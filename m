Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F50D2EAB93;
	Wed, 13 Aug 2025 13:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755093393; cv=fail; b=t8f428wabG3NVGcpYID5n1y04bzMYVyJMexnMTTNumY4PZMe7u+5z5Fzm/CLm4zJNsb+qXV/KAxjmuCcZs3criNUb3KgZQYcydLixj5IOUTXvyf/9KPWrHpHafp79uZqXNO/509Y9ras4Fz4GFTtmrAwO7eMKnDzSCggWPnOoQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755093393; c=relaxed/simple;
	bh=7uZ5IT3mtv84yy84vMxbHOvv9B6Eg8yx7coFJrJaEs0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t4EVVWS9kd2e5bLas5J7NwDtvz8Bbiq4D5xGXIt6mwFXW4ikTxCbPVeb63MJo3h3S/59ou+CP4T+V2YMS0Rnf2ABoIAmm928UJFoG/IxQNMbPLIzvLfqA2MH28jjpaD0Mn0qGgWehaQdsuVgMiw0gPaZHtU7WEbAU0NL+hBHr+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EmKHamUq; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EmKHamUq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755093392; x=1786629392;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7uZ5IT3mtv84yy84vMxbHOvv9B6Eg8yx7coFJrJaEs0=;
  b=EmKHamUq55XS2yaAWKi/m9juZxCAtIbzboRlJd3FetIpuWZDNlX2eB1U
   ILtGRZBDDJDJPziSrXu75YOxyYiKeysslrzKwDNlU8gXQNZ5yH3d1d78J
   ISXOwv8WRkQw+DqmYB1mfBgW9f1ts+MmOtQSWT93PSMbsuaowQKqDkZ9h
   cndkL/bXSp2QyLkUQsDyu+Wold7BIXn4lHYqXAM+mZ1wZOHSwPPz3mQNt
   erM2UVw/8PHmA/6R0cvWiqWqkSauTejEJ3oXfCbWOR45ezzpzBD4rzJBm
   8RB8adr4wHuAvT6z2z/YRVwbvxLkXqsxabJ0bz2nDDIKWytmDUapLG70p
   w==;
X-CSE-ConnectionGUID: XUFy15fnQRC0Fyu83d6G+A==
X-CSE-MsgGUID: dAcw9CkAQmez90yILOKb2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="68090464"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="68090464"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 06:56:19 -0700
X-CSE-ConnectionGUID: bP/seq4zQnORbmROmb6e9g==
X-CSE-MsgGUID: VvxpYWdwRdGyytsPhCGzsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="166846564"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 06:56:18 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 06:56:18 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 06:56:18 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.89)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 06:56:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EsCtstx6B9WGV3sfvao/h85y6HEMtFEIN38Hy6rzeBRLbcl5DovT0hcwpfhwF5/mtsxUGLvotJ3xNmE13Vts9FbiZEaqL6MWF/plfyLgN6oLX16tyXH3dGOmSepL/p5Cd0C8BSIMf1kKpInG77SpcaHxFQtvNZn0zMu6ig/PFBWQ38Kre0I0RlD65434keMOY/iFY6tl3dxCJi/NtS0wyU7EPiAnjpG/jL5smsd53ZAu65igkN7eizaaTBVfxPvzzLIXPbYAKgsKgRUGUvyQQgoDxKEcReUAgUD4TZCWx2BvVsANNCaFzNr+KgS9RW+BFlZLFAG2VO+0B6CSKBazqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7uZ5IT3mtv84yy84vMxbHOvv9B6Eg8yx7coFJrJaEs0=;
 b=qnslJDJK5r7KMJ1kLevtdPGStTYlP5K2NnYGypYE0koFfX6mZBGz/DevTgUdFvhfTTyP1IeRuBBZAlB8HNhnfdgo23U9sPh9ks0e8PbWOOCWtwE9Osb0vAWoQ3jeGAkDOwJgrz2/nrWDOKPd8ymZRDUPHkwOWYXS+ZZGtqfAKNxFUP5kdDsf1kjFHCVqBBzBCBhFYwg5FSm5HjYy0rNUUeJx4JaAkhKXPXqvA4nZXxZIPeghWTMa0YU3+ti56U3O0rTZuxBiXN1plOP1bN150/FKe0+0e/Raqt2mTHlZlXt9brTuVI1KLSfzs9FIl2ajXdguVV/nywciwgZ73LGhXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CO1PR11MB4946.namprd11.prod.outlook.com (2603:10b6:303:9e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.15; Wed, 13 Aug 2025 13:56:15 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9031.014; Wed, 13 Aug 2025
 13:56:14 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v13 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v13 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHcDC+7pF7jsXwSn0WF8PUl96tYl7RgbI+AgAAuTKA=
Date: Wed, 13 Aug 2025 13:56:14 +0000
Message-ID: <DM8PR11MB575054688AF2AC8E9B6A50A8E72AA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250813085233.1369036-1-elena.reshetova@intel.com>
	 <20250813085233.1369036-5-elena.reshetova@intel.com>
 <1a19722b2f979cf34125ec562523ddf0ea8e0b26.camel@intel.com>
In-Reply-To: <1a19722b2f979cf34125ec562523ddf0ea8e0b26.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CO1PR11MB4946:EE_
x-ms-office365-filtering-correlation-id: 5eb596e7-2f3e-49fc-af9b-08ddda712b36
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NUJYUGRZOUNFZHY3UkRtbHpiVVR1Z1BiZlh3L29PVGdOY0pZMFdTNk5TcFR2?=
 =?utf-8?B?K21NYjJoVkE2SFY0a0NvbDhVcitUNlJxa2ttamhnOEltMS9qRW80ek43NVBP?=
 =?utf-8?B?LzQ3RDhmNk1ZcVpuSGs5OHBXMjBwSWdiUFdZYXpYdzdKQktHR3VxUVBteUF2?=
 =?utf-8?B?VlFUZ0t2K3M3eE1SOEFzaVpjMWNFbmV6Ky9INjRmdjVUdGFpYlB6bC8zOTQr?=
 =?utf-8?B?d21CK3ptakxnZTNXN2NCaGdlanMwMW1DcS9MZXlFYURjVXNCc1B5ZkJKYllk?=
 =?utf-8?B?TDU4ME1pWmJWQXkrZTFFK3VnREVQU3FGbklLaEEreElncTVlOWNNT0s4bmRj?=
 =?utf-8?B?WFUwbnRGeE1rcnV6Z29kL0h1NmNCZVpSdHFWWXdKME1TZ1IrdEx4dTdQQXE3?=
 =?utf-8?B?bit0NWE0VG85TUxwNTFtdEdmZnBBbGIvUkE5N1BzNGZwVVdwMXFJY0dOTmR4?=
 =?utf-8?B?eng5bTdPZlVFYUZ4d0FmTEZIR0o3RExLaDY0UENiQWVUTElWRHpLZGJKK2o2?=
 =?utf-8?B?aHJ5aEIwbkF1eUNYNDRwZW9yN09hN3lwejJNVS8za24xUXR6L2JRc093OXBY?=
 =?utf-8?B?ck1tL1ZocGRlMnNJNTFsbk9lUmtHNEpnWWdKbjR5YnRnSjZpQXB1TVg3YnZ5?=
 =?utf-8?B?N3dJVFpVUWtmYWk4elVLZEwwZ0lIMVZjdGkybGRqRTdBWDJDVWFMR09JVldB?=
 =?utf-8?B?bXJnRSt4SHROanpQZW52dE5OSkpSenhtRDcrZVl4YkppSDlYSzNBTkU5TVBl?=
 =?utf-8?B?cFB1b3R4QVRPcmR4UHVmcmVIT1RRdTA3c3hZeXNRYmlpUUdnanYydGZhWTFr?=
 =?utf-8?B?TE5wbFlsTDIrOGVaR3lRVlI3L2xJUGdCbDR4YnJsSTFkMXYrbkczTkJxOWUx?=
 =?utf-8?B?V3BJRnJzRDJ6NnFJS2prS2hoS3lNbDhKaTducXBleXExY0pXRFFLdkRoS0RU?=
 =?utf-8?B?anpWRHE4WXU4N1lGdmpYRFBiaHVpMDBhbzRFclEzZVhtYVR5ZG5lMEtEWEt3?=
 =?utf-8?B?dGFhNER6MHdCSmdpYXo5NjgweHdRYVVKYktlamlITHJIMTFTWFBHU3VjSEJD?=
 =?utf-8?B?RGtqeGhBcG5VVWg3REVCUFR2djFsZ0RrVHZzZzhhQUtFbjhPQWdBWmVnV1Vh?=
 =?utf-8?B?em1OQkx2NFhqZXFtcUNqYi9PQ2hMdVZoSk10VVVEZ2FVWlhiVXVCUnNWSnVm?=
 =?utf-8?B?M2hYWVBybTZMUlNtVC9qeEQzV0pLSW5EWkFJWC8xZ1pRSHZRYkNjOHNUQ1VT?=
 =?utf-8?B?cHZXVEt0WURZUnNubXJFQzhXVHBTS2pGZHRDQ3Z0YitBWklvNVV6ajVrKzB3?=
 =?utf-8?B?RElJSFFVOGtZUzJhN2xrUi8wQ1o2bFliVWJqSGRyZFFFZ3kyOUtZZjVHU1Ra?=
 =?utf-8?B?T2dTNFJYMkZuLzlkWmY5UlBKVlo5aXRncW8xM2NJNmJKSlBSRWFkSyt0Mldi?=
 =?utf-8?B?djBsOHdtaUtBdFNieXhyOGx6d3BKVS82N2VPTVVBRTNsWk5sWC9vNFpJbEJP?=
 =?utf-8?B?R3pkLzBUQk5qYk1udzVEVGd5d2g2SzNZRm1FazkxSURJd3FqRERjblJzRHdl?=
 =?utf-8?B?RVU2QVZtYmt6MFBSQ0RENWJ0cFhRRU9yaGlxUE1BWmpUSisyVmVkQ0xFeXNL?=
 =?utf-8?B?K3lTQUw3ZTdhSCtiRVBja1E5ODRZNkZCOFlab2cyL3NKenpIMVZjSFlpZ3c1?=
 =?utf-8?B?c1NwajRMai9qQi9NdXRldVNOYi9MenBpTkdaVjhFaURkMXJLanlyRTArUG41?=
 =?utf-8?B?ZFFKQ0Q2eUVQRHNFZW1qQXhnU2NkNWFrM2JRajN1QXArR1NPUHAraHc0RTV4?=
 =?utf-8?B?eFd6VHN3bmFldXBoNzFPL0NsbERscVIwdDE3K0tYUmw0YnpyTURENFlmcVFx?=
 =?utf-8?B?MlBsYTFzTXRCNUEwUzFUVElLRDF1NGxnWURFQ21DWVRNY2lQLzFvSzg5ZEZM?=
 =?utf-8?B?VTFuYStTakJlaWk3Zk1GQU9ka0hYQjB3cnNwem5JbHZTMlRHKytNQWZtSFl4?=
 =?utf-8?Q?Z2eJQvv+SKUu2YBoTAMJdlxat0HOps=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0l2Ym5CaDlKRmRiQjhvMHFzbmVHTmMxdWRIc3I1UWZHaW9TV0t5S0tzU0s1?=
 =?utf-8?B?TU9mOGZiR0FGemVERlBSQW96RjAwanBvbUJZdzVSWE5HMU5xdFJtcEZIUkRp?=
 =?utf-8?B?UzdrOFE5Y3NDSVFXOWhCeitTMmY4dnlGaVhRVlgwSTg3U2V2bW94b1owSm9Z?=
 =?utf-8?B?U3BZSnduRVJCakhYTU5KTGlNaldKd1BTTU1zaUg4bEljL3hCU1pvZzBCTkZz?=
 =?utf-8?B?NWszMFpvNkRmeE9penlVRDZqKytNdFFVWTBRMDJGUDk3M2lPZmk3NjRYaElO?=
 =?utf-8?B?NVBEbEgzTVE5bnNEbHRZMzAwcVRXc2xhck1Ycm5peUZIZDg5T0dPZ3FVem1Z?=
 =?utf-8?B?MmNUeUZxOWZsaWUvMlBmVFZvMkxTWkVKOG5OWW1XVnhGNTVhdHROSE5WWms5?=
 =?utf-8?B?SUJmRktkR2wrYk1hQ2FLRysvSjV1RUdJcmxicjkxOHhTWkZNRzNOUmkvTGF0?=
 =?utf-8?B?M0xzR2FrM1FDTUdoeE9PL0w3Mm1Denc0eEQxdDIvaTlwa1hXNEZ3cVMxUkpF?=
 =?utf-8?B?cFFNT0o3UUFicHUxQ0xjYldCNnNPT25aN01FVS9nanIxbk9TNkZFMm00YVNt?=
 =?utf-8?B?WmVQTndzSnZ1Zk1ZZHpmc2drY1BXUUZ1TjRZcktKamNCektHdzl5bkFxSjhz?=
 =?utf-8?B?TU85eXU0ZldNejA2WnIzRWNvMGE4QWpqMUxScU5wMm5vYnNSSnlzTThYT1Fk?=
 =?utf-8?B?Q2xOOUhwQjFkWlZJWE4weUZ5THJYMGQ4ZS8rNkVwbkVLSUd1TjVPOXBocW00?=
 =?utf-8?B?QkIwZmJFbm5UZGhpWUtyRnRaditTQ2J5Z1ZWdmZ4Z1F5ckF0dmNoMTBUd29t?=
 =?utf-8?B?Q0hXL0JwNW1zVUVhRGZ2YjRHd3I5WkxXSFNHVXlvMnlKcGRCS08rSnpKeHNt?=
 =?utf-8?B?N3dKQmJLWThNN0xoZ2FIZ24yWlYvc0JMdXNmYmEvSmxvZmFFajZnYksvWGlN?=
 =?utf-8?B?QXdkek0wdGxEQTRJQXBWS1NuMGc5SHlNSnh3WEhCSnhwMzIzVld4aTRUNzN0?=
 =?utf-8?B?Q0hxUlYySmJHMGVKeWIrQnVWcC9CMlBlMnU3TGpzM0d5QlNqbDNXTkw5Nm40?=
 =?utf-8?B?SHhpNUo1OGVjUWEwRXE4Q3BQU1E2MEUyUEZFcVR5Zmw5MmxocldSTU5uZFlV?=
 =?utf-8?B?c3hwUlkxUGpva0NaY3QvSU14d3R4V1QxaFNRZlFQUVZYMkMxY3VsaTRpMVZQ?=
 =?utf-8?B?aUFJVTRVTWs0WisyR1M3TjlmaXZMVU1yL2hhSkZPYXlTRk9DQ1JRSjVZMUNX?=
 =?utf-8?B?Z0hTSEFLL0srVVIrRk9mZ2YzR3BhMEh0aXVuR3hTZnBDQmJ3UmpWMXc4S2JO?=
 =?utf-8?B?VklUUVlSNnh2TWlCSEpOVkRKaGc3VFFYMkZEdVdDRGZ1V0ovVVJYTmJ3M3BB?=
 =?utf-8?B?MmNNeXVQNGJlbTVTYmZ0VHdDdkR1OHE2YlYrMWNjZUI4bHY4TEFPU3dKRWpM?=
 =?utf-8?B?WFk3aDAwOTdSTHpXTk1mVVhBWURlNXpVL0xTYzh3cTJSMHRLbmh2eXVVd1Rz?=
 =?utf-8?B?RHdySUJKT1lkZ0xVL2MwSnA5MWFsQWFmYVNsa0UvSUJ1NUhPL0VSSy8reGVS?=
 =?utf-8?B?Z2dvTWlUM2RlV0NTUmIrNFVzay9wcHhKZVJmKzhha2l3amFSaTZBQmlDOXBT?=
 =?utf-8?B?WnN0WUkrcjVURHNlcklTREI2aERWOUtmazhqQ0NuSnRadjNSUjZNYU93d0ZI?=
 =?utf-8?B?S3dXUytNbC9pd1czTEw1dDlyejNOM3BkMVhGMDJpZTBaZ3k2a3dyOXhVRmJO?=
 =?utf-8?B?aHVuUEI3TzdhQ1JwZmRYV2h5bkhyb05BWmxxSllDUjlrQmszcEt6eGs5dU1Z?=
 =?utf-8?B?Ylo5YTFuODJLajUralR5RDR5a25FWDFEY3R2UTRpVExMbmorY2wzcWRsdWhB?=
 =?utf-8?B?KzlhZGQ4QWprWGxMWjlFODhpdXlBTHZFNG5UbWM2K0JWMG5ZNXBLN2gyMzhk?=
 =?utf-8?B?cndMNzJ2eDhTYStsSEZBODJPcURiR0xMYWhrS1VwRDZKcU1sQkJRRnBmODJK?=
 =?utf-8?B?NXcya0plWG81cUllWVpyUzZRdnVVeS9hclVtU3U4ZEl4V01NYkRIWGgvY0FT?=
 =?utf-8?B?TUFBZnIwTk1mMmxERGNjOTJSWW9VNFVUenVONmo1cmFDZmxDQmI4Ty9kb2hR?=
 =?utf-8?B?elNjd1dwamtFampDeEUyV204UGpYWU0vMUJFdEppQ3lPZ1REdTBoQ21oeGlH?=
 =?utf-8?Q?bKqHC0ABVU1VYH9l8wEG4KHwe002N9jPw6x6BqJzK7TM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eb596e7-2f3e-49fc-af9b-08ddda712b36
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2025 13:56:14.7035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XlxDcrQ3/vsi6OzwmKN/Fby7J3CCqPrrUpWCLsrbhXZwuJlyXXeAQ0gebu5eIzsz5rTgzVOeXuMrtOLMyFP5gSPxnKt5p2L36KdRmRRKX5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4946
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEF1Z3VzdCAxMywgMjAyNSAyOjA4IFBN
DQo+IFRvOiBSZXNoZXRvdmEsIEVsZW5hIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPjsgSGFu
c2VuLCBEYXZlDQo+IDxkYXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IENjOiBzZWFuamNAZ29vZ2xl
LmNvbTsgbWluZ29Aa2VybmVsLm9yZzsgU2NhcmxhdGEsIFZpbmNlbnQgUg0KPiA8dmluY2VudC5y
LnNjYXJsYXRhQGludGVsLmNvbT47IHg4NkBrZXJuZWwub3JnOyBqYXJra29Aa2VybmVsLm9yZzsN
Cj4gQW5uYXB1cnZlLCBWaXNoYWwgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT47IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7DQo+IE1hbGxpY2ssIEFzaXQgSyA8YXNpdC5rLm1hbGxpY2tAaW50
ZWwuY29tPjsgQWt0YXMsIEVyZGVtDQo+IDxlcmRlbWFrdGFzQGdvb2dsZS5jb20+OyBDYWksIENo
b25nIDxjaG9uZ2NAZ29vZ2xlLmNvbT47IEJvbmRhcmV2c2thLA0KPiBOYXRhbGlpYSA8Ym9uZGFy
bkBnb29nbGUuY29tPjsgbGludXgtc2d4QHZnZXIua2VybmVsLm9yZzsgUmF5bm9yLCBTY290dA0K
PiA8c2NvdHQucmF5bm9yQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MTMgNC81
XSB4ODYvc2d4OiBJbXBsZW1lbnQgRU5DTFNbRVVQREFURVNWTl0NCj4gDQo+IA0KPiA+DQo+ID4g
Ky8qIENvdW50ZXIgdG8gY291bnQgdGhlIGFjdGl2ZSBTR1ggdXNlcnMgKi8NCj4gPiArc3RhdGlj
IGludCBzZ3hfdXNhZ2VfY291bnQ7DQo+ID4NCj4gDQo+IFsuLi5dDQo+IA0KPiA+ICsgKiBSZXR1
cm46DQo+ID4gKyAqICUwOgkJCS0gU3VjY2VzcyBvciBub3Qgc3VwcG9ydGVkDQo+ID4gKyAqICUt
RUFHQUlOOgktIENhbiBiZSBzYWZlbHkgcmV0cmllZCwgZmFpbHVyZSBpcyBkdWUgdG8gbGFjayBv
Zg0KPiA+ICsgKgkJCQllbnRyb3B5IGluIFJORw0KPiA+ICsgKiAlLUVJTzoJCS0gVW5leHBlY3Rl
ZCBlcnJvciwgcmV0cmllcyBhcmUgbm90IGFkdmlzYWJsZQ0KPiA+ICsgKi8NCj4gDQo+IFRoaXMg
dGltZSBJIGFjdHVhbGx5IGRvd25sb2FkZWQgdGhvc2UgcGF0Y2hlcyBhbmQgYXBwbGllZCB0byBt
eSBsb2NhbCwgYW5kDQo+IEkgZm91bmQgdGhlIGRlc2NyaXB0aW9ucyBvZiB0aGUgZXJyb3IgY29k
ZXMgYXJlIG5vdCB2ZXJ0aWNhbGx5IGFsaWduZWQuDQo+IA0KPiBQbGVhc2UgZml4IChhbmQgaXQn
cyBzYWQgd2Ugc3RpbGwgbmVlZCB0byBmaXggdGhpcyB0eXBlIG9mIHRoaW5nIGluIHYxMykuDQoN
ClNvcnJ5IGFib3V0IHRoaXMsIGl0IHNlZW1zIGxpa2UgSSBuZWVkIHRvIGNoYW5nZSB0aGUgZWRp
dG9yLCB3aGljaCBrZWVwcyByZXZlcnRpbmcNCnRoaXMgb24gcmViYXNlcyAoKA0KDQo+IA0KPiBO
aXQ6IGFzIHNhaWQgYmVmb3JlLCB0aGUgay1kb2MgY29tbWVudCBkb2Mgc2F5czoNCj4gDQo+ICAg
ICAuLiBpbiBvcmRlciB0byBwcm9kdWNlIHRoZSBkZXNpcmVkIGxpbmUgYnJlYWtzLCB5b3UgbmVl
ZCB0byB1c2UgYSBSZVNUDQo+ICAgICBsaXN0LCBlLiBnLjoNCj4gDQo+ICAgICAqIFJldHVybjoN
Cj4gICAgICogKiAlMCAgICAgICAgICAgIC0gT0sgdG8gcnVudGltZSBzdXNwZW5kIHRoZSBkZXZp
Y2UNCj4gICAgICogKiAlLUVCVVNZICAgICAgIC0gRGV2aWNlIHNob3VsZCBub3QgYmUgcnVudGlt
ZSBzdXNwZW5kZWQNCj4gDQo+IChoaW50OiB0aGVyZSdzIGFuIGFkZGl0aW9uYWwgJyonIGJlZm9y
ZSB0aGUgJyUnLikNCj4gDQo+IEJ1dCBJIGd1ZXNzIGl0J3MganVzdCBhIG5pdCBidXQgbm90IGEg
YmxvY2tlci4NCg0KWWVzLCBJIGRpZCBnbyBhbmQgY2hlY2sgdGhlIGtkb2Mgc3R5bGUsIGJ1dCBt
aXNzZWQgdGhlIGFkZGl0aW9uYWwgJyonLg0KV2lsbCBmaXguIA0KDQo+IA0KPiA+ICtzdGF0aWMg
aW50IF9fbWF5YmVfdW51c2VkIHNneF91cGRhdGVfc3ZuKHZvaWQpDQo+ID4gK3sNCj4gPiArCWlu
dCByZXQ7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIElmIEVVUERBVEVTVk4gaXMgbm90IGF2
YWlsYWJsZSwgaXQgaXMgb2sgdG8NCj4gPiArCSAqIHNpbGVudGx5IHNraXAgaXQgdG8gY29tcGx5
IHdpdGggbGVnYWN5IGJlaGF2aW9yLg0KPiA+ICsJICovDQo+ID4gKwlpZiAoIWNwdV9mZWF0dXJl
X2VuYWJsZWQoWDg2X0ZFQVRVUkVfU0dYX0VVUERBVEVTVk4pKQ0KPiA+ICsJCXJldHVybiAwOw0K
PiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBFUEMgaXMgZ3VhcmFudGVlZCB0byBiZSBlbXB0eSB3
aGVuIHRoZXJlIGFyZSBubyB1c2Vycy4NCj4gPiArCSAqIEVuc3VyZSB3ZSBhcmUgb24gb3VyIGZp
cnN0IHVzZXIgYmVmb3JlIHByb2NlZWRpbmcgZnVydGhlci4NCj4gPiArCSAqLw0KPiA+ICsJV0FS
TihzZ3hfdXNhZ2VfY291bnQgIT0gMSwgIkVsZXZhdGVkIHVzYWdlIGNvdW50IHdoZW4gY2FsbGlu
Zw0KPiBFVVBEQVRFU1ZOXG4iKTsNCj4gDQo+IEl0IHNlZW1zIHlvdSBhcmUgb2JzZXNzZWQgdG8g
dXNlICIhPSAxIiwgcmF0aGVyIHRoYW4gIiE9IDAiLg0KPiANCj4gSUlVQywgRGF2ZSBzdWdnZXN0
ZWQgdGhlIGxhdHRlciBbKl06DQo+IA0KPiAgICAgCS8qIEVQQyBpcyBndWFyYW50ZWVkIHRvIGJl
IGVtcHR5IHdoZW4gdGhlcmUgYXJlIG5vIHVzZXJzOiAqLw0KPiAJV0FSTihjb3VudCwgIkVsZXZh
dGVkIHVzYWdlIGNvdW50Li4uIik7DQo+IA0KPiAuLiB3aGljaCBpcyBteSBuYXR1cmFsIHJlc3Bv
bnNlIHRvby4NCj4gDQo+IEFuZCB0aGUgb2RkIGlzIEkgYWN0dWFsbHkgbmVlZCB0byBsb29rIGF0
IHRoZSBuZXh0IHBhdGNoIHRvIHNlZSB3aHkgIiE9IDEiDQo+IGlzIHVzZWQuDQoNCkkgY2FuIGNo
YW5nZSBpdCB0byB0aGlzIHZlcnNpb24gZ2l2ZW4gdGhhdCBJIGNoYW5nZSB0aGUgY29kZSBpbiB0
aGUgcHJldmlvdXMgcGF0Y2guIA0KDQpUaGFuayB5b3UgdmVyeSBtdWNoIGZvciB5b3VyIHByb21w
dCByZXZpZXchDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
