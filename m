Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A155CC2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 16:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D9252065D
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 16:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgI1QUG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 12:20:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:48309 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgI1QUG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 12:20:06 -0400
IronPort-SDR: ebBylnUyEkKRx6ZMHgDu7vBQmQ/RrIHCESBCEUaILo1EK2OPdJ/KdJq8BpRzpuwoIPumBA9MMl
 MC0kWrvtj+Ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="159362211"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="159362211"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 09:20:03 -0700
IronPort-SDR: 6TZJ7Ehu/ELhw6vm2VOLjkupaHMzkSF96p16WXD+Pyxf8TnKh2UvfUtj/SAjsteIHkGVm6TJLD
 ViathMlqBWzA==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="488641778"
Received: from gboudouk-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.33.127])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 09:19:56 -0700
Date:   Mon, 28 Sep 2020 19:19:54 +0300
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
Message-ID: <20200928161954.GB92669@linux.intel.com>
References: <20200924202549.GB19127@linux.intel.com>
 <e25bfeaa-afb4-3928-eb80-50d90815eabb@intel.com>
 <20200924230501.GA20095@linux.intel.com>
 <b737fcab-bfde-90e1-1101-82d646a6f5b7@intel.com>
 <20200925000052.GA20333@linux.intel.com>
 <32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com>
 <20200925194304.GE31528@linux.intel.com>
 <230ce6da-7820-976f-f036-a261841d626f@intel.com>
 <20200928005347.GB6704@linux.intel.com>
 <6eca8490-d27d-25b8-da7c-df4f9a802e87@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6eca8490-d27d-25b8-da7c-df4f9a802e87@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 07:04:38AM -0700, Dave Hansen wrote:
> On 9/27/20 5:53 PM, Jarkko Sakkinen wrote:
> > On Fri, Sep 25, 2020 at 12:53:35PM -0700, Dave Hansen wrote:
> >> On 9/25/20 12:43 PM, Sean Christopherson wrote:
> >>>> That means that the intent argument (SGX_PROT_*) is currently unused.
> >>> No, the intent argument is used (eventually) by SGX's ->mprotect()
> >>> implementation, i.e. sgx_mprotect() enforces that the actual protections are a
> >>> subset of the declared/intended protections.
> >>>
> >>> If ->mprotect() is not merged, then it yes, it will be unused.
> >>
> >> OK, I think I've got it.
> >>
> >> I think I'm OK with adding ->mprotect().  As long as folks buy into the
> >> argument that intent needs to be checked at mmap() time, they obviously
> >> need to be checked at mprotect() too.
> >>
> >> Jarkko, if you want to try and rewrite the changelog, capturing the
> >> discussion here and reply, I think I can ack the resulting patch.  I
> >> don't know if that will satisfy the request from Boris from an ack from
> >> a "mm person", but we can at least start there. :)
> > 
> > I think what it needs, based on what I've read, is the step by step
> > description of the EMODPE scenarion without this callback and with it.
> 
> EMODPE is virtually irrelevant for this whole thing.  The x86 PTE
> permissions still specify the most restrictive permissions, which is
> what matters the most.
> 
> We care about the _worst_ the enclave can do, not what it imposes on
> itself on top of that.

AFAIK it is not, or what we are protecting against with this anyway
then?

Let say an LSM makes decision for the permissions based on origin. If we
do not have this you can:

1. EMODPE
2. mprotect

I.e. whatever LSM decides, won't matter.

The other case, noexec, is now unconditionally denied.

> > I think other important thing to underline is that an LSM or any other
> > security measure can only do a sane decision when the enclave is loaded.
> > At that point we know the source (vm_file).
> 
> Right, you know the source, but it can be anonymous or a file.

They are both origin, the point being that you know what you're dealing
with when you build the enclave, not when you map it.

This is my current rewrite of the commit message in my master branch:

"
    mm: Add 'mprotect' callback to vm_ops
    
    Intel Sofware Guard eXtensions (SGX) allows creation of blobs called
    enclaves, for which page permissions are defined when the enclave is first
    loaded. Once an enclave is loaded and initialized, it can be mapped to the
    process address space.
    
    There is no standard file format for enclaves. They are dynamically built
    and the ways how enclaves are deployed differ greatly. For an app you might
    want to have a simple static binary, but on the other hand for a container
    you might want to dynamically create the whole thing at run-time. Also, the
    existing ecosystem for SGX is already large, which would make the task very
    hard.
    
    Finally, even if there was a standard format, one would still want a
    dynamic way to add pages to the enclave. One big reason for this is that
    enclaves have load time defined pages that represent entry points to the
    enclave. Each entry point can service one hardware thread at a time and
    you might want to run-time parametrize this depending on your environment.
    
    The consequence is that enclaves are best created with an ioctl API and the
    access control can be based only to the origin of the source file for the
    enclave data, i.e. on VMA file pointer and page permissions. For example,
    this could be done with LSM hooks that are triggered in the appropriate
    ioctl's and they could make the access control decision based on this
    information.
    
    Unfortunately, there is ENCLS[EMODPE] that a running enclave can use to
    upgrade its permissions. If we do not limit mmap() and mprotect(), enclave
    could upgrade its permissions by using EMODPE followed by an appropriate
    mprotect() call. This would be completely hidden from the kernel.
    
    Add 'mprotect' hook to vm_ops, so that a callback can be implemeted for SGX
    that will ensure that {mmap, mprotect}() permissions do not surpass any of
    the original page permissions. This feature allows to maintain and refine
    sane access control for enclaves.
"

I'm mostly happy with this but am open for change suggestions.

/Jarkko
