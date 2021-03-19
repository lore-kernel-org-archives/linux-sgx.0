Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5832BC433DB
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 15:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F85D61883
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 15:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhCSO7b (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Mar 2021 10:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbhCSO7b (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 19 Mar 2021 10:59:31 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CFDC06174A;
        Fri, 19 Mar 2021 07:59:31 -0700 (PDT)
Received: from zn.tnic (p200300ec2f091e0035ab8ae551405c9b.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:1e00:35ab:8ae5:5140:5c9b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2342A1EC027A;
        Fri, 19 Mar 2021 15:59:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616165968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xDfmZontdcXI2rx+Td4htHoNtz/t5xTpmRVJBIIMsHg=;
        b=Ma5is/I+4bJeGbuzEqFO6gViaiB8cbRlxmS73VpXp6fyZ0rAjYZDbaCbSeRJgLVW0/jhoZ
        ZS7cx/j73uuwbqWlnpJRrUwxZ2ToY0hxmKYGXQgy75Lv/AHGwwBeGTJDzJE+mwaHS46Wx8
        tu7Tnv6p5K4nXZZbz3OyqLfc4XSP184=
Date:   Fri, 19 Mar 2021 15:59:31 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Avoid returning NULL in __sgx_alloc_epc_page()
Message-ID: <20210319145931.GH6251@zn.tnic>
References: <20210319040602.178558-1-kai.huang@intel.com>
 <20210319084523.GA6251@zn.tnic>
 <20210319220141.8bf20c54fdb06c6f93cde448@intel.com>
 <YFS6Of4nnDJR+ZFk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFS6Of4nnDJR+ZFk@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 19, 2021 at 04:50:33PM +0200, Jarkko Sakkinen wrote:
> > > I was on the verge whether to merge that into the original patch since
> > > it is the top patch on the branch or create a new one but opted for
> > > former because this way it won't break bisection and people won't have
> > > to pay attention whether there's a fix patch to the NUMA patch too, in
> > > case they wanna backport and whatnot.

...

> I understood Boris' comment that the fixes would not be squashed.

Please read it again and let me know what about it is not clear. It is
at the beginning of this mail.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
