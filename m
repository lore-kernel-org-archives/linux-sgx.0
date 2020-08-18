Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC4FC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 04:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 100472078D
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 04:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgHREYH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 00:24:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:16707 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgHREYH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 00:24:07 -0400
IronPort-SDR: 0tBwuaWEp3lq7b2XcTYOU+F5wUncoWNglI6ikqPmNn/Xyd/0DkU/2op5s3g/3KoiIf+rvfl4mX
 Rg2NhyqjIBZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="219156472"
X-IronPort-AV: E=Sophos;i="5.76,326,1592895600"; 
   d="scan'208";a="219156472"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 21:24:06 -0700
IronPort-SDR: U55WoiMVCW8YY9kfpJFk+gkw5yiXTjyYBGSxPNEtuQ0/mNaRKxQPFZWbaXg/ggk86efdknKXRX
 jhX/rD8VSO1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,326,1592895600"; 
   d="scan'208";a="334270261"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Aug 2020 21:24:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [RFC PATCH 0/4] x86/vdso: x86/sgx: Rework SGX vDSO API
Date:   Mon, 17 Aug 2020 21:24:01 -0700
Message-Id: <20200818042405.12871-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Rework __vdso_sgx_enter_enclave() to move all input/output params, except
for pass-through GPRs, into a single struct.  With the new struct, add
two new features (requested by Nathaniel and Jethro), and fix a
long-standing nit (from Andy).

 1. Add an opaque param to pass data from the runtime to its handler.
    https://lkml.kernel.org/r/CAOASepOFh-vOrNZEVDFrDSuHs+9GEzzpXUTG-fZMuyjWAkpRWw@mail.gmail.com

 2. Allow the runtime to exit the vDSO on interrupts, e.g. for context
    switching when doing M:N scheduling of enclave threads.
    https://lkml.kernel.org/r/dcebec2e-ea46-48ec-e49b-292b10282373@fortanix.com

 3. Use a dedicated exit reason instead of using -EFAULT for "exception"
    (and effectively -EINTR for interrupts, too).
    https://lkml.kernel.org/r/90D05734-1583-4306-A9A4-18E4A1390F3B@amacapital.net

Patch 1 is a bug fix I found by inspection when reworking the code.

Reworking so much of the code this late in the game is a bit scary, but
the alternative is massive param lists for both the vDSO and the handler,
especially if we add both a flags param and an opaque pointer.  And IMO,
the result is also a tiny bit cleaner than what we have today, even
without adding @flags and @opaque.

typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
                                        unsigned long rdx, unsigned int leaf,
                                        unsigned long r8,  unsigned long r9,
                                        struct sgx_enclave_run *r);

typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
                                          long ursp, long r8, long r9,
                                          struct sgx_enclave_run *r);

vs.

typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
                                        unsigned long rdx, unsigned int leaf,
                                        unsigned long r8,  unsigned long r9,
                                        void *tcs,
                                        struct sgx_enclave_exception *e,
                                        sgx_enclave_exit_handler_t handler,
                                        unsigned long flags,
                                        unsigned long opaque);

typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
                                          long ursp, long r8, long r9,
                                          void *tcs, int ret,
                                          struct sgx_enclave_exception *e,
                                          unsigned long opaque);

Sean Christopherson (4):
  x86/vdso: x86/sgx: Explicitly force 8-byte CMP for detecting user
    handler
  x86/vdso: x86/sgx: Rework __vdso_sgx_enter_enclave() API
  x86/vdso: x86/sgx: Introduce dedicated SGX exit reasons for vDSO
  x86/vdso: x86/sgx: Allow the user to exit the vDSO loop on interrupts

 arch/x86/entry/vdso/vsgx_enter_enclave.S | 94 +++++++++++++++++------
 arch/x86/include/uapi/asm/sgx.h          | 96 ++++++++++++++++--------
 2 files changed, 135 insertions(+), 55 deletions(-)

-- 
2.28.0

