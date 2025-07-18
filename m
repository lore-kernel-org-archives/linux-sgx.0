Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29D53214;
	Fri, 18 Jul 2025 04:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752814236; cv=fail; b=Tmt+HmJlwg/K7TkSeUwYfsUDzXowG2y5+p34hpKwx8Wvpb+IPkVXE6YygUNEPqbPtJI8/phNsUGYtFkDtVBrB/Sf9TN3dj2TV5Z5k0zEhsQWyF09QTm2x0lLtWKl3ABxpI5HBMnbe+LYKYvJkUPCX7e2Nr+nduQlZyvuIu+EQG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752814236; c=relaxed/simple;
	bh=vATF7o46zw0xy173VWrmffiH8oHNNx0N+5eYeh440so=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RihBkFgs3YhjwdhtxAl6d4eYQ50FNLAJG6Z050tbnyQHw44P9QzX07SZ0GtrV1RVvGIINiC29LISfPECSZVmoHYAwfHOKT+l6syrAiIwC/2XiEwPDQmkIc+4kLxILYWWInu91JP6F15qqgf3ZH+wXHZquUfyibEXlDSWrMEJTYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rq+JLa9k; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rq+JLa9k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752814235; x=1784350235;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vATF7o46zw0xy173VWrmffiH8oHNNx0N+5eYeh440so=;
  b=Rq+JLa9kzDZL9Hcwv4Z15+O+ua/LjIjbqllpOYvkhghy7v8sl92iEb02
   Uac5on8t5FGNyFVKx/tGoYbvTACPa2ndnfHIbVVHZ2EYTWnWT4ijdJ3Lu
   attVl3gISe9N1MZOlvm6hsFFshRvMt2bbclROPULRxqDy1PLPpIVIfcye
   lCkHadypmGXQFy+qhxPV9I66j8H4/2JxgQ87jFE/HatNEViRLk1tGqThP
   ADvntL1SlQwKGAAIpBSVhc/dUyQl8PHCOjz848/3E+eO/Jwxv+kpNpRF7
   Vr2nrnsrdhjA5zuBeMyDCD0g+D4710sVznJlwhlg6xggTYXjoCE8JxDbC
   w==;
X-CSE-ConnectionGUID: 2Uabj/JSToCVpB8hkbx3jQ==
X-CSE-MsgGUID: OmE7GGvMS/OmvvX6Y9ej9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="66551338"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="66551338"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 21:50:34 -0700
X-CSE-ConnectionGUID: HX5aAQUAR3ijlmKmiXbCrQ==
X-CSE-MsgGUID: 4jNQJZRlSOGtaHjt3yr0pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="162243135"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 21:50:35 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 21:50:33 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 17 Jul 2025 21:50:33 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.58) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 17 Jul 2025 21:50:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tl8+a60By9z/yZ+6RmXES8MZDiMwyScsQo1TF6S1dU1IITxEJlUnhDdV7mAaC33dr3PuE6Ktk4+RRrmiuiuJO2o5VPpM1xizk/dIQs+BCn6mUcwKC2F1aSvemRnQJ0K1gP1deBw+YqL17yw0fp7j3liXwGd872ISI+5HyCuejHDu4PI+W8ibkx3JruPqO/nVt2fXhdcBrh75gMz4h8YqOdX9yu/KDMb+bGxkv8+hwBLUeriUHqtIHujaq739JbU3D9KZZEVONXVk5xKTW4SZhYeTaJG5DbI6YairGhs9tjqqyt5kc8ndcFPuKQRmIzBRpg00PySn589kyDu0AQ/Xnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vATF7o46zw0xy173VWrmffiH8oHNNx0N+5eYeh440so=;
 b=WZkBOOXcKb5BWmeO8OSsmmtmwVI6DxSZkpcwDf8W6acgTf+e2gONgLzFrkYPIIh2WYZvVnTBf5+e2C3aEZI8AK8inetUXYtb+CPN3pVd3ANysVyE3I6YSka0D6RjXLXNgwMBlR48Sk7HHv921njhF6T2fxv4l7txsXyEEp2bNkRWH/3Kn+ChhNTe6RTBC0CqaJNSYLpqyf9/gJMy2snWup4lmSdSUHyc4VllUTcY4Fkhfm8zPTWU71wc7VSb2V85pXxHkh0K3V488FNHK0aCXl8xRlPTxEAG1kn/iI6aO54/BOAfNgq2nXM0IPZ2lslaNvfIkamtmqT1vliMPSd2uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW4PR11MB6861.namprd11.prod.outlook.com (2603:10b6:303:213::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Fri, 18 Jul
 2025 04:50:29 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8922.037; Fri, 18 Jul 2025
 04:50:29 +0000
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
Subject: Re: [PATCH v8 0/5] Enable automatic SVN updates for SGX enclaves
Thread-Topic: [PATCH v8 0/5] Enable automatic SVN updates for SGX enclaves
Thread-Index: AQHb9YXMsc49bXAwiU2d4YSgiPCJTrQ3U+gA
Date: Fri, 18 Jul 2025 04:50:28 +0000
Message-ID: <0dcb59cb4ccc186209ae90ea49611a37c6008fc3.camel@intel.com>
References: <20250715124109.1711717-1-elena.reshetova@intel.com>
In-Reply-To: <20250715124109.1711717-1-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW4PR11MB6861:EE_
x-ms-office365-filtering-correlation-id: a7a85aaa-cbc6-4323-ef86-08ddc5b69e80
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?emRweWFONEsyc0JuWGYwOC9WOXR1NGw4YzRpdzl2RGxTVkZiMDc2TXhvWHZq?=
 =?utf-8?B?dU0xdy9kaW1YeWdkalBOeVFmOTBqbU80cE5KV2xDYmRtWkRJV2Z1OUJ2RDdh?=
 =?utf-8?B?MURsNWVrVExTaXFvSUwzeVlnRkZMTDdEL3BzY0Y2bE1TKzRqVWZ1bTAzd2VE?=
 =?utf-8?B?YWJZaS9BT2N2aS9KZ1NYWDBzTHhZeWZsdVBzSmZVd0VkZnVLOUllL2M1TkRK?=
 =?utf-8?B?ekQ2ck04Mk5KY3ZtcE1PTWRmREVxeEhneWthbEY2am5WODJBUCtvOHF1QjB4?=
 =?utf-8?B?OEJXZHY0YllXSFJXZzhxaUk0czFCVjRiYXZONFZpMjZ5K0taL3ZjYjNMQ3p2?=
 =?utf-8?B?ZS95dERGUURhTytaN0UySjExSlNIdWhTMmZqRGhxekhiVGU5QnhTRG9pemFW?=
 =?utf-8?B?aWJjWFFlK05HSzJrSENwTURMekZ1ckczdmRvVjdOYTNMdW5WNXlvbVduK0RL?=
 =?utf-8?B?T0hKejA1czZiMUs0SkpRK092N1ZoZGdRL0RPVVNhcHFVZ2RzR3owZlBBWjlY?=
 =?utf-8?B?Zll0VmZTU0NaTGFpejVNSGZXR3UvNWk4NW1yRE5FSTQrMTZlbmEvOUVLMExk?=
 =?utf-8?B?dXhJdTk3YTdlRXJQSnBTcCs5VUV4UG9uOEpWdmIzRGdJVWtoN3psYUI4M05j?=
 =?utf-8?B?VUJpa3RJdXhZMDRPV0dlTWJaSDB2SFpJUXBpRlIrOXEvZmIxR2xLTXE0dEth?=
 =?utf-8?B?Y3FKVFF3QmxGdGtXK3lsR1NBZWpMcVB0S2duTWlodWR2TUxkcElDUkZxWUw1?=
 =?utf-8?B?aVY2UHBiMEt6Y3NJZ2pFMUtXKzQ5dzlqcWI4MDBYMlFrTzJrcnlDK1NaWk1j?=
 =?utf-8?B?eFJtTjFSaXUxbENSTVVVQ2s0V294VFFhTGo1ZFN2ajd1ZFYxYUhUdEErTG9U?=
 =?utf-8?B?cHJPTUk4UlE0Tm9DODJXMUsrd1pzbWFCRnQ2ZHg0STVLVEdISVZzcnR3aEky?=
 =?utf-8?B?WHkvdXlHVmQ4MCtwSExJZWxUaWxWV1BKeFJ2bkgwNVhuUXQ4MHp5NFQ1dENy?=
 =?utf-8?B?QUExTVloMXh2dUVYTkRVbkNDdDdxZmZoQnpscXBwNE4reU1pQU9yYStqbEFN?=
 =?utf-8?B?eEJvZi92QW1ibEROcFU1bFZOVkZWOFY5N1Ywcjd3clVLMEg1empEWlNiaXBP?=
 =?utf-8?B?emdOcDNhdkRkOWtGOFBCdmV0NmNlYnhJeHlJeVdCdzBiaFNGYnphQXJPSWh2?=
 =?utf-8?B?L0Nyb0FpZ21xK2dmd05KVTVLTjNib2d5c2JaQjdvY1cxRkZGRFpDRVc5S3lX?=
 =?utf-8?B?MmV4dzlucGliL2sxVktNWTFseHlTZEhEWWE4YVlteXdRTk1KNXB6d1pOVDlU?=
 =?utf-8?B?N2ExaXdYcE5ZRzVCYjJGQXVrSWVEeUdqRWZiNzBFdHphS0FNNGpCalFJamVz?=
 =?utf-8?B?N09FOFJtNTFaMkJuVkNXbVowTkkvVDFnb0pUUjZ2VllHWXZnNERNdHpycmZV?=
 =?utf-8?B?ZmNyWDNyQVFXaHNlVldldzhrQjhjdHRkOVZGNlN0R2RjTU9FQWhScGtqZlI2?=
 =?utf-8?B?ZmxuSVJpVVJ3WURjTWtnaVRzRURFZXRLQTB1MXBaZ29RcEdsVy9hUHVCYkNh?=
 =?utf-8?B?MjZnL2cwbXd1ZTRBcE40YXNKZXlNODkzRGozUWVFTm1ucGR6Q0JFOU5ERkNp?=
 =?utf-8?B?KzhCNXZOc2JlSGllWXdjS0NvUzUxdEF0M0x3U2w0RlZYS1d1UWhwQVB2NGtv?=
 =?utf-8?B?YmlwUGZWZWhZZmhJNXpocENSazdmdnBZV1h2REVXUWdvSVRINTlZQW5CTVNr?=
 =?utf-8?B?NkFYVlU4dU9tY3NYckxaTm9ualVDb05sOElBNWV3WFl2UnA2dXlLemxRZXlR?=
 =?utf-8?B?clYzNWFQZDNIMjErNHpEaGRrMTZiVlE5VDVGZ0VOWXBWM3k5MjA0V0J0WU80?=
 =?utf-8?B?YW5VYkovV1BvVHZnS1hUSnpCcm9tUDM4M3h4NnRwM01xbGQ4MnB5UXh5QTgy?=
 =?utf-8?B?QUM3VGRoR2VyZWM5NGsxMUMwL3hQTW0xY3YwVVBCcDk3M0VlL0kxKzEvV1Mr?=
 =?utf-8?Q?tyo2S+D2IvYFOGMk+7P0D+o8OSeAvU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkNGMk9rb0JNVkY0Q1N6b1p2ZVhyeHhTR3oyYjdHcmlaT0owSTlORGF0OWpK?=
 =?utf-8?B?bllrUEpNeWQvbDRHVDlVL0JnNDlrUSttREk0aTk3di9hbTF5bWJPWVozeE9a?=
 =?utf-8?B?K2FqZXd2K3ZMTysvSmtsR1d6VDFMNjBycGdxSVNpN1RTb3dleXVWYTUycTJY?=
 =?utf-8?B?M211OEpBQXJrRGx6V25YY3FodGdBR1lVSkdrYkNrUFpTQXkweFp2cGJBWWNE?=
 =?utf-8?B?Wjk4NTdFdExhU081WkJyRFdheU1ycGZGbnhUMFJSSmZoOXlENFlZOU9xbzF5?=
 =?utf-8?B?dHpUbXZPQ1Q2U2VHN2doYktGdGRaeFJpVVQ3bnZpMENaejBWUWlnOUw1SnQ2?=
 =?utf-8?B?amN6OThBbTZYd3Z5Ty9GSUVpTGdhS0llVWgvMDU4bDZpdDdEaFZlRzBkZHRv?=
 =?utf-8?B?eXBVcW85R084M3VzaFBudkdyU2N1Z3RQT0ZUNlhCc3pJamZaelZhaHZIT3RR?=
 =?utf-8?B?ai9NcExHeUpZV0M3NWZZTEM1NjJ5elJtaGpybldRcFVod1pZcy9RdXVrSEFO?=
 =?utf-8?B?cjdOV2ljeDlkKzJrRkpVWXZ1SmdHWmJyZGpkS0V3aDNiSHd1S0VvRkhGTW9i?=
 =?utf-8?B?U1l1ZHp5b3l6eHY0dHBRS2o3SHhMS1FwRENKSkwrNnV0R3JPZmZOZDdhQzZR?=
 =?utf-8?B?cHZZOUp6VDQ1MC95TVFqWVhIMkd1RmJlNndaNzVvWWpTU3MwcEFwdHg5a2xZ?=
 =?utf-8?B?MUE5aHpZM2l4cUxNTzVUR1FyUStKd2V2QTVjZ1ZCTzhiTEFsY3dJTU9qaC9n?=
 =?utf-8?B?Zmw0bTRsTDZKMzdYQkRuc2xmdzhndElrMHBYeHdsRWF0YkxBdVY3YUR4SlRo?=
 =?utf-8?B?TDduQVA5aktsdFdjeVIzSTZWcktQL3J1NUIyWjhlNmxQcE5ad1UvZ2xaZ2JD?=
 =?utf-8?B?Z1Q1TUNyc1VxZmVqcEVkcGEvSXBuL0ljMlVVYXBWSUhVRVVQdHpNQnZBTVk5?=
 =?utf-8?B?aDJramFYcGs0ZEcwazdEeWdKbEE5ZGV1aG9CbjdIbytGNzJVYTd3ek1DNTVx?=
 =?utf-8?B?My9RK05GZC9yS1JELytXWmVWYmp2d0E2RmlPRkJBV2t3aS9ZR0x0QnRrYktK?=
 =?utf-8?B?Szdub3NYVzRRaG5ZSzJ6K0l2d2NhZW1RSXgxS05EajVPblNpeGs1Z1lpU3dI?=
 =?utf-8?B?Ly9wTVUxTE1qSk5XVnprOG9VUE1ocmFWQXJ1bnpLOE41Z0ZIY3RibFVRbWxh?=
 =?utf-8?B?b3lpS2RSci9CN1BhN3NqM3I1K0dCTWVTUTNuMXU1aUZNTnhjZU5vTWRtRGZj?=
 =?utf-8?B?K2hLWW9EcTArWGJ5OFlqdW9qS0xZSHZ3L1pkeXA3WTB1SW40T2F3eWlrN1pn?=
 =?utf-8?B?Q2JzRTkxNXF2ZVR2Z2dRRVRML29FV0syVEdpc0paZWhqODJKb25mRHpVd1Y1?=
 =?utf-8?B?aGpiVjN2MEtjUitWWHpUdlRLYlNYaDc5b3hEWUdBeWVjV3MrODR0dnMyQzFY?=
 =?utf-8?B?dzByM2NSUUxiOEdXVk90UnRwVHFGamYyWmlza3NjejZPTDJTL0xJaWh2V2FJ?=
 =?utf-8?B?eHd4NElqcHRPeVBOL3U4OW1vcDJPd1p6TkhHRi9nY2FCYm9JQTJkN25iSW5x?=
 =?utf-8?B?aUF0Sy85SlJhdmJ1WENjbHVJM21jSFBFSUVDS1kwTEt6SW95aUNsZTY5U0Q0?=
 =?utf-8?B?bmF0b0FIWHZGYStMNkpvQXYycFgwY08zaW51NHVOdFJrZ2Zna2QyeUc1cmtN?=
 =?utf-8?B?K1JUK0VYb1ZXWTc0eEdBRFFveWJ6MnZ2VEJmY0tCNHI1L1ZMeVpsd1Z0d0NG?=
 =?utf-8?B?VmVoMjR4VkpFejZFV2pEMS9pSWZYeWtYaU1DdjA2YlQrVGthekd0WFY0STVi?=
 =?utf-8?B?N3F2K0pZY2paUXo1ZUF3UXlzM21TMkRHaEdOSzluV2trNDNDMFo4T1NIRlA3?=
 =?utf-8?B?Q29VUiswQlcxZEdkTW9xVndYQkpqVjNkM1IxbkJ1TXIzWFNlWGNhMDZtSExi?=
 =?utf-8?B?RXMxL0xNRE8zdU9IcXczOGVXN1JlbUIvTlhQOGgwVnh6YVpGbWQyRm81aElP?=
 =?utf-8?B?R29ja1lmeEt6VkxGdHVNRVAzbUNFQXUxOG92U0YxYUREUnAzZ3ZDN0NLV2Uy?=
 =?utf-8?B?UUdmaXVkaytOYUNkVk5MY0tOczVEY1RUUEhjTjFqRStCcUl6RWZ3amNlYkJx?=
 =?utf-8?Q?3PtcPygaWR/c6s8JJUZ7ehIGr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5099D4B20BE5154CA69072D250B17323@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a85aaa-cbc6-4323-ef86-08ddc5b69e80
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2025 04:50:29.0037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BplZhgyib98KsspjYWfpQ3hEckMMVcVDEDGlr8ZEzTho1HzHoc6YTOAa2mHkaAa2J/8GQbirCa+t267adNDDsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6861
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTE1IGF0IDE1OjQwICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IENoYW5nZXMgc2luY2UgdjcgZm9sbG93aW5nIHJldmlld3MgYnkgRGF2ZToNCj4gDQo+ICAt
IGNoYW5nZSBzZ3hfdXNhZ2VfY291bnQgdG8gYmUgYSBub3JtYWwgaW50IHR5cGUNCj4gIGFuZCBn
cmVhdGx5IHNpbXBsaWZ5IHRoZSBzZ3hfaW5jX3VzYWdlX2NvdW50IGZ1bmMuDQo+ICBUaGlzIHJl
c3VsdHMgaW4gcmVxdWlyaW5nIGEgbXV0ZXggZm9yIGVhY2ggc2d4Xyh2ZXBjXylvcGVuDQo+ICBi
dXQgZ2l2ZW4gdGhhdCB0aGUgbXV0ZXggaXMgaGVsZCBhIHNob3J0IGFtb3VudCBvZg0KPiAgdGlt
ZSBpdCBzaG91bGQgYmUgb2sgcGVyZi13aXNlLg0KPiANCj4gDQoNCkZvciB0aGlzIHNlcmllczoN
Cg0KQWNrZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg==
