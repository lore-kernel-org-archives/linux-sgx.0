Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29466C433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 18:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242326AbiEKSCD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 14:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiEKSCC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 14:02:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFBB57153
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 11:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652292117; x=1683828117;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TGejNYUpcbxdHcHUsInl7+w4sZtOBoebmNlMC66Ar7Y=;
  b=JfLQQ5Sp+tPUx3Co9O/t4EH+qqWSEnHsGQ8f31vpcoJAVs5J2f6Pcr9l
   CFAPEhpOi+mF4Z26okPsg13cNJeOM8J21mieUHcIQ0peEXZ4GNm4+QHwm
   Noq31kLlZ+ZDJyvr5VrVHns5pZ2OKAFiM8SC+XrpeIAQzn/hNx560qerb
   je5e9RdBoWtsfyU1RjpTPN2debo03l7b6yjPKMQZW0SrRorKtlc5oM1tG
   gTRf36YNWn61bqVvpjoFzC1pa4H8VqU338mWoA7JKQPylZnG4OKPprpLR
   hYg4JaLM/wQ074QyE0wMznAuJBxRiC7AfU5vXomSY7Oek01K7aP0/Vhai
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="251824703"
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="251824703"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 11:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="572189954"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 11 May 2022 11:01:56 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 11:01:55 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 11:01:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 11 May 2022 11:01:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 11 May 2022 11:01:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4t/bdEi/NpaMeoxNQaPlNikEcl2bzpcJEEI0ZDqOBnEHV5VLX4Fxabzlmn+HzNsdCKDJ3b7My37jAw7gvexawotxyj4LaWwWAoq32b5lSZimPtUCYUGyZTkftWJR9/ZFR1lZUUFpf86QwvlNDKxaRkQZHb2vNJDWIsMPeANRWdo9fgvsHSKt9WlkjFlARGNSfP+Fe9KzJ1fTgEsatog/UCANa2qey9US07eo4kL8q9Hs4H8jGwwlhTey0j9KEe+81r4/5dOc+y9aCRVfjquDgWednmYuLaETb7hC2fiAPlrOLtJnzFXLrmOjAd8Q6wo+UUcix/hyiZj8OvBX40/5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwWLXZJuSNp1fZbx1pmg7qnSONbzDjTSRivvvruQYC8=;
 b=gYM1j45Hyig7oD0Kn8dUMhITegqlMXwFUDEGRkpxSjUIcRklBJBeGzV07K08ttiY9ivJLTOwjAuhmTpMok67YtAzhVSvOOCDO823K7x9UtI3zFoEF5fm+xR85a3R4CrVwT33gEKXaldxnTCFaebuTv3wOXBNUPEYW6OWU68pc2+JlSUE7w2Yj8ockBZMGh+NpaZQUUJzX4ubg40YzoUTBATGftPt1mVyKpyNusN3v5piJPAa46pPYm3VXUdmk9h8WmP73z+8aCBS2N5MxJPNyikoEeizwBBvtQ7+USVoXNgvBM5Rq3HsTYjYg50XOdfzj61heU1Ay/qUoPQWkcyN1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5740.namprd11.prod.outlook.com (2603:10b6:610:101::7)
 by PH0PR11MB5174.namprd11.prod.outlook.com (2603:10b6:510:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 18:01:53 +0000
Received: from CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::5043:8c48:2510:3ec0]) by CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::5043:8c48:2510:3ec0%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 18:01:53 +0000
Message-ID: <013b94d7-c7bb-1d13-94b6-24a6508b4bb2@intel.com>
Date:   Wed, 11 May 2022 11:01:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [PATCH V2 2/5] x86/sgx: Mark PCMD page as dirty when modifying
 contents
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <dave.hansen@linux.intel.com>, <linux-sgx@vger.kernel.org>,
        <haitao.huang@intel.com>
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <217608112793e76b335540edde75dfda290de16c.1652131695.git.reinette.chatre@intel.com>
 <YnuTYN/QZxoN53jc@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YnuTYN/QZxoN53jc@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0024.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::37) To CH0PR11MB5740.namprd11.prod.outlook.com
 (2603:10b6:610:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f652c30e-a53e-4d82-3e16-08da3378547e
X-MS-TrafficTypeDiagnostic: PH0PR11MB5174:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5174D5096B0BC85FD23CD170F8C89@PH0PR11MB5174.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XrzSHcqzg/Dzh0bMmuMY3gS+yGvh8QT0bV66iQb+C3vXkx8m7GxpvC0/EUGK5dez8TdHu7gcKCiUN+df/0LEg2SOsQ0NoyfRdhdjQuGqhh1/irYSK4NigXAWX69olvJ2QTN4H6Syfbnj9JGpQhAbRGuvFZzsbmBHY77gyyPn5WqtjVjUL2nox/XS/5k7dQeB92OIBXlVufr+QCKkQIY424tk8ukZoDNmBJrTJ7Q+yrScgvn1Wo0vrJwFpA5oY2uPj5HHM4BnWw1MnbTro9YUuXnk9jn/oLss2V1w6FaCPGhhE8o7CRCOwbzIaO2/2OT7++rYVHCeftu4WfpBn7Vs0S/p7lEcPcgbB5ni/x3XJ/ORBSBcAG/KSFTxg1ZZAkdK78/quCiuY6c4T+dvRQ7A1v0PbX8Sh2BxbKMo6YBXp40DzFAqLzopEGbjRE9XHs4Zy0IuO9RU7d4gLTXnVhF0Xm5dVm0oTzJdFNyms58jp7LAo6+mVRcJAUUAp8lvaATXCwtLDGrWx0Sm1lXpujrWsGk3t9U8wY5JKv/yKPA/HXTA5oymhQQkWs6p0KV8XUG8hznjDJijpXrOdovNZqkMWSkH5piJmllCOZ2RQBSyDkcTMfbxc317pXL3TNRZdN5oAN+2pOeNxqJjMwv77FPUWOscuG9Vn8jzKYQU3ulg1vuy44O5R3xE4q0rYpzrUQnN0Av2jqUgq+DL4YbUmLx8sXpfKTKkSRETJWJs0tBBK+WBWaU+cLvFKwKAe9wuiTcbN+JQJd3tp6+oXugcSvwtfk7f9qCrgLORMlndPFQZGuekQ6+8qYxDDt+MU0c+Aj0SNIYIgOYbcjxRjlNooFaIx9M8Y7bRfvDf7NDs/kwHQsY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5740.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(53546011)(6506007)(6512007)(2616005)(5660300002)(8936002)(44832011)(2906002)(31686004)(36756003)(66556008)(966005)(508600001)(31696002)(86362001)(66946007)(66476007)(82960400001)(6486002)(4326008)(316002)(8676002)(83380400001)(186003)(38100700002)(6916009)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjJJUjA1d0xYdkRFU0g5SEU3OHhlV3hDT3NCS2N6UkJPdTlIZnlXaW5HYmY2?=
 =?utf-8?B?dmlrQXpQRTZvdEFWNlYvcFg4RkNrenhJRElwWkNRSTdsVURaWEx3QUMyU2t0?=
 =?utf-8?B?VEpuNm1rL2F3OXU3U3AwMG5ZUWlzN2FyZ0JEekI5d00wMGF2VEZDbmpYTTVr?=
 =?utf-8?B?SWU1V1pkeDNhUU51SS9DVnZnNm9HT1VnWWlCcExaa2lrL0h4aDhZYWhCejBr?=
 =?utf-8?B?bVFzRDlvYVJZVzZlcjNrSlc1Y2lyd1R1REVzNjF5M0Y1YldlVFBjL01CcktE?=
 =?utf-8?B?RXVzQzJwZ2x5THlTb2F6RnBESkNFWnAzcTNSQlkzbjk2V1FwK3N6dnhqbTNV?=
 =?utf-8?B?YWU4RFpiOVdobzlaalhVYm1qZVZESmVxcFFmRE1Ka0NKS0o5bmt2M1dxUTN5?=
 =?utf-8?B?dVZrN2JCTlNBUklHTnAxOVZiVlVBSVFzcTlYSWMzSFg5UkNhdGh2cVhzZ1VU?=
 =?utf-8?B?YXRQU0c2MzlXYmx5aFhGc2tEaitaZzBSRjJBMXdkMDErNEluRk5uSE5mL3lx?=
 =?utf-8?B?WldOTlJzMmgwdnpyWWRONmJMdHJkSUhEV1FnbnJrM3BZdGw0U3pjVXZMbWlZ?=
 =?utf-8?B?UzJmSGd4UEFmdmd6QmVqTURmYjFiSGJlMnRhYTgzM0srVjhIQkVLYksycHlz?=
 =?utf-8?B?SFVEV01MN0p5N1ZrNDNja1BXWnVNb0htV082bnN1TmNhQzRLWXEwSFpIV1NU?=
 =?utf-8?B?YzF0MzRpcHg0eGdWeXhlQWloV1NwMklOWEorR0lNY1lkZVlrYlFUMlllM2du?=
 =?utf-8?B?ZWNDcDVVUnVKWEwrQ3JkWjNYQUplWVkyWW5ZSmczelUwN3JkTlBXUGZxMmtF?=
 =?utf-8?B?Zi80SEg5SVEwd1cxdTlEZ3ZyQmlCMkQ4ZWhEZ29hSFpMdlVZVGZ5MHdwQmlJ?=
 =?utf-8?B?cjFtbk9uOWpBb1BPRW5kNk1NNUtITGxycVV1aTRPZ3J0S25MRmFCdnNMTS9R?=
 =?utf-8?B?eFlmRUhIUmtNRFZvRzU2bWpQcE80NkdQNm9jdFhlWnlibWdRQ1gzYUZYQ3RZ?=
 =?utf-8?B?bGlubVordEt0cm5heldBMEVOY2pFRjBHeXM4VjA0RDZXUEMzQ1pSOVNZTGE3?=
 =?utf-8?B?ZlFmeXVBcUxOektWRGEyc0VEdUhCeVlFMXZ1RDEwRmp1UGRFeTJ3TEdkc2xQ?=
 =?utf-8?B?SzVESHB5TVZSY1FDVGRSamxQb0JwcTgvU0s4T1lqcnhpbjNac3dzTUdVVjNy?=
 =?utf-8?B?WW1tSEZLYjU0dE5EOUtyR0JUUGJGTWRiY3ZSTG1vRVlNTElIUkl5OTlGTVZQ?=
 =?utf-8?B?Um4xVThONnRSUzJrVVlibmlrZHhZZUdHQ2hleUFYWGZPUW42STdEWjFxelJl?=
 =?utf-8?B?dVozUG9xVFErOWVZdUo2Y2ZjT2g5bXlrcGZpNk9PMlFzbHJZVU9aMitPU3Ay?=
 =?utf-8?B?VjVzbHc3ZFV2ZUd3NVEyOXVaZU9lOUJxZUFUMytURTNNYzNUdUt6b2RvZ0RD?=
 =?utf-8?B?dmNtUzVLaG8xeSt1d2xBamQ3MlpueSt2RnlPOFE0Z1NIMnhtUjU4OTh4WHUz?=
 =?utf-8?B?TUYzSjVVL01Vc3pDR3RsczhxMWhqWFB1cnh6c3l4amZnOTRRdnZjZ1p4RGZo?=
 =?utf-8?B?UjVROStyWXhwM3BDTUIxcUFZK2J5VmZ6c3pqc3FDb0lMNkltTDhhTDVTL3Ar?=
 =?utf-8?B?YXFrUjE5bjN0bjJwdklTYkRCekhXVUJQZXRBZU9tSmZSY2FhMDFTeDUwS0lM?=
 =?utf-8?B?UDFXTm8wa3JyalltRFdKVHh6SlgvUG9zSzIxalkvSUtFakxwbU1BL0JGbm9E?=
 =?utf-8?B?TnFaSVZzRUw0NDdjTmVZWGZsazF3OUZldXcyNWNlQUgxOEh3a01wMDBCN1M4?=
 =?utf-8?B?alVGaFQyM0xqLzFoSnFkeGFZazIwSEZMTVFUM21zL2FlYjRRWFJwdDg2Ujc4?=
 =?utf-8?B?WEZSbEErd3JtWVZsZ2N6bjVDR09oV0t0MTJmaTZpRkVLaVY5NExsbmtCa1Ur?=
 =?utf-8?B?WXdjVUFhRmJIUTNmemlZSzFnN0JVejJFQmpSTjU2ckRNeFF4aUxFeEI2SHNV?=
 =?utf-8?B?U2NCTjdpT3hCc1hwNXdNeGRrV29XRjBlN2s5TXh2OHUzRFRRMUMxaDFDbDk0?=
 =?utf-8?B?SWFHeUlGMFFyWk5YZG41NzM4dk5RcUVaVDlrd3ArRFRFbmp2MWlDSmN5cjdN?=
 =?utf-8?B?M3ZHS0FWOFA1L0grNHZWY3RQWlhRamJsNDFlWkpBbEQ2QnYvVFUrNGVKbGFz?=
 =?utf-8?B?WEcvdzN0YXFZWnpLMUVjaHFFNStWVTh5bi9mOGJnV2VKZllrdjB2ZEF6c0xG?=
 =?utf-8?B?dngxNGNqQWN3STIzMXU5VWVORy8rWENKVGFWQnd4RzlpREIwaFNZV1hONzJJ?=
 =?utf-8?B?SG9ScDc1N0FTUUFaYmtsVTlUVzd1OXhqSUxpVURkcDZ3eUYyNlFWdFJ5dCty?=
 =?utf-8?Q?db9nz0YOLs7LsGVs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f652c30e-a53e-4d82-3e16-08da3378547e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5740.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 18:01:53.5185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxidIj4JYpmncq8wduL5b/RS+6fP3MLin/lBnIyU13ZC95tMa/8dF5fzorMX0OvNLiMEAdYPX3+j7MihACSEauF60TsDz3ME+OvTKXjKpBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5174
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 5/11/2022 3:43 AM, Jarkko Sakkinen wrote:
> On Mon, May 09, 2022 at 02:48:00PM -0700, Reinette Chatre wrote:
>> Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
>> after faulting the enclave page") expanded __sgx_encl_eldu()
>> to clear an enclave page's PCMD (Paging Crypto MetaData)
>> from the PCMD page in the backing store after the enclave
>> page is restored to the enclave.
>>
>> Since the PCMD page in the backing store is modified the page
>> should be marked as dirty to ensure the modified data is retained.
>>
>> Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>> Changes since RFC v1:
>> - Do not set dirty bit on enclave page since it is not being
>>   written to and always will be discarded.  (Dave)
>>
>>  arch/x86/kernel/cpu/sgx/encl.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
>> index 398695a20605..2521d64e8bcf 100644
>> --- a/arch/x86/kernel/cpu/sgx/encl.c
>> +++ b/arch/x86/kernel/cpu/sgx/encl.c
>> @@ -83,6 +83,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
>>  		ret = -EFAULT;
>>  	}
>>  
>> +	set_page_dirty(b.pcmd);
>>  	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
>>  
>>  	/*
>> -- 
>> 2.25.1
>>
> 
> LGTM.
> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

Thank you very much.

Based on my understanding of Dave's feedback I do plan to move the
set_page_dirty() to be after the memset:
https://lore.kernel.org/linux-sgx/8922e48f-6646-c7cc-6393-7c78dcf23d23@intel.com/

Reinette

