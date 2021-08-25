Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF1BC432BE
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Aug 2021 20:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9260F610D1
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Aug 2021 20:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbhHYUfw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Aug 2021 16:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239539AbhHYUfv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Aug 2021 16:35:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2D48610CE;
        Wed, 25 Aug 2021 20:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629923705;
        bh=pKxV3Y1gj1zvl4VJobY0n84pnugy7uATtX3Mw6lQk/0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mo9moASupIP6Ot2g1MAmqf+8nG1VNt11U7C9nGTzDfW8klvtVOcKk5U5dK+KURiTF
         3rKWo8jK2oK2IdtBFmQEVEAZfqDkQX2P5fiY2q5OxbQH5nbOF94ydwL8+tO66AT4zE
         4SQel/ZHclyNL4Z7mwc2psTvfj00k2V2wNlIVBIqTeYwZdYxe83oJg6utcweCDLOTM
         nKA6QLUt418rPP6X+A0d6ws8M93aRhV+CTLfFvVPZAKMtwmFBAFsjHD3u/Y0D4aaSP
         WGgb322jONUuPNJgoKAirnPiZ08pfMLQpbBGTSjSk/jtK4DpkcjCnLj+vPiqVnhckK
         0+s+PVMm4CWlw==
Message-ID: <5fcd083a31f876fdc97c7438f41e2c2fcc41c35f.camel@kernel.org>
Subject: Re: [PATCH v2 1/2] x86/sgx: Add the missing ifdef for
 sgx_set_attribute()
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-sgx@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Date:   Wed, 25 Aug 2021 23:35:02 +0300
In-Reply-To: <YR6Bs2twT4EK/jUK@google.com>
References: <20210819124824.52169-1-jarkko@kernel.org>
         <YR6Bs2twT4EK/jUK@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-08-19 at 16:07 +0000, Sean Christopherson wrote:
> On Thu, Aug 19, 2021, Jarkko Sakkinen wrote:
> > Similarly as sgx_virt_*, decorate sgx_set_attribute() with ifdef, so th=
at
> > calling it without appropraite config flags, will cause a compilation
> > error, and not a linking error.
> >=20
> > Fixes: b3754e5d3da3 ("x86/sgx: Move provisioning device creation out of=
 SGX driver")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  arch/x86/include/asm/sgx.h | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> > index 05f3e21f01a7..38c397ef35a8 100644
> > --- a/arch/x86/include/asm/sgx.h
> > +++ b/arch/x86/include/asm/sgx.h
> > @@ -365,6 +365,11 @@ struct sgx_sigstruct {
> >   * comment!
> >   */
> > =20
> > +#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
>=20
> X86_SGX_KVM depends on X86_SGX
>=20
> And rather than shuffle code, you can wrap all of the prototypes, which h=
as the
> added bonus of "documenting" the aformentioned dependency, e.g.
>=20
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 05f3e21f01a7..d5f3e617cc38 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -365,6 +365,7 @@ struct sgx_sigstruct {
>   * comment!
>   */
>=20
> +#ifdef CONFIG_X86_SGX
>  #ifdef CONFIG_X86_SGX_KVM
>  int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
>                      int *trapnr);
> @@ -374,5 +375,6 @@ int sgx_virt_einit(void __user *sigstruct, void __use=
r *token,
>=20
>  int sgx_set_attribute(unsigned long *allowed_attributes,
>                       unsigned int attribute_fd);
> +#endif /* CONFIG_X86_SGX */
>=20
>  #endif /* _ASM_X86_SGX_H */

Right, makes sense.

A bit off from this patch set, but I'm wondering if there would be any bene=
fit to
have a compile time flag for just the allocator part, since KVM depends onl=
y that.

I.e. you could compile a kernel with just KVM required bits for SGX.

/Jarkko

