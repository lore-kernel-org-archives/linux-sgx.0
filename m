Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF05C2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 21:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86EF52083B
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 21:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgI1VFv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:05:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:20919 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbgI1VFu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 17:05:50 -0400
IronPort-SDR: HUFdE00GNG59CZhOC7R1j6KIb4zawP3ydrVe+yS6Y0kf+0UarC8zR+zjN5Jjns8OR7sPc0O4nD
 K6sPAKaPfjXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="180207818"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="180207818"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 12:32:39 -0700
IronPort-SDR: QO4Rtate0tOS4QYb8pyV9B9wp7jmnfuLKnnOw2M8uhgRxp6Pd+w95M3w6y4oENJjFcP4DRjrUw
 bM2M/sWsA0Vw==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="488732277"
Received: from evinhugx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.44.118])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 12:32:32 -0700
Date:   Mon, 28 Sep 2020 22:32:29 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200928193229.GA125819@linux.intel.com>
References: <20200924230501.GA20095@linux.intel.com>
 <b737fcab-bfde-90e1-1101-82d646a6f5b7@intel.com>
 <20200925000052.GA20333@linux.intel.com>
 <32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com>
 <20200925194304.GE31528@linux.intel.com>
 <230ce6da-7820-976f-f036-a261841d626f@intel.com>
 <20200928005347.GB6704@linux.intel.com>
 <6eca8490-d27d-25b8-da7c-df4f9a802e87@intel.com>
 <20200928161954.GB92669@linux.intel.com>
 <c29a662e-90ff-4862-8c82-06b43b81fb4d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c29a662e-90ff-4862-8c82-06b43b81fb4d@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 09:48:10AM -0700, Dave Hansen wrote:
> On 9/28/20 9:19 AM, Jarkko Sakkinen wrote:
> > On Mon, Sep 28, 2020 at 07:04:38AM -0700, Dave Hansen wrote:
> >> EMODPE is virtually irrelevant for this whole thing.  The x86 PTE
> >> permissions still specify the most restrictive permissions, which is
> >> what matters the most.
> >>
> >> We care about the _worst_ the enclave can do, not what it imposes on
> >> itself on top of that.
> > 
> > AFAIK it is not, or what we are protecting against with this anyway
> > then?
> > 
> > Let say an LSM makes decision for the permissions based on origin. If we
> > do not have this you can:
> > 
> > 1. EMODPE
> > 2. mprotect
> 
> The thing that matters is that the enclave needs relaxed permissions
> from the kernel.  What it *ALSO* needs to do to *ITSELF* to get those
> permissions is entirely irrelevant to the kernel.

Lets try to find the root of misunderstanding, shall we?

I'm assuming that your statement is encapsulated to:

https://lore.kernel.org/linux-sgx/32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com/

I do agree with this.

And here is a direct quote:

"It is also stashed off and then later compared with enclave PTEs to
ensure that any future mmap()/mprotect() operations performed by the
enclave creator or the enclave itself are consistent with the earlier
declared permissions."

Without the mprotect callback in place, by using EMODPE and mprotect,
one could surpass the permisssions that we declared earlier.

With the callback in place this is not possible. EMODPE can be freely
used but mprotect() always caps the permissions. It enables us to *not
care* about EMODPE.

My problem is that I fully agree what you say in your description but
disagree on that EMODPE should not be mentioned.

> >     There is no standard file format for enclaves. They are dynamically built
> >     and the ways how enclaves are deployed differ greatly. For an app you might
> >     want to have a simple static binary, but on the other hand for a container
> >     you might want to dynamically create the whole thing at run-time. Also, the
> >     existing ecosystem for SGX is already large, which would make the task very
> >     hard.
> 
> I'm sorry I ever mentioned the file format.  Please remove any mention
> of it.  It's irrelevant.  This entire paragraph is irrelevant.

Not sure if it is or not. It is merely to state that execve() path is
possible. Perhaps should be toned down in some way. Should be like the
a small remark at most.

> >     Finally, even if there was a standard format, one would still want a
> >     dynamic way to add pages to the enclave. One big reason for this is that
> >     enclaves have load time defined pages that represent entry points to the
> >     enclave. Each entry point can service one hardware thread at a time and
> >     you might want to run-time parametrize this depending on your environment.
> 
> I also don't know what this paragraph has to do with the mprotect()
> hook.  Please remove it.

Agreed.

> >     The consequence is that enclaves are best created with an ioctl API and the
> >     access control can be based only to the origin of the source file for the
> >     enclave data, i.e. on VMA file pointer and page permissions. For example,
> 
> It's not strictly page permissions, though.  It's actually VMA
> permissions.  The thing you copy from might be the zero page, and even
> though it has Write=0 page permissions, apps are completely OK to write
> to the address.  This is the WRITE vs. MAY_WRITE semantic in the VMA flags.
> 
> It's also not just about *files*.  Anonymous memory might or might not
> be a valid source for enclave data based on LSM hooks.

Yes, this should be refined, agreed. Source can be either anonymous page
or a file, I do of course understand that.

> >     this could be done with LSM hooks that are triggered in the appropriate
> >     ioctl's and they could make the access control decision based on this
> >     information.
> 
> This "appropriate ioctl's" is not good changelog material.  Please use
> those bytes to convey actual information.
> 
> 	... this could be done with LSM hooks which restrict the source
> 	of enclave page data
> 
> I don't care that it's an ioctl(), really.  What matters is what the
> ioctl() does: copy data into enclave pages.

Agreed.

> >     Unfortunately, there is ENCLS[EMODPE] that a running enclave can use to
> >     upgrade its permissions. If we do not limit mmap() and mprotect(), enclave
> >     could upgrade its permissions by using EMODPE followed by an appropriate
> >     mprotect() call. This would be completely hidden from the kernel.
> 
> There's too much irrelevant info.
> 
> I'll say it again: all that matters is that enclaves can legitimately,
> safely, and securely have a need for the kernel to change page
> permissions.  That's *IT*.  EMODPE just happens to be part of the
> mechanism that makes these permission changes safe for enclaves.  It's a
> side show.

Disagree on this. I wrote my statement about. Maybe it should not be
driving argument but should be definitely part of the description.

> >     Add 'mprotect' hook to vm_ops, so that a callback can be implemeted for SGX
> >     that will ensure that {mmap, mprotect}() permissions do not surpass any of
> >     the original page permissions. This feature allows to maintain and refine
> >     sane access control for enclaves.
> 
> Instead of "original", I'd stick to the "source" page nomenclature.
> There are also "original" permissions with mprotect().
> 
> Also, it's literally OK for the enclave page permissions to surpass the
> original (source) page permissions.  That sentence is incorrect, or at
> least misleadingly imprecise.

Yes it is. It's fine to use EMODPE to upgrade the perms, and by having
this hook, doing anything nasty with it is impossible.

> > I'm mostly happy with this but am open for change suggestions.
> 
> I wrote a pretty nice description of this.  It was about 90% correct,
> shorter, and conveyed more information.  I'd suggest starting with that.

I should have added a disclaimer that my description is not up to date.
Just do not want to make anything final before this EMODPE discussion
has some conclusion.

I'm fine using your description as basis for the commit message if as long
as these few details are settled.

/Jarkko
