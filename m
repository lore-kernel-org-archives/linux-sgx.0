Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78FD4C433F5
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Jan 2022 12:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiAGMZa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Jan 2022 07:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiAGMZ3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 7 Jan 2022 07:25:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3009C061245
        for <linux-sgx@vger.kernel.org>; Fri,  7 Jan 2022 04:25:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7303EB825E3
        for <linux-sgx@vger.kernel.org>; Fri,  7 Jan 2022 12:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDFFC36AE0;
        Fri,  7 Jan 2022 12:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641558327;
        bh=S6LzLpkV56867B6nbWgR9mCXedYzHipHEAAD/X8JNv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IRvAdG8zYadO+k6OPZiheIwOUXfwPUsCfSP9GTvYqazTQ9avqibMsVhFEw8hX0Zsg
         9s0xGXtGr+hGdBtQnbaFrbrHCawxMljykcTr2Vu6LyrfTIKdvBInU0uDBB0KW7oiLw
         qUpB9T6tcCXreaXEC7f0JK2wdAoAxwZ71DBp4TlQV9mz5KcB/3TTgyUGu41Uvpgte9
         mAA1JP3mTku/algico51vRGO6gvXpyg3DwSkK0fDtbM8NUH8uFJSsReZUZHLcOrJku
         1lkPBRY4oZ2j5ImgM5oplKB6/qFvoFNNYYMgy827b6KFGJni4SWtGHgybV2BVf8/Aw
         rWZQZzW3Ska3w==
Date:   Fri, 7 Jan 2022 14:25:22 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86/sgx: Add accounting for tracking overcommit
Message-ID: <YdgxMvEu6v+fvdRz@iki.fi>
References: <20211220174640.7542-1-kristen@linux.intel.com>
 <20211220174640.7542-2-kristen@linux.intel.com>
 <YcuX/DzVsAWvhEBA@iki.fi>
 <8aa0be2752ed26317ff9b24c9803ccef542ce6ab.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aa0be2752ed26317ff9b24c9803ccef542ce6ab.camel@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 06, 2022 at 10:26:18AM -0800, Kristen Carlson Accardi wrote:
> Hi Jarkko, thanks for your review,
> 
> On Wed, 2021-12-29 at 01:04 +0200, Jarkko Sakkinen wrote:
> > On Mon, Dec 20, 2021 at 09:46:39AM -0800, Kristen Carlson Accardi
> > wrote:
> > > 
> > > +
> > > +/**
> > > + * sgx_charge_mem() - charge for a page used for backing storage
> > > + *
> > 
> > Please remove this empty line:
> > 
> > https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
> 
> I read this to be that there should be an empty line after the short
> description/arg list but before the longer description. I think for
> functions without args this is the proper layout. It also is more
> readable.
> 
> > 
> > > + * Backing storage usage is capped by the
> > > sgx_nr_available_backing_pages.
> > > + * If the backing storage usage is over the overcommit limit,
> > 
> > Where does this verb "charge" come from?
> 
> Charge in this context means that some available backing pages are now
> not available because they are in use. It feels appropriate to me to
> use "charge/uncharge" verbs for this action, unless you think it's
> confusing somehow.

OK, it's cool.

I'm still wondering why you need extra variable given that
sgx_nr_backing_available_pages is signed. You could mark the
feature being disabled by setting it to -1.

It might cosmetically improve readability to have a boolean but
for practical uses (e.g. eBPF tracing scripts) it only adds extra
complexity.

/Jarkko
