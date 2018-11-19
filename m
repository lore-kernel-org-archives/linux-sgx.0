Return-Path: <SRS0=RM7e=N6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D37C43441
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 17:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B89D2145D
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 17:39:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="LGGJaZGe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B89D2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389806AbeKTEDf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:03:35 -0500
Received: from mail-eopbgr720134.outbound.protection.outlook.com ([40.107.72.134]:35384
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389750AbeKTEDf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Nov 2018 23:03:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7ujoqdKcarEL5alv0qdvwgLvfHyk1KqcAPbt4JrprY=;
 b=LGGJaZGecCHI6dH671qm/cKp+QLdBD6C+15DIXmTqYZuHiAEkHicxQ5zXBSjL8uMG6bG0zcSCTK8rO3IzYCx6M4t6GUV+sR66KE7uNxj3Aja+Vbd6Jbotx4ao4dmU4A8pXG4n74cBJzLy8DkFHb6iUfnIbqaEPoWcfqY9bVK+ws=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3469.namprd11.prod.outlook.com (52.135.112.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.23; Mon, 19 Nov 2018 17:39:04 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::4cee:6f2d:f3c2:cac7]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::4cee:6f2d:f3c2:cac7%3]) with mapi id 15.20.1339.026; Mon, 19 Nov 2018
 17:39:04 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "mark.shanahan@intel.com" <mark.shanahan@intel.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Thread-Topic: [PATCH v17 18/23] platform/x86: Intel SGX driver
Thread-Index: AQHUfUjfX0aB3m959EWZdPqQBfyo6KVXOHKAgAAVJgCAAA/qAIAABWAA
Date:   Mon, 19 Nov 2018 17:39:04 +0000
Message-ID: <63b97d22-9d28-e0f8-492d-27e5cc456fce@fortanix.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <20181119150655.GA11843@linux.intel.com>
 <e8e640be-6f9f-0835-0578-48f140ac68f9@fortanix.com>
 <20181119171934.GA16252@linux.intel.com>
In-Reply-To: <20181119171934.GA16252@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::21) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [122.179.27.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3469;6:PTBCPh4dq43GQSOfSqc4uerCuPn3gvoxYAscTrDdpycTlHG5FnVWTgqJIbj5n+FBACUj97Auuaf7SwABHOUoZL9gCwF6ewHZgbKSFWQqdBtLrq4vLYC0Qgx15xpQxYmFt1iiob0mQYNZM47+zv/yZBraAo1synHcJjnT6+aYCJqFq4zqCI1oqkLXGRj5b9ZY2E2l7NEMWvZGl7stvlnvmsIg/IkyzApafY3ki28TXJ9oF1nJJ1pylVj4YDnIZ0behVWzivP6dHtstUs2qINglTBZ6fhiFxGl53bEKouFxn6wb8h9yy3ijEvunOQn0QFxFS0YLZODwx5uog75OXbNTkWK5j1GrR+40u5IZKXJ82KDACbXJEuj392LnqxSetsupYI4UfSJAJk0Pwi2ku35IaTgY6eMTjXBYVOokJCy/WiyhRyW6VktiKjj6iqnfWNuircBkqdTiiNRa2q9naRZWQ==;5:U7Mi6PMsDTHffGG079jg1TiiL4SPAXAs+rkACMfeUy7xS6A4vD0vVh0wIEbox/d5jLQsvtob3p4NKMrgy0LgiokkoVhh9COESae8Y8pnM99TTLDgYWlNLRuplfg5w7Nylr7Io1X3TOseRqgQjqccoA16Bs/Kkp0BmyRdXm1sPwY=;7:nGGOeo0PQyvQPTHMzlcQ3zQ7nEY+0z9peZ8SSWd1oo+XIyRrjxakD1Lva7nbFbAy52SJwHfH+jsf9tANZjKL3P2P/DIN4f0skm5lKzZfH1OHsTo2sbuhJMeLXKnDv1AVOM+BtCkrQ4Iwqh1DSraVmw==
x-ms-office365-filtering-correlation-id: 477b8951-cb76-410a-a8f9-08d64e45e629
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3469;
x-ms-traffictypediagnostic: SN6PR11MB3469:
x-microsoft-antispam-prvs: <SN6PR11MB3469F404DE14512F365A3C57AAD80@SN6PR11MB3469.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(8121501046)(5005006)(3002001)(93006095)(93001095)(3231415)(944501410)(4983020)(52105112)(10201501046)(148016)(149066)(150057)(6041310)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(2016111802025)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3469;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3469;
x-forefront-prvs: 08617F610C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39830400003)(396003)(366004)(346002)(376002)(189003)(199004)(2906002)(2900100001)(36756003)(66066001)(105586002)(6246003)(106356001)(68736007)(6512007)(99936001)(97736004)(229853002)(4326008)(31686004)(14444005)(6436002)(4001150100001)(256004)(14454004)(71190400001)(71200400001)(6486002)(6916009)(11346002)(8936002)(446003)(305945005)(7736002)(54906003)(508600001)(476003)(81166006)(486006)(81156014)(8676002)(2616005)(316002)(93886005)(25786009)(52116002)(6116002)(86362001)(76176011)(3846002)(102836004)(99286004)(186003)(26005)(53546011)(6506007)(386003)(31696002)(7416002)(5660300001)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3469;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: luD9+ZudUr4MnWbniKRMWNt4hXWKOflSsk5ILu6RTNtbmsJhUnL9pwV7xdaRhDfXJ/tTNif+h4biTt2ipW33XdwFSv64tJ6ycqBmXZKyEOAlOzXFQy8fkLZjFIDhe8Ic9QJu+s3frJo0Xjf8nea36GyfTpn4M0J7GBz41STbqI/bZD3m4O1JBsc/QCuiafVAgrPA+Ba3qX3wytbQLC2/vbxm/aXISdqbgkFqvvoZrXBlwIJ69tGK+amoo2KHgnYpCzvl/xSPWz7nrq8WZKnqKzNHoieX7eJDjhxEQpnRxBATJJ96QtLXn5S7pJ/ZvaoJJCOX8VPyGsppx+i9B3KMO+eFSU4QgGGpeqG7aKO3Ufk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020400010809040807050702"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 477b8951-cb76-410a-a8f9-08d64e45e629
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2018 17:39:04.3896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3469
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020400010809040807050702
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-11-19 22:49, Jarkko Sakkinen wrote:
> On Mon, Nov 19, 2018 at 04:22:54PM +0000, Jethro Beekman wrote:
>> On 2018-11-19 20:36, Jarkko Sakkinen wrote:
>>> Question: should be dissolve the driver completely and move this code=
 to
>>> arch/x86/kernel/cpu/sgx/ (and rename intel_sgx.c as main.c)? Swapping=

>>> patch removes the possibility to compile this as a module anyway.
>>
>> No. We should keep the capability to build this as a module for other =
users
>> of SGX. What is the swapping patch and why doesn't allow building as a=

>> module?
>=20
> In some earlier version of the patch set the request was to remove the
> callback interface to the driver so now core does direct calls to the
> swapping operations.

I see, you're talking about this part (from PATCH v17 20/23):

> This has the unfortunate and odd side effect of preventing the SGX driv=
er from=20
> being compiled as a loadable module.

But you also write:

> However, this should be a temporary situation

And in PATCH v17 19/23:

> Allowing the userspace-facing driver to be built as a loaded module is =

> desirable

I wholeheartedly agree with that last statement.

Let's keep it as separated as possible for now until KVM lands and we=20
get the module capability back, instead of integrating everything so=20
tightly that that is no longer possible.

--
Jethro Beekman | Fortanix


--------------ms020400010809040807050702
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTExOTE3Mzg0OFowLwYJKoZIhvcNAQkEMSIEILYrg8iX
K0Rqckc7MJiGAUnMl51Az1x9J/iBrHoyDYOJMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQC6Vl5I3WYI7KOzE1lUPhKE+xvKlZQIzk3GWh17C3uT3Hv/r9QUQLXfcc+eln1tOunS4U4q
7R+6i7u7MAt69q2NYZplXdYUjeN7fD8QNQD6PssOxmIJsk3Vh75tm+NfOKhhCziwN/HWzDL7
V2T4eh6h19AYIwXxa7D0JEaw/IEmcQuqZ27cl6KOWgdhh8ziSspfdzGu3u0T3FKoS9pSgNlQ
Rh1jDmFHCyAx/ivJaOFgWpNcoagt+qg13fDeBeT8bCr5YPUKDfsQuEHX/jeD4Bt+41Jq4skE
pUHK+Txs18xWxLuZ3DjCMm9koryQyeHyX9seIWLPRUqG0wwMx3t64EgsAAAAAAAA

--------------ms020400010809040807050702--
