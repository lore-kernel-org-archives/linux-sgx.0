Return-Path: <SRS0=axKZ=AT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FC6C433DF
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jul 2020 22:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22E1B206DF
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jul 2020 22:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGHW4t (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jul 2020 18:56:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:18722 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgGHW4s (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 8 Jul 2020 18:56:48 -0400
IronPort-SDR: NkHbaKtR/W1R9HHqcytVc0RouyJwf+h7eH8/kJvsaV+tckRFOsBaFrDcaPaLaLZ4oDtaliCCIl
 kNPDICwFjOOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="127498496"
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="127498496"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 15:56:47 -0700
IronPort-SDR: /auNzKhh+AO4yI81ZDRh49U1dmLrMxI7i1dpQov7WHos3zFuA9nebDYYxIkBC97DzZgEFOlh19
 ypKq3d6y3tvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="297870575"
Received: from herbergs-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.31])
  by orsmga002.jf.intel.com with ESMTP; 08 Jul 2020 15:56:35 -0700
Date:   Thu, 9 Jul 2020 01:56:33 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v34 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200708225633.GA590299@linux.intel.com>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-11-jarkko.sakkinen@linux.intel.com>
 <20200707031424.GD25523@casper.infradead.org>
 <20200707032254.GB5208@linux.intel.com>
 <20200707032408.GE25523@casper.infradead.org>
 <20200707040151.GA143804@linux.intel.com>
 <20200707041046.GI25523@casper.infradead.org>
 <20200708143320.GD538949@linux.intel.com>
 <20200708143708.GR25523@casper.infradead.org>
 <20200708161027.GA549022@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708161027.GA549022@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 08, 2020 at 07:10:27PM +0300, Jarkko Sakkinen wrote:
> On Wed, Jul 08, 2020 at 03:37:08PM +0100, Matthew Wilcox wrote:
> > On Wed, Jul 08, 2020 at 05:33:20PM +0300, Jarkko Sakkinen wrote:
> > > I get the point but I don't think that your proposal could work given
> > > that mprotect-callback takes neither 'prev' nor 'newflags' as its
> > > parameters. The current callback has no means to call mprotect_fixup()
> > > properly.
> > > 
> > > It would have to be extended
> > > 
> > > 	int (*mprotect)(struct vm_area_struct *vma,
> > > 			struct vm_area_struct **pprev, unsigned long start,
> > > 			unsigned long end, unsigned long prot,
> > > 			unsigned long newflags);
> > > 
> > > Is this what you want?
> > 
> > https://lore.kernel.org/linux-mm/20200625173050.GF7703@casper.infradead.org/
> 
> Ugh, it's there as it should be. I'm sorry - I just misread the code.
> 
> I think that should work, and we do not have to do extra conversion
> inside the callback.
> 
> There is still one thing that I'm wondering. 'page->vm_max_prot_bits'
> contains some an union of subset of {VM_READ, VM_WRITE, VM_EXEC}, and
> 'newflags' can contain other bits set too.
> 
> The old implementation of sgx_vma_mprotect() is like this:
> 
> static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
> 			    unsigned long end, unsigned long prot)
> {
> 	return sgx_encl_may_map(vma->vm_private_data, start, end,
> 				calc_vm_prot_bits(prot, 0));
> }
> 
> The new one should be probably the implemented along the lines of
> 
> static int sgx_vma_mprotect(struct vm_area_struct *vma,
> 			    struct vm_area_struct **pprev, unsigned long start,
> 			    unsigned long end, unsigned long newflags)
> {
> 	unsigned long masked_newflags = newflags &
> 					(VM_READ | VM_WRITE | VM_EXEC);
> 	int ret;
> 
> 	ret = sgx_encl_may_map(vma->vm_private_data, start, end,
> 				   masked_newflags);
> 	if (ret)
> 		return ret;
> 
> 	return mprotect_fixup(vma, pprev, start, end, newflags);
> }
> 
> Alternatively the filtering can be inside sgx_encl_may_map(). Perhaps
> that is a better place for it. This was just easier function to
> represent the idea.

Turned out that mmap() handler was already masking with RWX. So I
removed masking from there and do it as the first step in
sgx_encl_may_map(), which is called by the both handlers:

int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
		     unsigned long end, unsigned long vm_flags)
{
	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
	unsigned long idx, idx_start, idx_end;
	struct sgx_encl_page *page;

Also renamed the last function parameter from vm_flags to vm_port_bits.
Kind of makes the flow more understandable (i.e. vm_prot_bits is purely
internal representation, not something caller needs to be concerned of).

/Jarkko
