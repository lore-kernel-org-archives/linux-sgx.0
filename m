Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2C7C433FE
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Oct 2022 04:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJKEir (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Oct 2022 00:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJKEiq (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 11 Oct 2022 00:38:46 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DD086891
        for <linux-sgx@vger.kernel.org>; Mon, 10 Oct 2022 21:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665463125; x=1696999125;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b987ndQ34egU34tEjluZIpWIg34FhOtwRwm83ml7BmI=;
  b=iQdCss0SPPwOm8KwYEjwmwZsTWxM90dFHJ0ehfOAFIJLw5h7OyavhHmB
   /gU/phLrsUPzW8+PeEzOvHl05h2ZGNOMUXwPOtIkYg860kLMdCbWgPheT
   6YQh4QE1ThgLOlJTtZbIVO8AV7JBvVC2K76/fBqFTSpmUW4zATYYe8dWj
   Y965FmHRWvtVOErZTZ5IZa1CCyawNuLSxZD3v64oFRTJ0/tGZggIX3kk7
   EBPsDYpJww8RBQHqsbC2TWfjJwQym8DKDlsnQZE/q82N0fjGbk8nZ9mre
   NGlwImWAWnXlsq4zbityq0h3QyqSkP73LZPPFuLIFk9Sn0PWMJLqmKcCs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="284787221"
X-IronPort-AV: E=Sophos;i="5.95,175,1661842800"; 
   d="scan'208";a="284787221"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 21:38:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="751599529"
X-IronPort-AV: E=Sophos;i="5.95,175,1661842800"; 
   d="scan'208";a="751599529"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 10 Oct 2022 21:38:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 21:38:43 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 21:38:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 10 Oct 2022 21:38:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 10 Oct 2022 21:38:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEDyXcU7rW6PI6RrAOyVqkK3amfVyj8Y0wtMKSA6E4OLwcRtlhWIwrzCS2J5U6AUk/Xpw1Y8viPS9XiupptUEG8juIUY4StbHoLWERzipBVyctXYLwlerxmIo2tIyrxVd6gMdl+wLHFlhXrTOZAYRZ1dTOp0PRlfAl6mBy0bQ/ORtdMLjpsCWJv6W90jmxKR3OcPFTxI3Ly8McJZH6pJvBykxtwMMDw57qjsUHwkATw9uwx+JDsuV05fgqO17qTLzVX+FAMHDHnBjsnVeSk/cwi/H5qIG/ATZBOK5rFqy/u3aT6TDGarKhIR8sKbbeE9H/6MlbUAvvlpgc5AK5a9QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uXmo8hBG0uykSe6tqZED8RNDsAVmJj0sB1CKCoMiRRg=;
 b=WTUhn8KlrcESZdfc7jVMsnPNYXgpVYVfTtjcILUpkvebUoGwwzdRHF36SjJpPg6ka9ygG5lpQrRW7mB6t21kptm6SrfLdoP5JD6cvYPYlel7EBfUPr7FMFGpv40vxeV5eJW2dOnLOuzqQ+Pe34BsVpTfti4bNdmYNodqEkRL54PyMbigwttkb5gJ8cod0JVUAqJRvf99euu7NvKOmuGE65MtMsr2PwZLX19fOa12By0FbVUU50lp6Vooegd+KQzzgVEkjaOQZcqkemqawXOOihCR8SBRJ++tCf2KeHFSmNEAxcE20cp0CBUQiSBqY4l1SCzmi9wZO95yJgBM52oP+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CO6PR11MB5652.namprd11.prod.outlook.com (2603:10b6:5:35e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Tue, 11 Oct
 2022 04:38:40 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e%5]) with mapi id 15.20.5709.019; Tue, 11 Oct 2022
 04:38:40 +0000
Message-ID: <7f6c9dc0-ab49-4637-b4fc-83c1ed6e198c@intel.com>
Date:   Tue, 11 Oct 2022 12:44:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <linux-sgx@vger.kernel.org>,
        <tony.luck@intel.com>, <jarkko@kernel.org>,
        <dave.hansen@linux.intel.com>, <kai.huang@intel.com>
CC:     <seanjc@google.com>, <fan.du@intel.com>, <cathy.zhang@intel.com>,
        <tglx@linutronix.de>, <bp@suse.de>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <befac658-a821-5ae3-94db-09bbf6fd4a54@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <befac658-a821-5ae3-94db-09bbf6fd4a54@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0026.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::13)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|CO6PR11MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 76dcef38-f712-402d-5a9f-08daab427808
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v3W2EOLVOAut+8XqPJDCBOe7oiNRrRTTiWGi39nywg5+oD9yMgtJ5PsarqdszWZMdtzFeel7xGvdLTSsiLxoYv3832EFFsfRmdX6VKVD1vb8UwjqLCpW2Q7bq68vc9JEWJgKZ5vOuMfB8VpZSG/M2SerFS049IHfKGRH58ClOLXhEmMueF39p5WqsVc4gUKZl40cby1e2p1Q2OTwurzc5V6G1BkJpwtdZDiWUsgDcrsg45xcxz7G8MJKMtF9f5+iN4HPJPLY1xaHX7muhKXi9YH6aYwzpO2nlHQjkLX0JgAOPjcVxIL0KxKWn9lqf48win6xGmo5n65H10ZG1jtTzu+17Iuv12xCYr+KUhBhPPJdO9lZ1hqibLJwsmKFWV9IbkY6m9i78CyiuolXJGMIGcLc8Mumt6kz1w17mNntqopRBdvtRpSLc+dUqNTP4gwzUVzkrT+lGdMS+13XdVsgJImZgOSvfBDyQmvL/wabXlZbO3f+p+SKfLOqYC0XRTA+NAC0/DPcYbHfsIlFizsY/cjXFtD2SzNZkjDQUmuXx+aaqf/PLINlNtyF3+X0B4+TMwIj1N6qoHGNWT0sq4yRXByGFkCPo2Nof4E9Smzx29bY5EcZNLLZTqsFfR46W+VlYsyKvVSzEAeEYdp4W8E0PKzzKU9Sm25Bdvhylgqc7Yatih4CPAmqGbrlyKX7wvXPM8RJmdVOwo7TB/1LahPy/+unJspYoEJA2Y9lCG5MdQ1FrlnktbGmNh10od5z57iq2lwGRt0NYQ6KJN2wDENLM1RZ79e9UG/6ukmoN033RNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199015)(38100700002)(31696002)(82960400001)(86362001)(53546011)(66556008)(26005)(4326008)(41300700001)(2616005)(6506007)(66476007)(66946007)(6486002)(6512007)(8676002)(6636002)(316002)(6666004)(2906002)(5660300002)(8936002)(186003)(83380400001)(478600001)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzVyRzJJMWdweEkrM1RYVUNCSnZoQXh0eHRHa1IzS250SSs2SGhkS2VnOEha?=
 =?utf-8?B?cFN4Sk91Mys2ZXVuWW5CM254TCtnK2ZyVWZZYXN2dUJMS2JpWDNwenR5eU9Z?=
 =?utf-8?B?NnFyU05RNXhsZDFBdDlZL24waWdwK3praDVrRkNyRXc1WFB2K2FxUW5Zd3Jn?=
 =?utf-8?B?Z0p2dEtuRkRhUFdsQnBORjJzM24wZkRVQ0UxVkpkbFlNSlBxNDdoUXBxekN5?=
 =?utf-8?B?cENaaFg4bzFZMGQvVHhSU3lCRk5kdmI3ODZRZ1NOZ0xPNGVqdEpRNzNwSWUv?=
 =?utf-8?B?OVh2b3BtQWxleG5SUWZscXRoRG9sMzB1YkZuSURRKzFGbFRsTDRtc0pSVG9V?=
 =?utf-8?B?STBCbXExNlo5SUwxdWpJZ3p4RVVzNXZYN2lXVE5vS0pLNk5XZW51eUZpT1R4?=
 =?utf-8?B?NHRnTkp5ajRlVWVvWFlsaVo3dmg2dnIxRGRqalBXc2Y1VXQ2ZTg0aGNkMnZP?=
 =?utf-8?B?cENGUE1RMk02ZitSS1prKzFPTHlFN2VzV2x4anFHRk41NHVaQVN2NnZxWmxs?=
 =?utf-8?B?MUJVTHkwb3FhQjd0OGdWejNIRi9iQ01TQlhUcjJYbXhpZXlRamE1d1REUjBK?=
 =?utf-8?B?VmFOWVp1MUlBUm1RZldUa1lrbkNiOExYUmw3YzNXZFVydDl0aDV4YTVrQmNl?=
 =?utf-8?B?WHJaRnBCcDlxWjkzZ0JCWGNtZU0xTjByaXFwMTZDbVlTcWZGNWdyLzVOOXJq?=
 =?utf-8?B?aGhWOG9sL2ZFN0VWRGJzdVhvb1JwRlNROHI1VVVzckZDdFVHdHJUcnNrK2Vx?=
 =?utf-8?B?TW0zZVlnU0NjcFlzZUFNNGQ0NTFQbm5KSmNFRXBEZWszKzI2eldHeE0zdkFZ?=
 =?utf-8?B?NW1zOVJ0a2xGYzE5d3NOR1V5aVNndU0vZWNRR3l1WE1pZG96aVc1Qi8xeHMx?=
 =?utf-8?B?UFE3Z0NYSlUwUkFTaG16RnZXNlNmMUIzTzBRekIwUHdmbkJ5N1haSkhtSGJv?=
 =?utf-8?B?M2d5MEpXKzQzOHI0aFk5cTVtT2VLSnhuMGUrbG9aN3FSQ3BuYWJZbmhSb0s5?=
 =?utf-8?B?Qk5RVTY4MVIzUTlscFdzcDBYWkpUK2dYRmg0U0N4dUE0WEtsWEtjYXhYUUEv?=
 =?utf-8?B?UW8wbklIVG1nakVaV0QwdWUzelRyanZTaTlmbU1rb2FaUnpPM2tIQVZjK3Bi?=
 =?utf-8?B?QVYzNjBrdkRiUWlBNysvSDVmUms3UFM4M3hRZmVPTDVVdEdqMGttUHpseE12?=
 =?utf-8?B?V3kwV0FWV2J4a0p5N0JocDNvSzNmM3pJU3lEUU5xNk1uMGFxQU9kS1NtQm1C?=
 =?utf-8?B?VC9NL3IxQlZyZ2hQVG5FUjdFaU5ydWpVRkZXY0F6WTV4Z2hMdzZUdHFmbmxm?=
 =?utf-8?B?dzA1dHN6bU5lYjVOZ1lXMmNXNmdXVlF4TGZJaW02V1JtVDRjNkJlU2FsZVFY?=
 =?utf-8?B?ZjExMnZFYytPdUJnTVVCaVovMytKTldXbjNSajZXdXI5T3gwcHVmU3AzOW9n?=
 =?utf-8?B?c1Z5MWErY3BZUnEzdllDZ1BDWTFYRkRYQXBXZTRhdi9RMWMwcTJDckZlK3hO?=
 =?utf-8?B?cWI3OTM3RHBZOWY4M2ZUV2IrZ25PVmVzWnFqUFdaT050RmNTZmhOTWRkQk9Y?=
 =?utf-8?B?NUhydWlmNmdlcEppOUxEY2Y2Q1R0WTFka1FUQWxCeWlUK2pvSS9qUFE1V3c1?=
 =?utf-8?B?RjJMLzl1K3pMQi9rN2FVMkdpZnB3L1Jmc1lyTkM4RUNXTDhWTm02QzVDVXRQ?=
 =?utf-8?B?QVptOG9xaXlVc2ltalo1Y2ZrcEFTREl0TlJvN0RFcDVyK2FPR3FRUVJ1SHFO?=
 =?utf-8?B?aVQvT3drY3BIUVRWdVg2ZlNrZ0ErdDUrZ2xYNnVIOHdsdWxmVTcrZnprb1Ry?=
 =?utf-8?B?QWhlUzhYTGZGVFVLVUdudnZ1eXU3MEEzMUV0R2wrcE9oVEZRNG1tQmFiVGJv?=
 =?utf-8?B?QllmZEw0b1FXK1FvT1FyUFN4bGs1TjZMQWErK3JaN1c1cWREUmhxWjhTY3NZ?=
 =?utf-8?B?L3RBMmFoQnZPZVU2VEFQRkNNUm9Td1lVemhuVXZZblhucHE2Q2Jwd01LRnp3?=
 =?utf-8?B?TVErSmRnVVQ1alhVWmxiTlhhUmx3Z3lreCsyZTdHYndsTlVoTXNIMXA5MnBR?=
 =?utf-8?B?ZkVENEVaSUhyQklQaFlOaURCd3ZHMGZUclpDQ1JEd1hObDFhaVBuMlAvQkRP?=
 =?utf-8?B?K1lJRTFkRWQ3TzI4UFh2c2poRU1iN0hFck51SU4zdUZkVnJwOHFLMFB3VGgw?=
 =?utf-8?B?V2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 76dcef38-f712-402d-5a9f-08daab427808
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 04:38:40.0413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2X4qKd1ApiCAFvsBp/3PE/y+6wYgHEFc/exg7Gv69/hU9jLimmVi7dOmCteGOn7AqhzArWFbng7mLJHI6CVtpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5652
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/10/11 07:20, Dave Hansen wrote:
> On 9/19/22 23:39, Zhiquan Li wrote:
>> +	if (flags & MF_ACTION_REQUIRED) {
>> +		/*
>> +		 * Provide extra info to the task so that it can make further
>> +		 * decision but not simply kill it. This is quite useful for
>> +		 * virtualization case.
>> +		 */
> 
> "Quite useful to the virtualization case", eh?
> 
> This code can only even be *run* in the virtualization case.
> 

OK, I'll change it in V10.

>> +		if (page->flags & SGX_EPC_PAGE_KVM_GUEST) {
>> +			/*
>> +			 * The 'encl_owner' field is repurposed, when allocating EPC
>> +			 * page it was assigned to the virtual address of virtual EPC
>> +			 * page.
>> +			 */
> 
> That comment is talking about history, which is kinda silly.  Let's just
> focus on what the code is doing today.
> 

How about move the comment above to here? Because it's talking about
what the code is doing today.
Then this comment can be removed.

>> +			vaddr = (void *)((unsigned long)page->vepc_vaddr & PAGE_MASK);
> 
> First, why even align this?  What does it matter?
> 
> Second, is there a reason not to use PTR_ALIGN() here?
> 

You're right.  The align is unnecessary, host kernel just reports the
error address, no matter if it's aligned, guest kernel MCA will convert
it to PFN.

Best Regards,
Zhiquan

>> +			ret = force_sig_mceerr(BUS_MCEERR_AR, vaddr, PAGE_SHIFT);
>> +			if (ret < 0)
>> +				pr_err("Memory failure: Error sending signal to %s:%d: %d\n",
>> +					current->comm, current->pid, ret);
>> +		} else
>> +			force_sig(SIGBUS);
>> +	}
> 
