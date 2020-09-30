Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1F2C4727C
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 14:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB2CD20739
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 14:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgI3Of4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 10:35:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:32902 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729903AbgI3Of4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 10:35:56 -0400
IronPort-SDR: 6j2m2XzV3H2ghhlIna2HH5NeTjXVh8Hx8QQdLOe7sH3FY6uUQjL37aWImiQcvRn97AbZJFnclf
 PtqnIjoP59Sw==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="159799659"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="159799659"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 07:35:55 -0700
IronPort-SDR: h9hvVVcJlvsG5tcAQK2vCwil5WDKeTE87RcUL7mHoacJZPen0aSPPuRBc5WCkmmUkMznFDMxCP
 GZFcci42nH+g==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="308178028"
Received: from mdioury-mobl.amr.corp.intel.com (HELO [10.213.184.164]) ([10.213.184.164])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 07:35:53 -0700
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
References: <20200928201959.GA3856@linux.intel.com>
 <E16AF0FA-3017-4323-BDD9-56DCA33CED74@amacapital.net>
 <20200929040521.GC301037@linux.intel.com>
 <1b1bd1f8-210d-486a-b038-2d6eea9d35cd@intel.com>
 <20200930002024.GA805586@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <06079188-df33-2cab-1f5a-bce02f94d481@intel.com>
Date:   Wed, 30 Sep 2020 07:35:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930002024.GA805586@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9/29/20 5:20 PM, Jarkko Sakkinen wrote:
> On Tue, Sep 29, 2020 at 07:24:24AM -0700, Dave Hansen wrote:
>> On 9/28/20 9:05 PM, Jarkko Sakkinen wrote:
>>> On Mon, Sep 28, 2020 at 06:37:54PM -0700, Andy Lutomirski wrote:
>>>> I don’t personally care that much about EMODPE but, you could probably
>>>> get the point across with something like:
>>>>
>>>> SGX’s EPCM permission bits do not obviate the need to enforce these
>>>> rules in the PTEs because enclaves can freely modify the EPCM
>>>> permissions using EMODPE.
>>>>
>>>> IOW, EMODPE is not really special here; rather, EMODPE’s existence
>>>> demonstrates that EADD / EEXTEND are not special.
>>>
>>> So I did "disagree and commit" with this one. I'm not actually
>>> diagreeing on anything what Dave wrote, on the contrary it is an
>>> understandable high level description. I just thought that it would not
>>> hurt to remark that the ISA contains such peculiarities as EMODPE.
>>>
>>> I did only very rudimentary clean up for the text (e.g. fix the ioctl
>>> name, add shortt summary and not much else).
>>>
>>> Does not make sense to waste more time to this. I'll move on to
>>> implement the missing boot time patching for the vDSO so that we
>>> get the next version out.
>>>
>>> "
>>> mm: Add 'mprotect' hook to struct vm_operations_struct
>>>
>>> Background
>>> ==========
>>>
>>> 1. SGX enclave pages are populated with data by copying data to them
>>>    from normal memory via ioctl(fd, SGX_IOC_ENCLAVE_ADD_PAGES).
>>> 2. We want to be able to restrict those normal memory data sources.  For
>>>    instance, before copying data to an executable enclave page, we might
>>>    ensure that the source is executable.
>>
>> I know I wrote that.  I suck, and I wrote it in a changelog-unacceptable
>> way.  Folks dislike the use of "we" in these things.  Here's a better
>> version:
>>
>>   2. It is desirable to be able to restrict those normal memory data
>>      sources.  For instance, the kernel can ensure that the source is
>>      executable, before copying data to an executable enclave page.
>>
>>> 3. Enclave page permissions are dynamic just like normal permissions and
>>>    can be adjusted at runtime with mprotect() (along with a
>>>    corresponding special instruction inside the enclave).
>>> 4. The original data source may have have long since vanished at the
>>>    time when enclave page permission are established (mmap() or
>>>    mprotect()).
>>>
>>> Solution
>>> ========
>>>
>>> The solution is to force enclaves creators to declare their intent up front
>>> to ioctl(fd, SGX_IOC_ENCLAVE_ADD_PAGES).  This intent can me immediately
>>> compared to the source data mapping (and rejected if necessary).  It is
>>> also stashed off and then later compared with enclave PTEs to ensure that
>>> any future mmap()/mprotect() operations performed by the enclave creator or
>>> the enclave itself are consistent with the earlier declared permissions.
>>
>> Let's also say "... or *requested* by the enclave itself ...", since the
>> enclave itself can't directly make syscalls.
> 
> Yes, it is definitely more understandable way to say it. Do you mind
> if I rephrase it as:
> 
> "It is also stashed off and then later compared with enclave PTEs to
> ensure that any future mmap()/mprotect() operations performed by the
> enclave creator or requested the enclave by itself (e.g. by issuing
> ECLU[EMODPE]) are consistent with the earlier declared permissions."
> 
> I'd just mention EMODPE as an example, but I'm also perfectly fine
> leaving that out :-) Not a big deal for me.

If I say it's a big deal for me, will you remove the bloody thing?

Mentioning EMODPE is a distraction for this patch.  It's a big
distraction because it makes it sound like it is some kind of *peer* of
mmap()/mprotect().  It's not.  It's subservient to x86 paging
protections and thus *IRRELEVANT* for this unless you care about the
intricacies of writing enclaves.

It's a big deal to me.

Also, I've tried to give this feedback previously, but the paging
permissions are also essentially irrelevant.

> Also, should there be commas, i.e. ", or requested the enclave by
> itself,"? I suck with English comma rules.

I'd just say this:

	It is also stashed off and then later compared with enclave PTEs
	to ensure that any future mmap()/mprotect() operations are
	consistent with the earlier declared permissions.

Yours was starting to look pretty run on.

> "ioctl(fd, SGX_IOC_ENCLAVE_ADD_PAGES, ...) checks for every page that
> Thread Control Structure (TCS) pages are always added with zero
> permissions and no pages are sourced from noexec partitions. TCS pages
> are pages that work as entry points to the enclave. This is the basic
> acceptance criteria for any enclave page before it gets mapped.

This is going off into the SGX weeds again.

We don't need to justify the ABI for an ioctl() introduced in a
different patch in *THIS* patch.  Just remove this, please.

> After finishing this, the ioctl will project the enclave permissions to
> the corresponding VMA permissions and stores the result for later
> lookup.

That sounds vaguely relevant, although I'm not sure what permission
projection is.  You use that terminology over and over, so you probably
need to define it.

>  For regular pages this is an identity mapping but as an
> exception TCS pages are unconditionally mapped as RW VMA permssion even
> though their enclave permissions are zero. This required by the ISA.

I don't think this is relevant.

> This information will be used by sgx_mmap() and sgx_vma_protect() to
> enforce that higher permissions than the projected permissions will
> not be used by checking this for each every page in the address
> range.

I've given this feedback before.  Please don't use "higher" and "lower"
permissions.  "Stronger/weaker" is my preferred terminology.

You also don't have to *NAME* the functions.  If I want to know where a
structure field is, grep is a better way to find that.

Does this lose any meaning if we just say:

	This information will be to ensure that enclave PTEs will not be
	created with permissions weaker than the source data

?

> By doing this, we give assets for LSM's to make decisions during the
> build time based on projected VMA permissions and the source VMA
> (either a file or anonymous mapping) that hold when the enclave is
> finally mapped to the visible memory."
