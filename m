Return-Path: <SRS0=YIp+=U3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487EEC4321A
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jun 2019 21:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C53C20828
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jun 2019 21:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfF1Vxu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jun 2019 17:53:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:32186 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfF1Vxu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 28 Jun 2019 17:53:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 14:53:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="189586393"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jun 2019 14:53:48 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX104.amr.corp.intel.com ([169.254.4.70]) with mapi id 14.03.0439.000;
 Fri, 28 Jun 2019 14:53:47 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>
CC:     "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "greg@enjellic.com" <greg@enjellic.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Topic: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Index: AQHVLG/L9SgvyZq9qEim/LcvveBd6Kaxu+6A///ZupA=
Date:   Fri, 28 Jun 2019 21:53:46 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551C45F@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <f36415e6-5a69-b1b9-74b6-87a9af4508d3@tycho.nsa.gov>
In-Reply-To: <f36415e6-5a69-b1b9-74b6-87a9af4508d3@tycho.nsa.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjE1NDhmY2UtMjdkYi00NTI5LWIyMzgtODBiM2ViZTliM2IyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUTJDV3RVY2dsMmRnXC9mbWt3M0diQ3pjdXdGOXNtb1wvamJHdmNnMWZvMklrUWFPQjlqNktVR1Ruc1pyWkYzSCtEIn0=
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
Cj4gU2VudDogRnJpZGF5LCBKdW5lIDI4LCAyMDE5IDk6MzcgQU0NCj4gDQo+ID4gbHNtLmVtYS5j
YWNoZV9kZWNpc2lvbnMgaXMgb24gYnkgZGVmYXVsdCBhbmQNCj4gPiBjb3VsZCBiZSB0dXJuZWQg
b2ZmIGJ5IGFwcGVuZGluZyDigJxsc20uZW1hLmNhY2hlX2RlY2lzaW9ucz0w4oCdIG9yDQo+ID4g
4oCcbHNtLmVtYS5jYWNoZV9kZWNpc2lvbnM9b2Zm4oCdIHRvIHRoZSBrZXJuZWwgY29tbWFuZCBs
aW5lLg0KPiANCj4gVGhpcyBzZWVtcyBwcm9ibGVtYXRpYyBvbiBhIGZldyBmcm9udHM6DQo+IA0K
PiAtIFNwZWNpZnlpbmcgaXQgYXMgYSBib290IHBhcmFtZXRlciByZXF1aXJlcyB0ZWFjaGluZyBh
ZG1pbnMgLyBwb2xpY3kNCj4gZGV2ZWxvcGVycyB0byBkbyBzb21ldGhpbmcgaW4gYWRkaXRpb24g
dG8gd2hhdCB0aGV5IGFyZSBhbHJlYWR5IGRvaW5nDQo+IHdoZW4gdGhleSB3YW50IHRvIGNyZWF0
ZSBwb2xpY3ksDQo+IA0KPiAtIExpbWl0aW5nIGl0IHRvIGEgYm9vdCBwYXJhbWV0ZXIgcmVxdWly
ZXMgYSByZWJvb3QgdG8gY2hhbmdlIHRoZSBtb2RlDQo+IG9mIG9wZXJhdGlvbiwgd2hlcmVhcyBT
RUxpbnV4IG9mZmVycyBydW50aW1lIHRvZ2dsaW5nIG9mIHBlcm1pc3NpdmUgbW9kZQ0KPiBhbmQg
ZXZlbiBwZXItcHJvY2VzcyAoZG9tYWluKSBwZXJtaXNzaXZlIG1vZGUgKGFuZCBzbyBkb2VzIEFw
cEFybW9yKSwNCg0KSG93IGFib3V0IG1ha2luZyBhIHZhcmlhYmxlIHR1bmFibGUgdmlhIHN5c2N0
bD8NCg0KPiANCj4gLSBJbiB0aGUgY2FjaGVfZGVjaXNpb25zPTEgY2FzZSwgZG8gd2UgZ2V0IGFu
eSBhdWRpdGluZyBhdCBhbGw/ICBJZiBub3QsDQo+IHRoYXQncyBhIHByb2JsZW0uICBXZSB3YW50
IGF1ZGl0aW5nIG5vdCBvbmx5IHdoZW4gd2UgYXJlDQo+IGdlbmVyYXRpbmcvbGVhcm5pbmcgcG9s
aWN5IGJ1dCBhbHNvIGluIG9wZXJhdGlvbi4NCg0KQ3VycmVudGx5IGl0IGRvZXNuJ3QgZ2VuZXJh
dGUgYXVkaXQgbG9nLCBidXQgSSBjb3VsZCBhZGQgaXQsIGV4Y2VwdCBpdCBjb3VsZG4ndCBwb2lu
dCB0byB0aGUgZXhhY3QgZmlsZS4gQnV0IEkgY2FuIHVzZSB0aGUgc2lnc3RydWN0IGZpbGUgaW5z
dGVhZCBzbyBhZG1pbmlzdHJhdG9ycyBjYW4gYXQgbGVhc3QgdGVsbCB3aGljaCBlbmNsYXZlIHZp
b2xhdGVzIHRoZSBwb2xpY3kuIERvIHlvdSB0aGluayBpdCBhY2NlcHRhYmxlPw0KDQo+IA0KPiAt
IFRoZXJlIGlzIHRoZSBwb3RlbnRpYWwgZm9yIGluY29uc2lzdGVuY2llcyB0byBhcmlzZSBiZXR3
ZWVuIHRoZQ0KPiBlbmZvcmNlbWVudCBhcHBsaWVkIHdpdGggZGlmZmVyZW50IGNhY2hlX2RlY2lz
aW9ucyB2YWx1ZXMuDQoNClRoZSBlbmZvcmNlbWVudCB3aWxsIGJlIGNvbnNpc3RlbnQuIFRoZSBk
aWZmZXJlbmNlIG9ubHkgbGllcyBpbiB0aGUgbG9ncy4NCg0KPiANCj4gSSB3b3VsZCBzdWdnZXN0
IHRoYXQgd2UganVzdCBuZXZlciBjYWNoZSB0aGUgZGVjaXNpb24gYW5kIGFjY2VwdCB0aGUNCj4g
Y29zdCBpZiB3ZSBhcmUgZ29pbmcgdG8gdGFrZSB0aGlzIGFwcHJvYWNoLg0KDQpUaGlzIHdpbGwg
YWxzbyBiZSBhIHZpYWJsZSBvcHRpb24uIEkgZG9uJ3QgdGhpbmsgYW55IGVuY2xhdmVzIHdvdWxk
IGJlIGNvbXByaXNlZCBvZiBhIGxhcmdlIG51bWJlciBvZiBmaWxlcyBhbnl3YXkuIFdoZW4gU0dY
MiBjb21lcyB1cCwgSSB0aGluayBtb3N0IGVuY2xhdmVzIHdpbGwgYmUgaW5zdGFudGlhdGVkIGZy
b20gb25seSBvbmUgZmlsZSBhbmQgZGVmZXIgbG9hZGluZyBsaWJyYXJpZXMgYXQgcnVudGltZS4g
U28gaW4gcHJhY3RpY2Ugd2UgYXJlIGxvb2tpbmcgdG8ga2VlcGluZyBvbmx5IG9uZSBmaWxlIG9w
ZW4gcGVyIGVuY2xhdmUsIHdoaWNoIHNlZW1zIHRvdGFsbHkgYWNjZXB0YWJsZS4NCg0KU3RlcGhl
biAoYW5kIGV2ZXJ5b25lIGhhdmluZyBhbiBvcGluaW9uIG9uIHRoaXMpLCB3aGljaCB3YXkgZG8g
eW91IHByZWZlcj8gc3lzY3RsIHZhcmlhYmxlPyBPciBuZXZlciBjYWNoZSBkZWNpc2lvbnM/DQo=
