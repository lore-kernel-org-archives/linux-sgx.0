Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A74C282E0
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 21:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EF842171F
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 21:56:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="vF/qFKJt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfDSV4O (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 17:56:14 -0400
Received: from mail-eopbgr740129.outbound.protection.outlook.com ([40.107.74.129]:5664
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbfDSV4N (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Apr 2019 17:56:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Giz+m+uFj9bYjBkKa9tIfUb0PUvVkC9wxmYVwNmF51U=;
 b=vF/qFKJtCiJoOx0RPZtIYzpxrTJeX5ntUIxPwcS7IhS43ieDm0YdHxd+yFrqJjMDh05leu0Q+RuZfA+K75junZ1w5AWmm7Hw7hM3cLpDRQuU/4sLb22mRCMOxHjJrNrFP6eWg+QJvMFS4cz59SOFPUIjGNq1CItvDdCQveCiDaE=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2736.namprd11.prod.outlook.com (52.135.92.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.14; Fri, 19 Apr 2019 21:56:08 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d%3]) with mapi id 15.20.1813.013; Fri, 19 Apr 2019
 21:56:08 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        "Dr. Greg" <greg@enjellic.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Thread-Topic: [PATCH v20 00/28] Intel SGX1 support
Thread-Index: AQHU9QnkBhtGQ+66Y0uqVL4+2rp75qZCKU6AgAAN+gCAAVPlAIAAE4gAgABGE4CAABE+gIAAAfEAgAABGQCAAADeAIAABewAgAABNYCAAAN+gIAAAP2AgAAA3wCAAATggA==
Date:   Fri, 19 Apr 2019 21:56:07 +0000
Message-ID: <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190418171059.GA20819@wind.enjellic.com>
 <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
 <20190419141732.GA2269@wind.enjellic.com>
 <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
 <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com>
 <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de>
 <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com>
 <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de>
 <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com>
 <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com>
 <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
 <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::15) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88d0b571-20d9-473c-2406-08d6c511d339
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR11MB2736;
x-ms-traffictypediagnostic: SN6PR11MB2736:
x-microsoft-antispam-prvs: <SN6PR11MB27366FA63E3A7C30D87EF4C5AA270@SN6PR11MB2736.namprd11.prod.outlook.com>
x-forefront-prvs: 0012E6D357
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(396003)(376002)(39840400004)(199004)(189003)(8676002)(52116002)(36756003)(26005)(54906003)(68736007)(97736004)(53936002)(31696002)(2616005)(3846002)(6246003)(476003)(2906002)(102836004)(6916009)(316002)(186003)(66476007)(6436002)(66556008)(6506007)(14444005)(256004)(386003)(8936002)(25786009)(31686004)(6486002)(4326008)(76176011)(7736002)(81156014)(5660300002)(53546011)(229853002)(508600001)(81166006)(66946007)(73956011)(71190400001)(71200400001)(86362001)(11346002)(446003)(99286004)(305945005)(14454004)(66066001)(6116002)(6512007)(486006)(66446008)(7416002)(64756008)(93886005);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2736;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kzsstK+OlRjGrPXNIl5LMfyiKh4h3iPxCsllXWgDH6uHrTp1wn9erUBPRKczpg+ZNASlWwlpTvVL+G7f4vHyqu8Q8iqOSd9rb7yTSbExAIhRfXoiWLBOv0Yxz/ZNiswez11sxEFR462VORxzi9CHBHnZX8E98aCNYWeyjE8BXRUd8KWuKa9D/ksyqj8H/fgul3Tw4ldJOsYkT3DWrx/ftvEhg1B0Vioc9exo37b3aaYqkdGVZFCCYDc4FBkkoiaZyPOfIJ04PfWKVbb0pdR3VHPWB1oGx6Tz6UTEWML1pQWIxv1joPkKqn5k8MXBVLT5hBCMCYTlew4cLi8YtiwdDSgmfo4l2g8IRqzKgO4AiTtA9bDlPv5IZBnW4JhW82SZGjhfN/JmhzbqgzTACl4HM24re+luMwR/K6O/4tq+7fM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B36F6FEECFD3D4C8C12D083112A4582@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d0b571-20d9-473c-2406-08d6c511d339
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2019 21:56:08.2177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2736
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gMjAxOS0wNC0xOSAxNDozNCwgVGhvbWFzIEdsZWl4bmVyIHdyb3RlOg0KPiBBbmQgaG93IHNv
PyBZb3UgY3JlYXRlIHdyaXRlYWJsZSBBTkQgZXhlY3V0YWJsZSBtZW1vcnkuIFRoYXQncyBhIG5v
bm8gYW5kDQo+IHlvdSBjYW4gYXJndWUgaW4gY2lyY2xlcywgdGhhdCdzIG5vdCBnb2luZyB0byBj
aGFuZ2Ugd2l0aCBhbnkgb2YgeW91cg0KPiBwcm9wb3NlZCBjaGFuZ2VzLg0KDQpPbiAyMDE5LTA0
LTE5IDE0OjM4LCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6DQo+IFlvdSBhcmUgd29ya2luZyBhcm91
bmQgTFNNIG5vdGhpbmcgZWxzZSBhbmQgdGhhdCdzIGp1c3Qgbm90IGdvaW5nIHRvIGZseS4NCg0K
QmFzZWQgb24geW91ciBjb21tZW50cywgSSdtIHN0aWxsIHVuc3VyZSBpZiB3ZSdyZSBvbiB0aGUg
c2FtZSBwYWdlIHdpdGgNCnJlZ2FyZHMgdG8gd2hhdCBJJ20gcHJvcG9zaW5nLg0KDQpIZXJlJ3Mg
YSByZWd1bGFyIG5vbi1TR1ggZmxvdyB0aGF0IExTTSB3b3VsZCBsaWtlbHkgcHJldmVudDoNCg0K
bW1hcChQUk9UX1JFQUR8UFJPVF9XUklURSkNCm1lbWNweSgpDQptbWFwKFBST1RfUkVBRHxQUk9U
X0VYRUMpIDwtLSBkZW5pZWQgYnkgTFNNDQoNCk9yIGp1c3Qgc29tZXRoaW5nIGJhc2VkIG9uIHJl
Z3VsYXIgUFQgcGVybWlzc2lvbnM6DQoNCm1tYXAoUFJPVF9SRUFEfFBST1RfRVhFQykNCm1lbWNw
eSgpIDwtLSBTSUdTRUdWDQoNCk5vdywgdGhlIGVxdWl2YWxlbnQgZm9yIFNHWDoNCg0KbW1hcChQ
Uk9UX1JFQUR8UFJPVF9XUklURSkNCmlvY3RsKEVBREQpDQptbWFwKFBST1RfUkVBRHxQUk9UX0VY
RUMpIDwtLSBkZW5pZWQgYnkgTFNNDQoNClRoaXMgd29ya3MgZmluZSB3aXRoIHYyMCBhcy1pcy4g
SG93ZXZlciwgY29uc2lkZXIgdGhlIGVxdWl2YWxlbnQgb2YgdGhlDQpQVC1iYXNlZCBmbG93Og0K
DQptbWFwKFBST1RfUkVBRHxQUk9UX0VYRUMpDQppb2N0bChFQUREKSA8LS0gbm8gZXJyb3IhDQoN
Ckl0J3Mgbm90IG1lIHRoYXQncyB3b3JraW5nIGFyb3VuZCB0aGUgTFNNLCBpdCdzIHRoZSBTR1gg
ZHJpdmVyISBJdCdzDQp3cml0aW5nIHRvIG1lbW9yeSB0aGF0J3Mgbm90IG1hcmtlZCB3cml0YWJs
ZSEgVGhlIGZ1bmRhbWVudGFsIGlzc3VlIGhlcmUNCmlzIHRoYXQgdGhlIFNHWCBpbnN0cnVjdGlv
biBzZXQgaGFzIHNldmVyYWwgaW5zdHJ1Y3Rpb25zIHRoYXQgYnlwYXNzIHRoZQ0KcGFnZSB0YWJs
ZSBwZXJtaXNzaW9uIGJpdHMsIGFuZCB0aGlzIGlzIChuYXR1cmFsbHkpIGNvbmZ1c2luZyB0byBh
bnkNCmtpbmQgb2YgcmVmZXJlbmNlIG1vbml0b3IgbGlrZSB0aGUgTFNNIGZyYW1ld29yay4gWW91
IGNhbiBjb21lIHVwIHdpdGgNCnNpbWlsYXIgc2NlbmFyaW9zIHRoYXQgaW52b2x2ZSBQUk9UX1JF
QUR8UFJPVF9XUklURXxQUk9UX0VYRUMgb3INCnB0cmFjZShQVFJBQ0VfUE9LRVRFWFQpLiBTbywg
Y2xlYXJseSwgdGhlIHByb3BlciB3YXkgdG8gZml4IHRoaXMgZmFpbHVyZQ0Kb2YgY29tcGxldGUg
bWVkaWF0aW9uIGlzIGJ5IGVuZm9yY2luZyBhcHByb3ByaWF0ZSBwYWdlLXRhYmxlIHBlcm1pc3Np
b25zDQpldmVuIG9uIHRoZSBTR1ggaW5zdHJ1Y3Rpb25zIHRoYXQgZG9uJ3QgZG8gaXQgdGhlbXNl
bHZlcy4gSnVzdCBtYWtlIGFueQ0KaW1wbGljaXQgbWVtb3J5IGFjY2VzcyBsb29rIGxpa2UgYSBy
ZWd1bGFyIG1lbW9yeSBhY2Nlc3MgYW5kIG5vdw0KZXZlcnlvbmUgaXMgb24gdGhlIHNhbWUgcGFn
ZSAocHVuIGludGVuZGVkKS4NCg0KLS0NCkpldGhybyBCZWVrbWFuIHwgRm9ydGFuaXgNCg==
