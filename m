Return-Path: <SRS0=SAws=OH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060E4C43441
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Nov 2018 05:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 809F62081B
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Nov 2018 05:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="NT9Fj9q5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 809F62081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbeK1Qis (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 28 Nov 2018 11:38:48 -0500
Received: from mail-eopbgr800095.outbound.protection.outlook.com ([40.107.80.95]:21283
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726972AbeK1Qis (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 28 Nov 2018 11:38:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzBzsIIB8+UvPcj8GP9I9e4d3kbXyjMhfGbkENryiqY=;
 b=NT9Fj9q5lN4DjaWHhbqrhgGbp/9mHnXFtQi5QZaOM+k9HABherm+DlTjLUyQt/SVk+GFVxhlPI5h95zsCdI2n/6swpABljiIblM9ldYfn7MfNQqJ7kHTH45fJ2wj4LAB7v34C/RsEUURz2gh1wUIfGcVjxXeHBz/zBQXxuZK6oQ=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3152.namprd11.prod.outlook.com (52.135.127.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.18; Wed, 28 Nov 2018 05:38:16 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c%2]) with mapi id 15.20.1361.019; Wed, 28 Nov 2018
 05:38:16 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Dr. Greg" <greg@enjellic.com>
CC:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "mark.shanahan@intel.com" <mark.shanahan@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Thread-Topic: [PATCH v17 18/23] platform/x86: Intel SGX driver
Thread-Index: AQHUfUjfX0aB3m959EWZdPqQBfyo6KVXPryAgAAN74CAAAs1AIABP/4AgAMWMICAAKMHgIAA5fGAgAH4pQCABYZ+AIAACFSA
Date:   Wed, 28 Nov 2018 05:38:16 +0000
Message-ID: <d0761c34-483c-3ffe-712a-7cd7510aa954@fortanix.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
 <20181119161917.GF13298@linux.intel.com>
 <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
 <20181120120442.GA22172@linux.intel.com>
 <20181122111253.GA31150@wind.enjellic.com>
 <CALCETrV4wOpk7wf9+ywd50PekGjfT7LNtwqHhcV08=oxPmKtKQ@mail.gmail.com>
 <20181123103923.GA13851@wind.enjellic.com>
 <20181124164534.GC30310@linux.intel.com>
 <20181128050814.GA8842@linux.intel.com>
In-Reply-To: <20181128050814.GA8842@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR01CA0114.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::18) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [14.143.179.162]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3152;6:CxWt46bxxZyTtZuBtMvpg4/y0w9jd3M9bS3btEX+trjAViw07/K4x1CSbNtOhw6KReLaiRrfM6E+KwlqSPEhbHDp+fxwKFCERaXnqNXAB/XzQEbvNEI7CJBSXZGQwFFRsc2uHEN3JSzHlMKCuhK8r38EmgGH9K4dOBBj8kojXBABViIPRchGEARLerbelrzoNlP3Qf5li3Prc8EixYZPzCmhqapAgV9rCkqA8wtHCdKXkX2c+sgWyBgE6fVDPE05VoQLGam76Gp2KWjAYKd9yt3f43S7hyKFcS6PzeuO8h44qp0/OLtb1UE4XrG6Q7saEEyXm43qFFQXQ1IOaUuc4R3GyE9waMUE0MoV/aX3a4evzf02iFqjtfDDMqal73ohyc7m3DUBS7mC8S+diEq+72NBgXvZFmGu/V8aeGvLK4Pe+DODV0rvbywqP8wjqyI7vect5s8E3I0l5JpIISx1Gg==;5:AZic6fK/4dNpmBUDprRK9bTmsLapBMfskdm1wcwWiQW/dEyVipEoUOCHRumfeYSf8EI61u5gNUl2de13XcDfL1BHU/bvmDsd8UsU5G/IT4s9estxviqQH2aFZNmgJX71IAR0vRIjGOAaWxb34eG35eKbEwFKKTzVfHf2hUozMW4=;7:hZvLp19NzqOe6wtQ4OsQH4fiNUMYBmGv0P6OzM3h3TapwCDqF8H44qVWWdcd1j2sakSYdwetWs3PggXdIs0qahRBvr4wHRu/8IBWkzF4q4D1xLN+hTTtCAFFmNaqipD8HOL2BkaB7TwHPtZCe85pQg==
x-ms-office365-filtering-correlation-id: 3e5965ca-e478-4a77-95a7-08d654f3b21f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(7021145)(8989299)(5600074)(711020)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3152;
x-ms-traffictypediagnostic: SN6PR11MB3152:
x-microsoft-antispam-prvs: <SN6PR11MB3152C7F6E74EA589674C12E3AAD10@SN6PR11MB3152.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231443)(944501410)(4983020)(52105112)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123558120)(2016111802025)(20161123560045)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3152;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3152;
x-forefront-prvs: 0870212862
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39830400003)(136003)(366004)(346002)(376002)(396003)(199004)(189003)(31686004)(4001150100001)(52116002)(6246003)(2616005)(316002)(4326008)(97736004)(54906003)(476003)(110136005)(31696002)(25786009)(5660300001)(99936001)(11346002)(6436002)(229853002)(486006)(105586002)(14454004)(446003)(66066001)(6116002)(78486014)(3846002)(8936002)(106356001)(93886005)(6486002)(2906002)(6512007)(81156014)(81166006)(99286004)(305945005)(7416002)(36756003)(8676002)(68736007)(186003)(386003)(6506007)(55236004)(26005)(102836004)(53936002)(7736002)(256004)(76176011)(508600001)(86362001)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3152;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: h3D8J3todttU47qBQKyWfd4pENj2ab1R2j8mQ6qsio+31wloCgUL+8ywulD4wvZx326z+COD142WBBTDBKIKLWSe0Og5BjyaMG+mUbaPlMIQ5lmC02R8fLHzL7vpt+ZJhvA73bLPZVvebMvSJ4ZjcV0GI2/VSR8cdarF5LkymM1IRyHOvnI+rMAIx8H4zQGC3Kn5mMg2Nwtk5sGJlpqFz/NZw31vkX/3/sFti32dfpQtK9fp+rIn5GvulbWWZ2bAyGYAZufOQ/AqM6CsYAOPIgv8HiUhbEX5sDmomjMKBHyudNhFQONg2cb9zOsVl5zkDMcBHcuXxnGZL5fqMm70GX1JRWycTVwFUs1b/sXYM/k=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010309090804000201050205"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e5965ca-e478-4a77-95a7-08d654f3b21f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2018 05:38:16.6079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3152
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms010309090804000201050205
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

  2018-11-28 10:38, Jarkko Sakkinen wrote:
> On Sat, Nov 24, 2018 at 08:45:34AM -0800, Jarkko Sakkinen wrote:
>> On Fri, Nov 23, 2018 at 04:39:23AM -0600, Dr. Greg wrote:
>>> Jarkko, when this driver lands it will set the SGX ABI in stone for
>>> Linux.  It would be very, very helpful to the development community i=
f
>>> there was some official guidance from Intel on whether or not FLC wil=
l
>>> be a universal feature on all hardware and the date that is going to
>>> happen or has happened.
>>
>> I seriously don't know but I can take this message to the mothership..=
=2E
>=20
> LC enabling is essentially a platform vendors choice, not Intels choice=
,
> like many other CPU features that Linux is dependent on. Of course, if
> Linux ends supporting only LC that will without doubt have a big impact=

> on vendors so in that way it is indirectly also communitys choice.
>=20
> /Jarkko
>=20

Jarkko, it would be good if Intel at least documented FLC and=20
recommended a particular practice in the SGX BIOS Writer's guide, in a=20
similar way to how the software control interface is documented.

--
Jethro Beekman | Fortanix


--------------ms010309090804000201050205
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTEyODA1MzgwM1owLwYJKoZIhvcNAQkEMSIEIFLwe96U
hmi9Fc+LwOPzpFmh6GX/AiVJlRLrrK+q3JAVMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQBl/Fj44xepT/5cNE+2D3leA7A2lnKwFFBnmTnQP15Vp9kJb9sCwbKZObVEgWZsFwymWvgt
+9XBH/JAIAFDrqiZ9qQQv5i0dnWfq1LGSeC1oAbrGii3uq9QJ96f6d7HTlhRZ0DQwsZgYtsW
7USlX0PNu16+6FUDuf8nT1l7jHbmq0Sn1Su6aFufPeO3o1PTTCoCIZHe+Lk0l+KPIe8QvF9P
pcajp4Jfr2LbkuELJqF73snc8faSozknk2+rtI8o+w1a/oAA5amwsDooNwmyOz8KQyVdrY+A
Zr+Llz+gnSHK/RgoPn6VUqLK0WUh2HhSXRd5n9tkPMK7vK4W51VBANVMAAAAAAAA

--------------ms010309090804000201050205--
