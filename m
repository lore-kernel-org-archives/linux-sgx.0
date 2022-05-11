Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D71C433F5
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 18:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiEKSC5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 14:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345991AbiEKSC4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 14:02:56 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C030F7EA3C
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 11:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652292175; x=1683828175;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eFFsYL+/61kmkovMQjBj3kU3+DpnWE2gMyH5hUfIqWc=;
  b=WBde1BrvXsGmhyfzJ2z91swztRPjMrIZ/WOirHnSzR4CCwJRXRxtKy9w
   HVD+Y3YSNlJ3qZ0LIfaX6PXZmZP69sZLJk25nQh98ruGzInsL7CqMEjMR
   xtcYuK7Sxv8pTFow0LeUGhn1tstkNgAxGo9sau2QIRdXNP8RgUg5NUukp
   U9vf0mjHvJbUKQpBsc9Bq3f6EmO6twDUG4iR07CgNe87KpX8pXyEFvBiw
   HSMk7QQ1B+r7hYBTGEKe88gdfruTeWOmTm9KhHsGAi31djNxeaD93R/BR
   hts9pJzJDLn/tGtvEJzfUn8y7B8maEWtUtAwxOyyzRWeR8Cswln1AxXef
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="330373496"
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="330373496"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 11:02:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="658261737"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by FMSMGA003.fm.intel.com with ESMTP; 11 May 2022 11:02:53 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 11:02:52 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 11:02:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 11 May 2022 11:02:52 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 11 May 2022 11:02:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i14YVwMdbKJDfdKTaqNxFO+VnVRDZkzRQ/nHis7ohYGEUm4LVsYPJxeY043PqveWf09F4g2Rs5LVsW+YmfN6E1Jqdt7GUL7DSFtIVkagFTOFUmy/TZ58BjXR71FoxCXLkWyYZ3em/HgY77QrZ8ljh3U+VT4h8prndJB7de7AiZ1gypjUUTt/AMej3LIdBEmtrQedzi6J0KFydvDyPLIFshYMNUDzeL328MlnuDUW017+yVxcfCxGilJtWuKZ/Lal/PXdj9iFrXMG2xx1F846aLpW+sgFzUECRgtzhM80JYHZBm8ZTRRAlkcphcaDCJeq+AcFFJCrp56GU5re9MKxVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x425Piba1XZ3vmKWPPsXgVXwiZnJkNNbdJ5GBiTvhvI=;
 b=AIIsh+OZhLW02+9jNmbLnTOho6qBTS0liwulMaAaz72r20zhZMG2CjlvrhJD0N+/jEWBHipDyb7uOuBo2e4Wd4mIdKDNB+ZWCgi2JcKpbsHx7k5DVFT/s2fxEdX7n7oDLI6rSpLEMemR0w/jNA7n1WUGmnbBovusXW7afdiQrJwAP2yK+I6MCOi3WF6NeIPTOQjFbBs9A2MfkhBPGKLwsKxWFKN8o3lVlanR/5mdZ8v1qVUjRFUuRwMw5T2STX04t4YifWtrdfepcDS9oNcRf4/TFWNM/cfs1obnkIdt1oRRMNmkQGX7KGvivF8lf9fpDVhbZl5gv1S2tcnKR1G9Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5740.namprd11.prod.outlook.com (2603:10b6:610:101::7)
 by BYAPR11MB2533.namprd11.prod.outlook.com (2603:10b6:a02:c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 18:02:50 +0000
Received: from CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::5043:8c48:2510:3ec0]) by CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::5043:8c48:2510:3ec0%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 18:02:50 +0000
Message-ID: <420e255f-08ba-9077-fb4d-8a5fa81fa1a1@intel.com>
Date:   Wed, 11 May 2022 11:02:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [PATCH V2 3/5] x86/sgx: Obtain backing storage page with enclave
 mutex held
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <dave.hansen@linux.intel.com>, <linux-sgx@vger.kernel.org>,
        <haitao.huang@intel.com>
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <b98b7b0d60778845eceb4e279b4354632b7111f2.1652131695.git.reinette.chatre@intel.com>
 <YnuacaADPcuAFkDB@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YnuacaADPcuAFkDB@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0023.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::36) To CH0PR11MB5740.namprd11.prod.outlook.com
 (2603:10b6:610:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0fe984b-d5d0-4a10-9f78-08da33787679
X-MS-TrafficTypeDiagnostic: BYAPR11MB2533:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB253307DC80AD7EFB8E0C3CA3F8C89@BYAPR11MB2533.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eP82ZVQw9WZtgJfTrexKb7nycmu+H+6xlvJN+j7cLTA3gvK/5q3Oov1Is3OP6eCYBfeA/gFBDw6+1VhIfPgN6nmDVp0HCU//zFHKB70CXOomtd1QvBIp3ZzVOunCoxbF+EWjo8T4YoHh8/8Sm34h78CZoVNi4WrYU7MNVKus7yOkeraUhrv+pX9BlWMguWBjFT9sT7GQ7ncXspgCDr3u5kMqjbogaDxjG/psl+xoEAedNTENlVq99QBQZUSaAMW7ObL22P7rpXgFcd2Azzssd+i/ZfkoginQpXtV6Hx/fZqF2quwK+yiJq5eemFcgV2Ny6jHOiegUkVUZoqrswDp9vLkzYltQGaNAmrQQ97PEJ3dom6HpHUNHM1i3i05mJmNBG8sztjZm1Q1eA0WPeDhSEEtMZiJnyBH8Xu5RcIFyiYfWJ2CICsGja+zEauFwI6jfoMIOb80SWvXv+/8Jz3zeJQinqp1OkoOAyfX7zHqy8i5XKwk8nfqFvwKJHd6rp991GRPj4LZzpKqvRAiyhByORIOrH7er/SPZr2tgB6d87cZSc8eHzlbClw6z8JK6X7UgNEATgPhKNAzMv1NGWmc/1VV/WpTPaeq+MT6vBlsnGemM4VPAUj4tpUMROWeoZKxSaIKV0XrWz4mHLiicLretlQq1pNenqv6yOOwtgFmIk6j/BFAOPGPKk685Vcb7axISepdzei5WSE6QOa8uSS897GEem/GeeUKIB4T2bLTJKEHzqXggv9b6bOzA98vaW/N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5740.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(31686004)(83380400001)(6666004)(44832011)(2616005)(26005)(2906002)(6512007)(36756003)(86362001)(82960400001)(5660300002)(6486002)(508600001)(8936002)(38100700002)(31696002)(66476007)(66556008)(6916009)(66946007)(8676002)(4326008)(6506007)(53546011)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejh1cXFpNTZMZVpRTEkrVHpTYlJVNk8xK0dQY2NjQnJva0k2T29ldTdPalo4?=
 =?utf-8?B?ZFUzVUczRHYzdzBCNWg1MzZFZ2wwZlJZRVFtUlZUOGhQd29tZ2g3Q0tWRnA0?=
 =?utf-8?B?MlUyNEdKa2Z1cm9VOG51MnZJaTRBUmZEZWJja1dmOVljbmFsYjNWQUZGcVB1?=
 =?utf-8?B?ZGsxWnIxK29QU29MMXJ4UnhRenZRMUhITmV0UnQvbllHVHBOWWJxUVhpdUZa?=
 =?utf-8?B?RVJhQ25qNW85TnhUWmFONld5cEVuREovelRCOW5sZ3pnOFJEVzRJS09Wd0dy?=
 =?utf-8?B?R3RzcHlzYzIxVkg4YlN2d1NYMHpIZnVJMXhjUmdneG44clJZbENxc213TDds?=
 =?utf-8?B?R0wvNzl4L0RrN3FwQ0ZGL1RGY0RpOVNsN3RTSkMwRE5uMzI4d25jYUZPcUMx?=
 =?utf-8?B?bFF3WmJFRmppOFF6Mmd2dy9zQU1OWkp3cERUMEJNbkYwSVNLSDBJWFR6aExV?=
 =?utf-8?B?a0NSSnJGdUU2SHVaRnVVR2Y3RmU0SzlULzZYNWZrRllSMkxCa0w4RVNCMUhw?=
 =?utf-8?B?dk5qVW12SkRSVW8yazN5T3R1Z0ZzSkdLWmZ3RnFOOXRkcGt5VnQ0Sm9lNHJ0?=
 =?utf-8?B?V3RTMW5wOGxUTlF0OHpIWmFEekc2dWwyR2Q5YmpXUVl5SUM4TkJwYUI4T0dJ?=
 =?utf-8?B?MXphcGhqNklYa3BiT0pKVkt4TjY2SXlHdzNpbW53RHhuZjBqTXRBWS9mZ0ky?=
 =?utf-8?B?RGRKQUR2SlByUndLMjVtUGpGVlNnb3luazJFOVJybUU2a0pQNFVDSjFvS2RX?=
 =?utf-8?B?dURTUFpQaVBtRUxuVlR2UlErblJTYnJqbzI4QkU0WU1JcitzYUZBRy9JZlJy?=
 =?utf-8?B?WXBXWnFGNUpmTXJEZkFkVGFHUkV6V0tFc01HOTl0WDRudU0xa3BzSHY5Nmha?=
 =?utf-8?B?akpZbnBlNW9QUGdKcW1uYStXUEd5RVYzMGJVNHpzaFFCYjZMKzI1bW1xNkZF?=
 =?utf-8?B?enZGR3Y5SU1pNGJOdFFzNmozR2J3bzdqdzNCVHJPTG5Tc1E5N3R2bTNEdkd2?=
 =?utf-8?B?OENMajlVQ0lMS0dHcXlwRkVOUjhTV1BxOHJSbGxkYmNwSnZZOWNuN3lxbC8x?=
 =?utf-8?B?Tm4wZ2pOczdQbVdZMm9ON2lFVk1uL0pMVFhxMWlyTE5XRmU2VThTcitNQmNu?=
 =?utf-8?B?c0V3amI3NlZ0cUZTOUdXTXVZTlczY3ZscXJXNHVCRjU4Z0k3K0VudHRuOWFC?=
 =?utf-8?B?MVZYQWw5aWc5ZGd5OWhUd2YzanFWeHFkbHRDbEMrQThzVE9IZzVmdGN0emJx?=
 =?utf-8?B?MGZwSFcxK2lIeUx4MVd5L2pxdXFxeUtQNUh6VXFQbm9lbFFQTk9qdG1weDVC?=
 =?utf-8?B?bGtDeDRSSm5lYWMySmxqVTFLSU1hamJaS2RuV2lPUHViakl3WlhEVVArdisw?=
 =?utf-8?B?emMydDJBQk55VXZQYTFZanpIN2N3Nm5KWmhUNVM1Mm1DUGR0Qm9ORGprM0I0?=
 =?utf-8?B?SW52WW1yYi9pdmZqS3BjRWNWRERuWUkwOUEzSzIzZUFRbjZxME9nbkcrTnFF?=
 =?utf-8?B?eXAvcVpucW02Sy9uVVpWSWtGZjlZNFNrQU1KU2g3U01FVHl1WnJxeWE4WHBv?=
 =?utf-8?B?b0c0a3VzclBoWHdzTmlWOW9yY21UdjNIRmlBbGdLV1VDLzRNTTh3YlNBci82?=
 =?utf-8?B?bDB1eVRvV3hOeFJueW5WWEh5elRuOXRDYk14TXZxN2RCa1BkQXpjOXZSQWsy?=
 =?utf-8?B?MnR0aEQyQlV1MUYxMkIzYlZVVm5Oc2FQcE9WeUwxT09PTHo2ZDF2MWcxYzND?=
 =?utf-8?B?VmV0OWdSSEJaTEpXUFVPME9xa2x4WDNRQitxSVJxSmV1L0FPKzB0RGFJUndD?=
 =?utf-8?B?dEVIMCtTM0FNWDZuVi9KdzJydnJqVFdsdGlSZ0EvZmt6NUg1OHdJS3l5Skxs?=
 =?utf-8?B?RkZRczRIL285Y2NoTENRR05IMWNIbUNWN2F3QWIxRDZYM1JpWVNGcmpZOWZQ?=
 =?utf-8?B?dTFGYitvTHhsakpHTGhwVGYzS2VlanVrdEZRK2xmUjZjRnN1WE5EN1Y5TURa?=
 =?utf-8?B?YzdzUHU1RjRPaUw5WGRGcDZGWjZRM2YycnVjM3BaWlkyUzA5Z2U2SndLcnMv?=
 =?utf-8?B?RkV3YTlheTZnRTI5dGV4MjFlMVVNVjFBMVZjcEFoOUtndjg0SXVmUFZ6eHJw?=
 =?utf-8?B?MkNnQUNBUmdUMk9uOElHaHNwRld4UTBybFRjaGYwT1V6OWJkMlNBcHBFT3dT?=
 =?utf-8?B?QU15VUkvK3hpZ3hGNEJJalZJQkVVQjl6VXM4TUhNbW9RcnE2N0dxK2tKZFNG?=
 =?utf-8?B?b3o0RzdRNTZKMHVMWEZRNnlkT3RzRSsyZi9hbzU1N1Q3UGFSVUUwTldMNjRC?=
 =?utf-8?B?YmNKMk9ZWk5KVU1aaGh1bkVCdGMySEhlUXNzdkdxcG1MMjVTckkwajVSLzJy?=
 =?utf-8?Q?734opD3PrzP8I6uY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0fe984b-d5d0-4a10-9f78-08da33787679
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5740.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 18:02:50.5151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1q1NE+cYJv8ffPluBvpZ6Q5YyffGF7kSqH/ua+omG/8eeVDs1YlmYEEzlKcj49kIQTDobdyjs/xZD5wojKOsdOBCodf/FT6KasiQxzvEak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2533
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 5/11/2022 4:13 AM, Jarkko Sakkinen wrote:
> On Mon, May 09, 2022 at 02:48:01PM -0700, Reinette Chatre wrote:

...

>> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
>> index fad3d6c4756e..a60f8b2780fb 100644
>> --- a/arch/x86/kernel/cpu/sgx/main.c
>> +++ b/arch/x86/kernel/cpu/sgx/main.c
>> @@ -310,6 +310,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>>  	sgx_encl_ewb(epc_page, backing);
>>  	encl_page->epc_page = NULL;
>>  	encl->secs_child_cnt--;
>> +	sgx_encl_put_backing(backing);
>>  
>>  	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
>>  		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
>> @@ -381,11 +382,14 @@ static void sgx_reclaim_pages(void)
>>  			goto skip;
>>  
>>  		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
>> +
>> +		mutex_lock(&encl_page->encl->lock);
>>  		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
>> -		if (ret)
>> +		if (ret) {
>> +			mutex_unlock(&encl_page->encl->lock);
>>  			goto skip;
>> +		}
>>  
>> -		mutex_lock(&encl_page->encl->lock);
>>  		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
>>  		mutex_unlock(&encl_page->encl->lock);
>>  		continue;
>> @@ -413,7 +417,6 @@ static void sgx_reclaim_pages(void)
>>  
>>  		encl_page = epc_page->owner;
>>  		sgx_reclaimer_write(epc_page, &backing[i]);
>> -		sgx_encl_put_backing(&backing[i]);
>>  
>>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
>>  		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
>> -- 
>> 2.25.1
>>
> 
> I get the locking part but why is the move of sgx_encl_put_backing
> relevant?

Moving sgx_encl_put_backing() accomplishes the locking goal.

Before the patch:

sgx_reclaim_pages() {
	...
	sgx_reclaimer_write() {
		mutex_lock(&encl->lock);
		...
		mutex_unlock(&encl->lock);
	}
	sgx_encl_put_backing(); /* Not protected by enclave mutex */
}

After the patch:

sgx_reclaim_pages() {
	...
	sgx_reclaimer_write() {
		mutex_lock(&encl->lock);
		...
			sgx_encl_put_backing(); /* Protected by enclave mutex */
		...
		mutex_unlock(&encl->lock);
	}

}

Even so, because of patch 1/1 the first scenario described in the
changelog is no longer valid since the page is marked as dirty
with the enclave mutex held. It may thus not be required
to call sgx_encl_put_backing() with enclave mutex held but it
remains important for sgx_encl_get_backing() to be called with
enclave mutex held since it ensures that SGX_ENCL_PAGE_BEING_RECLAIMED
can be used (in patch 4/5) to reliably reflect references to the
backing storage.
Considering that I would like to continue to consistently protect
sgx_encl_get_backing()/sgx_encl_put_backing() with the enclave mutex.

Reinette	





