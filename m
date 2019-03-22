Return-Path: <SRS0=8iz8=RZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C39FC43381
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 10:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F3D121916
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 10:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfCVKTv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Mar 2019 06:19:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:56929 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbfCVKTu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Mar 2019 06:19:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 03:19:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="127672945"
Received: from vanderss-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.199])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2019 03:19:41 -0700
Date:   Fri, 22 Mar 2019 12:19:40 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 12/27] x86/sgx: Enumerate and track EPC sections
Message-ID: <20190322101940.GC3122@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-13-jarkko.sakkinen@linux.intel.com>
 <20190318195043.GA20298@linux.intel.com>
 <20190321144056.GM4603@linux.intel.com>
 <20190321152810.GC6519@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321152810.GC6519@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 21, 2019 at 08:28:10AM -0700, Sean Christopherson wrote:
> On Thu, Mar 21, 2019 at 04:40:56PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Mar 18, 2019 at 12:50:43PM -0700, Sean Christopherson wrote:
> > > On Sun, Mar 17, 2019 at 11:14:41PM +0200, Jarkko Sakkinen wrote:
> > > Dynamically allocating sgx_epc_sections isn't exactly difficult, and
> > > AFAICT the static allocation is the primary motivation for capping
> > > SGX_MAX_EPC_SECTIONS at such a low value (8).  I still think it makes
> > > sense to define SGX_MAX_EPC_SECTIONS so that the section number can
> > > be embedded in the offset, along with flags.  But the max can be
> > > significantly higher, e.g. using 7 bits to support 128 sections.
> > > 
> > 
> > I don't disagree with you but I think for the existing and forseeable
> > hardware this is good enough. Can be refined if there is ever need.
> 
> My concern is that there may be virtualization use cases that want to
> expose more than 8 EPC sections to a guest.  I have no idea if this is
> anything more than paranoia, but at the same time the cost to increase
> support to 128+ sections is quite low.
> 
> > > I realize hardware is highly unlikely to have more than 8 sections, at
> > > least for the near future, but IMO the small amount of extra complexity
> > > is worth having a bit of breathing room.
> > 
> > Yup.
> > 
> > > > +static __init int sgx_init_epc_section(u64 addr, u64 size, unsigned long index,
> > > > +				       struct sgx_epc_section *section)
> > > > +{
> > > > +	unsigned long nr_pages = size >> PAGE_SHIFT;
> > > > +	struct sgx_epc_page *page;
> > > > +	unsigned long i;
> > > > +
> > > > +	section->va = memremap(addr, size, MEMREMAP_WB);
> > > > +	if (!section->va)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	section->pa = addr;
> > > > +	spin_lock_init(&section->lock);
> > > > +	INIT_LIST_HEAD(&section->page_list);
> > > > +
> > > > +	for (i = 0; i < nr_pages; i++) {
> > > > +		page = kzalloc(sizeof(*page), GFP_KERNEL);
> > > > +		if (!page)
> > > > +			goto out;
> > > > +		page->desc = (addr + (i << PAGE_SHIFT)) | index;
> > > > +		sgx_section_put_page(section, page);
> > > > +	}
> > > 
> > > Not sure if this is the correct location, but at some point the kernel
> > > needs to sanitize the EPC during init.  EPC pages may be in an unknown
> > > state, e.g. after kexec(), which will cause all manner of faults and
> > > warnings.  Maybe the best approach is to sanitize on-demand, e.g. suppress
> > > the first WARN due to unexpected ENCLS failure and purge the EPC at that
> > > time.  The downside of that approach is that exposing EPC to a guest would
> > > need to implement its own sanitization flow.
> > 
> > Hmm... Lets think this through. I'm just thinking how sanitization on
> > demand would actually work given the parent-child relationships.
> 
> It's ugly.
> 
>   1. Temporarily disable EPC allocation and enclave fault handling
>   2. Zap all TCS PTEs in all enclaves
>   3. Flush all logical CPUs from enclaves via IPI
>   4. Forcefully reclaim all EPC pages from enclaves
>   5. EREMOVE all "free" EPC pages, track pages that fail with SGX_CHILD_PRESENT
>   6. EREMOVE all EPC pages that failed with SGX_CHILD_PRESENT
>   7. Disable SGX if any EREMOVE failed in step 6
>   8. Re-enable EPC allocation and enclave fault handling
> 
> Exposing EPC to a VM would still require sanitization.
> 
> Sanitizing during boot is a lot cleaner, the primary concern is that it
> will significantly increase boot time on systems with large EPCs.  If we
> can somehow limit this to kexec() and that's the only scenario where the
> EPC needs to be sanitized, then that would mitigate the boot time concern.
> 
> We might also be able to get away with unconditionally sanitizing the EPC
> post-boot, e.g. via worker threads, returning -EBUSY for everything until
> the EPC is good to go.

I like the worker threads approach better. It is something that is
maintainable. I don't see any better solution given the hierarchical
nature of enclaves. It is also fairly to implement without making
major changes to the other parts of the implementation.

I.e. every time the driver initializes:

1. Move all EPC first to a bad pool.
2. Let worker threads move EPC to the real allocation pool.

Then the OS can immediately start to use EPC.

Is this about along the lines what you had in mind?

/Jarkko
