Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF5AC433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Sep 2021 21:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBF5061131
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Sep 2021 21:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbhIUVgF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 21 Sep 2021 17:36:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:60349 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235422AbhIUVgF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 21 Sep 2021 17:36:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="221582336"
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="221582336"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 14:34:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="435235808"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga006.jf.intel.com with ESMTP; 21 Sep 2021 14:34:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 14:34:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 14:34:34 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.012;
 Tue, 21 Sep 2021 14:34:34 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 1/7] x86/sgx: Provide indication of life-cycle of EPC
 pages
Thread-Topic: [PATCH v5 1/7] x86/sgx: Provide indication of life-cycle of EPC
 pages
Thread-Index: AQHXrAxnIongNzZ1PEqWcazcdLfLRquvfG0A//+LjvA=
Date:   Tue, 21 Sep 2021 21:34:34 +0000
Message-ID: <4c7351bcd03b4161b78a7dc01c795b43@intel.com>
References: <20210827195543.1667168-1-tony.luck@intel.com>
         <20210917213836.175138-1-tony.luck@intel.com>
         <20210917213836.175138-2-tony.luck@intel.com>
 <bba7e537fd9197a92358640ebb0aef365984cebc.camel@kernel.org>
In-Reply-To: <bba7e537fd9197a92358640ebb0aef365984cebc.camel@kernel.org>
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

Pj4gU2luY2UgdGhlcmUgYXJlIG11bHRpcGxlIHVzZXMgb2YgdGhlICJvd25lciIgZmllbGQgd2l0
aCBkaWZmZXJlbnQgdHlwZXMNCj4+IGNoYW5nZSB0aGUgc2d4X2VwY19wYWdlIHN0cnVjdHVyZSB0
byBkZWZpbmUgYW4gYW5vbnltb3VzIHVuaW9uIHdpdGgNCj4+IGVhY2ggb2YgdGhlIHVzZXMgZXhw
bGljaXRseSBjYWxsZWQgb3V0Lg0KPg0KPiBCdXQgaXQncyBzdGlsbCBhbHdheXMgYSBwb2ludGVy
Lg0KPg0KPiBBbmQgbm90IG9ubHkgdGhhdCwgYnV0IHR3byBhbHRlcm5hdGl2ZSBmaWVsZHMgaW4g
dGhhdCB1bmlvbiBoYXZlICpleGFjdGx5KiB0aGUNCj4gc2FtZSB0eXBlLCBzbyBpdCdzIGtpbmQg
b2YgYXJ0aWZpY2FsbHkgcmVwcmVzZW50aW5nIHRoZSBwcm9ibGVtIG1vcmUgY29tcGxleA0KPiB0
aGFuIGl0IHJlYWxseSBpcy4NCg0KQm90aGVyISBJIHNlZW0gdG8gaGF2ZSBqdW1ibGVkIHNvbWUg
b2xkIGJpdHMgb2YgdjQgaW50byB0aGlzIHNlcmllcy4NCg0KSSBhZ3JlZSB0aGF0IHdlIGp1c3Qg
d2FudCAidm9pZCAqb3duZXI7IGhlcmUuICBJIGV2ZW4gbWFkZSB0aGUgY2hhbmdlcy4NClRoZW4g
bWFuYWdlZCB0byBsb3NlIHRoZW0gd2hpbGUgdXBkYXRpbmcuDQoNCkknbGwgZmluZCB0aGUgYml0
cyBJIGxvc3QgYW5kIHJlLW1lcmdlIHRoZW0gaW4uDQoNCi1Ub255DQo=
