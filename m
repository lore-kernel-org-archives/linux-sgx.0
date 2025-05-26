Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8F8199FAC;
	Mon, 26 May 2025 11:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748259940; cv=fail; b=FWMS0i66o1kc4PT0FrEvprg9m9z9+uheZ62zBPQj1uz/7rHVdXuUvselqvcVG62luPc+EWJpV0Ki8TkSI7hs4W+jakccxc/QstTZbnSii6nYRu4WRPsQgiVPy1Xf1MgfFsQrHFbk5pcrtFlTfUaW9B+GaD7zbYFDASx/kK1AzKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748259940; c=relaxed/simple;
	bh=Qk+8jmgHGX+QB761IAhAkNCZdMOP2AzQHNxr2RNh5Co=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZHfrDis5A00Z90dxoO4YvUituQ9vzYheENh5QblEakxRRQznuugAUTwgK/8gKNx2zIh7gkUbi9k0YPQzJf2y/0UO6hD9sh92zcI776Ln6oIOaB8+oyoVz6Gx/q3Wrt1NTth2gluGWZ2b8U6BUL+yx8WksigpUVyxeNhJ4w6n80E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VuKFIvb3; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VuKFIvb3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748259938; x=1779795938;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qk+8jmgHGX+QB761IAhAkNCZdMOP2AzQHNxr2RNh5Co=;
  b=VuKFIvb3EKVwSIVktp3a9oAksLxIyO0Ys1SNeqV5PiuwW5n59MAa655J
   JkHFuVcesJ0kiI7ZymN0tEcvt8ZRrGq+o5GgWl8c2PKETy871PgN4Imtl
   zw3EldafhcyzGm06go1MK3e+hQ2/Yd3lpCQhI17vu4aGeHlhWjr6wo4A7
   AAXCdZrXPf7rAZs+jEhVoDc//2FnfruDtqxwiwB56c/Kz9hqjsuCcUTBB
   ioXT85n8ikt6DOuDIJnugt3EGAl9K4AyXMHM3mSO8iIis9VibZzlR2d45
   bB9XJqOX/BU6YpeavWWxJX68G8UcS6SV7ZGD02lyb85qbOsW0O0mD32XZ
   Q==;
X-CSE-ConnectionGUID: hy6xh7SfTWqxeiZ1GbzbKA==
X-CSE-MsgGUID: qoaek6L8TtS2TG5/PXmFTQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11444"; a="54025449"
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="54025449"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 04:45:38 -0700
X-CSE-ConnectionGUID: bVnOclxhTwWmqbeFsNRr/w==
X-CSE-MsgGUID: 6Mqg6pbOSs+jx0BNuIag7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="165527224"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 04:45:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 04:45:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 04:45:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.55) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 04:45:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sv7hMquW9XNZu9MSe6f2Cq3+uqm8VuW0QFKDtc/6RayWn04Ren4gJv/KZD43j5+hbgVoQbqsyzDf3yiBolpzHCCO8dCLlAsf86jJd9Sm7Ik4noYbuTtnTzmBbWw7aFAI/KiPJhpoNKn30vAWRG34MtKv8XAZLVKFx6c3P23Z6K18kGdharja3ZeshvuoAZ/DEHc+xoqeI59fIKqyvkt10uqP7kNlVUh/JDJkHEpeYfa+zF/YQfBLzl1ww7vSb7ja6JEBsX2SmJKnSV/wk+H0ihj8oZrp53ehTPrdOPveb2PuaFxasG4U9CETxrOk/89MWmeJ0DeSwwyBb0Q1LstdCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qk+8jmgHGX+QB761IAhAkNCZdMOP2AzQHNxr2RNh5Co=;
 b=DCLi9IzY2Vu277UmHLGWVz33KPWqCHyMWPUzLMg4UIN2U93UOR2v6ecJc9+f24NheIpMTZy054+BNi4PDaTvgTGVWuxE/FZav6KpsDFlomQXfLI8HJ6IwdDl3Gnva20UAtw9PwhR2CbCOTcGlnMKev7RVYnJhTqjTMyL78mRbpe1s2pqSlZj+fvkGm86oCoH/tjnow3Hns+gSOwjsrnjt98y4IygNqXTrKcpNSJXEgbMxSsQPOjs+YphCfPd0onmKG8sa2Fjgs+H0bXJLpK5P537+OJKqDTKF0MlJU5M6EblKw3VDehJgIv0GAVsCBJWuWdZHi9Lvox1Yvt1pAdUgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CY8PR11MB7012.namprd11.prod.outlook.com (2603:10b6:930:54::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.24; Mon, 26 May 2025 11:45:07 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%5]) with mapi id 15.20.8769.025; Mon, 26 May 2025
 11:45:07 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyvsquqNiUCfiSU2V76ezJnd3LrPgX96AgARwvYA=
Date: Mon, 26 May 2025 11:45:07 +0000
Message-ID: <DM8PR11MB5750056460866A573DBB8603E765A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
 <20250522092237.7895-2-elena.reshetova@intel.com>
 <aDCaH2WAMhLhFAVE@kernel.org>
In-Reply-To: <aDCaH2WAMhLhFAVE@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CY8PR11MB7012:EE_
x-ms-office365-filtering-correlation-id: 860404a7-b2ab-4518-38ac-08dd9c4ac314
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dTg0YngrZVhQcVZTL3BGWGZvSk9hdTY2SXhDVFpKMDFsMUlNa1lOWElwVFda?=
 =?utf-8?B?aVpJRGpveldxYjdxc09lbHlVWUg5N3NSNTFFNFl4M0pLRmtmV3ZKcVY1Nk9N?=
 =?utf-8?B?U0lTNFBYTE9hQlVySnlvSEdVRzUvcWFyM3B6Z3UzRisxcTNNSjRTTHZ2TDV5?=
 =?utf-8?B?cHFpeU1JaUpZRTR1eXd5RGlHTWRxKyt5VWwxTWptZDlQR0xnU0VKVkVZTk1R?=
 =?utf-8?B?T3pOT0xGMTlpRXN6VjNTcnA3Q3UxQXNpVGM0NVdnR1ozVWNJdDdudzZ6RFlt?=
 =?utf-8?B?T1ArYXpLVkJCazVya2d2cmgyWnF1blZQckZVQm03WkpIK1FzY3hvWHhZOXpU?=
 =?utf-8?B?N3p1NjIvRm8wRUJSKytpS1hWZTRlYmprWkRRTWJRNkhTSkE2c2FoZ21YS2lM?=
 =?utf-8?B?ZjlTK3JraDgrVWRWNFJtbTk3K1NhWkhOclU4Uk4vbnRtbUhxOVFERCtvZ2hM?=
 =?utf-8?B?MWRpOGloT0tiNlR2czJDL1I0VGgxNTJaMThSVVBZM3oxVVRmejQvNy9EdFVU?=
 =?utf-8?B?c3VVc3gxT1FTL0RYZ3FjYktCSGFScFJOWkVIWjQxTjFyNk9RQ1d2VmFGelFt?=
 =?utf-8?B?Q1ArT3RzU1lYdXBacXdGZkVZbGhUK1VlTFIvbnd4dEx0Q29ER3A3MEU0WHZ1?=
 =?utf-8?B?M0FFaEt4bTlGVFl4czBzanpwZy9ScG44S1g4TnVtOUc3QUhOQXVxaVdqbDdj?=
 =?utf-8?B?djBsRUcrRVI2WGVYUlBVbkE2ZFpaaWFXN3Nid3BXRHpyOVFzTUJXSnhud3RD?=
 =?utf-8?B?MUFwaTlwbkRCbHpjWVZTY0RBRFErVGFGVkgzT21KMW90dTIxcWtRRTZTbkxS?=
 =?utf-8?B?REdHSGNBNkw0a1JKT1NnRjJoOURVYXlGWE1UeWNYV25UWnZmOWtWd2JNQkQ1?=
 =?utf-8?B?U0NZMSs1Y216Tk9tQzYrM0JOT0dTSFdBKzBNb1ZRTEdCb2lyMGs2NWZWRUV4?=
 =?utf-8?B?STc0ei9wVkZBOWZPMFd4cW45enYrL2R3cE93bnQ5ZDJmWjdEREpZZitvSGtm?=
 =?utf-8?B?b1d6ZnR4MUdXYXY0LzRTOXZsNVZhQkhXZGZSSy90ckN0ZDdHNnV4TnhkejJh?=
 =?utf-8?B?QVVGVnhjdkl3QXR4UlBFbC81Q0pVVVRWRXAxMXNJYU9mNENQdUdGMDZndFlH?=
 =?utf-8?B?bTBPeVhpUHI2VVBxb3FJWFBOYVN5MkRjV3VNMjltTU82Vm9weWVJZWJHOEtX?=
 =?utf-8?B?amNBMm5IOGhLeEMwV0FCSXN4S3lZc3pFaDBEdVdZWFB6ZlUrUWNGTHhwSEkx?=
 =?utf-8?B?UU9EenpyRlpiZGs3RG5Pc1ByMDVLRVZCWU95UWxBT1REVWlkR293Y29laTJT?=
 =?utf-8?B?N0FvQ05UVHhFZXFTdFhoOUM0RnNBazFLd2NLbHk1WkNRNkhJK1E2Y2dVRnk1?=
 =?utf-8?B?QUU4NDYzc2xQdkoreGQvWXJzb01pNjVsaXdCTTJxWFdMZmZNZncvVUVPWjFJ?=
 =?utf-8?B?VlErQlBzR0IwVDYrYUdxSHBQM3I1MzAydU9haXFtU3ViK1BleWkvRmFuMDh0?=
 =?utf-8?B?U0U1ZG1MNkE1MGZCNEVwejFPNEcyYjUzUjcxUFMya0NRSStuVDdodG02SERE?=
 =?utf-8?B?N0VhSDdXRGQvVzNDVldhMXd6RG5ocnIzeTFXTVUwUktld2Yyb1IzL0w5KzdY?=
 =?utf-8?B?Q0tLRGI5N1k5WWZRemZpaGVrSXVoUVFVaG0rcHhyczhNNUIyd253MW1Nc1hF?=
 =?utf-8?B?b3ZBNENjUWpIcnRNVnh5SG9PM0k1Q2hzWUlMYkcybUtRL0s2WTBqd3RBekN5?=
 =?utf-8?B?c1VKdjZ5MngvOVNPdEVQY1AvNjZSdXRRSVJVZVRNSGhKMktxWmJVOWxSbERw?=
 =?utf-8?B?M1ZoV3I2amZEYmxFWHVzRVJ5a1h1dnZsbzRVT2lZdFVqTTkwWFExZW1sUnRl?=
 =?utf-8?B?VDBWMnNGYklQOW5ZNmFTRzVvYVRrNXFpZHI2SnBGa0NDS0x3MmlwVzVHeEZN?=
 =?utf-8?B?TVI2TnBLK1VWY2kzMlNZSi9kdWdUdHBNcGpHM1BRdXBnWFZBbTA0VGVXTVdR?=
 =?utf-8?Q?wwlkxW45lxKZX9nGY2VuAVcAXe0PT8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2JvTjE3MHhQOC9xVmtwY2U4SHFheGxZdlUzK0wxRU9CR0M5YW01bExiSU5a?=
 =?utf-8?B?WkZ4T3dLWEhWR1BxclV5VFA3UktsYytYZ3NGSXdMQUlFOFJSZ1BZREVUZUVs?=
 =?utf-8?B?SDVMdXlycWZRYnpOdXdzQXdId0oxdkVHQTRMKzZSbXU1N3hiREJlTTVYNmp4?=
 =?utf-8?B?Z0kreEl4Wi9GZUxxRVgwSlVqMWptRHV5YWNTMXJPbGtWaFNjcXJabFlIY1B1?=
 =?utf-8?B?OG16WW13Q1k0V2srZU1YVWE3QmZIRWFwU2V2T1k2YWdadDhYOW82ZHZFTEJh?=
 =?utf-8?B?dHM0eDQrRmNpOEFEQmxodVFHQ3VNVXhHSVBmNnk0WUNFM0tvaE8xdXovU2JF?=
 =?utf-8?B?VCt5enBJWDg5djh5U2dJUHFNOTNJcXUxRERQNHc5SXA4OUljWSszU29XVlpT?=
 =?utf-8?B?bmNiMjloNHBWRXZNdFVtTlRFVkg5QjRxTDRIMXZNMkxzME54b1p6a1N5UjlW?=
 =?utf-8?B?dXFqSkZGSk9aMnlMWUVqT2ZsMVRVM1Z4V0c1ZnB0WkNaWkNLbDluaE5DUktX?=
 =?utf-8?B?bWJrRlJ1K3VGczF4OTlGb0dHNFBxY2l4OFFONU9sb0pRUHFzWDRZSDViVDhS?=
 =?utf-8?B?eStNSzRSSnNZbFlTN3VNU3Y5Z2xNVnpERGVKK2lBUUZFZnorenVOaU44SGw2?=
 =?utf-8?B?TWdsN0FvMUNRc3R6S1MrYjFXaVY4c3ErK2NHMy9OMjRwUlJ2SzlvTmcvYU1B?=
 =?utf-8?B?VjBoL2pCWTBNOSsrUVJyUUVKcTVibHNZaUxlOUlvWUhRQzBlREx3ZGUveG4r?=
 =?utf-8?B?Y3FhUTRNa2luOFdJSWk4ME5WVGIxSHNyeTNrTUZldzltNERveEF0UExsd3F0?=
 =?utf-8?B?Zmd6MjdRSiswQlZ6OVdaU0xJVG5CL0pCV2VjWnlCQWp3eUlBQmJsVllVNHFB?=
 =?utf-8?B?UHlSOUpobHgyTkNONHBIemRHc0tCdWxSREZsSDJaWmhtN0dpa2hvbmFUTWFs?=
 =?utf-8?B?SENJYjFyaW1wL1UvTWJwbm5JR0xneHdrS280dFhuZk9aUlFCVklXTGVPa1ZL?=
 =?utf-8?B?WTZvT0JTL1orTFVRUFNwQUZtTDVtc0FuRXJSOUk4YVZUbEJTYmRqaExJc1Jo?=
 =?utf-8?B?OTVyZ1hra3lJRFpVTVRseVNjREwxRnV1SFFhcWRBTGJzREpha3BTY1pFYi9p?=
 =?utf-8?B?Q3ZIMm1rMWc0Sk51dlhsZk5tNXVHWnhlOHcwNW5rdmpZOUFXalBsenBObUt5?=
 =?utf-8?B?RXRtKzRBWVNJN1pOOVljSGxJeG5La1U5WXdMTGlhclE4amNCZXp5Q3RIbHcv?=
 =?utf-8?B?cUJEZW9vMlpLWGloWkJLd3RLV0t1RS9mYVpXT0JCZ21QRERNVWtHTkpKcUY1?=
 =?utf-8?B?djNsR0Q3aUx2U3IrL2xHU1NMam93RzI3L3hsUlE0eTQ3cEIxWW9tamdDVVNH?=
 =?utf-8?B?RU8xWHBYUmhQOHhnRHRmRllTdjllM3VzeExsRkhNVFNTNDRGSVZtZllvZm1V?=
 =?utf-8?B?enlJMXV3RzhvYkJXWjFaeklmdE4zL3FnUDVZbXVqYmt0MFdJSU8xUXM0eGk1?=
 =?utf-8?B?THFTQms0YS9McldsK1F1TzNPZ2EzVkQ0VHE1c2pZTEJNYThVL1NFcjV4Q3F5?=
 =?utf-8?B?T3JGUURQYTFZYjlYb2NackxleEhQR2J4WnJHSndYTGtjN2F1RVlTaGxTWUpw?=
 =?utf-8?B?NjlweVhoYTJRTTFVZHhrcEUzU2h5MGVvSTU3eDcvV2IwVmNvSXNtSzc0ZGJR?=
 =?utf-8?B?MFhLTnNab3h4cDFER0RielZOWEtLS3hicjR2L0Z1NUkrNW9YMHN3S1kvM3U2?=
 =?utf-8?B?Q3oybHR0WUxZOTAxSEZXd1d6ckdpUEVwS1pTamQ0Nm1XZWNuNmFMSUxBMFRC?=
 =?utf-8?B?NjY0QSs2MUwyR2JKQzNndDJZOU9OYVFqRHVsampVcGJJckZqNGtpVU5oT21X?=
 =?utf-8?B?c1hRdlBwcE50Q1FsaGFFYWdVY2FFZVZVdGViN1Rac3E5TEl3TEVpdHR0V1Zy?=
 =?utf-8?B?Yk53QldMaTMvQ2tsUFNOSUN6YmJ5cjdXTEhGcTlhWTFRZ2hzUEx4Vnh1WU51?=
 =?utf-8?B?blN5M2kyb1VvTnlQMzNoZ2dtNnh1UE03ZHhvbW1EakRUMkpHUGhacW5yRkZ2?=
 =?utf-8?B?cDdRaGhDSDYybU1QdjBIMGJnSGNhaUhJOFFxSG5tVE9MM1dxVWxCVG9qcGxX?=
 =?utf-8?B?MWE4QVh6TUljbDNKV2pJOWhFWVNvSFBKQ1p0UDNVR0oxWjVFaEZ1MzlWVld0?=
 =?utf-8?B?K2c9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 860404a7-b2ab-4518-38ac-08dd9c4ac314
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2025 11:45:07.0275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: clrsji3Z4zGABzpnZU6U872VV3W8qmzzzfbZEl4MfMu9iwW39MqoE3VNC4yeY9BEXolL8VZNMiJVxs3qANc6TF/7PlxuyXdVlA7yE1GP0yI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7012
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFya2tvIFNha2tpbmVu
IDxqYXJra29Aa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCBNYXkgMjMsIDIwMjUgNjo1NCBQ
TQ0KPiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4NCj4g
Q2M6IEhhbnNlbiwgRGF2ZSA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPjsgc2VhbmpjQGdvb2dsZS5j
b207IEh1YW5nLCBLYWkNCj4gPGthaS5odWFuZ0BpbnRlbC5jb20+OyBtaW5nb0BrZXJuZWwub3Jn
OyBsaW51eC1zZ3hAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVs
Lm9yZzsgeDg2QGtlcm5lbC5vcmc7IE1hbGxpY2ssIEFzaXQgSw0KPiA8YXNpdC5rLm1hbGxpY2tA
aW50ZWwuY29tPjsgU2NhcmxhdGEsIFZpbmNlbnQgUg0KPiA8dmluY2VudC5yLnNjYXJsYXRhQGlu
dGVsLmNvbT47IENhaSwgQ2hvbmcgPGNob25nY0Bnb29nbGUuY29tPjsgQWt0YXMsDQo+IEVyZGVt
IDxlcmRlbWFrdGFzQGdvb2dsZS5jb20+OyBBbm5hcHVydmUsIFZpc2hhbA0KPiA8dmFubmFwdXJ2
ZUBnb29nbGUuY29tPjsgZGlvbm5hZ2xhemVAZ29vZ2xlLmNvbTsNCj4gYm9uZGFybkBnb29nbGUu
Y29tOyBSYXlub3IsIFNjb3R0IDxzY290dC5yYXlub3JAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIHY2IDEvNV0geDg2L3NneDogSW50cm9kdWNlIGEgY291bnRlciB0byBjb3VudCB0
aGUNCj4gc2d4Xyh2ZXBjXylvcGVuKCkNCg0KDQo+ID4gIC8qDQo+ID4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4
L21haW4uYw0KPiA+IGluZGV4IDJkZTAxYjM3OWFhMy4uYTAxOGIwMWI4NzM2IDEwMDY0NA0KPiA+
IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiA+ICsrKyBiL2FyY2gveDg2
L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiA+IEBAIC05MTcsNiArOTE3LDIwIEBAIGludCBzZ3hf
c2V0X2F0dHJpYnV0ZSh1bnNpZ25lZCBsb25nDQo+ICphbGxvd2VkX2F0dHJpYnV0ZXMsDQo+ID4g
IH0NCj4gPiAgRVhQT1JUX1NZTUJPTF9HUEwoc2d4X3NldF9hdHRyaWJ1dGUpOw0KPiA+DQo+ID4g
Ky8qIENvdW50ZXIgdG8gY291bnQgdGhlIGFjdGl2ZSBTR1ggdXNlcnMgKi8NCj4gPiArc3RhdGlj
IGF0b21pYzY0X3Qgc2d4X3VzYWdlX2NvdW50Ow0KPiA+ICsNCj4gPiAraW50IHNneF9pbmNfdXNh
Z2VfY291bnQodm9pZCkNCj4gPiArew0KPiA+ICsJYXRvbWljNjRfaW5jKCZzZ3hfdXNhZ2VfY291
bnQpOw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gDQo+IE1heWJlIHRoaXMgd2FzIGRpc2N1
c3NlZCBidXQgd2h5IHRoaXMgaXMgbm90IGp1c3QgYSB2b2lkLWZ1bmN0aW9uPw0KDQpUaGUgbGFz
dCBwYXRjaCBpcyBjbGVhbmVyIGlmIHRoZSBwcm90b3R5cGUgaXMgYWxyZWFkeQ0KcmV0dXJuaW5n
IGludCBoZXJlLiBBbHNvIGVycm9yIHVud2luZGluZyB0YWtlcyB0aGlzIGludG8gYWNjb3VudA0K
cmlnaHQgaW4gdGhpcyBwYXRjaC4gRG8geW91IGhhdmUgb2JqZWN0aW9ucyB0byBsZWF2ZSBpdCBh
cyBpdCBpcz8gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
