Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6B3C4338F
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 12:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCF4C61154
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 12:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbhHSMtF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhHSMtF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Aug 2021 08:49:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ADE1610FF;
        Thu, 19 Aug 2021 12:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629377308;
        bh=M2KqScfh8Ka58GufwkkT09GLypd5iIn+0XO1ysycaSI=;
        h=From:To:Cc:Subject:Date:From;
        b=o7gyR8ueni9QsNF4fiqX478NSOpy9j8s0K2WDkmleOTFtKmRWmRCka+uJxJLzyyvW
         TIq2HBe9ppX0hhHzM9ud/mcq1I6HB7Ybg4eeZq4RjaiAqZP9LDVbqD2/VU9uYO7j6q
         nz/aFlcVRDLRLQXluqDgi+9NV+maJ/JYjxMAE45ZTY5Y6qhb280K/RrmFtZ9e0XiFB
         y9gJhRhBaKuH2a8FWrq952w+oABlW+mzKsDeyzAMzML/ezoG1+QgK809QdBAKqKWDy
         QW6uvREbspI7eJYOxNkojI9Bz3LRRxIg1vyDJrh7xf2GHKryY2JiFAzed1J5E0kUxH
         jXM1LLAK5TrFQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] x86/sgx: Add the missing ifdef for sgx_set_attribute()
Date:   Thu, 19 Aug 2021 15:48:23 +0300
Message-Id: <20210819124824.52169-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Similarly as sgx_virt_*, decorate sgx_set_attribute() with ifdef, so that
calling it without appropraite config flags, will cause a compilation
error, and not a linking error.

Fixes: b3754e5d3da3 ("x86/sgx: Move provisioning device creation out of SGX driver")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/include/asm/sgx.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 05f3e21f01a7..38c397ef35a8 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -365,6 +365,11 @@ struct sgx_sigstruct {
  * comment!
  */
 
+#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
+int sgx_set_attribute(unsigned long *allowed_attributes,
+		      unsigned int attribute_fd);
+#endif
+
 #ifdef CONFIG_X86_SGX_KVM
 int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 		     int *trapnr);
@@ -372,7 +377,4 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
 		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
 #endif
 
-int sgx_set_attribute(unsigned long *allowed_attributes,
-		      unsigned int attribute_fd);
-
 #endif /* _ASM_X86_SGX_H */
-- 
2.25.1

