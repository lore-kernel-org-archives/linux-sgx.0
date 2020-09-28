Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62045C4742B
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 16:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C94220717
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 16:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgI1Qsh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 12:48:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:23965 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbgI1QsO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 12:48:14 -0400
IronPort-SDR: CRIQGF5Ia+oo4f2uYebDTWZM4PZIkTu88tQuPIYqlEf7aHrqkmarVp/g9jx0hGRiOqW/Mb6txN
 C8gR88D0Rnug==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="162907532"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="162907532"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 09:48:12 -0700
IronPort-SDR: 5E66H2whoS8RfrgTspPO2Tp5CegedCZ8GPRmqtUwBBNvI7+2CMT6X4QwHOqTJl1gI7kZ07ZQCI
 i35JswzrrQ7w==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="293944527"
Received: from rcalvo1-mobl1.amr.corp.intel.com (HELO [10.209.56.88]) ([10.209.56.88])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 09:48:10 -0700
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
 <20200928161954.GB92669@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <c29a662e-90ff-4862-8c82-06b43b81fb4d@intel.com>
Date:   Mon, 28 Sep 2020 09:48:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200928161954.GB92669@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9/28/20 9:19 AM, Jarkko Sakkinen wrote:
> On Mon, Sep 28, 2020 at 07:04:38AM -0700, Dave Hansen wrote:
>> EMODPE is virtually irrelevant for this whole thing.  The x86 PTE
>> permissions still specify the most restrictive permissions, which is
>> what matters the most.
>>
>> We care about the _worst_ the enclave can do, not what it imposes on
>> itself on top of that.
> 
> AFAIK it is not, or what we are protecting against with this anyway
> then?
> 
> Let say an LSM makes decision for the permissions based on origin. If we
> do not have this you can:
> 
> 1. EMODPE
> 2. mprotect

The thing that matters is that the enclave needs relaxed permissions
from the kernel.  What it *ALSO* needs to do to *ITSELF* to get those
permissions is entirely irrelevant to the kernel.

> I.e. whatever LSM decides, won't matter.
> 
> The other case, noexec, is now unconditionally denied.



>>> I think other important thing to underline is that an LSM or any other
>>> security measure can only do a sane decision when the enclave is loaded.
>>> At that point we know the source (vm_file).
>>
>> Right, you know the source, but it can be anonymous or a file.
> 
> They are both origin, the point being that you know what you're dealing
> with when you build the enclave, not when you map it.
> 
> This is my current rewrite of the commit message in my master branch:
> 
> "
>     mm: Add 'mprotect' callback to vm_ops
>     
>     Intel Sofware Guard eXtensions (SGX) allows creation of blobs called
>     enclaves, for which page permissions are defined when the enclave is first
>     loaded. Once an enclave is loaded and initialized, it can be mapped to the
>     process address space.
>     
>     There is no standard file format for enclaves. They are dynamically built
>     and the ways how enclaves are deployed differ greatly. For an app you might
>     want to have a simple static binary, but on the other hand for a container
>     you might want to dynamically create the whole thing at run-time. Also, the
>     existing ecosystem for SGX is already large, which would make the task very
>     hard.

I'm sorry I ever mentioned the file format.  Please remove any mention
of it.  It's irrelevant.  This entire paragraph is irrelevant.

>     Finally, even if there was a standard format, one would still want a
>     dynamic way to add pages to the enclave. One big reason for this is that
>     enclaves have load time defined pages that represent entry points to the
>     enclave. Each entry point can service one hardware thread at a time and
>     you might want to run-time parametrize this depending on your environment.

I also don't know what this paragraph has to do with the mprotect()
hook.  Please remove it.

>     The consequence is that enclaves are best created with an ioctl API and the
>     access control can be based only to the origin of the source file for the
>     enclave data, i.e. on VMA file pointer and page permissions. For example,

It's not strictly page permissions, though.  It's actually VMA
permissions.  The thing you copy from might be the zero page, and even
though it has Write=0 page permissions, apps are completely OK to write
to the address.  This is the WRITE vs. MAY_WRITE semantic in the VMA flags.

It's also not just about *files*.  Anonymous memory might or might not
be a valid source for enclave data based on LSM hooks.

>     this could be done with LSM hooks that are triggered in the appropriate
>     ioctl's and they could make the access control decision based on this
>     information.

This "appropriate ioctl's" is not good changelog material.  Please use
those bytes to convey actual information.

	... this could be done with LSM hooks which restrict the source
	of enclave page data

I don't care that it's an ioctl(), really.  What matters is what the
ioctl() does: copy data into enclave pages.

>     Unfortunately, there is ENCLS[EMODPE] that a running enclave can use to
>     upgrade its permissions. If we do not limit mmap() and mprotect(), enclave
>     could upgrade its permissions by using EMODPE followed by an appropriate
>     mprotect() call. This would be completely hidden from the kernel.

There's too much irrelevant info.

I'll say it again: all that matters is that enclaves can legitimately,
safely, and securely have a need for the kernel to change page
permissions.  That's *IT*.  EMODPE just happens to be part of the
mechanism that makes these permission changes safe for enclaves.  It's a
side show.

>     Add 'mprotect' hook to vm_ops, so that a callback can be implemeted for SGX
>     that will ensure that {mmap, mprotect}() permissions do not surpass any of
>     the original page permissions. This feature allows to maintain and refine
>     sane access control for enclaves.

Instead of "original", I'd stick to the "source" page nomenclature.
There are also "original" permissions with mprotect().

Also, it's literally OK for the enclave page permissions to surpass the
original (source) page permissions.  That sentence is incorrect, or at
least misleadingly imprecise.

> I'm mostly happy with this but am open for change suggestions.

I wrote a pretty nice description of this.  It was about 90% correct,
shorter, and conveyed more information.  I'd suggest starting with that.
