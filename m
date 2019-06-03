Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C889C04AB5
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 18:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6839D218BC
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 18:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfFCSDD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 14:03:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:62804 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbfFCSDC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 14:03:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 11:03:00 -0700
X-ExtLoop1: 1
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga001.jf.intel.com with ESMTP; 03 Jun 2019 11:03:00 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 3 Jun 2019 11:02:59 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX161.amr.corp.intel.com ([169.254.4.187]) with mapi id 14.03.0415.000;
 Mon, 3 Jun 2019 11:03:00 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Thread-Topic: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Thread-Index: AQHVGAkeu//pWDttTk+JsIicrUDwLaaG/FIQgAOxr4D//4xvIA==
Date:   Mon, 3 Jun 2019 18:02:59 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654ECFEE@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EC5FD@ORSMSX116.amr.corp.intel.com>
 <e5e1dc77-eb56-bdab-8164-602ea544ea6e@tycho.nsa.gov>
In-Reply-To: <e5e1dc77-eb56-bdab-8164-602ea544ea6e@tycho.nsa.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzRkYzI0ZmYtOWRhYS00NWE0LWEwMDQtYjA5Y2FiODIzYzhmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVDJBbGtVa1orakFQSnZkMlgxOXlZaFFSa3ZuTjVQWHRQb0d1V0dIUFEwMkdxZnQ3bjFmU2pZWDdLTmZtWitqZiJ9
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
Cj4gU2VudDogTW9uZGF5LCBKdW5lIDAzLCAyMDE5IDEwOjQ3IEFNDQo+IA0KPiBPbiA2LzIvMTkg
MzoyOSBBTSwgWGluZywgQ2VkcmljIHdyb3RlOg0KPiA+IEhpIFNlYW4sDQo+ID4NCj4gPj4gRnJv
bTogQ2hyaXN0b3BoZXJzb24sIFNlYW4gSg0KPiA+PiBTZW50OiBGcmlkYXksIE1heSAzMSwgMjAx
OSA0OjMyIFBNDQo+ID4+DQo+ID4+IFRoaXMgc2VyaWVzIGlzIHRoZSByZXN1bHQgb2YgYSByYXRo
ZXIgYWJzdXJkIGFtb3VudCBvZiBkaXNjdXNzaW9uDQo+ID4+IG92ZXIgaG93IHRvIGdldCBTR1gg
dG8gcGxheSBuaWNlIHdpdGggTFNNIHBvbGljaWVzLCB3aXRob3V0IGhhdmluZyB0bw0KPiA+PiBy
ZXNvcnQgdG8gZXZpbCBzaGVuYW5pZ2FucyBvciBwdXQgdW5kdWUgYnVyZGVuIG9uIHVzZXJzcGFj
ZS4gIFRoZQ0KPiA+PiBkaXNjdXNzaW9uIGRlZmluaXRlbHkgd2FuZGVyZWQgaW50byBjb21wbGV0
ZWx5IGluc2FuZSB0ZXJyaXRvcnkgYXQNCj4gdGltZXMsIGJ1dCBJIHRoaW5rL2hvcGUgd2UgZW5k
ZWQgdXAgd2l0aCBzb21ldGhpbmcgcmVhc29uYWJsZS4NCj4gPj4NCj4gPj4gVGhlIGJhc2ljIGdp
c3Qgb2YgdGhlIGFwcHJvYWNoIGlzIHRvIHJlcXVpcmUgdXNlcnNwYWNlIHRvIGRlY2xhcmUNCj4g
Pj4gd2hhdCBwcm90ZWN0aW9ucyBhcmUgbWF4aW1hbGx5IGFsbG93ZWQgZm9yIGFueSBnaXZlbiBw
YWdlLCBlLmcuIGFkZCBhDQo+ID4+IGZsYWdzIGZpZWxkIGZvciBsb2FkaW5nIGVuY2xhdmUgcGFn
ZXMgdGhhdCB0YWtlcw0KPiA+PiBBTExPV197UkVBRCxXUklURSxFWEVDfS4gIExTTXMgY2FuIHRo
ZW4gYWRqdXN0IHRoZSBhbGxvd2VkDQo+ID4+IHByb3RlY3Rpb25zLCBlLmcuIGNsZWFyIEFMTE9X
X0VYRUMgdG8gcHJldmVudCBldmVyIG1hcHBpbmcgdGhlIHBhZ2UNCj4gd2l0aCBQUk9UX0VYRUMu
ICBTR1ggZW5mb3JjZXMgdGhlIGFsbG93ZWQgcGVybXMgdmlhIGEgbmV3IG1wcm90ZWN0KCkNCj4g
dm1fb3BzIGhvb2ssIGUuZy4gbGlrZSByZWd1bGFyIG1wcm90ZWN0KCkgdXNlcyBNQVlfe1JFQUQs
V1JJVEUsRVhFQ30uDQo+ID4+DQo+ID4+IEFMTE9XX0VYRUMgaXMgdXNlZCB0byBkZW55IGhpbmdz
IGxpa2UgbG9hZGluZyBhbiBlbmNsYXZlIGZyb20gYQ0KPiA+PiBub2V4ZWMgZmlsZSBzeXN0ZW0g
b3IgZnJvbSBhIGZpbGUgd2l0aG91dCBFWEVDVVRFIHBlcm1pc3Npb25zLCBlLmcuDQo+ID4+IHdp
dGhvdXQgdGhlIEFMTE9XX0VYRUMgY29uY2VwdCwgb24gU0dYMiBoYXJkd2FyZSAocmVnYXJkbGVz
cyBvZg0KPiA+PiBrZXJuZWwgc3VwcG9ydCkgdXNlcnNwYWNlIGNvdWxkIEVBREQgZnJvbSBhIG5v
ZXhlYyBmaWxlIHVzaW5nIHJlYWQtDQo+IG9ubHkgcGVybWlzc2lvbnMsIGFuZCBsYXRlciB1c2Ug
bXByb3RlY3QoKSBhbmQgRU5DTFVbRU1PRFBFXSB0byBnYWluDQo+IGV4ZWN1dGUgcGVybWlzc2lv
bnMuDQo+ID4+DQo+ID4+IEFMTE9XX1dSSVRFIGlzIHVzZWQgaW4gY29uanVjdGlvbiB3aXRoIEFM
TE9XX0VYRUMgdG8gZW5mb3JjZQ0KPiBTRUxpbnV4J3MgRVhFQ01PRCAob3IgRVhFQ01FTSkuDQo+
ID4+DQo+ID4+IFRoaXMgaXMgdmVyeSBtdWNoIGFuIFJGQyBzZXJpZXMuICBJdCdzIG9ubHkgY29t
cGlsZSB0ZXN0ZWQsIGxpa2VseQ0KPiA+PiBoYXMgb2J2aW91cyBidWdzLCB0aGUgU0VMaW51eCBw
YXRjaCBjb3VsZCBiZSBjb21wbGV0ZWx5IGhhcmVicmFpbmVkLA0KPiBldGMuLi4NCj4gPj4gTXkg
Z29hbCBhdCB0aGlzIHBvaW50IGlzIHRvIGdldCBmZWVkYmFjayBhdCBhIG1hY3JvIGxldmVsLCBl
LmcuIGlzDQo+ID4+IHRoZSBjb3JlIGNvbmNlcHQgdmlhYmxlL2FjY2VwdGFibGUsIGFyZSB0aGVy
ZSBvYmplY3Rpb24gdG8gaG9va2luZw0KPiBtcHJvdGVjdCgpLCBldGMuLi4NCj4gPj4NCj4gPj4g
QW5keSBhbmQgQ2VkcmljLCBob3BlZnVsbHkgdGhpcyBhbGlnbnMgd2l0aCB5b3VyIGdlbmVyYWwg
ZXhwZWN0YXRpb25zDQo+ID4+IGJhc2VkIG9uIG91ciBsYXN0IGRpc2N1c3Npb24uDQo+ID4NCj4g
PiBJIGNvdWxkbid0IHVuZGVyc3RhbmQgdGhlIHJlYWwgaW50ZW50aW9ucyBvZiBBTExPV18qIGZs
YWdzIHVudGlsIEkgc2F3DQo+ID4gdGhlbSBpbiBjb2RlLiBJIGhhdmUgdG8gc2F5IEMgaXMgbW9y
ZSBleHByZXNzaXZlIHRoYW4gRW5nbGlzaCBpbiB0aGF0DQo+ID4gcmVnYXJkIDopDQo+ID4NCj4g
PiBHZW5lcmFsbHkgSSBhZ3JlZSB3aXRoIHlvdXIgZGlyZWN0aW9uIGJ1dCB0aGluayBBTExPV18q
IGZsYWdzIGFyZQ0KPiBjb21wbGV0ZWx5IGludGVybmFsIHRvIExTTSBiZWNhdXNlIHRoZXkgY2Fu
IGJlIGJvdGggcHJvZHVjZWQgYW5kDQo+IGNvbnN1bWVkIGluc2lkZSBhbiBMU00gbW9kdWxlLiBT
byBzcGlsbGluZyB0aGVtIGludG8gU0dYIGRyaXZlciBhbmQgYWxzbw0KPiB1c2VyIG1vZGUgY29k
ZSBtYWtlcyB0aGUgc29sdXRpb24gdWdseSBhbmQgaW4gc29tZSBjYXNlcyBpbXByYWN0aWNhbA0K
PiBiZWNhdXNlIG5vdCBldmVyeSBlbmNsYXZlIGhvc3QgcHJvY2VzcyBoYXMgYSBwcmlvcmkga25v
d2xlZGdlIG9uIHdoZXRoZXINCj4gb3Igbm90IGFuIGVuY2xhdmUgcGFnZSB3b3VsZCBiZSBFTU9E
UEUnZCBhdCBydW50aW1lLg0KPiA+DQo+ID4gVGhlb3JldGljYWxseSBzcGVha2luZywgd2hhdCB5
b3UgcmVhbGx5IG5lZWQgaXMgYSBwZXIgcGFnZSBmbGFnIChsZXQncw0KPiBuYW1lIGl0IFdSSVRU
RU4/KSBpbmRpY2F0aW5nIHdoZXRoZXIgYSBwYWdlIGhhcyBldmVyIGJlZW4gd3JpdHRlbiB0byAo
b3INCj4gbW9yZSBwcmVjaXNlbHksIGdyYW50ZWQgUFJPVF9XUklURSksIHdoaWNoIHdpbGwgYmUg
dXNlZCB0byBkZWNpZGUNCj4gd2hldGhlciB0byBncmFudCBQUk9UX0VYRUMgd2hlbiByZXF1ZXN0
ZWQgaW4gZnV0dXJlLiBHaXZlbiB0aGUgZmFjdCB0aGF0DQo+IGFsbCBtcHJvdGVjdCgpIGdvZXMg
dGhyb3VnaCBMU00gYW5kIG1tYXAoKSBpcyBsaW1pdGVkIHRvIFBST1RfTk9ORSwgaXQncw0KPiBl
YXN5IGZvciBMU00gdG8gY2FwdHVyZSB0aGF0IGZsYWcgYnkgaXRzZWxmIGluc3RlYWQgb2YgYXNr
aW5nIHVzZXIgbW9kZQ0KPiBjb2RlIHRvIHByb3ZpZGUgaXQuDQo+ID4NCj4gPiBUaGF0IHNhaWQs
IGhlcmUgaXMgdGhlIHN1bW1hcnkgb2Ygd2hhdCBJIHRoaW5rIGlzIGEgYmV0dGVyIGFwcHJvYWNo
Lg0KPiA+ICogSW4gaG9vayBzZWN1cml0eV9maWxlX2FsbG9jKCksIGlmIEBmaWxlIGlzIGFuIGVu
Y2xhdmUsIGFsbG9jYXRlIHNvbWUNCj4gZGF0YSBzdHJ1Y3R1cmUgdG8gc3RvcmUgZm9yIGV2ZXJ5
IHBhZ2UsIHRoZSBXUklUVEVOIGZsYWcgYXMgZGVzY3JpYmVkDQo+IGFib3ZlLiBXUklUVEVOIGlz
IGNsZWFyZWQgaW5pdGlhbGx5IGZvciBhbGwgcGFnZXMuDQo+ID4gICAgT3BlbjogR2l2ZW4gYSBm
aWxlIG9mIHR5cGUgc3RydWN0IGZpbGUgKiwgaG93IHRvIHRlbGwgaWYgaXQgaXMgYW4NCj4gZW5j
bGF2ZSAoaS5lLiAvZGV2L3NneC9lbmNsYXZlKT8NCj4gPiAqIEluIGhvb2sgc2VjdXJpdHlfbW1h
cF9maWxlKCksIGlmIEBmaWxlIGlzIGFuIGVuY2xhdmUsIG1ha2Ugc3VyZQ0KPiBAcHJvdCBjYW4g
b25seSBiZSBQUk9UX05PTkUuIFRoaXMgaXMgdG8gZm9yY2UgYWxsIHByb3RlY3Rpb24gY2hhbmdl
cyB0bw0KPiBnbyB0aHJvdWdoIHNlY3VyaXR5X2ZpbGVfbXByb3RlY3QoKS4NCj4gPiAqIEluIHRo
ZSBuZXdseSBpbnRyb2R1Y2VkIGhvb2sgc2VjdXJpdHlfZW5jbGF2ZV9sb2FkKCksIHNldCBXUklU
VEVODQo+IGZvciBwYWdlcyB0aGF0IGFyZSByZXF1ZXN0ZWQgUFJPVF9XUklURS4NCj4gPiAqIElu
IGhvb2sgc2VjdXJpdHlfZmlsZV9tcHJvdGVjdCgpLCBpZiBAdm1hLT52bV9maWxlIGlzIGFuIGVu
Y2xhdmUsDQo+ID4gbG9vayB1cCBhbmQgdXNlIFdSSVRURU4gZmxhZ3MgZm9yIGFsbCBwYWdlcyB3
aXRoaW4gQHZtYSwgYWxvbmcgd2l0aA0KPiA+IG90aGVyIGdsb2JhbCBmbGFncyAoZS5nLiBQUk9D
RVNTX19FWEVDTUVNL0ZJTEVfX0VYRUNNT0QgaW4gdGhlIGNhc2Ugb2YNCj4gPiBTRUxpbnV4KSB0
byBkZWNpZGUgb24NCj4gYWxsb3dpbmcvcmVqZWN0aW5nIEBwcm90Lg0KPiANCj4gQXQgdGhpcyBw
b2ludCB3ZSBoYXZlIG5vIGtub3dsZWRnZSBvZiB0aGUgc291cmNlIHZtYS9maWxlLCByaWdodD8g
IFNvDQo+IHdoYXQgZG8gd2UgY2hlY2sgRklMRV9fRVhFQ1VURSBhbmQvb3IgRklMRV9fRVhFQ01P
RCBhZ2FpbnN0Pw0KPiB2bWEtPnZtX2ZpbGUgYXQgdGhpcyBwb2ludCBpcyAvZGV2L3NneC9lbmNs
YXZlLCByaWdodD8NCg0KTXkgYXBvbG9neSB0byB0aGUgY29uZnVzaW9ucyBoZXJlLg0KDQpZZXMs
IHZtYS0+dm1fZmlsZSBpcyBhbHdheXMgL2Rldi9zZ3gvZW5jbGF2ZSwgYnV0IGVhY2ggb3Blbigi
L2Rldi9zZ3gvZW5jbGF2ZSIpIHJldHVybnMgYSAqbmV3KiBmaWxlIHN0cnVjdCAobGV0J3MgZGVu
b3RlIGl0IGFzIEBlbmNsYXZlX2ZkKSB0aGF0IHVuaXF1ZWx5IGlkZW50aWZpZXMgb25lIGVuY2xh
dmUgaW5zdGFuY2UsIGFuZCB0aGUgZXhwZWN0YXRpb24gaXMgdGhhdCBAZW5jbGF2ZV9mZC0+Zl9z
ZWN1cml0eSB3b3VsZCBiZSB1c2VkIGJ5IExTTSB0byBzdG9yZSBlbmNsYXZlIHNwZWNpZmljIGlu
Zm9ybWF0aW9uLCBpbmNsdWRpbmcgQUxMT1dfKiBmbGFncyBhbmQgd2hhdGV2ZXIgZGVlbWVkIGFw
cHJvcHJpYXRlIGJ5IGFuIExTTSBtb2R1bGUuDQoNCkluIHRoZSBjYXNlIG9mIFNFTGludXgsIGFu
ZCBpZiB0aGUgY2hvaWNlIGlzIHRvIHVzZSBGSUxFX19FWEVDTU9EIG9mIC5zaWdzdHJ1Y3QgZmls
ZSB0byBhdXRob3JpemUgUlctPlJYIGF0IHJ1bnRpbWUsIHRoZW4gU0VMaW51eCBjb3VsZCBjYWNo
ZSB0aGF0IGZsYWcgaW4gQGVuY2xhdmVfZmQtPmZfc2VjdXJpdHkgdXBvbiBzZWN1cml0eV9lbmNs
YXZlX2luaXQoKS4NCg==
