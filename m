Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC5FC433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Jan 2022 17:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244618AbiAXR5N (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Jan 2022 12:57:13 -0500
Received: from meesny.iki.fi ([195.140.195.201]:41828 "EHLO meesny.iki.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244534AbiAXR5M (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Jan 2022 12:57:12 -0500
Received: from localhost (91-154-92-187.elisa-laajakaista.fi [91.154.92.187])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sakkinen)
        by meesny.iki.fi (Postfix) with ESMTPSA id 9FC9E20072;
        Mon, 24 Jan 2022 19:57:10 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1643047030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Iy4LZKq4pv4S0rz4xvIuspOXnd/d1UaY0kg4oSFtjCU=;
        b=btLB0KTIDGYb+WRjKD2Dunao5qwT/dQl/M/SAbqWMPX8iic4NunW+j9wVrBfyVwml4LTFd
        3wZr9z7WEt5eEp6GNQ1bw4p7FLOU2QtYFpCqgXCoc8slyqvYPCyouGt+GKG7Xef1DZ2nuF
        UWBNN2rgchDYIx2uBKsPTUwiRzKP+t4=
Date:   Mon, 24 Jan 2022 19:56:51 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
To:     "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: Testing 5.17 bugfix material
Message-ID: <Ye7oYz9Lj8yLadyT@iki.fi>
References: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
 <06fa9c6e691db71abec906ebce14167bb896ade2.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06fa9c6e691db71abec906ebce14167bb896ade2.camel@intel.com>
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=sakkinen smtp.mailfrom=jarkko.sakkinen@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1643047030; a=rsa-sha256; cv=none;
        b=dKDZgN90TNLERgfJmAnCqbWCvxavJV7rmqdhB4dRwOfid6YjacfbdeRGzkQxvhyd0UZrxK
        5pYjQFhjy+P8v7EVkFwhBhG6Gtj09mf6lgBxYUom+a2i9UnOUVebD5q9lc6VwDHUTiSfEY
        rHbgGB0Zu67na14gOmZuJJ8YyeiLXVM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1643047030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Iy4LZKq4pv4S0rz4xvIuspOXnd/d1UaY0kg4oSFtjCU=;
        b=xyJ0YWPFrg22mXZn32StFf6C9pZpRexCCFfAUgwzfOQufIyPaxMk7xB1HfONvfhgCNUKes
        iNVWaSSq+bxgJfHSuMR8I78Ix9dQpaf9BwQPYJahfl4EoCgh9LsyqDzHqUucZAl0n2sge1
        t+wp36pB4sNHwl6n9Gcw9+hxifsFy/8=
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 24, 2022 at 05:44:43PM +0000, Accardi, Kristen C wrote:
> On Fri, 2022-01-21 at 11:57 -0800, Dave Hansen wrote:
> > Hi Everyone,
> > 
> > There are a few SGX fixes that have showed up in the last week or so,
> > mostly around RAS and fixing the backing storage issues.  Could folks
> > please give this branch a good thrashing?
> > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=x86/sgx
> > 
> > I'm planning to send this bunch up to Linus after 5.17-rc1 comes out.
> > 
> > Kristen, I really dug into the changelogs of your two patches to make
> > it
> > more clear that they are bugfix and stable@ material.  I'd appreciate
> > some additional eyeballs there.
> 
> There's a bug in the calculation for the available backing bytes,
> pointed out by Haitao and team. Here's a fix applied to your tree.
> 
> From 2ebcf0e70b1235224410e08c983e357d5ac3c435 Mon Sep 17 00:00:00 2001
> From: Kristen Carlson Accardi <kristen@linux.intel.com>
> Date: Mon, 24 Jan 2022 09:28:56 -0800
> Subject: [PATCH] x86/sgx: fixup for available backing pages calculation
> 
> Remove improper parentheses from calculation for available backing
> bytes. Without this fix, the result will be incorrect due to
> rounding.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 7ed6a1b10c21..10a6af89bf64 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -922,7 +922,7 @@ static bool __init sgx_page_cache_init(void)
>  		return false;
>  	}
>  
> -	available_backing_bytes = total_epc_bytes * (sgx_overcommit_percent / 100);
> +	available_backing_bytes = total_epc_bytes * sgx_overcommit_percent / 100;
>  	atomic_long_set(&sgx_nr_available_backing_pages, available_backing_bytes >> PAGE_SHIFT);
>  
>  	return true;
> -- 
> 2.20.1
> 

So what about sgx_reclaim_pages() having no return value that Haitao
pointed out?

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
