Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A3025634;
	Mon, 18 Aug 2025 05:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493427; cv=fail; b=UHzbP08+OuISLttp+/qieyssyYI1zAPEbufTo7ib9bR4ErvAqDAk1XhJ8zNrfbndyCiyqYQ0MT+wHq8QaMRDpawGexo5urkzxDT1jgn6y42kUQ7eVOaBKW78rN9kVz04A5TrILYwgvPGQdWjYvlcegYeJSwuh+iPfqLppzFAewA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493427; c=relaxed/simple;
	bh=vve1aw4GEX+YyCFD0pVU5DbuGD4v5gwyyLTg404m/64=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k/X9WycyKR3oO/yVj9Ipx4OfVczfXybH0Fn03SATX/L9hPCxP+xBgaMfDj9TtbFCJjx4Y1hXGnESocnYfUiBnHG2ITAcJtch6i7ke/r3JdP3bl5u3mb0JzWRprVo407OkaM9JQNf41FYxVrNY4g5annPN9gGJGY/18Q1QRVAOro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VJ7vOQ52; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VJ7vOQ52"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755493426; x=1787029426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vve1aw4GEX+YyCFD0pVU5DbuGD4v5gwyyLTg404m/64=;
  b=VJ7vOQ52hkvbsIFfSNM4KNh+WrIQHD7c/VYZV6MjzyBhx0V4WBzussXX
   Qlj0R6loTcqFXS9VUDMUyjwLpmaxpNkZfsSns1uVvzzsW6nu2LJidSZCL
   BFlLlW9oPQTlPUS6GZcYneBZ/G5uuV61StZl+DF59zkEKHQQUBstUjWhH
   p5rNmnwenp3YoXyZ3nCYnmKhf2mWU2iqw0+ZU+WdEFVzlcAGEtvBSiq3R
   p/Rf86tW/Ku7eH6xAFFadvCdq0SS+cslnD2jHwtSKVT3JpD8WBDWQ+Cq6
   l8SbPvnjkNALj1ivFX1ISjpRrM0ewACuXxkRpWhFKA64AVgbg++pqkVme
   w==;
X-CSE-ConnectionGUID: xfZQCQlTSqiFLhSBJtUcXQ==
X-CSE-MsgGUID: jFA/UHY/Q36XCzZu1mXiEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="57816648"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="57816648"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 22:03:45 -0700
X-CSE-ConnectionGUID: a31pNsvnQVKZiyaC/wW/CA==
X-CSE-MsgGUID: zhzVPKzPSHWOP4BO2Nf4wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167457007"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 22:03:45 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 17 Aug 2025 22:03:44 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 17 Aug 2025 22:03:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.74) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 17 Aug 2025 22:03:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gw16ze+Nj9P0msJeRUYIW+x0na1Iyw7Y+P47bgjWEEHb6lof2AaLCIjZF141d9wiFB5cYGpTm+iloJk6SSHZ74FEYJgFbNY0NmiFLnatqlrudaqAzGt/aJkjDTqdQpyuNUvBLCu0MeUxnHJEqsp61eOTekZVCq9qiAt0KPStNuSFxgud98ONU3qJ7a3xDalsmJCK+8naKt8p80X3G7PacY5cmHNkPCsdBs8xC65lt+Uoumc28hjZ5/Cf44suM9BnXZZvcNiWVYg9/Q9ujmoVka6yy76zlhG5NdmApXQdksUE1ZhgRxg6xwqq2Bu5+1r8sGu9kRxmoP2kgOHJ+vUXww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vve1aw4GEX+YyCFD0pVU5DbuGD4v5gwyyLTg404m/64=;
 b=AOCtlP3y0hPlJ8IlKEkP0Jinxm0oApWwzaea/BTMmMkudiNeN/rSMQyrH7MW4MsBvC8xoTmyVsIVl3DDom7YBOqhqCUIGrSdqQd5o1juKJe8nsMMdgztnGg5fJVGsiAsSTP9SvbVc7kn78fCwxdnnY/xxPeWsbbF+ha79HdxNnkFUUKCjnJrchUsLBa5P4bH7MKMVN5RHwa4/UAmezc9ctY6EnI1aEaQSTZjHTUZEDt/TJJLUmHyjUQ0jD2lDuaGuKU/iDxMCqikXfMfLfTu+ceegCSjaXBDrlHQ1vBsGR5j82h4iMIeL5Xec9sNlqPHFsL4jEeRxd2bDo00Chu/NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB6928.namprd11.prod.outlook.com (2603:10b6:510:224::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 05:03:41 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 05:03:41 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"mingo@kernel.org" <mingo@kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcDO5TnQHIa6baW0CdldyvXyq8LrRiXVoAgABQ5QCAAJwngIAElqaA
Date: Mon, 18 Aug 2025 05:03:40 +0000
Message-ID: <c9a730751f34087bdde3ea63a8c0d3a70b8d84b5.camel@intel.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
		 <20250814073640.1507050-6-elena.reshetova@intel.com>
		 <4baa3bd4-cbc3-49b3-b8e6-09a2079c8363@intel.com>
	 <31d0ac3b0b25efde64d502755e7c5f4717fb7f38.camel@intel.com>
	 <DM8PR11MB5750EADDEFCA1160E6E75B0AE734A@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750EADDEFCA1160E6E75B0AE734A@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB6928:EE_
x-ms-office365-filtering-correlation-id: a720a802-ef81-48fa-9c26-08ddde14995b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bGZaaUIwa2c4aGhldzd0LzZNV3NMSXBzeXNoWU5sNVQzaGkyQzkreDkyakky?=
 =?utf-8?B?Y3VqZEJOTWwyOTlxSXVVRmlBY3FpTU13U2N6UEdRV1JFNjB1Ukt3Qm1xcys5?=
 =?utf-8?B?cGhBa3BFZTlrdEVvVFBEcVVIMWQ5dC9WSGh3bksrV1ZFT3ZveThsZDVLTU8z?=
 =?utf-8?B?cURONWVmVGhwZlphdHVmZVNrQ05hTnVGZ1R3VWJQWVdWTDlTTnR5UzJDU25o?=
 =?utf-8?B?dDNoQjNPKzVraUpick9GaFB1VHRxcXR5TWdkQ2FWcUgvQUdqQStKZ2w2Y2Ft?=
 =?utf-8?B?NUtEdTlsVS9vcVptd2N1K2pEdjQzQ3pnSkdjQjlmQkZ1QytvcG5MMXJDWjhL?=
 =?utf-8?B?bDdCKzIwVmZtcGh0UW5ieFRycjJvSmlSWEdaUDk3QW5FYmwra2l1ZERxUVow?=
 =?utf-8?B?VDQrR1hCKzFpcDF3R2hZYkFTWGt4T0RqVDFNNVlEVDVtakRCdEcxUHpDQmt3?=
 =?utf-8?B?cGR1a04zdGdVSGlPMkpVeHQwV29tQzFHNTIyM0ZlU0lpcm9aWStGMDlNWmRV?=
 =?utf-8?B?M3NBdVFmaENZWFNLYlplRDN0SzQzbzdwUjg0eWE5YjNOREFDRDAxSWQxNFAx?=
 =?utf-8?B?c2J4QzhYdzZSRDEyZzlOL0lWUEMyeHNzYldXNWJySWE2RnliN1o5M3FyN01x?=
 =?utf-8?B?MGlVUGg5OWtSQjlNYXIwRW1yUXZJaDhtaFhUazI5cGc0UFJGblczbVVScVlD?=
 =?utf-8?B?b3hOTkk4UzBTMjRQcDF4V1ozc1YvM2tMVDFKQnVZTmQvTzJUVUd1bTVSNEg2?=
 =?utf-8?B?ano5Z1BxWkVFZDVsdXIvR3BpMTZxRFBQd1h2Zy93UkpQM2dtd1RBR2V3WkU5?=
 =?utf-8?B?dVB3UmZ1TEVYQTFtbElUU1pIQ2pDRTMrdzVZdTBQNTJHRDlhUHNZRWtaV2ZP?=
 =?utf-8?B?TExRY2VvTFdocUhSaUUyQmFjRzFRZFVodHdFbVF0N0J4RUhVcWNxSVVHOE5q?=
 =?utf-8?B?MHNqYlhXWFJHeUJCenpXOEk5dTRxMVh5OVJRWUFIdXVkQlNMZWtJRFlyYUIv?=
 =?utf-8?B?V2xxZFhlekhnTk80Q000cXRIZS9rUjlkUUNad09jVVk3ZUIweEsvb3NHTjRj?=
 =?utf-8?B?bjhtQWFXR2NxQVlrZzEwek1JS3ZVZFRaSHdHR1d5NlZiSHBkZU5NM0dxdkpL?=
 =?utf-8?B?UFk5NUdma3A5TzBKWUFuMUdvWlRpankvTGRMYWcvL0VsT1dweFZYV0hSWmFq?=
 =?utf-8?B?TU1oYlgwcFN1RERIcnkrcGRHallpTDdIUVgwaDVQcitXMWM2dFlDc0IrWTBU?=
 =?utf-8?B?VnM4ZFNnbVBvSnNmbWg1RjRRQjRmVnpLb2ZIUVJqMGxveG5nM0hmeWxhOXVF?=
 =?utf-8?B?eG1LSEcvbHRyZnZiV1ZyT0lDS0FaOERiM29LU1hDTXZvR1crUEVuVEdsajdz?=
 =?utf-8?B?QUZNRGVWR1ZEcWlpRkxxZG1hcmp2aXRRbVYzY1BOQnhHdUxoV2VMUHRWbFc5?=
 =?utf-8?B?ZW5Wb0lKUk9XWVkySjdlR0dreDNnM2lHYWlLbmJmU0tNa2RpU0E1a2twLzhn?=
 =?utf-8?B?dHBPN1JlcU5wTy9MQVN5ZFB2TklVVkhFME9UdkNrL1hDMTdNcElIR0JUU0p6?=
 =?utf-8?B?M0U0czFwdnNUeWtWWStqVUhoQzRxNG9hSlRRNitxUmFSMWpOMzVJVStXSjA3?=
 =?utf-8?B?NXIxQ0poaVhERm5Ea0xtNG84STl6RU9iOC9FQ0E2MnNuQUlMYTV0dVBYQW1x?=
 =?utf-8?B?UXYwUnlJRzFjYjB0aGhXRWluOHozYmNadWFHaUJ6Smp0dC9ycXpNRzhwdjVt?=
 =?utf-8?B?TUtyVkNOQjFqK2VSQS8wZ3BYTlZKdk1maW9ZUWZ2ajRpU2wraHBPYXpPM0ZZ?=
 =?utf-8?B?ajJ5QmRKUjJPanFQT1g0Y0RNWUZQOHlUR2pFU2J1ZElsalREdFA5V2FONWFx?=
 =?utf-8?B?YVI0Q0M2aFg3RmVSWXJKeTVYN2F2U3dJdm1ENEQxbEFGdUNxTUxmVVNVdGlZ?=
 =?utf-8?Q?3sWnrrEHAPv122HepTt5EdzGkU9nP/w4?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0RYMFVaaUllVzdRNkVaZzRJR0NzaUZGd1piVnlFVVlWOVZRZzJscUlQajlL?=
 =?utf-8?B?bUpoWkdDTE1MVTR1Nk85Y0Z6aVo4MHZVM2JBS2M5bWhXMmUyTThNYlJ5TGMx?=
 =?utf-8?B?ZXhtMnBHZjNaSy9YU0tsMnhBcmVRMTJMWWMreUZYRW9WYnRONWhwcDlnWUdG?=
 =?utf-8?B?cE5QeGZwdWNZMUNVdy9rU2Q1V1hBa2xtdTFENkorRlIyZWZocWJySEgrOThD?=
 =?utf-8?B?eFJ0ZlErWktaRm9zQmtleWJnOUY3VjF2bUJJNGpWNzdoMmhnMDFjT1A4YkRy?=
 =?utf-8?B?cjFUYk9hNHc3dUh6TUZyandVdmErVUhRa1BMZVlsQjc3YUVGZGcrK3F1dDFY?=
 =?utf-8?B?K0FSV2VRTEx3Y1NQMlVGZG9OTHJUQWszcnZ2WmVkYUpxU0lmUTBzV2dIR0sz?=
 =?utf-8?B?WWczQmpYUTFhOGlrcHpRcVZwRVFmOFhpbzk1ZDhoNHBoejRzOXI5bEgwQ1NN?=
 =?utf-8?B?UTJlNFlCSncrTmNybDVrQmcxWnNFbTg2S0tJTEVQYU5IY2pTblk2R0o0TEVi?=
 =?utf-8?B?TGVJUCtvVVJZYTdTeXpQTDNhTGkxaHpYMW9LSkNhNGQrdVRDWk0vSG5NQ0hR?=
 =?utf-8?B?SmVPZFJHb0VXNzdRWisxN1o4UlpPNUJIQnA5ZG9JTkloR0FiMFg4RnBjL21Q?=
 =?utf-8?B?Z3RUbjYyWmFpaUVUR3dxMlBseGVpOVdvYVFZNGpZckd1SlFtQjhYNEdoM1Mv?=
 =?utf-8?B?aFNZYkxTc2lkRGpvcXRSSW5TRGhaNG1kdDY4Mng1cG9vT2VUWnh0eHNvOGt3?=
 =?utf-8?B?MXRaS2RqR2UrV0RDeTU1M1p1WjBBa0xHaEJaRHFyZ0hjQktRd1p2MGZaSG40?=
 =?utf-8?B?czJqSlBnNlN0MmNGaEluMEt6ZUZ6Y0RYY0dNTU1CWVh4bUNQU3NHVTJCR2xm?=
 =?utf-8?B?eHhtbkc3YlM5MDk4bFJQNDdTM01rWWNMbm5SSTl2Z2hKZ0xFTHJIaDVseE1U?=
 =?utf-8?B?N3NjeFd4YUJUcmRZVWQyM2ZQWk5tNVJ2WE0vT1BjaW5RQjZKaGwwYjdnNThH?=
 =?utf-8?B?NFIyTmJJMnVmeVN1RVIxSHpBbHZKaXRpTUF6TVV6M2I0MFFRdlhnd3ZUV2hq?=
 =?utf-8?B?VEcyWVc0Q0JnQkFYbnlrUE5VRDdQdHl2NlZqdktpNm5sNTl1aVBUNStKNTY3?=
 =?utf-8?B?Wjd4VVdjb3JoYmhBUFJSL01FYXFWa1B5VlFhMmd1QVJhRXlEUk9aMjdPczZy?=
 =?utf-8?B?TTVWUnpsNXBxa1RtWVRCMDZmVW8zb2VtU2V2a05DWUd0ZWtvZU10Ri9IdnJi?=
 =?utf-8?B?VGRYRG5lMkpPcTZPaW1vVzA3Sk5nYUJpOGgvcWF6TUZJTmdPcndaT1dRalh3?=
 =?utf-8?B?UUlObWRtczZ4QzByVUxocHJOWGJ2c29rUEJBbXRmSGFvRU0zNWEyMlQ2SGNw?=
 =?utf-8?B?aElmR2w3UklDMm5rcjFMZEY4OHFtZnQxODNsWFVXdEZHcnpoZVN3a0t6clhR?=
 =?utf-8?B?Tk5pTkw1WVA3UVVvN2ZSa0JLL0JRYWhpTG9NaUNRaituVFJmU2dMZFcrbWIw?=
 =?utf-8?B?Qk9WRmZBUU50TU4xV1FhVFVhRDVIaUkrcGlCVGNkTlV5TnY3Nk5pdUxGQ0Jt?=
 =?utf-8?B?dTFUVVpJdnVsNDR4YWQ0THRHMEM4NVlVYXZUbldUZ1lhOUt6T2VuRnpqdTZB?=
 =?utf-8?B?M3JWa3JlcklGVFpSdlRnbHRXOWhjVWdWNitIWGN4YUxCaEFzcVQ2Nno1K2d2?=
 =?utf-8?B?N29EbEtsQVRacFpNa3Q4Y3hTUTJaaEtTanBoMDMrVU9pUDljeDZISHZiQVIx?=
 =?utf-8?B?QWN2czdJOU5SaXBTR1ExY3IyRGdXb1I1UWFqUW9KS0FvVFNFOG1nalRNSjhw?=
 =?utf-8?B?NjR0MCszc21TM1VuUFNPS1c1QkNrMEQ4bkx0VnkyVC9EcGU2bUh4Tm9CQjM2?=
 =?utf-8?B?NW1hNEYyYmsvdGtPcWZqU2tkbmhJQ0U0MmF1MjNkZThScmRNM2FnVnZJVmQ3?=
 =?utf-8?B?VXdlaitjK25raTNQaGhCdC9FUy8xd2I5RTB3bEFJcDVhZlYySzlGc3Babkth?=
 =?utf-8?B?Q1VCVGpnRmlMQm1RcDhQS3FJdjVJRU9yQ3ZIOERoenoxSUhRcmV0elRUNzh3?=
 =?utf-8?B?SWxGQ0JOTk5Sa1BkbUJwbXRoZ2MzZXNWMm5rMFFMT1hjWlJnZHhWcjR1TjBt?=
 =?utf-8?Q?quL1KVVcuuYn2SXtK4C4fnI3B?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FB2255EE633454DABFEE37EF4A736AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a720a802-ef81-48fa-9c26-08ddde14995b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 05:03:40.9618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Af/4vdqv80dQKAceaU0+p+hgba4lu7YLlS0V6dsX7DXuOKsnqe8cqDZjdqNLFO6Z0oQNpnPDGr66z7liHXNvfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6928
X-OriginatorOrg: intel.com

PiA+ID4gPiANCj4gPiA+ID4gIHZvaWQgc2d4X2RlY191c2FnZV9jb3VudCh2b2lkKQ0KPiA+ID4g
PiAgew0KPiA+ID4gPiAtCXJldHVybjsNCj4gPiA+ID4gKwlzZ3hfdXNhZ2VfY291bnQtLTsNCj4g
PiA+ID4gIH0NCj4gPiA+IA0KPiA+ID4gSG93IGlzIGEgcGxhaW4gaW50LS0gc2FmZT8NCj4gPiA+
IA0KPiA+ID4gV2hlcmUncyB0aGUgbG9ja2luZz8NCj4gPiANCj4gPiBTb3JyeSBJIG1pc3NlZCB0
aGlzIGR1cmluZyByZXZpZXcgdG9vLg0KPiANCj4gTXkgbGluZSBvZiB0aGlua2luZyB3ZW50IHRo
YXQgd2UgZG9uJ3QgYWN0dWFsbHkNCj4gY2FyZSBvciBhY3Qgb24gZGVjcmVtZW50IChpdCBpcyBu
b3QgYSB0cnVlIHJlZiBjb3VudGVyKQ0KPiBhbmQgdGhlcmVmb3JlLCByYWNlcyBoZXJlIGFyZSBv
ay4gV2hhdCBJIGZvcmdvdCBpcyB0aGF0DQo+IHdlIGxvb3NlIGJhc2ljIGF0b21pY2l0eSBhbHNv
IHdpdGggcGxhaW4gaW50ICgoDQo+IA0KPiBJIHdvdWxkIHBlcnNvbmFsbHkgbGlrZSB0byBnbyBi
YWNrIHRvIGF0b21pYyAodGhpcyBpcw0KPiB3aGF0IGl0IGlzIGV4YWN0bHkgZm9yKSwgYnV0IEkg
Y2FuIGFsc28ganVzdCBhZGQgYW5vdGhlcg0KPiBtdXRleCBoZXJlLiBQcmVmZXJlbmNlcz8gDQoN
CllvdSBkb24ndCBuZWVkIGFub3RoZXIgbXV0ZXggQUZBSUNULCBqdXN0IHVzZSB0aGUgb25lIHlv
dSBhbHJlYWR5IGhhdmUuDQoNClRoZSBwcm9ibGVtIG9mIHRoZSByYXcgJ2NvdW50LS0nIGlzIGl0
IGlzIG5vdCBtdWx0aXBsZSB0aHJlYWRzIHNhZmUsIGUuZy4sDQpJSVVDLCB5b3UgY291bGQgZWZm
ZWN0aXZlbHkgbG9zZSBvbmUgb3IgbW9yZSBzdWJ0cmFjdGlvbnMgaGVyZSwgbGVhZGluZyB0bw0K
Y291bnRlciBuZXZlciByZWFjaGluZyB0byAwLg0KDQpGcm9tIHRoZSBwZXJzcGVjdGl2ZSBvZiBm
dW5jdGlvbmFsaXR5LCB0byBtZSB0aGVyZSdzIG5vIGRpZmZlcmVuY2UgYmV0d2Vlbg0KbXV0ZXgg
dnMgYXRvbWljX3QsIHNvIGVpdGhlciB3b3VsZCBiZSBmaW5lLiAgQnV0IGFzIHNob3duIGluIHlv
dXIgdjcgWypdLA0KaXQgYXBwZWFycyBhdG9taWNfdCB2ZXJzaW9uIGlzIHN0aWxsIHNsaWdodGx5
IG1vcmUgY29tcGxpY2F0ZWQgdGhhbiB0aGUNCm11dGV4Lg0KDQpTbyBzaW5jZSB3ZSBhcmUgYWxy
ZWFkeSBoZXJlLCBJIHdvdWxkIHNheSBqdXN0IHVzZSB0aGUgbXV0ZXg6DQoNCnZvaWQgc2d4X2Rl
Y191c2FnZV9jb3VudCh2b2lkKQ0Kew0KCWd1YXJkKG11dGV4KSgmc2d4X3N2bl9sb2NrKTsNCglz
Z3hfdXNhZ2VfY291bnQtLTsNCn0NCg0KQW0gSSBtaXNzaW5nIGFueXRoaW5nPw0KDQpbKl0NCmh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXNneC8yMDI1MDcxMTE2NTIxMi4xMzU0OTQzLTEt
ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbS9ULyNtZTNkOWNhOTQyMzMwMDM5YTU5ZTJkZDZlMWQx
NGI4MWM2NjcwZjg3YQ0K
