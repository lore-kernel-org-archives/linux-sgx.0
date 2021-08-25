Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F25C432BE
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Aug 2021 23:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34457610C8
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Aug 2021 23:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhHYXxY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Aug 2021 19:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhHYXxX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Aug 2021 19:53:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D330161026;
        Wed, 25 Aug 2021 23:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629935557;
        bh=4f6/aZLhkYgMT8zgbbe7Ss6Hx3pMcO1Py5fmqFnqnLQ=;
        h=From:To:Cc:Subject:Date:From;
        b=fKlps0FmgfMsUl5e5pBiC1wlFmq/yZ847+vZ+GQ783qITp22LUoKSCQt3YyJ+hDOa
         /5tj8WNPRI2+qekZ1igQXuAkcEuImQ/XHWJM949OToCJZuyz3nuieCmuB25hOU1rEt
         4TCQU//AARNWJPkxka99J137+E7iaa34akOD9X6mLVt8AKHP3KF/jUupxfci7wpg52
         Z2JMsmNXGo7SC+PVYUeDNKYfjqUZZhGOdO8zoFpvBZKWc0tXW4P6O++kXFU0hKr4wQ
         n6vMfqM9ijrcRR3TBAupr+OgRPtuzqV7B6qhJbZqBS/+bYM3Wr8p+NHaObT6NpexhF
         I0iySu5JlSWgw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     Shuah Khan <shuah@kernel.org>, Borislav Petkov <bp@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] x86/sgx: Add the missing ifdef for sgx_set_attribute()
Date:   Thu, 26 Aug 2021 02:52:32 +0300
Message-Id: <20210825235234.153013-1-jarkko@kernel.org>
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
v3:
* Since CONFIG_X86_SGX_KVM depends on CONFIG_X86_SGX surround everything
  with CONFIG_X86_SGX config flag.
  Link: https://lore.kernel.org/linux-sgx/YR6Bs2twT4EK%2FjUK@google.com/
---
 arch/x86/include/asm/sgx.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 05f3e21f01a7..996e56590a10 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -365,6 +365,11 @@ struct sgx_sigstruct {
  * comment!
  */
 
+#ifdef CONFIG_X86_SGX
+
+int sgx_set_attribute(unsigned long *allowed_attributes,
+		      unsigned int attribute_fd);
+
 #ifdef CONFIG_X86_SGX_KVM
 int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 		     int *trapnr);
@@ -372,7 +377,6 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
 		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
 #endif
 
-int sgx_set_attribute(unsigned long *allowed_attributes,
-		      unsigned int attribute_fd);
+#endif /* CONFIG_X86_SGX */
 
 #endif /* _ASM_X86_SGX_H */
-- 
2.25.1

