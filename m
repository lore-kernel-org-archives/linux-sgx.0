Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91585C31E5B
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B962082C
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbfFQWYu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:24:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:43046 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbfFQWYt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jun 2019 18:24:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:24:48 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 17 Jun 2019 15:24:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: [RFC PATCH v3 05/12] x86/sgx: Enforce noexec filesystem restriction for enclaves
Date:   Mon, 17 Jun 2019 15:24:31 -0700
Message-Id: <20190617222438.2080-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617222438.2080-1-sean.j.christopherson@intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Do not allow an enclave page to be mapped with PROT_EXEC if the source
vma does not have VM_MAYEXEC.  This effectively enforces noexec as
do_mmap() clears VM_MAYEXEC if the vma is being loaded from a noexec
path, i.e. prevents executing a file by loading it into an enclave.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 42 +++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 8e95e45411f2..f239300e0fc2 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -564,6 +564,39 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	return ret;
 }
 
+static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)
+{
+	struct vm_area_struct *vma;
+	int ret;
+
+	/* Hold mmap_sem across copy_from_user() to avoid a TOCTOU race. */
+	down_read(&current->mm->mmap_sem);
+
+	/* Query vma's VM_MAYEXEC as an indirect path_noexec() check. */
+	if (prot & PROT_EXEC) {
+		vma = find_vma(current->mm, src);
+		if (!vma) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (!(vma->vm_flags & VM_MAYEXEC)) {
+			ret = -EACCES;
+			goto out;
+		}
+	}
+
+	if (copy_from_user(dst, (void __user *)src, PAGE_SIZE))
+		ret = -EFAULT;
+	else
+		ret = 0;
+
+out:
+	up_read(&current->mm->mmap_sem);
+
+	return ret;
+}
+
 /**
  * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
  *
@@ -604,13 +637,12 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 
 	data = kmap(data_page);
 
-	if (copy_from_user((void *)data, (void __user *)addp.src, PAGE_SIZE)) {
-		ret = -EFAULT;
-		goto out;
-	}
-
 	prot = addp.flags & (PROT_READ | PROT_WRITE | PROT_EXEC);
 
+	ret = sgx_encl_page_copy(data, addp.src, prot);
+	if (ret)
+		goto out;
+
 	ret = sgx_encl_add_page(encl, addp.addr, data, &secinfo, addp.mrmask,
 				prot);
 	if (ret)
-- 
2.21.0

