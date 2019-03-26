Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591A4C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 04:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1905620823
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 04:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbfCZEQu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 00:16:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:43852 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbfCZEQu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 00:16:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Mar 2019 21:16:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="137422886"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga007.fm.intel.com with ESMTP; 25 Mar 2019 21:16:48 -0700
Received: from orsmsx163.amr.corp.intel.com (10.22.240.88) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 25 Mar 2019 21:16:48 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX163.amr.corp.intel.com ([169.254.9.144]) with mapi id 14.03.0415.000;
 Mon, 25 Mar 2019 21:16:48 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Topic: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fwgACBcQD//5sEUIADt/WAgADIIJCAAMRtgP//souwgAOYIID//8YcwA==
Date:   Tue, 26 Mar 2019 04:16:46 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E85FA7B@ORSMSX116.amr.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
 <20190322215903.GE12666@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
 <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com>
 <CALCETrWdc2d2HJ-aoE7-889sHN-YJiKXrEkssyWJ6QQTykb+EQ@mail.gmail.com>
In-Reply-To: <CALCETrWdc2d2HJ-aoE7-889sHN-YJiKXrEkssyWJ6QQTykb+EQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTNjNzAyNDMtMWVhMC00NTZkLWE5NzctNDM4M2JkOTU3ZGJlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidjNZYWZXNlFtZE95V3NMVFJheFYzNm0rbFhMMDVuRytuVGVncDRPN1dKaTJ1RlVTNFZmVVI2bkEwYjhpdWg4ciJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBJIHRoaW5rIHlvdSdyZSBtaXN1bmRlcnN0YW5kaW5nIG1lLiAgSSdtIG5vdCB0YWxraW5nIGFi
b3V0IHNlY3VyaXR5IGF0DQo+IGFsbCBoZXJlLiAgU0dYIGlzbid0IGEgc2FuZGJveCwgZnVsbCBz
dG9wLiAgSSdtIHRhbGtpbmcgYWJvdXQgdGhlIGRlZ3JlZQ0KPiB0byB3aGljaCBhbiBTR1ggZW5j
bGF2ZSBhY3RzIGxpa2UgYSB3ZWxsLWJlaGF2ZWQgYmxhY2sgYm94Lg0KDQpBbnkgbWVhbmluZ2Z1
bCBjb21tdW5pY2F0aW9uIHJlcXVpcmVzIGFuIGFncmVlbWVudCBpbiBwbGFjZS4gVGhlIGhvc3Qg
YW5kIHRoZSBlbmNsYXZlIGNvdWxkIGJlIGVpdGhlciBpbiBhZ3JlZW1lbnQsIG9yIG5vdCBpbiBh
biBhZ3JlZW1lbnQuIEluIHRoZSBmb3JtZXIgY2FzZSwgdGhlIGVuY2xhdmUgd2lsbCBiZWhhdmUg
d2hpbGUgaW4gdGhlIGxhdHRlciBjYXNlIGl0IHdpbGwgbWlzYmVoYXZlLiBUaGUgdGhpbmcgaXMs
IGlmIGFuIGFncmVlbWVudCBiZXR3ZWVuIHRoZW0gc2F5cyAtICJEb24ndCB5b3UgZW5jbGF2ZSB0
b3VjaCB0aGUgc3RhY2siLCBhbmQgaWYgdGhlIGVuY2xhdmUgYmVoYXZlcywgdGhlbiBpdCB3b3Vs
ZG4ndCB0b3VjaCB0aGUgc3RhY2s7IG9yIHRoZSBlbmNsYXZlIG1pc2JlaGF2ZXMsIHRoZW4gdGhh
dCAiYWdyZWVtZW50IiBDQU5OT1Qgc3RvcCBpdCBmcm9tIGRvaW5nIHNvLCBSRUdBUkRMRVNTIHdo
YXQgdGhhdCBhZ3JlZW1lbnQgaXMuDQoNClRoZSBwb2ludCBpcywgYW4gYWdyZWVtZW50IG11c3Qg
ZXhpc3QgZm9yIGhvc3QvZW5jbGF2ZSBjb21tdW5pY2F0aW9uLiBUaGUgQUJJIGxpbWl0cyB3aGF0
IGtpbmRzIG9mIGFncmVlbWVudHMgdGhleSBjYW4gYmluZCB0bywgYnV0IGNhbiBORVZFUiBlbmZv
cmNlIGFuIGFncmVlbWVudC4gVGhlIGRpZmZlcmVuY2UgYmV0d2VlbiBTZWFuJ3MgQUJJIGFuZCBt
aW5lIGlzIHRoYXQgbWluZSBpcyBtb3JlIHJlbGF4aW5nIChpLmUuIGFsbG93cyBsYXJnZXIgdmFy
aWV0eSBvZiBhZ3JlZW1lbnRzKSBidXQgb3RoZXJ3aXNlIGlkZW50aWNhbCBmdW5jdGlvbmFsbHku
IEkgdHJ1bHkgaG9wZSB5b3UgY2FuIHVuZGVyc3RhbmQgdGhhdC4NCiANCj4gDQo+ID4NCj4gPiA+
IEnigJltIGdvaW5nIHRvIHB1dCBteSB2RFNPIG1haW50YWluZXIgaGF0IG9uIGZvciBhIG1pbnV0
ZS4gIENlZHJpYywNCj4gPiA+IHlvdXIgcHJvcG9zYWwgaGFzIHRoZSBmb2xsb3dpbmcgaXNzdWVz
IHJlbGF0ZWQgc3BlY2lmaWNhbGx5IHRvIHRoZQ0KPiB2RFNPOg0KPiA+ID4NCj4gPiA+IEl0IGlu
aGVyZW50bHkgY29udGFpbnMgaW5kaXJlY3QgYnJhbmNoZXMuICBUaGlzIG1lYW5zIHRoYXQsIG9u
DQo+ID4gPiByZXRwb2xpbmUgY29uZmlndXJhdGlvbnMsIGl0IHByb2JhYmx5IG5lZWRzIHRvIHVz
ZSByZXRwb2xpbmVzLiAgVGhpcw0KPiA+ID4gaXMgZG9hYmxlLCBidXQgaXTigJlzIG5hc3R5LCBh
bmQgeW91IG5lZWQgdG8gd29ycnkgYWJvdXQgcmVnaXN0ZXINCj4gY2xvYmJlcnMuDQo+ID4NCj4g
PiBPbmx5IHRoZSB3ZWFrZXN0IGxpbmsgbWF0dGVycyBpbiBzZWN1cml0eS4gV2l0aCBkeW5hbWlj
IGxpbmtpbmcgaW4NCj4gdXNlLCB0aGlzIGFkZGl0aW9uYWwgaW5kaXJlY3QgQ0FMTCBjYW4ndCBt
YWtlIHRoaW5ncyB3b3JzZS4gQnV0IEknbSBvcGVuDQo+IHRvLCBhbmQgaW4gZmFjdCBhbHNvIHdp
bGxpbmcgdG8sIGFwcGx5IHdoYXRldmVyIG1pdGlnYXRpb24gdGhhdCB5b3UNCj4gdGhpbmsgaXMg
c2F0aXNmYWN0b3J5IChvciB0aGF0IGhhcyBiZWVuIGFwcGxpZWQgdG8gb3RoZXIgaW5kaXJlY3QN
Cj4gYnJhbmNoZXMsIHN1Y2ggYXMgaW4gUExUKSwgc3VjaCBhcyByZXRwb2xpbmUuIEJ0dywgZG9u
J3Qgd29ycnkgYWJvdXQNCj4gcmVnaXN0ZXIgY2xvYmJlcnMgYmVjYXVzZSB3ZSBoYXZlIGF0IGxl
YXN0ICVyYXggYXQgb3VyIGRpc3Bvc2FsLg0KPiANCj4gVGhlcmUgaXMgbm8gYWN0dWFsIGZ1bmRh
bWVudGFsIHJlYXNvbiB0aGF0IGR5bmFtaWMgbGlua2luZyBoYXMgdG8gd29yaw0KPiB0aGlzIHdh
eSwgYW5kIGluIHByaW5jaXBsZSwgb25lIGNvdWxkIGV2ZW4gdXNlIHJldHBvbGluZXMgdG8gdGhl
IGNhbGwNCj4gdGhlIHZEU08uICBJbiBhbnkgZXZlbnQsIHRoZSB2RFNPIGlzIGN1cnJlbnRseSBj
b21waWxlZCB3aXRoIHJldHBvbGluZXMNCj4gZW5hYmxlZCwgYW5kIGlmIHdlIGRlY2lkZSB0byB0
dXJuIHRoYXQgb2ZmLCBpdCB3b3VsZCBiZSBkZWNpc2lvbiB0byBiZQ0KPiBtYWRlIGluZGVwZW5k
ZW50bHkgb2YgU0dYLg0KDQpEb24ndCBnZXQgbWUgd3JvbmchIEknbSBqdXN0IHNheWluZyBkeW5h
bWljIGxpbmtpbmcgcmVxdWlyZXMgaW5kaXJlY3QgYnJhbmNoZXMgc28gd2hhdGV2ZXIgbWl0aWdh
dGlvbiB1c2VkIHRoZXJlIGNhbiBhbHNvIGFwcGx5IGhlcmUuIEknbSB3aWxsaW5nIHRvIGltcGxl
bWVudCB0aGUgc2FtZSBtZWNoYW5pc20gYXMgZ2VuZXJhbGx5IGFjY2VwdGVkIGluIG90aGVyIG9j
Y2FzaW9ucy4gSWYgcmV0cG9saW5lIGlzIHRoZSBvbmUgdGhlbiBJIHdpbGwganVzdCBkbyBpdC4N
Cg0KQnR3LCByZXRwb2xpbmUgd29uJ3Qgd29yayB3aXRoIENFVCB0aG91Z2guDQoNCj4gDQo+ID4N
Cj4gPiA+DQo+ID4gPiBJdCB1c2VzIGVmZmVjdGl2ZWx5IHVuYm91bmRlZCBzdGFjayBzcGFjZS4g
VGhlIHZEU08gdGltaW5nIGZ1bmN0aW9ucw0KPiA+ID4gYXJlIGFscmVhZHkgYSBwcm9ibGVtIGZv
ciBHbywgYW5kIHRoaXMgaXMgd29yc2UuDQo+ID4NCj4gPiBJZiB0YXJnZXRpbmcgdGhlIHNhbWUg
ZnVuY3Rpb25hbGl0eSAoaS5lLiBubyBleGl0IGNhbGxiYWNrKSwgbXkgQVBJDQo+IHVzZXMgZXhh
Y3RseSAyNCBieXRlcyBtb3JlIHRoYW4gU2VhbidzLiBJcyBpdCByZWFsbHkgdGhlIGNhc2UgdGhh
dCB0aG9zZQ0KPiAyNCBieXRlcyB3aWxsIGJyZWFrIEdvPw0KPiANCj4gWW91J3JlIGNvdW50aW5n
IHdyb25nLiAgWW91ciB2ZXJzaW9uIHVzZXMgMjQgYnl0ZXMgKyB0aGUgc3RhY2sgc2l6ZSBvZg0K
PiB0aGUgZXhpdCBoYW5kbGVyICsgdGhlIGFtb3VudCBvZiBzdGFjayBjb25zdW1lZCBieSB0aGUg
ZW5jbGF2ZSwgd2hpY2ggaXMNCj4gZWZmZWN0aXZlbHkgdW5ib3VuZGVkLiAgU28gdGhpcyB3aG9s
ZSBzY2hlbWUgYmVjb21lcyB1bnVzYWJsZSBvbg0KPiBhbnl0aGluZyBvdGhlciB0aGFuIGEgc3Rh
Y2sgdGhhdCBpcyAibGFyZ2UiIGZvciBhIHRvdGFsbHkgdW5kZWZpbmVkDQo+IHZhbHVlIG9mIGxh
cmdlIGFuZCB0aGF0IGhhcyBndWFyZCBwYWdlcy4NCg0KWW91IG1pc3JlYWQuIEkgc2FpZCAidGFy
Z2V0aW5nIHRoZSBzYW1lIGZ1bmN0aW9uYWxpdHkiLCBtZWFuaW5nIG5vIGV4aXQgY2FsbGJhY2sg
aXMgdXNlZCAoYmVjYXVzZSBTZWFuJ3MgQUJJIGRvZXNuJ3Qgc3VwcG9ydCBpdCkuIEFuZCBiZWNh
dXNlIG5vIGNhbGxiYWNrcyB3aWxsIGJlIG1hZGUsIG9ubHkgMjQgbW9yZSBieXRlcyB3aWxsIGJl
IG5lZWRlZC4NCg0KQW5kIGF0IHRoaXMgcG9pbnQgSSdtIHRyeWluZyB0byBzdHJlc3MgdGhlIGZh
Y3QgdGhhdCBteSBwcm9wb3NhbCBpcyBhIHN1cGVyc2V0IG9mIFNlYW4ncyBpbiB0ZXJtcyBvZiBm
dW5jdGlvbmFsaXR5IC0gaS5lLiBteSBwcm9wb3NhbCBjYW4gZG8gYWxsIHRoYXQgU2VhbidzIGNh
biBkby4gRm9yIGV4YW1wbGUsIGlmIHRoZSBlbmNsYXZlIGlzIGNvZGVkIE5PVCB0byB1c2UgdGhl
IHVudHJ1c3RlZCBzdGFjaywgZS5nLiBpbiBGb3J0YW5peCdzIGNhc2UsIHRoZW4gaXQgd29uJ3Qg
dXNlIHRoZSBzdGFjayBhbmQgdGhlIGNhbGxiYWNrIGlzIHVubmVjZXNzYXJ5IChhbmQgc2hhbGwg
YmUgc2V0IHRvIE5VTEwpLiBUaGF0IGlzLCBtaW5lIHdpbGwgd29yayBleGFjdGx5IHRoZSBzYW1l
IGFzIFNlYW4ncyBpbiB0aGUgY2FzZSBvZiBlbmNsYXZlIG5vdCB0b3VjaGluZyB0aGUgc3RhY2su
IE15IGFwb2xvZ3kgZm9yIGJlaW5nIGV4Y2Vzc2l2ZWx5IHZlcmJvc2UgaGVyZSBidXQgeW91ciBj
b21tZW50IGFib3ZlIHByb21wdHMgbWUgdGhhdCB5b3UgbWF5IE5PVCBoYXZlIHJlYWxpemVkIHRo
YXQgbXkgcHJvcG9zYWwgd2lsbCB3b3JrIGV4YWN0bHkgdGhlIFNBTUUgYXMgU2VhbidzIHdoZW4g
ZXhpdCBjYWxsYmFjayBpcyBhYnNlbnQgKE5VTEwpLg0KDQo+IA0KPiA+DQo+ID4gPg0KPiA+ID4g
Q2VkcmljLCB5b3VyIHByb3Bvc2FsIGFsbG93cyBhbiBlbmNsYXZlIHRvIG11Y2sgd2l0aCBSU1As
IGJ1dCBub3QgaW4NCj4gPiA+IGEgd2F5IHRoYXTigJlzIHBhcnRpY3VsYXJseSBwbGVhc2FudC4N
Cj4gPg0KPiA+IEZyb20gc2VjdXJpdHkgcGVyc3BlY3RpdmUsIGl0IGlzIFNHWCBJU0EsIGJ1dCBO
T1QgYW55IHBhcnRpY3VsYXIgQUJJLA0KPiB0aGF0IGFsbG93cyBlbmNsYXZlcyAidG8gbXVjayB3
aXRoIFJTUCIuDQo+IA0KPiBBZ2FpbiwgdGhpcyBoYXMgbm90aGluZyB0byBkbyB3aXRoIHNlY3Vy
aXR5LiAgV2l0aCB5b3VyIHByb3Bvc2FsLCBpdCdzDQo+IG5vdCBwb3NzaWJsZSBmb3IgdGhlIGNh
bGxlciBvZiBhbiBlbmNsYXZlIHRvIGRlY2lkZSwgaW4gYW4gb2NhbGwNCj4gaGFuZGxlciwgdG8g
cGF1c2UgYW5kIGRvIHNvbWV0aGluZyBlbHNlLiAgVGhpcyBpc24ndCBqdXN0IHRoZW9yZXRpY2Fs
Lg0KPiBTdXBwb3NlIHNvbWVvbmUgd2FudHMgdG8gc2VuZCBhIG5ldHdvcmsgcmVxdWVzdCBpbiBh
biBvY2FsbCBoYW5kbGVyLg0KPiBXaXRoIHRoZSBjdXJyZW50IFJTUCBhcHByb2FjaCwgaXQncyBk
aWZmaWN1bHQgdG8gZG8gdGhpcyBpbiBhIHByb2dyYW0NCj4gdGhhdCB1c2VzIHBvbGwgLyBzZWxl
Y3QgLyBlcG9sbCAtLSB5b3UgY2FuJ3QgcmV0dXJuIG91dCBmcm9tIHRoZSBvY2FsbA0KPiB1bnRp
bCB5b3UgaGF2ZSBhbiBhbnN3ZXIuDQoNCkFuZHksIHlvdXIgY29tbWVudCBoZXJlIGZ1cnRoZXIg
Y29uZmlybXMgdGhhdCB5b3UgaGF2ZSBOT1QgdW5kZXJzdG9vZCBteSBwcm9wb3NhbC4NCg0KSW4g
dGhlIGNhc2UgdGhlIG8tY2FsbCBwYXJhbWV0ZXJzIGFyZSBwYXNzZWQgaW4gcmVnaXN0ZXJzIChv
ciBzZXBhcmF0ZSBidWZmZXJzKSwgZXhpdCBoYW5kbGVyIGlzIE5PVCBuZWVkZWQgKGFuZCBzaG91
bGQgYmUgc2V0IHRvIE5VTEwpLCBhbmQgdGhlIEFQSSB3aWxsIGp1c3QgcmV0dXJuIGF0IEVFWElU
LCBhbmQgdGhlbiB0aGUgY2FsbGVyIGNhbiBkaXNwYXRjaCB0aGUgby1jYWxsIHNvbGVseSBiYXNl
ZCBvbiByZWdpc3RlciB2YWx1ZXMsIHdoaWNoIGlzIGV4YWN0bHkgdGhlIFNBTUUgYXMgU2Vhbidz
IHByb3Bvc2FsLg0KDQpBbiBleGl0IGhhbmRsZXIgaXMgTk9UIG5lY2Vzc2FyeSB0byBzdXBwb3J0
IG8tY2FsbHMuIEl0IGlzIG5lZWRlZCBPTkxZIGlmIHRoZSBob3N0L2VuY2xhdmUgZXhjaGFuZ2Vz
IGRhdGEgb24gdGhlIHN0YWNrLg0KDQpNeSBhcG9sb2d5IGFnYWluIGZvciByZXBlYXRpbmcgbXlz
ZWxmLCBidXQgbXkgcHJvcG9zYWwgaXMgYSBTVVBFUlNFVCBvZiBTZWFuJ3MgZnJvbSBmdW5jdGlv
bmFsIHBlcnNwZWN0aXZlLCBhbmQgaXQgd2lsbCB3b3JrIGluIEVYQUNUTFkgdGhlIFNBTUUgd2F5
IGFzIFNlYW4ncyBpbiBBTEwgYXNwZWN0cyB3aGVuIGV4aXQgY2FsbGJhY2sgaXMgYWJzZW50LiBT
byB5b3UgcmVhbGx5IGhhdmUgTk9USElORyB0byB3b3JyeSBhYm91dCBmcm9tIGZ1bmN0aW9uYWwg
c3RhbmQgcG9pbnQhIEFuZCBhcyB5b3Ugc2FpZCB5b3UgZG9uJ3Qgd29ycnkgYWJvdXQgc2VjdXJp
dHkgZWl0aGVyLCB0aGVuIHlvdSByZWFsbHkgaGF2ZSBOT1RISU5HIHRvIHdvcnJ5IGFib3V0IQ0K
DQotQ2VkcmljIA0K
