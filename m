Return-Path: <SRS0=niAy=DQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EF4C43467
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Oct 2020 08:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4825122245
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Oct 2020 08:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732555AbgJIIVu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Oct 2020 04:21:50 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55756 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732337AbgJIIVu (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 9 Oct 2020 04:21:50 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A9C211C0B88; Fri,  9 Oct 2020 10:21:48 +0200 (CEST)
Date:   Fri, 9 Oct 2020 10:21:47 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201009082146.GA15188@amd>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003143925.GB800720@kroah.com>
 <20201009071045.GA10335@amd>
 <20201009072141.GA12545@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20201009072141.GA12545@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-10-09 09:21:41, Greg KH wrote:
> On Fri, Oct 09, 2020 at 09:10:45AM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > > new file mode 100644
> > > > index 000000000000..f54da5f19c2b
> > > > --- /dev/null
> > > > +++ b/arch/x86/kernel/cpu/sgx/driver.c
> > > > @@ -0,0 +1,173 @@
> > > > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> > >=20
> > > You use gpl-only header files in this file, so how in the world can it
> > > be bsd-3 licensed?
> > >=20
> > > Please get your legal department to agree with this, after you explain
> > > to them how you are mixing gpl2-only code in with this file.
> >=20
> > This specifies license of driver.c, not of the headers included. Are
> > you saying that it is impossible to have a kernel driver with anything
> > else than GPL-2? That would be news to many, and that's not what
> > current consensus is.
>=20
> If you want to write any non-GPL-2-only kernel code, you had better be
> consulting your lawyers and get very explicit instructions on how to do
> this in a way that does not violate any licenses.
>=20
> I am not a lawyer, and will not be giving you any such advice, as I
> think it's not something that people should be doing.

You are pushing view that is well outside accepted community
consensus, then try to hide it by claiming that you are not a lawyer.

Stop it.

Dual licensed drivers are common in the kernel, and are considered
okay by everyone but you. Author is free to select license for his
work.

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+AHZoACgkQMOfwapXb+vKOjACgl9a8pvMx5bpSZjOeW06bWO7I
Z6oAniRaZ5xNHGC/MQ/hB3c/rW5oYhGI
=jELf
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
