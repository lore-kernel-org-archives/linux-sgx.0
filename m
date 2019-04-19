Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8456EC282E0
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 21:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 457B0208C0
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 21:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="iWXxEUM4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfDSVTi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 17:19:38 -0400
Received: from mail-eopbgr740094.outbound.protection.outlook.com ([40.107.74.94]:30609
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725932AbfDSVTh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Apr 2019 17:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syC6hG6IwS5Ha4q8xKjm/VWVMmKH7D/ta198QkM2E0g=;
 b=iWXxEUM4TsOT71togTyGvJyeaUkc5/DxeXsfsCWcOymz5bHJ0Qr7GfQr4wMSgucX5xXEK+nbfH4KGnFGnNtWvUCb2lcu6jZz+/QnAaDQuWq+6RbicuThguJIJxJ29MO4E2oMOuFIm3J/zZSQeJsJ/P/yf3JYL9JeOBEmDA5EWDc=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2813.namprd11.prod.outlook.com (52.135.93.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.12; Fri, 19 Apr 2019 21:19:31 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d%3]) with mapi id 15.20.1813.013; Fri, 19 Apr 2019
 21:19:31 +0000
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
Thread-Index: AQHU9QnkBhtGQ+66Y0uqVL4+2rp75qZCKU6AgAAN+gCAAVPlAIAAE4gAgABGE4CAABE+gIAAAfEAgAABGQCAAADeAIAABewAgAABNYA=
Date:   Fri, 19 Apr 2019 21:19:31 +0000
Message-ID: <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com>
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
In-Reply-To: <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:74::41) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6910fdad-576d-44bd-b073-08d6c50cb676
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600141)(711020)(4605104)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7193020);SRVR:SN6PR11MB2813;
x-ms-traffictypediagnostic: SN6PR11MB2813:
x-microsoft-antispam-prvs: <SN6PR11MB2813E425DCD2196440EA8B18AA270@SN6PR11MB2813.namprd11.prod.outlook.com>
x-forefront-prvs: 0012E6D357
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(366004)(39840400004)(136003)(396003)(346002)(376002)(199004)(189003)(7416002)(305945005)(26005)(6506007)(386003)(53546011)(102836004)(36756003)(14454004)(3846002)(7736002)(93886005)(97736004)(316002)(6486002)(229853002)(66946007)(31686004)(31696002)(14444005)(256004)(6916009)(99286004)(73956011)(5660300002)(6512007)(71200400001)(86362001)(81156014)(25786009)(81166006)(8676002)(8936002)(508600001)(52116002)(186003)(2616005)(486006)(476003)(446003)(6116002)(4326008)(71190400001)(6436002)(6246003)(66446008)(66476007)(68736007)(53936002)(66066001)(54906003)(76176011)(64756008)(11346002)(66556008)(2906002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2813;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1X+iVMuNJVaOxfwsIi21mx5l42MglD6WUFIg+V+x3WkcoMkbd2RAKMIvhkyU9/8k3QTSJwxPtYN8BapWUW4iW2FyBmZ0I1PfxIHKuHDnMFZeqq91PGPwQWB45TjU0XzTk5yNBnfuT1o0pitczxLScAjcV6bqriKOGMjfFmdexuFbMU+I5Qk4Gug9PBHb3kFLzTd3iu18sa2ucmefZdB5nZfi0dRUBAxD3nUCzAQPNj5TsphMLa0iFFwJ/zUjvZqWCGGXU+2JtBedcGhv8dL5FjwT08qgNbyQLJEtXPTqaYucpdKTsgVEB3i26tjeQ9hxmFMLyHtAuxy9mDnosI+57POEYev3l31gYwSCLNl2qfzan/DWzpoymQFW10IK5P/C0zadP2w2vNxuR8vpqK+jpaGQTC1BLK9Oxf5nP2Nmbnk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73A7C21FAEBA93429F11F62F815898AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6910fdad-576d-44bd-b073-08d6c50cb676
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2019 21:19:31.3616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2813
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

DQoNCkpldGhybyBCZWVrbWFuIHwgRm9ydGFuaXgNCg0KT24gMjAxOS0wNC0xOSAxNDoxNSwgQW5k
eSBMdXRvbWlyc2tpIHdyb3RlOg0KPiANCj4gDQo+IA0KPiANCj4+IE9uIEFwciAxOSwgMjAxOSwg
YXQgMTo1NCBQTSwgSmV0aHJvIEJlZWttYW4gPGpldGhyb0Bmb3J0YW5peC5jb20+IHdyb3RlOg0K
Pj4NCj4+PiBPbiAyMDE5LTA0LTE5IDEzOjUwLCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6DQo+Pj4+
IE9uIEZyaSwgMTkgQXByIDIwMTksIEpldGhybyBCZWVrbWFuIHdyb3RlOg0KPj4+Pj4gT24gMjAx
OS0wNC0xOSAxMzozOSwgVGhvbWFzIEdsZWl4bmVyIHdyb3RlOg0KPj4+Pj4+IE9uIEZyaSwgMTkg
QXByIDIwMTksIEpldGhybyBCZWVrbWFuIHdyb3RlOg0KPj4+Pj4+DQo+Pj4+Pj4+IE9uIDIwMTkt
MDQtMTkgMDg6MjcsIEFuZHkgTHV0b21pcnNraSB3cm90ZToNCj4+Pj4+Pj4gVGhlcmUgYXJlIG1h
bnksDQo+Pj4+Pj4+IG1hbnkgTGludXggc3lzdGVtcyB0aGF0IGVuZm9yY2UgYSBwb2xpY3kgdGhh
dCAqYWxsKiBleGVjdXRhYmxlIHRleHQNCj4+Pj4+Pj4gbmVlZHMgdG8gY29tZSBmcm9tIGEgdmVy
aWZpZWQgc291cmNlLiAgT24gdGhlc2Ugc3lzdGVtcywgeW91IGNhbid0DQo+Pj4+Pj4+IG1tYXAg
c29tZSB3cml0YWJsZSBtZW1vcnksIHdyaXRlIHRvIGl0LCBhbmQgdGhlbiBjaGFuZ2UgaXQgdG8N
Cj4+Pj4+Pj4gZXhlY3V0YWJsZS4NCj4+Pj4+Pg0KPj4+Pj4+IEhvdyBpcyB0aGlzIGltcGxlbWVu
dGVkIG9uIHRob3NlIHN5c3RlbXM/IEFGQUlLIHRoZXJlJ3Mgbm8ga2VybmVsIGNvbmZpZw0KPj4+
Pj4+IG9wdGlvbiB0aGF0IGNoYW5nZXMgdGhlIHNlbWFudGljcyBvZiBtbWFwIGFzIHlvdSBkZXNj
cmliZS4NCj4+Pj4+DQo+Pj4+PiBUaGF0IGhhcyBub3RoaW5nIHRvIGRvIHdpdGggbW1hcCgpIHNl
bWFudGljcy4gWW91IG1tYXAoKSB3cml0ZWFibGUgbWVtb3J5DQo+Pj4+PiBhbmQgdGhlbiB5b3Ug
Y2hhbmdlIHRoZSBwZXJtaXNzaW9ucyB2aWEgbXByb3RlY3QoKS4gbXByb3RlY3QoKSBjYWxscyBp
bnRvDQo+Pj4+PiBMU00gYW5kIGRlcGVuZGluZyBvbiBwb2xpY3kgYW5kIHNlY3VyaXR5IG1vZGVs
IHRoaXMgd2lsbCByZWplY3QgdGhlDQo+Pj4+PiByZXF1ZXN0Lg0KPj4+Pj4NCj4+Pj4+IEFuZHkg
d2FzIHBvaW50aW5nIG91dCB0aGF0IHRoZSBTR1ggaW9jdGwgYnlwYXNzZXMgdGhlIExTTSBtZWNo
YW5pY3Mgd2hpY2gNCj4+Pj4+IGlzIG9idmlvdXNseSBhIGJhZCB0aGluZy4NCj4+Pj4NCj4+Pj4g
V2UgY291bGQgbW9kaWZ5IHRoZSBkcml2ZXIgc3VjaCB0aGF0IHdoZW4geW91IGNhbGwgaW9jdGwg
RUFERCwgdGhlIHBhZ2UNCj4+Pj4gdGFibGUgcGVybWlzc2lvbnMgbmVlZCB0byBiZSB0aGUgUEFH
RUlORk8uU0VDSU5GTy5GTEFHUyB8IFBST1RfV1JJVEUsDQo+Pj4+IG90aGVyd2lzZSB5b3UgZ2V0
IEVQRVJNIG9yIHNvLiBBZnRlciBFQURELCBpZiB5b3Ugd2FudCwgeW91IGNhbiByZXN0cmljdA0K
Pj4+PiB0aGUgcGFnZSB0YWJsZSBwZXJtaXNzaW9ucyBhZ2FpbiB1c2luZyBtcHJvdGVjdCBidXQg
dGhlIHBhZ2UgdGFibGUNCj4+Pj4gcGVybWlzc2lvbnMgZG9uJ3QgcmVhbGx5IG1hdHRlciBmb3Ig
U0dYLg0KPj4+DQo+Pj4gQW5kIHRoZSBwb2ludCBvZiB0aGF0IGlzPyBUaGF0IHlvdSBzdGlsbCBj
YW4gY2lydW12ZW50IExTTSBmb3IgZmVlZGluZw0KPj4+IGV4ZWN1dGFibGUgY29kZSBpbnRvIFNH
WC4NCj4+DQo+PiBIb3c/IExTTSB3b3VsZCBzZWUgdGhhdCB5b3UncmUgdHJ5aW5nIHRvIG1hcCBh
IHBhZ2UgUldYIHNvIHlvdSBjYW4gZG8NCj4+IHlvdXIgaW9jdGw/DQo+IA0KPiBXaXRoIHBsYWlu
IG1tYXAoKSArIG1wcm90ZWN0KCksIHRoZSBMU00gd2lsbCBwcmV2ZW50IHlvdSBmcm9tIG1ha2lu
ZyBtZW1vcnkgdGhhdCAqd2FzKiB3cml0YWJsZSBleGVjdXRhYmxlLiAgVGhpcyBpcyBieSBkZXNp
Z24gYW5kIFNFTGludXggc3VwcG9ydHMgaXQuICBJIGRvbuKAmXQgcmVtZW1iZXIgdGhlIG5hbWUg
b2YgdGhlIGFzc29jaWF0ZWQgU0VMaW51eCBwZXJtaXNzaW9uIG9mZiB0aGUgdG9wIG9mIG15IGhl
YWQuDQo+IA0KPiBJZiB3ZSBzdGFydCBlbmZvcmNpbmcgZXF1aXZhbGVudCBydWxlcyBvbiBTR1gs
IHRoZW4gdGhlIGN1cnJlbnQgQVBJIHdpbGwgc2ltcGx5IG5vdCBhbGxvdyBlbmNsYXZlcyB0byBi
ZSBsb2FkZWQg4oCUIG5vIG1hdHRlciBob3cgeW91IHNsaWNlIGl0LCBsb2FkaW5nIGFuIGVuY2xh
dmUgd2l0aCB0aGUgY3VycmVudCBBUEkgaXMgaW5kaXN0aW5ndWlzaGFibGUgZnJvbSBtYWtpbmcg
YXJiaXRyYXJ5IGRhdGEgZXhlY3V0YWJsZS4NCg0KWWVzIHRoaXMgaXMgZXhhY3RseSB3aGF0IEkg
aW50ZW5kZWQgaGVyZTogYSB2ZXJ5IHNpbXBsZSBjaGFuZ2UgdGhhdA0Kc3RvcHMgU0dYIGZyb20g
Y29uZnVzaW5nIExTTS4gSnVzdCBieSBlbmZvcmNpbmcgdGhhdCBldmVyeXRoaW5nIHRoYXQNCmxv
b2tzIGxpa2UgYSBtZW1vcnkgd3JpdGUgKEVBREQsIEVBVUcsIEVEQkdXUiwgZXRjLikgYWN0dWFs
bHkgcmVxdWlyZXMNCndyaXRlIHBlcm1pc3Npb25zLCByZWFsaXR5IGFuZCBMU00gc2hvdWxkIGJl
IG9uIHRoZSBzYW1lIHBhZ2UuDQoNCklmIHlvdSB3YW50IHRvIGdvIGZ1cnRoZXIgYW5kIGFjdHVh
bGx5IGFsbG93IHRoaXMgYmVoYXZpb3Igd2hlbiB5b3VyIExTTQ0Kd291bGQgb3RoZXJ3aXNlIHBy
b2hpYml0IGl0LCBwcmVzdW1hYmx5IHRoZSBzYW1lIHdvcmthcm91bmRzIHRoYXQgZXhpc3QNCmZv
ciBKSVRzIGNhbiBiZSB1c2VkIGZvciBTR1guDQoNCi0tDQpKZXRocm8gQmVla21hbiB8IEZvcnRh
bml4DQo=
