Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159DBC4332F
	for <linux-sgx@archiver.kernel.org>; Fri,  6 May 2022 22:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444817AbiEFWoe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 May 2022 18:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444820AbiEFWoW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 6 May 2022 18:44:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1815186FB
        for <linux-sgx@vger.kernel.org>; Fri,  6 May 2022 15:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651876837; x=1683412837;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8MJ4XOuRcZCUz4EG80OY3Gr9JbYpLaOAyErhiV45qh8=;
  b=gyTlCpGC6IS2fHpJ3kWlwGwYdynT5lH3swLWZg6SN5qfZLM47cDHIf6h
   DoBGkp9B9W3vx2IoL/05N1VTSAhey/9iKyF22FzYY0GFWEdmG31Ewdas8
   ammUrT1W1SAepVOFIE65dCmlazzirzh2e3uk8sSvrGuSFYF10XSDGdETI
   WcVnK7LF3wFMG07G+j4lc5M5cyOj2Ph7XUxfStjYqnJtw+G+/8BTNMpL3
   wP5qIS+V8lb3id4vGBsbw3ihuvOV3HhTaWMwsivwEIlCaP+dUptOn5ATJ
   lb+Ey6W8vmfacRJG0uYB/zgMnid8rtW3/hJjGYGrKnEzC3UHZAEapCmls
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="268733790"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="268733790"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:40:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="564065312"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 06 May 2022 15:40:37 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 6 May 2022 15:40:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 6 May 2022 15:40:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 6 May 2022 15:40:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLFImNjc93ydjQ93w05PLgpDkYQOTYCAvRSvVx0N+xFVOyrwQpvs3SgDmwXodsA1dPZ0BOIkL5xQT0jWG9dwGx/I/AqEauspWg2q4yVr3akR4cf8XNFxdTlPJLDKRNieZ+Xr3FfoUmz7X5fvMstlU7ArRE9wHaZYQPAnBABwGGsOJ0Q4SYg0lj3ixkmNOqPpHxx3qemvD3PA6Mk4jax3tpjnEcDM/HNhkJKGxD2bpk2PxBrVrZ+BeJFxgt85G7TG9bZFPdL/wERJJhy8PZhWjBhFfCNzm3M0XqsKlnK0tinc11RvUrHy5F6z42cVWbOvLlKuFIlLR4J3Cm327+e2mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBKoPlz4iTbTBApTN/GzlTUXTd0MqyPpV6vty514g8g=;
 b=dQJUvVwrFV9I1ZiJngHTs89BisAPOBM0l0acKZKy14ICspWaKteffZsMRQDvcqcwH3E8DMMNvFpGp9TuOxotW2lA3qe/buAOK5M8NwlfujRhXxohZlYPKtLzUO0GRER+MkPnZ8OhVtBbOQuP8VrVw99of2ED5CXtJNsc89uvGCBlbOtPQBy8k0W8RPq1JjrbK9+sZ9xjYoUcTxVcgGrqoRpZJXT6R85EJ7N4Vb4Qm1qhdGek8Kv/BGkiMAfIIDqJhYVG3NquGkN4UAn/AGbKZVIJDvpS0toMrSXJ4wQzYdun2JRvgHNEaMJm0X5ohEaVTQoJhEAng8y8kghoPtNT6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN6PR11MB0052.namprd11.prod.outlook.com (2603:10b6:405:69::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Fri, 6 May
 2022 22:40:30 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5227.020; Fri, 6 May 2022
 22:40:29 +0000
Message-ID: <0689f89d-2025-477a-32ab-eebd4090341b@intel.com>
Date:   Fri, 6 May 2022 15:40:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH 2/4] x86/sgx: Set dirty bit after modifying page
 contents
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <dave.hansen@linux.intel.com>,
        <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <b0596095e09ee4a14a3802c5ce91372a0dc21220.1651171455.git.reinette.chatre@intel.com>
 <de2e1a1d69331bb521222eb93b5ffa6d00af354c.camel@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <de2e1a1d69331bb521222eb93b5ffa6d00af354c.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0070.namprd08.prod.outlook.com
 (2603:10b6:a03:117::47) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80da47c2-db12-4606-3db4-08da2fb16c2d
X-MS-TrafficTypeDiagnostic: BN6PR11MB0052:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB00529E25B40A0F4DD2D35F66F8C59@BN6PR11MB0052.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Dh2f4qukpvgSCSsNpDyeyNnH4UzelagUpf4GjxgyOA9C8bN17vmfD/PzmGW60VFGUVc0iNe3dSGbRrTweQpZj3QxPuJsAS6vvK9HFIV0JbJhCGxIiBdw+TTEtWqY1aS/6W2SmKwQ0lu6PlfUHfWfSVN6ibTZ8/pD5PUdinaNEpUtUy6ST2fsbh5nb6mPOQsmX2NR2+roxnoa/0y+JFU4EIZeFGO1GT20JC4fnGXW9s+FN4rsVYnm/nfJTqdANd+OMta6NtmxAAURopYYgkV6jkWMGCLA58PKotCKNkkuU4jeDyKUMCYmnqES7mVGBu8KtYlu8l3iEDOmtfEqSzw7gHQdwsaVwet9jh5kROisxDGGQVvyWltOgF89OlBrQsE7Jw4j6aV3dZuNCDpjU3xPCrEpZtfrfQwEyxEhxrbqQnMkPOcALFl7uIai7wSzacUPcMcWZPwFXoy/ZZR8ZlJkudszdBE0N5wuAraH71accRsIqLjSmF/Hbv3DfMtWc2uwIX+AJfq5Gm04a1nf7ZL6XPaeShMvEB+nDCM6PZG8yxnqrjqFVz9agGFfDSeevJAd3HBUraMlkTEa//KZurAbnz9/6G412Upxy1PcDEKZJYN7D5UsLBYA8x5nsiaYkyQ8swxZBBentwmAqq0Zy20D92+vrhALZha9bZm+Phxv9pxFEXH3qw7xWx68Vzytu7frnr+tKGyPdrwz0n5kwaKJzegbdbjxiO1XCGqbLAeLKgUcq4EUa96EGWRWZSmpVAfT4huaiOaza6RmG9QsYzfdWkokTTZCVhbV8lCffs6hCF8dwT2eVsRNwZA8DpIrNGXPvTge8FNsfEn0VnjxLBKOEyaejn3viHcG+1DmlSPYwI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(966005)(508600001)(8676002)(66556008)(4326008)(66946007)(66476007)(2616005)(8936002)(6486002)(83380400001)(82960400001)(38100700002)(86362001)(6512007)(2906002)(5660300002)(316002)(53546011)(31686004)(6666004)(6506007)(36756003)(186003)(26005)(31696002)(44832011)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTNhc3YwV2txV1FRampyZmNNUTNhRnRyN1lESGFuSkRaaGYrakhnVS9TZW9W?=
 =?utf-8?B?ZnU5UDdYWi9rbDUxWFNwMG8xTUNUcHJZSzJQVVkyVW9YU3hBdC9kTjJrQnEw?=
 =?utf-8?B?TDIxd2xsWTQyWXd0T0VSZ1VyaWs1bWhrWHhwM2ovTUFNdHZTdjErT2NlOTNw?=
 =?utf-8?B?TVBuR2w1OTZqRnVnMnBhcTBhMG84QmV1N3N1M2lsQjVLR2g4SzdnYXpYYjU1?=
 =?utf-8?B?RDg2d1ovOERxWmdqY1preHFuSW1wWVZFMVdTaU1hODJuMVdwOENMeXE3bHdh?=
 =?utf-8?B?dnlRSTVnTHdDVkhzOXJuWmZ1ajcxaGpHZUE4dGlOMXhka2s3Z1FLbWlwa243?=
 =?utf-8?B?NExkcWZEMExPeS9vNUU1VVBtM3lQL2FHV3VEdHlXVmRnMWdLMlhLandLTVJG?=
 =?utf-8?B?T01yYlRnLzZaTE01elBuMWRqTkRIbFpzVE9YZERyL3RjNkpVWFZ6K245TVhN?=
 =?utf-8?B?czBWTElsbmF0dEFxcVRRV0hlSHhiNW9uaUVYRDlXZmRpdTg3ZEhCKzM4RGJj?=
 =?utf-8?B?a0hia3IvNmRSam5DUTl6WnZCNmlIc2FrN0d1Sm1BZUx0Uyttb0dHaEQyYnE5?=
 =?utf-8?B?THc0R2VlSFUwYU0zN2JQS0FMdVpEL1FvM1IvbEp1VFRQN2tvOStPSUhEWHQw?=
 =?utf-8?B?VWM5T2tydEprVmhjMW1HSitLb1ZoWS9OSkNPTExveVY5WFVQZ0ZmS1NEdnVX?=
 =?utf-8?B?VCtjb2M1Nkl3bjc5MGpKMC9obzNUdTJnbGJhRCs2NkVMbFFWSUpEZjVzQzU4?=
 =?utf-8?B?MytrUWFtRmJQYzJaR01ibnh1N2xTaHpUWmQxRkk1L2t6R0VrclFZYzBBay8v?=
 =?utf-8?B?c3pCeVVpQ0VHK1RpV2pMell2b0F6MERKTW9NUnNBcXduVEpQaXJZT1orcDlv?=
 =?utf-8?B?VXpXUEoyV0pCZWNVL3dwb3BrRGhmWGNxbE0vYXNUWUR6UURVZVFZYjBTT2dJ?=
 =?utf-8?B?NTdmRVg2TmRrL0s0QjhlUFhrSU1pRC9CaWdUYUI2MmQ3V09ma1BieVRBSURn?=
 =?utf-8?B?K2VpOU5MbkVwOU02Tm9GbGJ2Um1ub2dpNk5PWWJ4bldkUGpZNlhISDVoVUdC?=
 =?utf-8?B?YVpaK3l3NTJGYkNyZ2Vwa3NIMENBWnR4TSsxaUpmY2c1ZlZKVWFybEo3UnI5?=
 =?utf-8?B?NTkwek16OFBiKzJJT284Z0RKWDJKOXZ2eWo1NW5pT1A5cS8vTFo0RzA0ZGto?=
 =?utf-8?B?cE9SU28wM3FINTFKR1FwSkVnazJaeG9oS3dML3NJcDQrd3JNd1RTaEFNU3BM?=
 =?utf-8?B?b080bHJFZ0NPVDhiVFlRUHVTRWV1dUpxRDJnVkxZSS84WnNQd3BmUDNzVzRo?=
 =?utf-8?B?akhYV1czQnc5V3AvalIxak5ZeDBYd0IwM1A5WXRXOU9LWTkvVk1rdThyZm1V?=
 =?utf-8?B?b0N1bWwxQ2JRdFRLeHdJN1pqYVNZa1RPSndwMDJaU3JTMXJPWHFjTTRCWkRS?=
 =?utf-8?B?UEFEMWhteXA2K3l0a2FyT1NwMUE0NzdMdkNvc0ROeGhTd0dMcS9vK2xOVk1i?=
 =?utf-8?B?OW4wcHBEN1IwS0w3NUJ3R2k0OUl3elZleDNIMzZ5dzZSYlU2U3dqRHl2a1N1?=
 =?utf-8?B?NTVVNXFSc2Y1MXBEdEcwRjZuaHRza2FBWnRqclRvTFAzdXYzVnVrY2lXRFF4?=
 =?utf-8?B?aXZlbUJsaVRsa25NT2RPcWdrN0ZPYXFIVU5IQzIwUEtScU9Pa3FoQjBZQ2pY?=
 =?utf-8?B?bVVYVUxxSkJ3TFhKNkYyeWlvQU9hbDZZN0tWMVByVi9KcklhZWY5Slk5dEhr?=
 =?utf-8?B?Ykpha294cU02Q1lDT1NlOUt2dXBZWHNvNk5UWnQ3Vk5RUXpmQlBlUEY0eVFJ?=
 =?utf-8?B?QTdFUjZVU3hkQVh1QXZUOGVkWUF0VWFoV3kvdFFKbEdRTElKTmhiUE9zTitq?=
 =?utf-8?B?TkJROUR4UlQxeFhIc3MxV3hxTzloVGwzQ2pRQlBMVVhRYm1maDBXYjhhN3BM?=
 =?utf-8?B?MEFOSG8xdWlTcG1HL3N0RW5PYUh2aktEY3EvdW5yR2t4Yy82TXFSTUxMaDUv?=
 =?utf-8?B?blI0WVIxdmExNGw2RnRlSVhGY2Rla0krNnNrMDhmdmpocTUwYndQbXVZZEp0?=
 =?utf-8?B?VG5INzNlSzZsVjJrZWZiSjdndXlrTUtXNmRQbFpPVFVHS3g4UER1RDMwMUpK?=
 =?utf-8?B?OHdCT1dWcGEzQVNxc2lxQzBmMWV1QU5YVW9UTEVJNTYxM0N3Rk04N1A3YXhw?=
 =?utf-8?B?MTFhYXppMVJ3YUdzNGM2MkhGQmFtbTdqRUVjQkNIaVVOUnUrSUFpOUVjdndH?=
 =?utf-8?B?Q1hRM21rQTY5RDAyR0JpMzJabFE0QzZZSHdNdTVZMDVzeGR0TnVnNFBRVjZr?=
 =?utf-8?B?N01QZFd1eEQvM25odUJsK2ZGZGFoa2huV3VQS2hXZXA3R29VdmVxSjc4YTlU?=
 =?utf-8?Q?wNJFYEiVfcNaEQFw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80da47c2-db12-4606-3db4-08da2fb16c2d
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 22:40:29.8686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rF1Lew/cHID8UVFlEjYwhZFQnTGCOiMu1cl2Du9BqaYe2tIi0UIwU/eQuSg5NNMK7q+N0DigQMlXfa/hsdp7bAqngFQ5UB8ccuQuHdGC6SY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0052
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 5/6/2022 3:27 PM, Jarkko Sakkinen wrote:
> On Thu, 2022-04-28 at 13:11 -0700, Reinette Chatre wrote:
>> Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
>> after faulting the enclave page") expanded __sgx_encl_eldu()
>> to clear an enclave page's PCMD (Paging Crypto MetaData)
>> from the PCMD page in the backing store after the enclave
>> page is restored to the enclave.
>>
>> Since the PCMD page in the backing store is modified the page
>> should be set as dirty when releasing the reference to
>> ensure the modified data is retained.
>>
>> Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
>> index e5d2661800ac..e03f124ce772 100644
>> --- a/arch/x86/kernel/cpu/sgx/encl.c
>> +++ b/arch/x86/kernel/cpu/sgx/encl.c
>> @@ -98,7 +98,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>>         kunmap_atomic(pcmd_page);
>>         kunmap_atomic((void *)(unsigned long)pginfo.contents);
>>  
>> -       sgx_encl_put_backing(&b, false);
>> +       sgx_encl_put_backing(&b, true);
>>  
>>         sgx_encl_truncate_backing_page(encl, page_index);
>>  
> 
> So, the implementation is:
> 
> void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write)
> {
> 	if (do_write) {
> 		set_page_dirty(backing->pcmd);
> 		set_page_dirty(backing->contents);
> 	}
> 
> 	put_page(backing->pcmd);
> 	put_page(backing->contents);
> }
> 
> And we only want to set dirty for PCMD part, right?
> 
> Thus, perhaps we should fix it instead by:
> 
> 	set_page_dirty(backing->pcmd);
> 	put_page(backing->pcmd):
> 	put_page(backing->contents);
> 	
> ?	
> 
> I would not mind getting rid of that function anyway. It's kind
> of bad wrapping IMHO.

Could we rather just change sgx_encl_put_backing() to be:

void sgx_encl_put_backing(struct sgx_backing *backing)
{
	put_page(backing->pcmd);
	put_page(backing->contents);
}

Two reasons:

1) Instead of getting rid of sgx_encl_put_backing() we can keep
   it so that its name reflects its work and its usage remains
   symmetrical to sgx_encl_get_backing() that will stay and
   the code thus continues to be clear on the page references.

2) By moving the set_page_dirty() out of that function the
   set_page_dirty() can be called _before_ writing data to
   the page, which is the right thing to do per:
   https://lore.kernel.org/linux-sgx/c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com/

Reinette
