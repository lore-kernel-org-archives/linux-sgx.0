Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA86C433EF
	for <linux-sgx@archiver.kernel.org>; Sat, 14 May 2022 05:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiENFjG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 14 May 2022 01:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiENFjE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 14 May 2022 01:39:04 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FFD10A0
        for <linux-sgx@vger.kernel.org>; Fri, 13 May 2022 22:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652506741; x=1684042741;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F5weoM1lga8K2QAiCAiuZpS/qEcvXAeqPgAPy+Fs7t0=;
  b=kZdi4DmhIQElRFeLPsuJ3iMYtLnuDwwa5Vj3L33vSulSKHn9JVomJ9ro
   8iVR8DAiRc3C7PcS5XhD+rakcAsBJ1BGSCE2+acdN+4mCB5vR8j605P+v
   LmA83mmIKB+FGrgdGDyHvy0H0MZM5ktzpwI6+eTEZuq6J8hznk3hKvLTK
   +pr8u6guvwDfmS6AaWpFXwcrWLpkv/n5S/XIP8sbxrgIvqH6YwdvNU3fN
   eN4VqzEf/ZEDkw1MysWxMEHC2m00jD/UkwozUPAm2arjzCM70Z9TTjFWk
   NhylsnoGmH6Ls0ldu+a8RAa4aZFiBMGiHANaLn9FSWjQjY+qaNUbwkbPj
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="270147490"
X-IronPort-AV: E=Sophos;i="5.91,225,1647327600"; 
   d="scan'208";a="270147490"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 22:38:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,225,1647327600"; 
   d="scan'208";a="659406082"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 13 May 2022 22:38:59 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 22:38:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 13 May 2022 22:38:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 13 May 2022 22:38:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaC14yrIYhHn9KFsAfZPfO8TwNT4e8LgL6es3gbyrmmLXMDNsWlKyTyZhpldER4HVE7CoJep1kckmhWquPExF7M5mjc2cnKq9PLCCadT4XtWZKuY4oAHW1skNwuqWAOtDYNoKC0o083FfNUGY8lHWZKRvqwFXc1mm1lgGVFGQSefnZReE82GPZ/ZJCtEIgxD0sc2jywtIWOKZ90m6WHoJdI9mjl59wLSJcIkEKufG0Shmg6OZKJVhfZ41gyIal8n8gfhkwQHyZMejwMJFEawUQiKOmqoZcPZe0X/OR4NTowwYl0qfydfkbTFUgkLNhhTyenySpLmqzeJONqz730G9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arLE4zSyLTHQhZvmJAaa6sPEyzETMqR4iWwNrlUpaMw=;
 b=Njy1zA1rFVU6AABjDumG/NNHr3bETGw/XCCXn3+yLe+RYlulgrVPQPwZGybY/tC0R1lVhKw44siC2Y9NKm75W/cc8HYKt0TVWPuupBLRGTiEYRBHyc9x7gBDLkcZa2jjHJOXx1kN7Mkz2b/Kc9B2Gpvw9HzNo4KEmrXDgpsx5cAQbC0r1mltNlnyG70TZ/ooEYlI4ZCoEQ9UCaIz8g8VoYKhbO00iNBbINMDgMyDombm9p+4l1L05qcYztS6pO/LT4Xrz0NKurxqXGLXAuA2JeW2k7jneOtG+bf8j953G8aqG5+1I6vTPHNS1RF1+nNSn9wv2oDR0ecxKYsYCYa6RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by BYAPR11MB3590.namprd11.prod.outlook.com (2603:10b6:a03:b2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Sat, 14 May
 2022 05:38:55 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342%7]) with mapi id 15.20.5250.013; Sat, 14 May 2022
 05:38:55 +0000
Message-ID: <35284def-ca7f-d42b-164f-1c49eb8977ee@intel.com>
Date:   Sat, 14 May 2022 13:39:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Content-Language: en-US
To:     "Luck, Tony" <tony.luck@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Du, Fan" <fan.du@intel.com>, <zhiquan1.li@intel.com>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
 <YnuQJaM0p7gD5qel@kernel.org>
 <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com> <Yn5tPS0aLXBgHtYT@iki.fi>
 <55ffd9475f5d46f68dd06c4323bec871@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <55ffd9475f5d46f68dd06c4323bec871@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR03CA0049.apcprd03.prod.outlook.com
 (2603:1096:202:17::19) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 386cfe7f-8d92-452d-f8bb-08da356c088f
X-MS-TrafficTypeDiagnostic: BYAPR11MB3590:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BYAPR11MB35904CE0169D1DC230AF0C27A5CD9@BYAPR11MB3590.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4/IR+cPfgu5bOsxbe2WzVhsa225ie+6dvKml3AcSHBl5AOXnNaQIWAauwWJjNY5vR1bf876j4qofuApRNo+fM25I1Inf9XGm5xiFKT2apjmRCT6iZZz7afqQm5W92idCjgrdbPzAEFEJsFW5CPW6UuOQYOZ7rOSuM0buLi5PzuzJJ5havTrP9L2iv02SfVe46CbOY4e4tcfNKfOmg6Lwj+h5x1GjySn2n0nZ5XTfCWXUjEL2vTCFstp/kPFJJhWKLs4x9XEryg8Hym1qJMboeStPrf6UhSrXI2eVoUPshRghXAeEoLAiQQ7rbSgIHDUSUMvhbbdkvs1BG0JDdNNI1zTL4YKMLZ+zvLMqeM7umft2c5XeoLLfJC0DvacSMgJwagbq+JXMQMcm3/og5zE6Kup1264amugYS6emMhRXIBtOJEElgu6qDN74EIPPCTB/ZGpjnbwUY+Yj9T+8ylbdRKrIasx/yC4QEvFmkdb97wIcoCtojVcTUtWNTihNvfhmqb/GO+T9YHraA/fQ3k8TtaDyblyRT7+Gzta0jofeG1Igb8i/XHmh++De2X5scKd3PF7uRdgd9AgXoFlpXqeBemYRsQnVQoE9dr+bfMYBpMmeFCwihbd/LTsSmkkCIg4auRxKdnTrByEhH+aFxaw8F5jDqYgWl04bypYKDdNJCjqyEDD+zLmmxelm2HuErqgw8FTp6FKD8eFx4STfX8Mdk7XZRx5Dm8/ztlwpC87yF+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(2906002)(186003)(31696002)(86362001)(31686004)(316002)(36756003)(66556008)(8676002)(66946007)(4326008)(5660300002)(66476007)(8936002)(110136005)(6486002)(6666004)(6512007)(2616005)(53546011)(6506007)(26005)(38100700002)(82960400001)(508600001)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTZlYkpQbCtkMVkrUjlkbG4rdTB1NTF4RnhZRlJqREtZRDkxY1JDWEhHb0F1?=
 =?utf-8?B?U1hCZEhTcmRSeHJYMCtVdWpGcWRDSlBVenVQNWVQTFBIaVhiTEcrMEZneC8z?=
 =?utf-8?B?V2ZJaXJrZjIyS0FqQmxBYzFHNnVsOXJGZ29sbUp3YnJVY1RHdjZRSVBCaVVB?=
 =?utf-8?B?STZtU09wSlNxeCtEdXd0TTRTblRUSkJRaUdyRStrSy9YQmluU0RwUWEvcjBL?=
 =?utf-8?B?Q29vVDhXL2RNbk1jclB6SHNscnBPb0NZdndUb0pLMkRQU3djSzRLNEVIWFox?=
 =?utf-8?B?d1Q3WEFCdk1rZTRkODZjRUxpZmVWSVE3YXhDa1RzUUMrUHQvdG1XeE5TNS96?=
 =?utf-8?B?R0NLMDRMMTBwZkw0RWM1ZVoyNEFidERROFRvVFpFbDZyRlNleTJUSXhpc1dq?=
 =?utf-8?B?RHErVXpoWHZYcnNXcnJzL2hQVXhNTU9SbmI0WTlvN09CbHY1d3RpdWh0OWli?=
 =?utf-8?B?RHBNMmc4QWlkcWpLYjRQTW4weWJPTWdwc3o4UlZEY0tDMUk4S1FxNmlwWERV?=
 =?utf-8?B?TEhZbjEwWUxjOGxXUnVocy85WGZPQ1BSQU5nMVRTa2ZSM1dZMGdIYzlkN0Ev?=
 =?utf-8?B?U1VMeW96RitnSklMTzZMWlFJWWlNM3BocFBMZTBzZkRYREwzOHZST3lIRjNs?=
 =?utf-8?B?TTRDTkNRWWxXTmpaQzZpMzNSb0xhMWdVTXBHZ3ZSM252Q2ZmcUNHZGd6T3B6?=
 =?utf-8?B?QTBYenFUU2NyNU5KY29JS2UxcmtCdEtDeUkwajhvRDZkVmVLMnp4UG9VQWkw?=
 =?utf-8?B?N1dvMHZpMVE2bitLVys3YkRVZlBYQStJTXd0RzJ4OFFkWjZMc2R2RytYL0JM?=
 =?utf-8?B?ZXcvSkJQaGxHTDZKZzNJbHpZVzZHVmI3dVdoUHB1YTNrSWJBSnJGZnhsYW9O?=
 =?utf-8?B?SUJ4Yk1sZTdFbzl5dHQwcjMzdDM2K0UxK0IxWUJLN0tEdk9vV1hjUXpzQzhi?=
 =?utf-8?B?MXBCeHF3aFVHZ3VyeEZMSFZldFlpUUYxUG00SFdXWlhqVlhCQ3BzZzJRUUo1?=
 =?utf-8?B?Zm52Yy90L0QwMkhXbG53MDFUY0VmZ200MGEyblp5ZFNybTdnTGtJRHlYQlk5?=
 =?utf-8?B?THRPbXNGNk5wU2NtSGRTSDZ6UktHRDhEdmprM3N1ZHJ2WCtDaWJZNmxoRDhv?=
 =?utf-8?B?THBaZmt5eW1sb2oxU3RuSGtMMkNjRTZPRUc0V3lZKytIbjRjelpFYWQzN00y?=
 =?utf-8?B?WmVyMGhhMWhIZDNIc3FtZmZOYk9iZUd2Um41a0ZYcnh3YXEvZVJHVkVkajgw?=
 =?utf-8?B?cjZqNFVPU1lodXFhY3o0aHNqN0J1K3hScDZwQWJVaXZ1M0JpaXlGZU45azFB?=
 =?utf-8?B?NXFvSGw3VVF1VmFJYitITlhtQzVxMURjbkxHS2N5M1FRYWMrSUF0K1lYaWNN?=
 =?utf-8?B?REFkSkhUZnBtQkswTmUvaGZEK05LYldITEpWL2pLV1NIWFRpbUgrYUZsbVhz?=
 =?utf-8?B?dnliQWZ5TzdzcXRkSCtGaHQ3SkZ2YWVYcVBpeHVuNnNhcmdjcEprUGRHMm1l?=
 =?utf-8?B?bFAycE1KNExpbGd0VG5LLzFWOFNpaWFienNSNk5iZlN6dlAvdjZ2cnRIRmxG?=
 =?utf-8?B?QVBKTnV4UHlua284ZmMzY2ZRYzhhNFRvL0RaZm9Sb1RUQ2lORTh4eWVuT1lQ?=
 =?utf-8?B?aWNsZkpQRE9sT080ZHBOVzREVjVjNGx4NExZUHpKN2hwcDJrSk9pS3VoUkpT?=
 =?utf-8?B?Mmk3ODJQa21UMEc0ZG9JeGc0Q0FxTjNiOHZ0azFHRlpUZCs2SkRWZEZVNzdK?=
 =?utf-8?B?K1hqNytKQ2ZFR29HaVVqcndoWVZNNkRVR1lWVUpZNjVqeU9oZnFOREZ2UndX?=
 =?utf-8?B?bFZmenhHTy91ZVRwUXNEdXpyOGdUM3A1Q05VQm03NUhMOXFuYVEyUXNwKzgr?=
 =?utf-8?B?dVN4USt3OW9oL2VudWtLRkZOUWs1V1pncTQvSUp4aU5LVFB0OFV6OU5QUmhx?=
 =?utf-8?B?SVZaLzFuWUZHcVZOQTRGRzBqVkVZTE85U1NGU2dvalo2Ym1jcjZBa204Zktl?=
 =?utf-8?B?U3k4a3AveE9yeTdrb25RS3lwRmVRbGpsTkh4Z254TUdoM3NTQSthUXN2YzV5?=
 =?utf-8?B?YzdpVEZRSVZwSGxnd3ZZUXErOXlnRzkrM1VIRzVNWjRkR3pNQ3E2bE1xOFhZ?=
 =?utf-8?B?ZG1zdzdwRmV5ZWRwU0FaQmp2Q3pkWHZnbXdWK05UOE93SkJ1OFU2ZEtRSEda?=
 =?utf-8?B?T1VPWFI0aVBwYVBWT3JXdUZHb1pvUzhlZ3M3S3B2MjNMMDhwUUtPc0k0Nkx4?=
 =?utf-8?B?YWVZM3dZMlBoTHVhai9aMWx4SUZuUkcxUzB6Qmx1L1RGUWFqVWZvdmtVa0x4?=
 =?utf-8?B?ZVBjaXdYdHN3d2RRWTVCemlvSmVUMkpuU2Z3eUNWODh2WEhRM3krVnlTd2JW?=
 =?utf-8?Q?3cDZHimyorBV7ho4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 386cfe7f-8d92-452d-f8bb-08da356c088f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2022 05:38:54.6489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KWVCS3AlD0DQhwkFb55tMjR4C2dA8+Cx2VHG9037fq+GS/Bvx+BkavZOzpEP+fE4vF8bS8A4TnvoTj+wBcOEtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3590
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/5/14 00:35, Luck, Tony wrote:
>>> Do you think the processes sharing the same enclave need to be killed,
>>> even they had not touched the EPC page with hardware error?
>>> Any ideas are welcome.
>>
>> I do not think the patch set is going to wrong direction. This discussion
>> was just missing from the cover letter.

OK, I will add this point into v2 of cover letter and patch 03.

> 
> I was under the impression that when an enclave page triggers a machine check
> the whole enclave is (somehow) marked bad, so that it couldn't be entered again.
> 
> Killing other processes with the same enclave mapped would perhaps be overkill,
> but they are going to find that the enclave is "dead" next time they try to use it.

Thanks for your clarification, Tony.
You reminded me to check Intel SDM vol.3, 38.15.1 Interactions with MCA Events:

"All architecturally visible machine check events (#MC and CMCI) that are detected
while inside an enclave cause an asynchronous enclave exit.
Any machine check exception (#MC) that occurs after Intel SGX is first enables
causes Intel SGX to be disabled, (CPUID.SGX_Leaf.0:EAX[SGX1] == 0). It cannot be
enabled until after the next reset. "

So, I suppose current behavior would be gently enough, other processes with the
same enclave mapped should get rid of it if they really need to use the enclave
again. If we expect those processes to be early killed, it worth another patch set
to archive it.

Best Regards,
Zhiquan

> 
> -Tony
