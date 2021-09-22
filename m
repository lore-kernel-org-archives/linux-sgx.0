Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E19AC433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Sep 2021 23:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E35CC611C4
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Sep 2021 23:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbhIVXcV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 Sep 2021 19:32:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:49788 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231259AbhIVXcV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 22 Sep 2021 19:32:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="210964164"
X-IronPort-AV: E=Sophos;i="5.85,315,1624345200"; 
   d="scan'208";a="210964164"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 16:30:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,315,1624345200"; 
   d="scan'208";a="513203130"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga008.fm.intel.com with ESMTP; 22 Sep 2021 16:30:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 16:30:49 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 16:30:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 16:30:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 16:30:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzqMqNke3AmDrALik0AYQVO+WPqrS1tRdXaFOZQLRKp9FL9os/64THkX/x9cv7TjDG+YKN5GC5CCRbOcYJHRUSYrhwBVd7/83Op+b/Dv7Zk6zjbgfj8tSB7svOvZpTgMSHW0VEfqOkBZpCaSOk9g1tJRg/RBmtDDeRIT0BDIPSVd/+sHmJrDiToBfzu/s9Y65zYRURQ8mOCC88+AguwE1LeXpVuje2kjcQx2guQkJzYh+WMDkN07dDInc5cqW9A0G2Gfvolse2TfBZWGanvF46AGbEfDL8vYPKQ37UAIYrruq+YXZUb24NGijda5vyNsIlpBF8dqQ/eh/Ypa3LKn1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=y2d1Z07W6qojtVctFHCG6wrhUUJTlMXFyHTIQlNgE/0=;
 b=kNh569G0CBFCj9WpfIydhcRv+Q4fAXP2a0Mzl+dq18MKB77B0T7XTLyTwhdCKIUHkUn2/Yblefm28vQjWOeGCAKAz6vlz9HsceOydTs6wRnGjmXmjQA8/DnujVJJ5jsR0SjyK70XoUARMrtJ7aeVSDKdtFfhuLxXyyf5csFlOrJMuVGoyPpy+MitM0WmbSCEIky9cqnV9Vu0cS5ordSqmub0j7cKHXfv4GExwxp9Nz6X5b91EZRksDW0SJHuPPsOFZxLlTtpkHXPauyYnoYj8H/MzhBn+D9DPF1iWqiDK+lLFGSws+q6gRuXkgqNDuP289Kpi1/7KyPN4C/Y+AGbng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2d1Z07W6qojtVctFHCG6wrhUUJTlMXFyHTIQlNgE/0=;
 b=d1CFAVi6qbWn2S3pWEbTvl+wCt8Pvxh7oV6uF7ADFcMiBk0hLwpfePwlE1lFgXMguEONu8pWIMzNLyoWbkzZM3BZcdaxeJl3Ma1n7RsiVZSqIpAH924jhRzrpTeK27is50u51FtQ37MNI8VwMtac4vde9lI8hWgEc7gLPw8j4FA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN9PR11MB5290.namprd11.prod.outlook.com (2603:10b6:408:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 23:30:47 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::d47c:525:2aef:f6a]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::d47c:525:2aef:f6a%3]) with mapi id 15.20.4544.015; Wed, 22 Sep 2021
 23:30:47 +0000
Subject: Re: [PATCH v5 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>
CC:     <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
References: <20210914030422.377601-1-jarkko@kernel.org>
 <20210914030422.377601-2-jarkko@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <f45245ba-41b8-62ae-38b5-64725a214bad@intel.com>
Date:   Wed, 22 Sep 2021 16:30:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <20210914030422.377601-2-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR18CA0035.namprd18.prod.outlook.com
 (2603:10b6:320:31::21) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
Received: from [192.168.1.221] (71.238.111.198) by MWHPR18CA0035.namprd18.prod.outlook.com (2603:10b6:320:31::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 23:30:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17273513-da3c-4752-06ed-08d97e210167
X-MS-TrafficTypeDiagnostic: BN9PR11MB5290:
X-Microsoft-Antispam-PRVS: <BN9PR11MB5290B687E45B6F940165BBD9F8A29@BN9PR11MB5290.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7w4AQQ5KzV2haTRINbYJRB/Z9E/Y7VqdinoANfCdPm4ure2bZbFTYAQYd1TQRAGOQOUiyiSGsUdMjPbUfiqOL5/uxPVXX1DyMHKC2lbRnXD9yI1R1pFT6NwxtaLfh768BNN88T63DXq+VimjknqmuB4cTr2LByJjIC1CYufoOIAee2wu1GbahYyKndEN3xPCoVgJ3Lq25pUquJJFF8yYlgeCFgXRKJKxNtIVk5pieIOh0NQWkXypYQjKpQRfshdYPDOREObIQekfV2Na7t2qGcbtLBLwXXKpjPbLvLLmB3I5HV0hpS2f1s2FihSoic7sYWRYieXiS7kN4Dl7jQJuwvfwNOao9kwqDGsiIYLQnsMChgVO6wvhgFURdWezvqpto3tjj/WMskCrzkqfy6x6qtcc/3kB+bThQeoCLoKyl49o4ShCQs5lWK7KSD9382unIbZvTgX/sq2l7hvXBYHDQzqRpLqV+RnFx0815DzaAfbu3DMqfWd1Ox9iVXtAVpmuE2k6LaufHbPEZ2Yg5lSLykS2FK8kStfeIsdThYqJU8bX9jrZojVp+5M+Wejr6H0oAMcpP5vp/KYkabO8ymdfeay6hEvr5jEfyK8osaZDI8nX/0pig57WOb4SIQgsRNZZZw6vzWbwWTnPD70opPdXNVOE06aoWZ28tRk1cKOteCkE/KxXnhv7btKf/UJr900inDBiTF6WD92iRk4XK+CHQKYJ4bx509S+VdRKuY88e2ShiWBKTnuyXONAda3VqH+Hga2uZlWzAM2d/ju+rKzV+3QBDiIAGxaf/3ZmsFgwPJU73O3HB7GfXTaXPgiScd0+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(38100700002)(8676002)(8936002)(508600001)(36756003)(2906002)(6666004)(31686004)(53546011)(2616005)(31696002)(7416002)(956004)(316002)(4326008)(6486002)(186003)(44832011)(110136005)(66946007)(16576012)(66476007)(5660300002)(66556008)(26005)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjRvTk9oQmV1d0hzWFhVQjJ5akRFU01PRUhCenRvaXp3QlYrTVh5L1B6YS95?=
 =?utf-8?B?TkcvWlArNHcrVEx3RUx5ekxKYnFlNnZwREtKRmpkMDcvTlY1cFJYbjQ0NVlD?=
 =?utf-8?B?RG40dU5tdGZ3cmZmaTUzaEgxajJkK09iRld0ckxISGUyYmNFYUlzL3dNUWN5?=
 =?utf-8?B?UXJnTE5rTWVSQ01NL3lSQUlKeFFFdFpkb1BjSTBBZjNtc2R0aHBSRjRtcE9L?=
 =?utf-8?B?UXhoZUJSbUNKdjBMSlhTTkw0b00wVzhadHFrdVdYZlBDaEdxRUNjUEZQZXlX?=
 =?utf-8?B?TVhFenVCaEdTUFZXa1UvRE5qU1JpUGZnYno1MXlxQ0xBS0duVTFRRnVPQ0dh?=
 =?utf-8?B?Z2MwdlAyK0ZmTzFPTlptdkZZWkx4Qjh0SVdIblJOaDRvNDdzYW5wcHpzTmRh?=
 =?utf-8?B?dmQ3YVhqeU9yTXBLRERwUkttNEtmS3I2YlJTYnU1a0l1cDd5enU2bm9sTWUv?=
 =?utf-8?B?RHpzM0paUzNoSWE4ajhsbWhmbkVMZVNkeG5WODRZMDVwM2E5V3RCcU1TbFla?=
 =?utf-8?B?RmpQWmJMTmFOUzQrREdjZ0l5K0Rvc0xiallDT2cwcE0xRWVtU3BiZnNraENw?=
 =?utf-8?B?U2plWjFSakNoQ011cE54RC8rVkUrWlRHN2FRY2RJUlhwT1ZhbXh2RWxETHdL?=
 =?utf-8?B?WDR3Q0tISGR1NHVPelpxVDlOS2hpQy9YLzM0RElRb3IreG80SDJScEd3dGd2?=
 =?utf-8?B?Rk5iODhwSHJjbVFrOEUwRVBjRFBUOUxybFM0WVpxVDM5WnFMZ1hJbTBMNFlC?=
 =?utf-8?B?QW0zYlVzaTJtYjMrNUJBQU5vZnRyZFhsc2JaOUU2Qld4alN0K0k2SWFYNWtZ?=
 =?utf-8?B?VTVOMU5rSXNzZDg2dnJLaEZqby9SVmRoUE5ZQkF5YVZ3NEJ2Nnk3RVl0U3Bq?=
 =?utf-8?B?N2s1dWxtTHVKY0RYcXg5ZjJ5VHYra3p4MGhONGR5dGtrQTU1cndIMXcyUzBZ?=
 =?utf-8?B?TDJGUys3K0kzbU5WUGhUZnBscHhvN0FWK3NLanhyZ09pWWJvMDJZQ3I1Nklp?=
 =?utf-8?B?RXRzOThBVStoOGZDN3AzS0dmQXd2NS85bkZlTDdMdWE4RE9obHdVL2ZEa0kr?=
 =?utf-8?B?dkFJRjFrdjU3QU0rK3FGQ0RLYjAvMG9tdkhJMUI0ZGNUaDZiQXcvL2dGL1FH?=
 =?utf-8?B?RldnbFgvd3lnaXFMS21YZ2l5bndncGFMT3RIV3hSQkFUSzNWZUJjTkl0eHBs?=
 =?utf-8?B?V25HcW5wcys2NkJNNVlUbDVYSm1zdWdsczgyWkJ4MmlNY29MTktxRWIwQlFD?=
 =?utf-8?B?UWJTTGJDcVB0OFBSc1BMS1hiYjU1WU5KTk1Ra3ZsQUIwdmx4R3BZdk1hdEQr?=
 =?utf-8?B?Y2NFSWgrcFN4UkEzK3RBMXBQbTJKQ3NpSFQ1eTZJZWVjWmdpcThGUjh5M00r?=
 =?utf-8?B?MnhHQXhDMGtheWdhdVYxeTVyVXVwTHNuMmZiNEZIUmREMFRHWGxRek5RdVZM?=
 =?utf-8?B?MDhFV3ZKSXBuWE9UWWpFTkdpbnJDeHo4WTVQUnFjajFvV0lVS0p4RmNkL2FL?=
 =?utf-8?B?ZkF4Vit2eHhmQlhkMlRkbXF2RThkblIvM2dDVUJ0ZzNDMHZOanFlTzNYQzYr?=
 =?utf-8?B?aDJqMzgwYXpvVS9KWHBGeDhFMi94eThrUU1aSTBRdVlSUzRIbmhpdU40M1V3?=
 =?utf-8?B?MS93WVRERVVQblhpRG1Nc1FBWHR6aWptZkVyT2E0U08wZTdUR1V2QVZqbGtO?=
 =?utf-8?B?Z2ZJNHRaMlZJWEpiaUJuUit2WTNaMVFubnVJdWZ3VWJObEsrc0Z0V0ovSERU?=
 =?utf-8?Q?cKU546mK8RibQb31C5VXb1mBshkEv0D1/E1Gq1b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17273513-da3c-4752-06ed-08d97e210167
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 23:30:47.3818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M59lJPndoeOGpykHWMiq0plhhds/7iX4d0mE1N2K9YSK5VCSiyzgWeJElkaztlAdHJaMMWV7VznuCrZ5YZMbzVaxOize7OhrnW2K2CzJOOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5290
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 9/13/2021 8:04 PM, Jarkko Sakkinen wrote:
> The amount of SGX memory on the system is determined by the BIOS and it
> varies wildly between systems.  It can be from dozens of MB's on desktops
> or VM's, up to many GB's on servers.  Just like for regular memory, it is
> sometimes useful to know the amount of usable SGX memory in the system.
> 
> Add an attribute for the amount of SGX memory in bytes to each NUMA
> node. The path is /sys/devices/system/node/node[0-9]*/sgx/memory_size.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> ---
> v5: A new patch based on the discussion at
>      https://lore.kernel.org/linux-sgx/3a7cab4115b4f902f3509ad8652e616b91703e1d.camel@kernel.org/T/#t
> ---
>   Documentation/x86/sgx.rst      | 14 ++++++
>   arch/x86/kernel/cpu/sgx/main.c | 90 ++++++++++++++++++++++++++++++++++
>   arch/x86/kernel/cpu/sgx/sgx.h  |  2 +
>   3 files changed, 106 insertions(+)
> 


...

> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index a6e313f1a82d..c43b5a0120c1 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -717,6 +717,7 @@ static bool __init sgx_page_cache_init(void)
>   		}
>   
>   		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
> +		sgx_numa_nodes[nid].size += size;
>   
>   		sgx_nr_epc_sections++;
>   	}

The above memory seems to be uninitialized at the time it is incremented.

I tried this out on a system that reports the following:

$ dmesg | grep EPC
[    7.252838] sgx: EPC section 0x1000c00000-0x107f7fffff
[    7.256921] sgx: EPC section 0x2000c00000-0x207fffffff

It shows unexpectedly large values:
$ cat /sys/devices/system/node/node*/sgx/memory_size
12421486739271732874
16308428754864105707

System reported sane values after adding this fixup:

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 3380390cc052..d73bbfbfc05d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -621,7 +621,7 @@ static bool __init sgx_page_cache_init(void)
  	int nid;
  	int i;

-	sgx_numa_nodes = kmalloc_array(num_possible_nodes(), 
sizeof(*sgx_numa_nodes), GFP_KERNEL);
+	sgx_numa_nodes = kcalloc(num_possible_nodes(), 
sizeof(*sgx_numa_nodes), GFP_KERNEL);
  	if (!sgx_numa_nodes)
  		return false;


After fixup:
$ cat /sys/devices/system/node/node*/sgx/memory_size
2126512128
2134900736


Reinette
