Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7338C43218
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 22:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84FDD20859
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 22:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390138AbfFJW2i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 18:28:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:8878 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388328AbfFJW2i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 18:28:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 15:28:36 -0700
X-ExtLoop1: 1
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga005.jf.intel.com with ESMTP; 10 Jun 2019 15:28:36 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 10 Jun 2019 15:28:35 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.28]) with mapi id 14.03.0415.000;
 Mon, 10 Jun 2019 15:28:35 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Paul Moore" <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define enclave
 pages' protection bits
Thread-Topic: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define
 enclave pages' protection bits
Thread-Index: AQHVHA02SpPQp25T6UKJfs0Hq6ptA6aVOU0QgACFp4D//7q0cA==
Date:   Mon, 10 Jun 2019 22:28:34 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F655010EF@ORSMSX116.amr.corp.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-3-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F65500E13@ORSMSX116.amr.corp.intel.com>
 <CALCETrWv9FYDtiHMfnfH==jE00tt7F22t-zcnP+XjfRCQgLr7A@mail.gmail.com>
In-Reply-To: <CALCETrWv9FYDtiHMfnfH==jE00tt7F22t-zcnP+XjfRCQgLr7A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiN2M1NzlmODctMzY3NS00MDEyLTg2OTAtYmUxYTViMjIwM2VjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVkd3WUUxSllibVRVcXMzUDYwcXVQZnNrK01uOHNQdWljU1pvTGo3bzhIeGxZSTFkZVZnTjJEWjVza0Jkdk5jQiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5vcmddDQo+IFNlbnQ6
IE1vbmRheSwgSnVuZSAxMCwgMjAxOSAxMjoxNSBQTQ0KPiANCj4gT24gTW9uLCBKdW4gMTAsIDIw
MTkgYXQgMTE6MjkgQU0gWGluZywgQ2VkcmljIDxjZWRyaWMueGluZ0BpbnRlbC5jb20+DQo+IHdy
b3RlOg0KPiA+DQo+ID4gPiBGcm9tOiBDaHJpc3RvcGhlcnNvbiwgU2VhbiBKDQo+ID4gPiBTZW50
OiBXZWRuZXNkYXksIEp1bmUgMDUsIDIwMTkgNzoxMiBQTQ0KPiA+ID4NCj4gPiA+ICsvKioNCj4g
PiA+ICsgKiBzZ3hfbWFwX2FsbG93ZWQgLSBjaGVjayB2bWEgcHJvdGVjdGlvbnMgYWdhaW5zdCB0
aGUgYXNzb2NpYXRlZA0KPiA+ID4gZW5jbGF2ZSBwYWdlDQo+ID4gPiArICogQGVuY2w6ICAgIGFu
IGVuY2xhdmUNCj4gPiA+ICsgKiBAc3RhcnQ6ICAgc3RhcnQgYWRkcmVzcyBvZiB0aGUgbWFwcGlu
ZyAoaW5jbHVzaXZlKQ0KPiA+ID4gKyAqIEBlbmQ6ICAgICBlbmQgYWRkcmVzcyBvZiB0aGUgbWFw
cGluZyAoZXhjbHVzaXZlKQ0KPiA+ID4gKyAqIEBwcm90OiAgICBwcm90ZWN0aW9uIGJpdHMgb2Yg
dGhlIG1hcHBpbmcNCj4gPiA+ICsgKg0KPiA+ID4gKyAqIFZlcmlmeSBhIHVzZXJzcGFjZSBtYXBw
aW5nIHRvIGFuIGVuY2xhdmUgcGFnZSB3b3VsZCBub3QgdmlvbGF0ZQ0KPiA+ID4gK3RoZSBzZWN1
cml0eQ0KPiA+ID4gKyAqIHJlcXVpcmVtZW50cyBvZiB0aGUgKmtlcm5lbCouICBOb3RlLCB0aGlz
IGlzIGluIG5vIHdheSByZWxhdGVkDQo+ID4gPiArdG8gdGhlDQo+ID4gPiArICogcGFnZSBwcm90
ZWN0aW9ucyBlbmZvcmNlZCBieSBoYXJkd2FyZSB2aWEgdGhlIEVQQ00uICBUaGUgRVBDTQ0KPiA+
ID4gK3Byb3RlY3Rpb25zDQo+ID4gPiArICogY2FuIGJlIGRpcmVjdGx5IGV4dGVuZGVkIGJ5IHRo
ZSBlbmNsYXZlLCBpLmUuIGNhbm5vdCBiZSByZWxpZWQNCj4gPiA+ICt1cG9uIGJ5IHRoZQ0KPiA+
ID4gKyAqIGtlcm5lbCBmb3Igc2VjdXJpdHkgZ3VhcmFudGVlcyBvZiBhbnkga2luZC4NCj4gPiA+
ICsgKg0KPiA+ID4gKyAqIFJldHVybjoNCj4gPiA+ICsgKiAgIDAgb24gc3VjY2VzcywNCj4gPiA+
ICsgKiAgIC1FQUNDRVMgaWYgdGhlIG1hcHBpbmcgaXMgZGlzYWxsb3dlZA0KPiA+ID4gKyAqLw0K
PiA+ID4gK2ludCBzZ3hfbWFwX2FsbG93ZWQoc3RydWN0IHNneF9lbmNsICplbmNsLCB1bnNpZ25l
ZCBsb25nIHN0YXJ0LA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBlbmQs
IHVuc2lnbmVkIGxvbmcgcHJvdCkgew0KPiA+ID4gKyAgICAgc3RydWN0IHNneF9lbmNsX3BhZ2Ug
KnBhZ2U7DQo+ID4gPiArICAgICB1bnNpZ25lZCBsb25nIGFkZHI7DQo+ID4gPiArDQo+ID4gPiAr
ICAgICBwcm90ICY9IChWTV9SRUFEIHwgVk1fV1JJVEUgfCBWTV9FWEVDKTsNCj4gPiA+ICsgICAg
IGlmICghcHJvdCB8fCAhZW5jbCkNCj4gPiA+ICsgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ID4g
PiArDQo+ID4gPiArICAgICBtdXRleF9sb2NrKCZlbmNsLT5sb2NrKTsNCj4gPiA+ICsNCj4gPiA+
ICsgICAgIGZvciAoYWRkciA9IHN0YXJ0OyBhZGRyIDwgZW5kOyBhZGRyICs9IFBBR0VfU0laRSkg
ew0KPiA+ID4gKyAgICAgICAgICAgICBwYWdlID0gcmFkaXhfdHJlZV9sb29rdXAoJmVuY2wtPnBh
Z2VfdHJlZSwgYWRkciA+Pg0KPiA+ID4gUEFHRV9TSElGVCk7DQo+ID4gPiArDQo+ID4gPiArICAg
ICAgICAgICAgIC8qDQo+ID4gPiArICAgICAgICAgICAgICAqIERvIG5vdCBhbGxvdyBSfFd8WCB0
byBhIG5vbi1leGlzdGVudCBwYWdlLCBvcg0KPiBwcm90ZWN0aW9ucw0KPiA+ID4gKyAgICAgICAg
ICAgICAgKiBiZXlvbmQgdGhvc2Ugb2YgdGhlIGV4aXN0aW5nIGVuY2xhdmUgcGFnZS4NCj4gPiA+
ICsgICAgICAgICAgICAgICovDQo+ID4gPiArICAgICAgICAgICAgIGlmICghcGFnZSB8fCAocHJv
dCAmIH5wYWdlLT5wcm90KSkNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVB
Q0NFUzsNCj4gPg0KPiA+IEluIFNHWDIsIHBhZ2VzIHdpbGwgYmUgIm1hcHBlZCIgYmVmb3JlIGJl
aW5nIHBvcHVsYXRlZC4NCj4gPg0KPiA+IEhlcmUncyBhIGJyaWVmIHN1bW1hcnkgZm9yIHRob3Nl
IHdobyBkb24ndCBoYXZlIGVub3VnaCBiYWNrZ3JvdW5kIG9uDQo+IGhvdyBuZXcgRVBDIHBhZ2Vz
IGNvdWxkIGJlIGFkZGVkIHRvIGEgcnVubmluZyBlbmNsYXZlIGluIFNHWDI6DQo+ID4gICAtIFRo
ZXJlIGFyZSAyIG5ldyBpbnN0cnVjdGlvbnMgLSBFQUNDRVBUIGFuZCBFQVVHLg0KPiA+ICAgLSBF
QVVHIGlzIHVzZWQgYnkgU0dYIG1vZHVsZSB0byBhZGQgKGF1Z21lbnQpIGEgbmV3IHBhZ2UgdG8g
YW4NCj4gZXhpc3RpbmcgZW5jbGF2ZS4gVGhlIG5ld2x5IGFkZGVkIHBhZ2UgaXMgKmluYWNjZXNz
aWJsZSogdW50aWwgdGhlDQo+IGVuY2xhdmUgKmFjY2VwdHMqIGl0Lg0KPiA+ICAgLSBFQUNDRVBU
IGlzIHRoZSBpbnN0cnVjdGlvbiBmb3IgYW4gZW5jbGF2ZSB0byBhY2NlcHQgYSBuZXcgcGFnZS4N
Cj4gPg0KPiA+IEFuZCB0aGUgcy93IGZsb3cgZm9yIGFuIGVuY2xhdmUgdG8gcmVxdWVzdCBuZXcg
RVBDIHBhZ2VzIGlzIGV4cGVjdGVkDQo+IHRvIGJlIHNvbWV0aGluZyBsaWtlIHRoZSBmb2xsb3dp
bmc6DQo+ID4gICAtIFRoZSBlbmNsYXZlIGlzc3VlcyBFQUNDRVBUIGF0IHRoZSBsaW5lYXIgYWRk
cmVzcyB0aGF0IGl0IHdvdWxkDQo+IGxpa2UgYSBuZXcgcGFnZS4NCj4gPiAgIC0gRUFDQ0VQVCBy
ZXN1bHRzIGluICNQRiwgYXMgdGhlcmUncyBubyBwYWdlIGF0IHRoZSBsaW5lYXIgYWRkcmVzcw0K
PiBhYm92ZS4NCj4gPiAgIC0gU0dYIG1vZHVsZSBpcyBub3RpZmllZCBhYm91dCB0aGUgI1BGLCBp
biBmb3JtIG9mIGl0cyB2bWEtPnZtX29wcy0NCj4gPmZhdWx0KCkgYmVpbmcgY2FsbGVkIGJ5IGtl
cm5lbC4NCj4gPiAgIC0gU0dYIG1vZHVsZSBFQVVHcyBhIG5ldyBFUEMgcGFnZSBhdCB0aGUgZmF1
bHQgYWRkcmVzcywgYW5kIHJlc3VtZXMNCj4gdGhlIGVuY2xhdmUuDQo+ID4gICAtIEVBQ0NFUFQg
aXMgcmVhdHRlbXB0ZWQsIGFuZCBzdWNjZWVkcyBhdCB0aGlzIHRpbWUuDQo+IA0KPiBUaGlzIHNl
ZW1zIGxpa2UgYW4gb2RkIHdvcmtmbG93LiAgU2hvdWxkbid0IHRoZSAjUEYgcmV0dXJuIGJhY2sg
dG8NCj4gdW50cnVzdGVkIHVzZXJzcGFjZSBzbyB0aGF0IHRoZSB1bnRydXN0ZWQgdXNlciBjb2Rl
IGNhbiBtYWtlIGl0cyBvd24NCj4gZGVjaXNpb24gYXMgdG8gd2hldGhlciBpdCB3YW50cyB0byBF
QVVHIGEgcGFnZSB0aGVyZSBhcyBvcHBvc2VkIHRvLCBzYXksDQo+IGtpbGxpbmcgdGhlIGVuY2xh
dmUgb3Igd2FpdGluZyB0byBrZWVwIHJlc291cmNlIHVzYWdlIHVuZGVyIGNvbnRyb2w/DQoNClRo
aXMgbWF5IHNlZW0gb2RkIHRvIHNvbWUgYXQgdGhlIGZpcnN0IGdsYW5jZS4gQnV0IGlmIHlvdSBj
YW4gdGhpbmsgb2YgaG93IHN0YXRpYyBoZWFwIChwcmUtYWxsb2NhdGVkIGJ5IEVBREQgYmVmb3Jl
IEVJTklUKSB3b3JrcywgdGhlIGxvYWQgcGFyc2VzIHRoZSAibWV0YWRhdGEiIGNvbWluZyB3aXRo
IHRoZSBlbmNsYXZlIHRvIGRlY2lkZSB0aGUgYWRkcmVzcy9zaXplIG9mIHRoZSBoZWFwLCBFQURE
cyBpdCwgYW5kIGNhbGxzIGl0IGRvbmUuIEluIHRoZSBjYXNlIG9mICJkeW5hbWljIiBoZWFwIChh
bGxvY2F0ZWQgZHluYW1pY2FsbHkgYnkgRUFVRyBhZnRlciBFSU5JVCksIHRoZSBzYW1lIHRoaW5n
IGFwcGxpZXMgLSB0aGUgbG9hZGVyIGRldGVybWluZXMgdGhlIHJhbmdlIG9mIHRoZSBoZWFwLCB0
ZWxscyB0aGUgU0dYIG1vZHVsZSBhYm91dCBpdCwgYW5kIGNhbGxzIGl0IGRvbmUuIEV2ZXJ5dGhp
bmcgZWxzZSBpcyB0aGUgYmV0d2VlbiB0aGUgZW5jbGF2ZSBhbmQgdGhlIFNHWCBtb2R1bGUuDQoN
CkluIHByYWN0aWNlLCB1bnRydXN0ZWQgY29kZSB1c3VhbGx5IGRvZXNuJ3Qga25vdyBtdWNoIGFi
b3V0IGVuY2xhdmVzLCBqdXN0IGxpa2UgaXQgZG9lc24ndCBrbm93IG11Y2ggYWJvdXQgdGhlIHNo
YXJlZCBvYmplY3RzIGxvYWRlZCBpbnRvIGl0cyBhZGRyZXNzIHNwYWNlIGVpdGhlci4gV2l0aG91
dCB0aGUgbmVjZXNzYXJ5IGtub3dsZWRnZSwgdW50cnVzdGVkIGNvZGUgdXN1YWxseSBqdXN0IGRv
ZXMgd2hhdCBpdCBpcyB0b2xkICh2aWEgby1jYWxscywgb3IgcmV0dXJuIHZhbHVlIGZyb20gZS1j
YWxscyksIHdpdGhvdXQganVkZ2luZyB0aGF0J3MgcmlnaHQgb3Igd3JvbmcuIA0KDQpXaGVuIGl0
IGNvbWVzIHRvICNQRiBsaWtlIHdoYXQgSSBkZXNjcmliZWQsIG9mIGNvdXJzZSBhIHNpZ25hbCBj
b3VsZCBiZSBzZW50IHRvIHRoZSB1bnRydXN0ZWQgY29kZSBidXQgd2hhdCB3b3VsZCBpdCBkbyB0
aGVuPyBVc3VhbGx5IGl0J2QganVzdCBjb21lIGJhY2sgYXNraW5nIGZvciBhIHBhZ2UgYXQgdGhl
IGZhdWx0IGFkZHJlc3MuIFNvIHdlIGZpZ3VyZWQgaXQnZCBiZSBtb3JlIGVmZmljaWVudCB0byBq
dXN0IGhhdmUgdGhlIGtlcm5lbCBFQVVHIGF0ICNQRi4gDQoNClBsZWFzZSBkb24ndCBnZXQgbWUg
d3JvbmcgdGhvdWdoLCBhcyBJJ20gbm90IGRpY3RhdGluZyB3aGF0IHRoZSBzL3cgZmxvdyBzaGFs
bCBiZS4gSXQncyBqdXN0IGdvaW5nIHRvIGJlIGEgY2hvaWNlIG9mZmVyZWQgdG8gdXNlciBtb2Rl
LiBBbmQgdGhhdCBjaG9pY2Ugd2FzIHBsYW5uZWQgdG8gYmUgb2ZmZXJlZCB2aWEgbXByb3RlY3Qo
KSAtIGkuZS4gYSB3cml0YWJsZSB2bWEgY2F1c2VzIGtlcm5lbCB0byBFQVVHIHdoaWxlIGEgbm9u
LXdyaXRhYmxlIHZtYSB3aWxsIHJlc3VsdCBpbiBhIHNpZ25hbCAodGhlbiB0aGUgdXNlciBtb2Rl
IGNvdWxkIGRlY2lkZSB3aGV0aGVyIHRvIEVBVUcpLiBUaGUga2V5IHBvaW50IGlzIGZsZXhpYmls
aXR5IC0gYXMgd2Ugd2FudCB0byBhbGxvdyBhbGwgcmVhc29uYWJsZSBzL3cgZmxvd3MgaW5zdGVh
ZCBvZiBkaWN0YXRpbmcgb25lIG92ZXIgb3RoZXJzLiBXZSBoYWQgc2ltaWxhciBkaXNjdXNzaW9u
cyBvbiB2RFNPIEFQSSBiZWZvcmUuIEFuZCBJIHRoaW5rIHlvdSBhY2NlcHRlZCBteSBhcHByb2Fj
aCBiZWNhdXNlIG9mIGl0cyBmbGV4aWJpbGl0eS4gQW0gSSByaWdodD8NCg==
