Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1369C433FE
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Oct 2022 22:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJMWPl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiJMWPi (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Oct 2022 18:15:38 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D013E474F3
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 15:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665699335; x=1697235335;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7k3k5Ipuv73XvsqXrGnz6NRybfJVysMNz9A63GpnZvw=;
  b=bCYO+XEkpESWpEfIb5MEygOGR8+KFcA/0ZwIdcT05SBP9zvNY00dLZkz
   XwYmLOQXsMXxxY0fctr96IPMgm9LWjB9BG1/F7aT2jbYyl8c1mAfFf1Ln
   lzeGOz7QZFgnm3Vqat9TvhiC3NT9DFt7B858kUCLt4kk/M/a1WNNpBJ9U
   wBh3oPUAtv2dqhe+BtAgZz70eyEmqipMXqqPYtWh9S9x87jocrQ1qLOof
   eK07zcni4xsPN1WXRSzZ7+MZnPkrsONR/VpPzy1/l85RU5dlcHzpUc5O2
   n2BqthRwzeNvwmKN+EAPaT19mrP5j1tH0p7Mm025DW4zDuTKVHUfhkYDv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="284945379"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="284945379"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 15:15:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="629710561"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="629710561"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 13 Oct 2022 15:15:35 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 15:15:35 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 15:15:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 13 Oct 2022 15:15:34 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 13 Oct 2022 15:15:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jcq12Ox3mS2XBoh5tooi5ZqmxOcugLDrveLm1CTTh7DgzWFWMTJJ9WvinFsw/ZoPA+tPrVSiwkxPwo/fulmYfw+cgSbtv+M1Nwvb8aJy7B8PPNnzzWb3/Of6jVKhiGLsttcFuLGcQg8KCwbqw0HdPd57IATfWd/Ej/7ooWZEA2TmKcYebGWXgDL4oT4QwQm2arHjfp+UcykVkjyeTSqREcX66FCyKlcOzbnWg/qpIVXqgN9k0p2/dL2cSbUadpkoqlo2PJ5k6o3PQ/Uibsv7p78jboKda9jffB1+GzclZPDtqjNBlSQqO3/LNR8IkcvDii+tzPHCQl+7TGdJ6GswNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7k3k5Ipuv73XvsqXrGnz6NRybfJVysMNz9A63GpnZvw=;
 b=KhR7G6qvCPvTpakXaE3of272bY00uGbE252O0Di7PUo1T3L1iXa2RWgCAUwIh3S2ShMl+Tmv6A6mc1chJqAmfBmJpmprj+Ud1daoBYV/XOHxrDyUggkEfRSuXw5OJFEncRUngb43HH/EwiUP6TOKgxo7gon+KFy3JcKLr5qK0xNr3GpurIA4rfAoEoNV25naKbjebGqxVjlnm1Jp0CcP7gEwcgz9DIQsE3QV9EYC369f7I2Ie1Bo6k38Qcfikpur2rKET6p8tIzn/WI94RALWaY+ZffqugAgth5SyW4zvxgWBfIZp6iG25dLj6hdYAIvY3hsrMufrDgmQ1inzuZrbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7379.namprd11.prod.outlook.com (2603:10b6:208:431::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 13 Oct
 2022 22:15:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.032; Thu, 13 Oct 2022
 22:15:19 +0000
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
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAJ5RgIABk7IAgAARzYCAAGXuAIAAA7UAgAADhIA=
Date:   Thu, 13 Oct 2022 22:15:19 +0000
Message-ID: <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
         <20220920063948.3556917-4-zhiquan1.li@intel.com>
         <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
         <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
         <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
         <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
         <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
         <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
         <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
In-Reply-To: <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7379:EE_
x-ms-office365-filtering-correlation-id: 0e51d326-92d3-41df-33c3-08daad686a1c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pO0G+AMj1TmC3z3m6tU83F1D+7ow0VR9P7Uz27scinJELSyiYKO0zay7wwqoTLOIigVCdUM/Hb3Zm0w5KFqRrdrUD/lSWZfa/DUEB1zlHsF/uDgsAOfbMXULfd2SrCzzvNxyBBxTUfnFg0uZZOamXrza33uFE9HO/WcDfl+f6fMB/kEhNeU2NFxVNfIoYa6suIthOYQIbTtLJJYpVrbF5Jh/oKCNKHKJkI8rgy6//JeGNKuNGbzT6WeblK3tbV9S0zOUo6ZRHQBSyz7K68pmwL9vUTbU3U2rG02PkaDuSoUOCU7khExeDOOUfHGVi2cMy1i5SIq0sk2mqi7TS6AToUPo3TyeEgdriIHD0GF4UmQ4PCKVCT8CF6nUhAdKkJKsGQN34y5QpjJg+LON60eHyIXjPxcgTeI3cpleQhGM8nqHeaSLBoXKVHqVxnmyhl7uGg0NZs8hMveCBYFDhw3DPAORVHNjIR9750DIRctBW41FQLO3bkr6hZOqRikmmtWl1qVdGXiaB8pjV4q4tphhbwluJr3ZapxoEcIOU8f9LKw2BZn5nGrbDDUVTI8UsGXr3sy3oKep5fkqaEaqSZDZ3wDA7UXIPD89QfQi6deMkqizQSizHNjnjj1L15ZQHzojgG/zYOFVhMYVzUuEToigCDLyDZm0K0MM6eNWMLNn60pQAeFmv3CohKAUr0GICW/awE3GZgM1efWhB5w98YSyrow0LVyL+e1AfQDv7OIqSC2C+LAcNaMpEVg1CcBtqoRwiLU3X0O3ehrfJcc5A/xxZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199015)(76116006)(316002)(54906003)(478600001)(110136005)(6486002)(71200400001)(66446008)(66476007)(66946007)(64756008)(91956017)(8676002)(66556008)(4326008)(6512007)(26005)(8936002)(186003)(41300700001)(5660300002)(4001150100001)(6506007)(4744005)(2616005)(2906002)(36756003)(122000001)(38100700002)(82960400001)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjBRRTBhMFdEK2hleURJVityMmRhQ0ZmWVVXc3Z1ZklSUDZuTkQ4OVZoS3Iz?=
 =?utf-8?B?U1JpZjMwWmN6R0IwVHR5U0hLQjEwbGswcXBsSXlacTJCOUtnTFExL2RLU1hF?=
 =?utf-8?B?MmRJSHVMdGlPTzNPU0hwTFd6NEtvK0ZreFNvSEYwNmovNE9IaGc1RVlhY1hz?=
 =?utf-8?B?Qk5wVlNiNlNncHI1NVh1d3lYNWVtTS9ZQzBHU29mSDRtb0hoM2hlYi9YS096?=
 =?utf-8?B?Q1lCOU5PWVFHOFpYK1htbGdPMVhSc0JYZ2pyc2g5OE9VMDdQZmJ2TVRibGRD?=
 =?utf-8?B?ZVRGZ3Uvc0RlYTJNbkM4SG5pVk5tMkZRSVZSeXdvaGU0bE1rTER0Sm1nVG1S?=
 =?utf-8?B?WkllMCt2M1k1TmcvMlMrMHpzNG5LYStvVVpJcXNzUzNTMnFyYnIzNDVTZncw?=
 =?utf-8?B?RHF2RjNvWmRRblI2VDBrdENlQk1HVVhzdWhtWjlMaGlsK2xqaS9vdXVUaFF2?=
 =?utf-8?B?bmZIODk3Vi9UTElqUFNRUzNDb2p1V1FiWk53UUducXd6QlJoeEFQdldUYTBu?=
 =?utf-8?B?ZTNWTWZRK3RxSmJqSXhxY1VBNCtzbEorZmo0TXF6QzNva2lPNHBtenhlWGk3?=
 =?utf-8?B?c2tzWndXcDdIdDNVR2ZENEY3bE5DeUw4eTl4U29pMTZ4bUx3YmZkRVZCelM5?=
 =?utf-8?B?SVpld3c2K1Y3ckpEdWZ6U2Q3bDEvRTVjUUplTWYwNG81dmFLWTlMbm9VaWxV?=
 =?utf-8?B?ZU1xVnJwdjZDR2VEQUI4VEc2UFY4dkFHcnoxdzhwb2MrbS85MVBhM1pFRzhr?=
 =?utf-8?B?bGdPSFhjd1VpUVVZTGo3dFNUL2hXY0VTM2VVM3hpQXRzcGovMng0WEVrMTZV?=
 =?utf-8?B?Zjc5NjROTDE2SWZ3UnQyQVExYlE3OWpGWXVaSDMvWnRLWTVXeS9rYldDSG1J?=
 =?utf-8?B?VDFYaU9OemhtV0dWdm9XRFRJWFVCVW5qTmI4SzllSFl6R2UySXUxVkNkZnY5?=
 =?utf-8?B?WWM3MGRVU2lFSnVISGRmajdHb0dSOC90dllxRkJBK25DR2o2Mm1iUzhhK2tW?=
 =?utf-8?B?a1JrU3I4ZWMreXozd1lrZHZCMXI1SU1ibXZ2cWZHenFGVWJBWVVIUmlEVTZu?=
 =?utf-8?B?WHNPNTNKdzNPcTFFaWFpVG56TWVHb1pFUitSRHNYaVFhTDN0dlNBMXE5b2E0?=
 =?utf-8?B?bVZ5OVBaZlFUZDJsVkdHR21vWFF5UmVYdWZVTXNyZmUzU1loL2cyN0Fxd2ZM?=
 =?utf-8?B?NFdxVUJTek0xY09naTdOaTRvQW5QMVNhNytuZ3hmNmZzd09mZitkQzAyekVF?=
 =?utf-8?B?OWR5aVZqcmhEaEx6ZWJ4ODFkNXFDT3g1SnQrSms5YTlGaWxIWEhkYk9yWXZn?=
 =?utf-8?B?UVlXK2UvTDlEa0FHN29IcnJaRkpyMUZDS3VwZWVnWmR6ZFA3U1VzbkN0Z1pT?=
 =?utf-8?B?cCs0WklOWmI0K1VneEowU2RmRWY5dG9aaEp0UGxxbXJqbndDQWFhM3V1Rzdo?=
 =?utf-8?B?eVh0RkhaTDlOeWdBcE1tcW9CcnZZaGtZYURtaDJTQzhxN2dVMmh3cExEVDZ6?=
 =?utf-8?B?VzYxTmxsSmlJYWNpY1hhcEFZRWVRYVR2dHg5bnlUSU9aUWpTWWRwZitiL2E4?=
 =?utf-8?B?LzB6WjJlOWdZV2d5OCtXYUVBdmtkT0JsRXVNcVFvZjB2RDlxWlNWbkNGTlB1?=
 =?utf-8?B?S0QxMFI3em51NDF4Tm5vTDZ1OWY2ZE1sVHA0UGNLUWtMQkJGZzllTldjd0Nk?=
 =?utf-8?B?aGtzNnNscHhMY2tYdDVJR2czVFo4Qm5SVHBSYVpSMDY4ZWFMcTVwRDQ4NnZx?=
 =?utf-8?B?bVdwUkRwc2M4THhTRFRpN2p5d1VQbFlaWjJQc1ZIMlFEZzBNcHdoY0hLZ29Z?=
 =?utf-8?B?bWliM285djJTSi9ldWxFYnJyMUt6WDg5RFF5QWVCOENuUlQyUVcrMXphOEJB?=
 =?utf-8?B?aFJ4MTFqSFRoOFRUd2FuWFoxTEgxUmNCcjRybDhpNklLVkticURxeEhpV2dZ?=
 =?utf-8?B?a2ZsS3liV1ZETkRzV3BwalhUM0xoQUxyL1p6UWJiZlhUNHJJeE92OURUQlpt?=
 =?utf-8?B?WENSV2tCNS9Henk5dVlGY1FhMXdqRldYM2YwU1JyQkxCM0E2clBBc0E3MWty?=
 =?utf-8?B?UmV0QWdUaUdURllxbE9RMy9OUGZ3TTdlRGhBVVRHT0pmREYwNDE2aUtOc0RQ?=
 =?utf-8?B?R3kzeUpnWlVadWE2eFlzUHNadUJQUUhFeER3RTRPUzNGa1NkZTlBQ0phYWJE?=
 =?utf-8?B?N3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03710EFB0180D1479BC6A2BB7459DBBC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e51d326-92d3-41df-33c3-08daad686a1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2022 22:15:19.4315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q7TfDBT8xGssZC51eLwrX61z+GqPNSwoqiCRQbJKtr3NGviP1pBc5Yzz0O7Ct2wyx3tEBy7P5bhj4E8doeZqmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7379
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTEzIGF0IDE1OjAyIC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IFNwZWNpZmljYWxseSwgd2l0aCB0aGlzIG1hY2hpbmUgY2hlY2sgU0lHQlVTIGltcGxlbWVudGF0
aW9uLCBvbmUgRVBDDQo+IHBhZ2UgY2FuIG9ubHkgaGF2ZSBvbiBob3N0IHZpcnR1YWwgYWRkcmVz
cy7CoCBCdXQsIGl0J3MgcG9zc2libGUgdG8NCj4gbW1hcCgpIGEgc2luZ2xlIFZFUEMgcGFnZSBp
biBtdWx0aXBsZSBwcm9jZXNzZXMgYXQgbXVsdGlwbGUgaG9zdCB2aXJ0dWFsDQo+IGFkZHJlc3Nl
cy4NCj4gDQo+IFNvLCB0aGUgaW1wbGVtZW50YXRpb24gb25seSBhbGxvd3Mgb25lIGhvc3Qgdmly
dHVhbCBhZGRyZXNzLsKgIEJ1dCwgd2UNCj4gY2FuIGltYWdpbmUgYSBzY2VuYXJpbyB3aGVyZSB0
aGVyZSBhcmUgKlRXTyogdmFsaWQgdmlydHVhbCBhZGRyZXNzZXMNCj4gd2hlcmUgdGhlIFZFUEMg
aXMgbWFwcGVkLg0KPiANCj4gV2hhdCBtaWdodCBoYXBwZW4gaW4gdGhpcyBjYXNlP8KgIFdoYXQn
cyB0aGUgZmFsbG91dD8NCg0KTXkgdW5kZXJzdGFuZGluZyBpcyB0aGVyZSBjYW4gYmUgdHdvICNN
QyBoYXBwZW5pbmcgb24gdHdvIHZpcnR1YWwgYWRkcmVzc2VzLg0KDQpFYWNoICNNQyB3aWxsIGJl
IGluamVjdGVkIHRvIHRoZSBWTSB3aGljaCB0cmlnZ2VycyB0aGF0ICNNQyB0byBoYW5kbGUuDQoN
ClRvZGF5LCBib3RoIFZNIGdldHMga2lsbGVkLg0K
