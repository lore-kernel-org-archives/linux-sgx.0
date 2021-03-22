Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CF4C433DB
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Mar 2021 10:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0117619A3
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Mar 2021 10:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhCVKch (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:32:37 -0400
Received: from mail.skyhub.de ([5.9.137.197]:33994 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230173AbhCVKbo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Mar 2021 06:31:44 -0400
Received: from zn.tnic (p200300ec2f06670063ce2fe2d87b4e47.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:6700:63ce:2fe2:d87b:4e47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D6BE41EC04D1;
        Mon, 22 Mar 2021 11:31:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616409098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=A7X6xqWwvrumHxCzhE/jGhlXXWmEGnnV8W9n3h7zfrM=;
        b=fj4dFah2LjRf9lhNjzR/HlbwH48kifin9iJOUdTZmYEdAiilXgsbAeb5WHR8m96PB7Sn0L
        lHKxRt3adznDjYY6mQ7MGn3t68KdPDS8Ezj8B8o5waytw+6P6DI6iv8YzvEp1MOijTLE6e
        Hu/AHI4jQw9pBhZf2S2ejjsBZpxCJ+A=
Date:   Mon, 22 Mar 2021 11:31:37 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de, jmattson@google.com, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, corbet@lwn.net
Subject: Re: [PATCH v3 00/25] KVM SGX virtualization support
Message-ID: <20210322103137.GB6481@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <YFS6kTe1SuAjiMFN@kernel.org>
 <d876e5abb1a7e4fce160bfcb217bf3ab675f44a8.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d876e5abb1a7e4fce160bfcb217bf3ab675f44a8.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 22, 2021 at 11:03:28PM +1300, Kai Huang wrote:
> If there's no other comments, should I send another version

No need.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
