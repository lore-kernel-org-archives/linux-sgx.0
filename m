Return-Path: <SRS0=smjw=OA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DEFC43441
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Nov 2018 05:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91E592087E
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Nov 2018 05:17:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="A7KvBNPp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91E592087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbeKUPuc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Nov 2018 10:50:32 -0500
Received: from mail-eopbgr780098.outbound.protection.outlook.com ([40.107.78.98]:45712
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726149AbeKUPub (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Nov 2018 10:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBEcQvGrqEKFfBUio1hQH3mACftKnouSdharYYv+kIA=;
 b=A7KvBNPpCWJbgcXDktOv3q6Z0D63F4GHvtC8rOGwr9Nco/xdqFz73DVjyjoFDFZylS/edLXmjaEZwcH2BtIcMhnS1qxKURhpvL0a7qLhcgE8ycab5bi33wqbi1hrsZ1UvmKPfxQEAtorWKYrPSw3veYH3T5bgfXuf6Ot/vGdj3Y=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3453.namprd11.prod.outlook.com (52.135.111.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.20; Wed, 21 Nov 2018 05:17:32 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::4cee:6f2d:f3c2:cac7]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::4cee:6f2d:f3c2:cac7%3]) with mapi id 15.20.1339.027; Wed, 21 Nov 2018
 05:17:32 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
CC:     Dave Hansen <dave.hansen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rich Felker <dalias@libc.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: RFC: userspace exception fixups
Thread-Topic: RFC: userspace exception fixups
Thread-Index: AQHUcgvc1wPHkMTl1kOh3Odo0nI54qVVOPcAgAIcTACAAAkSAIAAEDkAgAEgLYCAAFYTgIAAf1EAgABqtgA=
Date:   Wed, 21 Nov 2018 05:17:32 +0000
Message-ID: <0a78772e-4f42-254b-d91a-f0f80a24ff90@fortanix.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
 <CALCETrXSpn7QGzPgO1BjMRQ75r2i0kmACrbUM+8PyT+xi3f3Hw@mail.gmail.com>
 <20181119160204.GD13298@linux.intel.com>
 <CALCETrWRVgPjnDd-CknskrXfNbke=rSnr_jezszNNWJUM_YJKQ@mail.gmail.com>
 <20181120101133.GA7319@linux.intel.com>
 <CALCETrU2dy7Oh+AHDGZ2omq9p7pNbjFd8ruv5CkfJXCp5nTYBQ@mail.gmail.com>
 <20181120225518.GE8391@linux.intel.com>
In-Reply-To: <20181120225518.GE8391@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR0601CA0013.apcprd06.prod.outlook.com (2603:1096:3::23)
 To SN6PR11MB3167.namprd11.prod.outlook.com (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [14.143.179.162]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3453;6:7ATcNhxLa9/8yzvTubl68pIl/tq67NA6HOlotNwvqaSE5XILyBmps8+0tPaO7iD6iQIAzk8hicU5f+DAq2bh0bZ/v+bj88fybiQrUdCkKcLtHG/rd9BmFluhqG2lcoIuwDBtC/G939+wJJYaSbfZWltqZqct9KoaXTjfMGFN2HQPDz7i0Xsf/r/lSdUz5Ikq/Dsl0hrwkkmDEGlVz1FerzjcDZxFc8AjwrQao2+D1lVPD3MWj7qFaESFbZn4dH9nXR8Mtg3uWhHAeHlU+dZ+pcZ5wDmIOFcUvLnSFb0TgIDuTdeY4hjBvh5DFEjB1X+T4ES3ds3LA/ZOK3XWFC4dNmfsS6niXATIIKPRjuHHSqsTk6iECmnq1WZ+pttQuExuyPyV+l291Zf2+ZI+xaCHSLnrfrk/tEeIsK2FNT2v+r8RWcUZ612+XDSlC615iUyKqKy0Bo8sHJxY8gafpcS1Hg==;5:8h/DIIOEDphnDvVsjqkYDWmyrscMmmJSufz1ILak0NUAWyt3agFVlzCkbr9ShyoCD1EV1k/Y8wL1qtc4KarNO/oo+Us8A+CjWbNSFqfaraEnWGr5vDFeKwq37PL3VdWBV/ad9LXF0TPZZDTVYs7+EtbZPcih+wMVrojTNjrAW/4=;7:Nc74pvdvCbJ6XcxQWl1VcnRnU2s1YKbkAdOfFzgfOVmrgxmwbj8nDkabHaVx+ucUw6SLQxBAWkHhy0uQbXk0G1RP6p3BQnSeqWSRrcWFwSXI4difRL7Ytg+Okk7P9aMpbaLKFYfCqBONZm0wBxGOZg==
x-ms-office365-filtering-correlation-id: 60d66656-d7a6-4638-4a81-08d64f70a3ac
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(7021145)(8989299)(5600074)(711020)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3453;
x-ms-traffictypediagnostic: SN6PR11MB3453:
x-microsoft-antispam-prvs: <SN6PR11MB345322D95ADFD396112E02AEAADA0@SN6PR11MB3453.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(5005006)(8121501046)(3231442)(944501410)(4983020)(52105112)(10201501046)(93006095)(93001095)(3002001)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(2016111802025)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3453;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3453;
x-forefront-prvs: 08635C03D4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(39830400003)(366004)(136003)(199004)(189003)(14454004)(5660300001)(53936002)(305945005)(508600001)(186003)(7416002)(99936001)(6512007)(93886005)(54906003)(110136005)(2616005)(316002)(476003)(6436002)(6116002)(3846002)(6486002)(36756003)(106356001)(2906002)(7736002)(446003)(52116002)(2900100001)(6246003)(78486014)(11346002)(99286004)(71200400001)(71190400001)(76176011)(105586002)(86362001)(486006)(256004)(66066001)(4001150100001)(25786009)(26005)(229853002)(8676002)(102836004)(81156014)(97736004)(81166006)(8936002)(68736007)(386003)(6506007)(31686004)(55236004)(4326008)(31696002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3453;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: kUSTQuNYvoOoc7YeWFOu4cClTinBXsaY5AMWU9hLSyuGx1jyLBGEffoGzbXxEiaCVi8gexEVOZOlck9ZFME/HwuuGzTjWBpXOkt403WkP74Eue6qwpfZ4D6k0gvelXO2MAnlz9nhlAF6iIihc+tFYgGrnQh+G3ha3bKqsOld3defmYG7BGL/UV6bH7axZBARZnZR5myTDd0RZWkNahMaAmI+kD1WqhzxSZDvkUiwl72eTGcMxjKuTtpRL5mwuoCOlivhpDA9w2ZtZ3YM20g92A/4/EoRNzX+Sjq90LIhFgawsIUUu3ordYiKuz1qHK4V+VWWKf9VsjvQhnufzSSH1IyyF8XibZ1T4E+0Ijilabw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000004040406070609060704"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d66656-d7a6-4638-4a81-08d64f70a3ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2018 05:17:32.4615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3453
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms000004040406070609060704
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-11-21 04:25, Jarkko Sakkinen wrote:
> On Tue, Nov 20, 2018 at 07:19:37AM -0800, Andy Lutomirski wrote:
>> general by mucking with some regs and retrying -- that will infinite
>> loop and confuse everyone.  I'm not even 100% convinced that decoding
>> the insn stream is useful -- AEP can point to something that isn't
>> ENCLU.
>=20
> In my return-to-AEP approach to whole point was not to do any decoding
> but instead have something else always in the AEP handler than just
> ENCLU.
>=20
> No instruction decoding. No RIP manipulation.
>=20
>> IOW the kernel needs to know *when* to apply this special behavior.
>> Sadly there is no bit in the exception frame that says "came from
>> SGX".

Jarkko, can you please explain you solution in detail? The CPU receives=20
an exception. This will be handled by the kernel exception handler. What =

information does the kernel exception handler use to determine whether=20
to deliver the exception as a regular signal to the process, or whether=20
to set the special registers values for userspace and just continue=20
executing the process manually?

--
Jethro Beekman | Fortanix


--------------ms000004040406070609060704
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTEyMTA1MTcxNFowLwYJKoZIhvcNAQkEMSIEIGkGlOHK
cYyCgXgQqe9tx5ygCjVEV/nvbsGrC5dTsC2XMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQA1mRKY4bQ5D4GZp6TvTQ5T/mFnJBANLpt0ijL0aBAYRtdOtslp5MLQ6fWkUi/v7jE4gRq/
2CPeEz/hH5cuCSiV6CWGwce26smT143VFewwTYb3xvFdYHV3umDwokM273LQN2cWQHmoFzFe
io6zK/JIJW/7Jp1vXeP4xzFdyy+2EMg4PN0g7rcL8xbR0AIMFbvOYpNUVo6GRJxCBUN8pvjm
DQuMMJyTAA3viBdq6HHrThpL2kpB/yceqAY2cUE7r7wkNwbx4id9C2JF6xMnevm0wb1U4M89
W1Dp7xB02e4No9sAaHg5+jtuBwgP+9tJcBUDiiSBBeYAu6eBtBSlfkheAAAAAAAA

--------------ms000004040406070609060704--
