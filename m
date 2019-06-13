Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93247C31E49
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F8E320673
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393009AbfFMQrO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:47:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:40156 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392924AbfFMQrK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 12:47:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 09:47:09 -0700
X-ExtLoop1: 1
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jun 2019 09:47:08 -0700
Received: from orsmsx155.amr.corp.intel.com (10.22.240.21) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 13 Jun 2019 09:47:07 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX155.amr.corp.intel.com ([169.254.7.68]) with mapi id 14.03.0415.000;
 Thu, 13 Jun 2019 09:47:07 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
CC:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
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
Thread-Index: AQHVGAkhOWaRiY3eFUikM4z1CKpVNqaL3IKAgACNcAD//6h8oIABllSAgABS9QCAAUUHgIAK4cIA//+706A=
Date:   Thu, 13 Jun 2019 16:47:06 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65503A93@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-3-sean.j.christopherson@intel.com>
 <20190604114951.GC30594@linux.intel.com>
 <CALCETrVe0jhAWAFmx+NFEjJcijSJv2LDVC7cUXi0w99kNKjh_g@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EDBDE@ORSMSX116.amr.corp.intel.com>
 <20190605151653.GK11331@linux.intel.com>
 <5A85C1D7-A159-437E-B42A-3F4254E07305@amacapital.net>
 <20190606153710.GB25112@linux.intel.com>
 <20190613134800.GA12791@linux.intel.com>
In-Reply-To: <20190613134800.GA12791@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzE2M2VhMDctZGU1MS00ZWU3LThhMWQtYjc5ZGQ4ZjgxNTA0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMzh2ZjlrUGRBZ0c5WVlcLzY1QndNQUh6NTlRWFFTYzVoWmpNUnZId0pZS1NHTEVKZTlDUkRjMURcLytvbDJsSkp3In0=
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

PiBGcm9tOiBKYXJra28gU2Fra2luZW4gW21haWx0bzpqYXJra28uc2Fra2luZW5AbGludXguaW50
ZWwuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgSnVuZSAxMywgMjAxOSA2OjQ4IEFNDQo+IA0KPiBP
biBUaHUsIEp1biAwNiwgMjAxOSBhdCAwNjozNzoxMFBNICswMzAwLCBKYXJra28gU2Fra2luZW4g
d3JvdGU6DQo+ID4gT24gV2VkLCBKdW4gMDUsIDIwMTkgYXQgMDE6MTQ6MDRQTSAtMDcwMCwgQW5k
eSBMdXRvbWlyc2tpIHdyb3RlOg0KPiA+ID4NCj4gPiA+DQo+ID4gPiA+IE9uIEp1biA1LCAyMDE5
LCBhdCA4OjE3IEFNLCBKYXJra28gU2Fra2luZW4NCj4gPGphcmtrby5zYWtraW5lbkBsaW51eC5p
bnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPj4gT24gVHVlLCBKdW4gMDQsIDIwMTkg
YXQgMTA6MTA6MjJQTSArMDAwMCwgWGluZywgQ2VkcmljIHdyb3RlOg0KPiA+ID4gPj4gQSBiaXQg
b2ZmIHRvcGljIGhlcmUuIFRoaXMgbW1hcCgpL21wcm90ZWN0KCkgZGlzY3Vzc2lvbiByZW1pbmRz
DQo+ID4gPiA+PiBtZSBhIHF1ZXN0aW9uIChndWVzcyBmb3IgSmFya2tvKTogTm93IHRoYXQNCj4g
PiA+ID4+IHZtYS0+dm1fZmlsZS0+cHJpdmF0ZV9kYXRhIGtlZXBzIGEgcG9pbnRlciB0byB0aGUg
ZW5jbGF2ZSwgd2h5IGRvDQo+IHdlIHN0b3JlIGl0IGFnYWluIGluIHZtYS0+dm1fcHJpdmF0ZT8N
Cj4gPiA+ID4+IEl0IGlzbid0IGEgYmlnIGRlYWwgYnV0IG5vbi1OVUxMIHZtX3ByaXZhdGUgZG9l
cyBwcmV2ZW50DQo+ID4gPiA+PiBtcHJvdGVjdCgpIGZyb20gbWVyZ2luZyBhZGphY2VudCBWTUFz
Lg0KPiA+ID4gPg0KPiA+ID4gPiBTYW1lIHNlbWFudGljcyBhcyB3aXRoIGEgcmVndWxhciBtbWFw
IGkuZS4geW91IGNhbiBjbG9zZSB0aGUgZmlsZQ0KPiA+ID4gPiBhbmQgc3RpbGwgdXNlIHRoZSBt
YXBwaW5nLg0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IFRoZSBmaWxlIHNob3VsZCBi
ZSBwcm9wZXJseSByZWZjb3VudGVkIOKAlCB2bV9maWxlIHNob3VsZCBub3QgZ28gYXdheQ0KPiB3
aGlsZSBpdOKAmXMgbWFwcGVkLg0KPiANCj4gbW0gYWxyZWFkeSB0YWtlcyBjYXJlIG9mIHRoYXQg
c28gdm1fZmlsZSBkb2VzIG5vdCBnbyBhd2F5LiBTdGlsbCB3ZSBuZWVkDQo+IGFuIGludGVybmFs
IHJlZmNvdW50IGZvciBlbmNsYXZlcyB0byBzeW5jaHJvbml6ZSB3aXRoIHRoZSBzd2FwcGVyLiBJ
bg0KPiBzdW1tYXJ5IG5vdGhpbmcgbmVlZHMgdG8gYmUgZG9uZS4NCg0KSSBkb24ndCBnZXQgdGhp
cy4gVGhlIHN3YXBwZXIgdGFrZXMgYSByZWFkIGxvY2sgb24gbW0tPm1tYXBfc2VtLCB3aGljaCBs
b2NrcyB0aGUgdm1hLCB3aGljaCBpbiB0dXJuIHJlZmVyZW5jZSBjb3VudHMgdm1hLT52bV9maWxl
LiBXaHkgaXMgdGhlIGludGVybmFsIHJlZmNvdW50IHN0aWxsIG5lZWRlZD8gDQoNCj4gDQo+ID4g
UmlnaHQsIG1ha2VzIHNlbnNlLiBJdCBpcyBlYXN5IG9uZSB0byBjaGFuZ2UgZXNzZW50aWFsbHkg
anVzdCByZW1vdmluZw0KPiA+IGludGVybmFsIHJlZmNvdW50IGZyb20gc2d4X2VuY2wgYW5kIHVz
aW5nIGZpbGUgZm9yIHRoZSBzYW1lLiBJJ2xsDQo+ID4gdXBkYXRlIHRoaXMgdG8gbXkgdHJlZSBh
bG9uZyB3aXRoIHRoZSBjaGFuZ2VzIHRvIHJlbW92ZSBMS00vQUNQSSBiaXRzDQo+IEFTQVAuDQo+
IA0KPiAvSmFya2tvDQo=
