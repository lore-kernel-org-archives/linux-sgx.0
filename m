Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7196AC4332F
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Oct 2022 05:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiJKFn4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Oct 2022 01:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJKFnz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 11 Oct 2022 01:43:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A2A8274B
        for <linux-sgx@vger.kernel.org>; Mon, 10 Oct 2022 22:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665467034; x=1697003034;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dqY6THDIwaG3IZEa13xp3ee7hXB8ilw4hHekbEnWs/Q=;
  b=dKqc79hUX/PGuGsL/nUeRQUV3S4aiFJ3uZsZZ5+qpzQjlyhWmsrHZ42d
   y9dHcDLiVAAzpiuLxhCGPCPrznRFy7yR+wCUuQ1CD1MOsjgGBOARVEYuW
   IM3ztdIyhiv3Ab4RQ1A9kP3iAa/3KNXg5mtTzOwJc2eN64N3ve1suTvyt
   4AtPRa978bHnS1hBfOorDVEgV/YE4ol4ajBR+GudBeXGNmwrURY5TWMrY
   eGsMucQHIp7T1Nj+in+Zj2YfBbhWHzj/sf4fofSfQaYYa+AjJjh/7diEs
   VYJomC+dQ/uNdqPRkFykjlFcExwgwKkFMFgv5ZSqjtAlrxe7iw9uqcYyU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="284143573"
X-IronPort-AV: E=Sophos;i="5.95,175,1661842800"; 
   d="scan'208";a="284143573"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 22:43:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="801338458"
X-IronPort-AV: E=Sophos;i="5.95,175,1661842800"; 
   d="scan'208";a="801338458"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 10 Oct 2022 22:43:53 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 22:43:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 10 Oct 2022 22:43:52 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 10 Oct 2022 22:43:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maAq0ff1PE7O0jnxYX9m/4vgoC5y+8unfQOC+uvU8spwfkgfhyKMWSZycB/zSCCuJ+9iklWidwb8qn1bo10IjQ7y+RfEgtST3X3LPUEH3vtqMyTwtV6FOSI+g5jLK3UTTjhpY+I/JC5X2xR+3rCK41wY7eaBDrjb4jT1rBZ37TS48WFS1kXiexTepTj8rDPaQSaYO0HtKK0yjkcy6XQe7ob1z4aP1DCxcpceMPo1D4EjG2YaZ7pzMwHnrE0wqzI1WaSuEtkHDqKK7HllPoctp6U6OrcABjDKiPaOJ6v0QcY/gQ9Xu8ydJreie5pd7ePikqPb6UyXQXkXz4M5Xciq3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+gnMahI6v7OJCILFyVnrlaOEGyqD3I+BkkTCq7Ys0I=;
 b=Hks8ECrXL3QaUrG4w55nCMK/uuMacCV46dOoonAx+1/zUfMtcSsXHAn/LDDsiMZ/jowrRN9+3dGzDQJ1To0lT2X/YSbhXdlYyUxfw6Zjh0ZHjtkDdHiki4HYgDBpXhh2qokPraMV1T6PebVeWyifkaHstNHWgoc69669vppFlljLx110pqq1zpSYjOv0ukYuA3t3NDwAYVzT/j00MXgxXILV1NcSUTzlDSA7Gi+t10sEEMZl/zLPNsF3QzABdZi4RZ9HpM6j6MAJha1fnDORVX5ReCdnVDV5+XaTKYv3aodWtXGJingwguT9UiaRxzxzOQI6hQQj+DDBCsoaqJlWIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by DM6PR11MB4626.namprd11.prod.outlook.com (2603:10b6:5:2a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.19; Tue, 11 Oct
 2022 05:43:48 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e%5]) with mapi id 15.20.5709.019; Tue, 11 Oct 2022
 05:43:48 +0000
Message-ID: <540df1d4-d784-b33e-e1e3-573aa5f804c6@intel.com>
Date:   Tue, 11 Oct 2022 13:49:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v9 2/3] x86/sgx: Introduce union with vepc_vaddr field for
 virtualization case
To:     Dave Hansen <dave.hansen@intel.com>, <linux-sgx@vger.kernel.org>,
        <tony.luck@intel.com>, <jarkko@kernel.org>,
        <dave.hansen@linux.intel.com>, <kai.huang@intel.com>
CC:     <seanjc@google.com>, <fan.du@intel.com>, <cathy.zhang@intel.com>,
        <tglx@linutronix.de>, <bp@suse.de>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-3-zhiquan1.li@intel.com>
 <f6180914-2b63-29dd-8dc3-de48c4197769@intel.com>
Content-Language: en-US
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <f6180914-2b63-29dd-8dc3-de48c4197769@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:54::21) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|DM6PR11MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: c2397b0c-0eef-49aa-5b5e-08daab4b91d1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rV1++SKtg47vB9LqyGtJ9mDNsgkKl6Oddxd2nj5+gCrzv2mmInD51ERDbrbrOLqGjA8keqOvGRPJvYpCLDOalfXSY41ffAMYsqi4dm60LCLPKDxyoIkITAp+ak2n4x1ySy6wmT8ih5j7Pit0wO9I+nX337nkkpz7lgqdKIQcSXRgzOWCz91EV5P/hLbvG0EyWRd7fvbwPi6uYsJvCFHQ6oHV30kK/M4iPhRXzk6PmcG9u6aFFhdRNtWI48U8RYjgEyhflbEbP3ORf0+t4vqniMAx3Ercv9cW8EA7mcM2fw0mbr/0bxci61eklG5q6QXX9koOzmJD2vzddeSX1Sd2U4pd/Dgi9CHUpLadi+j5u/X8cGfHb4RLqaRR3F+AKm5Eq5tqCeh87Hg99wzy2jxY9v8a9I70JsBCAy86SwDVbWJZQSnuIb1KmezPIVQW1MyiNUDW9JrnvUmdSkmJPfi3Ls7pbpY0//kaoC0xokHLbmClYMwrfg5C6Ii1EMP+nXpZsMJEu18B1fKEYrAH7UIF7PZVskko+tcXan3QpifQQD7uum1+E1YmAJXIFsfDHNFdblu3d3BSp1CxAtRJurH3myTWri3CJFtMigDgJsxL/I17a45R4Sn7GJ+xrQc8SQvU/rA7df2/VAHxBXtJU3n5Rok7k1Fo+ScQGFGBueshWty7MlulsW0s07lcuQ9Wsqpdu9PTOVjtq/VSIGbi0eiJDjhSsjnnCbGZvHy3hpLhxU+M88VJXCizGJZ8IZfygCwlDiChT5Hd28s7r0PPAtBgUxpxf2okb7SI3W7LjAiaiIpo4OnDE+4ZXfzduL4gqqep0y0oQShRbUPfnMYLnQVRGLZhwgbhZ9T/LhADwsAy5t8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199015)(31686004)(6486002)(966005)(478600001)(6636002)(316002)(66476007)(66946007)(8676002)(4326008)(66556008)(6666004)(53546011)(41300700001)(5660300002)(26005)(8936002)(36756003)(6512007)(6506007)(2906002)(2616005)(186003)(83380400001)(86362001)(82960400001)(31696002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnpZWFFIQXlYdm8yb1BidzM5eGVHZVY3U2pldkFpRHg0akthSVBiNHZNR21S?=
 =?utf-8?B?dUpMRXJvOTZxN0J2blVTNGMwOFFMN3JBQWNCZ2ZEa25KK01HNHRwcUxTK3ZO?=
 =?utf-8?B?WmFRZ01sUGdSRkFPQ3B6UHRXRERZMmpLcTZxcjB6Tmd3VXNrVGlDY0tWNzFs?=
 =?utf-8?B?Z1BTWkY4THlEbzZwaXM2aU9IK0xybnIwRnkvd0czbDMyYW5BTVhQYytucEVv?=
 =?utf-8?B?VG1oc3hpcG5HVTE2RG5DY3RyRDJrUW96VGNDcG4rQkxuOXRLQmovR0tqZXZM?=
 =?utf-8?B?VDU5RGxZOU1BbU0xdm1IWmpIU2dwOVBkcTdiRVRoWjRkTk1rY2ExaEY5dlBv?=
 =?utf-8?B?WGJ0TW13b1ZINjhmcjRiRk5yUlVtY1JHQUVKdTU4SG0vMDZRQ3A3UGdudXgw?=
 =?utf-8?B?Tk9hbllVa1RqYVp6dHpDSFNKK3RkVzl3UU1wK09pRURUNDNYVjJrWTgyMkl1?=
 =?utf-8?B?SlpWTVRDVVc2Nk84UDZGdTYzOUk2ZTRyL1dKTE8yVmNnWFMvR2xqQWZFdTZ0?=
 =?utf-8?B?VmtwbG5Yb3U1bG5xT3hKYXRkS29DVFIrbERjaWFwZTZGcCtjUkdGMEc3cmNV?=
 =?utf-8?B?WlV1MndLb0tZMGtnUlZDbXpuUFZ6Z1VHMk9qN2E5emxWSkJJczBvN3FXRG03?=
 =?utf-8?B?QUlvbEExWXAyNEJpWjFVQTF5a2tCS3ZGd3l3WUMwUlBSQlhrMUJqYVdEV2VQ?=
 =?utf-8?B?MXk3d1BBT1RMT292SGVTQWhvbHd3c1drcTVGczY2dUt1R2hOdlBGSSt1RTl5?=
 =?utf-8?B?M2trR0VHZHM0K3pIcExsUE9sQmhGNk55dGNRcFd3djFyUFZoQloyNlZWNDNj?=
 =?utf-8?B?bldtY1Z3cmQ5b1hoZjMzOU9jd1B3UUVxelNrcVJKS2lXelhBUWphOW80ek5M?=
 =?utf-8?B?d29yR3VVYjVSNTVpQkk2MUlzRUdWaVNuMjlad1FHS3diNGQ5OCtTZnhSVHUr?=
 =?utf-8?B?WCt5bkNiQ0xtZVNSalljODJJV2t3a2tQKzZaTzJLZ1JxNjUyZFRqUjdCa0tK?=
 =?utf-8?B?NlIwTHk0blJWMDJsaVlMWjd4djBiMytIQmg1UlRrUTU0TTdSNlg1T284U1Ux?=
 =?utf-8?B?Yi9CZTR0Z1NSQzhuUFM0cFdIR2VFMUZBRXhsNG1qU2hRejllVi95aFBnb3B1?=
 =?utf-8?B?ck5SV090amNBemxFZi9PMDIyK3VFWVNFa1B5aDlMUnU4WFFlb29Mc0pXRm9k?=
 =?utf-8?B?ZWh6RUJWaVFsL05yOHlUZmpkTkFWRDlVZ3Q4QzlEMDlBTytPL3FoOTI2S0tW?=
 =?utf-8?B?NVFWQUV0SzJoVEU3azlQRllLL3RuZTNaUWh4Vjl1bDNyWDZTRlBkWTB1MDFr?=
 =?utf-8?B?Si9vMUk3ZnNWOWtXSGJUNWc5Z2x1K1ROTVM3NFZreFhZWFZkWDFCdkxmaUkz?=
 =?utf-8?B?S21OSm56V2k2UTh5d1BqUG5sWXRFTlA5TllObWRSaWx6M2U3U0RobEl3RTJB?=
 =?utf-8?B?QjdhNmtxUGYwMHN1OHRyZzNoVlpncUdQU0xmbithRm90ZXZIaWovcEVxYlVU?=
 =?utf-8?B?U3hFNEt3SStPUDVOdnBobXQybWZTeXNodGR1SFZGVENzSVVPNXNXNFI2Yk1r?=
 =?utf-8?B?NjlEZU1YQUEwd1UyVVhqYXJqeDV4anJnZmFmS0lLdUhhSFc0ZU8xRHNmQjJR?=
 =?utf-8?B?SVdDNTlXZEhFaTJ6OWlITndNc0xTTzMrRWx4NndJdzRTYWV1NU9sZ1FwNWgr?=
 =?utf-8?B?VzFrNi9VSGpXRkU4QXg4aXlkSmlTZXBUTkYyMGV2UTVLcUU3dVBhYWNyN2hl?=
 =?utf-8?B?T0JLb0xjTnJnVkE1Wi9PbXIvKzJaK0llUENmNUprZkVXR1RlR2lvenRvazZC?=
 =?utf-8?B?R1d6cmx1WmlwcEdzRHBjWGxkMFhKL1c5TmtETlZsY254SmRsdm9pQXdXUUpR?=
 =?utf-8?B?eklBd0NuYkMyWEFwRDFOT20wdDFKTEVCelJHQ0V4UGkwZUhqL0dlRmd4dys0?=
 =?utf-8?B?Mm5qck41OCtWMUNBbHo0WTNJSnhVbHdGcEQ5UmQvL1FucGNzMlZYejhLaGNr?=
 =?utf-8?B?eUlrVGNiQmh4cTJmNVljbm50NWdvZVgyVWh3bXFKY0laSktwZTlsV0YwSmFq?=
 =?utf-8?B?OE5OQ0tHc0VXbzQ0c1J3M2Y0czZNM2t5WEVSa3J0Nkg1MVhxWVRmNXhIVzRv?=
 =?utf-8?Q?gfZ/M5RHJO2NAassOhaKaS1ZY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2397b0c-0eef-49aa-5b5e-08daab4b91d1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 05:43:48.6941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KBGdTi6mG1PRNRjRIuXzPUeaANl9B9UnxVdSndN41TGZa83GLe5kxyvY93KeCiyBM0aYwPW0RmcePKwY4jwLyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4626
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 2022/10/11 07:10, Dave Hansen wrote:
> On 9/19/22 23:39, Zhiquan Li wrote:
>> --- a/arch/x86/kernel/cpu/sgx/virt.c
>> +++ b/arch/x86/kernel/cpu/sgx/virt.c
>> @@ -46,10 +46,12 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
>>  	if (epc_page)
>>  		return 0;
>>  
>> -	epc_page = sgx_alloc_epc_page(vepc, false);
>> +	epc_page = sgx_alloc_epc_page((void *)addr, false);
>>  	if (IS_ERR(epc_page))
>>  		return PTR_ERR(epc_page);
> 
> One thing not clear from the changelog: This actually changes the value
> getting passed into sgx_alloc_epc_page() and set in the page->owner field.
> 
> What effect does this have?  If I apply these and run the tree at this
> commit, what happens?  What behavior changes?
> 
> Was this 'vepc' value simply not used before?

Yes, it was not used before. Kai had confirmed this point:
https://lore.kernel.org/all/fa93057f417b1f630d8199381589c415a0ec710b.camel@intel.com/

The initial idea is to add a new struct sgx_vepc_page to hold 'vaddr'
and the reversed relationship from EPC page to struct sgx_vepc:

  struct sgx_vepc_page {
  	unsigned long vaddr;
  	struct sgx_vepc *vepc;
  };

But which means there will be additional 16 bytes memory consumption on
host for each EPC page assigned into guest.

Jarkko suggested us repurpose the 'owner' field:
https://lore.kernel.org/linux-sgx/Yoa90l89OTQX0NYk@iki.fi/

1. It can save memory.
2. We don't have any scenario need the reversed relationship from EPC
page to struct sgx_vepc, keeping the relationship from VEPC to EPC pages
is enough.

May I add below description to explain behavior changes in changelog?

The behavior is changed when allocating an EPC page to a virtual EPC,
the virtual address of the virtual EPC will be passed as the first
argument of sgx_alloc_epc_page() which be assigned to 'encl_owner' field
of struct sgx_epc_page.  After that, the reversed relationship from an
EPC page to virtual EPC doesn't exist, in practice, such relationship is
useless.

Thanks & Best Regards,
Zhiquan
