Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526C0C4361B
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 22:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2270D23D22
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Dec 2020 22:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388618AbgLIW1w (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Dec 2020 17:27:52 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:47612 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388813AbgLIW0g (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Dec 2020 17:26:36 -0500
X-Greylist: delayed 1580 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2020 17:26:34 EST
Received: from [2a02:1811:d05:2600:ba82:33db:3e5e:d545] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1kn7UK-0004k8-6R; Wed, 09 Dec 2020 22:59:08 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1kn7UF-000kZ5-Uf; Wed, 09 Dec 2020 22:59:03 +0100
Message-ID: <fd81b46065cd33397e38a17096a206760b7b2937.camel@decadent.org.uk>
Subject: Re: Creating executable device nodes in /dev?
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Andy Lutomirski <luto@amacapital.net>,
        Topi Miettinen <toiwoton@gmail.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Zbigniew =?UTF-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
        linux-hotplug@vger.kernel.org,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>
Date:   Wed, 09 Dec 2020 22:58:59 +0100
In-Reply-To: <308AE66A-F401-4D2D-9D53-17E11EAF68E3@amacapital.net>
References: <f2279f2d-f0a6-a948-9691-96f47a0bd997@gmail.com>
         <308AE66A-F401-4D2D-9D53-17E11EAF68E3@amacapital.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-HfnQe6Xx6rBFLwlXKhP7"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:1811:d05:2600:ba82:33db:3e5e:d545
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


--=-HfnQe6Xx6rBFLwlXKhP7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-12-09 at 07:14 -0800, Andy Lutomirski wrote:
> On Dec 9, 2020, at 12:58 AM, Topi Miettinen <toiwoton@gmail.com> wrote:
[...]
> > I think we agree that there's a need for either way to allow SGX
> > (if default is hardened) or a hardening option (in the opposite
> > case). For systemd I see two approaches:
> >=20
> > 1. Default noexec /dev, override with something like
> > - ExecPaths=3D/dev
> > - MountOptions=3D/dev:rw,exec,dev,nosuid
> > - or even MountOptions=3D/dev/sgx:rw,exec,dev,nosuid
> > - ProtectDev=3Dno
> > - AllowSGX=3Dyes
> >=20
> > 2. Default exec /dev, override with
> > - NoExecPaths=3D/dev
> > - MountOptions=3D/dev:rw,noexec,dev,nosuid
> > - ProtectDev=3Dyes
> > - DenySGX=3Dyes
> >=20
> > I'd prefer 1. but of course 2. would be reasonable.
>=20
> I would argue for 2, for the following reason.=C2=A0 I absolutely agree
> that hardening a system by making it impossible to create executable
> code dynamically is valuable, but I don=E2=80=99t think it=E2=80=99s a go=
od default.
> By default, programs like gcc and clang should work, but so should
> JITs, and JITs are getting more popular and powerful all the time.=C2=A0
> In a default setting that allows JITs, etc, I see no benefit at all
> to making /dev noexec. To the contrary, making /dev noexec seems like
> plugging a little restricted corner of code creation (because it
> requires UID=3D0) while allowing the easy ways (/tmp, /home, /dev/shm,
> unshare(2), mmap(), etc).=C2=A0 By all means let admins harden this, but =
I
> see no reason to apply some of the hardening when the rest is
> disabled.
[...]

I'm convinced.  I've committed a change to initramfs-tools that removes
the noexec mount option again.

Ben.

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education.
                                                      - Albert Einstein

--=-HfnQe6Xx6rBFLwlXKhP7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl/RSKMACgkQ57/I7JWG
EQnIXhAAwMUewts9rz++6N19HKsBEbAv2kN8kN/dmVvSi6A/d1oddTNZ/Mcn44jT
LBMdqTEr6igbZ+HtAQ/QwxQ8jMCiO6Acz2hRZbpdd/R2N8dsRbkuXc+OOQhsWW5O
p62AI9N6dhXCvEWRyCrFI4zTvS784bH9OYoIwP5EvEQqa/oYUSLXH2g4BJNE9AEq
TAYSql/v6jcD+TysYP4YC/mlnrb5S/rf/4Xtn/DBZE5nQguhsK6Vv0yR7i89Duq5
wuLi5IH4IeCF8Y/YXVi7IPV5RDOaSQx2MJxPjyQb0T5QlWwAs11IP3BwYTi+R5LB
BVveAO5uKN03zUbQXScSfEqwPXUiM5aywrMxenwrFkWGKcrFM142GnrVqsx236Kp
hc2iZWIxgOt1951LHJ52RCsaNu+zWD5juciWpeWTeIfKhDk2HflMuSHv4vh/Ls0b
k/dXJRGrDPAYCP1GXZlTyteIrurwsEWqdmcCdstY0LwZskoRyGqM3zJPkqJLENko
rwT+4ZAHaCgarq1yHIhAc/0w0ZZgfr93vJRAkq39ARIj3zhtpatKIUvVCzbyK3dD
JIsoV+f4Ah0SL71O3Vj23jJboQkeYLfFPuPNAN3SpoHMY5fgCKOPf56jBlqmAdEO
Zun04rAzfNUTF5SKIeMxS4qpQiYwz2vpJPPGuLVniX7svEGfa7U=
=B7xG
-----END PGP SIGNATURE-----

--=-HfnQe6Xx6rBFLwlXKhP7--
