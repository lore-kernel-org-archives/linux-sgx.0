Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569EBC3A59D
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Oct 2022 01:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiJXB1E (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Oct 2022 21:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJXB1D (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 23 Oct 2022 21:27:03 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D1966862
        for <linux-sgx@vger.kernel.org>; Sun, 23 Oct 2022 18:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666574820; x=1698110820;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/KuJy6AMlz8qNIUepE2zGdnOoKZFRoOqkRq5rJBpzWs=;
  b=AN+hvkVaY72Jz1g6IgLDOh/yJd1xwMGRqEKuLxtLU7SNX1Rpbh2M0QC5
   +hM1KosQoZXPAmBIoK/uIqfkuL0re8xIx5knmLxTYpo0uqBwHBTfei4J8
   ypgzPP79a8AthwA5ul726qOsXucKplUSyay4ijKu+JdtG3E6D3OiJ26B4
   jXyFn/FwXimrgIZtMPq882HDJt8/YJToHjkzl3VC5PTm/YACvOkZ6jcIy
   HuOsiisnJcptJN4JwMRCY1R2UQVRDcUwq5kowclamCPT834tjDzWHMaVd
   QdbZkQwYM0Apq5Cyf0sayhk0z4yM+wsl9ehfneEd3jjyjXpSXkMKhCRyP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="306047856"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="306047856"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2022 18:27:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="720330385"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="720330385"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Oct 2022 18:26:59 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 23 Oct 2022 18:26:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 23 Oct 2022 18:26:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 23 Oct 2022 18:26:59 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 23 Oct 2022 18:26:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmOdd90sUuIrVlvso8klEn3P6E0tm+63f8XQKfB2VJl7Acqw9DHjVW3Xn10nJ7ZKXz+6dt3sTKQYIrJeU2KNPNtMD/fNO4vANfG/V54bRzLlDChGMxmISMiVM9MRuB73UH69bsehm/O/eQQpL7x3CQAC86cdlR3DZtbCbJPy/i9/wKfwxyf3G5K106SdjyJJ/Ar9Kk3cbooTN5aC64UXoa3P2BIe4fCzoEeaOBoNqccg1VGgB82o0fEh5d33xp5omy8l6RThJW7KjAVGCW1Eo2bm+Y6Wgn26fSKuz/Z5rr1EvaN5ed3j8e3WE0waiySHPe+OM7LgkN2njMrhW7dKAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYp35Y1C9tzvrG199D8DmexnUASGYRRUw5b1fN1VAbA=;
 b=c8cBxDclg3Y3DT2/ybe4ed3ySIrRc80zXU15FKKkBfhAW8zHqS5vPyYKibyeL7SWN0fjPg6aoY0udpMnQeVJI/6C/axN50TtTMQVyNgeA0iB5h9c1LAzdC5zEk41fjifuF62JqFSbNaWZaQYPOFKbYkV2JPYds0jVHzdjG/7m+r8cx7PDrcjCDXrLicKWhLzWG16oaImsPKSxhPDUxpGhqUQLAnf1fyp9JounptOMdSbw69RIVnpxQb8sD2nepiRZvMVdalEuRuMGvK/pRXX+LWFY7iWOT92H+XxvKqXqf7F800QYg6ITXML2IKQQKr6M9jrnwAhwZfe6E7F58MY7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by PH7PR11MB7121.namprd11.prod.outlook.com (2603:10b6:510:20c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 24 Oct
 2022 01:26:56 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e%5]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 01:26:56 +0000
Message-ID: <e8f1e391-0362-33b7-aaf6-45a685eba0a4@intel.com>
Date:   Mon, 24 Oct 2022 09:32:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
References: <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
 <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
 <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
 <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
 <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
 <4930999a-888f-88bc-a05c-86762504f059@intel.com>
 <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
 <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
 <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
 <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
 <Y1WmZgqIkl8GkR/i@kernel.org>
Content-Language: en-US
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <Y1WmZgqIkl8GkR/i@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|PH7PR11MB7121:EE_
X-MS-Office365-Filtering-Correlation-Id: e06c1b96-2e3a-4185-50a4-08dab55ed681
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fl70jGUixSwcz6juyyBdYiCBtUAwuNL3uUb1ztZq1rQaWfbG6bJCPouIRUteFqxySZTSF31Pxm9dvC4x/PPBdBQeIeDZXRaH7Q87cNnPTaL0MsbnLEymtk5CONv5KC8SZ3ia7bkq7PIkALWHt3VrlnCeRPb8mrmft/QH4xeV6bG3C+/kdgGT2xbhnEidcMNcx0eb2g9UKjGqmiP4APfigzHF8o7RXP59YXgEN2iKzDGxnbmn/FGHxJQKC+DH7GYhNwOoPSmHwDwzBQSgLk5dyMIZu9un3J2jj6MOSHHLR2Dir+7ZKpz0mu+o6+3yrhVLHAXCwsRgPI7m/1izqPdDLxL04UgULrag9H9yWWZExmOfUmv7QIbTCdrlrEmXr0iV62EH7DGV/djkGncmFt3dJ4xtY1vxT/RorWVmO3YAYMvREU/LkuUYhnGt+4cJs8B4DEKwabe4i5UqGcQ+6ZUU2BBthTXUCbRkhIbKLJ+Qdo++3sCkagwYAEbr5g43REAdiotRNOd4bnESiQr4NSZuSxG4+iudHThZTF7f+YK55pK4NLppIdoNCdqaODywdudFxD8PEz9C1xTxIR3xKBy2k3vhq6IR4d09Dk/ZHqfuw/MzG9qSrQVYE2W4nvrt8MCXczU2ncSoFa+LnJ/of8m3cxK9b9hv2MXVhH8zqttF0sZBt8oWvq500eSe2Li1aM1gx4rPr0E/MsRkY2jT2XlTGwNevipCM0byG2/z2nvf/Nie8585nq5JDszMfvU0v09skurpqKFzS3QeiIZG5GUlbcp3ur+34jBBdlhhOBCmyQ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(36756003)(6506007)(31686004)(6636002)(31696002)(38100700002)(6486002)(26005)(54906003)(5660300002)(110136005)(186003)(82960400001)(86362001)(83380400001)(66476007)(6512007)(53546011)(6666004)(316002)(4326008)(66556008)(66946007)(478600001)(2906002)(41300700001)(2616005)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVlTSzlxQllJQ2xGem1JT0I5Ymw5OVVGWGl2dlE1czNodDVQY1I1amRnK3Vq?=
 =?utf-8?B?MzE0MEIvaEVaR0w3L2prL01qazNyNHVLVjQvTFpVQ2hOR0dJR2xsajF3S2ZO?=
 =?utf-8?B?eFM4TlNlWm1CUmpNZFo5TmtvMUUrVHJOYWMzckV4bmZOOHR2Z0lvQVltOThY?=
 =?utf-8?B?LzNrUmd4WVJBMXdzc1FIdGJPRXZrT0VXQWk3VHJrZUdjc0wxTU9zWk4rZm1Z?=
 =?utf-8?B?Smc3MnhHam5VY1lFS1hEeHd6bFJ6UlN4aWpzMGFwNk1pVVZPdlpxdGJUaTFF?=
 =?utf-8?B?R2pxR2JqR0I2Szk2dUg2Y1d1MjkwVmI1QnFtU1lFcVlSSnl5OWhweVBUMXp4?=
 =?utf-8?B?RTlYanVnUDRFdURuMjRGdFFvZjFrT0VpNkMvR1JCakNjSHhqNUVxM0hDRll3?=
 =?utf-8?B?U2Q0MzhxZmFIWXFGWVZyNjVEVENpbGs0d3RPOFhKeEdhaWlZZStJbW42NXAx?=
 =?utf-8?B?ZFIyc01iOUdQRUF1WWtEcFlmbytQd0FWckxxbHBGTmRyYW45MmxtWEtaejJt?=
 =?utf-8?B?bklTdUZhQzBOZlNEQXlHOGNpdmI5L0FIdWdRK2xBSVZvd2pMeFVMUERJY2xY?=
 =?utf-8?B?dDlXNkRib09CWHhUblBRUnkxb01aa2x1YjJxNVFTMC85NGNMYlZ5MXVaMzBG?=
 =?utf-8?B?U2lUNTBQdlFKb1JpZ1QzYXFYdG9pMS84QmpPdEs4NVZISHRVY3ZxeUQ4OUlB?=
 =?utf-8?B?UHpYb1ZQL3lvQVJvTFU1dWVkUjhsYkw0RE13YWJIcmVlcnBqVDEzWDBaeEtW?=
 =?utf-8?B?eDdYaFl1SWFYQnQ2ZFlrcmlGR1YwZUlXYU9kL2UrV0ljMTN1YmowTFVYMm4v?=
 =?utf-8?B?azJicEwvOHhCbVJBcTNJaUhaL1lPcGErL1doYmV1SlNzSThHVzRiSFlyeGg5?=
 =?utf-8?B?bSs3d2R4dDZhK2wzcHVrb1VWclNuYXJsSnZ4TWtuL245Wm9FSVgzYU5IWFhl?=
 =?utf-8?B?dEVNanBaclFVdVdBSXYwNWdtaVNGU3lQRjRoSU11UHlnS1R3YmFNdlNpVlhF?=
 =?utf-8?B?dDZlUFRhSDRQV21UUWJQR1JkckowOXRnM2pGaFRMblJPc1NqaDFaTmY3elpX?=
 =?utf-8?B?Y0ttL0k2L3QvaUFOYWwrOEdPaURFTERPbDR2NVU2dGVIMFdhZEdVMlNpZXBy?=
 =?utf-8?B?Z0ZCMm1MZVkxZUxra0ZvRGw2UHZFUzNYWGJQSUh3djJoaVYxSzRoaGhFVVV0?=
 =?utf-8?B?QkNWUHFZRVIxMjFNaDUzWEw1ZUtqN0lIa1U1VDVBR1JlcHQ1eHgzSVNOWHkw?=
 =?utf-8?B?UXpVQmt5L0wyTGdMS0xSdnJSR0I4eURTNGNQZWpTclNmQU1sL3g3RDFaeUZU?=
 =?utf-8?B?bTY1UFl0ZlZKK3FlNkhjRFZLVEFCTDJ3L2o4dEQzcFRuNmdpejZiWDdrdXNX?=
 =?utf-8?B?WHppT2R0Wmg4N2NycmdMSlVvMlgrUjFYNzYrNWxDK0tMbmtSRm1hdkRVaDJM?=
 =?utf-8?B?YURFZGN3L3EvWmpJeEg2Ump6RWJTK1lWQ1dCS1VxdzBrOC9ZTzVRSC91Ungv?=
 =?utf-8?B?aHdrdHpwcmJ6N3hPZThRUG5nZkRacnZONHJGekUvQ0VuQUlVS3R4YjF6NS8v?=
 =?utf-8?B?cHJOWEdXNzlhQmZVNkF6U0RoaU1zWHJ4b3B6NGZad1NUVllIU3JtT1AvZHFO?=
 =?utf-8?B?RWJFUE1vZ1BONzZmemhlNVJaa2IrOVJqcHlkbVdIK2dZanJoVW5MUlc3WmVP?=
 =?utf-8?B?RTVNMkFRdVllcU5FaEloaXNTR0JvS0R5Y21ZaE1oT1JIeHRtNVptb3lVMXBC?=
 =?utf-8?B?VlVxZVNxOWh5am5rbTY2bTQ3OTA1Y2g3NUJsNnV6Ry8rd2c4WVBtcGpHVUtz?=
 =?utf-8?B?L1hDa052aENLOGJ6VXFKZHlGYm8rUDQzcituS1dBRjlKUDNuSFBaUnVoWmNT?=
 =?utf-8?B?WmV0TjI5Rkg5ZGR2azlqcWNUa3U1blpUOVRabXdrOW5yS0owbGgrSEdLNEhR?=
 =?utf-8?B?WVM3amc4UDh4OEx5NTZOMGNSNmRvR2J0MjZGSlZvSW05eXpSb0Q4Yi8zdDhk?=
 =?utf-8?B?SlpNM0NEcWxtblhlNGhXUy9MUGt0Vm55aHdYWkFzVFFZZjU5ZkwzOWhPZCtP?=
 =?utf-8?B?WkZDV0dLdkJjeFpQRkcyQml5RVA4RUpsZkJybTlVR3hyajJXT3FmTHRzejZD?=
 =?utf-8?B?TVY4bU5TclNBbU0wdmxuM1hsYWx4OTZXUmZYT2tLSHZSZHNIUWlKQllONHFH?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e06c1b96-2e3a-4185-50a4-08dab55ed681
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 01:26:56.0292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I1Ls8wZUBv4YtnRb0m6xF/BysTgzF85ed9dNyDyKlJ3NHxnh+tXseG0YXrX5cBLKcBBZ3eR64EU9t7oIBG9mlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7121
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 2022/10/24 04:39, jarkko@kernel.org wrote:
>> As you can see if the EPC page has already been populated at a given index of
>> one virtual EPC instance, the current fault handler just assumes the mapping is
>> already there and returns success immediately.  This causes a bug when one
>> virtual EPC instance is shared by multi processes via fork(): if the EPC page at
>> one index is already populated by the parent process, when the child accesses
>> the same page using different virtual address, the fault handler just returns
>> success w/o actually setting up the mapping for the child, resulting in endless
>> page fault.
>>
>> This needs to be fixed in no matter what way.
> I think you mean that vm_insert_pfn() does not happen for child because
> of early return? I did not understand the part about "different virtual
> addresses", as it is the same mapping.
> 

If userspace do something like this, the child will get "different
virtual address":

  ... parent run enclave within VM ...
  if (fork() == 0) {
      int *caddr = mmap(NULL, 4096, PROT_READ, MAP_SHARED, vepc_fd, 0);
      printf("child: %d\n", caddr[0]);
  }


- "vepc_fd" is inherited from parent which had opened /dev/sgx_vepc.
- mmap() will create a VMA in child with "different virtual addresses".
- "caddr[0]" will cause a page fault as it's a new mapping.

1. Then kernel will run into the code snippet referenced by Kai.
2. The early return 0 will result in sgx_vepc_fault() return
   "VM_FAULT_NOPAGE".
3. This return value will make the condition as true at
   function do_user_addr_fault()

   if (likely(!(fault & VM_FAULT_ERROR)))
       return;

4. Since this page fault has not been handled and "$RIP" is still the
   original value, it will result in the same page fault again.  Namely,
   it's an endless page fault.

But the problem is neither the early return in __sgx_vepc_fault() nor
the return of VM_FAULT_NOPAGE at sgx_vepc_fault().  The root cause has
been highlighted by Kai, one virtual EPC instance
can only be mmap()-ed by the process which opens /dev/sgx_vepc.

In fact, to share a virtual EPC instance in userspace doesn't make any
sense.  Even though it can be shared by child, the virtual EPC page
cannot be used by child correctly.

Best Regards,
Zhiquan
