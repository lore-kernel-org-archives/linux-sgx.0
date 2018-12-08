Return-Path: <SRS0=HX43=OR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75853C04EB8
	for <linux-sgx@archiver.kernel.org>; Sat,  8 Dec 2018 08:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17ABE2083D
	for <linux-sgx@archiver.kernel.org>; Sat,  8 Dec 2018 08:15:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17ABE2083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbeLHIPn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 8 Dec 2018 03:15:43 -0500
Received: from mail-eopbgr730102.outbound.protection.outlook.com ([40.107.73.102]:49504
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726103AbeLHIPn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 8 Dec 2018 03:15:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOcb2W4ENDcDtYykc3nB7GPtpO7zjhW0kwHbUkBrdjA=;
 b=NGZStG7IebHBJ9Zf8kl7lNZ/2n/slyhoHtgqcTdJyKFZRMRhjb8YSQ4z715A1hxsAIiEAy5rt3zWNGZ1lRaedp4pTg+bmSz8bb7BzppQR3wjpKkaoe5p1hHqf/mdq5iz/Ucd5pgEsJAqoKrJ3GmOmW79fpdK9MbD3J8NNnmMPXI=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2815.namprd11.prod.outlook.com (52.135.93.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.22; Sat, 8 Dec 2018 08:15:38 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c%3]) with mapi id 15.20.1404.023; Sat, 8 Dec 2018
 08:15:38 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
Thread-Index: AQHUjljGdIrv8QEhmk6icaec8mjmDaVznP6AgADio4A=
Date:   Sat, 8 Dec 2018 08:15:38 +0000
Message-ID: <f595c046-682c-0d4a-ce68-44d4634cedf2@fortanix.com>
References: <20181206221922.31012-1-sean.j.christopherson@intel.com>
 <20181206221922.31012-5-sean.j.christopherson@intel.com>
 <f2b7df05-20ef-ac16-fc99-258c39d84666@fortanix.com>
 <59c989a1-e699-9665-780f-6dd263f41ce4@intel.com>
In-Reply-To: <59c989a1-e699-9665-780f-6dd263f41ce4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::28) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [122.166.155.231]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB2815;6:zxPjEbFtSTBkJ/JSLl+Vz0B9nsQITfYxrDPLIGsW2viH4pWYvcaACyKzs7imTNs/pvzZuSG/Hn1fjWDX7vPX4GsHXXmXuqhwfnPALQ16G6000gG73KrsnfZsaOc/qxmz890RapRPP9BI34HJMMy7zXjdFCyWFr5o0zBFq4MJXI/Od1tB3xiZszBv52t7FET2G3ixhA7b+nsssoC5GbDChKHHpM+IMQPxZTJlIz1t3l0HXaXNaO7STUhBmz6RLggTxTkBlecwxbSdpE1CdPKOlAtejSWG1d/IoSif2yvOrFKVD/15eUB/Ki4EuSQWXKVLj0chlj96OgRqtpfFevbJ0mYQGC/2hWTYTMA8VHobV7EXSh878QVmxqkj4lagUwBwWqsRL4Ae4zJE0lMlH+HQ0rSUa0Jm/7aug3xJesKCh15OsXYfv7Ua10Gtl10EYrfymLkVqu6oRzA4uDgVSLpA6g==;5:1RfA6SOf7+v7g7OwXfj3LCCaASUkiqTzumBOGF/fcDp95LbGrxX5ztRsdIpuKyjBbxJaA0A2havPhjV7mXGHan8zuDRM+YsSJNA/vC0jbzwvO+sAf741E8RSTAefMmr3fZCc3BCfx7o+AKwpUOftIcu/BGZdSqwx6FxphiijyAU=;7:EC1J9vuFkzW1HbTNSgtX4eqX/HYD6eEQlWfCcqlSgbvonVQZjH7CeGQL/XzbrNvLTAGa4zqJfm9bdVMzx7HnJ4qHlaUFL+W1iqq00G/1oPDrG4lGRwPT6YbMH0CrdnOxlclm7o8nkuPdD3KFCmdI9g==
x-ms-office365-filtering-correlation-id: fbf8a607-31cb-47b3-55e7-08d65ce555b8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB2815;
x-ms-traffictypediagnostic: SN6PR11MB2815:
x-microsoft-antispam-prvs: <SN6PR11MB2815BD2867D2652094E13833AAAB0@SN6PR11MB2815.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231455)(999002)(944501520)(4983020)(52105112)(93006095)(93001095)(10201501046)(148016)(149066)(150057)(6041310)(20161123562045)(20161123560045)(20161123564045)(20161123558120)(2016111802025)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB2815;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB2815;
x-forefront-prvs: 0880FB6EC1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(136003)(396003)(39830400003)(189003)(199004)(45074003)(68736007)(25786009)(102836004)(53546011)(6506007)(486006)(7416002)(476003)(31686004)(6116002)(52116002)(8936002)(66066001)(217873002)(93886005)(508600001)(5660300001)(76176011)(99936001)(316002)(6486002)(4326008)(229853002)(3846002)(386003)(2906002)(186003)(53936002)(6512007)(6246003)(97736004)(54906003)(26005)(14454004)(71200400001)(110136005)(6436002)(31696002)(446003)(8676002)(71190400001)(305945005)(2616005)(81166006)(81156014)(106356001)(105586002)(256004)(36756003)(99286004)(2501003)(7736002)(86362001)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2815;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: WtzsMDQ599qygnDSfiFyqLytMZOcDi/MxSTt7WbBWHtc44JjPY3ZUzN5odejddq54BrNW0FCyNmQB+iv6B9HHG9zaKE1uhhnV1lHHZ/lkG/0Wq2d3r2QV6nrcN2xuAAgxzUBgQ0Uk6jnCorTTVTr7jfo5aqpkITsUaggK0gnPuai6ssnRAJbg3nnufW53nWfhEdc1yx4L0AGnQyuOg6zmoqi3VI3ZAEjY1Wj/UDCUtllO6a1XyC2hVkheH/wuXhOUl3ZSVUr6u50AcRR/AbQkpgUdm3xWG1/u3aGG95CyDCJR7UoaJ6CoFRjesGTO/z3YHrGw2b3mmwMG2cSk5Y7U0vrvmGBzHHFRL1p1+FkjHk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020508090705090307070409"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf8a607-31cb-47b3-55e7-08d65ce555b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2018 08:15:38.5651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2815
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020508090705090307070409
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-12-08 00:14, Dave Hansen wrote:
> On 12/7/18 10:15 AM, Jethro Beekman wrote:
>> This is not sufficient to support the Fortanix SGX ABI calling
>> convention, which was designed to be mostly compatible with the SysV
>> 64-bit calling convention. The following registers need to be passed i=
n
>> to an enclave from userspace: RDI, RSI, RDX, R8, R9, R10. The followin=
g
>> registers need to be passed out from an enclave to userspace: RDI, RSI=
,
>> RDX, R8, R9.
>=20
> Are you asking nicely to change the new Linux ABI to be consistent with=

> your existing ABI?  Or, are you saying that the new ABI *must* be
> compatible with this previous out-of-tree implementation?

What's being discussed here is one of the alternatives for SGX fault=20
handling, meant to improve the current status quo of having to use a=20
signal handler.

I'm merely providing a data point that the currently proposed solution=20
is not sufficient to support current use of the (ring 3) ENCLU=20
instruction. You might find this useful in determining whether proposed=20
kernel features will actually be used by users, and in further=20
developing this solution or other solutions to the fault handling issue.

If going with the vDSO solution, I think something with semantics closer =

to the actual instruction would be preferred, like the following:

notrace __attribute__((naked)) long __vdso_sgx_enclu_with_aep()
{
	asm volatile(
		"	lea	2f(%%rip), %%rcx\n"
		"1:	enclu\n"
		"2:     ret\n"
		".pushsection .fixup, \"ax\" \n"
		"3:	jmp 2b\n"
		".popsection\n"
		_ASM_VDSO_EXTABLE_HANDLE(1b, 3b)
		:::
	);
}

--
Jethro Beekman | Fortanix


--------------ms020508090705090307070409
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTIwODA4MTUyMVowLwYJKoZIhvcNAQkEMSIEIO53I7Um
bLjolm5L8pftPOnttD+QlteWG2wn0C9h53dSMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQBEvnR5NFa62R1pCGQl1eCUMDgDGpXudzw2mE10o1MXn/R5Y2DYwDyeCPpif/jVUdeOycqh
Zsa8TugUHuzkatL+qWST4QIIZVYPQo+FszcjVicxNGaifcqqTH6w/+yjzlpW0xaaVR4R0Okp
W/8PBR8nLdlH7gjbKQ1R8qYBUDRzLjdV9HVAs3U2Ej4DLA+T8heyeCVk+U/lJgt4pg/74APC
ya4b5oi7l/avHjQwuuQobxnNKRkA0kla6ZgRu8fBC5S9dKFAZE1npBEHmZ9pwdTqIKRORThm
veK03JAQl8oARY2GQ5RXIDLPdMFjQTciJswjooP+pPKktLBxIpAbF3afAAAAAAAA

--------------ms020508090705090307070409--
