Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663C5C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 15 Jan 2021 10:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CA8223603
	for <linux-sgx@archiver.kernel.org>; Fri, 15 Jan 2021 10:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbhAOKJA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 15 Jan 2021 05:09:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbhAOKI7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 15 Jan 2021 05:08:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7422E235F9;
        Fri, 15 Jan 2021 10:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610705299;
        bh=nA4wC43S56EOwm9vQj9uFLi+XUwkcBKjBZHffULpMnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SBB0THer+zQoEo8RlTQoXT2rquhunv1xAZZiRk/3JhXra0qWNmwvJSMMlSy+zWN6w
         vPyMzaeh3P81KVLSGHMcBaLM0Z/hIQPZRdL6TApHDNWcnm36BA7ZO19aqGShUUjL6g
         Q1FmCsUCj7rP6f4vUFNS1G0JuAzOHwepXjfkI4w/8kRgYoPi/GN06pgEBjvujPcD5r
         9JN9PDS74Mbx9jRhLvI4nHqLO+5p/EhpmMuy0/gbyFMrdJSDRcOdWWUf2K6V4RvAlF
         fsZuXj1zYsx7asWrt2JT/6kJ2xCOUMh+ytIMVlRBmtYXmrebb9yKyvKFnEFJme9Pwf
         qIskL7KJuM8vg==
Date:   Fri, 15 Jan 2021 12:08:13 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sami Tolvanen <samitolvanen@google.com>, sfr@canb.auug.org.au
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Kees Cook <keescook@chromium.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: fix the return type of sgx_init
Message-ID: <YAFpjSegNiP+Vge2@kernel.org>
References: <20210113232311.277302-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113232311.277302-1-samitolvanen@google.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 13, 2021 at 03:23:11PM -0800, Sami Tolvanen wrote:
> device_initcall() expects a function of type initcall_t, which returns
> an integer. Change the signature of sgx_init() to match.
> 
> Fixes: e7e0545299d8c ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Thank you.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

I applied this to the master and next of

git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git

Including to the v5.12 PR, actually is the first commit included to that.
That reminds that I should get the next branch mirrored to linux-next.

Stephen, can you start picking the next branch?

/Jarkko
