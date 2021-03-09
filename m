Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6229CC433E0
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Mar 2021 17:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A32264FCF
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Mar 2021 17:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhCIRQN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Mar 2021 12:16:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:43996 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231382AbhCIRQG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Mar 2021 12:16:06 -0500
IronPort-SDR: ODf6VxckW8QFaooauv7u9Ix93GD2S4YR8MmLYgIeWwl/jJuW5DXSCqCyfDa0Q30qWmFO0S518j
 MfLX+sMcFG3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="184921211"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="184921211"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 09:16:04 -0800
IronPort-SDR: tF16Bv29ZUMnR2FHS7sFWgDZEQQTQRNStbCvjWCgPz9K/AL8ydbyBjbDH08CF1rng72vD31K6w
 pqnYPINpWoZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="520394791"
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138])
  by orsmga004.jf.intel.com with ESMTP; 09 Mar 2021 09:16:03 -0800
Received: from irsmsx605.ger.corp.intel.com (163.33.146.138) by
 IRSMSX605.ger.corp.intel.com (163.33.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 17:16:02 +0000
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138]) by
 IRSMSX605.ger.corp.intel.com ([163.33.146.138]) with mapi id 15.01.2106.013;
 Tue, 9 Mar 2021 17:16:02 +0000
From:   "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
To:     "Huang, Haitao" <haitao.huang@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Mahalingam, Ganesh" <ganesh.mahalingam@intel.com>,
        "Narjala, Ranjit S" <ranjit.s.narjala@intel.com>,
        "Helm, Kent" <kent.helm@intel.com>,
        "Mathew, Shama" <shama.mathew@intel.com>,
        "Kumar, Deepak1" <deepak1.kumar@intel.com>,
        "Saffores, Ryan D" <ryan.d.saffores@intel.com>,
        "Vij, Mona" <mona.vij@intel.com>,
        "Kuvaiskii, Dmitrii" <dmitrii.kuvaiskii@intel.com>,
        "Jaramillo, Alex V" <alex.v.jaramillo@intel.com>,
        "Hossain, Md Iqbal" <md.iqbal.hossain@intel.com>
CC:     "Sterrett, Craig" <craig.sterrett@intel.com>,
        "Macieira, Thiago" <thiago.macieira@intel.com>,
        "Salunke, Manoj" <manoj.salunke@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Gandhi, Jinen" <jinen.gandhi@intel.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>
Subject: Re: SGX Performance Creep
Thread-Topic: SGX Performance Creep
Thread-Index: AQHXFHzNiiQNrGe3IkOTkCy07u2cH6p75sWA
Date:   Tue, 9 Mar 2021 17:16:02 +0000
Message-ID: <f5392a42d34cf5da6f0367ce14f1250461d42eb0.camel@intel.com>
References: <BYAPR11MB274479307F08C6AE305FB9A8F2BA9@BYAPR11MB2744.namprd11.prod.outlook.com>
         <MWHPR11MB19048655E5942E21F4D78983DA819@MWHPR11MB1904.namprd11.prod.outlook.com>
         <edb58aeb-6f6a-236c-046d-b692377cc550@intel.com>
         <BYAPR11MB274441F17146490289EED9A3F2819@BYAPR11MB2744.namprd11.prod.outlook.com>
         <DM6PR11MB4723CB5D0DF41F38FB59154399819@DM6PR11MB4723.namprd11.prod.outlook.com>
         <d5d851d7-ebb0-df51-2684-b916f2b47432@intel.com>
         <BYAPR11MB2744D84CAB45A321D7B83389F2819@BYAPR11MB2744.namprd11.prod.outlook.com>
         <BYAPR11MB2744212BCA03E628DA29D2C8F2809@BYAPR11MB2744.namprd11.prod.outlook.com>
         <MW3PR11MB468192CCAC4C2B12DFF7EC99F9809@MW3PR11MB4681.namprd11.prod.outlook.com>
         <MW3PR11MB46012C10D9526DE48641512FB6809@MW3PR11MB4601.namprd11.prod.outlook.com>
         <MW3PR11MB47295620E26A7612D81FCB2899809@MW3PR11MB4729.namprd11.prod.outlook.com>
         <b9bb309e2385537e02bac93ad29d43b8b86e5143.camel@intel.com>
         <MW3PR11MB47295461B3E28FEEA28AE8A1999F9@MW3PR11MB4729.namprd11.prod.outlook.com>
         <990a55e9-5160-c2ae-08ab-7e1d277bd310@intel.com>
In-Reply-To: <990a55e9-5160-c2ae-08ab-7e1d277bd310@intel.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.1]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8062AA9B388AF341B271C7C6A9E7B9A2@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gTW9uLCAyMDIxLTAzLTA4IGF0IDE2OjQwIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
SSBnb3QgbXkgaGFuZHMgb24gYSBOVUM3Q0pZSCwgd2hpY2ggaXMgdGhlIGZpcnN0IHBpZWNlIG9m
IGZ1bmN0aW9uYWwNCj4gRmxleGlibGUgTGF1bmNoIENvbnRyb2wgaGFyZHdhcmUgSSd2ZSBhY3R1
YWxseSBsYWlkIG15IGhhbmRzIG9uLg0KPiANCj4gSSB3ZW50IGxvb2tpbmcgZm9yIGFueSAicGVy
Zm9ybWFuY2UgY3JlZXAiLsKgIEkgdHJpZWQgYSB2ZXJ5IHNpbXBsZSB0ZXN0Og0KPiBDcmVhdGUg
YW5kIHJ1biBhbiBlbmNsYXZlIHRoYXQgdG91Y2hlcyBhIDY0TUIgc3RhdGljYWxseS1hbGxvY2F0
ZWQNCj4gYnVmZmVyLsKgIChUaGUgcGF0Y2ggdG8gdGhlIGtlcm5lbCBzZWxmdGVzdCB0byBkbyB0
aGlzIGlzIGF0dGFjaGVkKS4NCj4gDQo+IHRsO2RyOiBJJ20gbm90IHNlZWluZyBhbnkgbWVhbmlu
Z2Z1bCBjaGFuZ2UgaW4gcnVudGltZXMsIGV2ZW4gYWZ0ZXINCj4gcnVubmluZyBhbmQgdGVhcmlu
ZyBkb3duIHRoZSBlbmNsYXZlIGZvciA2LTcgaG91cnMuDQo+IA0KPiBJJ20gcnVubmluZyB0aGUg
c2VsZnRlc3QgbGlrZSB0aGlzLCBjcmVhdGluZyBhIGxvZyBmaWxlIHdpdGggL3Vzci9iaW4vdGlt
ZToNCj4gDQo+IE5PVz0kKGRhdGUgKyVzKTsgbWFrZSAmJiB3aGlsZSB0cnVlOyBkbyAvdXNyL2Jp
bi90aW1lIC4vdGVzdF9zZ3ggPj4NCj4gJE5PVy5sb2cgMj4+ICROT1cudGltZWxvZyB8fCBicmVh
azsgZG9uZQ0KPiANCj4gVGhpcyBsZXRzIG1lIGRvIGEgcXVpY2sgYW5kIGRpcnR5IGhpc3RvZ3Jh
bSBvZiB0aGUgcnVudGltZXMuwqAgTm90ZSB0aGF0DQo+IHRoZXJlJ3MgYSBzaW5nbGUsIG5pY2Ug
cGVhay7CoCBJdCdzIG5vdCAic21lYXJlZCIgbGlrZSBJIHdvdWxkIGV4cGVjdA0KPiBmcm9tIHNs
b3dseS1kZWdyYWRpbmcgcnVuIHRpbWVzLg0KPiANCj4gJCBjYXQgMTYxNTIyOTk3Ni50aW1lbG9n
wqAgfCBncmVwIGVsYXBzZWQgfCBhd2sgJ3twcmludCAkMX0nIHwgc29ydCB8IHVuaXEgLWMNCj4g
wqDCoMKgwqDCoCA0IDIuMDh1c2VyDQo+IMKgwqDCoMKgIDE0IDIuMDl1c2VyDQo+IMKgwqDCoCAx
MDYgMi4xMHVzZXINCj4gwqDCoMKgIDQwMyAyLjExdXNlcg0KPiDCoMKgIDEwNTUgMi4xMnVzZXIN
Cj4gwqDCoCAxNTE4IDIuMTN1c2VyDQo+IMKgwqAgMTI2OCAyLjE0dXNlcg0KPiDCoMKgwqAgNzI2
IDIuMTV1c2VyDQo+IMKgwqDCoCAzMDIgMi4xNnVzZXINCj4gwqDCoMKgwqAgOTYgMi4xN3VzZXIN
Cj4gwqDCoMKgwqAgMjMgMi4xOHVzZXINCj4gwqDCoMKgwqDCoCA4IDIuMTl1c2VyDQo+IMKgwqDC
oMKgwqAgMSAyLjIwdXNlcg0KDQpJIHRoaW5rIGl0IHdvdWxkIGJlIGEgZ3JlYXQgZW5oYW5jZW1l
bnQgZm9yIHRoZSBzZWxmLXRlc3QsIGlmIHlvdSBjb3VsZA0KDQoxLiBNYWtlIHRoZSB0ZXN0IHBy
b2dyYW0gY2hhbmdlIGF0dGFjaGVkLg0KMi4gQ3JlYXRlIGEgc2NyaXB0IGZvciBzdHJlc3MgdGVz
dCBhbmQgaGlzdG9ncmFtLg0KDQoNCj4gDQo+IEknbGwgcnVuIGZvciBhbm90aGVyIGRheSBvciB0
d28gYW5kIHNlZSBpZiBhbnl0aGluZyBpbnRlcmVzdGluZyBzaG93cw0KPiB1cC7CoCBCdXQsIGZv
ciBub3csIG5vdGhpbmcgaW50ZXJlc3RpbmcgaXMgaGFwcGVuaW5nLsKgIFdoYXRldmVyIGZvbGtz
IGFyZQ0KPiBzZWVpbmcsIGl0IGRvZXNuJ3Qgc2VlbSB0byBiZSBwcmVzZW50IG9uIG15IGxpdHRs
ZSBzaW1wbGUgdGVzdCBjYXNlLCBvcg0KPiB0aGlzIEF0b20tYmFzZWQgaGFyZHdhcmUuDQo+IA0K
PiBUaGUga2VybmVsIGlzOiBzdG9jayA1LjEyLjAtcmMyLg0KPiBUaGUgQ1BVIGlzOiBJbnRlbChS
KSBDZWxlcm9uKFIpIEo0MDA1IENQVSBAIDIuMDBHSHoNCj4gDQoNCi9KYXJra28NCg==
