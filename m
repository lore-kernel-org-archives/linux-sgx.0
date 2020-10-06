Return-Path: <SRS0=YsX3=DN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4064C4363D
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Oct 2020 23:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 551B7206F4
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Oct 2020 23:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgJFXVg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Oct 2020 19:21:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:46817 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgJFXVg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Oct 2020 19:21:36 -0400
IronPort-SDR: clDxPIc3dThM9B4fq+AYHLLiPYkLLJrURjiZ56PRXxxKh0CLafq+cVpXrNrzqOovoFBNjff3aa
 7VEEEtdn2NTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="164809157"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="164809157"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 16:21:34 -0700
IronPort-SDR: VEl41zVVTvoYVJy06WsKjWx/blRN48fEKTknNoT7/m0qhcaNa0xc7faug+agI9D9PeJppJBa4e
 I3DiLWvspbNg==
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="527659173"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 16:21:30 -0700
Date:   Tue, 6 Oct 2020 16:21:29 -0700
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
Message-ID: <20201006232129.GB28981@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
 <20201006025703.GG15803@linux.intel.com>
 <453c2d9b-0fd0-0d63-2bb9-096f255a6ff4@fortanix.com>
 <20201006151532.GA17610@linux.intel.com>
 <20201006172819.GA114208@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006172819.GA114208@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 06, 2020 at 08:28:19PM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 06, 2020 at 08:15:32AM -0700, Sean Christopherson wrote:
> > On Tue, Oct 06, 2020 at 10:30:16AM +0200, Jethro Beekman wrote:
> > > On 2020-10-06 04:57, Sean Christopherson wrote:
> > > > On Sat, Oct 03, 2020 at 07:50:56AM +0300, Jarkko Sakkinen wrote:
> > > >> +struct sgx_enclave_run {
> > > >> +  __u64 tcs;
> > > >> +  __u64 user_handler;
> > > >> +  __u64 user_data;
> > > >> +  __u32 leaf;
> > > >
> > > > I am still very strongly opposed to omitting exit_reason.  It is not at all
> > > > difficult to imagine scenarios where 'leaf' alone is insufficient for the
> > > > caller or its handler to deduce why the CPU exited the enclave.  E.g. see
> > > > Jethro's request for intercepting interrupts.
> > >
> > > Not entirely sure what this has to do with my request, I just expect to see
> > > leaf=ERESUME in this case, I think? E.g. as you would see in EAX when calling
> > > ENCLU.
> > 
> > But how would you differentiate from the case that an exception occured in
> > the enclave?  That will also transfer control with leaf=ERESUME.  If there
> > was a prior exception and userspace didn't zero out the struct, there would
> > be "valid" data in the exception fields.
> > 
> > An exit_reason also would allow retrofitting the exception fields into a
> > union, i.e. the fields are valid if and only if exit_reason is exception.
> 
> Let's purge this a bit. Please remark where my logic goes wrong. I'm
> just explaining how I've deduced the whole thing.
> 
> The information was encoded in v38 version of the vDSO was exactly this:
> 
> - On normal EEXIT, it got the value 0.
> - Otherwise, it got the value 1.
> 
> The leaf, then embdded to struct sgx_exception but essentially the same
> field got the value from EAX, and the value that EAX had was only
> written on exception path.
> 
> Thus, I deduced that if you write $EEXIT to leaf on synchrous exit you
> get the same information content, nothing gets overwritten. I.e. you
> can make same conclusions as you would with those two struct fields.

And then a third flavor comes along, e.g. Jethro's request interrupt case,
and exit_reason can also return '2'.  How do you handle that with only the
leaf?
