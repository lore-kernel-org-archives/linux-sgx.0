Return-Path: <SRS0=RM7e=N6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B320FC43441
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 05:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6505720817
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 05:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="By8Ocek3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6505720817
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbeKSPj7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Nov 2018 10:39:59 -0500
Received: from mail-eopbgr760109.outbound.protection.outlook.com ([40.107.76.109]:6118
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbeKSPj7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Nov 2018 10:39:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWXEYXXwREIUIBGjzcLmgABmNcHQhTenK9B2w5qOqqc=;
 b=By8Ocek3D1jt1zXn/9DRq1cactbjpk/sVWaVm1NVQXA5RnLOfbEVJF3sFPYbIkcF03mIYx41Ep2E6pfvgU3sUuszyEV2mH/Dw4/F9tof/wtUORW7KJ3QerxysOIGerkSP0oKQbvGIcNH0SjOPBZcsuKjJxKPebxEjGi+wIgT9ng=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2944.namprd11.prod.outlook.com (52.135.124.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.30; Mon, 19 Nov 2018 05:17:27 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::4cee:6f2d:f3c2:cac7]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::4cee:6f2d:f3c2:cac7%3]) with mapi id 15.20.1339.026; Mon, 19 Nov 2018
 05:17:27 +0000
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
Thread-Index: AQHUcgvc1wPHkMTl1kOh3Odo0nI54qVVOPcAgABgvYCAARB1AA==
Date:   Mon, 19 Nov 2018 05:17:26 +0000
Message-ID: <ce304dba-0b02-02e2-4de8-212cd3bd1876@fortanix.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
 <20181118130203.GA18934@linux.intel.com>
In-Reply-To: <20181118130203.GA18934@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR04CA0137.apcprd04.prod.outlook.com
 (2603:1096:3:16::21) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [14.143.179.162]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB2944;6:8sVcb5W5lHoqKblFGUSjbnNzTNFAgO7BOL3ZfffQxjil80M0180akzG85NZv4JuDtwOLu5IVRNuN3x6VZ++B2R5TbRmkkt28NjEvXau9zGP7Xv9A+64NY72qyBQk3NikOsOc4Z86+OGEHJ+9z+75GDzeAtsQwtBOBJFyLUJ77ycjcGAQpBXIfqeq7SZYizNOTeLL2mJNPowlSGMUxw2HDVuIyJID+gjNtPoR8sTEPHgAZdUqrIoS1mpNKmZNt4V+2LLGk2EeYKB8VzZ6fJE9ebjsZn9f3ttkIhBkQFF1LcV8vUhxmJyMPjRJSpPso1ApepONOxtVqMgoQXsRRsB5Bj0g3HcSgxeumd8NMbVIn3231qXHa7EDlPYzEuL9TSe8Q5fTGleX62pBgKcnSNSG/BOQJ0PV+Q+n6AfJpFBO4WgPcHwGsinDEUULDRSE57B3ziPoqHNDNPmtoSWGb7zB3A==;5:8nusaRmp5eRTykMxpJ8M7QQythxGlikEbynqIlijjHVn/x0zGyOFBKMDI3WUJ9uCDaYAD3B3h1U3Wdd0GoV5OZsoiafAB+1+xZ8RsNh5CbcUyhrZUE1ucKmPr7pEIClB7kjCVrB5kVfkBT5ztKwNumJ0ar+Ri0Q7COGxr2SvMkk=;7:iV3YIgszOhhNVTAfxwhNLG4MZgdP5XAXEnREJYhX5/LxrOGpACyyoGgnEx9TLv+I+uNsM0vCk29il3hKYoJ8BK1IOnKW6ZCiDQjsluBC05FIxcA85jPJtucT3fGrBYAFk+c0HHsG+yBQxUE6nyKyLQ==
x-ms-office365-filtering-correlation-id: 38ce3074-3bcb-40e8-65c7-08d64dde4b8f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(7021145)(8989299)(5600074)(711020)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB2944;
x-ms-traffictypediagnostic: SN6PR11MB2944:
x-microsoft-antispam-prvs: <SN6PR11MB2944C7184A44C0DC1F075521AAD80@SN6PR11MB2944.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(3231415)(944501410)(4983020)(52105112)(10201501046)(3002001)(148016)(149066)(150057)(6041310)(20161123558120)(2016111802025)(20161123562045)(20161123564045)(20161123560045)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB2944;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB2944;
x-forefront-prvs: 08617F610C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(39830400003)(396003)(366004)(199004)(189003)(53754006)(7416002)(66066001)(71190400001)(71200400001)(229853002)(8676002)(81166006)(7736002)(81156014)(305945005)(256004)(476003)(36756003)(2906002)(53546011)(486006)(99286004)(2616005)(106356001)(105586002)(4326008)(11346002)(52116002)(76176011)(8936002)(25786009)(446003)(55236004)(6506007)(386003)(102836004)(6486002)(6246003)(186003)(14454004)(5660300001)(3846002)(97736004)(6116002)(31696002)(68736007)(86362001)(26005)(2900100001)(508600001)(6436002)(6512007)(78486014)(31686004)(4001150100001)(54906003)(110136005)(99936001)(53936002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2944;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: vlqKKjvtX4bLaA9KzbmVPNiH+SAYtKszWbqJNijqTAEXeGO/0l1w1t2OYkLTScPRUdWWjNdcXAUKrVXErPIwm3vPL5QILwqnE8tRe3umChq4V+kgqXukJlQnCnN/olmFLT8MCXZ5Z+B0BAB4Lop9NeUz75ETj+9VG9E++ZXq+7vlY0YwMsrRCYlVu4m75RMczO+ccLL2evibeUfzlGUTinj5Xfc4BgmdpnQ99nKGawfpeD2cnV6PJuhIYoC0HDd8wCJUj0metnpQPO35Z0hRG9TudbMuWuEmgR8TIp1ZiUd0TQwEQrzvd/avHFXLf4qiooVyx3etxSsSjjNeF+0TIbOXWlI3+r/SjT8ztp/y55Y=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030006070600080800030405"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38ce3074-3bcb-40e8-65c7-08d64dde4b8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2018 05:17:27.0294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2944
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms030006070600080800030405
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-11-18 18:32, Jarkko Sakkinen wrote:
> On Sun, Nov 18, 2018 at 09:15:48AM +0200, Jarkko Sakkinen wrote:
>> On Thu, Nov 01, 2018 at 10:53:40AM -0700, Andy Lutomirski wrote:
>>> Hi all-
>>>
>>> The people working on SGX enablement are grappling with a somewhat
>>> annoying issue: the x86 EENTER instruction is used from user code and=

>>> can, as part of its normal-ish operation, raise an exception.  It is
>>> also highly likely to be used from a library, and signal handling in
>>> libraries is unpleasant at best.
>>>
>>> There's been some discussion of adding a vDSO entry point to wrap
>>> EENTER and do something sensible with the exceptions, but I'm
>>> wondering if a more general mechanism would be helpful.
>>
>> I haven't really followed all of this discussion because I've been bus=
y
>> working on the patch set but for me all of these approaches look awful=
ly
>> complicated.
>>
>> I'll throw my own suggestion and apologize if this has been already
>> suggested and discarded: return-to-AEP.
>>
>> My idea is to do just a small extension to SGX AEX handling. At the
>> moment hardware will RAX, RBX and RCX with ERESUME parameters. We can
>> fill extend this by filling other three spare registers with exception=

>> information.
>>
>> AEP handler can then do whatever it wants to do with this information
>> or just do ERESUME.
>=20
> A correction here. In practice this will add a requirement to have a bi=
t
> more complicated AEP code (check the regs for exceptions) than before
> and not just bytes for ENCLU.
>=20
> e.g. AEP handler should be along the lines
>=20
> 1. #PF (or #UD or) happens. Kernel fills the registers when it cannot
>     handle the exception and returns back to user space i.e. to the
>     AEP handler.
> 2. Check the registers containing exception information. If they have
>     been filled, take whatever actions user space wants to take.
> 3. Otherwise, just ERESUME.
>=20
>  From my point of view this is making the AEP parameter useful. Its
> standard use is just weird (always point to a place just containing
> ENCLU bytes, why the heck it even exists).

I like this solution. Keeps things simple. One question: when an=20
exception occurs, how does the kernel know whether to set special=20
registers or send a signal?

--
Jethro Beekman | Fortanix



--------------ms030006070600080800030405
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTExOTA1MTcxMlowLwYJKoZIhvcNAQkEMSIEIEMCd7us
AiJP3IcVvrq+lmWcpj3baIYMKMBfqqLuc/RFMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQA3OX33ODUV9LgCwyYFBDFeJCgwwBJFWs05rWM0rUCyiWKr1f6HbUDymWz4qnNny/2uldrM
evmuZncSazm4XVAw4aQAhWkulDAeJTuhFk7/tQXHiGtVCTGu2hrTrfgkQPD4v8dfTeURsONS
I0hGgByJ3auJhp2j6KyO+yHQGsmRiEz477DIoGOcz/IWvDtrK6lkmTkmOdBQVzbMCaj3vn98
jTW7/ZBnBGC1u5aacaZI/iyhOVywlL6wi1QQ+qFWJv7CWoiHmEXSh2ffDPHqf2FqEcjBVhhf
hDTHzhqFWXNMBStjpuxKEBgCIqQqSZZa0g4dRn4MGbb1xz0/FGrMCFWdAAAAAAAA

--------------ms030006070600080800030405--
