Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B586C433DB
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 04:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 317946157F
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 04:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhCSEG7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Mar 2021 00:06:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:60155 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233640AbhCSEGc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Mar 2021 00:06:32 -0400
IronPort-SDR: Tets64KEt0y6m+PyjoWctdcp4+m4QcTe3nXx7q80+vFHfK7KXHnYtXi+tfuh79/SzGeURJDur+
 8S/kKWntT/gw==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="186471728"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="186471728"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 21:06:31 -0700
IronPort-SDR: kbyxE+5AtLjLyENpcbJzxr0GaaK7xtFZSCp0v84pClHqUm20XPQzlBZxAol9cSKoMoPuDVmtCd
 YYRP7gAdE+uQ==
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="406620937"
Received: from dharorix-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.226])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 21:06:29 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     bp@alien8.de, jarkko@kernel.org, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH] x86/sgx: Avoid returning NULL in __sgx_alloc_epc_page()
Date:   Fri, 19 Mar 2021 17:06:02 +1300
Message-Id: <20210319040602.178558-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Below kernel bug happened when running simple SGX application when EPC
is under pressure.  The root cause is with commit 5b8719504e3a
("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()"),
__sgx_alloc_epc_page() returns NULL when there's no free EPC page can be
allocated, while old behavior was it always returned ERR_PTR(-ENOMEM) in
such case.

Fix by directly returning the page if __sgx_alloc_epc_page_from_node()
allocates a valid page in fallback to non-local allocation, and always
returning ERR_PTR(-ENOMEM) if no EPC page can be allocated.

[  253.474764] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  253.500101] #PF: supervisor write access in kernel mode
[  253.525462] #PF: error_code(0x0002) - not-present page
...
[  254.102041] Call Trace:
[  254.126699]  sgx_ioc_enclave_add_pages+0x241/0x770
[  254.151305]  sgx_ioctl+0x194/0x4b0
[  254.174976]  ? handle_mm_fault+0xd0/0x260
[  254.198470]  ? do_user_addr_fault+0x1ef/0x570
[  254.221827]  __x64_sys_ioctl+0x91/0xc0
[  254.244546]  do_syscall_64+0x38/0x90
[  254.266728]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  254.289232] RIP: 0033:0x7fdc4cf4031b
...
[  254.711480] CR2: 0000000000000008
[  254.735494] ---[ end trace 970dce6d4cdf7f64 ]---
[  254.759915] RIP: 0010:sgx_alloc_epc_page+0x46/0x152
...

Fixes: 5b8719504e3a("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index fe26e7e91c25..7105e34da530 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -508,10 +508,10 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 
 		page = __sgx_alloc_epc_page_from_node(nid);
 		if (page)
-			break;
+			return page;
 	}
 
-	return page;
+	return ERR_PTR(-ENOMEM);
 }
 
 /**
-- 
2.30.2

