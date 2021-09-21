Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BF6C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Sep 2021 20:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A0C160F6E
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Sep 2021 20:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhIUUvn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 21 Sep 2021 16:51:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:2351 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232145AbhIUUvm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 21 Sep 2021 16:51:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="223493202"
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="223493202"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 13:50:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="512468408"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 21 Sep 2021 13:50:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 13:50:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 13:50:11 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.012;
 Tue, 21 Sep 2021 13:50:11 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
CC:     "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 2/7] x86/sgx: Add infrastructure to identify SGX EPC
 pages
Thread-Topic: [PATCH v5 2/7] x86/sgx: Add infrastructure to identify SGX EPC
 pages
Thread-Index: AQHXrAxnZDX1Yl9E4Uu8UQt85PjUBauvanYA//+PLtA=
Date:   Tue, 21 Sep 2021 20:50:11 +0000
Message-ID: <eeeb51049e894a70b40013ec18a9fa65@intel.com>
References: <20210827195543.1667168-1-tony.luck@intel.com>
 <20210917213836.175138-1-tony.luck@intel.com>
 <20210917213836.175138-3-tony.luck@intel.com>
 <ccb678fc-25b8-dcd6-ffaa-267865c66ea5@intel.com>
In-Reply-To: <ccb678fc-25b8-dcd6-ffaa-267865c66ea5@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Pj4gIAlzZWN0aW9uLT5waHlzX2FkZHIgPSBwaHlzX2FkZHI7DQo+PiArCXNlY3Rpb24tPmVuZF9w
aHlzX2FkZHIgPSBwaHlzX2FkZHIgKyBzaXplIC0gMTsNCj4+ICsJeGFfc3RvcmVfcmFuZ2UoJmVw
Y19wYWdlX3Jhbmdlcywgc2VjdGlvbi0+cGh5c19hZGRyLA0KPj4gKwkJICAgICAgIHNlY3Rpb24t
PmVuZF9waHlzX2FkZHIsIHNlY3Rpb24sIEdGUF9LRVJORUwpOw0KPg0KPiBEaWQgd2UgZXZlciBm
aWd1cmUgb3V0IGhvdyBtdWNoIHNwYWNlIHN0b3JpbmcgcmVhbGx5IGJpZyByYW5nZXMgaW4gdGhl
DQo+IHhhcnJheSBjb25zdW1lcz8NCg0KTm8uIFdpbGx5IHNhaWQgdGhlIGV4aXN0aW5nIHhhcnJh
eSBjb2RlIHdvdWxkIGJlIGxlc3MgdGhhbiBvcHRpbWFsIHdpdGgNCnRoaXMgdXNhZ2UsIGJ1dCB0
aGF0IHRoaW5ncyB3b3VsZCBiZSBtdWNoIGJldHRlciB3aGVuIGhlIGFwcGxpZWQgc29tZQ0KbWFw
bGUgdHJlZSB1cGRhdGVzIHRvIHRoZSBpbnRlcm5hbHMgb2YgeGFycmF5Lg0KDQpJZiB0aGVyZSBp
cyBzb21lIGVhc3kgd2F5IHRvIG1lYXN1cmUgdGhlIG1lbW9yeSBiYWNraW5nIGFuIHhhcnJheSBJ
J20NCmhhcHB5IHRvIGdldCB0aGUgZGF0YS4gT3IgaWYgc29tZW9uZSBlbHNlIGNhbiBzeW50aGVz
aXplIGl0IC4uLiB0aGUgdHdvDQpyYW5nZXMgb24gbXkgc3lzdGVtIHRoYXQgYXJlIGFkZGVkIHRv
IHRoZSB4YXJyYXkgYXJlOg0KDQokIGRtZXNnIHwgZ3JlcCAtaSBzZ3gNClsgICAgOC40OTY4NDRd
IHNneDogRVBDIHNlY3Rpb24gMHg4MDAwYzAwMDAwLTB4ODA3ZjdmZmZmZg0KWyAgICA4LjUwNTEx
OF0gc2d4OiBFUEMgc2VjdGlvbiAweDEwMDAwYzAwMDAwLTB4MTAwN2ZmZmZmZmYNCg0KSS5lLiB0
d28gcmFuZ2VzIG9mIGEgYml0IHVuZGVyIDJHQiBlYWNoLg0KDQpCdXQgSSBkb24ndCB0aGluayB0
aGUgb3ZlcmhlYWQgY2FuIGJlIHRvbyBoaWRlb3VzOg0KDQokIGdyZXAgTWVtRnJlZSAvcHJvYy9t
ZW1pbmZvDQpNZW1GcmVlOiAgICAgICAgMTA0ODY4MjAxNiBrQg0KDQpJIHN0aWxsIGhhdmUgfiAx
VEIgZnJlZS4gV2hpY2ggaXMgbXVjaCBncmVhdGVyIHRoYXQgdGhlIDY0MCBLQiB3aGljaCBzaG91
bGQNCmJlICJlbm91Z2ggZm9yIGFueWJvZHkiIDotKS4NCg0KLVRvbnkNCg==
