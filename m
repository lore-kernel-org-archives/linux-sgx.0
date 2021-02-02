Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C82C433E6
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 18:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1F4E64F7E
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 18:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbhBBSXi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Feb 2021 13:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbhBBSVf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 2 Feb 2021 13:21:35 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4516C061786
        for <linux-sgx@vger.kernel.org>; Tue,  2 Feb 2021 10:20:54 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id q131so14885546pfq.10
        for <linux-sgx@vger.kernel.org>; Tue, 02 Feb 2021 10:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RUsJDxkSlqcCKd7R0SLhR0x18td21Yut7qTAhHydX0E=;
        b=R6bZWeUaDuiTpU50NcqXVnAlaBiFhTfKyqhjb4Xc9GUgUfNzelCAxNUQmzw9JVzUU7
         wE3JysIkGJ5u7KizUSGt2C9XwNcm/juELt5J1W28M/S+5j4/zhG8PoYG/PrBzcJwfG3w
         KeupjX4ajavNjLVA+vuUtq2BgF8v4MMdD1k6OxYEYTNnUbBUIqtdpgceie7uCLQlPfu1
         bpBAoHSJKm7aajrKuODIvDWOz6Npa/8ICJCKdWxk0Q/hBUP6u7GD6h6AQQIW7P/VOnRN
         9e/9+I3KkXjQ8+/mLCOjfUnVD8HVjITCyDc7hwpQ7rqboexYI1RbwSxYNEr30zqzTpNt
         xqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RUsJDxkSlqcCKd7R0SLhR0x18td21Yut7qTAhHydX0E=;
        b=N+exH97vzaf3xGN+atzZiOpi4YDhQmdDMkcrRpRnYNJmbUP5r2ovzqUL5EAoDoCRVe
         X/rLsPb9zYVxHKRLl1udTD3pulq6lwdDtbXhszNSbhBiWpDMzrE6393r6gbjAHOeeWCI
         JR7NoU8+lz9CXlnqUspvJ5sN8uEDs3KYmAJO4QvLM603OYkBMG54OBXZ8QJ2Vu82g8Jc
         ywFkAi+csi1jwhNJSASPxKmgzlz4fBcjuwN3ESw2qoQO8vmMCsONHNVT5biz4owi4m5p
         HFXjMgVoEtfA0s4iO914FhUdCj1eCq7ZqAYzudZR4h1OiwJEOXZ2h1BHCZP6KV1VZjRr
         uCeQ==
X-Gm-Message-State: AOAM530BirVIIOAzE5CZaEVwYW+hJv+Kwv6LHG5Q7Hi5losGbrKG9hUc
        hLfXbj8ZxNC8aGWRvWWzZhgAuQ==
X-Google-Smtp-Source: ABdhPJz0bTAsW+a3ILACMhhOP/S/IsxtT/MfAyGbcktLEsPs+7pbX3OOIGvpENWvZ6UgILikIVrFxA==
X-Received: by 2002:aa7:9399:0:b029:1cc:5346:1edd with SMTP id t25-20020aa793990000b02901cc53461eddmr13856032pfe.28.1612290054223;
        Tue, 02 Feb 2021 10:20:54 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id w10sm20274063pfj.150.2021.02.02.10.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 10:20:53 -0800 (PST)
Date:   Tue, 2 Feb 2021 10:20:47 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBmX/wFFshokDqWM@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
 <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <YBmMrqxlTxClg9Eb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBmMrqxlTxClg9Eb@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 02, 2021, Jarkko Sakkinen wrote:
> On Mon, Feb 01, 2021 at 06:40:40PM +1300, Kai Huang wrote:
> > On Sat, 30 Jan 2021 16:45:43 +0200 Jarkko Sakkinen wrote:
> > > On Tue, Jan 26, 2021 at 10:31:00PM +1300, Kai Huang wrote:
> > > > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > > > even if the bare-metal SGX driver is disabled.  The bare-metal driver
> > > > might be disabled if SGX Launch Control is in locked mode, or not
> > > > supported in the hardware at all.  This allows (non-Linux) guests that
> > > > support non-LC configurations to use SGX.
> > > > 
> > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > ---
> > > > v2->v3:
> > > > 
> > > >  - Changed from sgx_virt_epc_init() to sgx_vepc_init().
> > > > 
> > > > ---
> > > >  arch/x86/kernel/cpu/sgx/main.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > > index 21c2ffa13870..93d249f7bff3 100644
> > > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > > @@ -12,6 +12,7 @@
> > > >  #include "driver.h"
> > > >  #include "encl.h"
> > > >  #include "encls.h"
> > > > +#include "virt.h"
> > > >  
> > > >  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> > > >  static int sgx_nr_epc_sections;
> > > > @@ -712,7 +713,8 @@ static int __init sgx_init(void)
> > > >  		goto err_page_cache;
> > > >  	}
> > > >  
> > > > -	ret = sgx_drv_init();
> > > > +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> > > > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > > 
> > > If would create more dumb code and just add
> > > 
> > > ret = sgx_vepc_init()
> > > if (ret)
> > >         goto err_kthread;
> > 
> > Do you mean you want below?
> > 
> > 	ret = sgx_drv_init();
> > 	ret = sgx_vepc_init();
> > 	if (ret)
> > 		goto err_kthread;
> > 
> > This was Sean's original code, but Dave didn't like it.
> 
> I think it should be like:
> 
> ret = sgx_drv_init();
> if (ret)
>         pr_warn("Driver initialization failed with %d\n", ret);
> 
> ret = sgx_vepc_init();
> if (ret)
> 	goto err_kthread;

And that's wrong, it doesn't correctly handle the case where sgx_drv_init()
succeeds but sgx_vepc_init() fails.

> There is problem here anyhow. I.e. -ENODEV's from sgx_drv_init().  I think
> how driver.c should be changed would be just to return 0 in the places
> where it now return -ENODEV. Consider "not initialized" as a successful
> initialization.


