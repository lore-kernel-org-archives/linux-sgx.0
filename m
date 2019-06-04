Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D314C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 21:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C5642070B
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 21:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfFDVyX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 17:54:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:58618 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfFDVyX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 17:54:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 14:54:22 -0700
X-ExtLoop1: 1
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga003.jf.intel.com with ESMTP; 04 Jun 2019 14:54:21 -0700
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 4 Jun 2019 14:54:21 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.172]) with mapi id 14.03.0415.000;
 Tue, 4 Jun 2019 14:54:21 -0700
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
Subject: RE: [RFC PATCH 7/9] x86/sgx: Enforce noexec filesystem restriction
 for enclaves
Thread-Topic: [RFC PATCH 7/9] x86/sgx: Enforce noexec filesystem restriction
 for enclaves
Thread-Index: AQHVGAkjwUGhfvPW2Uy0jc3S+IXJ16aMKaSAgABC2AD//6D4cA==
Date:   Tue, 4 Jun 2019 21:54:21 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654EDBA2@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-8-sean.j.christopherson@intel.com>
 <20190604162555.GC3811@linux.intel.com>
 <CALCETrUqcQNbRvBe2UqQih8RHnuwn3KaC=xJU1cRsaEVsCQUgw@mail.gmail.com>
In-Reply-To: <CALCETrUqcQNbRvBe2UqQih8RHnuwn3KaC=xJU1cRsaEVsCQUgw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTVhZDM0N2EtOTIxMi00ZWFmLTk4YWMtZjAzYzkxZTRkZjNlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiam9PYTBna2xLdzRrMFZSK0pVdVNoYXV2OW4zbUwzZTVFSnlmcGxXRzRORlZtaFJiQTdEdFRoWTgzMUdrdm52cSJ9
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

PiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5vcmddDQo+IFNlbnQ6
IFR1ZXNkYXksIEp1bmUgMDQsIDIwMTkgMToyNSBQTQ0KPiBUbzogSmFya2tvIFNha2tpbmVuIDxq
YXJra28uc2Fra2luZW5AbGludXguaW50ZWwuY29tPg0KPiANCj4gT24gVHVlLCBKdW4gNCwgMjAx
OSBhdCA5OjI2IEFNIEphcmtrbyBTYWtraW5lbg0KPiA8amFya2tvLnNha2tpbmVuQGxpbnV4Lmlu
dGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiBGcmksIE1heSAzMSwgMjAxOSBhdCAwNDozMTo1
N1BNIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+ID4gRG8gbm90IGFsbG93
IGFuIGVuY2xhdmUgcGFnZSB0byBiZSBtYXBwZWQgd2l0aCBQUk9UX0VYRUMgaWYgdGhlDQo+ID4g
PiBzb3VyY2UgcGFnZSBpcyBiYWNrZWQgYnkgYSBmaWxlIG9uIGEgbm9leGVjIGZpbGUgc3lzdGVt
Lg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4u
ai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+DQo+ID4NCj4gPiBXaHkgZG9uJ3QgeW91IGp1c3Qg
Y2hlY2sgaW4gc2d4X2VuY2xfYWRkX3BhZ2UoKSB0aGF0IHdoZXRoZXIgdGhlIHBhdGgNCj4gPiBj
b21lcyBmcm9tIG5vZXhlYyBhbmQgZGVueSBpZiBTRUNJTkZPIGNvbnRhaW5zIFg/DQo+ID4NCj4g
DQo+IFNFQ0lORk8gc2VlbXMgYWxtb3N0IGVudGlyZWx5IHVzZWxlc3MgZm9yIHRoaXMga2luZCBv
ZiB0aGluZyBiZWNhdXNlIG9mDQo+IFNHWDIuICBJJ20gdGhpbmtpbmcgdGhhdCBTRUNJTkZPIHNo
b3VsZCBiZSBjb21wbGV0ZWx5IGlnbm9yZWQgZm9yDQo+IGFueXRoaW5nIG90aGVyIHRoYW4gaXRz
IHJlcXVpcmVkIGFyY2hpdGVjdHVyYWwgcHVycG9zZS4NCg0KRm9yIHRoZSBwdXJwb3NlIG9mIGFs
bG93aW5nL2RlbnlpbmcgRUFERC9FQVVHLCBTRUNJTkZPIGlzIHVzZWxlc3MuIA0KDQpCdXQgU0VD
SU5GTyBjb250YWlucyBhbHNvIHRoZSBwYWdlIHR5cGUuIFdoYXQncyBjb21pbmcgYXMgbmV3IGZl
YXR1cmUgb2YgU0dYMiBpcyBDT05GSUdJRCwgd2hpY2ggaXMgYSA1MTItYml0IHZhbHVlIGluc2lk
ZSBTRUNTLCBwcm92aWRlZCBieSB1bnRydXN0ZWQgY29kZSBhdCBFQ1JFQVRFLiBVc3VhbGx5IENP
TkZJR0lEIGlzIGEgaGFzaCBvZiBzb21ldGhpbmcgdGhhdCB3b3VsZCBhZmZlY3QgdGhlIGJlaGF2
aW9yIG9mIHRoZSBlbmNsYXZlLiBGb3IgZXhhbXBsZSwgdGhlICJtYWluIiBlbmNsYXZlIGNvdWxk
IGJlIGEgSlZNIHdpdGggdGhlIGFjdHVhbCBhcHBsZXQgYmVpbmcgbG9hZGVkIGhhc2hlZCBpbnRv
IFNFQ1MuQ09ORklHSUQuIEluIHRoYXQgY2FzZSB0aGUgZW5jbGF2ZSdzIG1lYXN1cmVtZW50cyAo
TVJFTkNMQVZFKSB3aWxsIHN0YXkgdGhlIHNhbWUgZm9yIGFsbCBhcHBsZXRzIHlldCBpbmRpdmlk
dWFsIGFwcGxldCB3aWxsIGhhdmUgZGlzdGluY3QgQ09ORklHSUQgYW5kIHJlY2VpdmUgZGlzdGlu
Y3Qga2V5cy4gV2hlbiBpdCBjb21lcyB0byBMU00sIGEgcG9saWN5IG1heSB3YW50IHRvIHdoaXRl
bGlzdC9ibGFja2xpc3QgYXBwbGV0cyBmb3IgYSBKVk0gc28gYSBob29rIGF0IEVDUkVBVEUgbWF5
IGJlIGRlc2lyYWJsZS4gV2UgY291bGQgZWl0aGVyIGRlZmluZSBhIG5ldyBob29rLCBvciBvdmVy
bG9hZCBzZWN1cml0eV9lbmNsYXZlX2xvYWQoKSBieSBwcm92aWRpbmcgU0VDSU5GTyBhcyBvbmUg
b2YgaXRzIHBhcmFtZXRlcnMuDQo=
