Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B568FC48BE4
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 19:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9756E208CB
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 19:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfF0TUc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 15:20:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:18329 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbfF0TUc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jun 2019 15:20:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 12:20:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,424,1557212400"; 
   d="scan'208";a="164433176"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga007.fm.intel.com with ESMTP; 27 Jun 2019 12:20:31 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Jun 2019 12:20:31 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.185]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 12:20:30 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Schaufler, Casey" <casey.schaufler@intel.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: RE: LSM module for SGX?
Thread-Topic: LSM module for SGX?
Thread-Index: AQHVLOfAlMZevLzsF0K4M8+HVOF2Bqav96sA///olwA=
Date:   Thu, 27 Jun 2019 19:20:30 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551B732@ORSMSX116.amr.corp.intel.com>
References: <320da9183c7e9ae2c63982d5e124054a615c4b99.camel@linux.intel.com>
 <496ea018-2655-a438-bc6b-80330c36cd11@tycho.nsa.gov>
In-Reply-To: <496ea018-2655-a438-bc6b-80330c36cd11@tycho.nsa.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODY1MWJkYzMtNDlmOS00NTAyLWI2ZjgtMzI3MzhlZTEzZmQ3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibExSOU9TRkpPZk96XC9WWUpwdElWWFdMUmpZQW5SRWpKNUxrME9YZmFDbDViVE02VUp1dmRUVElTenhYMUlvNFgifQ==
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
Cj4gU2VudDogVGh1cnNkYXksIEp1bmUgMjcsIDIwMTkgNjo0MiBBTQ0KPiANCj4gT24gNi8yNy8x
OSA4OjU2IEFNLCBKYXJra28gU2Fra2luZW4gd3JvdGU6DQo+ID4gTG9va2luZyBhdCB0aGUgU0dY
LUxTTSBkaXNjdXNzaW9ucyBJIGhhdmVuJ3Qgc2VlbiBldmVuIGEgc2luZ2xlIGVtYWlsDQo+ID4g
dGhhdCB3b3VsZCBoYXZlIGFueSBjb25jbHVzaW9ucyB0aGF0IHRoZSBuZXcgaG9va3MgYXJlIHRo
ZSBvbmx5DQo+IHBvc3NpYmxlDQo+ID4gcm91dGUgdG8gbGltaXQgdGhlIHByaXZpbGVnZXMgdG8g
dXNlIFNHWC4NCj4gPg0KPiA+IEFuIG9idmlvdXMgYWx0ZXJuYXRpdmUgdG8gY29uc2lkZXIgbWln
aHQgYmUgdG8gaGF2ZSBhIHNtYWxsLXNjYWxlIExTTQ0KPiA+IHRoYXQgeW91IGNvdWxkIHN0YWNr
LiBBRkFJSyBDYXNleSdzIExTTSBzdGFja2luZyBwYXRjaCBzZXQgaGFzIG5vdCB5ZXQNCj4gPiBs
YW5kZWQgYnV0IEkgYWxzbyByZW1lbWJlciB0aGF0IHdpdGggc29tZSBjb25zdHJhaW50cyB5b3Ug
Y2FuIHN0aWxsIGRvDQo+ID4gaXQuIENhc2V5IGV4cGxhaW5lZCB0aGVzZSBjb25zdHJhaW50cyB0
byBtZSBmZXcgeWVhcnMgYWdvIGJ1dCBJIGNhbid0DQo+ID4gcmVjYWxsIHRoZW0gYW55bW9yZSA6
LSkNCj4gPg0KPiA+IE9uZSBleGFtcGxlIG9mIHRoaXMgaXMgWWFtYSwgd2hpY2ggbGltaXRzIHRo
ZSB1c2Ugb2YgcHRyYWNlKCkuIFlvdSBjYW4NCj4gPiBlbmFibGUgaXQgdG9nZXRoZXIgd2l0aCBh
bnkgb2YgdGhlICJiaWciIExTTXMgaW4gdGhlIGtlcm5lbC4NCj4gPg0KPiA+IEEgbWFqb3IgYmVu
ZWZpdCBpbiB0aGlzIGFwcHJvYWNoIHdvdWxkIHRoYXQgaXQgaXMgbm9uLWludHJ1c2l2ZSB3aGVu
DQo+IGl0DQo+ID4gY29tZXMgdG8gb3RoZXIgYXJjaGl0ZWN0dXJlcyB0aGFuIHg4Ni4gTmV3IGhv
b2tzIGFyZSBub3Qgb25seQ0KPiA+IG1haW50ZW5hbmNlIGJ1cmRlbiBmb3IgdGhvc2Ugd2hvIGNh
cmUgYWJvdXQgU0dYIGJ1dCBhbHNvIGZvciB0aG9zZSB3aG8NCj4gPiBoYXZlIHRvIGRlYWwgd2l0
aCBMU01zLg0KPiANCj4gUmVnYXJkbGVzcyBvZiB3aGV0aGVyIG9yIG5vdCB5b3Ugb3IgYW55b25l
IGVsc2UgY3JlYXRlcyBzdWNoIGENCj4gc21hbGwtc2NhbGUgTFNNLCB3ZSB3b3VsZCBzdGlsbCB3
YW50IHRvIGJlIGFibGUgdG8gY29udHJvbCB0aGUgbG9hZGluZw0KPiBvZiBlbmNsYXZlcyBhbmQg
dGhlIGNyZWF0aW9uIG9mIGV4ZWN1dGFibGUgZW5jbGF2ZSBtYXBwaW5ncyB2aWEgU0VMaW51eA0K
PiBwb2xpY3ksIHNvIHRoZSBob29rcyB3b3VsZCBiZSBuZWNlc3NhcnkgYW55d2F5Lg0KDQpKdXN0
IHdhbnQgdG8gYWRkIHRoYXQsIG5vIG1hdHRlciBpdCBpcyBpbmNvcnBvcmF0ZWQgaW50byBhIGJp
ZyBvciBzZXBhcmF0ZWQgaW50byBhIHNtYWxsIExTTSBtb2R1bGUsIGhvb2tzIGFyZSBhbHdheXMg
bmVjZXNzYXJ5LiBUaGUgZGlmZmVyZW5jZSBpcyBqdXN0IHdoaWNoIExTTSBtb2R1bGUgcmVnaXN0
ZXJzIGZvciB0aG9zZSBob29rcy4NCg==
