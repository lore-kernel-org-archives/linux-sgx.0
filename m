Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC92ECAAD8
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Sep 2022 06:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiITGgx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 20 Sep 2022 02:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiITGgV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 20 Sep 2022 02:36:21 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0782EE90
        for <linux-sgx@vger.kernel.org>; Mon, 19 Sep 2022 23:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663655671; x=1695191671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cGLYoUiOR1de/Gx/W8MZkGvfargWonvwxf3D5g9msVY=;
  b=S9Sql9STRUY16NmX81Rg57YxQXFBOKP6cb9P4Gy5J+02wVMlkBYigxd7
   bItvy0gNAKjZXZHcmJsnl2TgGCq5FypP9Yt8Lp8aJ+qEUdjeXFtz2duUA
   ykFKVrnjxOW3EJXfJ6adc23lozQWvC6NV+B6nIDbR9axF0htR9Z1OTShr
   Eya3Ll49gs1eZVssmLiBglUGFMsJO5csKt7KBgRpByUcNv4yybYkiY2ey
   9/0p6Qg/SJz/nx3PquDbOqLy98y83fxzRVyQb6SfJT0mbXvcy6LseF+h4
   xwocNVuAcyX1O5RO4F9WFy7MA+lk6FOc6HRlGh4iBoLJy9Ic2qbIrypfi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="297203983"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="297203983"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 23:34:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="947538029"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga005.fm.intel.com with ESMTP; 19 Sep 2022 23:34:28 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        kai.huang@intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com,
        zhiquan1.li@intel.com
Subject: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for virtualization
Date:   Tue, 20 Sep 2022 14:39:48 +0800
Message-Id: <20220920063948.3556917-4-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220920063948.3556917-1-zhiquan1.li@intel.com>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Today, if a guest accesses an SGX EPC page with memory failure,
the kernel behavior will kill the entire guest.  This blast
radius is too large.  It would be idea to kill only the SGX
application inside the guest.

To fix this, send a SIGBUS to host userspace (like QEMU) which can
follow up by injecting a #MC to the guest.

SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
being shared by multiple VMs via fork().  However KVM doesn't support
running a VM across multiple mm structures, and the de facto userspace
hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
this should not happen.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de76@intel.com/T/#m1d1f4098f4fad78034e8706a60e4d79c119db407
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

---
Changes since V8:
- Remove excess Acked-by.

Changes since V7:
- Add Acked-by from Jarkko.

Changes since V6:
- Fix build warning due to type changes.

Changes since V5:
- Use the 'vepc_vaddr' field instead of casting the 'owner' field.
- Clean up the commit message suggested by Dave.
  Link: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m2ff4778948cdc9ee65f09672f1d02f8dc467247b
- Add Reviewed-by from Jarkko.

Changes since V4:
- Switch the order of the two variables so all of variables are in
  reverse Christmas style.
- Do not initialize "ret" because it will be overridden by the return
  value of force_sig_mceerr() unconditionally.

Changes since V2:
- Retrieve virtual address from "owner" field of struct sgx_epc_page,
  instead of struct sgx_vepc_page.
- Replace EPC page flag SGX_EPC_PAGE_IS_VEPC with
  SGX_EPC_PAGE_KVM_GUEST as they are duplicated.

Changes since V1:
- Add Acked-by from Kai Huang.
- Add Kai's excellent explanation regarding to why we no need to
  consider that one virtual EPC be shared by two guests.
---
 arch/x86/kernel/cpu/sgx/main.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b319bedcaf1e..160c8dbee0ab 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -679,6 +679,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
 	struct sgx_epc_section *section;
 	struct sgx_numa_node *node;
+	void __user *vaddr;
+	int ret;
 
 	/*
 	 * mm/memory-failure.c calls this routine for all errors
@@ -695,8 +697,26 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	 * error. The signal may help the task understand why the
 	 * enclave is broken.
 	 */
-	if (flags & MF_ACTION_REQUIRED)
-		force_sig(SIGBUS);
+	if (flags & MF_ACTION_REQUIRED) {
+		/*
+		 * Provide extra info to the task so that it can make further
+		 * decision but not simply kill it. This is quite useful for
+		 * virtualization case.
+		 */
+		if (page->flags & SGX_EPC_PAGE_KVM_GUEST) {
+			/*
+			 * The 'encl_owner' field is repurposed, when allocating EPC
+			 * page it was assigned to the virtual address of virtual EPC
+			 * page.
+			 */
+			vaddr = (void *)((unsigned long)page->vepc_vaddr & PAGE_MASK);
+			ret = force_sig_mceerr(BUS_MCEERR_AR, vaddr, PAGE_SHIFT);
+			if (ret < 0)
+				pr_err("Memory failure: Error sending signal to %s:%d: %d\n",
+					current->comm, current->pid, ret);
+		} else
+			force_sig(SIGBUS);
+	}
 
 	section = &sgx_epc_sections[page->section];
 	node = section->node;
-- 
2.25.1

