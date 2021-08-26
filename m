Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EC2C432BE
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 17:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A6360F14
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 17:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhHZRyP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Aug 2021 13:54:15 -0400
Received: from mail.skyhub.de ([5.9.137.197]:40578 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231801AbhHZRyO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 26 Aug 2021 13:54:14 -0400
Received: from zn.tnic (p200300ec2f131000d5458c5ba0c26ca5.dip0.t-ipconnect.de [IPv6:2003:ec:2f13:1000:d545:8c5b:a0c2:6ca5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 401D21EC01FC;
        Thu, 26 Aug 2021 19:53:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1630000402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=pe5lUCCxwWzzJLMcs55RNyaX6auO63yfSXsiiFFa7sg=;
        b=BHcynWcW/F254O84tgxdcCcbmk2NvW79gxdqQ/5nSO2XDh4YK2fbyPQlataezeJGjqB3jD
        FspWtWt60COid4OqovuA1YxAgkUr8ww4hC8gAurPTNi2YPLKn6934Os3Tz6XTAtbvH5fVL
        eBeTggtnhzYOlhY/UdDQy+yE6esfWNA=
Date:   Thu, 26 Aug 2021 19:53:59 +0200
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
Message-ID: <YSfVN16aZbe1TXO0@zn.tnic>
References: <20210825235234.153013-1-jarkko@kernel.org>
 <YSdl16MFt/GVNGDq@zn.tnic>
 <a006c85ef21f4dbd46a2ec1f73fa4e273afc5f6c.camel@kernel.org>
 <YSfC2vhMxaUY2j/H@zn.tnic>
 <5a44ada347713097eb0308e0f2f2b16cb55a635f.camel@kernel.org>
 <YSfOMBzWwWuefke/@zn.tnic>
 <3980adde9c05963790215e99d566740059da6870.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3980adde9c05963790215e99d566740059da6870.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 26, 2021 at 08:31:13PM +0300, Jarkko Sakkinen wrote:
> The actual problem is to use it in set_memory.c.

So I asked you in the first mail:

"Please explain what exactly is this fixing."

> This the unsplit version:
> 
> https://lore.kernel.org/linux-sgx/20210818132509.545997-1-jarkko@kernel.org/

But you're still feeding me some pieces of the puzzle piecemeal.

> Should I just squash them again into one patch?

You should explain *why* you're fixing whatever you're fixing and your
commit message should explain exactly how the bug is triggered so that
the reader of that commit message can reproduce it on their end.

Otherwise it'll get ignored until you do it right.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
