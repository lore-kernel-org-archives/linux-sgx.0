Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145491A0B0E;
	Mon, 18 Aug 2025 05:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755495724; cv=fail; b=iSUXdJdiZeYg4GHNkQsjy5kpTNObE9GkopfmeYnzMFirp26L5yP4qJzHsXDcHIB1mXVVLMY+yd6smKUcoVlwSnaKGJls/YWtzlazQQLMzES7ZhpIkrXV1zECv5bQ0wVr10zrxA5/rniR5b1tHFPUy24Z7uaHlEBkNGLvGUAoF4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755495724; c=relaxed/simple;
	bh=yHNN2XvBj2Af6Gab+48tz+5jL+lKGialCu2+b/KJWXY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bW8nsGDCOvds4ffpfFUd+exNJcRgt2cAkQMyAR95zcl5CiC9JQSfWqtdAwfIuHJc8AfvoLItqZlaoIkW64kbcM56zd0y/0OuDGONHlDazB1xAKxBC+28lkfE5XW7AkWkDF5Pp33NPkfBddjvrtP1U+Df5oqQY/7k4s0PwlTcZ/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aevvoias; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aevvoias"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755495723; x=1787031723;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yHNN2XvBj2Af6Gab+48tz+5jL+lKGialCu2+b/KJWXY=;
  b=aevvoiasv10CtJRfxEKSV4ddQ30AYyPsnTcITaxd81f7qmj74YiHEtNZ
   /5JjbcvjVzafrhzYBXzArqofhU8BGiWK29enKfidUW+zcLrKIVuSG8lPM
   ADDI47/wl3g/JuGStPh3blNF5fVxZQo+FiEJQp2jPsO+289egWuZKRNC8
   idVqkiIhL6KQoC/fa8uzBr785cl1r20YvmHxz6jGJTM/EJF6mVx7BuHEK
   Z7GzMJ7xPjBEDeM0DojrMH2U1pTumKxGtjB72epkaSTpRCveN1xxW7AMp
   PzM3NBbkmvPCaUKrfUsjvBeurvukUeUNiP/Vi7vngiMt1wdK3sGoKlr/J
   A==;
X-CSE-ConnectionGUID: oEo0Ct9JSc6t+Hbq3aKYWA==
X-CSE-MsgGUID: NNLf9EndQzuw2D6ThVW3/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="56919919"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="56919919"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 22:42:02 -0700
X-CSE-ConnectionGUID: Qj7IQejGT5+VF2p547ONrg==
X-CSE-MsgGUID: jYZp3liJQmq1AjkkTZRUmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="191185369"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 22:42:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 17 Aug 2025 22:42:02 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 17 Aug 2025 22:42:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.62)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 17 Aug 2025 22:42:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QJV/Grp1QsBkDziO4SaxvBuSZ2KFJoqy3RxUmvJrkIMApjvle7SEv3SYHUBp6GYOG+aK9C9aGW73fWjC31/exOb7MKZ6N3EI69x6SpZXXVXRSBF/0o5fFNh7ybttPVqlNPiosUELBdc0MSEPIWn87sloY0pUAK29zbSMUEh5myTC/qrUZN0HzvouuOQy/Q23U9o6q+hUO4P9ROhPOSN40xYUoZ4VKCT9tyeNsInQCu9cp2UQ1xqP+yrDqTBqcfy/4+zVaLiqQmLVinooZQKtTxy7hhlZkR9Jl2pQrEM9YHFtwKkqSYItkVm/N5i3SIlxtEDtTzcd+rw1czjkBaq+FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHNN2XvBj2Af6Gab+48tz+5jL+lKGialCu2+b/KJWXY=;
 b=iTXHdPsYKZnvbLHY8fDjAMq0yerTmoFXdndJf/qXBMDfmqrlv/6G0djnnmo6V8uPj9Ie9UvlxeUJSirnkNobFkQQ/MhGz3dT9yLJhA92tKlNIkljReD14Aa3+YmUzc4hOMaTOfvaK+/lQyDJRLshfdsHUAi2i16GNhPDf+Qb0PiiJZn4bKMQ0M8HhvMfxvovi28Ry6GBh8sDc8L9C84RXevfQV1iqUz9iN4GS27a0WmbEgpRGU+jsArXy46EFeZH7370Uqkx70lsVqJM9gNrc6bn09qY+gsDacIhBKbzSxasWbtOLXZRs+hkapW1P39cIUwNGj8UsCrrVtkysNWpfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 BN9PR11MB5260.namprd11.prod.outlook.com (2603:10b6:408:135::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Mon, 18 Aug 2025 05:41:59 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 05:41:59 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"mingo@kernel.org" <mingo@kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcDO5T+cs1fW4tzkm5n6kKNVsmGrRiXVoAgABQ6YCAAJi68IAEmhIAgAAHmdA=
Date: Mon, 18 Aug 2025 05:41:58 +0000
Message-ID: <DM8PR11MB575076B29223DA1C70EA35E2E731A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
		 <20250814073640.1507050-6-elena.reshetova@intel.com>
		 <4baa3bd4-cbc3-49b3-b8e6-09a2079c8363@intel.com>
	 <31d0ac3b0b25efde64d502755e7c5f4717fb7f38.camel@intel.com>
	 <DM8PR11MB5750EADDEFCA1160E6E75B0AE734A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <c9a730751f34087bdde3ea63a8c0d3a70b8d84b5.camel@intel.com>
In-Reply-To: <c9a730751f34087bdde3ea63a8c0d3a70b8d84b5.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|BN9PR11MB5260:EE_
x-ms-office365-filtering-correlation-id: 3b5dff6f-daa1-4350-2ef8-08ddde19f30c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?eHFkeGQrRnpxQmdKdDJSOUxSYzJDYy9aeTZ1d3BSZVFpZzM2QUpGY3dYOTBM?=
 =?utf-8?B?NThxYkZOZ2NLalBVNFhwdnh6Tml6dVNkUU9FeGpCNm43MTNjalQvcHZUZHVW?=
 =?utf-8?B?SW1WeUVuanAwUHl3YlE5cU4xaXQ5ZnVINFI1SUdTdjdVMHhtdkJUeTMvaW1l?=
 =?utf-8?B?YUtOa09pV0hMZ21meGNkVXVsSzN1WkZQeWpvQkh0dW9Ga0ZZZU5iK1ZRNHdJ?=
 =?utf-8?B?NjZ1eUc4SGE1ZndDNEZEeXZiU1hlVEIxK2RsOW1WK1J5aEhnZTRLVVVja3Ny?=
 =?utf-8?B?dGlINEUrZ1d4TWdLMk9SekdJcUJwRjB1dG9YeDhpcnJLU3I3cllESU43Nm9W?=
 =?utf-8?B?TXd2V3hLVVFuazFJY2tmWnZtK2NSZWx4eWhwdjFkNjRUVWhnYk9MVElCcXJX?=
 =?utf-8?B?czhyTVBtYnZnb3l4MnNZNWV1dUthLzMzR1QwYXkrZUJleU1pYlBIRkMxWVNh?=
 =?utf-8?B?bHhkZHNUM0greTRibC95RWtVdERUVzM2alFkVDFhM2VNOEl3N3ZpUmtpY2Fz?=
 =?utf-8?B?cHZFWm1oRnd6UU5rSnBxU29ybzd1aU93S2lNaWZaamk1NEo2K2NSdE5jWjFs?=
 =?utf-8?B?MU5xYjJDMUlZTWNnWmUzaG1XUXNNdUQwZ1YzeXdxS2ZWOXhYRDBwUXRRK3JN?=
 =?utf-8?B?eHJpMkIrc1VObkZQZTNHSzFiVUttcmhuRmlINHRDNVV0RGtnTVNvcWIrQzJj?=
 =?utf-8?B?T2wweHlhM0l0OXVxUlk0Y25wNVpMWDNVQzhxenMrSDl6aFVKZWg1aEh6U1B2?=
 =?utf-8?B?QzdoNDhHRzF3bmFHTjZwbFRsdnUrdFg3R0tmN05mRnA4bDg2UCt1SFA2ZHQw?=
 =?utf-8?B?aXloSk8xSnpUSkMyQmJlRUNJajVtdjZpWnRFdHowV2V6d0dmYW5kcitlTkYv?=
 =?utf-8?B?SUVsQzRXVExMSFZmbW1wU3NCRkJ0RlAxQ1VyL0dUZDZhY1pXaWN2STkyMnNx?=
 =?utf-8?B?ZlByVXBRTTMxaEVwbDF2WEpJRmEvTElSV1dwcDczM0o2TlByaVpqSDc0bkg5?=
 =?utf-8?B?V2c2WGQzS1JicnlNdDZScXE3c0FNRkdFNjJneW1VSlE0YVQvVWhjcGtLQ012?=
 =?utf-8?B?bzF4MytnWHZXR0VJVkxsZzdwaWFuZkRnVDlJcGhkck5KZmJ1QnR2NkkyNU5y?=
 =?utf-8?B?eXJibHZwNk9wVDI3VFRDSzBZQ3Q0bjl6LytrbTZWTkloYzhYQTRpRzFYL3kr?=
 =?utf-8?B?SjIrZGtnbWc4ZDByNDF6WjNxVmtieFV2eGg2eno2L09kQ3ZRdG9Takp5MlBo?=
 =?utf-8?B?ejg4c1dCaXZzZ0xhQjZ4NjRjZ1pTOHIyMzNERWIyb1U1MmdTb0paWmExSzdn?=
 =?utf-8?B?Z0NVZGY5UG9MWmtRNHNUeFQzUW1sWHdzZXVoRHJ1OTMvTGg2em1rQ3dtUVBp?=
 =?utf-8?B?c3NRTW9RTGtFR1pkcnY1Sjl6N0w5OW9SZlUrQVY5c1RhdU5odHBKUkZWd3Vn?=
 =?utf-8?B?cUlZLzBFckJmbTlCRnRTc0pObkRiZzVpSjl1U21kZFBPd2NOS0p1MXlnaEFn?=
 =?utf-8?B?RmFCUzdEdEZwWnF0TnJCeXpBS1g1ektVQmM0eE9KOGdqc1FGYXRPUjMxZG4y?=
 =?utf-8?B?R0FWTTBrSDRVemlOYU9UODgxVGZnZTFVeU92ZmQyK1RIUHQ4OFE2NGFWVmE2?=
 =?utf-8?B?WEFmdTliSjBVYjk2VDFlSlBvRjVmV1d4REZ6SVd4S2IvODlFSFVYSFlrMXpj?=
 =?utf-8?B?MjhjQXVRNjNkMW1HVGhEQ0RCZ2cvSjRaaDBkMHdCUkQwZGJ2WTNBZ0dzUEN6?=
 =?utf-8?B?VkF4STNmeitMeEc2UUQzV2wrWUkySGVZNHNKRnlJYlVPdjJPSXNHVnlaM1Zm?=
 =?utf-8?B?RXpGMEhmOFpyYUlDcDFwUmdzd2FPWkxDeGRSNTZ5NVBDZEppQzVDTWxIanFu?=
 =?utf-8?B?U1dJTVN3OGpqekM5aTFVZ0ZLL2ZqOWZOdXNQUzBJNDRkVXU0cEhPQW1ZTnZU?=
 =?utf-8?B?T3cxWS9KK3FTV1VobEN0emdhSk8xZkNrSXFSVUQ1dUc5YUxIVEVuRzFJWjlh?=
 =?utf-8?Q?iWy2+oaX0VNiKJkU21UekZWcj8s5sc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZW1TUEYzR25jNFdoNjh4MTBmLzE0bXlZTVo4MDQ4ZkxSaURnVncrMUVGaGZU?=
 =?utf-8?B?dHgwMkRRL0RYaGk4emhoZWllVHNJK1dDZG9BeXM2OURqQXdKcWhnUzVHZ0kx?=
 =?utf-8?B?dUVWVkE1SFVXZ2FCSFFYbU5LVitBSHNERVdXS2J3ZVhURDRhL0R3S1lRV1Qw?=
 =?utf-8?B?UER3VmE2QXJqaTFNcmZ3QUkya1dMS3NxWGJnSDhyd2NLeEZjdFlIQ3ZLWU54?=
 =?utf-8?B?OWJVd0VNQVpHT0tWR0V2NzR3S1RTK1JGdStpdUJUaGJ5RXlYNzh2NTA1Y0R4?=
 =?utf-8?B?Smh4dHVvWVJsRHg4Q1hENjNPbml4bWNpL0NOUzVVRDZqOElDeS9qekM2WlBX?=
 =?utf-8?B?ZUsxTDJtQ2hWTkRMV0pMSUdlbjVka1BPZUhCK1p3cUM5NTNRdkhwVjBRSWNB?=
 =?utf-8?B?eTY0UzlFcVkwNFFUUDN6TFgyV1UzT2pwQzJhRG55ME4rbkNJVjliTUd4ZG5H?=
 =?utf-8?B?b2tpb2JxNkVZbzVpdFppTzdBNUxMSGNRdE5obHZFNGEzYUtpQWhBWHhrNjQ0?=
 =?utf-8?B?S245VE9DM09pS0V1b0FBUnUzVlBTL0tDSzlhU1B4VlgvT1lCN0VNQXBDd29w?=
 =?utf-8?B?cHBJSzg5Q2Q0V1BJSUtxVVprYjVNL1VhRm81SHArdmNGSHJaRzRUcjB0bm55?=
 =?utf-8?B?a2JtU09zQldqN1RhWFdDNkVhbjNCV1QxL1FlUWR5Qmt4TkU1WWN6OHF6UlFr?=
 =?utf-8?B?d0FFeVVwdjAySXhWZkxtVlZrdnRreHVXZ3BNaU55Yy80V25VVHhJWUdROG10?=
 =?utf-8?B?N1I2NTBGOG85ZUpXWUozMjh4TTVDMFZXQlF6WGhFbmJ0TjNNUDBFTTQ2Z3Nk?=
 =?utf-8?B?SGt3YXRLdVBsaDNWeFh6M1ZnRXpGeWNzdWFhR0hTeHZWVmV3eUwvTGQ0bkVS?=
 =?utf-8?B?K24rUk5wdFRpSzIvOS9Nbk1KbXdLa0NzdVk4aVBoRThZS2hYTlZaWHZLQzVv?=
 =?utf-8?B?LzlZUHMveTlBTnF2ekZLNVlHTXg4YkRRZyttdEZ4akVRa2ZSOUhiWitOQVVZ?=
 =?utf-8?B?UDZvUzZmQXV3YUZIcHYrUzBYd3lFTUNCSFNvaWtQdVJNWHAwajhtZ2xIcmdV?=
 =?utf-8?B?OUxZTlZiTm96MHFLTVZzTHF2VjB0eEhZYjE1OG44UUU4YmdJeHBQN1Nwa2RL?=
 =?utf-8?B?TkU2K2tIUVZKZUI1cllIcW1ON0FLWWluUmtwTE55dGVudEMxb2JGVjdiMldW?=
 =?utf-8?B?Q1ZwQXJkMXp6dE43Rk5pQ1pXOFRCcXZjZzVBdkpjRTlsVy9JdEpFOVQva0xo?=
 =?utf-8?B?ZmM1SFBGSlRIaklMZmcycE5jMVFtU3dqcEJzRmUyd1Yva2p3aVBkbjVNZ2pL?=
 =?utf-8?B?di95WmZaYlMvN3RIWFpHY01aSFdiNmxTLzVZY3ZjVlUyYm5RQ01KLzg5a2Fw?=
 =?utf-8?B?aGJWRkZiaWQxSEcvRm02MGVPQ1M4S1JIb3JoZFBjMDZ3UXFDWFBVcFlnTUcz?=
 =?utf-8?B?bmtvM09NVlhWNWtxYmxwNGZKK0xrSDZwWmxrY3RqdkhUd3J4TmZ3WVQvNWlP?=
 =?utf-8?B?QWNMcEFqTnNuUk52a3RYaFUrTGNMUThWd1NacnU3dGdDekNac3FlY0hnYXFV?=
 =?utf-8?B?WWxoZmJxenduMEg1alVabEppcDZnbEJQMFNYYW5LN3E5VWdQSFI4dDkwWlph?=
 =?utf-8?B?dS93cHBWTEUxdDZXUXc5WGR0MUFDb3kyeFVqWjdNeTF2RVpEOS9FdHdOVGxp?=
 =?utf-8?B?Rm43SHlYRDN1NTZ6LzFuWUJmQ2lWUHh3MzhzcWI1UXBQNjkvQ1ZhVDJpV0JF?=
 =?utf-8?B?dVRaT0FqVzd2dTduaXZXK09lcVN2NkF6RVFjZU02ZzBVODJ1QVhiUHhaR1Rr?=
 =?utf-8?B?TTV3U2NBSmYvVFdnWVZvWWpQZUQ4YXlObkJJK2JvOEIwdlNSTHVYZVlkcjJJ?=
 =?utf-8?B?OU9zQXZoa0ZWWXRxY0xpNjJBZ21sNk5QSEpvMG5JK0IwTzFoNXhWYlpWZjBL?=
 =?utf-8?B?Qnhhd3ZUU1hHNDRZbkVuWmkxUHp3SDMvekFzSFNXMlZZeDQxOEVka1lqM2Fk?=
 =?utf-8?B?MXhwNkJob01IbU1hcGQ1MTJ1UWw0MlB3blh6MmNkc1Bpc0hja053MGNCMjhZ?=
 =?utf-8?B?SkZzQVZ3bkN0WE5CcFl2MnJYYUpwajliNWt4QTFiRExvMnVLWHVocmJ0VHl4?=
 =?utf-8?B?bEJidmRLUEEzcWZubnRvaHRnajhHQUpFUHpLbE5qb3NzVFZIUnMwNjdtV0RD?=
 =?utf-8?B?cnc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5dff6f-daa1-4350-2ef8-08ddde19f30c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 05:41:58.9275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ytwnv8SbHw3RpXFfyjwW6aiTIE2Dl4UcqeSOIA2kIQDTUYHRcHGVdqM+9S5IKZ6NvyS8OBAaOaN24IMnv0tuIlVMo3f150vk0D4eJkU8P5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5260
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBBdWd1c3QgMTgsIDIwMjUgODowNCBB
TQ0KPiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT47IEhh
bnNlbiwgRGF2ZQ0KPiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPg0KPiBDYzogbGludXgtc2d4QHZn
ZXIua2VybmVsLm9yZzsgbWluZ29Aa2VybmVsLm9yZzsgU2NhcmxhdGEsIFZpbmNlbnQgUg0KPiA8
dmluY2VudC5yLnNjYXJsYXRhQGludGVsLmNvbT47IHg4NkBrZXJuZWwub3JnOyBqYXJra29Aa2Vy
bmVsLm9yZzsNCj4gQW5uYXB1cnZlLCBWaXNoYWwgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT47IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IE1hbGxpY2ssIEFzaXQgSyA8YXNpdC5rLm1h
bGxpY2tAaW50ZWwuY29tPjsgQWt0YXMsIEVyZGVtDQo+IDxlcmRlbWFrdGFzQGdvb2dsZS5jb20+
OyBDYWksIENob25nIDxjaG9uZ2NAZ29vZ2xlLmNvbT47IEJvbmRhcmV2c2thLA0KPiBOYXRhbGlp
YSA8Ym9uZGFybkBnb29nbGUuY29tPjsgc2VhbmpjQGdvb2dsZS5jb207IFJheW5vciwgU2NvdHQN
Cj4gPHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjE0IDUv
NV0geDg2L3NneDogRW5hYmxlIGF1dG9tYXRpYyBTVk4gdXBkYXRlcyBmb3IgU0dYDQo+IGVuY2xh
dmVzDQo+IA0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gIHZvaWQgc2d4X2RlY191c2FnZV9jb3VudCh2
b2lkKQ0KPiA+ID4gPiA+ICB7DQo+ID4gPiA+ID4gLQlyZXR1cm47DQo+ID4gPiA+ID4gKwlzZ3hf
dXNhZ2VfY291bnQtLTsNCj4gPiA+ID4gPiAgfQ0KPiA+ID4gPg0KPiA+ID4gPiBIb3cgaXMgYSBw
bGFpbiBpbnQtLSBzYWZlPw0KPiA+ID4gPg0KPiA+ID4gPiBXaGVyZSdzIHRoZSBsb2NraW5nPw0K
PiA+ID4NCj4gPiA+IFNvcnJ5IEkgbWlzc2VkIHRoaXMgZHVyaW5nIHJldmlldyB0b28uDQo+ID4N
Cj4gPiBNeSBsaW5lIG9mIHRoaW5raW5nIHdlbnQgdGhhdCB3ZSBkb24ndCBhY3R1YWxseQ0KPiA+
IGNhcmUgb3IgYWN0IG9uIGRlY3JlbWVudCAoaXQgaXMgbm90IGEgdHJ1ZSByZWYgY291bnRlcikN
Cj4gPiBhbmQgdGhlcmVmb3JlLCByYWNlcyBoZXJlIGFyZSBvay4gV2hhdCBJIGZvcmdvdCBpcyB0
aGF0DQo+ID4gd2UgbG9vc2UgYmFzaWMgYXRvbWljaXR5IGFsc28gd2l0aCBwbGFpbiBpbnQgKCgN
Cj4gPg0KPiA+IEkgd291bGQgcGVyc29uYWxseSBsaWtlIHRvIGdvIGJhY2sgdG8gYXRvbWljICh0
aGlzIGlzDQo+ID4gd2hhdCBpdCBpcyBleGFjdGx5IGZvciksIGJ1dCBJIGNhbiBhbHNvIGp1c3Qg
YWRkIGFub3RoZXINCj4gPiBtdXRleCBoZXJlLiBQcmVmZXJlbmNlcz8NCj4gDQo+IFlvdSBkb24n
dCBuZWVkIGFub3RoZXIgbXV0ZXggQUZBSUNULCBqdXN0IHVzZSB0aGUgb25lIHlvdSBhbHJlYWR5
IGhhdmUuDQo+IA0KPiBUaGUgcHJvYmxlbSBvZiB0aGUgcmF3ICdjb3VudC0tJyBpcyBpdCBpcyBu
b3QgbXVsdGlwbGUgdGhyZWFkcyBzYWZlLCBlLmcuLA0KPiBJSVVDLCB5b3UgY291bGQgZWZmZWN0
aXZlbHkgbG9zZSBvbmUgb3IgbW9yZSBzdWJ0cmFjdGlvbnMgaGVyZSwgbGVhZGluZyB0bw0KPiBj
b3VudGVyIG5ldmVyIHJlYWNoaW5nIHRvIDAuDQoNClllcywgdGhpcyBpcyB3aGF0IEkgY2FsbCBh
dG9taWNpdHkuIA0KDQo+IA0KPiBGcm9tIHRoZSBwZXJzcGVjdGl2ZSBvZiBmdW5jdGlvbmFsaXR5
LCB0byBtZSB0aGVyZSdzIG5vIGRpZmZlcmVuY2UgYmV0d2Vlbg0KPiBtdXRleCB2cyBhdG9taWNf
dCwgc28gZWl0aGVyIHdvdWxkIGJlIGZpbmUuICBCdXQgYXMgc2hvd24gaW4geW91ciB2NyBbKl0s
DQo+IGl0IGFwcGVhcnMgYXRvbWljX3QgdmVyc2lvbiBpcyBzdGlsbCBzbGlnaHRseSBtb3JlIGNv
bXBsaWNhdGVkIHRoYW4gdGhlDQo+IG11dGV4Lg0KDQpZZXMsIGJ1dCBpdCB3YXMgYmVjYXVzZSBv
cmlnaW5hbGx5IHdlIHRyaWVkIHRvIGF2b2lkIG11dGV4L2xvY2sgaW4NCmZhc3QgKG5vbi16ZXJv
IGluY3JlbWVudCBwYXJ0KS4gSWYgd2UgZHJvcCB0aGlzIHJlcXVpcmVtZW50IGFuZCBjb25kaXRp
b24NCmV2ZXJ5dGhpbmcgd2l0aCB0aGUgbXV0ZXggKGFzIG5vdyksIHRoZW4gd2UgY2FuIGdvIGJh
Y2sgdG8gc2ltcGxlciBoYW5kbGluZw0KdmlhIGF0b21pYyBpbiBpbmMoKSBhbmQgaW4gZGVjKCkg
aXQgd291bGQgYmUgc2ltcGxlIGF0b21pY19kZWMoKS4gU210aCBsaWtlIHRoaXM6DQoNCmludCBz
Z3hfaW5jX3VzYWdlX2NvdW50KHZvaWQpDQp7DQoJaW50IHJldDsNCg0KCWd1YXJkKG11dGV4KSgm
c2d4X3N2bl9sb2NrKTsNCg0KCWlmIChhdG9taWM2NF9yZWFkKCZzZ3hfdXNhZ2VfY291bnQpPT0w
KSB7DQoJCXJldCA9IHNneF91cGRhdGVfc3ZuKCk7DQoJCWlmIChyZXQpDQoJCQlyZXR1cm4gcmV0
Ow0KCX0NCg0KCWF0b21pYzY0X2luYygmc2d4X3VzYWdlX2NvdW50KTsNCg0KIAlyZXR1cm4gMDsN
Cn0NCg0Kdm9pZCBzZ3hfZGVjX3VzYWdlX2NvdW50KHZvaWQpDQp7DQoJYXRvbWljNjRfZGVjKCZz
Z3hfdXNhZ2VfY291bnQpOw0KfQ0KDQo+IFNvIHNpbmNlIHdlIGFyZSBhbHJlYWR5IGhlcmUsIEkg
d291bGQgc2F5IGp1c3QgdXNlIHRoZSBtdXRleDoNCj4gDQo+IHZvaWQgc2d4X2RlY191c2FnZV9j
b3VudCh2b2lkKQ0KPiB7DQo+IAlndWFyZChtdXRleCkoJnNneF9zdm5fbG9jayk7DQo+IAlzZ3hf
dXNhZ2VfY291bnQtLTsNCj4gfQ0KPiANCj4gQW0gSSBtaXNzaW5nIGFueXRoaW5nPw0KDQpUaGUg
bXV0ZXgganVzdCBzZWVtcyBzdWNoIGFuIG92ZXJraWxsIGZvciBwbGFpbiBhdG9taWNpdHkgcmVx
dWlyZW1lbnQgaGVyZQ0KaW4gZGVjKCkuIEJ1dCBzdXJlLCBJIGNhbiBzZW5kIHRoZSBuZXh0IHZl
cnNpb24gd2l0aCBtdXRleC4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLiAgDQo=
