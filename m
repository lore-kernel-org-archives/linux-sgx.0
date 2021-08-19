Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533B0C4338F
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 11:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2227A61130
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 11:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbhHSLdY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Aug 2021 07:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231210AbhHSLdX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Aug 2021 07:33:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F1EF60F11;
        Thu, 19 Aug 2021 11:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629372767;
        bh=qqUv0afXLlZmgpuXp+0i7xIq823VG8q0+CKIHc5YFx0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=X8pTqxxyptHJwxAfARUDxpKpRvfj7JlO9CM3caAQ4738Nk5gdAs6MNutinaEnf1us
         JEj1Ulcgq/lXtuGAl6KZg30vRfot3DVKfhNjizlXFXF62diZKes2ZFzmrjUqqkDZiB
         gvbsF3XtiW7bYNkQbAGN+NKCtkAmI6jl5Wtuz0GHqFuytdmtQfc346a6ror8bUqvhp
         pywcAtRV8h3xw0OJ1GM757bWFfMg4vtYF/ZKXh5RBOKQft/UufbaNPMk0dtqnFm3ig
         Is7J/fhdGuUuDtmj8OjNdlELOudPx+Onyqu8bMPIxSGEjThdS35svcIa+8I8WscRGy
         cXBOdd1bUkhgw==
Message-ID: <565b8fdebe3ff6017bbf46e8928866ee49b44e97.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Add SGX_MemTotal to /proc/meminfo
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Jethro Beekman <jethro@fortanix.com>
Cc:     linux-sgx@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Saravanan D <saravanand@fb.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Date:   Thu, 19 Aug 2021 14:32:45 +0300
In-Reply-To: <ffcef189-78fd-1b57-88bb-577708fb7abc@linuxfoundation.org>
References: <20210818132509.545997-1-jarkko@kernel.org>
         <acd5a925-ce86-9934-5e1c-d0bcee3f606b@fortanix.com>
         <20210818134026.GA7967@iki.fi>
         <ffcef189-78fd-1b57-88bb-577708fb7abc@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2021-08-18 at 12:34 -0600, Shuah Khan wrote:
> On 8/18/21 7:40 AM, Jarkko Sakkinen wrote:
> > On Wed, Aug 18, 2021 at 03:29:59PM +0200, Jethro Beekman wrote:
> > > On 2021-08-18 15:25, Jarkko Sakkinen wrote:
> > > > The amount of SGX memory on the system is determined by the
> > > > BIOS and it
> > > > varies wildly between systems.  It can be from dozens of MB's
> > > > on desktops
> > > > or VM's, up to many GB's on servers.  Just like for regular
> > > > memory, it is
> > > > sometimes useful to know the amount of usable SGX memory in the
> > > > system.
> > > >=20
> > > > Add SGX_MemTotal field to /proc/meminfo, which shows the total
> > > > amount of
> > > > usable SGX memory in the system.  E.g. with 32 MB reserved for
> > > > SGX from
> > > > BIOS, the printout would be:
> > > >=20
> > > > SGX_MemTotal:      22528 kB
> > > >=20
> > > > It is less than 32 MB because some of the space is reserved for
> > > > Enclave
> > > > Page Cache Metadata (EPCM), which contains state variables for
> > > > all the
> > > > pages in the Enclave Page Cache (EPC).  The latter contains the
> > > > pages,
> > > > which applications can use to create enclaves.
> > > >=20
> > > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > > ---
> > > >   Documentation/x86/sgx.rst      |  6 ++++++
> > > >   arch/x86/include/asm/sgx.h     | 10 +++++++---
> > > >   arch/x86/kernel/cpu/sgx/main.c |  7 ++++++-
> > > >   arch/x86/mm/pat/set_memory.c   |  5 +++++
> > > >   4 files changed, 24 insertions(+), 4 deletions(-)
> > > >=20
> > > > diff --git a/Documentation/x86/sgx.rst
> > > > b/Documentation/x86/sgx.rst
> > > > index dd0ac96ff9ef..68ee171e1d8f 100644
> > > > --- a/Documentation/x86/sgx.rst
> > > > +++ b/Documentation/x86/sgx.rst
> > > > @@ -250,3 +250,9 @@ user wants to deploy SGX applications both
> > > > on the host and in guests
> > > >   on the same machine, the user should reserve enough EPC (by
> > > > taking out
> > > >   total virtual EPC size of all SGX VMs from the physical EPC
> > > > size) for
> > > >   host SGX applications so they can run with acceptable
> > > > performance.
> > > > +
> > > > +Supplemental fields for /proc/meminfo
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > +
> > > > +SGX_MemTotal
> > > > +	The total usable SGX protected memory in kilobytes.
> > > > diff --git a/arch/x86/include/asm/sgx.h
> > > > b/arch/x86/include/asm/sgx.h
> > > > index 05f3e21f01a7..2ae9dc8c9411 100644
> > > > --- a/arch/x86/include/asm/sgx.h
> > > > +++ b/arch/x86/include/asm/sgx.h
> > > > @@ -365,6 +365,13 @@ struct sgx_sigstruct {
> > > >    * comment!
> > > >    */
> > > >  =20
> > > > +#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
> > > > +extern unsigned long sgx_nr_all_pages;
> > > > +
> > > > +int sgx_set_attribute(unsigned long *allowed_attributes,
> > > > +		      unsigned int attribute_fd);
> > > > +#endif
> > > > +
> > > >   #ifdef CONFIG_X86_SGX_KVM
> > > >   int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void
> > > > __user *secs,
> > > >   		     int *trapnr);
> > > > @@ -372,7 +379,4 @@ int sgx_virt_einit(void __user *sigstruct,
> > > > void __user *token,
> > > >   		   void __user *secs, u64 *lepubkeyhash, int
> > > > *trapnr);
> > > >   #endif
> > > >  =20
> > > > -int sgx_set_attribute(unsigned long *allowed_attributes,
> > > > -		      unsigned int attribute_fd);
> > > > -
> > >=20
> > > This change seems unrelated?
> >=20
> > It's just a good practice not to define symbols that do not exist,
> > so that
> > if the symbol is ever used, we get a compilation error, not linking
> > error.
> >=20
> > Since this is included to set_memory.c, based on this conclusion, I
> > added
> > the check.
> >=20
>=20
> It would make sense to make this change in a separate patch since.
>=20
> thanks,
> -- Shuah

NP, I can split it.

/Jarkko
