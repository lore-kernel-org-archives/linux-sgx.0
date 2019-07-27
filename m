Return-Path: <SRS0=PICp=VY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2DBC433FF
	for <linux-sgx@archiver.kernel.org>; Sat, 27 Jul 2019 23:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 670412085A
	for <linux-sgx@archiver.kernel.org>; Sat, 27 Jul 2019 23:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="QD7wGhXS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfG0XQH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 27 Jul 2019 19:16:07 -0400
Received: from mail-eopbgr700097.outbound.protection.outlook.com ([40.107.70.97]:43329
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbfG0XQG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 27 Jul 2019 19:16:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvCX6f5boPcyphwZ+yqJAiJUodUbVWvtgmBUNduvcUAIwIyKvm/Plcs2ctw6XYR3HldJRVtl7LdQYdQylAGXTfzM7VFHv4Viid3lsFwfIpHHhlmBdMF1YRN60Ny0UYN+gHsk4Nq0LJJdJ7SnjGVC+ttqGAD2PAzdv/14sQHPktAM+skGhj7BlLBfyRqjfWUNqw4qhL+ynZBcPJfkIKDR/mnprPjQV9cGYYkH0eDLHj95WiOEFRvROaG/+dSPOMiL1gY2WmGIzMiBKnfroTg/NWBIfAgOvv0JlgREBzSw9v4uW7w1njX0yvYb0fyYm7JFSw4L3lbdPXgxIgEdlvXoJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOq2GcB4QkMzGFjmepcIJrONM2GqaY5w5HSTNx8Buuw=;
 b=gFH5fs9Nn6fjhxceDnO6BUsu8Sb1ujCVlUxWldneHGknHVai40U3R0TTbEPCfrZPICbDDBHfu0sTy5ii16rk3lBDtoviziaIIO9LBV8ebDfPhO2h0aEtc1cLswu/Oxaxg4xhOsS2s3M+66U7uRnFqZ6LFJIaWvt6Xtwz+nqV0555Wau8k3BpdS/oIClDErbV6y71IERuoGzHKlUnCDLVNYq5/m/ERStb0FE6YO39b/QleCU3SwHG3xIFce4rRQSZ1f1h/j2G0WHnR0VoazC3k1IxDuI6CiV7fIDFTD9ASDQJtIBuXbtYQYGexsgYwxaQZ4Z6dDsPBjx6ag1eN4LhVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fortanix.com;dmarc=pass action=none
 header.from=fortanix.com;dkim=pass header.d=fortanix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOq2GcB4QkMzGFjmepcIJrONM2GqaY5w5HSTNx8Buuw=;
 b=QD7wGhXSPPI6cGJPwEbCbYZryxjRFtFO/Q0+lFdqCWjE4yNWbHpRB3wHZBg5vOwGAxVOIQq5r8XYU1mM8l2PJoK+StDMlZvMryZXt0QKmhgLzlayRtHSqEAmCOWmRAdpHmMpU06BNjELmQecPX6vk3JfGWYmB8gCL6K2LGen5+4=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3471.namprd11.prod.outlook.com (52.135.112.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Sat, 27 Jul 2019 23:16:02 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::bd32:8938:dba:9379]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::bd32:8938:dba:9379%5]) with mapi id 15.20.2115.005; Sat, 27 Jul 2019
 23:16:02 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Bug in EPC paging
Thread-Topic: Bug in EPC paging
Thread-Index: AQHVRNFB5rEMap7fYk+r6LDMNfzkmg==
Date:   Sat, 27 Jul 2019 23:16:01 +0000
Message-ID: <b1b95c9c-9191-64d4-37f3-7741cbb0c157@fortanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0039.prod.exchangelabs.com (2603:10b6:a03:94::16)
 To SN6PR11MB3167.namprd11.prod.outlook.com (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [216.9.109.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd805d0a-97ba-4a07-f2c6-08d712e86371
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:SN6PR11MB3471;
x-ms-traffictypediagnostic: SN6PR11MB3471:
x-microsoft-antispam-prvs: <SN6PR11MB347123FE4736D6F6757290BAAAC30@SN6PR11MB3471.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01110342A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(346002)(376002)(39830400003)(136003)(366004)(189003)(199004)(316002)(3480700005)(81156014)(81166006)(8676002)(186003)(2906002)(8936002)(26005)(66446008)(386003)(6506007)(2501003)(66946007)(66616009)(66476007)(66556008)(64756008)(102836004)(256004)(305945005)(486006)(66066001)(7736002)(71190400001)(71200400001)(2616005)(476003)(86362001)(68736007)(2351001)(31686004)(6436002)(99936001)(99286004)(31696002)(6486002)(6116002)(508600001)(3846002)(4744005)(5640700003)(6916009)(6306002)(6512007)(25786009)(966005)(5660300002)(36756003)(14454004)(53936002)(52116002)(6606295002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3471;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZBudX3uqkpi9NkzOtMLO3KxS6G5fvesqd/ZkQ247kHAKcCt/OqmUtd7ydhV5n/BKE0SUX5XnMvnt4mghvxy2+Vn2bfwLdDnqDKtjO/FQjA8CtpYQwz83+6CQSDHfE1IYJXHFDJUCqX4ALa6yRwN1AmrxgSOtNooT2052fDZnT9P67KKJJO0j/OqTZnjfGAYyuB71dLJzAXs05yWtPwMoXkZ/28UQpUCcLvGbaoCRvyd/iV9WbYhZH/BkcoVY97qcsZm46EvRYNbS+hr+9YpR9zGLnUnVFD/hi+BE38MnO5BxYU+BMrESm33dAw8fexnlmnZjDHhVK17929nuo3XxH+0Ce5aLuRT8uSG08TsNJkbI4C4LRT4puiDCB7EYjRlHspf8XPhohBTfJbOZGiA1HLDEwzKIEre3d+E04VaSycM=
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080102050608020003090300"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd805d0a-97ba-4a07-f2c6-08d712e86371
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2019 23:16:02.7017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jethro@fortanix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3471
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080102050608020003090300
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

A user is reporting CPU soft lockup with Intel SDK version 2.1 and 2.5=20
driver. This only happens when using SGX in conjunction with DPDK (Data=20
Plane Development Kit) in the same process. The process is running two=20
enclaves that together are bigger than the EPC.

Dmesg output:

2.1 driver:=20
https://github.com/YangZhou1997/dpdk-sgx-crash/blob/master/dmesg-full.log=


2.5 driver:=20
https://github.com/YangZhou1997/dpdk-sgx-crash/blob/master/dmesg-full-2.5=
=2E0.log

Enclave memory layout:=20
https://github.com/YangZhou1997/dpdk-sgx-crash/blob/master/sgxs.info

--=20
Jethro Beekman | Fortanix


--------------ms080102050608020003090300
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDcyNzIzMTU1N1owLwYJKoZIhvcNAQkEMSIEIMo94RFT
1d1zppU7Y5z7SKVq6/w/deh9ZVEH58dR5z8cMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQDMXlFAq06N5VGLoGAiptYnAsHDsbZHIYbDF9Rtaz2Six9EIoj/KG4ZJXvRL94q/GSrGAWE
BOk52XvWi34xTh1A4D8dsOXonnVhMjeCtfmea9MNLwD91SGx172jy7OmWJ9IO3f0cgK6m7V/
s9mxfGLpxwKOIiymG+6IJPIjB9GVuCQE+qoNcqi28YINJVJHqVDeCgwUJjSY9YdnjgXKZcwq
Uo05FfdbOK/8o5KTm0nmDCf8bxQWnrfaWCzCA0nRP53h8IrHvdMJf9k/YEo+SeB7E94wh/lo
419zzecX/zaFHFLtGe+my36L+ftjYtBjBoMKaCiXmt6SgC7t5wlmvopYAAAAAAAA

--------------ms080102050608020003090300--
