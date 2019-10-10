Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194E1ECE58D
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 22:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E834B214E0
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 22:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfJJWzj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
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
   d="scan'208";a="197400448"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 10 Oct 2019 15:55:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 1/4] x86/sgx: Pass EADD the kernel's virtual address for the source page
Date:   Thu, 10 Oct 2019 15:55:27 -0700
Message-Id: <20191010225530.26400-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191010225530.26400-1-sean.j.christopherson@intel.com>
References: <20191010225530.26400-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use the kernel's virtual address to reference the source page when
EADDing a page to the enclave.  gup() "does not guarantee that the page
exists in the user mappings", i.e. EADD can still fault and deadlock
due to mmap_sem contention if it consumes the userspace address.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index eeed919ed3e2..62965d003fda 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -328,16 +328,14 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 	if (ret < 1)
 		return ret;
 
-	__uaccess_begin();
-
 	pginfo.secs = (unsigned long)sgx_epc_addr(encl->secs.epc_page);
 	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
 	pginfo.metadata = (unsigned long)secinfo;
-	pginfo.contents = (unsigned long)src;
+	pginfo.contents = (unsigned long)kmap_atomic(src_page);
 
 	ret = __eadd(&pginfo, sgx_epc_addr(epc_page));
 
-	__uaccess_end();
+	kunmap_atomic((void *)pginfo.contents);
 	put_page(src_page);
 
 	return ret ? -EFAULT : 0;
-- 
2.22.0

