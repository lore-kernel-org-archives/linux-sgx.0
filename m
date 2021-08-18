Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC75C4338F
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Aug 2021 13:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D95746108F
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Aug 2021 13:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbhHRNZu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Aug 2021 09:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233722AbhHRNZt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Aug 2021 09:25:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE7960232;
        Wed, 18 Aug 2021 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629293114;
        bh=EIgtZqd7EE46TdiAte/iRevKQQMOSJMFo/Qjgbovf+s=;
        h=From:To:Cc:Subject:Date:From;
        b=E90PsYncoa3RDYNupJkHXoyp4NFgH/TKLcdSfZFQubFlFW6FS8X+bo92d8kHTaa1j
         HFSSAyoWyJpPksoqrQt5v7z/UBsi2DHVA/FRO8sp8tm9UKno8/5e0KGMGP/7zBJsCm
         7NmXScyUOCVdBRZRWu8PnzpSTQ67HV1WNjfF/UP+z6hBxWbOhjXWoJTqCyiKxSyKft
         2pWczjhANfo5emuHOEKGL2Wa02A0POSnRBRMYRDh50+YDvGlhJC3SjYNOPqveYY5XG
         MeBoI7l4Topi1iXIF73LXnJUi3eb25WEc4P94zf1rsI1Vo4XgG3jhhvseEd+0+HqCm
         OqgxD03sQQXYA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Saravanan D <saravanand@fb.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] x86/sgx: Add SGX_MemTotal to /proc/meminfo
Date:   Wed, 18 Aug 2021 16:25:07 +0300
Message-Id: <20210818132509.545997-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The amount of SGX memory on the system is determined by the BIOS and it
varies wildly between systems.  It can be from dozens of MB's on desktops
or VM's, up to many GB's on servers.  Just like for regular memory, it is
sometimes useful to know the amount of usable SGX memory in the system.

Add SGX_MemTotal field to /proc/meminfo, which shows the total amount of
usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from
BIOS, the printout would be:

SGX_MemTotal:      22528 kB

It is less than 32 MB because some of the space is reserved for Enclave
Page Cache Metadata (EPCM), which contains state variables for all the
pages in the Enclave Page Cache (EPC).  The latter contains the pages,
which applications can use to create enclaves.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/x86/sgx.rst      |  6 ++++++
 arch/x86/include/asm/sgx.h     | 10 +++++++---
 arch/x86/kernel/cpu/sgx/main.c |  7 ++++++-
 arch/x86/mm/pat/set_memory.c   |  5 +++++
 4 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index dd0ac96ff9ef..68ee171e1d8f 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -250,3 +250,9 @@ user wants to deploy SGX applications both on the host and in guests
 on the same machine, the user should reserve enough EPC (by taking out
 total virtual EPC size of all SGX VMs from the physical EPC size) for
 host SGX applications so they can run with acceptable performance.
+
+Supplemental fields for /proc/meminfo
+=====================================
+
+SGX_MemTotal
+	The total usable SGX protected memory in kilobytes.
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 05f3e21f01a7..2ae9dc8c9411 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -365,6 +365,13 @@ struct sgx_sigstruct {
  * comment!
  */
 
+#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
+extern unsigned long sgx_nr_all_pages;
+
+int sgx_set_attribute(unsigned long *allowed_attributes,
+		      unsigned int attribute_fd);
+#endif
+
 #ifdef CONFIG_X86_SGX_KVM
 int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 		     int *trapnr);
@@ -372,7 +379,4 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
 		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
 #endif
 
-int sgx_set_attribute(unsigned long *allowed_attributes,
-		      unsigned int attribute_fd);
-
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..1fe26a8e80dc 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -28,7 +28,10 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
 static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
-/* The free page list lock protected variables prepend the lock. */
+/* The number of usable EPC pages in the system. */
+unsigned long sgx_nr_all_pages;
+
+/* The number of free EPC pages in all nodes. */
 static unsigned long sgx_nr_free_pages;
 
 /* Nodes with one or more EPC sections. */
@@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
+	sgx_nr_all_pages += nr_pages;
+
 	return true;
 }
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index ad8a5c586a35..82bb09c298de 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -29,6 +29,7 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/sgx.h>
 
 #include "../mm_internal.h"
 
@@ -116,6 +117,10 @@ void arch_report_meminfo(struct seq_file *m)
 	if (direct_gbpages)
 		seq_printf(m, "DirectMap1G:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_1G] << 20);
+
+#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
+	seq_printf(m, "SGX_MemTotal:   %8lu kB\n", sgx_nr_all_pages << 2);
+#endif
 }
 #else
 static inline void split_page_count(int level) { }
-- 
2.25.1

