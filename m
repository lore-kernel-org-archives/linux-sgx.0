Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A74C48BE5
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Jun 2021 10:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6881C61426
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Jun 2021 10:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhFOKTm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Jun 2021 06:19:42 -0400
Received: from mga06.intel.com ([134.134.136.31]:54852 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhFOKTm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Jun 2021 06:19:42 -0400
IronPort-SDR: zJvxWL3SMzkKDtL/UTjKqMOjFpoqv/Zv9MGM8erslzeyqmvn7lXsymXXYm+nFFhLicjdtf9p51
 Ay6m3iDVYo9A==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="267110232"
X-IronPort-AV: E=Sophos;i="5.83,275,1616482800"; 
   d="scan'208";a="267110232"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 03:17:37 -0700
IronPort-SDR: 0jGvotN3Aeu01qs4h7Jw8N0+w6kDLY+14kGthGCf+lfI89+P2rMfbVL+lz2RWQSfbgdx9SHip3
 oWzbeM7Olieg==
X-IronPort-AV: E=Sophos;i="5.83,275,1616482800"; 
   d="scan'208";a="421079165"
Received: from tmonfort-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.223.245])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 03:17:35 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, bp@alien8.de, seanjc@google.com,
        jarkko@kernel.org, dave.hansen@intel.com, tglx@linutronix.de,
        mingo@redhat.com, Yang Zhong <yang.zhong@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH] x86/sgx: Add missing xa_destroy() when virtual EPC is destroyed
Date:   Tue, 15 Jun 2021 22:16:39 +1200
Message-Id: <20210615101639.291929-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

xa_destroy() needs to be called to destroy virtual EPC's page arra
before calling kfree() to free the virtual EPC.  Currently it is not
calaled.  Add the missing xa_destroy() to fix.

Fixes: 540745ddbc70 ("x86/sgx: Introduce virtual EPC for use by KVM guests")
Tested-by: Yang Zhong <yang.zhong@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/virt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 6ad165a5c0cc..64511c4a5200 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -212,6 +212,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 		list_splice_tail(&secs_pages, &zombie_secs_pages);
 	mutex_unlock(&zombie_secs_pages_lock);
 
+	xa_destroy(&vepc->page_array);
 	kfree(vepc);
 
 	return 0;
-- 
2.31.1

