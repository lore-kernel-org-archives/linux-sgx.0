Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A7EC433FE
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 15:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 048B861262
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 15:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbhI1Pn2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 28 Sep 2021 11:43:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:24877 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241080AbhI1Pn1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 28 Sep 2021 11:43:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224771875"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="224771875"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 08:41:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="616766951"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 28 Sep 2021 08:41:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 08:41:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 08:41:46 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.012;
 Tue, 28 Sep 2021 08:41:46 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: RE: [PATCH v7 3/7] x86/sgx: Initial poison handling for dirty and
 free pages
Thread-Topic: [PATCH v7 3/7] x86/sgx: Initial poison handling for dirty and
 free pages
Thread-Index: AQHXs+eHriXnbXxy5E2eyNmJWowVQqu5M54AgABgRLA=
Date:   Tue, 28 Sep 2021 15:41:46 +0000
Message-ID: <ca3bb671a49141608ac981012091c3ea@intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
         <20210927213452.212470-1-tony.luck@intel.com>
         <20210927213452.212470-4-tony.luck@intel.com>
 <3efcda381b49651004e230f6ef008032842db1f9.camel@kernel.org>
In-Reply-To: <3efcda381b49651004e230f6ef008032842db1f9.camel@kernel.org>
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

Pj4gQWRkIGRlYnVnZnMgZmlsZXMgL3N5cy9rZXJuZWwvZGVidWcvc2d4L3BvaXNvbl9wYWdlX2xp
c3Qgc28gdGhhdCBzeXN0ZW0NCj4+IGFkbWluaXN0cmF0b3JzIGdldCBhIGxpc3Qgb2YgdGhvc2Ug
cGFnZXMgdGhhdCBoYXZlIGJlZW4gZHJvcHBlZCBiZWNhdXNlDQo+PiBvZiBwb2lzb24uDQo+DQo+
IFNvLCB3aGF0IHdvdWxkIGEgc3lzYWRtaW4gZG8gd2l0aCB0aGF0IGRldGFpbGVkIGluZm9ybWF0
aW9uPw0KDQpJdCdzIGdvaW5nIHRvIGJlIGEgcmFyZSBjYXNlIHRoYXQgdGhlcmUgYXJlIGFueSBw
b2lzb25lZCBwYWdlcyBvbiB0aGF0IGxpc3QNCihhIGxhcmdlIGVub3VnaCBjbHVzdGVyIHdpbGwg
aGF2ZSBzb21lIHN5c3RlbXMgdGhhdCBoYXZlIHVuY29ycmVjdGVkDQpyZWNvdmVyYWJsZSBlcnJv
cnMgaW4gU0dYIEVQQyBtZW1vcnkpLg0KDQpFdmVuIHdoZW4gdGhlcmUgYXJlIHNvbWUgcG9pc29u
ZWQgcGFnZXMsIHRoZXJlIHdpbGwgb25seSBiZSBhIGZldy4gU3lzdGVtcw0KdGhhdCBoYXZlIHRo
b3VzYW5kcyBvZiBwYWdlcyB3aXRoIHVuY29ycmVjdGVkIG1lbW9yeSBlcnJvcnMgd2lsbCBzdXJl
bHkgY3Jhc2gNCmJlY2F1c2Ugb25lIG9mIHRob3NlIGVycm9ycyBpcyBnb2luZyB0byBlaXRoZXIg
dHJpZ2dlciBhbiBlcnJvciBtYXJrZWQgYXMgZmF0YWwsDQpvciB0aGUgZXJyb3Igd29u4oCZdCBi
ZSByZWNvdmVyYWJsZSBieSBMaW51eCBiZWNhdXNlIGl0IGlzIGluIGtlcm5lbCBtZW1vcnkuDQoN
CkEgc3lzYWRtaW4gbWlnaHQgYWRkIGEgc2NyaXB0IHRvIHJ1biBkdXJpbmcgc3lzdGVtIHNodXRk
b3duIChvciBwZXJpb2RpY2FsbHkNCmR1cmluZyBydW4tdGltZSkgdG8gc2F2ZSB0aGUgcG9pc29u
IHBhZ2UgbGlzdC4gVGhlbiBhdCBzdGFydHVwIHJ1bjoNCg0KZm9yIGFkZHIgaW4gYGNhdCBzYXZl
ZF9zZ3hfcG9pc29uX3BhZ2VfbGlzdGANCmRvDQoJZWNobyAkYWRkciA+IC9zeXMvZGV2aWNlcy9z
eXN0ZW0vbWVtb3J5L2hhcmRfb2ZmbGluZV9wYWdlDQpkb25lDQoNCnRvIG1ha2UgcG9pc29uIHBl
cnNpc3RlbnQgYWNyb3NzIHJlYm9vdHMuDQoNCi1Ub255DQo=
