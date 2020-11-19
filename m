Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1AAC63697
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 01:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0AD5246DC
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 01:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgKSBjz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Nov 2020 20:39:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:61942 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgKSBjy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Nov 2020 20:39:54 -0500
IronPort-SDR: c8MIROG6OgH54s0WkOffaYy4is7DqUbMSn8tPKC1ZZqi4oMTQbrRb6yYHn+0y/c9JU+OXCTITB
 nLewoFoJWvbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="158248755"
X-IronPort-AV: E=Sophos;i="5.77,489,1596524400"; 
   d="scan'208";a="158248755"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 17:39:54 -0800
IronPort-SDR: FyWagM392snwNLeLy57jhT52y7risszr7gvIqKkdnUCQ2fCR+7Ug/PTQ97Pn3kQzGqz3CsCMqK
 4bAGK705/1Uw==
X-IronPort-AV: E=Sophos;i="5.77,489,1596524400"; 
   d="scan'208";a="357214172"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO fgctuval.land.test) ([10.209.121.50])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 18 Nov 2020 17:39:51 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Andy Lutomirski" <luto@kernel.org>, "Dr. Greg" <greg@enjellic.com>
Cc:     "Dave Hansen" <dave.hansen@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        "X86 ML" <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Linux-MM <linux-mm@kvack.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Matthew Wilcox" <willy@infradead.org>,
        "Jethro Beekman" <jethro@fortanix.com>,
        "Darren Kenny" <darren.kenny@oracle.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, "Borislav Petkov" <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        "Conrad Parker" <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "Keith Moyer" <kmoy@google.com>,
        "Christian Ludloff" <ludloff@google.com>,
        "Neil Horman" <nhorman@redhat.com>,
        "Nathaniel McCallum" <npmccallum@redhat.com>,
        "Patrick Uiterwijk" <puiterwijk@redhat.com>,
        "David Rientjes" <rientjes@google.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, yaozhangx@google.com,
        "Mikko Ylinen" <mikko.ylinen@intel.com>
Subject: Re: [PATCH v40 10/24] mm: Add 'mprotect' hook to struct
 vm_operations_struct
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com>
 <20201106174359.GA24109@wind.enjellic.com>
 <e70c9e92-0bd4-59a4-21b1-bccf8621c6bb@intel.com>
 <20201107150930.GA29530@wind.enjellic.com>
 <c7157bc6-8a65-11f4-e961-17163730df5d@intel.com>
 <20201112205819.GA9172@wind.enjellic.com>
 <5c22300c-0956-48ed-578d-00cf62cb5c09@intel.com>
 <CALCETrWaUDO1eG7PE_bpA2C_OVeNZ7VbEVaznkg2U7Qx=X=oEw@mail.gmail.com>
 <20201116180023.GA32481@wind.enjellic.com>
Date:   Wed, 18 Nov 2020 19:39:50 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0ua2t306wjvjmi@fgctuval.land.test>
In-Reply-To: <20201116180023.GA32481@wind.enjellic.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 16 Nov 2020 12:00:23 -0600, Dr. Greg <greg@enjellic.com> wrote:

> On Thu, Nov 12, 2020 at 02:41:00PM -0800, Andy Lutomirski wrote:
>
> Good morning, I hope the week is starting well for everyone.
>
>> On Thu, Nov 12, 2020 at 1:31 PM Dave Hansen <dave.hansen@intel.com>  
>> wrote:
>> >
>> > On 11/12/20 12:58 PM, Dr. Greg wrote:
>> > > @@ -270,11 +270,10 @@ static int sgx_vma_mprotect(struct  
>> vm_area_struct *vma,
>> > >                           struct vm_area_struct **pprev, unsigned  
>> long start,
>> > >                           unsigned long end, unsigned long newflags)
>> > >  {
>> > > -     int ret;
>> > > +     struct sgx_encl *encl = vma->vm_private_data;
>> > >
>> > > -     ret = sgx_encl_may_map(vma->vm_private_data, start, end,  
>> newflags);
>> > > -     if (ret)
>> > > -             return ret;
>> > > +     if ( test_bit(SGX_ENCL_INITIALIZED, &encl->flags) )
>> > > +             return -EACCES;
>> > >
>> > >       return mprotect_fixup(vma, pprev, start, end, newflags);
>> > >  }
>> >
>> > This rules out mprotect() on running enclaves.  Does that break any
>> > expectations from enclave authors, or take away capabilities that  
>> folks
>> > need?
>
>> It certainly prevents any scheme in which an enclave coordinates
>> with the outside world to do W-and-then-X JIT inside.  I'm also not
>> convinced it has any real effect at all unless there's some magic I
>> missed to prevent someone from using mmap(2) to effectively change
>> permissions.
>
> The patch that I posted yesterday addresses the security issue for
> both mmap and mprotect by trapping the permission change request at
> the level of the sgx_encl_may_map() function.
>
> With respect to the W-and-then-X JIT issue, the stated purpose of the
> driver is to implement basic SGX functionality, which is SGX1
> semantics, it has been stated formally for a year by the developers
> themselves that they are not entertaining a driver that addresses any
> of the issues associated with non-static memory permissions.
>

The JIT issue is applicable even to SGX1 platforms. We can do EADD with  
EPCM.RWX in sec_info and with PTE.RW, EINIT, then mprotect to set PTE.RX  
when JIT is done.

Haitao
