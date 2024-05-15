Received: from out0-221.mail.aliyun.com (out0-221.mail.aliyun.com [140.205.0.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3992E42ABE;
	Wed, 15 May 2024 07:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.205.0.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715758136; cv=none; b=WZKT2FgDGf3Ewx6wD9tI/SPBTcBOW/OyS7E1y8cUweruEVfxK0CpKRnD/fytFjiDnEl4WcJV4Z99uP1nmjGrSwGIROHTkOMtYTPsmzDnmQ5TDHXIAugGkvhAFUupivKT50V6jkm5SRUGh+q1xOF7QJD1UXFGQxO16OfAeg2wpAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715758136; c=relaxed/simple;
	bh=kg9FBGaLFSYSolZ+kYeYLXd4PfPjIRINga9fZHbguOE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CV3oRy5+H03BrtwoinwPdwKOfn4VNo1xHShoa3he0volkTAnRy+a+nU3o0T2qAx088U+1GVOj+uIkWMgSKR56KH1pPn1uoTsOa/KZMdMRFz7dbAwPjl/KxdIU8yuVmHaEb9I4AbCPaHvNVViyVfwMhQRmvcW6T6nFAH8L4m1FLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=cKNeGxB9; arc=none smtp.client-ip=140.205.0.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="cKNeGxB9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1715758124; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=iygWzb146bE5+hKjt3BFt09dlMmLDxw3q9sYO4Jp0aQ=;
	b=cKNeGxB9xQA2XmFoELGwJC1pz+Gi8ekSTnZRDce/m+rrEKW6W2uId+R9i9TudBSVY4MKI8VI7jqlnf0PltYWQqtjU7Z1WKroUgvIgWVKjCIKwtF1jCfsowjWIg/q2jWxo46X3cTvvOULHJqavDJwOj5rWxE0IwLcyWiS0GEwmiY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047201;MF=zhubojun.zbj@antgroup.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---.Xd2Mww6_1715756260;
Received: from localhost(mailfrom:zhubojun.zbj@antgroup.com fp:SMTPD_---.Xd2Mww6_1715756260)
          by smtp.aliyun-inc.com;
          Wed, 15 May 2024 14:57:48 +0800
From: "Bojun Zhu" <zhubojun.zbj@antgroup.com>
To: linux-kernel@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	jarkko@kernel.org,
	dave.hansen@linux.intel.com
Cc:  <reinette.chatre@intel.com>,
  "=?UTF-8?B?5YiY5Y+MKOi9qeWxuSk=?=" <ls123674@antgroup.com>,
  "Bojun Zhu" <zhubojun.zbj@antgroup.com>
Subject: [RFC PATCH v3 1/1] x86/sgx: Explicitly give up the CPU in EDMM's ioctl() to avoid softlockup
Date: Wed, 15 May 2024 14:55:21 +0800
Message-Id: <20240515065521.67908-2-zhubojun.zbj@antgroup.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240515065521.67908-1-zhubojun.zbj@antgroup.com>
References: <20240515065521.67908-1-zhubojun.zbj@antgroup.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EDMM's ioctl()s support batch operations, which may be
time-consuming. Try to explicitly give up the CPU as the prefix
operation at the every begin of "for loop" in
sgx_enclave_{ modify_types | restrict_permissions | remove_pages}
to give other tasks a chance to run, and avoid softlockup warning.

Additionally perform pending signals check as the prefix operation,
and introduce sgx_check_signal_and_resched(),
which wraps all the checks.

The following has been observed on Linux v6.9-rc5 with kernel
preemptions disabled(by configuring "PREEMPT_NONE=y"), when kernel
is requested to restrict page permissions of a large number of EPC pages.

    ------------[ cut here ]------------
    watchdog: BUG: soft lockup - CPU#45 stuck for 22s!
    ...
    RIP: 0010:sgx_enclave_restrict_permissions+0xba/0x1f0
    ...
    Call Trace:
     sgx_ioctl
     __x64_sys_ioctl
     x64_sys_call
     do_syscall_64
     entry_SYSCALL_64_after_hwframe
    ------------[ end trace ]------------

Signed-off-by: Bojun Zhu <zhubojun.zbj@antgroup.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 40 +++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index b65ab214bdf5..6199f483143e 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -365,6 +365,20 @@ static int sgx_validate_offset_length(struct sgx_encl *encl,
 	return 0;
 }
 
+/*
+ * Check signals and invoke scheduler. Return true for a pending signal.
+ */
+static bool sgx_check_signal_and_resched(void)
+{
+	if (signal_pending(current))
+		return true;
+
+	if (need_resched())
+		cond_resched();
+
+	return false;
+}
+
 /**
  * sgx_ioc_enclave_add_pages() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGES
  * @encl:       an enclave pointer
@@ -409,7 +423,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	struct sgx_enclave_add_pages add_arg;
 	struct sgx_secinfo secinfo;
 	unsigned long c;
-	int ret;
+	int ret = -ERESTARTSYS;
 
 	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
 	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
@@ -432,15 +446,8 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 		return -EINVAL;
 
 	for (c = 0 ; c < add_arg.length; c += PAGE_SIZE) {
-		if (signal_pending(current)) {
-			if (!c)
-				ret = -ERESTARTSYS;
-
+		if (sgx_check_signal_and_resched())
 			break;
-		}
-
-		if (need_resched())
-			cond_resched();
 
 		ret = sgx_encl_add_page(encl, add_arg.src + c, add_arg.offset + c,
 					&secinfo, add_arg.flags);
@@ -740,12 +747,15 @@ sgx_enclave_restrict_permissions(struct sgx_encl *encl,
 	unsigned long addr;
 	unsigned long c;
 	void *epc_virt;
-	int ret;
+	int ret = -ERESTARTSYS;
 
 	memset(&secinfo, 0, sizeof(secinfo));
 	secinfo.flags = modp->permissions & SGX_SECINFO_PERMISSION_MASK;
 
 	for (c = 0 ; c < modp->length; c += PAGE_SIZE) {
+		if (sgx_check_signal_and_resched())
+			goto out;
+
 		addr = encl->base + modp->offset + c;
 
 		sgx_reclaim_direct();
@@ -898,7 +908,7 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 	unsigned long addr;
 	unsigned long c;
 	void *epc_virt;
-	int ret;
+	int ret = -ERESTARTSYS;
 
 	page_type = modt->page_type & SGX_PAGE_TYPE_MASK;
 
@@ -913,6 +923,9 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 	secinfo.flags = page_type << 8;
 
 	for (c = 0 ; c < modt->length; c += PAGE_SIZE) {
+		if (sgx_check_signal_and_resched())
+			goto out;
+
 		addr = encl->base + modt->offset + c;
 
 		sgx_reclaim_direct();
@@ -1095,12 +1108,15 @@ static long sgx_encl_remove_pages(struct sgx_encl *encl,
 	unsigned long addr;
 	unsigned long c;
 	void *epc_virt;
-	int ret;
+	int ret = -ERESTARTSYS;
 
 	memset(&secinfo, 0, sizeof(secinfo));
 	secinfo.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X;
 
 	for (c = 0 ; c < params->length; c += PAGE_SIZE) {
+		if (sgx_check_signal_and_resched())
+			goto out;
+
 		addr = encl->base + params->offset + c;
 
 		sgx_reclaim_direct();
-- 
2.25.1

