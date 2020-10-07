Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21023C4363D
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 01:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D499320782
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 01:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgJGBRm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Oct 2020 21:17:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:64023 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbgJGBRk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Oct 2020 21:17:40 -0400
IronPort-SDR: FGlFUB6cYExiQqUHpz2sg0hDAWHEfqVuJRUMa5teOExRL2hRhjjQkhlSgAo8PuuA4QQpbcLrn2
 29S7GGImtaaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="249484990"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="249484990"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 18:17:40 -0700
IronPort-SDR: z4GdBqZyOMbCI7Pm9uc6aG8jGviXAZzx5h4TfpxYHByZbgbVjGUnjHJLCPamuh6k7bPj+9z2ca
 YmPDJQ61PO0g==
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="518582544"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 18:17:39 -0700
Date:   Tue, 6 Oct 2020 18:17:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20201007011738.GE28981@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
 <20201006025703.GG15803@linux.intel.com>
 <453c2d9b-0fd0-0d63-2bb9-096f255a6ff4@fortanix.com>
 <20201006151532.GA17610@linux.intel.com>
 <20201006172819.GA114208@linux.intel.com>
 <20201006232129.GB28981@linux.intel.com>
 <20201007002236.GA139112@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007002236.GA139112@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 07, 2020 at 03:22:36AM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 06, 2020 at 04:21:29PM -0700, Sean Christopherson wrote:
> > On Tue, Oct 06, 2020 at 08:28:19PM +0300, Jarkko Sakkinen wrote:
> > > On Tue, Oct 06, 2020 at 08:15:32AM -0700, Sean Christopherson wrote:
> > > > On Tue, Oct 06, 2020 at 10:30:16AM +0200, Jethro Beekman wrote:
> > > > > On 2020-10-06 04:57, Sean Christopherson wrote:
> > > > > > On Sat, Oct 03, 2020 at 07:50:56AM +0300, Jarkko Sakkinen wrote:
> > > > > >> +struct sgx_enclave_run {
> > > > > >> +  __u64 tcs;
> > > > > >> +  __u64 user_handler;
> > > > > >> +  __u64 user_data;
> > > > > >> +  __u32 leaf;
> > > > > >
> > > > > > I am still very strongly opposed to omitting exit_reason.  It is not at all
> > > > > > difficult to imagine scenarios where 'leaf' alone is insufficient for the
> > > > > > caller or its handler to deduce why the CPU exited the enclave.  E.g. see
> > > > > > Jethro's request for intercepting interrupts.
> > > > >
> > > > > Not entirely sure what this has to do with my request, I just expect to see
> > > > > leaf=ERESUME in this case, I think? E.g. as you would see in EAX when calling
> > > > > ENCLU.
> > > > 
> > > > But how would you differentiate from the case that an exception occured in
> > > > the enclave?  That will also transfer control with leaf=ERESUME.  If there
> > > > was a prior exception and userspace didn't zero out the struct, there would
> > > > be "valid" data in the exception fields.
> > > > 
> > > > An exit_reason also would allow retrofitting the exception fields into a
> > > > union, i.e. the fields are valid if and only if exit_reason is exception.
> > > 
> > > Let's purge this a bit. Please remark where my logic goes wrong. I'm
> > > just explaining how I've deduced the whole thing.
> > > 
> > > The information was encoded in v38 version of the vDSO was exactly this:
> > > 
> > > - On normal EEXIT, it got the value 0.
> > > - Otherwise, it got the value 1.
> > > 
> > > The leaf, then embdded to struct sgx_exception but essentially the same
> > > field got the value from EAX, and the value that EAX had was only
> > > written on exception path.
> > > 
> > > Thus, I deduced that if you write $EEXIT to leaf on synchrous exit you
> > > get the same information content, nothing gets overwritten. I.e. you
> > > can make same conclusions as you would with those two struct fields.
> > 
> > And then a third flavor comes along, e.g. Jethro's request interrupt case,
> > and exit_reason can also return '2'.  How do you handle that with only the
> > leaf?
> 
> I'm listening. How was that handled before? I saw only '0' and '1'.  Can
> you bring some context on that? I did read the emails that were swapped
> when the run structure was added but I'm not sure what is the exact
> differentiator. Maybe I'm missing something.

https://patchwork.kernel.org/patch/11719889/
