Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916C4C433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Apr 2022 18:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380073AbiD2SyO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Apr 2022 14:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380077AbiD2SyN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 29 Apr 2022 14:54:13 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD1E61620
        for <linux-sgx@vger.kernel.org>; Fri, 29 Apr 2022 11:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651258254; x=1682794254;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X9a3IRALd6cXo9A1r6gurQveLU4QaQU+qRcpGOPLLZM=;
  b=a8dtoCU7WDgH3kLTPMcPjGasuxJ7tVAA0vWmGJ4wfRabnr/vr+1zCnPQ
   s7vseuBx8QJ/MzwQCg6TVE41k8hZzP/Fak2ScZbolnS2slZx8/elQHjd/
   PgBoLiKcKcNF4Xau1bHOg7jb0vKjYDwqr0WG7Ykg6exADnAQQLWlXSgqJ
   YKY2/Y4dZrCTcywO8uywDEzWpreFOoJf+VUojRzptz5bz1FsZv+Z8aoY6
   +hFDjjjp9tvv/JYgOKTvKl4l5u23CQEhr7k8BVMOJzl3sBlNHnRQ4F3dw
   +DHTueZYmWy9+e7RifXfAsFLonjNw3gdK6hjpMeRi6I7W4KGhS8HN1Cq5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="291915772"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="291915772"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 11:50:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="881373101"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2022 11:50:54 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 11:50:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 11:50:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 29 Apr 2022 11:50:53 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 29 Apr 2022 11:50:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwV6mBr/yyVVf7AfDPr+mjPX7FAJGMzrmfhoIScXMk60veuNicX9qn/X11ObXy0GJX91JkKYQJcwuS2D/WMQyhc0GqyFz5O8PBVsx4xWOinJXeV8oCbbW/C5pKowqCTStd1ST5bYggKqB1lHDQOAfUNmSQrWzrrICehFH0SHdp6TIxSqjIXt4lhkhnbGl2DRUkyOl55Ty036nOtYGV5w0euZYntk7YqGGrnR7Rpe/kUygbEy3OGROkFMq2J/vrI3IHmf5hj2P1EZWArPs3cuhTfE61C4QuXtFpwfBE5FZmDQUjmLs2UTl13PRiezXLjCZ1EdS4BNZA2Dk5Mi9IIbng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vOd9/BRUADdRRMhaaJN/4XPwItwee20tNfDW0QT+JU=;
 b=WlP8W2L4naNoihS78R2bnfX+wOkLnRIW1FP390auA3Jv5b7ply1FKf2f4poH4pLCtN8ane+nGDj6KjoAlKvN2Z++Q3SihuA4i5yKnMuuPy1fLr/3hp1UyIKihG9CVVfQRGubymig0ICmbx0RYTdibu8PZ9qb8TYAS/qo2Bj9uAj7H2TBYd/pbRwOJoKWMg2ILcjwIiL1Eo3v4VR+y7QMBt7igj1TxrDsFZvh1LaWbXPwJcN/HXRPGeTc/1crvNqT3DQQQU5Bhk2fGsJz7JtZddv1Kz4o+M6tspmrIAlTy846GvhD8SXzCdUpkRSHtJM7hNP7HnVlwvdGRSWoQ9+c6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by MN0PR11MB6182.namprd11.prod.outlook.com (2603:10b6:208:3c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Fri, 29 Apr
 2022 18:50:50 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 18:50:50 +0000
Message-ID: <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
Date:   Fri, 29 Apr 2022 11:50:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:254::16) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f98128b9-ec68-4fd1-777e-08da2a112dd4
X-MS-TrafficTypeDiagnostic: MN0PR11MB6182:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MN0PR11MB6182F3D8799F3C02B0FC8194F8FC9@MN0PR11MB6182.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0RaGn5JPR9zQDFoEemIJrcyTVVjnqWRjR2U/15V25CRhCk/6iPtuQfXcrjuhVsOeci4SNY5jl9F6/AFIOrMGX4h2Tqhb7uCBXywBdehUML/hPCI5cgqv40JYSLb5QU/K1u+HHw4bepJHnBTBQZs+0OLzlJujAp8mA4EggsUnG8jdUWw1fEsrwiZHS+X8Bi1dpM8kNIEX0zKodqKkGFDDrM1mAE3Sn+bcRqryMDieiGhivT4kYRhK2O0bLKBqpkCpgT89LtcWgrexi0HuJUK7SKz+VXhVhMfcZyfbXLQpBqz3QMZKeGtyhbMFt2m0Lj4ByplxvJcMAG1SRcP/qwDcV75PRfjsjC+Mf6TQBB52bgKSsAwmbsITLp5x6H/WPCCPU7zYmVl23jyKF1blVhsMd6ChnrMc1wU9NzH7xuV3AE2CBNGuP7PTFaUJZOhh+TEGwBcyqXE4NuJT7RLH8Iq1STo2F0HRoZvnjXcwv6/vQES9GioSg93iqTXsN4BOG0DcWoJZYAVHr/x05JqxhNWddPAnvgNvY0fcKQ8rSVC1RRtKaq+yaY37i17ILFvDdpKkdPc6Boj07zGMt0+h/ly6puIxCsqIuiZlQaLKM+DDbYHRLGXwn6IFLoJ5uo9G4nTmO0uKImgQ3OYhzaxmzfRWByx+j/2jcd0xDcVVVwAYmCTpyAP3bnECzYLuTvioMbeYOEC/n3GphxDG+L74QHBPgrY7SpWqxBqcbNsKDrgi8j2L1OC1OkK1FNn91+KB70v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(53546011)(83380400001)(31696002)(82960400001)(5660300002)(44832011)(8936002)(38100700002)(2906002)(6512007)(31686004)(186003)(316002)(36756003)(6486002)(508600001)(4326008)(6666004)(8676002)(66946007)(66556008)(66476007)(6506007)(26005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGVsQlNoTE5uQ1FIUlBNU3dNZStkSHZSb0tCSE5BNHJPc0xIdzF2dGRjVXFU?=
 =?utf-8?B?SkFIYVc3U2hkSXFBbFlTMkp5ZUxPVVp1WUtHRkxsQ1UxL0prUnAvdHB6bmJK?=
 =?utf-8?B?RDlmS0Ezb3VBNC9kbHpmNW1GOTk3TThxbGRrQTV5aUI3dTJpTkI5WUtkeXBN?=
 =?utf-8?B?dm5CS3ZtVk50QW9aNnZqeFFvakxBVC9vL2cwZDEzZ3duOTJvdW1wcWJLV211?=
 =?utf-8?B?WUZvNjBLM2FpR2c5a2VURjc5ampVQ0UxMlhJTE9aVDkyRm53MU9iOTQ2ZVNT?=
 =?utf-8?B?UGxpdlFYUmM0QXh4Q05TbTFrUVVaUXc0Wk5CQVZZdU56bHpvM2Rld0pUZzln?=
 =?utf-8?B?TWNnRXVSRHBUM29ralY0R2kyc2xZM2RpTmZsbDJhN1c1bVBUbXZtd3B0Rkds?=
 =?utf-8?B?elc3OVNBc0NnZkh3TUw1ci84a041YWd5dHNkT25SUlR1T01UZmpvSmFvZEE5?=
 =?utf-8?B?anZNU3FzbDlTZlVTbitjcktORmRqRnozbXJQMUZXQklCNGFrbE9ZZkdRSjAr?=
 =?utf-8?B?eUgzbEpsbHFVRHRGUkZMdm92VXUyWW1LRDd0NGxJUVZwR2ViYzZjR1Nha0xU?=
 =?utf-8?B?K09tc2Z6V1JkcnFLUlRrS2h1dFdhbnNRbzc4K011R25lRGdyK0hlUjBKbEw0?=
 =?utf-8?B?MlIyeXRrUWV6cmJnb2NKM1VXMVAxcWd2dTR4dHVoRDJua0NxSFJjWExONk9E?=
 =?utf-8?B?enAvNVBDQkdPL3FtdktMeHdUODJqS0FITDZleWdoSzh2QTRiRnQ1TXNYTXY3?=
 =?utf-8?B?TTMxUURmbFBCelgyYTVacFRUWFhjVmVnK1JzSVo5TVJWYWFYUGd6ZFZOSnFR?=
 =?utf-8?B?Z3FpaVUyMUtUdnJPUnBaNFVGUHYvbjhPMG43ZTBld1o3cTdoaHVWWmhvbysw?=
 =?utf-8?B?eXlJalpjTWYwbXVuc3V4RXJEZjQrczJzUkRCaU91cjJ6dDROT1lLckMvRTNR?=
 =?utf-8?B?NUZLK2JoS2dmSW9kVzM2dWxzbXZ6ZmRyazVENFNJZGcrOFZqTHI3eEE2QUZh?=
 =?utf-8?B?NUlxN0o4ZnhwaUVUbWxJb2ZDUzgzL05JQ2FWaFF5Y2dOd0ZtakhsbmI4aXJE?=
 =?utf-8?B?bmQzREtsSlMyWUp3bTVGSnZCL0lKU053S0djc2orSjczOCsyUHdKcGt0b08r?=
 =?utf-8?B?SFRvNk0yMzZ5d2h5MUExWFA3R0NVYU9SVVVUL2NuWW03bDZybkxWeE14TUgy?=
 =?utf-8?B?ZTVHcklTQ1B3T0dJNmpLY3E5d09UNDlHMWJwa0lNVStZTG05aUZBTUlpUXha?=
 =?utf-8?B?QmFRc0psV211aThMNVJKcWdUSGsxSWxWbkdmYklZQmRwcGNIYzlXbkN3c0gz?=
 =?utf-8?B?S3ZGcHZDbmdXMEE2NWZKWERqeCs2VTRqZ25aTFVYd2ppVUZCcDYrRGN3RDhz?=
 =?utf-8?B?UEVtSkhQeHBvUS9BUTY1ZmxRSWFVSFFpZ3IySEVkVmRQbUwzNDIrbW9zbGpN?=
 =?utf-8?B?Z056dENYR0pTUTBRbWhSOFdCa1kzV3VOemhxUDhYUnduaEJxQ2ZMNUdIYkFE?=
 =?utf-8?B?UEt3UmgxSDlsSGNITnNpbm1wWDF2Z3JXNDhueUNHdVJYRTVxVmg5TVFTbkZ0?=
 =?utf-8?B?T1FEZnFYS05KZmN5N1BiRXNycTFwYVFTdXBYM2lhcTdDNmNDTVFHRnhqVXlh?=
 =?utf-8?B?Y3AxdzQ4R0k3UWZoZ3BlMW5BNFJqYkhJNko3SElSaWJwL3AwYW12enoxbXd3?=
 =?utf-8?B?ZXA3U010ejNzYTlCN1J0Zld5NW1jTExDWmhXRnNJVXU0WXpLc2tiTVRrWlNa?=
 =?utf-8?B?UkFicThTeG5yOVY1L0ZrbnFRUnJHbm4yL05JUElMdnJSRUxmWjBqL3Njd2hi?=
 =?utf-8?B?ejlsMFVSbDdZaXdlSzViY1dLS3Vmb1BTcnBFSDhEV0V1ZmlFSmxnRGVWTkJQ?=
 =?utf-8?B?L20wNU84VjlXUlJKcVhjVi9IME15MzNDMS9RTmVHMWRSdVN1TFV2b3lya3Zv?=
 =?utf-8?B?RzRBOENvVW9LVWpwYVZVTkZTL0hocnVVSVpjeDBnajRsaS9JSUlEeVJnQ0F4?=
 =?utf-8?B?SlJ6dkdDZ1dSRktIdDN3NFdZalBPM2pUUzVQVE0reE0vMWNXTWhkOS9iNnlN?=
 =?utf-8?B?UWxaZmk3OUxWeThwbjJmY1d3elpkck9HamFmYW9uLzYvZWNNSGtVNWw1SXlz?=
 =?utf-8?B?M2xnL0VUeGorWlNESWxwMGMyLzE5TDBqTm1YY2tINFBTNUF4Sktsb0NheUJx?=
 =?utf-8?B?ZGZReUs0aEpDZE1HaDcrNURUcWV4T1l6YXhKZXVnVE54ZGxkTEpwL3ZxTGZj?=
 =?utf-8?B?YWVLekwwZ0FZS1FlRlNBYS83REZMOEFGdFlkdjNsa21XVGl1aXJuUmVyb3JV?=
 =?utf-8?B?NFYrRzJsSnMrbHRVeVZaODlMUjRNTVhVcnZDN201b2Uxd0QwR1ZvWUlBT0Vy?=
 =?utf-8?Q?b6b6YdzBmsCykg7A=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f98128b9-ec68-4fd1-777e-08da2a112dd4
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 18:50:50.0718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hxi0ftewEE6G0B5oGEYw00h7v8WocUE35GSWkqjTZ5pkl/PW/ic+c04nwl/jEneJxZQGi7zsmZTOXKy6FCGOzXXuQiBvEmW5LMqBVPSUXsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6182
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 4/28/2022 2:12 PM, Dave Hansen wrote:
> On 4/28/22 13:11, Reinette Chatre wrote:
>> ELDU returned 1073741837 (0x4000000d)
>> WARNING: CPU: 72 PID: 24407 at arch/x86/kernel/cpu/sgx/encl.c:81 sgx_encl_eldu+0x3cf/0x400
>> ...
>> Call Trace:
>> <TASK>
>> ? xa_load+0x6e/0xa0
>> __sgx_encl_load_page+0x3d/0x80
>> sgx_encl_load_page_in_vma+0x4a/0x60
>> sgx_vma_fault+0x7f/0x3b0
> 
> First of all, thanks for all the work to narrow this down.
> 
> It sounds like there are probably at least two failure modes at play here:
> 
> 	1. shmem_read_mapping_page_gfp() is called to retrieve an
> 	   existing page, but an empty one is allocated instead.  ELDU
> 	   fails on the empty page.  This one should be fixed by patch 	
> 	   4/4.

I am not yet comfortable calling patch 4/4 a fix. From what I understand
hitting that error means that the kernel lost a page. This patch detects
it earlier so that we can avoid the ELDU #GP but it does still seem
an issue to hit that error in the first place.

> 	2. shmem_read_mapping_page_gfp() actually finds a page, but it
> 	   still fails ELDU.
> 
> Is that right?

Correct.

> 
> If so, I'd probably delve deeper into what the page and the PCMD look
> like.  I usually go after these kinds of things with tracing.  I'd
> probably dump some representation of the PCMD and page contents with
> trace_printk().  Dump them when the at __sgx_encl_ewb() time, then also
> dump them where the warning is being hit.  Pair the warning with a
> tracing_off().
> 
> // A crude checksum:
> u64 sum_page(u64 *page)
> {
> 	u64 ret = 0
> 	int i;
> 
> 	for (i = 0; i < PAGE_SIZE/sizeof(u64)); i++)
> 		ret += page[i];
> 
> 	return ret;
> }
> 
> Then, logically something like this:
> 
> 	trace_printk("bad ELDU on shm page: %x sum: pcmd: %x %x...\n",
> 		page_to_pfn(shm_page), sum_page(page_kmap),
> 		&pcmd, ...);
> 
> Both at EWB time and ELDU time.  Let's see if the pages that are coming
> out of shmem are the same as the ones that were put in.
> 
> When you hit the warning, tracing should turn itself off.  Then, you can
> just grep through the trace for that same pfn.

Thank you very much for this guidance.

I added trace_printk() to the EWB and ELDU flows as below and found an
interesting result.

EWB:
__sgx_encl_ewb() {
   ...
   trace_printk("EWB encl %px on SHM page: 0x%lx PCMD page: 0x%lx index %lu sum: 0x%llx \n",
                encl_page->encl, page_to_pfn(backing->contents), page_to_pfn(backing->pcmd),
                page_index, sum_page((u64 *)pginfo.contents));
   ...
}


ELDU:
__sgx_encl_eldu() {
  ...
  trace_printk("WARN encl %px ELDU on SHM page: 0x%lx PCMD page: 0x%lx index %lu sum: 0x%llx \n",
               encl, page_to_pfn(b.contents), page_to_pfn(b.pcmd), page_index, sum_page((u64 *)pginfo.contents));
  ...
}


Below is the last few entries of the trace buffer:
           ksgxd-806     [022] ...2.   857.259294: __sgx_encl_ewb: EWB encl ffff90a2a38d0000 on SHM page: 0x27906c PCMD page: 0x27906d index 168866 sum: 0x0
           ksgxd-806     [022] ...2.   857.259299: __sgx_encl_ewb: EWB encl ffff90a2a38d0000 on SHM page: 0x27906c PCMD page: 0x27906d index 168866 sum: 0x9f7dc28a239283bb
=>           ksgxd-806     [022] ...2.   857.259321: __sgx_encl_ewb: EWB encl ffff90a2a38d0000 on SHM page: 0x27906e PCMD page: 0x27906d index 168867 sum: 0xcfe97176b1e8c386
           ksgxd-806     [022] ...2.   857.259325: __sgx_encl_ewb: EWB encl ffff90a2a38d0000 on SHM page: 0x27906f PCMD page: 0x27906d index 168868 sum: 0xd1d012775db676d9
           ksgxd-806     [022] ...2.   857.259329: __sgx_encl_ewb: EWB encl ffff90a2a38d0000 on SHM page: 0x279070 PCMD page: 0x27906d index 168869 sum: 0x1c568b08bd31d7bb
           ksgxd-806     [022] ...2.   857.259333: __sgx_encl_ewb: EWB encl ffff90a2a38d0000 on SHM page: 0x279071 PCMD page: 0x27906d index 168870 sum: 0x4dba242d348982a7
=>  test_sgx_large-4092    [030] ...2.   857.259341: sgx_encl_eldu: WARN encl ffff90a2a38d0000 ELDU on SHM page: 0x27906e PCMD page: 0x279052 index 168867 sum: 0xcfe97176b1e8c386


It seems that in this scenario a page is evicted from the enclave and then almost immediately
faulted back in. At the time it is faulted back in the sum matches with the original
encrypted enclave page at the time it was evicted from the enclave.
The interesting part is that the enclave page's PFN matches with the PFN when it was
evicted, but the PCMD PFN does not match.

I did search the log and I cannot find the PCMD PFN printed during ELDU used by the
enclave at all.

I am not familiar with this area - is the PFN expected to be consistent? Do
you perhaps have an idea why the PFN of the PCMD page may have changed? This
is running with this series applied so the ELDU flow would do a lookup of the
PCMD page and not attempt to allocate a new one.

Any hints would be appreciated.

Thank you very much

Reinette
