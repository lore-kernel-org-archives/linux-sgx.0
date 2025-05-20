Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AD613C3CD;
	Tue, 20 May 2025 06:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747722356; cv=fail; b=ZCrGB4wUiOizpgoXtBJHzlOOpOcW/TEx/aaFPEffx0fTIXbxJk9egho+wFVBBseG8IF4MHAdi0Cp/a76wzinUrNorWtfyCJdHQZbe/0HkrbtpOMu6dIlqkRlbZLdOyrM2ngpoHkvki8H5mBf9PNmmAssbCf7YsRJJOxSER18028=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747722356; c=relaxed/simple;
	bh=QxevAd5hKS9oIpAhGffnMWuV4euOMaO6xiCjN/YW9y4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gt5YPlfPQIYkWeupGfOqK2sooDugtKG6atd7LeQs0FqgBPx60TvTSGdg6BKfRrZ/IZiAGUWs9SrLjiqAfBuep0WncibsGGcfAW0XO2191JBwYf5+GDY9pz32f1Z5MFoCpjTyGBQ87UBDOI9P8gY8p6L7JStM+VGrmPt+ngC5Wwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mf61YVZr; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mf61YVZr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747722355; x=1779258355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QxevAd5hKS9oIpAhGffnMWuV4euOMaO6xiCjN/YW9y4=;
  b=Mf61YVZr1yyNpAue0qhbGEU33FJrrVQXDRNt6223/Vdk9L/MQNXoc9B0
   IbvnFpcs5dObQTa8p8ORmJwbUUK/l7FTOeDCysGZB9D/sq0B3UFKHuWWM
   7Nt0PnCRgZsNc3TKgJdn0zC6bNA7lzecaQd5JXH4afKQOfrKUQV42NwpN
   6MObKPn+jSP5eV3l0AEYiZyqKvC05LgQg7ZqV6IW0rneNyg9yZOfZuU1t
   g+Lp+RWpvpQumx6cWZg5YBxV+kgSvWA//dRYUQ8btrTN8tEQCXqJtrU5/
   e2QCqWavARJMn6cCG0mw9SEZMbJ7pjTyOqNu77JuWNfFlPUhhi0xDwnK4
   Q==;
X-CSE-ConnectionGUID: JAwXmDmdROG5ZEVgSwihsQ==
X-CSE-MsgGUID: ErlMfVNBT46dyyNytyOtCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="59869989"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="59869989"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:25:55 -0700
X-CSE-ConnectionGUID: dkr+rBy8Qy6YhDIMKhU8hQ==
X-CSE-MsgGUID: Y8v/lh1yTAivOCF4gaDBHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="140008953"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:25:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 23:25:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 23:25:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 19 May 2025 23:25:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YtuzLtf+LQG3Bt4mSR6yZY6iezjqlIsweirF+wO2Y6bPVRBb7jWzG1ueSCs1RU7Sz02OGx1EiK3P92nGex1i1k2t6WdqfBJmbqNHapJm3tuemfChiTQ+27jJhcLyu5IKpJxPyoUd3rMmU35T8iLUYmu1KqZi/cEm9Uyt9SlT2dpGNblmv9y06nPZbIqUhCIu0W0uVbZA6V6LaucE3VOvUs752sP0Gk6FoSS+owdQGY7ydOzZpzFb7LB3NuSnoDAGeQIG+KVjVHVI+cKRrWYwZfbqzcf2/34dSXIuR27vgSQlNRpzNN1gyZgUG4aVbEgbG0O84IUMgSAI/t2rGLd2dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QxevAd5hKS9oIpAhGffnMWuV4euOMaO6xiCjN/YW9y4=;
 b=whT57a199j+Kdo4zrx/Un0bvpWXBfRZqttUc306PafdlfXjr0ySl8ybvijQ+0K+z2x3DzRNF7B1JI7CTNb8jfWPSPqIpBsB5L0wxzSREEV9lAW/RrloIgHO8UfFPziI85p2G5V3VgWLwddC/3RP0Mox6TZDM6jkTSzQzsWcakOl/oCUo6+aFJ8dTEODMDwmPKoecn0YeAA2haSeOzCG7ZmP0guc4FngIdFCzSmLgTpczIgDvgqbRIh4TJFRhtV6iVW3REQwkEWZoJeQn8lukUlP7jCbKQ9czO6A5NruqWAJekAnEuAu+8cNmAYaXzMZIMvg8RK9+tqaM5ORjhqA/uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DM4PR11MB6192.namprd11.prod.outlook.com (2603:10b6:8:a9::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.29; Tue, 20 May 2025 06:25:04 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Tue, 20 May 2025
 06:25:04 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyI9kSVxmTXaknEyFmJx4IavRXLPaM+WAgADafcA=
Date: Tue, 20 May 2025 06:25:04 +0000
Message-ID: <DM8PR11MB57502D692F699DB8D8FCFCBEE79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-2-elena.reshetova@intel.com>
 <aCtor7AxyLAk3rlB@kernel.org>
In-Reply-To: <aCtor7AxyLAk3rlB@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|DM4PR11MB6192:EE_
x-ms-office365-filtering-correlation-id: 80282964-05ce-4a53-7ace-08dd97670ee9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QUlNaHQzRXBsK29FR05YN3RCQWhXOFBIWnRoa2puOElrRjlKUndLTklybCty?=
 =?utf-8?B?MmFuUzNtMjE4Q3lKOU1rVTIwSThwUGtHUjBRanBhNHN3MkNqbUhoWnF1UlZp?=
 =?utf-8?B?eVhweVI5Skk5azFVTHR4Nks3a2JOUGszUkNlampMQVpsU2twSEJ6Y3lwSC9R?=
 =?utf-8?B?akdod0kxUDB1dXFaREJuZjg0MFE0VElpOC9sWnlDaVpRRHcrQjFJczhpdFdv?=
 =?utf-8?B?TTYwWVdHZHU3L09EcEJ3d3Z1UUdxaGN2MVZkRzJKeG8rWjkwT09zMVQ5TkZk?=
 =?utf-8?B?WHlxVHZUeWl6b0pnNWF6WFptK2F1bzRyWE5xMFljelpDVUZkdnRGWVFhaXFG?=
 =?utf-8?B?MmEzZmU0ZGhiTFI2LzM4UWg3Z2Y2NTMwQUY4K1VqeURISGZUdDh1ZlE0bjl4?=
 =?utf-8?B?SWlQNnBHN0VXdUNyUXNSMHFWd2dHRWxZREk3bU5TMzRPNkVIUGJzTjU2UlpI?=
 =?utf-8?B?ZDQ3YjFoTFFkWk1xVWxZRnFhSkowd3U3YlgxcE1mbzFMclpBY01kdmpmWTdM?=
 =?utf-8?B?V2d6N01mNE9sYkpFTk0zUzB4a0lPYXlPUXJqc29OZ2wwcjhpVjBybWcvdEtx?=
 =?utf-8?B?eWJLcnZBcmlidzd3MEM2bU1KMHVoZGNTWEtDdG1kUC9QT2Fma3BLSEtjMXBY?=
 =?utf-8?B?dW9tTUZqN3M1cFhtSUdoQmozNS8zN1pveC9md3Q1SG9WbzhVazJwajFPcmhV?=
 =?utf-8?B?VTRTbVpydjRPNmlHaHhaRUNPaUFqNlYzQW5zVzdycUVlTUlmVHQ3Y2p6MU16?=
 =?utf-8?B?c1VjSUdxcVQzdi9ydWpmYWtBL3lacHU1RzBIZ01DdVVPUDIrNHBta3ZWSUJp?=
 =?utf-8?B?U1J2SVF6Qzh1eTlnTjdPTkQwQjlKclphSjZyR2dRd1lyU244TzdGRlYrY0JB?=
 =?utf-8?B?ZnlmU3BHTkxaSmJGTFhNWlF2aUY0ZmhwbmppSFl5dGdjRW56cEcvc1BOOURs?=
 =?utf-8?B?Y3Y2TWRDYjIxbWRXTGI4aTRHMU50bmpoRDRndW9nOGZKTDY4QmtBaGlBT0lt?=
 =?utf-8?B?V3JUYkRPeUFuVXFFaEY5ZlhlNThzQWQyY1pXSEJJSW1oZmpPczNRVlpVYWow?=
 =?utf-8?B?dUFjSHY5NmMrcXByTFdWdkpITUV6UFUxeU1xUWNjTjNkSGkyYlJZbGZNZ1kz?=
 =?utf-8?B?eGg1Qm9kOW1tUVR1R2hNcVViT1lIVEtheFZXay9nZ2dCN3l6WGVONkcxY2ZU?=
 =?utf-8?B?azczamZxdkNCTkcxL1NwOXRGOEhYRFpmMWVRbC9Sc21YTjcwTy85NXlBdGcr?=
 =?utf-8?B?YStId01rcDVmSkljUTluUU9oUEhrdkVZdURyeUVGTXR1U1JWaitBYzlLWmw1?=
 =?utf-8?B?QndPTDcrSFVYcVV0K1BvcVF3RjBJYlMvRHRsNmcrTW5QWFQ4cFp4V2ZCUHlM?=
 =?utf-8?B?Q3IyWU05emVEUXBKZjRjZ0t3T2JtQ250a3JhMUl2Vk93NFhBUVUwSi9MbDNt?=
 =?utf-8?B?MUtLbGh5ZkRZR0Q3bEgvenJmMDlhdkdQNmZwUExOdThjTlliVWFXYm5HWDZr?=
 =?utf-8?B?anpDOWVlVlNvNzBWSnNlT0ZvNXd6ZDluZVVHQUlLQzRFK0RLWXRwNHozdzhE?=
 =?utf-8?B?bG1XOXBiVEY2VDdXMUR2dFIxZ01mSFBVSm0vUUdOYzFXV1BteVNOV2l2SnJh?=
 =?utf-8?B?YmR6YWpqNWpseFRoc1Vxbk1IWDVxejYrMVNpOWZKU2lGeENxdzRwNEw1NDJi?=
 =?utf-8?B?bnJmak0rN0Vsa0hUY2dXVXY0emZCcVhwaUwrVGRuRFpFNCt4YWhaK1hhR0ll?=
 =?utf-8?B?allMTDBTcDVnM2tCQUYyRXkxZkpFSEdMWGVZMlZQenc4S1VESVVZUitLWnpB?=
 =?utf-8?B?UUtkeFh4aXgzYnVQQyt3THhxRTNaWXQvWEljMjNKNnVNUmp4MjRRTDlLb0dh?=
 =?utf-8?B?SngySWpsTUpoUCtoK0orbHdVT1VvZWI0bFFSV0dETithc1VmdG50RHo4czFJ?=
 =?utf-8?B?TGFQRjA2TXZYTGVQNkRPZTJ6NU5BTXNXbEovdUtwZktEZ0JwYXpFV1dnZHhN?=
 =?utf-8?B?SjdEeDZqbFBnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTNIa0FWSXBseG4ydndYLzA5M0xKSWtpbzNBdktOaW8wRUpORkVtY3JvamFS?=
 =?utf-8?B?S3RFWVZhS2FzR096Rko4TVZXUGREOW5hUVZ2ZWlYaTlwLzhSRG5hVWMwS1Er?=
 =?utf-8?B?aUZITUZUb1ZFak1LbVo4ZVF3Q3o5TlRLWmpEMmc2M3I0RWNGRTlLdzFlejQx?=
 =?utf-8?B?UDU1V3lERWxLczFIQ0R3UjFxWXBEeTJlR1YvMlRkQkdjTkIvVEhYZEVyUlB1?=
 =?utf-8?B?azNjUmRCdXlwVkp1S282T1RuNWhoSEFlTU5KVk13bUpsS2RMeW9ibzNTZWlW?=
 =?utf-8?B?bFZHTGpHVzhsbXBRREpYcnJQWkFTcitoN0paS3FGYjUzY2dHbkZQOUVWY1hj?=
 =?utf-8?B?OFlCc1BvRHNSenFHZHVnd2xoWUVGNCszNzVyYkhmREowdnZVa3R1dEJ6TnlM?=
 =?utf-8?B?RWwwdkRzTnV4NlFyU292UnhYU3pDWm1oTDNTOWRVWXhLbGdsMlJYNXpYTk1J?=
 =?utf-8?B?MXl3TUJOejlZd3FrOTVrdXA1blVHWTViQVEzRkc0NnV3QXRhNFFzRUQ1cjVu?=
 =?utf-8?B?NlBUSTBQVmphdmhDeEVtRk42ekJQVHJOR1ZBN1llZ3Nxb05XblozWkw1SzBx?=
 =?utf-8?B?OEtFLzJCRjA4K3F3SVFnakl2ZTNMME9WY3RETHVhanQwS3NGQkNZSmphc1pJ?=
 =?utf-8?B?RmRwU3dSOWpPTnREYUlvN2tPYjJpYjRRQ1g0bkdiR1ZwTUQ1OXBSdDhQeGp5?=
 =?utf-8?B?azArSVpBY2RRK3pIdWRCK0Q3VGVzMEs0OU1MN3MrTzhxRWFzbVRKZXgydm1F?=
 =?utf-8?B?Sk93bjl2OFRxMzk1K1RTTXV3ZndJdUp4cVFFTEt4cEZlbW9kRjdOa0RsZmd6?=
 =?utf-8?B?T3RNNWszak5JWkVKYUVUUVNxTnBqSDRSQVgxKzU3cWF1bWllaWZyL0VMdHcy?=
 =?utf-8?B?dXJGNzg1SDRhellMczJmYlAxVHRRQ3NBWHZOWEpKbU8rNWhSR1BpbDFmbk80?=
 =?utf-8?B?ZUFITk9BaVFxdG5pWkZ2NSs5MHFEcU5RZ3BvZWdNSk91RWw5RzBwaW1DSUFQ?=
 =?utf-8?B?ZEtOR3lsUE5qNHpkcE9YVmY1Q1h4SWM2T1ErM1UyNStncFRPWFF2RTVRQSta?=
 =?utf-8?B?bFpER3JUNzcwSDVqOFF3NFNnRDhNYmpzZnNUL2t2azdUY0djRDNtV1VhZnFV?=
 =?utf-8?B?THZjY3NTYjcvWm9URkt2NUIrRHIrU2xLeXlQVFh0bTQxOHZGODlKYzBlUkdG?=
 =?utf-8?B?LytTU3Q3b2g0SU51eEpFNzhVdTV2aWVCM3kzRFJqUThOUVZZdURzQnJFbG9t?=
 =?utf-8?B?Umx5L1RJaWpaekFTVUNTci9qYWFiUXlVamt2Q2FlVjhYUVQvcTlidjBoL01z?=
 =?utf-8?B?NktQV2s5M2QzUFBtcjVESUUvWHN0ODdQOElZeEIzNFdISE15NC8xaDJ0ZVNp?=
 =?utf-8?B?c3JDaFZtS0s4S0QyZmgwZGRnbWVoZHNwYndQb0xRY05aZkZwYXBmNE4rK3lR?=
 =?utf-8?B?dEhCK1gweCtUTStSY1l0M2gxSi9OdzNNcW1wdVpYSTlSYVEyQ1N5Qk1FVHpu?=
 =?utf-8?B?UzYrY2o5cWNhZXU2S1RyckZUTURKY2JScVhsTTZLcXBQZFczUU85Y2svVGIy?=
 =?utf-8?B?bFFYM1dCSkIvVnhHYTFheXpXMThOUW05TXhEdyt0NjE1bmRveHliNVlPcURl?=
 =?utf-8?B?ZU9mT1BmUVUxL3hxejVyUnI2anhkVW14KzFNSFZydURjdmR5cGdLSm0vWWNK?=
 =?utf-8?B?MW1JVVlPSUY5SzdRQ3BCTmhvdURxdmJUYUxxRmd6SjVaaVFScTVnRDVHMFl2?=
 =?utf-8?B?MnVZN09JTnc5ZnYzVGo1bTdRejVpZkRMWi9ITWtUR2VCMzBDNWdWZU1PclpQ?=
 =?utf-8?B?NGQxTUZJdmFndWpHV0VvdWNEbFQrYzZFNUt6eTA4UTdTeitGR2F6MlBOcmli?=
 =?utf-8?B?Rml1OGZVRnQwckRibDEyTFJ4NUF6cmlvMVJqUEY5cDFYNTFpdFNxb3N3OVFO?=
 =?utf-8?B?SStNRkNhSVFyZCtTRkhKRzBmSERwZGhGeU1CK0lxNVZjd0xWOGYzcmd5U1RF?=
 =?utf-8?B?d1NHS0J1bHUzbnRVQURyWmVEcmIwZjhWR0pnSHpTazRQN1dvRzBrdG1Wb0ZM?=
 =?utf-8?B?NndON2Q0L3RaR2xnTWtscGdrcExDRWt1bFlEWHNLSmJHcjh0SWczSDNVdjNV?=
 =?utf-8?B?MndtUWh3MEVWaEF3SzloaEhEemlPV1N1eDRMd2JSYUhGYWZYcmd6ZThJazBR?=
 =?utf-8?B?Rmc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 80282964-05ce-4a53-7ace-08dd97670ee9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 06:25:04.4062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3R5m1G1cY+/KxZG3kAQDdsRIXIkFZUycA7SHETORuem71fnk9LWuf4nJzZRpEi1d+ZjTWX9jfpkkUmSpHr8nopS19vdCNh4POjASEKLXw6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6192
X-OriginatorOrg: intel.com

PiBNYXliZSBqdXN0IHVzZSByYXcgYXRvbWljX2luYygpIGFuZCBhdG9taWNfZGVjKCkgYXQgdGhl
IHNpdGVzPw0KPiANCj4gSU1ITywgaXQgbWFrZXMgb25seSBzZW5zZSB0byB3cmFwLCB3aGVuIGl0
IG1ha2VzIHNlbnNlIHRvIHdyYXAuDQoNCllvdSBtZWFuIGZvciB0aGlzIHBhdGNoIG9yIG92ZXJh
bGw/IEZvciBvdmVyYWxsIHdlIGRpc2N1c3NlZCBpbiB2NA0Kd2h5IHdlIHdvdWxkIGxpa2UgdG8g
cmFpc2UgaXQgdG8gYXRvbWljNjQuDQpPciBkbyBJIG1pc3VuZGVyc3RhbmQgeW91ciBjb21tZW50
Pw0KDQpCZXN0IFJlZ2FyZHMsDQpFbGVuYS4NCg==
