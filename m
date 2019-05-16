Return-Path: <SRS0=m9nj=TQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B61C04AAF
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 22:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA3352070D
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 22:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfEPWXd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 May 2019 18:23:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:11710 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbfEPWXd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 May 2019 18:23:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 15:23:32 -0700
X-ExtLoop1: 1
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga007.fm.intel.com with ESMTP; 16 May 2019 15:23:31 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX105.amr.corp.intel.com ([169.254.2.95]) with mapi id 14.03.0415.000;
 Thu, 16 May 2019 15:23:31 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     James Morris <jmorris@namei.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "LSM List" <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
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
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: RE: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Topic: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Index: AQHVC0vUmIXibKT8TUm/EUnHn2XAfqZtD8kAgAAKXgCAACSqAIAAB3yA//+8UNCAAJ8WgIAAanNw
Date:   Thu, 16 May 2019 22:23:30 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
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
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
In-Reply-To: <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOGJiNWQ0ZTgtMzZhZi00NTc5LTkyZTItYTlkNWRjMjFmZGE1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZDY5Z2RZcEo5eUR6elwvMkUzNlR5MDZ2TVpqYVhTek9NK3hRUEQ1VHp6Z0hrbTdCK3hLUStBTnN6UkZmOWZ3dHcifQ==
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

SGkgQW5keSwNCg0KPiA+IFNJR1NUUlVDVCBpc24ndCBuZWNlc3NhcmlseSBzdG9yZWQgb24gZGlz
ayBzbyBtYXkgbm90IGFsd2F5cyBoYXZlIGEgZmQuDQo+IEhvdyBhYm91dCB0aGUgZm9sbG93aW5n
Pw0KPiA+IHZvaWQgKnNzX3BvaW50ZXIgPSBtbWFwKHNpZ3N0cnVjdF9mZCwgUFJPVF9SRUFELC4u
Lik7DQo+ID4gaW9jdGwoZW5jbGF2ZV9mZCwgU0dYX0lOSVRfVEhFX0VOQ0xBVkUsIHNzX3BvaW50
ZXIpOw0KPiA+DQo+ID4gVGhlIGlkZWEgaGVyZSBpcyBTSUdTVFJVQ1Qgd2lsbCBzdGlsbCBiZSBw
YXNzZWQgaW4gbWVtb3J5IHNvIGl0IHdvcmtzDQo+IHRoZSBzYW1lIHdheSB3aGVuIG5vIExTTSBt
b2R1bGVzIGFyZSBsb2FkZWQgb3IgYmFzaW5nIGl0cyBkZWNpc2lvbiBvbg0KPiB0aGUgLnNpZ3N0
cnVjdCBmaWxlLiBPdGhlcndpc2UsIGFuIExTTSBtb2R1bGUgY2FuIGZpZ3VyZSBvdXQgdGhlIGJh
Y2tpbmcNCj4gZmlsZSAoYW5kIG9mZnNldCB3aXRoaW4gdGhhdCBmaWxlKSBieSBsb29raW5nIGlu
dG8gdGhlIFZNQSBjb3ZlcmluZw0KPiBzc19wb2ludGVyLg0KPiANCj4gSSBkb27igJl0IGxvdmUg
dGhpcyBhcHByb2FjaC4gIEFwcGxpY2F0aW9uIGF1dGhvcnMgc2VlbSBsaWtlbHkgdG8gdXNlDQo+
IHJlYWQoKSBpbnN0ZWFkIG9mIG1tYXAoKSwgYW5kIGl04oCZbGwgc3RpbGwgd29yayBpbiBtYW55
IGNhcmVzLiBJdCB3b3VsZA0KPiBhbHNvIGNvbXBsaWNhdGUgdGhlIGtlcm5lbCBpbXBsZW1lbnRh
dGlvbiwgYW5kIGxvb2tpbmcgYXQgdGhlIGlub2RlDQo+IGJhY2tpbmcgdGhlIHZtYSB0aGF0IGJh
Y2tzIGEgcG9pbnRlciBpcyBhdCBsZWFzdCByYXRoZXIgdW51c3VhbC4NCj4gSW5zdGVhZCwgaWYg
dGhlIHNpZ3N0cnVjdCBpc27igJl0IG9uIGRpc2sgYmVjYXVzZSBpdOKAmXMgZHluYW1pYyBvciBj
YW1lDQo+IGZyb20gYSBuZXR3b3JrLCB0aGUgYXBwbGljYXRpb24gY2FuIHB1dCBpdCBpbiBhIG1l
bWZkLg0KDQpJIHVuZGVyc3RhbmQgeW91ciBjb25jZXJuIGhlcmUuIEJ1dCBJIGd1ZXNzIHdlIGFy
ZSBtYWtpbmcgdG9vIG11Y2ggYXNzdW1wdGlvbiBvbiBob3cgZW5jbGF2ZXMgYXJlIHN0cnVjdHVy
ZWQvcGFja2FnZWQuIE15IGNvbmNlcm4gaXMsIHdoYXQgaWYgYSBTSUdTVFJVQ1QgcmVhbGx5IGhh
cyB0byBiZSBmcm9tIG1lbW9yeT8gRm9yIGV4YW1wbGUsIGFuIGVuY2xhdmUgKGFsb25nIHdpdGgg
aXRzIFNJR1NUUlVDVCkgY291bGQgYmUgZW1iZWRkZWQgaW5zaWRlIGEgc2hhcmVkIG9iamVjdCAo
b3IgZXZlbiB0aGUgIm1haW4iIGV4ZWN1dGFibGUpIHNvIGl0IHNob3dzIHVwIGluIG1lbW9yeSB0
byBiZWdpbiB3aXRoLiBPZiBjb3Vyc2UgaXQgY291bGQgYmUgY29waWVkIHRvIGEgbWVtZmQgYnV0
IHdoYXRldmVyICJhdHRyaWJ1dGVzIiAoZS5nLiBwYXRoLCBvciBTRUxpbnV4IGNsYXNzL3R5cGUp
IGFzc29jaWF0ZWQgd2l0aCB0aGUgb3JpZ2luYWwgZmlsZSB3b3VsZCBiZSBsb3N0LCBzbyBJJ20g
bm90IHN1cmUgaWYgdGhhdCB3b3VsZCB3b3JrLg0KDQpJJ20gYWxzbyB3aXRoIHlvdSB0aGF0IGFw
cGxpY2F0aW9ucyB0ZW5kIHRvIHVzZSByZWFkKCkgaW5zdGVhZCBvZiBtbWFwKCkgZm9yIGFjY2Vz
c2luZyBmaWxlcy4gQnV0IGluIG91ciBjYXNlIHRoYXQnZCBiZSBuZWNlc3Nhcnkgb25seSBpZiAu
c2lnc3RydWN0IGlzIGEgc2VwYXJhdGUgZmlsZSAoaGVuY2UgbmVlZHMgdG8gYmUgcmVhZCBzZXBh
cmF0ZWx5KS4gV2hhdCBpZiAoYW5kIEkgZ3Vlc3MgbW9zdCBpbXBsZW1lbnRhdGlvbnMgd291bGQp
IHRoZSBTSUdTVFJVQ1QgaXMgZW1iZWRkZWQgaW4gdGhlIHNhbWUgZmlsZSBhcyB0aGUgZW5jbGF2
ZT8gbW1hcCgpIGlzIHRoZSBtb3JlIGNvbW1vbiBwcmFjdGljZSB3aGVuIGRlYWxpbmcgd2l0aCBl
eGVjdXRhYmxlIGltYWdlcywgYW5kIGluIHRoYXQgY2FzZSBTSUdTVFJVQ1Qgd2lsbCBoYXZlIGFs
cmVhZHkgYmVlbiBtbWFwKCknZC4gDQoNCkknbSB3aXRoIHlvdSBhZ2FpbiB0aGF0IGl0J3Mga2lu
ZCBvZiB1bnByZWNlZGVudGVkIHRvIGxvb2sgYXQgdGhlIGJhY2tpbmcgaW5vZGUuIEJ1dCBJIGJl
bGlldmUgd2Ugc2hvdWxkIHN0cml2ZSB0byBhbGxvdyBhcyBsYXJnZSB2YXJpZXR5IG9mIGFwcGxp
Y2F0aW9ucy91c2FnZXMgYXMgcG9zc2libGUgYW5kIEkgZG9uJ3Qgc2VlIGFueSBhbHRlcm5hdGl2
ZXMgd2l0aG91dCBsb3NpbmcgZmxleGliaWxpdHkuDQoNCj4gPg0KPiA+Pg0KPiA+PiAvKiBBY3R1
YWxseSBtYXAgdGhlIHRoaW5nICovDQo+ID4+IG1tYXAoZW5jbGF2ZV9mZCBSTyBzZWN0aW9uLCBQ
Uk9UX1JFQUQsIC4uLik7DQo+ID4+IG1tYXAoZW5jbGF2ZV9mZCBSVyBzZWN0aW9uLCBQUk9UX1JF
QUQgfCBQUk9UX1dSSVRFLCAuLi4pOw0KPiA+PiBtbWFwKGVuY2xhdmVfZmQgUlggc2VjdGlvbiwg
UFJPVF9SRUFEIHwgUFJPVF9FWEVDLCAuLi4pOw0KPiA+Pg0KPiA+PiAvKiBUaGlzIHNob3VsZCBm
YWlsIHVubGVzcyBFWEVDTU9EIGlzIGF2YWlsYWJsZSwgSSB0aGluayAqLw0KPiA+PiBtbWFwKGVu
Y2xhdmVfZmQgUldYIHNlY3Rpb24sIFBST1RfUkVBRCB8IFBST1RfV1JJVEUgfCBQUk9UX0VYRUMp
Ow0KPiA+Pg0KPiA+PiBBbmQgdGhlIGlkZWEgaGVyZSBpcyB0aGF0LCBpZiB0aGUgLmVuY2xhdmUg
ZmlsZSBpc24ndCBtYXBwZWQNCj4gPj4gUFJPVF9FWEVDLCB0aGVuIG1tYXBwaW5nIHRoZSBSWCBz
ZWN0aW9uIHdpbGwgYWxzbyByZXF1aXJlIEVYRUNNRU0gb3INCj4gPj4gRVhFQ01PRC4NCj4gPg0K
PiA+IEZyb20gc2VjdXJpdHkgcGVyc3BlY3RpdmUsIEkgdGhpbmsgaXQgcmVhc29uYWJsZSB0byBn
aXZlIEVYRUNNRU0gYW5kDQo+IEVYRUNNT0QgdG8gL2Rldi9zZ3gvZW5jbGF2ZSBiZWNhdXNlIHRo
ZSBhY3R1YWwgcGVybWlzc2lvbnMgYXJlIGd1YXJkZWQNCj4gYnkgRVBDTSBwZXJtaXNzaW9ucywg
d2hpY2ggYXJlICJpbmhlcml0ZWQiIGZyb20gdGhlIHNvdXJjZSBwYWdlcywgd2hvc2UNCj4gcGVy
bWlzc2lvbnMgaGF2ZSBwYXNzZWQgTFNNIGNoZWNrcy4NCj4gDQo+IEkgZGlzYWdyZWUuICBJZiB5
b3UgZGVueSBhIHByb2dyYW0gRVhFQ01PRCwgaXTigJlzIG5vdCBiZWNhdXNlIHlvdQ0KPiBkaXN0
cnVzdCB0aGUgcHJvZ3JhbS4gSXTigJlzIGJlY2F1c2UgeW91IHdhbnQgdG8gZW5mb3JjZSBnb29k
IHNlY3VyaXR5DQo+IHByYWN0aWNlcy4gIChPciB5b3XigJlyZSBBcHBsZSBhbmQgd2FudCB0byBk
aXNhbGxvdyB0aGlyZC1wYXJ0eSBKSVRzLikNCj4gQSBwb2xpY3kgdGhhdCBhY2NlcHRzIGFueSBz
aWdzdHJ1Y3QgYnV0IHJlcXVpcmVzIHRoYXQgZW5jbGF2ZXMgY29tZQ0KPiBmcm9tIGRpc2sgYW5k
IHJlc3BlY3QgV15YIHNlZW1zIGVudGlyZWx5IHJlYXNvbmFibGUuDQo+IA0KPiBJIHRoaW5rIHRo
YXQgYmxvY2tpbmcgRVhFQ01PRCBoYXMgbGlrZWx5IHNlcnZlZCB0d28gdmVyeSByZWFsIHNlY3Vy
aXR5DQo+IHB1cnBvc2VzLiBJdCBoZWxwcyBmb3JjZSBhcHBsaWNhdGlvbiBhbmQgbGlicmFyeSBk
ZXZlbG9wZXJzIHRvIHdyaXRlDQo+IGFuZCBjb21waWxlIHRoZWlyIGNvZGUgaW4gYSB3YXkgdGhh
dCBkb2VzbuKAmXQgcmVseSBvbiBkYW5nZXJvdXMgdHJpY2tzDQo+IGxpa2UgcHV0dGluZyBleGVj
dXRhYmxlIHRyYW1wb2xpbmVzIG9uIHRoZSBzdGFjay4gIEl0IGFsc28gbWFrZXMgaXQNCj4gZXNz
ZW50aWFsbHkgaW1wb3NzaWJsZSBmb3IgYW4gZXhwbG9pdCB0byBydW4gYWN0dWFsIGRvd25sb2Fk
ZWQgbWFjaGluZQ0KPiBjb2RlIOKAlCBpZiB0aGVyZSBpcyBubyB3YXkgdG8gcnVuIGNvZGUgdGhh
dCBpc27igJl0IGFwcHJvcHJpYXRlbHkNCj4gbGFiZWxlZCwgdGhlbiBhdHRhY2tlcnMgYXJlIG1v
cmUgbGltaXRlZCBpbiB3aGF0IHRoZXkgY2FuIGRvLg0KDQo+IA0KPiBJIGRvbuKAmXQgdGhpbmsg
dGhhdCBTR1ggc2hvdWxkIGJlY29tZSBhbiBleGNlcHRpb24gdG8gZWl0aGVyIG9mIHRoZXNlLg0K
PiBDb2RlIHNob3VsZCBub3QgaGF2ZSBhbiBleGN1c2UgdG8gdXNlIFdYIG1lbW9yeSBqdXN0IGJl
Y2F1c2UgaXTigJlzIGluDQo+IGFuIGVuY2xhdmUuIFNpbWlsYXJseSwgYW4gZXhwbG9pdCBzaG91
bGQgbm90IGJlIGFibGUgdG8gcnVuIGFuDQo+IGF0dGFja2VyLXN1cHBsaWVkIGVuY2xhdmUgYXMg
YSB3YXkgYXJvdW5kIGEgcG9saWN5IHRoYXQgd291bGQNCj4gb3RoZXJ3aXNlIHByZXZlbnQgZG93
bmxvYWRlZCBjb2RlIGZyb20gcnVubmluZy4NCg0KTXkgYXBvbG9neSBmb3IgdGhlIGNvbmZ1c2lv
biBoZXJlLg0KDQpJIHRob3VnaHQgRVhFQ01PRCBhcHBsaWVkIHRvIGZpbGVzIChhbmQgbWVtb3J5
IG1hcHBpbmdzIGJhY2tlZCBieSB0aGVtKSBidXQgSSB3YXMgcHJvYmFibHkgd3JvbmcuIEl0IHNv
dW5kcyBsaWtlIEVYRUNNT0QgYXBwbGllcyB0byB0aGUgd2hvbGUgcHJvY2VzcyBzbyB3b3VsZCBh
bGxvdyBhbGwgcGFnZXMgd2l0aGluIGEgcHJvY2VzcydzIGFkZHJlc3Mgc3BhY2UgdG8gYmUgbW9k
aWZpZWQgdGhlbiBleGVjdXRlZCwgcmVnYXJkbGVzcyB0aGUgYmFja2luZyBmaWxlcy4gQW0gSSBj
b3JyZWN0IHRoaXMgdGltZT8NCg0KSSB3YXMgbm90IHNheWluZyBlbmNsYXZlcyB3ZXJlIGV4ZW1w
dCB0byBnb29kIHNlY3VyaXR5IHByYWN0aWNlcy4gV2hhdCBJIHdhcyB0cnlpbmcgdG8gc2F5IHdh
cywgRVBDIHBhZ2VzIGFyZSAqbm90KiBzdWJqZWN0IHRvIHRoZSBzYW1lIGF0dGFja3MgYXMgcmVn
dWxhciBwYWdlcyBzbyBJIHN1c3BlY3QgdGhlcmUgd2lsbCBiZSBhIGRlc2lyZSB0byBlbmZvcmNl
IGRpZmZlcmVudCBwb2xpY2llcyBvbiB0aGVtLCBlc3BlY2lhbGx5IGFmdGVyIG5ldyBTR1gyIGZl
YXR1cmVzL2FwcGxpY2F0aW9ucyBiZWNvbWUgYXZhaWxhYmxlLiBTbyBJIHRoaW5rIGl0IGJlbmVm
aWNpYWwgdG8gZGlzdGluZ3Vpc2ggYmV0d2VlbiByZWd1bGFyIHZzLiBlbmNsYXZlIHZpcnR1YWwg
cmFuZ2VzLiBBbmQgdG8gZG8gdGhhdCwgYSBuZXcgVk1fU0dYIGZsYWcgaW4gVk1BIGlzIHByb2Jh
Ymx5IGEgdmVyeSBzaW1wbGUvZWFzeSB3YXkuIEFuZCB3aXRoIHRoYXQgVk1fU0dYIGZsYWcsIHdl
IGNvdWxkIGFkZCBhIG5ldyBzZWN1cml0eV9zZ3hfbXByb3QoKSBob29rIHNvIHRoYXQgTFNNIG1v
ZHVsZXMvcG9saWNpZXMgY291bGQgYWN0IGRpZmZlcmVudGx5Lg0KDQpBbmQgaWYgeW91IGFyZSB3
aXRoIG1lIG9uIHRoYXQgYmlnZ2VyIHBpY3R1cmUsIHRoZSBuZXh0IHF1ZXN0aW9uIGlzOiB3aGF0
IHNob3VsZCBiZSB0aGUgZGVmYXVsdCBiZWhhdmlvciBvZiBzZWN1cml0eV9zZ3hfbXByb3QoKSBm
b3IgZXhpc3Rpbmcvbm9uLVNHWC1hd2FyZSBMU00gbW9kdWxlcy9wb2xpY2llcz8gSSdkIHNheSBh
IHJlYXNvbmFibGUgZGVmYXVsdCBpcyB0byBhbGxvdyBSLCBSVyBhbmQgUlgsIGJ1dCBub3QgYW55
dGhpbmcgZWxzZS4gSXQnZCBzdWZmaWNlIHRvIGdldCByaWQgb2YgRVhFQ01FTS9FWEVDTU9EIHJl
cXVpcmVtZW50cyBvbiBlbmNsYXZlIGFwcGxpY2F0aW9ucy4gRm9yIFNHWDEsIEVQQ00gcGVybWlz
c2lvbnMgYXJlIGltbXV0YWJsZSBzbyBpdCByZWFsbHkgZG9lc24ndCBtYXR0ZXIgd2hhdCBzZWN1
cml0eV9zZ3hfbXByb3QoKSBkb2VzLiBGb3IgU0dYMiBhbmQgYmV5b25kLCB0aGVyZSdzIHN0aWxs
IHRpbWUgYW5kIG5ldyBTR1gtYXdhcmUgTFNNIG1vZHVsZXMvcG9saWNpZXMgd2lsbCBwcm9iYWJs
eSBoYXZlIGVtZXJnZWQgYnkgdGhlbi4NCg0KLUNlZHJpYw0K
