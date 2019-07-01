Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A96C0650E
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 17:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBD07206A3
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 17:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbfGARqH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 13:46:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:57675 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbfGARqG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 13:46:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 10:46:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="338685737"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2019 10:46:05 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 10:46:05 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX161.amr.corp.intel.com ([169.254.4.81]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 10:46:05 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
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
Thread-Index: AQHVJu2+BRxznwhIFUiQ7nhB61/EnaammGEAgAbDtgCABnPCAIACQmXw
Date:   Mon, 1 Jul 2019 17:46:04 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D558@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
 <CALCETrWPzSaFUWi4q4Vq_0RrtNMFZAKkwKkya=p6cfB50x2tMQ@mail.gmail.com>
In-Reply-To: <CALCETrWPzSaFUWi4q4Vq_0RrtNMFZAKkwKkya=p6cfB50x2tMQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDQ1ODMzYjctYmU0ZS00ZmQ1LThmOTYtNjg2Nzg2MGQ5MDJiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiV28yeDVCR29nRnhlK3ROR1dDUHBqcVh6ZGZJODArcUoyaitUOE9TRkxNYUFnMW1mcGZkN1F6ZUQ5SmdHdWl4NSJ9
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
IFNhdHVyZGF5LCBKdW5lIDI5LCAyMDE5IDQ6NDIgUE0NCj4gDQo+IE9uIFR1ZSwgSnVuIDI1LCAy
MDE5IGF0IDI6MDkgUE0gU3RlcGhlbiBTbWFsbGV5IDxzZHNAdHljaG8ubnNhLmdvdj4NCj4gd3Jv
dGU6DQo+ID4NCj4gPiBPbiA2LzIxLzE5IDU6MjIgUE0sIFhpbmcsIENlZHJpYyB3cm90ZToNCj4g
PiA+PiBGcm9tOiBDaHJpc3RvcGhlcnNvbiwgU2VhbiBKDQo+ID4gPj4gU2VudDogV2VkbmVzZGF5
LCBKdW5lIDE5LCAyMDE5IDM6MjQgUE0NCj4gPiA+Pg0KPiA+ID4+IEludGVuZGVkIHVzZSBvZiBl
YWNoIHBlcm1pc3Npb246DQo+ID4gPj4NCj4gPiA+PiAgICAtIFNHWF9FWEVDRElSVFk6IGR5bmFt
aWNhbGx5IGxvYWQgY29kZSB3aXRoaW4gdGhlIGVuY2xhdmUgaXRzZWxmDQo+ID4gPj4gICAgLSBT
R1hfRVhFQ1VOTVI6IGxvYWQgdW5tZWFzdXJlZCBjb2RlIGludG8gdGhlIGVuY2xhdmUsIGUuZy4N
Cj4gPiA+PiBHcmFwaGVuZQ0KPiA+ID4NCj4gPiA+IFdoeSBkb2VzIGl0IG1hdHRlciB3aGV0aGVy
IGEgY29kZSBwYWdlIGlzIG1lYXN1cmVkIG9yIG5vdD8NCj4gPg0KPiA+IEl0IHdvbid0IGJlIGlu
Y29ycG9yYXRlZCBpbnRvIGFuIGF0dGVzdGF0aW9uPw0KPiA+DQo+IA0KPiBBbHNvLCBpZiB0aGVy
ZSBpcywgaW4gcGFyYWxsZWwsIGEgcG9saWN5IHRoYXQgbGltaXRzIHRoZSBzZXQgb2YgZW5jbGF2
ZQ0KPiBTSUdTVFJVQ1RzIHRoYXQgYXJlIGFjY2VwdGVkLCByZXF1aXJpbmcgYWxsIGNvZGUgYmUg
bWVhc3VyZWQgbWFrZXMgaXQNCj4gaGFyZGVyIHRvIHN1YnZlcnQgYnkgd3JpdGluZyBpbmNvbXBl
dGVudCBvciBtYWxpY2lvdXNseSBpbmNvbXBldGVudA0KPiBlbmNsYXZlcy4NCg0KQXMgYW5hbHl6
ZWQgaW4gbXkgcmVwbHkgdG8gb25lIG9mIFN0ZXBoZW4ncyBjb21tZW50cywgbm8gZXhlY3V0YWJs
ZSBwYWdlIHNoYWxsIGJlICJlbmNsYXZlIG9ubHkiIGFzIGVuY2xhdmVzIGhhdmUgYWNjZXNzIHRv
IGhvc3QncyBtZW1vcnksIHNvIGlmIGFuIGV4ZWN1dGFibGUgcGFnZSBpbiByZWd1bGFyIG1lbW9y
eSBpcyBjb25zaWRlcmVkIHBvc3RpbmcgYSB0aHJlYXQgdG8gdGhlIHByb2Nlc3MsIGl0IHNob3Vs
ZCBiZSBjb25zaWRlcmVkIHBvc3RpbmcgdGhlIHNhbWUgdGhyZWF0IGluc2lkZSBhbiBlbmNsYXZl
IGFzIHdlbGwuDQoNClRoYXQgc2FpZCwgZXZlcnkgZXhlY3V0YWJsZSBlbmNsYXZlIHBhZ2Ugc2hv
dWxkIGhhdmUgYW4gZXhlY3V0YWJsZSBzb3VyY2UgcGFnZSAoZG9lc27igJl0IGhhdmUgdG8gZXhl
Y3V0YWJsZSwgYXMgbG9uZyBhcyBtcHJvdGVjdChYKSB3b3VsZCBzdWNjZWVkIG9uIGl0LCBhcyBz
aG93biBpbiBteSBwYXRjaCksIGhlbmNlIGFueSBleHBsb2l0cyBtb3VudGFibGUgb24gdGhlIGVu
Y2xhdmUgcGFnZSBzaGFsbCBhbHNvIGJlIG1vdW50YWJsZSB1c2luZyB0aGUgc291cmNlIHBhZ2Uu
IEdpdmVuIG9ubHkgdGhlIHdlYWtlc3QgbGluayBtYXR0ZXJzIGluIHNlY3VyaXR5LCBJIGFyZ3Vl
IHRoYXQgU0dYX0VYRUNVTk1SIGlzIHVubmVjZXNzYXJ5IGZyb20gdGhlIHByb2Nlc3MncyBwZXJz
cGVjdGl2ZS4NCg0KU0dYX0VYRUNVTk1SIGRvZXMgaW1wYWN0IHNlY3VyaXR5IGZyb20gdGhlIGVu
Y2xhdmUncyBwZXJzcGVjdGl2ZSwgdGh1cyBpdCBpcyByZWZsZWN0ZWQgaW4gZW5jbGF2ZSdzIG1l
YXN1cmVtZW50LCB3aGljaCBpcyBwYXJ0IG9mIFNHWCBJU0EuIEl0J3MgdGhlIGVuY2xhdmUgdmVu
ZG9yJ3MgcmVzcG9uc2liaWxpdHkgdG8gZW5zdXJlIGNvZGUgcGFnZXMgYXJlIHByb3Blcmx5IG1l
YXN1cmVkIGFuZCB0aGF0J3MgbGFyZ2VseSBhdXRvbWF0ZWQgYnkgdG9vbHMuIEl0J3MgaGlnaGx5
IHVubGlrZWx5IGFuIElTViB3b3VsZCAiZm9yZ2V0IiB0byBtZWFzdXJlIGEgcGFnZSBzbyBJIGRv
bid0IHRoaW5rIFNHWF9FWEVDVU5NUiBoYXMgbXVjaCB2YWx1ZSBmb3IgSVNWcy4NCg0KU28gdGhl
IG9ubHkgY2FzZSBsZWZ0IGlzIHRoZSBlbmNsYXZlIGF1dGhvciBsZWZ0IGEgcGFnZSB1bm1lYXN1
cmVkIHdpdGggYSBtYWxpY2lvdXMgaW50ZW50LiBBcyB0aGF0J3MgcGFydCBvZiB0aGUgZW5jbGF2
ZSBtZWFzdXJlbWVudCwgaXQgd291bGQgZ2V0IGNhdWdodCBhdCBFSU5JVCBiZWNhdXNlIG9mIGFu
IHVudHJ1c3RlZC9ibGFja2xpc3RlZCBzaWduaW5nIGtleSwgb3IgaXQgZG9lc24ndCBiZWNhdXNl
IG9mIHRoZSBsYWNrIG9mIHdoaXRlbGlzdGluZy9ibGFja2xpc3RpbmcgbWVjaGFuaXNtLiBCdXQg
aW4gdGhlIGxhdHRlciBjYXNlLCB0aGUgYWR2ZXJzYXJ5IGNvdWxkIGp1c3QgbWVhc3VyZSB0aGUg
bWFsaWNpb3VzIHBhZ2UgYXMgdGhlIGZpbmFsIG1lYXN1cmVtZW50IG9yIHNpZ25pbmcga2V5IGRv
ZXNuJ3QgbWF0dGVyIGFueXdheS4gU2VhbidzIHNlcmllcyBkb2Vzbid0IGhhdmUgYW4gZW5jbGF2
ZV9pbml0KCkgaG9vayBzbyBpdCB3aWxsIGFsd2F5cyBiZSB0aGUgbGF0dGVyIGNhc2UsIHdoZXJl
IHRoZSBmaW5hbCBtZWFzdXJlbWVudCBkb2Vzbid0IG1hdHRlci4gVGhlcmVmb3JlLCBTR1hfRVhF
Q1VOTVIgZG9lc24ndCBoYXZlIGFueSB2YWx1ZSBhcyBhZHZlcnNhcmllcyBjb3VsZCBhbHdheXMg
bWVhc3VyZSBhbGwgY29kZSBwYWdlcyB0byBzYXRpc2Z5IHRoZSBwb2xpY3kgd2l0aG91dCB3b3Jy
eWluZyBhYm91dCBmaW5hbCBtZWFzdXJlbWVudHMuDQo=
