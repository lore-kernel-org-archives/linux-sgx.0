Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69939C12002
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Jul 2021 20:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 523AD613C0
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Jul 2021 20:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhGNUpI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Jul 2021 16:45:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:64914 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230463AbhGNUpI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 14 Jul 2021 16:45:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10045"; a="197609982"
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="197609982"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 13:42:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="505457262"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jul 2021 13:42:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 13:42:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 14 Jul 2021 13:42:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 14 Jul 2021 13:42:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHk9073Uz3+McogbjumQ3SZGUjPMeF4zyEDT5ynfb7Yidw/b/BwylIRmDBnJHFi8rstjda4vP40Kde93xpmjDX5hsg8Eq/ndkysKINrXImRWcn3TJCtVaHtTc6p44Gudxs4stAan4FUBd21Zoad75KSFrdcCN3bqBkFod0yWwNLtPBbpzLYy5GBlY5xk5KSk7Y89kQ0lNKk8wdvkTYYgBwV/rY2fiDvxupXok0YEhHJOY3/R1K6DG2pLwXCvII2a88U9eWxfHoZvJ75U5N9qDutqGknl0pvnmAJONEwzOMlMk6EGhTB8FTgGpiT3aSamE9uIo/Fwlan6rpynT73AXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAGQRbm6I1RbvndRi89oWGO4z9gJ0DMndlD/l70IOjg=;
 b=fuPMwRDVG0b2adiDQv7PZMJbTd+neFc6dYf/YCT9TSmVMOx/mUE7mzz3j9Cj0MNQItfwAZL6YrMZwV4QGAQMIlF9XzZyw0rJ1ucuyNHTH5ViHyIaIi3SbRyQhv1UnxfEbYwXtOz4rKA8N/3SIGB1ttrc6cMVAE8dvE5oyr/DyyG3lSkvQ+HVoo10zNgo4wZhCzjKPTOonppM10rd4P5Hqyw84QYXgKeTEF7jQbtEc+sImRR2n8KwaYe3/DN0gq5Hlq7ee4GbSljpu1uEYfATcGcDY+uM8HOugndZ3O3F0V9x5eE70cMYHb481iM1f/Wvlgo3r1VEb+0QLiqAxoBUWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAGQRbm6I1RbvndRi89oWGO4z9gJ0DMndlD/l70IOjg=;
 b=sPBJI2mFwGcqPSLK9CuIzzXtPslr6jhMeHAMIphLiKu8WfZYKYqHi6f+HDtp0wsMPLJ/CqBc9jT+BiCzZuylioIvA1LwjSuaPcg7Clb4AoStif3ZakFUAAndP+y/viqzEsu6Uuop6Hk9t+QXKFWtw9DeXv0CS8i495eJzO67eIU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN7PR11MB2818.namprd11.prod.outlook.com (2603:10b6:406:ad::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.26; Wed, 14 Jul
 2021 20:42:13 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::202f:e602:3983:e631]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::202f:e602:3983:e631%8]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 20:42:12 +0000
Subject: Re: [PATCH 1/4] x86/sgx: Track phase and type of SGX EPC pages
To:     Tony Luck <tony.luck@intel.com>
CC:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210708181423.1312359-1-tony.luck@intel.com>
 <20210708181423.1312359-2-tony.luck@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <93845f78-120d-7522-bd3e-fe042380d29e@intel.com>
Date:   Wed, 14 Jul 2021 13:42:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
In-Reply-To: <20210708181423.1312359-2-tony.luck@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:217::14) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.219] (71.238.111.198) by BY3PR04CA0009.namprd04.prod.outlook.com (2603:10b6:a03:217::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Wed, 14 Jul 2021 20:42:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbba69af-100d-4416-f750-08d94707dba4
X-MS-TrafficTypeDiagnostic: BN7PR11MB2818:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR11MB2818F08C792A827729404380F8139@BN7PR11MB2818.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZSmfUvl0zz92xcqMpmTOLu5v5tG8M0+ZGtL8Hz8p1LPtDoPEGJU+he7s2COsRbKOrhvIM3aB2+TIMTc2l+SORvDJFMQB/MVMfHQ/aY0dopL6x0rRdZDbasPaaiPrWNf7qpM8uuxDZho5mNVQWn4PW+R2pU8+fz96vbaRSn0zu79J2jGNlY9+HvVHaSR9wCQ7Ctxew2KNQlLyObdYFUU8RHHTco/ry5h7KL8lOTGjo2z8gWvefdYmuDve+brDZkd0hJVZW/4A8EKIOuAEtG4ryMS6i8AC9lMdB9pD9MGqDQVB7r9Pff34AFKyMus8UifwiwKZ6gKd5l4VeII4ndGcE78jdIvMri8F4SBz4ZXZXkiZymsP/Wsu9yyOGlnbkN7ON4FalGJzhwZxv/4Y1QNz4wrtuuNtuShWLxGgQtXt8zp8Hw04IXRQIYs8F1MpGxjdMFkZ7ra0IN8O1voJxDCav3eMgAzma8EmqJo4Fq1zFgPL5ljArLBgE1MsVV2KxGlmZ0pllTtCIQU3VTOj/3eAqmTQlCurRtIGKhfnbPsJxLGzRUIubIg6CLKEUslEdSFV6BY1F0xk3jljdsoYXeQQdU2ZAj1CzrAs1aGy+jOwBghay/sTzfkK2jMW5Hqu9Y+SKK7JL9Ea2vUD1OOf7CLC4XUvFNzupMZAFz4wXR3QwLGu3dDka6nRe59Z8Y/+aOlHhcxh4YK0CPsMvEvhawOq7jroS2+YgEE+jRrWaqIsdIYYFtHb4KvfyR0GhffQoFyMDblTiJSS2woFWYEYGo7mEujkWlmYjkCZh1hfP1gGHhUafbCceM2CebjLdEdMdcAV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(54906003)(53546011)(83380400001)(26005)(6862004)(316002)(186003)(478600001)(66476007)(956004)(86362001)(66556008)(4326008)(8936002)(966005)(31696002)(44832011)(66946007)(8676002)(2616005)(36756003)(6636002)(16576012)(31686004)(6486002)(5660300002)(37006003)(38100700002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXZEUjFKU0FEdDNXS0RSSHdnbitDQk1Rd05oMDZ4cEs2YVl1N1lIVmQ3dG5w?=
 =?utf-8?B?eUUxL0lzNDJzUWFHbnArb29LYVluVE9vY0JYbGpMNktKNlpRRTdVbXZOcHdl?=
 =?utf-8?B?ZjhqUnpNSzBiMmtZOUk2eS9mMGhPdVBDSWpTeUJOQWRPcGV4VUFEWm1vY3dV?=
 =?utf-8?B?a3hJck1RL1lDNCs0azlYcnpFWXFWZ29VTjNLZDB6R2h1NDVhRU1BalFhbXZL?=
 =?utf-8?B?b21MZStnak15ck43d09Dd3l5blZzbFZwMFBMVGRJd2JISjJrWDY2ekJDVmlY?=
 =?utf-8?B?dlo2ZkpJTWtNMW1ZUXFMTWFxb0w2dVAxNWw3V0dCZUlmK0h5bWxlbVA0YTlZ?=
 =?utf-8?B?SzhXdWIyZXAzUVV3MmhzWCtMY2R2Uy9FVjR6ME9FV3V6ejlNTmpvMUVIM3hP?=
 =?utf-8?B?SHAvUS9VTHFEQWNQYVV2ZEs1WkhQTlI3TGJuWmxwUnZiZWhFQzljSjdtQk5l?=
 =?utf-8?B?QmtudlhTV2x2ZGVSamFqaFY0b1J4SDByUXkwNW1hNnRmRjF6eExBMjNFd3hE?=
 =?utf-8?B?ZTdWVHRSejRhck9pdU9VNnFxYnpHYVg4Yy9SZ1QrQ2o3WCs4dklCNHgwNS9W?=
 =?utf-8?B?bmFsVkdwVFliY3RlaWYxanZmNWNLOUY1NGlRRUN2ZEdOYjJEd1RhdXJlZFp5?=
 =?utf-8?B?dGVCRy9SZVQyNDlRajIrK2svSkoxNTlDcHBFZlYvSW9jTmdtc3VRMENDL3gx?=
 =?utf-8?B?RlpUenVGV0JRbFlubWZvRy91OGx0ZXFoNUtvLzlPY1dwZ2NaUlFlMjhRbE0x?=
 =?utf-8?B?SmtKdUZMVkRFMzVDck9XaDE2RTBYWTlXV1RRa3lNcVpxMkZFaWtjMStITXgr?=
 =?utf-8?B?S0VnR2N1ZnVxa0cwazlNdXJzRjZKMnZwdmQzUHNNb2IvQkNoaTdzS28xSzV4?=
 =?utf-8?B?YzFQUTRJVEgzL3daSWtFVWw0L3BXTWt5MEZXQ3FZREdnRmNIWWkrNE1WRzFO?=
 =?utf-8?B?bVc1TVA3UFMvcmhGVC9DckRNOWF5VXhxYWhYbHc4WS9zV0xUeDZtd2h3V1FB?=
 =?utf-8?B?a2dkVHQzb3lmdFM0N1YwTDd0R01jZ2U5bDM5akFZTXpKVDhZSzlXc1hHSzB3?=
 =?utf-8?B?Ujh6bnNzaGlTUnYwTXpGMTFGMlhLcXBVQ3NyMkdqZHVDckdLZG8va1F5Q05R?=
 =?utf-8?B?dnA2VTRGMDVmb25WSnpCcS9pUVFNNmFvRXVUWWtBVnRQRjF5SGhGUHA4b3FL?=
 =?utf-8?B?bUhxeGRoVEc1c3U1RElSdFhxM0xnclpxNFlpQTBGOWdtdGl2cTk5eUdyUCtx?=
 =?utf-8?B?MFdHVmsyaFJ0ZkxxYzdCa0F4TlB3QnNDMVZ3VzFxNkpFbHcxODc1UDlQeUVD?=
 =?utf-8?B?UlFsYm1ucTIzUkdzSUg5MkRsZ0RlZUFhZ1d1RituaHI5NEk2T1ZMWm41Vjdv?=
 =?utf-8?B?ZDFZS2Jkc0ZFSkYxekk3NmNLMzVkVTQrUDg3QlNEWVNZZmZMbzRFNktTWVpl?=
 =?utf-8?B?enNOckplakR2YU1hRlNPTTd3R0krQWlEc2UydTliY2hKREMrL3JMRVVKMi9h?=
 =?utf-8?B?TlkrVHZsRHZFeVZ3MlRMaEZUQmVVVTl6aDI4dlIweGRnZU5sREo5d1lLN3Nm?=
 =?utf-8?B?VUlVaXM1SW9MVUxPaVN2UTB4SERxamdaUFJDM2RLU3FBK3pZdDArbERGbzVu?=
 =?utf-8?B?eUJwZjJuM2xnVGduVjdPZkdLaU1MWGJVbUQ3ZHZUV1hSWitUYUlWMlQ0anBi?=
 =?utf-8?B?TW5XdXpVTkEwaFA5b3EwQSs3UmZaRmo5eS9qTUhOTVRxeFFBZ1NRU1lLRGkz?=
 =?utf-8?Q?BaJK6JINhSn8SGfZGqXcCk1S6So7QsmejLEUVUN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dbba69af-100d-4416-f750-08d94707dba4
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 20:42:12.8156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mWVtk3tnLSV5fJ4goliuacd1Qxk1DgVf0U/f8NwC2RbIof0mO2M5F4bDB4e8OrmtOdr8SqoGbRSLTVWC4bedfW8KU/w3ZHJ94kyFfU3+XoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2818
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Tony,

On 7/8/2021 11:14 AM, Tony Luck wrote:
> 
> Add a type field to struct epc_page for how an in-use page has been
> allocated. Re-use "enum sgx_page_type" for this type, with a couple
> of additions for s/w types.

Tracking the enclave page type is a useful addition that will also help 
the SGX2 support where some instructions (ENCLS[EMODPR]) are only 
allowed on pages with particular type.

Could this tracking be done at the enclave page (struct sgx_encl_page) 
instead? The enclave page's EPC page information is not available when 
the page is in swap and it would be useful to know the page type without 
loading the page from swap. The information would continue to be 
accessible from struct epc_page via the owner pointer that may make some 
of the changes easier since it would not be needed to pass the page type 
around so much and thus possibly address the SECS page issue that Sean 
pointed out in
https://lore.kernel.org/lkml/YO3FuBupQTKYaKBf@google.com/

> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 4628acec0009..e43d3c27eb96 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -26,9 +26,19 @@
>   /* Pages, which are being tracked by the page reclaimer. */
>   #define SGX_EPC_PAGE_RECLAIMER_TRACKED	BIT(0)
>   
> +/* Pages, on the "sgx_dirty_page_list" */
> +#define SGX_EPC_PAGE_DIRTY		BIT(1)
> +
> +/* Pages, on one of the node free lists */
> +#define SGX_EPC_PAGE_FREE		BIT(2)
> +
> +/* Pages, with h/w poison errors */
> +#define SGX_EPC_PAGE_POISON		BIT(3)
> +
>   struct sgx_epc_page {
>   	unsigned int section;
> -	unsigned int flags;
> +	u16 flags;
> +	u16 type;

Could this be "enum sgx_page_type type" ?

Reinette
