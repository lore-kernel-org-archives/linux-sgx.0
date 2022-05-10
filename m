Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEBEC433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 23:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiEJXB2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 10 May 2022 19:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiEJXB1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 10 May 2022 19:01:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0856A7A83D
        for <linux-sgx@vger.kernel.org>; Tue, 10 May 2022 16:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652223685; x=1683759685;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L3QV3CLYd7uwH8YqJE9XQg3o28uAwyJbFXVxcUukq5M=;
  b=J+yDoMM0CuILlsE5Kbd0iQ8/AFIE+vVQ8MRvNRBOsB5zlCm7qlk7uOTr
   qUDdC7g+OwJlSYn8HV3qxfoRVEyjLUS+i04Yb8yomSGeuuPfUxIUBDk7V
   bepqbeMjt/LwygZsd5jui3xKU6kHgs97ROwPYNmRNaBvIewrsl2rgHRn/
   rE/wXpoI6tpcebFI/no4jaaRd1QWrElNXYGgY5BFFiDpcKad9RQADQyaP
   jSK1msP+k6V2FZI6JRSfPE3HzwLp5HYAT5o+SJKkeCkdhTtORwfPAxRIb
   InegJmFycHzLqLCMNwubdXbNebEK67cOPJe8OTo8T8KuAXeYCj/ANzIlX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="332560710"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="332560710"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 16:01:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="738941007"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 10 May 2022 16:01:20 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 16:01:20 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 16:01:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 10 May 2022 16:01:20 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 10 May 2022 16:01:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvztRjd0HJdwE9QfL7P/tERIFM5BTPagg4U7TLjhgnk6V5MR5DOOPPQ5YAfmMwVqkb+MMJmXbsRm3zDFW39KmTeNCFc90BxkKwNSH2MsVyA1kGCy8sIKgs/ruiCuw4Z5qIZT8JuqPl5SzWsgShscgUdQZbOFIObniMGTRiyDXIqcEJgXnRCHv6McwzKw73rIIzmpTW8q3Ul4ifJZEAXTiWbOfopMzCSGbD9Hg4jZcv4OE1C0nIH9oJ6RDTe9Os1VIuR/xIn9awmLlZaBP5Kao/72xGW4CUqWgTBUOdfZqd/OLYeyOD3o+t4IXbikxbA3aZfJaVej2kt29+b4gqcllw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tivFnWALOOsGEUJPJBQhXKTQmWVy1FRdGAiSbkt79Do=;
 b=D2BWx7kbS2WWWkU4HiBXaE4y7m1tLdTmTy9caUjxtoYHxHVQm9udqoE9z5H/pKr4hi5LGa5feQ9vHmhc/K6ba3dN+5HR3dncedq9SidXYjsZsBWE/71jr0EuRW+ZzmIHLLUyAYoGHj55jgf/9+dQgHke8COrVHecBDPNTq2K31brZKX8BsV9P3gN8wTCPtHpmmsuBp9Up7Y6sL1ALDu3rxPTUNLqHYmNclD6oIlAzXFL6T8BPCSs+SoEn2e53f6znFfGa0ysHk2dVMctfeYTmgvLZqfwwQBRdALu+0dAzSpnGI3QhBs6mHTLfM5K3z7kF6hFAPau9CT5HiF4w7C+3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by DM5PR11MB1769.namprd11.prod.outlook.com (2603:10b6:3:10a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 23:01:18 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 23:01:18 +0000
Message-ID: <52430317-fb52-b386-870e-99fba6e28f3d@intel.com>
Date:   Tue, 10 May 2022 16:01:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [PATCH V2 4/5] x86/sgx: Fix race between reclaimer and page fault
 handler
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <d0ace4a1770ab8f4196bfeae06d0970ddb14ef01.1652131695.git.reinette.chatre@intel.com>
 <10f69ad5-4c19-341e-b8fd-92eca02fc66c@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <10f69ad5-4c19-341e-b8fd-92eca02fc66c@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0035.prod.exchangelabs.com (2603:10b6:a02:80::48)
 To BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa2dcf56-1d2c-4192-07f2-08da32d8fde7
X-MS-TrafficTypeDiagnostic: DM5PR11MB1769:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR11MB17699D768F50137DE6924E65F8C99@DM5PR11MB1769.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JT1dcnZIuF3PwSbS7WG6BGCMiJ0rEKAlfFSdTh1/lJGphGQer0z7sHwGmU+a/RD65kZuvnmD7ei3AbtnILXDGlozcNHtQdVofCsczY+ATb7bh/T2XGcOtCONKyeA1SH96BPofFsfav32I6mw9fc++xPILxy8OGMCv2/CDeytlhOXRz0SGYWo55lnLKyaOoNKFW04ZQonWuh2dKudZvlyorYlVUkBGsinskQOzuCMtiXDY5F1AKhNsKCbjF5wCb7GGBTwo9H2vUrMtZ1KN1ygK5/Vni0rw3xzf+7rCl4Pk2eSVFyPUvnfGFHVHpQZUNRTnqe/8NRA7igVeslsG90bTtN0Lz7Fyedv9KUbGJkobbf5sBjl02eNAg7mLwR5gzRzod/qoNsE2Yt2iAxFLs43Xxch50Lb/PiLqRGV3rIrz6brkxCEqBL0KLHhySdW2q6fFcu/GZtRIe0NNo6snXuer2d6YGUafBMfLiGwnfxEkofgzD+yLc2xhHbAh/aTDXwuzHtl/tMi7ikrlCRlg6VmfeJFLCboeOlih+28zSNl11SfWmPM1jwFFTcBoXdGQ5X1Tpa8HRnmBlL/1/TBzYsgDDlI3WDhXy5PbP8nRIRvNJ8RktKFGeYnn7kTClToiMSxC++c/YkqpCzIvdehN6Qot0n6wVfFinIBYbePXW0XMGWzMh8tzIN95QuV+GnAcQ50wzn6PJfoiJxWOArPR2+dI96PpGAYwGOFAZZg7Zxz5vM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(2616005)(82960400001)(26005)(36756003)(6512007)(6666004)(53546011)(5660300002)(6506007)(83380400001)(8936002)(31686004)(86362001)(6486002)(66476007)(66556008)(316002)(44832011)(508600001)(66946007)(4326008)(8676002)(31696002)(186003)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OW1OaUdYZ2VBYmFaL09lR1kyTFdUUk0weUdzRnFkS0dqZkxzRG1peWQwTDFG?=
 =?utf-8?B?VUtRdFRIRG5ZYmRsZndPNFRLWE5GNllHOCswWDdCZFd5czlYaUxjSlhUaEJi?=
 =?utf-8?B?QXY0QzRyWDJBYnhTNi9HQmorMGxINUc1d0RKMFJadDQwWWZWaldkZFYxWlFo?=
 =?utf-8?B?M1NnS05UVXdhclhFNU1jRTJEZ2FzZ2lyV0lrY1dMWVpGb3VjVEVDSzlod3Uz?=
 =?utf-8?B?alJZajViN0RLc1FBZ3NUZkpLbW9NOFlldk1sdlhoeFdVNzFZK0NBQ2tGQUpR?=
 =?utf-8?B?SGIyTVh2dWNiSkdiL2t3clM3eEh4ZHpoN1lLYU0xNXVjcUJ2eGNodGphYXBi?=
 =?utf-8?B?Nzh4ekdpeGZDRlBzU2t1aWIvc0V6Nkl2Vk9OaWt1WWYxUkJYY0N4MmdaQ0N1?=
 =?utf-8?B?ajgxeUJ1bWZMNUdvaC8ybk13dGpiYlV0c3plc0p0ZWFrWWJ1Sjd3ejE2UDVu?=
 =?utf-8?B?WlNtQVJpUTIzVzd3TVVaL2JHenpOd0s1L3NGQVFjZGwzRzl3R0xsMlN5MzRw?=
 =?utf-8?B?L3BucU5WVWkyWVZmSEVMeEErT3ExYzNZR05jM2pHMSsybTNrc0xJUDFCbkhV?=
 =?utf-8?B?Q3ZqS2JuaXBpTUtmTGJxc0xLOHFNRklkUndmQ1B5dW9aVzRhVUhHR1lWa3Yy?=
 =?utf-8?B?SXdsMzZ1VmJQaHY4M3hxOGRydE0wZnllam9vbFVPQW1FbE55K3BmWmRVNzVo?=
 =?utf-8?B?ZXRJeXhRVmNTM3VEYU5qM2UyaGwvSDFGVGRTbVAvL05XNnJwa2g0YTdFTkND?=
 =?utf-8?B?NGw3WlhIcytjQURSY3FjeE13TDdYSExhYkdGOElGOGFNcHR1eWgycjNibGZi?=
 =?utf-8?B?OXRvS2pGZ0VJRGJ0TFErSkhkaVdRQzBMeDZrSkMxMmJCMzNkNkVid2FPVXV3?=
 =?utf-8?B?NGtucE8wV2RZZGdtb2hPdW41Y2lFbmw3aFcxeEs5VVQ3STJZbWw5RTZJakNX?=
 =?utf-8?B?ZWxreTJsazNsOGxRbXkrcCtMK2JiZ2E5OTNMajRyTGdDNlZFZnpyRXNRanZy?=
 =?utf-8?B?V1hSU21kbXFGcEhUNEdpTjV1WFREb2luQmFnT1I2eXNRcGUyS2hpMGJhcThT?=
 =?utf-8?B?aTF3Um9mL0QvQTFyTVBsQUxwampsRFdDaG92a0xTS3BHc0tqR2dHc3pCeWlZ?=
 =?utf-8?B?cThGbGRrbUdJaWY4Ti8zRzRLRWtpaTVxQUxrK2x2aitkVVRuTnF6WTV1V1kv?=
 =?utf-8?B?SWtBczFUekxDemd3MTI1NlArMzJLTG9Sc2YrdkZGc3N6MmpXMzBCdmROb0Jp?=
 =?utf-8?B?em0wKzdCemRrRjh3Mjh1aVJEd1pONDl5ZDRnRGdnekQvU0Vhc05tRE5jTUUz?=
 =?utf-8?B?ZzBuQSt2cmgyb2xpQWptZDNwRitmMmUxMFlSdmNHQW5iMlEwd2Z4VG5vOU9q?=
 =?utf-8?B?bi96MlhUUVk2T2JSaTh5VWFFSGM4aVZBczcwTW1ROW03c0VnREI1L093eTR0?=
 =?utf-8?B?MmNtazJlTHZMeWNmQUpsMmpUQVU5bmE1a3hQK0YwYVZRS0luZmlYQWR3VjZL?=
 =?utf-8?B?UUpySjBEbVJsU3ZDakN0ZlY1K2NHZmpsQlNmamdMTnlCR1huZGp5VGY0QXNU?=
 =?utf-8?B?VUoxaExvak1VbHBhdUFzZmVnUmxNWGg5YlRmWThXLzlrK2Uzemp3R2RoL29v?=
 =?utf-8?B?RjlBc1kydnZHL3l6ZkNudTRTVUQ5bURneGFIR3gvMXBSNUlOd2hHckwxNU5G?=
 =?utf-8?B?MW82YkpEME4rL1prTmVQWHlhYlFzSEN1dHg2MW5kWHRQNFl1eStWWnpuZ0Q2?=
 =?utf-8?B?ODBmQVY3U25VdTgxVmhqelZUN1JhY1pFaDVlYWZhNDl2dlFhOHRtSHdud0pu?=
 =?utf-8?B?UHJYb2l3N3NhWjdpYVRPQ21TcnN6YmRCdzhBNTdySHlNTlJLSWhlWktSTXlW?=
 =?utf-8?B?djIramVFdysyVDFnbklYVTdsdXJHQVVYbjdndk9POVhrb0dabGVYdnZRM0tI?=
 =?utf-8?B?eU53aklSek10ZnM4cVdjcXRiN2ZLRWRockZVL05SQ0xJM055Sy9jaERtWEI2?=
 =?utf-8?B?ZmZZQlFIR00yblpFY0sxU2UrN3dXYkhLY0t3T2hMb0QvVjlwZytZNnVmUHln?=
 =?utf-8?B?MzFEK0FDV2xEZjFqbDR3VkVETExBSCtSL2gwakEwNytKZUNBeENlbUtPTEhW?=
 =?utf-8?B?dEVmS2tzT0VCVy9FKzJMSXVteHlZR1RQQkF3QXBmQUMzUkhldHRTd3pmaWh1?=
 =?utf-8?B?WnN3M3NSa056VGVmKy9QeDYxUmNKeUZ2enhZRVZWc05CeVRReHJoMjdiLzla?=
 =?utf-8?B?djNjWmxMTmpQcTgvR2dndlZsaHdueEowcmRnSTFDN1BaY2NqUkpCcGkrbGJk?=
 =?utf-8?B?bHBsN1ZoRE0rUkpuVFVGUUZpb3VHTGVQbzk0SVhDdURNaDlra2Q0TXU0UDgw?=
 =?utf-8?Q?dmYLPdXH8vI98DeY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2dcf56-1d2c-4192-07f2-08da32d8fde7
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 23:01:18.1697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dbj0YcDUws9N9ldV3sq1AVXnXalQH/xMyY1xSB5EIouEnl7RHPL8CYSjsBXj+I+NagvrTi9zvu44bKdsLitquad2YBzIIiNee2QQKBifL1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1769
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 5/10/2022 2:55 PM, Dave Hansen wrote:
> On 5/9/22 14:48, Reinette Chatre wrote:
> ...
>> +#define PCMDS_PER_PAGE (PAGE_SIZE / sizeof(struct sgx_pcmd))
>> +/*
>> + * 32 PCMD entries share a PCMD page. PCMD_FIRST_MASK is used to
>> + * determine the page index associated with the first PCMD entry
>> + * within a PCMD page.
>> + */
>> +#define PCMD_FIRST_MASK GENMASK(4, 0)
>> +
>> +/**
>> + * pcmd_page_in_use() - Query if any enclave page associated with a PCMD
>> + *                      page is in process of being reclaimed.
> 
> The name is a bit too generic for what it does.

This function is called after a PCMD page is determined to be empty and is
about to be truncated. The question this function needs to answer is, "is this
PCMD page in use?" - that is, even though it is empty, it cannot be truncated
since there is a reference to this page (specifically from the reclaimer) and
a reference is obtained with the intent to write data to the page.

For some other name options, how about:
reclaimer_has_pcmd_ref()
reclaimer_using_pcmd()

Do any of these look better to you?

> 
>> + * @encl:        Enclave to which PCMD page belongs
>> + * @start_addr:  Address of enclave page using first entry within the PCMD page
>> + *
>> + * When an enclave page is reclaimed some Paging Crypto MetaData (PCMD) is
>> + * stored. The PCMD data of a reclaimed enclave page contains enough
>> + * information for the processor to verify the page at the time
>> + * it is loaded back into the Enclave Page Cache (EPC).
>> + *
>> + * The backing storage to which enclave pages are reclaimed is laid out as
>> + * follows:
>> + * All enclave pages:SECS page:PCMD pages
>> + *
>> + * Each PCMD page contains the PCMD metadata of
>> + * PAGE_SIZE/sizeof(struct sgx_pcmd) enclave pages.
>> + *
>> + * A PCMD page can only be truncated if it is (a) empty, and (b) no enclave
>> + * page sharing the PCMD page is in the process of being reclaimed.
> 
> Let's also point out that (b) is _because_ the page is about to become
> non-empty.

Thank you. I will emphasize that.

> 
>> + * The reclaimer sets the SGX_ENCL_PAGE_BEING_RECLAIMED flag when it
>> + * intends to reclaim that enclave page - it means that the PCMD data
>> + * associated with that enclave page is about to get some data and thus
>> + * even if the PCMD page is empty, it should not be truncated.
>> + *
>> + * Return: 1 the PCMD page is in use, 0 if is not in use, -EFAULT on error
>> + */
>> +static int pcmd_page_in_use(struct sgx_encl *encl,
>> +			    unsigned long start_addr)
>> +{
>> +	struct sgx_encl_page *entry;
>> +	unsigned long addr;
>> +	int reclaimed = 0;
>> +	int i;
> 
> Can 'addr' and 'entry' be declared within the loop instead?

Yes, will do.

> 
>> +
>> +	/*
>> +	 * PCMD_FIRST_MASK is based on number of PCMD entries within
>> +	 * PCMD page being 32.
>> +	 */
>> +	BUILD_BUG_ON(PCMDS_PER_PAGE != 32);
>> +
>> +	for (i = 0; i < PCMDS_PER_PAGE; i++) {
>> +		addr = start_addr + i * PAGE_SIZE;
>> +
>> +		/*
>> +		 * Stop when reaching the SECS page - it does not
>> +		 * have a page_array entry and its reclaim is
>> +		 * started and completed with enclave mutex held so
>> +		 * it does not use the SGX_ENCL_PAGE_BEING_RECLAIMED
>> +		 * flag.
>> +		 */
>> +		if (addr == encl->base + encl->size)
>> +			break;
>> +
>> +		entry = xa_load(&encl->page_array, PFN_DOWN(addr));
>> +		if (!entry)
>> +			return -EFAULT;
> 
> Can xa_load() return NULL if it simply can't find an 'encl_page' at
> 'addr'?  In that case, there would never be a PCMD entry for the page
> since it doesn't exist.  Returning -EFAULT would be a
> pcmd_page_in_use()==true condition, which doesn't seem accurate.

Thank you very much for catching this. This should be:

entry = xa_load(&encl->page_array, PFN_DOWN(addr));
if (!entry)
	continue;

> 
>> +		/*
>> +		 * VA page slot ID uses same bit as the flag so it is important
>> +		 * to ensure that the page is not already in backing store.
>> +		 */
> 
> Probably a patch for another day, but isn't this a bit silly?  Are we
> short of bits in ->desc or something?

I am not familiar with the history behind this. The VA slot information
do indeed take up quite a few bits though, leaving just three bits
available.

> 
>> +		if (entry->epc_page &&
>> +		    (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)) {
>> +			reclaimed = 1;
>> +			break;
>> +		}
>> +	}
>> +
>> +	return reclaimed;
>> +}
> 
> Could we also please add a comment about encl->lock needing to be held
> over this?  Without that, there would be all kinds of trouble.

Will do. I will add a "Context:" portion to the function's kernel-doc.

Reinette
