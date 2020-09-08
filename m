Return-Path: <SRS0=A1EY=CR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC0AC43461
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Sep 2020 19:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80771206B8
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Sep 2020 19:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgIHTA5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Sep 2020 15:00:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:39479 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731235AbgIHTAy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Sep 2020 15:00:54 -0400
IronPort-SDR: fIofUWm6w56aDPBy0stwwseg35Hkwk2nrot1wZbNixdV5QyZigoIO+Udv9JI+1Sbd6pjjWAnoq
 sCkRGnbUq5Jg==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="222412737"
X-IronPort-AV: E=Sophos;i="5.76,406,1592895600"; 
   d="scan'208";a="222412737"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 12:00:53 -0700
IronPort-SDR: Cu3d6pgV1F96768TtbtYJyeJff7/WT6Iz8eT/lC/+aUnqPdpNm/pj3yaRLrIXiPLgXc5Ntbe/o
 Ysub71i6iEJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,406,1592895600"; 
   d="scan'208";a="285977273"
Received: from jfontesg-mobl.ger.corp.intel.com (HELO localhost) ([10.252.39.71])
  by fmsmga008.fm.intel.com with ESMTP; 08 Sep 2020 12:00:51 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86/sgx: Roof the number of pages process in SGX_IOC_ENCLAVE_ADD_PAGES
Date:   Tue,  8 Sep 2020 22:00:42 +0300
Message-Id: <20200908190042.24895-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove 'count' from struct sgx_enclave_add_pages and return number of
pages processed as a positive return as there is no reasonable use for
-EINTR for the caller. Then, roof the processing with a fixed constant
and break out the loop also when this value is surpassed.

Link: https://lore.kernel.org/linux-sgx/20200626153400.GE27151@zn.tnic/
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/uapi/asm/sgx.h |  2 --
 arch/x86/kernel/cpu/sgx/ioctl.c | 10 ++++------
 arch/x86/kernel/cpu/sgx/sgx.h   |  1 +
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index b3d5ccf5b976..1564d7f88597 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -45,7 +45,6 @@ struct sgx_enclave_create  {
  * @length:	length of the data (multiple of the page size)
  * @secinfo:	address for the SECINFO data
  * @flags:	page control flags
- * @count:	number of bytes added (multiple of the page size)
  */
 struct sgx_enclave_add_pages {
 	__u64	src;
@@ -53,7 +52,6 @@ struct sgx_enclave_add_pages {
 	__u64	length;
 	__u64	secinfo;
 	__u64	flags;
-	__u64	count;
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 6c3c6177b690..0ae00fa9b589 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -490,7 +490,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
  * caller.
  *
  * Return:
- *   0 on success,
+ *   length of the data processed on success,
  *   -EACCES if an executable source page is located in a noexec partition,
  *   -EIO if either ENCLS[EADD] or ENCLS[EEXTEND] fails
  *   -errno otherwise
@@ -530,8 +530,8 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 		return -EINVAL;
 
 	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
-		if (signal_pending(current)) {
-			ret = -EINTR;
+		if (c == SGX_MAX_ADD_PAGES_LENGTH || signal_pending(current)) {
+			ret = c;
 			break;
 		}
 
@@ -544,12 +544,10 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 			break;
 	}
 
-	addp.count = c;
-
 	if (copy_to_user(arg, &addp, sizeof(addp)))
 		return -EFAULT;
 
-	return ret;
+	return c;
 }
 
 static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 1a6ca5f734e5..94b29f378ea2 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -37,6 +37,7 @@ struct sgx_epc_section {
 #define SGX_EPC_SECTION_MASK		GENMASK(7, 0)
 #define SGX_MAX_EPC_SECTIONS		(SGX_EPC_SECTION_MASK + 1)
 #define SGX_EPC_PAGE_RECLAIMABLE	BIT(8)
+#define SGX_MAX_ADD_PAGES_LENGTH	0x100000
 #define SGX_NR_TO_SCAN			16
 #define SGX_NR_LOW_PAGES		32
 #define SGX_NR_HIGH_PAGES		64
-- 
2.25.1

