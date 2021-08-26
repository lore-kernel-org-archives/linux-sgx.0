Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F73C432BE
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 17:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 329D16101C
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 17:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243178AbhHZRYW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Aug 2021 13:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243210AbhHZRYL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 26 Aug 2021 13:24:11 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61742C0613CF;
        Thu, 26 Aug 2021 10:23:24 -0700 (PDT)
Received: from zn.tnic (p200300ec2f131000d5458c5ba0c26ca5.dip0.t-ipconnect.de [IPv6:2003:ec:2f13:1000:d545:8c5b:a0c2:6ca5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EF6671EC0559;
        Thu, 26 Aug 2021 19:23:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1629998599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Mo9jTobg7YRdgvO0YOsX8cFgOpo+GxgVHpEM/g5L7DM=;
        b=kOFXCRvZkaWulu4ysy/mNXLkFyshNc/chh6PPTNQxkwlatJWUmDN7rhhfU70jwRvkUjI/f
        HySEowVTAYYFRL6D7tFwbRQG9ciaB9hP9AOJ2EWkkGjQ5+jScIah7i65nVyahjg8LDZNRj
        d6nHCNbFq+9OtyaTev8RQGUrNAP86mU=
Date:   Thu, 26 Aug 2021 19:24:00 +0200
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
Message-ID: <YSfOMBzWwWuefke/@zn.tnic>
References: <20210825235234.153013-1-jarkko@kernel.org>
 <YSdl16MFt/GVNGDq@zn.tnic>
 <a006c85ef21f4dbd46a2ec1f73fa4e273afc5f6c.camel@kernel.org>
 <YSfC2vhMxaUY2j/H@zn.tnic>
 <5a44ada347713097eb0308e0f2f2b16cb55a635f.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5a44ada347713097eb0308e0f2f2b16cb55a635f.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 26, 2021 at 08:11:27PM +0300, Jarkko Sakkinen wrote:
> Is your preference is to have in set_memory.c:

My preference is to take fixes only for actual problems which can be
triggered with some config - not something you're doing locally.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
