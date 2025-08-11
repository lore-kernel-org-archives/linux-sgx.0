Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B5E274FE0;
	Mon, 11 Aug 2025 10:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754909436; cv=fail; b=Bm2A7i5AbsivLos8eIWh4xE9PMHFNbnpOZNLk09B+T5ERu8+HQQk4Z2v0pAZHbCUTai4hpv4bJBqGwntW62FxQpPmu3nfLv1fzpLFUv0165UonCFwSVOvD5y7PrHbRCTsnBlpgxgSD/ZUohsierHsB9lbBotZhX/Pkl/1V9Bj7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754909436; c=relaxed/simple;
	bh=18DvEOj+SLWIPHwe8RnbhYsZ/QeAcj1i25tl6V63nZY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SLgyZ6m5wZEr0bf0+X+rY+66JB34SjQWk5JKg4A9Fl0SficiwFDc0/IVJkROUUgJufXBVFQIWi0EgWXR3AdSmQbbxUCvEdp8aPHBKYLUkw7GpVEmjZzlBQjz93r3wMzCRU3HQogKhAfXJaz3hLYQHH8fh13pK9Q/LPXRXNaTHUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E/52BFGF; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E/52BFGF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754909434; x=1786445434;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=18DvEOj+SLWIPHwe8RnbhYsZ/QeAcj1i25tl6V63nZY=;
  b=E/52BFGF+o0OQYF/2c0sjFaXtZ1S4LO7t8RqLPuErEWH4z+sNgg5Rs8m
   RxA6O0Lq44+VYsLcMYq3ZStjfErVOtp1mwMHr+EhK8wuRnSrgqxTeVdpK
   GBclTZk2IKCM0FS3QlvX43w33d9JF6WwHHtmLriInTa+/Z49spWYOZNzG
   f8SPE9JOVBFL/YxtqOK1orz6EP5zn3KkgCyWP4TEpFhPG3lp89ef6mHIW
   ZH/v89C2Q3TZ7itOfhZVkySQ3haTnESVYwDhzPsqhD4o1gfaNjHWadBwF
   hNYlr7t7bwOwDgepmn6YriCNNHaN5j9/LzEfhO+rJ5t9/s7pa4lib639Y
   g==;
X-CSE-ConnectionGUID: W2J/pqlZQbuk1acMxfhJlw==
X-CSE-MsgGUID: 3zW6gd+lSlyLtnwIyMSODA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="60961039"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="60961039"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 03:50:33 -0700
X-CSE-ConnectionGUID: MujQh4xgTv+rsqXCY989hg==
X-CSE-MsgGUID: fi5T6v96RZGAkpeSkVxr3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="166681733"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 03:50:33 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 03:50:32 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 03:50:32 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.89)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 03:50:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQv6LUpN4UO60TZEUfNm/KCqXhl0k7R0iwBlIN7MLJDMl/H6VoyW5kMWjQNK/kJtStwWXCMIqrHlN2Qwj5lbXUmirfdiCTfxLNZsI7N9a0wFsVOQhHemuPppxlKqidE95LPkW+HKI7TuZjXQVYjDMvxktj8NgKGcWIKkaepc+susOXO0knUMvjBTG4olhEQHojTb9ibLpWC6lrD+LN2M7sUDt5m48DFEbjGYYhFbW2g8W7o1Y1lC5LXRvHHn/u17BC0uNLLMpLOHQM694624P/iFiJlrGLLRvZS16m77UIM1BpWeGKVbDbpHmF7PUMw4o4puNoC5QMby2ewprm8t5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18DvEOj+SLWIPHwe8RnbhYsZ/QeAcj1i25tl6V63nZY=;
 b=Nc8Ceq9h+Bj0gMMFmpr2rZPsFhVsJ/hbyOmONt+u14Dk13TLWvO5bJKpp8QC3YxHW4D5YrlnbnKhIV8H4Ocg+umX/85PI9nDAuBlL3GKlLEG1RxfZGNBa9z+miDQGF09GgiD+rHjFy7ahLAN/WZIhj/lnpEzL8GBHyEVLbZiL35Ap8kwzEjE7czkQFrNFeGTiRmPlHXVh3CgZj1t4zv55d5xP3V3JQ+J0KCP1lYU2xvGHcKjcl/V8jwL9YrSATEy1eG/HN17OMq9OoXC41jIBzGdq7lCmlYtNPrDCjBciYeXDpdZfABlqr3WdqPUYkEcLnUqlc2t4jrMTSoGBqGBrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by DS7PR11MB6175.namprd11.prod.outlook.com (2603:10b6:8:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Mon, 11 Aug
 2025 10:50:29 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 10:50:29 +0000
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
Subject: Re: [PATCH v12 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v12 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcCp+LaqeuqQghWEO4k9X7rHVGNrRdRj4A
Date: Mon, 11 Aug 2025 10:50:29 +0000
Message-ID: <74fd32cecdd42cb45d88a96a1dbb6d74cb39594d.camel@intel.com>
References: <20250811090751.683841-1-elena.reshetova@intel.com>
	 <20250811090751.683841-6-elena.reshetova@intel.com>
In-Reply-To: <20250811090751.683841-6-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|DS7PR11MB6175:EE_
x-ms-office365-filtering-correlation-id: d01941f2-1ca7-45aa-64c8-08ddd8c4e341
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U0E3TmJlL1pLL0pKc1ByZ0wwcU14eXdnZUpPVm5DRFV4R2JsWFY3TllSNytp?=
 =?utf-8?B?OElzYTdxSlRlcng5cHF3SUVHRmo4TmpQWGJpUmpaZ3pHeTF0TnFYRWxzaWQv?=
 =?utf-8?B?R0dmWG16K2xNaGd4U2FFY2xYbzVRM2JJMWF4Q0dQTDkwa0F1OWh5T0NScmxP?=
 =?utf-8?B?ZkJlOFhRakNTcHhJN0wxc0xjdjZCT3c3RlBFcVpTdThJdzN1d1pFV1RMTThX?=
 =?utf-8?B?YjlJek52NEZMdzhwZDRIT0ZhNDdSeTRHV21BOXZXbk1CV0pkbUt5WFFqUkZy?=
 =?utf-8?B?dGNialg2SE1oRWZEcHpOdVRBN3Q5bXpVekJOZUFhT21vZHZVSTN1K2MvMm5M?=
 =?utf-8?B?VGJWSEtnTnZmMWMyUUxSYytMUWlCbzFCOW5Cb1NpQnRqekJYcUpZRzljK0pi?=
 =?utf-8?B?b25zc1BzcVJtSmtIT2c1dWtpRkRTNm5xTHF5M1hYeVBiaXBYQi9reGhlS20y?=
 =?utf-8?B?UjIrT1IrcDY0M1pYK1lwblc4WDk4ZDBTUWlYcUxoK0p4a1JiOHE3S09RMHk2?=
 =?utf-8?B?WkRUVTVHcFZuRTlJUFhEZ2JIQWJRNnU1Szc4ekNBcTh1di9BQmZJMWx0Qzl2?=
 =?utf-8?B?dFIvREtHVDNLQ292UFJ0bGRmM0Nmck54UlFoa2R1TUhqS0dDQ0orWTBHMnRi?=
 =?utf-8?B?T3M3Rlo4UkJ4bE4rUjQ4U0VENk8wa2cwS00rNFZPZnA5dmI2bytDV3NRbkJz?=
 =?utf-8?B?WFhxckNjL3h1Tk45bFRxbU91TTEzU0pHSktqaUhlQVhpM1NGaC9FbmplMHpx?=
 =?utf-8?B?SEFhZCtVeDdOU0M3b1hQQmNoV2ovaE1pb1pLUGlaU3ZiRDBCYzB4RTdWYmVU?=
 =?utf-8?B?bEdVRDVOaG5SNUhaQkRERDVsanFrcTBoZlBMekFaL0ZJaEZiNklEZDdTemM1?=
 =?utf-8?B?aXlpcmxiMEp0VktyS09xTGgwcEhiK3hRQWtPYnlKN3YrQVk0SjlLTmhrc0Ez?=
 =?utf-8?B?MlFxaGI3NnRkZ05DRVlMZ2F3NlRhMWp3VTc5TlQxVFRtNkhGSjZFbDh3U0Ns?=
 =?utf-8?B?VjI2blhuSWdyQnJlekdsdm9NazloeFU4MFJFalBhLzk1U2hDWS9DTytQUUNO?=
 =?utf-8?B?QTdQQnpSQ3c4V1lpQVV4aFhWbDJKbjRxMWZzZGUzekk0MWdMaW9VVEZTRVRy?=
 =?utf-8?B?VGZYQU9sRjAwbnUwdTdPdEdhaFBqNVZ0VCsvaHV6dkpXaVlrMTVQTUdXZ1B4?=
 =?utf-8?B?M21PUUJXeFpRZzMxaUdoYUNHQjZ0bG9lS3pDSGUrRVhNN2JtcEpyQnF4a1lB?=
 =?utf-8?B?SnR3ZmhIemQvWVI3Sml4bnZlZGF1MWFQTjBWQXVIYXRwdlMrSEtreWtZNzVK?=
 =?utf-8?B?dmZPNWNyb1F2a1RrNDNMTDdWRVFucC9uOGlJUThFQVdZV1VXcENVTExZNmVY?=
 =?utf-8?B?R3VZUEJNWW4weml2TXhmMnV2alZ5WHo2TU5vNTNxM2hBbm1mcUk1b3J1SW1a?=
 =?utf-8?B?b0Nnbis0bThad2pOSU56OWd2MENtTlhPRTdOSDhtVlB1ekk3TFE1dWFNdFhO?=
 =?utf-8?B?ODh0OFE1Rnp1R1RTVFl0WnFJK3BpRFo1aHRnNjdlQjJpVE5xcHNGNzFRWHVu?=
 =?utf-8?B?dXBCZS93WkwzWkZTUm5qQndrWWtiT3hNN1dDRnlYL1k2aUQ3WHlaYXR5NTlO?=
 =?utf-8?B?N1NlL2g5cGx1RUNEblpET204eHVHUVBmWkxxTHlXRGtpckhEODY2clVDeUhn?=
 =?utf-8?B?T2IxVGt1WlhLaTVwZ1BEbUNEV1ArRXNhTm1OMHQ1SnZUd2lUbDVTcytHTUpJ?=
 =?utf-8?B?M1ZmMUZlVXMrMmtIUnBxVk9OY1FIVGYrSzNzUndLMFJIdVI1TjlxOVM3RlNL?=
 =?utf-8?B?RmFZWUNGVDdhbzFPOVdScCs4NzJuekRMMjNkblFjbWJOTkRzTzd2YmhJNE4r?=
 =?utf-8?B?RENwU04zd0lhUG1tWm1XdHMrY3ArV1V0ZmViNkRvbWFaN0czYlE5R25naXVZ?=
 =?utf-8?B?MjI3WGFkZEFuczN0ajY0ellDUjJRTlRPc1FsRXFvODJ6b1RDdjdnTXV3WXhn?=
 =?utf-8?Q?df249C5IVBNP6OlEWnV7t4wfIEG7ww=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDNmN2t3bTRDLzRzZWZES3BYWEx6OGtIN3M4WWdnbUFHSDl5dnQ5ZFdkbXZX?=
 =?utf-8?B?V3RaMmo0cDBMRzhaYW9vUUdGT1Zyc1VkUFNxbHpCNCtZZm9HUTk0OGpRamk0?=
 =?utf-8?B?QVRBSGZ6QVE3OTdwYjhxc3F4eG4rYVNVMWJidlZyY3o0Ui9iTFlVT3VvdWxj?=
 =?utf-8?B?M0o0ajNCOEt1NkNtRGpSaDFWTzZjVWY5WlRzYnZBeWlIeGorNis1RkJ4cHl0?=
 =?utf-8?B?NktCNE5jMFY4bEpFY2tNMnVHcTFsWGJTdmJrUmdxbktmSUdydkQrdkcrZXJl?=
 =?utf-8?B?ZHNhWFBoSmpHeHcwcUIwNndWUnBYS2Q2YU1hSHF0TVN0dUhZUElvcS9rTW9J?=
 =?utf-8?B?U2NBVys4NjMySDRaSEpVeUVsOWVJOUM1dzRZSWlaV2t6STIxWis3RUw4b1Bl?=
 =?utf-8?B?QzNhc3lmQzFnUk9IZVdiN0JETHQ5UzYrczc1dnBnNjNtUHp5M2FUaFpKZ3pz?=
 =?utf-8?B?MHgvNmxtbHpJb1pLblBabUp2dFpqZTVKZVdWTU9GMGUwNTFmRkYyTTlvQjhr?=
 =?utf-8?B?WnJ5RGFObG5GWXZHK2ZrbHpkanJvMmtneGRMMkk3V1o2NEdHV0hxRVdnYTVG?=
 =?utf-8?B?dzZYamt3OCthYXBrTi9tTmx1QWI1K2ZJQmRiQy9NMDlKUkhBZWI5SG5wYjFT?=
 =?utf-8?B?Q3Z1cGErYXM0S3hQZUphQ2RZU2NFZXcxb1ZkdHhnKzAzNVdMZzh6TWkvQ3VF?=
 =?utf-8?B?cTlDUEZnS29HdzlnYkxVVGtxa1BTVmZVcVRVRi9Kb3ZtYjJReGsvWVREVzZ3?=
 =?utf-8?B?ZERnc2ljbkhNT296UjN0WDJIVk9qakZlTXhUbzAvMlJVK3pNTE9QWDRGcDVk?=
 =?utf-8?B?b01ZYnBjcVRQdnhIc3JHSkRBRlgrMHB4bjNvUDUyaCtzT2NaOTVaUEx3aXQ4?=
 =?utf-8?B?UFNQWEdDT2JrOW5Za1FGd0w4a2ZYaDI1VGhPaTBVaWpkd1RpZzFVY2RFTFdC?=
 =?utf-8?B?ZlQyTC9pTGtTMytTc0o5ZnphMy9Lb2gySWtjMUliM1dTOU9pc2N4RnVQTWF3?=
 =?utf-8?B?YlhFUVZHUDJlSDJwdndyaDNEaEpNK1lVNDV6VHd6ejhQUlNUN3FqTkxtbUxR?=
 =?utf-8?B?RG8zeHFjbUVreXRoYS9vcDV6bG5vZnRjUFY4dVQvaCtIYkNPM296M1R6YkNG?=
 =?utf-8?B?NWRaMHRucmQ1QU5POWk2aGozbzVwT1RObmdoM0Z0ZTFZd0V6U1ZRclhWNWlw?=
 =?utf-8?B?dEZ1VjNvTERaajRzR1U3UGxRWm1RNWFJZzE1TlV4eEZLUWtSUTNGdVZNalU5?=
 =?utf-8?B?SU1UNVM2VnhZb01GRU84Q2JySm1IRS94blpxNWxOUWFpdWQyaFE4NmJIY1B0?=
 =?utf-8?B?c2ZHcWpTWnQzV3JNUi9SeFkwb0c1T01icVM4QWdXOXJjVG9tb0RlMjBQQk5G?=
 =?utf-8?B?U2lkUmh0M3pMamNaQkxrVFNyL3lFREEyRHZHQlZ3cUFqNTMrWVZTZ2w3S1pD?=
 =?utf-8?B?NjY0UEx5K1pjSUcvWE5lUHlaek1UZlNyOUFPNTZ0VFQ1L3RSdUk0ZlZsRnMr?=
 =?utf-8?B?VEkvUUxZT3JBM0JSQWROWk1RTW9rV1lBL1kxcXpyY09FajFVVmVYcVhUQXVm?=
 =?utf-8?B?U2NCeFA1OFJkR1FvODVQelo4aUtXd21HM2s5aVVRWFdyRTlEbjJLYlRJN014?=
 =?utf-8?B?dGR1alVKSGlZTnRhMXo4Y2xmK1ExS1lkR0l5UlAxUHBWRG1BM1J5ZU5JZFAy?=
 =?utf-8?B?M01VKzc1YmxUQk5lUmdRMDh5dDY4UkJucEt1dm1wWG1jMHhVaFdYVEZWZS9w?=
 =?utf-8?B?QWtNUmFjMFB0T1c0VFBDTkhZRTJUM0FVc2xYS25nK2pOZXA0NjZ2WTdBSSti?=
 =?utf-8?B?OTBzMU5pVmo2WGx1WXZ6dmlNR2NlVWFvZWw5b1crTTByUGVUejVWN1ZjTlkx?=
 =?utf-8?B?OHZQKzdsYkpPbHkyYTZmd0I2WmpUZ3UxaDMxalljb0VmMUE5SEpvR3QyUWRW?=
 =?utf-8?B?aklCN1NDQktpY3NtZ04yRkFUWjBaMDRnZGVHQjcrRWxMZVAwODNzc2lNRUhq?=
 =?utf-8?B?dnF3b1BHeWo2WHIvOVY1TFRsZjNkOXcrdWM1dlZwWkZtcmdQU2g0a3QySVk3?=
 =?utf-8?B?T3lBV1VBWkpDdnJheDhSTkgvb2RTZHp2cWl0T3MzQW1DRUVOZkJ0RUJHd2dV?=
 =?utf-8?Q?5mkeLW2x0R4oZUE/7Fc0nGHhZ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <809571EFF13E8F4DB1B88844E766EC81@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d01941f2-1ca7-45aa-64c8-08ddd8c4e341
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 10:50:29.3789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /XWV3rt2Zr5XIU481Sl8tumed78QcjOCkMfZ+oUPmEwEsAfAS014gt0gxtxbacYAdxRjZecheZlT5flDuqM/Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6175
X-OriginatorOrg: intel.com

DQo+ICANCj4gKy8qIE11dGV4IHRvIGVuc3VyZSBubyBjb25jdXJyZW50IEVQQyBhY2Nlc3NlcyBk
dXJpbmcgRVVQREFURVNWTiAqLw0KPiArc3RhdGljIERFRklORV9NVVRFWChzZ3hfc3ZuX2xvY2sp
Ow0KPiArDQo+ICBpbnQgc2d4X2luY191c2FnZV9jb3VudCh2b2lkKQ0KPiAgew0KPiArCWd1YXJk
KG11dGV4KSgmc2d4X3N2bl9sb2NrKTsNCj4gKw0KPiArCWlmIChzZ3hfdXNhZ2VfY291bnQrKyA9
PSAwKQ0KPiArCQlyZXR1cm4gc2d4X3VwZGF0ZV9zdm4oKTsNCj4gKw0KDQpIbW0uLiBzb3JyeSBm
b3Igbm90IG5vdGljaW5nIHRoaXMgYmVmb3JlLi4gQnV0IEkgdGhpbmsgd2UgbWlnaHQgaGF2ZSBh
DQpwcm9ibGVtIGhlcmUgc2luY2UgdGhlIHNneF91c2FnZV9jb3VudCBpcyBpbmNyZWFzZWQgcmVn
YXJkbGVzcyBvZiB0aGUNCnJlc3VsdCBvZiBzZ3hfdXBkYXRlX3N2bigpLg0KDQpJZiBzZ3hfdXBk
YXRlX3N2bigpIGZhaWxzLCBpdCBtYWtlcyBzZ3hfaW5jX3VzYWdlX2NvdW50KCkgcmV0dXJuIGVy
cm9yDQp0b28sIHNvIHNneF97dmVwY199b3BlbigpIHdpbGwgZmFpbCBhbmQgcmV0dXJuIGltbWVk
aWF0ZWx5IHcvbyBjYWxsaW5nIA0Kc2d4X2RlY191c2FnZV9jb3VudCgpLg0KDQpCdXQgdGhlIHNn
eF91c2FnZV9jb3VudCBoYXMgYmVlbiBpbmNyZWFzZWQuDQoNCkFGQUlDVCB3aGVuIHNneF97dmVw
Y199X29wZW4oKSBmYWlscywgdGhlIHNneF97dmVwY199cmVsZWFzZSgpIGlzIG5vdA0KY2FsbGVk
LCBzbyBzZ3hfZGVjX3VzYWdlX2NvdW50KCkgaXMgbmV2ZXIgY2FsbGVkIGFuZCBzZ3hfdXNhZ2Vf
Y291bnQNCnJlbWFpbnMgaW5jcmVhc2VkLg0KDQpTbyB3aGVuIHNneF97dmVwY199b3BlbigpIGNh
bGxzIHNneF9pbmNfdXNhZ2VfY291bnQoKSBhZ2FpbiwgaXQgd2lsbCBza2lwDQpjYWxsaW5nIHNn
eF91cGRhdGVfc3ZuKCksIGFuZCBhbGxvdyBlbmNsYXZlL3ZFUEMgdG8gYmUgY3JlYXRlZA0Kc3Vj
Y2Vzc2Z1bGx5LCB3aGljaCBqdXN0IGRlZmVhdHMgdGhlIHB1cnBvc2UuDQoNClNvIGlmIEkgYW0g
bm90IG1pc3NpbmcgYW55dGhpbmcsIEkgdGhpbmsgd2Ugc2hvdWxkIG9ubHkgaW5jcmVhc2UgdGhl
IGNvdW50DQp3aGVuIHNneF91cGRhdGVfc3ZuKCkgcmV0dXJucyBzdWNjZXNzPw0KDQo+ICAJcmV0
dXJuIDA7DQo+ICB9DQo+ICANCj4gIHZvaWQgc2d4X2RlY191c2FnZV9jb3VudCh2b2lkKQ0KPiAg
ew0KPiAtCXJldHVybjsNCj4gKwlzZ3hfdXNhZ2VfY291bnQtLTsNCj4gIH0NCj4gIA0KPiAgc3Rh
dGljIGludCBfX2luaXQgc2d4X2luaXQodm9pZCkNCg==
