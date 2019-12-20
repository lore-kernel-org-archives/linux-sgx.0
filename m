Return-Path: <SRS0=2o92=2K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3F7C3F68F
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Dec 2019 22:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D970206DA
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Dec 2019 22:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLTWzE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:55:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:34039 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfLTWzD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Dec 2019 17:55:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 14:55:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="366508438"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 20 Dec 2019 14:55:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 0/4] selftests/x86: x86/sgx: Minor selftest cleanup
Date:   Fri, 20 Dec 2019 14:54:57 -0800
Message-Id: <20191220225501.23476-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a .gitignore entry for the selftests and cleanup the includes to remove
some homebrewed definitions in sgx/defines.h.

Sean Christopherson (4):
  selftests/x86: Fix INCLUDES definition in SGX Makefile
  x86/sgx: Add missing linux/bits.h include in sgx/arch.h
  selftests/x86: Add .gitignore for SGX selftest
  selftests/x86: Remove redundant kernel include

 arch/x86/kernel/cpu/sgx/arch.h             |  1 +
 tools/testing/selftests/x86/sgx/.gitignore |  3 +++
 tools/testing/selftests/x86/sgx/Makefile   |  3 ++-
 tools/testing/selftests/x86/sgx/defines.h  | 22 ----------------------
 tools/testing/selftests/x86/sgx/main.c     |  2 --
 5 files changed, 6 insertions(+), 25 deletions(-)
 create mode 100644 tools/testing/selftests/x86/sgx/.gitignore

-- 
2.24.1

