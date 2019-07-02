Return-Path: <SRS0=bK9D=U7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89CF7C4646D
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Jul 2019 06:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68D6E216C8
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Jul 2019 06:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbfGBGgA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Jul 2019 02:36:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:46424 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfGBGgA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 2 Jul 2019 02:36:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 23:35:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,442,1557212400"; 
   d="scan'208";a="315124516"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga004.jf.intel.com with ESMTP; 01 Jul 2019 23:35:43 -0700
Received: from orsmsx153.amr.corp.intel.com (10.22.226.247) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 23:35:43 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX153.amr.corp.intel.com ([169.254.12.252]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 23:35:43 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Topic: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Index: AQHVLG/L9SgvyZq9qEim/LcvveBd6KazxkIAgAI8SeCAAIcaAP//kNKQgACKcwD//4xFUIAA5zOA///F7XA=
Date:   Tue, 2 Jul 2019 06:35:42 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551DB90@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <CALCETrWQUEEwAAdPrVQMengKDhX3-fVrtJwaP2i=mWD+s+B8vg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D4B3@ORSMSX116.amr.corp.intel.com>
 <CALCETrUR=W3rfmG+qHydm0FQvASSYRt_V72v5WeQ4KWT7tjEdA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D5FA@ORSMSX116.amr.corp.intel.com>
 <CALCETrUAme7ujK3j-6gg1=_FtVGY3ZM8WBg9_9Sn-keywd7Smg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D75B@ORSMSX116.amr.corp.intel.com>
 <CALCETrVRDBN_AcKQaYbodtUVv5vW=s2bWP2OAucw=8OjhWo=ng@mail.gmail.com>
In-Reply-To: <CALCETrVRDBN_AcKQaYbodtUVv5vW=s2bWP2OAucw=8OjhWo=ng@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTA1MmJlODYtMmQ0Mi00NDljLWExODQtNjM4NGIxNzNiMGE4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRGpxNTV4YTRaME91U01QZ2RxUkRvRjFDN2NQZG5NeVVYZXF4TUU1Z01NdmdvbVdXRmxMTGtRYlJLWjUyaG9CSyJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5vcmddDQo+IFNlbnQ6
IE1vbmRheSwgSnVseSAxLCAyMDE5IDc6MjkgUE0NCj4gDQo+IE9uIE1vbiwgSnVsIDEsIDIwMTkg
YXQgMTI6NTYgUE0gWGluZywgQ2VkcmljIDxjZWRyaWMueGluZ0BpbnRlbC5jb20+IHdyb3RlOg0K
PiA+DQo+ID4gPiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5vcmdd
DQo+ID4gPiBTZW50OiBNb25kYXksIEp1bHkgMDEsIDIwMTkgMTI6MzYgUE0NCj4gPiA+DQo+ID4g
PiBPbiBNb24sIEp1bCAxLCAyMDE5IGF0IDExOjMxIEFNIFhpbmcsIENlZHJpYyA8Y2VkcmljLnhp
bmdAaW50ZWwuY29tPg0KPiA+ID4gd3JvdGU6DQo+ID4gPiA+IEkgaW50ZW5kZWQgdG8gc2F5IHRo
ZSBtYWpvciByZWFzb24gSSBvYmplY3RlZCBTZWFuJ3MgYXBwcm9hY2ggd2FzIGl0cw0KPiA+ID4g
aW5hYmlsaXR5IHRvIHN1cHBvcnQgU0dYMiBzbW9vdGhseSAtIGFzICNQRiBkcml2ZW4gRUFVRyBy
ZXF1aXJlcyBub24tDQo+ID4gPiBleGlzdGVudCBwYWdlcyB0byBiZSBtbWFwKCknZWQsIG90aGVy
d2lzZSB2bV9vcHMtPmZhdWx0IHdvdWxkbid0IGJlDQo+ID4gPiBkaXNwYXRjaGVkIHNvIEVBVUcg
Y291bGRuJ3QgYmUgaXNzdWVkIGluIHJlc3BvbnNlIHRvICNQRi4NCj4gPiA+DQo+ID4gPiBJIHN0
aWxsIHRoaW5rIHRoYXQsIGlmIHRoZSBrZXJuZWwgd2FudHMgdG8gc3VwcG9ydCAjUEYtZHJpdmVu
IEVBVUcsIGl0DQo+ID4gPiBzaG91bGQgYmUgYW4gb3B0LWluIHRoaW5nLiAgSXQgd291bGQgYmUg
c29tZXRoaW5nIGxpa2UNCj4gPiA+IFNHWF9JT0NfQUREX0xBWllfRUFVR19QQUdFUyBvciBzaW1p
bGFyLiAgSWYgaXQncyBkb25lIHRoYXQgd2F5LCB0aGVuDQo+ID4gPiB0aGUgZHJpdmVyIG5lZWRz
IHRvIGxlYXJuIGhvdyB0byB0cmFjayByYW5nZXMgb2YgcGFnZXMgZWZmaWNpZW50bHksDQo+ID4g
PiB3aGljaCBpcyBhbm90aGVyIHJlYXNvbiB0byBjb25zaWRlciBsZWF2aW5nIGFsbCB0aGUgZmFu
Y3kgcGFnZSAvIHBhZ2UNCj4gPiA+IHJhbmdlIHRyYWNraW5nIGluIHRoZSBkcml2ZXIuDQo+ID4g
Pg0KPiA+ID4gSSBkb24ndCB0aGluayBpdCdzIGEgZ29vZCBpZGVhIGZvciBhIHBhZ2UgZmF1bHQg
b24gYW55IG5vbi1FQUREZWQgcGFnZQ0KPiA+ID4gaW4gRUxSQU5HRSB0byBhdXRvbWF0aWNhbGx5
IHBvcHVsYXRlIHRoZSBwYWdlLg0KPiA+DQo+ID4gSSdtIHdpdGggeW91LiBUaGUgdXNlciBjb2Rl
IHNoYWxsIGJlIGV4cGxpY2l0IG9uIHdoaWNoIHJhbmdlIHRvIEVBVUcgcGFnZXMgdXBvbiAjUEYu
DQo+IFdoYXQgSSdtIHNheWluZyBpcywgYSByYW5nZSBoYXMgdG8gYmUgbWFwcGVkIGJlZm9yZSB0
aGUgZHJpdmVyIGNvdWxkIHJlY2VpdmUgI1BGcyAoaW4gdGhlDQo+IGZvcm0gb2Ygdm1fb3BzLT5m
YXVsdCBjYWxsYmFja3MpLiBCdXQgU2VhbidzIHNlcmllcyBkb2VzbuKAmXQgc3VwcG9ydCB0aGF0
IGJlY2F1c2Ugbm8gcGFnZXMNCj4gY2FuIGJlIG1hcHBlZCBiZWZvcmUgY29taW5nIGludG8gZXhp
c3RlbmNlLg0KPiA+DQo+ID4gRm9yICJwYWdlIHRyYWNraW5nIiwgd2hhdCBpbmZvcm1hdGlvbiB0
byB0cmFjayBpcyBMU00gZGVwZW5kZW50LCBzbyBpdCBtYXkgcnVuIGludG8NCj4gcHJvYmxlbXMg
aWYgZGlmZmVyZW50IExTTXMgd2FudCB0byB0cmFjayBkaWZmZXJlbnQgdGhpbmdzLiBBbmQgdGhh
dCdzIHRoZSBtYWpvciByZWFzb24gSQ0KPiB0aGluayBpdCBzaG91bGQgYmUgZG9uZSBpbnNpZGUg
TFNNLg0KPiA+DQo+ID4gQmVzaWRlcywgdGhlIGN1cnJlbnQgcGFnZSB0cmFja2luZyBzdHJ1Y3R1
cmUgaW4gdGhlIGRyaXZlciBpcyBwYWdlIG9yaWVudGVkIGFuZCBpdHMgc29sZQ0KPiBwdXJwb3Nl
IGlzIHRvIHNlcnZlICNQRnMuIFBhZ2UgcHJvdGVjdGlvbiBpcyBiZXR0ZXIgdHJhY2tlZCB1c2lu
ZyByYW5nZSBvcmllbnRlZA0KPiBzdHJ1Y3R1cmVzLiBUaG9zZSAyIGFyZSBvcnRob2dvbmFsLiBJ
dCB3b3VsZG4ndCByZWR1Y2UgdGhlIGNvbXBsZXhpdHkgb2YgdGhlIHdob2xlIGtlcm5lbA0KPiBi
eSBtb3ZpbmcgaXQgaW50byBTR1ggZHJpdmVyLg0KPiANCj4gSXQgc2VlbXMgdG8gbWUgdGhhdCB0
aGUgZHJpdmVyIGlzIGdvaW5nIHRvIG5lZWQgdG8gaW1wcm92ZSBpdHMgZGF0YQ0KPiBzdHJ1Y3R1
cmVzIHRvIHRyYWNrIHJhbmdlcyBvZiBwYWdlcyByZWdhcmRsZXNzIG9mIGFueSBMU00gaXNzdWVz
LiAgSWYNCj4gd2UncmUgZ29pbmcgdG8gaGF2ZSBhbiBlbmNsYXZlIHdpdGggYSBodWdlIEVMUkFO
R0UgYW5kIHdlJ3JlIGdvaW5nIHRvDQo+IG1hcmsgc29tZSBsYXJnZSBzdWJzZXQgb2YgdGhlIGZ1
bGwgRUxSQU5HRSBhcyBhbGxvY2F0ZS1vbi1kZW1hbmQsIHRoZW4NCj4gd2UgYXJlIGdvaW5nIHRv
IHdhbnQgdG8gdHJhY2sgdGhhdCByYW5nZSBpbiBzb21lIGVmZmljaWVudCB3YXkuICBJdA0KPiBj
b3VsZCBiZSBhIHNpbmdsZSBleHRlbnQgb3IgYSBzZXQgb2YgcG93ZXItb2YtdHdvLXNpemVkIGV4
dGVudHMgKGkuZS4NCj4gcmFkaXggdHJlZSBlbnRyaWVzKSwgb3Igc29tZXRoaW5nIGVsc2UsIGJ1
dCBhIGxpc3Qgb2YgcGFnZXMsIG9mIHdoaWNoDQo+IHNvbWUgYXJlIG1hcmtlZCBub3QteWV0LWFs
bG9jYXRlZCwgaXNuJ3QgZ29pbmcgdG8gY3V0IGl0Lg0KPiANCj4gT25jZSB0aGF0IGhhcHBlbnMs
IGl0IHNlZW1zIG5hdHVyYWwgdG8gcHV0IHdoYXRldmVyIHBlcm1pc3Npb24NCj4gdHJhY2tpbmcg
d2UgbmVlZCBpbnRvIHRoZSBzYW1lIGRhdGEgc3RydWN0dXJlLiAgVGhhdCdzIHdoeSBteSBwcm9w
b3NhbA0KPiBoYWQgdGhlIGRyaXZlciBnZXR0aW5nIGNvYXJzZS1ncmFpbmVkIGluZm8gZnJvbSBM
U00gKCJtYXkgZXhlY3V0ZQ0KPiBkaXJ0eSBwYWdlIiwgZm9yIGV4YW1wbGUpIHJhdGhlciB0aGFu
IGFza2luZyB0aGUgTFNNIHRvIHRyYWNrIHRoZQ0KPiB3aG9sZSBzdGF0ZSBtYWNoaW5lLg0KPiAN
Cj4gRG9lcyB0aGF0IG1ha2Ugc2Vuc2U/DQoNClRoZSBkcml2ZXIgd2lsbCBldmVudHVhbGx5IG5l
ZWQgc29tZSByYW5nZSBvcmllbnRlZCBzdHJ1Y3R1cmVzIGZvciBtYW5hZ2luZyBFQVVHcy4gQnV0
IGl0IGRvZXNuJ3QgbmVjZXNzYXJpbHkgaGF2ZSB0byBiZSBpbiB0aGUgc2FtZSBzdHJ1Y3R1cmUg
YXMgb3RoZXIgcGVyLXBhZ2UgaW5mb3JtYXRpb24uIEFmdGVyIGFsbCwgdGhleSBhcmUgdG91Y2hl
ZCBieSBkaWZmZXJlbnQgY29tcG9uZW50cyBvZiB0aGUgZHJpdmVyIGFuZCBpbmRlZWQgcHJldHR5
IG9ydGhvZ29uYWwuIEV2aWxzIGFyZSBhbHdheXMgaW4gdGhlIGRldGFpbHMuIEl0IG1heSBiZSBj
b3VudGVyLWludHVpdGl2ZSBidXQgcGVyIG91ciBwcm90b3R5cGUgeWVhcnMgYWdvLCBpdCB3b3Vs
ZCBiZSBzaW1wbGVyIHRvIGp1c3Qga2VlcCB0aGVtIHNlcGFyYXRlLiANCg0KSUlVQywgeW91ciBp
ZGVhIGlzIGluIGZhY3Qga2VlcGluZyBhIEZTTSBpbnNpZGUgU0dYIGRyaXZlciBhbmQgdXNpbmcg
cmV0dXJuIHZhbHVlcyBmcm9tIHNlY3VyaXR5X2VuY2xhdmVfbG9hZCgpIHRvIGFyZ3VtZW50IGl0
LiBUaGF0IG1lYW5zIExTTSBoYXMgdG8gd29yayBxdWl0ZSAiY2xvc2VseSIgd2l0aCBTR1ggZHJp
dmVyIChpLmUuIExTTSBuZWVkcyB0byB1bmRlcnN0YW5kIHRoZSBGU00gaW4gU0dYIGRyaXZlciks
IHdoaWNoIGlzIHF1aXRlIGRpZmZlcmVudCB0aGFuIGFsbCBvdGhlciBleGlzdGluZyBob29rcywg
d2hpY2ggYmFzaWNhbGx5IG1ha2UgYmluYXJ5IGRlY2lzaW9ucyBvbmx5LiBBbmQgSSdtIG5vdCBz
dXJlIGhvdyB0byBjaGFpbiBMU01zIGlmIHRoZXJlIGFyZSBtdWx0aXBsZSBhY3RpdmUgYXQgdGhl
IHNhbWUgdGltZS4gQXVkaXRpbmcgaXMgYWxzbyBhIHByb2JsZW0sIGFzIHlvdSBjYW4ndCBnZW5l
cmF0ZSBhdWRpdCBsb2cgYXQgdGhlIHRpbWUgYSByZWFsIG1wcm90ZWN0KCkgcmVxdWVzdCBpcyBh
cHByb3ZlZC9kZW5pZWQuIFVBUEkgaXMgYWxzbyB1bnBsZWFzYW50IGFzIHRoZSBlbmNsYXZlIGxv
YWRlciBoYXMgdG8gInByZWRpY3QiIHRoZSBtYXhpbWFsIHByb3RlY3Rpb24sIHdoaWNoIGlzIG5v
dCBhbHdheXMgYXZhaWxhYmxlIHRvIHRoZSBsb2FkZXIgYXQgbG9hZCB0aW1lLCBvciBzaWduaWZp
Y2FudCBjaGFuZ2VzIHRvIGVuY2xhdmUgYnVpbGQgdG9vbHMgd291bGQgYmUgbmVjZXNzYXJ5LiBJ
IHRoaW5rIHRoZSBGU00gaXMgcmVhbGx5IHBhcnQgb2YgdGhlIHBvbGljeSBhbmQgaW50ZXJuYWwg
dG8gTFNNIChvciBtb3JlIHBhcnRpY3VsYXJseSwgU0VMaW51eCwgYXMgZGlmZmVyZW50IExTTSBt
b2R1bGVzIG1heSBoYXZlIGRpZmZlcmVudCBGU01zKSwgc28gaXQgc3RpbGwgbWFrZXMgbW9yZSBz
ZW5zZSB0byBtZSB0byBrZWVwICJMU00gaW50ZXJuYWxzIiBpbnRlcm5hbCB0byBMU00uIA0K
