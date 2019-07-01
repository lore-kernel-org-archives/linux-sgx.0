Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F049AC06511
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 18:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D13332173E
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 18:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfGASOj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 14:14:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:32960 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGASOj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 14:14:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 11:14:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="168535334"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga006.jf.intel.com with ESMTP; 01 Jul 2019 11:14:37 -0700
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 11:14:36 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.198]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 11:14:36 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Stephen Smalley <stephen.smalley@gmail.com>
CC:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
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
Subject: RE: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Thread-Topic: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Thread-Index: AQHVJu2+BRxznwhIFUiQ7nhB61/EnaammGEAgAbDtgCAApYG8IABzxAA///bK+CAALuNgIADyHNQ
Date:   Mon, 1 Jul 2019 18:14:36 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D5D7@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F6551B824@ORSMSX116.amr.corp.intel.com>
 <99499d1a-56eb-60b0-596c-6d24e38d4757@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F6551C422@ORSMSX116.amr.corp.intel.com>
 <CAB9W1A1D=uDEdfSjS9DDNbThA1_HwATJN3=BcxZdXX5qMGHFrA@mail.gmail.com>
In-Reply-To: <CAB9W1A1D=uDEdfSjS9DDNbThA1_HwATJN3=BcxZdXX5qMGHFrA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzE1Y2MwODAtMzgyYS00OTIzLWEzNjAtZDVjZGU1ODE1NTE3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUmdaKzBmNlVNQXUyRlc4TXhUV2orRGVISStndDU2cWVsSmxoeXVTaHFLR3d2VEx0bStYcm1XWHE2QXU3WjF3SyJ9
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

PiBGcm9tOiBTdGVwaGVuIFNtYWxsZXkgW21haWx0bzpzdGVwaGVuLnNtYWxsZXlAZ21haWwuY29t
XQ0KPiBTZW50OiBGcmlkYXksIEp1bmUgMjgsIDIwMTkgNjoxNiBQTQ0KPiANCj4gT24gRnJpLCBK
dW4gMjgsIDIwMTkgYXQgNToyMCBQTSBYaW5nLCBDZWRyaWMgPGNlZHJpYy54aW5nQGludGVsLmNv
bT4NCj4gd3JvdGU6DQo+ID4NCj4gPiA+IEZyb206IGxpbnV4LXNneC1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgW21haWx0bzpsaW51eC1zZ3gtDQo+ID4gPiBvd25lckB2Z2VyLmtlcm5lbC5vcmddIE9u
IEJlaGFsZiBPZiBTdGVwaGVuIFNtYWxsZXkNCj4gPiA+IFNlbnQ6IEZyaWRheSwgSnVuZSAyOCwg
MjAxOSA5OjE3IEFNDQo+ID4gPg0KPiA+ID4gRldJVywgYWRkaW5nIG5ldyBwZXJtaXNzaW9ucyBv
bmx5IHJlcXVpcmVzIHVwZGF0aW5nIHBvbGljeQ0KPiA+ID4gY29uZmlndXJhdGlvbiwgbm90IHVz
ZXJzcGFjZSBjb2RlL3Rvb2xzLiAgQnV0IGluIGFueSBldmVudCwgd2UgY2FuDQo+ID4gPiByZXVz
ZSB0aGUgZXhlY3V0ZS0gcmVsYXRlZCBwZXJtaXNzaW9ucyBpZiBpdCBtYWtlcyBzZW5zZSBidXQg
c3RpbGwNCj4gPiA+IGNvbnNpZGVyIGludHJvZHVjaW5nIGFkZGl0aW9uYWwsIG5ldyBwZXJtaXNz
aW9ucywgcG9zc2libHkgaW4gYQ0KPiA+ID4gc2VwYXJhdGUgImVuY2xhdmUiIHNlY3VyaXR5IGNs
YXNzLCBpZiB3ZSB3YW50IGV4cGxpY2l0IGNvbnRyb2wgb3Zlcg0KPiBlbmNsYXZlIGxvYWRpbmcs
IGUuZy4NCj4gPiA+IEVOQ0xBVkVfX0xPQUQsIEVOQ0xBVkVfX0lOSVQsIGV0Yy4NCj4gPg0KPiA+
IEknbSBub3Qgc28gZmFtaWxpYXIgd2l0aCBTRUxpbnV4IHRvb2xzIHNvIG15IGFwb2xvZ3kgaW4g
YWR2YW5jZSBpZiBJDQo+IGVuZCB1cCBtaXhpbmcgdXAgdGhpbmdzLg0KPiA+DQo+ID4gSSdtIG5v
dCBvbmx5IHRhbGtpbmcgYWJvdXQgdGhlIG5ldyBwZXJtaXNzaW9ucywgYnV0IGFsc28gaG93IHRv
IGFwcGx5DQo+IHRoZW0gdG8gZW5jbGF2ZSBmaWxlcy4gSW50ZWwgU0dYIFNESyBwYWNrYWdlcyBl
bmNsYXZlcyBhcyAuc28gZmlsZXMsIGFuZA0KPiBJIGd1ZXNzIHRoYXQncyB0aGUgbW9zdCBzdHJh
aWdodCBmb3J3YXJkIHdheSB0aGF0IG1vc3Qgb3RoZXJzIHdvdWxkIGRvLg0KPiBTbyBpZiBkaWZm
ZXJlbnQgcGVybWlzc2lvbnMgYXJlIGRlZmluZWQsIHRoZW4gdXNlciBtb2RlIHRvb2xzIHdvdWxk
IGhhdmUNCj4gdG8gZGlzdGluZ3Vpc2ggZW5jbGF2ZXMgZnJvbSByZWd1bGFyIC5zbyBmaWxlcyBp
biBvcmRlciB0byBncmFudCB0aGVtDQo+IGRpZmZlcmVudCBwZXJtaXNzaW9ucy4gV291bGQgdGhh
dCBiZSBzb21ldGhpbmcgZXh0cmEgdG8gZXhpc3RpbmcgdG9vbHM/DQo+IA0KPiBJdCBkb2Vzbid0
IHJlcXVpcmUgYW55IHVzZXJzcGFjZSBjb2RlIGNoYW5nZXMuICBJdCBpcyBqdXN0IGEgbWF0dGVy
IG9mDQo+IGRlZmluaW5nIHNvbWUgY29uZmlndXJhdGlvbiBkYXRhIGluIHRoZSBwb2xpY3kgZm9y
IHRoZSBuZXcgcGVybWlzc2lvbnMsDQo+IG9uZSBvciBtb3JlIHNlY3VyaXR5IGxhYmVscyAodGFn
cykgZm9yIHRoZSBTR1ggLnNvIGZpbGVzLCBhbmQgcnVsZXMNCj4gYWxsb3dpbmcgYWNjZXNzIHdo
ZXJlIGRlc2lyZWQsIGFuZCB0aGVuIHNldHRpbmcgdGhvc2Ugc2VjdXJpdHkgbGFiZWxzIG9uDQo+
IHRoZSBTR1ggLnNvIGZpbGVzICh2aWEgdGhlIHNlY3VyaXR5LnNlbGludXggZXh0ZW5kZWQgYXR0
cmlidXRlIG9uIHRoZQ0KPiBmaWxlcykuICBFdmVuIHRoZSBsYXN0IHBhcnQgaXMgZ2VuZXJhbGx5
IGhhbmRsZWQgYnkgdXBkYXRpbmcgYQ0KPiBjb25maWd1cmF0aW9uIHNwZWNpZnlpbmcgaG93IGZp
bGVzIHNob3VsZCBiZSBsYWJlbGVkIGFuZCB0aGVuIHJwbQ0KPiBhdXRvbWF0aWNhbGx5IGxhYmVs
cyB0aGUgZmlsZXMgd2hlbiBjcmVhdGVkLCBvciB5b3UgY2FuIG1hbnVhbGx5DQo+IHJlc3RvcmVj
b24gdGhlbS4gSWYgdGhlIG5ldyBwZXJtaXNzaW9ucyBhcmUgZGVmaW5lZCBpbiB0aGVpciBvd24N
Cj4gc2VjdXJpdHkgY2xhc3MgcmF0aGVyIHRoYW4gcmV1c2luZyBleGlzdGluZyBvbmVzLCB0aGVu
IHRoZXkgY2FuIGV2ZW4gYmUNCj4gZGVmaW5lZCBlbnRpcmVseSB2aWEgYSBsb2NhbCBvciB0aGly
ZCBwYXJ0eSBwb2xpY3kgbW9kdWxlIHNlcGFyYXRlIGZyb20NCj4gdGhlIGRpc3RybyBwb2xpY3kg
aWYgZGVzaXJlZC9uZWVkZWQuDQoNCkknbSBub3Qgb2JqZWN0aW5nIHRvIHdoYXQgeW91IHByb3Bv
c2VkIGJ1dCBqdXN0IHRyeWluZyB0byB1bmRlcnN0YW5kIG1vcmUuDQoNClNHWCBlbmNsYXZlcyBk
b24ndCBsb29rIGFueSBkaWZmZXJlbnQgdGhhbiByZWd1bGFyIHNoYXJlZCBvYmplY3RzIGV4Y2Vw
dCB0aGUgbWV0YSBkYXRhIHNlY3Rpb24sIHdoaWNoIGlzIGltcGxlbWVudGF0aW9uIGRlcGVuZGVu
dCAoYWxsIGVuY2xhdmVzIGJ1aWx0IGJ5IEludGVsJ3MgU0RLIGhhdmUgLm5vdGUuc2d4bWV0YSBz
ZWN0aW9ucyBidXQgb3RoZXJzIGNvdWxkIGRvIHNvbWV0aGluZyBjb21wbGV0ZWx5IGRpZmZlcmVu
dCBhbmQgbWF5IG5vdCBldmVuIHVzZSBFTEYgc2VjdGlvbnMpLiBUaGVuIGhvdyBkb2VzIHJwbSB0
ZWxsIHdoZXRoZXIgYSAuc28gZmlsZSBpcyBhIHJlZ3VsYXIgc2hhcmVkIG9iamVjdCBvciBhbiBT
R1ggZW5jbGF2ZT8gTXkgdW5kZXJzdGFuZGluZyBpcywgcnBtIGhhcyB0byBiZSBhYmxlIHRvIGRp
c3Rpbmd1aXNoIHRob3NlIHR3byBpbiBvcmRlciB0byBsYWJlbCB0aGVtIGNvcnJlY3RseSAoZGlm
ZmVyZW50bHkpLiBBbSBJIGNvcnJlY3Q/IA0KDQo+IA0KPiA+DQo+ID4gPg0KPiA+ID4gT25lIHJl
c2lkdWFsIGNvbmNlcm4gSSBoYXZlIHdpdGggdGhlIHJldXNlIG9mIEZJTEVfX0VYRUNVVEUgaXMg
dXNpbmcNCj4gPiA+IGl0IGZvciB0aGUgc2lnc3RydWN0IGZpbGUgYXMgdGhlIGZhbGxiYWNrIGNh
c2UuICBJZiB0aGUgc2lnc3RydWN0IGlzDQo+ID4gPiBhbHdheXMgcGFydCBvZiB0aGUgc2FtZSBm
aWxlIGFzIHRoZSBjb2RlLCB0aGVuIGl0IHByb2JhYmx5IGRvZXNuJ3QNCj4gPiA+IG1hdHRlci4g
IEJ1dCBvdGhlcndpc2UsIGl0IGlzIHNvbWV3aGF0IG9kZCB0byBoYXZlIHRvIGFsbG93IHRoZSBo
b3N0DQo+ID4gPiBwcm9jZXNzIHRvIGV4ZWN1dGUgZnJvbSB0aGUgc2lnc3RydWN0IGZpbGUgaWYg
aXQgaXMgb25seSBkYXRhICh0aGUNCj4gc2lnbmF0dXJlKS4NCj4gPg0KPiA+IEkgYWdyZWUgd2l0
aCB5b3UuIEJ1dCBkbyB5b3UgdGhpbmsgaXQgYSBwcmFjdGljYWwgcHJvYmxlbSB0b2RheT8gQXMN
Cj4gZmFyIGFzIEkga25vdywgbm8gb25lIGlzIGRlcGxveWluZyBzaWdzdHJ1Y3RzIGluIGRlZGlj
YXRlZCBmaWxlcy4gSSdtDQo+IGp1c3QgdHJ5aW5nIHRvIHRvdWNoIGFzIGZldyB0aGluZ3MgYXMg
cG9zc2libGUgdW50aWwgdGhlcmUncyBkZWZpbml0ZWx5DQo+IGEgbmVlZCB0byBkbyBzby4NCj4g
DQo+IEkgZG9uJ3Qga25vdywgYW5kIGl0IHdhc24ndCBjbGVhciB0byBtZSBmcm9tIHRoZSBlYXJs
aWVyIGRpc2N1c3Npb25zLg0KPiBJZiBub3QgYW5kIGlmIGl0IGlzIGFjY2VwdGFibGUgdG8gcmVx
dWlyZSB0aGVtIHRvIGJlIGluIGZpbGVzIGluIHRoZQ0KPiBmaXJzdCBwbGFjZSwgdGhlbiBwZXJo
YXBzIGl0IGlzbid0IG5lY2Vzc2FyeS4NCg==
