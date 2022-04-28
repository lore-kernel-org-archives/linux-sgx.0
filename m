Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FD4C433FE
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 22:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiD1WYK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 18:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352867AbiD1WX6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 18:23:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6326A04E
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 15:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651184441; x=1682720441;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cb70Hj1LjcArFrw5JM9R4g0YRbybCU5j+i8zQvd8M+w=;
  b=bfXwx5ZDOIG+YEYtEUfMgB5lFfmMYSS5MVrWgsUv/RteFXDq7e4/vu0w
   vfTzUvV4fN4PEuV/kQTvyzvufjBq+lkk8sqj82kjUcYIDu+96Yp6xCWK+
   XNLUrUBRNVzD4thYHCbKgNqzxjF5YOBQAZ4b7KpYHwC/KEmUriKb+aPd8
   gAbhjFja9maToFQMUvb94IqbIEbJb739BdpQSalADZxyBILB0TG6Le7qW
   AZhXRjpkizup7jUjhpER8W7ulzBmid2PAYfTYRsIUi0wzWsUA2hc6/Fg+
   uM7fK89iU2L3Q6tjOD4xXsFpb3SPbQ94emDinD5zzPzGtyZO0tPpZRZoO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266600071"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="266600071"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:20:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581676209"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 15:20:40 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 15:20:40 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 15:20:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 28 Apr 2022 15:20:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 28 Apr 2022 15:20:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdpzHFn/dLu7Z2sApU8o0Tcz+ZEYfkQI5beC4q4EiNKxOitsjkWDXX32ZetrHT7h9G2oR1BEVE+xmOWjggC+LJCpplAOjRgpkGdf4X2/cpUo8pqTs/5xuURgdPrsrJtKWjZaqf6UL0bOO2HzSLDzZ8YxYn4g4O37leKe75QY/kUL+ZYMsphkfEsyEZknATSbbTC0nZKTH5Ow2uzCHlGApAqy5gOXPP5jGzkKe+SLZKHDwiSLwuYh+eav0/cVmVoXorSbQ2KMtmIaD+C/kIxc8I3DXueATCyfOLKBFt85ooSyPMa5vl46oT6/cPDf8Y824uoVRdfEsnucZWe9It6lNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Ct9L8KY/i6VRM6F2fwNAX2rRivjsl1CPDhfT0UuD9M=;
 b=D9dcXcbCd9sYrcLRGvgZ6bQVyI+w5VJ5dopL8jXbqrJYCv5T39wGSXtg9sEfFNIMbIkhr4jvFWxG0KtJgnVBImvFWetp0Y+QcYqO0Hz+Wzy/dQLHcrk7iCa3NEbEQ9VHKVLm0eMOvZ6ffwpXhTJZEbH7sgGCWgy2XaMAsEom8dwg+rwzeGzcCyIEFr7PDBkRvrpqPlXCFVzOZ3lwox95y34ZFHXiAwYXJSBKvSP+1jHEmjRp8qnfm3ZfNtu+TM5ZVqEudb7mkTbKbX2LbsSRi/V2yhQG3iRjXjQg+7YBRIzJL1A4NLKp1sZ2G94gHm+hC9IGenDB8KE0xv7G5Q0kjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN6PR11MB1556.namprd11.prod.outlook.com (2603:10b6:405:d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 22:20:38 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::5459:7151:e684:6525%2]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 22:20:38 +0000
Message-ID: <4d08cb1a-7304-e7b3-fcab-74c96edfb47b@intel.com>
Date:   Thu, 28 Apr 2022 15:20:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <haitao.huang@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <883a217d-2459-6da8-3199-7a99c973cbf0@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <883a217d-2459-6da8-3199-7a99c973cbf0@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0214.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::9) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcd66fc7-dc68-487d-0c8e-08da2965523d
X-MS-TrafficTypeDiagnostic: BN6PR11MB1556:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB15565EABA724617AF40652FEF8FD9@BN6PR11MB1556.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FRi05jjxYtRN2wkivgjBpuzizzZmeiLhVyEFauN+FaYFYCpHHfOZT55Rm+M1eX0+gFvIwubSlnh4C68e/3O2nMADD6c+6Eh2A6spk+t7u82AJ2EsMe1YYq4HCWBYX+7MmW/3w3MVIH4z357xvBU4aIghbCZeCpPgOtUCop6qo3TM9P21YTA5RAP2DEUOhTlqiGTy5h76urWkFV3heLIJDJlOv6ZMUeIRyOBrN1bp7hk5IFEL8R2thJ7DEf2Y059jUmxbqX7851ij74j+mu9ZXJ+TLlIy9fSRDaBasKMh8r54pEmEB0j/DqXAdWfAsa1Ak45Mjn8fdcBFaGz6fs2WPvRS/qNLBEX9C7nTwKkgE9SQrfqqN/dWpoUwgYy1HtLlC0rXmKqAtvEmQWfFI85Gm9E3hXbf6nvB2EgMNLHdxogYAQaFpKmYv6mlYZ+1eLYA4I/kCTcgN3RDOkuKkfk8SqPvLHjj61dFRjDZVZO6cd2r41oIJOapyBfpQN5ruTpYmrYvVT5ZrkVXkAxAx16Oz4hBFzJdVwNF0zVlToGKZNyLVQQivDCmch43fzWjr8qXeeqOOGBAKXAF5yAcz4p83V8oaGm5wG+oMY0BVIOWJbiFqJFFtwf+UktfLHFlqdiEo8Fo3OKpxr7tzyjVAlKKuaEoMe1l3OKOBP2D2rEGrfT6vKUXRnBN5xq3GNgpkgRGQt9k839im74x9CA0GmdyHeLuHn/wb5kxiD0tMOQxnTV6S3Xc2Dg1OJeTnFPE8DQd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(38100700002)(86362001)(31696002)(316002)(53546011)(6666004)(6506007)(36756003)(26005)(6486002)(4744005)(44832011)(508600001)(6512007)(2906002)(186003)(2616005)(4326008)(8936002)(66946007)(5660300002)(66476007)(8676002)(31686004)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QldhNDhjQXhMVHBLTjRKcDhZWkNWc1NBL0J2MllmWGkzenVlODJkZkZxVXlh?=
 =?utf-8?B?QzRLWHFNTWpGK09UemJCT3d5UzY4c3JVcHJCZHdjcUJNa1V1Vk1RbHJIRUVG?=
 =?utf-8?B?YmhGVWtzRlFTaFpFdnVhRndYRlBxOGRlNUh2SzVWdGNuRUpvUXRCVlZzdjhU?=
 =?utf-8?B?ejRkbS8xMnRzblhyRjFWSWdaZHc4cnJvUmhGcEwxUDVwV2JGcU5KQWNtMkNU?=
 =?utf-8?B?dFZML3BPZm5ub2JsSWFiaTlFY25waTVqdnhNT2hMZkZENXZ0RlFGcWVYNHEv?=
 =?utf-8?B?ZThQb3dub3h6VVhiUGk3SzJIODhXWm9zQzhQWVhKWVVIakpkazlzYjJReldF?=
 =?utf-8?B?b0NmUUcwL0VKSU4xNkszRXNqMlpXY0NPYTdKWnQxbE51U21CbHFQbVNCczUw?=
 =?utf-8?B?amNQYXMxZksvdG5tcGwwcENSQng0WnZZRlhydHZsWC95TmZxY2tvQWdPSUhn?=
 =?utf-8?B?UFIzbzZvL2h6Qi9HUXVZR0xnNmJlei9FNldnZ0IzaDVkWHZWenZDM2JMVmpw?=
 =?utf-8?B?TW5mV1duVTloUXh1SHVnd0Zhc2tCcnA5c0hCR1pNWTFrZ3RmTFk3QVlCUmRo?=
 =?utf-8?B?VmVEcHM1RGpiWFZhL1JReWxSdkpDOThJeW55OUhiYkI1K2VXTDd3TVdpQmFM?=
 =?utf-8?B?WEhPSlNwY1VPTFE0N2c5akNLT3JGb05INzZtZHNEWFV0c0lGYmVCMHJCQUo2?=
 =?utf-8?B?Q0N4RFpiT09hbzh2RUtoNys3K1NHSDlpNXE1ZXRBOWJCQ0p5c1R3SUdHK201?=
 =?utf-8?B?TjlnKzNwUDd1ZmpzdTY5dkc4cHBJZDBpcjBkZXN4bVRzckE4SXJRTWVuSHdn?=
 =?utf-8?B?aUpXWXBJNUNGWTg3bFBaemVXNjhNSEVKQlhha1k0bmdYVXhCVUpIeGNiakd4?=
 =?utf-8?B?WHVVWlFpVGVxdkRVbnVvaGxFNFJ4Mk1GTWhlOTVYbG9VTVZJSmRjYWs1R204?=
 =?utf-8?B?NERuV0FTSWRScG02cDQxV04walQxbTBQN2JWY09VR0t4V3M4bVdEU1NIYkdw?=
 =?utf-8?B?ZUNNRjVFdkpyWVdqMFZHd2E4ZklBTTM3T24wM2QwTWJuSDdCSVkvM3Z1akZx?=
 =?utf-8?B?WW9nNjlIQU04bXBaUmFzTy9KcXZuTVQ2S0x2ODk1dDJOMmJaYzFSeUJ5dlh0?=
 =?utf-8?B?QjR6ODFia2ZvaGFpckVaWmxUYWNkNlNpcGRDSzBFWndqNk41SHNhWHZqUXhm?=
 =?utf-8?B?QnJ6T3l3LzJySlpLSC9ZdEtxdiszdGh4YXB0SnF4NzZVdWNZb1QySHR1RTlH?=
 =?utf-8?B?emxzUFg4WlBRdFpnWmJiWDhHR0dWZ0FpV05qeitFaUF2WEllbno1SGo5UmhI?=
 =?utf-8?B?Tk1jbnBHL3Q2azdOd2tEQW9pNU9VLzFZVmNQVmdEbTB2azVmeE5KY3RQUmNp?=
 =?utf-8?B?cFBmVkRGbjdRY2xjYUJ1VTdOQmtEay83dENZT3MyQUpJNGkzakwwSDM1Tnpk?=
 =?utf-8?B?ODA0Q3A3UCtRWnRvZmdMczNWOC9FZWFvNFJ1ckczZVdFMzdlQ0R1WGRLZmFO?=
 =?utf-8?B?aEYwUDBiZGhwdDFSbWgxeFcrRDlBdnBwRGw4TXZHd1ZvYUF2Ym5PZTB3VG5a?=
 =?utf-8?B?L2luc3NERHBNVmVjOFJuRzVZYVdhRGQvWVlFOTdGejhGdDFEYzR2Q2M0V0pC?=
 =?utf-8?B?TmFUUExzMzhLTTdOVDNQRm5iSlpWZmVVODc0MnVqbjlpQmxBdll0Vmx1dVdK?=
 =?utf-8?B?UThCSlJJS1hXUFVVeVFtcHh1aEMwR28vdjVMd3FLNldTRmZNY2RmMHpxUTZ1?=
 =?utf-8?B?dGFIM1d6U2FGZEp0cmVSM2tlMTFIVmFsZDhMS0hwVG5OakpXaFd0YS80ZUh1?=
 =?utf-8?B?bHhHR0x0eVJZTzFoVURMRzU1UzFjTmZJczgwUGhMYkdXVmdYc0ZHSjVsYmZv?=
 =?utf-8?B?RTVoZS8vMzdWa01MbEhzMFZvZTJwaTZiMWVmL0JnVXROczJ1aVVLd1pzVTMx?=
 =?utf-8?B?ZDZ4M3p2Y0F6VlpySXY5MG85REJmYTcrZmhGTnlUU1ZreWk3Q08wdUJtSis1?=
 =?utf-8?B?VlkwT003ZEM5WXQ2MHVXR2YwQVlocE9NZmlPRERZZFRqbFB6L21nejVjTjdN?=
 =?utf-8?B?dzVIYkpDcUs0WStPcXZaUzk0T2o1OXllNFVGb0g3eWpUZjhqa1QrRkh4Rkl1?=
 =?utf-8?B?cWFVaEtoWU95QWJWSGcyTmlVZEwrUzlrRUZKeGF2ODBMWmN0cHFFVDduRkx2?=
 =?utf-8?B?SkNKRXJWd1VVT0ozdlErcnY4bk1ISlNjQ3JHRk5OS1VUOUhrYWQ0YUtuTGIw?=
 =?utf-8?B?NmNzUWxHMzdXaGdTT3FYUVpBeVFWaUdKN1NaeUxMVkpvTjhHcmFUUG1nZDZQ?=
 =?utf-8?B?a1lyRjRlb2YrK21oWXpLcmVsVVpIUmEvbldmeVl0cFpIZmxXaFBjRzlNdWxq?=
 =?utf-8?Q?+9NprEj47YxeduWI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd66fc7-dc68-487d-0c8e-08da2965523d
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 22:20:37.6870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gEHss81OdWxXIF0k9Vv4dT37V+ppnR2K/he+5nQ8sTvFzdHD1hfgEqh/zJcFo8ZCDKw3lmj3F5MCwB+TM17cFlRELmJv+cw9XpyvxTrE/do=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1556
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,

On 4/28/2022 2:29 PM, Dave Hansen wrote:
> On 4/28/22 13:11, Reinette Chatre wrote:
>> ELDU returned 1073741837 (0x4000000d)
> 
> BTW, what does that decode to exactly?

ENCLS instructions can fault as well as return SGX error
codes.

0x40000000 (SGX_ENCLS_FAULT_FLAG) indicates that this is
an ENCLS fault (as opposed to an error returned by the
ENCLS instruction) with 0xd (#GP) identifying the fault.

Reinette
