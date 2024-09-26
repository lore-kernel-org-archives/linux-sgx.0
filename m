Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1741E50D
	for <linux-sgx@vger.kernel.org>; Thu, 26 Sep 2024 00:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727311132; cv=fail; b=rm1/n3m7EVoiVl+iA+CxwlGT9VT8LEbPTfggns+5t3Hcn2QbqXtBCYv0Y+XKEn0tfbHd2urabcBinwDQzArEeCl9boeicgZ/4wApXh5XkrE14lJxgH+Klc4YU8YUSduKvKzii38HH/rD+7YmejoXWryfAyLFBr/alz5dP/JYcDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727311132; c=relaxed/simple;
	bh=/qo5/ov12NLgbZTyORhwzYW0GrZbgHgYN3LwDP9WFX4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=edBi9fwpkkfS47QQf7rtEWzW2LllFtVEBchb76I9ZNFQfzY2WX4fryadEyATTgFL7dWm50pGpHZgv8klHjVTsqsVrqUWz1SzWOWoGCrtLq4oofHXgZ5rGzW8DBt/JtbN6bKTt7CQG2HePtD5vJiobCPlhztAaZJASUBsvfdOM/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l3rtTD38; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l3rtTD38"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727311131; x=1758847131;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=/qo5/ov12NLgbZTyORhwzYW0GrZbgHgYN3LwDP9WFX4=;
  b=l3rtTD38tFdw/HsQJe/vQOYc61yUMJbGZyvmoW1yqNpVl+rj7IP3N/7e
   adxYBzxcaGQAP3XBzSDV5O8RjHWb+KzGupKkQ1ISdAUiAB7VK1EYVlWN7
   xqlUsFEmBwCe6iEAEgG0kBexM7YoQzhzi87E1VapJDs+V72yQOEh7RW7A
   9JrX/p9Po3s8vSad4wbTZqyEYIqmab5A0ilOSuFBqIpcSYqCeFtdNqDmw
   m6Oj7111mu4qRuz7oZdEPa+N5y+N/6SknEs3JntOAKw1T4kbg6kvEP/M5
   AoDYtiU2MoXS3u9mXm0vJnuzcYOU0kd85k77uWMR5jCNjHhMMQAdfJfa3
   A==;
X-CSE-ConnectionGUID: wPX5ihsMQ0uLNGWN7Sd+WQ==
X-CSE-MsgGUID: T4FRaE/fQ9uWblHh2Ti7Jg==
X-IronPort-AV: E=McAfee;i="6700,10204,11206"; a="30182214"
X-IronPort-AV: E=Sophos;i="6.10,258,1719903600"; 
   d="scan'208";a="30182214"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2024 17:38:50 -0700
X-CSE-ConnectionGUID: 1peHiHM2SROvMMj5R5RZNw==
X-CSE-MsgGUID: Z+MUnETcSI60JepML0ywWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,258,1719903600"; 
   d="scan'208";a="102779540"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2024 17:38:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 17:38:49 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 17:38:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 25 Sep 2024 17:38:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 25 Sep 2024 17:38:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gZxY5KyqZZJD5woJwkWFSvL7qDgLP4v3lG8jb7SmykEO4eQHIhL4BJmqB7ZqTKDbquGrRMlcD5e1AL0xTXiIfuEUcUrMeKzdvT+n0g9M+VYcGDQQqSwc8PKiUsr5TMXCmFf5aWhok3WbtI6qPsgA/XRcOQR+duqTg/kSwdDVs6hAcCDwKCtNe+RojAwWPRJqJTlnUjIqoMwkE9P/q3SCpesklD/ye6F1AUacW/3P1vUkLR9qZ5FfnfcMbta4oZNmnYfFOoCkGXDCe8XY21uZ2OFiw0tg7Fb8AoC9cU2tkpcxUYj+D2+GBDkQG+YKTFCgifkcL4nkakNQgnCNpONltg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCDNcyFWcZ1OByMxI1MRXBynzbZvQU96tuoJ5r9twqI=;
 b=mqaoJmLppHBEiGiz1Akxrt4DORLtwW14JtPFIX0JhwKDqZnw4uLJhHdD/DhndK3kM+wODETEP7W6YHrfwKkl7ODpjCgIsLuORmzSKVPq5ut+aO07Zza/Yv0+cikSqk0zmcXg4Yb8FKjDJ9GjSbN8zdwAEwXc91HbLaG51T5QMDEexNtjT9ki0OFvo1weSjSKDibHZM9PXph8y4wPznPQUoKu7Ze9zPb51P/eKdDUdXCq55nStTzWEmBTMhoWAK9VB/k+u6FEMS96SL2wqglHdWosCitafwfqBv4sR5I0jBaBZKQU3fkTKw4h0A2U56w8QmRb3pw3a4FGMt8oY1Be/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4816.namprd11.prod.outlook.com (2603:10b6:a03:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Thu, 26 Sep
 2024 00:38:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 00:38:46 +0000
Message-ID: <bd784be9-3723-4ad8-94a8-058f4a001042@intel.com>
Date: Thu, 26 Sep 2024 12:38:41 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: VMA merging updateds?
To: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>, Jarkko Sakkinen
	<jarkko@kernel.org>, <linux-sgx@vger.kernel.org>, <linux-mm@kvack.org>
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi> <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
 <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
 <D4FSKQJ45J56.38A19ZT8CDTR0@iki.fi>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <D4FSKQJ45J56.38A19ZT8CDTR0@iki.fi>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0210.namprd05.prod.outlook.com
 (2603:10b6:a03:330::35) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4816:EE_
X-MS-Office365-Filtering-Correlation-Id: bdf884b3-a496-441c-f1e6-08dcddc394a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QWo2cjB5eThRZ0VNZERnMVBITkd6YkJrZ3FPSXZKYml5dHNyUWdtdVJ6WXZW?=
 =?utf-8?B?cllmUzEzN2VuTUdSdUVCcG1SQ2NNcUdDSlN1eUN6UnpXUHc1OU5WRHRXeVND?=
 =?utf-8?B?eGFRN0dianhLZk9jdG4yeVc3dEhIVFQxdjFsREh6OTNPUUNoU25mMHFHTHMx?=
 =?utf-8?B?djhNR1ZnRCsxd2NYS2xJTGVHQVFUNlpvUzB4dlNCWDkwS1lhdmJwa1RqSHJv?=
 =?utf-8?B?Z2Npc1BpVThzaWw5K0RMOHNpbU9sVkFZaS9pV0xIU0FGY2M3d2VxZW02V01K?=
 =?utf-8?B?cnNkWjRvQmJ0Q2FVVXVMaVZ2dERJVlQzdzVIU2lUV2xCKzNOYmk0Uzg0YWU4?=
 =?utf-8?B?Qis0U0c5Zis4Y0xROG94QUJhRkVLbnZSdkpiK2pBSW9xT3UwY1IzcC9ZQkNp?=
 =?utf-8?B?d1RPUTdOcVRTNWxBMXlPYjltSXpPNDZ0c2swTldZTXpaN3d0bmtoWE9Ic0Qv?=
 =?utf-8?B?VnJzaEZzbGgrS0dwTk93bjhDQ1dtditEMGFINW1PS2lqVVI3cGh5YnN4bmh6?=
 =?utf-8?B?S29RdnJGcmk4Ny9uRUpuMXpNcENiRklRa2Q1dGZ0bzNLVW9abmtLQkt3bFR2?=
 =?utf-8?B?NTdvd2Y5WW5CRjJ3T3BPQTdSZUY0cWkwcTFGc2htWDdJUUxkRFAwZytLcDUr?=
 =?utf-8?B?N3dCRFc5bjBxVHA3c3I1am9pWWNZeHdjRkhUKzk2aFZucTZoV2ZMeDBpbDV5?=
 =?utf-8?B?RW8zOUgvOTJlbWc3eEYwM29ha0RDMUJqRmhzN1JPb0lXc0JKY0d3TVFEUmNo?=
 =?utf-8?B?UDA5dEVOY3V3cndIVnhybEgwRUczdWR1WGs4M0xwODVRR2VzSE1YT0IrR3A5?=
 =?utf-8?B?K2pVRTFNSVl1eDY2djIwREpYWjZOTm1hRGJ4cndTc0NuRG5ENUc4eldSblBn?=
 =?utf-8?B?Z2pBYXAweUVNV3RrbTZHQnBVOW9BOUhmcFk2aTRzT3dtZUVoYzFaZ0VBYnBp?=
 =?utf-8?B?RSthak1DaisvdDdna1JZSGlnYUxDelBXTWY1ZTZzeXJrK05FL3g3Q1FtcWdm?=
 =?utf-8?B?TmhXUFpEdlBrendwMGdONXBPWGNJWWFUSDFZbERsSkd4Tmx5UEZLcEpORUp1?=
 =?utf-8?B?QjdEbEpmL2x2ZHZuTDNoZEFPeVdldnR4UFREejFDQlRsSGVCTFlYRGw1QTRh?=
 =?utf-8?B?VU94UDRhQzU3SWdYS1VlSnFySlR6ZWw2TThjWkhtY3BQdzVHVWRDL1FkUTZh?=
 =?utf-8?B?bDhXZ3JwQVY3aVY4SURIai9nakJvM3VESFFuYVIrNnd4RXR2L041K1REQ1c0?=
 =?utf-8?B?YXh3aVJMTGROZG9uVGZDNkVFM21SSm13UHoxRmtRSWxYUkhndy8wVVphdjdR?=
 =?utf-8?B?ZzVQc1dhc0gxTmthYVVYS1V3SExPUG5jSWpRZTA1V04yS3hvZFF2Nkx4U09S?=
 =?utf-8?B?WlBQa0lCenhwOUZhellMTmcraysxMC9yR2ZycW1YamtGYnFLbHk5Lzg4dWFy?=
 =?utf-8?B?WVQ3VDZZQjhlTGlydG1WYVlJVmJJdW4zeTkwOWxUL09oMDFOdTJqSWlWYjFG?=
 =?utf-8?B?c0k1emtHRnN5RElSeDAxMFhnNGVqSEpPNk1pcStBNWNEeUV1d2Mva0U5SU1Q?=
 =?utf-8?B?bE1nNjFkK3hFbGJ2S05udWR5R3Y4cnkyR2dKN2p5V2lUOWxuRFVCMGwzVGZI?=
 =?utf-8?B?SVVIQytaLzhhYmdRYmhqU2V6T1BsdS8yOXMxUzRTdlp2VzVyNnB3M3ZmdDNO?=
 =?utf-8?B?bjVBS3h2Z3pTaHBFdy9jS2ZyV0h2T2E0Q1B5S2pBQTNhSldKVnFaTU1ONWJI?=
 =?utf-8?B?dFIyQ0NETU9MMytjTHFGd0NZYkVQOVdkbisxbEZSVFVsR3lqYVlmMDNOYmJH?=
 =?utf-8?Q?nKuNHUZyRh7lCwDuWfyI4qEbcUwZ/ht51SQ7w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YSt4RU5Kd2RJdG43czZ4N0MrdnUwZzl1K29KaWxROEJqdnJIN2puQ0NhSWc4?=
 =?utf-8?B?RW94ckxZT1hDa2xRWXh0elUrKzlqL2hBMzFINFcxQ1Roai8vUXdLc0VmL3dh?=
 =?utf-8?B?ZzhyMW5CWGk1YXRVMDUyc2QzK1Y1QTdjdXplcFdGUW1aYWVMY0V3eEVrV2FD?=
 =?utf-8?B?ZkdqM0JoWmFEN2l5MU9oNk9WQ3A0VnB3VWJyR25ZVG05eDNlbCsvS2J3NXcx?=
 =?utf-8?B?d2sxZzR6c1dhUGhFTC93ZnJ1UUVpZzkxc1hoMTVhSE9qL3lIRFBKcFk4ZDY3?=
 =?utf-8?B?aFJMbDR2VDArSHFMRitSSU5CK0Q3M2tKdzlVMVBJWmZza0pPQ1VaeUNBS1NJ?=
 =?utf-8?B?WXpwZzFrOXozUlRSV0ZFY3d5dkJSc1lyaEtzaTRpamo4ZzExWjFEWXFGak5W?=
 =?utf-8?B?cFgyUmljMEhMbWJzZUNJMll4bloyNGdlKzRlZVhLOXB3eUFlaWlHdmlId011?=
 =?utf-8?B?WnJPQ2dpZW5MVkNsQUttbVBPK09rcVNWZWs2SkV3eXJPaWxlaGZjUjZFZVJs?=
 =?utf-8?B?L3NYR2M4Z2lsQkFiVGNqUmk2Wk9CY0ppcVA4YzRsMlRkSGFUWExrbS8wTGdC?=
 =?utf-8?B?WjVRMUhuQkRZVjhLdFZNUmdZdUloeFkxVGh2eE9SeVg1T2M5a2E2bWEyS2JX?=
 =?utf-8?B?ZHY4VkpKYzdaNS91Sm9aamtiSkFIc1FOS0tZS2V3Qis0ck9ZdXlKd09VUUZJ?=
 =?utf-8?B?Ykh0WTEwTk5BeWk2ZTJZaFhKNlFyWnlRNy9oRVZob2JsRmxNSUtpRkpxRnBa?=
 =?utf-8?B?bTNVWVEwc0lkVEhIZWdEZDhpZE5GeTVEOS9jUEFkQnRXVkxMMTdwSFUvZmkw?=
 =?utf-8?B?bENxdUZPS2FhMVNYTk1hbDhGeVRJWk9mSCtPd1BUMlE4ZWQ2Zm9EZXF1SlBy?=
 =?utf-8?B?Nm5MZ1c0aGFSUWtYM1gweFpZcmZzczlNbU9yRDVDNHdteWNpTFQ2L1RBSkUx?=
 =?utf-8?B?VjFEeWlLREJiOVJLdUxoUE1FRFV1M3BOV0JQeUtVVFBkVC9CRmVkMHRtbnFt?=
 =?utf-8?B?M0Q2Y2JLc2RuMytFQjJzRDE3KzNGV3orSkVJWFUzWHBqVHlwOEQydURUQ3Uv?=
 =?utf-8?B?MzY0cWpVTVp5NU8zQTFJcDZVUFhuRzljV3NBRUFrdTgvWXdZbDI1RlFSdXA0?=
 =?utf-8?B?RjVCNlhKanpPYVNnWkdyUHlpY3lTalRvOE9lc0w0eE5qMVR0dlZFMXAxeVpo?=
 =?utf-8?B?YnJHNWdnUTNlSlpjTklubUlQQ0lvbEUrNWgrR2FqNWdjc3FqamZBWlNSOS9n?=
 =?utf-8?B?MFl5ZGVFaE1PYkdPUFJxOG1LZ21TVkY1dSs4aytxQlUrbVdvS0FCd1NsTmtw?=
 =?utf-8?B?ZkNjVElvL25WLzU0WVZvVW1BUXZXWnZlN1lnbHBhUHZGNzNISmlCejJvMHpE?=
 =?utf-8?B?SmtkVEMvUWMxY3JnMEUwNUxDbkx3bkliLzE3cm4zU3B3cHB4NUp5UlVrNlZo?=
 =?utf-8?B?UGZlKzQ4V0JqTkdPeW4yWTh1TU1GcFJTeWhRc2dma3F5V2ZJNDdiOVc5anhx?=
 =?utf-8?B?WVdXdFlhTzE3WHB1Z2lkTlRqNjF3MVNCcGZUUE03c3RNZytxKzJhUzRGSHIz?=
 =?utf-8?B?bmFwNFQxdEpSOTBaTE5qU0E3cnRBaUJ5ejZKelA5eHJXMXBIbXZRUmJHZFlo?=
 =?utf-8?B?dys3YmNCMVFPVmZ5QkJUMlFCbXVPcHgxclBJMXhudmxXQTB3TEtBc3E2NGRC?=
 =?utf-8?B?V21JNlNCZld3UEdQYVlLNENRZnFBMnBlMkhaV1VHK045ZXMvT09FMWhKSXNY?=
 =?utf-8?B?ZEF4b3ljNDRUdi9oaHVKeWVvQ0V6dUpQN2tOcmN0RWFvVUpQM1BQMEtXT2F5?=
 =?utf-8?B?K0V1V21KcEM3WVM1WThVaU0wMTFUVThkenJsZTEvaVFrTElEditCVTlYVHVp?=
 =?utf-8?B?b0pBVTlCUElOTWRUU3V3OGpQOThGRlVQU0xkTlV4V0JiNDRhUlVvWnJ1UHBO?=
 =?utf-8?B?ODlmaVRCd2ZWNHVEbHdUY1dDK01jVjg5ZlZ2dW93UEl4N2prMjZwWDJnZThN?=
 =?utf-8?B?VG0zMzJZODR5NHVwWkR5TlZ6R2tTUWRGT2pwcFZYVFhKdU5jYThNbUZKNk9u?=
 =?utf-8?B?WHkrOHBkZ1AxcTYrdGZXRFF4MlFFaVNOandKUHNzZ0p0TnFuVk1wMDJvaS9Q?=
 =?utf-8?Q?RNJIjoYCYOSsND3V6WauQXUn4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf884b3-a496-441c-f1e6-08dcddc394a7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 00:38:46.3671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N2ZBY0i/c9exGztPaNrbZICfNBPMCqXpXiElByqbH4TgaIlhJvnxcRrnWa9/rKfWmqwKc8WCYlpA89duvG6fRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4816
X-OriginatorOrg: intel.com



On 26/09/2024 12:33 pm, Jarkko Sakkinen wrote:
> On Thu Sep 26, 2024 at 3:07 AM EEST, Kai Huang wrote:
>>
>>
>> On 23/09/2024 7:48 pm, Jarkko Sakkinen wrote:
>>> On Sun Sep 22, 2024 at 7:57 PM EEST, Jarkko Sakkinen wrote:
>>>>> On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
>>>>>> Hi
>>>>>>
>>>>>> I started to look into this old issue with mm subsystem and SGX, i.e.
>>>>>> can we make SGX VMA's to merge together?
>>>>>>
>>>>>> This demonstrates the problem pretty well:
>>>>>>
>>>>>> https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org/
>>>>>>
>>>>>> It was result of brk() syscall being applied a few times.
>>>>
>>>> Briging some context here. This can be fixed in the run-time by book
>>>> keeping the ranges and doing unmapping/mapping. I guess this goes
>>>> beyond what mm should support?
>>>>
>>>> I thought to plain check this as it has been two years since my last
>>>> query on topic (if we could improve either the driver or mm somehow).
>>>
>>> In the past I've substituted kernel's mm merge code with user space
>>> replacement:
>>>
>>> https://github.com/enarx/mmledger/blob/main/src/lib.rs
>>>
>>> It's essentially a reimplementation of al stuff that goes into
>>> mm/mmap.c's vma_merge(). I cannot recall anymore whether merges
>>> which map over existing ranges were working correctly, i.e. was
>>> the issue only concerning adjacent VMA's.
>>>
>>> What I'm looking here is that can we make some cosntraints that
>>> if satisfied by the pfnmap code, it could leverage the code from
>>> vma_merge(). Perhaps by making explicit call to vma_merge()?
>>> I get that implicit use moves too much responsibility to the mm
>>> subsystem.
>>>
>>
>> Hi Jarkko,
>>
>> Just want to understand more on the background:
>>
>> Are you seeing any real problem due to needing a lot of mmap()s to the
>> same enclave, or it is just a problem that doesn't look nice and you
>> want to resolve?
>>
>> I mean, this problem doesn't seem to be SGX-specific but a common one
>> for VMAs with VM_PFNMAP (any bit in VM_SPECIAL), e.g., from random
>> device drivers with mmap() support.  We will need a good justification
>> if we want to make any core-mm change, if any, for this.
> 
> It requires essentially replicating core mm in user space.
> 

Is there any real problem if we don't do this at all (neither in core mm 
nor in userspace)?
