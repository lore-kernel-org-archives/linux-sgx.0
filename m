Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EE1C43461
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 052912084D
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgIDKpc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 06:45:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:43131 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729959AbgIDKpF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 06:45:05 -0400
IronPort-SDR: J6g9615pVo8nD7af9MwVj5nhGakrGQjZqvMsDnMLfc0aLbmQD3PFoinYoi0GcjKD0oVJdlBBx0
 3EoCG6eGguag==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="145455660"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="145455660"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 03:44:47 -0700
IronPort-SDR: ZT6lPFKmtnUsygAS3uxCHdHH20T7xUxePTNZSdGNM5/Z+B2iQy55lOf17KWoh9IkKtHZgjGgal
 BuKtYo38aJCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="283026273"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga007.fm.intel.com with ESMTP; 04 Sep 2020 03:44:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v37 0/6] x86/vdso: x86/sgx: Rework SGX vDSO API
Date:   Fri,  4 Sep 2020 03:44:31 -0700
Message-Id: <20200904104437.29555-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Rework __vdso_sgx_enter_enclave() to move all input/output params, except
for pass-through GPRs, into a single struct.  With the new struct, add
a pass-through param requested by Nathaniel[1], fix a long-standing nit
from Andy[2], and add a flags field to allow for future extensions.

 1. Add an opaque param to pass data from the runtime to its handler.
    https://lkml.kernel.org/r/CAOASepOFh-vOrNZEVDFrDSuHs+9GEzzpXUTG-fZMuyjWAkpRWw@mail.gmail.com

 2. Use a dedicated exit reason instead of using -EFAULT for "exception"
    (and effectively -EINTR for interrupts, too).
    https://lkml.kernel.org/r/90D05734-1583-4306-A9A4-18E4A1390F3B@amacapital.net

RFC->V1:
  - Drop the EXIT_ON_INTERRUPT patch. [Andy]
  - Fix the macro names in the assembly code. [Jarkko]
  - Move the leaf back into the exception sub-struct.  The leaf is fully
    redundant with SGX_SYNCHRONOUS_EXIT.
  - Add selftest support. [Jarkko]

Jarkko, I didn't address you comment about moving the vDSO kernel docs
comments to the .rst file because I have an question on that and didn't
want to hold this up.  But Intel's mail servers appear to be on the fritz,
so it might be a moot point...

Sean Christopherson (6):
  x86/vdso: x86/sgx: Explicitly force 8-byte CMP for detecting user
    handler
  x86/vdso: x86/sgx: Rework __vdso_sgx_enter_enclave() API
  x86/vdso: x86/sgx: Introduce dedicated SGX exit reasons for vDSO
  selftests/sgx: Update the SGX selftest to match the reworked vDSO API
  selftests/sgx: Sanity check the return value of the vDSO call
  selftests/sgx: Add a smoke test to ensure the user handler is invoked

 arch/x86/entry/vdso/vsgx_enter_enclave.S | 76 +++++++++++++-------
 arch/x86/include/uapi/asm/sgx.h          | 88 ++++++++++++++++--------
 tools/testing/selftests/sgx/call.S       | 10 +--
 tools/testing/selftests/sgx/main.c       | 61 ++++++++++++----
 tools/testing/selftests/sgx/main.h       |  2 +-
 5 files changed, 160 insertions(+), 77 deletions(-)

-- 
2.28.0

