Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D994C433DB
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Mar 2021 08:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BFAA61A1A
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Mar 2021 08:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCYInJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Mar 2021 04:43:09 -0400
Received: from mail.skyhub.de ([5.9.137.197]:51432 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhCYImn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Mar 2021 04:42:43 -0400
Received: from zn.tnic (p200300ec2f0d5d00784c9f440731cfd1.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:5d00:784c:9f44:731:cfd1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 030AB1EC03D2;
        Thu, 25 Mar 2021 09:42:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616661762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=5ZA3QbgvQdCV0S/1PKyxIMsyoHrm2ajnvhq1m8bUFS4=;
        b=gUAsMvF+oHBbUDQCUolS8KhswjoZQQopp+MOsFfLpaw3pIEIUxd0Mw2xCskJlCLkiCMTeY
        vW6oLKsIxk2AGr3bdZLrqXwdVbqV7vKTg0/ZVws8qk7U4iQaolX1r2Agwt9KLwuG/OnY+8
        FpafXLjYbKxr37MOnhefcV403D4mpFk=
Date:   Thu, 25 Mar 2021 09:42:41 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <20210325084241.GA31322@zn.tnic>
References: <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com>
 <20210323160604.GB4729@zn.tnic>
 <YFoVmxIFjGpqM6Bk@google.com>
 <20210323163258.GC4729@zn.tnic>
 <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
 <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
 <20210325122343.008120ef70c1a1b16b5657ca@intel.com>
 <8e833f7c-ea24-1044-4c69-780a84b47ce1@redhat.com>
 <20210325124611.a9dce500b0bcbb1836580719@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210325124611.a9dce500b0bcbb1836580719@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

... so you could send the final version of this patch as a reply to this
thread, now that everyone agrees, so that I can continue going through
the rest.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
