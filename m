Return-Path: <SRS0=VHel=4U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B432FC3F2D1
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 20:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 858BF208C3
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 20:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbgCCUyK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Mar 2020 15:54:10 -0500
Received: from mga17.intel.com ([192.55.52.151]:63245 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730949AbgCCUyK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Mar 2020 15:54:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 12:54:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="233769318"
Received: from fkuchars-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.4.236])
  by orsmga008.jf.intel.com with ESMTP; 03 Mar 2020 12:54:06 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 1/2] x86/sgx: cleanup: Remove unused struct
Date:   Tue,  3 Mar 2020 22:53:58 +0200
Message-Id: <20200303205359.108336-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove struct sgx_einittoken as it is no longer required. Only size
of the microarchitectural structure is needed by the kernel.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/arch.h  | 54 +--------------------------------
 arch/x86/kernel/cpu/sgx/encls.h |  5 ++-
 arch/x86/kernel/cpu/sgx/ioctl.c | 14 ++++-----
 3 files changed, 9 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/kernel/cpu/sgx/arch.h
index 98836ab3eeaf..ddae55e9d4d8 100644
--- a/arch/x86/kernel/cpu/sgx/arch.h
+++ b/arch/x86/kernel/cpu/sgx/arch.h
@@ -338,58 +338,6 @@ struct sgx_sigstruct {
 	u8  q2[SGX_MODULUS_SIZE];
 } __packed;
 
-#define SGX_EINITTOKEN_RESERVED1_SIZE 11
-#define SGX_EINITTOKEN_RESERVED2_SIZE 32
-#define SGX_EINITTOKEN_RESERVED3_SIZE 32
-#define SGX_EINITTOKEN_RESERVED4_SIZE 24
-
-/**
- * struct sgx_einittoken - a token permitting to launch an enclave
- * @valid:			one if valid and zero if invalid
- * @attributes:			attributes for enclave
- * @xfrm:			XSave-Feature Request Mask (subset of XCR0)
- * @mrenclave:			SHA256-hash of the enclave contents
- * @mrsigner:			SHA256-hash of the public key used to sign the
- *				SIGSTRUCT
- * @le_cpusvn:			a value that reflects the SGX implementation
- *				running in in the CPU
- * @le_isvprodid:		a user-defined value that is used in key
- *				derivation
- * @le_isvsvn:			a user-defined value that is used in key
- *				derivation
- * @le_keyed_miscselect:	LE's miscselect masked with the token keys
- *				miscselect
- * @le_keyed_attributes:	LE's attributes masked with the token keys
- *				attributes
- * @le_keyed_xfrm:		LE's XFRM masked with the token keys xfrm
- * @salt:			random salt for wear-out protection
- * @mac:			CMAC over the preceding fields
- *
- * An enclave with EINITTOKENKEY attribute can access a key with the same name
- * by using ENCLS(EGETKEY) and use this to sign cryptographic tokens that can
- * be passed to ENCLS(EINIT) to permit the launch of other enclaves. This is
- * the only viable way to launch enclaves if IA32_SGXLEPUBKEYHASHn MSRs are
- * locked assuming that there is a Launch Enclave (LE) available that can be
- * used for generating these tokens.
- */
-struct sgx_einittoken {
-	u32 valid;
-	u32 reserved1[SGX_EINITTOKEN_RESERVED1_SIZE];
-	u64 attributes;
-	u64 xfrm;
-	u8  mrenclave[32];
-	u8  reserved2[SGX_EINITTOKEN_RESERVED2_SIZE];
-	u8  mrsigner[32];
-	u8  reserved3[SGX_EINITTOKEN_RESERVED3_SIZE];
-	u8  le_cpusvn[16];
-	u16 le_isvprodid;
-	u16 le_isvsvn;
-	u8  reserved4[SGX_EINITTOKEN_RESERVED4_SIZE];
-	u32 le_keyed_miscselect;
-	u64 le_keyed_attributes;
-	u64 le_keyed_xfrm;
-	u8  salt[32];
-	u8  mac[16];
-} __packed __aligned(512);
+#define SGX_LAUNCH_TOKEN_SIZE 304
 
 #endif /* _ASM_X86_SGX_ARCH_H */
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 30132edddcd6..b4c27d8bd2ac 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -186,10 +186,9 @@ static inline int __eadd(struct sgx_pageinfo *pginfo, void *addr)
 	return __encls_2(EADD, pginfo, addr);
 }
 
-static inline int __einit(void *sigstruct, struct sgx_einittoken *einittoken,
-			  void *secs)
+static inline int __einit(void *sigstruct, void *token, void *secs)
 {
-	return __encls_ret_3(EINIT, sigstruct, secs, einittoken);
+	return __encls_ret_3(EINIT, sigstruct, secs, token);
 }
 
 static inline int __eremove(void *addr)
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 2880ed4745b6..eaae533578b9 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -595,8 +595,7 @@ static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
 	}
 }
 
-static int sgx_einit(struct sgx_sigstruct *sigstruct,
-		     struct sgx_einittoken *token,
+static int sgx_einit(struct sgx_sigstruct *sigstruct, void *token,
 		     struct sgx_epc_page *secs, u64 *lepubkeyhash)
 {
 	int ret;
@@ -616,7 +615,7 @@ static int sgx_einit(struct sgx_sigstruct *sigstruct,
 }
 
 static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
-			 struct sgx_einittoken *token)
+			 void *token)
 {
 	u64 mrsigner[4];
 	int ret;
@@ -694,10 +693,10 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
  */
 static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 {
-	struct sgx_einittoken *einittoken;
 	struct sgx_sigstruct *sigstruct;
 	struct sgx_enclave_init einit;
 	struct page *initp_page;
+	void *token;
 	int ret;
 
 	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
@@ -711,9 +710,8 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 		return -ENOMEM;
 
 	sigstruct = kmap(initp_page);
-	einittoken = (struct sgx_einittoken *)
-		((unsigned long)sigstruct + PAGE_SIZE / 2);
-	memset(einittoken, 0, sizeof(*einittoken));
+	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
+	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
 
 	if (copy_from_user(sigstruct, (void __user *)einit.sigstruct,
 			   sizeof(*sigstruct))) {
@@ -721,7 +719,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 		goto out;
 	}
 
-	ret = sgx_encl_init(encl, sigstruct, einittoken);
+	ret = sgx_encl_init(encl, sigstruct, token);
 
 out:
 	kunmap(initp_page);
-- 
2.25.0

