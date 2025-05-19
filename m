Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E5620D509;
	Mon, 19 May 2025 11:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654389; cv=fail; b=QGbc9s3oqQ8pUff3OOULHr2OXegJrOqhNBGSL5ELO+48qlunZdA1iX/kGyrlPKfiesqKln3NWHzkOf+pjtDtvRkvkMMxjsg3U20pQ03Ev/xFHPNLhml+gZKkcDgoCVznY9SrtdTS+qbWbPnPQlzYTFPkgOtCheW6EbKZ6xGLJ+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654389; c=relaxed/simple;
	bh=RS0MqHsv9kcTHMbToeTWSBRVITyDFTUY16TnFTHzlhs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LPWpg+Y15Z2hVLTaWE0h0HyiGBV1FZ90PDryDUnnEFP6DahTAP0IQN8XeHiNR2UdkQqdM6wTmGbKuEH7uKBMuoBle/R1K4jCsP+9qAHdcy3lClBieBCzUc308gPC/sF++PFc9UZSQRlD/WjQ3O2qF+Oj5/Txpvw8LEAfRwLq2ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vf/R1dbC; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vf/R1dbC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747654388; x=1779190388;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RS0MqHsv9kcTHMbToeTWSBRVITyDFTUY16TnFTHzlhs=;
  b=Vf/R1dbCCgCgYniyh0nro8Djn5xXIbsGnRZZLBHF8WHAKHtKBfP6V5cL
   G67v0194eVwdXkAfv2rYkU9PHZYScr8NpfKZOOMSuiC0GPWek80C3yE89
   kqyKQoeI0jpqzIzsAkfl2+iGkmexWc9lUX4g3BogC7RqObkic438/cu+J
   ci4MrFiKX5twbV9/XZmh17BLvuiOHzseq34mIc2dy5e+9mDWSZf9fuRj1
   1nBOxHbukrH7ECouTjk8HVP4U7P11Zwm3AKdZJLL156op7h2h2+1GMhBr
   ec59NMBeld9WbzL0YP8SZy5VF4RuEW1MEePS8p+DU914iCpYT2/Wx9blw
   A==;
X-CSE-ConnectionGUID: oSEUdmiETo6zaxSWmHmHDw==
X-CSE-MsgGUID: XMDeVbn/Tr+Am6oriUY6Ug==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="53347701"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="53347701"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:33:07 -0700
X-CSE-ConnectionGUID: 9E3H1wGDSVumaR2PDVobwg==
X-CSE-MsgGUID: auCVr9y2RrKvM7+SeMlk6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139387440"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:33:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 04:33:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 04:33:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 04:33:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ggGEXcEO0As/+Y7uCLLaEe67bn++dGrnqcx4Zt596LP/mrdLgyRVod6CqdExaF6uj/Hl76LTFw3tSAoqeB+aN0UgdUq541CnFJ75ATEJG5V7VSCRYqWI+zTy0iZ8S/oSgUyJxd0EX5VpwmbXOYleGu/FN7O6f6CTBpszfEkbjWZj0jKJZHRqfrVvMrLNMm5ALZ83nrLmHZKbHhhBzpYQ2MRAs7R1eTjtC3jeNbncinvND7WNLuoi/Zcc3/ApOmrXU+IzCSCqN5UupmDc93Bi5ycPtMjlKgdxu/315z65Uu4+uXvhFSjiM+ivozYQ8kxZzg1/IL7z/ukpQg5r9unCsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RS0MqHsv9kcTHMbToeTWSBRVITyDFTUY16TnFTHzlhs=;
 b=hQR6EcPdaj7oqBMaYvTKFo77YTNkOiZxI0Niv+G8NzeVGG0pYMK6+kmGeulMmjuFA5YDTpBVHLDKZijxWxrZcWKeeMNxqsNGrae2jgZYx+itgOnowuH/cZ7rpjdu+HdHSL4HGXQO5loa1C/O0E+c867FqeobkXBxjG9QLwBlAPpPZq2pWlmFUXDw0WTLgUgZpTzvvqib5Rw9McEgbV3GU3H9sX/1rTqKDpOYJVgyex39cdMrhAG3uowMW7dJzbBFtoetwCSVkR2oZZyNyjNRx+ZiCeTig44ZXv2zcV/Nl4TfOdfxBzRl08XetrHRvNjezzaVdrzH32f/lStfzBayUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL1PR11MB5956.namprd11.prod.outlook.com (2603:10b6:208:387::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.29; Mon, 19 May
 2025 11:32:58 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%3]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 11:32:58 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: Re: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHbyI9nK0GX+MCyyECBUnY05vaI+bPZ0mWA
Date: Mon, 19 May 2025 11:32:58 +0000
Message-ID: <990841309a27d4f3e7c53b44d7cce0e555594a21.camel@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
	 <20250519072603.328429-5-elena.reshetova@intel.com>
In-Reply-To: <20250519072603.328429-5-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL1PR11MB5956:EE_
x-ms-office365-filtering-correlation-id: 0328ab78-6a1a-43cc-d45b-08dd96c8e814
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cDcyYzM3a1JTbU0wOHBva3NabHVsWWdoeC9iMVI1eVV2eTcyVUhkMnNQWDAw?=
 =?utf-8?B?M3BZZXRhaUhRWU53SGhBOGQxa0FHQWNDaTVTTWY0K2prSlUyV3RoZk9yQ2Rw?=
 =?utf-8?B?amQvNGN6Z1krUFVrcm5RRXh2K3QyL3Q4VXhQQ2FYeHQyZCtHS0VJN2NQRUxJ?=
 =?utf-8?B?TVE5K2thTkpBUkZBSW1UeVZOWGFDbnBEZFB2YkJxUzlZZ0Y0S2EzM3RmWHZv?=
 =?utf-8?B?UldRREpRdnFVNFVQYTc3ZHpla1dmYVp6RnMrM1pFQ0FNMWhWTXFPdDlndGVv?=
 =?utf-8?B?VUtQMTlpbDh2R0tINDBNckczY3pLb0RzNXNwQ20wdzFLc3hqMHNtdWcvQk5U?=
 =?utf-8?B?MksrbS9BVVMvc1lIOWtkU0pibzUyTGx1VkUybkVmK01MOGlnSlhNcVNRL3l3?=
 =?utf-8?B?WCtPRWZXSitrWkZkMWhnYkxsTkpWQ1hBM0ZQR0JYN0tEeEhyZjRvb2NNekVj?=
 =?utf-8?B?V1hDUXZ4UmFLQ0xXN051K3k3dHV2c25xbDVWTlZmdlM4NytFU3FWUllPa0Ex?=
 =?utf-8?B?bWVBR0N6Nlc2UGd0MzJtTENsVklTcWNwaHpWOUhNcUZ2OU96VUR5VGM5U0J1?=
 =?utf-8?B?eXI3WGNhTXc0c1N1Y3g2WTEzT1AwMlFvSVhyU04wck9zRHZHOTBQVVl6dkJo?=
 =?utf-8?B?d3BCT1RSUjkwRmZWNTFjclQvTlFEaEFVT0tXYzJYbHFmTVlUZS91Z2RyNHcy?=
 =?utf-8?B?dGtDRFhuZGtLWVIzVzk3Mlh3TEF4Y2NidU9YRVRZbnNGRjdCZ1BiT0xkMklh?=
 =?utf-8?B?djRlM1pyKzAwOFhqblp6anYxY3JwM21NYkFwdUVrZnVHN0pLS1h5MXpkcmtD?=
 =?utf-8?B?LzFjT2srNGVjd1ZJTnVYeFdHclhjbzhYQjNtOGRwZFJ6VFBkSHFGMkYyd2dm?=
 =?utf-8?B?WmRDZWx5WUFlOHlBU3N4anp0a3I4WDFKM1pCKzhqVCtTQlRMbGFUMi9laTA2?=
 =?utf-8?B?OEhNNG5UNlVLd0MvRXRBSHJ3ZEVEandyeC90dVo5QytvZUZGeVdJSDR3VzZ5?=
 =?utf-8?B?SWhiQXJ1TktjNS8wS2lqK0dSMjJMSGFZeVpVRXJNcEUyYUFxWjZKdkpFTEtP?=
 =?utf-8?B?NDJPM2UyVU02UVR6dzR6ZVNlQmRQTG1Cb3BBelRQeUtQMjcxQ05nbnVsckNX?=
 =?utf-8?B?N0JlVVU2dTlGN2VoWXExRXE4c0hmZ0luV0xKb2ZIQ0RHVEJTZ3gxQVVVZWdt?=
 =?utf-8?B?VlR4N1hPczRJSFJuWU1kSlh4SXNNb3E0bXRpVVozdllzbjN4UlFtbU9MU0hq?=
 =?utf-8?B?MVhDS2JNL2hkV3NscHprWXFIK2phZjZqUnNNMzV2YzdIK2hEQXNhSU9nMWdt?=
 =?utf-8?B?bU5pN2JhK1NMbDU0MklzSmlHNzdsZG1UbUpjbjJBVFlLTDF5ZlVMYnBJUTFV?=
 =?utf-8?B?WFFnWlFLSUNmeDNTRTVSQ1drZm9pZVh5Yk16NmdDU0VZWGtCUnNvWlpJRE56?=
 =?utf-8?B?enJQZkFxeE1INXMxV21IclBGazVHQlFJQkl2cEp1MFBVZ3dZckRGSWVmYzRR?=
 =?utf-8?B?N0NYYmE3aGRLcFNiVEEwdncxSlMvSjVlRWN3M1pWU25yZGFRSFp6TldocjRU?=
 =?utf-8?B?MENHdTI4UWlSclBkL1Uwd1dOWE1DcnJ1c3JxQWsrSWoyVmJZSHNYMGFzL1dX?=
 =?utf-8?B?ZnZNMmVHVXJNeEtsUU1vTndaQ0RLaFUrUGYyaWVoTWtIVUY5NUFuckMvaVlJ?=
 =?utf-8?B?M3NIbmx1THEvMzVmMjdPVWF5WEZ2S2tadXUzSnNXMFJoSW9VM055ZHhGU05z?=
 =?utf-8?B?ZkYvbFd2aWlNL2ExRlR2cEp0WmJJSG1MZFR4Uk1tV3djRXQ0SUx0QkM3bmJW?=
 =?utf-8?B?Z0ZxWVJHS01LeE5KVGJzazhxYWlZRDVwMVZXc0hUd3U1TVZKdWc2RnJ4azkv?=
 =?utf-8?B?TmJTMGZ0QjA0VndvTkpLQ0I5ekdMcjdpdFBES3JtVnIzL0xtaWZxbmF2cG1C?=
 =?utf-8?Q?QwRCqhTp/Sc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejRSQWMrb2lyYU9uMlRtSWFwTHI0MUxMNnFXUUs4b1N6MExDMzRqMjlTUnBL?=
 =?utf-8?B?NXppZFhLaE9OS1k0YWdyS25TYmovMzlXRm8wZzA0U0R6Rzg5aXFiSmU1dzNC?=
 =?utf-8?B?MllKZVUvOW5TYnNUdnZsWUlLNnliQ2dlWWhHQlhBYzRGK2Q1YWlMb1ZadWhn?=
 =?utf-8?B?U1lqaTlrbVpwKzVlMncvL1VuaC85VjEzYnd4cmVrZWhSb2NoeVN4dWFjQW5U?=
 =?utf-8?B?OXU2eVUyTzNWM2JXWFRwNG1CMko5NnJiYkdzbXEvZkovTGJaZUZoWU9JV3p2?=
 =?utf-8?B?UmswdzVKYThCcTRXNVBQVWFkVHZ5QmNRcmJsZzJwdFFDWVBOV1VyQjE1Wnd1?=
 =?utf-8?B?cXpLOGtTREcvb0ViekpmY3hWN0NGZTBmM3loM2lUSmFKVUVwUzZ5clp4VkZq?=
 =?utf-8?B?MkdJenJFY3VkbUp5OFZpRm5HbWNLRzJYYUcvdEs4MWxQeFlrWHRvZ2owZjJU?=
 =?utf-8?B?Y2JpMFYzbzVaU2w2OWlxR2F3cGVtSUhERkJBT01ycVMvZ1JzL1YrQlpLaU5X?=
 =?utf-8?B?Z1NlRkd0QjA0QzRyLzBQUWVEV2pTbkNFVFoxTTg5K2g4ZzNyalIwaThhS3RT?=
 =?utf-8?B?RVl2SnhWbEhodCtiT0hsd0FYQldnbUtkcTlnZnpwTlZ2anl6bEFMVHZKcDZR?=
 =?utf-8?B?Mm41NEZhSk8yQ08rLzFOSHBlQnlpbUpPQnJaMk96OTc4aXg3T3RzZlFSYnFQ?=
 =?utf-8?B?TkFhY0tUTTU5RGpBSFczSjFEUVpQNEtzbFpxODBHQk5UaEc1S0JiZDRZYjQ4?=
 =?utf-8?B?dWpJRmZBT3I2aUJUNThMc296V29rTGtSV2N2NERURm9YSmU3M2xubk1aVlN2?=
 =?utf-8?B?QjBoY0MzRlZ5RTMxNXhjT0wzeExuMkJwU3owbmlpM2pqUDhQQVF1WXJzbHcr?=
 =?utf-8?B?NGcxWXhTUGhKQXZRS2J5VXl6eTdKclMzQzkzYWNYMXU5L3ZYWFZLTWFBUFFn?=
 =?utf-8?B?TTBpVm5MNlZRcHo0UXNYd3R2czlpWEF0QVB5ZWl3ZzlPYlBGUzBFM3FrRFcy?=
 =?utf-8?B?d2paWmFyeVdBc2RSYVRDMTVIaVdkb0FybUlTT2RER0RlK2Y5NGYyeW5RYzA3?=
 =?utf-8?B?dVkzcEJpRDBBdjFTK3JhVUE4V3pPMENqdXU4YWVTa2pEUE82SHZQZElxak8r?=
 =?utf-8?B?RHVCTlhnbDJlRjc1Skd4OU5WcmpFUHBiODdNZ2dYeEN3ck8zUXZIazZyWFU2?=
 =?utf-8?B?SVB4OWhGS1h6eTZXTWFvaDY1R1NZWWN3dVdKQlhNK3g5ejV5cjNtSlpKdW42?=
 =?utf-8?B?Wm5pWWNSOXA1V2d2UmN5MjQySlQ0aEFvcWVCMUhyTUpXdnppY0crdlRXOHQz?=
 =?utf-8?B?cVFseDNFalJVY1FFMFFOVkVNbFk3NjRhNkdvVmJmRVZJVHdEVnJaK1FteEhp?=
 =?utf-8?B?bGg3TzdKT1QzWjk3ZExORFBPSXljcURIdUNOeXdyeEpUUWUyK1lEVzF1QVcv?=
 =?utf-8?B?ZFA0OEdrS0x3MXNtSGNBQkV6SGx0K0pzazFEdEFLSGxBQ1kwSzQ4NGJLd2lU?=
 =?utf-8?B?WklselhLYktXS3JhKzlvQ3pCQUpXVGpCNHVvdzVpYS8wbElyaVhaNk1UYVVy?=
 =?utf-8?B?c25obEEyb0MyeE1RUGdWd3ptYWx3RkFqU0ZrNW9Bc3kxTXBiSWd3Y05oc29L?=
 =?utf-8?B?ZlVjcFVLQ3Q0bFN0K29PVGRCMHRUSEttMkdINXlVRFI0WERYaWpwbXBYendH?=
 =?utf-8?B?TW1RaXVzdy9QVEcwdVdVLzg5Q3dyZEVnSEpyT0N1amVpbzhIdjlTYXhOb25F?=
 =?utf-8?B?THZYOUZCTXVsVDRXcG53RmZSY1BXRmFkb04rbGdzNHcrQkhhOGxQSnVUUTlK?=
 =?utf-8?B?U083Rm1LRTVrM2toSnRCdDFXUHQ3eVdEaTBlc0tSd3o2bjl0WlJIdkFjMThv?=
 =?utf-8?B?UklLVElFK3NtTWlvTXRrUlVIR25nZXBHTDlIdzhBb0txZkhqTW5nVnBQaXpt?=
 =?utf-8?B?RExFRGN6SzVZYXpvajJKOVptRjFwbm1tb2JpYk11RzNsUWxIeGd5RUVjbTB6?=
 =?utf-8?B?Z0tYSUpGUkhqSXg5SlB3Q0M1d0ZHemxJdUJydWxpZFc0djJOdmRxTmFRcGgy?=
 =?utf-8?B?U2poYU53M3V3K0J4OUJ6RGhBOUFCV2N0UDhKMVFHSVdKNmoyTDNGM2lld2FN?=
 =?utf-8?Q?fZcAt2ytrP8mHnaQOrSHbc3uN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04BDE2C309861B46A40A6F71B857A1E1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0328ab78-6a1a-43cc-d45b-08dd96c8e814
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 11:32:58.7176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zkT+7goIupKEsA1Q8UxFxZAhjB7uDkBqjoSbDeh7iTnCN4UMmY8ck4liBfD5IasuV2+KSxOScN6JJUCf7rXooA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5956
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDEwOjI0ICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IFRoZSBTR1ggYXR0ZXN0YXRpb24gYXJjaGl0ZWN0dXJlIGFzc3VtZXMgYSBjb21wcm9taXNl
DQo+IG9mIGFsbCBydW5uaW5nIGVuY2xhdmVzIGFuZCBjcnlwdG9ncmFwaGljIGFzc2V0cw0KPiAo
bGlrZSBpbnRlcm5hbCBTR1ggZW5jcnlwdGlvbiBrZXlzKSB3aGVuZXZlciBhIG1pY3JvY29kZQ0K
PiB1cGRhdGUgYWZmZWN0cyBTR1guIFRvIG1pdGlnYXRlIHRoZSBpbXBhY3Qgb2YgdGhpcyBwcmVz
dW1lZA0KPiBjb21wcm9taXNlLCBhIG5ldyBzdXBlcnZpc29yIFNHWCBpbnN0cnVjdGlvbjogRU5D
TFNbRVVQREFURVNWTl0sDQo+IGlzIGludHJvZHVjZWQgdG8gdXBkYXRlIFNHWCBtaWNyb2NvZGUg
dmVyc2lvbiBhbmQgZ2VuZXJhdGUNCj4gbmV3IGNyeXB0b2dyYXBoaWMgYXNzZXRzIGluIHJ1bnRp
bWUgYWZ0ZXIgU0dYIG1pY3JvY29kZSB1cGRhdGUuDQo+IA0KPiBFVVBEQVRFU1ZOIHJlcXVpcmVz
IHRoYXQgU0dYIG1lbW9yeSB0byBiZSBtYXJrZWQgYXMgInVudXNlZCINCj4gYmVmb3JlIGl0IHdp
bGwgc3VjY2VlZC4gVGhpcyBlbnN1cmVzIHRoYXQgbm8gY29tcHJvbWlzZWQgZW5jbGF2ZQ0KPiBj
YW4gc3Vydml2ZSB0aGUgcHJvY2VzcyBhbmQgcHJvdmlkZXMgYW4gb3Bwb3J0dW5pdHkgdG8gZ2Vu
ZXJhdGUNCj4gbmV3IGNyeXB0b2dyYXBoaWMgYXNzZXRzLg0KPiANCj4gQWRkIHRoZSBtZXRob2Qg
dG8gcGVyZm9ybSBFTkNMU1tFVVBEQVRFU1ZOXS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEVsZW5h
IFJlc2hldG92YSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4
Ni9rZXJuZWwvY3B1L3NneC9lbmNscy5oIHwgIDUgKysrDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC9tYWluLmMgIHwgNTcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAy
IGZpbGVzIGNoYW5nZWQsIDYyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNscy5oIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5j
bHMuaA0KPiBpbmRleCA5OTAwNGIwMmUyZWQuLmQ5MTYwYzg5YTkzZCAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbHMuaA0KPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwv
Y3B1L3NneC9lbmNscy5oDQo+IEBAIC0yMzMsNCArMjMzLDkgQEAgc3RhdGljIGlubGluZSBpbnQg
X19lYXVnKHN0cnVjdCBzZ3hfcGFnZWluZm8gKnBnaW5mbywgdm9pZCAqYWRkcikNCj4gIAlyZXR1
cm4gX19lbmNsc18yKEVBVUcsIHBnaW5mbywgYWRkcik7DQo+ICB9DQo+ICANCj4gKy8qIEF0dGVt
cHQgdG8gdXBkYXRlIENQVVNWTiBhdCBydW50aW1lLiAqLw0KPiArc3RhdGljIGlubGluZSBpbnQg
X19ldXBkYXRlc3ZuKHZvaWQpDQo+ICt7DQo+ICsJcmV0dXJuIF9fZW5jbHNfcmV0XzEoRVVQREFU
RVNWTiwgIiIpOw0KPiArfQ0KPiAgI2VuZGlmIC8qIF9YODZfRU5DTFNfSCAqLw0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jIGIvYXJjaC94ODYva2VybmVsL2Nw
dS9zZ3gvbWFpbi5jDQo+IGluZGV4IDgwZDU2NWU2ZjJhZC4uZmQ3MWUyZGRjYTU5IDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gKysrIGIvYXJjaC94ODYv
a2VybmVsL2NwdS9zZ3gvbWFpbi5jDQo+IEBAIC0xNSw2ICsxNSw3IEBADQo+ICAjaW5jbHVkZSA8
bGludXgvc3lzZnMuaD4NCj4gICNpbmNsdWRlIDxsaW51eC92bWFsbG9jLmg+DQo+ICAjaW5jbHVk
ZSA8YXNtL3NneC5oPg0KPiArI2luY2x1ZGUgPGFzbS9hcmNocmFuZG9tLmg+DQo+ICAjaW5jbHVk
ZSAiZHJpdmVyLmgiDQo+ICAjaW5jbHVkZSAiZW5jbC5oIg0KPiAgI2luY2x1ZGUgImVuY2xzLmgi
DQo+IEBAIC05MTcsNiArOTE4LDYyIEBAIEVYUE9SVF9TWU1CT0xfR1BMKHNneF9zZXRfYXR0cmli
dXRlKTsNCj4gIC8qIENvdW50ZXIgdG8gY291bnQgdGhlIGFjdGl2ZSBTR1ggdXNlcnMgKi8NCj4g
IHN0YXRpYyBhdG9taWM2NF90IHNneF91c2FnZV9jb3VudDsNCj4gIA0KPiArLyoqDQo+ICsgKiBz
Z3hfdXBkYXRlc3ZuKCkgLSBBdHRlbXB0IHRvIGNhbGwgRU5DTFNbRVVQREFURVNWTl0NCj4gKyAq
IElmIEVQQyBpcyBlbXB0eSwgdGhpcyBpbnN0cnVjdGlvbiBhdHRlbXB0cyB0byB1cGRhdGUgQ1BV
U1ZOIHRvIHRoZQ0KPiArICogY3VycmVudGx5IGxvYWRlZCBtaWNyb2NvZGUgdXBkYXRlIFNWTiBh
bmQgZ2VuZXJhdGUgbmV3DQo+ICsgKiBjcnlwdG9ncmFwaGljIGFzc2V0cy5zZ3hfdXBkYXRlc3Zu
KCkgTW9zdCBvZiB0aGUgdGltZSwgdGhlcmUgd2lsbA0KPiArICogYmUgbm8gdXBkYXRlIGFuZCB0
aGF0J3MgT0suDQo+ICsgKg0KPiArICogUmV0dXJuOg0KPiArICogMDogU3VjY2Vzcywgbm90IHN1
cHBvcnRlZCBvciBydW4gb3V0IG9mIGVudHJvcHkNCj4gKyAqLw0KPiArc3RhdGljIGludCBzZ3hf
dXBkYXRlX3N2bih2b2lkKQ0KPiArew0KPiArCWludCByZXQ7DQo+ICsNCj4gKwkvKg0KPiArCSAq
IElmIEVVUERBVEVTVk4gaXMgbm90IGF2YWlsYWJsZSwgaXQgaXMgb2sgdG8NCj4gKwkgKiBzaWxl
bnRseSBza2lwIGl0IHRvIGNvbXBseSB3aXRoIGxlZ2FjeSBiZWhhdmlvci4NCj4gKwkgKi8NCj4g
KwlpZiAoIVg4Nl9GRUFUVVJFX1NHWF9FVVBEQVRFU1ZOKQ0KPiArCQlyZXR1cm4gMDsNCg0KU2hv
dWxkIGJlOg0KDQoJaWYgKCFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1NHWF9FVVBE
QVRFU1ZOKSkNCgkJcmV0dXJuIDA7DQoNCj4gKw0KPiArCWZvciAoaW50IGkgPSAwOyBpIDwgUkRS
QU5EX1JFVFJZX0xPT1BTOyBpKyspIHsNCj4gKwkJcmV0ID0gX19ldXBkYXRlc3ZuKCk7DQo+ICsN
Cj4gKwkJLyogU3RvcCBvbiBzdWNjZXNzIG9yIHVuZXhwZWN0ZWQgZXJyb3JzOiAqLw0KPiArCQlp
ZiAocmV0ICE9IFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSkNCj4gKwkJCWJyZWFrOw0KPiArCX0N
Cj4gKw0KPiArCS8qDQo+ICsJICogU1ZOIGVpdGhlciB3YXMgdXAtdG8tZGF0ZSBvciBTVk4gdXBk
YXRlIGZhaWxlZCBkdWUNCj4gKwkgKiB0byBsYWNrIG9mIGVudHJvcHkuIEluIGJvdGggY2FzZXMs
IHdlIHdhbnQgdG8gcmV0dXJuDQo+ICsJICogMCBpbiBvcmRlciBub3QgdG8gYnJlYWsgc2d4Xyh2
ZXBjXylvcGVuLiBXZSBkb250IGV4cGVjdA0KPiArCSAqIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9Q
WSBlcnJvciB1bmxlc3MgdW5kZXJseWluZyBSRFNFRUQNCj4gKwkgKiBpcyB1bmRlciBoZWF2eSBw
cmVzc3VyZS4NCj4gKwkgKi8NCj4gKwlpZiAoKHJldCA9PSBTR1hfTk9fVVBEQVRFKSB8fCAocmV0
ID09IFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSkpDQo+ICsJCXJldHVybiAwOw0KDQpJIGFtIGEg
bGl0dGxlIGJpdCBjb25mdXNlZCB3aHkgd2Ugc2hvdWxkIHJldHVybiAwIHdoZW4gcnVubmluZyBv
dXQgb2YgZW50cm9weS4NCg0KSXQgc2VlbXMgaW4gdjQgeW91IHNhaWQgaXQncyBub3QgdGhhdCBo
YXJkIHRvIGNhdXNlIEVVUERBVEVTVk4gdG8gZmFpbCByZWxpYWJseToNCg0KICAgIEFuZCB0byBt
YWtlIGl0IG1vcmUgY29uY3JldGUsIEkgbWFkZSBzb21lIHNpbXBsZSB0ZXN0cyBiYXNlZA0KICAg
IG9uIHByb2dyYW0gZm9yIHN0cmVzcyB0ZXN0aW5nIHJkcmFuZC9yZHNlZWQgdGhhdCB3YXMgZGlz
Y3Vzc2VkIGluIHRoYXQNCiAgICB0aHJlYXQgZWFybGllcjogaHR0cHM6Ly9sa21sLm9yZy9sa21s
LzIwMjQvMi82Lzc0NiANCiAgICBVc2luZyB0aGlzIHN0cmVzcyB0ZXN0aW5nIGFuZCBlbm91Z2gg
dGhyZWFkcywgSSBjYW4gbWFrZSBFVVBEQVRFU1ZOIGZhaWwNCiAgICByZWxpYWJseSBhbmQgcXVp
dGUgZWFzaWx5IGV2ZW4gd2l0aCAxMCB0aW1lIHJldHJ5IGxvb3AgYnkga2VybmVsLiANCg0KUmV0
dXJuaW5nIDAgd2lsbCBtYWtlIHNneF9vcGVuKCkgc3VjY2VlZCBpZiBJIHJlYWQgeW91ciBuZXh0
IHBhdGNoIGNvcnJlY3RseSwNCndoaWNoIG1lYW5zIHRoaXMgd2lsbCBhbGxvdyBlbmNsYXZlIHRv
IGJlIGNyZWF0ZWQgd2hlbiB1cGRhdGluZyBTVk4gZmFpbHMuDQoNCldoeSBub3QganVzdCBmYWls
IHNneF9vcGVuKCkgKGUuZy4sIHJldHVybiAtRUJVU1ksIG9yIC1FQUdBSU4pIGluIHRoYXQgY2Fz
ZT8gwqANClVzZXJzcGFjZSBjYW4gdGhlbiByZXRyeT8NCg0KPiArDQo+ICsJaWYgKCFyZXQpIHsN
Cj4gKwkJLyoNCj4gKwkJICogU1ZOIHN1Y2Nlc3NmdWxseSB1cGRhdGVkLg0KPiArCQkgKiBMZXQg
dXNlcnMga25vdyB3aGVuIHRoZSB1cGRhdGUgd2FzIHN1Y2Nlc3NmdWwuDQo+ICsJCSAqLw0KPiAr
CQlwcl9pbmZvKCJTVk4gdXBkYXRlZCBzdWNjZXNzZnVsbHlcbiIpOw0KPiArCQlyZXR1cm4gMDsN
Cj4gKwl9DQo+ICsNCj4gKwkvKg0KPiArCSAqIEVVUERBVEVTVk4gd2FzIGNhbGxlZCB3aGVuIEVQ
QyBpcyBlbXB0eSwgYWxsIG90aGVyIGVycm9yDQo+ICsJICogY29kZXMgYXJlIHVuZXhwZWN0ZWQu
DQo+ICsJICovDQo+ICsJRU5DTFNfV0FSTihyZXQsICJFVVBEQVRFU1ZOIik7DQo+ICsJcmV0dXJu
IHJldDsNCj4gK30NCj4gKw0KPiAgaW50IHNneF9pbmNfdXNhZ2VfY291bnQodm9pZCkNCj4gIHsN
Cj4gIAlhdG9taWM2NF9pbmMoJnNneF91c2FnZV9jb3VudCk7DQo=
