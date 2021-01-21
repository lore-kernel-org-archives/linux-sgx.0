Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12EEC433E6
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 00:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC8F23730
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 00:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbhAUAvq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 19:51:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732789AbhAUAbf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Jan 2021 19:31:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 032102376F;
        Thu, 21 Jan 2021 00:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611189054;
        bh=4yI1tHsy7IU5ZtsfF68rC47orrOygZ+JpaM2hnsfqGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iWnwvweNrT/zWAAr1o94ACIxD2d52gIZHO+DTKnrAoZA6C/8yHZEvXA/g9pK8Q1bD
         exhyyXx7mFrbBgemBuOtJDjF8KSqWe2y/0bG+MN0XtDIcgVCK8NeSbhDVVbpcwjuOs
         obGchRMqgE35o0yO2ZtUCAID2uGxaJfjgXVblXfW0Ygvg+gCZMc7ruWWHENwAZDHeF
         lHBh6RGuTkKmGx6hjor4lDKUyTFQRfBW2MKkcd7n/+FAj85XZlMvcWif/s7nmpY/cl
         HEXPj57fK1zqZUo27sHESK4p7msj1Xpx+zlGAtmLzZytkJuvtiogf8DxfAa6bXy5U4
         th4s3WlGBNfgQ==
Date:   Thu, 21 Jan 2021 02:30:49 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Subject: Re: [PATCH v2] x86/sgx: Remove redundant if conditions in
 sgx_encl_create
Message-ID: <YAjLOWvDblzFICS2@kernel.org>
References: <20210120035328.19868-1-tianjia.zhang@linux.alibaba.com>
 <YAhsyXahEYjV7DZ8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAhsyXahEYjV7DZ8@google.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 20, 2021 at 09:47:53AM -0800, Sean Christopherson wrote:
> On Wed, Jan 20, 2021, Tianjia Zhang wrote:
> > In this scenario, there is no case where va_page is NULL, and
> > the error has been checked. The if condition statement here is
> > redundant, so remove the condition detection.
> > 
> > Reported-by: Jia Zhang <zhang.jia@linux.alibaba.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/ioctl.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> > index 1c6ecf9fbeff..efad2fb61c76 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -66,9 +66,12 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> >  	va_page = sgx_encl_grow(encl);
> >  	if (IS_ERR(va_page))
> >  		return PTR_ERR(va_page);
> > -	else if (va_page)
> > -		list_add(&va_page->list, &encl->va_pages);
> > -	/* else the tail page of the VA page list had free slots. */
> > +
> > +	if (WARN_ONCE(!va_page,
> > +		      "the tail page of the VA page list had free slots\n"))
> 
> IMO it's worth trimming down the message to keep this on a single line.  The
> newline isn't necessary, and this code expects a completely empty list, e.g. it
> can be reworded to something like:
> 
> 	if (WARN_ONCE(!va_page, "non-empty VA page list before ECREATE"))

Agreed. If I recall correctly, these days you can have at least 100
characters per line (if not more, cannot recall the exact number).

/Jarkko

> 
> > +		return -EIO;
> > +
> > +	list_add(&va_page->list, &encl->va_pages);
> >  
> >  	/* The extra page goes to SECS. */
> >  	encl_size = secs->size + PAGE_SIZE;
> > -- 
> > 2.19.1.3.ge56e4f7
> > 
> 
