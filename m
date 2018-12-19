Return-Path: <SRS0=HOZE=O4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8244C43387
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 09:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E16921850
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 09:36:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="UMBf9qLR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbeLSJgZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Dec 2018 04:36:25 -0500
Received: from mail-eopbgr780124.outbound.protection.outlook.com ([40.107.78.124]:59552
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbeLSJgY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Dec 2018 04:36:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNh5hPNbxc9PMQqBJKL4AHtNEt5VbueO/0pcrq15A8o=;
 b=UMBf9qLR32DE1mwLJlFy1ZI9syQE2EuC2PQ+z4z5l75Cz4sFA7H0/NSScf5YTqN3nxS5tnxV/dVjPLSJ67b1wZ1IarvOf6hHMo73HQ9pwXTITbTS9b4u95nNmkB+2CT/BU7073pn/IJhpqA4lWz2nXf8RqYyt8v08sAtW/R/bR4=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3327.namprd11.prod.outlook.com (52.135.111.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1425.22; Wed, 19 Dec 2018 09:36:16 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c%3]) with mapi id 15.20.1425.024; Wed, 19 Dec 2018
 09:36:16 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: x86/sgx: uapi change proposal
Thread-Topic: x86/sgx: uapi change proposal
Thread-Index: AQHUl3Co+wqDa0VeJE+ysGhRrrse2aWFvkEAgAAImwCAAAbGgA==
Date:   Wed, 19 Dec 2018 09:36:16 +0000
Message-ID: <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
In-Reply-To: <20181219091148.GA5121@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR06CA0180.apcprd06.prod.outlook.com
 (2603:1096:1:1e::34) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [14.143.179.162]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3327;6:2c/0cQrqCn39rrmuOQuOjeH1N38Lcy1h1WU8GZ13bcJKbC436Xd22/X2iKd+f9SgqhKQllVeO9kcQJXxwI5hRgSrXil4fII7K/dRLZEJKDwWJ/w/4bl8JIgwIlzb5847ktw0HT0YpKaLDYE3pH3cADcuAmLToNOQ9c5iOrqXn1Hfy0MaNO2gM/lCazpAjoYnjYRn105fDUXLINHXr7aE8VTyFOBNv5IDAS4pvfo9A/GiKrPmyzNfFcWUnaH3RfY4POgJndPUGxReegISDt2oiy/CTgDLWcPTbmgQ1cxfFWIYxOO4fzNp0BlGgF/Kt1WRHIbTJ2cd+WKiyeou83V0KaQbhx2lTh79AFUqxrPgRvhBNaBn6c3NqAHajb8IHKhbi1Z4nMCoCmtUOiel7xhXGMoqaGX53+AJUSepBU1L26dv2Qnyg3W7txWPHbaH0bbsMSzajHmzmF666FH9Wka4nA==;5:uHTupk09Ry4QHOieQ5S7dC1aqEAzEE102CnwXJf2xUcOMEfKEU/k31aOpDUCLMjQSg3fj88rtv/BgOxByXrzAOywZ5c70zPbCo4crHt/BFAJzrMwWThR1faflGXhGum33QjzadWvqofe9cVgX69eneXhFJvd8x6ZOUjfgR0xziQ=;7:5x4FpI+grStJsAQ23ZEiJFw1azXa799s7T591v9hcZI7kjtGavYUPLly8qKOSfvz+GHyDnmU2ftsJWQrwXBiE8K6m9FxYjsxufex4XNZJ1/wftpIi0ZvOGEXi9lZmxEhfBPnjuIEsGCsHZZQfmAo+A==
x-ms-office365-filtering-correlation-id: a99f6b5e-8d1c-4091-a07f-08d665956c10
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3327;
x-ms-traffictypediagnostic: SN6PR11MB3327:
x-microsoft-antispam-prvs: <SN6PR11MB332713FF773A8EA5CB50751BAABE0@SN6PR11MB3327.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(999002)(5005020)(102415395)(6040522)(2401047)(8121501046)(3002001)(10201501046)(93006095)(93001095)(3231475)(944501520)(4983020)(52105112)(148016)(149066)(150057)(6041310)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(2016111802025)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3327;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3327;
x-forefront-prvs: 0891BC3F3D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39830400003)(136003)(189003)(199004)(54906003)(36756003)(6116002)(105586002)(93886005)(3846002)(316002)(26005)(186003)(386003)(76176011)(6506007)(52116002)(99286004)(14454004)(508600001)(6512007)(53936002)(53546011)(31686004)(102836004)(66066001)(6436002)(6246003)(99936001)(5660300001)(6486002)(55236004)(7416002)(106356001)(81156014)(8676002)(25786009)(229853002)(81166006)(2906002)(2616005)(305945005)(8936002)(4326008)(7736002)(68736007)(6916009)(11346002)(71200400001)(71190400001)(256004)(486006)(78486014)(4001150100001)(31696002)(86362001)(97736004)(446003)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3327;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: yqvMWfoW1cXQ/6Ktwyhh0OYOzSwWQaMtXnCB/DaoELRdJoU2GQ7F4oF/wzpDl061mLKRMn0jgobsI3a7P3hDwZlHYjYKcMCP7VEI1ub0ASCP0VULse3UDCZGe+4KiDUVxXmgDya+q6YRoR/zBCtnDixXJ6E3y8mBCgfS/xWI9CHLWOMPkPevH/vPypOUBO+x2YB4irKj5on7843vKTVRFMn//tCkVEdWCXuoBbbEJB3v+wuXeJuJix4nU8bUU9xekDHwwmH7yedrR6B+4Kjz0ddzB7jowePTLkBrWsPS0tijQQwWbasvhewHsbsm4c8I
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010800020607000100020608"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a99f6b5e-8d1c-4091-a07f-08d665956c10
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2018 09:36:16.2048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3327
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms010800020607000100020608
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-12-19 14:41, Jarkko Sakkinen wrote:
> On Wed, Dec 19, 2018 at 08:41:12AM +0000, Jethro Beekman wrote:
>> One weird thing is the departure from the normal mmap behavior that th=
e
>> memory mapping persists even if the original fd is closed. (See man mm=
ap:
>> "closing the file descriptor does not unmap the region.")
>=20
> The mmapped region and enclave would be completely disjoint to start
> with. The enclave driver code would assume that an enclave VMA exists
> when it maps enclave address space to a process.
>=20
> I.e. VMA would no longer reference to the enclave or vice versa but
> you would still create an enclave VMA with mmap().
>=20
> This is IMHO very clear and well-defined semantics.
>=20
>>> struct sgx_enclave_add_page {
>>> 	__u64	enclave_fd;
>>> 	__u64	src;
>>> 	__u64	secinfo;
>>> 	__u16	mrmask;
>>> } __attribute__((__packed__));
>>
>> Wouldn't you just pass enclave_fd as the ioctl fd parameter?
>=20
> I'm still planning to keep the API in the device fd and use enclave_fd
> as handle to the enclave address space. I don't see any obvious reason
> to change that behavior.
>=20
> And if we ever add any "global" ioctls, then we would have to define
> APIs to both fd's, which would become a mess.
>=20
>> How to specify the address of the page that is being added?
>=20
> Yes, that is correct and my bad to remove it (just quickly drafted what=

> I had in mind).

So your plan is that to call EADD, userspace has to pass the device fd=20
AND the enclave fd AND the enclave address? That seems a little superfluo=
us.

--
Jethro Beekman | Fortanix


--------------ms010800020607000100020608
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTIxOTA5MzYwM1owLwYJKoZIhvcNAQkEMSIEICVs966I
FTIceE6pZJx1pDfGOAk+O52JpT8THBTQ7st3MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQCNanFswD11I6lmLKU1Xuk4KSgjed7VtnrlEf+cqE9wCZH3OhBtcWktccgHfxiYg/A4ilBx
P9YQUNWj61gwINKJWiSwUPYMY07k3Jl1cpB1GBVfPvVagrFuXhpTRv7+VjpxlIzar0wBzvfa
UG4tuU/XbXeYWk/19zGZUhSc9md+9PrN9nhpZFOV8PSt9wYd5N8yroJ5ZOqI3/6/ajOVTrr1
YIllmdbW1AvkiGtkD6E/qWTtxAKREfyBrqWl/Ll155uxJOjYcfP4vy8Q7dsg6ted3l49+5b0
it0L/4PwIRqtvbB855PfF4VeFyYo5X1eOkt0dacBw1kstPTp5LiZJqWOAAAAAAAA

--------------ms010800020607000100020608--
