Return-Path: <SRS0=MPu7=OW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0B6C65BAE
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Dec 2018 21:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 684E320811
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Dec 2018 21:31:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 684E320811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbeLMVbl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Dec 2018 16:31:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:43547 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbeLMVbl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Dec 2018 16:31:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 13:31:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,349,1539673200"; 
   d="scan'208";a="127709232"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.154])
  by fmsmga004.fm.intel.com with ESMTP; 13 Dec 2018 13:31:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: [RFC PATCH v4 0/5] x86: Add vDSO exception fixup for SGX
Date:   Thu, 13 Dec 2018 13:31:30 -0800
Message-Id: <20181213213135.12913-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Episode IV: The vDSO Strikes Back

After a brief detour into ioctl-based fixup, the vDSO implementation
is back.  Relative to v2 (the previous vDSO RFC), patch 4/4 once again
contains the vast majority of changes.

__vdso_sgx_enter_enclave() is now written entirely in straight assembly.
Implementing the expanded enclave ABI in inline assembly was an absolute
train wreck as GCC's contraints don't play nice with the full spectrum
of registers.  And I suspect the previous vDSO RFCs were likely broken
due to incorrect register clobbering (I never tested them end-to-end).

The exit_handler() concept proposed in v2 is gone.  I expect most SGX
libraries will directly call __vdso_sgx_enter_enclave(), at which point
the overhead of returning effectively boils down to restoring the
non-volatile registers, which is likely outweighed by the cost of the
retpoline call (to the handler) alone.  In other words, I doubt anyone
will actually use the exit_handler()...

...except for libraries that want to manipulate the untrusted stack,
i.e. force __vdso_sgx_enter_enclave() to treat RSP as volatile.  At that
point we're effectively maintaining two separate ABIs since the normal
ABI would be e.g. "RBP, RSP and the red zone must be preserved" vs. the
exit_handler() ABI's "RBP must be preserved".  And *if* we want to deal
with maintaining two ABIs, supporting the kernel's existing signal ABI
is a lot cleaner (from a kernel perspective) than polluting the vDSO.

v1: https://lkml.kernel.org/r/20181205232012.28920-1-sean.j.christopherson@intel.com
v2: https://lkml.kernel.org/r/20181206221922.31012-1-sean.j.christopherson@intel.com
v3: https://lkml.kernel.org/r/20181210232141.5425-1-sean.j.christopherson@intel.com
v4:
  - Back to vDSO
  - Implement __vdso_sgx_enter_enclave() directly in assembly
  - Modify effective enclave register ABI to follow x86-64 kernel ABI
  - Split __vdso_sgx_enter_enclave input into separate non-union params
  - Drop the exit_handler() concept

Sean Christopherson (5):
  x86/vdso: Add support for exception fixup in vDSO functions
  x86/fault: Add helper function to sanitize error code
  x86/fault: Attempt to fixup unhandled #PF on ENCLU before signaling
  x86/traps: Attempt to fixup exceptions in vDSO before signaling
  x86/vdso: Add __vdso_sgx_enter_enclave() to wrap SGX enclave
    transitions

 arch/x86/entry/vdso/Makefile             |   6 +-
 arch/x86/entry/vdso/extable.c            |  37 ++++++
 arch/x86/entry/vdso/extable.h            |  29 +++++
 arch/x86/entry/vdso/vdso-layout.lds.S    |   9 +-
 arch/x86/entry/vdso/vdso.lds.S           |   1 +
 arch/x86/entry/vdso/vdso2c.h             |  58 ++++++++--
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 136 +++++++++++++++++++++++
 arch/x86/include/asm/vdso.h              |   5 +
 arch/x86/include/uapi/asm/sgx.h          |  44 ++++++++
 arch/x86/kernel/traps.c                  |  14 +++
 arch/x86/mm/fault.c                      |  33 ++++--
 11 files changed, 349 insertions(+), 23 deletions(-)
 create mode 100644 arch/x86/entry/vdso/extable.c
 create mode 100644 arch/x86/entry/vdso/extable.h
 create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S

-- 
2.19.2

