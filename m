Return-Path: <SRS0=odJq=OX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7A3C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 21:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B47E208C3
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 21:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbeLNV5d (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Dec 2018 16:57:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:13309 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731020AbeLNV5d (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Dec 2018 16:57:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Dec 2018 13:57:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,354,1539673200"; 
   d="scan'208";a="118650661"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.154])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Dec 2018 13:57:31 -0800
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
Subject: [RFC PATCH v5 0/5] x86: Add vDSO exception fixup for SGX
Date:   Fri, 14 Dec 2018 13:57:24 -0800
Message-Id: <20181214215729.4221-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

__vdso_sgx_enter_enclave() gets another rewrite, this time to strip
it down to the bare minimum and explicitly break compliance with the
x86-64 ABI.  Feedback from v4 revealed that __vdso_sgx_enter_enclave()
would need to save (a lot) more than just the non-volatile GPRs to be
compliant with the x86-64 ABI, at which point breaking from the ABI
completely became much more palatable.

The non-standard ABI also solves the question of "which GPRs should be
marshalled to/from the enclave" by getting out of the way entirely and
letting userspace have free reign (except for RSP, which has a big ol'
DO NOT TOUCH sign on it).

[1] https://lkml.kernel.org/r/cda13cff-1a56-a40f-7d69-f0f1ab752f8e@fortanix.com


v1: https://lkml.kernel.org/r/20181205232012.28920-1-sean.j.christopherson@intel.com
v2: https://lkml.kernel.org/r/20181206221922.31012-1-sean.j.christopherson@intel.com
v3: https://lkml.kernel.org/r/20181210232141.5425-1-sean.j.christopherson@intel.com
v4: https://lkml.kernel.org/r/20181213213135.12913-1-sean.j.christopherson@intel.com
v5:
  - Strip down  __vdso_sgx_enter_enclave() so it only touches RSP and
    GPRs that are already collateral damage of ENCLU[EENTER/ERESUME].
  - Add a 16-byte reserved field to 'struct sgx_enclave_exception' so
    the struct can grow in a backwards compatible fashion.
  - Add a blurb at the end of the changelog for patch 1/5 explaining
    why the vDSO fixup macros look different than the equivalent kernel
    macros.

Sean Christopherson (5):
  x86/vdso: Add support for exception fixup in vDSO functions
  x86/fault: Add helper function to sanitize error code
  x86/fault: Attempt to fixup unhandled #PF on ENCLU before signaling
  x86/traps: Attempt to fixup exceptions in vDSO before signaling
  x86/vdso: Add __vdso_sgx_enter_enclave() to wrap SGX enclave
    transitions

 arch/x86/entry/vdso/Makefile             |  6 +-
 arch/x86/entry/vdso/extable.c            | 37 +++++++++
 arch/x86/entry/vdso/extable.h            | 29 +++++++
 arch/x86/entry/vdso/vdso-layout.lds.S    |  9 ++-
 arch/x86/entry/vdso/vdso.lds.S           |  1 +
 arch/x86/entry/vdso/vdso2c.h             | 58 ++++++++++++--
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 97 ++++++++++++++++++++++++
 arch/x86/include/asm/vdso.h              |  5 ++
 arch/x86/include/uapi/asm/sgx.h          | 18 +++++
 arch/x86/kernel/traps.c                  | 14 ++++
 arch/x86/mm/fault.c                      | 33 +++++---
 11 files changed, 284 insertions(+), 23 deletions(-)
 create mode 100644 arch/x86/entry/vdso/extable.c
 create mode 100644 arch/x86/entry/vdso/extable.h
 create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S

-- 
2.19.2

