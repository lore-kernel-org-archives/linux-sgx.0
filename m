Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A957C06511
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 19:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64C8221721
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 19:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfGATDz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 15:03:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:17087 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfGATDy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 15:03:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 12:03:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="163773878"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jul 2019 12:03:53 -0700
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 12:03:53 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.149]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 12:03:53 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
CC:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Thread-Topic: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Thread-Index: AQHVJu2+BRxznwhIFUiQ7nhB61/EnaammGEAgAbDtgCABnPCAIACQmXwgACBGYD//5UrQIAABrlw
Date:   Mon, 1 Jul 2019 19:03:52 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D654@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
 <CALCETrWPzSaFUWi4q4Vq_0RrtNMFZAKkwKkya=p6cfB50x2tMQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D558@ORSMSX116.amr.corp.intel.com>
 <CALCETrXjq9JNjXZo3Va83Ca7fiAJx7ZM9VRWYebzpyH6ug0cKg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D63B@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551D63B@ORSMSX116.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZGZkYzM3Y2YtZDcxYi00OGNiLWI4NWQtNjE1MWQzYmEyNzRiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVTUrWDJnT0hwdE5WbEVxTUtrU2Q2UDhpQWtsM3VySFZoTlVQalZZK2paVDRDdlBxYXZIMmJsTHdEdGhBbHowRiJ9
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

SGkgQW5keSwNCg0KPiBGcm9tOiBsaW51eC1zZ3gtb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWls
dG86bGludXgtc2d4LQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBYaW5n
LCBDZWRyaWMNCj4gU2VudDogTW9uZGF5LCBKdWx5IDAxLCAyMDE5IDExOjU0IEFNDQo+ID4gPg0K
PiA+ID4gVGhhdCBzYWlkLCBldmVyeSBleGVjdXRhYmxlIGVuY2xhdmUgcGFnZSBzaG91bGQgaGF2
ZSBhbiBleGVjdXRhYmxlDQo+ID4gPiBzb3VyY2UgcGFnZSAoZG9lc27igJl0IGhhdmUgdG8gZXhl
Y3V0YWJsZSwgYXMgbG9uZyBhcyBtcHJvdGVjdChYKQ0KPiB3b3VsZA0KPiA+ID4gc3VjY2VlZCBv
biBpdCwgYXMgc2hvd24gaW4gbXkgcGF0Y2gpDQo+ID4NCj4gPiBEb2VzIFNlYW4ncyBzZXJpZXMg
cmVxdWlyZSB0aGlzPyAgSSB0aGluayB0aGF0LCBpZiB3ZSBjYW4gZ2V0IGF3YXkNCj4gd2l0aA0K
PiA+IGl0LCBpdCdzIGEgbG90IG5pY2VyIHRvICpub3QqIHJlcXVpcmUgdXNlciBjb2RlIHRvIG1h
cCB0aGUgc291cmNlDQo+IHBhZ2VzDQo+ID4gUFJPVF9FWEVDLiAgU29tZSBwb2xpY3kgbWF5IGNo
ZWNrIHRoYXQgaXQncyBWTV9NQVlFWEVDIG9yIGNoZWNrIHNvbWUNCj4gPiBvdGhlciBhdHRyaWJ1
dGUgb2YgdGhlIFZNQSwgYnV0IGFjdHVhbGx5IHJlcXVpcmluZyBQUk9UX0VYRUMgc2VlbXMNCj4g
bGlrZQ0KPiA+IHdlJ3JlIHdlYWtlbmluZyBleGlzdGluZyBoYXJkZW5pbmcgbWVhc3VyZXMgdG8g
ZW5mb3JjZSBhIHBvbGljeSwgd2hpY2gNCj4gPiBpcyBhIG1pc3Rha2UuDQo+IA0KPiBNeSBwYXRj
aCBkb2Vzbid0IHJlcXVpcmUgWCBvbiBzb3VyY2UgcGFnZXMgZWl0aGVyLiBJIHNhaWQgIndvdWxk
IiwNCj4gbWVhbmluZyBYICp3b3VsZCogYmUgZ3JhbnRlZCBidXQgZG9lc24ndCBoYXZlIHRvIGJl
IGdyYW50ZWQuIFlvdSBjYW4gc2VlDQo+IHRoaXMgaW4gc2VsaW51eF9lbmNsYXZlX2xvYWQoKSBj
YWxsaW5nIHNlbGludXhfZmlsZV9tcHJvdGVjdCgpIGluIG15DQo+IGNvZGUuIFRoZSBwdXJwb3Nl
IGlzIHRvIGRldGVybWluZSBpZiBYICp3b3VsZCogYmUgZ3JhbnRlZCB0byB0aGUgc291cmNlDQo+
IHBhZ2VzIHdpdGhvdXQgYWN0dWFsbHkgZ3JhbnRpbmcgWC4NCg0KRm9yZ290IHRvIGNvbmNsdWRl
IHRoYXQgd2UgYXJlIG9uIHRoZSBzYW1lIHBhZ2UgZm9yIHRoZSByZXF1aXJlbWVudCBvbiB0aGUg
c291cmNlIHBhZ2VzLg0KDQpBbmQgZ2l2ZW4gdGhhdCByZXF1aXJlbWVudCAoZW5jbGF2ZSBwYWdl
IGNhbm5vdCBiZSBYIHVubGVzcyBzb3VyY2Ugd291bGQgYWxzbyBiZSBhbGxvd2VkIFgpLCBtZWFz
dXJpbmcgZW5jbGF2ZSBjb2RlIHBhZ2VzIG9yIG5vdCBkb2Vzbid0IG1ha2UgYW55IGRpZmZlcmVu
Y2UgZnJvbSB0aGUgZW5jbG9zaW5nIHByb2Nlc3MncyBwZXJzcGVjdGl2ZSBpbiB0ZXJtcyBvZiBz
ZWN1cml0eS4gU28gaXQgb25seSBtYWtlcyBhIGRpZmZlcmVuY2UgZm9yIHRoZSBlbmNsYXZlLCB3
aGljaCBob3dldmVyIGhhcyBiZWVuIGNvdmVyZWQgY3J5cHRvZ3JhcGhpY2FsbHkgYnkgaXRzIG1l
YXN1cmVtZW50IGFscmVhZHkuIFNvIFNHWF9FWEVDVU5NUiBkb2Vzbid0IGhhdmUgYW55IHByYWN0
aWNhbCB1c2UsIHRodXMgSSBkb24ndCB0aGluayBpdCBzaG91bGQgYmUgYWRkZWQgYXMgYSBuZXcg
cGVybWlzc2lvbi4NCg==
