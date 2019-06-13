Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225FCC31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 21:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F32A821473
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 21:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbfFMVJa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 17:09:30 -0400
Received: from mga06.intel.com ([134.134.136.31]:4042 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfFMVJa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 17:09:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 14:09:29 -0700
X-ExtLoop1: 1
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jun 2019 14:09:28 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX108.amr.corp.intel.com ([169.254.2.211]) with mapi id 14.03.0415.000;
 Thu, 13 Jun 2019 14:09:28 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Stephen Smalley" <sds@tycho.nsa.gov>
CC:     "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "pmccallum@redhat.com" <pmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Thread-Topic: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks
 in SELinux
Thread-Index: AQHVH1ilvNGS2ZisK0eWTCWidam/YaaW7RmA///+7GCAA25ngIAAHjKA//+fg4A=
Date:   Thu, 13 Jun 2019 21:09:27 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65503E13@ORSMSX116.amr.corp.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F65502A85@ORSMSX116.amr.corp.intel.com>
 <b7f3decf-b1d2-01b1-6294-ccf9ba2d5df4@tycho.nsa.gov>
 <20190613194833.GB18385@linux.intel.com>
In-Reply-To: <20190613194833.GB18385@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOGUwZGZjY2YtYTUwNi00ODI2LTg0ZjMtYTBhM2YwY2UwYmM5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMVNLeVlodVhoQXZPXC9kZmxOb3dydVFtWmZYYm5McWZEeGxXRHByM1dBOWlaS3Nwa1FJMHNHdmgxZmxtMUE5akoifQ==
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

PiBGcm9tOiBDaHJpc3RvcGhlcnNvbiwgU2VhbiBKDQo+IFNlbnQ6IFRodXJzZGF5LCBKdW5lIDEz
LCAyMDE5IDEyOjQ5IFBNDQo+IA0KPiA+ID5CeSAiU0dYIiwgZGlkIHlvdSBtZWFuIHRoZSBTR1gg
c3Vic3lzdGVtIGJlaW5nIHVwc3RyZWFtZWQ/IEl0IGRvZXNu4oCZdA0KPiA+ID50cmFjayB0aGF0
IHN0YXRlLiBJbiBwcmFjdGljZSwgdGhlcmUncyBubyB3YXkgZm9yIFNHWCB0byB0cmFjayBpdA0K
PiA+ID5iZWNhdXNlIHRoZXJlJ3Mgbm8gdm1fb3BzLT5tYXlfbXByb3RlY3QoKSBjYWxsYmFjay4g
SXQgZG9lc24ndCBmb2xsb3cNCj4gPiA+dGhlIHBoaWxvc29waHkgb2YgTGludXggZWl0aGVyLCBh
cyBtcHJvdGVjdCgpIGRvZXNuJ3QgdHJhY2sgaXQgZm9yDQo+ID4gPnJlZ3VsYXIgbWVtb3J5LiBB
bmQgaXQgZG9lc24ndCBoYXZlIGEgdXNlIHdpdGhvdXQgTFNNLCBzbyBJIGJlbGlldmUNCj4gPiA+
aXQgbWFrZXMgbW9yZSBzZW5zZSB0byB0cmFjayBpdCBpbnNpZGUgTFNNLg0KPiA+DQo+ID4gWWVz
LCB0aGUgU0dYIGRyaXZlci9zdWJzeXN0ZW0uICBJIGhhZCB0aGUgaW1wcmVzc2lvbiBmcm9tIFNl
YW4gdGhhdCBpdA0KPiA+IGRvZXMgdHJhY2sgdGhpcyBraW5kIG9mIHBlci1wYWdlIHN0YXRlIGFs
cmVhZHkgaW4gc29tZSBtYW5uZXIsIGJ1dA0KPiA+IHBvc3NpYmx5IGhlIG1lYW5zIGl0IGRvZXMg
dW5kZXIgYSBnaXZlbiBwcm9wb3NhbCBhbmQgbm90IGluIHRoZQ0KPiBjdXJyZW50IGRyaXZlci4N
Cj4gDQo+IFllYWgsIHVuZGVyIGEgZ2l2ZW4gcHJvcG9zYWwuICBTR1ggaGFzIHBlci1wYWdlIHRy
YWNraW5nLCBhZGRpbmcgbmV3DQo+IGZsYWdzIGlzIGZhaXJseSBlYXN5LiAgUGhpbG9zb3BoaWNh
bCBvYmplY3Rpb25zIGFzaWRlLA0KPiBhZGRpbmcgLm1heV9tcHJvdGVjdCgpIGlzIHRyaXZpYWwu
DQoNCkFzIEkgcG9pbnRlZCBvdXQgaW4gYW4gZWFybGllciBlbWFpbCwgcHJvdGVjdGlvbiBmbGFn
cyBhcmUgYXNzb2NpYXRlZCB3aXRoIHJhbmdlcy4gVGhleSBjb3VsZCBvZiBjb3Vyc2UgYmUgZHVw
bGljYXRlZCB0byBldmVyeSBwYWdlIGJ1dCB0aGF0IHdpbGwgaHVydCBwZXJmb3JtYW5jZSBiZWNh
dXNlIGV2ZXJ5IHBhZ2Ugd2l0aGluIHRoZSByYW5nZSB3b3VsZCBoYXZlIHRvIGJlIHRlc3RlZCBp
bmRpdmlkdWFsbHkuDQoNCkZ1cnRoZXJtb3JlLCB0aG91Z2ggLm1heV9wcm90ZWN0KClpcyBhYmxl
IHRvIG1ha2UgdGhlIGRlY2lzaW9uLCBJIGRvbid0IHRoaW5rIGl0IGNhbiBkbyB0aGUgYXVkaXQg
bG9nIGFzIHdlbGwsIHVubGVzcyBpdCBpcyBjb2RlZCBpbiBhbiBTRUxpbnV4IHNwZWNpZmljIHdh
eS4gVGhlbiBJIHdvbmRlciBob3cgaXQgY291bGQgd29yayB3aXRoIExTTSBtb2R1bGVzIG90aGVy
IHRoYW4gU0VMaW51eC4NCg0KPiANCj4gPiBFdmVuIHRoZSAjYiByZW1lbWJlcmluZyBtaWdodCBl
bmQgdXAgYmVpbmcgU0VMaW51eC1zcGVjaWZpYyBpZiB3ZSBhbHNvDQo+ID4gaGF2ZSB0byByZW1l
bWJlciB0aGUgb3JpZ2luYWwgaW5wdXRzIHVzZWQgdG8gY29tcHV0ZSB0aGUgYW5zd2VyIHNvDQo+
ID4gdGhhdCB3ZSBjYW4gYXVkaXQgdGhhdCBpbmZvcm1hdGlvbiB3aGVuIGFjY2VzcyBpcyBkZW5p
ZWQgbGF0ZXIgdXBvbg0KPiA+IG1wcm90ZWN0KCkuICBBdCB0aGUgbGVhc3Qgd2UnZCBuZWVkIGl0
IHRvIHNhdmUgc29tZSBvcGFxdWUgZGF0YSBhbmQNCj4gPiBwYXNzIGl0IHRvIGEgY2FsbGJhY2sg
aW50byBTRUxpbnV4IHRvIHBlcmZvcm0gdGhhdCBhdWRpdGluZy4NCg==
