Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED674C74A5B
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC0B02084B
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbfGKQQ1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 12:16:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:37842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbfGKQQ1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 12:16:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 09:16:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="177213535"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga002.jf.intel.com with ESMTP; 11 Jul 2019 09:16:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v21 0/2] x86/sgx: Use SRCU and mmu_notifier
Date:   Thu, 11 Jul 2019 09:16:23 -0700
Message-Id: <20190711161625.15786-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add SRCU support in a standalone patch.  I included the mmu_notifier patch
as well so that you can compare approaches without having to wait on me
for additional input.

Sean Christopherson (2):
  x86/sgx: Use SRCU to protect mm_list during reclaim
  x86/sgx: Use mmu_notifier.release() instead of per-vma refcounting

 arch/x86/Kconfig                      |   2 +
 arch/x86/kernel/cpu/sgx/driver/main.c |  60 +++++----
 arch/x86/kernel/cpu/sgx/encl.c        | 182 +++++++++++++-------------
 arch/x86/kernel/cpu/sgx/encl.h        |  12 +-
 arch/x86/kernel/cpu/sgx/reclaim.c     |  71 ++++------
 5 files changed, 158 insertions(+), 169 deletions(-)

-- 
2.22.0

