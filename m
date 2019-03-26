Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7149C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 12:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73FF02075C
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 12:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfCZMBi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:01:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:18163 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbfCZMBh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 08:01:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 05:01:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="310509550"
Received: from pgsmsx101.gar.corp.intel.com ([10.221.44.78])
  by orsmga005.jf.intel.com with ESMTP; 26 Mar 2019 05:01:32 -0700
Received: from pgsmsx109.gar.corp.intel.com (10.221.44.109) by
 PGSMSX101.gar.corp.intel.com (10.221.44.78) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 26 Mar 2019 20:01:31 +0800
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.114]) by
 PGSMSX109.gar.corp.intel.com ([169.254.14.173]) with mapi id 14.03.0415.000;
 Tue, 26 Mar 2019 20:01:31 +0800
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
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
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
Subject: Re: [PATCH v19,RESEND 16/27] x86/sgx: Add the Linux SGX Enclave
 Driver
Thread-Topic: [PATCH v19,RESEND 16/27] x86/sgx: Add the Linux SGX Enclave
 Driver
Thread-Index: AQHU3zlqJyshVndaUUiNLGXmU0HMwKYdUroA
Date:   Tue, 26 Mar 2019 12:01:31 +0000
Message-ID: <1553601688.17255.12.camel@intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
         <20190320162119.4469-17-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20190320162119.4469-17-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.24.201]
Content-Type: text/plain; charset="utf-8"
Content-ID: <31E7A22AF4084D48B90E7B42298F726C@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gV2VkLCAyMDE5LTAzLTIwIGF0IDE4OjIxICswMjAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
DQo+IEludGVsIFNvZnR3YXJlIEd1YXJkIGVYdGVuc2lvbnMgKFNHWCkgaXMgYSBzZXQgb2YgQ1BV
IGluc3RydWN0aW9ucyB0aGF0DQo+IGNhbiBiZSB1c2VkIGJ5IGFwcGxpY2F0aW9ucyB0byBzZXQg
YXNpZGUgcHJpdmF0ZSByZWdpb25zIG9mIGNvZGUgYW5kDQo+IGRhdGEuIFRoZSBjb2RlIG91dHNp
ZGUgdGhlIGVuY2xhdmUgaXMgZGlzYWxsb3dlZCB0byBhY2Nlc3MgdGhlIG1lbW9yeQ0KPiBpbnNp
ZGUgdGhlIGVuY2xhdmUgYnkgdGhlIENQVSBhY2Nlc3MgY29udHJvbC4NCj4gDQo+IFRoaXMgY29t
bWl0IGFkZHMgdGhlIExpbnV4IFNHWCBFbmNsYXZlIERyaXZlciB0aGF0IHByb3ZpZGVzIGFuIGlv
Y3RsIEFQSQ0KPiB0byBtYW5hZ2UgZW5jbGF2ZXMuIFRoZSBhZGRyZXNzIHJhbmdlIGZvciBhbiBl
bmNsYXZlLCBjb21tb25seSByZWZlcnJlZA0KPiBhcyBFTFJBTkdFIGluIHRoZSBkb2N1bWVudGF0
aW9uIChlLmcuIEludGVsIFNETSksIGlzIHJlc2VydmVkIHdpdGgNCj4gbW1hcCgpIGFnYWluc3Qg
L2Rldi9zZ3guIEFmdGVyIHRoYXQgYSBzZXQgaW9jdGxzIGlzIHVzZWQgdG8gYnVpbGQNCj4gdGhl
IGVuY2xhdmUgdG8gdGhlIEVMUkFOR0UuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKYXJra28gU2Fr
a2luZW4gPGphcmtrby5zYWtraW5lbkBsaW51eC5pbnRlbC5jb20+DQo+IENvLWRldmVsb3BlZC1i
eTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlzdG9waGVy
c29uQGludGVsLmNvbT4NCj4gQ28tZGV2ZWxvcGVkLWJ5OiBTZXJnZSBBeW91biA8c2VyZ2UuYXlv
dW5AaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZXJnZSBBeW91biA8c2VyZ2UuYXlvdW5A
aW50ZWwuY29tPg0KPiBDby1kZXZlbG9wZWQtYnk6IFNoYXkgS2F0ei16YW1pciA8c2hheS5rYXR6
LXphbWlyQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2hheSBLYXR6LXphbWlyIDxzaGF5
LmthdHotemFtaXJAaW50ZWwuY29tPg0KPiBDby1kZXZlbG9wZWQtYnk6IFN1cmVzaCBTaWRkaGEg
PHN1cmVzaC5iLnNpZGRoYUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFN1cmVzaCBTaWRk
aGEgPHN1cmVzaC5iLnNpZGRoYUBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgRG9jdW1lbnRhdGlvbi9p
b2N0bC9pb2N0bC1udW1iZXIudHh0ICAgIHwgICAxICsNCj4gIGFyY2gveDg2L0tjb25maWcgICAg
ICAgICAgICAgICAgICAgICAgICB8ICAxNyArLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS91YXBpL2Fz
bS9zZ3guaCAgICAgICAgIHwgIDU5ICsrDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9NYWtl
ZmlsZSAgICAgICAgfCAgIDUgKy0NCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci9N
YWtlZmlsZSB8ICAgMyArDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9kcml2ZXIvZHJpdmVy
LmggfCAgMzggKysNCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci9pb2N0bC5jICB8
IDc5NSArKysrKysrKysrKysrKysrKysrKysrKysNCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4
L2RyaXZlci9tYWluLmMgICB8IDI5MCArKysrKysrKysNCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUv
c2d4L2VuY2wuYyAgICAgICAgICB8IDM1OCArKysrKysrKysrKw0KPiAgYXJjaC94ODYva2VybmVs
L2NwdS9zZ3gvZW5jbC5oICAgICAgICAgIHwgIDg4ICsrKw0KPiAgYXJjaC94ODYva2VybmVsL2Nw
dS9zZ3gvZW5jbHMuYyAgICAgICAgIHwgICAxICsNCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4
L21haW4uYyAgICAgICAgICB8ICAgMyArDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9zZ3gu
aCAgICAgICAgICAgfCAgIDEgKw0KPiAgMTMgZmlsZXMgY2hhbmdlZCwgMTY1NyBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gveDg2L2luY2x1
ZGUvdWFwaS9hc20vc2d4LmgNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL3g4Ni9rZXJuZWwv
Y3B1L3NneC9kcml2ZXIvTWFrZWZpbGUNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL3g4Ni9r
ZXJuZWwvY3B1L3NneC9kcml2ZXIvZHJpdmVyLmgNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNo
L3g4Ni9rZXJuZWwvY3B1L3NneC9kcml2ZXIvaW9jdGwuYw0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0
IGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci9tYWluLmMNCj4gIGNyZWF0ZSBtb2RlIDEw
MDY0NCBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNsLmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0
NCBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNsLmgNCg0KU2hvdWxkbid0IHRoZSBkcml2ZXIg
YmUgbG9jYXRlZCBzb21ld2hlcmUgdW5kZXIgZHJpdmVycy8sIGJ1dCBub3QgdW5kZXIgYXJjaC94
ODY/DQoNCkkgZG9uJ3QgdGhpbmsgeDg2IG1haW50YWluZXJzIHNob3VsZCBoYXZlIHRoZSBidXJk
ZW4gdG8gcmV2aWV3IGV2ZXJ5IGNvZGUgY2hhbmdlIG1hZGUgdG8gU0dYIGRyaXZlcj8NCg0KVGhh
bmtzLA0KLUthaQ==
