Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB8CC433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jun 2022 06:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiFHGBC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240512AbiFHFxF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Jun 2022 01:53:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069B321CBC6
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 20:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654659903; x=1686195903;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1D+vQPajUC1GTICK855r++U5nU5d6OFbGJC8MGjFND0=;
  b=Zg7Xbpin59ASWFckUNH5Or9hLM3I2hBGfGkhMcBSrpwhG9MF+7ZcsoIQ
   +CX9ne6gGQRkol7F9FROQxBAShPBgMz3RMcaFrUT1VoEA+WTXkvU+l7+r
   ouxFlWuXXR1J3ojwajbf2qcqOI6Tg+8c01yyuAPhRfhAEK+eN6OJCsr++
   r4aOkvzKsEH+0/lIjcQDykW0pY9fAvV2yM9YCaJMiTFvSpOXlW5TCHsDd
   SIV/Zr+UMSwCoRgJMbVomnLUwRNMwnC8bXutDjxRj1ypFPDM3pB6Q+SyA
   op4kcrbdmBg33fHKbNMhm/BeKxBf10MKDfxlm6U8LLPtE0p1ukeP5o9f+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="276821977"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="276821977"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 20:45:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="709769027"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 07 Jun 2022 20:45:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 7 Jun 2022 20:45:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 7 Jun 2022 20:45:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 7 Jun 2022 20:45:02 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 7 Jun 2022 20:45:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0FMqT8P7W1naEoxwyBU2VFkTbku9+ADHqsgUMXURUTZ4lF85DHQE1hcs6XkSw38g3+2E1vKcZ6nYjJASjx6TPTK04NfFu9L+r1YaTOSoogzbqa2b+4eBiBalUbMfnGkoapZLGK5EHs2kVv1Pz2IuILS6F86mQ7jlxV5VC+NLHF+C1qYKiIgBv9sDJKu1FoLnslyCkOZ+GdBYpe4ze6GdyJopOm9Lj3eztu+DPx+EBL42tgtDhByNDWgAakzLgQmz4eTLJjjfnAnRribm7UHVM3nhj/Tdc59mQO2TovPlq+l/53hE0X5oBsqOZN8L8vlFzaEsqllRLYOpGA1JM98zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QN8NM6JwRjaUFI77xbHvLYU3Qt8w5qBGqIwQyjZxavM=;
 b=TMIcPpnEQrHFYInCUCVS9xhI8GW1AoMZeAq0aeBZQnRbhcRQihSzR8XaGpOuRRyw7tN8NB/VgDZDGCB7TVphm4ysqPxMOXHt+KVFsTGLjNos72TLLAsHMTTzydh/dBuOh5bG9yS6sZvPCEB+LkswLBJ5e22Za+o+B47Zc2bJT3hZLavN7uUlgSxS8yHXHXgnHFrgIt9QEKiDSqhkHx5kutD7ATn0lyFNcwzeHXXCcvIMUlcwoiydoH+506yyVHoLEnEyLJvBglne5RhYCWCKKT9a/PKOTbYtHUy8/dPSLek+aK1fceyv1MGCUQlqotgQ3Lsc+KAc8v0PTSJZ5IL/YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by MN2PR11MB3567.namprd11.prod.outlook.com (2603:10b6:208:ed::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Wed, 8 Jun
 2022 03:45:00 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::a988:feb4:e85b:3f73]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::a988:feb4:e85b:3f73%7]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 03:45:00 +0000
Message-ID: <ffdcf3e6-b7ff-2629-e40c-77bdcf058801@intel.com>
Date:   Wed, 8 Jun 2022 11:45:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 1/3] x86/sgx: Repurpose the owner field as the virtual
 address of virtual EPC page
Content-Language: en-US
To:     <linux-sgx@vger.kernel.org>, "Zhang, Cathy" <cathy.zhang@intel.com>
CC:     <seanjc@google.com>, <kai.huang@intel.com>, <fan.du@intel.com>,
        <dave.hansen@linux.intel.com>, <jarkko@kernel.org>,
        <tony.luck@intel.com>
References: <20220608032654.1764936-1-zhiquan1.li@intel.com>
 <20220608032654.1764936-2-zhiquan1.li@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <20220608032654.1764936-2-zhiquan1.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:54::18) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d8e61db-635a-4926-dc11-08da49014362
X-MS-TrafficTypeDiagnostic: MN2PR11MB3567:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MN2PR11MB356791366C3F60B770074F1AA5A49@MN2PR11MB3567.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1+TKkJ8yILD528FN4dc5VYq2TG2QW9iZA0cB4kh6ckuE8oXkIJVVR4j7TvYSy0Vq6w/npc6ohpllJNSU+iCCmuIHvKDpbWWmC1hXDvY1aXqbGXkd6SnIboj5hewsM5ddvkLezAsXnGnydUY+9bTuXya0J+NJv8VB5wuO4+1d/OImonMKtv+ammSn51AqB17AoES+v/6NvH4usJMeCgsS/YesMmOWN0QZquykwZAFaI5N6gu1/SyXrO4e734EyfyhcPQL9OFyGAwno8jv83dQK0N30P79EE3tocWKVZUR47+eJlZSyaYej3KJOc21Up2eplC+CbfExiUVExlPKMoy1zNyVgGqDOuvD8Xui09agGUu+T3FAdOw6o/MU0gCgXNzMD/voATuCKpML1L3zcUhSNFYfLpGmit6/VUUIoqvuxTys+W/bY3KbAi7eY2ElVluDd3C+nWfZ91sMyyIW0G+OXe8lFmu7CcOdOtcYsONaATbD4IJEhcq2I6uxDk4OLE/Yt6zAdzOIvHlglh2UwMyZG40AykqPM9yjEHv4jg5YojyU5QbH7B0s/4d8zzeEgy7yB8wtTLzXLIHK2LQeknmDdSjEai1e/Sx99pevybShRxkHL46zZ3+a9JBNDGuSusiUE910617YsE6SpP0w8vIdtpDr6a+QUbU0frTdnHICGhKJsU55tiqrkAhQO+172KXeo/wE2BcWRJ/giAKfOQVQpOJUEADbpcx/qy5mxf9l2DDSVt79ECHbGWh/XoG2DAj717rsJKnuajK+oV/jL6J8tUShl5Mppw1nluLFKqBz1aaO5HiryLHlzzk/KwPiRpq03tjDf8XoXj6HT11N2jISlm14adkZ9ywQCN1L9IYl8ObYJvxI6Ab8Nh2DY9czuk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(37006003)(316002)(8936002)(6512007)(186003)(6486002)(2906002)(966005)(508600001)(83380400001)(6666004)(36756003)(66946007)(2616005)(66476007)(38100700002)(6636002)(31686004)(8676002)(4326008)(53546011)(26005)(82960400001)(86362001)(5660300002)(31696002)(66556008)(6862004)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXN5cFZsUnBBc05OR1ZsaE40U2h6aWp6aGtGR3prUkl0YVdUS0ZZREF2cTJT?=
 =?utf-8?B?WktpT0loTFFiRTZTZHFWUWRDZkRzNzNuWlJtaVcwQ0tuREJxZ2FiaEQyWUNG?=
 =?utf-8?B?RmE4bU9lWHJ2K2UxZjZsMnYzSkpwRTJ3NGFPZzhuN1BHZGs0MG1vWjNWR05I?=
 =?utf-8?B?Q3oxUkpUOEhVWVZzWWo5eDhHNUZFRDcwUzNEVVdPU3hCL2tqK3JmaHZIMzNp?=
 =?utf-8?B?R2dJMkxweGRoWnZYbDNYMmFJRVBtaXEyVjh5S0NjK2xvaCsveWZvSGRVTWRS?=
 =?utf-8?B?UjREdnhHMnpiTkU2dVhtWXVRaGNJMlluOGwwMVU3QnNybG55alJCVktRaU94?=
 =?utf-8?B?aXBTWG5sMWtNZ0FHVnpsRmVVWXF0bDA3S00xQTI5K0F5THpEb0lvUC9RZWQz?=
 =?utf-8?B?SjJrQ1lJL2RMN0Exckp0UEZKR1ZvZjQzUDJ3UDdkNnhvTTVpd2gvcHBwVFRk?=
 =?utf-8?B?aU9xRFJ4M3kyYkZyVlJDM0NLSnRLTnFta2ttNFRWVkk0dStqbHhUdHFweVpW?=
 =?utf-8?B?OHRyL0VrSEE0cEtyZllPcW1RWEI4V0puUU5tUEVYOE1STUgzdFNNeithU3Ew?=
 =?utf-8?B?akdEMmlld2hVcW0yR3ZieG8rc1NFM3lTNldZcWVYY2hlTDFuSDMwSEJNd1Zp?=
 =?utf-8?B?bmZkYnNyK3VwdGpMUi9zcE5URmVZZVY1RVRlUzYwYmpsbWJ6TzRlS3IxcFlv?=
 =?utf-8?B?MzVuOUQrT0k0bXZ4WWJKa2MyU29XM1JCUFQvazlLREtGb1J2YXl5VnFjb1kz?=
 =?utf-8?B?eCtHc21hUWNETXRraFF4cXVpOFFKZVQrNm80M2xWeXNxRnVSSTRPTEVBT2dN?=
 =?utf-8?B?Tnk4cXh3VnZsR3pCck44N3JBaE4va0JaNXFPWHFiMVdiaGpBWjFHV3FFZUI1?=
 =?utf-8?B?cVIvSVkvU2hKYXQrOFJHaVFFdm45UDNCTEoyWU5TZDhvcTRYZGZ1YkJ5Y1J4?=
 =?utf-8?B?ZklzdW5FUWN5bHVXOWZadTRXc1ZybXpLa1BacGNxeDlPbzFoczduNmZUNWRH?=
 =?utf-8?B?TVZvazNQV1hjVCtPSGNaVHc0aUhmOGxuQ2VxNFRGcjFMN1p2a2twU1JiZ1JC?=
 =?utf-8?B?UVA5UWhDV3NhdWZhYkhpUWwrMDluNjhmVGxyR0I2ZWE5Smp5dWg3dFEyb1py?=
 =?utf-8?B?WFVMbXYycUdSRGRxbXZsZlpHcXFSTG5qVFVCUThLdjZBOFBuT3I3M1pPYktv?=
 =?utf-8?B?eVYzVXA1bVduMFBqdnN4TXFuS0tNMHZVZ0c2Y25Ia0ZQSWdSdklDSTNBdUI1?=
 =?utf-8?B?TWdrSVVRU0NnRjJod2MzTkhOYnNyY2pSeFp3NlRqOU4wa0NsY3pxZTc0bEEw?=
 =?utf-8?B?SW9HL3dRRG1OSHNiY2pnbjgybmJHeENJa00xc0dDRU9TUFFjUUtIODdOV3ZY?=
 =?utf-8?B?TE5xQUJONGJsaE9aUTl6M1hjcWQxK1RkZ2p5UFdMYlNCSDd5YjgzRkRuNUpK?=
 =?utf-8?B?SnZITG5tRCsvVGNNa3ZWb0RhRkRRVjhPWFdMZFpDWFYxeDNUQzQwU2JMU09o?=
 =?utf-8?B?blZFOTlnRzc3ZFFaRWNwNDJlVUxLQlo5bzFOdG1yZmRtaFhQZFZLZjRoTkZ6?=
 =?utf-8?B?V2FZSGN2bWtHcEV1a2VXY3NOWldDODMvem5yTy9xZitFWUtVNjhpOVVBM1ky?=
 =?utf-8?B?Q2paSXlMVXlTaEpKenBlbnBLWVNjemdrNDFOcUlITlUwTCtYNGd0MGFiL3lS?=
 =?utf-8?B?Wk9WQ0R0aWI4V2dndjVZcGdmSjR0UzJiTHlNcVdBMTYzRFZRUzZnVDE4Y1FX?=
 =?utf-8?B?VDBvckVlQ2JqaFRmN0xyaVVpL1djeGhkbEZJYkRiSnFLRGJyWXlHRktqSkZn?=
 =?utf-8?B?eFhOM2VDN1dBOFAvWUVlNlB6TjZ0NzAwU0xGOHd0SWtJNzlBTmg1bytieXRX?=
 =?utf-8?B?eDI4SkZidUlNL1pWaW44TmtONisyYWpLTk1LNWR0QlU5NTFjKzhsVG01OHZu?=
 =?utf-8?B?VDFLVm9mN0lSaXNQWGI3ci9qZkFkZTdtYytjcWRMc0hGbDNVUzlkUHBQRjMy?=
 =?utf-8?B?UEwxTURCZGgydXZkdERrV1ZuZ29sNER3dkJkUUtsMnRiTGI2cW41di9rcERH?=
 =?utf-8?B?WDJTM3YxOFNNRWR5Y29PWXZWUWFpVHNIc3NOenQrVUplb2hhYzVmTzd1TmxC?=
 =?utf-8?B?cHFqd3UreTloNnVrMmR2N0dITzh5dlVURC9DT0FzYmdlbFVNR1FUc0JQZWJv?=
 =?utf-8?B?ZUNZaS9Xd2owVThPcFNISXYwckRQQnNzdEJZcW9RQ2lscnNsTzgyMnZmMTho?=
 =?utf-8?B?NGxVQ2F3bG5qTTYvVXJRSzV2YzFIKytCZ2ZEZ0R5aDNhckZuVkhadVdUTjZO?=
 =?utf-8?B?UzRnREVZVmlGVmY3MHJSUlBqWStiZXlqbGs2elNjMkNNUjJuWEdPSnJDK0Ni?=
 =?utf-8?Q?RG0le0wpjjhlUBZs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d8e61db-635a-4926-dc11-08da49014362
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 03:45:00.4443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cAN3Rnm2fwpHvuKXeUm8ZlD0yQ6QWFSrX7eG5cO6wsybHjKd/g5cJh/ZB5tWOpIpixQerk21g0odOZxzpFR93Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3567
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2022/6/8 11:26, Zhiquan Li wrote:
> When a page triggers a machine check, it only reports the
> physical address of EPC page. But in order to inject #MC into
> hypervisor, the virtual address is required. Then repurpose the
> "owner" field as the virtual address of the virtual EPC page so that
> arch_memory_failure() can easily retrieve it.
> 
> Add a new EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the
> meaning of the field.
> 
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>

Hi Cathy,

I forgot to add your signature here.

The flag SGX_EPC_PAGE_KVM_GUEST is taken from your patch:
https://lore.kernel.org/linux-sgx/YoveWpEsH6Hghc5Y@kernel.org/T/#u

Can I add "Co-developed-by" as well as "Signed-off-by" for you?

Best Regards,
Zhiquan

> ---
> Changes since V3:
> - Move the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
>   Cathy's third patch of SGX rebootless recovery patch set but discard
>   irrelevant portion, since it might need more time to re-forge and
>   these are two different features.
>   Link: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170
> 
> Changes since V2:
> - Rework the patch suggested by Jarkko.
> - Remove struct sgx_vepc_page and relevant code.
> - Remove new EPC page flag SGX_EPC_PAGE_IS_VEPC definition as it is
>   duplicated to SGX_EPC_PAGE_KVM_GUEST.
>   Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u
> 
> Changes since V1:
> - Add documentation suggested by Jarkko.

