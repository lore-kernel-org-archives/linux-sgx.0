Return-Path: <SRS0=sWWJ=7K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7492BC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 01:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CC6C2078C
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 01:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgE1BXc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 May 2020 21:23:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:38741 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgE1BXb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 May 2020 21:23:31 -0400
IronPort-SDR: E8aktFxO/gwpocDw2/sjRk4LFGYAnb2uqYnSISjQBY7MATiPfboDOcSqiTtpsvy5yO1QIUO7S0
 DDWRrtw7Ol6Q==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 18:23:30 -0700
IronPort-SDR: NGyjpN/SxYtMmRAZ7PoIsAytx8WAUyQ+JgCrWDFkqig0EJrEiVtkET7fJM1IWAUPHWjxGo4QBg
 SFfH6BAEp4lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208,223";a="285002293"
Received: from ederaloi-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.44.51])
  by orsmga002.jf.intel.com with ESMTP; 27 May 2020 18:23:21 -0700
Date:   Thu, 28 May 2020 04:23:19 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 08/20] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20200528012319.GA7577@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
 <20200526125207.GE28228@zn.tnic>
 <20200527042111.GI31696@linux.intel.com>
 <20200527204638.GG1721@zn.tnic>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20200527204638.GG1721@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 27, 2020 at 10:46:38PM +0200, Borislav Petkov wrote:
> On Tue, May 26, 2020 at 09:21:11PM -0700, Sean Christopherson wrote:
> > In other words, sgx_alloc_epc_section() is poorly named.  It doesn't
> > actually allocate EPC, it allocates kernel structures to map and track EPC.
> > sgx_(un)map_epc_section() would be more accurate and would hopefully
> > alleviate some of the confusion.
> 
> Makes sense.
> 
> > I have no objection to renaming __sgx_alloc_try_alloc_page() to something
> > like sgx_alloc_epc_page_section or whatever, but IMO using get/put will be
> > horrendously confusing.
> 
> Ok. My only issue is that the naming nomenclature sounds strange and
> confusing as it is. "try" in an "alloc" function is kinda tautological -
> of course the function will try to do its best. :)
> 
> And there are three functions having "alloc" in the name so I can
> imagine someone getting very confused when having to stare at that code.
> 
> So at least naming them in a way so that it is clear what kind of pages
> they "allocate" - i.e., what they actually do - would be a step in the
> right direction...
> 
> Thx.

I also think sgx_get_epc_page() is also kind of confusing name. The
reason is that "get" can many things.

I'm not sure I follow fully Sean's reasoning but the way alloc is used
mostly in Linux is to ask through some API the used kernel memory
allocator to give memory for some kernel data structures.

Agreed that it is not the best match on what we are doing.

The first common verb that comes to my mind about the action taken is
grabbing. Attached a patch reflecting this idea that I'm ready to
squash.

/Jarkko

--PEIAKu/WMn1b1Hv9
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-x86-sgx-sgx_alloc_page-to-sgx_grab_page.patch"

From 2598b920fc917790966ba314a2df524ff4695c75 Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Date: Thu, 28 May 2020 04:21:08 +0300
Subject: [PATCH] x86/sgx: sgx_alloc_page() to sgx_grab_page()

$ git  grep -l sgx_alloc_page | xargs sed -i 's/sgx_alloc_page/sgx_grab_page/g'
$ git  grep -l sgx_try_alloc_page | xargs sed -i 's/sgx_try_alloc_page/sgx_try_grab_page/g'

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c  |  6 +++---
 arch/x86/kernel/cpu/sgx/ioctl.c |  4 ++--
 arch/x86/kernel/cpu/sgx/main.c  | 14 +++++++-------
 arch/x86/kernel/cpu/sgx/sgx.h   |  4 ++--
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index c070aa90b5fe..fab2a8aec410 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -67,7 +67,7 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_page(encl_page, false);
+	epc_page = sgx_grab_page(encl_page, false);
 	if (IS_ERR(epc_page))
 		return epc_page;
 
@@ -686,7 +686,7 @@ struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
 }
 
 /**
- * sgx_alloc_page - allocate a VA page
+ * sgx_grab_page - allocate a VA page
  *
  * Allocates an &sgx_epc_page instance and converts it to a VA page.
  *
@@ -699,7 +699,7 @@ struct sgx_epc_page *sgx_alloc_va_page(void)
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_page(NULL, true);
+	epc_page = sgx_grab_page(NULL, true);
 	if (IS_ERR(epc_page))
 		return ERR_CAST(epc_page);
 
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 81b6c5d64c96..c880dc40310c 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -183,7 +183,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 
 	encl->backing = backing;
 
-	secs_epc = sgx_alloc_page(&encl->secs, true);
+	secs_epc = sgx_grab_page(&encl->secs, true);
 	if (IS_ERR(secs_epc)) {
 		ret = PTR_ERR(secs_epc);
 		goto err_out_backing;
@@ -376,7 +376,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	if (IS_ERR(encl_page))
 		return PTR_ERR(encl_page);
 
-	epc_page = sgx_alloc_page(encl_page, true);
+	epc_page = sgx_grab_page(encl_page, true);
 	if (IS_ERR(epc_page)) {
 		kfree(encl_page);
 		return PTR_ERR(epc_page);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5ce77e554676..b5cd941861bc 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -14,7 +14,7 @@
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 int sgx_nr_epc_sections;
 
-static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section)
+static struct sgx_epc_page *__sgx_try_grab_page(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
 
@@ -29,7 +29,7 @@ static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section
 }
 
 /**
- * sgx_try_alloc_page() - Allocate an EPC page
+ * sgx_try_grab_page() - Allocate an EPC page
  *
  * Try to grab a page from the free EPC page list.
  *
@@ -37,7 +37,7 @@ static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section
  *   a pointer to a &struct sgx_epc_page instance,
  *   -errno on error
  */
-struct sgx_epc_page *sgx_try_alloc_page(void)
+struct sgx_epc_page *sgx_try_grab_page(void)
 {
 	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
@@ -46,7 +46,7 @@ struct sgx_epc_page *sgx_try_alloc_page(void)
 	for (i = 0; i < sgx_nr_epc_sections; i++) {
 		section = &sgx_epc_sections[i];
 		spin_lock(&section->lock);
-		page = __sgx_try_alloc_page(section);
+		page = __sgx_try_grab_page(section);
 		spin_unlock(&section->lock);
 
 		if (page)
@@ -57,7 +57,7 @@ struct sgx_epc_page *sgx_try_alloc_page(void)
 }
 
 /**
- * sgx_alloc_page() - Allocate an EPC page
+ * sgx_grab_page() - Allocate an EPC page
  * @owner:	the owner of the EPC page
  * @reclaim:	reclaim pages if necessary
  *
@@ -69,12 +69,12 @@ struct sgx_epc_page *sgx_try_alloc_page(void)
  *   a pointer to a &struct sgx_epc_page instance,
  *   -errno on error
  */
-struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
+struct sgx_epc_page *sgx_grab_page(void *owner, bool reclaim)
 {
 	struct sgx_epc_page *entry;
 
 	for ( ; ; ) {
-		entry = sgx_try_alloc_page();
+		entry = sgx_try_grab_page();
 		if (!IS_ERR(entry)) {
 			entry->owner = owner;
 			break;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 0c481e6f2c95..84198c17e766 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -101,8 +101,8 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
 int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
 void sgx_reclaim_pages(void);
 
-struct sgx_epc_page *sgx_try_alloc_page(void);
-struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
+struct sgx_epc_page *sgx_try_grab_page(void);
+struct sgx_epc_page *sgx_grab_page(void *owner, bool reclaim);
 void sgx_free_page(struct sgx_epc_page *page);
 
 #endif /* _X86_SGX_H */
-- 
2.25.1


--PEIAKu/WMn1b1Hv9--
