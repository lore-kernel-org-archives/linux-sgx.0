Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADBBC43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 20:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27D8C21874
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 20:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfCTUK5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 16:10:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:54475 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbfCTUK4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 16:10:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 13:10:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="330431675"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga005.fm.intel.com with ESMTP; 20 Mar 2019 13:10:54 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX109.amr.corp.intel.com ([169.254.11.11]) with mapi id 14.03.0415.000;
 Wed, 20 Mar 2019 13:10:54 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Haitao Huang" <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Topic: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fwgAB+UAD//5xBQA==
Date:   Wed, 20 Mar 2019 20:10:53 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E85C567@ORSMSX116.amr.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <c7da5f00-f266-48a7-2149-49d7c8ba44a5@fortanix.com>
In-Reply-To: <c7da5f00-f266-48a7-2149-49d7c8ba44a5@fortanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2E4OTNhZDQtZWI2ZS00MDRmLTliMmUtYjU2Mjk4ZmE1YzMzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidW1sdnlmTnpLK3BEeHdIN2FncE4xdURXSVd5STA1U3h6TjFlMlFpd1lnbENoQTB1U2MrMjRCSUdzVlg3a1RBQiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiA+IEJ5IHJlcXVpcmluZyBwcmVzZXJ2YXRpb24gb2YgUlNQIGF0IGJvdGggQUVYIGFuZCBFRVhJ
VCwgdGhpcyBwcmVjbHVkZXMNCj4gdGhlIHBvc3NpYmlsaXR5IG9mIHVzaW5nIHRoZSB1bnRydXN0
ZWQgc3RhY2sgYXMgdGVtcG9yYXJ5IHN0b3JhZ2UgYnkNCj4gZW5jbGF2ZXMuIFdoaWxlIHRoYXQg
bG9va3MgcmVhc29uYWJsZSBhdCBmaXJzdCBnbGFuY2UsIEknbSBhZnJhaWQgaXQNCj4gaXNuJ3Qg
dGhlIGNhc2UgaW4gcmVhbGl0eS4gVGhlIHVudHJ1c3RlZCBzdGFjayBpcyBpbmFyZ3VhYmx5IHRo
ZSBtb3N0DQo+IGNvbnZlbmllbnQgd2F5IGZvciBkYXRhIGV4Y2hhbmdlIGJldHdlZW4gYW4gZW5j
bGF2ZSBhbmQgaXRzIGVuY2xvc2luZw0KPiBwcm9jZXNzLCBhbmQgaXMgaW4gZmFjdCBiZWluZyB1
c2VkIGZvciB0aGF0IHB1cnBvc2UgYnkgYWxtb3N0IGFsbA0KPiBleGlzdGluZyBlbmNsYXZlcyB0
byBkYXRlLiBHaXZlbiB0aGUgZXhwZWN0YXRpb24gdGhhdCB0aGlzIEFQSSB3aWxsIGJlDQo+IHVz
ZWQgYnkgYWxsIGZ1dHVyZSBTR1ggYXBwbGljYXRpb24sIGl0IGxvb2tzIHVud2lzZSB0byBiYW4g
dGhlIG1vc3QNCj4gY29udmVuaWVudCBhbmQgY29tbW9ubHkgdXNlZCBhcHByb2FjaCBmb3IgZGF0
YSBleGNoYW5nZS4NCj4gDQo+IEZvciByZWZlcmVuY2UsIGhlcmUncyB0aGUgY29kZSBpbiB0aGUg
SW50ZWwgdG9vbGNoYWluIHJlc3BvbnNpYmxlIGZvcg0KPiB0aGlzOg0KPiBodHRwczovL2dpdGh1
Yi5jb20vaW50ZWwvbGludXgtDQo+IHNneC9ibG9iLzZhMGI1YWM3MWY4ZDE2ZjA0ZTAzNzZmM2Iy
MTY4ZTgwYzc3M2RkMjMvc2RrL3RydHMvdHJ0cy5jcHAjTDEyNQ0KPiAtTDE0MA0KPiANCj4gUmVn
YXJkaW5nICJhbG1vc3QgYWxsIGV4aXN0aW5nIGVuY2xhdmVzIHRvIGRhdGUiLCBlbmNsYXZlcyBi
dWlsdCB3aXRoDQo+IHRoZSBGb3J0YW5peCB0b29sY2hhaW4gZG9uJ3QgdG91Y2ggdGhlIHVudHJ1
c3RlZCBzdGFjay4NCj4gDQo+IC0tDQo+IEpldGhybyBCZWVrbWFuIHwgRm9ydGFuaXgNCg0KVGhh
bmtzIGZvciBwcm92aWRpbmcgdGhlIHJlZmVyZW5jZXMuIFllcywgbm90IGV2ZXJ5IGVuY2xhdmUg
dG91Y2hlcyB0aGUgdW50cnVzdGVkIHN0YWNrIHNvIEkgdXNlZCB0aGUgd29yZCAiYWxtb3N0Ii4N
Cg0KRXZlcnl0aGluZyBleGlzdHMgZm9yIGEgcmVhc29uLiBCeSBicmluZ2luZyB1cCB3aGF0IGlz
IGRvbmUgdG9kYXksIEkgd2FzIHRyeWluZyB0byBpbnNwaXJlIHRoaW5raW5nIG9uIHRoZSBtb3Jl
IGltcG9ydGFudCBxdWVzdGlvbiBvZiAid2h5IGlzIGl0IGRvbmUgdGhpcyB3YXkgdG9kYXk/Ii4N
Cg==
