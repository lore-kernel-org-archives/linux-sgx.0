Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9665ECAAD3
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Aug 2022 02:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiH3CUM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Aug 2022 22:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiH3CUL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 29 Aug 2022 22:20:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9CF40BC1
        for <linux-sgx@vger.kernel.org>; Mon, 29 Aug 2022 19:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661826010; x=1693362010;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lwdxyw6r7JRQuV4p9lWoXbwCqK0WUlES1ENCniBvGt4=;
  b=bdI7toSDq1Dhs3DDLzQI4f906+Db18mWSSuw30T+OvWlr8D+AknWRHVk
   0DPXgWzC+cF9nS173Vfly0LXHlYVQSL1JEdwMpLL6fZutyJ0x8VbnSIA5
   XW2ZrHkFP9OgsZFMce9oQ2/eY2snJnutAyyi4PWTaVAhBUTlrpkUDCY2H
   TkSIv83tdofUOmsu1oTLoKmu50KwnmoX//idiiEvbgr4IVBnFEcC7WXG4
   EsbbbbVANag+2teoOkdsFLL7c5oznH/3e6fh6r/Bs270lE9RnLbow22nP
   q3wUXBHkBnK4bNYA6dBJQwPQMUesb4sSBKoS6cS24+Z6NGRIUQ9zeewJY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="293801001"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="293801001"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 19:20:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="679855588"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 29 Aug 2022 19:20:06 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 19:20:01 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 19:20:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 29 Aug 2022 19:20:00 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 29 Aug 2022 19:20:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IisTnRpJw0XnnIkBPjMTcSZXT1L4eD/useqG6zdU5dPIQpC5BF1CYtJGQHU/X6mJUz0eTCGfeZFODr8AgwQimydosJnyDADm97NzPUqgJadUD3Z357kh7hcCsG1GnqqwO2/v+qN0MPGajrDaQ6XQf8GO/zoyVW1lqUv2wtpttpCn7IC9sLY6+zepizlBGAAZp7GZ3URDBpo8WomjmWJsGQMnfAmieLBrgE35ZB5/Bvfi0/0v6VWaP5+AMeXk7lzoEL/BSnYRS7IqeVg8nG+tS11mk4SLtkNA5+NHoTzU+0qv6Vq7CLeKdg3HEPfeVs9LBjMG9mejqqgRMbmj7NSGTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YZfM+TZZd3dy4dTtwmIwvgdr+4+SDI0M0KzpjVpUPo=;
 b=Y2y0lTxwMtAhpleqVC6xPAwOrLgPRbL/pJpL1gjU+RHdYZ8ABb171METFVNCwSU/Gl9kA4NEeCzgCjiMzsH/Wb3jSv99xL2du32GLdjfwNSxvv9ITBELjorZ72VO5mrCjP1nKd+O1BLal1P8qP27ei2x9ifHu/qbrqJgrZFBoriDfWPwmq84MV6/aVS3OfGqIXLPJE7IJXRylEe5kLkqzsMq98EFVT59PPWyj1+9uSG01WJwpoNCoW8oDd6yghUQCcwKNj3aXSDVinNI1kWVrRgx4luYS0NPjuDmnQnw9XrWneQWwT3WpFF7/4StTqwhQTTn1pNz35wevqelQ/vjQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CY4PR11MB1638.namprd11.prod.outlook.com (2603:10b6:910:e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 02:19:57 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed%4]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 02:19:57 +0000
Message-ID: <20a17b1d-eba3-8502-d6cd-038d5d44687e@intel.com>
Date:   Tue, 30 Aug 2022 10:24:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH RESEND v6 1/3] x86/sgx: Rename the owner field of struct
 sgx_epc_page as encl_owner
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <dave.hansen@linux.intel.com>, <linux-sgx@vger.kernel.org>,
        <tony.luck@intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
        <seanjc@google.com>, <kai.huang@intel.com>, <fan.du@intel.com>,
        <cathy.zhang@intel.com>
References: <20220826160503.1576966-1-zhiquan1.li@intel.com>
 <20220826160503.1576966-2-zhiquan1.li@intel.com>
 <Ywrgp+NUuB83ajkO@kernel.org>
 <e95f8dcd-49db-8bfb-90aa-b8074002919d@intel.com>
 <YwytkoKoK2TmXPva@kernel.org>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <YwytkoKoK2TmXPva@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0087.apcprd02.prod.outlook.com
 (2603:1096:4:90::27) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8dfad78b-1116-4aea-b3a2-08da8a2e21be
X-MS-TrafficTypeDiagnostic: CY4PR11MB1638:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aIRUotEwSXCZBMhU/YmNJ7yFIF/281eEWr2l8qsRJ0RBzRnHFozW8g3FaV4jKx3mlgiqa3rjb+9Is7p1bQ5/KsKnEJSSVgSDYC4ccxANny5T+fHGewF1ui5V7vClvzn3rYy0as9E9qGbP0JakmjdsKnnYMAPOazw3XrQIczNCTwAnx8PYPk0okdB85dsbC6jW8Nua16tAYegLpdyI2oojdFF5h+TqjxXHQTFuNhoLXb1PRHmJX1sFZEmcwt9fjcJ8YigOkteY9mHOgLv3P5N3wDT6xM2TKbrxEgEY5K6DnjCXpBFha9duX6/5TnoYEnfhHjC/8h5hb0OQMYg+VCpmgImsAXK1rO2ZtaIe2Gx/n0h5RYl+nBTlk+uxdeHakajBqfWxSBaCDKw2oMFZvOoLbSSED/2Y87iHpygUTJ8+5x0LaHFh2YKjiFuuVrgpkeKJppUIk2pCUdoh2/Akldqwur3NhMoYNWZh5pJ7nGh4Jbq2x5mMLbO+J68VmeQjNKofAbusu0r1fkOkvGdVtK0SHeOlldFz0xp5giUlco270j2Tdbe2jQcPlXFGq+HcXdr8dO2J5YnzS9PZxiCmSdgF7kekGZRs45jaA402bYptjiYQkBO9BJ5N956q+et/LXSfZdFkKHVu5jwFq6qzkb6zI/d/tL+AjqDNpjaAr6SrJA4Gweh9IAW+N0SSL9vf6f0mMQ5FFPdTi4DAUH9L2TaLBxSnahzTJPWasXWr68M/gobrjjCg8Oq+v9epYiJTmOJGr0SSbK0QRDFWB0TcLwL17FrEdEUW6NG/+cGiCqomrlC4oTdmCYDU6yS8J7CFw+yifSt2ATKmRV92AKiu4Jsmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(396003)(39860400002)(376002)(8936002)(4326008)(66556008)(66946007)(8676002)(5660300002)(66476007)(26005)(2616005)(316002)(31686004)(36756003)(6916009)(2906002)(6486002)(478600001)(6506007)(6666004)(41300700001)(966005)(53546011)(86362001)(6512007)(31696002)(82960400001)(83380400001)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MStPZ3BBVlJyd0Y2NTQza294bUhDemtKVmtJN2NvdUdsTmJFWHlJUUI5SW5v?=
 =?utf-8?B?Yys4cmtmd3ZPTW9pQXRKZXlwQ1o2THNBMER4cVFWNnNvY29GL2FibzVRbDhX?=
 =?utf-8?B?eHFPUHlQUkx4TGZBdFhlUytiSVkzV3VUOENMdnpTWjlsSFNtYWU2RVdRdHBQ?=
 =?utf-8?B?TlMzcDdYZjFJSXhrK3N6OFpNWW9NT3AzamVKWnNFVktBVXM0cTRPZzlZTmtk?=
 =?utf-8?B?cFU3VmV6NkRHdEk1MXlLTFg4U3E1L3BEQ2JJam5SSFhkQk1yZDBzZEdpakl0?=
 =?utf-8?B?WVpGeW9MNU4rWjVsb2ZxZ0tmRXBPT1RJNmNIblpQQUZzUnNjZEJUZE9qSlhQ?=
 =?utf-8?B?c3ZBWTNwUDJucWdQbkNQWWl5ejh2NUVDd05WbGNXSjVTS3QrL1Q1YVB5dUhz?=
 =?utf-8?B?MTZCOUU3TnN4YkJyamJmWFhYc3JVdXVnMmpjbWR6TndjM0tFSGp3MFlrYzhC?=
 =?utf-8?B?SmFSUVVwVVF1cTFZU054QlpJQTN2OEVKYzAzWmkremRjYmZiWUhUalViZlpF?=
 =?utf-8?B?MnVUNG9ieCtRb2NOWGJidjUvZ3JFRy85T3RzanRFNjV4di91T3BtYXNGbnlU?=
 =?utf-8?B?T1JFaEVSVW54WndkVmJteWVuclhuODc4bVFmdmI4N2NEZksvM3hVMFhGelpz?=
 =?utf-8?B?bU9NQSt5cWlEZGFQUHN0aGYxeEhzZVgzbFdMS3gwVloxYWh1OGczai9XMEVV?=
 =?utf-8?B?akhtb3hOSEdYbW1PK3FlN3ZnSzBhSnVnVWRja0NLTitTd29vMk9ROEI4WFl0?=
 =?utf-8?B?OVkxamF0a3A5elA1aktDYmk0M0QzT1JKMk1YdUgvUVU1VjVvMzdlTzA4R3o2?=
 =?utf-8?B?aGNqTTJtcjQySE5IZk4ya0hqTlVRTUp6YUowWUdmMW8yNDZVQW5CWSs3Tm9O?=
 =?utf-8?B?OGtEdWduTnphRkhMZ25MRFQvNjNNZTlkbkg5Y2V0VDc3OVIyNHZqNFFSNGtW?=
 =?utf-8?B?STVObTFhdHVBK1NrQ3o1UkduajNvcEFrTklNcWNQcWhJbitJeWN5WGkyRklG?=
 =?utf-8?B?cU8yVkoxSTZiSmh0SnJRM3I5MmNSNVUvc0EwemYxSlNLV2l3dnFoa2hxbDNt?=
 =?utf-8?B?eURnTEFzbEh3bWJFU25jaVVaWGlRR2FTelRRcEFEaDdrNHo4QldlN1hYSVhF?=
 =?utf-8?B?cDVLSFBBODNvSHRjVitjekxxUGpjQWR4QmNsczhmdDlQeTNQdVNLcmlqdDV2?=
 =?utf-8?B?blRnQ05zZXl6VmNXK0J2OHUyMmlqMnR5VlJISlNlQy80TkZHQmt1ckhRUk1s?=
 =?utf-8?B?ZmtnVm9iVTlmalBsR1NwazBybEMrWmZHdDdTeEFJODQ0d3k3bW1LZngrY3dL?=
 =?utf-8?B?aTlML0I5TTZBWFhRbnJTZXJUM2YzdEI0RFVhK2tTN2ZFaUZuTVA5bU4rWFN5?=
 =?utf-8?B?eTZSZWt6NzVwM21sQzFLVDRia3VEVlBidzM2aEtIOHlONjhpdE1xMytPWmxS?=
 =?utf-8?B?MHdQZEliRHRzOWFuYVc1S2ZrQ1FIVlNWY1NuRVRtVHlBczFEaEo4NE41M3pW?=
 =?utf-8?B?VjZ6dXBrUHBkSnlGOUxMODBlNExtb3dJRlpYRnlNT2l5cE13K3FoZEYrTEhX?=
 =?utf-8?B?dmRzNlZnYVFMcVRsbi9OdVB3SE9ZdFZPdWhadU5IL1RIMHk4ZHdKUFk1WS9r?=
 =?utf-8?B?YVExdUVkenpUbUZwcTVOVzFGUERuYmdxQWlaWU5BVFBRTWpoZTlCSDNSbTF5?=
 =?utf-8?B?Y1dMMmZaU2JIWnFZWndRSnkvMWJtMzdlcWxqR0FVQjl6emNrMkx2MzV0RjN4?=
 =?utf-8?B?Ky9XVUJIb3RMZjZzRjZzNitqUG1TcDF0QUs0UEtKK1BQcURtemZkWVlBV1VE?=
 =?utf-8?B?TEtPVDErejRvcjUzVW9qdWwwb01lcmFlK2J0OVUrZ2VLTUdBUE9CbXMwYkE4?=
 =?utf-8?B?dDlFSzNkV3BEOGVkWWJRd2o3WEN5N1hwU254dWMrV0VtSDlwcmtzZmFPcG5z?=
 =?utf-8?B?dXozUHZUNDUraWwwdXpLUWdqalFGcUVCTURrVDNLbWtvMjAzUWwxWWZNcjJ3?=
 =?utf-8?B?RlgybWp6Ums3SCt2bGZCaUNpMTMwclJZUU9WdnpzdVJXTlc4WmJSTXBDZTNR?=
 =?utf-8?B?L1VJY0pGb3dmMlpGbTVHaHo4bXJUVVNHSEM4UGd2NHdJZ1FRdFpSNG9iWTBZ?=
 =?utf-8?Q?ntX6woscHKS7D3SDlYwwYzrib?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dfad78b-1116-4aea-b3a2-08da8a2e21be
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 02:19:56.9527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMTwSHG9MYgJjBU2r2JQlnsydjIjHlH3lxbHDXImdri3foYDt+R30ivNBO7o03S1kL5BBkO/RYr87oAduFjX+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1638
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 2022/8/29 20:14, Jarkko Sakkinen wrote:
> On Mon, Aug 29, 2022 at 09:23:48AM +0800, Zhiquan Li wrote:
>>
>> On 2022/8/28 11:27, Jarkko Sakkinen wrote:
>>> On Sat, Aug 27, 2022 at 12:05:01AM +0800, Zhiquan Li wrote:
>>>> In order to describe the purpose of 'owner' field more exactly,
>>>> rename the 'owner' field of struct sgx_epc_page as 'encl_owner',
>>>> and update all of references.
>>>>
>>>> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
>>> Is this rename really worth of doing? I'd only consider
>>> such if there was two 'owner' fields but since there is
>>> no name collision, why bother?
>>>
>>> Thoughts? Please correct me if I've forgot something
>>> essential previously discussed.
>>>
>>> BR, Jarkko
>>>
>>>
>>
>> Hello Jarkko,
>>
>> The field name and union comes from Dave's suggestion:
>>
>> https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m2ff4778948cdc9ee65f09672f1d02f8dc467247b
>>
>> - If the rename make the thing complicated we can consider drop this patch, it might introduce potential conflict with the SGX patches under reviewing.
>> - If you think the union introduced by patch 02 is also unnecessary, then we need to discuss it with Dave.
>>
>> Best Regards,
>> Zhiquan
> 
> "In order to avoid unnecessary casting" might then be a better
> way to start the sentence.
> 
> BR, Jarkko

No problem, I'll revise the commit message and send V7 soon.
Thanks for your review.

Best Regards,
Zhiquan
