Return-Path: <SRS0=nHr/=TO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5109C04AB4
	for <linux-sgx@archiver.kernel.org>; Tue, 14 May 2019 22:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98ECB20879
	for <linux-sgx@archiver.kernel.org>; Tue, 14 May 2019 22:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfENW2z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 May 2019 18:28:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:16607 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfENW2y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 May 2019 18:28:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 15:28:54 -0700
X-ExtLoop1: 1
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga006.fm.intel.com with ESMTP; 14 May 2019 15:28:53 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 14 May 2019 15:28:53 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.185]) with mapi id 14.03.0415.000;
 Tue, 14 May 2019 15:28:53 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Subject: RE: [PATCH v20 00/28] Intel SGX1 support
Thread-Topic: [PATCH v20 00/28] Intel SGX1 support
Thread-Index: AQHU9QnxaoiNNkdqP0yJjajWChyAgKZCnqeAgAAN+QCAAVPmAIAAE4cAgABGGYCAABE4gIAAAfWAgAABFgCAAADiAIAABegAgAABOYCAAAN6gIAAAQAAgAAA2wCAAATlgIAEWt6AgBvkEoCAAHnYgIAABJkAgAAC6gD//5XxkIAAergAgAAFGwCABCIJAIABljuAgABLfwCAAFy4gIAAC6YA//+UP9A=
Date:   Tue, 14 May 2019 22:28:52 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654E1213@ORSMSX116.amr.corp.intel.com>
References: <960B34DE67B9E140824F1DCDEC400C0F4E885F9D@ORSMSX116.amr.corp.intel.com>
 <979615a8-fd03-e3fd-fbdb-65c1e51afd93@fortanix.com>
 <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
In-Reply-To: <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTQyNWM2MjEtMTZhZS00ZTMzLThmMDUtNjBjNGQzZjdkMmY3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibk5BOU5ob0NIV0dDSDNGQmlOYVNxYUhhb1wvRFFnRndBS3c0cnQ4MEFRVU5RTjVcLzVhcWlWSVpCbmQwTFwvVHQzSyJ9
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

SGkgQW5keSwNCg0KPiBMZXQgbWUgbWFrZSBzdXJlIEknbSB1bmRlcnN0YW5kaW5nIHRoaXMgY29y
cmVjdGx5OiB3aGVuIGFuIGVuY2xhdmUgdHJpZXMNCj4gdG8gZXhlY3V0ZSBjb2RlLCBpdCBvbmx5
IHdvcmtzIGlmICpib3RoKiB0aGUgRVBDTSBhbmQgdGhlIHBhZ2UgdGFibGVzDQo+IGdyYW50IHRo
ZSBhY2Nlc3MsIHJpZ2h0PyAgVGhpcyBzZWVtcyB0byBiZSB0aGF0IDM3LjMgaXMgdHJ5aW5nIHRv
IHNheS4NCj4gU28gd2Ugc2hvdWxkIHByb2JhYmx5IGp1c3QgaWdub3JlIFNFQ0lORk8gZm9yIHRo
ZXNlIHB1cnBvc2VzLg0KPiANCj4gQnV0IHRoaW5raW5nIHRoaXMgYWxsIHRocm91Z2gsIGl0J3Mg
YSBiaXQgbW9yZSBjb21wbGljYXRlZCB0aGFuIGFueSBvZg0KPiB0aGlzLiAgTG9va2luZyBhdCB0
aGUgU0VMaW51eCBjb2RlIGZvciBpbnNwaXJhdGlvbiwgdGhlcmUgYXJlIHF1aXRlIGENCj4gZmV3
IHBhdGhzLCBidXQgdGhleSBib2lsIGRvd24gdG8gdHdvIGNhc2VzOiBFWEVDVVRFIGlzIHRoZSBy
aWdodCB0byBtYXANCj4gYW4gdW5tb2RpZmllZCBmaWxlIGV4ZWN1dGFibHksIGFuZCBFWEVDTU9E
L0VYRUNNRU0gKHRoZSBkaXN0aW5jdGlvbg0KPiBzZWVtcyBtb3N0bHkgaXJyZWxldmFudCkgaXMg
dGhlIHJpZ2h0IHRvIGNyZWF0ZSAodmlhIG1tYXAgb3IgbXByb3RlY3QpIGENCj4gbW9kaWZpZWQg
YW5vbnltb3VzIGZpbGUgbWFwcGluZyBvciBhIG5vbi1maWxlLWJhY2tlZCBtYXBwaW5nIHRoYXQg
aXMNCj4gZXhlY3V0YWJsZS4gIFNvLCBpZiB3ZSBkbyBub3RoaW5nLCB0aGVuIG1hcHBpbmcgYW4g
ZW5jbGF2ZSB3aXRoIGV4ZWN1dGUNCj4gcGVybWlzc2lvbiB3aWxsIHJlcXVpcmUgZWl0aGVyIEVY
RUNVVEUgb24gdGhlIGVuY2xhdmUgaW5vZGUgb3INCj4gRVhFQ01PRC9FWEVDTUVNLCBkZXBlbmRp
bmcgb24gZXhhY3RseSBob3cgdGhpcyBnZXRzIHNldCB1cC4NCj4gDQo+IFNvIGFsbCBpcyB3ZWxs
LCBzb3J0IG9mLiAgVGhlIHByb2JsZW0gaXMgdGhhdCBJIGV4cGVjdCB0aGVyZSB3aWxsIGJlDQo+
IHBlb3BsZSB3aG8gd2FudCBlbmNsYXZlcyB0byB3b3JrIGluIGEgcHJvY2VzcyB0aGF0IGRvZXMg
bm90IGhhdmUgdGhlc2UNCj4gcmlnaHRzLiAgVG8gbWFrZSB0aGlzIHdvcmssIHdlIHByb2JhYmx5
IG5lZWQgZG8gc29tZSBzdXJnZXJ5IG9uIFNFTGludXguDQo+IElTVE0gdGhlIGFjdCBvZiBjb3B5
aW5nICh2aWEgdGhlIEVBREQgaW9jdGwpIGRhdGEgZnJvbSBhIFBST1RfRVhFQw0KPiBtYXBwaW5n
IHRvIGFuIGVuY2xhdmUgc2hvdWxkIG5vdCBiZSBjb25zdHJ1ZWQgYXMgIm1vZGlmeWluZyINCj4g
dGhlIGVuY2xhdmUgZm9yIFNFTGludXggcHVycG9zZXMuICBBY3R1YWxseSBkb2luZyB0aGlzIGNv
dWxkIGJlIGF3a3dhcmQsDQo+IHNpbmNlIHRoZSBzYW1lIGlub2RlIHdpbGwgaGF2ZSBleGVjdXRh
YmxlIHBhcnRzIGFuZCBub24tZXhlY3V0YWJsZSBwYXJ0cywNCj4gYW5kIFNFTGludXggY2FuJ3Qg
cmVhbGx5IHRlbGwgdGhlIGRpZmZlcmVuY2UuDQo+IA0KDQpFbmNsYXZlIGZpbGVzIGFyZSBwcmV0
dHkgbXVjaCBsaWtlIHNoYXJlZCBvYmplY3RzIGluIHRoYXQgdGhleSBib3RoIGNvbnRhaW4gZXhl
Y3V0YWJsZSBjb2RlIG1hcHBlZCBpbnRvIHRoZSBob3N0IHByb2Nlc3MncyBhZGRyZXNzIHNwYWNl
LiBEbyBzaGFyZWQgb2JqZWN0cyBuZWVkIEVYRUNVVEUgdG8gYmUgbWFwcGVkIGV4ZWN1dGFibGU/
IElmIHNvLCB3aHkgd291bGQgcGVvcGxlIG5vdCB3YW50IEVYRUNVVEUgaW4gZW5jbGF2ZSBmaWxl
cz8NCg0KV3J0IHRvIHdoaWNoIHBhcnQgb2YgYW4gZXhlY3V0YWJsZSBmaWxlIGlzIGV4ZWN1dGFi
bGUsIHRoZSBsaW1pdGF0aW9uIHJlc2lkZXMgaW4gc2VjdXJpdHlfbW1hcF9maWxlKCksIHdoaWNo
IGRvZXNuJ3QgdGFrZSB0aGUgcmFuZ2Ugb2YgYnl0ZXMgYXMgaW5wdXQuIEl0IGlzbid0IFNHWCBz
cGVjaWZpYy4gSSdkIHNheSBqdXN0IGxldCBlbmNsYXZlcyBpbmhlcml0IGFwcGxpY2FibGUgY2hl
Y2tzIGZvciBzaGFyZWQgb2JqZWN0cy4gVGhlbiBpdCB3aWxsIGFsc28gaW5oZXJpdCBhbGwgZnV0
dXJlIGVuaGFuY2VtZW50cyB0cmFuc3BhcmVudGx5Lg0KDQo+IE1heWJlIHRoZSBlbmNsYXZlIHNo
b3VsZCB0cmFjayBhIGJpdG1hcCBvZiB3aGljaCBwYWdlcyBoYXZlIGV2ZXIgYmVlbg0KPiBlaXRo
ZXIgbWFwcGVkIGZvciB3cml0ZSBvciBFQUREZWQgd2l0aCBhICpzb3VyY2UqIHRoYXQgd2Fzbid0
IFBST1RfRVhFQy4NCj4gQW5kIHRoZW4gU0VMaW51eCBjb3VsZCBsZWFybiB0byBhbGxvdyB0aG9z
ZSBwYWdlcyAoYW5kIG9ubHkgdGhvc2UgcGFnZXMpDQo+IHRvIGJlIG1hcHBlZCBleGVjdXRhYmx5
IHdpdGhvdXQgRVhFQ1VURSBvciBFWEVDTU9EIG9yIHdoYXRldmVyDQo+IHBlcm1pc3Npb24uDQoN
CldoYXQgZG8geW91IG1lYW4gYnkgImVuY2xhdmUiIGhlcmU/IFRoZSBlbmNsYXZlIHJhbmdlIChF
TFJBTkdFKSBjcmVhdGVkIGJ5IG1tYXAoKSdpbmcgL2Rldi9zZ3gvZW5jbGF2ZSBkZXZpY2U/IE15
IGFyZ3VtZW50IGlzLCBhbiBlbmNsYXZlJ3Mgc2FuaXR5L2luc2FuaXR5IGlzIGRldGVybWluZWQg
YXQgbG9hZCB0aW1lIChFQUREL0VFWFRFTkQgYW5kIEVJTklUKSBhbmQgYWxsIHBhZ2UgYWNjZXNz
ZXMgYXJlIGVuZm9yY2VkIGJ5IEVQQ00sIHNvIFBURSBwZXJtaXNzaW9ucyByZWFsbHkgZG9uJ3Qg
bWF0dGVyLiBBcyBJIGRpc2N1c3NlZCBpbiBhbiBlYXJsaWVyIGVtYWlsLCBJJ2QgYWxsb3cgUldY
IGZvciBhbnkgcmFuZ2UgYmFja2VkIGJ5IC9kZXYvc2d4L2VuY2xhdmUgZGV2aWNlIGZpbGUgYnkg
ZGVmYXVsdCwgdW5sZXNzIGFuIFNHWC1hd2FyZSBMU00gbW9kdWxlL3BvbGljeSBvYmplY3RzIHRv
IHRoYXQgKGUuZy4gdmlhIGEgbmV3IHNlY3VyaXR5X3NneF9tcHJvdGVjdCgpIExTTSBob29rKS4N
Cg0KPiANCj4gRG9lcyB0aGlzIHNlZW0gYXQgYWxsIHJlYXNvbmFibGU/DQo+IA0KPiBJIHN1cHBv
c2UgaXQncyBub3QgdGhlIGVuZCBvZiB0aGUgd29ybGQgaWYgdGhlIGluaXRpYWxseSBtZXJnZWQg
dmVyc2lvbg0KPiBkb2Vzbid0IGRvIHRoaXMsIGFzIGxvbmcgYXMgdGhlcmUncyBzb21lIHJlYXNv
bmFibGUgcGF0aCB0byBhZGRpbmcgYQ0KPiBtZWNoYW5pc20gbGlrZSB0aGlzIHdoZW4gdGhlcmUn
cyBkZW1hbmQgZm9yIGl0Lg0KDQpBZ3JlZWQhDQoNCi1DZWRyaWMNCg==
