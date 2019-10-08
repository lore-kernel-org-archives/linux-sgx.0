Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A0CC4360C
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAAAA206C2
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfJHEqP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:8175 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfJHEqP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566487"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 00/16] x86/vdso: sgx: Major vDSO cleanup
Date:   Mon,  7 Oct 2019 21:45:57 -0700
Message-Id: <20191008044613.12350-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The main purpose of this series is to implement feedback from the original
RFC to expand the vDSO[*] that went unaddressed before the expanded
function was rushed into v21.

The other half of the series is to overhaul the selftest to actually test
the exit handler variation of the vDSO, with a bunch of prework to add an
assertion framework to standardize the various assertions in the test and
improve the readability of the code.

The basic ideas for the exit handler subtests are from Cedric's original
RFC, but rewritten from scratch to take advantage of the new assertion
framework.  I haven't yet implemented single-step subtest, ideally that
too will get done before v23.

[*] https://lkml.kernel.org/r/20190426210017.GA24467@linux.intel.com

Sean Christopherson (16):
  x86/vdso: sgx: Drop the pseudocode "documentation"
  x86/vdso: sgx: Do not use exception info to pass success/failure
  x86/vdso: sgx: Rename the enclave exit handler typedef
  x86/vdso: sgx: Move enclave exit handler declaration to UAPI header
  x86/vdso: sgx: Add comment regarding kernel-doc shenanigans
  x86/vdso: sgx: Rewrite __vdso_sgx_enter_enclave() function comment
  selftests/x86: Fix linker warning in SGX selftest
  selftests/x86/sgx: Use getauxval() to retrieve the vDSO base address
  selftests/x86/sgx: Add helper function and macros to assert results
  selftests/x86/sgx: Handle setup failures via test assertions
  selftests/x86/sgx: Sanitize the types for sgx_call()'s input params
  selftests/x86/sgx: Move existing sub-test to a separate helper
  selftests/x86/sgx: Add a test of the vDSO exception reporting
    mechanism
  selftests/x86/sgx: Add test of vDSO with basic exit handler
  selftests/x86/sgx: Add sub-test for exception behavior with exit
    handler
  x86/vdso: sgx: Rework __vdso_sgx_enter_enclave() to prefer "no
    callback"

 arch/x86/entry/vdso/vsgx_enter_enclave.S  | 228 +++++++------
 arch/x86/include/uapi/asm/sgx.h           |  18 +
 tools/testing/selftests/x86/sgx/Makefile  |   2 +-
 tools/testing/selftests/x86/sgx/defines.h |   6 +
 tools/testing/selftests/x86/sgx/main.c    | 384 ++++++++++++++--------
 5 files changed, 387 insertions(+), 251 deletions(-)

-- 
2.22.0

