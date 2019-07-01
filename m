Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC35C46478
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 19:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB4F121721
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 19:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfGAT4W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 15:56:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:47610 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbfGAT4W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 15:56:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 12:56:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="154194235"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga007.jf.intel.com with ESMTP; 01 Jul 2019 12:56:21 -0700
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 12:56:21 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.198]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 12:56:20 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Topic: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Index: AQHVLG/L9SgvyZq9qEim/LcvveBd6KazxkIAgAI8SeCAAIcaAP//kNKQgACKcwD//4xFUA==
Date:   Mon, 1 Jul 2019 19:56:20 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D75B@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <CALCETrWQUEEwAAdPrVQMengKDhX3-fVrtJwaP2i=mWD+s+B8vg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D4B3@ORSMSX116.amr.corp.intel.com>
 <CALCETrUR=W3rfmG+qHydm0FQvASSYRt_V72v5WeQ4KWT7tjEdA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D5FA@ORSMSX116.amr.corp.intel.com>
 <CALCETrUAme7ujK3j-6gg1=_FtVGY3ZM8WBg9_9Sn-keywd7Smg@mail.gmail.com>
In-Reply-To: <CALCETrUAme7ujK3j-6gg1=_FtVGY3ZM8WBg9_9Sn-keywd7Smg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDllMjY0MjgtOTA3OS00NmU2LWFkZWMtMzM4NDE4NDE3NzBhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUEFYK3ZQSG56WFpaZnc4WThnV2ZXYVUxN3RLMGJXUTZwTGxLWHlDUDA4QXN5WmJrVjhWZXZKNXpJZnFTTWFtUSJ9
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

PiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5vcmddDQo+IFNlbnQ6
IE1vbmRheSwgSnVseSAwMSwgMjAxOSAxMjozNiBQTQ0KPiANCj4gT24gTW9uLCBKdWwgMSwgMjAx
OSBhdCAxMTozMSBBTSBYaW5nLCBDZWRyaWMgPGNlZHJpYy54aW5nQGludGVsLmNvbT4NCj4gd3Jv
dGU6DQo+ID4gSSBpbnRlbmRlZCB0byBzYXkgdGhlIG1ham9yIHJlYXNvbiBJIG9iamVjdGVkIFNl
YW4ncyBhcHByb2FjaCB3YXMgaXRzDQo+IGluYWJpbGl0eSB0byBzdXBwb3J0IFNHWDIgc21vb3Ro
bHkgLSBhcyAjUEYgZHJpdmVuIEVBVUcgcmVxdWlyZXMgbm9uLQ0KPiBleGlzdGVudCBwYWdlcyB0
byBiZSBtbWFwKCknZWQsIG90aGVyd2lzZSB2bV9vcHMtPmZhdWx0IHdvdWxkbid0IGJlDQo+IGRp
c3BhdGNoZWQgc28gRUFVRyBjb3VsZG4ndCBiZSBpc3N1ZWQgaW4gcmVzcG9uc2UgdG8gI1BGLg0K
PiANCj4gSSBzdGlsbCB0aGluayB0aGF0LCBpZiB0aGUga2VybmVsIHdhbnRzIHRvIHN1cHBvcnQg
I1BGLWRyaXZlbiBFQVVHLCBpdA0KPiBzaG91bGQgYmUgYW4gb3B0LWluIHRoaW5nLiAgSXQgd291
bGQgYmUgc29tZXRoaW5nIGxpa2UNCj4gU0dYX0lPQ19BRERfTEFaWV9FQVVHX1BBR0VTIG9yIHNp
bWlsYXIuICBJZiBpdCdzIGRvbmUgdGhhdCB3YXksIHRoZW4NCj4gdGhlIGRyaXZlciBuZWVkcyB0
byBsZWFybiBob3cgdG8gdHJhY2sgcmFuZ2VzIG9mIHBhZ2VzIGVmZmljaWVudGx5LA0KPiB3aGlj
aCBpcyBhbm90aGVyIHJlYXNvbiB0byBjb25zaWRlciBsZWF2aW5nIGFsbCB0aGUgZmFuY3kgcGFn
ZSAvIHBhZ2UNCj4gcmFuZ2UgdHJhY2tpbmcgaW4gdGhlIGRyaXZlci4NCj4gDQo+IEkgZG9uJ3Qg
dGhpbmsgaXQncyBhIGdvb2QgaWRlYSBmb3IgYSBwYWdlIGZhdWx0IG9uIGFueSBub24tRUFERGVk
IHBhZ2UNCj4gaW4gRUxSQU5HRSB0byBhdXRvbWF0aWNhbGx5IHBvcHVsYXRlIHRoZSBwYWdlLg0K
DQpJJ20gd2l0aCB5b3UuIFRoZSB1c2VyIGNvZGUgc2hhbGwgYmUgZXhwbGljaXQgb24gd2hpY2gg
cmFuZ2UgdG8gRUFVRyBwYWdlcyB1cG9uICNQRi4gV2hhdCBJJ20gc2F5aW5nIGlzLCBhIHJhbmdl
IGhhcyB0byBiZSBtYXBwZWQgYmVmb3JlIHRoZSBkcml2ZXIgY291bGQgcmVjZWl2ZSAjUEZzIChp
biB0aGUgZm9ybSBvZiB2bV9vcHMtPmZhdWx0IGNhbGxiYWNrcykuIEJ1dCBTZWFuJ3Mgc2VyaWVz
IGRvZXNu4oCZdCBzdXBwb3J0IHRoYXQgYmVjYXVzZSBubyBwYWdlcyBjYW4gYmUgbWFwcGVkIGJl
Zm9yZSBjb21pbmcgaW50byBleGlzdGVuY2UuDQoNCkZvciAicGFnZSB0cmFja2luZyIsIHdoYXQg
aW5mb3JtYXRpb24gdG8gdHJhY2sgaXMgTFNNIGRlcGVuZGVudCwgc28gaXQgbWF5IHJ1biBpbnRv
IHByb2JsZW1zIGlmIGRpZmZlcmVudCBMU01zIHdhbnQgdG8gdHJhY2sgZGlmZmVyZW50IHRoaW5n
cy4gQW5kIHRoYXQncyB0aGUgbWFqb3IgcmVhc29uIEkgdGhpbmsgaXQgc2hvdWxkIGJlIGRvbmUg
aW5zaWRlIExTTS4gDQoNCkJlc2lkZXMsIHRoZSBjdXJyZW50IHBhZ2UgdHJhY2tpbmcgc3RydWN0
dXJlIGluIHRoZSBkcml2ZXIgaXMgcGFnZSBvcmllbnRlZCBhbmQgaXRzIHNvbGUgcHVycG9zZSBp
cyB0byBzZXJ2ZSAjUEZzLiBQYWdlIHByb3RlY3Rpb24gaXMgYmV0dGVyIHRyYWNrZWQgdXNpbmcg
cmFuZ2Ugb3JpZW50ZWQgc3RydWN0dXJlcy4gVGhvc2UgMiBhcmUgb3J0aG9nb25hbC4gSXQgd291
bGRuJ3QgcmVkdWNlIHRoZSBjb21wbGV4aXR5IG9mIHRoZSB3aG9sZSBrZXJuZWwgYnkgbW92aW5n
IGl0IGludG8gU0dYIGRyaXZlci4gDQo=
