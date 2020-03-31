Return-Path: <SRS0=QQlo=5Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4889DC2D0E8
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1835320848
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgCaLpA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Mar 2020 07:45:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:45954 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730515AbgCaLo7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 31 Mar 2020 07:44:59 -0400
IronPort-SDR: f00lKzajIQdKeAgHRmGySX4BGFdkp2VxzNO+UNua8SUlDDFwYRid1ul8/ztfk+l/Gmecq6pGhl
 5A1h/T6qsK4g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 04:44:59 -0700
IronPort-SDR: ycM7814PHdSS326X/foGVY2ZQ7W8RmBRDCEPFssyntvylsI8rrg1RQ9y4643PE5s4RgnKnEFGI
 zoJeT/3SlGnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="272717104"
Received: from tking1-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.59.94])
  by fmsmga004.fm.intel.com with ESMTP; 31 Mar 2020 04:44:55 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     kai.svahn@intel.com, bruce.schlobohm@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        luto@kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 4/4] x86/sgx: Hand over the enclave file to the user space
Date:   Tue, 31 Mar 2020 14:44:32 +0300
Message-Id: <20200331114432.7593-5-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a new output parameter, @enclave_fd, to struct sgx_enclave_init, which
will receive a file descriptor pointing the enclave file whose ownership is
transferred to the user space. While doing this, replace the comment
prepending sgx_ioc_enclave_init() with a regular (not kdoc) comment given
that it was out of date and the function is internal.

Cc: luto@kernel.org
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/uapi/asm/sgx.h    |  2 ++
 arch/x86/kernel/cpu/sgx/ioctl.c    | 56 ++++++++++++++++++------------
 tools/testing/selftests/sgx/load.c | 16 +++++----
 tools/testing/selftests/sgx/main.c |  3 +-
 tools/testing/selftests/sgx/main.h |  3 +-
 5 files changed, 49 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index e196cfd44b70..62f990c0a295 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -60,9 +60,11 @@ struct sgx_enclave_add_pages {
  * struct sgx_enclave_init - parameter structure for the
  *                           %SGX_IOC_ENCLAVE_INIT ioctl
  * @sigstruct:	address for the SIGSTRUCT data
+ * @enclave_fd:	file handle of the enclave
  */
 struct sgx_enclave_init {
 	__u64 sigstruct;
+	__u64 enclave_fd;
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 891aa9395907..b25e18622c02 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -606,9 +606,11 @@ static int sgx_einit(struct sgx_sigstruct *sigstruct, void *token,
 	return ret;
 }
 
-static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
-			 void *token)
+static int __sgx_ioc_enclave_init(struct file *filep,
+				  struct sgx_sigstruct *sigstruct, void *token)
 {
+	struct file *encl_file = filep->private_data;
+	struct sgx_encl *encl = encl_file->private_data;
 	u64 mrsigner[4];
 	int ret;
 	int i;
@@ -656,35 +658,39 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 		sgx_encl_destroy(encl);
 		ret = -EFAULT;
+		goto err_out;
 	} else if (ret) {
 		pr_debug("EINIT returned %d\n", ret);
 		ret = -EPERM;
-	} else {
-		atomic_or(SGX_ENCL_INITIALIZED, &encl->flags);
+		goto err_out;
 	}
 
+	/* Transfer the ownership of the enclave file to the user space. */
+	ret = get_unused_fd_flags(O_RDWR);
+	if (ret < 0)
+		goto err_out;
+
+	filep->private_data = NULL;
+	fd_install(ret, encl_file);
+
+	atomic_or(SGX_ENCL_INITIALIZED, &encl->flags);
+
 err_out:
 	mutex_unlock(&encl->lock);
 	return ret;
 }
 
-/**
- * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
- *
- * @filep:	open file to /dev/sgx
- * @arg:	userspace pointer to a struct sgx_enclave_init instance
- *
- * Flush any outstanding enqueued EADD operations and perform EINIT.  The
- * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
- * the enclave's MRSIGNER, which is caculated from the provided sigstruct.
- *
- * Return:
- *   0 on success,
- *   SGX error code on EINIT failure,
- *   -errno otherwise
+/*
+ * Initialize the enclave by performing ENCLS[EINIT] and hand over the enclave
+ * file to the user space. The function also checks whether the LE public key
+ * hash MSRs are out of date and updates them as necessary before performing
+ * ENCLS[EINIT].
  */
-static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
+static long sgx_ioc_enclave_init(struct file *filep,
+				 struct sgx_enclave_init __user *arg)
 {
+	struct file *encl_file = filep->private_data;
+	struct sgx_encl *encl = encl_file->private_data;
 	struct sgx_sigstruct *sigstruct;
 	struct sgx_enclave_init einit;
 	struct page *initp_page;
@@ -708,12 +714,16 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	if (copy_from_user(sigstruct, (void __user *)einit.sigstruct,
 			   sizeof(*sigstruct))) {
 		ret = -EFAULT;
-		goto out;
+		goto err;
 	}
 
-	ret = sgx_encl_init(encl, sigstruct, token);
+	ret = __sgx_ioc_enclave_init(filep, sigstruct, token);
+	if (ret < 0)
+		goto err;
 
-out:
+	ret = put_user((uint64_t)ret, &arg->enclave_fd);
+
+err:
 	kunmap(initp_page);
 	__free_page(initp_page);
 	return ret;
@@ -785,7 +795,7 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		ret = sgx_ioc_enclave_add_pages(encl, (void __user *)arg);
 		break;
 	case SGX_IOC_ENCLAVE_INIT:
-		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
+		ret = sgx_ioc_enclave_init(filep, (void __user *)arg);
 		break;
 	case SGX_IOC_ENCLAVE_SET_ATTRIBUTE:
 		ret = sgx_ioc_enclave_set_attribute(encl, (void __user *)arg);
diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index 53c565347e9e..ee5792f98162 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -27,8 +27,11 @@ void encl_delete(struct encl *encl)
 	if (encl->bin)
 		munmap(encl->bin, encl->bin_size);
 
-	if (encl->fd)
-		close(encl->fd);
+	if (encl->encl_fd)
+		close(encl->encl_fd);
+
+	if (encl->dev_fd)
+		close(encl->dev_fd);
 
 	if (encl->segment_tbl)
 		free(encl->segment_tbl);
@@ -88,7 +91,7 @@ static bool encl_ioc_create(struct encl *encl)
 	secs->size = encl->encl_size;
 
 	ioc.src = (unsigned long)secs;
-	rc = ioctl(encl->fd, SGX_IOC_ENCLAVE_CREATE, &ioc);
+	rc = ioctl(encl->dev_fd, SGX_IOC_ENCLAVE_CREATE, &ioc);
 	if (rc) {
 		fprintf(stderr, "SGX_IOC_ENCLAVE_CREATE failed: errno=%d\n",
 			errno);
@@ -114,7 +117,7 @@ static bool encl_ioc_add_pages(struct encl *encl, struct encl_segment *seg)
 	ioc.secinfo = (unsigned long)&secinfo;
 	ioc.flags = SGX_PAGE_MEASURE;
 
-	rc = ioctl(encl->fd, SGX_IOC_ENCLAVE_ADD_PAGES, &ioc);
+	rc = ioctl(encl->dev_fd, SGX_IOC_ENCLAVE_ADD_PAGES, &ioc);
 	if (rc) {
 		fprintf(stderr, "SGX_IOC_ENCLAVE_ADD_PAGES failed: errno=%d.\n",
 			errno);
@@ -145,7 +148,7 @@ bool encl_load(const char *path, struct encl *encl)
 		goto err;
 	}
 
-	encl->fd = ret;
+	encl->dev_fd = ret;
 
 	if (!encl_map_bin(path, encl))
 		goto err;
@@ -271,12 +274,13 @@ bool encl_build(struct encl *encl)
 	}
 
 	ioc.sigstruct = (uint64_t)&encl->sigstruct;
-	ret = ioctl(encl->fd, SGX_IOC_ENCLAVE_INIT, &ioc);
+	ret = ioctl(encl->dev_fd, SGX_IOC_ENCLAVE_INIT, &ioc);
 	if (ret) {
 		fprintf(stderr, "SGX_IOC_ENCLAVE_INIT failed: errno=%d\n",
 			errno);
 		return false;
 	}
 
+	encl->encl_fd = ioc.enclave_fd;
 	return true;
 }
diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 9238cce47f77..17bf57909435 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -149,7 +149,8 @@ int main(int argc, char *argv[], char *envp[])
 		struct encl_segment *seg = &encl.segment_tbl[i];
 
 		addr = mmap((void *)encl.encl_base + seg->offset, seg->size,
-			    seg->prot, MAP_SHARED | MAP_FIXED, encl.fd, 0);
+			    seg->prot, MAP_SHARED | MAP_FIXED, encl.encl_fd,
+			    0);
 		if (addr == MAP_FAILED) {
 			fprintf(stderr, "mmap() failed, errno=%d.\n", errno);
 			return false;
diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/sgx/main.h
index 6e1ae292bd25..cf0d4cf20fb0 100644
--- a/tools/testing/selftests/sgx/main.h
+++ b/tools/testing/selftests/sgx/main.h
@@ -14,7 +14,8 @@ struct encl_segment {
 };
 
 struct encl {
-	int fd;
+	int dev_fd;
+	int encl_fd;
 	void *bin;
 	off_t bin_size;
 	void *src;
-- 
2.25.1

