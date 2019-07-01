Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B178C0650E
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 18:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6C1821721
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 18:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfGASbT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 14:31:19 -0400
Received: from mga18.intel.com ([134.134.136.126]:37449 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGASbT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 14:31:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 11:31:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="174304076"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga002.jf.intel.com with ESMTP; 01 Jul 2019 11:31:18 -0700
Received: from orsmsx121.amr.corp.intel.com (10.22.225.226) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 11:31:18 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX121.amr.corp.intel.com ([169.254.10.250]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 11:31:18 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Topic: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Index: AQHVLG/L9SgvyZq9qEim/LcvveBd6KazxkIAgAI8SeCAAIcaAP//kNKQ
Date:   Mon, 1 Jul 2019 18:31:17 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D5FA@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <CALCETrWQUEEwAAdPrVQMengKDhX3-fVrtJwaP2i=mWD+s+B8vg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D4B3@ORSMSX116.amr.corp.intel.com>
 <CALCETrUR=W3rfmG+qHydm0FQvASSYRt_V72v5WeQ4KWT7tjEdA@mail.gmail.com>
In-Reply-To: <CALCETrUR=W3rfmG+qHydm0FQvASSYRt_V72v5WeQ4KWT7tjEdA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDgwODljYWQtM2ExYi00OGVlLWE0MjYtY2UwZmViN2E4NmEzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiV2Fic0JGZmp0alMyUGY0QWcwUVU1SmxxNmM3VWt5c2RDVVUzdkI4S1JnSStsKzdjRUo4eXc1SThBZkd4S21MWCJ9
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

PiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5vcmddDQo+IFNlbnQ6
IE1vbmRheSwgSnVseSAwMSwgMjAxOSAxMDo1OCBBTQ0KPiANCj4gT24gTW9uLCBKdWwgMSwgMjAx
OSBhdCAxMDoxMSBBTSBYaW5nLCBDZWRyaWMgPGNlZHJpYy54aW5nQGludGVsLmNvbT4NCj4gd3Jv
dGU6DQo+ID4NCj4gPiBIaSBBbmR5LA0KPiA+DQo+ID4gPiBGcm9tOiBBbmR5IEx1dG9taXJza2kg
W21haWx0bzpsdXRvQGtlcm5lbC5vcmddDQo+ID4gPiBTZW50OiBTYXR1cmRheSwgSnVuZSAyOSwg
MjAxOSA0OjQ3IFBNDQo+ID4gPg0KPiA+ID4gSnVzdCBvbiBhIHZlcnkgY3Vyc29yeSByZXZpZXcs
IHRoaXMgc2VlbXMgbGlrZSBpdCdzIGNyZWF0aW5nIGEgYnVuY2gNCj4gPiA+IG9mIGNvbXBsZXhp
dHkgKGEgd2hvbGUgbmV3IGxpYnJhcnkgYW5kIGRhdGEgc3RydWN0dXJlKSwgYW5kIEknbSBub3QN
Cj4gPiA+IGNvbnZpbmNlZCB0aGUgcmVzdWx0IGlzIGFueSBiZXR0ZXIgdGhhbiBTZWFuJ3MgdmVy
c2lvbi4NCj4gPg0KPiA+IFRoZSBuZXcgRU1BIGRhdGEgc3RydWN0dXJlIGlzIHRvIHRyYWNrIGVu
Y2xhdmUgcGFnZXMgYnkgcmFuZ2UuIFllcywNCj4gU2VhbiBhdm9pZGVkIHRoYXQgYnkgc3Rvcmlu
ZyBzaW1pbGFyIGluZm9ybWF0aW9uIGluIHRoZSBleGlzdGluZw0KPiBlbmNsX3BhZ2Ugc3RydWN0
dXJlIGluc2lkZSBTR1ggc3Vic3lzdGVtLiBCdXQgYXMgSSBwb2ludGVkIG91dCwgaGlzIGNvZGUN
Cj4gaGFzIHRvIGl0ZXJhdGUgdGhyb3VnaCAqZXZlcnkqIHBhZ2UgaW4gcmFuZ2Ugc28gbXByb3Rl
Y3QoKSB3aWxsIGJlIHZlcnkNCj4gc2xvdyBpZiB0aGUgcmFuZ2UgaXMgbGFyZ2UuIFNvIGhlIHdv
dWxkIGVuZCB1cCBpbnRyb2R1Y2luZyBzb21ldGhpbmcNCj4gc2ltaWxhciB0byBhY2hpZXZlIHRo
ZSBzYW1lIHBlcmZvcm1hbmNlLg0KPiANCj4gSXQgc2VlbXMgb2RkIHRvIHN0aWNrIGl0IGluIHNl
Y3VyaXR5LyBpZiBpdCBvbmx5IGhhcyBvbmUgdXNlciwgdGhvdWdoLg0KPiBBbHNvLCBpZiBpdCB3
YXNuJ3QgaW4gc2VjdXJpdHkvLCB0aGVuIHRoZSBzZWN1cml0eSBmb2xrcyB3b3VsZCBzdG9wDQo+
IGNvbXBsYWluaW5nIDopDQoNClRoYXQncyB3aGVyZSBJIHN0YXJ0ZWQuIEVNQSAodGhvdWdoIG5h
bWVkIGRpZmZlcmVudGx5IGluIG15IHYxKSB3YXMgYnVyaWVkIGluc2lkZSBhbmQgdXNlZCBvbmx5
IGJ5IFNFTGludXguIEJ1dCBTdGVwaGVuIHRob3VnaHQgaXQgdXNlZnVsIGZvciBvdGhlciBMU01z
IGFzIHdlbGwsIGFzIGl0IGNvdWxkIGJlIGV4cGVjdGVkIHRoYXQgb3RoZXIgTFNNcyB3b3VsZCBh
bHNvIG5lZWQgdG8gdHJhY2sgZW5jbGF2ZSBwYWdlcyBhbmQgZW5kIHVwIGR1cGxpY2F0aW5nIHdo
YXQncyBkb25lIGluc2lkZSBTRUxpbnV4LiANCg0KSSdtIG9rIGVpdGhlciB3YXksIHRob3VnaCBJ
IGRvIGFncmVlIHdpdGggU3RlcGhlbidzIGFzc2Vzc21lbnQuDQoNCj4gDQo+IA0KPiA+DQo+ID4g
QW5kIHRoYXQncyBub3QgdGhlIG1vc3QgaW1wb3J0YW50IHBvaW50LiBUaGUgbWFqb3IgcHJvYmxl
bSBpbiBoaXMNCj4gcGF0Y2ggbGllcyBpbiBTR1gyIHN1cHBvcnQsIGFzICNQRiBkcml2ZW4gRUFV
RyBjYW5ub3QgYmUgc3VwcG9ydGVkIChvcg0KPiBoZSdkIGhhdmUgdG8gYW1lbmQgaGlzIGNvZGUg
YWNjb3JkaW5nbHksIHdoaWNoIHdpbGwgYWRkIGNvbXBsZXhpdHkgYW5kDQo+IHRpcCB5b3VyIHNj
YWxlKS4NCj4gPg0KPiANCj4gV2h5IGNhbid0IGl0IGJlPw0KDQpMZXQgbWUgdGFrZSBpdCBiYWNr
LiBJdCdzIGltcG9ydGFudCBhcyBpdCBpcyB3aGVyZSBMU00gZm9sa3MgYXJlIGRpdmlkZWQuIA0K
DQpJIGludGVuZGVkIHRvIHNheSB0aGUgbWFqb3IgcmVhc29uIEkgb2JqZWN0ZWQgU2VhbidzIGFw
cHJvYWNoIHdhcyBpdHMgaW5hYmlsaXR5IHRvIHN1cHBvcnQgU0dYMiBzbW9vdGhseSAtIGFzICNQ
RiBkcml2ZW4gRUFVRyByZXF1aXJlcyBub24tZXhpc3RlbnQgcGFnZXMgdG8gYmUgbW1hcCgpJ2Vk
LCBvdGhlcndpc2Ugdm1fb3BzLT5mYXVsdCB3b3VsZG4ndCBiZSBkaXNwYXRjaGVkIHNvIEVBVUcg
Y291bGRuJ3QgYmUgaXNzdWVkIGluIHJlc3BvbnNlIHRvICNQRi4gDQo=
