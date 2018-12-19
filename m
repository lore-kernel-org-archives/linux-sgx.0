Return-Path: <SRS0=HOZE=O4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63420C43387
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 08:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1931E2054F
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 08:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="Yc5PHDjg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbeLSIlS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Dec 2018 03:41:18 -0500
Received: from mail-eopbgr710103.outbound.protection.outlook.com ([40.107.71.103]:31616
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbeLSIlS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Dec 2018 03:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Gd9XFx1UUQ042djCxN5mNP3i5U2+Zlp4k/LMw4k+wo=;
 b=Yc5PHDjgcDP+mtoxSN5jHPDHrSSIF70+y4wFLxW35HWi9Kx3v1i169+rv5mSMwixbiKjf6EbPNSN6fo3OZT7qLhLGsiXTBf77GSAXl6VZZbYwxyTMsfY4x/mQGmhlkMPOVHnhhTi06o7MLBj21UAyJwu1x3awuICt6dz2A0wDpo=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3376.namprd11.prod.outlook.com (52.135.110.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1446.19; Wed, 19 Dec 2018 08:41:12 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c%3]) with mapi id 15.20.1425.024; Wed, 19 Dec 2018
 08:41:12 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
CC:     "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: x86/sgx: uapi change proposal
Thread-Topic: x86/sgx: uapi change proposal
Thread-Index: AQHUl3Co+wqDa0VeJE+ysGhRrrse2aWFvkEA
Date:   Wed, 19 Dec 2018 08:41:12 +0000
Message-ID: <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
In-Reply-To: <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR06CA0212.apcprd06.prod.outlook.com
 (2603:1096:4:68::20) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [14.143.179.162]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3376;6:jCsLv9x/4CnxTYIY61IQxTNwQv2p3HSaqjI22x+J4uy6iC4KAE/jKjBbtYl3PJjLfQG4F0ppI2boXEGxdvDBvX2iEs+H6eYvxV+yfF4UblBvWn9vhxTN/O6vKq161pJKp0+ehwlHJCsEaMcO8PnMUfRNPzlNxDM86mjsz9m3MTYr5DreSmrjk7it1uENYBj3m1AU4wcWp3K5abhV1nQ6MK6HW2EN6eGiKqmEQujd9vwd3o9aOWCF7acotzZvCSE/rzBP2N+QjcIjKjyOIQKhaDfxPE4JlONUWuNWUrNiBD0Bx61qVwKAhG1whnIWQgDmlAWRAgPbSMckSFlqW6EjU4BCWnUEeO4LRBnRvDM07ZDlkuLU23bieDnf1ktr5mn5pFHm/mOJqVhE2HJ2cdcNxMNs0LKirK1CTvAOJvyLbqmXWlBMXEnHQNs6oadd1Hq9ZlqVfuqbEE2WTBlPAErPZQ==;5:4ZwzTCB1I//MjmlkwEQM07NeiCiSbpjyIyDlXPhIjIKwOeA3mllttUT/1B63bKMfNLy60mES60F4uoO3tBJBl8ymYCLP6gxhRB0HWdlPAY9xFG62+N1av4O6gfRDwrDzp0RwOISaqSLh8CTbqabxxtsRC8ZMg53VplJrJHIrBWg=;7:IisBYeVpMvZYW849yHFUv7y0RPRtXaqFhjqsv/uj0hh9VIaFyFbGEwBBuO9LzADEnZesq/zVqgUE/BD38Eg6d2Z2oqy6KRRuuQPizg99t2NdjVg6AmJn7augD2HCM8Joem1o/Uq7gPp0RQMxjGVj1g==
x-ms-office365-filtering-correlation-id: fae925c3-e61e-4060-6b9d-08d6658dbaf1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3376;
x-ms-traffictypediagnostic: SN6PR11MB3376:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-microsoft-antispam-prvs: <SN6PR11MB3376006B18CA68EFC0C81D9EAABE0@SN6PR11MB3376.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(999002)(5005020)(102415395)(6040522)(2401047)(8121501046)(3231475)(944501520)(4983020)(52105112)(93006095)(93001095)(3002001)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123564045)(20161123558120)(2016111802025)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3376;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3376;
x-forefront-prvs: 0891BC3F3D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(39830400003)(396003)(136003)(199004)(189003)(102836004)(6506007)(55236004)(53546011)(26005)(76176011)(386003)(52116002)(71190400001)(8936002)(71200400001)(81166006)(81156014)(6436002)(8676002)(4326008)(6246003)(6512007)(3846002)(78486014)(31686004)(53936002)(229853002)(106356001)(105586002)(7736002)(6486002)(6116002)(2501003)(5024004)(14444005)(256004)(31696002)(14454004)(305945005)(575784001)(86362001)(2616005)(4001150100001)(446003)(97736004)(11346002)(5660300001)(7416002)(476003)(486006)(2906002)(99936001)(68736007)(66066001)(186003)(25786009)(99286004)(508600001)(316002)(54906003)(110136005)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3376;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: BFToEZJbN6zXH09zpPwtJpsbSUm++o0Mdutt7LA2DKTTKremuDvLk1SPpv8Oc3vO/SvD3KhMhiXRpCIdcxDW5YWc3Kt+RuUucNkcWXlwi/Mfm1PydgcBjbp3H+XM/lQOvRYYH2aF0DNtBQXcdjK/uaOs5cFKlSHI2HKalm8M5CV+S3i/YOqIN77+jBcM4cdPSDZWt4loA8JXRscsq0JRTa7JMZ7vbQnH7aH49K5WiNWcpQ2vX8IdrI7HjsJctOYB5RkiAzfWisAYOEbgkrpNTBuLgfBIhvn4igcpghVnEvkzCaWb8UTjAHrNQxLmm2Z0
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050300020606090704060703"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fae925c3-e61e-4060-6b9d-08d6658dbaf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2018 08:41:12.3313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3376
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050300020606090704060703
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-12-19 13:28, Jarkko Sakkinen wrote:
> I have pretty much figured out how to change the driver implementation
> from VMA based to file based. Most of the code in the driver can be
> reused with not that enormous changes. I think it is a clue that the
> architecture is somewhat right because changing the driver this
> radically does not seem to require any changes to the core.

One weird thing is the departure from the normal mmap behavior that the=20
memory mapping persists even if the original fd is closed. (See man=20
mmap: "closing the file descriptor does not unmap the region.")

> Using anon inode is the right choice because it is more robust interfac=
e
> to be able to create multiple enclaves.
>=20
> The only remaining open that I have when it comes to implementing this
> is the backing storage. From API perspective the most robust choice
> would be to revert to use shmem file. It would be easy then to create a=

> complete construction flow without any dependencies to mm_struct.
>=20
> I do recognize the issue with accounting but to which process the
> backing storage should be accounted anyway in this new paradigm.
>=20
> I've attached the new uapi header to this email that I'm going forward
> with.
>=20
> /Jarkko
>=20
> sgx.h
>=20
> /* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> /**
>  * Copyright(c) 2016-18 Intel Corporation.
>  */
> #ifndef _UAPI_ASM_X86_SGX_H
> #define _UAPI_ASM_X86_SGX_H
>=20
> #include <linux/types.h>
> #include <linux/ioctl.h>
>=20
> #define SGX_MAGIC 0xA4
>=20
> #define SGX_IOC_ENCLAVE_CREATE \
> 	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
> #define SGX_IOC_ENCLAVE_ADD_PAGE \
> 	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
> #define SGX_IOC_ENCLAVE_INIT \
> 	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> #define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
> 	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_set_attribute)
>=20
> /* IOCTL return values */
> #define SGX_POWER_LOST_ENCLAVE		0x40000000
>=20
> /**
>  * struct sgx_enclave_create - parameter structure for the
>  *                             %SGX_IOC_ENCLAVE_CREATE ioctl
>  * @src:	address for the SECS page data
>  * @enclave_fd:	file handle to the enclave address space (out)
>  */
> struct sgx_enclave_create  {
> 	__u64	src;
> 	__u64	enclave_fd;
> };
>=20
> /**
>  * struct sgx_enclave_add_page - parameter structure for the
>  *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
>  * @eclave_fd:	file handle to the enclave address space
>  * @src:	address for the page data
>  * @secinfo:	address for the SECINFO data
>  * @mrmask:	bitmask for the measured 256 byte chunks
>  */
> struct sgx_enclave_add_page {
> 	__u64	enclave_fd;
> 	__u64	src;
> 	__u64	secinfo;
> 	__u16	mrmask;
> } __attribute__((__packed__));

Wouldn't you just pass enclave_fd as the ioctl fd parameter?

How to specify the address of the page that is being added?

>=20
>=20
> /**
>  * struct sgx_enclave_init - parameter structure for the
>  *                           %SGX_IOC_ENCLAVE_INIT ioctl
>  * @eclave_fd:	file handle to the enclave address space
>  * @sigstruct:	address for the SIGSTRUCT data
>  */
> struct sgx_enclave_init {
> 	__u64	enclave_fd;
> 	__u64	sigstruct;
> }; >
> /**
>  * struct sgx_enclave_set_attribute - parameter structure for the
>  *				      %SGX_IOC_ENCLAVE_INIT ioctl
>  * @addr:		address within the ELRANGE

Stray parameter in docs

>  * @eclave_fd:		file handle to the enclave address space
>  * @attribute_fd:	file handle of the attribute file in the securityfs
>  */
> struct sgx_enclave_set_attribute {
> 	__u64	enclave_fd;
> 	__u64	attribute_fd;
> };

What is this for?

>=20
> #endif /* _UAPI_ASM_X86_SGX_H */

--
Jethro Beekman | Fortanix


--------------ms050300020606090704060703
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTIxOTA4NDEwMFowLwYJKoZIhvcNAQkEMSIEIENOhRea
lbFnOUzzfWNk5cMCmdjDoEG+r46nRWOBSGZKMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQCmVSCl8g+5qwTQ5pWls9g7QJAKcXe1rDAb/HBrHUeM+9wMa1nvEtix6wmo8nI08SzLSwTs
y/YRicq6aXIR8sWA6b3JucgvZHeyqbBZErJULlYq33OBvlhNsn73csYyHvIz0uHNG51v5546
f9HX1QM0y7tS26wAsiuXamaKRGP1MpF/VCHLkx5WE8WTB0wHinLhxCUpV+zVi+rHAD9lI3d7
dgljRlvvz851o7srkF5MJfQSCOdS9U9m/3PKa1lmn2Vc4/WiGz5K6myIgsCGzCY98YIAmdx+
M6NExNDtEMapcqrwsMZw7KZ13zaFxnJZeyLKdxcej50Jaxfm4kYe69+BAAAAAAAA

--------------ms050300020606090704060703--
