Return-Path: <SRS0=Q2gl=CU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF9BC43461
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Sep 2020 11:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B539F22204
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Sep 2020 11:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgIKLvP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Sep 2020 07:51:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:58812 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgIKLvE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Sep 2020 07:51:04 -0400
IronPort-SDR: j41a3vyCMSm65K5/Xo7R4A+zZ/sAYrpvA0ayEPCxhbecDsLk4RaQ/susFbwYzPAWku8r6j2ndF
 FqePnVZQN0Gg==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="156139001"
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="156139001"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 04:50:35 -0700
IronPort-SDR: sCXj8DwhkG+ftXl2ZCw3+NB1UoQfDr6Fyj1BEnNUFbpE3DRNLXbpF37A+5lhJESmq5OIbMHDtI
 cBgq5hwnyp8g==
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="378541862"
Received: from amaksymi-mobl.ger.corp.intel.com (HELO localhost) ([10.252.60.247])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 04:50:32 -0700
Date:   Fri, 11 Sep 2020 14:50:30 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Darren Kenny <darren.kenny@oracle.com>
Cc:     linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86/sgx: Roof the number of pages process in
 SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20200911115030.GB5718@linux.intel.com>
References: <20200908190042.24895-1-jarkko.sakkinen@linux.intel.com>
 <m2k0x346kx.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2k0x346kx.fsf@oracle.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 09, 2020 at 10:55:58AM +0100, Darren Kenny wrote:
> On Tuesday, 2020-09-08 at 22:00:42 +03, Jarkko Sakkinen wrote:
> > Remove 'count' from struct sgx_enclave_add_pages and return number of
> > pages processed as a positive return as there is no reasonable use for
> > -EINTR for the caller. Then, roof the processing with a fixed constant
> > and break out the loop also when this value is surpassed.
> >
> > Link: https://lore.kernel.org/linux-sgx/20200626153400.GE27151@zn.tnic/
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Borislav Petkov <bp@suse.de>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/include/uapi/asm/sgx.h |  2 --
> >  arch/x86/kernel/cpu/sgx/ioctl.c | 10 ++++------
> >  arch/x86/kernel/cpu/sgx/sgx.h   |  1 +
> >  3 files changed, 5 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> > index b3d5ccf5b976..1564d7f88597 100644
> > --- a/arch/x86/include/uapi/asm/sgx.h
> > +++ b/arch/x86/include/uapi/asm/sgx.h
> > @@ -45,7 +45,6 @@ struct sgx_enclave_create  {
> >   * @length:	length of the data (multiple of the page size)
> >   * @secinfo:	address for the SECINFO data
> >   * @flags:	page control flags
> > - * @count:	number of bytes added (multiple of the page size)
> >   */
> >  struct sgx_enclave_add_pages {
> >  	__u64	src;
> > @@ -53,7 +52,6 @@ struct sgx_enclave_add_pages {
> >  	__u64	length;
> >  	__u64	secinfo;
> >  	__u64	flags;
> > -	__u64	count;
> >  };
> >  
> >  /**
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> > index 6c3c6177b690..0ae00fa9b589 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -490,7 +490,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> >   * caller.
> >   *
> >   * Return:
> > - *   0 on success,
> > + *   length of the data processed on success,
> >   *   -EACCES if an executable source page is located in a noexec partition,
> >   *   -EIO if either ENCLS[EADD] or ENCLS[EEXTEND] fails
> >   *   -errno otherwise
> > @@ -530,8 +530,8 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
> >  		return -EINVAL;
> >  
> >  	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
> > -		if (signal_pending(current)) {
> > -			ret = -EINTR;
> > +		if (c == SGX_MAX_ADD_PAGES_LENGTH || signal_pending(current)) {
> 
> I know that SGX_MAX_ADD_PAGES_LENGTH may be a multiple of PAGE_SIZE, but
> to be sure that nothing breaks here in the future, I think it would be
> better to use '>=' as the comparison rather than just '=='.


I'm not forseeing this. We will change the comparison or remove it if
the constant is no longer required.

> 
> Also, the indentation seems off here w.r.t. using TABs when the break
> below is using spaces - would be good to have them the same at least.

Ugh, that must be my mistake. I'll check these before squashing this.

Thank you.



/Jarkko
