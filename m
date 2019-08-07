Return-Path: <SRS0=l2ne=WD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40E6C19759
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 06:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99D1F21BF6
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 06:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="Y6DZcoa3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfHGGkz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 02:40:55 -0400
Received: from mail-eopbgr700124.outbound.protection.outlook.com ([40.107.70.124]:22017
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726883AbfHGGke (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 02:40:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldZfibAOctKzfIjYOgWsaeAluGkww9MFY4za031bIihYqBd+0rg5iKhlZ6CJ4CmPn9Oe/UM4nMLc6+A4+gsB/2KSk7k9Iz7PuVADmH9EecrSV45rG5co0tv0mY+voUKUO61TndzkpqleAndhyi344iszYJZMEmzcK5qgpw6Ci7o2Hwrqq/Tx580oumsZsN63vHrcw+SW5rmtxi0jXT9PgUGp8dDUKfQrPdRgFkmEMVLljtLxY5LIzp/f19T963rFFXaRSnT4qILi6nff3Ag7dHmXoZXT8eDXNR+q1m/TZpOjnB3tOtjrY1eOmCT2p9+X3lkZxA6NVoK5pSs/GqJw8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2d8OsfOmcQphS5PjO02vzFKM5Nlva0x/VInvCwrPrw=;
 b=cdh18dP51vsxkSqjPP4mktrZVuUZDvLvaQlKQO+uRkQQGmcA0IsaO4oYshltJCD1tRY0MTsaDBfm7L20W9z4Pf/hyVhH98MYfgxuRL9uGD5v4E6On23K4R+YARbK3SABeXt6ifDksayKlcaUfExDZ3xAhv78eB6aq8kyduw/W4dsHZYhnBYAZDlJhMnFrHOnINuOGmH3oRDRBdfXN6weYcX5H8fZoVKetD9friMBQdF6aOVZxjX9xESxBLtNzNvlTKqUdNngNHZGJbxekyF4qwIE4M1RjZa+w1l/2mJ/hGA1F4J/Dx9eGXIWXrap6npTRF+YyHO6v2QgEtlCg0uL1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fortanix.com;dmarc=pass action=none
 header.from=fortanix.com;dkim=pass header.d=fortanix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2d8OsfOmcQphS5PjO02vzFKM5Nlva0x/VInvCwrPrw=;
 b=Y6DZcoa3aV5P5UmAesZosLUrAxcghMIAWgtcCWXNvF6Sa+SX3Q8CzoXFRL5xdlooAgSkMwjNsauw24NCHNWOiG11qUVvMmUGz+ULrUDyrI6JxbCkEXXFB65/d5vpcFRVsBMBfLy84FDf/rifn/ihi9r77BJ5SuJzNAnZF/xuPj4=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2640.namprd11.prod.outlook.com (52.135.91.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Wed, 7 Aug 2019 06:40:31 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::bd32:8938:dba:9379]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::bd32:8938:dba:9379%5]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 06:40:30 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "cedric.xing@intel.com" <cedric.xing@intel.com>
Subject: Re: [PATCH v21 00/28] Intel SGX foundations
Thread-Topic: [PATCH v21 00/28] Intel SGX foundations
Thread-Index: AQHVOZ2TUfYdM/CPWE6WCIX/rqIUqKbKL+2AgCUy3wA=
Date:   Wed, 7 Aug 2019 06:40:30 +0000
Message-ID: <df88d6ca-9f16-f6c0-fc2b-ee452a26563e@fortanix.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190714143653.ziwgmtgysknxfgnl@linux.intel.com>
In-Reply-To: <20190714143653.ziwgmtgysknxfgnl@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR01CA0015.prod.exchangelabs.com (2603:10b6:208:71::28)
 To SN6PR11MB3167.namprd11.prod.outlook.com (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.58.43.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09ad9116-7650-43e2-4ce9-08d71b0223c3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:SN6PR11MB2640;
x-ms-traffictypediagnostic: SN6PR11MB2640:
x-microsoft-antispam-prvs: <SN6PR11MB26401E0B4C1C6E6F8BB7A80AAAD40@SN6PR11MB2640.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(136003)(39840400004)(376002)(189003)(199004)(54534003)(2616005)(68736007)(6436002)(2906002)(14454004)(53546011)(6506007)(99936001)(8676002)(102836004)(14444005)(256004)(76176011)(476003)(81156014)(386003)(486006)(86362001)(446003)(81166006)(36756003)(11346002)(6486002)(7416002)(4326008)(66066001)(5660300002)(99286004)(229853002)(6512007)(8936002)(53936002)(31696002)(2201001)(54906003)(6116002)(3846002)(71200400001)(71190400001)(110136005)(64756008)(66556008)(7736002)(6246003)(66476007)(26005)(508600001)(25786009)(31686004)(2501003)(66616009)(66446008)(52116002)(305945005)(316002)(186003)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2640;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dot3UP4QNL+4/NeYVG3wW3JA9UAMyPV7Ep9BqS+27rPHr0QQr0URWSGkf0rqGsr5/X7GHeaw1gyjYYYzGbfEPQ+lA2A+71DAqTFmO1Pux/8Hh8HRRcFROaeLPK6Etd3Wvab2Yf0e8060FkwZIbRFbb99jdq1XM+ZkTmnQHaiAl8r7qpFaIPeTkRdEw5Knm3eLnQQIjCEwdRwJTv8I4nRwgFDqVZtJqXSQy4IiffGkfHXgyNaynaAnDlgs2sffZcpUinfBMjnjk35rq0tTqTuhIQ6Ps9yybs/bGcjBDJSO/6ynQA1rJ5sCOOglQao+OxS8+CH5R1RjYMOuhzy1YpngvbSgWIeRDDYc3+sCTtZpRxcA2r+ROdW5/ErpgBIC71pJ438OScIBf7MzzhSgV2rQWaRw1Zgal06qj04/5I/K58=
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050905070108070004010706"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ad9116-7650-43e2-4ce9-08d71b0223c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 06:40:30.2619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jethro@fortanix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2640
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050905070108070004010706
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-07-14 07:36, Jarkko Sakkinen wrote:
> On Sat, Jul 13, 2019 at 08:07:36PM +0300, Jarkko Sakkinen wrote:
>> v21:
>> * Check on mmap() that the VMA does cover an area that does not have
>>    enclave pages. Only mapping with PROT_NONE can do that to reserve
>>    initial address space for an enclave.
>> * Check om mmap() and mprotect() that the VMA permissions do not
>>    surpass the enclave permissions.
>> * Remove two refcounts from vma_close(): mm_list and encl->refcount.
>>    Enclave refcount is only need for swapper/enclave sync and we can
>>    remove mm_list refcount by destroying mm_struct when the process
>>    is closed. By not having vm_close() the Linux MM can merge VMAs.
>> * Do not naturally align MAP_FIXED address.
>> * Numerous small fixes and clean ups.
>> * Use SRCU for synchronizing the list of mm_struct's.
>> * Move to stack based call convention in the vDSO.
>=20
> I forgot something:
>=20
> * CONFIG_INTEL_SGX_DRIVER is not bistate i.e. no more LKM support. It i=
s
>    still useful to have the compile-time option because VM host does no=
t
>    need to have it enabled. Now sgx_init() calls explicitly sgx_drv_ini=
t().
>    In addition, platform driver has been ripped a way because we no
>    longer need ACPI hotplug. In effect, the device is now parentless.
>=20

I think you also missed in the changelog that you're now checking page=20
permissions in EADD.

--
Jethro Beekman | Fortanix


--------------ms050905070108070004010706
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDgwNzA2NDAzNFowLwYJKoZIhvcNAQkEMSIEIAoHFZVV
HZE73LQHlfAs9a/sYM2EYNmub9PQYxtQSc18MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQCw4pB4EpHg8Eo77eD1nbVHj6KkeHTrwUTg/pWcnZqagz579BGMAkDZrsDLWdiOd+w5NL01
R/XHhqIiOtT/Td/8Zc/VapicBO7GTChSN3BFAbvU26cOz0tCKKYpSL4c8c1no+xu5nrwfkyX
/X5LmbPbNIEhyT/BRySiSfZq/LfBP5rYAhNI6NNifSxhmUFG4l3T1XSRUM74TIzRbzyZSJ66
zZ7U5P/LeOQrDhFVkuQmbc8mJrRbhyRT/7YUI4QpSvlD55N6Gk4I33J9r2tL8J3E9lxx/wGT
ul9XYHTFNuD5iE+vlJ6D3E8BU4jvVFQ7HARHScqQbpixBDA/bMfln7u/AAAAAAAA

--------------ms050905070108070004010706--
