Return-Path: <SRS0=btop=U6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC263C0650E
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 18:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C831620B7C
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jul 2019 18:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfGASyT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jul 2019 14:54:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:16338 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGASyT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jul 2019 14:54:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 11:54:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="scan'208";a="163769908"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jul 2019 11:54:17 -0700
Received: from orsmsx115.amr.corp.intel.com (10.22.240.11) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 1 Jul 2019 11:54:17 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX115.amr.corp.intel.com ([169.254.4.13]) with mapi id 14.03.0439.000;
 Mon, 1 Jul 2019 11:54:17 -0700
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
Thread-Index: AQHVJu2+BRxznwhIFUiQ7nhB61/EnaammGEAgAbDtgCABnPCAIACQmXwgACBGYD//5UrQA==
Date:   Mon, 1 Jul 2019 18:54:16 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551D63B@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
 <CALCETrWPzSaFUWi4q4Vq_0RrtNMFZAKkwKkya=p6cfB50x2tMQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D558@ORSMSX116.amr.corp.intel.com>
 <CALCETrXjq9JNjXZo3Va83Ca7fiAJx7ZM9VRWYebzpyH6ug0cKg@mail.gmail.com>
In-Reply-To: <CALCETrXjq9JNjXZo3Va83Ca7fiAJx7ZM9VRWYebzpyH6ug0cKg@mail.gmail.com>
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

PiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5vcmddDQo+IFNlbnQ6
IE1vbmRheSwgSnVseSAwMSwgMjAxOSAxMDo1NCBBTQ0KPiANCj4gT24gTW9uLCBKdWwgMSwgMjAx
OSBhdCAxMDo0NiBBTSBYaW5nLCBDZWRyaWMgPGNlZHJpYy54aW5nQGludGVsLmNvbT4NCj4gd3Jv
dGU6DQo+ID4NCj4gPiA+IEZyb206IEFuZHkgTHV0b21pcnNraSBbbWFpbHRvOmx1dG9Aa2VybmVs
Lm9yZ10NCj4gPiA+IFNlbnQ6IFNhdHVyZGF5LCBKdW5lIDI5LCAyMDE5IDQ6NDIgUE0NCj4gPiA+
DQo+ID4gPiBPbiBUdWUsIEp1biAyNSwgMjAxOSBhdCAyOjA5IFBNIFN0ZXBoZW4gU21hbGxleSA8
c2RzQHR5Y2hvLm5zYS5nb3Y+DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4gT24gNi8y
MS8xOSA1OjIyIFBNLCBYaW5nLCBDZWRyaWMgd3JvdGU6DQo+ID4gPiA+ID4+IEZyb206IENocmlz
dG9waGVyc29uLCBTZWFuIEoNCj4gPiA+ID4gPj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDE5LCAy
MDE5IDM6MjQgUE0NCj4gPiA+ID4gPj4NCj4gPiA+ID4gPj4gSW50ZW5kZWQgdXNlIG9mIGVhY2gg
cGVybWlzc2lvbjoNCj4gPiA+ID4gPj4NCj4gPiA+ID4gPj4gICAgLSBTR1hfRVhFQ0RJUlRZOiBk
eW5hbWljYWxseSBsb2FkIGNvZGUgd2l0aGluIHRoZSBlbmNsYXZlDQo+IGl0c2VsZg0KPiA+ID4g
PiA+PiAgICAtIFNHWF9FWEVDVU5NUjogbG9hZCB1bm1lYXN1cmVkIGNvZGUgaW50byB0aGUgZW5j
bGF2ZSwgZS5nLg0KPiA+ID4gPiA+PiBHcmFwaGVuZQ0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gV2h5
IGRvZXMgaXQgbWF0dGVyIHdoZXRoZXIgYSBjb2RlIHBhZ2UgaXMgbWVhc3VyZWQgb3Igbm90Pw0K
PiA+ID4gPg0KPiA+ID4gPiBJdCB3b24ndCBiZSBpbmNvcnBvcmF0ZWQgaW50byBhbiBhdHRlc3Rh
dGlvbj8NCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBBbHNvLCBpZiB0aGVyZSBpcywgaW4gcGFyYWxs
ZWwsIGEgcG9saWN5IHRoYXQgbGltaXRzIHRoZSBzZXQgb2YNCj4gPiA+IGVuY2xhdmUgU0lHU1RS
VUNUcyB0aGF0IGFyZSBhY2NlcHRlZCwgcmVxdWlyaW5nIGFsbCBjb2RlIGJlIG1lYXN1cmVkDQo+
ID4gPiBtYWtlcyBpdCBoYXJkZXIgdG8gc3VidmVydCBieSB3cml0aW5nIGluY29tcGV0ZW50IG9y
IG1hbGljaW91c2x5DQo+ID4gPiBpbmNvbXBldGVudCBlbmNsYXZlcy4NCj4gPg0KPiA+IEFzIGFu
YWx5emVkIGluIG15IHJlcGx5IHRvIG9uZSBvZiBTdGVwaGVuJ3MgY29tbWVudHMsIG5vIGV4ZWN1
dGFibGUNCj4gcGFnZSBzaGFsbCBiZSAiZW5jbGF2ZSBvbmx5IiBhcyBlbmNsYXZlcyBoYXZlIGFj
Y2VzcyB0byBob3N0J3MgbWVtb3J5LA0KPiBzbyBpZiBhbiBleGVjdXRhYmxlIHBhZ2UgaW4gcmVn
dWxhciBtZW1vcnkgaXMgY29uc2lkZXJlZCBwb3N0aW5nIGENCj4gdGhyZWF0IHRvIHRoZSBwcm9j
ZXNzLCBpdCBzaG91bGQgYmUgY29uc2lkZXJlZCBwb3N0aW5nIHRoZSBzYW1lIHRocmVhdA0KPiBp
bnNpZGUgYW4gZW5jbGF2ZSBhcyB3ZWxsLg0KDQpXaGF0IEkgd2FzIHRyeWluZyB0byBzYXkgd2Fz
LCBhbiBleGVjdXRhYmxlIHBhZ2UsIGlmIGNvbnNpZGVyZWQgYSB0aHJlYXQgdG8gdGhlIGVuY2xv
c2luZyBwcm9jZXNzLCBzaG91bGQgYWx3YXlzIGJlIGNvbnNpZGVyZWQgYSB0aHJlYXQgbm8gbWF0
dGVyIGl0IGlzIGluIHRoYXQgcHJvY2VzcydzIG1lbW9yeSBvciBpbnNpZGUgYW4gZW5jbGF2ZSBl
bmNsb3NlZCBpbiB0aGF0IHNhbWUgcHJvY2VzcydzIGFkZHJlc3Mgc3BhY2UuDQoNClRoZXJlZm9y
ZSwgZm9yIGEgcGFnZSBpbiByZWd1bGFyIG1lbW9yeSwgaWYgaXQgaXMgZGVuaWVkIGV4ZWN1dGFi
bGUsIGl0IGlzIGJlY2F1c2UgaXQgaXMgY29uc2lkZXJlZCBhIHBvdGVudGlhbCBzZWN1cml0eSB0
aHJlYXQgdG8gdGhlIGVuY2xvc2luZyBwcm9jZXNzLCBzbyBpdCBzaGFsbCBub3QgYmUgdXNlZCBh
cyB0aGUgc291cmNlIGZvciBhbiBleGVjdXRhYmxlIGVuY2xhdmUgcGFnZSwgYXMgdGhlIHNhbWUg
dGhyZWF0IGV4aXN0cyByZWdhcmRsZXNzIGl0IGlzIGluIHJlZ3VsYXIgbWVtb3J5IG9yIEVQQy4g
RG9lcyB0aGF0IG1ha2UgbW9yZSBzZW5zZT8NCg0KPiANCj4gSHVoPyAgVGhlIFNETSAoMzcuMyBp
biB3aGF0ZXZlIHZlcnNpb24gSSdtIHJlYWRpbmcpIHNheXMgIkNvZGUgZmV0Y2hlcw0KPiBmcm9t
IGluc2lkZSBhbiBlbmNsYXZlIHRvIGEgbGluZWFyIGFkZHJlc3Mgb3V0c2lkZSB0aGF0IGVuY2xh
dmUgcmVzdWx0DQo+IGluIGEgI0dQKDApIGV4Y2VwdGlvbi4iICBFbmNsYXZlcyBleGVjdXRlIGVu
Y2xhdmUgY29kZSBvbmx5Lg0KPiANCj4gSW4gYW55IGV2ZW50LCBJIGJlbGlldmUgd2UncmUgZGlz
Y3Vzc2luZyB0YWtpbmcgcmVhZGFibGUgbWVtb3J5IGZyb20NCj4gb3V0c2lkZSB0aGUgZW5jbGF2
ZSBhbmQgY29weWluZyBpdCB0byBhbiBleGVjdXRhYmxlIGNvZGUgaW5zaWRlIHRoZQ0KPiBlbmNs
YXZlLg0KDQpZb3UgYXJlIGNvcnJlY3QuIFNHWCBJU0EgZG9lc24ndCBjYXJlIHRoZSBzb3VyY2Ug
cGFnZSBhcyBpdCBvbmx5IHRha2VzIGNhcmUgb2YgdGhlIHNlY3VyaXR5IHRoZSBlbmNsYXZlIGl0
c2VsZi4gDQoNCkJ1dCBMU00gb24gdGhlIG90aGVyIGhhbmQgYWxzbyB0YWtlcyBjYXJlIG9mIHRo
ZSBlbmNsb3NpbmcgcHJvY2Vzcy4gVGhhdCBzYWlkLCBhIHBhZ2UsIGlmIGRlbmllZCBleGVjdXRh
YmxlIGJlY2F1c2UgaXQgaXMgY29uc2lkZXJlZCBhIHBvdGVudGlhbCB0aHJlYXQgdG8gdGhlIHBy
b2Nlc3MgYnkgTFNNLCBzaG91bGQgYWxzbyBiZSBkZW5pZWQgKGJ5IExTTSkgYXMgdGhlIHNvdXJj
ZSBmb3IgYW4gZXhlY3V0YWJsZSBlbmNsYXZlIHBhZ2UgYmVjYXVzZSB0aGUgc2FtZSB0aHJlYXQg
d291bGQgZXhpc3QgZXZlbiBpZiBpdCByZXNpZGVzIGluc2lkZSBhbiBlbmNsYXZlLCBmb3IgZW5j
bGF2ZXMgaGF2ZSBhY2Nlc3MgdG8gYWxsIG9mIHRoZSBlbmNsb3NpbmcgcHJvY2VzcydzIG1lbW9y
eS4NCg0KPiANCj4gPg0KPiA+IFRoYXQgc2FpZCwgZXZlcnkgZXhlY3V0YWJsZSBlbmNsYXZlIHBh
Z2Ugc2hvdWxkIGhhdmUgYW4gZXhlY3V0YWJsZQ0KPiA+IHNvdXJjZSBwYWdlIChkb2VzbuKAmXQg
aGF2ZSB0byBleGVjdXRhYmxlLCBhcyBsb25nIGFzIG1wcm90ZWN0KFgpIHdvdWxkDQo+ID4gc3Vj
Y2VlZCBvbiBpdCwgYXMgc2hvd24gaW4gbXkgcGF0Y2gpDQo+IA0KPiBEb2VzIFNlYW4ncyBzZXJp
ZXMgcmVxdWlyZSB0aGlzPyAgSSB0aGluayB0aGF0LCBpZiB3ZSBjYW4gZ2V0IGF3YXkgd2l0aA0K
PiBpdCwgaXQncyBhIGxvdCBuaWNlciB0byAqbm90KiByZXF1aXJlIHVzZXIgY29kZSB0byBtYXAg
dGhlIHNvdXJjZSBwYWdlcw0KPiBQUk9UX0VYRUMuICBTb21lIHBvbGljeSBtYXkgY2hlY2sgdGhh
dCBpdCdzIFZNX01BWUVYRUMgb3IgY2hlY2sgc29tZQ0KPiBvdGhlciBhdHRyaWJ1dGUgb2YgdGhl
IFZNQSwgYnV0IGFjdHVhbGx5IHJlcXVpcmluZyBQUk9UX0VYRUMgc2VlbXMgbGlrZQ0KPiB3ZSdy
ZSB3ZWFrZW5pbmcgZXhpc3RpbmcgaGFyZGVuaW5nIG1lYXN1cmVzIHRvIGVuZm9yY2UgYSBwb2xp
Y3ksIHdoaWNoDQo+IGlzIGEgbWlzdGFrZS4NCg0KTXkgcGF0Y2ggZG9lc24ndCByZXF1aXJlIFgg
b24gc291cmNlIHBhZ2VzIGVpdGhlci4gSSBzYWlkICJ3b3VsZCIsIG1lYW5pbmcgWCAqd291bGQq
IGJlIGdyYW50ZWQgYnV0IGRvZXNuJ3QgaGF2ZSB0byBiZSBncmFudGVkLiBZb3UgY2FuIHNlZSB0
aGlzIGluIHNlbGludXhfZW5jbGF2ZV9sb2FkKCkgY2FsbGluZyBzZWxpbnV4X2ZpbGVfbXByb3Rl
Y3QoKSBpbiBteSBjb2RlLiBUaGUgcHVycG9zZSBpcyB0byBkZXRlcm1pbmUgaWYgWCAqd291bGQq
IGJlIGdyYW50ZWQgdG8gdGhlIHNvdXJjZSBwYWdlcyB3aXRob3V0IGFjdHVhbGx5IGdyYW50aW5n
IFguDQo=
