Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C75A12C7FD;
	Thu, 27 Mar 2025 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743089421; cv=fail; b=uLxBszcgSqYZ/2BIfE4luCX6PPxjHAlFWqNFYH5CrEjeHcH6X39dpFgR5Na02ZyhqBTGvZzwOOgtZEKUZZ2wCfmQtn4wTA2+wLw3gMgG6whGP2o3oodhA84xFPzJGfcQyoZ+R+ADvqUu3Zzco8DWMl3QaJ+drQXM6VaEi7k7g3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743089421; c=relaxed/simple;
	bh=G67GV8lgCKhOl8EUaRPRreO6M55/T+ywbmaT7iegIJ0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L2Z9MrTV3xWW27+hG4FJ+xlqH9vrqrfVz37+zXK2NrmzM3r4JdZ3zPRewA0VgW0Y+0SCRYNS/Lm8C711PrKpQat9HdoTVZGsAQ2OgDbaPruR0k6vWnqUKFRqjsNaz0hQyf8Y16wNFFqOYCma/cAsGuBT6MsKOiV2RhdCWsgIalA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hhMrBOoq; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hhMrBOoq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743089419; x=1774625419;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G67GV8lgCKhOl8EUaRPRreO6M55/T+ywbmaT7iegIJ0=;
  b=hhMrBOoqqAgftzzb7Fq7l/sVKzB3DUres3mQZz9yfRkiUMz+xdNGOcz+
   Gl81JvCDDvE5nOVp01G1n/i9qCEmR9GtenE2iImnygJ4H/3nF5j73s6sy
   L4URgyhF/4YN8A3RPIiwSkwbTrt+KvAMwKcf7uMfyyVYQ1nW0sfDT3/wa
   4PHzeIfFexoHw0/s7vz4QwR2DZWAfgzo9Kr5sP40LyskOwAJTnwIb8HW1
   4DVPmLqXVwk86Mm/hNPAQtIu2BrRwV6Ql6ckpuUGuz2n3cA/SbvjbFdsC
   Ge1jY0UKP4GeAZhdTMbLD/+UXK9sD6wKtefyn823fckze2X5uk+AjKsdz
   g==;
X-CSE-ConnectionGUID: zEFlIK4IR+CAghy5z1x05g==
X-CSE-MsgGUID: PSKGH7YeRy+QbYcodmMx6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="55078941"
X-IronPort-AV: E=Sophos;i="6.14,280,1736841600"; 
   d="scan'208";a="55078941"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 08:30:17 -0700
X-CSE-ConnectionGUID: ULkRmJfuRXeZb+3TxQ562Q==
X-CSE-MsgGUID: jKOWm7o8Q9y4JoRXOGywjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,280,1736841600"; 
   d="scan'208";a="125622578"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 08:30:05 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 27 Mar 2025 08:30:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 27 Mar 2025 08:30:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Mar 2025 08:30:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EggeZU7rCQl3ZABwQf2WFyMgaPi5bTLtLGmp8nxON22BqlHf20tfDHECl34T7rYSRyTg95OttqBVLmkSGitAEMpEMLGwCjeO8E+Vl1+ER2IaYHSCt5U/23XNy4xfeGgPQCPZR+o2pbFa1jtM2o45+7Gc/fxe872U8nkaMI1BatcQX+4YkwlGZe90LiH1nGLKSWXZ6tRcFNWk1iTiFzqnQGhJ7pz+3RjmATq0YAdf0IGwCemvOciqgkmAJoaEhUThdNxwuC9lTUqp82i3NR2zbhSbbz4AmjX6QpCU59qqyJFhlI/mnfzIoKRwh2ODUvXZ3NTbJG/svsDluabB1n05sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G67GV8lgCKhOl8EUaRPRreO6M55/T+ywbmaT7iegIJ0=;
 b=H2d9MYS0GEwFzZa9uAJsF9sg21J8LA+vIPIvK1/s0PhPPG7Xqf/qfz1hq2pln4iAREDylUVmPB3uBjORm7oW1T0f4/84VVe9OnxbcRfBE33qlLOxJl9xnNedhG3nO5zb675Mb06uL/mDJzcUDihkItvIZCga/JQnR71n35UJbrA+Gd7Gzvux0muPTV/sZthfhDF9paApxJddaVr/HC857elSTIzE8+1N4937b2T4/4ks7twE65AnRFm42cbkguq45gzQsdnYGeQUmBZxQw5qHanT7gn3z3RqBHvKJZq5QJeZQ2OxbLXdOmFS1d67zpcR8yzaxUw18HSHnN74ZV+9dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SA3PR11MB8117.namprd11.prod.outlook.com (2603:10b6:806:2f0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 15:29:54 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.040; Thu, 27 Mar 2025
 15:29:54 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>
Subject: RE: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Thread-Topic: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Thread-Index: AQHbml52rO5WRn4U4UWiUGJJakHgYrN/tmkAgAJ/A3CAA6SegIABR0IQ
Date: Thu, 27 Mar 2025 15:29:53 +0000
Message-ID: <DM8PR11MB575029FAC2C833553CE422CFE7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-2-elena.reshetova@intel.com>
 <Z98yki-gH4ewlpbP@kernel.org>
 <DM8PR11MB57508A3681C614C9B185B04EE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RY8-bL2snpRKTB@kernel.org>
In-Reply-To: <Z-RY8-bL2snpRKTB@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SA3PR11MB8117:EE_
x-ms-office365-filtering-correlation-id: ac93c3d7-853c-40d0-2137-08dd6d443927
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N3QxaVVDdkJnMkRpbkZQcVhVQXR1ZDBIK0hrY2dwT29HZWtuakN5ckE3WDBo?=
 =?utf-8?B?c2dzQTlHVHNvODRZTWttYUQrSXBCYXd0T1A1WlBZZmY4MVVjVGxnK051Rkt3?=
 =?utf-8?B?LzRIUXlWNGdrMndoNE5Lb0JNL21pMDE4bm1ENVV1Y1Z1MExSVEtYVlo5Sldj?=
 =?utf-8?B?RCswNnd0dDRrUndhK3hkTDJWeWl5WnFidlZ2S3dRbWxsK01mS2o5T0p2TkRz?=
 =?utf-8?B?ZkFkOTV6S2p3OHVXQVNBVEZ2TUVlQWJLOVczcXdHMnJIMzlkREFpRGVTTkNB?=
 =?utf-8?B?RTV6MUJxOVJQNjZIQlV5cTlJRm9XcWRRRGlDU3I1SXlIRE5iaUhGRjEzQmV1?=
 =?utf-8?B?YXpTZ05RUVlkTFBteWlUZjhoRno2YXRZcTB5WGlqM1VJMGdsVnFQSnNFTnRE?=
 =?utf-8?B?TjdGWG9VTFF3c2xUZTN0RHNMckRhTXM1bVd1bGU1T0psY1luNWN2MzVDUHBW?=
 =?utf-8?B?cTkyVnBNQ3hQazJCRzllenErWkR0NGVsWFluTGZXV2JpRVVVaDZzRFRMdTlq?=
 =?utf-8?B?S0VjeGN4bEJQbnQ2dTFVeU9FaitIZ2ExWWZJZUJxcUFmUnQwK2dHQUMzZU5U?=
 =?utf-8?B?ZG11RWhwQlNYZ2VPTmZhaVppTnREZS9HcTlHSHZleVhIbk1STVp4V2VYWXJo?=
 =?utf-8?B?eTFENWtpVzRUZGVXaGF5RndaZklMR2U2bTNrK21sSWUwVTNSamx4dWIrUnlr?=
 =?utf-8?B?N29STndBcFlIWlFnWm45a1lSbjl6ckNqOUU5OW5ua1V3KzlOd1Y0RWJub3dM?=
 =?utf-8?B?QmRCb0VOOVZWeW1vVDN1OGMvS1o0djJTeUxnZEdYeWtnaGdvWGVibDJnbG1y?=
 =?utf-8?B?N21wcEsvSFJidXNQeUQ4SmNuV1RuSmJXTXMxTFRBRk1rRExhQUxVYzZCWXVW?=
 =?utf-8?B?TDUxZHdzTkRCMlprR2tiL3A5T3JpSkZhREZkcXBwcmN4UWEvVnQrczNwN3Iv?=
 =?utf-8?B?MnNHblp5R2U2K25CMlo0M1c0QUM3ZTBSd0NkUmJwR0l3NXI0TFZ2K0V2TDBJ?=
 =?utf-8?B?ZElFUFozd25xckVvQmlPTFJYWTlVOTJUNmIvSmpxR3o4TXB6VDArNGFSRHMx?=
 =?utf-8?B?RDVhTG5VWWdaSTJQaWYvcU5teXY2V1pvRHVkdkVGdWg5NXlMWldQYmY5Q2lo?=
 =?utf-8?B?cCtvaDZxT0tzRjNpM29BcElqbWdXL3p1UFFNd01tbWJDZUhjNDRyOWxxR1ZR?=
 =?utf-8?B?VC90VUd0RXdCWkQ4ZVozaTZOUEVDRWxaS2UvOXZRK082Nzk3VG5vQmFVb3hM?=
 =?utf-8?B?TE5QWW9yVm9OcUdUR2hucVB4bFRNUUw5WnNrMURza09zanIzYkZRYTNvVEZa?=
 =?utf-8?B?TW8rZWRaTUU1bHBSTTZpUW5JNXRpenRYN2hETkZqWUVoVHlZL0EzODljVHpt?=
 =?utf-8?B?bC8xTFFtT3Q2Qm82MkEwWmxFZFJJOEhVcmJxSVNNYXZ6ZFdyc2pIaWJDTUlU?=
 =?utf-8?B?N3ZxOWdDbVhKR09wdVdlTk93ek9kUWhOc1M4TnRkS3NTY3RYMmFCa0pYTTA0?=
 =?utf-8?B?OUt2UU5zZncwSkdTazcxRmwrWHVhQ2g5QUlSL2pIT1NaK0NFNW8zd3VMZ1Nu?=
 =?utf-8?B?dUFRSjNadGxreUt0MG00WVlkWFlRSVpaV2hnUjFWaFY3RDFraHVQOVcyNnZO?=
 =?utf-8?B?N2pIVENacVdxNXFiRVJvbmczVmVacDQrRlFjTXZEYitlc2Y0NXJBd1phQ1cx?=
 =?utf-8?B?T0N4Y2VwNnlidzI1LzRkVzZ6NHh2T0djc0xFeDhwZlFxdXhqWm1yS0NjTlJw?=
 =?utf-8?B?UjJrNm16d3ZtTlZTaW9oajVCQUNmTlZrOXl6S21Db0xvUDljbkNTWnM2Q2xT?=
 =?utf-8?B?QktxRGpUT2pyZC9OdWJ3Q2J2czJPMi9qVHN0V2x6MXN6NXZ6V0lzeUd0dnJ5?=
 =?utf-8?B?NDBkME9PK00xam0wZi9oZURvbzZSU2Y5VDRRTmZxSHd6RERjb25jS3lnRTJz?=
 =?utf-8?Q?k1ddJsQHTjEtYiCyR5KBu2i2njX9a9xL?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUF4NmsxdjhhUHY0eldDTjRVWks2bTJWKzRjdy9DOWYzSkxwOE5Ob2VXQW1w?=
 =?utf-8?B?cEFBNXllTFVCT1F3Vk0rUVEvTTVFVlplRzg2SEh3SFg0TVQvS2xkUlhSdWdw?=
 =?utf-8?B?Q2o2RGxqNlNyZUIyNUhMRlR0M1dROC9PekZHN0NneFF0b2pra21UUm9oeW5v?=
 =?utf-8?B?Tmxna0M3SWs2M1lvTFB4L1ArQWV5T2dSN21oNEk5OXBSN2xlb0hmakVnMWll?=
 =?utf-8?B?ZmNjb0pjSzJCTFA3NEttSWJ4TkpubVRpSFAvWFNRRTU2L3lQdy9maEk2RVpC?=
 =?utf-8?B?QTFGZGNSTU9vMjVqTHVnamd4NEZKMkROcGN0d1dLV29WblEvWVJDOUU1RnNT?=
 =?utf-8?B?MHpoc1MzbGRSbEVMN1hWajk3aGlCQVhHNWNJZ2ZBQ1JUcnJ1WTVPTVNqVTdq?=
 =?utf-8?B?Z1oxVHE4ZVc2UndIbldUTE9DbHJ1YWxOMEIxZERoYW8rV05qV25KMnBnK1JR?=
 =?utf-8?B?YnNvM3Z5U3FaNGtaL0YwZlpYY3dSSFpXQzEyczR0ZCsrOHJlc01RTzBvdDhN?=
 =?utf-8?B?SnZtNlArcGhpWnpuS2RsdUtnZ2xOcFk0TFUxNGhiaVAxdkhjODZtZkpkVmtz?=
 =?utf-8?B?YmRHdVZHVk1rdjFXVkRuZUgrblpkQy9OSytZcmxRWkRsSHlheTh3dXUrSnI1?=
 =?utf-8?B?QWVNQ3MzdTU1K3hFb3o4MmNMSEpJR2dJSkNNeHl3M0pBNXY0c2x2TGdqOUVr?=
 =?utf-8?B?Uk45amJGZFhPMjEzZU5VZ2tENVBCdXJtTjRrbE9qOGo0T2paMGtXV3ZYWFZ3?=
 =?utf-8?B?N0FTRWU1NFovdkc1UGwxSXhabTFtMWxId053cFE4L0NCSDcvUDR2VHVyRjdq?=
 =?utf-8?B?R2ZpQnpmWVFrWTdVNW9pd01ITU9CT2pVOFczbng2Y0tTSGtDZlhhN0xWRG1Y?=
 =?utf-8?B?TCtxRlltOWdSWUdFOVFtQllYcEhqWEQ3NnRYcVZtdmpGRlBQNS9GRFduaDA4?=
 =?utf-8?B?S1gvQ0xTQUY3ZWExSVZ1akY1MW11VVFGWFhsN0M5TUFSY3pNMTIyNUcxdXdo?=
 =?utf-8?B?OUhUMC9VOXBsNlVuNUttRnU2d3JQMHZzNXVtQUxsTnQ1bWNvb2tUYlNmVHgw?=
 =?utf-8?B?cWR2OW5kbXMxNys5dEdZS0lES2k1Z01tdnA5c014MGRNYmhRYkN2OVpxNnor?=
 =?utf-8?B?ejB1RGQ5aHNlRVF4REtqdlFjVkFRUHp5YjROc25WajlTTW9haENwY0c3YmY5?=
 =?utf-8?B?dHdqTTVCdy9aZHBDZDFoMTgwK3c5UDI2TU1IblJwTTNZdG9hYXE1SHpPSFJV?=
 =?utf-8?B?d2VCUm4yUVRUNmQrQTNFMFhrb3lJQ3R4NitETXRCczRBVktpdjA1MDltT3Yr?=
 =?utf-8?B?TWhIaDBUMFBuQlBlZ1ZuNzhER25uMW1WOThMT2k2dHRIV3ovbXVNR3Y5MklP?=
 =?utf-8?B?OVZJUU84OWMyRlZUbW91empMWWdGUnRidEVvcDB1aHc1UHpPSy9ibXdIN3Zz?=
 =?utf-8?B?Yk16TUpHYlB5NjVDUGVXNU5XVlhLMEdTZ1JpOEJGQlkxQXkzakVCcmZuRnhl?=
 =?utf-8?B?dlVrUUpMVHdNcVNob0ozTVAwQXZsTDZ0N2o3UGlhT0NXTm14bld5SlJRdGwy?=
 =?utf-8?B?Sy83Yzh3WjkvM1M2OWFXSkN1WGQ1cERUN0tCYUdTQVVYa2hiZXBnZWVBYUxh?=
 =?utf-8?B?cm9UL2RSUFlIWk4wQWZiRlVDcTNvZGd1WWFTSzlCTUZ4dzI5SEt0cFVNbngy?=
 =?utf-8?B?cWJHRlZ1L2ZWRDNNSDlNK2FMalkzOVQwdDJqQUdRdDNyU01aMk9DNis4WGdQ?=
 =?utf-8?B?RVJFd0J3dEp5RVdwV1FpZ2YyVXo3aVcvUUZVNmNha2V5eGZNeDl0ODZRZmh4?=
 =?utf-8?B?ZEdBbWlwWnViQXJpaU15ZTZPdzIxbnlJTDFaRlJITExRY2dqaWowK0lVSTNQ?=
 =?utf-8?B?a0R0UmFaa2czMHBTRlZtQzhQL2krTldrYitqT2JFTktPaVlVbldaWVc1alZt?=
 =?utf-8?B?UGZpWkVHclAzYlJ2c290NkNmbHVtRDVjZ3RXMjBZZ0s2U1lNM3JHNjJCMTZo?=
 =?utf-8?B?WWNOZERoY3VBYmYxbXhVNmVST1ZPdjF0Rng1a3FKVU03QmdtV0lsVWw4QUVR?=
 =?utf-8?B?eG9tUnhMVUdvaGRrUkFhZE56QzdqU2ZVWURWVmpIQWdJUWhJTnllOTVLZzlv?=
 =?utf-8?Q?nhVpu+onT2sPiaumUHNdURlSL?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ac93c3d7-853c-40d0-2137-08dd6d443927
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2025 15:29:53.9988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oUnrVpwpChNPXdJcmCBfExnxbrMEnZtiBqeGDj/uNzNyWDVzjL57mEQVM0Bjx07LoxWkl2wDPATZIjAt+QtQrXMNnn4UW5vxTCoNES87gZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8117
X-OriginatorOrg: intel.com

DQo+IE9uIE1vbiwgTWFyIDI0LCAyMDI1IGF0IDEyOjEyOjQxUE0gKzAwMDAsIFJlc2hldG92YSwg
RWxlbmEgd3JvdGU6DQo+ID4gPiBPbiBGcmksIE1hciAyMSwgMjAyNSBhdCAwMjozNDo0MFBNICsw
MjAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6DQo+ID4gPiA+IEluIG9yZGVyIHRvIHN1Y2Nlc3Nm
dWxseSBleGVjdXRlIEVOQ0xTW0VVUERBVEVTVk5dLCBFUEMgbXVzdCBiZQ0KPiBlbXB0eS4NCj4g
PiA+ID4gU0dYIGFscmVhZHkgaGFzIGEgdmFyaWFibGUgc2d4X25yX2ZyZWVfcGFnZXMgdGhhdCB0
cmFja3MgZnJlZQ0KPiA+ID4gPiBFUEMgcGFnZXMuIEFkZCBhIG5ldyB2YXJpYWJsZSwgc2d4X25y
X3RvdGFsX3BhZ2VzLCB0aGF0IHdpbGwga2VlcA0KPiA+ID4gPiB0cmFjayBvZiB0b3RhbCBudW1i
ZXIgb2YgRVBDIHBhZ2VzLiBJdCB3aWxsIGJlIHVzZWQgaW4gc3Vic2VxdWVudA0KPiA+ID4gPiBw
YXRjaCB0byBjaGFuZ2UgdGhlIHNneF9ucl9mcmVlX3BhZ2VzIGludG8gc2d4X25yX3VzZWRfcGFn
ZXMgYW5kDQo+ID4gPiA+IGFsbG93IGFuIGVhc3kgY2hlY2sgZm9yIGFuIGVtcHR5IEVQQy4NCj4g
PiA+DQo+ID4gPiBGaXJzdCBvZmYsIHJlbW92ZSAiaW4gc3Vic2VxdWVudCBwYXRjaCIuDQo+ID4N
Cj4gPiBPaw0KPiA+DQo+ID4gPg0KPiA+ID4gV2hhdCBkb2VzICJjaGFuZ2Ugc2d4X25yX2ZyZWVf
cGFnZXMgaW50byBzZ3hfbnJfdXNlZF9wYWdlcyIgbWVhbj8NCj4gPg0KPiA+IEFzIHlvdSBjYW4g
c2VlIGZyb20gcGF0Y2ggMi80LCBJIGhhZCB0byB0dXJuIGFyb3VuZCB0aGUgbWVhbmluZyBvZiB0
aGUNCj4gPiBleGlzdGluZyBzZ3hfbnJfZnJlZV9wYWdlcyBhdG9taWMgY291bnRlciBub3QgdG8g
Y291bnQgdGhlICMgb2YgZnJlZSBwYWdlcw0KPiA+IGluIEVQQywgYnV0IHRvIGNvdW50IHRoZSAj
IG9mIHVzZWQgRVBDIHBhZ2VzIChoZW5jZSB0aGUgY2hhbmdlIG9mIG5hbWUNCj4gPiB0byBzZ3hf
bnJfdXNlZF9wYWdlcykuIFRoZSByZWFzb24gZm9yIGRvaW5nIHRoaXMgaXMgb25seSBhcHBhcmVu
dCBpbiBwYXRjaA0KPiANCj4gV2h5IHlvdSAqYWJzb2x1dGVseSogbmVlZCB0byBpbnZlcnQgdGhl
IG1lYW5pbmcgYW5kIGNhbm5vdCBtYWtlDQo+IHRoaXMgd29yayBieSBhbnkgbWVhbnMgb3RoZXJ3
aXNlPw0KPiANCj4gSSBkb3VidCBoaWdobHkgZG91YnQgdGhpcyBjb3VsZCBub3QgYmUgZG9uZSBv
dGhlciB3YXkgYXJvdW5kLg0KDQpJIGNhbiBtYWtlIGl0IHdvcmsuIFRoZSBwb2ludCB0aGF0IHRo
aXMgd2F5IGlzIG11Y2ggYmV0dGVyIGFuZCBubyBkYW1hZ2UgdG8NCmV4aXN0aW5nIGxvZ2ljIGlz
IGRvbmUuIFRoZSBzZ3hfbnJfZnJlZV9wYWdlcyBjb3VudGVyIHRoYXQgaXMgdXNlZCBvbmx5IGZv
ciBwYWdlIHJlY2xhaW1pbmcNCmFuZCBjaGVja2VkIGluIGEgc2luZ2xlIHBpZWNlIG9mIGNvZGUu
DQpUbyBnaXZlIHlvdSBhbiBpZGVhIHRoZSBwcmV2aW91cyBpdGVyYXRpb24gb2YgdGhlIGNvZGUg
bG9va2VkIGxpa2UgYmVsb3cuDQpGaXJzdCwgSSBoYWQgdG8gZGVmaW5lIGEgbmV3IHVuY29uZGl0
aW9uYWwgc3BpbmxvY2sgdG8gcHJvdGVjdCB0aGUgRVBDIHBhZ2UgYWxsb2NhdGlvbjoNCg0KZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYyBiL2FyY2gveDg2L2tlcm5l
bC9jcHUvc2d4L21haW4uYw0KaW5kZXggYzhhMjU0MjE0MGExLi40ZjQ0NWMyODkyOWIgMTAwNjQ0
DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCisrKyBiL2FyY2gveDg2L2tl
cm5lbC9jcHUvc2d4L21haW4uYw0KQEAgLTMxLDYgKzMxLDcgQEAgc3RhdGljIERFRklORV9YQVJS
QVkoc2d4X2VwY19hZGRyZXNzX3NwYWNlKTsNCiAgKi8NCiBzdGF0aWMgTElTVF9IRUFEKHNneF9h
Y3RpdmVfcGFnZV9saXN0KTsNCiBzdGF0aWMgREVGSU5FX1NQSU5MT0NLKHNneF9yZWNsYWltZXJf
bG9jayk7DQorc3RhdGljIERFRklORV9TUElOTE9DSyhzZ3hfYWxsb2NhdGVfZXBjX3BhZ2VfbG9j
ayk7DQogDQogc3RhdGljIGF0b21pY19sb25nX3Qgc2d4X25yX2ZyZWVfcGFnZXMgPSBBVE9NSUNf
TE9OR19JTklUKDApOw0KIHN0YXRpYyB1bnNpZ25lZCBsb25nIHNneF9ucl90b3RhbF9wYWdlczsN
CkBAIC00NTcsNyArNDU4LDEwIEBAIHN0YXRpYyBzdHJ1Y3Qgc2d4X2VwY19wYWdlICpfX3NneF9h
bGxvY19lcGNfcGFnZV9mcm9tX25vZGUoaW50IG5pZCkNCiAgcGFnZS0+ZmxhZ3MgPSAwOw0KIA0K
ICBzcGluX3VubG9jaygmbm9kZS0+bG9jayk7DQorDQorIHNwaW5fbG9jaygmc2d4X2FsbG9jYXRl
X2VwY19wYWdlX2xvY2spOw0KICBhdG9taWNfbG9uZ19kZWMoJnNneF9ucl9mcmVlX3BhZ2VzKTsN
Cisgc3Bpbl91bmxvY2soJnNneF9hbGxvY2F0ZV9lcGNfcGFnZV9sb2NrKTsNCiANCiAgcmV0dXJu
IHBhZ2U7DQogfQ0KDQpBbmQgdGhlbiBhbHNvIHRha2Ugc3BpbmxvY2sgZXZlcnkgdGltZSBldXBk
YXRlc3ZuIGF0dGVtcHRzIHRvIHJ1bjoNCg0KaW50IHNneF91cGRhdGVzdm4odm9pZCkNCit7DQor
IGludCByZXQ7DQorIGludCByZXRyeSA9IDEwOw0KKw0KKyBzcGluX2xvY2soJnNneF9hbGxvY2F0
ZV9lcGNfcGFnZV9sb2NrKTsNCisNCisgaWYgKGF0b21pY19sb25nX3JlYWQoJnNneF9ucl9mcmVl
X3BhZ2VzKSAhPSBzZ3hfbnJfdG90YWxfcGFnZXMpIHsNCisgc3Bpbl91bmxvY2soJnNneF9hbGxv
Y2F0ZV9lcGNfcGFnZV9sb2NrKTsNCisgcmV0dXJuIFNHWF9FUENfTk9UX1JFQURZOw0KKyB9DQor
DQorIGRvIHsNCisgcmV0ID0gX19ldXBkYXRlc3ZuKCk7DQorIGlmIChyZXQgIT0gU0dYX0lOU1VG
RklDSUVOVF9FTlRST1BZKQ0KKyBicmVhazsNCisNCisgfSB3aGlsZSAoLS1yZXRyeSk7DQorDQor
IHNwaW5fdW5sb2NrKCZzZ3hfYWxsb2NhdGVfZXBjX3BhZ2VfbG9jayk7DQoNCldoaWNoIHdhcyBj
YWxsZWQgZnJvbSBlYWNoIGVuY2xhdmUgY3JlYXRlIGlvY3RsOg0KDQpAQCAtMTYzLDYgKzE2Mywx
MSBAQCBzdGF0aWMgbG9uZyBzZ3hfaW9jX2VuY2xhdmVfY3JlYXRlKHN0cnVjdCBzZ3hfZW5jbCAq
ZW5jbCwgdm9pZCBfX3VzZXIgKmFyZykNCiAgaWYgKGNvcHlfZnJvbV91c2VyKCZjcmVhdGVfYXJn
LCBhcmcsIHNpemVvZihjcmVhdGVfYXJnKSkpDQogIHJldHVybiAtRUZBVUxUOw0KIA0KKyAvKiBV
bmxlc3MgcnVubmluZyBpbiBhIFZNLCBleGVjdXRlIEVVUERBVEVTVk4gaWYgaW5zdHJ1Y3Rpb24g
aXMgYXZhbGlibGUgKi8NCisgaWYgKChjcHVpZF9lYXgoU0dYX0NQVUlEKSAmIFNHWF9DUFVJRF9F
VVBEQVRFU1ZOKSAmJg0KKyAgICAhYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0hZUEVSVklTT1Ip
KQ0KKyBzZ3hfdXBkYXRlc3ZuKCk7DQorDQogIHNlY3MgPSBrbWFsbG9jKFBBR0VfU0laRSwgR0ZQ
X0tFUk5FTCk7DQogIGlmICghc2VjcykNCiAgcmV0dXJuIC1FTk9NRU07DQoNCldvdWxkIHlvdSBh
Z3JlZSB0aGF0IHRoaXMgd2F5IGl0IGlzIG11Y2ggd29yc2UgZXZlbiBjb2RlL2xvZ2ljLXdpc2Ug
ZXZlbiB3aXRob3V0IGJlbmNobWFya3M/IA0KDQpCZXN0IFJlZ2FyZHMsDQpFbGVuYS4gDQo=
