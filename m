Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848CEC43217
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 20:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbiD1UO4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbiD1UOz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 16:14:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F053BF951
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 13:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651176700; x=1682712700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FjVvWUklc8U0tgSt4/FdkYDQfKTwavQNkbDD7Ucz8BA=;
  b=i6XBN8K+wUgyBlmGqZPv33Dj0MfTd86IlYZygYnH+zT5UL33xSbNrNN0
   r7smuL/cMlXepRG3q5VIFb4GA0X7DEEV6BUYOZbwdfqiFjStUPVTw6j5M
   nkSyrGcTHwjykln3mlz6Q36p3t+kZ6C4WzlIFOWxwytEh6xR+oJIlGpOo
   zal0+blMI4KrqFIuvmwEuOq0iIn8hphEfyYVXHZFXE/B1mXpfkDjR5Kaj
   EZVSKMByx4GDioa9oqcEo3/KjYD0CToagpr3cpUSdRfOJj2YG+T23payO
   QbT6QDsRIOrLyLOvIdiAWNg4ehkDkAgEc9OHYy3AO6AqziA5xEjCcAnBS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246324263"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="246324263"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:11:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="514458611"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:11:32 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Subject: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on ENCLS[ELDU] failure
Date:   Thu, 28 Apr 2022 13:11:24 -0700
Message-Id: <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651171455.git.reinette.chatre@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
after faulting the enclave page") frees the backing storage
after it becomes unneeded due to the data from it being
loaded back into the EPC (Enclave Page Cache).

The backing storage is freed after running ENCLS[ELDU],
whether ENCLS[ELDU] succeeded or not. If ENCLS[ELDU]
thus failed then the data within that page is lost.

Exit with error without removing the backing storage if
it could not be restored to the enclave.

Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 1a2cbe44b8d9..e5d2661800ac 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -81,6 +81,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 			ENCLS_WARN(ret, "ELDU");
 
 		ret = -EFAULT;
+		kunmap_atomic(pcmd_page);
+		kunmap_atomic((void *)(unsigned long)pginfo.contents);
+		sgx_encl_put_backing(&b, false);
+		return ret;
 	}
 
 	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
-- 
2.25.1

