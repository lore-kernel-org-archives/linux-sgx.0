Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED9EC3E8A8
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Apr 2022 21:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380731AbiDDV0U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379077AbiDDQ3N (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 4 Apr 2022 12:29:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CBF3464D
        for <linux-sgx@vger.kernel.org>; Mon,  4 Apr 2022 09:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649089635; x=1680625635;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gUTjivseYh1kyX+/2uVYSmQ/aRMY/17DhNHKtRno8qM=;
  b=hDGOxv2hv/HHE3iT0Tw9Q5R7ib0RDCNdGFBTNQlPFoOSrXxW2O+lDBke
   c06xYKabwqTiMVu4Tl9NRgHKVDfn6WVtqUl1om+otwqdeNdbVTNeMDmYf
   zP+EMZf1YeKV+WWyRVrbOEqPSjnka+tdbKnR2/rA/vMEW95pbeRgj/tOu
   ytU5/hwvAjAEIFARH4797egmOfy+aXCaTdiTHzYE/Uv7TimnDpFt4rLdK
   Vxao+CgNOlTKit6aqeAr+/XgzYETqjRLN6RBqBhWZjteAB2yLgMYkyAKu
   XxpBdD4U9GXECgB7ZrdLZjaPA9X5gx0a/7R0rj4SzrXPLOc0or4cW+9rg
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="346994198"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="346994198"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 09:27:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="696623826"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 04 Apr 2022 09:27:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 4 Apr 2022 09:27:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 4 Apr 2022 09:27:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 4 Apr 2022 09:27:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIez0WlcUU2OBpPoWjxX0iYMyQEdM/wDEjYrfIcXKKUaxC2K2/gmHotGSIkhtKM84y+89gbRhiLNc0sFu5pHSE/uWINeer4wVhfE+832lqilTCOBmTHj8SGEApN/zP618AXcV0e6yUYpNW5eDVAXECUrjNsj1wI2IkRsZ9iPViA3a3djr8vcKZqSeNm9arQLm1hlU1ZRQWbZqvXkXvdX7nf3j9pwLaeKCVVpbz39WwXWTLDvsHm1VEKpN0H9YNB+kk48UuQtXsnraQsnUxLmYLCfI3uDEVaat4UPBe6Bs0pkKEzQsNUzGhPkRjpZMmQJUt54dWlK8mBnAKdz++t60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QahSOjLCnw7Yk2afmMGlqY3zcckA6xwkVznvUKznn0Q=;
 b=kpxMtqb7oaZD88C9evcbSdjhROGjYsucLKSXOxYCYib0Y8nR7vziaQsei4Pwm2ZNw6nB0wL16gbm/09PPkiPp9PBB5KV0n889NJ19cMaUxCjNg7jPibggzBz2B2cRvZdb4fDG6Olu9Gvs9ZiH0CUo6cb4x3In8uwHMKUrw6jQdZHoXU3OZeKcr+PaGoxWeft644C5EWOqzNLM4N8kudo6T5Xst8XsPCbWwx5d+g0cLit7jMa3jbRUvhMS3F6oujw1FxptlC8VJ9ooa7jTun7S9iTspYn3c93XPLHOSiESfkpRw1pUhiOVt9ONoU3yz4VdyZPVH/3Rt7uQDWhl4fVjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by MN0PR11MB6060.namprd11.prod.outlook.com (2603:10b6:208:378::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.25; Mon, 4 Apr
 2022 16:27:13 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::918d:6022:8ee6:3e36]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::918d:6022:8ee6:3e36%2]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 16:27:13 +0000
Message-ID: <3d2b5a6e-f59a-e5fc-9349-5449d6cc7267@intel.com>
Date:   Mon, 4 Apr 2022 09:27:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: Odd looking #PF fault code
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     <dave.hansen@linux.intel.com>
References: <YkoyvdqIqkaOk8NL@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YkoyvdqIqkaOk8NL@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:303:8c::23) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 761b2c35-6404-4838-3ca4-08da1657f9a2
X-MS-TrafficTypeDiagnostic: MN0PR11MB6060:EE_
X-Microsoft-Antispam-PRVS: <MN0PR11MB6060A2B59DB7269FC89E9188F8E59@MN0PR11MB6060.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WLfPa1xgB0B/9CogaPfAc6S6L/j5b1CvSfvpyJLjsa0Xklf6WwJBBZH2VAkSfhSe10Ljnrj3gSiNZszURnH0yMgNywtDAURiQFtGk5s5K5LDBpUF8LsyUdKv9jRuIc/EvUf8o1y4iSTEbF/GxleKWRQqAvJAC2BEwelhRlR4rN/Jmgo/zP6XgyPFUkE9rLIzJSnyPTLQVlZXDqSawnr756KaHAukwbq25MsN0g8VXAr/8ezGnfOVYVWMf++tFadqf6fJKExVsywKkGAcLLVKqBMTjW5/IT040r54iIPT8p7n1Xw7LT1K7Clvk86NNgFomVDekF6Wt5EUSn7lNupa2Hzf0IcgWkT3qyHdNUYMaoGjJ9bSS3seji5g+OgEumOuLF5VEVuyMfwgDsgonQC4UXzgL/Gz7lxsDc0nu6dA/if1DOtFXFK6FN8ooh0ppxTS9OGq9H3nlw2p/q+un8sdgmt+U8bo84mxLE2Y7h984WheFgKUP/pcWojEfpOV2CEmEUI44uJ/SEQu5trbvxCE4/uVxhaexN9YognSHJNeBD3eKBMGeQuwU1KIDuNz5AEmJ2WWEwNBu346X48XXVb+XqCrTY0pDqVKTV4XxPYKokHX+dNFxR9eIyyXCKiucY1cFvXEXqKUAISQFC0oJ2QV8Q3IunbIZNOk+mNS9y7ysP0YgIgImHepG7tPP3uYyXjX8LzsmVQgiuvMbpmny+kPVxblcdtg7j23LWZOxMnWEVjSzqzEqBdGwjdiolCTol71ps0OQK2vJNQZHTOI/878XKjbPUhjW3Fj37JsjjsKYY7TW2sDZk9HGb0Z1Ybf44BoEbzvd0ogAGrYY3PwW/TJ4e31e6O+zHu5Ns4UuoBZiVw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(186003)(26005)(53546011)(6512007)(6506007)(2616005)(66946007)(38100700002)(36756003)(4326008)(8676002)(5660300002)(66556008)(66476007)(8936002)(316002)(31686004)(508600001)(6486002)(44832011)(86362001)(31696002)(966005)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnlQV0wyQ09WekI3TVB4ZWIrVUVlNEdNMTd6Vy9mbldETExqTElXSDk2SVJG?=
 =?utf-8?B?Mm9zOFdnclB1MXhRK0Jsam9ZcTNTcjJkTWxZSFF2bzNGNkVGbDJRRVFOTW1k?=
 =?utf-8?B?Q09jc2pFVGRpcU56MHhxVGZ0dWRhNUZSekFUMWZWRVYyc0cwRVRScUlUSC91?=
 =?utf-8?B?MlBBUFZhS01Sc3B4Z2NBRFVEZmNoQU1BTE4wR01BSEVTS2xrL3BkRXRrdVZk?=
 =?utf-8?B?Ulk1S042bG1XWVYzNTZWUmhVME1FS241VXc2YzE2bUxUYkxSREFkUFRTV0Ny?=
 =?utf-8?B?STdSZTBPcGlacEM2NC9mRXBzbXI0anVaSUd4bVRLSEEyRXRGSnJkcXRXczVK?=
 =?utf-8?B?SDhNZHZlRGFWUkk5UEJvOTNTRDdGdlRxcWZBZjBCdmcrYnVlU0NRKzg5aExZ?=
 =?utf-8?B?akRYMDZnNFJMcnVOVDZWVWZWOUVncmorbEN2UHB1bGl5TmRGd2JpUllwYnlU?=
 =?utf-8?B?U0xxWkQrRkRIc3ByZzRuODlJTVd1akVvSUlzSW50TEYrbXU0MmRPZnRFenB1?=
 =?utf-8?B?T0lDakxwMFg5TFloZmh4aEVTNVFpNlI3VEdaQ3d3eUVTYlVXQndzdW1rVHp6?=
 =?utf-8?B?ZDVpcVpydXZPVDNRWEpWbU9EZHhMT2QzUHluUlprYnZzbjBISDZoQmorQ2pV?=
 =?utf-8?B?TDlWZVNCWkhSSnYzMXZZTTFrR2E1NnhmNi9yZWhmV2tOeWFPZUNuNHNxdXNU?=
 =?utf-8?B?NFJURG5zdDNtcDcxTzQyOThPK3ZrTzlQaHJVZzBEWmpYOURyS2RuWXhDWTlQ?=
 =?utf-8?B?dmVDZzE5U2xiQ3dSc0ZFSk9WMnpMdUVlZFYraUJFRnpaNkl6RkU1MGxzWHJH?=
 =?utf-8?B?SUZNV3lRVEdsOEpUYXlSYS9uSzh3YWVJTDYzTEJwK2RHMEdYQTg5VWtxbWN2?=
 =?utf-8?B?dFgzUkVad3lMbUJ0ZzBVcThQVWJtbTJBLzNIK2tEKytVVnEvcU54UVFHY1dt?=
 =?utf-8?B?UWozSDVKWk5SYkFMVzlhV2prc2xjUndyUkV4cS9EbkgvMUowUDZOWmYyUmVV?=
 =?utf-8?B?NHVLSThOcU54RFNBYmdRUjBKNUZ2RFFxTWJBRllsRCtGYmhJOVRUY1V4U29l?=
 =?utf-8?B?YXNrVGtnZFAvSlZLRTNrU1N3aXRuQnk1TjRKU3JnSXlQU3JNNjNEWnNIT0cr?=
 =?utf-8?B?UU1TQ05IaWhWMFl0TXZ4clFLVWpVNk1GSFpDWjFUSXRJR0FzR0cyUGExU3VW?=
 =?utf-8?B?dDR3VzBkMzdqaFZuaW5ZRldOYUV1Z2YyRmtoRFBiMzVpdE80UzltTS95amVQ?=
 =?utf-8?B?UklaSHp5aVhaRkkrVVlyNkltRlpjQnRqVUUzbDQ4UDhubWtSOGpucHdxL1Ez?=
 =?utf-8?B?cEViK0hzVFZJQmhUNzk2SFRReVl3L3c1d0xTbVo1UFliWUdob0lnVGs4OGE1?=
 =?utf-8?B?RVVMaGdlOGtrd2kvbTVEcnZuMDhLdUxHdElJQlJzQ1hPcThRYVNoR3dJYVA1?=
 =?utf-8?B?M1l6MnhCRTNHekFnY1pqTTJUWUhxamVaa2hNdmxrRjcxeUEyQ2FLMDdEWjA2?=
 =?utf-8?B?MkZCZWQyUEJUcmZsaUp5c1dXc04zSVZPQXFmdytmMWJJM2FJeExDd2RhQU1D?=
 =?utf-8?B?aFRkNzM0ZHd2UVcydTlaeUpQVXpwVWRYbzRGZ0lNU1F3MG5OSmxpZW8yOUk4?=
 =?utf-8?B?bzBHaitiOUFPYVdHcUtEUXRDTGhmQnJKYkFLYUpPVEVpaEF2c3lLbmtOZDhL?=
 =?utf-8?B?bEUxWGg4N3lQTVZqTG9BL2pZS09ta3FIZmYxandhOUJVSVBzQjNDODVNZVVu?=
 =?utf-8?B?QTl6bmpFcVdHOGF4TDQ4QlNjL2tndjNqSFhndXJ0Wm5ZMkpYMVlub2ZKZk1r?=
 =?utf-8?B?dTlpbW50RmhjOUM2MXdndDM0THYveEVKRWJ0Uzl5YzF4c0ZXZlZPeFh2ZFVV?=
 =?utf-8?B?QUgzbmlyaEJpcWhhckpHUGFsVmZMb08xenYwVldRWTB1UGFqSzZNV2tCUFRm?=
 =?utf-8?B?RGVML3RyMzJSSXR1aVZWc20zYTI0Z2hBdzNVbVpTZmR4VjlQYWh4R2ZuejlB?=
 =?utf-8?B?NHJ0dnJKWVo2dFgzeG5IS0M0M2x3cE1uR0lpVUJraUFLcnFaZGdlcGNxd1lt?=
 =?utf-8?B?OXVxa1dqTlhKQitBR2ZqU2tTYUFJU1NsZ05TUnpGMXdtbU8wQjdEZWpJb2ZB?=
 =?utf-8?B?QnlZU3N4aUtGeWdJSS82MWZJaFZ6Smg2ei9BK2tIT1lUM1NwVEhrV1RJTEpa?=
 =?utf-8?B?TVlGWGJ1WjN1TFFyWm1QZDlYZjVKbjZLaEtzZXVNbEV0d211K1oyMTJFOG9h?=
 =?utf-8?B?S1lRTXdKNkluSG51Y2U0SVAzcVUwL3hCUTVpWWVMOWpYbEtSa1l5ZU56Qm5n?=
 =?utf-8?B?T3RoTGcxV1cvV1ZMbzgzcWJGWFN2M1pFMmcxNTdBTm9Ud0VPWEMxTE1NWFNt?=
 =?utf-8?Q?btf4Q0ssDF2ddluA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 761b2c35-6404-4838-3ca4-08da1657f9a2
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 16:27:13.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9C1/8FhZ+RMbXcssfc9TpXr+W1Zmznjb37BX1RTzzQv+scvZkhFlsKc4ydXXjgwec++7ei/io4S2Pf9+UYljOMrGM6cNf1fmqwP0N1WNgIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6060
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 4/3/2022 4:50 PM, Jarkko Sakkinen wrote:
> I get this when trying to get EAUG-EACCEPTCOPY to run on Enarx and I get:
> 

There seems a difference in the error codes described:

> Unexpected PF: address: 0x007f7fff910000, error code 0x15

Error code 0x15 translates to binary 10101 which is:
BIT 0: Present
BIT 2: User
BIT 4: Instruction fetch

> 
> I'm using patches from:
> 
> https://github.com/rchatre/linux/tree/sgx/sgx2_submitted_v2_plus_rwx
> 
> Fault code is in other words PROT|WRITE|USER|RSVD.

PROT|WRITE|USER|RSVD is bits 0,1,2,3 which is 0xF

Did you obtain 0x15 or 0xF as error code?

If EAUG/EACCEPTCOPY was followed by an attempt to execute that page
then 0x15 error could be explained since the page would only support
RW permissions at that time.


> According to arch/x86/kernel/fault.c:
> 
> 	/*
> 	 * Reserved bits are never expected to be set on
> 	 * entries in the user portion of the page tables.
> 	 */
> 	if (unlikely(error_code & X86_PF_RSVD))
> 		pgtable_bad(regs, error_code, address);
> 
> Any clue how this fault code could emit?
> 
> [*] https://github.com/enarx/enarx/pull/1608
> 
> BR, Jarkko


Reinette
