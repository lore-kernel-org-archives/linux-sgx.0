Return-Path: <SRS0=L3CU=R6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD61C10F00
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Mar 2019 18:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE89E2070B
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Mar 2019 18:39:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="MvfWa9ia"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391482AbfC0SjD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:39:03 -0400
Received: from mail-eopbgr800122.outbound.protection.outlook.com ([40.107.80.122]:21148
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392046AbfC0SjC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 Mar 2019 14:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TWRvpYkjP5gA0OOf+4SL3UC63Klal98RG0nsTzWYM4=;
 b=MvfWa9iak9fhC81Vs9kBLF7ypQrid2zP2h8gQMzSWnwMx3u4+99StDZYPrThb4Pz0SNVtcwfd3ZC3YHDtx5F7iAvK3cskR8pqcku1BG774tAtgpmVCeCWcg58lZi74UjYl/famXVCE89q1kEHOMbkdEUDbMkIVm9jTwtUv5S7CU=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3392.namprd11.prod.outlook.com (52.135.111.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.16; Wed, 27 Mar 2019 18:38:57 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::41b2:7a64:aec0:7746]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::41b2:7a64:aec0:7746%7]) with mapi id 15.20.1730.019; Wed, 27 Mar 2019
 18:38:57 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
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
Thread-Index: AQHU3QbotMy5xdD81UKIp8enwnpo+qYTeOyAgALI1YCAB7NUAIAAsJYAgABcGgCAANzVAA==
Date:   Wed, 27 Mar 2019 18:38:57 +0000
Message-ID: <825f5477-c90a-b54b-efeb-a1dc43ccc9d2@fortanix.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
 <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com>
 <20190326132650.GA31662@linux.intel.com>
 <20190326235852.GL3757@linux.intel.com>
 <20190327052830.GF15397@linux.intel.com>
In-Reply-To: <20190327052830.GF15397@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:a03:74::38) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f54c6f21-6112-470f-a11b-08d6b2e37896
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3392;
x-ms-traffictypediagnostic: SN6PR11MB3392:
x-microsoft-antispam-prvs: <SN6PR11MB3392E3EB19D104106009AB35AA580@SN6PR11MB3392.namprd11.prod.outlook.com>
x-forefront-prvs: 0989A7979C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(366004)(189003)(199004)(6512007)(66066001)(6486002)(7416002)(305945005)(6436002)(8936002)(26005)(229853002)(4326008)(68736007)(6116002)(3846002)(81156014)(8676002)(446003)(2906002)(11346002)(486006)(186003)(2616005)(476003)(7736002)(99936001)(53936002)(81166006)(97736004)(25786009)(54906003)(110136005)(71190400001)(71200400001)(36756003)(14454004)(508600001)(6246003)(93886005)(5660300002)(256004)(14444005)(105586002)(31686004)(31696002)(86362001)(52116002)(76176011)(102836004)(99286004)(386003)(53546011)(106356001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3392;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NC11v33/hU1WPWFW+/4Rx648WDycOHellHo1dvg2dhppJOFkKlcykh1d6f9FHmd7ThUI7yzue2wwZqnTREu2lIjyV5Kxm7HJhvX6DwD+HUKcRlEPviKC+s+zh7qUNvRooLYZ33t5A4jEIai7LqN/yjodai8gqaOn6bbLBZKJenK5B9vD/LeAvEiDVPhgEAyA+ylmB2P6ujaxbF9H0Vl/9mkBv0LOYN8NXmSSZLL7RwJBt1egWZIOm9a93sIVlVBXnDFsOn6xLm0I/JWDskivSHjgBO2xBy2mI8gjNLhfd42sUiZBd0fIqCQUYWUz5aaHDUxIQTi4OVU+hh6JfGzeGemsAPJuCeW+ARg5jSy64i2rM3DEfYV7+XFRZ3JgQhZ1HdJ6vCNyp6RRnFffXVmO5hhecX9x05MJMZYUK/VgvKU=
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060103090507080304020205"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f54c6f21-6112-470f-a11b-08d6b2e37896
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2019 18:38:57.4655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3392
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms060103090507080304020205
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-03-26 22:28, Jarkko Sakkinen wrote:
> On Tue, Mar 26, 2019 at 04:58:52PM -0700, Sean Christopherson wrote:
>> On Tue, Mar 26, 2019 at 03:26:50PM +0200, Jarkko Sakkinen wrote:
>>> On Thu, Mar 21, 2019 at 05:51:11PM +0200, Jarkko Sakkinen wrote:
>>>>> Yuck.  If we remove the driver specific Makefile then we can elimin=
ate
>>>>> the "../" prefix here.  E.g. in the main SGX Makefile:
>>>>>
>>>>> obj-$(CONFIG_INTEL_SGX_DRIVER) +=3D driver/main.o driver/ioctl.o
>>>>
>>>> I think this is a great idea.
>>>
>>> On a 2nd thought not gonna do anything to that because it would
>>> require to move driver.h and it is cleaner to keep all the driver
>>> files in the same directory (and separated from the core).
>>
>> What about collapsing driver/*.c into driver.c and moving driver.{c,h}=

>> to the root sgx directory?  The bulk of driver/main.c is securityfs
>> and platform driver code, e.g. has a good chance of going away entirel=
y
>> or being moved out of the "driver".  At that point there probably isn'=
t
>> a strong reason to have driver/main.c and driver/ioctl.c.
>=20
> I think doing anything major would require to lock in whether to have
> the LKM for the driver at all. If we wipe out the driver, then this is
> just matter of moving dev management part to lets say dev.c.
>=20
> Unless there is some real production use I can wipe it away. For v19
> I wanted to fix it namely because in v18 LKM was just broken. It is
> always good to make decisions based on working code.

It should be a module because things should be modules when possible.=20
I'm not sure what the "Linux policy" is here but this seems obvious to me=
=2E

For example:

* Modules allow users to easily disable functionality that they don't=20
use/is buggy for them/other reasons using blacklisting.
* Modules allow users to customize their functionality without having to =

rebuild the entire kernel.
* Modules allow developers to customize their modules without having to=20
rebuild the entire kernel.

Specifically for SGX I can think of the following reasons as well:

* Module-based hypervisors may want to make EPC allocations for their=20
guests.
* Easy experimentation with different EPC interfaces
* Easy experimentation with in-kernel LE

--
Jethro Beekman | Fortanix

>=20
> /Jarkko
>=20


--------------ms060103090507080304020205
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDMyNzE4Mzg1NFowLwYJKoZIhvcNAQkEMSIEIA7/KVHd
0Lvg17dWYnGfRHIslO8r/c+BdNC02ABG59+hMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQAQxDICd6Y8LR6NQf7d9RhaGnVqtXDLqXAvvCja6rKypfe3HjOU1W3LMVSuZvFe8g3K0DYM
IqS4BawimvvojampGjWCZ4BceQAcHI2SFsWo0NXUreRjmQyXJ9nG5TfVQ68kwh1cVefpYDCb
CaWsxRw/HwgAz1YZGx+e+vBPP0VctDje8ENwJmtzKtc5S5Qxejo4LBG7JLGx1zmnTIdv2D7B
JSfNni3/XTUMypS3n09m36/JyX1UE59fDev5lfLwuzLvR2codq6ZBgmhhKQrVyBuY4wugiIc
X46NYvlnihqXRvtqLKFRr/NhpFb5KBajXCFG2P7i+ox6rbjLdJKTiU9XAAAAAAAA

--------------ms060103090507080304020205--
