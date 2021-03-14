Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D968CC433E0
	for <linux-sgx@archiver.kernel.org>; Sun, 14 Mar 2021 11:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E1DF64EB7
	for <linux-sgx@archiver.kernel.org>; Sun, 14 Mar 2021 11:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbhCNLQz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 14 Mar 2021 07:16:55 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:37806 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235115AbhCNLQ0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 14 Mar 2021 07:16:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0URqdWtn_1615720581;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0URqdWtn_1615720581)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 14 Mar 2021 19:16:22 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Shuah Khan <shuah@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v6] selftests/x86: Use getauxval() to simplify the code in sgx
Date:   Sun, 14 Mar 2021 19:16:21 +0800
Message-Id: <20210314111621.68428-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Simplify the sgx code implemntation by using library function
getauxval() instead of a custom function to get the base address
of vDSO.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/sgx/main.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 724cec700926..5167505fbb46 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -15,6 +15,7 @@
 #include <sys/stat.h>
 #include <sys/time.h>
 #include <sys/types.h>
+#include <sys/auxv.h>
 #include "defines.h"
 #include "main.h"
 #include "../kselftest.h"
@@ -28,24 +29,6 @@ struct vdso_symtab {
 	Elf64_Word *elf_hashtab;
 };
 
-static void *vdso_get_base_addr(char *envp[])
-{
-	Elf64_auxv_t *auxv;
-	int i;
-
-	for (i = 0; envp[i]; i++)
-		;
-
-	auxv = (Elf64_auxv_t *)&envp[i + 1];
-
-	for (i = 0; auxv[i].a_type != AT_NULL; i++) {
-		if (auxv[i].a_type == AT_SYSINFO_EHDR)
-			return (void *)auxv[i].a_un.a_val;
-	}
-
-	return NULL;
-}
-
 static Elf64_Dyn *vdso_get_dyntab(void *addr)
 {
 	Elf64_Ehdr *ehdr = addr;
@@ -162,7 +145,7 @@ static int user_handler(long rdi, long rsi, long rdx, long ursp, long r8, long r
 	return 0;
 }
 
-int main(int argc, char *argv[], char *envp[])
+int main(int argc, char *argv[])
 {
 	struct sgx_enclave_run run;
 	struct vdso_symtab symtab;
@@ -203,7 +186,8 @@ int main(int argc, char *argv[], char *envp[])
 	memset(&run, 0, sizeof(run));
 	run.tcs = encl.encl_base;
 
-	addr = vdso_get_base_addr(envp);
+	/* Get vDSO base address */
+	addr = (void *)getauxval(AT_SYSINFO_EHDR);
 	if (!addr)
 		goto err;
 
-- 
2.19.1.3.ge56e4f7

