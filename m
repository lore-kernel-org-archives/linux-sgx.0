Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA9EC25B67
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Oct 2023 16:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbjJZQDi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Oct 2023 12:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbjJZQD2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 26 Oct 2023 12:03:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B8419AF;
        Thu, 26 Oct 2023 09:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698336177; x=1729872177;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IJT/jPZ+V/pWvYgSXPxCruObW2YfmaBplwUaqAwkrMA=;
  b=Aq4gxInDMp78Wv5P+APyqo8n0BuWkVYV5TL4GB4aKqKbLj1rn/4LV0y5
   hh3yblnEiOpLrBiHEyPaTFvx3jFj3jXL5iSzaE2PW8faAHiT7l0pI+1s2
   xMVVuIWUs9NX+yqGlTTQnZj22Ts4ymaNcpZWc6NApSOwiBV9ODL5l+mhF
   sHG6hpB4/Ni3AUh6erEGh/0d6GjmNOBHS4LsVRMjxE2vSTGu5YQdtK9G3
   uE7OlV+S52fuDZUP5Kwh607OnJ+rNoNa0qK5m9b2UOHLWW4MlnEHgKnhU
   0iXf9v+S36JdKwrbt0uoFMKijsWBE3hmuJpCTIxKfSAeNHpstduBdfUZM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="372630889"
X-IronPort-AV: E=Sophos;i="6.03,253,1694761200"; 
   d="scan'208";a="372630889"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 09:02:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,253,1694761200"; 
   d="scan'208";a="7327334"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Oct 2023 09:01:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 26 Oct 2023 09:02:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 26 Oct 2023 09:02:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 26 Oct 2023 09:02:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsFuPidV0iJ+HyIgu4nmIx6Fm3nJHcfwjc7ZPHGq1Jkh7yjKcWD/3VySN5VtUZL+/clkFNNyiHUOHQy5OOYOD+9zj+EHnTIVc5tA0pyQjIPAnnfhK8MfCKZdL6kz1vDPw5JQ2QdrigWMXY5JRp4Hl7IVYYTc7U2XKkqP1lTpGklFgPkYIr9jsDQmdzzHFnQwkQ5lqF5B5wOBHn3QPOJh9GjUJLOjexO43ziXikmajj+DBBsTGgH9AmeABulOchHzCdpg+AFuw2dZ2BMrryW3u5e++lYh8KEzTWN2GoafPdHSb61RPuJ5qXqyAXFx3aTqoMp289tH/TgAi89fQDFiwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikZK5VybyYVn9MZ7He0gHuHCSRWvpPENaaLcxymn84w=;
 b=GScVcNubVAuCHnwp0ttSKmcmRQY+ulvPqhGRiPQLha1QedmTCzqjuZYJxij0FlcFV7GCpr6ntip6lz2lvx///qlhXqKpq0fP1MkC9hPTOTbUzyxEtCKI09+2dkZhliidla831getaDgzIyo41l3B2BLmQWstCrfLEWBaoccBqJEAexU1fXTarLgrSu+kMthFbQisE4LsAUMoJAiL7uCETjZ/WGEgAZan7TGeNrX+MGUQjKqkpd0J7cn24LxLZ9+C0FMUN9biFV0nJXM+rrxHa+WLtW84Dryt1zvWQvgrJsFtXQYiTfhbZDuSbWGyNQ72oibTl9ptorPju6cshpaSuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7497.namprd11.prod.outlook.com (2603:10b6:510:270::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.22; Thu, 26 Oct
 2023 16:02:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::6710:537d:b74:f1e5]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::6710:537d:b74:f1e5%5]) with mapi id 15.20.6933.022; Thu, 26 Oct 2023
 16:02:01 +0000
Message-ID: <b709d680-5754-45ab-ae73-c812420f10e5@intel.com>
Date:   Thu, 26 Oct 2023 09:01:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20231020025353.29691-1-haitao.huang@linux.intel.com>
 <b8ec3061-436f-41d3-8bff-635a90774dfb@intel.com>
 <b389986bac0e65ce128c9553603436efdda24a58.camel@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <b389986bac0e65ce128c9553603436efdda24a58.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:303:6a::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: 82c22e3c-8b9d-47a1-d4da-08dbd63ce36b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sLtX8+tFqywPqYbzcAGok4DByqYwzX8Eds7q55b5pcrEtcrvQoT8CecFcct5r1bpwmWyq7RNyppRQlxKrO2g14HS7flt0vf7MMLAWgudyK/nQAXar/A9GJNdW/bpKHhRM89SSM3wmoRzdZBEcjNZiQlTc9MY79IarJ5TUxKz+gv9rUr87HGgu/4hFA4YSeJdZh0f+JIcBIr8jenEv3nCRuYli1vEKX1EpJtcFT0fDS3NrR1ViBqgBkjqfXiKy0/jCgyH+Ad2dPcAD2K5nh9q3nqkwbIExkufWG36Iz0cjULWS8WXHr+8VI3COyU5oitZLeG2S35x3fH5L0nejl9TBm9AUwmeykf+LnK0cPlSxert+449KgTfu6Nysha5LoJF99m9Go859jZh0G3RpYVVSqgW4vO7Ft1lwc2yxknQZS2eXbEGJ359/wKIAuu4tvHjCL+7kmWYW02l5s0t+YJFPkfXp2IZAdF3lPCiYvIVXNfQwQX4uTNUqf+le6gwa9OdQsFnxD4eQ8Kn8PzLVJSV/D6RfiXnQAE4XlU1sy6ltAY8xaFdzsVWd2G7StEo0DhZOtwJdkz+BsUiicwLf4uA210q0vedLAma+MHEaspLrXM6p9Cfg9R6mmj8iQwMiJjupw7rDRKojY/ce82butCrSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(376002)(396003)(346002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(38100700002)(83380400001)(53546011)(6506007)(6666004)(6512007)(31686004)(66946007)(110136005)(2616005)(6486002)(26005)(478600001)(82960400001)(316002)(66476007)(66556008)(8676002)(8936002)(4326008)(5660300002)(41300700001)(2906002)(86362001)(4001150100001)(36756003)(44832011)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjZoaWo0TmR4V3BJb21PRHBIS0RTR3prK1R6Uyt3MVhDNkZ4L042S0dmbUVk?=
 =?utf-8?B?bXdVRGdYQThQOFh6a2c1aUJZc29yRHV2NkI4OU10NXduOHZXeDladjcrK1Na?=
 =?utf-8?B?dlMxNjFtUjZUbUJGYXlyMmpOcm9mVG5VdHk1bzk3NG9YNERuQ1M4T044TGRJ?=
 =?utf-8?B?SFlBeXFzdXh6OVovdXNMZzE4Ry92WlRMZzQzNDhEdkppSDF1ZStJY0J0d2o1?=
 =?utf-8?B?ZTA3ZUJibjJDZEd3eUxvUzR1ZzdzaU1tRlh1VDFQbGFKVmw4UVU5QWdLYlp6?=
 =?utf-8?B?V1JQYUl5ODg0Z3BLSDR2TTNSZktvdmpEU0gycXJoOE05eVV2dENhaWV5R05z?=
 =?utf-8?B?Y09mWVNhVGNMSTdzT05VK3FubDgvNDdCWEpSZldkbGRNNDVBb2ZyVFBVbXYv?=
 =?utf-8?B?UlpXc3dkQTFrRjB5VWtzQnE4U0FnbjdnREpFUkNVTHI0Vy9jQ0IwMnBoTC80?=
 =?utf-8?B?bFhEcW5YMVFjWVJIZ0pmY1QvVU1waTlHSXZTUTJobkxDenFPY2pXanY2UGJ1?=
 =?utf-8?B?bFIxNlVMZlVxSnc2U0ROYkNKQmtaUm9GS0N2MVF5Si9lUlJlWVVKbDl0ZXlF?=
 =?utf-8?B?ZzRja01UaExoOEVSSi83YzNnZ1NOVFo0Z1ZvbjcyQWpFYVd2UHNlZG9CZE1q?=
 =?utf-8?B?S3cyL2dnYkZzVXhVU2l5amY4T05XVW9aR3VYc3A3R1hNL3pXRitBNnNOeWt5?=
 =?utf-8?B?SXhlL0h1VmpIZmpsRDJJV3UwQytDMmpCeWV5V2VJb3lxSUZtL2xBZW11eXFj?=
 =?utf-8?B?ZUM2eUg5L05VaHIvell5bU1rcjBJUktFTUt5UmlUZlRQR2dxMWI5QjQ5V3Iv?=
 =?utf-8?B?RitLODhXRklFbTQ5UXIxajdIM01xNngwSmgwRXlHZ1dkWEJrUzgzdzF4d3o5?=
 =?utf-8?B?ZlQxMTRxbmh3MlNUMXpmbk1MSnQ3cEFqN2F5SUVuYjlCNGx5aFQ4eUFrZm1U?=
 =?utf-8?B?UEx4aGNrd2pJZSsvU2Q0emViZFVkTzk2YXkxV0RwYzRoY0EwNmNFcTNxVU5I?=
 =?utf-8?B?ZmVqSmdxKzNTSmxVYStqOGpCdnpTZFg5a1NCQ0JCU3JVcjg1a3czQUFiR2Nz?=
 =?utf-8?B?L3Z2R29pYS91VUFaTjlGL3pWbjZncE1UZHU4RnZxanlOVHpBTkY1T1B1RFp2?=
 =?utf-8?B?azdXRXR3c2NxQ2Z5OTJVWHR2Qk90SGY5Q3hoNGNGY1orL01VSDJ5cnhoVW1l?=
 =?utf-8?B?czBxUmQ0MC9yNEYxYi9OTjliRXlXNzdLbnZocUUwd1MzN1VJTVRVOGhxaERJ?=
 =?utf-8?B?NWlOVUZNOVBHc2NPNmsxbWU2ZXRBdHcxOTAvZEYxUVJxem5JWTZsaVNGNG5t?=
 =?utf-8?B?Q295M1N3MjZyWkw3dWhDUG5YRHVPczN3UlF1eUNkVFVNTjBCTlZrZ2R1Nkl0?=
 =?utf-8?B?bzU2UlBsMGNheC8vVTVWQy91VW5tdnR4TnpFa0NGNEc3OE9NOVVVendRV1Jv?=
 =?utf-8?B?QWZGV3hZMmdKbkxKYjNQVVA2OExuZzV3cmU2TEFBN2gyNXhsNzVTcitnQkEw?=
 =?utf-8?B?K0svYlJqZUNyWGEwWkh4VkkzbHUxaXhrWTJ1dGhpY0Z5cCtDWTFsaHdxQmxM?=
 =?utf-8?B?OHE1WXRSUk44ZWF1RVo4WEcvLzlKa29FR3V0b1ZvZTE5ZURPNWxHaDF6bWdm?=
 =?utf-8?B?Z1VXTTFDZm9rcWRNaDdweXluR2gxa28zQk5lbG4rM3V3ZU9lQjBTSUdlRlNK?=
 =?utf-8?B?bGJMN29PbWdHVThSeDVGbnZkanpKaHA2RnZBS0JJYndIKzNEQVBrTHRDQWdh?=
 =?utf-8?B?cExKdytIVkIwajU5WnRzWldDVnRDYU93NDNFa3d1b25jdWdaMGh6Wi9STXdm?=
 =?utf-8?B?eFNRNmFYN0NWYjc0cWYvYVRvdkdXcWFTSEF0NEdlaytyV3JaRFNoc1NPWnhn?=
 =?utf-8?B?VWJYWVNiNlFHK2kzdDVXVUJBYmRDWlBJZkpDZnhzUDZnTXNvY2JZd2sxd0lQ?=
 =?utf-8?B?Y0xWT3ZSUm5iaUIrME5PVmdWa2I4NUxaQTV0QzZLODJMYkFkTEovZnNQa1h3?=
 =?utf-8?B?RE1abTNyanRjU1BGNTkvUm5XSUdINWRqUWlCelEyZithNWJMZzdkeWtBN3M2?=
 =?utf-8?B?cVR3TzRwbGZPbSsxMjM0c3RDcXhmVGp3UTdBNEJvcVZSVFoydCt4NjI2ME8y?=
 =?utf-8?B?anpaZmJ1V0ZHb1YwSm5PRU5DQUlYMjR4YlpUWFJYSnFDSktXTHQ3N1JYb213?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c22e3c-8b9d-47a1-d4da-08dbd63ce36b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2023 16:02:00.6551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rv+EoB823cMVGpv7BK8hV+1tnPSnKLzjSaoO2Uq7UykZphR0lRxW4aCbu+d5mqsDs6iyaqbSuHQy4qm5inbiycrC4E7ZlCJEvXsKMN1mlNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7497
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 10/25/2023 4:58 PM, Huang, Kai wrote:
> On Wed, 2023-10-25 at 07:31 -0700, Hansen, Dave wrote:
>> On 10/19/23 19:53, Haitao Huang wrote:
>>> In the EAUG on page fault path, VM_FAULT_OOM is returned when the
>>> Enclave Page Cache (EPC) runs out. This may trigger unneeded OOM kill
>>> that will not free any EPCs. Return VM_FAULT_SIGBUS instead.

This commit message does not seem accurate to me. From what I can tell
VM_FAULT_SIGBUS is indeed returned when EPC runs out. What is addressed
with this patch is the error returned when kernel (not EPC) memory runs
out.

>> So, when picking an error code and we look the documentation for the
>> bits, we see:
>>
>>>  * @VM_FAULT_OOM:               Out Of Memory
>>>  * @VM_FAULT_SIGBUS:            Bad access
>>
>> So if anything we'll need a bit more changelog where you explain how
>> running out of enclave memory is more "Bad access" than "Out Of Memory".
>>  Because on the surface this patch looks wrong.
>>
>> But that's just a naming thing.  What *behavior* is bad here?  With the
>> old code, what happens?  With the new code, what happens?  Why is the
>> old better than the new?
> 
> I think Haitao meant if we return OOM, the core-MM fault handler will believe
> the fault couldn't be handled because of running out of memory, and then it
> could invoke the OOM killer which might select an unrelated victim who might
> have no EPC at all.

Since the issue is that system is out of kernel memory the resolution may need to
look further than owners with EPC memory.

...

> 
> (Also, currently the non-EAUG code path (ELDU) in sgx_vma_fault() also returns
> SIGBUS if it fails to allocate EPC, so making EAUG code path return SIGBUS also
> matches the ELDU path.)
> 

These errors all seem related to EPC memory to me, not kernel memory.

Reinette
