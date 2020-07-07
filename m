Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4528C433E0
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ACF420663
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgGGDF4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Jul 2020 23:05:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:17170 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgGGDF4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Jul 2020 23:05:56 -0400
IronPort-SDR: dqcsHK09N0lJ1abJ2aL1mZQcDW7Pp0TeVPvpwGanmkycXX9o6hzWSgq9X1gqntYP7iJJtfvxTZ
 OuIHDmIWiWfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="134997246"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="134997246"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 20:05:55 -0700
IronPort-SDR: CX0y5OpetYri44VJbHKwB9jQJy6IbaeBtETD7HdKizIXnITVyGFPHt/kXJ84lQ+nM3rrKwB9IG
 nYwmRJgf0fJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="388368823"
Received: from apiccion-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.45.178])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jul 2020 20:05:42 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v34 17/24] x86/sgx: ptrace() support for the SGX driver
Date:   Tue,  7 Jul 2020 06:01:57 +0300
Message-Id: <20200707030204.126021-18-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
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
index b22e7187142d..a0c84a7fb6f9 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -334,10 +334,97 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
 				calc_vm_prot_bits(prot, 0));
 }
 
+static int sgx_edbgrd(struct sgx_encl *encl, struct sgx_encl_page *page,
+		      unsigned long addr, void *data)
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
+static int sgx_edbgwr(struct sgx_encl *encl, struct sgx_encl_page *page,
+		      unsigned long addr, void *data)
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
 	.mprotect = sgx_vma_mprotect,
+	.access = sgx_vma_access,
 };
 
 /**
-- 
2.25.1

