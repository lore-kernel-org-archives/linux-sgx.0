Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FCBC433F5
	for <linux-sgx@archiver.kernel.org>; Thu,  5 May 2022 00:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiEEAMl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 4 May 2022 20:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiEEAMk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 4 May 2022 20:12:40 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB8762C1
        for <linux-sgx@vger.kernel.org>; Wed,  4 May 2022 17:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651709343; x=1683245343;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fk38BGYM9EQV+5fsRLLXpBX0H28McpMpAdlNDJG2+1U=;
  b=donR8vVCX58jAjWoiV2Rlt/gnm9kw0cJ4+mFupOqA8MvkM9sG4biP/gx
   QQcNgX2jcLXo2+VNF+4tQ9xfarC2TjROZYh3aMWhriEwT3/ggqJ2LPZ5J
   OH+cX8IsEWC+5HT8og8xceDjExq0ZoO5sYKu7CT1/1kdWZlO0G9Cc5NgG
   3zVvNWM6w/FrQqybPrC/udlZadcjaBtm/wQJow31uWXW+23NuNd7Dr7ou
   cudUrP4Hqe39m/1jlcaewrMCrAXGAwQHfey/sbXaNmFgqW89iGmHL7R8K
   kTHNt1XrBypThkOXAJKSm9OlNXujxpaIhT5Et/5eQYKyauc7Ita36lwPg
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="268089387"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="268089387"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 17:09:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="694408991"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2022 17:09:02 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 17:09:02 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 17:09:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 4 May 2022 17:09:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 4 May 2022 17:09:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3Xg+T9Yc0mxEmGRQNw1oB5We8E7uhdGTXMICSZc/UUppqNpxoL4ghiLkr9Oq38moChyDFkaPhDy8DAb99gtJED7FEQ5tTzeIPnjecVXPxScdKvpA2rK6Y04s5r+tjgMcN/2klM70qxxLtKvM61dJVUEwsBgK/dLPeKkvIwShCvl5PJdpCR5+E0DF/Yq6aRsLDQodtE+pCVSg8TaLuUwnuSm7uCyli/XVeiOrh7xU6AhWCrpWiwSdSBlmuCwsFiWqw5neWuzL+ZKPod6lkwgt18gy2JYX804XonIbnFvUq3GQc7P6ZsQR4Qs3jq4M2SJ2SmC3ouaZ/BzJx0E2UjyxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXRlos/zqTtFAobd7ZfYRNoKCqnIgxY77WDVYvno1vQ=;
 b=m9bYTS4cjnDQZHY0jF8RH3lV6PBcHipyN1b8EZ5ytDJXKJGvliYQO1rI2il5lggN34Kjnn58LHsMQI1lZT8dTyqYhDB9yqIgo8xRctyL3ZoRu/bsck1hD6ptPMBfnxDeL5TfvKcy2DtpJZJP15q/iHxLblRcP0NKEnHQUBkqnYXANzIJtDHXLYIEkRptDT0dQLt8V2mC67n15O/Rf1rBdKz35mL5ds2ybGmDCsviXyEDiJgEVr/9/WNKTecfybz8p30u7+QxJMOIm6yjeH1p3OqKXN6kuF4zulqj7XC/1DWia37N8NWtt3WT/EEScZtYSMUWcnMyOBtfFndIdToGsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BY5PR11MB3974.namprd11.prod.outlook.com (2603:10b6:a03:183::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Thu, 5 May
 2022 00:08:59 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.026; Thu, 5 May 2022
 00:08:59 +0000
Message-ID: <da387afc-e666-45d0-1e99-066d8c4aab03@intel.com>
Date:   Wed, 4 May 2022 17:08:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
 <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
 <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
 <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
 <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
 <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
 <c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com>
 <d4b52482-2dd0-d5f1-bda9-e1d97883298d@intel.com>
 <705c7c6a-3618-2d74-115c-68347b8aa8e6@intel.com>
 <468848d0-ad58-8da0-dd39-b9604d458cdf@intel.com>
 <fd752d77-9f33-9618-36c1-66dee6c2e93c@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <fd752d77-9f33-9618-36c1-66dee6c2e93c@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::33) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8b82922-2ba6-4b71-f396-08da2e2b7448
X-MS-TrafficTypeDiagnostic: BY5PR11MB3974:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BY5PR11MB3974FB7C76753DDEC525F965F8C29@BY5PR11MB3974.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/ucyPqJWoCHI4JZ10Uu3lv5XAfRw+AA/8dXA9PY6PXvNnDFVG2Cg+ihNErbpNng7hxEi/9tZfWl+0ktdmpD3FOT+5ZkTpt3HMG8kMi0JxLEUDlvgzutFPL9dNcEw6tBgIYvNLq6kEZMS8UfWntN4+QPAdGIxCy6XU4ibkDKivLFc8WXsFZ9hm4vr0/5JLsJWT2LaU00VezqGZJJsrowWUKB4JZCLVjhMCeiEmaXK29fv1q5svehpxZtFG60OPFQv8ugG2Jvnuz5B+TiZKqdwkfZgi+lyU9sat9HhP+UFadT47C2CJX2hECzPy9xmJVZFvc06dJPF3kP5U4SYW1pnEz9E6c/9BeoYOpiIEaS3iw06g4GxHlcwCJgxAYoovMuLohEHQsLGIW/bdx9ponVmTrWebAVzaRu4fn0OyTtGbXdKTOlO1OL2FKSHLnPCHr2i1EUSDql7qzvsGoKdMoLj53IidE1mpck2Z9x4UDc8ADC6h7eDiIgDDfgY/fXHSWpqqbrLKYeb7GfDMlgmdik3jvVZTvmY7mN3R7MkiXzzN1CtXdaLq5Zrk+b4rc8ZZwPC2dHzzfl+lyzAVTk46n1PyBsfveHo5nBAjn7+Jyh2AfeiScXEntJEaDMHKdJhFO8zVUSFLTyhceDDHxJohM2oUQXrf4DW4F3nSPjPzeDGm0gqQrJhffifV3bLhkDopb3ZCLWUP3U02f/KYb7Ot7uahzkhk0Vy0Yy13Y1mQPhaIebHtyniGDVZ1L8UW3JHZ3Le/U/dIz3MMGCHuRMS27pKp7AuU0Nq5s9wF6w1RFefqFmylHXA9h83cjmlpUopAxX7K28HRj51+/XzQWwhggpgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(5660300002)(44832011)(83380400001)(6486002)(966005)(36756003)(8936002)(66476007)(31686004)(2906002)(316002)(4326008)(8676002)(66946007)(66556008)(6666004)(26005)(186003)(2616005)(6512007)(53546011)(6506007)(38100700002)(86362001)(31696002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U01acUJTd3lLVjJ6UjQ3SXB5ckV4bnc1VS9kbGlwNzl3V3hTQ3pnZFhHWkhj?=
 =?utf-8?B?UGppL2FKRjZ0TjhzS1I5NEJLVEt0ZHBGc24rVzdIbFpQUHoydjJnbDdqWmVP?=
 =?utf-8?B?MmVXT1NRK3I2Skk0RzZ5OWN1T2FCZVpLNWduK3VXbnYrMENKTnE3R0d2UTdt?=
 =?utf-8?B?WE9JeFM3QXVaeDkwUGdUYWR1TjRnYUg3aG1DRjJXNTlHaE5lMnpoWkVCM3l6?=
 =?utf-8?B?VFl5RDdLb3NyNWVaN1Z1Y3hQS3pDUi9KVXB1QXZrNFovTzhUTUR2TEs1SU4y?=
 =?utf-8?B?TGc0c0JEMHFEN3NyYTR4U0NYZWxBU1RSbUhmMCtiemJKclRTa0lMRmdZdmd3?=
 =?utf-8?B?a1lQT1V4bXRVNUhmTExoWWdxTTFEdHVxNmVYQUlkYVQxMkpvdUM3Y2xsbWhE?=
 =?utf-8?B?UFdFVlpTZkRFNldjY3R5SnQwUW1nbXU5VHBpZEZiRW9pdmlLVWdHZ215eExr?=
 =?utf-8?B?UlVEc242SDN1ajlDUktwZERaT2tXOWVsMEJpWUY4SzZ5a2Rzd0JmMk1sWTV1?=
 =?utf-8?B?V1RmKzY3VE1BOEV0d0xpK1Q0emxkWWs1ZWhBeDh2bzNrRDBXRTVqSTRGQkp1?=
 =?utf-8?B?VUVjR1BCQlAzTFJzWXpXVWhXZTYxUi9SK3FnVUdBU01JUWR1MXlXVGZFRXJT?=
 =?utf-8?B?QXdaMU1wQm16cWpaaHdOdmlFcU9vQm1TYlZRMjQ0RTBaeE4wWnBLbi96V1JT?=
 =?utf-8?B?eGlDVmtlZDNUb1pOM0NlaDU4MkRGSmk3anB5OE1YMWZQUDZCaUlBTWdIUkc4?=
 =?utf-8?B?SGUxOXpZTk84dHl0K29zZkxhTkRpQ2RLbnF0azIya2lGcGQ3QlJrV3kyeEN6?=
 =?utf-8?B?YTRUSmMyc3RXODR2cDVyU3RYT3RRa292MlZqK2RSZlQyU2xKajZJUEFpY1NT?=
 =?utf-8?B?dDM2R09PTzY2anZoY2p6c2YzR3Z2YW5wdGRRRUxodVV2Q3g1eTl0YllwM09q?=
 =?utf-8?B?b1l5TGhLMWtBbDdFNWliV2twV204d1FOVk9QbDEzN2haSHErQlBqR3NpVWw0?=
 =?utf-8?B?MWQ5Yzd4dTlhWk5uTmZmSGE0QWdaUmVqYTR6OHlISG41SE55VzdzYnVmdG5H?=
 =?utf-8?B?YTBkNFFuZS9UZ25SUkY2SE5XVDFCMGhxRDgzWGhVSEN0R2twYzVzd2I1a1Uz?=
 =?utf-8?B?enltZ2t0ZEFPODdFN0R6UEpMZTdqcEJwWUVKbGoxVzF2UVZFRDBFSXhhVE5h?=
 =?utf-8?B?alhsRUo1czRGVVYvRTJsSnR3R2dUbDIrNVZlb1ZDcG8yRnhibkNuRDUvR2w2?=
 =?utf-8?B?c2lSZ1k0b0pvM0dEM3FKS0FXc2UyM0NRa3NVY0phWFNEK0R6MXM1Qm1uU1RZ?=
 =?utf-8?B?c3YrUExoQS84VTl3cnpQRFpuMGw3SXpDTFJYaGcxU2dJU1pabHViRlhpZTM5?=
 =?utf-8?B?NngvNldnWEt2WnNyZXZFTi9EdXpQeXQ4SHltNGhWOXdQNWsxT3ErdGdPeTBD?=
 =?utf-8?B?eDRPajYvQlk2b1E2RFg3dGJlVC9uUGZQa29kcTJYSGNBbk9KbThaLzg1V1VS?=
 =?utf-8?B?azlldXRRUWFVQVRVY3JFVTZsNWZpTTJ6YzYxeDBDenVSaHFxMFYwU29hZ3Z6?=
 =?utf-8?B?VGRvQ09pT2Zrc2pyWk9BSVlUK0ZQeHhwSzZpU3d1eHZPbFdCb0x0NXZpUy9C?=
 =?utf-8?B?em4xVzBqMGh4YTVVc1hPdCtxTDhMZ3F2VEhZL2RMSXlMVWI2OVhMcDBNQVV0?=
 =?utf-8?B?OW9haTV2U09vSkJMSElLZlBWKy94b0prbzRsNUFmaXp0YTAxdStDb1dCYUdH?=
 =?utf-8?B?ZW9LdXdhSTROSWs3M1gyYjJoUjdSc2xzOHJoVklUTVU3UkIxRFdHUHgrVWJ5?=
 =?utf-8?B?RzZpY2U2TlJxTjV5TCtMSFdwNUJlcnlMVEFqNFRabnZRU3dwNkdueHJ0ZDhM?=
 =?utf-8?B?SXlvOEwrdHlPVmZxY3kyeHBRdFQ1ZW12MmoyclVVeE03dVErcjFMWnVFMFRU?=
 =?utf-8?B?ZFp2NnRSc0pkVFJKZWZIcFVSckNUS2QwaERDWWJpYllxTmQ4SktTZVNIc0k5?=
 =?utf-8?B?ZTJNS1hQcmlYbjhOMGttdGRKWG12cks0ZUJmaFpUUXJtNzMrMG5qUnljWjFH?=
 =?utf-8?B?ZllsV2JweTdKQUV4VGxnSm1mUUpnYit4dXBBWWxub2ljZ3QrSTZaMWNQVWFr?=
 =?utf-8?B?TEZVenJTblVFWmcwWTNBczdUcGdKZGhXZ05tMGc2UnI1VGdXOUJVaDdsNjlO?=
 =?utf-8?B?R1g0dndhTHZreHJMaE9wdGJNKzhKNmpQeTduZnRJa2lSc25NN2V6M3hEK3c0?=
 =?utf-8?B?NVo4VVh5cTRBb0Z2UFBPcHdydC92ZDY5aTMvV1lEMFg0dnhFc1grNXdUbkU2?=
 =?utf-8?B?MHRNbSs2Y21QUmxzcnpyTGtPOHNweTNBOFUxbmlJeFB3Mk93T1F4TDRhc0tY?=
 =?utf-8?Q?+pCvLJafUMm1wspc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b82922-2ba6-4b71-f396-08da2e2b7448
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 00:08:59.7474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l7wWsz9+7NpTUhLB/ZniGf5LRMLGEAXltn0jkcd3Eu4E3hMpbBfxr9PLgy5rh11KA/ba+CuULxfIcZS8DKThvFApT+4RBZ+5cfhJskHdQLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3974
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 5/4/2022 4:50 PM, Dave Hansen wrote:
> On 5/4/22 16:36, Reinette Chatre wrote:
>> The page fault handler cannot check for SGX_ENCL_PAGE_BEING_RECLAIMED
>> until the reclaimer releases the mutex.
> 
> Ahh, got it now.  I thought the mutex wasn't held on the reclaimer side.
>  Thanks for the refresher.
> 
>>> One other thing.  The role of encl->lock here is very important.
>>> Without it, two concurrent page faults could do their individual
>>> memset(), each see !pcmd_page_empty, then decline to truncate the page.
>>
>> Your argument is not clear to me. Yes, this would be an issue (and
>> that will not be the only issue) if the enclave mutex is not held
>> by the page fault handler ... but the enclave mutex _is_ held by the
>> page fault handler.
> 
> It would just be nice to clearly state the locking logic in the eventual
> changelog.

Will do. Below is the changelog I am currently working on:

x86/sgx: Fix race between reclaimer and page fault handler

Haitao reported encountering a WARN triggered by the ENCLS[ELDU]
instruction faulting with a #GP.

The WARN is encountered when the reclaimer evicts a range of
pages from the enclave when the same pages are faulted back right away.

Consider two enclave pages (ENCLAVE_A and ENCLAVE_B)
sharing a PCMD page (PCMD_AB). ENCLAVE_A is in the
enclave memory and ENCLAVE_B is in the backing store. PCMD_AB contains
just one entry, that of ENCLAVE_B.

Scenario proceeds where ENCLAVE_A is being evicted from the enclave
while ENCLAVE_B is faulted in.

sgx_reclaim_pages() {

  ...

  /*
   * Reclaim ENCLAVE_A
   */
  mutex_lock(&encl->lock);
  /*
   * Get a reference to ENCLAVE_A's
   * shmem page where enclave page
   * encrypted data will be stored
   * as well as a reference to the
   * enclave page's PCMD data page,
   * PCMD_AB.
   * Release mutex before writing
   * any data to the shmem pages.
   */
  sgx_encl_get_backing(...);
  encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
  mutex_unlock(&encl->lock);

                                    /*
                                     * Fault ENCLAVE_B
                                     */

                                    sgx_vma_fault() {

                                      mutex_lock(&encl->lock);
                                      /*
                                       * Get reference to
                                       * ENCLAVE_B's shmem page
                                       * as well as PCMD_AB.
                                       */
                                      sgx_encl_get_backing(...)
                                     /*
                                      * Load page back into
                                      * enclave via ELDU.
                                      */
                                     /*
                                      * Release reference to
                                      * ENCLAVE_B' shmem page and
                                      * PCMD_AB.
                                      */
                                     sgx_encl_put_backing(...);
                                     /*
                                      * PCMD_AB is found empty so
                                      * it and ENCLAVE_B's shmem page
                                      * are truncated.
                                      */
                                     /* Truncate ENCLAVE_B backing page */
                                     sgx_encl_truncate_backing_page();
                                     /* Truncate PCMD_AB */
                                     sgx_encl_truncate_backing_page();

                                     mutex_unlock(&encl->lock);

                                     ...
                                     }
  mutex_lock(&encl->lock);
  encl_page->desc &=
       ~SGX_ENCL_PAGE_BEING_RECLAIMED;
  /*
  * Write encrypted contents of
  * ENCLAVE_A to ENCLAVE_A shmem
  * page and its PCMD data to
  * PCMD_AB.
  */
  sgx_encl_put_backing(...)

  /*
   * Reference to PCMD_AB is
   * dropped and it is truncated.
   * ENCLAVE_A's PCMD data is lost.
   */
  mutex_unlock(&encl->lock);
}

What happens next depends on whether it is ENCLAVE_A being faulted
in or ENCLAVE_B being evicted - but both end up with ENCLS[ELDU] faulting
with a #GP.

If ENCLAVE_A is faulted then at the time sgx_encl_get_backing() is called
a new PCMD page is allocated and providing the empty PCMD data for
ENCLAVE_A would cause ENCLS[ELDU] to #GP

If ENCLAVE_B is evicted first then a new PCMD_AB would be allocated by the
reclaimer but later when ENCLAVE_A is faulted the ENCLS[ELDU] instruction
would #GP during its checks of the PCMD value and the WARN would be
encountered.

Noting that the reclaimer sets SGX_ENCL_PAGE_BEING_RECLAIMED at the time
it obtains a reference to the backing store pages of an enclave page it is
in the process of reclaiming, fix the race by only truncating the PCMD page
after ensuring that no page sharing the PCMD page is in the process of being
reclaimed.

Reported-by: Haitao Huang <haitao.huang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

> 
>>> Also, given the challenges here, I do think we should check the
>>> pcmd_page after truncate to ensure it is still all zero's.
>>
>> Could you please elaborate the challenges? I do not think it would
>> help the issue at hand at all to add a check since this is done with
>> the mutex held while the reclaimer has a reference to the page but no
>> mutex ... as long as the page fault handler has that mutex it can write
>> and check the PCMD page all it want, the new changes would occur to the
>> PCMD page when it (the page fault handler) releases the mutex and the
>> reclaimer attempts to use the page it has a reference to.
> 
> I'm just asking for a debugging check that looks at the page *after* is
> has been truncated to ensure it is zero, in case another bug creeps in here.

ok, I can add your patch from
https://lore.kernel.org/linux-sgx/faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com/
to this series.

Reinette
