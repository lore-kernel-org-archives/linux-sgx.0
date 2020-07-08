Return-Path: <SRS0=axKZ=AT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7236C433DF
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jul 2020 16:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A95DC20672
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jul 2020 16:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbgGHQKm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jul 2020 12:10:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:44073 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730093AbgGHQKm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 8 Jul 2020 12:10:42 -0400
IronPort-SDR: kgevKEQRic7NhEejjIDovVxRqo+mMEQpTBOfAdE/9qGFVkaZrJVphn/j/QKPBrmCKPZB5u2FAV
 bvt4/u+oSTzg==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="136081064"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="136081064"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 09:10:41 -0700
IronPort-SDR: 4XwI0liHo6Juww0gS1MkBZwDh/jOgBd/ryttESAIJbuKqCHWfA2CFZqV1cve0I/VCw5Kl+CGqo
 oL5d7Tkw3hvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="279998123"
Received: from jschirra-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.201])
  by orsmga003.jf.intel.com with ESMTP; 08 Jul 2020 09:10:28 -0700
Date:   Wed, 8 Jul 2020 19:10:27 +0300
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
Message-ID: <20200708161027.GA549022@linux.intel.com>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-11-jarkko.sakkinen@linux.intel.com>
 <20200707031424.GD25523@casper.infradead.org>
 <20200707032254.GB5208@linux.intel.com>
 <20200707032408.GE25523@casper.infradead.org>
 <20200707040151.GA143804@linux.intel.com>
 <20200707041046.GI25523@casper.infradead.org>
 <20200708143320.GD538949@linux.intel.com>
 <20200708143708.GR25523@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708143708.GR25523@casper.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 08, 2020 at 03:37:08PM +0100, Matthew Wilcox wrote:
> On Wed, Jul 08, 2020 at 05:33:20PM +0300, Jarkko Sakkinen wrote:
> > I get the point but I don't think that your proposal could work given
> > that mprotect-callback takes neither 'prev' nor 'newflags' as its
> > parameters. The current callback has no means to call mprotect_fixup()
> > properly.
> > 
> > It would have to be extended
> > 
> > 	int (*mprotect)(struct vm_area_struct *vma,
> > 			struct vm_area_struct **pprev, unsigned long start,
> > 			unsigned long end, unsigned long prot,
> > 			unsigned long newflags);
> > 
> > Is this what you want?
> 
> https://lore.kernel.org/linux-mm/20200625173050.GF7703@casper.infradead.org/

Ugh, it's there as it should be. I'm sorry - I just misread the code.

I think that should work, and we do not have to do extra conversion
inside the callback.

There is still one thing that I'm wondering. 'page->vm_max_prot_bits'
contains some an union of subset of {VM_READ, VM_WRITE, VM_EXEC}, and
'newflags' can contain other bits set too.

The old implementation of sgx_vma_mprotect() is like this:

static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
			    unsigned long end, unsigned long prot)
{
	return sgx_encl_may_map(vma->vm_private_data, start, end,
				calc_vm_prot_bits(prot, 0));
}

The new one should be probably the implemented along the lines of

static int sgx_vma_mprotect(struct vm_area_struct *vma,
			    struct vm_area_struct **pprev, unsigned long start,
			    unsigned long end, unsigned long newflags)
{
	unsigned long masked_newflags = newflags &
					(VM_READ | VM_WRITE | VM_EXEC);
	int ret;

	ret = sgx_encl_may_map(vma->vm_private_data, start, end,
				   masked_newflags);
	if (ret)
		return ret;

	return mprotect_fixup(vma, pprev, start, end, newflags);
}

Alternatively the filtering can be inside sgx_encl_may_map(). Perhaps
that is a better place for it. This was just easier function to
represent the idea.

/Jarkko
