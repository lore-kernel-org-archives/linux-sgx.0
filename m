Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F36C04AAF
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 01:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F199206BF
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 01:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfEQBGW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 May 2019 21:06:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:64277 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbfEQBGV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 May 2019 21:06:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 18:06:19 -0700
X-ExtLoop1: 1
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga006.jf.intel.com with ESMTP; 16 May 2019 18:06:19 -0700
Received: from orsmsx126.amr.corp.intel.com (10.22.240.126) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 16 May 2019 18:06:18 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX126.amr.corp.intel.com ([169.254.4.35]) with mapi id 14.03.0415.000;
 Thu, 16 May 2019 18:06:18 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     James Morris <jmorris@namei.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: RE: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Topic: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Index: AQHVC0vUmIXibKT8TUm/EUnHn2XAfqZtD8kAgAAKXgCAACSqAIAAB3yA//+8UNCAAJ8WgIAAanNwgADjZgD//5BqYA==
Date:   Fri, 17 May 2019 01:06:17 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654E40E5@ORSMSX116.amr.corp.intel.com>
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org>
 <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
 <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <CALCETrXmyau8Gq-wKHZ5FdNGF+mqd7a+q+HAVR2sqvXA6av9BA@mail.gmail.com>
In-Reply-To: <CALCETrXmyau8Gq-wKHZ5FdNGF+mqd7a+q+HAVR2sqvXA6av9BA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzE0ZGFlNTItYmJjYS00MzlmLTliY2YtYWFkZjhhODIyMzBmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiN3E2ckNDV21sWG44RUtWODBrRUIrckYzZ3JCajBMZHl5WEhpRE1MT2ZORVwvdlNqaVo1WEcrdTJqZ00wN1J1dUcifQ==
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

PiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5vcmddDQo+IA0KPiBP
biBUaHUsIE1heSAxNiwgMjAxOSBhdCAzOjIzIFBNIFhpbmcsIENlZHJpYyA8Y2VkcmljLnhpbmdA
aW50ZWwuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IEhpIEFuZHksDQo+ID4NCj4gPiA+ID4gU0lH
U1RSVUNUIGlzbid0IG5lY2Vzc2FyaWx5IHN0b3JlZCBvbiBkaXNrIHNvIG1heSBub3QgYWx3YXlz
IGhhdmUNCj4gYSBmZC4NCj4gPiA+IEhvdyBhYm91dCB0aGUgZm9sbG93aW5nPw0KPiA+ID4gPiB2
b2lkICpzc19wb2ludGVyID0gbW1hcChzaWdzdHJ1Y3RfZmQsIFBST1RfUkVBRCwuLi4pOw0KPiA+
ID4gPiBpb2N0bChlbmNsYXZlX2ZkLCBTR1hfSU5JVF9USEVfRU5DTEFWRSwgc3NfcG9pbnRlcik7
DQo+ID4gPiA+DQo+ID4gPiA+IFRoZSBpZGVhIGhlcmUgaXMgU0lHU1RSVUNUIHdpbGwgc3RpbGwg
YmUgcGFzc2VkIGluIG1lbW9yeSBzbyBpdA0KPiA+ID4gPiB3b3Jrcw0KPiA+ID4gdGhlIHNhbWUg
d2F5IHdoZW4gbm8gTFNNIG1vZHVsZXMgYXJlIGxvYWRlZCBvciBiYXNpbmcgaXRzIGRlY2lzaW9u
DQo+ID4gPiBvbiB0aGUgLnNpZ3N0cnVjdCBmaWxlLiBPdGhlcndpc2UsIGFuIExTTSBtb2R1bGUg
Y2FuIGZpZ3VyZSBvdXQgdGhlDQo+ID4gPiBiYWNraW5nIGZpbGUgKGFuZCBvZmZzZXQgd2l0aGlu
IHRoYXQgZmlsZSkgYnkgbG9va2luZyBpbnRvIHRoZSBWTUENCj4gPiA+IGNvdmVyaW5nIHNzX3Bv
aW50ZXIuDQo+ID4gPg0KPiA+ID4gSSBkb27igJl0IGxvdmUgdGhpcyBhcHByb2FjaC4gIEFwcGxp
Y2F0aW9uIGF1dGhvcnMgc2VlbSBsaWtlbHkgdG8gdXNlDQo+ID4gPiByZWFkKCkgaW5zdGVhZCBv
ZiBtbWFwKCksIGFuZCBpdOKAmWxsIHN0aWxsIHdvcmsgaW4gbWFueSBjYXJlcy4gSXQNCj4gPiA+
IHdvdWxkIGFsc28gY29tcGxpY2F0ZSB0aGUga2VybmVsIGltcGxlbWVudGF0aW9uLCBhbmQgbG9v
a2luZyBhdCB0aGUNCj4gPiA+IGlub2RlIGJhY2tpbmcgdGhlIHZtYSB0aGF0IGJhY2tzIGEgcG9p
bnRlciBpcyBhdCBsZWFzdCByYXRoZXINCj4gdW51c3VhbC4NCj4gPiA+IEluc3RlYWQsIGlmIHRo
ZSBzaWdzdHJ1Y3QgaXNu4oCZdCBvbiBkaXNrIGJlY2F1c2UgaXTigJlzIGR5bmFtaWMgb3IgY2Ft
ZQ0KPiA+ID4gZnJvbSBhIG5ldHdvcmssIHRoZSBhcHBsaWNhdGlvbiBjYW4gcHV0IGl0IGluIGEg
bWVtZmQuDQo+ID4NCj4gPiBJIHVuZGVyc3RhbmQgeW91ciBjb25jZXJuIGhlcmUuIEJ1dCBJIGd1
ZXNzIHdlIGFyZSBtYWtpbmcgdG9vIG11Y2gNCj4gYXNzdW1wdGlvbiBvbiBob3cgZW5jbGF2ZXMg
YXJlIHN0cnVjdHVyZWQvcGFja2FnZWQuIE15IGNvbmNlcm4gaXMsIHdoYXQNCj4gaWYgYSBTSUdT
VFJVQ1QgcmVhbGx5IGhhcyB0byBiZSBmcm9tIG1lbW9yeT8gRm9yIGV4YW1wbGUsIGFuIGVuY2xh
dmUNCj4gKGFsb25nIHdpdGggaXRzIFNJR1NUUlVDVCkgY291bGQgYmUgZW1iZWRkZWQgaW5zaWRl
IGEgc2hhcmVkIG9iamVjdCAob3INCj4gZXZlbiB0aGUgIm1haW4iIGV4ZWN1dGFibGUpIHNvIGl0
IHNob3dzIHVwIGluIG1lbW9yeSB0byBiZWdpbiB3aXRoLg0KPiANCj4gSG1tLiAgVGhhdCdzIGEg
ZmFpciBwb2ludCwgYWx0aG91Z2ggb3BlbmluZyAvcHJvYy9zZWxmL2V4ZSBjb3VsZCBiZQ0KPiBz
b21ld2hhdCBvZiBhIHdvcmthcm91bmQuICBJdCBkb2VzIHN1ZmZlciBmcm9tIGEgYml0IG9mIGFu
IGluLWJhbmQNCj4gc2lnbmFsaW5nIHByb2JsZW0sIHRob3VnaCwgaW4gdGhhdCBpdCdzIHBvc3Np
YmxlIHRoYXQgc29tZSBvdGhlciByYW5kb20NCj4gYnl0ZXMgaW4gdGhlIGxpYnJhcnkgcmVzZW1i
bGUgYSBTSUdTVFJVQ1QuDQo+IA0KPiA+IEkgd2FzIG5vdCBzYXlpbmcgZW5jbGF2ZXMgd2VyZSBl
eGVtcHQgdG8gZ29vZCBzZWN1cml0eSBwcmFjdGljZXMuIFdoYXQNCj4gSSB3YXMgdHJ5aW5nIHRv
IHNheSB3YXMsIEVQQyBwYWdlcyBhcmUgKm5vdCogc3ViamVjdCB0byB0aGUgc2FtZSBhdHRhY2tz
DQo+IGFzIHJlZ3VsYXIgcGFnZXMgc28gSSBzdXNwZWN0IHRoZXJlIHdpbGwgYmUgYSBkZXNpcmUg
dG8gZW5mb3JjZQ0KPiBkaWZmZXJlbnQgcG9saWNpZXMgb24gdGhlbSwgZXNwZWNpYWxseSBhZnRl
ciBuZXcgU0dYMg0KPiBmZWF0dXJlcy9hcHBsaWNhdGlvbnMgYmVjb21lIGF2YWlsYWJsZS4gU28g
SSB0aGluayBpdCBiZW5lZmljaWFsIHRvDQo+IGRpc3Rpbmd1aXNoIGJldHdlZW4gcmVndWxhciB2
cy4gZW5jbGF2ZSB2aXJ0dWFsIHJhbmdlcy4gQW5kIHRvIGRvIHRoYXQsDQo+IGEgbmV3IFZNX1NH
WCBmbGFnIGluIFZNQSBpcyBwcm9iYWJseSBhIHZlcnkgc2ltcGxlL2Vhc3kgd2F5LiBBbmQgd2l0
aA0KPiB0aGF0IFZNX1NHWCBmbGFnLCB3ZSBjb3VsZCBhZGQgYSBuZXcgc2VjdXJpdHlfc2d4X21w
cm90KCkgaG9vayBzbyB0aGF0DQo+IExTTSBtb2R1bGVzL3BvbGljaWVzIGNvdWxkIGFjdCBkaWZm
ZXJlbnRseS4NCj4gDQo+IEknbSBub3Qgb3Bwb3NlZCB0byB0aGlzLCBidXQgSSBhbHNvIGRvbid0
IHRoaW5rIHRoaXMgbmVlZHMgdG8gYmUgaW4gdGhlDQo+IGluaXRpYWwgdXBzdHJlYW0gZHJpdmVy
LiAgVk1fU0dYIGFsc28gaXNuJ3Qgc3RyaWN0bHkgbmVjZXNzYXJ5IC0tIGFuIExTTQ0KPiBjb3Vs
ZCBpbnNwZWN0IHRoZSBWTUEgdG8gZGVjaWRlIHdoZXRoZXIgaXQncyBhbiBTR1ggVk1BIGlmIGl0
IHJlYWxseQ0KPiB3YW50ZWQgdG8uDQoNClZNX1NHWCBpcyBqdXN0IHdoYXQgSSB0aGluayBpcyB0
aGUgZWFzaWVzdCB3YXkgZm9yIGFueSBtb2R1bGUgdG8gdGVsbCBlbmNsYXZlIFZNQXMgZnJvbSBh
bGwgb3RoZXJzLiBJIGFncmVlIHRvdGFsbHkgd2l0aCB5b3UgdGhhdCBkb2Vzbid0IGhhdmUgdG8g
YmUgaW4gdGhlIGluaXRpYWwgcmVsZWFzZSENCg0KPiANCj4gVGhhdCBiZWluZyBzYWlkLCBkbyB5
b3UgaGF2ZSBhbnkgc3BlY2lmaWMgYmVoYXZpb3IgZGlmZmVyZW5jZXMgaW4gbWluZA0KPiBhc2lk
ZSBmcm9tIHRoZSBvZGRpdGllcyBpbnZvbHZlZCBpbiBsb2FkaW5nIHRoZSBlbmNsYXZlLg0KDQpU
aGUgbWFqb3IgdGhpbmcgaXMgZHluYW1pY2FsbHkgbGlua2VkIGVuY2xhdmVzLiBTYXkgaWYgeW91
IHdhbnQgc29tZXRoaW5nIGxpa2UgZGxvcGVuKCkgaW5zaWRlIGFuIGVuY2xhdmUsIHRoZSBkcml2
ZXIgd291bGQgbmVlZCB0byBFQVVHIGEgcGFnZSBhcyBSVyBpbml0aWFsbHksIGFuZCB0aGVuIGNo
YW5nZSB0byBSWCBhZnRlciBpdCBoYXMgYmVlbiBFQUNDRVBUQ09QWSdlZCBieSB0aGUgZW5jbGF2
ZS4gU28gaXQncyBsaWtlIGEgUlctPlJYIHRyYW5zaXRpb24gYW5kIGFuIExTTSBtb2R1bGUvcG9s
aWN5IG1heSB3YW50IHRvIGFsbG93IGl0IG9ubHkgaWYgaXQncyB3aXRoaW4gYW4gZW5jbGF2ZSBy
YW5nZSAoRUxSQU5HRSksIG9yIGRlbnkgaXQgb3RoZXJ3aXNlLg0KDQo+IA0KPiA+DQo+ID4gQW5k
IGlmIHlvdSBhcmUgd2l0aCBtZSBvbiB0aGF0IGJpZ2dlciBwaWN0dXJlLCB0aGUgbmV4dCBxdWVz
dGlvbiBpczoNCj4gd2hhdCBzaG91bGQgYmUgdGhlIGRlZmF1bHQgYmVoYXZpb3Igb2Ygc2VjdXJp
dHlfc2d4X21wcm90KCkgZm9yDQo+IGV4aXN0aW5nL25vbi1TR1gtYXdhcmUgTFNNIG1vZHVsZXMv
cG9saWNpZXM/IEknZCBzYXkgYSByZWFzb25hYmxlDQo+IGRlZmF1bHQgaXMgdG8gYWxsb3cgUiwg
UlcgYW5kIFJYLCBidXQgbm90IGFueXRoaW5nIGVsc2UuIEl0J2Qgc3VmZmljZSB0bw0KPiBnZXQg
cmlkIG9mIEVYRUNNRU0vRVhFQ01PRCByZXF1aXJlbWVudHMgb24gZW5jbGF2ZSBhcHBsaWNhdGlv
bnMuIEZvcg0KPiBTR1gxLCBFUENNIHBlcm1pc3Npb25zIGFyZSBpbW11dGFibGUgc28gaXQgcmVh
bGx5IGRvZXNuJ3QgbWF0dGVyIHdoYXQNCj4gc2VjdXJpdHlfc2d4X21wcm90KCkgZG9lcy4gRm9y
IFNHWDIgYW5kIGJleW9uZCwgdGhlcmUncyBzdGlsbCB0aW1lIGFuZA0KPiBuZXcgU0dYLWF3YXJl
IExTTSBtb2R1bGVzL3BvbGljaWVzIHdpbGwgcHJvYmFibHkgaGF2ZSBlbWVyZ2VkIGJ5IHRoZW4u
DQo+IA0KPiBJIGhhZG4ndCB0aG91Z2h0IGFib3V0IHRoZSBTR1gxIHZzIFNHWDIgZGlmZmVyZW5j
ZS4gIElmIHRoZSBkcml2ZXINCj4gaW5pdGlhbGx5IG9ubHkgd2FudHMgdG8gc3VwcG9ydCBTR1gx
LCB0aGVuIEkgZ3Vlc3Mgd2UgcmVhbGx5IGNvdWxkIGdldA0KPiBhd2F5IHdpdGggY29uc3RyYWlu
aW5nIHRoZSBFUEMgZmxhZ3MgYmFzZWQgb24gdGhlIHNvdXJjZSBwYWdlIHBlcm1pc3Npb24NCj4g
YW5kIG5vdCByZXN0cmljdGluZyBtcHJvdGVjdCgpIGFuZCBtbWFwKCkgcGVybWlzc2lvbnMgb24N
Cj4gL2Rldi9zZ3gvZW5jbGF2ZSBhdCBhbGwuDQoNClRoaXMgaXMgZXhhY3RseSB3aGF0IEknbSBn
b2luZyBhZnRlciEgDQoNCkJ1dCBJIGhhdmUgdG8gYXBvbG9naXplIGZvciB0aGlzIHNpbGx5IHF1
ZXN0aW9uIGJlY2F1c2UgSSBkb24ndCBrbm93IG11Y2ggYWJvdXQgU0VMaW51eDogV291bGRuJ3Qg
aXQgcmVxdWlyZSBjaGFuZ2VzIHRvIGV4aXN0aW5nIFNFTGludXggcG9saWNpZXMgdG8gKm5vdCog
cmVzdHJpY3QgbXByb3RlY3QoKSBvbiAvZGV2L3NneC9lbmNsYXZlPw0KDQotQ2VkcmljDQo=
