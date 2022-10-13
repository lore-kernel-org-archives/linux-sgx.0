Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB270C4332F
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Oct 2022 23:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiJMXke (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Oct 2022 19:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJMXkd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Oct 2022 19:40:33 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC36265806
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 16:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665704431; x=1697240431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g5utxKP3i80H1ycJjQxKFUWx8ETuYDaxhd2wIMAChBQ=;
  b=aNahECcTEkIPdwEb4gyy1vyJJvGKvf4wMPIsdFv7egP+o1Up1rkVdYyO
   ZUQU90TvRJ40nmYxaxWUAlo8Y5CAAkJqTNHAqXQrdYTvuWznHBOtNd9xd
   n8912IuId8OS6O+urkzLwCD8JF0DOKJdi8O9R6KLhKLBSiaPnyE6E8CJ2
   bhERJhJ/KbhxPjxI4RbJ8XuhmVGPAeCQOcViqK5Iy7BQJY3OMPFZzBQRf
   tCI0aacuMGg8QpjqrwFmBjJziOIZxXRwj9U8TvBWUV5EBJ5BV/8QID5ah
   OHnCWQA5bMuHbX5a4v8BgPvbsmtpMDYUwH9TMe95SYlzwwiOoX3Z+HcHE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="292586682"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="292586682"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 16:40:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="605172885"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="605172885"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 13 Oct 2022 16:40:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 16:40:30 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 16:40:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 13 Oct 2022 16:40:29 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 13 Oct 2022 16:40:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwAUOI4ov/+gF+KFH/ZstFLVokvG8s2UGby2ZXglq3gxvT1cJgnVfXkV1Av+cbJtLnHeIlNqGbujkcrSSz/UQqhOYTT2A+h26oHDFZtW8Vd/CEMOii7VphgU65UgNnOGIpDaUXWk0epPtSi0MQyyBjHI945WdrXZOlkzE+NGLHULFKjG/UJjcPZCsxD/2yYMTAeM1zFdgPt91SFNdncCFzJcrdE67+vkRBjJrhvYA1LjLrq/cNKQEZvAEspMiNhnqF4jmf5I0+MBZ25viLJ5BY6XbFiBDSX/ugXRJbvS8zfLUHqAZ60W5fBl4YY2bWZDq0SIDD6jEBc+LeTk+/UmRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5utxKP3i80H1ycJjQxKFUWx8ETuYDaxhd2wIMAChBQ=;
 b=nltA++kYsgdkE7gOhPOWCpTDBJmr6UAMdlbvNDr22WZBWRl/pmDCSvjZ/XsGCGYcRYUE5hqXOrN1aYzMGqvvhxlH59M+EqZJq3ZCePChqGC1hrnlYvWoxJWqooJXeImXQ2adF+6GPZOtmZSzstLzndzTs9cW6f7KddykIKA6Jl7c7R2XidrFHoav+Ya9/5aX5uPxqybMdT9Iuo9ZN5cvtqN67DixKbAJl/1yiunY39kQrzthS+zUV7B902Tpc1ao1OMX7UZYy63ltzKJTZkdWO8oMk//IMdgrDAUIa0NZSYzLxnvz71my+2g8XJg9orw+eCPeJhkK906z7ZHyuG48g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV2PR11MB6072.namprd11.prod.outlook.com (2603:10b6:408:176::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.22; Thu, 13 Oct
 2022 23:40:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.032; Thu, 13 Oct 2022
 23:40:25 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Topic: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAJ5RgIABk7IAgAARzYCAAGXuAIAAA7UAgAADhICAAAPHAIAAFAEA
Date:   Thu, 13 Oct 2022 23:40:25 +0000
Message-ID: <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
         <20220920063948.3556917-4-zhiquan1.li@intel.com>
         <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
         <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
         <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
         <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
         <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
         <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
         <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
         <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
         <4930999a-888f-88bc-a05c-86762504f059@intel.com>
In-Reply-To: <4930999a-888f-88bc-a05c-86762504f059@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|LV2PR11MB6072:EE_
x-ms-office365-filtering-correlation-id: 3e212968-c14e-4e31-9af9-08daad744da6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: scPApfru7b2Jfw3XSU18g/J1uEaXeVLn87h5nmz2yB9zLhogXAu7wgfxdfgUwH6Utk18wGpNOTtdc+lykpYOZE/0au8gX6fZ+WOm+VYq6G36WzSEXxCUHuOfXaf/zmwWyladhMihmohezJXhKMsPXs97f7XjquxxlYQ6GphQ3Ee99He4av94VbXtrxMRTY06orxDVDxHjm/8x9HWM1bHvJ8xnA6tdFA571Q3hxB8cUk0DMUGO1o63Zx3nyId68k/g+4Gwp3V/5KLTAtKWTNLETI86oBBUsrbrDYBb6rfpNOUwN7wWzXls2Iy/6tUK5qRnzFT3AdVjOkUELWsuMkpQLhKFpjWXfrtWnqRHrgqAePPgT+40qOk6CP0+EUlE+9XMXseoeIiJAQIqKOL9X+/wzo6aABldU4p6aT2yfK1TKPK094wP0iMMcai9PJDRzvtyXUDdOb0saLx0J1juliuWqiDyaJMCFC6/gxMhVAC3R3VnPsiICPUBhW73PnT2KX2giO8/cugRmTpAou4VW+m0isw6kPo7ru9WXXaSY/8x5O7iTzrSJmNvI2a5HDA8KnC96pCEWywTIO4HmtZJoKYMYYXeu7pAmwc7F9fdlaPH/Ujhkc1d0kFCk/M25ws/vL9zrnu/zJjF+/JTGYTLqrCkS13tnjT8r383B7JnsvQxQUANNL2CDleF8btIYRoIlNvvqsuLtcdfHf4sKtvtY0YzJmtqoW3rSf+SouMb3jJRadrl8kvmNT+PDt6DOiqQz/05+GvNwenzQuRZqldpZGPDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(2616005)(110136005)(478600001)(4001150100001)(186003)(54906003)(83380400001)(36756003)(2906002)(86362001)(5660300002)(38070700005)(6506007)(66946007)(38100700002)(82960400001)(41300700001)(316002)(6512007)(26005)(8936002)(71200400001)(6486002)(4326008)(76116006)(8676002)(64756008)(66556008)(122000001)(66446008)(91956017)(66476007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QncwMDF1Ty90Rjl2cHg5cFpuU1JVQVlnRGhYWVNkUXp5bVExMnNaSUNqV3RF?=
 =?utf-8?B?QlRRZlIxcGxXVFJIa2FBVzZaRnYyd2hiUmRBRDhBVHMrNDRHeThteW5JaUZk?=
 =?utf-8?B?RERmRExIR1RzVzk5OW1TdGRTblZqbjB0Z2doRnFsckFYWUtBdW1DYXJyWm5G?=
 =?utf-8?B?aGFaSnNndGtmN2hKOGQyOGMwc290MWxBcUxtbytmb2Z5WW1GMzQ4ekxrZ0lJ?=
 =?utf-8?B?M3NQNVA3bDhKNTUxNDltWXFnN0lJT1NqM2pBZzJnbGNGYUJQUUM1bEE2dERm?=
 =?utf-8?B?Mmc0cWJ5MmdhNFRYYkw0ejlocEc2Vk5zOEs4aVFaNkJGOXFTdUVRaVNXVXg2?=
 =?utf-8?B?R1J5emJOVGxPRzNHNlhMTDRiYndRVEc0bW5ZZFNrS2ZuK2lrbXVINkxYL2lm?=
 =?utf-8?B?OUVjZEFpWHlaMCtlajBaMW90SnhqSjBDSE9Za1IzNzhRMnNsUWx0ekJDVTRh?=
 =?utf-8?B?MGp2bCtpWmpDOC9JTHJrcitKS1pqenRaaEoxK0V5eEZrNDZMdWVkZ0c1aFd2?=
 =?utf-8?B?aUozcW1ibGhodjduVlhkdWpPRGtrQVBlbndDYXI1RnM2UVNDMGFSYmlKenlI?=
 =?utf-8?B?YzBzQm1qMVBiQkZ4RVNFbGMwYW15cENtRERMaHhWQVNuR1ZrM1hML0xBbGNB?=
 =?utf-8?B?WmpaanNVZkVhY3lFdzdBSGJqNU5aVEhwaXM1TGlkaStNME9HNnNveUNCT2xX?=
 =?utf-8?B?REVHSjFiUU5CWmd5cFV0YklPU2JJRnF2UG16WkN2M0JHb1FkSnpLeWVXMlZB?=
 =?utf-8?B?VW5iNnNKaFFzbDBraXoxRTkxZG51Ui9mQ0FJbUowVU1CYUZvaFNRL05zbVRO?=
 =?utf-8?B?SFg4RXVQVjA4YmRlVHRPV0JEcFFYUExmTnJtVWNzOHo3L0FHMFdqK0xTcEdW?=
 =?utf-8?B?RmhuellYcHVobnJleHdmMDU4TXd1MmFZcm9rME5RRWtpQUZaQWYrcy8zRk5h?=
 =?utf-8?B?dDVyNEZENmxnU1FVNDJySUNGdnUwRG9reG9uQk9VdGdnS2xKR1RHdzIrOXZJ?=
 =?utf-8?B?RXE2OFB3a3I0Q0t4RktndVl5Z0NubFdLUzFDNFNGSGR2aVJmL1JsL1dhMU9p?=
 =?utf-8?B?WEZ2ZTlubkE2dHA1ZkxCYWdSTG9iYjFJUTN1SC9rMkZXcnlFU0pRcS8xZjdW?=
 =?utf-8?B?d09zdlhnT3l2dVJwM0pyZnZtbUJ5TlNjbnFXS1lUS09jQTh5WnZ5RldyUWZk?=
 =?utf-8?B?VGd3a1MyTWVXWTRuT0d1RXJ6emlBeTNhUzZwWUphcCtlc1ByV1FZL1Q1czRK?=
 =?utf-8?B?ei8yRHVlYkZ1aHNnTGxlak1mWVFUaGVBS3hSYjhFb3lwN1ZBVjd4QU9RWEVP?=
 =?utf-8?B?WTJiZ0N6bEYzbHFMMXluRlFURW9jQThSY1ByQk10dkd2V0t2Mm1MTHVQVUN1?=
 =?utf-8?B?WThYcGRMZzZFbFZ3bDhoK0t0TmhJZWZXNS82L2Uya3VrYjNSSkxVd0FGb1dD?=
 =?utf-8?B?QmUvRFA3VGJROS9vcGFodTQzSk9udDVNNkNkMnpJVXFWSjZENlBoNXRpbWJL?=
 =?utf-8?B?dHpjdFAzRXFMN1c0TlRtNmFiTmpwYWllZWJQZFV4eTZLYW9pY0RRSmI2VlFs?=
 =?utf-8?B?U09VOUx1L0tLQXE0WlVKZ2c0RUR1SjJXVkpaVnplSEFraXEwaDFjNGIyOFJS?=
 =?utf-8?B?UEl4S0hLak1PdnJVaUcrNWJ0Q3Z4TFV2R2VjREh6Qm5BbFhZeFZuRTVEbmEx?=
 =?utf-8?B?dGpKZytzQmRqK2pyL01WcXV1em5GMk9KeTNXZG9BbzMyLy9oMFc3bHNXMFUv?=
 =?utf-8?B?Mm84QU1kZFllTW1oWjllMnZ0TWpSak94NmFKZm9TcmpjZVZIQXZYZS9VcENE?=
 =?utf-8?B?ZjB6LzNpTjdJNWZWWDlGdnBtdlZQUC8rTTNmQ2dhOURYTVczS042dmM2MGY0?=
 =?utf-8?B?S25RdHRrb3g1RXEvY2p1OUlWOWErcG5ZM05sMlZBb0lMRG9EY0p1NVJ0akFX?=
 =?utf-8?B?NjMxU0dNZHV6Z25obnBrYmNWTWwrMk1hWE5YdzNuMW45Y2JnNmtTM1loMjgr?=
 =?utf-8?B?MHlUK1JEY1l4Wjgya3F2SHpCVXVpSlY4RVBDOHNEUkdNWkRiUm5ESExSbFZ4?=
 =?utf-8?B?bk9pRUphejBjZ3k2bVNoOWZMd2RKVk93VElIeHNZcU5pR1lXbWd4TTFoYTFQ?=
 =?utf-8?B?c0VRbmUzVHFhUlJlSEpJbUtYUDF2Nm02VGR3T2ZTdlB2RGxyRnNoOUtKbUlM?=
 =?utf-8?B?dFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D02C31A24C9FF44F8901FEAC141DBA71@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e212968-c14e-4e31-9af9-08daad744da6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2022 23:40:25.6453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xzowq6LkQGjiFFH1vqcF/Q4wey5c4wlO41TasrIrdAb3zK+jbQYsrw2shaa0eiktd/5uNnf9xEH1VN/YTrUmJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6072
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTEzIGF0IDE1OjI4IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMTMvMjIgMTU6MTUsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gVGh1LCAyMDIyLTEw
LTEzIGF0IDE1OjAyIC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+ID4gPiBTcGVjaWZpY2Fs
bHksIHdpdGggdGhpcyBtYWNoaW5lIGNoZWNrIFNJR0JVUyBpbXBsZW1lbnRhdGlvbiwgb25lIEVQ
Qw0KPiA+ID4gcGFnZSBjYW4gb25seSBoYXZlIG9uIGhvc3QgdmlydHVhbCBhZGRyZXNzLiAgQnV0
LCBpdCdzIHBvc3NpYmxlIHRvDQo+ID4gPiBtbWFwKCkgYSBzaW5nbGUgVkVQQyBwYWdlIGluIG11
bHRpcGxlIHByb2Nlc3NlcyBhdCBtdWx0aXBsZSBob3N0IHZpcnR1YWwNCj4gPiA+IGFkZHJlc3Nl
cy4NCj4gPiA+IA0KPiA+ID4gU28sIHRoZSBpbXBsZW1lbnRhdGlvbiBvbmx5IGFsbG93cyBvbmUg
aG9zdCB2aXJ0dWFsIGFkZHJlc3MuICBCdXQsIHdlDQo+ID4gPiBjYW4gaW1hZ2luZSBhIHNjZW5h
cmlvIHdoZXJlIHRoZXJlIGFyZSAqVFdPKiB2YWxpZCB2aXJ0dWFsIGFkZHJlc3Nlcw0KPiA+ID4g
d2hlcmUgdGhlIFZFUEMgaXMgbWFwcGVkLg0KPiA+ID4gDQo+ID4gPiBXaGF0IG1pZ2h0IGhhcHBl
biBpbiB0aGlzIGNhc2U/ICBXaGF0J3MgdGhlIGZhbGxvdXQ/DQo+ID4gDQo+ID4gTXkgdW5kZXJz
dGFuZGluZyBpcyB0aGVyZSBjYW4gYmUgdHdvICNNQyBoYXBwZW5pbmcgb24gdHdvIHZpcnR1YWwg
YWRkcmVzc2VzLg0KPiA+IA0KPiA+IEVhY2ggI01DIHdpbGwgYmUgaW5qZWN0ZWQgdG8gdGhlIFZN
IHdoaWNoIHRyaWdnZXJzIHRoYXQgI01DIHRvIGhhbmRsZS4NCj4gDQo+IE9LIGJ1dCB3aGljaCBh
ZGRyZXNzIHdpdGggZWFjaCBvZiB0aGVtIHNlZSBpbiBzaWdpbmZvLT5zaV9hZGRyPyAgVGhlcmUn
cw0KPiBvbmx5IG9uZSAtPnZlcGNfdmFkZHIuDQo+IA0KPiBJdCBzZWVtcyB0byBtZSBsaWtlIHRo
aXMgbWlnaHQgcmVzdWx0IGluIHRoZSBzaWdpbmZvIGdldHRpbmcgcG9wdWxhdGVkDQo+IHdpdGgg
dGhlIC0+c2lfYWRkciBmcm9tIHRoZSAqT1RIRVIqIHByb2Nlc3MgYW5kICpPVEhFUiogdmlydHVh
bCBhZGRyZXNzLg0KPiAgQmFzaWNhbGx5LCB3aG9ldmVyIGFsbG9jYXRlcyB0aGUgcGFnZSBzZXRz
IHVwICp0aGVpciogdmlydHVhbCBhZGRyZXNzLg0KPiAgQW55b25lIGVsc2Ugd2hvIGdldHMgYSBt
YWNoaW5lIGNoZWNrIG9uIHRoYXQgcGFnZSB3aWxsIHNlZSBhIHZpcnR1YWwNCj4gYWRkcmVzcyB0
aGF0IGhhcyBub3RoaW5nIHRvIGRvIHdpdGggaXRzIHZpcnR1YWwgYWRkcmVzcyBzcGFjZS4NCj4g
DQo+IElzIHRoYXQgcHJvYmxlbWF0aWM/DQoNClRoYW5rcyBEYXZlLiAgSSBzZWUgdGhlIHByb2Js
ZW0gbm93LiAgSSBhbHJlYWR5IGZvcmdvdCB0aGUgcmVhc29uIHRoYXQgSSBzYWlkDQoid2hldGhl
ciB0byBhZGQgYSBjb21tZW50IGlzIGdvb2QgZW5vdWdoIiBpbiBteSBvcmlnaW5hbCByZXBseS4N
Cg0KU28gd2l0aCBhbGxvd2luZyBmb3JrKCksIHB1dHRpbmcgdGhlICd2aXJ0dWFsIGFkZHJlc3Mn
IHRvIHRoZSBvd25lciBkb2Vzbid0DQpzZWVtcyByaWdodC4gIEkgdGhpbmsgcGVyaGFwcyB3ZSBo
YXZlIHR3byBvcHRpb25zOg0KDQoxKSB0byBlbmZvcmNlIGluIGtlcm5lbCB0aGF0IHZpcnR1YWwg
RVBDIGRvZXNuJ3Qgc3VwcG9ydCBmb3JrKCksIGFuZCBwYWdlJ3MNCm93bmVyIGNhbiBiZSB1c2Vk
IHRvIGNhcnJ5ICd2aXJ0dWFsIGFkZHJlc3MnLg0KMikgaW4gYXJjaF9tZW1vcnlfZmFpbHVyZSwg
d2UgZmluZCBvdXQgdGhlIHZpcnR1YWwgYWRkcmVzcyBiYXNlZCBvbiB0aGUgY3VycmVudA0KcHJv
Y2VzcywgYnV0IEkgYW0gbm90IGVudGlyZWx5IHN1cmUgd2hldGhlciBpdCBjYW4gd29yaywgaS5l
LiBpdCdzIG5vdCBjYWxsZWQNCmZyb20gaW50ZXJydXB0IGNvbnRleHQ/DQoNCldoYXQncyB5b3Vy
IHN1Z2dlc3Rpb24/DQo=
