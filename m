Return-Path: <SRS0=SeXc=WG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DE9C31E40
	for <linux-sgx@archiver.kernel.org>; Sat, 10 Aug 2019 00:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9782F2166E
	for <linux-sgx@archiver.kernel.org>; Sat, 10 Aug 2019 00:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfHJAj7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 20:39:59 -0400
Received: from mail-eopbgr740115.outbound.protection.outlook.com ([40.107.74.115]:58876
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726219AbfHJAj7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 20:39:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4enOoU1ycCh1sTu+4XGEyIRT9yzYeAxpmRwgbSrWW05uk3blQUVFuW9yKwqkO4cLHyipFakoYiYBUmQvjlVSy0f/qs32ftsOB1tHZWTkWGUFO4l6NE+AqA4jR3GVx6tCJX40dNdUrmc3XdCOTjV4wypGUAx/ciFp+T05i+flPethA9Sbj0q1sZFbb0WbvUtatjM/F3qG+TDTUyKjrMWAQ4+B4Z4YB6mTgz45PDkVV5CgmKavZGN7dkJGHEYUuKcQSrH2Zs+BOPQF6w4fUeUnCAu0Nh2Cv8LvtWntffeYUz48s665EvKNSJSexNb5qT/iqrpZXSJa5+u+8zg9YzhnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7y5MEk4+fXradARNL9dEQ2yMhbuIVsImCVJL7ynMlDo=;
 b=nDZ0Go65mp/JHoQIlU+SdF4w26pEOXUigthCdhWaRUGurLAcsQpRRyKxZkzjEoDP570OrxJwkaUWnb2jQ3qQvXbzwMRlf4AnP46fXFnzeiI0ISFXSBeurjDaRxPtKApc2qGKssn4m11MLfsaPtSLy7Qed54vIos/Sm/PokfIhjJjSvNl9bFUk+WNOn1CeSIKbBZKRWd48wULmZRjobERkUyRzqJjB8Pb92OMYcHjFq7FoFA4/1ewP2i3ovtloNK7bs0TxXPFixis1LYc4orIYzf59RgfnD0jeYQeN+mTf1rayBjuzB/T7459AwAy/rwt/OClxfvLm6cbiiAGORJPYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7y5MEk4+fXradARNL9dEQ2yMhbuIVsImCVJL7ynMlDo=;
 b=il912Nnz6d3JxNR7VfHj6auj+lBiQqkDrjv0saHXLuG+c4pMx8LXL/nsGU+snMxer45mHK5HC+RNPmaKW6ZMP36TleKXX1CptCPkH3OssMMjR/emNLTw/FLPJCytPSPVbR9aI6I+6qf155xwhJ9PjF3c/jGWj+kjHM2lyJrp/0Y=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3455.namprd11.prod.outlook.com (52.135.111.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Sat, 10 Aug 2019 00:39:54 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::bd32:8938:dba:9379]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::bd32:8938:dba:9379%5]) with mapi id 15.20.2157.021; Sat, 10 Aug 2019
 00:39:54 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: [PATCH for_v22] selftests/x86/sgx: Ensure SECS base (ELRANGE) is
 naturally aligned
Thread-Topic: [PATCH for_v22] selftests/x86/sgx: Ensure SECS base (ELRANGE) is
 naturally aligned
Thread-Index: AQHVTxLfGdozGX/K6ECrRqvMyY54sabziheA
Date:   Sat, 10 Aug 2019 00:39:54 +0000
Message-ID: <d38b3d14-a30d-88b0-ac60-a71d4577ca16@fortanix.com>
References: <20190810003051.15712-1-sean.j.christopherson@intel.com>
In-Reply-To: <20190810003051.15712-1-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0100.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::41) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.58.38.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 848dd2ea-31b6-4f8b-cb8f-08d71d2b434d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(49563074)(7193020);SRVR:SN6PR11MB3455;
x-ms-traffictypediagnostic: SN6PR11MB3455:
x-microsoft-antispam-prvs: <SN6PR11MB345587DC1974A0CE83D399DFAAD10@SN6PR11MB3455.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 012570D5A0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(376002)(39830400003)(136003)(199004)(189003)(102836004)(52116002)(66556008)(2616005)(11346002)(66616009)(66476007)(476003)(66946007)(386003)(66446008)(31686004)(64756008)(486006)(446003)(71200400001)(71190400001)(66066001)(26005)(76176011)(86362001)(186003)(508600001)(25786009)(6506007)(229853002)(53546011)(6436002)(14454004)(99936001)(31696002)(6486002)(256004)(8936002)(6246003)(3846002)(8676002)(6116002)(6512007)(81156014)(81166006)(53936002)(2906002)(305945005)(558084003)(7736002)(99286004)(4326008)(5660300002)(36756003)(316002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3455;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 18zL0u4vPAZ78Q8LANwgcqxu3u6q3leZBplHUjd6t2ojWrpqAXNWKg7JPR/kzj9eLyYXOlhPTdxjzMJRu66y23xsEMH9+2Pk1ieu1ARO5KCNP623SgpA2yQRevKo6ScsvPVgVJfENOSKR74+INcgYgDkwZ6tqihNcH3dJwNnjFIwYVFGG3JZ4hocQh3j3K+a15NyT+4F/eZY4ujo3Z6EZxnzVuPRnzcsuYioIebII7hU5B/q+rSsRoQoA7V0Aos2RQ8J1zBh17qUkP5Bfp42HGn9eeiC+WOHi3XTA+CEvCFTRvUTNlx4ZZYFgWOOwOxhWkY7PdVujePtBSGd8L8whq5ByOvJ5+mKMbQ8rQWJWvLj+3hxW344KhZ1X+xKyMhwDfgGVaRvvgL4YvNlEkmPV99uc7kryd2lRQ5RhMna6K4=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080707000909010006060302"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 848dd2ea-31b6-4f8b-cb8f-08d71d2b434d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2019 00:39:54.7954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iiXC5PrRNSdqPJQxNM+P7Y9SZVPOWmtLifSc9MuVhBYer7Gf4M5og6YzobYHfB7HqX/qKO7pqOmeUvDA1Oxjxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3455
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080707000909010006060302
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-08-09 17:30, Sean Christopherson wrote:
> Manually align ELRANGE now that the kernel doesn't automatically do so
> for SGX mappings.

What was the rationale for moving this out of the kernel? Now every user =

of this API needs to implement it manually.

--
Jethro Beekman | Fortanix


--------------ms080707000909010006060302
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDgxMDAwMzk1MVowLwYJKoZIhvcNAQkEMSIEIOW9v9Gh
CztEqiCnkQEX+54KSa3s6uWZNgWyro39CDtHMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQBCbD9nE400wAa4jpK07gQu+N2qc/SeM7We0iKozata18XJzEyNH/Jv8UesslXeCMVwpdEn
dl5KVepapJpMN0pu8W93UDxWJTVfRhMxdE1WNsrgrjf9JkXwpJ+/x6a76j66SYC72OCHoCIW
eAi5rofep6g6p5WGNy4WNAFjfgDg2P7kqxNkdu3VFarDffYnONjunxe88u9IGXpsDhpbzHP6
U0ZineGvjaB0FF98vTqKwG0s3KeIDkxLgHtSQiOA2oaAX98XAYM3rMOlDSpLmk7NJB4P+508
ob3y7H7+KDImNO96SBWpfCCXHcOOcWSq8HDRUwP/V6c2majRtbhQtGuoAAAAAAAA

--------------ms080707000909010006060302--
