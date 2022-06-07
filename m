Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7027C43334
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jun 2022 07:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbiFGHCf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jun 2022 03:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237416AbiFGHCd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Jun 2022 03:02:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B3F21BC
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 00:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654585348; x=1686121348;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GWbscR6ChcDRFzDczzkvuMztvQQSS4oaR9gRSXJacpI=;
  b=ZbGtzSljt11XUi/61tnzUvd8BkvCgNmslegUPGu5wnVEHI6tnwqbInzI
   KimkzpAUkaH/ExFimeFpjcJrWT6f/h4xqIlW7Y+EtLYKxBRgD7wSMsnlB
   t5tK29vtcAFPFKQBfKxuAv6lkGV/KrJaqYteddS6FF7KJ3fUaDceM7frs
   rE1AbQBMlXNX0Id2ngh9l3Jw6K+Ygh982BjtTCjl4mQytu66xNXTYbrPh
   wIjQKBUeuahWE5WSSWNSVCiwaCct4mHLCyemu67f8vCPR1hS8HZuF3Bg9
   K8P3s588Rv0X7M99hX3V348EO3XmPDv//+IWv5CsNitHKA2jvLSEMbHIm
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="274246276"
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="274246276"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 00:02:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="584068452"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 07 Jun 2022 00:02:26 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 7 Jun 2022 00:02:25 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 7 Jun 2022 00:02:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 7 Jun 2022 00:02:25 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 7 Jun 2022 00:02:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5xJ8Hv6IwFFUWnHLWncH+FhOxVaBLSiqOJjlzSupNKJUmedwwLCADX4ckQi0efRc7Dv6dqbVSPLt8uDehUcuEjj+qvT7vJyO3ctEE4lA6WoiAggEMMlY5Yv61ogKvBktiBaJDH3DyOL5lnM3sNGfwegn5VC22ilhNof+RvQm14P18mARvdj7wUEFmG8hmMFDfXkCFun7hznCxtzD4aj27gliL/Oq0ceQlRDJ/NxKjOnKZY/QpHTgREQJH9HLEwmGFq5NJdMbHtimNZ40vKB+az1IsmgjAX1o1dyGwA//4LJokUCfN94/yFms1C2Ci5kbNJOxoaIpORWhxp/z+W94A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wI+aPlifq40jj4aum6Fbkks4upgJLecPYOYufR1phvA=;
 b=aZWKVGlbGUFjpWyPdxf41Jyg4fwPcP+wKYpZf/M9HdQZYKA44wWDV8XiVzXwx0ZLiUANxdWTTrcJceffGJhSxxWVEIzs2qcLiAZyiC/bkUg9YEBKGke6T/+S1Fa42C4CwuEEy9P88Wg4bLshyfm7eR8nMvnsbv9ph0/5MqqF9YIZalPwfr1bKPEeTzSeLG0Ae15Z926AaluKxK8as4DEV7YvCG0plV9kzwZEjdRjthaM0S1C/fVJYginjFNAlFgJUlEagngMuSYBl1MggESr7TeliorIvcCmkF2NZNY87fyu7tyaR/H3HBz0N9hgv6NeswlTg6iTaZd/TcFW6KnlFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by DM6PR11MB2747.namprd11.prod.outlook.com (2603:10b6:5:c6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Tue, 7 Jun
 2022 07:02:21 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::a988:feb4:e85b:3f73]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::a988:feb4:e85b:3f73%7]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 07:02:21 +0000
Message-ID: <0350d13c-0122-365d-11cb-eca004b411ca@intel.com>
Date:   Tue, 7 Jun 2022 15:02:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 0/3] x86/sgx: fine grained SGX MCA behavior
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Kai Huang <kai.huang@intel.com>, "Du, Fan" <fan.du@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>
References: <20220525100604.760576-1-zhiquan1.li@intel.com>
 <f239a63d32cb8b3d8d6730dac940a51e92831828.camel@kernel.org>
 <MN0PR11MB6181099B27E37C05659A30B199A19@MN0PR11MB6181.namprd11.prod.outlook.com>
 <ccfc5dacc80454e35b0f13410abc8606832f7517.camel@intel.com>
 <86eb19b512771098136e43fcdac95be8646357e4.camel@kernel.org>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <86eb19b512771098136e43fcdac95be8646357e4.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::16)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 053fbaea-bc59-4330-2439-08da4853aac3
X-MS-TrafficTypeDiagnostic: DM6PR11MB2747:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR11MB2747A9CC195037E263152FCCA5A59@DM6PR11MB2747.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H3QPIHwfqIiwXlpO2RL80VeWAuorQ2IOx7ND+Sqt6qFotB9HJIdll7SFHPilUwSiPl5cK6ktqIcadiO5iVceRLCYWC4PzRrpzv+GCw0PXU8eBEIlRdleiEtnwg+4nznk+Z5p9JiMu9g52d4kkw99cFB0j0OWIk02lsui0LxNpfN2quil9oft6o1dVpf9IJCYueF91qKAR68ATRFKnAC1E351Sr9SCzzI+rpOsgD+VfVSaiZ/ECvhS5Grka08SqGyoBlsOqr2/Did5j8QxPzBLfOenpG2rHZLWUcuO3y4Cq04hFxjd0JX5GooDhVJDocFqkT6lPn1jKhMQsVqQjW3jeQpkSOgdUJhqS0YZZH9cRPDZmVmjnyUlYQsAaIRSbATc+EJOMIxia/DBwJveUcXK7Dg1/vqiKbHd96xYyvn2jHrjcmforvQFiZtpvnGwN7UfbjhZZAXpCfe6Rfi3mTcNzWnm0adswDcswqgpe6F9IfNIE4gZ7qtroA+/HiI0JU8g/bT/ymvpTIcasoXGMCk8bn5PZjDwYDqIGUEEAJX2z1DIqBPUjtzJ2R1XCn76Zz3qHrhVTLA9uAIZDhEj64jxBvCyOhT+/FBocl7U3VZOLsB9r8/w2vwgc5z7TYQaO5l1eXMF9S5hA6h5SvSoCl0aXNS4pw1wH6EqRWCxHb1oTub/Prmpk/l3rjMIZEvGnjS/bbIJe2ZRVIzI5YK58/8qVVKBZH71YgpOKAKnx7Sg5VOUrdwO0srIgY4qLpEDJV4qfhAhAY6HZ64pcSKSFfwqDdyI2XcMueTAfTnKF34CUR9tIg1ZvzGb/rnSeOeE6nVQFAkfscYDZXPFksez8aoxKSYESv5+8aa+ifRY7KerkbwI9lCPcOu8qIsfPMp97g2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(6486002)(2616005)(31696002)(4744005)(4326008)(36756003)(2906002)(86362001)(186003)(31686004)(110136005)(6512007)(6636002)(83380400001)(26005)(316002)(921005)(6666004)(82960400001)(966005)(8936002)(6506007)(66556008)(66476007)(38100700002)(66946007)(53546011)(5660300002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGN6ekdiZ2RBY2tDdmtJWm1zWmhUb2FjOGJ2QWYwYVRwdm9ZVlVnYUU3Tmdm?=
 =?utf-8?B?Y2RYaWNsYXhienVZMUUxM08zcDR1SWpRNnJCR3luN0N6Rk5BS1RwRjdwMmcw?=
 =?utf-8?B?djBBaEhHNmIrM2o4dE8veW9KTTRqZjhwT1QrQTJuNlN3a3lVQkFaRkp1VmMz?=
 =?utf-8?B?Z2w2dm9PcVZ1a25JR3FGZ29KdktFR09tTkRoYmZqZjNNY0VHTW1vd1hZNEV0?=
 =?utf-8?B?K2tOWUV5emd0dVFhTGU2T0VHNGlickJYUE1NQzFCRzN3WmI4R1MyUVNoY2Nr?=
 =?utf-8?B?ckNLL2pORDE3cUVYeXhhU09BSGdxek1KOUF4SG1UVDc4UXJWQm45NGFmQXRE?=
 =?utf-8?B?b1BFam1CN0YwckZkTFp3UUVvaTA3eGxjd05NcEhrdTROZGJvQkpGbjd2TWly?=
 =?utf-8?B?eE0rN0c1TFdoYWZDTW1mK3I4TERFM1MwNnYxQU1zaWVUN0hpTDNNT2lyZWQr?=
 =?utf-8?B?d3l5S3VuVFJWMlJOTUg3UnlvMjk5S2licVFCTXpFa3pSLzBtZ3ljZnQrQmw4?=
 =?utf-8?B?Z1A2N2MyK1pRaTM0enQ1NGZYOUlUYllZYURDaUtXaC93KzZVR2h6V29sYTVJ?=
 =?utf-8?B?VGdEcG9MQkwza2IzOHRuRERDR1JuNFBodHJvWkwxaHdoMFNUZW1uRDU4a3Iv?=
 =?utf-8?B?M0hiaEZnY0FBdG9XYmNUckxZaFdtTWluSlFhNTkrVm9TVnFPcCtrOUhTWGxt?=
 =?utf-8?B?eFIrSWxEWlZUNDZ4UWVCTHdWeWtoV0F2V2wxTUh0NTBFeTNKM3BsYkpMSUVH?=
 =?utf-8?B?aHVZKzl6NkFLSlpPQWNxL01QMHM1Y3owZTNZZjJEZDlNNWdFcmJWb2hEaWlj?=
 =?utf-8?B?TDJrUk1uejRFdXBaQStPSGk2bkdBRmc2eDBuOUtoVzJVaUtUaGlmR2U4K2Jy?=
 =?utf-8?B?OEhXNG8wS1R1bllGYnZEVkpSaUlvRHA0bnZHTUVIMjYrTzlidlBFd0t3bXp5?=
 =?utf-8?B?RDljbWsvYmhsVTZEdFRLanJRUGFyTy82MVVZSnV0TVR4SXl6dVQ5YndRUVNm?=
 =?utf-8?B?Mjd1K2xaSTAwbnFDV0VPWkhtY3pRQ1pHbFNzSlZVZTVyaWMvaGI0U0VYTGJM?=
 =?utf-8?B?bzFSU3AvRFNrS0M3aDlqUndkMTBJYndzSUEvRitMNk1oejlMRGhjLzRFbm95?=
 =?utf-8?B?RmxpN2hsQ25OdlhmWCtGbGNDUjRnUWl4Yzg1KzQyNFVNaXQwb2Q0dTRqR0lh?=
 =?utf-8?B?MWJLTC9SL2RxZGxGTnhqbHpHV3l5a3JUNnRmS3Ivamhvd0lWU3VJQkR6Zlp5?=
 =?utf-8?B?YzJVTmFLUTRBM3I0TWtpNjBZdzNTS1dzUUtRSGVTZS9EM0NZNEtyUndpTmlp?=
 =?utf-8?B?dnZkdjcyeFA0a1dhd3pzYW5vU2tSQ1BlNUpKRG5tMzBMYlRoY0xNbitDdTFZ?=
 =?utf-8?B?cDQxQnNoQVAzNHpzWXk4alZyMk5ZOUZLVGRqSU1VNFpCMXBqd1FvMkIrL0VQ?=
 =?utf-8?B?UHZGbmE2dmQ5alN2YlFZSDRKaXBYUDN1YTlaMlBoRVBMMndaaXJBaTJJV2Jw?=
 =?utf-8?B?b1A3Ylg5UXJ2c0FLSE9vOUwxbzZZRTZEam5XVkpFeHNSVjlLZW81b1VZdUZq?=
 =?utf-8?B?bDJRZk9HeFVHZTVld3huODJnSTA5K0xta3ZHYjhrdGJlLzBNYkxTOFMzSG9I?=
 =?utf-8?B?ckowUmwyczdvMEVpSkxCU2tYVHFpVWxBdkRtbjQ1aUV3TEpPQTVQSXUwMnE4?=
 =?utf-8?B?QnE4czlLOWs4VFhHaFBpUnMzMFZ0MUNwa2hUMU01R0d0b0ZXaUFubFRQVjBi?=
 =?utf-8?B?ZmtPZ2FVamR3KzlVcy9aeGg1U2NmWkVDQjhGNk41MDMrSG40M0w5ak52YzJP?=
 =?utf-8?B?MklmamNWaHJ6VkhybitGblpIRTk2bG1Xa3RDQWF3YVUxVXRJNWhuQWVGV0Zq?=
 =?utf-8?B?bkpCNEJWS2RxbGZvTTI2N3NCelFNdDFLUDJkVExSS3FkZnRrc09qZ04zSHJG?=
 =?utf-8?B?UlZXZmRTd3I3NmZZR29QYnlDK29NUllvWnloZWI2K2VXYnFTRjZlcDYreHFO?=
 =?utf-8?B?VUwrTkUzRWtJazRpVWZ5NTUrRFJuMlpqWEVraGI4SW4vbHNPUlJCNnVOMkNm?=
 =?utf-8?B?eUpqeS9GQTNjSWcwTFF4TVNvUVBqTnhZckZZb04vRks4R2ZhYmQ5MzJXakc3?=
 =?utf-8?B?OHJZOUxHOUpXemFJUmJjWVB1RmtSazZuMUtUeG5uRnB0bGRnZ0FNUlJJRXN0?=
 =?utf-8?B?WFJTcWNtWVo5SXlDbXdGVWdwMlF6dUNHcSs3OVNmUEhYMEN0UEtiZG5LNHFx?=
 =?utf-8?B?Z2hERWJhUHkxMHJxbEFib1ZXNGx0N2ZDNGUxdXNhcTRxdzBwdUFaVHBlckFI?=
 =?utf-8?B?dXFPN2hVNDVyMndRU3ZMWmxGV3pCTVNiOUlhMmFyd3pEd0pUNUpoSVVhMTFr?=
 =?utf-8?Q?Ix1o71TWXlI4Pso8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 053fbaea-bc59-4330-2439-08da4853aac3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 07:02:21.4028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXaR/W1Ez2OBCb1KmN4ol6zsTM+i790RMu2uabbB5pKQdbPoNZhNcLfBlc1/vgqLeZ2APU6QUypaFPAF43VgsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2747
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2022/6/7 14:35, Jarkko Sakkinen wrote:
> Considering Zhiquan's series: all the patches have different message ID,
> which puts them into different threads and makes it hard to apply.
> 
> E.g.
> 
> https://lore.kernel.org/linux-sgx/20220525100625.760633-1-zhiquan1.li@intel.com/T/#u
> 
> https://lore.kernel.org/linux-sgx/20220525100730.760815-1-zhiquan1.li@intel.com/T/#u
> 
> Zhiquan: can you send your patch series as a single series? Easiest
> way to do it is to use git send-email. Right now the series broken.

Thanks for the heads up.

I was not aware of the patch series are broken on https://lore.kernel.org/.
I do use git send-email, there must be some settings are wrong,
let me check my git config.
Sorry for the inconvenience.

Best Regards,
Zhiquan

> 
> BR, Jarkko
