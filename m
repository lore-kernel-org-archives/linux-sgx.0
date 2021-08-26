Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC6BC4320E
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 16:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A06E961040
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 16:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242962AbhHZQI5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Aug 2021 12:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231732AbhHZQI5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 26 Aug 2021 12:08:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FC1960EBD;
        Thu, 26 Aug 2021 16:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629994089;
        bh=GewD7zN2+Ps6AHo4qAH+E+QMukH8FsKbZaen88ozxRM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I0z2/zdlUcAhS8LtYd1g+tDrBdZ7FW4OdVMX547zegELwpzPD1UkhGu08W9xrFGbI
         5AmILC8fQP76ndksiIjfNgtE6DujWZj+N9DmOAjCK9s+Zc+WF8+4XhIGYpETnp6Jwu
         CDzo8GmT4SsY37DKccvd6nYdpq2RehTAUuk7uJYobI7wvVhCGf10lpo9Pxldp8TipT
         TC+kXNWIFEj2s9q3fsH3dlIKn2I1RQpNk3jOyCfax+BS1RsAqRzzqnmwe2WLWwBmQL
         EeCTdeAJ7eAmRf+7tecNNv4jOsGi38MyQTyEBbq/uUr/91BA5GkRnTKTBvwiil+31o
         ZNkYf1kfe8IeQ==
Message-ID: <a006c85ef21f4dbd46a2ec1f73fa4e273afc5f6c.camel@kernel.org>
Subject: Re: [PATCH v3 1/2] x86/sgx: Add the missing ifdef for
 sgx_set_attribute()
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org
Date:   Thu, 26 Aug 2021 19:08:07 +0300
In-Reply-To: <YSdl16MFt/GVNGDq@zn.tnic>
References: <20210825235234.153013-1-jarkko@kernel.org>
         <YSdl16MFt/GVNGDq@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-08-26 at 11:58 +0200, Borislav Petkov wrote:
> On Thu, Aug 26, 2021 at 02:52:32AM +0300, Jarkko Sakkinen wrote:
> > Similarly as sgx_virt_*, decorate sgx_set_attribute() with ifdef, so th=
at
> > calling it without appropraite config flags, will cause a compilation
> > error, and not a linking error.
>=20
> Please explain what exactly is this fixing. IOW, how can I reproduce the
> failure?

You're right, fixes tag is not necessary.

I made this change because I'm including the header to set_memory.c, and
IMHO it is better to make sure when possible that we get compilation errors
than linker errors, if for some reason kernel did not have SGX support.

It's also incoherent that KVM specific functions are compilation flagged bu=
t
sgx_set_attribute() is not.

/Jarkko
