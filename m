Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2031217A2FB;
	Thu, 24 Apr 2025 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504204; cv=fail; b=LadPmTmzezYadfcHdbqzlYCO88b8RqOiHwmaPD281OsIX4X3VVWPBNnPP5mfTFo+yHo/NIfAXUVvcviGRGADX2gzWVGA94kqoHxTRlzJIDamtnIV3BGMVW5tIaQo2aDB7xDsT8+22Zx34ZQ469jljMRpyAHXi+Kw1nuD1q8e0Qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504204; c=relaxed/simple;
	bh=Wte3XihrxYowjz1gguZV60gIHsvx3W2vX2jPODTCelk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XuFnt9tWzYEa//2BSf+RflEx/T+lFzSNpxrfGUCZDUEEqGuNfw1hrMlfonUquEFXkC/XZlqQAKsFHl3Vf+1wEUdga1zwj9mmUJaF5wB12R+DYdunQ+eJaS/1X1yMa5cGN+EavhRd8COR0iJ3f8CNIAS2U2Nvhp3WB7NT5hatZ8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iYkfcS4d; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iYkfcS4d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745504202; x=1777040202;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wte3XihrxYowjz1gguZV60gIHsvx3W2vX2jPODTCelk=;
  b=iYkfcS4dbqSdVYIxwcAMeO6LvQh+FLhhC6OQFrML8eQhKB98pBrK3oOf
   h+Ok8B+fojZepKpZh0dRPJFrtsr9wOnJPwgvXgRhSzgxWq99qCuTpypU5
   p7Q0jLcoc343wPYlOfpzA7qjA3FA1O6hNlYmG7kt0dcm/zycbNFOJ+EBe
   QHOCkDlkOFclVUKUbxN/cXpRAApz355/fVIT+orrZFBuisjjuGFu6ZYCT
   LS8zM7kw02m1q77iSrDfZK2Vbi6A+l76m37df41iW093nZ8K68GBNEAkY
   7qF/17utywbGjIoG4ybM/5l8ZKaqJHGm+66R5TXtYeKh8YjeBq/vnhnvd
   w==;
X-CSE-ConnectionGUID: IboEVD4bTcW3xsxfqib2Eg==
X-CSE-MsgGUID: LoE4UTwnQL6qZ9kK4AIj1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="50947461"
X-IronPort-AV: E=Sophos;i="6.15,236,1739865600"; 
   d="scan'208";a="50947461"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 07:16:41 -0700
X-CSE-ConnectionGUID: A++oUWXFQ7amTpD/8dO2oA==
X-CSE-MsgGUID: wZoaCdI/RaeQSoK1t9am4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,236,1739865600"; 
   d="scan'208";a="132611389"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 07:16:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 07:16:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 07:16:40 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 07:16:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AiacKw4OAldBkQzL+w17LIuJkZK/YVyZa/w0oVJ0I22JmLnzp76asgKpUYdGWeDu4uwEYGjDqqH1g2KU8bwTQZLY/GfnRa9zrN9OyQ0XtN7I+zmHkVonS3X0DSrwysXuFaFItEDtda/rWG0vEFzbMr0AuKimAH5g/pylVyx41tFLKMDtHuXA9wWf/ByTfWNU1eZ799/b5YidDghH/L7GvIB/Z1eBm1cuvMzjTb4/kq8pfAXpBc2LlwY3fZ7h4UXjBHkaTkWolqYrua4n4gnXIAJLdkb0+58VEtgubBOS/WiHjhTOW2WMkGMT2YsGyz8Z1JknM7HsKYrx38l1Lp5GMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wte3XihrxYowjz1gguZV60gIHsvx3W2vX2jPODTCelk=;
 b=W1rZ7xyLKkCUl4jbQ/Ulf1SmxVLDW0Rx2RgC2nHkyXbir1f6BrNTcwkcEVVcV/mP4WpKaNGPYktq1ppeWH24kj/dOCY/Wan91OHLNjUSXbBP8hn+nCSfV/81oxwkDXz5BH8JLbcT7aSywqCux/n8qBvvjjY7eZJJB2LIk+R9e1VGO5BPUHejS7h9s7WCb91YWqecq0LaXxwsUV8bTGJAQiYdiTeiCm/j98tFlOu90rkOloUlK26BAUfnLGTL9QTr1Kca6jhAkAsVPn8AWmJDhMfPrMyw1T0rbuQTxjeHy8PthfhNduJX1y90fgUk94tT9GRulIMh/jMYl6zytCLTkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 LV3PR11MB8580.namprd11.prod.outlook.com (2603:10b6:408:1ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Thu, 24 Apr
 2025 14:16:22 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%7]) with mapi id 15.20.8678.025; Thu, 24 Apr 2025
 14:16:22 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Sean Christopherson <seanjc@google.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>
CC: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Cai, Chong"
	<chongc@google.com>, "Mallick, Asit K" <asit.k.mallick@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "bondarn@google.com" <bondarn@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbrfzujDHiSNozs0m8Z6fqnS5FZ7Oph/QAgAXK54CAAG1QAIACw3gAgABd6wCAAAZ2IA==
Date: Thu, 24 Apr 2025 14:16:21 +0000
Message-ID: <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
 <20250415115213.291449-3-elena.reshetova@intel.com>
 <aAJn8tgubjT5t7DB@google.com>
 <f5cb3c37589791b2004a100ca3ea3deb9e1ae708.camel@intel.com>
 <aAefmNVRFc3me6QQ@google.com>
 <DM8PR11MB5750B37305B3B1FAE4F42D3AE7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAo_2MPGOkOciNuM@google.com>
In-Reply-To: <aAo_2MPGOkOciNuM@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|LV3PR11MB8580:EE_
x-ms-office365-filtering-correlation-id: 8ece0bfc-1d39-4753-e038-08dd833a96e9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bHhNNXZockx5UVJWblpMV2Rnd2duV3pkNWV3cXpNVlBlYTJlcGdvSktmd3U5?=
 =?utf-8?B?bzA5NDVZMXcyZkRnRUhFanJ6Ym1rUWlMWm1zcmhFTXM4NWZnOWdnS1ZwMTBl?=
 =?utf-8?B?NnNIdEQ5RnhXUU1ibWtnRVV5QWdzSDVmTXBoOUsycWI5NjF3bEloSkh5dGM0?=
 =?utf-8?B?OERiMERSMlk0MExMVDNEK2tYVitBT05tMjBBcFMzdVU5THFNS0xqWlpTeGgz?=
 =?utf-8?B?S1RCSmpQTGpFY21qTmF2cVBZZlRKaFlCWW5MV0dRZHp6Q0xkcEF5aUEyZDBG?=
 =?utf-8?B?Z01Ua1MvT0lGN0VrOHM0TTFPaGFDYXFoa0FpU3dwOFBOU1pKVjhZZEh0eHdZ?=
 =?utf-8?B?ek5WZGdzMkpWd1ZZNDZEUjM0T2gvQ3MwdlNFVXVXOWdJVW4vYWEzb3lIcG5V?=
 =?utf-8?B?bExPc2ZmQ0Jvb05JZmJRTmw4L0xLTzdkZlA2R3Rxb3NraWZqUUFTcy94emR5?=
 =?utf-8?B?aFI1UXJRbFZjMlY4a0NTakF4VXFwWEdaWStncFV5Zjd3R3FDY2dDY3NuUktG?=
 =?utf-8?B?a245aVY0R0U1UzhTY2xaQXEwNjVIbTIrODc5aDVKanVXUUo0K1pLVGEzUDVz?=
 =?utf-8?B?aDZaU2pMdnlLUm9kTFRpOUNCSFpYbkp0bFBoRmRka3BBOUY0VVF2azdCdnJ1?=
 =?utf-8?B?YnoyVVJzZkhiQzFaNkF2c3NKRnl2QTR3TmZLU3R2YTRTN29LR2lPYm9HWWw3?=
 =?utf-8?B?aGtBcUNoNE1JYkk5cVYxcjJJRXNPMlBPL3lyZFpRVjdPNDZ3Nk5PVHBSaW0r?=
 =?utf-8?B?R1BrVDJ6Ni9ITzhyc04xaFBMVHpGQlFYOVZCZDBhL01pY0ozTE5HZGZjVm4y?=
 =?utf-8?B?c09jM3JtcEpjemJwQmZvUVFBUE0rL0JiK0tnWWZiaDhzRWZYcGJ6UG9FQ3cx?=
 =?utf-8?B?MlJ0RTNJTFdJekFSbTdSNExFSG13b3dJSCtpNjVNTkhjWXBjd3ZOcmFZNEp0?=
 =?utf-8?B?Y3plbVVNbnJuWXVQSWJkd21STDNibGdlMXAwVk1HRkkxa1o5QUR0WnZCaFVo?=
 =?utf-8?B?SnlaaldNTkxBTHl6NERXZmpBcjBwSWVlVEdFYjRsOGFLTys5WUVqSGpBbnJz?=
 =?utf-8?B?OWlOQlluZFB0czBvLyt1VnRtaEtvQXNld3NBTzNWbm1yVkQzbkFiOHg2dmZv?=
 =?utf-8?B?MGd5ekMvakFpbDRhQzk0d2NUNzJpbGVieG5CdjJyMktoNlpyUGNjV0dwWG0y?=
 =?utf-8?B?L2J1d1pyVElPSkFQaiswNWN2UFd3ZWh3eWtkSGF3dkhrVGNtOUhTcFgvckhC?=
 =?utf-8?B?TnpFV3RBZ3prZlBWdWJWV0pEb0Z0UkhkbW04dVdhVHJha2hrQ2NJVHhDa3F5?=
 =?utf-8?B?MUk0RnJoeWMzQUdrU000VENtaVNZV1RuelFmQXpHWm1iV3M2QzBRV0FZa3RF?=
 =?utf-8?B?STBlSkloSmdWdzBhUFowS2RTQks5aGhHUW9HSTYreDROYTgxekZMMnp0Tk5E?=
 =?utf-8?B?b2ErUVRidkFJVVlpTkZ6c1hJb3dQdXZQaGhyS2VJbzBrUm9Pc2tDTng0T3Mv?=
 =?utf-8?B?MGRFN1hVMDdqV1VDa2lwZ3hRL0NFV0tWK3UwcmxEZ3JjL0N2VjZvTm5OMzBJ?=
 =?utf-8?B?Q0ZaTWZ1Q1VYT1drcG9McklHdUtGYUdwcjQwdEZjV1VqVk04ZStiU1haZkp6?=
 =?utf-8?B?REg0K3VXRlcvSmRoWEZUNzhRNW9tZ2NNNVhBUXlsYWhtdzhwKytIZUJrY2Qr?=
 =?utf-8?B?eFI2RXd6MmNiZ1l5K3M5dUpwYjI2VnAzRDJXU3RSRWl2OUZRUFFGdjVXUnNN?=
 =?utf-8?B?UUtLYmlwYnBicDVtUHNacmxxVEtPbTZEWThrMWRyWTZnR0grdWw4eVFDVHZ4?=
 =?utf-8?B?TmhsVElJSDFwRzlIdHdKWnpJU2RrVHUxSEJOaXdnNkl1RlJkQmJEZjFBTnJW?=
 =?utf-8?B?RU9xQWNaRHJCRjdiY1NLQnoxNHdCNWdILzdaUnh3ajBISGxtVHZ5VnJocFV6?=
 =?utf-8?B?cE5ScHFHRWVsWGdaUEE2WHBKS1ZsaUtVanpRejVoSm9TVlZWQ0VQakdTMnFh?=
 =?utf-8?Q?6Tt/Roo71KpmNmuRZX98N3k7zWQUPM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjVDVVZ5OEhJS2xHRTJCL0Q4QUdPNm1oMWU4czFSMGhRQlNwUnBISnkrSnZ0?=
 =?utf-8?B?ZjVES1prNnZOYmhtSEtoa3E3SVYrZ2M4ek5GTnErVEZLMUZNb0t2Z205aHBC?=
 =?utf-8?B?MndOaDZlSU8vTyswbmk2NFV6L0xaZllaWGpwRDAyU0Y2S0VBaWxBY2oxV2hW?=
 =?utf-8?B?aWZoZHl0NlpvQ28xM0tmSHhrV1pwZkJkMTZReldlcEIveHRzMHdwekVlSW9y?=
 =?utf-8?B?Z3g2QkZGUVVlR0JhNWw5SDRKTnQxT1h5SGNOSDJkbFFCL3NBSG9zVVc4R2pL?=
 =?utf-8?B?NW9TdFNMOVF1UUFCZDF3R2pvcjJsbE01TE5ZMklIa2k0UFl6dUxWTG5uUy9T?=
 =?utf-8?B?ZVBCbXljZlZvd2RXOGNscGR5QnFram96UytqYnRETmsyWFRBQzN0dVBtOFRj?=
 =?utf-8?B?VjQyN2NsWW1OaSsxbFJ6c3hHakNIekw4UU5Id1hTMUJLOGx0VlY0SXRkQzY5?=
 =?utf-8?B?NWxhR3Q5N25TaHlSbWZHVmh2NVVndkltNytQNnV3OWVSc3BwQkVmeHBadFBK?=
 =?utf-8?B?RzRGK3pVbzdYSGhMTXpnM3lEUzlYc2o4dXluMjBmQk56VFJJYVJ4UzNLU2Fu?=
 =?utf-8?B?MGlGVXVyUVVuQnpJSkc0cDREbjRqS2E0c0hSNXdCYlo0eHhScmZKY050OUVw?=
 =?utf-8?B?d3V6ejZDTmNNS2tsWWtWYUxXZTdiMDRhR3FJKzR6d1A4VTNDMEkxcWlvRFNF?=
 =?utf-8?B?bG9sWXJVS3MrYnFlWEpLUkdOSUcvSW9VNWJhbWRleDNkK0hOSUw4cExyMUZj?=
 =?utf-8?B?ejZueEJlclhFUkF6eTZ3T3lWME1JcGdnRklsNDdISFZWMUJUL0pHaUN4UEM5?=
 =?utf-8?B?MHJCQWhFZnBsTTJkZ2orUFNJaHZiZWo2M2hZUklmbzBQY2hwR1pTQzJGZ1h5?=
 =?utf-8?B?aFZHOVdlS2VCNU9uNUUwMDhLd0plVm1yY0t1WG03NVNRWXJXNkZiSU1Henp5?=
 =?utf-8?B?ZUVkTkdkSkZ2RjRwVjR3NldvemxtcnBTbWs2QjUxbHI0cmo2OXJyMDFJTmFS?=
 =?utf-8?B?SmhsLy9wQlMzS0UrVmljNGh1K0tWRERtQmpZeGJNWWErZjFqNEJsSUdUUERC?=
 =?utf-8?B?WFRYNHFOVGZEcjF4dmlyZmhjVHFHNUhyYVgyNW1VVUV4T1RPMldoVnBkTXNM?=
 =?utf-8?B?b2RRU0RtVHpnQm1aMGNadUp2eXZRWndHb0JUT1lOSG9WdWVBSk1NNGhCaG0x?=
 =?utf-8?B?S0VRZlNMVGR5clFhUFI1QkUxdUJtZUNRQWZFV0t2MnN3cVZXd3ZHR2NTZXVO?=
 =?utf-8?B?UXMxbnR4aHB6aXNtdU8veFpQSThiRUJWNnlRTnZNdmtRYWFCMWtFVjY0Q3ZD?=
 =?utf-8?B?Umt2Um5ycUtKdFVBTzNMNkVWU3lLK3FBeG1KZTllaURlY2RHYzRvRCt0OWx0?=
 =?utf-8?B?SEtXUTR4bThBVThaWmJGUExKbEM0SzNXNlAwWmZOejhsWWgzK1g4MXFiaEdR?=
 =?utf-8?B?T3FiMHdBSWxheEpOaHhycDl6M0o0YnlnY2h2aWdxdlNGc0lBK2czZXNBczNh?=
 =?utf-8?B?RFphUndja2pYSENrRTAwb3ZuOUlDc0ZTT1pEcGVLZ0JQMEE1RzVZS04rL3Zr?=
 =?utf-8?B?czVCQy9WZnNrYy9XY01GQkxIYktRYkp2NUZGTDZRTldTeGJ2MlpLbG0vNTNy?=
 =?utf-8?B?Z09CRXoxdzlSRHdzQk8wUFY2b1RPMW1jb3VUSlhtUFllWk9tMlRYYmc0dFFD?=
 =?utf-8?B?ZTlLR0VXc1VFSVhzUS82MVZXOE16VndKSVU4aXhUbGVIYm9mVm5XdUM0Tk5v?=
 =?utf-8?B?clc5SVIxeGtNSW0wa0FLemtoQzU2TGRzMHprNE1CSldVVzhKZ29vN2IzOEky?=
 =?utf-8?B?RXd0UlRJVktvbDJ3SjdXcFRQdHVrQ3p1V01lNE9CVHpPK0w2QnkyTjljK2tI?=
 =?utf-8?B?eVQ0M011VVhYNmsyY2ZvQmFDdzN2dVBUa21ScFJoM2t2WHloQzRPY3RlNlow?=
 =?utf-8?B?QzZzQUcvUFRheC9TdUg3dnJmdTdzQWwybUtqMTd2TlVONDNTTlJNSUd6Q1kx?=
 =?utf-8?B?MDNQdEJRaURheEhjUjVaUUMrMHIzN3BWRGhycUZGc0NpdnR1aG8vSTZ5QUF1?=
 =?utf-8?B?QU9yb2g2R0lMdlluZ3RNaUw4UXl0dnNXSzdISms4YnNqcllaYmoxLzNUK0tU?=
 =?utf-8?B?NVZ4OHFXUVk1UzEzUlh0MmFDb3daMDA4bFRyWTA1RW92ZUhBZERWQy9JeERH?=
 =?utf-8?B?R1E9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ece0bfc-1d39-4753-e038-08dd833a96e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2025 14:16:21.9514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TRjknH4sz1T49vAnh2PN6b6hU3c5S6jGLsMl2NRl5cx9+MUIr0Mn/eH3H1d9ajCfmdSrpwD7WEGMyWUqvLP9lY+3OyvfWJlv5XDFpe+EjkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8580
X-OriginatorOrg: intel.com

PiBPbiBUaHUsIEFwciAyNCwgMjAyNSwgRWxlbmEgUmVzaGV0b3ZhIHdyb3RlOg0KPiA+ID4gT24g
VHVlLCBBcHIgMjIsIDIwMjUsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+ID4gT24gRnJpLCAyMDI1
LTA0LTE4IGF0IDA3OjU1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+ID4g
PiA+IE9uIFR1ZSwgQXByIDE1LCAyMDI1LCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6DQo+ID4gPiA+
ID4gVGhhdCBzYWlkLCBoYW5kbGluZyB0aGlzIGRlZXAgaW4gdGhlIGJvd2VscyBvZiBFUEMgcGFn
ZSBhbGxvY2F0aW9uDQo+IHNlZW1zDQo+ID4gPiA+ID4gdW5uZWNlc3NhcnkuICBUaGUgb25seSB3
YXkgZm9yIHRoZXJlIHRvIGJlIG5vIGFjdGl2ZSBFUEMgcGFnZXMgaXMgaWYNCj4gPiA+ID4gPiB0
aGVyZSBhcmUgbm8gZW5jbGF2ZXMuICBBcyBhYm92ZSwgdmlydHVhbCBFUEMgdXNhZ2UgaXMgYWxy
ZWFkeSBhbGwgYnV0DQo+ID4gPiA+ID4gZ3VhcmFudGVlZCB0byBoaXQgZmFsc2UgcG9zaXRpdmVz
LCBzbyBJIGRvbid0IHRoaW5rIHRoZXJlJ3MgYW55dGhpbmcNCj4gPiA+ID4gPiBnYWluZWQgYnkg
dHJ5aW5nIHRvIHVwZGF0ZSB0aGUgU1ZOIGJhc2VkIG9uIEVQQyBhbGxvY2F0aW9ucy4NCj4gPiA+
ID4gPg0KPiA+ID4gPiA+IFNvIHJhdGhlciB0aGFuIHJlYWN0IHRvIEVQQyBhbGxvY2F0aW9ucywg
d2h5IG5vdCBob29rIHNneF9vcGVuKCkgYW5kDQo+ID4gPiBzZ3hfdmVwY19vcGVuKCk/DQo+ID4g
PiA+DQo+ID4gPiA+IFRoZSBvbmx5IHRoaW5nIEkgZG9uJ3QgbGlrZSBhYm91dCB0aGlzIGlzIHdl
IG5lZWQgdG8gaG9vayBib3RoIG9mIHRoZW0uDQo+ID4gPg0KPiA+ID4gQW5kIGhhdmluZyB0byBt
YWludGFpbiBhIHNlcGFyYXRlIGNvdW50ZXIuDQo+IA0KPiAuLi4NCj4gDQo+ID4gSWYgd2UgZm9s
bG93IHRoZSBhcHByb2FjaCBvZiB0cnlpbmcgdG8gZXhlY3V0ZSBFVVBEQVRFU1ZOIHZpYQ0KPiA+
IHNneF9vcGVuKCkgYW5kIHNneF92ZXBjX29wZW4oKSBwYXRocywgaXQgYWRkcyBtb3JlIGNvbXBs
ZXhpdHkgdG8ga2VybmVsDQo+ID4gY29kZQ0KPiANCj4gVGhpcyBpcyB3aGVyZSBJIGRpc2FncmVl
LiAgSSBkb24ndCBzZWUgaG93IGl0J3MgbW9yZSBjb21wbGV4IGV2ZW4gb24gdGhlDQo+IHN1cmZh
Y2UsDQo+IGFuZCB3aGVuIHlvdSBzdGFydCBjb25zaWRlcmluZyB0aGUgaW1wbGljYXRpb25zIG9m
ICJyYW5kb21seSIgaW5zZXJ0aW5nIGENCj4gbm9uLQ0KPiB0cml2aWFsIG9wZXJhdGlvbiBpbnRv
IEVQQyBhbGxvY2F0aW9uLCBJTU8gaXQncyBmYXIgbGVzcyBjb21wbGV4IG92ZXJhbGwuDQoNCllv
dXIgY29kZSBiZWxvdyBsb29rcyBjbGVhbiBlbm91Z2gsIHNvIEkgYWdyZWUgbm93LiBJIHdhcyBh
ZnJhaWQgaXQgd291bGQNCnR1cm4gaW50byBtb3JlIGNvbXBsZXhpdHkuDQogDQo+IA0KPiA+IGFu
ZCBpbW8gaXQgc3RpbGwgZG9lc27igJl0IHJlbW92ZSB0aGUgY29tcGxleGl0eSBmcm9tIHVzZXJz
cGFjZQ0KPiA+IG9yY2hlc3RyYXRpb24gc3cuIEkuZS4gdXNlcnNwYWNlIHN0aWxsIGhhcyB0byBn
ZXQgcmlkIG9mIGhvc3QgZW5jbGF2ZXMgYW5kDQo+ID4gU0dYIGVuYWJsZWQgVk1zIChiZWNhdXNl
IHN5bmNpbmcgd2l0aCBWTXMgb3duZXJzIHRvIG1ha2Ugc3VyZSB0aGVpcg0KPiA+IGVuY2FsdmVz
IGFyZSBkZXN0cm95ZWQgYW5kIHRoZXNlIFZNcyBhcmUgcmVhZHkgZm9yIEVVRFBBVEVTVk4gc2Vl
bXMNCj4gPiBsaWtlIGEgYmlnIG9yZ2FuaXphdGlvbmFsIGNvbXBsZXhpdHkgYW5kIGVycm9yIHBy
b25lKS4NCj4gDQo+IFllYWgsIEkgZG9uJ3Qgc2VlIGEgd2F5IGFyb3VuZCB0aGF0Lg0KPiANCj4g
PiBTbywgdGhlIG9ubHkgdGhpbmcgdGhpcyBhcHByb2FjaCB3b3VsZCBhZGRyZXNzIHdvdWxkIGJl
IGFuIEVQQw0KPiA+IHByZS1hbGxvY2F0aW9uIGRvbmUgYnkgcWVtdT8gV291bGRuJ3QgaXQgYmUg
bW9yZSByZWFzb25hYmxlDQo+ID4gKGhlcmUgSSBhbSBwdXJlbHkgc3BlY3VsYXRpbmcsIEkgZG9u
dCBrbm93IHFlbXUgY29kZSkgdG8gaW1wbGVtZW50DQo+ID4gaW4gcWVtdSB0aGUgY29kZSB0byBk
cm9wIEVQQyBwcmUtYWxsb2NhdGlvbiBpZiBubyBWTXMgd2l0aCBTR1ggYXJlDQo+ID4gcnVubmlu
Zz8gVGhhdCB3b3VsZCBiZSBhIGdvb2Qgb3ZlcmFsbCBwb2xpY3kgaW1vIG5vdCB0byB3YXN0ZSBF
UEMNCj4gPiBzcGFjZSB3aGVuIG5vdCBuZWVkZWQgaW4gcHJhY3RpY2UuDQo+IA0KPiBRRU1VIG9u
bHkgcHJlYWxsb2NhdGVzIHdoZW4gdGhlIFZNIGlzIGJlaW5nIGNyZWF0ZWQsIGkuZS4gUUVNVSBk
b2Vzbid0DQo+IG1haW50YWluDQo+IGEgcGVyc2lzdGVudCBwb29sLiAgQWxsIEkgd2FzIHNheWlu
ZyBpcyB0aGF0IHVzZXJzcGFjZSBuZWVkcyB0byBzaHV0IGRvd24gU0dYDQo+IGNhcGFibGUgVk1z
LCBldmVuIGlmIHRoZSBWTSBpc24ndCBhY3RpdmVseSBydW5uaW5nIGVuY2xhdmVzLCB3aGljaCBp
cyBhIHNoYW1lLg0KDQpPSywgbm93IHdlIGFyZSBvbiB0aGUgc2FtZSBwYWdlIHRoZW4uIFNvcnJ5
IEkgbWlzdW5kZXJzdG9vZCB5b3VyIGNvbW1lbnQNCmFib3V0IHFlbXUgcHJlYWxsb2NhdGlvbi4g
DQoNCj4gDQo+IFVudGVzdGVkIHNrZXRjaCBvZiBob29raW5nIGNyZWF0ZS9kZWxldGUgdG8gZG8g
U1ZOIHVwZGF0ZXMuDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2gsIEkgY2FuIGdpdmUgdGhpcyBhIHRy
eS4gDQpKYXJra28gZG9lcyB0aGlzIG5ldyBhcHByb2FjaCBsb29rcyBnb29kIHRvIHlvdSBvbiB0
aGUgaGlnaCBsZXZlbD8gDQoNCk9uZSBxdWVzdGlvbiB0aG91Z2ggb24gZGV0YWlscywgc2VlIGJl
bG93IGlubGluZS4gDQoNCj4gDQo+IC0tLQ0KPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZHJp
dmVyLmMgfCAgNCArKysrDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNsLmMgICB8ICAy
ICsrDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMgICB8IDM0ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9zZ3guaCAg
ICB8ICAzICsrKw0KPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvdmlydC5jICAgfCAgNiArKysr
KysNCj4gIDUgZmlsZXMgY2hhbmdlZCwgNDkgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+IGIvYXJjaC94ODYva2VybmVs
L2NwdS9zZ3gvZHJpdmVyLmMNCj4gaW5kZXggN2Y4ZDFlMTFkYmVlLi42NjllNDRkNjFmOWYgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+ICsrKyBiL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+IEBAIC0xOSw2ICsxOSwxMCBAQCBzdGF0
aWMgaW50IHNneF9vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQ0K
PiAgCXN0cnVjdCBzZ3hfZW5jbCAqZW5jbDsNCj4gIAlpbnQgcmV0Ow0KPiANCj4gKwlyZXQgPSBz
Z3hfaW5jX3VzYWdlX2NvdW50KCk7DQo+ICsJaWYgKHJldCkNCj4gKwkJcmV0dXJuIHJldDsNCj4g
Kw0KPiAgCWVuY2wgPSBremFsbG9jKHNpemVvZigqZW5jbCksIEdGUF9LRVJORUwpOw0KPiAgCWlm
ICghZW5jbCkNCj4gIAkJcmV0dXJuIC1FTk9NRU07DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
ZXJuZWwvY3B1L3NneC9lbmNsLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNsLmMNCj4g
aW5kZXggMjc5MTQ4ZTcyNDU5Li44NGNhNzg2MjdlNTUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2
L2tlcm5lbC9jcHUvc2d4L2VuY2wuYw0KPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9l
bmNsLmMNCj4gQEAgLTc2NSw2ICs3NjUsOCBAQCB2b2lkIHNneF9lbmNsX3JlbGVhc2Uoc3RydWN0
IGtyZWYgKnJlZikNCj4gIAlXQVJOX09OX09OQ0UoZW5jbC0+c2Vjcy5lcGNfcGFnZSk7DQo+IA0K
PiAgCWtmcmVlKGVuY2wpOw0KPiArDQo+ICsJc2d4X2RlY191c2FnZV9jb3VudCgpOw0KPiAgfQ0K
PiANCj4gIC8qDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMg
Yi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gaW5kZXggOGNlMzUyZmM3MmFjLi5j
YTc0YzkxZDQyOTEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4u
Yw0KPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gQEAgLTkxNCw2ICs5
MTQsNDAgQEAgaW50IHNneF9zZXRfYXR0cmlidXRlKHVuc2lnbmVkIGxvbmcNCj4gKmFsbG93ZWRf
YXR0cmlidXRlcywNCj4gIH0NCj4gIEVYUE9SVF9TWU1CT0xfR1BMKHNneF9zZXRfYXR0cmlidXRl
KTsNCj4gDQo+ICtzdGF0aWMgYXRvbWljX3Qgc2d4X3VzYWdlX2NvdW50Ow0KPiArc3RhdGljIERF
RklORV9NVVRFWChzZ3hfc3ZuX2xvY2spOw0KPiArDQo+ICtzdGF0aWMgaW50IHNneF91cGRhdGVf
c3ZuKHZvaWQpDQo+ICt7DQo+ICsJLy8gYmxhaCBibGFoIGJsYWgNCj4gK30NCj4gKw0KPiAraW50
IHNneF9pbmNfdXNhZ2VfY291bnQodm9pZCkNCj4gK3sNCj4gKwlpZiAoYXRvbWljX2luY19ub3Rf
emVybygmc2d4X3VzYWdlX2NvdW50KSkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwlndWFyZCht
dXRleCkoJnNneF9zdm5fbG9jayk7DQo+ICsNCj4gKwlpZiAoYXRvbWljX2luY19ub3RfemVybygm
c2d4X3VzYWdlX2NvdW50KSkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwlyZXR1cm4gc2d4X3Vw
ZGF0ZV9zdm4oKTsNCj4gK30NCj4gKw0KPiArdm9pZCBzZ3hfZGVjX3VzYWdlX2NvdW50KHZvaWQp
DQo+ICt7DQo+ICsJaWYgKGF0b21pY19kZWNfcmV0dXJuKCZzZ3hfdXNhZ2VfY291bnQpKQ0KPiAr
CQlyZXR1cm47DQo+ICsNCj4gKwlndWFyZChtdXRleCkoJnNneF9zdm5fbG9jayk7DQo+ICsNCj4g
KwlpZiAoYXRvbWljX3JlYWQoJnNneF91c2FnZV9jb3VudCkpDQo+ICsJCXJldHVybjsNCj4gKw0K
PiArCXNneF91cGRhdGVfc3ZuKCk7DQoNCldoeSBkbyB3ZSB3YW50IHRvIHRyeSB0byBleGVjdXRl
IHRoaXMgb24gcmVsZWFzZSBhbHNvPyANCkkgd291bGQgdGhpbmsgdGhhdCBkb2luZyB0aGlzIGlu
IHNneF9pbmNfdXNhZ2VfY291bnQoKQ0KaXMgZW5vdWdoLg0KDQoNCkJlc3QgUmVnYXJkcywNCkVs
ZW5hLg0KDQo=
