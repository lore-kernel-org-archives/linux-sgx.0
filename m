Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79D4C4646D
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 18:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF05B2184B
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 18:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfGASCE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 14:02:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:19565 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbfGASCD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 14:02:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 11:02:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="190333453"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga002.fm.intel.com with ESMTP; 01 Jul 2019 11:02:02 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 11:02:02 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.71]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 11:02:02 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Stephen Smalley <stephen.smalley@gmail.com>
CC:     Stephen Smalley <sds@tycho.nsa.gov>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "greg@enjellic.com" <greg@enjellic.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Topic: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Index: AQHVLG/L9SgvyZq9qEim/LcvveBd6Kaxu+6A///ZupCAALjwgIADxYuw
Date:   Mon, 1 Jul 2019 18:02:01 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D5AD@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <f36415e6-5a69-b1b9-74b6-87a9af4508d3@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F6551C45F@ORSMSX116.amr.corp.intel.com>
 <CAB9W1A3Xusf77LZ44HjNYuuFPHv=vditqJZLu6yrStFG3OwHXQ@mail.gmail.com>
In-Reply-To: <CAB9W1A3Xusf77LZ44HjNYuuFPHv=vditqJZLu6yrStFG3OwHXQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTg1YjkzZjItNTlhNC00MzQwLTkxNjctOTU5NTFlZDc0NmVhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZnNJa2hDa2JTMW40ekdTdzl5YXdsSGNzZFh1ZklCRDdldlAwQWN1a3pDM0VsWFFtYTZWQ3RNUnRRYnlyWjF6SCJ9
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
XQ0KPiBTZW50OiBGcmlkYXksIEp1bmUgMjgsIDIwMTkgNjoyMiBQTQ0KPiANCj4gT24gRnJpLCBK
dW4gMjgsIDIwMTkgYXQgNTo1NCBQTSBYaW5nLCBDZWRyaWMgPGNlZHJpYy54aW5nQGludGVsLmNv
bT4NCj4gd3JvdGU6DQo+ID4NCj4gPiA+IEZyb206IGxpbnV4LXNneC1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgW21haWx0bzpsaW51eC1zZ3gtDQo+ID4gPiBvd25lckB2Z2VyLmtlcm5lbC5vcmddIE9u
IEJlaGFsZiBPZiBTdGVwaGVuIFNtYWxsZXkNCj4gPiA+IFNlbnQ6IEZyaWRheSwgSnVuZSAyOCwg
MjAxOSA5OjM3IEFNDQo+ID4gPg0KPiA+ID4gPiBsc20uZW1hLmNhY2hlX2RlY2lzaW9ucyBpcyBv
biBieSBkZWZhdWx0IGFuZCBjb3VsZCBiZSB0dXJuZWQgb2ZmDQo+ID4gPiA+IGJ5IGFwcGVuZGlu
ZyDigJxsc20uZW1hLmNhY2hlX2RlY2lzaW9ucz0w4oCdIG9yDQo+ID4gPiA+IOKAnGxzbS5lbWEu
Y2FjaGVfZGVjaXNpb25zPW9mZuKAnSB0byB0aGUga2VybmVsIGNvbW1hbmQgbGluZS4NCj4gPiA+
DQo+ID4gPiBUaGlzIHNlZW1zIHByb2JsZW1hdGljIG9uIGEgZmV3IGZyb250czoNCj4gPiA+DQo+
ID4gPiAtIFNwZWNpZnlpbmcgaXQgYXMgYSBib290IHBhcmFtZXRlciByZXF1aXJlcyB0ZWFjaGlu
ZyBhZG1pbnMgLw0KPiA+ID4gcG9saWN5IGRldmVsb3BlcnMgdG8gZG8gc29tZXRoaW5nIGluIGFk
ZGl0aW9uIHRvIHdoYXQgdGhleSBhcmUNCj4gPiA+IGFscmVhZHkgZG9pbmcgd2hlbiB0aGV5IHdh
bnQgdG8gY3JlYXRlIHBvbGljeSwNCj4gPiA+DQo+ID4gPiAtIExpbWl0aW5nIGl0IHRvIGEgYm9v
dCBwYXJhbWV0ZXIgcmVxdWlyZXMgYSByZWJvb3QgdG8gY2hhbmdlIHRoZQ0KPiA+ID4gbW9kZSBv
ZiBvcGVyYXRpb24sIHdoZXJlYXMgU0VMaW51eCBvZmZlcnMgcnVudGltZSB0b2dnbGluZyBvZg0K
PiA+ID4gcGVybWlzc2l2ZSBtb2RlIGFuZCBldmVuIHBlci1wcm9jZXNzIChkb21haW4pIHBlcm1p
c3NpdmUgbW9kZSAoYW5kDQo+ID4gPiBzbyBkb2VzIEFwcEFybW9yKSwNCj4gPg0KPiA+IEhvdyBh
Ym91dCBtYWtpbmcgYSB2YXJpYWJsZSB0dW5hYmxlIHZpYSBzeXNjdGw/DQo+IA0KPiBCZXR0ZXIg
dGhhbiBhIGJvb3QgcGFyYW1ldGVyIGJ1dCBzdGlsbCBub3QgYW1lbmFibGUgdG8gcGVyLWRvbWFp
bg0KPiBwZXJtaXNzaXZlIGFuZCBzdGlsbCByZXF1aXJlcyBhZG1pbnMgdG8gcmVtZW1iZXIgYW5k
IHBlcmZvcm0gYW4gZXh0cmENCj4gc3RlcCBiZWZvcmUgY29sbGVjdGluZyBkZW5pYWxzLg0KPiAN
Cj4gPg0KPiA+ID4NCj4gPiA+IC0gSW4gdGhlIGNhY2hlX2RlY2lzaW9ucz0xIGNhc2UsIGRvIHdl
IGdldCBhbnkgYXVkaXRpbmcgYXQgYWxsPyAgSWYNCj4gPiA+IG5vdCwgdGhhdCdzIGEgcHJvYmxl
bS4gIFdlIHdhbnQgYXVkaXRpbmcgbm90IG9ubHkgd2hlbiB3ZSBhcmUNCj4gPiA+IGdlbmVyYXRp
bmcvbGVhcm5pbmcgcG9saWN5IGJ1dCBhbHNvIGluIG9wZXJhdGlvbi4NCj4gPg0KPiA+IEN1cnJl
bnRseSBpdCBkb2Vzbid0IGdlbmVyYXRlIGF1ZGl0IGxvZywgYnV0IEkgY291bGQgYWRkIGl0LCBl
eGNlcHQgaXQNCj4gY291bGRuJ3QgcG9pbnQgdG8gdGhlIGV4YWN0IGZpbGUuIEJ1dCBJIGNhbiB1
c2UgdGhlIHNpZ3N0cnVjdCBmaWxlDQo+IGluc3RlYWQgc28gYWRtaW5pc3RyYXRvcnMgY2FuIGF0
IGxlYXN0IHRlbGwgd2hpY2ggZW5jbGF2ZSB2aW9sYXRlcyB0aGUNCj4gcG9saWN5LiBEbyB5b3Ug
dGhpbmsgaXQgYWNjZXB0YWJsZT8NCj4gDQo+IFNlZW1zIHByb25lIHRvIHVzZXIgY29uZnVzaW9u
IGFuZCBsYWNrcyBwcmVjaXNpb24gaW4gd2h5IHRoZSBkZW5pYWwNCj4gb2NjdXJyZWQuDQo+IA0K
PiA+DQo+ID4gPg0KPiA+ID4gLSBUaGVyZSBpcyB0aGUgcG90ZW50aWFsIGZvciBpbmNvbnNpc3Rl
bmNpZXMgdG8gYXJpc2UgYmV0d2VlbiB0aGUNCj4gPiA+IGVuZm9yY2VtZW50IGFwcGxpZWQgd2l0
aCBkaWZmZXJlbnQgY2FjaGVfZGVjaXNpb25zIHZhbHVlcy4NCj4gPg0KPiA+IFRoZSBlbmZvcmNl
bWVudCB3aWxsIGJlIGNvbnNpc3RlbnQuIFRoZSBkaWZmZXJlbmNlIG9ubHkgbGllcyBpbiB0aGUN
Cj4gbG9ncy4NCj4gPg0KPiA+ID4NCj4gPiA+IEkgd291bGQgc3VnZ2VzdCB0aGF0IHdlIGp1c3Qg
bmV2ZXIgY2FjaGUgdGhlIGRlY2lzaW9uIGFuZCBhY2NlcHQgdGhlDQo+ID4gPiBjb3N0IGlmIHdl
IGFyZSBnb2luZyB0byB0YWtlIHRoaXMgYXBwcm9hY2guDQo+ID4NCj4gPiBUaGlzIHdpbGwgYWxz
byBiZSBhIHZpYWJsZSBvcHRpb24uIEkgZG9uJ3QgdGhpbmsgYW55IGVuY2xhdmVzIHdvdWxkIGJl
DQo+IGNvbXByaXNlZCBvZiBhIGxhcmdlIG51bWJlciBvZiBmaWxlcyBhbnl3YXkuIFdoZW4gU0dY
MiBjb21lcyB1cCwgSSB0aGluaw0KPiBtb3N0IGVuY2xhdmVzIHdpbGwgYmUgaW5zdGFudGlhdGVk
IGZyb20gb25seSBvbmUgZmlsZSBhbmQgZGVmZXIgbG9hZGluZw0KPiBsaWJyYXJpZXMgYXQgcnVu
dGltZS4gU28gaW4gcHJhY3RpY2Ugd2UgYXJlIGxvb2tpbmcgdG8ga2VlcGluZyBvbmx5IG9uZQ0K
PiBmaWxlIG9wZW4gcGVyIGVuY2xhdmUsIHdoaWNoIHNlZW1zIHRvdGFsbHkgYWNjZXB0YWJsZS4N
Cj4gPg0KPiA+IFN0ZXBoZW4gKGFuZCBldmVyeW9uZSBoYXZpbmcgYW4gb3BpbmlvbiBvbiB0aGlz
KSwgd2hpY2ggd2F5IGRvIHlvdQ0KPiBwcmVmZXI/IHN5c2N0bCB2YXJpYWJsZT8gT3IgbmV2ZXIg
Y2FjaGUgZGVjaXNpb25zPw0KPiANCj4gSSdkIGZhdm9yIG5ldmVyIGNhY2hpbmcgZGVjaXNpb25z
Lg0KDQpBbHJpZ2h0LCBJJ2xsIHJlbW92ZSB0aGUgYm9vdCBwYXJhbWV0ZXIgYW5kIG5ldmVyIGNh
Y2hlIGRlY2lzaW9ucy4NCg==
