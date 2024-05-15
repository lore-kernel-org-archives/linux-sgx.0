Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA42156231;
	Wed, 15 May 2024 15:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715788723; cv=fail; b=neV7jcYHIKAPGsIxE7yNJzX5AX3D8oJujfKcTj6fUpvGYadvaedgqOaBa6q0M1O/kcRDCO9eBliHPkwmroowxfnbfqpd/OSkJ6u4tzqLp1Kqzdr86z4Hm9WuN1TuTOCRMS5Fc7jhr2zjQcd1h7jsKyn5KmdDK53UFPJUoJSG4No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715788723; c=relaxed/simple;
	bh=mV2eHTuvISRbbceoPYGqfpJB4bi8XlkqMe/n8KgIndA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uzfEubcKJdBh0m5mchPOGpgZkP72st+RxsEWyGPIU8Lq04BhRnc4Qo1o0VPuapi7fct6imHx2tgiYWQxN9MNBwetHDBiqWi2Z/GWf8IRh1/26TtBnUGbJX3Thd3VguYHM1SddJQgrw4TIBkhw6UBzgfA9WZ9m3NJXYd2gWs68xQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ebvkwsqc; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ebvkwsqc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715788722; x=1747324722;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mV2eHTuvISRbbceoPYGqfpJB4bi8XlkqMe/n8KgIndA=;
  b=ebvkwsqcwmGvIl1YDU/VXOeZtZTLRLSssUv7hvSbcB4LMns3bBswhebr
   +sYenwglGcB9/jljvWG0zD2a7tVrDycWrepOenKBlypyPDBI22tOCIj3e
   hh1yiftOoBrl/Box1l5wg1SM4Lfor5dp/ElF3T20Y42wVvI/COnKHCFO3
   Y09kjYZkqPaHU5GGKoAj87ryXEfF6gWMi+5cSEFmojzdLSHVPnra5uYvU
   rc7mtzvkdIX4g2zdfpkpMolyG5Z3lSc/BFTMnm7gelz+l5nhMs9QLBD01
   9qLvnocuO0NfFroEf8etFlY9Opi5TSnwze+/+Yb7wC6YOxtHwOHOUszCT
   g==;
X-CSE-ConnectionGUID: kmYi9JOISVKn/bbH33tVJg==
X-CSE-MsgGUID: abqlxVpNRFaDz1osgxphCQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11679076"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11679076"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 08:58:41 -0700
X-CSE-ConnectionGUID: WcBI8P27Tqy32dgBm+K9dg==
X-CSE-MsgGUID: CLlsu2H1Q2yOhGcd+Q9VUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31106905"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 08:58:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 08:58:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 08:58:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 08:58:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlSlUw4Iu7Pc3IrSLCT2vPQiZdZDy0r2q90nS8Bn7YsaN0RCsSnq8mEiLW8lcYTIZv7gVCYotH1//lV8EnI2JwBS22qb27Q+Tflov3HZKOPA4lylEgx/7erNASd1yAJkTBlp3geqOxZmONcjpgnj/tJtK6Krghklc4pN/G1C/kHZXdV54KvLP6U0osTJQf8tieiUzbsiNVeI+XiHnvM/nLPtUrrN6NXYFwE/44ZCYkFZyszbg+zq+DgF9HkbkuLvmk1j8z4XbcbEgcyKqFFhvvndM6/uI3R1u/hx5auIYC25E+apM79B03SXObMpzU6DY++dONI8uS9ZW/VXquTyjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHUiW6NUcS5Qt7VeQW/heq8ozzGg0dS7i+3U3aZyQBQ=;
 b=gxY6RtctBqJGMG/5Fp/bqE4sPrESwL5Zq9LOjNkTC/xEBFifRCjW2M6fp2iQF8Ki53NwkxqpULangT41reL0rY+deeCrNRs8xMJTnRnHZjscerD+AkntSMG5L2ZfdcSFCSDZd1lUQnHwkO6NfllHpsISh+x+FRjCV9rTOQFF2Thlvrr0MQbrntI8VlYecTW4k6aTx84T1TBcijMVfsRR5VERDmtOLHaFBH2TSmkQ5FBUwZab8S//8qdbyaIB2hziwdY/wl8Gp0k4LYdQHYwCt3AGDNY1BIx4i6hg2c0knLsFJ9+z+RL6pO81JZN4MvT0XpOSO6IBKRf+sUoQ1krlFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYYPR11MB8407.namprd11.prod.outlook.com (2603:10b6:930:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Wed, 15 May
 2024 15:58:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 15:58:37 +0000
Message-ID: <149a736f-8817-400b-93e7-0059b71af9f0@intel.com>
Date: Wed, 15 May 2024 08:58:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
To: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>,
	<dave.hansen@linux.intel.com>, <jarkko@kernel.org>, <kai.huang@intel.com>,
	<haitao.huang@linux.intel.com>, <linux-sgx@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>,
	=?UTF-8?Q?Marcelina_Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
References: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
 <20240515131240.1304824-2-dmitrii.kuvaiskii@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515131240.1304824-2-dmitrii.kuvaiskii@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0343.namprd04.prod.outlook.com
 (2603:10b6:303:8a::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYYPR11MB8407:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a8988c7-6255-4dfe-3e0d-08dc74f7e178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K0lVcXpOWlE1czFISFo5ZS8zTVFUdnN3YmwxTndwRHBtNHBvempNVmVBemVy?=
 =?utf-8?B?VUlUaEYwM1NLU2I2MHQxekpsdSs1eWxnTmJvRk5rSk05enZRczhOUVp2VTIv?=
 =?utf-8?B?cCtleHFWWEF5RDRBWWplK3orMUJXSUdYREszOXROMktBaVhYM0pYUUFudGZF?=
 =?utf-8?B?RWhnRHBiVWdKaVkyZFNRdEtmTldRMjFiemNyY1ZpY0NMSDRKelRIdm8veDBE?=
 =?utf-8?B?dlM0a3hMOWxaM3N3WmFtT3RGbHNBUXMwWkUreG9OL0g5WHY1eS8wNFJyYTNG?=
 =?utf-8?B?REEwemhCM0ZuT21NQjhIMTRmWDlrMDM2UGtwSnBiTEd1TmliMFg1S2szU0dX?=
 =?utf-8?B?RHNGcDlGc1oyNXI0SndLMmJVNitURmlQeHQ2QWV3ajIyRGYxVDBlRTh5eGJ5?=
 =?utf-8?B?a2oxWHhIckVrSkttb1UyYlp3Sy9VT3NUWVlhSG1lazhrcHNrUklXTEllWGcz?=
 =?utf-8?B?UGJmTFdPbzNXNGxlcTYyekJ0L1lJejFLNFZJRDF3RzRJSWhITTlITjB4L1VC?=
 =?utf-8?B?RDkybGFoVXlNN3dkTFpqa2JBcnA3NTFIaEtESUxuRHlaN1VtVzdxYU81NXRY?=
 =?utf-8?B?NFl1OVp4V2ljWW5pZTEycGVLSDhmRThPRHFGQU16bHFLQjhXVDc2MGJTS1VQ?=
 =?utf-8?B?VDBzUE9STDk0Mk9wM0VaalBobWFRaEdCaVlqT2JrNHd6OW84SXFEbE11OXgv?=
 =?utf-8?B?eC92U0V2WVJNaEhDUlJEeUFuK3FReVdXckozMVRmZmQzTG02NE1oOXJZYnF2?=
 =?utf-8?B?ZlRSbUFEeHdkOWtBR2l5OHUrOFUxMVFrTjhMZjdGZEFzSGE1MU9wWFZtckRa?=
 =?utf-8?B?SmFUbFdlazBSZGlFakRNSHlzcEtOUmROWHdodVNrYXYwaysxenpTM0s2WGkz?=
 =?utf-8?B?TWdlbDlDcTNjMzZ1MzAxby9UWGxLbWhicVhlRSsxVVJXUHVlaTE0dDE4NkpM?=
 =?utf-8?B?OXNmaUVLNmpHd0R5eEtDVkdYTUNHMzlvRkRJbnB5SWp6WS8rTHJlN2FYcVox?=
 =?utf-8?B?d3d4Y3FIMVdiMlMreVJhb1lUM0hreHRzZGhhKzNQMjgrMkpsdVl0WHJxVXg4?=
 =?utf-8?B?Mk04VTlwN0FKWkFDYW5zdWt2QmMwcU9xRkVWOXgxNmlsbDFueHVZNzNXeGdZ?=
 =?utf-8?B?WGIrWmltNHJVbHNRMUZOR1h6Wml4eUp1Vlk1ME1FZ0xLR3BqNkhHWFIrcG5M?=
 =?utf-8?B?dFZmK0lwa2hPN1NjVTRhRk93UW1PTHJ2WFhHeFp4TElDTzI3NE1CNU1WL3l1?=
 =?utf-8?B?MGZXUWtCYTJTUkRKWnVMZFp5cU9oeVR3QmwxWmFZOXUxVVJuR3QycjNyMlJq?=
 =?utf-8?B?d29jREgvL2o5aC9pSm83L0dqSnl6b2swTGRVSnNldWlhN01JUk5WRytQUFdV?=
 =?utf-8?B?dWQ4alVZT3VPYXZ1cURKT3dKZU9jT0Q2Q044QzVqalJMeEowU1drMXk1TFlt?=
 =?utf-8?B?WkMwTlgvUHdWT3YzeWtvczNCQXcwS0pVSUpmc0lVVEJxL3A3Mk1QYWRGL0VK?=
 =?utf-8?B?QU1hUEwxT3phbEIrZWtqRTNKM0VMdUFtNXFwaDVRdVFYSmRwNUdQWE5UZ0ZW?=
 =?utf-8?B?OTcxcHpzMDhPdjRUZ1B2UDIvYUV0TUp5dHBMZTJGNGwwVjNMb05QbjB0Yk1B?=
 =?utf-8?B?ZXFBQTFpR2huY0FBd0lGeHF0NU5NZ1o4bmtFVmdxT1NXN01UL3JLbTlyOUZC?=
 =?utf-8?B?VkxNNHZGRUw1UVdFejBlN3hVem9MMlo4cnJoOUZpTFZ4NFFpSEhDbWN3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWJJUkR0Q1hQTit4dnBRVGFVRnI3akFGbHdwcXlGNGhqd2xCUmc3TXgrcDNW?=
 =?utf-8?B?VXlGVk56UUZNTjRYdjV5TURydnhSNmVBQzIwSUhPYjRneWRxOXlxNjR0QXcw?=
 =?utf-8?B?Z2hNUzVHT1Z5TC8rQi9wVmxwSUxHb2E1REpIQlh6RTE5ejNWcG8ydXRZTmxu?=
 =?utf-8?B?Q2tYaWhQL1BxVGhyU1gvNU15SHpiU0lOL0xlOWpPanl5Q01DSlBwbmxRaDlJ?=
 =?utf-8?B?L1lYZnFwNUFicFAzTFdSOVVSZmNWOHRlVEo1bHRZQTZ5Zm9hOTFhUkx2c0NO?=
 =?utf-8?B?elJubzNIRUlab0c0UWdmWmUzZWhQOHlIYThuZDdEdjFMUUN2eG1NVVN1WkRD?=
 =?utf-8?B?YUhOdXk2UnZVdW1qRjJpTFB2ZjJaZzNoQ0ZvcTNsaUxoRWZxVGc4QXoxb1ht?=
 =?utf-8?B?dWdobEZOazlKOHRvUGc1eWViSkFybmJGdjZ0dkJUL1JPOHNCOUJ3SURGaDEw?=
 =?utf-8?B?TVBoU1R1QnB0RDI1cXBCeC92MEpmWlhCV0ZrM3hJL2VGdmxXRmN1bExMMVBI?=
 =?utf-8?B?KytUYkRXb0VIVjBJVy9Jbnc1QzhNYzlHdm1NYXBxWExha2Y4azNHN0xMRWlE?=
 =?utf-8?B?OU1DU3FKaG84RXlUWkpiOUdnU0R1S2RCODVjNSsxeUhzN0wxeGJJY2VQbEg1?=
 =?utf-8?B?UFVRM3V0ZysvOFUxT0NFZmZEemhGUjhVUXZMaUVGS1BVUnpGTDdxbHM3bndL?=
 =?utf-8?B?Y0tRMkl3MEJDVlJYaEJhWmlRL2ZOU0JmZ0h0QURwNmVORkNtSnJEd1NuV0Qy?=
 =?utf-8?B?MEFvY0I0VTlPUlo5NFIxbUwyYWl1dHZLbThENkM1bVM5RFA1YnZSaDVrQlZQ?=
 =?utf-8?B?R1ltbm9rTHhsMHhqdE9Ca00waGJBcFA5dFNFWGc4ZUxEZndFS3lib2R3dng0?=
 =?utf-8?B?TXRUV2pDUStOOHdQVHVDMUVyajBQeWFvZ0wzNUtXV0dqTlp6U08xSkNXR05P?=
 =?utf-8?B?L3YrNGFSYkhiQ0I4KzhFS2dqeVphTHF5UXBwbHJsaUU0QmFFdDEzS2c2WC9q?=
 =?utf-8?B?bUpWR2Q1M0M1Y1VheVdZclN1d1YybUF4Vlc2MFIraHBxSVpZRGV0YTJyMTVo?=
 =?utf-8?B?aiswMUZkQm9VYUhrUXdVM3lUODhYN0FJTGJpaGFicUpoeDlYZUR0RDVXb2NW?=
 =?utf-8?B?R3k2WE90d1h5cUFaRDhXcExjRVl0UlQ2WFhHY3h5V3RGOU5aQStqQjJvbWxY?=
 =?utf-8?B?ZzFBYk1xR1hnaUp0ZDJ4WWNSL21iSWYxd1RtZUtMK0V5OWx3WTJhZlJ5SjhG?=
 =?utf-8?B?YUozeHBuaElmaEdZOFU3bzhDWmQybTMyNWFjSGhJaWdxTnZ0UzVmdUh0L1No?=
 =?utf-8?B?aittUVdnYVZSTmh4Vmc1MmYzUWxWRldHZ3gzNHJzbnVKR0xvRzVqSm0rOUhi?=
 =?utf-8?B?VGlVSmhFRHhObFFtMjcxekFmWHR3UXdVMXBWSTBTQ3FKZUhydEc1S0FNZTBz?=
 =?utf-8?B?QzdPZ3JQdXhVcER6aXp2bDd5U1ZmUnRTcnU2WlFBd1pjSjRTRTB2V0NmYkRX?=
 =?utf-8?B?OTN6WjRVcXV6NnI0YzYyWGZCRVFCVDhxMHVpbU14Z2VKUDJqSk1nWW9WVllp?=
 =?utf-8?B?NzN1VGxXRVBxc0Fac3BJWE1senppeWoxR1c4a245RkJRVE91eUFXQ0hBRDJt?=
 =?utf-8?B?WGlFdjFFRFFiZC9YLzdNbmRTa004ZjZIZC9BVldLQ1JsZ1NkZ2grWTNTV2R3?=
 =?utf-8?B?dGsvczdyVGwzQ3VEcnAvcFQ0TnI0RnE3djd2Mjg2NDhGSms2Zmg5Y3hWSUVh?=
 =?utf-8?B?WFJBY0w3aTdzQWJXeEVOcWUrUmprMjlweGxSZ1h2MVZvN3dza00vc0QweU9l?=
 =?utf-8?B?NU5qU0E1YVZlakxmUzYrZHlMWlhFVTduVUVOOGU4TjNSQTI4cXBVaWtvcC9h?=
 =?utf-8?B?L0hWdE9wcGc5dVZXSFRidlBycjFjZHBPTjl5cXdkR0VaSno4a3U0SFp0WlZW?=
 =?utf-8?B?OW5wL2R1Z3JEZ1ZBVC83ZmdOUk9BbnoyUENSR1pLSmxadmZVcWpnM1k3Z25D?=
 =?utf-8?B?ZGxaakNXZW9VVzRtVzhPeXoxR281NVJ2TERIU0Q0d0QrSFgzWmlPZ05oVEtN?=
 =?utf-8?B?Z1dZRmVEWXluRng3QUVNUmFFWXdmdkpmKzE2RXYvZjZGczdoZXB0bENpQjV0?=
 =?utf-8?B?eGFkcGl5bjZFbUlsNUpXbjVRVnpEQS9UVVQ0UllCa1l2c3hmUnNKK1hjaGVl?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8988c7-6255-4dfe-3e0d-08dc74f7e178
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 15:58:36.9392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X280jvhSVqK+Of8qSdsovWvM0ryZiws4bTLEaSUovpTKtbL0dKdheeaak6XHKxOYHJcU8opZsF5ePuk93lgkPgVjO+7De9i+mGkH62lwAYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8407
X-OriginatorOrg: intel.com

Hi Dmitrii,

On 5/15/2024 6:12 AM, Dmitrii Kuvaiskii wrote:
> Two enclave threads may try to access the same non-present enclave page
> simultaneously (e.g., if the SGX runtime supports lazy allocation). The
> threads will end up in sgx_encl_eaug_page(), racing to acquire the
> enclave lock. The winning thread will perform EAUG, set up the page
> table entry, and insert the page into encl->page_array. The losing
> thread will then get -EBUSY on xa_insert(&encl->page_array) and proceed
> to error handling path.
> 
> This race condition can be illustrated as follows:
> 
> /*                             /*
>  * Fault on CPU1                * Fault on CPU2
>  * on enclave page X            * on enclave page X
>  */                             */
> sgx_vma_fault() {              sgx_vma_fault() {
> 
>   xa_load(&encl->page_array)     xa_load(&encl->page_array)
>       == NULL -->                    == NULL -->
> 
>   sgx_encl_eaug_page() {         sgx_encl_eaug_page() {
> 
>     ...                            ...
> 
>     /*                             /*
>      * alloc encl_page              * alloc encl_page
>      */                             */
>                                    mutex_lock(&encl->lock);
>                                    /*
>                                     * alloc EPC page
>                                     */
>                                    epc_page = sgx_alloc_epc_page(...);
>                                    /*
>                                     * add page to enclave's xarray
>                                     */
>                                    xa_insert(&encl->page_array, ...);
>                                    /*
>                                     * add page to enclave via EAUG
>                                     * (page is in pending state)
>                                     */
>                                    /*
>                                     * add PTE entry
>                                     */
>                                    vmf_insert_pfn(...);
> 
>                                    mutex_unlock(&encl->lock);
>                                    return VM_FAULT_NOPAGE;
>                                  }
>                                }
>                                /*
>                                 * All good up to here: enclave page
>                                 * successfully added to enclave,
>                                 * ready for EACCEPT from user space
>                                 */
>     mutex_lock(&encl->lock);
>     /*
>      * alloc EPC page
>      */
>     epc_page = sgx_alloc_epc_page(...);
>     /*
>      * add page to enclave's xarray,
>      * this fails with -EBUSY as this
>      * page was already added by CPU2
>      */
>     xa_insert(&encl->page_array, ...);
> 
>   err_out_shrink:
>     sgx_encl_free_epc_page(epc_page) {
>       /*
>        * remove page via EREMOVE
>        *
>        * *BUG*: page added by CPU2 is
>        * yanked from enclave while it
>        * remains accessible from OS
>        * perspective (PTE installed)
>        */
>       /*
>        * free EPC page
>        */
>       sgx_free_epc_page(epc_page);
>     }
> 
>     mutex_unlock(&encl->lock);
>     /*
>      * *BUG*: SIGBUS is returned
>      * for a valid enclave page
>      */
>     return VM_FAULT_SIGBUS;
>   }
> }
> 
> The err_out_shrink error handling path contains two bugs: (1) function
> sgx_encl_free_epc_page() is called that performs EREMOVE even though the
> enclave page was never intended to be removed, and (2) SIGBUS is sent to
> userspace even though the enclave page is correctly installed by another
> thread.
> 
> The first bug renders the enclave page perpetually inaccessible (until
> another SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl). This is because the page is
> marked accessible in the PTE entry but is not EAUGed, and any subsequent
> access to this page raises a fault: with the kernel believing there to
> be a valid VMA, the unlikely error code X86_PF_SGX encountered by code
> path do_user_addr_fault() -> access_error() causes the SGX driver's
> sgx_vma_fault() to be skipped and user space receives a SIGSEGV instead.
> The userspace SIGSEGV handler cannot perform EACCEPT because the page
> was not EAUGed. Thus, the user space is stuck with the inaccessible
> page. The second bug is less severe: a spurious SIGBUS signal is
> unnecessarily sent to user space.
> 
> Fix these two bugs (1) by returning VM_FAULT_NOPAGE to the generic Linux
> fault handler so that no signal is sent to userspace, and (2) by
> replacing sgx_encl_free_epc_page() with sgx_free_epc_page() so that no
> EREMOVE is performed.
> 
> Note that sgx_encl_free_epc_page() performs an additional WARN_ON_ONCE
> check in comparison to sgx_free_epc_page(): whether the EPC page is
> being reclaimer tracked. However, the EPC page is allocated in
> sgx_encl_eaug_page() and has zeroed-out flags in all error handling
> paths. In other words, the page is marked as reclaimable only in the
> happy path of sgx_encl_eaug_page(). Therefore, in the particular code
> path affected in this commit, the "page reclaimer tracked" condition is
> always false and the warning is never printed. Thus, it is safe to
> replace sgx_encl_free_epc_page() with sgx_free_epc_page().
> 
> Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initialized enclave")
> Cc: stable@vger.kernel.org
> Reported-by: Marcelina Kościelnicka <mwk@invisiblethingslab.com>
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 279148e72459..41f14b1a3025 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -382,8 +382,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  	 * If ret == -EBUSY then page was created in another flow while
>  	 * running without encl->lock
>  	 */
> -	if (ret)
> +	if (ret) {
> +		if (ret == -EBUSY)
> +			vmret = VM_FAULT_NOPAGE;
>  		goto err_out_shrink;
> +	}
>  
>  	pginfo.secs = (unsigned long)sgx_get_epc_virt_addr(encl->secs.epc_page);
>  	pginfo.addr = encl_page->desc & PAGE_MASK;
> @@ -419,7 +422,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  err_out_shrink:
>  	sgx_encl_shrink(encl, va_page);
>  err_out_epc:
> -	sgx_encl_free_epc_page(epc_page);
> +	sgx_free_epc_page(epc_page);
>  err_out_unlock:
>  	mutex_unlock(&encl->lock);
>  	kfree(encl_page);

Thank you very much. I understand the changelog is still being discussed
and those changes look good to me, to which you can add:

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
