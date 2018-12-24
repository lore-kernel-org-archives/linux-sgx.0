Return-Path: <SRS0=n9z9=PB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46ECBC43387
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 05:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D933821773
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 05:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="q9nK7jio"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbeLXFRf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Dec 2018 00:17:35 -0500
Received: from mail-eopbgr730094.outbound.protection.outlook.com ([40.107.73.94]:4224
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbeLXFRf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Dec 2018 00:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJwm0CciPlKDQBQ7/SLnzTTQV1+3LhuMDIHiFkpJ5V4=;
 b=q9nK7jioIaTvqqB4TrUajBcawGouUlae2gPOaRNmZP89kYwxIVU7f/8cbQAFndhVXN5dCHUCsavgKiVpbl/myAMgAxNJX39SDPLq4JnyWMC6+6R4OWs+ITgJ3VLyxvstIfw9jYaAKhLxuj4x62rKg25og7o0p0XdGRbZgVKktGg=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3501.namprd11.prod.outlook.com (52.135.125.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1446.23; Mon, 24 Dec 2018 05:17:16 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::106d:42ec:cef3:2303]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::106d:42ec:cef3:2303%3]) with mapi id 15.20.1446.026; Mon, 24 Dec 2018
 05:17:16 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
        "luto@kernel.org" <luto@kernel.org>
Subject: Re: [PATCH v18 10/25] x86/sgx: Add ENCLS architectural error codes
Thread-Topic: [PATCH v18 10/25] x86/sgx: Add ENCLS architectural error codes
Thread-Index: AQHUmYLQI4TiUSxMRka8J/nfrp+2yaWNXMoA
Date:   Mon, 24 Dec 2018 05:17:16 +0000
Message-ID: <4966112d-36b3-37e7-4344-2a0401a1f73d@fortanix.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
 <20181221231154.6120-11-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181221231154.6120-11-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR03CA0110.apcprd03.prod.outlook.com
 (2603:1096:4:91::14) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [14.143.179.162]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3501;6:wolaPllKUscJMLR/koqu4CVvSO/6Dci4Q4zvTRqLh7o8llwGN81/d33fOL2cT4ez7APW6Kiszz/Kq0QXE+6dFzuJsQLiOeMFQTgjKtB7Zk6zbYSWzeVUEe+6VqpjNIW7FfX+9cgPGYbNxlecdyGSjExHRS6HHrMVBzjRnRDoHNW7VSpAEj+VVw9SpxivWizluA05sHkAJzVu5XP83RUsZhFtnLdDC/gTOmaT7LSNxSQGzp92bzUCxjvBzptvUo3gKY0QUAzayoZt8EOdqLm64Kpsu+zSWwQg2HGl3IC7HDF9TfqXwSsT5+e5p81Ys/f3IjIK1DDHB/FCKfR+upTIzFiLQtj6V7L348SQ2zOCKqfi9smMfhQDOjSOQvE8WINsnLtd2Hw4yeSuuuH0InpiRJi/e40Ft2AxVVUFr9mnh8aO7DJeMrFwqxFwQRV/yX8Cv5ECpxi2IWA1OVkkJNCJ+Q==;5:qI6Yqe7bnHYDF7QnclmGGOewg1v3fFzygA3HemfQ6UUSrgE1hU25c/ZNROgEgcHORFXHWGKdUKaIU5KlBp/mjVLampR/xrvyPVQvYgXMPPnbwHrficZQbfl1xK/Tn77oL9SVKVz17v9zKAH+4gdlkqGTrg2lkxZ8XFsS4oKR7hA=;7:Ha6vJuvLOCv6WIcCA9wMnlWWng8ZO1W6bH2WbXDVqTB6ArVFY8F/HL3uJF7v45/9jgkF0JfgYJSQqO9/Pqebw0aIZnyvCbOTXfY5L6vd5MaQ1M1HjsWCz/RtvMKHyvYpEdhvp0eAVE5g8JTkHW7/Xw==
x-ms-office365-filtering-correlation-id: 916ea1e0-e331-47aa-9d45-08d6695f1194
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3501;
x-ms-traffictypediagnostic: SN6PR11MB3501:
x-microsoft-antispam-prvs: <SN6PR11MB3501D40EC4CF542F62EA5C44AABB0@SN6PR11MB3501.namprd11.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(908002)(999002)(5005026)(102415395)(6040522)(2401047)(8121501046)(3231475)(944501520)(4983020)(52105112)(93006095)(93001095)(3002001)(10201501046)(6041310)(2016111802025)(20161123564045)(20161123562045)(20161123560045)(20161123558120)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3501;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3501;
x-forefront-prvs: 0896BFCE6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39830400003)(396003)(346002)(376002)(199004)(189003)(6486002)(229853002)(2906002)(14454004)(99936001)(508600001)(97736004)(4001150100001)(86362001)(316002)(110136005)(31696002)(54906003)(2201001)(2501003)(6512007)(3846002)(6436002)(99286004)(8676002)(6116002)(81156014)(68736007)(8936002)(81166006)(78486014)(486006)(11346002)(446003)(476003)(31686004)(2616005)(36756003)(14444005)(256004)(7736002)(7416002)(305945005)(25786009)(5660300001)(71200400001)(71190400001)(106356001)(105586002)(26005)(186003)(76176011)(55236004)(386003)(6506007)(102836004)(52116002)(4326008)(6246003)(53936002)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3501;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TJTGv/ma/7CuTN+Zm8CIRZJjvhiTsGPWQ0wmEypW/VJGtdI8H49LIoinvOIwCpRa7MbH/UZrGMtvRx3ct+WVCS1YH86RJM4zxSxnUQbS6oPxgMCABhiJLWZerTIcXwtlSfcd4aeHo1tFP6/3q+Uk6+i+IK9DUaQcrmEa0THggGyVNnbiyUs3qDUZIIV2HqWLyjt3Nj44ieFhB9wTxZmKL32Wxt1/ftwacvJzLjj//IEFQfJqIiiNy+f+6oBc06pa3I1zWJmMVHTd1M1YMZC0llrEh00d8nMvOcG1KpbzQ7YBu6cl+s8R6T/GfNnWKH17
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050703070806000908000302"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 916ea1e0-e331-47aa-9d45-08d6695f1194
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2018 05:17:16.3203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050703070806000908000302
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-12-22 04:41, Jarkko Sakkinen wrote> +#ifndef=20
_UAPI_ASM_X86_SGX_ERRNO_H
> +#define _UAPI_ASM_X86_SGX_ERRNO_H
> +
> +/**
> + * enum sgx_encls_leaves - return codes for ENCLS, ENCLU and ENCLV
> + * %SGX_SUCCESS:		No error.
> + * %SGX_INVALID_SIG_STRUCT:	SIGSTRUCT contains an invalid value.
> + * %SGX_INVALID_ATTRIBUTE:	Enclave is not attempting to access a resou=
rce
> + *				for which it is not authorized.
> + * %SGX_BLKSTATE:		EPC page is already blocked.

Is it BLSTATE (SDM =C2=A740.1.4) or BLKSTATE (SDM =C2=A740.3)?

--
Jethro Beekman | Fortanix


--------------ms050703070806000908000302
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTIyNDA1MTcwNVowLwYJKoZIhvcNAQkEMSIEIGpE+BlM
mAcOGUW79noVsa5gVk/dT+sOCYVdx6/tPOilMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQCCqKhh6NceERbqzGCkpciXqU1VR1/iR+ck/mAC4ttUAjbt5KjWlOgF8E/8YEDRFr8R3nbi
u2YU7634mi86SOaZnIUFgObjxLIsPhxR3bHoi9vtsfMpWFW8RZTM8G3R/uYy1AODEnDG64vj
HPmQ0XsxgLVtC3h/qsZlXENLk1AIH+7ihBmXhP0oSIKUhUSu7zjmAZRAFa6Qpgr1lP5ONA2j
bytIt+5Z1amYBwYEZqt37JKFXerRrfvejdvYBrcc8w0AuM8ey6/UTocG5kgE9NG6fOUOQ84/
XWgM0fFzfTX+WP6GeOJT1GtI7YFKluqxeapp7s82C2n9+lHLIXvWcV+aAAAAAAAA

--------------ms050703070806000908000302--
