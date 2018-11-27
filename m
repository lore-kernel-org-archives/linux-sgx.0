Return-Path: <SRS0=TXuC=OG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66612C43441
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Nov 2018 07:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A19A20873
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Nov 2018 07:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="jL9EtsSN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A19A20873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbeK0Snw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Nov 2018 13:43:52 -0500
Received: from mail-eopbgr760107.outbound.protection.outlook.com ([40.107.76.107]:17664
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729070AbeK0Snw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Nov 2018 13:43:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uiPE67p2sJK1NNzL0KEjIWT0CN1cxfvz1EP4sDeYjSQ=;
 b=jL9EtsSNTP12xxjQW4hT8YZoQTYPBaA1GSbtXGfB1jLotbJVbX8x3zNGdruScgLxz6DgZ4AHMVl3m5vtdrQhJypLqycRvgihVW0h7M0ReKZkJPgFKVZY7ubd0/IOXiMrozdiQsRYLlt4mWodWqGnrjcNO9ofizMR9IOnEBE9V+g=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3104.namprd11.prod.outlook.com (52.135.126.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.19; Tue, 27 Nov 2018 07:46:48 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::916c:7b87:64a8:d58c%2]) with mapi id 15.20.1361.019; Tue, 27 Nov 2018
 07:46:48 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
CC:     Andy Lutomirski <luto@kernel.org>,
        "Dr. Greg Wettstein" <greg@enjellic.com>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "mark.shanahan@intel.com" <mark.shanahan@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Thread-Topic: [PATCH v17 18/23] platform/x86: Intel SGX driver
Thread-Index: AQHUfUjfX0aB3m959EWZdPqQBfyo6KVXPryAgAAN74CAAAs1AIABP/4AgAMWMICAAEVcAIADRjgAgAFpDYCAABjlgIAB7kyAgACmMQA=
Date:   Tue, 27 Nov 2018 07:46:48 +0000
Message-ID: <f16f1347-24de-85da-9cdf-ecd478e1d097@fortanix.com>
References: <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
 <20181119161917.GF13298@linux.intel.com>
 <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
 <20181120120442.GA22172@linux.intel.com>
 <20181122111253.GA31150@wind.enjellic.com>
 <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com>
 <20181124172114.GB32210@linux.intel.com>
 <20181125145329.GA5777@linux.intel.com>
 <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net>
 <20181126215145.GC868@linux.intel.com>
In-Reply-To: <20181126215145.GC868@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR02CA0119.apcprd02.prod.outlook.com
 (2603:1096:4:92::35) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [14.143.179.162]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SN6PR11MB3104;6:qL+W2y0qFr5dETUZ8nXSpYUpTmezaDrJOi5TfITyHG7XPSCa8Qg3lwN8EAo8sac3XWMv+kJvorWhcXjW633Bo+JKW5hD+QzKYucWizJVIa/8BagLSmkqLeot/7hAgi3RCf2lCPW7v45z4ECSTB3g76QuoLeVyJbokXKZfk2xQudD11nxur+47XXUZ9Ar0UJDoDSiUIrHIg6t1+fsfQVSCgIOUx3kJNncUfriYhacr2PLW9XwTrr6vF/5afRyaSzpz+D1Xbm4EavhZVoNFlJXL+G24TmCZKLe86P+k/DT8hvxKY6QXrHIa0HLCnVLJSSvPBdKKNiJmW/fD98PK8u/Mpa2H4NMVbY8mPjWH1B+8Lazivr2yYOAJiXbDoG6sJV4eiVXQCNg6XxRtQo4Fv9JJ7iqaBpS/Nsed8dB4B8mUDKCtrcLjGIuPivsvMSKUPnKJN1tSk4vnwLRdC48kMx7sw==;5:Y5knHq7EqeOkJML3HILfytyFJlyC96KNKVdBtb7jcsReI9QZqHN4gYh85KMqhh74dJLUGjj0p90+P0mWxD15FLBNSjOkBxbm+mvjWGA40Zn7E0OCpziRlFLmRclP/D27on+L6HnHvk8uBxCQ/4MuJ6Nel84uEx0YYjorJ+PObCg=;7:o2Zs8aivz/d0wHSVezRK69mHf3hR/9AHGFvxfORnj6+eHBmKuWgGVwifE0rf1/PkOFBvLOgIVY+VgvUTxEPaSaVjPd/sSHmA+Kk0A1omDTkXd1OYK/SFkbMpD1kCdao9ixdGbtYuPooiUAFtrijxuQ==
x-ms-office365-filtering-correlation-id: eb448f65-84c8-491d-972e-08d6543c7c12
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(7021145)(8989299)(5600074)(711020)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(49563074)(7193020);SRVR:SN6PR11MB3104;
x-ms-traffictypediagnostic: SN6PR11MB3104:
x-microsoft-antispam-prvs: <SN6PR11MB310416C822F60DC443068E9BAAD00@SN6PR11MB3104.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(5005006)(8121501046)(10201501046)(93006095)(93001095)(3231443)(944501410)(4983020)(52105112)(3002001)(148016)(149066)(150057)(6041310)(20161123560045)(2016111802025)(20161123564045)(20161123562045)(20161123558120)(6043046)(201708071742011)(7699051)(76991095);SRVR:SN6PR11MB3104;BCL:0;PCL:0;RULEID:;SRVR:SN6PR11MB3104;
x-forefront-prvs: 086943A159
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(76176011)(78486014)(446003)(102836004)(508600001)(11346002)(54906003)(6436002)(229853002)(316002)(305945005)(7736002)(25786009)(6246003)(99286004)(26005)(486006)(4001150100001)(52116002)(14454004)(110136005)(97736004)(66066001)(4326008)(2616005)(476003)(71200400001)(53546011)(386003)(71190400001)(6506007)(55236004)(186003)(53936002)(8936002)(6512007)(7416002)(93886005)(6486002)(256004)(31686004)(81166006)(105586002)(31696002)(6116002)(3846002)(99936001)(68736007)(106356001)(5660300001)(8676002)(86362001)(81156014)(36756003)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3104;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: XTPvseqDbYJ2ISUN8xOfk+vw1umd1AlRxs+LpJI8HYUHlav38Kb6EfOfky5hAFNeSeA44bLtd0iEzCvbiATzLItsqmX32TPjhjgjfP0L0bVWNNSO2vW2USf5YgPGqYmIt0k88JpnVdZy7HwKtsMDABenOCygGA2XCr6bIklKz/I+cXTETUuPQoloHfHGZIfYnIjub9mbe4I1JfWe/7iMnr55xDcH+E+AphpCbput5vcEAMidKxyDk6s3mSWQhmIolfMcfCzPa5HxDAI9qOZqC7z6EW+sUb4Z1DIPNu/3I97jMHAEY7sv2/vm5G7Whs51O0lJqRdAqiqPP9mCkkWoyw0wTqeh2iHIq2C330HjGKc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010103080500000402080801"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb448f65-84c8-491d-972e-08d6543c7c12
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2018 07:46:48.2430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3104
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms010103080500000402080801
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-11-27 03:21, Jarkko Sakkinen wrote:
> BTW, off-topic from this but should we remove ENCLAVE from IOC names as=

> they all concern enclaves anyway? Seems kind of redundant. I.e.
>=20
> SGX_IOC_ENCLAVE_CREATE -> SGX_IOC_CREATE
> SGX_IOC_ENCLAVE_ADD_PAGE -> SGX_IOC_ADD_PAGE
> SGX_IOC_ENCLAVE_INIT -> SGX_IOC_INIT=20

Future ioctls might be added that deal with system-global SGX things?=20
Like an interface to communicate with the in-kernel LE or something.

Jethro Beekman | Fortanix


--------------ms010103080500000402080801
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
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTEyNzA3NDYzNFowLwYJKoZIhvcNAQkEMSIEIDxcanyT
tU9sX7ncsBaNOpBRTzZJDpSh/5HAeHz8ceV5MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQAEtkPwJ7rYxqFVON6oZv6XN8gy0ZY5vVP8a/5CUUAqbCyFfP3ObF5rbpAe7pS74JWId46P
nxGqVopdZVJi3riy1a3jxoloBI3cDGF6dzjGiEjKiztPdDFTzySANLa6NLKE8oHgGULJ3GIi
MlG1vGUmqYjPbZ9RTfOre8oYmTVtyMdyacYbpfrXfdl4SjxVfDIGgNrUGk2VezPvXL8sM/12
JzQKGlxsFbzmEujP4gmVLViBTJR9DttkD5m+JNL0X5ymrK/UNXHWvqpLC+osMq0ZFgXo3L38
9By6eexGJxEId/lSojIdGDbVpvh1tDAI7hSx3col8rINIjXLuTQ21NP5AAAAAAAA

--------------ms010103080500000402080801--
