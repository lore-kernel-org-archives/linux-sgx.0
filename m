Return-Path: <SRS0=OrTC=YP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1F1CA9EA0
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 22:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9A452075A
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 22:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389589AbfJVWtX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Oct 2019 18:49:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:58904 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732738AbfJVWtX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Oct 2019 18:49:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 15:49:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,218,1569308400"; 
   d="scan'208";a="372690699"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 22 Oct 2019 15:49:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 0/3] x86/sgx: More cleanup for v23
Date:   Tue, 22 Oct 2019 15:49:19 -0700
Message-Id: <20191022224922.28144-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Two small enchancements, and a rework of the sgx_free_page() split that
was sent in a previous series.

Sean Christopherson (3):
  x86/sgx: Update the free page count in a single operation
  x86/sgx: Do not add in-use EPC page to the free page list
  x86/sgx: Move reclaim logic out of sgx_free_page()

 arch/x86/kernel/cpu/sgx/encl.c    |  3 ++-
 arch/x86/kernel/cpu/sgx/main.c    | 36 +++++++++----------------------
 arch/x86/kernel/cpu/sgx/reclaim.c | 32 +++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h     |  3 ++-
 4 files changed, 46 insertions(+), 28 deletions(-)

-- 
2.22.0

