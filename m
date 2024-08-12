Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3074915C159;
	Mon, 12 Aug 2024 10:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458904; cv=fail; b=RY7U9pBI1U1cYtLM/uT+wQzYwuK1/zgL0F+C7OP6gmS16f4cMthmGjDVAyJUdyAZPChheSH59+mni3lSsKX8NaWe0yVjsdkcL6Y/WD8MAF2EwJkoST3AClSsKNPN4J8t+NKwNI2/vFNFIBvJ8B3hhTTE0Bqp6ReLqinVxa4N/Kk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458904; c=relaxed/simple;
	bh=a6A+dtPWYnYWUkGMVAuFoanm//8d52fXxg9Or7L3PSg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YHzloIMwyr/BVTar92DT8MiY+GXvWk7nOTHyJ2pu/j3XAkBiKwhJ3v1FWSTWO9KwV6+EwXMq76Lf67PjcOq2RPb7M5MDnh8XaRknwRANAe+oe2ZOQMFs8aS00+NPlxJvdFSePM97LEY5+EysCoxycAm9h+i0dDpuJyYX6IRNXBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aZfNzfcJ; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aZfNzfcJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723458903; x=1754994903;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a6A+dtPWYnYWUkGMVAuFoanm//8d52fXxg9Or7L3PSg=;
  b=aZfNzfcJgj1QujpKXyJvEWzlAhX6DhcORNkzogSOholQVJvC68DyleA9
   xmOHZ3agp/Os2xuC2nMoF+KM7AnhiTt8s1HqV4K8dw8CPhaenoE0LNi8S
   yr5A5aEwJ4L3JnAv1KeoEL4UPng6hJVlna13NUvAzjVQnu7Ckw8HpSE/c
   GUvWZT7TYrjn8gj/KG5IomMc3fj1FWCQH9ZRZieSHao1GxPmgjwu9AqyG
   AgNbwTPJmGgU2GQ45FYNuGohJfB9oFA38EsMezOyRGZSx1a2917eEtIf6
   DjLVUTz9vwPnQyQHtgG1la+T3Yw69TBGZQMIFyz/iu2cm1R6IhVF3tCe+
   A==;
X-CSE-ConnectionGUID: wp+s8PWLTXCo2DtsEurpaw==
X-CSE-MsgGUID: ulgjoMEbSVyfS1NHM2g7fQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="21440505"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="21440505"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 03:35:02 -0700
X-CSE-ConnectionGUID: U1MQNmnsQSGPmwCocBChiw==
X-CSE-MsgGUID: Y3+Tp3dmR8+XS88reWAFMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="89062436"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Aug 2024 03:35:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 03:35:01 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 03:35:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 12 Aug 2024 03:35:01 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 12 Aug 2024 03:34:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SSCDCslO1i2gop/abiKYQUFOMVDo0bW9vCCbaNduw65iIuXdS95R54hnzwFmMTqk9FJx4QXpIu0r811ztarAjHgHx5TtnFsjAi/f1F+3Yp7lLWtcmlu3ux//a8wHGx15V7POwizt3hz/mM8hniFY10k5UnhJKf+GAYPYZabvkSaGTG8nHVnIEn3Rd+yKPXeoC4GvH3CZJWylEckMwVB+x5FIi7D9yc0KELtFFoHYCbQOs78N+PA17Q3y2f+QLZowUxesAT0PSIXNCeTWH29uwenqvwrjuGqGu685M/E8acuNUNhsHFHiTp+ds88p6qfokKZ5214d9a5qIGyVYUyvFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6A+dtPWYnYWUkGMVAuFoanm//8d52fXxg9Or7L3PSg=;
 b=MJRVQ+lCjFfunNFTjF9O7wti9QZO1k6TInqxBln5g2Fw6FPCFjYIJ1lLrisuqHZNi3TZFDP20bR0fCGITKy/Dsr0ZfJOZzsN/dsGWtxdxSwqZ9fj0tVqsSwz3C9ccR/JSyJTyP2Z17KkjkMymlNwyNhsMnRwE3IKcUKV0kLwI5LjPDCX2gfLIh8EVJf16nZaPvRdVPiMBiJ3CuaKhrj6Me1UDAWfnlZMkFL8KoTATZjxmgQBgo+mxp4JGk+7B6T6ydMtSGiKSytuYop3qF/aBrWDD44zdViJW3kSrXDfMwuRHnPqGn0InbKSIPzwKYkvARD0zgnGQeYBPdquz54dDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8113.namprd11.prod.outlook.com (2603:10b6:8:127::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Mon, 12 Aug
 2024 10:34:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Mon, 12 Aug 2024
 10:34:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Kuvaiskii, Dmitrii" <dmitrii.kuvaiskii@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Qin, Kailun" <kailun.qin@intel.com>,
	"haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "Vij, Mona"
	<mona.vij@intel.com>
Subject: Re: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
Thread-Topic: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
Thread-Index: AQHazrB4mIMKrvC2y0eY2IQtmlLA9bIGxLIAgBgc0wCAAB0PAIAEiEaAgAAiTAA=
Date: Mon, 12 Aug 2024 10:34:55 +0000
Message-ID: <f722fd24bef96dc12500eaffb1d1e1f169a6dd9f.camel@intel.com>
References: <8ab0f2d8aaf80e263796e18010e0fa0a4f0686a3.camel@intel.com>
	 <20240812083207.3173402-1-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240812083207.3173402-1-dmitrii.kuvaiskii@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB8113:EE_
x-ms-office365-filtering-correlation-id: ea1c10b9-9fd2-4ba7-25dc-08dcbaba684e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZXZDUUFEclVCZFdlcXJjRmo2U01NdDd5QXo3a0xRUXBRcFdGamF5SFNOR1RL?=
 =?utf-8?B?dEVpVmFYZmVGQlBFMmRtZGkxQmhEUUVIa01hMmpkaHROSzV0OWd4WitxRWFD?=
 =?utf-8?B?SzdVOUs1T2srNVI5L240c1hEZFNhQkR1S1Fpc0l2ZSttNnNIaTU2bXJZQkZG?=
 =?utf-8?B?ZUc5Q0RqNFpxT3Bua1YvcDQzTmo4bDVIZUdoeVFRdFQvNmFxRzV4ekJvMU5L?=
 =?utf-8?B?WHVQNkN6MmVnbWNSUE5CRzRZN2daeVoyclhzV1Y0MnFzQkdwL2t2ajc0WDZ3?=
 =?utf-8?B?aVR1Zk9FZER2emJqOHZIYW5CMVBySzQrVVRQVUtVeFN0UysyUFBDbDN3OFZm?=
 =?utf-8?B?L1F4T2hRRWxTK2xxN2NSa2NzRXk5dm9Xd3RlclhZSTBmcDZCajdPSEo0NkZJ?=
 =?utf-8?B?SFNFaWFzcjBoRG5lc01lazJUZTJPOFE5RWpIQ2JmT05hUDdLNXpDNmxRSUVX?=
 =?utf-8?B?ck5MREtudGU0aXpvejc3cU9TblVjd0RrTVZsVnBIaEpvNVRJRE1tc0hjcWlW?=
 =?utf-8?B?ZU5URGNOVmJMNVJTUEcxOHVWSFp3ZzZ3a3hjS2d3V1loVDJZZ25pVFpTNzFJ?=
 =?utf-8?B?M0diQVNVSXhEemdHYWc1VkwvMDUxK2dnWU9MSEN0eUlZUTlXOXl4WjIrVXVL?=
 =?utf-8?B?czZWS29HWUZ3bFlIWlJBL3VvUEM1bUEvU3A5ZThuZStPU3JJZDJibmJhZllN?=
 =?utf-8?B?ZlpFREFiaTAzY2JtYUdGVG11YnF1eFNmN2dIOEJpa0ROckFsV2FveXFUcmp2?=
 =?utf-8?B?WWtubjhrR2RqbkhSUG5OUFM2dlNEU0l0QWhsOGNNaldVd01NUTZ2ZE9hMXdL?=
 =?utf-8?B?Qzh0blpsNkFxWEMxZUZPTWtESU0yb0NlSFBvaWZ4TTkxSGl4YXJDbWYyZzdP?=
 =?utf-8?B?elhmOFd0VWhWanFGMnpDUFdXblJqRTE3VGRxMi82VEJub2F1b20xSnZENG5u?=
 =?utf-8?B?SVllOWlnNmx5TURBbWs0bk8vQTRnTXFRWWViWTFHWndzSWxxWnZQczV6bTNw?=
 =?utf-8?B?amZ3YUVmZDRXek85dUpYVnJQWVR6d1U1VkpCMitXbVJrMzhRWkRsRjN5aXkv?=
 =?utf-8?B?ams5U1VDOEdiNllMM2ppSVdXMENYMlRQRkpscldzVCsrMHNjNXRDQW1EQzNl?=
 =?utf-8?B?d0I3NlJmUFBJV2FtZ3JjcEFwYzM0bjZJMlNURXlKcXFpTlVmdkZCbU5jcXFv?=
 =?utf-8?B?SzVkMytPRjdzSTBLd2dTUDBKS2lVQlQyTE9Na0tMeCtERFczSXZ0cUtQVDhz?=
 =?utf-8?B?WTl4cXY4azllQkJyYUJqVlJlSXVPWlNHczNpbXUzMDdqUFVHTWQrYndUMUZT?=
 =?utf-8?B?cHBJYkxwNU04b3lheUR0MVRpcXF1VWlnQm02Tk14aW9rWVk5UEw1NHZhcWs4?=
 =?utf-8?B?TkxmcDdKakVndUJvVUtHajRPYmFoQ1FrSWRLSmpuM2hiMWxkZGpqc0hETDlQ?=
 =?utf-8?B?Z0h3NFB6dUowM2tzSlJ1dWQ5WS83amFJbVV2MnA3b2RCWjVhdDEzR3NGM1BL?=
 =?utf-8?B?aTJ6RmtuNXFYMmZLdHpOeDRnQkNkb0NLS2JzNlZEbmJRTmh1blYrcEpGZklE?=
 =?utf-8?B?Zm44L0NnOXBnS2FFUmx5aW5PRWRPd1hiY1VtaXNEc3VvZDE2QVo5MkRRazcz?=
 =?utf-8?B?eXplMUtRYURJWkUxUjZmakRIeGR0QzROdW5zNEwyRW8xdEt4SW5PQ3ZqeTd4?=
 =?utf-8?B?ZlNrVzdVVHlQZjJ0UXJNUnBndmxaSXV0NXNldE1zU1RJMGY3RnRtcjFkK3Rj?=
 =?utf-8?B?YVBuSUMrbXBZQ1pkWjZFQ0FaMzdXUExXSDJabFRqZDZLQU8yU3JYVzM1cGJS?=
 =?utf-8?B?YW5qc3doYytIQWRjQTNib24xNC90dVRmUXFOYzRlaUJkY3Frd2VnQWpVNDhE?=
 =?utf-8?B?ZndSNHlkUE5vMURkY25NdFNEN2ZXMVRsQkhZNU02SnFsOWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjdaZ0dLcmhDbEFia2V2OFdVcnV5OUc2cERiZE1mWEZrR1UwSW4wT3NRd2hT?=
 =?utf-8?B?cityMUU5WWE3NVppTW9kblpzMFNvbWxhSFhZWXZZaHVkY1E0d3pxVXJLOWRY?=
 =?utf-8?B?SUFDQlFneDhSSnd5c09kUDMvK3Z2NzNpbmY0SDd4aXJINXJySFBCS1Y0bWhO?=
 =?utf-8?B?dEJmQ1VBaXVLZlV3RElxUzVoanN4c0JrK0lTK3pDakZrcWw5VnRJeDRHLzQy?=
 =?utf-8?B?WG5LZDdtREtnZm53YXQrSk5FL3pPamEyOCt4SndiVWdGcGphcnp4YWN3WkJY?=
 =?utf-8?B?bTZVajhtVEJnV1FSK1dnemlVQlBhTlBpWmhXZ1ZxSzJiVVVSU1pnZGpSb1RP?=
 =?utf-8?B?b0FuMk5kejhZVkhsSUFJWkpIamNiOUF2cjdISWhDaU9aTENrVy9YT3puTDkv?=
 =?utf-8?B?Z1lCYWJjeHNkRWNSMFduVkhLMW1hQmdtWlhvM2ppUW5MVDd5Qi9XaTNuOWgw?=
 =?utf-8?B?Tzd2U3djek5yZGNpbThUVyswby9JQUVKV3l4T2RFWkU4T3NaTGt0WjVGY0N4?=
 =?utf-8?B?cGkweEs2OVJ3dDhJY2poQkxFTDRJL1V5K1F5Sy9GWEZVZ05pZTl4YkVlMWhK?=
 =?utf-8?B?eHV0dkZuRU1SQ3VPWWJ2eExOY0o1bC9oWFVTbm5KR1Q0R295SktpdEg4Z1JU?=
 =?utf-8?B?cTd2VjZ2NnJCbFl4NDFYK2Q0M1hHWUlUNy9OM1FoaWpSZ0tVeXpHdE04SG40?=
 =?utf-8?B?cnZ3V1ZDcEpTRXRBelhBaXRKMUt5RThIa2dVb1kwTnZ6WnpCb05TbGFYSU5r?=
 =?utf-8?B?Rmc5ckl6UFBmdlVSOFp0eFhuc1VXSFc4cFpUTHR6anQyLzdYUVppVnY1TjF4?=
 =?utf-8?B?eGNGbnBoSStoV3V6U1duQk8rekR0T0h2WmJ5a0F1YTBOWWFjNnJwaDZXZHda?=
 =?utf-8?B?R0dhMmJNZzRObmNCUUVOWk9Pc05wemtJWFc3VktYMUZ2dlUzYWhVMmdFWGZ1?=
 =?utf-8?B?YzU2M0tERm9CWlgzWWdacTArZnVPMTV3KzNnekRzeVMrMU1HaDBkbTVxY2I1?=
 =?utf-8?B?dEVEMkhTT3M3ZEFJbW1IbkxzY285VmQ4NWZIdTRZNkZra0pEOEhWRE9BQk5Z?=
 =?utf-8?B?cmtRK0tieEZQL0V4Q0NScTQ5YnBPSHUzVDFnR3Q0QU1VT0IrOE5veFZheXZl?=
 =?utf-8?B?M0hCMXVGc2ZKRXNkZXNPeVpTSG5xSitIbTM4eStjSDRkN1dHTlltbHBSZFBC?=
 =?utf-8?B?Q0JWT25yb3FWNXBYeUtWdjRBRDlaTXNKK2FpVVk4WkxVaWpFNVhPcUJDTWh6?=
 =?utf-8?B?a0ZjZ2d1MDNUS1pJVUNKTmdBaE5VYXlJaHZsTUZzdis3QTBhdldTdTlrZ1dK?=
 =?utf-8?B?MHZrNkM1aDhtRFpTMVpET1VtSkxuM3JZY1pJSmthNzFEUmEwZmpxZHpqdmZX?=
 =?utf-8?B?NGxaYTZoZlBodHByUUo5cXZlWEE2aDN0SDFjSlZTL3ltakMzaG4zTFI5dVcw?=
 =?utf-8?B?MTVHSVNpMGdjck1zOXNwZ1JxSVRlZ05JalczZjFQVXpBUnFPQmo0dzliS2c1?=
 =?utf-8?B?Q0lIeHZJMWw4bDA2cERTdXBuM2VLdzVBVHlqWTZPTGRndEVkOEFjY1RFelRR?=
 =?utf-8?B?eUprcGZvWVl5K3R5cHRzTVZGRDZ3YU5Gb0ZwTTR0MkNyUTFMaHczbEFUTlRC?=
 =?utf-8?B?S1ZKMUN0RXRvOGdiTzU4T04yQXYrUlQ0OWVwdExkaXBXdys1aUJUNHhPTmhT?=
 =?utf-8?B?alZsNzhUdm96cHVVR2VjQXZHcVlnTnpPd2NISDFJbUsvWDFuM1F4aVIyOWVP?=
 =?utf-8?B?Z01ZT1BpYVJnL2h1ZzZZcEJUS1BhVXM4bkNVa2pCZi9yRDIrOG0vaXF4K3I2?=
 =?utf-8?B?VlpINExHMDg5YURZTmZERTE3bDZ3WjJ2WjYrUzh6a05YdHVBbE9ET0hvMWNj?=
 =?utf-8?B?bTRhWGxQOFRndTlZNWFFV3VoMDR4V0ZLK1Jld0k4NHBXZFZSdW8rNmpkVitC?=
 =?utf-8?B?czluV0pJclRGQndUUnFHSjhjUGxFQzljRzliRjNTT245TTdkcHJUclVTRVJL?=
 =?utf-8?B?MENhQVpKeVgyczg4QzljR3Z5WlJDMlErSEFDaXJDbXlkd2FHVGJ0eW9ZVzdP?=
 =?utf-8?B?YnIrVnErVU9PSmtUN21ZNDhSREEyQU5heEdUdlZTMURGR0t5c1I2SmRUQS82?=
 =?utf-8?Q?7WMTWUaiA2lGFzH0lgzmX98rH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9B5467A3B35AB418170FD213F674AFC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea1c10b9-9fd2-4ba7-25dc-08dcbaba684e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2024 10:34:55.6009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LlwgIyS/t+hT0aQR2nCZ9MCETrZEdAX5+U9ObvJcaKMId4PQyaDvm+s2gOQ5LGtQ5E5Tk0Jc4Xfk3lelClU9bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8113
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTEyIGF0IDAxOjMyIC0wNzAwLCBLdXZhaXNraWksIERtaXRyaWkgd3Jv
dGU6DQo+IE9uIEZyaSwgQXVnIDA5LCAyMDI0IGF0IDExOjE5OjIyQU0gKzAwMDAsIEh1YW5nLCBL
YWkgd3JvdGU6DQo+IA0KPiA+ID4gVExEUjogSSBjYW4gYWRkIHNpbWlsYXIgaGFuZGxpbmcgdG8g
c2d4X2VuY2xhdmVfbW9kaWZ5X3R5cGVzKCkgaWYNCj4gPiA+IHJldmlld2VycyBpbnNpc3QsIGJ1
dCBJIGRvbid0IHNlZSBob3cgdGhpcyBkYXRhIHJhY2UgY2FuIGV2ZXIgYmUNCj4gPiA+IHRyaWdn
ZXJlZCBieSBiZW5pZ24gcmVhbC13b3JsZCBTR1ggYXBwbGljYXRpb25zLg0KPiA+IA0KPiA+IFNv
IGFzIG1lbnRpb25lZCBhYm92ZSwgSSBpbnRlbmQgdG8gc3VnZ2VzdCB0byBhbHNvIGFwcGx5IHRo
ZSBCVVNZIGZsYWcgaGVyZS4gwqANCj4gPiBBbmQgd2UgY2FuIGhhdmUgYSBjb25zaXN0IHJ1bGUg
aW4gdGhlIGtlcm5lbDoNCj4gPiANCj4gPiBJZiBhbiBlbmNsYXZlIHBhZ2UgaXMgdW5kZXIgY2Vy
dGFpbmx5IG9wZXJhdGlvbiBieSB0aGUga2VybmVsIHdpdGggdGhlIG1hcHBpbmcNCj4gPiByZW1v
dmVkLCBvdGhlciB0aHJlYWRzIHRyeWluZyB0byBhY2Nlc3MgdGhhdCBwYWdlIGFyZSB0ZW1wb3Jh
cmlseSBibG9ja2VkIGFuZA0KPiA+IHNob3VsZCByZXRyeS4NCj4gDQo+IEkgYWdyZWUgd2l0aCB5
b3VyIGFzc2Vzc21lbnQgb24gdGhlIGNvbnNlcXVlbmNlcyBvZiBzdWNoIGJ1ZyBpbg0KPiBzZ3hf
ZW5jbGF2ZV9tb2RpZnlfdHlwZXMoKS4gVG8gbXkgdW5kZXJzdGFuZGluZywgdGhpcyBidWcgY2Fu
IG9ubHkgYWZmZWN0DQo+IHRoZSBTR1ggZW5jbGF2ZSAoaS5lLiB0aGUgdXNlcnNwYWNlKSAtLSBl
aXRoZXIgdGhlIFNHWCBlbmNsYXZlIHdpbGwgaGFuZw0KPiBvciB3aWxsIGJlIHRlcm1pbmF0ZWQu
DQo+IA0KPiBBbnl3YXksIEkgd2lsbCBhcHBseSB0aGUgQlVTWSBmbGFnIGFsc28gaW4gc2d4X2Vu
Y2xhdmVfbW9kaWZ5X3R5cGVzKCkgaW4NCj4gdGhlIG5leHQgaXRlcmF0aW9uIG9mIHRoaXMgcGF0
Y2ggc2VyaWVzLg0KPiANCg0KVGhhbmtzLg0K
