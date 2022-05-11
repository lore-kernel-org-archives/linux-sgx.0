Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF40C433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 17:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345466AbiEKRXh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 13:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345045AbiEKRXg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 13:23:36 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483582108AF
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 10:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652289815; x=1683825815;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ItJETMjY6MjMF5Ga0sjFCij91orrSqp8PssdFSPr5bk=;
  b=exkj3bGJooRF7vlmakhfP4OcsYog2zgSaQZVzUPxSNUxE8aGwpAMjCrW
   AFS6gDef3Re2kvLf3L9nEEVUDOL3QENn9sQnLO9XT89dggHpbHletU2vJ
   ANAOn/iH+4C8m7JBqxUKbbGVi6w/kU2nhxO2DCvV9LRJBaYIAbvC8uoGH
   /WAT1weHv0AlZVB9MWoX9jmg9TTE4ybtf7eaydwWyrIN20Cgj5woE1NZI
   Z0NxCl8tfTOpDU3MQUmcZde3OKI2T2KPBv3c7Zb1gENgkmwyi42kH7yfH
   0aEPZJ0LU4i7/FHoN7lvP6HrwqhqhYtYs4CPQWS2IyLSXrd2xfUSdK+4V
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="330363965"
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="330363965"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 10:23:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="739313076"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 11 May 2022 10:23:34 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 10:23:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 11 May 2022 10:23:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 11 May 2022 10:23:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVacaWnCIw+VhYyFOTODhouEGu9vxwSfBFqEDkpLOmqqJ4dAk7Eki2evr8eb4XJovsy7Tvi+FS5TJm9jaQrB6Jdxv/nkpCkKJEzjbyJZ7H0cEbN6Fsils3eSxCcZaQAn9ENmd695ZXVGiyEHCClgd0wETmrYV9F9EB5l0bvXtlspa2fme3hOJg+dzPfVzD4X+P21ou9+k7PBV8bu0ubHF+o1wZxGgB0MVJlHVwSQ0/sOROSLtkk9X6ykEySwE+k1ekBhOAn5f3GTTYPzt31Gda4d4i2ZtU/wQyjM6dd/sXL8QS/iehGVTz25mbThGeLfJ13hOjGEacLfQCq/j1bViA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwqbjoSkmM+PdfbNlBtCp2xLm9ccEy4pmw3wjoUuWv8=;
 b=VHiNsBApRRbVuR/nNWxiLCe2GAM1UotogB1IUB9B4eY1Nt0de57k+o2n7Deku6yADw2iPWEYpVh+xz9PT5N13ca30+0Y4SPb6i+NWYpczn950JGGSx3/554HIknEjgWkd756rm713xdrcpZibhh0zyCZbv14lY8sIEw+6FCGTiuBIBGumxL9z3TibZZghHj1eONJYAkIgAqWmBN2FUQfCq+yCv2wpddyvnofcIgrov3Bmm5dG1nmzJ3dHqvwYrYSgd81mLE8CF4T7BWXesKrnmM66yziuiVajG7CetNBZeHND8wn6wxd9VjQavjR6FlZJaE85n3lA2ol9VLOwutKHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5740.namprd11.prod.outlook.com (2603:10b6:610:101::7)
 by IA1PR11MB6369.namprd11.prod.outlook.com (2603:10b6:208:3af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 17:23:33 +0000
Received: from CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::5043:8c48:2510:3ec0]) by CH0PR11MB5740.namprd11.prod.outlook.com
 ([fe80::5043:8c48:2510:3ec0%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 17:23:32 +0000
Message-ID: <ef9027ad-bf98-2137-992f-0a88246b8cd7@intel.com>
Date:   Wed, 11 May 2022 10:23:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     Dave Hansen <dave.hansen@intel.com>, <dave.hansen@linux.intel.com>,
        <linux-sgx@vger.kernel.org>, <haitao.huang@intel.com>
References: <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
 <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
 <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
 <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
 <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
 <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
 <c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com>
 <Ynavabraw26HwnfW@kernel.org> <Ynaw2A0z6mBLU0m4@kernel.org>
 <c75f56b5-e071-fe37-835e-7cdd275852f5@intel.com>
 <YnrnBIavYD8yA3Jx@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YnrnBIavYD8yA3Jx@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:a03:40::15) To CH0PR11MB5740.namprd11.prod.outlook.com
 (2603:10b6:610:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab200340-ce79-4f8b-d917-08da3372f92a
X-MS-TrafficTypeDiagnostic: IA1PR11MB6369:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <IA1PR11MB6369BF1814D3343AB870E851F8C89@IA1PR11MB6369.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TA85E5kNPAOMF46OXvSnPdvNrka22+EE1itjuhHbjGf0eUQ/dzpKB1W8XeOj1LuaNbkyJlSkkPaqKZMYVdFyzVISgnI0WUE5vaHTmDcdOv8feQTlf9APTL9ZLElhGTHpFPFhy/AO44a2eKNrW1wzt9tKGZXxFgDTteUncU1iEOHe3tbXkeQAx/GdG0Wljapx+GHO95W6lI3gxOAWvVqBsB4GLTtElb2bir07d8Hnd62txt6B2Cnv/qdLhQJPeFfSz0V09B1k/uBDr0EhtsOqwBNTpJcBXqLPV1So74Pbqo8QTGj0ni1SGJKjisjYnlIy5ovwnwDY9thPI+2bkFauIJsgvykXZHb7OjopDKLIbo/6iOw+V5z6K2k2TlzVy9GTopuraxSAHI427uUh16BhbQeWmc+PFbqKghnbVSsf+XEP3SVHzaf/OLZE/4gTR81yatZW7vchyMs5amyR7ucX6KMRzWERnMd/CcI5EhLajMKbhQSSOPIrH0L+Pmcq55ihgrtb7v7XIRYjx1oN93yRkgQkM/SmhvVfCcvnjk9tr+P1Ty/MFbZLFRwqqCrKOA/1pnErFfnG8Ttvl2KZ+llwZ/YytccAHHu0BCe7VlwG51F6jnZnNDE5xIvPYVhnv8OBj2esOU35DG5EhYh9RNxcRUBiRxyk+kw2C9i0RjZm5fi6rQpkxpC5qcU+7AK3CZ1pu8chS3vjg2nPCft44LusM5MBtgy8D1c67lGZjsLz8gz6Ev83EAROTcwjw5NQ00SokyD8u37PaxSBZevPWmoqkhtQxuWptIQQUSN9GqaKFNqI5AWLXjfvJrEvRQqXFk4f+B5RDuwBiQ2g02t0MQVuGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5740.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(2616005)(31696002)(508600001)(5660300002)(186003)(6916009)(36756003)(86362001)(31686004)(316002)(6506007)(2906002)(6512007)(82960400001)(53546011)(26005)(83380400001)(6486002)(966005)(44832011)(8676002)(4326008)(6666004)(38100700002)(66946007)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUZaeFk2ckJrVGZWRGQ5czhtSFpYbFJNT2s1VkUxMlkyWTZjMWgwUDBhZ3JJ?=
 =?utf-8?B?aTZvM2VKVmtPZ3lnM3haZmpNeVBXa1g4SUx3NTYxTkFYYmloUW1KNFhpajg1?=
 =?utf-8?B?SFMxUmRjMTVuT0Q5OEV1eGFIL1U2M1Evb3lZWm01MEJMZ2E1YSt6S2pTdGMz?=
 =?utf-8?B?MHgxb2VLYjhYbEdUclJRTTVuOFJ2THpBWDdVdFFjN2NZNUphVTZ2RE1qTzFv?=
 =?utf-8?B?R1JYaFVSM3kxWitCZ1R0blRnWENYQTV2aWVqYUZWT09OMlVuWmdVT3c4OTRs?=
 =?utf-8?B?a3ZCNk9qRm53Z2xCU2VqYkd1Y0Q5SmpSZWw0TlZMQnZqVlpZTzlmUGNPY1F2?=
 =?utf-8?B?MGtsL0tyUmlkUlVXVVBJbS9ZajNpNFE1a0RocmxYdWNCbkthQmoweDZJNDR6?=
 =?utf-8?B?YlkvNVoxaUxvandKalJvZEx4ZHNBeHQ4elZEc1VPRUV1WndHakc3WFRudTBx?=
 =?utf-8?B?VmtEbnphUzFiWDJoa0FUZjZ6OTJTRmJPMlZxbElJRGNybDlVSzBPazZOMzVp?=
 =?utf-8?B?WDNjSGRnMTduZkUvRjM1R3NxVEhMaG00S2tjWTBXWkp4NUF3V0JpUTVqcEU2?=
 =?utf-8?B?c3lYRURVNjExQ09DbGt3NHpJUDJEdTFZLzY5NXdRUUtWZ3JtSmJYK1JVVlg4?=
 =?utf-8?B?SEtJM3ZuS01Cd3JYdHVYdmk4V2RhNDFXUW50SFNkNGZVMU5Bd0pYZEVuNEFV?=
 =?utf-8?B?VjIwaFBKcFBxQ1lGSHFPamVPeENVU2xNbzZUdmo1MHZTNEtYU2Q5MTFIQUFG?=
 =?utf-8?B?STdMRHJaMnBFcWZ3UGUzMklQOVhWV1JSYjJ2d2hvdzNCZ2hCZk1wV2d1ZG9k?=
 =?utf-8?B?RE9uK096bU1QMkRETlNRY2RWOTJmWG5SRGtPazNhc1lRRmFUUjZIZi93eU80?=
 =?utf-8?B?OXlLUlBjWU5Ia3hoVjlaV0FTK0RFOGZIUnJNK0pjSFRNUUV4MFdsQk5lK2JD?=
 =?utf-8?B?RWhQZFNLWE1RY0d1SWF4Uit4a0JjaktjdDR2dVpZVzFTM08yL29nbXlBRERh?=
 =?utf-8?B?WTlLNUx2aE5OMVdEN2RrWlRCdDFQRU5tS3N4bk81VXNRZHBFWWJHc1RIUWlC?=
 =?utf-8?B?UXVvNEJmaDM4dmJPUGNJT21OOHU0QWZlcXU0dCtjUG83TGdFRU9TOHJaaDY0?=
 =?utf-8?B?OFY3UDJXTmxjRzFRS3hFQVBzc2hCL09jaDRzcTB1ZVhvMHVGOG9ZWmtsOVNF?=
 =?utf-8?B?V2YxNFpVb0ZyNWFjWjQ2WXN5UmZ6d0c3WDJtVHhXRFhKcWJWQkM0S3JnZDBD?=
 =?utf-8?B?RDZNelZjOEZ1MVBGM3VDNlFkVmJaQW9yRDYxUTdBWWVzTmlTMVVLdld2N2xk?=
 =?utf-8?B?YUh0S1V4cnBJLzN0TWU2U0k5TVBxWFVlUXZXOUkvTHFtbUtFUzl6WW1XeWRE?=
 =?utf-8?B?MHlOalhkRXg1MUY5eCtIQytFRGtVd0JIdjJJcEZTVHFXc0JZMW9HN2M5OUJM?=
 =?utf-8?B?M2Jwamh3SjBheWlJVVlXM0xwVkZ2NTZWYittc01iTThEaFJvZjVsdjBOLzU4?=
 =?utf-8?B?RXVQemhabFh2N1N5MFd2NXlYZ256MHdsMkdLUGQ4RHU2Q0Z4SGxjSTBjYS8v?=
 =?utf-8?B?eUFpby9xR01uNUw2ZkRMWGh0MUh0akwrdlVmMFREelBPS1BrL3J6THc4aHda?=
 =?utf-8?B?Q1k5WkRIbFFoODYvblRibGpVSmNFUFFHNnpYaFFldkhlaGxVZk1xNXA4blJj?=
 =?utf-8?B?Q1JnQjM2TGFoNEpnbm1zdE1UTWx3SUlnd2lHN1dvQzhTeUtIOHZSeHRCTXdl?=
 =?utf-8?B?cnNWM1NaRUYxYklNYzcrdUxYdXhjN2JOeDNHZStTQzdTMWFvSWdtOEdxS2dv?=
 =?utf-8?B?R0l1Y25GcDJvNm5CNXd6K1FFcDYrWGhGVFl3S004emhWeUlEc0RnemRVemxE?=
 =?utf-8?B?TTBLbnc2QXBIWnhJbmZRUS9mMnYxWUNiaS9qRjhCdS9IR2lHQXNCczdiZmhH?=
 =?utf-8?B?UTloS3NLUjZhSEI5M25BSlZxaHc3N3F4R3VwbmJRVjFQdjltN2EwY2tvN291?=
 =?utf-8?B?MENzRzR4cy83QlcrMktRSG1vMmhWY3JQaW80WTc5L3lYOEl2QTN0Z0MzNTkz?=
 =?utf-8?B?bEVWYWtSVXpMeDIvSHJmVTJIVTUyYkk5U0xCMzRwSzBackRmb0JaT3BwZ2dX?=
 =?utf-8?B?RkdveDhvZ2hQa1BYamMxaVJWajVKcHF5TEtUdDdjZGVPL3NXYkFQeGV4OE8y?=
 =?utf-8?B?YkczQXVVaHR5TUQ3U3VjMG9EbTRCbUZVOVgzU3pVTWxUbGdMaHI4MVY1ZjRK?=
 =?utf-8?B?MVB2RVluenNFZC95d1RsdnhYMWpLWVRWWE5PaUVvQjVuRUVSMjlaTlRieU5x?=
 =?utf-8?B?b2VZR0tBMkFLSFErUDN2SGxjTjZUckZBNC90ME80Z0FENGZRUDYwYjRSNmlr?=
 =?utf-8?Q?jIxyHi8JXpaXkYQQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab200340-ce79-4f8b-d917-08da3372f92a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5740.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 17:23:32.8625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: THtuoc0Nm4y/vFv/SXGZYvlpa3jFN46/RnlfqDKHtl4Ydni2X9U1aHUFKqvEgiG2OtJxMVQUVCIlyGjxue9QPX04s9seP98ENU0DKX3ebuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6369
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 5/10/2022 3:28 PM, Jarkko Sakkinen wrote:
> Let's just say that I came a bit late to the series, and should have read
> the whole thread before responding to anything. As long as enclave lock is
> kept on both sides things should be fine.

For the most part, yes. The remaining scenario is the case when the reclaimer
releases the enclave mutex while keeping a reference to the backing store pages.
By releasing the enclave mutex there is opportunity for page fault
handler to run and also operate on the backing store. Both the reclaimer
(after patch 3/4 in this series) and page fault handler operate on
the backing store with enclave mutex held but if that is done without
taking backing store references into account data could be lost. This is
addressed in the following series with:
https://lore.kernel.org/linux-sgx/d0ace4a1770ab8f4196bfeae06d0970ddb14ef01.1652131695.git.reinette.chatre@intel.com/


> 
> I think for bugs like these it would make sense to put them out early as
> possible, e.g. I would be fine getting them from kernel bugzilla. Now there
> there was two week latency on finding the issue, and making it public.
> Unless there is something confidential, it would be best to get early
> alert. I'm always ready to change my priorities to help to fix such issues.

I am sorry about this. The reason I first struggled with this by myself was
because it was made out to be an SGX2 issue. This was made worse when I was not
able to create an SGX1 test case that can trigger the issue. I thus lacked
evidence that it is an upstream issue and it took me a while to debug and
understand the issue to gain confidence that it is indeed an upstream issue.

Reinette
