Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FE5C433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 18 May 2022 01:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiERBCQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 May 2022 21:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiERBCM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 17 May 2022 21:02:12 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123836325
        for <linux-sgx@vger.kernel.org>; Tue, 17 May 2022 18:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652835732; x=1684371732;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l8Kav4Pt+2pHi4/MBf3B7pzkDoc+k9vBsfnh4CSSui8=;
  b=EICxGz4bJlNaAaN4kP+Gbwrkw/tpSDtdsLfuX5as+wF2usRojyAIgDLe
   Vn8ybB4jq6JONjjmcRo4ozX9wAhgGql0BtBPfCgzMDzn9yEXoqWFzEqtE
   hZqY5tqmz+PVMZHFS7VwhHa6LbA5tM/bFlJLjvgMrW2jpT9Ufsuitrc/T
   iycjOG77nt3ovMvUBfNlGG7XrQUtVZPHXbfIZ58jbfkK37L7tomTHO5fU
   qasYkpkhCYTmYItoKJNNSyYG4Ft8vRiXtK42+lzyf5Vrirho9YN8z96eF
   P2yP9X/PJAdDHZD+busB5D8IBbr0eNR6Llzljto0fE9dYJ1ejPNj1Wdx0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="271103431"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="271103431"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 18:02:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="605619855"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga001.jf.intel.com with ESMTP; 17 May 2022 18:02:11 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 17 May 2022 18:02:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 17 May 2022 18:02:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 17 May 2022 18:02:08 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 17 May 2022 18:02:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ej7ysGIzH3hUmkauX5rtaG8/JMdqDMxWPg9QQBeorztnByDZTx+bTOIma3H/K+6OvNmzgtFhKGMtqF5fSIHzMN5HcezULxYZ7NzEfm97LpH0kNVLsBcufkd9R0RN36BaeykX2qMKm4yC9g78cpo0sk0GvFM077f3WYparuND6oh1viVZY3Vxpof4pArklw+RHuQF4r4REbkUDhU0LqhH5Rgx15NgqAfTQfQpO8zMHCVPl6ppM2y/37+Zt7tRpJfMgbJ0CwmEPFuWV54PecLVqBw3wfimZ2fDi9BXltwYhmF3RgABY9V5MvsOcYj5Mz1r7KsLlX/UmffXYZWN95ij0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZlOEBxtYJuFlESvJklUptBTPrWT4oy1nlujTXLqA8w=;
 b=lFmt2U4Nwi7v2tloC5Kgc6Hm9XwcDbFlgUlLlTOiHIZdeyDXN2I46mh3PXRr0MaO/6dpI6yurB9FChaY7jwrKfDVNuksw2d1LO9kgeVRvsXGv2H3R966aS1gT6FltYXjE4yAC3w76uD8CcKvFrIwx30kZEvpz7okLD06tF1WRuzOcstVsLJPoiUVM5uTfMwTftTKTvh02VFm6NEfJLEq8Iw0J6ySf1Xlm0rgJU7j4A4Zy0x01FvjaQDbefX/tE2tVim7OnKJ8gVuoloyVkMXuFQqNqbwgH+2k/dMaIRlEyTKD3LijMeh4LBrqOjWYAuHo+0wXAefCF804gitRKj9WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CY5PR11MB6212.namprd11.prod.outlook.com (2603:10b6:930:24::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 01:02:05 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::6ce5:7fe5:340d:e342%7]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 01:02:05 +0000
Message-ID: <443cb425-009c-2784-56f4-5e707122de76@intel.com>
Date:   Wed, 18 May 2022 09:02:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Du, Fan" <fan.du@intel.com>, <zhiquan1.li@intel.com>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
 <YnuQJaM0p7gD5qel@kernel.org>
 <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com> <Yn5tPS0aLXBgHtYT@iki.fi>
 <55ffd9475f5d46f68dd06c4323bec871@intel.com>
 <35284def-ca7f-d42b-164f-1c49eb8977ee@intel.com>
 <968e75d65a37ff7ae21f84875b78fb1ebbbef33d.camel@intel.com>
 <af6b22cf-bcc5-d1c1-e183-fb47200d58ab@intel.com>
 <52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <52dc7f50b68c99cecb9e1c3383d9c6d88734cd67.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGBP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::21)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c805887d-d271-4d13-0870-08da386a0681
X-MS-TrafficTypeDiagnostic: CY5PR11MB6212:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CY5PR11MB6212FCFF0FE152F849065194A5D19@CY5PR11MB6212.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGWQAUwu4w9ZmgBZpq7oKzTSK6awBo9ffm9j6DSHdJr3iYZbsQYfAHXQTBb4Evej+LdEGj6tpO/bEBRMcj8HSLbyO5DcYCoaUeQvb1c9NJe8iuQn3jTozn6kob62b+C0SPrX77VHeWpLEcOK8dOUeOcN8Rgky7LTo09RdUM7w2DwFtwtQUNP6NVl1hw/OdPUuK+IoyoA1ve/TpiIwNpx4LlDXOU1MOpRdBhmQcwtvRxo/KyKeEJsRzbiUnfY4jW1e94ovkexVvTjF7NN3cWPZBRImrpKeo1qPyqIIyLD9UvUViCKripw5EuFuP43tKX+CQoBNb0lQQOdLTwrJXTzFdhwSz3YhJIf5inhZrYRKYkleJDCJuI8Hb4QQKxpBCwk74f7Tu7ZS/Adyhl8UKtgTtWWuAgNQXU7MXGu8XCGts+XSh7fWcz6S/d+a5HrVuEcc8JIet8qd58AyolrrLX1y9TDmZBVTCDnBih9RDFzW0N4j2gKF06eatLIqvQ2kvcvvv5FQthh7/BYEGFvdbXKkXk5rcQsaYY3Ym9d9nyexKMQ551B9WVdMl6jw+IHWGQlOFTmVmF3k1+3hJj9LJx1F/YwC1AyzbjIbdJOAYWFlY/4HFTfFPh2dBAjFrXcM/ZRxJHWF8r9YEM9/mMV+B3yg81v9ERHIVBPYIxZHkApvYzk74GYQy0ntr7sq9EpRFPsC/lwxBQ04u8sHyOFNDfGhymWYcxhQ0aV2aQ1mF1w2+4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(6666004)(508600001)(86362001)(186003)(54906003)(36756003)(4326008)(316002)(6506007)(110136005)(26005)(6486002)(53546011)(2906002)(6512007)(31686004)(8676002)(83380400001)(2616005)(66556008)(82960400001)(66946007)(38100700002)(66476007)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aG1jT0MrelE5b0ZJcXRjTEtTcHNweVVtRjJ3WnUvMzFMMEp4ZmdJMFFlYXRH?=
 =?utf-8?B?Z3ZQaWpWajJDZFZiRDdYQSsvTVE0bnRJcEZ0OGxjakg2QzFxUUhKRS9wZ0xr?=
 =?utf-8?B?b3VBVWYwMkNEZ0lWOFFSOWltN0tqang3Z0RWdEFreG9aS0dPZnFaYVlGRXF5?=
 =?utf-8?B?dnFHcmV2N2VOUHBEKzBzWlJGU2MxQUlnVnVFM0lIbnJXZWRpNWtOWHR2Wkkx?=
 =?utf-8?B?MHlLaEpxY0gxVXg3eks5ajdGc0xuNUI1TndBVGpEQjcrRFB5THR0dUdGZGh0?=
 =?utf-8?B?NnBSWUlCU1lUZnhzNUR6dERGWEV0eDdGMWZvM2F6U01HcG5OYlRQempyMnN1?=
 =?utf-8?B?a2ErdnZweTlwaStrTTE5N0I4WVNnK2ZxZzN2QTN0WXVqQkoxUXd4Y0hYcVpN?=
 =?utf-8?B?WmNZUWJSL1Y0cHhFYjR6TUZXNnhFV1d1cG5qeFN5Mk5WMzQ2dXdjSFJsbWRR?=
 =?utf-8?B?V1o2S3JDMTdMbW1OL1h1T21JZWFpQlFGTlRpYnVFWGtVaW11KzBjUUQ4ZlJR?=
 =?utf-8?B?VXkxbWs5MzJQUmptMHd4QTlUTTNHbmVYdzR6WEhnZFVZL1lCZWYyVEluUkh1?=
 =?utf-8?B?OG9ENjJTbWtBVkczRSsyNDJKV2JuNWYxWmUzaEVMR3cvbWJMTTg3TUZLeVRs?=
 =?utf-8?B?RHBhYzRwazhDUHhvQ0lWZ1hURGlrRDFtRGNNVGt5L0RIRDVhcllHTG5VYkdw?=
 =?utf-8?B?RzBHa002WktsaFg0SkFLMUdmeG5HN1R0WmNVajB6TVhnTTQ2VlpkN2pHT3Vk?=
 =?utf-8?B?YWVLT0hTeUlWWThSQW54NEttYWVJTU9pMDlVbDVsWitvbmc3aS92VXpoZzly?=
 =?utf-8?B?bUQ0aC9EZWlXRXZoZ25rRWIwU3M4OEUrRnlJMTQ2ai8weE9rWUp3M1RRd1BW?=
 =?utf-8?B?cnNudkx3WFpuVW1DY1NHRTMyL2todUJxY2pUWWhiOEt5SzZlWmt1M0hJYWEz?=
 =?utf-8?B?ZWl5MHQraTgxMXMrWkRrWVBEY0R2dWJCRnNGYmV0eHZRUXB2Tm1KczNpcGZw?=
 =?utf-8?B?ZWs4YTZSMlBaUHVHSUVvdmc1YkRuK3IrTTY0amRyK0IrNmxzeTVDNnpaaEJx?=
 =?utf-8?B?QnJlOEI4RVgxVDJDNmdnRXIyYzZKTWQyV21ITk5YcDMySTQxZFNndzFYajNY?=
 =?utf-8?B?dys3THlEanpBclJ0VEY5NGV2ZGRGSGx5amlFVUlZNHhrR1hsNk9yVU5QdEZQ?=
 =?utf-8?B?YWRwZ3NSR09oMUpSZndYTmdZMzA3RExIT1p6Mmx1am1OeW55aHZnRFVocXFH?=
 =?utf-8?B?NXF4Q1R6OUdrZXgybnJ4N3hYNzNsb1RpVUtrdmFnMUVQend6Rnl5YzdXVSsx?=
 =?utf-8?B?RzVESTBaRGJXK1c0NmRhZGRKUW9aSk40eE9QdWcrVm5ldW1wZW1kOVMwRFc1?=
 =?utf-8?B?R0YyQWxiejBHeEQwZEtBVEltU3Z3U2hJbmk0UDRkeFhFQ21Hd0l5NHkrQ3pz?=
 =?utf-8?B?c1gwK200ZHVTWEpVemRGUnpLZnFvL3dwbmNlTDNGcWQ1cmlPV1JFK0lOTG5p?=
 =?utf-8?B?aXhwNnZNVURXUjZHMHdiMmJTRXJUcmpKZGhQK2YzbHcyQSs1ZEtPbmpqemxB?=
 =?utf-8?B?cjhtMkF6N2h2UklLS3ZBcEFRL1FndmFMZDUxemFOLzhOV3dqcUhtRGVNZHJl?=
 =?utf-8?B?ZytiTS9GRXRKUGhoWU93TFB1cmQ0R3pRUnBkZGxrZ1dYYzV0eCtYWHBacDhK?=
 =?utf-8?B?SW80NUYxajFvUjF0cHYwSnVVTlZDZ3NLczdtREk2eGRWMHZHemh2SGJZUkM0?=
 =?utf-8?B?d1NKa0RreStIWEF1ZiszSVJRMzdMMXpFRkNyMFp2WndiQmlhM0RLRTFZNmhu?=
 =?utf-8?B?K05ZZFQ3SDUrUEh1eS9sSE5pazh1R29PRVU3MUJHS01vdWt5blFvUzNJRVhN?=
 =?utf-8?B?YTJHSXlGZFJpRDNpNHR0ZG9ySXRaNWF0RkQ4VmxlR3JCcDFCK2gzWkZ0R0Y2?=
 =?utf-8?B?Q3NUcVh4THZsZ202dXp2OWxDWE12bmt3TWtJaW5xNUtwMWZWMjVKejJZZ01s?=
 =?utf-8?B?L3U3YkdtK0N5RzVLeDN3MzhJOTEyVGQzWU9ObHVmZ2NmY29NZ01lWmRvTkQx?=
 =?utf-8?B?UEJNRHd4dmNBRHYwS0VkcU1aV2tiT2ExcG4zMGxEWnRVR0Noclp6RGZGc1gr?=
 =?utf-8?B?MVBXUWJtV1J4bDFJa2t3bk4yMHJJMEZDUjhDSEVEZjhGWlh0eUlCaHFlWE9S?=
 =?utf-8?B?Vk1jb1lBa210REY4Qm1Ydkk0ZjZVakNaME91SlFDQlpTS0FUS1UzcEhvSjdw?=
 =?utf-8?B?eFF6aHBpclVOMERRWEVaYXBEWVhrTzhvYTIvTGdkVlJOa0twR3prZDE5eEsy?=
 =?utf-8?B?dFFncEMxY1NwS1NJRENrWjZQelVWZGhXc2FYUm0xaFN0SVcwOVc2VUZRcmgy?=
 =?utf-8?Q?0nCWTlMP9X6OcQSM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c805887d-d271-4d13-0870-08da386a0681
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 01:02:05.7060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPPsJ123xU8ptW/ej150XjajR+P/h0nRQd4seKVuKNgKVJCVc/NzeQrYKWSjDnMd0ZRJ3T/Q35G6vc+9fFWPAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6212
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/5/17 08:43, Kai Huang wrote:
> On Mon, 2022-05-16 at 16:40 +0800, Zhiquan Li wrote:
>> On 2022/5/16 10:29, Kai Huang wrote:
>>> On Sat, 2022-05-14 at 13:39 +0800, Zhiquan Li wrote:
>>>> On 2022/5/14 00:35, Luck, Tony wrote:
>>>>>>> Do you think the processes sharing the same enclave need to be killed,
>>>>>>> even they had not touched the EPC page with hardware error?
>>>>>>> Any ideas are welcome.
>>>>>> I do not think the patch set is going to wrong direction. This discussion
>>>>>> was just missing from the cover letter.
>>>> OK, I will add this point into v2 of cover letter and patch 03.
>>>>
>>>>
>>> I don't think you should add to patch 03.  The same enclave can be shared by
>>> multiple processes is only true for host enclaves, but not virtual EPC isntance.
>>> Virtual EPC instance is just a raw EPC resource which is accessible to guest,
>>> but how enclaves are created on this EPC resource is completely upto guest. 
>>> Therefore, one virtual EPC cannot be shared by two guests.
>>>
>> Thanks for your clarification, Kai.
>> Patch 04 is for the host case, we can put it there.
>>
>> May I add your comments in patch 03 and add you as "Acked-by" in v2?
>> I suppose it is a good answer if someone has the same question.
>>
> Yes you can add the comments to the patch.
> 
> One problem is currently we don't explicitly prevent vepc being shared via
> fork().  For instance, an application can open /dev/sgx_vepc, mmap(), and
> fork().  Then if the child does mmap() against the fd opened by the parent, the
> child will share the same vepc with the parent.
> 
> We can either explicitly enforce that only one process can mmap() to one vepc in
> mmap() of vepc, or we can put into comment saying something like below:
> 
> 	Unlike host encalves, virtual EPC instance cannot be shared by multiple
> 	VMs.  It is because how enclaves are created is totally upto the guest.
> 	Sharing virtual EPC instance will very likely to unexpectedly break
> 	enclaves in all VMs.
> 
> 	SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
> 	being shared by multiple VMs via fork().  However KVM doesn't support
> 	running a VM across multiple mm structures, and the de facto userspace
> 	hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
> 	this should not happen.
> 

Very excellent explanation!! I will put them into patch 03.
Thanks a lot, Kai.

Best Regards,
Zhiquan

> I'd like to hear from others whether simply adding some comment is fine.
> 
> -- Thanks, -Kai
