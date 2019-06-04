Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5886C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 22:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDF13206B8
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 22:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfFDWKZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 18:10:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:6264 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFDWKZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 18:10:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 15:10:24 -0700
X-ExtLoop1: 1
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga004.jf.intel.com with ESMTP; 04 Jun 2019 15:10:24 -0700
Received: from orsmsx162.amr.corp.intel.com (10.22.240.85) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 4 Jun 2019 15:10:23 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX162.amr.corp.intel.com ([169.254.3.190]) with mapi id 14.03.0415.000;
 Tue, 4 Jun 2019 15:10:24 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Stephen Smalley" <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
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
Subject: RE: [RFC PATCH 2/9] x86/sgx: Do not naturally align MAP_FIXED
 address
Thread-Topic: [RFC PATCH 2/9] x86/sgx: Do not naturally align MAP_FIXED
 address
Thread-Index: AQHVGAkhOWaRiY3eFUikM4z1CKpVNqaL3IKAgACNcAD//6h8oA==
Date:   Tue, 4 Jun 2019 22:10:22 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654EDBDE@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-3-sean.j.christopherson@intel.com>
 <20190604114951.GC30594@linux.intel.com>
 <CALCETrVe0jhAWAFmx+NFEjJcijSJv2LDVC7cUXi0w99kNKjh_g@mail.gmail.com>
In-Reply-To: <CALCETrVe0jhAWAFmx+NFEjJcijSJv2LDVC7cUXi0w99kNKjh_g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTViMzE3OTQtY2NkZi00ZWM4LWEzMTAtNmQyNWExNzc4MDRmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaXI3M1Jpa2o5dGpHbjhYR3NYd3FIM1pJQWhpamtWRytkQW1seTVnTWdpanpsQTZiendSOWRKcDhpMUVVXC9WdlgifQ==
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
LQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBBbmR5IEx1dG9taXJza2kN
Cj4gU2VudDogVHVlc2RheSwgSnVuZSAwNCwgMjAxOSAxOjE2IFBNDQo+IA0KPiBPbiBUdWUsIEp1
biA0LCAyMDE5IGF0IDQ6NTAgQU0gSmFya2tvIFNha2tpbmVuDQo+IDxqYXJra28uc2Fra2luZW5A
bGludXguaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IE9uIEZyaSwgTWF5IDMxLCAyMDE5IGF0
IDA0OjMxOjUyUE0gLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiBTR1gg
ZW5jbGF2ZXMgaGF2ZSBhbiBhc3NvY2lhdGVkIEVuY2xhdmUgTGluZWFyIFJhbmdlIChFTFJBTkdF
KSB0aGF0DQo+ID4gPiBpcyB0cmFja2VkIGFuZCBlbmZvcmNlZCBieSB0aGUgQ1BVIHVzaW5nIGEg
YmFzZSttYXNrIGFwcHJvYWNoLA0KPiA+ID4gc2ltaWxhciB0byBob3cgaGFyZHdhcmUgcmFuZ2Ug
cmVnaXN0ZXJzIHN1Y2ggYXMgdGhlIHZhcmlhYmxlIE1UUlJzLg0KPiA+ID4gQXMgYSByZXN1bHQs
IHRoZSBFTFJBTkdFIG11c3QgYmUgbmF0dXJhbGx5IHNpemVkIGFuZCBhbGlnbmVkLg0KPiA+ID4N
Cj4gPiA+IFRvIHJlZHVjZSBib2lsZXJwbGF0ZSBjb2RlIHRoYXQgd291bGQgYmUgbmVlZGVkIGlu
IGV2ZXJ5IHVzZXJzcGFjZQ0KPiA+ID4gZW5jbGF2ZSBsb2FkZXIsIHRoZSBTR1ggZHJpdmVyIG5h
dHVyYWxseSBhbGlnbnMgdGhlIG1tYXAoKSBhZGRyZXNzDQo+ID4gPiBhbmQgYWxzbyByZXF1aXJl
cyB0aGUgcmFuZ2UgdG8gYmUgbmF0dXJhbGx5IHNpemVkLiAgVW5mb3J0dW5hdGVseSwNCj4gPiA+
IFNHWCBmYWlscyB0byBncmFudCBhIHdhaXZlciB0byB0aGUgTUFQX0ZJWEVEIGNhc2UsIGUuZy4g
aW5jb3JyZWN0bHkNCj4gPiA+IHJlamVjdHMgbW1hcCgpIGlmIHVzZXJzcGFjZSBpcyBhdHRlbXB0
aW5nIHRvIG1hcCBhIHNtYWxsIHNsaWNlIG9mIGFuDQo+IGV4aXN0aW5nIGVuY2xhdmUuDQo+ID4g
Pg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlz
dG9waGVyc29uQGludGVsLmNvbT4NCj4gPg0KPiA+IFdoeSB5b3Ugd2FudCB0byBhbGxvdyBtbWFw
KCkgdG8gYmUgY2FsbGVkIG11bHRpcGxlIHRpbWVzPyBtbWFwKCkgY291bGQNCj4gPiBiZSBhbGxv
d2VkIG9ubHkgb25jZSB3aXRoIFBST1RfTk9ORSBhbmQgZGVuaWVkIGFmdGVyd2FyZHMuIElzIHRo
aXMgZm9yDQo+ID4gc2VuZGluZyBmZCB0byBhbm90aGVyIHByb2Nlc3MgdGhhdCB3b3VsZCBtYXAg
YWxyZWFkeSBleGlzdGluZyBlbmNsYXZlPw0KPiA+DQo+ID4gSSBkb24ndCBzZWUgYW55IGNoZWNr
cyBmb3Igd2hldGhlciB0aGUgaXMgZW5jbGF2ZSB1bmRlcm5lYXRoLiBBbHNvLCBJDQo+ID4gdGhp
bmsgdGhhdCBpbiBhbGwgY2FzZXMgbW1hcCgpIGNhbGxiYWNrIHNob3VsZCBhbGxvdyBvbmx5IFBS
T1RfTk9ORSBhcw0KPiA+IHBlcm1pc3Npb25zIGZvciBjbGFyaXR5IGV2ZW4gaWYgaXQgY291bGQg
Y2FsbGVkIG11bHRpcGxlIHRpbWVzLg0KPiA+DQo+IA0KPiBXaGF0J3MgdGhlIGFkdmFudGFnZSB0
byBvbmx5IGFsbG93aW5nIFBST1RfTk9ORT8gIFRoZSBpZGVhIGhlcmUgaXMgdG8NCj4gYWxsb3cg
YSBQUk9UX05PTkUgbWFwIGZvbGxvd2VkIGJ5IHNvbWUgcmVwbGFjZW1ldHMgdGhhdCBvdmVybGF5
IGl0IGZvcg0KPiB0aGUgaW5kaXZpZHVhbCBzZWdtZW50cy4gIEFkbWl0dGVkbHksIG1wcm90ZWN0
KCkgY2FuIGRvIHRoZSBzYW1lIHRoaW5nLA0KPiBidXQgZGlzYWxsb3dpbmcgbW1hcCgpIHNlZW1z
IGF0IGxlYXN0IGEgYml0IHN1cnByaXNpbmcuDQoNCkRpc2FsbG93aW5nIG1tYXAoKSBpcyBub3Qg
b25seSBzdXJwcmlzaW5nIGJ1dCBhbHNvIHVubmVjZXNzYXJ5Lg0KDQpBIGJpdCBvZmYgdG9waWMg
aGVyZS4gVGhpcyBtbWFwKCkvbXByb3RlY3QoKSBkaXNjdXNzaW9uIHJlbWluZHMgbWUgYSBxdWVz
dGlvbiAoZ3Vlc3MgZm9yIEphcmtrbyk6IE5vdyB0aGF0IHZtYS0+dm1fZmlsZS0+cHJpdmF0ZV9k
YXRhIGtlZXBzIGEgcG9pbnRlciB0byB0aGUgZW5jbGF2ZSwgd2h5IGRvIHdlIHN0b3JlIGl0IGFn
YWluIGluIHZtYS0+dm1fcHJpdmF0ZT8gSXQgaXNuJ3QgYSBiaWcgZGVhbCBidXQgbm9uLU5VTEwg
dm1fcHJpdmF0ZSBkb2VzIHByZXZlbnQgbXByb3RlY3QoKSBmcm9tIG1lcmdpbmcgYWRqYWNlbnQg
Vk1Bcy4gDQoNCg==
