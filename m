Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2984BC43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03C5621927
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388638AbeLUXPd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:15:33 -0500
Received: from mga06.intel.com ([134.134.136.31]:16623 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730803AbeLUXPd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:15:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:15:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338726"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:15:25 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v18 22/25] x86/sgx: ptrace() support for the SGX driver
Date:   Sat, 22 Dec 2018 01:11:51 +0200
Message-Id: <20181221231154.6120-23-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add VMA callbacks for ptrace() that can be used with debug enclaves.
With debug enclaves data can be read and write the memory word at a time
by using ENCLS(EDBGRD) and ENCLS(EDBGWR) leaf instructions.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/vma.c | 109 +++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/driver/vma.c b/arch/x86/kernel/cpu/sgx/driver/vma.c
index da7b4080a4a6..e971a42cc64e 100644
--- a/arch/x86/kernel/cpu/sgx/driver/vma.c
+++ b/arch/x86/kernel/cpu/sgx/driver/vma.c
@@ -51,8 +51,117 @@ static int sgx_vma_fault(struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 }
 
+static int sgx_edbgrd(struct sgx_encl *encl, struct sgx_encl_page *page,
+		      unsigned long addr, void *data)
+{
+	unsigned long offset;
+	int ret;
+
+	offset = addr & ~PAGE_MASK;
+
+	if ((page->desc & SGX_ENCL_PAGE_TCS) &&
+	    offset > offsetof(struct sgx_tcs, gs_limit))
+		return -ECANCELED;
+
+	ret = __edbgrd(sgx_epc_addr(page->epc_page) + offset, data);
+	if (ret) {
+		sgx_dbg(encl, "EDBGRD returned %d\n", ret);
+		return encls_to_err(ret);
+	}
+
+	return 0;
+}
+
+static int sgx_edbgwr(struct sgx_encl *encl, struct sgx_encl_page *page,
+		      unsigned long addr, void *data)
+{
+	unsigned long offset;
+	int ret;
+
+	offset = addr & ~PAGE_MASK;
+
+	/* Writing anything else than flags will cause #GP */
+	if ((page->desc & SGX_ENCL_PAGE_TCS) &&
+	    offset != offsetof(struct sgx_tcs, flags))
+		return -ECANCELED;
+
+	ret = __edbgwr(sgx_epc_addr(page->epc_page) + offset, data);
+	if (ret) {
+		sgx_dbg(encl, "EDBGWR returned %d\n", ret);
+		return encls_to_err(ret);
+	}
+
+	return 0;
+}
+
+static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
+			  void *buf, int len, int write)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_encl_page *entry = NULL;
+	unsigned long align;
+	char data[sizeof(unsigned long)];
+	int offset;
+	int cnt;
+	int ret = 0;
+	int i;
+
+	/* If process was forked, VMA is still there but vm_private_data is set
+	 * to NULL.
+	 */
+	if (!encl)
+		return -EFAULT;
+
+	if (!(encl->flags & SGX_ENCL_DEBUG) ||
+	    !(encl->flags & SGX_ENCL_INITIALIZED) ||
+	    (encl->flags & SGX_ENCL_DEAD))
+		return -EFAULT;
+
+	for (i = 0; i < len; i += cnt) {
+		if (!entry || !((addr + i) & (PAGE_SIZE - 1))) {
+			if (entry)
+				entry->desc &= ~SGX_ENCL_PAGE_RESERVED;
+
+			entry = sgx_fault_page(vma, (addr + i) & PAGE_MASK,
+					       true);
+			if (IS_ERR(entry)) {
+				ret = PTR_ERR(entry);
+				entry = NULL;
+				break;
+			}
+		}
+
+		/* Locking is not needed because only immutable fields of the
+		 * page are accessed and page itself is reserved so that it
+		 * cannot be swapped out in the middle.
+		 */
+
+		align = ALIGN_DOWN(addr + i, sizeof(unsigned long));
+		offset = (addr + i) & (sizeof(unsigned long) - 1);
+		cnt = sizeof(unsigned long) - offset;
+		cnt = min(cnt, len - i);
+
+		ret = sgx_edbgrd(encl, entry, align, data);
+		if (ret)
+			break;
+		if (write) {
+			memcpy(data + offset, buf + i, cnt);
+			ret = sgx_edbgwr(encl, entry, align, data);
+			if (ret)
+				break;
+		} else
+			memcpy(buf + i, data + offset, cnt);
+	}
+
+	if (entry)
+		entry->desc &= ~SGX_ENCL_PAGE_RESERVED;
+
+	return ret < 0 ? ret : i;
+}
+
 const struct vm_operations_struct sgx_vm_ops = {
 	.close = sgx_vma_close,
 	.open = sgx_vma_open,
 	.fault = sgx_vma_fault,
+	.access = sgx_vma_access,
 };
-- 
2.19.1

