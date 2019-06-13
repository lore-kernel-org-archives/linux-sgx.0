Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F5DC31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 23:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AB7E2147A
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 23:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfFMXD0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 19:03:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:63438 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfFMXD0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 19:03:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 16:03:25 -0700
X-ExtLoop1: 1
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jun 2019 16:03:24 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX110.amr.corp.intel.com ([169.254.10.60]) with mapi id 14.03.0415.000;
 Thu, 13 Jun 2019 16:03:24 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "pmccallum@redhat.com" <pmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Thread-Topic: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks
 in SELinux
Thread-Index: AQHVH1ilvNGS2ZisK0eWTCWidam/YaaW7RmAgACMWICAAtC5gP//6xkw
Date:   Thu, 13 Jun 2019 23:03:24 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65503EDD@ORSMSX116.amr.corp.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <20190611220243.GB3416@linux.intel.com>
 <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov>
In-Reply-To: <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzIwNzkwOGItNTg5MS00YjVhLThkNGItNzhhYTA5OTBkNzRhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQVVNblBBT0NWcVVSWWNPb3ViRDRrTE5EbDVtSk1tRGRNRWRzTkZRYmRmajVoc01KZUJaak5BQm5tT0dLNjhwQyJ9
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

PiBGcm9tOiBTdGVwaGVuIFNtYWxsZXkgW21haWx0bzpzZHNAdHljaG8ubnNhLmdvdl0NCj4gU2Vu
dDogVGh1cnNkYXksIEp1bmUgMTMsIDIwMTkgMTA6MDIgQU0NCj4gDQo+IE9uIDYvMTEvMTkgNjow
MiBQTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiBPbiBUdWUsIEp1biAxMSwgMjAx
OSBhdCAwOTo0MDoyNUFNIC0wNDAwLCBTdGVwaGVuIFNtYWxsZXkgd3JvdGU6DQo+ID4+IEkgaGF2
ZW4ndCBsb29rZWQgYXQgdGhpcyBjb2RlIGNsb3NlbHksIGJ1dCBpdCBmZWVscyBsaWtlIGEgbG90
IG9mDQo+ID4+IFNHWC1zcGVjaWZpYyBsb2dpYyBlbWJlZGRlZCBpbnRvIFNFTGludXggdGhhdCB3
aWxsIGhhdmUgdG8gYmUNCj4gPj4gcmVwZWF0ZWQgb3IgcmV1c2VkIGZvciBldmVyeSBzZWN1cml0
eSBtb2R1bGUuICBEb2VzIFNHWCBub3QgdHJhY2sNCj4gdGhpcyBzdGF0ZSBpdHNlbGY/DQo+ID4N
Cj4gPiBTR1ggZG9lcyB0cmFjayBlcXVpdmFsZW50IHN0YXRlLg0KPiA+DQo+ID4gVGhlcmUgYXJl
IHRocmVlIHByb3Bvc2FscyBvbiB0aGUgdGFibGUgKEkgdGhpbmspOg0KPiA+DQo+ID4gICAgMS4g
UmVxdWlyZSB1c2Vyc3BhY2UgdG8gZXhwbGljaXRseSBzcGVjaWZpY3kgKG1heGltYWwpIGVuY2xh
dmUgcGFnZQ0KPiA+ICAgICAgIHBlcm1pc3Npb25zIGF0IGJ1aWxkIHRpbWUuICBUaGUgZW5jbGF2
ZSBwYWdlIHBlcm1pc3Npb25zIGFyZQ0KPiBwcm92aWRlZA0KPiA+ICAgICAgIHRvLCBhbmQgY2hl
Y2tlZCBieSwgTFNNcyBhdCBlbmNsYXZlIGJ1aWxkIHRpbWUuDQo+ID4NCj4gPiAgICAgICBQcm9z
OiBMb3ctY29tcGxleGl0eSBrZXJuZWwgaW1wbGVtZW50YXRpb24sIHN0cmFpZ2h0Zm9yd2FyZA0K
PiBhdWRpdGluZw0KPiA+ICAgICAgIENvbnM6IFN1bGxpZXMgdGhlIFNHWCBVQVBJIHRvIHNvbWUg
ZXh0ZW50LCBtYXkgaW5jcmVhc2UNCj4gY29tcGxleGl0eSBvZg0KPiA+ICAgICAgICAgICAgIFNH
WDIgZW5jbGF2ZSBsb2FkZXJzLg0KPiA+DQo+ID4gICAgMi4gUHJlLWNoZWNrIExTTSBwZXJtaXNz
aW9ucyBhbmQgZHluYW1pY2FsbHkgdHJhY2sgbWFwcGluZ3MgdG8NCj4gZW5jbGF2ZQ0KPiA+ICAg
ICAgIHBhZ2VzLCBlLmcuIGFkZCBhbiBTR1ggbXByb3RlY3QoKSBob29rIHRvIHJlc3RyaWN0IFct
PlggYW5kIFdYDQo+ID4gICAgICAgYmFzZWQgb24gdGhlIHByZS1jaGVja2VkIHBlcm1pc3Npb25z
Lg0KPiA+DQo+ID4gICAgICAgUHJvczogRG9lcyBub3QgaW1wYWN0IFNHWCBVQVBJLCBtZWRpdW0g
a2VybmVsIGNvbXBsZXhpdHkNCj4gPiAgICAgICBDb25zOiBBdWRpdGluZyBpcyBjb21wbGV4L3dl
aXJkLCByZXF1aXJlcyB0YWtpbmcgZW5jbGF2ZS0NCj4gc3BlY2lmaWMNCj4gPiAgICAgICAgICAg
ICBsb2NrIGR1cmluZyBtcHJvdGVjdCgpIHRvIHF1ZXJ5L3VwZGF0ZSB0cmFja2luZy4NCj4gPg0K
PiA+ICAgIDMuIEltcGxlbWVudCBMU00gaG9va3MgaW4gU0dYIHRvIGFsbG93IExTTXMgdG8gdHJh
Y2sgZW5jbGF2ZQ0KPiByZWdpb25zDQo+ID4gICAgICAgZnJvbSBjcmFkbGUgdG8gZ3JhdmUsIGJ1
dCBvdGhlcndpc2UgZGVmZXIgZXZlcnl0aGluZyB0byBMU01zLg0KPiA+DQo+ID4gICAgICAgUHJv
czogRG9lcyBub3QgaW1wYWN0IFNHWCBVQVBJLCBtYXhpbXVtIGZsZXhpYmlsaXR5LCBwcmVjaXNl
DQo+IGF1ZGl0aW5nDQo+ID4gICAgICAgQ29uczogTW9zdCBjb21wbGV4IGFuZCAiaGVhdmllc3Qi
IGtlcm5lbCBpbXBsZW1lbnRhdGlvbiBvZiB0aGUNCj4gdGhyZWUsDQo+ID4gICAgICAgICAgICAg
cHVzaGVzIG1vcmUgU0dYIGRldGFpbHMgaW50byBMU01zLg0KPiA+DQo+ID4gTXkgUkZDIHNlcmll
c1sxXSBpbXBsZW1lbnRzICMxLiAgTXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IEFuZHkNCj4gPiAo
THV0b21pcnNraSkgcHJlZmVycyAjMi4gIENlZHJpYydzIFJGQyBzZXJpZXMgaW1wbGVtZW50cyAj
My4NCj4gPg0KPiA+IFBlcmhhcHMgdGhlIGVhc2llc3Qgd2F5IHRvIG1ha2UgZm9yd2FyZCBwcm9n
cmVzcyBpcyB0byBydWxlIG91dCB0aGUNCj4gPiBvcHRpb25zIHdlIGFic29sdXRlbHkgKmRvbid0
KiB3YW50IGJ5IGZvY3VzaW5nIG9uIHRoZSBwb3RlbnRpYWxseQ0KPiA+IGJsb2NraW5nIGlzc3Vl
IHdpdGggZWFjaCBvcHRpb246DQo+ID4NCj4gPiAgICAjMSAtIFNHWCBVQVBJIGZ1bmtpbmVzcw0K
PiA+DQo+ID4gICAgIzIgLSBBdWRpdGluZyBjb21wbGV4aXR5LCBwb3RlbnRpYWwgZW5jbGF2ZSBs
b2NrIGNvbnRlbnRpb24NCj4gPg0KPiA+ICAgICMzIC0gUHVzaGluZyBTR1ggZGV0YWlscyBpbnRv
IExTTXMgYW5kIGNvbXBsZXhpdHkgb2Yga2VybmVsDQo+ID4gaW1wbGVtZW50YXRpb24NCj4gPg0K
PiA+DQo+ID4gWzFdDQo+ID4gaHR0cHM6Ly9sa21sLmtlcm5lbC5vcmcvci8yMDE5MDYwNjAyMTE0
NS4xMjYwNC0xLXNlYW4uai5jaHJpc3RvcGhlcnNvbg0KPiA+IEBpbnRlbC5jb20NCj4gDQo+IEdp
dmVuIHRoZSBjb21wbGV4aXR5IHRyYWRlb2ZmLCB3aGF0IGlzIHRoZSBjbGVhciBtb3RpdmF0aW5n
IGV4YW1wbGUgZm9yDQo+IHdoeSAjMSBpc24ndCB0aGUgb2J2aW91cyBjaG9pY2U/IFRoYXQgdGhl
IGVuY2xhdmUgbG9hZGVyIGhhcyBubyB3YXkgb2YNCj4ga25vd2luZyBhIHByaW9yaSB3aGV0aGVy
IHRoZSBlbmNsYXZlIHdpbGwgcmVxdWlyZSBXLT5YIG9yIFdYPyAgQnV0DQo+IGFyZW4ndCB3ZSBi
ZXR0ZXIgb2ZmIHJlcXVpcmluZyBlbmNsYXZlcyB0byBiZSBleHBsaWNpdGx5IG1hcmtlZCBhcw0K
PiBuZWVkaW5nIHN1Y2ggc28gdGhhdCB3ZSBjYW4gbWFrZSBhIG1vcmUgaW5mb3JtZWQgZGVjaXNp
b24gYWJvdXQgd2hldGhlcg0KPiB0byBsb2FkIHRoZW0gaW4gdGhlIGZpcnN0IHBsYWNlPw0KDQpB
cmUgeW91IGFza2luZyB0aGlzIHF1ZXN0aW9uIGF0IGEpIHBhZ2UgZ3JhbnVsYXJpdHksIGIpIGZp
bGUgZ3JhbnVsYXJpdHkgb3IgYykgZW5jbGF2ZSAocG90ZW50aWFsbHkgY29tcHJpc2VkIG9mIG11
bHRpcGxlIGV4ZWN1dGFibGUgZmlsZXMpIGdyYW51bGFyaXR5Pw0KDQojYiBpcyB3aGF0IHdlIGhh
dmUgb24gcmVndWxhciBleGVjdXRhYmxlIGZpbGVzIGFuZCBzaGFyZWQgb2JqZWN0cyAoaS5lLiBG
SUxFX19FWEVDTU9EKS4gV2UgYWxsIGtub3cgaG93IHRvIGRvIHRoYXQuDQoNCiNjIGlzIGtpbmQg
b2YgbmV3IGJ1dCBjb3VsZCBiZSBkb25lIHZpYSBzb21lIHByb3h5IGZpbGUgKGUuZy4gc2lnc3Ry
dWN0IGZpbGUpIGhlbmNlIHJlZHVjZWQgdG8gI2IuDQoNCiNhIGlzIHByb2JsZW1hdGljLiBJdCdk
IHJlcXVpcmUgY29tcGlsZXJzL2xpbmtlcnMgdG8gZ2VuZXJhdGUgc3VjaCBpbmZvcm1hdGlvbiwg
YW5kIHByb3BlciBleGVjdXRhYmxlIGltYWdlIGZpbGUgZm9ybWF0IHRvIGNhcnJ5IHRoYXQgaW5m
b3JtYXRpb24sIHRvIGJlIGV2ZW50dWFsbHkgcGlja2VkIHVwIHRoZSBsb2FkZXIuIFNFTGludXgg
ZG9lc24ndCBoYXZlIFBBR0VfX0VYRUNNT0QgSSBndWVzcyBpcyBiZWNhdXNlIGl0IGlzIGdlbmVy
YWxseSBjb25zaWRlcmVkIGltcHJhY3RpY2FsLg0KDQpPcHRpb24gIzEgaG93ZXZlciByZXF1aXJl
cyAjYSBiZWNhdXNlIHRoZSBkcml2ZXIgZG9lc24ndCB0cmFjayB3aGljaCBwYWdlIHdhcyBsb2Fk
ZWQgZnJvbSB3aGljaCBmaWxlLCBvdGhlcndpc2UgaXQgY2FuIG5vIGxvbmdlciBiZSBxdWFsaWZp
ZWQgInNpbXBsZSIuIE9yIHdlIGNvdWxkIGp1c3QgaW1wbGVtZW50ICNjLCB3aGljaCB3aWxsIG1h
a2UgYWxsIG9wdGlvbnMgc2ltcGxlci4gQnV0IEkgZ3Vlc3MgI2IgaXMgc3RpbGwgcHJlZmVycmVk
LCB0byBiZSBhbGlnbmVkIHdpdGggd2hhdCBTRUxpbnV4IGlzIGVuZm9yY2luZyB0b2RheSBvbiBy
ZWd1bGFyIG1lbW9yeSBwYWdlcy4NCg==
