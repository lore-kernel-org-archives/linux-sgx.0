Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2EDC4338F
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 12:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 442D360F5E
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 12:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239249AbhHSMtJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhHSMtI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Aug 2021 08:49:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D39361154;
        Thu, 19 Aug 2021 12:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629377312;
        bh=xIQ/zVqxRG/q7zsWF4vebQ5bnJmagrf+yNKkdMIvQAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6oz3OBfmcYPf8GHcWhS87HrdGq07GcxI1UkNO5Dq/veO0GikBMoR4D3IFLXNaaLs
         UbXglUgFQLjeNYc3lo9vtPjkMN6SS5zemcCDzF0d2b1NSqczfdSb9hX8SV4u3zFXOW
         Jp48lbIbMRiS6ScMx0J6oy+8XehJE3Wv/y7XtzFEa/9MjN/slArOZ+ntMewoMRuC/J
         kt4FDLhD9voqPZKG5m4oCRUIqX4IL/Zzg6ZPVqWFdl2rP3+C2mFnkIxwD5EsrIpU6r
         iSOwVUor9t4SobtP46IKgoIyDk4MApAOThcLEdy78N/l5zCe1cXl0QR5fQzIlWHxc9
         aUa6pAoEYGTeg==
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
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Saravanan D <saravanand@fb.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
Date:   Thu, 19 Aug 2021 15:48:24 +0300
Message-Id: <20210819124824.52169-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819124824.52169-1-jarkko@kernel.org>
References: <20210819124824.52169-1-jarkko@kernel.org>
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
index 38c397ef35a8..2ae9dc8c9411 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -366,6 +366,8 @@ struct sgx_sigstruct {
  */
 
 #if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
+extern unsigned long sgx_nr_all_pages;
+
 int sgx_set_attribute(unsigned long *allowed_attributes,
 		      unsigned int attribute_fd);
 #endif
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

