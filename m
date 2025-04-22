Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E532367D1;
	Tue, 22 Apr 2025 21:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745359093; cv=fail; b=mdJSm9bMYg4QNj9lDwxnLRJAr5F825RLnQgGD3IsUNZ/NAp9s/natWjkZpH4Gxth+J3Gn+UbKnyeR4OEgPUuG6qTOKUQMGJFsYLR66j+QlJGDRYqJamwfepgmnMP7d58GNWQMG31HgoS2eEwH/XwIU5/UJjrCotgrZaN5L+oSuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745359093; c=relaxed/simple;
	bh=HVZdo6U2AY81Oa3ndmFTu7F1Nx3RCTd1a/xc3zYtzbI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rMIiGlGou8FiIPAMNqtbR2eldIwz9ar2IDscrNPQgkmmikQcv7I15js9xAUQHn+NYfDwyHp6WJ1aAvPRS+JKel+wSa5hMba5R3ndLDhuqZ+2vBenY65MIiMAPmNfZwXubHZgLM7S7CQz3/IyNBiQUdBldga9ALCRVqYudx815EU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ea8ufSGG; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ea8ufSGG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745359092; x=1776895092;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HVZdo6U2AY81Oa3ndmFTu7F1Nx3RCTd1a/xc3zYtzbI=;
  b=ea8ufSGGadOj0dzEc8L33Xuxoj+joPx/yz3TtTi82BP4TDd2KEv2ml3R
   Owbt60/VZBX8on/mlXBGh9N/u+pxYGeA9ly7pe+Q+Htidmcjir7jWjWI/
   r9Gl2zkiG6FF7gJRthGBrdQ66hAeFGf6bJrqbdfLSVqKgbnsKfsdB9p7y
   9uwk/L5Q5SMih4RD71hRykFhIucDvYg+9S/s+pumAep3s9kKbs2PnjJle
   I+gn/flEIlFA84/WP6P0ldDfwhEjttEfAHmbYaWVEwJJGO2VnnsOwpKRg
   7h5sVm2roRpwh3Pz+1InB1FsoVno20MVjxnMr01lBgcSUYId9elR7Aysg
   w==;
X-CSE-ConnectionGUID: cfY/gL9+SJimlpIyJf8TxQ==
X-CSE-MsgGUID: rbpM6R1SQcODpS5pi0U5zQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="50597230"
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="50597230"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 14:58:11 -0700
X-CSE-ConnectionGUID: ThM1BBHNT9WKchRhYCMReQ==
X-CSE-MsgGUID: gpKL6zeHS2+tksO7uQZHyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="136915193"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 14:58:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 14:58:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 14:58:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 14:58:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mgPXPhDms1VSkn0uk1hc5LjYAQ+p15G5bTUfRelYj4Kjt4r7w1CDfSll7KqhRYSxqrWiX6JkFWEpzv0p6JQFH+Qtg0QndAMdxe12x/8/Z6YHg25nyvCpLbS01ykAUeMcU543ZXUytGz4pTsVzOXoZWD+ZInuqLr3lu6r/RzSgEq6N9rm4gMBeDjAGkt/01TFbuIPmwmKtZPRetVUcVKtxWOm1EnVSCG9R7nEox7OGDu2tA6HKWVmK3Z7VQXwu1Ve46ofO1jUOpOydXwGhxolJrlwBnCFq/z3apFSTHNM4JeNUB9YBVOYRMr6qPd+gzsIL1w+G/1il+914ooBS29wZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVZdo6U2AY81Oa3ndmFTu7F1Nx3RCTd1a/xc3zYtzbI=;
 b=PvCkiDd6KkV4qRbYBewDBKe4MSY8KljBUPoIPu/mv5gOhJ+X9pKx9+eyGP8gZFlRgcvXpYbocSoNytGSCsHBx8akYbUMaXAq7nG4jhaHPI2bgq5Aipddg91+N/aswaEL/igWr2HKFp7LOiwf0x3cKtIDMnANZQ9QYFDCoTy9DU3t9+WQq0Am7ibe396nxRthyvc3OdBvROdETFViqdpbBSjW5/FK6ZhCQgQjCvFu4iD8DWZ/L86XhlvZGle3CWBZ922q8R3Vz7EMvKEkIaapj2q66ZHzym/8C8jtP0n8eqhNoFwLrAMsVoTa9fnjPUDNUstjLtyudRY+qLaGg41gZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4514.namprd11.prod.outlook.com (2603:10b6:5:2a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 21:57:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 21:57:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Cai, Chong" <chongc@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"bondarn@google.com" <bondarn@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbrfz+Y/CHaQuxfEeQ0lhbNBYyWLOph/QAgAXK4oCAAG1VAIAAhvgA
Date: Tue, 22 Apr 2025 21:57:39 +0000
Message-ID: <306e06e2aa927719fee9e5cb42cc7657837d2e67.camel@intel.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
	 <20250415115213.291449-3-elena.reshetova@intel.com>
	 <aAJn8tgubjT5t7DB@google.com>
	 <f5cb3c37589791b2004a100ca3ea3deb9e1ae708.camel@intel.com>
	 <aAefmNVRFc3me6QQ@google.com>
In-Reply-To: <aAefmNVRFc3me6QQ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM6PR11MB4514:EE_
x-ms-office365-filtering-correlation-id: ca131204-5fa8-48f0-899c-08dd81e8b357
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b3BiYWdOMm5jQ0s4ZFQ0alB0bXhzQ0Y4c0EwZlFRMG1wZUM2T2pVODN3MmFa?=
 =?utf-8?B?bklJUVBsbHg2RndGTld2WFhsSWdJLzQ5aUlYenlkL3JRdFdRNkhzdm5LdnRB?=
 =?utf-8?B?TW9KT3dXeURXbVRpRTN3c3dCcW5OT3dHT3ZaaGlBZlMyMndnWWIvUm9TZ0g1?=
 =?utf-8?B?T1NKdWJRQzZvRVJPQXpnU1hmekEzZlFBVVRhb1RsdHMvb0tsV0sxMkJRMU1w?=
 =?utf-8?B?MVVwN2RvTnVmVEE4ZGJRV3A4QkduZndhUGNpNEJsYUNSK2gyWlplWTFvcGUv?=
 =?utf-8?B?clNYNmZ2OEU5dC9YVXlva1FMbnpyeEZad0Qza1RCQ3FWNm53V0NnekJTMkV5?=
 =?utf-8?B?Z3RpT085Z0xKejN0QitLUHFEdlpFZWxnMnJ5SHB4dG96alA3WVZoNEI0NUQ2?=
 =?utf-8?B?aENtTlNQcXRuWStxbVZnTnF1ZHkxZFlRWU9OZXp4azFrY1E0V2J6TEMzMTBu?=
 =?utf-8?B?d2xKdDY0TkpYQnVJRnpQcjF0QkM0MnRqNGg5b2EwSEVESUlNb0JBNnBYZ0xv?=
 =?utf-8?B?TGlmdytKT1dCRDZTUldlUGJGTGRKUTZiTGJFNnE5MVRQdkVFY0g4dy9iL1ZU?=
 =?utf-8?B?RlRvRk42b1VlYS9iYzdialJ3blRYWW9vMWhkbzhIU3lNYUx2TzJZWkc0MWNx?=
 =?utf-8?B?b1czZ3lUbGNGeGVIS1dSUGpCWjBmeXBFQzdOdkNwNDgrU0NaeTZBNzJjeGtH?=
 =?utf-8?B?OTBUTHRHUlBXRndjZnVaK2FtK0RsK3hRQi92TFh6YkZHRzNKR1hWNnp2UHIy?=
 =?utf-8?B?N1ZVUWxHcnZRVzVZbjlXRmYzTGpSc3ltOUh3OHZKOWZvcWpEdVZYbWhqcnpJ?=
 =?utf-8?B?a1p5cU1OdDZHRTNmemNKc0gvdkhJT1B1dFdPNm1XM0VjUmFqUUhzNDI5and1?=
 =?utf-8?B?NzVTZm8zci9KT1p1d2VKeit0REFXSkd0QUVaQ0NTTjlVK0hvclBsaVR5ZTZs?=
 =?utf-8?B?cXFTYWFLYjJPTWdoZEwzRDFEdWxWSDVEcTBhWDhmWXV2cmNaQXNPS1YwV2FN?=
 =?utf-8?B?bWljaDRyMkQ2US9ySnZXZWt6a0k5WmxmaW9MMWRPTGN1WTZzazNCMXlXQ2VD?=
 =?utf-8?B?RVJKSjZLNVp0WWsrSFhMeXE4VEttY2k5ZUZCZ21TOStsREo5U3puNWcyU3BC?=
 =?utf-8?B?aHBjdi8wZVA2cS9IMVFHc0d1ek9rSjFPQ0drWDFvemdtMjgyNWZNUDVjWCtF?=
 =?utf-8?B?MHF2WVFzblh1MjhLRkZKa2NNWlo5ck15Wm5LVThZWEtmYmZ5b2VKVUpVTEt3?=
 =?utf-8?B?Vy9ZZllTYTlWYTBsZ1JqMkJXTEtkeWVmZ0VxeENlakFhamkwRi9HbzQyY2hB?=
 =?utf-8?B?TjFadHAyKzJIQUl4SXpRZU1RZ1lrUDdxcHFEMUY4d0toV2U2TkhkK29XckxN?=
 =?utf-8?B?NDRoVHpjZkNBdllvTElJVUZYMHM0c1Z2dHIzQk1JdVNhYXJFUnB2b2U1UG9w?=
 =?utf-8?B?bzFCdmcxR3JBNHlpOEJRcnMxYXVOeWpacHVEekpTYWhrbGV3NTFjdTNZWlBB?=
 =?utf-8?B?RVhNSDVJVURrZXdWSktmSHF5a24wYTJkZlFNSmhFcVZ4WS9oY2IvbWk5cGE4?=
 =?utf-8?B?ZmJzbDB6dDNtYkZSbzBHS09BeEthUFVjZGErdkp6eGdnUnBXUXlNTjhOTVEy?=
 =?utf-8?B?Wm5aZUpuNmozYzdQNGl0RXJsVlFRWmwzR2dWZm42Z3dmUlpxSkhzZGF3Q1NG?=
 =?utf-8?B?cm1UUUR6VkdYbXBDWjZjU25GcWZtWGdLNWk0bURieWpmS2xEWlVMOVlVWkda?=
 =?utf-8?B?MGJaanRzYjBlRDFCWWU3VGMwU29wTm9NVWpJQmE1aktKYUNyejRkWDFGZWFR?=
 =?utf-8?B?V1hCWGFFUWw5N2w2U3JkMERpQWFuUThsekNsT3FVMzR3UmRZMlZoT2ppU2hT?=
 =?utf-8?B?eFpORGlFSDI2RjFlcnRVVEdWQ3lrVlUrUzFmV0dRemJ3MVZwbm1rWHlvK0hu?=
 =?utf-8?B?dFFpa3FVdXdhcFp6TEF4T0VGaVVRd0pqSmphd0JTRTN4cHdDVy84VzByL2p5?=
 =?utf-8?B?Rk5neG1TVmFBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDZScDdmNzZHS1FCc2gwOEppOGZVQmFPcWFNVDYyR2pBK3VvZkU1SmhYNkhW?=
 =?utf-8?B?M1UzWHByRDBTNVd2SS94cEVlQlNYdU1tQXdWbVk4SThCV2hEVFN3YkNnc1hZ?=
 =?utf-8?B?RkYwRzJOTkpRMVVtYkFPRFBNbWdEWklJYmI4cXNQRlBQWkdpS0hoRXFWOEdo?=
 =?utf-8?B?bnozbThQV3dRRzBZZE5WSVNJUW1FOHd6RUdUeU1MQncwc2Rhd0phaElpclcx?=
 =?utf-8?B?VFdXU3M0aXE2NnE1TGt3RTNCSDA0RmVHeHl5aHphVk1WaXE2UWlIT3d4UllR?=
 =?utf-8?B?aXVONmx5U2c2enJudmpCR21FL0RWdFhRMlBqRFlRREVnbnNkb3N0SDZaQXJi?=
 =?utf-8?B?dkdLL1gvWHdZWUtXL09QWENzYmJSN2lwOFlhYnJvVDRMMXRkS1dJeXlHaWJ2?=
 =?utf-8?B?SCtwQVA4ZFplZjFESGgwZFdLMEZXbUdMcC9PMlYrQlZNcGtxeXdwcUdvR1la?=
 =?utf-8?B?RDZjL0NydjljNWthM2NuanloTGhRbnRGZ2JsdEYyQ2VWTjAxc0FNbjN5aXl0?=
 =?utf-8?B?OHRrRzU0WklZMkFyZ1p2KzNqSVRBSC9ZS3F3OUgyUDdwdVJobndsYURwWXpl?=
 =?utf-8?B?SDhlVUxKczlzc3QvdHc0Y3FPOGtEektXWWsvM3ZBMGpldVEwNkZHVk5DcmxB?=
 =?utf-8?B?ai9ISFpQR3B5b0hSeWxyVkk1REVrUUVHRjJnOFcyVGtSaXpWa1hVbFFqSTVF?=
 =?utf-8?B?Umc1WDFpcW14Z0RqclF4c05YL1dSM3JiRTFnVW5ab3k3Nmg0SGxyNkdJNWY3?=
 =?utf-8?B?azYwTGUzb0JaVzIyMzA2YUFPU05rMVRmaEczSGdZclRaRlJVQldkSlVuSmRW?=
 =?utf-8?B?eFNoVFQ2Y1lPaVl5UjBGUVpHSG81NUJwTUN4Skh6N1lpY0RpNTRkd3pqYk15?=
 =?utf-8?B?MW9oYVJRdm9rdm1ZcTR4WVNvQ0dXOWVsckZFTkxhZ3llZmozUTdzTGhGQnFk?=
 =?utf-8?B?Mk41Q1NDL3lMS09tZFUxck5RTTFpNSswQXgrV1hVMm0yOW56blhUbmhCeTQy?=
 =?utf-8?B?cGhZZVhFVTFMQ0ZsNStVVW5IQ2lGSDVDeDZMU1RXOHkxN2xCK0E0ekcyU0pr?=
 =?utf-8?B?TjhyYmo4ditBNXpldkpId2M2ZGRkQXZrT1JlQkU5NllUNXFEMWc3ZzBIRm1w?=
 =?utf-8?B?bU9tMUEwWjcyQ2JPbGRoOWpKVUx5c1RJQnVXRHR3MzZqMVRncXVNckJIa0xr?=
 =?utf-8?B?RkxYTUtZcXREbDBpZStJOVpaQ0lBak5BTGN4a2I4dTZOOExQODdDRlFtd0JH?=
 =?utf-8?B?dUlGY1E3NGFhdzlsdnBnYmNldTZMWVFYZUhlcUdzdVB4RTkyMjJRQ29JcTha?=
 =?utf-8?B?QmRCMzBmMHNMZzdwajBiYk5jUUlwK0E3QjF0aVBHYVFVWVBCUFhMUHV5K1d5?=
 =?utf-8?B?Q3lraCtCOFE5UFNZTit3R21uam9DaG9IUEtuUWdlR1N0WFhVVWYrZ2RXSWgz?=
 =?utf-8?B?QWQ1Zy95ZUVPTzlyOVRwV25hU2g4MmJOOElWOEtiZ2gxYWZjbHZKM0RlT1By?=
 =?utf-8?B?Wm1zVVdzM25JR1A3NEN4WlJMZ1paTlFadkFYSE02ZGY4MWVDeW1TYXpTQm1R?=
 =?utf-8?B?VE9GR016UXVvTkl2cjg5bVBRSGZEc3FGU3lZdnVlNjI5NlZDdndpei85dEhT?=
 =?utf-8?B?NUtvUUJudnkxTGxSZFArYVM1U1ZSWEo5T1NmZ3YrblJibDFBdkxZbzdHWGJC?=
 =?utf-8?B?aGMvdTcwaFFNY2hhMHV5aFlnZXdHbnl6SVh3NEdZWTJtckRSeCtnTU9Ic2ZY?=
 =?utf-8?B?ekJ0ZDFhb1JoM3hmQThTdVc2QnFLMnUxaGdpMjBrZ0U1bklCNXBiQ1FzYlI2?=
 =?utf-8?B?T3RFRFhBVzNCKzVKMHB4b3RZeXVxSHlaQjRtRzNvYzQrV1V6bHFCZmx4YUl6?=
 =?utf-8?B?a0QxZTRBbmlUY3Vsek5YazNMUHJlYThydkcrVE9WR05WT2EybktFdUtFNkVx?=
 =?utf-8?B?bkF0Zmh6TUJnODVFM296WkdJWU5IZ01pVGw3SFNMazc4Rjk2T0JNZUZZb0lZ?=
 =?utf-8?B?SnZYWGd3QkRRbFNuS3BEMmhIWnlWclpPL2JuTXZFTUIvV0ZETFY2Z244cThX?=
 =?utf-8?B?aVVzWTVmeEswbGtCcXZNdzRsMmFYT01rM3l1Nlk1dHljQVZhS2RxKzI2UDly?=
 =?utf-8?Q?MlODJC06utTrujxegtHErOZh9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F529ACAA0A6B64A8BA1752FB843221B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca131204-5fa8-48f0-899c-08dd81e8b357
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 21:57:39.7475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jxGBGVEo8y6rBhxAPWTAncJFvYVCaoSELM82NrQzUEopmeRjshBYdbVJ2n/MYDvfBZ/1j8EeaQgA3FcTTFBkMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4514
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA0LTIyIGF0IDA2OjU0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEFwciAyMiwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIEZy
aSwgMjAyNS0wNC0xOCBhdCAwNzo1NSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFR1ZSwgQXByIDE1LCAyMDI1LCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6DQo+ID4g
PiBUaGF0IHNhaWQsIGhhbmRsaW5nIHRoaXMgZGVlcCBpbiB0aGUgYm93ZWxzIG9mIEVQQyBwYWdl
IGFsbG9jYXRpb24gc2VlbXMNCj4gPiA+IHVubmVjZXNzYXJ5LiAgVGhlIG9ubHkgd2F5IGZvciB0
aGVyZSB0byBiZSBubyBhY3RpdmUgRVBDIHBhZ2VzIGlzIGlmIHRoZXJlIGFyZQ0KPiA+ID4gbm8g
ZW5jbGF2ZXMuICBBcyBhYm92ZSwgdmlydHVhbCBFUEMgdXNhZ2UgaXMgYWxyZWFkeSBhbGwgYnV0
IGd1YXJhbnRlZWQgdG8gaGl0DQo+ID4gPiBmYWxzZSBwb3NpdGl2ZXMsIHNvIEkgZG9uJ3QgdGhp
bmsgdGhlcmUncyBhbnl0aGluZyBnYWluZWQgYnkgdHJ5aW5nIHRvIHVwZGF0ZQ0KPiA+ID4gdGhl
IFNWTiBiYXNlZCBvbiBFUEMgYWxsb2NhdGlvbnMuDQo+ID4gPiANCj4gPiA+IFNvIHJhdGhlciB0
aGFuIHJlYWN0IHRvIEVQQyBhbGxvY2F0aW9ucywgd2h5IG5vdCBob29rIHNneF9vcGVuKCkgYW5k
IHNneF92ZXBjX29wZW4oKT8NCj4gPiANCj4gPiBUaGUgb25seSB0aGluZyBJIGRvbid0IGxpa2Ug
YWJvdXQgdGhpcyBpcyB3ZSBuZWVkIHRvIGhvb2sgYm90aCBvZiB0aGVtLg0KPiANCj4gQW5kIGhh
dmluZyB0byBtYWludGFpbiBhIHNlcGFyYXRlIGNvdW50ZXIuDQo+IA0KPiA+ID4gSXQncyB0aGUg
aHlwZXJ2aXNvcidzIHJlc3BvbnNpYmlsaXR5IHRvIGVudW1lcmF0ZSBTR1hfQ1BVSURfRVVQREFU
RVNWTiBvciBub3QuDQo+ID4gPiBFLmcuIGlmIHRoZSBrZXJuZWwgaXMgcnVubmluZyBpbiBhICJw
YXNzdGhyb3VnaCIgdHlwZSBzZXR1cCwgaXQgd291bGQgYmUgcGVyZmVjdGx5DQo+ID4gPiBmaW5l
IHRvIGRvIEVVUERBVEVTVk4gZnJvbSBhIGd1ZXN0IGtlcm5lbC4gIEVVUERBVEVTVk4gY291bGQg
ZXZlbiBiZSBwcm94aWVkLA0KPiA+ID4gZS5nLiBieSBpbnRlcmNlcHRpbmcgRUNSRUFURSB0byB0
cmFjayBFUEMgdXNhZ2UNCj4gPiANCj4gPiBJIGFtIG9wZW4gdG8gdGhpcyBIWVBFUlZJU09SIGNo
ZWNrLCBiZWNhdXNlIEkgZG9uJ3QgdGhpbmsgd2UgY3VycmVudGx5IHN1cHBvcnQNCj4gPiBhbnkg
a2luZCBvZiAicGFzc3Rocm91Z2giIHNldHVwPw0KPiANCj4gV2hvIGlzICJ3ZSI/ICBLVk0/ICBG
cm9tIHRoZSBTR1ggZHJpdmVyJ3MgcGVyc3BlY3RpdmUsIGl0IGRvZXNuJ3Qga25vdyBvbiB3aGlj
aA0KPiBoeXBlcnZpc29yIGl0J3MgcnVubmluZywgb3IgdGhlIGludGVudCBvZiB0aGF0IGh5cGVy
dmlzb3IuICBJLmUuIHdoZXRoZXIgb3Igbm90DQo+IEtWTSBvciBhbnkgb3RoZXIgaHlwZXJ2aXNv
ciBzdXBwb3J0cyBzb21ldGhpbmcgaXMgaXJyZWxldmFudC4NCg0KSSB3YXMgdGhpbmtpbmcgYWJv
dXQgS1ZNLCBidXQgcmlnaHQgd2UgY2Fubm90IGFzc3VtZSB3aGF0IHdpbGwgdGhlIHVuZGVybmVh
dGggDQpoeXBlcnZpc29yIGRvLg0KDQo+IA0KPiA+IEFuZCBkZXBlbmRpbmcgb24gd2hhdCBraW5k
YSBvZiAicGFzc3Rocm91Z2giIHR5cGVzLCB0aGUgdGhpbmdzIHRoYXQgdGhlDQo+ID4gaHlwZXJ2
aXNvciB0cmFwcyBjYW4gdmFyeS4NCj4gPiANCj4gPiBBbnl3YXksIEkgYWdyZWUgaXQncyBub3Qg
bmVjZXNzYXJ5IHRvIGhhdmUgdGhpcyBjaGVjaywgYmVjYXVzZSBjdXJyZW50bHkgaXQgaXMNCj4g
PiBub3QgcG9zc2libGUgZm9yIGEgZ3Vlc3QgdG8gc2VlIHRoZSBFVVBEQVRFU1ZOIGluIENQVUlE
Lg0KPiANCj4gV2h5IGlzIHRoYXQ/DQo+IA0KDQpJIHdhcyB0aGlua2luZyBhYm91dCBLVk0gOi0o
IFlvdSBhcmUgcmlnaHQgaXQncyB1cCB0byB0aGUgaHlwZXJ2aXNvciB0byBkZWNpZGUNCndoZXRo
ZXIgdG8gYWR2ZXJ0aXNlIEVVUERBVEVTVk4gaW4gQ1BVSUQuDQoNCkdpdmVuIHdlIGRvbid0IHdh
bnQgdG8gcnVsZSBvdXQgdGhlcmUgbWlnaHQgYmUgc29tZSBoeXBlcnZpc29yIG91dCB0aGVyZSB3
aGljaA0KbWF5IGp1c3QgcGFzc3Rocm91Z2ggZXZlcnl0aGluZywgSSBhZ3JlZSB3ZSBzaG91bGQg
cmVtb3ZlIHRoaXMgSFlQRVJWSVNPUiBjaGVjay4NCg0KVGhhbmtzIDotKQ0K
