Return-Path: <SRS0=unfi=R7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35ECC43381
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Mar 2019 01:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57B1A2070B
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Mar 2019 01:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="rTm+gA63"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfC1BVn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 Mar 2019 21:21:43 -0400
Received: from mail-eopbgr700103.outbound.protection.outlook.com ([40.107.70.103]:17761
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727416AbfC1BVm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 Mar 2019 21:21:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4xZv1GEMuhw5nx9xiZ/cByK+zZVrGdZ7zjdwCFjp3g=;
 b=rTm+gA63kF9kAvjGp7PSuemZVoHwERhSu5lWcORY04D9AWnJfd2pIZE7Ow4CvvjN+F1h29IZmXj9q6dm0+WSY7+15Fe18np0y87ao4iqZdFoQaUgkgnP80K43JeVxRXl4+2GzeHvO3J/h+Sa3CHavqc95abbo3179OVscHnxAQ0=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2653.namprd11.prod.outlook.com (52.135.91.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.19; Thu, 28 Mar 2019 01:21:36 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::41b2:7a64:aec0:7746]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::41b2:7a64:aec0:7746%7]) with mapi id 15.20.1730.019; Thu, 28 Mar 2019
 01:21:36 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Thread-Topic: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Thread-Index: AQHU3QbotMy5xdD81UKIp8enwnpo+qYTeOyAgALI1YCAB7NUAIAAsJYAgABcGgCAANzVAIAAGGOAgABYFoA=
Date:   Thu, 28 Mar 2019 01:21:36 +0000
Message-ID: <7f193f22-94be-1b56-e457-2925ae84b8a8@fortanix.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
 <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com>
 <20190326132650.GA31662@linux.intel.com>
 <20190326235852.GL3757@linux.intel.com>
 <20190327052830.GF15397@linux.intel.com>
 <825f5477-c90a-b54b-efeb-a1dc43ccc9d2@fortanix.com>
 <20190327200610.GF9310@linux.intel.com>
In-Reply-To: <20190327200610.GF9310@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0094.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::35) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.56.39.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e1267db-068f-4b35-01a1-08d6b31bb811
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB2653;
x-ms-traffictypediagnostic: SN6PR11MB2653:
x-microsoft-antispam-prvs: <SN6PR11MB26539D1552114939B2565DB2AA590@SN6PR11MB2653.namprd11.prod.outlook.com>
x-forefront-prvs: 0990C54589
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(39850400004)(396003)(136003)(189003)(199004)(186003)(2906002)(6436002)(26005)(6486002)(97736004)(5660300002)(76176011)(6506007)(386003)(7416002)(4326008)(305945005)(68736007)(229853002)(8936002)(99286004)(52116002)(102836004)(86362001)(81156014)(8676002)(14454004)(71190400001)(71200400001)(81166006)(93886005)(14444005)(316002)(105586002)(6116002)(6512007)(256004)(53936002)(478600001)(36756003)(6916009)(31696002)(106356001)(3846002)(7736002)(2616005)(31686004)(25786009)(446003)(53546011)(11346002)(486006)(54906003)(476003)(99936001)(6246003)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2653;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: A5zXsWy1yjJS6Mlk1I0otW+JNLOcb1y/UtI/lkbj/gbunDDi57xJ66GB+7qUYqpPukrnfCzzuBcSLVYm+TysrgdvtJ5MiclyM8q3ewdrGONOy3qFBAVWkCBJOm4maPa7WKtqhb6rupSHaQLsKHdpMrp0IIqySdd8BdSPT9UzWw6okD1WGgcIHcIIPd5bXM3D+2H3KU+cKX8C1yDmvl3BQrqW1gXX6OcOqooBBDpjGngDHcmsx/kwait+5t9m53GqO0bkOmLzw3/97gaj/etSqwHbdA+70Hsl0otxHxZcWh0JvoENSF0wBbafvnHF5EDLArfcoFnJojfxaYArs96umEWCUoD7/WgNOz6NyLP0KHdkbk1oAm00U71LxF+jAg1NrDCuPN0SiEahUPSQauBjOsp1mUv4WPEq6x1RripQOW8=
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000000080409070705060006"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e1267db-068f-4b35-01a1-08d6b31bb811
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2019 01:21:36.8616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2653
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms000000080409070705060006
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-03-27 13:06, Sean Christopherson wrote:
> On Wed, Mar 27, 2019 at 06:38:57PM +0000, Jethro Beekman wrote:
>> On 2019-03-26 22:28, Jarkko Sakkinen wrote:
>>> On Tue, Mar 26, 2019 at 04:58:52PM -0700, Sean Christopherson wrote:
>>>> On Tue, Mar 26, 2019 at 03:26:50PM +0200, Jarkko Sakkinen wrote:
>>>>> On Thu, Mar 21, 2019 at 05:51:11PM +0200, Jarkko Sakkinen wrote:
>>>>>>> Yuck.  If we remove the driver specific Makefile then we can elim=
inate
>>>>>>> the "../" prefix here.  E.g. in the main SGX Makefile:
>>>>>>>
>>>>>>> obj-$(CONFIG_INTEL_SGX_DRIVER) +=3D driver/main.o driver/ioctl.o
>>>>>>
>>>>>> I think this is a great idea.
>>>>>
>>>>> On a 2nd thought not gonna do anything to that because it would
>>>>> require to move driver.h and it is cleaner to keep all the driver
>>>>> files in the same directory (and separated from the core).
>>>>
>>>> What about collapsing driver/*.c into driver.c and moving driver.{c,=
h}
>>>> to the root sgx directory?  The bulk of driver/main.c is securityfs
>>>> and platform driver code, e.g. has a good chance of going away entir=
ely
>>>> or being moved out of the "driver".  At that point there probably is=
n't
>>>> a strong reason to have driver/main.c and driver/ioctl.c.
>>>
>>> I think doing anything major would require to lock in whether to have=

>>> the LKM for the driver at all. If we wipe out the driver, then this i=
s
>>> just matter of moving dev management part to lets say dev.c.
>>>
>>> Unless there is some real production use I can wipe it away. For v19
>>> I wanted to fix it namely because in v18 LKM was just broken. It is
>>> always good to make decisions based on working code.
>>
>> It should be a module because things should be modules when possible. =
I'm
>> not sure what the "Linux policy" is here but this seems obvious to me.=

>>
>> For example:
>>
>> * Modules allow users to easily disable functionality that they don't =
use/is
>> buggy for them/other reasons using blacklisting.
>> * Modules allow users to customize their functionality without having =
to
>> rebuild the entire kernel.
>> * Modules allow developers to customize their modules without having t=
o
>> rebuild the entire kernel.
>=20
> I agree with all of the above, but unfortunately blacklisting is really=

> the only benefit that would be realized by modularizing the driver.  Th=
e

=2E..

> Tying into the your comment of "things should be modules when possible"=
,
> we've gradually come to the realization that truly modularizing the SGX=

> driver isn't possible, at least not without compromising other parts of=

> the design.

What do you mean? The interface that the kernel needs to provide to any=20
EPC-using modules is some way to allocate/free EPC pages and some way to =

associate EPC pages with enclaves (so that the swapper can be=20
intelligent). This is pretty much exactly what the API looks like in v19.=


Note that you still need enclave tracking with KVM if you want the host=20
kernel to be able to page out guest EPC pages. However, you probably=20
wouldn't want to do this with VMAs, so maybe there's an opportunity to=20
streamline the API here.

> For example, relying on the EPC ACPI entry to autoprobe the driver fall=
s
> apart when virtualization support also wants to add an SGX device (or w=
e
> end up with a weird split model where the uapi driver is autoprobed via=

> ACPI and the virtualization device is probed by the SGX subsystem).
>=20
> Relying on the EPC ACPI entry really shows its warts when systems
> with multiple EPC sections show up.  The SGS BIOS writer's guide
> (allegedly, I haven't personally read it) says that one and only one
> EPC entry should be created in the ACPI tables, i.e. software must
> use CPUID to enumerate the base+size of EPC sections.
>=20
> In other words, the whole ACPI entry and platform device approach was a=

> hack purely to allow SGX to be implemented as an out-of-kernel driver.
> If the darn ACPI hack had never been added in the first place, i.e.
> CPUID is the only way to enumerate/probe SGX, then odds are we wouldn't=

> even be having this dicsussion and no one would bat an eye at SGX being=

> implemented as an Intel-specific feature that is baked into the kernel.=

>=20
>> Specifically for SGX I can think of the following reasons as well:
>>
>> * Module-based hypervisors may want to make EPC allocations for their
>> guests.
>> * Easy experimentation with different EPC interfaces
>> * Easy experimentation with in-kernel LE

The only example you give here is ACPI autoprobe. I don't really care=20
about this. I do care about the other things I mentioned.

--
Jethro Beekman | Fortanix


--------------ms000000080409070705060006
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDMyODAxMjEyN1owLwYJKoZIhvcNAQkEMSIEIIRZ+Gnk
IitLuWZS+1pA2tUxTZEMxIoY/sy62tb3ig8AMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQCTN8UorWDO7L61kcb35Mp1z131M/+1vCdxIqLU6ER6pgJKAU4Kr5R7ilFjaOJvuILC5n2k
VhPS+8vcXYLZ5zF6k+3waPnBLnOeBY9aw/BKhEt1Q9hP2Iq7GXwUnTJMQZS3MtJmar5btcSt
IX+UUivi7FU+YyHeYeOC2PzL59ILXgjN2BkWkc6BcJnJiSX2RMgkfmVRidE2tzlU77/k7HKg
fHWuLkS95fANJTfORNnaB+LbHPS8mjtTPE1m20X+1AWE66Pgmpjul8qWLLl38Hh793a5OHd7
NAJ3rsAxOxR1NJ0Rd38AdFEUTC/qBpPuIlJEnTOyf6lpgNGEl3sB+5ctAAAAAAAA

--------------ms000000080409070705060006--
