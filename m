Return-Path: <SRS0=8iz8=RZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EA4C43381
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 20:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A169F21900
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 20:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbfCVUbU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Mar 2019 16:31:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:55851 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbfCVUbU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Mar 2019 16:31:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 13:31:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="331141865"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga005.fm.intel.com with ESMTP; 22 Mar 2019 13:31:19 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX103.amr.corp.intel.com ([169.254.5.129]) with mapi id 14.03.0415.000;
 Fri, 22 Mar 2019 13:31:18 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Topic: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fwgAB7nID//4szkIAB7KQAgAEyn5A=
Date:   Fri, 22 Mar 2019 20:31:17 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E85DA80@ORSMSX116.amr.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <CALCETrVKAUK-jZ7Knp7RetTL055p3iK1D8Wyr6=hPq5HkePkFg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C53D@ORSMSX116.amr.corp.intel.com>
 <CALCETrUmWJRg120Evk4ctAUXOiA5HcfrW2uGWq_Z0OT5K70zGw@mail.gmail.com>
In-Reply-To: <CALCETrUmWJRg120Evk4ctAUXOiA5HcfrW2uGWq_Z0OT5K70zGw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTY3MDdhMjQtNmM3Ni00MmQ0LTlkMjUtMjRkZmVlZTFlNjAwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSzJSOHVPTThZRXBQaWNOdW9FTW1yb09KK1hIVHEyQ09JUjdkb2VOMERncVhackFlT2pLQzdydkdXUzRJRzVSRyJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGkgQW5keSwNCg0KPiA+ID4gIC0gSXQgd2lsbCBtYWtlIGl0IHF1aXRlIHVucGxlYXNhbnQgdG8g
Y2FsbCBpbnRvIGFuIGVuY2xhdmUgaW4gYQ0KPiA+ID4gY29yb3V0aW5lIGRlcGVuZGluZyBvbiBo
b3cgdGhlIGhvc3QgdW50cnVzdGVkIHJ1bnRpbWUgaW1wbGVtZW50cw0KPiA+ID4gY29yb3V0aW5l
cy4NCj4gPg0KPiA+IEknbSBub3Qgc3VyZSB3aGF0IHlvdSBhcmUgcmVmZXJyaW5nIHRvIGJ5ICJj
b3JvdXRpbmUiLiBCdXQgdGhpcyB2RFNPDQo+IEFQSSB3aWxsIGJlIChleHBlY3RlZCB0byBiZSkg
dGhlIG9ubHkgcm91dGluZSB0aGF0IGFjdHVhbGx5IGNhbGxzIGludG8NCj4gYW4gZW5jbGF2ZS4g
SXNuJ3QgdGhhdCBjb3JyZWN0Pw0KPiANCj4gSSBtZWFuIHVzZSBpbiBsYW5ndWFnZXMgYW5kIHJ1
bnRpbWVzIHRoYXQgYWxsb3cgYSBmdW5jdGlvbiBhbmQgaXRzDQo+IGNhbGxlZXMgdG8gcGF1c2Ug
YW5kIHRoZW4gcmVzdW1lIGxhdGVyLiAgU29tZXRoaW5nIGxpa2UgKHBzZXVkb2NvZGUsDQo+IG9i
dmlvdXNseSk6DQo+IA0KPiB2b2lkIGludm9rZV90aGVfZW5jbGF2ZSgpDQo+IHsNCj4gICBkb19l
ZW50ZXJfdGhyb3VnaF92ZHNvKCk7DQo+IH0NCj4gDQo+IHZvaWQgc29tZV9vY2FsbF9oYW5kbGVy
KHZvaWQgKnB0cikNCj4gew0KPiAgIHlpZWxkOw0KPiB9DQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2gg
Zm9yIHlvdXIgZGV0YWlsZWQgZXhwbGFuYXRpb24uIFRoaXMgbG9va3MgbW9yZSBhYm91dCB3aGV0
aGVyIG9yIG5vdCB0aGUgdW50cnVzdGVkIHN0YWNrIHdpbGwgcmVtYWluIHZhbGlkIGFmdGVyIEVF
WElULCB0aGFuIHdoZXRoZXIgdGhlIG9jYWxsIHdpbGwgYmUgcGF1c2VkIG9yIG5vdC4gQXMgaW4g
eW91ciBleGFtcGxlIGNvZGUgYWJvdmUsIGEgcHJvYmxlbSBtYXkgb2NjdXIgaWYgInlpZWxkIiBk
ZXN0cm95cyB0aGUgc3RhY2sgb2YgaXRzIGNhbGxlci4gQnV0IGlzIHRoYXQgYSBjb21tb24gYmVo
YXZpb3Igb2YgInlpZWxkIiAob3IgYW55IHNjaGVkdWxlciBhdCBhbGwpPyANCg0KWW91ciBwb2lu
dCBpcyB3ZWxsIHJlY2VpdmVkIHRob3VnaCAtIE5vdCBldmVyeSBlbmNsYXZlIGNhbi9zaGFsbCBh
c3N1bWUgZXhpc3RlbmNlIG9yIHNpemUgb2YgYW4gdW50cnVzdGVkIHN0YWNrLiBUaGVyZWZvcmUg
SSd2ZSBtYWRlIHN1cmUgbXkgcHJvcG9zYWwgd2lsbCB3b3JrIG5vIG1hdHRlciB0aGUgZW5jbGF2
ZSB0b3VjaGVzIHRoZSB1bnRydXN0ZWQgc3RhY2sgb3Igbm90Lg0KDQo+IA0KPiBJZiB0aGUgZW5j
bGF2ZSBoYXMgcHRyIHBvaW50aW5nIHRvIHRoZSB1bnRydXN0ZWQgc3RhY2ssIHRoZW4gdGhpcyBn
ZXRzDQo+IHF1aXRlIGF3a3dhcmQgZm9yIHRoZSBydW50aW1lIHRvIGhhbmRsZSBlZmZpY2llbnRs
eS4gIElNTyBhIG11Y2ggbmljZXINCj4gYXBwcm9hY2ggd291bGQgYmU6DQo+IA0KPiB2b2lkIGlu
dm9rZV90aGVfZW5jbGF2ZSgpDQo+IHsNCj4gICBjaGFyIGJ1ZmZlclsxMDI0XTsNCj4gICB3aGls
ZSAodHJ1ZSkNCj4gICB7DQo+ICAgICBlZW50ZXIgKHRocm91Z2ggdmRzbyk7DQo+ICAgICBpZiAo
ZXhpdCB3YXMgYW4gb2NhbGwgcmVxdWVzdCkgew0KPiAgICAgICBzb21lX29jYWxsX2hhbmRsZXIo
YnVmZmVyKTsNCj4gICAgIH0NCj4gICB9DQo+IH0NCj4gDQo+IEFuZCBub3cgdGhlcmUgaXMgbm90
aGluZyBmdW5ueSBoYXBwZW5pbmcgYmVoaW5kIHRoZSBydW50aW1lJ3MgYmFjayB3aGVuDQo+IHNv
bWVfb2NhbGxfaGFuZGxlciB0cmllcyB0byB5aWVsZC4NCg0KQWdyZWVkLiANCg0KSW4gZmFjdCwg
TXIuIENocmlzdG9waGVyc29uJ3MgQVBJIGNvdWxkIGJlIGltcGxlbWVudGVkIHVzaW5nIG1pbmUg
YXMgYSBzdWJyb3V0aW5lIChwbGVhc2Ugc2VlIGJlbG93KS4gU28geW91ciAibmljZXIgYXBwcm9h
Y2giIHdpbGwgY29udGludWUgdG8gd29yayBhcyBsb25nIGFzIGl0IHdvcmtzIHdpdGggY3VycmVu
dCBwYXRjaC4gSG93ZXZlciwgcGxlYXNlIGtlZXAgaW4gbWluZCB0aGF0IHlvdXIgIm5pY2VyIiBh
cHByb2FjaCBkb2Vzbid0IGhhdmUgdG8gYmUgdGhlICJvbmx5IiBhcHByb2FjaC4NCg0KVGhlIGNv
ZGUgc25pcHBldCBiZWxvdyBzaG93cyBhbiBlcXVpdmFsZW50IGltcGxlbWVudGF0aW9uIG9mIE1y
LiBDaHJpc3RvcGhlcnNvbidzIEFQSSB1c2luZyBtaW5lIGFzIGEgc3Vicm91dGluZSwgZXhjZXB0
IHRoYXQgUkJQIGNhbm5vdCBiZSB1c2VkIGFzIGEgcGFyYW1ldGVyIHRvIHRoZSBlbmNsYXZlIGJl
Y2F1c2UgaXQgd2lsbCBiZSBvdmVyd3JpdHRlbiBiZWZvcmUgRUVOVEVSLiBUbyBkaXN0aW5ndWlz
aCBoaXMgQVBJIGFuZCBtaW5lLCB0aGV5IGFyZSByZW5hbWVkIHRvIF9fdmRzb19zZ3hfZW50ZXJf
ZW5jbGF2ZV9DaHJpc3RvcGhlcnNvbiBhbmQgX192ZHNvX3NneF9lbnRlcl9lbmNsYXZlX1hpbmcs
IHJlc3BlY3RpdmVseS4gDQoNCl9fdmRzb19zZ3hfZW50ZXJfZW5jbGF2ZV9DaHJpc3RvcGhlcnNv
bjoNCiAgICAgICAgcHVzaCAgICAkMCAgICAgIC8qIE5vICJleGl0IGNhbGxiYWNrIiBwcm92aWRl
ZCAqLw0KICAgICAgICBwdXNoICAgICVyY3ggICAgLyogT3B0aW9uYWwgcG9pbnRlciB0byAnc3Ry
dWN0IHNneF9lbmNsYXZlX2V4Y2VwdGlvbicgKi8NCiAgICAgICAgcHVzaCAgICAlcmJ4ICAgIC8q
IFRDUyAqLw0KICAgICAgICBjYWxsICAgIF9fdmRzb19zZ3hfZW50ZXJfZW5jbGF2ZV9YaW5nDQog
ICAgICAgIGFkZCAgICAgJDI0LCAlcnNwDQogICAgICAgIHJldA0KDQpUaGFua3MhDQoNCi1DZWRy
aWMNCg==
