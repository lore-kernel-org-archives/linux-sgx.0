Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48787C0502A
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Aug 2022 01:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiH2BVp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 28 Aug 2022 21:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiH2BVo (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 28 Aug 2022 21:21:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6A927CF3
        for <linux-sgx@vger.kernel.org>; Sun, 28 Aug 2022 18:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661736102; x=1693272102;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w6WxvPT3JiO+O/ejBKPzFZZcnAo/YqaNPc7TmDbwuwA=;
  b=Hg9g+41GpL1GOCX38wnar2p66qpiONnsnJR/VL/5SNKZUkIs2E9i/d1M
   3D+mVFTVxdj/ng8FE2Fm/hGzYc8ovjf/q5gGMX1wwLE9Bn4u3yI7B+zho
   q+dBi4YYDMvs3nmFnf8ehHv5yDys6/esceYB3DXzlzN/JYAEjVmgBtzwi
   yCb8K3dGi4emy6yIUod4lGao4hodbHxwlIxvqHJvHzicQMqmY4C6Qnpyp
   lcFQ44ajPBXkzSL1gZXA5MW4f/0O5gd5NkHuVt/NhDNombFZwltT7f0vB
   Xid9KeumlzTP3pL42Qn+NxUOrTl2Vker3QLvII+hCvT+Ra9dAg0p5bxqu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="358750178"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="358750178"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 18:21:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="939398679"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 28 Aug 2022 18:21:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 18:21:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 18:21:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 18:21:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 18:21:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H74W6E/5UzcX9tpd10ocKXeeNIo/sCrQl6bqQHT7YDWxWsQ6QmhCWKpn1ATOEFsQx274RognLvnJeeZX7nUoDELTGY+V5Nzwb/5JvBgQeUrO5Wyc3UU8jCL6uzm4IwvgxsHCQotarradbnXryslpaQY6Enz16hkUbndm4erln6YZ2h4wD4bJElS6GRnwyXmGQPwbDRZ1flVLm5SMvBeKL8rNFv+iLOUY5hRM5yCjHLb04OfaQDo3eNA3fb/i65ek/2r8wFpzJaimq8XYknugPB3FUYt9RqQYe/LpVa6rAnWpcXoLsjkKAG5CFxMplsclVo5kWN2yGEwK33jHTIBwew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4He3kDJ9MCpBZNDadDANA30ta4RSXHH6DJn45vwASJE=;
 b=XIKxLzSMvGlG385Txw7S+QL0US+MfnE0gNHHc2qd8iksgL1fZHx3ByLQKZHLuqWnxFXQJr2Ft0WT7H5KyB3zOfZXtU2w65ZqRu5Wt7u3vf5EbyBf0Li+K3M4H0COQMVVz625Z93C58ctz/YmRBjoIrMrcQD9/Yrj2ySsHLdnpdKEz+99DLiPRSi6LSRI1rUMaavPGDWRUc4MEGkiTgqxKkVZKKOc0jztuKo/2LgG4qX9Sk3rsOFueE40XfjviY0jlquVs7D16xgsauvKufQ+SqOVR8X5wUfzI/6WE/K4/I9QSjj5zxLxV+mAc2SN958utEje50AUQIPFcb/3fLDdDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by PH7PR11MB7099.namprd11.prod.outlook.com (2603:10b6:510:20e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.20; Mon, 29 Aug
 2022 01:21:30 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 01:21:30 +0000
Message-ID: <981df5cb-cd6a-e941-dc98-151257d4f1a8@intel.com>
Date:   Mon, 29 Aug 2022 09:27:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH RESEND v6 2/3] x86/sgx: Introduce union with vepc_vaddr
 field for virtualization case
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <dave.hansen@linux.intel.com>
CC:     <linux-sgx@vger.kernel.org>, <tony.luck@intel.com>,
        <tglx@linutronix.de>, <bp@alien8.de>, <seanjc@google.com>,
        <kai.huang@intel.com>, <fan.du@intel.com>, <cathy.zhang@intel.com>
References: <20220826160503.1576966-1-zhiquan1.li@intel.com>
 <20220826160503.1576966-3-zhiquan1.li@intel.com>
 <YwqQ1HRzdZNWM1VX@kernel.org>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <YwqQ1HRzdZNWM1VX@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0186.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::14) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c305258-0a87-497c-4909-08da895ccd53
X-MS-TrafficTypeDiagnostic: PH7PR11MB7099:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9aZ+hC1YQbz6jx3rxFAmyn532xXFs+lSdqFWwUBqtaCSafS2V4upzzu158Qo35nbVnTihSL9ZWSv5zj/4uBRDng7U6mn9igLsxwZJq9pqAIDRj3r9EuFKohBX3K+N8oqcR2a1xEKuEJllA+mfinaHmSY7QMebe+j3TRNVSHcQZhOwEgMUvzx4HcBqN9gXxhfi7kb1MN1pS6QRKuzP6BiEU8of2ef+p1YqR24GhwdNMsQrWvnGoHpNULlKMW3PAdNDyk+/naJkGvWgr/9WFuEZsQcKtdteTFExsnUUiboWQYP4dRYXhdzeThUliQ8lFSN3DtI1jJkfwHeKfjUEhMeQuzRI/ChROTw4xXJl4u4AcGE8nBAOex1ZJghaTJWnXAy2xrZ2zWyqsPHS0hmCCz1gCowavaJQV/NQZV5o6lgxgMvPHXcinReZD889YI7gFvzlILa/pQzNXlTmXFRulqUT1SvwJU7njnE+Eje9nmWZ8dnQKYRoCUpZoZv0pw10bR698XGvNVnkB03RCOP3+6f2dXTUE0zniW6sdPleRMy8bTnFtQ0m2jm2jMPUeD4LVVFa95LAINH0NtqFT4320LQBFSRQAVX/fdf/DLt9wkNIjSr0BoLex15CftNkeut7Zy8Oitu7qRX9sz+YlN/LR2T6tcgLFow+3+SPX7tG9dJU5x8J8xsbS9sZJWNT9eGJS+48k+FOAejhwtZfQxeXuCGJC8x6Jq0bm/B22tuTbGeTMIhe0B4IN+wc/fLI9gA1DH6EMOML3rTnQpZ6O6y5KiIm/uxVH4Ja8V235MoNo1U9RU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(136003)(376002)(366004)(2906002)(53546011)(86362001)(36756003)(6506007)(31696002)(6666004)(478600001)(26005)(8936002)(41300700001)(31686004)(82960400001)(2616005)(6486002)(186003)(6512007)(66946007)(316002)(66556008)(4326008)(66476007)(5660300002)(8676002)(38100700002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUNKaldzRW1XdmNQRldwS2NTQ01RRmhwc1J2K3I4NlJvcnVzNFZZNjVCZm5O?=
 =?utf-8?B?ZEtuSEM0Wm9yaU9ad1psSlQ2T0ZMU29EQUczd3BoMEk3dFJOMm1RYytFeWl0?=
 =?utf-8?B?MDVqaTdvRExBN3pvZ1FoRUtFc2M5WmZZTjNWdTQ1RmFreVRMZ3NPYlNLd3dk?=
 =?utf-8?B?Lzg5bms0MWRJWHRCeWI1blVLNnlHYnZYRjluamgvQkpldW1LN0h2UFhrSTY3?=
 =?utf-8?B?Z3ZVUkN3VHFEczU3K2N2WCtseHkvL042UEYzV0JmazYySnFsclhORTE0dlFB?=
 =?utf-8?B?eUgybTVZcmNOUmRFNmgvRytPdXhqRkdVTklzeTd5WFpnQjQxTFRqNXFTejlL?=
 =?utf-8?B?Qk9QNUYyZ1BVL29YbTl0L1hsd3MvOGNTM0VZTEpyK0YrMkhybzNzOVJJVWRy?=
 =?utf-8?B?OUJ5NFJPOEtCUjB1Qm5HOEFTeUttSmg4aGxhQm5wZkcwSzBieE5EWk1wbldS?=
 =?utf-8?B?SlIzamhzMzhiM0ZjaVpZQW1weXR4RkVya0Q2dGordkExVnVPOUJnK3RWbnE1?=
 =?utf-8?B?VTd3K2FnMmJSK0NUOWszSFBMd0pkTFQ1NFFkRGI5VlkxYS9yN2xrdVFNMDEw?=
 =?utf-8?B?MUFqeVNOaGFKa0VyTll1SytrVXdlT2xFRjZaZ29jMm1LbGJ1NlJOZTd1WEpY?=
 =?utf-8?B?eEZHb3U2R3JUM3VVWVBBNjZ0Uk95RG1EaDR3U0ZIaWxUaDhDdGd5cW9MZXpI?=
 =?utf-8?B?UWhPNitsNU5qdmZDdmJtYTBRY2dpaG9lYlkrZzEyVzd6Nmp5OWdmM2UvWW10?=
 =?utf-8?B?OWtkOTdvdmx1Y285dG9KUTV5TnY5VnYzWnNjQ1dHL0d3VkdKc0Z1dEc3T3JO?=
 =?utf-8?B?QUFGVGZzWTR3L3IzREwzS2dCNVZ0WUVyZEJlckg1S3FKaFlVMzZaaGthMzdl?=
 =?utf-8?B?bForeXFkNzBSVzVmbDhYVUlYd0tjTEZkeVZFRDZOVVNORXA5dXBmWGlNRUky?=
 =?utf-8?B?YXpUVWYxeVZIWlNlc05tVWhNU0tCT01RRkVVSTFMTmRDeTF0ejE0WDlxd0pv?=
 =?utf-8?B?SnI3Ly8xSUt6aTdmQkIrUUtPSko0dzNFc2plSjFXOEN0cllFbU44N1hmbkRz?=
 =?utf-8?B?NUVEdXdQUURaZmRkc21LM1FQOHhEZ3dMelNSUkVkVytCMldibGs3cS85V3Jl?=
 =?utf-8?B?Nm8rYU9WMWNGT2pURWl0TWFLdy9Pb3JRS2Y5RzVjZXVMcmRlbUNJeWgzZUV3?=
 =?utf-8?B?bktZbUpndWRIbmVra2VMVnh2NTZZWS9TY3pWZEREWTFXR1lkakVJR2RHQWxX?=
 =?utf-8?B?NnNSamd0MjB0MDhKd3EwRTgwYXR1Ly9IUUJLRUZuOVg4aFRPbTBRSHFtdGlu?=
 =?utf-8?B?aG11VkVMenMrWmp1SFowZkhRQlhhVno5WWdEbU9pSFdvcUZyVWlzMjZkL2xK?=
 =?utf-8?B?TFFneFBLdHlCMGRIalRnak9XYm4xd0NrK1d0dzNRYVBJTXowaHpKeHdKR21F?=
 =?utf-8?B?RkgweU80eHQrQ0N1eDhHM2tFOFA4SDhWZTNkWDRjSnlzRXduL1NpQWl2VmZm?=
 =?utf-8?B?UngxVXZRb0tCS3RBbDZET01HUm8rcmhFdVhaVXc1NWtVUG52bEpxZmxyblpo?=
 =?utf-8?B?TWtCd1FjQzVjTXJiOEpIK2pXaitTbzlJUDBscEVHYk13eFZnc2NuUVJmUStT?=
 =?utf-8?B?c3B3cHF3WStlSEtiMmQ2bGhST1N3TlJxV3pWQjJKdUNhWk0raWIxZ3BrRzJY?=
 =?utf-8?B?dWlFTjAyZVZkaVc4MlFOTE5pKzJBb3QwUFFSNUtQc0lhWFlwdlYzeDZCclNJ?=
 =?utf-8?B?Z1JvNm5POG90YmlWVkFXWmhpejRuOHpRMEhFUVAyUWpZeVVlZmZ1cThJdjhq?=
 =?utf-8?B?cldmMUZhS1lZSXZCZXBwMEVaRldoc3dpTWp0VTkvK0o0T1g0ZForMTUxQUdE?=
 =?utf-8?B?WkpTZVF5N2lNem9lN1o0VUlYRWRSOHRvN1ZYNHZLb2o3OXZDUEhEeXlkSHBp?=
 =?utf-8?B?QlA2Zk1TWjErcDBaMklieUJjbzZFTUdleVdIdlJ0TlB5RDFtUnN0QkV2bGRN?=
 =?utf-8?B?RHVGYmxKc0JwdHpqZGdDdUlDU0VTWE0rTW1yaFhQOGFLdTZwQVljRlA4TmVx?=
 =?utf-8?B?dVZrQmY5MzdzYlVKSG5rM3BUcDBJMFRPbE1kTHk1Z0UvcDViMHM1cm91NEh3?=
 =?utf-8?B?YmlSYVNVWmdxNE02dFMxQXpNRDg5czNyL3NCcEJHcHRwdVFEaTlmOU9Qa2hD?=
 =?utf-8?B?bUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c305258-0a87-497c-4909-08da895ccd53
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 01:21:30.5348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P+Vjz3vkKmAFiC9DKaV+oOaI+pDUqrKaLkgZKH8YhsUV5RaXzWYUhYnbB4x9S8TGq3Td4zRLKXqy6hyF0JTe0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7099
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/8/28 05:47, Jarkko Sakkinen wrote:
>> -	struct sgx_encl_page *encl_owner;
>> +	union {
>> +		struct sgx_encl_page *encl_owner;
>> +		/* Use when SGX_EPC_PAGE_KVM_GUEST set in ->flags: */
>> +		void __user *vepc_vaddr;
> Revisiting this, I'd tend to think that simple
> "void *owner" would be less complicated option
> than this.
> 
> Thoughts?
> 
> BR, Jarkko
> 

Thanks for your thought, Jarkko.

The reason is in the reply of patch 01, let's discuss it there.

Best Regards,
Zhiquan
