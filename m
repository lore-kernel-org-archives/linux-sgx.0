Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F61BC282E0
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 21:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D12FC2171F
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 21:05:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="ovznqg8H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfDSVFt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 17:05:49 -0400
Received: from mail-eopbgr720121.outbound.protection.outlook.com ([40.107.72.121]:4293
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726120AbfDSVFt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Apr 2019 17:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPuKM2SUxKB6N7+Mw0a0VsLNsrxkeM3zv/1h9c4ENXM=;
 b=ovznqg8HHjgoEVn+D+5W5PPYAuE6Rc2LC7A8khvtmpqo6WXk3XXxotmsohec0sxhU/AlBpX9hKytaXy6/3vMlsT6ChXz3/UrCtLRKENRw/epje/L7Sysru0keJfbpm+3M+l+z34zZPld8UQ+V+xWwb4JFxQcjbGeDe1Fm/w1vCU=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3232.namprd11.prod.outlook.com (52.135.112.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.14; Fri, 19 Apr 2019 21:05:44 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d%3]) with mapi id 15.20.1813.013; Fri, 19 Apr 2019
 21:05:44 +0000
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
Thread-Index: AQHU9QnkBhtGQ+66Y0uqVL4+2rp75qZCKU6AgAAN+gCAAVPlAIAAE4gAgABGE4CAABE+gIAAAfEAgAAFP4A=
Date:   Fri, 19 Apr 2019 21:05:44 +0000
Message-ID: <72a190fa-34b6-62ff-f52d-1693f70c59cc@fortanix.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190418171059.GA20819@wind.enjellic.com>
 <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
 <20190419141732.GA2269@wind.enjellic.com>
 <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
 <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com>
 <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de>
 <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com>
In-Reply-To: <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::16) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e2c946e-105c-40f8-55dc-08d6c50ac9be
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600141)(711020)(4605104)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7193020);SRVR:SN6PR11MB3232;
x-ms-traffictypediagnostic: SN6PR11MB3232:
x-microsoft-antispam-prvs: <SN6PR11MB32327F14E7CE23265C4656AAAA270@SN6PR11MB3232.namprd11.prod.outlook.com>
x-forefront-prvs: 0012E6D357
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(366004)(39840400004)(396003)(376002)(199004)(189003)(43544003)(93886005)(316002)(14444005)(52116002)(508600001)(102836004)(5660300002)(86362001)(186003)(66446008)(26005)(36756003)(8936002)(64756008)(256004)(66556008)(66946007)(4326008)(2616005)(6916009)(81166006)(14454004)(97736004)(6486002)(71200400001)(305945005)(2906002)(486006)(8676002)(6116002)(7736002)(81156014)(446003)(71190400001)(3846002)(68736007)(66066001)(54906003)(31686004)(6512007)(11346002)(53936002)(7416002)(76176011)(31696002)(6436002)(476003)(66476007)(229853002)(25786009)(99286004)(6506007)(6246003)(53546011)(73956011)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3232;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 496NfF/hfLk2BB/+oKWWBlEtKP2Ajxgk+yPw2jOcHfN/oyFk+tX3u7CTPfFG+pXm6uEvB8xjPg3EVrXQx1UzaRaLe3Er24vyQb0DkvdQmJobHfKf+IbIyvVRZ3mVOJx3/HY6y0I9Uv1fhfPvPmF6npYzOzE5vhPmDTvvTvzzZ3mY50qHE9T75SMnCKzgLpcy7VsS7d0wFix6Zuq5T3HoEOAdlF6bGTOo/cZIg8wrnQi3infWqX6oBO7p2vETPx28DsErC2+P7+REWrSQNEW0cWCXYKx5Zea7QmhlnBqSmtpEsa3fSSoRNVh6vOWpz9IeGtBZclT/S+wInzhWQnxrKbmRVHmAxVwnX6K6dmqvKYvBdWnyht+jHdZu6WYd9OjeVy4N4Ge0T0+ZQ2TUmt44+sCixlLKxjJjGr1nnkPqKDY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6149A358BEEAE49816331A22C3726D6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2c946e-105c-40f8-55dc-08d6c50ac9be
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2019 21:05:44.6424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3232
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gMjAxOS0wNC0xOSAxMzo0NiwgSmV0aHJvIEJlZWttYW4gd3JvdGU6DQo+IE9uIDIwMTktMDQt
MTkgMTM6MzksIFRob21hcyBHbGVpeG5lciB3cm90ZToNCj4+IE9uIEZyaSwgMTkgQXByIDIwMTks
IEpldGhybyBCZWVrbWFuIHdyb3RlOg0KPj4NCj4+PiBPbiAyMDE5LTA0LTE5IDA4OjI3LCBBbmR5
IEx1dG9taXJza2kgd3JvdGU6DQo+Pj4+IFRoZXJlIGFyZSBtYW55LA0KPj4+PiBtYW55IExpbnV4
IHN5c3RlbXMgdGhhdCBlbmZvcmNlIGEgcG9saWN5IHRoYXQgKmFsbCogZXhlY3V0YWJsZSB0ZXh0
DQo+Pj4+IG5lZWRzIHRvIGNvbWUgZnJvbSBhIHZlcmlmaWVkIHNvdXJjZS4gIE9uIHRoZXNlIHN5
c3RlbXMsIHlvdSBjYW4ndA0KPj4+PiBtbWFwIHNvbWUgd3JpdGFibGUgbWVtb3J5LCB3cml0ZSB0
byBpdCwgYW5kIHRoZW4gY2hhbmdlIGl0IHRvDQo+Pj4+IGV4ZWN1dGFibGUuDQo+Pj4NCj4+PiBI
b3cgaXMgdGhpcyBpbXBsZW1lbnRlZCBvbiB0aG9zZSBzeXN0ZW1zPyBBRkFJSyB0aGVyZSdzIG5v
IGtlcm5lbCBjb25maWcNCj4+PiBvcHRpb24gdGhhdCBjaGFuZ2VzIHRoZSBzZW1hbnRpY3Mgb2Yg
bW1hcCBhcyB5b3UgZGVzY3JpYmUuDQo+Pg0KPj4gVGhhdCBoYXMgbm90aGluZyB0byBkbyB3aXRo
IG1tYXAoKSBzZW1hbnRpY3MuIFlvdSBtbWFwKCkgd3JpdGVhYmxlIG1lbW9yeQ0KPj4gYW5kIHRo
ZW4geW91IGNoYW5nZSB0aGUgcGVybWlzc2lvbnMgdmlhIG1wcm90ZWN0KCkuIG1wcm90ZWN0KCkg
Y2FsbHMgaW50bw0KPj4gTFNNIGFuZCBkZXBlbmRpbmcgb24gcG9saWN5IGFuZCBzZWN1cml0eSBt
b2RlbCB0aGlzIHdpbGwgcmVqZWN0IHRoZQ0KPj4gcmVxdWVzdC4NCj4+DQo+PiBBbmR5IHdhcyBw
b2ludGluZyBvdXQgdGhhdCB0aGUgU0dYIGlvY3RsIGJ5cGFzc2VzIHRoZSBMU00gbWVjaGFuaWNz
IHdoaWNoDQo+PiBpcyBvYnZpb3VzbHkgYSBiYWQgdGhpbmcuDQo+IA0KPiBXZSBjb3VsZCBtb2Rp
ZnkgdGhlIGRyaXZlciBzdWNoIHRoYXQgd2hlbiB5b3UgY2FsbCBpb2N0bCBFQURELCB0aGUgcGFn
ZQ0KPiB0YWJsZSBwZXJtaXNzaW9ucyBuZWVkIHRvIGJlIHRoZSBQQUdFSU5GTy5TRUNJTkZPLkZM
QUdTIHwgUFJPVF9XUklURSwNCj4gb3RoZXJ3aXNlIHlvdSBnZXQgRVBFUk0gb3Igc28uIEFmdGVy
IEVBREQsIGlmIHlvdSB3YW50LCB5b3UgY2FuIHJlc3RyaWN0DQoNCkFjdHVhbGx5LCBJIGRvbid0
IHRoaW5rIHlvdSBldmVuIG5lZWQgdG8gaW5jbHVkZSBQQUdFSU5GTy5TRUNJTkZPLkZMQUdTLA0K
eW91IGp1c3QgbmVlZCB0byBlbnN1cmUgUFJPVF9XUklURS4gUmVndWxhciBwYWdlIHRhYmxlIGNo
ZWNrcyB0YWtlIGNhcmUNCm9mIFBBR0VJTkZPLlNFQ0lORk8uRkxBR1MuDQoNCi0tDQpKZXRocm8g
QmVla21hbiB8IEZvcnRhbml4DQo=
