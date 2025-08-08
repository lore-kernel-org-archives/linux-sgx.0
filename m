Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD3921D3EE;
	Fri,  8 Aug 2025 10:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754650122; cv=fail; b=chTtQywwbhVRYnesvyS4Z4N+03GbcPa43UgngynWI2gW07hUVRx+jwR35EX0jZa5/6Jbm94Ez8zv33uIjzxeBsFrV+bh/IAC4kJnmbVVuZvxOBukf+AugIGp9PLEk9S64Ds3gHiuPBZM6IAWsxM/tL6wSGIekQ+b7pi36Ch5vhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754650122; c=relaxed/simple;
	bh=vMGBCxuzo0NSFmfCI72UwMc8VaJAu75gHs72GoMQX8k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=egcF/ATPjskd8fh5lf5do4QOVjFchZrJh/TMLMXFRRZG7pifxq28wZ0070QkkVzZheDtes5lExC2tZeO1I5iUrIagIJ0dQwbzpbnVNK7R8rCyfJVF2o6UdNBO9FEBM+U/OIxe64lHDmxsbiP2QZ6MKOBgTlieBuDsRE+MI4jrXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ff94vgPh; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ff94vgPh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754650122; x=1786186122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vMGBCxuzo0NSFmfCI72UwMc8VaJAu75gHs72GoMQX8k=;
  b=ff94vgPhtsxEz3U0UduL8bKjMeYzwbe/F9x7eT2D9ona1F4JlZcW/GJu
   E/me2dfVeaTqyhxBZJnCDdvJnfkynUXSVM/ZJ5JUcKzsU+UKP29FXV0WC
   l9KFzgDr6j5p7ODTg7R+LWOF20ssfEOpKShK9A0FGfF1akqyeZGpMJSjb
   vW5Sfxa+n0kL3Kd88ioc2XQxmJFlv6XQIdnJfaxyu1Amr6g1ihY5OaX1W
   bj3mAm9Fr+Kiz/W++vuvLISGzWXYPLfm6QGK5y1bQ3yQIwekH8c7s3PEM
   DIy3AoBu58Iw/j6p8AQchNAJZUQQ4mlHPaDb7gEglaoOGoigi6oUpejLA
   A==;
X-CSE-ConnectionGUID: rK6dGxtgQcSGATIO92vNcQ==
X-CSE-MsgGUID: gn2A69wVSyeguQVI0JiwMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="79555206"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="79555206"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 03:48:34 -0700
X-CSE-ConnectionGUID: CDj8hotcR7Om6p7CqavwWQ==
X-CSE-MsgGUID: Hveh6eLzTXWgb5MGvy54zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="202473371"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 03:48:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 03:48:32 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 8 Aug 2025 03:48:32 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.48)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 8 Aug 2025 03:48:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pp1EU8tsD+w9lNHdi6bC79SYqdT3B/JdFyFwUXmULuzdNjRI7MbwIL790VMQ32bZICwOiAgVlCK0j80GjGm0JZKa9aP5IxU5m7BkKziFR/yOJgfa0b9P45LLRBW71DgiYQoLKTfFJkrhQslb2vlrm44LCTSua13w/pmvnPkHjh/9LUeqvBGK1j/eQqDst8WORiBgPf61XKAeAgujOJkRBFBbWEl1Jn4zEORtK6VjhlVurmRpZTcJF0mJk4z1ROl0DcrX5Ul9Svrj9UTlfDUSPSV2s3Txi7hO4hdCoXZlPvR2d2bky2f60evNsmn9DRZJjqEwxr+d3/dh6DqTU4g1VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vMGBCxuzo0NSFmfCI72UwMc8VaJAu75gHs72GoMQX8k=;
 b=SjU3Nx44zFibX5sCsGVMXnhyrFInBHITeyaER+sApKZxssRset6KqqIHB9C45skmttMS/OOsEZbAJQ2k7J3ZhQQvzFrE8OtwuUFM7s4Z38oA4/0fs10RPico0Iwqw6g+Q7EzNSqYnhSnTlbwVytWWm0MPE4+0qdmpiokoas2DDtpHw4tPAjDMkIQwLUW54i4gpSoFfEEcPvShhbYSoLBwfx2VUKkXY37fE/brL3ULtjiMfjQ3opN4+Ce4qTAKgVJiWalY790Z66yD7k0fSiIgRbuPHu/lfzgKuXC+CO8KIlnKyByRdL14FqmuD7bjmEsMxrivebNcDpLlSGEXsIQ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH0PR11MB5901.namprd11.prod.outlook.com (2603:10b6:510:143::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Fri, 8 Aug
 2025 10:48:29 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 10:48:29 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v11 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Topic: [PATCH v11 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Index: AQHcBqohH25tWnGnRk+tT83jfhlEVrRWSX6AgAJNBAA=
Date: Fri, 8 Aug 2025 10:48:29 +0000
Message-ID: <DM8PR11MB575048DAAEED9EE057A703CEE72FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-3-elena.reshetova@intel.com>
 <eb6d3e9425f9e6d588a7528c579fc32606db319c.camel@intel.com>
In-Reply-To: <eb6d3e9425f9e6d588a7528c579fc32606db319c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH0PR11MB5901:EE_
x-ms-office365-filtering-correlation-id: c2c06b89-77ce-4d3e-c662-08ddd6691c9f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QWRWN2hiaGdrcGRwNDlrRHZIaU1wOWloeWFiaS9XVGZUM0YrSlZsd1ZoOTd6?=
 =?utf-8?B?SDZoK3dVakE1WTladGdnVVNqR2NkNGVwV0t6elhyRjdGSlJZdnE2U0E4bjR5?=
 =?utf-8?B?ZmsrZ3Zib2pWTFJibDVtRUJXV3lqWkwvRzJwY000SFNzOFlFdldUbHRZdTZJ?=
 =?utf-8?B?MXQrTG13YnZJTE9rZUdFZ2p5VjltSi9QcnRydkJkcXh5Nm03MllWOXlFN01s?=
 =?utf-8?B?S09ieVhjZ2h2L0JGSFhtSmlIMWVaRmZCWXpiZDdkR2pRLzBvSnpJaVJMcGdC?=
 =?utf-8?B?TjFIc29WQVNJb1kvZkw4dWRrY1lhcVVrb3VkZHJDcDhoVXRyMU0rSTRiYk1B?=
 =?utf-8?B?bkovSXlldisydS9pZFdlbVZCUHhzZFRVVVMvd1R5MDQrdWFVYmp4WXFSdng1?=
 =?utf-8?B?VzhtT1NJRE1XaGZVdWxENU9jaDRGcTAyOFlkTERGTEhtYmlsRXhmRlAzOFkw?=
 =?utf-8?B?ZG9TTjZmekVBelplblZNY1IxaWJ4a0pYMUZTZUhCN3dtSHVWSnZqR1grTWFZ?=
 =?utf-8?B?NEhjNXplbE5QY0hwZE9EdWhyUlprR3h1NmVtU05lYkVZSXJGeGQ5eFlOSUll?=
 =?utf-8?B?bUs3OWxqRGdxeC9vUlhrdjNGMlRtTUFEYTY0NHNuMFVXc3BZcGVnaVZaZWtM?=
 =?utf-8?B?T05SZVFqRHl1Tlkwbzg1Y0JQKzJjbGVkazg2K3lFcUlUS3B4b0krUkhHRmJO?=
 =?utf-8?B?Z1ZyWlVOT29FM3J4c3ZKdkl4bjhvYkRWdU55MWYzQm9sSjFtRGw4a01pcmdj?=
 =?utf-8?B?OEhVeGozWktmMmZKaG93VC9MNm5zN2lPMFJsajBuUzNyT2c3RUxBK01hSWNM?=
 =?utf-8?B?cEFxc0NYYS90OEpjNDUyTFY0SWpPRnFsRHN6eGVHZEpRNG5IcEdNTjFsSmxp?=
 =?utf-8?B?N2NLd2xqZGJ1RHBQZ00vc3h1MFo5VHZCRHQrN0xlRGx3UG1uZ3IyWG9KMDVu?=
 =?utf-8?B?aXFQaXZva1g4aGRuUFN0RE1wMUVTYXk4ZzUzZ1RzanIxYmZ0TXJNUVlPRmV2?=
 =?utf-8?B?Rkw0OWc4akZ0NndlWXJPVWkyRkp0L2RsemJXak4yZUc2eW5mQm8zNWFqdTdt?=
 =?utf-8?B?ajV5UC81eHpqQk4zSCtISGpmM0ZhbElzZkdsT1hwMUJ6ZUVVMVFldW1GS2p3?=
 =?utf-8?B?ODRrLzI1RVdLYzV1cElQS3dHejI2aGJqdlFza3JTbUFNZC8yZDJXbkc1K0po?=
 =?utf-8?B?TlNFSi84amh2VVhoVlh6Wml0VUEyVW9WUHI1cmlYTzBaVGRUM1VROVl0eVdn?=
 =?utf-8?B?dk9vS2Y2bXNuRlNqN2RuTkg5SzdhTkNESzFFR1N1TmtvTGtlZWRRdHBEMDEy?=
 =?utf-8?B?Q0RkOWkxYkZGUkN6RVkzMXFLejAwV2ppbzFpT0xJbFhEWk81MVlyUnVFeEhz?=
 =?utf-8?B?YUpKemJkV2FRZjZhSkRtNFVpRnFQZnhWaUE4by9xQXBqem1obWlBQ0xvOVZa?=
 =?utf-8?B?RGxVUEJUWEdYbHF2YjY1WUMxbHJsdk1WZXJYZ052bkh6U3d6MzR0VDBtUE1s?=
 =?utf-8?B?RzViV3N6am5iVFpsQzNCR1hBNDhvL1kwYjFkeHkvQUVsY0lPTUJNdjlHK1hT?=
 =?utf-8?B?OEEvUDBiUmt1L2hYNW9PMEZTcnVqMlRsVVRvWXRJd2NrQ3Z4dTQ4M3V4N0cy?=
 =?utf-8?B?UGV0SVh0NnhONi9uVkcyc3JhWDZYQTZiZFhLcDNyNzZYc3pTNWlNK0pGT3hL?=
 =?utf-8?B?WXVUZ2RsUW9RaS9GTzEzV3hqZFZuWHE0a01YWTVzRy9PcEtuMURJdlBzU3ZH?=
 =?utf-8?B?SzRhZXh6RENKWVJKam02MS94d0NkcS9ZSjFrVTNoL0U3YnVGMEFmc1VFZ0xR?=
 =?utf-8?B?T1dZV3RzNUNaWDRmRllxU1BsMG1FbVNvdG1pU2RFQkVGUHNKd01rWUx6SUE3?=
 =?utf-8?B?MVlVMStTQnZSMEFXY0ZOT29aRGlOVkx6TFlpZUg0YlJJREJpeFFUVER5OUxZ?=
 =?utf-8?B?ZE9JZHdHK3pKLzNjSDF2VldCeGIyMStmNzVMa2RoLy9mbkNHMERpNzNDQVJw?=
 =?utf-8?B?WVNnS1dpTGlRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0hvc01RU3FkdEVWN2NKTVJ0M1Q3VWVXL29MQi9FRzN6SXpnQkdKdWwyKzM3?=
 =?utf-8?B?VmRJYmlWSE9xSmhBbWVwZndONzJZTHViWWtsMTM3L0ZuWnZMdTNuM1ljN1k5?=
 =?utf-8?B?b1NlQTg4WjNRenRsQ21XektGb1BFUmV5TENMYlgyS1J1aG9vWDhXTFU5RXhr?=
 =?utf-8?B?WUNJLzhvVHB2UWdDVjh1b04ySWNRTnRoVTc2VWMzTk1YUDFNQmRBbGRkOS8y?=
 =?utf-8?B?TlMzYWR3amlVMUw3WlFML1ZYWHcwK1dvSEN6elU1ZkM5ZDFLb200MjZoKzdK?=
 =?utf-8?B?TFk5dm9vczBlWE9UVmIycExwNXFha3VDTTQ5SVdLQy9MR2dNZ2NrdHlvM09l?=
 =?utf-8?B?ci8wWlZ3WWNzLzBCZTk3YnkvZ05Ucm8zcHFwQ2E3M1ZXd1BLMzZ0UjhGSjRr?=
 =?utf-8?B?UkRQdjZ5R1ZxandkU2dYMWNTUEI5TStxVmducEgzN210bjNzZVhRb0c0dnpo?=
 =?utf-8?B?bnJKekJYd1lZSUdZSU0xeU9IWTFIaGhuVFBXTElDZk5laDJmN0xaLzhHbSsx?=
 =?utf-8?B?SFJ4S1YrOUYyTjRnOVlGTFRvMDMrY0ZNN2xWY3ZMTjFSMFM2bC9tNm1ZeVpr?=
 =?utf-8?B?VUd3RHZmS1NhdjJkdTltMWlJOFBMbmZQcVJSZFJZenhxaFVMUTJUMVI0Y2xZ?=
 =?utf-8?B?cnZtYjJzTmNTU2RSbHZXSzB5RGpia2JjMUd1blh3NmlGbVArSXVvdVNpYnVp?=
 =?utf-8?B?NEhuWXFUZ3lIZFJya0Jjd0poMTVjQm1DVTBqNU5TMWZDeFI0ZVhyQjd5SmVE?=
 =?utf-8?B?anV2a0pBb3hSSlR6SVVVVVdIa2syZW04N1ZHZ1JFU3RpRk95YjhlNHViZTlC?=
 =?utf-8?B?RWhpVGx5RHNuQ3l1THlnbE1pdXVzMDZkZExBSlRLRml3Z2RJK0U2VXUzVGFI?=
 =?utf-8?B?S3A4SDF6MFh4alV6MGF6ajV0WFpKcTV1dzJjcERUZ2JYb2VRYVNtcGZFbUhw?=
 =?utf-8?B?c2RKZEtsUTBIYVBYTExlcHBuNFBueDE4bVlQbzNUbE9hVlFwNlhOVDZ6NzhR?=
 =?utf-8?B?Z3c1MEpwQVZaRjNuTlhLVmRmNGVlSVZjbDNCWVczaUsxcUxMSTJ2L2pLbmc3?=
 =?utf-8?B?czg0c2hRVFdTdWNLMnEwMVFaVmFsWG5Ba0MzWW1ISU5sS1hOK0E5Z2d2dUNZ?=
 =?utf-8?B?TllNbEFSejlaTGk2RXUzR2ZkRkJWMU51enRqVUtDOVc2WnVtMUtmTXMwNDdC?=
 =?utf-8?B?eUV6TEVCQ2tMZUY4UFRmZnl1aEdVZ1pyM21aRk5jWTVSS3BVQ2RDRXdTL2tB?=
 =?utf-8?B?RGkrNk9jejhLVVVYeGJldjlpMkcvTzA2TFduK0dIZ3lXaWNBRDgrWFdjVEJT?=
 =?utf-8?B?V1hUMHBZVEpja3BEV2crQ1pWcHNGWkI3Mm1TWmVvRWNOOUlmc2pkN0ppSWk0?=
 =?utf-8?B?bVBDY2dPUHFVcmE3MkRjTTNaT1d5c0k4SzZTRkdmUnBBTm02b0NWSFFiakl3?=
 =?utf-8?B?NWYwNW14akRaU3A0L0ZFOFIrelkwVEZzd29DejhBcENUUndnY2dxZzl2bTAv?=
 =?utf-8?B?QjF4UmdTZnozeThUc1BMeUpnMDRJRXgrc0dhc2xkZUVnUjJDcm5raVgxazVE?=
 =?utf-8?B?clJ5M2dHeUZ6WFJlMlcvMWhXenFEVWdhV1JGWlFtODkwNE1SL25SKy9rTG5z?=
 =?utf-8?B?ZEpYODQvVVpXTTZFbjZiMGlaVGhvMnJkS3dBZCtNeVpKSXdNYnhORlZsTUdP?=
 =?utf-8?B?UWJMUTExaDlXY1hMTmFQL1Y4ejNYT1V2VXpZcm04MEdvWCtNNXNXYk5JRVVm?=
 =?utf-8?B?SVBCZHpsZEhVOUlxRzdON1ZPanpZT2syRXVVWGcvRFpjZXhpajRwOFkrTGVs?=
 =?utf-8?B?TjhFeG0za0RjejNwT3FMS3dVQ0xacjYwTWpQblZyZDVGbVZJbmJyUm1wWHVU?=
 =?utf-8?B?YmhPZjhUdlNUeTd6cGlGTjFtM201dytYWDY0Q1oySEFheU9GOURxdW1FRktz?=
 =?utf-8?B?NEd6MGN3K1BOOVl6aDFoMXhQTFhXWDdMY1BVcmhpeEdzWkFDZURFOGlCUkFs?=
 =?utf-8?B?ZEFEQXN3Qk1CWlU2eXNxcVV4aUZjVlFlaHY3Y1JwSzJ0WXdrTWFEaXdYeUNs?=
 =?utf-8?B?QXZhYlZwQjZFcmNiMDg5SFFRUFFoZlRkUEplSlcyM3ZnMW9FVDE4YnpocUNV?=
 =?utf-8?B?OU5LNEpZMFhWL0VJVlFKQXdUVEs3NkJiQ05ycGdwekNPNWw2RGRYY3J6UDFs?=
 =?utf-8?Q?TpkBuR1FPp3DJx3cm6nXuvjJMhorfrFlV3LQTG6MfvbM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c06b89-77ce-4d3e-c662-08ddd6691c9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 10:48:29.6398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hqXXFbhwd6IQGwGb6jvs3gh0PNzNdOdMuQ/lItng0O7CDeF/GesMCFDAmKpz8qBhOcjEBX3qlL0ODPvTc+E88RWmZhWsbLg2+EVR8obtznM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5901
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDcsIDIwMjUgMjo0MCBBTQ0K
PiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT47IEhhbnNl
biwgRGF2ZQ0KPiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPg0KPiBDYzogc2VhbmpjQGdvb2dsZS5j
b207IG1pbmdvQGtlcm5lbC5vcmc7IFNjYXJsYXRhLCBWaW5jZW50IFINCj4gPHZpbmNlbnQuci5z
Y2FybGF0YUBpbnRlbC5jb20+OyB4ODZAa2VybmVsLm9yZzsgamFya2tvQGtlcm5lbC5vcmc7DQo+
IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOw0KPiBNYWxsaWNrLCBBc2l0IEsgPGFzaXQuay5tYWxsaWNrQGludGVs
LmNvbT47IEFrdGFzLCBFcmRlbQ0KPiA8ZXJkZW1ha3Rhc0Bnb29nbGUuY29tPjsgQ2FpLCBDaG9u
ZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBCb25kYXJldnNrYSwNCj4gTmF0YWxpaWEgPGJvbmRhcm5A
Z29vZ2xlLmNvbT47IGxpbnV4LXNneEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRhdmUuaGFuc2VuQGxp
bnV4LmludGVsLmNvbTsgUmF5bm9yLCBTY290dCA8c2NvdHQucmF5bm9yQGludGVsLmNvbT4NCj4g
U3ViamVjdDogUmU6IFtQQVRDSCB2MTEgMi81XSB4ODYvY3B1ZmVhdHVyZXM6IEFkZA0KPiBYODZf
RkVBVFVSRV9TR1hfRVVQREFURVNWTiBmZWF0dXJlIGZsYWcNCj4gDQo+IE9uIFdlZCwgMjAyNS0w
OC0wNiBhdCAxMToxMSArMDMwMCwgRWxlbmEgUmVzaGV0b3ZhIHdyb3RlOg0KPiA+IEFkZCBhIGZs
YWcgaW5kaWNhdGluZyB3aGVuZXZlciBFTkNMU1tFVVBEQVRFU1ZOXSBTR1ggaW5zdHJ1Y3Rpb24N
Cj4gPiBpcyBzdXBwb3J0ZWQuIFRoaXMgd2lsbCBiZSB1c2VkIGJ5IFNHWCBkcml2ZXIgdG8gcGVy
Zm9ybSBDUFUNCj4gPiBTVk4gdXBkYXRlcy4NCj4gDQo+IFlvdSBtYXkgbmVlZCB0byBwYXkgYXR0
ZW50aW9uIHRvIHRleHQgd3JhcCwgYW55d2F5IC4uLg0KDQpZZXMsIHdpbGwgZml4IGluIGFsbCBw
YXRjaGVzIG5leHQuIA0KDQo+ID4NCj4gPiBSZXZpZXdlZC1ieTogRGF2ZSBIYW5zZW4gPGRhdmUu
aGFuc2VuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBFbGVuYSBSZXNoZXRv
dmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTogS2FpIEh1
YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiANCg0KVGhhbmsgeW91IQ0K
