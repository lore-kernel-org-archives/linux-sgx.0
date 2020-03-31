Return-Path: <SRS0=QQlo=5Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B85C43331
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C621208E0
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbgCaLoy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Mar 2020 07:44:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:45935 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730542AbgCaLoy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 31 Mar 2020 07:44:54 -0400
IronPort-SDR: e7dyTjfoQMoTDcaOhhojmCJDB6VPtKOPenLPmnE5RPF5ewKpztUqmv3/DFS37vXZGM65bzeeA3
 E4ELcxDGl3Ww==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 04:44:53 -0700
IronPort-SDR: lKAKF9h1iJakbREWouhbQpDCQsDjD5zgAD9n5KPIwlZeyIbX/a2GB519ph7fMcifY51zqj0/gI
 t8mUKGfCKp7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="272717087"
Received: from tking1-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.59.94])
  by fmsmga004.fm.intel.com with ESMTP; 31 Mar 2020 04:44:50 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     kai.svahn@intel.com, bruce.schlobohm@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        luto@kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 3/4] x86/sgx: Move mmap() to the anonymous enclave file
Date:   Tue, 31 Mar 2020 14:44:31 +0300
Message-Id: <20200331114432.7593-4-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move mmap() to the internal anonymous enclave file as the latest Linux
distributions tend to map /dev as noexec.

Consequences:

1. Building an enclave requires no special privileges as the device file
   has no operations to map the enclave to the address space.
2. Running an enclave requires execu-from-mem privilege as one needs to
   be able to map pages with execution rights.

My conclusion is that exec-from-mem is the correct level of privileges
for an enclave because it best represents the actual enclave behaviour.

After this change the mmap()'s will fail expectedly with -ENODEV.

Cc: luto@kernel.org
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 45 ++++++++++++++++----------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 1c825ef957db..b871dbd1490f 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -57,9 +57,31 @@ static int sgx_encl_file_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int sgx_encl_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct sgx_encl *encl = file->private_data;
+	int ret;
+
+	ret = sgx_encl_may_map(encl, vma->vm_start, vma->vm_end,
+			       vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC));
+	if (ret)
+		return ret;
+
+	ret = sgx_encl_mm_add(encl, vma->vm_mm);
+	if (ret)
+		return ret;
+
+	vma->vm_ops = &sgx_vm_ops;
+	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
+	vma->vm_private_data = encl;
+
+	return 0;
+}
+
 static const struct file_operations sgx_encl_file_fops = {
 	.owner			= THIS_MODULE,
 	.release		= sgx_encl_file_release,
+	.mmap			= sgx_encl_file_mmap,
 };
 
 static int sgx_open(struct inode *inode, struct file *file)
@@ -127,28 +149,6 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
 }
 #endif
 
-static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct file *encl_file = file->private_data;
-	struct sgx_encl *encl = encl_file->private_data;
-	int ret;
-
-	ret = sgx_encl_may_map(encl, vma->vm_start, vma->vm_end,
-			       vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC));
-	if (ret)
-		return ret;
-
-	ret = sgx_encl_mm_add(encl, vma->vm_mm);
-	if (ret)
-		return ret;
-
-	vma->vm_ops = &sgx_vm_ops;
-	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
-	vma->vm_private_data = encl;
-
-	return 0;
-}
-
 static unsigned long sgx_get_unmapped_area(struct file *file,
 					   unsigned long addr,
 					   unsigned long len,
@@ -172,7 +172,6 @@ static const struct file_operations sgx_encl_dev_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sgx_compat_ioctl,
 #endif
-	.mmap			= sgx_mmap,
 	.get_unmapped_area	= sgx_get_unmapped_area,
 };
 
-- 
2.25.1

