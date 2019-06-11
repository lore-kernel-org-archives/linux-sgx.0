Return-Path: <SRS0=yZGw=UK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0490FC31E44
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Jun 2019 22:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1C772086D
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Jun 2019 22:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436957AbfFKWzp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Jun 2019 18:55:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:47106 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436750AbfFKWzp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Jun 2019 18:55:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jun 2019 15:55:44 -0700
X-ExtLoop1: 1
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga007.jf.intel.com with ESMTP; 11 Jun 2019 15:55:44 -0700
Received: from orsmsx115.amr.corp.intel.com (10.22.240.11) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 11 Jun 2019 15:55:44 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX115.amr.corp.intel.com ([169.254.4.229]) with mapi id 14.03.0415.000;
 Tue, 11 Jun 2019 15:55:43 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "pmccallum@redhat.com" <pmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Thread-Topic: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks
 in SELinux
Thread-Index: AQHVH1ilvNGS2ZisK0eWTCWidam/YaaW7RmA///+7GA=
Date:   Tue, 11 Jun 2019 22:55:42 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65502A85@ORSMSX116.amr.corp.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
In-Reply-To: <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTYzZDA3ZGYtZTk5ZS00OGE1LWI0YzctNjQzMDNmNjkyOGMyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoib1FobnpwRWxYcWtxZWZYK0RjWTZZbk9QeEc1TGJTYW05K2VrWE9JdWZPWEdMbXdQOXZWY3dZbjA3WlVMZXFIVyJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBGcm9tOiBsaW51eC1zZ3gtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtc2d4
LQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBTdGVwaGVuIFNtYWxsZXkN
Cj4gU2VudDogVHVlc2RheSwgSnVuZSAxMSwgMjAxOSA2OjQwIEFNDQo+IA0KPiA+DQo+ID4gKyNp
ZmRlZiBDT05GSUdfSU5URUxfU0dYDQo+ID4gKwlyYyA9IHNneHNlY19tcHJvdGVjdCh2bWEsIHBy
b3QpOw0KPiA+ICsJaWYgKHJjIDw9IDApDQo+ID4gKwkJcmV0dXJuIHJjOw0KPiANCj4gV2h5IGFy
ZSB5b3Ugc2tpcHBpbmcgdGhlIGZpbGVfbWFwX3Byb3RfY2hlY2soKSBjYWxsIHdoZW4gcmMgPT0g
MD8NCj4gV2hhdCB3b3VsZCBTRUxpbnV4IGNoZWNrIGlmIHlvdSBkaWRuJ3QgZG8gc28gLQ0KPiBG
SUxFX19SRUFEfEZJTEVfX1dSSVRFfEZJTEVfX0VYRUNVVEUgdG8gL2Rldi9zZ3gvZW5jbGF2ZT8g
IElzIGl0IGENCj4gcHJvYmxlbSB0byBsZXQgU0VMaW51eCBwcm9jZWVkIHdpdGggdGhhdCBjaGVj
az8NCg0KV2UgY2FuIGNvbnRpbnVlIHRoZSBjaGVjay4gQnV0IGluIHByYWN0aWNlLCBhbGwgRklM
RV9fe1JFQUR8V1JJVEV8RVhFQ1VURX0gYXJlIG5lZWRlZCBmb3IgZXZlcnkgZW5jbGF2ZSwgdGhl
biB3aGF0J3MgdGhlIHBvaW50IG9mIGNoZWNraW5nIHRoZW0/IEZJTEVfX0VYRUNNT0QgbWF5IGJl
IHRoZSBvbmx5IGZsYWcgdGhhdCBoYXMgYSBtZWFuaW5nLCBidXQgaXQncyBraW5kIG9mIHJlZHVu
ZGFudCBiZWNhdXNlIHNpZ3N0cnVjdCBmaWxlIHdhcyBjaGVja2VkIGFnYWluc3QgdGhhdCBhbHJl
YWR5Lg0KDQo+ID4gK3N0YXRpYyBpbnQgc2VsaW51eF9lbmNsYXZlX2xvYWQoc3RydWN0IGZpbGUg
KmVuY2wsIHVuc2lnbmVkIGxvbmcgYWRkciwNCj4gPiArCQkJCXVuc2lnbmVkIGxvbmcgc2l6ZSwg
dW5zaWduZWQgbG9uZyBwcm90LA0KPiA+ICsJCQkJc3RydWN0IHZtX2FyZWFfc3RydWN0ICpzb3Vy
Y2UpDQo+ID4gK3sNCj4gPiArCWlmIChzb3VyY2UpIHsNCj4gPiArCQkvKioNCj4gPiArCQkgKiBB
ZGRpbmcgcGFnZSBmcm9tIHNvdXJjZSA9PiBFQUREIHJlcXVlc3QNCj4gPiArCQkgKi8NCj4gPiAr
CQlpbnQgcmMgPSBzZWxpbnV4X2ZpbGVfbXByb3RlY3Qoc291cmNlLCBwcm90LCBwcm90KTsNCj4g
PiArCQlpZiAocmMpDQo+ID4gKwkJCXJldHVybiByYzsNCj4gPiArDQo+ID4gKwkJaWYgKCEocHJv
dCAmIFZNX0VYRUMpICYmDQo+ID4gKwkJICAgIHNlbGludXhfZmlsZV9tcHJvdGVjdChzb3VyY2Us
IFZNX0VYRUMsIFZNX0VYRUMpKQ0KPiANCj4gSSB3b3VsZG4ndCBjb25mbGF0ZSBWTV9FWEVDIHdp
dGggUFJPVF9FWEVDIGV2ZW4gaWYgdGhleSBoYXBwZW4gdG8gYmUNCj4gZGVmaW5lZCB3aXRoIHRo
ZSBzYW1lIHZhbHVlcyBjdXJyZW50bHkuICBFbHNld2hlcmUgdGhlIGtlcm5lbCBhcHBlYXJzIHRv
DQo+IGV4cGxpY2l0bHkgdHJhbnNsYXRlIHRoZW0gYWxhIGNhbGNfdm1fcHJvdF9iaXRzKCkuDQoN
ClRoYW5rcyEgSSdkIGNoYW5nZSB0aGVtIHRvIFBST1RfRVhFQyBpbiB0aGUgbmV4dCB2ZXJzaW9u
Lg0KDQo+IA0KPiBBbHNvLCB0aGlzIHdpbGwgbWVhbiB0aGF0IHdlIHdpbGwgYWx3YXlzIHBlcmZv
cm0gYW4gZXhlY3V0ZSBjaGVjayBvbiBhbGwNCj4gc291cmNlcywgdGhlcmVieSB0cmlnZ2VyaW5n
IGF1ZGl0IGRlbmlhbCBtZXNzYWdlcyBmb3IgYW55IEVBREQgc291cmNlcw0KPiB0aGF0IGFyZSBv
bmx5IGludGVuZGVkIHRvIGJlIGRhdGEuICBEZXBlbmRpbmcgb24gdGhlIHNvdXJjZSwgdGhpcyBj
b3VsZA0KPiB0cmlnZ2VyIFBST0NFU1NfX0VYRUNNRU0gb3IgRklMRV9fRVhFQ01PRCBvciBGSUxF
X19FWEVDVVRFLiAgSW4gYSB3b3JsZA0KPiB3aGVyZSB1c2VycyBvZnRlbiBqdXN0IHJ1biBhbnkg
ZGVuaWFscyB0aGV5IHNlZSB0aHJvdWdoIGF1ZGl0MmFsbG93LA0KPiB0aGV5J2xsIGVuZCB1cCBh
bHdheXMgYWxsb3dpbmcgdGhlbSBhbGwuICBIb3cgY2FuIHRoZXkgdGVsbCB3aGV0aGVyIGl0DQo+
IHdhcyBuZWVkZWQ/IEl0IHdvdWxkIGJlIHByZWZlcmFibGUgaWYgd2UgY291bGQgb25seSB0cmln
Z2VyIGV4ZWN1dGUNCj4gY2hlY2tzIHdoZW4gdGhlcmUgaXMgc29tZSBwcm9iYWJpbGl0eSB0aGF0
IGV4ZWN1dGUgd2lsbCBiZSByZXF1ZXN0ZWQgaW4NCj4gdGhlIGZ1dHVyZS4gIEFsdGVybmF0aXZl
cyB3b3VsZCBiZSB0byBzaWxlbmNlIHRoZSBhdWRpdCBvZiB0aGVzZQ0KPiBwZXJtaXNzaW9uIGNo
ZWNrcyBhbHdheXMgdmlhIHVzZSBvZiBfbm9hdWRpdCgpIGludGVyZmFjZXMgb3IgdG8gc2lsZW5j
ZQ0KPiBhdWRpdCBvZiB0aGVzZSBwZXJtaXNzaW9ucyB2aWEgZG9udGF1ZGl0IHJ1bGVzIGluIHBv
bGljeSwgYnV0IHRoZSBsYXR0ZXINCj4gd291bGQgaGlkZSBhbGwgZGVuaWFscyBvZiB0aGUgcGVy
bWlzc2lvbiBieSB0aGUgcHJvY2Vzcywgbm90IGp1c3QgdGhvc2UNCj4gdHJpZ2dlcmVkIGZyb20g
c2VjdXJpdHlfZW5jbGF2ZV9sb2FkKCkuICBBbmQgaWYgd2Ugc2lsZW5jZSB0aGVtLCB0aGVuIHdl
DQo+IHdvbid0IHNlZSB0aGVtIGV2ZW4gaWYgdGhleSB3ZXJlIG5lZWRlZC4NCg0KKl9ub2F1ZGl0
KCkgaXMgZXhhY3RseSB3aGF0IEkgd2FudGVkLiBCdXQgSSBjb3VsZG4ndCBmaW5kIHNlbGludXhf
ZmlsZV9tcHJvdGVjdF9ub2F1ZGl0KCkvZmlsZV9oYXNfcGVybV9ub2F1ZGl0KCksIGFuZCBJJ20g
cmVsdWN0YW50IHRvIGR1cGxpY2F0ZSBjb2RlLiBBbnkgc3VnZ2VzdGlvbnM/DQogDQo+IA0KPiA+
ICsJCQlwcm90ID0gMDsNCj4gPiArCQllbHNlIHsNCj4gPiArCQkJcHJvdCA9IFNHWF9fRVhFQ1VU
RTsNCj4gPiArCQkJaWYgKHNvdXJjZS0+dm1fZmlsZSAmJg0KPiA+ICsJCQkgICAgIWZpbGVfaGFz
X3Blcm0oY3VycmVudF9jcmVkKCksIHNvdXJjZS0+dm1fZmlsZSwNCj4gPiArCQkJCQkgICBGSUxF
X19FWEVDTU9EKSkNCj4gPiArCQkJCXByb3QgfD0gU0dYX19FWEVDTU9EOw0KPiANCj4gU2ltaWxh
cmx5LCB0aGlzIG1lYW5zIHRoYXQgd2Ugd2lsbCBhbHdheXMgcGVyZm9ybSBhIEZJTEVfX0VYRUNN
T0QgY2hlY2sNCj4gb24gYWxsIGV4ZWN1dGFibGUgc291cmNlcywgdHJpZ2dlcmluZyBhdWRpdCBk
ZW5pYWwgbWVzc2FnZXMgZm9yIGFueSBFQUREDQo+IHNvdXJjZSB0aGF0IGlzIGV4ZWN1dGFibGUg
YnV0IHRvIHdoaWNoIEVYRUNNT0QgaXMgbm90IGFsbG93ZWQsIGFuZCBhZ2Fpbg0KPiB0aGUgbW9z
dCBjb21tb24gcGF0dGVybiB3aWxsIGJlIHRoYXQgdXNlcnMgd2lsbCBhZGQgRVhFQ01PRCB0byBh
bGwNCj4gZXhlY3V0YWJsZSBzb3VyY2VzIHRvIGF2b2lkIHRoaXMuDQo+IA0KPiA+ICsJCX0NCj4g
PiArCQlyZXR1cm4gc2d4c2VjX2VhZGQoZW5jbCwgYWRkciwgc2l6ZSwgcHJvdCk7DQo+ID4gKwl9
IGVsc2Ugew0KPiA+ICsJCS8qKg0KPiA+ICsJCSAgKiBBZGRpbmcgcGFnZSBmcm9tIE5VTEwgPT4g
RUFVRyByZXF1ZXN0DQo+ID4gKwkJICAqLw0KPiA+ICsJCXJldHVybiBzZ3hzZWNfZWF1ZyhlbmNs
LCBhZGRyLCBzaXplLCBwcm90KTsNCj4gPiArCX0NCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGlj
IGludCBzZWxpbnV4X2VuY2xhdmVfaW5pdChzdHJ1Y3QgZmlsZSAqZW5jbCwNCj4gPiArCQkJCWNv
bnN0IHN0cnVjdCBzZ3hfc2lnc3RydWN0ICpzaWdzdHJ1Y3QsDQo+ID4gKwkJCQlzdHJ1Y3Qgdm1f
YXJlYV9zdHJ1Y3QgKnZtYSkNCj4gPiArew0KPiA+ICsJaW50IHJjID0gMDsNCj4gPiArDQo+ID4g
KwlpZiAoIXZtYSkNCj4gPiArCQlyYyA9IC1FSU5WQUw7DQo+IA0KPiBJcyBpdCBldmVyIHZhbGlk
IHRvIGNhbGwgdGhpcyBob29rIHdpdGggYSBOVUxMIHZtYT8gIElmIG5vdCwgdGhpcyBzaG91bGQN
Cj4gYmUgaGFuZGxlZC9wcmV2ZW50ZWQgYnkgdGhlIGNhbGxlci4gIElmIHNvLCBJJ2QganVzdCBy
ZXR1cm4gLUVJTlZBTA0KPiBpbW1lZGlhdGVseSBoZXJlLg0KDQp2bWEgc2hhbGwgbmV2ZXIgYmUg
TlVMTC4gSSdsbCB1cGRhdGUgaXQgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KPiANCj4gPiArDQo+
ID4gKwlpZiAoIXJjICYmICEodm1hLT52bV9mbGFncyAmIFZNX0VYRUMpKQ0KPiA+ICsJCXJjID0g
c2VsaW51eF9maWxlX21wcm90ZWN0KHZtYSwgVk1fRVhFQywgVk1fRVhFQyk7DQo+IA0KPiBJIGhh
ZCB0aG91Z2h0IHdlIHdlcmUgdHJ5aW5nIHRvIGF2b2lkIG92ZXJsb2FkaW5nIEZJTEVfX0VYRUNV
VEUgKG9yDQo+IHdoYXRldmVyIGdldHMgY2hlY2tlZCBoZXJlLCBlLmcuIGNvdWxkIGJlIFBST0NF
U1NfX0VYRUNNRU0gb3INCj4gRklMRV9fRVhFQ01PRCkgb24gdGhlIHNpZ3N0cnVjdCBmaWxlLCBz
aW5jZSB0aGUgY2FsbGVyIGlzbid0IHRydWx5DQo+IGV4ZWN1dGluZyBjb2RlIGZyb20gaXQuDQoN
CkFncmVlZC4gQW5vdGhlciBwcm9ibGVtIHdpdGggRklMRV9fRVhFQ01PRCBvbiB0aGUgc2lnc3Ry
dWN0IGZpbGUgaXMgdGhhdCB1c2VyIGNvZGUgd291bGQgdGhlbiBiZSBhbGxvd2VkIHRvIG1vZGlm
eSBTSUdTVFJVQ1QgYXQgd2lsbCwgd2hpY2ggZWZmZWN0aXZlbHkgd2lwZXMgb3V0IHRoZSBwcm90
ZWN0aW9uIHByb3ZpZGVkIGJ5IEZJTEVfX0VYRUNVVEUuDQoNCj4gDQo+IEknZCBkZWZpbmUgbmV3
IEVOQ0xBVkVfXyogcGVybWlzc2lvbnMsIGluY2x1ZGluZyBhbiB1cC1mcm9udA0KPiBFTkNMQVZF
X19JTklUIHBlcm1pc3Npb24gdGhhdCBnb3Zlcm5zIHdoZXRoZXIgdGhlIHNpZ3N0cnVjdCBmaWxl
IGNhbiBiZQ0KPiB1c2VkIGF0IGFsbCBpcnJlc3BlY3RpdmUgb2YgbWVtb3J5IHByb3RlY3Rpb25z
Lg0KDQpBZ3JlZWQuDQoNCj4gDQo+IFRoZW4geW91IGNhbiBhbHNvIGhhdmUgRU5DTEFWRV9fRVhF
Q1VURSwgRU5DTEFWRV9fRVhFQ01FTSwNCj4gRU5DTEFWRV9fRVhFQ01PRCBmb3IgdGhlIGV4ZWN1
dGUtcmVsYXRlZCBjaGVja3MuICBPciB5b3UgY2FuIHVzZSB0aGUNCj4gL2Rldi9zZ3gvZW5jbGF2
ZSBpbm9kZSBhcyB0aGUgdGFyZ2V0IGZvciB0aGUgZXhlY3V0ZSBjaGVja3MgYW5kIGp1c3QNCj4g
cmV1c2UgdGhlIGZpbGUgcGVybWlzc2lvbnMgdGhlcmUuDQoNCk5vdyB3ZSd2ZSBnb3QgMiBvcHRp
b25zIC0gMSkgTmV3IEVOQ0xBVkVfXyogZmxhZ3Mgb24gc2lnc3RydWN0IGZpbGUgb3IgMikgRklM
RV9fKiBvbiAvZGV2L3NneC9lbmNsYXZlLiBXaGljaCBvbmUgZG8geW91IHRoaW5rIG1ha2VzIG1v
cmUgc2Vuc2U/DQoNCkVOQ0xBVkVfX0VYRUNNRU0gc2VlbXMgdG8gb2ZmZXIgZmluZXIgZ3JhbnVs
YXJpdHkgKHRoYW4gUFJPQ0VTU19fRVhFQ01FTSkgYnV0IEkgd29uZGVyIGlmIGl0J2QgaGF2ZSBh
bnkgcmVhbCB1c2UgaW4gcHJhY3RpY2UuDQoNCj4gPiAraW50IHNneHNlY19tcHJvdGVjdChzdHJ1
Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwgc2l6ZV90IHByb3QpIHsNCj4gPiArCXN0cnVjdCBlbmNs
YXZlX3NlYyAqZXNlYzsNCj4gPiArCWludCByYzsNCj4gPiArDQo+ID4gKwlpZiAoIXZtYS0+dm1f
ZmlsZSB8fCAhKGVzZWMgPSBfX2VzZWMoc2VsaW51eF9maWxlKHZtYS0+dm1fZmlsZSkpKSkNCj4g
ew0KPiA+ICsJCS8qIFBvc2l0aXZlIHJldHVybiB2YWx1ZSBpbmRpY2F0ZXMgbm9uLWVuY2xhdmUg
Vk1BICovDQo+ID4gKwkJcmV0dXJuIDE7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJZG93bl9yZWFk
KCZlc2VjLT5zZW0pOw0KPiA+ICsJcmMgPSBlbmNsYXZlX21wcm90ZWN0KCZlc2VjLT5yZWdpb25z
LCB2bWEtPnZtX3N0YXJ0LCB2bWEtPnZtX2VuZCwNCj4gPiArcHJvdCk7DQo+IA0KPiBXaHkgaXMg
aXQgc2FmZSBmb3IgdGhpcyB0byBvbmx5IHVzZSBkb3duX3JlYWQoKT8gZW5jbGF2ZV9tcHJvdGVj
dCgpIGNhbg0KPiBjYWxsIGVuY2xhdmVfcHJvdF9zZXRfY2IoKSB3aGljaCBtb2RpZmllcyB0aGUg
bGlzdD8NCg0KUHJvYmFibHkgYmVjYXVzZSBpdCB3YXMgdG9vIGxhdGUgYXQgbmlnaHQgd2hlbiBJ
IHdyb3RlIHRoaXMgbGluZTotKCBHb29kIGNhdGNoIQ0KDQo+IA0KPiBJIGhhdmVuJ3QgbG9va2Vk
IGF0IHRoaXMgY29kZSBjbG9zZWx5LCBidXQgaXQgZmVlbHMgbGlrZSBhIGxvdCBvZiBTR1gtDQo+
IHNwZWNpZmljIGxvZ2ljIGVtYmVkZGVkIGludG8gU0VMaW51eCB0aGF0IHdpbGwgaGF2ZSB0byBi
ZSByZXBlYXRlZCBvcg0KPiByZXVzZWQgZm9yIGV2ZXJ5IHNlY3VyaXR5IG1vZHVsZS4gIERvZXMg
U0dYIG5vdCB0cmFjayB0aGlzIHN0YXRlIGl0c2VsZj8NCg0KSSBjYW4gdGVsbCB5b3UgaGF2ZSBs
b29rZWQgcXVpdGUgY2xvc2VseSwgYW5kIEkgdHJ1bHkgdGhpbmsgeW91IGZvciB5b3VyIHRpbWUh
DQoNCllvdSBhcmUgcmlnaHQgdGhhdCB0aGVyZSBhcmUgU0dYIHNwZWNpZmljIHN0dWZmLiBNb3Jl
IHByZWNpc2VseSwgU0dYIGVuY2xhdmVzIGRvbid0IGhhdmUgYWNjZXNzIHRvIGFueXRoaW5nIGV4
Y2VwdCBtZW1vcnksIHNvIHRoZXJlIGFyZSBvbmx5IDMgcXVlc3Rpb25zIHRoYXQgbmVlZCB0byBi
ZSBhbnN3ZXJlZCBmb3IgZWFjaCBlbmNsYXZlIHBhZ2U6IDEpIHdoZXRoZXIgWCBpcyBhbGxvd2Vk
OyAyKSB3aGV0aGVyIFctPlggaXMgYWxsb3dlZCBhbmQgMyB3aGV0aGVyIFdYIGlzIGFsbG93ZWQu
IFRoaXMgcHJvcG9zYWwgdHJpZXMgdG8gY2FjaGUgdGhlIGFuc3dlcnMgdG8gdGhvc2UgcXVlc3Rp
b25zIHVwb24gY3JlYXRpb24gb2YgZWFjaCBlbmNsYXZlIHBhZ2UsIG1lYW5pbmcgaXQgaW52b2x2
ZXMgYSkgZmlndXJpbmcgb3V0IHRoZSBhbnN3ZXJzIGFuZCBiKSAicmVtZW1iZXIiIHRoZW0gZm9y
IGV2ZXJ5IHBhZ2UuICNiIGlzIGdlbmVyaWMsIG1vc3RseSBjYXB0dXJlZCBpbiBpbnRlbF9zZ3gu
YywgYW5kIGNvdWxkIGJlIHNoYXJlZCBhbW9uZyBhbGwgTFNNIG1vZHVsZXM7IHdoaWxlICNhIGlz
IFNFTGludXggc3BlY2lmaWMuIEkgY291bGQgbW92ZSBpbnRlbF9zZ3guYyB1cCBvbmUgbGV2ZWwg
aW4gdGhlIGRpcmVjdG9yeSBoaWVyYXJjaHkgaWYgdGhhdCdzIHdoYXQgeW91J2Qgc3VnZ2VzdC4N
Cg0KQnkgIlNHWCIsIGRpZCB5b3UgbWVhbiB0aGUgU0dYIHN1YnN5c3RlbSBiZWluZyB1cHN0cmVh
bWVkPyBJdCBkb2VzbuKAmXQgdHJhY2sgdGhhdCBzdGF0ZS4gSW4gcHJhY3RpY2UsIHRoZXJlJ3Mg
bm8gd2F5IGZvciBTR1ggdG8gdHJhY2sgaXQgYmVjYXVzZSB0aGVyZSdzIG5vIHZtX29wcy0+bWF5
X21wcm90ZWN0KCkgY2FsbGJhY2suIEl0IGRvZXNuJ3QgZm9sbG93IHRoZSBwaGlsb3NvcGh5IG9m
IExpbnV4IGVpdGhlciwgYXMgbXByb3RlY3QoKSBkb2Vzbid0IHRyYWNrIGl0IGZvciByZWd1bGFy
IG1lbW9yeS4gQW5kIGl0IGRvZXNuJ3QgaGF2ZSBhIHVzZSB3aXRob3V0IExTTSwgc28gSSBiZWxp
ZXZlIGl0IG1ha2VzIG1vcmUgc2Vuc2UgdG8gdHJhY2sgaXQgaW5zaWRlIExTTS4NCg==
