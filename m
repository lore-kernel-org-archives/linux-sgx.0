Return-Path: <SRS0=sJTe=OQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_MED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9418C07E85
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 18:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EE932083D
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 18:19:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="Cznl4FW9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EE932083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbeLGSTJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Dec 2018 13:19:09 -0500
Received: from mail-eopbgr800108.outbound.protection.outlook.com ([40.107.80.108]:35280
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726177AbeLGSTI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 7 Dec 2018 13:19:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+4SyXJ2veD7ilRkQxjDHJJjYnPN1a5N2Zvh7aQw9P4=;
 b=Cznl4FW9hHoRN8nNI4JqQRYFzlu86wtoqdiUi+/sCNzBn0dQ0P5b+iHvJNpaqVgnZmsbRtuKnNzv2rqhY+dIqQ8seH01pmsFpqQgUUyHEkURPE3MLDaKuq7skR2dR81/ZEFqTK20nCeTqTIsoxsYnSGFscKAtvgJZz9weDTdCMA=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3279.namprd11.prod.outlook.com (52.135.109.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.17; Fri, 7 Dec 2018 18:19:03 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c%3]) with mapi id 15.20.1382.024; Fri, 7 Dec 2018
 18:19:03 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     "Dr. Greg" <greg@enjellic.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Thread-Topic: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Thread-Index: AQHUjllVdIrv8QEhmk6icaec8mjmDQ==
Date:   Fri, 7 Dec 2018 18:19:03 +0000
Message-ID: <f036e41f-8b93-cab3-07fd-641354e60b35@fortanix.com>
References: <20181206221922.31012-1-sean.j.christopherson@intel.com>
 <20181206221922.31012-5-sean.j.christopherson@intel.com>
 <20181207163127.GA23494@wind.enjellic.com>
In-Reply-To: <20181207163127.GA23494@wind.enjellic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::13) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [171.48.9.28]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3279;6:Abn43FvuXOVNpGZKWnvzD6dyLAtrODW07IgpElOvVV0ia1229UCeD6SLhy1rF75ZEgQy2VJdMbmKMM87X80gwqVpcQS+DV+T3cKtPs3aF8mji/m/gxMOqwIZujLhS24NytViOP9cn8DRV6X6/Zj9ABZwPT9j+USYA64dP10J8Jo5FBa3uSAI4pPQ8Irc2A7jxCynoq2Bo4NvXMf/oJQ0Qj1dWngq436h2i5Va+UOEiHy5j4BBv22PmYN0lNc/0Ilwkw2w0Eaz/3aL1jdrQLrmsAn/kaRyPZTihCQ1sv9ANVfLYjO2oEq1OhudpcUmLSowXK1lgH4YcPICY0+zqGrNCXsfJc3VkP48nB6s1P96VlklQA2NLyLhDPkWP80Lfn2hGaL686+LpnJadLWodubnS0W800UoXfe5pwPlaMErOPnsYaW5PWp5+p2Oj63AOfiEukiTWI3j4L2CIOQglqlQw==;5:GZsI9QTs+cO5eRbJBkwd6ddePMjs0R90ELbAn2oA+oRPoa7RlocMkIHKCYeJDaCugk1CclOx/T0jrofuhtRhXSRRrVFp5LlPr5MKL7hH4lJTcFi7XnPO7NqynT0FHyLVVEpkbFGjFD4GB/0a/LRnobEoSpsUpFvI5jnjZVKTkDA=;7:f+/bk98tMVw4mBa1o1n++BOpznN6tMcv1vy8pPsAN+p7hxyYF0X7r9WZ7CBCZJxqoTG32PHLDK/G5RHiDNGD5iFMpZ530p62aNgm4dxFEOMqG7RL9Z/iE9wwuxTjqrT49PrzCUm+XXz6NLl53UUC9A==
x-ms-office365-filtering-correlation-id: 017e6b92-fd4d-47a8-efa5-08d65c707760
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(7021145)(8989299)(5600074)(711020)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3279;
x-ms-traffictypediagnostic: SN6PR11MB3279:
x-microsoft-antispam-prvs: <SN6PR11MB3279F66FB3D3DC856CF7D7E7AAAA0@SN6PR11MB3279.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(5005006)(8121501046)(3231455)(999002)(944501520)(4983020)(52105112)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123564045)(20161123560045)(20161123558120)(20161123562045)(2016111802025)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3279;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3279;
x-forefront-prvs: 0879599414
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(39830400003)(396003)(136003)(376002)(189003)(199004)(99286004)(76176011)(78486014)(26005)(31686004)(2616005)(2906002)(11346002)(508600001)(486006)(476003)(71200400001)(229853002)(71190400001)(186003)(316002)(217873002)(102836004)(386003)(110136005)(6506007)(53546011)(52116002)(14454004)(81156014)(81166006)(54906003)(8676002)(8936002)(5660300001)(36756003)(31696002)(4326008)(97736004)(86362001)(7736002)(305945005)(6512007)(256004)(6246003)(106356001)(7416002)(53936002)(6486002)(25786009)(99936001)(6436002)(68736007)(446003)(66066001)(6116002)(3846002)(105586002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3279;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: YgtxTOqrfqxjOPhYCJgxa+rDSZnvM9JaZ77vw/RUHNustBseSu8mkbGzUvr6c6s9ZCIdro4H5nkbzRkP93G9QNf+NV79hVY4zf/Qo8slKMYmNVcLrn00DT1sm8zMMt8/Y2udC/pszEQPbTEXvHCkMXehfo6nJn2UfoVsnjRlt5XYW+/V0qWHi1w70Ke1RpNuoyFDaMMlSQCPZtYdEw0gus+nySiLUp3JVZ1TdDl1NmlaaKey4njyW1Y/RVGprMtKRBQKleAwwycojdQGZAOTwtAyFJKEknLMfx+XOo55QqB/O8x9PfvnwgQN6VDR1JiyhXhM/QICxCyq9JfTqdeaEM6tg5iJ3FZx4jTQYQckRRE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050001030904030700010801"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 017e6b92-fd4d-47a8-efa5-08d65c707760
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2018 18:19:03.1620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3279
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050001030904030700010801
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-12-07 22:01, Dr. Greg wrote:
> Baidu and Fortanix are working on Trusted RunTime Systems (TRTS) based
> on RUST, I believe, so this will affect them to the extent that they
> are implementing their own low level enclave runtime support or they
> may be simply building on top of the low level Intel TRTS.  Perhaps
> Jethro would comment on these issues if he could.

As far as I know, Baidu merely provides Rust bindings to the Intel SDK.=20
As far as our requirements, I've sent those in my previous email.

> I'm assuming that in the proposed model the URTS would interrogate the
> VDSO to determine the availability of entry and exception handling
> support and then setup the appropriate infrastructure and exit
> handler?  VDSO's are typically the domain of the system library.
> Given the nature of SGX I couldn't even conceive of Glibc offering
> support and, if it was acceptable to provide support, the potential
> timeframe that would be involved in seeing deployment in the field.
>=20
> As a result, do you anticipate the need for a 'flag day' with respect
> to URTS/PSW/SDK support for all of this?

It is my understanding that the use of the vDSO enclave entry will be=20
optional. i.e., if your application/library/enclave combination installs =

a signal handler and calls ENCLU directly, that would still work. Of=20
course, using the vDSO will be very strongly recommended.

--
Jethro Beekman | Fortanix


--------------ms050001030904030700010801
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTIwNzE4MTg0OVowLwYJKoZIhvcNAQkEMSIEIGqmSq8L
kzAHpywIRdgFG7oJkKHJF1n6YTVK2TT8kfijMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQAjVfpi5AlmZpy5csAEvxy9WaqfDsBeMPqdAMf5pCHm9A0D9++OFAKdh7XJLwyNSAQKyRFx
UdLzO6tFShDQ3BqZ9l0kGrP5zj4edv9uXh/+W//J+mKW69mbcJPSau6tLauZ/8aQBL7W1sbq
oHUWEpH7F52mMWdzYRhcBPina5gflRbJ+V+jg3WMTByhwGHB3WOzMl75fqdK7R7/YRBH5wJM
Hb03UKHFoOIqBSzSbDjQMrPgM1SwWJQBPQUHsHXXQKGBu5KE3tKLJqNzxDTEc/A5qXoQ6UEh
enIIBOPXaOL4xehzu17sWA7b0a2Zr9jq2iXZRvtqc8dgAeEqt/X+GqyKAAAAAAAA

--------------ms050001030904030700010801--
