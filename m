Received: from mga06.intel.com ([134.134.136.31]:34820 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726906AbeIJX2j (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Mon, 10
 Sep 2018 19:28:39 -0400
Date: Mon, 10 Sep 2018 21:33:01 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>, "maintainer:X86 ARCHITECTURE
 (32-BIT AND 64-BIT)" <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>, "Siddha, Suresh B"
	<suresh.b.siddha@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Darren Hart
	<dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, "Linux
 Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 11/13] platform/x86: Intel SGX driver
Message-ID: <20180910183301.GA20225@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-12-jarkko.sakkinen@linux.intel.com>
 <CAHp75VcqKunkHYNdd287_F7APHwYr7K9QD2PVCkqBqJWG2_E-g@mail.gmail.com>
 <20180905173355.GE11368@linux.intel.com>
 <CAHp75Vc2SZUfRnBPZ9xJ_B=KJL7yK9hqRZiFOTswn0AzjnLD1A@mail.gmail.com>
 <20180906092100.GA27302@linux.intel.com>
 <CANiq72kpY1y2aPH+GMi8mWZdttfdYJ3wk0cvE_qVD97vdvTJbQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CANiq72kpY1y2aPH+GMi8mWZdttfdYJ3wk0cvE_qVD97vdvTJbQ@mail.gmail.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Thu, Sep 06, 2018 at 07:35:46PM +0200, Miguel Ojeda wrote:
> Hi Jarkko,
> 
> On Thu, Sep 6, 2018 at 11:21 AM, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > There is another open. If I grep through the kernel tree I see SPDX
> > headers that are decorated both with C99- and C89-style comments. I
> > guess I ended up using C99-style because when I was instructed to add
> > SPDX headers in the first place that was the example I was given. Still
> > checkpatch.pl complains about C99-style comments.
> >
> > Which one is right and why the kernel tree is polluted with C99-headers
> > when they do not pass checkpatch.pl? How those commits were ever
> > accepted?
> 
> See Documentation/process/license-rules.rst. Headers should go with
> C-style comments:
> 
>    The SPDX license identifier is added in form of a comment.  The comment
>    style depends on the file type::
> 
>       C source: // SPDX-License-Identifier: <SPDX License Expression>
>       C header: /* SPDX-License-Identifier: <SPDX License Expression> */
> 
> And:
> 
>    If a specific tool cannot handle the standard comment style, then the
>    appropriate comment mechanism which the tool accepts shall be used. This
>    is the reason for having the "/\* \*/" style comment in C header
>    files. There was build breakage observed with generated .lds files where
>    'ld' failed to parse the C++ comment. This has been fixed by now, but
>    there are still older assembler tools which cannot handle C++ style
>    comments.
> 
> The ones that got in are probably either old or they slipped through
> (and they do not break the build).

Thank you, this clears things up. Highly appreciated!

> Cheers,
> Miguel

/Jarkko
