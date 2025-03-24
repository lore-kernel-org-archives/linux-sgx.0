Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE22425C71A;
	Mon, 24 Mar 2025 12:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742818908; cv=fail; b=s0IVqopCdP4hEQcM12Gtuysr8a2P7BCjXpCWiVhO4okyqHK8rM2juyAYwj7SB0R61esf3Y+MvXlCujYirsZ2kFu9JGl3zJspTXqqB412X1vPiEg8xhUuKdHfsR8BK16NR3eKfkS+l/YeV70fsyhq1+IkIYNb7W5pkKIS/6Hx9eU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742818908; c=relaxed/simple;
	bh=4ljasCakI7m8/zXlxQfhdIaWkI/HT9dVFn2eGlf30FM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cq+xgK+k3HWWNI8SEA3G+3Zs/4LdAdpc0zIiOCHCvunFx5MC0uXy9Xk9bwg8rmc82E/DC6rxhZq9w4swUu8sngQCR68DxCa58bOZpVVkSQG/fYaV+ehtzETCzSKxUiF3tt8kqNk/oPcMDg8+1l1jzjrpn5yrIw9/gICXypVcNfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FP57ob4y; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FP57ob4y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742818907; x=1774354907;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4ljasCakI7m8/zXlxQfhdIaWkI/HT9dVFn2eGlf30FM=;
  b=FP57ob4yODyUaOHu340F7dLE8dIMv1+ALTDGI11NeASJJJePvD9ueJZE
   fawQ+7Z2sv4asfxtMj7sPyryIAxt5urHKTKiWlhwITITaxXryaPAKTaXx
   4PubUPP62Ft2DoPzGyTwmcFAmkfNNBBlhk4SuIv78NklqR63C5j4+qDLP
   mMzbSPqMiyfctw+fn9Qh0YMS57Wy6Ahg5/Mmnix/3pB52pPXPyTQw/zc2
   ihcNff7v6bEsAeT5FNMK88CexHw9fM+Qhwos3R00Eoohu5dRnOayBWqye
   DxzK2jpTHEx5yilGOJMFfmkuvMH61bpgCbuDMVUsEFQTSUcgVDC2SYaAN
   Q==;
X-CSE-ConnectionGUID: LZxljggbQYqgApMyGPWN9A==
X-CSE-MsgGUID: k42zuXO2RJidSuJBc9ZvBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11383"; a="43896829"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="43896829"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 05:21:46 -0700
X-CSE-ConnectionGUID: GyrGhlcUSFy7nc/KkIQ12A==
X-CSE-MsgGUID: /Un6sBH0RO2Qfpug3jPqcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="154940283"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Mar 2025 05:21:47 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 24 Mar 2025 05:21:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 24 Mar 2025 05:21:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Mar 2025 05:21:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OzMj1BKCMAj5rOlRuVKhNgJhj+NS3OCEUdeb4QKy+RHmVSCAEfxcieEq02Kzv4BSYpQGLAyOX6ukYoaQ1ne5NCWYm8uwGV4VgvbDyv8m60nn0u0EKe6oZ0E/bTmp91Bzz2+AlDI9lYx091eYVZw/KnkkVAL4kMdtNi3cmgkhuFxY+K1V3iC3AuCbJdAvRydIyK7kkLH6Ttuw3Gn4Y05h1H35LS3VZ6bZxQhhp39VKxPoWIDDJzqS9t3UM772sR5o2S8kxEfphVQtfnmSu7/Gfxlmc4I+gHKqTFE0DzBka0oqmZgVIxFPRE70u+amRkzCtDAIMvnYJlXCnFoXORJcmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ljasCakI7m8/zXlxQfhdIaWkI/HT9dVFn2eGlf30FM=;
 b=o7jFFhTpShVyUdJpOvepN3aUpLYS2jeh5p47+w7Rj541CKYE9Vx9dILE5hAITxTW/zIuyrk7c0vu8kPjQX3DDAqAT/l0o/PfjvSqQC21yuivGMY9cVhMSlGskejQ583jf/AOOTDlLQISCO0PjD/KZlbtWs6Nn+dbj614/IxnzV1IE0DHA0BSAV8u4cMs/vngI0CLM0L+VL6v3uDv3BI9fjJMkbru+RPoEMLW3Hzq3Fpjwo54p0x3rguBffDXFoMYRQ01uOMDcldlYPM4zjlTfpgyMRfTaRmChd5dNCMmJdwK7HfUCMISysVlHyRekETIm9slKY7V9DhAJMNyRDrrMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SA1PR11MB6992.namprd11.prod.outlook.com (2603:10b6:806:2b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 12:21:14 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 12:21:14 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>, "Zhang,
 Cathy" <cathy.zhang@intel.com>
Subject: RE: [PATCH 3/4] x86/sgx: Define error codes for ENCLS[EUPDATESVN]
Thread-Topic: [PATCH 3/4] x86/sgx: Define error codes for ENCLS[EUPDATESVN]
Thread-Index: AQHbml5snyYEa5bXK0yUxAJfnWP9TrN/s2iAgAKF9jA=
Date: Mon, 24 Mar 2025 12:21:14 +0000
Message-ID: <DM8PR11MB575028B19C9C23E6EF31357FE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-4-elena.reshetova@intel.com>
 <Z98wDd_eMCFE40Z7@kernel.org>
In-Reply-To: <Z98wDd_eMCFE40Z7@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SA1PR11MB6992:EE_
x-ms-office365-filtering-correlation-id: 3ecb393a-367b-4415-7036-08dd6ace5eae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q05CdXYzZW54TzhVWmRKQ0VmckRNbGg4TVBrTGUrdytudkF6WjhjcXIyRC8r?=
 =?utf-8?B?Z29pUmg3TEtoMWYvSGhyRFVUQVBhMHZqMkZBVFhucUwwVzhpYTZNS0Jyc1FN?=
 =?utf-8?B?V2ZMME9NSmYwak83b0lUa0RUVUxOOStpQ3lpSUhMbm04aDV2cXhWSzVtcXk4?=
 =?utf-8?B?d3picGduRWlZWkpVQ0FMdzJuQ2JkTWRSSTlMMmgwRkI0ZnlDYlAzRGNPbE1T?=
 =?utf-8?B?YnN5ZlBmYnhvWmNwendtZ3piQXArbE9jYTN1YjRMY2RxVkNaa3RVS3h2YUhx?=
 =?utf-8?B?dzRvbndPUmpaNHpvWUhxSVAxQkVvV1B5aVVtYzhGYlBXcEhxQzJsS1hsZnpo?=
 =?utf-8?B?V25FajcvVEN0a004SFZuSDNVKytheklXejhFTnZmREhTN2doVndvOHFybDlL?=
 =?utf-8?B?MHhPSXRMUjlNbUxBL040ekRCTWxkaFBYdjltdFRqTzRtbWxLeU9SWUVkTVM0?=
 =?utf-8?B?aDdrNE8zcE91ejlIeWcrYS9rZEVPNXEzdHR0MjB4OTBWdUxoYVhXWTVwUlVG?=
 =?utf-8?B?am45TnNvbGdiaXlkR3VBL2VRbmNmemRmOUtrSUVSUUtxeEUyY2UrVVBtS1ln?=
 =?utf-8?B?bFk0TmpLS3JCbjc1aFBkR09qOWdWMGZvdXcyeDcxM0pUakxoN3dpMU9JdWVu?=
 =?utf-8?B?bC9YUDZkMVBkdjFURVFoZEVSTm1qeWFtY1d4aDhtcll5bzA5ekZ5R1duSUFz?=
 =?utf-8?B?WFJqSGozRDljTDk1S1dIL0JpMkxnVFg5aU1YeE54Z0ozOHZ2MlJaOG5QRnVl?=
 =?utf-8?B?aFYrTDc1WmtsT3EvUjV5QWpWeXJpREl0Q1pqU3NianRPNDltcmJPbUVBN1Rm?=
 =?utf-8?B?NWF5dCtHd2N0YVNWN0diWUZXZUE3MjBRNDk3NVJXWkpqSnBaLzJoQ3lVK0pB?=
 =?utf-8?B?K3J2S0ZiT3hQTDJ1TEpEQWsxSEY4VndjOGFOMkkyZFA4QWJ4ZnByT3B3dFEr?=
 =?utf-8?B?TWRURW5hZlRtbUtjQXJvQzVMVlo0OU1pek4rNjlRNkZOTFlMMWFSclJ5KzNw?=
 =?utf-8?B?OFowU2dzOGZNcmc0aHVoRzJ0a0VGUW9vOHZESE4rVUFKZW5XajFzdmZtalJW?=
 =?utf-8?B?VEwvVDBVbURWcklNTStRN3lreGxWUlRxUlBTT0NiSFNoMEVtWFhWL3R1ZlJQ?=
 =?utf-8?B?LzE5RWdTeUhtc0htTGkzdTlYNDdIUHFBYjd5cFpGaW5acVVpRC95a2U4WHli?=
 =?utf-8?B?MHFhR2Fta2htMWMyN203VU80b2FESk9qUjdIWXYvTjlNZ3NrUGZmL09QVmZt?=
 =?utf-8?B?NlYydWxCbEVJL1RkRkpjYXVNWmZZMlZxRkhwdGxHdGMwckhtTWFCdE5ObFlv?=
 =?utf-8?B?TE5GWTFScitNTDV4amI2YnE0K2FBdTg5eDloSkU2VThXZXBQcHRCQXhkV3BY?=
 =?utf-8?B?TlpWMU8xT0VHOXpSRWIyU3I3M2xSREZjQXFPUFV3K1JVc1NEZW5ualZxYW1D?=
 =?utf-8?B?Y1FEWVpZYnI2SG9TZ3o2MTRKWEpVdjJiaTN4cCtoY1pQb1JnM003Z29xV1o1?=
 =?utf-8?B?OUkvTW5NalZaekJueGVZcVh0ZG9HK2M4bXlmenpPSjc3Zmh0ekRVbUNPMXdy?=
 =?utf-8?B?YWhPdTdaM3diV3Fqb2NLa01GY1BTUU1ENVRVSlJsQzEweDMzdDhRYi85TlpC?=
 =?utf-8?B?MTdrbVl6UE1WWHlGZEhhZGdnMXF1bkNDdDBNdHZoUEU0RUNUdVZGSHJtZXJs?=
 =?utf-8?B?MU9hcW8yR1VkYTFybjVhNldDS3pBaVFmZ3hIMmZpVDRqMGs3QmFyK0doUS90?=
 =?utf-8?B?eFBSNXdzTURDSlZyREJHRUNZcmR0Z3UwOUMwZDhDaFUwOEk1aE56dU5FRi9Q?=
 =?utf-8?B?UFlDZERaUzFGNmVwZU44WVRNaGNvdDVDUnl5Rm9sRlREcGJVRURqSDNGN3Az?=
 =?utf-8?B?cyt2NlpyREx2MTR4Q3ZsUHJwS3Y1TUhqbFFUNUcwdEFtMVR5MnkxRDJaNklv?=
 =?utf-8?Q?aFRCz7g+a9NmTRpSpH2bAQfLpfAue3lE?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWJXeXpTWE43UnpTbytSdkYvMzMrZHZabHlSWklVVHdsVldjV1dVY1BIY1Fl?=
 =?utf-8?B?VnFRSVVFSkw3NnNKTG1OTUg0Wi9JZU1uS2NMZlh6SjRRVXFnaU42OUZ5ZU9B?=
 =?utf-8?B?NHJkWXRndXNzdEw5WEdtajBmejdZcGMxbllVVTZrVjNlS2FMVGduWWlmK3V4?=
 =?utf-8?B?SUpreXJlaUZzNFh1enc2ZmNsTTJiOFFuWXF3TDhnSW9KUGpFL0xRWjhNbzhW?=
 =?utf-8?B?dmFDU2ZlWUlZbkl6WkNFSTRNV0ZQcnN0RkcvaUJPTmo1dGE1azZ1ZVVoT1Fr?=
 =?utf-8?B?UHpxUVZKNVNaMjc5Mk5oa0NsVm14Y2dPck9NZmlhcTcrakpFYW8wTHpUWkgx?=
 =?utf-8?B?KzdTVUVJdkxxYjFFT2k0eUlPQVYvL21YbXRlNVl0ZjdVTi9aK1VjMU9Tcmtj?=
 =?utf-8?B?TFBNN1hReEJ5NitKOFlHUFpKUUJCZW04UFIvT0psSCtwWVZOV0hrbVJROUZG?=
 =?utf-8?B?YzkwaHkzTTZ5U09mMlExR2FsQUlLdGpsN2d3YldjM2FLN3Z1WlBVUVNMYjJZ?=
 =?utf-8?B?VHliS2FpeCtjZlZTWGpNZWFZaExSYkxPcjYxRzVDQktocWZxU1V0Lzh3VTlv?=
 =?utf-8?B?RmlsN3dXbEtSckcrdFBMOFZDVzlwN2dHYmppK0svM3JIKzVKclhjOGMraWRL?=
 =?utf-8?B?QzZqYW9mT0pqYVZESjBtYlZYa0NHUUdua0tnRjJxK2Q0UjE0YTlqcjhqT0cx?=
 =?utf-8?B?SnFNTGFSdWNSOXVJeGxEWVpuckpxbk1ISUV3VTRXQWxiVTFRTVVyZkh4djlu?=
 =?utf-8?B?OWJqemhhV1l1VU5ZUFNiOVZvVS85YzhLbW1mbXRIS0M5V3l5bE9TdzQ0TVNB?=
 =?utf-8?B?aUxSQUUrbGtPQjVjanFQenRZb3MxTHllYitMclRsclEydnJsUUlwZ1ZLY3lG?=
 =?utf-8?B?MWZJUG9rVUhEVUFjQmhqeFNNUXJPVWZmYUZRd296bUVJK2JDNWJYa1c2WGI5?=
 =?utf-8?B?bGpGYzFqTTRYNzkzYWhmcW5oZmZ6NmVpZVliYnVCQzhHZTI2YWFQeE56YkFU?=
 =?utf-8?B?MzRBUlhTYmQ4aCtQUVA2YVRvZDVoSHhJaXh4ZXY0cFcvNzM3aXlIcE9oNFJR?=
 =?utf-8?B?S3dPRUhjTmhNVGxSZStkbE1FaFUxazFaTUIxVW52UGtyVnd5UkdWZTdUUHFJ?=
 =?utf-8?B?M0JCZVpFNG0xVk9kMHkzSzJWL2xaSWZnaEhhNExvelluRHN6eEtLYWlmYWxE?=
 =?utf-8?B?YVlQRmEweDJzS0JjeEVadkkxc1hhbzNOVW5IOTY4SWttSHZVQ2xFZTRiUVM5?=
 =?utf-8?B?N2RJWWgwbVhjVFJMTFcvRGJKZUZLMTZJRm5wZUJHdzFoVnZMV1ZZa002K214?=
 =?utf-8?B?bnkzTkJ1M2FVUHMrdDdDQ0tObGFTSDFkcGE4TjF5YW55VnlzbGFnUzhTWUpa?=
 =?utf-8?B?aXBmNW1GSHlRaVlRVC95RkNtbmtQVzlTcUlhZ0VDSUpTWUw2OU1uejVZQzVH?=
 =?utf-8?B?aldzbTNmbmlpbHJjVE4vdmowVXdiVmNhUzJDYUVOUjZiVWNraHl6d1BNL1JW?=
 =?utf-8?B?WkRMRTl4SCtZejNqOTBKRzhBVjhRVSt0ZnVsV3RjNlBsR0JWSDA4MWpIL0lw?=
 =?utf-8?B?cFhFU0Q3TUtjSmQzdWQrajZ3M0tlRWFNQkF1NEtreDNWekJPc042cTk0YmFj?=
 =?utf-8?B?UWp6MWRaVUIzb1N3L2dHYm53OXVtQ0s1MVdVUXIzVG4vY29RUmg2ZytKSHFx?=
 =?utf-8?B?RytLaXNkM3J5bDVkQlFBZ1JKMEdNMGJTSjk2M29CSm9DL0ZFNXdqcXh1WmRa?=
 =?utf-8?B?MU9iakNDR2lrc3hTNUdYKzFTMmhkOWIzUjlsMG1LdHBkSlM4a0xxMGZnWVhz?=
 =?utf-8?B?dHJCT3RmTXAwVkNJSXZTRTNQWFNPRGtmd1ZIRlJoU2JIT2RyVzJqQnZiOUtJ?=
 =?utf-8?B?RXRXWGowcmRYS3cyeVA5cUpMRC9oUmV2MVNuQ2x5MlAxc3VsRW5nWXZoMjVE?=
 =?utf-8?B?TVNMTjlyYldvNFdDV0lVdFNJY2hrOGcxdW4xWEJ3TStmdloxV1l1ODQrOGJm?=
 =?utf-8?B?UUYwdnExYTVoYnlQNUlOOGR2c1Z2YnhaZlV5eTY0TTRqcUIrTXNSS2hvUitS?=
 =?utf-8?B?aUw5ZDFMalYzOXRaem9jTDZTcHVMRDFWR1hJL25CTStlcnk3bHZPdFZaRmsz?=
 =?utf-8?Q?OJ0Kwkts5Fnjn0MMrg1A8Pcq7?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecb393a-367b-4415-7036-08dd6ace5eae
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2025 12:21:14.0356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DYzR8HwjVBC5nWk3hOeVRXVHxKdOV+QnvyRpp6JXFF/9Wfg19kZO7fUzYF/S2DErI3f8+sD2UhEPwkJMV+hklR08BJvFCQq9+Bpt/9Ukkyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6992
X-OriginatorOrg: intel.com

DQoNCj4gT24gRnJpLCBNYXIgMjEsIDIwMjUgYXQgMDI6MzQ6NDJQTSArMDIwMCwgRWxlbmEgUmVz
aGV0b3ZhIHdyb3RlOg0KPiA+IEFkZCBlcnJvciBjb2RlcyBmb3IgRU5DTFNbRVVQREFURVNWTl0s
IHRoZW4gU0dYIENQVVNWTiB1cGRhdGUNCj4gPiBwcm9jZXNzIGNhbiBrbm93IHRoZSBleGVjdXRp
b24gc3RhdGUgb2YgRVVQREFURVNWTi4NCj4gPg0KPiANCj4gRW51bWVyYXRlIHRoZSBlcnJvciBj
b2Rlcy4gDQoNCllvdSBtZWFuIGluIHRoZSBjb21taXQgbWVzc2FnZSBvcj8gDQoNCg0KPiBEbyB3
ZSBuZWVkIGFsbCBvZiB0aGUgdGhyZWUgYWRkZWQ/DQoNClllcywgd2UgZG8uIFRoZXkgYXJlIGFs
bCB2YWxpZCBlcnJvciBjb2RlcyB0aGF0IGNhbiBiZSByZWNlaXZlZCBhcyBhIHJlc3VsdCBvZg0K
ZXhlY3V0aW9uIG9mIEVVUERBVEVTVk4uIA0KDQpCZXN0IFJlZ2FyZHMsDQpFbGVuYS4NCg==
