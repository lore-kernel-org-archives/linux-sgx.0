Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC89AC41604
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 18:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 648152168B
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 18:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbgJGSJQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Oct 2020 14:09:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:12302 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgJGSJP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Oct 2020 14:09:15 -0400
IronPort-SDR: svaI1SWYEQGMy54XnoLrs0JwN5GAYb8lTdwbfwkMsSDdGkji3UR74wxUJhwgpkAsL2DvolaabX
 2fP7Lw+ahHAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="229216216"
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="229216216"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 11:09:09 -0700
IronPort-SDR: 5PNCETrDiwQy2/t4785lrTEzbxUpmB04/ke5g7I8guUsNIo2ozeFzyvsKhUTusdLmznvN5cU6L
 fNNS37/u73XA==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="528080810"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO mqcpg7oapc828.gar.corp.intel.com) ([10.255.33.155])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 07 Oct 2020 11:09:03 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Greg KH" <gregkh@linuxfoundation.org>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Matthew Wilcox" <willy@infradead.org>,
        "Jethro Beekman" <jethro@fortanix.com>,
        "Chunyang Hui" <sanqian.hcy@antfin.com>,
        "Jordan Hand" <jorhand@linux.microsoft.com>,
        "Nathaniel McCallum" <npmccallum@redhat.com>,
        "Seth Moore" <sethmo@google.com>,
        "Darren Kenny" <darren.kenny@oracle.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Suresh Siddha" <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003143925.GB800720@kroah.com> <20201004143246.GA3561@linux.intel.com>
 <20201005094246.GB151835@kroah.com> <20201005124221.GA191854@linux.intel.com>
Date:   Wed, 07 Oct 2020 13:09:01 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0r4p1bn7wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
In-Reply-To: <20201005124221.GA191854@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 05 Oct 2020 07:42:21 -0500, Jarkko Sakkinen  
<jarkko.sakkinen@linux.intel.com> wrote:

> On Mon, Oct 05, 2020 at 11:42:46AM +0200, Greg KH wrote:
>> > > You use gpl-only header files in this file, so how in the world can  
>> it
>> > > be bsd-3 licensed?
>> > >
>> > > Please get your legal department to agree with this, after you  
>> explain
>> > > to them how you are mixing gpl2-only code in with this file.
>> >
>> > I'll do what I already stated that I will do. Should I do something
>> > more?
>>
>> This was written before your previous response.
>
> OK, that is weird, I got this one some time later.
>
>> > > > +	mutex_lock(&encl->lock);
>> > > > +	atomic_or(SGX_ENCL_DEAD, &encl->flags);
>> > >
>> > > So you set a flag that this is dead, and then instantly delete it?   
>> Why
>> > > does that matter?  I see you check for this flag elsewhere, but as  
>> you
>> > > are just about to delete this structure, how can this be an issue?
>> >
>> > It matters because ksgxswapd (sgx_reclaimer_*) might be processing it.
>>
>> I don't see that happening in this patch, did I miss it?
>
> It's implemented in 16/24:
>
> https://lore.kernel.org/linux-sgx/20201004223921.GA48517@linux.intel.com/T/#u
>
>> > It will use the flag to skip the operations that it would do to a  
>> victim
>> > page, when the enclave is still alive.
>>
>> Again, why are you adding flags when the patch does not use them?
>> Please put new functionality in the specific patch that uses it.
>>
>> And can you really rely on this?  How did sgx_reclaimer_* (whatever that
>> is), get the reference on this object in the first place?  Again, I
>> don't see that happening at all in here, and at a quick glance in the
>> other patches I don't see it there either.  What am I missing?
>
> I went through the patch, and yes, they can be migrated to 16/24.
> I agree with this, no excuses.
>
> In 16/24 pages are added to sgx_active_page_list from which they are
> swapped by the reclaimer to the main memory when Enclave Page Cache
> (EPC), the memory where enclave pages reside, gets full.
>
> When a reclaimer thread takes a victim page from that list, it will also
> get a kref to the enclave so that struct sgx_encl instance does not
> get wiped while it's doing its job.
>
>> > Because ksgxswapd needs the alive enclave instance while it is in the
>> > process of swapping a victim page. The reason for this is the
>> > hierarchical nature of the enclave pages.
>> >
>> > As an example, a write operation to main memory, EWB (SDM vol 3D  
>> 40-79)
>>
>> What is that referencing?
>
> https://software.intel.com/content/dam/develop/public/us/en/documents/332831-sdm-vol-3d.pdf
>
>> > needs to access SGX Enclave Control Structure (SECS) page, which is
>> > contains global data for an enclave, like the unswapped child count.
>>
>> Ok, but how did it get access to this structure in the first place, like
>> I ask above?
>
> I guess I answered that, and I also fully agree with your suggestions.
>
> It used to be many iterations ago that enclaves were not file based but
> just memory mappings (long story short: was not great way to make them
> multiprocess, that's why file centered now), and then refcount played a
> bigger role. Having those "extras" in this patch is by no means
> intentional but more like cruft of many iterations of refactoring.
>
> Sometimes when you work long with this kind of pile of code, which has
> converged through many iterations, you really need someone else to point
> some of the simple and obvious things out.
>
>> > There is a patch that adds "sgx/provision".
>>
>> What number in this series?
>
> It's 15/24.
>

Don't know if this is critical. I'd prefer to keep them as is. Directory  
seems natural to me and makes sense to add more under the same dir in case  
there are more to come.

Thanks
Haitao
