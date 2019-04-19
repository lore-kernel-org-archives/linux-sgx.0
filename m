Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC4DC282E2
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 20:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6AE82171F
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 20:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="cekhzssQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfDSUrC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 16:47:02 -0400
Received: from mail-eopbgr810135.outbound.protection.outlook.com ([40.107.81.135]:6167
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726455AbfDSUrC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Apr 2019 16:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tm6JXoYeRQgbEwbr9Zxy9IBwJp6mLY2u2wkYAsvuQH4=;
 b=cekhzssQnpE+op3k57YRBVGvXbnwOpzKwhi2BYZyxiiNJY6fkrUc4zSgRwbmbEQk1SSmEdiMShzO9JKJa5LTk87QbqwIKnDFH9oXhtKqNzcMM9ST/Oce0QuXNI2WgcJ6VrZZ6uw9ipUKxnrdH3NRihSOtq8igcKNdaCZR/if/uA=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3341.namprd11.prod.outlook.com (52.135.111.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.16; Fri, 19 Apr 2019 20:46:57 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d%3]) with mapi id 15.20.1813.013; Fri, 19 Apr 2019
 20:46:57 +0000
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
Thread-Index: AQHU9QnkBhtGQ+66Y0uqVL4+2rp75qZCKU6AgAAN+gCAAVPlAIAAE4gAgABGE4CAABE+gIAAAfEA
Date:   Fri, 19 Apr 2019 20:46:57 +0000
Message-ID: <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190418171059.GA20819@wind.enjellic.com>
 <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
 <20190419141732.GA2269@wind.enjellic.com>
 <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
 <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com>
 <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0047.namprd07.prod.outlook.com
 (2603:10b6:a03:60::24) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 581ddceb-5ede-4dc9-1357-08d6c50829e1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR11MB3341;
x-ms-traffictypediagnostic: SN6PR11MB3341:
x-microsoft-antispam-prvs: <SN6PR11MB33413A3C6BA31712DBF8AE2AAA270@SN6PR11MB3341.namprd11.prod.outlook.com>
x-forefront-prvs: 0012E6D357
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(136003)(39840400004)(366004)(189003)(199004)(6436002)(305945005)(6486002)(7736002)(71190400001)(186003)(71200400001)(53936002)(6512007)(54906003)(229853002)(6116002)(316002)(6916009)(7416002)(14454004)(508600001)(3846002)(2906002)(66066001)(26005)(6506007)(53546011)(76176011)(476003)(386003)(81156014)(8936002)(102836004)(52116002)(68736007)(81166006)(93886005)(256004)(8676002)(14444005)(31686004)(99286004)(86362001)(31696002)(66476007)(97736004)(446003)(5660300002)(486006)(6246003)(36756003)(4326008)(66946007)(11346002)(66556008)(2616005)(73956011)(25786009)(64756008)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3341;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: At55TULCxsFO8epLWx12vOGWN4nZUMGkFWkqT0uKEb6T0iBKMcgsV3eMqX6hFmV3JedCLMXLL5lazBPk4Xxbe90I9Kb69mo82kc216WxNqsRRPPeYGi9DfJD2yZFUKDgQ/YEOFMheY40UIbeudggsM0OyO3UbU/8LSi2pffetL8WANC9/DxizGnRG1C8e12rshzlzY8p/UXhYUenP5/nX5nBxgEeE1zbd0HmiEGwJ3wwXDKGp5g6V/LYoj+E7E1RpKbkIbwaT+TsuNAP/NooFBO00F/1xIgyR7AedI0kJXWqs3V/wh0V0u9Ax4UjLxQVoGz6CmUVDb0vmshz/L54Z1tkOuqnitdfVsppgtAeS7twXtzrSVtfaew7flnorgJ2Z5mWCfobnEZFuTIfsfJPHZUx+viEem1XlZZv2TQ+SMw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0929D3224B70A94D91C47A0D42F07743@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 581ddceb-5ede-4dc9-1357-08d6c50829e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2019 20:46:57.5562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3341
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gMjAxOS0wNC0xOSAxMzozOSwgVGhvbWFzIEdsZWl4bmVyIHdyb3RlOg0KPiBPbiBGcmksIDE5
IEFwciAyMDE5LCBKZXRocm8gQmVla21hbiB3cm90ZToNCj4gDQo+PiBPbiAyMDE5LTA0LTE5IDA4
OjI3LCBBbmR5IEx1dG9taXJza2kgd3JvdGU6DQo+Pj4gVGhlcmUgYXJlIG1hbnksDQo+Pj4gbWFu
eSBMaW51eCBzeXN0ZW1zIHRoYXQgZW5mb3JjZSBhIHBvbGljeSB0aGF0ICphbGwqIGV4ZWN1dGFi
bGUgdGV4dA0KPj4+IG5lZWRzIHRvIGNvbWUgZnJvbSBhIHZlcmlmaWVkIHNvdXJjZS4gIE9uIHRo
ZXNlIHN5c3RlbXMsIHlvdSBjYW4ndA0KPj4+IG1tYXAgc29tZSB3cml0YWJsZSBtZW1vcnksIHdy
aXRlIHRvIGl0LCBhbmQgdGhlbiBjaGFuZ2UgaXQgdG8NCj4+PiBleGVjdXRhYmxlLg0KPj4NCj4+
IEhvdyBpcyB0aGlzIGltcGxlbWVudGVkIG9uIHRob3NlIHN5c3RlbXM/IEFGQUlLIHRoZXJlJ3Mg
bm8ga2VybmVsIGNvbmZpZw0KPj4gb3B0aW9uIHRoYXQgY2hhbmdlcyB0aGUgc2VtYW50aWNzIG9m
IG1tYXAgYXMgeW91IGRlc2NyaWJlLg0KPiANCj4gVGhhdCBoYXMgbm90aGluZyB0byBkbyB3aXRo
IG1tYXAoKSBzZW1hbnRpY3MuIFlvdSBtbWFwKCkgd3JpdGVhYmxlIG1lbW9yeQ0KPiBhbmQgdGhl
biB5b3UgY2hhbmdlIHRoZSBwZXJtaXNzaW9ucyB2aWEgbXByb3RlY3QoKS4gbXByb3RlY3QoKSBj
YWxscyBpbnRvDQo+IExTTSBhbmQgZGVwZW5kaW5nIG9uIHBvbGljeSBhbmQgc2VjdXJpdHkgbW9k
ZWwgdGhpcyB3aWxsIHJlamVjdCB0aGUNCj4gcmVxdWVzdC4NCj4gDQo+IEFuZHkgd2FzIHBvaW50
aW5nIG91dCB0aGF0IHRoZSBTR1ggaW9jdGwgYnlwYXNzZXMgdGhlIExTTSBtZWNoYW5pY3Mgd2hp
Y2gNCj4gaXMgb2J2aW91c2x5IGEgYmFkIHRoaW5nLg0KDQpXZSBjb3VsZCBtb2RpZnkgdGhlIGRy
aXZlciBzdWNoIHRoYXQgd2hlbiB5b3UgY2FsbCBpb2N0bCBFQURELCB0aGUgcGFnZQ0KdGFibGUg
cGVybWlzc2lvbnMgbmVlZCB0byBiZSB0aGUgUEFHRUlORk8uU0VDSU5GTy5GTEFHUyB8IFBST1Rf
V1JJVEUsDQpvdGhlcndpc2UgeW91IGdldCBFUEVSTSBvciBzby4gQWZ0ZXIgRUFERCwgaWYgeW91
IHdhbnQsIHlvdSBjYW4gcmVzdHJpY3QNCnRoZSBwYWdlIHRhYmxlIHBlcm1pc3Npb25zIGFnYWlu
IHVzaW5nIG1wcm90ZWN0IGJ1dCB0aGUgcGFnZSB0YWJsZQ0KcGVybWlzc2lvbnMgZG9uJ3QgcmVh
bGx5IG1hdHRlciBmb3IgU0dYLg0KDQotLQ0KSmV0aHJvIEJlZWttYW4gfCBGb3J0YW5peA0K
