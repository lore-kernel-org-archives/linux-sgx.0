Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BA9C433EF
	for <linux-sgx@archiver.kernel.org>; Sat, 30 Apr 2022 03:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381060AbiD3DZp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Apr 2022 23:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiD3DZn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 29 Apr 2022 23:25:43 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491F2D081F
        for <linux-sgx@vger.kernel.org>; Fri, 29 Apr 2022 20:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651288943; x=1682824943;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qBhpvlRmKBujCeCQ4LjjAJRqtjhC0y+yp9sDyDOtVoI=;
  b=CpH83gch+/AF1BL+Y+0YfCUJhN8DopnJlEHnRmUZyyV5e/H0tWv6QoWd
   +0Q+P8uLLyvzrm144p5s1nValy6OZOBNBafHe1h4wdVAw9NirXGr+rWpq
   L4hHaHH5UGEeUnO4iqL7/neUocEUPLTFkXs0BZogA/KumanBHYCXW48aP
   xi0JvGPQzoIcBEdTH3UGDUgo/1pPBaOvKCk+NFjgBEhCDn0Jvm9dTIhXv
   6TE+KJBxHYLjV/kLnBSM/fe0V6jQ7ov2KzKZ3YyEgUFu6zS3eofUxP8FN
   XhTEJLd7oOqpPQZ+La53CsqLwqwqYTYuKfbHW3WWkT7iMpgBk16Vp042W
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="264412257"
X-IronPort-AV: E=Sophos;i="5.91,187,1647327600"; 
   d="scan'208";a="264412257"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 20:22:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,187,1647327600"; 
   d="scan'208";a="582562675"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 29 Apr 2022 20:22:22 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 20:22:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 20:22:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 29 Apr 2022 20:22:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 29 Apr 2022 20:22:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9jHMym2fKpkfyIYVqPavWO4g/buC0NGjRJnzmiQMvc8Omp5j7xvqohd5PpcpKRQNMUmW/gvUE+k708o064BbMaG54pEIBbOUKvFgpqNI71efDSnf9D+sNO8AyprgQlpb+RbLBqNl8ZY1A43Vh60YHdaNLURghZkRFIFQwXgie8U5plRRbKG3jZ4beKSfDECoYkRBCvuiwVhfnGcSlEo3J0rl1kI4mI5OHWu+4AvRtUz3hIbKyru4bhWCNzja4MPXzh2rcdr0m2gHQ4Go9HcWRiGhWhl7e9L+OLQI3vxGH9UOB2Lury1VpUGz2EsE7G01bTY5I80QgU0UVSIYzRAsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQANy9UIf0cXrCkn8xl3PN0HqqEAvaAB+L3gL9nH1Yc=;
 b=LcfML8LmONUnbO07hUe0riq8sDx7/yV7+3kQW6y10jpVujJSOka4Is0c3QBUNFkujamDknCHEO6BW7K26+fNvti89D/DoLD+AUKtMzK4FSuHOeB3X3nBxKKNEfVsEEISKBZYhT8RD2JEA8bLcqZxLhs8eNz0uQKYYkiFk8N+kXx0wY36/c/yFATKM8PVy4cScoNjC15UcZdwCi4Kfyioberw7bGORC0otw7HUiU0thxfJvAx+kitzjAB3+MlvyzxkDDYznSemxkk2uo/4zxmkmT98JrpAj2OVOveqwSJMUBChO+0UCDBPW5GWetINQG47T/SO1BQZXbi6QysLkjEVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by SN6PR11MB3373.namprd11.prod.outlook.com (2603:10b6:805:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Sat, 30 Apr
 2022 03:22:20 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.013; Sat, 30 Apr 2022
 03:22:19 +0000
Message-ID: <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
Date:   Fri, 29 Apr 2022 20:22:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
 <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
 <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0222.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::17) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dabd4ef-de0a-4960-6237-08da2a58a215
X-MS-TrafficTypeDiagnostic: SN6PR11MB3373:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <SN6PR11MB33738EB77403252CF1325DBDF8FF9@SN6PR11MB3373.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C72oEiQ81CMnjbfh/FVpL7a6NH3eAp6yLLpTgwtDQcU40UJ7q/po74LlJ5VQ1bwsxtuzrkC5DlcBmvsU+u3U/o1fPw2gFTwEiyXa8OzzZP4Eog3d4ovjtfF4SHy4Vpoll7q/g/RjXF7ROE9yirhnvwWcybluJY514bRje7Tljpzc+U22ehwIowy6Ud+RsGrF224CZAYuRRt+1uz8VgQ/SAjLwmMlYQzhozDqaREFlc+3QdWXom12eYRjX+DjTV4vWrP6SY+P42fRweJ05uIW4w5HDF1aipvU8jqDAOxqpMc17OUifyxMgM8znIrGyabjbkBznfuUbl6oAGpYRNvC8j75SkDgTYCXTxpDc8a1OK4/stTPCJPOj8KoyMOwiqHjWL593c4BPKkt7YHWq5Yg9m6y63CSeFp9/tvK9jhDzV0ss8CjXRmtNGCSRqtv2fDWJCfybxEuXptwg182bgzj6IlyeuJ38McwgNDypg2kX2w6NSe/xiRyxSjeiGOV/BAqhhv6OS/VWdGjWwVDwo0aUnudC1K39fQt+KfFWq5HNnkF//FrEsbP3g8R6AvNghLbRg/bYHMNestDjGjdx0XeEx+wLQV49BSA7k1Ch+1xn/j9yJZZ1bJVCtgDAwyGAUo2M3lLe4IK+J3efLaHZ+JJ7RV8/NkR+smrtZCmpPmkEzFEWc5Hy4avi1Hoo7+otSoXUupGDi/8FgBgCextp0DcNkC4FU3C6nnmggPR6hud2EHy98hp+Nq8DStQ+8wOS1uA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(66476007)(6506007)(6512007)(6666004)(4326008)(86362001)(66556008)(66946007)(53546011)(8676002)(2906002)(38100700002)(83380400001)(82960400001)(31696002)(2616005)(186003)(31686004)(316002)(5660300002)(508600001)(44832011)(26005)(6486002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czY1Ykw2bStsN2tpUGMza2pSeks2S3hrcEJoT0VFbkc4OWdEMGxsbkFKMVpo?=
 =?utf-8?B?T3hvQnJwTGZ4UU5zZTBlRGtZUU41bTRicnV0T1RmTkZSSE9PaEkyNmN3SXR5?=
 =?utf-8?B?NXltNElDejdPQ2MzamdabWk3b1JFWnpOZXVvcjYvS3dQVXdCemlwV0EvcWFF?=
 =?utf-8?B?RFgyQjh4TnhpYmVKMmsvZkluQmk3bVBESW5qRG54cG8vMXB5LzZ1b0NVWnYz?=
 =?utf-8?B?UFN2TUtRSU1CWUszTkp4a0lzbU1sUm95L3RuWVR3VDV0WXdsRXBxUnFMYStu?=
 =?utf-8?B?NHpYb2FVYkRlN2Qxc2hiN1FQV0o1aVB4VlVkUUw2ckZVZDEyaGtYMEdHOUdr?=
 =?utf-8?B?NUVxdS9qZm9zendaVFFpTWE2MENMVWxGZ2ZnYTNOODEwZTJFVzUwWWt5ZjlG?=
 =?utf-8?B?UU0xeDIwekFCSlB1Qkk3eFBlakRsQWJYWjFGamRWUFBXQnR5MUNKc250SzBK?=
 =?utf-8?B?N0Z0aW9LTmZMQ2xXS3V6ZnBhOXNTb2ZKY2hjSWRTSW95VkpBRlZvc25VckJn?=
 =?utf-8?B?SFpTZUNJRVR0NWxhd2FjQW1UeE4rdWhOOEcwWEhKMitRdlhzWU9SdGVRQmo4?=
 =?utf-8?B?QnpXVEM4WTdFUlZLc0NFSTNuK2JlelpnZUtLQ1p1SDRxM09HQVp6cGQ0ZUcv?=
 =?utf-8?B?NmlGeGJVWUFFajJsZG93MWhUVzdnNVI4TzhoVld5V0xNMnNtTG9MZFFNeU1Q?=
 =?utf-8?B?c0xYdnVZQnBHbHJNSEFheDJDeDJteWFnTStTaWJHSVB1TWd0YUh2R2ROYnls?=
 =?utf-8?B?aHBONmxQOWVwN0lZRGJlblF4NS9WWmFKM1ZnUXMzblYzdzVBQnhES0dZdGdG?=
 =?utf-8?B?U0VBYTVzYnhWdElVZDdvbGFsZkVmM015U3FkTUEwbnk4ZklmRkxRd1ZielV5?=
 =?utf-8?B?ZGJkV0JpQXJ2aXVoYlFRanZIZTljRHVuVFh6aTNWMDJSTUZVTlh2T2Z4a3Z6?=
 =?utf-8?B?TWM2MmtDM3dlSE9iZW1DS1N5cWVUYlJhYi9kaTZaME91ZnYrQ1pmVzBQdmFO?=
 =?utf-8?B?NG83bVFGL3ZZNzdyQUFGS0RFNWY3OVhhcmUrc0ZNSzhzMDkrZSt6QzFTbzVo?=
 =?utf-8?B?L2JTcjM2c3QyaDlHQjBHWmFRN3RRbU8veUZWSllTQlZ4Ni9KeUg0WnRNam5i?=
 =?utf-8?B?NlF5RjFpN0twMlVlLzVyYmdDSlY5bG80dXZ0aDlWeDFTZlQ2QVhRbEtETSs4?=
 =?utf-8?B?cTloaXNHOStlODBHclpMSHhWUXhkM1Z3VVk5OVdGNWYxY1Nvb3doMFpldlI4?=
 =?utf-8?B?LzJSSTJjdllUY3B4MHJCNGlodDZjRTZYeDhXRXdrK2dXWFFFVG1kSCtFRHBM?=
 =?utf-8?B?ZXFCRXdZMHZMY2VZejJyVkl0Ym0wSUsrWENLYTBoeGZvNUZ5VWxqRzFWMlpK?=
 =?utf-8?B?QWhUalQ2NmZOTHJsS245VFlQOVVzNkltQSsyNkJiQzZTRk94anBKUVR1SWVQ?=
 =?utf-8?B?VVpnNVNZb2RRdXAxVXkzb0tXVmdFOWJTMk1FS013VWY1MDFEOTRoUXJMa1Nn?=
 =?utf-8?B?V2hQcGZaUXdCZXJmam9wd0Q3VWlENWZtRTd0UExtaStHcitoaFRyUG5ITGhn?=
 =?utf-8?B?ZytwRGxQNlpsaVB4S0o4Z0ppMGw4bmxLZStLenppR2lwVGV5UlZhNTk0U3Rq?=
 =?utf-8?B?ME80Z1Z1RFRHaDdoYUlyUDFaVzdwT1RjWllicXp1ZENRbUJ4QWY1ekxVSFlh?=
 =?utf-8?B?a3p2aTU1czE0Z21rZldSSnJ2MTNNeVlKVnA5aDM3RWw1WE9NQ3E4bkpOTWM4?=
 =?utf-8?B?SUlRRFg4emc0YUZLYWNKVU1vMHlwTnZ6czlqQ0NUVkE4Y0o3ajJXbytYY25Z?=
 =?utf-8?B?alhTb1NMMi9FT2xaU1lYK3MxWTJ1b0R2R0tCRHg5QkdYK1Q5aWRGTVExVDdi?=
 =?utf-8?B?a0tXSmVFUWxJeWVoaFpyUmpNN0Y1MkxQVEhmcnhxakNVdi9TdkFKYUNkODR2?=
 =?utf-8?B?UGpxWlRORndycXNLNWdqOERBNXZIb2czdFZHcndlUFE3S3MvL25ieGR6N1d4?=
 =?utf-8?B?MEgrbGx2R3JmK1c5VVdwRlh0Q0ZDeXpqbWZYTzZIcnA5TDZTc055QlpybjQw?=
 =?utf-8?B?V3RNaWV1UGpubFZXSlBNQ3dwZXYvdk1RVWl0VmZicHJUc1VDWWYyU0hOOU13?=
 =?utf-8?B?K2UrWEZRdVdDWUJQdEpqWTlwZjFtRjVtbjZwbVBOOEw3aVlkZk9QM1cwV3pS?=
 =?utf-8?B?b0Z3Mmh6V0h6Q1kvV1FmS1dRMmkyZmc5S1g3dVNWOXZieWcxWWI5amp1eG5W?=
 =?utf-8?B?Q0d6QVhqb21GWWI2N1VPYXZtRG9VNHNjRWlJRmZtMldFSk51YndEWE5IYTNW?=
 =?utf-8?B?M3RiMmVuV2xESWtqdlFXc3JiSzhBL0VRaUlibEg2QnVrc2tMc3FwVFRvbGNo?=
 =?utf-8?Q?8ABKIm8vOc3yhXGY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dabd4ef-de0a-4960-6237-08da2a58a215
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 03:22:19.4270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsq0SdFAuGloT/cHJPHloWsnjeZfCnhQrT/DXiGGHNC5mw/kHrWskAOr3YYSq7euWgR64YlQ2lVtXhieZCbkZb0cwzgwtwnhdwI9QXcHqrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3373
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 4/29/2022 12:45 PM, Dave Hansen wrote:
> On 4/29/22 11:50, Reinette Chatre wrote:
>> I am not familiar with this area - is the PFN expected to be consistent? Do
>> you perhaps have an idea why the PFN of the PCMD page may have changed? This
>> is running with this series applied so the ELDU flow would do a lookup of the
>> PCMD page and not attempt to allocate a new one.
> 
> First of all, cool!  This is really good progress!
> 
> It's possible for the PCMD shmem page to be swapped out and swapped back
> in.  The pfn would be likely to change in that case.  But, that seems
> highly unlikely in that short of a period of time.
> 
> I'd dump out two more things:
> 
> First, dump out page_pcmd_off, just like you're doing with page_index in
> case page_pcmd_off itself is getting botched.  I looked but couldn't
> find anything obvious.
> 
> Second, dump out the pfn in sgx_encl_truncate_backing_page().  It's
> possible that something is getting overly-aggressive and zapping the
> PCMD page too early.  That would be easy to explain with that PCMD
> locking issue you discovered.  But, your patch should have fixed that issue.
> 
> For debugging, could you double-check that the PCMD page *is* empty
> around sgx_encl_truncate_backing_page()?  If there's a race here you can
> also enlarge the race window by adding an msleep() or a spin loop
> somewhere after the memchr_inv().
> 
> You could also hold an extra reference on the PCMD page, maybe something
> like the attached patch.  That will let you inspect the actual page
> after it is *actually* truncated.  There should never be data in the
> page there.


Thank you so much for pointing me in the right direction. With this
information I believe that I found a race condition. I did create a
fix for it and it has been running for more than an hour now without
a WARN _and_ without the -ENOENT error introduced in patch 4/4.

Please find below the description of the race and the fix.

Scenario is that the reclaimer is evicting a range of pages that
are being faulted right away.

Consider three enclave pages (ENCLAVE_A, ENCLAVE_B, and ENCLAVE_C)
sharing a PCMD page (PCMD_ABC). ENCLAVE_A and ENCLAVE_B are in the
enclave memory and ENCLAVE_C is in backing store. PCMD_ABC contains
just one entry, that of ENCLAVE_C.

Scenario proceeds where ENCLAVE_A is being evicted from the enclave
while ENCLAVE_C is faulted in.

Scenario is with this patch series applied.

sgx_reclaim_pages() {

  ...

  /*
   * Reclaim ENCLAVE_A
   */
  mutex_lock(&encl->lock);
  /*
   * Get a reference to ENCLAVE_A's
   * shmem page where enclave page
   * encrypted data will be stored
   * as well as a reference to the
   * enclave page's PCMD data page,
   * PCMD_ABC.
   */
  sgx_encl_alloc_backing(...);
  mutex_unlock(&encl->lock);

                                    /*
                                     * Fault ENCLAVE_C
                                     */

                                    sgx_vma_fault() {

                                      mutex_lock(&encl->lock);
                                      /*
                                       * Get reference to
                                       * ENCLAVE_C's shmem page
                                       * as well as PCMD_ABC.
                                       */
                                      sgx_encl_get_backing(...)
                                     /*
                                      * load page back into
                                      * enclave via ELDU
                                      */
                                     /*
                                      * Release reference to
                                      * ENCLAVE_C' shmem page and
                                      * PCMD_ABC.
                                      */
                                     sgx_encl_put_backing(...);
                                     /*
                                      * PCMD_ABC is found empty so
                                      * it and ENCLAVE_C's shmem page
                                      * are truncated.
                                      */
                                     /* Truncate ENCLAVE_C backing page */
                                     sgx_encl_truncate_backing_page();
                                     /* Truncate PCMD_ABC */
                                     sgx_encl_truncate_backing_page();

                                     mutex_unlock(&encl->lock);

                                     ...
                                     }
  mutex_lock(&encl->lock);
  /*
  * Write encrypted contents of
  * ENCLAVE_A to ENCLAVE_A shmem
  * page and its PCMD data to
  * PCMD_ABC.
  */

  sgx_encl_put_backing(...)

  /*
   * Reference to PCMD_ABC is
   * dropped and it is truncated.
   * ENCLAVE_A's PCMD data is lost.
   */
  mutex_unlock(&encl->lock);
}



What happens next depends on whether it is ENCLAVE_A being faulted
in or ENCLAVE_B (or ENCLAVE_C) being evicted.

If ENCLAVE_A is faulted then the error introduced in patch 4/4 would
be encountered since lookup of PCMD_ABC fails. Before patch 4/4 a new
PCMD page would be allocated and then ENCLS[ELDU] would WARN on the PCMD
data.
If ENCLAVE_B is evicted first then a new PCMD_ABC would be allocated but
later when ENCLAVE_A is faulted the ENCLS[ELDU] instruction would #GP
during its checks of the PCMD value and the WARN would be encountered.

Below is the fix I am currently testing. It would not truncate the memory
if there is a reference to the PCMD page.

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 22ed886dc825..81c7bfc12b9b 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -98,11 +98,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
-	sgx_encl_put_backing(&b, true);
-
+	put_page(b.contents);
 	sgx_encl_truncate_backing_page(encl, page_index);
 
-	if (pcmd_page_empty) {
+	if (pcmd_page_empty && && put_page_testzero(b.pcmd)) {
 		ida_free(&encl->pcmd_in_backing, PFN_DOWN(page_pcmd_off));
 		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
 	}


I plan on letting the test keep running to make sure it really fixes the
issue. If all goes well patch 4/4 can be dropped and the fix included instead.

Thanks again for your guidance. It was tremendously helpful.

Reinette
