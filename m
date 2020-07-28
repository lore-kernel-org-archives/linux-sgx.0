Return-Path: <SRS0=dqKk=BH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52E7C433E1
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Jul 2020 21:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A231F20768
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Jul 2020 21:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgG1VfP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 28 Jul 2020 17:35:15 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:53966 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbgG1VfP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 28 Jul 2020 17:35:15 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3053A1C0BD8; Tue, 28 Jul 2020 23:35:12 +0200 (CEST)
Date:   Tue, 28 Jul 2020 23:35:11 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 23/24] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
Message-ID: <20200728213511.GB13081@duo.ucw.cz>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-24-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <20200716135303.276442-24-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> +CPUs starting from Icelake use Total Memory Encryption (TME) in the plac=
e of
> +MEE. TME throws away the Merkle tree, which means losing integrity and
> +anti-replay protection but also enables variable size memory pools for E=
PC.
> +Using this attack for benefit would require an interposer on the system =
bus.

It is not exactly clear what "this attack" means.

(And it would be cool to explain against what SGX is protecting. I
thought it was malicious RAM, but apparently not on Icelake+).

> +Backing storage
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Backing storage is shared and not accounted. It is implemented as a priv=
ate
> +shmem file. Providing a backing storage in some form from user space is =
not
> +possible - accounting would go to invalid state as reclaimed pages would=
 get
> +accounted to the processes of which behalf the kernel happened to be act=
ing on.

"of which behalf" -- I can't parse that?

> +Access control
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +`mmap()` permissions are capped by the enclave permissions. A direct
> +consequence of this is that all the pages for an address range must be a=
dded
> +before `mmap()` can be applied. Effectively an enclave page with minimum
> +permission in the address range sets the permission cap for the mapping
   ~~~~~~~~~~
    permissions?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXyCaDwAKCRAw5/Bqldv6
8qFgAKClxgMbspa7O4ERrC2byjVCOrBDdQCWNBMqIv/eMVREN1fVGtAq39zCSw==
=+N0T
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
