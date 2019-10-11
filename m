Return-Path: <SRS0=gA9u=YE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3A7ECE58C
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 16:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 250B62089F
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 16:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="V6Gd229i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfJKQh3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Oct 2019 12:37:29 -0400
Received: from mail-eopbgr770125.outbound.protection.outlook.com ([40.107.77.125]:49218
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726331AbfJKQh3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Oct 2019 12:37:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Do6iuZSWADfgenDWTyImGeWhcGnYZkMuYocbk3x8bL4IkqSnPSSGVGMlkcrgcbJvJmG5AcFMSDnIE/B3CjVhY3LkSL2b7i8Dt1dTO79l9YJtu/5Vy41bd5YjYARd2qFgm4SI7Kj8QdSwgeITjVsDekzdrprAEUXgkWtEnYkwiBm7TyaM8VdwutiCtI2PcFpj3SqNoc6TtdBXIGjPuSUuz8Oq0v/NZ2fMC7QFjTFOtC6XqpU2TGDsUAwR8GOu82kkvm3+gWDMN4SYysg+bVgObNsAK6HCZ5c72EpnwEcgY5IeGPRLy5vteIWBchL78c8ukkqcjwH3K4GcJfBPE/BzEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRjKtiE9GfdvDeY1LIacPVdi5vnLimeWCsBkzBRE3hk=;
 b=ErqUDnu7ZgSsaxO/Qc/EkiSLbsmqgvl5/274PS19qG0opN17Et7ipftT6S1HlZVX+k6mnhGgJFNPgQdf7OOin3I1kqfLasaC5I9AoNezRv98/QyFk2PVc7/cm9TGXLkLsuFrI/BoIrp9LD3e9JSR+hoYWjj0NZFajyv4f7jrY13EkQJ6BbfhPewkt0vQOUl0Ozr4xBxgfkMMLWqfZgxM10ZnzElpyMFiSVo53oq5E/snhqZJg2LXFQLRZVt9531Rk/pqkeZdyaNbbu80Q9IYWgsPxPS4jdmTC7fy3upJgfezi9VdQtpFnLUWPfzLVnbfcKmU4aWNKos3RvZf6J/Eyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRjKtiE9GfdvDeY1LIacPVdi5vnLimeWCsBkzBRE3hk=;
 b=V6Gd229i0xfFskmeH0QHFkeyGN2XPmn28+MsUCjuBjrFRbpPkNKVHiQsNHbnsm3Ztjlo9cc0Ca0gxpKfhySWwglzEkqptw3EIUz66hTD0MOEGoEeflclm2NfadNlXgTzVVOY7NiVPO+QwDO8Kg7jFXi+AnSdvx+tuULIjwNx/FI=
Received: from DM6PR11MB3740.namprd11.prod.outlook.com (20.179.16.22) by
 DM6PR11MB4298.namprd11.prod.outlook.com (52.132.251.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Fri, 11 Oct 2019 16:37:25 +0000
Received: from DM6PR11MB3740.namprd11.prod.outlook.com
 ([fe80::6815:fb8d:66f5:1e1c]) by DM6PR11MB3740.namprd11.prod.outlook.com
 ([fe80::6815:fb8d:66f5:1e1c%7]) with mapi id 15.20.2347.016; Fri, 11 Oct 2019
 16:37:25 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Thread-Topic: x86/sgx: v23-rc2
Thread-Index: AQHVf18m9ttV+e6GE0ir+CdMME1pGadVpY2A
Date:   Fri, 11 Oct 2019 16:37:25 +0000
Message-ID: <a657081e-cdaf-7c9d-2695-23c9c07bcfbf@fortanix.com>
References: <20191010113745.GA12842@linux.intel.com>
In-Reply-To: <20191010113745.GA12842@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0426.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::30) To DM6PR11MB3740.namprd11.prod.outlook.com
 (2603:10b6:5:140::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.61.132.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1167621a-777e-49dc-4221-08d74e694c42
x-ms-traffictypediagnostic: DM6PR11MB4298:
x-microsoft-antispam-prvs: <DM6PR11MB4298565875341C3D3D244426AA970@DM6PR11MB4298.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(346002)(376002)(39840400004)(53754006)(52314003)(189003)(199004)(99936001)(2906002)(14444005)(256004)(64756008)(53546011)(25786009)(66946007)(71190400001)(71200400001)(36756003)(6436002)(6116002)(6486002)(486006)(54906003)(476003)(2616005)(11346002)(14454004)(446003)(3846002)(6246003)(6306002)(6512007)(229853002)(4001150100001)(66066001)(26005)(186003)(52116002)(102836004)(76176011)(4326008)(305945005)(7736002)(2501003)(66446008)(81156014)(81166006)(110136005)(66556008)(6506007)(386003)(99286004)(8676002)(31696002)(508600001)(66476007)(66616009)(8936002)(316002)(86362001)(31686004)(5660300002)(966005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR11MB4298;H:DM6PR11MB3740.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NFCtCItX9J4npkYhNInzCct2fYrFQggampU1kxY/lE/BSwN7qAVrfkGKDVvWVW9aE8c0iAKO8yd/cv343SU+wgz2rI0g8b68KOMr0vJw7ZP9PEAkSmiK6PXXbodzrFeJ9MHYNNDlLsQ6HoNh4Ujv4Zl4FDO55haJ8R0IWghP2CIb+W7pjpZnSsoVWGu1afwAbzutkX07S1LyUBU2JC+UVZ9NWJIRcngDwgPEc6BWu0py1LH2fMakf7r7yVwkKXQ9ISuFxkSFxt/x6iO/stNXAcqUEwMFDqogS/xHks1qsI9LicUNjlQn80xp55WVbslBKdLkw0ftTYV/iFhY5D9mAHP5dACnZCVEb/eFYscJWTZOJ5QKXUdzWsuJvJkEvzLrQ2PQCo52IQG9b+xI9LVvkKlN+G2UyaFqENP/8702LZw=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060104090301090101030700"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1167621a-777e-49dc-4221-08d74e694c42
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 16:37:25.5976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2hbFu7ogUCWLi8Ekd5+g1oIXEtfIHF3j01ZBkGi6ugwYFgUrmW6lv/1r/yW5Yqhe6uo9RO4C5sKrYLTPfmOmmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4298
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms060104090301090101030700
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi all,

I wrote a preliminary patch integrating the latest kernel patches with th=
e Rust EDP, see https://github.com/fortanix/rust-sgx/pull/181 . I tested =
against (I think) v23-rc2 with the 3 patch sets from Sean applied. In par=
ticular, I started from https://github.com/jsakkine-intel/linux-sgx 8915a=
ef. It would be nice if you'd use git tags so everyone can be on the same=
 page.

I haven't done a whole lot of testing, so I can't speak to the stability =
of the driver. But I do have some comments regarding the API.



UAPI:

This got a whole lot more complex for userspace compared to the out-of-tr=
ee driver.

1. Manually needing to mmap a naturally-aligned memory region by allocati=
ng too much memory and then unmapping parts is quite annoying. Why was th=
e auto-aligning removed? I think this will need to be handled the same fo=
r every consumer of SGX, so I don't see why this is not handled in the ke=
rnel. It never seems wrong to align if NULL is passed as the requested ad=
dress. Alternatively, is there room in the flags for a MAP_ALIGNED bit?

2. Having to re-open the device for every enclave is also annoying. This =
means you need a filesystem available throughout the process lifetime. I =
tried dup, but that doesn't work. Can we make dup work?

3. Needing to mprotect every page with the precise permissions needed aft=
er EINIT is really bad. This means I have to remember this data for every=
 page between EADD and EINIT. I don't care about SELinux, I trust the ECP=
M will do its job for me. Can we make it so that I can protect the whole =
range at once, or protect the individual pages at EADD time?



VDSO:

It is *difficult* to link to weakly link to a symbol in the VDSO. Anyway,=
 I figured it out.

1. What if I don't want to automatically ERESUME after kernel interrupt?

2. I normally do a sanity check after ENCLU[EENTER] that EAX =3D EEXIT. T=
he current implementation just clears EAX instead without looking at it.

--
Jethro Beekman | Fortanix

On 2019-10-10 13:37, Jarkko Sakkinen wrote:
> tag v23-rc2
> Tagger: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Date:   Thu Oct 10 14:33:07 2019 +0300
>=20
> x86/sgx: v23-rc1 patch set
>=20
> * Return -EIO instead of -ECANCELED when ptrace() fails to read a TCS p=
age.
> * In the reclaimer, pin page before ENCLS[EBLOCK] because pinning can f=
ail
>   (because of OOM) even in legit behaviour and after EBLOCK the reclaim=
ing
>   flow can be only reverted by killing the whole enclave.
> * Fixed SGX_ATTR_RESERVED_MASK. Bit 7 was marked as reserved while in f=
act
>   it should have been bit 6 (Table 37-3 in the SDM).
> * Return -EPERM from SGX_IOC_ENCLAVE_INIT when ENCLS[EINIT] returns an =
SGX
>   error code.
> * In v22 __uaccess_begin() was used to pin the source page in
>   __sgx_encl_add_page(). Switch to get_user_pages() in order to avoid
>   deadlock (mmap_sem might get locked twice in the same thread).
> -----BEGIN PGP SIGNATURE-----
>=20
> iJYEABYIAD4WIQRE6pSOnaBC00OEHEIaerohdGur0gUCXZ8XTyAcamFya2tvLnNh
> a2tpbmVuQGxpbnV4LmludGVsLmNvbQAKCRAaerohdGur0phXAP9QPYcpyUTSO9hk
> sG/pV7vsIjS4lO6pxBCgWCtg3/ZkvAEApLCu7mFvyZs3rDcbOlQA+nQiVv+rUwzu
> tsYmW2YsgQ4=3D
> =3DVeL3
> -----END PGP SIGNATURE-----
>=20
> /Jarkko
>=20


--------------ms060104090301090101030700
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
C54wggVPMIIEN6ADAgECAhAFFr+cC0ZYZTtbKgQCBwyyMA0GCSqGSIb3DQEBCwUAMIGCMQsw
CQYDVQQGEwJJVDEPMA0GA1UECAwGTWlsYW5vMQ8wDQYDVQQHDAZNaWxhbm8xIzAhBgNVBAoM
GkFjdGFsaXMgUy5wLkEuLzAzMzU4NTIwOTY3MSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBB
dXRoZW50aWNhdGlvbiBDQSBHMTAeFw0xOTA5MTYwOTQ3MDlaFw0yMDA5MTYwOTQ3MDlaMB4x
HDAaBgNVBAMME2pldGhyb0Bmb3J0YW5peC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDHWEhcRGkEl1ZnImSqBt/OXNJ4AyDZ86CejuWI9jYpWbtf/gXBQO6iaaEKBDlj
Vffk2QxH9wcifkYsvCYfxFgD15dU9TABO7YOwvHa8NtxanWr1xomufu/P1ApI336+S7ZXfSe
qMnookNJUMHuF3Nxw2lI69LXqZLCdcVXquM4DY1lVSV+DXIwpTMtB+pMyqOWrsgmrISMZYFw
EUJOqVDvtU8KewhpuGAYXAQSDVLcAl2nZg7C2Mex8vT8stBoslPTkRXxAgMbslDNDUiKhy8d
E3I78P+stNHlFAgALgoYLBiVVLZkVBUPvgr2yUApR63yosztqp+jFhqfeHbjTRlLAgMBAAGj
ggIiMIICHjAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFH5g/Phspz09166ToXkCj7N0KTv1
MEsGCCsGAQUFBwEBBD8wPTA7BggrBgEFBQcwAoYvaHR0cDovL2NhY2VydC5hY3RhbGlzLml0
L2NlcnRzL2FjdGFsaXMtYXV0Y2xpZzEwHgYDVR0RBBcwFYETamV0aHJvQGZvcnRhbml4LmNv
bTBHBgNVHSAEQDA+MDwGBiuBHwEYATAyMDAGCCsGAQUFBwIBFiRodHRwczovL3d3dy5hY3Rh
bGlzLml0L2FyZWEtZG93bmxvYWQwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMIHo
BgNVHR8EgeAwgd0wgZuggZiggZWGgZJsZGFwOi8vbGRhcDA1LmFjdGFsaXMuaXQvY24lM2RB
Y3RhbGlzJTIwQ2xpZW50JTIwQXV0aGVudGljYXRpb24lMjBDQSUyMEcxLG8lM2RBY3RhbGlz
JTIwUy5wLkEuLzAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRI
Q0wtRzEvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUAXkM7yNq6pH6j+IC/7IsDPSTMnowDgYDVR0P
AQH/BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4IBAQC8z+2tLUwep0OhTQBgMaybrxTHCxRZ4/en
XB0zGVrry94pItE4ro4To/t86Kfcic41ZsaX8/SFVUW2NNHjEodJu94UhYqPMDUVjO6Y14s2
jznFHyKQdXMrhIBU5lzYqyh97w6s82Z/qoMy3OuLek+8rXirwju9ATSNLsFTzt2CEoyCSRtl
yOmR7Z9wgSvD7C7XoBdGEFVdGCXwCy1t9AT7UCIHKssnguVaMGN9vWqLPVKOVTwc4g3RAQC7
J1Aoo6U5d6wCIX4MxEZhICxnUgAKHULxsWMGjBfQAo3QGXjJ4wDEu7O/5KCyUfn6lyhRYa+t
YgyFAX0ZU9Upovd+aOw0MIIGRzCCBC+gAwIBAgIILNSK07EeD4kwDQYJKoZIhvcNAQELBQAw
azELMAkGA1UEBhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5B
Li8wMzM1ODUyMDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENB
MB4XDTE1MDUxNDA3MTQxNVoXDTMwMDUxNDA3MTQxNVowgYIxCzAJBgNVBAYTAklUMQ8wDQYD
VQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4v
MDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENB
IEcxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwPzBiVbZiOL0BGW/zQk1qygp
MP4MyvcnqxwR7oY9XeT1bES2DFczlZfeiIqNLanbkyqTxydXZ+kxoS9071qWsZ6zS+pxSqXL
s+RTvndEaWx5hdHZcKNWGzhy5FiO4GZvGlFInFEiaY+dOEpjjWvSeXpvcDpnYw6M9AXuHo4J
hjC3P/OK//5QFXnztTa4iU66RpLteOTgCtiRCwZNKx8EFeqqfTpYvfEb4H91E7n+Y61jm0d2
E8fJ2wGTaSSwjc8nTI2ApXujoczukb2kHqwaGP3q5UuedWcnRZc65XUhK/Z6K32KvrQuNP32
F/5MxkvEDnJpUnnt9iMExvEzn31zDQIDAQABo4IB1TCCAdEwQQYIKwYBBQUHAQEENTAzMDEG
CCsGAQUFBzABhiVodHRwOi8vb2NzcDA1LmFjdGFsaXMuaXQvVkEvQVVUSC1ST09UMB0GA1Ud
DgQWBBR+YPz4bKc9Pdeuk6F5Ao+zdCk79TAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaA
FFLYiDrIn3hm7YnzezhwlMkCAjbQMEUGA1UdIAQ+MDwwOgYEVR0gADAyMDAGCCsGAQUFBwIB
FiRodHRwczovL3d3dy5hY3RhbGlzLml0L2FyZWEtZG93bmxvYWQwgeMGA1UdHwSB2zCB2DCB
lqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUuYWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRo
ZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxvJTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIw
OTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0
cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAO
BgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQELBQADggIBAE2TztUkvkEbShZYc19lifLZej5Y
jLzLxA/lWxZnssFLpDPySfzMmndz3F06S51ltwDe+blTwcpdzUl3M2alKH3bOr855ku9Rr6u
edya+HGQUT0OhqDo2K2CAE9nBcfANxifjfT8XzCoC3ctf9ux3og1WuE8WTcLZKgCMuNRBmJt
e9C4Ug0w3iXqPzq8KuRRobNKqddPjk3EiK+QA+EFCCka1xOLh/7cPGTJMNta1/0u5oLiXaOA
HeALt/nqeZ2kZ+lizK8oTv4in5avIf3ela3oL6vrwpTca7TZxTX90e805dZQN4qRVPdPbrBl
WtNozH7SdLeLrcoN8l2EXO6190GAJYdynTc2E6EyrLVGcDKUX91VmCSRrqEppZ7W05TbWRLi
6+wPjAzmTq2XSmKfajq7juTKgkkw7FFJByixa0NdSZosdQb3VkLqG8EOYOamZLqH+v7ua0+u
lg7FOviFbeZ7YR9eRO81O8FC1uLgutlyGD2+GLjgQnsvneDsbNAWfkory+qqAxvVzX5PSaQp
2pJ52AaIH1MN1i2/geRSP83TRMrFkwuIMzDhXxKFQvpspNc19vcTryzjtwP4xq0WNS4YWPS4
U+9mW+U0Cgnsgx9fMiJNbLflf5qSb53j3AGHnjK/qJzPa39wFTXLXB648F3w1Qf9R7eZeTRJ
fCQY/fJUMYID9jCCA/ICAQEwgZcwgYIxCzAJBgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8x
DzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5Njcx
LDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZY
ZTtbKgQCBwyyMA0GCWCGSAFlAwQCAQUAoIICLzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0xOTEwMTExNjM3MTlaMC8GCSqGSIb3DQEJBDEiBCCZhhi0mL6O
fxBxGgIT3er7M8e3ewkesELblCjeS5dUSDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAhHqjCS+jvYK8VHEh6pbAm4NVmmeifRkeKf/rK3kYN2ndbvhRdfaePIsm
EBt+a24sWkmaNC0HuUSmV/8mAiHxg7BaDHgKc7uc4fim4/XuTr9fky6IuPBezDKI/g+2U0EH
SMUpYn6+KUSadiWvtSQzqvXuOuqyWAM0jxIo1sRprPtHGus7YMgf6wOCc37yjTNoHNS9N5sS
WWd5uH/pPwd1bS3arao2l0I4WvLwGOK78CxGkb26w3qm3S0kg6zSYc62b7/t+0a+LJ62qHKo
gD8cTwfg/B12seqIUaHex5uQFdrynq8/fNg8ZXTvaxbFIEXInJH4XHK1oGh/NDKlyxXC7AAA
AAAAAA==

--------------ms060104090301090101030700--
