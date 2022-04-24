Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEBEC433F5
	for <linux-sgx@archiver.kernel.org>; Sun, 24 Apr 2022 02:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbiDXCVP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 23 Apr 2022 22:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiDXCVO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 23 Apr 2022 22:21:14 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415C41A6B46
        for <linux-sgx@vger.kernel.org>; Sat, 23 Apr 2022 19:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650766695; x=1682302695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tsfpdjxBFkvErU985A7NuKwAG8Bdxdn811QVlIVOKC8=;
  b=YsiYVo6xNPERnZRwNqz7lRqI3G3xKBN3bYu6M5FOkvgIEwFWstluxMol
   jnjRjo1HF9ju34XqvXCnkli9sIxiMAH9M1KnLisbLEKYa+LL7BJumXTsX
   IjKh/eXPxmuYoUV/iWzPkN1uABgcyNan3/4/hW2ylxOX9oQZudkF6huBu
   bRpWRFbpdEhLXGO44ywss0FS+HBKWHzblfQrsr5AEM/xMkQv24fCW8ojP
   87OJlEMDCJwKsSwd+v9aehMOKILWxP8+UfyoHhmiRU6oMQhBzSpnBNRA4
   KEddtodCV5lE4qXRLnEBELlj2dCPfrWkVFHokNnaI9ckmlfGuSIX1NZVB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="252324417"
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="252324417"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 19:18:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="512106954"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2022 19:18:14 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 23 Apr 2022 19:18:14 -0700
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84]) by
 fmsmsx604.amr.corp.intel.com ([10.18.126.84]) with mapi id 15.01.2308.027;
 Sat, 23 Apr 2022 19:18:14 -0700
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v4 8/9] x86/cpu: Call ENCLS[EUPDATESVN] procedure in
 microcode update
Thread-Topic: [PATCH v4 8/9] x86/cpu: Call ENCLS[EUPDATESVN] procedure in
 microcode update
Thread-Index: AQHYVW+as2wwB/JJhU67AIl9mRpBA6z6ux8AgAOcG+A=
Date:   Sun, 24 Apr 2022 02:18:13 +0000
Message-ID: <8004820093324bb8974d95b864bb7633@intel.com>
References: <20220421110326.856-1-cathy.zhang@intel.com>
 <20220421110326.856-9-cathy.zhang@intel.com> <YmFI7OiWRaWNNsGM@zn.tnic>
In-Reply-To: <YmFI7OiWRaWNNsGM@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-reaction: no-action
dlp-product: dlpe-windows
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGkgQm9yaXMsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQm9yaXNs
YXYgUGV0a292IDxicEBhbGllbjguZGU+DQo+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAyMSwgMjAy
MiA4OjA3IFBNDQo+IFRvOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT4NCj4g
Q2M6IGxpbnV4LXNneEB2Z2VyLmtlcm5lbC5vcmc7IHg4NkBrZXJuZWwub3JnOyBqYXJra29Aa2Vy
bmVsLm9yZzsgQ2hhdHJlLA0KPiBSZWluZXR0ZSA8cmVpbmV0dGUuY2hhdHJlQGludGVsLmNvbT47
IEhhbnNlbiwgRGF2ZQ0KPiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPjsgUmFqLCBBc2hvayA8YXNo
b2sucmFqQGludGVsLmNvbT47IFBlbmcsIENoYW8gUA0KPiA8Y2hhby5wLnBlbmdAaW50ZWwuY29t
PjsgWmhvbmcsIFlhbmcgPHlhbmcuemhvbmdAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIHY0IDgvOV0geDg2L2NwdTogQ2FsbCBFTkNMU1tFVVBEQVRFU1ZOXSBwcm9jZWR1cmUgaW4N
Cj4gbWljcm9jb2RlIHVwZGF0ZQ0KPiANCj4gT24gVGh1LCBBcHIgMjEsIDIwMjIgYXQgMDc6MDM6
MjVQTSArMDgwMCwgQ2F0aHkgWmhhbmcgd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2luY2x1ZGUvYXNtL21pY3JvY29kZS5oDQo+IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vbWljcm9j
b2RlLmgNCj4gPiBpbmRleCBkNmJmZGZiMGYwYWYuLmVjMTIzOTJhZjM3MSAxMDA2NDQNCj4gPiAt
LS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9taWNyb2NvZGUuaA0KPiA+ICsrKyBiL2FyY2gveDg2
L2luY2x1ZGUvYXNtL21pY3JvY29kZS5oDQo+ID4gQEAgLTMsNiArMyw3IEBADQo+ID4gICNkZWZp
bmUgX0FTTV9YODZfTUlDUk9DT0RFX0gNCj4gPg0KPiA+ICAjaW5jbHVkZSA8YXNtL2NwdS5oPg0K
PiA+ICsjaW5jbHVkZSA8YXNtL3NneC5oPg0KPiANCj4gVGhhdCBpbmNsdWRlIGxvb2tzIGxpa2Ug
YSBsZWZ0b3Zlci4NCg0KWWVwLCBpdCBpcy4gSSd2ZSByZW1vdmVkLiBUaGFua3MgZm9yIHBvaW50
aW5nIG91dCEgSSB3aWxsIHBheSBtb3JlIGF0dGVudGlvbiBpbiBmdXR1cmUuDQoNCj4gDQo+IC0t
DQo+IFJlZ2FyZHMvR3J1c3MsDQo+ICAgICBCb3Jpcy4NCj4gDQo+IGh0dHBzOi8vcGVvcGxlLmtl
cm5lbC5vcmcvdGdseC9ub3Rlcy1hYm91dC1uZXRpcXVldHRlDQo=
