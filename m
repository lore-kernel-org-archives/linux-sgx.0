Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45816C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Sep 2021 20:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21E5761164
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Sep 2021 20:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhIWUl2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 Sep 2021 16:41:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:59173 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhIWUl1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 Sep 2021 16:41:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10116"; a="309495133"
X-IronPort-AV: E=Sophos;i="5.85,317,1624345200"; 
   d="scan'208";a="309495133"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 13:39:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,317,1624345200"; 
   d="scan'208";a="653787971"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga005.jf.intel.com with ESMTP; 23 Sep 2021 13:39:55 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 23 Sep 2021 13:39:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 23 Sep 2021 13:39:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 23 Sep 2021 13:39:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIR6Ky/OLICoXnhsVOfunpdPCNVmkSsvc8c2Z5Fe7iOox2zdjIns0joUOzznBssGQPhnSVTOpU4uYuYVVKiKHzmgrRkhOi7DHlDey8yVL40FWWfKJMB5jENQj4LVjDLUTf5KD+kWWHHTIof5dh282pccbfdTPlcS81QiLCuTqMHWV6c+ysPxGUFq+PyaeZkJpoGmNTT/dbNLkjB7GRSOqNOMCVmYISLuvUjK9pCbkL+YWuHo68bVy9rRs9lAAco7SpPUy9DN//gbU6G9Up22RGYG1XMTAUgWbFEjPfvfjk5l3n7w6n7gznXGiw4Zy59CGxv9rdU44CtIaikY/OddSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Y9Kpg1+exaThW3dBVxTV7iZ4uNvC3oq32gcK2ukygFo=;
 b=kJnPbUb2ddFlr1l3Ajj/tXgaNIUYXzrsjAqXQ27oIk54rhwC02Tx2Tbnp+9KoxQlMUosbXp6q/pElpAfviZdv08vHkf6m6oNBNUOuc12I+V4Hw6Iu6DWLnQXu6qsRWu96BTsszzdpvXUZ67+rMbV8d7bTBOFrKh76McfRIiUygbAHqzkmLVJiaYEp1zZovbh+SBBQdUn2bqm0371uFM6tzOOofHsv5oJXq8pPSqEeqsmGVonyGU6Ot0od8R/LUS/EKjvuYqLTVoM+GD+D3yGFA42oLQ9LpUn6gvrgrT6Ltyy6ykhIqwvQXonPdCdRlF64gLWLMIP6gz1iPnvV13Jwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9Kpg1+exaThW3dBVxTV7iZ4uNvC3oq32gcK2ukygFo=;
 b=qeawc8oyIK3NU1ejtTyhjuSvrKRUVl8SPmTF+68l2rakF/X0sLCa0R+iT7sNBTtXzfMdqWQFDWUUgYS/KbZ9oKTVtFpqtwrnz+PnvTjvBNeqpYOFI5npTxWDj0jlSihHH4E8O59r8UFx4S06bKmyUvqUGPwCqJUfpea4kxOuXjY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 20:39:53 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::d47c:525:2aef:f6a]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::d47c:525:2aef:f6a%3]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 20:39:53 +0000
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
 <f45245ba-41b8-62ae-38b5-64725a214bad@intel.com>
 <254864594af4cde213a37a4db527e293a1ef1d7a.camel@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <0f75a6db-27e6-dfc5-4025-e81d8e753e30@intel.com>
Date:   Thu, 23 Sep 2021 13:39:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <254864594af4cde213a37a4db527e293a1ef1d7a.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR15CA0053.namprd15.prod.outlook.com
 (2603:10b6:301:4c::15) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
Received: from [192.168.1.221] (71.238.111.198) by MWHPR15CA0053.namprd15.prod.outlook.com (2603:10b6:301:4c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 20:39:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fae05510-ae56-4a92-0d03-08d97ed24c2d
X-MS-TrafficTypeDiagnostic: BN0PR11MB5744:
X-Microsoft-Antispam-PRVS: <BN0PR11MB57441E640836D92957701E36F8A39@BN0PR11MB5744.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ETDEs6Yrw7pcHAGhr6EiXDc/88CUN6VgoJu7zI17DLqk4ZZ2x0tbBSEgCisrBFDZKtlVcZ5OVPg9JfK1XtI9pc0VgY+QHS6p10KBP1WHKAMttebfEVOzhYIeSvhkkSRgJp5MWaK3Yicck08tovz6iqFZikmvuBvp5nNwar0DKZQ0klKObDX04O2yrIXQg+BgkxrGEERHug0X+6QwCSWVOnwmzijKg6qPPxkozR9vWqz2TBF7kImeI+w2vQsc8GabhalSfQgt4LYjoGbA/56qTlL/ZD0yBLpxGYpX6JEnzW3Hef1mvEq7yCzkDhhfXcdjl5Ydu5WZIMPKB3rLBA/DG+T17aCJUQNpQoXF/PPhSmTwNbIToHPrOr/GA/EUf0RyNF3qwmVnEfsTS889s0K7NFOA/fY+SnBmjO+IctmjJHlKjXQYL+wxut/Y9QDjg0kvj5ZvUaZ/Ft8BSNyDNimkGPXuQUige5beTIakAF2ek/pWhdFsbeK8i7CweaKd1y6MMqOxt4Pz87ckIFJ1pbc9K5omlDEuDmjjDH0bJkVR3Ftx/ecApHCwQqHap5Mq0nK5caN7psssl43amN5Zp0/SJ51LbSeWUMAzyQESZGEeBBIQ/zXEokKGI+09jW/AJHEXAboIjS3wuYz/e8ty+lKnBKC3eViv25yvEFC7fTSILTHE3G8o/VvZIpMmvV6wXXeir5Q+6IsAeZUF7UW91lurKo9geKgMsQ8JIyiTq3QS6Ss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(16576012)(8936002)(31686004)(8676002)(66556008)(66946007)(7416002)(6666004)(110136005)(2616005)(956004)(26005)(316002)(4326008)(66476007)(86362001)(31696002)(38100700002)(53546011)(508600001)(6486002)(4744005)(186003)(44832011)(36756003)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFAzYlh3VG85TGllY3czQ0dqK1JIRi9Oa2RBc2FzMERwd3o4VDlkVWdSeDZ6?=
 =?utf-8?B?LzJ3RjhXL2ZPR2hrRHhZd1hsUEJocE1IQ0YwUDltK0d5MlVMWlYzbHdpUVBx?=
 =?utf-8?B?OFh5ZVJORXltWlcwTisvL2ZzTFpyd2FNMHBIMENMSHdva2JveEVPUzBTSTRP?=
 =?utf-8?B?QTgxaEt3REYxYXcra2F6eE5TUXIrU0JkZXg5cUdjR0NFQVZDVjc2T1REczdy?=
 =?utf-8?B?c1FHcVBGWHdlQXduY2hRSUJqOFl3WWtkbjdmeE9mSVRQV3RSSTJZSVRDc3Ro?=
 =?utf-8?B?bzN4alFrVUx0d0dWNjloeUlLQW9VTjdGZ202bVd6TURpMHZDWThyNjMzdWdI?=
 =?utf-8?B?NTQyV3FaMnd4TmRCanpvMUJqSGMveGthZis5elZ3Y0tYNGhpMkl6TkdkWG10?=
 =?utf-8?B?aHpmZnNKd3BTZnBVYUFWK0UrV1VoTUtmUkZUUkNWY2VTdC9Ra0VmYUlOd0dm?=
 =?utf-8?B?bHlDMlVwZTZOZmwrK1I3anRUeGpYcFQ3bVB2UGYza3JsMkF5aGhuMVBZUUps?=
 =?utf-8?B?OFBlM2lDVEFoWXV3ZTkxU05uU2M0eWVKZkRlUXppQ0kzYmdoeHZJY0lpNEJZ?=
 =?utf-8?B?UXVvS094T3FJNm9NL0cyQ0RUWEhQT01teG0rUkxJYmhoa1IxU2ZZUmovNUpp?=
 =?utf-8?B?OTRERktUZnBWdlBKVmtNS0ZJSjdHMFpkaHV6TUlPdzQ5eHVNbzhjRVRUOFor?=
 =?utf-8?B?MmUyci9wcFI0N25EcXVZQ0tSb2liS0hVM2dBc1BEeTlYbUJZM1E4NldzSTI0?=
 =?utf-8?B?R2dKM3NvcjF5RzFEYXh6bjUyWGFKK2tPLzBxZzQra2RNNmNwZ2NvY205aWRB?=
 =?utf-8?B?d3MyQi9LV3Fsa0hINVdHdVdTRXo3TVBkY21rMENKNENkbkRzVW9uTGs0ZTlw?=
 =?utf-8?B?WEswRnJ1UmNiZ1N3MGEzTkVBNjFHMi8wYUpRMWlTeDF6TzB1VjRWYjRDc21h?=
 =?utf-8?B?Q2crRFFBSE5IeE95ZEZRVW5Wc1lJNXUwYTNmTVozbE1acUtpL0IzMXVhVVBG?=
 =?utf-8?B?ajkxV1ZROHlGOHJFVytHUU1KdGhVVVRpeklWTzVDeVhGVmkvZUs2VVRQbkxB?=
 =?utf-8?B?WnhudTR0bEJ5eWYra0FaOFhKemdtcUx0VEZGOHJicEJ5RUplM1FzbHJXTzJN?=
 =?utf-8?B?c2lTZkNIRVd2WHl5cDlhVllaOTdIeExWempOd2s3NXlZYVVFcURlcFlUK1Ru?=
 =?utf-8?B?TEtqRTdhbXhRSndWbVh0ejBpMkV0RituQUlGdnBzek9UMklyRWJnK1BxdndK?=
 =?utf-8?B?OWR1YWU5MHg5am1qWFdqV1BHcXI3VkQrTFFZcGY1aVQ1SmZQNS9YekxtTFc3?=
 =?utf-8?B?VkNjVmhEN3Q1TlRySEd0d0RKc1cza3hmSlIzaUs4bFZITnZXYjNXbDdZVGJL?=
 =?utf-8?B?VFdweFM2VmUyYzN0VTR6R2U4SkswY3R4eGtCQXc4eFIyMHdtc1U4Q09wa0l0?=
 =?utf-8?B?bXREZUo5MC9OSzFJaERBRThkZ242U2hWdEpFcVZhTXY4ckxRbkg3Z3N3U0dM?=
 =?utf-8?B?QWtreVQ2RkRJZ010eVQxWXM2eUQwdWYzMUFxeHNJV3NIaWZHQVVQMHRiSXZ2?=
 =?utf-8?B?NjFxWThVQm8wYlU5Q3JuZEcyeVcvY3B6cEE1cjh2VzFxeDRzS0VlNnJGNTdt?=
 =?utf-8?B?STFiV2tSN0tURzNpa203UDhFRXorVVh5ckZHSm1xaWt2TnZrUVpINzlBR1dw?=
 =?utf-8?B?aEJsTjNKckxlVUNNQmQxY1RiK2FjN3RFTHdxMHNsZFNmRzNLN1FkbEJpRWlw?=
 =?utf-8?Q?+fjNGbJa5INMDkyvYHQA3DHVhRFFSbWXjHR1yGz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fae05510-ae56-4a92-0d03-08d97ed24c2d
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 20:39:53.7561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAePbUgaai5wbeuFO+rsyjwvspnWVa/Yh5kfKT0zh+O/edJyA1fJxbIoc/tounJwvMcNoMqeq51gLWSXzjYCweNaXbjMR58KYWat4SBqOG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5744
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 9/23/2021 1:30 PM, Jarkko Sakkinen wrote:
> 
> So cat you pick these patches to your patch set, and squash
> this fix to it?

My patch set is focused on SGX selftests while this series target the 
x86 tree. I assumed that this series would go into x86 separately and 
after they land we can proceed with the SGX selftest work.

Reinette

