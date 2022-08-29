Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1AFECAAA2
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Aug 2022 01:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiH2BSR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 28 Aug 2022 21:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiH2BSP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 28 Aug 2022 21:18:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1792B240BD
        for <linux-sgx@vger.kernel.org>; Sun, 28 Aug 2022 18:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661735895; x=1693271895;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eAaW2GDvthardVsA9DYmbxkqKmDWWrrNB4W7O2NGBPM=;
  b=JLCxF1im4CC3LCxt/+Pyd8FDK3oGE1a59ihtBRzMwM4RvHJAjaSwwJ7H
   ue4bfYvmvUzn3erGejdEqGvloaxJ1cImZc+uQk1aWqcyBGAKQBMcPWrlM
   7KrJ5ku0JGbDwIAtXfmRrR9I23dW3Pa4mRG5bJK/RjxxqDcvQyYINURNT
   L1eG1YD7qLRBtrckrc0UTeaTgLaxfg2VyQTTlpZsa+T50EIuuK3SXQVRv
   mTr0//fPgC5iQy6qQrjfdMAYuK1j2+FQQED+G0ATDFquZV9gB6VqfvgeJ
   UyT0wkiLycAUd5yL2trf+ZUSWjfrl6OV0Bjaos3ggdRgJ+4gsE5yga625
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="381088424"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="381088424"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 18:18:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="614058680"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 28 Aug 2022 18:18:14 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 18:18:14 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 18:18:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 18:18:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 18:18:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbSBVJAQp08Ncp5x7USexp2eefe5rcQjFpaWC34AQHTVP98VAWpP1OO2tSYGA1KBCVnb6VOpFjM2CIJrcuvlejPFfTawIdmUOtfTbAqHy1R/ZoJG3S6VuLIXURRBAvjuABo8p8GPNAbwaXHdzIJWH+S45WJjFIf8rYtCz3ha8x/aPBTet6i4g/bMa10nuQ4e6p2kVADoj6Fno+GIxB+McDXfam0z12FCaJkDIJWYwxUd8mPBRHYIZwWgSUqnYr2AlnDFeFyWEcWHH2j4AYFlSskRTQ4/6b0hncQZVIZ1rdxv349Q9BPmC9tAdQxM1mts9FZc7aclCYIkCZsxVaruMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzre6oCuxUcgeS+NSRod7jsd49P7+Yv3Q3+v0SbYhTI=;
 b=AM1BsQI2lwskmu9M8UF7YuhY9gt94ZiMiH0vo1Kjwn3luDHFKtlqBLvKD7exwCoFOYXAKeEbk739eRTgV8Ncuify/TbYhr7BGmIc+U9p8LxZk0ORlYaw5u0MaMbGLQtS7xAURaL7gviZCxVL7Da1akJ+VUhJbvgHiNOIOYkqP36c4/1zXp+MWvNRZ6MT5yd+ZwjmLjulO7Xg7VGrMEIdCAFTcHDYrcBydmkV5vORtoa3jcRkjMPGUjfsjC8bfZZJqHyxusC4FAyJhZgayxsBdt2cFncKNR/Ui2u9c4H4LjocWdwznlY9fMkRUej49DiKFVuzpsuQvcSxoxOhA/PD2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by PH7PR11MB7099.namprd11.prod.outlook.com (2603:10b6:510:20e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.20; Mon, 29 Aug
 2022 01:18:11 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 01:18:10 +0000
Message-ID: <e95f8dcd-49db-8bfb-90aa-b8074002919d@intel.com>
Date:   Mon, 29 Aug 2022 09:23:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH RESEND v6 1/3] x86/sgx: Rename the owner field of struct
 sgx_epc_page as encl_owner
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <dave.hansen@linux.intel.com>
CC:     <linux-sgx@vger.kernel.org>, <tony.luck@intel.com>,
        <tglx@linutronix.de>, <bp@alien8.de>, <seanjc@google.com>,
        <kai.huang@intel.com>, <fan.du@intel.com>, <cathy.zhang@intel.com>
References: <20220826160503.1576966-1-zhiquan1.li@intel.com>
 <20220826160503.1576966-2-zhiquan1.li@intel.com>
 <Ywrgp+NUuB83ajkO@kernel.org>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <Ywrgp+NUuB83ajkO@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0036.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::23)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 638a42d8-9339-46db-a99a-08da895c564a
X-MS-TrafficTypeDiagnostic: PH7PR11MB7099:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLMBksBDns0QW8MPrmKhHCly4inFKF0dd2j+zmlacpmpYcU1p6s2NIkbZdLQMvCGeVfgmYYd1v3LJL0e2nWc8s+drxMAC+uUO8p3vYG8Y5v1ue2Znu1De0PqJ4Wz7/OuV3Zew/oKx2MCPwqxSvV+82Ffz+xqQQxx8eylAL1IeSn/PkM3/zZSPa8cs3khHluYGYUQdp9in2HPoKcqux1sg0ertduG6ZTlH272a4m4gal2eKqYkIk/WOYkw9+EW9skpg86wwkbDgj7vvRfQowVqL9ZhAxlZ+cLc2CJQyRn9hrCiJ0eBuEljPiaEKZqQbuV14lxVMdgw37w10PsQQDZBlt9HanXI2ccbuu1fOQxc5w4Obchp1ZV7Ru7QGTS2XEFIN8l4BY7gjjKqWU5JG9K8gGVSCOxeA4Wi4PsgwJRTXUXfgZyAjFVyrzYtoumYGYXUzR8mDA96ZjLGMeCEm+9dleK/iD2eR0CrT/Uy2UQBir0T1Q6lRDOLSkm2dC3Qu1ic2RT9r2aQUv04+Te0a09FARWk8TtHA0NmocuDXG1z4BfeOQ1ZHUpc8JXnlB1Lhrl5nRzXiOP3yusHsVVdrfoLL++R0qRM8hkns0B7HeVyodleppr1c+9TZtU1hZ96b/uht3HpLNyv5nigBfpeQV/9BPVzcIo7RKcdxARJBlggobHUX0KSm3F0zlgDVRP19a+NZ8Z87eXhAr5qxCLkfgojqob90wYxWbX4YHQM+XsVgrB/4pK5PSu/K+ulSKP2ujKoFyuNYzDnT1FTuQ9ipZDvotFv470yTZDnol75BzAKO0zIv/YSLSCtyBxFVNDwfIEWvmWKVj9/yIqgm6StHtJwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(136003)(376002)(366004)(2906002)(53546011)(86362001)(36756003)(6506007)(31696002)(6666004)(478600001)(26005)(8936002)(41300700001)(31686004)(83380400001)(82960400001)(2616005)(6486002)(186003)(966005)(6512007)(66946007)(316002)(66556008)(4326008)(66476007)(5660300002)(8676002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFQwYVlNQ2JFVHR6M21sS3ZINlJlNnA0UTJYb0ExNjdsUGNGWGMxcXF3TVo0?=
 =?utf-8?B?ZWZvcHFWWUlRaWh1cm1PVjExRWtadlJNNjlBZWdvamFNTXZSdjBML2E2c1Jy?=
 =?utf-8?B?QkFiR0ovY1VZSjFWRXpxb081dGZJMTllb3VOdnprKzduRHVJYTYxbjlEV3kz?=
 =?utf-8?B?U1NQRHVyTUhTOEtvV0E1WTZjRWhDdUU2S1ZsY0FkQmpMaEZjaDRYQ1ZtdUZX?=
 =?utf-8?B?TVhzRVZXYkhaWEw3ZVpEUmZ6eHJFdXI1ajJWWTFwNkRab0xYYWNzcEx5dkhN?=
 =?utf-8?B?MGVncVQwdjNnbXZEQkVDSTlqRmRzaFJEZ05rYjR6K2xQY29LVUdEdXpsUGJs?=
 =?utf-8?B?V0I2aXZ3R3ZUaVQvQlhlMjU3YXdkdzNKVlh6bGQ1YVVPWFdNbDQzQU16aC84?=
 =?utf-8?B?N1ovMnAwdE1maFJFSTJneURMV1REYlN3T1FSUTFIR3NoamsxRUZNalFSUnZM?=
 =?utf-8?B?V082UzJaTmI3Y0FZNnV2UFRYQmxnbFZxZktNaE90dkZpa3d2OWFzRE5QY0hF?=
 =?utf-8?B?N2MvQ2drNlNXT3hmQnQzWnBNV1VsWWVxVTVXcVFLalBITE9pWUs1S1BqOW1F?=
 =?utf-8?B?QkpSRVdXTDUrMnNKbHhoTDIvaG5JUVU5STIxU0pKVXhoZm1TcWpmYnRuZUwy?=
 =?utf-8?B?RkJEM2paNFBmTi9GL3FOSmdWdCsvZktKUG5jaTIwcTJyNktwdUFhNUcxVEw2?=
 =?utf-8?B?NDZMVG5NYS9YWDJJeUlsdFV6d283NUJhWngrbXdJYjdZdWM3dTg3cXNTN2tI?=
 =?utf-8?B?UHVMaVpkQTRra1BHWGFkWWVCWDZCak1lcm1GRjJWcTRHd2Z5aHZ0QnJJY1M0?=
 =?utf-8?B?M1lHYVBLMnkyRkxLU1Zsaitzckt0TTBvN1M5UDEzSExOYlFLZURWaXc1M2J3?=
 =?utf-8?B?VnAvUkpyMVhqSXR5UUtPb3NEaDNKYzVnK0NCQWNSd2c0NytIRnJ0NEJvbWlV?=
 =?utf-8?B?dzRVa3JEdE9pSHhKMG9rNXRxcE1YTkx5RVNoL25RZFRIeHVxSGd5U21wakU5?=
 =?utf-8?B?cDRYdEg3aTEyalZMUWJUeEhMWlpid01BQlVYV0JkU0xEUEEwbHAxS2xiV05X?=
 =?utf-8?B?SFZWYWRadHN6a0dqNHlwbmFyN0Y5S1IrWXNBVi9sNFIxY2N1R3VpZVRPaG91?=
 =?utf-8?B?T0pnM0pDNGJ4LzVCeXpwRGcxbVlVOW1BNHF5bkR2ZlV1SkM5Yk0rdlhleW5E?=
 =?utf-8?B?UTFaMDB2blpQaHJ3a1J4K0Y5ZzNIVVhVM0UzbzE5VGIyYU9EV2ZwZzFRYzlz?=
 =?utf-8?B?RGl2VHhRaUlYVEdUZElJWktHREN1R0VuN0JBRjZUdnNRcWpuTHRNdEhwc2hx?=
 =?utf-8?B?bHdzckZRTXVlVkdPaWtLZzN2NFhaUy9HbUw2WVpiSStGVHlvZ3ptSUprdTJE?=
 =?utf-8?B?N0txZjNhc0JMTjRJT3o1RjVoMkFxaEJkby81QXdBQnAxL256N0s1b20yaFZD?=
 =?utf-8?B?alNBdUxuWXFvMmNlbjNGRDdycWV4dnVaTDBQTnpTT1JHbjlTeHN5bXQ4UDlP?=
 =?utf-8?B?UDJDeW9XM1JMei9pMnJvTGZKSG5HWWRaUnBXanNFUnFmOXNDYnF5T2FtdXJu?=
 =?utf-8?B?RnBpT3J2dGtSRFhNTjFpVy9KVTBiN2x2VzhxWGgxYjdlKzlIYzZRRzJqb3p0?=
 =?utf-8?B?RlZDRXQ5cndTNWJaeURyYlNDVnJIQWJhc0poTWFKRWlwSnIyWS9RVHplRW1Z?=
 =?utf-8?B?M1JMNzhQY2VYamFOekpHYjdDM2R2Z3lIZmY3K2lPWSthbWU0UFBsZ3BtK0dU?=
 =?utf-8?B?azVVM1UwRlk3WnpuY0s0ZDNSMU9OejdPTnpQSFppM0dSWHE5QThYN0FjNG5n?=
 =?utf-8?B?ZnZGanlsWllJU0E3dnpmbFlLdFFxTU5PWFFKa2dSVmFGV1ZsMWpoRFpvSWRo?=
 =?utf-8?B?cURVMmVnS1FCM0hSeXZtMUluZy9hNCtXZExBTHZrME5keVBIZWp3M1VIQ20z?=
 =?utf-8?B?RDY5S2xDSlErZld1Y3U1d1FqZUV0aHVnY2wxZUFBQ0xET1VURDU2Yzk2eHR4?=
 =?utf-8?B?dEsvSUJEUWtKQnBNa3ZTcDdiR0tRM1pBTkJHVGFMRmI3Sm1XUDNGVU55UGhO?=
 =?utf-8?B?WHlMQWdVeExzM213LzJ3RnZURW9lVHZDWWN5Ny9oZzFhTkJjaGE2WVk1Q2hD?=
 =?utf-8?B?NmlESXpnQXdrV0xIcnpMc1lZa012aDRHeXhtbzJoVmRmSUJLWmN5dEJBUFRR?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 638a42d8-9339-46db-a99a-08da895c564a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 01:18:10.7357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bNTUVjT6RajjVlBtHkRMiMGVORuqkkxfsyR3+6Vtg22pZSQPw4HveUcLsLiXq29eWxpmhT1qKpJ49D1D4myWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7099
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/8/28 11:27, Jarkko Sakkinen wrote:
> On Sat, Aug 27, 2022 at 12:05:01AM +0800, Zhiquan Li wrote:
>> In order to describe the purpose of 'owner' field more exactly,
>> rename the 'owner' field of struct sgx_epc_page as 'encl_owner',
>> and update all of references.
>>
>> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> Is this rename really worth of doing? I'd only consider
> such if there was two 'owner' fields but since there is
> no name collision, why bother?
> 
> Thoughts? Please correct me if I've forgot something
> essential previously discussed.
> 
> BR, Jarkko
> 
> 

Hello Jarkko,

The field name and union comes from Dave's suggestion:

https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m2ff4778948cdc9ee65f09672f1d02f8dc467247b

- If the rename make the thing complicated we can consider drop this patch, it might introduce potential conflict with the SGX patches under reviewing.
- If you think the union introduced by patch 02 is also unnecessary, then we need to discuss it with Dave.

Best Regards,
Zhiquan
