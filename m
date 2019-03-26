Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71364C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 12:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40CF32075E
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 12:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfCZMR6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:17:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:19910 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfCZMR5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 08:17:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 05:17:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="144002255"
Received: from kmsmsx153.gar.corp.intel.com ([172.21.73.88])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Mar 2019 05:17:54 -0700
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.114]) by
 KMSMSX153.gar.corp.intel.com ([169.254.5.176]) with mapi id 14.03.0415.000;
 Tue, 26 Mar 2019 20:17:40 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v19,RESEND 08/27] x86/cpu/intel: Detect SGX support and
 update caps appropriately
Thread-Topic: [PATCH v19,RESEND 08/27] x86/cpu/intel: Detect SGX support and
 update caps appropriately
Thread-Index: AQHU3zky6JmIjy9D9kKUr6BC7GDLPqYdVzoA
Date:   Tue, 26 Mar 2019 12:17:40 +0000
Message-ID: <1553602654.17255.15.camel@intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
         <20190320162119.4469-9-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20190320162119.4469-9-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.24.201]
Content-Type: text/plain; charset="utf-8"
Content-ID: <30A81F9D69E31C419085BBE1A5E2F10F@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gV2VkLCAyMDE5LTAzLTIwIGF0IDE4OjIxICswMjAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
DQo+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRl
bC5jb20+DQo+IA0KPiBTaW1pbGFyIHRvIG90aGVyIGxhcmdlIEludGVsIGZlYXR1cmVzIHN1Y2gg
YXMgVk1YIGFuZCBUWFQsIFNHWCBtdXN0IGJlDQo+IGV4cGxpY2l0bHkgZW5hYmxlZCBpbiBJQTMy
X0ZFQVRVUkVfQ09OVFJPTCBNU1IgdG8gYmUgdHJ1bHkgdXNhYmxlLg0KPiBDbGVhciBhbGwgU0dY
IHJlbGF0ZWQgY2FwYWJpbGl0aWVzIGlmIFNHWCBpcyBub3QgZnVsbHkgZW5hYmxlZCBpbg0KPiBJ
QTMyX0ZFQVRVUkVfQ09OVFJPTCBvciBpZiB0aGUgU0dYMSBpbnN0cnVjdGlvbiBzZXQgaXNuJ3Qg
c3VwcG9ydGVkDQo+IChpbXBvc3NpYmxlIG9uIGJhcmUgbWV0YWwsIHRoZW9yZXRpY2FsbHkgcG9z
c2libGUgaW4gYSBWTSBpZiB0aGUgVk1NIGlzDQo+IGRvaW5nIHNvbWV0aGluZyB3ZWlyZCkuDQo+
IA0KPiBMaWtlIFNHWCBpdHNlbGYsIFNHWCBMYXVuY2ggQ29udHJvbCBtdXN0IGJlIGV4cGxpY2l0
bHkgZW5hYmxlZCB2aWEgYQ0KPiBmbGFnIGluIElBMzJfRkVBVFVSRV9DT05UUk9MLiBDbGVhciB0
aGUgU0dYX0xDIGNhcGFiaWxpdHkgaWYgTGF1bmNoDQo+IENvbnRyb2wgaXMgbm90IGZ1bGx5IGVu
YWJsZWQgKG9yIG9idmlvdXNseSBpZiBTR1ggaXRzZWxmIGlzIGRpc2FibGVkKS4NCj4gDQo+IE5v
dGUgdGhhdCBjbGVhcmluZyBYODZfRkVBVFVSRV9TR1hfTEMgY3JlYXRlcyBhIGJpdCBvZiBhIGNv
bnVuZHJ1bQ0KPiByZWdhcmRpbmcgdGhlIFNHWExFUFVCS0VZSEFTSCBNU1JzLCBhcyBpdCBtYXkg
YmUgZGVzaXJhYmxlIHRvIHJlYWQgdGhlDQo+IE1TUnMgZXZlbiBpZiB0aGV5IGFyZSBub3Qgd3Jp
dGFibGUsIGUuZy4gdG8gcXVlcnkgdGhlIGNvbmZpZ3VyZWQga2V5LA0KPiBidXQgY2xlYXJpbmcg
dGhlIGNhcGFiaWxpdHkgbGVhdmVzIG5vIGJyZWFkY3J1bSBmb3IgZGlzY2VybmluZyB3aGV0aGVy
DQo+IG9yIG5vdCB0aGUgTVNScyBleGlzdC4gIEJ1dCwgc3VjaCB1c2FnZSB3aWxsIGJlIHJhcmUg
KEtWTSBpcyB0aGUgb25seQ0KPiBrbm93biBjYXNlIGF0IHRoaXMgdGltZSkgYW5kIG5vdCBwZXJm
b3JtYW5jZSBjcml0aWNhbCwgc28gaXQncyBub3QNCj4gdW5yZWFzb25hYmxlIHRvIHJlcXVpcmUg
dGhlIHVzZSBvZiByZG1zcl9zYWZlKCkuICBDbGVhcmluZyB0aGUgY2FwIGJpdA0KPiBlbGltaW5h
dGVzIHRoZSBuZWVkIGZvciBhbiBhZGRpdGlvbmFsIGZsYWcgdG8gdHJhY2sgd2hldGhlciBvciBu
b3QNCj4gTGF1bmNoIENvbnRyb2wgaXMgdHJ1bHkgZW5hYmxlZCwgd2hpY2ggaXMgd2hhdCB3ZSBj
YXJlIGFib3V0IHRoZSB2YXN0DQo+IG1ham9yaXR5IG9mIHRoZSB0aW1lLg0KDQpbUmVzZW5kLiBT
b21laG93IG15IGxhc3QgcmVwbHkgZG9lc24ndCBzaG93IHVwIGluIG15IG1haWxib3ggc28gbm90
IHN1cmUgd2hldGhlciBJIHNlbnQgaXQNCnN1Y2Nlc3NmdWxseSBvciBub3QuIFNvcnJ5IGlmIHlv
dSByZWNldmluZyBkdXBsaWNhdGVkIG1haWxzLl0NCg0KSG93ZXZlciB0aGlzIGlzIG5vdCBjb25z
aXN0ZW50IHdpdGggSFcgYmVoYXZpb3IuIElmIExDIGZlYXR1cmUgZmxhZyBpcyBub3QgcHJlc2Vu
dCwgdGhlbiBNU1JzIHNob3VsZA0KaGF2ZSBoYXNoIG9mIEludGVsJ3Mga2V5LCB3aGljaCBpcyBu
b3QgYWx3YXlzIHRoZSBjYXNlIGhlcmUsIHdoZW4geW91IGV4cG9zZSBTR1ggdG8gS1ZNLiBFbmNs
YXZlIGluDQpLVk0gZ3Vlc3Qgd2lsbCBnZXQgdW5leHBlY3RlZCBFSU5JVCBlcnJvciB3aGVuIGxh
dW5pbmcgSW50ZWwgZW5jbGF2ZSwgaWYgb24gSFcgTVNScyBhcmUgY29uZmlndXJlZA0KdG8gM3Jk
IHBhcnR5IHZhbHVlIGJ1dCBsb2NrZWQgdG8gcmVhZG9ubHkuDQoNCk15IG9waXRpb24gaXMgd2Ug
YWxyZWFkeSBoYXZlIGVub3VnaCBjYXNlcyB0aGF0IHZpb2xhdGVzIEhXIGJlaGF2aW9yIGluIFNH
WCB2aXJ0dWFsaXphdGlvbiwgbGV0J3MNCm5vdCBoYXZlIG9uZSBtb3JlLg0KDQpCZXNpZGVzLCB3
aHkgZG8gd2UgIm5lZWQgYW4gYWRkaXRpb25hbCBmbGFnIHRvIHRyYWNrIHdoZXRoZXIgb3Igbm90
IExhdW5jaCBDb250cm9sIGlzIHRydWx5DQplbmFibGVkIj8gRG9lc24ndCBkcml2ZXIgb25seSBu
ZWVkIHRvIGtub3cgd2hldGhlciBNU1JzIGFyZSB3cml0YWJsZT8NCg0KVGhhbmtzLA0KLUthaSAN
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3Rv
cGhlcnNvbkBpbnRlbC5jb20+DQo+IENvLWRldmVsb3BlZC1ieTogSmFya2tvIFNha2tpbmVuIDxq
YXJra28uc2Fra2luZW5AbGludXguaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKYXJra28g
U2Fra2luZW4gPGphcmtrby5zYWtraW5lbkBsaW51eC5pbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJj
aC94ODYva2VybmVsL2NwdS9pbnRlbC5jIHwgMzkgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDM5IGluc2VydGlvbnMoKykNCj4gDQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2ludGVsLmMgYi9hcmNoL3g4Ni9rZXJuZWwv
Y3B1L2ludGVsLmMNCj4gaW5kZXggZmMzYzA3ZmU3ZGY1Li43MDI0OTdmMzRhOTYgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvaW50ZWwuYw0KPiArKysgYi9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L2ludGVsLmMNCj4gQEAgLTU5Niw2ICs1OTYsNDIgQEAgc3RhdGljIHZvaWQgZGV0ZWN0
X3RtZShzdHJ1Y3QgY3B1aW5mb194ODYgKmMpDQo+ICAJYy0+eDg2X3BoeXNfYml0cyAtPSBrZXlp
ZF9iaXRzOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgdm9pZCBfX21heWJlX3VudXNlZCBkZXRlY3Rf
c2d4KHN0cnVjdCBjcHVpbmZvX3g4NiAqYykNCj4gK3sNCj4gKwl1bnNpZ25lZCBsb25nIGxvbmcg
ZmM7DQo+ICsNCj4gKwlyZG1zcmwoTVNSX0lBMzJfRkVBVFVSRV9DT05UUk9MLCBmYyk7DQo+ICsJ
aWYgKCEoZmMgJiBGRUFUVVJFX0NPTlRST0xfTE9DS0VEKSkgew0KPiArCQlwcl9lcnJfb25jZSgi
c2d4OiBUaGUgZmVhdHVyZSBjb250cm9sIE1TUiBpcyBub3QgbG9ja2VkXG4iKTsNCj4gKwkJZ290
byBlcnJfdW5zdXBwb3J0ZWQ7DQo+ICsJfQ0KPiArDQo+ICsJaWYgKCEoZmMgJiBGRUFUVVJFX0NP
TlRST0xfU0dYX0VOQUJMRSkpIHsNCj4gKwkJcHJfZXJyX29uY2UoInNneDogU0dYIGlzIG5vdCBl
bmFibGVkIGluIElBMzJfRkVBVFVSRV9DT05UUk9MIE1TUlxuIik7DQo+ICsJCWdvdG8gZXJyX3Vu
c3VwcG9ydGVkOw0KPiArCX0NCj4gKw0KPiArCWlmICghY3B1X2hhcyhjLCBYODZfRkVBVFVSRV9T
R1gxKSkgew0KPiArCQlwcl9lcnJfb25jZSgic2d4OiBTR1gxIGluc3RydWN0aW9uIHNldCBpcyBu
b3Qgc3VwcG9ydGVkXG4iKTsNCj4gKwkJZ290byBlcnJfdW5zdXBwb3J0ZWQ7DQo+ICsJfQ0KPiAr
DQo+ICsJaWYgKCEoZmMgJiBGRUFUVVJFX0NPTlRST0xfU0dYX0xFX1dSKSkgew0KPiArCQlwcl9p
bmZvX29uY2UoInNneDogVGhlIGxhdW5jaCBjb250cm9sIE1TUnMgYXJlIG5vdCB3cml0YWJsZVxu
Iik7DQo+ICsJCWdvdG8gZXJyX21zcnNfcmRvbmx5Ow0KPiArCX0NCj4gKw0KPiArCXJldHVybjsN
Cj4gKw0KPiArZXJyX3Vuc3VwcG9ydGVkOg0KPiArCXNldHVwX2NsZWFyX2NwdV9jYXAoWDg2X0ZF
QVRVUkVfU0dYKTsNCj4gKwlzZXR1cF9jbGVhcl9jcHVfY2FwKFg4Nl9GRUFUVVJFX1NHWDEpOw0K
PiArCXNldHVwX2NsZWFyX2NwdV9jYXAoWDg2X0ZFQVRVUkVfU0dYMik7DQo+ICsNCj4gK2Vycl9t
c3JzX3Jkb25seToNCj4gKwlzZXR1cF9jbGVhcl9jcHVfY2FwKFg4Nl9GRUFUVVJFX1NHWF9MQyk7
DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyB2b2lkIGluaXRfaW50ZWxfZW5lcmd5X3BlcmYoc3RydWN0
IGNwdWluZm9feDg2ICpjKQ0KPiAgew0KPiAgCXU2NCBlcGI7DQo+IEBAIC03NjMsNiArNzk5LDkg
QEAgc3RhdGljIHZvaWQgaW5pdF9pbnRlbChzdHJ1Y3QgY3B1aW5mb194ODYgKmMpDQo+ICAJaWYg
KGNwdV9oYXMoYywgWDg2X0ZFQVRVUkVfVE1FKSkNCj4gIAkJZGV0ZWN0X3RtZShjKTsNCj4gIA0K
PiArCWlmIChJU19FTkFCTEVEKENPTkZJR19JTlRFTF9TR1gpICYmIGNwdV9oYXMoYywgWDg2X0ZF
QVRVUkVfU0dYKSkNCj4gKwkJZGV0ZWN0X3NneChjKTsNCj4gKw0KPiAgCWluaXRfaW50ZWxfZW5l
cmd5X3BlcmYoYyk7DQo+ICANCj4gIAlpbml0X2ludGVsX21pc2NfZmVhdHVyZXMoYyk7
