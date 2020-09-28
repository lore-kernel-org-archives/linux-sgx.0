Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23922C2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 08:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E4732076D
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 08:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="EH6+hSM6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgI1Iag (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 04:30:36 -0400
Received: from mail.skyhub.de ([5.9.137.197]:52466 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgI1Iag (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 04:30:36 -0400
Received: from zn.tnic (p200300ec2f072200afd3fa405d8d6d26.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:2200:afd3:fa40:5d8d:6d26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9B6B01EC00F4;
        Mon, 28 Sep 2020 10:30:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1601281834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=uLC0XytYkYBfgCQafARNCH0W8cLI9VHZHzj2cBk/nxU=;
        b=EH6+hSM6KX1xs0QVpsygklaSgP2dkBFX0Z2Ezx0UoVYH1uviN5YxEZ102Jq9Wa0opOsn3d
        k38oN/xuo0RpO4q2w4+dCwvGg00ZbVROiq8tHm8u4QOodi5cg85R8C86AewGWpODCXuyLv
        wWITmnjPNvqGVuyBjIxJCZ9E3cljGZE=
Date:   Mon, 28 Sep 2020 10:30:32 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200928083032.GB1685@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <20200924180407.GO5030@zn.tnic>
 <20200925010031.GH119995@linux.intel.com>
 <20200925082807.GG16872@zn.tnic>
 <20200927233700.GA4450@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200927233700.GA4450@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 02:37:00AM +0300, Jarkko Sakkinen wrote:
> I did not get Sean's reply, and neither can find it from lore:
> 
> https://lore.kernel.org/linux-sgx/20200915112842.897265-1-jarkko.sakkinen@linux.intel.com/T/#t

Yah, your mail server upgrade broke a lot of stuff. And lore even says
it is not there:

2020-09-25 11:43           ` Jethro Beekman
     [not found]     ` <20200925003808.GB20333@linux.intel.com>		<---
2020-09-25  1:04       ` Jarkko Sakkinen

Lemme bounce it to you.

> I'd make that a description and take away individual parameter
> descriptions. Is that fine?

Sure.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
