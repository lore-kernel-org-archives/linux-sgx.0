Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0F715539A;
	Mon,  4 Aug 2025 07:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754291834; cv=fail; b=Qy77GtBRJBDZUWHdpCHSquhEEltC5KOQVYgSWkI1YjpjaBgIUj+DPJbF8T/nquLz3DKshfy5vNktubnKL/1oGlDQbd7ySNZgKGcEBpKcnUbmG5ATuoZ4qugO+Zlc/TIrwnwpi2z5YFcE/H8omJCBay4+wNsOAbpCBXHKogYhfcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754291834; c=relaxed/simple;
	bh=gj9I/JIhakKAu+GGSg5uFdZc8si19XsUUcEQvyZ3cOE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LXyTCDEnsm6I/SnbhLolZzH6P0bfVaRs02vzaY/rqtx/W/yhP66Y435bhp8F0uflL2bGidpyyHfCX6M1QC9x736QujoSBCtIe/7TRtAUpkS6fgiWI98Z14d9HUFz7TvFUvFhPYqY8rBsYG6+pSMVdRvTweKRqwkXEcMlCBcROp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ftm/QX0K; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ftm/QX0K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754291833; x=1785827833;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gj9I/JIhakKAu+GGSg5uFdZc8si19XsUUcEQvyZ3cOE=;
  b=ftm/QX0KRXD53nSFRGCmO3I6tbFb2yH7mNq6xWOtIQflLHLSB+foS0r1
   vpYcpSyzMR/MoWdR+FtXv37LQlscNv3uc/MwKG/v9siqUR/pNTk2HDFZd
   uOKbsWmA/P7ZxI9HuqWtmchdOWxqYCdrNZ4QBxOp2roNZsiqEIeeknN9X
   9TnijRGtSIYM/834Wcp16HO8NkOOm+g8x61kVMvHhq8sPnbKErNQiQMYA
   IFk22rNYEQK3sQoVF2DgPKx+boNY6ZnaEBDFQL5/+0glRHbOpzQQ/XKaM
   8qaK7AHgxksA6NDKNzPCHUN29VolugNFA/S3x8SILlXJP9Th5tBov5UYJ
   Q==;
X-CSE-ConnectionGUID: YJ8iV9ifQJ2z5NN6JMLfiQ==
X-CSE-MsgGUID: WFwL1cbmRY+UM7HHMqdyCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="67916145"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="67916145"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 00:17:12 -0700
X-CSE-ConnectionGUID: y5kZXL39R1K0WXnSG5RJCw==
X-CSE-MsgGUID: GgxqZ0m7RgmUmS9T9pt0Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="164084354"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 00:17:13 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 00:17:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 4 Aug 2025 00:17:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.59)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 00:17:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ED6sQOuW98Xn3B9yP7jL9FdHN6Mx7sXtWEQbtTDBfgxtXm18QRmUavzzlO7XxrMDf4E0Abuvhzq9iT8E1AuWJR+CF1gviSUxOlbzvpSc7ceO2PcPSm2JR9Z518YL9G6LuL/50OvKoxTJlDaftSn+Ys0w3bgCGozWYuWb1ro620gByA4h/ceY4yqTUIEvI2T3vMyINzLIODPJZPbGyV46gSnf1zI2TtGb7o2Q55vOGJs2JnReEkSF1jFXT65BOVjXvKBxOoPrOGxZO6UngUGqWN+9dyOjzDAfVQlHbEHhqetKPIOOIrUYZQsdJXiW8ZU1EQnjQ044I1lkej8xzfB2Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gj9I/JIhakKAu+GGSg5uFdZc8si19XsUUcEQvyZ3cOE=;
 b=X8sSDUTN0MRn11Nl72FzIyuUN9MStm9XPSVVjuOwPUB6aQjYvwdmnb6MFeg4rrBmsCVCmK82iUpdw4JW6W/qTIMZQIbnklk0IFWYpL5JOx4hLSXYih6ztxf7vtlMTEdjCtovnXWT84Gb6YmxF6jua1NWaNA7VmbLjaIt8WV2sEkyxB8NKzTNN2NjqJ/DCnytD9iGwSgxdXGuoswoxQIrWwVqe5PlLdBC9c/G2D4ysdjeXRVbnDATFKdtasA52rbcgDQBjGhYuIB+FOgvPdSa9Op552QeRtx9fN1SgK+ogNmHaiRs8LQUi+EX5jx9+Ox2P0MNXAhZCHP6UojfQWD8Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SJ0PR11MB5070.namprd11.prod.outlook.com (2603:10b6:a03:2d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 07:16:53 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 07:16:53 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v10 1/6] x86/sgx: Convert sgx_(vepc_)open to
 __sgx_(vepc_)open
Thread-Topic: [PATCH v10 1/6] x86/sgx: Convert sgx_(vepc_)open to
 __sgx_(vepc_)open
Thread-Index: AQHcAtctORSmd2ej2kKRcI3BKXQ4JLROAMiAgAQYspA=
Date: Mon, 4 Aug 2025 07:16:53 +0000
Message-ID: <DM8PR11MB57502860D432C3304C05D589E723A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250801112619.1117549-1-elena.reshetova@intel.com>
 <20250801112619.1117549-2-elena.reshetova@intel.com>
 <1a216d75-4411-4aa6-ae29-c7815eec248f@intel.com>
In-Reply-To: <1a216d75-4411-4aa6-ae29-c7815eec248f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SJ0PR11MB5070:EE_
x-ms-office365-filtering-correlation-id: af4da057-0381-4c7f-d6c1-08ddd326e368
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eVdXbFdmZHZ5bkNLQk8zcCtCbVlPaUdNMEd2WEkzelFRMTNLYVpUemJ0ekNN?=
 =?utf-8?B?TzFEWk04RmhGREVzSm1QQkd1UmR4K24rQy9pTUJEREV4QkwySkdmY0hmZmlh?=
 =?utf-8?B?UGw1L0s1MUhveGJNV0EzaG9SOTZNWW9jUkRTQ1ZiMGFJcDBxVXR6Q2QxVjVi?=
 =?utf-8?B?aVNkTTI3aDJ6WkJoOXRoYzFZM2c0NTcybmtvb0pHMkhoRE5jMlFPYSs5R3Zq?=
 =?utf-8?B?eTBMbk1Gdm1QR3l1cy9rdDVZRmVGRUwvSzYrVVNGd1pQTjNXb0kwUzNKZHR6?=
 =?utf-8?B?TmZROCt6T1k4ai8zS1FkbEUrcXVOL05IekFkVGN0R0M4MDVGdy9KTmMrV0hH?=
 =?utf-8?B?UWRQRmozNUFPeFhPOFNaOG1DSk5zWEw2UHdiSFZuYnBRQWxLRzdNbmswNG50?=
 =?utf-8?B?dXJNeXBPeEQwZmhGZ2czZjRIM3BEYTNIT2JCTmJMakR4dFptd0lmekxRWEdG?=
 =?utf-8?B?NFVmQ1gxMTBuanJqOTVwdUhpeHpXNWJQZGRGVWJKWWhSeDYxaVpBV2FISEc0?=
 =?utf-8?B?YU1VSVJOR2RYMmlIOEIvQkRzdEVFQnZ2SXdaUnNoSU9zVVJ5NjV3ckdxYmFn?=
 =?utf-8?B?OFd4a0toOWdreFBJc20rWjdQTE53Q2VhRktnWFdCMjVWcVRScFJ3TGR0WmhX?=
 =?utf-8?B?Q2tqVkdPTllaUldvY01BK2xrUXFqcjJJZHNsYy9ZSXNGYjdzRy92NEhKV1lM?=
 =?utf-8?B?WXFoS0hhRW9HNG9qVUVmNy95NEd5QWpKTTFnSTVWb21iNDhxRHlNamtrZlVN?=
 =?utf-8?B?RmdWMGYvby9IMGxyY0R2SDg0cVhldCtKK2Zhd2hqMTVTL2RzekhSQm9iTk1z?=
 =?utf-8?B?c0tkY0tiQ0ZiTTVteTVhNXRjOThPRnZVWWZsZ21wKys2MGRCYkhZS25NTjkr?=
 =?utf-8?B?VFJQcDFxdTIzbE5PZlhJZEtJSVRsdVZCTVExc3FwR1NUMnBVZXRDWW0wcmJW?=
 =?utf-8?B?ZHVodTBwaGUyeUZpZlJ6WkNNclpHWlVwR2wwR2xSWjdHZmpyNGwraVpFVkh3?=
 =?utf-8?B?Ly9DcXYremlpU0x4emwvc2N2bCtLSjFGdTJUemlmT2ZJU0xCWEgyeUlkUFVL?=
 =?utf-8?B?ZE5aQ2FsekYybk0zQ2JFcTBhOWhGcFdabS9FbnVETXBWcEpQVVdyck9KS2VL?=
 =?utf-8?B?VTBpSEhZMW8rQkk4b1VQdFN3S2k5NXAzMWJvZVB0Wi96S1RNc0FZeGxEUEJM?=
 =?utf-8?B?L0RCd0RHRytuYjUxdk5ZQ0RtZE1hRTlQK0ZkalhzWEc0bnNyQlR2OWZoblBC?=
 =?utf-8?B?VGdaWDdSMWUwdDg0QmdtY1VDdW4xSnpKKzV5dmt6ejd4cGdnMFV2c2dUT3Q3?=
 =?utf-8?B?dnlBc2JKa08xV0RUZS9OSzZWaWVnNStmN1dkVERnNUkrRVhNcU5NMThJT2tZ?=
 =?utf-8?B?cENiQUxRVHpCTy9YSDlHUStSbWZFZm1lc2k5bVZ6ZVhOZ3FzdDlYK0huV25j?=
 =?utf-8?B?b0ZzakMrL3J6ZW1NMHBpK1hwek1oWGhkSWoxcloyTVBDN2NJNUFBYkV2K0tR?=
 =?utf-8?B?Ylp6OURqbW04c2thK1VSYnFSZnpGdHVSVzFjZlJLVmZEMDdJZ0dQdHpXN0pY?=
 =?utf-8?B?Z2J2TUxPMEhMNkFFN3c2NVBZbE1QeG1UWGdhVWtmS2xOUWhXMjM1TXBiMGtX?=
 =?utf-8?B?Q2k4RXJLMm5KM2tyM1hOWGpXd1ZHd2NkWE51UGJhdWNmWFI5dGU3eHlWZUI5?=
 =?utf-8?B?UzJFdGREeG9JWllWVjRnUHdqQkxtUFpWTHZqR0pNVDFQOVB0d3dSMEpIbUYw?=
 =?utf-8?B?RUd2NElHMStreE5xcThJd3NqWFVGSmN4WjhuWUNVdjVNSXpTVmF3N014Mmtv?=
 =?utf-8?B?bWFQaCtYUFlpVWFMMU10MzVBSkFSbnJieXBrTEtiakFCRHA3ZUlVcDBLdGpr?=
 =?utf-8?B?aGdiWFAxbUNCakF4ZEYyS254TlJqQ3d5WmhWYVZJV2NPU3RKeHYvdzQ2bHRm?=
 =?utf-8?B?ditLZXhlZzNxVmx3QzBobEdKMDEreXY3WmhjNFFCd2Yyc0d5R05oMVN5TVZp?=
 =?utf-8?Q?wrrHCGevIBLJbwRNzUWS8VGHK8ZXZU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnIrVTZKVEYzbldiNHF2RnkxRllxTUZFNi9FSGVRbUVGZ0oraGhlaVFGL1lm?=
 =?utf-8?B?TVNkT2ZvMDg4SzNMYWFDVFp0b1hFbHY1SHU3dlVmdDdDd2hBV1BVUzhVYXZ6?=
 =?utf-8?B?VlhpYlhNU0RrNnF3c0pBQTBQL283VjJlOFM2dVJZMEZpZVp0UEhseHlqUDZC?=
 =?utf-8?B?a3lmSXFCSmdwb1YxbC9VMng3Q3BONHV0bUl2bDhKbHF2S2Zva011d053cy9p?=
 =?utf-8?B?NVRDVnZDdXpDMDBtQmtsa1NpY2VsNmtXVHNvdmp1bmVad2xqMnFXRnRQTW5V?=
 =?utf-8?B?UCtiZWQycGJCeUVSK0l1RXBMUXVyUDBhVkhDdFpPc3lRUjdVTmR1UUtlWVly?=
 =?utf-8?B?YWJ4TkQzNUdySVQ2SHdTTWlZdFFwZjJoSkllVU4wL0NjZzl4Z2ZLYUF4V1dV?=
 =?utf-8?B?b001bU5SaWVlUkoxZXhTQXk4WDh6dUo4T2FQdDNIcEZQcFhBSUpqbnd3OXFZ?=
 =?utf-8?B?N0dtWFpyZkk0ajFKckRxNGM2VzByaGRSLzdMa2VMbmFZeCtMb3lxVEw3cGR5?=
 =?utf-8?B?ekJiNDVxVGd2c0RjTFJFRFIrQlRoOHh6Uk5EaTVidUhqQ2JHZWYxTEhqak1p?=
 =?utf-8?B?K0dzOWtra0luN016c0tPc3Izbk5qTldaVzZhUldhNzh6TklyVFRETWVqYnl4?=
 =?utf-8?B?NXNzQlVBU3d3RHZ0TnovdlMrY0tOenk1cFdUNCthYjBrOFVjUU1Na0crd1Jr?=
 =?utf-8?B?NGJZUGlvUlIrWHFyTlNpd2N6akVzRlFxRWp5b3dRQVpZNmJOcHpDZk1LaU5x?=
 =?utf-8?B?NCtycGxsZ1hld0w2Q0kyNFZWU0NXalNkT3VubnZEUWVTK00zYm1taDBXTndI?=
 =?utf-8?B?TkY1V3NmUy9qM0NYbkxsbjlpaHpZYTFCY0drVlN3bE5wUy9JL01IZHA5Q284?=
 =?utf-8?B?RFFHVy90bWNEeERwWno2K3IyM05jN28zQ2pwZzI5clpTT0ZyS0FpZFJEWWlj?=
 =?utf-8?B?ZXBGL2IyQWs0OTBwaDhkUlJFRDJZYWR5UXBZZGgyRDJ5MW81ajQyNlBMRk00?=
 =?utf-8?B?WlpXWndURzRScVNoSGlpcGNUZGJad3dYcm9aOXNhcFRwTHJNVExSUmM3MmtU?=
 =?utf-8?B?ZWw5dm9VWUEzdEFMN1c1TlZYMzZnMmxyWkFVdmZ3OHp6TXEwcS8xMW9rb1Ux?=
 =?utf-8?B?cVNiZVBYUzFqT2d3QlVZbjNOdUp5ak1lUjdrWnB3WWhBMVp3K25XRm8yaTZw?=
 =?utf-8?B?VGduRjZtSGJtUnFmS2dkWmJCZlFXLzZjZUZ0a2F0czZVRFdqZDNTV3V4VlRR?=
 =?utf-8?B?YThLSkIrTkxMVXBiR3p6Z2N2ZnR0OENBK0FRMWYrUXhMZEsvc3M5cDkvMk5z?=
 =?utf-8?B?VVRYUVBqRkxoUHFiMUp5Mm5vQXAvWi9HVDBVUFUxemZqT0VSQ3JSb1FOQ3lN?=
 =?utf-8?B?bTFvRlJqOW1VaUFhZklFYys3aWNBNHRNaVhEUlNEVnNqQWlLREdOSjJOZ0hq?=
 =?utf-8?B?NzErdmNuWVlESVJObkFBRlViS0N3cjExY2E0Q0NWK0pSQ1NLZGpoejNQK1Jx?=
 =?utf-8?B?R2ZueXQxRy9QeUFTbUd6YVFFZFo0czRCWHlCVStCZzkxMlRKM2MzQnMzOGs3?=
 =?utf-8?B?TEkyMExGQi9nbDhQRFBUM0FMUVFkOUVINzg0MkJiZUxvT3h3QW14a28xaE1C?=
 =?utf-8?B?RWlBUFBEK3ZDbGV5OGh6OTNWVldjV1BSNTJ3OGF5ZUNxSUE3Ym9peDh5RGFO?=
 =?utf-8?B?T3IvMHU2NkgvQitYU3J0Uy9FbXBqbEQwQjRkSWQrSElXL1R4Nm5YQ3BSeHd4?=
 =?utf-8?B?eXFsWFBoaUVNS1lHRlEwTHFyRnB2bEdQbFlXQlpoK1cxUjNld0F1TWtUbWtx?=
 =?utf-8?B?UWFmZEk0QVIzNG5JZHBtVHpUQkl1cXFrb2lKYkI3d2ZhZjd4MWhHenBsSDJp?=
 =?utf-8?B?MmlrdG9oaUt3Sk85M1lWaGxzYUpxYnl1L3hLL2ZnUXFrdUgwRU5lQjFYQzQ4?=
 =?utf-8?B?NWlxZnVsUS9LOUxDNWtwTE9SdmpuMGZrZTg2YWRPeSs1L3J0alg2U01VSkxN?=
 =?utf-8?B?VnVxK0dhNEl5Y3AzU0hGWHFaeFRhbStVZjJJb2ZrYnlxSWlWNmtnTWdNbmp2?=
 =?utf-8?B?cVYwaklmY2Ruc09hbkNwV2pOTHcyS1JuVTd4RTZXVlVMN2pteVE2OHFTbkxR?=
 =?utf-8?B?M2JmeTBybkdBRFhsWDh0bW1WWDIxR0RaVjdDc2NnNGp5aE5jL1ZKMW95VzF5?=
 =?utf-8?B?Smc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5750.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af4da057-0381-4c7f-d6c1-08ddd326e368
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2025 07:16:53.3646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lMwkApOt2iEwpWzrfE9y2toe4X0Kq31Rq5G938FlcYa/GwNJ8WyvKXlj8zPFYTP3LjCnCNEWxAErjiG6eeCPvr/EaSPSCJXXLiG024ktEEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5070
X-OriginatorOrg: intel.com

IA0KPiBPbiA4LzEvMjUgMDQ6MjUsIEVsZW5hIFJlc2hldG92YSB3cm90ZToNCj4gPiBJbiBvcmRl
ciB0byBpbnRyb2R1Y2UgdGhlIGNvdW50aW5nIG9mIGFjdGl2ZSBzZ3ggdXNlcnMgb24gdG9wDQo+
ID4gb2YgY2xlYW4gZnVuY3Rpb25zIHRoYXQgYWxsb2NhdGUgdmVwYyBzdHJ1Y3R1cmVzLCBjb3Zl
cnQgZXhpc3RpbmcNCj4gPiBzZ3hfKHZlcGNfKW9wZW4gdG8gX19zZ3hfKHZlcGNfKW9wZW4uIExh
dGVyIHBhdGNoIHdpbGwgaW50cm9kdWNlIHRoZQ0KPiA+IHRvcCBsZXZlbCB3cmFwcGVycyB0aGF0
IG1hbmFnZSB0aGUgdXNhZ2UgY291bnQuDQo+ID4NCj4gPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBp
bnRlbmRlZCBpbiB0aGlzIHBhdGNoLg0KPiANCj4gSSdtIG5vdCBmb2xsb3dpbmcgYXQgYWxsIHdo
eSB0aGlzIHBhdGNoIGlzIG5lZWRlZC4gSXQgbG9va3MgbGlrZSBwdXJlDQo+IHVubmVlZGVkIGNo
dXJuIHRvIG1lLg0KDQpJIGFtIGhhcHB5IHRvIG1lcmdlIHRoaXMgaW50byBwYXRjaCAyIGlmIHRo
ZXJlIGFyZSBubyBvYmplY3Rpb25zLiANCkphcmtrbyBvcmlnaW5hbGx5IHdhbnRlZCB0aGVzZSB0
d28gcGF0Y2hlcyBzZXBhcmF0ZWQgZm9yIGNsYXJpdHksIHNvDQpJIGZvbGxvd2VkIGhpcyBzdWdn
ZXN0aW9uLiANCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuDQo=
