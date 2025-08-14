Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E511B286881;
	Thu, 14 Aug 2025 09:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755164196; cv=fail; b=uR3pmXTYKhA8IXoEwbhAjlsI5JTQJfHCH3fvgx5dbdRgYXnAzVUWYI1hSGP3v/Y+FXXlC7h0/aywvWbK50wZ0TLC+n0Y9chTRE6bqQne8MHQnH3A4dTr7dJW/5bhTTuOk/2cATz7oxW4nw/HdXwkQixWvUU9YVXxK0bsim3opd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755164196; c=relaxed/simple;
	bh=pTV53nKVX7hI51EByUbTnWMpZx9DQp0gCxf8ppDIb9A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dYavrEd45O+9N9oVzBHml4vcG8CL9LHR3G11aleevZPsLKDQcfHzzbNAE50eQyiS1GYYUdtGrwZ4cYrO43fA6rUL56hWfbQ1QPQsTcs63KMpHjLc6gCsvSExYnPT4NT71H4As7Ok0+VgugPs2+9ClBKpYXkh6rh6KpZa4MDHy5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QkCk3BnJ; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QkCk3BnJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755164194; x=1786700194;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pTV53nKVX7hI51EByUbTnWMpZx9DQp0gCxf8ppDIb9A=;
  b=QkCk3BnJmYdMyN2BHvwoFPK3yxtjfFBnZEP1riiwsjyw0plUsg5LICjg
   cIpm874qrNw81/bVFOtkx09DEKm4y2r5mrUeQceqmmbT2kEb1qHWKv5VW
   /isPjBUiHS2W1fVyshWaQzGqAiHcN4uCMKaT9jYMLHdprSJ8wn/zfHqFh
   /BvAdTAn6oJTcCj2WdXcdGZ9JITcq7DIvS4xAZMNhtQZMKBu7fjoGX7lQ
   2bbrHclUQXeO4dNBzYCx348p7Qgg8pVaU4u3ox8uI79/bzlk/UsAK5i7a
   DrxfHCG0UENXcbGwruCC/fgRbGywbf1HeCb7qT6H0LaE1i4cjvgkk42QC
   g==;
X-CSE-ConnectionGUID: fWJR0xT1QbaVB+90gpXuTw==
X-CSE-MsgGUID: IMKb3GtLShaU1FXvKgvBcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="61100639"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="61100639"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 02:36:34 -0700
X-CSE-ConnectionGUID: ZqnlfYONTlidi/oQTwOD3Q==
X-CSE-MsgGUID: E7qPyaBCQMGMJ7hqjvmYXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="170844506"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 02:36:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 02:36:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 02:36:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.51)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 02:36:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mSjUTP3pQJloOPdrHkFaFf5q7+WuFddiIEiI+LqFnm1bC+BNZoh0nsy9G3ZoZg1z5ihBjpmjWCm8JVzwAqR5Bx5xG++Btra6A+c0nl4Fo4mV6266izkAt2keYWQrtPOCA6tMp1hociUyoEqGFb9mJ+ffYdvH4LtsL0K9Z2elxkEAWuOt2Pl+8C4Oiilrh83Yl8qzY+6LajmC50Z41iVtAdJlf/o3W/npUVYPJOMZ6dluK1jz4ELUGSuDOkYmoQQQy5ZcBXElBj7RXHUp/k2WZCupTIKbVRJ6136IKT/anatiunHEjWLjHgBIZFDXeNN2TFm2V0QQedF1HUEdJ/GtNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTV53nKVX7hI51EByUbTnWMpZx9DQp0gCxf8ppDIb9A=;
 b=wM7VjqGNEECeolN+qSY75Wr0gO6cM2SFzqRGknC0xO/J+RiJ6ftmDFMLcfkUdNJaiTEMa+vlXMR7ITQW+QswYgpsv7k6qjfiTojKAIIaFtPOTubjToGiwKakqAZHQwn9q2iqtQw/+pQfTBYRRdAnSoRPrFTaKrY7lFd3XNkX4lFYMWoPDuo0+v/xmMjW8GI/BqX0iQCYrPs2iVAmYxT4wpdNQ5zH7JUX1x+QodRNbo1B9Ue6B5RFxDFWuphGh6qef2JBPmKqWTR1eKZzeEz0iQx4rMIvtH5SKWtp5bOWLeW9qBuNEsArhVL45ypV5keSX4Z6MoLP0V4lqhQZFFuwnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ1PR11MB6082.namprd11.prod.outlook.com (2603:10b6:a03:48b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 09:36:30 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 09:36:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcDO5TnQHIa6baW0CdldyvXyq8LrRh4/OA
Date: Thu, 14 Aug 2025 09:36:30 +0000
Message-ID: <a75801b6bf56362c0ac9fd4ac2f82f3133b55f1a.camel@intel.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
	 <20250814073640.1507050-6-elena.reshetova@intel.com>
In-Reply-To: <20250814073640.1507050-6-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ1PR11MB6082:EE_
x-ms-office365-filtering-correlation-id: 0bf07abc-8816-4251-1f8c-08dddb160cbb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aW1vVS9jRE4wMG8zS05jN1k2cGk2VHlUT0N0NGxvZitjRkI5OVVvRDM5aWVr?=
 =?utf-8?B?WjI1S1hnamRjT2drWlpBUE5GOC9yb0h1eGxXcDRLTWlSeGkvN08rbE1WQmlF?=
 =?utf-8?B?b1JOTW8zOW5EMElSQ2lWelM2U01JWU5CMW9rdWhLa1JidVF2V1RkRjFFb0kv?=
 =?utf-8?B?Nkw0Z053aFBWU3F3WUFwY0k4U0tUbmFxWDQzWFpDQ0RzQU0xVTdoRUw4Y3FJ?=
 =?utf-8?B?bmVXaG1jMjA2cTNnd3hibEcxSjZUYnhBYUR1bWpKMkgrWlB6K3FuS3o1bm9k?=
 =?utf-8?B?OEpuODhKK0NBRlQrNCtvU28xeXpWbk9XQ0VKdVVVcHl0dmtvTVVNWFoxUzRB?=
 =?utf-8?B?b1V5emRWWmxRUU1id1IzdHo3M1NOcFpaMjhVNktIVEcxTE9saE1LL2RTS2tl?=
 =?utf-8?B?SklnSDJ2bDNLazhEWGRtYWNVWkF0d3BGS1ltRHJUOC9kdkc2OW9EcXllWVh0?=
 =?utf-8?B?UkJORUM5V3JwTWMvVDM3ZXNTZ0daMkVMWiszY25ybTNjenhZTWNZRElRclBD?=
 =?utf-8?B?dFBZZnUwb1FRVTRXWS9waHRwWnROOXNwRXJmWGpjSERMelU1ZUhoS1UvTDN2?=
 =?utf-8?B?WXZ2a2V6dHFPTEtrWE0xT0NxZGk2a3dQaWg5QTAxZDgzTnNPUVUyZXZUZWlk?=
 =?utf-8?B?MjFmYnp6K0dhZVN2d1h4WEJ5NHVVcHovMTJhTU9rMktRK1pvc3p4a1dnSWl5?=
 =?utf-8?B?QzdIbnhiMkxCTlR5NGNPdW94WmhncE5nd3gyY085Mk9ubVJxb2NRczAyVmtr?=
 =?utf-8?B?Smw2U0hJK0h4ZldIaW12REo5bHZWOHgyaDY0b3ZBYUQrV3c2cW5IbTVnd3oz?=
 =?utf-8?B?dmE1Qkk5QVlsVlZjYVJ0MFZKQnM1aVM0N3NJUEdiOTBwTVRmd0J3ZWhsYjI1?=
 =?utf-8?B?YUV2ZHFFaTlNa3BnSXVhbWJrZFA0WjFvYnU4c3ozWnNsNGs5cGo5S1Q5em0v?=
 =?utf-8?B?ZGQxMVpqVHFIQ28wcW5lNEJYOG9BeVdqWFhnNHdYamhWbXFPSjBqak5LVTRD?=
 =?utf-8?B?dW0vQ1ZjY1JFUStHM3kwc1N4QUdHZmlISEN5K1B4NCtxaitrVmgwWkFna2VV?=
 =?utf-8?B?alVUSnZ1bG9PeWdnU1JNL21WbWpldmQzTElyR2hxTEhNTWs3TytKL3R5eEsx?=
 =?utf-8?B?QlZycUZTTDJaVHJVYmJVbkdaOHhXTDVENm9iTW9DLzNKdUtTeVJIamhGL05z?=
 =?utf-8?B?U1V6OGpEeU1BdHgzcEU1V2d4NUVEMmhpSmdwQTAvN1VuVU1RUzJ6ZmpITmF4?=
 =?utf-8?B?SHYzdzJvVk1zWUNhRUhvU01sbmhhNVlLZkZ1NWtFS0t1eC83NE10ZERqeWl6?=
 =?utf-8?B?RmY5dGtuQU9haTE1MlIzQXZrOXBYR2ZRdllpK1VGWEJPdEwwRmFRTHVGK2ZW?=
 =?utf-8?B?ZmVZNzVncWZHK1FpcHhoazI5V21sSUxYZndWS1hvcjhhTXdmNGNWVGZWak1P?=
 =?utf-8?B?bE82NTI4bCtuU1BvQ2NxRDg1Nm0rVzZHVy95d2cxUkF6dTRyRGpSVWEzdDdN?=
 =?utf-8?B?aEhxbHdJYlhjS25HcW9pWjgrTklrY1FZekxrNnJ2ZWNnVW5jWmlybFRPS3lS?=
 =?utf-8?B?RXRqN0k0TGtaem9aYSt5M3hncXZ6aXN2eUU0VVlzN0J6R0FnaXpQWXN4SU5T?=
 =?utf-8?B?bzhZcEttaitvYnZHY29MWUx6enhwMXBnYUpOSGRHT2J6dHJXSXRrdXE4bFp4?=
 =?utf-8?B?bzk3Z3ozNDNLanZjTGQ1R0hGL2xtMEt1N2N0SkFrSkNDbnUweUhTRmRGRWZr?=
 =?utf-8?B?Q2dKRFV4eEtmODJPZkRXRllybGNwSlQ2SmFBYkdxcGdYVUp6Q011VnBtMWxD?=
 =?utf-8?B?Y3VkN1pRdzVBNGhOYUxYSW1Zbm5rNDBnWDdoYW9PbkFzbkF0T0paWGhFUUZF?=
 =?utf-8?B?d1ZuVHI5ckw4cVd2c2dTVldxTExYbXNPV0h1WU1tdHd5SkpyR0owU3dkaStl?=
 =?utf-8?B?eEFEckdxL3NkclBnc3pPVDlVQVZ5WU5hL2pEVHJHVCtDeVBldiszejdvck01?=
 =?utf-8?Q?jhv2+ZJsB33rKh2jddPRqOuh5jDAQo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTBid3NpUTZkc21sVzhEVEJWUmhrTmRlQkp3NEorMW9neDJLNEo0cGgxUVJ4?=
 =?utf-8?B?TUdWWXdrajdxVHpud3RhbkJPMGU2aW5OR3IyZUFrNkdTQVA1MmdsL1B2Y3My?=
 =?utf-8?B?U0I2NWVoRWw1K2FxRi8ySkNCT3A3Y3dyZCtzcktCVkRuRFpkd282WVRocDM2?=
 =?utf-8?B?a2RpM0o1d2Rrc1pnYzdES3hjR0VIamwxeGd0b0xrQVRjaHJFVjI3ZXdINSs1?=
 =?utf-8?B?UTRhdithWHZDQSt6RC9YVWV0MmRsQVhiT0JjOFA2QnVacWo3eGU3dXNqY0Jq?=
 =?utf-8?B?bTJUZjU0anhLSStjNE1vOG9IQnFtNUN6eVI1YVFuTUQ1VEZrSWJLenB1Z1l4?=
 =?utf-8?B?V29JL0lobE1VOVMzMVJ6Z1krQkxmcnN1VUtORzYraGQ4UDVkMGhhZE5zMkdW?=
 =?utf-8?B?OUNKeWk3VEU1ei9SZlc4dWFvS0NtUHAySWZQYUhReTZoOEtnOVJxMStLVmtL?=
 =?utf-8?B?Mk9tTTMyYTJncHVwRUErZjBKTm9aZW5iOEdZYUVlNEdlN0JFcWl0WTA3VmFO?=
 =?utf-8?B?RCtzZWFXck85VzY2RVQxUExzeDVDWGV0VkIxaXViV2RnU2ZWdzJjYXQ1TkVV?=
 =?utf-8?B?anUza2YrVGIyWVVuVXNtc1pBMGpuejJHQ2xaMW5UeGxOdEorb0hnY2RhNTZH?=
 =?utf-8?B?T2tyaWkwSXlxTFRlVDZXTkFSL1JkNU1BL1MrMWwyVG5kUGdocjlVMndoMTNP?=
 =?utf-8?B?eXkyRTkydFQzNEdWSUw4U3h6OVhRekdmOUNNQ09OdE5aNG5lYzdubG03UHJi?=
 =?utf-8?B?V1VRZjBrcFh2TENtTDZDZmQ5dVArTjFKeCt3YkI0NHpBVlhuTzg3VDBBb1hR?=
 =?utf-8?B?WHRCa2hMUGNTNFc3R3JKSDhkZ2pSNENxNVRGTDNLYlN0VEU2WXBDWmIzZzNo?=
 =?utf-8?B?cFE1cjNiS0cwKzV1Z0QrY0pPQnFHNzgwVU9nL2J1cTVwa1lBbnFwTXhTcU1w?=
 =?utf-8?B?WHhMTWxzeUxaYzJvK1ZlZTF0NjIyeC9KRXVTVGo2czBXQXNsL1RXRUpNcFpP?=
 =?utf-8?B?dndPKy84NzB5SnN2WFpOc2R1VGg4b3hwZXlWUlkxM3pjbUd4ZC9ibTFXZ09z?=
 =?utf-8?B?NGROMk93QnBsK2ZaeS8rQ0YxamdMNXE0NDZ2MnVBUysxTk5Tb2ExaG1NSzJq?=
 =?utf-8?B?VEhzUHptRjB1WmhybTdxNUtzdzZzem0vamhvU2lSdWVmb25zMWw1K1A0ZW5k?=
 =?utf-8?B?MEhSVmRiWk1aNlBHd0RoZUwzclNKdi8vK1BFL1NpSVdoZmhWcWdDb3RQc1Jv?=
 =?utf-8?B?YzNZWEFZcC9uUVpDaE9ZaEgxeWUxa3U1UkpjblNaOWN4RWpvR3JjdktaMGhH?=
 =?utf-8?B?a256NklRbU1Iakw1R3RLd3c5cTZJYXNiNWhDcjh4QzZhaVVqZGJoU1RoUkx5?=
 =?utf-8?B?Y0FVS3VsaWNkTmZxWldBdlBTR3ROSms0cmorQS8wNk15UFRVTXhtWG92Nlpx?=
 =?utf-8?B?Tkw5VWdBeTYyR3Z2TFpKVnFaeGVWajhIRnQzd3ZiUnZLNHhkdzhUNXI3SUlk?=
 =?utf-8?B?a0FoTE9LWkx3VWlaTjJmcVF6djZvUGQybXVCcmRJRjd2R21SZW1aM1RIOW92?=
 =?utf-8?B?VUpCaU12ZnlrcjY0bHBLRHZ4aStyU3RURXJsdGJYQ283b0txNm1hd043ZGY1?=
 =?utf-8?B?dnQ3c25relBMbEF6L0JHejlvUmU1TERlZDFmN3BLbms1T2FEK1ppOWREZXdS?=
 =?utf-8?B?U2NFZ295eElRSEpKcFN3QTRvQkZiUENsQ3drZFAvckppalplOTdVNm44aENF?=
 =?utf-8?B?Ky9iUUdyWlpXdkQvaTRUOGdpUTlKRTcza0N4cFloeXQ3bjFMak8rUHFrbnBz?=
 =?utf-8?B?Sno3OEl0RXAyOXFRV1ZlNy9ScWJvT0RKVzc4ZHNObVlYZHg5eCt2UE81R0Fp?=
 =?utf-8?B?U0YzQU5iQjFESTZOTGhsK0tVRkRsYkpBYVZwaS93L0RHb3VtYkgycS9RY1Qv?=
 =?utf-8?B?NGN0K21hU2Q5VG9HT3crTmtKY1ovS1NwNlM2ZDVFNnh6MkNSOUY1U0lrT0J0?=
 =?utf-8?B?OGRZcFdrMGw0aERKa0JiV0FxMTBtQ2tEMUw2MEsyTXpuS2tiaVVWTkZ5TVo1?=
 =?utf-8?B?K1FoK0VicHM4NDNmcDZYTHpZcGZlTXBzMjRvWFVPS0oxV1VnMXJCUTI1d1ph?=
 =?utf-8?Q?3Ys8SxnTD/J/PK9d7wOv5RaS6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E2A52D9BD7607409EF2AA1311323714@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf07abc-8816-4251-1f8c-08dddb160cbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 09:36:30.5538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UVOIAmCyetydU5phSwEcZL2l4IpoHO7LljOgj6bkKINGsIRzgmNa2xMbV3PDycRAVxXehId1DaPkPrJcMuLdeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6082
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTE0IGF0IDEwOjM0ICswMzAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3Rl
Og0KPiA9PSBCYWNrZ3JvdW5kID09DQo+IA0KPiBFTkNMU1tFVVBEQVRFU1ZOXSBpcyBhIG5ldyBT
R1ggaW5zdHJ1Y3Rpb24gWzFdIHdoaWNoIGFsbG93cyBlbmNsYXZlDQo+IGF0dGVzdGF0aW9uIHRv
IGluY2x1ZGUgaW5mb3JtYXRpb24gYWJvdXQgdXBkYXRlZCBtaWNyb2NvZGUgU1ZOIHdpdGhvdXQg
YQ0KPiByZWJvb3QuIEJlZm9yZSBhbiBFVVBEQVRFU1ZOIG9wZXJhdGlvbiBjYW4gYmUgc3VjY2Vz
c2Z1bCwgYWxsIFNHWCBtZW1vcnkNCj4gKGFrYS4gRVBDKSBtdXN0IGJlIG1hcmtlZCBhcyDigJx1
bnVzZWTigJ0gaW4gdGhlIFNHWCBoYXJkd2FyZSBtZXRhZGF0YQ0KPiAoYWthLkVQQ00pLiBUaGlz
IHJlcXVpcmVtZW50IGVuc3VyZXMgdGhhdCBubyBjb21wcm9taXNlZCBlbmNsYXZlIGNhbg0KPiBz
dXJ2aXZlIHRoZSBFVVBEQVRFU1ZOIHByb2NlZHVyZSBhbmQgcHJvdmlkZXMgYW4gb3Bwb3J0dW5p
dHkgdG8gZ2VuZXJhdGUNCj4gbmV3IGNyeXB0b2dyYXBoaWMgYXNzZXRzLg0KPiANCj4gPT0gU29s
dXRpb24gPT0NCj4gDQo+IEF0dGVtcHQgdG8gZXhlY3V0ZSBFTkNMU1tFVVBEQVRFU1ZOXSBldmVy
eSB0aW1lIHRoZSBmaXJzdCBmaWxlIGRlc2NyaXB0b3INCj4gaXMgb2J0YWluZWQgdmlhIHNneF8o
dmVwY18pb3BlbigpLiBJbiB0aGUgbW9zdCBjb21tb24gY2FzZSB0aGUgbWljcm9jb2RlDQo+IFNW
TiBpcyBhbHJlYWR5IHVwLXRvLWRhdGUsIGFuZCB0aGUgb3BlcmF0aW9uIHN1Y2NlZWRzIHdpdGhv
dXQgdXBkYXRpbmcgU1ZOLg0KPiANCj4gTm90ZTogd2hpbGUgaW4gc3VjaCBjYXNlcyB0aGUgdW5k
ZXJseWluZyBjcnlwdG8gYXNzZXRzIGFyZSByZWdlbmVyYXRlZCwgaXQNCj4gZG9lcyBub3QgYWZm
ZWN0IGVuY2xhdmVzJyB2aXNpYmxlIGtleXMgb2J0YWluZWQgdmlhIEVHRVRLRVkgaW5zdHJ1Y3Rp
b24uDQo+IA0KPiBJZiBpdCBmYWlscyB3aXRoIGFueSBvdGhlciBlcnJvciBjb2RlIHRoYW4gU0dY
X0lOU1VGRklDSUVOVF9FTlRST1BZLCB0aGlzDQo+IGlzIGNvbnNpZGVyZWQgdW5leHBlY3RlZCBh
bmQgdGhlICpvcGVuKCkgcmV0dXJucyBhbiBlcnJvci4gVGhpcyBzaG91bGQgbm90DQo+IGhhcHBl
biBpbiBwcmFjdGljZS4NCj4gDQo+IE9uIGNvbnRyYXJ5LCBTR1hfSU5TVUZGSUNJRU5UX0VOVFJP
UFkgbWlnaHQgaGFwcGVuIGR1ZSB0byBhIHByZXNzdXJlIG9uIHRoZQ0KPiBzeXN0ZW0ncyBEUk5H
IChSRFNFRUQpIGFuZCB0aGVyZWZvcmUgdGhlICpvcGVuKCkgY2FuIGJlIHNhZmVseSByZXRyaWVk
IHRvDQo+IGFsbG93IG5vcm1hbCBlbmNsYXZlIG9wZXJhdGlvbi4NCj4gDQo+IFsxXSBSdW50aW1l
IE1pY3JvY29kZSBVcGRhdGVzIHdpdGggSW50ZWwgU29mdHdhcmUgR3VhcmQgRXh0ZW5zaW9ucywN
Cj4gaHR0cHM6Ly9jZHJkdjIuaW50ZWwuY29tL3YxL2RsL2dldENvbnRlbnQvNjQ4NjgyDQo+IA0K
PiBSZXZpZXdlZC1ieTogSmFya2tvIFNha2tpbmVuIDxqYXJra29Aa2VybmVsLm9yZz4NCj4gU2ln
bmVkLW9mZi1ieTogRWxlbmEgUmVzaGV0b3ZhIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0K
PiANCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg==
