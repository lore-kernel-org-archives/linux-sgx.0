Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03302FA372B
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA927218DE
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392109AbfJQDDq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 23:03:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:45377 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392047AbfJQDDq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 23:03:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 20:03:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="195026817"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 20:03:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v2? v2 00/14] selftests/x86/sgx: Improve tests
Date:   Wed, 16 Oct 2019 20:03:26 -0700
Message-Id: <20191017030340.18301-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The bulk of this series is comprised of the selftest portion of the vDSO
cleanup[*].  The big difference from the full vDSO series is to reuse as
much of the existing selftest code as possible.  There is still a bit of
homebrew code in defining the low level assertion macro, but much less so
than in the previous from-scratch version.

Cc'd Andy, who also happens to be a reviewer for the harness code, on the
off chance he has bandwidth to weigh in.

Tagged for_v2? to make it clear that this doesn't need to be rushed into
v23.

Passing case:

  TAP version 13
  1..4
  ok 1 test_sgx_basic: Passed
  ok 2 test_sgx_vdso: Passed
  ok 3 test_sgx_vdso_exit_handler: Passed
  ok 4 test_sgx_vdso_exception_handler: Passed
  # Pass 4 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0

Failing case:

  TAP version 13
  1..4
  not ok 1 Expected 'result (1234605616436508552) != MAGIC (1234605616436508552)' at main.c:324
  ok 2 test_sgx_vdso: Passed
  ok 3 test_sgx_vdso_exit_handler: Passed
  ok 4 test_sgx_vdso_exception_handler: Passed
  # Pass 3 Fail 1 Xfail 0 Xpass 0 Skip 0 Error 0


[*] https://patchwork.kernel.org/cover/11178771/

Sean Christopherson (14):
  selftests/x86/sgx: Fix a benign linker warning
  selftests/x86/sgx: Use getauxval() to retrieve the vDSO base address
  selftests/x86/sgx: Sanitize the types for sgx_vdso_call()'s input
    params
  selftests/x86/sgx: Mark helper functions as static
  selftests/x86/sgx: Move vDSO setup to a helper function
  selftests/x86/sgx: Move individual tests into helper functions
  selftests/x86/sgx: Use standard helper function to signal pass/fail
  selftests/harness: Move operator macros to their own header file
  selftests/x86/sgx: Use kselftest operators to check test results
  selftests/x86/sgx: Handle setup failures via kselftest assertions
  selftests/x86/sgx: Add a check on the vDSO exception reporting
    mechanism
  selftests/x86/sgx: Add test of vDSO with basic exit handler
  selftests/x86/sgx: Add check to verify exit handler stack alignment
  selftests/x86/sgx: Add test for exception behavior with exit handler

 Documentation/dev-tools/kselftest.rst         |   9 +-
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/kselftest_harness.h   | 246 +---------
 tools/testing/selftests/kselftest_operators.h | 255 +++++++++++
 tools/testing/selftests/x86/sgx/Makefile      |   2 +-
 tools/testing/selftests/x86/sgx/defines.h     |   7 +
 tools/testing/selftests/x86/sgx/main.c        | 426 +++++++++++-------
 tools/testing/selftests/x86/sgx/sgx_call.h    |   3 +-
 8 files changed, 541 insertions(+), 408 deletions(-)
 create mode 100644 tools/testing/selftests/kselftest_operators.h

-- 
2.22.0

