Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B5EC433F5
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 18:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346025AbiEKSDH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 14:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345991AbiEKSDG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 14:03:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C0377F3F
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 11:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652292184; x=1683828184;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vyolR0izHrh417a++jkgYIZThhe5etVKtKc4YZBdn2s=;
  b=m4uknWJhayIDEpBIy+tYbGpjrRU6/1R/p9sugSv3RUpORBSC2MBWC7mk
   iMvBNdlSQbM0YmeIS4YnADBKZpCf0yeQDrzZefxh5ySVrc1qeOoBm81bg
   I1ghGriIxJhGXSI7Yh1b7fQzreEk3rnITV6fDKo97NMpMC29qPvCrqL8I
   e+gtc4adwXADMkHaKyYKFxJG+FQ8pzCaKxx6wwJT5h1ghvwfe79ekT+6Y
   QAqVzTwY8x4vyyMwDWxAk2SnSydKJGcys5DAup4WbldTwTHhPJuFVRqgs
   XOnXIk2OH0r4mD0NRRnZYlDy6XzkVD0mf11Slh+/j99M512UvP4K6MpIC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="251825194"
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="251825194"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 11:03:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="520616362"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 11 May 2022 11:03:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 11:03:02 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 11:03:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 11 May 2022 11:03:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 11 May 2022 11:03:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcTw5lHf4qoK7svGFkmP+KIrEgffn4NGEh66QBithe9oq3FixbIMLDXk3MAjSuNpCCVFjDW8F2MQupMeHfC+Yd3AIRkx4WcPvdVscoc0XSl0pDNLRKEF4Zjofe19VBku6GhngLamRYZpjoJT4wy0I7O8EJ3wu3Zt8vqx9T+JpR0cNuQTjH9UEw/snbi7TobH+BKb94pP4pxxYdrqB376suiI5LSt9T+pxcuP83IMzI3r6kBNRZLbh+121y3mjDiA+oDuyRuLkNGaFj6R8LibaqFhUbkjYrdjiazqFdhvyuF9KL2oR7r3PdrY+rtiOGsWq5gVkCK7h80k/xJpLMNCLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwCNIFrycS8Omh3zcbS2O9idhgJPpa75zZT1hctDPqE=;
 b=Vpo672ByZ7cpRkUezC/7Pje17kaqACWZzyCUiOPwWn0bUeQW6eesEu61bI96XwuGJC5WtLUb00Gox5/myga6WTHoQkHXyQfCIdF1ivL5q6ZHLPkBKbI6WtoZw/5otRGGKjIEv9oZ2AR80hRm0vUXDwoo/9OaQtqhofqFL+RTE+zPHY1UFKfvZlIucsb9SSpKOsvo19IkjyjfsfgcyXylfV8JpOz4AkAHWaPZs/C41c0chkYuSaEraqnQTK4SWPv4aPadukNxH0UYa9U6HKILhZvT+aSNIYy2GG5Xo6yUAJW8TWEKfJixgM4xsKTcJndvpAGAeA+RVqtz2AGWHaQQqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5740.namprd11.prod.outlook.com (2603:10b6:610:101::7)
 by BYAPR11MB2533.namprd11.prod.outlook.com (2603:10b6:a02:c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 18:03:00 +0000
Received: from CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::5043:8c48:2510:3ec0]) by CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::5043:8c48:2510:3ec0%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 18:03:00 +0000
Message-ID: <9c85f01a-9f9b-1d2f-7dfd-11306d623ebe@intel.com>
Date:   Wed, 11 May 2022 11:02:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [PATCH V2 5/5] x86/sgx: Ensure no data in PCMD page after
 truncate
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <dave.hansen@linux.intel.com>, <linux-sgx@vger.kernel.org>,
        <haitao.huang@intel.com>
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <bca979301e2fbb55c314fed29c06e72e82074fba.1652131695.git.reinette.chatre@intel.com>
 <YnuRxPqhOkWOAXjk@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YnuRxPqhOkWOAXjk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0133.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::18) To CH0PR11MB5740.namprd11.prod.outlook.com
 (2603:10b6:610:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d04b6f0-330f-4d58-488e-08da33787c68
X-MS-TrafficTypeDiagnostic: BYAPR11MB2533:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB25337B04EEE490E6F0C5CA21F8C89@BYAPR11MB2533.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IJODYycff53VUIVUx4R1IvBO1y/MIimXbTSfhyxJiGLqbTe0REgBUEOT/hy6n0R7vJECBjXr1NhHU+vrEGrIsY4YSclX1YAcrZA/NvF2Mc8m9Iyn1wRe+oeJlfvjnwWit9IYGEdaXofc8YHy5cA5bNOVVnStaMKWEeQuRw8OHvescNI8iJ95zmmkidI03ypNMdSXJPj5lXBlNuJiZWcaeb+VQVZo/mfq2VJ9njpJEwK9qta4F0itI6ENRsulitEaIUTwjJypuujOdyunT33p5R/5GbIqG3MikX+rAta/Ef/g4s/L0wwtR2kMWTSy+5AnqPISkIXLBID4OyQ3c5ZnGbGDb7JG95xSudyemdTUaDVbE7jZCqEVaTuBPfjH51a/g2JolC5um0+HAb1wIbs+nu4i/kSMB46EMmZmEHSTNzQDcl7h4ctxJCBupAfpXjsEoQpYhWwpJ4vFyuON4ThYcwTDz5/FhAxzdCjLuJMge2J0giRXIxivUFJIce+0th0MX439Q9memOJxJhPELl+Fy6dKJsNgqJSOFotqzcY70uerd3oKr69+C0v/cuGGJ3wmZ560IR+32Aa+KbeTCM/2S+W4rF7pQc0CBDkqbFbxVT8Xy+O6Kn995ZFLsUx2M2fOMOSwRJ51/Yvxup3U/qZ6aoqu+EPGKR1Diat9Y3fQBrn4ZpG1HwdvqeQEZuY3o9FiPLB3RbMZ9i6ZzyGL7oWO2mIa9Ppyj4zPk23VHB4T1dwbP0qsgCgTHeHTcYKdznd3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5740.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(31686004)(83380400001)(44832011)(2616005)(26005)(2906002)(6512007)(36756003)(86362001)(82960400001)(5660300002)(6486002)(508600001)(8936002)(38100700002)(31696002)(66476007)(66556008)(6916009)(66946007)(8676002)(4326008)(6506007)(53546011)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWdkYlZwbEVFYXpybzN5UWx1Um5GcU1NTGJZSVZySzkxQkI0UXlESW93NkdS?=
 =?utf-8?B?Q1VTUzBVb3Blbjl6S1JJeXNwd245Z1RrbHNpb045SjdoOXlHR0txUkpEeEVj?=
 =?utf-8?B?dFN6UHVkUEJ1OW1adzM4WEpSbXhQRXNFY214cUp1d094akxmaW5ja3JvbUo4?=
 =?utf-8?B?YmxPVitONWFCOUNhWjRJOUZvcUhyL253bnB4MXNrSFFYL2lUbmJNZmZHSzM1?=
 =?utf-8?B?NU1UZmRZMFJIUXpTRkw4LzArWW9oZDVaR2VyelhVT0ZlUVdUOXh2QURyQ0Y5?=
 =?utf-8?B?a2xhWVlrTWlPajFBZEJ3TVJ1OTJneEdkRkRaaCtiV1N6OUo1SVdFYStOdllH?=
 =?utf-8?B?a1lBMnRFM3pzRXpWejRvWlovV0JUL1N2N2RSUm9oKzh6WlZRVFJxUURLU3M1?=
 =?utf-8?B?OExhN3NEOEIrRkF4MC9qL3NqY1lDT29OTjRRTjFoS2xLTldKKzFHdkhuRDZ0?=
 =?utf-8?B?QTdQSjBXVm4ybjUvUkl2eC9QVnpkT01SMGpUUXU4a1g5TFk2VmhQMU0wNklQ?=
 =?utf-8?B?ZmRReS9UMUZ6Y29kckpFRTFiWE5ta1pTZUVZTGlKSEZ0N1ZVYUhyOGovNHN3?=
 =?utf-8?B?TDFYeWhxOGg2eTJxWEMzZ1VMRDBYa0dXcWd0Q3JWRkFtendwaUs5ZGYveDhC?=
 =?utf-8?B?S2crMjlzNTg1WVRKWXA4VWtBYk8wdVphVGliVUpGdk1FYW1LTGtLb1FPN20v?=
 =?utf-8?B?ZWdPNVFPNFhKcTVjOHRtQ0lTWXAxUVg0cVkrTU1DdnNXVVRqTzZPclhmS1Zt?=
 =?utf-8?B?di8yakpObWsybUN1RlpKNmNDWkJMa1YzRHVVcnNGNXozL1hBRmwydzl0TkpC?=
 =?utf-8?B?azU3SkxOQXhnbjBSRVdRMGhqZ1RmaEhMUVYzem5iN1JFR3ZQdGJ5cWE1NTlh?=
 =?utf-8?B?VjNqYnNhS3k2RGNpNUU0c3dGY29obFVOYVVncU1mUXpyM3RXMzFHSlZpcDRW?=
 =?utf-8?B?T0NNVXg5N0JHdFkybFdLcUs1cHJZL1BXSjJCRVQ5YUEvalorcVQzT3RQTk1P?=
 =?utf-8?B?VEYyZHRQT3pWMDFoTUhrR0s5MmpLczhiZUllV2NDOEhGL002NWJCd3U2NTIx?=
 =?utf-8?B?K0d6VTF2U1psNnkrdTZ4dDZEYjFIOUF0amY0bCthdElvcTNBV3lkL3NLcVdh?=
 =?utf-8?B?dmNtK0ZMcWZmZjNvZTdMSkNORzV2VUlyN2ZjWFlXTEdLUSt0YVg5ZG9XWlFu?=
 =?utf-8?B?Q0YvN05VS3E5ZE1tWFhxRDNteS9nMlYyQkZPYVFQUHVvOGVBQW1iUkxYTHJm?=
 =?utf-8?B?Wm0yaCt6L3ZhaXRWVE9LWGxNZVFjVGEzT3hFR3R1Mnk5cERMTytwZ1ozM21k?=
 =?utf-8?B?WjNsR3kxWlIrNXFEUWd4dFhmelFJRzBrbWc2bXFDeUtiRkpQUDZtcWJFZXVU?=
 =?utf-8?B?K3U1R1hFc1QvL0VTRk9VN1p2WHVlODluMTExWWdjaHBPTVBzM0QyM0hCV2F5?=
 =?utf-8?B?RFpBazM3TkJyQUtTUlNLa3NZcjF5aE9nclpXcHBuWGRSS0djbURWcU5vaGF4?=
 =?utf-8?B?K2krUDBuZXpwOXlVN2VWWTZic1pkUUVTWnlZWklaWHp6M1RpS1JqWWF6VENx?=
 =?utf-8?B?N1JKeXFqMGszVG4xU3QveWhxbVBFakhPeEhBVVF3Y1RLNk5Iakx4bHRZcG1x?=
 =?utf-8?B?UjVRWXBRdXhyaFFHanM2dTltczcvZFFLTUQwTE9YVXo4dllNUEFReittRWdS?=
 =?utf-8?B?RG0yMVJuQ0daaGd2N2lRWFVEb25YV2REaTZNL0R0ZHVoMW0rQktaYkVGNXhE?=
 =?utf-8?B?SHpxckl3dkpHTXJQUW1NWml3ZTdtZVV2RmVaRkhkZHI0Tkt1L0NLTEdmejFX?=
 =?utf-8?B?Zk4rSk5OZWhjK0lZODlRTjVRcjcwdzMwVCtya3NTM2NqbnhrWk12KytNYU55?=
 =?utf-8?B?T3RWWmRMNVNzOGxQVzE3QWQzanVNRHRHYmZvQlY5NS9MVGIrT3BJUVdFZ2ty?=
 =?utf-8?B?bEFTNGdkMEZWaFNreWhYWW5TckRwQS9qeURRamxld0lDRy8xVXJ0ZnRod3Nw?=
 =?utf-8?B?ZFBQM2VudUk1OEs5alBPNXJLK3pPcGVmL2xZV2RVQ2pEVFo3Zlo1bGJNK1JT?=
 =?utf-8?B?SmF3WFBFdk4rb2hXS2F4K3owNGFTN0hreXZVVHh3RkNIbVFlOUlzZlhxTTUx?=
 =?utf-8?B?M0RkSHVoU3BmUCt6blFNdHF4eWtadFdzY3ZubmxyZ2F4OGI1dnhadkhwUDQx?=
 =?utf-8?B?NnNXVjc3a05qNkx5a2ljamVVcFE0aTd3SndmcG1vUE5vN05xLy9QRmV5d0xF?=
 =?utf-8?B?eDFHeGkxdGxJanJrYjJpUm9rL0h2YjBBMS9oTk1vQVowT3Btcm9YVVNEVmZy?=
 =?utf-8?B?cmFhTHZpSG5tdFZwRnVHQzBDYm9jaDloMTlFVGd3K0ltelJoZHYvOGI0djZl?=
 =?utf-8?Q?nauyzSOlA9F9VoSU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d04b6f0-330f-4d58-488e-08da33787c68
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5740.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 18:03:00.4678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWh59fE+EapO4+qLCXhv9FjCrllddnQcCbp+Oi/dBbtXIYH9vo2bO+e+OE41BaQlhktbqcCdc6oh5XaXfgzzmRLpO1E2oiqAId/jYlGdSXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2533
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 5/11/2022 3:36 AM, Jarkko Sakkinen wrote:
> On Mon, May 09, 2022 at 02:48:03PM -0700, Reinette Chatre wrote:
>> A PCMD (Paging Crypto MetaData) page contains the PCMD
>> structures of enclave pages that have been encrypted and
>> moved to the shmem backing store. When all enclave pages
>> sharing a PCMD page are loaded in the enclave, there is no
>> need for the PCMD page and it can be truncated from the
>> backing store.
>>
>> A few issues appeared around the truncation of PCMD pages. The
>> known issues have been addressed but the PCMD handling code could
>> be made more robust by loudly complaining if any new issue appears
>> in this area.
>>
>> Add a check that will complain once with a WARN if the PCMD page is not
>> actually empty after it has been truncated. There should never be data
>> in the PCMD page at this point since it is always updated with the
>> enclave mutex held.
>>
>> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>  arch/x86/kernel/cpu/sgx/encl.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
>> index d1d4e8572702..af972dbad965 100644
>> --- a/arch/x86/kernel/cpu/sgx/encl.c
>> +++ b/arch/x86/kernel/cpu/sgx/encl.c
>> @@ -183,12 +183,19 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>>  	kunmap_atomic(pcmd_page);
>>  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>>  
>> +	get_page(b.pcmd);
>>  	sgx_encl_put_backing(&b);
>>  
>>  	sgx_encl_truncate_backing_page(encl, page_index);
>>  
>> -	if (pcmd_page_empty && !pcmd_page_in_use(encl, pcmd_first_page))
>> +	if (pcmd_page_empty && !pcmd_page_in_use(encl, pcmd_first_page)) {
>>  		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
>> +		pcmd_page = kmap_atomic(b.pcmd);
>> +		WARN_ON_ONCE(memchr_inv(pcmd_page, 0, PAGE_SIZE));
> 
> Is WARN necessary, or would it make more sense to use pr_warn()?
> 

I will change it to pr_warn().

> It would give a better chance to collect information if "panic_on_warn" is
> set for the running kernel.
> 

Reinette
