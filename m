Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27569ECAAD1
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Sep 2022 09:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiIAJ0A (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Sep 2022 05:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiIAJZ6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 1 Sep 2022 05:25:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC76D7E
        for <linux-sgx@vger.kernel.org>; Thu,  1 Sep 2022 02:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662024358; x=1693560358;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ieFEfUBWIRyHtIPM2ZHmjSyp71KgrWkIdwaDr35Ej+w=;
  b=gPnAoX8drwGlqMAim+D6JT9E+qXzeGkEUl2+hHbeLLDFedzR1y+33GyF
   Rj8R5yo/F015op6TzjhctaIICVH2RV872/GQMrauzoKyuCh65xQVHNgui
   M2miJe6mm7yvsr+91fo62vlV9g21pSsi4J5aegb+DXjGRoaa4LxuQ0PeU
   9nZpdEANXnj7kSn2esTeVusxsAV3Q+kdefX6gBT7ztAUM7MJII9jxznk+
   01nxm3+WnI5SOtIKV4LMOQQyvWPWypKpC1mW99qbAdUbMr6fE8+3SCuur
   tKlYbqvIKkmVgfPoKdhytQg03UrfeNv6AWRwQeSFjV3CS3TTvDQte0wtf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="278684399"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="278684399"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 02:25:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="738429319"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 01 Sep 2022 02:25:24 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 02:25:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 02:25:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 02:25:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ya/KiFrap5J5qvGGgaLM3i90JFJ4grWOo6DbsqWf58XJOe2rZgu0/no7r5i4RczVisqcyb4vMu7DrmMqqNqFT5Hl/zC8UyfYC6wvU3yaJb+xlF0obcXtcKz1nJzQ0bQgCQt7Hjg0fKTSScBHxd+4mdfZ7BjB7KBqYdbk4qluJWXe27hYHERnS5BXv34ydwYIEzoU15IciAwjPIMIvj8nnTAyWpZmKMt8jjDBGMXLW4defB40BSTXkUnhAbOyGal3FrRDWibpDujcW6BAUDVOaPwnXuP91qM9RkJ2iY09+vtPKUhdC+C6ekUw9stAlkjAvkAP1bgM6oEUS+BT14yRog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UI6wW/Uru9nW0dcx+W2c/U7QcoUu7Ce2e4H2Sxr+zxA=;
 b=mg7/kHb30QsWeVJO92YjflHf+/mgkaDb0qSf53fCS8uA/l0VcQA85Ep1sj/v3d00CF5dSBjdaAHPKH7c177On9fucp9bMrpfSb5N7iX1PiyGQB/ovuA+IkN+2mxk+FcwtjhKa1iaVMB9v8llPistiWfOsyIxHiQflgDLVPESkNt7Co/tTaCylLGWlnavfAC/gJecKnsFHTCEPQVYWHJVai/HWBguxEhYzkUTqSKhuE1X9udMVj91x/Qf66HToemV1KoKNRvLrIAi9BgdA0lnsS6EfKuJEMPm0pSb27mD6n2RqR+qMeJaKkhZvVY4xw44KnC9AnQJxTUY/WAFCiqqrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CH2PR11MB4246.namprd11.prod.outlook.com (2603:10b6:610:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 09:25:21 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed%4]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 09:25:21 +0000
Message-ID: <bcbc1b4c-3db4-c9c8-01f3-d89849b40ff5@intel.com>
Date:   Thu, 1 Sep 2022 17:30:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v7 1/3] x86/sgx: Rename the owner field of struct
 sgx_epc_page as encl_owner
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
References: <20220901003601.2048563-1-zhiquan1.li@intel.com>
 <20220901003601.2048563-2-zhiquan1.li@intel.com>
 <7d222818eabcecc1376c616f8f2fcbb89f0df70e.camel@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <7d222818eabcecc1376c616f8f2fcbb89f0df70e.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0129.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::33) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53b5fb15-4023-4aec-1359-08da8bfbe489
X-MS-TrafficTypeDiagnostic: CH2PR11MB4246:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Ftz5Z4G/CmEsqx3m80w8/lR93U/PgLB3BwTypG+KLV7N0XfwAm0NOLzY8iWc/YQOx+X4xcbinnq+GpBoHDBmc5bSXcdqERZVlWYbo9Elc+EUGnobZs4iUqNnYfT1Ck8f77oeNJZjF7wFKWa091RMzWFBIFxZQ5ewRn8eEWJEqCwmAOuqsgzHn/yG1/eL5QOgfovXbEvWWfOTAohZAw8voV/a+tFX4SP+GnLFL6Z989+tRfrJDATF33ZP4lcWtYK5oPdeG0fCPZR02u7pB0zyT2vuY6JzzyLWwVHKg9gMUnDKt6XTkrydpPFPl/h/fO4vrIvBhiNfkONKlxlpyiQxM+H54y1eslizDFWcsbpB7bE9LtGugobDjG5iL9cLz1X31RyNHgCvQqgYG0/6aNDqp2t7V0Q0PQT4c3T6RMyho/VoRQ++5F8Fbn8g1Rp1UnrnPkQlGMBm6cVNbbax9qa2roiSTdZudqkdkmioZvxq5Asy5hh6OVvcBpa01tgjZKY2X1Uq+uDIfYJZ+rmcnp145t15FvRSDVhUM1/q+5RgVIri0Q5pFolnB8Sg0NS7Bc9TCV4nUyNBxOlrS15XykcRFTQZLgLaY5hwDX6F5hJN5uIWmR5wOv3fQOw80gujPg0xr5u/fJ3iEiliLXKjAmI3eD4eR3zC4WZ/XbsFKgBH9GQp0OW9sQFoRX0IOTG4O5u2CHg30HCfNNJD8dos4EM5UJhBc/k/jt9XVY7LWoSCFQVXd4mLEJlOQevilHXwZwiLYgLEZcuaJqRg2jRvliF8Cl1g68FVhei7lJj6hb3jXb5oaig/4eLYTnIOVqlFFHPrhFZFNCPr2XdB2JEX3sL6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(39860400002)(136003)(346002)(31696002)(66946007)(54906003)(66476007)(4326008)(966005)(110136005)(66556008)(316002)(8676002)(6486002)(8936002)(86362001)(478600001)(5660300002)(82960400001)(31686004)(36756003)(41300700001)(6506007)(2616005)(6512007)(53546011)(26005)(6666004)(38100700002)(2906002)(83380400001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEVXWHQ2c2lobXdsUnROSGltaXBHM0liWmZxL2VuQ3hDUStYVEp2a1JYTWlp?=
 =?utf-8?B?bnNKZVd2L2thZWJDeDJqQ2trQXE0VEVIV0puRG1uSE1YY0VzSmF3TWZPaGZR?=
 =?utf-8?B?cWlVaHpMamRpUDlpZ1hMazRDWWJLQWxURnVnSVVzRlcxcTNPaXJmc0hXSDNO?=
 =?utf-8?B?TzlENlYrUVBCRVBHaWEzUGkrODlNRGE0MTNtM3BmVCs1aE5uNW1VT2hBK3Rw?=
 =?utf-8?B?dWV0RDFaZllick9Kb21zQzI1UHV6UXg4dllRT1Nxc2MrZjRHWFBkREprOW9k?=
 =?utf-8?B?bUVCY0d4YnhsdE5VYjllNHRlay9VTlFCU29XRjZEOGNTRmFMOFpxMHovUlMw?=
 =?utf-8?B?MitFdmNva01ZVDR1TlM5UXkyYURlOUY2RHUwWklaWHd4WmJZaWNmdzBPYllm?=
 =?utf-8?B?NHBHTy92TDlZNVNGcHFRK0tpNlVXcjNyK2dJaGNDcmJnQWFPemFSNUpmQlBY?=
 =?utf-8?B?NUJqeDQvTGlCSWZpdTE0VGFVc3hGdGhnRG9LOWNvb2tWU2lQaHRkcUpXSVo5?=
 =?utf-8?B?Zm1QRnlxcFFWaCs4N2NxbStNTFdaRENKTVNkSzJaZnBmUWt2aGIva0ljMzdD?=
 =?utf-8?B?M1RTYkJoOUs2Y3Y3REJpSGJLRnhaOHphRlMyNUQ5aWN0anp5UjR4K1pKcGM4?=
 =?utf-8?B?K0U4SzJvaElSMHErQ01iYTJHT0RkQmJQa1dWZE15ZkNnbEFXMk9UWktyWlJ3?=
 =?utf-8?B?SnltY2tQOWJ3Ri9XYTZIdWl1eDIyV3lZaTBHUFR1RDBIdzBLQWtGNUIxaDVT?=
 =?utf-8?B?U3I0VDF5SjArZUtOdlNwZzF0TnM2SXBpODhWTUQvMFFTT0NKRGVuN05sRDQw?=
 =?utf-8?B?WDNIQzRpdkhEZndDMjFDR2lOSWkycjdFdkZQTVFYNHZVcFVOaFQ3cjZFWVhI?=
 =?utf-8?B?TEtHQUVpczBRZ1pKczBIVGxSenFJVXlGRk56bUVLWXo5dHBqc3BnbW5GRXhI?=
 =?utf-8?B?RkFvcytScUY1RDczK3V4NTlQQ3BSSlpHZkcwZHROVWR2WkNnT01sS2paU25P?=
 =?utf-8?B?Rmdod2lzMEZ5U3NNLy9wK1Z1ekRjMWc5SVovaGxtVE9HZzBTWWovRUxOZENH?=
 =?utf-8?B?L0NiSkhOSjZ5QWFDOElSNEJmR1FUZXEwVHBiWUduMjgyaDBRUnlHOTRtNUxr?=
 =?utf-8?B?SXRRYWtCdnZmdDZLYXhuN3dERFdUV0NCQldyWEM0R2JHUmI3bHhsaFdDbEoy?=
 =?utf-8?B?aE9RbjF4UklxeGpIeitNQ3Q5MlpydlN6MWJ1UnF6RlVrQlBYQ1VnQWdud3VC?=
 =?utf-8?B?RmNoSEdKbElHTEFYaGU1ZTdRSVlhMHRlSkhqaWpwc29CVkRYK0VQTjRRZzBy?=
 =?utf-8?B?UU1lazB4K29RRU1qWDhFQXlPZlhBMkg4cmh5QmZYMWZOMHpoaFBwdGlEQ1h4?=
 =?utf-8?B?Yi9pOUkyK0tya0MzNFNiWTJ5SEFtVTV1VnpWaDJYdDZhRHZ6cVVjTno2bS9s?=
 =?utf-8?B?cUpYeXpuVVFhQVQ3TXZKcytBUk9kSW9GYU5ud1IrVmRnRUxvRUVXZUdScmpn?=
 =?utf-8?B?cDZMQ2lEYXJqZmM3SUxIWUhrbTZqVHlrWWg3UWw5eUR2TGJBZlc1VVNidFY3?=
 =?utf-8?B?NmpnVS92RWZ5UDlQTWtXa2IwTk9NbXd4cVBHU1Z3eHhIUEtLektiS3RjelBm?=
 =?utf-8?B?cWlOT0wxNE1nSjNlK3RkWE1rTjdDekFMcUZ3UkZFL0lSaFc5YmVrWkpBczFF?=
 =?utf-8?B?MGdFRzd2YmxjNEYzUzl0anVZUWVpZkw1R2UreGs4TGNaWmRma1FHN3NXYXFG?=
 =?utf-8?B?Y1F0Uk5Ga2hqb1B5MkdDdDk4cENwa2pUSmhCbEhHTmdNT1hsRkVZQ0REa0tX?=
 =?utf-8?B?alNVZlZlcEpzSnduNDNSck5nNmE1dHJmME1NM2p5SGs0aFNib1VQZG4rQmw0?=
 =?utf-8?B?SVlGVmFKRnRQOXdrWFVzVFdXN1NIV1ExcGRtdk5TeWZ1QVpkekFzL2FmdjE3?=
 =?utf-8?B?bFZCdkJscTV6dm44RGtXa002VEZXL0l3S2xTc1czODFJU3RwblhVYytuSDN1?=
 =?utf-8?B?MDVITXlzTVhxa1NnSXFQbUpJeGFaaTVVYjNVeXNydXB6UW04WFFRVW5wSGRv?=
 =?utf-8?B?aGFodHJpMFdIWTl1ZjdPNkJlNUs2VUZOU05WdmhYU1l4K0N4Q1llTjRoaVJ2?=
 =?utf-8?Q?zVgZyWErvZwwMHjLu9rKL21Xg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b5fb15-4023-4aec-1359-08da8bfbe489
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 09:25:21.5149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQKWkyWpZ7AswR4XUtjG8M6cCsmpFPmK+6ccXiv07A0Jer6jsSecVk9G1lHgYFjB1szFtouaKMlS7teI4+zvpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4246
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/9/1 11:36, Huang, Kai wrote:
> On Thu, 2022-09-01 at 08:35 +0800, Zhiquan Li wrote:
>> In order to avoid unnecessary casting, rename the 'owner' field of
>> struct sgx_epc_page as 'encl_owner', and update all of references.
> This changelog itself doesn't explain _why_ renaming 'owner' to 'encl_owner' can
> avoid the explicit casting.  In fact, the reason is that you will use a 'union'
> to separate the use of 'owner' of the EPC page (between SGX driver and virtual
> EPC).  The rename is just to make the name more clear, but cannot really avoid
> casting.
> 
> So I think there should be more sentences to explain here, such as "in order to
> send SIGBUS to userspace hypervisor to allow it to inject #MC to guest, use
> virtual EPC page's owner to be the userspace virtual address of the EPC page",
> and after those you can say something like "in order to avoid casting, use a
> union to separate the use of owner for SGX driver EPC page and virtual EPC page.
> And rename owner of SGX driver EPC page to 'encl_owner' to be more specific",
> etc.
> 
> That being said, I guess you can just merge this patch with your second patch,
> which actually introduces the 'union' and uses the owner for virtual EPC page.
> And in changelog you explain everything above to justify the patch.
> 
> Does this make sense?

Thanks for your review and sentences, Kai!

Hi Jarkko,

Do you agree Kai's proposal? That is, merging patch 01 (just rename, no
functional changes) and patch 02 (introduce a union and utilize the
'vepc_vaddr' field) into one.

- If yes, I'll do it like Kai said.
- If not, I'll just enrich the commit message of patch 01 and keep it
separately.

Best Regards,
Zhiquan

> 
>> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
>>
>> ---
>> Changes since V6:
>> - Revise the commit message suggested by Jarkko.
>>   Link: https://lore.kernel.org/linux-sgx/20220826160503.1576966-1-zhiquan1.li@intel.com/T/#mb201506ed06932438c82d48915cd4ceae9745bc2
>> ---
