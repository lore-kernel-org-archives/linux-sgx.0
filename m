Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7336C433E0
	for <linux-sgx@archiver.kernel.org>; Fri,  8 Jan 2021 08:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9810323447
	for <linux-sgx@archiver.kernel.org>; Fri,  8 Jan 2021 08:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbhAHIOB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 8 Jan 2021 03:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbhAHIOB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 8 Jan 2021 03:14:01 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D914AC0612F4;
        Fri,  8 Jan 2021 00:13:19 -0800 (PST)
Received: from zn.tnic (p200300ec2f0a3100d005afb8b8ef6dfd.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:3100:d005:afb8:b8ef:6dfd])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 131F01EC0423;
        Fri,  8 Jan 2021 09:13:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610093597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3MGxjmDQiegHjp974jsS8YIgdrpV3uPYV+6Tq9+wzZQ=;
        b=kFwA7zeMemymCm5rT8NUFEeb8dwhUV894/LiHn1rL+6DNXArSytJwzjrF426RiLzo6DACH
        W3V/yuqb9vv1aIt5HGPQQuWzZcYg24wbzgwFneMfCGRQZC/QRb1OxQUw6DmrCSZewPp7mU
        1Fb5PA9Yws22lPEdU4cdtsrGaKVHIis=
Date:   Fri, 8 Jan 2021 09:13:14 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        jarkko@kernel.org, luto@kernel.org, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210108081314.GC4042@zn.tnic>
References: <cover.1609890536.git.kai.huang@intel.com>
 <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
 <20210106221527.GB24607@zn.tnic>
 <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
 <20210107064125.GB14697@zn.tnic>
 <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
 <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
 <20210108210647.40ecb8233f0387578cb0d45a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210108210647.40ecb8233f0387578cb0d45a@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jan 08, 2021 at 09:06:47PM +1300, Kai Huang wrote:
> No offence, but using synthetic bits is a little bit hack to me,given
> they are actually hardware feature bits.

Why?

Perhaps you need to have a look at Documentation/x86/cpuinfo.rst first.

> And using synthetic leaf in reverse lookup is against current KVM
> code.

You know how the kernel gets improved each day and old limitations are
not valid anymore?

> I'll try my own  way in next version, but thank you for the insight! :)

Feel free but remember to keep it simple. You can use mine too, if you
want to, as long as you attribute it with a Suggested-by or so.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
