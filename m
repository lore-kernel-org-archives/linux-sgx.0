Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB347C48BD7
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 19:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A72E720665
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 19:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfF0Til (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 15:38:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:7441 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfF0Til (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jun 2019 15:38:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 12:38:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,424,1557212400"; 
   d="scan'208";a="164837651"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga003.jf.intel.com with ESMTP; 27 Jun 2019 12:38:40 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX109.amr.corp.intel.com ([169.254.11.153]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 12:38:39 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [RFC PATCH v4 09/12] LSM: x86/sgx: Introduce ->enclave_load()
 hook for Intel SGX
Thread-Topic: [RFC PATCH v4 09/12] LSM: x86/sgx: Introduce ->enclave_load()
 hook for Intel SGX
Thread-Index: AQHVJu2/Ps4u3cZ3TEKYDYciObKMyqamVmOwgAcDXACAAA1YAIAChs7g
Date:   Thu, 27 Jun 2019 19:38:39 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551B756@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-10-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F655184A2@ORSMSX116.amr.corp.intel.com>
 <008635cd-9c0b-1367-d250-99aa16b41305@tycho.nsa.gov>
 <a494b094-cde7-b53d-3903-81ccc907b392@tycho.nsa.gov>
In-Reply-To: <a494b094-cde7-b53d-3903-81ccc907b392@tycho.nsa.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTgxYWI0YzktODc3YS00OWIyLWE4YzItNGNhMTIzMmFkMmQyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiY042bWN2amdiaUg2RkY1WU50UDdHam9cLzdXV0huY3dubTVTYmJNcDVXWndhcWZxbDdienJEXC9MbXp6cUM4SEYxIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBGcm9tOiBsaW51eC1zZ3gtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtc2d4
LQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBTdGVwaGVuIFNtYWxsZXkN
Cj4gU2VudDogVHVlc2RheSwgSnVuZSAyNSwgMjAxOSAyOjQ5IFBNDQo+IA0KPiBPbiA2LzI1LzE5
IDU6MDEgUE0sIFN0ZXBoZW4gU21hbGxleSB3cm90ZToNCj4gPiBPbiA2LzIxLzE5IDE6MDUgUE0s
IFhpbmcsIENlZHJpYyB3cm90ZToNCj4gPj4+IEZyb206IENocmlzdG9waGVyc29uLCBTZWFuIEoN
Cj4gPj4+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSAxOSwgMjAxOSAzOjI0IFBNDQo+ID4+Pg0KPiA+
Pj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc2VjdXJpdHkuaCBiL2luY2x1ZGUvbGludXgv
c2VjdXJpdHkuaA0KPiA+Pj4gaW5kZXggNmExZjU0YmE2Nzk0Li41NzJkZGZjNTMwMzkgMTAwNjQ0
DQo+ID4+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L3NlY3VyaXR5LmgNCj4gPj4+ICsrKyBiL2luY2x1
ZGUvbGludXgvc2VjdXJpdHkuaA0KPiA+Pj4gQEAgLTE4MzIsMTEgKzE4MzIsMTggQEAgc3RhdGlj
IGlubGluZSB2b2lkDQo+ID4+PiBzZWN1cml0eV9icGZfcHJvZ19mcmVlKHN0cnVjdCBicGZfcHJv
Z19hdXggKmF1eCkNCj4gPj4+IMKgICNpZmRlZiBDT05GSUdfSU5URUxfU0dYDQo+ID4+PiDCoCAj
aWZkZWYgQ09ORklHX1NFQ1VSSVRZDQo+ID4+PiDCoCBpbnQgc2VjdXJpdHlfZW5jbGF2ZV9tYXAo
dW5zaWduZWQgbG9uZyBwcm90KTsNCj4gPj4+ICtpbnQgc2VjdXJpdHlfZW5jbGF2ZV9sb2FkKHN0
cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLCB1bnNpZ25lZCBsb25nDQo+ID4+PiBwcm90LA0KPiA+
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgbWVhc3VyZWQpOw0KPiA+Pj4gwqAg
I2Vsc2UNCj4gPj4+IMKgIHN0YXRpYyBpbmxpbmUgaW50IHNlY3VyaXR5X2VuY2xhdmVfbWFwKHVu
c2lnbmVkIGxvbmcgcHJvdCkNCj4gPj4+IMKgIHsNCj4gPj4+IMKgwqDCoMKgwqAgcmV0dXJuIDA7
DQo+ID4+PiDCoCB9DQo+ID4+PiArc3RhdGljIGlubGluZSBpbnQgc2VjdXJpdHlfZW5jbGF2ZV9s
b2FkKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLA0KPiA+Pj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgcHJvdCwgYm9vbCBtZWFzdXJlZCkg
ew0KPiA+Pj4gK8KgwqDCoCByZXR1cm4gMDsNCj4gPj4+ICt9DQo+ID4+PiDCoCAjZW5kaWYgLyog
Q09ORklHX1NFQ1VSSVRZICovDQo+ID4+PiDCoCAjZW5kaWYgLyogQ09ORklHX0lOVEVMX1NHWCAq
Lw0KPiA+Pg0KPiA+PiBQYXJhbWV0ZXJzIHRvIHNlY3VyaXR5X2VuY2xhdmVfbG9hZCgpIGFyZSBz
cGVjaWZpYyBvbiB3aGF0J3MgYmVpbmcNCj4gPj4gbG9hZGluZyBvbmx5LCBidXQgdW5zcGVjaWZp
YyBvbiB3aGljaCBlbmNsYXZlIHRvIGJlIGxvYWRlZCBpbnRvLiBUaGF0DQo+ID4+IGtpbGxzIHRo
ZSBwb3NzaWJpbGl0eSBvZiBhbiBMU00gbW9kdWxlIG1ha2luZyBlbmNsYXZlIGRlcGVuZGVudA0K
PiA+PiBkZWNpc2lvbnMuDQo+ID4+DQo+ID4+IEJ0dywgaWYgZW5jbGF2ZSAoaW4gdGhlIGZvcm0g
b2Ygc3RydWN0IGZpbGUpIGlzIGFsc28gcGFzc2VkIGluIGFzIGENCj4gPj4gcGFyYW1ldGVyLCBp
dCdkIGxldCBMU00ga25vdyB0aGF0IGZpbGUgaXMgYW4gZW5jbGF2ZSwgaGVuY2Ugd291bGQgYmUN
Cj4gPj4gYWJsZSB0byBtYWtlIHRoZSBzYW1lIGRlY2lzaW9uIGluIHNlY3VyaXR5X21tYXBfZmls
ZSgpIGFzIGluDQo+ID4+IHNlY3VyaXR5X2VuY2xhdmVfbWFwKCkuIEluIG90aGVyIHdvcmRzLCB5
b3Ugd291bGRuJ3QgbmVlZA0KPiA+PiBzZWN1cml0eV9lbmNsYXZlX21hcCgpLg0KPiA+DQo+ID4g
U29ycnksIHlvdSB3YW50IHNlY3VyaXR5X2VuY2xhdmVfbG9hZCgpIHRvIHN0YXNoIGEgcmVmZXJl
bmNlIHRvIHRoZQ0KPiA+IGVuY2xhdmUgZmlsZSBpbiBzb21lIHNlY3VyaXR5IG1vZHVsZS1pbnRl
cm5hbCBzdGF0ZSwgdGhlbiBtYXRjaCBpdA0KPiA+IHVwb24gbGF0ZXIgc2VjdXJpdHlfbW1hcF9m
aWxlKCkgY2FsbHMgdG8gZGV0ZXJtaW5lIHRoYXQgaXQgaXMgZGVhbGluZw0KPiA+IHdpdGggYW4g
ZW5jbGF2ZSwgYW5kIHRoZW4gYWRqdXN0IGl0cyBsb2dpYyBhY2NvcmRpbmdseT/CoCBXaGVuIGRv
IHdlDQo+ID4gcmVsZWFzZSB0aGF0IHJlZmVyZW5jZT8NCj4gDQo+IEkgZ3Vlc3MgeW91IG1lYW4g
c2V0IGEgZmxhZyBpbiB0aGUgZW5jbGF2ZSBmaWxlIHNlY3VyaXR5IHN0cnVjdCB1cG9uDQo+IHNl
Y3VyaXR5X2VuY2xhdmVfbG9hZCgpIGFuZCBjaGVjayB0aGF0IGZsYWcgaW4gc2VjdXJpdHlfbW1h
cF9maWxlKCkuDQoNClllcywgYnkgaW52b2tpbmcgc2VjdXJpdHlfZW5jbGF2ZV9sb2FkKCksIHRo
ZSBTR1ggc3Vic3lzdGVtIGluZGljYXRlcyB0byBMU00gdGhlIGZpbGUgc3RydWN0IGluIHN1Ympl
Y3QgcmVmZXJzIHRvIGFuIGVuY2xhdmUuIEJ1dCBzZWN1cml0eV9tbWFwX2ZpbGUoKSBkb2Vzbid0
IHBhc3MgaW4gdGhlIHJhbmdlIGJlaW5nIG1tYXAoKSdlZCBzbyBMU00gc3RpbGwgY2Fubm90IGRl
Y2lkZS4gSW5zdGVhZCBvZiBjaGFuZ2luZyB0aGUgZGVmaW5pdGlvbiBvZiBzZWN1cml0eV9tbWFw
X2ZpbGUoKSwgSSdkIGludm9rZSBzZWN1cml0eV9maWxlX21wcm90ZWN0KCkgZnJvbSBzZ3hfbW1h
cCgpLiBBZnRlciBhbGwsIGNyZWF0aW5nIGEgbmV3IG1hcHBpbmcgaXMgZXF1aXZhbGVudCB0byBj
aGFuZ2luZyB0aGUgdGFyZ2V0IHJhbmdlIGZyb20gUFJPVF9OT05FIHRvIEBwcm90IGJlaW5nIHJl
cXVlc3RlZC4gSSBqdXN0IHNlbnQgb3V0IGEgcGF0Y2ggc2VyaWVzIHdpdGggYWxsIHRob3NlIGRl
dGFpbHMgaW4gY29kZS4NCg0KPiANCj4gVGhpcyBzZWVtcyBzb21ld2hhdCBzaW1pbGFyIHRvIG9u
ZSBvZiBTZWFuJ3MgYWx0ZXJuYXRpdmVzIGluIHRoZSBwYXRjaA0KPiBkZXNjcmlwdGlvbiBmb3Ig
MDYvMTIsIGV4Y2VwdCBieSBwdXNoaW5nIHRoZSBpbmZvcm1hdGlvbiBmcm9tIHNneCB0byBMU00N
Cj4gdXBvbiBzZWN1cml0eV9lbmNsYXZlX2xvYWQoKSByYXRoZXIgdGhhbiBwdWxsaW5nIGl0IHZp
YSBhDQo+IGlzX3NneF9lbmNsYXZlKCkgaGVscGVyLiAgTm90IGNsZWFyIGlmIGl0IGlzIHN0aWxs
IHN1YmplY3QgdG8gdGhlIHNhbWUNCj4gbGltaXRhdGlvbnMuDQoNClllcywgdGhleSBhcmUgc2lt
aWxhciBleGNlcHQgd2hvIGtlZXBzIHRyYWNrIG9mIHRoYXQgcGllY2Ugb2YgaW5mb3JtYXRpb24u
IEFzIERyLiBHcmVnIHBvaW50ZWQgb3V0LCB0aGUgbmV3IGhvb2tzIGRvIGhhdmUgdG8gYmUgU0dY
IHNwZWNpZmljLiBCdXQgY2FsbGluZyBpc19zZ3hfZW5jbGF2ZSgpIHJlYWxseSB0aWVzIExTTSB0
byBTR1guIEluIGNvbnRyYXN0LCBpbmZlcnJpbmcgaXQgdGhyb3VnaCBzZWN1cml0eV9lbmNsYXZl
X2xvYWQoKSBtYWtlcyBMU00gU0dYLWFnbm9zdGljLiBUaGVuIHRoZSBvbmx5IFNHWCBzcGVjaWZp
YyB0aGluZyBsZWZ0IGluIHRoZSBob29rcyBpcyB0aGUgc2d4X3NpZ3N0cnVjdC4gSW4gdGhlb3J5
LCB0aGF0J3MganVzdCBhIGRpZ2l0YWwgc2lnbmF0dXJlIGFuZCBhcyBEci4gR3JlZyBwb2ludGVk
IG91dCwgU0dYIGlzIHByb2JhYmx5IG5vdCB0aGUgb25seSB0ZWNobm9sb2d5IHRoYXQgdXNlcyBk
aWdpdGFsIHNpZ25hdHVyZSB0byBpZGVudGlmeSBleGVjdXRhYmxlIGNvbnRlbnRzLiBBbmQgaW4g
dGhhdCBzZW5zZSwgaWYgd2UgcmVuYW1lIGl0IHRvIHNvbWV0aGluZyBnZW5lcmljIHdpdGggcHJv
YmFibHkgYSB0YWcgaW5kaWNhdGluZyBpdHMgZm9ybWF0LCB0aGVuIHRoZSB3aG9sZSB0aGluZyB3
b3VsZCBiZWNvbWUgU0dYIGFnbm9zdGljIGFuZCBjb3VsZCBiZSB1c2VmdWwgZm9yIG90aGVyIFRF
RXMgb24gYXJjaGl0ZWN0dXJlcyBvdGhlciB0aGFuIHg4Ni4NCg==
