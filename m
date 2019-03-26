Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41359C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 04:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FFE620828
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 04:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfCZExj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 00:53:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:11430 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfCZExj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 00:53:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Mar 2019 21:53:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="158406275"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga001.fm.intel.com with ESMTP; 25 Mar 2019 21:53:38 -0700
Received: from orsmsx154.amr.corp.intel.com (10.22.226.12) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 25 Mar 2019 21:53:37 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX154.amr.corp.intel.com ([169.254.11.183]) with mapi id 14.03.0415.000;
 Mon, 25 Mar 2019 21:53:37 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fwgACBcQD//5sEUIADt/WAgADIIJCAAMRtgP//souwgAM2LoCAAGNgAP//0r3A
Date:   Tue, 26 Mar 2019 04:53:36 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E85FABF@ORSMSX116.amr.corp.intel.com>
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
In-Reply-To: <CALCETrXqb3CHefN-RLudC61jwdbLFS8cXuS4V5OJ6HTuf_arYw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTA4OWJlMWItN2NmYS00Zjc4LThkOWMtZDcxZDIxOWZlNDAwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTUkxQ2F0dGs4YkowXC9LSENrRWlwWjVPTjg1ZGZscjhsMXJCXC9XQnJ2R09ldGcxWExrV3BNcTNhMXlLZHQxajdqIn0=
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

PiBPbiBNb24sIE1hciAyNSwgMjAxOSBhdCAxMTowMyBBTSBTZWFuIENocmlzdG9waGVyc29uDQo+
IDxzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IE9uIFN1
biwgTWFyIDI0LCAyMDE5IGF0IDAxOjU5OjQ4QU0gLTA3MDAsIFhpbmcsIENlZHJpYyB3cm90ZToN
Cj4gPiA+IEFzIHNhaWQgaW4gbXkgcHJldmlvdXMgZW1haWwsIHRoaXMgdkRTTyBBUEkgaXNuJ3Qg
ZXZlbiBjb21wbGlhbnQgdG8NCj4gPiA+IHg4Nl82NCBBQkkgYW5kIGlzIGFic29sdXRlbHkgTk9U
IGZvciBhdmVyYWdlIGRldmVsb3BlcnMuIEluc3RlYWQsDQo+ID4gPiBob3N0L2VuY2xhdmUgY29t
bXVuaWNhdGlvbnMgYXJlIGV4cGVjdGVkIHRvIGJlIGhhbmRsZWQgYnkgU0RLcyBhbmQNCj4gPiA+
IHRob3NlIGRldmVsb3BlcnMgd2lsbCBiZSB2ZXJ5IGF3YXJlIG9mIHRoZSBsaW1pdGF0aW9ucyBv
ZiB0aGVpcg0KPiA+ID4gdGFyZ2V0ZWQgZW52aXJvbm1lbnRzLCBhbmQgd2lsbCBuZWVkIHRoZSBm
cmVlZG9tIHRvIGRlcGxveSBvcHRpbWFsDQo+IHNvbHV0aW9ucy4NCj4gDQo+ID4gSSBmdWxseSBy
ZWFsaXplIHRoYXQgdGhlIGFib3ZlIGFwcHJvYWNoIHNhZGRsZXMgQ2VkcmljIGFuZCB0aGUgU0RL
DQo+ID4gdGVhbSB3aXRoIHRoZSBleHRyYSB0YXNrIG9mIGp1c3RpZnlpbmcgdGhlIG5lZWQgZm9y
IHR3byB2RFNPDQo+ID4gaW50ZXJmYWNlcywgYW5kIGxpa2VseSByZWR1Y2VzIHRoZSBwcm9iYWJp
bGl0eSBvZiB0aGVpciBwcm9wb3NhbCBiZWluZw0KPiA+IGFjY2VwdGVkLiAgQnV0LCB3ZSBkb24n
dCAqZm9yY2UqIHRoZSBTREsgdG8gYmUgcmV3cml0dGVuLCBhbmQgd2UgZ2Fpbg0KPiA+IGEgdkRT
TyBpbnRlcmZhY2UgdGhhdCBtYW55IHBlb3BsZSB3YW50IGFuZCBpcyBhY2NlcHRhYmxlIHRvIHRo
ZQ0KPiA+IG1haW50YWluZXJzICh1bmxlc3MgSSd2ZSBob3JyaWJseSBtaXNyZWFkIEFuZHkncyBw
b3NpdGlvbikuDQo+IA0KPiBJIGRvbid0IHRoaW5rIHlvdSd2ZSBob3JyaWJseSBtaXNyZWFkIGl0
LiAgSSB3b3VsZCBsaWtlIHRvIGtlZXAgdGhlDQo+IHN0dWZmIGluIHRoZSB2RFNPIGFzIG1pbmlt
YWwgYXMgcG9zc2libGUuICBJZiB3ZSBuZWVkIHRvIGFkZCBhIGZhbmNpZXINCj4gaW50ZXJmYWNl
IGRvd24gdGhlIGxpbmUsIHRoZW4gdGhhdCdzIGZpbmUuDQoNCkFuZHksIEkgZG9uJ3Qga25vdyAi
bWFueSBwZW9wbGUiIGlzIGhvdyBtYW55IGluIFNlYW4ncyBlbWFpbC4gSSBjb3VsZG4ndCB0ZWxs
IHlvdSBob3cgbG9uZyBpdCB0b29rIHVzIHRvIHNldHRsZSBvbiB0aGUgY3VycmVudCBTR1ggSVNB
IGJlY2F1c2UgeW91IHdvdWxkIGp1c3QgTEFVR0ghIFdoeT8gQmVjYXVzZSBpdCB0b29rIGluc2Fu
ZWx5IHJpZGljdWxvdXNseSBsb25nLiBXaHkgdGhhdCBsb25nPyBCZWNhdXNlIHRoZSBoL3cgYW5k
IHUtY29kZSB0ZWFtcyB3b3VsZCBsaWtlIHRvIHRyaW0gZG93biB0aGUgSVNBIGFzIG11Y2ggYXMg
cG9zc2libGUuIFRoZSBmYWN0IGlzLCB3aGF0ZXZlciBuZXcgaXMgcmVsZWFzZWQsIEludGVsIHdp
bGwgaGF2ZSB0byBtYWludGFpbiBpdCBvbiBhbGwgZnV0dXJlIHByb2Nlc3NvcnMgRk9SRVZFUiEg
VGhhdCBtZWFucyBzaWduaWZpY2FudC9vbi1nb2luZyBjb3N0IHRvIEludGVsLiBTbyBhbnkgYWRk
aXRpb24gdG8gSVNBIGhhcyB0byB1bmRlcmdvIGV4dGVuc2l2ZSByZXZpZXdzIHRoYXQgaW52b2x2
ZSBhbGwga2luZHMgb2YgZXhwZXJ0cyBmcm9tIGJvdGggd2l0aGluIEludGVsIGFuZCBleHRlcm5h
bGx5LCBhbmQgd291bGQgdXN1YWxseSB0YWtlIHllYXJzLCBiZWZvcmUgeW91IGNhbiBzZWUgd2hh
dCB5b3UgYXJlIHNlZWluZyB0b2RheS4gQXMgSSBzYWlkIGluIG15IGVhcmxpZXIgZW1haWxzLCBS
QlAgaXMgTk9UIG5lZWRlZCBmb3IgaW50ZXJydXB0L2V4Y2VwdGlvbiBoYW5kbGVycywgdGhlbiBo
b3cgZGlkIFJCUCBlbmQgdXAgYmVpbmcgcmVzdG9yZWQgYXQgQUVYPyBZb3UgY2FuIGd1ZXNzIGhv
dyBtYW55IHBlb3BsZSB3ZXJlIHN0YW5kaW5nIGJlaGluZCBpdCEgU2VhbiBoYXMgbm8gY2x1ZSEg
SSBjYW4gYXNzdXJlIHlvdSENCg0KR3Vlc3Mgd2UndmUgdGFsa2VkIGVub3VnaCBvbiB0aGUgdGVj
aG5pY2FsIGZyb250LiBTbyBsZXQncyB0YWxrIGFib3V0IGl0IG9uIHRoZSBidXNpbmVzcyBmcm9u
dC4gTGV0IG1lIHRha2UgYSBzdGVwIGJhY2suIExldCdzIHNheSB5b3UgYXJlIHJpZ2h0LCBhbGwg
ZW5jbGF2ZXMgd291bGQgZXZlbnR1YWxseSBiZSBjb2RlZCBpbiB0aGUgd2F5IHlvdSB3YW50LiBX
ZSAoSW50ZWwgU0RLIHRlYW0pIHdlcmUgY29udmluY2VkIHRvIGZvbGxvdyB5b3VyIGFwcHJvYWNo
LiBCdXQgdGhlcmUgd2VyZSBleGlzdGluZyBlbmNsYXZlcyBhbmQgYSBtaWdyYXRpb24gcGF0aCB3
b3VsZCBiZSBuZWVkZWQuIFdvdWxkIHlvdSBsaWtlIHRvIHN1cHBvcnQgdXM/IEl0J2QgYmUgb25s
eSA5IExPQyBvbiB5b3VyIHNpZGUgYnV0IGhvdyBtdWNoIHdvdWxkIGluY3VyIG9uIG91ciBzaWRl
PyBJZiB5b3UgYmVsaWV2ZSB5b3UgYXJlIGRvaW5nIHJpZ2h0IHRoaW5nLCB0aGVuIGFjY2VwdGFu
Y2UgaXMgdGhlIG5leHQgdGhpbmcgeW91IHNob3VsZCB0aGluayBvZi4gWW91IHNob3VsZCBvZmZl
ciBhbiBlYXN5IHBhdGggZm9yIHRob3NlIHdobyBkaWQgIndyb25nIiB0byBnZXQgb24geW91ciAi
cmlnaHQiIGJvYXQuIERvbid0IHlvdSB0aGluayBzbz8NCg0KLUNlZHJpYw0K
