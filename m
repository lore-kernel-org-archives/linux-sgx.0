Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E53AC004E6
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 20:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56BDC20828
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 20:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF0UTH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 16:19:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:36071 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbfF0UTG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jun 2019 16:19:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 13:19:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,424,1557212400"; 
   d="scan'208";a="170536127"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jun 2019 13:19:05 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX109.amr.corp.intel.com ([169.254.11.153]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 13:19:05 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Thread-Topic: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Thread-Index: AQHVJu2+BRxznwhIFUiQ7nhB61/EnaammGEAgAbDtgCAApYG8A==
Date:   Thu, 27 Jun 2019 20:19:04 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F6551B824@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
In-Reply-To: <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzg3MmMzYWEtMzE2MC00NDVkLTkyZTYtZGI3MTJmOWI3MGE3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSmF1c2dmMXd0THV3NVBGVmRuN1JQMWpFM1Z3cjZhSjhubElTaVVkMGl4WFFcLzZ1VmxlakhjWENYYXQwWDNBSVEifQ==
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
Cj4gU2VudDogVHVlc2RheSwgSnVuZSAyNSwgMjAxOSAyOjEwIFBNDQo+IA0KPiBPbiA2LzIxLzE5
IDU6MjIgUE0sIFhpbmcsIENlZHJpYyB3cm90ZToNCj4gPj4gRnJvbTogQ2hyaXN0b3BoZXJzb24s
IFNlYW4gSg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIEp1bmUgMTksIDIwMTkgMzoyNCBQTQ0KPiA+
Pg0KPiA+PiBJbnRlbmRlZCB1c2Ugb2YgZWFjaCBwZXJtaXNzaW9uOg0KPiA+Pg0KPiA+PiAgICAt
IFNHWF9FWEVDRElSVFk6IGR5bmFtaWNhbGx5IGxvYWQgY29kZSB3aXRoaW4gdGhlIGVuY2xhdmUg
aXRzZWxmDQo+ID4+ICAgIC0gU0dYX0VYRUNVTk1SOiBsb2FkIHVubWVhc3VyZWQgY29kZSBpbnRv
IHRoZSBlbmNsYXZlLCBlLmcuDQo+ID4+IEdyYXBoZW5lDQo+ID4NCj4gPiBXaHkgZG9lcyBpdCBt
YXR0ZXIgd2hldGhlciBhIGNvZGUgcGFnZSBpcyBtZWFzdXJlZCBvciBub3Q/DQo+IA0KPiBJdCB3
b24ndCBiZSBpbmNvcnBvcmF0ZWQgaW50byBhbiBhdHRlc3RhdGlvbj8NCg0KWWVzLCBpdCB3aWxs
LiBBbmQgYmVjYXVzZSBvZiB0aGF0LCBJIGRvbid0IHRoaW5rIExTTSBzaG91bGQgY2FyZS4NCg0K
PiANCj4gPg0KPiA+PiAgICAtIFNHWF9FWEVDQU5PTjogbG9hZCBjb2RlIGZyb20gYW5vbnltb3Vz
IG1lbW9yeSAobGlrZWx5IEdyYXBoZW5lKQ0KPiA+DQo+ID4gR3JhcGhlbmUgZG9lc24ndCBsb2Fk
IGNvZGUgZnJvbSBhbm9ueW1vdXMgbWVtb3J5LiBJdCBsb2FkcyBjb2RlDQo+IGR5bmFtaWNhbGx5
IHRob3VnaCwgYXMgaW4gU0dYX0VYRUNESVJUWSBjYXNlLg0KPiANCj4gU28gZG8gd2UgZXhwZWN0
IEVYRUNBTk9OIHRvIG5ldmVyIGJlIHRyaWdnZXJlZCBhdCBhbGw/DQoNCkkgZG9uJ3QgdGhpbmsg
c28uIEFuZCBmcm9tIHNlY3VyaXR5IHBlcnNwZWN0aXZlLCB0aGUgZGVjaXNpb24gSSB0aGluayBz
aGFsbCBiYXNlIG9uIHdoZXRoZXIgdGhlIHNvdXJjZSBwYWdlcyBhcmUgKGFsbG93ZWQgdG8gYmUg
bWFkZSkgZXhlY3V0YWJsZS4gDQoNCj4gDQo+ID4NCj4gPj4gICAgLSBTR1hfRVhFQ1VURTogbG9h
ZCBhbiBlbmNsYXZlIGZyb20gYSBmaWxlLCBpLmUuIG5vcm1hbCBiZWhhdmlvcg0KPiA+DQo+ID4g
V2h5IGlzIFNHWF9FWEVDVVRFIG5lZWRlZCBmcm9tIHNlY3VyaXR5IHBlcnNwZWN0aXZlPyBPciB3
aHkgaXNuJ3QNCj4gRklMRV9fRVhFQ1VURSBzdWZmaWNpZW50Pw0KPiANCj4gU3BsaXR0aW5nIHRo
ZSBTR1ggcGVybWlzc2lvbnMgZnJvbSB0aGUgcmVndWxhciBvbmVzIGFsbG93cyBkaXN0aW5jdGlv
bnMNCj4gdG8gYmUgbWFkZSBiZXR3ZWVuIHdoYXQgY2FuIGJlIGV4ZWN1dGVkIGluIHRoZSBob3N0
IHByb2Nlc3MgYW5kIHdoYXQgY2FuDQo+IGJlIGV4ZWN1dGVkIGluIHRoZSBlbmNsYXZlLiAgVGhl
IGhvc3QgcHJvY2VzcyBtYXkgYmUgYWxsb3dlZA0KPiBGSUxFX19FWEVDVVRFIHRvIG51bWVyb3Vz
IGZpbGVzIHRoYXQgZG8gbm90IGNvbnRhaW4gYW55IGNvZGUgZXZlcg0KPiBpbnRlbmRlZCB0byBi
ZSBleGVjdXRlZCB3aXRoaW4gdGhlIGVuY2xhdmUuDQoNCkdpdmVuIGFuIGVuY2xhdmUgYW5kIGl0
cyBob3N0IHByb2Nlc3MsIGFueSBleGVjdXRhYmxlIGNvbnRlbnRzIGNvdWxkIGJlIGFsbG93ZWQg
aW4NCjEpIE5laXRoZXIgdGhlIGVuY2xhdmUgbm9yIHRoZSBob3N0DQoyKSBFbmNsYXZlIG9ubHkN
CjMpIEhvc3Qgb25seQ0KNCkgQm90aCB0aGUgZW5jbGF2ZSBhbmQgdGhlIGhvc3QNCg0KR2l2ZW4g
dGhlIGZhY3QgdGhhdCBlbmNsYXZlIGNhbiBhY2Nlc3MgaG9zdCdzIG1lbW9yeSwgaWYgYSBwaWVj
ZSBvZiBjb2RlIGlzIE5PVCBhbGxvd2VkIGluIHRoZSBob3N0LCB0aGVuIGl0IHNob3VsZG4ndCBi
ZSBhbGxvd2VkIGluIGVuY2xhdmUgZWl0aGVyLiBTbyAjMiBzaGFsbCBuZXZlciBoYXBwZW4uDQoN
CkFuIGVuY2xhdmUgZGljdGF0ZXMvZW5mb3JjZXMgaXRzIG93biBjb250ZW50cyBjcnlwdG9ncmFw
aGljYWxseSwgc28gaXQncyB1bm5lY2Vzc2FyeSB0byBlbmZvcmNlICMzIGJ5IExTTSBJTU8uDQoN
ClRoZW4gIzEgYW5kICM0IGFyZSB0aGUgb25seSAyIGNhc2VzIHRvIGJlIHN1cHBvcnRlZCAtIGEg
c2luZ2xlIEZJTEVfX0VYRUNVVEUgaXMgc3VmZmljaWVudC4NCg0KSSdtIG5vdCBvYmplY3Rpbmcg
dG8gbmV3IHBlcm1pc3Npb25zIHRvIG1ha2UgdGhpbmdzIG1vcmUgZXhwbGljaXQsIGJ1dCB0aGF0
J2QgcmVxdWlyZSB1cGRhdGVzIHRvIHVzZXIgbW9kZSB0b29scy4gSSB0aGluayBpdCBqdXN0IGVh
c2llciB0byByZXVzZSBleGlzdGluZyBwZXJtaXNzaW9ucy4NCg0K
