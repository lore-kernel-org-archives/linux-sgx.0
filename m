Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66D3C433B4
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 16:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81ABD61260
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 16:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344881AbhDGQPk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Apr 2021 12:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhDGQPk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 7 Apr 2021 12:15:40 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA041C061756;
        Wed,  7 Apr 2021 09:15:30 -0700 (PDT)
Received: from zn.tnic (p200300ec2f08fb00aad493ab6ea3c721.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:fb00:aad4:93ab:6ea3:c721])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2B33E1EC0246;
        Wed,  7 Apr 2021 18:15:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617812129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=F9OuUN762B+9d4jmnherzF+wKWI42AD+cSEq+YQttyQ=;
        b=A6wMC0+jv+/LO+6T2qggvFCBNhuX20IUJ7kqMDqEWN33tLbhLAGIxSXvJWeLCNpvGt8FN7
        RX/iq8/bPpFHVxHf2L8+04DJLBfpoBCm6UG9NTg39ZN3vXWVIc19wVjL0dMTK1N5nksmHg
        aUuy7DbZa8nhOvh+yA+ax0MvQvbkX/w=
Date:   Wed, 7 Apr 2021 18:15:33 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the
 debugfs
Message-ID: <20210407161533.GJ25319@zn.tnic>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210405232653.33680-2-jarkko@kernel.org>
 <20210407155636.GG25319@zn.tnic>
 <YG3ZJyMB+S5LcUso@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YG3ZJyMB+S5LcUso@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 07, 2021 at 07:09:11PM +0300, Jarkko Sakkinen wrote:
> I left out "epc" because they are already prefixed with "sgx_".

Are there any other "page" types which are going to be figurating in
some pseudofs or is "sgx" == "epc" in this case?

> debugfs was my first shot, but for sure these could be sysfs.

Ok, let's keep it in debugfs for now, it can always be made an ABI later
and moved to sysfs. But pls document what those are and what they do and
that when in debugfs, there are no guarantees that these interfaces will
be there in the future.

> Should that be part of the first patch?

Yes pls.

Thx.


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
