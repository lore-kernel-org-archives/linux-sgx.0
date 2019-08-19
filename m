Return-Path: <SRS0=kvvX=WP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C9BC3A5A0
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 15:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9303F2082C
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 15:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfHSPZz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Aug 2019 11:25:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:9895 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfHSPZz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Aug 2019 11:25:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 08:25:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="180393027"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.125])
  by orsmga003.jf.intel.com with ESMTP; 19 Aug 2019 08:25:50 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christpherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH 1/5] x86/sgx: Document permission handling better
Date:   Mon, 19 Aug 2019 18:25:40 +0300
Message-Id: <20190819152544.7296-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The way permissions are managed inside the driver is not trivial and
intuitive. The non-obvious parts were not properly remarked in the
source code. This patch refines them a bit.

Cc: Sean Christopherson <sean.j.christpherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 9b784a061a47..64d3286f3324 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -259,7 +259,10 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 		return ERR_PTR(-ENOMEM);
 	encl_page->desc = addr;
 	encl_page->encl = encl;
+
+	/* Calculate maximum of the VM flags for the page. */
 	encl_page->vm_prot_bits = calc_vm_prot_bits(prot, 0);
+
 	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
 				encl_page);
 	if (ret) {
@@ -640,11 +643,15 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 
 	data = kmap(data_page);
 
+	/* Set prot bits matching to the SECINFO permissions. */
 	prot = _calc_vm_trans(secinfo.flags, SGX_SECINFO_R, PROT_READ)  |
 	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_W, PROT_WRITE) |
 	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_X, PROT_EXEC);
 
-	/* TCS pages need to be RW in the PTEs, but can be 0 in the EPCM. */
+	/* TCS pages must always RW set for CPU access while the SECINFO
+	 * permissions are *always* zero - the CPU ignores the user provided
+	 * values and silently overwrites zero permissions.
+	 */
 	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
 		prot |= PROT_READ | PROT_WRITE;
 
-- 
2.20.1

