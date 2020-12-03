Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC886C0018C
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Dec 2020 18:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B62CB2085B
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Dec 2020 18:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502086AbgLCSZ3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 3 Dec 2020 13:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502081AbgLCSZ2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 3 Dec 2020 13:25:28 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B956C061A4F;
        Thu,  3 Dec 2020 10:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=U9iOOGWehdlRUZXMOAGYSmpHDwaEN5yGkIu/JuTNHLc=; b=yI9D3Vsc4WFLhHnJITFcP7XA6m
        XEEYwWiZHdl/PR6CV76yIbz1IUCSxU3LXCJeECvZpomwq6CXR9nRdbWXxGFykzFZZtawk30VW+rFN
        K3cC7FX4dvb5esv+Jlbhrtep6QiojsIiOlfFpBchnjhjYm1mhzS/mVOnKOokImwunf49tK59Hb1jz
        Ph0wWAel3G5QvbHd3j2hnjLBKIjmVknDvrSQc5E1unA+Jlz5WZYRBZUBCWvPKekW+aPXUJqiswa8a
        eVJruHrrDY3ZVms2atOGqW2ga41fmbs6Shlv4l3GC2mD6gt6t94ClaXd4VVenkwhUzkRbf7gZdGNA
        tx4WbbPw==;
Received: from 83-245-197-237.elisa-laajakaista.fi ([83.245.197.237] helo=kapsi.fi)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko.sakkinen@iki.fi>)
        id 1kktHk-0007HB-2X; Thu, 03 Dec 2020 20:24:56 +0200
Date:   Thu, 3 Dec 2020 20:24:54 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Initialize "ret" in sgx_ioc_enclave_add_pages()
Message-ID: <20201203182454.GA123023@kapsi.fi>
References: <20201202162200.88941-1-jarkko@kernel.org>
 <20201202173829.GG2951@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202173829.GG2951@zn.tnic>
X-SA-Exim-Connect-IP: 83.245.197.237
X-SA-Exim-Mail-From: jarkko.sakkinen@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 02, 2020 at 06:38:29PM +0100, Borislav Petkov wrote:
> On Wed, Dec 02, 2020 at 06:22:00PM +0200, Jarkko Sakkinen wrote:
> > Initialize "ret" to zero as otherwise a zero length address range will
> > leave it uninitialized.
> 
> That length is:
> 
>  * @length:     length of the data (multiple of the page size)
> 
> I think we wanna fail this even earlier when it wants to add data of
> length 0 because that sounds nonsensical to me. Or is there some use
> case for zero-length data?
> 
> Btw, pls CC lkml on patch submissions.

Yeah, makes sense to fail right after copying the parameter struct
with -EINVAL.

> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

/Jarkko
