Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9EE2AC17;
	Mon, 19 May 2025 11:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747655263; cv=fail; b=I/uvKFaJJ9rgioqabJDjFNAw7ikbfVtJA1dTNAnLLqxfb9hk/0W2ILpG1tRYVHnP4H1UdQeNhHQ9RVqfFyFqSQX3DDuEee1bkapgi87+5si0KKfDY7hylS4QLtf6sGC/SO/UKrJhmylmlNcT/gBulkZRUuADJ/9BEUEbLbKAdaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747655263; c=relaxed/simple;
	bh=o44aR3mjs/OVPEv56gOXJBZpFOZC8r8eHKgzdsGko2k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QrdoklM3SJc4RzJ9RMDaFujSuX7kDO2LCRoe0CQtmA0EqY8WUiodnoF0d/IWPn6pBSH7tjeO1DM+uipP0Zr7uQO7AT4qVvNxScQoREtX4HydyxIA1HNNmToaAd3ygmEoeXmyWC7QOcFKKbbQTUAXvUosfgxMB0Beu6n5pTilSOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TC0Cygm1; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TC0Cygm1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747655262; x=1779191262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o44aR3mjs/OVPEv56gOXJBZpFOZC8r8eHKgzdsGko2k=;
  b=TC0Cygm1qQSSlsCbrpb1MzSq4P3otiSWL+EBUqCmd3hVG4/9E7JUvpQc
   nkwtMF0pMWbPcNo6M0MLTixF14Cg9YgHvVCul9jQSX91Gd/3NBK9E2kNo
   FBQ/KwxH+yy53wsblJ2+ayP/MBLNPTnzRumktdG3leVLuGHHlKMKKGnGX
   2VbKv3Ib9c42daaUZxHl6gOwFmMQRhr++mmE+wEqB7p4GvRHG9MI1GvA+
   k6Bc/5X6J0hjzQjNoG0lMe13r8kBKBh0fZpsTMFLpgrYio7GuweAHfVw+
   532dMTU6ildjysBb1EhRaffahaz4HMKLVMWD1NLeZwZVd6J0L4UmWIpVd
   A==;
X-CSE-ConnectionGUID: EOgeHfQlTZSppDAHHaAnlA==
X-CSE-MsgGUID: wDImgVJQRFGzvCMgvFaYvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49654988"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="49654988"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:47:35 -0700
X-CSE-ConnectionGUID: qup1wgr7QqePJ/2QTJxcqw==
X-CSE-MsgGUID: iXaUA1gBQ0SWjsc3ocVw9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="144599731"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:47:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 04:47:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 04:47:34 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 04:47:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHHgHBMFotG+3PQPGd1C2UvVKdckDYhT9hBKGWNX3cWGuKxI02y6dmDHji+wo/FGuuc8jsDMXOdVZV2NzXJNKaHKDK6/W4Gq0vJqwXf6njWVYbC6xi7tR2Mbzk0cWkgMdSg3MPKea2zM7seXof6OK6E2p0l/0P3xrODeLjDxDWy9CxlOZHRTOglfAZagQZ0/TxVgRbgeOjdgPwX3ki7HYQQUWN5blcbqP0/W2h+ycnkS9771MIRDpNk3ukKRN0hjsTIq3k74hqRpb7sWdQfOmwFsUvj8aInOP9jn5T1qb+twzRQi6Dt5rbuCdd9l56PrOpr6BhFQYMW9vXhMh+FvSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o44aR3mjs/OVPEv56gOXJBZpFOZC8r8eHKgzdsGko2k=;
 b=Tl2npw+v/qSUMFZMl7GkCdk8Omg1gclTpr45tPSV+le6JVrdlMoXRNaELC13FJyo6+GKYT+grUdBaC0V0DN/u5TPbPeA8jIp/sGXq/cQ1I7HhnauIGUUUJgOMsMrJeqnFpvOmp6+mnhx9TDN8dzhdeFiORFcqNybizj6u2iH+IBBx/nTSL6t2c7DVGVmYwkcgvDlmA4oveCsHr567pmFRKeZ9EZ47ahpV5ic0yEW+diabALXraMTPbw2LgJaaT44ZGijeF721zHsUfVyLKt++beNnuVprHy9/wURdNxgvZ/nhZVOfCW1FxYWXjyUdPfPZ4dkfBZ9jgzJaClxOg9L8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH8PR11MB6951.namprd11.prod.outlook.com (2603:10b6:510:225::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Mon, 19 May
 2025 11:47:32 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 11:47:32 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: RE: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyI9kSVxmTXaknEyFmJx4IavRXLPZxbaAgAAP8YA=
Date: Mon, 19 May 2025 11:47:32 +0000
Message-ID: <DM8PR11MB5750A29C0878480F6F19E39BE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
	 <20250519072603.328429-2-elena.reshetova@intel.com>
 <c955515c5469dae17faa13ebda28459d7c998bb9.camel@intel.com>
In-Reply-To: <c955515c5469dae17faa13ebda28459d7c998bb9.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH8PR11MB6951:EE_
x-ms-office365-filtering-correlation-id: 380e6015-e26d-4b85-208e-08dd96caf0a4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RFhVRGFKSVZjalcyS0ZySTNQWkVLb2hldlY3K0VqMWI2NXVZcmpXcUFsRjVy?=
 =?utf-8?B?M25wTzcyUFhJV2FtcjFjRUUxWXBISFJSaEdmdGlTN1Y4N3A0WkdoRTBld0RK?=
 =?utf-8?B?M3c1cllGRGhTMUVhNDIyc2hFdVRHeWRWdktGV1R5dnpha1VGNG9Lemw2VENv?=
 =?utf-8?B?emhoMnlkb21Kb3owdVFSVDJGYlFaL2IwdEJDZGRyTkkzUmM5MzJKTjIvT2xt?=
 =?utf-8?B?ZFhEQ1F4VERhMXhoRkkvSERsSHBCcjN4cG1xS1FrZ09zSHBXMG54YUFGQXll?=
 =?utf-8?B?UmFQaExVc2FLVlUvNldjUEg4TnpYWUovMExFT3RHMHR3YUhTYUp5ZHVlQ3Rz?=
 =?utf-8?B?TUMvU2VFSDBNenhXWW83clVoWE1vYnlZM2xVcW5qZzRRcXBGY3dDYzd4cHFI?=
 =?utf-8?B?em1nWGRSV2tuZ2pRSG5kcnZMZmhPRTd5RS8rTzIzaWZQMEF6Q3lLUkVGbk5x?=
 =?utf-8?B?V1hBWk1LRVNub3R5cnRuRFo0UitYN1RnNXZFRXQvaXlBbVB6ejBpTUM2TU1L?=
 =?utf-8?B?UjFxUkxldHZqb0taRGRZNUw3L2sxT2VmVm9oVU54Zmw3azArVEd3Mm5PSVFT?=
 =?utf-8?B?Ymw5YWF1ejFDMFQ2S3hTQ0tQSEo4VG5vUlV5eGZJNElNbXdCbFVYVUlWTjA2?=
 =?utf-8?B?WlV5Z2RtSk1pYi8zMi80Y0psdVkwbFlzbTM2M1grbld1RVBOQmxEdzFuK1h2?=
 =?utf-8?B?UVdXVk4rUzQ0YWN3OFYvWk5OeVJDL1d0ZTU5dzgxTjJzandHTTlTRXh1K1li?=
 =?utf-8?B?TDBraG5lQXRwek5WZ0JEZWpIbzdkemxZVDFVYlFOQ3NOVDFkS3ZMQWFzUW9s?=
 =?utf-8?B?aTNXM3JPaUJxVUgyeithTXozeXZtSHpHRmFnRWhBS1VXSHhJMDlraEV4SDhi?=
 =?utf-8?B?OU41MVpNYkx3ZmNqZU4ybnFFdG1vc0FuYzJ5bDVtS0NpanppVS9WdU1EWjcv?=
 =?utf-8?B?R3ZnZ20vOUpxaW9uei9rTU41cVlNNzZqRDlyVlFjTEU2allLWHhCM2tPZDNC?=
 =?utf-8?B?Z1NwaVpTSzRsakJRTzBhOUxsTzRmZG9HbDhpZ2tXeXZDbDgzQVNxbWNjYjVR?=
 =?utf-8?B?NTV0N24zc283L2FvTHZuSEhtVHAya0dTRkF2RVdZOUVPS2xSOUR0QzEwbTVO?=
 =?utf-8?B?TE1uVVpsWk1VSTJKZHF1UHB5N3lTR0haQTVQMnBTaDFNWW9BNjIyWjVDTFpK?=
 =?utf-8?B?cjZQR1I3MTFDV0NvTDExaGJQa1RKWEZNemRTL3RxVzFmQUU3VnVjcHNGTC8x?=
 =?utf-8?B?bGZaemhYcFJiQnRmRktWMGsvZldQeFAzb3I4NWMwTmpwVGVWYS9KQWNhWHN2?=
 =?utf-8?B?VDFtVk5hZExDNmJLRFYvZDRqVkU5TUdTM3B5aFdPSEhuS1ozRWF1OStxOXJB?=
 =?utf-8?B?RTZOQUdWZy9VbG1YWjVlUTlKL0VSbFpVYitxUHAwSkE5NU81bEc1UmVXbERu?=
 =?utf-8?B?Y3hRazYyZXhqN2w3cUlLWW5xY2lkRk9CRG40ZWtqOHlNQ0J1eDNIWWVpbDlx?=
 =?utf-8?B?TmE3ZkVPOXE2WTBJRUxzMXRWaG5jMUdCaXZNbFNQbWFjVDNDbEhOMnRlbzV6?=
 =?utf-8?B?Y0VjZ0VFOTdqeXhyRnpsYjJSTUxHSWU2Z08zL1k0eFhOWUZhSXRrS2d1NWc4?=
 =?utf-8?B?TUdwM3J3Tmd5RlhscFFHVmtZVHFXK2xXRGpZVDAwZTBTZDIvWkVrWUozY0lW?=
 =?utf-8?B?bnEvalhxeDlLdzAvaHBxTG1lQWJTd2JUMm5RY1NnV200cUltMTNOKy9YTWdO?=
 =?utf-8?B?NGR1Ym91aWNSSjNCK29DeFFlYStONUhvbFJ2UjdJWmRBU2dWa2tBZG1sWENO?=
 =?utf-8?B?RDNETVNDVDdnMVdVRFY1VFhPVVU5aE4vbWh3dGxCQWdYRUU4RjNKZTZrdjdI?=
 =?utf-8?B?MTdvakRHaVFabm9sUnNYdThOTkNTOFkrTGhrTjlydDlheTVkOWpTd0xLWjZ3?=
 =?utf-8?B?WC9LaWc0UU40eVo1YmpUM3UvTksxcWpLRlQ1MHhCSkQ4eFpBVG1WNTNOY1Yy?=
 =?utf-8?B?VHJsakZ4cS93PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFRiVW8xU2xIYW1TQkJiSkV3RFJCZm5TMVpkSUlWeWVPZVpXeHUvbDJDOEh1?=
 =?utf-8?B?NXNBUG1saGFHZ2R1MnNjeHQrSTN3djg4Y0h0N1ZRdG1semhXUmk1a1dLOFY3?=
 =?utf-8?B?RTlHRFprOHI2QUlDUmZoNVhicTR4NXZJeDYzcDdMcGYyb0RsemZudm1JL3B0?=
 =?utf-8?B?ay9xOUsxeU5wcFBKQXVYaE9CZXlxU1ArRU1pU2hQeHdQOEtrMVVFb0hsZTZq?=
 =?utf-8?B?S0Z6TUpPa3YrMlBITGFvbXhERGNxT28yRzJCN200cFdHRlhBOEsyL1NxNWtF?=
 =?utf-8?B?S1lIZnRPb3dVNlYvR0JEdGtrSkdhNHl0YVEyWVJ2YWpNVGRlZEo1RXhaZ0dL?=
 =?utf-8?B?VDdTNnRkbi95WE9kTldadTU3WDVWYVUrRWRLMXVncHBKd0g4bE55Y2NRUG5P?=
 =?utf-8?B?QmhYeXR6eTJaeGx5OXNyZTFudlNxeVBDeEpuNEd1KzJUYjA3a3ZTTk9rZTBs?=
 =?utf-8?B?cThUajlrK2xQbGlmY2FiclVPbFZYbUxzejY0RXYwaDdxOVlIQVFBaEh0MUFw?=
 =?utf-8?B?aTRmWHpuWWtBTmxNc1dYZG1abVg2MGFIV3JmK0VKYVFVL00wSjZhcDNxcVdt?=
 =?utf-8?B?blFZeU52MjFHMGlnSmtEaWpXWU5BcWFtMm5RY0FHZ3NpU2k2VlR2M242Mi9p?=
 =?utf-8?B?ZnEvZEhtS3ZvTnhvK3BvQTdtSHNLRmhKK3JWYlAwSS9laDhUUmN6MFVEcGZs?=
 =?utf-8?B?M3hYTGYzTHBwZkczMkt5UHRucTRkSjAyTlpGb2trbXJZa29iL1h2ZGIzR01p?=
 =?utf-8?B?Y2pRRmJONW5XQ2Fha0tyanE1RURyQVpUZEFmbnQ2ckdld0dVNzE2eWk3Z2Zq?=
 =?utf-8?B?QUYrMnkwRkoxajJsaXFISG1EYW5YU0xrelJMS01wY2k4eXdEUmpCU1FNa21X?=
 =?utf-8?B?NWhIeGV4Q09yNmhZd1BxM2k3Z3k3SmtvKzVKRCtwTE5pRldrNWgxNFpwTG1t?=
 =?utf-8?B?VlNTT09VT1ZjdVpYNzdZWXJ1TDI1SS9KdEU3aElnWXNtZUk3ZkJaTG1ZcGFs?=
 =?utf-8?B?WThHQUUwTGdQU2NrS0huKzdNcnJ1UFpIRkdnRjVmM2ZTL21EZ3NLYmhEaWhF?=
 =?utf-8?B?Wkk4MWQzWTdnWGVsdHFVSEZ3eHpUL1J1M3RZTFNuOWxnMUxJTTJHdWtyZzVP?=
 =?utf-8?B?RkduOHBnRDRuWFpUZ1M5ZFJURkNLeGpxMC9Jd1pxbmtNRUVSdTJQaVNVL3Fj?=
 =?utf-8?B?NEp2eUxNV0pGd2Y0QzlxYUl0QncxdG5kNWdvYVMvMEEyckIza2tMMFR2UDY5?=
 =?utf-8?B?NlpNYnRCQ1g3UmRwYkpJa0Q3V2ljTEJBUzNiODRzTWdMWUxlcjhqaXM5NHMr?=
 =?utf-8?B?THhqdEdMb0pqMFpRNVZGN3Z5YUhHNmpqUS85S2Qza3hBcEEvbTZyYldqa1pH?=
 =?utf-8?B?aHZvU3lUekM0dXdpbS8vOEZ0emNJeXhNTnhGZ1BKd3R0MkY3eTc2Z1RkcmZJ?=
 =?utf-8?B?WUozekNCTTA5Z0VkMGJtR0RzMzRpM3VNVEpqYTNJQ3plZUhraHlsR21BcnNU?=
 =?utf-8?B?MmU2ZFpQK2trYWZLbDdXblQ4bEtUOVNaaEo5eDd3S3d6cHo2UnNCN3E2Ykpu?=
 =?utf-8?B?THl4NGU4WFBySk9IS0Nma0lpMjJ1NGRQNndBTHZkUzBRcHdSWmIwNklDVytH?=
 =?utf-8?B?OExLbEVkbkN2alc4Zmhua0pIQVJEQTBjTnN2NEFzeWg3YnBFTFlhTS9LRlhF?=
 =?utf-8?B?RGJrOFo1SVRkRkpqWlhYWXRwZmNjaUpIYkVMVEZtTUdPS0FDNEVHc2M2dGRU?=
 =?utf-8?B?SEJMUisrbGR3Y0NlR1R5RVMwV255eUpIYnNYSHk5TXpBU1FGOW5BV3hSNWph?=
 =?utf-8?B?UkNJdUpDWEFQNmwyYXBXZzU4aWNnTjNpV2JiZEFLdFlwdk9JdVBBSXFkcDhJ?=
 =?utf-8?B?MDdwTzFRbGY4RXBuSGg1K01LaEpiWEdJWm5uWWdXdklXVTRwOTVNdk1SVm5B?=
 =?utf-8?B?Q0tPUG5meVg0Nk9KamwvWkRpNHllcDV5bUZ1NW44c1hDMGFKWlAzcm1QMFpB?=
 =?utf-8?B?Q2RreGNHSDFoOGRoVXg5bjRoS2VxM0ZIQVJlOHc3bm9zd05SV2pHSFd3dkpm?=
 =?utf-8?B?SXRENWpubUVMekpmMkhhblRjclJ0UVJCLzR3bDB4NXl4aSt1QnVES2VPTi9y?=
 =?utf-8?B?cjhoa2RwdjJoaUtCa1hOTjEyYjlJODVlYndhMllRdC9pRUFxWmlsSTNmbU5k?=
 =?utf-8?Q?a1twVj6xxHfFvLyp+JCYTkTGvIGLRP9N2k/m5/Ss41t4?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 380e6015-e26d-4b85-208e-08dd96caf0a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 11:47:32.0720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y+ifBF2YfI7wZomspzSRwo7rZcNcOLU77LoXEu8noPPW8YVLt9LsLbhkQxnnLH9hpnPeO/cjCg9wWKr/UgKoWTpbou2zUa0RkkMn0Z+8d3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6951
X-OriginatorOrg: intel.com

PiBPbiBNb24sIDIwMjUtMDUtMTkgYXQgMTA6MjQgKzAzMDAsIEVsZW5hIFJlc2hldG92YSB3cm90
ZToNCj4gPiBDdXJyZW50bHkgU0dYIGRvZXMgbm90IGhhdmUgYSBnbG9iYWwgY291bnRlciB0byBj
b3VudCB0aGUNCj4gPiBhY3RpdmUgdXNlcnMgZnJvbSB1c2Vyc3BhY2Ugb3IgaHlwZXJ2aXNvci4g
SW1wbGVtZW50IHN1Y2ggYSBjb3VudGVyLA0KPiA+IHNneF91c2FnZV9jb3VudC4gSXQgd2lsbCBi
ZSB1c2VkIGJ5IHRoZSBkcml2ZXIgd2hlbiBhdHRlbXB0aW5nDQo+ID4gdG8gY2FsbCBFVVBEQVRF
U1ZOIFNHWCBpbnN0cnVjdGlvbi4NCj4gPg0KPiA+IFN1Z2dlc3RlZC1ieTogU2VhbiBDaHJpc3Rv
cGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogRWxlbmEgUmVz
aGV0b3ZhIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4
Ni9rZXJuZWwvY3B1L3NneC9kcml2ZXIuYyB8ICAxICsNCj4gPiAgYXJjaC94ODYva2VybmVsL2Nw
dS9zZ3gvZW5jbC5jICAgfCAgMSArDQo+ID4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4u
YyAgIHwgMTQgKysrKysrKysrKysrKysNCj4gPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvc2d4
LmggICAgfCAgMyArKysNCj4gPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvdmlydC5jICAgfCAg
MiArKw0KPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9kcml2ZXIuYw0KPiBiL2FyY2gveDg2
L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+ID4gaW5kZXggN2Y4ZDFlMTFkYmVlLi5iNWZmZTEw
NGFmNGMgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZHJpdmVyLmMN
Cj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9kcml2ZXIuYw0KPiA+IEBAIC0xOSw2
ICsxOSw3IEBAIHN0YXRpYyBpbnQgc2d4X29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0
IGZpbGUgKmZpbGUpDQo+ID4gIAlzdHJ1Y3Qgc2d4X2VuY2wgKmVuY2w7DQo+ID4gIAlpbnQgcmV0
Ow0KPiA+DQo+ID4gKwlzZ3hfaW5jX3VzYWdlX2NvdW50KCk7DQo+IA0KPiBUaGlzIHNob3VsZCBi
ZSBkb25lIGF0IHRoZSBlbmQgb2Ygc2d4X29wZW4oKSB3aGVyZSB0aGUgb3BlbiBjYW5ub3QgZmFp
bCwNCj4gc2luY2UNCj4gc2d4X3JlbGVhc2UoKSBpcyBub3QgY2FsbGVkIGlmIHNneF9vcGVuKCkg
ZmFpbGVkIEFGQUlDVC4NCg0KDQpDb3VsZCB5b3UgcGxlYXNlIGVsYWJvcmF0ZSBhIGJpdCBtb3Jl
IG9uIHRoaXM/IA0KSW4gY2FzZSBzZ3hfaW5jX3VzYWdlX2NvdW50IGZhaWxzLCB3ZSBkb250IGFs
bG9jYXRlIHJlc291cmNlcyB5ZXQsIHNvIHdoYXQgaXMgDQp3cm9uZz8gDQoNCkJlc3QgUmVnYXJk
cywNCkVsZW5hLg0K
