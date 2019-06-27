Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66865C48BE3
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 20:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F022133F
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 20:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfF0U3l (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 16:29:41 -0400
Received: from mga05.intel.com ([192.55.52.43]:25859 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbfF0U3l (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jun 2019 16:29:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 13:29:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,424,1557212400"; 
   d="scan'208";a="337698628"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga005.jf.intel.com with ESMTP; 27 Jun 2019 13:29:40 -0700
Received: from orsmsx158.amr.corp.intel.com (10.22.240.20) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Jun 2019 13:29:40 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX158.amr.corp.intel.com ([169.254.10.128]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 13:29:40 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [RFC PATCH v4 07/12] LSM: x86/sgx: Introduce ->enclave_map()
 hook for Intel SGX
Thread-Topic: [RFC PATCH v4 07/12] LSM: x86/sgx: Introduce ->enclave_map()
 hook for Intel SGX
Thread-Index: AQHVJu298pW6xqsp60O41aqgonY6j6amVH7ggAcBrICAAqlbcA==
Date:   Thu, 27 Jun 2019 20:29:39 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551B85C@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-8-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551847B@ORSMSX116.amr.corp.intel.com>
 <8235709b-9034-4751-30ce-720e41e31525@tycho.nsa.gov>
In-Reply-To: <8235709b-9034-4751-30ce-720e41e31525@tycho.nsa.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzM1OTAyNTktOGE5OC00NGFjLWI1M2EtM2UwMjNkYzQxZTZhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibmcyMndhbmFaK0tYVSs5d3hkQzlKZGNUQWN2clFaQW5ObWhTbW1xeWU2S2xyak5jcGI5cWtnSkcwWkNic0kxYiJ9
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

PiBGcm9tOiBsaW51eC1zZ3gtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGludXgtc2d4
LQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBTdGVwaGVuIFNtYWxsZXkN
Cj4gU2VudDogVHVlc2RheSwgSnVuZSAyNSwgMjAxOSAxOjQ4IFBNDQo+IA0KPiBPbiA2LzIxLzE5
IDEyOjU0IFBNLCBYaW5nLCBDZWRyaWMgd3JvdGU6DQo+ID4+IEZyb206IENocmlzdG9waGVyc29u
LCBTZWFuIEoNCj4gPj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDE5LCAyMDE5IDM6MjQgUE0NCj4g
Pj4NCj4gPj4gZGlmZiAtLWdpdCBhL3NlY3VyaXR5L3NlY3VyaXR5LmMgYi9zZWN1cml0eS9zZWN1
cml0eS5jIGluZGV4DQo+ID4+IDYxM2E1YzAwZTYwMi4uMDM5NTFlMDhiZGZjIDEwMDY0NA0KPiA+
PiAtLS0gYS9zZWN1cml0eS9zZWN1cml0eS5jDQo+ID4+ICsrKyBiL3NlY3VyaXR5L3NlY3VyaXR5
LmMNCj4gPj4gQEAgLTIzNTksMyArMjM1OSwxMCBAQCB2b2lkIHNlY3VyaXR5X2JwZl9wcm9nX2Zy
ZWUoc3RydWN0DQo+IGJwZl9wcm9nX2F1eCAqYXV4KQ0KPiA+PiAgIAljYWxsX3ZvaWRfaG9vayhi
cGZfcHJvZ19mcmVlX3NlY3VyaXR5LCBhdXgpOw0KPiA+PiAgIH0NCj4gPj4gICAjZW5kaWYgLyog
Q09ORklHX0JQRl9TWVNDQUxMICovDQo+ID4+ICsNCj4gPj4gKyNpZmRlZiBDT05GSUdfSU5URUxf
U0dYDQo+ID4+ICtpbnQgc2VjdXJpdHlfZW5jbGF2ZV9tYXAodW5zaWduZWQgbG9uZyBwcm90KSB7
DQo+ID4+ICsJcmV0dXJuIGNhbGxfaW50X2hvb2soZW5jbGF2ZV9tYXAsIDAsIHByb3QpOyB9ICNl
bmRpZiAvKg0KPiA+PiArQ09ORklHX0lOVEVMX1NHWCAqLw0KPiA+DQo+ID4gV2h5IGlzIHRoaXMg
bmV3IHNlY3VyaXR5X2VuY2xhdmVfbWFwKCkgbmVjZXNzYXJ5IHdoaWxlDQo+IHNlY3VyaXR5X21t
YXBfZmlsZSgpIHdpbGwgYWxzbyBiZSBpbnZva2VkPw0KPiANCj4gc2VjdXJpdHlfbW1hcF9maWxl
KCkgZG9lc24ndCBrbm93IGFib3V0IGVuY2xhdmVzLiAgSXQgd2lsbCBqdXN0IGVuZCB1cA0KPiBj
aGVja2luZyBGSUxFX19SRUFELCBGSUxFX19XUklURSwgYW5kIEZJTEVfX0VYRUNVVEUgdG8gL2Rl
di9zZ3gvZW5jbGF2ZS4NCj4gVGhpcyB3YXMgbm90ZWQgaW4gdGhlIHBhdGNoIGRlc2NyaXB0aW9u
Lg0KDQpTdXJlbHkgSSB1bmRlcnN0YW5kIGFsbCB0aG9zZS4gQXMgSSBtZW50aW9uZWQgaW4gbXkg
b3RoZXIgZW1haWwsIGVuY2xhdmVfbG9hZCgpIGNvdWxkIGluZGljYXRlIHRvIExTTSB0aGF0IGEg
ZmlsZSBpcyBhbiBlbmNsYXZlLiBPZiBjb3Vyc2UgbW1hcCgpIGNvdWxkIGJlIGludm9rZWQgYmVm
b3JlIGFueSBwYWdlcyBhcmUgbG9hZGVkIHNvIExTTSB3b3VsZG4ndCBrbm93IGF0IHRoZSBmaXJz
dCBtbWFwKCksIGJ1dCB0aGF0IGRvZXNuJ3QgbWF0dGVyIGFzIGFuIGVtcHR5IGVuY2xhdmUgd291
bGRuJ3QgcG9zdCBhbnkgdGhyZWF0cyBhbnl3YXkuDQo=
