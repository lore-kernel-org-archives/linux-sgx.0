Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52134C433F5
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Oct 2022 15:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiJDPWS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Oct 2022 11:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJDPWI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 4 Oct 2022 11:22:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BF85FDD9
        for <linux-sgx@vger.kernel.org>; Tue,  4 Oct 2022 08:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664896924; x=1696432924;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/Be7ymu7RLsFj6WLAqnbh9luJaEvcQ6msOBgI5N3LsE=;
  b=mbrg+1/9Rr1Xp+UWFka6CryW9+0BRFCc1EQol1bjmCH8KoExYbYbFnu0
   WYdFwvI1U2OWe9pSFjKFBietk9flEWcVpLVYpKa122FvuZWnFeSoaAZ3q
   K6C/NVRn379wFXdHsuIyT8XgQKIhFv8pbX6WiJtdBHsGnWClJVX3ARxsS
   gRBe4Ai8JTqtPeWCPgcsk3ClKvbb2KETG6OS22x8SrK4g9qAMqiQ2KGmd
   u/WwPcV2Chv33Bm1WscsE6bBvnlaOa+vZhpiJitPcvdmLVXydkiGqZA4b
   mu1qrT7vxHjIjg7qjWOChueNeUC9zGUnjSOdBwLIUzSHQRURZ87oY6Ica
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="282648553"
X-IronPort-AV: E=Sophos;i="5.95,158,1661842800"; 
   d="scan'208";a="282648553"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 08:22:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="623966424"
X-IronPort-AV: E=Sophos;i="5.95,158,1661842800"; 
   d="scan'208";a="623966424"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 04 Oct 2022 08:22:02 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 4 Oct 2022 08:22:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 4 Oct 2022 08:22:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 4 Oct 2022 08:22:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 4 Oct 2022 08:22:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZ1jcf7YTE8EEjlQjMC2kv6nZGuhnNz7MFiFjnF0K5yxQy4DWcBxl7UmFJKxJpq3WiDHipIwn47t+dtEykkARzyYVIDQbYvTqEIU7XH82HedMNtdkbzT6I1TOjjCkr3yzqn+Uh3s9vx6cDezkBHbJaQIehPPKHE5PcGTNA0MUgZWDJ62b8W2h0ks0fH/NK+JzWYooE4aPJ4lpBDMI4tIu09zRQViGlcWVq55yCWKMTeR/BM6Sq6Y1khfwEn/d+MrTCbkGIwVsA+oqaL/fPGkYo0aSnjRMYjLnh29S9arvdRD5sxUgoLL4LNozwz+EIsLLNt+MMlxWxIH6ZGsJ9PQjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pj+aJwlpb9tCLGfyfZ6qXIHXmzRarbPmehdYMgmNIp0=;
 b=AYZFxQO8aOmgxEJOyX7is+BoRZPR44Vac8br/HEkk1S1Uagys/V+yFTpz7djSIbzlilRFc8HMUpPR2Aog74zRVcWd2AcVNLwvnckz47oAbWk76bytj9vWd7wQuBV2xJhEgzGnlJXrlNFCLu8zm1suAuQ6J2Au18cJpiRRIY3gMxIiOcus5IJ7umpVzg03e7Z5usZylLhpqrAHNrrHDLio+yKPHBrVy9pI9aDMlRoagX+uYH5m8Cf6Nny4toiX9hVFqBGQpNzEhCU2UQh0RrXZuzuPDWawj/7GQf++wKk8fCIpW/ECpzoaX962Jnj2755MZNkHeuIbghEhpdVCOxfJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by DS7PR11MB6062.namprd11.prod.outlook.com (2603:10b6:8:75::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.31; Tue, 4 Oct
 2022 15:21:59 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::207e:ab0b:9e29:6a4b]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::207e:ab0b:9e29:6a4b%12]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 15:21:59 +0000
Message-ID: <c9e0dd37-994a-be56-195e-dbee408e9666@intel.com>
Date:   Tue, 4 Oct 2022 08:21:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.1
Subject: Re: sgx_validate_offset_length bug
Content-Language: en-US
To:     Borys <borysp@invisiblethingslab.com>, <jarkko@kernel.org>,
        <dave.hansen@linux.intel.com>, <linux-sgx@vger.kernel.org>
CC:     <mkow@invisiblethingslab.com>
References: <9e1e61cf-39d9-8039-b2e4-f0a3804fe493@invisiblethingslab.com>
 <956f6af2-e0cb-72c0-abf8-e2e00067851c@intel.com>
 <5b3bc4ce-bdfa-285e-79e0-77a85616e637@intel.com>
 <703f49cb-7edd-9ac5-4202-0e799e1a98a4@invisiblethingslab.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <703f49cb-7edd-9ac5-4202-0e799e1a98a4@invisiblethingslab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::8) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|DS7PR11MB6062:EE_
X-MS-Office365-Filtering-Correlation-Id: 01909ee7-1f7c-4f3c-5a85-08daa61c2e12
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 10c3up62bYbDUpMCDP6GhZ24T1U9mcOJQqdG+nt6MFGo7+BzFFmaTLI6V/dNXauvhkAV3TnX7wGBhwZnxSS+Fb+w3ar4jorKFiDQBcfMEooddvWIs9EZqzNHlj3Ey5J3DTOvGvnD05VIenU18d9yvYenJYbPzCyonIk4NNK24r/ocUmsLUFUpmy1FQ/mPTbOsB0glZfroZECHbloNfmcSPae5XcbknYqzOPicD/bedE3JpMv0/+cdv0rl2bN1ooSwFyV4Ap1t+g7A1hk3cYZZ5kJi1LA2l0jkYG8l8JEBp88uJeuJ90/MEtNoVGvrj+LpXhiB5zm9Us/ehmb+tVAdHuWWtfRUPV8DvVLQuGXQWEqTwZKmb0dFlWwTz7dfjJ0aeg4id1e4XfMTcTCkqjR7KBnTrzTs5XLgH/3L9GJdgTAbTKTBfgOB/esXVCo8MOqWQ/AvCefUi5Pqr+mH8zkiLg9+7uKKmT9g1oqEt6asS54pZWlKMXcF2b0GAiprLe7NqjNJhyoyjLJdwoQ/PXTjryNHXRu4QJAN79iVmElHdDe24EOWWzBS3EbfdAkzo8fE6v4Z+/jjEXdB8UiPcXfpXBv0NOxB48Iy8YIdqTzjSWeW4+yptv1o/WNEAdRjHipJLZ9ocSHqjJA/r3AB/kdAiLiaPrUTm8EbFUc4MU8vj2ORFbmaiPfsEh+KJYVSE3tlB131Li4u4fAGJftJ8wcOIiTj/ZDixQrA1UB/m21eZ3QDlydP7YBP/BvvrLRdPXP5cqoI2o3X+pWp3u5n58QXYnyYNV7EC7QTfLh00IJ/Vo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199015)(66556008)(36756003)(66476007)(66946007)(4326008)(8676002)(316002)(2616005)(186003)(31696002)(83380400001)(86362001)(478600001)(38100700002)(82960400001)(6486002)(26005)(6512007)(53546011)(6506007)(6666004)(31686004)(8936002)(5660300002)(44832011)(41300700001)(2906002)(7116003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHlnZ0kwNDYxN3EvTjZORnQzMEZkazF0TnJNajNLVlhucStua3QzRHBtelpB?=
 =?utf-8?B?MFZWVGJ5RW43OEgzTVRMc3ZsMDhqQ2FYcGFxVzNQbW90d0VtUElXbVE2dVpn?=
 =?utf-8?B?VTBIb0FmeHpVQ0E3bVVrZ2IrV0tNVXlnYlZYa0RqbEE5SFQ1YWJHRkh6VlN0?=
 =?utf-8?B?Zk1qWGJoNXREOU1pcng3QTR1QUVtcTd4Tkt5SEt4eHkzdjJDWHBockxxWTdO?=
 =?utf-8?B?WG9mbXN3ajZWai9DVnlydFBjTDEwb2paOGFGMElQaDZ2QjNvM2ZDaUtqekxM?=
 =?utf-8?B?TTJrNm1lRWljNnhPTkZkbmk1czdtWWl5VnJYNWpRTmR5WUovWDQ1cTlSY1dY?=
 =?utf-8?B?WHdSS29sWXRnWmtLeU15T3dDbncrZGduK0VnQ0ZpUUJRWHpiODJMWExEc3V2?=
 =?utf-8?B?SDF2QWpkZHdzY0VKZUdxSFgvdHpwVHFpeWw0L0lISGhhM0hyNlFzNEtCWDZZ?=
 =?utf-8?B?NnRDTE1kRFJmT2ZZSjVwS01YM0VXU2RRRDF2MTE2a2hzOXpxekhQOWlIUjdD?=
 =?utf-8?B?V2J6b3h0SWM3OGgvaXZZaTZkVG1mdXRuN1MyWnRscUYySkZGNW12LzlFODF4?=
 =?utf-8?B?bktNZEZhVGM3M2dBY1lETUpRWWp1bWwxVUt4UWpyblNnd1JSb0JEV1gvWGtn?=
 =?utf-8?B?dWcxem9yRkhUWjA1OFgxOEEvb3Fic2c1Z1RmRHpON2VyR3Eza0FaV0FvMHUx?=
 =?utf-8?B?ZU9KRHNsK05UMnpjKytySzN1UDVjaHkxeWFTL0hWeGROTWprK0FNdFQ1VHFK?=
 =?utf-8?B?cUZyczlSc0Mwa3hxVXljdDVpa1BxQkYxUmN0ZDdpOFE4clViUHlBaUVTSEdP?=
 =?utf-8?B?YnYxdTBkNWtNUU5wbDVQVEhVMXlOVUNsZERVN0J2VHAzczdGNWovZVp3ZEVP?=
 =?utf-8?B?QUVDbEtDMjluWm5qQkMvS0JmaFVXVXBuUHRuVWVHZHZRdDgzZDBQcGQyNmZa?=
 =?utf-8?B?TURGOE5RQnlBcGU0S2NweHZiUDBnREhQbjlVM3NuVVhjc0x3MWlnMnFPbXdG?=
 =?utf-8?B?L3RVb0VaVnBKV1o3T1QyZUF6L3gwVGhnelFjem9SSDVRWTZqUGtBL3I2VktZ?=
 =?utf-8?B?TzgyWDl6T285TXVHOEI2MkVJSjZwNE1nTi9EOWd5WFY5R2xLOXVmbkpDSjBn?=
 =?utf-8?B?N1ZVUSs5NnBiUmFFeWRveG5LTG8ySEN4WW1OeFJ4MnRySHFVdlovK0NVdjEr?=
 =?utf-8?B?VUsxNjM0aWRTaC91R2picmtiVGhXTlZPbkNBUWVXNW42OHZURTllVVZ5S3ps?=
 =?utf-8?B?Y3RRdHhZd2R5bWZyWGRWVVdLQ1hTcTc4cXhrV01VYXpXbDNCN1dRTGxlZ3cw?=
 =?utf-8?B?Zy9pY0pid1VwSFdiVFczLzFiSFZqVVV3NWdUOXJVQzRYMDdrVmdTc2RTOEVt?=
 =?utf-8?B?VWRTeS9BZHhBam5Xa2NEZTNRbFZySXVtTjZ2cUhpOFQvM3JESEtudDJyN0Fp?=
 =?utf-8?B?dVZxMEE3SmZsZ2hETmV6a09KMEpMRVp0M1dHbXhkbGJDQVgySCtnS1gzNGdC?=
 =?utf-8?B?Mm1ZZmxZMmFmdHJ0TWZxVzFndlEvWXk1VGpaZklvU3RTM0tuR3B2SkljRWlN?=
 =?utf-8?B?c1A4ZDVjcFMzTm1IV1IvVmdsMDBZUEkxQzV0VVFuejE1Z0czc3cwaDFkOFgr?=
 =?utf-8?B?ZkVwYUZIN2hZcGExSVNCcUlwUUFNNnd1ZWdOdWd4ck1lRzJVL21KSzBrcUJa?=
 =?utf-8?B?NFlQa0VXZ2VPUlZaQS9jVFEzYnh2ZDY1SzhDclNhbTRJNjJCTHljc2Q5Ly9Z?=
 =?utf-8?B?Tm90cXV3QWxaSElHUjJSMENET1hwaTg4K1Fha0VzRFJ2azIvazd3azJWYWJs?=
 =?utf-8?B?ZllJNUlzZHpzeE5Mc1ltc0t2ekNPdjU5WE94RUhycWxiNzRBTENQeVNwK2tG?=
 =?utf-8?B?SzlFdFY4anY1cjhSVHNPK2NaNFZTVGxSaHk2aEQrQ1FweWNUb2hXQkh5MEZo?=
 =?utf-8?B?QS84UHROZ05WTHdvdGY1S21xS0tvNUtEOENhYVZVZjBUa1pnZVVpMUgvdDhZ?=
 =?utf-8?B?WmVwaWl2QWhGbGhyUUxJQWQ3cDZETmsxWVZqZTh5RHprQnVxRmdOM3ZFUjQ0?=
 =?utf-8?B?Mk85bGgrZXo3amtubnR5M2l0cVZXLzZndEJRMStkbGV2eXVUbEs5TUV4c21M?=
 =?utf-8?B?Tk96VGxqdmsyK2RhRDZWUHdleVkzQWUyVEpiT3Y2UWVPS2NIK20wdjU2Y3BO?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01909ee7-1f7c-4f3c-5a85-08daa61c2e12
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 15:21:59.0627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IquvL14DwIvBqBg8+vuKCJEPnFH2iulUjjjKplNUpBqR0q/2NoUSffyCOcTSWszYE6wzKfxCDw0NZaQPkeHR1mmMt67qM3NMlMb4DG4hMS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6062
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Borys,

On 10/4/2022 6:22 AM, Borys wrote:
> On 10/3/22 19:58, Reinette Chatre wrote:
>> On 10/3/2022 10:33 AM, Reinette Chatre wrote:
>>> On 10/3/2022 10:19 AM, Borys wrote:
>>>> I've stumbled upon "sgx_validate_offset_length" function in
>>>> "arch/x86/kernel/cpu/sgx/ioctl.c" (all of this is based on 6.0-rc7
>>>> version), which does not entirely do what it claims. "offset" and
>>>> "length" parameters are provided by userspace and as such their
>>>> addition can overflow, which may result in this function approving
>>>> malicious values. Fortunately this does not result in any exploitable
>>>> bugs at the moment (or at least I couldn't find any), but this might
>>>> change if "sgx_validate_offset_length" is used in a new context or
>>>> current usages are changed, so it might be worth fixing anyway.
>>>> Simple overflow check `offset + length < offset` should be enough.>
>>> Could you please elaborate where you see a possibility for overflow?
>>>
>>> Together the provided values, offset and length, are already ensured to
>>> not exceed the total size of the enclave in the following check:
>>>
>>> sgx_validate_offset_length() {
>>>     ...
>>>     if (offset + length - PAGE_SIZE >= encl->size)
>>>         return -EINVAL;
>>>     ...
>>> }
>> I think I see what you mean now ... if offset and length are
>> sufficiently large the above check can still pass but loops
>> that have the following pattern may have issues:
>>
>> for (c = 0 ; c < length; c += PAGE_SIZE) {
>>
>>     ...
>>     /* do something at <offset> */
>>
>> }
>>
>> Are you planning to submit a patch for the check you propose?
>>
>> Reinette
> 
> Sure, I'll try to submit a patch later today.

Thank you very much.

Please do take care when determining the "Fixes" tag. You identified
the issue within sgx_validate_offset_length() but please note that
this is a function recently introduced by refactoring code that has been
in SGX since the beginning. Please see commit:
dda03e2c331b ("x86/sgx: Create utility to validate user
provided offset and length")

While the initial fix will be to sgx_validate_offset_length()
care should be taken that the fix also propagates to older kernels that
do not have this utility. Either a new fix can be created for older
kernels or perhaps the stable team could backport dda03e2c331b
together with your fix. There are ways to create a patch that
communicates this to stable team's automation.

Reinette
