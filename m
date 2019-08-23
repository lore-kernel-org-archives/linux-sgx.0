Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C9CC3A5A3
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 21:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1C7D21848
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 21:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfHWVwj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 17:52:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:26984 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392742AbfHWVwj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 17:52:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 14:52:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="203896868"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 23 Aug 2019 14:52:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH 3/3] x86/sgx: Fix whitespace damage in sgx_encl_page_alloc()
Date:   Fri, 23 Aug 2019 14:52:36 -0700
Message-Id: <20190823215236.8081-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190823215236.8081-1-sean.j.christopherson@intel.com>
References: <20190823215236.8081-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Fix a variety of recently introduced whitespace damage.  No functional
change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index ead9fb2d9b69..3ce7849f067b 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -133,7 +133,7 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 						 u64 secinfo_flags)
 {
 	struct sgx_encl_page *encl_page;
-       unsigned long prot;
+	unsigned long prot;
 
 	encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
 	if (!encl_page)
@@ -145,18 +145,17 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 	if (secinfo_flags & SGX_SECINFO_TCS)
 		encl_page->desc |= SGX_ENCL_PAGE_TCS;
 
+	prot = _calc_vm_trans(secinfo_flags, SGX_SECINFO_R, PROT_READ)  |
+	       _calc_vm_trans(secinfo_flags, SGX_SECINFO_W, PROT_WRITE) |
+	       _calc_vm_trans(secinfo_flags, SGX_SECINFO_X, PROT_EXEC);
 
-       prot = _calc_vm_trans(secinfo_flags, SGX_SECINFO_R, PROT_READ)  |
-	      _calc_vm_trans(secinfo_flags, SGX_SECINFO_W, PROT_WRITE) |
-	      _calc_vm_trans(secinfo_flags, SGX_SECINFO_X, PROT_EXEC);
-
-       /*
-	* TCS pages must always RW set for CPU access while the SECINFO
-	* permissions are *always* zero - the CPU ignores the user provided
-	* values and silently overwrites them with zero permissions.
-	*/
-       if ((secinfo_flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
-	       prot |= PROT_READ | PROT_WRITE;
+	/*
+	 * TCS pages must always RW set for CPU access while the SECINFO
+	 * permissions are *always* zero - the CPU ignores the user provided
+	 * values and silently overwrites them with zero permissions.
+	 */
+	if ((secinfo_flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
+		prot |= PROT_READ | PROT_WRITE;
 
 	/* Calculate maximum of the VM flags for the page. */
 	encl_page->vm_max_prot_bits = calc_vm_prot_bits(prot, 0);
-- 
2.22.0

