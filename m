Return-Path: <SRS0=RnOm=7L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A88C433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54E1B2073B
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgE2RyM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 May 2020 13:54:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:51589 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbgE2RyL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 May 2020 13:54:11 -0400
IronPort-SDR: Q2dqvHu8nnzDEbY7EFhSbiYSdLnU8d0F42EqhxaBn3GhceRyMZUqhKw2EGEiSig+sw+OqMhEpa
 aeloo0gqWGwg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:54:08 -0700
IronPort-SDR: 0CQ3/KvTDlB4hcGLt9kdb3IfFn6GdMYXe3rQbGFwkR+c/HaV6z+P3X/MkuaTerGxVQt1ejiQlG
 qBxR5HKfY5zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="271292318"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 29 May 2020 10:54:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v31 0/6]  x86/sgx: Misc fixes for v31
Date:   Fri, 29 May 2020 10:54:01 -0700
Message-Id: <20200529175407.2109-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

One bug fix and a variety of cleanups that apply on top of your current
master, commit b625c3d1370ca ("x86/sgx: Update MAINTAINERS").

Sean Christopherson (6):
  x86/sgx: Fix inadvertant early return from sgx_ioctl()
  x86/sgx: Remove unnecessary globals after merging reclaim.c into
    main.c
  x86/sgx: Rename sgx_free_page() to sgx_free_epc_page()
  x86/sgx: Replace "grab" with "alloc" in VA page helper
  x86/sgx: Update stale comment in EPC page allocators
  x86/sgx: Drop the message that fires when there are too many EPC
    sections

 arch/x86/kernel/cpu/sgx/encl.c  | 16 +++++++-------
 arch/x86/kernel/cpu/sgx/encl.h  |  2 +-
 arch/x86/kernel/cpu/sgx/ioctl.c | 10 ++++-----
 arch/x86/kernel/cpu/sgx/main.c  | 39 +++++++++++++--------------------
 arch/x86/kernel/cpu/sgx/sgx.h   |  5 +----
 5 files changed, 30 insertions(+), 42 deletions(-)

-- 
2.26.0

