Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4833D53BE;
	Fri,  8 Aug 2025 11:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754651179; cv=fail; b=NsfSia3hKfGAUCo5gy7rIuzX1VaWuVaE778K47L0p+h53qX0JnS/eq/YfR+tg9KfvdLxSlb8Oxq1Fex2D3LbdI4puk9vwC83R/qmKHShzEy8PCTJnEljRr9+UvnCgeLYf1/nJEt5gGb3IK1XH9S/mDlXUl7yKFob/FO9ENPHGTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754651179; c=relaxed/simple;
	bh=yzR4pQwGzijzuhYy+5M108M7o1kTy1f6xbh3rGbuRfY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gwDvYPH/8YPCje02S6n4Ix4bavGj9Z9qq1wUUN9E5I5xKj7xtUbpeIVPEG8gSaoeCdKQLqcyG5CAh+lQMY1vAwDfjh6eKeqb2p0k2qo8EHLS49Hgr5yyDg492JYeAsz1S6e0uUxHHId43n53ePK1q3BbXbTd37WfXhxLRT7OCcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iqvi3R1y; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iqvi3R1y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754651178; x=1786187178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yzR4pQwGzijzuhYy+5M108M7o1kTy1f6xbh3rGbuRfY=;
  b=Iqvi3R1ykc/1kOrifhL5pbIJod1wMFMGykwCBtPbuGRo80P9ttYGa5j7
   9brshcZ6CngaMh372hjmEmWCsmAgPdHChHS6ziiNylHgXoZ1sUHGuleR2
   TknzW1hOjcvtCalDUcm0dqGIK/OqvdphbCfLXXIbQZtN41JmonMrlrY7H
   P5My6q1MbZQpzSSGi1vfMh/LeACvqQcq9BCgwnxwas+zkZ0ooDZQWGOHY
   +7sxI5pR14kGt3HWc6t/e16GEEXCA/DQ714V8VxdvzPyobVCYZsf1ls27
   PkJcDvq6tAfi1Z81lmGEP7fzHZldxgNTJbOIDOFvpXPJ/k2DVyGrKhBKo
   g==;
X-CSE-ConnectionGUID: aN9RhrIORJGKNngLv1Nrvw==
X-CSE-MsgGUID: rV04g8hKQWi85uTqAnS49A==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="60622922"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="60622922"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 04:06:17 -0700
X-CSE-ConnectionGUID: Nr05OGbYSluKb6My8hn9wQ==
X-CSE-MsgGUID: uYFOEoznQdOpiMB5ErdCNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="169764117"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 04:06:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 04:06:16 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 8 Aug 2025 04:06:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.77) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 04:06:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hCIePCN0ZyocyDrY7IU7SRsvOEBIst2ZIC+EOSAxjJ4b2LHExjElDHITrgTsUxrC9YncKQZb91XD5yudd7AYTlSihro0FQK5uZ0P6eDzgeWaV1N4MuLZPNj5RIaVI20DocBRaHDLsjEQrSBFAqU18dZ3tC8lxnytEWl+ojgQEylTgrCG9ScWm8p9axCdR33XsZ4cGvx2ecCiZVa5AxbB+tjOxeQmF4tD8IUpffhLWcC/pKjrmbQwuPRyCigquXxmvf/wmiXfMf+0CQVQCvyuijoEt5WwlXw3zEI1YjbkAFV9d/T4++A3BTYH2gQ/UOjwKDYAAwew3fj5oZnj7juD6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzR4pQwGzijzuhYy+5M108M7o1kTy1f6xbh3rGbuRfY=;
 b=lP3gYdQK9B6P6eBdZjvG5kRZW/xNnq+LOxxuFQBP3OisYaiEhhgbxZyWgbjvljf8NfwfY9mUa0J9g/bMR/kcmPJGm89qmgQ90rrZ8pSBU2WfJ8hbmR2moMTpMP0hATwv8XZCdXSaQ9sADb2SRNpF0ztUXA1C5fv23zNPPMKqFISpe7zgtPJPzGFfm5SlRno2/Xt9RKVm/Aw8qMHQwZh4XOIZerXn+xZZj3qtzZmqp0+Y82mD4Dl1YJ5sVFsvYnxyB+zBDjOJGs2J9SB8BsFiY0D1uA6LGB/kWNLGhTqIiWITXyRrYFTaFCYVY0Cr+QGO5YFuB/OelVygwSgP+L6r8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 IA1PR11MB7272.namprd11.prod.outlook.com (2603:10b6:208:428::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.16; Fri, 8 Aug 2025 11:06:08 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 11:06:08 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v11 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v11 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcBqotekYTIbhxTUy9DoE44BH2grRWVdGAgAJFhFA=
Date: Fri, 8 Aug 2025 11:06:08 +0000
Message-ID: <DM8PR11MB5750AEA6BA80C8FD857336BFE72FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-6-elena.reshetova@intel.com>
 <819aa3e7857d8213cfbf84356834a5a57eb75074.camel@intel.com>
In-Reply-To: <819aa3e7857d8213cfbf84356834a5a57eb75074.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|IA1PR11MB7272:EE_
x-ms-office365-filtering-correlation-id: 295149e4-068f-4677-d684-08ddd66b93dc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NEEza1RZNEJYUWFFYURlN1l5QVZwUys0T3BCSEdYdG1NeW1RTXJBQWVvZXN1?=
 =?utf-8?B?aER2WHRILytoR1dpQklaL3hmRXFWNXozTmdqSUxNQkFna0d3bWxmbWcwaU16?=
 =?utf-8?B?QjBBRTBreGEwcXRzWVIyOHEyK1gxcThOK041aHhRM2x2MktaelhkcDZnVnpp?=
 =?utf-8?B?dkw0ZldVcXZJWCt6VUhZMmhzWHVaR2xxUWYwM1N1a3NBQWs2QnMrNjV6UWJm?=
 =?utf-8?B?TFJ4SUVaZzQrZEJiQXZhOU9Yc2toa3JiUkIxSG5hRVp6VXVZUEZNRmh5R1cw?=
 =?utf-8?B?MmEyZlFrNkRsQmRTYTJFTVU2OWsvaDAyamF2bHA5U3lFaGFBTHZvY1l6Ykpv?=
 =?utf-8?B?ZStoUEpSZzhjaVhVNHdoY1N0a1BmWkd5VGY4QjdPOElCTCtGc0NRczVmR0d3?=
 =?utf-8?B?aFpraDlKeWpaeEZNdytNSXJwY1ZXRnpNemgxVnkvUHUrSkN2T2lwL1dLam50?=
 =?utf-8?B?eHE1dks5K085UkpJa2QwWHpwUnlrM29aN2FTMTROcGlPNkJmK1VmdGt1YXdy?=
 =?utf-8?B?Z0hWQWxKckpQOVlhWjJaQnIvUGpHa2c0V2oyNnhxTU4vcUN1Nkl5VDlXVEsw?=
 =?utf-8?B?N05sdUNYN2ZKU05pZDZyQWg1Nmx2R1docEJ0KzFHMkdRSkoxcXBveDFsL3Vr?=
 =?utf-8?B?Z01XWWFuZFZEYjBNTUp2UDc4RWJwZG4wb2lyOGFoKzFlYzkxZHRwWFoxWVRw?=
 =?utf-8?B?UDF5NVA1ejNIdjdWWWxXYkl0VWpPQ2JPMmd3Z0dwRnEzdStYS1NSZWVMSjR4?=
 =?utf-8?B?V2RGaGhwTy9MTUR5VFc3R3d5dGVzY3A3UFpDK09ha2xnakJrK2w2KzNSQzdo?=
 =?utf-8?B?ZE9aQURXK1g4TXFtR1NvRTBRd2o3V2dUU1A5eDE2Mzltc0JNYXN3RUxhVVUx?=
 =?utf-8?B?eFdIZlZxbEJHNWQ1RTR3TWI5OXNXNjVONTRZbUpCKzRVQlJiK0RSZ2Mzck9L?=
 =?utf-8?B?N1BDRWJIbnFVTG9Ud1JuTTNjYWJrTDV5YisyZlIyTEdla2lSZm5UQWlCRHNW?=
 =?utf-8?B?MDFBRk5hcFFrR21qdmJidmJYU0hweDdhdzBrakFUNjBSdWtUdjdtM2psK1Zp?=
 =?utf-8?B?ZWd4NFB4SWM4S1pjZHcrYVpTVTVadWIzd0FzS2t4b0taMGlkQmIxYngvU0RE?=
 =?utf-8?B?YXROa0xmYXM5OTFwTVdkdlhsV05Odk43QlhWS2tGdTNMSUl5QldIT3Y5WW80?=
 =?utf-8?B?YktXTGlKMi9LN2VNV3MvczZiZWRVNFBVYUxseCtPWHVibnh2eDh4YXltaW9w?=
 =?utf-8?B?UDZNRlVaVnZjcUhaajBEQU5Dcmd6ZHk3MDRrcGd6TGd0WlhreUdVKzM4Z2sv?=
 =?utf-8?B?ZERxVkJ3NjM3SHVVdHcvWnBuT1lRd3RCNy90VmZXYW9FeEFhQUJGaXJzUGxv?=
 =?utf-8?B?Z1I2TnB3bXR3dW80elFtMnoxMDJGSUI2YWcrRUdoTmNDUmxMbDNlY3lOQUhx?=
 =?utf-8?B?S2hsV0g5NElZcFdybzNvYWtZSzJYYlB0TVlrZFJBbzBlcVhnTVBrcDhSc2tC?=
 =?utf-8?B?RlV6TkJKbnJsM2RWdkZEVW1WVmxZK08zZTE4OUQvdDg2N0NTajBWaHlxWUtJ?=
 =?utf-8?B?ZzFxVUF4ZEFkNnFuWHJBcU9mWFdEU2d4aFZDSStqMFZPM0d6MERSZmUrcUlO?=
 =?utf-8?B?SkNLUnNBQ2g5dUdaakIrc0dLV0FnOFhOVnNLS25VMDZidnFSYkRYakQ4QThw?=
 =?utf-8?B?WE83SHFTMmd2aGQxWGF5ZlVMeHRwV2ViRnFQRG51R2FHQUM3TnNKaEdEMjhQ?=
 =?utf-8?B?YVZIZ3prTXozN1Y2MjczV204eXEwRWQ5d2lrNmFUR09oL2ZuZmQ5dHkrUTcr?=
 =?utf-8?B?bmhYNHdrajBFNmVsTnZiZkc5cWhJd3REbUx1K2xZcG4wM0dMcmlYdUlXWGJR?=
 =?utf-8?B?Mmx3ME4yODJrUmcyQndFVCtSZ3RpTlYwOHFzNmJSSFdSZzdOcVlybUdVRVR4?=
 =?utf-8?B?L2pCZWg4dmgwWGpLU1hVUlc2ellrNFJvSnV5eDZ1V3hjWVhqUjRmbHFJUU13?=
 =?utf-8?B?SFNiWGJDOGx3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YityVWJaUzZ4eVFOODA2UVg3LytFVG95cVE5NVBhYmRiV0VucitjZC9qMjZl?=
 =?utf-8?B?L3UxMmlVWnZSVGZpbHhJSFQxTHNIYmhxeitUVWVMRllYSHM1MVlrR0VoMnZ5?=
 =?utf-8?B?N1d5RWlLTi9uUjQ4cVlWdXdyeHllcEJGZitoRU1aRXhuYVZ5TWhqaE1Qd3dU?=
 =?utf-8?B?aDVmNzMza294cVg0b0xyMjlPTGlCYlNVQ1lDbzFRQitXYzQ0NE5rME5pWXRH?=
 =?utf-8?B?emlHZWF5U0hjSkl0Q0xaQnJqQlFLTnN3NEpXckJROVpVWG16L05oUWZmS0RH?=
 =?utf-8?B?ZEg2RDdiUEloby9Ud3RHVjhiTzN6ZXZFa0ErblAxcXcwN2Y1Sys5dzAzS0Jl?=
 =?utf-8?B?YXNrQTlxWjEyTGgzWlNSRjJ6Y1lrb2RUa3dxZkM4dzkvMFU1Y2c1ZnBnSnVO?=
 =?utf-8?B?K2FnZlpBZFAyVEdDTmI5WUJPZDlkbXhIQjhoN250SVJtOVlpT2JIRHRiT0lP?=
 =?utf-8?B?WCswL28yakVQVkNtU2c5Y3AwdlBZSUhEL2FkRXo3UlpEK3QvajdmNjdaT1la?=
 =?utf-8?B?MUFiZG5JV3lRNTE3SUhuWkpDUmtFWGlFcHY4cFpJNDJCWUZUOXloQUxoOUJz?=
 =?utf-8?B?RHo5cEREbWZ2ZkVBVXB3V1pZTHp4YnkyY3lYeXFSdVJmeXIxOTBjOXpvUUVq?=
 =?utf-8?B?bUprc0xPYlRsM3VMaGVmMEdKTUxTR2pKc1M4QmdmcnhaTFlNamx4QXNYbXV3?=
 =?utf-8?B?bGpJVERaVWR3OWtoWCtmL2tRejV5TTFYNEYycnlvV0NKVmZ2SXZpdzVmYWVJ?=
 =?utf-8?B?dUtZSStBQU5sMklIM2lPT2FManY1NkM2eVBVTjNDaTFuV1VaaEdsWDY5OFQ4?=
 =?utf-8?B?dEhtYnE1b0FSczVHMXhVY21CT045a0ZMbXdYZUdyUTlDYndqNDB4c0lWTXI0?=
 =?utf-8?B?bnBZbFRWVURnSkFBZXJuUXlXZFp5eXFOcHBRTFYyVHZ4QThCSERLdmRwZXpx?=
 =?utf-8?B?aXBPVTRwM2ZjZzEyb1c0eGpTVTgyN29IT1FoQ2NkclJjclRudi9VWG5qcThK?=
 =?utf-8?B?MGhEL2kwZFRtZkxmc3MxanphTlBabWVPSVJXUTRucWtLdU5EaFZ0R1h3ZVJT?=
 =?utf-8?B?dzBvbmJUMm1rcHNRQWFaTHZrRWFsTlZ6UDV6YWJKbmV4NXpvek53N0lzUkg4?=
 =?utf-8?B?bDdPcjNCOFBpZlhiM0tmOTVmeUowOHhkQWdFUlFyZWZDN1N4WW5yV1pjUjB5?=
 =?utf-8?B?K2xFZmtheGoxcnMwY3ZGVlgwT28rSzM4NitjS3BMeWtydFVWZDNNNEQyclow?=
 =?utf-8?B?dytsS1dMVERaRzJWdnZCV0p6a0dKbTE3OXg4bFBGSVZ3K3VhellGYTJhbjBq?=
 =?utf-8?B?aU52K09rWXc3bU41M2VHM21zdkNXendQelBoWVBOWEpLSEI3M2tKZkVPYUtR?=
 =?utf-8?B?SG9ZMUpzYzhiZmRIYS9WTXlBVjh6MlNaaEpIVzRxZVBuVFdPUUxSZnFhMlRD?=
 =?utf-8?B?Q1dKUm53YzFsaGVROEI2SFlVdVpSeEYydHYyTFBSbEh4aDRnQzRjQUdvQW5X?=
 =?utf-8?B?TlVYczhYV2pFcnhYVCtTc09yUzRiVkJUakpITEJNNlNsc0t3L295blJKYkJy?=
 =?utf-8?B?MmpIcEFqaVpmczY2QlVWS0NYaVMzdHNiY2JTbjdtUzhkK1FVdHlYMlpnbGFy?=
 =?utf-8?B?V2pISk5jWkhGVk5rdVE4WHE4Vks0aXQzajdoaHZIbG1vRUZDU2s2bmY3M255?=
 =?utf-8?B?enkrVzE1aEZkcjdkMzlCbHF0NlhtelhjNVN0U3F3TXgrU1B4TlB4Ni9hOTdZ?=
 =?utf-8?B?S0ZiZ0RPZUJ5bWx5N2dEN2hwcTdjWDQwK3VFSWtJWW91VGttMFQ4b1RyUHhJ?=
 =?utf-8?B?QXlMWGV6RTZDOXd6a29FUEwvR0ZoOCtreXZRcGp5N3loYzNZaTJPNE15ZnQy?=
 =?utf-8?B?SFVaUXVZd3ZwZnRCNkVESXpmWEw4bTh4dWtOK2x2ejRHMEMxWWwrYW5nYU1N?=
 =?utf-8?B?eUxmNjVJMnZmcDZuanN0b05sYmxvSzd2R1F0UFdZQUlmMlEvMFRHenM1NUU3?=
 =?utf-8?B?eUJZaVpKcnBzekg3ejIxZzU3T1ZqM1ZERnlYRDRaS2sxNlZ5OGNiaG9YSW1Y?=
 =?utf-8?B?b3NMMkZDN1N4R3hQejhQUmtZR2dYVVRQL1VjVGNvQjVkTHZDdExwRVRUNkdJ?=
 =?utf-8?B?QllNQzBHYmthcTJEWS8reWQ3aVE5MDlkNzZja3QzSWs5U1ZEVDl0R2FqcUdZ?=
 =?utf-8?Q?f3kdU+rzeHZP82aiMErlw7vXLo1AdUcbKH6EZRjeKwge?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 295149e4-068f-4677-d684-08ddd66b93dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 11:06:08.6882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pPT2zo2RYtzwlGHyNbe9BxJan1udhPfZOrxG+CfMTgLOH+7JElqCzknE1v3QZKlyxgu6MwySHu96APAyZ9icRiGwhm6/FRsM+l5ti87Mtwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7272
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCA3LCAyMDI1IDM6MjQg
QU0NCj4gVG86IFJlc2hldG92YSwgRWxlbmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+OyBI
YW5zZW4sIERhdmUNCj4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4NCj4gQ2M6IHNlYW5qY0Bnb29n
bGUuY29tOyBtaW5nb0BrZXJuZWwub3JnOyBTY2FybGF0YSwgVmluY2VudCBSDQo+IDx2aW5jZW50
LnIuc2NhcmxhdGFAaW50ZWwuY29tPjsgeDg2QGtlcm5lbC5vcmc7IGphcmtrb0BrZXJuZWwub3Jn
Ow0KPiBBbm5hcHVydmUsIFZpc2hhbCA8dmFubmFwdXJ2ZUBnb29nbGUuY29tPjsgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZzsNCj4gTWFsbGljaywgQXNpdCBLIDxhc2l0LmsubWFsbGlja0Bp
bnRlbC5jb20+OyBBa3RhcywgRXJkZW0NCj4gPGVyZGVtYWt0YXNAZ29vZ2xlLmNvbT47IENhaSwg
Q2hvbmcgPGNob25nY0Bnb29nbGUuY29tPjsgQm9uZGFyZXZza2EsDQo+IE5hdGFsaWlhIDxib25k
YXJuQGdvb2dsZS5jb20+OyBsaW51eC1zZ3hAdmdlci5rZXJuZWwub3JnOyBSYXlub3IsIFNjb3R0
DQo+IDxzY290dC5yYXlub3JAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxMSA1
LzVdIHg4Ni9zZ3g6IEVuYWJsZSBhdXRvbWF0aWMgU1ZOIHVwZGF0ZXMgZm9yIFNHWA0KPiBlbmNs
YXZlcw0KPiANCj4gT24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjExICswMzAwLCBFbGVuYSBSZXNo
ZXRvdmEgd3JvdGU6DQo+ID4gPT0gQmFja2dyb3VuZCA9PQ0KPiA+DQo+ID4gRU5DTFNbRVVQREFU
RVNWTl0gaXMgYSBuZXcgU0dYIGluc3RydWN0aW9uIFsxXSB3aGljaCBhbGxvd3MgZW5jbGF2ZQ0K
PiA+IGF0dGVzdGF0aW9uIHRvIGluY2x1ZGUgaW5mb3JtYXRpb24gYWJvdXQgdXBkYXRlZCBtaWNy
b2NvZGUgU1ZOIHdpdGhvdXQgYQ0KPiA+IHJlYm9vdC4gQmVmb3JlIGFuIEVVUERBVEVTVk4gb3Bl
cmF0aW9uIGNhbiBiZSBzdWNjZXNzZnVsLCBhbGwgU0dYIG1lbW9yeQ0KPiA+IChha2EuIEVQQykg
bXVzdCBiZSBtYXJrZWQgYXMg4oCcdW51c2Vk4oCdIGluIHRoZSBTR1ggaGFyZHdhcmUgbWV0YWRh
dGENCj4gPiAoYWthLkVQQ00pLiBUaGlzIHJlcXVpcmVtZW50IGVuc3VyZXMgdGhhdCBubyBjb21w
cm9taXNlZCBlbmNsYXZlIGNhbg0KPiA+IHN1cnZpdmUgdGhlIEVVUERBVEVTVk4gcHJvY2VkdXJl
IGFuZCBwcm92aWRlcyBhbiBvcHBvcnR1bml0eSB0byBnZW5lcmF0ZQ0KPiA+IG5ldyBjcnlwdG9n
cmFwaGljIGFzc2V0cy4NCj4gPg0KPiA+ID09IFNvbHV0aW9uID09DQo+ID4NCj4gPiBBdHRlbXB0
IHRvIGV4ZWN1dGUgRU5DTFNbRVVQREFURVNWTl0gZXZlcnkgdGltZSB0aGUgZmlyc3QgZmlsZSBk
ZXNjcmlwdG9yDQo+ID4gaXMgb2J0YWluZWQgdmlhIHNneF8odmVwY18pb3BlbigpLiBJbiB0aGUg
bW9zdCBjb21tb24gY2FzZSB0aGUgbWljcm9jb2RlDQo+ID4gU1ZOIGlzIGFscmVhZHkgdXAtdG8t
ZGF0ZSwgYW5kIHRoZSBvcGVyYXRpb24gc3VjY2VlZHMgd2l0aG91dCB1cGRhdGluZyBTVk4uDQo+
IA0KPiBBIG5ld2xpbmUgaGVyZSB3b3VsZCBiZSBoZWxwZnVsLg0KDQpPSw0KDQo+IA0KPiA+IE5v
dGU6IHdoaWxlIGluIHN1Y2ggY2FzZXMgdGhlIHVuZGVybHlpbmcgQ1JfQkFTRV9LRVkgaXMgcmVn
ZW5yYXRlZCwgaXQgZG9lcw0KPiAJCSAgICAgIF4gY2FzZSwgc2luY2UgaXQncyBqdXN0IG9uZSBj
YXNlLCByaWdodD8NCj4gDQo+IENSX0JBU0VfS0VZIGNvbWVzIG91dCBvZiBibHVlLiAgQW5kIHRo
ZSBvZGQgaXMgdGhlIFNETSBhY3R1YWxseSB1c2VzDQo+IENSX0JBU0VfUEsgQUZBSUNULCBzbyBp
dCBjb3VsZCBicmluZyBzb21lIGNvbmZ1c2lvbi4NCj4gDQo+IFBlcmhhcHMganVzdCAiY3J5cHRv
LWFzc2V0cyIgaW4gZ2VuZXJhbD8NCg0KU3VyZSwgd2lsbCBmaXggYm90aC4gDQoNCj4gDQo+ID4g
bm90IGFmZmVjdCBlbmNsYXZlcycgdmlzaWJsZSBrZXlzIG9idGFpbmVkIHZpYSBFR0VUS0VZIGlu
c3RydWN0aW9uLg0KPiA+DQo+ID4gSWYgaXQgZmFpbHMgd2l0aCBhbnkgb3RoZXIgZXJyb3IgY29k
ZSB0aGFuIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSwgdGhpcw0KPiA+IGlzIGNvbnNpZGVyZWQg
dW5leHBlY3RlZCBhbmQgdGhlICpvcGVuKCkgcmV0dXJucyBhbiBlcnJvci4gVGhpcyBzaG91bGQg
bm90DQo+ID4gaGFwcGVuIGluIHByYWN0aWNlLg0KPiA+DQo+ID4gT24gY29udHJhcnksIFNHWF9J
TlNVRkZJQ0lFTlRfRU5UUk9QWSBtaWdodCBoYXBwZW4gZHVlDQo+ID4gdG8gYSBwcmVzc3VyZSBv
biB0aGUgc3lzdGVtJ3MgRFJORyAoUkRTRUVEKSBhbmQgdGhlcmVmb3JlIHRoZSAqb3BlbigpIGNh
bg0KPiA+IGJlIHNhZmVseSByZXRyaWVkIHRvIGFsbG93IG5vcm1hbCBlbmNsYXZlIG9wZXJhdGlv
bi4NCj4gDQo+IHBsZWFzZSBjaGVjayB0ZXh0IHdyYXAuDQoNClllcywgd2lsbCBkby4gDQoNCg==
