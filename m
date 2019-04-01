Return-Path: <SRS0=Wg/f=SD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FB6C43381
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Apr 2019 17:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD5C120883
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Apr 2019 17:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="uasRC64/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732401AbfDARZV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Apr 2019 13:25:21 -0400
Received: from mail-eopbgr750111.outbound.protection.outlook.com ([40.107.75.111]:10560
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729819AbfDARZU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Apr 2019 13:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CbFTcilnurP0ruT1v0k+4zz6ap6NGA1uMDKreEF/GU=;
 b=uasRC64/+VPmkSG8QqPe5zNtBwXOom0jyx90IZ5NfuaacGZ0S2fqgiUPMjYUuKiSXmBZiZ6Bb1rhopmoPZ/EhTFaYKzJnydNFAkU5L52/WrXoR4FvXF+b1ugsHf9FXKUlpT/21Rjxop/YP032HSuJpI/48Np345H235zD/d8Cz8=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2606.namprd11.prod.outlook.com (52.135.91.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.15; Mon, 1 Apr 2019 17:25:11 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d%2]) with mapi id 15.20.1750.021; Mon, 1 Apr 2019
 17:25:11 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
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
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Thread-Topic: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Thread-Index: AQHU3QbotMy5xdD81UKIp8enwnpo+qYTeOyAgALI1YCAB7NUAIAAsJYAgABcGgCAANzVAIAAGGOAgAEgwICAAGCrgIABZBOAgARNRgCAAHvlAA==
Date:   Mon, 1 Apr 2019 17:25:11 +0000
Message-ID: <a09d23ef-e1f3-906a-d58f-e39b02311d1b@fortanix.com>
References: <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com>
 <20190326132650.GA31662@linux.intel.com>
 <20190326235852.GL3757@linux.intel.com>
 <20190327052830.GF15397@linux.intel.com>
 <825f5477-c90a-b54b-efeb-a1dc43ccc9d2@fortanix.com>
 <20190327200610.GF9310@linux.intel.com>
 <20190328131939.GI7094@linux.intel.com>
 <CALCETrXWMtm9WcPjbYB+ubRkb++WBYzYJAkiU-LJT_SK+m+SmQ@mail.gmail.com>
 <20190329162001.GC19448@linux.intel.com>
 <20190401100142.GB8483@linux.intel.com>
In-Reply-To: <20190401100142.GB8483@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::43) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3191e05-15e2-4876-b380-08d6b6c6fe8f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB2606;
x-ms-traffictypediagnostic: SN6PR11MB2606:
x-microsoft-antispam-prvs: <SN6PR11MB260671FA5288054152666610AA550@SN6PR11MB2606.namprd11.prod.outlook.com>
x-forefront-prvs: 0994F5E0C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(346002)(39830400003)(136003)(189003)(199004)(81166006)(4326008)(102836004)(6506007)(97736004)(2906002)(6246003)(186003)(26005)(53936002)(6512007)(6306002)(7736002)(14444005)(305945005)(71200400001)(71190400001)(31696002)(8936002)(256004)(14454004)(66066001)(7416002)(11346002)(5660300002)(486006)(966005)(446003)(86362001)(476003)(316002)(93886005)(229853002)(31686004)(2616005)(68736007)(8676002)(6116002)(106356001)(36756003)(3846002)(478600001)(52116002)(53546011)(81156014)(6486002)(99936001)(99286004)(76176011)(54906003)(386003)(105586002)(110136005)(6436002)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2606;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nOkJhVZAlolFsNfvxRhUL2ljz+oGiXjoPjzB3Vkq2L+EYu97SGgCnCBm53uebRxJBTkAX8Yv6xbEQ0wbGNTplfeWAH1wEL6Y0GzVkyg9D6gPir1m3FEiEfZ8ABmnJAxblSmcS5SRKZlGlZ3PQXDauehdmbaF/usQkpYxbLTbWJS/iPbrGly94seIKIpH+Nonej18aiwhhqatD/yRlGdk2Iicj03ULd+gAhexvuxDO3pxOOgmTZYDiJI7xR8YV6Y8H69cBHiXhgDCbzQjy9nXbrhDokc5iVxDUGUGKYvEe6G5ic8nF0+QuZ8+mrTaSn5K7/hsRhgeTW6vgqKdTLpZF/Llh5x+OPqi10D2WYfjxjzdKJVbxkYuo5WbMHzE8MgUoFIIgZmUBD3o5CQroBjJFzAVJmacRZiEJ+OaxYdYWG0=
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030506060206030103020006"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3191e05-15e2-4876-b380-08d6b6c6fe8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2019 17:25:11.3206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms030506060206030103020006
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-04-01 03:01, Jarkko Sakkinen wrote:
> On Fri, Mar 29, 2019 at 09:20:05AM -0700, Sean Christopherson wrote:
>> On Thu, Mar 28, 2019 at 12:05:39PM -0700, Andy Lutomirski wrote:
>>> On Thu, Mar 28, 2019 at 6:19 AM Jarkko Sakkinen
>>> <jarkko.sakkinen@linux.intel.com> wrote:
>>>>
>>>> On Wed, Mar 27, 2019 at 01:06:11PM -0700, Sean Christopherson wrote:=

>>>>> I agree with all of the above, but unfortunately blacklisting is re=
ally
>>>>> the only benefit that would be realized by modularizing the driver.=
  The
>>>>> "driver" at this point is just the device and its ioctls, the meat =
of
>>>>> the functionality has been moved into the subsystem proper.  And th=
e few
>>>>> remaining tidbits of functionality, e.g. sgx_encl_page_alloc() and
>>>>> sgx_encl_alloc(), probably should be moved out of ioctl.c as well.
>>>>
>>>> That is kind of core reason of having an LKM here, to wrap the uapi.=
 It
>>>> is not about reducing size of the kernel. It is about ability to tai=
lor
>>>> the uapi on stock kernels.
>>>>
>>>
>>> As I see it, there is really only one significant benefit of modules:=

>>> reducing the size of the kernel in the case that the module isn't
>>> loaded.
>>
>> This is a much more succinct explanation of what I was attempting to s=
ay.
>>
>>>   (And organizing module parameters, I suppose, but you don't,
>>> strictly speaking, need to be able to build as a module to do that.)
>>> SGX can be blacklisted by booting with nosgx (or, if if can't, then
>>> that should be added).
>>
>> The split lock detection series also proposed extending clearcpuid to
>> take flags by name, a dedicated 'nosgx' may not even be necessary in t=
he
>> long run.
>>
>> https://lkml.kernel.org/r/1549084491-57808-6-git-send-email-fenghua.yu=
@intel.com
>> https://lkml.kernel.org/r/1549084491-57808-7-git-send-email-fenghua.yu=
@intel.com
>> https://lkml.kernel.org/r/1549084491-57808-8-git-send-email-fenghua.yu=
@intel.com
>=20
> OK, that's great. Then I just rework the LKM out...

Wait, why? I don't agree with Andy's "only" reason for LKMs, and it=20
sounded like you agree.

--
Jethro Beekman | Fortanix


--------------ms030506060206030103020006
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDQwMTE3MjUwOFowLwYJKoZIhvcNAQkEMSIEIL44dDrZ
rNcY53qZyCPCkGgqY5Rywndss300+ROGi2WqMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQB+AMlCrqfqTBswniRs6p1U4FDr77CslFYjiByvNGW07y5/7k8KueLPQ/99vFMtGVwand3d
FNjA79CkDp7VaQ+901NTsexPrgQIxa1nSVQ9Bm+e/DLJexW6kr2NvnZaJYsSLZ72OC3UkzV7
/fk4O5rgKWKU/g0KDD29PFSeM0ykldSbcJ2iGtvUQJXi3H2l69r/718LhXClTQcUFsfsuA+l
GALbJOl6n1T5anD383tqdTypaFJ43YKTleVZAgKP9eFVQxVA/o8ktTDJMry1BsQrEELmBKgS
zU+q1+LGP6vtKyHtVPp0sIFY4vU38tieESX58uJbladbwgDz+JF2XsD+AAAAAAAA

--------------ms030506060206030103020006--
