Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982C9C4332F
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Nov 2022 12:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiKGMLg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Nov 2022 07:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiKGMLf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Nov 2022 07:11:35 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3F7E4E
        for <linux-sgx@vger.kernel.org>; Mon,  7 Nov 2022 04:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667823095; x=1699359095;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+oxTxN+5/eDycFvkCXE+lif00AfFM3xTWfZbboi9edI=;
  b=KzRzNR4UPury/nez8LWWoTNZN7d6Z2VHg+6+LOT9GNIcPtfnG5kDJM2X
   PsridReBGplgl4OnaUrBAO5oLhg5yMwimkQW4D0oksb6bQqihgf02lIau
   e3zbKyqqnmDFbVqow60PS9XmG6lfPxS7Qh3K8suIz8TJHJJ1pbmgafRTe
   1vdtKHXnbaxe0I523RPFaBQQbT6ZV706QVvoUVMwGbUrk+PLskNVOw2ge
   eEnAIeg1iz0B1djAYKEK+eLS0XCw7cDxV7ZhRH62Dxn1gXgmsSkZ5GW1z
   Lw9ufMShMmehfSRjiG9fkBgEKEVBExi4ZbDckfzjorfoJTJofCshvXqhQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="293741563"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="293741563"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 04:11:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="881049321"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="881049321"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 07 Nov 2022 04:11:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 04:11:34 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 04:11:34 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 04:11:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obuH8qCttfaubaDKt+H/WNYlPlQyzHm7as3URkjBdgrbVk5uWm9c3d5D4EViRUCzv1y4FgjokRQKg0t8s+STvKDSScXuavBpNGsQ/mQBm+gLBr919yndLZd/Sy5tdxwPPf3rkjcnP9ZSWx8Sqend4trVB3EWhCRf0JNJQfcBacP77K9jgk+PomAIo4/lwdrubqLRQvAjARnHJxhxcyevc7CUWVh7kXKAjZ/CPI8pdjLNebvXEeXYLY0sDkdbIwMpkdsCgZHbctebzAGV86bx0ni9zdkD9SWfFN9o3iOvrgUd7xPnTysvlKDKbTokoKuVndwuKrXU5EvJujvjQc41xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NR3GkVBLwAwRWLJk3OiddwortHA8aSrT9HjaqxsclE=;
 b=F3x0BX79gf233GWX9cYtTAmhn8b+vK9+SN4sUikVmDGSaRAIXuxjXWSNcVg//nZ+zKo5z3jGQ0R2jUNX9a005Hz+yADCfzgUmECsJ5JgtMtv8hRN9OTWDE5U/jNNPsaUeW0aE56Dvx5DAwSYKNy1rMQ7HzwHysRP39zBH7V7AME4sQUqscZ7Y0EOCOBLRg2dXUcpg/1rUC5kwZ9PRt1uzpj1VlcvqNS/tBaLM5C0FXBiAFpY3NfjIg0HfwMyFbZbxPFD3wPBO3UMiDJVB4aVvB5qh71O13YDPCqtpIcy1d+XWrDRtvPpmbfBbW2T9MXMnlBzNyPn1pfHZa4Gs8UpTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CH0PR11MB5522.namprd11.prod.outlook.com (2603:10b6:610:d5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 12:11:27 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::902d:bd13:fe4e:4c0a]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::902d:bd13:fe4e:4c0a%6]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 12:11:27 +0000
Message-ID: <0879bc49-d016-aed1-d061-4eb9ef20736c@intel.com>
Date:   Mon, 7 Nov 2022 20:19:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
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
References: <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
 <4930999a-888f-88bc-a05c-86762504f059@intel.com>
 <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
 <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
 <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
 <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
 <Y1WmZgqIkl8GkR/i@kernel.org>
 <e8f1e391-0362-33b7-aaf6-45a685eba0a4@intel.com>
 <Y2BsSCM1BWlsqPcK@kernel.org>
 <ff40770e-dd55-e869-53cb-ea976bc5f63f@intel.com>
 <Y2jtup9Owa7PE9Ug@kernel.org>
Content-Language: en-US
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <Y2jtup9Owa7PE9Ug@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To MN2PR11MB3728.namprd11.prod.outlook.com
 (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3728:EE_|CH0PR11MB5522:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bfb8f9d-0d15-4607-7d1b-08dac0b93214
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pw99C9LsI0MlpJfD2A0eSV4KRMpcSNR5B9qGHmgb6E6tL8ccr40NQapEM+kjGYnAZ6LiVKq03pbCKhtsY62qSI/lxCrj/Z0G0iSjI+8zHAQ0BHKk8l0RjeLL65DuFnq8CdzYrT//f/acEMIXD/3CcWvJxkZ1iiXZIjPotkkYYShtjP4LpcHhLNsb/cbRl2v59iibpAmkrtDtnCik67F54Qj5hRp0jX0QB/ICm3wej7O/qaFvZHk+nNDda3Q+3wxnrnxOlXalTwssqiv306+dHz/G6Np7YhnTN+UYURfedv2gEX7EmPaezbqKwPZHYWM4lqI3Bj9oGPBeB3cez29j56do8tWYGE09Xz9bbl+OO+NDjmsEQRrfi/tgenjx42TLbqLflSm1ZT0Vwpso2DemF1hys1pEKMvyrBdFaJGZJOvMcHDddzUwt2xf8JhxjORP89WdqmDkov+vrppe1VAhK4Csp001ewa+2nOYCpY6w/sZfGJ7lNhvSv5s8XhSwJC1KkC6cVr21rQFkv9rGBGo8SoI+uMlQNGsRg01/nbQI5WzH8kX+EWh1I2OHHRDGWWGYZbjm6cgmHEfqhWx8iQJ1iTf/yj9yCPvx/cspMrWIIv5mGB46aQM6rJSG+Nsl+IFYRJvlB2FaWW8dX4NjaDf2PGtM3+XNapSxjvkorLEG+2xRvXWgirKD97e9CSI8kvmcQQJhbF3pDS6rc/RCg0I1P9O7L3ySS6Oqf7f/QH7aIeUb1mfaXCLm7qoGI97yO+3TN81P3deatZuW/MjCDRuYv+Hqas0bW6hysJUdlmtLd4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199015)(36756003)(31686004)(38100700002)(2906002)(82960400001)(83380400001)(2616005)(186003)(558084003)(66476007)(8676002)(66556008)(6512007)(26005)(53546011)(6506007)(31696002)(54906003)(4326008)(316002)(66946007)(6916009)(41300700001)(86362001)(8936002)(5660300002)(6486002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjdDeS9qZGtYeVB0b29zRFlyQjgvMmdaZXIyT2FJOVE1Q3U4bG9VVzlUbVgr?=
 =?utf-8?B?ZFBRbmUzRjdkcVFTQnI1WEdjVStoWVUyR0NxQm95RUlIVll3ZWFXdjVlMzJu?=
 =?utf-8?B?cFgwOXR0YkJORmQvL0N4cmRQOHE5cDNOMUIyeGhST1VGR2NwOUFCblUvSmFE?=
 =?utf-8?B?bGh1V0dsQVFYaC9rK0RjNTh5WXN4MEFmVStwckttalpSR2RUeXo3bG5FRGo4?=
 =?utf-8?B?R21jcW1xbXhDZnpLWW95SEpQRmMzY3JhM0VxbTZkQzVQSjJXZnZRUnhvZEdX?=
 =?utf-8?B?ZldIQ3dEL2Fqdmh0K0U1TUdPOHd2NzF2dnd1OTBVQVBuMHhqSXpKQXl6K1NQ?=
 =?utf-8?B?cFZrRjRWVWl2Tk1La3Z6bW10cm16NlBsbUFvRWhJd01HcytxYmw2WDFOY25D?=
 =?utf-8?B?Z1paRGVCZ00zMk92bnJ3SkdVaEcxUTNwMzBRN2x1bWRNQ21Oa2hHWTJ6dWt3?=
 =?utf-8?B?YXExeHFsYW9mNGZVVjQvV3JGMDFWQ0JXdnhLUE5oQ3ZVQldEUi9QV3Z5c2I5?=
 =?utf-8?B?Uk9iYzJ4VU1lRWgzOXYxaDRpV0QvaFNEbGJnTnBFOGFhcGZTNlJPajZDWUpq?=
 =?utf-8?B?UFNsYXJnOVVpVmZTeTBpSU1TdXMxM0k2Vk5uODMrZ0l2TVRDWnlSTkNSd2or?=
 =?utf-8?B?bkIxSUI0enoxd3M5QXBxbzNOSlcvRnZoZytaNzd2cHpqZ3VDTDNCU1lqWjdF?=
 =?utf-8?B?NEwvSlJGNGxSckVnVEljQ0VMdy94Q0QwS1h1djE1Tis0UThXbk5IS3J3bjFq?=
 =?utf-8?B?S0VZM2hkbUNWRmwxcEJWdkxNWHhxUVltL0VaUE14MG5XYjVSU09pZURLSlU5?=
 =?utf-8?B?akRmTEp0dzc4L2t1RzdORE1OSCs2Snh6bFFpdnY5TkxKWkVhUkFvcGRtUnNC?=
 =?utf-8?B?REhDdmF4VklZeC9uNFE3NHJwcDFmOVdabjdHNE1OMjAxY2lKVHFSN0E5dDMr?=
 =?utf-8?B?bytldHRGUVc2VzJjSU9VWjVEOWtKZDdmMHo5b1loL3hFNkQ0aU84MHJzL2g2?=
 =?utf-8?B?WVM3ZFJhSVpWMVRWU1NHZGVhK2NZNUk3N1N3N0I4enFEeGhmc3I1OW9SZVFH?=
 =?utf-8?B?TndGbzI4dWRkRlpscFhKdWk5Tmt5a3lEWFJvMk4rajY0ckNDbEc0KzlubVFX?=
 =?utf-8?B?QTV6cklvNkhSaGNCMElHVG1SdmVoTnkwTnJRWi9aWkJsQlJGNlBVczVZemk3?=
 =?utf-8?B?bTNuNWxzb21xQ2QyWVcvaExPa1h1RjVnSlRXbEFONnNVd3p1ZjlISmJ4dTBE?=
 =?utf-8?B?SjhYb2d1WDd2Nmd3c0JSVmx5YlRzdndvT0lkTk1GUGJyaHlKQ0tNNTVla3Jk?=
 =?utf-8?B?cm55dzExUGQ0RkY3b0s2aTRqVGR4TUYxMm1vTUZFY2tIV3BrcHF6ZURXUTd5?=
 =?utf-8?B?YW5YQy81aE9HdFc4QVkyOGNRQmRTRFhxZWgwOWpFUnpPSURHRDBTMTRnejJS?=
 =?utf-8?B?amFGbmZQUHNVVEozRFVxQ3QwZ0ZKTHVabUhDYjN5TXQybmRoOXUzamN6SnJY?=
 =?utf-8?B?MTVubC96UDMyRnVCcWwvbzFxOTV4Q1A3MWo5ZUJyck03MUZ2UFhUTkpqUzUy?=
 =?utf-8?B?dkpDSUgwRTcwbzU2a0FOcjhmS2xzbi8vbG14RzZ0bGZTWVBGeWs5M0Vzeldk?=
 =?utf-8?B?ZDVzalR0WXFTRDk5SWQxTEx3TWdaaEJxMDlsQkcvWkJ5VHRtdHF4emFvZGRk?=
 =?utf-8?B?RVNOdWNIU3VqVUdhK2tXaWE3NWJyUVlmcjNJek9vWEJRYlUybXpUZGVQcE1J?=
 =?utf-8?B?anJTRHZ5SjR1STF6VWx0QmlpYVhTRlBqeFNmeTNmWERraUdQZks1Qk43azMy?=
 =?utf-8?B?aTZoTUpmWVcxb3p0VXVlb1JJTjg5eS9rUnB0WE5FaE1aWmpJamNnT2pnRDM5?=
 =?utf-8?B?cjhHWHhsOVBYVXVQKzVJVmhUWTRHSTZwbTIzQkNqZ0IvSkpVVFhuLzBJUHVR?=
 =?utf-8?B?b2tua1E2cU11TXQ4bGxmK0hNN1FNcXZnWVRGT3M1Y3dRQkd0WERzZldtUTBI?=
 =?utf-8?B?aStvdkNQeFladDcwdHNCUG95WWFYbnJOdnpteDdvdnBKQUxhbjNhVzNzTjJs?=
 =?utf-8?B?R2hKMkpTTlJoY0xVbFlQNmdvOXdlUGhGckdKdWJIWmNpUC9NYnI1YzJTdmNO?=
 =?utf-8?Q?UG1JzWsT9UULmbEQ/EhXIEJ7O?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bfb8f9d-0d15-4607-7d1b-08dac0b93214
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 12:11:27.1782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CJAPEUAEss2iom9pxNreuOQiziPatAVkp14s2JQPioAgtCplXLkOZhP+15bbUTUE1WOaer0ud4C544G0tpNFtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5522
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



On 2022/11/7 19:36, jarkko@kernel.org wrote:
> Can you phrase this to the commit message? This makes sense as a
> motivation.
> 

No problem, I will add it to v10 patch after current concerns are
clarified and get a clear solution.

Best Regards,
Zhiquan
