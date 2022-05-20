Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECAFC433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 20 May 2022 06:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbiETGlj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 May 2022 02:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiETGlh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 20 May 2022 02:41:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE7A5713B
        for <linux-sgx@vger.kernel.org>; Thu, 19 May 2022 23:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653028896; x=1684564896;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=28ttyplZg3jBj6rvnG31iximn6S0CX8p9jHszUrXlm0=;
  b=HamCPQh/iR1hDTjrFdzXUXS4z9qbzH4B+EKQZRjVPZ79zAfMaqOrFWW6
   B1aeAD7L3Tgbl2ZON0cuZPM8WpFRewqecvcz0sGMHBbAXrZqBaZTB9InW
   AjKLjwFMrPH61sKxMve16KEPNp0PlDxgYrCo53l6QipxTx9se7/oNDvSi
   Z6SV+Oe4bIkJZnw1sl5BTAs9wAY8QXNzhCPjwPRtz7fl5Czt+bbmPJ7LU
   hYxKpAJ8qD78ITxG2lEhRA8TOfCbWK8eekDX+qimOFKxQC1m0MLSRtPy4
   b890KffW9FnyGsjnnfMP6ZR4ceXFnOuNsevqqtw1WrGJ+oT4tutMWn0fA
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="272483376"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="272483376"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 23:41:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="701606470"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 19 May 2022 23:41:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 19 May 2022 23:41:29 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 19 May 2022 23:41:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 19 May 2022 23:41:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 19 May 2022 23:41:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7uNalUtI3y982rsRaqr4VZW5oKvrSi7cxB2l/ool8Qt+YN+ID3lCBTx8J6MMrEKtzeL4FobkFQtv8X+qCSa5+g9KrkITjOTDIrb26oaQj1hSr+LIgCz4uvU8ZO9kjlsj1MxwjG2X2BIgnQX5IBrIAuoy8uhSNV/HHcYEi7ukWhdHtXlJXrQtHwlwGYq6zvcO7FELuRTq07Kcg9ksg3dXJK3mPxxvsHJ1bBqserEKodO0n2cIc71vs3FsB0BXkD54LrSigPoq926w55j53JC1vJ9PRJg9VpWQ+0vSgnD2rzEcd9q+/wgD4CtbaTmSpn4UAozG++1y3+lZK7dJ6HUIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggTyq46ZVGbYcGw0sjx2Y6f6vA5T5RFmJIZurAiRCrI=;
 b=WvtnGer7o8nGbstSmlqc/OL+kO25WIyzohRJURqZIZ5ri4Z87zLFGShplDqEbtvB41wM9iXNEZ7c52vz3PGuWzOx8XXxuzdHKcFYDzidpxqCxqAVk43NWAkvrBANnulDrIAtlqC09V4kPv+l1kIfkOJ+iIopPyIwKIUkdCQFdz0rndWPTdpvcTKupi7LfBod5rT8Uao/9xArh50ick5iGDjTP+cKtbe9hrlk7Q+xQ3Bf/wgmBx8Tk9y3dWxFRyWLt17yTNSN5YdBdEM99Jj0RSipxqrS3XA2TayE30nnAwoMdZ1Jy0uLuqAvEXLkqoWxTMWe/gpoarLV82wpymJayQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by BYAPR11MB2645.namprd11.prod.outlook.com (2603:10b6:a02:c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Fri, 20 May
 2022 06:41:26 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342%7]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 06:41:26 +0000
Message-ID: <694234d7-6a0d-e85f-f2f9-e52b4a61e1ec@intel.com>
Date:   Fri, 20 May 2022 14:42:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 2/4] x86/sgx: add struct sgx_vepc_page to manage EPC
 pages for vepc
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
CC:     <linux-sgx@vger.kernel.org>, <tony.luck@intel.com>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <fan.du@intel.com>, <zhiquan1.li@intel.com>
References: <20220519031137.245767-1-zhiquan1.li@intel.com>
 <Yoa76TmwHPeS7vRG@iki.fi> <Yoa90l89OTQX0NYk@iki.fi>
 <3be5e00db1f02913139366c32efb892e6eb71292.camel@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <3be5e00db1f02913139366c32efb892e6eb71292.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::13)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c5405eb-33ad-469e-ee4d-08da3a2bc328
X-MS-TrafficTypeDiagnostic: BYAPR11MB2645:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BYAPR11MB2645F21D1A2FF25E9F21F382A5D39@BYAPR11MB2645.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XlGvD2XBodaoRmMK2xZvtOKWjeZDMbypeGnO6FooHPi7R05IVtuu8FhL7nzvLkw9Br3bIDisP3SNU/E4oC/ITC2/aS/PHCRKmftxzSirAzZjaIXvMmdX+L6yW6bC5JzQ96ANYXNFf9l5sWuQngRmA8NlkD6jj+kAuiLuQ9UyRIxBuKJqptKTvxeITcn9VHAH6EVJzPuMTylOW/6dVjBnXVKjWocToCevdmuWjp/bC1KwdX0Y/TulHlU4+w305fZEUNNtQAmU7CPutLBdrzx4Q8BDK0bG8QICYHTUnGmRNYF2SYcFOUaAo/USkFY9hM7yXUePeHJtzyJV+OgUVL+fw63JvlALVZZ/pr3NqvIqaacY9rHWqc48TWKkQKC6ju2q0cceAEtoZ7YIT8lnRxxkupownOjVLcD3NS2+ND8iaY0T7X46rqhlnrqn58+B9jT1ReBpVvATb8xCrO7tOI3zC3BtWuaj45dPVeZt8E6CxCfphkVzQEFoirkThgVbxVOmHS/M5Dje+GpWsGhH1St5L+k9s0rHWV8jHDvPnECyudNZqOfEXdYRaa5GXefx9QFgKLbQqPfuaPZLN25X296u975h9oDYazDzD6Fk7S4y/8JaSKYq2NrIvTUeXW9CEO0wjg4BWVLsA54sL6k1pqF7epwrXQy60vgW1DuU8ejgBishoqgqNC/8yipgLloz5fW+fZd+rARHJgdAMM2XgYtH5X0t0u5qpy51rqD1U+7GApg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(5660300002)(186003)(2616005)(4326008)(31686004)(6512007)(36756003)(2906002)(26005)(66946007)(508600001)(110136005)(66556008)(31696002)(6486002)(6666004)(6506007)(86362001)(82960400001)(38100700002)(8936002)(316002)(66476007)(83380400001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTdYWmpYeWEzZG1ucFNOaUQzRE90QjB3VHc2NHlsbktOblFTYlBDZUZHTXR0?=
 =?utf-8?B?cEZQMS9xcWNNNmNMSFQrV3JZUUNkRWxlTEdTZUZVY0Z3UXFUQVhVR3huR0NH?=
 =?utf-8?B?TTdFM0c5MjNuemc5aDFmcVc2MlRXYkI2NkV1dmc2dEhRc1IxQnFRODJvMmNM?=
 =?utf-8?B?SEt3ODNiaTYxOWIyMjhhcjdIMmJ6cGlsWGh4V1RDdGJmcjU4ajUzZ3hBUi9j?=
 =?utf-8?B?U2x4RDI0WHE5ZFdxV25oRnFiMlR4STc3THhkYitCbmZVUE5jVU11TGtCR0lt?=
 =?utf-8?B?bjVxVjd3RDdXeVpUdW1EYTB3LzMyZ0k0TEpQK0oyb014NlJTaTlrbXo1N29G?=
 =?utf-8?B?U1BBZWlxUXNDdlAvR2NzM1Y3SEdydnEvRnhabjZXb3crVUYyRmRMc2tzZ1Nh?=
 =?utf-8?B?SmNNRHRTSktFV1d6d3RnRmhTb2FqdkloL05hSVBNTEtlN1pRYW9QYXdRc1pm?=
 =?utf-8?B?NTlyek1YYmhxNlZyOW1zbk1pSFBweHFYUEszdEo5Smx3cFJjbXovZzdpWVJ6?=
 =?utf-8?B?akhOUUN4Z0VTUlVEM1pxZlFibldTN052Q0pnT1VIblAreEdBRDZFVXRJdDFZ?=
 =?utf-8?B?cEVLZVRTZ0poamlXckVQdWYyOWVLMjIzY1RYMHEvRkoreDJrTkhnalFVc0Z0?=
 =?utf-8?B?TU1CbjE5NnNoM2ZEb05sbmRmWkZyaFRwQ1VadzVud3cxZWg1STRER0pnM0do?=
 =?utf-8?B?LzBENXVQQUg1QWQ5Z1ZnYXdJRmgySEo1UXRjWDZwTDYvRDR6bHpQaHdWK3BJ?=
 =?utf-8?B?NDB0am9ERTE5V0x2a1R1MWNnVHFXQWM5bU1aYTFjYjFySGIxay9CblRrOEhG?=
 =?utf-8?B?Mkl6RXljem5ndDVpT3cxK3JheXpodkpjTWVJMEg4UlJKUEE0R1AraEE5RDdV?=
 =?utf-8?B?MVc1TFlRcG9ULzBZYTJINjlKWklaRU5sdlRJL0h6V3MwaUdyL1JuUTJrMW4y?=
 =?utf-8?B?NFY1YmtGSmlXSlZEQitSL2V5LyszMndmOUhrMjFGODZRazJ1M1hJVUsxNTdv?=
 =?utf-8?B?Rlc1QkxKMWJLUEpYelJmckRLZzYrOUxlUDVEVzByMVRGejBMdTJjQ3RTTnhO?=
 =?utf-8?B?Z3pXQmNZVFc5UXQ3RTJBV2hqV1BsZmUySlRBdWRMVXhpUGdTbElFSHhBdFRk?=
 =?utf-8?B?M1luQVM3QXd0VmY0c1ZDNjY5RGdhd0hzRzYzSDVHbFQ0ZGc2cWxLNFpZaUdo?=
 =?utf-8?B?dmJkOUVoUnFyOGRTeE1ZNHFaRkVhQ1FsaXU3ckE3S1l4SWtZQllzQ3JEY2tW?=
 =?utf-8?B?MHpLOXk3YXprbkt5QkY3b0srV2ovamRsOG1KUkVBenF3WktuOFdxcEk3ekVO?=
 =?utf-8?B?NU5KeGpoSjZFTllVcUU4M3AyaXlTbXNaYnd4bnAzb2Voa0xSRUJFQ0dEUHd4?=
 =?utf-8?B?Vy94a1RLVm8vU3k3MEFSOGJ3WXd3TXgzSE1yNyt2NkNYVXhHQlo5SnhHeld5?=
 =?utf-8?B?ajFpQmNKN25sM3FRVGdVUUhtd1RvQ3VnRll2Zy9PVkd3VFBuVmJldmF4cXpt?=
 =?utf-8?B?K3c1K1VVQWpPZWFqM0FReHV5VktPMzZ4RWI4M0NHQ05ycllRV0F4SjJJQzl0?=
 =?utf-8?B?QUhycnEwMktjcHoxMFR3bWRpTVozY2Y1TTY0dVN6dUs4VGdNbGdlZTRoWW1B?=
 =?utf-8?B?V25LVXFOY2FTQ01aYUZOeVk4eVNwUWNJNnBWVG1FNzNubnMvaHlTRFlHMm41?=
 =?utf-8?B?QmpZcDdMV0Z4cXBneG52UHMxUS8vb1Z6azRxaDZ4WXhTdkpyQUpNSzlBdG05?=
 =?utf-8?B?U3VsbGZpV0VUV2xJUVpVUXFycmd1MXhlYkxKM1RBYU9hZ25uQnR5K0wwRE52?=
 =?utf-8?B?MnY5RWFBSnVmNnN3NzVPeEJxYzJ4aG9QYnRYNFowanNuVjVUdXlVZzFVVWdl?=
 =?utf-8?B?blQ3SUJwaXhlNVY1NDB5Ykxpc001VHJyMlVzV2hFRlZpTGlDNU1hVGtrU2c3?=
 =?utf-8?B?aEV6MmNERnpiM2hwNEhzWmpMVE9GMStlcWo5MTJpVy9XOHdQQ0tnK3Vtc285?=
 =?utf-8?B?OS8xOFdmSXEvUzFMUU80TTN5OVFYYkxhNnBRK3BjZFE4Nm9idHp6QnZZM3N2?=
 =?utf-8?B?RUdFTlFBRnpIcUpROE5raXF5MkZqa0sxMVFjUWZQV3hhYlNocC9uMi94K1h2?=
 =?utf-8?B?VE1teHByZVNZVHZyQzZMVUVqcENYZVRlWnc5U1BlcTYvaFB3OGpsNVFBNTBx?=
 =?utf-8?B?TXpNb0Noc0kwYWlXQmVvazg1NlV3bnp1OCtTbUJmdU4zaFpjdlJPL0Vpc1Q3?=
 =?utf-8?B?dHlPU2lIcHRqdDV1QXlsR0pFdDlhdmNXdjNid21ucCtOeXZwRDlCUHhFcjYz?=
 =?utf-8?B?U2ZvMW00bXFDZGxXMFd6dFdRVDBpSDc1bTlsOURNZVZKVmJ5a0pQZ0pQMzZN?=
 =?utf-8?Q?T/ZPfzLFTIVyXG/Y=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5405eb-33ad-469e-ee4d-08da3a2bc328
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 06:41:26.2653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aumBCJPGRMKd1J8ta0Wnb6WNNhvNxzVhzeuaYVzY9CCkvWj/+akelDkqpdUXa0/I8ndjQ7zxzklcxCatgadgJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2645
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/5/20 08:48, Kai Huang wrote:
> On Fri, 2022-05-20 at 00:59 +0300, Jarkko Sakkinen wrote:
>>> I think this patch set is going taking wrong approach. Instead it would
>>> be better just to re-use struct sgx_encl_page.
>>>
>>> Things will get out of hands, if we have a struct of each flavor of the
>>> same entity.
>>>
>>> Additionally, it will take virtualization code a step closer to be
>>> feasible for the page reclaimer consumption.
>> I have a better idea. Why don't you simply store 'vaddr' to 'owner',
>> i.e.
>>
>>         epc_page = sgx_alloc_epc_page((void *)addr, false);
>>
>> The new struct is useless, or harmful, because it consumes memory.
>> SGX_EPC_PAGE_IS_VEPC is there to interpret the meaning of the field
>> correctly.

Many thanks, Jarkko!
It's really a good idea.

Actually I've ever considered re-using struct sgx_encl_page, but in such
case we just use the field 'desc', the others four fields are useless.
Which means a virtual EPC page will have 32 bytes additional memory
consumption outside of VM.

Repurpose the "owner" field of struct sgx_epc_page now looks the best idea,
there is no extra memory consumption and the code changes are more brief
than before :-)

I'll send v3 after testing.

> This is also fine to me.

Thanks for your review, Kai.

Best Regards,
Zhiquan

> 
> 
> -- Thanks, -Kai
