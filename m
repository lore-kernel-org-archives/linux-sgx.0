Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269F8C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Sep 2021 23:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0B9E60F70
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Sep 2021 23:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhIUXuH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 21 Sep 2021 19:50:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:50231 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229824AbhIUXuG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 21 Sep 2021 19:50:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="203641189"
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="203641189"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 16:48:37 -0700
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="474274829"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 16:48:37 -0700
Date:   Tue, 21 Sep 2021 16:48:36 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] x86/sgx: Add infrastructure to identify SGX EPC
 pages
Message-ID: <YUpvVK1C4y66Cj2Q@agluck-desk2.amr.corp.intel.com>
References: <20210827195543.1667168-1-tony.luck@intel.com>
 <20210917213836.175138-1-tony.luck@intel.com>
 <20210917213836.175138-3-tony.luck@intel.com>
 <ccb678fc-25b8-dcd6-ffaa-267865c66ea5@intel.com>
 <eeeb51049e894a70b40013ec18a9fa65@intel.com>
 <8c39b812-b77a-7d63-2d82-f1c0401a5f16@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c39b812-b77a-7d63-2d82-f1c0401a5f16@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 21, 2021 at 03:32:14PM -0700, Dave Hansen wrote:
> On 9/21/21 1:50 PM, Luck, Tony wrote:
> >> Did we ever figure out how much space storing really big ranges in the
> >> xarray consumes?
> > No. Willy said the existing xarray code would be less than optimal with
> > this usage, but that things would be much better when he applied some
> > maple tree updates to the internals of xarray.
> > 
> > If there is some easy way to measure the memory backing an xarray I'm
> > happy to get the data. Or if someone else can synthesize it ... the two
> > ranges on my system that are added to the xarray are:
> > 
> > $ dmesg | grep -i sgx
> > [    8.496844] sgx: EPC section 0x8000c00000-0x807f7fffff
> > [    8.505118] sgx: EPC section 0x10000c00000-0x1007fffffff
> > 
> > I.e. two ranges of a bit under 2GB each.
> > 
> > But I don't think the overhead can be too hideous:
> > 
> > $ grep MemFree /proc/meminfo
> > MemFree:        1048682016 kB
> > 
> > I still have ~ 1TB free. Which is much greater that the 640 KB which should
> > be "enough for anybody" :-).
> 
> There is a kmem_cache_create() for the xarray nodes.  So, you should be
> able to see the difference in /proc/meminfo's "Slab" field.  Maybe boot
> with init=/bin/sh to reduce the noise and look at meminfo both with and
> without SGX your patch applied, or just with the xarray bits commented out.
> 
> I don't quite know how the data structures are munged, but xas_alloc()
> makes it look like 'struct xa_node' is allocated from
> radix_tree_node_cachep.  If that's the case, you should also be able to
> see this in even more detail in:
> 
> # grep radix /proc/slabinfo
> radix_tree_node   432305 482412    584   28    4 : tunables    0    0
>  0 : slabdata  17229  17229      0
> 
> again, on a system with and without your new code enabled.


Booting with init=/bin/sh and running that grep command right away at
the prompt:

With the xa_store_range() call commented out of my kernel:

radix_tree_node     9800   9968    584   56    8 : tunables    0    0    0 : slabdata    178    178      0


With xa_store_range() enabled:

radix_tree_node     9950  10136    584   56    8 : tunables    0    0    0 : slabdata    181    181      0



The head of the file says these are the field names:

# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>

So I think this means that I have (9950 - 9800) * 584 = 87600 more bytes
allocated. Maybe that's a lot? But percentage-wise is seems in the
noise. E.g. We allocate one "struct sgx_epc_page" for each SGX page.
On my system I have 4GB of SGX EPC, so around 32 MB of these structures.

-Tony
