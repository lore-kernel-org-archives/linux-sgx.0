Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B44B263C7F;
	Thu, 24 Jul 2025 10:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753352310; cv=fail; b=AKnkf+JJroXHfakcSbvOynGMVY7lMaT/R9Ksvz4m1oHiFFxSOOfEGGOCW3us5yvhY5ccg1BiwoHzD2fr42T84fXTL6eqM7dT9yzhlKOybzgYXTtfpGl9ahS+YGNMq95x5CnwE1yzJ1bWk/I2231ssr5Qnf66Wj7mtCkeGhYEWhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753352310; c=relaxed/simple;
	bh=z85wxzvjcNpN3CcVtYyalhNHlxlXzeLXmGt4t/OQDO4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nABa2p77i6p8ynaJ9cqwsHjayMfLSw9KT+iGwBOUCs1F38v8mIDs5fmB3OrIeLi572dfLI038wUjtqg6VkjWaVTmKuDetqeezgMLb9lGUbhsucRvvAfTonx2v9aUEjU5DS3tDUI7PXdoAwQlQ5uwtenQXFnfdwdVGxbzoO2/4SE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dSHmfF/t; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dSHmfF/t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753352309; x=1784888309;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=z85wxzvjcNpN3CcVtYyalhNHlxlXzeLXmGt4t/OQDO4=;
  b=dSHmfF/tWhep931nraBUtDomKh47DVC7FzuiKmDDhzQticZZ6yOYDxYE
   UfQB6kcVAbrnIdbT97EH18xDRFL/Qe864UzaMkU/HBAUrsmDSxXuXIeKz
   FAjEpIL+TQAHsJR1qPIb0NstvvijNGIv2Bn3UUc/L6AoKudniUW+xzFfP
   EOpExqvybzMNxGRbII34IHGPvOEdJPHzHjNaASuaPUNnS+JRiLyH5QQ/f
   VUw6k7AGFjeXPzTiVn5VVtp1Ex5e7XEsvL5/qO9au6fwr+GqSkP+JC25/
   1YVfmevOLG5gK3ty2KxAM2S8CMwqXPoLuE0LMw0fH07oBH7aWia+AQ/bw
   A==;
X-CSE-ConnectionGUID: X8Fs98fkQWCte1mAMLcnuA==
X-CSE-MsgGUID: lN3ajt6qSfq0tavLaMrUtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55506129"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="55506129"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 03:18:28 -0700
X-CSE-ConnectionGUID: OqEufzdcRhi280cH1fYhxw==
X-CSE-MsgGUID: gsoZ3x4hSOS4ESRRBSVALw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="165666786"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 03:18:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 03:18:27 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 03:18:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.52)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 24 Jul 2025 03:18:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WTkK642ESBVevvG6HU95JQvM4GDec/5NSTRTe4UMavmAyt0oSDmaWJma4VuxVTvF+nUNMNBNea2YUD7c0bxUUEAoMDxq692Lv2itZaR83V5v5SXgXHP+6yxIWms2ptAVoBd9GqsXyz2mF9DwPUuCzXkWzhuaffGt2znqz1BV/q4ARJbD5hq371+P/2xClzlflGQYzjfNBrNMHiNcUPESiB8Xj4gyjdGbvquix2Gq41QO1GHQWqqLdI15So/71a4MFsTO4dfHj2RwuTdbBiXGYKCKUdvxQsx3sPKjLQgiz1SmtfTV+SU273O8+qgMIcABNGBw7Adj9SJmWwHUPOX+dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z85wxzvjcNpN3CcVtYyalhNHlxlXzeLXmGt4t/OQDO4=;
 b=RP2+tZt0Y0zXMxcHKADgXhDQX1gAZG4u7roUrtCpt0OmPz85x1aKBRxC6bGG8O6jOEVCDuJhfED1Rba3pmbZRU4X5Fvn6gCoDd7V5EDymFclzKeOfSW1mrnqoQMrua2meHlVmPlOMAl4vYzDl6OIvrbAiEenrxpzSUZO2Y3Wk99voZBds5ab7pCNZmlyqCfCV5c1ZSNcvu1BYKnDx9XeVyGzhwhhPz0dzWbgGjLXSot1tR/hx4T5YEjGeCBkLHNCqfJcf+Ll+Z6XY4zUqAE8wr5F2Eb324x8w3/YL77HbVNvwnOotqZUb2sXyx6ms9wp7BneZav1u2nl6PVTw5B5Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ5PPF44E8B88DF.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::825) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Thu, 24 Jul
 2025 10:18:24 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 10:18:24 +0000
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
Subject: Re: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHb/HGK60dfSRXjp02uNG1v9X+jQ7RBD6qA
Date: Thu, 24 Jul 2025 10:18:24 +0000
Message-ID: <de38822919d93dd5074becc707d616022fad03c2.camel@intel.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
	 <20250724080313.605676-7-elena.reshetova@intel.com>
In-Reply-To: <20250724080313.605676-7-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ5PPF44E8B88DF:EE_
x-ms-office365-filtering-correlation-id: fdc73ecd-5860-4e27-0dab-08ddca9b6c4a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?M0dLblQxbndxcDdiSnkyVjNWZnpDZlljV1lCVUR4azlrM3AvcThxeThYS2k2?=
 =?utf-8?B?NEZ5WnUxSFYrRWhCSHlwbW5EaGxsMmxqTlhqQ0l1R3U2US9lTXhYcTVsczRX?=
 =?utf-8?B?RWpNZjRDNVJ3M1lFekZJR1RiNGRrNFZtdndVNmdVcTlyMTEyT2RHamFFalJv?=
 =?utf-8?B?dW9VUmhXbjRScmN2NDhBZldSVmxCQmtHazFnWmpYOEhsY1BnYzljdWNpMVRY?=
 =?utf-8?B?N3JUTFlOeGp1UkVwdE8vQjAyaFFUVU95N3BoamlPWk9YTDBiZGVoNHI2K2Va?=
 =?utf-8?B?Y01wQU5SbUV3L0Z5SG5xMERzVER1aVlJb1B3bU8xZmZJYmxFaWhXaWtSWjdt?=
 =?utf-8?B?SkV6TWJaT1ZhOUFvMURFK1Jhajl2ekllSDB1NU1VK1lheWhUT1NxaUZKU0Zm?=
 =?utf-8?B?YytJcXY1Mk9RRmc5N2RPUjZ2RFFHamwrZHhXMWNibkg2NmlrQ3RUTXpWcVU1?=
 =?utf-8?B?eGxvTVkzOE1XMzNpTHJENmFCV1h5VDlJSUJHYkxDNUtCMFgwQTZBdE01aHBM?=
 =?utf-8?B?R2lpbGQwRXZVb2FyOURwa0szOWE4TU02REVTQUJaa0tPVmZMSUo4M1hJRGh6?=
 =?utf-8?B?ZlgxUnR5RDdnK1JKVW1LbTV1R1B2YWVFTk94Sms2SVJSQmdzaG9kK1dXbnNv?=
 =?utf-8?B?QlI4d2xocVRRb3NOTlVGTVRmUWRzTUVCY0ZqMXRGTnMyL2xNcGxXRERtaFhJ?=
 =?utf-8?B?QytLUGViRGROd3FrWU81WVgzcHNWZ1FFTFRleEJQaGpCVW5EWE81cDdiYjBY?=
 =?utf-8?B?cEtIRXpLR1N2cC95SzhTYUlwUzN1VGRTTHZYcStDL2dMcXg0aHdmbFBzcHl1?=
 =?utf-8?B?R2E3UzlEMzBHVi9XcUhUMi9DNkFsWG1nc3ZIbXBHdTh3QXpaVll2S280K3Qv?=
 =?utf-8?B?WjF2d3l5b29MMTRVQytFWkIycXdrcEhCT2lPWXNjZnNIMm5wZGM4OUJoOUpZ?=
 =?utf-8?B?Y2pqeTBMQ2pZcHpENkdIdDlFVHpUT2VqNXdxVVVmMThaQzIxekdUcnFBVnZX?=
 =?utf-8?B?anVxbHE0WXpaM1BwT3kxVWc2UGpTM3BpOWllSW1HaFc3N29PTWlwa1BMa0tV?=
 =?utf-8?B?MFlsMEt2SWprYW5lYmo1T215bnRtemY1OWt3K2VXbXRkNjdrbFlWRHM5MGpH?=
 =?utf-8?B?cnJzNzBtMkE4bU1LRnZ0RkEzWEFUelFsZ2Q3TUhkK05VUXVYd2VoWG1mLzRt?=
 =?utf-8?B?SG9oZVJ3cE5BTkRPWXA4OGJ2OU5rQnRSRDdFVzkyRXhkQjJUN2d5YU1ocGV6?=
 =?utf-8?B?L20vTFd2V28vbTFZZWVDNERpSUNNcWZVMUY4QjNXRFF2QTZpZ2ViVWFQRFZE?=
 =?utf-8?B?WS84K1dudGFNRXcvVmo0a2U0bXFQMVhKNzFPZzZjRmZqdDNuWW9EOFRRUXV2?=
 =?utf-8?B?T2NFYnNuVlhwUngzUWw4ZUNlVUVNTzR1eC9Fb1hwbEdUZTV3TEpBeFdZS201?=
 =?utf-8?B?dzhUN1dTano2dFlJWE1uZmk0ZDRML2JTTndtOGZJUlJYdk9KL214NldxRXV2?=
 =?utf-8?B?VFdDek9EckhhNnkzZ3IvNlliblA2MklKUmJTRHhIYzkzajZDQ0c2bVlrVytW?=
 =?utf-8?B?LzNmUHYvWXh3NHJmWC9ndVdqOGFKTUFtazdJQ2R5d045dmZZZzB0dmlTN2VI?=
 =?utf-8?B?TFE4ckdXZHkwS0RqZGZNdWVLUjN3dVRuMGk5bXlNYlFOU3RocEN6bFE0MUlH?=
 =?utf-8?B?ZVVnaW4zam81aXArelFuRVhKbVpzcmpwVm8wQTNNZjZSb2ovQmttdUl3Tm81?=
 =?utf-8?B?SE5SYXZ1Qjc5Yk9Md3htYW1IdHNFNkdUZS9BMmVkYlErMjI3UUpNUlp1bkhB?=
 =?utf-8?B?OUN0Zjh1b2NKZnZRYXN6ZTFsbU1vSWFkNVhsRk9oZHdWU05GbFloeWp5NDhq?=
 =?utf-8?B?d2VnaDZtd2g1S0VlaU8wOXBzajFDalhsNm1rUkZ5WmpDcWxFZnBuQ05FOVU1?=
 =?utf-8?B?RkczT3dwaFdhK1BzcEIxNHpYRTM5ZGtLNnlIUkMrMmRzRnQ3YzUwc0c5K0tp?=
 =?utf-8?Q?Y/F7SdzSLEJXzZZujc3S4+IPGAMeaI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDlOTktCdU82MElvTjBvcHVWZ05pbncrTXkrbUNHdEl5WXZmM2NnV0R1TXVs?=
 =?utf-8?B?YmJzbnlyT0grV3ZFWTlXdm1kb0h6RnhpRWZXKzE4bTBuaDg0Rlk1OUU4VmVG?=
 =?utf-8?B?T2hPYmsrWEZwOVpXeXJPTEF1NHlHL3pCSktMbWZ6d0dTYmZOQURJMzMrYnQ5?=
 =?utf-8?B?NWtlOHJjWitNQXJ4cURyOCszSUVpUjdkY1QvOWVzNi85ZEg0TUUzRWRUNHgw?=
 =?utf-8?B?Vm9WK1pIZWZWWFFoeDlNS3ZiK3BJVlhxdFErM2xCS01KTTFhK2t3RE4vbVNs?=
 =?utf-8?B?aU1xNHJDZUVISWVPeW5nS2VVcmVjYW1SM1cyTnNYdFBHVHVJTnVGVHJZRVM0?=
 =?utf-8?B?RktLa2xPYnVMVnFmV0R0S2U2MUNRSkpJRXZjTVZjOXc5a2lGOEJYY0pCSFZL?=
 =?utf-8?B?MU96TmhrbjZ0eW5BRmxFMVRNZkc0KzMxNTNHQXE3MnlMNXZ3bUxBbVZBNDNJ?=
 =?utf-8?B?Wk1yWUJ1VGR2N2tIcVVBV2MwY2xXT1ZQemhWUmdHUnNteHRvK3ArejRMWFZz?=
 =?utf-8?B?UVZMTTBzQzlySXhFQTduTlN5cStiMTNqUUExWkh4UFpNbHJDd1lFRktrRlQ1?=
 =?utf-8?B?RlBjNElOUWVSVnVxTHNFcFFuOGNVK2crSjYxVFo0djNTZ0VUelJwYkVXaEsy?=
 =?utf-8?B?WWdDZ3I4LzZ2aEk2bFZIZ3U5WG5wdjRUbnQ4eXprNSszbldVRWQ5MWExVjdS?=
 =?utf-8?B?MTdUN2c5dlhKbFE0WDV5aE96ZXUyUUt3bng0QmtuZTVhbWNvaU8vWWdScUNB?=
 =?utf-8?B?aERBdmZJUFVTa2k5QXp3WFJLMCtPUWJPelJWd2VsSUlPQ01kZzF2VXRUT1VJ?=
 =?utf-8?B?QlRWZnpmdytDQ1RQSXZpZnN6OTJRenVaaWNqWThqdWltaFV5bzdHeW9OZ0Zt?=
 =?utf-8?B?MEkybXNKZzZTRXNLTnFCSUJUREFtQW15cWhaeUNISzRyRG92eWFLRUcyREZw?=
 =?utf-8?B?UXh0b2M5QnRBVmdVZTFiYXh2ZnZGR3lBalB4aWJXN05nRXRzcTh1ZDlHRzVp?=
 =?utf-8?B?ZEJDaHpLQWxYYlp3UzVlN3Z4YTR5Wm50bHMxenJIVGc1dXhTUzVoN0g3Rzhh?=
 =?utf-8?B?YlpYdFpkcHRxWXA4S2xab2JRMXJ3TUd0L0ptN1QxNXJhdHpHY3o4S3plZXlS?=
 =?utf-8?B?V0NaR1JxWS9MQkgvb1JReDdUUWs2OVhjL1YxTjYzZzkwYUVwaTIyZ0ozcnA1?=
 =?utf-8?B?TWRoN0NWMjJjcEViUnA1S3ZGd1oxSFZkeXdtbEdxWHJ4MG0rb2V2SEVXOFBJ?=
 =?utf-8?B?QStJZGQ0TG9Zd2UvMGF2T25ydURJajRpTmo1Z0pGTmxuSVJ3T2w3eWo5Qk1J?=
 =?utf-8?B?bStqb2lqQTlMa0h3K0crRldDNjVzU1pxYm01RGw3SlhoT0h3blNUN0xaME5H?=
 =?utf-8?B?azF5cXVJaWF4TzlPVUFhRFlicnpCZlczT3ZjckR6eXg5S0x4aVV4eVU1ZUkz?=
 =?utf-8?B?RW9XaXArd2dRSEhPVllwR0FFNUhsOVZ2Ykw2dzVxSlpONk14dDhhRnJSTWJH?=
 =?utf-8?B?RXlxWFRHclF4ekFPeENITTlDRzAzTHl2bE1rcEdueWdEaDRaS01NMXZUS044?=
 =?utf-8?B?YTQ2eEtibnoxdE92UTJBRGRsdTg5bHFSZjdJNlNoYmx6TU5VRlFpcENNRGVK?=
 =?utf-8?B?a0U0d0ZGd0RKWHp4WTdjMnF1Q1hYaTYzdklCdTA3enpVcTJjMk02a3V0aEVz?=
 =?utf-8?B?QkNUMnNYKzEzOXdiTmkzdzZRYk1MaVF4WFQwQWJLYU5rNHM3ZTdrUll0L2t6?=
 =?utf-8?B?TGVZamFMeTkvc0hEVGprMnlJV29obENCL3poUVl4bis1NnZ5TGd3Zm5HQXgx?=
 =?utf-8?B?bStqbXVjUzRzWmoxNHFqRk8ybG11QzA2U2RDU2UxNG4zTERYeDB5Zk0vMkVN?=
 =?utf-8?B?S1ZHZnNxbGhmN1BnM25WeUJMWlJRa1BCRUFuaU4wdXl0V1I1NERwK0xpd2tV?=
 =?utf-8?B?NFlma0k1UnBmczFpMGhUM1dubzdiZGFQd2ZCWTgwU2RPQVZySGhrcE54Tmc3?=
 =?utf-8?B?N2hhNjR5TE9iRHRVajlBQXBHcFdRSFp6aUtkY1ZhVldwS0VGSE5hSU5QdUpC?=
 =?utf-8?B?Z1ZWZlMvZklmUmxGVHFROVZiME9CWGE1dEwvUE1nM1Brd3V4dFFiekp4MnRa?=
 =?utf-8?Q?E4EftLfud6Xwa7TCpaHheS/qu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9D01D135DF281409AA903423DAF1CCF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc73ecd-5860-4e27-0dab-08ddca9b6c4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 10:18:24.1512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wY255bfg1XrfTtcs9N9CUX0AnUJxKhh3xUsQtE+MPjrUFgCSRc49+co4J+uyvEqFNBVgRyE6/DL+OdctmQROAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF44E8B88DF
X-OriginatorOrg: intel.com

DQo+ICAvKiBDb3VudGVyIHRvIGNvdW50IHRoZSBhY3RpdmUgU0dYIHVzZXJzICovDQo+ICBzdGF0
aWMgaW50IF9fbWF5YmVfdW51c2VkIHNneF91c2FnZV9jb3VudDsNCg0KU2VlbXMgeW91IGZvcmdv
dCB0byByZW1vdmUgdGhpcyBfX21heWJlX3VudXNlZC4NCg0KSSB0aGluayB5b3UgY2FuIGp1c3Qg
aW50cm9kdWNlICdzZ3hfdXNhZ2VfY291bnQnIGluIHRoaXMgcGF0Y2guDQoNCj4gIA0KPiArLyog
TXV0ZXggdG8gZW5zdXJlIG5vIGNvbmN1cnJlbnQgRVBDIGFjY2Vzc2VzIGR1cmluZyBFVVBEQVRF
U1ZOICovDQo+ICtzdGF0aWMgREVGSU5FX01VVEVYKHNneF9zdm5fbG9jayk7DQo+ICsNCj4gIC8q
Kg0KPiAgICogc2d4X3VwZGF0ZV9zdm4oKSAtIEF0dGVtcHQgdG8gY2FsbCBFTkNMU1tFVVBEQVRF
U1ZOXS4NCj4gICAqIFRoaXMgaW5zdHJ1Y3Rpb24gYXR0ZW1wdHMgdG8gdXBkYXRlIENQVVNWTiB0
byB0aGUNCj4gQEAgLTkzNyw3ICs5NDAsNyBAQCBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkIHNn
eF91c2FnZV9jb3VudDsNCj4gICAqICBlbnRyb3B5IGluIFJORy4NCj4gICAqIC1FSU86IFVuZXhw
ZWN0ZWQgZXJyb3IsIHJldHJpZXMgYXJlIG5vdCBhZHZpc2FibGUuDQo+ICAgKi8NCj4gLXN0YXRp
YyBpbnQgX19tYXliZV91bnVzZWQgc2d4X3VwZGF0ZV9zdm4odm9pZCkNCj4gK3N0YXRpYyBpbnQg
c2d4X3VwZGF0ZV9zdm4odm9pZCkNCj4gIHsNCj4gIAlpbnQgcmV0Ow0KPiAgDQo+IEBAIC05ODMs
MTIgKzk4NiwxNyBAQCBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkIHNneF91cGRhdGVfc3ZuKHZv
aWQpDQo+ICANCj4gIGludCBzZ3hfaW5jX3VzYWdlX2NvdW50KHZvaWQpDQo+ICB7DQo+ICsJZ3Vh
cmQobXV0ZXgpKCZzZ3hfc3ZuX2xvY2spOw0KPiArDQo+ICsJaWYgKHNneF91c2FnZV9jb3VudCsr
ID09IDApDQo+ICsJCXJldHVybiBzZ3hfdXBkYXRlX3N2bigpOw0KPiArDQo+ICAJcmV0dXJuIDA7
DQo+ICB9DQo+ICANCj4gIHZvaWQgc2d4X2RlY191c2FnZV9jb3VudCh2b2lkKQ0KPiAgew0KPiAt
CXJldHVybjsNCj4gKwlzZ3hfdXNhZ2VfY291bnQtLTsNCj4gIH0NCj4gIA0KPiAgc3RhdGljIGlu
dCBfX2luaXQgc2d4X2luaXQodm9pZCkNCj4gLS0gDQo+IDIuNDUuMg0K
