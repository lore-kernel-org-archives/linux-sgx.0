Return-Path: <SRS0=unfi=R7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FE2C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Mar 2019 23:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0010D2173C
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Mar 2019 23:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbfC1XTb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Mar 2019 19:19:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:45640 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbfC1XTb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 Mar 2019 19:19:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Mar 2019 16:19:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,282,1549958400"; 
   d="scan'208";a="286842287"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga004.jf.intel.com with ESMTP; 28 Mar 2019 16:19:30 -0700
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 28 Mar 2019 16:19:30 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.82]) with mapi id 14.03.0415.000;
 Thu, 28 Mar 2019 16:19:28 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Topic: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fwgACBcQD//5sEUIADt/WAgADIIJCAAMRtgP//souwgAM2LoCAAGNgAP//0r3AACmYkYAANjyeQAAy5DgAAAcQZfA=
Date:   Thu, 28 Mar 2019 23:19:25 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E8617BF@ORSMSX116.amr.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
 <20190322215903.GE12666@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
 <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com>
 <20190325180349.GF31069@linux.intel.com>
 <CALCETrXqb3CHefN-RLudC61jwdbLFS8cXuS4V5OJ6HTuf_arYw@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85FABF@ORSMSX116.amr.corp.intel.com>
 <CALCETrVcR_etAHSVZxvCz7CcPnF4ajpcWiRCtFrOckVWVJByHA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E860C69@ORSMSX116.amr.corp.intel.com>
 <CALCETrUUv3WSX7uL22DnWg8FOJqVyB=tknxbGDWb9wpx7zY2CQ@mail.gmail.com>
In-Reply-To: <CALCETrUUv3WSX7uL22DnWg8FOJqVyB=tknxbGDWb9wpx7zY2CQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZmY5MTU2MGUtYzAzYi00OGI2LWJhYTItODM1YTIxMjIxMmQwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRkJmZGdZdHg2eUdWSjVcL0FMZWpQYkg1dlhzOE1VZGpYSVRrZytWUzRMaGRIVnJNTnNneFUzUW9DRjJsRWxTbGMifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBJdCdzIGNlcnRhaW5seSBtYWtpbmcgcHJvZ3Jlc3MuICBJIGxpa2UgdGhlIGZhY3QgdGhhdCB0
aGUgY2FsbGJhY2sgaXMNCj4gbm93IHVuY29uZGl0aW9uYWwgKGlmIG5vbi1OVUxMKSByYXRoZXIg
dGhhbiBiZWluZyB1c2VkIGp1c3QgaW4gY2FzZSBvZg0KPiBjZXJ0YWluIGV4aXQgdHlwZXMuICBC
dXQsIGlmIHdlIGdvIGRvd24gdGhpcyByb3V0ZSwgbGV0J3MgbmFtZSBhbmQNCj4gZG9jdW1lbnQg
aXQgYXBwcm9wcmlhdGVseSAtLSBqdXN0IGNhbGwgdGhlIGZ1bmN0aW9uICJjYWxsYmFjayIgYW5k
DQo+IGRvY3VtZW50IGl0IGFzIGEgZnVuY3Rpb24gdGhhdCBpcyBjYWxsZWQganVzdCBiZWZvcmUN
Cj4gX192ZHNvX3NneF9lbnRlcl9lbmNsYXZlIHJldHVybnMsIHRvIGJlIHVzZWQgaWYgc3VwcG9y
dCBmb3IgbGVnYWN5DQo+IGVuY2xhdmVzIHRoYXQgcHVzaCBkYXRhIG9udG8gdGhlIHVudHJ1c3Rl
ZCBzdGFjayBpcyBuZWVkZWQuICBXZSBzaG91bGQNCj4gZnVydGhlciBkb2N1bWVudCB0aGF0IGl0
J3Mgc2FmZSB0byBsb25nam1wIG91dCBvZiBpdC4NCj4gDQo+IEFsc28sIHRoZSB0ZXN0cyBpbiB0
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy94ODYvdW53aW5kX3Zkc28uYyBzaG91bGQgYmUNCj4gYXVn
bWVudGVkIHRvIHRlc3QgdGhpcyBjb2RlLg0KPiANCj4gRmluYWxseSwgd2h5IGRvZXMgdGhlIHZE
U08gY29kZSBib3RoZXIgY2hlY2tpbmcgd2hldGhlciB0aGUgbGVhZiBpcw0KPiB2YWxpZD8NCg0K
SSBjYW4gZG9jdW1lbnQgaXQuIEknbGwgbG9vayBpbnRvIHVud2luZF92ZHNvLmMgdG8gc2VlIHdo
YXQga2luZCBvZiBzZWxmdGVzdHMgd2lsbCBtYWtlIHNlbnNlIGhlcmUuIEFuZCBJJ2xsIHNlbmQg
b3V0IGEgUkZDIHBhdGNoIHdpdGggZXZlcnl0aGluZyBpbmNsdWRlZC4gT3Igd291bGQgeW91IHBy
ZWZlciB0byBoYXZlIG15IGNoYW5nZXMgaW50ZWdyYXRlZCBpbnRvIEphcmtrbydzIHBhdGNoIHYy
MD8NCg0KRGlmZmVyZW50IEVOQ0xVIGxlYWYgaGFzIGRpZmZlcmVudCBwYXJhbWV0ZXJzLiBUaGlz
IHZEU08gQVBJIGtub3dzIGhvdyB0byBsb2FkIHVwIHBhcmFtZXRlcnMgb25seSBmb3IgRUVOVEVS
IGFuZCBFUkVTVU1FIHNvIGl0IGVycnMgb24gYWxsIG90aGVyIHBvc2l0aXZlIHZhbHVlcy4gMCBh
bmQgbmVnYXRpdmUgdmFsdWVzIGFyZSBpbnRlcnByZXRlZCBhcyByZXR1cm4gY29kZXMuIA0K
