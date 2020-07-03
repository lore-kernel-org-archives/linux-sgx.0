Return-Path: <SRS0=squH=AO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D080BC433E1
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jul 2020 03:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B87E920A8B
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jul 2020 03:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGCDJo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jul 2020 23:09:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:43112 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgGCDJo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Jul 2020 23:09:44 -0400
IronPort-SDR: Oh2U5pS+1iJOcn5ffAEMiQLvZ7/K5CqCouF7fxnmbCMFHzhix/p9hoZ+GMFsfXfiV3ZXGrAtd/
 zeKaE8Lt9H0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="127166618"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="127166618"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 20:09:43 -0700
IronPort-SDR: aPFCC2Rjr2grbjLW42eLLUBa1wZ2Pj6RM0b2nYbGW7eym/tg1+xXFs6GGgWYXShSYtcTco/gLx
 R/ivR5oK335g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="455744536"
Received: from skochetx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.55.66])
  by orsmga005.jf.intel.com with ESMTP; 02 Jul 2020 20:09:29 -0700
Date:   Fri, 3 Jul 2020 06:09:28 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200703030928.GE306897@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200626091419.GB27151@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626091419.GB27151@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 26, 2020 at 11:14:19AM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > index 59472cd6a11d..35f713e3a267 100644
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -323,6 +323,7 @@ Code  Seq#    Include File                                           Comments
> >                                                                       <mailto:tlewis@mindspring.com>
> >  0xA3  90-9F  linux/dtlk.h
> >  0xA4  00-1F  uapi/linux/tee.h                                        Generic TEE subsystem
> > +0xA4  00-1F  uapi/asm/sgx.h                                          Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)
> 
> Maybe add <mailto:linux-sgx@vger.kernel.org> ?
> 
> >  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> >  0xAB  00-1F  linux/nbd.h
> >  0xAC  00-1F  linux/raw.h
> 
> ...
> 
> > +static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> > +{
> > +	unsigned long encl_size = secs->size + PAGE_SIZE;
> 
> Wait, you just copied @secs from user memory in sgx_ioc_enclave_create()
> and now use ->size unverified? You're kidding, right?

The validation is done in sgx_validate_secs().

> 
> > +	struct sgx_epc_page *secs_epc;
> > +	unsigned long ssaframesize;
> > +	struct sgx_pageinfo pginfo;
> > +	struct sgx_secinfo secinfo;
> > +	struct file *backing;
> > +	long ret;
> > +
> > +	if (atomic_read(&encl->flags) & SGX_ENCL_CREATED)
> > +		return -EINVAL;
> > +
> > +	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);
> 
> So this is using more un-validated user input to do further calculations.
> What can possibly go wrong?
> 
> I sure hope *I* am wrong and am missing something here.
> 
> If not, please, for the next version, audit all your user input and
> validate it before using it. Srsly.

It works but is unclean. I'd guess reason for this is just that code has
evolved into this state over time.

I'd just move the call to sgx_calc_ssaframesize() inside
sgx_validate_secs().

/Jarkko
