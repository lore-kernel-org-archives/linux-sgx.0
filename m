Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F778C12002
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Jul 2021 23:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D1C661360
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Jul 2021 23:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhGNXLS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbhGNXLS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 14 Jul 2021 19:11:18 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FD1C061760
        for <linux-sgx@vger.kernel.org>; Wed, 14 Jul 2021 16:08:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x16so3359790pfa.13
        for <linux-sgx@vger.kernel.org>; Wed, 14 Jul 2021 16:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K/NuvTBS8hSpo+aPjZhTeBLUsME49BowO7AjRtNJH9s=;
        b=qK7bcTp8HEGodO52BtnpGPmzpRz4poywlXvqa+UJ0M4EwpuOYkKZBXiRUIhOEECmtE
         2AISWHQqMfGl6ds1TLkIfMbL0ZrUyWCO9Jbkh0JuaV4ddrWZ+g23WWo/RGX1bzECXsfD
         +0dXQzysWR0rkdTDPwbPs91blA+hC41hCORvslhP/ttDtiPi5ddVEYHTaEi95L2sXV3s
         k4Dvq0Zq2NFY8NiLeaYWabh25MGmwh20sGbl8OSxyd5an7zqepmq45uSi6meWaHvMyAP
         qTXna3QCsP5YVpdNBP6XEWzEYy1AB8g2ekn3hUcoG2xPWyMfOm7o/c9k2cTp0eMfbxrf
         W81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K/NuvTBS8hSpo+aPjZhTeBLUsME49BowO7AjRtNJH9s=;
        b=h3mHLeZwEASxhUguQQX/mgkECCSUNmnHSYIA20XZqtEL+UoIaGI9LursGE7pKlLrzL
         RB4+ITIRByfJdsIFMlcbtduFCU44P2uTxBWYXUtXa8vnS5bztPCZ7JxFC0FCMrYEFj89
         muy0NKrWB3JePEspncMVZqGaoG81O87OxwP1FoACrElG3PIBcn4aqX5Q0DkgLT3Ieuu6
         T9u/ZUGIBAsjVOJ9j6R+HVyyCpRS6cvtxpt5VYsV3CGgYkuE4XEZgRiFtHcvkyaw9zLK
         ufKDZOLIlKZfNYL9rrezCgK4a2/sMkHDv6tOuieL5o44NOpf7dO1VrqfwdX08quGRwFF
         87Rg==
X-Gm-Message-State: AOAM531+jIsiYXyR/Z4CMRfXP9uWhhpPwsuWFm5M64lwfBTzNI1JknbM
        nGFl2XinaUnZfKqUQtgZQgZEDA==
X-Google-Smtp-Source: ABdhPJyMGKKzUGD6hIvMFpkrDTbtFf6J7jN2++qco+lVST9vfqybScV8Z1vIYNMbSt72xZ8dQ2PBiw==
X-Received: by 2002:a63:505d:: with SMTP id q29mr425830pgl.137.1626304104367;
        Wed, 14 Jul 2021 16:08:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f16sm4180598pgb.51.2021.07.14.16.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 16:08:23 -0700 (PDT)
Date:   Wed, 14 Jul 2021 23:08:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86/sgx: Track phase and type of SGX EPC pages
Message-ID: <YO9uZKLYCIBc1HsH@google.com>
References: <20210708181423.1312359-1-tony.luck@intel.com>
 <20210708181423.1312359-2-tony.luck@intel.com>
 <93845f78-120d-7522-bd3e-fe042380d29e@intel.com>
 <31668f36583844cbbae0b10a594193d6@intel.com>
 <00114991-9075-84f4-797d-f0f953d34660@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00114991-9075-84f4-797d-f0f953d34660@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 14, 2021, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/14/2021 1:59 PM, Luck, Tony wrote:
> > > Could this tracking be done at the enclave page (struct sgx_encl_page)
> > > instead?
> > 
> > In principle yes. Though Sean has some issues with me tracking types
> > at all.

I've no objection to tracking the type for SGX2, my argument in the context of
#MC support is that there should be no need to track the type.  Either the #MC
is recoverable or it isn't, and the enclave is toast regardless of what type of
page hit the #MC.

There might be a need to identify track vEPC pages, e.g. to avoid the retpoline
associated with a virtual function table, but IMO that would be better done as a
new flag instead of overloading the page type.  E.g. a page can be both a
vEPC page and an SECS/REG/VA page depending on its use in the guest.

> For the SGX2 work knowing the page types are useful. Some instructions only
> work on certain page types and knowing beforehand whether an instruction
> could work helps to avoid dealing with the errors when it does not work.

Yes, but the SGX2 use case is specific to "native" enclaves, i.e. it can and
should be limited to sgx_encl_page, as opposed to being shoved into sgx_epc_page.

> > > The enclave page's EPC page information is not available when
> > > the page is in swap and it would be useful to know the page type without
> > > loading the page from swap. The information would continue to be
> > > accessible from struct epc_page via the owner pointer that may make some
> > > of the changes easier since it would not be needed to pass the page type
> > > around so much and thus possibly address the SECS page issue that Sean
> > > pointed out in
> > > https://lore.kernel.org/lkml/YO3FuBupQTKYaKBf@google.com/
> > 
> > I think I noticed that the "owner" pointer in sgx_encl_page doesn't point
> > back to the epc_page for all types of SGX pages. So some additional
> > changes would be needed. I'm not at all sure why this is different (or
> > what use the non-REG pages use "owner" for.
> 
> This may be VA pages? struct sgx_va_page also contains a pointer to an EPC
> page. I did not consider that for this case. Perhaps these could be
> identified uniquely.

The "owner" is currently only used for reclaim.  IIRC, the proposed EPC cgroup
also used "owner" to enable forced "reclaim", i.e. reclaiming EPC by nuking the
owning entity, e.g. tearing down a virtual EPC section.  And I believe the cgroup
also used the aforementioned vEPC flag to invoke the correct EPC OOM reaper.
