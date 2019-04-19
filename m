Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04C9C282E0
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 20:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 556EE2171F
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 20:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="FxnshHhf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfDSUyF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 16:54:05 -0400
Received: from mail-eopbgr750128.outbound.protection.outlook.com ([40.107.75.128]:60237
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726120AbfDSUyE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Apr 2019 16:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Eiw5vJOZ16qXuyqGRELPN90NM6xbsMrpqY5/jYXdww=;
 b=FxnshHhfeaX2Wa/0OJ3IaXIaCe0fNUoS8m/9FBx6KO6TD3LLy1WqcyRcMpLKoBlWCkaX8lcDNMqXSGIXQ/p+t+xjR4X18/mxXHkTHOjs7d4m3GrmYl3l1ZTj6LmQXFWO4JNnpybYXjwgJkqTMjfA/v5LGxU2qkLaIm/wZvS/lUo=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3344.namprd11.prod.outlook.com (52.135.112.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.19; Fri, 19 Apr 2019 20:54:00 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d%3]) with mapi id 15.20.1813.013; Fri, 19 Apr 2019
 20:54:00 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Andy Lutomirski <luto@kernel.org>, "Dr. Greg" <greg@enjellic.com>,
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
Thread-Index: AQHU9QnkBhtGQ+66Y0uqVL4+2rp75qZCKU6AgAAN+gCAAVPlAIAAE4gAgABGE4CAABE+gIAAAfEAgAABGQCAAADeAA==
Date:   Fri, 19 Apr 2019 20:54:00 +0000
Message-ID: <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190418171059.GA20819@wind.enjellic.com>
 <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
 <20190419141732.GA2269@wind.enjellic.com>
 <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
 <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com>
 <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de>
 <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com>
 <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0096.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::37) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d957cfa7-8bc9-44e7-1b25-08d6c509255a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600141)(711020)(4605104)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7193020);SRVR:SN6PR11MB3344;
x-ms-traffictypediagnostic: SN6PR11MB3344:
x-microsoft-antispam-prvs: <SN6PR11MB33446D23BF172E8652ACF2EAAA270@SN6PR11MB3344.namprd11.prod.outlook.com>
x-forefront-prvs: 0012E6D357
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39840400004)(366004)(376002)(346002)(189003)(199004)(31696002)(446003)(476003)(186003)(6436002)(305945005)(102836004)(486006)(6916009)(26005)(76176011)(31686004)(11346002)(6486002)(2616005)(99286004)(54906003)(3846002)(2906002)(6116002)(66066001)(66446008)(66946007)(229853002)(64756008)(7736002)(93886005)(316002)(52116002)(97736004)(36756003)(5660300002)(386003)(7416002)(6506007)(508600001)(25786009)(68736007)(73956011)(6246003)(256004)(53546011)(8676002)(81166006)(81156014)(6512007)(53936002)(4326008)(8936002)(71200400001)(71190400001)(14454004)(66476007)(86362001)(66556008)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3344;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KiomF4KkN2pxIfoRZ9ZLl7RbLIqX49vjWTdsB3jtKgssV81NQFHdLYwz7/sHT/kBD7dbNmQmlawFz3pBlC7Ao5D6OLPtqlE2MItk96af3p8P6P80onEeIUzHK9sLf08Uoa3zH8Bi9n59O/itITAy+aM64L01uDiokRbrvYmv5FCJ3JBT5SVntRxZYAvxEJT7nPrgesOmOBGw4Tlwk6vjtacldv/xHw7hHBZbDbDZ8jjSy9ygNpM/L8DnIlqmbxKs6OsQpM392ARj0a5W+I22OfTYHTTMyeaIJ+gLVm2UVkMGjwha2XO4QxEDDQqIOcfWJQvYOwaf0l/Uw5zun9ZlzjC2KqEKZ6gwaK3/X9gVIZ8U0q2EkL/mzaGzCv1xGHzEFpRkJmp4lpSFAxi8rbxLNbP77jTKdE3qxDix03655pE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9F1D34E3B322249888C628EC4C677F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d957cfa7-8bc9-44e7-1b25-08d6c509255a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2019 20:54:00.0199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3344
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gMjAxOS0wNC0xOSAxMzo1MCwgVGhvbWFzIEdsZWl4bmVyIHdyb3RlOg0KPiBPbiBGcmksIDE5
IEFwciAyMDE5LCBKZXRocm8gQmVla21hbiB3cm90ZToNCj4+IE9uIDIwMTktMDQtMTkgMTM6Mzks
IFRob21hcyBHbGVpeG5lciB3cm90ZToNCj4+PiBPbiBGcmksIDE5IEFwciAyMDE5LCBKZXRocm8g
QmVla21hbiB3cm90ZToNCj4+Pg0KPj4+PiBPbiAyMDE5LTA0LTE5IDA4OjI3LCBBbmR5IEx1dG9t
aXJza2kgd3JvdGU6DQo+Pj4+PiBUaGVyZSBhcmUgbWFueSwNCj4+Pj4+IG1hbnkgTGludXggc3lz
dGVtcyB0aGF0IGVuZm9yY2UgYSBwb2xpY3kgdGhhdCAqYWxsKiBleGVjdXRhYmxlIHRleHQNCj4+
Pj4+IG5lZWRzIHRvIGNvbWUgZnJvbSBhIHZlcmlmaWVkIHNvdXJjZS4gIE9uIHRoZXNlIHN5c3Rl
bXMsIHlvdSBjYW4ndA0KPj4+Pj4gbW1hcCBzb21lIHdyaXRhYmxlIG1lbW9yeSwgd3JpdGUgdG8g
aXQsIGFuZCB0aGVuIGNoYW5nZSBpdCB0bw0KPj4+Pj4gZXhlY3V0YWJsZS4NCj4+Pj4NCj4+Pj4g
SG93IGlzIHRoaXMgaW1wbGVtZW50ZWQgb24gdGhvc2Ugc3lzdGVtcz8gQUZBSUsgdGhlcmUncyBu
byBrZXJuZWwgY29uZmlnDQo+Pj4+IG9wdGlvbiB0aGF0IGNoYW5nZXMgdGhlIHNlbWFudGljcyBv
ZiBtbWFwIGFzIHlvdSBkZXNjcmliZS4NCj4+Pg0KPj4+IFRoYXQgaGFzIG5vdGhpbmcgdG8gZG8g
d2l0aCBtbWFwKCkgc2VtYW50aWNzLiBZb3UgbW1hcCgpIHdyaXRlYWJsZSBtZW1vcnkNCj4+PiBh
bmQgdGhlbiB5b3UgY2hhbmdlIHRoZSBwZXJtaXNzaW9ucyB2aWEgbXByb3RlY3QoKS4gbXByb3Rl
Y3QoKSBjYWxscyBpbnRvDQo+Pj4gTFNNIGFuZCBkZXBlbmRpbmcgb24gcG9saWN5IGFuZCBzZWN1
cml0eSBtb2RlbCB0aGlzIHdpbGwgcmVqZWN0IHRoZQ0KPj4+IHJlcXVlc3QuDQo+Pj4NCj4+PiBB
bmR5IHdhcyBwb2ludGluZyBvdXQgdGhhdCB0aGUgU0dYIGlvY3RsIGJ5cGFzc2VzIHRoZSBMU00g
bWVjaGFuaWNzIHdoaWNoDQo+Pj4gaXMgb2J2aW91c2x5IGEgYmFkIHRoaW5nLg0KPj4NCj4+IFdl
IGNvdWxkIG1vZGlmeSB0aGUgZHJpdmVyIHN1Y2ggdGhhdCB3aGVuIHlvdSBjYWxsIGlvY3RsIEVB
REQsIHRoZSBwYWdlDQo+PiB0YWJsZSBwZXJtaXNzaW9ucyBuZWVkIHRvIGJlIHRoZSBQQUdFSU5G
Ty5TRUNJTkZPLkZMQUdTIHwgUFJPVF9XUklURSwNCj4+IG90aGVyd2lzZSB5b3UgZ2V0IEVQRVJN
IG9yIHNvLiBBZnRlciBFQURELCBpZiB5b3Ugd2FudCwgeW91IGNhbiByZXN0cmljdA0KPj4gdGhl
IHBhZ2UgdGFibGUgcGVybWlzc2lvbnMgYWdhaW4gdXNpbmcgbXByb3RlY3QgYnV0IHRoZSBwYWdl
IHRhYmxlDQo+PiBwZXJtaXNzaW9ucyBkb24ndCByZWFsbHkgbWF0dGVyIGZvciBTR1guDQo+IA0K
PiBBbmQgdGhlIHBvaW50IG9mIHRoYXQgaXM/IFRoYXQgeW91IHN0aWxsIGNhbiBjaXJ1bXZlbnQg
TFNNIGZvciBmZWVkaW5nDQo+IGV4ZWN1dGFibGUgY29kZSBpbnRvIFNHWC4NCg0KSG93PyBMU00g
d291bGQgc2VlIHRoYXQgeW91J3JlIHRyeWluZyB0byBtYXAgYSBwYWdlIFJXWCBzbyB5b3UgY2Fu
IGRvDQp5b3VyIGlvY3RsPw0KDQo+IE5vLCB3ZSBhcmUgbm90IG1ha2luZyBzcGVjaWFsIGNhc2Vz
IGFuZCBleGNlcHRpb25zIGZvciBTR1guDQoNCk1heWJlIEkgZGlkbid0IGV4cHJlc3MgbXlzZWxm
IGNsZWFybHk/IEkgZG9uJ3QgdGhpbmsgSSB3YXMgc3VnZ2VzdGluZw0KYW55dGhpbmcgbGlrZSB0
aGF0Lg0KDQotLQ0KSmV0aHJvIEJlZWttYW4gfCBGb3J0YW5peA0K
