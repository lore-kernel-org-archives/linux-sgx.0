Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CDCC07E9D
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Sep 2022 08:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbiI2IBW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Sep 2022 04:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbiI2IA5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 29 Sep 2022 04:00:57 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B9D86713
        for <linux-sgx@vger.kernel.org>; Thu, 29 Sep 2022 01:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664438413; x=1695974413;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S9Rgkw3BKtpwW2pOvpb+7U1uLxvoOlFUJUzJ+AkvD64=;
  b=L96JUq7rb5O9uHChmkTXQo8+1OKW9feBajCi+DVQIGuk6YZy9LttsQQ+
   LJF5a5DYGAj7FC4SAXeaSXMXMCaD314XUcHAq1IFpqdrS0ED+SKb2d5+r
   3noSUQ9kJMMaPfy3UTM1j6fPK91cp/jMqZyM7xfTk7WRuXedKh8yX1nO5
   zkiIEEyjENI7rS+JSQQRwWphODVHW+yYAIaXZRJwCBYyUheV6zFLCX2K3
   YIe7kE8qlzv7HZY/Chn9FD+Aaq2SkdlcL1yR2lmmjDt5U/nvHYSYeiwip
   D9AqiEhnZLZbFLuclP2081F204+DBqyw2NVawzb34ehEIyD0F8UII01qX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="288987818"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="288987818"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 01:00:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="624470139"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="624470139"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 29 Sep 2022 01:00:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 01:00:08 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 01:00:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 29 Sep 2022 01:00:07 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 29 Sep 2022 01:00:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYPRQcpLGXNiTt/jfYLJBGDPZAoFudC2Q+wf9/4l52DQK5MR1ZhZIlF4KIJe0PuyjDzIFAT2f/jJoEncb+Xnmk5X2zFBPnhrh/qcd23i9R/UgtAxC1z5q5D7NLapi+wg8JNs5wZLQB1OFe7bfRIT4bw4dTwmdN/Wpe8RoPL+Q27mB+xOyQu0aZ+6PJmqV+LzS0T1oZyw415FNug9ROVjH4IAsjfShL9YvbttWCKwubPDD7skenACMEDljQZjsVLwvTqO6R+vXZvQNrgW9HET+qtSdYoUh3m1bTXLLT2xUNRkL+P1Yqz3pOUaTOU5Zzkqy0kG0T7Cwcnrz0V7CIJzZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLS9ikAAg3rAONgmh28zOi56aMqb8OSd+M1XEDFLbUU=;
 b=dPX2Bk9P8eT2GzsL0LzresykkhjkhrB9yfPxwRVMeRQUCGDyQhJOLxNa/+6AYARGG96a/tMBprWnq3gin+caOF/JmH1vmqXSRAc+Ysy5LjZJEbEhNMSLrZ7noOIBZlrvGrOOoBORH9k/o7JTZhNHeZi+uTgpKoLJsUyjFTEmXcMANfQUmPEpPFHxvU+r0cxLe6fNHfqpytGcbEfCTAvdUdv4De1wjio8L3Nk3EdbEgMsgF6ouTChsfl5W/7xDcBm2F133otxxfJQjZygmLYRZJtzyMQ1lZaaxGk8Wo66KMZMraTtdjLiSJ/0K9xOu5wMa37GC8f1Nn0/5eB2H3pfJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN8PR11MB3715.namprd11.prod.outlook.com (2603:10b6:408:85::13)
 by SJ1PR11MB6250.namprd11.prod.outlook.com (2603:10b6:a03:459::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Thu, 29 Sep
 2022 08:00:03 +0000
Received: from BN8PR11MB3715.namprd11.prod.outlook.com
 ([fe80::a486:ab23:cd0e:4681]) by BN8PR11MB3715.namprd11.prod.outlook.com
 ([fe80::a486:ab23:cd0e:4681%7]) with mapi id 15.20.5676.017; Thu, 29 Sep 2022
 08:00:03 +0000
Message-ID: <254ecf51-3e7f-dd8b-a030-8d5607b3cf67@intel.com>
Date:   Thu, 29 Sep 2022 16:05:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 0/3] x86/sgx: fine grained SGX MCA behavior
Content-Language: en-US
To:     <linux-sgx@vger.kernel.org>, <tony.luck@intel.com>,
        <jarkko@kernel.org>, <dave.hansen@linux.intel.com>,
        <kai.huang@intel.com>
CC:     <seanjc@google.com>, <fan.du@intel.com>, <cathy.zhang@intel.com>,
        <tglx@linutronix.de>, <bp@alien8.de>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <20220920063948.3556917-1-zhiquan1.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGBP274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::30)
 To BN8PR11MB3715.namprd11.prod.outlook.com (2603:10b6:408:85::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR11MB3715:EE_|SJ1PR11MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: 764b8681-0aa0-4305-a09c-08daa1f09d70
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vWTAHvVbjb1hh/XSTNjOmcIAfMu3Z/2toaGDeDj3+h35LyyA3O4iaEQIbW0X6EM5nwS+Kb3dWdWTzw+pJC99cYysx9mp9OHzKjEVFjLtqj/z0tmK4kjNb+q9GPIYKrUVQPGK6smN0WXMEstFbImyTqpLl2g6lcG0Wfhoxs0C5l2ZN1JMp9T9uF0oa+hMukRzRDXUZz8vgCpdS2cPA4M8TECyleSSLJmwJRByIA8ZER+Ac7ZfTjxB1K6jOkgFc2dkVv3n/du/aO4f8ozaY5pPkWx7qnsNWxoQBS9sgRWhOsKgcwgjKotHMNMcVPOYS15w6zq6g8yiPETzWkJITccmRYISbPJtAUCKXnGl8BvnhJGE0iz27BzU3KmJiBrlh8uJqAfWf+hu2KKEUAIRy0GEAr+0Z0BGLMoIdxOVwqZtFoI88aen0H6XWHWcQ4V4ZT5uw0gdiIw7EZ0ZSiHW7gXhZSmCvVzGoVzUxKffx2bbJeC+tC/CNCwqZXCqGRJDYk9WaOU+CB+e2W52L5V9Ovqfyo4ku/8KJS6+XqFXF94Cl9xUeFMwenNUAeldpnxAfWHuSdriNSXNWmA/qKg3919o+lw/XmzzmoaAvPoRkPYB5Auf1zGheDM+jYzMCHL0LJlBSPFAtE977TvkTvXoGBb8HzUc9UTB9f5j9Nqs3RNaCBDjxxamRbhmmXb1PnDtFfFqO8rS2gPxkA6nf6dyx27MOG1pfEE/ySxxIRwkiTwJdqjX4uuwhhBdq0ybHsebT+KI6eoPksz6I6BJ7nD2KZmVhJJ+ZttXikEZ0uWLZNgPWA56sNrFcJ1hoPtTickmRvsGzNGEyZbmxzegF6lFEnM5JUOUF2hkJ1j/fj+hqKegTpXG9B/ugP9yPJZqek5S5Aua
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3715.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199015)(38100700002)(31696002)(82960400001)(36756003)(31686004)(86362001)(5660300002)(186003)(41300700001)(6512007)(26005)(53546011)(478600001)(6506007)(966005)(6666004)(6486002)(316002)(4326008)(6636002)(2906002)(83380400001)(8936002)(66476007)(8676002)(66556008)(2616005)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWk1RC9xNUx2RStTR1AxclBYNUsxYzZwc0lESE1BdnRCK25oNllWdXlmRjY0?=
 =?utf-8?B?QTdMbE51TXBzVERMSG5xb1RsamlRa05JR0cwV2lVT3NuYm5DVk5kYTZlSStw?=
 =?utf-8?B?TVoycWVuTzRQQ3BKYnNqTW5jYmJZWnMvWTI3OTVXZGZTdCtqL21mWDFDU2FI?=
 =?utf-8?B?a0xlZE9CMUJrYmhHSjE5VGhZWE9WNmRWc2VTMytlSHk3eFhrcCsyMzJyWFY1?=
 =?utf-8?B?bFlsK0FqcHZDZTFNTEhNQVRnOXRxSlZYOUF0MlR2U3duTWJoRSs5dVVPeDBE?=
 =?utf-8?B?NndWL1M1Mm5qY0lqZW0yY0JPalAxVkdYL1Erd0ZQSlRSUnUzUk1UZ2ErdWpP?=
 =?utf-8?B?bE84cHVHM29JTXFuc2ltVHh1MnUxaFZ2dTkyVUdSWmRHUFRMVkoyTmEvTCtQ?=
 =?utf-8?B?VjIxRkJycDNTZFpMZXk0QVloeGVkRkhzbXlMcGRzMWdTclZ1UVhUQU1lSGJX?=
 =?utf-8?B?SUtuQlluVld3Y0JmOFRhNzYxVjZtdnkxZDc3NDVUTVVNYVVram5pcVZIMGpY?=
 =?utf-8?B?MDNyV0ZsYUNTdWFyb0pzcUVTV3d1NTRrZ2pnR09abXNpNmpPUmpFckhNMVRp?=
 =?utf-8?B?YmVlY0FTSVJKd0d0K0psaTBON3JZTDlMN3JVT2NPSkQ3TmhTMHhKSFprelBx?=
 =?utf-8?B?WExLYmk3UXQ3eisxS0ltNlZTSDZFei9WK2NMaVBPTnVCMjIzODhieXNvaFJH?=
 =?utf-8?B?QjQ1ZHlhd3RNcWpwUjBFUkdtWXlacG5JQ0hHcHdjaWo1QzQwNU03eXI2bDRJ?=
 =?utf-8?B?NmVhQjlVczR4b0kydlM2b2NtL2ZGeW9acGJESG14Q0tkc3dTMmVhajdGS1Ja?=
 =?utf-8?B?Y3RaTnQyQWZ1a2x2TG9ZR1VVQ2JRVzRnY1JqQzZvOHdwZ3oyanIzS2R6S0lr?=
 =?utf-8?B?bFd2eXFuUEthM3JYK3dJYmRkSUYzeDlEK3ZNU1VTZmZOR21XZms5Tk55S2Nz?=
 =?utf-8?B?Uzg4TExDYXNQQmU1ZDJZSFJXM3Z2QkwyZ2hOYlEwWVU5dGxXdHZrd1VnQkJP?=
 =?utf-8?B?di9GMXlEMVhUMmE3TWkwNE1JMkFBd3pqTjk1N2RUOGlBWXAvV24xb2ljb1g4?=
 =?utf-8?B?M3dJZ24xUUlNRzIvbW5rUFZaRExMTW1jeERNdk1TOFZyWHNtWUtoMmFFdVhR?=
 =?utf-8?B?MmUyOUtEcndqNjdaRjF0Q2ZVZnQxMmtCWTVpT3VCRkUvaG1pMHZweXQ2aldn?=
 =?utf-8?B?L0FFS3JEOGdwR0ZKMkFZUEdUTTdZcVRsNGJUZFVTeUUxeXBLSFZTYm0zVzdS?=
 =?utf-8?B?a0QwMlozalQySmJldStUNXRzL2pNT0JIbHlIaGVvRG0zc3AwMjI2UXJLbGNw?=
 =?utf-8?B?WkY5cElsUmV0cnc3QVJ6ZWIrc2phQ1lSZ1R1cWJ1eDk5Z1RPLzNZbTV5b0Rr?=
 =?utf-8?B?YnRTNWNNb0JWclNVbjVuU1VhN0dSbTFiQkc4c0tKOEp2STRqYlpLWDBUelFk?=
 =?utf-8?B?Ti9USkpVRkNoLzJnN0V3TkEyWXBXZnM2ZkZkclJIQXE0ekVUWTNGSUtwTUIy?=
 =?utf-8?B?em0ycjVEV0VDVTFQeGY1eW1zTUhrOWtVcmsrbGxsRjVmZjZSQWR1NmFKVXVS?=
 =?utf-8?B?SGVyUzNkbml4cUl5UzZ6bTZIbXlqYjBsUUxOazEyV1Rqc0FMcTVzWUViUTFI?=
 =?utf-8?B?QjhQeWRkR3hqa285TEtMYUc2Qy93dWx2d3greFNwY0pQbG45R2d5UnllLzl0?=
 =?utf-8?B?OXF5WXBNcVUwUnliR25ESEdGK2RVZkdoTEJOa0o4WDBtVmJhaTF2dDNaNFZY?=
 =?utf-8?B?aUdlODZhdzdLSVp2d29lbWJwSW9Icis4dndIdFJ4Mlk2VktuSnorOWVXSWEx?=
 =?utf-8?B?Skt1QWJFeC9Oak1NVjF2SDFkMk1hSjBHajRXdktvWDRjTXN4Sld5Ukk4OWZu?=
 =?utf-8?B?ZXpOT2NLUFNIOFZDeW5JcG1VajE5czRhWWIvOThPRU9KdWV4aVEwWTBkb2VN?=
 =?utf-8?B?bUJwditPaitFUkZFZWFxN1lSb2ZGMmNDSitETTlFaVhLN01RSElxTnM1bHVR?=
 =?utf-8?B?blFOajd0K0JUdlo1QXB5Qzd6dXRmVmUrNTZIbHlmMlZuTFRKOGtPYWNIVGsy?=
 =?utf-8?B?RU9PbTFqREtsa1dyTFBmWkZubEJsVk5JZkdLYW1RQWcyVzlkUEpobWlpVGdN?=
 =?utf-8?B?M041USsyVUg0SmhTSmU1VGVZaDljc2YwdHlFUlprK09UQjRGa1RGZEpqU2tN?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 764b8681-0aa0-4305-a09c-08daa1f09d70
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3715.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 08:00:03.5879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sxQZxjlGpekkpdKZxIkga6RLMTlzAIWy0/rZ3j9LMfz0t+YK8s6ekroCt7jgBHBW3IULu6H8FbzXjUSH7Ukwjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6250
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/9/20 14:39, Zhiquan Li wrote:
> V8: https://lore.kernel.org/linux-sgx/20220913145330.2998212-1-zhiquan1.li@intel.com/T/#t
> 
> Changes since V8:
> - Remove excess Acked-by from patch 02 and 03.
> 
> V7: https://lore.kernel.org/linux-sgx/YxEyRT2SbfBdYNfm@kernel.org/T/#t
> 
> Changes since V7:
> - Enrich the motivation for renaming in commit message of patch 01 with
>   the explanation from Kai.
> - Add Acked-by from Jarkko.
>   Link: https://lore.kernel.org/linux-sgx/YxEyRT2SbfBdYNfm@kernel.org/T/#mc1c93e7d9643588b27cefa9540f988a070469b5b
> - Add Acked-by from Kai Huang at patch 01.
> 
> V6: https://lore.kernel.org/linux-sgx/20220826160503.1576966-1-zhiquan1.li@intel.com/T/#t
> 
> Changes since V6:
> - Revise the commit message of patch 01 suggested by Jarkko.
> - Fix build warning due to type changes.
> 
> V5: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#t
> 
> Changes since V5:
> - Rename the 'owner' field as 'encl_owner' and update the references
>   as a separate patch.
> - To prevent casting the 'encl_owner' field, introduce a union with
>   another field - "vepc_vaddr", suggested by Dave Hansen.
> - Clean up the commit message of patch 02 suggested by Dave Hansen.
> - Remove patch 03 unless we have better reason to keep it.
> - Add Reviewed-by from Jarkko.
>   Link: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m379d00fc7f1d43726a42b3884637532061a8c0d1
> 
> V4: https://lore.kernel.org/linux-sgx/20220608032654.1764936-1-zhiquan1.li@intel.com/T/#t
> 
> Changes since V4:
> - Switch the order of the two variables at patch 02 so all of variables
>   are in reverse Christmas style.
> - Do not initialize 'ret' because it will be overridden by the return
>   value of force_sig_mceerr() unconditionally.
> - Add Co-developed-by and Signed-off-by from Cathy Zhang at patch 01.
> - Add Acked-by from Kai Huang at patch 01.
> 
> V3: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#t
> 
> Changes since V3:
> - Take the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
>   Cathy Zhang's third patch of SGX rebootless recovery patch set but
>   discard irrelevant portion, since it might need some time to re-forge
>   and these are two different features.
>   Link: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170
> 
> V2: https://lore.kernel.org/linux-sgx/694234d7-6a0d-e85f-f2f9-e52b4a61e1ec@intel.com/T/#t
> 
> Changes since V2:
> - Repurpose the owner field as the virtual address of virtual EPC page
> - Remove struct sgx_vepc_page and relevant code.
> - Remove patch 01 as the changes are not necessary in new design.
> - Rework patch 02 suggested by Jarkko.
> - Adapt patch 03 and 04 since struct sgx_vepc_page was discarded.
> - Replace EPC page flag SGX_EPC_PAGE_IS_VEPC with
>   SGX_EPC_PAGE_KVM_GUEST as they are duplicated.
>   Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u
> 
> V1: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de76@intel.com/T/#t
> 
> Changes since V1:
> - Updated cover letter and commit messages, added valuable
>   information from Jarkko, Tony and Kai's comments.
> - Added documentations for struct struct sgx_vepc and
>   struct sgx_vepc_page.
> 
> Hi everyone,
> 
> This series contains a few patches to fine grained SGX MCA behavior.
> Today, if a guest accesses an SGX EPC page with memory failure,
> the kernel behavior will kill the entire guest.  This blast radius is
> too large.  It would be idea to kill only the SGX application inside
> the guest.
> 
> To fix this, send a SIGBUS to host userspace (like QEMU) which can
> follow up by injecting a #MC to the guest.
> However, when a page triggers a machine check, it only reports the
> PFN.  But in order to inject #MC into hypervisor, the virtual address
> is required.  The 'encl_owner' field is useless in virtualization
> case, then repurpose it as 'vepc_vaddr' - the virtual address of the
> virtual EPC page for such case so that arch_memory_failure() can easily
> retrieve it.
> 
> Suppose an enclave is shared by multiple processes, when an enclave
> page triggers a machine check, the enclave will be disabled so that
> it couldn't be entered again.  Killing other processes with the same
> enclave mapped would perhaps be overkill, but they are going to find
> that the enclave is "dead" next time they try to use it.  Thanks for
> Jarkko’s head up and Tony’s clarification on this point.
> Unlike host enclaves, virtual EPC instance cannot be shared by multiple
> VMs. It is because how enclaves are created is totally up to the guest.
> Sharing virtual EPC instance will be very likely to unexpectedly break
> enclaves in all VMs.
> 
> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
> being shared by multiple VMs via fork(). However KVM doesn't support
> running a VM across multiple mm structures, and the de facto userspace
> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
> this should not happen.
> 
> This series is based on tip/x86/sgx.
> 
> Tests:
> 1. MCE injection test for SGX in VM.
>    As we expected, the application was killed and VM was alive.
> 2. Kernel selftest/sgx: PASS
> 3. Internal SGX stress test: PASS
> 4. kmemleak test: No memory leakage detected.
> 
> Much appreciate your feedback.
> 
> Best Regards,
> Zhiquan
> 
> Zhiquan Li (3):
>   x86/sgx: Rename the owner field of struct sgx_epc_page as encl_owner
>   x86/sgx: Introduce union with vepc_vaddr field for virtualization case
>   x86/sgx: Fine grained SGX MCA behavior for virtualization
> 
>  arch/x86/kernel/cpu/sgx/main.c | 48 +++++++++++++++++++++++++---------
>  arch/x86/kernel/cpu/sgx/sgx.h  |  8 +++++-
>  arch/x86/kernel/cpu/sgx/virt.c |  4 ++-
>  3 files changed, 46 insertions(+), 14 deletions(-)
> 

Hello Jarkko,

Could this patch set be merged into tip/x86/sgx branch, since there is
no concern for a long time?

Thanks & Best Regards,
Zhiquan
