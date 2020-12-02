Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FB3C64E7C
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 17:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB9A7208FE
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 17:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgLBRjQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgLBRjP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 2 Dec 2020 12:39:15 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03937C0613D4;
        Wed,  2 Dec 2020 09:38:35 -0800 (PST)
Received: from zn.tnic (p200300ec2f161b00329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f16:1b00:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 92A581EC0445;
        Wed,  2 Dec 2020 18:38:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1606930713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=TOj/CbJQozLlgEpZDfi9IAgrGve3UT6kEWc9dUDAvrs=;
        b=pVYkiLvCjPRAyGBJicax/qGhEzgb0oC6n55ApDLBwvajD/q9T7jPZIM7lxFXhtnLPSA7l5
        UoL3KY/i11gK4jBdjEHR79lr3Kac8qpPkdmvOPyVInmwfyLgb0EPezIW/oZsrX8bXYIA6v
        jltxwnp51mCmufWXj1Eb7mQJJWVwTus=
Date:   Wed, 2 Dec 2020 18:38:29 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Initialize "ret" in sgx_ioc_enclave_add_pages()
Message-ID: <20201202173829.GG2951@zn.tnic>
References: <20201202162200.88941-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201202162200.88941-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 02, 2020 at 06:22:00PM +0200, Jarkko Sakkinen wrote:
> Initialize "ret" to zero as otherwise a zero length address range will
> leave it uninitialized.

That length is:

 * @length:     length of the data (multiple of the page size)

I think we wanna fail this even earlier when it wants to add data of
length 0 because that sounds nonsensical to me. Or is there some use
case for zero-length data?

Btw, pls CC lkml on patch submissions.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
