Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18255C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Jul 2022 17:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbiGVRdL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Jul 2022 13:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbiGVRdK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 22 Jul 2022 13:33:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45B08CEB2
        for <linux-sgx@vger.kernel.org>; Fri, 22 Jul 2022 10:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658511189; x=1690047189;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=urkEVYlvNDktozW2Z5KhWB3OeNhdfj/BpN3ufgnKdcY=;
  b=DLIyzoYHCidXYOY5BQlH2ZjNEqpiEvB9rprZogFBR6QB5vp6mO0l0wc4
   7dWRCSeAn8a77CccaLSUahwlk5eFbfRYwFVaT16sTf7RZci/bXLv7iCBl
   giwQihJbv1JYDL1dzZBjC05G1GgN4Ce4quBHGWUKt5uYr3wi6zDzq4oS2
   MIcRlIcN7vytV1SrpWrRk1iJ/sDMaOmmgyo1SMj8S6HodKBFAhIk38niC
   jK9gtHvIEis4tm2dHYQeVJVpRscJ7xMx6ZpteUCgciVGw8CtiiexIVD8/
   DscvWLsvjxAh1PU7iZ4zjzNit2tgxsTNqPy6swpHwZ1gCDbkOeHjrG/3c
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="288542485"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="288542485"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 10:24:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="549240934"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 22 Jul 2022 10:24:16 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 10:24:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 22 Jul 2022 10:24:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Jul 2022 10:24:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XywGE888p/4T86XtewpOeJKaMzv3fEGbtX6fhacQPLLjCBxuYX8lFdw45BqBjRWlQSpa1jCBo+cw9M91ZDm8jE/0/n1fgR4J/QDKHSC9hRYMjMwjBSYlQyd02QeLInMLgGAFyx/a7gao/RJbL69meEDt5UoDAa237RXOnnuyg5ELO5a9nWcDxJ15LF/T+JpRNFS5kbr2JMctkdu+kjV77lp+uI0dAMseGmuXepuMK4a0Ch4mSpA36AS1aGieM7EPi68TcR5bgB+Ib+s4MQZaon33Gk924ki9DzVEKQl4hcRmOBmaXZzGMlNoJ8VcXHgZMjKdDdz3senH3W/5FttQgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urkEVYlvNDktozW2Z5KhWB3OeNhdfj/BpN3ufgnKdcY=;
 b=DlTsCeQOvME1TCbebJR966+5kLP2wiWHf/vRbRmRc5w9ehUnAX3gsplaxB4pmotLOtl3Czp3ROFSxapSBI4YMdeK4WFQMy6620ViHUnLmdfIxd+47YLbxYu806KWkgb1J9O+CtzqrJNH/2IVQatIxDQ2VkVCGe2ZNZJQsqMcVS1CgMenY0dwd/jjQQY5pXbx7/EunFCZMb07xkSuTeZcz4poGOE4XIRAwsxXPvUzPwC8iRO3wXStodIpDUvcifA8s8gcODqmblD+UjKaRzSQU3yJZ/fMyNBxfMp1JvFiC97jbYtzwwFfCM2RALpKbyqNIe2sclPybY90sBmmWD5rYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
 by CH2PR11MB4440.namprd11.prod.outlook.com (2603:10b6:610:48::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 17:24:09 +0000
Received: from MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e101:93a4:5ad6:ffff]) by MN2PR11MB3728.namprd11.prod.outlook.com
 ([fe80::e101:93a4:5ad6:ffff%5]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 17:24:09 +0000
Message-ID: <eaf43a52-02b4-b5fa-9e49-914282b70c8e@intel.com>
Date:   Sat, 23 Jul 2022 01:28:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 3/3] x86/sgx: Fine grained SGX MCA behavior for normal
 case
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <linux-sgx@vger.kernel.org>,
        <tony.luck@intel.com>, <jarkko@kernel.org>,
        <dave.hansen@linux.intel.com>
CC:     <seanjc@google.com>, <kai.huang@intel.com>, <fan.du@intel.com>,
        <cathy.zhang@intel.com>
References: <20220622093705.2891642-1-zhiquan1.li@intel.com>
 <20220622093705.2891642-4-zhiquan1.li@intel.com>
 <b70b4902-24f5-8a76-5e72-e51de20d1d59@intel.com>
From:   Zhiquan Li <zhiquan1.li@intel.com>
In-Reply-To: <b70b4902-24f5-8a76-5e72-e51de20d1d59@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0162.apcprd04.prod.outlook.com (2603:1096:4::24)
 To MN2PR11MB3728.namprd11.prod.outlook.com (2603:10b6:208:f4::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a14da91a-0eb7-4e4e-76b1-08da6c06fc67
X-MS-TrafficTypeDiagnostic: CH2PR11MB4440:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jorSTb9EVPdSKRZKxjGdHkTm6esowksqexMa8f6PgQydfwd3WHzbziQM0+HQoa/o/BX7iVOOhkDT6XEfkrrrVo3a9eR5o0nnKsiD/WYPMumET0CpXZzbpsCW6x6i9rIMJSr7XQZmERKB7kGi+Vn9sCdK0hvCm8ZS71nKV5O7kDV1desgEZp/dS1z7zG4wb3R8CAxFimfPG+FZZWGUA+RMAmTapwAUvyh5HHd1pmgZw24EURQbI0IAdgT+igVMaNB8aKZvt+7515fjIblg1CyOP0Yxg4k/c+ODAJfqokIY0Fe1Z18+xDtm9OHd88myuDToeenQ7Qct1KYugFsnr1DxdnDggYf5P+fTAokOz/yLAP75W8ylCApOAiUBdp5RmLOd8aBIXTB8rKiTZaR1E/WAME1nvjf2AS6U/cQOEgFp++ohnJNYKMYkUfRGMpFX15GoJkuLuI2kyfcWTLmPh37LHq6KEJz163IlpfEuRlyqIsSBX56OiLkjZe2KZkkIzbEjBHCj4phXGpqlP1cNF0ZSTAQ8UwXTdJNZWX9PfkU3EYSrBY6KbPQEjLX/8rgIdxzqdL5yyifRNzeImwyiVF4tKAAJjeHM5+rikSbyt/8TmytAas/hDwklHZDvN8qAxDrf/KXDksjlx4bnbLSXujjdsbFohKb8VCH+QdGBg6OerCCLMJMqVqke+DwsjSR5IVahr2LHrY4cqbb4OA27sBbwljOANRZ+doJpQkfUBLDtabHm6fr43ugHFZdF8gR4BvoFXKp8igNJQoLQ83VylB3S/ouI7Dh9HJCT7Yp/zAqtkDjCChHEgyg/n340Kn9fsw+tYEoRPdwahmybtnYHrjNlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3728.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(346002)(366004)(376002)(186003)(66946007)(66556008)(8676002)(4326008)(41300700001)(6666004)(66476007)(36756003)(31686004)(2906002)(6506007)(6512007)(26005)(53546011)(2616005)(558084003)(38100700002)(86362001)(31696002)(316002)(5660300002)(478600001)(82960400001)(8936002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFVuNk9nRjZIQk5DMCtFcmk0U255elovSDlXQ2tkZmp3QzBSOE1VbG5rcG5x?=
 =?utf-8?B?cDZvR3N1clpMSVIzbkRBK3JPcDBzeXNDTzlMRFExV3k1ZkdGOE5IeG5SRG43?=
 =?utf-8?B?bUJIMG9sSk1lVS9hVnVueXorcUhid0cyZ3JYTEcvcVVFQ1VqbEFxRG9RQVBi?=
 =?utf-8?B?ZGhrQU96NnFpbGdXcllzZk0vUCtlTU9GNEo0dEQ0SnA3eSs2V2pFU0FHYnZ2?=
 =?utf-8?B?Y3JkMnNqK1Zsc0xSRmdRZkNxaTRiNmdDMEdQcVdJZUxrUEF0bGJUUnJKRUZ2?=
 =?utf-8?B?NjBIaDNNMSt3WFdlRERuTFlwNWlxRnhjeGFhUG5PZ3RnTkkvanVhK29GajNj?=
 =?utf-8?B?ejdYZ2pXQVlGaVVkdmFGaExWcGhQTXpCeXNDVUVRNHlMallvMmxuOGZqaGY0?=
 =?utf-8?B?dFlJNGpxTitiWWdWWnhBZ3h2SEpuWjk4Z2Mxajg0dlpVNVlTMno5NzVreUZR?=
 =?utf-8?B?Q29tZVpndGRIMlZ5a2xuSWo0N0l5N0l3R0h5UHV1enJmS1A3Z25rVXJpZEM1?=
 =?utf-8?B?dUxqRnNzZkF4bFZDL0ZOWDZJLzV4NDhSR3d1Q3lMbDNnNGtKVHRzdytJTm5q?=
 =?utf-8?B?aVNmUFpaU1ZJUW81UlNiN0IxSWgzdGJrTHZ0TnlDSlp5c2JQTFhvZGU0Nm9P?=
 =?utf-8?B?aUhXVGpYTFphQXBVT3ZMTEdLTXp5MU9VZldSQmRIbUl3dUVCdjcwYlJPdWFT?=
 =?utf-8?B?Z00xVUMvcWhEQ3QvczdlT0d6MDNRWTZBck5iYVVwbzd0OHk2U3JGZFIzM0h2?=
 =?utf-8?B?QlpkUzlKdThPbTdGZDk4YlZrYlVtUy9iQVd4RHZQVnVyWFRQRG1ZM2J1RFRJ?=
 =?utf-8?B?c2JvVm9qV3JBWmRuS3Npd29oQnpMQkhBYjJSRXlHNmQxNk0wNklFUitaTEZq?=
 =?utf-8?B?aVRlQUVVYTB1cENjT0VrbXc4ZnF4aE4xMGdseldHSTU0cGdSa1JXWUd6eEFI?=
 =?utf-8?B?K08vZWN1STZSdHYxM1A2WFBEeDRzTE1WUmtOeGNTekVFT2dGVHAzZ2JBU0k4?=
 =?utf-8?B?WTZRV2JZNjBOem8xNmhqWk5sbDNNY0JucXpSOEJFTE9MbUp6Zk12TDZ5TUpY?=
 =?utf-8?B?T1pnbUVDYkRKU2tHbEZZRDVMbTJqZEFtUmVwemhJRVFsMzFrRU1RWG1oMCtM?=
 =?utf-8?B?V0NLUkFkS0lEQUxmWVdpU1BoWnF5eWhERXRYZmI2cGJ5RlhiajBSL2VrRkJZ?=
 =?utf-8?B?U1U2MkNwM09ndjZTZHcyM25vZ1ZDb1VJRjNERDFCR2R4VFpmcGJhZDFYM1Ny?=
 =?utf-8?B?WThtbW1wY2hUWTUycktQbkN0cGl4YzkyaHphZWI4azF1VnAwQW9HR3V3YjdV?=
 =?utf-8?B?RzlpZ0ZEU1pFclVEK3k4NHdwaVFHODZlSFJCMjJmNFpkTmhsNlpKOEFTcFIv?=
 =?utf-8?B?bzZHenNkUmQrZmdzc0RzTExobS9MVTZtL3RpeXRXdHA3QUxJUlpUbU9Ra2JG?=
 =?utf-8?B?SDZraUhMVG81ZXZTQjNNL1ZmSGE0RDc1aGN1R3RhelB6aExNSFg1S3AwQnlK?=
 =?utf-8?B?NTdtM1p3b0psaVBNN2xUVThhSnNYaHdaM1MrYXA0T3ozcFFIbkxwTTMrM1dZ?=
 =?utf-8?B?eCt6Q3g5VWF5aHJYM25nbFNsc2xkTkIzZHZvVVJYR090aGpOdEQyZnBaZGVz?=
 =?utf-8?B?VytPS3lLVWE1L1lja3c0RjhQbEVHa3VFb3RNRnFIU0RhRmpUbEZETUtUZy84?=
 =?utf-8?B?SytTdGRaaHVLT3l1WWVLcjJOWmc2TllpV2pId1A5Z2FtSDdmdHl3S3Z0a0tQ?=
 =?utf-8?B?YUg4Wm9mWWxFR1dHbVFYY3VJUzQxb2lmOGpMZCttbGxhSXlQZUoyMDNwZXBj?=
 =?utf-8?B?KzREQzB0cUZxOEJIeVpLK2tVMCtoNHZJQUZ6WFZ0UHAzT3FOS3dWeTNnWHZz?=
 =?utf-8?B?U3ZTT0liVFpOdUxFVEVMZ0NOTGJISWxYbGpaT0d5bEtsR1dsVlJtM0xLWStx?=
 =?utf-8?B?RC9XcXoyVjZjVVFHRUxXeW95SGxwTEQ1djFQNlEzaWQwNmdtTWZ5c0pvcFVm?=
 =?utf-8?B?VENTK0MwK3FEeGJZckdNdEthUmJhTjVyMEFVbTVyUXF5czBvWTVVOVJ5TmRC?=
 =?utf-8?B?RjVRUzE1ZG5xQ0pwa2xBQ1R4SDcvdzlGSHU0V3ZWMjAxdms3VittWk0xdXZW?=
 =?utf-8?B?NHlZVmxEdnhWRStURXZxWVdjSmM1MHk3UUhQcHROa3hvZmdPaVYvdVNLUVZU?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a14da91a-0eb7-4e4e-76b1-08da6c06fc67
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3728.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 17:24:09.0963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lXe5PId0SSaV9UMb87HdDxSQFAEFkDGq3MShkAqSSOJudMbidliEIQHHLiMjHTDR8tSW1EKAx0YM633bLV48jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4440
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


On 2022/7/22 00:57, Dave Hansen wrote:
> I honestly have zero idea what this patch is doing.

OK, let's drop it unless we have more proper reason in future.

Best Regards,
Zhiquan
