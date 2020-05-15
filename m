Return-Path: <SRS0=5ZAu=65=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B2FC433E4
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 00:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B36A206B6
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 00:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgEOAqc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 20:46:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:34992 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgEOAqc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 20:46:32 -0400
IronPort-SDR: sYFrDhlgDwuO3OAYgb1qYXD35R0KlYJqI2PtwgU5YWgvq8WvdNx7vd7yXscCQrO3mifib22F2Y
 cAsxnLR/qxLg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 17:46:31 -0700
IronPort-SDR: nQssOF0PvWFLsGcD2sYIu2Dic6w+EwYEKjPDxYbsROi0p2eChV/luzFEXmXImW3ipXX5wjK0Co
 wz1F7ZWxppVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,393,1583222400"; 
   d="scan'208";a="253644379"
Received: from ashadrin-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.38.112])
  by fmsmga008.fm.intel.com with ESMTP; 14 May 2020 17:46:24 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: [PATCH v30 13/20] x86/sgx: ptrace() support for the SGX driver
Date:   Fri, 15 May 2020 03:44:03 +0300
Message-Id: <20200515004410.723949-14-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add VMA callbacks for ptrace() that can be used with debug enclaves.
With debug enclaves data can be read and write the memory word at a time
by using ENCLS(EDBGRD) and ENCLS(EDBGWR) leaf instructions.

Acked-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 87 ++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index fe7dbca40bb4..2211e86fb711 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -333,10 +333,97 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
 				calc_vm_prot_bits(prot, 0));
 }
 
+static int sgx_edbgrd(struct sgx_encl *encl, struct sgx_encl_page *page,
+		      unsigned long addr, void *data)
+{
+	unsigned long offset = addr & ~PAGE_MASK;
+	int ret;
+
+
+	ret = __edbgrd(sgx_epc_addr(page->epc_page) + offset, data);
+	if (ret)
+		return -EIO;
+
+	return 0;
+}
+
+static int sgx_edbgwr(struct sgx_encl *encl, struct sgx_encl_page *page,
+		      unsigned long addr, void *data)
+{
+	unsigned long offset = addr & ~PAGE_MASK;
+	int ret;
+
+	ret = __edbgwr(sgx_epc_addr(page->epc_page) + offset, data);
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
+	/* If process was forked, VMA is still there but vm_private_data is set
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
+		ret = sgx_edbgrd(encl, entry, align, data);
+		if (ret)
+			goto out;
+
+		if (write) {
+			memcpy(data + offset, buf + i, cnt);
+			ret = sgx_edbgwr(encl, entry, align, data);
+			if (ret)
+				goto out;
+		} else
+			memcpy(buf + i, data + offset, cnt);
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
 	.may_mprotect = sgx_vma_mprotect,
+	.access = sgx_vma_access,
 };
 
 /**
-- 
2.25.1

