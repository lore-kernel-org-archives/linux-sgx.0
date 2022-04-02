Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C41C433EF
	for <linux-sgx@archiver.kernel.org>; Sat,  2 Apr 2022 02:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiDBCz5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 22:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiDBCz4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 22:55:56 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1C33EBB3
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 19:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648868044; x=1680404044;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fCIfli0kcmuTVNsMk2zCgsMw55CxihhwQHwMt0FGNX8=;
  b=ZDeteJP+xgERkvKgeKV9Xl/3ChFgz0PDrRJvDLKC/XCaGouPZAmZQ8X5
   Pz5BdOzotA28oCJFviSEJJp2HfQto+CklCF5WDtF8WIvt4IX+yS0f0YDK
   hmmuCdWNyaGdKpKhAQK2594Ie84v5CXQXjNJYjXbcin7I7khJqvK7BpnW
   wCKXy5LS4EuqKDo8H8FPfQI6BW1tzLWCAYGjQAzZRJkFN6KQssVf/m4Tk
   ciOC60HixeMTw4X5X9z7+imYPkWtiSZNOP+91gPTmxqUERhE+UwfSkgq7
   +Yu52/kCH0jUTcQiSZQzWAGinUatnw7CUyXLFb2mVLMrgg7LuwlVdePKl
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="285206798"
X-IronPort-AV: E=Sophos;i="5.90,229,1643702400"; 
   d="scan'208";a="285206798"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 19:54:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,229,1643702400"; 
   d="scan'208";a="568023941"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 01 Apr 2022 19:54:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Apr 2022 19:54:03 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Apr 2022 19:54:02 -0700
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84]) by
 fmsmsx604.amr.corp.intel.com ([10.18.126.84]) with mapi id 15.01.2308.027;
 Fri, 1 Apr 2022 19:54:02 -0700
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [RFC PATCH v3 09/10] x86/cpu: Call ENCLS[EUPDATESVN] procedure in
 microcode update
Thread-Topic: [RFC PATCH v3 09/10] x86/cpu: Call ENCLS[EUPDATESVN] procedure
 in microcode update
Thread-Index: AQHYRdQ5llePF2ePjEKmwm4O3CAD66zbk4oAgABT6oA=
Date:   Sat, 2 Apr 2022 02:54:02 +0000
Message-ID: <20a83d9e11fe46a4a6ab798d4e65a50e@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-10-cathy.zhang@intel.com> <YkcMVh2ostXlhr5t@zn.tnic>
In-Reply-To: <YkcMVh2ostXlhr5t@zn.tnic>
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

SGkgQm9yaXMsDQoNClRoYW5rcyBmb3IgaGVscGluZyByZXZpZXchDQoNCj4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQm9yaXNsYXYgUGV0a292IDxicEBhbGllbjguZGU+DQo+
IFNlbnQ6IEZyaWRheSwgQXByaWwgMSwgMjAyMiAxMDozMCBQTQ0KPiBUbzogWmhhbmcsIENhdGh5
IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+IENjOiBsaW51eC1zZ3hAdmdlci5rZXJuZWwub3Jn
OyB4ODZAa2VybmVsLm9yZzsgamFya2tvQGtlcm5lbC5vcmc7IENoYXRyZSwNCj4gUmVpbmV0dGUg
PHJlaW5ldHRlLmNoYXRyZUBpbnRlbC5jb20+OyBIYW5zZW4sIERhdmUNCj4gPGRhdmUuaGFuc2Vu
QGludGVsLmNvbT47IFJhaiwgQXNob2sgPGFzaG9rLnJhakBpbnRlbC5jb20+DQo+IFN1YmplY3Q6
IFJlOiBbUkZDIFBBVENIIHYzIDA5LzEwXSB4ODYvY3B1OiBDYWxsIEVOQ0xTW0VVUERBVEVTVk5d
DQo+IHByb2NlZHVyZSBpbiBtaWNyb2NvZGUgdXBkYXRlDQo+IA0KPiBPbiBGcmksIEFwciAwMSwg
MjAyMiBhdCAxMDoyNDowOFBNICswODAwLCBDYXRoeSBaaGFuZyB3cm90ZToNCj4gPiBAQCAtMjA4
Niw2ICsyMDg3LDE0IEBAIHZvaWQgbWljcm9jb2RlX2NoZWNrKHZvaWQpDQo+ID4NCj4gPiAgCXBl
cmZfY2hlY2tfbWljcm9jb2RlKCk7DQo+ID4NCj4gPiArCS8qDQo+ID4gKwkgKiBTR1ggcmVsYXRl
ZCBtaWNyb2NvZGUgdXBkYXRlIHJlcXVpcmVzIEVVUERBVEVTVk4gdG8gdXBkYXRlDQo+IENQVVNW
Tiwgd2hpY2gNCj4gPiArCSAqIHdpbGwgZGVzdHJveSBhbGwgZW5jbGF2ZXMgdG8gZW5zdXJlIEVQ
QyBpcyBub3QgaW4gdXNlLiBJZiBTR1ggaXMNCj4gY29uZmlndXJlZA0KPiA+ICsJICogYW5kIEVV
UERBVEVTVk4gaXMgc3VwcG9ydGVkLCBjYWxsIHRoZSBFVVBEQVRFU1ZOIHByb2NlY3VyZS4NCj4g
PiArCSAqLw0KPiA+ICsJaWYgKElTX0VOQUJMRUQoQ09ORklHX1g4Nl9TR1gpICYmIChjcHVpZF9l
YXgoU0dYX0NQVUlEKSAmDQo+ID4gK1NHWF9DUFVJRF9FVVBEQVRFU1ZOKSkNCj4gDQo+IFN0aWNr
IGFsbCB0aGF0IGFib3ZlLi4uDQoNClRoZSBjb21tZW50IGlzIHJlLXdyaXR0ZW4gYXMgZm9sbG93
czoNCg0KICAgICAgICAvKg0KICAgICAgICAgKiBTR1ggYXR0ZXN0YXRpb24gaW5jb3Jwb3JhdGVz
IHRoZSBtaWNyb2NvZGUgdmVyc2lvbnMgb2YgYWxsIHByb2Nlc3NvcnMNCiAgICAgICAgICogb24g
dGhlIHN5c3RlbSBhbmQgaXMgYWZmZWN0ZWQgYnkgbWljcm9jb2RlIHVwZGF0ZXMuIFNvLCB1cGRh
dGUgU0dYDQogICAgICAgICAqIGF0dGVzdGF0aW9uIG1ldHJpYyAoY2FsbGVkIENQVVNWTikgdG8g
ZW5zdXJlIGVuY2xhdmVzIGF0dGVzdCB0byB0aGUNCiAgICAgICAgICogbmV3IHZlcnNpb24gYWZ0
ZXIgbWljcm9jb2RlIHVwZGF0ZS4NCiAgICAgICAgICovDQoNCj4gDQo+ID4gKwkJdXBkYXRlX2Nw
dXN2bl9pbnRlbCgpOw0KPiANCj4gLi4uaW5zaWRlIHRoaXMgZnVuY3Rpb24gc28gdGhhdCB5b3Ug
aGF2ZSBvbmx5IHRoZSBjYWxsIGhlcmUuIEluc2lkZSB0aGUgZnVuY3Rpb24NCj4geW91IGNhbiBk
byBhbGwgdGhlIGlmZGVmZmVyeSwgY2hlY2tpbmcgYW5kIGNvbW1lbnRpbmcgYW5kIHNvIG9uLiBK
dXN0IGxpa2UNCj4gcGVyZl9jaGVja19taWNyb2NvZGUoKSBkb2VzLg0KPiANCg0KVGhhbmtzIGZv
ciBzaG93aW5nIG1lIHRoZSBleGFtcGxlISBJJ3ZlIHJlZmVycmVkLg0KDQo+IFRoeC4NCj4gDQo+
IC0tDQo+IFJlZ2FyZHMvR3J1c3MsDQo+ICAgICBCb3Jpcy4NCj4gDQo+IGh0dHBzOi8vcGVvcGxl
Lmtlcm5lbC5vcmcvdGdseC9ub3Rlcy1hYm91dC1uZXRpcXVldHRlDQo=
