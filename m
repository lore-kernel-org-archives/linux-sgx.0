Return-Path: <SRS0=YIp+=U3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1CBC4646D
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jun 2019 21:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8731D208CB
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jun 2019 21:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfF1VUD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jun 2019 17:20:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:17167 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbfF1VUD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 28 Jun 2019 17:20:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 14:20:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="189576070"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jun 2019 14:20:01 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX104.amr.corp.intel.com ([169.254.4.70]) with mapi id 14.03.0439.000;
 Fri, 28 Jun 2019 14:20:01 -0700
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
Subject: RE: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Thread-Topic: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Thread-Index: AQHVJu2+BRxznwhIFUiQ7nhB61/EnaammGEAgAbDtgCAApYG8IABzxAA///bK+A=
Date:   Fri, 28 Jun 2019 21:20:00 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551C422@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F6551B824@ORSMSX116.amr.corp.intel.com>
 <99499d1a-56eb-60b0-596c-6d24e38d4757@tycho.nsa.gov>
In-Reply-To: <99499d1a-56eb-60b0-596c-6d24e38d4757@tycho.nsa.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTgzNDU3NWYtMTkzNi00YTQ4LTk3NTgtNjhhOWU5ZTgxYzZhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZkVHUlM4ZGhZWVhcLzYxbWV6VDE2SzVIbVVrTUY3dXhDSmZCUmQxcWtCUjlZcDZYYzBNRkZPdWxvTHFTdzhkWlwvIn0=
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
Cj4gU2VudDogRnJpZGF5LCBKdW5lIDI4LCAyMDE5IDk6MTcgQU0NCj4gDQo+IEZXSVcsIGFkZGlu
ZyBuZXcgcGVybWlzc2lvbnMgb25seSByZXF1aXJlcyB1cGRhdGluZyBwb2xpY3kgY29uZmlndXJh
dGlvbiwNCj4gbm90IHVzZXJzcGFjZSBjb2RlL3Rvb2xzLiAgQnV0IGluIGFueSBldmVudCwgd2Ug
Y2FuIHJldXNlIHRoZSBleGVjdXRlLQ0KPiByZWxhdGVkIHBlcm1pc3Npb25zIGlmIGl0IG1ha2Vz
IHNlbnNlIGJ1dCBzdGlsbCBjb25zaWRlciBpbnRyb2R1Y2luZw0KPiBhZGRpdGlvbmFsLCBuZXcg
cGVybWlzc2lvbnMsIHBvc3NpYmx5IGluIGEgc2VwYXJhdGUgImVuY2xhdmUiIHNlY3VyaXR5DQo+
IGNsYXNzLCBpZiB3ZSB3YW50IGV4cGxpY2l0IGNvbnRyb2wgb3ZlciBlbmNsYXZlIGxvYWRpbmcs
IGUuZy4NCj4gRU5DTEFWRV9fTE9BRCwgRU5DTEFWRV9fSU5JVCwgZXRjLg0KDQpJJ20gbm90IHNv
IGZhbWlsaWFyIHdpdGggU0VMaW51eCB0b29scyBzbyBteSBhcG9sb2d5IGluIGFkdmFuY2UgaWYg
SSBlbmQgdXAgbWl4aW5nIHVwIHRoaW5ncy4NCg0KSSdtIG5vdCBvbmx5IHRhbGtpbmcgYWJvdXQg
dGhlIG5ldyBwZXJtaXNzaW9ucywgYnV0IGFsc28gaG93IHRvIGFwcGx5IHRoZW0gdG8gZW5jbGF2
ZSBmaWxlcy4gSW50ZWwgU0dYIFNESyBwYWNrYWdlcyBlbmNsYXZlcyBhcyAuc28gZmlsZXMsIGFu
ZCBJIGd1ZXNzIHRoYXQncyB0aGUgbW9zdCBzdHJhaWdodCBmb3J3YXJkIHdheSB0aGF0IG1vc3Qg
b3RoZXJzIHdvdWxkIGRvLiBTbyBpZiBkaWZmZXJlbnQgcGVybWlzc2lvbnMgYXJlIGRlZmluZWQs
IHRoZW4gdXNlciBtb2RlIHRvb2xzIHdvdWxkIGhhdmUgdG8gZGlzdGluZ3Vpc2ggZW5jbGF2ZXMg
ZnJvbSByZWd1bGFyIC5zbyBmaWxlcyBpbiBvcmRlciB0byBncmFudCB0aGVtIGRpZmZlcmVudCBw
ZXJtaXNzaW9ucy4gV291bGQgdGhhdCBiZSBzb21ldGhpbmcgZXh0cmEgdG8gZXhpc3RpbmcgdG9v
bHM/IA0KDQo+IA0KPiBPbmUgcmVzaWR1YWwgY29uY2VybiBJIGhhdmUgd2l0aCB0aGUgcmV1c2Ug
b2YgRklMRV9fRVhFQ1VURSBpcyB1c2luZyBpdA0KPiBmb3IgdGhlIHNpZ3N0cnVjdCBmaWxlIGFz
IHRoZSBmYWxsYmFjayBjYXNlLiAgSWYgdGhlIHNpZ3N0cnVjdCBpcyBhbHdheXMNCj4gcGFydCBv
ZiB0aGUgc2FtZSBmaWxlIGFzIHRoZSBjb2RlLCB0aGVuIGl0IHByb2JhYmx5IGRvZXNuJ3QgbWF0
dGVyLiAgQnV0DQo+IG90aGVyd2lzZSwgaXQgaXMgc29tZXdoYXQgb2RkIHRvIGhhdmUgdG8gYWxs
b3cgdGhlIGhvc3QgcHJvY2VzcyB0bw0KPiBleGVjdXRlIGZyb20gdGhlIHNpZ3N0cnVjdCBmaWxl
IGlmIGl0IGlzIG9ubHkgZGF0YSAodGhlIHNpZ25hdHVyZSkuDQoNCkkgYWdyZWUgd2l0aCB5b3Uu
IEJ1dCBkbyB5b3UgdGhpbmsgaXQgYSBwcmFjdGljYWwgcHJvYmxlbSB0b2RheT8gQXMgZmFyIGFz
IEkga25vdywgbm8gb25lIGlzIGRlcGxveWluZyBzaWdzdHJ1Y3RzIGluIGRlZGljYXRlZCBmaWxl
cy4gSSdtIGp1c3QgdHJ5aW5nIHRvIHRvdWNoIGFzIGZldyB0aGluZ3MgYXMgcG9zc2libGUgdW50
aWwgdGhlcmUncyBkZWZpbml0ZWx5IGEgbmVlZCB0byBkbyBzby4NCg0K
