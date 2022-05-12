Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52485C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 12 May 2022 12:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353533AbiELMDM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 May 2022 08:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353524AbiELMDI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 12 May 2022 08:03:08 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394EB22A8A2
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 05:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652356987; x=1683892987;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bl1F/5zJTBwJIzFcQN6FW2nh42FuAOL4dECHCzTDwJw=;
  b=mtTQeEJ1Vg+I5JMyawyOQuhU/1mSmvwQlrnTZXWdPwuaN6SPsLOoEHQz
   9OPuLTywMaTolUL/48OHEMtls3wnly3SUu+fvSpL0YERSEDOO+cSIYi7f
   ajp3l1lLlL3K6pOYWOPHmJMa0U+p6f3vS1CrVnMZ5KaryJ/bRry3fNgpk
   An4/qxxW/rO39sHsKSsQhQbBQ2LQ5gDPWhpzXAc8HkF3ntBQxzQGNLSVh
   j/FxpOvc6K+f+fNJsViju+sqmF/ZCBBM8AbLZJ0K9qDPU6CTZ/Tab6cF8
   xhRud+iCWAndUuHO8xlCZ+OlTi1quXkzXJHfHOATNLlOJW1M3vmI6au0V
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="269654448"
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="269654448"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 05:03:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,219,1647327600"; 
   d="scan'208";a="895765212"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2022 05:03:05 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 12 May 2022 05:03:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 12 May 2022 05:03:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 12 May 2022 05:03:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0cukhHLwHXPqL88uTJuyuafwt0LKIRlCIVbgct1QD+Xb8VAoPVdLkWqqG2s8LdYwbuoKfcy0lMuJcA7MUVAXGEZCWb+PbvSKpZAb7Iuri0zaf6tHZMaUd8SS7ZfQzN6x4xd/UEGPV8Ir1e70ESB0p8w09xBXO3xVkHByGzaKUcma93Cj2GAC1YxADtO0sCZRf4vAFxUdFF++01dhL80s8dJaZ/v6HQQnNKplBGodQs7uGjZO2w6WGLD1zlXrdxoT5I78N7INlU7Ur/zQNewLSXq4y2QGwJVuGH7ugulpoKhwcgMWV/8DfUuaXC1puPREJxRfZFlJKtPJWfdtd5uJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcBXQn1uUBxNvPUJCur2leP+AjZ6rGlqm6j8XHsw3UA=;
 b=KlHwY1mRe/4JOJxn2gQ6qjvL8gTt4VUSbm6OuSTopFATKyE0mVy1AA+BHmeKYeYdHySk4YXkuj6BOzar2FL3L/nERFHdisEI99ls507BQd2tHyQqJPMUbVjEi/pqD4heePCAWyjo1h+nL223+CDBlmDOyebBr4uQZLAlW/+UZYCTduKnY6mz0lPdcjZ32cJTLnhc5h4/kAp/OqDd+d0uLto81Uz/K0BX+90q8royTJTCJ5v2Jwxh4Ru4CjibL3n+JrQ8zVBE8+L2gXAcoum/HKC8bj9wal7NyUjRrZu995L2LCVZvMczjNXlEAOGOwJmInoYg5hqHBgNutUsOc8P1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CY4PR11MB1671.namprd11.prod.outlook.com (2603:10b6:910:9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Thu, 12 May
 2022 12:03:01 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342%7]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 12:03:00 +0000
Message-ID: <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com>
Date:   Thu, 12 May 2022 20:03:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Zhiquan Li <zhiquan1.li@intel.com>
Subject: Re: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <linux-sgx@vger.kernel.org>, <tony.luck@intel.com>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <fan.du@intel.com>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
 <YnuQJaM0p7gD5qel@kernel.org>
Content-Language: en-US
In-Reply-To: <YnuQJaM0p7gD5qel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR0401CA0002.apcprd04.prod.outlook.com
 (2603:1096:202:2::12) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c80297f-f930-4bd1-b544-08da340f5c53
X-MS-TrafficTypeDiagnostic: CY4PR11MB1671:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CY4PR11MB1671B3DD2366C22277044CEDA5CB9@CY4PR11MB1671.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M/rjmDXj5y+Cu+64DM31tcxvewo97NYBYltIQA2YHkgZG/K2D77yEMRkVazwpOrK4Q3BTiW6DthqJgfr46vquWLo8+n27Absv8iCKYlo0KSWcDVk34+bcpJXMpRle9HMXYPlZZ14CN/A5+2/BGbRY/bK7Fe4T1SR97elqrZNbd9S8NDVKzeH3ZfmLovuNPK8sD4d5yYvKVCqqEBSL7vbMWQRW5Whwai4jrdStw9uHzn5zbSPor9zXPtlNKdpsCJVgm4GYmfUehuJClP1xeuFPxwsAyl2viauOOToak507zsnUdrvdTbKvhy7pfBpmYakUq6iidrEfEfohZsd9A4TiuNqaNjk1VaJ7mZyxhlWoAIFuPLeuhPqiqedbLa5u+h06DRCYEyZ8/ae6LfqGEYayXwKULeix5EyVQfTdvZm0jjgFaQOphViTrtT1dBRVH9tW0DbaJOcvKnSK3jbezwXG07v3bRQCPB6EnXEFs7/RQx6j2b8HcKerIgF9/ELVWheGj2tRecPFJJSPKM1rBecV8GYfEQihn8WeQJwmKzuKPF+8aqjcyFfvPuvhQ1h8gKdumE/Z7Bm9gmpFquNKNIAKF052ehDTpfvmBL5X1dTG1oUjUdCczm9Xmws5yBsjJGzRm8pL4VYKnAT5leSne7DOxwP5VgzV47D3WxT9t1ao1sLi0w9f2OdozinPiDrAHr74i6pL58iEg1NCr3xVP2IPhqcpNfU2X/46Eg7dzT0TRH0iKgNqdtxNChSt5WsYN/s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(26005)(6512007)(83380400001)(31696002)(82960400001)(53546011)(86362001)(2906002)(6506007)(2616005)(5660300002)(8936002)(6666004)(66476007)(66556008)(66946007)(31686004)(186003)(6916009)(316002)(36756003)(508600001)(6486002)(8676002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmNhYzZERlRYc1J0dWw1dGRHaEkrSmJDS3lxMlV1OW9jUk9oUGxTRnl1T3lj?=
 =?utf-8?B?Y0I0dk1ZRllHVW5RSHVFUm1HRTRSdy81N1dBbzhrSVpGOGlFUVZzSEp1b1R5?=
 =?utf-8?B?VXhIWFRad2lobEtTU3FBNFFnOGUrMjQzdDc5aHlOTjlndmZhM3BWUkN0VkdQ?=
 =?utf-8?B?dlFjVlh0OUlSZmYxUDhHcFZmRCt1emg4bkt2cDY4a05QQlFnUko1YWJLL0pn?=
 =?utf-8?B?dHNRVGJ6STgxL2pMWm9MMGRXSHcwL05wOWFleTVvRXdCOTMzUzExSGxvZm1M?=
 =?utf-8?B?dlpCSzhacWFMWmJ4RFp6cE1hMUxjbVFybEdNSjJaMUVCTnZ1eXAvZlpXNVpU?=
 =?utf-8?B?dkZtcDUrSTE3bkRUZklDWDZJTGt2bFZScVNFOHdabGFTbVVYRUYxdW5uNFNq?=
 =?utf-8?B?bS9SMER0b2N2bkFhczdlZFpMSlJjM0tvblBFSEEyWTdON05KM2puTElEWHUx?=
 =?utf-8?B?ZU1xSndoRjU3b1NpQ1crVDVkbjI2V2VGbUJFUzFYVVQwWEM2Y0J0TkdPdnFM?=
 =?utf-8?B?eXc4RHVaaDR2VjNEQ1A1SFNUV0N4Ti8xNjVVWm12emtydTU3eVBXdC9xdEJv?=
 =?utf-8?B?Z3R6bjdobU1XUmkwNGxxRDV0NUtVSFRqblhnKzJuaUJFeDZOOFcrT0RXNHhZ?=
 =?utf-8?B?OTQwUC9xTzNhR3pXQUt2SzRqczcxeWdCZnF2Qkh0bURmRnBpbk0rRGlzSnR2?=
 =?utf-8?B?ZnRhbGZCSkw3SlA3ek1LNm90RHIxK2g4Q25HRmJCb0YzVDdNb3F4SlIxdzVz?=
 =?utf-8?B?ZExQcGJxU2UyUURCdTB2ZG03NEhIa1UxZFpVZi9YT1FnZDlXbmxZdEZkRGZj?=
 =?utf-8?B?WWxhemRsaVJ4cU5ZdlhCNk9talNHMDFRNW55VWtqLzNtSjlwM0ZJT3lKVkhp?=
 =?utf-8?B?eVpoeTBQTDA0K2ZhYW8yVEJLMzhRdnpONmJlRGlWd0xpZEFhcXduVTFGT0Rn?=
 =?utf-8?B?VDRwM1dOR1EvZFJOUjEzRS9pUGVobHhWY21VKzBWcXI2R0MreWtGSlJibUFU?=
 =?utf-8?B?QUh6TkIwVXl4Y3hpREYrV3VzTWplZ3g0TGNMQ3RGbkhRL2FFL1Y2elVucTNq?=
 =?utf-8?B?YWk5V2pkUEoxN0N1RXJuUDN1bGgvSlVqbFNSVkNudytsaGc3SVF4U2ltRjIw?=
 =?utf-8?B?U2ZlelpFaFY0cDUzUG9MMmRmbXFjUzU5bUpSQXJLYVdZU0k2QytmaWZZTDZu?=
 =?utf-8?B?KzczOUt0VzF6ZGpDZHFJT0hkN3hxV1hidWxzWmtJSXFqcVVteXBDc3VkZTRV?=
 =?utf-8?B?VjJZRmxzem9yTmZmdzFTZDBrbjZuMlpHU25uQWVqSml4Y0NPVW5Jc1poZXp4?=
 =?utf-8?B?ZXNtZmZsVFVpNVFyWkhUei80QkNFTnZxV21PNlR1RmxqcTgwdEEvOXZSSGU2?=
 =?utf-8?B?SUswdE1TRmFkT2VlUjNVME9ROStIdXNYWnU4MDlxTEJBSU5tSXp2ZkxQUDkv?=
 =?utf-8?B?dDhKMHhzclFOcUhkbWNOV01EYlBYMFM2SzhIZXJCb3d6TkVxUGw3b0JRN3dJ?=
 =?utf-8?B?aVk3K3JwaW9GbzZyQWhkSkpGOXNrR2xUTVVQOXQ5WnlPaUVGVHNIMVAyMmRu?=
 =?utf-8?B?Tk1TU0EvcTQ4bkhreThXYjdFWk4rZlR2UkgwWjBkOU1pTlFLSWRleXFoemdj?=
 =?utf-8?B?MS9iTlI4dG56RFp0YVBFNFM4ejNKUzczaFFXRHF3YjNTTzQzemUyWVNsckV2?=
 =?utf-8?B?VCtVM1dWUkVwZTBKaFFUbkhWSmVZaFpWWThmckhVd0xhY3BsbGNuUGg4WUM4?=
 =?utf-8?B?Q3VXS2MyeGFiVHR2NUdrRVgzZmNjWWs2VEZob3kwZThiUDZ6Y2FyN3lNOFJm?=
 =?utf-8?B?aTU5WG9NcW1iK2tWS1RyREpEU2thK3NsZTZCQjJmbmRhLzhGRktkdmFZdE1W?=
 =?utf-8?B?ai9KbmQ3WUhrTHorNWV1eGYwUUlLRnFqTFNDQkNaTGpvZitJNlJvMmJ1Y2Nw?=
 =?utf-8?B?eitGT3llTHhXWUp3ZjFjTHpyUXdYWWE4RnlVVDI0QjAwc2FNSFRSa2xvSENP?=
 =?utf-8?B?OU4vWUdUQlNnSkxaaUY5Nk5GSkxST0JwWE83dWpBcHZrbzQ2RHViZnZTYnly?=
 =?utf-8?B?UFY0NW5xTFVlVlNONmlRa0RQOTRXcXBIejhuNmZHeTR6S21UNHRzTHVIUGd6?=
 =?utf-8?B?RzNuMGJjQ1RET0h4NERxY0tkRXNOdkVpRjJkRHA0ZDloNCtCV1gzVm5rSVNL?=
 =?utf-8?B?U1haLzRiSmd2bFJvTDdYanFmS1F4RUdZKzVRbVhBZjA0ZzZlMzhYMDJ1UEho?=
 =?utf-8?B?S01VZTJXVzhLdkNvb0FzQVQzdjZGOTRmOUdVbmcraTh6UEdUbys1VUlWYW8r?=
 =?utf-8?B?bFlYTTRiNGV6aCtzSWdNTXBYdWpZUGl4TzU2amJYd1h3bUpwQzQ0elc2a2l3?=
 =?utf-8?Q?lcA/SmIZskFxNmGE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c80297f-f930-4bd1-b544-08da340f5c53
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 12:03:00.7771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZKgvEa58VrClh4uB09fMJZkBWR91okWaeuGJfcpd2S4jW7ACHf3toJq/kmmEAxpgeKCfkbRZFD4NqiH7tqsnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1671
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/5/11 18:29, Jarkko Sakkinen wrote:
> On Tue, May 10, 2022 at 11:16:46AM +0800, Zhiquan Li wrote:
>> Hi everyone,
>>
>> This series contains a few patches to fine grained SGX MCA behavior.
>>
>> When VM guest access a SGX EPC page with memory failure, current
>> behavior will kill the guest, expected only kill the SGX application
>> inside it.
>>
>> To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
>> information for hypervisor to inject #MC information to guest, which
>> is helpful in SGX virtualization case.
>>
>> However, current SGX data structures are insufficient to track the
>> EPC pages for vepc, so we introduce a new struct sgx_vepc_page which
>> can be the owner of EPC pages for vepc and saves the useful info of
>> EPC pages for vepc, like struct sgx_encl_page.
>>
>> Moreover, canonical memory failure collects victim tasks by iterating
>> all the tasks one by one and use reverse mapping to get victim tasks’
>> virtual address. This is not necessary for SGX - as one EPC page can
>> be mapped to ONE enclave only. So, this 1:1 mapping enforcement
>> allows us to find task virtual address with physical address
>> directly.
> 
> Hmm... An enclave can be shared by multiple processes. The virtual
> address is the same but there can be variable number of processes
> having it mapped.

Thanks for your review, Jarkko.
You’re right, enclave can be shared.

Actually, we had discussed this issue internally. Assuming below
scenario:
An enclave provides multiple ecalls and services for several tasks. If
one task invokes an ecall and meets MCE, but the other tasks would not
use that ecall, shall we kill all the sharing tasks immediately? It looks
a little abrupt. Maybe it’s better to kill them when they really meet the
HW poison page.
Furthermore, once an EPC page has been poisoned, it will not be allocated
anymore, so it would not be propagated.
Therefore, we minimized the changes, just fine grained the behavior of
SIGBUG and kept the other behavior as before.

Do you think the processes sharing the same enclave need to be killed,
even they had not touched the EPC page with hardware error?
Any ideas are welcome.

Best Regards,
Zhiquan

> 
>>
>> Then we extend the solution for the normal SGX case, so that the task
>> has opportunity to make further decision while EPC page has memory
>> failure.
>>
>> Tests:
>> 1. MCE injection test for SGX in VM.
>>    As we expected, the application was killed and VM was alive.
>> 2. MCE injection test for SGX on host.
>>    As we expected, the application received SIGBUS with extra info.
>> 3. Kernel selftest/sgx: PASS
>> 4. Internal SGX stress test: PASS
>> 5. kmemleak test: No memory leakage detected.
>>
>> Zhiquan Li (4):
>>   x86/sgx: Move struct sgx_vepc definition to sgx.h
>>   x86/sgx: add struct sgx_vepc_page to manage EPC pages for vepc
>>   x86/sgx: Fine grained SGX MCA behavior for virtualization
>>   x86/sgx: Fine grained SGX MCA behavior for normal case
>>
>>  arch/x86/kernel/cpu/sgx/main.c | 24 ++++++++++++++++++++++--
>>  arch/x86/kernel/cpu/sgx/sgx.h  | 12 ++++++++++++
>>  arch/x86/kernel/cpu/sgx/virt.c | 29 +++++++++++++++++++----------
>>  3 files changed, 53 insertions(+), 12 deletions(-)
>>
>> -- 
>> 2.25.1
>>
> 
> BR, Jarkko
