Received: from mail-qk1-f196.google.com ([209.85.222.196]:46350 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbeKCW3G (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 3 Nov 2018 18:29:06 -0400
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com> <20181102231320.29164-16-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-16-jarkko.sakkinen@linux.intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 3 Nov 2018 15:17:35 +0200
Message-ID: <CAHp75VdhSwy8zzf64PZnHhZVikJEzasu-=a+UOz4cLAxEJW-YA@mail.gmail.com>
Subject: Re: [PATCH v15 15/23] x86/sgx: Add wrappers for ENCLS leaf functions
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, <suresh.b.siddha@intel.com>, "Linux Kernel Mailing
 List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Sat, Nov 3, 2018 at 1:18 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> ENCLS is an umbrella instruction for a variety of cpl0 SGX functions.
> The ENCLS function that is executed is specified in EAX, with each
> function potentially having more leaf-specific operands beyond EAX.
> ENCLS introduces its own (positive value) error codes that (some)
> leafs use to return failure information in EAX.  Leafs that return
> an error code also modify RFLAGS.  And finally, ENCLS generates
> ENCLS-specific non-fatal #GPs and #PFs, i.e. a bug-free kernel may
> encounter faults on ENCLS that must be handled gracefully.
>
> Because of the complexity involved in encoding ENCLS and handling its
> assortment of failure paths, executing any given leaf is not a simple
> matter of emitting ENCLS.
>
> To enable adding support for ENCLS leafs with minimal fuss, add a
> two-layer macro system along with an encoding scheme to allow wrappers
> to return trap numbers along ENCLS-specific error codes.  The bottom
> layer of the macro system splits between the leafs that return an
> error code and those that do not.  The second layer generates the
> correct input/output annotations based on the number of operands for
> each leaf function.

> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */

> +/**

I dunno if kernel-doc script still complains about this.

> + * Copyright(c) 2016-18 Intel Corporation.
> + */

-- 
With Best Regards,
Andy Shevchenko
