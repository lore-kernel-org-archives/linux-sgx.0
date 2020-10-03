Return-Path: <SRS0=MzOG=DK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0718AC46466
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 04:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C748C2311D
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 04:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgJCEwT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Oct 2020 00:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgJCEvw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Oct 2020 00:51:52 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 749FE22262;
        Sat,  3 Oct 2020 04:51:43 +0000 (UTC)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v39 17/24] x86/sgx: Add ptrace() support for the SGX driver
Date:   Sat,  3 Oct 2020 07:50:52 +0300
Message-Id: <20201003045059.665934-18-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Intel Sofware Guard eXtensions (SGX) allows creation of executable blobs
called enclaves, which cannot be accessed by default when not executing
inside the enclave. Enclaves can be entered by only using predefined memory
addresses, which are defined when the enclave is loaded.

However, enclaves can defined as debug enclaves at the load time. In debug
enclaves data can be read and/or written a memory word at a time by by
using ENCLS[EDBGRD] and ENCLS[EDBGWR] leaf instructions.

Add sgx_vma_access() function that implements 'access' virtual function
of struct vm_operations_struct. Use aforementioned leaf instructions to
provide read and write primitives for the enclave memory.

Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Acked-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 89 ++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 54326efa6c2f..ae45f8f0951e 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -337,10 +337,99 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma,
 	return mprotect_fixup(vma, pprev, start, end, newflags);
 }
 
+static int sgx_encl_debug_read(struct sgx_encl *encl, struct sgx_encl_page *page,
+			       unsigned long addr, void *data)
+{
+	unsigned long offset = addr & ~PAGE_MASK;
+	int ret;
+
+
+	ret = __edbgrd(sgx_get_epc_addr(page->epc_page) + offset, data);
+	if (ret)
+		return -EIO;
+
+	return 0;
+}
+
+static int sgx_encl_debug_write(struct sgx_encl *encl, struct sgx_encl_page *page,
+				unsigned long addr, void *data)
+{
+	unsigned long offset = addr & ~PAGE_MASK;
+	int ret;
+
+	ret = __edbgwr(sgx_get_epc_addr(page->epc_page) + offset, data);
+	if (ret)
+		return -EIO;
+
+	return 0;
+}
+
+static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
+			  void *buf, int len, int write)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_encl_page *entry = NULL;
+	char data[sizeof(unsigned long)];
+	unsigned long align;
+	unsigned int flags;
+	int offset;
+	int cnt;
+	int ret = 0;
+	int i;
+
+	/*
+	 * If process was forked, VMA is still there but vm_private_data is set
+	 * to NULL.
+	 */
+	if (!encl)
+		return -EFAULT;
+
+	flags = atomic_read(&encl->flags);
+
+	if (!(flags & SGX_ENCL_DEBUG) || !(flags & SGX_ENCL_INITIALIZED) ||
+	    (flags & SGX_ENCL_DEAD))
+		return -EFAULT;
+
+	for (i = 0; i < len; i += cnt) {
+		entry = sgx_encl_reserve_page(encl, (addr + i) & PAGE_MASK);
+		if (IS_ERR(entry)) {
+			ret = PTR_ERR(entry);
+			break;
+		}
+
+		align = ALIGN_DOWN(addr + i, sizeof(unsigned long));
+		offset = (addr + i) & (sizeof(unsigned long) - 1);
+		cnt = sizeof(unsigned long) - offset;
+		cnt = min(cnt, len - i);
+
+		ret = sgx_encl_debug_read(encl, entry, align, data);
+		if (ret)
+			goto out;
+
+		if (write) {
+			memcpy(data + offset, buf + i, cnt);
+			ret = sgx_encl_debug_write(encl, entry, align, data);
+			if (ret)
+				goto out;
+		} else {
+			memcpy(buf + i, data + offset, cnt);
+		}
+
+out:
+		mutex_unlock(&encl->lock);
+
+		if (ret)
+			break;
+	}
+
+	return ret < 0 ? ret : i;
+}
+
 const struct vm_operations_struct sgx_vm_ops = {
 	.open = sgx_vma_open,
 	.fault = sgx_vma_fault,
 	.mprotect = sgx_vma_mprotect,
+	.access = sgx_vma_access,
 };
 
 /**
-- 
2.25.1

