Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2B1C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 18:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFDD361A21
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 18:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237547AbhCXSYp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:24:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:16715 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237298AbhCXSYZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Mar 2021 14:24:25 -0400
IronPort-SDR: u0BXAHGzOwwtHi+J0WuD0hauc5P3vEw3lxRRv8ZSlpY/zLLge78r0pxCyli4dCNRDgnxVumjOK
 +2tDcyNNJ+yw==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="190857221"
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="190857221"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 11:24:23 -0700
IronPort-SDR: H8fKkRDL6KDXqfGvIm5i/rDyWLDoiuYZ4U3ghKa7SfHZ8PkFVBZolHrPcKfXz3YJPYnLU4gbQW
 lA14730w3S1A==
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="408967340"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 11:24:23 -0700
Date:   Wed, 24 Mar 2021 11:24:22 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] x86: Remove unnecessary kmap() from
 sgx_ioc_enclave_init()
Message-ID: <20210324182422.GU3014244@iweiny-DESK2.sc.intel.com>
References: <20210306002058.303796-1-ira.weiny@intel.com>
 <20210324094720.GA5010@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324094720.GA5010@zn.tnic>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 24, 2021 at 10:47:20AM +0100, Borislav Petkov wrote:
> On Fri, Mar 05, 2021 at 04:20:58PM -0800, ira.weiny@intel.com wrote:
> 
> > Subject: Re: [PATCH v5] x86: Remove unnecessary kmap() from  sgx_ioc_enclave_init()
> 
> The tip tree preferred format for patch subject prefixes is
> 'subsys/component:', e.g. 'x86/apic:', 'x86/mm/fault:', 'sched/fair:',
> 'genirq/core:'. Please do not use file names or complete file paths as
> prefix. 'git log path/to/file' should give you a reasonable hint in most
> cases.

Fixed.

> 
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > kmap is inefficient and we are trying to reduce the usage in the kernel.
> 
> Please use passive voice in your commit message: no "we" or "I", etc,
> and describe your changes in imperative mood.
> 
> Also, pls read section "2) Describe your changes" in
> Documentation/process/submitting-patches.rst for more details.
> 
> Bottom line is: personal pronouns are ambiguous in text, especially with
> so many parties/companies/etc developing the kernel so let's avoid them
> please.

Fixed.

> 
> > @@ -615,11 +614,14 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> >  	if (copy_from_user(&init_arg, arg, sizeof(init_arg)))
> >  		return -EFAULT;
> >  
> > -	initp_page = alloc_page(GFP_KERNEL);
> > -	if (!initp_page)
> > +	/*
> > +	 * sigstruct must be on a page boundry and token on a 512 byte boundry
> > +	 * kmalloc() gives us this alignment when allocating PAGE_SIZE bytes
> 
> Please integrate scripts/checkpatch.pl into your patch creation
> workflow. Some of the warnings/errors *actually* make sense.
> 
> WARNING: 'boundry' may be misspelled - perhaps 'boundary'?
> #90: FILE: arch/x86/kernel/cpu/sgx/ioctl.c:618:
> +        * sigstruct must be on a page boundry and token on a 512 byte boundry
>                                        ^^^^^^^
> 
> WARNING: 'boundry' may be misspelled - perhaps 'boundary'?
> #90: FILE: arch/x86/kernel/cpu/sgx/ioctl.c:618:
> +        * sigstruct must be on a page boundry and token on a 512 byte boundry
>                                                                        ^^^^^^^
> 
> Also, do you see how other comments in this file are proper sentences?
> Please formulate yours this way too.

Thanks fixed.

> 
> The change itself looks ok.

Thanks, new version 5 sent.

Ira

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
