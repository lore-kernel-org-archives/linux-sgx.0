Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFE7ECAAD3
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Sep 2022 02:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiIOCRS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Sep 2022 22:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIOCRR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 14 Sep 2022 22:17:17 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620038FD45
        for <linux-sgx@vger.kernel.org>; Wed, 14 Sep 2022 19:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663208236; x=1694744236;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xn/7VAryBKCx2VI6sgiZF66nNfaNBGAC/h9465aMuyg=;
  b=nAud6Ujz4doTmark6rAZdrGQzDOCN8zLDzx+OC66oLKZQE2e2/uro9gx
   wrOHHc9yQgny5NaDleecVP0r5DLTk7e++0tjOgnVImaPGtNl51e60ShZC
   daGHY4hojFgCxXUm/gmwy3DTHEHkb2Hnpgmd/RNHDMEwQf3PCCwt30il2
   5UInWj7uKgT1jCVKt6J7jG3N2JnJ0Sx/jh0ok6YSEag+88zbjJ1vNfizB
   M7wwuHavKueQaN1p02b9I4rWUyKca4JrhUHWDzxQ5/ILH9ZSoERpHODBJ
   Niteq6/AO5Zl2VfIlcBSGRMeywLerxwJfRO52pq2AMj7qRatFxbwXJ7xt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="285632607"
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="285632607"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 19:17:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,316,1654585200"; 
   d="scan'208";a="619519705"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 14 Sep 2022 19:17:13 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 19:17:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 14 Sep 2022 19:17:13 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 14 Sep 2022 19:17:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moqzm1VbPSWuQFxFWWuSpQr5A/d4KQU4B4L4qCYnmXpR0NQk1HSnpPn3ACaXCdZYoDMOtJDF+nKlPu0EA7Qi9sLLGykMlhVeXgQ1yf5snKgj8hUBQfBfGTAat8kanYRjuuz7vJiGgYMce03qZUW3DFoGVNztdRCnovsTeDuKz48EX9RL8chYsZkxp9Eo3CHvmi+eHlIHUndMfW8tAoQ/rSxvx1kp3FRLavDb8VOUbL9S52AbmDnUqvgl8zEHAnY38jfqxuFwxxFLGFSqh4l26mH1jUPP/mdJmSro91UN3xRqSjSiph04CFq1t/FGZFxiHSq3btXi9q+xyFhFPgKN5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HywNDLl/PTPC5iPWuP97T+WdU5P2+oYM77kBXndalbE=;
 b=QHu58JEvZ7CHrrodMB28u2QPjcxW9ro+ayEW0Inpe6NW4TAIJvDWMhgyQ5eV+d2GhpP4mRGn/fK07nP1eOuo7hBJ4gLcphqTMtpe1AxGn26g8EINAzJ50VHjAzB87LPFY5Q51YYExbv030in0fmLdjiiB/wZwjbdwFa8VTm7kzT/kw8cKMIRf4yCrUs9Xtxt7xSfvj9zEn0R2ak3V0GPZ6a4bv/Rg4vb2OtbsaOs/fjwA1zh+KItlQaGHUwYHO726k+umMK/lHDzxfb7f/Rn+SdG7NdYl5pvt1aRC+324qB4dZ7Eg5Irk25+MLBsIF8f7ibql/NkIGYSWjwnAkaGgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by SA0PR11MB4733.namprd11.prod.outlook.com (2603:10b6:806:9a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Thu, 15 Sep
 2022 02:17:10 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::8498:736d:7748:9bed%4]) with mapi id 15.20.5612.023; Thu, 15 Sep 2022
 02:17:03 +0000
Message-ID: <48f10df1-f5ac-cd66-032a-5648989b8aba@intel.com>
Date:   Thu, 15 Sep 2022 10:22:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 2/3] x86/sgx: Introduce union with vepc_vaddr field for
 virtualization case
Content-Language: en-US
To:     Haitao Huang <haitao.huang@linux.intel.com>,
        <linux-sgx@vger.kernel.org>, <tony.luck@intel.com>,
        <jarkko@kernel.org>, <dave.hansen@linux.intel.com>,
        <tglx@linutronix.de>, <bp@alien8.de>
CC:     <seanjc@google.com>, <kai.huang@intel.com>, <fan.du@intel.com>,
        <cathy.zhang@intel.com>, <zhiquan1.li@intel.com>
References: <20220913145330.2998212-1-zhiquan1.li@intel.com>
 <20220913145330.2998212-3-zhiquan1.li@intel.com>
 <op.1shsrfrrwjvjmi@hhuan26-mobl1.mshome.net>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <op.1shsrfrrwjvjmi@hhuan26-mobl1.mshome.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0162.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::18) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|SA0PR11MB4733:EE_
X-MS-Office365-Filtering-Correlation-Id: eed7fe45-251d-4506-0b82-08da96c060da
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wi4YvLqFn/G+iaHPNxh6YGNd77F0BSnLIZhQt7xQf2AaQgpUCefBZ531jU2iYKd+KR4DuVaDcFVBadvhHM8anjsT3do1f7GmeuHBoHBtCrpze7UY+Y6cc3wvOvsFTKllpAmebDebw8M1ULRDy/mMgg8gYQiUfUlM0DKa71cxjzyFzHuSiNtWhLrGGYWVLPKEceyNPVW5ZK4kF+SH0UHUGf4r2sH2q9giYOR5kUrJB9Rpzu72bahgnGdBcqMqMz0vRPmRwUZSOgyL+rGe5QNqg5Q7qenuezZuuxgo1jlps18aIYAkKTgErxQgu8+MnzJs88r32XLK9CQSmqm+P66aSoqXIevVLIJzcGR3uIc5ntrFK83i40Lt+Jo1Fi0tu+z2Pymujp5EQPQhbOmd9Ibv8SrfxoQBknCYYHEmEg1pcEEnJJx5FJE8DMqpX+n8QFhQ8oFUvroIY7kY3DdsYrhe4MktyThEda/tz7eHFmbFySe2bgDaBOWnG+W6nmw+WLYqy73t7d7P1rindcYrNXAd/NDkRXfPYZ07Y+Rf34qI9XPRJEaSUx6perxdDt7owP+0+3SeejMLQMc92YNcXdOeiuHSh9Z0R8xG4ywwoaWpIsBUOITFv2CjHJSa/fkUs9216Oax+A001Dc+Sfzi5pVWe3lYXuoC79gyMty+Q5mvuloTm7foo6E91cvu8m1oJJG6/CYXswkyK04jIN/ZwFt2e3TcJQ65Eqs2UivGrKiswC5Zxvy/62+oqkWleS5YsR5VVI0NaJgybzWDJm72NPRHysU5dOS1DWBBA7VRsykisoI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199015)(4326008)(86362001)(478600001)(6512007)(2616005)(66556008)(8676002)(4744005)(26005)(38100700002)(82960400001)(6486002)(6506007)(5660300002)(53546011)(41300700001)(316002)(2906002)(6666004)(66946007)(83380400001)(31686004)(8936002)(66476007)(36756003)(31696002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3VZbWxOSElkanRWYzJuak84Nnk1U0R3bWxDN3RkYTltdk9RQWZXcGF5UExv?=
 =?utf-8?B?djZmSHFpRlNua0ttM0xDdVo0bG52QXpEd0NIQS9IWXVrV2NZeTU2ZDZTZUp2?=
 =?utf-8?B?TkZSU1JNSDJqcWQvdStXV0F6MzRDOTl2bkx4Q0gxTXl5VFZUbi9Ua3h1Tzln?=
 =?utf-8?B?RDBDdkhNNnlNNkN1WDcyWTY4aW52d1ByTUc5dWFES3p6MDlWcUcvN3djZFIr?=
 =?utf-8?B?MG5YNGNGa1hieFNvVTFlRHNxRWg0NTF5cTB3eVpsN1BFOFJaRzZhS1VCbWda?=
 =?utf-8?B?Q3ZaRGNRbDN1Yy9xMzY2QXFPSEJtQTdXK3ZaamsydkFobEt6anFmWEJsNDBB?=
 =?utf-8?B?d2ZkWUV2MmtBeThiT2tOdXdWU3R2OGxnMWdnaVg3dzJBbTI4RjJscWE1WVpJ?=
 =?utf-8?B?cHJXWEtyMnNpcG5kRVFZd1EwMGFpdXo0aWxrWk80L3RPSStIcGlwN2c3ekZu?=
 =?utf-8?B?NzR2SzF4NE9SK3pLVkJoSmJLY2xuME5LWlBMblNITC91SFp2Z0NaTnE0M0Ir?=
 =?utf-8?B?dnd1aXQ0QkM5Z0dlcnJndC96cDJHYUNiUUx2WEVQRkVrNDgrUVYwcm1LMUY5?=
 =?utf-8?B?bisyUCs2VHBmRHBPdnhRYjhMT3dGWHc2VHhMck5qcG1TaVhqUzRnZzdqNkR2?=
 =?utf-8?B?ZGVSMlhNMHRKSVd6YUxBR0Y3RTVBbnBaZ2IyOUN4TjZldGY3bkQvSmNwZGpm?=
 =?utf-8?B?Y0NMaGZtVmE1MXBZM3Z4ZjZhQjNRRm0xMkg4aTlxOUN1TWxrMklvanlFYzhz?=
 =?utf-8?B?N21pa05FeFFGSzQySmJlaFBtWTVpNEpmT3I2NnVKdEswMFFXZk5XTDZjSmlo?=
 =?utf-8?B?ZHdmRnlRZWk1N3BOL3JMQ0ZyUEh6T2ZxZHgwdEIrMG94V0phcUlMRXBHdGxn?=
 =?utf-8?B?WlpleUNKcTNLMmdTM05KK2pxakhMYXZtNDVnRC83enV5YjhQdmdlaUFzV1Vx?=
 =?utf-8?B?Tks2NjlsQXArN3B4VDhEVU9uSHRySXVFbkdaWXRGbjNsR255THd6RzVNYnJv?=
 =?utf-8?B?OHhGV2htenVlcnZKV2pJTys3K3dBS1VUL3ZuSEN3N1g3S24vT0orNmNjQmk0?=
 =?utf-8?B?UHRUR1d1RGhaL1FqT2xFUS9nWDNhYmIvUi9hVDJPRTliLzMrNmN1bS9QZUly?=
 =?utf-8?B?ZG53ays4RTA5SDNYSkxHS3N5a3NzTUx0cjd5WnBkdUxwRmtvY3hmQnFaVHZF?=
 =?utf-8?B?YjNwZ1NJdnVrWXVvNTdOejlwbmU4OTd4eHNsTDdCektDcE4zd0ZFYjlIUTg5?=
 =?utf-8?B?THdvdkRaQWFKd1VGUWhLN3hiQWpnQ01qbm4zY2JtK21HT0JxOWlnUEhEOENj?=
 =?utf-8?B?bE8rWnYzMnFOS3hyc3B3UjBCcEttMEV1MXVNNFlxZUF3LzVjdVhoQW82d2Nr?=
 =?utf-8?B?eVB6YnpHNjd2NDg0UEdzdVpValNsb1FEbVFsS2pCVk5aYnVFdXJ0bFhmMEdx?=
 =?utf-8?B?b0lNWDBEbm4ybENTaGdETUh1eHdCWTRIWUkzelpLOCtjTHo0STVCTGVMQXF0?=
 =?utf-8?B?Nks0WGY3SXZiOTlaUzNDOW1mbFBtUlFxY1VRb2NJbHZpT2RFbzFxTi9PY1dz?=
 =?utf-8?B?WUpUNlVCUFRhL0NMb21aTHFYWGpvM3hGY1dxYkt5V3U3dG9GdHQ2UEpVS2Q3?=
 =?utf-8?B?UFVIUU5KYk96RjlaOERXbUR3YkJBdWJvc0ZqWDFmaGJ5aFJTQTY0VVJzUkJj?=
 =?utf-8?B?RWM2Z1R0M0I1U3o0Q3AzVnJBbU56blFBRGJlb3FrQlR5ZUdQM2EvU2VrVXlu?=
 =?utf-8?B?YThyWnYraHpKQ2h2SFVvd3hBa25NSUthZlkyN2NqWjBxMzJ2NHpid1pwNHk0?=
 =?utf-8?B?T1NSYzYyOEN3Mnc0UFgrMEJqemc5bTkzVkxURmtjd3ByQ0FtdE5NTUlWZXBi?=
 =?utf-8?B?cWFpSk95OTloSksraVE1T0o4aVA0N3Uxc0hkb2YwN3FEYXIvci8xQ1F2VzhR?=
 =?utf-8?B?NGNzZ0U1SmZuWktKWWlWNkxiZ1NqK2xXQk9RalVhS09Bc1orN2VtZFJPZkZM?=
 =?utf-8?B?NW1mdHFYbytTRkNZdEZVVjI5bEtXSHpKVXVVYjB6ckZSQll0TTdHNHNYemNq?=
 =?utf-8?B?QkdDTmdaWk5TYWNHLzM5Y3U0Um1jMi92Z1JpTWMyd0ZVckxkNVZKQVJEcjJY?=
 =?utf-8?Q?gVF0KAlZGzwq5PBr6Ji7dH9jG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eed7fe45-251d-4506-0b82-08da96c060da
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 02:17:03.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UYNVcuK6JS7xkq6CE4ulr0Q1CdKYFc1tVhYuY8uu8XYkmSDS0qE5/s0w1O+Q4H9DLljDLDDVC+gTxKEO4cS6Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4733
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/9/14 23:46, Haitao Huang wrote:
> Maybe it's just me missing some prior knowledge. It's not obvious to me
> why you don't need any guard accessing the encl_owner field in ksgxd
> thread. Is it because all vepc pages are never put in the active list
> and encl_owner would never be null for all pages in that list?

Yes, all vepc pages are never put in the active list. The SGX core page
reclaimer doesn’t support reclaiming EPC pages allocated to KVM guests
through the virtual EPC driver.

> Regardless, could you add a few sentence here to to make the rule explicit?

More details please see the section "Virtual EPC" at
Documentation/x86/sgx.rst.

Thanks and Best Regards,
Zhiquan

> 
> Thanks
> Haitao
