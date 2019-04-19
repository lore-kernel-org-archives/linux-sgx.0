Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B222C10F14
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 03:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6556E21736
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 03:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfDSDGz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 18 Apr 2019 23:06:55 -0400
Received: from mga04.intel.com ([192.55.52.120]:25756 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfDSDGz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 18 Apr 2019 23:06:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Apr 2019 20:06:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,368,1549958400"; 
   d="scan'208";a="163188867"
Received: from pgsmsx103.gar.corp.intel.com ([10.221.44.82])
  by fmsmga004.fm.intel.com with ESMTP; 18 Apr 2019 20:06:51 -0700
Received: from pgsmsx109.gar.corp.intel.com (10.221.44.109) by
 PGSMSX103.gar.corp.intel.com (10.221.44.82) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 19 Apr 2019 11:06:49 +0800
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.40]) by
 PGSMSX109.gar.corp.intel.com ([169.254.14.210]) with mapi id 14.03.0415.000;
 Fri, 19 Apr 2019 11:06:49 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v20 16/28] x86/sgx: Add provisioning
Thread-Topic: [PATCH v20 16/28] x86/sgx: Add provisioning
Thread-Index: AQHU9QorPuxiqm5t3UWkqdBgsZ38LKZCSaAA
Date:   Fri, 19 Apr 2019 03:06:48 +0000
Message-ID: <1555643200.2776.1.camel@intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
         <20190417103938.7762-17-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20190417103938.7762-17-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.60.18]
Content-Type: text/plain; charset="utf-8"
Content-ID: <18CCDFF5DE53F24CB10B113661895E29@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gV2VkLCAyMDE5LTA0LTE3IGF0IDEzOjM5ICswMzAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
DQo+IEluIG9yZGVyIHRvIHByb3ZpZGUgYSBtZWNoYW5pc20gZm9yIGRldmlsZXJpbmcgcHJvdmlz
b25pbmcgcmlnaHRzOg0KPiANCj4gMS4gQWRkIGEgbmV3IGRldmljZSBmaWxlIC9kZXYvc2d4L3By
b3Zpc2lvbiB0aGF0IHdvcmtzIGFzIGEgdG9rZW4gZm9yDQo+ICAgIGFsbG93aW5nIGFuIGVuY2xh
dmUgdG8gaGF2ZSB0aGUgcHJvdmlzaW9uaW5nIHByaXZpbGVnZXMuDQo+IDIuIEFkZCBhIG5ldyBp
b2N0bCBjYWxsZWQgU0dYX0lPQ19FTkNMQVZFX1NFVF9BVFRSSUJVVEUgdGhhdCBhY2NlcHRzIHRo
ZQ0KPiAgICBmb2xsb3dpbmcgZGF0YSBzdHJ1Y3R1cmU6DQo+IA0KPiAgICBzdHJ1Y3Qgc2d4X2Vu
Y2xhdmVfc2V0X2F0dHJpYnV0ZSB7DQo+ICAgICAgICAgICAgX191NjQgYWRkcjsNCj4gICAgICAg
ICAgICBfX3U2NCBhdHRyaWJ1dGVfZmQ7DQo+ICAgIH07DQo+IA0KPiBBIGRhZW1vbiBjb3VsZCBz
aXQgb24gdG9wIG9mIC9kZXYvc2d4L3Byb3Zpc2lvbiBhbmQgc2VuZCBhIGZpbGUNCj4gZGVzY3Jp
cHRvciBvZiB0aGlzIGZpbGUgdG8gYSBwcm9jZXNzIHRoYXQgbmVlZHMgdG8gYmUgYWJsZSB0byBw
cm92aXNpb24NCj4gZW5jbGF2ZXMuDQo+IA0KPiBUaGUgd2F5IHRoaXMgQVBJIGlzIHVzZWQgaXMg
c3RyYWlnaHQtZm9yd2FyZC4gTGV0cyBhc3N1bWUgdGhhdCBkZXZfZmQgaXMNCj4gYSBoYW5kbGUg
dG8gL2Rldi9zZ3gvZW5jbGF2ZSBhbmQgcHJvdl9mZCBpcyBhIGhhbmRsZSB0bw0KPiAvZGV2L3Nn
eC9wcm92aXNpb24uICBZb3Ugd291bGQgYWxsb3cgU0dYX0lPQ19FTkNMQVZFX0NSRUFURSB0bw0K
PiBpbml0aWFsaXplIGFuIGVuY2xhdmUgd2l0aCB0aGUgUFJPVklTSU9OS0VZIGF0dHJpYnV0ZSBi
eQ0KPiANCj4gcGFyYW1zLmFkZHIgPSA8ZW5jbGF2ZSBhZGRyZXNzPjsNCj4gcGFyYW1zLnRva2Vu
X2ZkID0gcHJvdl9mZDsNCj4gDQpTaG91bGQgYmUgcGFyYW1zLmF0dHJpYnV0ZV9mZCA9IHByb3Zf
ZmQ7DQoNClRoYW5rcywNCi1LYWk=
