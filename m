Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69780C4332F
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Oct 2022 17:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiJCR7u (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiJCR7G (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 3 Oct 2022 13:59:06 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3D71182F
        for <linux-sgx@vger.kernel.org>; Mon,  3 Oct 2022 10:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664819920; x=1696355920;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uqoDn1a6YZRpOHf1wCLRbjSezj/JCK7PKVvJx5N9Db0=;
  b=CRphlAO3EsLQQVlf0GHtWQQkBRdgrc1UhkPw5kU1FcrV7m4YbQ6gsn2G
   FCundZfVsFKwxClcoy7JGhKRYFZDJXHLK3fvzNDoa+b8nxj374CdBEKnF
   fwbOjWpjUe77EqaC1wysLvj29moAghozaX1Yi7QP26cjOe3UaMOtBtn/F
   wEIOw4XJDc8F5NMMTS5MOWWFsNHBgqcEbqcUyb8iZ3LCpWYFhmtGIIggh
   9qu8hIb2FnR6ke9I6KC/1gcFldnS2MfPZVz0tm8M0GsPnndjgxC8RXFlo
   X++CbHVMAsfW1cLlNa2PEHNFQjnP1c15rfJYeIQGpjrQvvmef/ORE9kKw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="389004093"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="389004093"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 10:58:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="601323793"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="601323793"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 03 Oct 2022 10:58:37 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 10:58:36 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 10:58:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 3 Oct 2022 10:58:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 3 Oct 2022 10:58:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vgi0b2zIJEl7KxWiK4gqm5PACYEKg6/h22kqE03rC1iNVARHb3FbFUTCDCChEZ8nzt+rLFVJthwT8CKWlW5mQXrd5u71tyL9ATwbA8mrSe+yIviB84TDfM12i+6o91JTo/DxmDAkRWXFyHMhvbls6urz4JxSjdVkmQLhMtJYkmdMXPbaCBqmhhbF3exXSDYgVdmUh6ZkG5uBEHsMTZg0wnZ5YjTUGI1t/eXfVawY7WqXpJaxmIXAmomnTYjORgYaqsa1gHkVhTTPkPHMqzG5/Ur442hRrOnHJw0hXOXhzflNAWB1cs3ikK8nXAmawHavRK3B7TgrPqWkTmTIPzZylA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PaR3SiGXk+2FpcXepG16/ZxxPtzfoV24Hy3tFlmVDP8=;
 b=Npt2hVMGOAe8hWs0EEYWHTHLLWzoQjDYj/nadFoPiU/j9HlXwPZ3w4c2yiEuemqXmX6BCo8sWoOXOF1ohdKvOjZ20jybFqqW8CWmT4q9A1CTEqDfBfSutX2dLS5JkfUGwF4Wy5afRz/kfhP7pKtlQEHisPHz4CSft+pnXl6X9u4gN9ewb0cd5VF9S/NU+8rzrYR+I3XOwoOuk40lbQQqhchaN/jrad5of9K+FaRUWLCIAYbc667rj/ciWobxOGsBEY8M5rwpbEXSPdSMCorFrBjj4uRuHvRjex/So46YDpzkoCRUTviqS/9gQtTXGhJ84cYhF2KCVFAnspCQ/IVqwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by BL1PR11MB5238.namprd11.prod.outlook.com (2603:10b6:208:313::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Mon, 3 Oct
 2022 17:58:34 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::207e:ab0b:9e29:6a4b]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::207e:ab0b:9e29:6a4b%12]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:58:33 +0000
Message-ID: <5b3bc4ce-bdfa-285e-79e0-77a85616e637@intel.com>
Date:   Mon, 3 Oct 2022 10:58:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.1
Subject: Re: sgx_validate_offset_length bug
Content-Language: en-US
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     Borys <borysp@invisiblethingslab.com>, <jarkko@kernel.org>,
        <dave.hansen@linux.intel.com>, <linux-sgx@vger.kernel.org>
CC:     <mkow@invisiblethingslab.com>
References: <9e1e61cf-39d9-8039-b2e4-f0a3804fe493@invisiblethingslab.com>
 <956f6af2-e0cb-72c0-abf8-e2e00067851c@intel.com>
In-Reply-To: <956f6af2-e0cb-72c0-abf8-e2e00067851c@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0038.namprd07.prod.outlook.com
 (2603:10b6:a03:60::15) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|BL1PR11MB5238:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ec1c589-aeb5-4143-d8c1-08daa568e358
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SSuU9ElkoABGiQDhfqqA3aia0uA+Y/YsvsJ6/mwHGhDaZx32Dbzb3khrvGguBSKxQNudzutVMuQAkXSIjTTtVM9O1VQ97Xnyl88BFs69fk0Aau1/t/lhhh4TT15wf4JD0oOBVJ31J+fEIL2pbpBgQYkyYhxACkhR90YtogXqvDsYAmWU1w3VENuS0LLffXu3zERF2opiujeh5/bZPM8ulNvPYb2elSYXGGBMBabfL/Cf4Rcp+IE6zHavvXDUr5a8rzo44/xnqgcta3OvJ5IWnSnSsqJLDtRQNXveGwcX1MOu7Z6QiR/meaQiNBJ3ef1k1gN0wLBcpv4BOTz5I/Wi45ZPPm8s02rxALaKbQX2xEywMSXHuEHMKy9UFWY3mI+FApwcw/Bms7kpDX0odbIWitKmU2Cut2DFpxthrejbzopn5yv1vk8G0/FoQ8z0RCx42nBBIoRU3rGdn1rDKkfSOZcPoYckl0rbiPkBft+6vDWzzVeMpk85NmYPzRK1lxox+dhYZRPDEu1g4qNORd9bSL7ZxNs86eNc141RRn0rMMPsclLDFrwDCfoihXpVPWU0WzllMYSfCFpQLGatF4E/WDAS8KR59lwYInL81YgEPMT5PTt25hJuEvse5M+jdRJ3J3u0KX9uLbb5v/Z/wd463hnbVHtl0oa2V9DxPV2pT5zV0yayqspjjcNvHz926GSvQhiG7yR327i0xXlJR8DFYiu976sYjNio9Pw/sbMRanxXuFxDkZvnPuiRMXsyLhDLNXyVth5jhZmD020erF/edQUG5s7pQ4fPjFJJy6/9RqM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(39860400002)(346002)(366004)(451199015)(31686004)(2616005)(86362001)(44832011)(2906002)(5660300002)(31696002)(186003)(6512007)(53546011)(8936002)(66946007)(36756003)(66476007)(26005)(41300700001)(8676002)(4326008)(7116003)(316002)(82960400001)(66556008)(6506007)(83380400001)(478600001)(38100700002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekt4Q1orQ0xmTFphdzFWVDRTQTQ0NVNBMHdCbTdsK0twSWRSQVdvd2lndHdw?=
 =?utf-8?B?QWhvcjQvYUJndDFyQXIrRHhoaFUwRU5BTnRxYkc5ZVE1UUxvYzN2bWRDbHZQ?=
 =?utf-8?B?TmNzYjlaemNVSC9UUlp3UlJHVTVObk9pUUxkdGhsRzZpNm92US9sY0tEenNR?=
 =?utf-8?B?alVHeVBnMUtVTU9XZ0xheHFSYlNlWS8zSG1Oc0RZNlpUbmNnaHdUQWEwRjRI?=
 =?utf-8?B?dmpkVnN1VWl6VG9NbUxLMDRHRVgrNm9LcFhXdFZQVXRnaWZaYlhOK3AvNmM5?=
 =?utf-8?B?ZGJFZHlrTTk3Y2NHZTZtaTgrYjlQaVJrbitkVStZVXJJR1NHZUpac0N0MVl5?=
 =?utf-8?B?NGIxbzhGRnlYYzlocjRDcUwvRVdaRlJKVG01Q0RiM3Mxem5ESEpJcnI1WDZC?=
 =?utf-8?B?ODc0SnRTTG9YWEFQVll0ZmRML3ZSbzlDdkFWOHNUejlzTmN1Wnc5eFFteGQy?=
 =?utf-8?B?TTNuaW5XdklTajl4RUdFbGMxTjlGenlFSTdzc3V6Tzk4QkkrMk5GTXFUUTJU?=
 =?utf-8?B?YWVQQWMvUnFMamNrbWhwTEVDeUUwTFdCWDJmSmVmSjRYTkE1cUI1Nzg4Mm5S?=
 =?utf-8?B?aG1qVjFDeTNmeDJLejh5Q2IwRXUwVEZkNkhIcnZjMVoxZ2MwMkJZSWlhWFpI?=
 =?utf-8?B?WFFUdUVVdk9kZ2JqYXZLN1BCUlU0QUtzQTl5clJHek91UURheStQeUJUVXRs?=
 =?utf-8?B?MWdWYTRBOHROVjlyM3RjUXZEWEFIV2VnaGhHNVV2ZlJyZUV3K0ZQZkVmckpW?=
 =?utf-8?B?bkw0bitseWtJK1VHWnFZQTFGa3J0S3d1Y1M1TVdBdVBlYzBpTEY3ZVpUbUpF?=
 =?utf-8?B?eis4RFRjQm1SS3hKekV0aWF6LzhMK2Zkd05mMXF3RjRGeElIN04wU0Fubkts?=
 =?utf-8?B?ZDV2RTdrUlZqTHc0SENGV2RpMS9SaENFeHJncUh0ME9kb1M3QXNxdXAvTFdD?=
 =?utf-8?B?bkUwWncxUENTNWlPelVPSTlwU2QvV0RnQTRjdVFjeVBLenEwTWdFdm5ISnlT?=
 =?utf-8?B?ZG92OEhuem9HREpib1A3VXN3d01yVWhVb2hwdkRnUjBjbjdsRGd6cXRsOFcw?=
 =?utf-8?B?U1VtcW5lMlZOQnBhWllTOEZyUE1iYVB3OVY4SlVMUXFJQUEyeXBGT0Z0YjN4?=
 =?utf-8?B?L01vbmtZS1RHZW9oRmJ6R0hhcTVoNkxrcFhiMDdiM2RJSTREdE04L09wdmk3?=
 =?utf-8?B?U0VjakJlalYzM0E5NUlrbVQvNURUaFYrNmtCSzdpR2psdnZ5VXpFRCt4bzU4?=
 =?utf-8?B?L0gzMGF6ZWhQRjY1K1FGOFhvMXhSVU5DNEtXSWhab0ZaeEdYL2V1TnNZWjVq?=
 =?utf-8?B?MkVXUlVORnc4ZXJOSW5zL05KUW90eTVkYlRUY2tsOSs5b0ZwMVF6R3hjWHFZ?=
 =?utf-8?B?N2NDTUlZbkpIQ0JxcTcxU0dhblpKZUZYRy9MTEJEMWZGNkk4WEFvR25ka3Bt?=
 =?utf-8?B?cUloSCtZaWYwelZoTWVoeVpKa3VhVHhDTThTWG8xKzZyM0RKbitRYk5wRU96?=
 =?utf-8?B?OGpNU0RvcTZLWVVMalpGR2haaUM1bWg3Rk9mTjZpeEtNNzdha3EyMFZlVkxF?=
 =?utf-8?B?RE1pQUE1V285SjNtZytuQ254c3BpU1pmK2pENnJtR3lxYVBpRXdzekxJWFZv?=
 =?utf-8?B?WWp0d0F4Sm9FY3JRSlRpakRrRXlub3hoelI2SmprWnVwRzducW1pakVMNlVQ?=
 =?utf-8?B?eEFsRENRZEVPZkp1eXl1dVd6SHpCSlI1NHZ3REo0K0wwcnFHTGdmd3NqR1A4?=
 =?utf-8?B?aW9zb2p4bmJnTmtubG1sZXNHLzFOSEFWWXQ5M3ZUbGhVV0hSaXZMTUYwY1Jn?=
 =?utf-8?B?aXRCKyszRk9ycmwzeW5EZTJNSGROcGNZblJkUE10Ry8vQkJ0Q0dEMENKT0pm?=
 =?utf-8?B?b2pIWlRBcXljS3VpZmxsU3REQnc2SDZWY3c2cEoybDRIUlMveTRKZHFiV1RV?=
 =?utf-8?B?dTh5eTF2UkcxaHE0c0tWQXVhUWplbk9YQ0c5WjFNejdoRU5Lc1NiMG5tamxu?=
 =?utf-8?B?QTZ6b0FjNHdnMWU5TEtaUEUwejl4UWxCWllXckVNYUNuMXN2RkFBekQ4OWJt?=
 =?utf-8?B?cmtTZFYxdEhCbmI3NUFRQ0ZYVktsUlRPWDlLcDNQYlpqK1djMEdtdVVLUU1E?=
 =?utf-8?B?SmIraEU2TnZYYmFYNzlxOWttREU5QkhwYnVidE03aTRGRjRPNWJpZk9QMWpv?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec1c589-aeb5-4143-d8c1-08daa568e358
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:58:33.7341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MhMeLr3RTLSY0xKw0r1qqfUfy1vmc+7C6UDKClNwPMAIy9msYhjq1o8QGG3PIH6iS0XJo3vhUM7bEqISuw7dfRBGtIVsWxzcLEUfoPiHxYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5238
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Borys,

On 10/3/2022 10:33 AM, Reinette Chatre wrote:
> On 10/3/2022 10:19 AM, Borys wrote:
>> I've stumbled upon "sgx_validate_offset_length" function in
>> "arch/x86/kernel/cpu/sgx/ioctl.c" (all of this is based on 6.0-rc7
>> version), which does not entirely do what it claims. "offset" and
>> "length" parameters are provided by userspace and as such their
>> addition can overflow, which may result in this function approving
>> malicious values. Fortunately this does not result in any exploitable
>> bugs at the moment (or at least I couldn't find any), but this might
>> change if "sgx_validate_offset_length" is used in a new context or
>> current usages are changed, so it might be worth fixing anyway.
>> Simple overflow check `offset + length < offset` should be enough.> 
> 
> Could you please elaborate where you see a possibility for overflow?
> 
> Together the provided values, offset and length, are already ensured to
> not exceed the total size of the enclave in the following check:
> 
> sgx_validate_offset_length() {
> 	...
> 	if (offset + length - PAGE_SIZE >= encl->size)
> 		return -EINVAL;
> 	...
> }

I think I see what you mean now ... if offset and length are
sufficiently large the above check can still pass but loops 
that have the following pattern may have issues:

for (c = 0 ; c < length; c += PAGE_SIZE) {

	... 
	/* do something at <offset> */

}

Are you planning to submit a patch for the check you propose?

Reinette
