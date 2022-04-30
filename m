Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AB1C433F5
	for <linux-sgx@archiver.kernel.org>; Sat, 30 Apr 2022 15:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbiD3Pzt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 30 Apr 2022 11:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiD3Pzr (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 30 Apr 2022 11:55:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2EE49F92
        for <linux-sgx@vger.kernel.org>; Sat, 30 Apr 2022 08:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651333945; x=1682869945;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1qzzTp59dPQ/ju8itYYa0JEtPGeJmFKBhYwlWxydjSw=;
  b=XYyRJ4l/dYf3YcUMBWzzfuf7qt9YzUKVObHdlJ3hR2Fjkg6yVOkTkRst
   RSLB4p9E9NwUSwbyVnsholTnn7VGsLTlKuXr25h+UqNAb/DS7F7sSVVhE
   3JUIECxCzP0Not9hFRRHe/dqReBkltceOVzDqbufsiGBtNBVUoGCaDeo7
   xsAF3Gvmu2ZMAFROcJWQ/G9eMWl82vb6A0wKY3KKerxCg6wuWbt9ZVqws
   ur7rfrDq+ZnvO2oInp15KSpvWzlx2L+3Gvx0xX7mBl5fENQ1rBblqQ741
   vjrJIiqL4KLHwBoRBmb6NAYRavq8yxItT5Me/vX1B9j1+dQSYdtIOuIE5
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10333"; a="247450370"
X-IronPort-AV: E=Sophos;i="5.91,188,1647327600"; 
   d="scan'208";a="247450370"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2022 08:52:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,188,1647327600"; 
   d="scan'208";a="535013275"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga006.jf.intel.com with ESMTP; 30 Apr 2022 08:52:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 30 Apr 2022 08:52:24 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 30 Apr 2022 08:52:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sat, 30 Apr 2022 08:52:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sat, 30 Apr 2022 08:52:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLTNEbMin/Oy5Uq9/CPLOjYFnc1jjruu0u7okwiVnGTsYhBJC7VDSOprIL9E4QZUV/qasP4jzz+nbJFWGFi5i4bv/k9Hmpg6/5bYQ31Ps/1r9LAVouZA23xFX4417902qTLQeDI62TSB2DLOwk/A24HdIkmFgVeqHRFVsl4zapDkRmGHPLgzW6rRHX1ZAszhkm6T8AlJhepKghjoc2WXEh0ckYdlV49bbXFyXjrKRO3HLZdIhECRbZDruoeDHQZpDwnE1Nm2l6IXzxCGi4qXC5bGBylWHJekbZEtCa2rkYwYkyyJqxTCA+jBJSHJ8/LCwSao1CNbTcjWKcTvfWCShg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ErtRsPNQaQBjC11yDJJYFBAP1MYVR7vG+6IZBuY1NM=;
 b=kJ1hNCr7+q+FpORx7qJjpxvfv2MkxlmI7UhnzVe0trDvRL5ZjxLHvIKouapu1+V1Ki1jSP0begnCHedSgLD2RKOdksOQBjQAeJ9bUlf7YIjM6vmgbD9aLB0IYdLaL1ZJKfPgye1ArzKIOJ/N6t4IWjDrneeCfGLSscRC1MnffElY3ROKnoHrZj0wZgOsnnomU61tBB5LHbqixEgdXa/qJkPkkFIpa/InUK3vYmLsbTUpG5SDhwenXtYvaF4KpimdGEB8Uhcyo+5jFBBxPkQcnR67tn0o8zT02eb+TpmYPBRE6xzSg+xWOzq60jekGnX34tQlclikiKPh1MkHV985RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by CY4PR11MB1560.namprd11.prod.outlook.com (2603:10b6:910:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Sat, 30 Apr
 2022 15:52:22 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.013; Sat, 30 Apr 2022
 15:52:22 +0000
Message-ID: <3a32fc64-b986-6f1a-f714-cbe4cda638ed@intel.com>
Date:   Sat, 30 Apr 2022 08:52:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
 <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
 <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
 <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
In-Reply-To: <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0012.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::25) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a1ebec9-62a6-4ae3-7014-08da2ac169e1
X-MS-TrafficTypeDiagnostic: CY4PR11MB1560:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CY4PR11MB1560C77CF68E6752804177D4F8FF9@CY4PR11MB1560.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: naqepFhTX+DR0/5hVoSKX/VjvTZfpKM8sEdIsG+Z644ctJha41cPyMC3H/NoN7hYaFcINEfkVMWTOCYzUlVb2acnzOq6TyfQCiZDiQbnpGkeSw/ZAfEZ+nQgL2TBkLCisuezhcvdkgoqCJ6so7vSAX8hn/bjs1Ax+o5MKkerA8uAkQSSi2tX5sYUYVizYCDYq11wUEc+5CeZraG5hrEH3ARCdll4E6rnfienUn2slTBZeudhzqmfPTliFhpjkSI1UxElWvCWnTizIzNCvQdF6jdAC1XvjMrAEn7CvOzpsnmF0nReRdRqjGEmqZSMpb0G+tG2jAIAC90S5aYQN4YHonhBGumNn8B0yTQJEgs544UGW5BuXZxsh+Vu73hKAruiFs5nO6eBBrp0L7WRSWi08j4bLE3+OA/RP9enkAcfRooYGhwLUrwpQM7bFegE+u1mhL16OEVadjVeuXNcOYsohrr46PwI+hHVUk2PhN1kDQ38P69v7BC+3yOGqu80z/cGY4D3nFyathyGQegsfBBg6KDSiSU5UMjya5ekey9YRvLi2hlu2fkWEYl7+Qbet3MYCyajkMSMX5NjA2stQ+r2WlL00lBCW3qczZfxTDRCgDdYP1BKXKgpRPAzxKMqsnCqUgWIFYewxy7u1U6ziRKFDgArroGhZM4bu8izNaboGKx21vJe5RqxsoGfs2FMMxpDmc2P4My4O1Mpv/GDjxN5kcPNLG7R166vBU1g8c3fIW2FVUgzeb3UVmQ1MdjV6lGc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(2616005)(31686004)(8676002)(31696002)(44832011)(26005)(508600001)(6486002)(36756003)(316002)(5660300002)(6506007)(6512007)(6666004)(53546011)(8936002)(66476007)(86362001)(4326008)(66556008)(66946007)(38100700002)(82960400001)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cklIdnRoYzE0K1JNZVNuNzRnS0VySzJ4ek0ydnlhTHp0aEVaR1AvcWpzaXZm?=
 =?utf-8?B?Tk1wNkVhSGZVZ3pIU3dvSmpsN1lXM1RKcGc4R0I5eEZvZWF1cGRDbGplbWRT?=
 =?utf-8?B?OG1IdEp6SVdDZy9ROG55UXZNWENCbW5pTEhQTmZMYnYwb2p6am9adVBLOWZB?=
 =?utf-8?B?dHRTK1ZGQkVUTGo1WjhKTXhQUnVncEs0MGxWSFBqaG1jSkY4dHozaC91Zmhx?=
 =?utf-8?B?Nnp6WXFoY1lJMU4vWnhJVUtGeGRNZEJmMWpGT2FGUGo3S1A2Mkx5eCsrZy9V?=
 =?utf-8?B?MzFZZHFVbXZocVdkZGhxTmNOMHlOa1pld3ZUd1pyWkJYWVd3ODBYTkJCa3dH?=
 =?utf-8?B?NU9uTCtHSjh2NC8rRzVoZWRZdEJodnRkNTVkS3d1N1Fldmswd3JXY2l4VmFM?=
 =?utf-8?B?MlBtUUlsc00vY0dPdVpyYVR4em1vSko5QzBtNkExeCtNYldGby8vVkFtOVN6?=
 =?utf-8?B?NkNIeWF1MWJVNlVtanpnQXluSEhMZWIySWx1bG9lTEx5NzVVK2NqMCsvRWFS?=
 =?utf-8?B?U2p2bUNUNDJYcitLcVloT1RCZG1lM1AvV2VxTDNJOWZ5Q1NqYzRrQWJ5Ujdl?=
 =?utf-8?B?dC9wMmoycWRHcktVcGhuY29MVk1QTWNHUXpReGVrVm5vN2ltOHB4TjNFeFcy?=
 =?utf-8?B?akFodCs5U3dHOGdMNnhvNkw5Tmx1TXl4TmZybDE0L0RiME43Nlh1dXZQNW53?=
 =?utf-8?B?ZXg3cE1PeWZ2aVltdGVtajNsYTJraFdMZzR4a1RNdzg5QkJMTUhSTWxjYnhN?=
 =?utf-8?B?eEo5UXY3N0J4Z2FaRnF1UldHaXdHYm0wY2Nnc0JiNmxLaDdoRHNjQWJCNnJr?=
 =?utf-8?B?RFd2bEVKYU0xbUpuVDBrVDlIOVZadUlJU0kyMlg3eUVDZmN1SnFTZTZGWWUw?=
 =?utf-8?B?UUtvU2VOayt6amVPYWxKSlVGaDdtUTVMNE9NOVpQSUlScXhFQnhTemlMVGI2?=
 =?utf-8?B?RHd3Vzljak9yWEZnZ1R2YUVqUXJibTZGcHREQ0xGVG9CbnFSclB0SkZZSW9Z?=
 =?utf-8?B?Z01pRE13b0t2ekFCWmE0b1RpOUMrTlgrREdpUm5aNFE1VEp5QVpBdkRQaVpH?=
 =?utf-8?B?MmxIT0loM0Jxa0JnZ1Z2N0pIYitMUUxwV1dZeStzV2ppc29FY0lxcVVsODFh?=
 =?utf-8?B?WWxWVk8zWXlBSEU5V0NBMXBZL2dDMFFLYnF1dUtpOEJjVmlDdUs1V1pDM0du?=
 =?utf-8?B?VEZvK25LQ0ZHKytsaS9iYlZzQmxtandjeXRlQzdQdkpDQ2tCWTUwbkQ0aHA2?=
 =?utf-8?B?eS80TE9WT1k0RFdRVUZQY0RxN1BlalNkcGdVNXRFdFpKdTNaQUFXQytUQlBm?=
 =?utf-8?B?MUsraGR1ekphdmZwVjE1OG0zQVdPRlc4eU4vS3Nhb25KOExnKzZsS0V4eDJW?=
 =?utf-8?B?SmErRXFiN3JsL1hPeFZRT1B2QnRmUElUdzROVkVzWDJYNDcvKzl6TlpsQ1Vs?=
 =?utf-8?B?WG14ekF6bHlPYll2NkNlZ2ZnR2x2QVhMVlM0VzMrZDBOcEVIek1zUXViNDNY?=
 =?utf-8?B?YzdiT0tDMFBOeGZ1bzlVVFNZREFIWlJzSHRCTWRGb3JNTVdZa3RBQjYzT2dx?=
 =?utf-8?B?eXZvQVNLNnZIRnQyU3ZpNmprbHFwUEppZHovMlZHd2tUT2xBcGVOZEVEMTV6?=
 =?utf-8?B?cG9NMkRacDJnakZVNDI3YU40ZnF6YWhKcHUxOHpLRG1QdWkxRit0RG1WMjRa?=
 =?utf-8?B?cWxidzN1TWdkckFLRDNJSVBPdkt4bnQrUnN3RmJHUjgxRXNJSXJyUUdRbDFG?=
 =?utf-8?B?Sy9kT1N1Yzd0d3lTQ2gvZ0JyUEFiYXczWkY3c01oR0V1S05IeGhsWXcwT0NK?=
 =?utf-8?B?MEM5QlJQMWY3UEdGRE1ySWYyK2xqckdTek5QSTRhQXVwd3padzQwR1N5emd1?=
 =?utf-8?B?dnJJa3NPM09FM3dWNjVRUlgrL05RL3luZTJkbmFibGVUQ2F0b1FURE5waEZM?=
 =?utf-8?B?T0lFVmdBekg4b2tPS0QrUExJNTJjbk41aXovNVlONGhObGdTT1RGVWNaOG9T?=
 =?utf-8?B?QjQ0NVhBenRuVnVDUGRUS3VOdEwrMXhvSEdPVXZHUXFBTm1PelA1cVlIYjlW?=
 =?utf-8?B?dURoa2xMNWZXODh4NElzczRaa1d1eXBSTDdTWXV5ZjBvZzR0WWZvVCtWWmsz?=
 =?utf-8?B?b3p5R0ZZbkRZTFQ0ODJZVlNhMjRTbmJ1dWFkZ09STVhyUzIyN2h3QXhCT0Ex?=
 =?utf-8?B?ZHJGRVlDUmp0ckVpNGVRWnkwSVBjSmtkaEp0OHVlNFMrMVl0ZFRFcXFrR242?=
 =?utf-8?B?cmJkdWpUVkdub0hBOFRndnZLT2UyMnowSm5oVFB1V2c2WHZadkhQYlRTNmZC?=
 =?utf-8?B?Yk1WUXdXaVRudVJyK0FSeVhGS1JYWUJycDlYK2hLOWcxb0g2YmFIanFXZHlZ?=
 =?utf-8?Q?8Gt38FhLfX+qJZzo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a1ebec9-62a6-4ae3-7014-08da2ac169e1
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 15:52:22.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cyrHrM6AEtR22rmq7SyKHNQ37tvFklR5cirmQjSK0h5oE9BZOE9jarWDXwhp1MT9au62QVndcd6L/EwnreiNaWenhTeBGeBimJWb0/FGGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1560
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 4/29/2022 8:22 PM, Reinette Chatre wrote:

> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 22ed886dc825..81c7bfc12b9b 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -98,11 +98,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>  	kunmap_atomic(pcmd_page);
>  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
>  
> -	sgx_encl_put_backing(&b, true);
> -
> +	put_page(b.contents);
>  	sgx_encl_truncate_backing_page(encl, page_index);
>  
> -	if (pcmd_page_empty) {
> +	if (pcmd_page_empty && && put_page_testzero(b.pcmd)) {

These tests need to be swapped and instead be:

	if (put_page_testzero(b.pcmd) && pcmd_page_empty) {

I fixed the tests. Even with previous order the concurrent
selftests ran overnight without encountering a single error
or WARN. I increased the number of test iterations and will
run it over the weekend with the correct test order shown
above to ensure the reference to the PCMD page is always
dropped.

Reinette
