Return-Path: <SRS0=1WHz=M3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC45CC04AA5
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Oct 2018 20:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 677F7208B3
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Oct 2018 20:54:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 677F7208B3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbeJPEle (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 16 Oct 2018 00:41:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54116 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbeJPEle (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 16 Oct 2018 00:41:34 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id A906B80889; Mon, 15 Oct 2018 22:54:37 +0200 (CEST)
Date:   Mon, 15 Oct 2018 22:54:36 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        andriy.shevchenko@linux.intel.com,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 19/19] x86/sgx: Driver documentation
Message-ID: <20181015205436.GA28500@amd>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-20-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20180925130845.9962-20-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181015205436.0rcsbw_nUys-nHkhdUj9FCqLd057gx5LAtvCVwMOWAc@z>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2018-09-25 16:06:56, Jarkko Sakkinen wrote:
> Documentation of the features of the Software Guard eXtensions used
> by the Linux kernel and basic design choices for the core and driver
> and functionality.
>=20
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

> --- /dev/null
> +++ b/Documentation/x86/intel_sgx.rst
> @@ -0,0 +1,185 @@
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Intel(R) SGX driver
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Introduction
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Intel(R) SGX is a set of CPU instructions that can be used by applicatio=
ns to
> +set aside private regions of code and data. The code outside the enclave=
 is
> +disallowed to access the memory inside the enclave by the CPU access con=
trol.
> +In a way you can think that SGX provides inverted sandbox. It protects t=
he
> +application from a malicious host.

Well, recently hardware had some problems keeping its
promises. So... what about rowhammer, meltdown and spectre?

Which ones apply, which ones do not, and on what cpu generations?

> +Overview of SGX
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +SGX has a set of data structures to maintain information about the encla=
ves and
> +their security properties. BIOS reserves a fixed size region of physical=
 memory
> +for these structures by setting Processor Reserved Memory Range Registers
> +(PRMRR).
> +
> +This memory range is protected from outside access by the CPU and all th=
e data
> +coming in and out of the CPU package is encrypted by a key that is gener=
ated for
> +each boot cycle.

Encryption, that sounds nice, but it is hard to do right. If SGX
protected code changes single bit in its memory, how many bits will be
changed in physical RAM?

Can we get security people to look at this and perhaps tells us what
properties it has?

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlvE/owACgkQMOfwapXb+vI5JACeIS4TIY4nGCXYOUBBdtMzSfEh
JH4AoKFfu10QTC4CbpAC/REiWoJy7pLi
=Zkv5
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
