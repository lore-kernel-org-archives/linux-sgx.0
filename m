Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F672C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 06:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79448206B6
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 06:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgENGbL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 02:31:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:49835 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgENGbL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 02:31:11 -0400
IronPort-SDR: w5MEMxDe8JA082gLyZjs/Ow0zwsnZZ595wB22nGdPB91UZActcPN2tWxzP2pozu6pw/QdJW1Q4
 ih9xd6bLipPg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 23:31:10 -0700
IronPort-SDR: ukTu972U4kZTuPkKUDyAXdvQit6t4PE8LwfYTVc7QV8wAvCPI2hleySWlWoWBJ5Ep3UNmyi0lW
 AyKYZZc0f6Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="307013804"
Received: from aburovox-mobl.ger.corp.intel.com (HELO localhost) ([10.249.39.145])
  by FMSMGA003.fm.intel.com with ESMTP; 13 May 2020 23:31:09 -0700
Date:   Thu, 14 May 2020 09:31:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH v2] x86/sgx: Hack in idea for allocating from local EPC
 node when possible
Message-ID: <20200514063108.GD5377@linux.intel.com>
References: <20200514051036.14552-1-sean.j.christopherson@intel.com>
 <20200514063021.GC5377@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514063021.GC5377@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 14, 2020 at 09:30:24AM +0300, Jarkko Sakkinen wrote:
> On Wed, May 13, 2020 at 10:10:36PM -0700, Sean Christopherson wrote:
> > Allocate EPC from the local node when possible.  There is no new NUMA
> > enumeration for EPC.  Because EPC is carved out of RAM on bare metal,
> > the sections are naturally covered by the existing ACPI SRAT entries,
> > i.e. can be found by querying the kernel's NUMA info.
> > 
> > Keep the per-section tracking to simplify iterating over all sections
> > and reverse lookups given an EPC page.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> > 
> > I like this version a lot more.  Far less clever and doesn't assume
> > anything about number of EPC sections vs. NUMA nodes.
> > 
> > As before, compile tested only.
> > 
> > For folks (especially non-Intel people) who may be confused, this is a
> > less-than-an-RFC patch to frame in an idea for adding basic NUMA awareness
> > for EPC sections without (yet) supporting full mempolicy stuff.
> > 
> >  arch/x86/kernel/cpu/sgx/main.c    | 95 +++++++++++++++++++++++++------
> >  arch/x86/kernel/cpu/sgx/reclaim.c |  6 +-
> >  arch/x86/kernel/cpu/sgx/sgx.h     |  6 +-
> >  3 files changed, 84 insertions(+), 23 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 5ce77e5546766..3128b4fa5ff4f 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -11,7 +11,15 @@
> >  #include "driver.h"
> >  #include "encls.h"
> >  
> > -struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> > +struct sgx_epc_node {
> > +	struct sgx_epc_section sections[SGX_MAX_EPC_SECTIONS];
> > +	int nr_sections;
> > +};
> > +
> > +static struct sgx_epc_node sgx_epc_nodes[MAX_NUMNODES];
> > +static int sgx_nr_epc_nodes;
> > +
> > +struct sgx_epc_section *sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> >  int sgx_nr_epc_sections;
> >  
> >  static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section)
> > @@ -28,23 +36,15 @@ static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section
> >  	return page;
> >  }
> >  
> > -/**
> > - * sgx_try_alloc_page() - Allocate an EPC page
> > - *
> > - * Try to grab a page from the free EPC page list.
> > - *
> > - * Return:
> > - *   a pointer to a &struct sgx_epc_page instance,
> > - *   -errno on error
> > - */
> > -struct sgx_epc_page *sgx_try_alloc_page(void)
> > +static struct sgx_epc_page *sgx_try_alloc_page_node(int nid)
> >  {
> > +	struct sgx_epc_node *node = &sgx_epc_nodes[nid];
> >  	struct sgx_epc_section *section;
> >  	struct sgx_epc_page *page;
> >  	int i;
> >  
> > -	for (i = 0; i < sgx_nr_epc_sections; i++) {
> > -		section = &sgx_epc_sections[i];
> > +	for (i = 0; i < node->nr_sections; i++) {
> > +		section = &node->sections[i];
> >  		spin_lock(&section->lock);
> >  		page = __sgx_try_alloc_page(section);
> >  		spin_unlock(&section->lock);
> > @@ -53,6 +53,41 @@ struct sgx_epc_page *sgx_try_alloc_page(void)
> >  			return page;
> >  	}
> >  
> > +	return NULL;
> > +}
> > +
> > +/**
> > + * sgx_try_alloc_page() - Allocate an EPC page
> > + *
> > + * Try to grab a page from the free EPC page list.
> > + *
> > + * Return:
> > + *   a pointer to a &struct sgx_epc_page instance,
> > + *   -errno on error
> > + */
> > +struct sgx_epc_page *sgx_try_alloc_page(void)
> > +{
> > +	struct sgx_epc_page *page;
> > +	int nid = numa_node_id();
> 
> This means that CONFIG_NUMA is not really needed.

I'll refine the patch with this premise, should turn out to be somewhat
simple.

/Jarkko
