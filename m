Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6310DC31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23D1020665
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="f1vP/Irb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404196AbfFMQ6o (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:58:44 -0400
Received: from mail-eopbgr800139.outbound.protection.outlook.com ([40.107.80.139]:4512
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729878AbfFMAnu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 20:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJDJYXMRcRxXKiZRQxC4DUL1k2MqPsc5v8DPM5gl1HQ=;
 b=f1vP/IrbUDTdH4iq0+Uw9W/yQL6Q8fhJiJZwK795Jj0sUt9qYkcDa2XilJyikXvlkPP99XN9Zm3a+Ze8fw03/BM5OZIMM5ZJV5iLHzJo/zvAD3iPqytKUpMYXYHQguIO0oI9DV94m9tD90nALtcJPNQt/AFuzahaAbLF53lt/3U=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3454.namprd11.prod.outlook.com (52.135.111.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 00:43:42 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::95a7:7f01:a25f:c318]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::95a7:7f01:a25f:c318%7]) with mapi id 15.20.1965.017; Thu, 13 Jun 2019
 00:43:42 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH 4/7] x86/sgx: Allow userspace to add multiple pages in
 single ioctl()
Thread-Topic: [PATCH 4/7] x86/sgx: Allow userspace to add multiple pages in
 single ioctl()
Thread-Index: AQHVG9fRgGNALS7dK0GDigS6wliYTqaYymQA
Date:   Thu, 13 Jun 2019 00:43:42 +0000
Message-ID: <f2e88e83-e5f6-fecb-c180-b75be1d1a582@fortanix.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-5-sean.j.christopherson@intel.com>
In-Reply-To: <20190605194845.926-5-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:2d::29) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.56.38.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da6b912f-58bd-44c8-3e82-08d6ef982efc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:SN6PR11MB3454;
x-ms-traffictypediagnostic: SN6PR11MB3454:
x-microsoft-antispam-prvs: <SN6PR11MB34547041417D08232B8B97E2AAEF0@SN6PR11MB3454.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(346002)(396003)(39840400004)(199004)(189003)(446003)(508600001)(8676002)(31686004)(11346002)(81166006)(14454004)(476003)(6116002)(81156014)(486006)(66446008)(2616005)(3846002)(8936002)(68736007)(229853002)(6512007)(6436002)(6246003)(73956011)(6486002)(25786009)(66476007)(26005)(2906002)(66946007)(66616009)(64756008)(66556008)(4326008)(186003)(99936001)(54906003)(86362001)(19627235002)(76176011)(71200400001)(53936002)(52116002)(36756003)(316002)(71190400001)(386003)(31696002)(6506007)(99286004)(5660300002)(110136005)(102836004)(7736002)(305945005)(256004)(14444005)(53546011)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3454;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Mwaj7vfO8VsZIs7GK4/j3eDTykS0nhRvoMqVy8hXbzZcqSizLUTVuT3fDXg7gu7NeV5c8qdanHbyFep/heBJZ3EuhsxcE66/8nkYrWSnXVePfDqUL8EwVc/RF9H8AMFYv5TP7JuAIuWGpux9sFnZ/qZ+HHukK6jA5b/0i5xl4uT/VfzLB/KmJnC74mPQR07WYH625P8Nb6XGtZAG1t7AqUgXBTZaoFP8dLoy/YaVosvNIzWZez+VsYERnXe5yM0RBBBMYoC3Q3I6EV/zTORapYg9CwImOIJ6KIvNdxuNI2X608/SY4ahttG2tcs8bevkEWTMchxoLNRA9j0CUoAWMgzLOTTyAVzGEp0Tlv0iQw/TTIN3TjmgPGpDRc0xBjxUUOhbvztNIJmFJnhj2LpA+Jb5yu+8C4YXTyJrff7WKSE=
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090107060001060501060607"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da6b912f-58bd-44c8-3e82-08d6ef982efc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 00:43:42.4722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jethro@fortanix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3454
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms090107060001060501060607
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-06-05 12:48, Sean Christopherson wrote:
> ...to improve performance when building enclaves by reducing the number=

> of user<->system transitions.  Rather than provide arbitrary batching,
> e.g. with per-page SECINFO and mrmask, take advantage of the fact that
> any sane enclave will have large swaths of pages with identical
> properties, e.g. code vs. data sections.
>=20
> For simplicity and stability in the initial implementation, loop over
> the existing add page flow instead of taking a more agressive approach,=

> which would require tracking transitions between VMAs and holding
> mmap_sem for an extended duration.
>=20
> On an error, update the userspace struct to reflect progress made, e.g.=

> so that the ioctl can be re-invoked to finish adding pages after a non-=

> fatal error.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   Documentation/x86/sgx/3.API.rst        |   2 +-
>   arch/x86/include/uapi/asm/sgx.h        |  21 ++--
>   arch/x86/kernel/cpu/sgx/driver/ioctl.c | 128 +++++++++++++++++-------=
-
>   3 files changed, 98 insertions(+), 53 deletions(-)
>=20
> diff --git a/Documentation/x86/sgx/3.API.rst b/Documentation/x86/sgx/3.=
API.rst
> index b113aeb05f54..44550aa41073 100644
> --- a/Documentation/x86/sgx/3.API.rst
> +++ b/Documentation/x86/sgx/3.API.rst
> @@ -22,6 +22,6 @@ controls the `PROVISON_KEY` attribute.
>  =20
>   .. kernel-doc:: arch/x86/kernel/cpu/sgx/driver/ioctl.c
>      :functions: sgx_ioc_enclave_create
> -               sgx_ioc_enclave_add_page
> +               sgx_ioc_enclave_add_region
>                  sgx_ioc_enclave_init
>                  sgx_ioc_enclave_set_attribute
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/as=
m/sgx.h
> index 9ed690a38c70..30d114f6b3bd 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -12,8 +12,8 @@
>  =20
>   #define SGX_IOC_ENCLAVE_CREATE \
>   	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
> -#define SGX_IOC_ENCLAVE_ADD_PAGE \
> -	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
> +#define SGX_IOC_ENCLAVE_ADD_REGION \
> +	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_region)
>   #define SGX_IOC_ENCLAVE_INIT \
>   	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
>   #define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
> @@ -32,21 +32,22 @@ struct sgx_enclave_create  {
>   };
>  =20
>   /**
> - * struct sgx_enclave_add_page - parameter structure for the
> - *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> - * @addr:	address within the ELRANGE
> - * @src:	address for the page data
> - * @secinfo:	address for the SECINFO data
> - * @mrmask:	bitmask for the measured 256 byte chunks
> + * struct sgx_enclave_add_region - parameter structure for the
> + *                                 %SGX_IOC_ENCLAVE_ADD_REGION ioctl
> + * @addr:	start address within the ELRANGE
> + * @src:	start address for the pages' data
> + * @size:	size of region, in bytes
> + * @secinfo:	address of the SECINFO data (common to the entire region)=

> + * @mrmask:	bitmask of 256 byte chunks to measure (applied per 4k page=
)
>    */
> -struct sgx_enclave_add_page {
> +struct sgx_enclave_add_region {
>   	__u64	addr;
>   	__u64	src;
> +	__u64	size;
>   	__u64	secinfo;
>   	__u16	mrmask;

Considering:

1. I might want to load multiple pages that are not consecutive in memory=
=2E
2. Repeating mrmask (other than 0 or ~0) doesn't really make sense for=20
ranges.

I'd be in favor of an approach that passes an array of=20
sgx_enclave_add_page instead.

Somewhat unrelated: have you considered optionally "gifting" enclave=20
source pages to the kernel (as in vmsplice)? That would avoid the=20
copy_from_user.

--
Jethro Beekman | Fortanix


--------------ms090107060001060501060607
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
Cx8wggUxMIIEGaADAgECAhBdZC9mIseKJlmxx1xn+g00MA0GCSqGSIb3DQEBCwUAMIGXMQsw
CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
b3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBD
bGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xODA5MTUwMDAw
MDBaFw0xOTA5MTUyMzU5NTlaMCQxIjAgBgkqhkiG9w0BCQEWE2pldGhyb0Bmb3J0YW5peC5j
b20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDRQDOQsroKjy2xAQCXLyqryJt4
Xwj8hcweJCzOnjILKHIoWlOQ0b9yIbFLIWBRt/9zdxlE5ZabDVHnkIyhcVgtU/BA73e78Wx2
LOObdg0wfs9U2CVRYhz2EPHFjGvkYKihItt69ye91hj1w7RKCrYC8KZGSZ/+sbkJzQdXVy32
lxmiNEt17GNRebpkJCaFnznd6C2a8tBAS2Fa/UNyFdEs4eoRoYSKswclRhbe81aVhqY2hjcd
O6puyyaYp5hkmau2UPih6OpRSOhbe6Tuebceg1yvumoVX3OZtGPS1VdQ+p0bxB0RE6gNs140
ZKUhrvAJDETuGaaQD4A2/6ksLunjAgMBAAGjggHpMIIB5TAfBgNVHSMEGDAWgBSCr2yM+MX+
lmF86B89K3FIXsSLwDAdBgNVHQ4EFgQUsFUcmGtaJBU7/52LyTYHC/M+LscwDgYDVR0PAQH/
BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEBAwUC
MBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkGCCsG
AQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBL
hklodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlv
bmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0
dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5k
U2VjdXJlRW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNv
bTAeBgNVHREEFzAVgRNqZXRocm9AZm9ydGFuaXguY29tMA0GCSqGSIb3DQEBCwUAA4IBAQB6
v3tFEUSGv9+yY4wUjvcMyz3126nJrX5LkfEvrnCEpEiImECuoYvxOYNLYYynell7BQGtTaZg
shMfDvwpy2isoi3w1AWAfbn6npnSKLzu0BMRvcCPWY8VPmePPizTqXoPkLwgTJfSaWkxMP1u
rfL9S5NeRdkjwjHklX5IWuwwDu1hsKVZrxSSY2unCtvq67UHWz+z6rG1JQrP2YDfb98xun3y
eLBNe/LFBNnGISbkT5q6D+e5c0bgzoH9nH4bsw3t8aDqJTfT3BqQdWr4pF05ODzzeOmEqeYE
qGlD9hIL2AbmTZLjunAnARr6Fv7Sfqt23ptsGkmoZ9ZQNjT3TlwvMIIF5jCCA86gAwIBAgIQ
apvhODv/K2ufAdXZuKdSVjANBgkqhkiG9w0BAQwFADCBhTELMAkGA1UEBhMCR0IxGzAZBgNV
BAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09N
T0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRo
b3JpdHkwHhcNMTMwMTEwMDAwMDAwWhcNMjgwMTA5MjM1OTU5WjCBlzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQC+s55XrCh2dUAWxzgDmNPGGHYhUPMleQtMtaDRfTpYPpynMS6n9jR22YRq2tA9
NEjk6vW7rN/5sYFLIP1of3l0NKZ6fLWfF2VgJ5cijKYy/qlAckY1wgOkUMgzKlWlVJGyK+Ul
NEQ1/5ErCsHq9x9aU/x1KwTdF/LCrT03Rl/FwFrf1XTCwa2QZYL55AqLPikFlgqOtzk06kb2
qvGlnHJvijjI03BOrNpo+kZGpcHsgyO1/u1OZTaOo8wvEU17VVeP1cHWse9tGKTDyUGg2hJZ
jrqck39UIm/nKbpDSZ0JsMoIw/JtOOg0JC56VzQgBo7ictReTQE5LFLG3yQK+xS1AgMBAAGj
ggE8MIIBODAfBgNVHSMEGDAWgBS7r34CPfqm8TyEjq3uOJjs2TIy1DAdBgNVHQ4EFgQUgq9s
jPjF/pZhfOgfPStxSF7Ei8AwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAw
EQYDVR0gBAowCDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmwuY29tb2Rv
Y2EuY29tL0NPTU9ET1JTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHEGCCsGAQUFBwEB
BGUwYzA7BggrBgEFBQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQWRk
VHJ1c3RDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTANBgkq
hkiG9w0BAQwFAAOCAgEAeFyygSg0TzzuX1bOn5dW7I+iaxf28/ZJCAbU2C81zd9A/tNx4+js
QgwRGiHjZrAYayZrrm78hOx7aEpkfNPQIHGG6Fvq3EzWf/Lvx7/hk6zSPwIal9v5IkDcZoFD
7f3iT7PdkHJY9B51csvU50rxpEg1OyOT8fk2zvvPBuM4qQNqbGWlnhMpIMwpWZT89RY0wpJO
+2V6eXEGGHsROs3njeP9DqqqAJaBa4wBeKOdGCWn1/Jp2oY6dyNmNppI4ZNMUH4Tam85S1j6
E95u4+1Nuru84OrMIzqvISE2HN/56ebTOWlcrurffade2022O/tUU1gb4jfWCcyvB8czm12F
gX/y/lRjmDbEA08QJNB2729Y+io1IYO3ztveBdvUCIYZojTq/OCR6MvnzS6X72HP0PRLRTiO
SEmIDsS5N5w/8IW1Hva5hEFy6fDAfd9yI+O+IMMAj1KcL/Zo9jzJ16HO5m60ttl1Enk8MQkz
/W3JlHaeI5iKFn4UJu1/cP2YHXYPiWf2JyBzsLBrGk1II+3yL8aorYew6CQvdVifC3HtwlSa
m9V1niiCfOBe2C12TdKGu05LWIA3ZkFcWJGaNXOZ6Ggyh/TqvXG5v7zmEVDNXFnHn9tFpMpO
UvxhcsjycBtH0dZ0WrNw6gH+HF8TIhCnH3+zzWuDN0Rk6h9KVkfKehIxggQ1MIIEMQIBATCB
rDCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
BxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9E
TyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yi
x4omWbHHXGf6DTQwDQYJYIZIAWUDBAIBBQCgggJZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDYxMzAwNDMzOFowLwYJKoZIhvcNAQkEMSIEIKqez0Km
02APhLvMTRbPC3KqBCBAgIXMY1S/mEUuolAKMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQA3dZT/DlORbeP3mggDRHi8KBu2pe+4T9u2TqOv/1N+G1dkfavr5sV4VXTglY43rQInX6LB
Cpq5Th+ucAMWPSc9L6LoVNGwcEUWmnga8wnZ6Ht68lbS1uLS8BoCJyxpJvBUnORahV56Jbau
1JktTQd7EyjGjhovDuPVGtgKowY3id+YctvX6BfcM7Tgtoz5pqtpC7yMRTWfPtKNzw5HaChG
aUfoBGOKFirP7evn9MvT6iOnSR1DpjDjX9GdjZShPLyP/R/yZseKO1tMdkNsW3nLW3LUUFIj
LSNNfX1v1eNWcAVFaWNHkx3Td1/VSds65CMc1Bpt65BF+AkYeU5ettAZAAAAAAAA

--------------ms090107060001060501060607--
