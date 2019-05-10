Return-Path: <SRS0=kShl=TK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8929FC04A6B
	for <linux-sgx@archiver.kernel.org>; Fri, 10 May 2019 18:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6345B217D7
	for <linux-sgx@archiver.kernel.org>; Fri, 10 May 2019 18:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfEJS4l (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 10 May 2019 14:56:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:11875 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbfEJS4k (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 10 May 2019 14:56:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 May 2019 11:56:40 -0700
X-ExtLoop1: 1
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga007.jf.intel.com with ESMTP; 10 May 2019 11:56:40 -0700
Received: from orsmsx122.amr.corp.intel.com (10.22.225.227) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 10 May 2019 11:56:39 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.36]) by
 ORSMSX122.amr.corp.intel.com ([169.254.11.68]) with mapi id 14.03.0415.000;
 Fri, 10 May 2019 11:56:39 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
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
Thread-Index: AQHU9QnxaoiNNkdqP0yJjajWChyAgKZCnqeAgAAN+QCAAVPmAIAAE4cAgABGGYCAABE4gIAAAfWAgAABFgCAAADiAIAABegAgAABOYCAAAN6gIAAAQAAgAAA2wCAAATlgIAEWt6AgBvkEoCAAHnYgIAABJkAgAAC6gD//5XxkA==
Date:   Fri, 10 May 2019 18:56:38 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
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
 <960B34DE67B9E140824F1DCDEC400C0F4E885F9D@ORSMSX116.amr.corp.intel.com>
 <979615a8-fd03-e3fd-fbdb-65c1e51afd93@fortanix.com>
 <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
In-Reply-To: <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTFjNjBiNTItZmUxMy00ZjgzLTg4N2QtYmZiYzg2MmU4NzA0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVFkrQ1YweFh0WlZ1NHM2NGNGdW5PRnVzTTU3QnBnZzJTYUFEamxIak9Wb1VOTEpuVm1VWm5zNkMzK29mZFpSTyJ9
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

SGkgSmV0aHJvLA0KIA0KPiBFTEYgZmlsZXMgYXJlIGV4cGxpY2l0bHkgZGVzaWduZWQgc3VjaCB0
aGF0IHlvdSBjYW4gbWFwIHRoZW0gKHdpdGggbW1hcCkNCj4gaW4gNDA5Ni1ieXRlIGNodW5rcy4g
SG93ZXZlciwgc29tZXRpbWVzIHRoZXJlJ3Mgb3ZlcmxhcCBhbmQgeW91IHdpbGwNCj4gc29tZXRp
bWVzIHNlZSB0aGF0IGEgcGFydGljdWxhciBvZmZzZXQgaXMgbWFwcGVkIHR3aWNlIGJlY2F1c2Ug
dGhlIGZpcnN0DQo+IGhhbGYgb2YgdGhlIHBhZ2UgaW4gdGhlIGZpbGUgYmVsb25ncyB0byBhbiBS
WCByYW5nZSBhbmQgdGhlIHNlY29uZCBoYWxmDQo+IHRvIGFuIFItb25seSByYW5nZS4gQWxzbywg
RUxGIGZpbGVzIGRvbid0IChub3JtYWxseSkgZGVzY3JpYmUgc3RhY2ssDQo+IGhlYXAsIGV0Yy4g
d2hpY2ggeW91IGRvIG5lZWQgZm9yIGVuY2xhdmVzLg0KDQpZb3UgaGF2ZSBwcm9iYWJseSBtaXNy
ZWFkIG15IGVtYWlsLiBCeSBtbWFwKCksIEkgbWVhbnQgdGhlIGVuY2xhdmUgZmlsZSB3b3VsZCBi
ZSBtYXBwZWQgdmlhICptdWx0aXBsZSogbW1hcCgpIGNhbGxzLCBpbiB0aGUgc2FtZSB3YXkgYXMg
d2hhdCBkbG9wZW4oKSB3b3VsZCBkbyBpbiBsb2FkaW5nIHJlZ3VsYXIgc2hhcmVkIG9iamVjdC4g
VGhlIGludGVudGlvbiBoZXJlIGlzIHRvIG1ha2UgdGhlIGVuY2xhdmUgZmlsZSBzdWJqZWN0IHRv
IHRoZSBzYW1lIGNoZWNrcyBhcyByZWd1bGFyIHNoYXJlZCBvYmplY3RzLg0KDQpUaGUgb3RoZXIg
ZW5jbGF2ZSBjb21wb25lbnRzIChlLmcuIFRDUywgaGVhcCwgc3RhY2ssIGV0Yy4pIHdpbGwgYmUg
Y3JlYXRlZCBmcm9tIHdyaXRhYmxlIHBhZ2VzIHdpdGhpbiB0aGUgY2FsbGluZyBwcm9jZXNzJ3Mg
YWRkcmVzcyBzcGFjZSBhcyBiZWZvcmUuIFNpbWlsYXIgdG8gaGVhcHMvc3RhY2tzIGluIGEgcmVn
dWxhciBwcm9jZXNzLCB0aG9zZSBjb21wb25lbnRzIGRvbid0IGhhdmUgdG8gYmUgYmFja2VkIGJ5
IGRpc2sgZmlsZXMuDQoNClRoZSBjb3JlIGlkZWEgaXMgZm9yIFNHWCBkcml2ZXIgdG8gImNvcHki
IG5vdCBvbmx5IHRoZSBjb250ZW50IGJ1dCBhbHNvIHBlcm1pc3Npb25zIGZyb20gYSBzb3VyY2Ug
cGFnZSB0byB0aGUgdGFyZ2V0IEVQQyBwYWdlLiBHaXZlbiB0aGUgZXhpc3RlbmNlIG9mIHRoZSBz
b3VyY2UgcGFnZSwgaXQgY2FuIGJlIGNvbmNsdWRlZCB0aGF0IHRoZSBjb21iaW5hdGlvbiBvZiBj
b250ZW50IGFuZCBwZXJtaXNzaW9ucyBvZiB0aGF0IHBhZ2UgaGFzIHBhc3NlZCBhbGwgSU1BL0xT
TSBjaGVja3MgYXBwbGljYWJsZSB0byB0aGF0IHBhZ2UsIGhlbmNlICJjb3B5aW5nIiB0aGF0IHBh
Z2UgdG8gRVBDIHdpdGggdGhlIHNhbWUgKG9yIGxlc3MpIHBlcm1pc3Npb24gaXMgKm5vdCogYSBj
aXJjdW12ZW50aW9uIG9mIElNQS9MU00gcG9saWNpZXMuDQoNCi1DZWRyaWMNCg==
