Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1537BC433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 23:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353408AbiD1XwY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 19:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbiD1XwY (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 19:52:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F01AAE33
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 16:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651189747; x=1682725747;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+T/K5xB9DyHh2/ymgLtyWBhwILSkRk3T7HhFkFDVj9k=;
  b=Kcilnaa78Ay29iLxtcWxtVVNk35Q3cIaTzw9oSJkQXas1fgP5/qPw/fp
   6uCBA+0v0ufwKpJ4Gu4eZG+GFkAXx/WajVYBpB5vWrglhGO4QXvSZxFiX
   HCsiBvYe3Z2smaN4wNMLV7zpVL5V9ZrEImBHTubJFkJUFukplUg2UJnRL
   1P6agkWAFmNWDGD6+rxezrjaE7CQKP4nb45HmeWh6iHI8U5gz2kxtE6Ad
   X1aHC0A8aXyRYkweVB0HuC6md4qGeCb0ZEbdmrL5f5gVcmUucRWCtecGC
   SIE8ULj29D8ZtcjHc72N7EEyrdrAqKU/EweFvFtSJFvh64xB7Xjycuc6W
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="253847358"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="253847358"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="541799448"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 28 Apr 2022 16:49:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 16:49:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 16:49:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 28 Apr 2022 16:49:05 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 28 Apr 2022 16:49:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kj/6XzUn9CYuBhqQewstise+0v8iIZhpLyPlnOMBHq9+9mM/jHOZXi1EzQDI/bNgnSeSa2T04oMidUCiAs2C+zeU8gHyqkVwiTaCgAVVOEoD/f7E7QRdMdLFWh8W25OZF44UXmtwrgboKjnt/E/PqPabTuttTrzNR/MDwbhyY9e7j96IGuu/3pVvNQ8tcCJROaWjEK9+v3+Pbj5KthGTRlg5pUta3JoIGLwfZGKVGCINgc3MbpOLOdmUjbd6yaDMzWjfvdJG4otwc0bd2+nIoGUD9D3LnA+qpeu9lL0l7Ydy8jjz+BVX6RMxy1MIxKF6dkfAyT8WwW3dr5O/wMiuaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Jn4xofY+WAWsjFkl5eQmWJSOB1LPJ5T0rHvNaVfiMg=;
 b=ijYrdNBmvoyLxizicdlzyqSboWdbACbF2GK9JuNk3ETJilSxv3/nHSqzBHxr7HmNfad+Qh8OGD8Ber540DqGrsU9AEYKCEaExQq/YPYJbv75+snFWCHh3rHsYpMNQGJnzQXSNHh+pU0RpLwvxriWJ+/0QDPyfSkV3gOw6by/FGSToaJbupzf6sMV6EcI3HUFR0+ufjf7mlrjXQsUOnSeaFryjH/Iu4GL1jAfLzEkBvNp3CYRrxcy94CPrBPQvJRywjgjCN6ElyERbKPg4fKh3JsoLOBG6M4Ft9KIoQN74zasJTjP+yeBxUIzqHww9z5h7DJM39OV2t9o796YxAqi6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by MN2PR11MB3919.namprd11.prod.outlook.com (2603:10b6:208:13b::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 23:49:03 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 23:49:03 +0000
Message-ID: <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com>
Date:   Thu, 28 Apr 2022 16:49:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
 <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
 <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
 <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8fa269e-ce3d-484f-1878-08da2971acc9
X-MS-TrafficTypeDiagnostic: MN2PR11MB3919:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MN2PR11MB3919D6712B2322D72A4E9727F8FD9@MN2PR11MB3919.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8izyBI3DvGZsa2rZdrYhDkmfOfDolgCeQTtPo+a8a4BWeeADrt5XMnd7CLfBNaJ/xklbxkQ/GE1EK1MIp4If2dTK7RLpAuAm65TBFH1bC8vjTwE/hR5EZTQk0Jq85Q6i5VMsDVTwKv2dlFMdcQcFj6h8e/sQQ2rLmkY1U5YOS3py6e2LkcqxCHayLESS453XgVQKePZkKV8beOA57P2vDDKmiDOLBAr9v3bR/p+yRUruhmcjDT5TfsEmaUSXWWK/9uy70YAMuHe6WA99ct4bPX9ER80N4cncFACkXXZlYY3L8sht7uKRNsFaRF84NVXzXXTGXWgcOOX5E6yCTzK5doDd7mMNLYf0Ae2TGu2SpJeYOE20NHaSZ/9qs+oJAL9VoSVYjvqS80cmXkIuiR7oW8Hm1vVPsgwGNQXUzxwuLhdzSRVa8pCx+M7bwDy3laOf4apzGy41fZQBAFfsQJ6PihR0mQ1fakkI7XNyEKIH4FsF9eApNJ8xTDeyCTjjDy5Cz0ocdl8MzOj8avOq2cYVxVrx0lcn1LxcdjtR1jmKp222o456OU2NqhxF1zAZBrKkEjHJ3Ph2vFf677RDvVqsbrW8Aklb8j1icLBVTNbdM4GFzXiuvypK1KV0dT4XsITjx4hZGdIy0movHgl6h0WIg7/1H4ate3YObH1WPXy/llcWp8kq38xmndh+vjIUhAgzJYunUjN9jqbiMbnUk5jH9OWBgi6w91OZ7kBgfqCg+dpzsS/cmjN6ajN1qdCEryDlOuyI7uLsMg3J+VAXKU8IwZ7oNaaSw8dkxLI/D+9UHfQ4VLQlpAPMliio4Wukm4FhqF9R2lpI9cXJ3roRFCmoSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(38100700002)(82960400001)(5660300002)(2616005)(44832011)(86362001)(8936002)(186003)(36756003)(966005)(31686004)(4326008)(6506007)(8676002)(66556008)(66476007)(53546011)(66946007)(508600001)(2906002)(83380400001)(316002)(26005)(6512007)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rkhtc2JWamxFY1lzM3N4YkxLRHFsMk9ramFRdlpZd2t6QTd4VG5SczNXQ0No?=
 =?utf-8?B?U0NaTXVCMkV1aGFFWE96OGQ0UTkzVDg5QXpSYlJ5ZTdjT1Bsd0xvNWF1WjB2?=
 =?utf-8?B?cDQ1K094WjFrc1c2dy94SVpKZjFpNGljbEw4VDc2YXdVQmM5NGhTeG50clFs?=
 =?utf-8?B?eFRPdXFIMllTcHF2ZlkzNlA4UTFVVkk5NzhkU3c0OEo0U09TeE1YV1BhTzlR?=
 =?utf-8?B?aTZyK0RrUnZNRlFjZW1mU0hxeVRuVDBjcUcrREhUNGsxcExmcmsrSkpMeFd2?=
 =?utf-8?B?M2RtSnlCR0ZEaFVMNFJaSjVkdU4zbG5hSUt6WnFWVVJkdEF5Vnd5MEtCdkVq?=
 =?utf-8?B?aXF2aXd3Sms3eEcweEFHM2EvdVR6T1lKOW8xKzljakpIb0Y3WjdoVyt2MFFq?=
 =?utf-8?B?TWI4b0JsR0lmVU45SjNDQTkvcFcybnNtcjVhd3hVSU9oV2NoRWNRWG5ZMFJN?=
 =?utf-8?B?cUQ3d05KMWw3eGRId0w2Z3phdFVaQlNFekJ5eGhDRDVhQWtoWTdrR2ZGY2hF?=
 =?utf-8?B?amlJRGZxU2xjcmdWZmpFNk5hUm4wN0xQUEM3aUlnaWY5NE9SMWlEL1JXSHBl?=
 =?utf-8?B?ZGFMWWt2cW5ac3FiSllldG95TmxYVzJMaXdnUzZKeHBVb1RUaVRNQzNUMjJZ?=
 =?utf-8?B?TXBuRUp0SGl2SnJ2OEZRVVA4UWlmMDU1eVFrNHVVTzc3Vis3N013WUlHOTFu?=
 =?utf-8?B?ZUFwRGo1VEZwVitwL3lvclE0TkhiVzNMWlNYQ1JzQ0tYbXl0N3JXSFR3aURk?=
 =?utf-8?B?bU1XMGx1b212K05nUjZyV2YrKzYyOEM4bVpBMCtmTDFNdzR3TzNFZEZKQWth?=
 =?utf-8?B?VFlCVHR0REpUSVYzejlKeXIxbURwVXBzMjh0Qk1rVHdWbGFBb1Bhc2xYZENI?=
 =?utf-8?B?MElaQWNMMkdhL1NEa0pDaHozTjlKcEtidDR1eXl0YUZIeFFMSS9VOUtVbWl3?=
 =?utf-8?B?OHBGTVZITVhoVXgzRE1NT2lOTlE3UFJiU080UmE5QUhsUy9zcVlIdDVGV3JI?=
 =?utf-8?B?Rzk0M2plRVdBNDJ2dFhWUU1sVUFTMFhXc3lxT1MxSWZmUUU2YWdzclI1bjFO?=
 =?utf-8?B?aEZpSG5PT0FHdmM5VUVZRUIxbFJheWswakJUbjVKbVVxY1lPU3RFWjNTZVhS?=
 =?utf-8?B?cFY3bkNmK3lJLzVyRkxNR2cvQjFBSXVEOXlFK0M0QkdJaUdGM3JZUUpKRm9B?=
 =?utf-8?B?Ynp5Q3BIQnBKV3M2SlNzaEs1R3V3djVIQkZDUmQzaHkrK01wTzAvSytBcStK?=
 =?utf-8?B?OG9DZjlYRlViUkZzT1BLZ0gwNVhJYjFnNUx4Y01HTEpXRSswTy85OXh5ck42?=
 =?utf-8?B?N3FFZFBOaVQwOFZHUUFYY214RUdxcGFtLy85c1I2UHV5UUd2MloyWWgrT0I2?=
 =?utf-8?B?a0w5TXFkYUFMSnFxRUxTMXNsdFdmRTlVWkNnK3ZOTWEvRDhrUTVGMHBiL3VH?=
 =?utf-8?B?aWN4RjllczhqemdHKzdieUZNbkNIbzdHM2NIYXYzeFc3aFhrYWNXTldmTVBv?=
 =?utf-8?B?c1A0VGl1ZDJoV2FQRGpQMjhYYk9xemUyaHdCL1BoZSt3ZFBoZy9nc2pWQUpV?=
 =?utf-8?B?c0pMYnpKS1ZwK1pyRGNOSUZxenh0dVFSb1IycDRtUVNrcy9iZlowTndmeVdH?=
 =?utf-8?B?YkRGMnFDVWRwWEc0aGJhNkxxLzc2eDE3SVBoTFAwbVk3YnJuRHFicExwYzUz?=
 =?utf-8?B?TWhwUVVnQ3BEdmF1MDFLMWlqclhoR3BPRjRPMC8xZXkxZ3djTGFORHIxY3di?=
 =?utf-8?B?eHBoQTlqbFBlbjV3ZUtvZXlMNzZyY3JPVmtoKzB6ZDd2eGtOL3dEOTNrd2ow?=
 =?utf-8?B?UDNDT3RPaGV5RWtOU0ZpTHhzNUNROTlheEUxdFRTWVI4NW1peHdITUZFTno2?=
 =?utf-8?B?VWR6eDlaZmhqeG1GUTgzSUx3b2syNUVlTjRreDQzTUUrendnZ296SEd3RXZK?=
 =?utf-8?B?eHBNeU5ZQ1drdVQ1Zm5XY2VvSHdNQTI2eDVtcElrL2pRZldWdytsOC9TZWcx?=
 =?utf-8?B?bEl6aysyVndTdkVSa2h5U0NWL1FMN0ZkU1RHdTl2cWxKaWtTdWZPeEFRSnNV?=
 =?utf-8?B?ZUk3bVBkMTNDNVpxQ0d5NVg2NmpvSlhsdC9GZEJIMGNhOEwxSkV4cjlQbzJC?=
 =?utf-8?B?K0I3VE83VjZaTlRQaERLR0VhalNmMlI2QmZKUGo3QTg4VUJNbDc0azJ4L3Ri?=
 =?utf-8?B?UFhhRW9hZDFabUtXVzVDZXE1eGI0ZWhhckNiWWFVRWpscitvb2VoYVhEUEtW?=
 =?utf-8?B?QU1LQXUzS0VLTlNKOUlISmhITFB2bVlPc254U1BtWmh0a3ZzblRYcHdId2ZM?=
 =?utf-8?B?d1lxbGc3WHNrb1dXeGZaU01PMHd2SkxBZGtZR04zREF2WC95dHZ0QXBwVXFM?=
 =?utf-8?Q?htS+tZkv9XTebZMw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8fa269e-ce3d-484f-1878-08da2971acc9
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 23:49:03.4968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u43u2xdxXLwblu6EoobZ7e5be+Pi3g44GIFQmCDRopYRTWSSPOMvf2Nx1fs8eK+qkihrqGc9xuC1tswBDgATyCBD7OHNnJuQEyau37N11U8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3919
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 4/28/2022 3:53 PM, Dave Hansen wrote:
> On 4/28/22 15:20, Reinette Chatre wrote:
>> Hi Dave,
>>
>> On 4/28/2022 2:30 PM, Dave Hansen wrote:
>>> On 4/28/22 13:11, Reinette Chatre wrote:
>>
>>> Are there any transient, recoverable errors that can come back from
>>> ELDU?  If so, this makes a lot of sense.  If not, then it doesn't make a
>>> lot of sense to preserve the swapped-out content because they enclave is
>>> going to die anyway.
>>
>> Good point.
>>
>> Theoretically ELDU could encounter a page fault while accessing the 
>> regions it needs to read from and write to. These faults are passed
>> through and the instruction would return with a #PF that is
>> propagated with the page fault handler returning SIGBUS.
> 
> We don't have to worry about those, though, do we?  We're operating
> entirely on kernel mappings that won't cause #PF.

Indeed, yes, I do not see how an ELDU error or fault is recoverable.

> 
>> Even so, this flow also impacts the SGX2 flows that need to load pages from
>> the backing store. In this case the kernel would pass it as an error
>> (-EFAULT) to the runtime but it would not result in the
>> enclave being killed. If it was a #PF that caused the issue then
>> perhaps theoretically the SGX2 instruction has a chance of succeeding
>> if the runtime attempts it again? 
> 
> How are the SGX2 flows different than what we have now?

SGX2 uses the same flow as the page fault handler to load the
page into the enclave. The only difference is that the SGX2 flow removed the
VMA permission checks. See:
https://lore.kernel.org/lkml/db3a14f2d2df7678dec23375d48c96b603f8cfb5.1649878359.git.reinette.chatre@intel.com/

As per the trace printed in the WARN the issue being investigated is
triggered by the ELDU run as part of the page fault handler, not
the SGX2 flows.

> 
> I also looked a little deeper at this transient failure problem.  The
> ELDU documentation also mentions a possible error code of:
> 
> 	SGX_EPC_PAGE_CONFLICT
> 
> It *looks* like there can be conflicts on the SECS page as well as the
> EPC page being explicitly accessed.  Is that a possible problem here?

I went down this path myself. SGX_EPC_PAGE_CONFLICT is an error code
supported by newer ELDUC - the ELDU used in current code would indeed
#GP in this case. The SDM text describing ELDUC as "This leaf function
behaves like ELDU but with improved conflict handling for oversubscription"
really does seem relevant to the test that triggers this issue.

I stopped pursuing this because from what I understand if
SGX_EPC_PAGE_CONFLICT is encountered with commit 08999b2489b4 ("x86/sgx:
Free backing memory after faulting the enclave page") then it should
also be encountered without it. The issue is not present with
08999b2489b4 ("x86/sgx: Free backing memory after faulting the
enclave page") removed. I am thus currently investigating based on
the assumption that the #GP is encountered because of MAC
verification problem. I may be wrong here also and need more information
since the SDM documents two seemingly related errors:
#GP(0) -> If the instruction fails to verify MAC.
SGX_MAC_COMPARE_FAIL -> If the MAC check fails.


Reinette
