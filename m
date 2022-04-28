Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC8CC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 22:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiD1WYJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 18:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352891AbiD1WYE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 18:24:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AE66C948
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 15:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651184448; x=1682720448;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jyjtHGp4gSmNkAlpE8naAg2T3+jVRg0mEeK/Wlge5eE=;
  b=hPseCL10WQN/3O7CSfspXMTXQqSWQqahXwZsE9Cggljt1bKHegtNCZqc
   q9g/pxsleZ3uWzlUtVjmygGDZHAshgo7n5oweYYmvd27hm7pVW1XT/irp
   zWrtc8DqB7E5LEZBxLXzhy3uyx8Efut0lpQK6y7cRD7R09EUaDgumO97L
   8AQv2HWHVUfjI71kkqTzdFP4r22Y6JUSkOUA1djSucdWS2aNbWaDke9R9
   bE4h6StTsYE3vqc4pCmMpGP8i8wsNAbDU65GHkbzqa3Cr5q8foSbeeYIh
   WIRj+6GQL8r3h8fQ4f7qbMbHnRjuyOoYwOmVQFC9w1ytr6ZXhveLba9iw
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246358852"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="246358852"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:20:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="683396744"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 28 Apr 2022 15:20:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 15:20:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 15:20:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 28 Apr 2022 15:20:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 28 Apr 2022 15:20:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZy8Rx+6YrGRyzzHYfd2cdUzvmpHOXf/UUdfeep2IYK9Wc39J8KvR+xQqxiC8yn27vvqFXlNbWrYiX4e/YmIwFvT2WNKzTQItEgoh8C0ackrW39yto/NBtCMLQUOcUuwTGEArYGpdXbVNH5qqvevgHActoGj1crDvLu14nQ5NQVWMOPLHltydWeVAwc2zqerkfnFiNpt0lc3TbySrC8729KZ/zFhkI96BiyI44ijsIkcEh+CvE304GgAr0L4w84j3BkM8NUCfR2uSsc4EeS1s2kGUR3T97IX0M3oWwthsL3HcAK1U5Dm0fXt8VWgRk76gnSxn4/tl35v8hgH0JdYYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVmyNw/Hc573DvWUeItk/nDu8cTJmQ7LPiO8IheTZEk=;
 b=nch0xJaFDSR2uG3aHKPFOSOR7BBF8cR5hlhv52rzMC0HbgX84ZXjX9GEcldWCgTkdK0Na8WwMHFHAqiChzWTqbcSQlG6EncHTMvszz4WMJuxYu1AYhecWtxw+zOLIDCY3ZxnzKNM/nm3UopVaE4PVziMTMsMfWKIepsihFBW98HL08K1YwigfMXOGKCUpZta213tIxk6yT/2fCsA25D+u+f9m+B4H6DSzBjdDMwqzNBSD0Cai2hPvQM8wCESxiiCizrNks1JjjBO3SyGqP8sYMYOol/7TUu31VLRvG4G92LvmTiaOaSt4rwMhBZ0nGVaPNr3WnQqoeymtEtQ/3+v4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by SJ1PR11MB6228.namprd11.prod.outlook.com (2603:10b6:a03:459::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 22:20:45 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 22:20:45 +0000
Message-ID: <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
Date:   Thu, 28 Apr 2022 15:20:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
 <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0223.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::18) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac4bbcbd-3f1e-4c67-2b23-08da296556a3
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6228:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <SJ1PR11MB6228EDF5AE32C241BDC6F960F8FD9@SJ1PR11MB6228.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +c2iKLjIDg2FTd2Zjy5S4IfJ1TVh1nqh2NBsPVqsLWAegggFb6xe/QdL0SNqj3/zzT51ICPJ/YO6kxoin5IOqeBnsMqXRdJZoXtpoUS15HR+iHvxBiD7sn3ISib1CFOjtDtomGsngamw2HgKPtsuk78Lfdph36gsZ95zPM4FXwUTp5rVl7N4tzcFt4LcoZZ0fdcUV6t+4hocCeeF5W9YZ0GGnaAivEz4tTqUPfldTi1+H29yIjOWFcpoFkosD4BZq+aLGmK7/5K7ihvm59CEZLnpIcSgIlSc5oQyhmDHFyGdoejzouc03/FGSmK7VE+mnRNY74QyxcjOyVWuSTP0RD/bBOKLfKIEGMnqtfrDU43Uf1UYedcjc9Ba3grxJq/fT/HJytZmsYK73lrtRMbDs3ubGhz02UeTZkRWB9ORylnH6dtJApcom722/SMXovD+Orlgi74hfZionQ0Yo2ILG58SjcvHnRztup/uJMOfD2VeTbwUo4MeCeoDZ5DsMlqpEmfl52r09NSCPEwrR4s9zh0dwvd3+XpNFsFCwH7VHGE+IXgYG8dxUjSuNgYeNcYhFvFhI27f3yXDdjbN+1EzMY/lBfLKXWQtaJoOC4zmgW3ZIPVyCi0/loemSew6oek/nV652F4fzewyE9HPJI27a0klo00T4n/FGMY/mRW5XItkPXlcU+0zCrvhr+bghin/NQIFmAxn+wI6oOtGk1/vXt5nZBG5wMZC277DvRpYeTM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(82960400001)(53546011)(31696002)(66476007)(66556008)(2616005)(8676002)(66946007)(4326008)(508600001)(86362001)(316002)(83380400001)(186003)(38100700002)(26005)(6512007)(6506007)(36756003)(6666004)(31686004)(44832011)(5660300002)(8936002)(2906002)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjJwRkdQcEdZMnQ1bWVKS3ZDVXhWZTdvblRIa29lZUVyUlhhbFl4MG1RV3dn?=
 =?utf-8?B?MUQ0bzNFellnbi9zVjN0NnlsZG91Ky9ZZHB4c2tTMng3SEplSXVWR1VVanpQ?=
 =?utf-8?B?NS9xRGp6KzdxN1czbUswK3BvQzlTOW5WcFB4M0ZTbE1uUkFaR2tIRXo0K1Rq?=
 =?utf-8?B?M2F4VktPb3A4Z1ExNHNMc09VbUhtOGdCUVJVc0t2bnFvMW9BODVjYXRkOHd4?=
 =?utf-8?B?NGU1amJYYmU3WGRYVlpubFpGbDN6T3BwQkNRQytuY01JS1ZwelJndVJIUVFh?=
 =?utf-8?B?anppSFRyckpNOVhidGtFbEYyUGcxS2ZEL2UveU0xY0RJL2dzZUpoZ1FBVHZD?=
 =?utf-8?B?YmNOY3FKZUVJZkR3Uy9DclgySGdTSmNLY1JVZzQ2ck8zN2hEekV2ZmRTTC9C?=
 =?utf-8?B?Ukw0NGZIV2V4eVYyNzJZQmpmVHorUkc1aVZ6Nm1weFR6dldGMFZycEJaTDBO?=
 =?utf-8?B?Kzk4UDRrSmNtTDFwTk1xbFlnd0V6eXhrRStiakFENGU4Rks3TFRzMWRVQUtJ?=
 =?utf-8?B?eHRGaytuVklBU3FXZStYY3Z5MGIvam4rVUM5NnE4V1h1QjhYNnJ1bkJBY1hM?=
 =?utf-8?B?bG1STUZtTU1YNDBXZ1BsS3B5bk5DVGNONUQvRjNOcE5LTWkyV2R2Y2QxVmht?=
 =?utf-8?B?eFFOSXVHKzZQeGNGRzJJalBrVkE3ZUtYMGVBd3lLdCtPbk5QdGtHV043QkpR?=
 =?utf-8?B?SGk4d01TaC9VZ1R5c1ZKcWVIOVRXYkxzZk9kUXN3Y0RwWWFuSkpMUjd5NlFr?=
 =?utf-8?B?b1BrUURnNi9kSmJ3THVqSyt5KzQ0dGdDS1pQcmE2OWtQM3RaUEFiWmJTMjJR?=
 =?utf-8?B?K09XQyt0MnpxNkVUd2xKeEFybWh2R3VlbmtZOUdmSjgzZm1EaDVBRnhvcGlU?=
 =?utf-8?B?YkZURHhwM3RVRS9GSTFuQUxUeXdaY3JjWjB5UHZlZUdFeFVpUHBSRk1iNUxE?=
 =?utf-8?B?OTRxU05wTHVGRXFKbzBnekNRR1FucGNMV21PVHRqNld2VXNNY29yMWxyQ3pG?=
 =?utf-8?B?bTVia0JtQm9pR3VJejJ4enNnZGJRclJXWnNLUDBjbUJTUTFreGNheVczVVBC?=
 =?utf-8?B?RHErdXJYbjhOUDA1eTlNcXphV0RPRTl2MWZPY0ZLTmtjQ3NVTTBlNm1IQnJY?=
 =?utf-8?B?cXkwRnlRSHo4NWxRMkVMOVp6SGE3eHpwU2hWd1pETWJHMFliVzllN3JKQ0FZ?=
 =?utf-8?B?NUhzUW5EOXpkeGM0YTMvbGtwb1NBdHF4UEM1UlNIMnZBNXFwWU44OElYSFJn?=
 =?utf-8?B?WWQ0K3RQVUxpeVFCWlgxaFp5WXpHWmRKZXpzdnRnRjVWeU05WlVvWGpLTktm?=
 =?utf-8?B?K0xMRUYxQXpSVi9Ha29kZVpVQmlZclorRnVSc2F4NllGRThFNGRaQytYNldY?=
 =?utf-8?B?RnNtRWw0T2d4U2lBM0IxRllIQnYxVWp2bFdFYWxBU1dremFmODkrOGxnb0RU?=
 =?utf-8?B?aWlCNndkVWQzNUVseThOZ21DVjZxOGRSOVREbENZN3NXNWE0T08rQlNZcnhF?=
 =?utf-8?B?eXBTTitTcnFjRTFMRTdia0pJQ3R4Uis2d05vaWN5NHdzSDM0UTlhTFRsS25L?=
 =?utf-8?B?cTdZNjBic2VrWjltRVFndnVEenpJVDlhOC9EQmYycXhCZ2EyaThhcWc2RG9v?=
 =?utf-8?B?SmU3b3I4Mk1tNjdybXVUZlN2TXU5V1EwQTgxSWxLNVFrbENDeTdHR0RocFFU?=
 =?utf-8?B?WUdiZE1PTi9zVFp1Q1VTZWs4bmZ4dVZ6SWVoNWdWRE51NnJBT3FSVE9ubmtm?=
 =?utf-8?B?cnV0VGVvOGtmQnJGa2xPcFdjMXZlK05ISFpXSFc0a29QYTVHQUlISk51QlRo?=
 =?utf-8?B?Mko2emg5MG5QM2M4K2tNOTRrQmJQWVNYTC9VSmR3MGJKcW1vMncvc3RqVnYr?=
 =?utf-8?B?d1Jjck44UWxjeGdVSkhMd0dZbzRBMnpOUFpQaFBESWxOUGtXZHdVZzhMWVFR?=
 =?utf-8?B?TkU5dWxPaU12Q2J1bmhvYklyalVkUDVqd2QyNTIwMEtCT3Q0elg2blV6SUJO?=
 =?utf-8?B?c3daMm8xVkVwWmZZRlpVWUlUdlp0UmRHQWxsRGl6QXRFb2ZhSFZQVzIwOFBt?=
 =?utf-8?B?OVBUK1hOTlByS0xpZTk1SHZLVS8xbU9DQnJrVWk4M2lvbVZLUlpBV0RNM3lK?=
 =?utf-8?B?OFFuOTdWa3YrdndCdVRNei9hWHpmUXFYSjZxckRYSGI1akY0ZEc3SGV5M2w1?=
 =?utf-8?B?ODd5Rlhack4vRG92TW5HUUNLYytDQU9PUDNKQmgwYXdVM2tPZHR5cWJDNzVi?=
 =?utf-8?B?ckVrb241S09oOW5RcFRwVGhvRHlNcTFBY00zV1N4Q1ZwSitka0JNS1d2NnBr?=
 =?utf-8?B?TWRaY1B4SzlOWE16b2dqbUFTbGxpbWQ3aFk0aVhNa0ZjN3BiUUMyTFo1VkVL?=
 =?utf-8?Q?qVExWBzHZr2OPYPU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac4bbcbd-3f1e-4c67-2b23-08da296556a3
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 22:20:44.9915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zANium9p1GB5IL9CdamIYmQs9nAZ5ewAoL9ocjzNePzyZ9i/DTnaliyBw0dcQQrTq6IIKvuWpmNTIQLcx89rBzkDzvF/tUIkqynazKBpfQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6228
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 4/28/2022 2:30 PM, Dave Hansen wrote:
> On 4/28/22 13:11, Reinette Chatre wrote:

> Are there any transient, recoverable errors that can come back from
> ELDU?  If so, this makes a lot of sense.  If not, then it doesn't make a
> lot of sense to preserve the swapped-out content because they enclave is
> going to die anyway.

Good point.

Theoretically ELDU could encounter a page fault while accessing the 
regions it needs to read from and write to. These faults are passed
through and the instruction would return with a #PF that is
propagated with the page fault handler returning SIGBUS.

Even so, this flow also impacts the SGX2 flows that need to load pages from
the backing store. In this case the kernel would pass it as an error
(-EFAULT) to the runtime but it would not result in the
enclave being killed. If it was a #PF that caused the issue then
perhaps theoretically the SGX2 instruction has a chance of succeeding
if the runtime attempts it again? 

Reinette

