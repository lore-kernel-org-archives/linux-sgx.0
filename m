Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7992CC4332F
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Oct 2022 00:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJNAUI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Oct 2022 20:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiJNAT7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Oct 2022 20:19:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9A113D3C
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 17:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665706783; x=1697242783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YYw8nmqWEjAAv1QGACyTu+9y5joqIcaP8yxvpOD5BfM=;
  b=nzQl7+nAaCHMAfgkPqCHL5N1ths8+vPY+R6kW3UquVxEptFgB4IAwAZo
   NUPEPeN4npH7f9ibmFUNP5z4MUKN2Km4Fekd+Fzil0w0DHuJSP4jS32Bc
   LcEf5hFiO7unJQ6rJ48J3TOb1McH4eY+pv6eos0nBqwgN1+stuA/hA8Mf
   tKgcMkonI0cRkFSDA8R/q9nOk8S3XoutMnMYVNo7Mtc3OrKPy3EXTepwQ
   U/X4qLHZGyg8QXzKy0pdEeFIJY+ZewRSi3Ua26W3NdQtXwHroIc3p+Ste
   qB6YTFHN5nYLofCbm1OdBZ7NEsl/4QqUvXPuWmkfJ3VIsPtTrLc66CVEe
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="305231122"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="305231122"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 17:19:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="802440829"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="802440829"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 13 Oct 2022 17:19:41 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 17:19:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 13 Oct 2022 17:19:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 13 Oct 2022 17:19:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkDudOrnYa65Lbtk/V1h+h92OuxQUXgpijmowq0heTU5bSR9jah/DWtrilnD4CDga+DOv/s7EeJufYC6Dt6PKONk53Pnzbu2Kn3knM/DEDwyk4pS8Bv6wbKSJ4N6phVbUuyXpvglM4O4cZ6SdkIC9t5Fzlks2sSr9jZQ3l4wLVp5u6xMjuKCwEzgZlGuCafR3KV7Cf4kbji7kq/Cxt8TKkegN78Xh5Ylz+CdjVwCN+ecBeNSlh30xe4BbpunxtUw+9f8EvqeWbwuce6YY59c29CILV6ULEp/OyNvy4D7ZoLPODkDST914hDOanJct73qeVzRict/CfVjEEqz6UTBvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YYw8nmqWEjAAv1QGACyTu+9y5joqIcaP8yxvpOD5BfM=;
 b=JPx98YrIKtqBoprjkIyd3aXgjwUR6UJ4TIdbAAn6XF+FYIHx2XQnexlx1eZF98OaFvVASIUU1N1ZpF4OhzkHLQNVs/BNbua0K+StCEaAJiIVUqrwsi0U/GxL2EXS5f3qpuTYf/RS/R8PZu91JR4LakXTBQcjxMH16CzOUDEkhg2mAKAjf6DdBXA7s3wNS6LAxdMthS2JitF/bdCNuiyPilwdccKF/WIWr7YR7DYmIVBaHMRYxqLJzSYh38jv0MbsP6yeCXCvAHDRjZSO4VgHEx34QS1Lo6utXFbI9+ZFbmqM+OkpNVIsyWiLOb1kSW4vxkmq+mHbprqF5+ewsLtDIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6006.namprd11.prod.outlook.com (2603:10b6:510:1e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.19; Fri, 14 Oct
 2022 00:19:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.032; Fri, 14 Oct 2022
 00:19:36 +0000
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
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAJ5RgIABk7IAgAARzYCAAGXuAIAAA7UAgAADhICAAAPHAIAAFAEAgAAE0QCAAAYhAA==
Date:   Fri, 14 Oct 2022 00:19:36 +0000
Message-ID: <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
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
         <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
         <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
In-Reply-To: <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6006:EE_
x-ms-office365-filtering-correlation-id: b20d6f6f-702b-47db-7a93-08daad79c6c6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8z5nZ7mSAaa27uGsKL1KwfWeG7bMwE0ugi6qvCxSmV09L1AvUB/JIYFqcVkx9VGQ2JS+VhrqMCiA49L5qrMTxGFCINwJHwP3vL5KmEOs4P6AprxPXudDVpICW6ltHU2SdeaX58JL5KCpKGSXEMGcX52BZeXOBWhUdLd9Vi49kEaFt6146Qj5bb02ylnQZ/bghhm9R6oIjO4PJ87jadS2XvV9uAVsCY+5e4pOVtjfo4B6fwQwx2u/zw8Dsqw2SHaSoWrsmd5LFMfe4jZNeZygvXmMwz0TpdtoBrxaicpTrziRCUCiBm79zN+za/0E88uEyNosynNZeIOgHhdJ+t1COJk7//Xd/I7XRkIVcJG29j1BWuNdGEp/p5U68jjfw1XjWCs45KuQnZu/c0/Vq4ffFjDPDoTYUPIFX1HYlv3JNt0d2LbfF1dkXjWkj2qj6lLyN8Qf09N1r6u9L+27IeCg1F8P66y24C+occQ7Y/ajWIOVRArZq8VNUBGRMWh7UroR2cC39hnLseyUIcCPCZxEzxkFImVDN4O955iP4mzZe8FDilGGPozqMBMdZSC+LKvKDa5NlT4Y+oqt/FGH24jFLsyaK1dNx+siaWKKxTZd6CKKk0uX7UvRDehd9jxYAmsIc6W7249CztmaIvpHZVlohLsH0LzB8Zna7C26xSN+vmcSwbkkzwjvtL8QFvZnkyX6a/e9KQH6j4WnRjo+/L0oCi6cUg+QVVjkjUTpLxF2sRayr66oUzyopZJi/VbX33pnLzIE0TZAFKbet7vP3nxgtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199015)(5660300002)(8936002)(4326008)(66946007)(76116006)(91956017)(71200400001)(110136005)(316002)(54906003)(53546011)(38100700002)(38070700005)(6506007)(558084003)(82960400001)(6486002)(2616005)(186003)(478600001)(26005)(6512007)(122000001)(2906002)(66556008)(86362001)(66446008)(66476007)(4001150100001)(64756008)(41300700001)(36756003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWxIVTRhSkgwbmlyTnp6dUNBbW1iVzVkaUV4Y1JzM2p6KzBzaVZxdTdQQVhZ?=
 =?utf-8?B?dERhUjJkeklBc2lrb1kxbmxRTDU5dFlOdm1hRytEcUJBTnROaC8weDlCall4?=
 =?utf-8?B?Y3dLMzR5OFYvVDc4Wm1xS2ZmaVNPMmtDeCtETUd4RHlTQUdBQzBURktrckR5?=
 =?utf-8?B?aG44VEF1c0cvUDNGV2o5ajdPY3lYc1JMTHBUbTVDVk5sRnhrK1FYNURkeXlu?=
 =?utf-8?B?Yk96cEQ0Ykl5NTZjdjY2SFBQVndUM2pmcUE1R1VDY092VUtwQlVqVE5PMDJJ?=
 =?utf-8?B?aXAyY0FQbm1BNDNwWUlmTW0xODdxbVZqWXVQc3FHNjJoY1hoa0lIa1grK1VB?=
 =?utf-8?B?ZzhVUW52MVlDYjkxZm5DUVpFbmZvWFlwN2JtdVB0UTE5c1RFdkhaRmQ3UHpv?=
 =?utf-8?B?bWZROG80WVEzaHAxbjFxbDZEN2Z3WW9xNG5mM1p4WEZsSzFiN3Fzano0blRC?=
 =?utf-8?B?MFRqVk1lNHA3aURaRWpvNjhQQUJOM2FxdDlvZmJ1UDI3ZTVLcjR0enlGcVRK?=
 =?utf-8?B?NlNqSWFVK1lCWDFRVENPLzlOcVNPZkR1cjNkaVlJT3ROMk9MU0UvV0xyVWRW?=
 =?utf-8?B?OXhvTDV4d0FsdEQ4OXFndy9rZ3ZXcmUwNklVc21pYndwQ1dITFRvVUN3c0dX?=
 =?utf-8?B?bEY0Yi9OSnRMMmtlVTg4RHZnM01PTFRQVXVJWk5rcGdIMGxwWitldFIyY2xN?=
 =?utf-8?B?TldHQm1hKzYwTWtvV2E5VUE4aFFXNmIyeXI0TU93Y3A4NEIwaDRsOUFxVngw?=
 =?utf-8?B?NzFWMUI3SGlvSm5vZERXUXZnemFtUlM5VmNFekhLSXJ5UnBWTk84Qmovb3NU?=
 =?utf-8?B?MEszSkZrVkl6cnNNaU9CZFAxVmtUYWpjVXRPZEdacmhUZGRHdFI3a0VXRC8v?=
 =?utf-8?B?N1NYcnJzTjc0NXFxZTBwc3pvRTB1Ni92Z0g0Z1FtSjBDWUIzaHJQUzRzbGdi?=
 =?utf-8?B?djFlV2tCQ050b2Yyc1p6SzRLa2xqbWZXOWY1d1JrQWdtSXVCMW5SSUNkS09J?=
 =?utf-8?B?NVJ0ZDdia1lOcmRmSlF5QTZIVitwYTJSeU9pc3F1M05VNG9kdnVYcFhpWnI4?=
 =?utf-8?B?SVFzSVhpSm1oWDRSd1dma05YVWFjeUt4bW9FWXFnV3ZkQzZlOGRuNFcwQW1P?=
 =?utf-8?B?K0cwTGpKRmVLOXREQWFmNlVzZkNmVXFBcU9ZMlQyc0V6d2tzVjhsdVhod1Mv?=
 =?utf-8?B?Y1RyQ2ZBTjJyc1BWS2lPb3JLcmFwdmpETG04TTN6M1FCSmpkY1BEVzZOZ2Fm?=
 =?utf-8?B?a0lZYzZkSHpHb2JqNTBJNTlCL1llZmJKRkRQTmdyeVlMWkgveWVCaXJjYTlJ?=
 =?utf-8?B?YzI3RzlUenFyOTlKYnp5ZHpzdmhPd3JiY1g4VSs4M1cvbGJMTTVWU3J2eEtU?=
 =?utf-8?B?UDR0R3YrL2pJSHpneis2RHNkcTU0d1hnRitEc0x3dGhPUGh5TlQxZ0g4eW5P?=
 =?utf-8?B?ZVJhSldBVzVZL1F1MXZvZ1ZBbXVMWkd1RG9teVJ0UFI3OTFENEZza0xPV1BL?=
 =?utf-8?B?ZGxFWmxFd0hEVFV2cWFYVTBzSWxPaWJyd0Q0QXR3QXZqVGR3UzhLRnhxeFJj?=
 =?utf-8?B?QmVMa084bjJmenRTekh6eUdBakFOR1ROZG1kM3VIOThIekRnbERzU2JRRC8r?=
 =?utf-8?B?RVNSSE5IZUFhWFUwOFlOMUMzdUwwMHZoU2V0NlVQQk0vbE96a2hVbmxaRmJN?=
 =?utf-8?B?ak1Bd0p1SEx3akJPbHZjbDJkems3YWJQbFRTNGNEKzBKSDVZcFQvVnVjSCth?=
 =?utf-8?B?K0o1amVJRWI4OTNQTXAyeUJsMEIvZldUTE5nbGkvbEFGTWhIWGhaTFhzSjRs?=
 =?utf-8?B?RWJCdzRKUmcyZG1uWUREcFBRQmdYMnF6OG5iTW1sYkZMS3ZwdjIvYXlnTlF1?=
 =?utf-8?B?MUEyNjUrSXdJN2cvWHJsQjdxZ25UTmd2MkdTLzRnSEdiRHhERVZGK2hIam1B?=
 =?utf-8?B?TkdnVUhyWjRrS3RZMUprQUlLY2dlTkkxUEZEc2tiT0ZZUmJZandvTWRBOGNU?=
 =?utf-8?B?SEE3VlNKclZjemlHa2FDMXdmdFBsa1R1TGhoTDhhTlVOVmJxSW9waHpMeEVt?=
 =?utf-8?B?OFNwTXJEbmI2OENUVnliUlhOdTloTkdSUG12Njh6aWYrU3dSVG16SUlnc202?=
 =?utf-8?B?b1NCM0VjbVNTMnozK1JiSFhKMy9uMkFjWTcxdFdLeVhWb3ZYZG1DT2E5dEpQ?=
 =?utf-8?B?R1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3171AE619530E4F9C2393C79A161DEB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20d6f6f-702b-47db-7a93-08daad79c6c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 00:19:36.3266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WThLQ0m2gFy2sZ1RV5jg+0YxjzSj1z3cIewtdVnIk4aBFjxm3fBw4gzNd8KgfSEHCgDxz+hfN2jU0A7lHxgtRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6006
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTEzIGF0IDE2OjU3IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMTMvMjIgMTY6NDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gV2hhdCdzIHlvdXIgc3Vn
Z2VzdGlvbj8NCj4gDQo+IEknbSBmcmVzaCBvdXQgb2Ygc3VnZ2VzdGlvbnMuDQoNClRoYW5rcyBE
YXZlLiAgSSdsbCBkaWcgbW9yZSBhbmQgZmluZCBvdXQgYSBzb2x1dGlvbi4NCg0KLS0gDQpUaGFu
a3MsDQotS2FpDQoNCg0K
