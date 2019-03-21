Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31580C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 15:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00254218D4
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 15:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfCUP2L (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:28:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:65137 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfCUP2L (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 11:28:11 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 08:28:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,253,1549958400"; 
   d="scan'208";a="216247920"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga001.jf.intel.com with ESMTP; 21 Mar 2019 08:28:10 -0700
Date:   Thu, 21 Mar 2019 08:28:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 12/27] x86/sgx: Enumerate and track EPC sections
Message-ID: <20190321152810.GC6519@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-13-jarkko.sakkinen@linux.intel.com>
 <20190318195043.GA20298@linux.intel.com>
 <20190321144056.GM4603@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321144056.GM4603@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 21, 2019 at 04:40:56PM +0200, Jarkko Sakkinen wrote:
> On Mon, Mar 18, 2019 at 12:50:43PM -0700, Sean Christopherson wrote:
> > On Sun, Mar 17, 2019 at 11:14:41PM +0200, Jarkko Sakkinen wrote:
> > Dynamically allocating sgx_epc_sections isn't exactly difficult, and
> > AFAICT the static allocation is the primary motivation for capping
> > SGX_MAX_EPC_SECTIONS at such a low value (8).  I still think it makes
> > sense to define SGX_MAX_EPC_SECTIONS so that the section number can
> > be embedded in the offset, along with flags.  But the max can be
> > significantly higher, e.g. using 7 bits to support 128 sections.
> > 
> 
> I don't disagree with you but I think for the existing and forseeable
> hardware this is good enough. Can be refined if there is ever need.

My concern is that there may be virtualization use cases that want to
expose more than 8 EPC sections to a guest.  I have no idea if this is
anything more than paranoia, but at the same time the cost to increase
support to 128+ sections is quite low.

> > I realize hardware is highly unlikely to have more than 8 sections, at
> > least for the near future, but IMO the small amount of extra complexity
> > is worth having a bit of breathing room.
> 
> Yup.
> 
> > > +static __init int sgx_init_epc_section(u64 addr, u64 size, unsigned long index,
> > > +				       struct sgx_epc_section *section)
> > > +{
> > > +	unsigned long nr_pages = size >> PAGE_SHIFT;
> > > +	struct sgx_epc_page *page;
> > > +	unsigned long i;
> > > +
> > > +	section->va = memremap(addr, size, MEMREMAP_WB);
> > > +	if (!section->va)
> > > +		return -ENOMEM;
> > > +
> > > +	section->pa = addr;
> > > +	spin_lock_init(&section->lock);
> > > +	INIT_LIST_HEAD(&section->page_list);
> > > +
> > > +	for (i = 0; i < nr_pages; i++) {
> > > +		page = kzalloc(sizeof(*page), GFP_KERNEL);
> > > +		if (!page)
> > > +			goto out;
> > > +		page->desc = (addr + (i << PAGE_SHIFT)) | index;
> > > +		sgx_section_put_page(section, page);
> > > +	}
> > 
> > Not sure if this is the correct location, but at some point the kernel
> > needs to sanitize the EPC during init.  EPC pages may be in an unknown
> > state, e.g. after kexec(), which will cause all manner of faults and
> > warnings.  Maybe the best approach is to sanitize on-demand, e.g. suppress
> > the first WARN due to unexpected ENCLS failure and purge the EPC at that
> > time.  The downside of that approach is that exposing EPC to a guest would
> > need to implement its own sanitization flow.
> 
> Hmm... Lets think this through. I'm just thinking how sanitization on
> demand would actually work given the parent-child relationships.

It's ugly.

  1. Temporarily disable EPC allocation and enclave fault handling
  2. Zap all TCS PTEs in all enclaves
  3. Flush all logical CPUs from enclaves via IPI
  4. Forcefully reclaim all EPC pages from enclaves
  5. EREMOVE all "free" EPC pages, track pages that fail with SGX_CHILD_PRESENT
  6. EREMOVE all EPC pages that failed with SGX_CHILD_PRESENT
  7. Disable SGX if any EREMOVE failed in step 6
  8. Re-enable EPC allocation and enclave fault handling

Exposing EPC to a VM would still require sanitization.

Sanitizing during boot is a lot cleaner, the primary concern is that it
will significantly increase boot time on systems with large EPCs.  If we
can somehow limit this to kexec() and that's the only scenario where the
EPC needs to be sanitized, then that would mitigate the boot time concern.

We might also be able to get away with unconditionally sanitizing the EPC
post-boot, e.g. via worker threads, returning -EBUSY for everything until
the EPC is good to go.

> 
> > 
> > > +
> > > +	return 0;
> > > +out:
> > > +	sgx_free_epc_section(section);
> > > +	return -ENOMEM;
> > > +}
> > > +
> > > +static __init void sgx_page_cache_teardown(void)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0; i < sgx_nr_epc_sections; i++)
> > > +		sgx_free_epc_section(&sgx_epc_sections[i]);
> > > +}
> > > +
> > > +/**
> > > + * A section metric is concatenated in a way that @low bits 12-31 define the
> > > + * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
> > > + * metric.
> > > + */
> > > +static inline u64 sgx_calc_section_metric(u64 low, u64 high)
> > > +{
> > > +	return (low & GENMASK_ULL(31, 12)) +
> > > +	       ((high & GENMASK_ULL(19, 0)) << 32);
> > > +}
> > > +
> > > +static __init int sgx_page_cache_init(void)
> > > +{
> > > +	u32 eax, ebx, ecx, edx, type;
> > > +	u64 pa, size;
> > > +	int ret;
> > > +	int i;
> > > +
> > > +	BUILD_BUG_ON(SGX_MAX_EPC_SECTIONS > (SGX_EPC_SECTION_MASK + 1));
> > > +
> > > +	for (i = 0; i < (SGX_MAX_EPC_SECTIONS + 1); i++) {
> > > +		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
> > > +			    &eax, &ebx, &ecx, &edx);
> > > +
> > > +		type = eax & SGX_CPUID_SUB_LEAF_TYPE_MASK;
> > > +		if (type == SGX_CPUID_SUB_LEAF_INVALID)
> > > +			break;
> > > +		if (type != SGX_CPUID_SUB_LEAF_EPC_SECTION) {
> > > +			pr_err_once("sgx: Unknown sub-leaf type: %u\n", type);
> > > +			return -ENODEV;
> > 
> > This should probably be "continue" rather than "return -ENODEV".  SGX
> > can still be used in the (extremely) unlikely event that there is usable
> > EPC and some unknown memory type enumerated.
> 
> OK, lets do that. Maybe also pr_warn_once() should be used?

Yeah, probably.  If we use pr_warn here, then we should also convert
pr_err("sgx: There are zero EPC sections.\n"); to use pr_warn() since
that'll likely fire at the same time.

> 
> > 
> > > +		}
> > > +		if (i == SGX_MAX_EPC_SECTIONS) {
> > > +			pr_warn("sgx: More than "
> > > +				__stringify(SGX_MAX_EPC_SECTIONS)
> > > +				" EPC sections\n");
> > 
> > This isn't a very helpful message, e.g. it doesn't even imply that the
> > kernel is ignoring EPC sections.  It'd also be helpful to display the
> > sections that are being ignored.  Might also warrant pr_err() since it
> > means system resources are being ignored.
> > 
> > E.g.:
> > 
> > #define SGX_ARBITRARY_LOOP_TERMINATOR   1000
> > 
> > 	for (i = 0; i < SGX_ARBITRARY_LOOP_TERMINATOR; i++) {
> > 		...
> > 
> > 		if (i >= SGX_MAX_EPC_SECTIONS) {
> > 			pr_err("sgx: Reached max number of EPC sections (%u), "
> > 			       "ignoring section 0x%llx-0x%llx\n",
> > 			       pa, pa + size - 1);
> > 		}
> 
> Fully agree with these proposals!
> 
> > 	}
> > 
> > > +			break;
> > > +		}
> > > +
> > > +		pa = sgx_calc_section_metric(eax, ebx);
> > > +		size = sgx_calc_section_metric(ecx, edx);
> > > +		pr_info("sgx: EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
> > > +
> > > +		ret = sgx_init_epc_section(pa, size, i, &sgx_epc_sections[i]);
> > > +		if (ret) {
> > > +			sgx_page_cache_teardown();
> > > +			return ret;
> > 
> > Similar to encountering unknown sections, any reason why we wouldn't
> > continue here and use whatever EPC was successfuly initialized?
> 
> Nope.
> 
> > 
> > > +		}
> > > +
> > > +		sgx_nr_epc_sections++;
> > > +	}
> > > +
> > > +	if (!sgx_nr_epc_sections) {
> > > +		pr_err("sgx: There are zero EPC sections.\n");
> > > +		return -ENODEV;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
