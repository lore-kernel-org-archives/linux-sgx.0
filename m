Return-Path: <SRS0=m9nj=TQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E61C04E84
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 03:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84F6120848
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 03:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfEPDD0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 May 2019 23:03:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:4526 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbfEPDDZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 15 May 2019 23:03:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 May 2019 20:03:24 -0700
X-ExtLoop1: 1
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga001.jf.intel.com with ESMTP; 15 May 2019 20:03:24 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX109.amr.corp.intel.com ([169.254.11.251]) with mapi id 14.03.0415.000;
 Wed, 15 May 2019 20:03:24 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>, James Morris <jmorris@namei.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Eric Paris" <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
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
Thread-Index: AQHVC0vUmIXibKT8TUm/EUnHn2XAfqZtD8kAgAAKXgCAACSqAIAAB3yA//+8UNA=
Date:   Thu, 16 May 2019 03:03:23 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org>
 <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
 <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
In-Reply-To: <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTk2MGUwNDItMDdmMi00NzJmLWJhMTItNmM5MzU4MWQ3ZDMxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiM0ZyaEtXUFNTaXE5Mml2NUdiQmtGRTJrTUp3NXJcLzhRZXlNeTdxZTF1RGU3RTgxUDRKSENFRlwvN2pnM0lLWHVQIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGkgQW5keSwNCg0KPiBGcm9tOiBBbmR5IEx1dG9taXJza2kgW21haWx0bzpsdXRvQGtlcm5lbC5v
cmddDQo+IA0KPiBPbiBXZWQsIE1heSAxNSwgMjAxOSBhdCAzOjQ2IFBNIEphbWVzIE1vcnJpcyA8
am1vcnJpc0BuYW1laS5vcmc+IHdyb3RlOg0KPiA+DQo+ID4gT24gV2VkLCAxNSBNYXkgMjAxOSwg
QW5keSBMdXRvbWlyc2tpIHdyb3RlOg0KPiA+DQo+ID4gPiA+IFdoeSBub3QganVzdCB1c2UgYW4g
eGF0dHIsIGxpa2Ugc2VjdXJpdHkuc2d4ID8NCj4gPiA+DQo+ID4gPiBXb3VsZG4ndCB0aGlzIG1h
a2UgaXQgc28gdGhhdCBvbmx5IHNvbWVvbmUgd2l0aCBDQVBfTUFDX0FETUlOIGNvdWxkDQo+ID4g
PiBpbnN0YWxsIGFuIGVuY2xhdmU/ICBJIHRoaW5rIHRoYXQgdGhpcyBkZWNpc2lvbiBzaG91bGQg
YmUgbGVmdCB1cCB0aGUNCj4gPiA+IGFkbWluaXN0cmF0b3IsIGFuZCBpdCBzaG91bGQgYmUgZWFz
eSB0byBzZXQgdXAgYSBsb29zZSBwb2xpY3kgd2hlcmUNCj4gPiA+IGFueW9uZSBjYW4gbG9hZCB3
aGF0ZXZlciBlbmNsYXZlIHRoZXkgd2FudC4gIFRoYXQncyB3aGF0IHdvdWxkIGhhcHBlbg0KPiA+
ID4gaW4gbXkgcHJvcG9zYWwgaWYgdGhlcmUgd2FzIG5vIExTTSBsb2FkZWQgb3Igb2YgdGhlIExT
TSBwb2xpY3kgZGlkbid0DQo+ID4gPiByZXN0cmljdCB3aGF0IC5zaWdzdHJ1Y3QgZmlsZXMgd2Vy
ZSBhY2NlcHRhYmxlLg0KPiA+ID4NCj4gPg0KPiA+IFlvdSBjb3VsZCB0cnkgdXNlci5zaWdzdHJ1
Y3QsIHdoaWNoIGRvZXMgbm90IHJlcXVpcmUgYW55IHByaXZzLg0KPiA+DQo+IA0KPiBJIGRvbid0
IHRoaW5rIEkgdW5kZXJzdGFuZCB5b3VyIHByb3Bvc2FsLiAgV2hhdCBmaWxlIHdvdWxkIHRoaXMN
Cj4gYXR0cmlidXRlIGJlIG9uPyAgV2hhdCB3b3VsZCBjb25zdW1lIGl0Pw0KPiANCj4gSSdtIGlt
YWdpbmluZyB0aGF0IHRoZXJlJ3Mgc29tZSBlbmNsYXZlIGluIGEgZmlsZQ0KPiBjcnlwdG9fdGhp
bmd5LmVuY2xhdmUuICBUaGVyZSdzIGFsc28gYSBmaWxlIGNyeXB0b190aGluZ3kuc2lnc3RydWN0
Lg0KPiBjcnlwdG9fdGhpbmd5LmVuY2xhdmUgaGFzIHR5cGUgbGliX3Qgb3Igc2ltaWxhciBzbyB0
aGF0IGl0J3MNCj4gZXhlY3V0YWJsZS4gIGNyeXB0b190aGluZ3kuc2lnc3RydWN0IGhhcyB0eXBl
IHNneF9zaWdzdHJ1Y3RfdC4gIFRoZQ0KPiBlbmNsYXZlIGxvYWRlciBkb2VzLCBpbiBlZmZlY3Q6
DQo+IA0KPiB2b2lkICpzb3VyY2VfZGF0YSA9IG1tYXAoY3J5cHRvX3RoaW5neS5lbmNsYXZlLCBQ
Uk9UX1JFQUQgfCBQUk9UX0VYRUMsIC4uLik7DQo+IGludCBzaWdzdHJ1Y3RfZmQgPSBvcGVuKCJj
cnlwdG9fdGhpbmd5LnNpZ3N0cnVjdCIsIE9fUkRPTkxZKTsNCj4gaW50IGVuY2xhdmVfZmQgPSBv
cGVuKCIvZGV2L3NneC9lbmNsYXZlIiwgT19SRFdSKTsNCj4gDQo+IGlvY3RsKGVuY2xhdmVfZmQs
IFNHWF9JT0NfQUREX1NPTUVfREFUQSwgc291cmNlX2RhdGEgKyBzb3VyY2Vfb2Zmc2V0LA0KPiBl
bmNsYXZlX29mZnNldCwgbGVuLCAuLi4pOw0KPiBpb2N0bChlbmNsYXZlX2ZkLCBTR1hfSU9DX0FE
RF9TT01FX0RBVEEsIHNvdXJjZV9kYXRhICsgc291cmNlX29mZnNldDIsDQo+IGVuY2xhdmVfb2Zm
c2V0MiwgbGVuLCAuLi4pOw0KPiBldGMuDQo+IA0KPiAvKiBIZXJlJ3Mgd2hlcmUgTFNNcyBnZXQg
dG8gY2hlY2sgdGhhdCB0aGUgc2lnc3RydWN0IGlzIGFjY2VwdGFibGUuDQo+IFRoZSBDUFUgd2ls
bCBjaGVjayB0aGF0IHRoZSBzaWdzdHJ1Y3QgbWF0Y2hlcyB0aGUgZW5jbGF2ZS4gKi8NCj4gaW9j
dGwoZW5jbGF2ZV9mZCwgU0dYX0lOSVRfVEhFX0VOQ0xBVkUsIHNpZ3N0cnVjdF9mZCk7DQoNClNJ
R1NUUlVDVCBpc24ndCBuZWNlc3NhcmlseSBzdG9yZWQgb24gZGlzayBzbyBtYXkgbm90IGFsd2F5
cyBoYXZlIGEgZmQuIEhvdyBhYm91dCB0aGUgZm9sbG93aW5nPw0Kdm9pZCAqc3NfcG9pbnRlciA9
IG1tYXAoc2lnc3RydWN0X2ZkLCBQUk9UX1JFQUQsLi4uKTsNCmlvY3RsKGVuY2xhdmVfZmQsIFNH
WF9JTklUX1RIRV9FTkNMQVZFLCBzc19wb2ludGVyKTsNCg0KVGhlIGlkZWEgaGVyZSBpcyBTSUdT
VFJVQ1Qgd2lsbCBzdGlsbCBiZSBwYXNzZWQgaW4gbWVtb3J5IHNvIGl0IHdvcmtzIHRoZSBzYW1l
IHdheSB3aGVuIG5vIExTTSBtb2R1bGVzIGFyZSBsb2FkZWQgb3IgYmFzaW5nIGl0cyBkZWNpc2lv
biBvbiB0aGUgLnNpZ3N0cnVjdCBmaWxlLiBPdGhlcndpc2UsIGFuIExTTSBtb2R1bGUgY2FuIGZp
Z3VyZSBvdXQgdGhlIGJhY2tpbmcgZmlsZSAoYW5kIG9mZnNldCB3aXRoaW4gdGhhdCBmaWxlKSBi
eSBsb29raW5nIGludG8gdGhlIFZNQSBjb3ZlcmluZyBzc19wb2ludGVyLg0KDQo+IA0KPiAvKiBB
Y3R1YWxseSBtYXAgdGhlIHRoaW5nICovDQo+IG1tYXAoZW5jbGF2ZV9mZCBSTyBzZWN0aW9uLCBQ
Uk9UX1JFQUQsIC4uLik7DQo+IG1tYXAoZW5jbGF2ZV9mZCBSVyBzZWN0aW9uLCBQUk9UX1JFQUQg
fCBQUk9UX1dSSVRFLCAuLi4pOw0KPiBtbWFwKGVuY2xhdmVfZmQgUlggc2VjdGlvbiwgUFJPVF9S
RUFEIHwgUFJPVF9FWEVDLCAuLi4pOw0KPiANCj4gLyogVGhpcyBzaG91bGQgZmFpbCB1bmxlc3Mg
RVhFQ01PRCBpcyBhdmFpbGFibGUsIEkgdGhpbmsgKi8NCj4gbW1hcChlbmNsYXZlX2ZkIFJXWCBz
ZWN0aW9uLCBQUk9UX1JFQUQgfCBQUk9UX1dSSVRFIHwgUFJPVF9FWEVDKTsNCj4gDQo+IEFuZCB0
aGUgaWRlYSBoZXJlIGlzIHRoYXQsIGlmIHRoZSAuZW5jbGF2ZSBmaWxlIGlzbid0IG1hcHBlZA0K
PiBQUk9UX0VYRUMsIHRoZW4gbW1hcHBpbmcgdGhlIFJYIHNlY3Rpb24gd2lsbCBhbHNvIHJlcXVp
cmUgRVhFQ01FTSBvcg0KPiBFWEVDTU9ELg0KDQpGcm9tIHNlY3VyaXR5IHBlcnNwZWN0aXZlLCBJ
IHRoaW5rIGl0IHJlYXNvbmFibGUgdG8gZ2l2ZSBFWEVDTUVNIGFuZCBFWEVDTU9EIHRvIC9kZXYv
c2d4L2VuY2xhdmUgYmVjYXVzZSB0aGUgYWN0dWFsIHBlcm1pc3Npb25zIGFyZSBndWFyZGVkIGJ5
IEVQQ00gcGVybWlzc2lvbnMsIHdoaWNoIGFyZSAiaW5oZXJpdGVkIiBmcm9tIHRoZSBzb3VyY2Ug
cGFnZXMsIHdob3NlIHBlcm1pc3Npb25zIGhhdmUgcGFzc2VkIExTTSBjaGVja3MuDQoNCkFsdGVy
bmF0aXZlbHksIEkgdGhpbmsgd2UgY291bGQgbWFyayBlbmNsYXZlIFZNQXMgc29tZXdoYXQgZGlm
ZmVyZW50bHksIHN1Y2ggYXMgZGVmaW5pbmcgYSBuZXcgVk1fU0dYIGZsYWcuIFRoZSByZWFzb24g
YmVoaW5kIHRoYXQgaXMsIGVuY2xhdmUgcmFuZ2VzIGRpZmZlciBmcm9tICJyZWd1bGFyIiB2aXJ0
dWFsIHJhbmdlcyBpbiB0ZXJtcyBvZiBib3RoIGZ1bmN0aW9uYWxpdHkgKGkuZS4gI1BGIHdpbGwg
aGF2ZSB0byBiZSBoYW5kbGVkIHF1aXRlIGRpZmZlcmVudGx5KSBhbmQgc2VjdXJpdHksIHNvIEkg
YmVsaWV2ZSBkZW1hbmQgd2lsbCBjb21lIHVwIHRvIGRpc3Rpbmd1aXNoIHRoZW0gZXZlbnR1YWxs
eSAtIGUuZy4sIExTTSBtb2R1bGVzIGNhbiB0aGVuIGVuZm9yY2UgZGlmZmVyZW50IHBvbGljaWVz
IG9uIHRoZW0gKGJ5IGEgbmV3IHNlY3VyaXR5X3NneF9tcHJvdCgpIGhvb2s/KS4NCg0KLUNlZHJp
Yw0K
