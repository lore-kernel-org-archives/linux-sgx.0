Return-Path: <SRS0=YIp+=U3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAB2C5B577
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jun 2019 00:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBDF520B7C
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jun 2019 00:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfF1Ar6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 20:47:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:25349 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfF1Ar6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jun 2019 20:47:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 17:47:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,425,1557212400"; 
   d="scan'208";a="170603897"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jun 2019 17:47:56 -0700
Received: from orsmsx155.amr.corp.intel.com (10.22.240.21) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Jun 2019 17:47:55 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX155.amr.corp.intel.com ([169.254.7.237]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 17:47:55 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Casey Schaufler <casey@schaufler-ca.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>
CC:     "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "greg@enjellic.com" <greg@enjellic.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Topic: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Index: AQHVLG/L9SgvyZq9qEim/LcvveBd6KawhbyA//+RRaCAAIfxgP//kpmg
Date:   Fri, 28 Jun 2019 00:47:55 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551B975@ORSMSX116.amr.corp.intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <b08798a5-65f7-f96e-1c04-39dd0e60c114@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551B8D7@ORSMSX116.amr.corp.intel.com>
 <9f525db2-f46b-b4cb-c4e9-b9dbd18ed4d2@schaufler-ca.com>
In-Reply-To: <9f525db2-f46b-b4cb-c4e9-b9dbd18ed4d2@schaufler-ca.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzIwMTdkYmUtMDU0My00MjlkLTkwY2MtNmY5MGE3M2VkNjBjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSG5BdjNSMjhCanQ4ekhlazFNXC9qNFlKTFZtMnd3U2FOcjBSN3ZBSDNaZSt5Q0V3RTh5QmdPM3czZXJOVFZCUjAifQ==
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

PiBGcm9tOiBDYXNleSBTY2hhdWZsZXIgW21haWx0bzpjYXNleUBzY2hhdWZsZXItY2EuY29tXQ0K
PiBTZW50OiBUaHVyc2RheSwgSnVuZSAyNywgMjAxOSA0OjM3IFBNDQo+ID4+DQo+ID4+IFRoaXMg
Y29kZSBzaG91bGQgbm90IGJlIG1peGVkIGluIHdpdGggdGhlIExTTSBpbmZyYXN0cnVjdHVyZS4N
Cj4gPj4gSXQgc2hvdWxkIGFsbCBiZSBjb250YWluZWQgaW4gaXRzIG93biBtb2R1bGUsIHVuZGVy
IHNlY3VyaXR5L2VuY2xhdmUuDQo+ID4gbHNtX2VtYSBpcyAqaW50ZW5kZWQqIHRvIGJlIHBhcnQg
b2YgdGhlIExTTSBpbmZyYXN0cnVjdHVyZS4NCj4gDQo+IFRoYXQncyBub3QgZ29pbmcgdG8gZmx5
LCBub3QgZm9yIGEgbWludXRlLg0KDQpXaHkgbm90LCBpZiB0aGVyZSdzIGEgbmVlZCBmb3IgaXQ/
DQoNCkFuZCB3aGF0J3MgdGhlIGNvbmNlcm4gaGVyZSBpZiBpdCBiZWNvbWVzIHBhcnQgb2YgdGhl
IExTTSBpbmZyYXN0cnVjdHVyZS4NCg0KPiANCj4gPiAgSXQgaXMgZ29pbmcgdG8gYmUgc2hhcmVk
IGFtb25nIGFsbCBMU01zIHRoYXQgd291bGQgbGlrZSB0byB0cmFjaw0KPiBlbmNsYXZlIHBhZ2Vz
IGFuZCB0aGVpciBvcmlnaW5zLg0KPiANCj4gVGhhdCdzIHRydWUgZm9yIEluZmluaUJhbmQsIHR1
biBhbmQgc2N0cCBhcyB3ZWxsLiBMb29rIGF0IHRoZWlyDQo+IGltcGxlbWVudGF0aW9ucy4NCg0K
QXMgZmFyIGFzIEkgY2FuIHRlbGwsIEluZmluaUJhbmQsIHR1biBhbmQgc2N0cCwgYWxsIG9mIHRo
ZW0gc2VlbWVkIHVzZWQgaW5zaWRlIFNFTGludXggb25seS4NCg0KSWYgeW91IGhhZCBhIGNoYW5j
ZSB0byBsb29rIGF0IHYxIG9mIG15IHNlcmllcywgSSBzdGFydGVkIGJ5IGJ1cnlpbmcgZXZlcnl0
aGluZyBpbnNpZGUgU0VMaW51eCB0b28uIEJ1dCBTdGVwaGVuIHBvaW50ZWQgb3V0IHN1Y2ggdHJh
Y2tpbmcgd291bGQgYmUgbmVlZGVkIGJ5IGFsbCBMU01zIHNvIGNvZGUgZHVwbGljYXRpb24gbWln
aHQgYmUgYSBjb25jZXJuLiBUaHVzIEkgcmVzcG9uZGVkIGJ5IG1vdmluZyBpdCBpbnRvIExTTSBp
bmZyYXN0cnVjdHVyZS4NCg0KPiANCj4gPiBBbmQgdGhleSBjb3VsZCBiZSBleHRlbmRlZCB0byBz
dG9yZSBtb3JlIGluZm9ybWF0aW9uIGFzIGRlZW1lZA0KPiBhcHByb3ByaWF0ZSBieSB0aGUgTFNN
IG1vZHVsZS4NCj4gDQo+IFdoaWNoIGlzIHdoYXQgYmxvYnMgYXJlIGZvciwgYnV0IHRoYXQgZG9l
cyBub3QgYXBwZWFyIHRvIGJlIGhvdw0KPiB5b3UncmUgdXNpbmcgZWl0aGVyIHRoZSBmaWxlIGJs
b2Igb3IgeW91ciBuZXcgZW1hIGJsb2IuDQoNCkEgbHNtX2VtYV9tYXAgcG9pbnRlciBpcyBzdG9y
ZWQgaW4gZmlsZS0+Zl9zZWN1cml0eS4gRWFjaCBsc21fZW1hX21hcCBjb250YWlucyBhIGxpc3Qg
b2YgbHNtX2VtYSBzdHJ1Y3R1cmVzLiBJbiBteSBsYXN0IHBhdGNoLCBTRUxpbnV4IHN0b3JlcyBh
IGVtYV9zZWN1cml0eV9zdHJ1Y3Qgd2l0aCBldmVyeSBlbWEsIGJ5IHNldHRpbmcgc2VsaW51eF9i
bG9iX3NpemVzLmxic19lbWFfZGF0YSB0byBzaXplb2YoZW1hX3NlY3VyaXR5X3N0cnVjdCkuDQoN
CmVtYV9zZWN1cml0eV9zdHJ1Y3QgaXMgaW5pdGlhbGl6ZWQgaW4gc2VsaW51eF9lbmNsYXZlX2xv
YWQoKSwgYW5kIGNoZWNrZWQgaW4gZW5jbGF2ZV9tcHJvdGVjdCgpLCB3aGljaCBpcyBhIHN1YnJv
dXRpbmUgb2Ygc2VsaW51eF9maWxlX21wcm90ZWN0KCkuIEJUVywgaXQgaXMgYWxsb2NlZC9mcmVl
ZCBhdXRvbWF0aWNhbGx5IGJ5IExTTSBpbmZyYXN0cnVjdHVyZSBpbiBzZWN1cml0eV9lbmNsYXZl
X2xvYWQoKS9zZWN1cml0eV9maWxlX2ZyZWUoKS4NCg0KPiANCj4gPiAgVGhlIGxhc3QgcGF0Y2gg
b2YgdGhpcyBzZXJpZXMgc2hvd3MgaG93IHRvIGV4dGVuZCBFTUEgaW5zaWRlIFNFTGludXguDQo+
IA0KPiBJIGRvbid0IHNlZSAoYnV0IEkgYWRtaXQgdGhlIGNvZGUgZG9lc24ndCBtYWtlIGEgbG90
IG9mIHNlbnNlIHRvIG1lKQ0KPiBhbnl0aGluZyB5b3UgY291bGRuJ3QgZG8gaW4gdGhlIFNFTGlu
dXggY29kZSBieSBhZGRpbmcgZGF0YSB0byB0aGUNCj4gZmlsZSBibG9iLiBUaGUgZGF0YSB5b3Un
cmUgYWRkaW5nIHRvIHRoZSBMU00gaW5mcmFzdHJ1Y3R1cmUgZG9lc24ndA0KPiBiZWxvbmcgdGhl
cmUsIGFuZCBpdCBkb2Vzbid0IG5lZWQgdG8gYmUgdGhlcmUuDQoNCllvdSBhcmUgY29ycmVjdC4g
TXkgdjEgZGlkIGl0IGluc2lkZSBTRUxpbnV4Lg0KDQpUaGUga2V5IHF1ZXN0aW9uIEkgdGhpbmsg
aXMgd2hldGhlciBvbmx5IFNFTGludXggbmVlZHMgaXQsIG9yIGFsbCBMU01zIG5lZWQgaXQuIFN0
ZXBoZW4gdGhvdWdodCBpdCB3YXMgdGhlIGxhdHRlciAoYW5kIEkgYWdyZWUgd2l0aCBoaW0pIHNv
IEkgbW92ZWQgaXQgaW50byB0aGUgTFNNIGluZnJhc3RydWN0dXJlIHRvIGJlIHNoYXJlZCwganVz
dCBsaWtlIHRoZSBhdWRpdGluZyBjb2RlLg0KDQo+ID4+IE5vdCBhY2NlcHRhYmxlIGZvciB0aGUg
TFNNIGluZnJhc3RydWN0dXJlLiBUaGV5DQo+ID4+IGFyZSBpbmNvbnNpc3RlbnQgd2l0aCB0aGUg
d2F5IGRhdGEgaXMgdXNlZCB0aGVyZS4NCj4gPiBJJ20gbm90IHN1cmUgSSB1bmRlcnN0YW5kIHRo
aXMgY29tbWVudC4NCj4gDQo+IEl0IG1lYW5zIHRoYXQgeW91ciBkZWZpbml0aW9uIGFuZCB1c2Ug
b2YgdGhlIGxzbV9lbWFfYmxvYg0KPiBkb2VzIG5vdCBtYXRjaCB0aGUgd2F5IG90aGVyIGJsb2Jz
IGFyZSBtYW5hZ2VkIGFuZCB1c2VkLg0KPiBUaGUgTFNNIGluZnJhc3RydWN0dXJlIHVzZXMgdGhl
c2UgZW50cmllcyBpbiBhIHZlcnkgcGFydGljdWxhcg0KPiB3YXksIGFuZCB5b3UncmUgdHJ5aW5n
IHRvIHVzZSBpdCBkaWZmZXJlbnRseS4gWW91ciBtaWdodCBiZQ0KPiBhYmxlIHRvIGNoYW5nZSB0
aGUgcmVzdCBvZiB0aGUgZW5jbGF2ZSBzeXN0ZW0gdG8gdXNlIGl0DQo+IGNvcnJlY3RseSwgb3Ig
eW91IG1pZ2h0IGJlIGFibGUgdG8gZmluZCBhIGRpZmZlcmVudCBwbGFjZQ0KPiBmb3IgaXQuDQoN
CkknbSBzdGlsbCBub3Qgc3VyZSB3aHkgeW91IHRoaW5rIHRoaXMgKGxic19lbWFfZGF0YSkgaXMg
aW5jb25zaXN0ZW50IHdpdGggb3RoZXIgYmxvYnMuIA0KDQpTYW1lIGFzIGFsbCBvdGhlciBibG9i
cywgYW4gTFNNIHJlcXVlc3RzIGl0IGJ5IHN0b3JpbmcgdGhlIG5lZWRlZCBzaXplIGluIGl0LCBh
bmQgaXMgYXNzaWduZWQgYW4gb2Zmc2V0LCBhbmQgdGhlIGJ1ZmZlciBpcyBhbGxvY2F0ZWQvZnJl
ZWQgYnkgdGhlIGluZnJhc3RydWN0dXJlLiBBbSBJIG1pc3NpbmcgYW55dGhpbmc/DQoNCj4gPg0K
PiA+IEFzIEkgc3RhdGVkIGluIHRoZSBjb3ZlciBsZXR0ZXIsIHRoZSBwcmltYXJ5IHF1ZXN0aW9u
IGlzIGhvdyB0bw0KPiBwcmV2ZW50IFNHWCBmcm9tIGJlaW5nIGFidXNlZCBhcyBhIGJhY2tkb29y
IHRvIG1ha2UgZXhlY3V0YWJsZSBwYWdlcw0KPiB0aGF0IHdvdWxkIG90aGVyd2lzZSBub3QgYmUg
ZXhlY3V0YWJsZSB3aXRob3V0IFNHWC4gQW55IExTTSBtb2R1bGUNCj4gdW5hd2FyZSBvZiB0aGF0
IHdvdWxkIGxlYXZlIHRoYXQgImhvbGUiIG9wZW4uIFNvIHRyYWNraW5nIGVuY2xhdmUgcGFnZXMN
Cj4gd2lsbCBiZWNvbWUgYSBjb21tb24gdGFzayBmb3IgYWxsIExTTXMgdGhhdCBjYXJlIHBhZ2Ug
cHJvdGVjdGlvbnMsIGFuZA0KPiB0aGF0J3Mgd2h5IEkgcGxhY2UgaXQgaW5zaWRlIExTTSBpbmZy
YXN0cnVjdHVyZS4NCj4gDQo+IFBhZ2UgcHJvdGVjdGlvbnMgYXJlIGFuIGltcG9ydGFudCBwYXJ0
IG9mIG1hbnkgc2VjdXJpdHkgZmVhdHVyZXMsDQo+IGJ1dCB0aGF0J3MgYmVzaWRlIHRoZSBwb2lu
dC4gVGhlIExTTSBzeXN0ZW0gcHJvdmlkZXMgbWVjaGFuaXNtIGZvcg0KPiBwcm92aWRpbmcgYWRk
aXRpb25hbCByZXN0cmljdGlvbnMgdG8gZXhpc3Rpbmcgc2VjdXJpdHkgbWVjaGFuaXNtcy4NCj4g
Rmlyc3QsIHlvdSBjcmVhdGUgdGhlIHNlY3VyaXR5IG1lY2hhbmlzbSAoZS5nLiBlbmNsYXZlcykg
dGhlbiB5b3UNCj4gYWRkIExTTSBob29rcyBzbyB0aGF0IHNlY3VyaXR5IG1vZHVsZXMgKGUuZy4g
U0VMaW51eCkgY2FuIGFwcGx5DQo+IHRoZWlyIG93biBwb2xpY2llcyBpbiBhZGRpdGlvbi4gSW4g
c3VwcG9ydCBvZiB0aGlzLCB0aGUgTFNNIGJsb2INCj4gbWVjaGFuaXNtIGFsbG93cyBzZWN1cml0
eSBtb2R1bGVzIHRvIG1haW50YWluIHRoZWlyIG93biBpbmZvcm1hdGlvbg0KPiBhYm91dCB0aGUg
c3lzdGVtIGNvbXBvbmVudHMgKGUuZy4gZmlsZSwgaW5vZGUsIGNyZWQsIHRhc2spIHRoZXkNCj4g
Y2FyZSBhYm91dC4gVGhlIExTTSBpbmZyYXN0cnVjdHVyZSBkb2VzIG5vdCBpdHNlbGYgcHJvdmlk
ZSBvcg0KPiBzdXBwb3J0IHNlY3VyaXR5IGRhdGEgb3IgcG9saWN5LiBUaGF0J3Mgc3RyaWN0bHkg
Zm9yIHRoZSBtb2R1bGVzDQo+IHRvIGRvLg0KDQpBZ3JlZWQhDQoNCkVNQSBkb2Vzbid0IGRpY3Rh
dGUgcG9saWNpZXMgZm9yIHN1cmUuIElzIGl0IGNvbnNpZGVyZWQgInNlY3VyaXR5IGRhdGEiPyBJ
J20gbm90IHN1cmUgdGhlIGRlZmluaXRpb24gb2YgInNlY3VyaXR5IGRhdGEiIGhlcmUuIEl0IGRv
ZXMgc3RvcmUgc29tZSAiZGF0YSIsIHNvbWV0aGluZyB0aGF0IG11bHRpcGxlIExTTSBtb2R1bGVz
IHdvdWxkIG5lZWQgdG8gZHVwbGljYXRlIGlmIG5vdCBwdWxsZWQgaW50byBhIGNvbW1vbiBwbGFj
ZS4gSXQgaXMgbWVhbnQgdG8gYmUgYSAiaGVscGVyIiBkYXRhIHN0cnVjdHVyZSwganVzdCBsaWtl
IHRoZSBhdWRpdGluZyBjb2RlLg0K
