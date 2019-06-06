Return-Path: <SRS0=qw+Y=UF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5923FC28CC5
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 02:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D0C420866
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 02:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfFFCLw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 22:11:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:61633 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbfFFCLv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 22:11:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 19:11:50 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 05 Jun 2019 19:11:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: [RFC PATCH v2 3/5] x86/sgx: Enforce noexec filesystem restriction for enclaves
Date:   Wed,  5 Jun 2019 19:11:43 -0700
Message-Id: <20190606021145.12604-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190606021145.12604-1-sean.j.christopherson@intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
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
Checking noexec indirectly by way of VM_MAYEXEC naturally handles any
other cases that clear VM_MAYEXEC to deny execute permissions.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 47 +++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index ef5c2ce0f37b..44b2d73de7c3 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -577,6 +577,44 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	return ret;
 }
 
+static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)
+{
+	struct vm_area_struct *vma;
+	int ret;
+
+	if (!(prot & VM_EXEC))
+		return 0;
+
+	/* Hold mmap_sem across copy_from_user() to avoid a TOCTOU race. */
+	down_read(&current->mm->mmap_sem);
+
+	vma = find_vma(current->mm, src);
+	if (!vma) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/*
+	 * Query VM_MAYEXEC as an indirect path_noexec() check (see do_mmap()),
+	 * but with some future proofing against other cases that may deny
+	 * execute permissions.
+	 */
+	if (!(vma->vm_flags & VM_MAYEXEC)) {
+		ret = -EACCES;
+		goto out;
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
@@ -616,13 +654,12 @@ static long sgx_ioc_enclave_add_page(struct file *filep, unsigned int cmd,
 
 	data = kmap(data_page);
 
-	if (copy_from_user((void *)data, (void __user *)addp->src, PAGE_SIZE)) {
-		ret = -EFAULT;
-		goto out;
-	}
-
 	prot = addp->flags & (PROT_READ | PROT_WRITE | PROT_EXEC);
 
+	ret = sgx_encl_page_copy(data, addp->src, prot);
+	if (ret)
+		goto out;
+
 	ret = sgx_encl_add_page(encl, addp->addr, data, &secinfo, addp->mrmask,
 				prot);
 	if (ret)
-- 
2.21.0

