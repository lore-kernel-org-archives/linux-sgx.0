Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C54C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 12 May 2022 12:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353579AbiELMQb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 May 2022 08:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352872AbiELMQ3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 12 May 2022 08:16:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ECF3EAA0
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 05:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652357787; x=1683893787;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fGi6SfMk0O3Fnj/xRFYHPdtVPW/9y8PaNbDwyGJdMcA=;
  b=FEja9zW+HMD4pCJRNk3/vY/nsXf2lmS7k74T/fEfFglop7k7cGPFdFZB
   Pv5n50VXN4l6xBY9uznMqwDQFFbOZxK9cCB7X8IfdKnnAu1EWxCiTPFTQ
   5HQ+Na3UT9xhXozoPkv5A1xtH+3vVFqOo6+VdsP/lFRz7uevpbWiqMc2C
   IBgpeFhdaYbhHEITuCM5KDkK1J0OYANebSitJSZdRNFg9SVL+l304nbOD
   4l5RDmslV5N5Fz1wogho/XmaN+oXOjnzxsgZ1+w/ShQ8MbhQTda0ZSoEC
   g7ZvMEuaCLpHckwElSvyAH+ZrPWhwqZYVw+DrU1lbq8Qs1/IqWXIDMVhP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="268816756"
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="268816756"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 05:16:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="624376679"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 12 May 2022 05:16:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 12 May 2022 05:16:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 12 May 2022 05:16:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 12 May 2022 05:16:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/K2Gez2Fq7PeBNLAgT+Cq5GWknrV72AGNHjd08XmSvT+BODqFhLmzFO8d7XE480Og5pOcqLNajPVbym0ZWWxDMmQceEAz4wuO2jC7PWX/BkfOHVXXEhaoPyV6Uryk1Sr7n2rbrOMbNjwmrkN6GKO5KaAJrQs2N7RA/gdkPXGvi9cz53g3I4deoSp378AAAYb3qXmESWI4aaGl+U264bBJ1+eHrEDWtxNeO5G8qneV7FTrKsNkHIcQJX+MrfZZFNMpSEYDUvUgc9V5toKUpmZ6vQV/7Qkwpx3Wo92Rb7hbSUUAADPs/wtfRk93YJSgOmL7VOWxICROQrJLyuEgGhtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVGWTbSJ5pEP3jwSkOsiwIrYkBHJ7nzYi+e2sqmEeqQ=;
 b=ELnaACH0SlnGsLf4ym43fKWhnoT+Fy1rJ3i/zfxEBQmFstkuvLm41soanQcLTobWvGfG/8LCuwNkfjfH6VB4IcC2s1hzFbekjq7DDguz4E1+rWptTcCUO65QeW50Fj3ZQjEAvrOiPXvmu90SK57BZfQBm5/UQwaUkvZh9AmMUN4jgkGO6IA/rw02YmvoImXjv9bCPj4BvTNTNOycEEiydLpptZPcRALFMUIyQghsWfQqdc9NvSo5G9t+e/9Tfu99xJoiQxncE15ONmbqZ+kumftKDN5EaApdOCFI/ZNQTyk5D+aokIcbWNfAQ0mdw4x4V6Zi3eGUCTh01N3zKGIz9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by IA1PR11MB6443.namprd11.prod.outlook.com (2603:10b6:208:3a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Thu, 12 May
 2022 12:16:24 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342%7]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 12:16:24 +0000
Message-ID: <150aa9aa-f9e1-c0c9-39f2-24a107312e66@intel.com>
Date:   Thu, 12 May 2022 20:16:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 2/4] x86/sgx: add struct sgx_vepc_page to manage EPC pages
 for vepc
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <linux-sgx@vger.kernel.org>, <tony.luck@intel.com>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <fan.du@intel.com>
References: <20220510031737.3181410-1-zhiquan1.li@intel.com>
 <YnuQvN+oQ1ar6ypU@kernel.org>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <YnuQvN+oQ1ar6ypU@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR0401CA0020.apcprd04.prod.outlook.com
 (2603:1096:202:2::30) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c92a1d66-6ef8-4cf2-3ffd-08da34113b16
X-MS-TrafficTypeDiagnostic: IA1PR11MB6443:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <IA1PR11MB64434889E19DAA292E0BD15BA5CB9@IA1PR11MB6443.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yTMNrnKs6jXki+Rvjb5vTw5kGYN0nclJ3EmkRHPZvCqOIAtz36iK57YWgnC5lG+G8Rk+YeZg4MQUdjFw5dwIhSOS+g6z56M8+duisfLKYIfMCdecVSgRFN+5wlkhdyr57eWZuxK1UUmPqflKX/1X+OvTSLB2vATRFZ9J9ZcbVKYPhthRrXVIwWIV9J2wC7Ib70CpTVmPcN+OH/EHWdaFhBBGTujOD6IxyqyvF2oaaGv3j+w15U5akGNrHU8yBfr8JAj7q6v+002xBWdidn5JbqEy5iRjlnFU7ztRZVGBuhptNDqLPu3tZRlo3ivPK5UiW/n0DdPftbLvP6o/92XVh2FHeO+M9D40YIXdqQKNk4Ey7xBnhiCmMLx/DUHtxRZWcJNIlsjKS4C6rXD7fw5uTQbMi/X1ZHdLIFWl6gi0wtEFFaVg/wgnpTWb2Q2XjUyvM9GnspHBGiNr4yrpxhYxR5IlFbBq6ZA8hjV1tLhPseY1qQkvPEXIHEYIAZzH9zmA4ID/yxltJ1qXGNECbl1vFibBsnKriMesebVepBcAu9Mnhmg+kj7SCCQ+o0j1oDd5UQqRg55xp/o0BKTjT9c4u8ND86vYRltQ0ASOxXqPhBsqomqhyhQcm8H6PGLO2DG0n2ySmlq9b9KV3VO38KpLEOh//a4dtLvS72Tv+n1B/cTpSL/Fl133bnG5MJTj3LAfZxACXMfDonAIABHDcBTNjylRfqWOxLCn/8j+9uvt30k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(508600001)(82960400001)(2616005)(66556008)(66476007)(86362001)(31696002)(66946007)(4326008)(8676002)(6506007)(8936002)(6512007)(6916009)(38100700002)(316002)(2906002)(186003)(83380400001)(26005)(6666004)(36756003)(5660300002)(31686004)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nlovb2tKTTJPR0pCQTl4YlVabVI4SVNrNDExemltVkg0alY3VDM0K1Zrek5N?=
 =?utf-8?B?N0toVWE2QUorcGlFWklna2hFSWtacXQ4QStTK3REK2t2RVBUMU1oakVKQ1pl?=
 =?utf-8?B?aklsUHArdDRwNC9KemZPRW1zbXFrdEh2L2s1SG1scHFMc2Z1RUswOTFKN1VG?=
 =?utf-8?B?YVpBSHBmWVk4YzIzb2FhT24rcjVQQzN6V0NsMU5meEpxcnowK1hFdWd6cjdJ?=
 =?utf-8?B?b3dPdzVXOEFFQWJUODNXTlgvMEY4TTZCM0hxZUtZekMzcnd3ZHVqL2FzODBh?=
 =?utf-8?B?UkRGMmdiTnYvbkNYTmI2dWJSQWFHcW9SVGpCKzZVRzR1d242SUw5NjBpa2Fq?=
 =?utf-8?B?c1p6YXEyYysyeGp5eEdNWWk0UDMvZE9RNUR1ejRLNndEZ3ZyY2lKNy8raGcy?=
 =?utf-8?B?K0RObVNJQjJRY3JqMEpwZno3ZXNPT2RLS3FDdUpIUlptWkd0dlRiSERNK3ZE?=
 =?utf-8?B?SXNhVkJpOUJYTnljb1Q0aHAxd2UvazcvN1EyOS9pN2pjTkhpMlBJZ1BydEl2?=
 =?utf-8?B?bFVQQktqelRreXlidUtwZ05JOU9DWDN2MVpXL3RrM2w4ZmY0NWFBN3dzUGwz?=
 =?utf-8?B?TXM4L3pTS0dlN0FqUzg4VGVJMzBWNytOeHBQVy9PVGhidy9kSUs4Z1FqQ3Z1?=
 =?utf-8?B?TTFXQ3pFcUZGbXFKYzZNZXlTWm41alJMME96STVmMG1FM3k5ZHNsdDAyTTFs?=
 =?utf-8?B?QWhoYmsvaGczSGM5cDVQM1hrNzVqZlM3YUdUVVZWNndTRCtpbGF6cmcvMzh4?=
 =?utf-8?B?WGtVeXNFdHgrVmR3WlJuRW43d1ArdGZyUi9GNDVnazNxZERXcFpJSWliM0ZS?=
 =?utf-8?B?S3ZHc1dBYWNnRFBNcUxtcFlxUGxtc0FRRWtsYjRZaFRjRng3QTA3eVF5Unk2?=
 =?utf-8?B?WkFEOTloZndYY3JZQ3QrL3lJWFpaTU9YUkMvUXlrUDE4cFBMQ082MUtGaUJR?=
 =?utf-8?B?Y1hxd0hwK2dzSXc4S0U3VzlubHZ5SnN3RnFlbnlzNDVIc2lEQWxlaVZiZTNK?=
 =?utf-8?B?Q2tybXZYb0w0V1VQSkdBT3J4ZHNYN3hoWUs1Q3Q4UjVlam5MaG1xak44UUtI?=
 =?utf-8?B?YWF6VDk5RGFRYk42NzJBdWVuT1V6dkRoSzVUcCtKaUhvUmRXdSt6MGt4Z2c0?=
 =?utf-8?B?dVk1cEJIV3BBN0dOSm1ObHd4MHZ3SU1pSGtmVTQ0WHdVajdMRXUxclRRSGln?=
 =?utf-8?B?VzF3ck54WmluMHMwNGt3Ykt0a2g4Vkk5c0FEV2pZSi8rMjUwbndkQ0c5dklB?=
 =?utf-8?B?N1MvZWtrNWV0MGpHVU9nZEpqLzNqSVNIN3dYTGFjVU84N2RMcGk0b2hha2JB?=
 =?utf-8?B?UFF2S0J2R0pUdW9uZE9jeWFGTGJnY0JPQzI1RFQ3RURsQW5WNnBxSXU5b3hs?=
 =?utf-8?B?UGMybkszanlyaFJDVDBlMmVsZnpMRzRGd0loQ25xMlB4TlRVeXAyS3F1V1U3?=
 =?utf-8?B?WDRtV01EZXZmQnhnUWJZbGk0dzdBUExRNmVQWkE2aGVnUHBKZ0lEQ2g4TkVB?=
 =?utf-8?B?T0NnMkd5aUxDQ21HNTJZY3dLMTVZZGVLQUl2ZERuMjJnRk94M002YzJ2WUFk?=
 =?utf-8?B?VVprZW9PMU0yTFZJSmpzNXZIUmFvOU1lNVhMMHEvMFUzYzN0Sm14WUNlUlBh?=
 =?utf-8?B?OWN6QUlleHErdnVoUXdHR2tXdzJjUE9lQ0U4R01PbVBsY2xZTmpwNHI3UWNm?=
 =?utf-8?B?OHhlM2lKQkEvbmNSMFV4TXljZnZ6RGF5bDA0M2l1aGhpNENyVzBXSTBDc3Rm?=
 =?utf-8?B?Wk1RTHBQSk11dXZPS2pFemFWT29yLzdEZEVldGRHdU1nbkF3SmtkOHk0TFFC?=
 =?utf-8?B?K0N2cUhVcE1pQUsrUHVGOHlLVFlXaExQVW1hQldvYzJ4U3QzWm5RSWk4ZUd6?=
 =?utf-8?B?b28vWmo0STQyWWFET2hlRWJwOXBrNFEwaGk4b1VvdnRETGJWRjJBRHR3bFFx?=
 =?utf-8?B?Z0hRc2hEbG5YVC90Ly9PaGpOZnVlbzcwK2lVbDJYQldyamJXM2NFYklOM3Fa?=
 =?utf-8?B?TWI2ek93b1FvZUdrQkF6Lys4cEgzV2hQMmF4ZVoxdWRpVE1IQmdXME50Rk1u?=
 =?utf-8?B?Z3dHOVdseUlDZnc2aUZReDh2RnBWWVJtdDgxUDFtVFRYZG1ISFNVRlFRNTgx?=
 =?utf-8?B?bmtQNGp6MXhoTEZyRmJvZldGYU5vWmpQdExlR2UrMk1FVnExdTU2UCs4ZXZP?=
 =?utf-8?B?NlZqcUFKUUlJRkRwUE5aQkxGZVg0clRYb3IzeFNQbDkvOGRNb0FUYUUwSXE4?=
 =?utf-8?B?NWVoUS9KVVR5ZVprODM1UjFXTWV6NGlOQ1pRZWRFRHd0UWpFZWpXdzczQ0Qv?=
 =?utf-8?B?bUExZkcyZm5BdmhWcmttWHJVTlhacVc1QXVQV3puQWltbkxqTlNtbzRadXhZ?=
 =?utf-8?Q?mkxO8mRD18dQe4Wk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c92a1d66-6ef8-4cf2-3ffd-08da34113b16
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 12:16:24.0498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ex4/xpzotd98JTpuYtop0fk/sLRKvU8aXvfzOGVFNyTQqIVn+U/jVZitCgKi1Bd7i4yOYLZWosOkPVyepzrLuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6443
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 2022/5/11 18:32, Jarkko Sakkinen wrote:
> On Tue, May 10, 2022 at 11:17:37AM +0800, Zhiquan Li wrote:
>> Current SGX data structures are insufficient to track the EPC pages for
>> vepc. For example, if we want to retrieve the virtual address of an EPC
>> page allocated to an enclave on host, we can find this info from its
>> owner, the ‘desc’ field of struct sgx_encl_page. However, if the EPC
>> page is allocated to a KVM guest, this is not available, as their owner
>> is a shared vepc.
>>
>> So, we introduce struct sgx_vepc_page which can be the owner of EPC
>> pages for vepc and saves the useful info of EPC pages for vepc, like
>> struct sgx_encl_page.
>>
>> Canonical memory failure collects victim tasks by iterating all the
>> tasks one by one and use reverse mapping to get victim tasks’ virtual
>> address.
>>
>> This is not necessary for SGX - as one EPC page can be mapped to ONE
>> enclave only. So, this 1:1 mapping enforcement allows us to find task
>> virtual address with physical address directly.
>>
>> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
>> ---
>>  arch/x86/kernel/cpu/sgx/sgx.h  |  7 +++++++
>>  arch/x86/kernel/cpu/sgx/virt.c | 24 +++++++++++++++++++-----
>>  2 files changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
>> index 83ff8c3e81cf..cc01d992453a 100644
>> --- a/arch/x86/kernel/cpu/sgx/sgx.h
>> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
>> @@ -28,6 +28,8 @@
>>  
>>  /* Pages on free list */
>>  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
>> +/* Pages is used by VM guest */
>> +#define SGX_EPC_PAGE_IS_VEPC		BIT(2)
>>  
>>  struct sgx_epc_page {
>>  	unsigned int section;
>> @@ -106,4 +108,9 @@ struct sgx_vepc {
>>  	struct mutex lock;
>>  };
>>  
>> +struct sgx_vepc_page {
>> +	unsigned long vaddr;
>> +	struct sgx_vepc *vepc;
>> +};
> 
> Same comment as for struct sgx_vepc.

No problem, I will add comments in v2 patch.

Best Regards,
Zhiquan

> 
>> +
>>  #endif /* _X86_SGX_H */
>> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
>> index c9c8638b5dc4..d7945a47ced8 100644
>> --- a/arch/x86/kernel/cpu/sgx/virt.c
>> +++ b/arch/x86/kernel/cpu/sgx/virt.c
>> @@ -29,6 +29,7 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>>  			    struct vm_area_struct *vma, unsigned long addr)
>>  {
>>  	struct sgx_epc_page *epc_page;
>> +	struct sgx_vepc_page *owner;
>>  	unsigned long index, pfn;
>>  	int ret;
>>  
>> @@ -41,13 +42,22 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>>  	if (epc_page)
>>  		return 0;
>>  
>> -	epc_page = sgx_alloc_epc_page(vepc, false);
>> -	if (IS_ERR(epc_page))
>> -		return PTR_ERR(epc_page);
>> +	owner = kzalloc(sizeof(*owner), GFP_KERNEL);
>> +	if (!owner)
>> +		return -ENOMEM;
>> +	owner->vepc = vepc;
>> +	owner->vaddr = addr & PAGE_MASK;
>> +
>> +	epc_page = sgx_alloc_epc_page(owner, false);
>> +	if (IS_ERR(epc_page)) {
>> +		ret = PTR_ERR(epc_page);
>> +		goto err_free_owner;
>> +	}
>> +	epc_page->flags = SGX_EPC_PAGE_IS_VEPC;
>>  
>>  	ret = xa_err(xa_store(&vepc->page_array, index, epc_page, GFP_KERNEL));
>>  	if (ret)
>> -		goto err_free;
>> +		goto err_free_page;
>>  
>>  	pfn = PFN_DOWN(sgx_get_epc_phys_addr(epc_page));
>>  
>> @@ -61,8 +71,10 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>>  
>>  err_delete:
>>  	xa_erase(&vepc->page_array, index);
>> -err_free:
>> +err_free_page:
>>  	sgx_free_epc_page(epc_page);
>> +err_free_owner:
>> +	kfree(owner);
>>  	return ret;
>>  }
>>  
>> @@ -122,6 +134,7 @@ static int sgx_vepc_remove_page(struct sgx_epc_page *epc_page)
>>  
>>  static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
>>  {
>> +	struct sgx_vepc_page *owner = (struct sgx_vepc_page *)epc_page->owner;
>>  	int ret = sgx_vepc_remove_page(epc_page);
>>  	if (ret) {
>>  		/*
>> @@ -141,6 +154,7 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
>>  		return ret;
>>  	}
>>  
>> +	kfree(owner);
>>  	sgx_free_epc_page(epc_page);
>>  	return 0;
>>  }
>> -- 
>> 2.25.1
>>
> 
> BR, Jarkko
