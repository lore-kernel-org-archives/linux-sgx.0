Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAF0C32789
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 16:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F2472081B
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 16:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="UDDO/rJe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F2472081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbeKCCE0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 22:04:26 -0400
Received: from mail-eopbgr730111.outbound.protection.outlook.com ([40.107.73.111]:61472
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726707AbeKCCE0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Nov 2018 22:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0YT9K+LQ1XCUSiS/F6MLcr5X9AwPvQ/Un2kc7Q1eTE=;
 b=UDDO/rJeDWc1H5Aobfgrxtl3c2fgRv8sO/ZzpPcszGnmVTZv354N01dzAFIvcvpFGKn6dfUBtHx+f8FxXpq5VeBIhomW9A1UYKhV4MQcUm+wWGcH88JzCuVcBYLhnearPzmrB52EsILSm5WDiqb/Usqk2to6kTIF8nkRZZRqHfA=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3455.namprd11.prod.outlook.com (52.135.111.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.26; Fri, 2 Nov 2018 16:56:36 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::e100:5c05:f62d:b2c5]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::e100:5c05:f62d:b2c5%5]) with mapi id 15.20.1273.030; Fri, 2 Nov 2018
 16:56:36 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Carlos O'Donell <carlos@redhat.com>,
        "adhemerval.zanella@linaro.org" <adhemerval.zanella@linaro.org>
Subject: Re: RFC: userspace exception fixups
Thread-Topic: RFC: userspace exception fixups
Thread-Index: AQHUcgvc1wPHkMTl1kOh3Odo0nI54qU7PrGAgAAFRoCAAAUTgIAABb2AgAAfqQCAACEagIABHyAAgAAB0ACAAAQxAIAAAT0A
Date:   Fri, 2 Nov 2018 16:56:36 +0000
Message-ID: <dd455b30-b586-bf5b-2195-cf20c1af9890@fortanix.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx>
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com>
 <7e14ee0e-ce15-1e88-7ae9-4d0f40cb3d84@fortanix.com>
 <20181102165204.GC7393@linux.intel.com>
In-Reply-To: <20181102165204.GC7393@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM6PR06CA0042.namprd06.prod.outlook.com
 (2603:10b6:5:54::19) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.56.39.144]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3455;6:pf+y+g3jzaSI3QJXvS6d5QkGN9P/CmgXlwbqEhLK10qFVCK6+mLoErw05mm+1mRU1104LYmO+Qvgmk5eD5SvRk3DPzVRxwFt3v4PuRNFz8TbaDKa70uzy+LiX3oos1aAVC244TKY+Hh2DMr4uGviF2z2gDGxVNbl1qB/8IpOqvFQgsBLPy/lWbaUZiqxeJdi4/gTf+esAuNMThXTYYJv8w0+fFCf+9PQmgB6EFXhTNc3IQW0fKQ+3lW8ViSU1jV14jznIYcub/n1e+6TWFlXWkYZ9i0cmEasSX1YJvPjMAk+7/GCoYrxUZd79gLa1SgGBOLZZwQRktmTgXudqzB4pJo1PmGgA8NY3DSjbsK2PYel43sujNCh6/fZVl80kd24uwqtgNVUKG0b3xdRZxrzlbgETB1dEMFnanf6svqClPI2loRFwYWGrvdRx9Qa3kGYMXKCp8MLZ48qiQnp/OefjA==;5:vZbXvS1ghlPEvlQTjK2ZpzvTHiwJDjzvorKUew+pf4taHKRWNCjbxYb6BfMExkhg4hm9WIzLjbpvVlTasMiGqKlN/wRTYbTCdc1FHrI78H8XSJ/0L9sx4m9VVgOcz/3Qls8erTFyPTmn/d7u69NH3aXjBXiVv6TRCGSmDvf9nso=;7:l+LOBGt4N2GdS368VeQ+IyQd8vgsPpEYtCt8KN5NFo3prQ2tpzfP7EVnFLByjstHNW5/NrB1gxfRarqh2MWg4HeYn7dd5AyW9x/lwMCU7ajzt/etmk1efVJ8IjfWBEbEymljq+Cvhg4ANnAsDbzJZA==
x-ms-office365-filtering-correlation-id: c9156aa9-7ff6-413d-392d-08d640e42663
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(7021145)(8989299)(5600074)(711020)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3455;
x-ms-traffictypediagnostic: SN6PR11MB3455:
x-microsoft-antispam-prvs: <SN6PR11MB3455E7EE41C0EE85720B46AFAACF0@SN6PR11MB3455.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(4983020)(52105095)(3002001)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(2016111802025)(20161123562045)(20161123560045)(20161123564045)(20161123558120)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3455;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3455;
x-forefront-prvs: 08444C7C87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39840400004)(366004)(136003)(346002)(396003)(189003)(199004)(476003)(11346002)(86362001)(52116002)(99286004)(446003)(486006)(102836004)(105586002)(14454004)(186003)(53546011)(8936002)(386003)(6506007)(8676002)(26005)(2906002)(2900100001)(2616005)(81166006)(81156014)(66066001)(68736007)(31686004)(6916009)(7416002)(6512007)(5660300001)(97736004)(53936002)(54906003)(256004)(316002)(305945005)(76176011)(3846002)(99936001)(7736002)(508600001)(6116002)(229853002)(93886005)(106356001)(36756003)(31696002)(6486002)(71200400001)(6436002)(6246003)(25786009)(71190400001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3455;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: C9/YZkWMosNr+cQZZ4Wd/nkHH/Zo5g4+CK8nS7SCGq3BrQAxFckhM5cD/RMbWfw2EduQwo6C9+BqjBzR9RAhnoS2feeZEWilUFcRzldFV84cbQ3Jed2pIEFEYk3alkQpyoRMXPmQC616UO4sbhRkyzhPhPRq9Fxb6IORPgzGTdeTbD2CIjWvegOkGA1V8eBxXK9qp9ZnlbJvIty3NgkJV3P2ST+f916SZe9k02tfn9MvvCPOU+yoVsSRkh1BBqdponhleKHUKLYO/Lc/RPZY/iQGQTKyBN9nBbU/C2zwPwNKy+DHpw/rGHA9mYn+BW5X+Qmd66X7OKEz3t+7VdbPDV1NsaJSxg+5OOpjIiUEFEw=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030509020403000008030509"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9156aa9-7ff6-413d-392d-08d640e42663
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2018 16:56:36.4104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3455
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181102165636.-Z6DX6dmrz7pT_LiO_ax6ueF6ivi8WIJRBYnWi3m-Vg@z>

--------------ms030509020403000008030509
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-11-02 09:52, Sean Christopherson wrote:
> On Fri, Nov 02, 2018 at 04:37:10PM +0000, Jethro Beekman wrote:
>> On 2018-11-02 09:30, Sean Christopherson wrote:
>>> ... The intended convention for EENTER is to have an ENCLU at the AEX=
 target ...
>>>
>>> ... to further enforce that the AEX target needs to be ENCLU.
>>
>> Some SGX runtimes may want to use a different AEX target.
>=20
> To what end?  Userspace gets no indication as to why the AEX occurred.
> And if exceptions are getting transfered to userspace the trampoline
> would effectively be handling only INTR, NMI, #MC and EPC #PF.
>=20

Various reasons...

Userspace may have established an exception handling convention with the =

enclave (by setting TCS.NSSA > 1) and may want to call EENTER instead of =

ERESUME.

Userspace may want fine-grained control over enclave scheduling (e.g.=20
SGX-Step)

--
Jethro Beekman | Fortanix


--------------ms030509020403000008030509
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTEwMjE2NTYzMVowLwYJKoZIhvcNAQkEMSIEIMKwKom9
y5xLYufLbHtA0QzEBhoa36+RnylFu8dnprV+MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQAfbs5FJUVojEqh+ULXVUocv2RQzA7F0E6x71hK95qZ5aHKKucfmSWxo7i1lexJvAilwbAc
pXu2aOn6mzSv51NIbIWC9zIOX5X/Pr1TGZnLiZ7WquWNl5RyLKb4/GoGeRhiBh00JQOov7Hw
1sK9K993b1uDdapFv6hPybvzvAtLeyITj6qtzX52AugFz+FXpdDF9hITcuYZJur4T37kzny+
PQ12YoegQnHy8QUheuXxJQhgL2hXWP1UNHWD3/nSQDzjraMsTRP5ufZ4XPe6+zmCe4J27lhg
CDP+eWLJUK+/v0N7WMkL5qApsM6+JAsQwgMKHp/pPDakfQ+iiioPeccwAAAAAAAA

--------------ms030509020403000008030509--
