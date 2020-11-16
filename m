Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828A2C4742C
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Nov 2020 17:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F2C12225E
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Nov 2020 17:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="PkFwH0ln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732854AbgKPR2r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:28:47 -0500
Received: from mail.skyhub.de ([5.9.137.197]:54862 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731210AbgKPR2q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Nov 2020 12:28:46 -0500
Received: from zn.tnic (p200300ec2f07680050d12d82a515c0a8.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:6800:50d1:2d82:a515:c0a8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7114B1EC0283;
        Mon, 16 Nov 2020 18:28:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1605547725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=SWXUYProWhX6YdAPy+gjb5MB4wAngARvJHgm98j1JaY=;
        b=PkFwH0lnz6yuVIISgmpYr2HzVs/Ckf3DukWRJIA5lHIhio3enZyzM8ndY/LgLGmzHhJ6Dp
        /Mzoa+O5sxDapovkuxzgVNpVnD5SbXs9bx3ZVgecneelO/tfwmxaiOCItAVCIFLtXk/CyR
        jVSzu+jK/VNh4n1rYOCrz4K+QPw12M8=
Date:   Mon, 16 Nov 2020 18:28:40 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v41 00/24] Intel SGX foundations
Message-ID: <20201116172840.GD1131@zn.tnic>
References: <20201112220135.165028-1-jarkko@kernel.org>
 <20201116165544.GC1131@zn.tnic>
 <eb8100e8-1439-4dd3-ba7b-68e8919ab5b7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eb8100e8-1439-4dd3-ba7b-68e8919ab5b7@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 16, 2020 at 09:21:16AM -0800, Dave Hansen wrote:
> That works when there is something universal across the set, like if
> Sean Signed-off-by on each patch and we didn't have any other SoB's.
> Sean is also mentioned in at least one of five different tags:

So?

You git-format-patch, build the CC-list and supply it with --cc-cmd or
whatever scripting you have and do --suppress-cc=all as the last switch.

> The bounces aren't the end of the world, they're just annoying.

And I have to go edit every patch by hand to remove those comments
again. No, bounces happen all the time and we ignore them simply. Can't
fix them all.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
