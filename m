Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1639C432BE
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 09:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DACF0610D0
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 09:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241205AbhHZJ7H (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Aug 2021 05:59:07 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53386 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241259AbhHZJ7D (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 26 Aug 2021 05:59:03 -0400
Received: from zn.tnic (p200300ec2f131000e9f5f92baa539bd3.dip0.t-ipconnect.de [IPv6:2003:ec:2f13:1000:e9f5:f92b:aa53:9bd3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3D7831EC051E;
        Thu, 26 Aug 2021 11:58:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1629971890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xbX4r5EqKg8cDu/+GUe232oyiQQBaN6NPDk7h7Xak1I=;
        b=ZzhTJ3285L0EUEd//gUs94F3JlGT+V9rsO6E4QWn1zqJoECtIWit4UwiRq8By4Lh+CnD38
        3boipgm2CR19Q5HJ/3ZiYISkPqqRoMHLy4LkHSnNEkLwASRqQFrKyljttbBYBEiOjEQuKV
        IkzM4Z9707X4jaNoGhF8ZtNCrc2bh70=
Date:   Thu, 26 Aug 2021 11:58:47 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] x86/sgx: Add the missing ifdef for
 sgx_set_attribute()
Message-ID: <YSdl16MFt/GVNGDq@zn.tnic>
References: <20210825235234.153013-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210825235234.153013-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 26, 2021 at 02:52:32AM +0300, Jarkko Sakkinen wrote:
> Similarly as sgx_virt_*, decorate sgx_set_attribute() with ifdef, so that
> calling it without appropraite config flags, will cause a compilation
> error, and not a linking error.

Please explain what exactly is this fixing. IOW, how can I reproduce the
failure?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
