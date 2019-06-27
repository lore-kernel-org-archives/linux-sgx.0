Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7B2C004E6
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 20:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EF1820665
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 20:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfF0U0Y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 16:26:24 -0400
Received: from mga12.intel.com ([192.55.52.136]:15704 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfF0U0Y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jun 2019 16:26:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 13:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,424,1557212400"; 
   d="scan'208";a="183530464"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jun 2019 13:26:23 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Jun 2019 13:26:22 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.185]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 13:26:22 -0700
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
Subject: RE: [RFC PATCH v4 08/12] security/selinux: Require SGX_MAPWX to map
 enclave page WX
Thread-Topic: [RFC PATCH v4 08/12] security/selinux: Require SGX_MAPWX to
 map enclave page WX
Thread-Index: AQHVJu2+pgr/3JM48UeUDAsxgoYlgKamWU8wgAcBp4CAAqKVEA==
Date:   Thu, 27 Jun 2019 20:26:21 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551B843@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-9-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F655184C3@ORSMSX116.amr.corp.intel.com>
 <6f86681a-5478-c46c-b74a-52a973b53320@tycho.nsa.gov>
In-Reply-To: <6f86681a-5478-c46c-b74a-52a973b53320@tycho.nsa.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDgyMGI5YTAtYmI3My00NjQyLWE1YjktNjU2MGE4M2ViOWQ4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZUFWSkZQUk94UG0rTXE3T3Z4UTdTajdMXC9UUnhhSlIyUmlkcmtlK2hTUkMyeEdBN3NhNWlOK2w1elA3XC9rQnRMIn0=
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
Cj4gU2VudDogVHVlc2RheSwgSnVuZSAyNSwgMjAxOSAyOjA2IFBNDQo+IA0KPiBPbiA2LzIxLzE5
IDE6MDkgUE0sIFhpbmcsIENlZHJpYyB3cm90ZToNCj4gPj4gRnJvbTogQ2hyaXN0b3BoZXJzb24s
IFNlYW4gSg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIEp1bmUgMTksIDIwMTkgMzoyNCBQTQ0KPiA+
Pg0KPiA+PiBkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvc2VsaW51eC9ob29rcy5jIGIvc2VjdXJpdHkv
c2VsaW51eC9ob29rcy5jDQo+ID4+IGluZGV4IDNlYzcwMmNmNDZjYS4uZmMyMzllNTQxYjYyIDEw
MDY0NA0KPiA+PiAtLS0gYS9zZWN1cml0eS9zZWxpbnV4L2hvb2tzLmMNCj4gPj4gKysrIGIvc2Vj
dXJpdHkvc2VsaW51eC9ob29rcy5jDQo+ID4+IEBAIC02NzI2LDYgKzY3MjYsMjMgQEAgc3RhdGlj
IHZvaWQgc2VsaW51eF9icGZfcHJvZ19mcmVlKHN0cnVjdA0KPiBicGZfcHJvZ19hdXggKmF1eCkN
Cj4gPj4gICB9DQo+ID4+ICAgI2VuZGlmDQo+ID4+DQo+ID4+ICsjaWZkZWYgQ09ORklHX0lOVEVM
X1NHWA0KPiA+PiArc3RhdGljIGludCBzZWxpbnV4X2VuY2xhdmVfbWFwKHVuc2lnbmVkIGxvbmcg
cHJvdCkgew0KPiA+PiArCWNvbnN0IHN0cnVjdCBjcmVkICpjcmVkID0gY3VycmVudF9jcmVkKCk7
DQo+ID4+ICsJdTMyIHNpZCA9IGNyZWRfc2lkKGNyZWQpOw0KPiA+PiArDQo+ID4+ICsJLyogU0dY
IGlzIHN1cHBvcnRlZCBvbmx5IGluIDY0LWJpdCBrZXJuZWxzLiAqLw0KPiA+PiArCVdBUk5fT05f
T05DRSghZGVmYXVsdF9ub2V4ZWMpOw0KPiA+PiArDQo+ID4+ICsJaWYgKChwcm90ICYgUFJPVF9F
WEVDKSAmJiAocHJvdCAmIFBST1RfV1JJVEUpKQ0KPiA+PiArCQlyZXR1cm4gYXZjX2hhc19wZXJt
KCZzZWxpbnV4X3N0YXRlLCBzaWQsIHNpZCwNCj4gPj4gKwkJCQkgICAgU0VDQ0xBU1NfUFJPQ0VT
UzIsIFBST0NFU1MyX19TR1hfTUFQV1gsDQo+ID4+ICsJCQkJICAgIE5VTEwpOw0KPiA+DQo+ID4g
V2h5IGlzbid0IFNHWF9NQVBXWCBlbmNsYXZlIHNwZWNpZmljIGJ1dCBwcm9jZXNzIHdpZGU/DQo+
IA0KPiBIb3cgd291bGQgeW91IHRpZSBpdCB0byBhIHNwZWNpZmljIGVuY2xhdmU/ICBXaGF0J3Mg
dGhlIG9iamVjdC90YXJnZXQNCj4gU0lEPyAgVGhlIFNJRCBvZiB0aGUgZW5jbGF2ZSBpbm9kZT8g
IFdoaWNoIG9uZT8gIFRoZSBzb3VyY2Ugdm1hIGZpbGUsDQo+IHRoZSAvZGV2L3NneC9lbmNsYXZl
IG9wZW4gaW5zdGFuY2UsIHRoZSBzaWdzdHJ1Y3QgZmlsZSwgLi4uPyAgSWYgYQ0KPiBwcm9jZXNz
IGNhbiBtYXAgb25lIGVuY2xhdmUgV1gsIHdoYXQncyB0aGUgYmVuZWZpdCBvZiBwcmV2ZW50aW5n
IGl0IGZyb20NCj4gZG9pbmcgbGlrZXdpc2UgZm9yIGFueSBvdGhlciBlbmNsYXZlIGl0IGNhbiBs
b2FkPw0KDQpJIHdhc24ndCBzYXlpbmcgd2Ugc2hvdWxkLiBSYXRoZXIsIEkgdGhpbmsgd2UgY2Fu
IHJldXNlIEVYRUNNRU0uIEFmdGVyIGFsbCwgdW5kZXIgd2hhdCBjaXJjdW1zdGFuY2VzIGFyZSBX
WCBuZWNlc3Nhcnk/IElNSE8sIFdYIHNoYWxsIGJlIHN0cm9uZ2x5IGRpc2NvdXJhZ2VkIGFuZCB0
aGlzIFNHWF9NQVBXWCBpcyBraW5kIG9mIHRyeWluZyB0byBnaXZlIHRoZSBiZWFyaW5nIGVuY2xh
dmUgYSBkaXJ0eSBsb29rLiBBbmQgaWYgdGhhdCdzIHRoZSBzb2xlIHB1cnBvc2UsIGxldCdzIG1h
a2UgaXQgZXZlbiBkaXJ0aWVyIGJ5IHJlcXVpcmluZyBFWEVDTUVNIG9uIHRoZSBob3N0IHByb2Nl
c3MuIEFmdGVyIGFsbCwgV1ggaXMgbmV2ZXIgYSBnb29kIHRoaW5nIGluIHNlY3VyaXR5IHNvIEkg
ZG91YnQgYW55IElTVnMgd291bGQgaGF2ZSBhIHByYWN0aWNhbCByZWFzb24gdG8gcmVxdWlyZSBX
WCBpbiB0aGVpciBlbmNsYXZlcy4NCg==
