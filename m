Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8227EC43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 02:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 500AE218A2
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 02:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfCUCIn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 22:08:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:3774 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbfCUCIm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 22:08:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 19:08:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,251,1549958400"; 
   d="scan'208";a="124464639"
Received: from pgsmsx108.gar.corp.intel.com ([10.221.44.103])
  by orsmga007.jf.intel.com with ESMTP; 20 Mar 2019 19:08:37 -0700
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.114]) by
 PGSMSX108.gar.corp.intel.com ([169.254.8.195]) with mapi id 14.03.0415.000;
 Thu, 21 Mar 2019 10:08:37 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v19 17/27] x86/sgx: Add provisioning
Thread-Topic: [PATCH v19 17/27] x86/sgx: Add provisioning
Thread-Index: AQHU3QbvP5BGVbOPA0+DLUjy9mJ6e6YS3xIAgAH2tgA=
Date:   Thu, 21 Mar 2019 02:08:36 +0000
Message-ID: <1553134108.1952.4.camel@intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
         <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
         <20190319200912.GH25575@linux.intel.com>
In-Reply-To: <20190319200912.GH25575@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.55.184]
Content-Type: text/plain; charset="utf-8"
Content-ID: <26DF35DA0DCF9747B5F104333618914A@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDE5LTAzLTE5IGF0IDEzOjA5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBTdW4sIE1hciAxNywgMjAxOSBhdCAxMToxNDo0NlBNICswMjAwLCBKYXJra28g
U2Fra2luZW4gd3JvdGU6DQo+ID4gSW4gb3JkZXIgdG8gcHJvdmlkZSBhIG1lY2hhbmlzbSBmb3Ig
ZGV2aWxlcmluZyBwcm92aXNvbmluZyByaWdodHM6DQo+ID4gDQo+ID4gMS4gQWRkIGEgbmV3IGZp
bGUgdG8gdGhlIHNlY3VyaXR5ZnMgZmlsZSBjYWxsZWQgc2d4L3Byb3Zpc2lvbiB0aGF0IHdvcmtz
DQo+ID4gICAgYXMgYSB0b2tlbiBmb3IgYWxsb3dpbmcgYW4gZW5jbGF2ZSB0byBoYXZlIHRoZSBw
cm92aXNpb25pbmcgcHJpdmlsZWdlcy4NCj4gPiAyLiBBZGQgYSBuZXcgaW9jdGwgY2FsbGVkIFNH
WF9JT0NfRU5DTEFWRV9TRVRfQVRUUklCVVRFIHRoYXQgYWNjZXB0cyB0aGUNCj4gPiAgICBmb2xs
b3dpbmcgZGF0YSBzdHJ1Y3R1cmU6DQo+ID4gDQo+ID4gICAgc3RydWN0IHNneF9lbmNsYXZlX3Nl
dF9hdHRyaWJ1dGUgew0KPiA+ICAgICAgICAgICAgX191NjQgYWRkcjsNCj4gPiAgICAgICAgICAg
IF9fdTY0IHRva2VuX2ZkOw0KPiA+ICAgIH07DQoNCldvdWxkIHlvdSBlbGFib3JhdGUgd2h5IHRo
ZSBuYW1lIGlzICJ0b2tlbl9mZCI/IEkgdGhpbmsgKnRva2VuKiBpbiBTR1ggaGFzIG1vcmUgc3Bl
Y2lmaWMgbWVhbmluZz8NCg0KPiA+IA0KPiA+IEEgZGFlbW9uIGNvdWxkIHNpdCBvbiB0b3Agb2Yg
c2d4L3Byb3Zpc2lvbiBhbmQgc2VuZCBhIGZpbGUgZGVzY3JpcHRvciBvZg0KPiA+IHRoaXMgZmls
ZSB0byBhIHByb2Nlc3MgdGhhdCBuZWVkcyB0byBiZSBhYmxlIHRvIHByb3Zpc2lvbiBlbmNsYXZl
cy4NCj4gPiANCj4gPiBUaGUgd2F5IHRoaXMgQVBJIGlzIHVzZWQgaXMgbW9yZSBvciBsZXNzIHN0
cmFpZ2h0LWZvcndhcmQuIExldHMgYXNzdW1lIHRoYXQNCj4gPiBkZXZfZmQgaXMgYSBoYW5kbGUg
dG8gL2Rldi9zZ3ggYW5kIHByb3ZfZmQgaXMgYSBoYW5kbGUgdG8gc2d4L3Byb3Zpc2lvbi4NCj4g
PiBZb3Ugd291bGQgYWxsb3cgU0dYX0lPQ19FTkNMQVZFX0NSRUFURSB0byBpbml0aWFsaXplIGFu
IGVuY2xhdmUgd2l0aCB0aGUNCj4gPiBQUk9WSVNJT05LRVkgYXR0cmlidXRlIGJ5DQo+ID4gDQo+
ID4gcGFyYW1zLmFkZHIgPSA8ZW5jbGF2ZSBhZGRyZXNzPjsNCj4gPiBwYXJhbXMudG9rZW5fZmQg
PSBwcm92X2ZkOw0KPiA+IA0KPiA+IGlvY3RsKGRldl9mZCwgU0dYX0lPQ19FTkNMQVZFX1NFVF9B
VFRSSUJVVEUsICZwYXJhbXMpOw0KPiA+IA0KPiA+IENjOiBKYW1lcyBNb3JyaXMgPGptb3JyaXNA
bmFtZWkub3JnPg0KPiA+IENjOiBTZXJnZSBFLiBIYWxseW4gPHNlcmdlQGhhbGx5bi5jb20+DQo+
ID4gQ2M6IGxpbnV4LXNlY3VyaXR5LW1vZHVsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBTdWdnZXN0
ZWQtYnk6IEFuZHkgTHV0b21pcnNraSA8bHV0b0BrZXJuZWwub3JnPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEphcmtrbyBTYWtraW5lbiA8amFya2tvLnNha2tpbmVuQGxpbnV4LmludGVsLmNvbT4NCj4g
PiAtLS0NCj4gPiAgYXJjaC94ODYvaW5jbHVkZS91YXBpL2FzbS9zZ3guaCAgICAgICAgfCAxMyAr
KysrKysrDQo+ID4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci9pb2N0bC5jIHwgNDMg
KysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZHJp
dmVyL21haW4uYyAgfCA0NyArKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAzIGZpbGVz
IGNoYW5nZWQsIDEwMyBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2luY2x1ZGUvdWFwaS9hc20vc2d4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL3VhcGkvYXNtL3Nn
eC5oDQo+ID4gaW5kZXggYWFkZjljNzZlMzYwLi4xNTBhNzg0ZGIzOTUgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS91YXBpL2FzbS9zZ3guaA0KPiA+ICsrKyBiL2FyY2gveDg2L2lu
Y2x1ZGUvdWFwaS9hc20vc2d4LmgNCj4gPiBAQCAtMTYsNiArMTYsOCBAQA0KPiA+ICAJX0lPVyhT
R1hfTUFHSUMsIDB4MDEsIHN0cnVjdCBzZ3hfZW5jbGF2ZV9hZGRfcGFnZSkNCj4gPiAgI2RlZmlu
ZSBTR1hfSU9DX0VOQ0xBVkVfSU5JVCBcDQo+ID4gIAlfSU9XKFNHWF9NQUdJQywgMHgwMiwgc3Ry
dWN0IHNneF9lbmNsYXZlX2luaXQpDQo+ID4gKyNkZWZpbmUgU0dYX0lPQ19FTkNMQVZFX1NFVF9B
VFRSSUJVVEUgXA0KPiA+ICsJX0lPVyhTR1hfTUFHSUMsIDB4MDMsIHN0cnVjdCBzZ3hfZW5jbGF2
ZV9zZXRfYXR0cmlidXRlKQ0KPiA+ICANCj4gPiAgLyogSU9DVEwgcmV0dXJuIHZhbHVlcyAqLw0K
PiA+ICAjZGVmaW5lIFNHWF9QT1dFUl9MT1NUX0VOQ0xBVkUJCTB4NDAwMDAwMDANCj4gPiBAQCAt
NTYsNCArNTgsMTUgQEAgc3RydWN0IHNneF9lbmNsYXZlX2luaXQgew0KPiA+ICAJX191NjQJc2ln
c3RydWN0Ow0KPiA+ICB9Ow0KPiA+ICANCj4gPiArLyoqDQo+ID4gKyAqIHN0cnVjdCBzZ3hfZW5j
bGF2ZV9zZXRfYXR0cmlidXRlIC0gcGFyYW1ldGVyIHN0cnVjdHVyZSBmb3IgdGhlDQo+ID4gKyAq
CQkJCSAgICAgICVTR1hfSU9DX0VOQ0xBVkVfSU5JVCBpb2N0bA0KPiA+ICsgKiBAYWRkcjoJCWFk
ZHJlc3Mgd2l0aGluIHRoZSBFTFJBTkdFDQo+ID4gKyAqIEBhdHRyaWJ1dGVfZmQ6CWZpbGUgaGFu
ZGxlIG9mIHRoZSBhdHRyaWJ1dGUgZmlsZSBpbiB0aGUgc2VjdXJpdHlmcw0KPiA+ICsgKi8NCj4g
PiArc3RydWN0IHNneF9lbmNsYXZlX3NldF9hdHRyaWJ1dGUgew0KPiA+ICsJX191NjQJYWRkcjsN
Cj4gPiArCV9fdTY0CWF0dHJpYnV0ZV9mZDsNCj4gPiArfTsNCj4gPiArDQo+ID4gICNlbmRpZiAv
KiBfVUFQSV9BU01fWDg2X1NHWF9IICovDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5l
bC9jcHUvc2d4L2RyaXZlci9pb2N0bC5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZHJpdmVy
L2lvY3RsLmMNCj4gPiBpbmRleCA0YjlhOTFiNTNiNTAuLjVkODViZDNmNzg3NiAxMDA2NDQNCj4g
PiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9kcml2ZXIvaW9jdGwuYw0KPiA+ICsrKyBi
L2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci9pb2N0bC5jDQo+ID4gQEAgLTc1OSw2ICs3
NTksNDYgQEAgc3RhdGljIGxvbmcgc2d4X2lvY19lbmNsYXZlX2luaXQoc3RydWN0IGZpbGUgKmZp
bGVwLCB1bnNpZ25lZCBpbnQgY21kLA0KPiA+ICAJcmV0dXJuIHJldDsNCj4gPiAgfQ0KPiA+ICAN
Cj4gPiArLyoqDQo+ID4gKyAqIHNneF9pb2NfZW5jbGF2ZV9zZXRfYXR0cmlidXRlIC0gaGFuZGxl
ciBmb3IgJVNHWF9JT0NfRU5DTEFWRV9TRVRfQVRUUklCVVRFDQo+ID4gKyAqIEBmaWxlcDoJb3Bl
biBmaWxlIHRvIC9kZXYvc2d4DQo+ID4gKyAqIEBjbWQ6CXRoZSBjb21tYW5kIHZhbHVlDQo+ID4g
KyAqIEBhcmc6CXBvaW50ZXIgdG8gYSBzdHJ1Y3Qgc2d4X2VuY2xhdmVfc2V0X2F0dHJpYnV0ZSBp
bnN0YW5jZQ0KPiA+ICsgKg0KPiA+ICsgKiBTZXRzIGFuIGF0dHJpYnV0ZSBtYXRjaGluZyB0aGUg
YXR0cmlidXRlIGZpbGUgdGhhdCBpcyBwb2ludGVkIGJ5IHRoZQ0KPiA+ICsgKiBwYXJhbWV0ZXIg
c3RydWN0dXJlIGZpZWxkIGF0dHJpYnV0ZV9mZC4NCj4gDQo+IFdpdGggdGhlIEBkYXRhIGNoYW5n
ZSAoc2VlIGJlbG93KSwgdGhpcyBiZWNvbWVzIHNvbWV0aGluZyBsaWtlOg0KPiANCj4gICogQWxs
b3cgdGhlIGVuY2xhdmUgdG8gcmVxdWVzdCB0aGUgYXR0cmlidXRlIG1hbmFnZWQgYnkgdGhlIFNH
WCBzZWN1cml0eSBmaWxlDQo+ICAqIHBvaW50ZWQgYXQgYnkgdGhlIHBhcmFtZXRlciBzdHJ1Y3R1
cmUgZmllbGQgYXR0cmlidXRlX2ZkLg0KPiANCj4gPiArICoNCj4gPiArICogUmV0dXJuOiAwIG9u
IHN1Y2Nlc3MsIC1lcnJubyBvdGhlcndpc2UNCj4gPiArICovDQo+ID4gK3N0YXRpYyBsb25nIHNn
eF9pb2NfZW5jbGF2ZV9zZXRfYXR0cmlidXRlKHN0cnVjdCBmaWxlICpmaWxlcCwgdW5zaWduZWQg
aW50IGNtZCwNCj4gPiArCQkJCQkgIHVuc2lnbmVkIGxvbmcgYXJnKQ0KPiA+ICt7DQo+ID4gKwlz
dHJ1Y3Qgc2d4X2VuY2xhdmVfc2V0X2F0dHJpYnV0ZSAqcGFyYW1zID0gKHZvaWQgKilhcmc7DQo+
ID4gKwlzdHJ1Y3QgZmlsZSAqYXR0cmlidXRlX2ZpbGU7DQo+ID4gKwlzdHJ1Y3Qgc2d4X2VuY2wg
KmVuY2w7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCWF0dHJpYnV0ZV9maWxlID0gZmdl
dChwYXJhbXMtPmF0dHJpYnV0ZV9mZCk7DQo+ID4gKwlpZiAoIWF0dHJpYnV0ZV9maWxlLT5mX29w
KQ0KPiANCj4gVGhpcyBzaG91bGQgYmU6DQo+IA0KPiAJaWYgKCFhdHRyaWJ1dGVfZmlsZSkNCj4g
CQlyZXR1cm4gLUVJTlZBTDsNCj4gDQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKw0KPiA+
ICsJaWYgKGF0dHJpYnV0ZV9maWxlLT5mX29wICE9ICZzZ3hfZnNfcHJvdmlzaW9uX2ZvcHMpIHsN
Cj4gPiArCQlyZXQgPSAtRUlOVkFMOw0KPiA+ICsJCWdvdG8gb3V0Ow0KPiA+ICsJfQ0KPiA+ICsN
Cj4gPiArCXJldCA9IHNneF9lbmNsX2dldChwYXJhbXMtPmFkZHIsICZlbmNsKTsNCj4gPiArCWlm
IChyZXQpDQo+ID4gKwkJZ290byBvdXQ7DQo+ID4gKw0KPiA+ICsJZW5jbC0+YWxsb3dlZF9hdHRy
aWJ1dGVzIHw9IFNHWF9BVFRSX1BST1ZJU0lPTktFWTsNCj4gDQo+IEEgY2xlYW5yIGFwcHJvYWNo
IHdvdWxkIGJlIHRvIHBhc3MgU0dYX0FUVFJfUFJPVklTSU9OS0VZIHZpYSBAZGF0YSB0bw0KPiBz
ZWN1cml0eWZzX2NyZWF0ZV9maWxlKCkuICBUaGVuIHlvdSBkb24ndCBuZWVkIHRvIGRlZmluZSBk
dW1teSBmaWxlX29wcw0KPiBmb3IgZWFjaCBmaWxlLCBpLmUuIGEgZ2VuZXJpYyBzZ3hfc2VjX2Zz
X29wcyB3b3VsZCBzdWZmaWNlIGZvciB0aGUgYWJvdmUNCj4gY2hlY2suICBBbmQgeW91IGRvbid0
IGhhdmUgdGhpcyB3ZWlyZCBoYXJkY29kaW5nIG9mIHRoZSBwcm92aXNpb24gYml0Lg0KPiANCj4g
RS5nLjoNCj4gDQo+IAlpZiAoYXR0cmlidXRlX2ZpbGUtPmZfb3AgIT0gJnNneF9zZWNfZnNfZm9w
cykgew0KPiAJCXJldCA9IC1FSU5WQUw7DQo+IAkJZ290byBvdXQ7DQo+IAl9DQo+IA0KPiAJcmV0
ID0gc2d4X2VuY2xfZ2V0KHBhcmFtcy0+YWRkciwgJmVuY2wpOw0KPiAJaWYgKHJldCkNCj4gCQln
b3RvIG91dDsNCj4gDQo+IAllbmNsLT5hbGxvd2VkX2F0dHJpYnV0ZXMgfD0gKHU2NClhdHRyaWJ1
dGVfZmlsZS0+cHJpdmF0ZV9kYXRhOw0KPiANCj4gU2luY2UgU0dYIGRvZXNuJ3Qgc3VwcG9ydCAz
Mi1iaXQgYnVpbGRzIHdlIGRvbid0IGV2ZW4gbmVlZCB0byB3b3JyeSBhYm91dA0KPiB0aGUgKHZl
cnkgZGlzdGFudCkgZnV0dXJlIHdoZXJlIFNHWCBkZWZpbmVzIGJpdHMgaW4gdGhlIDYzOjMyIHJh
bmdlLg0KPiANCg0KQWdyZWUgd2l0aCBTZWFuIHRoYXQgcGFzc2luZyBTR1hfQVRUUl9QUk9WSVNJ
T05LRVkgdmlhIEBkYXRhIGlzIG1vcmUgY2xlYW5lci4NCg0KVGhhbmtzLA0KLUthaQ==
