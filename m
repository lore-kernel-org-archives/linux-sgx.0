Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8F4C4332F
	for <linux-sgx@archiver.kernel.org>; Thu,  5 May 2022 00:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbiEEAEy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 4 May 2022 20:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349958AbiEDXkh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 4 May 2022 19:40:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA525614F
        for <linux-sgx@vger.kernel.org>; Wed,  4 May 2022 16:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651707419; x=1683243419;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KwtvRMkszRqN5Zl4LYhd2hOaDOx4E5/NyOfrUHnjIqw=;
  b=hUGJdwKgvEtcWzjfbI532cqDnANtoGc5JK6h0idTrdQU7IqxbSRL385k
   MFNm9As6rSdaRwccokHSGU1kEG/MhaanKhTP4QGZO70XnkRaMfYsLVagm
   Bm9LIga4wXNynj4Wtdcy8xUk7ubgFHW4FAFPNwZvt57DZO3H2dbWxI7/J
   oEVvfqzhJMSeR/UHBA+8qVvtSdRwlPXKVLFNC+WpmaoB22dqTVOCob8TS
   QGICbR7iBkmc9BpwVmhrvrvd92MKNTlBubSRL6b1ZC6mpVGUAG23RLgMC
   foe06O3f/rXsCstBPOYShV6MyrpUQLF7Ar2C0klvYiltUf/KizJSL/bSw
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="265524999"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="265524999"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 16:36:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="653949551"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 04 May 2022 16:36:50 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 16:36:50 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 16:36:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 4 May 2022 16:36:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 4 May 2022 16:36:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTK2nbLzg0lTAInsTVRWib+eDIjqinUXB0/0FJKyvV/v3ZjRJWjTsmqx+AsZLLs7WtDaA6/qSqLwO2iqlOKUkzRMwHzZltBCL+mtpK+qjnTzaQ+HYGe6djtXiQLAOPuEher7QldTOeHzuNC1sLfO8aaX+cLSGgm8wBuk2ZRy5kYw0mXNBiuvEwfQ5QafdClQ7WFDFcdiRSMS8MNRF34tDfFBkI8kXrHtMsNGpjoB+A5neXyu1PaXPKKThR0nem6zPd6LtRGZBrFljlFS7xmIqdvPeF3DFw81AwdUAFu0c3675HB2tWvDYMGvvXxdGM2EX7mwxs+Lasw2pyDeMmdfEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B5VIrotuJys/8UhwA84fQpoc1+olE/AnCJQQC+C8T6Y=;
 b=eiWV5bR+SD1XHSYgosxNaVYxHhfjIH/d7lWfFoxWSq4DTLENDXIkpByiiEl2UD1f9aO98U04PWA3bik4EVlP7DqMilebAiwmClCcHNm6+wHgH2drka9RaV+djSGs65fHC52W4P22/458o7qMbQB+EnGTbYplBRoQybxu4vIPh9c4pWojXpmLp965+uwra6GP6azKUmD8rDP7cIqJgGYBYJ3cIaGC/3CVKtMQaTt/rFdAcTO1qup6dyAP3sjEysFTRCutkrdlMTUEYE7yQj+Wr3nkMOYK/F+lR+Jki4CNtwG8HsmrSCGfyi1ZdocSBuwSJC1tL/1DBQvRxDk3Ut8y9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 23:36:48 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.026; Wed, 4 May 2022
 23:36:48 +0000
Message-ID: <468848d0-ad58-8da0-dd39-b9604d458cdf@intel.com>
Date:   Wed, 4 May 2022 16:36:45 -0700
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
 <d4b52482-2dd0-d5f1-bda9-e1d97883298d@intel.com>
 <705c7c6a-3618-2d74-115c-68347b8aa8e6@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <705c7c6a-3618-2d74-115c-68347b8aa8e6@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::38) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dd8c8cf-8db5-49ae-ea94-08da2e26f506
X-MS-TrafficTypeDiagnostic: BN6PR11MB3988:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB3988CAD1721E0FCCBE45B144F8C39@BN6PR11MB3988.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAPTffDVIwK1ZH+hbHCY8XOVjATIyPomn0MlrXVyvIG4lvJ31IdySgSWdOUTeVA91pUEAenZhCQiVC8mCBW4sztRYyZHCOqMqIs5UZ4XrY4Am5kipkjGeZpDgkff10FoNCRuSktCAGLyto8DdkrV0tsa6DHKgXLb9sxufXSz7fi4E/Ehwa+kwm+Z/FgxJpz1A5JLwIV4ksMnPGLdEZoTZIMjmKoIx/Agl3qtpA51ONGbD/e4Jy2VtojZvJKOIhbhm+SQ4P/dwRHkIgrN8sEn8YK1XFP6bt8wtTBsK+zlfq4N+RYaVoaUPYW0k/rX1TKCPqxWPWP/avvLHkigi16tddkr5S9UlSU330F2ToPfwL6gXzSrmQp+0fNdBVemIt5Sqm+J+8sUU0BL9EwaBu0GET0kMe8uTh8WkkYJnMlrFJF01CezrU+gbWA3TQfv5ld5jHcXnwjswivH/M8I6jy5qmRmRsWHJWJdipftGDyOcFAidnX/H9WqwAvLMrR0OsFgNmVd00755p5Nx+Sddx+Syq74iEAcU1wdG5dykvO4AS/ydVXMk0x3imqoGhHVv557GjjV6ICOJ9kLbJkWBEzHyDSwacvag1IYtcGPpfJJFppgjJOKjrEB080h9rsiXHD4CyvjKrKGONYH1uaxCQmCulxw1TNxcDspxLQd1K/jiIwA5HzvGbkcRCmurThbkcQj36uuE+mCPcWu+SfwxgZ2pV1FQjIwkPWBovWu31I+m3P+3e7QvWAifQ6jKn2s3GS2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(44832011)(36756003)(82960400001)(186003)(5660300002)(86362001)(8936002)(508600001)(316002)(6486002)(26005)(31696002)(6506007)(53546011)(66946007)(83380400001)(6666004)(6512007)(2906002)(66476007)(66556008)(31686004)(4326008)(8676002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTkyZTNMYnBOc2ZnMnRjY2wwMTZoZjVRa3d4SFplTWpJeDVud2JUWHZ2OWlW?=
 =?utf-8?B?UldBc25JUTBJRU9Ic0RwdUl1M1VRZ0pWaUljVUFJcXhzY3BHTmdXMEZVTSt3?=
 =?utf-8?B?ZWJUejZmL0p5YzB5TmhCYy9nN1dhZ1U2WDgxaEdlbC9xRG9odGI2SG9nT3VW?=
 =?utf-8?B?UnRpcXZDN1lSQnFYQ3NNNGQ2NmxYMXJLWUsxbWpEMThCMWxqQ3ROOHQ4UW9t?=
 =?utf-8?B?a25KNWZmdE1Wb08wbTJwckxSdjVtb0NXV2ZQRUQweGwzcDB5Zm1UMy9yWmNX?=
 =?utf-8?B?dkttaXdPQnNZV1hsSnR4OU43ZFlvYVdTMWRGTzYrQWdkVVNJdU0yM0NDYmk3?=
 =?utf-8?B?S3FtUkEzYzZ4RjNlb01vT3Z3Qk9LZ2ExMktCMjcrdzlhR0xYS2ZlMUltdW84?=
 =?utf-8?B?WlF5ZmtLVTBRNk1sYXZDRlk3cEhja0pQT2drdFJ4bkwvd3hvdksxa1lBMndv?=
 =?utf-8?B?K2FEU1JHWG9HamZhRmhhMmN4MXJKV1RkSFQrQVdmRTVwdzUrVnRQYUZiNXRJ?=
 =?utf-8?B?bVloNXhaWUtRaldZaE41N29OYis3Ti9iSjYxeFlCMU9LMFA3YTFqWm84WVpP?=
 =?utf-8?B?L09WUnhJL3F5YkNsUkNJV2N3SDFkbzdyV09PWG1JeFhBQ0R0YXI0ZnlVQ0Ns?=
 =?utf-8?B?eCtxYnB1dUpjT3E2ckRqZGJQN1hBc3N3Y245TGM0dzU0dTM3K21MQkk1SjR5?=
 =?utf-8?B?QVl3ZFFpbkttdCtzZ095U0JIMWRHSVd5dVF6SjYreFJmT3NBQi9pTnpCT0Zl?=
 =?utf-8?B?akk3WmZWVDBEaTAvN2hXVzV2a3A3YVF6WEZBd3llZ0pPVkozOWgvcmdPRktw?=
 =?utf-8?B?K1VKTUJrVWQ4aHJOZ1VHQi9jTFdrTTFjanNJUnpFQ2RIUXB2cUVKVEVaeFVG?=
 =?utf-8?B?TzZ2b2xvTFJxTHRmRFFTalJHQlBDaEY4bmRFMVVKMkhBNGNXWm5nblVrRHVZ?=
 =?utf-8?B?M3NDRVgwL3FYZHoxWjkzQlk2TU5PYmxsT25qRmxUQVZ0VFZ2LzkrVjJMUTVw?=
 =?utf-8?B?d1pWNEZKZ2FHeEtYYkdWRFI4dG1QalcyaER4Qi9icUJ6SlI3bVc1a2FCV2FS?=
 =?utf-8?B?OVdCRDhtNjB1NjQyNWN4NzF4dHFzaDZOTGo5SE05NDVyTzFVcml5SldBbENv?=
 =?utf-8?B?QUZETVJIRmRnS25XcHN5TGsxNmlNNU1uQTZXdzRVd3ZJSGVLTHRVUWRBR1R6?=
 =?utf-8?B?MlEzdXVpU3RHYXRNRllHZktZRWdwT1RPeUVpL3VlM0hPUTlEWjJudTA2bENy?=
 =?utf-8?B?QmlDOUtOOWJ3bVpYeVRIU3FBV2ZMVUw0MWtHRjNJakM0V0MxdHpKRTZ1Q29N?=
 =?utf-8?B?RVdVRUVtd08vY0MvTURFQ2w1eS9EZzErZG1yVTFrR2Z2L0dISzZiUXhNcy8x?=
 =?utf-8?B?UDhPVUlMUll3aXRMSi9nYUtodjU2dzF1YjBvLzhFZW9YbHJTcy90eDBHSXJJ?=
 =?utf-8?B?dk1mbGhXbFh4R2M4eVE1Q24wNnJ1ZWdPcjZ1TlorREtva0kvbFVwNnVZNWxq?=
 =?utf-8?B?b3Y0bHhSWGY3cjZkV2VyY1ZaYzVibWFKYUtyQkd5bS9aSmpZZysvTm9QSjBU?=
 =?utf-8?B?WkMzenpBZUdXVktJL2tRYy9FSCtZMkVQa2V2cldWbHVrVDEzbFN6SlJQclV5?=
 =?utf-8?B?YnE5Rm9KWHJDRisrVElUc0ZPeHp3WHU1L1Buc3A4WGJ5OWt5ZTVpcUdIUGxi?=
 =?utf-8?B?QjQ1dUxzVUdmQUJXYm5INmxaeDQzUnRweEVWVW5PSzd5ZGxBTzI3WW1rUTd1?=
 =?utf-8?B?NFpvSlNaMXp2VWgrakQ2THFFeFhiTi9BTXNDZDVYdFMrem0vRnc0WkM0WUxu?=
 =?utf-8?B?MW1DQVFlYm04ZGQ4Y1BidzF3N3FWM1k0R3dKQnFvd2FCcFI3MmhYVEk2aHpJ?=
 =?utf-8?B?andsVktjUHplSlRWWjB4dU9JNStQMzNzNnJoSVNLblZQaTZRdDR0QnFLQ3BD?=
 =?utf-8?B?UTVmWm1ZRHFBMDMxMEs0ZW1LL1lsd0swaU5PbmlyMk5nTmpmMFMvM20zWnNm?=
 =?utf-8?B?Zks0dXZrc2xnTU92RVpXVEdINWs3NW9xYzhsTzVJMktOMUpUeDRiNm1PbVJY?=
 =?utf-8?B?YXhjZkNlUHhpVm1uRnVBNEg1TlpzdXlDQjd4WDNwUFBMNVZaU2hrbVNWYnBj?=
 =?utf-8?B?ZTUrVjRaclB5cGswZEJSRlRtSldvdlZxRGR3bWl3MWFodzgwVjBMMnB6SG52?=
 =?utf-8?B?bXhDQ2loMDMwaTJrYXg0bTdEWlBHZGE2LzU2aWQ1WlpCSjNjNXVnNDdXanh6?=
 =?utf-8?B?cVNzeUt0eUpOSHA4RU5EamVSKzBnd3lHWnlHQ1FrRHlQSHNocFJ3WjZpV0hz?=
 =?utf-8?B?Y0UvQkpybERuSXVJVUxrY3BpMFlzVEpNRTMvUnNwc1JwSXgvUHpOVjA0Smt2?=
 =?utf-8?Q?raU3tCyhw8oNwzUI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dd8c8cf-8db5-49ae-ea94-08da2e26f506
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 23:36:48.2750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ysj3MWmh7oHb55WekMPoZKHcvP+Ljsnsk+3+7nXJmxv1Hs/vcZ6gFv1AS3NHau0V5iNe9lvb0kW4N20qbwqqN3BHU6vuiWQwEuI+YD8sluQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3988
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 5/4/2022 3:58 PM, Dave Hansen wrote:
> On 5/4/22 15:13, Reinette Chatre wrote:
>> +		/*
>> +		 * VA page slot ID uses same bit as the flag so it is important
>> +		 * to ensure that the page is not already in backing store.
>> +		 */
>> +		if (entry->epc_page &&
>> +		    (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)) {
>> +			pr_debug("%s:%d encl %px addr 0x%lx desc 0x%lx (index %lu) being reclaimed\n",
>> +				 __func__, __LINE__, encl, addr, entry->desc,
>> +				 PFN_DOWN(entry->desc - entry->encl->base));
>> +			reclaimed = 1;
>> +			break;
>> +		}
> 
> I don't think this works as-is.  As it stands,
> SGX_ENCL_PAGE_BEING_RECLAIMED is cleared *BEFORE* the EWB.  It's
> possible for that check above to race with SGX_ENCL_PAGE_BEING_RECLAIMED
> being cleared.  That would erroneously lead pcmd_page_in_use() to return
> false *just* before data is written to the PCMD page.
> 
> static void sgx_encl_ewb()
> {
>         encl_page->desc &= ~SGX_ENCL_PAGE_BEING_RECLAIMED;
> 	...
> 	__sgx_encl_ewb()
> }

You are correct that SGX_ENCL_PAGE_BEING_RECLAIMED is cleared before
EWB. Please do note though that clearing that bit and running EWB
are all done in one section with the enclave mutex held the entire time.

The page fault handler cannot check for SGX_ENCL_PAGE_BEING_RECLAIMED
until the reclaimer releases the mutex.

These checks are thus not able to race. Here is a higher level view:


    sgx_reclaim_pages() {

      ...

      /*
       * Reclaim ENCLAVE_A
       */
      mutex_lock(&encl->lock);
      /*
       * Get a reference to ENCLAVE_A's
       * shmem page where enclave page
       * encrypted data will be stored
       * as well as a reference to the
       * enclave page's PCMD data page,
       * PCMD_AB.
       * Release mutex before writing
       * any data to the shmem pages.
       */
      sgx_encl_get_backing(...);
      encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
      mutex_unlock(&encl->lock);

                                        /*
                                         * Fault ENCLAVE_B
                                         */

                                        sgx_vma_fault() {

                                          mutex_lock(&encl->lock);
                                          /*
                                           * Get reference to
                                           * ENCLAVE_B's shmem page
                                           * as well as PCMD_AB.
                                           */
                                          sgx_encl_get_backing(...)
                                         /*
                                          * Load page back into
                                          * enclave via ELDU.
                                          */
                                         /*
                                          * Release reference to
                                          * ENCLAVE_B' shmem page and
                                          * PCMD_AB.
                                          */
                                         sgx_encl_put_backing(...);
                                         /*
                                          * PCMD_AB is found empty so
                                          * it and ENCLAVE_B's shmem page
                                          * are truncated.
                                          */
                                         /* Truncate ENCLAVE_B backing page */
                                         sgx_encl_truncate_backing_page();

                                          /*
                                           * pcmd_page_empty indicates that
                                           * PCMD_AB is empty
                                           */
                                          pcmd_page_in_use() {
                                           /*
                                            * Check SGX_ENCL_PAGE_BEING_RECLAIMED
                                            * of pages sharing PCMD page.
                                            * Will find that ENCLAVE_A's 
                                            * SGX_ENCL_PAGE_BEING_RECLAIMED is
                                            * set and PCMD_AB page will NOT
                                            * be truncated.
                                            */
                                          }
                                         /* sgx_encl_truncate_backing_page(); => not run */

                                         mutex_unlock(&encl->lock);

                                         ...
                                         }
      mutex_lock(&encl->lock);
      encl_page->desc &=
           ~SGX_ENCL_PAGE_BEING_RECLAIMED;
      /*
      * Write encrypted contents of
      * ENCLAVE_A to ENCLAVE_A shmem
      * page and its PCMD data to
      * PCMD_AB.
      */
      sgx_encl_put_backing(...)

      /*
       * Reference to PCMD_AB is
       * dropped.
       */
      mutex_unlock(&encl->lock);
    }



> 
> You might be able to move the ~SGX_ENCL_PAGE_BEING_RECLAIMED until after
> the __sgx_encl_ewb().

This will not change much since all is done with mutex held. At the current
location that bit has served its purpose and the code that follows will
replace it with the VA slot information.

>  But, at that point, the pcmd_page_empty is a bit
> useless because it's stale. 

I cannot see how pcmd_page_empty would be stale - could you please elaborate
on the flow where you see this happening?

> I guess it might act as a performance
> optimization because it allows avoiding the expensive pcmd_page_in_use()
> check.
> 
> Also, one nit:
> 
>> +	/*
>> +	 * Address of enclave page using the first entry within the
>> +	 * PCMD page.
>> +	 */
>> +	pcmd_first_page = PFN_PHYS(page_index & ~0x1FUL) + encl->base;
> 
> That ~0x1FUL is pretty magic.  I assume that's 5 bits because there are
> 32 PCMDs per page.  This could probably be something resembling this
> instead:
> 
> #define PCMDS_PER_PAGE (PAGE_SIZE/sizeof(struct sgx_pcmd))
> #define PCMD_FIRST_MASK GENMASK(PCMDS_PER_PAGE, 0)
> 

Thank you, yes, that needs to improve.

> One other thing.  The role of encl->lock here is very important.
> Without it, two concurrent page faults could do their individual
> memset(), each see !pcmd_page_empty, then decline to truncate the page.

Your argument is not clear to me. Yes, this would be an issue (and
that will not be the only issue) if the enclave mutex is not held
by the page fault handler ... but the enclave mutex _is_ held by the
page fault handler.
 
> Also, given the challenges here, I do think we should check the
> pcmd_page after truncate to ensure it is still all zero's.

Could you please elaborate the challenges? I do not think it would
help the issue at hand at all to add a check since this is done with
the mutex held while the reclaimer has a reference to the page but no
mutex ... as long as the page fault handler has that mutex it can write
and check the PCMD page all it want, the new changes would occur to the
PCMD page when it (the page fault handler) releases the mutex and the
reclaimer attempts to use the page it has a reference to.

Reinette




