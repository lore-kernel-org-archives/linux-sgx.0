Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EECC4332F
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Oct 2022 14:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJMOfo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Oct 2022 10:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiJMOfn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Oct 2022 10:35:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3038B4BA53
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 07:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665671742; x=1697207742;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8nVEeI+qXU8rTwTkDA/5qwmB6nu/v03fUm/NHnDvIok=;
  b=jpFetYNIZ4rnSoTjLSJwrpscW/0+IxY/t0XaMXQr9KuYBxtT35l1D/Kk
   NEEnqcdZ1JWr4jg7UbgbMMBVTywVDuzpK/iBNQWL3OFVtBhwr86Zu4jsg
   KUGNlNcfCHAuEsBKkggcfY6h6av601fWyKrjjHUT2DBDF1UDzq56tQ1dk
   8eWxbZVw6F9NEjRkxE+UKeajHIZVdAuJdrW92YFbv9pxMtNXBBRkZtb8D
   lIJoehhR/3OUYoUb38esAlIjBZPQDStaVsFYosgTZN8b4L83FZQ0uxn/2
   P9bW39wOKpe7mFEtlNkrHnD1w9ts8eIpMWYv3xwk+auzgFCTfSx0UJLLF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="288374022"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="288374022"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 07:35:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="872353477"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="872353477"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 13 Oct 2022 07:35:41 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 07:35:41 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 07:35:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 13 Oct 2022 07:35:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 13 Oct 2022 07:35:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCxo6x1l9wDF8JRob+uuq64MwTkTfMrXNBMj3v1lwaEsaQjTtSjXTzzVbjW0vC0CwTtrWpV8qUJy3BuW0iXjqOSrCkReOuXx4rwK2u8udGt1gfWAB1dzZNbgMMRqLGQZgbj5rSlT1HaYZRN7Pvoym/avgsDcofLeqF6Mh9SJgiPR3GwHGC3srZ8E8u/4cVMQHQYDCpI/4MkYKGx6N4gatJiXpGswSto3+fEWFSK4xteUTBaajvAfE8MDvyPzKlp+wdYOM4rXgiJwJhgvxeFWTyu57iQGt761e+oRryAWSbAJZlYO7oddb/QTe2/3DlJucnHi0Qzaea+Urzdus4naBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7ac/Bxcfu/YO69S6y6l4dkcPsTFC8LG2w9MN9Bc8GY=;
 b=TfIsczTpMUXoAMrOhVP1D1lItCKFNZi3aERmpIN7svW5+jpj0ls7y3XK5yahp7BtkNsusDFek0GIKTVQ1PE7Qdzdd5WeiL/L0Tj3/Nqk/ni7RhVv8xqvji3tj41RUPeQyS6KAsO7oXxz92Yrq3ULQdtzoYIyYFSKLAWLvHQXYR9AEe/OTG+So2mk+oLQzYzoct5kQv4AuXu0ef85hr82hCANs6XEmGGvJj4F33uaO2Me2fdGXDbdcqy2atgcVijqSNVvCHHMXTfTr/I880w1bwpjwavl8du8e2+tKmjH6xn+AhIItDr2bivBiy8Kr+02hgyF4FnmAem6cG5MrbNSQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CY5PR11MB6416.namprd11.prod.outlook.com (2603:10b6:930:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 13 Oct
 2022 14:35:38 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e%5]) with mapi id 15.20.5723.026; Thu, 13 Oct 2022
 14:35:38 +0000
Message-ID: <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
Date:   Thu, 13 Oct 2022 22:40:56 +0800
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
Content-Language: en-US
In-Reply-To: <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PU1PR01CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:803:15::33) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|CY5PR11MB6416:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d85dfae-d4cf-4d00-cacf-08daad283212
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLxFtwh5sLBjzhXk8Mdi1Ri5VxcXPDW7MmjKbGUBtztq9ziTyPSuy1AFjBcanLIdDCIWdjI1T39ECaTbBjJemCv93zJNvuYs24xopiehvuCeBm3bsSgHq74GHK7WmPz/Tna6wh3/TMpvTBSp3umYCikNCxpLJPaVlkVyPTFs8QieYOXgrGDl1xspNwFt28QAFzmblVLUEiPQgj2hv3JuKV9sD6ZzTO3Q4nhtrDPcSsHJWMkkSuxk6mspWfE8kP7vU2j+lNTKeWdAFqEHI5QH+ZR8a9kSSdGQ76M0fa0eu5XJ8pcJTLg1+X8OmLAi7kW1ukSyHlsEjJfKl6FSVU36hozAwU7hmQlLqMNGMYScN9gA/bftHS1X7iyEiQe9cr4xDdR9HafLc7E/y+Mnyv5O+hsbJySWrZaZLJoxDLtw4giKcAGGgB+3yBxALUNRKWbcPGE8DTzp0QtEL9ANuOUwx7hKzt3AwBfe5Dc8nfCeRHMANZi3t6iu7zUD8jA2tqsBxYMGPLiRtJg4INF85hPJyaioFx6MpvfZ6vTU15OYwk8/14yFzA9GF7SetBg1ZM8N1oqO7YNI2UhfeNQpSaAEiu2cTj65IiBDMo+I2FLdTotY5GhOJ3MwfDrUF6mcVhqICVtco22frvWN/fGq1aJqHrmjY7DTx0bIzRFCcSJYtL0NpJcjqS7IHMaL9RdaNu9vihPLU7e0a2uSQNCIZCdBMCRnpiF4iR084v5Km4f6GlgML4yXBgXE0lxiZh9X+otVkMX+yt8wDQ6BGkshA0p4lim5xlf6AsBb6qPT7eIIKVI6y3SmsCkSgBR0q/J/0JF8idiXM+MiVJGoU5F54wMUiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199015)(6666004)(966005)(36756003)(31696002)(6636002)(31686004)(82960400001)(83380400001)(6512007)(186003)(38100700002)(5660300002)(4326008)(2906002)(66556008)(26005)(53546011)(6506007)(316002)(8676002)(66946007)(41300700001)(478600001)(8936002)(86362001)(2616005)(66476007)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFEyRDRaTVpXanZiUUk2R0lIeVZlNGRQc0VjVmRlVmVhOXQxSytjdnI1NUtT?=
 =?utf-8?B?Vk8wRWp0Snh2clcvRkZvQkxydHZRS2NKTUFER1JCd2tLaml1K3kzR3VPQWxB?=
 =?utf-8?B?cGJ3R3hnR2EreDZnTmY0aUFUL2hVUXdLUjhJUDFFQmRZaEk2dENTNjNuSWVt?=
 =?utf-8?B?ZkppMU1QWUpCUldkQkgrcW9HZXVSbSszRVZaSjJSRUZHa0JiSGc5eUJYS29x?=
 =?utf-8?B?OGJhNEp3elk2Z0dsNGJtaEJOaXhRdVRTRlYvenlFTmR3Sk8rb3I2NUt6THdS?=
 =?utf-8?B?NWRnQmR0TXdxQkVJSWRjQnk0eWhWRmxSUVhBV0ZhSFpKL2FwZ2sxVXluNU1X?=
 =?utf-8?B?enhSWnVDbXBVWlRHRjBPazJNOTBLODJqbk5oWjJhMXY1OXAwYmJ0Lzh5QXRJ?=
 =?utf-8?B?RUkydDFBazlFNk51dHRVTnR1UkdRMXNnNUFNczNHSUVLMm1la0ozbUpNYWRY?=
 =?utf-8?B?aXVyRUtwL0hSSjcvTG9qMTBSQlY4aUJsL2J2Q0x2b2dIcXZ0SUhydnpRZTV3?=
 =?utf-8?B?bWtsYnlPQW9Yci9HZUp5L0VJd3MzZTFlUlVRNGtqSFVFS1pYSmhxUFRvdUx3?=
 =?utf-8?B?dmVkMEZERFdZVzZlS0pJbGhpeDRKVnB1UVRCM1A2NXFmRlFCSTdUZ1lSNTdu?=
 =?utf-8?B?b0lsa2xJSi93QWNXQktqYm9zSERnZW5rNlIyU2NweGtISGhpQWdZUWVacVlO?=
 =?utf-8?B?NUJ2NXFaSkpiUkxSWmg4M01ZNDd4aDgzSUJNRmpOUGdVT0lwakE3TVZFQmVp?=
 =?utf-8?B?d3NsLzlUU1JUdU9pQTQ1Q0djbVg4SjUzQi9nSStSbVFtVjZtVlFQQnVYaDNG?=
 =?utf-8?B?cjBjU25FTlJjcks1VDc2NjJENW1Pd3JEQkZxOHl0dUxRNWphQ1BjNkttZ1dE?=
 =?utf-8?B?azh6SmxON0ZpMlQvSnJrNXpxelVyeDIrWFZOYUVERjF6ZzZsbzJGc0RCVEZz?=
 =?utf-8?B?U1B3UFMxb1dVNEhrMG8vcy9hVkgwVjYzNEQ1VE9ZVStiVm5GZGJoSUhkQnRX?=
 =?utf-8?B?MzByZmMxTjIxb1dIREQ3dC9VUUt1aENHZ09VVW44SHBmVDlseTZRUnhEdWxm?=
 =?utf-8?B?ckkwbkJiMFpySWIyb0VQVWFVbk1MRFc2RDhSczhocEl5bVJHcWRSeXFpUmlC?=
 =?utf-8?B?NWV4L0NDYjlpUFVIZitlejZLTGhEcFBya3o5M0FBSlVBbFdXVmd2L2FoR1FZ?=
 =?utf-8?B?dGRadFZaRlE2b2N0bGlLSU12cmE5MStFK3FpSzhzQXZMbEJuR3JvZWlvMlNl?=
 =?utf-8?B?OWdWaS9JR0JiMlRRVll6eGQvRkxKejIxS0x6TGFkSkhlQ1J0MUtiWnlMUDVl?=
 =?utf-8?B?NFlITUhGcVN4WUo4bmxYQ25KbWtiMEhzSDU3NU01S3ROUmRuQTNZZ0ErY0hq?=
 =?utf-8?B?TWJpMUt3UFZEUHh6dWtabGxXejAxU1VrdjNYNjcrNVdBUDU3NnVSbFRvVmZh?=
 =?utf-8?B?cHpnTEtIM2ovemdva1JaMzNEaUVZMzBGeno5LzZ2WFBjc3NFYjFhdVNXNE9Z?=
 =?utf-8?B?QmdqeEo3MXhPaEx3Yml1cXd5WjdnWG5SajFyV2JZQzVwT25PNDd6bEVNK3d6?=
 =?utf-8?B?ZWFDRlNuQXV1dkpPUysvZWx5NHV2QVlPZ3M3NlhlazlRQU9lZGY4amhzSmFX?=
 =?utf-8?B?NjJBTFgzVmEyUWpxNnl4L091VksxdGZtYnc4SFIvY0M1MUFBdXd5Y0xVOGtw?=
 =?utf-8?B?OFRtOGdkRDdtRlFxOGN5WWN2Y0hCeEJSMnl1ZEM4YjhPbVNRUHF0Mjg4b2Yw?=
 =?utf-8?B?OWllZGZEbkZaUGVtelNDMDhTOEVKNVFYM0hDUGtwNE5ST0xsc29YNkF6cHZ2?=
 =?utf-8?B?T2lSSDJBdWlHQ1QwSndQbVErQW5LNW0xc3FFSVhHU21oTENrV1d2U0xjdUlS?=
 =?utf-8?B?c1NwZVBtbGwrL1V4SlFhOFNZSDFYVnFOTlJORWZsR2xVa0hlbGxNUDI1NGcv?=
 =?utf-8?B?MXRHVHFCUTk0MWR0UUp1eEpzMVkzNmNITVBZUUxDcDhMNzJSMXUyNmFjMFhG?=
 =?utf-8?B?ZzB2MHl3eE1UZFlSbWlBNkJ1eFdtLzRmVExuSHZnb0lLSFlkdmhKMko2STBh?=
 =?utf-8?B?Zi8vTGkyK3h4UnJZLzBDaE5FZkREZjFnVk5ubW9pTG5JVGR5YUR6RVhVK0gr?=
 =?utf-8?B?RzJaKzQ4emRaZ2RIaXJvTG9kK1pkdEkxeThKNVRiVmp2aldlZzhGdkRzS2lX?=
 =?utf-8?B?Umc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d85dfae-d4cf-4d00-cacf-08daad283212
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 14:35:37.9392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xf5mOpfDWgoo9UhAuPjb2hfnJlwAu3R0rej4PAXYVMw4VM9kto2GipHE0GTByijuNBnutRqg3bfv5VhhA8m7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6416
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/10/12 22:36, Dave Hansen wrote:
> This is really just mechanically restating what the patch does.  It
> doesn't help me understand how it achieves the goal.  I guess I'll just
> go and write the changelog for you.  Here's what I was missing:
> 
> 	There is already a signal-based ABI to tell userspace about
> 	machine checks.  But, SGX does not use that ABI.  Today, the
> 	kernel delivers a generic SIGBUS if a machine check occurs when
> 	accessing SGX memory.  Userspace can not differentiate that
> 	SIGBUS from <add example here>, so it is very unlikely to be
> 	able to recover from the signal and the app will die.
> 
> 	To fix this, have the SGX machine check code generate a SIGBUS
> 	which leverages the existing BUS_MCEERR_AR ABI.  This enlightens
> 	userspace about why the SIGBUS was generated and gives it a
> 	chance of being able to handle the signal.
> 
> 	QEMU, for instance, has code to handle these BUS_MCEERR_AR
> 	signals today.  Without this patch, QEMU will just die in the
> 	face of a generic SIGBUS, and take the whole VM with it.  With
> 	this patch <explain what QEMU actually does here>.
> 
> 	In short, BUS_MCEERR_AR enables QEMU to reduce the blast radius
> 	down from the whole QEMU process to a single page.
> 
> This patch doesn't *actually* reduce the blast radius.  It enables QEMU
> to do that.
> 

Perfect, Dave! I'm ashamed to have to get your hands dirty in the end.
I'd like to replace the angle brackets content as below, could you have
a look?

	There is already a signal-based ABI to tell userspace about
	machine checks.  But, SGX does not use that ABI.  Today, the
	kernel delivers a generic SIGBUS if a machine check occurs when
	accessing SGX memory.  Userspace can not differentiate that
	SIGBUS from <a recoverable machine check error>, so it is very
	unlikely to be able to recover from the signal and the app will
	die.
	...
	QEMU, for instance, has code to handle these BUS_MCEERR_AR
	signals today.  Without this patch, QEMU will just die in the
	face of a generic SIGBUS, and take the whole VM with it.  With
	this patch <QEMU will be aware of the machine check error and
	retrieve the virtual address (HVA) from siginfo, then convert it
	to GPA and inject a #MC into VM. Guest kernel will handle this
	#MC, find and kill the task who had accessed the error memory.>
	...

>>>> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
>>>> being shared by multiple VMs via fork().  However KVM doesn't support
>>>> running a VM across multiple mm structures, and the de facto userspace
>>>> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
>>>> this should not happen.
>>> This is out of the blue.  Why is this here?
>>>
>>> What happens if a hypervisor *DOES* fork()?  What's the fallout?
>> This part originates from below discussion:
>>
>> https://lore.kernel.org/linux-sgx/52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com/#t
>>
>> It intents to answer the question:
>>
>>     Do you think the processes sharing the same enclave need to be
>>     killed, even they had not touched the EPC page with hardware error?
>>
>> Dave, do you mean it's not appropriate to be put here?
> It's actually a pretty important point, but it's still out of the blue.
> 
> You also didn't answer my question.

Oh, sorry, I focused on answering "Why is this here?" but forgot to
answer "What's the fallout?"

It's a very good question.

Looks like Kai had answered it before:

	For instance, an application can open /dev/sgx_vepc, mmap(), and
	fork().  Then if the child does mmap() against the fd opened by
	the parent, the child will share the same vepc with the parent.

	...

	Sharing virtual EPC instance will very likely unexpectedly break
	enclaves in all VMs.
	...

https://lore.kernel.org/linux-sgx/52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com/#t

Moreover, I checked the code in below scenario while child sharing the
virtual EPC instance with parent:
- child closes /dev/sgx_vepc earlier than parent.
- child re-mmap() /dev/sgx_vepc to the same memory region as parent.
- child mmap() /dev/sgx_vepc to different memory region.
- child accesses the memory region of mmap() inherited from parent.

It's just that the app messes itself up, the vepc instance is protected
very well.
Maybe there are other corner cases I've not considered?

Best Regards,
Zhiquan

