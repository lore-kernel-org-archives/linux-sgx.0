Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D967217597;
	Mon, 29 Sep 2025 07:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759130276; cv=fail; b=QKcDorU7VQ1Tc5fXuaqDuY1K02H2R8nnI63XqVWXCow2s4o//pwBiG76436bXuiaCymlx4RcViNQlZuR5/OsTfuZnyzp9n74RTqGj3DYkZkBU+5CcQtXFgfnwziiS0j3Q6A8qYPcsWI13pgD9xzniWkmVQwBXYIa2GzF0ZzUEZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759130276; c=relaxed/simple;
	bh=T80g1kt0ei+ouUuzupHhKrKSJCSR777dzfiDlWd2ihA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sfLkhSC2hEbl5CnkwKcGvvmNMFVLxng+5bYnbfNYpclp0rVVxQNs+Hw3ildkiEJG2xlt5mQmQ3ouP+BAgTF7w1wuIBuTyy+xtIIA8ubAtzY3Rq+1xZ38iE30H0cqp5JWTapbk6OK0ZmMgeQFQP0yt164spK+0NYNkbX0bRQ6RuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YbgyaXo+; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YbgyaXo+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759130275; x=1790666275;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T80g1kt0ei+ouUuzupHhKrKSJCSR777dzfiDlWd2ihA=;
  b=YbgyaXo+Rcolhbj8iFiRB3+nF/EVurh7hZMBTkGjm5yibL2GctQkWBbQ
   KMtMK0mazBpNWbf03WWBGa60AsQwz4h0cJr1C9m0C5Cll/hDObF9VBruw
   IMfebtzzcLp6DOW1hnA8EMs6LCnQpGddSetgacZa/FW6tMvDQeiJMTFTr
   BGy8jMyZ8paP9p/JW38I4hhVXgJAsSpNu0duh+KyaiOdt16oKExuFlPrU
   oy2jJ8B0jI1GKYzPwF0OYz18tiOyo2zfiGfufsrjGHnfFaIIIjfQUmVR5
   5X+eAUdK/gUjTiOBUsqjDItVt9o6LA6xKn8Gy7YXJVOR/Pl9PapcSkphv
   g==;
X-CSE-ConnectionGUID: WeqgGFKtROKX4nqPD8iQsA==
X-CSE-MsgGUID: tmrJ46m0SWKiGgl39id2Rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11567"; a="83979799"
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="83979799"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 00:17:53 -0700
X-CSE-ConnectionGUID: eD5KWZsxRx6yF2owCYYbvA==
X-CSE-MsgGUID: vEjgHrtITXSEclzVJn6S7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="208890401"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 00:17:53 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 00:17:52 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 00:17:52 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.27) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 00:17:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1lqGpyKtQLRgJIR8i6yUcgmIrx6WLks7M9vViQk0JOVVaYjIe/sALQ+BjpFarJHN4N9sPzJCsoZIY8EvTmS98exCnV5iPRsek3T77rFWg+cT7KjLdTKFntw5mJU7YMbVLH0nK9TIvan2DO8NdjQgA9eoP8vydPgqPr/q/lBwM0dfvo3RYWfNc9GJfSStB8JSXGGNa0JlYMgHTLmiiY8Y+Kqv7LEZ9NZhcXSMHhcS7+ePy9ZCq4owjjqvKIuYSpTAx5siW6yiDWYCw12OB03bksMHEPYY5q5RUu4eX7AF1cEEQAjyzUFEg8fxT0Nq/HC8+31AneKG6A1uC/zhomStg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T80g1kt0ei+ouUuzupHhKrKSJCSR777dzfiDlWd2ihA=;
 b=eWVkD0p2U281Wjw50gNPJgu/NDxUfW3+921bMfsIbpR0WWDwr6ETsXZnXyqpLSb28LH+kaKvGbJ41b6ao+e4v+e8JFKX8gQQal3kx1CAx4RedPCw2tcfyJ4EpAeaTEHz3PE+ufiWMDg8toz85ErfvEIuzbIdCF/lc75UOfNktYzktM3Rr3PhXAuAViFQ9WCDCSHSi+0ua09pWVObh1AyqtJMvn49fesXJsE0RbnVYa2wjXWJ4UC6kDTs9qWPd2zJWbgdwSHlAIyyFHhSOw8PCkdDhxRzldga+7cCCUZfxF8E1AP4NuHGwGR+X9cHE+RtPoYgxKYc67fdQSOthkJGTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DS4PPFEE549A404.namprd11.prod.outlook.com (2603:10b6:f:fc02::60) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Mon, 29 Sep
 2025 07:17:49 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 07:17:49 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Bondarevska, Nataliia" <bondarn@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v15 0/5] Enable automatic SVN updates for SGX enclaves
Thread-Topic: [PATCH v15 0/5] Enable automatic SVN updates for SGX enclaves
Thread-Index: AQHcEA+cR1kKu06yk0OXCADImrxsDrSFGNsAgAAcJQCAJMzZ4A==
Date: Mon, 29 Sep 2025 07:17:49 +0000
Message-ID: <DM8PR11MB5750C11091D7D90B60FE7853E71BA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250818071304.1717183-1-elena.reshetova@intel.com>
 <287a2652-bce6-4084-b9b5-c8feb24a2940@intel.com>
 <CAGtprH8rPg30gsrhJ9=44uaePqf-Ay=R+O_+D8isH8TzM4uQXQ@mail.gmail.com>
In-Reply-To: <CAGtprH8rPg30gsrhJ9=44uaePqf-Ay=R+O_+D8isH8TzM4uQXQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|DS4PPFEE549A404:EE_
x-ms-office365-filtering-correlation-id: 26dda32b-0be0-479e-7424-08ddff284bdd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NjZvSTlyZUtiOUQwYVk3SUt5Nm5lMHRvR1c1ajRrOUUvQTc5ckl0KzdTL1ZU?=
 =?utf-8?B?azFXZEtDTW5WV2pTMmFiWlRjazNwMU8yMy9kOUVpZzYxSER2VGtQTWc4TTlX?=
 =?utf-8?B?TlRDWmlnRjdqTlhXWXhmcmlFcUt2SVRPN2lDQTREbEttSmVndVZtSE9kbE9K?=
 =?utf-8?B?a2J2dE92NVRkV1lpMCtUeGpvYnRKaWZmZ2N0NThzYjhvQlF1TG9wczdBdHhm?=
 =?utf-8?B?bUdaTnFtck5Gdk9YSXVNRUY5Y2VPNnJHc2VsUDg5Q09wNjE2RkNSam9KSUlO?=
 =?utf-8?B?VVpsL3k5VlV6QWhvVHhGZENZam1EQnBJK3BuNW9heW9jSC9RMks2TnRJV3E1?=
 =?utf-8?B?NUJHR0w5ZHRrRDI5YnlyMkNRaGl4UWRzMDgweTVhZGZvNW55aEYrV0JJZStL?=
 =?utf-8?B?R0w3TVBQRnlCc20ycnNpNWhvUFY1cEdpbENuczMzUFNRNGVvdm43bkRjWHJF?=
 =?utf-8?B?aG1HN3JXOEhjS1dsQlduVFYzK1F1NXREZGVjc2o0MHJsM3VTNG8vOVBENEVX?=
 =?utf-8?B?aHk5cGtCWU9hVVdIVUhLNytnWTV2VWxFdkhTWGxjaUwvWEIxeDhJV0RkODEw?=
 =?utf-8?B?b2k1SVkyYWNtY0NIZGs1eXVtWkM0MHVZME1WWUVkRlY2bmxDY0V0bzNZMjFL?=
 =?utf-8?B?R0prek1DYmJmd0VFQmZpN3NlRkpqcmh2MmRhSEYzclQydTlhb08yQzMvM0RU?=
 =?utf-8?B?cG5HZUxkVnFDMjhPK0czMThEa1QyOVNsT3UxV1lpYS9NNUYveXMxZEtRMkZ1?=
 =?utf-8?B?UUp6aXhvKzN5aHBzNmJLajNveG5KbWwxWTFhVU5BYlcrdzI4NFBVK3lkUXVE?=
 =?utf-8?B?ajVwQUVyTVNnYitYV29aSExRWXp2V2s0WXlhSW9OWVE0bkR5WUo0Qmt6TXF2?=
 =?utf-8?B?MWdMZTZXdzdyTGszMHhkTjNwRHJaOUlTY3lKbWFWNVJsV2hKTnlMMlJ6dVJy?=
 =?utf-8?B?anMxVmFyU1p5dzFnUEkwK0s2ZHJyeEpyU1pOR1dtcmFLQ1A0RXYzZHozOHpq?=
 =?utf-8?B?R1ZZYlh2aXpxU0xaS1NKQ1gwKzZ5VElYZDVlcU5TN1JZbEpJTnFLYVJrRzIv?=
 =?utf-8?B?WnRRUlU4TXhLMFBQMlhWUGdpNjlKc21zNDJjRitTSnJtMGgxWlR6cWtwUDQ0?=
 =?utf-8?B?aWd5WkdEcm5zSVYyZE5CQjBrWStUa2JaY1dOL21FVzZXdjBDTG8yY2RzbDBy?=
 =?utf-8?B?VTY5Z1BkRDFvOXN5UXNvZm1Uei9melVzcWZNR1E3SzhXS29GUE5PR1dneUkz?=
 =?utf-8?B?V3FzTXZRVzYxMUxKbWgwUStHbDFCa3JGMk1Gd1pxL3piTEtmUVRnTlNmZUdj?=
 =?utf-8?B?OC9kTFo0elZtVmMrM0xPL2hWdHpEeEVwM05NYVF3QUhld0xPUXJVRWRzU0hh?=
 =?utf-8?B?NWxOR0NXZUl4dmNHckNqSjUraThOV1R1U3o4dFFCaHUram5GYVNESGsweDJO?=
 =?utf-8?B?TWlhYVg4NXk0SnczSklGL3ZiaVNvTkVIZmg0alJJR003eW9JYTBZeDQ4dXAr?=
 =?utf-8?B?S0xZcHFYbTVCTm9DdlJaK1dKbDZXT1VVa1lyWE4yTUdBSmlxVkRCZjUxaXBn?=
 =?utf-8?B?ODJvZDY3blluWEUrZmlnVkszeVRNUDJFWEtpWWNkWWFXOGtsV2VuYm14NWxE?=
 =?utf-8?B?WVFKU0hPYU1Vc1VjU0xWSEtteTkvekQzRElreTRLaTlPRlcyYzU2OCtsTWYr?=
 =?utf-8?B?LzBSUnQ1K2FVWlgxNk1KK1BUaWJtbDIvalp2T2g3UVh0TjlWZEhyQzNSaDBy?=
 =?utf-8?B?ZmFZZ1E3UElaanBGRHBDMmxEWE96OVcyNTVVUVNxNmhGQlpvaU5yRWI4MW51?=
 =?utf-8?B?Y1BDT1dqVEV0UW15a1lBZ3kzR0RaUmFudEI4anBKLzZuT2xIWngvOUNOY0h0?=
 =?utf-8?B?Y1VKY0JlMWZxUDBHeGpZUHVNK2dJVGUrQjBJNzZJMjh4cmE4RUl0S2pTT2ZW?=
 =?utf-8?B?aGo3WC83QTNWNVhIRmFGOE4walVmQTkyZlZCbjF6YmttTHlzNUxkSTNQM0xn?=
 =?utf-8?B?em1HU2JIdk93ZHBsL05SV1ZVTVErRTFkQ2tnRW9jQlZYbFlaOEpLNTZGVk9W?=
 =?utf-8?Q?hc3N28?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEVGU01NWDNlRmtwK3lDbXZzMkVCSi9kR0tJbjRRQ0FYYWJGd0lyYy9UZGhM?=
 =?utf-8?B?Mng2WXRrVVZWYVZJSTFZQ3FDN0t4UmJHcnNEZWx3M1VpS3RISzBEZXdQOHV3?=
 =?utf-8?B?cHVNeGxMTWFHMDV6OURBVmVyQnIydElKNm1QbGRtcTlLNkkyVzVTU0Mxanpt?=
 =?utf-8?B?bE8rSjBFckREV1N4Y3NPMEpwQ2wveVNSL0xUT3Z4MXl2SHBhd3EyTHA3K2Fm?=
 =?utf-8?B?ZWk1N0ZUeWRFOXErVEFxRGkyblYySFBVM05yaVE2QVVJRGU3d0lOcXlJSlE5?=
 =?utf-8?B?WTFJMWxwdHp2TG5YTjIrMHZOa3FjMVZuZHdYQzVOcnhUUklER2ZzeGkweDNu?=
 =?utf-8?B?QjVxcU05U3o3YnJ4dU1XYU1xMjNkU0pNZzJXYkJvVTRVbEVvVHE0MjdXNkhL?=
 =?utf-8?B?VXFtSkI4Yk94UmZvSWtWS2tZMExJR0FzYnhUQ2lMTXBJN1Q4OVBhbTlMVmsx?=
 =?utf-8?B?WWtlY2lsWklZR0cxUlJja2RWUXR6cks3MEpHcFZnTWRvazFkTy9NWmRISUlV?=
 =?utf-8?B?TUtWcTl6WGZFeitMZTJkZVV5NWlLU3ZvR3g3S3NvL05EUGdNVDRjWDFUZXNE?=
 =?utf-8?B?UG53cTdrRUNSc1NZRnRvbHJvYmc5K3lEaVJVQ0szeFBWVDJhblJkUFF0UjJB?=
 =?utf-8?B?L1UwNGFEaDhtY2lrdjFnb3VaT3VGT1plWXhGV2lwMjQzd1VwNFN5bjh0c0Ez?=
 =?utf-8?B?clppTU9aOU1kRUhnQzVvSUkwUXJ3UVplVjhrV1pjVUZCTy9xNzc4NFlnOW9B?=
 =?utf-8?B?VnJSdUp5REUvVGFtcWtyakx4cGV0emtoYWFQU2Q0aUF1YnFGMksrKzRPVHRH?=
 =?utf-8?B?dDN1L1B3cENHVzA0VDRqMFNTVWllcFN3N1BsK01uZkpjVGVPckovcHcvK0Fz?=
 =?utf-8?B?djdmeExQQ2VZNFJGcitoeXp6Q2UwV0wzbjV5eEtEZDhGd25kMXc4ZUtQN3Fx?=
 =?utf-8?B?TkZOeS9DTXdtQzkwbjdzZnBpT0pLM2hJV3ZnMmpScG9tMFl3RTcwYzlzVUhq?=
 =?utf-8?B?M0pFT0xPY1c5cTNuMjFlSlJWczR4Q0V6L0M0YTd6YVRzVEFhQmgvVUZhZjhl?=
 =?utf-8?B?OTQybUdIOEpSN2plaUZYdEViTHIrVDgvbWxVb0ZEV1FlbHVWNWpjWkM1bmc3?=
 =?utf-8?B?WiswU0ZWaUZTRkg0clJqT3dYRlRRTDNta3BtaUhuTGFDL1hLS1ZYYWRFY1Fv?=
 =?utf-8?B?ZW9JMUFDWUYyN09qOXM5T3hYYm5TRnhHcW1TQUtIOHVzbkh2MCtWRFpQMnBn?=
 =?utf-8?B?Q1lnVFp6YS85QitCeGRnU3VWTi80SGtMUG5ZczdmWDk5OVVzUG90eGVJQkIw?=
 =?utf-8?B?U3MyV0lyaHFlaTgzOWhpV0VPUkkyVE9oNER5SHp6M0M2aFJ1Q2xJb05NemZz?=
 =?utf-8?B?YlBHNkRGNGE4NC9Ld0Q4UzhNQ0QwRTdrYm1ESmd0RDB4ZjhLWkthYjZLWGxv?=
 =?utf-8?B?TVV6Rm5vNUZxK3RBdWcwblRaZk4zcU5GQ1BhcFFzdkYvanczbXVUblhyM1kw?=
 =?utf-8?B?MzdFVTRvUVhvRDFYZFpJdjBrajk4UFJXeEs3M0J6L1UreTZ4SmZSRVpvYkZi?=
 =?utf-8?B?eWc4eVU2Q2ZCUHFhSnVsdWNXNVN4aWZISEZtWHBtdVNGZ21VSUhiLzNRclpl?=
 =?utf-8?B?bHFyY3pMZEI2VGlsQUhXWlFhdUhMWXl5aXR6aUxjUFlQdHRWbGNMcjRGNC9k?=
 =?utf-8?B?V2w3OWVkaEZqV3YyMXhWOFJhVzFCcXlJaGZ5TUJYU0NIU1FydkFZZmFBQ0hr?=
 =?utf-8?B?bVpqSFhRd295Zk94YWdMK1dSOHVJQS9CYTBQaTd2ZmovZFVZcEVoNFdrQ21a?=
 =?utf-8?B?TVFqYS9LRlhQUWhFZEprV0RmVnI5cDZmQnhRS2QwdERqRjYycHBob2EwZlli?=
 =?utf-8?B?dUZ6OE5NMFRlTmlVc09WT0lVUEtYT0ZQYS9IcGJIT1FDb3hUa2xvL0dGNTVz?=
 =?utf-8?B?dFFBSkxIK1RRRkRuVjlMZ0JYM0tUcEg3ZzRQZEZ5cWZYNlFpUlRRTU91amdh?=
 =?utf-8?B?QlBvdUFmaVZrK3pnVDN1SXhWVENNdlF5L0tjV3NLYWdOQktncTFYS2luSWhB?=
 =?utf-8?B?K3czcWJudjdXRVp0TUQyNDA5aEpFdTlhN1JSZFpZMWFBbmIva2p3TkJUaEU0?=
 =?utf-8?B?Y2R0SEtGOWxuS21VdE42Njk4NGV3RXZqZ1J2aG9SU3FPTXFaMnVmUVQydzBy?=
 =?utf-8?B?S3c9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 26dda32b-0be0-479e-7424-08ddff284bdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2025 07:17:49.2485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: euznDLNMZ2Nler8pq9nrrG1I4MUZ5PBbzR+mWoUbNIc3XiDyxQ9X3uDqcqFlY8D7t33t+IF91SCmU+WlmeSgpacGhKbUgk2m66/vR6V3xf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFEE549A404
X-OriginatorOrg: intel.com

IA0KPiBPbiBGcmksIFNlcCA1LCAyMDI1IGF0IDEyOjM34oCvUE0gRGF2ZSBIYW5zZW4gPGRhdmUu
aGFuc2VuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiA4LzE4LzI1IDAwOjExLCBFbGVu
YSBSZXNoZXRvdmEgd3JvdGU6DQo+ID4gPiBUZXN0aW5nDQo+ID4gPiAtLS0tLS0tDQo+ID4gPg0K
PiA+ID4gVGVzdGVkIG9uIEVNUiBtYWNoaW5lIHVzaW5nIGtlcm5lbCA2LjE3LjBfcmMxICYgc2d4
IHNlbGZ0ZXN0cy4NCj4gPiA+IEFsc28gdGVzdGVkIG9uIGEgS2FieSBMYWtlIG1hY2hpbmUgd2l0
aG91dCBFVVBEQVRFU1ZOIHN1cHBvcnQuDQo+ID4gPiBJZiBHb29nbGUgZm9sa3MgaW4gQ0MgY2Fu
IHRlc3Qgb24gdGhlaXIgc2lkZSwgaXQgd291bGQgYmUgZ3JlYXRseQ0KPiA+ID4gYXBwcmVjaWF0
ZWQuDQo+ID4NCj4gPiBZZWFoLCBsb3RzIG9mIEBnb29nbGUuY29tIGFkZHJlc3NlcyBvbiBDYywg
YnV0IHRoZXJlJ3MgYSBkZWFydGggb2YgdGFncw0KPiA+IGZyb20gdGhvc2UgYWRkcmVzc2VzLg0K
PiANCj4gQXBvbG9naWVzIGZvciB0aGUgZGVsYXkgb24gdGhpcyBvbmUsIEVsZW5hLiBXZSB3aWxs
IGdldCBiYWNrIG9uIHRoaXMNCj4gZWFybHkgbmV4dCB3ZWVrLg0KDQpIaSBWaXNoYWwsIA0KDQpE
byB5b3UgaGF2ZSBhbiB1cGRhdGUgb24gdGhpcz8gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLiAN
Cg==
