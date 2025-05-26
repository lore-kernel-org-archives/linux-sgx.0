Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DF91EA7DF;
	Mon, 26 May 2025 11:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748257780; cv=fail; b=DDx50fyGSqvUNwdHgnGcm14mufykkhlcwREQRKGT6MWE2C6M/6DKs9ENPd9Lo/s3e7LnyD75tyqwf5ztrgHw6zXBe43CWK6Fetjj2741pQMgQgALO+WtWYjIcr/KxN7nGcbyQVCUSUfwqx1lSBn30m/5gNgudh4VVvtxTg8+8to=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748257780; c=relaxed/simple;
	bh=ZYKMo9DoXOWiaubfapYYGnfYs/oyzkPe72R2ksvFops=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kt7i7RnCn+5WThks8LF3uPdfkWipJpRYGeuGDJAlm44JeOzQG8jUUTyX7Fq7kan3R0SQ1Ov+scfiWtOA22MW4QUBEVJqKgYDB0o8DkvCMQEfsYP47NL9frZGU5mROnXstMdYBYpB2j78wTVKYbGcIsMRNa8rdlUczgF3ukanyMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WjlbsgO9; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WjlbsgO9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748257779; x=1779793779;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZYKMo9DoXOWiaubfapYYGnfYs/oyzkPe72R2ksvFops=;
  b=WjlbsgO9wTw1qm2CNdgJEiG1gp6Pg4LOqrFXVqwAAIS6Ya9WTIeYZuFT
   RA93xlRciuq1GU9mcMNzLZvFjt427D6A1t2G+xLo9Tex3IaQYaJtH35B7
   D11YgXI1D3Edym+w2gQoXCw4wNeBIbwosQbRSpodrelcC/tbh+1SlFkqT
   ZkgXmxU/cQuqkdjSQqEQMpBw/VJ/2CeTSSPZ7lZGESsojJILEGBzMNyo6
   BI0GMldJ80qKiKzfucIf8hpISXHSBNqlA3piijsXhJLD6hf5SefMlwics
   IsK+GPiymBUAXlk6IC3Mhdj93+v5+r/PFn//TeCd91w4l/A/7uT17SnLh
   g==;
X-CSE-ConnectionGUID: Ak/lPM8MRmCIrxyjJ8H5xA==
X-CSE-MsgGUID: X2wzzLmPQvywPxl8um+b7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11444"; a="53884213"
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="53884213"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 04:09:39 -0700
X-CSE-ConnectionGUID: 541SuDnwRlCtZeswZZ6l5A==
X-CSE-MsgGUID: zKKY0q2UQC66e3X5I7EvOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="142241534"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 04:09:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 04:09:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 04:09:38 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.81)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 04:09:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpkRSuv1+IHHs97ut/TSt0Ad1Y7wgM6q3Fv/YNF6Pb6SmjbLDFqk0CyAKHmJqqn//XnWr81Sd+1a3q6PA/7bqBDrv+E5D8oDgzVTNlOrPODISShXrB+ZYv1i6HbD6U1NBub7KMYM9MExPDcfgwtdIQRT4OYSrGj0PXJgEsECPuaFodRuVCRqGOtzxIa4n0n9Az0X9/5gUC1jEcNGoIMM+Vh/kOn/R5c5LOUtcDcvxQ4d8pwuG8BqHhBaOZsDN+YLKDzUjKxPPxqISdmAxzGTBdg59qwXlW1FQH8+xOqtD5EVYvA+IMlF7G9Uat/7ism1IXFtIpz+5dEUSTcfLwwPug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYKMo9DoXOWiaubfapYYGnfYs/oyzkPe72R2ksvFops=;
 b=JLzRC9yCBnS5fR9M1GKiyzcpgT2iYxhP+b/8zjXdyySYtn41POai4TPjVEPzxIxapfrHntQLXrkQg4DSyZM8xlL75ufWaSngBSGwDIqPJZBX1mwvybGVUTMHZQPAOiHy66tGDZto8TrozThxPEW8Lcc7Es7aABhNkAcdIbP52+siKG/9h+HE5qHpSvUWpmf0SE7CVQ/DeInSmMzcceznyhbWFKWkpWO43dEttGG7ZEiF1lIYh2B609f+WIRJrzl/UEwZVrWyhIo5eEDhYBFJhF/PxgCpSiSyCUMxTTHrgT8ViBW/jH1EV9q0BoKgYC8ZD0slS++ZEqudGGXViZ6x3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 IA4PR11MB9034.namprd11.prod.outlook.com (2603:10b6:208:567::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Mon, 26 May
 2025 11:09:32 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%5]) with mapi id 15.20.8769.025; Mon, 26 May 2025
 11:09:31 +0000
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
Subject: RE: [PATCH v6 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v6 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHbyvstsbmOCooYLUOhDTxRMjMaVrPgYOKAgARkMyA=
Date: Mon, 26 May 2025 11:09:31 +0000
Message-ID: <DM8PR11MB575031F880D9B79D2A1D797EE765A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
 <20250522092237.7895-5-elena.reshetova@intel.com>
 <aDCa-U8buhyjIygO@kernel.org>
In-Reply-To: <aDCa-U8buhyjIygO@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|IA4PR11MB9034:EE_
x-ms-office365-filtering-correlation-id: ace5b309-7b3a-47f2-1cca-08dd9c45ca21
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VWtBaEhBY1U1bVZ0VUhxWVBaVUhmSnpvWS8rOFR4dms1MHg1dGwwVzVpTVR6?=
 =?utf-8?B?SDN1bmVkblZBVnBLK1VhRWl6RUc5dzZsREFUck9kbFRPT3lvOXlyOUt2ZEd6?=
 =?utf-8?B?TzFsK0hLRjFzdGR6dU9ta3FyVVIxdlRMakhlenFCcTRicjVjclpyN3ZWL0tR?=
 =?utf-8?B?UStMRXZ1UXBKRUE4NS9yLzVSU1ljOVBsMXYwVVVadzNtMFRrNThKK094MU05?=
 =?utf-8?B?S2JaNkVlc0ZPa1pWdlVuNldHejEvSVRPckJzaWNIbXZCc29Cb3NOVWRZQVQx?=
 =?utf-8?B?ZFB2NVRsZnBJM1AvQXdjTFdBdXUxSmwvaENWNnkwcG5mcko0Y2MwMGpZbkw1?=
 =?utf-8?B?YUpEWURqb3RvZFZiR0huYUhFNXZmZHVUbDgyQXlIZjJ3S0JmZWFnS2tNZVNE?=
 =?utf-8?B?QVhTc1FabGIwNEQ2VUhwRENwZkZ3MlNaTTA2b0lTLzlYVDV0VHdMc3pxc3N3?=
 =?utf-8?B?WlgyWkowdm9WVjQ3NjBHNS90QUV6cU5RQThUb2FrUzJJWVZocVVtcC9oT3Uy?=
 =?utf-8?B?UzA2NENTMGVrNTNESUd2dWdJM3lVbzJHdzJhcWtMUFhiTGJFbHBDL09UUU1r?=
 =?utf-8?B?dzhqY3NUQmhDSVNPQVBwYmZSdVQ3NUxiN3JwM0RCQmdGaThuaWJZTmNjRGFJ?=
 =?utf-8?B?Y3pDMzdWM1hESGJGbHBTYUhmcXdvYUFLc21Sa0ZjVk94bmFQZGJDS0dMMkRR?=
 =?utf-8?B?c1F0V1k5bmhjOW15SDM0UkhhUXRiaFhJSVN0OHY1dTFvcGtoTFkwYUpsUkdG?=
 =?utf-8?B?OXNXaWQyckRBUmIwT0MycTVab1pPbU9rVjd6SjZqNzYvQTd4S1R2U2E4anBH?=
 =?utf-8?B?TGM4WnlubXI5TlNHa25VVWs2ZkQ2SmF1NU14cnNtN2FFVFdDWUJIV1J4cENs?=
 =?utf-8?B?L3BySjNBYjFTdkhqanJ5VW1oU1Rkb3IvaHU5djN6K0hLdUIzbmxqeVllNlJz?=
 =?utf-8?B?U0MwbVNJRUV5eUVNTHJmR08zcmZ5Q3JXWngyZkNvaC91b1JXR1pxU0laaytz?=
 =?utf-8?B?Ymk4RytXNXk5aHdidU1DTVhwRFF1aUptcU1NQUgvN0UrNFh6dmJsMWZ2aEdS?=
 =?utf-8?B?WHJSYm9TbUthelFxUkJuS01kOVNTS2NWMTJ1cTVLd0Q4Qno2Sk9wZlNxR2hU?=
 =?utf-8?B?SVBrVDFQbm5RZTlZaUVuTVRDUFJvNGplNGd6WFhmVlFoTWRWWHlZM1J4OHJl?=
 =?utf-8?B?ejgwVXBHd1htKzhKV2IwRXJKbk5pY2VIemNsZDE2S1VqNjZBeFFIQWM5L2JR?=
 =?utf-8?B?VllFMXpTcG1GdElhQW8rOVNZTEVlZ0laelNubDBoR0k5cDhXNVBiaUo0R2NG?=
 =?utf-8?B?UW93K0NUUXlSYnoySXNoOHBiaVFPM0ZzWXRsN3lyZTJCZ0UxOEQwZk1aVHZ2?=
 =?utf-8?B?dzlmd0g2SnJLYVgvbGVhSGNJV2FqVmQ0QjJzdGZzZmpJa2c1dXZKZnZQQ2tS?=
 =?utf-8?B?ZVBxZUtMa0t4VktLZ0s1VVYzeEh2VlB2aTJGMFh4bXVobkZqRXZkNjhkaHNa?=
 =?utf-8?B?T3Uwb3pvaEd2MkZKZ253T0tKWXoxSkNYck9PajN0R3hMSi85Tnh3YmRoT3Ur?=
 =?utf-8?B?UzhVeG1Ea0djYlFqNXRDVkVzVGRWTXI5VExWYjNaMFJWR0Y2aGZ2SFhRNlk3?=
 =?utf-8?B?aGF2cHp2QkkvQTMrZkUvUnIwU2gxZms5K240bms3bXdxeHdlWStpZEhoQ1RP?=
 =?utf-8?B?Wk9hRTdzZVk5RmpnRmMvUWNybVB4bWZCSzYwQzdybFJQa2tyRisxTmFqcWpZ?=
 =?utf-8?B?dlNtSWpRbEFOdGh6d1ZTc3ZzSGtCWFMxS3Yyd3BLQUVGODA5cTNtejlsRDZB?=
 =?utf-8?B?dWdqNlB2R3ZDTTE1YTRvdW11bnFWSUJPNFo1TVBBMlFHOWZXdXBjczN0MUl6?=
 =?utf-8?B?QVhJTXdHZTQyN0I0U0U5cU44aGthUG1tWUpaQXh3cng5a0xjcWNhUThHZVJE?=
 =?utf-8?B?YmR5ZnRiZkd2VUNjT3FWcXlzazRVY0dhZ09sNWRleXNldDFrQkpXWlFpQ0lZ?=
 =?utf-8?Q?JJluQCrek8bwaStjrwHwMyhYbe7TFQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGFJZmMrVk9teTByemJsQnFuWjh5QkJBOG9WRTdhZG0zanlmcnpZZzlWR0F5?=
 =?utf-8?B?dGxteVZwMkh5cDlQZVNBWE0rZllsMitYdjhIMEVNMzFoeUtmclJ5L1orSU5w?=
 =?utf-8?B?ZVYybnFiWHlGeCtwbGk5WFZIa2w1UHJEcDl5UWRHazluYm1RWW91VHNsUG9D?=
 =?utf-8?B?NDhFbko5YlczeTlPYUVyak55S2srbTA5cjcxNDRHeWEvMzd6VFAzQWIvVDRD?=
 =?utf-8?B?MGZ0LzVsOEE1NElQT3JwV1ZUK0dzdElpTThPWFlnRjdiU2lhSXlUWUN5OWxQ?=
 =?utf-8?B?bWZ0ZzVReS91Z1VuZlJjMXBubGxRVnN0MFdENzlxSVREQlcrYXVqSUZrUXN1?=
 =?utf-8?B?VTlhbnBTOG8zRGZvc1FleHdxMnFualdWUVBGTFY0UEhWRjNjdXRnb2VhTmpI?=
 =?utf-8?B?NGYzWFJFQXQ1THRDVmR3aUpnQWRiMVNzTHZTUjBGTndQVHpIVXgyRmc4Qytm?=
 =?utf-8?B?N1VLWHNaWjQvRklVUVU3ek53MEtOVld2NHgzY1lRaHV2L0l1YnhpZnprbkx0?=
 =?utf-8?B?a1ZSWG9BMkNiR2tPdVMxU1d6cVJodkZxK1pSK3NaRWtUZGdSY21CdTRzWi85?=
 =?utf-8?B?dDRUUW1UTUFNR0tuaUptUEdaK3hPN3VPbkFqZ3NEYkh1L0ZwelB1V3hDcEIz?=
 =?utf-8?B?cTI0RUJzek1zWWR3b01XQ2cvbThUd2JNYUtWSjZlankxVlA1SnlMaHVJdkRN?=
 =?utf-8?B?YjBTN1JlRHJPaWR3Tm1RdkV3eHVRekhxVHJLbHMzblBxZUxIVnlhcW81bzJ3?=
 =?utf-8?B?NDczU2pOZTZWMVh5RzFCNXZjYkZ4NnJJQ2NZbHFPZ1BnbmFmWE5BN2VTa2Jo?=
 =?utf-8?B?Mjcrb1VPNzBSeUZKMnM2Z0YrWXhMMlNpK3JmVFc5OXh3MzBJLzdDYTNMNmFI?=
 =?utf-8?B?bldibmtkUG8zcWJIaGREQUw5RFM5Zy9hUXdldkYvanZadnVSZGZqRWl3S1Zn?=
 =?utf-8?B?RnhjRzkvQTdMM1RUcEVLVWh4MDdhbmw5b20vNmtvOE1pUVJCdHJPQUo1dUZw?=
 =?utf-8?B?VU0xVStsWk1xS1Y2SDN5a0x4RXRBbEVlazZGU1g4R293RHdzUmN3YnM1cG1a?=
 =?utf-8?B?dFRYb0xwckVZR3VhU0RJNDlWUHFIRFdmYUlIWTZQOC9SWHRnVmg1dWJ1dHFT?=
 =?utf-8?B?MTY1MVlNRnpkRElxS3VZUENydTNicHBFVmtwUXJMRFZXMy90ZTRFRmcvckpB?=
 =?utf-8?B?NUxUZkpzSHRncVJxNk5WeFhJb3owaVdMbmpoaWxYY0xvZTR3QWJyZi9BaHdD?=
 =?utf-8?B?Skg1QzJBbElDaW1YY2RBbk4wZlFxRnpPNWEwc2hrWGc2UGxNejVPR2RiN0F6?=
 =?utf-8?B?VWNCZFhpcEVZRkxvK0ZjaW9xT2REem1naExxaGJxaEY4UWJzQlRsNHB0eU9a?=
 =?utf-8?B?eTJ1U3FJLzlOZlNLWVlBL3ZyYWVqRW5ESGwzZy81SnZFVS9ZbmFMbG11NVVw?=
 =?utf-8?B?ZlZXNEt2WGhHZVpIVVM2b1NnOHRxVVNPc2UzZFlwQmYxaVZtZ2VTZEZ4aGNU?=
 =?utf-8?B?bm1JaGJ0YnFJUjVodi9qNFdHT3EvWWtLZDQ2VmRwOHhMY1pVRlZHZUhMcnZw?=
 =?utf-8?B?YTAwSXZ6RURzbkdPVndwZFlITldXRTRIdHRJL1EvS25sWFVOeTEzb2YycFJW?=
 =?utf-8?B?U2RpaFoxa0xMVVVhT1BqdHc5cDhWMkg0MEljQk1DZWx4UkZjVjlSSGNDeEo4?=
 =?utf-8?B?QTBtVlpoem1DQ2xvM0ZkTHYyYWxtT1hjT0ZNL0MwUGpQdDZIc3lQM2h4c0p1?=
 =?utf-8?B?bmNLQ2VqZTJ3dVF3cHNWbFRTMWlsYmh2eVVjaGNpNEloLzgwK0JVd2N3bURR?=
 =?utf-8?B?bXpuS0dJbXZWUHJUMHFHbjdkVVBUcGpvYkVUTFVMRFJ5QXYxYklIb1FzaEU2?=
 =?utf-8?B?UUdqZ1NOUzdSRzhqZzZjZHYvSit6RHRoQ25UTFNWaUdQUVhEK0gyd3daUDJE?=
 =?utf-8?B?TEJOWU1BVVRxYXdCb3ZwdTQ5TWhvOEtZYjlkckU0dkJYOTE2bGlFYTVONWNF?=
 =?utf-8?B?Q2sxbEVFRkNJVzNLQW9CQXNqcE4vQ2tyL2E0OHpndERUYWZSK1VucC9JOEQy?=
 =?utf-8?B?REdIODV5SWNrMHlscE9DeFNCOHRuZy9RNUliQ0wwRm4xWFMvQmdTNU9BM2tW?=
 =?utf-8?B?S05jQjhUUEFybG5FMi9aT0N5RG9DbFdLZjRuZzFlSkZCMEovUlRjTE1GcXBy?=
 =?utf-8?Q?EbvDrbB6kSaRXsiTAHr7qMr81wJ8pjHFnjw29zOWKZCs?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ace5b309-7b3a-47f2-1cca-08dd9c45ca21
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2025 11:09:31.3851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Pa7T0XbSyNaDobwb+6P2wT8wd1Se8Do9Nn3d9XsA+WQcw10dUJQfh69bRfis5Hq3P35cC2Y+vfmL4lJtmquIPxZNqwiB1iAOYrNLcmor38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9034
X-OriginatorOrg: intel.com

PiA+ICsJLyoNCj4gPiArCSAqIFNWTiB3YXMgYWxyZWFkeSB1cC10by1kYXRlLiBUaGlzIGlzIHRo
ZSBtb3N0DQo+ID4gKwkgKiBjb21tb24gY2FzZS4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKHJldCA9
PSBTR1hfTk9fVVBEQVRFKQ0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4g
KwkgKiBTVk4gdXBkYXRlIGZhaWxlZCBkdWUgdG8gbGFjayBvZiBlbnRyb3B5IGluIERSTkcuDQo+
ID4gKwkgKiBJbmRpY2F0ZSB0byB1c2Vyc3BhY2UgdGhhdCBpdCBzaG91bGQgcmV0cnkuDQo+ID4g
KwkgKi8NCj4gPiArCWlmIChyZXQgPT0gU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZKQ0KPiA+ICsJ
CXJldHVybiAtRUFHQUlOOw0KPiA+ICsNCj4gPiArCWlmICghcmV0KSB7DQo+ID4gKwkJLyoNCj4g
PiArCQkgKiBTVk4gc3VjY2Vzc2Z1bGx5IHVwZGF0ZWQuDQo+ID4gKwkJICogTGV0IHVzZXJzIGtu
b3cgd2hlbiB0aGUgdXBkYXRlIHdhcyBzdWNjZXNzZnVsLg0KPiA+ICsJCSAqLw0KPiA+ICsJCXBy
X2luZm8oIlNWTiB1cGRhdGVkIHN1Y2Nlc3NmdWxseVxuIik7DQo+ID4gKwkJcmV0dXJuIDA7DQo+
ID4gKwl9DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIEVVUERBVEVTVk4gd2FzIGNhbGxlZCB3
aGVuIEVQQyBpcyBlbXB0eSwgYWxsIG90aGVyIGVycm9yDQo+ID4gKwkgKiBjb2RlcyBhcmUgdW5l
eHBlY3RlZC4NCj4gPiArCSAqLw0KPiA+ICsJRU5DTFNfV0FSTihyZXQsICJFVVBEQVRFU1ZOIik7
DQo+ID4gKwlyZXR1cm4gLUVJTzsNCj4gPiArfQ0KPiANCj4gRXZlbiBpZiB1bmxpa2VseSgpIHdh
cyBub3QgdXNlZCBJIHN0aWxsIGRvbid0IGFncmVlIHdpdGggdGhlIG9yZGVyIGkuZS4sDQo+IGRl
YWxpbmcgd2l0aCB0aGUgc3VjY2VzcyBjYXNlIGluIHRoZSBtaWRkbGUuIFNvIEkgc3RhbmQgd2l0
aCBteSBlYXJsaWVyDQo+IHN1Z2dlc3Rpb24sIGV4Y2VwdCB1bmxpa2VseSgpIChzaW5jZSB0aGF0
IHdhcyBhIHByb2JsZW0gZm9yIERhdmlkLCBub3QNCj4gZ29pbmcgdG8gZmlnaHQgb3ZlciBpdCku
DQoNCkkgY2FuIGNoYW5nZSB0aGUgb3JkZXIgaW4gdGhlIG5leHQgcGF0Y2ggaWYgdGhpcyBpcyB3
aGF0IGV2ZXJ5b25lIGFncmVlcyBvbi4NClNvLCB5b3VyIHByZWZlcmVuY2Ugd291bGQgYmUgdG8g
aGF2ZSBzbXRoIGxpa2UgdGhpczoNCg0KKwkvKg0KKwkgKiBTVk4gc3VjY2Vzc2Z1bGx5IHVwZGF0
ZWQuDQorCSogTGV0IHVzZXJzIGtub3cgd2hlbiB0aGUgdXBkYXRlIHdhcyBzdWNjZXNzZnVsLg0K
KwkqLw0KKwlpZiAoIXJldCkgDQorCQlwcl9pbmZvKCJTVk4gdXBkYXRlZCBzdWNjZXNzZnVsbHlc
biIpOw0KKwkNCisJaWYgKCFyZXQpIHx8IChyZXQgPT0gU0dYX05PX1VQREFURSkNCisJCXJldHVy
biAwOw0KKw0KKwkvKg0KKwkgKiBTVk4gdXBkYXRlIGZhaWxlZCBkdWUgdG8gbGFjayBvZiBlbnRy
b3B5IGluIERSTkcuDQorCSAqIEluZGljYXRlIHRvIHVzZXJzcGFjZSB0aGF0IGl0IHNob3VsZCBy
ZXRyeS4NCisJICovDQorCWlmIChyZXQgPT0gU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZKQ0KKwkJ
cmV0dXJuIC1FQUdBSU47DQorDQorCS8qDQorCSAqIEVVUERBVEVTVk4gd2FzIGNhbGxlZCB3aGVu
IEVQQyBpcyBlbXB0eSwgYWxsIG90aGVyIGVycm9yDQorCSAqIGNvZGVzIGFyZSB1bmV4cGVjdGVk
Lg0KKwkgKi8NCisJRU5DTFNfV0FSTihyZXQsICJFVVBEQVRFU1ZOIik7DQorCXJldHVybiAtRUlP
Ow0K
