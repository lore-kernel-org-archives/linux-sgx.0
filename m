Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F340C432BE
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Aug 2021 23:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A34610A7
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Aug 2021 23:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhHYXx0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Aug 2021 19:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhHYXx0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Aug 2021 19:53:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A784D61101;
        Wed, 25 Aug 2021 23:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629935560;
        bh=2J2pSA9thXsSjhup1CAV2YxmdPx4Eg9gANJwKe6Itpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6G0XMtprnOLvrnCs/I5fQkmK469SX5c9DbwQLQdSliinv57v+wiQ0KstFal1DRVk
         GcYGdwmGCgV+ge03tUp8DyRELVlJHqLkUWeA/Lpq9pYj5d/Th0yA7pQEB6ZD+3EcTK
         gKfKas4HVFa7f4LqWwm2r2VQMSIgYH6j0I015uzXIOENODOH56tiDSCEU6usWxILRb
         w0hxUv4k9hXoDC2IjnrAmpOcoeuvXbNhkmT0184DcG5PfEL7GmjPsTq7x5mBj5y7tD
         8eGRuC9xTNEcDl6P0nKNbHMKYmF3hWA1Az3X3u7uqkps5GyYr4SoYZQzdHZdn5g6KE
         led5s3UH4f1kw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v3 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
Date:   Thu, 26 Aug 2021 02:52:33 +0300
Message-Id: <20210825235234.153013-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210825235234.153013-1-jarkko@kernel.org>
References: <20210825235234.153013-1-jarkko@kernel.org>
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
v2:
* Move ifdef fix for sgx_set_attribute() to a separate patch.
---
 Documentation/x86/sgx.rst      | 6 ++++++
 arch/x86/include/asm/sgx.h     | 2 ++
 arch/x86/kernel/cpu/sgx/main.c | 7 ++++++-
 arch/x86/mm/pat/set_memory.c   | 5 +++++
 4 files changed, 19 insertions(+), 1 deletion(-)

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
index 996e56590a10..d8e526b5487b 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -367,6 +367,8 @@ struct sgx_sigstruct {
 
 #ifdef CONFIG_X86_SGX
 
+extern unsigned long sgx_nr_all_pages;
+
 int sgx_set_attribute(unsigned long *allowed_attributes,
 		      unsigned int attribute_fd);
 
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

