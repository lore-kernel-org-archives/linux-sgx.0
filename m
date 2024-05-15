Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95646155723;
	Wed, 15 May 2024 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715788376; cv=fail; b=Cjp0bszjWpC6qRVpv6LVSl25110H7ZxS4VLfeAJWLpvA66jb9fQH2SKZQKrwb1blYp8pcF0mA0G4G4ADtReh9f83B5x1ZiCh2VgSh52fs9z4wJu/dvs0WHG038bdLlaJIwsLSUkcf/GAUmh8qoU9oVaXYqhOyQftYLXP7CcuDi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715788376; c=relaxed/simple;
	bh=OJD4K7NglkEa3Td/4Gf40sFYQvrker8T22zHFwjJIzY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C9M72IiPuidkwLEPCzKjpf10OmYb32IqEU/qffVFrq9AWYMYDqerU0y8phnVVrQgAcoX7dwAHwCJC8AqkaiqucyQoIv6+VjVeVw8wS1KfWW9eMLfYTYmuVE7rYz5kmyUVctMxSBEBokmSVMzhT6Uh2X51ki+Tb1dcMRnR9AFo20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UGTt9ovX; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UGTt9ovX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715788375; x=1747324375;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OJD4K7NglkEa3Td/4Gf40sFYQvrker8T22zHFwjJIzY=;
  b=UGTt9ovXT/cWtN3ddz0NjMYU4JZT+9Jt+Ua7SN3iXwhd1NhJUQqIV7tp
   cM4ypZFNBlCIl2ubULrCNsMYFIC9r49LGBAt42kxyrl+cPllG8sg293WU
   dsohFlGnz2Fm3/4ErFLsx3hmfpTrqkYobOEBVfjpwsIblMqXoYhvkJK5+
   ooYDUKDtL+gFqdoKY98PApcFMno+RR32ctuNiu4Z9X1mb46eOYDs52mPi
   LqJhlwKrcY4QfbcTWwJPxiqsGKhn0dY+LiOUg2c2LqDurT0sycRLui1jy
   /es/XU2/13nJy4Jv/zhgvwuAFlLcLbjDhb5xi8qb0GYk733GeetFQbGjz
   A==;
X-CSE-ConnectionGUID: h2i5LiUnRHmHOSFgdMEz0w==
X-CSE-MsgGUID: rbwkA9h7TTuuyotz+jmEMA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11703868"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11703868"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 08:52:39 -0700
X-CSE-ConnectionGUID: Lo/ndSV2Qq+SMFaIYnEFBw==
X-CSE-MsgGUID: cHSffqHsQEah1BJtrnwwRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31233744"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 08:52:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 08:52:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 08:52:38 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 08:52:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVDba8P4ab7AwLEAWMOQ77k8DnoYTbDDQZNHSP/BaBd6bzPbT5/kwBttPvhV188VTlFxe1DOvbyOPPpk4vbAMH0dfVSqsTFz5FilOD55+V6s5e7gXngwhrFMt/p538RB5wisViuCHMf/D4U0e15UDR871vm8XR9kH1B3TwmuuoT+IPHKrlmnR5yVnOzXdYdDfS7VrcCwZPsHbu7lOI7ROo97kaGaMEo5TKbkhZuuRaU9h1za6G+2EsglN3fJER75n7D6i2LxZq/mcdbGbbYZuSaDVD8+sswSCAwW/FReIL0yrx5F8GDT2S8JvGzDPEx2HOWz3z7KZLNn3uPCbJRzWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbBPBoWNanTm1jveWrzXb2HenDjQDbXdbViCwNMr2eU=;
 b=oQEfMI4PiMPgy39VibRkWVXps6yRsILHDRsVxQ5UqCnwUSr6Jp313iSeKcvFOvQcftX9jtBqizxCJrgGW+4KRii7/JrdOlWg8KLqeDEwmjLuUuNYJ8Vp8HZeZE2y6sOxCoV/V7kH+oKdRWWVEJhAGfhaQmKPI+e8E7ZbybSQeN00ejR4EL3MEVdMxeLPPDIVUMkOXQJkljYO10gjanKcLk326XxWpFB3MCsNpv9SstzfoWbxhksVZBRUbkduGiPXEAVEbJs5GTz9pB84Cdh9b+GfAY7zng2+QO+au8PB9QMYwSo4gbODkBbIEWQJxf+kcn5QEWyxWvCs+Uw/jos4VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6546.namprd11.prod.outlook.com (2603:10b6:510:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 15:52:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 15:52:36 +0000
Message-ID: <e81e35b2-466b-4804-b717-f3e6dc26bfa2@intel.com>
Date: Wed, 15 May 2024 08:52:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
To: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>,
	<dave.hansen@linux.intel.com>, <jarkko@kernel.org>, <kai.huang@intel.com>,
	<haitao.huang@linux.intel.com>, <linux-sgx@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>
References: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
 <20240515131240.1304824-3-dmitrii.kuvaiskii@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515131240.1304824-3-dmitrii.kuvaiskii@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0030.namprd21.prod.outlook.com
 (2603:10b6:302:1::43) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6546:EE_
X-MS-Office365-Filtering-Correlation-Id: 2150a8d3-2baa-4eda-7ebd-08dc74f70a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ODl5Q3BXNE5EdHphSkFUNVNVNy9ydWM2QzhWUkdONUwrRnk3aHp0SEMxR2pq?=
 =?utf-8?B?c0hoWkVwdmlXYVlOMTlWYW9rWDJTSFBoMUdjaTZVeFFaZ21wRmtlRVR6S2VV?=
 =?utf-8?B?WHJ4RmhHQ0lkWGJPUE44YzJSYTA2d2FEb1hpTWNlUjJXWCttTUFNOU9KZWhV?=
 =?utf-8?B?VFM1bFNWdVlONW9FUXJXTkphaGsrNkw2d2NSSVlFLzNTdit5WCtWYzhLLzdq?=
 =?utf-8?B?Vk1VOXBUL2VrMHA5VHJJajVRWFk2M2NoU3RWNmNVbTVERFE1NkR6WWxWNE40?=
 =?utf-8?B?Ky8ybXR2aDEzbTlzOG5sUC9CcDJYZTFQYk9QV1hQS2pwdHIvSGorcVIzM2RP?=
 =?utf-8?B?SjNOTHBGd0dVSmhaSkJxYWpYbDQrMEgzb3lUNzBoUjFkQnZtbU53VGlpQy9h?=
 =?utf-8?B?WkVicnJUZ05XSDlnell3eHJsaW0wZ05QVW0rY3VzRkdFaldOdVh2ejNsTmF6?=
 =?utf-8?B?YkkyZWlnUi9pK2FGZ2ZVbkhVYWhtb3EwN0RzL082Ulgxd2pzUXhzY1NSemJn?=
 =?utf-8?B?bFF5U2M5VDA2SzB3Tm1qVHYyM3hkNTA5Y25QK1dnb0pVOUliWWE2eEYxV1Z4?=
 =?utf-8?B?eVh4aHg0Wk4xWUx3TkI2U3FHa0JzU2NNNkFyWWNZaUFBdXFXd245RmxLNTFu?=
 =?utf-8?B?WVJzS3V4QlNKVC91bGI3U01UNVgrV3M0SUhkVzB5bUo4c0RzTWlNU3laRXhx?=
 =?utf-8?B?Z25BMHBjQlZXK3p3Y2FsZzQrVUE3cjMyNHluR2U3K1FRdnAxUkV6dElKWFhq?=
 =?utf-8?B?NVFjSGhsN0JDWUkwU1QrQkRMMHkyUlJucWp2T21uQVQ3dm5vNDhOUmpiZlYy?=
 =?utf-8?B?bGtQVEYraVJiSjczVHpnd01QVlg3a1RzSytCdnJndjBLTDdQU3FObVp0SmJ6?=
 =?utf-8?B?ZkdwSlJZWi8xZ29CbEFlNWc4YmU3NzJqR01zQWVvVTkwUG5OZVhBQnR1SzhG?=
 =?utf-8?B?OGJSTTRZRlpzYzIrOVdUeVlPMmgxVS91M3VPTk5Wc0IzT3Vwbk45UGJrKzlr?=
 =?utf-8?B?ZFArOWVJbEd6QUtka2c5OXhHSkNqazdRTGRLNmN0Znl0TTlnZGY0VmxhVGFL?=
 =?utf-8?B?Y1ZSVXZxUnQyVVVmSjg5Nm5nKzV5SHc5bVN5MXZJdXdtYjBxK0x4MzE2L212?=
 =?utf-8?B?ZHVMZy9SNVlQcWFkOVVRR1U5c3V4Q0x2b2xpS2ZvZ2E4Tm5oYmttc0Q5MzJW?=
 =?utf-8?B?a25rR0tic1hiU2pnL3dXVkZvdzRYMWJPOTFabDh0UGkxVWQyWUlyaHRCSGJC?=
 =?utf-8?B?bkxCUnhtNW9HOVJ6SGtQb3hWSjAyM1VBcVlkR0RrSzV6WFFTVURJcVZQUXk3?=
 =?utf-8?B?aVpScDhlNFhGc29CL0VDMXFjS1RkeHNkNlNZT0ZYNTB5SFkxbjRySjN5Rmlw?=
 =?utf-8?B?b1VHUU1Hall6bVJLNWJiYnRveDVrK3gvMXpPUUFaSElxelMybDU3RlhHeG5u?=
 =?utf-8?B?WDlOdS9KSThmRS9jTmc1Q2grd0o1ZU94cldYNUpVZDJrV1J5c0FBZXdub3lM?=
 =?utf-8?B?eDF2b0RoNkRuYzkwb3NFd2d2bkxvcnlubXNWQUhWMlhLSXZEb0llcE01Y01N?=
 =?utf-8?B?U04yK2ZqTVYvN2c5bzNPVnl0d3RLZlJ1MjF0aXdlZXZPaFJuTmt2V1FDM3Jp?=
 =?utf-8?B?eUtBK25KTU0wajNCdE00WEdSRFNJQzBQVU9mU2I3ZGNEaVBzclJvSjdIemZ3?=
 =?utf-8?B?ZzZuekFGZSs4TDNNZkJGVFZRY2hUbmFCOW92N0xJSmNwNXE2VHRGMUpBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0V3OEdoWFk1eWhXUUtOeXVpVUVYSk84bnJ0RndUdnBLL1RhTG1sa0M3NFJx?=
 =?utf-8?B?TWlMOXZrNzJ2NEF2czhLcXZHUDliVkpGVW8zMG1mYnZ0NThSbWNSVFJQTG1u?=
 =?utf-8?B?QldCOE9tdUNOSkNpd2diUGF1dlNtTTFTeFlFRFNKSllrWmVPQnZxaGw4RXVX?=
 =?utf-8?B?NVNnVGt2dkhqZFZnUE9kT3A4bjhLWUtZU1FkZHhPS2pUL0dmU09SalQ0dFZQ?=
 =?utf-8?B?TXloQnZNbFFvUWJlRjJodzJmeW9Mc1FKL2ltYlhGRE5DUFIvMXhxaTV0ck5Z?=
 =?utf-8?B?OEpFbmZhQVFrbVp3dEE5TThlZ214Z1ArL3gyczVjNnpheFFxR0h4NlJ6MkhF?=
 =?utf-8?B?RHJLTU5EVXRHbDRRa0I4M0NQclE5TUN4bHNXMmVSdzdmRGUvVWJuWHN2eldP?=
 =?utf-8?B?OFNndVJNVzUrTVFkR3lOMGExRkJubktrMzV1VnZ2alpNRkd0aEpyeDRhRGk0?=
 =?utf-8?B?Z1l1MkhZR0szZ0Rjc3dHUDVQb1U1LzFKNURlZEx1SjUwM01hR1FwbjVrL25a?=
 =?utf-8?B?TzVSVkRrWnMzR2xyd0t5SUNiOWZNM3lxbGZTNGZFVmNpY3BWNVhFN0E4b0J4?=
 =?utf-8?B?dFdQTE0zUVdKdjhjampHdDc1TWJMZkRhVHRxK2pSS0ZiQXAyb3ZUU2VCc2d3?=
 =?utf-8?B?WHYrM21DemJUNUpGT3RSVGN2UHlJOW94bmMzT1pPM0FreERuOGpFbFNkRTJM?=
 =?utf-8?B?TjJuQXJMb01Ed2o2aXlBNEh0TUtlM2Y5ZUJOYjB0WU8rZkdpWXBUUjhtd20x?=
 =?utf-8?B?US9rL0FLTDFQdHZUTnZPWGlNZ1RtaFhpV2ZDd1o1RmM3VTNGcXp2WlRrZm9L?=
 =?utf-8?B?YVVsMXJKMnJZck03SklKVk9IYjgrVmI5VFl0SVphR1pIUzc4c0xlM1IzMzVV?=
 =?utf-8?B?aU9uSEhpUlRubzltaUlQa29ta1pEYVNTYzFBVXFJOHozbXRQWkY0L3dON3dD?=
 =?utf-8?B?MTd0T1YzK3VleXVtQjVuUnAySHY2RnpTSkVQRkQzK2VRbFJCUjF4OWFITWc2?=
 =?utf-8?B?aWhDV05PaCticlBzV2lUZmdhaFFNakg5SGxETEhibXI0WkZkY05hczMxQW5r?=
 =?utf-8?B?VVpiTGx0YWFUaE5yVHE2ekZoZFVLUDZyVDJDSEZYN1dZbFltZkN2UkpPZnRM?=
 =?utf-8?B?U3BFdkFLTTROYmxjZVFjeTl5eHNmM3ZIS1duVkcxakpuYi90c0k3K2R3RHIz?=
 =?utf-8?B?am1XVXRoMjJvUlpTNnpYU2c0ZnJYU2tYcy9JaWZrOXhCMmpkT1Rac0ZjTlo4?=
 =?utf-8?B?VUM1b2JiSFZBZkRMZzZjTXpPQTNNNkFVNnVIajZuaXc2bnhLanl2SmRvc1Rr?=
 =?utf-8?B?N3NiTHBTU0k0SkJqVHQ1UG1aS1dDM2NJTWRJelREaUczekYzdHJHWEVLTlIw?=
 =?utf-8?B?SEhaY3orUUlBSVA1YUlBYUlpbmMvTzF1NHdkYlIvV05SVzZFckZHcHp5UlA0?=
 =?utf-8?B?WlozQmhBWTlaNnYrQnlPVStYQWJsSE5xNmhtanJxNEw0ZTBWeC9CMTkvMnpC?=
 =?utf-8?B?d2hXVGMzWkVtNlZzdCtmMFNwdmZoUGlKZDZpMkdYbktlNnJQWEFxd0hwREkz?=
 =?utf-8?B?NXJBeHVsOHBwalZ4ZW1sMzdZUjZYZE9uLzZJSmQ2bTNCTHUvbHU4VTJ2SkVP?=
 =?utf-8?B?Z2hMbHgvenAyOWloalJDUGxyQjhlZ2NKTjJDN1FwNE9PaUxzcnlyZFM2c0lV?=
 =?utf-8?B?Q3oyODh0RWhOSGdZcVJtVk1kc0ZqckVXQ2Qzem5BVURYMVF2M25aQ29adjJu?=
 =?utf-8?B?dkc1TzZLbWN3c1JzV2FqV0EzMjgrVGo2TTJsMTlBYUdaemFmaXNqK0szSFlr?=
 =?utf-8?B?cklYcFV5WHVpZU5mTUVSbkY1WGVuM3FqeVBMUlVYOERPVXJ2RmM4QVJTTjhu?=
 =?utf-8?B?M216N3ZydG1KclU0aC9waFJNdFJaSWpsa2tGUEhhQ0dEa3FnbHA0b1R2U1ps?=
 =?utf-8?B?SGQ4Q0Q4eXNXbDY2K21GSFlWbHJKWUZnYWtucjQ5eWtYbHd6Qno5Z0VDOUtl?=
 =?utf-8?B?a0NFMHJxWmNSeEtHY3JsYXdUYWV6Y2JMc3FpbS9NVjVKYklaMnRpUDJEdDk3?=
 =?utf-8?B?ZDRqME0vSHcxbUtsU1pRMEQzTjFOL1pmS0xnY2dMeGJKNHJIRXhSbzNCOTdE?=
 =?utf-8?B?ejlRem5LZXdnWThQZWtqL2YxdFpDdy9VRnJWN0twRlQxUUtSV3U4bWRqazVj?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2150a8d3-2baa-4eda-7ebd-08dc74f70a5c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 15:52:36.0851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ABuHYFGlE425hzDrtqGPa2Np3sqDY0CDg4FUYDOVNIR6A/4KJFL2Yb5Ocqd8ok6wXW1yVgxE8AVP4bYUxdlRD5H036RL0e+m558HjExvu0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6546
X-OriginatorOrg: intel.com

Hi Dmitrii,

On 5/15/2024 6:12 AM, Dmitrii Kuvaiskii wrote:
> Two enclave threads may try to add and remove the same enclave page
> simultaneously (e.g., if the SGX runtime supports both lazy allocation
> and MADV_DONTNEED semantics). Consider some enclave page added to the
> enclave. User space decides to temporarily remove this page (e.g.,
> emulating the MADV_DONTNEED semantics) on CPU1. At the same time, user
> space performs a memory access on the same page on CPU2, which results
> in a #PF and ultimately in sgx_vma_fault(). Scenario proceeds as
> follows:
> 
> /*
>  * CPU1: User space performs
>  * ioctl(SGX_IOC_ENCLAVE_REMOVE_PAGES)
>  * on enclave page X
>  */
> sgx_encl_remove_pages() {
> 
>   mutex_lock(&encl->lock);
> 
>   entry = sgx_encl_load_page(encl);
>   /*
>    * verify that page is
>    * trimmed and accepted
>    */
> 
>   mutex_unlock(&encl->lock);
> 
>   /*
>    * remove PTE entry; cannot
>    * be performed under lock
>    */
>   sgx_zap_enclave_ptes(encl);
>                                  /*
>                                   * Fault on CPU2 on same page X
>                                   */
>                                  sgx_vma_fault() {
>                                    /*
>                                     * PTE entry was removed, but the
>                                     * page is still in enclave's xarray
>                                     */
>                                    xa_load(&encl->page_array) != NULL ->
>                                    /*
>                                     * SGX driver thinks that this page
>                                     * was swapped out and loads it
>                                     */
>                                    mutex_lock(&encl->lock);
>                                    /*
>                                     * this is effectively a no-op
>                                     */
>                                    entry = sgx_encl_load_page_in_vma();
>                                    /*
>                                     * add PTE entry
>                                     *
>                                     * *BUG*: a PTE is installed for a
>                                     * page in process of being removed
>                                     */
>                                    vmf_insert_pfn(...);
> 
>                                    mutex_unlock(&encl->lock);
>                                    return VM_FAULT_NOPAGE;
>                                  }
>   /*
>    * continue with page removal
>    */
>   mutex_lock(&encl->lock);
> 
>   sgx_encl_free_epc_page(epc_page) {
>     /*
>      * remove page via EREMOVE
>      */
>     /*
>      * free EPC page
>      */
>     sgx_free_epc_page(epc_page);
>   }
> 
>   xa_erase(&encl->page_array);
> 
>   mutex_unlock(&encl->lock);
> }
> 
> Here, CPU1 removed the page. However CPU2 installed the PTE entry on the
> same page. This enclave page becomes perpetually inaccessible (until
> another SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl). This is because the page is
> marked accessible in the PTE entry but is not EAUGed, and any subsequent
> access to this page raises a fault: with the kernel believing there to
> be a valid VMA, the unlikely error code X86_PF_SGX encountered by code
> path do_user_addr_fault() -> access_error() causes the SGX driver's
> sgx_vma_fault() to be skipped and user space receives a SIGSEGV instead.
> The userspace SIGSEGV handler cannot perform EACCEPT because the page
> was not EAUGed. Thus, the user space is stuck with the inaccessible
> page.
> 
> Fix this race by forcing the fault handler on CPU2 to back off if the
> page is currently being removed (on CPU1). This is achieved by
> introducing a new flag SGX_ENCL_PAGE_BEING_REMOVED, which is unset by
> default and set only right-before the first mutex_unlock() in
> sgx_encl_remove_pages(). Upon loading the page, CPU2 checks whether this
> page is being removed, and if yes then CPU2 backs off and waits until
> the page is completely removed. After that, any memory access to this
> page results in a normal "allocate and EAUG a page on #PF" flow.
> 
> Fixes: 9849bb27152c ("x86/sgx: Support complete page removal")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c  | 3 ++-
>  arch/x86/kernel/cpu/sgx/encl.h  | 3 +++
>  arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 41f14b1a3025..7ccd8b2fce5f 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -257,7 +257,8 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
>  
>  	/* Entry successfully located. */
>  	if (entry->epc_page) {
> -		if (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)
> +		if (entry->desc & (SGX_ENCL_PAGE_BEING_RECLAIMED |
> +				   SGX_ENCL_PAGE_BEING_REMOVED))
>  			return ERR_PTR(-EBUSY);
>  
>  		return entry;
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index f94ff14c9486..fff5f2293ae7 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -25,6 +25,9 @@
>  /* 'desc' bit marking that the page is being reclaimed. */
>  #define SGX_ENCL_PAGE_BEING_RECLAIMED	BIT(3)
>  
> +/* 'desc' bit marking that the page is being removed. */
> +#define SGX_ENCL_PAGE_BEING_REMOVED	BIT(2)
> +
>  struct sgx_encl_page {
>  	unsigned long desc;
>  	unsigned long vm_max_prot_bits:8;
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index b65ab214bdf5..c542d4dd3e64 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -1142,6 +1142,7 @@ static long sgx_encl_remove_pages(struct sgx_encl *encl,
>  		 * Do not keep encl->lock because of dependency on
>  		 * mmap_lock acquired in sgx_zap_enclave_ptes().
>  		 */
> +		entry->desc |= SGX_ENCL_PAGE_BEING_REMOVED;
>  		mutex_unlock(&encl->lock);
>  
>  		sgx_zap_enclave_ptes(encl, addr);

Thank you very much for tracking down and fixing this issue.

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
