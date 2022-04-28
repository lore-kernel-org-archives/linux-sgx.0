Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620B5C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 22:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350254AbiD1Wrc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 18:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349982AbiD1Wra (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 18:47:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1686DC1C85
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 15:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651185855; x=1682721855;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GZG+jLpmOBblvr2ionmjvO4kTvHcn1idSo618E4i/Ws=;
  b=ngYQJQDRHFVB+4uFgKpWhW+Ko2GesHGqyT2Yd8SfQUY5ABwHfaamjwst
   87rc2qCU0/QcsJbpbFWufLMu9y1D5cvvKzMDAQqi5BZutu1HZoIdGTgzz
   pDEUm+HXNzWWISE9XCq9vh0PJ/7gD5+nkYA1fmPIkgh0A9EgLvwooogi0
   mQsyxalohvX9/9EAwINDi0CWD/yL3aapdFDIy1cf1xoKROBsKXFCQMizN
   Vy0+bFRqswdbUTfFezGddpLgHzSibXRB5ujoHj2SUiXbWMMjdIcOjJ7ho
   5GOJXdSkF1D1PL4ni2Wzdh7Idtt4J//IAb/XaDCDGnWPQwm06GSzH1i7k
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265975114"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="265975114"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:44:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="559932099"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 28 Apr 2022 15:44:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 15:44:14 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 15:44:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 28 Apr 2022 15:44:13 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 28 Apr 2022 15:44:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kW2bARkxOcYGE4XfUYhjrBakrK9KAiHmWxLFjiVrMTywKPJ5ZVu/zas1vYMp+NiiuWrmFkEF0tw1yy5Y1zSWrPNqI1rX/zAOWPCwSQWqU1oxjdl2yd/KzLPkiz6G28MeBTi0BKH1DlB3vN4BdDUBw421dC7FM+7weFPmJleCBMVOmsbgIrguJu/cCgbo1dp+yBSCVX5PkYJuLE1rJTTz2slpgY6SriBQnFazBXI9e65pzRSOwmFU2HeWymwWgfNSaqO/dmZDRGNEKyHieBiWvSYFDM67IMA8mtCLfdIBCPicTtBJwCLaAbGv2GaMrY5nrtmPEVBYY8Vgfy+/BLJN9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9f/siIq2jO2Fes08ZwQcH8FdWgkT+VH4oQ6lYKglmHo=;
 b=J4Z9P9qNLiyT8DCZlbQbJWp/XKDZ9Irqpp9R0RliuJkt+KLjBiCE6ERjVB/t7nyJBghdh0o6oXREezIVcMARlWTiQtZiYJdlOcgo6F51mjZeEocPIQN2F7TOnHCKXEoQk1Kg/zsmkeehtVfTcc9p7N1ZbjArImOFsQDSkWXUzxHPxJw+LlOAG6XMBQYWus7s0KaNGFhEeKr3dnEIlOlviOQYDhAd6es+J8vlq6zk7+dClt5YcgiA4vLbR67Dx3Z7a89abzmhVoycx2AG6f2oilgDpsxgZyHuLW6ynQecpGKCUjdD383hLCzOragSkmKR00PjMqyQUhPb6qd6dwRyxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by MN2PR11MB4190.namprd11.prod.outlook.com (2603:10b6:208:13e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 22:44:11 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 22:44:11 +0000
Message-ID: <8157fa40-8d02-8819-e1b6-fd2d8863fb56@intel.com>
Date:   Thu, 28 Apr 2022 15:44:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH 3/4] x86/sgx: Obtain backing storage page with enclave
 mutex held
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <24fd9203331d11918b785c6a67f85d799d100be8.1651171455.git.reinette.chatre@intel.com>
 <7b68a719-a949-d920-337f-0be72316eb82@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <7b68a719-a949-d920-337f-0be72316eb82@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0003.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::16) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f30fe6f3-b6c6-48a6-5065-08da29689d19
X-MS-TrafficTypeDiagnostic: MN2PR11MB4190:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MN2PR11MB4190E0119B6C0A7ACF4F3F4EF8FD9@MN2PR11MB4190.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HCOoxCIqFQtalgLTd0T7lsDKXLDA7wj+mb4z9PlGl1epBtizk+4qZTqT5yeN1nkFvIE87C0DPI0vPQuMu1zL/R9b6Qd6s+Nfby1ZgLGp7JFUMt9gQHf4sHk7Bso4j/3ZPPq7eV9Zr7OdzTIj6XYqHHliZLZ0yKVLhmSyhvMAjPIvE91BmG7vme08dozraRKbI74sjuigkh1x/LLBpiP8xZLdT4Dfv9eZ2Leb6gqNOivksUMQIr/MMHPuKbJJ4TdN3E5YGeRJa0ucBD6N0+CFoVgUM4BWErYCvIk4LN99sZX5CjycdohHPHmI8vcMZOWjwgES4BNNUwIt3wrTkGOz+j5e1ihUALjJxwjUY7IvG00eW/GQydy9czAmzXA3xSF6P12eigoZYjvSvgKY0g2UfbahX8lg2hSvTZkDRxqifcvpoto5dhNqjcVLQTMvAiXiNAFKzibNjf5Ew2c6SEO7L+7hAHVS0i092zS2Lmpo3NgMcjE5cr4b5RlAceprWnIfz6AxfaZqBIahtbe9svFfeaQWUFTuYiposy9wDkNDP5zr9lOjofVzyHhcRTWSGPya9swfFZ6I/Je0ANln5ljvLFSPbrzDPmzcDnDi1L46tBXklJQ3LefnsXhurPM4emJbRWdvxm3icMQVgLRfyLnZcXTdjTJnqZSBeLNjWsQjElYuaEV4OXTD+Q2pgZR3I1D5RIU0koFtUt5L6u2Pi+hGs45xut8mLf9Mo70e23KHjOQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(508600001)(82960400001)(31696002)(66476007)(4326008)(66556008)(8676002)(86362001)(66946007)(316002)(2906002)(38100700002)(53546011)(6512007)(31686004)(26005)(6506007)(6666004)(5660300002)(2616005)(44832011)(186003)(83380400001)(8936002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlZuL1lieTFVVlNUSndnbG5wY014bzdFRmFuOVpTbUF5aUQ0VTVhTXUzNytt?=
 =?utf-8?B?NWFoTlpsaDJKdEh5Zmw1Zm1LQ29YYkJpb29sNVNoRTBQRzBCYzFtcSs0TDZF?=
 =?utf-8?B?RElUTlNQWVZ4MDh5aHltMUl5S2F6T29pd1o0Y21kZzBncnFkWWhabG5uS0pl?=
 =?utf-8?B?dHFjR1dvUENreU9EZVhndEhYQXlCTFI3K0RZMnMraUNzYjcwNTMxcm91MFps?=
 =?utf-8?B?engrbTkzUnFyM01oYjhNMDFvUTY3NEVQcW1oRDNFMHFMWkNQcFd1T3N5SUJa?=
 =?utf-8?B?RnhadFVtTjZ1UVhRSnRDSCttZE90WHczR2U5Rjk0MWxRNnA3ZEh2a2FCV1Fw?=
 =?utf-8?B?bytrRzhRZENWNHhhNGhzNkxORlE0WXlNaDFBSlh5ekV6MWluTklTZmc0VExt?=
 =?utf-8?B?QWZOdWozVXVsZXZPaDZWNTlJSFhHVk1lSkZyVDd6NUFZVVFpcW50aXhSYVNZ?=
 =?utf-8?B?ZmFCUjZyUlRHM1lzS2l1allGTS81RmU1dUljRStOMCtkZDJDNGxLUnk1WGUy?=
 =?utf-8?B?VnQ1Y25WMEl1MytONTg1VGdqbUxVOURleHNCbmZrUE9zWVRSLzVuQ2NTeDRq?=
 =?utf-8?B?b3hqS0xpWlhkOFhvRXlyWEptUU1JbXAwRzkxOHFJeG5NdDRFTllqTlVibGNx?=
 =?utf-8?B?b05kN0FkbzBUVHB1SnY3eW5raHYyVmNjK0xjcHBSdmVxSEtoWlFxVEl2T1RP?=
 =?utf-8?B?WTVnOGRPaGxLaytmVFpldXRlV3c0b1BBTlpOMkNSRW95SHkzSmRZcXcxK1dj?=
 =?utf-8?B?Siswb3ZhK1ljeFdGZmxDWlVUZUNLTXF5d1RnckV0Ym5PRVJ2Z1dJeENRSzRr?=
 =?utf-8?B?c2hjNHorQWhLaVluK3JmVXVDYkJBRGVUbDJlWmxubE1OeUF4eHluV1Ayd3lk?=
 =?utf-8?B?ekxjRlYxL1ZBdXlsZmFJQ0hJd0dTek55MVlGRCtyWVk2bktrUnlIZ3FPNjlz?=
 =?utf-8?B?MEsxeW5icE9SSkFTT2U0b1RreXhpTklLaXQrV3BkWm5ZdzBGQ0R1Q05sRGpX?=
 =?utf-8?B?dFB3M3ZuY2ZXVndRdHhzKzN3Z1hZcVBkcEtvM1BXcjF0N2pYbEdaUUVRK0k4?=
 =?utf-8?B?b3hIcHZNQmY5NTlWRitLSVRUVmhVMm9Ka29DTlBxNTdObkRIRm5FQkFuUXhr?=
 =?utf-8?B?d0hDNjNLc3dwbGo5OEErdE41WHRiOHBVTDdwelhaeXRmSjFKQ2NHVmNZWnM3?=
 =?utf-8?B?VURDaDZZWTBrQXEwU3FUUm1CWW9BZXUwTlV5dU5VeVJQZEZWOWRiVnVQRTFJ?=
 =?utf-8?B?MkR6ZUhzZTFKUHBYMmNDZ3lvNkFIM1dERnlVN3l5THJNK2pUVkFMc0tzSmRt?=
 =?utf-8?B?YSt2eW1VMG5Vd0lpb2N1VVB2UzhsS0xGYnhuZmw3d201ZnBvUUFaRFROWFBz?=
 =?utf-8?B?T0pPcVMraktYcy9zWEFsUThEM1VRVjFyd2lteTRrSWYwK0pxKy96K2MzREtQ?=
 =?utf-8?B?dSticGxZSG5qcWdOR2trTFJrN3lZblVmcXMwakVySCtCKy8zb0J5amMwL2lT?=
 =?utf-8?B?U0FiMDdESFplZ1puanIxNzdiZnVUaXk3K2hZTXVyN1MzMTRVZ3NtOWhVZmlW?=
 =?utf-8?B?YjFxcS9IbUdqbng4am0vY3hTTUJxeFpzVTZOVlViSi91aFlneGR0Ny92QWtF?=
 =?utf-8?B?S29zejBPRUkyOHVjS08vWmo2dWU3aDZOMU9SbzZ6eHVmbVdmVnlFaFhLd29u?=
 =?utf-8?B?cVZubEMvbFRXOU1kRFhXZDBFYTFVUnRsQlliZHpERzJZMzNaeXF5d24wSEZy?=
 =?utf-8?B?a3pyRVhQRDM1ajdScVZxS1h1L2VnZkszNy8rN2YzdjJJQm9JTHBKblNDNHZs?=
 =?utf-8?B?c1czMGVqR2thYS9JZytqODYzWU9FOXQrWFBhMXFRaldMV1FTMUFFQ1lUcVh4?=
 =?utf-8?B?a2g5cmpUVEI0T2xiQ2dPd2NXd2h4cmp0Smc2OW80UGVDRy9KckVucC94Qktl?=
 =?utf-8?B?bzBtYnR5dFFMSlFPVUo2bkx5QjdZRng2Ulk5TmxDOEFBeThpd2xCb1lib0xP?=
 =?utf-8?B?cVVTeW1oYVZoeWNEWjl4SEM2UmJPREJDcHN3VUhFWTZnSmFtM0xWblM2WGZ0?=
 =?utf-8?B?UjBmV1htaysvbjhvLzhrdlllM2ZIam5RUUJBQndnQmFHZmxWTnZqNmdLTUhE?=
 =?utf-8?B?ZHVDUGV3QjlyWW0vcDVLMGo4VWg1aFUyVnozSEw0Tjh5SVhHc2lFMWpwS1kz?=
 =?utf-8?B?Z3d1d3l0NlpVSVZIUVZmcng3RzdyUzVoK1VXOWRDUjJmZEdybm5Jdzl4a2Ra?=
 =?utf-8?B?S2JRTEVvVnNpM3ViSnhkNUdMVUo0R1FUUjE3WCthWmhoYUFiOWRaSzVKS2Zx?=
 =?utf-8?B?cWVMTG9SY2N0bk1FWE92SnJ2ZVIwT3EzdEZ3ZGtncWllSXdwMXNJN1NLRkF6?=
 =?utf-8?Q?vxA816BPsxqRcJDQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f30fe6f3-b6c6-48a6-5065-08da29689d19
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 22:44:11.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACsFM9THrV84U9oA8hgXvgf5oYJ34ypAE8K3YRmrQShFCG3gZbyHX3jafIfxzPkG7w5XWqELVa9I3bA/VqdfXlyANXAIGMRch4kfMZTSMHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4190
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 4/28/2022 2:58 PM, Dave Hansen wrote:
> On 4/28/22 13:11, Reinette Chatre wrote:
>> @@ -252,6 +252,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>>  	sgx_encl_ewb(epc_page, backing);
>>  	encl_page->epc_page = NULL;
>>  	encl->secs_child_cnt--;
>> +	sgx_encl_put_backing(backing, true);
> 
> Could you also talk a bit about why this needed to move?  It's a bit
> harder to make sense of the refcounting when the get and put are done in
> different functions.

This needed to move to address the following scenario described in the
changelog:

sgx_reclaim_pages() {                    sgx_vma_fault() {
...                                      ...
/* write data to backing store */
sgx_reclaimer_write();
                                         mutex_lock(&encl->lock);
                                         __sgx_encl_eldu() {
                                         ...
                                         /* page not dirty -
                                          * contents may not be
                                          * up to date
                                         */
                                         sgx_encl_get_backing();
                                         ...
                                         }
                                         ...
/* set page dirty */
sgx_encl_put_backing();
...
                                         mutex_unlock(&encl->lock);
}                                        }

Before this change the backing store page was modified within
sgx_reclaimer_write() that essentially does:

sgx_reclaimer_write() {
    mutex_lock(&encl->lock);
    /* write encrypted data to backing store */
    mutex_unlock(&encl->lock);
}

The reclaimer followed the sgx_reclaimer_write() call with a
call to sgx_encl_put_backing() where the pages have their
dirty bits set. sgx_encl_put_backing() was thus done without
the enclave mutex held. If that page is faulted in at that
time the page fault handler may thus attempt to load
the page from the backing store between its contents being
changed and it being marked as dirty.

After the change the page fault handler would not be able to
load the page from the backing store before it is marked as
dirty.

I can improve the flow in the changelog to be clear on the
reclaimer's mutex usage. Perhaps something like:

sgx_reclaim_pages() {                    sgx_vma_fault() {
...                                      ...

  sgx_reclaimer_write() {
     mutex_lock(&encl->lock);
     /* write to backing store */
     mutex_unlock(&encl->lock);
  }
                                         mutex_lock(&encl->lock);
                                         __sgx_encl_eldu() {
                                         ...
                                         /* page not dirty -
                                          * contents may not be
                                          * up to date
                                         */
                                         sgx_encl_get_backing();
                                         ...
                                         }
                                         ...
/* set page dirty */
sgx_encl_put_backing();
...
                                         mutex_unlock(&encl->lock);
}                                        }



Reinette
