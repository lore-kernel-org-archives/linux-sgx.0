Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899E0C433FE
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Oct 2022 05:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJNFhb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Oct 2022 01:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiJNFh3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 14 Oct 2022 01:37:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B07D183E00
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 22:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665725848; x=1697261848;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=geX1gpzSSXFTK+CXODCBjsY824trxG5hf9P2s9wxvIM=;
  b=CeArMbIjsvonq6T7qIMYuBSP1PqxMtIyNhAK/GdbVQAgRTt9tni1MCBV
   7OQaMKIW3q0IUqM9rOR0nmx1rTr0BTj497C76UASNhbwFlLke6/I6Y83s
   N4ZtzWd3qsrauJtcSS3oQldQipOGicWPu1/KWkSAXC2OhA7u8iv01mUL1
   zTdQ4J7Kk8Cq3FcJqKTpm3GD/WpYik9xZ5KHo6r8Bddj0LjWlG+WrwAZR
   a+pFdUw6VdrNcj3ZagjtgmSNzJ1pfsvx58rwXDy/6iBBpwT6lRXYkTtW7
   /guoqaW49GC/MFRHLz1ybi0e7c2SVTUR4HccuuthhnzjvqCeFZ9s6Nj0S
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="302903949"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="302903949"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 22:37:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="622428058"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="622428058"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 13 Oct 2022 22:37:27 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 22:37:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 13 Oct 2022 22:37:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 13 Oct 2022 22:37:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sp07BCnJzJkXtp6wA9fQMzMB3kpNBYdNUdY27qzuwjABVSrw8FhUmXXUQMloMdY+2AowrJIQnTHl5GDI9UiNipKkE4vlMZmbwlDareXwil8/NO7wBaF4QGIrV65ddEJ9MkZGYDft3iUMCD2EwPK+2dW8n7leWi1yM8V82VfkIIcfzLa5I47MTZxFAVhXDSY9kI44rZpmmB63ZQycYP04X56UZjL+AsS2IsAIIOQVEu/86l+b82te9ZyTO//YSv++E/Chnr/gskKduOAnGeAG+G/RGYgZzkm7PV4yadaKoSwxLTbQS7gjjugTQMLVLVXwVNB2FXn6XLis99sd+ig0ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQh15tL/IN7lOEdNCJPnpNHyUIcWNYDjCLyogIPWiaA=;
 b=IBTvBZDjbA3Ko9bKYOcq5ecAqmhQ5P3ma3t8Cga75blMS4AEkucsMk8bzIqr3Qt79A4aZQSepgcZB7a1X6hGn+ZRupNz7n3Sz3qYekTkQOymaxSyr4WY7YIHJfdvn3ltHndMPALnZE2aWn0xa1EQ1XwOpT+2ozRMf0HLR1cjyNwuKPIh0FTG7+XTQ2AWb2EfKVMgvYwTO4bB3nBIqScxgnCwSErTS/pjL23LqlhZPMMANrsQxsECg9Gw/tFnlW3E61X9avd5kGgcwyrbcT1mSKF8T3BZE4xJtD83I6538e8pPCr6btXpe33CkEzpF6DUTjAhli0f1VtMmnR2K6r9Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CY8PR11MB7172.namprd11.prod.outlook.com (2603:10b6:930:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Fri, 14 Oct
 2022 05:37:25 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e%5]) with mapi id 15.20.5723.026; Fri, 14 Oct 2022
 05:37:25 +0000
Message-ID: <00036cfe-53f5-2a3f-8b16-51029c702080@intel.com>
Date:   Fri, 14 Oct 2022 13:42:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Zhiquan Li <zhiquan1.li@intel.com>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
To:     Dave Hansen <dave.hansen@intel.com>, <linux-sgx@vger.kernel.org>,
        <tony.luck@intel.com>, <jarkko@kernel.org>,
        <dave.hansen@linux.intel.com>, <kai.huang@intel.com>
CC:     <seanjc@google.com>, <fan.du@intel.com>, <cathy.zhang@intel.com>,
        <bp@suse.de>, <tglx@linutronix.de>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
 <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
 <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
 <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
 <b2dd91b1-9b9f-6b41-4cb9-80dd99837480@intel.com>
Content-Language: en-US
In-Reply-To: <b2dd91b1-9b9f-6b41-4cb9-80dd99837480@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:3:17::33) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|CY8PR11MB7172:EE_
X-MS-Office365-Filtering-Correlation-Id: 52b558fe-6951-433b-93f8-08daada62c54
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmd3hSmRH1b/UaHCxqG/qEp+VpCeuQWbyug7QG05m7uVs9ofdBPWM+6j1xzYruel+LqBc9m2El1y3H46ZnSYj1mQy6e92hBq3mlRn+RMjej8LDH4EXYMdEpgdDQrowy3qafRuaLsgbIjAOFQ29a/R7y1AiDy7XdHAY3xbQo1kO6HlP+VsH488Jc4J3zKfDZKHHN5lTHXbwEIJ/VBC1WxaYWZYR2+9MJiwzHfoH7mUA+RdgqVrPxWckHgC2i5LneCwKnfhnoVlzuzv46EtVFQK10q3LO8q3HllHxo0HFEh4ht2hOybqykh+okJYG/V9z69STjsyIL84svYbX0lmtKAwNL3EQA9f+JcUvSKZkTj5b+jdaZcQdSN+ItZwSbMlXig1c9R7Jyq16PgMeMtGp00KIEGVVz8zW50fUIv7c5NKpAPl9CkrPzJ5W3EBTTWGFeeY/4AN2/gyhsP1d6ThJBy0w4AULE79yJhAS4lZYWway+El5ZaX8vDDagULonzHf6t6RicccyHWpksSmhSB9juz9+vNmh1Z+izOv5U9IyAOwjfZ5WhYOdx8/7/U1gkkeKyrv5N0An0CIZ6DmOtwKgtRZPa2GGKYh2BhKqTNzgPXnW1xm06Ku7/UQZ57KGkkDkwHlfI9FveqXn5JkECMYR/LNxLCjTegNBepVnJVF4KRXyqp+RBuBKLnlUcS1m2LK3NaTpqDU1o7bGnwpP5H6xxprpexR/JJcgsitx1+Kjy+OlPka8IzfDq2elOLQXVr2CB35hiyqLau821flqw0Bwmz1nWJvSzjFT65TfUwZFMpQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199015)(8676002)(186003)(38100700002)(36756003)(6666004)(4744005)(4326008)(31696002)(6506007)(41300700001)(5660300002)(2906002)(83380400001)(53546011)(8936002)(6512007)(66476007)(2616005)(82960400001)(86362001)(6486002)(316002)(26005)(66946007)(478600001)(31686004)(66556008)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm5HOVByZFBCczRLVHVuQ1Vlam5yRU1VZzZtQXpicmxFbENBOGh0Q0pRdG5W?=
 =?utf-8?B?WHY0M1pCRjdvemJ2VzhRbnlTNmx1Nmd1QTZRRWR0SXo3RTNKZHhVazlOc3JS?=
 =?utf-8?B?aFhMNWMrd1FGamdTeS9sTDVUQjlNODYxNDlaTDdzRGlIM0hjRkhESXFsc2M2?=
 =?utf-8?B?aEJHU3BWcERDMmd6MU9WV004S05kbnBaeW9yUEJ3T3ZsOWFMeXlRenJjM3A2?=
 =?utf-8?B?Z1FxWXVwQzA5Qm10TlpHYkN5Z1BSdDlKbzF6a3JDZTlkZDUvQW5Dd1VhRnRh?=
 =?utf-8?B?di9ZQnhVRXFjeGZTaUdXRkwrYTVGM0NudTg1MG1TQktEWi91QlBoVHBPUEdp?=
 =?utf-8?B?VVZuSHE5RHhCbzAwR0xMVWYwV3oxNnRobTBBYXJvY052WGs1MjBreEo0L25p?=
 =?utf-8?B?TUpDbVBKMG5QRkwzb01RNHBkTjd3aW5WRDArR3FOMVk3ZG5IU3pWY0JvNVZw?=
 =?utf-8?B?QjFQK00rbFpLV2NHaWdqc2lQcUhQaDQrMlR5NEpGbjBZTEdOVy9NbXJJQkRE?=
 =?utf-8?B?WnNPZVFvcHlaeVFUa21lQ1ZFVDVON0tBaGZqa2tZL3N4b01rdThOZDBTdVA4?=
 =?utf-8?B?ZUw2Zm00Mk50WGJJMXVSNTh0cDI3MzV3cjRmZ1NUSkx3dTVHN3lxSWNrRGRn?=
 =?utf-8?B?RnN4Ni8vQlFRTjRzSHRqZkNlV3ZPdGl5VE5SWFFOY1VhMS93a1VvZnpGRmxU?=
 =?utf-8?B?bmpKalFyWTdCcEVkbnNCcVVGREh3NkNZWG1sWTFxTjFkUEFYVnhORjZSak5Q?=
 =?utf-8?B?dVYrMDVGVit3S2JzdXdUSG5wd1JETk1QcWZiZ3VmejkrSjlhcGkvTm4rQThE?=
 =?utf-8?B?YmVDM3pjSE1TUm9jTHNYTS9McHBGQ3lhWCtjSjNBcnN6L1RkQ2dwVjZtRXkv?=
 =?utf-8?B?dWdHQUJlVzhSMlcwMlJ4bkY4SkZQYTQxUWZtRWdTS1g2NEkyYW96L2lJSDlp?=
 =?utf-8?B?QzVkZ0RQTDBlczNURG1MUmR6YStNTCswV2dENDE2dk4zOVYwTEJQNEVQN2Va?=
 =?utf-8?B?bWNiK0xRRS9HNVlvUzYyZkpUU2VPbjl0NXJXbHZDN3ViS2c4NkR4Q2NZWkEw?=
 =?utf-8?B?TGpXQ053d1NwREVpVXVPQ0l0RlJZMXVpMFpJMGdUL0VUWlBnVldhV1poc3VR?=
 =?utf-8?B?L2dwcUpaZGcvc092aXNWUmlqdVU5ZnBvbXlNdWs1ZXZCTkZ2aXNxOEJDMEZC?=
 =?utf-8?B?ak94OUlIVVl3RHpVaEVTdDhaaHJsaDdGS1EwMUxVMmNIOTZzR01rRGZCRGQ3?=
 =?utf-8?B?TWJvQTlCR093MHdWUzhDWEJjRCtQb3o1Q2RoYkpHNFJxZmllZHN3QTVUaGdz?=
 =?utf-8?B?MVVwNmtVVVhMaDhobEZ3R0g5YTZKdkQ1c3VadG95NFFmS2hwM0tuOU1MbzlL?=
 =?utf-8?B?RXAyZ2lyZ3ArSWlCVG41eXVpNHRPVzBFbE0xV25ESjZrZmR0RklPc3hVVG1o?=
 =?utf-8?B?OElJNGsxeVdOdE5KOW1RYnFjN2pTa3h0RVlIZVRLWElibjVKS2RxM3pZVlUw?=
 =?utf-8?B?dFk0c2hQcGN2MURERHpoZWdGMHR3WjhwV2xVRitCUVNUdFpwOVFDVTlORFhY?=
 =?utf-8?B?clZIbmRqa1JPSDFMZ0tMT2JGUGVQY0xmZi90VFJnUFY3aVFLdGRFWDlUSE9U?=
 =?utf-8?B?LzRlenEvRWNhQ1NTbzVFMHVmeHlERldXczFEN05Hc1RQaWh4Y1VRV3dOSmh3?=
 =?utf-8?B?cVFNSVgvb0pqejJPQlJ1cDIybkVnekVSK2x6YStmTDc4Ty9QOFpEb3k1cG5y?=
 =?utf-8?B?NmdRLzRrYWQwT2p5ZnpXTHc5QVhUKzJ4ZDB0UnRDblBXcG5KdGdYT1lsTVZa?=
 =?utf-8?B?RlI4eGoxSTFSTXR0Y2xFcTdqVEc2dGxRVlZCcFltMFY1VmdLMGhockl4NGtY?=
 =?utf-8?B?YXNuT0FqbGlHdXlQVEV1ano3K3g1T3FyNnl1b1VBV0VqNHdqekhrOHI0RG5w?=
 =?utf-8?B?TVVCZkwwbkgwRy9wZzFUMEoyaFd2d3lWWkNvSXJkaHE3clI0ZVZuWnhxU3pm?=
 =?utf-8?B?QytRYml2ekZGVTdOZ0tqU2VVOUJmY3JIdTdZRzFodDRiNlFZbDY3amlKZjA3?=
 =?utf-8?B?M1pIcFMvOVplazZ4K1pTY2FxUG1DQlE4ZjB1dVpsTjNDVmV5aXdjRjR3UTZ6?=
 =?utf-8?Q?lDgakuUCCUTQFyFG/aL9c/O8P?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b558fe-6951-433b-93f8-08daada62c54
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 05:37:25.0013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wkh+olXEcovcK+5H1mKNb0oyZUXho6sHoSPG2r0ZXHZZ14/OrhaxIHcbivUCFFU/533jUw/oE5avIx2ypGSuTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7172
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/10/13 23:39, Dave Hansen wrote:
> I wanted an example here of a SIGBUS that can occur from sources *OTHER*
> than a recoverable machine check.

Oh, got it, it should like this:

	There is already a signal-based ABI to tell userspace about
	machine checks.  But, SGX does not use that ABI.  Today, the
	kernel delivers a generic SIGBUS if a machine check occurs when
	accessing SGX memory.  Userspace can not differentiate that
	SIGBUS from invalid address alignment, nonexistent physical
	address or object-specific hardware error, so it is very
	unlikely to be able to recover from the signal and the app will
	die.

Thanks for the clarification, Dave.

Best Regards,
Zhiquan
