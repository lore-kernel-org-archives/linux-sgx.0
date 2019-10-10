Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4508C4360C
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 22:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A34E6214E0
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 22:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfJJWzj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 18:55:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:20137 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfJJWzj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 18:55:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 15:55:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="197400447"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 10 Oct 2019 15:55:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 0/4] x86/sgx: Fix add page bugs
Date:   Thu, 10 Oct 2019 15:55:26 -0700
Message-Id: <20191010225530.26400-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Three bug fixes in the add page flow, along with a related enhancement.
Note, patch 4/4 is effectively a revert.

Sean Christopherson (4):
  x86/sgx: Pass EADD the kernel's virtual address for the source page
  x86/sgx: Check the validity of the source page address for EADD
  x86/sgx: Fix EEXTEND error handling
  x86/sgx: Drop mmap_sem before EEXTENDing an enclave page

 arch/x86/kernel/cpu/sgx/ioctl.c | 46 ++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 21 deletions(-)

-- 
2.22.0

