Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632B1C433F5
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Oct 2022 17:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiJCRkA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiJCRje (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 3 Oct 2022 13:39:34 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B6012A86
        for <linux-sgx@vger.kernel.org>; Mon,  3 Oct 2022 10:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664818755; x=1696354755;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b8/Ui77C/NkyhWzJXFhQcZ8x2sjBq50Rnhf5KqYrUL4=;
  b=CJekCt8eOSsCKzvSnGq+wLl9redUIZ4+9nNa+/th3S1rcOHhsS8Nxwme
   2OUUQoaHsBlt01dm8DbO7pLQ3TnHvp8hvtLOndkwtVdhcg8fhXv0OJAjT
   q9qNdE8i4yLdT9aHlu4enERpbs/7jOnnDGPD6CxKUktm3/yDlsS1W98OT
   Bovz9Gkj06KPl5+Kt6D+BfVQCS3D4MPCrgXDUZCL2LVttl0brBEgqlGaK
   GFs+irixYrQOy14Gb0+rjVlFSYDb04xEHNdG9DxTgDVhcfAsWx3h/8iEx
   d/3GfN+7lLJ3FHCn/GtdmC4BTPDHKuLUsneDyAst86Rlfy12uvPTs4Oc+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="289898505"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="289898505"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 10:33:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="625861521"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="625861521"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 03 Oct 2022 10:33:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 10:33:41 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 10:33:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 3 Oct 2022 10:33:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 3 Oct 2022 10:33:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbKZ/uX0F0K69Dm1ps1qw6KdR4hvzOA2QedW13Yl7AOu5aMhDCVYOvxde/ligdHnxDPHSSNzzSizPm5bpW29hPzbJZ86h+8vs17HgUH4vmb3PJOOfpmdVFej67Qu87FMozg4B2uNWtQNxEQqZmIEwShAoOpHB7S+YhVleOvH8qa8X9yA3lMtvRZyB7jPITUmeKlvYOf5dEo1sSx546IPRthVW3/Pu1gWDGKXEfxIiW8tG5K6ZbdwD4RimpOOMDSUzR/yxfpCzD1Q9t5JZh3Fc9rxl/xzTrSWIuYGHfmADr9OS43ZHcwx8aFMTcHEiK2r5IZAfR2l5lLb1Q4kXtftWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uJtSDwLkTjuFa88COCtqaQ9Oc8cDU7g/hYgAbFVTAII=;
 b=BU5D1lyHofhFwWKedZ4sEdXTNRYjYFYkgjwEmN9WPTz/wRLO0RFmA6zNcG3deYdyT4fCP17OH8D8I+d7x4bTiOI1aBRocgJj6K5QxqTk9re0ZuKnHqUR9D7mL9TXVQ5DcG124uU/hKhZiAV+HibFvcNsYCsJy6jhQS1FVzOwT1JEEwY9x+2daQ+n37+r/GyDMJkR4Fj081os+5vhbjByVasL1Q092Cf2ZtTUlAPpD5nJfHCxM9UcOxuxPGpN6+dRQa4xXieu1pDqaUuVlO52xsaX3dLanwK2cYE8kZdOjwvOkXwQ9w9ZGfSdbmWkQu+0bUJb4wzcxh6RtcwALAc8Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by DM4PR11MB5503.namprd11.prod.outlook.com (2603:10b6:5:39f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 17:33:38 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::207e:ab0b:9e29:6a4b]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::207e:ab0b:9e29:6a4b%12]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:33:38 +0000
Message-ID: <956f6af2-e0cb-72c0-abf8-e2e00067851c@intel.com>
Date:   Mon, 3 Oct 2022 10:33:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.1
Subject: Re: sgx_validate_offset_length bug
Content-Language: en-US
To:     Borys <borysp@invisiblethingslab.com>, <jarkko@kernel.org>,
        <dave.hansen@linux.intel.com>, <linux-sgx@vger.kernel.org>
CC:     <mkow@invisiblethingslab.com>
References: <9e1e61cf-39d9-8039-b2e4-f0a3804fe493@invisiblethingslab.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <9e1e61cf-39d9-8039-b2e4-f0a3804fe493@invisiblethingslab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0140.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::25) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|DM4PR11MB5503:EE_
X-MS-Office365-Filtering-Correlation-Id: b8c239d9-e62e-401e-352f-08daa565682a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I9ZsHkocXUORc/aWG0sBuIGwRkCsD6/G8wHoEngHmGNOfCqGQSjz4Vpe4ZztanVRAZ3MCZbBDssnH4oBIpuF24I21HwC3VVBP6lL+vL0suvbswMLVSuoRjj+yNGI3CWNDkZJxbdJB1H96Slpf6XiWjchcPLnKOG9j+zDuzY0A6oJaoQbhZawAd2Y41hc90qIzwpp6NGB7vVKE/s33kY2O8fyUDUEk+xl+0o2trxi2R+bGT+XSuRqFuGE0BSh+hK4jXbAYCvWn1lGpKoMTwrjvsNQd77cXJv6N1oxr/FYMBI4P8/gwSxFR47nnA3yb6DBkbVmV/078TJl4pPUv3Nk4Qc/q/5pFKqNH0/oARJJqNYYRAPLSTo9BoHP17i5YIQaUUy7ccYuJvCFVemMbpyQBo+s4m6r6rrIYfwTLqseajc6PdQ9FZg3sB0jPIP4PYAB33SpOKyBif+Mgp3csoICpN7QrOZmR6rUYk8adxs3iihiymJkuKZkh/SNn81m1VJNy71GCVdfOkGBDpdA/olyiDEtzXSZX0cLKN4gF3IvlmC5od0Y1K6UM+RYIMjYFMS7ASfirDhhDv94W6BYJss7SexfKoP7e0RRGSaJnsQ9AgoHj8cFnECNAhx+c6XM6731GTAVrkLiFvfB2sLYGXYBdSYAz6jySH+JzySnKXfqkC5t7lshnyZPki6Bx63z+uZ+oE9otF5W1BPbIaVgvgXOctQLpK6N7Bcdv3j8zQiBdC8Vm+K/LmRKhMcvhXOACjd1ckZJSk7KrDH96QOiTk2juU4rDKK/YkjTo/R7lUqnmjA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199015)(6666004)(82960400001)(86362001)(38100700002)(31696002)(4326008)(36756003)(53546011)(41300700001)(7116003)(66476007)(5660300002)(66946007)(66556008)(6506007)(6512007)(8936002)(44832011)(26005)(8676002)(6486002)(186003)(316002)(2906002)(2616005)(478600001)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWg1UlBPUmhFN042dUVKWGlUckt5cWplYXhIUGMreVNZMzhsazNLMnBQL0w3?=
 =?utf-8?B?eG91MDY2eEpTRVpEQ1I5MXlYRFVyK21hTWVYTnI4TWNhRzRjbjVhRUtZVmNE?=
 =?utf-8?B?WFhxMEZsV0UxNXgwQkFBc1N6VEkyOHFCQ2pyZXNrR3VoMC95SVFudXE2ZW1W?=
 =?utf-8?B?elJnNmsyeUFoTHA1cjU4MXY1Nmt0cjBUNWgwK1RWdzA4OHJLbk9xbGN0N2tI?=
 =?utf-8?B?MnVOWWJrNnhWcC9MaHdoMTM2N1R3UmJMY0tkanU1MXBpRm5EbGVzVHFpSkRT?=
 =?utf-8?B?aG1GZDBJeFdRMWYyZmpTQnpJd1lmSnBkVmFlV2FiQ1NSTDg3TWM0SG9iejl6?=
 =?utf-8?B?TnV6eVNWUE1qc3d4YVJQbFlRd3hWRW04b1h0M3JnSndTR25qY0ZXSnZMQVJt?=
 =?utf-8?B?NzhIUDdJOEJhaDdCeWpKSExlL3JBcDNiejlWRkNtRFhvdUZrcC9VeHk1Rmo0?=
 =?utf-8?B?cXp6aGxyTDNNTE9taFRTUzV1dDJ6SkpjU1RtV0llWTlacHQwcEdVVmVkc252?=
 =?utf-8?B?N3BDSnZmVnBKcXFPZlpIVXdHMjlqL3lTZ0dpSXlZQ3hvcEdrdUduSGdIME1K?=
 =?utf-8?B?anI2RzNBdHdTUVRGMFJLTEl0RW5OdmJKT3BzM05qbE5xN1FMNHpXV1YwK3ZK?=
 =?utf-8?B?dDRwYXlpeUtyOXJsbWZqaFZLSFhaZTJBZDRCNFduVGxINFBEdXYveEdOUVcy?=
 =?utf-8?B?cWhVcnZxMWJWYjRxZnRadm02SE4rNEsrR2ZLeTU3eGwxbnF2MlJsK1RFVmFW?=
 =?utf-8?B?Qmc3YmlLZDQzZFB4NUNRMmlCQjlPVlFBN3NIVm1YWnY0Qkh5NFVGaHpoSDVs?=
 =?utf-8?B?bUt3RzhoOVBZWHJtUXQrRUxhUzdpQ2NEekM3SjRhclFuRUdyNGJFakI2U0ps?=
 =?utf-8?B?T0JsNDgvUmV5Qy9yVDlqOGUzemRXd09DNTZBWnFSVGtnZWt2dUwwaUlJeGI5?=
 =?utf-8?B?WWxBRTFJMHVsYjVESTY4TkJhVVJxMkE5Wjc3cytzMTVtaUVIdUpRb1VTdisx?=
 =?utf-8?B?cjB5L3AwOGtXUzhRTWRXRWxoNTY5UE5HSjBWK0NFTTBaMG1DZmhMZnpXdXgy?=
 =?utf-8?B?bk5QQXMzL3J2cE94U0FVMnluM2NKRTIwSE44RWszL0R4V2lpMW9TVUdoUVF0?=
 =?utf-8?B?NFUyYkJrRlJMUElnays3d3lBM2FidDJOcms2VVQ2UXBrclNORlNwYlcxa0du?=
 =?utf-8?B?aUp0N21rSFNKZVpFRnBhVVlXUWUxV1dESldtM1FDaWtnYlZPQzNrUk01Yzlo?=
 =?utf-8?B?eWIvbWpWVDJwT0hwbkdlU1VNZE02Nll5NnJBRzMvay9ZMGdPbGs5N0U3RC9J?=
 =?utf-8?B?dTRzdXFyMkdLd1lPRjJPUzNUeFdmWEFjcmZMS3hUQ1p0NHlrNVNISWptYlJm?=
 =?utf-8?B?OTBIcVpGQlNzQWJhZUF0Qm5kZFl1eDgrSHFtT2k5a0htMUQ2WGZVV0s0emJn?=
 =?utf-8?B?RTdWdzdpVy9yVWxTSDFoaUlRNDM1ZDl2WDl4YjVWRm5VU2NkMjdMMjJTOThG?=
 =?utf-8?B?TkdjaDBaQnkxdWZLMnh0K1R4K1BZaVBZdXFNUmNpY0FCeGJuTUYrTlNQQ3Zn?=
 =?utf-8?B?d0VJZWtwNEk0aWFVYVFpU0RFTGhOeDdrQkJmK1kvejkrVjFHMWQ2RC9ka0JZ?=
 =?utf-8?B?WkFGd2d2a3k5UWZwSXhnTFdUOGVrbmJOMEJUWWM4ZUl4YWpyMGZZeEZVaVoz?=
 =?utf-8?B?VVBhQ0FyZzdYa0FadUVhQ0JnQ3lpNGl1REdIKzJSWmVMY0t2Z2hHQ0NnQXo5?=
 =?utf-8?B?QytoUEhVQXdTQ25kU2xzdHo0V0ViWThGbmZabGJXc0Jvb05HQVBzbEF5ZlpS?=
 =?utf-8?B?bjRCUUFxUytSNjd3S1RMOHNzYmZZQWRKdzlld2VkMEpLL1FNK0NmeEJVNCsz?=
 =?utf-8?B?K2pLam11UTUvREZhTlVILzFhZWgvSCs4ZW5qWm44RjFMWlBGUVlOdkNRbFI4?=
 =?utf-8?B?dHVaR2dNN0VoU3oyV2xFcldrVHhOZzVRMFRoa1NpNkpwQVdNL2ZqcFZQcEFs?=
 =?utf-8?B?OTBnQkozU0xROUNnV1RQeTJGbzFML0lUZnhIWXFtYVBPaGFOTjVUeUxhKzRW?=
 =?utf-8?B?K2pHZDlVaXo1MkNHRmNYWG9RcCtVVXYvSE51UHNHNUpqVmNTZXlDekc0dVdE?=
 =?utf-8?B?WGgzZ1VzQ1VrMmU4cGVVaXREdW96Q2VyaWNOTVQ2TUJjcE0vMEZlNWZiYlor?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c239d9-e62e-401e-352f-08daa565682a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:33:38.6254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hz2RMx/1o1EvfDHkaALNvKdkRZr/Me2jR6fYZ7JPEsz3AJ/oLOuk/oL7p8zjp3KiXM+as33DGRQw82WKyHap70OT/sVfGFiIYx17jRtgeZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5503
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Borys,

On 10/3/2022 10:19 AM, Borys wrote:
> I've stumbled upon "sgx_validate_offset_length" function in
> "arch/x86/kernel/cpu/sgx/ioctl.c" (all of this is based on 6.0-rc7
> version), which does not entirely do what it claims. "offset" and
> "length" parameters are provided by userspace and as such their
> addition can overflow, which may result in this function approving
> malicious values. Fortunately this does not result in any exploitable
> bugs at the moment (or at least I couldn't find any), but this might
> change if "sgx_validate_offset_length" is used in a new context or
> current usages are changed, so it might be worth fixing anyway.
> Simple overflow check `offset + length < offset` should be enough.> 

Could you please elaborate where you see a possibility for overflow?

Together the provided values, offset and length, are already ensured to
not exceed the total size of the enclave in the following check:

sgx_validate_offset_length() {
	...
	if (offset + length - PAGE_SIZE >= encl->size)
		return -EINVAL;
	...
}

Reinette
