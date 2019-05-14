Return-Path: <SRS0=nHr/=TO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E762C04AB4
	for <linux-sgx@archiver.kernel.org>; Tue, 14 May 2019 21:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D060420873
	for <linux-sgx@archiver.kernel.org>; Tue, 14 May 2019 21:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfENV63 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 May 2019 17:58:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:56468 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbfENV63 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 May 2019 17:58:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 14:58:25 -0700
X-ExtLoop1: 1
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga005.jf.intel.com with ESMTP; 14 May 2019 14:58:25 -0700
Received: from orsmsx126.amr.corp.intel.com (10.22.240.126) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 14 May 2019 14:58:25 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX126.amr.corp.intel.com ([169.254.4.35]) with mapi id 14.03.0415.000;
 Tue, 14 May 2019 14:58:25 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Haitao Huang <haitao.huang@linux.intel.com>
CC:     Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: RE: [PATCH v20 00/28] Intel SGX1 support
Thread-Topic: [PATCH v20 00/28] Intel SGX1 support
Thread-Index: AQHU9QnxaoiNNkdqP0yJjajWChyAgKZCnqeAgAAN+QCAAVPmAIAAE4cAgABGGYCAABE4gIAAAfWAgAABFgCAAADiAIAABegAgAABOYCAAAN6gIAAAQAAgAAA2wCAAATlgIAEWt6AgBvkEoCAAHnYgIAABJkAgAAC6gD//5XxkIAAergAgAAFGwCABfiogIAADDGAgAADpgCAAFgcAP//jXfQ
Date:   Tue, 14 May 2019 21:58:24 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654E11D8@ORSMSX116.amr.corp.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com>
 <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de>
 <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com>
 <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com>
 <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
 <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
 <CALCETrV7CcDnx1hVtmBnDNABG11GuMqyspJMMpV+zHpVeFu3ow@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E885F9D@ORSMSX116.amr.corp.intel.com>
 <979615a8-fd03-e3fd-fbdb-65c1e51afd93@fortanix.com>
 <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <op.z1saqpzxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <CALCETrXHbRL-pzZ7CG+RrMNGNEPKO9LY=6Bo4tuFzcZ_ZTMQvQ@mail.gmail.com>
 <op.z1sdc6m4wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <CALCETrVfUfcs8ntj6tAzGo5eiaDGnLvUmgkUXNLX0a6SyJT+pg@mail.gmail.com>
In-Reply-To: <CALCETrVfUfcs8ntj6tAzGo5eiaDGnLvUmgkUXNLX0a6SyJT+pg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTc4YzgwMjktMjZkYy00OTE1LTgxYmEtYjU4YzlkZGZmYjk3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNEVFdlFxMHVvUFNYZHcrZ09JXC9JYjIwWUF3UmU3anpKNUZOZ2VKdFFtdXNDOUM0Q0M5ek9teEwyU3ZJR0pRck8ifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGkgRXZlcnlvbmUsDQoNCkkgdGhpbmsgd2UgYXJlIHRhbGtpbmcgYWJvdXQgMiBkaWZmZXJlbnQg
a2luZHMgb2YgY3JpdGVyaWEgZm9yIGRldGVybWluaW5nIHRoZSBzYW5pdHkgb2YgYW4gZW5jbGF2
ZS4gDQoNClRoZSBmaXJzdCBraW5kIGRldGVybWluZXMgYW4gZW5jbGF2ZSdzIHNhbml0eSBieSBn
ZW5lcmFsbHkgYWNjZXB0ZWQgZ29vZCBwcmFjdGljZXMuIEZvciBleGFtcGxlLCBubyBleGVjdXRh
YmxlIHBhZ2VzIHNoYWxsIGV2ZXIgYmUgd3JpdGFibGUuDQoNClRoZSBzZWNvbmQga2luZCBkZXRl
cm1pbmVzIGFuIGVuY2xhdmUncyBzYW5pdHkgYnkgIndobyBzdGFuZHMgYmVoaW5kIGl0Iiwgc3Vj
aCBhcyB3aGV0aGVyIHRoZSBmaWxlIGNvbnRhaW5pbmcgU0lHU1RSVUNUIGhhcyB0aGUgcHJvcGVy
IFNFTGludXggbGFiZWwvdHlwZSwgb3Igd2hldGhlciB0aGUgc2lnbmluZyBrZXkgaXMgdHJ1c3Rl
ZC4NCg0KSSdkIHNheSB0aG9zZSAyIGtpbmRzIG9mIGNyaXRlcmlhIHNob3VsZCBiZSBvcnRob2dv
bmFsIGJlY2F1c2UgdGhleSBkb24ndCBnZXQgaW50byBlYWNoIG90aGVyJ3Mgd2F5IGFuZCBpdCBj
b3VsZCBhbHNvIGJlIGJlbmVmaWNpYWwgdG8gZW5hYmxlIGJvdGggYXQgdGhlIHNhbWUgdGltZS4g
Rm9yIGV4YW1wbGUsIGEgdXNlciBtYXkgd2FudCB0byBhbGxvdyBsYXVuY2hpbmcgZW5jbGF2ZXMg
c2lnbmVkIGJ5IGhpbXNlbGYvaGVyc2VsZiBvbmx5LCBob3dldmVyLCBhcyBhIGh1bWFuIGJlaW5n
IGhlL3NoZSBtYXkgbWFrZSBtaXN0YWtlcyBzbyB3b3VsZCBhbHNvIGxpa2UgdG8gZW5zdXJlIG5v
IFJXWCBwYWdlcyBldmVuIGZvciB0aG9zZSBlbmNsYXZlcyBleHBsaWNpdGx5IGF1dGhvcml6ZWQu
DQoNCkkgdGhpbmsgdGhvc2UgMiBraW5kcyBvZiBjcml0ZXJpYSBjb3VsZCBiZSBhYnN0cmFjdGVk
IGFzIDIgbmV3IExTTSBob29rcyAtIHNlY3VyaXR5X3NneF9hZGRfcGFnZXMoKSBhbmQgc2VjdXJp
dHlfc2d4X2luaXRpYWxpemVfZW5jbGF2ZSgpLg0KDQpzZWN1cml0eV9zZ3hfYWRkX3BhZ2VzKCkg
aXMgaW52b2tlZCBieSBTR1ggZHJpdmVyIHRvIGRldGVybWluZSBpZiBhIHJhbmdlIG9mIHNvdXJj
ZSBwYWdlcyBhcmUgYWxsb3dlZCB0byBiZSBFQUREJ2VkIHdpdGggdGhlIHJlcXVlc3RlZCBFUENN
IGF0dHJpYnV0ZXMsIGFuZCBieSBkZWZhdWx0IGl0IHJldHVybnMgMCAoYWxsb3dlZCkgaWZmIHRo
ZSByZXF1ZXN0ZWQgRVBDTSBhdHRyaWJ1dGVzIGFyZSBhIHN1YnNldCBvZiB0aGUgcGVybWlzc2lv
bnMgb2YgdGhlIFZNQSBjb3ZlcmluZyB0aGF0IHJhbmdlIG9mIHNvdXJjZSBwYWdlcy4gQW4gKFNH
WC1hd2FyZSkgTFNNIG1vZHVsZS9wb2xpY3kgY291bGQgZW1wbG95IGRpZmZlcmVudCBjcml0ZXJp
YSwgc3VjaCBhcyBtYWtpbmcgc3VyZSB0aGUgc291cmNlIHBhZ2VzIGFyZSBiYWNrZWQgYnkgYW4g
ZW5jbGF2ZSBmaWxlICh1c2luZyBTRUxpbnV4IGxhYmVsLCBmb3IgZXhhbXBsZSkuIA0KDQpzZWN1
cml0eV9zZ3hfaW5pdGlhbGl6ZV9lbmNsYXZlKCkgaXMgaW52b2tlZCBieSBTR1ggZHJpdmVyIHRv
IGRldGVybWluZSBpZiBhIGdpdmVuIFNJR1NUUlVDVCBpcyB2YWxpZCAoaGVuY2UgYWxsb3dlZCB0
byBiZSBFSU5JVCdlZCksIGFuZCBpdCBhbHdheXMgcmV0dXJucyAwIChhbGxvd2VkKSBieSBkZWZh
dWx0LiBBbiBMU00gaW1wbGVtZW50YXRpb24gbWF5IGVuZm9yY2UgY3VzdG9tIHBvbGljaWVzLCBz
dWNoIGFzIHdoZXRoZXIgdGhlIHNpZ25pbmcgcHVibGljIGtleSBpcyB0cnVzdGVkIGJ5IHRoZSBj
dXJyZW50IHVzZXIsIG9yIHdoZXRoZXIgaXQgd2FzIGJhY2tlZCAobW1hcCgpJ2VkKSBieSBhbiBh
dXRob3JpemVkIGZpbGUgKGUuZy4gb2YgYW4gZXhwZWN0ZWQgdHlwZSBpbiB0aGUgY2FzZSBvZiBT
RUxpbnV4LCBvciBsb2NhdGVkIGluIGEgcGFydGljdWxhciBkaXJlY3RvcnkgaW4gdGhlIGNhc2Ug
b2YgQXBwQXJtb3IpLg0KDQpXaXRoIHJlZ2FyZCB0byBTR1gyL0VETU0gKEVuY2xhdmUgRHluYW1p
YyBNZW1vcnkgTWFuYWdlbWVudCkgc3VwcG9ydCwgUlctPlJYIHRyYW5zaXRpb25zIGFyZSBpbmV2
aXRhYmxlIHRvIHN1cHBvcnQgY2VydGFpbiB1c2FnZXMgc3VjaCBhcyBkeW5hbWljIGxvYWRpbmcv
bGlua2luZywgbWVhbmluZyB0aG9zZSB1c2FnZXMgbWF5IGJlIGJsb2NrZWQgYnkgZXhpc3Rpbmcg
cG9saWNpZXMuIEJ1dCBmcm9tIHNlY3VyaXR5IHBlcnNwZWN0aXZlLCBJIHRoaW5rIHRoZXkgc2hv
dWxkIGJlIGFsbG93ZWQgYnkgZGVmYXVsdCAoaS5lLiBmb3Igbm9uLVNHWC1hd2FyZSBMU00gbW9k
dWxlcy9wb2xpY2llcykgYmVjYXVzZSBzdWNoIHBlcm1pc3Npb24gY2hhbmdlcyBhcmUgaW5oZXJl
bnQgYmVoYXZpb3JzIG9mIHRoZSBlbmNsYXZlIGl0c2VsZiwgd2hpY2ggaXMgY29uc2lkZXJlZCAi
c2FuZSIgYWZ0ZXIgcGFzc2luZyBhbGwgdGhlIGNoZWNrcyBwZXJmb3JtZWQgaW4gc2VjdXJpdHlf
c2d4X2FkZF9wYWdlcygpL3NlY3VyaXR5X3NneF9pbml0aWFsaXplX2VuY2xhdmUoKS4gT2YgY291
cnNlLCBhbiBTR1gtYXdhcmUgTFNNIG1vZHVsZS9wb2xpY3kgc2hhbGwgYmUgYWxsb3dlZCB0byBv
dmVycmlkZS4gSG93IGFib3V0IGFkZGluZyBhIG5ldyBzZWN1cml0eV9zZ3hfbXByb3RlY3QoKSBM
U00gaG9vaz8NCg0KPiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5v
cmddDQo+IA0KPiA+IE9uIE1heSAxNCwgMjAxOSwgYXQgODozMCBBTSwgSGFpdGFvIEh1YW5nDQo+
IDxoYWl0YW8uaHVhbmdAbGludXguaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+PiBPbiBUdWUs
IDE0IE1heSAyMDE5IDEwOjE3OjI5IC0wNTAwLCBBbmR5IEx1dG9taXJza2kgPGx1dG9Aa2VybmVs
Lm9yZz4NCj4gd3JvdGU6DQo+ID4+DQo+ID4+IE9uIFR1ZSwgTWF5IDE0LCAyMDE5IGF0IDc6MzMg
QU0gSGFpdGFvIEh1YW5nDQo+ID4+IDxoYWl0YW8uaHVhbmdAbGludXguaW50ZWwuY29tPiB3cm90
ZToNCj4gPj4+DQo+ID4+PiBPbiBGcmksIDEwIE1heSAyMDE5IDE0OjIyOjM0IC0wNTAwLCBBbmR5
IEx1dG9taXJza2kNCj4gPj4+IDxsdXRvQGtlcm5lbC5vcmc+DQo+ID4+PiB3cm90ZToNCj4gPj4+
DQo+ID4+PiA+IE9uIEZyaSwgTWF5IDEwLCAyMDE5IGF0IDEyOjA0IFBNIEpldGhybyBCZWVrbWFu
DQo+ID4+PiA+IDxqZXRocm9AZm9ydGFuaXguY29tPg0KPiA+Pj4gPiB3cm90ZToNCj4gPj4+ID4+
DQo+ID4+PiA+PiBPbiAyMDE5LTA1LTEwIDExOjU2LCBYaW5nLCBDZWRyaWMgd3JvdGU6DQo+ID4+
PiA+PiA+IEhpIEpldGhybywNCj4gPj4+ID4+ID4NCj4gPj4+ID4+ID4+IEVMRiBmaWxlcyBhcmUg
ZXhwbGljaXRseSBkZXNpZ25lZCBzdWNoIHRoYXQgeW91IGNhbiBtYXAgdGhlbQ0KPiA+Pj4gPj4g
Pj4gKHdpdGgNCj4gPj4+ID4+IG1tYXApDQo+ID4+PiA+PiA+PiBpbiA0MDk2LWJ5dGUgY2h1bmtz
LiBIb3dldmVyLCBzb21ldGltZXMgdGhlcmUncyBvdmVybGFwIGFuZA0KPiA+Pj4gPj4gPj4geW91
IHdpbGwgc29tZXRpbWVzIHNlZSB0aGF0IGEgcGFydGljdWxhciBvZmZzZXQgaXMgbWFwcGVkDQo+
ID4+PiA+PiA+PiB0d2ljZSBiZWNhdXNlIHRoZQ0KPiA+Pj4gPj4gZmlyc3QNCj4gPj4+ID4+ID4+
IGhhbGYgb2YgdGhlIHBhZ2UgaW4gdGhlIGZpbGUgYmVsb25ncyB0byBhbiBSWCByYW5nZSBhbmQg
dGhlDQo+ID4+PiA+PiA+PiBzZWNvbmQNCj4gPj4+ID4+IGhhbGYNCj4gPj4+ID4+ID4+IHRvIGFu
IFItb25seSByYW5nZS4gQWxzbywgRUxGIGZpbGVzIGRvbid0IChub3JtYWxseSkgZGVzY3JpYmUN
Cj4gPj4+ID4+ID4+IHN0YWNrLCBoZWFwLCBldGMuIHdoaWNoIHlvdSBkbyBuZWVkIGZvciBlbmNs
YXZlcy4NCj4gPj4+ID4+ID4NCj4gPj4+ID4+ID4gWW91IGhhdmUgcHJvYmFibHkgbWlzcmVhZCBt
eSBlbWFpbC4gQnkgbW1hcCgpLCBJIG1lYW50IHRoZQ0KPiA+Pj4gPj4gPiBlbmNsYXZlDQo+ID4+
PiA+PiBmaWxlIHdvdWxkIGJlIG1hcHBlZCB2aWEgKm11bHRpcGxlKiBtbWFwKCkgY2FsbHMsIGlu
IHRoZSBzYW1lIHdheQ0KPiA+Pj4gPj4gYXMgd2hhdCBkbG9wZW4oKSB3b3VsZCBkbyBpbiBsb2Fk
aW5nIHJlZ3VsYXIgc2hhcmVkIG9iamVjdC4gVGhlDQo+ID4+PiA+PiBpbnRlbnRpb24gaGVyZSBp
cyB0byBtYWtlIHRoZSBlbmNsYXZlIGZpbGUgc3ViamVjdCB0byB0aGUgc2FtZQ0KPiA+Pj4gPj4g
Y2hlY2tzIGFzIHJlZ3VsYXIgc2hhcmVkIG9iamVjdHMuDQo+ID4+PiA+Pg0KPiA+Pj4gPj4gTm8s
IEkgZGlkbid0IG1pc3JlYWQgeW91ciBlbWFpbC4gTXkgb3JpZ2luYWwgcG9pbnQgc3RpbGwgc3Rh
bmRzOg0KPiA+Pj4gPj4gcmVxdWlyaW5nIHRoYXQgYW4gZW5jbGF2ZSdzIG1lbW9yeSBpcyBjcmVh
dGVkIGZyb20gb25lIG9yIG1vcmUNCj4gPj4+ID4+IG1tYXAgY2FsbHMgb2YgYSBmaWxlIHB1dHMg
c2lnbmlmaWNhbnQgcmVzdHJpY3Rpb25zIG9uIHRoZQ0KPiA+Pj4gPj4gZW5jbGF2ZSdzIG9uLWRp
c2sgcmVwcmVzZW50YXRpb24uDQo+ID4+PiA+Pg0KPiA+Pj4gPg0KPiA+Pj4gPiBGb3IgYSB0aW55
IGJpdCBvZiBiYWNrZ3JvdW5kLCBMaW51eCAoQUZBSUsqKSBtYWtlcyBubyBlZmZvcnQgdG8NCj4g
Pj4+ID4gZW5zdXJlIHRoZSBjb21wbGV0ZSBpbnRlZ3JpdHkgb2YgRFNPcy4gIFdoYXQgTGludXgg
KmRvZXMqIGRvIChpZg0KPiA+Pj4gPiBzbw0KPiA+Pj4gPiBjb25maWd1cmVkKSBpcyB0byBtYWtl
IHN1cmUgdGhhdCBvbmx5IGFwcHJvdmVkIGRhdGEgaXMgbWFwcGVkDQo+ID4+PiA+IGV4ZWN1dGFi
bGUuICBTbywgaWYgeW91IHdhbnQgdG8gaGF2ZSBzb21lIGJ5dGVzIGJlIGV4ZWN1dGFibGUsDQo+
ID4+PiA+IHRob3NlIGJ5dGVzIGhhdmUgdG8gY29tZSBmcm9tIGEgZmlsZSB0aGF0IHBhc3NlcyB0
aGUgcmVsZXZhbnQgTFNNDQo+ID4+PiA+IGFuZCBJTUEgY2hlY2tzLg0KPiA+Pj4NCj4gPj4+IEdp
dmVuIHRoaXMsIEkganVzdCB3YW50IHRvIHN0ZXAgYmFjayBhIGxpdHRsZSB0byB1bmRlcnN0YW5k
IHRoZQ0KPiA+Pj4gZXhhY3QgaXNzdWUgdGhhdCBTR1ggaXMgY2F1c2luZyBoZXJlIGZvciBMU00v
SU1BLiBTb3JyeSBpZiBJIG1pc3NlZA0KPiA+Pj4gcG9pbnRzIGRpc2N1c3NlZCBlYXJsaWVyLg0K
PiA+Pj4NCj4gPj4+IEJ5IHRoZSB0aW1lIG9mIEVBREQsIGVuY2xhdmUgZmlsZSBpcyBvcGVuZWQg
YW5kIHNob3VsZCBoYXZlIHBhc3NlZA0KPiA+Pj4gSU1BIGFuZCBTRUxpbnV4IHBvbGljeSBlbmZv
cmNlbWVudCBnYXRlcyBpZiBhbnkuIFdlIHJlYWxseSBkb24ndA0KPiA+Pj4gbmVlZCBleHRyYSBt
bWFwcyBvbiB0aGUgZW5jbGF2ZSBmaWxlcyB0byBiZSBJTUEgYW5kIFNFTGludXgNCj4gY29tcGxp
YW50Lg0KPiA+Pg0KPiA+PiBUaGUgcHJvYmxlbSwgYXMgaSBzZWUgaXQsIGlzIHRoYXQgdGhleSBw
YXNzZWQgdGhlICp3cm9uZyogY2hlY2tzLA0KPiA+PiBiZWNhdXNlLCBhcyB5b3Ugbm90aWNlZDoN
Cj4gPj4NCj4gPj4+IFdlIGFyZSBsb2FkaW5nDQo+ID4+PiBlbmNsYXZlIGZpbGVzIGFzIFJPIGFu
ZCBjb3B5aW5nIHRob3NlIGludG8gRVBDLg0KPiA+Pg0KPiA+PiBXaGljaCBpcywgc2VtYW50aWNh
bGx5LCBhIGxvdCBsaWtlIGxvYWRpbmcgYSBub3JtYWwgZmlsZSBhcyBSTyBhbmQNCj4gPj4gdGhl
biBtcHJvdGVjdGluZygpIGl0IHRvIFJYLCB3aGljaCBpcyBkaXNhbGxvd2VkIHVuZGVyIHF1aXRl
IGEgZmV3DQo+ID4+IExTTSBwb2xpY2llcy4NCj4gPj4NCj4gPj4+IEFuIElNQSBwb2xpY3kgY2Fu
IGVuZm9yY2UNCj4gPj4+IFJPIGZpbGVzIChvciBhbnkgZmlsZSkuIEFuZCBTRUxpbnV4IHBvbGlj
eSBjYW4gc2F5IHdoaWNoIHByb2Nlc3Nlcw0KPiA+Pj4gY2FuIG9wZW4gdGhlIGZpbGUgZm9yIHdo
YXQgcGVybWlzc2lvbnMuIE5vIGV4dHJhIG5lZWRlZCBoZXJlLg0KPiA+Pg0KPiA+PiBJZiBTRUxp
bnV4IHNheXMgYSBwcm9jZXNzIG1heSBvcGVuIGEgZmlsZSBhcyBSTywgdGhhdCBkb2VzICpub3Qq
IG1lYW4NCj4gPj4gdGhhdCBpdCBjYW4gYmUgb3BlbmVkIGFzIFJYLg0KPiA+Pg0KPiA+DQo+ID4g
QnV0IGluIHRoaXMgY2FzZSwgZmlsZSBpdHNlbGYgaXMgbWFwcGVkIGFzIFJPIHRyZWF0ZWQgbGlr
ZSBkYXRhIGFuZCBpdA0KPiBpcyBub3QgZm9yIGV4ZWN1dGlvbi4gU0dYIGVuY2xhdmUgcGFnZXMg
aGF2ZSBFUENNIGVuZm9yY2VkIHBlcm1pc3Npb25zLg0KPiBTbyBmcm9tIFNFTGludXggcG9pbnQg
b2YgdmlldyBJIHdvdWxkIHRoaW5rIGl0IGNhbiB0cmVhdCBpdCBhcyBSTyBhbmQNCj4gdGhhdCdz
IGZpbmUuDQo+IA0KPiBBcyBhbiBleGFtcGxlLCBTRUxpbnV4IGhhcyBhbiDigJxleGVjdXRl4oCd
IHBlcm1pc3Npb24gKHZpYQ0KPiBzZWN1cml0eV9tbWFwX2ZpbGUg4oCUIHNlZSBmaWxlX21hcF9w
cm90X2NoZWNrKCkpIHRoYXQgY29udHJvbHMgd2hldGhlcg0KPiB5b3UgY2FuIGV4ZWN1dGUgY29k
ZSBmcm9tIHRoYXQgZmlsZS4gIElmIHlvdSBsYWNrIHRoaXMgcGVybWlzc2lvbiBvbiBhDQo+IGZp
bGUsIHlvdSBtYXkgc3RpbGwgYmUgYWJsZSB0byBtYXAgaXQgUFJPVF9SRUFELCBidXQgeW91IG1h
eSBub3QgbWFwIGl0DQo+IFBST1RfRVhFQy4gIFNpbWlsYXJseSwgaWYgeW91IHdhbnQgdG8gbWFs
bG9jKCkgc29tZSBtZW1vcnksIHdyaXRlDQo+ICpjb2RlKiB0byBpdCwgYW5kIGV4ZWN1dGUgaXQs
IHlvdSBuZWVkIGEgc3BlY2lmaWMgcGVybWlzc2lvbi4NCj4gDQo+IFNvLCB1bmxlc3Mgd2Ugc29t
ZWhvdyB0aGluayBpdOKAmXMgb2theSBmb3IgU0dYIHRvIGJyZWFrIHRoZSBleGlzdGluZw0KPiBt
b2RlbCwgd2UgbmVlZCB0byByZXNwZWN0IHRoZXNlIHJlc3RyaWN0aW9ucyBpbiB0aGUgU0dYIGRy
aXZlci4gSW4gb3RoZXINCj4gd29yZHMsIHdlIGVpdGhlciBuZWVkIHRvIHJlc3BlY3QgZXhlY21l
bSwgZXRjIG9yIHJlcXVpcmUgUFJPVF9FWEVDIG9yDQo+IHRoZSBlcXVpdmFsZW50LiBJIGxpa2Ug
dGhlIGxhdHRlciBhIGxvdCBtb3JlLg0KDQotQ2VkcmljDQo=
