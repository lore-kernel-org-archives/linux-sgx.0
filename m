Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A990C49ED7
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2613120873
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbfIPEO1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:14:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:52070 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEO1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:14:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:14:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387075893"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:14:24 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 00/17] v23 updates
Date:   Mon, 16 Sep 2019 07:14:00 +0300
Message-Id: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

My flush of updates for v23. Contains a bunch of clean ups and bug
fixes with the main focus on the page reclaimer. The main goal has
been to disclose all the other possibilities for failure after
ENCLS[EBLOCK] other than EPCM conflict when the whole EPC is
invalidated.

Jarkko Sakkinen (17):
  selftest/x86/sgx: Remove encl_piggy.h
  x86/sgx: Clean up internal includes
  x86/sgx: Write backing storage only if EWB is successful
  x86/sgx: Rename 'j' as 'cnt' in sgx_reclaim_pages()
  x86/sgx: Turn encls_failed() as inline function
  x86/sgx: Move sgx_einit() to encls.c
  x86/sgx: Remove pages in sgx_reclaimer_write()
  x86/sgx: Calculate page index in sgx_reclaimer_write()
  x86/sgx: Move SGX_ENCL_DEAD check to sgx_reclaimer_write()
  x86/sgx: Free VA slot when the EWB flow fails
  x86/sgx: Call sgx_encl_destroy() when the EWB flow fails
  x86/sgx: Open code sgx_reclaimer_get() and sgx_reclaimer_put()
  x86/sgx: Introduce sgx_can_reclaim()
  x86/sgx: Replace section->free_cnt with a global sgx_nr_free_pages
  x86/sgx: sgx_vma_access(): Do not return -ECANCELED on invalid TCS
    pages
  x86/sgx: Introduce sgx_encl_get_backing()
  x86/sgx: Fix pages in the BLOCKED state ending up to the free pool

 arch/x86/kernel/cpu/sgx/driver.c             |   2 +
 arch/x86/kernel/cpu/sgx/driver.h             |   3 -
 arch/x86/kernel/cpu/sgx/encl.c               | 104 +++----
 arch/x86/kernel/cpu/sgx/encl.h               |  23 +-
 arch/x86/kernel/cpu/sgx/encls.c              |  54 +++-
 arch/x86/kernel/cpu/sgx/encls.h              |  23 +-
 arch/x86/kernel/cpu/sgx/ioctl.c              |   5 +-
 arch/x86/kernel/cpu/sgx/main.c               |  64 +---
 arch/x86/kernel/cpu/sgx/reclaim.c            | 299 +++++++++----------
 arch/x86/kernel/cpu/sgx/sgx.h                |   6 +-
 tools/testing/selftests/x86/sgx/encl_piggy.h |  14 -
 tools/testing/selftests/x86/sgx/main.c       |   1 -
 12 files changed, 276 insertions(+), 322 deletions(-)
 delete mode 100644 tools/testing/selftests/x86/sgx/encl_piggy.h

-- 
2.20.1

