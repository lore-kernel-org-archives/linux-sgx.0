Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287C6C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Sep 2021 20:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 043936124F
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Sep 2021 20:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243153AbhIWUbt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 Sep 2021 16:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240613AbhIWUbt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 Sep 2021 16:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C9846124B;
        Thu, 23 Sep 2021 20:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632429016;
        bh=XIucntrX9WIXCoKynKSKFLEe423jN1UzGPo4Sk3EEic=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UbwbDWVnGQgwAUu1ASdyQYYsT4iQEWi3aSKUTRiDFOxTR2ceNmR2183d2FlsKLyuY
         WnEJFBs9cqqx3CaCtuWHr1Rg2xsSZTpfWw7M86ANoMdLRRQV0588Us76Yf0lYtvqa/
         5QrbKuTYVKKl5QqbxDeyDX6KK169XXe/kDiobm6m+pMeYCaYljSM929we8Wmu4Y60z
         SYZFwHpSht2VREE4cPAtbqyp1XJA+udANr/JN2R0aA6lWOc+Vlp6JOnUBnAkXkYsi8
         S0F/c1MWmIYcZQ33/D617h3bnYRKs7WRixMHvGy9ieptayR6qjOBGjoFl0bEgediPk
         ss3UqaCFYR8aQ==
Message-ID: <254864594af4cde213a37a4db527e293a1ef1d7a.camel@kernel.org>
Subject: Re: [PATCH v5 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date:   Thu, 23 Sep 2021 23:30:14 +0300
In-Reply-To: <f45245ba-41b8-62ae-38b5-64725a214bad@intel.com>
References: <20210914030422.377601-1-jarkko@kernel.org>
         <20210914030422.377601-2-jarkko@kernel.org>
         <f45245ba-41b8-62ae-38b5-64725a214bad@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2021-09-22 at 16:30 -0700, Reinette Chatre wrote:
> Hi Jarkko,
>=20
> On 9/13/2021 8:04 PM, Jarkko Sakkinen wrote:
> > The amount of SGX memory on the system is determined by the BIOS and it
> > varies wildly between systems.  It can be from dozens of MB's on deskto=
ps
> > or VM's, up to many GB's on servers.  Just like for regular memory, it =
is
> > sometimes useful to know the amount of usable SGX memory in the system.
> >=20
> > Add an attribute for the amount of SGX memory in bytes to each NUMA
> > node. The path is /sys/devices/system/node/node[0-9]*/sgx/memory_size.
> >=20
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> >=20
> > ---
> > v5: A new patch based on the discussion at
> >      https://lore.kernel.org/linux-sgx/3a7cab4115b4f902f3509ad8652e616b=
91703e1d.camel@kernel.org/T/#t
> > ---
> >   Documentation/x86/sgx.rst      | 14 ++++++
> >   arch/x86/kernel/cpu/sgx/main.c | 90 +++++++++++++++++++++++++++++++++=
+
> >   arch/x86/kernel/cpu/sgx/sgx.h  |  2 +
> >   3 files changed, 106 insertions(+)
> >=20
>=20
> ...
>=20
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/m=
ain.c
> > index a6e313f1a82d..c43b5a0120c1 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -717,6 +717,7 @@ static bool __init sgx_page_cache_init(void)
> >   		}
> >  =20
> >   		sgx_epc_sections[i].node =3D  &sgx_numa_nodes[nid];
> > +		sgx_numa_nodes[nid].size +=3D size;
> >  =20
> >   		sgx_nr_epc_sections++;
> >   	}
>=20
> The above memory seems to be uninitialized at the time it is incremented.
>=20
> I tried this out on a system that reports the following:
>=20
> $ dmesg | grep EPC
> [    7.252838] sgx: EPC section 0x1000c00000-0x107f7fffff
> [    7.256921] sgx: EPC section 0x2000c00000-0x207fffffff
>=20
> It shows unexpectedly large values:
> $ cat /sys/devices/system/node/node*/sgx/memory_size
> 12421486739271732874
> 16308428754864105707
>=20
> System reported sane values after adding this fixup:
>=20
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index 3380390cc052..d73bbfbfc05d 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -621,7 +621,7 @@ static bool __init sgx_page_cache_init(void)
>   	int nid;
>   	int i;
>=20
> -	sgx_numa_nodes =3D kmalloc_array(num_possible_nodes(),=20
> sizeof(*sgx_numa_nodes), GFP_KERNEL);
> +	sgx_numa_nodes =3D kcalloc(num_possible_nodes(),=20
> sizeof(*sgx_numa_nodes), GFP_KERNEL);
>   	if (!sgx_numa_nodes)
>   		return false;
>=20
>=20
> After fixup:
> $ cat /sys/devices/system/node/node*/sgx/memory_size
> 2126512128
> 2134900736

Thanks! I did not experience in a VM.

So cat you pick these patches to your patch set, and squash
this fix to it?


/Jarkko
