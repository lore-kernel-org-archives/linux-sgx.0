Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFA7C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 23:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbiEJXAT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 10 May 2022 19:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiEJXAS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 10 May 2022 19:00:18 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DCF9BAFB
        for <linux-sgx@vger.kernel.org>; Tue, 10 May 2022 16:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652223617; x=1683759617;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a75ceA8DHWev6nRW4+bGxw+sv7pgRvIXY9aUfzJsBX4=;
  b=enQaPBSr+43T+8a4ZbAa/nt5eAbuOix0i+9/HsVDcsCtg7dQfpCB2s+9
   ofCEKj1U3kEhFtzg8Oqpd30P2QyVtUof0aEnjQCGYxpd+ZO79IeE2IhKZ
   f35rVr72EBcrAOwTAjc+EhcLKeRL3OBP0NLcHPxD8t9PiOIRcu28jqpIn
   fipJVbHW99ZcgBuYhaPbj1NMiS1cFwUBa6cIB5WWEWVreywe/4EgZ6BWX
   tamJEj9/WDcu7gO3l5tBP/vlhWEftKk7Lf8apoUbtGhWq9IfAzhPhrdfo
   Q9wCYTd2y2xnf+vssuC48c7x8wm9HyOY0HHygFoA2b+4CDUJoN4/M7KAa
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="257063991"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="257063991"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 16:00:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="623687242"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 10 May 2022 16:00:16 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 16:00:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 10 May 2022 16:00:15 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 10 May 2022 16:00:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jr7roLn2qiryCp43J3HnFc/fH6E3/CnghYzZRy+q8ZKVEevPBmVMudtgMbQZ/gtWgT/zCFLMiOQngro+DkqgsdOJzhASzAq5KP/TDF9mOUmfD9ck+0WoN5X3igNB2PZE6IgJ/+DiEktH9kJPBi/gd+07y6CnjncTN1hxSbjBp1+yMg6tLcdo1JBt83o+M/drQywa4rV3BPrhjrPXqeX/pBYgcc53qkE1PNMUHD/itrn0bCGt6NPCtNtXJASxQ8wCtobXYzgBqRn+GlfVBJmPF0aUDOCNCTDEzS1VkhqZlZ/B0deEeSLGg1/UPlhJgVlqDtD0gMwyDNu6EFp1WtAjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=By+ZkjHO0rD+BOJgnNojaFFYPb2oJ6Z7DzxFzHJOX14=;
 b=g7EfTHq5gRJHFI3Dndgpou8cLAutFMHD89H0LCvq+r0z7JqiFdxjaujAjQGRVMP41jDUkq7u4aMBre2iJS8r/m1n9IOnejXUC8rcYmULlpc9c1nDoOBz69k8Eq/bIFELsLcmyqlyNmZjg9idtOZqOBKf4CEr/R1dFcCpqt/XrPTZUcPoZz+kjGFQaKXlTfS5he1djJUrvD7trmxFZNz5GTqOeUf7JGIpbwqDjpc8JXvpTrEvOdoiR0zcmYbyKRP/esmX+IoQ0C5AFGV5K0QxoXfoWETSdKsmdZ2lS9f4Cazy9XY796OPJ565GBXOQBtxy1/emreKqSv4tthvMVW7Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by DM5PR11MB1769.namprd11.prod.outlook.com (2603:10b6:3:10a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 23:00:13 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 23:00:13 +0000
Message-ID: <e7e2952a-113d-fff7-6312-464aa6355466@intel.com>
Date:   Tue, 10 May 2022 16:00:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [PATCH V2 1/5] x86/sgx: Disconnect backing page references from
 dirty status
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <4cda80a0049de6bc47480b4ad119091027c11d45.1652131695.git.reinette.chatre@intel.com>
 <8922e48f-6646-c7cc-6393-7c78dcf23d23@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <8922e48f-6646-c7cc-6393-7c78dcf23d23@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0102.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::43) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba4c64b1-e2ae-49fd-141f-08da32d8d753
X-MS-TrafficTypeDiagnostic: DM5PR11MB1769:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR11MB1769AE92F8BE9BC5B921E94BF8C99@DM5PR11MB1769.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XOqWVxPKunTU3KyGUJtQS89XW31mknQ94tBJmhQwOTGfUsxmgeYPGKIXJ2HTyzxpXYRwCYQECmjqT5m4XKlTM8r5RBFnZBAai/aGi8gXJaFORDPIvC5a8ZHJAHQWxCBguz6ad7AlKu40xmm3YT7NFj0bX9r++8OoWXPnCu9Vg7TRYUi7qNJNpPwQkMLXyKe6XKJk8LvhLLfsXwG2fvBNNIZfIa8SNM9raxDITK2TP1CDG2ssNhsK18A9pCloYW/fzxjCi8nhIQ/7g7pNXO4DmNavK5EbvPK0ai/QCNNUEcDNL9A5jT+XFNoVnG5NzubNrz7qS+DDijDWf1x/49+zsTNqV1CxRfvvqZzFEYIqRiSxLRo7c7ouCUEfSnqu620zoH34ghvQA+IhBGmtl0sjyed0AapyTLD6Xbnt/t4blNzJJO4K8M3VVMbjJPIGQSTj91hxidv8bMVA2ggEpc12etOCj1qYRHNNYzmfw32aUT+YouEF7sEQ4Et+RsJI2UuBZM6mTxnCdPbBh88BZZiQYH2bS89qjG/s51wQVG7SbcLsvwwQYjNktBKw8wOkRaW3JQ9tCSNlomr3LvK+YzPLS8rW9RVGBdnex1twV+Js6hkzlS4ULwEQA0IkJ3AcgBl8f3bOT/hN5lNnGE2AGtKFN1U99ZzoxtaZDl2rbEIExu38Pm6C+LmwHWQrkWAP6YWPsFZITA0gnwzfU4ZzGhEDDi8FV6AZlONgcoN3IMjs9WjolPzg433Wf8tQHsTqSW+i08TPXKbt3PFq0vVeO+iVjIcn2WDl1fzOeTuDwUw0jvkDnsJ52AOufrCgSTuDgR9ufgAxmfMVwKHgaTjh1Qezua6Wjn0NUkw50hacRmyHjTQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(2616005)(82960400001)(26005)(36756003)(6512007)(53546011)(5660300002)(6506007)(83380400001)(8936002)(31686004)(86362001)(6486002)(66476007)(66556008)(316002)(44832011)(508600001)(66946007)(966005)(4326008)(8676002)(31696002)(186003)(2906002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUYrem9WdUtpcHlwNEkxTGp3OWZxOG1paTdoMjFLYzhGcTgvaSt6cE5LZFVm?=
 =?utf-8?B?NDJPd05sdE1OZXZRa1lHN0VrMEYzYk4rZTNrZUk5OENuRUpJYmcySENOb1px?=
 =?utf-8?B?Zk9RNUVGRVhZSm5wdEphYlI2bHpsSjBCQjkzZW0rU2tuTnJ1enE5SFZDa2dW?=
 =?utf-8?B?WnFTdjZZRURHZ0xoWXdjQXhCY1NVQkU5WER4WGI1Zk9DK0FmRXBEK1A3YlVP?=
 =?utf-8?B?eXdTcXFPayt2K3owTXJlTDBQbVgycE5RcW4vUm1jdklQekQ0OG5UR3RGazBY?=
 =?utf-8?B?L0phaHVtYzYxczRIN096UEVlcHM1N2x1aUJRb3hFbXZhQS9tNXllTWc0c0h0?=
 =?utf-8?B?OXdlL1dyOGVuQ1RjOXAwWG1aOHd4RDlLMTdQRXBCU2c0OUF5cFg3ZUZiM3Jw?=
 =?utf-8?B?K3d6Y0p6MFJvQmhJZmplOVNTQU5MTzdUQXBXTkhTZFVBL04yOEZZOUlpbHJv?=
 =?utf-8?B?Zml2VEdUTGRIYTI3THZXYkpLdjVSQWJiZVVmRCtBbnkzeHFWekdFK1pCQlJJ?=
 =?utf-8?B?cTdWUzVjRFEvbkZuUXFBd1IyYWhHNk9WYkQ5L1NqM1UvdVRPRWQvOEhTa29i?=
 =?utf-8?B?cFZ0VngrSExnSGUzWEtSYVFSYWNNOGFIc3F0em9GdDNHOUt6QWtTdUpYcEVr?=
 =?utf-8?B?aVRabXRrU1k0UDJkYzBDWXcrWGM5NnE5UXpSbVJOY1pQai9jdGFmZDd1YzBr?=
 =?utf-8?B?UnI5enJWbnNJSnFJNUNDWk1wcS9mMG9qZ2VIK3A4ekw0a0xqY2FiV0ZlVXcy?=
 =?utf-8?B?cktqaEtYQzdoWHdkTGxvUHc3MnlYV1J4SmM5aEZyNHhJUm03cXBLekwzL3do?=
 =?utf-8?B?ditCVnFwc2pZSTg5c09aSkV1cm4yWlFrVk91ZnhQeEYxQmVHSVlYZXFhOGdI?=
 =?utf-8?B?QWQ2SElLYkpEYzhtOHpmd0xZM2tUOHpSUkIvU3NEZHQyeGZ0T24xaGhwbXNj?=
 =?utf-8?B?T3FudUk1MDRTSllUdzZyUzN4WE1XWnhKdWdRZDIxL3ZhOGJGZVRuSnJLWTJI?=
 =?utf-8?B?TmZvbHBRVCtVV05sL0trSTJ3c05wRnBKQVNrTFQ2dGd1YVF5NU9MV3IxZVlL?=
 =?utf-8?B?Qm1MUDBKNmhiYU9qMlJxbmtKVVg4cGpNUHA1SFpHNzAxM0RGM1lKa01lV0ZJ?=
 =?utf-8?B?VGdxYXFFQkNRQzBKbU9RNExOc3Y0Z2gyMjhYbkZ4NzdSOXlrZ1Q4YkczbUhn?=
 =?utf-8?B?V1pPQWhRRUpTNXJVYVpFNngrVElaQVdoclVCUmFLY296S0xKNko2czZYOXIy?=
 =?utf-8?B?dFpvYVBsV0hIRzBFQURVa0lXQWxRbXdtSmxlVm1mNERzbEQzVERPdjV0YmRx?=
 =?utf-8?B?dEcyQUM4SFExdDJtSEViN2RUSTlYdlJraTg4eGFmNEROOCt4Z01WdDZDd3Ux?=
 =?utf-8?B?cVJIQ0ZTSlBqRnkzYldIaEpGMy9JeWcvVmdzcm9LUjVmdVlnOElsR2UrNnE0?=
 =?utf-8?B?S2tKVmNyMmJwdUN1Sy9abWZPNUg3QjY3Sm1GZ05Zb1BHWDljemc1N204UUFK?=
 =?utf-8?B?R1V1VUZXcTJkcVhLcDNtczFYZUtIMTFmRXRKOGVUY25WRVZBazN5TmdVYnRD?=
 =?utf-8?B?Ujg1YVlPSnV5NHZ4aGdRTFh1dzdGcDN2b0N0QkYyNkU3VHRCRzZWS25CUHNo?=
 =?utf-8?B?WGlKUUdFVnNidnNnMlIzOU1BTnpuc1dRMGxvcU0rTEtEaUJMUWlMMkdwT1Av?=
 =?utf-8?B?S0tQcjA1K3ZBTVhLTGdqWHZvUlFiVDU1aGp3bnhUVlZrbVhGMmsyb0JJYy9a?=
 =?utf-8?B?RWtQS1FwdUZMaVN5UmRkVFUxQ05LdEV3eWxIZWpVVWxMMjRRcGdFSHFXeFBy?=
 =?utf-8?B?dDB6WEdLY0NUczV5ckV6TDdmL3BxaFFWNjZLVDZZSDV2ZHVmbmFPVkwxRWcr?=
 =?utf-8?B?YmpoekFYd1MyOW5VdUY2Q3hqVEhXdUZqbWQ3S3VoT0g4R01Ma1RoVmk5MmRW?=
 =?utf-8?B?ZFZ2TEcxdFptaXBZUEFKVDVoVW1IU2lEV0dkbEFNWW9FTjgrZ1FiYmVKQk9E?=
 =?utf-8?B?a0hwNWUwaTA5VmpNT2ZjSHBoVTZYN1cwV0RYTFdEb0IvNG1yNEZjRmZpbFpR?=
 =?utf-8?B?UCtETHk0NU5SLzJmSHBsaFJDTTM4QkpFK2ZnN1l6aW5UMU8rc1plSTF0ZjhI?=
 =?utf-8?B?VmpFVlBDOU5CMk9PNSs2bEtueEhJcjRlV3FDeEVPNjRsVVNLeFVqdnFBdDZa?=
 =?utf-8?B?RXFzTXNHckJhZFZRT3RJa05NR1g1THZKb1BObWNNL2tvL09HVTNQTXl2ODVC?=
 =?utf-8?B?dUcvWm0yd0NHRUw0SlplWEZZWk9Dc2N4ODZpRDl1Tm5ZYmYyZGE4ayt0WWNW?=
 =?utf-8?B?ZS8wVUtEcVdOYW1IcDBpWFJuZEhtaHFtcFhjcXpGNmhYM0taNnFMOXJ2cmNH?=
 =?utf-8?Q?C0B8FsZAK0OHOb8M=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4c64b1-e2ae-49fd-141f-08da32d8d753
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 23:00:13.6120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3yIt3ZUmU3LjGF3D+ZQfz6MPR1ThaE4ETuTpHfuAei1R8D+n5nWaufQyLpyH5AD+ux33gGrPo7NJ4YVFHiuiCR/DwSxCujQkduPE97nObWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1769
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 5/10/2022 1:12 PM, Dave Hansen wrote:
> On 5/9/22 14:47, Reinette Chatre wrote:
>> --- a/arch/x86/kernel/cpu/sgx/main.c
>> +++ b/arch/x86/kernel/cpu/sgx/main.c
>> @@ -190,6 +190,8 @@ static int __sgx_encl_ewb(struct sgx_epc_page *epc_page, void *va_slot,
>>  	pginfo.metadata = (unsigned long)kmap_atomic(backing->pcmd) +
>>  			  backing->pcmd_offset;
>>  
>> +	set_page_dirty(backing->pcmd);
>> +	set_page_dirty(backing->contents);
>>  	ret = __ewb(&pginfo, sgx_get_epc_virt_addr(epc_page), va_slot);
> 
> I think I may have led you astray on this.  It's typical to do:
> 
> 	lock_page(page)
> 	set_page_dirty(backing->contents);
> 	// modify page
> 	unlock_page(page)
> 
> That's safe because laundering the page requires locking it.  But, the
> page lock isn't held in this case.  So, it's possible to do:
> 
> 	get_page(page) // page can be truncated, but not reclaimed
> 	set_page_dirty(page)
> 	// race: something launders page here
> 	__ewb(page)
> 	put_page(page)
> 	// page is reclaimed, __ewb() contents were thrown away
> 
> __shmem_rw() has a similar pattern to what __sgx_encl_ewb() uses.  It
> doesn't hold a lock_page(), but does dirty the page *after* its memset()
> writes to the page.
> 
> In other words, I think the page dirtying order in the previous (before
> this patch) SGX code was correct.  The concept of this patch is correct,
> but let's just change the dirtying order, please.
> 
> Could you also please add a cc: stable@ and a Link: to either this
> message or the original message where I suggested this, like this
> (temporary) commit has:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/commit/?h=testme&id=5ee32d5d3f3cdb943b01992d2ffc5093b139d023

Will do. Thank you very much.

Reinette
