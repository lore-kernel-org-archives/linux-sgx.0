Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A9B21858A;
	Thu, 24 Jul 2025 21:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753393400; cv=fail; b=ZR62y3VEAMA8okCqUgCR0TZBCNKxQQf8kB+bgQswfE3FvrWo7u5iWR6i/J3VWNEjf8XliNRV3uEknTo2oH+9XRFwRHcQUrt0jaFtTe1iIqMA2dBDwPmk8G/JMRLjL/2WNM20XR7WDtL3IDpBDUCuDNnNt3ILwg6xPYVzLMoB1wA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753393400; c=relaxed/simple;
	bh=XDU0BsbBqy90nBLDH8pH+7Mys0dnInjz/KvIDSwnU3c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oaFcaKuPb1JzwHfVR9ZhA+YPCRZS0uenIZm6AHLsktEMEWHWOA2EjQOCgG2JQBz4u241tMZJWpchzrD7gvlTzYkeYNNgbLi0tE7iRkAGpgbh2NKDbGdzLiHS5+FIKh+fz8HsBcuGOLLbSviY3ikTz17T8NU9Rb6d+jSqNhVUMw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AFfQh5sW; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AFfQh5sW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753393400; x=1784929400;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XDU0BsbBqy90nBLDH8pH+7Mys0dnInjz/KvIDSwnU3c=;
  b=AFfQh5sWbDFiFNXWU9yrUMlw2juvfRxSfgby6dqx4ekIpEN8sElnf51y
   nXNi9aRlWD5YJ56FcPMG0/oGvqf2PPxjbNMC/a5DQgBdSUqZlYhKRGK6j
   8PaOs8aHFovtF+GAQuzaUkkFZtLyVuvfVbJHMla52APihdBWI+a+ery5s
   2F3ZbJIReJyGvHFkZjURfsjTQdHxVj8K/tlMDUE7GE7hHR81HEVh3iYtB
   8gLFdIzQWen0Fm8wf5DcnBu34FsW7PU5wObAiWDf/1QFVt7939oSn+fdH
   pmXdVx12tBFKJBV0ayDhXasFGeYgxfMnKaHUyMCL+l7wz6J6qyjpEIzvs
   Q==;
X-CSE-ConnectionGUID: gnnDpwxbRySPKt8faiEnhQ==
X-CSE-MsgGUID: omgJYmj8SRWUusox7vsAyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55689111"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="55689111"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 14:43:18 -0700
X-CSE-ConnectionGUID: H3aVYADeTbS9jsi/OTWImg==
X-CSE-MsgGUID: 6JAl3I2dTaG68OqH2IX73Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="165873039"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 14:43:17 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 14:43:16 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 14:43:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.61)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 14:43:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZtCpcTjnsnLeM3TVGe1ho7X/BDfmgNtsxSMrpcxjHiFu750eh7GtQ3wSRpFgq5+MOWHW2W1CoKdEC5rOIhTFNeRC0L5yaQe9ncGTjjBe0lxwskwxZgrfTQ1IQ1nj1ELcy5lTDuPICj317PHfHGrb6HmgnayZE/cAuRdfoCP4DSjljF5G7vOHUu8C2Ptx6BsaC32xunOgM+EAR6/8CRo7CZfuXIts6cepVTudQST0IdRRAi5X4/CYluhwpJO7x7whSJOGfm08uJUUSbalyfg3ZPJIEDuKaRLRc7gVmqx35G/woqpZyzC6EL7RjiFEQ/0LEMm7BizEiihnN+bpTMO6lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XDU0BsbBqy90nBLDH8pH+7Mys0dnInjz/KvIDSwnU3c=;
 b=mgHCxzqAnssWmsEPh+TR0qmfc1h+SDgcbD1dqMXXY+hy0VantrrMGePUmARmWZuRf8f3I/ZBOiubtFDqE3Zy4vfkrLbE+idEX+HHSFFJqg6cc755knFOeubdBWh4J35uke+ci1arbDmcrdbcNXPTNX/DGMYZ0E9Kev1/C2V2kOl7oLh0heXTXS18Bp8ltXqPfS81KHLHVtYlayCoABg+xKsKCUbnC2jOGvk23yiP2ayma68bzSMAea0sMw8rXnGCNN9BX5DY8SV0iYWzMfaodYCh+e3bPywVJZpl0IZYIvPY4wL02q7UekE0WDNttBY8BA5PW8Yg3bADIxLob7bdZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY5PR11MB6308.namprd11.prod.outlook.com (2603:10b6:930:20::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 24 Jul
 2025 21:43:14 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 21:43:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHb/HGK60dfSRXjp02uNG1v9X+jQ7RBHuaAgAAakoCAAI18AIAACA4A
Date: Thu, 24 Jul 2025 21:43:13 +0000
Message-ID: <e6ff5068a4e5b0e3463ed20657772f476eaaf070.camel@intel.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
			 <20250724080313.605676-7-elena.reshetova@intel.com>
		 <156919280fe6b1e01a81bb89f8850e72a6bfe077.camel@intel.com>
		 <DM8PR11MB57502FB1B78481B436DFAFFEE75EA@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <7a9e68954b23418fab09edd64b47dc8056f7f8e8.camel@intel.com>
In-Reply-To: <7a9e68954b23418fab09edd64b47dc8056f7f8e8.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY5PR11MB6308:EE_
x-ms-office365-filtering-correlation-id: b08bb92c-2cc0-450e-d38f-08ddcafb1791
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dmxHNXpRT29iQXZVUHJyK3VmRWJiN2lQdmV0WFNLTURJM0t2aTFva0wyRzhn?=
 =?utf-8?B?ZU1ia2YvSERYRUdXUWlpMmUwUHhSK2N6MzloSkxxa3dIL29rTHVVSUJjcWls?=
 =?utf-8?B?SkpQc2wyOG5zWDdlZUc4ZUh6aklIUU1uTWJQekpuSWFPVE1KR3I4T29LQitG?=
 =?utf-8?B?RU11Y1licldqYmFqZSsrdHVoemxhYUNkcmR6alFrV3dRZXlHRWpNWGdSS1Zo?=
 =?utf-8?B?M2lRU1gyN0NHTjd5YmhZRVlWSGNhcHNPY1hwUVNKcjlHd0ZqUGtpd2dCcnBI?=
 =?utf-8?B?NUlJalpkcTJTMVlxMkZUSGhNZThZcXRyVy9YNUhvTENqVmdTNU54YmZnQSt0?=
 =?utf-8?B?UEVjS1dQMHpRV0FvYWR2dDVuekg0R3ZrQUg3dFlkbUlVeSsyZE9Sd204TW1X?=
 =?utf-8?B?dloyUlZTa29qUnE2cWJOTEV3eFFCUVZLaWlra1EwY1psdzZkVTJwNkMzZUVX?=
 =?utf-8?B?M25xQmxWUTZvMHA2VDQxQVZEaXUwUEdxbXA4Tzd5R2NrVExLSUZoSXdqU1FV?=
 =?utf-8?B?aER4UU8zQUE1dE5yaGZQcTNGWjBvUEp5L0ppSHhOOUNlQmxadUY3VGwxNW5u?=
 =?utf-8?B?SUprdTNrdzh4VkNCZGZCZXBuNFlQWE5PUVo0bTFjckxMME11UG03RnZ0NU9u?=
 =?utf-8?B?dEVoek1vY3FPendObDNwMHJjanZMSmkwR2VhaWdvVW5ZMld1M25xMG1xaUY3?=
 =?utf-8?B?Tkxib1ZNSG96VkZ2ZExscVVSaDAwQlJSNUFFa09yWkYxNkJ5VmpaR2pzY0Qz?=
 =?utf-8?B?b3RNQVU2ZjNEYnU0N2xyZ2xDVlJuVTlqbzFPL2Q2UmswSjU1anNUam1UQStL?=
 =?utf-8?B?a3lLL01Xb0lGKzMzSnpNTjU4eEszZ2x2UkFNVTBIZStsRDJaREY5ai9RUFFv?=
 =?utf-8?B?NWlXYWpGaHE2a0gyRjduQm5MeXh2c3FVUVN0aHc0YkJqMkxQTXArOHlPQ1dY?=
 =?utf-8?B?RzVSMTlZUkwvMEh1djBZVXlKaGVVaTNISE1xdnYvM21FODFjOW9HUjc0U3RT?=
 =?utf-8?B?dEc5SmUzcHI4OTlTOGR5R0dYUmFMQXpZSUtTWitsOVBuMkhpbE83Q2owUU1R?=
 =?utf-8?B?NmMwemRaSC9EekFDeExzQTJZR09rRW03cHN3K21CeGYxZjhPcGVVZGxVbzFt?=
 =?utf-8?B?aG5WVVdXQ1pOOGhEZ0N5T2dGNTdkTHkvQTRhUzh0ZmVKOVVrQ2tyaWo2aGZl?=
 =?utf-8?B?S3ROc0pSajRmVlVnWFdzVC83UnptZzFZcmM4Y0xkNkRHeU8vblZlQ2p6MjZl?=
 =?utf-8?B?N0FCcm5QaVd2R21hdDdLN1ZDa3c1b21JSGJLenR5K1BraUcvdUE1dFFxVWlU?=
 =?utf-8?B?ZXR1SnR0bnhPN1g1cCt6K0FwSWtFYlh1ZGZaMjFLSWlCdVFnY1BHUlNzTGFu?=
 =?utf-8?B?TS9GeHdRUkJaRXFzUDd2VWcxMzVFaHRKS05zbFhCZHk0RjJmaTJubUw4enkv?=
 =?utf-8?B?Y0VGNmZKK09nZzMwQXdwdWZmbDQwQWpUbnFzdXNkcnFoc3I1WGRuZ1ZaUlps?=
 =?utf-8?B?bEYvcUI4L0ZmcGdJazQzYkcyREJ5QmtMQmxxYTVaUlRpb0NRaWFiTlk4dmJT?=
 =?utf-8?B?WVBJeUNaUzFScERjU2pZaFptUXd0WWp2RVJuYzNsb0NHbFZTU2pTdmpaN01L?=
 =?utf-8?B?aDc0bEpqTXpKMmRuc3NKK21CQWhzY3dsZSsyY0l0Z3B2bDNoYS9mVktCakg3?=
 =?utf-8?B?bHFYVXdFOVlVblYwZUtXdUVhSW9hT0FLY1p1MDJIQ0RhbHhhYWZHNGRHTnFT?=
 =?utf-8?B?UUZxNDA1TjA1UTNndFpxR3Y4TGEvdmVNT2pady9RTXlFUGZXM2cwNVp1QTJJ?=
 =?utf-8?B?eFdEdWNINDZnSytnZlZxNENYT0ViTCtISUlnSWkvVklWWGYvejV6M3g2REFa?=
 =?utf-8?B?cE9ENERmTlFQcVNBYXFvT05OeDFaQnJ0a0cxSUoyR0pKbUxTV1cwMy9Ta2lz?=
 =?utf-8?B?MEJPV21vQ0E3dnp6UFJkWXgzVXJJemlBQUFGOHlGK1dtencyM2gveDlzc3Mx?=
 =?utf-8?Q?REdCWOjMaS4da9+uXc1S+jzgIse274=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1FIM0Z0S3Q0N2l0V0VQdTE4T2htM1B0SXFQOEVoaXRNemxUVkpQU1hXQ3Fa?=
 =?utf-8?B?UUphSTFqZkJPbjBybkR0U2ZNSS9LWHIrY3J3WHVhWTFQQTQ4YTRxZVRNeDlt?=
 =?utf-8?B?Y2gzOWYyaDNjdGdEWEs5VFE2UEUrTU5wK3lzQ1Y2NjdxSm1NYUxtejJCSTlM?=
 =?utf-8?B?YmEyeGZLSE0xbStDOGVCS2lESTRFalY0UWpySnRzMnhPWS9TTmpDQVQ1Nnps?=
 =?utf-8?B?MmJ4TndtTmF3ZmJzTlpxYjdRWFVJNGdxZ1p1dkpGSXVxelZUQ3RFRWMzWllN?=
 =?utf-8?B?TWdSampJb0ZIeXR6aUYrVlBsUnFXcFdlL0ZkaXNTMkFyRjRUZEZPZVcwQ2pl?=
 =?utf-8?B?QjdraW5RZ2tzTXlEdno1cUdHeWFxMmlmYUMwQkhGbnUyM1ZKUUQ5WUxIaFdR?=
 =?utf-8?B?SmNWYlFsUUdaQVpvWHdrMnBzUTlNTU1mMWw0T29hMkk2dVp3N25oSE1mUXAw?=
 =?utf-8?B?Um1iWjEyeGJoWU43QStBWUVPQkorVmNZQ2ZjajZxek1IK0ppbUdrV0ZBK0kv?=
 =?utf-8?B?UGN5eFRpQTczdHp3MWVHZlFQakJmL0xlVG5SN1puVktyMzgxY2dNaTJ2cFN6?=
 =?utf-8?B?eFBZeklPSDc1Z3JtVjJRQmtmYUxIM1hyYUlDZTNBQlBJNEdqTStlSTFDVzVL?=
 =?utf-8?B?VFhVQWhyemdvY003MkFMaDFHV1J6R1Z4Y0x0K2t6d1pmNi9DUngzT252bDdz?=
 =?utf-8?B?azRFNWlKQlp0czRRbStTSnZVSDBwK1lTNndXQVJGUUpNaVZjakViQitIQ3JV?=
 =?utf-8?B?bGhqNUR0YTZZdWlTMnlLUjVtcmdhbmNXQkNIOWpXVm9OMUNlUXVTNGJvR1ZC?=
 =?utf-8?B?THcwK0ZqQktlODJjUmp0TXM4cm9HZVVxRnMwSkVjOVErNXdIUzUyM1VwNWdq?=
 =?utf-8?B?ZTlVVVRKdkE3UWRWaGZJejFiV3lkMEhETkVlYUtyNGhpYlhzNUlKRDBYTHhO?=
 =?utf-8?B?YU5HY05WamR3aWhlZm1Qa1dwUEtZRUZ2c2dDM2ZxcW5OMFdzaXdqYVBvYlpm?=
 =?utf-8?B?RE1qa1YwMWd1UmRxUDBzS3k2Qmh5aTEvYTJBbmRFMjlPMnc4NVF3aE5BTlBk?=
 =?utf-8?B?UjljcFF4MlNmeWVXYW1XWnlJdjEzMU5xVmk3ekRTUHBudm1LejRKdTBxS1Nq?=
 =?utf-8?B?dzR6K0h5cnJOZHIrblZSODM4c1AzdU9FQythYjd0YWdzVERiU2cxaUFPS1Fo?=
 =?utf-8?B?TS9RQUFlUzhRUHhkNURxRWpJcmhOZWtFNHFwY0lHWW5La2tBMmxvbXZLZkhx?=
 =?utf-8?B?Z0grOGQ1bHBxOXc3Vlp6UEtNN1F3NURjR2R1QWRMRUI0ckQ1ZnhDc3RZUFc0?=
 =?utf-8?B?dStVZXFZRXVQcEhvaEJldm9Wa0lleElVMWc4YTFxMjNhK20rS2E2VlRhRkpC?=
 =?utf-8?B?VDVVUzZuY0FDTUNDV1V4WmU4SnRQajFjb3VyamJ5OVpSS3pzYVpNd2ZXcTJ3?=
 =?utf-8?B?RFpDTzVucTNPV2Q1Z3hzK2dpelgxYlpHMHQxMHIzS1ZVN0JMSkthMDlWc2Za?=
 =?utf-8?B?djJDdGRMd21Kak5udnhNaG9ic3hXeXhqZlA0VERxODdYSk52dHgzd3FxLzdI?=
 =?utf-8?B?SHBBZk84aHhQMHZSOWhqcGQzUGdsOUtkRmwrSTdWQWExQXZMdmpwc2RhTEdk?=
 =?utf-8?B?QitOczV0eGVQMkRJUzRDbnBzMHpjWDcvdEVaZmZBUGdTVVNBR0FXVTJzQjRm?=
 =?utf-8?B?c2xxYmdyQjZ3cHRoL0pMdHZoNFFvcjd2OGhqdVdOSUhTZkR0Ykw0emNVbG1k?=
 =?utf-8?B?MXN3K0ZYMkVPVk5TMUw2ZXJrSEMrWHRlazk4UlRYUUxjdzN2VTNyUWxUWVp6?=
 =?utf-8?B?UzUxeGZqa0lPSW41UXhvOFhCdlRET3NUdzFOSzZYNTd0Qzc3YnpFUXlCakZG?=
 =?utf-8?B?M21saTE3UHp1MzdPY2puVkdGZGdoaWhFTFBPMlJhTU1pVE14Vmp0TFk4MjBJ?=
 =?utf-8?B?Q2JlSTcrenhPNDFXbGYzRnJ3Q1dIWTg4dVVWTmNqTDZpc2hsQkNEbTdSR0ti?=
 =?utf-8?B?eDNGTnA0K1ppbCtQTlNFenJLdTRka0NocDVBVy9NZWR5MUtBbVBiaDNMcmg2?=
 =?utf-8?B?dnVKSE9JRjBSR2EzTEVVTTVEcjZBbUNrRXZlM1RMMzJROExzTnkvaUwyRGxp?=
 =?utf-8?Q?jem4ofNFSDszD4uqziCXVXItS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBBB72E354279747A0A9CAA0DCA2A359@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08bb92c-2cc0-450e-d38f-08ddcafb1791
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 21:43:13.7312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uFFsDLSgCxy27uCJnk4OLa26/zyB9GiptBUYRGdt0fbHInDcqQZD0HoDpzDpFKtTRRdUjCrjEwdyBqYovzlRcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6308
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTI0IGF0IDIxOjE0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IA0KPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBBdHRlbXB0IHRvIGV4ZWN1dGUgRU5DTFNbRVVQ
REFURVNWTl0gZXZlcnkgdGltZSB0aGUgZmlyc3QgZmlsZSBkZXNjcmlwdG9yDQo+ID4gPiA+IGlz
IG9idGFpbmVkIHZpYSBzZ3hfKHZlcGNfKW9wZW4oKS4gSW4gdGhlIG1vc3QgY29tbW9uIGNhc2Ug
dGhlIG1pY3JvY29kZQ0KPiA+ID4gPiBTVk4gaXMgYWxyZWFkeSB1cC10by1kYXRlLCBhbmQgdGhl
IG9wZXJhdGlvbiBzdWNjZWVkcyB3aXRob3V0IHVwZGF0aW5nIFNWTi4NCj4gPiA+IA0KPiA+ID4g
KFNvcnJ5IEkgZm9yZ290IHRvIHNheSB0aGlzIGluIHRoZSBwcmV2aW91cyB2ZXJzaW9ucyk6DQo+
ID4gPiANCj4gPiA+IElmIEkgcmVhZCB0aGUgcHNldWRvIGNvZGUgY29ycmVjdGx5LCB3aGVuIHRo
ZSBTVk4gaXMgYWxyZWFkeSB1cC10by1kYXRlLA0KPiA+ID4gdGhlIEVVUERBVEVTVk4gZG9lc24n
dCB1cGRhdGUgU1ZOIGJ1dCBpdCByZS1nZW5lcmF0ZXMgY3J5cHRvIGFzc2V0cw0KPiA+ID4gYW55
d2F5Lg0KPiA+ID4gDQo+ID4gPiBUaGlzIGlzIG5vIGhhcm0gcGVyIHRoZSBwc2V1ZG8gY29kZSwg
c2luY2UgdGhlICJjcnlwdG8gYXNzZXRzIiBpcyBhY3R1YWxseQ0KPiA+ID4gdGhlIENSX0JBU0Vf
S0VZIHdoaWNoIGlzIG9ubHkgdXNlZCBieSBFV0IvRUxEVSBmbG93IHBlciB0aGUgU0RNLg0KPiA+
ID4gDQo+ID4gPiBJbiBvdGhlciB3b3JkcywgaXQgZG9lc24ndCBpbXBhY3Qgb3RoZXIgZW5jbGF2
ZSB2aXNpYmxlIGtleXMgKHRob3NlIGZyb20NCj4gPiA+IEVHRVRLRVkpIHN1Y2ggYXMgc2VhbGlu
ZyBrZXkuDQo+ID4gPiANCj4gPiA+IEkgdGhpbmsgdGhpcyBpcyBpbXBvcnRhbnQuICBCZWNhdXNl
IGlmIGVuY2xhdmUgdmlzaWJsZSBrZXlzIHN1Y2ggYXMNCj4gPiA+IHNlYWxpbmcga2V5IGFyZSBs
b3N0IG9uIEVVUERBVEVTVk4gd2hlbiBTVk4gaXMgYWxyZWFkeSB1cC10by1kYXRlICh3aGljaA0K
PiA+ID4gaXMgdGhlIG1vc3QgY29tbW9uIGNhc2UpLCBpdCB3aWxsIGJyaW5nIHNpZ25pZmljYW50
IHZpc2libGUgaW1wYWN0IHRvDQo+ID4gPiBlbmNsYXZlLiAgRS5nLiwgb25lIGVuY2xhdmUgY291
bGQgZmluZCBpdHMgc2VjcmV0IGVuY3J5cHRlZCBieSBzZWFsaW5nIGtleQ0KPiA+ID4gY291bGQg
bmV2ZXIgYmUgcmV0cmlldmVkIGFmdGVyIGl0IHJlc3RhcnRzLg0KPiA+ID4gDQo+ID4gPiBBc3N1
bWluZyBJIGRpZG4ndCBtaXNzIGFueXRoaW5nLCBjYW4gd2UgYWxzbyBtZW50aW9uIHRoaXMgaW4g
dGhlDQo+ID4gPiBjaGFuZ2Vsb2c/DQo+ID4gDQo+ID4gWWVzLCB5b3UgYXJlIHJpZ2h0LCBhbnl0
aGluZyBsaWtlIGFib3ZlIGJlaGF2aW91ciB3b3VsZCBiZSBhIG5pZ2h0bWFyZQ0KPiA+IGluIHBy
YWN0aWNlLiBTbyB3b3VsZCBzbXRoIGxpa2UgdGhpcyB3b3JrIGFzIGFuIGFkZGl0aW9uYWwgdGV4
dDoNCj4gPiANCj4gPiAiTm90ZSB0aGF0IGluIGNhc2VzIHdoZW4gU1ZOIGlzIGFscmVhZHkgdXAt
dG8tZGF0ZSBhbmQgRVVQREFURVNWTg0KPiA+IGlzIGV4ZWN1dGVkLCBpdCBkb2VzIG5vdCBhZmZl
Y3QgZW5jbGF2ZXMnIHZpc2libGUga2V5cyBvYnRhaW5lZCB2aWEgRUdFVEtFWQ0KPiA+IGluc3Ry
dWN0aW9uLiINCj4gPiANCj4gPiA/DQo+ID4gDQo+IA0KPiBZZXMgd29ya3MgZm9yIG1lLiAgVGhh
bmtzLg0KDQpTaWRlIHRvcGljLCBqdXN0IG91dCBvZiBjdXJpb3NpdHksIGRvIHlvdSBrbm93IHdo
eSBJbnRlbCBkZWNpZGVkIHRvIHJlLQ0KZ2VuZXJhdGUgQ1JfQkFTRV9LRVkgZXZlbiBTVk4gaXMg
Zm91bmQgdG8gYmUgdXAtdG8tZGF0ZT8NCg==
