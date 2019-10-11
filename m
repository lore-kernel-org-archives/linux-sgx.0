Return-Path: <SRS0=gA9u=YE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1ABECE58C
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 14:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68DAC206A1
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 14:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfJKOh1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Oct 2019 10:37:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:4592 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfJKOh0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Oct 2019 10:37:26 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 07:37:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,284,1566889200"; 
   d="scan'208";a="395764146"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 11 Oct 2019 07:37:25 -0700
Date:   Fri, 11 Oct 2019 07:37:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        "Dr. G.W. Wettstein" <greg@wind.enjellic.com>
Subject: Re: [PATCH for_v23 0/7] x86/sgx: Improve add pages ioctl
Message-ID: <20191011143725.GA30935@linux.intel.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
 <op.z9fc9yu4wjvjmi@hhuan26-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.z9fc9yu4wjvjmi@hhuan26-mobl.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

+cc Jethro and Greg

On Wed, Oct 09, 2019 at 10:28:36PM -0500, Haitao Huang wrote:
> On Tue, 08 Oct 2019 23:42:34 -0500, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
> >Enhance the SGX_IOC_ENCLAVE_ADD_PAGE{S} ioctl so that userspace can add
> >multiple pages to an enclave in a single syscall.  Also provide a flag
> >that allows replicating a single source page to multiple target pages so
> >that userspace doesn't need to allocate a giant chunk of memory when
> >initializing things like the enlave's .bss, heap, etc...
> >
> >People that actually develop runtimes, please weigh in.  Jarkko also
> >suggested going with a fully flexible ioctl, e.g. essentially creating an
> >array of the existing struct so that mrmask and/or secinfo can be unique
> >per page.  AFAICT that's overkill and more cumbersome to use as it forces
> >userspace to allocate the full array.  My understanding is that the
> >majority of enclaves will have contiguous blocks of pages with identical
> >mrmask and secinfo, e.g. code segments, ro data, etc..., thus the less
> >flexible but easier-in-theory to use approach proposed here.
> >
> We think using the same mask for all pages (solution in this patch set) is
> reasonable. Although it seems odd that all pages would apply the same mask,
> this allows enough flexibility we can foresee.

Jethro, last time I brought this up you mentioned that it'd be nice to
have an array of pages[*] instead of the repeat-for-each-page concept.
Is there a use case where taking an array would provide a substantial
benefit to userspace?  Taking an array has downsides, and I think would
actually be worse for the vast majority of use cases.

E.g. for a contiguous chunk with the repeater approach

	struct sgx_enclave_add_pages ioc;
	struct sgx_secinfo secinfo;

	memset(&secinfo, 0, sizeof(secinfo));
	secinfo.flags = sec_flags;

	ioc.secinfo = (unsigned long)&secinfo;
	ioc.mrmask = 0xFFFF;
	ioc.offset = offset;
	ioc.src = (uint64_t)data;
	ioc.nr_pages = nr_pages;
	ioc.flags = misc_flags;
	memset(ioc.reserved, 0, sizeof(ioc.reserved));

vs. something like this for the array approach

	struct sgx_enclave_add_pages ioc;
	unsigned long i;

	array = malloc(sizeof(struct sgx_enclave_add_page_entry) * nr_pages);
	for (i = 0; i < nr_pages; i++) {
		memset(entries[i].secinfo, 0, sizeof(secinfo));
		entries[i].secinfo.flags = sec_flags;

		entries[i].mrmask = 0xFFFF;
		entries[i].offset = offset;
		entries[i].src = (uint64_t)data;
		entries[i].flags = misc_flags;
		memset(entries[i].reserved, 0, sizeof(entries[i].reserved));
	}

	ioc.nr_pages = nr_pages;
	ioc.page_array = (uint64_t)array;
	memset(ioc.reserved, 0, sizeof(ioc.reserved));

The loop is mildly annoying, but the real killer is the array allocation.
SECINFO is 64 bytes, which means each entry is 88 bytes or more, e.g. around
180kb to add an 8mb chunk of .bss or heap.

My intention is/was for the multi-page add to be an opportunistic
optimization, not a way to add all enclave pages in a single ioctl.

[*] https://patchwork.kernel.org/patch/10977721/#22699225

> Another option acceptable to us (Intel SGX runtime) is to change it to a
> flag and have bit zero define whether the whole page is measured via
> EEXTEND. This is simpler and allows other bits reserved for future usages.
> However, it would fail any SGX runtime that is measuring partial page for
> optimization purposes.

This can be an orthogonal change.  I agree it makes sense to drop mrmask
and instead have a SGX_ADD_PAGES_MEASURED flag to cover the whole page.
Hiding the 256-byte granualarity from userspace is a good idea as it's not
intrinsically tied to the SGX architecture and exists only because of
latency requirements.  And most of the kernel interfaces work on 4k
granularity.
