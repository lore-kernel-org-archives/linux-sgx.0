Return-Path: <SRS0=n9z9=PB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AE0C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 05:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93C7E2173C
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 05:36:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="dlz58fOp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbeLXFgb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Dec 2018 00:36:31 -0500
Received: from mail-eopbgr760099.outbound.protection.outlook.com ([40.107.76.99]:35392
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725884AbeLXFga (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Dec 2018 00:36:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvSUJNjsJ21Oz7WVheh+4NWyj9Yk29fXEzo1FVlvLt4=;
 b=dlz58fOpyEpE8mPBLWY2LUyuIjHQpkYTSqN1LdAlmfHD77oP8NX4mbIy2CK4ruryYwjAxba5TjzcBZPEiW+TRFjTxQfjYqJrfwqaAIsgL3oLA5fmJf0nAjNQ9uSZUXFiJqHHPNM7Od7XPLrhf7onb2971nIEUPL/6by19APDAa0=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3120.namprd11.prod.outlook.com (52.135.127.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1446.19; Mon, 24 Dec 2018 05:36:25 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::106d:42ec:cef3:2303]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::106d:42ec:cef3:2303%3]) with mapi id 15.20.1446.026; Mon, 24 Dec 2018
 05:36:25 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
        "luto@kernel.org" <luto@kernel.org>
Subject: Re: [PATCH v18 18/25] x86/sgx: Add the Linux SGX Enclave Driver
Thread-Topic: [PATCH v18 18/25] x86/sgx: Add the Linux SGX Enclave Driver
Thread-Index: AQHUmYL7bAQLb96MwEucoDXYT4SaF6WNYiUA
Date:   Mon, 24 Dec 2018 05:36:25 +0000
Message-ID: <303abbae-2c40-9ee4-6bc1-8848ad1850cd@fortanix.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
 <20181221231154.6120-19-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181221231154.6120-19-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR01CA0153.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::33) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [14.143.179.162]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3120;6:eyroSybLooamxM6W5CiGLjrmJWCK8A8NF5YXd7up5qSAPXtGi/7MNr6jLHb9/F9Jn0FCcrutpDOHUUwSG6/n2b1P4dQ+2LvXTghbsypPIlyk8j7tPxn6hQ68yXFAkgKw1arWv56f7q2MAxQd2vIHl7m/ma2sLnvfB2XG98tfOiF6e7H0b5LbBJw8Z4MBgjlMBA5GEVEfItlJSfMfwnseJ6bUq4OWt5kyDuVoj7Ct1LQCI5H5Xr/jdlWcpakqssnDUtJJ028n3WvhaXQuofT8YmHww2zoB2NqLnwkP3e9ckBw9EWeAU/MoK83nlkdbDYOBV+bnIwY2VBXWEI8WDasuMlh12f2QuJUcO6QO0sOE3H61UzMTOmbGAVzNKsJVueNPjyNHooVli6GOuVXqc+P1Rwkap7ZDuKl3h1blIXe8ez+1TX5a5/q+NY+xYoM0shYHlxIpUxd9KO03fYy6IqeIw==;5:TSbepIkwQu4bhuHNSD4KnwoviATqY54Or0Bv6IyKVAvqWYNQPDiZIgdpIUKN4ahy3mE1Co0EEBtKnfWvDYxAOwi/V1z4JkAW6FMKjOb6dc08LlR6yYTtRcQSPQdbmPBbMp2VMXMq3ODMC/HSNwzFmuO1/PfPXTeVcTvY6r7eS48=;7:I0OQbwPEk2eAxGCYHfqcg4+3V5u0d4lt+rwO9Vm7/Ix8UIVRJQIamwBZJbAqQgjTgdbqG1z0Ns4k9zwDto6TMitYwr4aPBA83aOZSDSWzE6XhGqsM/Af0TsNuL9CGkZwegUDvJwfFkoNbBN2xjYiQA==
x-ms-office365-filtering-correlation-id: 207a818a-9720-4af6-ac37-08d66961be85
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3120;
x-ms-traffictypediagnostic: SN6PR11MB3120:
x-microsoft-antispam-prvs: <SN6PR11MB31201A799F7AD80E9F4E77A3AABB0@SN6PR11MB3120.namprd11.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(908002)(999002)(5005026)(102415395)(6040522)(2401047)(8121501046)(3231475)(944501520)(4983020)(52105112)(93006095)(93001095)(10201501046)(3002001)(6041310)(2016111802025)(20161123558120)(20161123560045)(20161123562045)(20161123564045)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3120;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3120;
x-forefront-prvs: 0896BFCE6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39830400003)(396003)(346002)(376002)(366004)(189003)(199004)(31696002)(25786009)(6116002)(110136005)(14454004)(3846002)(81166006)(7416002)(106356001)(76176011)(99286004)(36756003)(54906003)(52116002)(105586002)(5660300001)(2501003)(508600001)(68736007)(78486014)(7736002)(305945005)(8676002)(81156014)(8936002)(316002)(4001150100001)(97736004)(6506007)(386003)(31686004)(102836004)(55236004)(26005)(186003)(476003)(11346002)(446003)(4326008)(2616005)(53936002)(6436002)(229853002)(86362001)(6486002)(575784001)(6246003)(99936001)(256004)(2906002)(66066001)(71200400001)(486006)(2201001)(6512007)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3120;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WA58nonNYKwsDDI2QC0P966uuviFOEEFn5gqvJh0wNay1agJEPsd8icbJ8Hf/9jm8ho0fNlkBmSE9zwJSTG5ppHuHmzF6TOaWTbxUGFx+2B4aVLqs2ls59z5/pCKIWrCcmjLmmwYalY6bo/fsq75BNoQXrH4FvvxTLXWPWly1TMtYUj+l7k8oB8MHbqcA9CxTg8Sc66oImS5dAa0Ve3MGEsbSOqOMo0pKL2Suu8vytHddwWIY/R7rRhWUdYM5dg5sQ647K5+dIHZVD4Ez0ExMSVPlsHwfhZlbZgyrIkgll6aFpGrHKLVLV23GtxAV//B
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050301020601030201040204"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 207a818a-9720-4af6-ac37-08d66961be85
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2018 05:36:25.2117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3120
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050301020601030201040204
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-12-22 04:41, Jarkko Sakkinen wrote:> diff --git=20
a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> new file mode 100644
> index 000000000000..aadf9c76e360
> --- /dev/null
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +/**
> + * Copyright(c) 2016-18 Intel Corporation.
> + */
> +#ifndef _UAPI_ASM_X86_SGX_H
> +#define _UAPI_ASM_X86_SGX_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +#define SGX_MAGIC 0xA4
> +
> +#define SGX_IOC_ENCLAVE_CREATE \
> +	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
> +#define SGX_IOC_ENCLAVE_ADD_PAGE \
> +	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
> +#define SGX_IOC_ENCLAVE_INIT \
> +	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> +
> +/* IOCTL return values */
> +#define SGX_POWER_LOST_ENCLAVE		0x40000000
> +
> +/**
> + * struct sgx_enclave_create - parameter structure for the
> + *                             %SGX_IOC_ENCLAVE_CREATE ioctl
> + * @src:	address for the SECS page data
> + */
> +struct sgx_enclave_create  {
> +	__u64	src;
> +};

Documentation should specify which SECS fields should be passed by the=20
user and which fields will be filled in by the kernel.

--
Jethro Beekman | Fortanix


--------------ms050301020601030201040204
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTIyNDA1MzYxNFowLwYJKoZIhvcNAQkEMSIEIKfvkAQZ
lL51xjo2X138RMAiBq0FioBlfZf5n8R9X6zoMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQBewVj0Xfe/XSqBAWD6uWINOEtkysN3QrBLAkmA1GKKANTLv7B1So3bzua4NuzdsKiarSYz
O6SCn1Bfih1J4yQT9W390quXxEVcPfUrHLGRjdgoValFikYS5wEKb3OWVVCq+REciSYP4ZQd
MPjA1t/P3Z1ZDT65zK1PT4tP19Hz06IUrzLv5CyZ2x1SKxj7C33CiadLfM3IAU9ye2VJeJpa
jOKbTx06AEJRNCyI6QdTTDxELnbBLcEL58KDNBfcRz0F10AczNYZCi3ICvscFgmSi4jgpMjb
c3MLGW2MwL88dgHS9zTKBIvIkvEAoTM1ge9rio6Zz4kPu+MY5ri8YNQaAAAAAAAA

--------------ms050301020601030201040204--
