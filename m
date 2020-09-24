Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B793BC4346E
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 15:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50EB92396E
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 15:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="j/EqoXz2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgIXPzD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 11:55:03 -0400
Received: from mail.skyhub.de ([5.9.137.197]:35022 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbgIXPzC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 11:55:02 -0400
Received: from zn.tnic (p200300ec2f0c950086c1a307bd73ace8.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:9500:86c1:a307:bd73:ace8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1EAD81EC03D2;
        Thu, 24 Sep 2020 17:55:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600962901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=J/4r033Gyo3ppyqwY9Pbc9elt+QQJk8ct5cP7ZKcUho=;
        b=j/EqoXz2+IffhVveRKizA8vUZ3LdiGdPZpMaCqlpWuU1mRu4YjukcKsXG87JkoBBxXCz7N
        e5A/OBJs/ho96hyFZmIfML/QsE5kVlyjlSbhoyuKgC/U5mO2rj4W6Fjh2wDnH8lvdcqqP8
        GJH2TbreiYgkDjikll+THr+aOv9wGBw=
Date:   Thu, 24 Sep 2020 17:54:59 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 23/24] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
Message-ID: <20200924155459.GI5030@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-24-jarkko.sakkinen@linux.intel.com>
 <20200923135005.GI28545@zn.tnic>
 <20200924112801.GC56811@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200924112801.GC56811@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 02:28:01PM +0300, Jarkko Sakkinen wrote:
> On Wed, Sep 23, 2020 at 03:50:05PM +0200, Borislav Petkov wrote:
> > > +This leaf function takes an RSA-3072 signature of the enclave measurement and an
> > > +optional cryptographic token. Linux does not take advantage of launch tokens.
> > > +The instruction checks that the signature is signed with the key defined in
> > > +**IA32_SGXLEPUBKEYHASH?** MSRs and the measurement is correct. If so, the
> > 
> > That '?' wants to be '[0123]' perhaps?
> 
> What do you think of this:
> 
> "The leaf instruction checks that the measurement is correct and
> signature is signed with the key hashed to the four
> +**IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}** MSRs representing the SHA256 of a
> public key."

ACK.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
