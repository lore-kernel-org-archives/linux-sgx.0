Return-Path: <SRS0=2c9w=T6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C078BC28CC3
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 22:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A261A26267
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 22:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfE3WDh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 May 2019 18:03:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:42231 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbfE3WDh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 May 2019 18:03:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 14:48:45 -0700
X-ExtLoop1: 1
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga004.jf.intel.com with ESMTP; 30 May 2019 14:48:44 -0700
Received: from orsmsx158.amr.corp.intel.com (10.22.240.20) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 30 May 2019 14:48:44 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX158.amr.corp.intel.com ([169.254.10.135]) with mapi id 14.03.0415.000;
 Thu, 30 May 2019 14:48:44 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Stephen Smalley <sds@tycho.nsa.gov>,
        William Roberts <bill.c.roberts@gmail.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: RE: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Topic: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Index: AQHVC0vUmIXibKT8TUm/EUnHn2XAfqZu5q2AgAAGWoCABXOKgIABz2SAgAAI9ACAAWgPAIAAAJWAgAAJhACAAByGAIAAdoKAgABA+ICAAIOmAIAAQKcAgAAWeICAAIbLAIAAGyYA///WAeCAARtHgIAAIeCAgAADbAD//5AmcIAAjJAAgAAHN4CAABd5AIAAFI2AgAARBICAAPo7MIAArTmA///E0eAAlLibAAAlK2+AABHNCZAAIP3eAAAAS7MAAAEoiAAAAm/EAAADvKcAAALHiIAACtLzcA==
Date:   Thu, 30 May 2019 21:48:43 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654EB8BA@ORSMSX116.amr.corp.intel.com>
References: <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
 <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E9824@ORSMSX116.amr.corp.intel.com>
 <20190528202407.GB13158@linux.intel.com>
 <285f279f-b500-27f0-ab42-fb1dbcc5ab18@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F654EB487@ORSMSX116.amr.corp.intel.com>
 <678a37af-797d-7bd5-a406-32548a270e3d@tycho.nsa.gov>
 <CALCETrWXB9fNNDH7gZxPTx05F78Og6K=ZtAr2aA++BDwY09Wbg@mail.gmail.com>
 <c1135352-0b5e-4694-b1a9-105876095877@tycho.nsa.gov>
 <CALCETrWsEXzUC33eJpGCpdMCBO4aYVviZLRD-CLMNaG5Jv-TCA@mail.gmail.com>
 <20190530180110.GB23930@linux.intel.com>
 <CALCETrX2PgUc_jetXHqp85aaS0a0jHB8E7=T1rsW+5vyRgwnUA@mail.gmail.com>
In-Reply-To: <CALCETrX2PgUc_jetXHqp85aaS0a0jHB8E7=T1rsW+5vyRgwnUA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTMwZTgwYzYtZGJkZC00MGQyLWI4NGEtNjBjMjQ1MWJhMTQ5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNDFtTTBzNzA5ektIVUhZMVhZQ0pUWlpPUzlkeGEwR1I0RXVJejNDd25DU1hqUVFaMGM1SVAxbHdcL0U1dmV6V0MifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGkgQW5keSwNCg0KSSdtIGp1c3QgY3VyaW91cyBob3cgU2VhbiBjb252aW5jZWQgeW91IHRoYXQg
Ik1BWFBFUk0gZG9lc24ndCB3b3JrIi4gTW9yZSBzcGVjaWZpY2FsbHksIEknbSBvYmplY3Rpbmcg
dG8gdGhlIHN0YXRlbWVudCBvZiAidGhlIGVuY2xhdmUgbG9hZGVyIHdvbid0IGtub3cgYXQgbG9h
ZCB0aW1lIHdoZXRoZXIgYSBnaXZlbiBFQVVHLWVkIHBhZ2Ugd2lsbCBldmVyIGJlIGV4ZWN1dGVk
Ii4NCg0KSSdtIHN0aWxsIG5ldyB0byBMU00gc28gbXkgdW5kZXJzdGFuZGluZyBtYXkgbm90IGJl
IGNvcnJlY3QuIEJ1dCBJIHRoaW5rIExTTSBwb2xpY3kgZGVmaW5lcyBhIGJvdW5kYXJ5IHRoYXQg
Imxvb3NlbHkiIHJlc3RyaWN0cyB3aGF0IGEgcHJvY2VzcyBjYW4gZG8uIEJ5ICJsb29zZWx5Iiwg
SSBtZWFuIGl0IGlzIHVzdWFsbHkgbW9yZSBwZXJtaXNzaXZlIHRoYW4gYSBwcm9jZXNzIG5lZWRz
LiBGb3IgZXhhbXBsZSwgRklMRV9fRVhFQ01PRCBiYXNpY2FsbHkgc2F5cyB0aGVyZSBhcmUgc2Vs
Zi1tb2RpZnlpbmcgY29kZSBpbiBhIGZpbGUsIGJ1dCBpdCBpc24ndCBzcGVjaWZpYyBvbiB3aGlj
aCBwYWdlcyBjb250YWluIHNlbGYtbW9kaWZ5aW5nIGNvZGUsIGhlbmNlICphbGwqIHBhZ2VzIGFy
ZSBhbGxvd2VkIG1wcm90ZWN0KFJXLT5SWCkgZXZlbiB0aG91Z2ggb25seSBhIChzbWFsbCkgc3Vi
c2V0IGFjdHVhbGx5IG5lZWQgaXQuIExTTSBwb2xpY2llcyBhcmUgc3RhdGljIHRvbywgYXMgRklM
RV9fRVhFQ01PRCBpcyBnaXZlbiBieSBhIHN5c3RlbSBhZG1pbiB0byBiZSBhc3NvY2lhdGVkIHdp
dGggdGhlIGRpc2sgZmlsZSwgaW5zdGVhZCBvZiBiZWluZyByZXF1ZXN0ZWQvcHJvZ3JhbW1lZCBi
eSBhbnkgcHJvY2Vzc2VzIGxvYWRpbmcvbWFwcGluZyB0aGF0IGZpbGUuDQoNClNvIEkgdGhpbmsg
dGhlIHNhbWUgcmF0aW9uYWxlIGFwcGxpZXMgdG8gZW5jbGF2ZXMuIFlvdXIgb3JpZ2luYWwgaWRl
YSBvZiBNQVhQRVJNIGlzIHRoZSBwb2xpY3kgc2V0IGZvcnRoIGJ5IHN5c3RlbSBhZG1pbiBhbmQg
c2hhbGwgKm5ldmVyKiBjaGFuZ2UgYXQgcnVudGltZS4gSWYgYW4gZW5jbGF2ZSBpcyBkeW5hbWlj
YWxseSBsaW5rZWQgYW5kIG5lZWRzIHRvIGJyaW5nIGluIGNvZGUgcGFnZXMgYXQgcnVudGltZSwg
dGhlIGFkbWluIG5lZWRzIHRvIGVuYWJsZSBpdCBieSBzZXR0aW5nLCBzYXkgRU5DTEFWRV9fRVhF
Q01PRCwgaW4gdGhlIHNpZ3N0cnVjdCBmaWxlLiBUaGVuIGFsbCBFQVVHJ2VkIHBhZ2VzIHdpbGwg
cmVjZWl2ZSBSV1ggYXMgTUFYUEVSTS4gVGhlIHByb2Nlc3Mgd291bGQgdGhlbiBtcHJvdGVjdCgp
IHNlbGVjdGl2ZSBwYWdlcyB0byBiZSBSWCBidXQgd2hpY2ggZXhhY3Qgc2V0IG9mIHBhZ2VzIGRv
ZXNuJ3QgY29uY2VybiBMU00gdXN1YWxseS4NCg0KPiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21h
aWx0bzpsdXRvQGtlcm5lbC5vcmddDQo+IFNlbnQ6IFRodXJzZGF5LCBNYXkgMzAsIDIwMTkgMTI6
MjEgUE0NCj4gDQo+IE9uIFRodSwgTWF5IDMwLCAyMDE5IGF0IDExOjAxIEFNIFNlYW4gQ2hyaXN0
b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+DQo+IHdyb3RlOg0KPiA+
DQo+ID4gT24gVGh1LCBNYXkgMzAsIDIwMTkgYXQgMDk6MTQ6MTBBTSAtMDcwMCwgQW5keSBMdXRv
bWlyc2tpIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBNYXkgMzAsIDIwMTkgYXQgODowNCBBTSBTdGVw
aGVuIFNtYWxsZXkgPHNkc0B0eWNoby5uc2EuZ292PiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4g
T24gNS8zMC8xOSAxMDozMSBBTSwgQW5keSBMdXRvbWlyc2tpIHdyb3RlOg0KPiA+ID4gPiA+IEhp
IGFsbC0NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEFmdGVyIGFuIG9mZmxpbmUgZGlzY3Vzc2lvbiB3
aXRoIFNlYW4geWVzdGVyZGF5LCBoZXJlIGFyZSBzb21lDQo+ID4gPiA+ID4gdXBkYXRlcyB0byB0
aGUgdXNlciBBUEkgcGFydHMgb2YgbXkgcHJvcG9zYWwuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBV
bmZvcnR1bmF0ZWx5LCBTZWFuIGNvbnZpbmNlZCBtZSB0aGF0IE1BWFBFUk0gZG9lc24ndCB3b3Jr
IHRoZQ0KPiA+ID4gPiA+IHdheSBJIGRlc2NyaWJlZCBpdCBiZWNhdXNlLCBmb3IgU0dYMiwgdGhl
IGVuY2xhdmUgbG9hZGVyIHdvbid0DQo+ID4gPiA+ID4ga25vdyBhdCBsb2FkIHRpbWUgd2hldGhl
ciBhIGdpdmVuIEVBVUctZWQgcGFnZSB3aWxsIGV2ZXIgYmUNCj4gPiA+ID4gPiBleGVjdXRlZC4g
IFNvIGhlcmUncyBhbiB1cGRhdGUuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBGaXJzdCwgaGVyZSBh
cmUgdGhlIHJlcXVyZW1lbnRzIGFzIEkgc2VlIHRoZW0sIHdoZXJlIEVYRUNVVEUsDQo+ID4gPiA+
ID4gRVhFQ01PRCwgYW5kIEVYRUNNRU0gY291bGQgYmUgc3Vic3RpdHV0ZWQgd2l0aCBvdGhlciBy
dWxlcyBhdA0KPiA+ID4gPiA+IHRoZSBMU00ncw0KPiA+ID4gPiA+IGRpc2NyZXRpb246DQo+ID4g
PiA+ID4NCj4gPiA+ID4gPiAgIC0gWW91IGNhbiBjcmVhdGUgYSBXWCBvciBSV1ggbWFwcGluZyBp
ZiBhbmQgb25seSBpZiB5b3UgaGF2ZSBFWEVDTUVNLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gICAt
IFRvIGNyZWF0ZSBhbiBYIG1hcHBpbmcgb2YgYW4gZW5jbGF2ZSBwYWdlIHRoYXQgaGFzIGV2ZXIg
YmVlbg0KPiA+ID4gPiA+IFcsIHlvdSBuZWVkIEVYRUNNT0QuDQo+ID4gPiA+DQo+ID4gPiA+IEVY
RUNNT0QgdG8gd2hhdCBmaWxlPyBUaGUgZW5jbGF2ZSBmaWxlIGZyb20gd2hpY2ggdGhlIHBhZ2Un
cw0KPiA+ID4gPiBjb250ZW50IG9yaWdpbmF0ZWQsIHRoZSBzaWdzdHJ1Y3QgZmlsZSwgb3IgL2Rl
di9zZ3gvZW5jbGF2ZT8NCj4gPiA+DQo+ID4gPiBJIGxlYXZlIHRoYXQgZGVjaXNpb24gdG8geW91
IDopICBUaGUgdXNlciBzaG91bGQgbmVlZCBwZXJtaXNzaW9uIHRvDQo+ID4gPiBkbyBhbiBleGVj
bW9kIHRoaW5nIG9uIGFuIGVuY2xhdmUsIGhvd2V2ZXIgdGhhdCB3YW50cyB0byBiZSBlbmNvZGVk
Lg0KPiA+DQo+ID4gQnV0IHRoYXQgZGVjaXNpb24gZGljdGF0ZXMgaG93IHRoZSBTR1ggQVBJIGhh
bmRsZXMgc2lnc3RydWN0LiAgSWYgTFNNcw0KPiA+IHdhbnQgdG8gYXNzb2NpYXRlIEVYRUNNT0Qg
d2l0aCBzaWdzdHJ1Y3QsIHRoZW4gU0dYIG5lZWRzIHRvIHRha2UNCj4gPiBzaWdzdHJ1Y3QgZWFy
bHkgYW5kIGhvbGQgYSByZWZlcmVuY2UgdG8gdGhlIGZpbGUgZm9yIHRoZSBsaWZldGltZSBvZiB0
aGUgZW5jbGF2ZS4NCj4gPiBBbmQgaWYgd2UncmUgZ29pbmcgdG8gZG8gdGhhdCwgdGhlIHdob2xl
IGFwcHJvYWNoIG9mIGluaGVyaXRpbmcNCj4gPiBwZXJtaXNzaW9ucyBmcm9tIHNvdXJjZSBWTUFz
IGJlY29tZXMgdW5uZWNlc3NhcnkgY29tcGxleGl0eS4NCj4gPg0KPiA+ID4gPg0KPiA+ID4gPiA+
ICAgLSBUbyBjcmVhdGUgYW4gWCBtYXBwaW5nIG9mIGFuIGVuY2xhdmUgcGFnZSB0aGF0IGNhbWUg
ZnJvbQ0KPiA+ID4gPiA+IEVBREQsIHlvdSBuZWVkIEVYRUNVVEUgb24gdGhlIHNvdXJjZSBmaWxl
LiAgT3B0aW9uYWxseSwgd2UgY291bGQNCj4gPiA+ID4gPiBhbHNvIHBlcm1pdCB0aGlzIGlmIHlv
dSBoYXZlIEVYRUNNT0QuDQo+ID4gPiA+DQo+ID4gPiA+IFdoYXQgaXMgdGhlICJzb3VyY2UgZmls
ZSIgaS5lLiB0aGUgdGFyZ2V0IG9mIHRoZSBjaGVjaz8gIEVuY2xhdmUNCj4gPiA+ID4gZmlsZSwg
c2lnc3RydWN0IGZpbGUsIG9yIC9kZXYvc2d4L2VuY2xhdmU/DQo+ID4gPg0KPiA+ID4gRW5jbGF2
ZSBmaWxlIC0tIHRoYXQgaXMsIHRoZSBmaWxlIGJhY2tpbmcgdGhlIHZtYSBmcm9tIHdoaWNoIHRo
ZSBkYXRhIGlzIGxvYWRlZC4NCj4gPg0KPiA+IEl0IHdhc24ndCBleHBsaWNpdGx5IGNhbGxlZCBv
dXQgaW4gQW5keSdzIHByb3Bvc2FsKHMpLCBidXQgdGhlIGlkZWEgaXMNCj4gPiB0aGF0IHRoZSBT
R1ggZHJpdmVyIHdvdWxkIGVmZmVjdGl2ZWx5IGluaGVyaXQgcGVybWlzc2lvbnMgZnJvbSB0aGUN
Cj4gPiBzb3VyY2UgVk1BIChFQUREIG5lZWRzIGEgc291cmNlIGZvciB0aGUgaW5pdGlhbCB2YWx1
ZSBvZiB0aGUgZW5jYXZlIHBhZ2UpLg0KPiANCj4gSSBhY3R1YWxseSBtZWFudCBmb3IgaXQgdG8g
Km5vdCogd29yayBsaWtlIHRoaXMuICBJIGRvbid0IHdhbnQgdGhlIHNvdXJjZSBWTUEgdG8gaGF2
ZSB0bw0KPiBiZSBWTV9FWEVDLiAgSSB0aGluayB0aGUgTFNNIHNob3VsZCBqdXN0IGNoZWNrIHBl
cm1pc3Npb25zIG9uIC0+dm1fZmlsZS4NCg0KLUNlZHJpYw0K
