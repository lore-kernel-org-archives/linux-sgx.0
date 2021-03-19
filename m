Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D778C433DB
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 15:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F374C6195E
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 15:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhCSPxN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhCSPwv (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 19 Mar 2021 11:52:51 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87805C06174A;
        Fri, 19 Mar 2021 08:52:51 -0700 (PDT)
Received: from zn.tnic (p200300ec2f091e0083683e716a2b863f.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:1e00:8368:3e71:6a2b:863f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1307D1EC05B8;
        Fri, 19 Mar 2021 16:52:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616169170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=juRg9xU8839Azxv9DV6H8rSQ2lQMOUOh+EHWiWmR7AA=;
        b=OH9W9F/p/92PP+z6bxT6Gd0PJ8POb3RXVxZjleExLePgAwua/X2PHOPw3MbvcHHzi8RFLh
        pUhgtLNS0CbFmDBwvSdcl6Ihntoy37EnXIFoa+BM2EkmYQkJdOzsCCSjpIM3udLk5cEgZZ
        GeIJGzTYSMhMXx+qTlrC4Q5VLg9cxbs=
Date:   Fri, 19 Mar 2021 16:52:49 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Avoid returning NULL in __sgx_alloc_epc_page()
Message-ID: <20210319155249.GK6251@zn.tnic>
References: <20210319040602.178558-1-kai.huang@intel.com>
 <20210319084523.GA6251@zn.tnic>
 <20210319220141.8bf20c54fdb06c6f93cde448@intel.com>
 <YFS6Of4nnDJR+ZFk@kernel.org>
 <20210319145931.GH6251@zn.tnic>
 <YFTB0HD/4Hc0KvT3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFTB0HD/4Hc0KvT3@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 19, 2021 at 05:22:56PM +0200, Jarkko Sakkinen wrote:
> I did misread it for the first time.
> 
> So let's sanity: you *are* going to squash the patches together because
> that way it's factors easier to backport the whole thing?
> 
> Is this the correct understanding?

I squashed Kai's fix because I don't want to break people's bisection if
they land between your patch and his fix. They're already troubled enough
chasing an issue, don't want to have them get a NULL ptr in sgx land.

Now, looking at dhansen's fix: what can happen if nid is uninitialized?
AFAICT, we'll end up in

static inline int __next_node(int n, const nodemask_t *srcp)
{
        return min_t(int,MAX_NUMNODES,find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
}

with n uninitialized and depending on its value it'll either return
MAX_NUMNODES so we'll try to allocate on the first node or try to
allocate on some other node.

Now, if you think that that is still problematic enough for enclave
creation, then I'll fold his patch too.

So yes, the main reason is usability and not breaking bisection.

So, what would you prefer?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
