Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B717DC49ED7
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 10:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F37E214AF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 10:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbfIPKSQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 06:18:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:45632 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfIPKSQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 06:18:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 03:18:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="177001602"
Received: from sweber1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.40.159])
  by orsmga007.jf.intel.com with ESMTP; 16 Sep 2019 03:18:12 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v3 00/17] Fixes and updates for v23
Date:   Mon, 16 Sep 2019 13:17:46 +0300
Message-Id: <20190916101803.30726-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This patch set contains my fixes and updates for v23 except
sgx_alloc_page() changes that I will submit a bit later.

v3:
* Rebasing did not went right in the last version.
v2:
* Added the bug fix to not allow legitly BLOCKED pages to end up
  to the free page pool.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>

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

