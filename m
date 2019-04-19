Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BC3C282E1
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 21:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57DCF2183F
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 21:35:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="H7u3Ksw9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfDSVfi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 17:35:38 -0400
Received: from mail-eopbgr730121.outbound.protection.outlook.com ([40.107.73.121]:58080
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbfDSVfh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Apr 2019 17:35:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RDDtQqCwLO15JVd/v5LRbaX933Wjwug6kadDkbEPFA=;
 b=H7u3Ksw9bwTj8pEORfi0qkNvrcaif7rKVKYu0jtzcJzVClSZcOeKDUFFnCAIcyn7aCkEw/DutNyyF5hhgE42j6AaPzvX5OgaeVNcktYxZMrb6XU3QEKrS6BlnaESG6f7yiUiXQie4xK0PpB6uIur1fzi0Pbfq5zijWkmTS+8Kq4=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2607.namprd11.prod.outlook.com (52.135.91.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.21; Fri, 19 Apr 2019 21:35:33 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d%3]) with mapi id 15.20.1813.013; Fri, 19 Apr 2019
 21:35:32 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Andy Lutomirski <luto@amacapital.net>
CC:     Thomas Gleixner <tglx@linutronix.de>,
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
Thread-Index: AQHU9QnkBhtGQ+66Y0uqVL4+2rp75qZCKU6AgAAN+gCAAVPlAIAAE4gAgABGE4CAABE+gIAAAfEAgAABGQCAAADeAIAABewAgAABNYCAAAN+gIAAAP2A
Date:   Fri, 19 Apr 2019 21:35:32 +0000
Message-ID: <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
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
In-Reply-To: <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40ded031-0d6b-4ab3-cf5b-08d6c50ef366
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR11MB2607;
x-ms-traffictypediagnostic: SN6PR11MB2607:
x-microsoft-antispam-prvs: <SN6PR11MB2607C136617CBFE6473D4F96AA270@SN6PR11MB2607.namprd11.prod.outlook.com>
x-forefront-prvs: 0012E6D357
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39840400004)(366004)(136003)(376002)(396003)(199004)(189003)(229853002)(5660300002)(53546011)(6436002)(386003)(6486002)(2616005)(6512007)(6506007)(508600001)(4326008)(8676002)(316002)(31686004)(14454004)(97736004)(4744005)(446003)(6916009)(8936002)(7416002)(102836004)(11346002)(54906003)(53936002)(26005)(81166006)(99286004)(81156014)(52116002)(2906002)(93886005)(6116002)(486006)(86362001)(7736002)(36756003)(25786009)(186003)(66066001)(305945005)(256004)(476003)(66476007)(73956011)(66556008)(66946007)(66446008)(64756008)(6246003)(71200400001)(68736007)(31696002)(71190400001)(76176011)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2607;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kj2umVfbmuRlHi9g7zcMwSy91MusxZbQ6jmHzF8YhpLXseI5a1LTt1z1ih1vguXPGx7foaC/yk017bxyN/XJ3VR/h/jpdaNV8OHgWUpsxCkGEIJIwhTiXCVN5JXxjWACaWAc6tkgnpEyAXHxAYRWMVXBaSctw4iJZL/V3paySylcnWwgJ4b4lBLhdjCFg6IabX2s1PkUZGiEv1lqgYEE0wQGFYw5emmJvjjV3KbXwxi+jh8nri9LEyYZoyZ/srayU0F0qPrDM1D07SA6J8qTWXmEkpMn4MdYwXlx1wbF9xBPc4Cx5H8RkVxCeun8t1uwI0oHCd1B2+QWQPYSiNn8R4Ti9MPfrzd9rNtiByCJLHadpjHUXmQwKNzC3wHYkAMTlFWua3GrhexxjGBnpHB54tuX0pFH+gt2hAQMEbn17nQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7895164924D1244E8861312783D22BC7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ded031-0d6b-4ab3-cf5b-08d6c50ef366
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2019 21:35:32.6971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2607
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gMjAxOS0wNC0xOSAxNDozMSwgQW5keSBMdXRvbWlyc2tpIHdyb3RlOg0KPiBJIGRvIHRoaW5r
IHdlIG5lZWQgdG8gZm9sbG93IExTTSBydWxlcy4gIEJ1dCBteSBiaWdnZXIgcG9pbnQgaXMgdGhh
dCB0aGVyZSBhcmUgcG9saWNpZXMgdGhhdCBkb27igJl0IGFsbG93IEpJVCBhdCBhbGwuIEkgdGhp
bmsgd2Ugc2hvdWxkIGFycmFuZ2UgdGhlIFNHWCBBUEkgc28gaXTigJlzIHN0aWxsIHVzYWJsZSB3
aGVuIHN1Y2ggYSBwb2xpY3kgaXMgaW4gZWZmZWN0Lg0KDQpJIGRvbid0IHRoaW5rIHdlIG5lZWQg
dG8gYXJyYW5nZSB0aGF0IHJpZ2h0IG5vdy4gVGhpcyBwYXRjaCBzZXQgbmVlZHMgdG8NCmJlIG1l
cmdlZCBhZnRlciBtb3JlIHRoYW4gMiB5ZWFycyBvZiBkZXZlbG9wbWVudC4gSSdkIGxpa2UgdG8g
YXZvaWQNCmludHJvZHVjaW5nIGFueSBtb3JlIGJpZyBjaGFuZ2VzLiBMZXQncyBqdXN0IGRvIHdo
YXQgSSBkZXNjcmliZWQgdG8gbWFrZQ0KTFNNIG5vdCBicm9rZW4sIHdoaWNoIGlzIGEgbWluaW1h
bCBjaGFuZ2UgdG8gdGhlIGN1cnJlbnQgYXBwcm9hY2guIFdlDQpjYW4gYWRqdXN0IHRoZSBBUEkg
bGF0ZXIgdG8gc3VwcG9ydCB0aGUgdXNlIGNhc2UgeW91IGRlc2NyaWJlLg0KDQotLQ0KSmV0aHJv
IEJlZWttYW4gfCBGb3J0YW5peA0KDQo=
