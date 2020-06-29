Return-Path: <SRS0=HDiP=AK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753E5C433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jun 2020 19:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37B00206E2
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jun 2020 19:39:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="OBaDehdl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733189AbgF2TjG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387433AbgF2Thn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 29 Jun 2020 15:37:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EB2C03140B;
        Mon, 29 Jun 2020 10:10:29 -0700 (PDT)
Received: from zn.tnic (p200300ec2f092800b9efbf1c1ef2eddc.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:2800:b9ef:bf1c:1ef2:eddc])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4212D1EC01A9;
        Mon, 29 Jun 2020 19:10:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593450628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=j5hXS9nvnbM+fSpieFZ04v4XNRE7FJsxEX2ec96mQh0=;
        b=OBaDehdlg74vqOdiIcPbAbw5Rje/RWi1O7zVjWKP0EDqPqWqYFbl5qQ3gfCD/qW3lbLuO2
        BSt1CvSrup/U1RHK89+BJnA9/J3LyWGRS3fY2Iw8AKeIt20+OAQpr0TTdx1kF342/Nq4a1
        8yMJ4JH+A0CL+GRaITz21ZvbCvHu17Y=
Date:   Mon, 29 Jun 2020 19:10:22 +0200
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
Subject: Re: [PATCH v33 15/21] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20200629171022.GC32176@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-16-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200617220844.57423-16-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 18, 2020 at 01:08:37AM +0300, Jarkko Sakkinen wrote:
...
> intended benefit of massaging GCC's inlining algorithm is unlikely to
> realized in the vDSO any time soon, if ever.

That is a very good explanation and I would prefer if it would be in a
sgx-specific README or so instead of it getting lost in git...

> +bool fixup_vdso_exception(struct pt_regs *regs, int trapnr,
> +			  unsigned long error_code, unsigned long fault_addr)
> +{
> +	const struct vdso_image *image = current->mm->context.vdso_image;
> +	const struct vdso_exception_table_entry *extable;
> +	unsigned int nr_entries, i;
> +	unsigned long base;
> +
> +	/*
> +	 * Do not attempt to fixup #DB or #BP.  It's impossible to identify
> +	 * whether or not a #DB/#BP originated from within an SGX enclave and
> +	 * SGX enclaves are currently the only use case for vDSO fixup.
> +	 */

So this is all fine and dandy but nowhere do I see the code doing:

	if (am_I_an_sgx_enclave(tsk))
		fixup_vdso_exception()

because that vDSO exception fixup, albeit it looking kinda generic, is
SGX-only for now. So it should be designed to run only for SGX enclaves
for now.

Also, is there any particular reason for fixup_vdso_exception() to be in
arch/x86/entry/vdso/extable.c instead of in arch/x86/mm/extable.c?

I mean, it gets called by traps.c so it looks like normal kernel code to
me or am I missing some vdso magic?

And built only when CONFIG_INTEL_SGX is enabled.

And so on...

...

> diff --git a/arch/x86/entry/vdso/extable.h b/arch/x86/entry/vdso/extable.h
> new file mode 100644
> index 000000000000..aafdac396948
> --- /dev/null
> +++ b/arch/x86/entry/vdso/extable.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __VDSO_EXTABLE_H
> +#define __VDSO_EXTABLE_H
> +
> +/*
> + * Inject exception fixup for vDSO code.  Unlike normal exception fixup,
> + * vDSO uses a dedicated handler the addresses are relative to the overall
> + * exception table, not each individual entry.
> + */
> +#ifdef __ASSEMBLY__
> +#define _ASM_VDSO_EXTABLE_HANDLE(from, to)	\
> +	ASM_VDSO_EXTABLE_HANDLE from to
> +
> +.macro ASM_VDSO_EXTABLE_HANDLE from:req to:req
> +	.pushsection __ex_table, "a"
> +	.long (\from) - __ex_table
> +	.long (\to) - __ex_table
> +	.popsection
> +.endm
> +#else
> +#define _ASM_VDSO_EXTABLE_HANDLE(from, to)	\
> +	".pushsection __ex_table, \"a\"\n"      \
> +	".long (" #from ") - __ex_table\n"      \
> +	".long (" #to ") - __ex_table\n"        \
> +	".popsection\n"
> +#endif
> +
> +#endif /* __VDSO_EXTABLE_H */
> +

.git/rebase-apply/patch:122: new blank line at EOF.
+

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
