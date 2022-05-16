Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A529C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 May 2022 00:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbiEPA67 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 15 May 2022 20:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiEPA66 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 15 May 2022 20:58:58 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC15657A
        for <linux-sgx@vger.kernel.org>; Sun, 15 May 2022 17:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652662737; x=1684198737;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uG8OIMzbOpIx0dE0UpqU85D1kPMEui+lh28JyOfo1Kk=;
  b=WbDRNYgNLDdbMJnpvaWuQ7RLtZyCV+j2J6n9YuFuflgx44Ubk4RQSS27
   9t59H5sk8JP/ljV7GcDJsRl7fs10Qx0wQ22se484eDydzcXSRlqR8QhYH
   I7Iht37DvXCRcGg5jst9tlwekLw44fTXQe9sI3WiqBSyloh6tXhUpVm86
   ZvdIUBHC5r3D6wuWo/j8tBz+LGUWG4bY2AqiseCzDIbqaqMw1Lu8f018K
   SdTBj0RHKHnXmR85qU5vYAkxKnBmp+OS1Mc/o7802BmXtdQvYuiy6LgGW
   7aDX5SRNhmmX36b8ES8HRmVrFWZWQw8e87EKH+N97YLQOj+QO/48FZRwA
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="251211817"
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="251211817"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2022 17:58:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="816169895"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga006.fm.intel.com with ESMTP; 15 May 2022 17:58:56 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 15 May 2022 17:58:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 15 May 2022 17:58:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 15 May 2022 17:58:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeaRp5FW+swpi40CXvtXeN6QzoHS1Mv804e2gTqPtuTBwot8/V2QOjnY7+5FY0lvfYwDxipINw2z6jCQzLhRd3RuZA3DoIdTwka8FHeuaulrg5REAwf5PsByWzuZJvfdMagfPImsrWv8MNMrllg8OlCgry05cIgKYcg1Xs1Hy9GTPxzVUlrHlhKSsHQvf5Q3ySzm6qlhD9hyGsZZS9ZjPnihZ4O68DDUzweWlrQoWEX7RTGrA2TM0NVjxsnfZtonFXmUvJEVCbDdj+9MTvREdNRMZ3neZpncysK8zTS5Rqq5FQBEa6O6vPwT0qgzQy2+jJXo7KwEbg93GDhNEdOsPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUGuVpH+1Zrn+757Fre97GKgeBvTiqU8Zf7VRpmZAVU=;
 b=ngzLXd6qFG89r84cK4eosndX5bnLr38nFeBaMqbrOy9HZnBcF4CnQWOOC1n44cvGf2Bo3JxntcGmzkyg/RB64+ipWKBvDKM5na2IExFxwMpBdt1eHJRxS/0UxyKJVcuVP9mCwvpskXdTL++CiqSgeyDrxlnPywWWBJgc8/d0I/o1sMosQ8ByxBZFiAiP7L10Zoe/k4ELSQv2jqnEgnsbp6SyKkNud5IHCYCsMg3ODRdj9jmWjm9U8ErmaL+5oxI9GWLUzzXvUb0mbVVqJ1LaB+DnutAjtGVZ3f7gDk6K+nQfpPNxhK3WblidT5NLz7FS+6iDv34MZt1EEUcgmm8b8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by DM4PR11MB5375.namprd11.prod.outlook.com (2603:10b6:5:396::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 00:58:54 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 00:58:54 +0000
Message-ID: <b5232de5-d3c4-892a-12af-983c3dc4c9ae@intel.com>
Date:   Mon, 16 May 2022 08:57:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Content-Language: en-US
To:     "Luck, Tony" <tony.luck@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Du, Fan" <fan.du@intel.com>, <zhiquan1.li@intel.com>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
 <YnuQJaM0p7gD5qel@kernel.org>
 <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com> <Yn5tPS0aLXBgHtYT@iki.fi>
 <55ffd9475f5d46f68dd06c4323bec871@intel.com>
 <35284def-ca7f-d42b-164f-1c49eb8977ee@intel.com>
 <5b6ad3e2af614caf9b41092797ffcd86@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <5b6ad3e2af614caf9b41092797ffcd86@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR06CA0001.apcprd06.prod.outlook.com
 (2603:1096:202:2e::13) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2fc3e54-5de7-4f1e-220b-08da36d73f5e
X-MS-TrafficTypeDiagnostic: DM4PR11MB5375:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM4PR11MB5375C0CE94CF0E669808E8CDA5CF9@DM4PR11MB5375.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99CeA4NcXGnbIAp2XwsLZOu0DvUUZCJCUZjUELW/+InSzw9Amnp4GGjywkbQu/1V75r5b8Xqto/BcJ8jQBhQUMEvQlBwrCUlARupa3eag3IVch7goQJ4bg/fDegk93SmXav2sA3Y/NBdN7Yc9FlLZcXWg8UhtqUacEz3xteJHqufeykVZhTloINOPIBG+ZSJZHpy3Q3mGA+y35FoJx8PdR0XPSxpuWTc900rFUFFaegTAtwOAVyE3LN7y+cvS2VpgKt9Eax+IjiBKwUZzlAETO/vV2WjY3/Xy4QwAIanF8w7jtak5Enx2fTjm5b4M6UPj4My1Zd/fqT5Pw4EBeWxTI/qnbbFMsI3v++ZX8TLi0UBuaawuTBVFT0zg8hiuObStgjuHgQVVWTJ/RpYdr3uvQDLbMRTynBnKTXGdBTZZwxDChFQXcnE0qyObVObL3p5sqk9YTuqlBdbDpViVfNQawRueeISwTMvKPnIt8Bh4Dpm7CFrJzXyuXahS2SBCfbnml+M041gKmS/HikZyi/cbeSLepuQIw2ZMZRmDJ0g3RwOc1ekYw7Qt4qF9HFZ7LSkGwsOgWDjVE9B80hWoXWtZ3IU7jCnTQ+NOt+qJkor+7FjcvqHHAnAontseB6bCTLPQZ3c1FGh6oihr4T15ZNIpg6Wiw2XtE88pvxlZdO3tRFKEflW7/LYqWSSObBz6RINrUHsUoATdcKmf3KLooskLwYJlkT2gkJPE3eaZvaPM78=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(26005)(8676002)(66476007)(86362001)(4326008)(31696002)(66946007)(8936002)(53546011)(508600001)(5660300002)(4744005)(6506007)(38100700002)(82960400001)(6486002)(2906002)(31686004)(110136005)(2616005)(6512007)(6666004)(316002)(83380400001)(36756003)(54906003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2hTREFRbGV3cHpYMzJTdTZ4dXpjODBVSWcrWG5sVG5LK0dkUm5OblB2cStJ?=
 =?utf-8?B?M0NsN29RM3BXVjZ1Y1luemJra25RV3dzN0QrOHBUaytDY0JHakw3ZTUvbzFO?=
 =?utf-8?B?V2tyQjRXK1QySDAvVmgrYmU3Z1RDbTNOY2hiS3pTUEl5bG1NZ1FFZnM5TzlY?=
 =?utf-8?B?bXRPVk0wUkIraU41VWFKNGIreFdkVk80RWZmRTIvcVdpclhwQkVMcUNraWJB?=
 =?utf-8?B?RWFrMm5ZOEt6cWIrY3NwSUNDbVlGamdMVGpYendsVUt2R1liNnZsYk1xSkFL?=
 =?utf-8?B?Y0R0TS82VDFpWnV4b3pPSW1mZmxtQmliaXlMN1huUEV0aXpkTno3RlI2UUJt?=
 =?utf-8?B?QjRGRFZXMWYxTS9ETVJ1S3N6S3J0LzVTU2o5KzR1bTkwSm1ibWd1TWUwS094?=
 =?utf-8?B?eTYzYm1nTDduU3BmRnAydk10VnMxV2pHalYya0tKNDFRR1ZEekFsbmRJUEg2?=
 =?utf-8?B?eDVBTGtTOWpUVVB0aG92NEJMWWRheEZGWjFkY1ZQWG1qZjc3VUJPNWdNVGUz?=
 =?utf-8?B?WVhyWmRqY0RPQnA3UXc0dFhoYnRLOTNKanRmbkk3eXdRNjBsbmRKazVZeTQx?=
 =?utf-8?B?c05adlFPUml5V2FFd1RwcnVkS1JuZmdQczNiMHRjc3Z2aXlVUVFnZm9leTRi?=
 =?utf-8?B?SGRLN3c4bTg3QXNrSGFPaFlqUTNFZndFMjFFTjEzb1d4Z1E0b0hibkZ2b2FB?=
 =?utf-8?B?OU9nNmpNWmxEZFAxSExidms4NFhkakhxN01EOVdncSttVzhXSnh5VUhzdHU5?=
 =?utf-8?B?UkZkdm9VMGtHMXl1ZnE0ek0rQjRFZWVCL3VON21CKzY4aHY5ZGZnMDAxU2xT?=
 =?utf-8?B?eXNld3BYcmo4WExYTitwUkU2R2YzUU94L3lVSzBNbTVCWWlnYkp2OHZPTTlM?=
 =?utf-8?B?cGVWSldDR0p4L1BtL1pvWXhMZHJwZzJZVDFoVzR2V0trcU0ra043SGx1ejEw?=
 =?utf-8?B?KzA2YlA3K2N3ZEJVT3plWWI1d0lRenpDd2o5bjZYa0hnOVRoQnorR1lxZzdL?=
 =?utf-8?B?cW5ib0trY0x3Y2dtTmJmSDVXbVFuOEgzZVYwZG9MdS9OVXhVY2V3MC9NZmVF?=
 =?utf-8?B?MlFJMm5oanRXVXQvUkRXMUxMSnRLZURDRk1ZUERtNGlwOGs0eHVGMkZXTnNq?=
 =?utf-8?B?aXNkYVpGUVpPT25VeE5YTDZQbjVrS2kvOHN2U0Z1VFJnbTRGdWNoSGI1RXI3?=
 =?utf-8?B?MEJoK2xNcXlkdiszdXlVeGMwdWFDSndKcjVDZkkwLzJBTUE5aWcrcFFQbWl2?=
 =?utf-8?B?R0p2TGRkTFY3bFVTYk5QZjZlcHBHano3SWY0VTV3bW5lN2Z6TmpNTFhENm5Q?=
 =?utf-8?B?ajUrbnZzTlhvL1ZxMmZqL3IrQmhsdFRFUDM1dUNYVVZtL2UyWFo1c3RYc09I?=
 =?utf-8?B?YmVaNFFKKzNSN2toTVBnZkR4UE85bWU0NkszSUIwbm5nT3dxbXBqSzUreWJB?=
 =?utf-8?B?R1pZdElod0I2U0dnSm54MDJIczdHd2xxd3RieTZVWkYyZnZlcXJjK1VjaUd0?=
 =?utf-8?B?eE5sNHpKb0xHbENVSFpxM2xGSENaWkdIM2hrWjVEdVRHdWZMZnNLb2x2a2Rk?=
 =?utf-8?B?ck1tV2tyaVJ1THBDbEIrWFRKUkRvUldzMmRqc3Rjc1I0YVpVaHlnb1c3N2pU?=
 =?utf-8?B?NCtib2w5WXhpL0Q1WXovR0xRaUxIeVh6eVdFRW5iNGRVN3lZQnBHd25NcG5l?=
 =?utf-8?B?blBVcnhoRm0ySzE1OU1vUk5LQTIwWFhtUnRwZkRUcm9JU3I0MWRQSTF0eTZZ?=
 =?utf-8?B?ZFlsdlRpa09PTng3ZnlsVVUvbjJSa2pORWYycllnVkNyd3pOWXlXSHE5c1JS?=
 =?utf-8?B?V29aZXRGZUUreWVPbVRyTE1lSENZTHRiMXRsVjNwUFNBeXV2Q3lteXZUOXFj?=
 =?utf-8?B?TmJDMFFpUldjVTAwRUc5UGJ0UDBmV1FWdHNjVGpsQndBOU5QeHoyZHloR280?=
 =?utf-8?B?QnVRZmZNaTBFNDNPVHB3QlZBZEpmVkViU3dGc2tPZUdSeDJXL2ZkUk9rWVc1?=
 =?utf-8?B?N1hoOUlka1FsMXU3UEtSUy9YUkh1ZEU2NDFJcUJmejZwSkJvOGlrRmJFUVZF?=
 =?utf-8?B?Q29mOS9kZ0VRZ3hXWlk5WUNDVWM5bWh4OTRmYmszbGpmYkVybHhTME0zd0pq?=
 =?utf-8?B?SEc5S0doRWNEek9WbzdZTWRqcFJxUEhOdHE2R3FuM1hjUHZ3T1FPVlM0TUNN?=
 =?utf-8?B?Ky9BODJXVG5LTlF4bXg2SzM2ZElSSVdPZG1nejZBNlJUZTAxNDRJSHdHTHMx?=
 =?utf-8?B?bCtuUTBTanVtMllOSXQ1dWpFcmpEUGtMbjkrZ3hhcGtoQTIrZm1QVVl6eTFG?=
 =?utf-8?B?aW12VnFrbEZINGFBdlRlQlYwSGsvMEE3SXlZazJzRi8ybFNtOTA4bVk5a2k1?=
 =?utf-8?Q?UsVlsp1VkNjKNktM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2fc3e54-5de7-4f1e-220b-08da36d73f5e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 00:58:53.9254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWS4F+6DZp1FwvZbobMC8B4TPTZeOqfWXIHK3ppW+RlD8yWn8tX3CLy2TnN2X1VONjTiBPe9apArrmLsQDCXZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5375
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/5/15 11:35, Luck, Tony wrote:
>> Any machine check exception (#MC) that occurs after Intel SGX is first enables
>> causes Intel SGX to be disabled, (CPUID.SGX_Leaf.0:EAX[SGX1] == 0). It cannot be
>> enabled until after the next reset. "
> 
> That part is out of date. A machine check used to disable SGX system-wide. It now just
> disables the enclave that triggered the machine check.
> 
> Is that text still in the latest SDM (version 077, April 2022)?

Yes, I've double checked it, version 077, Apr. 2022.
Looks like SDM needs to follow up :-)

Best Regards,
Zhiquan

> 
> -Tony
