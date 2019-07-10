Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB955C74A21
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 16:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A078120844
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 16:08:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="jiKzGSsP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfGJQIe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Jul 2019 12:08:34 -0400
Received: from mail-eopbgr810090.outbound.protection.outlook.com ([40.107.81.90]:13309
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727325AbfGJQIe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Jul 2019 12:08:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4qS0RNXPpnZq3ksWES2BF9CfH7QrpW6LMX+xGLekQ4=;
 b=jiKzGSsPNPjvi1pd5Mzh2A2cn+OZsOVWPrXw6sQVkuCr/Ty30rzzrgjwD50cylFucG2fAXFWvuq4EFb4gn2iVHB4QUittw6Ze9s+3FJcQADbYSrGtyUsa6x+/9iNowCRTvh76phplQLe92mtSV2CB7Qu596aJNQaFSRaP63peN4=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2558.namprd11.prod.outlook.com (52.135.91.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 10 Jul 2019 16:08:28 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::59f4:16ea:3382:f48c]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::59f4:16ea:3382:f48c%7]) with mapi id 15.20.2052.019; Wed, 10 Jul 2019
 16:08:28 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Cedric Xing <cedric.xing@intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>
Subject: Re: [RFC PATCH v3 4/4] x86/sgx: Implement SGX specific hooks in
 SELinux
Thread-Topic: [RFC PATCH v3 4/4] x86/sgx: Implement SGX specific hooks in
 SELinux
Thread-Index: AQHVNR2UgZ8LFd/uPEifvJhBkuuqGqbEA9GAgAAFW4A=
Date:   Wed, 10 Jul 2019 16:08:27 +0000
Message-ID: <d6506d52-2da6-7667-aae4-e3eef7596e93@fortanix.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <cover.1562542383.git.cedric.xing@intel.com>
 <3a9efc8d3c27490dbcfe802ce3facddd62f47872.1562542383.git.cedric.xing@intel.com>
 <20190710154915.GA4331@linux.intel.com>
In-Reply-To: <20190710154915.GA4331@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:a03:100::15) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 198a73a9-a755-4def-ee97-08d70550d80a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:SN6PR11MB2558;
x-ms-traffictypediagnostic: SN6PR11MB2558:
x-microsoft-antispam-prvs: <SN6PR11MB25584C8D4B17BB380889528FAAF00@SN6PR11MB2558.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39830400003)(396003)(376002)(366004)(199004)(189003)(486006)(110136005)(316002)(54906003)(11346002)(6486002)(53936002)(6436002)(71190400001)(7736002)(3846002)(66446008)(6246003)(6512007)(71200400001)(66476007)(66616009)(305945005)(64756008)(2616005)(476003)(6116002)(99936001)(446003)(66946007)(8936002)(14454004)(86362001)(36756003)(256004)(76176011)(14444005)(229853002)(31696002)(2906002)(31686004)(53546011)(386003)(25786009)(508600001)(4326008)(5660300002)(52116002)(4744005)(102836004)(26005)(186003)(68736007)(8676002)(66066001)(66556008)(81166006)(81156014)(99286004)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2558;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: E776aVeb771P76OKi3lkeBJEJ4ih48EnHzBI/jY9flD3l2wKy2rXh87+0+j/paXzzCEVZ3ZVpX3GP+44xz3EkZKknWRt6DAvGSVRO8YuYy9LSOJ6EuH2Hkm0sMJboSAncdfGyC/1kA1P9gHc5zMwwSmvfkjocNuktK4bT3lWGuqFYd/3fVTAaeWRwWi1wzxdvZn/jIsOnZ8G5w66LCFOi7aObc9scm01lYNUwCphpXJoB6FDTB8DrUW4PP8krzd4G5n7rlFy06HD2Sl7oOaJ2t09fnacQBTsjCZJuBTtVoXvCh8wTXqLdsObTSmR+ZS93p9qo8izRKiJf47K2nta4bRDmAthO4NyJyiRv3KiZvvLNkqfTyN1vAVEZETbikzXTFwIAHH2o4sEd1wcjY1bVLnYjsAVRZ8GTTFLeWn5YYo=
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020804060803030900010505"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 198a73a9-a755-4def-ee97-08d70550d80a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 16:08:27.8081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jethro@fortanix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2558
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020804060803030900010505
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-07-10 08:49, Sean Christopherson wrote:
> On Sun, Jul 07, 2019 at 04:41:34PM -0700, Cedric Xing wrote:
>> selinux_enclave_init() determines if an enclave is allowed to launch, =
using the
>> criteria described earlier. This implementation does NOT accept SIGSTR=
UCT in
>> anonymous memory. The backing file is also cached in struct
>> file_security_struct and will serve as the base for decisions for anon=
ymous
>> pages.
>=20
> Did we ever reach a consensus on whether sigstruct must reside in a fil=
e?

This would be inconvenient for me, but I guess I can create a memfd?

--
Jethro Beekman | Fortanix


--------------ms020804060803030900010505
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDcxMDE2MDgyNVowLwYJKoZIhvcNAQkEMSIEIFNmBwWd
26EeDIy5PeIhAF0UtsslkIyS+3HuQ/BeP6NCMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQAycmaE5ipsfzjES4y9cOMk3NRAOkJpbJS6XjjCVjgC28m0IRNrj35xiFDJqkJkAh/62Pvu
7nWruXo8UcbjW/TzM5VjPcXqRwa2JUGyiIIr1OAOoGMXpfFX6rXdOEQwknafmm1kVJqdnb8Q
0eQa6XO0iQlmUC14i4Tby/Kko7LIs5XCXm9WO01e4h1Q8S1Zxg9Q7M+mhmqvzf6I+X0PE8ya
MPvYOrHISFhq5CGXIvtB7QFQuLhPKfEoyDZQnfxFtiLyoF8Glg/vDA3lO9H+DxPBNx8TwG0n
TqetvEwdg2nBvwlwiD9NC2pSVY7taBB/7bJ5Iu8urdSBY29W/o3DjOF8AAAAAAAA

--------------ms020804060803030900010505--
