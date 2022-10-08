Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C66C433F5
	for <linux-sgx@archiver.kernel.org>; Sat,  8 Oct 2022 02:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiJHCYG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Oct 2022 22:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJHCYE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 7 Oct 2022 22:24:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F77127BC2
        for <linux-sgx@vger.kernel.org>; Fri,  7 Oct 2022 19:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665195840; x=1696731840;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZqmEiT+5EwpJaFvk9xIGSH5ub6b2tB+SwDdVzD8fHAg=;
  b=I4ZfHiw7SLy4snyzysVVOa1gTIC0X29y/AEoV/yPQyKkFYyGKt5k8ibD
   6Lfhz0n1n69iYEQXlo+D2GYNgz1QvXu2+fHE+DTAX24U8gZ6X/Da4oeyj
   Ubzus/z0N7shy1bUQiWl9xnfFesvsHYPwvGmX8rHHJRO+lrXt2kiuIpj9
   2HCB+S28fVP+DfCyqulbsOVW1Y2dsmCw78CnlcrTh4Wufh8nZbrrq3l+t
   unGMKJHYxUvpZ7h/rGY33jvH1SkMlrHdUcT0QTyEj0YcjBnDfAumLBqRK
   FZLbeOdcI2yK+SQu2mODvocydk/+aj2NuctnBD7ZBkkzmJ1mi9w5o3dbC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10493"; a="283603272"
X-IronPort-AV: E=Sophos;i="5.95,168,1661842800"; 
   d="scan'208";a="283603272"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2022 19:23:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10493"; a="620446502"
X-IronPort-AV: E=Sophos;i="5.95,168,1661842800"; 
   d="scan'208";a="620446502"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 07 Oct 2022 19:23:59 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 19:23:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 7 Oct 2022 19:23:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 7 Oct 2022 19:23:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLGw47W63qiRZIzH8qJ+sBfaxpcRMfHLhfmGDxOHUBONGwIrq72YXccuSJsT1LzdxH8XWplBCqK8Jy3U9GPlsn+lKpYFVfxfBJzATxNOhv+MjWb1NboG3/svjVyI9DLevPp9OMDVwrg0M7WDWvH/uo27cZXpFmuzO9ukfXLdktupXRhtmV79YArCNEXGXQt3aOd+Wz+PHRjmeIk+KsGBhqlnl4sGDMqGXaJ/e0G9Om4zbsCrxaziP25PjQK9ieKmyKmkBOby9sTa7tC3bc801ONnrMH6jsxh7CgcchUggt6Y9IZCDPddie88m5JM8Ek3n8NAs0NGNJVBBOciL5y1rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+EXfVBm0VQCC6JD5YaAYtOn82FmKpXRd5gSFqnhEFI=;
 b=O341SSVpF/wyMKw1mAwH83bBaCCudNjBmNiac369CCA/tBGjrzMsU/Bj33nrquX3tLYIMpGgJz4aKZE54gOaMk4sOUF0QxsHo4XbfkN+3P7FfhYwlPhlZAapdFQH6pqRt75/Tzl5jSFe7pQJorGzT4zajMbJY0uFT4EowJx8rTWctrrTRDnAVSzVIxhl6zSpcWaxmhQyTRaLqTkOcSrehNuN4ikThkgzeP7kT278xukIBc0D+T4CMCSYhGhzlfxtZjFBD8U+HTaygGwTpyHy4JZY2pV7pS9BQht+CHH8Y+4XQe72KNLnCpa87f7THaxE0fnVAMdBveOsRrQmebU/Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by DM4PR11MB7398.namprd11.prod.outlook.com (2603:10b6:8:102::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Sat, 8 Oct
 2022 02:23:50 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e%5]) with mapi id 15.20.5676.040; Sat, 8 Oct 2022
 02:23:49 +0000
Message-ID: <2d52c8c4-8ed0-6df2-2911-da5b9fcc9ae4@intel.com>
Date:   Sat, 8 Oct 2022 10:29:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v9 0/3] x86/sgx: fine grained SGX MCA behavior
To:     <linux-sgx@vger.kernel.org>, <dave.hansen@linux.intel.com>,
        <bp@suse.de>
CC:     <seanjc@google.com>, <fan.du@intel.com>, <cathy.zhang@intel.com>,
        <tony.luck@intel.com>, <jarkko@kernel.org>, <kai.huang@intel.com>,
        <tglx@linutronix.de>, <bp@alien8.de>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
Content-Language: en-US
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <20220920063948.3556917-1-zhiquan1.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0022.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::9)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|DM4PR11MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c6d93c3-0d55-4e38-a0b2-08daa8d42255
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w9ZKPFnPsUAqY9YZkTnZhH5bz8+KOg9W6uJCthktdHm7HXQJl3A/161uLQq+C8vriHz3LKUmhhwB3KtGQrRUKAvCp4RiDya5wI8RoycJKuLS5mrT1mNKO6P2CA3KrjXHC6vIPJv0xlrMJeQYthBeukACq8Hga98lKG9n7qDWSjP93uBAi+yFJk4xhHvdkdjAx5E0ZKNrV9vOLrvYWQg17rsvF9JHYOIqN2MkzaJJs4ZquFsLYj9WHUYTkzHO9tWn71mosIRRryQQKERvWbbFlZ5y0UGTRwfptS6XKLtbITSL9WpSqFP/IdBDGBqOoVGElQ4N5nYX4n+jUS+XbnQP1VXRTsFwfM4rUxscQuRXLbHscVO1/6w23/yKNDyPvKm7Y8HFTMRARnXWdW2ospzgB276OteSFkj9c1q7udd4wxcORvk8AZ430iToKzdy2C+X/lY8nj99JiAj2iSn8f1d0ovN3LGmbdbSx6rN0Pji2tGtwD0rzigEv8tebo1VH6UVemAgcbHCPHHBI7bY7AQ02yPEEf3zYa9S31xsKMWddCpRgfj4D/GU4imyuTdTMkVbA82sSYcSpOgzLtuNlTfx2cK4NCibRyIoWhnKPwyS66bzTbqZ1i10YNws88SBSHZ+nE2S2qflkeW8kNT0FgMJKHNmiMJRID+m045kpBjtsq6Yv8itaObrU8D1AovEz+SxcdfOjybKNMIWjJyfjui7/VjNsy8+HM2WFKS7/eJ9wxV/1lx5zJTuq3BcJ7nggMM660POlv8FxwIVpCs6j1Rl905HnKjThfQ5nAeIxa77wHLqb1Z10i5Ty+8FEQkjbdz4vXboTYAdtAeQoPoDvTxZWT4V5VImblSZ/TTqpfGpPJQJGxhiErrV+URRN4Q40P6K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199015)(2616005)(5660300002)(2906002)(6512007)(4326008)(41300700001)(6506007)(66476007)(8676002)(8936002)(6666004)(66946007)(66556008)(82960400001)(26005)(316002)(86362001)(186003)(38100700002)(36756003)(31696002)(83380400001)(478600001)(966005)(6486002)(53546011)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlE3VWlFK1JZZ0QzelJCVlREOGc1SStXaW9qVENtV2hOa05MQVRYY2NhM1Vu?=
 =?utf-8?B?M2ZucXplRHEzS2JPSzBIUGF0akdObDVucXovOHp6bDhrNnh2MVY2VTYwMnB3?=
 =?utf-8?B?WFQzNUNwQlpxTXFXZmVVTm80K3FMZDV5OURYejB6SEt2U0d4UXl1a0FnVFBI?=
 =?utf-8?B?d09jdDNKdEo4bWNhU0NLZVZHVFNOS2s2a28xRnhBa0lTcFFCeDVpQUxUenY3?=
 =?utf-8?B?cE80VlFRdk10TFM3bUhVdTI5RVpuZk9iTVlKWnJGOFl1RGVMZ3FFL2U5Qktq?=
 =?utf-8?B?Q21WRFR6ZE9pNU1XQXdQUHFmM05zOEhiemM1RWIzeG9SS0xqSlVoQ2pRYkFX?=
 =?utf-8?B?TkNiSzNoWkxoN1k3eTZ6OVFvcXdvZGNvTENlR3Y2dm13K0I2MW8vTG5uYjJw?=
 =?utf-8?B?UjJ2cnlNRVhpTEtNRFliNjg4c2tySnJJaXVGdGhEd3htNkgrR0JTRXB3Qmdx?=
 =?utf-8?B?UVVjb2JzNzZ1SlU4V0F6WTFnbVB1NFlqM2pVSi8wRWppZUxaV296UHZQc0RO?=
 =?utf-8?B?SWlQaVFuNDMyWk9JUFFxdm4zdDd6cnJCcmR3MG5tNU1XVUVibkZZOGg3RE1D?=
 =?utf-8?B?a3FoaHp1VUtwMCtRK3U4TW56dkV5aFo3OXBleXRtTXBNb290VEMrcFd4RWlE?=
 =?utf-8?B?WXBEUkk5Ty9rUWRkTmhRQ2tzdFU3ZzIwWEcvdGNZd215ZGZHTnlMVWZJVHRC?=
 =?utf-8?B?cFRpKy83bVlvOGdweDRGTE5OMXo2NUd2aUtjMm1FeVZjMm5pRFhjUllkNjl2?=
 =?utf-8?B?TVJCcWxRL3pCWDBqYjNOQ1Z0YUdMK2s0dVJkZ05lTnJCK1hZK0FFY0gvUDRp?=
 =?utf-8?B?RDJqZmFzRGJvcUZBSDdsV3J1cGVJbk5pWHY4enpYR2hMbGpEY0h2YjcwRkxY?=
 =?utf-8?B?SE5KYzdqaWpJbWlrMElsNnBKOFZtQzJ5eGk0Qlp4ZU5HTU5ObmozbmdpWU9y?=
 =?utf-8?B?OHhQWlJoRDM3K0w0ZG9mQ1N6UnhSbGdHaVVwZUdzTFJCdmc4OEZ5dXdrUDFo?=
 =?utf-8?B?VUtacFV0THlxNWtkOTNuZVJscEVBdVZhTklCUHNMTHVEWmhVbHFKUFdWOU9O?=
 =?utf-8?B?YncrY2wyTkV6d0RrSngvMEQ2cHgyRVpkOUpUR1R0ekxDSlhQczFGbDc5S2hP?=
 =?utf-8?B?M3dwdnVMWGdzSUpVRFdhM085amZSU3QrdlZiQWJJczI1NXdrUGF3VTF0bVpP?=
 =?utf-8?B?Mlk4M0xTY1RZcGRNWVR0Z2V3MWdIblVyL1h6S1V0S3VPcWpGdXBaaUF4YlRI?=
 =?utf-8?B?dzlHWTB5TERWR0pRM1RmTk5YZ0gzUGVoenRRSFF0ZVNBMTJmNDJMbkx2OWt4?=
 =?utf-8?B?ZHRnRFBUWXFPcldzdDk1Y3EwRXhXWlM2c0g0YXM2M2lQOGxNYUFsL251TzNI?=
 =?utf-8?B?TmVwamJqYmR3RXRHbjVtcTRSeEI3WXg2Y1BPaUt1Q1lFNi9QbnRCRitCUWJx?=
 =?utf-8?B?d3JXWWxBSEdvNWhOSFN4Qk1JY2tPZStHNlpYak1JeU9FbmpZNG1TeFdpd2lF?=
 =?utf-8?B?eWVKRXp1aktjVjJTdkdXNWF5enlwc1JGQm5GQTZRZVRkakt2Z0lFUkd1b1VD?=
 =?utf-8?B?WkNHTmtYYzhmSS8zcE5Gd0VkNGVXTXh0YXEydnpnRmRxbWxYamgyUW5BQVEr?=
 =?utf-8?B?S3JldWlLUmxxcDZzYy9uRXUrT3owV3FFZ01wWXpUZENBMVVGU0dVY1VUWTJ5?=
 =?utf-8?B?bzRHZEt3WUt3VUx1c2lvcm1nRmFUSU13cVV0TmEwR3pXNHhKMlJNSkZVVVY2?=
 =?utf-8?B?MExDanA3cFV1UHFYODNqZE9qUGpRVUJYWlhMVW5JVVI5d3ZTenE0L2o5NEtQ?=
 =?utf-8?B?cUVCOUhmSERpQ2J5K0RoSThOcUV4RjJUc3l2ZlpkNnZSdXlRUmw5Ymg3aExL?=
 =?utf-8?B?eDU4NFFvS1lIL3Mxakt2R0dEN1dYWXAxWVlLMUY2WEhSQTJaTU5OVTNuazZx?=
 =?utf-8?B?QmFBV0ZjdjRteTZkV1FrRGN3b08rTlZ0aDA5anA4TzdGNlVSeVlDM040TjlV?=
 =?utf-8?B?RG5BdGJXQ1I0ZGN5eDc0MzNEaEJqdmtpd3BoeHNvOC81NDdPOXhaZjNlMzBw?=
 =?utf-8?B?N2hoN3FXV3k5T1JTT1hwaS9HQjVxUjd5NTBpYTRhd2hiMnNKb2NGdWtjWmRz?=
 =?utf-8?B?bXJKdmdkMjhLMFJUaG8zNGNSZlVBYUdPci9TZ1l2WlIzaG5GempBNUZqWXVX?=
 =?utf-8?B?RGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6d93c3-0d55-4e38-a0b2-08daa8d42255
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 02:23:49.0479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NzaqWeQj5rVY7TWq17NF+/akLQIbeNeMZhYT/0KGunrYVqfa2b/vDTUqUue37fBqVjXbjqyLP0uE2vsqzMW5Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7398
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/9/20 14:39, Zhiquan Li wrote:
> V8: https://lore.kernel.org/linux-sgx/20220913145330.2998212-1-zhiquan1.li@intel.com/T/#t
> 
> Changes since V8:
> - Remove excess Acked-by from patch 02 and 03.
> 
> V7: https://lore.kernel.org/linux-sgx/YxEyRT2SbfBdYNfm@kernel.org/T/#t
> 
> Changes since V7:
> - Enrich the motivation for renaming in commit message of patch 01 with
>   the explanation from Kai.
> - Add Acked-by from Jarkko.
>   Link: https://lore.kernel.org/linux-sgx/YxEyRT2SbfBdYNfm@kernel.org/T/#mc1c93e7d9643588b27cefa9540f988a070469b5b
> - Add Acked-by from Kai Huang at patch 01.
> 
> V6: https://lore.kernel.org/linux-sgx/20220826160503.1576966-1-zhiquan1.li@intel.com/T/#t
> 
> Changes since V6:
> - Revise the commit message of patch 01 suggested by Jarkko.
> - Fix build warning due to type changes.
> 
> V5: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#t
> 
> Changes since V5:
> - Rename the 'owner' field as 'encl_owner' and update the references
>   as a separate patch.
> - To prevent casting the 'encl_owner' field, introduce a union with
>   another field - "vepc_vaddr", suggested by Dave Hansen.
> - Clean up the commit message of patch 02 suggested by Dave Hansen.
> - Remove patch 03 unless we have better reason to keep it.
> - Add Reviewed-by from Jarkko.
>   Link: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m379d00fc7f1d43726a42b3884637532061a8c0d1
> 
> V4: https://lore.kernel.org/linux-sgx/20220608032654.1764936-1-zhiquan1.li@intel.com/T/#t
> 
> Changes since V4:
> - Switch the order of the two variables at patch 02 so all of variables
>   are in reverse Christmas style.
> - Do not initialize 'ret' because it will be overridden by the return
>   value of force_sig_mceerr() unconditionally.
> - Add Co-developed-by and Signed-off-by from Cathy Zhang at patch 01.
> - Add Acked-by from Kai Huang at patch 01.
> 
> V3: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#t
> 
> Changes since V3:
> - Take the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
>   Cathy Zhang's third patch of SGX rebootless recovery patch set but
>   discard irrelevant portion, since it might need some time to re-forge
>   and these are two different features.
>   Link: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170
> 
> V2: https://lore.kernel.org/linux-sgx/694234d7-6a0d-e85f-f2f9-e52b4a61e1ec@intel.com/T/#t
> 
> Changes since V2:
> - Repurpose the owner field as the virtual address of virtual EPC page
> - Remove struct sgx_vepc_page and relevant code.
> - Remove patch 01 as the changes are not necessary in new design.
> - Rework patch 02 suggested by Jarkko.
> - Adapt patch 03 and 04 since struct sgx_vepc_page was discarded.
> - Replace EPC page flag SGX_EPC_PAGE_IS_VEPC with
>   SGX_EPC_PAGE_KVM_GUEST as they are duplicated.
>   Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u
> 
> V1: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de76@intel.com/T/#t
> 
> Changes since V1:
> - Updated cover letter and commit messages, added valuable
>   information from Jarkko, Tony and Kai's comments.
> - Added documentations for struct struct sgx_vepc and
>   struct sgx_vepc_page.
> 
> Hi everyone,
> 
> This series contains a few patches to fine grained SGX MCA behavior.
> Today, if a guest accesses an SGX EPC page with memory failure,
> the kernel behavior will kill the entire guest.  This blast radius is
> too large.  It would be idea to kill only the SGX application inside
> the guest.
> 
> To fix this, send a SIGBUS to host userspace (like QEMU) which can
> follow up by injecting a #MC to the guest.
> However, when a page triggers a machine check, it only reports the
> PFN.  But in order to inject #MC into hypervisor, the virtual address
> is required.  The 'encl_owner' field is useless in virtualization
> case, then repurpose it as 'vepc_vaddr' - the virtual address of the
> virtual EPC page for such case so that arch_memory_failure() can easily
> retrieve it.
> 
> Suppose an enclave is shared by multiple processes, when an enclave
> page triggers a machine check, the enclave will be disabled so that
> it couldn't be entered again.  Killing other processes with the same
> enclave mapped would perhaps be overkill, but they are going to find
> that the enclave is "dead" next time they try to use it.  Thanks for
> Jarkko’s head up and Tony’s clarification on this point.
> Unlike host enclaves, virtual EPC instance cannot be shared by multiple
> VMs. It is because how enclaves are created is totally up to the guest.
> Sharing virtual EPC instance will be very likely to unexpectedly break
> enclaves in all VMs.
> 
> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
> being shared by multiple VMs via fork(). However KVM doesn't support
> running a VM across multiple mm structures, and the de facto userspace
> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
> this should not happen.
> 
> This series is based on tip/x86/sgx.
> 
> Tests:
> 1. MCE injection test for SGX in VM.
>    As we expected, the application was killed and VM was alive.
> 2. Kernel selftest/sgx: PASS
> 3. Internal SGX stress test: PASS
> 4. kmemleak test: No memory leakage detected.
> 
> Much appreciate your feedback.
> 
> Best Regards,
> Zhiquan
> 
> Zhiquan Li (3):
>   x86/sgx: Rename the owner field of struct sgx_epc_page as encl_owner
>   x86/sgx: Introduce union with vepc_vaddr field for virtualization case
>   x86/sgx: Fine grained SGX MCA behavior for virtualization
> 
>  arch/x86/kernel/cpu/sgx/main.c | 48 +++++++++++++++++++++++++---------
>  arch/x86/kernel/cpu/sgx/sgx.h  |  8 +++++-
>  arch/x86/kernel/cpu/sgx/virt.c |  4 ++-
>  3 files changed, 46 insertions(+), 14 deletions(-)
> 
Hello Boris,

Could you please help to take a look at this common feature which is
asked from CSP customer who has deployed SGX instance already?

The patchset had gotten ACK/Review-by from Jarkko, and Kai, and the
design has been stable for quite a while with through validation running
background.

Just wondering if you can shepherd the patchset for sgx tip tree for
v6.1 merge window?

Much appreciated.

Best Regards,
Zhiquan
