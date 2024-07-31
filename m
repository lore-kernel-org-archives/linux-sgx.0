Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746ED1AE874;
	Wed, 31 Jul 2024 12:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722428436; cv=fail; b=DGyYliRu6u8deHQTYOYm14FNsSS7noR1dwMJ/trSldsZqmy1t8op74T75Z/mjNQvx6iXhGTxaMQxGOHbP4uJ2gKAvxZmJSzchAkAkc6SKFy3g5YOnUFPSESr1sMN4dCboSp7Ovg2MM/Tnw2xZvGJWVnz//THcJz3RmWlMoaAx3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722428436; c=relaxed/simple;
	bh=t6R1uXEDcSR20VOK5Mv+jms26dyy13E7XuNGWwnVym8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JFyoJlbgxMkaDtLTGkMmtYAtLKn7EX2HPrTYFdNIl5DRkep7YuQZCYGI9HL7PFzEr8uaXlRMVyHbltoLhCrVe3zgyTC8B1mGbD4XIWIfciwsMkNQPn28OiPdZX9nez4WPD2TtnwedFooUl75ammtxV4CPEeQjwByZwJ4cInGQbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MaSt6vrQ; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MaSt6vrQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722428434; x=1753964434;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t6R1uXEDcSR20VOK5Mv+jms26dyy13E7XuNGWwnVym8=;
  b=MaSt6vrQMs9MR7fnKN77GmyhYQZZ0ihi7raZ/vLELbcKbUnqgqLkVrcD
   WBMgtsDu43qDqU+Md5b5O2jJ5BsR15n6ELOgW84MTsRwUTpz5YfdiquoC
   hyM0pzaFky/skh5aA6rhY5cxSoHemnuq+3xiaDyN+MZyvZZ6BdGjkc/6l
   2dh5G93oLioDK21SNULt0vA9kpcKZPDuZCNrMuH3q95UE/A9Zvf4QsM2M
   NHdDiKVeEAPE+lMNepS8RE7iTDQ+KfYaoE9F38FlMNIUu9qT40RM4OlLo
   D+K0B++AbSortUdcfDuwlkYPkAwbYpHYjR2AlAsJ8sWqLxx4aBnenEPl1
   g==;
X-CSE-ConnectionGUID: ft21W4+JT5i+ERrXPTYb6Q==
X-CSE-MsgGUID: uDicNYRSQ7mCScuedAszHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11149"; a="19994868"
X-IronPort-AV: E=Sophos;i="6.09,251,1716274800"; 
   d="scan'208";a="19994868"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2024 05:20:33 -0700
X-CSE-ConnectionGUID: yFdvlTSrTom9m/W/+09dXA==
X-CSE-MsgGUID: 9rHhaR1ARlyUijk2NlRaTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,251,1716274800"; 
   d="scan'208";a="54725848"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Jul 2024 05:20:33 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 31 Jul 2024 05:20:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 31 Jul 2024 05:20:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 31 Jul 2024 05:20:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jWSRu/8wWCRmsc4kmPdtyfAhX1Ka9aPAgp4XDBvmCOlIGTfMTGIHWdMrDp3i/oKAgA9xnwuU6UW7Nw0Qtep35c6/AG5Ccbpf+zdu2a8Lx2Ie248D9kv3Xyo4q/rB7hqFhiwPXPlXktuxIV87jE5QNQL+xpyB7TwQ87nvUIdt7OZTYqXi59seZUvMsK5OadV5sFRfYnPbOkZyvQhBrz+UdefnFrx58DoyFJL3ybw3lmkWdHaae3AI9NVl9aBseqizAp/SvXjIrRBCOdG75tGNmDyUDy+OJM/6UvCUVQPY6qJFQlSi0amPEHiGG6KVZoY25BIgheNKQdiny8klWXLYig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6R1uXEDcSR20VOK5Mv+jms26dyy13E7XuNGWwnVym8=;
 b=hFcqJHXi+nULxlko9n+bFq9xizT5/6XDeN8fjscl3diem1iCgD9wnRy+C4eGssdBFql29PlSAX+UJLg55oBqGfZYb0/+6QGtYPWENhmKoHMt1UE6He0z8PWpv/ERPDjrHr1dNpcvkz/ZmKQ6H6jq5ENXbhcsM8fjTkGozNFU9+sVlsayq5GQly4AVUoxgmRIIWx0YQyGckdYmSZCA0vGVxNeXauzRwNED1qbC0OSsc5qh0hDUYOsikpRVCEdjt4xnnTCgeO84Dqf7dlbhCx+Z+/2z9L/UuuiG1mxwj9Qj7kp1tgkWcofcvEd+C6H9uaAzUT/xLkyOEX6lqjGesgTvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5287.namprd11.prod.outlook.com (2603:10b6:208:31b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 31 Jul
 2024 12:20:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7807.026; Wed, 31 Jul 2024
 12:20:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "wangyuli@uniontech.com" <wangyuli@uniontech.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "xiangzelong@uniontech.com" <xiangzelong@uniontech.com>
CC: "baimingcong@uniontech.com" <baimingcong@uniontech.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"guanwentao@uniontech.com" <guanwentao@uniontech.com>,
	"haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
	"wubo@uniontech.com" <wubo@uniontech.com>
Subject: Re: [PATCH] x86/cpufeatures: SGX: Adjust the error message when BIOS
 does not support SGX
Thread-Topic: [PATCH] x86/cpufeatures: SGX: Adjust the error message when BIOS
 does not support SGX
Thread-Index: AQHa4is//1JBM77EBU2dmsGlk3Tz+bIPKv6AgAECZACAAJZTAA==
Date: Wed, 31 Jul 2024 12:20:29 +0000
Message-ID: <a30f7700c7817b3e7e2f2bdb37d5c10a318b2c3b.camel@intel.com>
References: <D345627B0A699F37+20240730024931.1026933-1-wangyuli@uniontech.com>
	 <a56bc12f6c60107c935db31d7330d28980ac4d5a.camel@intel.com>
	 <4453C8E00ABF5220+5cc48da4-637f-437f-abc8-5183399fc414@uniontech.com>
In-Reply-To: <4453C8E00ABF5220+5cc48da4-637f-437f-abc8-5183399fc414@uniontech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5287:EE_
x-ms-office365-filtering-correlation-id: f9e3e195-e8cd-4426-ea88-08dcb15b2a8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NW92RDIvUFZKRkFVN3ZDbk1JWjdleVNPVjliMG9pa2wvZW9qVWRheFkzdElC?=
 =?utf-8?B?UGpvNjRZYkFOM3hoYVBiNENQblhqcVVRbkNHejBCZzh1M3BmcFh4alFkV1BF?=
 =?utf-8?B?S00yYzMzMVJGRUIyaXlmQ2FONjlzZnhkdDhwODY3eEVYU2JCUndsUTR3bHVq?=
 =?utf-8?B?ZEluem80Vm5aR2RKb3c0N0UvK05NdUtoa1lmUytxZHJ4SkROUXRtd3FQWE92?=
 =?utf-8?B?UkRWSkRQeHFWVXNPYnZPSFc5V01mdVJrekg5YmtHV3YvV2hlM3R3ZWM3K3p5?=
 =?utf-8?B?aHlJdGJXenRiT09zU01rQkJuVVM0Q2lweE5OVytzUjBlUVY2bzZYdnZvL0Z0?=
 =?utf-8?B?RVZYUjM0M3ZxUzhuMkNoU21VR2F6YUVUSG1IS3JRUWhZc29NMTI0ZnZqUG9E?=
 =?utf-8?B?N1pxNWJvT21VdS9NWVNqbUZUZGZ2MGVUV0FxbG5JaXoxd21yVHhoQVZzbGVV?=
 =?utf-8?B?R1J6YUxteHp2RGFnaGhIdS84d005UnFDT0hPT3Q2V0FOVEp6dWNtRUdhells?=
 =?utf-8?B?azFTT2RQODN4cS9ya2F6SjNlWHR3V3VhZWVxWmJ0bnU3NDg4SWdaMlFrT1NU?=
 =?utf-8?B?NGt0WmMwQTI4dmhjTlYrTXdYQ21JOHRUd0kxTmIvMDJSNk1SSzJlelVKbDNC?=
 =?utf-8?B?SUE4R2kxbStMNTlzeTRBUENvQ3Q0U3VuS0ttMjBEMzdYMHovaTUxUjJVdG5r?=
 =?utf-8?B?ZlVBS0dFaFJZYWtIL1YxRUhNUklKS0l5blpSS0krdFdtVzV4SEJFV2ptK2Jq?=
 =?utf-8?B?VzZLalBoOUphTk12TXowQng5Syt4SnRqd091SmtubWtqN3hvYlllT2o5RnZY?=
 =?utf-8?B?M05BSFRGVWJ0Zk1lK2l6WUZGY0ViTnVBa0NMTVZSbHd6TlJFWjVnR0dwN2Ja?=
 =?utf-8?B?UHhtVkZ1T2JhbXplV28wYkE5ZTB2NE5WQUQxY2R4allXK1hQUDgyY1g2bjRE?=
 =?utf-8?B?ZGkvOGNzaHNwNTlydjRKVEpaSTZHRy9jL3hDY2krWW9qNzdSdlhTaHQ1RDFw?=
 =?utf-8?B?RFc2MnhWcktrVEZmcGlVMUJNcmU5V29NcU5DckdhclFLbkpjN3J4SFFTdDc3?=
 =?utf-8?B?V3Q4bmZDaUtkazViRXJlUnNXMm1rZEdUYnRuVVczZHlsRlpwOVVIRGptMVJQ?=
 =?utf-8?B?S1I1KzZyelJsNlR3M243K1lkVXp6TVQ0WDFvQUNGcWxkUjQrM1p0TGFPUitD?=
 =?utf-8?B?OXNMYjFibWNBRUFpS0x0dGxNR3p2VkpKc2dVa0RYU3d2ZDE3VW15UGl0Qll5?=
 =?utf-8?B?WlQ3cTVVUEdDM0c4eEEwNkFpTVlvODN1MmxxZ200OHA4OGJGYW9nVzdjNnNZ?=
 =?utf-8?B?VnRxeVY3Q2w1b3pPS05IVTdjUVR2MkZqUXRPY2NmZXp2dEpXbDdLUUdyWXZ2?=
 =?utf-8?B?SlpOUUoxeW1CcWxyVlV4cis5UHBCRzk2YUpvaUptbEt5c2xuOExQV2phd05J?=
 =?utf-8?B?UWN0V1JtUEM2U1NnTTFoNlMvM2w2aUJLeDhLcGRWUDBTc09sQnB3VHU0VFl0?=
 =?utf-8?B?WU5Xb2xzQjlFSnduZGMzWEdQK0Q1Tm9tcmVjSjBrOEJtR2I4SVlHaURxUVRn?=
 =?utf-8?B?bGYvU1NrVDR3VlJpUUNXRW9iL3FRWnNZTDQ5WXdQc2dMampTckJTMkhIaU1x?=
 =?utf-8?B?eFhnY1U4L3VvenBUSDQ1R2ZMUktkdE1La21SeHFSQmFrbkhNUUZPMFBzWDZx?=
 =?utf-8?B?UHhRODZKRnNiWW4rSmdCT1hZOGJ5YmlMb2oydnhmY2sxMXBaem4yUytxQW5V?=
 =?utf-8?B?YXpkTXNKbkdSNG53ZFRtL2JyczQ4bDBKSDZ1UE5NMzBGNDRLVmhzeXMrcElQ?=
 =?utf-8?Q?rgi7gmYZMFoHZ0y6fBjR22QlleLdpuaPcy/O0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUdQRGN4MU5rVFI2M25TamJONVltUVpOOXZGMFN1OFpOalU0ZS8rTFh4bDhP?=
 =?utf-8?B?YzNDMDBlODduNUVKNTJZZDdyZ3paUkFiNXA0VFpSODBZaytLdTAzMjZzbkJk?=
 =?utf-8?B?K0xjZ3lLa045NU5MWHRtRFBjWmxBMDR5TnBEejZvSFNBTFZ1cFg2RnBSU0xQ?=
 =?utf-8?B?M01hRmhnZ1ZRQi9ITUJZQVF4QThkT2tqUzFMWFpjYXd4UGVsTkVySkl4dFlu?=
 =?utf-8?B?YVNnSUFUcnlyOGVHckpZNHdxeFVxTHBuVmJKUFo0NlpSK2MxcDZBbWpleU5t?=
 =?utf-8?B?WmRtc3laWFllR0FkSDRqcHNvaFV6VXFhSXM5cDRDNDhDRVhpSmpEOVV0ODlp?=
 =?utf-8?B?N1dvQ3pwM1JDcnMxMUw4UkRHQysrU0NpK1J1NlVVVk5yajJmeWhST0VDVzhu?=
 =?utf-8?B?WlUrdStnK29CdnYyNFhINzY3dUUvSU55Y0hFQ0JXd1RITmNxbEN2Q1R2RUMw?=
 =?utf-8?B?bEo1QnFMeWhBb2FuNERBU3dhbVhmTWZXb1NoYWxpMG5aMFpFdG5ka0dUUXVR?=
 =?utf-8?B?b3oxc1FDSE95Y3dHVHo5dEdjZUpWUzhOQ3J2NUVqSW9TMVJjZWRtRVJuM0FX?=
 =?utf-8?B?S2pKLzZ4WWlYeVA5N2paWnI4b1ZSay83RDFMZGFyQi9jTk9yN1ZzZTQ1WlFB?=
 =?utf-8?B?a2dyUlhqVEEwMFg0eU90Yzh1cFFna2QzbW4wdXFHV2pxdFNad3hWbW5SZnND?=
 =?utf-8?B?VWNwVEltYlpNOGpzbnRic3M5d3J3K1Nxa3hXWEVGSGVVdS91aHFZcnVjVTdJ?=
 =?utf-8?B?OXd6WTIybW1TdkEvWFBqRHdwTmM5aEtiNEhzcjRsWEY5bUZJMVB5YnJGUGVx?=
 =?utf-8?B?cjVzL2pXNWVoOXFSWVE1Y3pvY2NXOTRCamFZWnFJbngzSDJGYXpVSWpTOWdH?=
 =?utf-8?B?Zm81UnhsYjRwQ2I4RHI1UGZPbUJodGQ3dmh4dkNsYTN0ZldZU0k2S1o1QUEw?=
 =?utf-8?B?aGtiNGpJQVlLMVVlZ2tKS1YrSjdJcVBUZXQ5WWJHWk80VVRKOTlwNmR3YVRj?=
 =?utf-8?B?ejN6cXp4Y1FEdGVJYVZ1em9EUUFEZzYwcE1hYm5UZWFwZnZYYmpHUmhSNHFW?=
 =?utf-8?B?dUduSnNqbytOYnpINW1DTGlrZFlub1VpSGlVM3pkVEZaTEg1aVVaRzhpaE90?=
 =?utf-8?B?ZHdRMFZkSGU0Kzg4N3g1dTBZNWJEemVLYXpURHc4UHBOSENtK1NyeSs1Q2JD?=
 =?utf-8?B?VU41MnM2akFINjVRN0tOR2dZSlNNM0NTdWJYOUd5VlJ1WVlGb3h0M1hRVFVR?=
 =?utf-8?B?dWtSc0Q0RWY1ODBnT1k5L0ZvNGwxZU16cGQ1TmtUR01Pam1OS2UvTjdOS25J?=
 =?utf-8?B?WWZRY0RFNmppeEd0Mm1rNlVxc2RVdmZVUWxvOFo1dHBxZ3VidmkwWWVEM3U1?=
 =?utf-8?B?U3hNSjFnTkZUcU0rZGwzQU50SGVRbC9FdHFwMG14Zjd0OU9zM2JvUmF5Z3Bu?=
 =?utf-8?B?TUlZdWFzK04zeGoxYkZYZzZLcVdWOXNVSElJQkJhZkoxcXV2QTdEeFI5M0pL?=
 =?utf-8?B?bi9ydG9zbDUzLzIrc3NyQnZYMm1kQ21Oa0E1aXBITUFxekNrcVRzZ0xzbEpS?=
 =?utf-8?B?Q2RRUEZLc2s1Nnc1MmJWK2lKcXd0bk5KTHRLTjN0TFZHajNPaVlNVU1nVEtZ?=
 =?utf-8?B?ZVBzMjliRUJHYmN0U3NLQzVhOXJkYzYxaWtqZzZ6L1p5SWxUNGlyTjhvMnRW?=
 =?utf-8?B?RGd2NGJyUDd2djVrdWFjeTU2WDFib0s1SzYzUG1Ha1l3a1VibjFjckhDR0t4?=
 =?utf-8?B?eVBKTHJtMUVPT1EvcVQrU1Y2d1drVU5mYnVDVGhHRzVmcmJFbE9yVXRNeUpJ?=
 =?utf-8?B?OU5hUzh0d08rN3pJZ3h4SjZrRUxtTXpZRDZGYlAwcFR4eXVaVW1SNFJoRCth?=
 =?utf-8?B?TTlxVXdVS3RUU2dSWmlmQ0VsNUgxby9ucEovUVdXVEUvYy9tWW9wR2FNM1Ni?=
 =?utf-8?B?bWc1U2xHSTF1UWFLVkdXMGF1ak84WFhFY2FJemM0VHNkdGkxVlIvclZ1aVkx?=
 =?utf-8?B?dXpmeWZjN09TMlYrNmZ1Q1B5MkpTYTFEb0Q3ak1CdGMyci93M1NIeWhiU0Ir?=
 =?utf-8?B?Tld0L3pnSUc1Z1I0Q2dkYUtBWjhCSk9jQWJyQk1oMFNnaFdNclNhNE1yMy9t?=
 =?utf-8?Q?EMLRvdX+B1hpluE1gDX0dYpfa?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E2D8C3AF5ADCA459E43C387FA1D0679@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e3e195-e8cd-4426-ea88-08dcb15b2a8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2024 12:20:29.3910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d4mxpncnqtf6OQOD0r+8DJMno0QOyuuENpUNNI1ARODW2Ga4JxhCCgPuu1TGFp0yZuZkDkfWF5osQh12thr98Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5287
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA3LTMxIGF0IDExOjIyICswODAwLCBXYW5nWXVsaSB3cm90ZToNCj4gT24g
MjAyNC83LzMwIDE5OjU3LCBIdWFuZywgS2FpIHdyb3RlOg0KPiANCj4gPiArbGludXgtc2d4IGxp
c3QsIEphcmtrbywgSGFpdGFvLg0KPiA+IA0KPiA+IFRoaXMgbWVzc2FnZSBpcyBvbmx5IHByaW50
ZWQgd2hlbiBTR1ggaXMgcmVwb3J0ZWQgaW4gQ1BVSUQgYnV0IGlzIG5vdA0KPiA+IGVuYWJsZWQg
aW4gdGhlIEZFQVRfQ1RMIE1TUi4gIEkgY2FuIG9ubHkgcmVjYWxsIHRoaXMgY2FuIGhhcHBlbiB3
aGVuIHRoZQ0KPiA+IEJJT1MgYWN0dWFsbHkgcHJvdmlkZXMgYW4gb3B0aW9uIGZvciB0aGUgdXNl
ciB0byB0dXJuIG9uL29mZiBTR1gsIGluDQo+ID4gd2hpY2ggY2FzZSB0aGUgY3VycmVudCBtZXNz
YWdlIGlzIGNvcnJlY3QuDQo+ID4gDQo+ID4gSSBjb3VsZCBiZSB3cm9uZywgYnV0IEkgZG9uJ3Qg
cmVjYWxsIEkgaGF2ZSBtZXQgYW55IG1hY2hpbmUgdGhhdCBkb2Vzbid0DQo+ID4gaGF2ZSBhbnkg
U0dYIG9wdGlvbiBpbiB0aGUgQklPUyBidXQgc3RpbGwgcmVwb3J0cyBTR1ggaW4gdGhlIENQVUlE
LiAgQ2FuDQo+ID4geW91IGNvbmZpcm0gdGhpcyBpcyB0aGUgY2FzZT8NCj4gDQo+IFN1cmUuDQo+
IA0KPiBGb3IgZXhhbXBsZSwgTGVub3ZvIFRoaW5rUGFkIFQ0ODBzIHRoYXQgY29tcGxpYW5jZSBp
ZCBpcyBUUDAwMDkyQS4NCj4gDQo+IA0KDQpGYWlyIGVub3VnaC4gIEkgZ3Vlc3MgdGhlIHVwZGF0
ZWQgbWVzc2FnZSBpcyBzbGlnaHRseSBiZXR0ZXI6DQoNCkFja2VkLWJ5OiBLYWkgSHVhbmcgPGth
aS5odWFuZ0BpbnRlbC5jb20+DQoNCkJ0dywgSSB0aGluayB0aGVyZSBhcmUgc29tZSBpc3N1ZXMg
aW4gdGhlIHBhdGNoIHRpdGxlL2NoYW5nZWxvZy4gIFBsZWFzZQ0KZml4IHRoZW0uDQoNCkUuZy4s
IEkgdGhpbmsgdGhlIGZvcm1hdCBvZiBwYXRjaCB0aXRsZSBzaG91bGQgYmU6DQoNCgl4ODYvY3B1
OiAuLi4NCg0KSW4gdGhlIGNoYW5nZWxvZyBwbGVhc2UgYXZvaWQgdXNpbmcgIndlIiwgYW5kIHBs
ZWFzZSB1c2UgaW1wZXJhdGl2ZSBtb2RlDQp0byBkZXNjcmliZSB0aGUgY2hhbmdlLiAgTW9yZSBp
bmZvcm1hdGlvbiBwbGVhc2Ugc2VlOiANCg0KaHR0cHM6Ly9kb2NzLmtlcm5lbC5vcmcvcHJvY2Vz
cy9tYWludGFpbmVyLXRpcC5odG1sDQo=
