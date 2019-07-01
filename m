Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1A2C0650E
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 17:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFCCC2146F
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 17:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbfGAR5n (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 13:57:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:39628 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbfGAR5n (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 13:57:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 10:57:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="362342925"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga006.fm.intel.com with ESMTP; 01 Jul 2019 10:57:41 -0700
Received: from orsmsx126.amr.corp.intel.com (10.22.240.126) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 10:57:41 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX126.amr.corp.intel.com ([169.254.4.136]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 10:57:40 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Stephen Smalley <stephen.smalley@gmail.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "greg@enjellic.com" <greg@enjellic.com>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Topic: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Index: AQHVLG/L9SgvyZq9qEim/LcvveBd6KawhbyA//+RRaCAAIfxgP//kpmggAGW7oCAAIp0gIABTq0AgAJvZOA=
Date:   Mon, 1 Jul 2019 17:57:40 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D585@ORSMSX116.amr.corp.intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <b08798a5-65f7-f96e-1c04-39dd0e60c114@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551B8D7@ORSMSX116.amr.corp.intel.com>
 <9f525db2-f46b-b4cb-c4e9-b9dbd18ed4d2@schaufler-ca.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551B975@ORSMSX116.amr.corp.intel.com>
 <f6f16990-0291-c530-61dd-dcd26525285c@schaufler-ca.com>
 <CAB9W1A1RpM_9D_49E1VauuKE1tL=TyfeATomv47HX4FONnjA4A@mail.gmail.com>
 <18833f2e-9d18-1f39-6bc5-9242910ab25c@schaufler-ca.com>
In-Reply-To: <18833f2e-9d18-1f39-6bc5-9242910ab25c@schaufler-ca.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWNhYmQ1YmMtZjYxZS00YmM0LTk4ZTEtYWNhNDUzMzA5NWIxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQThNVG5oXC9PdDJjQXVyRFZiVHdleDVSRUFnRWl3RlZVVVMwZDM0UlwvbXVQbE5nMU4rXC8wYm8ra29xeFpCUEo1VyJ9
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
LQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBDYXNleSBTY2hhdWZsZXIN
Cj4gDQo+IE9uIDYvMjgvMjAxOSA2OjM3IFBNLCBTdGVwaGVuIFNtYWxsZXkgd3JvdGU6DQo+ID4g
T24gRnJpLCBKdW4gMjgsIDIwMTkgYXQgMToyMiBQTSBDYXNleSBTY2hhdWZsZXIgPGNhc2V5QHNj
aGF1Zmxlci0NCj4gY2EuY29tPiB3cm90ZToNCj4gPj4gT24gNi8yNy8yMDE5IDU6NDcgUE0sIFhp
bmcsIENlZHJpYyB3cm90ZToNCj4gPj4+PiBGcm9tOiBDYXNleSBTY2hhdWZsZXIgW21haWx0bzpj
YXNleUBzY2hhdWZsZXItY2EuY29tXQ0KPiA+Pj4+IFNlbnQ6IFRodXJzZGF5LCBKdW5lIDI3LCAy
MDE5IDQ6MzcgUE0NCj4gPj4+Pj4+IFRoaXMgY29kZSBzaG91bGQgbm90IGJlIG1peGVkIGluIHdp
dGggdGhlIExTTSBpbmZyYXN0cnVjdHVyZS4NCj4gPj4+Pj4+IEl0IHNob3VsZCBhbGwgYmUgY29u
dGFpbmVkIGluIGl0cyBvd24gbW9kdWxlLCB1bmRlcg0KPiBzZWN1cml0eS9lbmNsYXZlLg0KPiA+
Pj4+PiBsc21fZW1hIGlzICppbnRlbmRlZCogdG8gYmUgcGFydCBvZiB0aGUgTFNNIGluZnJhc3Ry
dWN0dXJlLg0KPiA+Pj4+IFRoYXQncyBub3QgZ29pbmcgdG8gZmx5LCBub3QgZm9yIGEgbWludXRl
Lg0KPiA+Pj4gV2h5IG5vdCwgaWYgdGhlcmUncyBhIG5lZWQgZm9yIGl0Pw0KPiA+Pj4NCj4gPj4+
IEFuZCB3aGF0J3MgdGhlIGNvbmNlcm4gaGVyZSBpZiBpdCBiZWNvbWVzIHBhcnQgb2YgdGhlIExT
TQ0KPiBpbmZyYXN0cnVjdHVyZS4NCj4gPj4gVGhlIExTTSBpbmZyYXN0cnVjdHVyZSBwcm92aWRl
cyBhIGZyYW1ld29yayBmb3IgaG9va3MgYW5kIGFsbG9jYXRpb24NCj4gPj4gb2YgYmxvYnMuIFRo
YXQncyBpdC4gSXQncyBhIGxheWVyIGZvciBjb25uZWN0aW5nIHN5c3RlbSBmZWF0dXJlcyBsaWtl
DQo+ID4+IFZGUywgSVBDIGFuZCB0aGUgSVAgc3RhY2sgdG8gdGhlIHNlY3VyaXR5IG1vZHVsZXMu
IEl0IGRvZXMgbm90DQo+ID4+IGltcGxlbWVudCBhbnkgcG9saWN5IG9mIGl0J3Mgb3duLiBXZSBh
cmUgbm90IGdvaW5nIHRvIGltcGxlbWVudCBTR1gNCj4gPj4gb3IgYW55IG90aGVyIG1lY2hhbmlz
bSB3aXRoaW4gdGhlIExTTSBpbmZyYXN0cnVjdHVyZS4NCj4gPiBJIGRvbid0IHRoaW5rIHlvdSB1
bmRlcnN0YW5kIHRoZSBwdXJwb3NlIG9mIHRoaXMgY29kZS4gIEl0IGlzbid0DQo+ID4gaW1wbGVt
ZW50aW5nIFNHWCwgbm9yIGlzIGl0IG5lZWRlZCBieSBTR1guDQo+ID4gSXQgaXMgcHJvdmlkaW5n
IHNoYXJlZCBpbmZyYXN0cnVjdHVyZSBmb3Igc2VjdXJpdHkgbW9kdWxlcywgc2ltaWxhciB0bw0K
PiA+IGxzbV9hdWRpdC5jLCBzbyB0aGF0IHNlY3VyaXR5IG1vZHVsZXMgY2FuIGVuZm9yY2UgV15Y
IG9yIHNpbWlsYXINCj4gPiBtZW1vcnkgcHJvdGVjdGlvbiBndWFyYW50ZWVzIGZvciBTR1ggZW5j
bGF2ZSBtZW1vcnksIHdoaWNoIGhhcyB1bmlxdWUNCj4gPiBwcm9wZXJ0aWVzIHRoYXQgcmVuZGVy
IHRoZSBleGlzdGluZyBtbWFwIGFuZCBtcHJvdGVjdCBob29rcw0KPiA+IGluc3VmZmljaWVudC4g
VGhleSBjYW4gY2VydGFpbmx5IGltcGxlbWVudCBpdCBvbmx5IGZvciBTRUxpbnV4LCBidXQNCj4g
PiB0aGVuIGFueSBvdGhlciBzZWN1cml0eSBtb2R1bGUgdGhhdCB3YW50cyB0byBwcm92aWRlIHN1
Y2ggZ3VhcmFudGVlcw0KPiA+IHdpbGwgaGF2ZSB0byByZXBsaWNhdGUgdGhhdCBjb2RlLg0KPiAN
Cj4gSSBhbSBub3Qgb2JqZWN0aW5nIHRvIHRoZSBwdXJwb3NlIG9mIHRoZSBjb2RlLg0KPiBJICph
bSogb2JqZWN0aW5nIHRvIGNhbGxpbmcgaXQgcGFydCBvZiB0aGUgTFNNIGluZnJhc3RydWN0dXJl
Lg0KPiBJdCBuZWVkcyB0byBiZSBpdCdzIG93biB0aGluZywgb2ZmIHNvbWV3aGVyZSBlbHNlLg0K
PiBJdCBtdXN0IG5vdCB1c2UgdGhlIGxzbV8gcHJlZml4LiBUaGF0J3MgbmFtZXNwYWNlIHBvbGx1
dGlvbi4NCj4gVGhlIGNvZGUgbXVzdCBub3QgYmUgZW1iZWRkZWQgaW4gdGhlIExTTSBpbmZyYXN0
cnVjdHVyZSBjb2RlLCB0aGF0DQo+IGJyZWFrcyB3aXRoIGhvdyBldmVyeXRoaW5nIGVsc2Ugd29y
a3MuDQoNCklmIHlvdSB1bmRlcnN0YW5kIHRoZSBwdXJwb3NlLCB0aGVuIHdoeSBhcmUgeW91IG9i
amVjdGluZyB0aGUgbHNtXyBwcmVmaXggYXMgdGhleSBhcmUgQVBJcyB0byBiZSB1c2VkIGJ5IGFs
bCBMU00gbW9kdWxlcz8gT3Igd2hhdCBzaG91bGQgYmUgdGhlIHByZWZpeCBpbiB5b3VyIG1pbmQ/
IE9yIHdoYXQga2luZCBvZiBBUElzIGRvIHlvdSB0aGluayBjYW4gcXVhbGlmeSB0aGUgbHNtXyBw
cmVmaXg/DQoNCkFuZCBJJ2QgbGlrZSB0byBjbGFyaWZ5IHRoYXQgaXQgZG9lc24ndCBicmVhayBh
bnl0aGluZywgYnV0IGlzIGp1c3QgYSBiaXQgZGlmZmVyZW50LCBpbiB0aGF0IHNlY3VyaXR5X2Vu
Y2xhdmVfbG9hZCgpIGFuZCBzZWN1cml0eV9maWxlX2ZyZWUoKSBjYWxsIGludG8gdGhvc2UgQVBJ
cy4gQnV0IHRoZXJlJ3MgYSBuZWVkIGZvciB0aGVtIGJlY2F1c2Ugb3RoZXJ3aXNlIGNvZGUvZGF0
YSB3b3VsZCBoYXZlIHRvIGJlIGR1cGxpY2F0ZWQgYW1vbmcgTFNNcyBhbmQgdGhlIGxvZ2ljIHdv
dWxkIGJlIGhhcmRlciB0byBjb21wcmVoZW5kLiBTbyB0aGF0J3MgYSB0cmFkZS1vZmYuIFRoZW4g
d2hhdCdzIHRoZSBwcmFjdGljYWwgZHJhd2JhY2sgb2YgZG9pbmcgdGhhdD8gSWYgbm8sIHdoeSB3
b3VsZCB3ZSB3YW50IHRvIHBheSBmb3IgdGhlIGNvc3QgZm9yIG5vdCBkb2luZyB0aGF0Pw0KDQo+
IA0KPiAuLi4gYW5kIHRoZSBub3Rpb24gdGhhdCB5b3UgYWxsb2NhdGUgZGF0YSBmb3Igb25lIGJs
b2IgdGhhdCBnZXRzIGZyZWVkDQo+IHJlbGF0aXZlIHRvIGFub3RoZXIgYnJlYWtzIHRoZSBkYXRh
IG1hbmFnZW1lbnQgbW9kZWwuDQoNCldoYXQgZG8geW91IG1lYW4gaGVyZT8NCg0KRU1BIGJsb2Jz
IGFyZSBhbGxvY2F0ZWQvZnJlZWQgKm5vdCogcmVsYXRpdmUgdG8gYW55IG90aGVyIGJsb2JzLg0K
