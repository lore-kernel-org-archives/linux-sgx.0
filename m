Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6473F18A6C1;
	Mon, 24 Mar 2025 12:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742818812; cv=fail; b=V6PKGVH0jRWi45M5e+x+GqOeNqdFTHgi8IyLhiVqscpMPMpVnsy1OIxLUKkt8O51yPYmWgrWgBMmzKz29/TQNvxunVdWXBmpq0HOXLumPulb0hVVZfHfLoAB8mPf29TY4fR0SQQftD4nHsMxi38bxt3p6psTM6oww4v8cRYeQ34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742818812; c=relaxed/simple;
	bh=oVXquj5e0DRmXpeojQlQQKNlCBGhcZbMlX1HyGLbUAM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K9N8X4nl5ZrZEKQg9ZixyTh14t16Nmm98d+O3b7p9jTOW7qZlt3F39F2ZIpAdopF9VbZrleAObmh0y4gBw3NONBVWVCTnPSiv7Gl0Jdzsv+/Zdmtq1eqOCC5jBFSuIdrVEBiI+XugtErRrM04hDFUTNmljM/ClQy+bEUnUPCzEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NAFeLqqN; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NAFeLqqN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742818810; x=1774354810;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oVXquj5e0DRmXpeojQlQQKNlCBGhcZbMlX1HyGLbUAM=;
  b=NAFeLqqNm73/oEIQKCw5ZH8RtBkvh1930J27pc2ake798r7FlrZd0yIf
   3VvY2Xx7R2ItL8cmU1BSlVitUE4M4cxt7bGZB4sffdqmHSiIvwPzKeoa8
   //vKgTvSPTNGKlpaJm8pLoEA6Ytoideq1GI/ei7x5mwD3M/1DS/s7akul
   pTcbCXndEAsLgSKFyfJrK8lLPQMc4ABvU2zaG2Eqc+JTqiHYqVXxmjC3O
   63CkauW/nn2AkG3me9RYP+wobXIo8H2n5RbniQDcrELj4+1OUZNylPd4q
   /0l+iZOHlzmoXzCybsbmP2koSGEUL/E4hi0d0jD13PpLnAugfMGlntYiu
   w==;
X-CSE-ConnectionGUID: /VXewrFlRvCP+fAt+jC4aw==
X-CSE-MsgGUID: 5WwTGSd0T/Oh5KlYm8qy6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11383"; a="43748138"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="43748138"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 05:20:09 -0700
X-CSE-ConnectionGUID: 68bPNv9gSUSOGUSNkaZP/g==
X-CSE-MsgGUID: G/V1uWE1TOC6og7K7CtN3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="124020006"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 05:20:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Mar 2025 05:20:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 24 Mar 2025 05:20:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Mar 2025 05:20:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2JQ91zLV2racyLFULHJXH4FWBbRVOEtkbp04N1c+Zf19Z2MMqi4tzy4Pn01/c5fIYmP4UcaEDB4m98wE2wHMKUYJBTyxnIX1D6gHVPbF2xIXaWUJsSjYp30ANZueChZ2H70l0iMfdUPKrto8PAfkC9hmyAZRTlcMGxB8ffOfjQcAD9BVCXi7npnlE1jp9nLEOoKe7Eawj/b8PHluLwmM6noFc0XVvX96UVtKOQwDTUDSLWCrmI90oKd1vQ6sYGreB4B78bgp6MqejBKkx9fE11xVFtBVVWnEkPzfw6iUru+kewFZwvPZe2+XtvDat4DctHo5fR0cg4q8ywhdkI5SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVXquj5e0DRmXpeojQlQQKNlCBGhcZbMlX1HyGLbUAM=;
 b=wmPMy5+IYebR6ojLO5kbkQOdQItWHWxNwA8I8zjqea2xLptG4E+NInAnAxnATwDPY1Q3gE5ALA1dPyqeSFk5+AruOfQ1dsM+zT70iQvDBDHqyvtNw6Su1TxpHhSJ1bABKsJX6hvHwapNflajU4PelbAJUI5gXgKzOJhrM4JGaScpOKYJRsVS4WvFvkB4ypS/HOek53YJR+hvCjPBV+p3UhHH/MrG16lR9LvPw504SrYSm01oQ5OjMFRN1bjARYGRRTrqEBQQRimx7WvIFPLLqA941dbuYvtZ4Q73Ir02/PMTVN83Z0/GuS77EpCb1tPwUYto4n363k5X3aBLOZ8J0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SA1PR11MB6992.namprd11.prod.outlook.com (2603:10b6:806:2b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 12:19:37 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 12:19:37 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH 2/4] x86/sgx: Change counter sgx_nr_free_pages ->
 sgx_nr_used_pages
Thread-Topic: [PATCH 2/4] x86/sgx: Change counter sgx_nr_free_pages ->
 sgx_nr_used_pages
Thread-Index: AQHbml5v6wUxy5pYpkGncBs5Qx0PeLN/udYAgAJ9lCA=
Date: Mon, 24 Mar 2025 12:19:37 +0000
Message-ID: <DM8PR11MB5750B9CBBB7A51CE3A0F006AE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-3-elena.reshetova@intel.com>
 <Z981ciAqpknQ3hRF@kernel.org>
In-Reply-To: <Z981ciAqpknQ3hRF@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SA1PR11MB6992:EE_
x-ms-office365-filtering-correlation-id: d2c6e319-49a5-4eb5-57f0-08dd6ace2541
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dHRGb3hGeWU4ZmdPVXZsUFVVK2htemNMcWZIRzNRckVjS3JkV1orTFRjb3hs?=
 =?utf-8?B?MENsS2JFanFmNUlOZzRRSDZOd01lT01WOWFPUFZSWk5Xdm9PeE1ZV1dyS0d0?=
 =?utf-8?B?NFlSZW1mQ2NPY1FFaUVxYnNXV3FJeTV6ellsWi9wUFM0NStvKy9aOE5kdFZ6?=
 =?utf-8?B?QmhTMlVMZ3ZEbndKc1k5YkFZQVlUaWdIcnFZcklhaDJObVRRUmxWWVRuSkJG?=
 =?utf-8?B?ejZXdmV3VnIzS2Y3VWF0dEZUbGExd3FPQjlEVEN4YlNBQzFQZmxZTjZPQXMy?=
 =?utf-8?B?b3lRdmVzdjNPbjNOeGF1dEFTdHk5WFI4YjczVGEzcDE4Q1UrNTNtdHFndERK?=
 =?utf-8?B?dHZQb0I0KzI4T041ZTgvS3dDTnJNVDV3YTlNa2JTd3Q3UDdnSWlPcjl2UGlv?=
 =?utf-8?B?NnBaa2N6UWg4K3lKUXpEcUpEOG9xUzhwYXZGRGlOMHU3SCtxOFcraS9QRE1R?=
 =?utf-8?B?ZFlXUklQazFCTm1vMklHcFlaTTdSZjdpOExGMGR6eHBVL1pMRTViMmNoQ1RH?=
 =?utf-8?B?YWZFV3B5M0lXMVk3THhDNEhycS94VlFydTlPNGxFM1hFWHVwNU1yQ0Z4SDFO?=
 =?utf-8?B?S284VGIyWHNnUnorTGp5WmEwd2VCUWw0RmtGRXZzVHZEcExZL2MwclpWT0N2?=
 =?utf-8?B?azVYTWtLL1JFUGhrMmVySGh5V3dmRmtzeXBUbldNamlCdHk0RlB6TXpkRWxn?=
 =?utf-8?B?bng4cGFSTTlsczU0Q2NZRDJjOTc2Ti9VUnhXVnE3SkRNMkUzSEd5V05meU92?=
 =?utf-8?B?bkphanlaRWxFZWVSM20xZndaSmFPbFptNU1mMFRUeGV4K0RwSmlWZVJPSWI0?=
 =?utf-8?B?VEI2UHlRZHd2cVdjTXNseFIvcUU5UGIyeksxdGhBTXhjR0x1V3ZJOFpVNm5J?=
 =?utf-8?B?NGMwZnhYQWsrbmpvUWMzbUp6WGFvbVZMZzh6N1BsVmJGQnU2ZHlDcWdXUVMw?=
 =?utf-8?B?enF5ckhPVHptSlNGMitqRDlYUEpqOUpZOEZrMzFBUjdERzZxR3dmNDBsZlho?=
 =?utf-8?B?SFp5ZmQycWs4YzdydDFUc2hBYjM1Q29zMmo1Qi9wejUwcDJnZ1krVEU5Qmda?=
 =?utf-8?B?S2dzYW5WQVJxYnlTdlVwRmVsZzl2RjdocEVZMlc4Wmt4VkJMUkloaUd1K2dW?=
 =?utf-8?B?S01PWkxHRGw4YjJ5UGtsYVRVTkpZU2pMRXVzQUtjWGE3cngrUkVsaStIMWxR?=
 =?utf-8?B?OEJmVXJXZGVpc1dNa3lwWjNlV0ZHOUY0cjJHRHpRNnE4NVZHY3ZMa0lmS1BE?=
 =?utf-8?B?UE8wZlhseWxYdEdOa2ZvT1hLbmF5SUI0K2cyWHA1UzBvT2dvbG1RbU9wRnk3?=
 =?utf-8?B?dmhERUo5RHlYeXkybW1oZDc1Mlp4T2ZMaWwvTVlDbWQ2dnVLQi9iUENOSW9S?=
 =?utf-8?B?c09sdVY5RTZGR3YxMzJRN0dFZkZsZnI5SHJleURLMW8rdTY2Sm5uZ1RUSk5h?=
 =?utf-8?B?M1ZtTml4bGk0TTdOWTM5dGlsblh1NVYrV09jRFdVTitlcDJMaTZQQWw3MkJV?=
 =?utf-8?B?cjkvZXNVNjJ1c2txTm8xWCswenc0dGtzVXdBYU5acmcrTFM2S2UvUHJYNWlT?=
 =?utf-8?B?dzVJZzZocjhIZHFYM2xadytGMVdsTkRJUnJEWWtTK3JNQkliN0xPeUtQR2ZL?=
 =?utf-8?B?YWdnNkVWN0RVb3liV0hidVRsbEpmZzY0UlRvYnMrQTh3RnhCRWZpQndpMlhh?=
 =?utf-8?B?QmVHb3B3VFJOLzJ1VWEzL05NWnNwWEJZdzlyQ0hrR1BOUXVOL3NVSUJSaHhj?=
 =?utf-8?B?OWpNS1BaZXRuN2J6VlMyRG5uL1lrVi9UMWY1azZ2OHRmSm96RlhsVEFVMXNp?=
 =?utf-8?B?R2U5TldNVmJNTmRGcnhleGxiSlFYMDBCb0JpQ2I1VHZjYk1iK3ZZeE1nNkg2?=
 =?utf-8?B?eUFvUzZHNmtnekVJZjdNYW9kZmRZbFIvWUFYVitIMWxCdHpCcTZ3YlFUUm44?=
 =?utf-8?Q?DxEi4K7kcxi9eQTM3dxZ36pG++HKJHY0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkF3b0ZPSTBmbjByZnkrNmdBYnRSZEQ1c1lQN1JiUy9IZ2dYYktRMXdXdXda?=
 =?utf-8?B?ekczWTcwamhJWWE2aGFEK2MwV0NMVEV2Wm1sZE5wc0pVWjJYUUZkQ3lxQW5o?=
 =?utf-8?B?aHdSSlViUlBjVkdGeFFuU1ZlT3ErVnYzMW96UVp0cUJVcVB0L3JPWW9zUk5N?=
 =?utf-8?B?bEw4TkF1dUY0QUttTU95NHJWTEZYUmNNODMyQ1NiTFNabW1INTcvbEMvQVBa?=
 =?utf-8?B?bmhMeXFaN3FyUjJSWFBFYXRpUUpJZkl1VGFuMVUyOFhiMWxyL2ZQK1l0Sytp?=
 =?utf-8?B?dERnTzFwUmltdHI2bzlsczZmRGluSGp5Z3dVeSt1azJ6TEYxOERJQzRIVjh4?=
 =?utf-8?B?L2ZPM3l1bDhmSnlWQ2p4Mnp4eXRCTi9RTGlhMHg0MUFEZVRDZnpSZ0NCUGdM?=
 =?utf-8?B?SXRLWkZvVlY5THUvTlRrMmt0Zm1RWkpkOVJPTXRXMjRJczNMLzR4SCtnYUND?=
 =?utf-8?B?dFBRT3RnTXNJSzk5OWh5WVlNSmRBREhqd2J3dytDMUxGcUdlZFhCTkRYcTVF?=
 =?utf-8?B?TmY5V05xcVNqckdzWmpycDc0QjBQL3BFdm5DNnNIQ3Y4djJuMEY1L0ZBdnpr?=
 =?utf-8?B?M0pFcFJyaXlUazZzOUpDWENxT0txNUUxYWVteWVQamtNWCtJVTl0bnEzVWNj?=
 =?utf-8?B?ZmcvdjRENXVyQ3grQmZxYlgrSmc5dXdWeVV3bEJRS3NOamFLbTFzYlZmWDA1?=
 =?utf-8?B?QkwvWVgwelFTdEFOcFJtRlJHOTV5d3U3WEdGdVZQNE1MWGovNXZ4ZGQ5VVBR?=
 =?utf-8?B?SVNDN3Z3MlcreFU0ZkF1Snp3UWFLRW5Kc1ZKNmJnSkVZL2dGMk9PeDJJRWdU?=
 =?utf-8?B?aVhtZHBwMDUxcmtwUkxQc2xZZDdNRmFlVmJVRWFIWmRJazIwc1BqWmxyeGZa?=
 =?utf-8?B?WUVTeTRUS2FrcURVUnFDR0M2SzFvSjh6Vjh3Z1hsaW4wcmErYWl1SFEwbyt3?=
 =?utf-8?B?cDN4NmE2MjVSQkNLa3UyRlRNS1lKazJ5MG1jNGtGNnlBc1l5c2gvdlJNV2dZ?=
 =?utf-8?B?bXlwMHYwT2l5SGNOMnNqUmJReG04dE9qVmQ5aXNxdUxSQ3Q3UlVGRkZSQUhR?=
 =?utf-8?B?UnNyd0ZlcStSUFc2SHh4VmxYS3ZhYlZic0kwM1ZMcFAreVFwVkpRTWduZHlR?=
 =?utf-8?B?ZldBbFRvNjhGZmJrZUR4WDBzZEhyZXZTVTgrWlNHQWtkZmhGNFM0YlZoSHB1?=
 =?utf-8?B?NXJWVzdCVGhQOHlBMEdUYUJKMDlDZE4wRG40bEs4VXFIME9JdFprdTBodzZB?=
 =?utf-8?B?QVJXM3Y3QytSYWMyQklMcnRjd0t0VDU0Nks4b0ZueGpmSmVPN2VaZzhPdklQ?=
 =?utf-8?B?U3NxQUNQMmRTTkdNUk14SFVsdFA0Snhkenl6bXhDWW4zQTQ0TDEzbTN6OXpY?=
 =?utf-8?B?UTBKMDlKcTFHTllHV3lscVRsTXRUOG92TFZ6Q1orVGF4YWRMTXRDY3RGZkcv?=
 =?utf-8?B?T0hPbWZkVHdYckFDanY1cGM2aWZtdjVTNU1wczlSdXNwZmZhWjFRNFZuMHlZ?=
 =?utf-8?B?SGNVbm5DSHQyK2Y3UTBYNGFRZkhCRy9zZGVNemhRdStEdVRTeWZ2em5CSEc3?=
 =?utf-8?B?d01udE5SV01aM2VJK2NOd2VONzE3Vmp4WXJXclhFY1hjQms0c2IyN1dGaCt6?=
 =?utf-8?B?RFdWTk1vQ2cwaHRoWWNveDJBQlZGekQ0VnZpbm10VTN2Z3VkMUFnK0NXV0xi?=
 =?utf-8?B?cmQycGNzU1ZpTUduTForM1E0TUJiWFNZd0o4aHIyc3NpTlcvYTFkV1JsYUhG?=
 =?utf-8?B?OWQzODJVZFk5S1FqdG9BTVBWM0dvOGdoNkwvYUtJZElMWW8zbDBvbGhiYVFD?=
 =?utf-8?B?Y2c0dzM2cTg4Z1hBSVhvUVU5U21FaWlrVzhQTThBcHhnbG92L2dXYjl2Wkx2?=
 =?utf-8?B?Y2N3bkFYOTd5RSt3amZ2b2wwMXFod1JIK2szSytjNFlXYTJqWGcxMHA4MEMy?=
 =?utf-8?B?NGgyTTRwRUFZMi9LM2I2MWVZZG1JbTUrMXNjTEhOTkNRd04wWmZUUEdoNEho?=
 =?utf-8?B?dkxXcXg5cXp0UGJMRVlDa3pVYVZMbnBCakJrRHVSN0dRTndwL1hsK2RQcnJx?=
 =?utf-8?B?N3AxVG1MNktMbGZURU5zdWlwbTZJdkp2SFB4cTZJVE5FRzFwLzZLaWxDOTNq?=
 =?utf-8?Q?FGS1UiAoDAUw9Rf/ahfk+3x9P?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c6e319-49a5-4eb5-57f0-08dd6ace2541
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2025 12:19:37.6800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: coatNUFFXkTbXkG0Uj04e2uUbQqeX+quYIIQlxOA04HQaIRlEAF/Uzj81YvQdyfmSqFEwfpRQ6T0SNKffN8TZPQBwnwqiuWy+nyrdlmiFgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6992
X-OriginatorOrg: intel.com

IA0KPiBPbiBGcmksIE1hciAyMSwgMjAyNSBhdCAwMjozNDo0MVBNICswMjAwLCBFbGVuYSBSZXNo
ZXRvdmEgd3JvdGU6DQo+ID4gc2d4X25yX2ZyZWVfcGFnZXMgaXMgYW4gYXRvbWljIHRoYXQgaXMg
dXNlZCB0byBrZWVwIHRyYWNrIG9mDQo+ID4gZnJlZSBFUEMgcGFnZXMgYW5kIGRldGVjdCB3aGVu
ZXZlciBwYWdlIHJlY2xhaW1pbmcgc2hvdWxkIHN0YXJ0Lg0KPiA+IFNpbmNlIHN1Y2Nlc3NmdWwg
ZXhlY3V0aW9uIG9mIEVOQ0xTW0VVUERBVEVTVk5dIHJlcXVpcmVzIGVtcHR5DQo+ID4gRVBDIGFu
ZCBhIGZhc3Qgd2F5IG9mIGNoZWNraW5nIGZvciB0aGlzLCBjaGFuZ2UgdGhpcyB2YXJpYWJsZQ0K
PiA+IGFyb3VuZCB0byBpbmRpY2F0ZSBudW1iZXIgb2YgdXNlZCBwYWdlcyBpbnN0ZWFkLiBUaGUg
c3Vic2VxdWVudA0KPiA+IHBhdGNoIHRoYXQgaW50cm9kdWNlcyBFTkNMU1tFVVBEQVRFU1ZOXSB3
aWxsIHRha2UgdXNlIG9mIHRoaXMgY2hhbmdlLg0KPiANCj4gcy9zdWJzZXF1ZW50IHBhdGNoLy8N
Cg0KT2sNCg0KPiANCj4gWW91IHNob3VsZCByYXRoZXIgZXhwcmVzcyBob3cgRVVQREFURVNWTiB0
cmlnZ2VyIHdpbGwgZGVwZW5kIG9uIHRoZQ0KPiBzdGF0ZSBvZiBzZ3hfbnJfdXNlZF9wYWdlcyBh
bmQgc2d4X25yX2ZyZWVfcGFnZXMuDQoNCkhvdyBhYm91dCB0aGlzIGV4cGxhbmF0aW9uOg0KDQoi
QnkgY291bnRpbmcgdGhlICMgb2YgdXNlZCBwYWdlcyBpbnN0ZWFkIG9mICNvZiBmcmVlIHBhZ2Vz
LCBpdCBhbGxvd3MgdGhlDQpFUEMgcGFnZSBhbGxvY2F0aW9uIHBhdGggZXhlY3V0ZSB3aXRob3V0
IGEgbmVlZCB0byB0YWtlIHRoZSBsb2NrIGluIGFsbA0KYnV0IGEgc2luZ2xlIGNhc2Ugd2hlbiB0
aGUgZmlyc3QgcGFnZSBpcyBiZWluZyBhbGxvY2F0ZWQgaW4gRVBDLiBUaGlzIGlzDQphY2hpZXZl
ZCB2aWEgYSBmYXN0IGNoZWNrIGluIGF0b21pY19sb25nX2luY19ub3RfemVyby4iDQoNCkFsc28s
IGlmIHlvdSB0aGluayB0aGF0IGl0IGlzIGhhcmQgdG8gaW50ZXJwcmV0IHRoZSBwYXRjaCAyLzQg
d2l0aG91dCA0LzQNCkkgY2FuIGFsc28gc3F1ZWV6ZSB0aGVtIHRvZ2V0aGVyIGFuZCB0aGVuIGl0
IGJlY29tZXMgcmlnaHQgYXdheSBjbGVhcg0Kd2h5IHRoZSBjaGFuZ2Ugd2FzIGRvbmUuIA0KDQoN
Cj4gDQo+ID4NCj4gPiBObyBmdW5jdGlvbmFsIGNoYW5nZXMgaW50ZW5kZWQuDQo+IA0KPiBOb3Qg
cmVhbGx5IHVuZGVyc3RhbmRpbmcgaG93IEkgc2hvdWxkIGludGVycHJldCB0aGlzIHNlbnRlbmNl
Lg0KDQpKdXN0IGFzIHVzdWFsOiB0aGlzIHBhdGNoIGl0c2VsZiBkb2VzbuKAmXQgYnJpbmcgYW55
IGZ1bmN0aW9uYWwgY2hhbmdlcw0KdG8gdGhlIHdheSBhcyBjdXJyZW50IFNHWCBjb2RlIHdvcmtz
LiBJIG9ubHkgbmVlZGVkIHRoaXMgY2hhbmdlIHRvDQppbXBsZW1lbnQgcGF0Y2ggNC80IGluIG1v
cmUgbG9ja2xlc3Mgd2F5LiANCg0KPiANCj4gVGhlIGNvbW1pdCBtZXNzYWdlIGRvZXMgbm90IG1l
bnRpb24gc2d4X25yX3VzZWRfcGFnZXMsIGFuZCBuZWloZXIgaXQNCj4gbWFrZXMgYSBjYXNlIHdo
eSBpbXBsZW1lbnRpbmcgdGhlIGZlYXR1cmUgYmFzZWQgb24gc2d4X25yX2ZyZWVfcGFnZXMgaXMN
Cj4gbm90IHBvc3NpYmxlLg0KDQpJdCBpcyBwb3NzaWJsZSB0byBpbXBsZW1lbnQgaXQsIGluIGZh
Y3QgSSBkaWQgZXhhY3RseSB0aGlzIGluIHRoZSBiZWdpbm5pbmcgaW5zdGVhZCwNCmJ1dCBhcyBt
ZW50aW9uZWQgcHJldmlvdXNseSB0aGlzIHdvdWxkIGhhdmUgcmVzdWx0ZWQgaW4gdGFraW5nIGEg
bG9jayBmb3IgZWFjaA0KY2FzZSB0aGUgcGFnZSBpcyBiZWluZyBhbGxvY2F0ZWQuIA0KDQpCZXN0
IFJlZ2FyZHMsDQpFbGVuYS4NCg0KDQo=
