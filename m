Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1AAC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 12 May 2022 12:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353563AbiELMKt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 May 2022 08:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353548AbiELMKs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 12 May 2022 08:10:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DAB21A9
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 05:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652357445; x=1683893445;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DwYZbT4H0FCvpGFbHFWT2Wtn2YWUrcn5mFRnVRZOEoU=;
  b=WVEWk57Zs2DhN8Mg91bPOijdrdG6m7Rb7iZ3mEjRKPbrDQRRtK9YDhCQ
   ttcYS/vJDjOZt3ATBlMCXdDk5Ai6M9RcLKzxAVqVZ/Ne2QfVsivZVf/em
   FKpNQ80Id0LLMvLtQ/miTMo7XLlKSHtEiqjUtrqpfP1hdOZbvH1BaI607
   AiGaU5WN42xks3wnBW3X7FVyXJcb1h4cWz3UqAlE70hGCf6IXGl2WIc3B
   7FmiQGcWsqNQrPKHQtjxTa5VdBV1D3C5r8mqya5n5wP7EALYiRAoq5VQJ
   H3t6tT7816TIOhsT9ognc9L+GSyRbZBeWZL8Ebr1k5Nd84Q6M2zPjKzIf
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="257528126"
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="257528126"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 05:09:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="594638271"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 12 May 2022 05:09:51 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 12 May 2022 05:09:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 12 May 2022 05:09:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 12 May 2022 05:09:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAXxV10+ikbEia+3u+aWSHsYo2nwWtTqKRsD8jXXSDcAbS56DghzwnJa/Anwj2Vj39l46QgRqXyFVzMt81KBdX4DeiKhW//BK5h3cjPcF2iaI9q7ak0ySE7YUQOwLve2WrvkOW/ezVORbUxGn3yuS3d1It0ud+gRoMX0cIqc2CtAxfxBzTZymqXi2ItlsH0UcqoFzlaMf7GZe3BJadumXJxfZnSzx4kq+RsSlMTEvBzkS69Q/zV0wflCa0Uux6gTiTNlbSp/gKDSl3dOv2K+GnG5kKGJHTw37ySgIdz+et3+g+IUOvTV7nnHm682Q5skiK+4IBZCjgyC/80me9O5lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8X6pqHPVlc+hyZkunJZtkPCbPdYf9RNExVJioSZmlxs=;
 b=eh6ktlXQQLjP7TWeWwUxtAttY2ejwlD78EJABp0i8NQpHKkh2e1MX96PF+D6VPZzyz8Q7yR0QCAOTZSacCK2UXsprJh0LSRf14lTFjM5rZN9CUrx5PsUDlq1j6JXY6Y8lRBpxRNe5gqCwOJOJkbRVFGwCJKZb0XIjuCJMnm6JOaPyZFQ4ycr2CGU/v4UVB2VXDQsH5LtZ467Mo6yQF9yoG5QTjCNYDBctkMFEcO6zrsIsnpUu/5v6zOwUKhrx1RcUtjwmAdZzGMjoprIXBHVLNwscl25WlfYy5UxcJAldQs4eZ5AG1kr5OYmzLUOV3EBFItAEb9o1azoz2XE60a7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by BN6PR11MB1491.namprd11.prod.outlook.com (2603:10b6:405:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 12:09:48 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342%7]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 12:09:48 +0000
Message-ID: <39a50db6-39f6-28b5-9655-8e92f4810b33@intel.com>
Date:   Thu, 12 May 2022 20:10:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/4] x86/sgx: Move struct sgx_vepc definition to sgx.h
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <linux-sgx@vger.kernel.org>, <tony.luck@intel.com>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <fan.du@intel.com>, <zhiquan1.li@intel.com>
References: <20220510031725.3181361-1-zhiquan1.li@intel.com>
 <YnuQlEAG6kEAbLY2@kernel.org>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <YnuQlEAG6kEAbLY2@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0132.apcprd02.prod.outlook.com
 (2603:1096:202:16::16) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68eb0d01-f958-4c94-81fd-08da34104f7a
X-MS-TrafficTypeDiagnostic: BN6PR11MB1491:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB1491A4FFFBFB0C86F286BD8CA5CB9@BN6PR11MB1491.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FhwT5vUsi00BVxjIDSO2ZjeN+9KYHEbcs87dXCdmlDGBjCbJoLrXiK1SmmT5BsXdEhQmQ4uknzX7yDrQD12E2MYKk5V9v8aV2zY6DI4/a58MhYgzQxwp/VLSrS0i/Gs+EfxF8Oc9fvCPfp9+WynRjRubv1wRqN3p5YN3pi3TrTI9wgqZfqnfmEFGqfEev54COLO0e+a3iyi6My/D6sijaUWxjfXmmNR1z4jp2EgIMYcV5Fln+4kiWtgkjRkzl4TXXsunl2T9fMyWT2R9J66kSaqDVFzezEC8fUPDAy+IJZLmBeHCM2MT4HJPnrvmFq4RSmZKFYFJi1GD7SFz2JydtRjXpCfeqfxP0Do3PXATAVkjkooBgNTV/wcFHev4qDwvM7GivfSW5iEZ0Dl8iqaUwaVRV3zOQ8qAYw+9RycSi78+PVFbCoH75XuK1T47K3a13QNTRXlUX9qauGfktXjcZ9l0rs0O4in0dHLDoyGcpg+5Lm2wB4clhKlv4m6lIqjmwSTbHpN+2n5PNniOtRQBb1/FkUjxTi1QpF+hq/78PJVetaNJxYs+1ScM3cIeG3ghuUAXyASxNLxPyPnCIoWQJTMzueCNPpQzZsp3De8MyWM14Sc+Jc52nagkZpyeeG5gOcB9YCBJNoilcRrvUqPCsoNhzz2wUZGSuay1S4FznG5s99IfXeaqrD9MMca2OnSUBS7dPFvCd6Kd6E00eesjHay/H0J4m+I1S047+DcFuls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(66556008)(2616005)(8676002)(5660300002)(4326008)(38100700002)(31686004)(8936002)(316002)(53546011)(6486002)(6506007)(6916009)(36756003)(508600001)(83380400001)(6512007)(82960400001)(86362001)(2906002)(26005)(186003)(66946007)(6666004)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0V5SVg1QUtrdkdjcm43SmxTcUJYaGFYTVFsZE5kcVEwcHp6SEtHaTJNQklq?=
 =?utf-8?B?K2RESS9OL0hOQXZmeHhzK2dHUEpXWDBOanRZTlFSbFZMZm1SdjNhenhqMFdm?=
 =?utf-8?B?Ykw2YzlMSmpvZS8yNjAwaFA2TUNxSjBtSEUvNVArWFFyWlNQUitNeTVzZXNB?=
 =?utf-8?B?MlU2ajFzUlZwTUdpRjExeVVKQUtZRXdhdE16dmpRMmxNUFQ1dTVCLzIxVW0y?=
 =?utf-8?B?SHBNZmxpNTluUm1POFB4YllydXVyczJXZGdBbU1idEJPaDhDQ0xUVHp5cng4?=
 =?utf-8?B?a1M1Nko2MXkwNkZBQlczZWNoenN1K0ZUMkN3dzVNY3lRWk1KM2wwOWxaRVJJ?=
 =?utf-8?B?YmlscmFBYU9FakNocUJVekhUNkJNNmhVL0I4dzJWRkw2SUJIT2hnV3lUUElS?=
 =?utf-8?B?NS85K0poR2J6aVVRa0VGQ1FuYnZlYndqY1ZiYnFyZnJxcVJtQytoQTVBeVRM?=
 =?utf-8?B?UFVKeWYxcGJVTXNWa2dhTzNUakN1Y1Y1dWZzOTJ3Nk5OcmJ2NVI1UUFmaC9z?=
 =?utf-8?B?SzNvZlprdVpoNE1CZlF1Y1h0T0pnWitubUFnUHMxSHRraE8venhPVDlEV213?=
 =?utf-8?B?QzMxTnNoSXhDbERCeWJNcFRVWVJ6clBuYmRRMy9pSlpFZnAwMnRmNDFwaUhj?=
 =?utf-8?B?V0NpN2MyQnc0UkpwckpZYjhnNDlCOVRVQUp1OHlLZlNEU0lHamdaOEdmeU5G?=
 =?utf-8?B?aVFDcTNlbVc3T2J3bVg3bVM5c3YyQ1QwM2tEdFdyTEF4N2dxMERtLzhaQTZO?=
 =?utf-8?B?bk8rSDJyVVBGR1RaZlJxNHNXeVJia2I1Y2Y0VzNRaURMUHB2WDlVa3FVbXlw?=
 =?utf-8?B?RlZBeEh2c3pvckp2QXZNVGNZS0Z6enl6NVI1ZTJwd1ZEVk1hcVRPRVk0cS9r?=
 =?utf-8?B?aDBsU0E0MmVEaW41b3ZVdXNOSHdycG05QVVwMHIvVFhLNWVZbHl0TXBvR3E0?=
 =?utf-8?B?SWtKZUZEMkYwVllOTkdJVUlTSmd1eWZTNDBQVEFpdGhvWEpjSU5RUFg0eTlT?=
 =?utf-8?B?QzVvN253UExvNzJkWGxwQVdOUUFxVnJPeXBoMDZDTzZudXdKcnRZcUtvbW84?=
 =?utf-8?B?M1NkZU5ydGZ5ckpyRFRFbjRpSkd3aDU1OHZianV0aVI4bGZ1L3cydDZHVXgy?=
 =?utf-8?B?Uy9nY0JLbU14MVVPTEk3ZVhWOEM2ZWl6cFJueDdLZXZ5eXViNkRsZkU0eDk5?=
 =?utf-8?B?T0NkZks4cTRndGlKVVlsSW9reWZCTGxrc2FQeE12Njhsc1gwbFZZdndYak0v?=
 =?utf-8?B?dzQyTk0vVXRxUTlNbklRZGo2a1VlMHc5RFZ1QUYxYnZuK09GVFFqTk1JME01?=
 =?utf-8?B?TXNGRDZsT2I1clRIczdEdzlQV20zWWdoR2xkUjM0alRpVFA2dVZDUVhDSVNP?=
 =?utf-8?B?K29xODNsTE1xeHVaUXBRd05rMnNQOE1EN3lPNE1aZjJUU1oyQ1hkUzYxSTYv?=
 =?utf-8?B?VTFFSmtQdEVUdnZNQjFMZXdjWWRSMm5wZENHeHdCT1dkd0ZoUWQrcVVQZ3lq?=
 =?utf-8?B?TVRscVp4UkVhR2FoYXQ3Z2RsaFRybVJkVWNYeDA1OFl0MHQrTXlTenlqNXBk?=
 =?utf-8?B?NzBodlNqNHJPNndnU3FhYXJwd0VEM2xGQnJTcmhJakR4M1lmeTdIbHRKWDdl?=
 =?utf-8?B?ZFZsWFprTXFmUzFMeHc5UzJzblpEbzRLaTV1YUFSR2VCK2UrWGx4Sm1kUURS?=
 =?utf-8?B?QzQ1SmJhclVlb3gxQnRrZWd6L0RTZlQ0WmhNWDdPMk5WTXF1bldscVBmVVdt?=
 =?utf-8?B?aHJZMktiRlc2MkFFKzc1TUJyRTVRUDVqV2lERDRNaGo2ZmhJa21xZGQ0RHdG?=
 =?utf-8?B?cXVPRmtSV3VFeXA3b29vcXc1Z1BrZWdpRk40eVFnZDZSNURTNG1NeGdDWlhE?=
 =?utf-8?B?WGtJL2VJbXdtTm1wREhWSmtqOE5NSXIrcWUzelNrL1FJdzFTVWMwVU5CdGkv?=
 =?utf-8?B?aGsyZDllemZNOEZlUVlOWGhic3Q5dGhHaFoyTGhqTU1PbWdGaktaYUFpcVpj?=
 =?utf-8?B?UWY1d3I3dTlBVFlONXpkeG50cDNka3ExMGtpQ1orSkwvVFUwMGtIcVNGSmNR?=
 =?utf-8?B?TmtTU3B2L25BWE1zVWhsNHREYlp0L1AwaEtFc25QcHZ2MTlzL0UvcktiRDlH?=
 =?utf-8?B?UkZXQWRod3Q5eXBVWjByOXpPc1BMclVFK2MyZmUrYXkzaG1XQXVDRy9oTytu?=
 =?utf-8?B?T0d4SXp1SndLVEpiQ2srQ0dqYWpQMCsvb1VldFkvYmFZZ01ZM0hBellwRVJK?=
 =?utf-8?B?REUrOVQzbEFEY1dlTWY3NEEra0VVaFl2bVdWTm4vMUx6MVRYeGJOWG5xWG1j?=
 =?utf-8?B?T044VW93ZDB6OUZ0Q1puRE1RbjFzdER0U1NTTzdWZVAydHI1NlY1Mjl2dFRH?=
 =?utf-8?Q?QYdcNnuDVRHrFOOU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68eb0d01-f958-4c94-81fd-08da34104f7a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 12:09:48.7489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yHnmJ8/FQOjBHqdPBFUUbnHtcYCC3Pwv7HyVkK2DSOAh5QojFVIf/byYzLQPCwRC+L3mkEXjsnVQkt4wdQk6iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1491
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/5/11 18:31, Jarkko Sakkinen wrote:
> On Tue, May 10, 2022 at 11:17:25AM +0800, Zhiquan Li wrote:
>> Move struct sgx_vepc definition to sgx.h so that it can be used outside
>> of virt.c.
>>
>> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
>> ---
>>  arch/x86/kernel/cpu/sgx/sgx.h  | 5 +++++
>>  arch/x86/kernel/cpu/sgx/virt.c | 5 -----
>>  2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
>> index 0f17def9fe6f..83ff8c3e81cf 100644
>> --- a/arch/x86/kernel/cpu/sgx/sgx.h
>> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
>> @@ -101,4 +101,9 @@ static inline int __init sgx_vepc_init(void)
>>  
>>  void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
>>  
>> +struct sgx_vepc {
>> +	struct xarray page_array;
>> +	struct mutex lock;
>> +};
> 
> Would not BTW hurt to add some documentation for this struct, while at it.
> Nothing wrong with the code change itself but what about adding a brief
> explanation what it is?

No problem, I will add some documentation in v2 patch.

Best Regards,
Zhiquan

> 
>> +
>>  #endif /* _X86_SGX_H */
>> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
>> index 6a77a14eee38..c9c8638b5dc4 100644
>> --- a/arch/x86/kernel/cpu/sgx/virt.c
>> +++ b/arch/x86/kernel/cpu/sgx/virt.c
>> @@ -18,11 +18,6 @@
>>  #include "encls.h"
>>  #include "sgx.h"
>>  
>> -struct sgx_vepc {
>> -	struct xarray page_array;
>> -	struct mutex lock;
>> -};
>> -
>>  /*
>>   * Temporary SECS pages that cannot be EREMOVE'd due to having child in other
>>   * virtual EPC instances, and the lock to protect it.
>> -- 
>> 2.25.1
>>
