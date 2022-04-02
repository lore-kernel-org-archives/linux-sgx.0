Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7720DC433EF
	for <linux-sgx@archiver.kernel.org>; Sat,  2 Apr 2022 03:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiDBDEH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 23:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiDBDEG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 23:04:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E8867D25
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 20:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648868535; x=1680404535;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wIntDutnvLYrFfFexy5ySNgzOg2bNXgBg7Qutxtj+ec=;
  b=iyRHraivlWjpRPtlgKxOVAHkKtm7Jj1cMV495Plykh8767CKVi1CLwjY
   /GmfcLy3GfK+Hi1gBurPaEoD2gvtKMlT2wfgOEDWZkdIdV0EdTI4mcRoa
   8eq6edHhNw0DJ5b8xGhZw1/f66UXS6I5Q0/tWvREJNeXE6/7pQ7OcwsQa
   CA2hEbVVaKaUwBogmdEfxEreX6O2f7/5Scf0ucW1W0fyV3giJ87cXKFcK
   x1LIhz7pN5icozJmeZeoTWSzJORXfnLbu23alMekdVX3PrJOEKC/Absfo
   SAuQGfBFuf15sz7wSFupLSxA5w7vhwfrAuhTH8/24TnMStvMn0YZmKIVP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="285207262"
X-IronPort-AV: E=Sophos;i="5.90,229,1643702400"; 
   d="scan'208";a="285207262"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 20:02:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,229,1643702400"; 
   d="scan'208";a="650928265"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga002.fm.intel.com with ESMTP; 01 Apr 2022 20:02:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Apr 2022 20:02:14 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Apr 2022 20:02:14 -0700
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84]) by
 fmsmsx604.amr.corp.intel.com ([10.18.126.84]) with mapi id 15.01.2308.027;
 Fri, 1 Apr 2022 20:02:14 -0700
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [RFC PATCH v3 09/10] x86/cpu: Call ENCLS[EUPDATESVN] procedure in
 microcode update
Thread-Topic: [RFC PATCH v3 09/10] x86/cpu: Call ENCLS[EUPDATESVN] procedure
 in microcode update
Thread-Index: AQHYRdQ5llePF2ePjEKmwm4O3CAD66zbp9UAgABGXSA=
Date:   Sat, 2 Apr 2022 03:02:14 +0000
Message-ID: <5c66bcd8e2f143b7996af1c0c25fefa0@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-10-cathy.zhang@intel.com>
 <64c85acb-429b-ee40-22e6-d5ba7e4abee1@intel.com>
In-Reply-To: <64c85acb-429b-ee40-22e6-d5ba7e4abee1@intel.com>
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

SGkgRGF2ZSwNCg0KVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzIGFuZCBzdWdnZXN0aW9ucyENCg0K
PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIYW5zZW4sIERhdmUgPGRhdmUu
aGFuc2VuQGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBBcHJpbCAxLCAyMDIyIDExOjQyIFBN
DQo+IFRvOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT47IGxpbnV4LXNneEB2
Z2VyLmtlcm5lbC5vcmc7DQo+IHg4NkBrZXJuZWwub3JnDQo+IENjOiBqYXJra29Aa2VybmVsLm9y
ZzsgQ2hhdHJlLCBSZWluZXR0ZSA8cmVpbmV0dGUuY2hhdHJlQGludGVsLmNvbT47IFJhaiwNCj4g
QXNob2sgPGFzaG9rLnJhakBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIHYz
IDA5LzEwXSB4ODYvY3B1OiBDYWxsIEVOQ0xTW0VVUERBVEVTVk5dDQo+IHByb2NlZHVyZSBpbiBt
aWNyb2NvZGUgdXBkYXRlDQo+IA0KPiBPbiA0LzEvMjIgMDc6MjQsIENhdGh5IFpoYW5nIHdyb3Rl
Og0KPiA+ICsjaWZuZGVmIHVwZGF0ZV9jcHVzdm5faW50ZWwNCj4gPiArc3RhdGljIGlubGluZSB2
b2lkIHVwZGF0ZV9jcHVzdm5faW50ZWwodm9pZCkge30gI2VuZGlmDQo+ID4gKw0KPiA+ICAjZW5k
aWYgLyogX0FTTV9YODZfTUlDUk9DT0RFX0ggKi8NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
aW5jbHVkZS9hc20vc2d4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zZ3guaA0KPiA+IGluZGV4
IDc0YmNiNjg0MWE0Yi4uNTg2N2Y1YTc4ZDEzIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL3NneC5oDQo+ID4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vc2d4LmgNCj4g
PiBAQCAtNDA5LDQgKzQwOSw5IEBAIGludCBzZ3hfdmlydF9laW5pdCh2b2lkIF9fdXNlciAqc2ln
c3RydWN0LCB2b2lkDQo+ID4gX191c2VyICp0b2tlbiwgIGludCBzZ3hfc2V0X2F0dHJpYnV0ZSh1
bnNpZ25lZCBsb25nICphbGxvd2VkX2F0dHJpYnV0ZXMsDQo+ID4gIAkJICAgICAgdW5zaWduZWQg
aW50IGF0dHJpYnV0ZV9mZCk7DQo+ID4NCj4gPiArI2lmZGVmIENPTkZJR19YODZfU0dYDQo+ID4g
K3ZvaWQgdXBkYXRlX2NwdXN2bl9pbnRlbCh2b2lkKTsNCj4gPiArI2RlZmluZSB1cGRhdGVfY3B1
c3ZuX2ludGVsIHVwZGF0ZV9jcHVzdm5faW50ZWwgI2VuZGlmDQo+ID4gKw0KPiA+ICAjZW5kaWYg
LyogX0FTTV9YODZfU0dYX0ggKi8NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2Nw
dS9jb21tb24uYw0KPiA+IGIvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYyBpbmRleCA3Yjgz
ODJjMTE3ODguLmY1M2ZkODc3YmEwZA0KPiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L2NvbW1vbi5jDQo+ID4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYw0K
PiA+IEBAIC01OSw2ICs1OSw3IEBADQo+ID4gICNpbmNsdWRlIDxhc20vY3B1X2RldmljZV9pZC5o
Pg0KPiA+ICAjaW5jbHVkZSA8YXNtL3V2L3V2Lmg+DQo+ID4gICNpbmNsdWRlIDxhc20vc2lnZnJh
bWUuaD4NCj4gPiArI2luY2x1ZGUgPGFzbS9zZ3guaD4NCj4gPg0KPiA+ICAjaW5jbHVkZSAiY3B1
LmgiDQo+ID4NCj4gPiBAQCAtMjA4Niw2ICsyMDg3LDE0IEBAIHZvaWQgbWljcm9jb2RlX2NoZWNr
KHZvaWQpDQo+ID4NCj4gPiAgCXBlcmZfY2hlY2tfbWljcm9jb2RlKCk7DQo+ID4NCj4gPiArCS8q
DQo+ID4gKwkgKiBTR1ggcmVsYXRlZCBtaWNyb2NvZGUgdXBkYXRlIHJlcXVpcmVzIEVVUERBVEVT
Vk4gdG8gdXBkYXRlDQo+IENQVVNWTiwgd2hpY2gNCj4gPiArCSAqIHdpbGwgZGVzdHJveSBhbGwg
ZW5jbGF2ZXMgdG8gZW5zdXJlIEVQQyBpcyBub3QgaW4gdXNlLiBJZiBTR1ggaXMNCj4gY29uZmln
dXJlZA0KPiA+ICsJICogYW5kIEVVUERBVEVTVk4gaXMgc3VwcG9ydGVkLCBjYWxsIHRoZSBFVVBE
QVRFU1ZOIHByb2NlY3VyZS4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKElTX0VOQUJMRUQoQ09ORklH
X1g4Nl9TR1gpICYmIChjcHVpZF9lYXgoU0dYX0NQVUlEKSAmDQo+IFNHWF9DUFVJRF9FVVBEQVRF
U1ZOKSkNCj4gPiArCQl1cGRhdGVfY3B1c3ZuX2ludGVsKCk7DQo+IA0KPiBJbiBhZGRpdGlvbiB0
byB3aGF0IEJvcmlzbGF2IHNhaWQsIHRoZXNlICNpZmRlZnMgYXJlIG5vdCBob3cgd2UgZG8gdGhp
bmdzLg0KPiANCj4gVGhlIHVwZGF0ZV9jcHVzdm5faW50ZWwoKSBzaG91bGRuJ3QgYmUgZGVjbGFy
ZWQgaW4gdHdvIGRpZmZlcmVudCBoZWFkZXJzLg0KPiBKdXN0IGltYWdpbmUgd2hhdCBoYXBwZW5z
IGlmIHNvbWUgY29kZSBoYXBwZW5zIHRvIGluY2x1ZGUgdGhlIG1pY3JvY29kZQ0KPiBoZWFkZXIg
KnRoZW4qIHRoZSBzZ3guaCBoZWFkZXIuDQo+IA0KPiBQbGVhc2UgZGVmaW5lIGJvdGggdGhlICdz
dGF0aWMgaW5saW5lJyBzdHViICphbmQqIHRoZSBkZWNsYXJhdGlvbiBpbiBzZ3guaC4NCj4gVGhl
biB5b3Ugd29uJ3QgZXZlbiBuZWVkIHRoZSAjaWZuZGVmIHRyaWNrZXJ5LiAgUGxlYXNlIGFsc28g
YWRkIGFuICJzZ3hfIiB0bw0KPiBpdHMgbmFtZSBwcmVmaXggd2hpbGUgeW91J3JlIGF0IGl0Lg0K
DQpNb3ZlZCB0byBzZ3guaCBhbmQgYWRkZWQgInNneF8iLg0KDQo+IA0KPiBUaGF0IGNvbW1lbnQg
aXMgYWxzbyBub3QgZ3JlYXQuICBBIHJlYWRlciB3aWxsIGxpa2VseSBoYXZlICpaRVJPKiBpZGVh
IHdoYXQNCj4gRVVQREFURVNWTiBpcyBvciB3aGF0IGEgQ1BVU1ZOIGlzLiAgVHJ5IHRvIGZvY3Vz
IG9uIHdoYXQgdGhlIGNvZGUNCj4gKm1lYW5zKiByYXRoZXIgdGhhbiBqdXN0IHJlcGVhdCB0aGUg
aWYoKSBjb25kaXRpb25zIGluIHRoZSBjb21tZW50Lg0KDQpZZXMsIEkgc2VlLiBUaGUgdXBkYXRl
IGNvbW1lbnQgaXMgc2hvd24gaW4gbXkgcmVwbHkgdG8gQm9yaXMuIFBsZWFzZSB0YWtlIGEgbG9v
ay4NCg0K
