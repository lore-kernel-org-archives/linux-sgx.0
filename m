Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0F1C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 22:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352944AbiD1WpT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 18:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349982AbiD1WpS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 18:45:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C4CAAE37
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 15:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651185723; x=1682721723;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DA8ITORnqepsJ0Hqeu9gb2qI25ETYpOMoq36M5ztfwM=;
  b=Gs/2uvtnOc+8sQr2ZWaPRhhpOoxO8AKY+D+RQvwIMZko82EgnyUZoKnq
   lNKSsrQl+KoAcpPgBB1DRRfzd4KnsNTVEHyyUk9xstqsiVG60vyn1GY0N
   kEG86zicjfqlj7BvWOcUr70vXC5gTX/hdCGNdkXGxant8+Xrd4qdQsooo
   vJOv3en1O6VDvF0k72y5GR5H3nPz3G/Lk0eIg5cuQQNUtIk8gbAjaOVS+
   v3R3FCW+7fctGMRCjFg2vD/Z+0wCcPQ4W2wxff3R/FceUf4DAJtgfpVsT
   PxvqnUdbJmogFBykaipeJbKK72hlWnwYEPq90fYuEtswY6Pj7ScrdtYch
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="326940725"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="326940725"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:42:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581686331"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 15:42:02 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 15:42:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 28 Apr 2022 15:42:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 28 Apr 2022 15:42:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlD308LIPi0Ki6/i1lD/VwGa7x2ktwQxrgy0PQTG2PctXnPqYeWNfCceF/bN6pmtmxp0XyfikTKapOpzoxAHz65uEa8aT7cCiPFc4C2vUWV6hzCDChlDKfvAV6MTKXse9DjdR+Cyu2XDZ/j8cejjVZqJp2SyXNng2u/p4EPPUCKz4JzneV/gNG67KMZRbWzQObqiBxaioJGILaXskFlNx1WdPYzXjsPMXykd74b2U5Y/AFTJxTOJpltmDy/izGvtgJrmWq2uR4n+uosOQExO08hI3kqASifLy/0f16You7u2SNJTpJki1jpZGfmZOOyBgaQieNXunSoFkgZ6YI4xOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBtJzZhZhlrplXqDhiKr2M8oXSG8/irPDvK1vXRRRcE=;
 b=M9JrSSfGbiq5YJLV8W416YmToJi0TNzDQgr0f5tz6lQ/1uFLxYNKKcWC7ZGKxXJWgjoE4uDnC3qSkkuNuaZqZvhe3wa6ztAKwi2zxQK59haek9gAL+MNYyEJuwDzrxTeypvUFQ5Qsr1Lpf8QJSEjfi5DMbiC+VCHbO0QhV3OEgBkFlDAIUQX2ygvfZyRlf4ZzC1B1mUaTClRxZsOB43OcpyhFDo+d+1jVDOdcVqzWrsjgOwunJe6f2YgCnxUsRtzlwC3zZV8pKS8uj3Y3S0PeQOnJQgKu9sWslXR529gsfJkR26Z31JMvCcOlw6clkfAChpKSa8mLGJ8cmpxvBOXyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by CY4PR11MB1701.namprd11.prod.outlook.com (2603:10b6:903:22::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 22:41:59 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 22:41:59 +0000
Message-ID: <fdeb4269-2956-5dd7-d6ad-6e4f89df36e7@intel.com>
Date:   Thu, 28 Apr 2022 15:41:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH 2/4] x86/sgx: Set dirty bit after modifying page
 contents
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <b0596095e09ee4a14a3802c5ce91372a0dc21220.1651171455.git.reinette.chatre@intel.com>
 <8231188d-b3af-4395-3d8b-129d500474ce@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <8231188d-b3af-4395-3d8b-129d500474ce@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:a03:217::25) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1f89cd6-fc4a-4077-7f98-08da29684e52
X-MS-TrafficTypeDiagnostic: CY4PR11MB1701:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CY4PR11MB1701E96259811BD001E695DFF8FD9@CY4PR11MB1701.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1p3UFZd5+87b6tkX8mkazxTg0vctbHzEAsjQQ2QJ3GhkzaNfbht5z/wR7u+evjUleMKkE8Svp6y5SKSWk9cWrYAnmaixBIA9mWeW+bGVhJI0+BEedz/+VkxJwXRu9velJKpD6ktDyCtQU87dmvraZgAdhUQldiim0oHMgA+w5Hlgej4DBanYjQSuSz7LW+4UUk0qahLiW76Ne2ivgD7JixpVi3LeUTYooP4wkmlgBLx/mBdEuPtpN7KDZ2XZZU3HIZtvPEu5lk4IHfZP0Qzfug8iR2pxPj8FFWQR4jQh+79kzstUwj07KjrOIpltpjD9DnxersGnA72nSr9uhRi0WkBME3K4qirgDTQgLjIRnhNb4ILwbq1m/13FXX573uQ2xHb0oCyd2STEOj05wy4dBv9H4Qdjd+I1PxA9nmx5uspcA+L6KeHUVU8MP66UWPqvRr78Tybi0nU4l6vRt3Ehv8zyGAnjUFUF1bjqyNqJ+oMWY1G11efT3+lC5XihycA4UJnGQqrneeB7GJkAdTakDThYe5uIOqER4FN1kb3ePG+c0ygrjxUacY3L4jCeoi0zsTiQKFVlRCtFFXWBPdacYDm5mbr3qwhF0pGiUx9tKwjRbbohCeaaSGnvO4bm8DDVDG9N0XTwHZXEwilUAG3Vgd8HLf/lMGOqvXIRPqTOxJWdoIYZXZqhMKGEnfqszHHBL68iVzxU1zXfHlwsmv4GY+HHyBiroewz5YR90QwTeiTiAj5cYPK9MVzQZG73kG4tlejhb7hxxs96Umrf2o2vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(2906002)(66946007)(186003)(36756003)(5660300002)(44832011)(66476007)(316002)(8676002)(83380400001)(4326008)(8936002)(31686004)(2616005)(86362001)(6486002)(31696002)(508600001)(82960400001)(38100700002)(6666004)(6512007)(26005)(53546011)(6506007)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MklTcGRHWjBGL3QwQjJJVnQwdnBrWTIwdmV4RXVRWUcya1Mya2FDYTRGYmVM?=
 =?utf-8?B?ZTJJWFNxK09DUUFmS2RqS1B1YjduaHd2b2Z0QW9jVEM3bVU0aTN4eXgxQzI2?=
 =?utf-8?B?bTVWZ20zQy9zVTdaWWREK3drdEE2OXVhVmxBRkxTUStkaWdxaU0zYmJCOFNQ?=
 =?utf-8?B?NGpUeUFxV1pZRVZYaGRUWVVkZEE4TWs0b3lOQjdheXhxd2dIWGxqWDRKMUs0?=
 =?utf-8?B?NjdtWWZmblFvYm95OFdKSUxleTV1UVkxRVNad3F4Ulg3SVRrM3VpZ1JwYWhz?=
 =?utf-8?B?UUF6L2ZXb0pmd0tReU9CbStESEpYUHVBZDE3OGJBdUNpM1dyN3UrWjR6QjQ1?=
 =?utf-8?B?Y0dySkM5VDJyUjNEdDN1UVRPaXJGSnNORytXeVVkbzJINlArTVZITzd4Q3lY?=
 =?utf-8?B?bDRPcGwyeVBScUFIYmQ0djMwWnVhb05weDNLVWd2WU1JaXd1Q09WbFlUWHBQ?=
 =?utf-8?B?TGJUaWd4c1MrQU03ZzlVVGhWR1o4Y3puODNiaEZ5WEdtRnlSRDJrVGdrYzhJ?=
 =?utf-8?B?OTc5L1RCWklDejZVcWxFTkNqMXJpTGNiRGhoaXA2SlY4RVJ4MmVBWStsdUl1?=
 =?utf-8?B?QTVlZkVJUmhDM0RsZGRYRWxzSjVFV0JlQWRuQ0FxUTFMWEQxME1DbmxyWEt2?=
 =?utf-8?B?ek5jNUFhczBBWjA3ODlDNlV2SXdqVFkralZwcmovT0wxYXdMbE9EOVUzQkkr?=
 =?utf-8?B?MDkrTzV5Z0ZzSU5XTCt1R3RiYUJmTERhSzY1dGVhSldDV0pTVjVwdWM5Ykc4?=
 =?utf-8?B?ZVZWSWJwZUM5M081dDJURzMwdjQwOVcreElFQlBzSnZmU0VuUXFkSzY4bzY3?=
 =?utf-8?B?NkdJTHNxZlNBVU95aHJBWG9DaGFzUFNhTG1aTHlrOVloTStQQnpscUdMYmpQ?=
 =?utf-8?B?YzZGUjVBd0YzOUxmcXVES0dWREVUalIxYjY4dUhTUE1rTlM2ck1VMlNidTRm?=
 =?utf-8?B?dFYzOVh0MVBUcXplSG8xV3M3Q1dwVXQvTGlza2FhRlVZRmVTQmNiTE9td1NW?=
 =?utf-8?B?b2dBaXpIWDF6UkNDb2dSSUVZaHgxQ0RSTUU0QjdPVXBaR25rZnVhTnJTNEFx?=
 =?utf-8?B?SkZlUk9ZSnhwSVk3WFhyMFRkTFNJNFpmVUtlV0FWa3oxOTJ6S0JIK0FDUTZ4?=
 =?utf-8?B?Vmx5bExhNDg3YWFTa2VhZnV1VGNNV08rQ2lpTTFrczE0dzEwN3lBYmNhaVhV?=
 =?utf-8?B?eDhTR2FOYzVTRzlzSUM3YXMrbWw0bE1zMzF6QTErQlJaeHk0VTZGYnl4NlNK?=
 =?utf-8?B?YXhFeU96UERwdTBOcTkwSWIzRG91ZytWLzFRczFJM1VVWjJ5WXFkLzNJaEVI?=
 =?utf-8?B?dTl0cWkrM2U0MjBzU1ZwNjd6OHNjcXBmaFJEUmRkZ1hTdENNbGhyQzB6SFBZ?=
 =?utf-8?B?MnMrUk44dXBvL0dBOTUrM2dJWk1rZllJRDZDWWJMWElIdGtTbXhnNUJmNUlX?=
 =?utf-8?B?cC9kcWtHWFprb2pqLzZxU2g3WEhma0tiTUI2S0Y0NnByNkdmek9acVQvM04r?=
 =?utf-8?B?Nk91eE0yVU56ZFpySTRpZ0V4aG02N0YzTjJZVE9nN2tSMXB2M0ZQaWp0aFVT?=
 =?utf-8?B?SGRoekZlQ2g3bnZxdmtsZ3pVcXpZbXBIQVUxaFJ0aHpJVnZmT25vOFVlQk9D?=
 =?utf-8?B?TWtWK2s1VU1KYm1jbitMa2tmUzQyUEZnMnNLT0NIKzVyUWYxTTJnTUhUYndX?=
 =?utf-8?B?ODVzaEJzVU00UHV0WUREUDJZUys4UUROVjhZSGZHN3gxbzN3enJKcTZrY1A1?=
 =?utf-8?B?UG9kVGdSbXFSbU1Rd2FLeGtyU0k1aTI4c1kzbDV1OC9PS1l3SmROYUhBcmVT?=
 =?utf-8?B?aWJIelBjczFoQ3lyY2FUYUltYlZiOXNwTzJCRVUrdXNxNUFWZENtS3d2MDli?=
 =?utf-8?B?MUdvZ3BDTVhkenF1dkREenlNaThneVFod05adUJIK0VWZUlkYnoreHVaTVVW?=
 =?utf-8?B?aUswK3R2R0V1UW1vZHZncFdBNjVrZG5XSW9jcytwcnpDWlNrU3BXRU5RdkZ5?=
 =?utf-8?B?NzhsaER3OUNJam11cnFOM1BIOExYM1ZiRkRwNTI3VFNYSXpZZDNxZnN2Qmpa?=
 =?utf-8?B?VkVLMXpXUytHaDFIMm43UVNJV3prNGt2Tmc5VCswdHhiQ1pqc2wybmNBUnhT?=
 =?utf-8?B?UTFCWjdJc0I5NXBqRHArNm1FK1A2cEtoY09lblk1ZkNzK3k4NDM2d3BQWk42?=
 =?utf-8?B?ZzFpZWVqdnl0dk9QYXFKeGE3OU9oNG9FZXRCYTRGK0J5RDBpWk5tNVBQWGZv?=
 =?utf-8?B?OHBsLzZycno1SXdQSXdDcFdLSk9HZlJSazVNaWtrc3dvdGdEalpORFJJRW5T?=
 =?utf-8?B?WWxEb08rMjZNTEZxcE9zbE9xdXprai82V3pLWEdlTWZ5MFlyVGpYbDdnSDZy?=
 =?utf-8?Q?kYCRLCzWDtfD2J+Q=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f89cd6-fc4a-4077-7f98-08da29684e52
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 22:41:59.5588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rs42gzYWmePz+OswKORGnxuKL7OtvnhLWNmHoLpNvYAivdo9u2aO97vy/i7f1ek/xyj8/iuguDIMdPXvgOLQRLGORP55oMtpkTgtaaGxjAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1701
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 4/28/2022 2:40 PM, Dave Hansen wrote:
> On 4/28/22 13:11, Reinette Chatre wrote:
>>
>> Since the PCMD page in the backing store is modified the page
>> should be set as dirty when releasing the reference to
>> ensure the modified data is retained.
>>
>> Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
>> index e5d2661800ac..e03f124ce772 100644
>> --- a/arch/x86/kernel/cpu/sgx/encl.c
>> +++ b/arch/x86/kernel/cpu/sgx/encl.c
>> @@ -98,7 +98,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>>  	kunmap_atomic(pcmd_page);
>>  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>>  
>> -	sgx_encl_put_backing(&b, false);
>> +	sgx_encl_put_backing(&b, true);
> 
> I think you're on the right track here.  The concept is right.  The
> memset() wrote fresh data into the b.pcmd page.  But, if it were clean
> swap cache, it can be discarded again and the memset() might be lost.
> 
> I *think* all that would do in the end is leave us with a PCMD page that
> will never be truncated because the page has non-zero PCMD data that
> will never be used, the result of the thrown-away memset().

Thank you very much for the analysis. This explains why this change
did not impact the issue I am chasing.

> 
> But, I'd rather this be done more directly and closer to the actual
> dirtying of the page.  Perhaps:
> 
> +	set_page_dirty(b.pcmd);
>         memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
> 
> 

Will do (with comments to explain why this line was extracted from
the subsequent sgx_encl_put_backing() call). 


> I don't think the "b.contents" page needs the same treatment because its
> contents are always discarded in this path while some of the PCMD page's
> contents need to be preserved.

That's right. The consistent symmetrical API of get()/put() was appealing
to me.

Thank you very much.

Reinette
