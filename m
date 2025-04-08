Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16922261387;
	Tue,  8 Apr 2025 06:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744095266; cv=fail; b=jCkJTJAFDvqOdOE5RxcgJAz0WgQQq4j2IGoIg8bg2ViJJcWdiceBqmwPzhaLBvO6w+4wLR3fwTjz/y2dWrHp+METElSeSkAflHipS9ItMQvpsaFroBjQYA5dxvXLGtn5sgbDCpfCC4m0qIakl03aBOvPvAexwCGH+TC0PoooeKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744095266; c=relaxed/simple;
	bh=CeaPRtu3ydKKitBT3v1vGGb2cB7LiIYV8S+7E4QxU5A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cg0axNkljgqk47kVzazf9dMqJy0IYx62sAOG82cHmOVg6TzfCHeOmAInGqEzZsd9grstHNOKl4FWn7T03cZ5eV9sWiWtBFaErdtTf62rPUhf9HJ6QUdXy5+dgzFG+eejNkPZVd8Zn11uEK84bd6h1z2GAYyFIQ0IU+5dCBMBDIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AVLtEt9t; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AVLtEt9t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744095264; x=1775631264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CeaPRtu3ydKKitBT3v1vGGb2cB7LiIYV8S+7E4QxU5A=;
  b=AVLtEt9tx8KxR3LQrbXBX6SxLPFAIHFuIk/z6jtGZcE5o/jlzNbJ+gdP
   Pn+rBhaCWxqnRQYcKglBFJsJf226LsFR30nKqMYr3wTK1x4r2pu3VU8CV
   lbqlAQYn7VC/RZhhbEKxM7MBVvOHHDQY4Dqq0sdODfXNHnZ3Z3OmvY7xG
   uKue71YyxeVzvsxtcBrpdD00ghT2/vVdJQbDy8Ib1+CviV/8v1Iqc3a8D
   6BJhJozF+B3DtQZEdKzI2PQ6ZKbNzaNgDbeAF7x4UMnKEMg5dRUNCu1xO
   VisL0G8z3sfEQx9YgdTAd3H6Y6kaHKDxNhMrnTgpURemImc/C96ke4EVB
   Q==;
X-CSE-ConnectionGUID: 82RLn4b1Qr64ejRF05FGWA==
X-CSE-MsgGUID: K+JUKAtJQM+SSOueMsItXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="49167319"
X-IronPort-AV: E=Sophos;i="6.15,197,1739865600"; 
   d="scan'208";a="49167319"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 23:54:23 -0700
X-CSE-ConnectionGUID: Z9eVvfrDQoiD4TbLNLJbaw==
X-CSE-MsgGUID: p6SiV9BlTgerN4q0t/H/sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,197,1739865600"; 
   d="scan'208";a="127923980"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Apr 2025 23:54:18 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 7 Apr 2025 23:54:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 7 Apr 2025 23:54:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 7 Apr 2025 23:54:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qXkUTxlf4PmcRMWx8NUEGosqfjBtY8/TuT1O+vR4K4GSKKxdiGR4cXFYwXrDhalBtsaHK2PjnoZJQ2es6qVa3wn/vrLFjJPzSqe4irdJrNF3h5zsBhIOcoIDlhaxsGiLDIvzErV8ojI+RNCR7iY/2IXSxLXmHXDF+OoQZbVZsNxluxj749ZEZeQ3y+pL4gBJSiVBMXcKYY3bI04qwb3yD3im4XvAfrhL+Jr0960foC41h7pI05Mj/5Z3FMyj1jSWykb9kVAU4W8bbBU9KIFT0RB8j3RMG/oKjXKY96V+Dp6Eu1c/cLi3xeqgS+uZyGHDi0P5WBwLRI2euBBfia82tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CeaPRtu3ydKKitBT3v1vGGb2cB7LiIYV8S+7E4QxU5A=;
 b=zTVlP3ObvL8rkqVSDVw/DKGCkqul9gnfvqJz5P0UyavRX1UINzMUuw77LK9K6fshgMv5WAPAb7hYFqXzfLgS0Bz/4tDCsgcb3gzhLYY1F8uiq43ICmzkIrtisZQwB06ym0Nok32ldbqoG/Vk+F0ar20K8qLoG/cXuw+1UjsZE6QarLATk48VTQqcuhtVnQ8lFM1Pu93b3pUNeXRn6YHB0IGlZpWmnK95mRTYS26O1jN6X9kEJgimtI2dfgbeFgjjmLWonsOZGmWTuLUA6o+H5Kag3V9v9eP7Y479bboXzWH98t76AOt+LuXXF06ItEFFqcW3e+iYvZG+2v432/ORZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CH2PR11MB8866.namprd11.prod.outlook.com (2603:10b6:610:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.31; Tue, 8 Apr
 2025 06:54:14 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8606.033; Tue, 8 Apr 2025
 06:54:14 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, "Huang, Kai" <kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: RE: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbn+FDiJjsRSw2cUyPYDKGfVHjnbOI1BeAgAAEgICABAKjsIAArrUAgAEIZUCAAFLwgIABevGQgAH4xoCAAMDIQIAAEkoAgAS/YyCAAQj4AIAAbf8AgAAAqYCAAAKHQA==
Date: Tue, 8 Apr 2025 06:54:14 +0000
Message-ID: <DM8PR11MB5750D5848DC0B3AC0EF00C30E7B52@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <Z-rU_JXWn0vCdBr_@kernel.org>
 <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-v4WfcLhmXbYvaa@kernel.org>
 <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-7dqQCiu5fWZ9a9@kernel.org>
 <DM8PR11MB5750131ED71BFF175E3E329CE7A92@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z--OuMuWx8jUdSU1@kernel.org>
 <DM8PR11MB575046992BEACCD83164043CE7AA2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <a0a803275d317f88afdd757afa30e84a26b05656.camel@intel.com>
 <Z_TEzsYnCxXoEhi0@kernel.org> <Z_TFW_0D90wK8BdM@kernel.org>
In-Reply-To: <Z_TFW_0D90wK8BdM@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CH2PR11MB8866:EE_
x-ms-office365-filtering-correlation-id: c8abdc89-8974-49ac-cc24-08dd766a2c6f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RXJic1dldXlmeFJnaTZQRDZ1Qjlldzg0Z1ladjZrY28wbWNHSjlDWXBSK1F5?=
 =?utf-8?B?dGlCUVpqM0cvUFNTQ2NFUlB6VzhFdXVremY2dzZqbWJWNW5yb1pwc2Exa2xX?=
 =?utf-8?B?dnREeWdlRldnVVBvN2kxWnlqVnFyTHdlMjJrSHNmMHlyMEFpSnlLU0VNbVh5?=
 =?utf-8?B?UkNnRWZTMGNqNVdWWkNEY2NqMExwdUVhT2ZkaTBVTVRmUlpEaUZDQzVVQUM5?=
 =?utf-8?B?SWtUV0RZcXJHVDhkRmZWN1pqOGYzNjN3b3BSVHZBdlM5czBTY3FsMnJvdTRp?=
 =?utf-8?B?N1RRb0pKUlFYMzFLbVZ5a3I4WVJJRXZTRWFRK3ZiZThFSVJraTVwaktNMldL?=
 =?utf-8?B?OWZpZnE3ZGFOMnlIekd2WHZmZUZKZTVLaS9EWXV6QVBNM2g4ZnBBTklTSGtJ?=
 =?utf-8?B?RkdheENYK1NhODgzYlYrMkZBa1ZKQ0RaK2ZKNGorbXI2YzV1enVPU1ZjUC9p?=
 =?utf-8?B?UG5yNzhORUhnRzZRRllnaG1Sa3VranRHY1E4YzZFVDhMcU1FSGkyNncySlQx?=
 =?utf-8?B?TnR4TndwbmlpQnliOUNEcVBUV2FubWxTRjQ2YThvNm1nYWIwSFRwUk5DUk04?=
 =?utf-8?B?K01UenczM05JRmRPMndTNko0bHYyN0d6ZHl3MitjK1puV1ExYXd4NFEya0I2?=
 =?utf-8?B?Ty9EQnR3MkZac1BibFRVaFBvWWFNeTd5cE9SemZJcGlLcmNTMUluY1FJQjJL?=
 =?utf-8?B?WVRmSmNTYThnc1dQa2pGU3RnMndLNUVTM053QkVjbkF3R3VIcmNibTFDcnpw?=
 =?utf-8?B?MDBwV2c2Z28wUlBWZEdBUm1KZTJnaEltTVNxaWhkVmMxOFdEZHJSbFZTdlZR?=
 =?utf-8?B?T0grYUFMUXdsRmZJdE5mYTJpSVNhbVM5bVl3eHlYT2phVEZiSkhvTkFPL2NI?=
 =?utf-8?B?M0dzOVVoaGNMRlQwTnMwS2twNTMzSGxIcDZHblgzS2t2Y1lORlVkQit5eU45?=
 =?utf-8?B?MnBrRnJPMUVTUndnWVVRMk93U2Z1endHZ2oxUGxTeTdReFVsUTBCbGhITklX?=
 =?utf-8?B?OGJUWWZBVlhqbjZxRW1vZ3VVemttQ2g5WFV0K2hrM0EvL0hsK0VzazFMTGFJ?=
 =?utf-8?B?a2w4QkhvOWxTV280dTdaeG90UTJEa3lvZE5pWTZxbnpPVjVzeDErdzBqbTdU?=
 =?utf-8?B?SkNoZVgwWFdmRzluSjV1Y3RpaFhrMWRMUUVBZGMxWE1wNXNlaXFkSzA3cHZa?=
 =?utf-8?B?N2tzTWM4alZGbXQ4RnZCVGlzY3k5RVI5TFBQek5nWitQS3dBdGZ3dWFvS0R0?=
 =?utf-8?B?ck1WSEl6ZUZ1NmlKUW95anZBb1c2T0JNaDJaYTBuVnAyRjFRdEF6ZkRMYlBp?=
 =?utf-8?B?K1haeTFjOGJESXNqcHVrUDdBbERhZlVSVGdZZ2Q1YVVlYkpwdXZ6SmJoY3J2?=
 =?utf-8?B?OHdWa2pLMytyZ1lTYzV1bWZQTUlLaFlENGFZUEhISWlsQXE2a2pzak5LOXRX?=
 =?utf-8?B?NkdMSG5HNXpwZWlEM0FvTTIyeTNrQjQ0aHhLN25yb0RBL0hzWnQrN1FLNC9B?=
 =?utf-8?B?SnBiR0ZsbGorTDRzcmorRlNJSHU0ZndhVFR0TXF0WkhMa0ZTOHVIbXhFTnVQ?=
 =?utf-8?B?Q3hrbENJaUd0dVNUQUNLK3hmWGpIb3RkRWxjbXdFeGhtZVVRVmM0VVhFbzdo?=
 =?utf-8?B?aXduYXZQb055cWxYVXFvbGxkOU4ybGErcy80VHZyWmVXekVHMjRkTGliSXAy?=
 =?utf-8?B?K21qUitMNTUwK0VRNkxodlAwdHljT3p4U0RYczN2bmxZQ0lybjg0OHVIQ3Bi?=
 =?utf-8?B?dHh3aUw2UUdRUVZFU3FpMEcxS2lNM3Q1OHpFbmFPODgyZ2RNT291eGs2cEN1?=
 =?utf-8?B?NWtFMExrSmZvR29JdkNsWGh2ZzRySFk3UkQzQldaVi90SmpRTUk4TlphVlhJ?=
 =?utf-8?B?TWdVUUNPcithL056QTQweEhNdmdPY1dneUxPOHdUdkp0QkdCbDZ0cFFkdXZT?=
 =?utf-8?Q?J5PV/TWMRHjMdso3U+e4nN6A7iqqJEk+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3VtSEp6Ty93NEw1ZW9OdnM5eXVjOHozekxjQ0ZNeEZUR2VhRElaMllPMUZC?=
 =?utf-8?B?L3RFVjF2a01aSjBvMUo5WnZsMzlsSU9SM094OEUvZmlzN2Q5KzZJLzFYcmJC?=
 =?utf-8?B?ZlN4cVpQQ01qb0tNRnBqVXVGVDZQdmpSZmt3VzRnYWsvNnJTRGh5NExQR3RB?=
 =?utf-8?B?Z0h3NDVYVkV1d1FOcmlFejNSRXovR3d6UzV2VmEzMzYwSVZEaVhLNXFpMklY?=
 =?utf-8?B?SlRVcmxZU3R5QXBWQVZmVnNPNEpzN3FJNmJ4VTl6R1JLRStxV0xlWkswVnRN?=
 =?utf-8?B?MUNyRWJZOEtNR1JXSVp2cDlzUzZ1bE1MR25QS1N6VHlNbTNGV0JZZ0RaT3Fo?=
 =?utf-8?B?SzJXN1ZMRzdXYUZuajE5emU4a1pZMVBiSm9HVUYyN0FoYmdBNG9xOXhYbksv?=
 =?utf-8?B?dGkvTTRManJHRi9DbVQ5NnpQVnpCajRGSXVvL1pFeXJuWFVpMlcrWUkvTG1j?=
 =?utf-8?B?SENNMUVLNmlSR2Z5NFZEWUV4VWErN2U3dVJVelA2WTdoS3NiaE53MEgrNllN?=
 =?utf-8?B?Z3BOa3VjbGtLOVJULyt5SGRETHRmUEhIdTZENHR2WDUxYU1iNDRoK1EzZDUr?=
 =?utf-8?B?VG5ydUVUSmlVY1Z1cnY4K013TlRRYlZrb2Z3bFJVeC9JL0J0MmhkZmZleTUw?=
 =?utf-8?B?NlpIbHcyZ2Nwc0U4WkUvZUh5Tm04Z01kblZvN2N6VjlJcXJZd3dBUUJUMjkv?=
 =?utf-8?B?QWlhWi9PRktXcmE0QlFxczNXeFplcXZ1SXdPQWhlb056OUNOWmxpRFVSWnVl?=
 =?utf-8?B?NFFmd0VHQjU0UTJ6TzZFb05PVFVRc1FxVGdYRU44RnAvV3AybjVnMzJYbEpM?=
 =?utf-8?B?dFBCa0ZSVzFPRktKWWtJVk5MTmM5NHNCWUJPVWJqSGJBYzlBYjlxUFhCd3Vv?=
 =?utf-8?B?b3E3bVE0R3R6R3VxM3FuZFB6N2t4M055M282RHdhQW1JblFvWi9NVjNoRHZB?=
 =?utf-8?B?UnpzdnpTRVVqU1pZak9udmFYcnNzKzBsaUxFK1FZZnQwYktTd3ZPdVNsVlVz?=
 =?utf-8?B?VjQ0M2MwNmx6dDFZQlFYZk1rM1BXalQ5QmZFRlFBQVJmT2ZrMkhqR0NKb2hr?=
 =?utf-8?B?R1R3clJJUTVUZHZ5OThWUHBhOFVOK09nQmV3MS91SjZiakZZQ1k4aG9RSmh2?=
 =?utf-8?B?MWtvZy9QVzBESFhqK0V3d1k4NGdHWDdmQ05ndXlETjVSM1o0NjFCbm1VVDlM?=
 =?utf-8?B?RWlIV1hxSC81dnVQMDVFZjhLN3pZdGNkZUdHN2M2dE90cVFUZ1BPYjRaMXha?=
 =?utf-8?B?TE52ajhSQS9XT2plYzVuWWh5VnhOZFdzNzNHRjQvZUs0dGRGTERIMWd2MllY?=
 =?utf-8?B?WjNuLytvWTZxTHA5QkdCdmFSTjc2RmxmRjZDVFBscDhRdmt3NVduSERJSzla?=
 =?utf-8?B?YldZSWM5WXVsd1NJeW5RcWNaVzVGOUpKUFltbEgzVVZzTW15RzFsMERDRS9T?=
 =?utf-8?B?d3hHcU9tV2xPa0tlQjdGQkxhdWNEOUVVV3dZM3dIRS9ZT2F0NXBwUDkydWJt?=
 =?utf-8?B?OFlKRlAwQ2NucG1JV2RielhtazNiTXl5d0hubXU2QU9MMnRkRUVGZC9MYzdw?=
 =?utf-8?B?dHFxR1ZHZHNzRlZQeVNLYUZzMEhSOUIrOTRjU3NicEVnSjJFaHhFcDkzYnNs?=
 =?utf-8?B?LzRpTUpIQnIzMjM0OEo2U2tDVEdzQ1dGTWpwT290ZzU3L1BOQnJXdGczRTJ5?=
 =?utf-8?B?cjhtVEl2Q1cwS014ZG1vbHp1RnBscEowcTJIMzhGbEk0a2dNanJ5ckNjYk5R?=
 =?utf-8?B?MGVVTDZwc2xNYXNsWUdMYjU0eFhGRzQ4SXZaRHEzdVBOOVZGUE1CQzBhRzBi?=
 =?utf-8?B?VnJhb0c4TFpPQjNXdXcwdnJYTzlPMmxYQVZSeUo1TU5UbFlETzhWSVJqQ2Ry?=
 =?utf-8?B?TjNkb2Z3bjhWZEdJS3k0dnlkWTNiZEtzSEhjU09tYW5Pd1plVHFJdTlQMmZQ?=
 =?utf-8?B?TWdmZmF4U1NPUTdPN3VMc3hVWjk0OHkyMTRkL1d2QnJrV3prY1RtTFd5a0NM?=
 =?utf-8?B?STkwY1NlNkNYY25hRnpwV3d0ZnNHem5Ta0xOdTBBMlZRZllnYUhHcTUwdTV0?=
 =?utf-8?B?ZVNwN1NTOXVrY21OckdvbXhYRjd0cnZkNTV4S2FGNTRHTStzSlBPQ1UveEcy?=
 =?utf-8?B?Y2ZDdmM4bVNsU2VGUjVsM0pwNWhtT2MwL0dRenN2eXhZL2RHczRFcXFRL29N?=
 =?utf-8?Q?11kq1e8HoQWKRNNWNLn9v4hBMa3WzX9ZDmXHM0dj1GUs?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c8abdc89-8974-49ac-cc24-08dd766a2c6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2025 06:54:14.0315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wOJ56jLIX3M5oyHensx7WuLqp7aAWSks9tlOU85iDgl3FQuiX9h5ya08cSZNrq/Xted9yYCbxfAR4XKjLTJ549xKtOJmL2NjjMmdyHeU3zg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8866
X-OriginatorOrg: intel.com

PiANCj4gT24gVHVlLCBBcHIgMDgsIDIwMjUgYXQgMDk6NDA6MTRBTSArMDMwMCwgSmFya2tvIFNh
a2tpbmVuIHdyb3RlOg0KPiA+IE9uIFR1ZSwgQXByIDA4LCAyMDI1IGF0IDEyOjA2OjMyQU0gKzAw
MDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBPbiBNb24sIDIwMjUtMDQtMDcgYXQgMDg6MjMg
KzAwMDAsIFJlc2hldG92YSwgRWxlbmEgd3JvdGU6DQo+ID4gPiA+ID4gT24gRnJpLCBBcHIgMDQs
IDIwMjUgYXQgMDY6NTM6MTdBTSArMDAwMCwgUmVzaGV0b3ZhLCBFbGVuYSB3cm90ZToNCj4gPiA+
ID4gPiA+ID4gT24gV2VkLCBBcHIgMDIsIDIwMjUgYXQgMDE6MTE6MjVQTSArMDAwMCwgUmVzaGV0
b3ZhLCBFbGVuYQ0KPiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiA+ID4gY3VycmVudCBTR1gga2Vy
bmVsIGNvZGUgZG9lcyBub3QgaGFuZGxlIHN1Y2ggZXJyb3JzIGluIGFueQ0KPiBvdGhlcg0KPiA+
ID4gPiA+IHdheQ0KPiA+ID4gPiA+ID4gPiA+ID4gPiB0aGFuIG5vdGlmeWluZyB0aGF0IG9wZXJh
dGlvbiBmYWlsZWQgZm9yIG90aGVyIEVOQ0xTIGxlYXZlcy4gU28sDQo+IEkgZG9uJ3QNCj4gPiA+
ID4gPiA+ID4gPiA+ID4gc2VlIHdoeSBFTkNMU1tFVVBEQVRFU1ZOXSBzaG91bGQgYmUgZGlmZmVy
ZW50IGZyb20NCj4gZXhpc3RpbmcNCj4gPiA+ID4gPiA+ID4gYmVoYXZpb3VyPw0KPiA+ID4gPiA+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiA+IFdoaWxlIG5vdCBkaXNhZ3JlZWluZyBmdWxseSAo
aXQgZGVwZW5kcyBvbiBjYWxsIHNpdGUpLCBpbiBzb21lDQo+ID4gPiA+ID4gPiA+ID4gPiBzaXR1
YXRpb25zIGl0IGlzIG1vcmUgZGlmZmljdWx0IHRvIHRha2UgbW9yZSBwcmV2ZW50aXZlIGFjdGlv
bnMuDQo+ID4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+ID4gVGhpcyBpcyBhIHNpdHVh
dGlvbiB3aGVyZSB3ZSBrbm93IHRoYXQgdGhlcmUgYXJlICp6ZXJvKiBFUEMNCj4gcGFnZXMgaW4N
Cj4gPiA+ID4gPiA+ID4gPiA+IHRyYWZmaWMgc28gaXQgaXMgcmVsYXRpdmVseSBlYXN5IHRvIHN0
b3AgdGhlIG1hZG5lc3MsIGlzbid0IGl0Pw0KPiA+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+
ID4gPiA+IEkgZ3Vlc3MgdGhlIGJlc3QgYWN0aW9uIHdvdWxkIGJlIG1ha2Ugc2d4X2FsbG9jX2Vw
Y19wYWdlKCkNCj4gcmV0dXJuDQo+ID4gPiA+ID4gPiA+ID4gPiBjb25zaXN0ZW50bHkgLUVOT01F
TSwgaWYgdGhlIHVuZXhwZWN0ZWQgaGFwcGVucy4NCj4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gPiA+IEJ1dCB0aGlzIHdvdWxkIGJlIHZlcnkgbWlzbGVhZGluZyBpbW8uIFdlIGRvIGhhdmUg
bWVtb3J5LA0KPiBldmVuIHBhZ2UNCj4gPiA+ID4gPiA+ID4gPiBhbGxvY2F0aW9uIG1pZ2h0IGZ1
bmN0aW9uIGFzIG5vcm1hbCBpbiBFUEMsIHRoZSBvbmx5IHRoaW5nIHRoYXQgaXMNCj4gYnJva2Vu
DQo+ID4gPiA+ID4gPiA+ID4gY2FuIGJlIEVVUERBVEVTVk4gZnVuY3Rpb25hbGl0eS4gUmV0dXJu
aW5nIC1FTk9NRU0gaW4gdGhpcw0KPiBjYXNlDQo+ID4gPiA+ID4gc2VlbXMNCj4gPiA+ID4gPiA+
ID4gPiB3cm9uZy4NCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gVGhpcyBtYWtlcyBpdCBu
b3QgbWlzbGVhZGluZyBhdCBhbGw6DQo+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+IAlwcl9l
cnIoIkVVUERBVEVTVk46IHVua25vd24gZXJyb3IgJWRcbiIsIHJldCk7DQo+ID4gPiA+ID4gPiA+
DQo+ID4gPiA+ID4gPiA+IFNpbmNlIGhhcmR3YXJlIHNob3VsZCBuZXZlciByZXR1cm4gdGhpcywg
aXQgaW5kaWNhdGVzIGEga2VybmVsIGJ1Zy4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBPSywg
c28geW91IHByb3Bvc2UgaW4gdGhpcyBjYXNlIHRvIHByaW50IHRoZSBhYm92ZSBtZXNzYWdlLA0K
PiBzZ3hfdXBkYXRlc3ZuDQo+ID4gPiA+ID4gPiByZXR1cm5pbmcgYW4gZXJyb3IsIGFuZCB0aGVu
IE5VTEwgZnJvbQ0KPiBfX3NneF9hbGxvY19lcGNfcGFnZV9mcm9tX25vZGUNCj4gPiA+ID4gPiBh
bmQNCj4gPiA+ID4gPiA+IHRoZSBfX3NneF9hbGxvY19lcGNfcGFnZSByZXR1cm5pbmcgLUVOT01F
TSBhZnRlciBhbiBpdGVyYXRpb24NCj4gb3Zlcg0KPiA+ID4gPiA+ID4gYSB3aG9sZSBzZXQgb2Yg
bnVtYSBub2RlcyBnaXZlbiB0aGF0IHdlIHdpbGwga2VlcCBnZXR0aW5nIHRoZQ0KPiB1bmtub3du
DQo+ID4gPiA+ID4gZXJyb3INCj4gPiA+ID4gPiA+IG9uIGVhY2ggbm9kZSB1cG9uIHRyeWluZyB0
byBkbyBhbiBhbGxvY2F0aW9uIGZyb20gZWFjaCBvbmU/DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBJ
J2QgZGlzYWJsZSBpb2N0bCdzIGluIHRoaXMgY2FzZSBhbmQgcmV0dXJuIC1FTk9NRU0uIEl0J3Mg
YSBjaGVhcCBzYW5pdHkNCj4gPiA+ID4gPiBjaGVjay4gU2hvdWxkIG5vdCBldmVyIGhhcHBlbiwg
YnV0IGlmIGUuZy4sIGEgbmV3IGtlcm5lbCBwYXRjaCBicmVha3MNCj4gPiA+ID4gPiBhbnl0aGlu
ZywgaXQgY291bGQgaGVscCBjYXRjaGluZyBpc3N1ZXMuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBX
ZSBhcmUgdGFsa2luZyBoZXJlIGFib3V0IHNpdHVhdGlvbiB0aGF0IGlzIG5ldmVyIGV4cGVjdGVk
IHRvIGhhcHBlbg0KPiBzbyBJDQo+ID4gPiA+ID4gZG9uJ3QgdGhpbmsgaXQgaXMgdG9vIGhlYXZ5
IGhhbW1lciBoZXJlLiBIZXJlIGl0IG1ha2VzIHNlbnNlIGJlY2F1c2UNCj4gbm90DQo+ID4gPiA+
ID4gbXVjaCBlZmZvcnQgaXMgcmVxdWlyZWQgdG8gaW1wbGVtZW50IHRoZSBjb3VudGVyLW1lYXN1
cmVzLg0KPiA+ID4gPg0KPiA+ID4gPiBPSywgYnV0IGRvZXMgaXQgcmVhbGx5IG1ha2Ugc2Vuc2Ug
dG8gZXhwbGljaXRseSBkaXNhYmxlIGlvY3Rscz8NCj4gPiA+ID4gTm90ZSB0aGF0IGV2ZXJ5dGhp
bmcgKmluIHByYWN0aWNlKiB3aWxsIGJlIGRpc2FibGVkIHNpbXBseSBiZWNhdXNlIG5vdCBhDQo+
IHNpbmdsZSBwYWdlDQo+ID4gPiA+IGFueW1vcmUgY2FuIGJlIGFsbG9jYXRlZCBmcm9tIEVQQyBz
aW5jZSB3ZSBhcmUgZ2V0dGluZyAtRU5PTUVNIG9uDQo+IEVQQw0KPiA+ID4gPiBwYWdlIGFsbG9j
YXRpb24uIEFsc28sIG5vdGUgdGhhdCBhbnkgYXBwcm9hY2ggd2UgY2hvc2Ugc2hvdWxkIGJlDQo+
IHN5bW1ldHJpY2FsDQo+ID4gPiA+IHRvIFNHWCB2aXJ0dWFsaXphdGlvbiBzaWRlIGFsc28sIHdo
aWNoIGRvZXNuwrR0IHVzZSBpb2N0bHMgYXQgYWxsLiBTaW1wbHkNCj4gcmV0dXJuaW5nDQo+ID4g
PiA+IC1FTk9NRU0gZm9yIHBhZ2UgYWxsb2NhdGlvbiBpbiBFUEMgc2VlbXMgbGlrZSBhIGNvcnJl
Y3Qgc3ltbWV0cmljYWwNCj4gc29sdXRpb24NCj4gPiA+ID4gdGhhdCB3b3VsZCB3b3JrIGZvciBi
b3RoIG5hdGl2ZWwgZW5jbGF2ZXMgYW5kIEVQQyBwYWdlcyBhbGxvY2F0ZWQgZm9yDQo+IFZNcy4N
Cj4gPiA+ID4gQW5kIG5vdGhpbmcgd291bGQgIGJlIGFibGUgdG8gcHJvY2VlZCBjcmVhdGluZy9t
YW5hZ2luZyBlbmNsYXZlcyBhdA0KPiB0aGlzIHBvaW50Lg0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+
IFJpZ2h0LCBmYWlsaW5nIGlvY3RscygpIGRvZXNuJ3QgY292ZXIgU0dYIHZpcnR1YWxpemF0aW9u
LiAgSWYgd2UgZXZlciB3YW50IHRvDQo+ID4gPiBmYWlsLCB3ZSBzaG91bGQgZmFpbCB0aGUgRVBD
IGFsbG9jYXRpb24uDQo+ID4NCj4gPiAiSSBndWVzcyB0aGUgYmVzdCBhY3Rpb24gd291bGQgYmUg
bWFrZSBzZ3hfYWxsb2NfZXBjX3BhZ2UoKSByZXR1cm4NCj4gPiAgY29uc2lzdGVudGx5IC1FTk9N
RU0sIGlmIHRoZSB1bmV4cGVjdGVkIGhhcHBlbnMuIiAtbWUNCj4gPg0KPiA+ID4NCj4gPiA+IEJ0
dywgZm9yIHRoZSB1bmtub3duIGVycm9yLCBhbmQgYW55IG90aGVyIGVycm9ycyB3aGljaCBzaG91
bGQgbm90DQo+IGhhcHBlbiwNCj4gPiA+IGNvdWxkbid0IHdlIHVzZSB0aGUgRU5DTFNfV0FSTigp
PyAgQUZBSUNUIHRoZXJlIGFyZSBhbHJlYWR5IGNhc2VzIHRoYXQNCj4gd2UgYXJlDQo+ID4gPiB1
c2luZyBFTkNMU19XQVJOKCkgZm9yIHRob3NlICJpbXBvc3NpYmxlLXRvLWhhcHBlbi1lcnJvcnMi
Lg0KDQpPaywgc28gdG8gc3VtbWFyaXNlIHRoZSBhcHByb2FjaCBJIHdpbGwgYmUgc2VuZGluZyBp
biB0aGUgbmV4dCB2ZXJzaW9uOg0KDQpJbiBjYXNlIHVua25vd24gZXJyb3IgcmV0dXJucywgaXNz
dWUgRU5DTFNfV0FSTiAodXNlcyBXQVJOX09OIHVuZGVybmVhdGgpDQphbmQgcmV0dXJuIC1FTk9N
RU0gZnJvbSBFUEMgcGFnZSBhbGxvY2F0aW9uLiBObyBvdGhlciBleHBsaWNpdCBpb2N0bCBkaXNh
YmxpbmcgbmVlZGVkDQpzaW5jZSBub3RoaW5nIGNhbiBwcm9jZWVkIGFueWhvdyBpZiB3ZSBjYW5u
b3QgYWxsb2NhdGUgYSBwYWdlIGZyb20gRVBDLg0KDQpEb2VzIHRoaXMgc291bmQgcmlnaHQ/IA0K
DQpCZXN0IFJlZ2FyZHMsDQpFbGVuYS4NCg==
