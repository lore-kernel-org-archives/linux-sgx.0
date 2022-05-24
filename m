Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58336C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 24 May 2022 19:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiEXT0O (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 May 2022 15:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbiEXT0M (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 24 May 2022 15:26:12 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6325232ECC
        for <linux-sgx@vger.kernel.org>; Tue, 24 May 2022 12:26:10 -0700 (PDT)
Received: from zn.tnic (p200300ea974657c6329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9746:57c6:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D2BF11EC018C;
        Tue, 24 May 2022 21:26:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1653420364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fOyM/btV07Wr7orvUBqWgPMV6DjfBogMs6ola+xRYK4=;
        b=rL2GHuv5HvgzB71L+gLLV+yVwjHthVS37a6G2axkQxO3Fi7BvsZA4iDH1871CCGI8TKirS
        4QjNeZIA116+gkzpswsguH5n3s7WQGVTq9A0Ld88KnH5CjV1cASsU7S8v5cRKJjtTTB1wM
        aoIo0f3pd/QKIL00ENfoxgIcoModh9k=
Date:   Tue, 24 May 2022 21:26:00 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com,
        chao.p.peng@linux.intel.com, yang.zhong@intel.com
Subject: Re: [PATCH v5 0/9] Support microcode updates affecting SGX
Message-ID: <Yo0xSNt0JKGgOG59@zn.tnic>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
 <87r14izqrv.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87r14izqrv.ffs@tglx>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 24, 2022 at 09:15:00PM +0200, Thomas Gleixner wrote:
> Cathy,
> 
> On Fri, May 20 2022 at 18:38, Cathy Zhang wrote:

Btw, this mail has this here too:

> Historically, microcode updates are applied by the BIOS or early in
> boot. In recent years, several trends have made these old approaches
> less palatable.

Actually, late loading is the old method. Early came after it.

> > First, the cadence of microcode updates has increased to deliver
> > security mitigations. Second, the value of those updates has increased,
> > meaning that any delay in applying them is unacceptable. Third, users
> > have become accustomed to approaches like hot patching their kernels
> > and have a growing aversion to reboots in general.

I had missed that argument: so how do those users update their kernels?
Livepatching? I don't think you can replace a whole live kernel - that
would be magic. Unless you kexec but then you can early load microcode
too.

So if you reboot your kernel because you've installed a new one, you can
just as well update microcode.

So sorry but I'm not buying this argument.

For cloud vendors who cannot reboot because they've promised their users
ponies, that's their problem. They might have a somewhat ok-ish argument.

But not for normal users - they can just as well reboot their machines
and do kernel updates together with microcode.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
