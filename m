Return-Path: <SRS0=wmvE=UL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA41C31E46
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 18:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A166821019
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 18:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfFLSUq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jun 2019 14:20:46 -0400
Received: from mga12.intel.com ([192.55.52.136]:19427 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfFLSUq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 14:20:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 11:20:45 -0700
X-ExtLoop1: 1
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jun 2019 11:20:44 -0700
Received: from orsmsx126.amr.corp.intel.com (10.22.240.126) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 12 Jun 2019 11:20:43 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX126.amr.corp.intel.com ([169.254.4.124]) with mapi id 14.03.0415.000;
 Wed, 12 Jun 2019 11:20:43 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "q@linux.intel.com" <q@linux.intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
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
Subject: RE: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define enclave
 pages' protection bits
Thread-Topic: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define
 enclave pages' protection bits
Thread-Index: AQHVHA02SpPQp25T6UKJfs0Hq6ptA6aVOU0QgACFp4D//7q0cIACKckAgADxkoD//8kHYA==
Date:   Wed, 12 Jun 2019 18:20:43 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65502FF7@ORSMSX116.amr.corp.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-3-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F65500E13@ORSMSX116.amr.corp.intel.com>
 <CALCETrWv9FYDtiHMfnfH==jE00tt7F22t-zcnP+XjfRCQgLr7A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F655010EF@ORSMSX116.amr.corp.intel.com>
 <331B31BF-9892-4FB3-9265-3E37412F80F4@amacapital.net>
 <20190612143405.GC20308@linux.intel.com>
In-Reply-To: <20190612143405.GC20308@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODNjZDE5NzMtM2RkYS00ZDJhLWFmOTEtMWMxZTk0YjMxMzM3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiejZmU0Q3KzFtVkRtcitwazc4Tld6RTNxZjJ4SVVCbzZSQjFmanVVT3k2c0U3VWFCQmZEaWlYcEdSSkk3ZmxrciJ9
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

PiBGcm9tOiBDaHJpc3RvcGhlcnNvbiwgU2VhbiBKDQo+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSAx
MiwgMjAxOSA3OjM0IEFNDQo+IA0KPiBPbiBUdWUsIEp1biAxMSwgMjAxOSBhdCAwNTowOToyOFBN
IC0wNzAwLCBBbmR5IEx1dG9taXJza2kgd3JvdGU6DQo+ID4NCj4gPiBPbiBKdW4gMTAsIDIwMTks
IGF0IDM6MjggUE0sIFhpbmcsIENlZHJpYyA8Y2VkcmljLnhpbmdAaW50ZWwuY29tPg0KPiB3cm90
ZToNCj4gPg0KPiA+ID4+IEZyb206IEFuZHkgTHV0b21pcnNraSBbbWFpbHRvOmx1dG9Aa2VybmVs
Lm9yZ10NCj4gPiA+PiBTZW50OiBNb25kYXksIEp1bmUgMTAsIDIwMTkgMTI6MTUgUE0gVGhpcyBz
ZWVtcyBsaWtlIGFuIG9kZA0KPiA+ID4+IHdvcmtmbG93LiAgU2hvdWxkbid0IHRoZSAjUEYgcmV0
dXJuIGJhY2sgdG8gdW50cnVzdGVkIHVzZXJzcGFjZSBzbw0KPiA+ID4+IHRoYXQgdGhlIHVudHJ1
c3RlZCB1c2VyIGNvZGUgY2FuIG1ha2UgaXRzIG93biBkZWNpc2lvbiBhcyB0bw0KPiA+ID4+IHdo
ZXRoZXIgaXQgd2FudHMgdG8gRUFVRyBhIHBhZ2UgdGhlcmUgYXMgb3Bwb3NlZCB0bywgc2F5LCBr
aWxsaW5nDQo+ID4gPj4gdGhlIGVuY2xhdmUgb3Igd2FpdGluZyB0byBrZWVwIHJlc291cmNlIHVz
YWdlIHVuZGVyIGNvbnRyb2w/DQo+ID4gPg0KPiA+ID4gVGhpcyBtYXkgc2VlbSBvZGQgdG8gc29t
ZSBhdCB0aGUgZmlyc3QgZ2xhbmNlLiBCdXQgaWYgeW91IGNhbiB0aGluaw0KPiA+ID4gb2YgaG93
IHN0YXRpYyBoZWFwIChwcmUtYWxsb2NhdGVkIGJ5IEVBREQgYmVmb3JlIEVJTklUKSB3b3Jrcywg
dGhlDQo+ID4gPiBsb2FkIHBhcnNlcyB0aGUgIm1ldGFkYXRhIiBjb21pbmcgd2l0aCB0aGUgZW5j
bGF2ZSB0byBkZWNpZGUgdGhlDQo+ID4gPiBhZGRyZXNzL3NpemUgb2YgdGhlIGhlYXAsIEVBRERz
IGl0LCBhbmQgY2FsbHMgaXQgZG9uZS4gSW4gdGhlIGNhc2UNCj4gPiA+IG9mICJkeW5hbWljIiBo
ZWFwIChhbGxvY2F0ZWQgZHluYW1pY2FsbHkgYnkgRUFVRyBhZnRlciBFSU5JVCksIHRoZQ0KPiA+
ID4gc2FtZSB0aGluZyBhcHBsaWVzIC0gdGhlIGxvYWRlciBkZXRlcm1pbmVzIHRoZSByYW5nZSBv
ZiB0aGUgaGVhcCwNCj4gPiA+IHRlbGxzIHRoZSBTR1ggbW9kdWxlIGFib3V0IGl0LCBhbmQgY2Fs
bHMgaXQgZG9uZS4gRXZlcnl0aGluZyBlbHNlIGlzDQo+IHRoZSBiZXR3ZWVuIHRoZSBlbmNsYXZl
IGFuZCB0aGUgU0dYIG1vZHVsZS4NCj4gPiA+DQo+ID4gPiBJbiBwcmFjdGljZSwgdW50cnVzdGVk
IGNvZGUgdXN1YWxseSBkb2Vzbid0IGtub3cgbXVjaCBhYm91dA0KPiA+ID4gZW5jbGF2ZXMsIGp1
c3QgbGlrZSBpdCBkb2Vzbid0IGtub3cgbXVjaCBhYm91dCB0aGUgc2hhcmVkIG9iamVjdHMNCj4g
PiA+IGxvYWRlZCBpbnRvIGl0cyBhZGRyZXNzIHNwYWNlIGVpdGhlci4gV2l0aG91dCB0aGUgbmVj
ZXNzYXJ5DQo+ID4gPiBrbm93bGVkZ2UsIHVudHJ1c3RlZCBjb2RlIHVzdWFsbHkganVzdCBkb2Vz
IHdoYXQgaXQgaXMgdG9sZCAodmlhDQo+ID4gPiBvLWNhbGxzLCBvciByZXR1cm4gdmFsdWUgZnJv
bSBlLWNhbGxzKSwgd2l0aG91dCBqdWRnaW5nIHRoYXQncyByaWdodA0KPiBvciB3cm9uZy4NCj4g
PiA+DQo+ID4gPiBXaGVuIGl0IGNvbWVzIHRvICNQRiBsaWtlIHdoYXQgSSBkZXNjcmliZWQsIG9m
IGNvdXJzZSBhIHNpZ25hbCBjb3VsZA0KPiA+ID4gYmUgc2VudCB0byB0aGUgdW50cnVzdGVkIGNv
ZGUgYnV0IHdoYXQgd291bGQgaXQgZG8gdGhlbj8gVXN1YWxseQ0KPiA+ID4gaXQnZCBqdXN0IGNv
bWUgYmFjayBhc2tpbmcgZm9yIGEgcGFnZSBhdCB0aGUgZmF1bHQgYWRkcmVzcy4gU28gd2UNCj4g
PiA+IGZpZ3VyZWQgaXQnZCBiZSBtb3JlIGVmZmljaWVudCB0byBqdXN0IGhhdmUgdGhlIGtlcm5l
bCBFQVVHIGF0ICNQRi4NCj4gPiA+DQo+ID4gPiBQbGVhc2UgZG9uJ3QgZ2V0IG1lIHdyb25nIHRo
b3VnaCwgYXMgSSdtIG5vdCBkaWN0YXRpbmcgd2hhdCB0aGUgcy93DQo+ID4gPiBmbG93IHNoYWxs
IGJlLiBJdCdzIGp1c3QgZ29pbmcgdG8gYmUgYSBjaG9pY2Ugb2ZmZXJlZCB0byB1c2VyIG1vZGUu
DQo+ID4gPiBBbmQgdGhhdCBjaG9pY2Ugd2FzIHBsYW5uZWQgdG8gYmUgb2ZmZXJlZCB2aWEgbXBy
b3RlY3QoKSAtIGkuZS4gYQ0KPiA+ID4gd3JpdGFibGUgdm1hIGNhdXNlcyBrZXJuZWwgdG8gRUFV
RyB3aGlsZSBhIG5vbi13cml0YWJsZSB2bWEgd2lsbA0KPiA+ID4gcmVzdWx0IGluIGEgc2lnbmFs
ICh0aGVuIHRoZSB1c2VyIG1vZGUgY291bGQgZGVjaWRlIHdoZXRoZXIgdG8NCj4gPiA+IEVBVUcp
LiBUaGUga2V5IHBvaW50IGlzIGZsZXhpYmlsaXR5IC0gYXMgd2Ugd2FudCB0byBhbGxvdyBhbGwN
Cj4gPiA+IHJlYXNvbmFibGUgcy93IGZsb3dzIGluc3RlYWQgb2YgZGljdGF0aW5nIG9uZSBvdmVy
IG90aGVycy4gV2UgaGFkDQo+IHNpbWlsYXIgZGlzY3Vzc2lvbnMgb24gdkRTTyBBUEkgYmVmb3Jl
Lg0KPiA+ID4gQW5kIEkgdGhpbmsgeW91IGFjY2VwdGVkIG15IGFwcHJvYWNoIGJlY2F1c2Ugb2Yg
aXRzIGZsZXhpYmlsaXR5LiBBbQ0KPiA+ID4gSSByaWdodD8NCj4gPg0KPiA+IEFzIGxvbmcgYXMg
dXNlciBjb2RlIGNhbiB0dXJuIHRoaXMgb2ZmLCBJIGhhdmUgbm8gcmVhbCBvYmplY3Rpb24uIEJ1
dA0KPiA+IGl0IG1pZ2h0IG1ha2Ugc2Vuc2UgdG8gaGF2ZSBpdCBiZSBtb3JlIGV4cGxpY2l0IOKA
lCBoYXZlIGFuIGlvY3RsIHNldCB1cA0KPiA+IGEgcmFuZ2UgYXMg4oCcRUFVRy1vbi1kZW1hbmTi
gJ0uDQo+IA0KPiBUaGlzIHdhcyBwYXJ0IG9mIHRoZSBtb3RpdmF0aW9uIGJlaGluZCBjaGFuZ2lu
ZyBTR1hfSU9DX0VOQ0xBVkVfQUREX1BBR0UNCj4gdG8gU0dYX0lPQ19FTkNMQVZFX0FERF9SRUdJ
T04gYW5kIGFkZGluZyBhIEBmbGFncyBwYXJhbWV0ZXIuICBFLmcuDQo+IGFkZGluZyBzdXBwb3J0
IGZvciAiRUFVRy1vbi1kZW1hbmQiIHJlZ2lvbnMgd291bGQganVzdCBiZSBhIG5ldyBmbGFnLg0K
DQpXZSdsbCBlbmQgdXAgaW4gc29tZSBzb3J0IG9mIGludGVyZmFjZSBldmVudHVhbGx5LiBCdXQg
dGhhdCdzIHRvbyBlYXJseSB0byBkaXNjdXNzLg0KDQpDdXJyZW50bHkgd2hhdCB3ZSBuZWVkIGlz
IHRoZSBwbHVtYmluZyAtIGkuZS4gdGhlIHJhbmdlIGhhcyB0byBiZSBtbWFwKCknZWQgYW5kIGl0
IGNhbm5vdCBiZSBQUk9UX05PTkUsIG90aGVyd2lzZSB2bV9vcHMtPmZhdWx0KCkgd2lsbCBub3Qg
YmUgcmVhY2hlZC4NCg0KPiANCj4gPiBCdXQgdGhpcyBpcyBhbGwgY3VycmVudGx5IGlycmVsZXZh
bnQuIFdlIGNhbiBhcmd1ZSBhYm91dCBpdCB3aGVuIHRoZQ0KPiA+IHBhdGNoZXMgc2hvdyB1cC4g
OikNCg==
