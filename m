Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742E5C433DB
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 07:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A4D464F8C
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 07:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhBEHoU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Feb 2021 02:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbhBEHoR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 5 Feb 2021 02:44:17 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF16AC061786
        for <linux-sgx@vger.kernel.org>; Thu,  4 Feb 2021 23:43:35 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id n7so6549090oic.11
        for <linux-sgx@vger.kernel.org>; Thu, 04 Feb 2021 23:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pNYDAPwmA+T5j4N+W3YFNQofLY2Q0zVUyzfw2M1AxTo=;
        b=Q2BMWEdoyt5JsbluyrH16Kus+GEbCbjKP3WuVs802CW2/HihCB0uwOlViUTXQZVNzN
         s3C5hiSYAbZbqg2E1nAfEi1FEx/D3kJAfILhJrcc3hXV0lOOxgta/C2apinoAKf+KxWJ
         t/6+UVZ99B4akfS6vHKWYKnPDVAkubUnzpf6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pNYDAPwmA+T5j4N+W3YFNQofLY2Q0zVUyzfw2M1AxTo=;
        b=h1isXoAMb9ewGxAfdLmL/o1C4BurChlmH+BDauBNGkmGNLVVp1oMqZAGw/vid+Gt98
         DGPgD8SdSZ7fDSLez056M7BF6WZqpXUvp1rq+HSGuc+wZsywMMTPLaAk95Bd0qpWO3Ny
         Z6f49xmFlt39m4eVqOkPaE21Hjrfp7FNLibG1AsqPC4SBq0Z+c8aDKDmOh6SQyXuhJlZ
         6Ob3F1GRIhr1ypoEVFsoLWRhezPDqBntj6cHCklrCP6rrm+qZp/jITvMr8hFGHUcOQcB
         MDK97JrMB3Wt8BKJG8LyoRQjjyHxGMcJVRszna3aowT3fCT9X3lJDNw2JokwcI29G6iv
         MCKQ==
X-Gm-Message-State: AOAM530N+yAZ9NBlfUSo1Ia+PAuOQB/zh5lGKdtVcv0qPIib+c7LtkPV
        2VCJG/HC5UKStf1NiRKJdI5VoQ4xOS6naRpqaNC7NQ==
X-Google-Smtp-Source: ABdhPJzDeNovUCPUxkRfFTLU3DtLUexLktQWZivHRJ6NvIconAVJrQwO2Lte5w/rWcaQKnjtutQjcyt/8/gUQCEuDy4=
X-Received: by 2002:aca:1906:: with SMTP id l6mr2274756oii.101.1612511015117;
 Thu, 04 Feb 2021 23:43:35 -0800 (PST)
MIME-Version: 1.0
References: <20210204184519.2809313-1-daniel.vetter@ffwll.ch> <YBys6Io1ZbZdzWmj@kernel.org>
In-Reply-To: <YBys6Io1ZbZdzWmj@kernel.org>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 5 Feb 2021 08:43:24 +0100
Message-ID: <CAKMK7uFM=ZW_+D32OGfirwY83ZkUKQpiA-3zGx9KAe1UKjW0XQ@mail.gmail.com>
Subject: Re: [PATCH] x86/sgx: Drop racy follow_pfn check
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 5, 2021 at 3:26 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
>
> On Thu, Feb 04, 2021 at 07:45:19PM +0100, Daniel Vetter wrote:
> > References: https://lore.kernel.org/dri-devel/20201127164131.2244124-1-daniel.vetter@ffwll.ch/
>
> What is the difference between this and "Link:" anyway?

Afaik References: is for other reading (bug reports, discussions,
other patch series), Link: is for patch submission itself (which I
think some subsystem do an entire chain of, on each revision). My
scripts aren't good enough that they add the Link: before submitting,
I add them when I apply patches (since most patches I get don't have
them anyway).

btw since the final patch to remove follow_pfn won't be ready for 5.12
merge window (kvm and vfio have some work to do) I think it's best if
you just queue this up in your tree?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
