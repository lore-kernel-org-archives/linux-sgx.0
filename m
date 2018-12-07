Return-Path: <SRS0=sJTe=OQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,T_DKIMWL_WL_MED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A69C07E85
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 18:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A27212083D
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 18:15:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="pTAOOyTK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A27212083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbeLGSPN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Dec 2018 13:15:13 -0500
Received: from mail-eopbgr740095.outbound.protection.outlook.com ([40.107.74.95]:6473
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726208AbeLGSPN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 7 Dec 2018 13:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vc4G5bL0cy5gsJO7vF6+XHBKufoDCH406r80pPgeEWM=;
 b=pTAOOyTKg6GwD7eDlPX2YO9kgOwkM6Y/idqaMbQVlKrm0w7GrNpuCrfbKbrv/uuLzqKRDmoPOJvDleQLJrnseVbC87dn0OYro+QjbS5Qur6+9OezdRIOUv75LyCMyKhsUXzzNxpCGge2v+KhmFYGWmMBPdZaSWpUjMXSX8RnWzY=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3021.namprd11.prod.outlook.com (52.135.125.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.21; Fri, 7 Dec 2018 18:15:04 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c%3]) with mapi id 15.20.1382.024; Fri, 7 Dec 2018
 18:15:04 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Dr. Greg" <greg@enjellic.com>
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Thread-Topic: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Thread-Index: AQHUjljGdIrv8QEhmk6icaec8mjmDQ==
Date:   Fri, 7 Dec 2018 18:15:04 +0000
Message-ID: <f2b7df05-20ef-ac16-fc99-258c39d84666@fortanix.com>
References: <20181206221922.31012-1-sean.j.christopherson@intel.com>
 <20181206221922.31012-5-sean.j.christopherson@intel.com>
In-Reply-To: <20181206221922.31012-5-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::25) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [171.48.9.28]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3021;6:oIK6EJ0BKkVrxCM7QxTOKWXYrGNLVbh84aVv8nMPVNM7/ntxbX0XYTO4Dl5XVkfINclxmYaDbdJDP8mz42v50079IKek1TcfKrniwSEES1KYhEfRGl5aKS2qDk2mDZvorVl48eptBYI6qkoYJdpA98h7UvMQ+9r0qJxAMoTRZO0835JC6Nt0GRKgpnbob1CsMYRrpjtOHWQVanto8VXn3IL6nwm5UO1rYKTn7mquOck1gDvV5QgLzIDKwPNVknFcntAnvAzeHeY7rLaYSYQuUYxm72zGwbmZ0Yzkg2jMmq7xm8XnoYkyqbe4+fguIW3zTUd+ZWWZY2SQs3/4KYL8eb8fM496U3EdppCNAZ97EueJkjV0I25Aum8515AszTo7iSWK3qJCZUKm5I/9ANViWq4UX5zAlGSSD9OEbMCyFYmdhHAGjT1ADs3LqzGgqaJKokH0kYgGv+tMaFse3lLxuA==;5:om59kw9z7HRayuL4HkbOY63ewbKzfYXLvExPay0XqMV2KUCz+sJPUe2rcYpkdo7zyEbqZN26Ms0iMC55ZPhUIrgp7/XYGd5VSTtvs1Hn8yVLFRkP2dMeAk8hIXKEqFqXQ6kf3ls4G1X4IzMGCKUvVp9YJn/g0KU/YjBmtJvYq9I=;7:7bEEbBlOm9rP/8KqafFOCmU9N0puKM9ualO3iB9X3vX3mZYkPaGKV0vd7tu0JSZYrJcoJ9h058ogrRU05Es1dTtP0lmmmyavkzWkJ3QSD5c/Ba5tVqyVCYmlmhF8lrmLM/v3xqrlSZQq7vkYqVftbQ==
x-ms-office365-filtering-correlation-id: 7658aa17-e4ca-4445-edb2-08d65c6fe8dd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3021;
x-ms-traffictypediagnostic: SN6PR11MB3021:
x-microsoft-antispam-prvs: <SN6PR11MB3021593B26064837D206DA30AAAA0@SN6PR11MB3021.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231455)(999002)(944501520)(4983020)(52105112)(93006095)(93001095)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123564045)(20161123558120)(2016111802025)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3021;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3021;
x-forefront-prvs: 0879599414
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39830400003)(376002)(346002)(366004)(396003)(199004)(189003)(14454004)(5660300001)(229853002)(31696002)(6306002)(66066001)(6512007)(71200400001)(316002)(71190400001)(256004)(217873002)(508600001)(3846002)(86362001)(8676002)(99286004)(2906002)(26005)(6436002)(7416002)(25786009)(102836004)(76176011)(6486002)(54906003)(186003)(36756003)(386003)(6506007)(6246003)(99936001)(81156014)(53546011)(31686004)(486006)(78486014)(105586002)(52116002)(4326008)(2501003)(7736002)(97736004)(8936002)(106356001)(110136005)(446003)(68736007)(53936002)(305945005)(6116002)(11346002)(476003)(81166006)(2616005)(966005);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3021;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: yxCNNqp1KUvqvtq1Sw4NTFo+aylucYglw8ne42dcd0+qwlV81XIIT+HTclDLiLm4ADSQvlbMNRXLc/K6hrf7cKAi+q/uF+Jv5v/zSyejJSSxrMr59tbgBMCo8ZqzWqOHhy79qPdxfKdhvwyGx9NUlz1DtrM0q6MtFtsJ40M3bl5/DuM+8Nx7iEBCTPVtHCKnrTUx0Ad2ty6MvR0MwTWuSKxiy1tT/qKle4R0en2dGHsZCRFfuk8gaA2VsUJCuPaIOQAOfmZr+HK33uZwiKqzglfsnJ8WvX/phmoAJlLedmyoWyh0OEH1eFf/vQytTa1YIgmxaib03QLYcrxLU1d3mY+egqfsROW9BgoOt0MgtqI=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms040004060006080700010609"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7658aa17-e4ca-4445-edb2-08d65c6fe8dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2018 18:15:04.3081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3021
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms040004060006080700010609
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-12-07 03:49, Sean Christopherson wrote:

=2E..

> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.c b/arch/x86/entry/=
vdso/vsgx_enter_enclave.c
> new file mode 100644
> index 000000000000..896c2eb079bb
> --- /dev/null
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.c

=2E..

> +enter_enclave:
> +	asm volatile(
> +		/*
> +		 * When an event occurs in an enclave, hardware first exits the
> +		 * enclave to the AEP, switching CPU context along the way, and
> +		 * *then* delivers the event as usual.  As part of the context
> +		 * switching, registers are loaded with synthetic state (except
> +		 * BP and SP, which are saved/restored).  The defined synthetic
> +		 * state loads registers so that simply executing ENCLU will do
> +		 * ERESUME, e.g. RAX=3D4, RBX=3DTCS and RCX=3DAEP after an AEE.  So,=

> +		 * we only need to load RAX, RBX and RCX for the initial entry.
> +		 * The AEP can point at that same ENCLU, fixup will jump us out
> +		 * if an exception was unhandled.
> +		 */
> +		"	lea	1f(%%rip), %%rcx\n"
> +		"1:	enclu\n"
> +		"2:\n"
> +
> +		".pushsection .fixup, \"ax\" \n"
> +		"3:	jmp 2b\n"
> +		".popsection\n"
> +		_ASM_VDSO_EXTABLE_HANDLE(1b, 3b)
> +
> +		: "=3Da"(leaf), "=3DD" (rdi), "=3DS" (rsi), "=3Dd" (rdx)
> +		: "a" (leaf), "b" (tcs), "D" (priv)
> +		: "cc", "memory",
> +		  "rcx", "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15"
> +	);

This is not sufficient to support the Fortanix SGX ABI calling=20
convention, which was designed to be mostly compatible with the SysV=20
64-bit calling convention. The following registers need to be passed in=20
to an enclave from userspace: RDI, RSI, RDX, R8, R9, R10. The following=20
registers need to be passed out from an enclave to userspace: RDI, RSI,=20
RDX, R8, R9.

You can find the ABI specification at=20
https://github.com/fortanix/rust-sgx/blob/master/doc/FORTANIX-SGX-ABI.md#=
enclave-calling-convention

--
Jethro Beekman | Fortanix


--------------ms040004060006080700010609
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTIwNzE4MTQzOVowLwYJKoZIhvcNAQkEMSIEIEjfB8ol
IDlZbKuZ6N0ABy4yh6i3nYwwgBn+IvaaQpqMMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQCcqRhBWXYm6CiX73eEE5SGZjYBWBOoF+nDgo2EN2xUaHZmDH6qMnnUewkA6Y/unQ6DtgsR
WuQ7kZcoROyIxgDJIZvJ07Vk0Al9yOCbfWKClISaejbIDknyQsfo8aX3Bb4m4aHgwrm863Tj
3GvdcKpB9K+JIMVEZtS9rOCRts70548ravgXCT07h12sDDBYTzWDmeUNqxkZQQZm/1HScpFz
LtvJ4HKOq9hkR21WY6h6Ahks83jTJRGhDmMnisYPQdvQR1ZOHWsa1PtGiJM8tTg+Xyial61A
bqwLZC7hWlkTkX1nhiu224BVoT3uWO14KJ5BDbDTWe+GFpOCm0NdWjkOAAAAAAAA

--------------ms040004060006080700010609--
