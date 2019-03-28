Return-Path: <SRS0=unfi=R7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5A8C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Mar 2019 04:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF852173C
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Mar 2019 04:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbfC1EXj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Mar 2019 00:23:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:48112 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfC1EXj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 Mar 2019 00:23:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Mar 2019 21:23:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,278,1549958400"; 
   d="scan'208";a="137902777"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga003.jf.intel.com with ESMTP; 27 Mar 2019 21:23:38 -0700
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 27 Mar 2019 21:23:38 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.65]) with mapi id 14.03.0415.000;
 Wed, 27 Mar 2019 21:23:37 -0700
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
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fwgACBcQD//5sEUIADt/WAgADIIJCAAMRtgP//souwgAM2LoCAAGNgAP//0r3AACmYkYAANjyeQA==
Date:   Thu, 28 Mar 2019 04:23:37 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E860C69@ORSMSX116.amr.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
 <20190322215903.GE12666@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
 <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com>
 <20190325180349.GF31069@linux.intel.com>
 <CALCETrXqb3CHefN-RLudC61jwdbLFS8cXuS4V5OJ6HTuf_arYw@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85FABF@ORSMSX116.amr.corp.intel.com>
 <CALCETrVcR_etAHSVZxvCz7CcPnF4ajpcWiRCtFrOckVWVJByHA@mail.gmail.com>
In-Reply-To: <CALCETrVcR_etAHSVZxvCz7CcPnF4ajpcWiRCtFrOckVWVJByHA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjg0ZTNhMTUtMzUxOC00ZTg0LThkNDMtNTdhNWYxYWY2N2Y5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVld4M1BJZys4QUVZdit2eGJIVklhc2QrMTFEQkFJdGZMRjNaRzc3Qm9RNlpGU2RUODZRRkJET1pRZHAxdlNHWSJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGkgQW5keSwNCg0KPiBGcm9tOiBsaW51eC1zZ3gtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWls
dG86bGludXgtc2d4LQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBBbmR5
IEx1dG9taXJza2kNCj4gDQo+IEkgc3VwcG9zZSB0aGUgcmVhbCBxdWVzdGlvbiBpczogYXJlIHRo
ZXJlIGEgc2lnbmlmaWNhbnQgbnVtYmVyIG9mDQo+IHVzZXJzIHdobyB3aWxsIHdhbnQgdG8gcnVu
IGVuY2xhdmVzIGNyZWF0ZWQgdXNpbmcgYW4gb2xkIFNESyBvbiBMaW51eD8NCj4gIEFuZCB3aWxs
IHRoZXJlIGFjdHVhbGx5IGJlIHN1cHBvcnQgZm9yIGRvaW5nIHRoaXMgaW4gdGhlIHNvZnR3YXJl
DQo+IHN0YWNrPw0KDQpUbyB5b3VyIGZpcnN0IHF1ZXN0aW9uLCBJIGNhbm5vdCBzaGFyZSBpbmZv
cm1hdGlvbiBvZiBJbnRlbCBjdXN0b21lcnMgb3Igc3BlYWsgZm9yIHRoZW0uIEJ1dCBpbiBnZW5l
cmFsLCBwZW9wbGUgd291bGQgbGlrZSB0byBzdGF5IHdpdGggYW4gb2xkIGVuY2xhdmUgdXN1YWxs
eSBiZWNhdXNlIG9mOiAxKSBhdHRlc3RhdGlvbiwgYmVjYXVzZSBNUkVOQ0xBVkUgd2lsbCBjaGFu
Z2UgYWZ0ZXIgcmVidWlsZDsgYW5kL29yIDIpIHRoZSBuZWVkIHRvIHN1cHBvcnQgYSBtaXggb2Yg
b2xkZXIgYW5kIG5ld2VyIExpbnV4IGtlcm5lbHMuIFNvIEknZCBzYXkgaXQnbGwgYmUgY29tbW9u
bHkgZGVzaXJlZCwgZXNwZWNpYWxseSB3aGVuIHRoaXMgdkRTTyBBUEkgaXMgc3RpbGwgIm5ldyIg
KHNvIG5vdCBhdmFpbGFibGUgb24gZXZlcnkgcGxhdGZvcm0pLg0KDQpUbyB5b3VyIHNlY29uZCBx
dWVzdGlvbiwgSW50ZWwgd2lsbCBzdXBwb3J0IGFsbCAibGVnYWN5IiBlbmNsYXZlcyBidWlsdCB3
aXRoIG9sZGVyIFNHWCBTREtzIG9uIG5ld2VyIGtlcm5lbHMuIEFuZCB0aGF0J3Mgd2h5IHdlIGFy
ZSBzbyBlYWdlciB0byBmaW5kIGEgbWlncmF0aW9uIHBhdGguIEkgY2FuJ3Qgc3BlYWsgZm9yIG90
aGVyIGNvbXBhbmllcywgYnV0IGd1ZXNzIGJhY2t3YXJkIGNvbXBhdGliaWxpdHkgaXMgYWx3YXlz
IGRlc2lyYWJsZS4NCg0KPiANCj4gSWYgdGhlIGFuc3dlciB0byBib3RoIHF1ZXN0aW9ucyBpcyB5
ZXMsIHRoZW4gaXQgc2VlbXMgbGlrZSBpdCBjb3VsZCBiZQ0KPiByZWFzb25hYmxlIHRvIHN1cHBv
cnQgaXQgaW4gdGhlIHZEU08uICBCdXQgSSBzdGlsbCB0aGluayBpdCBzaG91bGQNCj4gcHJvYmFi
bHkgYmUgYSBkaWZmZXJlbnQgdkRTTyBlbnRyeSBwb2ludCBzbyB0aGF0IHRoZSBub3JtYWwgY2Fz
ZQ0KPiBkb2Vzbid0IGJlY29tZSBtb3JlIGNvbXBsaWNhdGVkLg0KDQpJJ2xsIHN1cHBvcnQgd2hh
dGV2ZXIgeW91IHRoaW5rIGlzIG1vcmUgYXBwcm9wcmlhdGUuDQoNCkF0IHRoZSBlbmQsIEknZCBs
aWtlIHRvIGdpdmUgb3V0IHRoZSBmdWxsIHZlcnNpb24gb2YgbXkgcHJvcG9zYWwsIHdpdGggeW91
ciBmZWVkYmFja3MgKGkuZS4gc3RhY2sgdW53aW5kZXIgYW5kIFNwZWN0cmUgdmFyaWFudCAyKSBh
ZGRyZXNzZWQuIEknbSBhIGJpdCBjb25jZXJuZWQgYnkgcmV0cG9saW5lLCB3aGljaCB3b24ndCB3
b3JrIChvciBiZSBuZWVkZWQpIHdoZW4gQ0VUIGNvbWVzIG9ubGluZS4gQXJlIHlvdSBsb29raW5n
IHRvIGNoYW5nZSBpdCBhZ2FpbiB0aGVuPw0KDQpIZXJlJ3MgdGhlIHN1bW1hcnkgb2YgdGhlIGNo
YW5nZXM6DQogLSBBZGRlZCBDRkkgZGlyZWN0aXZlcyBmb3IgcHJvcGVyIHVud2luZGluZy4NCiAt
IERlZmluZWQgc2d4X2V4X2NhbGxiYWNrIC0gdGhlIGNhbGxiYWNrIGZ1bmN0aW9uIG9uIGVuY2xh
dmUgZXhpdC9leGNlcHRpb24uDQogLSBBbGlnbmVkIHN0YWNrIHByb3Blcmx5IGJlZm9yZSBjYWxs
aW5nIHNneF9leF9jYWxsYmFjayAocGVyIHg4Nl82NCBBQkkpLg0KIC0gVXNlZCByZXRwb2xpbmUg
aW4gcGxhY2Ugb2YgaW5kaXJlY3QgY2FsbC4NCiAtIFRoZSBibG9jayBzdGFydGluZyBhdCBsYWJl
bCAiNDoiIGNhcHR1cmVzIGFsbCB0aGUgY29kZSBuZWNlc3NhcnkgdG8gc3VwcG9ydCBzZ3hfZXhf
Y2FsbC4gSXQgaGFzIGdyb3duIGxvbmdlciBkdWUgdG8gcmV0cG9saW5lLg0KDQovKioNCiAqIF9f
dmRzb19zZ3hfZW50ZXJfZW5jbGF2ZSgpIC0gRW50ZXIgYW4gU0dYIGVuY2xhdmUNCiAqDQogKiAl
ZWF4OiAgICAgICAgRU5DTFUgbGVhZiwgbXVzdCBiZSBlaXRoZXIgRUVOVEVSIG9yIEVSRVNVTUUN
CiAqIDB4MDgoJXJzcCk6ICBUQ1MNCiAqIDB4MTAoJXJzcCk6ICBPcHRpb25hbCBwb2ludGVyIHRv
ICdzdHJ1Y3Qgc2d4X2VuY2xhdmVfZXhjZXB0aW9uJw0KICogMHgxOCglcnNwKTogIE9wdGlvbmFs
IGZ1bmN0aW9uIHBvaW50ZXIgdG8gJ3NneF9leF9jYWxsYmFjaycsIHdob3NlDQogKiAgICAgICAg
ICAgICAgZGVmaW5pdGlvbiB3aWxsIGJlIGdpdmVuIGJlbG93LiBOb3RlIHRoYXQgdGhpcyBmdW5j
dGlvbiwgaWYNCiAqICAgICAgICAgICAgICBwcmVzZW50LCBzaGFsbCBmb2xsb3cgeDg2XzY0IEFC
SS4NCiAqIHJldHVybjogICAgICAwICh6ZXJvKSBvbiBzdWNjZXNzLCBvciBhIG5lZ2F0aXZlIGVy
cm9yIGNvZGUgb24gZmFpbHVyZS4NCiAqDQogKiBOb3RlIHRoYXQgX192ZHNvX3NneF9lbnRlcl9l
bmNsYXZlKCkgaXMgbm90IGNvbXBhdGlibGUgd2l0aCB4ODZfNjQgQUJJLg0KICogQWxsIHJlZ2lz
dGVycyBleGNlcHQgUkJQIG11c3QgYmUgdHJlYXRlZCBhcyB2b2xhdGlsZSBmcm9tIHRoZSBjYWxs
ZXIncw0KICogcGVyc3BlY3RpdmUsIGluY2x1ZGluZyBidXQgbm90IGxpbWl0ZWQgdG8gR1BScywg
RUZMQUdTLkRGLCBNWENTUiwgRkNXLCBldGMuLi4NCiAqIEVuY2xhdmUgbWF5IGRlY3JlbWVudCBS
U1AsIGJ1dCBtdXN0IG5vdCBpbmNyZW1lbnQgaXQgLSBpLmUuIGV4aXN0aW5nIGNvbnRlbnQNCiAq
IG9mIHRoZSBzdGFjayBzaGFsbCBiZSBwcmVzZXJ2ZWQuDQogKg0KICogc2d4X2V4X2NhbGxiYWNr
IC0gQSBjYWxsYmFjayBmdW5jdGlvbiB0byBiZSBpbnZva2VkIGJ5DQogKiBfX3Zkc29fc2d4X2Vu
dGVyX2VuY2xhdmUoKSB1cG9uIGV4Y2VwdGlvbiBvciBhZnRlciB0aGUgZW5jbGF2ZSBleGl0cy4N
CiAqDQogKiB0eXBlZGVmIGludCAoKnNneF9leF9jYWxsYmFjaykobG9uZyByZGksIGxvbmcgcnNp
LCBsb25nIHJkeCwNCiAqICAgICAgc3RydWN0IHNneF9lbmNsYXZlX2V4Y2VwdGlvbiAqZXhfaW5m
bywgbG9uZyByOCwgbG9uZyByOSwNCiAqICAgICAgbG9uZyByc3AsIHZvaWQgKnRjcyk7DQogKg0K
ICogTm90ZSB0aGF0IHNneF9leF9jYWxsYmFjayBzaGFsbCBiZSB4ODZfNjQgQUJJIGNvbXBsaWFu
dC4NCiAqDQogKiBOb3RlIHRoYXQgb3RoZXIgR1BScyAoZXhjZXB0ICVyYXgsICVyYnggYW5kICVy
Y3gpIGFyZSBhbHNvIHBhc3NlZCB0aHJvdWdoIHRvDQogKiBzZ3hfZXhfY2FsbGJhY2ssIGV2ZW4g
dGhvdWdoIGFjY2Vzc2luZyB0aGVtIHJlcXVpcmVzIGFzc2VtYmx5IGNvZGUuDQogKi8NCl9fdmRz
b19zZ3hfZW50ZXJfZW5jbGF2ZToNCiAgICAgICAgLyogcHJvbG9nICovDQogICAgICAgIC5jZmlf
c3RhcnRwcm9jDQogICAgICAgIHB1c2ggICAgJXJicA0KICAgICAgICAuY2ZpX2FkanVzdF9jZmFf
b2Zmc2V0ICA4DQogICAgICAgIC5jZmlfcmVsX29mZnNldCAgICAgICAgICVyYnAsIDANCiAgICAg
ICAgbW92ICAgICAlcnNwLCAlcmJwDQogICAgICAgIC5jZmlfZGVmX2NmYV9yZWdpc3RlciAgICVy
YnANCg0KMTogICAgICAvKiBFRU5URVIgPD0gbGVhZiA8PSBFUkVTVU1FICovDQogICAgICAgIGNt
cCAgICAgJDB4MiwgJWVheA0KICAgICAgICBqYiAgICAgIDVmDQogICAgICAgIGNtcCAgICAgJDB4
MywgJWVheA0KICAgICAgICBqYSAgICAgIDVmDQoNCiAgICAgICAgLyogTG9hZCBUQ1MgYW5kIEFF
UCAqLw0KICAgICAgICBtb3YgICAgIDB4MTAoJXJicCksICVyYngNCiAgICAgICAgbGVhICAgICAy
ZiglcmlwKSwgJXJjeA0KDQoyOiAgICAgIGVuY2x1DQoNCiAgICAgICAgLyogRUVYSVQgcGF0aCAq
Lw0KICAgICAgICBtb3YgICAgIDB4MTgoJXJicCksICVyY3gNCiAgICAgICAganJjeHogICAzZg0K
ICAgICAgICBtb3YgICAgICVlYXgsIEVYX0xFQUYoJXJjeCkNCiAgICAgICAgLyogbm9ybWFsaXpl
IHJldHVybiB2YWx1ZSAqLw0KMzogICAgICB4b3IgICAgICVlYXgsICVlYXgNCg0KNDogICAgICAv
KiBjYWxsIHNneF9leF9jYWxsYmFjayBpZiBzdXBwbGllZCAqLw0KICAgICAgICBjbXBxICAgICQw
LCAweDIwKCVyYnApDQogICAgICAgIGp6ICAgICAgNmYNCiAgICAgICAgLyogYWxpZ24gc3RhY2sg
cGVyIHg4Nl82NCBBQkkgKi8NCiAgICAgICAgbW92ICAgICAlcnNwLCAlcmJ4DQogICAgICAgIGFu
ZCAgICAgJC0weDEwLCAlcnNwDQogICAgICAgIC8qIHBhcmFtZXRlcnMgKi8NCiAgICAgICAgcHVz
aCAgICAweDEwKCVyYnApDQogICAgICAgIHB1c2ggICAgJXJieA0KICAgICAgICAvKiBjYWxsICow
eDIwKCVyYnApIHVzaW5nIHJldHBvbGluZSAqLw0KICAgICAgICBtb3YgICAgIDB4MjAoJXJicCks
ICVyYXgNCiAgICAgICAgY2FsbCAgICA0MWYNCiAgICAgICAgLyogc3RhY2sgY2xlYW51cCAqLw0K
ICAgICAgICBtb3YgICAgICVyYngsICVyc3ANCiAgICAgICAgam1wICAgICAxYg0KNDE6ICAgICBj
YWxsICAgIDQzZg0KNDI6ICAgICBwYXVzZQ0KICAgICAgICBsZmVuY2UNCiAgICAgICAgam1wICAg
ICA0MmINCjQzOiAgICAgbW92ICAgICAlcmF4LCAoJXJzcCkNCiAgICAgICAgcmV0DQoNCjU6ICAg
ICAgLyogYmFkIGxlYWYgKi8NCiAgICAgICAgY21wICAgICAkMCwgJWVheA0KICAgICAgICBqbGUg
ICAgIDZmDQogICAgICAgIG1vdiAgICAgJCgtRUlOVkFMKSwgJWVheA0KDQo2OiAgICAgIC8qIGVw
aWxvZyAqLw0KICAgICAgICBsZWF2ZQ0KICAgICAgICAuY2ZpX2RlZl9jZmEgICAgICAgICAgICAl
cnNwLCA4DQogICAgICAgIHJldA0KICAgICAgICAuY2ZpX2VuZHByb2MNCg0KLnB1c2hzZWN0aW9u
ICAgIC5maXh1cCwgImF4Ig0KNzogICAgICBtb3YgICAgIDB4MTgoJXJicCksICVyY3gNCiAgICAg
ICAganJjeHogICA4Zg0KICAgICAgICAvKiBmaWxsIGluIGV4X2luZm8gKi8NCiAgICAgICAgbW92
ICAgICAlZWF4LCBFWF9MRUFGKCVyY3gpDQogICAgICAgIG1vdiAgICAgJWRpLCBFWF9UUkFQTlIo
JXJjeCkNCiAgICAgICAgbW92ICAgICAlc2ksIEVYX0VSUk9SX0NPREUoJXJjeCkNCiAgICAgICAg
bW92ICAgICAlcmR4LCBFWF9BRERSRVNTKCVyY3gpDQo4OiAgICAgIG1vdiAgICAgJCgtRUZBVUxU
KSwgJWVheA0KICAgICAgICBqbXAgICAgIDRiDQoucG9wc2VjdGlvbg0KDQpfQVNNX1ZEU09fRVhU
QUJMRV9IQU5ETEUoMmIsIDdiKQ0KDQoNCi1DZWRyaWMNCg==
