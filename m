Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275D7FA372E
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 18:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F18572067D
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 18:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394280AbfJPShv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:37:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:22394 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394272AbfJPSht (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 14:37:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 11:37:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="397258414"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 16 Oct 2019 11:37:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 v3 01/12] x86/sgx: Pass EADD the kernel's virtual address for the source page
Date:   Wed, 16 Oct 2019 11:37:34 -0700
Message-Id: <20191016183745.8226-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191016183745.8226-1-sean.j.christopherson@intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
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
index bb8fcc4f91e3..2dd0eceee111 100644
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

