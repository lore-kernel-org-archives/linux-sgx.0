Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E0DC433EF
	for <linux-sgx@archiver.kernel.org>; Mon,  9 May 2022 17:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbiEIRN1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 13:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239463AbiEIRN0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 13:13:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3131E59DB
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 10:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652116171; x=1683652171;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Og1T6VA81skdcAUYtL4vUPO49R8WzX6yQHTwS9toRLE=;
  b=P/ZJdVfxlu58JlH20M6yoLA6EcXLTBKPx27gSp7gKg3Hrf9EX8Vfl9aC
   DTPgQhnASlQQ7kg2HbP6kZ9ugaYz74PaWBKnmvuTUqNuBj6fSQWmo86MR
   k29WRDgS9eZQB4rjYTBxAlbwEcR0gktAOhndGAu5B8/Ey/6a4dP9W43E2
   YK2ISifCRAsmbQYUBdMTdLz4FtM1Vg6kE52ixh2Iddcx1RBoAX5wg52Vc
   EkHK7MjGHa1Ai+7zhcemIUyC/MciCZ3qLiwlw1yaaVpNTh+XVU+8oEIEP
   iOJG9MJ7aWobl5zB/R7l03Y6cGVylvQlE4Fo4d6Y0NoD47e1mykEn49iU
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="269248399"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="269248399"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 10:09:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="570254773"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 09 May 2022 10:09:31 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 9 May 2022 10:09:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 9 May 2022 10:09:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 9 May 2022 10:09:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0mTK1BPgOIYRWvUdGsyziPxGXWBavvn4pg3lN6MvprL2bLPh//3jr4vkJXMvDHmrii5sxPi05IapEFc3JeLjWaUOAhXj63+fKStb1gE6CC1SWYB+G7xdUZmnJa78bwZ0Ys7HfGmrdCoy04PAALs42plaXc1tfpZ8Cg/g/lhyLb7PYT6zacvglgNrhSBmGMvxeI+2U/2sQRbE4wnRMopN4dNdsTs2x/fk4+ZB7oo37qBNOmemVEheZsrgFLjWI9hl/0Vv1be/f/I19COOFBclgvr3l9QCcwzsCu7rBr9/QSkZWBUKqC26unppQMnch841cA/lH1sqBbM5jzqhii/gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ed5R2tPF8XDrEAu14Z4mwpzJccunvMWpREL1r8eXHuw=;
 b=BodkXPh1CUZk9HSsNJed359wYbVylnaF6m6dkfzMOV43HNz9Ux/phZXFeIU37mKt71NRDTGrd+8Xi77Q+JIOYys5KrwhEqJdFOZiI90F4GuLKg4C6V4GhJGxDq7aG/vP3WTYRR02eEBPpW9+va87DN4GT38wb7vYczML847ubMYY7AroD1ZuLoEdXJyyb4GFun7utA3MhQtg2T+hW62xEfV5P8fg1l3punRQG6qeTMohSKiZf1zFjrAvcvr8/pAElUIwR6xTw3oRyuwinOhL0JoFkGMwiBlGKSX+fIUWKh9t+hEl4568yclFaBWIviYINIsVKN2H8zO9VWv8lLKpZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by CH0PR11MB5329.namprd11.prod.outlook.com (2603:10b6:610:bc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Mon, 9 May
 2022 17:09:28 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 17:09:27 +0000
Message-ID: <c75f56b5-e071-fe37-835e-7cdd275852f5@intel.com>
Date:   Mon, 9 May 2022 10:09:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
CC:     <dave.hansen@linux.intel.com>, <linux-sgx@vger.kernel.org>,
        <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
 <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
 <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
 <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
 <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
 <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
 <c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com>
 <Ynavabraw26HwnfW@kernel.org> <Ynaw2A0z6mBLU0m4@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <Ynaw2A0z6mBLU0m4@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0160.namprd03.prod.outlook.com
 (2603:10b6:a03:338::15) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7341d640-ff5d-492b-9493-08da31deac79
X-MS-TrafficTypeDiagnostic: CH0PR11MB5329:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CH0PR11MB5329DBF0B1994E8B21A69729F8C69@CH0PR11MB5329.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qisbat8ZjaTybGOq5Aqqm8FhHMrKsth1gr8FwayxBW3e6aZF1Xzl0mYULqiSxIUfe+f9V56HUIjW7InnuOUaMNTpZivNHzlO5alLwDhU3RBncZUgRl7j/BwU0SHca2nLcTmpX5VAtaR+TjmgNDwI4HHBtPOozPoqybyxMg142JJVNpY0rPaJ6l7zqKq1Aw5pVJeozijolxJmKogSxtjlBQz2QStvfa9OIiDkSecfGJk/eeP8tKwNP7aJuxK1LklW2f1HaRTISrQf+i5RbwFh2tQOYc/GZzC8uR3uKkkiJX39dsLKK3Xr0bRrFFycgbMbhmRzEmungCMJjsfWn9HKNwMAL0NgWrAtQ9Z7BDzIPhqKxP2lM1WeP3bi+hR1sg55lPHP65EoFrDjs4H5PpoJWWeFPIXq50Usoe4r9E2QCkMqn+J6wGg461E/wLZokmAxGUr2P3oWcemUTIeZMHYYNEBBus97y+2R6PIH10o6BvViMs4xF2fzWoY09plmK3xVvGzLKAzEWnDd57S7DhBIpNYCJBWaE5O8xl9/P0dvcy9gZsZJGrKfb6tfRfen3Vh4qyuwN3y8Ndtlv1S6fbW65Jji9OcXSOuBkcRrRhDKQ2mdIO+gi1i47ytIAwHuYF/cain0egB9tqy7iuUCOXrEx8IsUK8XSUd61dNEcqJ5WIMSEeNCNnSqMYcqhQUxE3BxlvejsCLrMwBhUM7DP5Hj93XqShEchmm0eC0SYfOZEfglP91oIQ5HjSHZnXcjXRppRbLmYm+t4Mc+GpclTgOTh9T6ykZcIkOcg/bCMUCelvfTfbi/Mg7RVlkWzFHSCumj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(6506007)(53546011)(26005)(44832011)(6666004)(6512007)(83380400001)(36756003)(66556008)(5660300002)(186003)(2616005)(2906002)(31696002)(38100700002)(8936002)(966005)(316002)(508600001)(82960400001)(6486002)(66946007)(86362001)(8676002)(66476007)(4326008)(6636002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXBDNlpsWWZtMmoyVEJIbkhmM202Q2Fxd0Fob2E3NEwxN3QwK3hmQUtXUldH?=
 =?utf-8?B?U2VmT2llWkFRNW02U2txWkxCdlBhN0ZXaXpNZnVGWkI0RVd5S3I5NkRNeCsw?=
 =?utf-8?B?UTJKVkxDOEpmRGxIVUo2STF6b0hmN1NzbllmbzFyS2lJTDQ1Tnp3c0Y4NmdB?=
 =?utf-8?B?RmM0aTZuVkp2Q1VJYVZDK3crUVYyV1ZTOXF0cE9yZDBvcjJxdGR2NWNxdzRx?=
 =?utf-8?B?V1ZxdEtBb1V6LzRaS3lUVnc4empXRFNVKzRYMzJWSXp6MFZVZWlzSTFYbFFY?=
 =?utf-8?B?OGtIdDVPWkg5bURkZXB5RUZNTmpHZUhtV1JmK2w4ckNaaXFUeGFLTkVqOXc2?=
 =?utf-8?B?VDlSYWJKVG1jNWhVMzN1ZWZGMGMvVFdvM0xVc2d3dktTd2gwUmNidGRONDhW?=
 =?utf-8?B?c0RMM0kzZzBBcHBJMWk2WSszejY1RFhpQjMvN3huemcrL3JzZnI4Tkx0S0hY?=
 =?utf-8?B?UHlOTDZpczJZUTVhUGVPVjNoUkg5c2FhVnU4VVdoNDMycFIyZ3Y1aGV2emR1?=
 =?utf-8?B?RVVrYVRMckZzNUpuelRHQUVpTGpTV0ZBWDkwVmZrdEpkN1JmcHdEYWdTOTdE?=
 =?utf-8?B?Z0Z2UWJuVEc0TWJ2SUF3c1VNdnRKV2crMUJVYUxPU0Rua0g1T25GYldZL05i?=
 =?utf-8?B?YzArRGdPS1pGbzFlVUFmZnF2bkxIRC9hT09wVEtZUHpnRVNFT3pHSm5RTTVX?=
 =?utf-8?B?WE9MNmlSNGpWWU8vbmlielJidU43REZZWTVpeXdtMEpvVnkvVDFnYVlUZklG?=
 =?utf-8?B?UjdsTitDdVhFcEhjKzdYUXRrZWlDRDFRaDZTZzduMmltYStsQzJ5cFo2SVF0?=
 =?utf-8?B?ejR4dkd2ZXFDbTJzdW5kMnJSZjJ6WGl0TWtKNmVja0RlcFBqTXhVV1R3MHhi?=
 =?utf-8?B?VytmUU9pM1F6dmhFNkdPOGR2MnIxMlVpTzNKVmloL2NuYkVrdmZ0aGJsQmdo?=
 =?utf-8?B?M2RuaTVYZWgwMmVLbmRiNUg4YVhHMHVhWEVXWXMwcHZ1T3JxR3RYQndiS2Nr?=
 =?utf-8?B?Si9hZHBCK3NKU0h5V1lhcTVQWFhERmVvMGZhMWppK3ovT05Mb1lENVZuM2ZE?=
 =?utf-8?B?cmlJemhBeGRYV1QzdFAvTFRDQlQzd3pNRldrLzJxL3BVdXNHVUdnS0VuTG1I?=
 =?utf-8?B?OEx3L1dGQ0xRRXFSRUM5dE1yV253UzR3TWdlYTM4ZWp3WDllNFJ3RUdKTnBV?=
 =?utf-8?B?YVkvVzZWVkpiR05OZ3VGZHRYOXE4aW5MaDBXVk1qbjJyTGVVaWpETnp2dnV2?=
 =?utf-8?B?dDAyZzJneW5YM292enBVbE5qcXhLd09YTzR2UGJabWx3ajZKQlVWRlJkSS9q?=
 =?utf-8?B?MFhOSmxwaUNtSThJSGIrdFNoQk90ai9wczBETUN5dTdZVUYvWGU0b0VCYzkx?=
 =?utf-8?B?dVdENUw2SDdpVVVyeHNIZHBFRENYRGE1VWFrRmFQTFFGMFZ3MkNkZ08zUDd6?=
 =?utf-8?B?UUl1VGdLVjg5cEloOEpXNVhQTGU2N3VWQ2pBdk54ZERlTklScSsyYmM0ZW1K?=
 =?utf-8?B?WUtmbnlYa0JzbDByRFY5ZXdhcUR3cm1Jd25OTU5zS3NaTnBWQnF6NG8zOGhT?=
 =?utf-8?B?MkYwTE42UUI2RGJFYTMvcUlWLzl6UEpwVm1UTUIzck53Q2x0STFiNHkvTzUr?=
 =?utf-8?B?TEUzRXhzY2xqVUYrKzBPQUVqTElMY3VGZVhscHl6WDBTcGhiUk0ybHFTQ1Vm?=
 =?utf-8?B?UWg4WDFNVXdkTDNBVUY0YSt3eW5McmdockhHU2lrSExNNmZzOWZ1Vlp3eXkx?=
 =?utf-8?B?dG42Sm5XWmgvT3FrbUdHVjhZaWQxcGxMdGJ3cnNibkU2Z2xRVnlVSm01Q0hm?=
 =?utf-8?B?VFBaZnhrUCt4b2VpLzVSang4MVZGRUVod0hiWjJyVDlXdW03eVFEY1Fxai96?=
 =?utf-8?B?SnVpRXFsNEZ0MTBoTXk1cC8xb29SeXFNT3hMYW9PdjBKcTFNKzVsaE1hdDBl?=
 =?utf-8?B?bEJ6c1V4WktvNjcyTDg2L29XUTFmcU1BRkxKdFYvZC9JN2UvZmlRZjhjVEJ0?=
 =?utf-8?B?Q3ArZzUvSUhxaUIzRHJqZEN4MGx2b0pvOW5xVG1CWW43NjBrOStQSCtmYXdl?=
 =?utf-8?B?dG9rbXhhQ0YrdnZkdzlwTXE0bXpHdnpBYnVtUktaKzhWdDhFWnE3MDhlU0I2?=
 =?utf-8?B?UEJ5QUhaK2NINEVzZ2tEUnZDYnR3eEVWbThqb1ZvUi91T21OVVBwQ3BGNm5h?=
 =?utf-8?B?THNjaTlFcmN5dDZKakd6STNDZVprNXRwQmNqY0krOU4xYVRNcGpKUmhUTVpW?=
 =?utf-8?B?TG9xZ3RrR2hkNW5SOHgyckwvNEt6VHJjQVkvU1orS1RCUDRhS2U5a3NUaDQ0?=
 =?utf-8?B?cDNnbEJtcVdPRWxmY0hObHRBMm1hWitGaUozS3d5bU40SVdVb2dYS25Hb3V6?=
 =?utf-8?Q?HYW2ZqwxlupVcBu4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7341d640-ff5d-492b-9493-08da31deac79
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 17:09:27.5620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ol9zMGYcnKakb3DoDcIBdX0yDI/pY3wdGmkYbqf5xQS7yU9HT+ssZx3+QmrQTw+EkBrjSaX5ytjTYNyZrd8EvFUjP8GuSCajZ4Cvme2D8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5329
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 5/7/2022 10:48 AM, Jarkko Sakkinen wrote:
> On Sat, May 07, 2022 at 08:46:50PM +0300, Jarkko Sakkinen wrote:
>> On Mon, May 02, 2022 at 02:33:06PM -0700, Dave Hansen wrote:
>>> On 5/2/22 10:11, Reinette Chatre wrote:
>>>> My goal was to prevent the page fault handler from doing a "is the PCMD
>>>> page empty" if the reclaimer has a reference to it. Even if the PCMD page
>>>> is empty when the page fault handler checks it the page is expected to
>>>> get data right when reclaimer can get the mutex back since the reclaimer
>>>> already has a reference to the page.
>>>
>>> I think shmem_truncate_range() might be the wrong operation.  It
>>> destroys data and, in the end, we don't want to destroy data.
>>> Filesystems and the page cache already have nice ways to keep from
>>> destroying data, we just need to use them.
>>>
>>> First, I think set_page_dirty(pcmd_page) before the EWB is a good start.
>>>  That's what filesystems do before important data that needs to be saved
>>> goes into pages.
>>>
>>> Second, I think we need behavior like POSIX_FADV_DONTNEED, not
>>> FALLOC_FL_PUNCH_HOLE.  The DONTNEED operations end up in
>>> mapping_evict_folio(), which has both page refcount *and* dirty page
>>> checks.  That means that either elevating a refcount or set_page_dirty()
>>> will thwart DONTNEED-like behavior.
>>>
>>> There are two basic things we need to do:
>>>
>>> 1. Prevent page from being truncated around EWB time
>>> 2. Prevent unreferenced page with all zeros from staying in shmem
>>>    forever or taking up swap space
>>>
>>> On the EWB (write to PCMD side) I think something like this works:
>>>
>>> 	sgx_encl_get_backing()
>>> 		get_page(pcmd_page)
>>>
>>> 	...
>>> 	lock_page(pcmd_page);
>>> 	// check for truncation since sgx_encl_get_backing()
>>> 	if (pcmd_page->mapping != shmem)
>>> 		goto retry;
>>> 	 // double check this is OK under lock_page():
>>> 	set_page_dirty(pcmd_page);
>>> 	__sgx_encl_ewb();
>>> 	unlock_page(pcmd_page);
>>>
>>> That's basically what filesystems do.  Get the page from the page cache,
>>> lock it, then make sure it is consistent.  If not, retry.
>>>
>>> On the "free" / read in (ELDU) side:
>>>
>>> 	// get pcmd_page ref
>>> 	lock_page(pcmd_page);
>>> 	// truncation is not a concern because that's only done
>>> 	// on the read-in side, here, where we hold encl->lock
>>>
>>> 	memset();
>>> 	if (!memchr_inv())
>>> 		// clear the way for DONTNEED:
>>> 		ClearPageDirty(pcmd_page);
>>> 	unlock_page(pcmd_page);
>>> 	// drop pcmd_page ref
>>> 	...
>>> 	POSIX_FADV_DONTNEED
>>>
>>> There's one downside to this: it's _possible_ that an transient
>>> get_page() would block POSIX_FADV_DONTNEED.  Then the zeroed page would
>>> stick around forever, or at least until the next ELDU operation did
>>> another memchr_inv().
>>>
>>> I went looking around for some of those and could not find any that I
>>> *know* apply to shmem.
>>>
>>> This doesn't feel like a great solution; it's more complicated than I
>>> would like.  Any other ideas?
>>
>> If we could do both truncation and swapping in one side, i.e. in ksgxd,
>> that would simplify this process a lot. Then the whole synchronization
>> problem would not exist.
>>
>> E.g. perhaps #PF handler could just zero PCMD and collect zeroed pages
>> indices to a list and ksgxd would truncate them.
> 
> I.e. instead of immediate response, go for lazy response that is taken 
> care by ksgxd.

Could you please elaborate how you envision this solution? From what I understand
there would be a per-enclave list that contains information about empty
PCMD pages intended to be truncated. The page fault handler adds pages
to this list and the reclaimer needs to remove pages from this list when
it writes to those pages and then do the actual truncation - but it is not
clear how the reclaimer will know when it can safely remove a page from the
list since it obtains PCMD page references in batches.

Did you get a chance to consider the fix proposed in
https://lore.kernel.org/linux-sgx/d4b52482-2dd0-d5f1-bda9-e1d97883298d@intel.com/ 

I understand that the email thread may have become hard to follow and I plan
to submit a new series today.

Reinette
