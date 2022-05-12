Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE54C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 12 May 2022 02:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbiELCSn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 22:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239106AbiELCSl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 22:18:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2C5DA51
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 19:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652321918; x=1683857918;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lOkEmHDngrGUfztUd80dnon/U7DFdu7DYJjg7uo3Eyg=;
  b=K15s752x/bjA6Q8o6qwTCAzByBzo8WuQYWNfWu4VpqXhp9eS3gTkn/q5
   xVL0TDbzpdyojLF/RMrWkeXnmStCitvLQ0Gt6kCU0ThTGFt4/OwCixgp4
   WDt5EaWTRJhLlEMne91kWURQ5p9+VLSaoVnkpYM49bagvsAf89KTTurqB
   hF7kE/5wgbUsiLX2BMdMG1wWdy8iXx5B6JsyIKWKsLYoF3YOBGda8jTUJ
   3R2G1n6dNUzj9bgBzB1cslj2mHtO+tVtE3CdzBCehsZPBTGE5L6vc+pny
   k3Dn95XNJm3lV0BYJCdlm3oYHm+K3vyncCJ29s3ctCgrpQEWYNybtUr2K
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="250393669"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="250393669"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 19:18:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="636655847"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 11 May 2022 19:18:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 19:18:37 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 19:18:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 11 May 2022 19:18:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 11 May 2022 19:18:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhtnUWXg/GyIH+AYGSbm57ktUBNkH47I2d4sN1HTm4LWdjAiQq6ThvCb9i6n6oRRMJMerBeBduNdvcx44+HOwdESoK365FaeWkP0z6rCu786y2VySokFs0bukRgU3mxUkn1wyuGfy0hbFxIy9wKulZeDKrnp6PUr2fizb+XEtZweb86qBUnwrxJRhbL4MZez8jnFPj4V1unZfdvXz/G/FyqXvJ7ZJd9idrXAR3PVnkQlZM0ziPenUitYoglKEcG2a72Na3CZHb3nzS30f3fxMSunpxcyzwmO5yVyWKoOIEduCNZvZv/svm2H0hNLjXpHN8xbgZ9Ne2dYwLFxCP/yyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0p3RSpnNAKBGyT+xf/wMSZf2n5D2zR3qrqf0qJomDU=;
 b=hN2DraiFbGwoJcKz3Tkg0NcohiyeedL719YM6lGbu8zbAN9hvSU/WIBYLuhkEvjKlW1h3yJilrvWB5hPmp7853mtu6M0BRS7DP/0Fm4wPZzVPhALg7D2fqqaoQUxNPcl9CSym3a1yGeTLY3nnbjzC+XHlcPQeUVjNddq2nxF97vkpOqGAg/yMg/gHPOenoURfp5G3eKYYlXqCCnuFmuMQrCaqAQmdUOiSyYMrliOwnt/a76f1Ck5XWAXc6vX4WNjErAmmKW7FNmbBTn9KCIyyBz+V9sQ8hF5RIdXxhC670UbEmKnfUbMAIgMTNN+pAXJQ2s6oL6EQbKvp2WihJ9ycw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by BN7PR11MB2722.namprd11.prod.outlook.com (2603:10b6:406:b8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Thu, 12 May
 2022 02:18:32 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342%7]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 02:18:32 +0000
Message-ID: <38d7bc14-80cb-b69d-753b-f8c0dc548dbf@intel.com>
Date:   Thu, 12 May 2022 10:19:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/4] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, <linux-sgx@vger.kernel.org>,
        <tony.luck@intel.com>
CC:     <jarkko@kernel.org>, <dave.hansen@linux.intel.com>,
        <seanjc@google.com>, <fan.du@intel.com>
References: <20220510031748.3181459-1-zhiquan1.li@intel.com>
 <c6b002cc4b6f979ffd0869f80742896fbe668376.camel@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <c6b002cc4b6f979ffd0869f80742896fbe668376.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2P15301CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::12) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8658dafe-eb4d-4126-690d-08da33bdb601
X-MS-TrafficTypeDiagnostic: BN7PR11MB2722:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN7PR11MB272252DA28266056EDB1EBF6A5CB9@BN7PR11MB2722.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3oykViyYQ1r3in1rdddqL8JV1yiS4hsTeV6j1jzUANy41uJJy9/xV/0nm/dcgdJW9JE8dA5oywnpVVjDDaZMiHPGr2Q8cRlnsmF//k743EMnG5DNiEEOhJ0xtrgM5hs4HpMFoXjpx5ZG2SiBARxbIRDD0ajZg0q0rht7u/hEc+s4JAoWC8miLlDdPo3SQepnj3xYxXey0v9q8qmXmdK/qEL1XH+zVyuw/l785NdG5hhFh+frEpLlEFzbxC0rVO/VPQ2Qd+S9cTwR8J/XQeVjCTQoq2Al0kmpddFfMs74q1xFUoMpHxn2N8+S9S/M7KA72vN8uG4JlF2F8TRxlhsjdQgVpRYDoHuPNbm5gkYvKWFieapGsu6tP3kHhaBHeB2zffD1/lQWJXCWu8oFy38Gy/glyv1aCsEY5KZgargtgtZ5sypoRxHNdu/Fzt4yJWQjDaKlEFjEc9GcjzsmxSUZp6ty+ufhHkf57qf7R8urphFyc9bBZZObFb20zh9uwznLzjdwMMREfEb0BEm1LmfjvXQ7dPlzeiiODaClKG54f3JqchEelRtCGo+IdyjUdbW8lszwWh9dzMuTBJLX/e5ivtAeNbQHGWK9yKb58h2Oq/2KUvOSB8on0CliYCyI4llg7Ii+GJg73w/gXpPCq/ZJFjDDLTxU28ubJPXzHLbhk2cuxnS41wRoDnbM2CBqcJkf3t1VI3yby/jMcm62wgVgENe1UZplBWvv0dDE38iv4GU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(31696002)(6506007)(31686004)(2906002)(6486002)(8936002)(508600001)(2616005)(86362001)(26005)(36756003)(53546011)(6512007)(6666004)(186003)(4326008)(82960400001)(8676002)(66946007)(66556008)(66476007)(6636002)(5660300002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlRiMFJwa3doaHdrR0ZqalU0VmUwb3Y5bjRTVjhFaFVmR1JoTWROQnAwYlpm?=
 =?utf-8?B?ZXJ3THk5U1BtVkkzbEw0SWFJVnRvSDd1d3dxSVhqV2czMzVSZVFKMWFiM2t5?=
 =?utf-8?B?eVZ2ZUNnRktmcm13WWMyeVpKd05DVTduS2FHSVZQNlFzZUJ4bFV5aHpRbDdD?=
 =?utf-8?B?dXFWQ3doSVJ4cGJab1dDNjZES3cvR2tSYUtuVTJxb3EvMUJFbzRES1RUNUtl?=
 =?utf-8?B?WmtCbldWbEcvQTgxQVZnS0RhL1pTR1N2dVlKbW96MDBCQ2I0UTc2SWhVL1dZ?=
 =?utf-8?B?T0xYUzNYQkJocDFyL1BDNC9pZ1hpNUVzTkl4amRDZDhoUGR1c0RSaXJNRzUy?=
 =?utf-8?B?OWNTa0NjQUhCbHlyclhXVUtoMWlENUFaaFBnWUNKTnpPU2JQc2J4S2NHaUxq?=
 =?utf-8?B?NDFuNjk4WE8yVVh3NjN1ajF2KzBUK2srcUpGSmRWMTQ0cEI2UkFQYUl0b2ow?=
 =?utf-8?B?QStXMGo0V2Vyck00STRodmNvakFIdUc1ZW8xbU9udnNuRkVsdHQzSDk0VmlK?=
 =?utf-8?B?UUpwaG9zSWxiSWZkYUNtTW1ZWUp6bHpXRmF5TlVXUmVIZkM4VFRsUGp4eXIr?=
 =?utf-8?B?OVFDVDhGcUFHWVdkemNlVllYeWpHcmNMb2tQQkhXSVBkU1ZkUzJpbGJGRHMz?=
 =?utf-8?B?UWR6V000MU8wQmhLM3F6b0UwM1FMc1k2NWhxVW5JMXVtekNJR1ovUlU3eDMx?=
 =?utf-8?B?V1ZvMkpsZGcxY1F6Y3Y4aVFJcVZpZkFjTFA2dVRJbjE4Z1A1blRlaTZlYVg0?=
 =?utf-8?B?ZzRRU0xYMVVpL29jYzVZM1k3TEs3VGhaZXNhc2pScERkVGVVWVlZTzYrNVNC?=
 =?utf-8?B?dXhOMnYvS0x3dW5BTDRRZVcyUjFTaThDZU9aSVdWdXBBVUtRRmt2b2tPc1dt?=
 =?utf-8?B?M1hraDJ5NDc4aVc2Um1HTDBDRVRjS2wydjNTVXFMQzdSeHkxOEx0Nk1RdWhj?=
 =?utf-8?B?K0FsRDZpZy9MQXFEZjZDZTg5VklucDVtYkVzQXJUVCtMYk1lakFHMFZMMkZn?=
 =?utf-8?B?dWVvV1poTk1yVzBFaHFjK3ZCRXNERytIVnEyNDQrbU1GNWo1R05GejdHTHlw?=
 =?utf-8?B?TXVEem1OV29rN0Zoc2pnQkxlcTlrNnlZeVA3UVI4elptVDV1MER0RVUxb1ox?=
 =?utf-8?B?aDNBTlRwWDZ1T1lFT0JmYmdZeXg0b1k2NnNsNWFkelo5Ky83U3pGN3JBZ1ll?=
 =?utf-8?B?L09qRXBUNHZVYjN3WDkzOHYyREQ3Y1JpOTRDM0xpdTNaaVYyNlU1aXRDY2t6?=
 =?utf-8?B?UFlUbDFPTkJ5K3BTVGFEUVkzbGROMmxKcHd2cHliUjZ2OTRDVWU3WkpYcmox?=
 =?utf-8?B?WlpSeFBuN1hpNGdmSFhoSjJJZEUzRnl6YUFiTlhDOWtOQkdncDh1dG82VW1y?=
 =?utf-8?B?WGZOQ3JzMEJRUmltVWNvT0MraUQyZHFVYTJseFk5MXhHWkhDMzBMM1BhaDQx?=
 =?utf-8?B?dEJwWmlBREdvTEZsNmRSWlhqVjl6UVhHYXcyei93Szd3ZjNYcTZwcEpFR2Vp?=
 =?utf-8?B?dTRRTVFZVy94SElPekFGMWZlT2VhK0F5V0N6YU9vMFU1ejFWSlZpVGlzN1Nu?=
 =?utf-8?B?MzZjeVRxeTdJV1pkSnVxNnNzOWJKVXBTeHBaSUNib1ZIcFRWanB4TnRaM05i?=
 =?utf-8?B?eTlkUWxLdGtHQUowanV1TnBDWE44TnlLUm5BWWp1S0wrNC8wcHpqVWpxMXJq?=
 =?utf-8?B?QmJnZ0h1QUVPOExkNkRhREZJYXRraHVXazNycGZhYjVXUmlvcFFESU1tWlR6?=
 =?utf-8?B?aGw4VzduSHJnRDM3WXkzTGRIeExvdTc2MXJmaW9OTzJPQ2MrSjlKOURGVjVo?=
 =?utf-8?B?dVZXakFqdUdjWE82a056am1WdCsxeGJ4d1RlY1ZuZVhSQWpDVi9vWi90WjZS?=
 =?utf-8?B?TmVmYjVCUGc1MXdVVVRhN0R3L0d3bHFkS3hpS0pQd3l4WXpjWmpIbmZDK2lV?=
 =?utf-8?B?VDZ1ZnJXZmUrVzNsMndra25oSTROaGhRNUNkTWkyb3BzRHFCTGFUTlB0NG9E?=
 =?utf-8?B?ZGR5VXd3ZnMvZ3pJOUEzWlVaaERmeTVNUUw1OFlreDVGRlQ2ZWN2N3hWK1lE?=
 =?utf-8?B?Tk1EVkRsNXhOWE9hdUdzRWx5QXRQWTVXcFhDNysxZ2dIdVpEZ2VnbWpzRUMw?=
 =?utf-8?B?WElFS1p6MHdQemJjSDB5QWJHSnF1SHJCZXNDMUJ2Yy9ZZEVKdlpmY3pmd1Iy?=
 =?utf-8?B?RENRT0RiVE4zTDIzelAwLyttQlo1YWZWT2VEaGd3SkkxOW40UHc5T1YzakJs?=
 =?utf-8?B?TW1WYlJRRTgxMFplRERqMTk0aHJsUkUvR2xQbGJNUjlXM1FRQlBHc1Z3eCtW?=
 =?utf-8?B?Nis4TVpabmF2dmVkVVNpRkxyUXVYZUNkQlVtYW5oZ1hHcDhHckZBNXY4ZmhO?=
 =?utf-8?Q?cTxdW8tyG8zSyIDc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8658dafe-eb4d-4126-690d-08da33bdb601
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 02:18:32.2821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ncLmAJjKhK6dWgQG4YZVgqlZ1gSAXIWP3CiXa6dp8Dvz2KFfoavc582srgYTjaiCY9/2AKdlrgVFvuPgrIBPkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2722
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/5/12 07:33, Kai Huang wrote:
>> +			ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)owner->vaddr,
>> +					PAGE_SHIFT);
> If I understand correctly, this sends signal to the userspace hypervisor, i.e.
> Qemu?  Can you elaborate how is KVM supposed to inject the #MC to guest, instead
> of Qemu process (the VM) being killed?
> 

Yes, here we use the facility that Qemu already has.
The basic call path as below:

sigbus_handler
  kvm_on_sigbus
    kvm_arch_on_sigbus_vcpu
      qemu_ram_addr_from_host
      kvm_physical_memory_addr_from_host
      kvm_hwpoison_page_add
      kvm_mce_inject
        cpu_x86_inject_mce

1. At first when Qemu init, it will register sigbus_handler() as its SIGBUS handler
   at qemu_init_sigbus().
2. At sigbus_handler() it will filter-out the signal which siginfo->si_code is not
   BUS_MCEERR_AO or BUS_MCEERR_AR, and then re-raise SIGBUS signal.
   If the si_code is BUS_MCEERR_AO or BUS_MCEERR_AR, it will invoke
   kvm_on_sigbus(siginfo->si_code, siginfo->si_addr), go on handling the signal.
3. kvm_on_sigbus() is a simple generic wrap which will call arch specific
   kvm_arch_on_sigbus_vcpu()
4. kvm_arch_on_sigbus_vcpu() is x86 specific implementation, it will do following
   1) Convert HVA (addr) to HPA (ram_addr)
      ram_addr = qemu_ram_addr_from_host(addr)
   2) Retrieve the GPA (paddr) as per HVA (addr)
      kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)
   3) Add the page including HWPoison HPA to its hwpoison_page_list
      kvm_hwpoison_page_add(ram_addr)
   4) Inject the #MC to guest with GPA and si_code
      kvm_mce_inject(cpu, paddr, code)
        cpu_x86_inject_mce()

The rest is guest kernel uses the existed MCA to handle the #MC. According to the
physical address (in fact, GPA) find the applications and send kill signal if the
#MC is SRAR.

So the intention of this patchset is to enrich the information when sending
SIGBUS, so that VMM can use already existed facility to take a proper behavior.

Best Regards,
Zhiquan

> 
> -- Thanks, -Kai
