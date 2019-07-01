Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78C6C0650E
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 19:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8221206A3
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 19:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfGATW6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 15:22:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:41177 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfGATW6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 15:22:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 12:22:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="163779368"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jul 2019 12:22:56 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX106.amr.corp.intel.com ([169.254.1.191]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 12:22:56 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: RE: [RFC PATCH v4 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Thread-Topic: [RFC PATCH v4 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Thread-Index: AQHVJu27XnLeOL4jVkKHLIzqsJHQ+6a2lScA//+fsZA=
Date:   Mon, 1 Jul 2019 19:22:55 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D70B@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-5-sean.j.christopherson@intel.com>
 <CALCETrXtVzCZW4mb994prdrzXxMP2T=xxU+fhy5k9N8AqjcqhA@mail.gmail.com>
In-Reply-To: <CALCETrXtVzCZW4mb994prdrzXxMP2T=xxU+fhy5k9N8AqjcqhA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjVjNTVhZTctZDhiOC00NzE2LThhMzYtZDhjZTllZTFjMTc0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRWY2clpqQWZwTkFtVHQ2MDQzbEZSc1g5RHZsQkxiamlIbTlVSFdIYjB0T3NwdXFWdGVxaTA2c04rZGlXRktNViJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5vcmddDQo+IFNlbnQ6
IE1vbmRheSwgSnVseSAwMSwgMjAxOSAxMTowMCBBTQ0KPiANCj4gT24gV2VkLCBKdW4gMTksIDIw
MTkgYXQgMzoyNCBQTSBTZWFuIENocmlzdG9waGVyc29uDQo+IDxzZWFuLmouY2hyaXN0b3BoZXJz
b25AaW50ZWwuY29tPiB3cm90ZToNCj4gPiAgc3RhdGljIGludCBzZ3hfbW1hcChzdHJ1Y3QgZmls
ZSAqZmlsZSwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpICB7DQo+ID4gICAgICAgICBzdHJ1
Y3Qgc2d4X2VuY2wgKmVuY2wgPSBmaWxlLT5wcml2YXRlX2RhdGE7DQo+ID4gKyAgICAgICB1bnNp
Z25lZCBsb25nIGFsbG93ZWRfcnd4Ow0KPiA+ICAgICAgICAgaW50IHJldDsNCj4gPg0KPiA+ICsg
ICAgICAgYWxsb3dlZF9yd3ggPSBzZ3hfYWxsb3dlZF9yd3goZW5jbCwgdm1hKTsNCj4gPiArICAg
ICAgIGlmICh2bWEtPnZtX2ZsYWdzICYgKFZNX1JFQUQgfCBWTV9XUklURSB8IFZNX0VYRUMpICYN
Cj4gfmFsbG93ZWRfcnd4KQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVBQ0NFUzsNCj4g
PiArDQo+ID4gICAgICAgICByZXQgPSBzZ3hfZW5jbF9tbV9hZGQoZW5jbCwgdm1hLT52bV9tbSk7
DQo+ID4gICAgICAgICBpZiAocmV0KQ0KPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0K
PiA+DQo+ID4gKyAgICAgICBpZiAoIShhbGxvd2VkX3J3eCAmIFZNX1JFQUQpKQ0KPiA+ICsgICAg
ICAgICAgICAgICB2bWEtPnZtX2ZsYWdzICY9IH5WTV9NQVlSRUFEOw0KPiA+ICsgICAgICAgaWYg
KCEoYWxsb3dlZF9yd3ggJiBWTV9XUklURSkpDQo+ID4gKyAgICAgICAgICAgICAgIHZtYS0+dm1f
ZmxhZ3MgJj0gflZNX01BWVdSSVRFOw0KPiA+ICsgICAgICAgaWYgKCEoYWxsb3dlZF9yd3ggJiBW
TV9FWEVDKSkNCj4gPiArICAgICAgICAgICAgICAgdm1hLT52bV9mbGFncyAmPSB+Vk1fTUFZRVhF
QzsNCj4gPiArDQo+IA0KPiBJJ20gd2l0aCBDZWRyaWMgaGVyZSAtLSB0aGlzIGlzIG5vIGdvb2Qu
ICBUaGUgcmVhc29uIEkgdGhpbmsgd2UNCj4gbmVlZCAubWF5X21wcm90ZWN0IG9yIHNpbWlsYXIg
aXMgZXhhY3RseSB0byBhdm9pZCBkb2luZyB0aGlzLg0KPiANCj4gbW1hcCgpIGp1c3QgbmVlZHMg
dG8gbWFrZSB0aGUgc2FtZSB0eXBlIG9mIFZNQSByZWdhcmRsZXNzIG9mIHRoZSBwYWdlcw0KPiBp
biB0aGUgcmFuZ2UuDQoNCkluc3RlYWQgb2YgbWFraW5nIGRlY2lzaW9ucyBvbiBpdHMgb3duLCBh
IG1vcmUgZ2VuZXJpYyBhcHByb2FjaCBpcyBmb3IgU0dYIHN1YnN5c3RlbS9tb2R1bGUgdG8gYXNr
IExTTSBmb3IgYSBkZWNpc2lvbiwgYnkgY2FsbGluZyBzZWN1cml0eV9maWxlX21wcm90ZWN0KCkg
LSBhcyBhIG5ldyBtYXBwaW5nIGNvdWxkIGJlIGNvbnNpZGVyZWQgYXMgY2hhbmdpbmcgcHJvdGVj
dGlvbiBmcm9tIFBST1RfTk9ORSB0byAodm1hLT52bV9mbGFncyAmIChWTV9SRUFEIHwgVk1fV1JJ
VEUgfCBWTV9FWEVDKSkuDQoNCi5tYXlfbXByb3RlY3QoKSBhbHNvIHNvbHZlcyBwYXJ0IG9mIHRo
ZSBwcm9ibGVtIC0gaS5lLiBWTUFzIHdpbGwgYmUgY3JlYXRlZCBjb25zaXN0ZW50bHkgYnV0IG5v
bi1leGlzdGVudCBwYWdlcyBzdGlsbCBjYW5ub3QgYmUgbWFwcGVkLCB3aGljaCBob3dldmVyIGlz
IG5lY2Vzc2FyeSBmb3IgI1BGIGRyaXZlbiBFQVVHIGluIFNHWDIuIEdpdmVuIHRoYXQgc2VjdXJp
dHlfZmlsZV9tcHJvdGVjdCgpIGlzIGludm9rZWQgYnkgbXByb3RlY3QoKSBzeXNjYWxsLCBpdCBs
b29rcyB0byBtZSBhIG1vcmUgc3RyZWFtbGluZWQgc29sdXRpb24gdG8gY2FsbCB0aGUgc2FtZSBo
b29rIChzZWN1cml0eV9maWxlX21wcm90ZWN0KSBmcm9tIGJvdGggcGxhY2VzIChtbWFwIGFuZCBt
cHJvdGVjdCkuIA0K
