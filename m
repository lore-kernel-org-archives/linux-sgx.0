Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B535C31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69A9F20665
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="Md+WZxgq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfFMQ7F (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:59:05 -0400
Received: from mail-eopbgr820134.outbound.protection.outlook.com ([40.107.82.134]:47040
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729853AbfFMAiM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 20:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5ogVbIpugCE0KDah3yPZchzuykmwyO2u20kKubrK58=;
 b=Md+WZxgqc8KXqfBV+ZTf6okQEWgs2cKkNbWHhX/sh5lUj1o9BkSkrCJ0Fm1tXYweKCaGH9rzR4XJXWkrvyUiiHuXbBBQRtHmjkkuArLcZ1H93mSM9YSY2UXA73LC7kE62hPXt1FGGjYxxZ5rAJFAepNv6aZDWIEx4MotYAt2Lbo=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3454.namprd11.prod.outlook.com (52.135.111.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 00:38:03 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::95a7:7f01:a25f:c318]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::95a7:7f01:a25f:c318%7]) with mapi id 15.20.1965.017; Thu, 13 Jun 2019
 00:38:03 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>
CC:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH 5/7] x86/sgx: Add flag to zero added region instead of
 copying from source
Thread-Topic: [PATCH 5/7] x86/sgx: Add flag to zero added region instead of
 copying from source
Thread-Index: AQHVG9fQxd63APJpO0OWGSPlIs2PraaO4KEAgAADYICAAbPEgIAErC4AgAOE3AA=
Date:   Thu, 13 Jun 2019 00:38:02 +0000
Message-ID: <35dd5d44-5ddf-09d3-e2d3-8570b2cdf6f5@fortanix.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
 <20190605194845.926-6-sean.j.christopherson@intel.com>
 <CALCETrXkWHOFUD0erQ+TZMY3VmGJz8=tk9rXOtdi8fP_GDEKCA@mail.gmail.com>
 <20190606173243.GE23169@linux.intel.com>
 <A948B013-BCA7-4C76-B816-CC27F38BF761@amacapital.net>
 <20190610185340.GJ15995@linux.intel.com>
In-Reply-To: <20190610185340.GJ15995@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR1501CA0029.namprd15.prod.outlook.com
 (2603:10b6:207:17::42) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.56.38.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f92f8b25-e45d-418f-3785-08d6ef97646d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:SN6PR11MB3454;
x-ms-traffictypediagnostic: SN6PR11MB3454:
x-microsoft-antispam-prvs: <SN6PR11MB3454A83ECFE37BD0A69E5982AAEF0@SN6PR11MB3454.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:486;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39840400004)(396003)(346002)(376002)(136003)(189003)(199004)(316002)(52116002)(53936002)(36756003)(6506007)(31696002)(71190400001)(386003)(86362001)(71200400001)(76176011)(305945005)(14444005)(256004)(53546011)(66066001)(5660300002)(99286004)(7736002)(102836004)(110136005)(486006)(66446008)(3846002)(2616005)(6116002)(476003)(81156014)(68736007)(8936002)(8676002)(508600001)(446003)(81166006)(14454004)(11346002)(31686004)(66616009)(66946007)(186003)(4326008)(54906003)(99936001)(64756008)(66556008)(6436002)(6486002)(73956011)(6246003)(229853002)(6512007)(25786009)(66476007)(26005)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3454;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZpNomLu5aCyWPvEdCWv8kZAI9bNXXIKojYBlznG3fvWK83w6e/1ZRr8jO4quRu1TN1sy67BmMATrf96FoZ6sypnvhOvogsiy0lbmQx9V8CW6HND78bfwN0RSAKwzHhAHjm1oXqRcjaar19Vdj7FhYxsOpX8FcatWqwFcjbwil3gEIS39UonfYPw9vCD99itGA0opOXpEPNPsz0brKQOZEez0exJXltDOkyNKly7COdZ2UNWcwEtFR/Roitzm4sCRQJ9GjKZzTM8QC+f84Gw739tLg2xvRlo1/E+YXevmtqRhHaqEO29mg7N5Gg6AxUq020LGXGW7RoUSZQ9xFCAnn6JEhL2Ki3FqVltMCOrBW7BpbHmuLELauFYNC25AOPUdGPMdpSC3ldrH8r8OOYjHHhJDtfNz5GQc/917J2Wr4QA=
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030905080801060807000608"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f92f8b25-e45d-418f-3785-08d6ef97646d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 00:38:02.9659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jethro@fortanix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3454
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms030905080801060807000608
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-06-10 11:53, Sean Christopherson wrote:
> On Fri, Jun 07, 2019 at 12:32:23PM -0700, Andy Lutomirski wrote:
>>
>>> On Jun 6, 2019, at 10:32 AM, Sean Christopherson <sean.j.christophers=
on@intel.com> wrote:
>>>
>>>> On Thu, Jun 06, 2019 at 10:20:38AM -0700, Andy Lutomirski wrote:
>>>> On Wed, Jun 5, 2019 at 12:49 PM Sean Christopherson
>>>> <sean.j.christopherson@intel.com> wrote:
>>>>>
>>>>> For some enclaves, e.g. an enclave with a small code footprint and =
a
>>>>> large working set, the vast majority of pages added to the enclave =
are
>>>>> zero pages.  Introduce a flag to denote such zero pages.  The major=

>>>>> benefit of the flag will be realized in a future patch to use Linux=
's
>>>>> actual zero page as the source, as opposed to explicitly zeroing th=
e
>>>>> enclave's backing memory.
>>>>>
>>>>
>>>> I feel like I probably asked this at some point, but why is there a
>>>> workqueue here at all?
>>>
>>> Performance.  A while back I wrote a patch set to remove the worker q=
ueue
>>> and discovered that it tanks enclave build time when the enclave is b=
eing
>>> hosted by a Golang application.  Here's a snippet from a mail discuss=
ing
>>> the code.
>>>
>>>     The bad news is that I don't think we can remove the add page wor=
ker
>>>     as applications with userspace schedulers, e.g. Go's M:N schedule=
r,
>>>     can see a 10x or more throughput improvement when using the worke=
r
>>>     queue.  I did a bit of digging for the Golang case to make sure I=

>>>     wasn't doing something horribly stupid/naive and found that it's =
a
>>>     generic issue in Golang with blocking (or just long-running) syst=
em
>>>     calls.  Because Golang multiplexes Goroutines on top of OS thread=
s,
>>>     blocking syscalls introduce latency and context switching overhea=
d,
>>>     e.g. Go's scheduler will spin up a new OS thread to service other=

>>>     Goroutines after it realizes the syscall has blocked, and will la=
ter
>>>     destroy one of the OS threads so that it doesn't build up too man=
y
>>>     unused.
>>>
>>> IIRC, the scenario is spinning up several goroutines, each building a=
n
>>> enclave.  I played around with adding a flag to do a synchronous EADD=

>>> but didn't see a meaningful change in performance for the simple case=
=2E
>>> Supporting both the worker queue and direct paths was complex enough
>>> that I decided it wasn't worth the trouble for initial upstreaming.
>>
>> Sigh.
>>
>> It seems silly to add a workaround for a language that has trouble cal=
ling
>> somewhat-but-not-too-slow syscalls or ioctls.
>>
>> How about fixing this in Go directly?  Either convince the golang peop=
le to
>> add a way to allocate a real thread for a particular region of code or=
 have
>> the Go SGX folks write a bit of C code to do  a whole bunch of ioctls =
and
>> have Go call *that*.  Then the mess stays in Go where it belongs.
>=20
> Actually, I'm pretty sure changing the ioctl() from ADD_PAGE to ADD_REG=
ION
> would eliminate the worst of the golang slowdown without requiring
> userspace to get super fancy.  I'm in favor of eliminating the work que=
ue,
> especially if the UAPI is changed to allow adding multiple pages in a
> single syscall.
>=20

I don't know if this is going to matter a whole lot, but have you=20
considered the performance impact of needing to the EPC paging while=20
doing the EADD ioctl and how this interacts with having a workqueue?

--
Jethro Beekman | Fortanix


--------------ms030905080801060807000608
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDYxMzAwMzc1OFowLwYJKoZIhvcNAQkEMSIEIFkhJRZH
Ve2pgMI7juNPyXVkQDuYPtYEWu+XG+Ufr0djMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQBVFABKMTWOp4bgSHbvXa99fgnfwkRpMW1tz5yyhaSvf0DrlgkU0HnarQruIQGNhXCUQtNs
wjV8KzJ08bQoUuB6hpj8HYQsvkGkRkof6XvSm4Js6sQeG8nya3Y49QPm99uc0xn8LzhM6ZVf
rAMEc4rnlBlxa8WJBLW7QAfBFYp12hh1mr6S5ORorBbMJFQJOcTI3ZLvHSyIqU75KkeBOPLJ
/DSV/eD13tbfEPPgr5zxB7stL8i4xbQYZjI2Spr8b2nVVViTB99ewXSr7Dnfjh9M9SzWLTMZ
48gfuhCpq90rTB/eK8g0FUP9P0L0YS9mpa3txrNvATvwcln+Lop98aCvAAAAAAAA

--------------ms030905080801060807000608--
