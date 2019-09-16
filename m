Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04ABC49ED7
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D044A214AF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfIPEPh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:15:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:16475 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEPh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:15:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:15:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387076121"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:15:34 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 15/17] x86/sgx: sgx_vma_access(): Do not return -ECANCELED on invalid TCS pages
Date:   Mon, 16 Sep 2019 07:14:15 +0300
Message-Id: <20190916041417.12533-16-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When validating a TCS page one should consider the man page of ptrace
(man 2 ptrace):

"request is invalid, or an attempt was made to read from or write to an
invalid area in the tracer's or the tracee's memory, or there was a
word-alignment violation, or an invalid signal was specified during a
restart request."

Thus, returning -ECANCELED is not right thing to do.

Instead, return -EIO when TCS validation fails. In effect, this renders
out the validation code. Remove SGX_ENCL_PAGE_TCS as it is no longer
used for anything.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c  | 16 ++--------------
 arch/x86/kernel/cpu/sgx/encl.h  |  2 --
 arch/x86/kernel/cpu/sgx/ioctl.c |  3 ---
 3 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 1c1fbc95be33..66762b9c1517 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -352,14 +352,9 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
 static int sgx_edbgrd(struct sgx_encl *encl, struct sgx_encl_page *page,
 		      unsigned long addr, void *data)
 {
-	unsigned long offset;
+	unsigned long offset = addr & ~PAGE_MASK;
 	int ret;
 
-	offset = addr & ~PAGE_MASK;
-
-	if ((page->desc & SGX_ENCL_PAGE_TCS) &&
-	    offset > offsetof(struct sgx_tcs, gs_limit))
-		return -ECANCELED;
 
 	ret = __edbgrd(sgx_epc_addr(page->epc_page) + offset, data);
 	if (ret)
@@ -371,16 +366,9 @@ static int sgx_edbgrd(struct sgx_encl *encl, struct sgx_encl_page *page,
 static int sgx_edbgwr(struct sgx_encl *encl, struct sgx_encl_page *page,
 		      unsigned long addr, void *data)
 {
-	unsigned long offset;
+	unsigned long offset = addr & ~PAGE_MASK;
 	int ret;
 
-	offset = addr & ~PAGE_MASK;
-
-	/* Writing anything else than flags will cause #GP */
-	if ((page->desc & SGX_ENCL_PAGE_TCS) &&
-	    offset != offsetof(struct sgx_tcs, flags))
-		return -ECANCELED;
-
 	ret = __edbgwr(sgx_epc_addr(page->epc_page) + offset, data);
 	if (ret)
 		return -EIO;
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 95e5713a50ad..c7abca1fcb9d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -19,7 +19,6 @@
 
 /**
  * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
- * %SGX_ENCL_PAGE_TCS:			The page is a TCS page.
  * %SGX_ENCL_PAGE_RECLAIMED:		The page is in the process of being
  *					reclaimed.
  * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version Array
@@ -30,7 +29,6 @@
  * the SECS page.
  */
 enum sgx_encl_page_desc {
-	SGX_ENCL_PAGE_TCS		= BIT(0),
 	/* Bits 11:3 are available when the page is not swapped. */
 	SGX_ENCL_PAGE_RECLAIMED		= BIT(3),
 	SGX_ENCL_PAGE_VA_OFFSET_MASK	= GENMASK_ULL(11, 3),
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index e57dda38513b..cc77728af7da 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -126,9 +126,6 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 	encl_page->desc = addr;
 	encl_page->encl = encl;
 
-	if (secinfo_flags & SGX_SECINFO_TCS)
-		encl_page->desc |= SGX_ENCL_PAGE_TCS;
-
 	prot = _calc_vm_trans(secinfo_flags, SGX_SECINFO_R, PROT_READ)  |
 	       _calc_vm_trans(secinfo_flags, SGX_SECINFO_W, PROT_WRITE) |
 	       _calc_vm_trans(secinfo_flags, SGX_SECINFO_X, PROT_EXEC);
-- 
2.20.1

