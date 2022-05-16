Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A0BC433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 16 May 2022 08:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbiEPIjz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 May 2022 04:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbiEPIjx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 16 May 2022 04:39:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962D5E0D8
        for <linux-sgx@vger.kernel.org>; Mon, 16 May 2022 01:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652690392; x=1684226392;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z9mUkrGc3Slp8Tcfd5eEFOutJCvr173yX6RPPMOKFOk=;
  b=fmPYygI9T2MANCBN6GMYue3IOyz55ZGZLSRCblm1oEqJkW4hA58EG0dy
   IFO/dVN7lw2k1w1QBzPbKq+tfzSnQjaSyL7l1M6cmnp/hs0nlDIkHVwxw
   dENo+jagQ7yFTnZxccPJMt7zKqt8KTD6FHiEfLcK82Lff8QDD4f5o+J3R
   HiVaUcPjs1arYzyPnfgFp251KKJD4MSlIcaASFiZPwYvi5UwAHKMgbXnx
   dQNdWJUENKf5lcXeH/bUgOvgxVlrnqA2dqu5TcZszaHN83x2Wy6aKdw8f
   mU5wEjWUTUkzIYpw/2LP+r9FH+bA7+nRLRMfYhc4GxpYIW2wZ6WpFRfpQ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="252841328"
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="252841328"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 01:39:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="555160227"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2022 01:39:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 16 May 2022 01:39:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 16 May 2022 01:39:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 16 May 2022 01:39:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsj4iZaafM0Q5lXY12IC5MSpENY4COKg9KT1HNsNiTGDGaBSHHvv31Fckc5xkdMHbyEZB6BHJClPA0Q9ci+s0krnmUCzp5/R/WTEbIpv7wifz3NHgZXKFaH6gfYAL1ABe/7PNuvQasAd7mSYkQ2BAjrD5KKWvTg4MHKwpRAZd+HC1cOkF1W6DBUeUxzHwSs0Ptk9JL6/TJlHGTO4kAMx7/lJLac93vl/PskWwGPHLQC5Be4ZbaJCAGr0FfM9AnJ23vWV14XbwugZ2HTxGAFRqt1F1yhNXm2DUR/vNF6XGm/DBbrHH4bW8oO7FoB3Ua8GIogdfBdZxTFE3MKIkut5ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJFo6S41zzj4llEcw3sXJ4xOcmjhA1g3nTsRwRUvMAs=;
 b=lTYz/kNXPRaf20pBmo9vdHLQP3QtythHYw0mzT/b55JHew/Yud50RAtxphtMP6t/Wf0woMsdKOkef9yHHI48zGzoggY9FUUB8NINA/zNjCncKVerD19sEytq6YCnkN+uukUG/TBIktYAQkbbapP+qGQuce7o8fzHBA0re6NKo5Ykckv+Te+5Ez2Mnu3mcr7B1CIborzOR/eLb9suSKnEVKSLNBm05LiR3h6mbc5tKnO2WTVKUnj/R3/WzNbrLWkZlut8d/suwT7s8gT1Uspw7tfwsN5uFD91KPxpEFVQo1c0vLghO6oA5LSLpWAKNfHSaU3e3mCz5IAPC0t5qxIcPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by BL3PR11MB6361.namprd11.prod.outlook.com (2603:10b6:208:3b4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 08:39:45 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 08:39:45 +0000
Message-ID: <af6b22cf-bcc5-d1c1-e183-fb47200d58ab@intel.com>
Date:   Mon, 16 May 2022 16:40:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Du, Fan" <fan.du@intel.com>, <zhiquan1.li@intel.com>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
 <YnuQJaM0p7gD5qel@kernel.org>
 <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com> <Yn5tPS0aLXBgHtYT@iki.fi>
 <55ffd9475f5d46f68dd06c4323bec871@intel.com>
 <35284def-ca7f-d42b-164f-1c49eb8977ee@intel.com>
 <968e75d65a37ff7ae21f84875b78fb1ebbbef33d.camel@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <968e75d65a37ff7ae21f84875b78fb1ebbbef33d.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0162.apcprd02.prod.outlook.com
 (2603:1096:201:1f::22) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d801d79b-ba7f-4cf3-d074-08da3717a0d9
X-MS-TrafficTypeDiagnostic: BL3PR11MB6361:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BL3PR11MB63614E13ACA9A60A6A80062CA5CF9@BL3PR11MB6361.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CbUlXWasSv925Zl3BkN8gtV5oNCMtx2yCIiS97ydZJGd3HRNe7fZXc6ywiEwDzdSkZsIItY4DOeGPxbeTgYapH8LunhIQQVSO5FA3Pjh3O58UFtHeoh0aDiEeOcnnBHINY0K5OBiF/U+q2KyyQYYgoM3SpU00QsnGHXPz6k0qwtCnrTnoFNmyI5DPZ1TBTfKxzMk5puuxIqOdXDdMRx/it9QNxpO5v5zYCv0Og60Eg0T0JgrU046KeJ5ERztPDG5B8se/scVIqRZ7qJ+8Hv9DrkYBwp11rurZ39p4geIlmJvtNX2FPYDlqXC1GV9zlL7MZWO6o1ICz1mrEae6HhUUK+YDS9HxfyLUYPtc3IHmX/HuLX2UR2+8jdobJ6toG1qahqkJTGVBSKkFezZ88FgSRmb+nPRFfI9t6E5AXSZaGKtSb8vT7/6zIKdgeyd9BZrQMs//kHUm7U87gYQXZOOutWOgAXr0CnASPoApVY0kYgr9nwG35FCpfFFs4yESQW04nGEajwp3nX/n4DW/gZNUTP1B8UFHQBnS2DYIkKtPTvhHHXwTKECzpvZ4O5fkofTSb7FDEnvHN9HTka6sKVAvzEAPVXjWeIf3RFWm15jTcYrw4xeLhHeY6761FcZ/VWzJ7THbGt0lhthvYCQ74eC3KzucJCihWcZxofldaKgcoX9bVNJmHYajNxJ6Ho+DGZYNeOlp2W8qGinVnNcjaAJP8uAfEMtBgv8eb/jtV7h3EbXMHBNrhOWWNFK2St3okBl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(53546011)(6506007)(8676002)(66556008)(66476007)(6486002)(508600001)(8936002)(5660300002)(83380400001)(6666004)(2906002)(38100700002)(316002)(4326008)(36756003)(6512007)(54906003)(31696002)(110136005)(82960400001)(26005)(31686004)(66946007)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnBoMXdrSEdPREE0TmVqY2xtc2phb2EveTZoV2JyeXA4djJ2ZCtLU3BWQ1l1?=
 =?utf-8?B?L3kvdWlQNFFGdEFDc1kwYXpzR3owL3JPNHg3KzRFYWtaNE9mNCtGMGxSekZI?=
 =?utf-8?B?TzlJcnJhMThLUTRSRERLbGtoSHZKUExxNjJYVUR4WEs0QXlBbHdoN2xMdEYw?=
 =?utf-8?B?ODlIVjJXNUJ0LzcrNWZVdmtmeUwwSnJiZHg1eFBxQVowNy92SXNCOUdHSlow?=
 =?utf-8?B?NUFKWlZ0T0lFek9DcEJJbHk0ZUhkWWVLeUkyZStsWDlMZWZmSGl3OHdvbEt2?=
 =?utf-8?B?NWZHSWlmd3dySTRUL2Z3dC8rRldwY21QYnhQTmhjS0lYYzRiRDRUU1hVa28y?=
 =?utf-8?B?QU91OFN5dU1HaDlkQlA5aVJONXB5SGN3UWZSaFFja0FVQVZkWkdGWEgyS1Rs?=
 =?utf-8?B?ZWRxNGJNWUgrTDREMytWY2JYYnB4Qm0wWVQ5Si8xSG14NHZBUy9UTk9Tc2Iz?=
 =?utf-8?B?R3o0bHN2dWtYQjBaTUZtVUd3RHI4NWttWXJBaW5SSFA0THE2b1FNbXc0MjhJ?=
 =?utf-8?B?eWs4NkdReUxOTVVvK2ZVTWNDeDExL1R0SHN1d3BvbTMxMzRnY2hJVGxHUkNi?=
 =?utf-8?B?T0lyTDhBNHNUemNyUEU1KzMxcjhYTThUb2xWa1VrOTF3ODRGUFZ1V0hBVGd3?=
 =?utf-8?B?bVJ2aXI2bE9jbVpVV0oxR0k2eFBPeWlybHFRQ1ZEK0hVSUlJMnE3NzhDK29W?=
 =?utf-8?B?ZzFjS1RxV1RkdzJ4bXdlcWJhOG4vN2dQWEhJUkR1anZ5ajVDSTltVXBuM3lU?=
 =?utf-8?B?a1A4M0hoSHFONEtIc2NDSEFSckllZUlEd0grdG9zY1dNaGpKN1JHV3RKYkRN?=
 =?utf-8?B?NmE2VEFNRURjeWJCUFVBUlpqMzRMUmdZT3hjR1Ivd21XWkxIR3VWSlZEeVRw?=
 =?utf-8?B?YjhnM3hzNUU4UXVKcktlVmZ1Nzd5a1dHeGJuUjQrTHlaUlFkek1JS01HZDZk?=
 =?utf-8?B?Y05pQjZabElHMEdNcUZTV2JDcEpUcUVHdm1aa3NFOFd1YVJQUzBXMUs3dEIv?=
 =?utf-8?B?UFNwbktVNEhOZ1Q4ZEZ5cEZWNytPQndnMmlNWUs0eWY2b25GaHZ4M2l1c1J2?=
 =?utf-8?B?eTZKZnBGM2p1d2hHVXBybXlsbCtiY1M2RzdoZlRQZk4vWENxY2dFbkYyNlJr?=
 =?utf-8?B?SEQ2TEpvT0tlbC9NVnNCdTlSWWNjcnFtMkNMVEtWMUdzakJjOVJkSzhYZ2pV?=
 =?utf-8?B?TFkvU0VEM1RiTFl1a3dvS1ovQWt4L3FyaEhnZC9WNGNTNVBWd3FsNC8vNDZO?=
 =?utf-8?B?UDZ5UFU1VnBmMkZwamM4NG4ybnFTSi9TdWFPRytTUXdOa1h6TE5vdUo2VEVP?=
 =?utf-8?B?bjlvRysrYmhOaEhTZVdWcTFSb1JmK3hhaCtLck5CS1dkSnJmaDlxZVBlZTYy?=
 =?utf-8?B?VUJvZ2JGb2pBODkvSnFNYWhvdmN1K3Q2Qkg2TzhuRWhKa3RXcHFBVjFYckdG?=
 =?utf-8?B?b3EyR3ZZUWRDSEtsTkYwTW5OZ29sY1MxcHVLcVJuSHNzRkN3WC95bTYwM1gv?=
 =?utf-8?B?Tk9RemhMMk41U1ZZRkdnNTRjS3Y2K283ZEtZd3V6L3JkczcyRExNSitnVzc1?=
 =?utf-8?B?R012RlBYV0lSNDZxSTBhdVhZVnhWalRpOVNJd3hiRllnMWhRUXhISmVYVHpO?=
 =?utf-8?B?aXpmWUdIYlNWQy9OSVBhcDRsQkZEdWlubkQ3aHVyblJEQVlHS0o5anBIdzBK?=
 =?utf-8?B?VnFvM1RFc3pxbytyNzdkWmQwUDN5bklwZkpqcDdJSkhtVjZtQ2FoSHkxTGlT?=
 =?utf-8?B?dmxmTGNwYnhpdnZkYnMySFB5N1lhOEtyM0tWNDVsdG1iWERRYkd0aHYxcy9n?=
 =?utf-8?B?WnU4UEhWUzFmenFZUXd0YUVTVC82TjBLS1orQ3NCdXNjY0F1b3MvbWVDcnRH?=
 =?utf-8?B?NWgxMlJVbzJ1L1JCbFlXN2xVME5RNFk5SmtSK0YwU2JmelFMdGk4QUczendi?=
 =?utf-8?B?b1JldWhHMng0cmxFRzYydUR2WHY1bFd1Q1lVZTBqT2FoeE9RU2NacTFhZ1lL?=
 =?utf-8?B?eWNaZURNZ292bXB0ek1INXBaSE11SFQ1WVo0TFFoZWRqZEJJbTVOVjVjU2hT?=
 =?utf-8?B?ZkVEUWdxQWNUNm50aDRQNlVzRUVndDh5UTJleElVWUp6d091Yy9peTZLZ2c3?=
 =?utf-8?B?S3QwcWZzTDhxVHNzSzVGMlM1TmdEb3hOd0xXVUsyZjFNKzNMNGlEUlJBOFQz?=
 =?utf-8?B?eVBOdi9jT2kydk44cUxOenhFUW42Z09wMUdCSWlPcHZoY3FDYkNwM2lLcmQ0?=
 =?utf-8?B?WE5CS1cxZW1UVWQrck1QUFBubUZxSi9QVXF1QlJYZHdiN3NFeVlPTUwvYVVH?=
 =?utf-8?B?dWo3dHo5bTBRejgvMWFMa3RiMlhhc1FPZ0NQZG5Ta1FmY3JtK00rM29oUHRo?=
 =?utf-8?Q?Xf5mN+/P1Om+CN3U=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d801d79b-ba7f-4cf3-d074-08da3717a0d9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 08:39:45.2188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZ59lU//ZhkNMNOsdfLPagZIyYYUqRPxzlE/0CRQtkBHxMwHp9RkxGtmNy22dfjxYHeqtiDDPEwpgeeyh+S/Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6361
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/5/16 10:29, Kai Huang wrote:
> On Sat, 2022-05-14 at 13:39 +0800, Zhiquan Li wrote:
>> On 2022/5/14 00:35, Luck, Tony wrote:
>>>>> Do you think the processes sharing the same enclave need to be killed,
>>>>> even they had not touched the EPC page with hardware error?
>>>>> Any ideas are welcome.
>>>> I do not think the patch set is going to wrong direction. This discussion
>>>> was just missing from the cover letter.
>> OK, I will add this point into v2 of cover letter and patch 03.
>>
>>
> I don't think you should add to patch 03.  The same enclave can be shared by
> multiple processes is only true for host enclaves, but not virtual EPC isntance.
> Virtual EPC instance is just a raw EPC resource which is accessible to guest,
> but how enclaves are created on this EPC resource is completely upto guest. 
> Therefore, one virtual EPC cannot be shared by two guests.
> 

Thanks for your clarification, Kai.
Patch 04 is for the host case, we can put it there.

May I add your comments in patch 03 and add you as "Acked-by" in v2?
I suppose it is a good answer if someone has the same question.

Best Regards,
Zhiquan

> 
> -- Thanks, -Kai
