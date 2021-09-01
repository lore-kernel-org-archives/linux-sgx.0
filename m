Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858DAC432BE
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Sep 2021 02:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61C7C61059
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Sep 2021 02:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241721AbhIACDo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Aug 2021 22:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231249AbhIACDo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 31 Aug 2021 22:03:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF6876102A;
        Wed,  1 Sep 2021 02:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630461768;
        bh=itf0YPIBFQSTV5XdA/fydfXnNEXgRwQUfxUzkZjmh3c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xmb3jiGQ373MJCK1YeQ6gIPfz/fSmEUFJh0eS/syA8MTggweyK1RDpNvRmRtCxczr
         k1Bsmb45KegENAbbNygdtE4i8jlO/7XcQmd8D1NFsiBojWrvwuEV5rjvum+XRUEK2s
         0/c4nzZYhAkhKkK87WZKbGCH5kabEqXdYwem677RYuNPWjOo53URzi+aW3WCnFNEHG
         +uSO5fketS+OFfhCezT4lqs15zbmmXuKAnWliQbCA48UHG/FxxEVxMMf70mWsgQV9V
         x9i60KYRj/x9cRxh0v1JqdmxDlAUQAjdq5KJRLltSFWKWImqyVjWqMICQn7xv+aNZR
         VwrpcZEasW26A==
Message-ID: <04b90a702328712204430db604b2a92ddfe8f990.camel@kernel.org>
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
Date:   Wed, 01 Sep 2021 05:02:45 +0300
In-Reply-To: <20210828000335.1d40dfff0f408b2d91467491@intel.com>
References: <20210825235234.153013-1-jarkko@kernel.org>
         <20210825235234.153013-2-jarkko@kernel.org>
         <20210826141959.5f13ff3c9c560c23b58443b1@intel.com>
         <54923ac01fc303e5105cadca06b7c5cbd322d815.camel@kernel.org>
         <20210828000335.1d40dfff0f408b2d91467491@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, 2021-08-28 at 00:03 +1200, Kai Huang wrote:
> > > > -/* The free page list lock protected variables prepend the lock. *=
/
> > > > +/* The number of usable EPC pages in the system. */
> > > > +unsigned long sgx_nr_all_pages;
> > > > +
> > > > +/* The number of free EPC pages in all nodes. */
> > > >  static unsigned long sgx_nr_free_pages;
> > > > =20
> > > >  /* Nodes with one or more EPC sections. */
> > > > @@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_section(u64 ph=
ys_addr, u64 size,
> > > >  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
> > > >  	}
> > > > =20
> > > > +	sgx_nr_all_pages +=3D nr_pages;
> > > > +
> > >=20
> > > EPC sections can be freed again in sgx_init() after they are successf=
ully
> > > initialized, when any further initialization fails (i.e. when fails t=
o create
> > > ksgxd, or fails to register /dev/sgx_provision).  In which case, I th=
ink
> > > sgx_nr_all_pages should also be cleared.  But current sgx_init() seem=
s doesn't
> > > reset it.  Do you need to fix that too?
> >=20
> > sgx_nr_all_pages tells just the total pages in the system, i.e. it's a =
constant.
> >=20
> > Maybe a rename to "sgx_nr_total_pages" would be a good idea? Would matc=
h with
> > the meminfo field better too.
>=20
> I don't have preference on name.  I just think if there's no actual user =
of
> EPC (when both driver and KVM SGX cannot be enabled), it's pointless to p=
rint
> number of EPC pages.

I'd presume that you refer to the code, which prints the number of *bytes* =
in
the system because code printing the number of pages does not exist in this
patch set.

I have troubles the decipher your statement.

You think that only if both the driver and KVM are *both* enabled, only the=
n
it makes sense to have this information available for sysadmin?

I don't get this logic, if I understood what you mean in the first place.

/Jarkko

