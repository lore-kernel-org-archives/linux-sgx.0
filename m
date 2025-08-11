Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091361BD035;
	Mon, 11 Aug 2025 10:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907840; cv=fail; b=gSspHa3l13LGhC/tDFxWNAkG74V5OZcb2KS/YNV4Zuv9CX2iHJHwWgvzecY6Hp7mO0qW7QncWFR4aZu7zC3KRIjiZVHO/xDFHnTUuFOI05SaTR6HFJG+X+7MgY+118pUeGGwt/b/ZDix506DuSgga/SXvjAiVV29J5bTYcIUo1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907840; c=relaxed/simple;
	bh=L5kSuZo8ricfBV+NKf/KYRWJ8Yrw4g8rAz9qyM6jARw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zn/PkGjCM7tdimGMqsFiVQglP52w0zwR5ucMQwXVktb5MQgx70694cJGD9tI4KAtNdcB9Nyje7hodaAbCdeZy95C5BPAvWRZ+UV4UfhUTnogkCdvR7Ixi6tMI2JZRInU0TD+2kJ9a1mq69qRYXugK7K3De3Fq0ZiERxqqtbU/J0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ki0duril; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ki0duril"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754907840; x=1786443840;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=L5kSuZo8ricfBV+NKf/KYRWJ8Yrw4g8rAz9qyM6jARw=;
  b=Ki0duril22w6wTYZLaN26IuLMc2mMzgnYjxrgClHGTgTZE50IsV9Ro8B
   vjt7xyQDK3a7/ZgU7SUCUwlXCpNFjuOWmmq3hWcHrxf2ses8ADhyzpJyI
   uTT2vkx5pnT6FRF3AjAXgHLx0GrB/2z7WLIJ26CDDUPTwsQz3ED8Qrw9g
   I7ltgjUWeJWwrK3AjNC3WyjaQRelmd7tgUxC2nb+B+QkRvGRjefqZfLpZ
   I1Rr4rbYTVQgTiBO1nu4IScykNlpiZmwKrBKNN6RVaD9MRxMU7/6pLvtb
   W5k2u7Put2MQ04QajJAMkgrVtQLGBnouIqq+HcYPzGIu22naVvCb0BJxB
   Q==;
X-CSE-ConnectionGUID: TAIKrLl8SHqYKodUC12zJA==
X-CSE-MsgGUID: f/kBhS+ETxW73NlAs/QYBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68237090"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68237090"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 03:23:59 -0700
X-CSE-ConnectionGUID: KtyiMW/UQmyOXeIfMIvdvQ==
X-CSE-MsgGUID: wj6VhkFnQF2KPzeWEsYkLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="166675485"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 03:23:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 03:23:57 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 03:23:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.66)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 03:23:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c1vzXxPlcy6vi7+chmSwNvYi00c1t/R68fiG3h5xfhlLl1/Eo5EwAX1ytYZvE+GhqB3Z5XIihF840aJrI2jrfzEei2FdUeqh1gdtMPPWa9lXseApNf5lROOHVY7VrBPYZ/Cmvhr14az7Ij20RdSSMMzOuI9enY2qK6O1hWJtTeN1T1jBnnMiTkeTVLgKtTNCpO0hOwsYcbCjjbSxew3t1b3g/7z9UZXGApv4PkSjVxLsE/FLeZnQIqESniio7BJ07wce1/Kw2bzVtEEcPlfa2YfRUUW9XIQ4Y2gp/PFBZQDvDwKrQvf8Oj+PTZbIO5PV6d/+st/ikjSSB/u3RxQMig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5kSuZo8ricfBV+NKf/KYRWJ8Yrw4g8rAz9qyM6jARw=;
 b=bnUAFGpz7PEk9/6I529LDtZCDAQfHinFMC+wSS7qFqxOmB9b7b95gqRaORqgZZsen2czMS25F7/3OZIQXgI1PXzWrDvFNrh+3Q613/nZ77DiHgoZKdn04renJEPOHmqAbmP7O/fPxcEdYSL9ZJcYDKJd8dkcyA3qL4hrafhrRZeYEQGpXe/FlBO0GLC9E/XRsZmD961Pxpajf6V5y6rDFXOuEjf2pUAWa/WaDPquoqUNmHgeg5MnIEebJsifLUyIowPc8v+YsvaVR9MpL4Z7HuC50GBz5HQIXrYMQ9V/79YefGjtOUtAS1uQiKlOminaapzAQJJf/82dWYDV2xZDfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW4PR11MB6840.namprd11.prod.outlook.com (2603:10b6:303:222::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 10:23:52 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9009.021; Mon, 11 Aug 2025
 10:23:52 +0000
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
Subject: Re: [PATCH v12 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v12 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Index: AQHcCp+HpmYiInFPQUOJFvDiMN/FubRdPs8A
Date: Mon, 11 Aug 2025 10:23:52 +0000
Message-ID: <c94bd946182a781f54a57d7b3e481f2d63b02764.camel@intel.com>
References: <20250811090751.683841-1-elena.reshetova@intel.com>
	 <20250811090751.683841-4-elena.reshetova@intel.com>
In-Reply-To: <20250811090751.683841-4-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW4PR11MB6840:EE_
x-ms-office365-filtering-correlation-id: 6103c4f1-cd9a-4cde-d1a0-08ddd8c12b9a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MGNYZDJuUUh0Sm55MSsvMzVsK3NCOVBpMHB6VmlPeGovV1c4dlB0UmlhNlBq?=
 =?utf-8?B?c1huOHg4WXByd3QwWjl2M0oyZEpOSDBiOTU5c1hSN29ETU4zRTVTaE0zZDg2?=
 =?utf-8?B?dDlpei9HQ253WkNjYllkMDVvVzJBckZUbWtFNmtULytIaWNjZFBDTW9OME1l?=
 =?utf-8?B?MzN6UktudkF3UWl6UUQwd3pjb28vNG8yRkYrZkVQbk5VeUt0by9weERHaHdv?=
 =?utf-8?B?MkJaeFVUSVhlYlpzeEdIK2V6TlpnV2taMXh6c3Y3OG1TSGZoMnF5MDRqSXF2?=
 =?utf-8?B?VTBvcUpUVFJxS0VkU0U5YlZmdmIzV2VmcXFremQ3bnd5M2diL29wNlptMW9M?=
 =?utf-8?B?WTNkU2JYbER3bUJnNGdWNWRWYi9wM1pDbVhJNDJkaDV5S3VyYUd6Q0R6dGNO?=
 =?utf-8?B?YnFJQ3FMRHVNTU8zZmZRWFpEN2s1R2MwUXNkQnF6TTFMNUcwYVRMcTJwMmFh?=
 =?utf-8?B?cy9NUWVkdlR4UUt6VW9TNXJQRzg0ZFlZby85eWd6OENySUJiR2Ixa2xMb0lN?=
 =?utf-8?B?d2J2cm1pODV2MHlEclNOWW9iWTRKb1R4WWh6R3hkN0xJbC9MSkZWU0kyaS9T?=
 =?utf-8?B?eFhQV2xZNUw2OVdZbURLNVozV3I0MlYycnJDU2s5blZJZ3paeGQyYkFYQVVM?=
 =?utf-8?B?eHp2d2FvYldtem5DYVYyOThMbVIvem1mV0JZWGRvS3hvdVB3eXlRVmFRTUhF?=
 =?utf-8?B?bHJGK0NheFhvZE11WjdHeHpFQXpaWW54eVFCVEdCWGRSOFRicmtSL1pzeGtF?=
 =?utf-8?B?YkszRFArWGFRMUpnY25scWNydEYxelRWKzBSNDV0Q0IyS3Ayb25GOXV3c3ow?=
 =?utf-8?B?WHNEYmdTSTNYLy9XeG5wNFdUbktUUE5jWlNJR0pOcHpuUFdlZ244MzhvbU5X?=
 =?utf-8?B?dHdtTVlVWmc5KzE0a05OS0RaRDBIM2lYdmRBSFpIY1FIV0FKcDQyQVdHVUJv?=
 =?utf-8?B?OVhUZE8yUU9taEZRbGVsQWtnSU55VlZtOEN4VWNvTVFjUStYR3kyN2JFS1Q4?=
 =?utf-8?B?cDlWelZCZXNCSHB6Sm9uLzViVGRHRDQyOGFCNERDOWFISXgwbDRGRDY2WmFn?=
 =?utf-8?B?VC9ndktlMVFhTlpvWStHS1JBQVBmSlJET0IxSDBvVFBMU3Z1c2gydS95ZXJ2?=
 =?utf-8?B?NXdoQ2FFKzhmMm1vUlpZSVM3eDhieUw2a3ZMWXJ5M3V3NStLMk5FR3VtL2I2?=
 =?utf-8?B?bkdVdUltZUM2dFhZZnVYYnRIRU5DMFlMV1dKNDZvVVJKRGVnekhRTXVhckxR?=
 =?utf-8?B?L3Npc1EyaVRCdGtSd0hncHgxR0hEMUNYQzIrS1lEQmJ3TlIzTWpZMjIvN2Rp?=
 =?utf-8?B?dzVWVjBrKzFCN2ovN1h6c0lzdW1hWmxFL0oyVG01aGYyNm8raTVndVB2TFJI?=
 =?utf-8?B?MGdwZ01Fb1hqMnpzUUZ0eC9zeTdOaUp6NDZGS01uMUhpaVdOaGtJRTVjbEl4?=
 =?utf-8?B?enRJWWdzeExBc2FKaHJyd3pCZEQ1L1dUblp1RXFUbDdVUVBHdEl0QUhDK0ha?=
 =?utf-8?B?am94S3ZkMFo5Rkk2RytzNlBBTkNlaGNkVmhDMXlXVjMvNTdYSjc4QWFrOXlt?=
 =?utf-8?B?TEdDYmhMOUFHalB0K1ViemdacExxRlhBNFZLSERRNkRGdWttWlB4NCtrM3dJ?=
 =?utf-8?B?RkdiK0lXTStHd3ZRV2tTQnBvQmNEcUpSZGhrYTlGZGoyNExEbUtXNzlIdjlW?=
 =?utf-8?B?cVZXV29aNzhCN01CdDZPWG9OeG1uWUY2WVMrVVg5S2xtRTljbUtmeWFLVk5N?=
 =?utf-8?B?U3JPVzVuYjh6QXNNN3FlQ0FETDdaYUNHbXRhVC93b1gwNXFYNm13RnJUNmkr?=
 =?utf-8?B?WDZFbXF3NGh4OFBxZFRMVVJsdlFLRTVCUkJ5WkVaNG9zMDAyZzl5ZFp0cEVh?=
 =?utf-8?B?TXhoMkpmdnhRNDJzY1NUN3QvU0xPbm1aOTRHT01oV0VWSWRrWW4vS1hWU3JR?=
 =?utf-8?B?OHl3T1FGV0wzdjhIVG5VTDVwcjMrczZha0JPTXpIakRZUmhjZnZyQ0tTMXFD?=
 =?utf-8?Q?crIAzQN+GT4z8XZIqEKJh2u4M0Qu7Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUJCckZsT0pmbmdCc05jaHZwbkNpSWpTeW1ZSThRTmp3eElVaFc2cm5EY3ZW?=
 =?utf-8?B?cWpkVUg3eDdLWUxWV3ZDTTBjWS9JeVdFUGtxblJkTGRYYVhDYmp4cXdNUmxs?=
 =?utf-8?B?aGNLUHArOFZudVFxb0NDcGpaUnV1Q2hsWTZZd1o4T0Fqc25xSGlwTUtsZ2Fm?=
 =?utf-8?B?YU1qK1N5eW13QW12NGZJMEpWNjRNV2ZocTVnSVN5WE4wb0N3M0hkTmMxbjRV?=
 =?utf-8?B?RXFIbkZCMUswWmlnRnMwRGdPbEgxVXc1U1o1OFYxRjcvblRGOCtyTmMzVjZ3?=
 =?utf-8?B?OFdwVUVHR0RtQk13WFhqQlNDRmd4cVdUVGtlTTRhUGtoNTZ0MzRZTS9LYml5?=
 =?utf-8?B?R25FYkJiTmtPbFJ3T04weXV2a3ZWODY2bDFocnZ3NE1lZzh5Sk00a0RjNjd2?=
 =?utf-8?B?cXZuSU92aHVFRWlXQ2dPUkpIdFpwRk9PVDArdEJ2L2JEcVFmN1V3QlBINE5z?=
 =?utf-8?B?OTY1bFlqeFhVdytUUnRSdTM0MXhZRDc4Ym9veGxoS3RrZ1htdk93OUJQVHA2?=
 =?utf-8?B?aEc1NERZVG5hWmdUZnNkQWJMUWlQR1Fla3d4czU4N3FkUjZjTVlYYWdUOXlq?=
 =?utf-8?B?N3JQMjd2TG1JLzB6ODE0MGdkS2xnRlZSS0pDTWV6YzlQZldMU29uK25TbFpR?=
 =?utf-8?B?NjJXWE4rUGNzd1ZFV0d0dFN6SjlYMmZDRmlZNjMrV3pwWnREWCtuajNzRGxq?=
 =?utf-8?B?Yjh4dHVMUkRSdGdsakpjUVFwZ3F5eUIvQUVvZnJodWkrUkwvYzJYZ25OaTYy?=
 =?utf-8?B?bUtMNWZXcGFhTWNucitFQUM4RWx0Q29rSjJjUklaWDE4T2RDOHR5WDhJK1Jp?=
 =?utf-8?B?bGxlS3lRakZRb04waXZDVGhteklEb1BEZG4zQXBwclM5ZUVLSnc3WHlJNmlp?=
 =?utf-8?B?UG81TlhjTlpRZFZFZHk5ZllRazU0NGlrL0Y2RUtiekJwSWtWNUxPUlNUa0hI?=
 =?utf-8?B?MmtOaXZUVWwwcmpRYVFhdStSY2JHcVlST2trdktWbFNsZjhLZ2Rtb0Q2ejhB?=
 =?utf-8?B?TEZZMi9aeks0SFdNZkUzSzd2OGpML1pYQlhNaTE2WmhVa0pkOXQyY1hvUmly?=
 =?utf-8?B?anpkK2lmNVZ2MHJlMlpVaEJzMjcrSUhyUkJlTFJKVmF2MG95Y0EwMnJ1dnB0?=
 =?utf-8?B?SWpKQlgxUDZ1Z1F2L3Y2YTVIUjFhcmVYYmdyQ3lEZ0lqMVlCZkJwaDhMZWxl?=
 =?utf-8?B?YnJTbGNTa1lnQ09vcTlDTDNVbTZBRFUwdUJ2VlR2MUVZV1pKeUJSdGJCUWZP?=
 =?utf-8?B?UXBMajVHbkthQVg0TFhzVUQwZmxwVk95QStndUdwKzQ0U3U2K3pYWmNaSksz?=
 =?utf-8?B?NHVVOXdRZzBOQkZhOVFUNUg4ZW5tNTJvRGNXLzI5RkRWZXNtK2JEQUF6VzB5?=
 =?utf-8?B?alRSZjJYeTQvTGdMYlBtU0ZMRmxpL3k3MUgyWjVXeWdRVjZIdUxKQUJCQmhM?=
 =?utf-8?B?b1NvdTFMdGZnNUxUaEVFLzZ1dk1KRm4zZ05OOWo3eFJ1WXY0ZHczRkdUOTVY?=
 =?utf-8?B?bWhVU0FHVDJJTW9vb1dod0YzT09hRzZTZ0RHVDhoeDJsckdkcm1SYjNGYmhX?=
 =?utf-8?B?TEwrT3I2b056VHhBV2JLbWQ2Z3FXSW9WSy9FSTB2TFU4Rmw0U3hLcEt1UGx0?=
 =?utf-8?B?TkF5VDlidTJCakFGcWZhNzlvTjE5WnlkRmhCaTZKcm5OMzNQVUZ1Z2h6K3hn?=
 =?utf-8?B?elhMZW8zUkVBU2JXdkJlSU9wL0wzYzJRQXUrbmFWVzY2cyt4ZmwyK2duWFhS?=
 =?utf-8?B?TkR2SjBzWVhQQ3kwcm5BTXF6K3RnQy9yeUhpaERBbCtnSlF6c1BsK1RWUzNw?=
 =?utf-8?B?U2RFQi8xbGgwU0dDZXVlRVlsWkd3eGRUL2dYejRzbzZvRy9KaE1EK01DTElW?=
 =?utf-8?B?QjVNZ1VJOXgzcmZCb3F5RnRjRkdGQkZXRllsWXF4Rk1jcjdGTG5Rcks5MDBi?=
 =?utf-8?B?YmF5TlFUOC9RTnlsRGsxeHJDNHdlNEZxNmJ3eVRzQ2R5dUI0aWYrU1JlMS9X?=
 =?utf-8?B?VExiYVN6OTdNN0FESFAxaWlpVkV4ZTdob3lMYWlkUDBlRmVQcmhxUHF2OFpU?=
 =?utf-8?B?ZkZWNFBacDRGeThNREhZWllhQUI1dVR1MWt1UmRYOVNlbk4yNWZMM0loQnNT?=
 =?utf-8?Q?4DFxjM3TD7Q13R2GbzOKH6CXB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <375DBCDC9FEBBE48BF530865F1176B98@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6103c4f1-cd9a-4cde-d1a0-08ddd8c12b9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 10:23:52.7910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tpom+tbwWqFyNOx4JeZE3X5GRsliQmkvnUJ+ctB64OHHvLaCY0ca/fXPvwWptoeQpZHaDRRRD65bV2C0VwN7pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6840
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA4LTExIGF0IDEyOjA2ICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IEFkZCBlcnJvciBjb2RlcyBmb3IgRU5DTFNbRVVQREFURVNWTl0sIHRoZW4gU0dYIENQVVNW
TiB1cGRhdGUgcHJvY2VzcyBjYW4NCj4ga25vdyB0aGUgZXhlY3V0aW9uIHN0YXRlIG9mIEVVUERB
VEVTVk4gYW5kIG5vdGlmeSB1c2Vyc3BhY2UuDQo+IA0KPiBFVVBEQVRFU1ZOIHdpbGwgYmUgY2Fs
bGVkIHdoZW4gbm8gYWN0aXZlIFNHWCB1c2VycyBpcyBndWFyYW50ZWVkLiBPbmx5IGFkZA0KPiB0
aGUgZXJyb3IgY29kZXMgdGhhdCBjYW4gbGVnYWxseSBoYXBwZW4uIEUuZy4sIGl0IGNvdWxkIGFs
c28gZmFpbCBkdWUgdG8NCj4gIlNHWCBub3QgcmVhZHkiIHdoZW4gdGhlcmUncyBTR1ggdXNlcnMg
YnV0IGl0IHdvdWxkbid0IGhhcHBlbiBpbiB0aGlzDQo+IGltcGxlbWVudGF0aW9uLg0KPiANCj4g
UmV2aWV3ZWQtYnk6IEphcmtrbyBTYWtraW5lbiA8amFya2tvQGtlcm5lbC5vcmc+DQo+IFNpZ25l
ZC1vZmYtYnk6IEVsZW5hIFJlc2hldG92YSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4NCj4g
DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=
