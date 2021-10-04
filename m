Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93E9C433EF
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Oct 2021 21:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28C5617E1
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Oct 2021 21:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbhJDV7j (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Oct 2021 17:59:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:42689 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233819AbhJDV7i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Oct 2021 17:59:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="248851693"
X-IronPort-AV: E=Sophos;i="5.85,346,1624345200"; 
   d="scan'208";a="248851693"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 14:57:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,346,1624345200"; 
   d="scan'208";a="487730087"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 04 Oct 2021 14:57:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 4 Oct 2021 14:57:48 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 4 Oct 2021 14:57:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 4 Oct 2021 14:57:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 4 Oct 2021 14:57:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvk8QkvlWlQwoVpYydAsU0l9mqCIPY9sP7rFOnjF+Y1ix0tRIB40gLTuvgrlzxa8iAEWb7IKWv0y/+kLXApDeYdTmJEm2iF3cyACHxCfoPj2JdQEl9BPZ/AiZkSV7w2Gj7pPdDWFVBjFru1Du/AiX5DENWrv9XUOSfUmIiTSQPSv3YbQcs58mESjSRkLXBoV77F3MYbrpcXOKMlz1b2+jjV2e7dpT6rwFZBsPS0fspywLXcM6rcPK5nMjAPFes5fsM1DcDeEOi59ih5bxKcWMUTgO2xZ2RhSqVdxYAtbZAYqtDE3KAbrIb4WjYNd6KA3xxPP+heCyO/i8xQGLmY2bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSpbrvK74MII89HIdiVtU6gBItKcFY+XBi5UYfPQk48=;
 b=Cb/I5Q24gNBKkKtB/tnr6XcizOf2ZTHFqYzPYfmVOuvZHLFUVRc28Q81aUXrakiAmp+ryP1zmgPXX5peRxzquxKBfzNIHgpeSwoacXyFdcGnkkdx3j9f3dBxVulUuukSda0kzaccJ1lm09PtN5ZzltDvctambbjih/h/X8N5ebEHMDJgUcLgmLXdfe3/az47ab9vub4TU2Y7oz59hNthTHqhK3WEy7CW0Bo3LFctBfuJxo6MQ8gERGEumoJyQVwLI4/qPnmgljP+7hnCFhadiH3nwC/Z4rlHXRnX305q5liNspR8x6MHr4VvbP1sKgRO2ArmrxZcp906msXUdNnRuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSpbrvK74MII89HIdiVtU6gBItKcFY+XBi5UYfPQk48=;
 b=b0imv33ykfDUe599Ob0PB3yrB6v45GbitjhPbabwNJwN9J4d0fvM9Zr/lSG8Juvqmu0dpx9jfu2vA6dBzL5mi0ZydaVQ9SlYB7WqhZTts/7yuoaE8RKmA6qVNfdAH2LaLdIcDEyJg1m9C/YL7AzhaGabvru+v5kzhzMxp5yb6rM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN6PR11MB1299.namprd11.prod.outlook.com (2603:10b6:404:49::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Mon, 4 Oct
 2021 21:56:36 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::d47c:525:2aef:f6a]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::d47c:525:2aef:f6a%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 21:56:36 +0000
Subject: Re: [PATCH v8 0/7] Basic recovery for machine checks inside SGX
To:     Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
CC:     Cathy Zhang <cathy.zhang@intel.com>, <linux-sgx@vger.kernel.org>
References: <20210927213452.212470-1-tony.luck@intel.com>
 <20211001164724.220532-1-tony.luck@intel.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <09a57e26-2ae4-377f-0eed-ac026115f002@intel.com>
Date:   Mon, 4 Oct 2021 14:56:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <20211001164724.220532-1-tony.luck@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0237.namprd04.prod.outlook.com
 (2603:10b6:303:87::32) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
Received: from [192.168.1.221] (71.238.111.198) by MW4PR04CA0237.namprd04.prod.outlook.com (2603:10b6:303:87::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Mon, 4 Oct 2021 21:56:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b18f3be3-4c6f-4e4b-7035-08d98781d663
X-MS-TrafficTypeDiagnostic: BN6PR11MB1299:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR11MB12996D4863F66287180FAE63F8AE9@BN6PR11MB1299.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: im+jIL0ktzWDoSurWRCMoQVeaOdgvuYmK4oVSzV5p7SF5FI5j1mjGOjkYRNqOsPKRN476nMzj5zyrwbKJTdClW+8aEbofj/4/8+Fb7KXa0jBi0rbxPXQjjjgWyu6HvvLbmgxWBu7/766H5pyPYiuYdJvV8hPbxj21QPtMjSvOCdbc5fOECxS8rLVd8bKekPhQCCQdyyqdjutL/LRIdUEvbOEuL9llMG4ZLUyjRdJK7jHIrFvqoPMWc5+FODI/VKQs9NgnhuxK3unV+2ypVowrODdicUGYf18PNDo5Lwr6Of/9fyxVAkjf2LMJkTp2oRHeyPpCTGJqKbl2l6h8qi/Tjtk7mU+nIGTEQvSbLysBNuBL+w9eetpxoBs4IUgCH0X91mp1a5YfqzroeFqWrTbmJ0lj+ukL+z25PGWr3qS5PBdM+4mZYXHbXlfkp+ZBavR97DWXJnPWz12c5Na3z6CJGaiELjTq3UbiPmx4xP6kgd1ZS+PXsALCrzdrNdz+HwtO2ulzA3HyzyXjDn2CEAatl17yiVioCueRcrbuT/KZHtpZi1mI5vMwIcw+eoleJiHQWNm1q3F0cA1RZhAdFBghGuoe3GjK0f0265XR0kLoB2cBRaw3y8XUrtIuxyh874VubhUqlpW759iyeaUincKTKh+BuraNiWl14hXVdZZTe5Vb2cCi0qI7o30e8IuQ9yMaMOfNvlBzi0jrS9SFpkUvzN7RuRjIZqnA+jzBX8l5ceYT+Vu33fAANXzB0lW1ExzLecJ/nSalPSOO2JOEisV40nIu4uAsblmlXrhdNRWiTZjb2LpeVHVX9jPKInA6gFgxxyRYHJSEUpCPTk2BhS4FA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(110136005)(83380400001)(86362001)(16576012)(31686004)(44832011)(6666004)(5660300002)(4326008)(6486002)(66946007)(8676002)(26005)(31696002)(8936002)(186003)(36756003)(38100700002)(2616005)(53546011)(6636002)(956004)(508600001)(966005)(66476007)(66556008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVIwWGhCL29sS28zTjZsNm4yNjlSeWhIVE1jQ2p1MWh4ZEM2M1VPS29jNjIz?=
 =?utf-8?B?SjI5aGdxL1BVNGRPTkpCRlFQcWlVeEFzaXU4cyt6WVFtenZXT3RGNmo1WUFJ?=
 =?utf-8?B?MjkvNDVRNmtmS004ekZ2dkFVZ1FUNG5xRUtVMi91SkZ3SG8zNWFsUWdFMlZH?=
 =?utf-8?B?VVNVUE90WTIwYkQwZnM4anAvRUhNaCtZTnlmSEgvbVB5b0VVV2kyQU1FUm5N?=
 =?utf-8?B?dmhJcTZNUWxjNVdNYzI4cGt3dmRGY0RYZk1RY1I3ZndCZlU4dUtLVHo4TTF1?=
 =?utf-8?B?VmhWaTBCS0NQK1JLZ3lmaThWTk1KS01wQklCS29na1NHRGk5WnMxOUdyaTJF?=
 =?utf-8?B?VWFPbyt4NHhoa09rblVQVWtTQXB3ZldTNGlpcy9XRGh2QUVpVUNBbXNGejkx?=
 =?utf-8?B?c3E5V0FjUVNJaEF2R2RzUS9leGFRRHNGaUJ2RXZEcW1uMTdkZHVYeG9MU3VQ?=
 =?utf-8?B?WlhVL0RwUE1YeWxNVHR6dExJblkvQno0WVhWdzQ5cnZ2UkhkZWg1Ym54eGdu?=
 =?utf-8?B?cTI5OEdFTzV4dzdWT0wrTzFNaEVkR2QrSEI3aXRnNE9aMEFzbUpHcVlwdksw?=
 =?utf-8?B?a3JLNzRzUlplQ040eDhMZFNGSU5vRUU3RkMwWU5WRlMvVlpDM2Z0OERORHha?=
 =?utf-8?B?NTVFeEluekRKaXhmSWV6US9teDN1Qk4xaWFYck5LZXNwVlNoVHVFQk5kb250?=
 =?utf-8?B?WUo0WC9QVXpybXRLVEhLR0hHMVk1b3dIUjFMRG9HVFBzZmNOR0w2RjV1Z1RN?=
 =?utf-8?B?ek0xSVZ4bDltUVg2NnM3dXlxakFxdGZJTWsxZU83WS9GeFVyclZ5TjZvZFBJ?=
 =?utf-8?B?dE43WGJ6UnlDV2JDV3F3eE9IT3dxbDV5V1dOV2R2RGlMZTBCWi91UVhzQjFi?=
 =?utf-8?B?VW5IV2owUTlBaHkvTmMxMVZOZHR4Q0h5SHZlS3B0UVoxZ3hFaGFxMlc2NGtD?=
 =?utf-8?B?bmZpcXlDVUFBem9rZFptY0xZU1V4djFCV1BTN1ZzeGRvcnBRVTJXSUQyL25u?=
 =?utf-8?B?bzdrVG1qSm5ZalU0d2ZjMEMrWk1rMTJaaGg3aU1XZEY2SGkwcDg3TitwTEVa?=
 =?utf-8?B?bk1JOTZBUXZFRXFtcnFIc1p3UWJlVmo2Q2NzVWpldk8yZlBudThSakxlNnNT?=
 =?utf-8?B?czhLT3ZkeGR1dk03YVNnMWl5S09kT1NRWjNWSUlMUTZENFRqYitEMisrR25j?=
 =?utf-8?B?NmFZczhuVE1VUFU1ZUlTWit2ZUVWTnFnYVhFdVZqOC9TcThLMFpmMEdhZ3o2?=
 =?utf-8?B?a2JnekVWWlVwODNGV1hxaVlqbWlxZ0lGd05WeVZxNmJLclBvWWRKYmlLR01K?=
 =?utf-8?B?VEtFQmtKcUZCK2FVUGE4U1l4NW41LzdIZXhwM0hVV2xUVlI2akc1ak83WFB6?=
 =?utf-8?B?eUxsTXc0SHJGeVJBVXpBdWswQUdPTGJNNzJjR2RrYVRWSy9ZZnVlRmJLaHF0?=
 =?utf-8?B?YjV3ZFIzQktjbFNDRFNRWGpZKzF1dDVnWGRqVnVaVTlsUVl2endtKzlpelRG?=
 =?utf-8?B?NjhZK0VkSGZORkRuQ0YyRDBnUTBkY1ZXamhpWmtCLzlJaFRLN2dBZUlrZWFY?=
 =?utf-8?B?T2E4K3VMdzNDRnBiN0l3RjNYOGxraGdBZzIzV3JjekhuTFNydVJYMFNac0ds?=
 =?utf-8?B?eTBMWW1OMzk3SW1GYVFlTVRMNXFDeUlvRDc1K1Q1VkhIc1QvNGxGTnZjdU1V?=
 =?utf-8?B?VXVlMmxyR2tEaDdNa3dlaVJVbklsRlBTenp5Y0NHOGU0NFN6MnFSV0NLSlB0?=
 =?utf-8?Q?ohJ8Z8vFsosuclR0htnV/6kKm6I+J7evBkAGpUf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b18f3be3-4c6f-4e4b-7035-08d98781d663
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 21:56:36.8172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B7yDIIKfEC1/9LsOOvapxsUFkgtJfAzBAXaP9Ppp2Q8BPf5lEDiQM3fRvmtu5T147r8ggWb7SXvP1JmWNnnGwU8NER3o62YVD5sdWwXseS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1299
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Tony,

On 10/1/2021 9:47 AM, Tony Luck wrote:
> Now version 8
> 
> Note that linux-kernel@vger.kernel.org and x86@kernel.org are still
> dropped from the distribution. Time to get some internal agreement on these
> changes before bothering the x86 maintainers with yet another version.
> 
> So I'm still looking for Acked-by: or Reviewed-by: on any bits of this
> series that are worthy, and comments on the problems I need to fix
> in the not-worthy parts.

Tested-by: Reinette Chatre <reinette.chatre@intel.com>

Details of testing:
I was curious how the signaling worked after reading some snippets that 
a vDSO does not generate a signal. To help my understanding I created 
the test below in the SGX selftests that implements the test sequence 
you document in patch 6/7 and with it I can see how the SIGBUS is delivered:

[BEGIN TEST OUTPUT]
#  RUN           enclave.mce ...
MCE test from pid 2746 on addr 0x7fc879644000
Set up error injection on virt 0x7fc879644000 and press any key to 
continue test ...

# mce: Test terminated unexpectedly by signal 7
[END TEST OUTPUT]

Below is the test I ran. It only implements steps 3 to 7 from the test 
sequence you document in patch 6/7. It does still require manual 
intervention to determine the physical address and trigger the error 
injection on the physical address. It also currently treats the SIGBUS 
as a test failure, which I did to help clearly see the signal, but it 
could be changed to TEST_F_SIGNAL to have a SIGBUS mean success. The 
test is thus not appropriate for the SGX selftests in its current form 
but is provided as informational to describe the testing I did. It 
applies on top of the recent SGX selftest changes from: 
https://lore.kernel.org/lkml/cover.1631731214.git.reinette.chatre@intel.com/

---8<---
  tools/testing/selftests/sgx/defines.h   |  7 +++++
  tools/testing/selftests/sgx/main.c      | 35 +++++++++++++++++++++
  tools/testing/selftests/sgx/test_encl.c | 41 +++++++++++++++++++++++++
  3 files changed, 83 insertions(+)

diff --git a/tools/testing/selftests/sgx/defines.h 
b/tools/testing/selftests/sgx/defines.h
index 02d775789ea7..2b471ba68e91 100644
--- a/tools/testing/selftests/sgx/defines.h
+++ b/tools/testing/selftests/sgx/defines.h
@@ -24,6 +24,7 @@ enum encl_op_type {
  	ENCL_OP_PUT_TO_ADDRESS,
  	ENCL_OP_GET_FROM_ADDRESS,
  	ENCL_OP_NOP,
+	ENCL_OP_MCE,
  	ENCL_OP_MAX,
  };

@@ -53,4 +54,10 @@ struct encl_op_get_from_addr {
  	uint64_t addr;
  };

+struct encl_op_mce {
+	struct encl_op_header header;
+	uint64_t addr;
+	uint64_t value;
+	uint64_t delay_cycles;
+};
  #endif /* DEFINES_H */
diff --git a/tools/testing/selftests/sgx/main.c 
b/tools/testing/selftests/sgx/main.c
index 79669c245f94..2979306a687a 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -594,4 +594,39 @@ TEST_F(enclave, pte_permissions)
  	EXPECT_EQ(self->run.exception_addr, 0);
  }

+TEST_F_TIMEOUT(enclave, mce, 600)
+{
+	struct encl_op_mce mce_op;
+	unsigned long data_start;
+
+	ASSERT_TRUE(setup_test_encl(ENCL_HEAP_SIZE_DEFAULT, &self->encl, 
_metadata));
+
+	memset(&self->run, 0, sizeof(self->run));
+	self->run.tcs = self->encl.encl_base;
+
+	data_start = self->encl.encl_base +
+		     encl_get_data_offset(&self->encl) +
+		     PAGE_SIZE;
+
+	printf("MCE test from pid %d on addr 0x%lx\n", getpid(), data_start);
+	/*
+	 * Sanity check to ensure it is possible to write to page that will
+	 * have its permissions manipulated.
+	 */
+
+	printf("Set up error injection on virt 0x%lx and press any key to 
continue test ...\n", data_start);
+	getchar();
+	mce_op.value = MAGIC;
+	mce_op.addr = data_start;
+	mce_op.delay_cycles = 600000000;
+	mce_op.header.type = ENCL_OP_MCE;
+
+	EXPECT_EQ(ENCL_CALL(&mce_op, &self->run, true), 0);
+
+	EXPECT_EEXIT(&self->run);
+	EXPECT_EQ(self->run.exception_vector, 0);
+	EXPECT_EQ(self->run.exception_error_code, 0);
+	EXPECT_EQ(self->run.exception_addr, 0);
+}
+
  TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/sgx/test_encl.c 
b/tools/testing/selftests/sgx/test_encl.c
index 4fca01cfd898..223a80529ba6 100644
--- a/tools/testing/selftests/sgx/test_encl.c
+++ b/tools/testing/selftests/sgx/test_encl.c
@@ -11,6 +11,11 @@
   */
  static uint8_t encl_buffer[8192] = { 1 };

+static inline void clflush(volatile void *__p)
+{
+	asm volatile("clflush %0" : "+m" (*(volatile char __force *)__p));
+}
+
  static void *memcpy(void *dest, const void *src, size_t n)
  {
  	size_t i;
@@ -35,6 +40,30 @@ static void do_encl_op_get_from_buf(void *op)
  	memcpy(&op2->value, &encl_buffer[0], 8);
  }

+static __always_inline unsigned long long read_tsc(void)
+{
+	unsigned long low, high;
+	asm volatile("rdtsc" : "=a" (low), "=d" (high) :: "ecx");
+	return (low | high << 32);
+}
+
+static __always_inline void rep_nop(void)
+{
+	asm volatile("rep;nop": : :"memory");
+}
+
+void delay_mce(unsigned cycles)
+{
+	unsigned long long start, now;
+	start = read_tsc();
+	for (;;) {
+		now = read_tsc();
+		if (now - start >= cycles)
+			break;
+		rep_nop();
+	}
+}
+
  static void do_encl_op_put_to_addr(void *_op)
  {
  	struct encl_op_put_to_addr *op = _op;
@@ -49,6 +78,17 @@ static void do_encl_op_get_from_addr(void *_op)
  	memcpy(&op->value, (void *)op->addr, 8);
  }

+static void do_encl_op_mce(void *_op)
+{
+	struct encl_op_mce *op = _op;
+
+	memcpy((void *)op->addr, &op->value, 8);
+	clflush((void *)op->addr);
+	delay_mce(op->delay_cycles);
+	memcpy(&op->value, (void *)op->addr, 8);
+}
+
+
  static void do_encl_op_nop(void *_op)
  {

@@ -62,6 +102,7 @@ void encl_body(void *rdi,  void *rsi)
  		do_encl_op_put_to_addr,
  		do_encl_op_get_from_addr,
  		do_encl_op_nop,
+		do_encl_op_mce,
  	};

  	struct encl_op_header *op = (struct encl_op_header *)rdi;
