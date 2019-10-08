Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264ABECE59A
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED43B2084D
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbfJHEqR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:8175 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729564AbfJHEqR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566512"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 08/16] selftests/x86/sgx: Use getauxval() to retrieve the vDSO base address
Date:   Mon,  7 Oct 2019 21:46:05 -0700
Message-Id: <20191008044613.12350-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Replace the open coded ELF fun with a simple getauxval() call.

Suggested-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index f78ff458b0dd..3a0d76c40bcc 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -15,6 +15,8 @@
 #include <sys/stat.h>
 #include <sys/time.h>
 #include <sys/types.h>
+#include <sys/auxv.h>
+
 #include "defines.h"
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
@@ -30,22 +32,9 @@ struct vdso_symtab {
 	Elf64_Word *elf_hashtab;
 };
 
-static void *vdso_get_base_addr(char *envp[])
+static void *vdso_get_base_addr(void)
 {
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
+	return (void *)getauxval(AT_SYSINFO_EHDR);
 }
 
 static Elf64_Dyn *vdso_get_dyntab(void *addr)
@@ -342,7 +331,7 @@ int main(int argc, char *argv[], char *envp[])
 
 	memset(&exception, 0, sizeof(exception));
 
-	addr = vdso_get_base_addr(envp);
+	addr = vdso_get_base_addr();
 	if (!addr)
 		exit(1);
 
-- 
2.22.0

