Return-Path: <SRS0=HDiP=AK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6371FC433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jun 2020 19:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41C5320842
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jun 2020 19:43:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="q3Vmk0Fh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387885AbgF2Tm7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387992AbgF2Tmo (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 29 Jun 2020 15:42:44 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7F3C0307B6;
        Mon, 29 Jun 2020 09:02:51 -0700 (PDT)
Received: from zn.tnic (p200300ec2f09280085fdc63970f65a73.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:2800:85fd:c639:70f6:5a73])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 61A8E1EC01A9;
        Mon, 29 Jun 2020 18:02:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593446569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=2L1vbdXs6967q5MXhDQz9AYQuCk2nlJpbVP3fi23e9k=;
        b=q3Vmk0FhoNVFWMh5+mBQDvLiLh3GQaDdq9zlzmE986sR91a5GEjRxfhBB4Wg7VoZL+7KWA
        mNTp8vkKYfVQ1qTyePc6HJ6DoocVKr65s6JZBEfA0Xh4/t5mh34IFJsCgyEJsQ7h1KN0PW
        sh1YVBu/JYjlt5uU9fhchMqyy8ICZmw=
Date:   Mon, 29 Jun 2020 18:02:42 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v33 12/21] x86/sgx: Allow a limited use of
 ATTRIBUTE.PROVISIONKEY for attestation
Message-ID: <20200629160242.GB32176@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-13-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200617220844.57423-13-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 18, 2020 at 01:08:34AM +0300, Jarkko Sakkinen wrote:
> Provisioning Certification Enclave (PCE), the root of trust for other
> enclaves, generates a signing key from a fused key called Provisioning
> Certification Key. PCE can then use this key to certify an attestation key
> of a QE, e.g. we get the chain of trust down to the hardware if the Intel

What's a QE?

I don't see this acronym resolved anywhere in the whole patchset.

> signed PCE is used.
> 
> To use the needed keys, ATTRIBUTE.PROVISIONKEY is required but should be
> only allowed for those who actually need it so that only the trusted
> parties can certify QE's.
> 
> Obviously the attestation service should know the public key of the used
> PCE and that way detect illegit attestation, but whitelisting the legit
> users still adds an additional layer of defence.
> 
> Add new device file called /dev/sgx/provision. The sole purpose of this
> file is to provide file descriptors that act as privilege tokens to allow
> to build enclaves with ATTRIBUTE.PROVISIONKEY set. A new ioctl called
> SGX_IOC_ENCLAVE_SET_ATTRIBUTE is used to assign this token to an enclave.

So I'm sure I'm missing something here: what controls which
enclave can open /dev/sgx/provision and thus pass the FD to
SGX_IOC_ENCLAVE_SET_ATTRIBUTE?

And in general, how does that whole flow look like: what calls
SGX_IOC_ENCLAVE_SET_ATTRIBUTE when?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
