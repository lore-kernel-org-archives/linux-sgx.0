Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4449EC433B4
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 16:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 031C461279
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 16:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhDGQJw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Apr 2021 12:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354214AbhDGQJY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Apr 2021 12:09:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F9060232;
        Wed,  7 Apr 2021 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617811754;
        bh=fLoBP1zlGVzAiQlkRSpUhLWqsQma3rzz/VOi1IPRvjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N4erpKd3LaUsMWqR9U8Xv7128BHavJyOuGmbFOdxf5n584ZpVeoxX+FjmbiRLM7/y
         jaDj94ZWKa0CQl4G+p/TuEkg3hMJeTF2BU/93Z5fTOOpz0V4l/ywkJhpsOkVxf+aV8
         J2kAgNyspyEBy4iuZl61bj/0SmA72mEifkqaMxVjZZSEuA7ZZuFhLmu9iWM+Y2qsj0
         OmMxGKpfn4p8D2fm7E2bxD81VAkDD+79+HxCOp77e6SppQiFS97ueU71gVarMkOFs5
         lKOBh78gGSV1UTMH+TT1H6vJIex+GhpKNZFk4rv1ET6GxnXKgK8Df0FjYyp0/9rSaA
         CtukGg1vYj2SQ==
Date:   Wed, 7 Apr 2021 19:09:11 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the
 debugfs
Message-ID: <YG3ZJyMB+S5LcUso@kernel.org>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210405232653.33680-2-jarkko@kernel.org>
 <20210407155636.GG25319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407155636.GG25319@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 07, 2021 at 05:56:36PM +0200, Borislav Petkov wrote:
> On Tue, Apr 06, 2021 at 02:26:53AM +0300, Jarkko Sakkinen wrote:
> > Add two debugs attributes:
> > 
> > * /sys/kernel/debug/x86/sgx_nr_all_pages
> > * /sys/kernel/debug/x86/sgx_nr_free_pages
> 
> Definitely under /sys/kernel/debug/x86/sgx/...
> 				      ^^^^^^
> 
> > These provide useful statistics for testing purposes.
> 
> Testing what exactly?
> 
> Also, if those are EPC pages, why isn't "epc" in the name?

When debugging the SGX code it is useful to quickly check the amount of
EPC pages, and also total amount of EPC available.

I left out "epc" because they are already prefixed with "sgx_".

> > E.g. on a NUC7CJYH2, when no enclaves are running, and EPC set to 32 MB:
> > 
> > $ sudo cat /sys/kernel/debug/x86/sgx_nr_all_pages
> > 5632
> > 
> > $ sudo cat /sys/kernel/debug/x86/sgx_nr_free_pages
> > 5632
> 
> I have no clue what that is useful for. You want to account how many of
> the EPC pages on all nodes are in use? What for?
> 
> Are those globally useful for people? If so, they need to go to sysfs
> along with documentation what they do.
> 
> If not, you can keep this patch in your tree for your own testing.

E.g. when stress testing this might be useful information to scale the
workload for example, or even sample the number of EPC pages. When
otherwise testing this might be useful to catch any leaks. I created
1/2 based on what I saw with these variables.

debugfs was my first shot, but for sure these could be sysfs.

> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > 
> > v2:
> > * Use debugfs_create_ulong():
> >   https://lore.kernel.org/linux-sgx/57c18e08-3e36-b5b3-aaba-9a21b75a1613@intel.com/
> > 
> >  arch/x86/kernel/cpu/sgx/main.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 7df7048cb1c9..07bad864c531 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -1,6 +1,7 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  /*  Copyright(c) 2016-20 Intel Corporation. */
> >  
> > +#include <linux/debugfs.h>
> >  #include <linux/freezer.h>
> >  #include <linux/highmem.h>
> >  #include <linux/kthread.h>
> > @@ -25,7 +26,10 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
> >  static LIST_HEAD(sgx_active_page_list);
> >  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
> >  
> > -/* The free page list lock protected variables prepend the lock. */
> > +/* The number of EPC pages in total in all nodes. */
> > +static unsigned long sgx_nr_all_pages;
> > +
> > +/* The number of free EPC pages in all nodes. */
> >  static unsigned long sgx_nr_free_pages;
> 
> Ok, you're fixing the comment here. Good.

Should that be part of the first patch?

> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

/Jarkko
