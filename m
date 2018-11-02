Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3378C32789
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 17:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9343F2081B
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 17:05:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="JB2w9rGL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9343F2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbeKCCNX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 22:13:23 -0400
Received: from mail-dm3nam03on0106.outbound.protection.outlook.com ([104.47.41.106]:21088
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726700AbeKCCNW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Nov 2018 22:13:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JHQWYJ/DfPOsZxE+YPAVVRkgS6pVNOCHVl0uE13lZU=;
 b=JB2w9rGLzIPllNWZ1BrHaiRkJ9zqlRFklS3tCeF8roNghCJIDqBTwxu+mIsLfzJgAYw2WDTgK+Yt6KRaTB/9znOPEslkk3ZC91qsi1duvOaz70q/lOCPuQCdJZyXcETOXvsTfWjzxQP6v54MbyDVikE+cf7ZCzZjoDJqB1qVXtY=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3103.namprd11.prod.outlook.com (52.135.126.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.21; Fri, 2 Nov 2018 17:05:25 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::e100:5c05:f62d:b2c5]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::e100:5c05:f62d:b2c5%5]) with mapi id 15.20.1273.030; Fri, 2 Nov 2018
 17:05:25 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Thread-Index: AQHUcgvc1wPHkMTl1kOh3Odo0nI54qU7PrGAgAAFRoCAAAUTgIAABb2AgAAfqQCAACEagIABHyAAgAAB0ACAAAQxAIAAAT0AgAABTACAAAErgA==
Date:   Fri, 2 Nov 2018 17:05:25 +0000
Message-ID: <1b87048e-7ed8-14a1-572f-3cd825319f8c@fortanix.com>
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
 <dd455b30-b586-bf5b-2195-cf20c1af9890@fortanix.com>
 <CALCETrUo8uwnu3dBVSHVtB_z4uQgW=40grVdZWmTt64Tei6WiQ@mail.gmail.com>
In-Reply-To: <CALCETrUo8uwnu3dBVSHVtB_z4uQgW=40grVdZWmTt64Tei6WiQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR0102CA0014.prod.exchangelabs.com (2603:10b6:4:9c::27)
 To SN6PR11MB3167.namprd11.prod.outlook.com (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.56.39.144]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3103;6:8hTtxBPXZpAFyLFt+hjUQ0/Rv7k8dJvmW35jmBkzcLOmNV9OEtMJuKuege2AqIeXVvKVs18uMpW6vE75lPw7DaQH/em0sjzFLgsMVVaY81dDpvmDMApobtNM9MJRHJ/TMvKEm07HPlNdCO2mIacxQMOrHWJJpnOxig61UHU+3ALYXCqEzBM1zEC+8Y+hzIoqYmYo1Tg7FPoUwls/EKsL83vh6SBxaybSgTdoWc7UzudQZ6mu4+9rFCJZSohFCIynbXNxMSkz4ntL/T6JmEYZNID5YaHLsHQ0lgwMvddXZ7Cnoi2kPIJgG4SvbPPwRUri+iaupgrLeWN8VpVals10aqGiMDIZcB49saKJ63+Xg3RCjJraJmeisyCGBwR2smKXltRzOTpKXSeUvD6L2d//y49i2fOcar9XwG60Fwoan+S158rUUVbXKlkWRqJ+q1+HvoM5k8C/UYbDkMheWWZ4fw==;5:eTzE0nS5RXb24O7cTwGECCmxq1lLlcWwcmbqdPKZRWQmR20b4X3v7K7hOeGuK7G2c94J0K3+GveKf3dZqo0FcMDE5Nu+HRSlZMjrxYKgkWGsKpM/Z+AjbS3hvSaxOwMZZ0Dl1i9OQLhkMWQ75f1i5R5aTdDMsakD6bn4QuTSsRI=;7:/v1aFWZCjXazshuevgcWna0ULcuR6NkurwOJup61Zb6lLxFEN/LWXj5J6T+99b2Ku+dRIVT1NewAlRYeHT0ojn7EYPzhJR7Cgf3zcDNh+RcLd+ukiH9+CBzU48rG5/ygsYE/8aoPYfKsxCNocEDTOA==
x-ms-office365-filtering-correlation-id: a18fd4bd-14f1-466f-638b-08d640e561b4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3103;
x-ms-traffictypediagnostic: SN6PR11MB3103:
x-microsoft-antispam-prvs: <SN6PR11MB3103CD8DFC79310BBBF1B197AACF0@SN6PR11MB3103.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(5005006)(8121501046)(3231382)(944501410)(4983020)(52105095)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(2016111802025)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3103;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3103;
x-forefront-prvs: 08444C7C87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39840400004)(366004)(396003)(199004)(189003)(305945005)(486006)(31696002)(6916009)(71190400001)(86362001)(71200400001)(4326008)(229853002)(8676002)(446003)(36756003)(6246003)(8936002)(54906003)(476003)(11346002)(2616005)(53546011)(102836004)(186003)(52116002)(93886005)(26005)(2906002)(6506007)(386003)(76176011)(316002)(256004)(508600001)(105586002)(106356001)(97736004)(6486002)(99286004)(25786009)(7736002)(31686004)(7416002)(68736007)(14454004)(53936002)(81166006)(81156014)(6436002)(99936001)(3846002)(66066001)(5660300001)(6116002)(2900100001)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3103;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: sj+LgBy4JM14XQDUiPcE/f9QHmHTw89gCewlmIWF8cZzL4ohLREFtrq8HZQ/HCdZAYaqxYivk6t+rRqp5g9ghrXLOwefsS0hsBH4YpcHWKHhJiw5HvqRPo4jIe4DkRXBo5VMJ8ERK+zSBt0DRXNtvTX4Zz4xK81Uyv7Ibrfmi40AzVJ0B3YpeV+d2Ft0dg2vcWw4WFaElP12Bnn/c6OezA8vxb83QBRxpg417YwyAgqhIDeM6pDqi5HWpsvTjLB3Aa2TWi5i7e3kjzj52I/bG0hQ4a/UELrRlosNWC8Q+rZjYcwvjRTwnlqDjcvhQ8QDHn00/q2Ke8pMdxXy4pZOAivPSkFb/cBfiyKgyvEJV5I=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080508070403040505010807"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a18fd4bd-14f1-466f-638b-08d640e561b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2018 17:05:25.3336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3103
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181102170525.FRh7oB9esTMRHyaun3z7v5_L776AoYG9JyHGd9KCdm0@z>

--------------ms080508070403040505010807
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-11-02 10:01, Andy Lutomirski wrote:
> On Fri, Nov 2, 2018 at 9:56 AM Jethro Beekman <jethro@fortanix.com> wro=
te:
>>
>> On 2018-11-02 09:52, Sean Christopherson wrote:
>>> On Fri, Nov 02, 2018 at 04:37:10PM +0000, Jethro Beekman wrote:
>>>> On 2018-11-02 09:30, Sean Christopherson wrote:
>>>>> ... The intended convention for EENTER is to have an ENCLU at the A=
EX target ...
>>>>>
>>>>> ... to further enforce that the AEX target needs to be ENCLU.
>>>>
>>>> Some SGX runtimes may want to use a different AEX target.
>>>
>>> To what end?  Userspace gets no indication as to why the AEX occurred=
=2E
>>> And if exceptions are getting transfered to userspace the trampoline
>>> would effectively be handling only INTR, NMI, #MC and EPC #PF.
>>>
>>
>> Various reasons...
>>
>> Userspace may have established an exception handling convention with t=
he
>> enclave (by setting TCS.NSSA > 1) and may want to call EENTER instead =
of
>> ERESUME.
>>
>=20
> Ugh,
>=20
> I sincerely hope that a future ISA extension lets the kernel return
> directly back to enclave mode so that AEX events become entirely
> invisible to user code.

Can you explain how this would work for things like #BR/#DE/#UD that=20
need to be fixed up by code running in the enclave before it can be resum=
ed?

--=20
Jethro Beekman | Fortanix


--------------ms080508070403040505010807
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTEwMjE3MDUxOVowLwYJKoZIhvcNAQkEMSIEIF9RxWfm
Ek6tqaU6eqasyNx7a8RCQB3QEjy7zyFNI7caMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQDJMlfPdE6Otuzl9vYBDYbOrlwoqYOXvgWMO91NeVWMro88SQq0cjD+o6wp4kpFb+ZBN+Y/
o6/41/FbIbU1K2tU1+FjGNj7aQ6Yqchy3yR0TaiM8nSREn0o69tTQ61dQssdb5UBLJVUrhN+
TZKhEOou7efuqsfMC3ObVCb60M/PPBt5ABjV/G9ucGVi7xyelEsep2gfhmmEqIjkIZ/9JIDk
mttyaFVEYv08u+mbkwq5EbmroU3oGejizG6dQY68L9phj2KOjAtOo9cg7b1zfi6o5hmOjfU/
VPTfIbSCvRAa2HnAMuP3diFnEdligvUiT+v8L3Sid5ngu4cxzbNGhLysAAAAAAAA

--------------ms080508070403040505010807--
