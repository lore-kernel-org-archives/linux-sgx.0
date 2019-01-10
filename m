Return-Path: <SRS0=3+dw=PS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B1AC43387
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 22:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C083208E3
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 22:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfAJWWN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Jan 2019 17:22:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:16657 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbfAJWWN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Jan 2019 17:22:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 14:22:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,462,1539673200"; 
   d="scan'208";a="137231241"
Received: from pgsmsx106.gar.corp.intel.com ([10.221.44.98])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jan 2019 14:22:07 -0800
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.246]) by
 PGSMSX106.gar.corp.intel.com ([169.254.9.46]) with mapi id 14.03.0415.000;
 Fri, 11 Jan 2019 06:22:05 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "luto@kernel.org" <luto@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "greg@enjellic.com" <greg@enjellic.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "jethro@fortanix.com" <jethro@fortanix.com>
Subject: Re: x86/sgx: uapi change proposal
Thread-Topic: x86/sgx: uapi change proposal
Thread-Index: AQHUl3CouNmOMJQZHU2YX8Dh54+gQaWFODMAgAAIjACAAAbWAIAAVlWAgADM8wCAAnSJgIAc/6rw//+proCAAAxngIABJ3KAgAHnBQCAAA04AA==
Date:   Thu, 10 Jan 2019 22:22:05 +0000
Message-ID: <1547158922.20396.13.camel@intel.com>
References: <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
         <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
         <20181219091148.GA5121@linux.intel.com>
         <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
         <20181219144515.GA30909@linux.intel.com>
         <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
         <20181221162825.GB26865@linux.intel.com>
         <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
         <20190108220946.GA30462@linux.intel.com>
         <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
         <20190109163135.GA1821@linux.intel.com>
         <CALCETrW2wPq_umu6jNzCMvR6kphTZhcEody6ok64yyLWvfrvTg@mail.gmail.com>
In-Reply-To: <CALCETrW2wPq_umu6jNzCMvR6kphTZhcEody6ok64yyLWvfrvTg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.182.156]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3230D82A469CD74B867555DD3AB11E2F@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDE5LTAxLTEwIGF0IDEzOjM0IC0wODAwLCBBbmR5IEx1dG9taXJza2kgd3JvdGU6
DQo+ID4gPiBPbiBKYW4gOSwgMjAxOSwgYXQgODozMSBBTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiANCj4gPiA+IE9u
IFR1ZSwgSmFuIDA4LCAyMDE5IGF0IDAyOjU0OjExUE0gLTA4MDAsIEFuZHkgTHV0b21pcnNraSB3
cm90ZToNCj4gPiA+IE9uIFR1ZSwgSmFuIDgsIDIwMTkgYXQgMjowOSBQTSBTZWFuIENocmlzdG9w
aGVyc29uDQo+ID4gPiA8c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbT4gd3JvdGU6DQo+
ID4gPiA+IA0KPiA+ID4gPiBDbGVhbmVyIGluIHRoZSBzZW5zZSB0aGF0IGl0J3MgZmFzdGVyIHRv
IGdldCBiYXNpYyBzdXBwb3J0IHVwIGFuZCBydW5uaW5nDQo+ID4gPiA+IHNpbmNlIHRoZXJlIGFy
ZSBmZXdlciB0b3VjaHBvaW50cywgYnV0IHRoZXJlIGFyZSBsb25nIHRlcm0gcmFtaWZpY2F0aW9u
cw0KPiA+ID4gPiB0byBjcmFtbWluZyBFUEMgbWFuYWdlbWVudCBpbiBLVk0uDQo+ID4gPiA+IA0K
PiA+ID4gPiBBbmQgYXQgdGhpcyBwb2ludCBJJ20gbm90IHN0YXRpbmcgYW55IGFic29sdXRlcywg
ZS5nLiBob3cgRVBDIHdpbGwgYmUNCj4gPiA+ID4gaGFuZGxlZCBieSBLVk0uICBXaGF0IEknbSBw
dXNoaW5nIGZvciBpcyB0byBub3QgZWxpbWluYXRlIHRoZSBwb3NzaWJpbGl0eQ0KPiA+ID4gPiBv
ZiBoYXZpbmcgdGhlIFNHWCBzdWJzeXN0ZW0gb3duIGFsbCBFUEMgbWFuYWdlbWVudCwgZS5nLiBk
b24ndCB0aWUNCj4gPiA+ID4gL2Rldi9zZ3ggdG8gYSBzaW5nbGUgZW5jbGF2ZS4NCj4gPiA+IA0K
PiA+ID4gSSBoYXZlbid0IGdvbmUgYW5kIHJlLXJlYWQgYWxsIHRoZSByZWxldmFudCBTRE0gYml0
cywgc28gSSdsbCBqdXN0DQo+ID4gPiBhc2s6IHdoYXQsIGlmIGFueXRoaW5nLCBhcmUgdGhlIGFj
dHVhbCBzZW1hbnRpY3Mgb2YgbWFwcGluZyAicmF3IEVQQyINCj4gPiA+IGxpa2UgdGhpcz8gIFlv
dSBjYW4ndCBhY3R1YWxseSBkbyBhbnl0aGluZyB3aXRoIHRoZSBtYXBwaW5nIGZyb20gdXNlcg0K
PiA+ID4gbW9kZSB1bmxlc3MgeW91IGFjdHVhbGx5IGdldCBhbiBlbmNsYXZlIGNyZWF0ZWQgYW5k
IGluaXRpYWxpemVkIGluIGl0DQo+ID4gPiBhbmQgaGF2ZSBpdCBtYXBwZWQgYXQgdGhlIGNvcnJl
Y3QgbGluZWFyIGFkZHJlc3MsIHJpZ2h0PyAgSSBzdGlsbA0KPiA+ID4gdGhpbmsgeW91IGhhdmUg
dGhlIHJpZ2h0IGlkZWEsIGJ1dCBpdCBpcyBhIGJpdCB1bnVzdWFsLg0KPiA+IA0KPiA+IENvcnJl
Y3QsIHRoZSBFUEMgaXMgaW5hY2Nlc3NpYmxlIHVudGlsIGEgcmFuZ2UgaXMgIm1hcHBlZCIgd2l0
aCBFQ1JFQVRFLg0KPiA+IEJ1dCBJJ2QgYXJndWUgdGhhdCBpdCdzIG5vdCB1bnVzdWFsLCBqdXN0
IGRpZmZlcmVudC4gIEFuZCByZWFsbHkgaXQncyBub3QNCj4gPiBhbGwgdGhhdCBkaWZmZXJlbnQg
dGhhbiB1c2Vyc3BhY2UgbW1hcCdpbmcgL2Rldi9zZ3gvZW5jbGF2ZSBwcmlvciB0bw0KPiA+IGlv
Y3RsKEVOQ0xBVkVfQ1JFQVRFKS4gIEluIHRoYXQgY2FzZSwgdXNlcnNwYWNlIGNhbiBzdGlsbCAo
YXR0ZW1wdCB0bykNCj4gPiBhY2Nlc3MgdGhlICJyYXciIEVQQywgaS5lLiBnZW5lcmF0ZSBhICNQ
RiwgdGhlIGtlcm5lbC9kcml2ZXIganVzdCBoYXBwZW5zDQo+ID4gdG8gY29uc2lkZXIgYW55IGZh
dWx0aW5nIEVQQyBhZGRyZXNzIHdpdGhvdXQgYW4gYXNzb2NpYXRlZCBlbmNsYXZlIGFzDQo+ID4g
aWxsZWdhbCwgZS5nLiBzaWduYWxzIFNJR0JVUy4NCj4gPiANCj4gPiBUaGUgL2Rldi9zZ3gvZXBj
IGNhc2Ugc2ltcGx5IGhhcyBkaWZmZXJlbnQgc2VtYW50aWNzIGZvciBtb3ZpbmcgcGFnZXMgaW4N
Cj4gPiBhbmQgb3V0IG9mIHRoZSBFUEMsIGkuZS4gZGlmZmVyZW50IGZhdWx0IGFuZCBldmljdGlv
biBzZW1hbnRpY3MuICBZZXMsDQo+ID4gdGhpcyBhbGxvd3MgdGhlIGd1ZXN0IGtlcm5lbCB0byBk
aXJlY3RseSBhY2Nlc3MgdGhlICJyYXciIEVQQywgYnV0IHRoYXQncw0KPiA+IGNvbmNlcHR1YWxs
eSBpbiBsaW5lIHdpdGggaGFyZHdhcmUgd2hlcmUgcHJpdmVsZWdlZCBzb2Z0d2FyZSBjYW4gZGly
ZWN0bHkNCj4gPiAiYWNjZXNzIiB0aGUgRVBDIChvciByYXRoZXIsIHRoZSBhYm9ydCBwYWdlIGZv
ciBhbGwgaW50ZW50cyBhbmQgcHVycG9zZXMpLg0KPiA+IEkuZS4gaXQncyBhbiBhcmd1bWVudCBm
b3IgcmVxdWlyaW5nIGNlcnRhaW4gcHJpdmlsZWdlcyB0byBvcGVuIC9kZXYvc2d4L2VwYywNCj4g
PiBidXQgSU1PIGl0J3Mgbm90IHVudXN1YWwuDQo+ID4gDQo+ID4gTWF5YmUgL2Rldi9zZ3gvZXBj
IGlzIGEgcG9vciBuYW1lIGFuZCBpcyBjYXVzaW5nIGNvbmZ1c2lvbiwgZS5nLg0KPiA+IC9kZXYv
c2d4L3ZpcnR1YWxtYWNoaW5lIG1pZ2h0IGJlIG1vcmUgYXBwcm9wcmlhdGUuDQo+ID4gDQo+ID4g
PiBJIGRvIHRoaW5rIGl0IG1ha2VzIHNlbnNlIHRvIGhhdmUgUUVNVSBkZWxlZ2F0ZSB0aGUgdmFy
aW91cyBFTkNMUw0KPiA+ID4gb3BlcmF0aW9ucyAoZXNwZWNpYWxseSBFSU5JVCkgdG8gdGhlIHJl
Z3VsYXIgU0dYIGludGVyZmFjZSwgd2hpY2ggd2lsbA0KPiA+ID4gbWVhbiB0aGF0IFZNIGd1ZXN0
cyB3aWxsIGhhdmUgZXhhY3RseSB0aGUgc2FtZSBhY2Nlc3MgY29udHJvbHMgYXBwbGllZA0KPiA+
ID4gYXMgcmVndWxhciB1c2VyIHByb2dyYW1zLCB3aGljaCBpcyBwcm9iYWJseSB3aGF0IHdlIHdh
bnQuDQo+ID4gDQo+ID4gVG8gd2hhdCBlbmQ/ICBFeGNlcHQgZm9yIEVJTklULCBub25lIG9mIHRo
ZSBFTkNMUyBsZWFmcyBhcmUgaW50ZXJlc3RpbmcNCj4gPiBmcm9tIGEgcGVybWlzc2lvbnMgcGVy
c3BlY3RpdmUuICBUcmFwcGluZyBhbmQgcmUtZXhlY3V0aW5nIEVOQ0xTIGxlYWZzDQo+ID4gaXMg
cGFpbmZ1bCwgZS5nLiBtb3N0IGxlYWZzIGhhdmUgbXVsdGlwbGUgdmlydHVhbCBhZGRyZXNzZXMg
dGhhdCBuZWVkIHRvDQo+ID4gYmUgdHJhbnNsYXRlZC4gIEFuZCByb3V0aW5nIGV2ZXJ5dGhpbmcg
dGhyb3VnaCB0aGUgcmVndWxhciBpbnRlcmZhY2UNCj4gPiB3b3VsZCBtYWtlIFNHWCBldmVuIHNs
b3dlciB0aGFuIGl0IGFscmVhZHkgaXMsIGUuZy4gZXZlcnkgRU5DTFMgd291bGQNCj4gPiB0YWtl
IGFuIGFkZGl0aW9uYWwgfjkwMCBjeWNsZXMganVzdCB0byBoYW5kbGUgdGhlIFZNLUV4aXQsIGFu
ZCB0aGF0J3MNCj4gPiBub3QgYWNjb3VudGluZyBmb3IgYW55IGFkZGl0aW9uYWwgb3ZlcmhlYWQg
aW4gdGhlIFNHWCBjb2RlLCBlLmcuIHVzaW5nDQo+ID4gdGhlIHJlZ3VsYXIgaW50ZXJmYWNlIHdv
dWxkIG1lYW4gc3VwZXJmbHVvdXMgbG9ja3MsIGV0Yy4uLg0KPiANCj4gVHJhcHBpbmcgRUlOSVQg
aXMgd2hhdCBJIGhhdmUgaW4gbWluZC4NCj4gDQo+ID4gDQo+ID4gQ291bGRuJ3Qgd2UgcmVxdWly
ZSB0aGUgc2FtZSBwcml2aWxlZ2UvY2FwYWJpbGl0eSBmb3IgVk1zIGFuZCBhbmQgRUlOSVQNCj4g
PiB0b2tlbnM/ICBJLmUuIC9kZXYvc2d4L3ZpcnR1YWxtYWNoaW5lIGNhbiBvbmx5IGJlIG9wZW5l
ZCBieSBhIHVzZXIgdGhhdA0KPiA+IGNhbiBhbHNvIGdlbmVyYXRlIHRva2Vucy4NCj4gDQo+IEht
bSwgbWF5YmUuICBPciB3ZSBjYW4gdXNlIEphcmtrb+KAmXMgc2VjdXJpdHlmcyBhdHRyaWJ1dGUg
dGhpbmd5Lg0KPiANCj4gQ29uY3JldGVseSwgSSB0aGluayB0aGVyZSBhcmUgdHdvIHRoaW5ncyB3
ZSBjYXJlIGFib3V0Og0KPiANCj4gRmlyc3QsIGlmIHRoZSBob3N0IGVuZm9yY2VzIHNvbWUgcG9s
aWN5IGFzIHRvIHdoaWNoIGVuY2xhdmVzIGNhbg0KPiBsYXVuY2gsIHRoZW4gaXQgc2hvdWxkIGFw
cGx5IHRoZSBzYW1lIHBvbGljeSB0byBndWVzdHMg4oCUIG90aGVyd2lzZSBLVk0NCj4gbGV0cyBw
cm9ncmFtcyBkbyBhbiBlbmQgcnVuIGFyb3VuZCB0aGUgcG9saWN5LiBTbywgaW4gdGhlIGluaXRp
YWwNCj4gaW5jYXJuYXRpb24gb2YgdGhpcywgUUVNVSBzaG91bGQgcHJvYmFibHkgaGF2ZSB0byBv
cGVuIHRoZSBwcm92aXNpb24NCj4gYXR0cmlidXRlIGZkIGlmIGl0IHdhbnRzIGl0cyBndWVzdCB0
byBiZSBhYmxlIHRvIEVJTklUIGEgcHJvdmlzaW9uaW5nDQo+IGVuY2xhdmUuICBXaGVuIHNvbWVv
bmUgaW5ldml0YWJseSBhZGRzIGFuIEVJTklUIExTTSBob29rLCB0aGUgS1ZNDQo+IGludGVyZmFj
ZSBzaG91bGQgYWxzbyBjYWxsIGl0Lg0KPiANCj4gU2Vjb25kLCB0aGUgbm9ybWFsIGVuY2xhdmUg
aW50ZXJmYWNlIHdvbid0IGFsbG93IHVzZXIgY29kZSB0byBzdXBwbHkNCj4gYW4gRUlOSVRUT0tF
Tiwgc28gdGhlIEtWTSBpbnRlcmZhY2Ugd2lsbCBwcmVzdW1hYmx5IG5lZWQgdG8gYmUNCj4gZGlm
ZmVyZW50LCB1bmxlc3Mgd2UncmUgZ29pbmcgdG8gZW11bGF0ZSBFSU5JVCBieSBpZ25vcmluZyB0
aGUgdG9rZW4uDQo+IFRoYXQgc2VlbXMgbGlrZSBhIHZlcnkgc3RyYW5nZSB0aGluZyB0byBkby4N
Cg0KSGkgQW5keSwNCg0KSU1ITyBhcHBseWluZyBwb2xpY3kgdG8gZW5jbGF2ZSBpbiBWTSBzaG91
bGQgYmUgZGlmZmVyZW50IHRvIGFwcGx5aW5nIHBvbGljeSB0byBlbmNsYXZlIGluIGhvc3QuIFNH
WA0Kc3cgc3RhY2sgaW4gaG9zdCBzaG91bGQgYmUgYWJsZSB0byBydW4gaW5zaWRlIFZNIHdpdGhv
dXQgYW55IG1vZGlmaWNhdGlvbiwgc28gZm9yIGV4YW1wbGUsIGlmIGhvc3QNCnNldHMgcG9saWN5
IHRoYXQgd2UgY2Fubm90IHJ1biBMRSAoZXhjZXB0IExFIGluIGhvc3QpLCB0aGVuIGJhc2ljYWxs
eSB3ZSBhcmUgZGlzYWJsaW5nIFNHWCBpbiBWTS4gSW4NCmdlbmVyYWwgS1ZNIFNHWCBpcyBzdXBw
b3NlZCB0byBydW4gYWxsIGd1ZXN0IE9TZXMgd2l0aCBTR1guIEFuZCBmb3IgcHJvdmlzaW9uaW5n
IGVuY2xhdmUsIGRvIHlvdSBzZWUNCmFueSByZWFzb24gdGhhdCB3ZSBuZWVkIHRvIGRpc2FsbG93
IHRvIHJ1biBpdCBpbnNpZGUgVk0/DQoNCk1heWJlIHNvbWUgbW9yZSBnZW5lcmFsIHF1ZXN0aW9u
czogV2hhdCBwb2xpY3kvcG9saWNpZXMgc2hvdWxkIHdlIGhhdmUgaW4gaG9zdD8gU2hvdWxkIHRo
ZXkgaW4gY29yZS0NClNHWCBjb2RlLCBvciBzaG91bGQgdGhleSBiZWxvbmcgdG8gU0dYIGRyaXZl
cidzIHNjb3BlPyBEbyB3ZSBuZWVkIHRvIGZpZ3VyZSBvdXQgYWxsIG9mIHRoZW0gYW5kIGhvdw0K
dG8gY29udHJvbCBiZWZvcmUgd2UgY2FuIGFjdHVhbGx5IHRoaW5rIGFib3V0IHVwc3RyZWFtaW5n
IHZpcnR1YWxpemF0aW9uIHN1cHBvcnQ/DQoNClRoYW5rcywNCi1LYWk=
