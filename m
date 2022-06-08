Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374ACC433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jun 2022 10:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiFHKFy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jun 2022 06:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbiFHKFk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Jun 2022 06:05:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06903AF323
        for <linux-sgx@vger.kernel.org>; Wed,  8 Jun 2022 02:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654681702; x=1686217702;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y3jGBR9CJozZduAyE1kLx+/tthUauX6gAfjFfeujw4A=;
  b=E+6xPy+PkxuDc2DaWyFcaTuRJ31Xc71b+zPsKK13cqEgg5QOgu040ME2
   q04xnNYgabsLm5ir7PxQJ2X7OOtv3XmImc/tPZFlTQ2Oj9WG8WFSzL5Tp
   CuFsqT5VhGXi3YPihQIUzi8lFis3SLTMdn9Gcipmm7nC/wtmRpPVJ4DfB
   aSjO8eK/trc3Xn3j5Q/cvgM72NWYcedUc8yY/OC1VU1vubKnwvaWPWNkR
   Zuak+xmPZczupjK+r1Osy7+yZdGWWZfvhTM1ouW4IIKFsXVamzjSCvkAj
   kNKuegMD3c5aGhotczuT7puC1W0XrvrD8D1D50Iy2MwWS+E2zYn0ovNax
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="256663851"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="256663851"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 02:47:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="648519597"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 08 Jun 2022 02:47:36 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 02:47:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 02:47:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 02:47:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 02:47:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aypCP48sRjYa8F6E8T/YLdyAsFSd6mlCOEvqSsfZ7qrqOS4GjPoCgcHx05uV4yfMj+2RPtXtj0V5zbbU6NgimCc4xomp7zq46c1RAw3NZN9R3Wf0TdxH6sxLB3Tf4sTyuZjX41+6zl2YgC+Ym/TEhfaLqyN/NhM100dZmQV/rIO9VB3MtCSK53o+ko7thX2apX8l22lAQrf082GYSGmgU/LwCCQENkrtT8+i/gBPesOQHFGJ2Rr5SQ3qoh2h6Vp2GHMfgxzEvX/Sdz2T7hS2CDMGIZRL4OvGhglUEsTfF2lufUWpCDKFFqEnHKp4WAbdCI49vy6p2ATswptCORzQOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIFMb5TyhlOYNA1fxxAXdKJ6FT9J2KyWWrNkyuZGE6g=;
 b=m0/wRyY/sJGpXzoIZA5Yx0IhiCValrzyBaiSAiT0t2ytPXAQ7S0Ur/G3nyHu8Ugjhuu+JLRDmUIE9zxH5TO1nBBUwfC/dh/+F8qskJ5jqc1XcVFEipJ2THrJF+RDR5zQBqTiqxp5abIHBjm8pUce6gCTCT/3z64qVFA94C7zUE9+fEiDP1f4+75s0kNbAaH75v7Sy3D2vxpxu3zHWWqQzyj7xwGYMYFeSxXQUSQKojgBFB5wd4m6yCwFkqm8WMCJyvz90EviVflxmmP899hXOscYTdI8UWoe0Vh/omkaUNi7m/OJw7YCq/nWKeQvEJYM2ObsNVV+HRbqPYidLJUt5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CH2PR11MB4488.namprd11.prod.outlook.com (2603:10b6:610:4a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 8 Jun
 2022 09:47:34 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::a988:feb4:e85b:3f73]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::a988:feb4:e85b:3f73%7]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 09:47:33 +0000
Message-ID: <0676cd4e-d94b-e904-81ae-ca1c05d37070@intel.com>
Date:   Wed, 8 Jun 2022 17:48:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 0/3] x86/sgx: fine grained SGX MCA behavior
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <linux-sgx@vger.kernel.org>, <tony.luck@intel.com>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <kai.huang@intel.com>, <fan.du@intel.com>, <cathy.zhang@intel.com>
References: <20220608032654.1764936-1-zhiquan1.li@intel.com>
 <YqBZbyWW4jTkn7qH@iki.fi>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <YqBZbyWW4jTkn7qH@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0216.apcprd06.prod.outlook.com
 (2603:1096:4:68::24) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89ad3aa7-1d1e-4a47-a561-08da4933e94f
X-MS-TrafficTypeDiagnostic: CH2PR11MB4488:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CH2PR11MB44883F044682C70781E78C8EA5A49@CH2PR11MB4488.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0KhTWZC8opEXcsW9UtfvwfFkV85e+AArvcqmoujYP5KAO0TaV3m7oE1iQPwpq8Mh3VYhqEd/UFNsXHTLe0Ep8O0LSXK5+/PH+poz1ymZBdTb28G3/X+XYi0ppS4w/Bksk/aZ62gjcp+RNcnUKbgGfJL1bOwISeX/Wk8FZxrtmOAV5ws0nxKugQ3GQOvTQuFXFo26EhVfh76Ib5gQZ6HxnZVeyGQrDYPfYMndeP8lFkUCTD6R74Vhe165vU3D33lvF+I6VOWkf64ijlF7Ap//j/9WEigFVo6XaZvEIZo/mqHRoWDVO6ywzt/9RJPWYM8Bf4++N5krqe+2tyEs8NoXQsqxrfU4IYKLAcnG+C+KwEwTQCD3JmbQAc350GJQDKBfULgmNBmJ74H4QfQevtWpvdouxoCuci8pI7+8Nx38fxlOTg4aoxENFAsDgBJS310McxK53Unx5ByVpbGb1aqNveISa2fKwwbs0F608tY7xs6clwzIQV49Rn1ODSc1srfGlvxOoGaVDnUk/zIqOveLHqS1gapgtQIaybdE9BCOuCMjSI5AmXCEH27j5VmpY/2IBwlYdthoEbhveZvhiM2OEg1BteemkmQjAg7HYdQRAfgYP3fzWGRe0jpTVOgGuDuelI/INMKyEiNo4mjej53DPQ4G0FHAWG09lzpAQfNU37PMUrfSZyPv+Xa95Wjs1Zu0JO49DIDyVMk4pJTkLqr0jbG8ncC6k4gAf/CLqirWC0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(82960400001)(8936002)(2906002)(508600001)(36756003)(6916009)(186003)(83380400001)(6486002)(5660300002)(31696002)(316002)(31686004)(2616005)(4326008)(6666004)(38100700002)(26005)(6506007)(53546011)(6512007)(66556008)(66946007)(66476007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmE4ZHpJSVVPMno5d1owWW5jb1lQN3JqNUNrRys1eEdmMVREMGQ5bnJqalpK?=
 =?utf-8?B?RHpkSlgxTDBrSkJUeXhzZ01jbjI1Y3NJL3ZsbXlRSG1ab2lDSU1PMDhkUHVZ?=
 =?utf-8?B?TnVYTGljTGRnVDZZWlR0ZVEwdzJNclNGMDJtMXFha0ZqMzA1eGhWQnE4RjIy?=
 =?utf-8?B?Z01YZXZjMkF4a0VxOWhRVHRmZEsyNjNtQnp4ZFJlRER1aEprTjJFNlNTVmhp?=
 =?utf-8?B?TzB6eVlVcDgwcUE5ajBNSnhKNjhndng2cnBrekJiZThxTTRVQUFsb3ExOEwx?=
 =?utf-8?B?anV1V29xc1NSeEJrNEdVVEtGQjE2aDQycVpqVUtDVkVYVkt1UFlaek5VYWpt?=
 =?utf-8?B?QndSZ2dYMTV5VDBKV2JsVklRMVgvMDlwYkF1Wk5JTktlUmo3bFhIY0htVjA5?=
 =?utf-8?B?SytUek5tN1p3L2lYNEFXT1VSY0lyeC9lYVREKzdRUHk0OUxzSFB4MzRSVWE1?=
 =?utf-8?B?ZE5kbjFvVmsyY21DZm14a0VxT01BdStsQ2pvYldjTHpsSTdGWGVYMkljQi9z?=
 =?utf-8?B?RkxhZTljOVJKenEvL1FyNG5tcDFjSng2cVgxWGcydGt4QmVxR3dWMC9ibE01?=
 =?utf-8?B?RW9zMWR4WVV1WkI0YTNONWFNOVhwOVI1RkpLS3VwcWFodDduYlJvMHo1RlNG?=
 =?utf-8?B?YjAwTmVWejVGK3p1a2E0OEp5NFBIUmJLVVdqOTAremhDUDVBMnh5MlpYOUtk?=
 =?utf-8?B?WUNwNlBCK1N5QTJESTY0bGpxUHF5bTNoMTBCcHc0ckU5czVDOG8wQWNlUHBr?=
 =?utf-8?B?d2NPQ3Fra0RyN3dFYmR6ekJNT01iQmJaVGpKUnVZNWlGVTI5TlFyZDArSTJZ?=
 =?utf-8?B?aHpZazZBWTl3MVh5aTJWclUzdTFDMXJoUVhiY1EvbjJXT21obXRLMXhVck1l?=
 =?utf-8?B?V0UrODlRczZYYitKS1doRUxhZ25LUGtseVJKVm1xbFRhS1krSk1LcEVjZHVK?=
 =?utf-8?B?YTE3MGtYUlJ6WEdiaExVWCs5Nnh3VHhiMktkSG1YN3ZMbjlmRExXOE9YSjlZ?=
 =?utf-8?B?aTZWNGJCZHFUVmVrSm5RRjBNUStYWDRuYUdGOFRrY2JJakVEN2VZQlhRWSsw?=
 =?utf-8?B?Y3AzUmdQVHlJSi83N01qUWwvT1BmNHJyK3Rycm5FTHNOeXpSbVBUdjQ4dEtz?=
 =?utf-8?B?REpySWN3WnpVam1oOFBsOWdYTGZmREcyTjlRV3psc3RjSHREYld4RjJIRm80?=
 =?utf-8?B?VEp4VGpEUkl6S25nbWtFYW1kZnlRbGE4NlFkYlk4bkl1N3BLNDFvZlppbERI?=
 =?utf-8?B?ZUE3YWkxZEJZVXBGVXo1TStkaEZoTXJmQXRMZW5yWjJvZlovZ2NVdUtsQ3c2?=
 =?utf-8?B?R2ZKZzVHUGpNS24ySThsQWNuNjlHUnlxOXZnZlZ4MDlrSGNvTk4vdkwzZmV2?=
 =?utf-8?B?T2tESTNNRXhmNFF4OUFZeURTODVaYitJUFFGVDcvcjZCZ3dYTWRTOTZoVE16?=
 =?utf-8?B?UzBmZy9TVERUZkpQZzZVQWsrdWliS1ZNUHQyYVgwWFV4U3crRGJsRTU2b1Vq?=
 =?utf-8?B?T1BtdS9TNGI5bzJORHFydEs0azhMQXdRL1lhNDFPVVJXVDNjMndOb05FOTln?=
 =?utf-8?B?eFVYc2N0RkRNdEs4QVFybTlSa1FOZDBBRTF0aHhnTUpXZGJlUXpsblhzNU9H?=
 =?utf-8?B?TGg2Rklra2hmOUNEZTlzeStUVTZVcytnYUlTKzhzMGJUNmtqVlloMmV0TkpF?=
 =?utf-8?B?Y1ptM0FJbUF5U2hDcU4xMGxhRGJudW01dG1WQlgyN1lQWFJONE1GWVM2MzFG?=
 =?utf-8?B?UzdZZEI2c0ZETmJEUkJ6dEZmYllxa2pqU3BCc1FESm05MDZBRjFIY3hkUWJh?=
 =?utf-8?B?VForeGlCYlhzamFIMGcrVTI5blFXMUVPb2k2S05WVWFKTDhPaWhCTk1aWVBS?=
 =?utf-8?B?YUlPRFBSQ29MeWtwQUlRNWI5d1BOK2lLTzM3WCtKS1Q5TW5MdVVHTDJjSDJo?=
 =?utf-8?B?Qk9MZGhCZG80SmE4SU5aSTFqNml6RjNqSlNlZ2J1UTdNNk5lVTBPVEg5a0Rm?=
 =?utf-8?B?d3dWMVdDSUdUMktvYjZSb0o4b0VCUnJYclRnMHB0WW5kUmxJM2gzeE4zempo?=
 =?utf-8?B?cUNyZVJkRllUTHh0Nm4zeElKaUVCOFE0UWU4QnZLWGVEakljL3ZYSFVJL2xq?=
 =?utf-8?B?S1pvOUN6SXB4SEJQMlBpaU4wT2R3MFdoRDlINUh5U2RSM3lpMDBxMWY5RXdw?=
 =?utf-8?B?Y1o2bjdJQ0twMXRSRUg1aldScXNaWVlDaVJVS1YzTXZqdG0rUy94Ny9hSERY?=
 =?utf-8?B?U3hxTkl0Y2xZdDdvM3BERW14MFRDS1pxRFovYzVrOTFBNm1xYU1WOFFlc3kv?=
 =?utf-8?B?RmRJVlY5NTlhdmU0b3VRd215K1d4K2hwMURUakUwL0xONGZ5MDZJT2tVbFls?=
 =?utf-8?Q?SRY6hAS3xNbY3TUg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ad3aa7-1d1e-4a47-a561-08da4933e94f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 09:47:33.6723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0C/rlGfes/4E/HLPFDqRQ0iL4yeffrzC7SdHwWj+IfJTM96xiOV7Cy8uP6Ab0SBheZ8hNDFAK2qdXMMu+jhvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4488
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/6/8 16:10, Jarkko Sakkinen wrote:
> LGTM, I'll have to check if I'm able to trigger MCE with
> /sys/devices/system/memory/hard_offline_page, as hinted by Tony.
> 
> Just trying to think how to get a legit PFN number. I guess one workable
> way is to attach kretprobe to sgx_alloc_epc_page(), and do similar
> conversion as in sgx_get_epc_phys_addr() for ((struct sgx_epc_page
> *)retval) and print it out.
> 

We follow the hint in Documentation/firmware-guide/acpi/apei/einj.rst
added by Tony.
To validate the part for virtualization, we do step 1~2 on host, do step
3~7 in VM.

Regarding to how to get the SGX EPC page mappings among GVA -> GPA -> HPA,
we do something like these:

1. Get GVA -> GPA in guest OS

1) Find the probe point in sgx_vma_fault(), as vmf_insert_pfn() only be
   call once in sgx_vma_fault():

   crash> dis sgx_vma_fault | grep vmf_insert_pfn
   0xffffffff8ce527b1 <sgx_vma_fault+113>: callq  0xffffffff8d0ec1d0 <vmf_insert_pfn>

2) Get the mapping of GVA to guest PFN

   echo 'p:sgxvmfault sgx_vma_fault+113 vaddr=%si pfn=%dx' >> /sys/kernel/debug/tracing/kprobe_events
   cat /sys/kernel/debug/tracing/kprobe_events
   echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
   cat /sys/kernel/debug/tracing/trace_pipe

2. Get GPA -> HPA on host OS
__sgx_vepc_fault() can tell us the mapping of HVA -> HPA, but to inject a
memory failure, we need GPA -> HPA. There are several ways can archive this,
e.g.,

- patch Qemu to show GPA -> HVA, then we can easily convert HVA -> HPA
- Walk EPT table
- patch kernel to show GPA -> HPA

We use the last one because it's most straightforward.

@@ -4047,6 +4047,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
    else
        r = __direct_map(vcpu, fault);

+   if (!!sgx_paddr_to_page(fault->pfn << PAGE_SHIFT))
+       trace_printk("SGX: gpa:0x%llx hpa:0x%llx\n", fault->gfn << PAGE_SHIFT, fault->pfn << PAGE_SHIFT);
 out_unlock:
    if (is_tdp_mmu_fault)
        read_unlock(&vcpu->kvm->mmu_lock);

(Because the filter of ftrace kprobe cannot support such a complex
expression, so we have to patch the host kernel directly.)

Then we get the mappings of GVA -> GPA -> HPA, next we can inject
real errors into enclave memory using ACPI/EINJ. Try to touch the
GVA in guest OS will trigger the bug and see how the patch 02 work.

Finally, Qemu console will show below message but will not be killed:

    qemu-system-x86_64: Guest MCE Memory Error at QEMU addr 0x7f3273f2a000 and GUEST addr 0x18012b000 of type BUS_MCEERR_AR injected


Best Regards,
Zhiquan

> BR, Jarkko
