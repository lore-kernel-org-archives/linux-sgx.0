Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4768C433F5
	for <linux-sgx@archiver.kernel.org>; Mon,  9 May 2022 17:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbiEIRVb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 13:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239495AbiEIRVa (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 13:21:30 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9EF24219D
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 10:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652116656; x=1683652656;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1yP1oi89VTLEhlB1K7n7MgJ9v7eZ2RuWT2KvVQqvVOc=;
  b=AM035lcIhLNgoWlraDN01okePqHSGBbf1p6Kw5NK10hLHitVSFsPg74o
   aozgEFlfaNPjkQ+m9p8MzgORAEqk1tO52IQfGJ31AfEOXO3hiP3ysPdV0
   VzxF0F5aKNvZDUDodEN3wOQago+97kKjwXoqnl3rZ6g6Q4eetzBdKcc6j
   H8SkNrGOglz+0RfEZlJtZgCL8pyv0pcr87wjw+9nfzd1YVTLDhGhA/Np4
   Ht4YrW9QeFBlMeMbfR8A+KwOMYiFLHI9050ydtT/8Ri4JaVuWmu7auo7n
   bx+uZFTEj6NAZGpwS65q8DCZ+Hpi5ztno6Ahn84OPBYkZg3naQd2uUvvs
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="269250691"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="269250691"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 10:17:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="551123371"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 09 May 2022 10:17:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 9 May 2022 10:17:35 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 9 May 2022 10:17:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 9 May 2022 10:17:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 9 May 2022 10:17:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihy6Ga8wO16LZC9KptsUbevb9rIP7+C6+82HmDRVxyki6jNxzGXS0rO/t6HIPgIMMw3HqIFq7sq1dIKFgsxKYYALrPC8eClQQbfFv5D/nSwDUeloCKATyciUocHHPP0X1EpbLhyju0bwwHVY/kQL5aCk+39fOwpxrULD4iXzLshTdhvDiE0Li6fv/JAkC6LED9t8irXzt3rli5HSxZL/U9NE4ds6TkddugBT79Y9gO0Mei4UETNlRQjNiNxHQv4NFo2GNJ0ohXXsA2jBnchXQC2OMEpy/dDvglV2S81pK7obiNO8lTivxO+BYNtcGPdvvGOVMHuZ7PkFndWwjQeHEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IR+J5fR65uRvWlMO42xoLWBblOr/54JQq8mG7RQrC4=;
 b=mZcmzbrzXgD8C2D2zR+UpG/yY6gV7mvcmt2ZDZJrby50TplRDlStB8UOxyUXsPmTCDs5F/ZHailoKzO/lXXH7GtZxVYzke+/wKobHyU7+heiecHzyJgbtT3elvo7Bm2cZaNXFELOnOZer+lzzyDfef1oqRoD4hPeKRKEBckalm4Bn87Z+LZLb0Xa7ydnKhNeCMcbFEg1UhvOL3PXRvb/DizL/xuAg/ZRzUUxzjXMRNfY8tE87l+FGtBo0elSS436wL18/hFRtIPN7QQNm2mCYlGLWQK7q4p0LEMpg7qvWNtKMlbSoK+v3EpUuy6poJtn8C3M0InjJIcEtPJl44ZXHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN6PR11MB3986.namprd11.prod.outlook.com (2603:10b6:405:77::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 17:17:33 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 17:17:33 +0000
Message-ID: <8d44af4c-798c-4887-def6-595f18f7ac66@intel.com>
Date:   Mon, 9 May 2022 10:17:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <linux-sgx@vger.kernel.org>, <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
 <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
 <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
 <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com>
 <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com>
 <YnarpxzH3cEBo5pL@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YnarpxzH3cEBo5pL@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0088.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::29) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6315884-167e-47b3-dba1-08da31dfcdf5
X-MS-TrafficTypeDiagnostic: BN6PR11MB3986:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB3986EE1EE44479BFEA4D95C8F8C69@BN6PR11MB3986.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hOipnt00N+oUZLtaqoQT7KvK1HSLwMkGTFiM4okCZFapmIiBCWedicv5Yod+FmTj3HlZPQlkMQT91+EbLnkwBRmZMV3G6lHS8yreSkrXEFCtezmMcfM6lclO++kkYQxrqQ+26mnr1/X1P+TWuhNEyEfiG11nB/rUnucM6muj1oatD0JoSWIfCC2CV4hXpQWvf1+w0EVEh44QtDaVkkmDVCGGB2vfJk7/N2tMteLoiYmH0QQIT3+VUoQxknBZQxPqxI329CziSp0UNB9L//T5MWCOhWLBVwYJndi47x7mpitGfp5qKZuhg09ztEywJMosy5hCcGjgtEOCvsewAUa8v3yzXAPa+LhPX+0C3QfOFp2w1Nlt4f/0QmQ1WEmym+VaDUh2M03VaAt9Sk1sI0zSnS4yRZyP1zHEyPG3o7WyYAwFaNyHdFT64prkgG6HWh7uRjSGjnalPM+DGglkgyHoDPm3Rmtv0UPB4GQo34lp2R8R4y1y61Hoz9QLoIAlqeEKTweHTC4B+Vm9vPSqcV1zEjygFB/wnGrdTJzM3RX/HdrpzSPsiwqkWO8nz0rgtZDF4RiVQV0uadzhTGw3CLqG9mUaEBis7wyaQcFs5h9neDva+daMio2crdBxoSNqNbGgMSR0QX7Zyj0fg0OTcSV+UBoP/lzwDK5svRpNzEH2tKW/R7/cHiG8WX9PYennq3mrv51qInAQfWziZhebNwNLEvm0VRjjE9lezB/joCDdhDEriEQuIxqcEx0Lh35/qhcaKnAZUjA78PZfZacdeHd/zbM94GAyxtK69uhPcgy6Was0192+KRvMcnH8xpcKEolf9vHda0GtVlw6IcOW9W+61APGu11tPxOsn9alKkXaSXZ8OQdw7TkRNNSFOvjMWzh3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(2906002)(6486002)(966005)(82960400001)(31686004)(83380400001)(6512007)(26005)(186003)(6666004)(5660300002)(44832011)(31696002)(8936002)(53546011)(6506007)(36756003)(2616005)(86362001)(4326008)(8676002)(6916009)(38100700002)(66556008)(66476007)(66946007)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDNDdVYzbWRaYjBzYWtIRnkvQjlRWXNGc0d5cTJKejlXTVMxTlZCNmRMOUIz?=
 =?utf-8?B?L2ZvMFVRRFZBczRCWXJTWFNveURqMDJYZ1llODRPaGZYTnhKTzh4TzUrbEdL?=
 =?utf-8?B?WDJWOGtITGRxUys5M2daWkZTRHhHbmFGb3JSbE9kazhTdTdobCt0Q2FySUFp?=
 =?utf-8?B?K1g1SWZVTW41LzQrK1VEb3BsbjJveHEzSWc4alVKbDJsN2pXalYrcFNyWFdO?=
 =?utf-8?B?UElJdlppWHBaR2cvVGlJUWpIT3g2TldQalAvd1BtU2dxWWlOS2Vmam5PMWNk?=
 =?utf-8?B?ajNGbnFCNXpYV1R5WVlQcWZxYmsxTCtmOXRwR29NY3dYd2xYTXQ5RlFQSDhX?=
 =?utf-8?B?VldHZ3g1d0Q0UVFHbFNEMlJicFdacitjWU00YVRsdFZDek1nMFpUNytTVkx0?=
 =?utf-8?B?N21hanpNWHJNdGZmQWhqOFdTTnV1WCtRMWVEV1EvRUxmcUVFQy8rWExOOTN5?=
 =?utf-8?B?bXAvclNpUHhSTlVzTXRUMnM5QkFyZUN2TlhhZ2JWR3hBQXVjcnFSQ1JubURa?=
 =?utf-8?B?NlRMYW1yVXczOEhFeGhKRnU0ZXZ6Y056SWo1V1hRemRhMDhaTExJWmsvTlVp?=
 =?utf-8?B?cTI1M1BFT0RDaXhiTmJjcmRTNkVQSlBlcmxKNG5aN0xHNnM2S0ZGTWwzcFYw?=
 =?utf-8?B?ekd4UkNxRE5rOTR1YzBYMzRFUGozVzBIOXdtdEFwenJnYW9NY1NYNktnL3Ar?=
 =?utf-8?B?M1k1T0tYMDZkN3pxRkJJTkN4WDRUajFQNnhWZDFhbEFIK2xCYmNoUHFYOXZt?=
 =?utf-8?B?S1J4NXJoNlNFRVE2bkNiOHhVSzdsMnUvMW1CY3pKclRQbjRuOEMwU0EvM2Q0?=
 =?utf-8?B?ZkZ5cHg2eDMrN092aEpwME5FeVQ1NTRZZzQ0UWdYczRNeG5IUDlFMCtQaVln?=
 =?utf-8?B?cHFvK0tqMm5lb3BBMTF2c2p4STJHSGQzbHdsZkdKbFcybTNzZDlMYkZVL1ls?=
 =?utf-8?B?aTl0TVNpQUpKdUVNMWl4R0poQ21VNWZEWXpVU2p4aVlyK3NsQXBVVWtNTWlQ?=
 =?utf-8?B?dkZMZVNLbHNralpRQ3ZjL2FKd25MejdFekwrR3JoSVd3a0VhZTZ3dlFVeDc0?=
 =?utf-8?B?L3MwRTRVK1FlSk1YZDRZcVJXSkRmZjBPdUhZeWs0VjRyUVhETlowRmxtK2hm?=
 =?utf-8?B?NGJhZG5yV3RkczdQK3RBVUF2WU1hQnhtNFpRbjljaWJBN1BQQ3NxalFlS3ZG?=
 =?utf-8?B?eVh4WWZpaG02bS9ldTlCNzZuMkZqWm1Hd01JbGw2ZDJJMjNNZVY1VWlFMm41?=
 =?utf-8?B?WFpRY0NCeTlDdzY0OUFIU0w4ZHJwMTJBL3ZiUHlneUhNSkIwRVJLL3JIWmVM?=
 =?utf-8?B?R0NMOENXaHFaSXJhSzZHeFh5WGFKQ21udWRYemMzeTdFQW5yMU15NHNGNzM0?=
 =?utf-8?B?b2pxVDcvZnNVTU1RSW1mVmNxdTI3Q3d1NzJ2Z3NiZ3FIWmJheTRMaStENTBF?=
 =?utf-8?B?UjNjU3ZzMlJpZ3VrUHVjZzJiWTdjVnN1UGNGYzNXQmI1WnE0V0hpZDdwSWps?=
 =?utf-8?B?MU1DRjRrY0xkSGZSRnVJaGhDRmd6a2toMVpGMm1sVjlFNDRhRjNtMVViYVVO?=
 =?utf-8?B?OU8zNmo4L2dGcnc2Z2pSWnlVZHNSbGVMb3d1UFQ3eXpuNmZjRDhuanRtakl5?=
 =?utf-8?B?NXpuUFh4ZUc5bFhUaTJ3dzM2a0xBdjNiNm5TdTBMTXRyNkxWdTEvQ3ZmZWt0?=
 =?utf-8?B?clA2NGp0MHVHci9NK1JiZnhMek9XWUQwMVBpRm1PRWJtbVV5cll6Q2RFck0y?=
 =?utf-8?B?TmxnM2w2MFgxTW50UGJBc3EvRFNxNC8xclFSVXBVWWRGQ3lENjZHMkZ6Q3Ru?=
 =?utf-8?B?Vy84K2djZ1B0K0V1eHMrc0E0cUVMVjNJRkVtU2NUMVcrMy85a0FTQk9hUitM?=
 =?utf-8?B?WEZBbW4zRnBzdEJGTkZoUkZvQndmbHQra29KMkYxWm9WUTFlRjdEY2xidms3?=
 =?utf-8?B?dTJtOHJ6NlF3ck5EeE1CQUlYbEYzeXdoUytRcjFqT3hMM1Z4RTJRUHd3Mjkz?=
 =?utf-8?B?cllKc1NiOVFUa1c2amRDMUlnVW1mQkxKbTl0dFdiWERqMXQzeTNnOVBQaFdx?=
 =?utf-8?B?djBvaGtlT3RTdU5QSFZpdUwrNlA3OVpRcEVMNUxNTENvQ2hhQ1NJK1A3SUNZ?=
 =?utf-8?B?UjFxZHRnZW9vR3Nnd002MXRVbU9VclRmalVKbjZ2UUZrbWZFVkcycC9ySzhy?=
 =?utf-8?B?YmlSSWlKQzNGVE5rajJ5NW5qMEFnNm9QSWJCVVFQUElTeHFtNGt0OXVZWGcw?=
 =?utf-8?B?Z3h0UlJ3dnEvYXp4cHhFUDMxU29tRGRnK0IrL0ZabDRqYVE2UnJwTmxTZFh5?=
 =?utf-8?B?ai9XcXpCVThaVUZkb0hRSjEyTzFBOVVpN0ZFeThWNG4zK0JyVzNkK3Q3WDFR?=
 =?utf-8?Q?VU2Uxv8SmvFe1f2s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6315884-167e-47b3-dba1-08da31dfcdf5
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 17:17:33.1456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqYOgV+DdSpWXNCN0ZPoDhCUtnGzXzMyydMtw33MpiB5D0IpFGTSxTZgJtu78qMUmO055DSn8nZVE9CNgRa4DNG4vv0l93LctUPRYp4ydLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3986
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 5/7/2022 10:25 AM, Jarkko Sakkinen wrote:
> On Thu, Apr 28, 2022 at 04:49:00PM -0700, Reinette Chatre wrote:
>>> I also looked a little deeper at this transient failure problem.  The
>>> ELDU documentation also mentions a possible error code of:
>>>
>>> 	SGX_EPC_PAGE_CONFLICT
>>>
>>> It *looks* like there can be conflicts on the SECS page as well as the
>>> EPC page being explicitly accessed.  Is that a possible problem here?
>>
>> I went down this path myself. SGX_EPC_PAGE_CONFLICT is an error code
>> supported by newer ELDUC - the ELDU used in current code would indeed
>> #GP in this case. The SDM text describing ELDUC as "This leaf function
>> behaves like ELDU but with improved conflict handling for oversubscription"
>> really does seem relevant to the test that triggers this issue.
>>
>> I stopped pursuing this because from what I understand if
>> SGX_EPC_PAGE_CONFLICT is encountered with commit 08999b2489b4 ("x86/sgx:
>> Free backing memory after faulting the enclave page") then it should
>> also be encountered without it. The issue is not present with
>> 08999b2489b4 ("x86/sgx: Free backing memory after faulting the
>> enclave page") removed. I am thus currently investigating based on
>> the assumption that the #GP is encountered because of MAC
>> verification problem. I may be wrong here also and need more information
>> since the SDM documents two seemingly related errors:
>> #GP(0) -> If the instruction fails to verify MAC.
>> SGX_MAC_COMPARE_FAIL -> If the MAC check fails.
> 
> This part puzzles me in the pseudo-code.
> 
> The version is read first:
> 
> TMP_VER := DS:RDX[63:0]; 
> 
> Then there's MAC calculation, comparison,  and finally this check:
> 
> (* Check version before committing *)
> IF (DS:RDX ≠ 0) 
>         THEN #GP(0); 
> ELSE
>         DS:RDX := TMP_VER;
> FI; 
> 
> For me it is a mystery what does zero the slot and in what condition
> it would be non-zero. Perhaps the #GP refers anyway to this check?

RDX contains the VA slot information and that appears to be correct
in these scenarios. The issue is the PCMD data pointed to by the
PAGEINFO.PCMD (link to PAGEINFO found in RBX) is all zeroes.

There are two scenarios under which the PCMD data could be zeroes. They
are documented in:
https://lore.kernel.org/linux-sgx/8157fa40-8d02-8819-e1b6-fd2d8863fb56@intel.com/
https://lore.kernel.org/linux-sgx/da387afc-e666-45d0-1e99-066d8c4aab03@intel.com/

I understand that context may be lost by pointing you to various emails
in this thread - I'll wrap up all learnings when I submit the new version
of this series today.


Reinette 
