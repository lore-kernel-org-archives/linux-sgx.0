Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388EBC433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jan 2022 12:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345683AbiAYMIl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jan 2022 07:08:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52970 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344858AbiAYMGp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 25 Jan 2022 07:06:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB6B4B817ED
        for <linux-sgx@vger.kernel.org>; Tue, 25 Jan 2022 12:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6641C340E0;
        Tue, 25 Jan 2022 12:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643112393;
        bh=Uvl2nZ/Bem8omy1N7KAD1XvAODVMjwC3hOeZ1E3wWDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xnyynt++3Ygh90Mgv45mwICb1wc6goLOmqNDjbklE9hDi0S1QsyRD+6uGlnKU8K9e
         OeAvbxN2SrAEvGWvSbI33kDs6wtkbWXp7rXJxndGpGH/3BDIoiLaTlwhi5Q3lk2NAo
         UtcCFLpOsiBESTn964SCSoAXDjxa9rtH7QjJTA3ZElEb9esHC5tta1rni0OG6iHfvT
         KgDtTMskUAIrgDJJMJxglm1JFvBsNtkLd3rULBdrlufrW+eqiAh1dcT9hdC80rDegS
         EMhU+3hjs65mtdrEYv9uYO/qwlG7A4YKyfOnpp+aic/74BapFSCZ1aOFE9QuPYHsWO
         41rv/K5p3Wn9g==
Date:   Tue, 25 Jan 2022 14:06:12 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: Testing 5.17 bugfix material
Message-ID: <Ye/ntErfl1ARo4S0@iki.fi>
References: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
 <06fa9c6e691db71abec906ebce14167bb896ade2.camel@intel.com>
 <Ye7oYz9Lj8yLadyT@iki.fi>
 <9ea2d9cdf649186a4079061bf6b654378c3d256e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea2d9cdf649186a4079061bf6b654378c3d256e.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 24, 2022 at 08:59:14PM +0000, Accardi, Kristen C wrote:
> On Mon, 2022-01-24 at 19:56 +0200, Jarkko Sakkinen wrote:
> > On Mon, Jan 24, 2022 at 05:44:43PM +0000, Accardi, Kristen C wrote:
> > > On Fri, 2022-01-21 at 11:57 -0800, Dave Hansen wrote:
> > > > Hi Everyone,
> > > > 
> > > > There are a few SGX fixes that have showed up in the last week or
> > > > so,
> > > > mostly around RAS and fixing the backing storage issues.  Could
> > > > folks
> > > > please give this branch a good thrashing?
> > > > 
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=x86/sgx
> > > > 
> > > > I'm planning to send this bunch up to Linus after 5.17-rc1 comes
> > > > out.
> > > > 
> > > > Kristen, I really dug into the changelogs of your two patches to
> > > > make
> > > > it
> > > > more clear that they are bugfix and stable@ material.  I'd
> > > > appreciate
> > > > some additional eyeballs there.
> > > 
> > > There's a bug in the calculation for the available backing bytes,
> > > pointed out by Haitao and team. Here's a fix applied to your tree.
> > > 
> > > From 2ebcf0e70b1235224410e08c983e357d5ac3c435 Mon Sep 17 00:00:00
> > > 2001
> > > From: Kristen Carlson Accardi <kristen@linux.intel.com>
> > > Date: Mon, 24 Jan 2022 09:28:56 -0800
> > > Subject: [PATCH] x86/sgx: fixup for available backing pages
> > > calculation
> > > 
> > > Remove improper parentheses from calculation for available backing
> > > bytes. Without this fix, the result will be incorrect due to
> > > rounding.
> > > 
> > > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/sgx/main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/sgx/main.c
> > > b/arch/x86/kernel/cpu/sgx/main.c
> > > index 7ed6a1b10c21..10a6af89bf64 100644
> > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > @@ -922,7 +922,7 @@ static bool __init sgx_page_cache_init(void)
> > >  		return false;
> > >  	}
> > >  
> > > -	available_backing_bytes = total_epc_bytes *
> > > (sgx_overcommit_percent / 100);
> > > +	available_backing_bytes = total_epc_bytes *
> > > sgx_overcommit_percent / 100;
> > >  	atomic_long_set(&sgx_nr_available_backing_pages,
> > > available_backing_bytes >> PAGE_SHIFT);
> > >  
> > >  	return true;
> > > -- 
> > > 2.20.1
> > > 
> > 
> > So what about sgx_reclaim_pages() having no return value that Haitao
> > pointed out?
> 
> I'm taking a look at that, and testing, and will send a separate fix.

NP, take your time, just remarked that it looks legit :-)

/Jarkko
