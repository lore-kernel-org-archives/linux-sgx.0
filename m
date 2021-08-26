Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F781C4320A
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 16:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36AA7610A6
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 16:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243007AbhHZQ16 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Aug 2021 12:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238124AbhHZQ15 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 26 Aug 2021 12:27:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D6C56108F;
        Thu, 26 Aug 2021 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629995230;
        bh=ri5PPlLWRy9zKXS5P/gclhNW627E4mS9121aUBqqlUw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GZQapewu8W1pU0mgJqWFvWbfufl2G/ZL70xxx4z4/HQqJJzK6UiWP8I5tsA/BGzAp
         yAN791sN6d8X3LWGlnN/c95VLhUVmyUgIzZXJPmIGxd30wm1hvf5ees5KDSpbRat16
         kSYkJlis+bOQqm9oQbSr67twrbPna8q1cAJdAAiag5jNW7OFBCFNoXcnSfTkCuA6r/
         JssqfaLn3+WNsG0z3y0t5Mq1ZDk4XTfMEDUzuxVPr3BEy8DsTqcXbPrUagLmoogt7t
         wjWRgoqXwCbzN7A2ljwhURP+7hnLG0wxJCeNnOltkaYzSyGmGZmFpNLu4k/s8cUiHx
         sG3jgDkv1WXYw==
Message-ID: <54923ac01fc303e5105cadca06b7c5cbd322d815.camel@kernel.org>
Subject: Re: [PATCH v3 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date:   Thu, 26 Aug 2021 19:27:07 +0300
In-Reply-To: <20210826141959.5f13ff3c9c560c23b58443b1@intel.com>
References: <20210825235234.153013-1-jarkko@kernel.org>
         <20210825235234.153013-2-jarkko@kernel.org>
         <20210826141959.5f13ff3c9c560c23b58443b1@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-08-26 at 14:19 +1200, Kai Huang wrote:
> On Thu, 26 Aug 2021 02:52:33 +0300 Jarkko Sakkinen wrote:
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
> >  Documentation/x86/sgx.rst      | 6 ++++++
> >  arch/x86/include/asm/sgx.h     | 2 ++
> >  arch/x86/kernel/cpu/sgx/main.c | 7 ++++++-
> >  arch/x86/mm/pat/set_memory.c   | 5 +++++
> >  4 files changed, 19 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> > index dd0ac96ff9ef..68ee171e1d8f 100644
> > --- a/Documentation/x86/sgx.rst
> > +++ b/Documentation/x86/sgx.rst
> > @@ -250,3 +250,9 @@ user wants to deploy SGX applications both on the h=
ost and in guests
> >  on the same machine, the user should reserve enough EPC (by taking out
> >  total virtual EPC size of all SGX VMs from the physical EPC size) for
> >  host SGX applications so they can run with acceptable performance.
> > +
> > +Supplemental fields for /proc/meminfo
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +SGX_MemTotal
> > +	The total usable SGX protected memory in kilobytes.
> > diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> > index 996e56590a10..d8e526b5487b 100644
> > --- a/arch/x86/include/asm/sgx.h
> > +++ b/arch/x86/include/asm/sgx.h
> > @@ -367,6 +367,8 @@ struct sgx_sigstruct {
> > =20
> >  #ifdef CONFIG_X86_SGX
> > =20
> > +extern unsigned long sgx_nr_all_pages;
> > +
> >  int sgx_set_attribute(unsigned long *allowed_attributes,
> >  		      unsigned int attribute_fd);
> > =20
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/m=
ain.c
> > index 63d3de02bbcc..1fe26a8e80dc 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -28,7 +28,10 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
> >  static LIST_HEAD(sgx_active_page_list);
> >  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
> > =20
> > -/* The free page list lock protected variables prepend the lock. */
> > +/* The number of usable EPC pages in the system. */
> > +unsigned long sgx_nr_all_pages;
> > +
> > +/* The number of free EPC pages in all nodes. */
> >  static unsigned long sgx_nr_free_pages;
> > =20
> >  /* Nodes with one or more EPC sections. */
> > @@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_section(u64 phys_a=
ddr, u64 size,
> >  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
> >  	}
> > =20
> > +	sgx_nr_all_pages +=3D nr_pages;
> > +
>=20
> EPC sections can be freed again in sgx_init() after they are successfully
> initialized, when any further initialization fails (i.e. when fails to cr=
eate
> ksgxd, or fails to register /dev/sgx_provision).  In which case, I think
> sgx_nr_all_pages should also be cleared.  But current sgx_init() seems do=
esn't
> reset it.  Do you need to fix that too?

sgx_nr_all_pages tells just the total pages in the system, i.e. it's a cons=
tant.

Maybe a rename to "sgx_nr_total_pages" would be a good idea? Would match wi=
th
the meminfo field better too.

>=20
> >  	return true;
> >  }
> > =20
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.=
c
> > index ad8a5c586a35..82bb09c298de 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -29,6 +29,7 @@
> >  #include <asm/proto.h>
> >  #include <asm/memtype.h>
> >  #include <asm/set_memory.h>
> > +#include <asm/sgx.h>
>=20
> How about only include <asm/sgx.h> when CONFIG_X86_SGX is on, then you do=
n't
> have to do #ifdef CONFIG_X86_SGX changes to sgx.h?

Why do it that way instead of doing it once in sgx.h for every site that wa=
nts
to include the file?

/Jarkko

