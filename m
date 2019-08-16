Return-Path: <SRS0=vX2d=WM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19785C3A59C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 15:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE7FB206C2
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 15:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="rknlPWQR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfHPPgP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Aug 2019 11:36:15 -0400
Received: from mail-eopbgr750125.outbound.protection.outlook.com ([40.107.75.125]:38018
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727359AbfHPPgP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Aug 2019 11:36:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LY3OnfMMBL7XpQqmaGcOZXfS6V4o8FDYjz3PkTlhevyVqpm/RhbtiOHmuW3XoOHOuK6MrumWYjZbMJ5OWUQjk1Uxp/WaQDYrhFSo15SLa/nYhTbZ36+Zjqg/9X7zQ0OFWy/nLgLiVFUqyoBoVgUZ54iASTUCpf4/4riV/L7z1A42EYiozafuVpYp1/iKSngCx8GM4mYwmNz5lN8DUMuWTABT7oAB16zvEi7ZcQvTZhmTSTjKDY58CFok8x3dkuwH3TOh+M+k/sulL9bPSqgVcc0zqdOBgalY3lvtYTIvxib4bXOKw4X3IcOIKvBbC/SZjPe0LtpKApgFPt5qt3PCEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMskY8tK/bbwuZ3keRjsm1XUmn6rL2Fh/aRmtK6kwX0=;
 b=IaViYPRx6+jaq2bOXNSTPOsYP+uwU2gBP+Wa9hHWdW8N4LDu34DuvIzO1L0zZ/37zEfPHMZ0vfVep8ZxrMu9Y5bte3Ot/gupl6aot6KflVyBEBh1jDnFT7Fd37JGbmJkG2C0v9wbe2eG7NlHNRwVc59iv/u33VMy0boxioC7v2nWmB7ou1dFXOZoRvtwq/WEsdak8bGUjH0dxcjmQA2uftZ7lN1o1aqoG7qeaM2axkImaJAf7hj+9Y+yqOFGdkybvx+R8ljVIUyj7574OUdfN5Zuwq53a8r+jzYrb3sasWTVC74QsbJsui7NemlCSAEvyR7saKXdrBQ6J8LLK/5Knw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMskY8tK/bbwuZ3keRjsm1XUmn6rL2Fh/aRmtK6kwX0=;
 b=rknlPWQR4yXtFj9FT3TJ4oZ2mXzmhz+fONNoGT/8cozWNkdxxitPqjH94a1377GOuOtkBvk8lpFl3xftxPvQyQNxFdjaOzdn8t41tWxtDVgVQa3dlaFgZdafrpI3AWazzLWYJcYlMaJokme9Q9+x2Qsa/vPO2qstkxgF3LCkB5I=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2912.namprd11.prod.outlook.com (52.135.123.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 16 Aug 2019 15:36:11 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::bd32:8938:dba:9379]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::bd32:8938:dba:9379%5]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 15:36:11 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 v2 1/8] selftests/x86/sgx: Align enclave binary on
 4k boundary
Thread-Topic: [PATCH for_v22 v2 1/8] selftests/x86/sgx: Align enclave binary
 on 4k boundary
Thread-Index: AQHVUXQ+vwokkMKBGUq7FhJGq/23qqb90Y+AgAAcPAA=
Date:   Fri, 16 Aug 2019 15:36:11 +0000
Message-ID: <a340b65e-917f-3230-49ea-c630c5af509b@fortanix.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
 <20190813011252.4121-2-sean.j.christopherson@intel.com>
 <20190816135421.6kbbt4zeiaijm3uk@linux.intel.com>
In-Reply-To: <20190816135421.6kbbt4zeiaijm3uk@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR02CA0052.namprd02.prod.outlook.com
 (2603:10b6:207:3d::29) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.58.46.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89f488ac-a7de-43e3-9103-08d7225f7740
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:SN6PR11MB2912;
x-ms-traffictypediagnostic: SN6PR11MB2912:
x-microsoft-antispam-prvs: <SN6PR11MB29125BC2FA7C88607EB9FAB7AAAF0@SN6PR11MB2912.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39830400003)(396003)(346002)(376002)(366004)(136003)(199004)(189003)(81156014)(110136005)(81166006)(66066001)(71200400001)(71190400001)(8676002)(5660300002)(316002)(446003)(52116002)(31686004)(6506007)(386003)(76176011)(186003)(99286004)(53546011)(54906003)(11346002)(26005)(3846002)(8936002)(6116002)(2616005)(6512007)(476003)(2906002)(486006)(36756003)(66616009)(7736002)(6486002)(4326008)(102836004)(25786009)(305945005)(229853002)(6246003)(66476007)(6436002)(66556008)(31696002)(64756008)(66446008)(53936002)(86362001)(99936001)(4744005)(256004)(14454004)(66946007)(508600001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2912;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tD2UGa104NoFA3U8DD6sOHpsg8JH3ik5al4RRfflxv3lE8QwzayrQ7tXYO70NhyhWvSYuvcvB+pjJYLUfWzmlz4t7jjt+JfwYaKvyG1dykvPgx+I8Uvdw5Um5Ln+gILn0IqWiCl8MMo+e+GVmgGwn84IUPJj9MUcHRmu35MAmtop2+mhgUjL3suF5g9Q6cw1naOB1/NJRz+O89QWXkNoRLRD8FFF7FzmHeOZ/aXZnOPjDItsZdWY/aUzc4eJoxGKiVsm8pw2Pw4WzemgV8mOppxiPEfqvrGLOpCTqkcRvZFALDGMtSXfjMAsQSMln/dyNLqaWvq+hNAjhnbD9LwyHwY1K9OBAda9wQ8NPQj7OSci1S59iPoe8TMGQK5BhIME/fBm2Pm5J6OtQi2Spyxp5+ZKRDynYpFLZuEDtdL4xNw=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060500030209030309030104"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f488ac-a7de-43e3-9103-08d7225f7740
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 15:36:11.6840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Z+hHsxOaofOYemaMHpoXfr9haB8l+cMEJQpioTYjy3eJ9wuJiUNwyM1mkuO/+aiVfc3dYZnKehghf56+l7qKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2912
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms060500030209030309030104
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-08-16 06:55, Jarkko Sakkinen wrote:
> Requirement is too way strong vocabulary here. Whether it should be req=
uired
> or there should fast and slow paths is debatable.

After userspace has gone through all the trouble to map an enclave using =

the new API, aligning the input to this ioctl seems like a minor=20
inconvenience.

--
Jethro Beekman | Fortanix


--------------ms060500030209030309030104
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDgxNjE1MzYyMFowLwYJKoZIhvcNAQkEMSIEINaWRk4h
MrhnB85Fz0t2MBYvx4MhajulkExN047si5hfMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQCMPtaaUIU34mZj3NTqK6MQRVR7J1H9Hq59yYlWlf8cKstqB0pJ1E5KCf+lmwjCPkuDEsx+
lSs2m20zLwYmu8VoW2r+KwzGc4QmTFVs9VbzgXxdmUgetUSZE3rDXM8O6E9ZNqRdu1ujps5t
liDrGuKck/eZE6+7AitkrzoDAc1spEgyCnahIzfZlsGdpzPyqVgzGV1nldgHDJpSCBpraYOT
vZE+A0GcRaewZk28jdECasqYWkH9QeIWucAkxpzpp7qq88sfhZynGZPP5RW+MZl+rpuxCkIR
f09Es0fgbqMkiCjQgkgePoLC3Q0llBZ7UO98wjJI+ReeAyKIDpOfueQOAAAAAAAA

--------------ms060500030209030309030104--
