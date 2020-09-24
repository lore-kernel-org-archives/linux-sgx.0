Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892ADC4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 16:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446792388A
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 16:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="cUUuiUuO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgIXQBB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 12:01:01 -0400
Received: from mail.skyhub.de ([5.9.137.197]:36076 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgIXQBA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 12:01:00 -0400
Received: from zn.tnic (p200300ec2f0c950086c1a307bd73ace8.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:9500:86c1:a307:bd73:ace8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5B47B1EC03D2;
        Thu, 24 Sep 2020 18:00:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600963259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Rzo2+uteZG8Ttlcty7/jTxT0+oan80JDRiAugBxyH0g=;
        b=cUUuiUuOw23CcowVMwZSiYfMBNRQ1s5vMhmFk+ugVJnUZJLJj3IMb2UDimKtyDFM6PLX9l
        gy9KOBz4x3EQM9v8t1+E6QnEMsrlF52eB3oP7lSvx9qD7LdGB8FAu+63oJ2Tp2GOK9RfQ5
        /IVW3uFrUKZZvYyDw9f/RAPIgfLxbQg=
Date:   Thu, 24 Sep 2020 18:00:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 18/24] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20200924160057.GK5030@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-19-jarkko.sakkinen@linux.intel.com>
 <20200923220712.GU28545@zn.tnic>
 <20200924120851.GE56811@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200924120851.GE56811@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 03:09:01PM +0300, Jarkko Sakkinen wrote:
> This is not technically SGX specific patch. Is SGX documentation the
> correct place for this?

So what is it then? It is SGX implementation-specific. Why would you not
put it in the documentation?!

> From checkpatch I only get:

Please concentrate and start reading more carefully:

".git/rebase-apply/patch:122: new blank line at EOF."

Would that error come from checkpatch?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
