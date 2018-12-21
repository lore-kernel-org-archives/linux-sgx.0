Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620F6C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FE612190A
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732065AbeLUXOn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:14:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:21194 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730803AbeLUXOm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:14:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:14:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338544"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:14:35 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v18 17/25] x86/mpx: pass @mm to kernel_managing_mpx_tables() in mpx_notify_unmap()
Date:   Sat, 22 Dec 2018 01:11:46 +0200
Message-Id: <20181221231154.6120-18-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

If @mm is not the same as current->mm, mpx_notify_unmap() will yield
invalid results and at worst will lead to a crash if it gets called by a
kthread.

The function in question gets called through do_munmap(). ATM kernel does
not use that function on x86 in such context that mm and current->mm would
differ

With the addition of SGX driver code, do_munmap() is called from workqueue
thread. This commit changes the parameter passed to @mm so that this will
yield the correct results and not crash as reference to current->mm would
be NULL in a kthread context.

Cc: Dave Hansen <dave.hansen@intel.com>
Fixes: 1de4fa14ee25 ("x86, mpx: Cleanup unused bound tables")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/mm/mpx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
index 2385538e8065..15fb62657ee9 100644
--- a/arch/x86/mm/mpx.c
+++ b/arch/x86/mm/mpx.c
@@ -882,7 +882,7 @@ static int mpx_unmap_tables(struct mm_struct *mm,
  * necessary, and the 'vma' is the first vma in this range (start -> end).
  */
 void mpx_notify_unmap(struct mm_struct *mm, struct vm_area_struct *vma,
-		unsigned long start, unsigned long end)
+		      unsigned long start, unsigned long end)
 {
 	int ret;
 
@@ -890,7 +890,7 @@ void mpx_notify_unmap(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * Refuse to do anything unless userspace has asked
 	 * the kernel to help manage the bounds tables,
 	 */
-	if (!kernel_managing_mpx_tables(current->mm))
+	if (!kernel_managing_mpx_tables(mm))
 		return;
 	/*
 	 * This will look across the entire 'start -> end' range,
-- 
2.19.1

