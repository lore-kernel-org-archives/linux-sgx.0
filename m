Return-Path: <SRS0=kShl=TK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8D5C04A6B
	for <linux-sgx@archiver.kernel.org>; Fri, 10 May 2019 17:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6237217F4
	for <linux-sgx@archiver.kernel.org>; Fri, 10 May 2019 17:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfEJRX5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 10 May 2019 13:23:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:12271 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbfEJRX5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 10 May 2019 13:23:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 May 2019 10:23:57 -0700
X-ExtLoop1: 1
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga002.jf.intel.com with ESMTP; 10 May 2019 10:23:56 -0700
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 10 May 2019 10:23:55 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.36]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.172]) with mapi id 14.03.0415.000;
 Fri, 10 May 2019 10:23:55 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
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
Thread-Index: AQHU9QnxaoiNNkdqP0yJjajWChyAgKZCnqeAgAAN+QCAAVPmAIAAE4cAgABGGYCAABE4gIAAAfWAgAABFgCAAADiAIAABegAgAABOYCAAAN6gIAAAQAAgAAA2wCAAATlgIAEWt6AgBvkEoA=
Date:   Fri, 10 May 2019 17:23:54 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E885F9D@ORSMSX116.amr.corp.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190418171059.GA20819@wind.enjellic.com>
 <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
 <20190419141732.GA2269@wind.enjellic.com>
 <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
 <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com>
 <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de>
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
In-Reply-To: <CALCETrV7CcDnx1hVtmBnDNABG11GuMqyspJMMpV+zHpVeFu3ow@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTM1OTBmOWMtNWU4Zi00YTQwLWFmNjEtYzVhYWI0YTViNjAyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidXRUMWlcL3BTMEYxc1J2NlpnXC9DWm5sYUtHQ1UwS3cwWCtSb1RuUTg1M0huenhjVm5uTDhUZWVvTmdMWWtFQUJGIn0=
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

SGkgQW5keSwNCg0KPiBTbyBJIHRoaW5rIHdlIG5lZWQgYSBiZXR0ZXIgRUFERCBpb2N0bCB0aGF0
IGV4cGxpY2l0bHkgZG9lcyB3b3JrIG9uIA0KPiBQUk9UX1JFQUR8UFJPVF9FWEVDIGVuY2xhdmUg
bWVtb3J5IGJ1dCBtYWtlcyB1cCBmb3IgYnkgdmFsaWRhdGluZyB0aGUNCj4gKnNvdXJjZSogb2Yg
dGhlIGRhdGEuICBUaGUgZWZmZWN0IHdpbGwgYmUgc2ltaWxhciB0byBtYXBwaW5nIGEgDQo+IGxh
YmVsZWQsIGFwcHJhaXNlZCwgZXRjIGZpbGUgYXMgUFJPVF9FWEVDLiAgTWF5YmUsIGluIGV4dHJl
bWUNCj4gcHNldWRvY29kZToNCj4gDQo+IGZkID0gb3BlbijigJwvZGV2L3NneC9lbmNsYXZl4oCd
KTsNCj4gaW9jdGwoZmQsIFNHWF9DUkVBVEVfRlJPTV9GSUxFLCBmaWxlX2ZkKTsgLy8gZmQgbm93
IGluaGVyaXRzIHRoZSBMU00gDQo+IGxhYmVsIGZyb20gdGhlIGZpbGUsIG9yIGlzIG90aGVyd2lz
ZSBtYXJrZWQuDQo+IG1tYXAoZmQsIFBST1RfUkVBRHxQUk9UX0VYRUMsIC4uLik7DQo+IA0KPiBJ
IHN1cHBvc2UgdGhhdCBhbiBhbHRlcm5hdGl2ZSB3b3VsZCBiZSB0byBkZWxlZ2F0ZSBhbGwgdGhl
IEVBREQgY2FsbHMgDQo+IHRvIGEgcHJpdmlsZWdlZCBkYWVtb24sIGJ1dCB0aGF04oCZcyBuYXN0
eS4NCg0KSSBhZ3JlZSB3aXRoIHlvdSB0aGF0ICpzb3VyY2UqIG9mIEVQQyBwYWdlcyBzaGFsbCBi
ZSB2YWxpZGF0ZWQuIEJ1dCBpbnN0ZWFkIG9mIGRvaW5nIGl0IGluIHRoZSBkcml2ZXIsIEkgdGhp
bmsgYW4gYWx0ZXJuYXRpdmUgY291bGQgYmUgdG8gdHJlYXQgYW4gZW5jbGF2ZSBmaWxlIGFzIGEg
cmVndWxhciBzaGFyZWQgb2JqZWN0IHNvIGFsbCBJTUEvTFNNIGNoZWNrcyBjb3VsZCBiZSB0cmln
Z2VyZWQvcGVyZm9ybWVkIGFzIHBhcnQgb2YgdGhlIGxvYWRpbmcgcHJvY2VzcywgdGhlbiBsZXQg
dGhlIGRyaXZlciAiY29weSIgdGhvc2UgcGFnZXMgdG8gRVBDLiBCeSAiY29weSIsIEkgbWVhbiBi
b3RoIHRoZSBwYWdlIGNvbnRlbnQgYW5kIF9wZXJtaXNzaW9uc18gYXJlIGNvcGllZCwgd2hpY2gg
ZGlmZmVycyBmcm9tIHRoZSBjdXJyZW50IGRyaXZlcidzIGJlaGF2aW9yIG9mIGNvcHlpbmcgcGFn
ZSBjb250ZW50IG9ubHkgKHdoaWxlIHBlcm1pc3Npb25zIGFyZSB0YWtlbiBmcm9tIGlvY3RsIHBh
cmFtZXRlcnMpLiBUaGF0IHNhaWQsIGlmIGFuIGFkdmVyc2FyeSBjYW5ub3QgaW5qZWN0IGFueSBj
b2RlIGludG8gYSBwcm9jZXNzIGluIHJlZ3VsYXIgcGFnZXMsIHRoZW4gaXQgY2Fubm90IGluamVj
dCBhbnkgY29kZSB0byBhbnkgRVBDIHBhZ2VzIGluIHRoYXQgcHJvY2VzcyBlaXRoZXIsIHNpbXBs
eSBiZWNhdXNlIHRoZSBsYXR0ZXIgZGVwZW5kcyBvbiB0aGUgZm9ybWVyLiANCg0KU2VjdXJpdHkg
d2lzZSwgaXQgaXMgYWxzbyBhc3N1bWVkIHRoYXQgZHVwbGljYXRpbmcgKGJvdGggY29udGVudCBh
bmQgcGVybWlzc2lvbnMgb2YpIGFuIGV4aXN0aW5nIHBhZ2Ugd2l0aGluIGEgcHJvY2VzcyB3aWxs
IG5vdCB0aHJlYXRlbiB0aGUgc2VjdXJpdHkgb2YgdGhhdCBwcm9jZXNzLiBUaGF0IGFzc3VtcHRp
b24gbWF5IG5vdCBhbHdheXMgYmUgdHJ1ZSBidXQgaW4gcHJhY3RpY2UsIHRoZSBjdXJyZW50IExT
TSBhcmNoaXRlY3R1cmUgZG9lc24ndCBzZWVtIHRvIGhhdmUgdGhhdCBpbiBzY29wZSwgc28gdGhp
cyBwcm9wb3NhbCBJIHRoaW5rIHN0aWxsIGFsaWducyB3aXRoIExTTSBpbiB0aGF0IHNlbnNlLiAN
Cg0KSWYgY29tcGFyZWQgdG8gdGhlIGlkZWEgb2YgImVuY2xhdmUgbG9hZGVyIGluc2lkZSBrZXJu
ZWwiLCBJIHRoaW5rIHRoaXMgYWx0ZXJuYXRpdmUgaXMgbXVjaCBzaW1wbGVyIGFuZCBtb3JlIGZs
ZXhpYmxlLiBJbiBwYXJ0aWN1bGFyLA0KKiBJdCByZXF1aXJlcyBtaW5pbWFsIGNoYW5nZSB0byB0
aGUgZHJpdmVyIC0ganVzdCB0YWtlIEVQQ00gcGVybWlzc2lvbnMgZnJvbSBzb3VyY2UgcGFnZXMn
IFZNQSBpbnN0ZWFkIG9mIGZyb20gaW9jdGwgcGFyYW1ldGVyLg0KKiBJdCByZXF1aXJlcyBsaXR0
bGUgY2hhbmdlIHRvIHVzZXIgbW9kZSBlbmNsYXZlIGxvYWRlciAtIGp1c3QgbW1hcCgpIGVuY2xh
dmUgZmlsZSBpbiB0aGUgc2FtZSB3YXkgYXMgZGxvcGVuKCkgd291bGQgZG8sIHRoZW4gYWxsIElN
QS9MU00gY2hlY2tzIGFwcGxpY2FibGUgdG8gc2hhcmVkIG9iamVjdHMgd2lsbCBiZSB0cmlnZ2Vy
ZWQvcGVyZm9ybWVkICB0cmFuc3BhcmVudGx5Lg0KKiBJdCBkb2Vzbid0IGFzc3VtZS90aWUgdG8g
c3BlY2lmaWMgZW5jbGF2ZSBmb3JtYXRzLg0KKiBJdCBpcyBleHRlbnNpYmxlIC0gVG9kYXkgZXZl
cnkgcmVndWxhciBwYWdlIHdpdGhpbiBhIHByb2Nlc3MgaXMgYWxsb3dlZCBpbXBsaWNpdGx5IHRv
IGJlIHRoZSBzb3VyY2UgZm9yIGFuIEVQQyBwYWdlLiBJbiBmdXR1cmUsIGlmIGF0IGFsbCBkZXNp
cmFibGUvbmVjZXNzYXJ5LCBJTUEvTFNNIGNvdWxkIGJlIGV4dGVuZGVkIHRvIGxlYXZlIGEgZmxh
ZyBzb21ld2hlcmUgKGUuZy4gaW4gVk1BKSB0byBpbmRpY2F0ZSBleHBsaWNpdGx5IHdoZXRoZXIg
YSByZWd1bGFyIHBhZ2UgKG9yIHJhbmdlKSBjb3VsZCBiZSBhIHNvdXJjZSBmb3IgRVBDLiBUaGVu
IFNHWCBzcGVjaWZpYyBob29rcy9wb2xpY2llcyBjb3VsZCBiZSBzdXBwb3J0ZWQgZWFzaWx5Lg0K
DQpIb3cgZG8geW91IHRoaW5rPw0KDQotQ2VkcmljDQo=
