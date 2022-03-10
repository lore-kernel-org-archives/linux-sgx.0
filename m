Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9EBAC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Mar 2022 05:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiCJFZ1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Mar 2022 00:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiCJFZ0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 10 Mar 2022 00:25:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F46710D4
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 21:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646889865; x=1678425865;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=v/gSEYYyqkZG8gJS9omU7n+pEaoesg/5k0FjiuyDtgo=;
  b=QJe0CVn5dtOLrJHUY5vs8vHdSLtEGGxefcDZrCEDkJevvShNfiPeqv/O
   GryM1vTfcGQUUYwzSrIHGJP7yN7ctTkv7Z7JIwxNmHc3ZSw2x80p2mZT4
   mm6D1vClw94PDiUOTo8bI6ePnnMRoTBe/0N7TIDiZHe7y1VMT4QLof1wM
   N9cxzPZ6ak6M0QtwvyaIbnTKRzpU68AagwjX/jO3r3R+K7bekV0RULHOw
   KEK1zt2vXSnXAfW7pCFpvlid19DExcUk5n0FrPkzCSLzc/0BOC3YXa8zX
   ZCgsyK/+NU8NC+kAc9SVFA4RgwRLWhN1OMOPtRVLPrC6nbAnG6aQJwvZg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="254897396"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="254897396"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 21:24:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="510766486"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 09 Mar 2022 21:24:25 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 21:24:24 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 21:24:23 -0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.021;
 Thu, 10 Mar 2022 13:24:21 +0800
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [RFC PATCH 00/11] Support microcode updates affecting SGX
Thread-Topic: [RFC PATCH 00/11] Support microcode updates affecting SGX
Thread-Index: AQHYM6IVktmAyyEgpEqK30RfEey+Q6y2/EQAgAEY31A=
Date:   Thu, 10 Mar 2022 05:24:21 +0000
Message-ID: <86db310117904ce99165f308227b71a7@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
 <78b2e9f9-3be0-8670-a827-0a8fe7bf9ba6@intel.com>
In-Reply-To: <78b2e9f9-3be0-8670-a827-0a8fe7bf9ba6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-reaction: no-action
dlp-product: dlpe-windows
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGkgRGF2ZSwgVGhvbWFzLA0KDQpUaGFua3MgZm9yIGhlbHBpbmcgcmV2aWV3IQ0KDQpJIHdpbGwg
cmVtb3ZlIHRoZSBuZXcgQUJJIGFuZCBsZXQgbWljcm9jb2RlIHVwZGF0ZSBwcm9jZXNzIGNhbGwg
dGhlIGludGVyZmFjZSBkaXJlY3RseSB0byBjbGVhbiB1cCBFUEMgYW5kIGRvIEVVUERBVEVTVk4u
IFBsZWFzZSBsZXQgbWUga25vdyBpZiB5b3UgaGF2ZSBvdGhlciBzdWdnZXN0aW9uLg0KDQo+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhhbnNlbiwgRGF2ZSA8ZGF2ZS5oYW5z
ZW5AaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMTAsIDIwMjIgNDozMyBBTQ0K
PiBUbzogWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+OyBsaW51eC1zZ3hAdmdl
ci5rZXJuZWwub3JnOw0KPiB4ODZAa2VybmVsLm9yZzsgUmFqLCBBc2hvayA8YXNob2sucmFqQGlu
dGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggMDAvMTFdIFN1cHBvcnQgbWljcm9j
b2RlIHVwZGF0ZXMgYWZmZWN0aW5nIFNHWA0KPiANCj4gT24gMy85LzIyIDAyOjQwLCBDYXRoeSBa
aGFuZyB3cm90ZToNCj4gPiBUaGlzIHNlcmllcyBpbXBsZW1lbnRzIHRoZSBpbmZyYXN0cnVjdHVy
ZSBuZWVkZWQgdG8gdHJhY2sgYW5kIHRlYXINCj4gPiBkb3duIGJhcmUtbWV0YWwgZW5jbGF2ZXMg
YW5kIHRoZW4gcnVuIEVVUERBVEVTVk4uIFRoaXMgaXMgZXhwZWN0ZWQgdG8NCj4gPiBiZSB0cmln
Z2VyZWQgYnkgYWRtaW5pc3RyYXRvcnMgdmlhIHN5c2ZzIGF0IHNvbWUgY29udmVuaWVudCB0aW1l
IGFmdGVyDQo+ID4gYSBtaWNyb2NvZGUgdXBkYXRlLCBwcm9iYWJseSBieSB0aGUgbWljcm9jb2Rl
IHVwZGF0ZSB0b29saW5nIGl0c2VsZi4NCj4gDQo+IENhdGh5LCBpZiBpdCBpc24ndCBhYnVuZGFu
dGx5IGNsZWFyIGJ5IG5vdywgZXZlcnlvbmUgc2VlbXMgdG8gaGF0ZSB0aGlzIHBhcnQgb2YNCj4g
dGhlIGltcGxlbWVudGF0aW9uLg0KPiANCj4gTGV0J3MganVzdCBtYWtlIHRoaXMganVzdCBkbyBF
VVBEQVRFU1ZOIGFzIGEgcGFydCBvZiB0aGUgbWljcm9jb2RlIHVwZGF0ZQ0KPiBwcm9jZXNzLiAg
Tm8gbmV3IEFCSS4gIE5vIHRyeWluZyB0byBwcmVzZXJ2ZSBlbmNsYXZlcy4gIEtpbGwgdGhlbSBl
YXJseSwga2lsbA0KPiB0aGVtIGFsbCwgYW5kIGJlIGRvbmUgd2l0aCBpdC4NCj4gDQo+IElmIHdl
IG1lcmdlIHRoYXQgYW5kIHdlIGhhdmUgZW5kIHVzZXJzIGNoYXNpbmcgdXMgd2l0aCB0b3JjaGVz
IGFuZA0KPiBwaXRjaGZvcmtzIGJlY2F1c2UgdGhlaXIgcHJlY2lvdXMgZW5jbGF2ZXMgd2VyZSB0
b3JuIGRvd24sIHdlJ2xsIHRoaW5rIGFib3V0DQo+IGRvaW5nIHNvbWV0aGluZyBkaWZmZXJlbnQu
DQo=
