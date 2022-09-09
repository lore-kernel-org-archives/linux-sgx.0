Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EEB8ECAAD3
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Sep 2022 12:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiIIMpC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Sep 2022 08:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiIIMpA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 9 Sep 2022 08:45:00 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E34D52461
        for <linux-sgx@vger.kernel.org>; Fri,  9 Sep 2022 05:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662727498; x=1694263498;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tNNdnKSXWMFssXr8WToroPGTN/XEnRsBl6Clh/Cyius=;
  b=ikGzbMS61fO+o3VI1vjgCj0PELEOHu3F9NMWRAyoqZfzZUFQvINAzpg/
   joYopX5RvnHMtRDqjiLKBD+gNR6uNIGzUyCsQFB/FItSWY1dnImw0+8+b
   p+Q18EJ/U/uAfm7kdHyD8EL764Y/MkyoAMKAX3pDtd6zLV7zyO5sLvTQg
   QG1+8+KvL6BylfRuYYN6bB/bovJnVJib4aMBkek8qNf5EX09CRJkhj74x
   EHIHpKGLoF/tdnt2e42wtXrrYGqZEPU+tbbBZRkxGJxuCXAEP2sR5T+lx
   L3S+zHZJf3c7gxX2o9WnTtAEG/3ob8EGRWEekutng3sFJFGiEOdjTPt0r
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="296201717"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="296201717"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 05:44:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="790798903"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 09 Sep 2022 05:44:57 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 05:44:57 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 05:44:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 9 Sep 2022 05:44:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 9 Sep 2022 05:44:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gu4vbwLPkWJ6w81zhDsjls3vu1DE5bZLgVOEL6QidczbIm57c7EJ6SThP+UyGgiEeJHsuV5AHBebqnkSF4Wb+XorNgxaK1fY3IEgyzyZgusF3EegZ6cyYgioBo4F7TemYdnn0rDdtrK6suto9Rn03JriSHQcPJkmHhwPQIOTq+SXI/Gx5SsS9J3+bbKbCmu+sG2byZMsV2wf0G1VeoGwDAwohrW1cSV1lsAC9LM2PVNXK6D44N7n1n8YNTBansm9beD1KPNyORrwOzyqiq5Uhg16fbPS/4c+0YjXE6cNGAGcfA0WjjEeI/S8Uihy2wni0u9lCzKk1nZcVw+4I/npWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ju0kASX1RKuVxYKby7ikDJc7laBhFxY4uQB+EKYQ910=;
 b=fKXhd/xOzQ10FT12700zxxlrKZCgAZCSf1/HzW8F2LUnWOMAtGCVmkWFFPKCSVApcTG0NOZZcEu9dk4VOeN4VYJo2LSvZv5HeTbcDX98rNgjwqDMIpySALGfaBzA2DRd3BoVNaZoS+/peZFe2kmkbdYitbLVg3ufP14S4BmSv9zuI5/nkCcLbGDvhrk7jS9L4SdCyHvGxEcXwqYKurXdDnOq8uIwAd0GneWZMiINJg4Q07vxvzMGAcb/6xcdxZZM4bffq/FHYJ/G9LSPEQPftH218YU0ZrNZYXOViR6QzM6QdtmtOvG1vY0sQvzwFL2It8va7FA0L4Y23AA9RdRebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by SJ0PR11MB5101.namprd11.prod.outlook.com (2603:10b6:a03:2dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 12:44:53 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed%4]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 12:44:53 +0000
Message-ID: <34a15728-af9f-0d75-023f-0b2bc2dced4e@intel.com>
Date:   Fri, 9 Sep 2022 20:50:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v7 1/3] x86/sgx: Rename the owner field of struct
 sgx_epc_page as encl_owner
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC:     "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
References: <20220901003601.2048563-1-zhiquan1.li@intel.com>
 <20220901003601.2048563-2-zhiquan1.li@intel.com>
 <7d222818eabcecc1376c616f8f2fcbb89f0df70e.camel@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <7d222818eabcecc1376c616f8f2fcbb89f0df70e.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0048.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::17)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|SJ0PR11MB5101:EE_
X-MS-Office365-Filtering-Correlation-Id: c1bb31e2-af63-4ef7-efd4-08da92611773
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JGRQ4IAMWWIMUvVgh2n5mRdVX5ULy5iajEtZbcMxW2cP4F8GIYEPpPoqURSn94czfWKIX/UVQuFq3XOgVIg1a1TgZYTyUy+XYbNaghHG22b8rfv+vwUic+5yPhbMZwRWeRt52KZ1hWqG/2uvQHlU9GxpfCXtSPkKtWbglj5owsKX4ktIBbptd6UeP/mPFd9jXsCmnCMI/A/s+9h2eWau6chipKeOeg0HmFdMa1hWO1gvHIuaxQiX9h6/wY0vcOJrp4o5L9jjoxeinKm/64n3nlfqe86zOIsPGkT+QIspM7fLq+Tzre5gNvd4ViIjjtlBhvHsSiNBoCvwS+yDQIu1y6IS7BCuJ/r03g58/yRBUASTmQyVxyM0TkUZ5mC45DG1MHweGUHWk5jxOtKRUTSzCqEX/cno+wKtGNh8gEXvOdXasbEFTUWl45/9Q+cxdu/ISFbfl7paV8rwQPb8eGI/RjMPozbqjwy2RR+xczzfnD6gEw6T1pYL0ePAvoB6OELnT7hrpVZZl1249knF2zeEi2zdrDiHNDea8HjpwpT3VIM89wPevRgy4BtJOHzoL05W68OC8ICsVdR9yga9bcXHQHJ9iG5vmqZ1GMKp0BRf3mKon3eIKcuvDVEAUV2XAUcOm4T4WpB1IAJk8q50kDEQKb6+xukzmZF3q8HsJhquci8KFadWZn/gpFE+dSrAKXLlE3/kK58W0qFCqYe8TZ+XlSiP3EUn/MMfzGDVe4p2MeeCoCeY7lNEmVtsgZlVMmGO89+J3zZTXdhgMcNcW4bXNH4291Uwon03Zk4ks3ROqTA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(346002)(376002)(396003)(136003)(38100700002)(82960400001)(36756003)(66556008)(66946007)(66476007)(4326008)(8676002)(31686004)(31696002)(86362001)(6506007)(83380400001)(53546011)(316002)(6512007)(26005)(6486002)(41300700001)(6666004)(478600001)(186003)(110136005)(54906003)(2616005)(5660300002)(2906002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE9TR3Z2N1ZCcFdaclBud2dNamlJQjFIN1luNFZvOFI1Zy9EMUtjN1lDMWtE?=
 =?utf-8?B?RXQxSDNNUzYvaTVOQ0VKTUt6UVR2QXUxQmZVSWVLQ01kdEU3akRzSGxkTFpX?=
 =?utf-8?B?OUMwN1BONDNucndac0JSZEFLL2VQVnVUcmpNVWRPOE1wL0tWaXVuMFUzUStS?=
 =?utf-8?B?YnB1KzVRYkJYQk1XUzQzSTVKdklsR1pJVGlsc2NoRkVKaEJVc0xPOWlDYVky?=
 =?utf-8?B?R3A0RGlOREM4Z2JsN2lQcW9LYlBRRnMxZ0V0aTNMK1IxTGR6bWEvMzZERTlE?=
 =?utf-8?B?cm44SkY0REI1d1ROWlNKd2RWSWNhaXRhREt4OCtnQ1BJa2F3ZTcwaXU0TXh0?=
 =?utf-8?B?WE1kQjJFNXhRUG1zRXhrOFhrQXdpTXF4TTJiSWpkcFF0OE9yQUkvcWpXeXdJ?=
 =?utf-8?B?S0tpSVF0VEdjN1BJb3F2dFcwTnZLUVljOVVyT0EwZHdsbnUzWDhRa29UOFFl?=
 =?utf-8?B?aWxSb1E1K3hPbzBoVFBhdDBKTk1SVmR2R1RMUUtINmRJN0xmdzB5QjliN0lR?=
 =?utf-8?B?SkxXbndVcjlQMnJYVHhCWjhQMTc4YjFaLytxK2srNFIzc3NWNWIrV1RuTDRq?=
 =?utf-8?B?dzA3eCtaK1B2a2lrUjZwSUI2RGNUS0IrR3dBQVgyOXdUUVE3VW41OGkxWmRy?=
 =?utf-8?B?WFk4cG9UaTdnTzgwYWNVVFo5TDRyNmNENHpkSVNtcThnRS8zclVZdkJIV2ty?=
 =?utf-8?B?Q2Yxbi9aSDU5YkVraTlkRmtQbTNHZjVqcEhMTnpzR2l5SGpGdmRaK0RvZTdK?=
 =?utf-8?B?NXRYSXJLNFJieVRLcGtDRU9OdXVwaVBiWkxXWlQ3NkVkT0dYS0lGTEdWRnhB?=
 =?utf-8?B?T2tCMmwyYWRDSkM2T1U0RG8xWG9OWkx5OFJMemQ2dnFyWWJXT2V6ZTFVd2xI?=
 =?utf-8?B?WkZ1MzRVNHk5RDZwWGR2djc3d1ZZMW85VHlPTHJRdnIwVWxPZzRWR012aWkv?=
 =?utf-8?B?bmVNRXdKZXpKeWdObytmdUIzbVhRaFQzNXptd2ZmNldsVnh1amN0dzVCM3RR?=
 =?utf-8?B?Q04zOHNQT1lUOGlyQ1BvbnVnQXNWMXZnK3MrUDNDK2l2VjYrcUdiS1dIZkkx?=
 =?utf-8?B?V0lzVm45TWlnelFUelhJZng3RGU1TTJ0NFhiMmJJbUR5WHBaMVB3L0huR29Y?=
 =?utf-8?B?ZlBTSW9KS0p4ZXVSLzFQeGVwTHphWUZvUjdqanpxNXVKUVFYcWk3b3RoZWxD?=
 =?utf-8?B?VFpwMEZldnd1Vk42OXRUb3YrQWU3anNUaWxNQm92YWx3TE50SUowUWVTbC8r?=
 =?utf-8?B?Sks4bzFQejdHaGpKaTV2ck9MQkZ5amVxMDRqanV4T0tJSEZoUm5uTUVsT0c5?=
 =?utf-8?B?MjV2RzdISnNldGdPelppWS9oZlV3R2JNNjhQejlxRWpLaWVJRVRDbFNHYWlH?=
 =?utf-8?B?Q3VTU0FKREF5N253bytMRENVbzFLVjdoUEg0VFpycGRvV1FMa2g2azJHYkFq?=
 =?utf-8?B?Mk9SRXVqWkkxeDExK28wdmtQaXVIWkJKSTZ4RHVKNmcyZkJnMDFMRGNLRWZP?=
 =?utf-8?B?QS9YbFVlM05LOWNZd2hEcjUwejg0R1RlT0xMVmlWallvSDdzcWZJanUvYlRW?=
 =?utf-8?B?blBYRE5nN1FDNWFMbVpvaTZ4YmN4eE1Sc3JmYzd6VjlHS01DdHlheFNMVTdu?=
 =?utf-8?B?bC95c2lwbGp4NmNCeURHd3VRVTdoN3N0NTRhTjlDUERCMVYyT1p0dm5sbzA4?=
 =?utf-8?B?d2RLeEZjMzRoVk1vWHZnU2xkU2QyWGZPRmVlU1NLYVVnZWF1NGRlNGltMGgy?=
 =?utf-8?B?cjcvMlhzVTlxUkJtTTJyVjBvSGZJLzQyZjgyOG5CUkxEOVJzZHlmTE5MbVZG?=
 =?utf-8?B?ajlOSjV5bG9XZGFXODkxQzlVWmVGY2Z0aXkyd2s1WllQTTRNS1JEeUlZWEJY?=
 =?utf-8?B?QXp3SU85eXZFZmg1ZHZuN0dDdmFBUW5qWWNuRjZSbW9pMW5Kb3BCMk1TQ2Vn?=
 =?utf-8?B?UUUweFVVQXlqQ1hlWnZCeFp5d0JOTGtRWU1MS3VDZzM5UC80Nk5INFpYaCtR?=
 =?utf-8?B?Wk1aSklrSWUxR1hFTEV6dk1pM1lWTDlpQzNXeGtwU1BXNUdjbjVRYUJnZ1RK?=
 =?utf-8?B?WlpwVExTYWZrWUxzZW9yTGJYaHR6V3Z3MmFtYUxBY0RueXFvL0ZaK3JoR05q?=
 =?utf-8?B?dXF6bzB3VXR0Y2x0V1V4VlJIRnI0NlRQY3ZVQzhoTFlJc25lY3hrbnpDSjFD?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1bb31e2-af63-4ef7-efd4-08da92611773
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 12:44:53.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKKQV0mUbakk9bVIitVdZaYNZ4cfAmL6DLdYEE2rvghWl+JldyL7qwyrjWoNt/dqNKi293tnvCgy5JpWxQWalg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5101
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/9/1 11:36, Huang, Kai wrote:
> On Thu, 2022-09-01 at 08:35 +0800, Zhiquan Li wrote:
>> In order to avoid unnecessary casting, rename the 'owner' field of
>> struct sgx_epc_page as 'encl_owner', and update all of references.
> This changelog itself doesn't explain _why_ renaming 'owner' to 'encl_owner' can
> avoid the explicit castg.  In fact, the reason is that you will use a 'union'
> to separate the use of 'owner' of the EPC page (between SGX driver and virtual
> EPC).  The rename is just to make the name more clear, but cannot really avoid
> casting.
> 
> So I think there should be more sentences to explain here, such as "in order to
> send SIGBUS to userspace hypervisor to allow it to inject #MC to guest, use
> virtual EPC page's owner to be the userspace virtual address of the EPC page",
> and after those you can say something like "in order to avoid casting, use a
> union to separate the use of owner for SGX driver EPC page and virtual EPC page.
> And rename owner of SGX driver EPC page to 'encl_owner' to be more specific",
> etc.
> 
> That being said, I guess you can just merge this patch with your second patch,
> which actually introduces the 'union' and uses the owner for virtual EPC page.
> And in changelog you explain everything above to justify the patch.
> 
> Does this make sense?
> 

Many thanks for your excellent explanation, I would like to add it into
the commit message of this patch but keep it separately.  IMHO, this
will benefit cherry-pick the subsequent patch to stable tree if it bases
on the new 'encl_owner' field but no related to this MCA fix. In such
case just cherry-pick patch 01 and the critical fix patch is enough,
patch 02 and 03 can be ignored.  What do you think?

Furthermore, I would like to add your “Acked-by” to this patch, is that
OK for you?

Thanks and Best Regards,
Zhiquan
