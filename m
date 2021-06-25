Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD135C2B9F4
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Jun 2021 13:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2E4E6191B
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Jun 2021 13:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhFYNu2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Jun 2021 09:50:28 -0400
Received: from mail.skyhub.de ([5.9.137.197]:43538 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhFYNu1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Jun 2021 09:50:27 -0400
Received: from zn.tnic (p200300ec2f0dae0049fb297996de39ad.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:ae00:49fb:2979:96de:39ad])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0C3831EC0595;
        Fri, 25 Jun 2021 15:48:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1624628886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iY+4utBdvbx+ojYEWBGu3aTvmIrU2MDnkCirQ/h45y0=;
        b=sJIIfGoaIlKF0q5NM0/Y3eu3t9dBe/4iKRyybKWdVdhn1NcOOcJvL6ACdxBFvGLVmGXxxe
        R1gmkNL3w8sC/r5mmiYb43/2nZqOpW5Ygkv7YB7QqkddB+oRJww/MVmD9YUqQ8CQjtpuW8
        /WDDSBk+MqSKzLKBCHt5Uwn651aItPg=
Date:   Fri, 25 Jun 2021 15:47:59 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
        dave.hansen@intel.com, tglx@linutronix.de, mingo@redhat.com,
        Yang Zhong <yang.zhong@intel.com>
Subject: Re: [PATCH v2] x86/sgx: Add missing xa_destroy() when virtual EPC is
 destroyed
Message-ID: <YNXej3ru9kxQugvR@zn.tnic>
References: <20210616003634.320206-1-kai.huang@intel.com>
 <20210623132844.heleuoxogrpz3cpm@kernel.org>
 <925090f035b8e749ea7aca8c857690c8afba7349.camel@intel.com>
 <YNWR+oSGfulOWziI@zn.tnic>
 <6df0600b755ca067a6c4ff82af47297feafa088a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6df0600b755ca067a6c4ff82af47297feafa088a.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Jun 26, 2021 at 12:04:53AM +1200, Kai Huang wrote:
> Oh sorry I thought the patch would go via x86/sgx branch

We usually send fixes through tip's urgent branches because they go
straight to Linus and not wait for the merge window.

> and I didn't monitor the tip-bot2 mail which was moved to my local x86
> folder.

That's not optimal because those tip-bot notifications are *exactly* for
that - to let the involved parties know that the patch has been queued.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
