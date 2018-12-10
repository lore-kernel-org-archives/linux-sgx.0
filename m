Return-Path: <SRS0=QEGF=OT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FAFC04EB8
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8B132081F
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:21:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8B132081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbeLJXV6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Dec 2018 18:21:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:11277 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbeLJXV6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Dec 2018 18:21:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2018 15:21:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,340,1539673200"; 
   d="scan'208";a="117684766"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.154])
  by orsmga001.jf.intel.com with ESMTP; 10 Dec 2018 15:21:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: [RFC PATCH v3 0/4] x86: Add exception fixup for SGX ENCLU
Date:   Mon, 10 Dec 2018 15:21:37 -0800
Message-Id: <20181210232141.5425-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This is effectively v3 of the "x86: Add vDSO exception fixup for SGX"
series, but as you might of noticed, there are no vDSO changes here.

Andy's comment on Spectre/retpoline[1] and Jethro's comment on making
the vDSO as barebones as possible[2] got me wondering if we could let
userspace dynamically set the "return" target of the SGX vDSO function,
taking advantage of the fact that most (all?) SGX processes will have a
single entry point for all enclaves.

The initial idea was to make __vdso_sgx_enter_enclave() a barebones
"function" consisting of ENCLU and UD2.  SGX would provide an IOCTL via
/dev/sgx that could be used to patch the UD2 in the current vDSO image
to a JMP rel32, with rel32 pointing at an address provided by the
user.  Aside from the issues of rel32 in a 64-bit memory space,
patching the vDSO image added a lot of overhead just so that the kernel
could know the address of ENCLU.

At that point I realized it's a hell of a lot easier to simply provide
an IOCTL via /dev/sgx that allows userspace to register a per-process
ENCLU exception handler.  At a high level, the basic idea is the same
as the vDSO approach: provide a hardcoded fixup handler for ENCLU and
attempt to fixup select unhandled exceptions that occurred in user code.

Pros:
  - No vDSO function.
  - Minimal userspace changes.
  - Smaller ABI, i.e. less bikeshedding (fingers crossed).
  - Kernel doesn't prevent userspace from doing stupid things, e.g.
    modifying the process' stack from within the enclave.
  - Kernel can proactively enforce the ENCLU handler as the only
    officialy supported ABI for enclave exception handling.

Cons:
  - Userspace can only register a single ENCLU handler per process.
  - ABI is more esoteric than a standard function call.


This series is based on Jarkko's current master branch, which moves all
of the SGX code into arch/x86.  The full code can be found here:

https://github.com/sean-jc/linux/tree/2538adcece15447b988d93bf677af48073c7d219

I have not actually tested this *exact* commit beyond compiling as I do
not know the health status of Jarkko's code.  To test, I cherry-picked
the patches into an older stable version of the code.  Git was able to
handle the file renaming.

v1: https://lkml.kernel.org/r/20181205232012.28920-1-sean.j.christopherson@intel.com
v2: https://lkml.kernel.org/r/20181206221922.31012-1-sean.j.christopherson@intel.com
v3:
  - Replace the vDSO fixup with SGX specific fixup.
  - Patches 2/4 and 3/4 are essentially identical, the only difference
    being the name of the function that is called.  The changelogs for
    these patches still need a lot of attention.

[1] https://lkml.kernel.org/r/CALCETrVBR+2HjTqX=W4r9GOq69Xg36v4gmCKqK0wUjzAqBJnrw@mail.gmail.com
[2] https://lkml.kernel.org/r/f595c046-682c-0d4a-ce68-44d4634cedf2@fortanix.com

Sean Christopherson (4):
  x86/sgx: Add a per-mm ENCLU exception fixup handler
  x86/fault: Attempt to fixup unhandled #PF on ENCLU before signaling
  x86/traps: Attempt to fixup exceptions in vDSO before signaling
  x86/sgx: Add an SGX IOCTL to register a per-mm ENCLU exception handler

 arch/x86/include/asm/mmu.h             |  4 ++++
 arch/x86/include/asm/sgx.h             | 13 +++++++++++++
 arch/x86/include/uapi/asm/sgx.h        | 23 ++++++++++++++++++-----
 arch/x86/kernel/cpu/sgx/driver/encl.c  |  6 ++++++
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 20 ++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/main.c         | 18 ++++++++++++++++++
 arch/x86/kernel/traps.c                | 15 +++++++++++++++
 arch/x86/mm/fault.c                    |  7 +++++++
 8 files changed, 101 insertions(+), 5 deletions(-)

-- 
2.19.2

