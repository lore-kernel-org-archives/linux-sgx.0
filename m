Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B42C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 22:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF2320673
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 22:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFDWCa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 18:02:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:42213 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfFDWCa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 18:02:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 15:02:29 -0700
X-ExtLoop1: 1
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga006.jf.intel.com with ESMTP; 04 Jun 2019 15:02:29 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 4 Jun 2019 15:02:28 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.165]) with mapi id 14.03.0415.000;
 Tue, 4 Jun 2019 15:02:28 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Paul Moore" <paul@paul-moore.com>,
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
Subject: RE: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple pages
 in single ioctl()
Thread-Topic: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple pages
 in single ioctl()
Thread-Index: AQHVGAki7TYpY4ZsUk+m4jTej+khLaaJYAJQgAF1XwCAAAjgAIABjEqA//+l+kA=
Date:   Tue, 4 Jun 2019 22:02:27 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654EDBC4@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-4-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654ECBBD@ORSMSX116.amr.corp.intel.com>
 <20190603200804.GG13384@linux.intel.com>
 <20190603203950.GJ13384@linux.intel.com>
 <CALCETrUb4X9_L9RXKhmyNpfSCsbNodP=BfbfO8Fz_efq24jp8w@mail.gmail.com>
In-Reply-To: <CALCETrUb4X9_L9RXKhmyNpfSCsbNodP=BfbfO8Fz_efq24jp8w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYmQ1ZDU4NmUtNjVkMC00OTNiLWIyODUtMWU3MDM5OTA4YTdiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiU21lRHFZM1orRk5UNzA0OEh4NU5ZS0syRk5oM0tvTlFJNSs4SlBrS3pEREdhRzhiaFpmYk5uSGlHTmVaRVJRMSJ9
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
IFR1ZXNkYXksIEp1bmUgMDQsIDIwMTkgMToxOCBQTQ0KPiANCj4gT24gTW9uLCBKdW4gMywgMjAx
OSBhdCAxOjM5IFBNIFNlYW4gQ2hyaXN0b3BoZXJzb24NCj4gPHNlYW4uai5jaHJpc3RvcGhlcnNv
bkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gT24gTW9uLCBKdW4gMDMsIDIwMTkgYXQgMDE6
MDg6MDRQTSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiA+IE9uIFN1biwg
SnVuIDAyLCAyMDE5IGF0IDExOjI2OjA5UE0gLTA3MDAsIFhpbmcsIENlZHJpYyB3cm90ZToNCj4g
PiA+ID4gPiBGcm9tOiBDaHJpc3RvcGhlcnNvbiwgU2VhbiBKDQo+ID4gPiA+ID4gU2VudDogRnJp
ZGF5LCBNYXkgMzEsIDIwMTkgNDozMiBQTQ0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gKy8qKg0KPiA+
ID4gPiA+ICsgKiBzZ3hfaW9jX2VuY2xhdmVfYWRkX3BhZ2VzIC0gaGFuZGxlciBmb3INCj4gPiA+
ID4gPiArJVNHWF9JT0NfRU5DTEFWRV9BRERfUEFHRVMNCj4gPiA+ID4gPiArICoNCj4gPiA+ID4g
PiArICogQGZpbGVwOiAgICAgICBvcGVuIGZpbGUgdG8gL2Rldi9zZ3gNCj4gPiA+ID4gPiArICog
QGNtZDogdGhlIGNvbW1hbmQgdmFsdWUNCj4gPiA+ID4gPiArICogQGFyZzogcG9pbnRlciB0byBh
biAmc2d4X2VuY2xhdmVfYWRkX3BhZ2UgaW5zdGFuY2UNCj4gPiA+ID4gPiArICoNCj4gPiA+ID4g
PiArICogQWRkIGEgcmFuZ2Ugb2YgcGFnZXMgdG8gYW4gdW5pbml0aWFsaXplZCBlbmNsYXZlIChF
QUREKSwgYW5kDQo+ID4gPiA+ID4gK29wdGlvbmFsbHkNCj4gPiA+ID4gPiArICogZXh0ZW5kIHRo
ZSBlbmNsYXZlJ3MgbWVhc3VyZW1lbnQgd2l0aCB0aGUgY29udGVudHMgb2YgdGhlDQo+IHBhZ2Ug
KEVFWFRFTkQpLg0KPiA+ID4gPiA+ICsgKiBUaGUgcmFuZ2Ugb2YgcGFnZXMgbXVzdCBiZSB2aXJ0
dWFsbHkgY29udGlndW91cy4gIFRoZQ0KPiA+ID4gPiA+ICtTRUNJTkZPIGFuZA0KPiA+ID4gPiA+
ICsgKiBtZWFzdXJlbWVudCBtYXNrYXJlIGFwcGxpZWQgdG8gYWxsIHBhZ2VzLCBpLmUuIHBhZ2Vz
IHdpdGgNCj4gPiA+ID4gPiArZGlmZmVyZW50DQo+ID4gPiA+ID4gKyAqIHByb3BlcnRpZXMgbXVz
dCBiZSBhZGRlZCBpbiBzZXBhcmF0ZSBjYWxscy4NCj4gPiA+ID4gPiArICoNCj4gPiA+ID4gPiAr
ICogRUFERCBhbmQgRUVYVEVORCBhcmUgZG9uZSBhc3luY2hyb25vdXNseSB2aWEgd29ya2VyIHRo
cmVhZHMuDQo+ID4gPiA+ID4gK0Egc3VjY2Vzc2Z1bA0KPiA+ID4gPiA+ICsgKiBzZ3hfaW9jX2Vu
Y2xhdmVfYWRkX3BhZ2UoKSBvbmx5IGluZGljYXRlcyB0aGUgcGFnZXMgaGF2ZQ0KPiA+ID4gPiA+
ICtiZWVuIGFkZGVkIHRvIHRoZQ0KPiA+ID4gPiA+ICsgKiB3b3JrIHF1ZXVlLCBpdCBkb2VzIG5v
dCBndWFyYW50ZWUgYWRkaW5nIHRoZSBwYWdlcyB0byB0aGUNCj4gPiA+ID4gPiArZW5jbGF2ZSB3
aWxsDQo+ID4gPiA+ID4gKyAqIHN1Y2NlZWQuDQo+ID4gPiA+ID4gKyAqDQo+ID4gPiA+ID4gKyAq
IFJldHVybjoNCj4gPiA+ID4gPiArICogICAwIG9uIHN1Y2Nlc3MsDQo+ID4gPiA+ID4gKyAqICAg
LWVycm5vIG90aGVyd2lzZQ0KPiA+ID4gPiA+ICsgKi8NCj4gPiA+ID4gPiArc3RhdGljIGxvbmcg
c2d4X2lvY19lbmNsYXZlX2FkZF9wYWdlcyhzdHJ1Y3QgZmlsZSAqZmlsZXAsDQo+IHVuc2lnbmVk
IGludCBjbWQsDQo+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNp
Z25lZCBsb25nIGFyZykgeyAgc3RydWN0DQo+ID4gPiA+ID4gK3NneF9lbmNsYXZlX2FkZF9wYWdl
cyAqYWRkcCA9ICh2b2lkICopYXJnOyAgc3RydWN0IHNneF9lbmNsDQo+ID4gPiA+ID4gKyplbmNs
ID0gZmlsZXAtPnByaXZhdGVfZGF0YTsgIHN0cnVjdCBzZ3hfc2VjaW5mbyBzZWNpbmZvOw0KPiA+
ID4gPiA+ICt1bnNpZ25lZCBpbnQgaTsgIGludCByZXQ7DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+
ICsgaWYgKGNvcHlfZnJvbV91c2VyKCZzZWNpbmZvLCAodm9pZCBfX3VzZXIgKilhZGRwLT5zZWNp
bmZvLA0KPiA+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgIHNpemVvZihzZWNpbmZvKSkpDQo+
ID4gPiA+ID4gKyAgICAgICAgIHJldHVybiAtRUZBVUxUOw0KPiA+ID4gPiA+ICsNCj4gPiA+ID4g
PiArIGZvciAoaSA9IDAsIHJldCA9IDA7IGkgPCBhZGRwLT5ucl9wYWdlcyAmJiAhcmV0OyBpKysp
IHsNCj4gPiA+ID4gPiArICAgICAgICAgaWYgKHNpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKQ0KPiA+
ID4gPiA+ICsgICAgICAgICAgICAgICAgIHJldHVybiAtRVJFU1RBUlRTWVM7DQo+ID4gPiA+DQo+
ID4gPiA+IElmIGludGVycnVwdGVkLCBob3cgd291bGQgdXNlciBtb2RlIGNvZGUga25vdyBob3cg
bWFueSBwYWdlcyBoYXZlDQo+IGJlZW4gRUFERCdlZD8NCj4gPiA+DQo+ID4gPiBIbW0sIHVwZGF0
aW5nIG5yX3BhZ2VzIHdvdWxkIGJlIGZhaXJseSBzaW1wbGUgYW5kIHNob3VsZG4ndCBjb25mdXNl
DQo+ID4gPiB1c2Vyc3BhY2UsIGUuZy4gYXMgb3Bwb3NlZCB0byBvdmVybG9hZGluZyB0aGUgcmV0
dXJuIHZhbHVlLg0KPiA+DQo+ID4gT3IgbWF5YmUgdXBkYXRlIEBhZGRyIGFuZCBAc3JjIGFzIHdl
bGw/ICBUaGF0IHdvdWxkIGFsbG93IHVzZXJzcGFjZSB0bw0KPiA+IHJlLWludm9rZSB0aGUgaW9j
dGwoKSB3aXRob3V0IGhhdmluZyB0byBtb2RpZnkgdGhlIHN0cnVjdC4NCj4gDQo+IElmIHlvdSdy
ZSBnb2luZyB0byB1c2UgLUVSRVNUQVJUU1lTLCB0aGF0J3MgdGhlIHdheSB0byBnby4gIC1FSU5U
UiB3b3VsZA0KPiBiZSBhbiBhbHRlcm5hdGl2ZS4gIEEgYmVuZWZpdCBvZiAtRVJFU1RBUlRTWVMg
aXMgdGhhdCwgd2l0aCAtRUlOVFIsIGl0DQo+IHdvdWxkbid0IGJlIHRoYXQgc3VycHJpc2luZyBm
b3IgdXNlciBjb2RlIHRvIHNpbXBseSBmYWlsIHRvIGhhbmRsZSBpdC4NCg0KLUVJTlRSIG1lYW5z
IHRoZSBjYWxsIHdhcyBpbnRlcnJ1cHRlZCBiZWZvcmUgYW55dGhpbmcgY291bGQgYmUgZG9uZS4g
QW0gSSBjb3JyZWN0Pw0KDQpCdXQgaW4gdGhpcyBjYXNlIHNvbWUgcGFnZXMgaGF2ZSBiZWVuIHBy
b2Nlc3NlZCBhbHJlYWR5IHNvIEkgZ3Vlc3Mgd2UgY2Fubm90IHJldHVybiBhbnkgZXJyb3IgY29k
ZS4gSSB0aGluayBpdCBtb3JlIHJlYXNvbmFibGUgdG8gcmV0dXJuIHRoZSBudW1iZXIgb2YgcGFn
ZXMgKG9yIGJ5dGVzKSBwcm9jZXNzZWQuDQo=
