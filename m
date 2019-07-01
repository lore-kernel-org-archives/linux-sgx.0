Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81627C06511
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 17:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 625592173E
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 17:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfGARL3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 13:11:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:45475 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfGARL2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 13:11:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 10:11:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="246980133"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga001.jf.intel.com with ESMTP; 01 Jul 2019 10:11:28 -0700
Received: from orsmsx162.amr.corp.intel.com (10.22.240.85) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 10:11:27 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX162.amr.corp.intel.com ([169.254.3.80]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 10:11:27 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Topic: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
Thread-Index: AQHVLG/L9SgvyZq9qEim/LcvveBd6KazxkIAgAI8SeA=
Date:   Mon, 1 Jul 2019 17:11:26 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D4B3@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <cover.1561588012.git.cedric.xing@intel.com>
 <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
 <CALCETrWQUEEwAAdPrVQMengKDhX3-fVrtJwaP2i=mWD+s+B8vg@mail.gmail.com>
In-Reply-To: <CALCETrWQUEEwAAdPrVQMengKDhX3-fVrtJwaP2i=mWD+s+B8vg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODcxYTQwMzEtN2I2NS00ZTQyLWIzOTQtNTdlZTllY2JlNTMzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoic3hCMHJhWWY0XC8rUEFVTGJ3MnlKbkJJZXVcL250QWwrTlAzcExMbXRBWUJlMHpGRnpqZUxkWFRMUm1QU0I1Mkh1In0=
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

SGkgQW5keSwNCg0KPiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5v
cmddDQo+IFNlbnQ6IFNhdHVyZGF5LCBKdW5lIDI5LCAyMDE5IDQ6NDcgUE0NCj4gDQo+IEp1c3Qg
b24gYSB2ZXJ5IGN1cnNvcnkgcmV2aWV3LCB0aGlzIHNlZW1zIGxpa2UgaXQncyBjcmVhdGluZyBh
IGJ1bmNoIG9mDQo+IGNvbXBsZXhpdHkgKGEgd2hvbGUgbmV3IGxpYnJhcnkgYW5kIGRhdGEgc3Ry
dWN0dXJlKSwgYW5kIEknbSBub3QNCj4gY29udmluY2VkIHRoZSByZXN1bHQgaXMgYW55IGJldHRl
ciB0aGFuIFNlYW4ncyB2ZXJzaW9uLg0KDQpUaGUgbmV3IEVNQSBkYXRhIHN0cnVjdHVyZSBpcyB0
byB0cmFjayBlbmNsYXZlIHBhZ2VzIGJ5IHJhbmdlLiBZZXMsIFNlYW4gYXZvaWRlZCB0aGF0IGJ5
IHN0b3Jpbmcgc2ltaWxhciBpbmZvcm1hdGlvbiBpbiB0aGUgZXhpc3RpbmcgZW5jbF9wYWdlIHN0
cnVjdHVyZSBpbnNpZGUgU0dYIHN1YnN5c3RlbS4gQnV0IGFzIEkgcG9pbnRlZCBvdXQsIGhpcyBj
b2RlIGhhcyB0byBpdGVyYXRlIHRocm91Z2ggKmV2ZXJ5KiBwYWdlIGluIHJhbmdlIHNvIG1wcm90
ZWN0KCkgd2lsbCBiZSB2ZXJ5IHNsb3cgaWYgdGhlIHJhbmdlIGlzIGxhcmdlLiBTbyBoZSB3b3Vs
ZCBlbmQgdXAgaW50cm9kdWNpbmcgc29tZXRoaW5nIHNpbWlsYXIgdG8gYWNoaWV2ZSB0aGUgc2Ft
ZSBwZXJmb3JtYW5jZS4gDQoNCkFuZCB0aGF0J3Mgbm90IHRoZSBtb3N0IGltcG9ydGFudCBwb2lu
dC4gVGhlIG1ham9yIHByb2JsZW0gaW4gaGlzIHBhdGNoIGxpZXMgaW4gU0dYMiBzdXBwb3J0LCBh
cyAjUEYgZHJpdmVuIEVBVUcgY2Fubm90IGJlIHN1cHBvcnRlZCAob3IgaGUnZCBoYXZlIHRvIGFt
ZW5kIGhpcyBjb2RlIGFjY29yZGluZ2x5LCB3aGljaCB3aWxsIGFkZCBjb21wbGV4aXR5IGFuZCB0
aXAgeW91ciBzY2FsZSkuIA0KDQpPdGhlciB3ZWlyZCB0aGluZ3MsIHN1Y2ggYXMgbW1hcCgpJ2lu
ZyBwYWdlIGJ5IHBhZ2UgdnMuIG1tYXAoKSdpbmcgdGhlIHdob2xlIHJhbmdlIHdpbGwgaW1wYWN0
IHN1YnNlcXVlbnQgbXByb3RlY3QoKSdzIGFzIHlvdSBoYXZlIG5vdGljZWQsIGRvbid0IGV4aXN0
IGluIG15IHNlcmllcy4NCg==
