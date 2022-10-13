Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94ADCC4332F
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Oct 2022 02:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJMCFc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Oct 2022 22:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJMCFP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Oct 2022 22:05:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E64676568
        for <linux-sgx@vger.kernel.org>; Wed, 12 Oct 2022 19:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665626700; x=1697162700;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fUaVblQcw0YKzSWDx1FwQ4pzNZhPClnIyIromYwZEUE=;
  b=OPblPnrZePvOt++mYoz57GaZeFonZ24DjqtU/PL21/uSyx0bcR4KGZFq
   6zYOzFrVoSyz86qFmlGRKm9PmbsPWBL732FFB8Vxz+6IyVMtwZK7lIcZh
   ZveplDFsKUZPxxvtrJa3Ls2Skk6GkcpROS/4r0ENLCOimhjPuIdGsQY/8
   piAD6tBoROFPdfwNJRyRYI+UNviMbW/jq0KHxk20tldwMKAwFJxxyKiju
   E4B4C+H1CMixtd54gq6g3dTvIjD9XnNfeS9eg3EvHxBnLrySKD5Wkbt4H
   d+Wva0kLz5O0t0v9jCctV70j3WJH0DiRvn8CXOJYINxX7MrpPgLOqHQQ5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="303694536"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="303694536"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 19:00:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="752341882"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="752341882"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 12 Oct 2022 19:00:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 19:00:29 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 19:00:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 12 Oct 2022 19:00:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 12 Oct 2022 19:00:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDlIfFMSDyOlb+fNsf545SIgZs+s+fayuM93Tj/RNqwN3Xv9aqjhsurjRhfZWg8r55AlpMmPtD9Zrh9tlqEPXLyNLzS2KxkTrBKn8icZ1N8+lhLrZYMCqjHPgaIlo7eLc3EoK/FEr00sy8KF/Kr7JIqeYmGkr3EAXxGDGwABUxhjVKVxvcLFao+61iKudq48zWzq+W59JeiA796zFBBBsLiSPdD/1pRBd+Yq/njFao73LTAulSPFjeuotZvuO99ojoPp/hznT8WzL0/ANL2xmcdC7H+Ala92UeKSUOi2pmT9nRwW/mLI8PQ2NFxaQvGQ9/DKfEDSWB0xCEFVJNU/uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4Uh4u+Wr2UeIM3ZeSpqj5zQapDFvLaKvzIEXKBeCDc=;
 b=QA7ClSLiWHvQbK4PzM4EKV2oH5MBTlGKVHHdJnIEJzcvWAVeQeh1Kv5lmtym9pLHfXIVVJmEQ4zQfYM+5nrHOPms54fYZzSTToPlcibgqLTUMHVwrx21bV8EyRIxWn4Wjj66JMLdKkEbkWfYguVItcThwyh5akjQ2sG/cufcOKrSEwOFu9wMrVi5t/D/8VxXNg2tYpbWo/WaPlAZZJ96IGaXCPH3p0l3zei126/6jnNOH/V5Iggr+l0jJLCWlDyYYYINWIG5gCf03PSvZsjDf+NXp/PVqS30Spym2qqW8kRoIRIyWdRpgeE7C7bMZ8IG9YD6SATIWjte5Qab2UP99w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CH0PR11MB5378.namprd11.prod.outlook.com (2603:10b6:610:b9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 13 Oct
 2022 02:00:26 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e%5]) with mapi id 15.20.5709.019; Thu, 13 Oct 2022
 02:00:25 +0000
Message-ID: <847deff5-ee96-6299-f7cd-29d3c4cb4b7f@intel.com>
Date:   Thu, 13 Oct 2022 10:05:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
 <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
 <188a334629319e430e16d4caf5e4a421b80c357a.camel@intel.com>
Content-Language: en-US
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <188a334629319e430e16d4caf5e4a421b80c357a.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:3:18::25) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|CH0PR11MB5378:EE_
X-MS-Office365-Filtering-Correlation-Id: 50cff21b-add7-4c54-9ad5-08daacbeb18c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lnAmFggj5kS2TSBkNwV0xy06/ZUSvY2+0rtgj3qw7/aqHNnKuXqU7+FP3vX/dbLbcuwY2XkwtFjvHzNOA0sKiL9WDvw+Rlk/xxYFc0sfYiQDVSS+wtWirJo0GLSrEK2vgyN/EIGVDXBzyPS56OuCegQb4sKg10yeRW00XhDGr5vNT939kLavljDLjEHjBdwZiJC8MWsJvqzOvy0UhU+/ATJnXo9faRD659rTc8RxOzL1PKvHIG5iJyaXky792V9TzCHGueHXa+/lQEPwEWPgLPj0cRkRUyoIltoKv8JpWjFdl1268qtJt6/agOqnwlWz/4eQNycLHRSWJavscR0Ea+HCBW4NZwK85mtt8Cwqy5MW0wuq5BspsXKAIFHpHtDIQYxYecSCpbDgbrlDoahbh26mWWPm0iDAh1ng7ilQpouKuh4nx6kVpGNw4NdSFOhZI9zf2nQ9pzFotyADaiMcbfv7ftjTg9NLF1keMypiqNa0TjvWZSUT3sdg6MQzwaSR3R3UaERpcyxiKTU3jcKCeTGtSLeW2IJssmzRmVaSlGyi0Loga9C2Zf+164uMKXc1Yv6ImH2ExFSLD/7upttgpTvvyxS59evRAvC2/zf/XY9zm2fLJIKuz/oZYY/6akRIQPO6cEeRK0nbflp37yOB/9bftLBS9zuW8elxBlfSzINlzsyaRPhibo3nLVDY0XZ4UV8AtTwkwntoNhZUUg03blx+nALj8XTvh+Iyegm0hvBO2nCGmJNnO6hQm+0/gsLsbCQzPwJWcz8sPxrvNp+uNPwtB/AVlexufW4a7xO0IbgwMbJFkspnqaiK3ZwRK3Lk+nUVZdfbV2FTRTSHMOJykA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199015)(478600001)(966005)(6486002)(86362001)(54906003)(41300700001)(110136005)(38100700002)(36756003)(31696002)(66476007)(66556008)(66946007)(4326008)(8676002)(6506007)(26005)(53546011)(316002)(31686004)(186003)(6666004)(2616005)(82960400001)(2906002)(4001150100001)(8936002)(6512007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkZtVUV6TnE1cXpoZE5qUTNjMm5zcE5CZkFGcGdCZS9RWTBzM1dNMm5ZVUp0?=
 =?utf-8?B?MjBZTXRCYU9yVUhKSG14a3BaZzUvTWZLZDNNdUpML2FtK3lCYzcyYVJhMitl?=
 =?utf-8?B?bEptL0w1WnBScG54QnFGcG1xMWxacU02bE9EV3R6NGsxc0JYSjVPd3Z4Mjhu?=
 =?utf-8?B?Yk1PdVVCODFVQVBFb0FNY1oraDlyTmNORGVhRFY1aGNsWGR4UHVwckx0NFVK?=
 =?utf-8?B?Q05ncDhRaDdUM2JETWV2MkFqMHlWdmNMVTlWYW1oVDEyWFppSno3R0xFMnVB?=
 =?utf-8?B?RU9mT283azBLYkd6T296REpOd1hST3VGM3FmZm9PNnNNZzBWVGdCRGQvanpv?=
 =?utf-8?B?RzZVSXBtZVB2Y2lpZE00NFB6M1JFdFNkTzFkM0JVczlDMllBVUtCWVNyeHh2?=
 =?utf-8?B?SktGWlV4WjkrWVptSjliMmpneTJjQkJNdThVOFRqSGhZWUc5K3dvaktFYU91?=
 =?utf-8?B?bnhabnArQUpOMXRNTXNmbm9oMUQwbmRmMGt4ZSs4dnlHOTZJamFjQ0kxT1RY?=
 =?utf-8?B?K1BWNExIUmpXMEhBd1dNVVkxV2poS1lUR2R2YWxmUERpY0EwcG1zcU5KMFY5?=
 =?utf-8?B?S3dmZEh5Qm1WcGVNcEtGZTVHdE5YK0tObjdmU3NyQ2VqZXAwcTh4SWJYc0xE?=
 =?utf-8?B?Mk1NNVhac05GN2dhSHBoVFNSaENxT1lkUlpkMHR6NTVmdkViRGx1RncydS9T?=
 =?utf-8?B?eDBVK1JqOXNFQzc1RFJOVitoNkk5Y2RlQUNneCtFdk8xWDFiN3JYYlZjcnow?=
 =?utf-8?B?WkdHOWh5eERDSE1sRG5aQkFicEFOU0lMVU40MjNBUU44RmNueFZSNFFSbmVI?=
 =?utf-8?B?VWdGZDFFNmZhSEszMDl1TU1IRnNxNEdPeDNiNUxTZkt0ci96MkUvckQzb2NN?=
 =?utf-8?B?cHplNlI0b0VHK05CaEtNTWFQeWd0QWZQR0tnSWY5UEdyVEhMUVRsV0Eya2tq?=
 =?utf-8?B?ajJKWm50WXplQk1MNmtucE9PR2RJTVY1VEdFVHJ4RUFpQ3dxYkFGQWMya3o1?=
 =?utf-8?B?a05oT3hKdVZVTWd6L0I1OGN4aWV1ZkExYmRwTXhVeW1VMG82VFNxL3EwUjlS?=
 =?utf-8?B?bU1NSWgrakp3azVmTUtJNk9YUXBqSXFlZVFlM3VyNEFJbC9lU1pJMXdvM1pa?=
 =?utf-8?B?eFlLK290M1FadDg0NVI0L2lLTjZ4aW1pTEZZSEJuMDBRRXpINmdxWFpTaUhw?=
 =?utf-8?B?YVdSMmVxaDhseG9GV2pqQWdNMnR0UmlOWk5FRUJSbEU3TnpsNi9uMDhGOC9J?=
 =?utf-8?B?ZFBWUStrOE9JbTR0ZWYrWVgxOW5IazJ0S1hYTFlTNUxBaTNhZjJWVWZhd1J6?=
 =?utf-8?B?MUh2RmtwenlQUUpZRkJRMnZqVm1CLzV2OVJHek9VOTJIMEhYMjQvcUtFaEdt?=
 =?utf-8?B?U3J5UE1aMmVOM3dJcjR4T2c4WXBKL1l2dktqa2tqcmhrMVp0MU1vblo5WVor?=
 =?utf-8?B?RlZhbFdCYjdHcDZsQ3VjbGlROFl5cVhZOGNvSnVHaUxLeU04dGxMdkpwUHgv?=
 =?utf-8?B?ck9XZ3pJWDhuM2g5U1pST1F1QWdUbjJMUFhlYlE1UnhNVFVyM0ZZSCtrTzhi?=
 =?utf-8?B?akxoZmZLSGZqd3VFK3dTZWp1eFhuTnlMdk4rVng5RjNtTklGdk9Pa01kOUhX?=
 =?utf-8?B?aWJFVnJNSzFLbkF2ZlRWUjJPeVpyL1FndEdXTWpISCt0TkVOd3UzWWN2Z3Yv?=
 =?utf-8?B?K2pRNUlEWTBOWW5WL0xLUThxNmpQMGVTRXI0RHBZdmxQMUZJaEtwYmZldHlV?=
 =?utf-8?B?U2prYzNxcVpuTUZqbk4wUFhoYUpmLzRjK0tBYUN6SmVjZzFTT0lTdDNYMGxm?=
 =?utf-8?B?bVJWbXlKRlZqV25HLy9mWGpSejV2K2pRZ3l4VVAyNGRocnBIdFlWZVlRV0Zu?=
 =?utf-8?B?MUl0dTRCbTR4aU1uTzZzdjd3cVV3VGd4MDNoWU41TUJUcmVkWWtNNDNBcFdP?=
 =?utf-8?B?dEZtL2kxeWhQVytSQmVLYk9ZN3UxR1VDYVhkUVo4TVd3L1VrSU5SbFhpMFF5?=
 =?utf-8?B?WG5ZZ29ESHB6VVFWTHY0U3ZxZFFUNm5hV3Z4SFpSR3dFQTc4c2E3aVlYcWZJ?=
 =?utf-8?B?WmJ3YUhRUm9KZ052MmhrdUs4cFFQemlXZnFjdUNiZlhncWp1Wmp3NE8zWHFu?=
 =?utf-8?B?bjdmbG1rMmhlbE8vc3p1dGs5WWRVaHB6d1dnRUZlRUtoTXhrZmNHRUMvOW91?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50cff21b-add7-4c54-9ad5-08daacbeb18c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 02:00:25.3579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h14s2eJwrlF9aq1YhOdsPARdM6YFRaPI1RNUHweWwnO3lFp8iEGb2AV/7kvF3xKF1eB5cUO1LKhIrOJ4zVSjwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5378
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/10/12 19:01, Huang, Kai wrote:
> On Wed, 2022-10-12 at 13:09 +0800, Zhiquan Li wrote:
>>>> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
>>>> being shared by multiple VMs via fork().  However KVM doesn't support
>>>> running a VM across multiple mm structures, and the de facto userspace
>>>> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
>>>> this should not happen.
>>>
>>> This is out of the blue.  Why is this here?
>>>
>>> What happens if a hypervisor *DOES* fork()?  What's the fallout?
>>
>> This part originates from below discussion:
>>
>> https://lore.kernel.org/linux-sgx/52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com/#t
>>
>> It intents to answer the question:
>>
>>     Do you think the processes sharing the same enclave need to be
>>     killed, even they had not touched the EPC page with hardware error?
> 
> Sharing virtual EPC instance will very likely unexpectedly break enclaves in all
> VMs.  Whether kernel should explicitly prevent is another topic. To me I don't
> see strong reason to enforce in the kernel.  For instance, multiple VMs can map
> the same file as memory backend with MAP_SHARED, in which case they can all
> break.  Userspace should use virtual EPC in the right way.
> 
> But the point is above is not directly related to your patch.  On host where
> multiple processes can share one enclave legally, it does the same thing.  I
> think you can just remove that paragraph from changelog.
> 

OK, I'll remove it since V10.
Thank you all the same, Kai.
