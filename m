Return-Path: <SRS0=9G3N=2L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EADC43603
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 596EB2072B
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfLUAb7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Dec 2019 19:31:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:9723 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfLUAb6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Dec 2019 19:31:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 16:31:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="267658115"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Dec 2019 16:31:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 0/4] x86/sgx: Reclaim bug fix and cleanup
Date:   Fri, 20 Dec 2019 16:31:52 -0800
Message-Id: <20191221003156.27236-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

One bug fix in the SECS reclaim path and loosely related cleanup.

Sean Christopherson (4):
  x86/sgx: Put SECS backing iff retrieving the backing succeeds
  x86/sgx: Use goto to handle sgx_encl_get_backing() failure in SECS
    flows
  x86/sgx: Drop unused @encl parameter from __sgx_encl_ewb()
  x86/sgx: Pre-calculate VA slot virtual address in sgx_encl_ewb()

 arch/x86/kernel/cpu/sgx/reclaim.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

-- 
2.24.1

