Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A22AC43334
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jun 2022 09:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbiFHJM4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiFHJKx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Jun 2022 05:10:53 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4547681984
        for <linux-sgx@vger.kernel.org>; Wed,  8 Jun 2022 01:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654677175; x=1686213175;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fBC3KeAwhT7amFClHt980zMcnlBqL5KuR4p8jKLL76M=;
  b=IsIFb2gEYYIZxWJkYEzeVQ6V+S/sSFRVN4yPk0MCDbP3ZYR4WBE2HIvZ
   Xs8KZ5XQkOQU2bCHnxMRADgHUOMZ1kkqqABEyJaPgvdbP7gmSb/rFRZU1
   UL5+kZRUAIcnPOqgj6yYCVghbUc9sG7dU7pHcRKRAddG1+hGvRNHayCpG
   CMRoelzLwaHqZ2ZS/D2v3rvUxH+ESPiZCYvPX90FnD6VkMDjviVZX2pM9
   bWs5c96pHRK9yN5B4xYW6axZRLrka2JzloE5K0T71UoEWH1/sEkmU+fnK
   dk4Dn1ZmdMAtpPIcuxmOpbbr+Trx4wBh+snAKC1zBfj7+g6W7NMajR07h
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="275580211"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="275580211"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 01:32:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="683208558"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jun 2022 01:32:54 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 01:32:54 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 01:32:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 01:32:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 01:32:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5BmAMM8VBq4XQF0BhRqBzeODPI/27rPJvCXK3Nfv78kSdcUL/btZoza7MR88PbVnzQkx85BdEgvzPthmQpc4xtyolNNXFtY1ONCgW4y3GfT2BuJZQddwqQaz8VBYf1UuxOoWanFg9c/mT/T5LgZzk8cphFO+VMgfCvdIF8ZDBrZkjVVmmho7O3hbn7HEiLYTDhaIemdDcz5S7jG6SMmhOd8rLRE4muKzjYBhVlzkcbziuonz0osTaHJJcAX9cN61OGhcP4Mha3E4mq8hdEacxoU4pZNlt94nOLJK7GYTob7QAQzDLrey6PMd6mLNCPPxm5Mt7TC3lRjk+i5r0xNpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOCPYfscEFAMHw7fnpdQHPrHjLjk0taVbw3JbNZQpoo=;
 b=B9X2KLlkZ3buAzAUuX0xLRn4LaYJWmxNTSPIZDi6USLvxW7NHE/las253GprdAVPQtG4c4p8q/VwLNrelNmrGP+7xaPrDotG3rIaZEkLLDqSW2iH7jD70UVgykdjAkz7Y5jIiTyM/VoUw7p/VnsI7FU+YElJ3tVLHReK+serNK1odV9cEwL/JYG3fC5jxkZ+rFljO3Z5LKVS4l6569rg6KF+0w8QFbFJcojWBqqQipfKf7IFJF7xSCIWMxwf3mUXi8Fke2kNaKXWY9t23OyC5snUkNDvGn3kX67PRmjR5lcAxzfI/MzOXeMo/BKfLpNaZ9jMw13/pGC/1lYla8vK4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by BN6PR11MB3874.namprd11.prod.outlook.com (2603:10b6:405:81::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Wed, 8 Jun
 2022 08:32:52 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::a988:feb4:e85b:3f73]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::a988:feb4:e85b:3f73%7]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 08:32:52 +0000
Message-ID: <345c0f66-910d-b97b-3c2d-7f56b69003ca@intel.com>
Date:   Wed, 8 Jun 2022 16:33:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 2/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Kai Huang <kai.huang@intel.com>
CC:     <linux-sgx@vger.kernel.org>, <tony.luck@intel.com>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <fan.du@intel.com>, <cathy.zhang@intel.com>
References: <20220608032654.1764936-1-zhiquan1.li@intel.com>
 <20220608032654.1764936-3-zhiquan1.li@intel.com>
 <4d0ff55937942835d45d629e4f53597a4b893c0a.camel@intel.com>
 <YqBaIXHTnleGcEJB@iki.fi>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <YqBaIXHTnleGcEJB@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0026.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::13)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84c9a8a3-92e3-4039-23c7-08da49297a0c
X-MS-TrafficTypeDiagnostic: BN6PR11MB3874:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB3874137B3B49AE07C27EB120A5A49@BN6PR11MB3874.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GOfGLOk112yWbB0W6nxO9xiMx3E9SmrlWES4PlBE6sLZiTvbU7IGYrdBpyU7vp6s2mnL6S2dhfSFa4oGe2Wv4rjOCG9Ta94Xk4uuADHK9Y2k0w7QyOA9nEnPN3ZhUfl1E99N6HC7hN+DAqG3mqWS4JvR8mRYZRQd8Vy+PWu+4CKmjZfRpJsmBFR3PJ3raJ3brPewT1QzgteBu5wrBRO0dQfmNqZejOC0HJ1dY5us1DxJ/rLZjcJYDm6vCqCnRiBFMrRVy0hNqUILOntUZxTGjrCQSk1+HhNagejwQc5H1TyFXnLJ61fxUVrmB3CPw1r5PoY4d4VucJofgzC+jfsmlzAUG0isUjhQbJPDuJ9/lEUdnD4fexCjgRQk308M4gvL5lTX1q9kzx4CHtMqzvk/xlxGkR8B2bBx82CW45E6f7j++rkCyLQ1zqilBr7gS+1lUQpuqZwzYI7Sz2b36d2f6ZlL6/k2GyOjbS1NKhY136v5VQXapP3zINOnXDsqOZDGFTb6VYkPMBrTGoh5aHkNr4etqtdAWHFHf4KH36QMJGKQT/jQXHnU1ddF7ICPXS2gVghdLwZwt0wQVgyUhce8BFttihM/aXO8vMNJeYmcRnr/LSClek6FhpvDsbQdtBj4D4GRKd7+pt99eYj+YZ179eej0FBTHGhQTuqeB6DwBIg3QvC7OGJ9GIPjZ1/ZieFh3WcFTI3qoTtgOVsO1xyoS1ikzbt+37yBxdmpWeMM4FA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(82960400001)(2906002)(508600001)(36756003)(110136005)(6636002)(186003)(83380400001)(5660300002)(6486002)(31696002)(316002)(31686004)(2616005)(4326008)(6666004)(38100700002)(4744005)(26005)(6506007)(53546011)(6512007)(8676002)(66556008)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUFnd3NQVWxJN0JGNzJ5Mlc4UmdnUGE3Kzhnb1ZSRGFRRUpKWjRxVGJyQVE4?=
 =?utf-8?B?WnovOVIxNjduR3hQSCtYcS81MTFKWXlDMkVRaFBGZU4zWm85Umo3cllGQXFP?=
 =?utf-8?B?emJVdTlVamNVMGs2aUU0YlJFcDhRUlJ0eFdGYm5ya0k2bTZwOEM4ZlhNR0Rz?=
 =?utf-8?B?dXhPOVdEZzR2cU9MZnZpMUNtZU9aZmw2bnNBN1VxV2dIRDh4Vk4ydmdUTHlo?=
 =?utf-8?B?RU14ZU8rcmRXbVdYNWx6SkQ0VjhQQktXaGVPMkxtOTFsZGE0RXRhb0tQUEhk?=
 =?utf-8?B?cEJUV1lqbFZtY1lmVzZ1OWtDK0FuZGRabExuWDg2dDVRMTQ2SWw2eVA3ZTFR?=
 =?utf-8?B?YUNJbm1zTGNUUnZwaTR1UXptT1JuWjdlaEhkd2FrS1plL0xHZm5oWm5rcGxZ?=
 =?utf-8?B?cFF1ZUN4QlUvMjl5SytkYlVFYzAxQ0R4eHpwNUZNanRIaUhEckFpT1VMWUFy?=
 =?utf-8?B?bDRoNXdsYzE1d2lTMDdlbkJzQks1elJ0WEQvdjVTLytDTWpqYmxPOU9HdDR3?=
 =?utf-8?B?azJNaUJLUlU2UC83MVQ0VzRVbHdRRE1UWVhNZUFjcElWV3BzNXMwMTJyZVZt?=
 =?utf-8?B?bDBoemo0NHpuUXlsS3k0UXNqMUxCajl1ZjRwbGg0OHdzOWNGUzBUaDdKQXZL?=
 =?utf-8?B?TDYzMFJvS2pQRnBCZXV2SzJ2SlZmYlZXN2xYZ0p6YWVaa2lhOS9XTE9ETVVs?=
 =?utf-8?B?aWtKYlNzTHE4bVZ3Q2hBcGg1Wlh1bGg1YXVQQ0RwRGFrNktrWkxwcStGT293?=
 =?utf-8?B?L2ExUnA0Z2lyOXBoSG54YTJxQjJZa3krZFU2cUFVZmdReStZT2x1aWlScHFC?=
 =?utf-8?B?bUxOQVJQQ0hlTnFiWEM1enp6dFVaYmFyRU9KV2wwTG1DOHR6UnVDN1ZGdWhu?=
 =?utf-8?B?cGlRamFZMXVZMk01KzRmOXpCVzAxTlB1WlBSTnpkT2FjbGprVEpBY1VKSWwr?=
 =?utf-8?B?UThDZmMzVzdNeEZaNjVadVJzbVBWd1NoemJLVU5DOEg0dnZ3S2NyZVBySlVZ?=
 =?utf-8?B?bW1adFRUNTFrYlpvOUdJbjZIOUVpdGlrcFNjbEhINU54elhZTk56N3dya09x?=
 =?utf-8?B?QTZUTVY3Sy8yajdGVEk1RWg5eW5ld3JZYTRKOE1vK1ppdWpZczBRMElVellZ?=
 =?utf-8?B?U1lZL0pSS1UxVG9yK0NzeUw2NW9rTjZWL1hiTmlQRHlYbTMraGlaM3czN2Rt?=
 =?utf-8?B?WVJGZnlwbXF2LytRaHNMWXl0aUxKMGo5ZFRIZ1FFbEthTHhRclUyUWovamE3?=
 =?utf-8?B?VEppeFVpb0VUTzNyREFZcThzU3JKdEFTcUJ6NGQydlI2aEhZaU8xTWhIZE5Q?=
 =?utf-8?B?MzJvN2thUjBXbmdOS2lBOUZ1aVlsRGdlMkNrVGtmby95WWNZYnpBeWFoc09E?=
 =?utf-8?B?QytjcWZ1SWgvVWtzVklSd2VaZ2svVXkwTkZuWGxwRTltSXg4SHB5S1hlYk5L?=
 =?utf-8?B?b0hocGE5S0ZhK0pjajM0ZkcwNW93aE9YdUlPc0svTTQ1THRYYWZ3TFZMQ3Bz?=
 =?utf-8?B?ZkpXSUNLTlpBaktlbVd3Vm1YTWRBMVFxaDg3bnlpR09mM3dUQTl2T0NrdW1V?=
 =?utf-8?B?SUp3MHRVanp3Mjk5QXZ1eWlmNE0wemNuVldseU9BcDVMd2VqVUFpdnVSemR1?=
 =?utf-8?B?VmNMd3FmRlgxdWpyeDJTNE5EZC9MdCtlSVIwSDJMWHpZQXBtUlJxUGh0cDRH?=
 =?utf-8?B?b3d4WGZTVFBOT2tVdEJQeTlqTU1kaU9PaUNwTWk2L2oxbTNnL0VlL1ZZeXZF?=
 =?utf-8?B?Y0lpL01yU0dIbEpKd1NrcVFsQyt2YTFkVGNzbk5DQ1krUmhFc2hkZnBlZ3dZ?=
 =?utf-8?B?R25iSUpFRGp6b3Rwd2JiYnd5SGxtYXVsYTd6bHM4UXBFRi9oWFFkdWZIUGFs?=
 =?utf-8?B?SXhZdmhHOXVFc0dHZDZpQnFic295aHAzSmdsOWNvQW1RZ0YzL0dPa25YdXNn?=
 =?utf-8?B?b3FLNlJsd0hRVUZiVmtWVTdMUFBYNURYQWF2RW05d0pxeG9odXYwQzkvNGU1?=
 =?utf-8?B?aG5hNWdsc1I2Vy9BQ3VtYUlhc1lNamZZWHVoMG9nRWh5RCtBMTRUWmczN2pU?=
 =?utf-8?B?VXNUNGNmQTMwS2tjS085aEhzZm8yMVlrZTJCcDV1SjZqank5cEpYMHBkdHYw?=
 =?utf-8?B?ZndrenJvVXRySmNSN0ptWElUYi81WWVySlJFOE5UcGgzT3NxV3RXREJLRE1s?=
 =?utf-8?B?Q2l5WFA3Q3hSeUg3dXQ3Ny93b2cxZERudk5aczRieGFwc1NVbEx3Q2pFRDli?=
 =?utf-8?B?TlVOeFY1RkhoOW1pKzVSa1Vla0RSdkRSR0R1bHJnVWpwUFNwdy9aVk5mdm9j?=
 =?utf-8?B?c1BLc0FRTTRCN0lFNEdYaG9ncXNlYWRkODlPenpvUmZlU2tENEFhL3VhSUNt?=
 =?utf-8?Q?x1iaLZHtDVhdNjLw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c9a8a3-92e3-4039-23c7-08da49297a0c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 08:32:51.9886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jguTUUk1a0V5LWRfxlaUP4bw4QNQh82oWl/n+QHNB/jCkGjDiktiuHCSyEBr3vqp59ysWztGiK2QKbfvaG7Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3874
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/6/8 16:13, Jarkko Sakkinen wrote:
> On Wed, Jun 08, 2022 at 03:52:46PM +1200, Kai Huang wrote:
>> On Wed, 2022-06-08 at 11:26 +0800, Zhiquan Li wrote:
>>> --- a/arch/x86/kernel/cpu/sgx/main.c
>>> +++ b/arch/x86/kernel/cpu/sgx/main.c
>>> @@ -715,6 +715,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
>>>  	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
>>>  	struct sgx_epc_section *section;
>>>  	struct sgx_numa_node *node;
>>> +	int ret = 0;
>>> +	unsigned long vaddr;
>>
>> Please switch the order of the two variables so all of variables are in reverse
>> Christmas style.
> 
> Yeah, we prefer that. Is it necessary to initialize ret?
> 

No problem, I will switch the order in V5 patch.

I referenced mm/memory-failure.c:kill_proc() to initialize "ret".
Whatever it will be overridden by the return value of force_sig_mceerr(), so it's
not necessary, we can remove it in V5 patch.

Best Regards,
Zhiquan

> BR, Jarkko
