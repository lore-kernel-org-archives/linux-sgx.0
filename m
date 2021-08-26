Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78609C432BE
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 16:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A91B6109E
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 16:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243021AbhHZQSa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Aug 2021 12:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232555AbhHZQSa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 26 Aug 2021 12:18:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67A1460ED3;
        Thu, 26 Aug 2021 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629994662;
        bh=pWmHQBlYwsNWsIX3eOuUwj8YH2EBIx3MDU5DMLTc/Sg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A+Nbd6UkhDDLQq9N19VoXjqk8Fxh+SbxWk0gOGNFKdaJC1k12n9xRHQg1RCAW/sjA
         4lK1ZHFx8RQgedJcKJAtYP/PsAoNKpADCPBhnd7PpM3td76Zdn8UJfO61E/YIygZO6
         FVyMn6zWh/6N8WCIcP0fXvUQVPJx/2MD2Eo/2yBn43iFXJEgklI8zYYPFnNUKYzpbu
         QEjEp0lSIyJmpgabZ3qzLb6bpUpJVmgfcZCujnMnzMnO8sSGStuu/TKYP1XToSyF1F
         0QiqtvJEFLrZheBnfef6qReLdxRVqPEJavyNxyeeXv+WgqJ3Z07y3gvRGpnJ48tVFS
         X3QYddHkjBGMg==
Message-ID: <e1ff36db0e7ed909653b6adb45094cc459dbad0b.camel@kernel.org>
Subject: Re: [PATCH v3 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date:   Thu, 26 Aug 2021 19:17:40 +0300
In-Reply-To: <ba483b7e-19a3-d4d3-56c0-3371a77341cb@infradead.org>
References: <20210825235234.153013-1-jarkko@kernel.org>
         <20210825235234.153013-2-jarkko@kernel.org>
         <ba483b7e-19a3-d4d3-56c0-3371a77341cb@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2021-08-25 at 17:39 -0700, Randy Dunlap wrote:
> On 8/25/21 4:52 PM, Jarkko Sakkinen wrote:
> > The amount of SGX memory on the system is determined by the BIOS and it
> > varies wildly between systems.  It can be from dozens of MB's on deskto=
ps
> > or VM's, up to many GB's on servers.  Just like for regular memory, it =
is
> > sometimes useful to know the amount of usable SGX memory in the system.
> >=20
> > Add SGX_MemTotal field to /proc/meminfo, which shows the total amount o=
f
> > usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from
> > BIOS, the printout would be:
> >=20
> > SGX_MemTotal:      22528 kB
> >=20
> > It is less than 32 MB because some of the space is reserved for Enclave
> > Page Cache Metadata (EPCM), which contains state variables for all the
> > pages in the Enclave Page Cache (EPC).  The latter contains the pages,
> > which applications can use to create enclaves.
> >=20
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> >=20
> > ---
> > v2:
> > * Move ifdef fix for sgx_set_attribute() to a separate patch.
> > ---
> >   Documentation/x86/sgx.rst      | 6 ++++++
> >   arch/x86/include/asm/sgx.h     | 2 ++
> >   arch/x86/kernel/cpu/sgx/main.c | 7 ++++++-
> >   arch/x86/mm/pat/set_memory.c   | 5 +++++
> >   4 files changed, 19 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> > index dd0ac96ff9ef..68ee171e1d8f 100644
> > --- a/Documentation/x86/sgx.rst
> > +++ b/Documentation/x86/sgx.rst
> > @@ -250,3 +250,9 @@ user wants to deploy SGX applications both on the h=
ost and in guests
> >   on the same machine, the user should reserve enough EPC (by taking ou=
t
> >   total virtual EPC size of all SGX VMs from the physical EPC size) for
> >   host SGX applications so they can run with acceptable performance.
> > +
> > +Supplemental fields for /proc/meminfo
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +SGX_MemTotal
> > +	The total usable SGX protected memory in kilobytes.
>=20
> Hi,
>=20
> I would prefer to see this listed in Documentation/filesystems/proc.rst
> as an optional field, depending on CONFIG_X86_SGX.
> Or at least put a reference in proc.rst to this doc file and its
> supplemental fields.
>=20
> thanks.

I *can* put it there but I did have reason not to, i.e. these attributes
are neither there:

DirectMap4k:     3930904 kB
DirectMap2M:    29440000 kB
DirectMap1G:     1048576 kB

And they are implemented in arch specific code.

Actually they are undocumented, e.g.

$ git grep DirectMap4k
arch/powerpc/mm/book3s64/pgtable.c:     seq_printf(m, "DirectMap4k:    %8lu=
 kB\n",
arch/s390/mm/pageattr.c:        seq_printf(m, "DirectMap4k:    %8lu kB\n",
arch/x86/mm/pat/set_memory.c:   seq_printf(m, "DirectMap4k:    %8lu kB\n",

/Jarkko
