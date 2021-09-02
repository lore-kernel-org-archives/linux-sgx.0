Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB43C433F5
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Sep 2021 22:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B196610CF
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Sep 2021 22:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhIBWPF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhIBWPF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Sep 2021 18:15:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B607160FA0;
        Thu,  2 Sep 2021 22:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630620846;
        bh=8yv/aTWXZ1bFs2b2YTiMap+cbrcYIgcA/mWm+A2evrA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=T9FtD/CFDgBXFIXE3kP+Kgyk4oQLmT4wuuBXZLzziPYa4gvtOBOqU6b91IouZNX4V
         SA/lTA0nmtoI8YL7HSIcwgWxnQVI+SpgQcMu7bO4XXktI98xiGcJVX2B89+pwr/Pdo
         AgOA3O6LltUM3Jw1qyK4e3eBYbj/S1qWPjSGPDqFj8tuX1q7UIgqgCRuwojzfVfeuK
         LZQ+Pc5cbYLk1pHjE8ySifvt73B7d9ipZXpNl3po/ScTRkeWLxpc8Xs8NMo2zyxQhi
         udlYoM2zE/U+FsKFiVNvj9jAwRakOrgNBYw9wc+jNhemPnq2o6qK7HJQlHntMTLf4c
         a8UWuy51EZ55g==
Message-ID: <752079ce7233280d2ca67d725a4d552d9e4bcdc6.camel@kernel.org>
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
Date:   Fri, 03 Sep 2021 01:14:03 +0300
In-Reply-To: <20210903095616.9806a6dd4938c021aa204b33@intel.com>
References: <20210825235234.153013-1-jarkko@kernel.org>
         <20210825235234.153013-2-jarkko@kernel.org>
         <20210826141959.5f13ff3c9c560c23b58443b1@intel.com>
         <54923ac01fc303e5105cadca06b7c5cbd322d815.camel@kernel.org>
         <20210828000335.1d40dfff0f408b2d91467491@intel.com>
         <04b90a702328712204430db604b2a92ddfe8f990.camel@kernel.org>
         <20210901173322.78f94b694b4be6b1225bee98@intel.com>
         <6a9fccdb6a458960e43a63afcce87cc62184adf9.camel@kernel.org>
         <20210901174705.3b1a943ef8c4bb09323c6d76@intel.com>
         <41e9b099f6492c389b3ed3bbe107d61804a307e9.camel@kernel.org>
         <20210903095616.9806a6dd4938c021aa204b33@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2021-09-03 at 09:56 +1200, Kai Huang wrote:
> On Thu, 02 Sep 2021 15:15:51 +0300 Jarkko Sakkinen wrote:
> > On Wed, 2021-09-01 at 17:47 +1200, Kai Huang wrote:
> > > On Wed, 01 Sep 2021 08:41:12 +0300 Jarkko Sakkinen wrote:
> > > > On Wed, 2021-09-01 at 17:33 +1200, Kai Huang wrote:
> > > > > On Wed, 01 Sep 2021 05:02:45 +0300 Jarkko Sakkinen wrote:
> > > > > > On Sat, 2021-08-28 at 00:03 +1200, Kai Huang wrote:
> > > > > > > > > > -/* The free page list lock protected variables prepend=
 the lock. */
> > > > > > > > > > +/* The number of usable EPC pages in the system. */
> > > > > > > > > > +unsigned long sgx_nr_all_pages;
> > > > > > > > > > +
> > > > > > > > > > +/* The number of free EPC pages in all nodes. */
> > > > > > > > > >  static unsigned long sgx_nr_free_pages;
> > > > > > > > > > =20
> > > > > > > > > >  /* Nodes with one or more EPC sections. */
> > > > > > > > > > @@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_se=
ction(u64 phys_addr, u64 size,
> > > > > > > > > >  		list_add_tail(&section->pages[i].list, &sgx_dirty_pa=
ge_list);
> > > > > > > > > >  	}
> > > > > > > > > > =20
> > > > > > > > > > +	sgx_nr_all_pages +=3D nr_pages;
> > > > > > > > > > +
> > > > > > > > >=20
> > > > > > > > > EPC sections can be freed again in sgx_init() after they =
are successfully
> > > > > > > > > initialized, when any further initialization fails (i.e. =
when fails to create
> > > > > > > > > ksgxd, or fails to register /dev/sgx_provision).  In whic=
h case, I think
> > > > > > > > > sgx_nr_all_pages should also be cleared.  But current sgx=
_init() seems doesn't
> > > > > > > > > reset it.  Do you need to fix that too?
> > > > > > > >=20
> > > > > > > > sgx_nr_all_pages tells just the total pages in the system, =
i.e. it's a constant.
> > > > > > > >=20
> > > > > > > > Maybe a rename to "sgx_nr_total_pages" would be a good idea=
? Would match with
> > > > > > > > the meminfo field better too.
> > > > > > >=20
> > > > > > > I don't have preference on name.  I just think if there's no =
actual user of
> > > > > > > EPC (when both driver and KVM SGX cannot be enabled), it's po=
intless to print
> > > > > > > number of EPC pages.
> > > > > >=20
> > > > > > I'd presume that you refer to the code, which prints the number=
 of *bytes* in
> > > > > > the system because code printing the number of pages does not e=
xist in this
> > > > > > patch set.
> > > > > >=20
> > > > > > I have troubles the decipher your statement.
> > > > > >=20
> > > > > > You think that only if both the driver and KVM are *both* enabl=
ed, only then
> > > > > > it makes sense to have this information available for sysadmin?
> > > > >=20
> > > > > Only if at least one of them is enabled.
> > > >=20
> > > > OK, thank you, that does make sense.
> > > >=20
> > > > What would happen if neither is enabled is that SGX_MemTotal would
> > > > state that there is zero bytes of EPC.=20
> > >=20
> > > This is the problem I pointed out at the beginning, that (if I read c=
ode
> > > correctly), it seems your current patch doesn't clear sgx_nr_all_page=
s when
> > > neither is enabled (in sgx_init() in sgx/main.c).
> >=20
> > It's initialized to zero, so are you talking about fallback when someth=
ing
> > fails?
> >=20
> > /Jarkko
>=20
> Yes, shouldn't you have something similar to below?
>=20
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index 63d3de02bbcc..270f6103b6c0 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -836,6 +836,7 @@ static int __init sgx_init(void)
>                 vfree(sgx_epc_sections[i].pages);
>                 memunmap(sgx_epc_sections[i].virt_addr);
>         }
> +       sgx_nr_all_pages =3D 0;
> =20
>         return ret;
>  }

Yeah, something along the lines. Thanks, this was really good
remark. The fallback path is clearly broken.

/Jarkko

