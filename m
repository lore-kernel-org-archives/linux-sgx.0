Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8869138FA6;
	Tue,  5 Aug 2025 10:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754388692; cv=fail; b=YWsaOTosiRM6pV/6ze926+hG1srS2y7wQRHluXXTRIwK4sFGy+LA1q8K8fC7HP2Edns8PBMCORtkJ7oO0n1uW4i5wazdCSTOX95oj77zRbpbMJ2Rc4ZCzV57P41Xm7LMVXES8aVog61wHdDxOQ3/HZmgai23swPSLafGdxbBeDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754388692; c=relaxed/simple;
	bh=3zjOWFzPe9RgaDQv70mo4X+e8F9pXD4xGRjnClRzsow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L91diOBBnxaZzTASSBNoUxJoYHLbmkNERmvXlcEbUrbO7+cSm75PnFBDxkxajHygvkycQpm4aMgmlUDw5sIegAnYSL/opsA8Wk8OdWh7tlBVxSEHhGUpSKA/ZJua6rvNrDccBhemmbjcp/wVZb4fXPpOmA4qRNFAJIWm/0bQdN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pyxdep0C; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pyxdep0C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754388691; x=1785924691;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3zjOWFzPe9RgaDQv70mo4X+e8F9pXD4xGRjnClRzsow=;
  b=Pyxdep0C0k1rP5GeV/1sCC4ba4pJAjv0y4j9zbYgyE9//ELxzlX+b6Zl
   Wvbey/GLYWAO5VgLn8hdpJ5olCMR73fxGWqaUey9hq1lD/FZWJCBGri+P
   CKa0ICY7c+qVsNyTo19NshR6XmSGMOUs3sbRLtrrRL5uXJMlCwbPcYGJZ
   bmnuY1DAAUMsNUJNOlvLGYc4Ip+OB0eLWpgg7FPsuWS02KIhUzeZsN3k8
   Th1dOHnRRqm5Y/gMcJXdY59mlC1Xfid5e2qpINffTny0w2WEY9cepbXV+
   CRyw2O4cFpAeQidTlerTKsrl7nuVmNmVxF+vDIZIOsok2a9INZ/MUxSiM
   g==;
X-CSE-ConnectionGUID: bbqrIBRAT1iDCjhHXfL1Jw==
X-CSE-MsgGUID: qn5LoZFoRF2sQvRl+xl81g==
X-IronPort-AV: E=McAfee;i="6800,10657,11512"; a="82125517"
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="82125517"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 03:11:27 -0700
X-CSE-ConnectionGUID: 4HnXym5USMapq7Gl1pKNnw==
X-CSE-MsgGUID: 5dKWKp6LSo+lnPCumL1vCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="165214840"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 03:11:26 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 5 Aug 2025 03:11:25 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 5 Aug 2025 03:11:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.40)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 5 Aug 2025 03:11:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eKjsyJ3b8hSBsRAlMhNpuX3HCSrvXaLvXp+l4Og4rR8pwSIEMi8Oxk8TXalwuJ7pSfR0slcGGdLxYm9HfZSOd/OhuZGpqSWV6YY3V2X5It8hjt6mIQt+59negQlMgp8ZTMjMBRcFujvLi0TQk5TyyKM+2HSIG/9Z6QrEw7VgrDKKVtKnUCgqw+LNOp2Q/tMAlwMQD8DJFWL1WXisMw3JgVUKtB+T+KthHEE6h0Q/gQOg4ue3PFbpg5urL8IMB//0lLzeovxg2QhZ5nK2bfxOZHSdhnC0u6r+WyoF56GB7m4C6JmTdCcSTKtbjGruvUx4HTGzJsmIEeJ1Lv5jWePLgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zjOWFzPe9RgaDQv70mo4X+e8F9pXD4xGRjnClRzsow=;
 b=r6tnJdZxHURrA79/vuvJ0sp5z5jNmQR3wYsazmrvuldoEtDLESTDBGyuLznFKpQfDs4NgfFWjOtbODmivB2/VwzVEpVq+mOT9s95ny84nQrGraKZvNCKbFh2ANLz6v/8h15zRxnQNh4LXFTz/FnZz5mHQm2bZWgnN2B3g83OwvH3bBypzyxZFt4dJqTkUKcIJXSV2tQdZIhogfPkhcTQYa1lv1FbYZkY9XwQPff4MoHLYdCQWtiKExFfcHPo7N6GnOxauuKM2NLcMflTDfdbIY+ArYH0OechQU6wLrECA6bldDNa9te5cxJsligIIQ+46ZE949VqPPfZPGG1dOdMhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH8PR11MB8259.namprd11.prod.outlook.com (2603:10b6:510:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Tue, 5 Aug
 2025 10:11:21 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 10:11:21 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v10 4/6] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v10 4/6] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Index: AQHcAtc1bBlshQJLFU2DhdSwAc13MbROBP8AgAQVZRCAAHWdAIABTEZg
Date: Tue, 5 Aug 2025 10:11:21 +0000
Message-ID: <DM8PR11MB5750B9D8DA723CF88500333EE722A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250801112619.1117549-1-elena.reshetova@intel.com>
 <20250801112619.1117549-5-elena.reshetova@intel.com>
 <80006246-d0c5-475d-a8c7-bdb5446d9489@intel.com>
 <DM8PR11MB5750515E878BAC6199882330E723A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <97a3e5f8-92d7-43f0-ab99-77e248589adc@intel.com>
In-Reply-To: <97a3e5f8-92d7-43f0-ab99-77e248589adc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH8PR11MB8259:EE_
x-ms-office365-filtering-correlation-id: c2b759e5-8ec3-4ad6-7c49-08ddd4086d2e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bkxCVGthWXYvZlJZR1dkemdSWStVbVNibTMvckQ3bi9MSjJzeHVNY3RxOUZl?=
 =?utf-8?B?eEpvYVBYZjZvMlVuY2pjNklPT0E1b3VPczNxdy9jelNDTEtJZ2J1b3Y0cjJU?=
 =?utf-8?B?djBYT3JzekFYanNoU3prVTl0WUFGYnBHR3VRbDBCNmJROFR0U3dVSVNmNXJy?=
 =?utf-8?B?b3BraENTOVc5blV4WWd1WVc2SHJnQTdndXZSa0x5S1N6TkZ4OHhUVUlXcTdL?=
 =?utf-8?B?SkJKM2NWcTh1NWduWG5JNktIUjZiQ091YkdXMWsvUjhTUldQMDZUWEhDcnlM?=
 =?utf-8?B?OUpFTVZaYi9nMDM4RnM2bmdtK2dtbTZ1a2pNclZIb3RjSURaeXozcXA0SWNS?=
 =?utf-8?B?WWREOVd3V0xpeWJMTzBQeTFuelRCNU53MFNKTjQ0TFc1QU53QzBtendodnZV?=
 =?utf-8?B?THZWMDRSODJtak1aUGQybVc1b1M3TDlHWVc1YmUxNGlIb09vZFZiMDF0MXFx?=
 =?utf-8?B?NzVNd0ZjT3N4VGpKWXhkTENmL3U4czRtMDBxQzVtM3lDWFoyd2FsSGdOQjB2?=
 =?utf-8?B?ZlJ1bW5YYll1NVczVDBnNUdnWVJEZkVLUWsxOENyTTBGZHFGRHg5VHRwSmw1?=
 =?utf-8?B?WGNUbUp6SmNvZ3ZoMUpUR2dVM3R6a3NSMnZYM3RnaFBhWTkrb1VPbkpDd0tz?=
 =?utf-8?B?dWZCWDlpMTF4UEdkZnZlcHlLTTJVNHVpYzR4d2xONnRjZUdQdkhTbmpzakV6?=
 =?utf-8?B?VmJ3aFMrRlVKeGFQZjlaVzdrOHcxaTFKbzJZWHh0TGRXeTVoMm82R3dnbGdM?=
 =?utf-8?B?ckZac09CQjdJaGhYb3o4M09YdFpJaXYvem5RY00yZDh2U25zSFltN0E3OTdV?=
 =?utf-8?B?NVJQc2ZpQlhxWDFZVHJ3QXE0OHlwOUp6dFFDTjZpaHNIUUpleXVHQy9MSS8w?=
 =?utf-8?B?YmxOSkxKT2E4VGpubUtrZlFoY1Q3enUyWDZyL0wzUFl6UHRiU3h6UnhmaTdq?=
 =?utf-8?B?cTBBV1hiYnpqMnZsT3UrbzR1L1NXbUNCU05uTE42Si92aWZGK0dSVnkxN0Nz?=
 =?utf-8?B?b216dGhqVDUxbXJ1ODRZWUZreDI3aDF3S3ZmdEpCQzc4UHRoRWVweE9BcGpW?=
 =?utf-8?B?elFiQUovMFdBeUl0Ky9DelVpN0NXWGZldlpySmxVN0VsTEQzcjFaOE5JTXZI?=
 =?utf-8?B?RkdBODZCRGJSRFpKZU5YN2YrUThXVW5TeXYwaHkrMUxFTTBJa2pVYVprays4?=
 =?utf-8?B?SngwLzR0OXB1WHdlc0hWeWlrSFBmNnBaRndEaEIveUx1VksvZEpTWjhZSm1a?=
 =?utf-8?B?RVRTWkk2Sk9xU0tRMjUrVlZGV3hNd2dnaXorMDA0Sno4Q0w5eTI5RmdVMWRJ?=
 =?utf-8?B?N2tiWGdwTUc5SWpMblJaTk1YMmpOSGMvN05xeXRsMHJIM09hY0pPK3JkOVBZ?=
 =?utf-8?B?dkdDSTN5dEprWUl6eDR0MFpiWG5IOUFDdU9RUWxPdDhBd1puanh4OXI0R2s4?=
 =?utf-8?B?UUlGT2NVQlZpTnNnVm1xY3hVK0hsSTJxKzg2TytkZy83bWd0Z3JWdVNVUGxn?=
 =?utf-8?B?YkpMMWVFYXFsQm8xNmV2MjAvYjZsL1ZQSm12ZHE0K3NFdE5leUVld1RpT1dS?=
 =?utf-8?B?YjA1SXFHblJLQytMemJpd2dVZmlwUGxPaUpYYzRxZ29DWkJ6M1dpTXVKM2sr?=
 =?utf-8?B?VHE1VGxRd0Z6cWFLQzFoZjFhMC9LQ2NPa0d3WWNYU0xpTXRVNHo1aFBzSkFE?=
 =?utf-8?B?TFB0UGlEZ1NJMlYrVmJObjlYQWptdjAreSt3MzNmYnVCT2J0aVY1OFFtRXV2?=
 =?utf-8?B?b2xYREp4aFo2aXo0Q2hnSlFuT296dDJudGtSSG5ITkhjK2k3UERBOW9lQ1dZ?=
 =?utf-8?B?cFdQTiswK2VHVmFFNmtpMDk5b1QyUDRTbjJ3ejArRWRnNGxNWTFONHV0TDNV?=
 =?utf-8?B?NFk3Zm05NXBDNHVqeEJQZFYwRXVzTWtacU81WjZ1ZDlKU3hnd3BSNlBRVVlh?=
 =?utf-8?B?WDI2WVdPQUFKbVkreWcyUGN5YzQxcm1iOTR1anhpYnRkUHc4V2lNVnlpb1Nq?=
 =?utf-8?B?NFBNbXNoTWpRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDA0N0t5UEFlUlViZkJVdXBISjBvZGk4cE4zdGw5OFBjOHVqd0MxamFlVFN6?=
 =?utf-8?B?NGpnZG9YRFZzdEhPdnpYTHoxenMvT0NmckI0Y1FONklwWlh2Q3lDdUdxT0hL?=
 =?utf-8?B?bm1kc2NpQ0srTmxVbVVLRnpBV2d2MmJnNGFXUkpjWHoxbllHZlNGeFRCeGRM?=
 =?utf-8?B?amUxS1grcGo1S3N2dW5Hck9kSTNDeldjdmpPWkR1ajN5L0dnSG9tSk5GY0JS?=
 =?utf-8?B?eEd2VXh1Q2dmbDBPckFCdDlzNEthaVlROHVTcnVKaU81dHY1UW1ERjE2bUJw?=
 =?utf-8?B?QjVweHducENoamV2NTNyUlVlSklkL3N4YnpzS0tiZE0wZGVKS043cWZ0NEN4?=
 =?utf-8?B?QzJsaTJoQTRsRi9ROWo1QWlCK2hiSHhTaytRYktvdlR0MVNNR2JVTXNnK3hN?=
 =?utf-8?B?R1U1S1ZQRzRkbnpQWUpwcUlwVmVmWjNEM2w3Rmx5ckszKzRkank2bWgzRnQ0?=
 =?utf-8?B?Y0xWR010UWUvM2wraHdkQ3dhRUQvcHNOSnNvOGUxbmV0SVF2Z2ZCcjI3VUhu?=
 =?utf-8?B?WWlKSVJ1c3lLTkprWi8yMUlhNTh2ZVVIUzBIZCszUXNVV3FCbnF1ajF3MXhP?=
 =?utf-8?B?T3RQQ2JvQmJLRHQ2WjJaY1dHT2YxSGRmRy8xZjIwbEh0cEpmOVZ4dHQ5Zkhx?=
 =?utf-8?B?YUpsV0lsdU9Ld1A0cVRPQmVjRHphd0xZb1o2SEQ4MHp4QUlvSW9LQUZueHIw?=
 =?utf-8?B?Q1JKdjk1MzJWa3QwSjJtK2dhR0M5bDNMZXAxeWthZDlYeU9UajZ2QUwrcjdq?=
 =?utf-8?B?RWxpUG5IczRWQlRiTkJYQ0w1QXdtRDJWWjBmdE4rR0h5aXA3YUF1eXNnZmdM?=
 =?utf-8?B?cTE0eHRYeDZQTCtWekFWcEwrSjgrU2lvU2k0b25LY0JsKzBaSE94NHQwS3Nv?=
 =?utf-8?B?MU1MR1RseUlmQXU4V3pVMXFrRDl0WUxKdVpCM3hJL1ZrbXh6a0Vic0c3S2Zh?=
 =?utf-8?B?Q2VlNUxjRTMvdVZKSHB0MWs1LzRCSWtrYTRoVFkySmVMYXpCUWFnZGFmTTZz?=
 =?utf-8?B?YzRIbGVYR2RPdnFoclJnL0ZKdy9QUXdGV3VjVzg4eTkzZzgvQlNtY3N6ZkdH?=
 =?utf-8?B?RFRhSUpudXYxWHJ3WkNCNnUyMVpkcjB5SEhuQWhhSUxxdHVXQnlIbG5NdzhN?=
 =?utf-8?B?M1dRZnpKem54QVkycGhVclJBVjVqQk5CRUJzN0J0ZnEwcldsZjVQTnhSdXZO?=
 =?utf-8?B?TjF1TFBDWld5bnA4OXN1MHYwaDBLbDlHSmFQbzFoSnJkOXRRVHlIcHdsOUlh?=
 =?utf-8?B?b3JRKzg4MExvbGxOcURhNUYxclJwa2tVSk1FTDBoUWdxNFdzc1hiRk5ETjNM?=
 =?utf-8?B?RWRLQ1Rxbm5KaHBGc28wdjkzNkZkcVlNNE9LQjhyNUZEUDVYbHR2WmhyR1dL?=
 =?utf-8?B?VmR3cmFIdWxTZzNGay9SY3RGV0xaUFNqUGU4WnRqSmVRbXRnZ2J0czY3T2ZX?=
 =?utf-8?B?OGcwazJ4UGYvTE1jRERlN2ZGYXhmOHY0UWxmQ0Vnc29hVCtIR09KcUQwUlpD?=
 =?utf-8?B?TXh4OENQZHlWenZjMUtVcXpuT3BtMWt4aDZVNnhqK3RZMnIyalBOZTNRalYw?=
 =?utf-8?B?TmpoaGtrTDBzK0w0R0IwNFREU2RKRVhzV2lZdk15UTdKd0hkWDlVVnU1YUt2?=
 =?utf-8?B?ZjRGWnBEeVh6TXBocVRKcTl3ZFZnSFhpL2FFTW5SRjZLTU12ZUhLb25WL2FV?=
 =?utf-8?B?VlhRWmM4UUI2a1JrWllqOEZwUzB6bjR0RXIxcXdHK1N6MENCcHE0UGI5MjUx?=
 =?utf-8?B?UUp1RkZLTzc3ZEk2dis1aEpQR1hKTW42eExXTFRCUFkrcGRpdHRtMmFEYjdW?=
 =?utf-8?B?VjJkSEY5U2xZWlhaM3ZZMmNibXMzVUVFdjZKbXVsaHJkVU83WTVFQzBZekha?=
 =?utf-8?B?dCtqSEZGTTNyRW4xbjVZaVlCYnN0Ynp4RkQ5MDNmSitKNEs4d2FONEVqeER4?=
 =?utf-8?B?QlJDVVlUNW1BZVpJWVVRWjBxY1czcDdEVVFLSHQrRm1UU1JxQVNsaDFmMGh4?=
 =?utf-8?B?QVNoQXlxOUZZa2tKNDFYbXdNaEZ4RkRnVEFxMTVYMWhNM21rQTVYT1RtbmJR?=
 =?utf-8?B?S0ZKdjIrSmNCZDFocXp2aXdOeHdhcGc1Nkp3LzI5Nm15SEE5NHA0K3RyaHd6?=
 =?utf-8?B?cldWa0ZKQm1kelVQTGZvK3daWVZGZ1pucU5ON0NvelRMMzNxTjdqNjFtYWxW?=
 =?utf-8?B?SGc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b759e5-8ec3-4ad6-7c49-08ddd4086d2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2025 10:11:21.2589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NBwbvCO3qItArBdOts9EbipKgVBVdVY6bu0bBycmlJAu5cBOb9EtQHERi+umTUU1Tml47JbPCoK0PhmA886cooIySeiKpUV2xTQZEsDnjTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8259
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIYW5zZW4sIERhdmUgPGRhdmUu
aGFuc2VuQGludGVsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBBdWd1c3QgNCwgMjAyNSA1OjIwIFBN
DQo+IFRvOiBSZXNoZXRvdmEsIEVsZW5hIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0KPiBD
YzogamFya2tvQGtlcm5lbC5vcmc7IHNlYW5qY0Bnb29nbGUuY29tOyBIdWFuZywgS2FpDQo+IDxr
YWkuaHVhbmdAaW50ZWwuY29tPjsgbWluZ29Aa2VybmVsLm9yZzsgbGludXgtc2d4QHZnZXIua2Vy
bmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHg4NkBrZXJuZWwub3Jn
OyBNYWxsaWNrLCBBc2l0IEsNCj4gPGFzaXQuay5tYWxsaWNrQGludGVsLmNvbT47IFNjYXJsYXRh
LCBWaW5jZW50IFIgPHZpbmNlbnQuci5zY2FybGF0YUBpbnRlbC5jb20+Ow0KPiBDYWksIENob25n
IDxjaG9uZ2NAZ29vZ2xlLmNvbT47IEFrdGFzLCBFcmRlbSA8ZXJkZW1ha3Rhc0Bnb29nbGUuY29t
PjsNCj4gQW5uYXB1cnZlLCBWaXNoYWwgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT47IEJvbmRhcmV2
c2thLCBOYXRhbGlpYQ0KPiA8Ym9uZGFybkBnb29nbGUuY29tPjsgUmF5bm9yLCBTY290dCA8c2Nv
dHQucmF5bm9yQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MTAgNC82XSB4ODYv
c2d4OiBEZWZpbmUgZXJyb3IgY29kZXMgZm9yIHVzZSBieQ0KPiBFTkNMU1tFVVBEQVRFU1ZOXQ0K
PiANCj4gT24gOC80LzI1IDAwOjIxLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3RlOg0KPiAuLi4NCj4g
Pj4+ICsJRVVQREFURVNWTgk9IDB4MTgsDQo+ID4+PiAgfTsNCj4gPj4NCj4gPj4gVGhpcyB1cGRh
dGUgaXMgbm90IGNvbnNpc3RlbnQgd2l0aCB0aGUgY2hhbmdlbG9nIG5vciB0aGUgcGF0Y2ggc3Vi
amVjdC4NCj4gPg0KPiA+IEkgY2FuIHJlbW92ZSB0aGUgYWxpZ25tZW50IGZpeC4NCj4gDQo+IEl0
J3Mgbm90IHRoZSBhbGlnbm1lbnQuDQo+IA0KPiBJdCdzIHRoZSBkZWZpbml0aW9uIG9mIEVVUERB
VEVTVk4gdGhhdCBnb2VzIGNvbXBsZXRlbHkgdW5tZW50aW9uZWQuDQoNClllcywgZ29vZCBjYXRj
aCwgdGhpcyBzaG91bGQgYmUgbW92ZWQgdG8gdGhlIG5leHQgcGF0Y2ggaW5kZWVkLiANCg0KPiAN
Cj4gLi4uDQo+ID4+IElkZWFsbHksIHdlIGZpbmQgYSB3YXkgdG8gcmVsYXkgdGhpcyBpbiBhIHZl
cnkgc3VjY2luY3Qgd2F5Lg0KPiA+DQo+ID4gQ291bGQgeW91IHBsZWFzZSBlbGFib3JhdGUgd2hh
dCB5b3UgbWVhbiBieSB0aGlzPw0KPiA+IENoYW5naW5nIHRoZSBkZXNjcmlwdGlvbj8gVGhlIG5h
bWUgb3I/DQo+IA0KPiBSZWxheWluZyBpdCBpbiB0aGUgY29tbWVudCBuZXh0IHRvIHRoZSBkZWZp
bml0aW9uIHdvdWxkIGJlIGJlc3QuDQoNClN1cmUsIHdpbGwgdHJ5IHRvIGV4dGVuZCB0aGUgY3Vy
cmVudCBkZXNjcmlwdGlvbiB0byBjb252ZXkgaXQgYmV0dGVyLg0KDQpCZXN0IFJlZ2FyZHMsDQpF
bGVuYS4gDQo=
