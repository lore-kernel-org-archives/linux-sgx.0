Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAB7C4332F
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Nov 2022 01:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKBBau (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 1 Nov 2022 21:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKBBas (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 1 Nov 2022 21:30:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E59A11C2F
        for <linux-sgx@vger.kernel.org>; Tue,  1 Nov 2022 18:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667352648; x=1698888648;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BaT6vbHY4F81GmPyir3VARD3k0X4kDUpYnqDtE9dU9A=;
  b=XjHSxUGJ5Hcd0bQNGGZJYM12LZMiaWSgYN7r/Vz8X46CoiwnH/pNZu95
   T8JIhg9sU+KIOmfFjNXE1mmS7EKQypd/n8vI3r+eXUaI2WQOVPdrKA2eC
   /elODxjJ7q3+Ioriu7DMDv6Hx0T5rQeNMHWYJNqTZpdI6ZjagRhWZct4U
   Cflqdd2lOzOv5hxwvUxEICv+a5mqEwMBIIO++/QWfzKN9862roYXbfoYz
   9kUsXPusa6xAiTUotTclpW2Jj1sgJImNOz4fdHTGFRQF6qjWHmKVMceSQ
   eVLblxZTW4yPDbZGIRsuUEHpN8tKo9E42xz2BcnoF9qtsv9yPJ4E1oEiB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="292595453"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="292595453"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 18:30:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="665363367"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="665363367"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 01 Nov 2022 18:30:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 18:30:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 1 Nov 2022 18:30:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 1 Nov 2022 18:30:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbMp+6+bFlH+eoTigp+KltDa+Jc0s5ONxSQc+gbeydD+/u8hA+O/gsc8A6xtGA3RrVXBwvZToUH6yVcKde5UidoIYnXgbfXuoJhGxk5MtZ+vlckZ7q21SnPM8yxFdLrYNIWWWFeyf9xXpOELVIV/shJYXsNoAFgQ6cBv4VfwWfd9o3kwe9zvOrDOshn3GFQrFp78zPyEe8xaRwDeewCpLgbGU6Yb8P6BOTct130EOaMp8xHhvJOiN8cuXSwCbgSKD1VgMzx4cJEFQNA4G8BH1ePp8DzAxrLp6C4ocscMzRk3lwqcfY/km9TTl9G/f+9nAa43Nv8ai83fFnYIM1fkzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcFZnY/Qv7gLTBoEbUW+FhA1s9oqKLxfkc4rCqj07Sw=;
 b=QjKewwOX8QeotWjwyZnPX8h6Frx87xuCZDyGvzMujRplWlTpalRYXbf5RLAlkMZggfK3+aLio9nKtuOp0UkWZPMTf4YmSyx0/DFuGhqBP6aZeQ9Q6wc8WDzJDLvlqgrWhye9AEijrcq4zf8Ny2gIXK17lIzkmJAIrkgN/nQ831NBo0nJPnWDzrWw5leVuHnw0QpFIZbBR6q8dGjNGMfKlYkFeFGoMy23qIC78m2n/fQgihIxrqLrrheWOv4NmGMO0W/9vXiOB4SGjp483jYQGB1UHQiA5UhnBKTSlZqxjw18e6nt2nk5BvPnCJLICgTPp1mN18v/1ibhOZWqCVLjsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by MW4PR11MB7006.namprd11.prod.outlook.com (2603:10b6:303:22f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Wed, 2 Nov
 2022 01:30:18 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e%5]) with mapi id 15.20.5769.021; Wed, 2 Nov 2022
 01:30:18 +0000
Message-ID: <ff40770e-dd55-e869-53cb-ea976bc5f63f@intel.com>
Date:   Wed, 2 Nov 2022 09:38:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
References: <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
 <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
 <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
 <4930999a-888f-88bc-a05c-86762504f059@intel.com>
 <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
 <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
 <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
 <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
 <Y1WmZgqIkl8GkR/i@kernel.org>
 <e8f1e391-0362-33b7-aaf6-45a685eba0a4@intel.com>
 <Y2BsSCM1BWlsqPcK@kernel.org>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <Y2BsSCM1BWlsqPcK@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0185.apcprd06.prod.outlook.com (2603:1096:4:1::17)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|MW4PR11MB7006:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d5f36a1-6dde-4f31-af42-08dabc71ccd3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A8jyXNU5sczd5uTeQrmKqh6hpjDqGOC/PmS/ETujq6XzSDjDwrRyYRI/wikSQOM0jwN5cohIs5XDks8ktmiKTZ6839zo+T4aBJ/kCuTdpjRCxks5Iv0un4YFVFqkg4J2pSl6dLIo87qLGZ0s0qdU8K2LwpKvI2CJwrNJSfD+mMcvlBvCfmptSaVkRAgCTvLMSSgxY5ixtxwIwpVJ60G+nr1F+Nz01n+7rrMuUoQ8ffXHmDjH1IGBT8BfP+RRvjdpcnad3jtx2wq2neivE3ha3B4YmSQU8EckQQlsbB48gUn8is02lAuh9bMmL/Poe1GlZTCGXtRxogpSnHP71+A5PiIYQlrEhA8chWlvsrjZzokSZHvp5PyhS5GBoJpaJ3rCdrmzpdWDVBDwRyDTMi+czOriZVnVB9vcbVRE2y6s4C1KPC1OiHXEs3sv9yjByuNZKIJIWIs+IZXinpNz2yRbwsBx954CMH4DajCx+AoId/gSNcvBpl1poGOLJQr9FmvgUmtnPGLmluDJMZk5/dl79o6RYVdDkIyw1GXQSiwYku1XWgUklO9b4Ppfx/mntDoM2uD+UROm0zyMxAbGc4StGS6Ko1EC2+csj3w8vUsqAr+EBGvYEi038Vp1uu6HlTPUYFh/Av8q55dVQ4ecvQ3SqfCRLBqTdHRS8T7RuDwBjwZjVmhaB8BpslX/pfyViXyj080qFG1RWUh6Li4c0dTiAI15teeKsmDDxD2T5bnev69SC1YedVnFJh6WKQQMvT/rfBMS/vu1W4KjPaG5DKpKS89aqyhd12G1XggKYkSvO1g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199015)(478600001)(31686004)(6486002)(83380400001)(66899015)(66946007)(31696002)(6666004)(41300700001)(38100700002)(2906002)(82960400001)(6916009)(186003)(5660300002)(36756003)(8936002)(54906003)(316002)(2616005)(6512007)(8676002)(4744005)(53546011)(4326008)(66556008)(86362001)(66476007)(26005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R29nc2doQ1ZuM05BT2VUVnVHeHN0dmtibTJIV3dNUkU0VXc2TTlXYUJYMXhC?=
 =?utf-8?B?N0Fad0NmY01ZOUZyS3I3dzlnNXUrS1pNVlF5V3JwRktBdnhLMS9UYU9XbEdN?=
 =?utf-8?B?WnpVb2MxaTduNnljb2k5aS9VanU1MzcrKzhQTlJJWHFzYVJYYjlhdDBiSmNZ?=
 =?utf-8?B?TFZoMVEya0hjbG9ZL3ltOWxqZTRURHMyRnR1WG0yaDF2N05DVVNHZzVQMFZI?=
 =?utf-8?B?dE05bzFXR3hCKzFrRFN0Ym9sbmdGUmFjampWMEQxTVB1TnJDSzNWcnVaU0Ny?=
 =?utf-8?B?SkdhNHVLNTgvY3dFSVBCVkJOaHVqaGZSQS9CbWxvZkRucVp3S1owdnhQNGxm?=
 =?utf-8?B?aXgreXBXaUtwSkpmV2lEZStZY1MwbXo5alpwK2Fzdi9hQS9udWNNYUo1L1FS?=
 =?utf-8?B?QXdLQ2VneUpxYW5MZTduUTV5MnB2dzd4QVJsUTZyYmxkdGtVV1MrWW1vbGNi?=
 =?utf-8?B?RWJPcG8zUXNNdEhPUlQ4aStQcEliMUFIc1AxbVd4dmlKUElNUlV3dS8yR0hI?=
 =?utf-8?B?djJsNHBYSDEvbW5LQjVtSUMzcy8rOXFOOUlicGJMWU13REZhbE55Q1M1UFUr?=
 =?utf-8?B?cnAxaEhCRmp4azNidThwaldHNitHZmxnS1RDL0dyNVlDakZXc1RzVUtGbjBt?=
 =?utf-8?B?cUNGYyt5bmdoM3o3MERkSXlCbSsxZFc3ZGFycDIxSlZra3ZjdkxpWUlwNTVF?=
 =?utf-8?B?SGFKWUlxR0lUMkdPaHhqcWJUekxqZjliOHdMa3hleHR4OXloSTJLenpyQ3lp?=
 =?utf-8?B?dDN2MFlnY21JeVkzaCtLcXM1Nk1Ja3FrU0JHNktISC9PT0JUZ1NTU1BMUG9a?=
 =?utf-8?B?YmI2d0NUenEvWGFiTkJYeGpVOFR5MGVIMzNNcGdNeERHWVN0RmVPd3hPS2JE?=
 =?utf-8?B?OWZVYldkOFVpaVRlNXdzajIxeHpRSmsyaUNobGl1S2tNSk9qMkhLZU43ZFZX?=
 =?utf-8?B?R1R6d1NhWnJQa1F1b09pZUlzU1JHMW5wcFpxVlU0YWZ4aDBiWWF4L0tRazh6?=
 =?utf-8?B?VjFaekJKSjB5dTY0dTVZYW1kWnNBT2w5c1RDeGlKWTBWT09FRWl5OUNFY1hH?=
 =?utf-8?B?dFo0ZFpwQTJsZUhwdFVKdFVWYzR0ZWY4cTEyU2Rzdm5EckxZTzcyYUFIY1NB?=
 =?utf-8?B?eWFYSGJyVU1GT3hKcFhwWER6U1JDTjZuSzJXWm1ybXRqT1Vnb1NqWXBzTS9L?=
 =?utf-8?B?RVVPOHlHNG91MGhmUXE0TXRXeFZHMDhnY3BrZ2hZaFFOYTA1Tkx2Z09iUEp4?=
 =?utf-8?B?bU1pUkcwd2R5YlhqNjg2SzB3NzFGQURaNE5MZmVyNDBXUW95WktKWHhDRStP?=
 =?utf-8?B?dldRM0NwT2ZOQ0piOFUzZVhzNjYxeU9KUXVFNS9EQWVMRVVuZFhWNFN4N0da?=
 =?utf-8?B?NSt3TnpCSExNWmlnbUNhZFlEckIzQ0lkYUJndnFQUVpESFVzSStKeFJyY0pN?=
 =?utf-8?B?d2JqZDVLOHFWakx0dEV2QTdwKzg4cjU3Kyt2U1NWQUxQcDFXM1VnbFFXVjFW?=
 =?utf-8?B?b1QrbTFMZXl5STVDKzJLY2Q0dlBsOXlablVyVXVNUjdHMTYvMHhRWTdmdlp4?=
 =?utf-8?B?T1BPbHN6M0paaDRZTEd5UnpjYmRmWkFJekU0WUozZkJ3bHpVaXFpRkFxU2or?=
 =?utf-8?B?YjFxMjh0aE93cXdOdkZCbGJYRGt0aThzUUtscDhad3JPSzAxT1VwL0FSVlZx?=
 =?utf-8?B?NlR5bWE1amxwdS9WUDZIcGIwMVIvMXEzZjdrd3JDK1JPaHVCdGwyN1JxYzBB?=
 =?utf-8?B?UUhqOXU0R2R2bG9KVmNZY1RXQlZxdVhZOTFXMjc0T0hiSnFaSHpURk1TZDZK?=
 =?utf-8?B?THMzV21GY1ZIaEZmUlNHaWhSY1ZVYnphbU8vWUI3aTJ3bnNVMTJ3dENZaFha?=
 =?utf-8?B?VDUydDJNc0FsaldSOWJBcnd1dWZWUnJmY3J3c251YStFZnNBWks4V3NnZHpB?=
 =?utf-8?B?VlJ2YjNrRkFnUDJ3MkJzUUdzS0ExeXJZV1BpZDhxMDhveFVPTFVrUjF0d0lO?=
 =?utf-8?B?QXRBOVNtbVN1aEhjcDZVbkwvcDF2ZU9jWWdrTXJ6ZUVXU0lJV3FhYmxuVDkz?=
 =?utf-8?B?c0V3T0hXaTdxOWxTcXlmYXMrUnZNWmk0UDBKYTVXbm1rUm1QRWh0OTNxOW1M?=
 =?utf-8?B?d21mVk82TG9NVGE0bTdlSDlKMFl4Mko2RWMybkZ5QUZSbm95Mm1teHFFZ2NB?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d5f36a1-6dde-4f31-af42-08dabc71ccd3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 01:30:18.3691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BWAKTllBstvBw35TKinxAyzuXEtWJJFlrK2pu5ML6scJbVjQ9/Lzmtyb4/1GH2JPGlkerpIQERn4ARZU3EejXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7006
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/11/1 08:46, jarkko@kernel.org wrote:
> Why would we want to enforce for user space not to do this, even
> if it does cause malfunctioning program?
> 

We want to resolve the problem at the source rather than just deal with
the symptom passively derived from it. For instance, we might be able to
return VM_FAULT_SIGBUS to kill the malicious application, but if the
malicious child touch the memory earlier than parent despite it cannot
use the virtual EPC page, then the parent will be victim.

Even thought it's not a security threaten, there is no practical
significance for sharing a virtual EPC instance. So we would like to
prevent it from the beginning.

Best Regards,
Zhiquan

> BR, Jarkko
