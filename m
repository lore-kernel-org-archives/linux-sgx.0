Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDBEC4320E
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Sep 2021 05:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 437BC6102A
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Sep 2021 05:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhIAFmM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 1 Sep 2021 01:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231195AbhIAFmK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 1 Sep 2021 01:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F36AF60F92;
        Wed,  1 Sep 2021 05:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630474874;
        bh=4gWXBhemBdFlwxDdizi6NHE619J+0CTJJuMfC4VTIMw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n4GfuipCLEKYaznqhsS+cNFZB/dq1ET+YDVLkPJjJrIhFDZthY6Wi3sZebGe7y/WE
         8OrXR+UDw6pzsGNsPpJYXflmELjOrc/GxePKdmPaU5OrlAZrJXkFMW2tLscciAVPP4
         W1+3Zxy1rDAJfD4HP15QvGMC/+W72aiNPC5JNh+Hut9zOvPxbldHDa2shEztVH0n4/
         9uzqkZryrLR5948DiDCWCFORp9+WR9EeOIe3ty9sdyJDxqGniZCDcvqyZhd+N4kYoK
         8vr4EGnIQTPXcmGhqUR4Kx9EAkBhQg8MTzDdFcmWACR2mGnj72EHpPtk3nd/unUvHv
         4aoT8gbufyb4A==
Message-ID: <6a9fccdb6a458960e43a63afcce87cc62184adf9.camel@kernel.org>
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
Date:   Wed, 01 Sep 2021 08:41:12 +0300
In-Reply-To: <20210901173322.78f94b694b4be6b1225bee98@intel.com>
References: <20210825235234.153013-1-jarkko@kernel.org>
         <20210825235234.153013-2-jarkko@kernel.org>
         <20210826141959.5f13ff3c9c560c23b58443b1@intel.com>
         <54923ac01fc303e5105cadca06b7c5cbd322d815.camel@kernel.org>
         <20210828000335.1d40dfff0f408b2d91467491@intel.com>
         <04b90a702328712204430db604b2a92ddfe8f990.camel@kernel.org>
         <20210901173322.78f94b694b4be6b1225bee98@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2021-09-01 at 17:33 +1200, Kai Huang wrote:
> On Wed, 01 Sep 2021 05:02:45 +0300 Jarkko Sakkinen wrote:
> > On Sat, 2021-08-28 at 00:03 +1200, Kai Huang wrote:
> > > > > > -/* The free page list lock protected variables prepend the loc=
k. */
> > > > > > +/* The number of usable EPC pages in the system. */
> > > > > > +unsigned long sgx_nr_all_pages;
> > > > > > +
> > > > > > +/* The number of free EPC pages in all nodes. */
> > > > > >  static unsigned long sgx_nr_free_pages;
> > > > > > =20
> > > > > >  /* Nodes with one or more EPC sections. */
> > > > > > @@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_section(u6=
4 phys_addr, u64 size,
> > > > > >  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list)=
;
> > > > > >  	}
> > > > > > =20
> > > > > > +	sgx_nr_all_pages +=3D nr_pages;
> > > > > > +
> > > > >=20
> > > > > EPC sections can be freed again in sgx_init() after they are succ=
essfully
> > > > > initialized, when any further initialization fails (i.e. when fai=
ls to create
> > > > > ksgxd, or fails to register /dev/sgx_provision).  In which case, =
I think
> > > > > sgx_nr_all_pages should also be cleared.  But current sgx_init() =
seems doesn't
> > > > > reset it.  Do you need to fix that too?
> > > >=20
> > > > sgx_nr_all_pages tells just the total pages in the system, i.e. it'=
s a constant.
> > > >=20
> > > > Maybe a rename to "sgx_nr_total_pages" would be a good idea? Would =
match with
> > > > the meminfo field better too.
> > >=20
> > > I don't have preference on name.  I just think if there's no actual u=
ser of
> > > EPC (when both driver and KVM SGX cannot be enabled), it's pointless =
to print
> > > number of EPC pages.
> >=20
> > I'd presume that you refer to the code, which prints the number of *byt=
es* in
> > the system because code printing the number of pages does not exist in =
this
> > patch set.
> >=20
> > I have troubles the decipher your statement.
> >=20
> > You think that only if both the driver and KVM are *both* enabled, only=
 then
> > it makes sense to have this information available for sysadmin?
>=20
> Only if at least one of them is enabled.

OK, thank you, that does make sense.

What would happen if neither is enabled is that SGX_MemTotal would
state that there is zero bytes of EPC. I'll add a note to the commit
message. It's useful because it give is easy programmatic way to check
if SGX is enabled in Linux or not.

/Jarkko
