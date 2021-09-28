Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD58C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 20:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D936139D
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 20:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242604AbhI1UzZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 28 Sep 2021 16:55:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:54496 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242572AbhI1UzY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 28 Sep 2021 16:55:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224841541"
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="224841541"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 13:53:44 -0700
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="706832827"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 13:53:44 -0700
Date:   Tue, 28 Sep 2021 13:53:43 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: [PATCH v7 3/7] x86/sgx: Initial poison handling for dirty and
 free pages
Message-ID: <YVOA1/AFFXmR6Uiw@agluck-desk2.amr.corp.intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
 <20210927213452.212470-1-tony.luck@intel.com>
 <20210927213452.212470-4-tony.luck@intel.com>
 <3efcda381b49651004e230f6ef008032842db1f9.camel@kernel.org>
 <ca3bb671a49141608ac981012091c3ea@intel.com>
 <1702295227b9276e051a0efee8af1475cba27407.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1702295227b9276e051a0efee8af1475cba27407.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 28, 2021 at 11:11:30PM +0300, Jarkko Sakkinen wrote:
> On Tue, 2021-09-28 at 15:41 +0000, Luck, Tony wrote:
> > > > Add debugfs files /sys/kernel/debug/sgx/poison_page_list so that system
> > > > administrators get a list of those pages that have been dropped because
> > > > of poison.
> > > 
> > > So, what would a sysadmin do with that detailed information?
> > 
> > It's going to be a rare case that there are any poisoned pages on that list
> > (a large enough cluster will have some systems that have uncorrected
> > recoverable errors in SGX EPC memory).
> > 
> > Even when there are some poisoned pages, there will only be a few. Systems
> > that have thousands of pages with uncorrected memory errors will surely crash
> > because one of those errors is going to either trigger an error marked as fatal,
> > or the error won’t be recoverable by Linux because it is in kernel memory.
> > 
> > A sysadmin might add a script to run during system shutdown (or periodically
> > during run-time) to save the poison page list. Then at startup run:
> > 
> > for addr in `cat saved_sgx_poison_page_list`
> > do
> > 	echo $addr > /sys/devices/system/memory/hard_offline_page
> > done
> > 
> > to make poison persistent across reboots.
> > 
> > -Tony
> 
> Couldn't it be a blob with 8 bytes for each address?

It could be a blob. But that would require some perl/python
instead of simple shell to do the above persistence trick.

Or I could just drop the debugfs interface from this patch,
waiting until some use case for the data is fleshed out so
that it can be done in the most sensible way for that use case.

Untested updated patch below.

-Tony

From 551fbc5822e8faf93ff53f0a2b2448b0b98f1dde Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Mon, 27 Sep 2021 13:26:06 -0700
Subject: [PATCH] x86/sgx: Initial poison handling for dirty and free pages

A memory controller patrol scrubber can report poison in a page
that isn't currently being used.

Add "poison" field in the sgx_epc_page that can be set for an
sgx_epc_page. Check for it:
1) When sanitizing dirty pages
2) When freeing epc pages

Poison is a new field separated from flags to avoid having to make
all updates to flags atomic, or integrate poison state changes into
some other locking scheme to protect flags.

In both cases place the poisoned page on a list of poisoned epc pages
to make sure it will not be reallocated.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 14 +++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 09fa42690ff2..653bace26100 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -43,6 +43,7 @@ static nodemask_t sgx_numa_mask;
 static struct sgx_numa_node *sgx_numa_nodes;
 
 static LIST_HEAD(sgx_dirty_page_list);
+static LIST_HEAD(sgx_poison_page_list);
 
 /*
  * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
@@ -62,6 +63,12 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
 
 		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
 
+		if (page->poison) {
+			list_del(&page->list);
+			list_add(&page->list, &sgx_poison_page_list);
+			continue;
+		}
+
 		ret = __eremove(sgx_get_epc_virt_addr(page));
 		if (!ret) {
 			/*
@@ -626,7 +633,11 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 
 	spin_lock(&node->lock);
 
-	list_add_tail(&page->list, &node->free_page_list);
+	page->owner = NULL;
+	if (page->poison)
+		list_add(&page->list, &sgx_poison_page_list);
+	else
+		list_add_tail(&page->list, &node->free_page_list);
 	sgx_nr_free_pages++;
 	page->flags = 0;
 
@@ -658,6 +669,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		section->pages[i].section = index;
 		section->pages[i].flags = SGX_EPC_PAGE_IN_USE;
 		section->pages[i].owner = NULL;
+		section->pages[i].poison = 0;
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index f9202d3d6278..a990a4c9a00f 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -31,7 +31,8 @@
 
 struct sgx_epc_page {
 	unsigned int section;
-	unsigned int flags;
+	u16 flags;
+	u16 poison;
 	struct sgx_encl_page *owner;
 	struct list_head list;
 };
-- 
2.31.1

