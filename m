Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE7BC433EF
	for <linux-sgx@archiver.kernel.org>; Mon,  2 May 2022 17:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386566AbiEBRO5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 2 May 2022 13:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386565AbiEBRO4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 2 May 2022 13:14:56 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1173A62E5
        for <linux-sgx@vger.kernel.org>; Mon,  2 May 2022 10:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651511487; x=1683047487;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mq2c8ykwhls1n21Nfv4GcJcNeip3/2WDSkxEIiKhA1o=;
  b=TVGjCOAJrQcTsQyu/3LmIcP3D1/cXdnx4CLNl94RZjMMWwFPyyJFJBxm
   z6UtrWHooRfiIXIepYFq02MpKFrFd8cCGkVjxsbGv72EyblpkfgC+yBDA
   CW2UVnqqlGCl1nRFd2XTeJTJcFxWfGpD9WSnDD0MNN7SA9IjgbPe0mywx
   PGAlUQslUIjgvv+B+lFWuni2JRs0i7EE99v1aO9zLjgzPiyZO/xsG40RL
   mWuA4YbJmatQmFeSZGB5qOwdlGftHjbdokgHXY1YkoF1qqP1sa/X4S3nQ
   /zVx0NKiL9nX7dqnNyoXvvcudtHTXspiIVS385qZVJ9DTdK3VlZweuk5e
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="267423514"
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="267423514"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 10:11:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="619988455"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 02 May 2022 10:11:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 2 May 2022 10:11:25 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 2 May 2022 10:11:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 2 May 2022 10:11:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 2 May 2022 10:11:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrIATbZ5nWMdU8mK9mDKn9Bckn1Vrho8J+PggOwSmzaJStgqTfpSX8nCAoMzoZPe6NC2XdXKRaoAHjX57btSxnZc26xC1BGnRIEqTMBGS0EesKGd+LvDJe/ZtJaOnHASQLNzqVVNNfphRsM84ilG+J6JF2Gvw6DeBSo7OE5PJoRhnojWJ8SOrv0nO5aGFvu4V1aix8l71S+VfBTVwxDThK3Zi6MtIgftt+tE9yp6vM9Xu/AKR0obqnN43JPTK7w2cyoAjYAcjaZUXC3JTgfRValfp01ivsNj7WeKGRQ1C2B7xWDgu3Lds1C/xcFrKW3LQUCgzPtYeGnBBpdhWorLBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bV1KVa/jV3vp2IoJWGHR0rwC2K8CkCBPZjU1E5rdLwM=;
 b=IX+2G/eCOedUi7qvoJ5Mydrg4MjSWCsaLcHwdRfKBCSekvecPMbEgsLoHEPPSpxAV/F0DXiVPK5rGVSxw8l9VGq9s+8gQKMsfldqkAdLSzD03LIbO6KQERY6+LeEdo05A54qY0nOD+47+Doa29pPcF2qtS3OgRIP2ymLe4DV/P38CMFzzVawYCiLxw11aiIO3eRt/W9FhE098rcOoqO9qv7br2rTVUD4BLYY3rOl6vN+h3LJE4U8vewXXbiANXsIkS/FJc13TsGjbr6+HaStaUlJA5/bg4JutFowm+goceJxtzwQTNGAkYeACzpaBdTlFCycAJsc2JR4FuHfcK1unw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by CY4PR11MB1352.namprd11.prod.outlook.com (2603:10b6:903:2a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 2 May
 2022 17:11:23 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 17:11:23 +0000
Message-ID: <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
Date:   Mon, 2 May 2022 10:11:19 -0700
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
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0362.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::7) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea71a058-558a-4a2b-3c47-08da2c5ec854
X-MS-TrafficTypeDiagnostic: CY4PR11MB1352:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CY4PR11MB1352A8EEEB6E9C7CB91CD7D5F8C19@CY4PR11MB1352.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pGOnBjcCVNa/cvfgwniXh9DjbTAwbdHSosp0ClPtPwOM2b0aRN+40tRIYoSFV88GAUkkrHHD0sdrKG2ZTIo7TEQt8sWKbE/oTwiXXishv85JOaHnnvrVjnQgmwnHZ9Rg51gsRYClh1lIgem8ast1R6/M71ou25LA0tZQhDuprN5BC58LrzTSlx+gKr32CIjL6NCRDoxOz5KLM19U7jcvXsdrL3NOy0JnXU0VzKem9DoA5sdVhY9j9lpPL8up3ajj+YHRQOnZfIbv5DxRDMSsVkX86RVMK1R/2nixFuYY5W4jPr61/gRiq0SQViqkGAr2CjeuxpeAYZfOeUpFeQyvATxLP/xcmYeKlCbflu4TBGcaXVFpRxivtwTzpebPoxs/3CFZyL5NonVO8ZOq0yGlhw+fy7gNw5R25XYNH/7rOFMx7DHkmC5FGiTfZJBGggx6tb2Uct4f+4vMzHc+Kb4QAzz1upFYC/QQKUJlzD9eB8rEDVexQZckHXofrKP9VQd8Q78/lKqEsXDCUfNTrMnXuCnrMZKignvbhlLXpPWPhlEtY0h4gD5xdDo+bruv4us2qSyGcEL5VXN59v59uOFtlQnOBSOqyDDQQHoIHmd3AhFZhcPn0v5dAiTqCRRqmWjl02WNgj9AY5ZqkmgHunpIVpcxqcUPfUX1c4nmMFDdCIG5fubtex3KROVAI4chLZETtDyTmOhtJDJnwvQAQQ/B6d8PXw5zn4fZEDP3a1mCI3p3U8j0oTlpDnGH+5j0ImEw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(31696002)(6486002)(44832011)(8936002)(508600001)(86362001)(2616005)(26005)(6512007)(53546011)(6666004)(2906002)(186003)(6506007)(82960400001)(8676002)(4326008)(38100700002)(66946007)(66556008)(66476007)(316002)(36756003)(31686004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXNWTHk3UTQxKzkzQ1RhdXl2RjlRKzNpbU84TEEza2dSZFRxNHh6K0hnbFlJ?=
 =?utf-8?B?S2Jud0RtTTBIVUprckVoeE1DV2ljeG5yN2hORU5tb1BXVVU3SndQREJXUzVJ?=
 =?utf-8?B?aDRLSUVKSi9SdkVnNUg3cW9NNjZKVk0raldValpuS3lHSVcxUWJtQTJlSE9z?=
 =?utf-8?B?eTFtWFBCSTZEOVFHQlh2Z2NWaFJpeHo3TXk5bW5aZzZLMlQ2TzRvV2hkZW9U?=
 =?utf-8?B?R1JiVjR6cHJIZDJSUGpQdzROMExOak5TSFo5bXBvRTFsMVdnbVJ6SmhGMTZZ?=
 =?utf-8?B?ck5Mc1hqVzdyQUdkTGM3dFJTL2Y2cEVOWWt1YnJ1ellIMEVXZFZpc2RhdmdJ?=
 =?utf-8?B?dFk4aVJmd1NVQ2FTMWgyU0orZU5NNERwK1k5TnYvWWpadktkOVhnclVzNGo2?=
 =?utf-8?B?SERPZUcxSUpQTzdselpQTm56bklsNnRXMjBRTjNUdm9tNVJWdjRubmdhU004?=
 =?utf-8?B?ZmxMVUZBUlVnVFBTRjBkaWZWUDJsUXAwcmFBdFpNeTllVzVDOHdvRC9Galp4?=
 =?utf-8?B?UGg4clVXWCtQTDFmNE5vU0ZYejZRcExiL1dmS0pPczdkdjA3Nm1mZWg3OEpv?=
 =?utf-8?B?WkdFMGJPTm8xcG5DdzQ3ZFYyOUU5TldUUk54V0h4WVVsU05tQ3ZWVXcwL2do?=
 =?utf-8?B?QUsyVTNjL0tLb0N4RnN4Rmg0Y3MwUG1aN1M3SkppTU5vMjhZdWhzdzFEU215?=
 =?utf-8?B?V1VqNEdwZUFkR3BkZ3VYVHhmUmx0N2IzeW5TczY2SjExRG9CUjh0QUVyUlFY?=
 =?utf-8?B?Mlp5endnWXoxUUpsOEpjenpmVUkwVFN0dlNNY3BiSTBFNlF0cm52cEszb2tw?=
 =?utf-8?B?U0xlZWhmcW84dEZnRENpY2toUmFQazQ3bThXZ3ZWRDFkeHJTSGVtV0dDZjlv?=
 =?utf-8?B?SnBlbXpHLzlsQnRranNIOU00cnlnaWE1dUVHL3RJaStza21UbmNFeUk4Yk9Y?=
 =?utf-8?B?QmJOL0l6NUpNTlIvYmp6RVpJYWhVMW83eFBmQjJ0aXFFWmZ2OFcybDRBanRF?=
 =?utf-8?B?dGZDS1VVOXFqbkVadFJ4L3d3TjdCd21DT0huamt1a0F4VEdDMVBKTVVvNStv?=
 =?utf-8?B?MDYzU3FCcXRvUjR6R0swK0YzSnpNcUdmdVFGRjVYc3llYWlNWWJNUUZDeU83?=
 =?utf-8?B?TVVjNHYvKzhWeXFKdllTM25NczJqdytVa0I3K0dLSUt5eWthUHNjUyt6bXdn?=
 =?utf-8?B?YVluNVU5WkFWajBDOC9VVnBFdURXK2l2Y05NYklTcFhoWXk4eUYwWEllbUZk?=
 =?utf-8?B?alAzVXJDaklLOG05MjNjV3dDTFlDNVJadWpzZllBNEJ1anN4RGkycEw4SEpX?=
 =?utf-8?B?dHpqeThiR2hQWlkvRUxJZ0EyVzMvQmxmQ01MR3hnZHZtWkZ3ZnJsd3krYkNw?=
 =?utf-8?B?UmNKa01iQlpPakFCblp3TlcyZDhJOE43TFg5UXArV1hVemZOcDkyN3dTZUpZ?=
 =?utf-8?B?UGhzQktVTG5oVWp4Z21lUjV5dEFrN2NuTkt4MHA1NTl3bTNQRWhOaFlDZ2hP?=
 =?utf-8?B?aW1tcEtOcUxxMGdhUXpIcmc4K0p2S3N2dnVDMjNXUHRHWGVvcmtJSyttdXoz?=
 =?utf-8?B?cHgxNUQvNCtSNUVaVjNNRVQ3NVlESDA5STBqUDZLdittSWRSSzZaS092ejU2?=
 =?utf-8?B?djc2eEd1YytrUFMzUnhTdGNMWk5EY1dEVlRkSFBFbzM4TU5abW9sMWE1U01z?=
 =?utf-8?B?RnpwTDBVdytPYjUyOVlNTk5DcTF2TmZtREx2NTVVUS9peENqZ0p0V05Hdi9C?=
 =?utf-8?B?VXgxYWlxdEYxNDVHS1RrZVFKRnRiODRMUmMvaHl3OG5OaUFZc2ducDdiSWxI?=
 =?utf-8?B?S2NBZGdCTmlqcWQ5WUdXOHNoRXQzSGpBUnIwK242V2QrajMwYjVvbzlDQ1BQ?=
 =?utf-8?B?OWh6ZnJjMlJYV09jR2xCc0c2NTlVTHh2ajk3UFZBaU1vdzlCZEV4ZkF4UFQw?=
 =?utf-8?B?OFJlZWh4WkY1WDB5VWEvanVXamZhRG5aS2M3Mm1Cc0g2Q0h3Vm1adTNXaEU0?=
 =?utf-8?B?U0FOWU83ME43UG5xNW5CRDJQY1JrNUk4cHc4cU0xNGF0SFlqRmRCNDE2d0M4?=
 =?utf-8?B?aUFIM09ac3FEcDlIQTQrajY5STBBUjc1WExxaFQzaGhaZmRGR0tvWTd4WXNH?=
 =?utf-8?B?R3N3T3F1Q3gyVEVLbXp5MWNJczcrRzRYdzc0eW03amM5THp0Q2Q4RDJnZGsz?=
 =?utf-8?B?SXV1ZGhRaW9ubG1ZQzhxRlROWS81cWZlQjBuWHRKcVp3ZzVhL3Y4MG5pTXpN?=
 =?utf-8?B?R0lxMkJBbDB0cXJSZjk5ZVp4NFp0NXcwcDRpZU1ERHZsa2dLR3hkbEJtbkRy?=
 =?utf-8?B?MFdUSE1UbXVYbGdOR1JmbGhnenRvTU9tSWRqRytqNjkycWlBWkoxTE1kM0FL?=
 =?utf-8?Q?1I17xdlvfUDI6i70=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea71a058-558a-4a2b-3c47-08da2c5ec854
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 17:11:22.9763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ODDkOrQMrr5/IPtVFi8hrqwtHdi4QcD6Wbm2YJViVKwp0Xwzn/NNTpwVE+0RiNveVEXXDv/bX7noZRIt5GwRgwkPFBnylMrI1SfbxfQ/WrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1352
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 5/2/2022 7:36 AM, Dave Hansen wrote:
> On 4/29/22 20:22, Reinette Chatre wrote:
>> -	if (pcmd_page_empty) {
>> +	if (pcmd_page_empty && && put_page_testzero(b.pcmd)) {
>>  		ida_free(&encl->pcmd_in_backing, PFN_DOWN(page_pcmd_off));
>>  		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
>>  	}
> 
> Reinette, nice work on tracking this down!
> 
> One comment on the fix though:  Will this put_page_testzero() ever
> actually trigger?  The page cache itself holds a reference, which is
> released in this case via:
> 
> 	shmem_truncate_range() ->
> 	truncate_inode_pages_range() ->
> 	truncate_inode_folio() ->
> 	filemap_remove_folio() ->
> 	filemap_free_folio() ->
> 	folio_put_refs()
> 
> So I think the lowest the page refcount can actually be at the point of
> put_page_testzero() is 1.

oh, I see, thank you for pointing that out. We then need something like
"put_page_testone()".

> 
> I suspect the end result of that patch would actually just be that PCMD
> pages are never freed at runtime, which would also work around the bug
> you discovered.
> 
> No matter what we do here, we need to ensure that there is no race between:
> 
>         pcmd_page_empty = !memchr_inv(pcmd_page, 0, PAGE_SIZE);
> and
> 	sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
> 
> Holding the encl->lock over that section of code would work.  It also
> would not be awful to add a special "truncation lock" which is taken
> before putting data in a pcmd page and is taken over the
> memchr()->truncate window as well.

&encl->lock is already held over that section of the code so there
never is a race between the empty check and the truncate call.

The problem as I see it is that at the time __sgx_encl_eldu() is called
by the page fault handler (with enclave mutex held), the reclaimer already
has a reference to the PCMD page (but of course does _not_ have the enclave
mutex). The reclaimer expects to write to the PCMD page later when it obtains
the enclave mutex again and expects it to be safe since it has a reference
to the PCMD page.

The page fault handler will find the PCMD page empty when it removes
the last entry and thus truncate the page.

When reclaimer runs again it writes to the just-truncated PCMD page and
when it releases its reference the page is removed and the just written
data is lost.

My goal was to prevent the page fault handler from doing a "is the PCMD
page empty" if the reclaimer has a reference to it. Even if the PCMD page
is empty when the page fault handler checks it the page is expected to
get data right when reclaimer can get the mutex back since the reclaimer
already has a reference to the page.

Regarding your other suggestion, to use a "truncation lock". SGX just
gets the page pointer from shmem every time it is needed so there is
no room as I see it to add metadata to a PCMD page. One possibility
that we could do is for the page fault handler to check if any enclave
page sharing the PCMD page is being reclaimed (has the SGX_ENCL_PAGE_BEING_RECLAIMED
flag set). The reclaimer sets SGX_ENCL_PAGE_BEING_RECLAIMED for an enclave
page when it obtains the reference to its PCMD page and clears the flag
when it releases the reference.

Reinette
