Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EE4C12002
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Jul 2021 21:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A73B613D6
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Jul 2021 21:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhGNVYk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:24:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:57845 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230297AbhGNVYk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 14 Jul 2021 17:24:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10045"; a="232252371"
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="232252371"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 14:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="430569328"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 14 Jul 2021 14:21:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 14:21:47 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 14:21:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 14 Jul 2021 14:21:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 14 Jul 2021 14:21:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFwwHkOBuUMFEsLS+UKJqUWcI1KbMAtBXCODeocRZUvE0TyqY2f1whHLtZidXoKElvIsT1A3KmxQv6ejaR7qo4Sbr7IuD+7/VFGyx0heupShYObypowWKh63hIjBaSubumsI0mTfGPZ2R1t1+XE2CvE6miw/EmzJZa+6k4ZvFHNo2D27Y4ZPvXjeroAtcy4yxiPe2KjRVkxpDVmTtQ0ecZF+2x1EEe9obt48EFNhWkZ8/lmD6Ce+82789AedNqM1qpUOtJlDEXcsTYn0SbE9kbhSYYMg/yd3jZb3z86JSatBh69vGi5bzD/RQDFbPMoseLpmIIJmGrTOiWejdWImRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7el5C9HHDN3kvo2QJ8Hz9uBvqcBHEdBlX6TTWPgrDE=;
 b=Y+OlDQh/nqCdsgm8miw5klS7ZqZKN9/mZkva9UGJAFRc76UqX8Va6OpfTCN6C630OA3kST1sVUfrLc1d4vtMQvjmOEWEXo7MWO4mmIHn+pqMqdKAz68n1InNCxEKDl4gU597/YVmtLS+Okl9PGAI1kLMyxHa06SpKYZhgChh7/rQOt+Cqf+l3xrhOP8Cx37QaAZ5HskuwyjJWrrJA4wWSRE0BVYtTBOuh2/qUxWQDX7bESmyhdMunmNqJTltoiRjbOmNE/WydU+o5GDhlWlzMycRRvIT0ZhNE3zLzHiV45rh2aKrCaVrzpTh1rC/R7+UhphJHBWH1YDS0Y+3CNgOtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7el5C9HHDN3kvo2QJ8Hz9uBvqcBHEdBlX6TTWPgrDE=;
 b=ko77qYyfthK8SZ3O/HmMXHje47zaM3lXzpjCv2ePqgXeHdi1lObbPzjUMHzYhc0kUFW8/bUmcdLByOgIlf42TxGJ4Yl66+7o4SLPBXXPdRsRHVL6oOxYfpeZCKzGrGa5b75U4QwMZpQcB0Q/a8SRhDuuPJcrQvZQH+QOOoSGMvk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN6PR1101MB2113.namprd11.prod.outlook.com (2603:10b6:405:51::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.24; Wed, 14 Jul
 2021 21:21:43 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::202f:e602:3983:e631]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::202f:e602:3983:e631%8]) with mapi id 15.20.4331.022; Wed, 14 Jul 2021
 21:21:42 +0000
Subject: Re: [PATCH 1/4] x86/sgx: Track phase and type of SGX EPC pages
To:     "Luck, Tony" <tony.luck@intel.com>
CC:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210708181423.1312359-1-tony.luck@intel.com>
 <20210708181423.1312359-2-tony.luck@intel.com>
 <93845f78-120d-7522-bd3e-fe042380d29e@intel.com>
 <31668f36583844cbbae0b10a594193d6@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <00114991-9075-84f4-797d-f0f953d34660@intel.com>
Date:   Wed, 14 Jul 2021 14:21:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
In-Reply-To: <31668f36583844cbbae0b10a594193d6@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.219] (71.238.111.198) by BYAPR08CA0067.namprd08.prod.outlook.com (2603:10b6:a03:117::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 21:21:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc271489-d0a4-446e-fc90-08d9470d6073
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2113:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2113E85D35801ECA7D917501F8139@BN6PR1101MB2113.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KS+Pb2FfC4xcXNgRmDz8bLxrXaTQhYzsZG6Q7R/VmwFLNENoK3sNrSDqa4DaYzpzcTAXOcarBrRXFgJKZVypmnSfj9K7JJZGpTc8pAGmBWS1Xtfku3pIjd2Ps/4LsJg78ofRQQ/V+knwO5RPfTO2upRq0p0AWzQHsWEjiejTHOm+ZsZ/z6rUh+urh4qPP6hdNUz/cGBhzTvLdgGXk46Y/TC9PRUht5GKDerq3uhHU4+xgSIzKnJNGAbGxGbtvLQ+Jj/UHyFzolJ3IibpWjQMNO0nVHAwUvc5YRo9eOhe0XAcmJ9smduQht0OpvsQfViuXbi/JYm10Th8nN1vQoBoj6oGwInUK36yGobU6/0JhmpDZlZw3MOU3guLap37ldGdtbpO2hnyMumgji5KKX/jnI34yoeMVnEL9L+uOjFJihr6xYq8buW3Pj4n3DCG0trA3gPF4kXB604Q5NP+0lSScUyvjFdQ2r4hUcSmD0C0TGK0Fu8n+I222q4CaOhTiLphSzpR5JgKkfFrmyhl2awBXAdlncrOpG/keXzIX5oWnL+tRBEvl8fErllxz9Vtb39M0cKpHo2A+LbfpGFYEPGD+kyrvznnCZD6nKlFMO9CqLXbNheQCOsIT3Rfp1YQRGR6shwztE4PVT7w629YMZ5016hM6WjfY7Uo8ghljF9wRcPgd+bZ0g/fktFxB/DX6ZkWK2Cc4T83PCxfIqYeeEEGgBp/joRiba9H2pVXFhUszFWTFI1KY9807DmnsGvTREholSVX+v8lOQ7iDrXJXHnJZE85yTrebXB/brAeUr9C7yn5DwNvELuLGr2ynAPi3UCy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(31686004)(26005)(6636002)(5660300002)(8936002)(4326008)(956004)(31696002)(44832011)(86362001)(8676002)(6862004)(2616005)(83380400001)(37006003)(2906002)(478600001)(316002)(66556008)(16576012)(36756003)(66476007)(966005)(6486002)(53546011)(66946007)(54906003)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnR4dEpBZ3BZcm8wTDEwcnR5WmRWTDFoZ3VlbGk5KzlFZ1RWSkhsUVdtdXll?=
 =?utf-8?B?K2hXTitwMzFTYkp5U1ZlMUgvV3lKclJOY1Rxd2ZBa09oQTdwMTE0TkNuZE9O?=
 =?utf-8?B?L1NhZUliUDYxUEhyZmJuaVM1VW9iSWlWLzFQeWNNeFZSUTRWTGtSSFc0eVNw?=
 =?utf-8?B?MHdYcS8wdTR4Y1FGQ1l0NVdENFpNeDFybkhrSGFMa0VnYk5hdllFQW1VMHA4?=
 =?utf-8?B?WTl2YkFnMTJQbStpOS8rK3BiYzVMY2hlY2lrMXVBTW9vTnMwN1c5a2luRzBP?=
 =?utf-8?B?Q0ppVDNRbU8yOE9RdlNLTXpNQ0thMGE3UWs2djM0Y3d5UHFVZWNQS1J3R3E3?=
 =?utf-8?B?QnlHMGNCSnIxajVya3dXa1RGTzgrUG1XUnB5eHFyNXVYenB2cnBRVHRHQ0xy?=
 =?utf-8?B?TnpRdXlxRk04WVFKTHJhYU5YUVkzYnBPcDFxdzJVL0JPaWppb29HWnFnR0V6?=
 =?utf-8?B?TFNpSDdwWmhNVFA5a3MycGk5NzZsN3hEc2hnTDR2elJRaHJsU1prdmlTVy9G?=
 =?utf-8?B?Q2g3MEIrYmNXZmZKQ1l2OXVNQVVUaEc4K1F1ZGw3TytZV2g0ZHZTZGx0OHRp?=
 =?utf-8?B?d2I2TGcweGpVK1lZVldMUWN4K2FGYldMVDFzR1Y1cDkwb0RDWHdhRW1WN2Q5?=
 =?utf-8?B?R0FkUlpmZFc2SHc4TXFMVVpweGZxWVo3emp2a01tcC95Y21HWG81ejk2QUhM?=
 =?utf-8?B?VDBsQ1ZaQ01rWHh2eTRGekpLeXg3RU9ER1RIbDllUVJzYk84OTJBMGNGSmlw?=
 =?utf-8?B?djRiYmFvNEc1aExOTW5taW5YbURNenNZdGdSc1NaOEtQZzFyS0dpOXdHU21n?=
 =?utf-8?B?VDZsM2RCU0QxWDlmeWdwWS8vdnBETUV1eHFuNkhUL3dHaWdrSFZ1L3ZPME1W?=
 =?utf-8?B?OHA0TFpCamRXRlVrN08xQzlGWHhKNjdKclFWWnk1U0E4RHEveVdpN25ianAx?=
 =?utf-8?B?MmEvbGlScmdLUnVQMWxYdDRXc3I4QWxpNnBPOEVmTWJROXVpR0NobEUra0hq?=
 =?utf-8?B?eXRsSnhrdFd0RE9SWURaT3RNWVZVYU9LcGxSQkZBTzd5NHgwYnFvS2Y2c0RR?=
 =?utf-8?B?KzhMdC9SMTFWTFdCOGUvNXFPNFpvaDIrLzdFVEtKSFg3ZmYrdFBrcXNkeEhK?=
 =?utf-8?B?R3kzV25FeEdDSDM0NUZVMTVrZXRjR0FMK0wxTm43RXdLQWE2SnM5djM0djc2?=
 =?utf-8?B?WCtzZTdOZk5LMXBGYTdQaFNqenVOM0g5UmhObmpaYU05NGNKNnN1VUhySUV3?=
 =?utf-8?B?aVUreVhlalh3dkxqUXI5RjhTWDdsR2xxSFBwSmR6SGZyS05ZaVN0ZFM3V3Fk?=
 =?utf-8?B?NnExckl2TkRraDBpTUlhTDhDMndVQVRSOTl4SjRkRkZVZHU2ZWZuVUJrWWhr?=
 =?utf-8?B?RXIvamtIL1ovSjl4Wmo1WlRUMFRJejY1V00za1pVYzBNUHZaelVWM0tvSW02?=
 =?utf-8?B?a2E1cmN4UzhFYzVtOEJSRHdMYlM4WUdOZTNZUXVPc2xaZitSSW1zdmZJQ1Z0?=
 =?utf-8?B?bUVDRTBCaWRSTkJwbUp2UHpUQ1dXY2dUbDkxVkU2TGNEa3Vac2kwQWJiUGgy?=
 =?utf-8?B?eEZPRitOSENjYVV2bm93L3htYktwVTV0UVJzdFB3Y0p5c2F4Tnhid0RkTGJq?=
 =?utf-8?B?ZVM1OFI1Ui9rSU4zT2c5aFBSSmk5bU4zRS9HM1EySTkzQUFQRTNISlYvbERu?=
 =?utf-8?B?SjFKZWpMY3FsbjdrNjlUS2VwVUdBdHNFVGhuRFBYRmRFSlgrN1BxYnVkdm5a?=
 =?utf-8?Q?ou7Y/RUCDB0KfYSL7D65MWKxg1ug8VtDegVZW84?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc271489-d0a4-446e-fc90-08d9470d6073
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 21:21:42.9649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NldLi5AyOIJiYqgNCk77nMkUlF4Xwc5Ag2rvaozxZly9EmaFqx6dCdFd4IXJOEg1AGqa1Xu+/kcSCwthlUpYJ64zi8RWcneLpqyRb21UFz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2113
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Tony,

On 7/14/2021 1:59 PM, Luck, Tony wrote:
>> Could this tracking be done at the enclave page (struct sgx_encl_page)
>> instead?
> 
> In principle yes. Though Sean has some issues with me tracking types
> at all.

For the SGX2 work knowing the page types are useful. Some instructions 
only work on certain page types and knowing beforehand whether an 
instruction could work helps to avoid dealing with the errors when it 
does not work.

>> The enclave page's EPC page information is not available when
>> the page is in swap and it would be useful to know the page type without
>> loading the page from swap. The information would continue to be
>> accessible from struct epc_page via the owner pointer that may make some
>> of the changes easier since it would not be needed to pass the page type
>> around so much and thus possibly address the SECS page issue that Sean
>> pointed out in
>> https://lore.kernel.org/lkml/YO3FuBupQTKYaKBf@google.com/
> 
> I think I noticed that the "owner" pointer in sgx_encl_page doesn't point
> back to the epc_page for all types of SGX pages. So some additional
> changes would be needed. I'm not at all sure why this is different (or
> what use the non-REG pages use "owner" for.

This may be VA pages? struct sgx_va_page also contains a pointer to an 
EPC page. I did not consider that for this case. Perhaps these could be 
identified uniquely.

Reinette
