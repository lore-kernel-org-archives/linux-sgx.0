Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B32C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 19:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB41521841
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 19:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbfCTT64 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 15:58:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:64215 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbfCTT64 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 15:58:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 12:57:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="127167178"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2019 12:57:53 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX106.amr.corp.intel.com ([169.254.1.19]) with mapi id 14.03.0415.000;
 Wed, 20 Mar 2019 12:57:52 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fwgAB7nID//4szkA==
Date:   Wed, 20 Mar 2019 19:57:52 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E85C53D@ORSMSX116.amr.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <CALCETrVKAUK-jZ7Knp7RetTL055p3iK1D8Wyr6=hPq5HkePkFg@mail.gmail.com>
In-Reply-To: <CALCETrVKAUK-jZ7Knp7RetTL055p3iK1D8Wyr6=hPq5HkePkFg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2E4OTNhZDQtZWI2ZS00MDRmLTliMmUtYjU2Mjk4ZmE1YzMzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidW1sdnlmTnpLK3BEeHdIN2FncE4xdURXSVd5STA1U3h6TjFlMlFpd1lnbENoQTB1U2MrMjRCSUdzVlg3a1RBQiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBVc2luZyB0aGUgdW50cnVzdGVkIHN0YWNrIGFzIGEgd2F5IHRvIGV4Y2hhbmdlIGRhdGEgaXMg
dmVyeSBjb252ZW5pZW50LA0KPiBidXQgdGhhdCBkb2Vzbid0IG1lYW4gaXQncyBhIGdvb2QgaWRl
YS4gIEhlcmUgYXJlIHNvbWUgcHJvYmxlbXMgaXQNCj4gY2F1c2VzOg0KPiANCj4gIC0gSXQgcHJl
dmVudHMgdXNpbmcgYSBub3JtYWwgZnVuY3Rpb24gdG8gd3JhcCBlbmNsYXZlIGVudHJ5IChhcyB3
ZSdyZQ0KPiBzZWVpbmcgd2l0aCB0aGlzIHBhdGNoIHNldCkuDQoNCkl0IGRvZXNuJ3QgcHJldmVu
dC4gSXQncyBhbGwgYWJvdXQgd2hhdCdzIGFncmVlZCBiZXR3ZWVuIHRoZSBlbmNsYXZlIGFuZCBp
dHMgaG9zdGluZyBwcm9jZXNzLiBXaXRoIHRoZSBvcHRpb25hbCAiZXhpdC9leGNlcHRpb24gY2Fs
bGJhY2siIHNldCB0byBudWxsLCB0aGlzIHdpbGwgYmVoYXZlIGV4YWN0bHkgdGhlIHNhbWUgYXMg
aW4gdGhlIGN1cnJlbnQgcGF0Y2guIFRoYXQncyB3aGF0IEkgbWVhbnQgYnkgImZsZXhpYmlsaXR5
IiBhbmQgInN1cGVyc2V0IG9mIGZ1bmN0aW9uYWxpdHkiLg0KDQo+IA0KPiAgLSBJdCBtYWtlcyBx
dWl0ZSBhIGZldyB1bmZvcnR1bmF0ZSBhc3N1bXB0aW9ucyBhYm91dCB0aGUgbGF5b3V0IG9mIHRo
ZQ0KPiB1bnRydXN0ZWQgc3RhY2suICBJdCBhc3N1bWVzIHRoYXQgdGhlIHVudHJ1c3RlZCBzdGFj
ayBpcyBhcmJpdHJhcmlseQ0KPiBleHBhbmRhYmxlLCB3aGljaCBpcyBlbnRpcmVseSB1bnRydWUg
aW4gbGFuZ3VhZ2VzIGxpa2UgR28uDQoNCkknbSB3aXRoIHlvdSB0aGF0IHN0YWNrIGlzIG5vdCBh
bHdheXMgZ29vZCB0aGluZywgaGVuY2UgSSdtIE5PVCBydWxpbmcgb3V0IGFueSBvdGhlciBhcHBy
b2FjaGVzIGZvciBleGNoYW5naW5nIGRhdGEuIEJ1dCBpcyBzdGFjayAiYmFkIiBlbm91Z2ggdG8g
YmUgcnVsZWQgb3V0IGNvbXBsZXRlbHk/IFRoZSBwb2ludCBoZXJlIGlzIGZsZXhpYmlsaXR5IGJl
Y2F1c2UgdGhlIHN0YWNrIGNvdWxkIGJlICJnb29kIiBmb3IgaXRzIGNvbnZlbmllbmNlLiBBZnRl
ciBhbGwsIG9ubHkgYnVmZmVycyBvZiAicmVhc29uYWJsZSIgc2l6ZXMgd2lsbCBiZSBleGNoYW5n
ZWQgaW4gbW9zdCBjYXNlcywgYW5kIGluIHRoZSByYXJlIGV4Y2VwdGlvbnMgb2Ygc3RhY2sgb3Zl
cmZsb3cgdGhleSdkIHByb2JhYmx5IGdldCBjYXVnaHQgaW4gdmFsaWRhdGlvbiBhbnl3YXkuIFRo
ZSBwb2ludCBoZXJlIGFnYWluIGlzIC0gZmxleGliaWxpdHkuIEknZCBzYXkgaXQncyBiZXR0ZXIg
dG8gbGVhdmUgdGhlIGNob2ljZSB0byB0aGUgU0RLIGltcGxlbWVudGVycyB0aGFuIHRvIGZvcmNl
IHRoZSBjaG9pY2Ugb24gdGhlbS4NCg0KPiBJdCBhc3N1bWVzIHRoYXQgdGhlIHVudHJ1c3RlZCBz
dGFjayBpc24ndCBmdXJ0aGVyIGNvbnN0cmFpbmVkIGJ5IHZhcmlvdXMNCj4gQ0ZJIG1lY2hhbmlz
bXMgKGUuZy4gQ0VUKSwgYW5kLCBhcyBvZiBsYXN0IHRpbWUgSSBjaGVja2VkLCB0aGUNCj4gaW50
ZXJhY3Rpb24gYmV0d2VlbiBDRVQgYW5kIFNHWCB3YXMgc3RpbGwgbm90IHNwZWNpZmllZC4gIA0K
DQpJIHdhcyBvbmUgb2YgdGhlIGFyY2hpdGVjdHMgcGFydGljaXBhdGluZyBpbiB0aGUgQ0VUIElT
QSBkZWZpbml0aW9uLiBUaGUgYXNzZW1ibHkgcHJvdmlkZWQgd2FzIGNyYWZ0ZWQgd2l0aCBDRVQg
aW4gbWluZCBhbmQgd2lsbCBiZSBmdWxseSBjb21wYXRpYmxlIHdpdGggQ0VULg0KDQo+IEl0IGFs
c28NCj4gYXNzdW1lcyB0aGF0IHRoZSB1bnRydXN0ZWQgc3RhY2sgZG9lc24ndCBoYXZlIEFCSS1p
bXBvc2VkIGxheW91dA0KPiByZXN0cmljdGlvbnMgcmVsYXRlZCB0byB1bndpbmRpbmcsIGFuZCwg
YXMgZmFyIGFzIEkga25vdywgdGhpcyBtZWFucw0KPiB0aGF0IGN1cnJlbnQgZW5jbGF2ZXMgd2l0
aCBjdXJyZW50IGVuY2xhdmUgcnVudGltZXMgY2FuIGludGVyYWN0IHF1aXRlDQo+IHBvb3JseSB3
aXRoIGRlYnVnZ2VycywgZXhjZXB0aW9uIGhhbmRsaW5nLCBhbmQgdmFyaW91cyBjcmFzaCBkdW1w
aW5nDQo+IHRlY2hub2xvZ2llcy4NCg0KUGVyIGNvbW1lbnRzIGZyb20gdGhlIHBhdGNoIHNldCwg
SSBndWVzcyBpdCdzIGJlZW4gYWdyZWVkIHRoYXQgdGhpcyB2RFNPIGZ1bmN0aW9uIHdpbGwgTk9U
IGJlIHg4Nl82NCBBQkkgY29tcGF0aWJsZS4gU28gSSdtIG5vdCBzdXJlIHdoeSBzdGFja2luZyB1
bndpbmRpbmcgaXMgcmVsZXZhbnQgaGVyZS4gSG93ZXZlciwgSSdtIHdpdGggeW91IHRoYXQgd2Ug
c2hvdWxkIHRha2UgZGVidWdnaW5nL2V4Y2VwdGlvbiBoYW5kbGluZy9yZXBvcnRpbmcvY3Jhc2gg
ZHVtcGluZyBpbnRvIGNvbnNpZGVyYXRpb24gYnkgbWFraW5nIHRoaXMgdkRTTyBBUEkgeDg2XzY0
IEFCSSBjb21wYXRpYmxlLiBJTU8gaXQncyB0cml2aWFsIGFuZCB0aGUgcGVyZm9ybWFuY2Ugb3Zl
cmhlYWQgaW4gbmVnbGlnaWJsZSAoZHdhcmZlZCBieSBFTkNMVSBhbnl3YXkuIEknZCBiZSBtb3Jl
IHRoYW4gaGFwcHkgdG8gcHJvdmlkZSBhIHg4Nl82NCBBQkkgY29tcGF0aWJsZSB2ZXJzaW9uIGlm
IHRoYXQncyBhbHNvIHlvdXIgcHJlZmVyZW5jZS4NCg0KPiAgLSBJdCB3aWxsIG1ha2UgaXQgcXVp
dGUgdW5wbGVhc2FudCB0byBjYWxsIGludG8gYW4gZW5jbGF2ZSBpbiBhDQo+IGNvcm91dGluZSBk
ZXBlbmRpbmcgb24gaG93IHRoZSBob3N0IHVudHJ1c3RlZCBydW50aW1lIGltcGxlbWVudHMNCj4g
Y29yb3V0aW5lcy4NCg0KSSdtIG5vdCBzdXJlIHdoYXQgeW91IGFyZSByZWZlcnJpbmcgdG8gYnkg
ImNvcm91dGluZSIuIEJ1dCB0aGlzIHZEU08gQVBJIHdpbGwgYmUgKGV4cGVjdGVkIHRvIGJlKSB0
aGUgb25seSByb3V0aW5lIHRoYXQgYWN0dWFsbHkgY2FsbHMgaW50byBhbiBlbmNsYXZlLiBJc24n
dCB0aGF0IGNvcnJlY3Q/DQoNCj4gDQo+IFNvIEkgdGhpbmsgaXQncyBhICpnb29kKiB0aGluZyBp
ZiB0aGUgZWZmZWN0IGlzIHRvIG1ha2UgZW5jbGF2ZSBTREtzDQo+IGNoYW5nZSB0aGVpciBtZW1v
cnkgbWFuYWdlbWVudCBzbyB0aGF0IHVudHJ1c3RlZCBidWZmZXJzIGFyZSBleHBsaWNpdGx5DQo+
IHN1cHBsaWVkIGJ5IHRoZSBob3N0IHJ1bnRpbWUuICANCg0KSW50ZWwgU0dYIFNESyB3aWxsIGNo
YW5nZSBubyBtYXR0ZXIgd2hhdC4gVGhlIHBvaW50IGlzIGZsZXhpYmlsaXR5LCBpcyB0byBvZmZl
ciBjaG9pY2VzIGFuZCBsZXQgU0RLIGltcGxlbWVudGVycyBkZWNpZGUsIGluc3RlYWQgb2YgZGVj
aWRpbmcgZm9yIHRoZW0gYWhlYWQgb2YgdGltZS4gDQoNCj4gSG9uZXN0bHksIEkgd291bGQgaGF2
ZSBtdWNoIHByZWZlcnJlZCBpZg0KPiB0aGUgYXJjaGl0ZWN0dXJlIGRpZCBub3QgZ2l2ZSB0aGUg
ZW5jbGF2ZSBhY2Nlc3MgdG8gUlNQIGFuZCBSQlAgYXQgYWxsLg0KPiAoQW5kLCBmb3IgdGhhdCBt
YXR0ZXIsIFJJUC4pDQoNClRoaXMgcmVtaW5kcyBtZSBvZiBQVVNIQS9QT1BBIGluc3RydWN0aW9u
cy4gV2Ugb25jZSB0aG91Z2h0IHRob3NlIGluc3RydWN0aW9uIHdvdWxkIGJlIGFwcHJlY2lhdGVk
IGJ5IGNvbXBpbGVycyBidXQgdGhlIGZhY3QgdHVybnMgb3V0IHRoYXQgbW9zdCBjb21waWxlcnMg
cHJlZmVyIGEgbWl4IG9mIGNhbGxlci1zYXZlZC9jYWxsZWUtc2F2ZWQgR1BScyBpbnN0ZWFkIG9m
IHRyZWF0aW5nIGFsbCBHUFJzIGNhbGxlciBvciBjYWxsZWUgc2F2ZWQuIFRoZW4gd2hlbiB3ZSBi
ZWxpZXZlZCBldmVyeW9uZSB3b3VsZCBwcmVmZXIgYSBtaXggYWZ0ZXIgc28gbWFueSB5ZWFycywg
YW4gZXhjZXB0aW9uIGVtZXJnZWQgYXMgR08gd2FzIGludmVudGVkLiBUaGF0IHNhaWQsIGZsZXhp
YmlsaXR5IGlzIHRoZSBwb2ludCBhbmQgaXMgdGhlIG1vc3QgaW1wb3J0YW50IHRoaW5nIElTQSBp
cyBhbHdheXMgdHJ5aW5nIHRvIG9mZmVyLiBUaGUgcmVzdCBpcyBqdXN0IHNvZnR3YXJlIGNvbnZl
bnRpb24uIFNvIHdlIGRlY2lkZWQgbm90IHRvIGVuZm9yY2UgUkJQL1JTUCwgdW5sZXNzIHRoZXJl
IGFyZSBzZWN1cml0eSBpbXBsaWNhdGlvbnMgLSBlLmcuIFJJUCAtIEVFWElUIHdpbGwgYmUgY29u
c2lkZXJlZCBhbiBpbmRpcmVjdCBicmFuY2ggaW5zdHJ1Y3Rpb24gYW5kIHdpbGwgaGF2ZSB0byBs
YW5kIG9uIGFuIEVOREJSIG9uY2UgQ0VUIGNvbWVzIG91dC4NCg==
