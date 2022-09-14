Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AD4ECAAD8
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Sep 2022 00:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiINAXt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 13 Sep 2022 20:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiINAXs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 13 Sep 2022 20:23:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69C76C11B
        for <linux-sgx@vger.kernel.org>; Tue, 13 Sep 2022 17:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663115027; x=1694651027;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ei/ZTLjRoJKo9cxSHACFbTQWP8XSU7I7ySWrqZ9PTrQ=;
  b=KNUqcMzZASv1XZFXAzdNUV0o48q0atBdT1BwO1YScbDJpCsu9PnD1Q9Q
   qtEOu/Defsznq4XFz1P8PivzraB/4623TqO6dSE+F2JjE4WWwuF4MFqJn
   qTnkyvZIApMYMXkHA4rgLLa42qhejfPlGOTfHuLU/MpoNv2Azft1NO801
   WfJ1On9TslOrI8u3WKOLfmeSohUHaHRRC+fVqfhItgbbvpX9Dadit4SR5
   tOZnkngaVezrpF21odiroK7Fw51qJmcPcndmS6QU24qWy7GogUWyZtdyv
   mce21on8PpOdqumztUriJ4SWfmnUbJWgP8C03AIlf90wgSMRNthqc+2Dw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="295880594"
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="295880594"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 17:23:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="619120889"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 13 Sep 2022 17:23:47 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 13 Sep 2022 17:23:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 13 Sep 2022 17:23:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 13 Sep 2022 17:23:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8xLvFEVxQ+VGItXlFI7sbTlF81mbeNG4gBtMWsHufIeuhXKRZTPgyRv0rSpwfcrJiQFbTN/qopGJbdas/MZILjXkTi6M/UQme1SsLc9UfjVz1+s/7gZxfLM03B0lOGrz/CkmFi88hkj8MSK7APsTXzHUW+qvQFYhPnKBH60T7LYpkY9KvCwmtRGnVc/EJbb/ekesrKtO6fjT6WSlgL/gfkQY6IEYP0tzS6sl5fR4WBiHmqX2kealkjf0YmW9mN/j18Tos9jQDXCLwfDt40Qf487tklgXRQEgNwuu0HEZbkpWLCbAeTAn4hyfWWdaRxRnJxpT9OCKkwAKdHUa9vK8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QrceH6fuFiVws+8xbOkrpfTQjMaVi/kpMZ8myebP2uk=;
 b=EynzyhXKa3ONbpeqv9oLx4jfRl50tRfdfYVFbWBEWVgtf5IcQtMIPhEcYz6j3sXh869ImQHxlsDnY8/9XjeqdCfPkmSMYkkRkS/DRguyR/1ww8El3bmAsV/B0voQko/InfJ9rI19+Nhpoe8ZdUtOUfGwVFHeCpPlaBUMB2vLW/szFIPF4/NB9Yu7JwXKxMURuqaJrz4zVjYpG5J69gtQFrVHUg+ZiDvNMwq+NEIQyxv8QW1igVVQ9dwgVIWw6JTafpp/jO2e2onVURh9lqaOxAqaT7q7BW6Z/a2JjyDsas0A8+2qSeoWdSyTdDkoJe3AmCm2PFVkK3S31UiwSeOVEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by PH0PR11MB5902.namprd11.prod.outlook.com (2603:10b6:510:14d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 00:23:43 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 00:23:43 +0000
Message-ID: <e84e4df1-e45e-4211-0ad4-68086a9956a8@intel.com>
Date:   Wed, 14 Sep 2022 08:29:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 2/3] x86/sgx: Introduce union with vepc_vaddr field for
 virtualization case
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC:     "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
References: <20220913145330.2998212-1-zhiquan1.li@intel.com>
 <20220913145330.2998212-3-zhiquan1.li@intel.com>
 <df29d6be949983aae3330557845babb31cab8e94.camel@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <df29d6be949983aae3330557845babb31cab8e94.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0251.apcprd06.prod.outlook.com
 (2603:1096:4:ac::35) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|PH0PR11MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: b927d5ef-22f8-49df-cba9-08da95e7613a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kpxFbElNmB1KVqxLzpqcH7/zsnbYa1n1iyiR5gD5VzOTqM0KhIkMhnHhgv8IkdFi0yCGlKsSMaIIRDzmwOFirMiWEJIV3whg4kO3ugm2BdkyAvexNpxSqtV0sR16SkKLHjB4jMOsInI1g5iXi3es/u/Twaw80fEzzAF0Qauu80i6nzel7uNrbN56GsgDC94IOT61rQ3RGdM8y0Qo6XaRYJyDUPPVmH0UXdVNcOE3/l54ebFrRrSGf3NeDDktyKiRw7BlCMbABxWZ0WQUW4WViJYLB3Vv6bU2523G6XFgKFMVKt23WJq4dROHtcpela9UdoBWfcKF+bJpQJ+cfzxkglXmPBIti95oZrQKUBQ6F3eRCzaGDIJEcfzolApbMJrH38Z9W5z0dHQwC3TGvYm6uWPxk1ICJuEq6ucD0/jFE9XyHMIIbXinqNHTi82LKfi2qWH8L2VVxFv6NZPzkvBnnenyDE5HF4tKa/5EQLfu8K0UvbWJiUvqwkSVSI5p9qCZuhrbug9/NVZj0gN/acFtzF7L+E4GMi2j5+2jyOfPKnmDpNmvyRIcaUC32tDdHHw8xbMen3DAomZsI9U95v6AT+VPztfpbm1fayIdEnxuB43byTuN94hsIdIUegJjpSON+WS9ese2aivypiPtLj/AAjnoOlIyq71U4ZYE3ofeP0IoK4aMk06NtmbDccNbq8Xbz9DRUI7kYb1ep7M9D/9qBkJmQzJVTBgLVElJZz4COJSznAybxCNlEQshX+5fT1SJ9eeiUZHeHhdI/ZKYmHgEaZuvDXNhLqziWzSzu71vJnM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199015)(2906002)(66556008)(38100700002)(2616005)(54906003)(6486002)(4326008)(186003)(8936002)(110136005)(478600001)(53546011)(66476007)(8676002)(66946007)(36756003)(86362001)(26005)(6512007)(6506007)(6666004)(82960400001)(316002)(5660300002)(31686004)(41300700001)(4744005)(83380400001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDJZUEN5cmk1T3p0eEg3UUpjNk95ZmZUT2VvQmViZ2lXU0pNN1lqekV0dmV5?=
 =?utf-8?B?cUpxNDFNWmNUVWtWREVyV3NQZGRZRjcvOTlCSXRXaWZ4M1p0VWFxcmtOa1FJ?=
 =?utf-8?B?WExSUE51QWhUYUJ5ZFlVcUtGV2daTy9rY2ovMTk3YUNIZDZDd2VaVUpKV2xk?=
 =?utf-8?B?MGFTRHk3Z3h1MEdpeDNxNVg3T0RWUWV1L3d0cUF4c2pnM0djdkZMVVFwc3g2?=
 =?utf-8?B?U01SU2hFTnBua2JvNk1POCtab2NrajdOVGRQTmJhSEdkU0FJTTZPcEF4eXdm?=
 =?utf-8?B?bTVqdTBrOVdjQWMrYTBwRTdza1RyNmRnVTVYcDMreW16UjJnODFmTTcwTWt1?=
 =?utf-8?B?a3JlV3Y2dWJQc1FJZW53cm1aWEJQaXNGMERET0IxdkVjczgzUlhFenQ0UGJo?=
 =?utf-8?B?cnJnTjl4aHREMU5GSGh6Ujl1VExXQllnTlNqd2VZWFUzNDF3d2ZMZ2Y4VU91?=
 =?utf-8?B?VERCeEhxZDRablNGR3dSNDJiQnRTM2w0MWo2R3VMbjdVQVlRbXdrSnRUU2pz?=
 =?utf-8?B?c0dlc3F2ZVo1eHlIbkxhbnJ6VlRlMVU5bE9sQUpZaUlLQ1pvUUIvNFNycGpu?=
 =?utf-8?B?eEk1bHI5MmVDUHJzNUFYZWVNeGZzaU55c29iVFFNWm1LUldpdXJGRnZvYzZr?=
 =?utf-8?B?S3JTQ1JGVEljZWFqb2N1NDBzWFk2anhOL2x1WmFDV1lGNG5vb1Q1TkZqc1Rt?=
 =?utf-8?B?UlRlODBIVnFoanBrdllmemg3RHFjZk5aWHFJVklMRDhLSlVvOElOMi9NZmpk?=
 =?utf-8?B?TlpwaG1MZnl5UkVrSkZwS1I0bWpXNFd5MDBWUm5DUmZ1cUFsVXZUeDZPanpy?=
 =?utf-8?B?VnJLZnVZQkxnKzRvV1piem5IcWluYy9HRUNhRVYxNGZVL1Evc08yNXVmcTk0?=
 =?utf-8?B?WEMzR3FldWFZOXBrdkNwQVdwVHErQmJsK3JSeE9NYjJjQjZvM2NkTE0vVW5I?=
 =?utf-8?B?WmlyeVUzNHM3UHJQdTYxOGxOSWhvY2w2cXcyQUR4d25DY0Y2TWg4MnZVazZK?=
 =?utf-8?B?R3hSUWhqZG9ITytqb2FGcXY0cFZ0aTIwdUZ1eDNSOWZJUUVLTmZUSDYwWjBZ?=
 =?utf-8?B?YzM5WmdFQkVNdlorbkxOZ0l6ZVlZTE8xZWFwWGhCU2NNOHBhbXEzNlZUTE9V?=
 =?utf-8?B?Mko4YTFta3dobW1zamlyMWtuaXYrUklKekk2bTlpVWZxQzU0ajQvTVREMmVj?=
 =?utf-8?B?d0V2M3NSV0lyYlFnaWg2SkZLNHIySFU5R3o4RnFCek5NRVlMMzB0NDdtVXda?=
 =?utf-8?B?THg5aGp3cVhYNXd3Vm53UVFiNERidHFBUTUyL0w5MGxXeDV1dmRpaW5qbWJC?=
 =?utf-8?B?bGM5TDBuMldyNTl4dEYvLzFITUFkTm02VFJReHJQSi9ZYnFGOVByZDh2YVYx?=
 =?utf-8?B?NGswSldTdkNjUkp6UE13QzNNWVEybjc2cndvcTBUWWx6b294Y0tTaG1ySVFm?=
 =?utf-8?B?aGFvVUJETTVkRGIwSEl5dmNaR0RObnhpbjB1NWptZ1ZkRVZDejZIMThtNk8w?=
 =?utf-8?B?Z3M1Q2xXU1ZjVmEwMUxhbXI0RnBPeWVqWnovdTBBZHpNY2t2KzgzcG82NEhh?=
 =?utf-8?B?RjJiVnIwOE5odWJ5LzdnNXpYOW9zS0Nialo0aUlQRHZSdFFpclZvUFRZQ0Qy?=
 =?utf-8?B?Z1JqYWY2NmRjeVhuNkVMeDF3aGY3eXhwUkNSd1VRdEpidFQ1WTlGeWNEWjU2?=
 =?utf-8?B?U1FpSDlQSnh5bkNwS09reE5VaklyNDllWkRCQVFoTVlUMkpWOXEvTlR6Nkdv?=
 =?utf-8?B?b3oxcGQxVThBa05SR0pLV3hsVXBWQnNHRUhRNTMzOCtTR2ZWa2QrODUwZG1S?=
 =?utf-8?B?MG9hUnhGMnYxaTRVdTVjcHpsQ2VKWDhNTUZ6QVBNTU5obFVRYnRHZEZyWXlV?=
 =?utf-8?B?Q2JGLzZtK3pqVmJpWDNGdGI1NktPL3NNMi9ERU5uRG9XWkZWRUp3YXhxd2xD?=
 =?utf-8?B?T3pYZEFNc0hhakhFTlFSUzBweFJtODdMYUFIY1dXbDVBQkN3M0tmRlM1elVi?=
 =?utf-8?B?U05RZzl1R2Y2QW9YZml2VkFEdEFXV1RlOU11Szd2Vmk4eWFabXJOaCt5bE94?=
 =?utf-8?B?blkwdDVkUDRxYWxJM240c05sRzZnSmxlbDhiMnZIclVuNkpyZFVDd1ZrTzZF?=
 =?utf-8?Q?kXaRtBP4QJfUn+BVU3bvZA54U?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b927d5ef-22f8-49df-cba9-08da95e7613a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 00:23:43.1792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OeNleEH1nqvK8W4lrs1AMyiEaq9TYMxH5xmTBNM9zl2a8Fs+TD15pWkSqsI/Oay8b+mj+q5/MkWOaT+Q0Ljezw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5902
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 2022/9/14 00:40, Huang, Kai wrote:
> On Tue, 2022-09-13 at 22:53 +0800, Zhiquan Li wrote:
>> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
>> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> Nit: you can delete someone's Acked-by if you already have the Reviewed-by.
> 
> (The same to your patch 3).

Thanks, good to know that ;-)

> 
> -- Thanks, -Kai
