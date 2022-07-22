Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF5BC433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Jul 2022 16:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbiGVQQt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Jul 2022 12:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiGVQQs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 22 Jul 2022 12:16:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4616B21B6
        for <linux-sgx@vger.kernel.org>; Fri, 22 Jul 2022 09:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658506607; x=1690042607;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xHHYRo7qUIpPd22ZLDsYHDeIO8XD5uZYkpOHdYffc+I=;
  b=MMxMREceWY4hyjH63ozho4vKRIodQW8wRqda7KV/f4Kry3jKfZSgyaem
   WEPZDu8G4B5nZ+3FPr8vz1qTVqChO3IFELEWRC9CVMx9UsqhyReLp5Q0V
   +SrxQwprufzb/WrXPhtG657TaFMGyADBXM6Pgc88zhyaIVslbG7rTl6z8
   HK73KOE1+ymIopCpFzdahj2OeAGwXyjxNjmj8n5wNTMp63D2NwYGebPZ0
   wfYrR4I8UfEv262QbfwNVuEMQMmlzcll3yIml9LqgQKD5H9KCy0TFZeGE
   VcTQhLgrni6xYCY36ftPWZNxaMrdsfsdtF74BXQ4e7UwkH3HNBDsgKfSu
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="284895452"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="284895452"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 09:16:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="596009779"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 22 Jul 2022 09:16:45 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 09:16:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 22 Jul 2022 09:16:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Jul 2022 09:16:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZWnhMon2K0FIX8r81Pa84ma25GFjEIlh1x8RnM4WbfdFaVJl2ER92BL4zYg3py4wn5vkVwYMXVwY/1xxupDD8ljWPuP6vIb0b4OHKSoW8+1o8LD16Rgh/ePnZNtwnKD4N15CCsNPIvaC+ROfYwIv/UJUAynUq7fmfdhgf6o1XEeOhlhKfmw9usTSYtB6ptAxFBziwGvzFOss55Dl61oaLxTkctVksCcFsk1t5YLH2ayaFvNMKok/w/JjSjhgQwLV2Jo0+IxCtPlm/BmFaOs36lXlxd+rqyPAiNOaQgPPL753zIHZ0rKeV2WhsvtirmJCcHqoQVKRz6qs/TTak/C9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D31bZExnDXEBA6hxPU9YbO9KUftEP2LZ7KOZyNGpuME=;
 b=UC2Q/XcI+d6MYP64Mq1ER+sarHYWkW0aTf79TKQ6HhOoh0l1wKfRsWp0AlGebuL5v+OKEwuI+AEbN1oFm+epkOHKMNBemFYUdeEPZ3C1dT50ZRaA28IdLPKTr3VPFOekeBoVM9Q3YadZ2nyCqpFVx43+NvQF9h5uMOVfrj8B8w7wqnUCBm4udiY5j1cpSJdphnDzqqJELzLkT4ocLaX18sHAiMT4RZxBShMS1u5sqCr/eaRL6xlvXAwwK1zPxZPHpjFl9z+ovQ4WUJlPw+9lJLoRuletRB0yIiLEKI+I9Qd7n/Y8Fm5EWBTj1Q7TjetreAO0dTr6Li0xHyFGpvX4NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CH0PR11MB5394.namprd11.prod.outlook.com (2603:10b6:610:b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Fri, 22 Jul
 2022 16:16:42 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e101:93a4:5ad6:ffff]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e101:93a4:5ad6:ffff%5]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 16:16:42 +0000
Message-ID: <a854e953-6e0c-e753-d331-e84098abb46b@intel.com>
Date:   Sat, 23 Jul 2022 00:21:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 2/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <linux-sgx@vger.kernel.org>,
        <tony.luck@intel.com>, <jarkko@kernel.org>,
        <dave.hansen@linux.intel.com>
CC:     <seanjc@google.com>, <kai.huang@intel.com>, <fan.du@intel.com>,
        <cathy.zhang@intel.com>
References: <20220622093705.2891642-1-zhiquan1.li@intel.com>
 <20220622093705.2891642-3-zhiquan1.li@intel.com>
 <32429523-3a71-2743-02b4-ea6ad1d99002@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <32429523-3a71-2743-02b4-ea6ad1d99002@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0153.apcprd04.prod.outlook.com (2603:1096:4::15)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82fd9eab-cdd8-490b-c17b-08da6bfd9024
X-MS-TrafficTypeDiagnostic: CH0PR11MB5394:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ODlOYsRwG3bqKVEY4riRLJVr0WDHXdWiIXvo4jGR9ahqEEEtm27KFZIhW95vlFF6k85pHf9es9ge840IE6mmPfNoEqJd/5HkjEjkMFnGMODxdGx5gniP0n518WCC09lZcCwew7vg1xyDN/unPFEuRgzsKphOJrq0LSt6OwIeshngxQpo/huW6qBK43CYKuLDLzFL9Hk+6kwABHfTGGHp3tzY5SXkLExNFJB8bY76NWfMwPn0m7X2ZtPUlD4o9rMjEW7JxnBK8uVruyos1AxpDZ/PdOInCPBOYY+d/AneF1PdCZnf3ILg+Kv9fCNN1LvcoH/rJx8qsPb6rE5CoZuXwm/asQ+mA/sTosX+bMT+lp8DBYFgGtDTHpwXahrrzgt0MsH9wyriILkbh9pR+1schnTzr+fNq/QFbwcwCFdRPwtxWacZ90igHJdkpSeHZLhedqxFNduGgj/3N1yqq8i7zwHwtYjQ2SfgtdB9trp8YECL4Yjvo19N2pUUodigdsvull7VO+uLYw7Qf4O/vPBQG4v8suLe3alvGu6QFho1sQyr9tTWZjMJ2xCTQlGRqrfpbHJSOPjlzlBVzHwDgDbtQrN/lKHSAaf3pj3CIB9iuG4boddTSqnjxe9Ih7iShzhwfP1R0thqlbwr+H6s4Fm2HNOdwXScUecS2D2re+2lR9S66nd6DPTmIcfqSTW0iwR/+ibnPcUauYN5oM7LFZDUTLdsuThACfXdttLxszYC6iCbBw1ecld6YS8bFpG2rpPlIWi9WQ5cXuoODi26ZWJS7VT+QOLjzrycnkA/C2UAwHwGzXUPZC4RFVc3V9O94Z4KIpPG8lYSNc44c9MyOBLWkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(396003)(366004)(39860400002)(5660300002)(8936002)(66476007)(66556008)(8676002)(66946007)(4326008)(2906002)(38100700002)(82960400001)(36756003)(31696002)(86362001)(478600001)(41300700001)(6506007)(6666004)(6486002)(53546011)(83380400001)(26005)(186003)(6512007)(2616005)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkJvd2J4Z0VzazZ2NkEvTHl6VGpmQWI2SEV0UGkra1J4OG8rSGxEM0VTQ2tr?=
 =?utf-8?B?YTVnVnNpL2xpUXRWVC8vbkdhMXVVcEVxbmxuOUxHVXc3dnI3dytMVENhbWdj?=
 =?utf-8?B?SkhwZE1DTzRCTjdBZDlBNE9UU2RBQ0N5WW1pMElFSmNQR1lTbm44TGo0ZUU0?=
 =?utf-8?B?dFpWOVcxaFNTL0wyVXN6QXFCUHkzMUhUbVcrRkU3dWM4RDVRMU1JSVQvMGZG?=
 =?utf-8?B?SmFBdFpzY2RMZHRGOVZwM3dqMHlrRGQ4dFAvQ2gvVkRuMHo4Y3hobW9kK21P?=
 =?utf-8?B?ZUZPUVZMdTBDNTNudEdmMlIyVy8zWnFNa1JxTGlyVFBZTzBXTk1tdTc2ZU40?=
 =?utf-8?B?bkY2NmZwRm1aNFRLUHdwNS8rMVlLVS9kN2NhSEUwQ0NVRzZlL3JGa3FRUUd4?=
 =?utf-8?B?Z2pZdExFVEVkaTMxN0hsTjVYQWhGbkRqSVZVRm1WdEZYanhIVU5yVWlVV0xa?=
 =?utf-8?B?MnFRTW9QekR0aVdVQzNTc3NSUXdXbjNDWU12VzFkNElRVlozRHYvV3ZNdEND?=
 =?utf-8?B?THJYWUtTUVdySGdpSzNLc3lDQTJZRXpMb0ZNWnNDTlpKMjdhbjVtZS9paHJv?=
 =?utf-8?B?MHZiMVE4WkllN1VweXhtbkhXVlFJOXp0Zlk0eHRzU3JjVmFHSUNjQ3FKejEx?=
 =?utf-8?B?eEhOSDNkN3M1QmNvTXdVbnJTV1FLVndCSmZqM211dmJ4QlpTZ0EvQW1EbmZu?=
 =?utf-8?B?enFwaktJclZuWlZ1aUI4M1pBbjlWVmxzNlduaGxRRWhlUXlGRjJnM0QzSlFa?=
 =?utf-8?B?V256VU91blA5bUhZYkp5eDRmeEh4RDFZYmdwcnVjT1lkWHB6TXF1ZU9jZ1pI?=
 =?utf-8?B?aVJNUDBIWlhORFYrYzkzYlYrZ09XeW9Cdmhkdlc0U210d2tLUlZMWTZQaGRU?=
 =?utf-8?B?cmFYcnZ6MVhHNE9yUkE1SUhLdDhaOXVESEhtS0FPWVVsT3JCNnB4QUNIVjQ0?=
 =?utf-8?B?ejg5TUE0c2hvRFF2Vk14MVlmcWhURXcyWDF5QUpkTWVFN0hWd2Z2UDQ3YWwv?=
 =?utf-8?B?dkhZbklKZDVrTVEwR3JIQmNqZ0wwQlY4VlVvZHhWRE85YSsvZExEczZhWG45?=
 =?utf-8?B?T24vM212cUJGdHhzaWd1MTNtQkFBbDdkZVhZUUJqVFBBTjBQZmNtZG9YbTBp?=
 =?utf-8?B?RWo1Mk5XZUNsS0VMK3NuaStXa3U4czlSWE5STGw2d2tqd1E0R1UvYWE3RUdI?=
 =?utf-8?B?ak9nWTRCUzdvVVM5QjNYMHZCS1Rua3dPTjVmWDd2L2tSSmNXS3doUzdMcGxS?=
 =?utf-8?B?RjRVcnh1ekhuWnl1MTlKQWkvV0hCRmRML09xdEJSclVCRVhjbC96QUdqSS9T?=
 =?utf-8?B?blI0QXpPUGN4VXZ1MEZ6c0JpWHFneGd6Tk8zbUk4a3k2VDJoRjJZdC9ERUtJ?=
 =?utf-8?B?UGxKQ0V5b0d6Z1VIV0hHYXlUaTUwNGMxRUlkS3RJZUVaamQ4NG1aNmV5MjZv?=
 =?utf-8?B?M2Rjd2JaOXY1Qm9EaHArQUJBUFFoQmdPVFVIQVZrWXU2RVE1c0RyT0pKNlhU?=
 =?utf-8?B?ejJwR3RNNFNycmtibkZMM1JXM2NlRTdlUGYxMmhkM3JYTGhNUlVjbUNyOVV1?=
 =?utf-8?B?ZThjaXlqWm1EN3YrNEk4RTFPWXRYYzBjbHJGSUx4MWdENm92NDFtTE9pWFlF?=
 =?utf-8?B?ZFVzY0dOMkJ1OVVvUmFnN1pTTzlVcm05Q3JER3JsR1lJd1pYWW1SWTl5cnMx?=
 =?utf-8?B?SFNEUXJZUjNucnprMkZwVTAzcUxtQUpMQk9aM0JaMjVFamlsOUVFdHBTeHJu?=
 =?utf-8?B?by9vUnNyNm5FcmgvT2loVWVyaWFJQm80bW0wN3B3My81YTRQWGxuYUV0N3Fx?=
 =?utf-8?B?SDI2Z29SQ0ZEL2hRcVBMNUxNRm1ZMFlTd2NiaXRpazFwNHNZdnhWQXo2K2Vo?=
 =?utf-8?B?SGNkWXB5TUUrRHJoYUNGRVE3MnR6WjRuQnoyMWc5N0psMVkrRjNHWWdlQ2xs?=
 =?utf-8?B?RVpVMlpyQ0VLWnQrdFpDMnNKMDFqbTd2Qk5wTm01MGtITS9yRkJIdWFHVXdm?=
 =?utf-8?B?VmFCVTV4dWVqM3JCcEdka0RmUGtSWmN5QUhIMmRNcVN0NlU2N242VjlMV0Zx?=
 =?utf-8?B?OVdjM21mUmc1UFBJeitnbDFvNEVTd2JkY2xKT3JKN1FJdTZVdUlCbHdmajBn?=
 =?utf-8?B?dHU5dURMbXpNeThZNlJ6U0hPc3RjWmJaOUtNUThpZ2t4MVRQNFhsNVpiN2Zy?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82fd9eab-cdd8-490b-c17b-08da6bfd9024
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:16:41.9478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GqK1BFnFevne1wrNjMZHNPLcNMNTWSoMj6rkpLw6arx3YKTq9JjWEHv7EJEfPMiNTqptNC0XpVRa4nyvqoGhbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5394
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/7/22 00:54, Dave Hansen wrote:
> On 6/22/22 02:37, Zhiquan Li wrote:
>> When VM guest access a SGX EPC page with memory failure, current
>> behavior will kill the guest, expected only kill the SGX application
>> inside it.
> Can we please clean this up?  This is generally readable, but _hard_ to
> read.  Perhaps:
> 
> 	Today, if a guest accesses an SGX EPC page with memory failure,
> 	the kernel will behavior will kill the entire guest.  This blast
> 	radius is too large.  It would be idea to kill only the SGX
> 	application inside the guest.
> 
>> To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
> 	    ^ No "we's".
> 
>> information for hypervisor to inject #MC information to guest, which is
>> helpful in SGX case.
> To fix this, send a SIGBUS to host userspace (like QEMU) which can
> follow up by injecting a #MC to the guest.
> 
>> The rest of things are guest side. Currently the hypervisor like Qemu
>> already has mature facility to convert HVA to GPA and inject #MC to
>> the guest OS.
>>
>> Unlike host enclaves, virtual EPC instance cannot be shared by multiple
>> VMs.  It is because how enclaves are created is totally up to the guest.
>> Sharing virtual EPC instance will be very likely to unexpectedly break
>> enclaves in all VMs.
> I'm not sure why this is here or why it is important to this patch.
> 
>> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
>> being shared by multiple VMs via fork().  However KVM doesn't support
>> running a VM across multiple mm structures, and the de facto userspace
>> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
>> this should not happen.
> 
>> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
>> index ab4ec54bbdd9..4507c2302348 100644
>> --- a/arch/x86/kernel/cpu/sgx/main.c
>> +++ b/arch/x86/kernel/cpu/sgx/main.c
>> @@ -715,6 +715,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
>>  	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
>>  	struct sgx_epc_section *section;
>>  	struct sgx_numa_node *node;
>> +	unsigned long vaddr;
>> +	int ret;
>>  
>>  	/*
>>  	 * mm/memory-failure.c calls this routine for all errors
>> @@ -731,8 +733,26 @@ int arch_memory_failure(unsigned long pfn, int flags)
>>  	 * error. The signal may help the task understand why the
>>  	 * enclave is broken.
>>  	 */
>> -	if (flags & MF_ACTION_REQUIRED)
>> -		force_sig(SIGBUS);
>> +	if (flags & MF_ACTION_REQUIRED) {
>> +		/*
>> +		 * Provide extra info to the task so that it can make further
>> +		 * decision but not simply kill it. This is quite useful for
>> +		 * virtualization case.
>> +		 */
>> +		if (page->flags & SGX_EPC_PAGE_KVM_GUEST) {
>> +			/*
>> +			 * The "owner" field is repurposed as the virtual address
>> +			 * of virtual EPC page.
>> +			 */
>> +			vaddr = (unsigned long)page->owner & PAGE_MASK;
> I really don't like repurposing page->owner like this.  It requires
> casting on *both* sides of a type that we have full control over.
> 
> 	struct sgx_epc_page {
> 	        unsigned int section;
> 	        u16 flags;
> 	        u16 poison;
> 		union {
> 		        struct sgx_encl_page *encl_owner;
> 			// Use when SGX_EPC_PAGE_KVM_GUEST
> 			// set in ->flags:
> 		        void __user *vepc_vaddr;
> 		};
> 	        struct list_head list;
> 	};
> 
> There is zero reason to play casting games instead of doing that ^
> 

Many thanks for your review, Dave.
I will send V6 patch set as per your suggestion.

Best Regards,
Zhiquan
