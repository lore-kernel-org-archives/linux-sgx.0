Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561BFC433DB
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Jan 2021 05:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EEFD221EA
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Jan 2021 05:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbhAZF6W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbhAYSrO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 25 Jan 2021 13:47:14 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2B9C061574
        for <linux-sgx@vger.kernel.org>; Mon, 25 Jan 2021 10:46:32 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 11so8933920pfu.4
        for <linux-sgx@vger.kernel.org>; Mon, 25 Jan 2021 10:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UoVeAcPYBoVP5YmNMUfLeCvrQBLfaM+e0XI1SRxnQQY=;
        b=CTh/m1HpQKQEbZttGur8vI9oMw39ZBDHSyW9iR9WHtr4mRBDIXg2aDJQLRU5MH/WSW
         WpQRXLxSLG0/6JcjMWSz0QEztRIxCckygLDFJOZNeeCATowa3UE3kkG4mU1mD48uY0LQ
         LmL2cFJcTyPUTsehLxdOgT+4zUsilRFbtH0qSAPdjKdv7kZqRmd1Wy0CidSi/tHi3QMF
         vj5feD/IxBqkgLK48RPJZUCgGLN4hAvDKCRMK47t6JC3yrvU2YFNG2HDGexcXdjqR6RY
         zmT3/BiTduj+n9Kqs6PMzilpqAwu5DMMsyxSu0GuPjJOixMxfwFanW3l5fO29ma4f6lM
         Uhug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UoVeAcPYBoVP5YmNMUfLeCvrQBLfaM+e0XI1SRxnQQY=;
        b=IVIsEBI3EyHWZwpPxWrCJiXPcJNa5RoqianGfdBFEfvuoLd63UwMbXUl0IhmAukg8M
         cFKyZuXbDiud8bsFQAIAMnKEBHfhKmjn9Jlku5WQLUF8u1uUetl2gL/2xKoHbHLQfQQe
         sMFRwFBssTDXC3iD17FMP2V8aJlbzspaidcPpGLUhqc9c6rIx4P7y2Js+6+BwnSyzWRS
         VuYI60RrxbpfxbK8nc0y1jPKGcD2hp2lA5Tr8MiTUsBciJdpNgXlv77fTLBzD7irEfvh
         Gtse+gTYvVnmCB3bM8RACADuV9VPaO6KQkiG8ynXF/UjkQ52raDxPB8kSNplYRA6ZA7T
         /emA==
X-Gm-Message-State: AOAM530hurEA9/n9+ir9mAge4jC5W2qVkC01kY9xVKk/sysbRwaK2kZM
        Rp9LRFZKvsFUoGlb9YIQCeDJ7w==
X-Google-Smtp-Source: ABdhPJxT7fdqgIb+7XNBiAwHrBNT5gYxRrewX2D5LTPe2Cm3sOy174fiftOEXjiG13Ue1bG20wl3Ww==
X-Received: by 2002:a63:770b:: with SMTP id s11mr1899929pgc.342.1611600392333;
        Mon, 25 Jan 2021 10:46:32 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id z3sm16881717pfb.157.2021.01.25.10.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 10:46:31 -0800 (PST)
Date:   Mon, 25 Jan 2021 10:46:25 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Subject: Re: [PATCH v3 5/5] x86/sgx: Remove redundant if conditions in
 sgx_encl_create
Message-ID: <YA8SAf3RFTGU/mhL@google.com>
References: <20210124062907.88229-1-tianjia.zhang@linux.alibaba.com>
 <20210124062907.88229-6-tianjia.zhang@linux.alibaba.com>
 <YA0tvOGp/shchVhu@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YA0tvOGp/shchVhu@kroah.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Jan 24, 2021, Greg KH wrote:
> On Sun, Jan 24, 2021 at 02:29:07PM +0800, Tianjia Zhang wrote:
> > In this scenario, there is no case where va_page is NULL, and
> > the error has been checked. The if condition statement here is
> > redundant, so remove the condition detection.
> > 
> > Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/ioctl.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> > index 1c6ecf9fbeff..b0b829f1b761 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -66,9 +66,11 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> >  	va_page = sgx_encl_grow(encl);
> >  	if (IS_ERR(va_page))
> >  		return PTR_ERR(va_page);
> > -	else if (va_page)
> > -		list_add(&va_page->list, &encl->va_pages);
> > -	/* else the tail page of the VA page list had free slots. */
> > +
> > +	if (WARN_ONCE(!va_page, "non-empty VA page list before ECREATE"))
> > +		return -EIO;
> 
> So you just crashed machines that have panic-on-warn enabled.  Don't do
> that for no reason, just handle the error and move on.

The WARN will only fire if someone introduces a kernel bug.  It's one part
documentation, two parts helping detect future breakage.  Even if the VA page
management is significantly reworked, I'm having a hard time envisioning a
scenario where adding VA pages before ECREATE would be anything but a kernel bug.
