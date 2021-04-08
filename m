Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EB3C43460
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 16:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC88161181
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 16:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhDHQ1i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 12:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232240AbhDHQ1h (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Apr 2021 12:27:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 133F5610FA;
        Thu,  8 Apr 2021 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617899246;
        bh=XgIz3E6DVRyqNfRyqK/14b+Wtb8Dfx2r6YRrKwYJOeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nASy4t/iCagZZUHEGaUr3t9xuStEQH8cbOY5O/HJ7bj3GOnB9CicfOZ6S55RdTDUu
         2jCkNYWrk+pQyaQqOu187CnEV8zhAOlFTYwKB8aK/8A2K0b7PQhqjMGjk6Vmys1gPC
         t72LRPGb9X7FvUjE99pUAahA5gK1ElGcJwk9XTeQWJ8z7H9jzhxyAaa2t6So6XsCK3
         0t4F36EvAUG65WHeqgke/HYIXdfJJnXn0ebzXPtYAH5Ph6aYQqQvtju7C53XJfUWPm
         QIP+U/pDa6PflTmvz8S+2UfLRcDIknlBedjw3scdY0pvWZ4azW5Ny8mEzXoooUdCQR
         M/dn2bkRQyaBA==
Date:   Thu, 8 Apr 2021 19:27:24 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the
 debugfs
Message-ID: <YG8u7BtcJ43Hao3t@kernel.org>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210405232653.33680-2-jarkko@kernel.org>
 <20210407155636.GG25319@zn.tnic>
 <YG3ZJyMB+S5LcUso@kernel.org>
 <20210407161533.GJ25319@zn.tnic>
 <YG7EWDXmwC9ai38k@kernel.org>
 <YG7JMc6b+HZIZqxM@kernel.org>
 <20210408093223.GG10192@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408093223.GG10192@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 08, 2021 at 11:32:23AM +0200, Borislav Petkov wrote:
> On Thu, Apr 08, 2021 at 12:13:21PM +0300, Jarkko Sakkinen wrote:
> > Actually I think read-only sysctl attributes would be a better idea.
> 
> I still think debugfs is the right *start* for this: you play with them,
> see what makes sense and what not, tweak them, etc, and then you cast
> them in stone.

Yup. Also better to see what makes sense in the context of virtualization.
Too many (unknown) unknowns to make the right call.

> Not cast them in stone and see if anyone is even interested. So pls keep
> them in debugfs for now - you can always do whatever, later, when it
> turns out that those are useful.

I'll do that.

> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
