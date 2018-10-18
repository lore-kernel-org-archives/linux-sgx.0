Date: Thu, 18 Oct 2018 11:57:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "open
 list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 19/19] x86/sgx: Driver documentation
Message-ID: <20181018095727.GC10861@amd>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-20-jarkko.sakkinen@linux.intel.com>
 <20181015205436.GA28500@amd>
 <alpine.DEB.2.21.1810180205490.5022@jsakkine-mobl1>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
In-Reply-To: <alpine.DEB.2.21.1810180205490.5022@jsakkine-mobl1>
Return-Path: pavel@ucw.cz
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2018-10-18 02:45:27, Jarkko Sakkinen wrote:
> On Mon, 15 Oct 2018, Pavel Machek wrote:
> >On Tue 2018-09-25 16:06:56, Jarkko Sakkinen wrote:
> >>+Intel(R) SGX is a set of CPU instructions that can be used by applicat=
ions to
> >>+set aside private regions of code and data. The code outside the encla=
ve is
> >>+disallowed to access the memory inside the enclave by the CPU access c=
ontrol.
> >>+In a way you can think that SGX provides inverted sandbox. It protects=
 the
> >>+application from a malicious host.
> >
> >Well, recently hardware had some problems keeping its
> >promises. So... what about rowhammer, meltdown and spectre?
>=20
> Doesn't hardware always have this problem over time?

No, not really.

In this case, tries to protect from hardware "attacks" done by machine
owner. That job is theoretically impossible, so you have harder
situation than most..

> >Which ones apply, which ones do not, and on what cpu generations?
>=20
> Definitely should be refined.
>=20
> Meltdowns approach AFAIK does not work because reads outside the enclave
> will always have a predefined value (-1) but only if the page is present,
> which was later exploited in the Foreshadow attack.

What about L1tf and https://github.com/lsds/spectre-attack-sgx ?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlvIWQcACgkQMOfwapXb+vIbCwCgw3wWxvBiMbEy5TVWTbYyQmif
TjkAniEwkld7XGcUBTl90sv+3trigWg1
=YAi6
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
