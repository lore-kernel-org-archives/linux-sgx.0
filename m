Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D77C4332F
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Oct 2022 05:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJLFEQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Oct 2022 01:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJLFEP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Oct 2022 01:04:15 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC34AA345
        for <linux-sgx@vger.kernel.org>; Tue, 11 Oct 2022 22:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665551053; x=1697087053;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JlvjATDjl9wOCXy1r6Kb5TPsiczAF2OBhCuAlvDKMNw=;
  b=CGqWjts3K3Ky02kdn0jm6NMFEAahIuChV9Ue/jQTyySMN1SB6uy6h86T
   q4Y9cv5bL11QZu+1gRrvxJ6E9IGZJmL7k1wBPVsKIpE1iBx8Q34BRFW+/
   8zRlvzXU5OB9jddyil/k816uqphfbp40WVbtGSc5qUu9MJ/VbjRnDlUeQ
   eUAdJv32aclygO9E6N4Y9LxYwiHe/zls0TlcsgNM9bZPWCDZjFF80nj5S
   33+G6D6DPyaIbfGBds6nZBUb973AAYFm//bWaSNeEUnwi0Bl/ffnc+zdr
   97qZeZXCDFH8Zdsl8Yc8zcRP0tTp6cJHmZVKQALhxy3GrqHfJUNGtw3Sr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="304685726"
X-IronPort-AV: E=Sophos;i="5.95,178,1661842800"; 
   d="scan'208";a="304685726"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 22:04:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="659800032"
X-IronPort-AV: E=Sophos;i="5.95,178,1661842800"; 
   d="scan'208";a="659800032"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 11 Oct 2022 22:04:11 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 22:04:09 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 22:04:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 11 Oct 2022 22:04:08 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 11 Oct 2022 22:04:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eloBu4b5ztwGqVpRV4wu/hCzojVPK/Qoq6ytN2dJYNLfPxEhqexjh6yHhjPi14sOZgI9Z6FKoYO+bCpSYtEEFd/GXWhcisD9qhA/PS0+TdA44ZG0DL1FsvBlVF9MAFvvidwtKM+w0Qtcc/TWoqgihZ0c/3Gla+QQFjQUMImOsKD/7lBzkNzO5xfODVz6E+Z7DQR8KTUnn/OYaXV+22Ufj6oxLLgRv3GzrU1kVZJvimFtCbplbIASQgQv1640rOijk4vysIdKRC4dGA3KLIcUg3PyOGqvLA+uHYe+6Q3dpRfpGF681C/dzjpvS+52vZ0F+/ruwvNLSn7Q3n+OyJ1ORQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aj2MFIaYGZyntyUNLQAqtsXDuvb0/laZroLZQvvAgcY=;
 b=WphMUEUzBNUXecgxkU0SE23ysr5nvk/kmx+UdskzCSMDbA4MojAQIyoudN4RjxFRT+KW5ED4Xi+Fy8Xj+mlewa3O7aUQ/CDk1I3SH5spd3rZkuJ8sP5Dc2Ttj8IpZArepfRwv8Rxyn5Amd+SasIPr7IVENc0J+Op6R71H2QBJ0vewbTJwM00wESQV13oR/bF3/MkRMtz53UMRFfFOvAFw5RVDB1YYzg3WioXnPvELZyxp3QPSaHN4CXlKFa12nGqXzaZnEtPPS4VfQtfPN8dzR+jOEoiD190P+pFhzZg7FP8fI7VwHaXf0/nWmwyY4aeJgDGH6oL0KkgzqzNIc8U1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by DM6PR11MB4596.namprd11.prod.outlook.com (2603:10b6:5:2a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Wed, 12 Oct
 2022 05:04:05 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e%5]) with mapi id 15.20.5709.019; Wed, 12 Oct 2022
 05:04:05 +0000
Message-ID: <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
Date:   Wed, 12 Oct 2022 13:09:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <linux-sgx@vger.kernel.org>,
        <tony.luck@intel.com>, <jarkko@kernel.org>,
        <dave.hansen@linux.intel.com>, <kai.huang@intel.com>
CC:     <seanjc@google.com>, <fan.du@intel.com>, <cathy.zhang@intel.com>,
        <bp@suse.de>, <tglx@linutronix.de>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0137.apcprd02.prod.outlook.com
 (2603:1096:4:188::17) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|DM6PR11MB4596:EE_
X-MS-Office365-Filtering-Correlation-Id: 3719ec38-7b48-4727-82b0-08daac0f2fbb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JKbUb6avSFwwvVp5rJn6t4dFjeP3BBQZOaZPGV6z08ON00lLzOct7P8PMsyNu2cbGs5ILxgktgPK3SDSbcWIjCkbzZZSWNTPHiAaHmkXqe0Ap7jgCyrQxO3voeDDn767Uq1QxhL5Ra8tS7dnWZD1Qh74lq0WrJNqyuDzKvwJePym4N5h0xGWfeRG9/tFr5jmgDptlkh8Pu6BUDjjLYGfT0SzpDMNYoYOajMn5G2MABpzp30qc9Fap2OqYK+4zyCMPdcsTOdW+FY/ZelOEGAyzu+4ZvDDENjTmGDQq6SK22NGRI9/LDiJG4ZHnDDOAi3t9Cip70/nhs6pheMgUKtfnVo3RdZ5XpCrzJcLl9jCl2QLwADjVMD6OpCWwAoNx1pHDiMMdwQ5TnYsvg/MoL9j09a1G+W11hi6aRTuac6znJZLy+VC1DgWWE4h/cdTthSTYfrG6WfzNWcUQcK+8WJNudbJzGj+roXRccCYva9hCGDAAq9F5Z7lKuG4ankjFkt6Z9P5JkY7v0dlM0QYvXiGBlAJB2PF5ekexrNy5UhV//oS89ss4KBU+KdPhG/x0ArYjQyU29dlZDuPFVMl83n564psHb0JcX1KDrlMbaMAc8pdVXZh0EPRnZoQXI4v/Z18IdG1LD04s/M5JSRD3Wyxgyf9VnAMnoDaaacx4T8xqDrhrOx81HGPvfscQSbwnaDUaCFZCkj7HChpJpp5Lx6TCMcfiX7ByOR4jlX9fxWIVI1Teg6BcnvVtJSz8MNdhAFzYYYMLuq1EN7WdNFIv3C2uUEsRnDrbrawzPRsS5RyQHXAQ+cWSeyiDtz44EJF7a6SBdxW9s8000Z9ZBXz6Uk9mmNq9MsrYUtycM4nbeRUvILJFaWwG4UW9DioXXNf2sjG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199015)(4326008)(8676002)(5660300002)(66946007)(66476007)(66556008)(31696002)(6486002)(966005)(478600001)(6666004)(6512007)(26005)(6506007)(2616005)(82960400001)(38100700002)(36756003)(86362001)(8936002)(41300700001)(2906002)(186003)(316002)(6636002)(66899015)(31686004)(53546011)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXN1MHhpVkE5ejJraVdwYmxqbytTNmFUYnpnOVlWcTNlQ0N3ejJyaGVNWXRH?=
 =?utf-8?B?RFVGOWNNZ3hWWExla093MnY5ejg3MDBXejF4Vk9MdmoxM2M3NTZPYVpyVlZQ?=
 =?utf-8?B?Sm9HRDFRRXloKzhHQTlsR3NnaHROc2RQUW5kUEJ4T0p5dDJVYW5Ha1hHSkNk?=
 =?utf-8?B?RFhyRGh1eitCZkZld21PY1NHNHg4UStQSjhtSFZxdW9mVWVuby85S2lHbzlC?=
 =?utf-8?B?bGpIR1hpTWlvQjJ2dlVnUGpxR0VTblZzWlRFK2JybG9yOXJBMkcyVUZFUVZw?=
 =?utf-8?B?cU1lQ3BIb09Malp4ZGVJMWZ3YVIxOFJPdGhZV1BRMmFMS2VzbEVPclVxWWJK?=
 =?utf-8?B?RldTZVU4blcydnlEL3RoeHBjckVJa3FzdUNpSmRLR3dJRWRBLzl3WVJ4SzNJ?=
 =?utf-8?B?WUk2Q2hIRnA3emVaVXIzN2hzNEdaQnQ0VEdnTDVoK2wxU2t4UFQ2TGNFUEhF?=
 =?utf-8?B?R1RFZGU0NEEwMWR6K01OSWk0aER6a2hneGloVnRyMnBTVnV5SURvaXpIb2E4?=
 =?utf-8?B?Zkc0T0Zud2kwbkk3K0xkRWNrQzh2K1ZXSFFrODg1QnZPdEViM2MvSWg2MUVO?=
 =?utf-8?B?UUYxSEgzcndqbXdvKzA4Rk5MeGlTN1RpSFFQRUZUcTVtZXRwaHhad241NGpW?=
 =?utf-8?B?QkppdDdiUU02NUZOTG5FQnY3cEN3TFJaRk5HMmN1SXhIcXZwU1NyNUJ1bmdy?=
 =?utf-8?B?NVVPOVhWY2J4ZDcyemNSTUtGanlHS0lNbTloY0pLdHBSRVdLckJ3ZnRmLzNF?=
 =?utf-8?B?VE1xSWVDSXFkU2FDQW5TK0JCUzl2OWR6OExxS1F1eERDVDM2UjdMNmJlaEVp?=
 =?utf-8?B?blZ3MFlTSjUrWEwvSVhSc3l4WUVNL25rL1lGSTNKWnovV2U5ckhaamwzNG5X?=
 =?utf-8?B?VlFFMThkWE13MVhhRm1zMEtKeHFwSkJMSnhtdXR3cUZaYWtBQXlsM1VvU2lB?=
 =?utf-8?B?TUlxaFpIdHFwT2wyZmdSZzFrZnozbVdxa3BJaFkxM0NGMWlBZ1hQc3dGL2Vp?=
 =?utf-8?B?eHd0dGxaQ2Qwa1hiOCtTY0tsRjV6VGZmRWk3MUk5Y3RaVXFIeVNlVmx0aVdu?=
 =?utf-8?B?cmV3Z1B4TkxFRVA5cTBuWUFYNDExOGxwVDNXZWsxRlBtZVZ5MnptaUdCQXFl?=
 =?utf-8?B?eW1OV2M2dnp5U2VOWnVleVhaNkZYeHNuQU5neWNlYVlvL2JYRjlWREVFb2Ft?=
 =?utf-8?B?TmVtVURyZFI4aG5zTHUzMXhBcWVUL2g3TWFPdUxuUW95YXgvY2RiQWh6SCs5?=
 =?utf-8?B?ZVErNFAwZDQzZXp3MkZGMVFlRWw1WFViZjA5eHJZNVFWV1I0ME1MMGhjenBs?=
 =?utf-8?B?ZTNJSE9xM2ZHSURwS2RBOSt3eTVtaCtoWW9WNWdrdzdZRGZSZGpUK2lLc1NJ?=
 =?utf-8?B?a2tmQ2FTZno0U3RCR3l3Rjk2ZVVwbzZmZmRneHVGUm1ZMEFmRzRydExla1dX?=
 =?utf-8?B?R2hDcGNNQTlLczB4cGkrMjN1TnhFS1lrZUd4M0trRHp3TDJIS2RmTWZib3BY?=
 =?utf-8?B?WjJoUDdLT0MwcTFOVWpmem10aDRtZ1kxMGU5ZWx0bmE4b2IwcUo0ZXlrZFk2?=
 =?utf-8?B?STJ4OXhSMjN6S01hRjl6bnBrdkRDcEdSaWxzeGxwVlYxUXo5Q3NpYUlCSjdm?=
 =?utf-8?B?YTRIcC9CdFpKVEVnZjhyYXlpWmxzUVdsamR4MlowcElLelMwN0FabUZCRHhL?=
 =?utf-8?B?d0IvR1hlak0yTytkd21rV3FXZU1mM1ZFczhhcFp4b09Xc2ZPVlpmK1BwUTN2?=
 =?utf-8?B?bnF0Ukx5WHdxQnhDQ1V4aHk5SldtbXhrdkk5c3FXSTl4R0FUR3lsVG53YkFB?=
 =?utf-8?B?M2twak4reVI5MWJ2VkFEb2g5dEhLWC9nTmVWZDUxU25wQ0FVVUxlM2l3M3Ev?=
 =?utf-8?B?OGEyL2ZjaWRubUIrd2MrVGhabytvV1UzRmpxMjRIUUM2ZmVncllSYnRUdHMx?=
 =?utf-8?B?RGhTc1lLT1VrcENvOHo0V0ZhSkJWRGIwVTYyS21JdWJ5YmhhbEg5dFV4S0pi?=
 =?utf-8?B?VEFNNmViT1BUZ2J4YmFSd1U1NU1BbXMxRTVGVHZpQkZESkVaRE9QOVpZdTdD?=
 =?utf-8?B?bDk1SFJ3TDdnS2pFM0hqVUVCRHRKRGtXK05ySjFpTWZ1OENQelYzeGNwRmR4?=
 =?utf-8?B?TXZZZDNMOWpGYnYrRmplR2lUMnNTZTJVenRmMFJ0b0k0aGI3RUZvSHFBSnZz?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3719ec38-7b48-4727-82b0-08daac0f2fbb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 05:04:05.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6dJq4zf/jKqJxXkI3AQG/iB8yBx7dH8EeaWz5yHpKJap/hrrA96no6LR27UyULiV9v/Ed4PPY0GfSda0JucO/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4596
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/10/11 22:04, Dave Hansen wrote:
> On 9/19/22 23:39, Zhiquan Li wrote:
>> Today, if a guest accesses an SGX EPC page with memory failure,
>> the kernel behavior will kill the entire guest.  This blast
>> radius is too large.  It would be idea to kill only the SGX
> 
> 				ideal ^
> 
>> application inside the guest.
>>
>> To fix this, send a SIGBUS to host userspace (like QEMU) which can
>> follow up by injecting a #MC to the guest.
> 
> This doesn't make any sense to me.  It's *ALREADY* sending a SIGBUS.
> So, whatever is making this better, it's not "send a SIGBUS" that's
> doing it.
> 
> What does this patch actually do to reduce the blast radius?
> 

Thanks for your attention, Dave.

This part comes from your comments previously:

https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m6d62670eb530fab178eefaaaf31a22c4475e818d

The key is the SIGBUS should with code BUS_MCEERR_AR and virtual address
of virtual EPC page. Hypervisor can identify it with the specific code
and inject #MC to the guest.

Can we change the statement like this?

    To fix this, send a SIGBUS with code BUS_MCEERR_AR and virtual
    address of virtual EPC page to host userspace (like QEMU) which can
    follow up by injecting a #MC to the guest.

>> SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
>> being shared by multiple VMs via fork().  However KVM doesn't support
>> running a VM across multiple mm structures, and the de facto userspace
>> hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
>> this should not happen.
> 
> This is out of the blue.  Why is this here?
> 
> What happens if a hypervisor *DOES* fork()?  What's the fallout?

This part originates from below discussion:

https://lore.kernel.org/linux-sgx/52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com/#t

It intents to answer the question:

    Do you think the processes sharing the same enclave need to be
    killed, even they had not touched the EPC page with hardware error?

Dave, do you mean it's not appropriate to be put here?

Best Regards,
Zhiquan
