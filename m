Return-Path: <SRS0=kShl=TK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F75C04A6B
	for <linux-sgx@archiver.kernel.org>; Fri, 10 May 2019 18:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A7D521479
	for <linux-sgx@archiver.kernel.org>; Fri, 10 May 2019 18:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfEJSo6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 10 May 2019 14:44:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:7804 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbfEJSo6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 10 May 2019 14:44:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 May 2019 11:44:57 -0700
X-ExtLoop1: 1
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga004.jf.intel.com with ESMTP; 10 May 2019 11:44:57 -0700
Received: from orsmsx122.amr.corp.intel.com (10.22.225.227) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 10 May 2019 11:44:57 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.36]) by
 ORSMSX122.amr.corp.intel.com ([169.254.11.68]) with mapi id 14.03.0415.000;
 Fri, 10 May 2019 11:44:57 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
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
Thread-Index: AQHU9QnxaoiNNkdqP0yJjajWChyAgKZCnqeAgAAN+QCAAVPmAIAAE4cAgABGGYCAABE4gIAAAfWAgAABFgCAAADiAIAABegAgAABOYCAAAN6gIAAAQAAgAAA2wCAAATlgIAEWt6AgBvkEoCAAHnYgIAABJkA//+VXFA=
Date:   Fri, 10 May 2019 18:44:56 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E886073@ORSMSX116.amr.corp.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
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
 <960B34DE67B9E140824F1DCDEC400C0F4E885F9D@ORSMSX116.amr.corp.intel.com>
 <979615a8-fd03-e3fd-fbdb-65c1e51afd93@fortanix.com>
 <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
In-Reply-To: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzcyYjQ1NjEtZTc3Yy00MDRmLWE1MWUtMDc2NWYyODM0MmNiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVjhBM0NXM2FIRGVUaDFuaG03MmFJd1FEYnRmcTVaUEZRTTdYdWdzYkxZZ2hMeldSdXdMa2EzcUo1blwvK0tlUCsifQ==
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

SGkgRGF2ZSwNCg0KPiBPbiA1LzEwLzE5IDEwOjM3IEFNLCBKZXRocm8gQmVla21hbiB3cm90ZToN
Cj4gPiBJdCBkb2VzIGFzc3VtZSBhIHNwZWNpZmljIGZvcm1hdCwgbmFtZWx5LCB0aGF0IHRoZSBt
ZW1vcnkgbGF5b3V0DQo+ID4gKGluY2x1ZGluZyBwYWdlIHR5cGVzL3Blcm1pc3Npb25zKSBvZiB0
aGUgZW5jbGF2ZSBjYW4gYmUgcmVwcmVzZW50ZWQNCj4gaW4NCj4gPiBhICJmbGF0IGZpbGUiIG9u
IGRpc2ssIG9yIGF0IGxlYXN0IHRoYXQgdGhlIGVuY2xhdmUgbWVtb3J5IGNvbnRlbnRzDQo+ID4g
Y29uc2lzdCBvZiA0MDk2LWJ5dGUgY2h1bmtzIGluIHRoYXQgZmlsZS4NCj4gDQo+IEkgX3RoaW5r
XyBDZWRyaWMncyBwb2ludCBpcyB0aGF0LCB0byB0aGUga2VybmVsLA0KPiAvbGliL3g4Nl82NC1s
aW51eC1nbnUvbGliYy5zby42IGlzIGEgImZsYXQgZmlsZSIgYmVjYXVzZSB0aGUga2VybmVsDQo+
IGRvZXNuJ3QgaGF2ZSBhbnkgcGFydCBpbiBwYXJzaW5nIHRoZSBleGVjdXRhYmxlIGZvcm1hdCBv
ZiBhIHNoYXJlZA0KPiBsaWJyYXJ5Lg0KPiANCj4gSSBhY3R1YWxseSBkb24ndCBrbm93IGhvdyBp
dCB3b3JrcywgdGhvdWdoLiAgRG8gd2UganVzdCBqdXN0IHRydXN0IHRoYXQNCj4gdGhlIHVzZXJz
cGFjZSBwYXJzaW5nIG9mIHRoZSAuc28gZm9ybWF0IGlzIGNvcnJlY3Q/ICBEbyB3ZSBqdXN0IGFz
c3VtZQ0KPiB0aGF0IGFueSBwYXJ0IG9mIGEgZmlsZSBwYXNzaW5nIElNQSBjaGVja3MgY2FuIGJl
IFBST1RfRVhFQz8NCg0KVGhlIGtleSBpZGVhIGhlcmUgaXMgZm9yIGVuY2xhdmUgZmlsZXMgdG8g
ImluaGVyaXQiIHRoZSBjaGVja3MgYXBwbGljYWJsZSB0byByZWd1bGFyIHNoYXJlZCBvYmplY3Rz
LiBBbmQgaG93IHdlIGFyZSBnb2luZyB0byBkbyBpdCBpcyBmb3IgdXNlciBwcm9jZXNzIHRvIG1h
cCBldmVyeSBsb2FkYWJsZSBzZWdtZW50IG9mIHRoZSBlbmNsYXZlIGZpbGUgaW50byBpdHMgYWRk
cmVzcyBzcGFjZSB1c2luZyAqbXVsdGlwbGUqIG1tYXAoKSBjYWxscywganVzdCBpbiB0aGUgc2Ft
ZSB3YXkgYXMgZGxvcGVuKCkgd291bGQgZG8gZm9yIGxvYWRpbmcgcmVndWxhciBzaGFyZWQgb2Jq
ZWN0cy4gVGhlbiB0aG9zZSBvcGVuKCkvbW1hcCgpIHN5c2NhbGxzIHdpbGwgdHJpZ2dlciBhbGwg
YXBwbGljYWJsZSBjaGVja3MgKGJ5IG1lYW5zIG9mIHNlY3VyaXR5X2ZpbGVfb3BlbigpLCBzZWN1
cml0eV9tbWFwX2ZpbGUoKSBhbmQgaW1hX2ZpbGVfbW1hcCgpIGhvb2tzKSB0cmFuc3BhcmVudGx5
LiBUaGF0IHNhaWQsIElNQS9MU00gaW1wbGVtZW50YXRpb25zL3BvbGljaWVzIHdpbGwgZGljdGF0
ZSB0aGUgc3VjY2Vzcy9mYWlsdXJlIG9mIHRob3NlIG9wZW4oKS9tbWFwKCkgc3lzY2FsbHMuIEFu
ZCBieSBkZXBlbmRpbmcgRVBDTSBhdHRyaWJ1dGVzIG9uIHBlcm1pc3Npb25zIG9mIHNvdXJjZSBW
TUFzLCBubyBFWEVDIHBhZ2UgY291bGQgYmUgZXZlciBjcmVhdGVkIHVubGVzcyB0aGUgc291cmNl
IHBhZ2UgKHdoaWNoIGhhcyB0byBiZSBFWEVDLCBidHcpIGhhcyBwYXNzZWQgSU1BL0xTTSBjaGVj
a3MgKGFzIGlmIGl0IHdlcmUgbG9hZGVkIGZyb20gYSByZWd1bGFyIHNoYXJlZCBvYmplY3QgZmls
ZSkuDQoNCi1DZWRyaWMgDQoNCg==
