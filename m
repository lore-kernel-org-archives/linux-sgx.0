Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061A1C12002
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Jul 2021 20:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D38F9613D3
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Jul 2021 20:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhGNVB5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:01:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:11337 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhGNVB5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 14 Jul 2021 17:01:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10045"; a="190108995"
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="190108995"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 13:59:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="651277941"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2021 13:59:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 13:59:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 13:59:03 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.010;
 Wed, 14 Jul 2021 13:59:03 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>
CC:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] x86/sgx: Track phase and type of SGX EPC pages
Thread-Topic: [PATCH 1/4] x86/sgx: Track phase and type of SGX EPC pages
Thread-Index: AQHXdCUcDncuRnkx9Ue+ht5iNpTdPatDbnyA//+NavA=
Date:   Wed, 14 Jul 2021 20:59:03 +0000
Message-ID: <31668f36583844cbbae0b10a594193d6@intel.com>
References: <20210708181423.1312359-1-tony.luck@intel.com>
 <20210708181423.1312359-2-tony.luck@intel.com>
 <93845f78-120d-7522-bd3e-fe042380d29e@intel.com>
In-Reply-To: <93845f78-120d-7522-bd3e-fe042380d29e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBDb3VsZCB0aGlzIHRyYWNraW5nIGJlIGRvbmUgYXQgdGhlIGVuY2xhdmUgcGFnZSAoc3RydWN0
IHNneF9lbmNsX3BhZ2UpIA0KPiBpbnN0ZWFkPw0KDQpJbiBwcmluY2lwbGUgeWVzLiBUaG91Z2gg
U2VhbiBoYXMgc29tZSBpc3N1ZXMgd2l0aCBtZSB0cmFja2luZyB0eXBlcw0KYXQgYWxsLg0KDQo+
IFRoZSBlbmNsYXZlIHBhZ2UncyBFUEMgcGFnZSBpbmZvcm1hdGlvbiBpcyBub3QgYXZhaWxhYmxl
IHdoZW4gDQo+IHRoZSBwYWdlIGlzIGluIHN3YXAgYW5kIGl0IHdvdWxkIGJlIHVzZWZ1bCB0byBr
bm93IHRoZSBwYWdlIHR5cGUgd2l0aG91dCANCj4gbG9hZGluZyB0aGUgcGFnZSBmcm9tIHN3YXAu
IFRoZSBpbmZvcm1hdGlvbiB3b3VsZCBjb250aW51ZSB0byBiZSANCj4gYWNjZXNzaWJsZSBmcm9t
IHN0cnVjdCBlcGNfcGFnZSB2aWEgdGhlIG93bmVyIHBvaW50ZXIgdGhhdCBtYXkgbWFrZSBzb21l
IA0KPiBvZiB0aGUgY2hhbmdlcyBlYXNpZXIgc2luY2UgaXQgd291bGQgbm90IGJlIG5lZWRlZCB0
byBwYXNzIHRoZSBwYWdlIHR5cGUgDQo+IGFyb3VuZCBzbyBtdWNoIGFuZCB0aHVzIHBvc3NpYmx5
IGFkZHJlc3MgdGhlIFNFQ1MgcGFnZSBpc3N1ZSB0aGF0IFNlYW4gDQo+IHBvaW50ZWQgb3V0IGlu
DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvWU8zRnVCdXBRVEtZYUtCZkBnb29nbGUu
Y29tLw0KDQpJIHRoaW5rIEkgbm90aWNlZCB0aGF0IHRoZSAib3duZXIiIHBvaW50ZXIgaW4gc2d4
X2VuY2xfcGFnZSBkb2Vzbid0IHBvaW50DQpiYWNrIHRvIHRoZSBlcGNfcGFnZSBmb3IgYWxsIHR5
cGVzIG9mIFNHWCBwYWdlcy4gU28gc29tZSBhZGRpdGlvbmFsDQpjaGFuZ2VzIHdvdWxkIGJlIG5l
ZWRlZC4gSSdtIG5vdCBhdCBhbGwgc3VyZSB3aHkgdGhpcyBpcyBkaWZmZXJlbnQgKG9yDQp3aGF0
IHVzZSB0aGUgbm9uLVJFRyBwYWdlcyB1c2UgIm93bmVyIiBmb3IuDQoNCj4+ICAgc3RydWN0IHNn
eF9lcGNfcGFnZSB7DQo+PiAgIAl1bnNpZ25lZCBpbnQgc2VjdGlvbjsNCj4+IC0JdW5zaWduZWQg
aW50IGZsYWdzOw0KPj4gKwl1MTYgZmxhZ3M7DQo+PiArCXUxNiB0eXBlOw0KPg0KPiBDb3VsZCB0
aGlzIGJlICJlbnVtIHNneF9wYWdlX3R5cGUgdHlwZSIgPw0KDQpNYXliZS4gSSB0aG91Z2h0IEkg
bmVlZGVkIGV4dHJhIHR5cGVzIChsaWtlIEZSRUUgYW5kIERJUlRZKS4gQnV0DQpTZWFuIHBvaW50
ZWQgb3V0IGhvdyB0byBhdm9pZCBzb21lIG9mIHRoZW0uDQoNCi1Ub255DQo=
