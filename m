Return-Path: <SRS0=l2ne=WD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFB4C19759
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 06:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BD88214C6
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 06:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="TvwdNgMx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfHGGdh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 02:33:37 -0400
Received: from mail-eopbgr740099.outbound.protection.outlook.com ([40.107.74.99]:28512
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726734AbfHGGdh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 02:33:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2R8GX6ATIzL9O0UftG8U9wDi/VOaFYcNyk3bbxir+B1PfDKYYgqUkW1ogwzlgliP4AG6yizRKfOIzUIAciijbDDqOQNh6QaVPo/ODc8r37XT9p2SMFVl2Vtdz+Su85r1YoGspkKAoAfSD9I7kD7TJCExDlBYRGLlTyk3EUuGMXB6c/B1zbO3l498isy9iNyWTSy1KxIdE3a24p6r8CArhlmnirLqWkEOI8J1Xw8w7EYcxN3TUP15mY8OkktmEa3k74xDoxlFEoCoWYH2PexKa6NpvVH3tAIHwi6SpPHFPEZ+VZmYos35foYuevb1qmkGI2jzrskF3mf9qieCgZmtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ov8jvhmw1UJenhQ4i4J8UWW8D/uxgTpfm1JgbKAZa9k=;
 b=VRxXqw3RobQ6LDPU0gXmppeN1qDBBo5gGylFpi68Rwuw2XD/rpqyyrUKgO0GvM2s+RI2aTrmCqmhIyu1DFR+CZ6BGKGQSDla5r6tYE2FBGImBSTs2XjQNc6riT8/ICdzu9IOXO+RpESI0YBI5FJv+w1xjNv1lSNf9uy5A/Lbj1mZ0H9/cpDqnAxAGZqDD0cBwGE/qFmgQ8umpRR5uTSU5/HbFq+9HwN2zS1WopMqQ7io4gP2HXDd1K7g0ehAuxbMzNUEBJD7Qe1qLri3GGHqU1OXW9OOpy5inS++pI/p6CvaBH4tFDazzsSdQmFBNgNo/Q+0xU3X9z/CUZx7PdLfVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ov8jvhmw1UJenhQ4i4J8UWW8D/uxgTpfm1JgbKAZa9k=;
 b=TvwdNgMxKzj4YiB16+YB7HcPMOHKbvFLCWM67pgPymPC3bnhnbA0x/qBWHWMnw0tp1OUzJtk2HNwNhTvfnQsTXvMzjjjyw1QXMH7XxM6T1b8sco/5Q7t9YtpBgYzq9crJ7RBdc1p8mdQ3Qa0WJnaozv7uS2KLuit0slO17QLhQE=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2558.namprd11.prod.outlook.com (52.135.91.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Wed, 7 Aug 2019 06:33:32 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::bd32:8938:dba:9379]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::bd32:8938:dba:9379%5]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 06:33:32 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
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
        "cedric.xing@intel.com" <cedric.xing@intel.com>
Subject: Re: [PATCH v21 18/28] x86/sgx: Add swapping code to the core and SGX
 driver
Thread-Topic: [PATCH v21 18/28] x86/sgx: Add swapping code to the core and SGX
 driver
Thread-Index: AQHVOZ4NAiOFPCgCukiMmtKAFgXQyabvYNqA
Date:   Wed, 7 Aug 2019 06:33:32 +0000
Message-ID: <ba0aa229-d764-4e26-5de3-044fe28ddf61@fortanix.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-19-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20190713170804.2340-19-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR17CA0035.namprd17.prod.outlook.com
 (2603:10b6:208:15e::48) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.58.43.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a976e662-eca9-4ee4-b89d-08d71b012aa1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:SN6PR11MB2558;
x-ms-traffictypediagnostic: SN6PR11MB2558:
x-microsoft-antispam-prvs: <SN6PR11MB2558BC07C6B2EF2ED42D37E0AAD40@SN6PR11MB2558.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(39840400004)(366004)(376002)(189003)(199004)(36756003)(446003)(31696002)(53546011)(6506007)(14444005)(386003)(256004)(53936002)(76176011)(8676002)(508600001)(66066001)(2501003)(7416002)(14454004)(68736007)(86362001)(186003)(81156014)(6512007)(81166006)(8936002)(486006)(2201001)(4326008)(26005)(6246003)(2616005)(476003)(11346002)(6486002)(229853002)(102836004)(6436002)(316002)(99286004)(54906003)(71200400001)(71190400001)(110136005)(66946007)(66446008)(64756008)(66556008)(66476007)(66616009)(305945005)(7736002)(5660300002)(52116002)(31686004)(99936001)(3846002)(6116002)(2906002)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2558;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dgCYXKLVaoJihrTmjruw94wxu6GT+5cr32C/bqOogG4q1pUckDFDO9XmXG6NpAJrkFfNjo2fI31WjmNpPwq7Y45SZzubpHYpcOnDuCtpRIaXj2d95GV135OMJx1r5cV7wBetngjNzEkZOeokp5iaiti6lqAsDAFTjXLvvDm8THFfD4xNrBeNLE3ry+FXXh61mvbaTLjPd2OwK+r4NGdvR2r+jA+xdest7M6vq6bYDiqApGp5yrRaZfDFU8VazMJVP4ucpDB5GRg0x+RH8VQLAOh1xRXhBnhuVjkJ6d01QSellEPU2WsWxGjiXExmW7HlQ1lY8DPw0fP8xX09E05JmLOSri/tLHwYgu2Ex2mblGpQ9gKbBpstqYaaYVI5SNuJWziqlKhemUctdlXosveaYAHD1nRYYACNkQyVIenBl6w=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010005060905030001000302"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a976e662-eca9-4ee4-b89d-08d71b012aa1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 06:33:32.4850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jethro@fortanix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2558
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms010005060905030001000302
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-07-13 10:07, Jarkko Sakkinen wrote:
> Because the kernel is untrusted, swapping pages in/out of the Enclave
> Page Cache (EPC) has specialized requirements:
>=20
> * The kernel cannot directly access EPC memory, i.e. cannot copy data
>    to/from the EPC.
> * To evict a page from the EPC, the kernel must "prove" to hardware tha=
t
>    are no valid TLB entries for said page since a stale TLB entry would=

>    allow an attacker to bypass SGX access controls.
> * When loading a page back into the EPC, hardware must be able to verif=
y
>    the integrity and freshness of the data.
> * When loading an enclave page, e.g. regular pages and Thread Control
>    Structures (TCS), hardware must be able to associate the page with a=

>    Secure Enclave Control Structure (SECS).
>=20
> To satisfy the above requirements, the CPU provides dedicated ENCLS
> functions to support paging data in/out of the EPC:
>=20
> * EBLOCK:   Mark a page as blocked in the EPC Map (EPCM).  Attempting
>              to access a blocked page that misses the TLB will fault.
> * ETRACK:   Activate blocking tracking.  Hardware verifies that all
>              translations for pages marked as "blocked" have been flush=
ed
> 	    from the TLB.
> * EPA:      Add version array page to the EPC.  As the name suggests, a=

>              VA page is an 512-entry array of version numbers that are
> 	    used to uniquely identify pages evicted from the EPC.
> * EWB:      Write back a page from EPC to memory, e.g. RAM.  Software
>              must supply a VA slot, memory to hold the a Paging Crypto
> 	    Metadata (PCMD) of the page and obviously backing for the
> 	    evicted page.
> * ELD{B,U}: Load a page in {un}blocked state from memory to EPC.  The
>              driver only uses the ELDU variant as there is no use case
> 	    for loading a page as "blocked" in a bare metal environment.
>=20
> To top things off, all of the above ENCLS functions are subject to
> strict concurrency rules, e.g. many operations will #GP fault if two
> or more operations attempt to access common pages/structures.
>=20
> To put it succinctly, paging in/out of the EPC requires coordinating
> with the SGX driver where all of an enclave's tracking resides.  But,
> simply shoving all reclaim logic into the driver is not desirable as
> doing so has unwanted long term implications:
>=20
> * Oversubscribing EPC to KVM guests, i.e. virtualizing SGX in KVM and
>    swapping a guest's EPC pages (without the guest's cooperation) needs=

>    the same high level flows for reclaim but has painfully different
>    semantics in the details.
> * Accounting EPC, i.e. adding an EPC cgroup controller, is desirable
>    as EPC is effectively a specialized memory type and even more scarce=

>    than system memory.  Providing a single touchpoint for EPC accountin=
g
>    regardless of end consumer greatly simplifies the EPC controller.
> * Allowing the userspace-facing driver to be built as a loaded module
>    is desirable, e.g. for debug, testing and development.  The cgroup
>    infrastructure does not support dependencies on loadable modules.
> * Separating EPC swapping from the driver once it has been tightly
>    coupled to the driver is non-trivial (speaking from experience).

Some of these points seem stale now.

--
Jethro Beekman | Fortanix


--------------ms010005060905030001000302
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDgwNzA2MzMzN1owLwYJKoZIhvcNAQkEMSIEIDmvvszq
ZlLmq23PG63UdwzLkt3ZXuitDPmhw85xWG4QMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQB7j4/tdYcTz7+bwv+BscUT3/APTgmJuQEx9gOjbMogI8BQpB5rMw/Qdap842cwpG7iQjm8
6naU8lLshbUOEUfInOzLAaM0UWfL8m0JXpkeOOciRWRFRx6T6SLQTZlVrCbqzbKArygvxXEz
XXEtLJzTAk4Wwm+yn2iIgvIhhDaSrE3LbtIxdNP3PxLYDUOm4r6XmGQ/mF1tEj7tPQl4rgL9
+q3cnZlxSxRTaXn1smGW58BN9WOfUVnYn2m6Yv7ElfLM8Zgalrfy8Gc6WdCDNDeZp+5f6dEL
2wMJha9pKGCDM3QIVjrPTKJE5y+lbIbWJqcWfJU5pQfR8sI4pk52LEq2AAAAAAAA

--------------ms010005060905030001000302--
