Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF24EC433FE
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Oct 2022 04:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJLEg4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Oct 2022 00:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJLEgy (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Oct 2022 00:36:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC5A49B4E
        for <linux-sgx@vger.kernel.org>; Tue, 11 Oct 2022 21:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665549414; x=1697085414;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LnsyWT7OcQwZ0fxdYtTF8i7OvP1Dbtk7o/705qPBx74=;
  b=TaN1sXcqyqtq3ZAwP9/+SsNv2QDTOT7i1NRetXgL9chpo5aAQoULmEjB
   MnN7qysTPEEimokLjiBy+5l6XjyV4ZyfpZZf4dy4/hINlhVfDvJWEIuhP
   Ixz9xwUpedpuB+OehpDUHWrK7BJWEOmZ5DaC2gKhIVj5Wl3c/4R7OTsIN
   sb1qWB2LMbOk8aelY65MuohiVK7J1jAsbvB6ijiP8uE8Pc2BBrpXBPlW6
   +RsT91EB5hyWih3ujWBI1MvJ1dLL3rdRA9kDlXvrhLablIW40HWf4iFE5
   l8yYMJ1bVWrJNFCKFSF7utAi236zkK/W9IlE3iDcKhkrKww6grwFC1zJz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="287962939"
X-IronPort-AV: E=Sophos;i="5.95,178,1661842800"; 
   d="scan'208";a="287962939"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 21:36:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="871767368"
X-IronPort-AV: E=Sophos;i="5.95,178,1661842800"; 
   d="scan'208";a="871767368"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 11 Oct 2022 21:36:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 21:36:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 11 Oct 2022 21:36:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 11 Oct 2022 21:36:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eH79tjzCmK1pswb7iBB50GyiefC8HBlnh0wyMLk6YQcJ4MfXQNQX7O2CIGhnqlHtReFVEsreYzmHobJtKwjPmfXK58/j7XY9hOuyVvrBF8QR3t9Q2KILB/qleis5I2fhfsevSm9emQ7rWurg6SpdKnau6j700Aj4apnV0wVb3X7IixtVsDwho6YA8Pf4Z8f/gW0Pp40vLJ2XEv1gaA5v/C4jiz2cYrBw5SvP9fJQbhpD4sRPqb6DbaCwit0Xd80xFfs8oVe+7f8suIYQAqUurwxoZVrInTytOZMhFr62s00oBNfd5yCC74QPsc4pCmgcmFIV/BLRq6ahRQBIKaTLUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6b4YOpWlTpk7hBzLxSarTKaKyZwEFb4fp8mYOzFXfjc=;
 b=lFleoMiY5lEnTnasqHwsnkMtMpAXM+qEcrIu1+406hZtIjqHkqAgtkJjolnOCVL/zidXKa4ZUHqdMvogTSBtVvdQ7EQie/M6kq5FGxBx6T83i96HYMDm8Vnc57V14xB84izH3Ggl/+rzHUEki9A3yqfieIleR91aPSyR+bz7skJOutwrEFhOn02ss7Px5Dn+nmhJkCtYozV5Rp8WO5wEgc4a4J60eeOTZrCnM46zlly8YH77hgrgi2XYQyZvtbhu84TJ89oPQPi/BuOBTsevtfvxlKnv7ehudjzp9PW6cMk2zhUqq+suATdsiVZumAax5IVm1xBCSs9sGdOygXU+Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by DM4PR11MB7279.namprd11.prod.outlook.com (2603:10b6:8:109::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Wed, 12 Oct
 2022 04:36:50 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e2ed:a3a2:6ffe:409e%5]) with mapi id 15.20.5709.019; Wed, 12 Oct 2022
 04:36:49 +0000
Message-ID: <2dd703b6-66a9-0a35-b02e-6a66e356277f@intel.com>
Date:   Wed, 12 Oct 2022 12:42:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v9 2/3] x86/sgx: Introduce union with vepc_vaddr field for
 virtualization case
To:     Dave Hansen <dave.hansen@intel.com>, <linux-sgx@vger.kernel.org>,
        <jarkko@kernel.org>, <dave.hansen@linux.intel.com>,
        <kai.huang@intel.com>
CC:     <seanjc@google.com>, <fan.du@intel.com>, <cathy.zhang@intel.com>,
        <tglx@linutronix.de>, <bp@suse.de>, <tony.luck@intel.com>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-3-zhiquan1.li@intel.com>
 <f6180914-2b63-29dd-8dc3-de48c4197769@intel.com>
 <540df1d4-d784-b33e-e1e3-573aa5f804c6@intel.com>
 <277c494c-7e55-2d73-dbf3-7a841836a395@intel.com>
Content-Language: en-US
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <277c494c-7e55-2d73-dbf3-7a841836a395@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0187.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::12) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|DM4PR11MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: e4b0dab4-56b4-48f1-16c6-08daac0b6068
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7NUqh88delKT1ufmQ4WJ/AnLBeszeYMtw0MO2iNI4se5x5QeS2IezfCME0CaJZZ14XhYNpPdTQmJX6QHC39dWWXD2CzZlxCW/JHPN7L54n0YcEAjSrXa2AfEbpFxHA5uRcAB2XCBoj9EjgyngSgfr6rZULWtEQWT6ps10GGxVjW1Nir1/+8pmK2V0Aodkf6slZgyUpy9yDdg81z/nbLFRu72NCIW44pPCTlbX+hPskkEyYqnJzE1lZ39KlM4nyHslWxUtuyQ7Tq0xJAeFwsOQZ34GQMU1zvZlnBkJ9IpynWWBUoPRUPqxciwvqIvLWoLCkLWcYl0hNtcyD23A6D7NtVaGVl16Mh3PefSLMVQPDzriKjmgG9BhXHkx2k3fB99B3tUBmoA10lgGporOeKKzXr8yvbLDyJLxH17c4BbKYADcHDJk45Rrc4tIox1EXjtETtyxxCf4V5ITk7eZGpMNkxNFbQQ+qNxITx/c//sciCNCwBhdxkTxTJDxjhdJ7GXikhg4C/PCCcxGwBHyMY/N9pA6CTT0O1P3AbRkRzZ5/HRGo9rGQxV6uL/2k6voSG1TRpv42hg1mYEDq3grqz3RGWLzsZl9GQ5AwullhbJnDqGolGbgP4ZUimIrGHxeXH5Z3pu857JqzEaNMVWPWelEFUeQ7OK8n9WXEM9efdTn2i+pbkAZY6ltJGvGI4OBKm8cEe7/z1Z1zQYQcWhtaGuFlj9I3KYuG8bTAbyVSn2h/phlyiIHnKAoFPJrWvtCB5sGvoDyVpOXNlIH2rNjSSXwgfV+Gbn4lvUQAN4TU19dRc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199015)(5660300002)(36756003)(186003)(31696002)(38100700002)(2906002)(2616005)(8936002)(6512007)(26005)(8676002)(4326008)(66556008)(41300700001)(53546011)(66476007)(86362001)(6666004)(66946007)(6506007)(31686004)(316002)(83380400001)(6636002)(82960400001)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3hyUkJ6QnRBbEFpZ3E4UVV1RzVXaGZnM1BmdkJPK1lETWFwSldmM0g4WWdF?=
 =?utf-8?B?N2xTcXpmR0hmenFNdEoyU1pRTjBKRWxUelNXY1hoWDFPc0UrNnZVUG5RWmxj?=
 =?utf-8?B?M091R2JSaG00SFpOa0hXU3FRUzZGdFZaSW1Ib29hU3FpSkFRNzhweURIUW14?=
 =?utf-8?B?VVpMTy9yYVdpcHJGUTFwR2JNYnpKaXNsMTdMVzNYOXRNbis4Ym81ODdxY0xR?=
 =?utf-8?B?ZWhMSWQzZ0J5L051Z2ZuSDV2c1Z6eU9zcVRTemM4LzRTaFJuNFpyQ2pkZFpN?=
 =?utf-8?B?RXlVaEFId2laMXpqbGFJaHYxaWFsOGUwR09UMG15bU5KUmFjYzF2d1VxK1pC?=
 =?utf-8?B?T2ROeld1UkVRMjY5SHpNeVZkZHVDMkVxczNzc0IvL0VkTi9JSWZCNEk0V245?=
 =?utf-8?B?L08yQ0ZHSm5NUGpWWFR5eFRNUEZvRkoxYUFDOTdCd2w3NDhkckN4REJ6V3A5?=
 =?utf-8?B?T29OWWt3UzNGY0Z4bVE5bmJOZ0Nzc3JHVXRkNXBVTjVFdzBLU3U1SnR2TTM3?=
 =?utf-8?B?WERDTEMvbllMeENyQWRWV0s4QytvN2tvallucytzUWtxa09Oci9pN2VCTG9y?=
 =?utf-8?B?dGtzQnQyWWFKVVExcE5TY0tORzc0TjFRQjJoTmI5NWdXZlRvb0QrNTl2RDZJ?=
 =?utf-8?B?azJEYmdjM3VzNDRocGdBaitVMzJvRnI0RVZMWlBzbUF4MHFvbDJHenN1UUF4?=
 =?utf-8?B?VGRhejRtUXcwcDRiaDVQUVlVT1lCTzVPc2RXMVFtRzBGbVRSSkorU2wxNWJX?=
 =?utf-8?B?U0ZWK2RKUWRQcUpMcGd1MHBZajVEMk1FZnZhblh1enNidU5IYytpR1d6MkI4?=
 =?utf-8?B?ZGNSelhHeWdxSzNvSlF3T0JrTHMyektSdEt0dDQ5QXB3VnFlK2RsWWdZTW1E?=
 =?utf-8?B?SVpCZmE2RzgvcjkvanVScVlTTSs2KzZhT3JwbnhMVDk2MndheHZUYkNqbzdt?=
 =?utf-8?B?MWFpcHlQaDZxdSthb0JQRnZXazI3d09NeTBjY3JGQU1sMG52TGdiRXJxY2tG?=
 =?utf-8?B?ekNLUnByWGxEcy9WMjVnZFpURDlQTHBrVHVoL1FCK3hZSVg0akp2TEJkZmVY?=
 =?utf-8?B?bW5aQlk4TzBzOG54cGNrNG1yV0xpUjRPTytzWFpleGVGeUlEYWtsSWgvTCt4?=
 =?utf-8?B?OUwxUklXUTNoMkdFMExlUjd1T0YyVjY5cERQOEtOM2xNVVhhazBRbEo4SFNC?=
 =?utf-8?B?L0dTcXRiNnBVRERHWENPcmM2NVUzOEVLL2dzYUwvcm5GbUphZkdDL2MzZWVP?=
 =?utf-8?B?UDFaQkluVzdDV29hQmtHRUpxQ0xRVGlxMTRpWjUyQTJFUkZQa2ZmczAwNlVs?=
 =?utf-8?B?TUtKUmJlN0V2VFZWNkh2ODZleU16cGlQRGpFb0FTOUZ6Um5YVTA1UUpXNitZ?=
 =?utf-8?B?QWJRTkR0YXZ4Mml2Vi9WT0w5ZFBGeUFPb1NpK0NENDlmSWRGeFNmSnRQZ2VK?=
 =?utf-8?B?ZUt2bDdieWdrMTh3TGRqTlA2akhZenZ4L1J5eXlKWmZUVkJyMzJ4Q1NQc1Rs?=
 =?utf-8?B?V0x2V0pVNGYzUHpSeGFhTEE5OVRjL3ZienRWVTR2Z01xVkVodkNTVHFWMEZh?=
 =?utf-8?B?YXZ1RWsxY2NXaWh5aDIxOTRyQVRBMHpiMFJQOFIvY3hqT2JFbnpac0w0cUZi?=
 =?utf-8?B?K3UyUndTQjJyb2t4K3pxOGhtelczUnMydHFRaWJBbWp1L2tZY2tEekRWdFR2?=
 =?utf-8?B?NlVaa2N1c1V0WUdubDBHVzNUaFdqYlh5enVONkJ0TFZKRU91L0VTVUNxVEo5?=
 =?utf-8?B?RVBjZW8rVmhVWmQ4d0paLzFOUVMrem5ONzcyL21ka1RwSFZGalhBNERjdExT?=
 =?utf-8?B?eHFUVE9SZDFUckh4STRSRTFzUmtBdVJQRWRWbUNneW96OUFHT1dPWFlqNVlz?=
 =?utf-8?B?L3haMUtDNVVBM1A1bkRhTzJGUDlDQTRuMDNuVUxVOTNIL3lzSnZud1cveTJn?=
 =?utf-8?B?MlhteTJJdEhlQytNOENmK0hoVlFnVEYrK3pUR2NPbll4aktydVJlMEwvMDVR?=
 =?utf-8?B?UHRGbCtmM3NSM3R4a1RXVlJ5SUY4NzFHN2tMSkxpTzh6elp4TmY3TkRMTkhn?=
 =?utf-8?B?dkFnMmsrdzRERWFzSVllVGFVNW8xNFFPNUNadS82TmtWVkZlckN2dm0xRWxm?=
 =?utf-8?B?UllGTDhNRTBNSXMvRk9JckczR3NBdW52bmd4RjI2QjNYM01rVEFBNy9XTlZR?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b0dab4-56b4-48f1-16c6-08daac0b6068
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 04:36:49.0117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +yLQd/ksnux3p5rP/nMwjxhJ96s/uUJrbdyykKLCb7BP6otDWOsNos8PouIoquCpB3MOBbMvc/OFYGt1WEhRrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7279
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/10/11 21:57, Dave Hansen wrote:
> That honestly doesn't help me understand what's going on here.
> 
> The changelog and subject are spending far too much time explaining the
> low level details of what is being done (like "add a union") and far too
> little time explaining what it _means_.

Thanks for your comments, Dave.

I added more descriptions for motivation and reduced explanations
for details in changelog as below, could you help me review if it is
easier to understand now?

    When a page triggers a machine check, it only reports the PFN.  But
    in order to inject #MC into VM through hypervisor, the virtual
    address of virtual EPC page is required.  To avoid introduce a new
    dedicated structure to track it, repurpose the 'encl_owner' field as
    it is useless in virtualization case, so that arch_memory_failure()
    can retrieve the virtual address easily and attach it to the extra
    info of SIGBUS which will be sent to hypervisor.

    The union can prevent playing the casting games while using it.  And
    add a new EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the
    meaning of the field.

    The changes take place while allocating an EPC page to a KVM guests.
    After applying it, the reversed relationship from an EPC page to
    virtual EPC doesn't exist, in practice, such relationship is
    useless. Beyond that, other behaviors have not been changed.

Furthermore, may I change the subject as below to highlight the
motivation?

    x86/sgx: track virtual address of virtual EPC page for injecting #MC
    into VM

Best Regards,
Zhiquan
