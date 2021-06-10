Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85923C47094
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jun 2021 07:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64D15613DF
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jun 2021 07:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhFJHXX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Jun 2021 03:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229792AbhFJHXX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Jun 2021 03:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD9EC61359;
        Thu, 10 Jun 2021 07:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623309687;
        bh=gsCKKhZ6WQSwauiR72OkaiDwBsMu3zcmcFITrH04hTE=;
        h=From:To:Cc:Subject:Date:From;
        b=RQaOGawf7w8c61hoHCcNjLiOe975pvO9BT5oGxKXCfvr5B9OHECRw98dPmJI4P3iv
         s41yPzyHDyxT647NGI4KRJMEKaFQXcKVO+2+hhAywBBHZbARzzFrioUSA9di9AItHa
         KjdK5H363t1FXzHpmyn5QqDwa6OD+I1mMDZaMPDse2+kBHl0aFQTBXsCNbt7YEk72r
         fSu1q6M3DL7NpdFIqjAh179UmpxG+1C3hgA2upZXToblhk3esgZkEBdee4UXfzV+UJ
         IOYz1VSC1q3Key7vqpBAkLh09aKETTyMtWFMdIa8SdTW9AURiDkrZipCvxbiSnE2jh
         eUDvOPNmvIncw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Add SGX_PAGE_REPEAT flag for SGX_IOC_ENCLAVE_ADD_PAGES
Date:   Thu, 10 Jun 2021 10:21:17 +0300
Message-Id: <20210610072117.76987-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

For uninitialized data, there's a need to add the same page multiple times,
e.g. a zero page, instead of traversing the source memory forward. With the
current API, this requires to call SGX_IOC_ENCLAVE_ADD_PAGES multiple
times, once per page, which is not very efficient.

Add a new SGX_PAGE_REPEAT flag to resolve the issue. When this flag is set
to the 'flags' field of struct sgx_enclave_pages, the ioctl will apply the
page at 'src' multiple times, instead of moving forward in the address
space.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/include/uapi/asm/sgx.h | 3 +++
 arch/x86/kernel/cpu/sgx/ioctl.c | 9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 9690d6899ad9..d20fd54fa250 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -12,9 +12,12 @@
  * enum sgx_page_flags - page control flags
  * %SGX_PAGE_MEASURE:	Measure the page contents with a sequence of
  *			ENCLS[EEXTEND] operations.
+ * %SGX_PAGE_REPEAT:	Read the same page at 'src' multiple times,
+ *			instead of traversing the memory forward.
  */
 enum sgx_page_flags {
 	SGX_PAGE_MEASURE	= 0x01,
+	SGX_PAGE_REPEAT		= 0x02,
 };
 
 #define SGX_MAGIC 0xA4
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 83df20e3e633..d81bb257bad0 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -415,6 +415,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 {
 	struct sgx_enclave_add_pages add_arg;
 	struct sgx_secinfo secinfo;
+	unsigned long src;
 	unsigned long c;
 	int ret;
 
@@ -453,8 +454,12 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 		if (need_resched())
 			cond_resched();
 
-		ret = sgx_encl_add_page(encl, add_arg.src + c, add_arg.offset + c,
-					&secinfo, add_arg.flags);
+		if (add_arg.flags & SGX_PAGE_REPEAT)
+			src = add_arg.src;
+		else
+			src = add_arg.src + c;
+
+		ret = sgx_encl_add_page(encl, src, add_arg.offset + c, &secinfo, add_arg.flags);
 		if (ret)
 			break;
 	}
-- 
2.31.1

