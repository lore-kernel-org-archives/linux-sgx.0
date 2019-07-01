Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4B5C5B578
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 20:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3C6120663
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 20:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfGAUDx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 16:03:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:3742 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbfGAUDx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 16:03:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 13:03:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="154196816"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga007.jf.intel.com with ESMTP; 01 Jul 2019 13:03:52 -0700
Received: from orsmsx122.amr.corp.intel.com (10.22.225.227) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 13:03:52 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX122.amr.corp.intel.com ([169.254.11.7]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 13:03:52 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
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
Thread-Index: AQHVJu2+BRxznwhIFUiQ7nhB61/EnaammGEAgAbDtgCABnPCAIACQmXwgACBGYD//5UrQIAAhn0A//+RRzA=
Date:   Mon, 1 Jul 2019 20:03:51 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D77E@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
 <CALCETrWPzSaFUWi4q4Vq_0RrtNMFZAKkwKkya=p6cfB50x2tMQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D558@ORSMSX116.amr.corp.intel.com>
 <CALCETrXjq9JNjXZo3Va83Ca7fiAJx7ZM9VRWYebzpyH6ug0cKg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D63B@ORSMSX116.amr.corp.intel.com>
 <CALCETrU=Btr+o9jb-zbj2kw8571WGhuhA6ZdttxQ_5_3pzZwUw@mail.gmail.com>
In-Reply-To: <CALCETrU=Btr+o9jb-zbj2kw8571WGhuhA6ZdttxQ_5_3pzZwUw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTA4OWRjZDEtNWI2ZC00YWE0LTg4N2ItYmM0ZDRiYzgyODkyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWncxNVdvK1FOUk5DcE9pM2tRK2FhVTBrUUJjUEtBVDJCQkxQZEdWRXpDc2FKUVdsQWRVc0hxN0hwc1VHbzFvUCJ9
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
IE1vbmRheSwgSnVseSAwMSwgMjAxOSAxMjozMyBQTQ0KPiANCj4gSXQgZG9lcyBtYWtlIHNlbnNl
LCBidXQgSSdtIG5vdCBzdXJlIGl0J3MgY29ycmVjdCB0byBhc3N1bWUgdGhhdCBhbnkgTFNNDQo+
IHBvbGljeSB3aWxsIGFsd2F5cyBhbGxvdyBleGVjdXRpb24gb24gZW5jbGF2ZSBzb3VyY2UgcGFn
ZXMgaWYgaXQgd291bGQNCj4gYWxsb3cgZXhlY3V0aW9uIGluc2lkZSB0aGUgZW5jbGF2ZS4gIEFz
IGFuIGV4YW1wbGUsIGhlcmUgaXMgYSBwb2xpY3kNCj4gdGhhdCBzZWVtcyByZWFzb25hYmxlOg0K
PiANCj4gVGFzayBBIGNhbm5vdCBleGVjdXRlIGR5bmFtaWMgbm9uLWVuY2xhdmUgY29kZSAobm8g
ZXhlY21vZCwgbm8gZXhlY21lbSwNCj4gZXRjIC0tIG9ubHkgYXBwcm92ZWQgdW5tb2RpZmllZCBm
aWxlIHBhZ2VzIGNhbiBiZSBleGVjdXRlZCkuDQo+IEJ1dCB0YXNrIEEgY2FuIGV4ZWN1dGUgYW4g
ZW5jbGF2ZSB3aXRoIE1SRU5DTEFWRSA9PSBzdWNoLWFuZC1zdWNoLCBhbmQNCj4gdGhhdCBlbmNs
YXZlIG1heSBiZSBsb2FkZWQgZnJvbSByZWd1bGFyIGFub255bW91cyBtZW1vcnkgLS0gdGhlDQo+
IE1SRU5DTEFWRSBpcyBjb25zaWRlcmVkIGVub3VnaCB2ZXJpZmljYXRpb24uDQoNCllvdSBhcmUg
cmlnaHQuIFRoYXQncyBhIHJlYXNvbmFibGUgcG9saWN5LiBCdXQgSSBzdGlsbCBjYW4ndCBzZWUg
dGhlIG5lZWQgZm9yIFNHWF9FWEVDVU5NUiwgYXMgTVJFTkNMQVZFIGlzIGNvbnNpZGVyZWQgZW5v
dWdoIHZlcmlmaWNhdGlvbi4NCg==
