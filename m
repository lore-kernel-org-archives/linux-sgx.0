Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93731C433ED
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 09:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58EF061155
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 09:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhDHJcd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 05:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhDHJcd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 8 Apr 2021 05:32:33 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C617C061760;
        Thu,  8 Apr 2021 02:32:20 -0700 (PDT)
Received: from zn.tnic (p200300ec2f095000c11580856fe05acf.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:5000:c115:8085:6fe0:5acf])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 63CF91EC0118;
        Thu,  8 Apr 2021 11:32:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617874339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=O06nRah4ZIJi4In/g3Icyh+CYI/e0j/pdllfHt+zpfI=;
        b=PAOEZW+UT1pScXssN01RW8g9qzJQMB5ipYabAbw7xObIB4MtdkClfTJbK5yqCBkGnlPWI6
        pw4oqulMgyId05wiINv3gg1oB1B7dgfbIpytMGnuXTZ2A3E73zNVy0lciPJu6Fz9oRU7rr
        le059h678t06sYqhT3RytOSWLFAN9vw=
Date:   Thu, 8 Apr 2021 11:32:23 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the
 debugfs
Message-ID: <20210408093223.GG10192@zn.tnic>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210405232653.33680-2-jarkko@kernel.org>
 <20210407155636.GG25319@zn.tnic>
 <YG3ZJyMB+S5LcUso@kernel.org>
 <20210407161533.GJ25319@zn.tnic>
 <YG7EWDXmwC9ai38k@kernel.org>
 <YG7JMc6b+HZIZqxM@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YG7JMc6b+HZIZqxM@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 08, 2021 at 12:13:21PM +0300, Jarkko Sakkinen wrote:
> Actually I think read-only sysctl attributes would be a better idea.

I still think debugfs is the right *start* for this: you play with them,
see what makes sense and what not, tweak them, etc, and then you cast
them in stone.

Not cast them in stone and see if anyone is even interested. So pls keep
them in debugfs for now - you can always do whatever, later, when it
turns out that those are useful.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
