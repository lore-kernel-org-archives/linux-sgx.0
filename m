Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7B9C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  4 May 2022 22:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357555AbiEDWRg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 4 May 2022 18:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237788AbiEDWRf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 4 May 2022 18:17:35 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3478E50E0E
        for <linux-sgx@vger.kernel.org>; Wed,  4 May 2022 15:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651702437; x=1683238437;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sOKSFObDLaGnWOjQtTbUVYW1RzMcyp9tBn3i3MLf7vE=;
  b=UxZQBUK1hPuAebvnoe99IY3/CYjW/N28oYfNqkVpNYM/lTQwVuuwSO6A
   y7xsM6tTMSjw07lUeJ0IzP2r71HWkxBMi5pijUIdXKvOT6oYVoi1GBGO7
   4Ld1XJ3sdkFUHkW2vjF28sY5t08/yFX0k1Nus+V9cX+RcTJdtbOWwjYLG
   2K2+wq68iFIAv41gEjLnnbANZUx5sYiX8muHLBsMSpJSZOckzo93pIEua
   5O1LADKjZsXqUq3X7F3oo/d0iRjAK0IKZrvGf3lrTz5QUHcW+1DreUmtz
   DOw/jlzHSE1ilTWUAu1j9B17FjCQ4e9lNy5aiTTCxV+dAZIZyuggjNInq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="267507964"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="267507964"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:13:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="562937609"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 04 May 2022 15:13:56 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 15:13:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 4 May 2022 15:13:55 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 4 May 2022 15:13:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eg66WOpjqYcE0/cM+6vZRwPcrRzObV4Dp5Idze5GWywJJM2DZxTCLdLf4svsDhTp0ROT1Ai5jGxFvEe8qJghTSDLdmJdEIEBZ4CZOKya7VZAOZEaaN27Cgj+ZAJVxXE+RviqSPsgETNCfQYr4V07AjxDoItMtMG+PYbkqGwEtHl4HtRSJNOtG5mTIynX+E0tsPrsb2mweodFnG8eSZPXdCqCORsjt1q6XxJXhQZQttwLjemWjCzbsqtuaI8QeV0CP3bLs4N7v68X8bQtoix14X4wg1TGKauJEWjQcE81fIacTVFVA1NuxpUPuM4dc5CM8S/5zJKeUAJzrUUirG3E3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tpP3m4wyPDl2dC3wT7JfVIrQTla/puGT5x6V5PflCQ=;
 b=TvXJCD593p4MGOUY9GM7NoFAUoFifap6x+gTjZlzi4fGf2gLm5KCcKOF+NDizr+m2s9EDTJAFzUFETNvy0H+ooUcLQjiap94yX9drMZZ/hx7wSSayQqmivHUKBrT3ShRG+iu+VZZe2UuQiGMTFXlKx9m3i3XqpQ3JCo7IUaIepTKUs3iTifKgsO4ZuN/CZQomm7DEfGV/3bHtH0I5QbY0LTbqR9zhaG83BBB2abianAFNqNoUre8N2xRZE+5JhuAWiXNwNqOtefT1Sy5v4N1U2aOE2Xrt4Jx3bjQtujWfemlG+PMCo7KmIqqPINiYtPfSPWGW1l4zdQu87wWKVLlzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BL1PR11MB5221.namprd11.prod.outlook.com (2603:10b6:208:310::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 22:13:53 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.026; Wed, 4 May 2022
 22:13:53 +0000
Message-ID: <d4b52482-2dd0-d5f1-bda9-e1d97883298d@intel.com>
Date:   Wed, 4 May 2022 15:13:49 -0700
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
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c81711a1-f5a2-4a8e-df9d-08da2e1b5fa0
X-MS-TrafficTypeDiagnostic: BL1PR11MB5221:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BL1PR11MB52215D09E583B42904E3BE54F8C39@BL1PR11MB5221.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQokdz1omgx4YF6Z743WnCrZ6wzkuTQPiFFC2WzjmQ1dnrb1GCBBj37s0oJgc6/yV7Ap/bV22AGJ26EqLGSBLw9+VZi9DKFegIhM3zJOkG0/91jPL5ZvPr/J2NqKauYkPQ4anGUHBRbLayKR48U2AH8rJDuO68Ph+6hPI+Pwz+kJklJSQifLibiJ1U1GNaQzqqgjI/2r7lt84zl4cyatEJSNUApty3CW1MJDAAfoDNXi5u1tuvaJIFMirgm8mPJO2TIBDFrA62+lbzh8gRmELRY+2IYgtNfxAWgQY1cgWqJ/xABugQsYzbNq9Gqx1AdfLA9aYRQkcBgC9J4JGJOubiCrNHN8uEXtM8+yN4phvVP5wYf9wfyvvuYkH2azx6gO4j6tlqbuowcEXHRBKUF2iWi6yyXMB/djZXHmEMAeJy0o17zcHcoPfb/jqdictfhXAAx1BMTTrtmUxCksqqEqTNBUIIHskPIAGLNlnaNMAZelTB//loGydBAfrUWBK11PU3CmJqv1G0MgbJCXWnODL/LV7qVf9c5I15A5EGSEEK+wjk76FSDtn6Vp35amKt0CaJCYaDJeKKSNdpCSzGHi5A14XHGaWKuUwh4k92t9x2grH/uRprN2HBy3Ekz4vH5bjs16oR6IvtHnF8b9p42R/zhY03U/ElZMfvqzc1sDHUKeLCmg9c8ssOF09W2Na1/PBwOnKcKXUys3DzKFUUX/cHZO0D2AtK8ykQR2VkPM6L4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(31696002)(44832011)(5660300002)(86362001)(30864003)(8676002)(38100700002)(4326008)(82960400001)(2906002)(66556008)(2616005)(66476007)(66946007)(26005)(6512007)(36756003)(186003)(316002)(6506007)(53546011)(6486002)(83380400001)(31686004)(8936002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWRtNXpWZ2NPYjJxNXgzeURqUmJRSk5iMTI2Z2RQREVJL3ovOFBWK1lCcWRX?=
 =?utf-8?B?Qml2UE9jZUc4ZFAwRE9GWDhoYWpmSlV3Y1kydlE0S0VCa0RDZG1NU0NObktM?=
 =?utf-8?B?cGNFZm5iUFU4M094aDZtU1hVK0xWM3VZd3NnK1BYK2tXVUFLMVFQWHFaUFNQ?=
 =?utf-8?B?Y2txbk9oaUk1TDVoOElBY2VEOWhhQ1A0YjBsbHZpYTBsN1dUd2hXZXU0SWtS?=
 =?utf-8?B?M3Q2aHU5aUQ5bkorNEkyeGNHYU5WeU1PK1FuTzViK2J4akNsTjJsbHdHeDYr?=
 =?utf-8?B?QzV5ZjE3L0Q0emNsVEJXaWZDSTdORWl0dXlLRFYxQmVvbkphQjJ6UjlwU25Y?=
 =?utf-8?B?ZmNCd0Nvd3VXRnlmUk1EVy9CNjVjazJ5QVAzSU5CTzgrTWJPKzNTVTk0U1Fs?=
 =?utf-8?B?YkhEaGhIVUN5YTYwWEpYK2ZSWkRoRWp0V3U3NitVMlJMbllXM1RKU1BXNHJ2?=
 =?utf-8?B?TTJSVEM0L2twaE1DR0IwdkUxK3hOek9jbkhrTkFSOVJRdzVmWWpXSkZyUTVV?=
 =?utf-8?B?dDZKRWZNckNUZkxTcHplT0VpQ3o5UTVJWHVZRGhVeXdONC9QY21JTlpMQ3Fh?=
 =?utf-8?B?azd5OG81b3RIRjZkUks4SUV3c1hkcnoySlFSV1VuV0NvRzBWZDg1UUk4b3Zq?=
 =?utf-8?B?SHczRm1uUUZuMXRLZGFka2FRb2NHcDlmU2RkUi9mdXVNbnNKS2U2ejVuSW5X?=
 =?utf-8?B?Y2swMDFIaWw4T0JaOG9BYnRoRHFHa1JMdmhNMUJ3ZmFyU21Wd0FWenZPdk52?=
 =?utf-8?B?TGxIak4wUkttR1c5NTN0UC9WaW5ObG1iS2E1dzFlSlI4MWo1TWgwcE9uNktv?=
 =?utf-8?B?clUvL09DbEZscWthcDhmdjRaV1lwMFBPR1VaVy9xWmN4VHNTRmtZdnhpWFdI?=
 =?utf-8?B?QmxwYXlJU2ZtbmMzUFF3WXZ1L1JQWG96bVZIcEo4TDd0VWhCdHBvYWVNMlh3?=
 =?utf-8?B?MnpJRHZqcjJFTy9CQktZcmt6aDdzY29IRzkxNTB2eUVEeDV0TmFOM3pnSG1u?=
 =?utf-8?B?RmxpbU5JTTlCTEJkSWtLVXpodXF2eFEycDhFQ0NCcHV0V3pxK0xrNXJWd3cx?=
 =?utf-8?B?MVZINnNaTWpLMXo0cjFEZVc1TmtUWVNUK2R3bXdvZkVMYWNuaVhBR25CQ04y?=
 =?utf-8?B?VGFGcExGTFFvb1NoUGJnbEhyazNudDArc1R1YzBROWdaNFpnQ1J1YmZwOVVr?=
 =?utf-8?B?RUtKNGhIOTA1c1JUbFNyL2gwcFVlZEo5eHRja1J0SjhLVUU4aEhsT3Iva0tX?=
 =?utf-8?B?aG9DWG5rK2VteGlvdmFsU1FQa1lZNkNIM0VNSU5NM1c4M08rMmpxcE9Vd2oy?=
 =?utf-8?B?SitUbmlqODFyNFNxd290bmw3UnFqM0pFbnEzT3lYZUwwUFVtYnV4T1FpdFVB?=
 =?utf-8?B?NXdEeXBNeExET3RkUzRRN0FCdVp4bFhPQ3ZmdVJMR2VUV1pWS2ZJVVlaMEFw?=
 =?utf-8?B?UlhXM2pJaXNFYzh0WTllTDFyNHViVXhvbEc3NTNEMWQ1NnNRWDgwWE1LMWJj?=
 =?utf-8?B?K1RYdnRMZGM5WlFEWkxmT2RGNUhuMzVXZEdrOGdTVHRIdStUTUs3K1pSdWlK?=
 =?utf-8?B?Z2hnVUZnRmlZd3F3OVhNTDYzTStBOCt6akN3aDVoTmtXeVZpSk0ralEyeUhC?=
 =?utf-8?B?RDZzOUI2NTZuTUVYNFl0SkE3aTRrelI1S2dwUlVScDE0ZXJBbFJWT284YzEw?=
 =?utf-8?B?ZWE5WUpuU0ZHYXJkK3E4WkQycEtnYnd4VkhybHpCOGYvajlBbW5JWlExanlF?=
 =?utf-8?B?V1UxQlRTSlo2WHFQSksxNnE4WlBTMUFUNllSZ0N6WUsvT2ZjNGRETy9ERjJ1?=
 =?utf-8?B?QmpNYVlwUnF4UHliMXhsWm1RZDNvaEU1SkNTNzVES3R3cTc0VFRpcWU0K3BK?=
 =?utf-8?B?Vmh6VVVJSjR2UW1MdytpSXdyYUtvcVpVZFFqUllUaU51cnU0LzYwOWU1TEpt?=
 =?utf-8?B?VVcvSmVjUGhPdjZ1TGxmeEZ4cC9pd0pmM3lhV3FVMndZNnNYMng0b3UxeTM1?=
 =?utf-8?B?UVhIOUZQa1BrU2JWUjk2bWExaTJNRzFKVUZjTUJ5SmQwU1orenRBOFpTOXM5?=
 =?utf-8?B?cDBXMERmdG1BVTQxYXlxL283Q1hhQ1NYY1Q0V1BLYkl0T2tTSjR0NFRMZUJX?=
 =?utf-8?B?eDNFbnRaVmU2UEcxUENTSVM3NktYeU8wdmpJNCs4RVJNOXNSMkJ3TU96SEVV?=
 =?utf-8?B?dDBtNEk0RUVmYzluck1KV01MdWlUS2J3RGFsemlUem5MSEtpN1p4aDgrRlcx?=
 =?utf-8?B?TWFNZ1JQNTRubGpyckxzTU5vbG91NXREVXgwdGZpTkFKcFAxMWg0dHFGWXJs?=
 =?utf-8?B?NU1ySUNySjBVNWk2NzVpSVdJZnByTkdqTitFdEIwU2pxU0hWcGkrWWFVN0dY?=
 =?utf-8?Q?ikSXdN07rwkZAw/Q=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c81711a1-f5a2-4a8e-df9d-08da2e1b5fa0
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 22:13:53.6593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rbrnl8Sr3MRBILX4C9M4eVbpLoCTywn9vArATAox9zU0Sw/O5GCGqpMSu660YTsj8Okvv5NMMewUnKwA4/AOwD4B1sAIgTwsDY6HuoT+66k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5221
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 5/2/2022 2:33 PM, Dave Hansen wrote:
> On 5/2/22 10:11, Reinette Chatre wrote:
>> My goal was to prevent the page fault handler from doing a "is the PCMD
>> page empty" if the reclaimer has a reference to it. Even if the PCMD page
>> is empty when the page fault handler checks it the page is expected to
>> get data right when reclaimer can get the mutex back since the reclaimer
>> already has a reference to the page.
> 
> I think shmem_truncate_range() might be the wrong operation.  It
> destroys data and, in the end, we don't want to destroy data.
> Filesystems and the page cache already have nice ways to keep from
> destroying data, we just need to use them.
> 
> First, I think set_page_dirty(pcmd_page) before the EWB is a good start.
>  That's what filesystems do before important data that needs to be saved
> goes into pages.

ok, at this time the reclaimer sets the dirty bit _after_ writing to the
shmem backing store. 

From what I understand we need to split sgx_encl_put_backing() and remove
the part where dirty bit is set and only use sgx_encl_put_backing()
to do the put_page() calls.

The motivation for this change is not exactly clear to me since in
the implementation the access to these pages are protected by the
enclave mutex.

> 
> Second, I think we need behavior like POSIX_FADV_DONTNEED, not
> FALLOC_FL_PUNCH_HOLE.  The DONTNEED operations end up in
> mapping_evict_folio(), which has both page refcount *and* dirty page
> checks.  That means that either elevating a refcount or set_page_dirty()
> will thwart DONTNEED-like behavior.
> 
> There are two basic things we need to do:
> 
> 1. Prevent page from being truncated around EWB time
> 2. Prevent unreferenced page with all zeros from staying in shmem
>    forever or taking up swap space
> 
> On the EWB (write to PCMD side) I think something like this works:
> 
> 	sgx_encl_get_backing()
> 		get_page(pcmd_page)
> 
> 	...
> 	lock_page(pcmd_page);
> 	// check for truncation since sgx_encl_get_backing()
> 	if (pcmd_page->mapping != shmem)
> 		goto retry;
> 	 // double check this is OK under lock_page():
> 	set_page_dirty(pcmd_page);
> 	__sgx_encl_ewb();
> 	unlock_page(pcmd_page);
> 
> That's basically what filesystems do.  Get the page from the page cache,
> lock it, then make sure it is consistent.  If not, retry.
> 
> On the "free" / read in (ELDU) side:
> 
> 	// get pcmd_page ref
> 	lock_page(pcmd_page);
> 	// truncation is not a concern because that's only done
> 	// on the read-in side, here, where we hold encl->lock
> 
> 	memset();
> 	if (!memchr_inv())
> 		// clear the way for DONTNEED:
> 		ClearPageDirty(pcmd_page);
> 	unlock_page(pcmd_page);
> 	// drop pcmd_page ref
> 	...
> 	POSIX_FADV_DONTNEED
> 
> There's one downside to this: it's _possible_ that an transient
> get_page() would block POSIX_FADV_DONTNEED.  Then the zeroed page would
> stick around forever, or at least until the next ELDU operation did
> another memchr_inv().
> 
> I went looking around for some of those and could not find any that I
> *know* apply to shmem.
> 
> This doesn't feel like a great solution; it's more complicated than I
> would like.  Any other ideas?

I am not familiar with the memory management and found the above a bit
intimidating. Noting that you are open to other ideas I 
attempted to contain the fix using existing SGX state. Note that the
reclaimer sets SGX_ENCL_PAGE_BEING_RECLAIMED at the time it obtains a
reference to the backing store pages of an enclave page it is in the
process of reclaiming. The fix only truncates the PCMD page
after ensuring that no page sharing the PCMD page is in the process of being
reclaimed.

I confirmed with this fix that PCMD pages are indeed being truncated -
but only if they are empty _and_ no page sharing the PCMD page is in
the process of being truncated.

With this fix the error printed by patch 4/4 are no longer encountered
and that patch is thus no longer required.

Temporarily I added the line of debugging that you can find in the patch
below and this line is printed while running the stress test. Here is a
snippet from the log file to give an idea how frequently this scenario
is encountered while running the stress test:

[  368.277362] sgx: pcmd_page_in_use:49 encl ffff9e76d8660000 addr 0x7f2545148000 desc 0x7f2545148008 (index 282952) being reclaimed
[  368.277400] sgx: pcmd_page_in_use:49 encl ffff9e76d8660000 addr 0x7f2545149000 desc 0x7f2545149008 (index 282953) being reclaimed
[  655.620465] sgx: pcmd_page_in_use:49 encl ffff9e774ce50000 addr 0x7fbe340f9000 desc 0x7fbe340f9008 (index 213241) being reclaimed
[  655.620520] sgx: pcmd_page_in_use:49 encl ffff9e774ce50000 addr 0x7fbe340fa000 desc 0x7fbe340fa008 (index 213242) being reclaimed
[  717.514992] sgx: pcmd_page_in_use:49 encl ffff9e780cd60000 addr 0x7f312c8cc000 desc 0x7f312c8cc008 (index 182476) being reclaimed
[  911.387007] sgx: pcmd_page_in_use:49 encl ffff9e77a6770000 addr 0x7f252fa2d000 desc 0x7f252fa2d008 (index 195117) being reclaimed
[  946.991400] sgx: pcmd_page_in_use:49 encl ffff9e76dd1a0000 addr 0x7fc210784000 desc 0x7fc210784008 (index 67460) being reclaimed
[  946.991479] sgx: pcmd_page_in_use:49 encl ffff9e76dd1a0000 addr 0x7fc210788000 desc 0x7fc210788008 (index 67464) being reclaimed
[ 1157.210449] sgx: pcmd_page_in_use:49 encl ffff9e76dc550000 addr 0x7f273158c000 desc 0x7f273158c008 (index 202124) being reclaimed
[ 1158.478397] sgx: pcmd_page_in_use:49 encl ffff9e76dc550000 addr 0x7f2743cac000 desc 0x7f2743cac008 (index 277676) being reclaimed
[ 1158.478451] sgx: pcmd_page_in_use:49 encl ffff9e76dc550000 addr 0x7f2743cad000 desc 0x7f2743cad008 (index 277677) being reclaimed
[ 1158.478467] sgx: pcmd_page_in_use:49 encl ffff9e76dc550000 addr 0x7f2743cae000 desc 0x7f2743cae008 (index 277678) being reclaimed
[ 1615.425623] sgx: pcmd_page_in_use:49 encl ffff9e774cee0000 addr 0x7efe1692c000 desc 0x7efe1692c008 (index 92460) being reclaimed
[ 1677.797446] sgx: pcmd_page_in_use:49 encl ffff9e77efc30000 addr 0x7feb3637f000 desc 0x7feb3637f008 (index 222079) being reclaimed
[ 1802.242423] sgx: pcmd_page_in_use:49 encl ffff9e76de190000 addr 0x7f5344fbf000 desc 0x7f5344fbf008 (index 282559) being reclaimed
[ 1887.397432] sgx: pcmd_page_in_use:49 encl ffff9e76d7960000 addr 0x7f0870ba8000 desc 0x7f0870ba8008 (index 461736) being reclaimed
[ 1994.519753] sgx: pcmd_page_in_use:49 encl ffff9e76d98d0000 addr 0x7f0531b43000 desc 0x7f0531b43008 (index 203587) being reclaimed
[ 2178.070802] sgx: pcmd_page_in_use:49 encl ffff9e775b400000 addr 0x7f1134149000 desc 0x7f1134149008 (index 213321) being reclaimed
[ 2349.632505] sgx: pcmd_page_in_use:49 encl ffff9e76ed450000 addr 0x7f944b94c000 desc 0x7f944b94c008 (index 309580) being reclaimed
[ 2349.632597] sgx: pcmd_page_in_use:49 encl ffff9e76ed450000 addr 0x7f944b94d000 desc 0x7f944b94d008 (index 309581) being reclaimed
[ 2349.632613] sgx: pcmd_page_in_use:49 encl ffff9e76ed450000 addr 0x7f944b94e000 desc 0x7f944b94e008 (index 309582) being reclaimed

---8<---

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 3051a26179bc..53bcaa153378 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -12,6 +12,76 @@
 #include "encls.h"
 #include "sgx.h"
 
+/**
+ * pcmd_page_in_use() - Query if any enclave page associated with a PCMD
+ *                      page is in process of being reclaimed.
+ * @encl:        Enclave to which PCMD page belongs
+ * @start_addr:  Address of enclave page using first entry within the PCMD page
+ *
+ * When an enclave page is reclaimed some Paging Crypto MetaData (PCMD) is
+ * stored. The PCMD data of a reclaimed enclave page contains enough
+ * information for the processor to verify the page at the time
+ * it is loaded back into the Enclave Page Cache (EPC).
+ *
+ * The backing storage to which enclave pages are reclaimed is laid out as
+ * follows:
+ * All enclave pages:SECS page:PCMD pages
+ *
+ * Each PCMD page contains the PCMD metadata of
+ * PAGE_SIZE/sizeof(struct sgx_pcmd) enclave pages.
+ *
+ * A PCMD page can only be truncated if it is (a) empty, and (b) no enclave
+ * page sharing the PCMD page is in the process of being reclaimed.
+ *
+ * The reclaimer sets the SGX_ENCL_PAGE_BEING_RECLAIMED flag when it
+ * intends to reclaim that enclave page - it means that the PCMD data
+ * associated with that enclave page is about to get some data and thus
+ * even if the PCMD page is empty, it should not be truncated.
+ *
+ * Return: 1 the PCMD page is in use, 0 if is not in use, -EFAULT on error
+ */
+static int pcmd_page_in_use(struct sgx_encl *encl,
+			    unsigned long start_addr)
+{
+	struct sgx_encl_page *entry;
+	unsigned long addr;
+	int reclaimed = 0;
+	int i;
+
+	for (i = 0; i < PAGE_SIZE/sizeof(struct sgx_pcmd); i++) {
+		addr = start_addr + i * PAGE_SIZE;
+
+		/*
+		 * Stop when reaching the SECS page - it does not
+		 * have a page_array entry and its reclaim is
+		 * started and completed with enclave mutex held so
+		 * it does not use the SGX_ENCL_PAGE_BEING_RECLAIMED
+		 * flag.
+		 */
+		if (addr == encl->base + encl->size)
+			break;
+
+		entry = xa_load(&encl->page_array, PFN_DOWN(addr));
+		if (!entry)
+			return -EFAULT;
+
+		/*
+		 * VA page slot ID uses same bit as the flag so it is important
+		 * to ensure that the page is not already in backing store.
+		 */
+		if (entry->epc_page &&
+		    (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)) {
+			pr_debug("%s:%d encl %px addr 0x%lx desc 0x%lx (index %lu) being reclaimed\n",
+				 __func__, __LINE__, encl, addr, entry->desc,
+				 PFN_DOWN(entry->desc - entry->encl->base));
+			reclaimed = 1;
+			break;
+		}
+	}
+
+	return reclaimed;
+}
+
 /*
  * Calculate byte offset of a PCMD struct associated with an enclave page. PCMD's
  * follow right after the EPC data in the backing storage. In addition to the
@@ -47,6 +117,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
 	struct sgx_encl *encl = encl_page->encl;
 	pgoff_t page_index, page_pcmd_off;
+	unsigned long pcmd_first_page;
 	struct sgx_pageinfo pginfo;
 	struct sgx_backing b;
 	bool pcmd_page_empty;
@@ -58,6 +129,12 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	else
 		page_index = PFN_DOWN(encl->size);
 
+	/*
+	 * Address of enclave page using the first entry within the
+	 * PCMD page.
+	 */
+	pcmd_first_page = PFN_PHYS(page_index & ~0x1FUL) + encl->base;
+
 	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
 
 	ret = sgx_encl_lookup_backing(encl, page_index, &b);
@@ -103,7 +180,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
-	if (pcmd_page_empty) {
+	if (pcmd_page_empty && !pcmd_page_in_use(encl, pcmd_first_page)) {
 		ida_free(&encl->pcmd_in_backing, PFN_DOWN(page_pcmd_off));
 		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
 	}
---8<---

What do you think?

Reinette
