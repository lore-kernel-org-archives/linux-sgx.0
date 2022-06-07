Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B231C43334
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jun 2022 15:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbiFGPni (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jun 2022 11:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbiFGPnh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Jun 2022 11:43:37 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5163BCEBE
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 08:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654616616; x=1686152616;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eeV2Hg1LmYishO/QOnmj3TJkXI7/N4HV+Xv4mJKKYhY=;
  b=c+NHOIuGkSk5K2k0ngalQmeqqLSBRwZzTAaxIz/vfuQEf/BsjNvy3FsQ
   N93HjvSri70X4MDV+UZHI09bwH5VbGPdLh6m+c0GwiMcI8qRPL9ttHS+E
   s64vJnlLVPYjM1fVoWRsf9Ohrqh2wlp3oHlSSsEwkZjFTws8tBRuBPFYF
   fW3XMyBvoaiBiALSwyzj64kFPW9nHLbaz858ffP954KjYm/4RABiz7fiJ
   ykHw2I1XzLYwhEYo6PKSh/OQrCgH8R+0le3imDD8uYwGE7pJlyIT/b8pb
   RIXeVNtlUVWY67I2NaTbJLvdRlgme06WFZyBSZy7RgV8Nogi+GfseuYlS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="256563064"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="256563064"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 08:43:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="584249867"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 07 Jun 2022 08:43:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 7 Jun 2022 08:43:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 7 Jun 2022 08:43:34 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Tue, 7 Jun 2022 08:43:34 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>, "Du, Fan" <fan.du@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH v3 0/3] x86/sgx: fine grained SGX MCA behavior
Thread-Topic: [PATCH v3 0/3] x86/sgx: fine grained SGX MCA behavior
Thread-Index: AQHYcB70W6riS71E6UaA03o+b1wsJK0wxfcAgAyd6gCABVThAIABTfAAgAAHnYCAABdPgIAAA6/g
Date:   Tue, 7 Jun 2022 15:43:34 +0000
Message-ID: <e1c78d1a31234384a005736115906127@intel.com>
References: <20220525100604.760576-1-zhiquan1.li@intel.com>
         <f239a63d32cb8b3d8d6730dac940a51e92831828.camel@kernel.org>
         <MN0PR11MB6181099B27E37C05659A30B199A19@MN0PR11MB6181.namprd11.prod.outlook.com>
         <ccfc5dacc80454e35b0f13410abc8606832f7517.camel@intel.com>
         <86eb19b512771098136e43fcdac95be8646357e4.camel@kernel.org>
         <0350d13c-0122-365d-11cb-eca004b411ca@intel.com>
 <41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org>
In-Reply-To: <41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiBJIHRoaW5rIFRvbnkgaGludGVkIG1lIGFib3V0IG1lY2hhbmlzbSB0byB0ZXN0IE1DQSBiZWhh
dmlvdXIgaW4NCj4ga2VybmVsIGJ1dCBJIGNhbm5vdCByZWNhbGwgaXQgYW55bW9yZS4gV2FzIHRo
ZXJlIGEgd2F5IHRvIG1ha2UNCj4gdG8gc2ltdWxhdGUgYSBtZW1vcnkgZmFpbHVyZSwgYW5kIHVz
ZSB0aGF0IHRvIHRlc3QgdGhlIHBhdGNoDQo+IHNldD8NCg0KSXQgaXMgcG9zc2libGUgdG8gaW5q
ZWN0IHJlYWwgZXJyb3JzIGludG8gZW5jbGF2ZSBtZW1vcnkgdXNpbmcgQUNQSS9FSU5KLg0KU2Vl
IHRoZSBmaW5hbCBwYXJ0IG9mOg0KDQogIERvY3VtZW50YXRpb24vZmlybXdhcmUtZ3VpZGUvYWNw
aS9hcGVpL2VpbmoucnN0DQoNCllvdSBkbyBhIGZha2VkIHRlc3QgYnkganVzdCBhc2tpbmcgdG8g
b2ZmbGluZSBhIHBhZ2U6DQoNCiMgZWNobyB7cGZufSA+IC9zeXMvZGV2aWNlcy9zeXN0ZW0vbWVt
b3J5L2hhcmRfb2ZmbGluZV9wYWdlDQoNCg0KLVRvbnkNCg==
