Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEE321D3D3;
	Mon, 19 May 2025 22:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747694061; cv=fail; b=f1Vv2pTvaHb75AZxTo59J+iZCtJ5Lt0Fp9Ko8GXvz2zdcE83YqA56POkblqcju1z4zkq60JmoNGUaQpiANQjDPy2j8lpk1sFWUA3kNB5tXo4MQtk+w8BkxZT9r/j7um8H4XTdlGVspmS9FZFMJufP4reQVwhEUrpXFvXNTzCA8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747694061; c=relaxed/simple;
	bh=AHhFmmkMxuGElAUhPk2Lv037ZGskuKsRj6snOnshjK4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BEho+Hoaanc7yk80NFD2pHht6KfydxTsSbD5b0ISgECmCpluLjxC86cvIeu3OefGtRNCIn1hS30CnwiLKekhofg7ZRobfSz0wPsx6cUCK1Q2vr/9pS6mm/IA1m0dfC2rhQVZja228KuYbl52DP1bnXgdNwSbrDf7GRN8UzXMOF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GtqMxwle; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GtqMxwle"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747694060; x=1779230060;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AHhFmmkMxuGElAUhPk2Lv037ZGskuKsRj6snOnshjK4=;
  b=GtqMxwle6Bfm8AiIrWZh8fwlJqDT/aA/dSosfVN+XGyTvdUc67RMxY3w
   O2cBWhZ3aTvgC1xlQ8u0gwc+gyoCvr8JEKB3/zzFAaBm5WB/SNMxpeA7c
   wup0AG+lDrp5yXqGFN3BdU4dIyGAaRmlzaNwt62J66kiSpRgOHZBqZQ93
   wiJpMaRuOQgUeu6aBqowB9L3KjzC0wT24KtH1HYxBeckIYvdRzWuvk4wI
   MpjMgot/xbVSxPIvJqGlfeMo0jQPvJ8I92EfKvqpV3YBdX3JYaygeyJIV
   dkFpzGN+AZepiFI34pTJ/mbUhNVtGWaiCaPDvAAGOfn020PRa7Jiv0KRt
   w==;
X-CSE-ConnectionGUID: IzuUIKRWQXCTalade7l1WA==
X-CSE-MsgGUID: yELzgNf1TGisiPcsINZLSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49485647"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49485647"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 15:34:19 -0700
X-CSE-ConnectionGUID: BckjvsvOS12WvzFEFLuLaA==
X-CSE-MsgGUID: xFINnpdEQJqoeGy9ix8DHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="139336256"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 15:34:18 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 15:34:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 15:34:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 15:34:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zLRkm8VNE2viWMZYB5IHRCtcQb7jspK4k0pGDN38yNCHbiPmAzVMqLRWLGn33zwCdQCo11AVIblsuKUFH3q9EvRJcnVuMj0kwxAVaJkKxQ0jiU2VlX38+Oldw1ao4ke5leVRj1uhEnpOjDlgFOlBIN93UTOMav2alcpFTTWlgMXwGtmghB28KhCvzuOHtkpnXLEOZCds4sbtcah7Gg4nNxz0uARdEPegyNEQdX1os52XsVSVBjTM5Qi7+4d7rD5hNllA3rMfzeVvOVPy+hT/L8qWs++OLp2Bl6+k0dr7afvolTy1VHaiBXPJgmtNA8tLsvboOyF4di4t0ig7pw72Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHhFmmkMxuGElAUhPk2Lv037ZGskuKsRj6snOnshjK4=;
 b=tNIztdhYkFu1CIhM9biAQs3G1tts+/gFntL7fJxH/BjLCKWxQfu4GnerMBa+DD6/qqO+1QZFzMzaawUErU1CgrKVkwxrXi+AJ4NGAzzWb53ng4mVDooM5yOcuc6W+oA6Q74GK5krzoNSG7G/IK71gHTtpcmOmuquFHranv9B2pDp9Kg/Gd5F6Aju9nBAruuM4VjgtfEWeHAE7TCBh/RxX7UXO5J1jFi/qA2zKI5ACHwxOsGgvRXE3TOwDjVQTc0xzjs3HXwoGomi2khA+CG6rji1idWbYP7bUJUyaRy0NbJ2WBx8vdt4wXap59WGkms7rOJptmxr7RnQ39oQNVFX3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA2PR11MB5148.namprd11.prod.outlook.com (2603:10b6:806:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 22:34:14 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%3]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 22:34:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "Raynor, Scott"
	<scott.raynor@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Mallick, Asit
 K" <asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Cai,
 Chong" <chongc@google.com>, "bondarn@google.com" <bondarn@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: Re: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyI9ksgqZIsreHUKEItLJ2DPjZrPZxbAAgAAQzQCAALSrAA==
Date: Mon, 19 May 2025 22:34:14 +0000
Message-ID: <79eaa1d4671c7bc93910ca3399bf5b023c52efa6.camel@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
		 <20250519072603.328429-2-elena.reshetova@intel.com>
	 <c955515c5469dae17faa13ebda28459d7c998bb9.camel@intel.com>
	 <DM8PR11MB5750A29C0878480F6F19E39BE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750A29C0878480F6F19E39BE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA2PR11MB5148:EE_
x-ms-office365-filtering-correlation-id: de614721-1d5c-4ec3-2901-08dd972548d8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R1huTEwva3l1Q3F0ekRpbExFeGxkTW12dkxTSDBLNVBRaTlHclNqVDNBdUhB?=
 =?utf-8?B?UkR6QWYrSW8wdlQ3VTVrVjJKM0xBQnRPa2N3TVYwSFVkcXc5dGFnL0VyMUI2?=
 =?utf-8?B?TTNaQ0cxWUtxeU95bm5vQzZrbVVVT2FyWXVqby9sRC9XZjQ2a3JRbm53SUVX?=
 =?utf-8?B?TVhxZUdxZDBIL0VTeGFkQjRYZS9DZVY0RjlzSjUzSkpFaFkra1JrWFpldzlT?=
 =?utf-8?B?WU5lcnpvZTNpTXJiZ0s3cE5ZWXlVelNjK2czN1grQTV3NVp2SHRuWlFXY2VW?=
 =?utf-8?B?WXduYkIzRnpRZGlMQVF4MWdUdzBvUC90c2xCK2lNMWVoZy9IaW1rQXMzcTVO?=
 =?utf-8?B?dkVWMTlXaVhNV2tJYnlvZWhCeVU4SHZWcFUrT3QzT2llbmVvSHJHeWtnSGti?=
 =?utf-8?B?NmtLT3d3TENtRTNBci9VTytMNVZzU1pNOTd2YWtlWkRKQzR3QkVxOHEvSEhU?=
 =?utf-8?B?TlZvTkkrYmFlbjBFY1d0N0hlRVRyWWw5elVlcWFjK29WYW1yYXlFRHhLV3RR?=
 =?utf-8?B?d2gyc3c2b3J0LzAzUDYyN0MyQ2pUOU1GVlRrU2F0enM1MDQ3MGNPNTd3cGRD?=
 =?utf-8?B?SE9iUXlmUWpoZExFbStGTVJ5Q3pGdG1IZjEzZFpNOXN5S3g0WHlPRHlGeU85?=
 =?utf-8?B?RHk1VmNqdllRNlVsNUFQdWY4VUMyWHY4aHo2d2ZtRndWK0FITlhvbzZQbnM5?=
 =?utf-8?B?bFJXaDM2aC9tVlBEV0tXY1ltWVpSWGlxL1hndCtYVERUV3lMMEtEbVExYTVQ?=
 =?utf-8?B?blNyTDd6czNCWWM5QldoZjdqT3A3aXNINlROVWpSK3hFc3JmSm80eEdzcVk1?=
 =?utf-8?B?R0I1Vkl6N2xUUGsrdWlDaEttWkFGT1AzSzJSUVZ4QitJMHhDVlc4VWd4OENN?=
 =?utf-8?B?MG4rdFNxcjE4UUV1bXhTVTJISkJHc25JUi9uR2k1WG15MGJOSzd2STFNVktK?=
 =?utf-8?B?OVBlQndPTHdndkN6UjNOOHpiTTBicldGZnV2L1ZSdnhTbTgzK3FTT1l5WUZz?=
 =?utf-8?B?eTMvRVRYVnRaNi8xdFBZWC9nQ1VENGRrS2NSaHhPUUlWTmFaSmg4ZFAvajhi?=
 =?utf-8?B?NVZJeGtsbmVnUjZrUFd4QTBSd1VXWnhKZ0hkMFFKd2xCa3pveUpVSWNHbkJx?=
 =?utf-8?B?cFhqaXRYK3U2QlBrczQ2U2UxK2x3WDNhditmUm5saTVaM1FDSUVYWnJYbnc2?=
 =?utf-8?B?VDliRkh0cldFM1hzMyt2Q3M2b1d6UHBkQ1ZPUENVaEJhNWNTZUpPQS9JMGdl?=
 =?utf-8?B?RFBLbEk5Y3dqL0s5enN3czlyaXVQZlRYcE9zdThoWkF2RHNuVW4wNDVyTTBS?=
 =?utf-8?B?QUdDQVI4dmZtWUNTcGsyR1dWVUpObEFmL3RvTDMwVnZHdzM3b1RMZUVCTzRV?=
 =?utf-8?B?ekpjcHNlOU52RjFqbGdYaXl4eXVQUmVJYzNrN3JuU2E4RVI5MS83cEdoWkpO?=
 =?utf-8?B?eGpKVENGS0g3WU5COGVCWVJMT3NWdnFJQ2RhbzhTSi9CYTMwUlg2cWxjTW9u?=
 =?utf-8?B?TUFyMzlRdGdWL3FRa0xiZ3JqeTBvT3U2MHJoQks3bzd4Z2ZuU01RMk1YU29M?=
 =?utf-8?B?RmlwUGxkY2NFS2FsL245eXNTQzI1ME5LOG03V0xkNHBnQ1Jab3NJQlkySzlH?=
 =?utf-8?B?VWxpekMrdjlGQTZjT1lOQ0x5QVBCcEM2dzEvQ3Z6Q1kvaHp3bTc3Um1wY1Nt?=
 =?utf-8?B?a1JzZHFTSUZ6SWdtYW5qZVRXR1UvOHJSeTFTalRMWTRWNHk0ZTBwd0pYYndo?=
 =?utf-8?B?bzZWS04xY0N0QlNmOWIvVmc0NUt4OVQwNXdmeFV3RUtJcCsrWkNrQ05NVVov?=
 =?utf-8?B?aXBLS0d6OWFoVVJFSzN0MlhXUVNWQTBmc29uaW5IR0ozV1hubXRXdi9uQUxm?=
 =?utf-8?B?dmkzUEV3UE9ycklXYmx3YUJtaFRIcGpaYVhtZll0cGtkeTR2YzFBQm5uWFJO?=
 =?utf-8?B?d2ZIa0xCNWJBcUw5NUFSU1RqaktONDRvZGFxZDhWcXVpM01Ca1Vhd1NESkRs?=
 =?utf-8?B?cVg5Mlo3K25RPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elFiRm5IT2lJdklpTXhrVFZIOXBjZTlwRFZWa1dnc01NUDRIYktkVlpLZjRW?=
 =?utf-8?B?WWJzNkFPNVZ6UnoyNXpPMDZndXZlM1RKOThEZms5S29nMTE0VTlKMGtRQUtl?=
 =?utf-8?B?Nm5hSHVXeG5yYlMzSlpDNnpyYkQrTGdpaE9mSmh1U3pNc3JEZEgwSmx4aDBq?=
 =?utf-8?B?ODRraFp4S3pvKzVnVHJ6ckVKVElPOW1vODF3SVdvRW1XYTVZd0h1bks3U2dL?=
 =?utf-8?B?TDdOWUg2WkZoK042SGpUaWhTdW5lMTFqYVNJQ0tWUVlrVDdSN1BCTkVwU2R4?=
 =?utf-8?B?dG9HS2ZnMlhHUUVIZXp1ZXRxREU4d3liT3JHSGJMWFZELzFSUkR2Y3Zpb0RN?=
 =?utf-8?B?WmJ6L1BFNExRQU12YWVkSXdmdkFKR2VPV3RYMEsyK251RFBDaE1OR1M3cXVa?=
 =?utf-8?B?NkFhR1d4T2phc1V1cXUrR1lBbkpJTU5mdUNLQTdtWDIvekVaK2FYMGZCRk1R?=
 =?utf-8?B?RWF4T1pvTUgxVG9VMm1YS2cvOXBnMnpKSkFveUNQOEc0OEJVbTVBZFR2T1lJ?=
 =?utf-8?B?T1d1ZCtIM1BNdFZLQzllS2RmaFRmOXNWZUd1OThSSHlpQ2w2MjRNY0JxRkZJ?=
 =?utf-8?B?Wm5QYWpJUGROSGlER0xIVHlLVEhNeTB5NXFLNnB6THVCL1JOOTRSTUxpeFRz?=
 =?utf-8?B?VFVNV2tncWxxRlZDWUw1ODMyd2pWamtzbk9XYUgyY1lqNjY2VjhpVUp0NU5F?=
 =?utf-8?B?QWNhVW1BelV6VkUrNC9PSkREN1dFZG9hQW4wUEVPeFJjeVF2TnNveHR3VWY2?=
 =?utf-8?B?L0pSQ2dJQXBnY0FYWW1aWjV5M2wrRGNxN3d2MFRMSGh5ZmgxZE9kdHRtelcy?=
 =?utf-8?B?eVlXSytHTHZTM21xYTlXSWFrWUJLRkxiY2thTGF6Q0tpb0N5RUpybHZpTnRO?=
 =?utf-8?B?TlhUdnhiODFKR0hvMFFGWjJGNGJDWkZ6OVIyY2FvQ0kwMkVmdGZuODhTT2pJ?=
 =?utf-8?B?L3pCSS9CNEZiV3hVUlFNVjBzVjlVL2pPQXZ3cVhralZxajdjcTFqWVY5VmNt?=
 =?utf-8?B?R1hkUnhvajFFcWxHSTlwMkZIZmZpR1VudEJpQy8wRDFyQXc2RTNUQjNOWDBq?=
 =?utf-8?B?dDdFOWk1R1QvQk9IZmNKTytNRllocTVjWjRPaGFldEVrQmpxWm9SNUhMNnhB?=
 =?utf-8?B?M01xUlJhUDVHMXlZNXVkS2Zkeko0Y1JRRllHMXFSeUVOa1VTcWV6NWllWEt4?=
 =?utf-8?B?TUhteURRcUc4bkxURzNnditPcjNtSUU5ajlpdUphdVp4THg0MmZUMzFYSTd0?=
 =?utf-8?B?QitsSDFwNm96bWVxOVdlR1hXQXE1b2doc0g1TC9sUk5jS0NOOFVycGM1NEVM?=
 =?utf-8?B?VE1EQThEU2RQZkFUd0xnVlFlb21GaHRWWllPM3k0K1c0bzR3TlJBakM3Yzdr?=
 =?utf-8?B?S1lraXVkb3BjVWpodU5XVnp3MjlSU2NjNEpqdXNSdDhvdWl1dTVFVnRacjlS?=
 =?utf-8?B?SjYwSzhud2hpRS8waWp1TFJIdmxtb1Q4UTJaSUswdmxVK2JNcTJDbnZPZHkz?=
 =?utf-8?B?Z1VVNlpYTWtacUl2dDRxMnJsT213SFVETUJPZnEvK1pFN1JFcUptWGZ3ZEJl?=
 =?utf-8?B?bGZMYUhqR0ZGR2EvOW1zRDJJSWU4VFBUeThPcmJ5NnB4YlNaU0Y2SGVyZXVi?=
 =?utf-8?B?cy94OERJTVV2U1A1WFdLU3UrMDlFY20xczYrRG1qTnVzdEY2RlhpSDJoM2Jt?=
 =?utf-8?B?WFoyRkZ0bVE5SnBvM3BjNnRsVXd3cmZMYUVxUTVVa1Y5dUdOL2dKNXY1TXBh?=
 =?utf-8?B?Z3JLWmZiLzFlR3JycDdDWHJMY1BhM3FUUmd5ZitvL0xZb2xqcVRreEVEQ0h2?=
 =?utf-8?B?YlRPT2ZsZ2VGVmpxdkRXakRpQUtjUmZEeTFMTnZWNHZRa0MzMXA1YXFUZkNG?=
 =?utf-8?B?eURXMlVjMi9MeFpOQnlrblA2UHJLTExjSTFQaXFRTEN2NUZwYlp5eUV5ODl3?=
 =?utf-8?B?TzR2bnBaak9YdW85T3VJTjZIUEcwOGRtVHV4VmpuUkF0aDMvckdKb21qbTBH?=
 =?utf-8?B?MzVnaWJCY2tqc1RvazVJK09JWGQ2MXdycUoyL3hTRXp0RWtmSlpwS0oxREY0?=
 =?utf-8?B?NjlTZXVjVjB5dTQvWm5KRnFTaWEyZWZDYmZHWG1aSVZrd1h4eE9mUVV1azdo?=
 =?utf-8?B?SU5BYjRUcmRGTTNFOWtpY2xuRVhUZDJSQVAzd0loTTVaQUczZ3g3c1FNTi84?=
 =?utf-8?B?OVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30E68D7EE98C994CB0AD03005116C94D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de614721-1d5c-4ec3-2901-08dd972548d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 22:34:14.8082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lGnP/3CruVZCBH7RASUEAAaX4mlVxphbeL+8appFDwnLAQxUS68K0owMcax+s2nJtULtbR9n5Ws7mbsg9YCzDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5148
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDExOjQ3ICswMDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3Rl
Og0KPiA+IE9uIE1vbiwgMjAyNS0wNS0xOSBhdCAxMDoyNCArMDMwMCwgRWxlbmEgUmVzaGV0b3Zh
IHdyb3RlOg0KPiA+ID4gQ3VycmVudGx5IFNHWCBkb2VzIG5vdCBoYXZlIGEgZ2xvYmFsIGNvdW50
ZXIgdG8gY291bnQgdGhlDQo+ID4gPiBhY3RpdmUgdXNlcnMgZnJvbSB1c2Vyc3BhY2Ugb3IgaHlw
ZXJ2aXNvci4gSW1wbGVtZW50IHN1Y2ggYSBjb3VudGVyLA0KPiA+ID4gc2d4X3VzYWdlX2NvdW50
LiBJdCB3aWxsIGJlIHVzZWQgYnkgdGhlIGRyaXZlciB3aGVuIGF0dGVtcHRpbmcNCj4gPiA+IHRv
IGNhbGwgRVVQREFURVNWTiBTR1ggaW5zdHJ1Y3Rpb24uDQo+ID4gPiANCj4gPiA+IFN1Z2dlc3Rl
ZC1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBFbGVuYSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQo+
ID4gPiAtLS0NCj4gPiA+IMKgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZHJpdmVyLmMgfCAgMSAr
DQo+ID4gPiDCoGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2VuY2wuYyAgIHwgIDEgKw0KPiA+ID4g
wqBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMgICB8IDE0ICsrKysrKysrKysrKysrDQo+
ID4gPiDCoGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3NneC5oICAgIHwgIDMgKysrDQo+ID4gPiDC
oGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYyAgIHwgIDIgKysNCj4gPiA+IMKgNSBmaWxl
cyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9kcml2ZXIuYw0KPiA+IGIvYXJjaC94ODYva2VybmVsL2Nw
dS9zZ3gvZHJpdmVyLmMNCj4gPiA+IGluZGV4IDdmOGQxZTExZGJlZS4uYjVmZmUxMDRhZjRjIDEw
MDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZHJpdmVyLmMNCj4gPiA+
ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+ID4gPiBAQCAtMTksNiAr
MTksNyBAQCBzdGF0aWMgaW50IHNneF9vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBm
aWxlICpmaWxlKQ0KPiA+ID4gwqAJc3RydWN0IHNneF9lbmNsICplbmNsOw0KPiA+ID4gwqAJaW50
IHJldDsNCj4gPiA+IA0KPiA+ID4gKwlzZ3hfaW5jX3VzYWdlX2NvdW50KCk7DQo+ID4gDQo+ID4g
VGhpcyBzaG91bGQgYmUgZG9uZSBhdCB0aGUgZW5kIG9mIHNneF9vcGVuKCkgd2hlcmUgdGhlIG9w
ZW4gY2Fubm90IGZhaWwsDQo+ID4gc2luY2UNCj4gPiBzZ3hfcmVsZWFzZSgpIGlzIG5vdCBjYWxs
ZWQgaWYgc2d4X29wZW4oKSBmYWlsZWQgQUZBSUNULg0KPiANCj4gDQo+IENvdWxkIHlvdSBwbGVh
c2UgZWxhYm9yYXRlIGEgYml0IG1vcmUgb24gdGhpcz8gDQo+IEluIGNhc2Ugc2d4X2luY191c2Fn
ZV9jb3VudCBmYWlscywgd2UgZG9udCBhbGxvY2F0ZSByZXNvdXJjZXMgeWV0LCBzbyB3aGF0IGlz
IA0KPiB3cm9uZz8gDQo+IA0KDQpJIGhhdmVuJ3QgbG9va2VkIGludG8gKGRldGFpbHMgb2YpIHRo
ZSBsYXN0IHBhdGNoIHlldCwgYnV0IGZvciBfdGhpc18gcGF0Y2gNCm9ubHksIGRvaW5nIHNneF9p
bmNfdXNhZ2VfY291bnQoKSBhdCB0aGUgYmVnaW5uaW5nIG9mIHNneF9vcGVuKCkgd2lsbCByZXN1
bHQgaW4NCnRoZSB1c2FnZSBjb3VudCBiZWluZyBpbmNyZWFzZWQgZXZlbiB3aGVuIHNneF9vcGVu
KCkgZmFpbHMgYXQgYSBsYXRlciB0aW1lLiANClNpbmNlIHNneF9yZWxlYXNlKCkgaXMgbm90IGNh
bGxlZCB3aGVuIHNneF9vcGVuKCkgZmFpbHMsIHRoZSB1c2FnZSBjb3VudCB3aWxsDQpub3QgYmUg
ZGVjcmVhc2VkIGNvcnJlY3RseS4NCg0KTm8/DQo=
