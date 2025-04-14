Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4582580F9;
	Mon, 14 Apr 2025 07:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744617392; cv=fail; b=r60mVFKLT3S9fzlmPyl/e+x92Mwge3O4Q+lOIHUXnNPhM6Ag8Va9cZTThd7k/ovKvvTPwrc22lZWBcGar2a8TDjKqkXNQIczP3cvWs394E9qx5nb0GYBV0pYgzTQD7tqJEbpr7JnVT1sb4v4LwLgCeIUWbgUe010wOnJzC0PTJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744617392; c=relaxed/simple;
	bh=ng5GM3eB3SWIZBWoY02DpG2lK/s6B33nRCN3smOiYLM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cL5WZCLPb/aeDIbjgnnC45dK3ghrKtZgfx+GpYdfuLsGnKuuhEEbXMRaV34bb8VKUjrnfPyM47cAYJZYsZMvxD3gAXZQBAL2jCwUw5JlmTnM3CKMD0C6Q1rUofyGKthv5CbpobW6Qztp+xA65DuCjXJ6jdc64wZ5FUVeNDNarn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ImwOALak; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ImwOALak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744617391; x=1776153391;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ng5GM3eB3SWIZBWoY02DpG2lK/s6B33nRCN3smOiYLM=;
  b=ImwOALak1/HyQHZva5r2xNpgTV4ppOEud3fvLPpyNS/tMOg60q13Tu+4
   PBLNnwRWMu3yF8ll8IosDXeiXhzjXmNubU24MMCl3FUHuuWsABlzCSTTG
   rRt3iOaCt0K5cz9RJhf/8WTgHDvI3f6RbGFrspOC+GYodJiDs715CyvlG
   2ASYBQKkZuXuhiEytJcm8/AVPDwaUjt73qWg9shlCsiUohGcbileBIpVm
   mSEQNNwLxQag0dU9CVMLTVSemt5xRrIYaIKeEmk/Rq+9SQKQztX7ATYkU
   +oQNz6aq6ncXfji7EfiKmMYgxAPcpuS5X9CkC3a90bE2OX1lWQpev8MTs
   w==;
X-CSE-ConnectionGUID: MfrZmZtrRoWygvrNqlLISA==
X-CSE-MsgGUID: Lhy4GswNSwqBa3TJ3VhYEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="68563917"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="68563917"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 00:56:30 -0700
X-CSE-ConnectionGUID: vZnJuKjqR6GtNpsK/ZD14A==
X-CSE-MsgGUID: q5uaOmXOTY6k8h0sjSN/Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="152936055"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 00:56:29 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 00:56:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 00:56:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 00:56:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LyLRPB64lMTz5/ifpqVjNWDmKeg8pw0zdrWhl4wejgcG0uNMSmbLWG6fkoD0d4ojOsxexxmSRkb4h/xRk+ZAFNLDrNrPyL2PZoqvk+u7AO6JoUOiRubSqyV5zqdNOQen1UdMJqcVVdjpDvEemF21smbcGlHuMx+aJNoCMR63PWQ5LRtDU7cLK2GcsYJt8FwrRkF9GQfIBjONyd5ft5UJMPUGeEZB24MqEyepcoURqMouF8cc72qZFsVoKZdZW97XNMrwrBLPREZUwl89Q7Kdv25FvAFBjNlaQfczLhGQOhlVYEbDYM5j+XW2TszyAjkrR7nhBRCsEdJ3/tWNYN3ocA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ng5GM3eB3SWIZBWoY02DpG2lK/s6B33nRCN3smOiYLM=;
 b=LXYPaFkQW9XfqDEu0FtV+PQ1LHv7to2SJsWaW+3BwT/uwzT7+Q5+FsA5CUsqZTWl+K0NApK7gtc/PRb9Oa33y7+Ey3+gXl3GSJ+84/FUw7fAOhhNIB30E+upuFmsjIN3yeok4z6OLOva2Zit0+YW79OIQx9iVTVNO9uBKEZm0bNP+EywZFpDHn23e8t6h5PQRfrysJYRcWlFYn8Zi3pj4zylMStJVVMps1qKe2OStazendteKILeGcwkVEZCjyFkSx7SKw0DJJWrLGsl6hsEhRTudTMTs5eVMvh5T16bnIitt5NHP3rjpAYNNRTTrK/Uxw9/T4ZdKBtClGabZJvnmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DS4PPF708A6BB3E.namprd11.prod.outlook.com (2603:10b6:f:fc02::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Mon, 14 Apr
 2025 07:56:26 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%6]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 07:56:26 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
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
Thread-Index: AQHbn+FDiJjsRSw2cUyPYDKGfVHjnbOI1BeAgAAEgICABAKjsIAArrUAgAEIZUCAAFLwgIABevGQgAH4xoCAAMDIQIAAEkoAgAS/YyCAAQj4AIAAbf8AgAAAqYCAAAKHQIAAkDkAgAjvtlA=
Date: Mon, 14 Apr 2025 07:56:26 +0000
Message-ID: <DM8PR11MB5750EC8334339DDA3DC32B86E7B32@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <Z-v4WfcLhmXbYvaa@kernel.org>
 <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-7dqQCiu5fWZ9a9@kernel.org>
 <DM8PR11MB5750131ED71BFF175E3E329CE7A92@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z--OuMuWx8jUdSU1@kernel.org>
 <DM8PR11MB575046992BEACCD83164043CE7AA2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <a0a803275d317f88afdd757afa30e84a26b05656.camel@intel.com>
 <Z_TEzsYnCxXoEhi0@kernel.org> <Z_TFW_0D90wK8BdM@kernel.org>
 <DM8PR11MB5750D5848DC0B3AC0EF00C30E7B52@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z_VAdvT305Rt2h9x@kernel.org>
In-Reply-To: <Z_VAdvT305Rt2h9x@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|DS4PPF708A6BB3E:EE_
x-ms-office365-filtering-correlation-id: 5c6e7073-7afb-41f9-8196-08dd7b29db99
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VlJCVlJsOGtWQTNILzJ5RWJVTDhQT1JVZFN5SVQwVWdCZ0xrZ2V6QjBRY1ox?=
 =?utf-8?B?eDRPVlF5cEZUUzIybGNQMjREaHYvU0YvZkc1cWROd2wwbFo3SWhXVG1RNzZh?=
 =?utf-8?B?NEJEVnJnZ3BQQVdiVElmcWZBaVQ3U0N1R0hGNTRMNFAwY3orME1YQ2JkQTlu?=
 =?utf-8?B?V2RQam96dDQxaFhIbkhvVTh4TTJwSGlrOS9tT1JOSHVCRWdtK0lqemV1dGNj?=
 =?utf-8?B?RUl3QmhVcGozL1BSMHpwcGRZOFhYR0VocDVid00yUG4vRTFwWkdEVHB0VGZ4?=
 =?utf-8?B?QTNMd2syUTNjbUJlWnk1NnZqTGhVeUswL2VHcHcwSnZvSjNvTy9sb1R5TGsy?=
 =?utf-8?B?SE96c1psZHFFcHJhTXloZ0JqWXhQa0NuV3ZucFM2TjA1bU5GbTRwbEJiZjFx?=
 =?utf-8?B?My8xcW9MaEpyUTJHL2tpbVZOQ2JZUUo2enlKZnIwb3EyYXRTZUh1VkhUMTRm?=
 =?utf-8?B?SXRiNjhsdTZDdWpyODFUa1pzeEZOS0oxdnJpYlVRSWdsVFZQejd4KzRGUWt2?=
 =?utf-8?B?b2VPNzNhajhxZTJ2V1Ywa3h5cGZmUXl3cGMxSmZ4SC92VzlEbHJpdHlLakhL?=
 =?utf-8?B?NU53aFdnNFluUXFwN1lBWk5JNndXRWxQYTltaUxzQnIvVEs2TzIrcWJ0QXI2?=
 =?utf-8?B?d2E1SThnb1RpOFVoeTRoL05ZUHBuclYrSnQrWElXaXNWVEJvL3NISXM0enlv?=
 =?utf-8?B?cTRQNHg0UXltdnVERXlDY1htOGFzRW01R2hxdUV2WnFHS1JaU0FHS2R0VndL?=
 =?utf-8?B?M3Z0Mm9Vejd1NnhFTEpBeWQ2dEczRlFNZWRzUWU3dTA0TERZak5la3VlaE5R?=
 =?utf-8?B?Tzl3czd6dlIvb3l4VXRCZTNkS3g4TXZvODhEOXlXVS9zU1pLL2k0eldWVXhV?=
 =?utf-8?B?NXhhVFZac0MxSjlOTXZVZmdOMVNDZnNEYWlPZytkZ04rWlB6dzRDTDJyQmFK?=
 =?utf-8?B?OWJjVFpmeUkvVjNVaWVscTNiWnBOVDJkQ2w0UysxVDlEZWVEWmMzYzJNYUZr?=
 =?utf-8?B?SHFab1JsQXY2WTBiQ0U2ekh4cHV1SFAva0JYR3BQQ2R0V3dCUGJ2T1VKSG0r?=
 =?utf-8?B?dkVUaEU2czVxa2VDVkJwYWRNc0Z5R1h2TXdRMGxxdnBHb1ZwNWN5YmoxcTQz?=
 =?utf-8?B?MFpsUExSd05sUGZSOWVVcG9aODJ5QkdpeFVjUldrRGRLc2UrK1k3bjF0MmZw?=
 =?utf-8?B?NEJYRDQ0bW5sM2thT3EvQ085ZGx2THRKYmFndXA2NEt3Zmp0bWJRdUtSWXNz?=
 =?utf-8?B?eGpkbHhlWHZqOFBoWlR5ZW1DWXBzVGcyc2VHQnhwRjJMaWkxSXEvQThBbEp6?=
 =?utf-8?B?UGdNRndZWFJBQzhNT1NyejlQdUhkaTM5cUF6TjhtN3dyZmlTeVFTVVlRQkRG?=
 =?utf-8?B?TXNIOWh5L1lZZ0dEQmd3c2FIUmlpVXNobW5hRllXTjZIV1V1UzdFQ1crSmlv?=
 =?utf-8?B?UDdvTk16VkZ2d2Q0UXpoaTMxZFhJZFNnWmYvbHlQUDFwZC9haTZWYzFCZElE?=
 =?utf-8?B?cHljcENNZi9JTnNKK1o1bWFCZXlNaFlRK0pPaUp5N2JGYUhOdmVGSTJuUzU4?=
 =?utf-8?B?RVlsWVJMcUV3L2xoNWh2N25EQnhOcURUUmUrSWxuMFNRTDhQMGlKbm5DejdD?=
 =?utf-8?B?Mk5PK0JabmdpL3ZOeTRSZVJsbW55dlZ0c2FybFNqaFk1eG80bVMrY3dvVWJr?=
 =?utf-8?B?d1ovM0QveGFyZlowSUJFYXF3WGNBckVWeWdiYVJzejI1MjEvT2ZsM1VQYjl5?=
 =?utf-8?B?clUyYXVua1BUWG9yaDhmU3Q5SFlpUy9xanI0Qm54K2k5UnlzVVdLN3p3aktZ?=
 =?utf-8?B?bHg0RDVBT1lBcmhWbDZJTVVKbFdMZCtEZ2QrMDJ3ZFNtM2NISG01NW9lRm1p?=
 =?utf-8?B?cERQZVRQYzRXbWRtS2loTEFxZDFKbVNSVEt1QUJGbkFOU0g1dHo1ZFA2MklK?=
 =?utf-8?B?cW53WFpaRFF6Y0w3NkVvOGd4TkliQzRUVTlXU1FOL09ZMytxSjFWNVkvZS9R?=
 =?utf-8?Q?zrknVfg0xkoK6kzmSphic+Zdj4biAI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djB0NU12VXZVZm9HRDZKdWVkWU85SEs1eXRIVTZGcW96K0NIQU1BTDZUS0lQ?=
 =?utf-8?B?amY0YjZDRGVSNVBEOGNBcVVFdlhnY1FtZ1lrUkxsUm9WcFZsdnlmRGlhVFNV?=
 =?utf-8?B?eExJYzF3UlBDSmlVeU9ZM05kYmR1Q0hQRzZMK0lYRDROYi9aNzZFK1gyS1Np?=
 =?utf-8?B?RThCMlFCWEY5RGgvakE4NjF4d0IvZGo2Ri9idEVJeXIrYytQbU5IMUxHVlpN?=
 =?utf-8?B?UU4zRGNXQzBrSk5RNDVjVW5JeURiNUNJSU1vYzQxUG9WT0xKQ0tZT2tGTzFL?=
 =?utf-8?B?d2F1VGw3RnpaNHhaL2JBUmRnVUtWQXVtRkhheGtEekxhOURCdk01RjZRR0p1?=
 =?utf-8?B?Q0Naa1psTjZiY3lyT21EUWJWdWdMOXFRMXZrU1FkR0ExcWpQSlJVVU9MTW1k?=
 =?utf-8?B?bkwxR2J5Mzd5TDVKVXJQMWhVOXpnWEloNzE4VUtaS1NXSmNGMWhGWGNrU1A4?=
 =?utf-8?B?OFVEN3orbklZb2VDVk9wRFRvZ1FOUmlXNFRDWlVWKzgzYmJ0bCtpVG5QTWlG?=
 =?utf-8?B?QWRIZmRVczZuaUJOV2MwcVU4bzk1djhLdGhJL240LzdZMi9ESndoajgyL2pC?=
 =?utf-8?B?QWRzbUpxSEV2RG5oTlg2alcvbnBmb3F0SEs2K0pDeCtSZWNyeUdQWnVrU2hj?=
 =?utf-8?B?andxczFIc1RtRkhyakRidElMNU42STlmTXdoK0Q0SlNzM244S1VYWFhBcUNB?=
 =?utf-8?B?eFJzWEpJQlErVkRCNW1wWGZvME9KdjFsdE0yS0VyaXhOalYwZ29UYW9HNUI3?=
 =?utf-8?B?M1Bydm9pb1E5MjcxOW8yTTVqaGFoc20vaFVJSU9lQXljSXdsdVZFanVBS2pu?=
 =?utf-8?B?dndFQWM2WDlCZFBHV3ppM2RVZS9vV1c2UnE5eGErSW5PMWYwTGFIN0IxZEtJ?=
 =?utf-8?B?ZXhYZm5kMWpiOElaVnNqektpSWdDeC83WXl2MWptQmlOTWxIanZOcXRvVis1?=
 =?utf-8?B?WDhtT2VpU3ZWWTJqT2FOQXl2elRkYXBsOERIMzVvcjdRc3ZQcFVkQVU3b3Yz?=
 =?utf-8?B?TmozaGhNY20xQk55QktQa21nUUVlcjNEelh5NWJmS0tHZVR5cXdvUENCWXFB?=
 =?utf-8?B?d1EwRkxoSnJHV3p5ME5HNCtBWVo0RThsbklUT1IwalZRNHB4emRWNUE4M0xW?=
 =?utf-8?B?ZkhFaURTU0pHMG5NTkYxU1N6U0drWGpsK3Q5cThjRkI1MnBNWlN0SkZNMFRN?=
 =?utf-8?B?Y0YxWDNIRmJpZkgwYnVPQTNRS2NHU0pEbVJMQW9DSkRUMUhvanpzTFFRR3h0?=
 =?utf-8?B?bXUramwvaWVaLy96ZkJoVE9iSE9aa3g2R0xyTmk0OGZiRmZXQzZ5ODB0Q1J1?=
 =?utf-8?B?Wnd6UExUSjNyNTNFbzhDeFdPeEZYOFRKWXBvTzRZVGFXT2gwRW8wVGlNdWZZ?=
 =?utf-8?B?NWo2alNZamgxdnpxOHZNQUhMc0VBK3FqWHRwVmQza1JESmxzNFNSN0JQSDZX?=
 =?utf-8?B?R2dnbEtDWE5Rbmh2NFhUNnV0bVR4bmc0dXZRZEZzS3E1NkY0S0tnSjJuYmZ2?=
 =?utf-8?B?S0Y4WUtka2F3SEVtV0syZEhaRUtvcnFkQkFvZUJ3OVlHR2JQc2JCNEUzQWIv?=
 =?utf-8?B?WTNZR29CNnFmZ2NTdG95c3U0d1BpdlFvUzhvRzNGM3ZYLy81MTB5NXF2cjYr?=
 =?utf-8?B?dHNpc1Y4a2JQSW5wWWxhQ2tDTE1EdjZySEtBYnA4L1MwWUhjSzNUT1dBamNv?=
 =?utf-8?B?c2wwZEV6Z0gxMUtuOVZDQTBtSlRSUHl2MHc5RzJOTVVVaFVyN3Y4SzVkQVdT?=
 =?utf-8?B?Q2RnRm1qYnNUS2JCNlBMOGExWlIyS2tYaWZNaTJEVUppQnd0RjJyN3o2U2Uv?=
 =?utf-8?B?R3NtOU9LVm41UCt0cEVkb3d3Uk81Z1RUNFdFdkwySmJEMHVSNHpOM1Ezaytq?=
 =?utf-8?B?UFl5a0prQlByM2J5MFZEMTlIeWhTQUExTUJLY0dwWDBXMXJlTWVpZTdhLzJW?=
 =?utf-8?B?TVBXTlhkcTliOCsvd2xXd1p6enlpc1JqTXNUdEFWM3BPNG5NZzkwWDZKNVhD?=
 =?utf-8?B?SGVodjZ1NzdDSlBzaHRwamczM3ZXamlyMk9mMWlwTHZPUVo2K1dNRVFNaUdw?=
 =?utf-8?B?Q1JGVCtVWENNcG9CSFVhbWVzQ0xqNkV1V0VQcm84Sk1aOFEwTEZkU2Nhc09t?=
 =?utf-8?B?WWpIeHMrVE1EUmJqc2xSUjY2ZzlIZSsrekcrQkRiL3d2T0plZ242S3d2MTI3?=
 =?utf-8?B?MVE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6e7073-7afb-41f9-8196-08dd7b29db99
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2025 07:56:26.4409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0MUnVrwLH4vP4XheG7DHzLmaJHCn/VmNvE5r9hFqYuqfoLm7XL8SZf6S4MZOnY+IJS9oAIuY+K0zThUY5db4lkAQjFhkvi8C3wXwp8GSM40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF708A6BB3E
X-OriginatorOrg: intel.com

PiANCj4gT24gVHVlLCBBcHIgMDgsIDIwMjUgYXQgMDY6NTQ6MTRBTSArMDAwMCwgUmVzaGV0b3Zh
LCBFbGVuYSB3cm90ZToNCj4gPiA+DQo+ID4gPiBPbiBUdWUsIEFwciAwOCwgMjAyNSBhdCAwOTo0
MDoxNEFNICswMzAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6DQo+ID4gPiA+IE9uIFR1ZSwgQXBy
IDA4LCAyMDI1IGF0IDEyOjA2OjMyQU0gKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiA+
ID4gT24gTW9uLCAyMDI1LTA0LTA3IGF0IDA4OjIzICswMDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdy
b3RlOg0KPiA+ID4gPiA+ID4gPiBPbiBGcmksIEFwciAwNCwgMjAyNSBhdCAwNjo1MzoxN0FNICsw
MDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+ID4gT24gV2VkLCBB
cHIgMDIsIDIwMjUgYXQgMDE6MTE6MjVQTSArMDAwMCwgUmVzaGV0b3ZhLCBFbGVuYQ0KPiA+ID4g
d3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBjdXJyZW50IFNHWCBrZXJuZWwgY29kZSBk
b2VzIG5vdCBoYW5kbGUgc3VjaCBlcnJvcnMgaW4NCj4gYW55DQo+ID4gPiBvdGhlcg0KPiA+ID4g
PiA+ID4gPiB3YXkNCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IHRoYW4gbm90aWZ5aW5nIHRoYXQg
b3BlcmF0aW9uIGZhaWxlZCBmb3Igb3RoZXIgRU5DTFMNCj4gbGVhdmVzLiBTbywNCj4gPiA+IEkg
ZG9uJ3QNCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiA+IHNlZSB3aHkgRU5DTFNbRVVQREFURVNWTl0g
c2hvdWxkIGJlIGRpZmZlcmVudCBmcm9tDQo+ID4gPiBleGlzdGluZw0KPiA+ID4gPiA+ID4gPiA+
ID4gYmVoYXZpb3VyPw0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+ID4gPiA+
ID4gV2hpbGUgbm90IGRpc2FncmVlaW5nIGZ1bGx5IChpdCBkZXBlbmRzIG9uIGNhbGwgc2l0ZSks
IGluIHNvbWUNCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiBzaXR1YXRpb25zIGl0IGlzIG1vcmUgZGlm
ZmljdWx0IHRvIHRha2UgbW9yZSBwcmV2ZW50aXZlDQo+IGFjdGlvbnMuDQo+ID4gPiA+ID4gPiA+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiA+ID4gPiBUaGlzIGlzIGEgc2l0dWF0aW9uIHdoZXJl
IHdlIGtub3cgdGhhdCB0aGVyZSBhcmUgKnplcm8qIEVQQw0KPiA+ID4gcGFnZXMgaW4NCj4gPiA+
ID4gPiA+ID4gPiA+ID4gPiB0cmFmZmljIHNvIGl0IGlzIHJlbGF0aXZlbHkgZWFzeSB0byBzdG9w
IHRoZSBtYWRuZXNzLCBpc24ndCBpdD8NCj4gPiA+ID4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gPiA+ID4gPiA+IEkgZ3Vlc3MgdGhlIGJlc3QgYWN0aW9uIHdvdWxkIGJlIG1ha2Ugc2d4X2Fs
bG9jX2VwY19wYWdlKCkNCj4gPiA+IHJldHVybg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+IGNvbnNp
c3RlbnRseSAtRU5PTUVNLCBpZiB0aGUgdW5leHBlY3RlZCBoYXBwZW5zLg0KPiA+ID4gPiA+ID4g
PiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+ID4gPiBCdXQgdGhpcyB3b3VsZCBiZSB2ZXJ5IG1pc2xl
YWRpbmcgaW1vLiBXZSBkbyBoYXZlIG1lbW9yeSwNCj4gPiA+IGV2ZW4gcGFnZQ0KPiA+ID4gPiA+
ID4gPiA+ID4gPiBhbGxvY2F0aW9uIG1pZ2h0IGZ1bmN0aW9uIGFzIG5vcm1hbCBpbiBFUEMsIHRo
ZSBvbmx5IHRoaW5nIHRoYXQNCj4gaXMNCj4gPiA+IGJyb2tlbg0KPiA+ID4gPiA+ID4gPiA+ID4g
PiBjYW4gYmUgRVVQREFURVNWTiBmdW5jdGlvbmFsaXR5LiBSZXR1cm5pbmcgLUVOT01FTSBpbg0K
PiB0aGlzDQo+ID4gPiBjYXNlDQo+ID4gPiA+ID4gPiA+IHNlZW1zDQo+ID4gPiA+ID4gPiA+ID4g
PiA+IHdyb25nLg0KPiA+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiA+IFRoaXMgbWFr
ZXMgaXQgbm90IG1pc2xlYWRpbmcgYXQgYWxsOg0KPiA+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4g
PiA+ID4gPiA+IAlwcl9lcnIoIkVVUERBVEVTVk46IHVua25vd24gZXJyb3IgJWRcbiIsIHJldCk7
DQo+ID4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+ID4gU2luY2UgaGFyZHdhcmUgc2hv
dWxkIG5ldmVyIHJldHVybiB0aGlzLCBpdCBpbmRpY2F0ZXMgYSBrZXJuZWwNCj4gYnVnLg0KPiA+
ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+ID4gT0ssIHNvIHlvdSBwcm9wb3NlIGluIHRoaXMg
Y2FzZSB0byBwcmludCB0aGUgYWJvdmUgbWVzc2FnZSwNCj4gPiA+IHNneF91cGRhdGVzdm4NCj4g
PiA+ID4gPiA+ID4gPiByZXR1cm5pbmcgYW4gZXJyb3IsIGFuZCB0aGVuIE5VTEwgZnJvbQ0KPiA+
ID4gX19zZ3hfYWxsb2NfZXBjX3BhZ2VfZnJvbV9ub2RlDQo+ID4gPiA+ID4gPiA+IGFuZA0KPiA+
ID4gPiA+ID4gPiA+IHRoZSBfX3NneF9hbGxvY19lcGNfcGFnZSByZXR1cm5pbmcgLUVOT01FTSBh
ZnRlciBhbiBpdGVyYXRpb24NCj4gPiA+IG92ZXINCj4gPiA+ID4gPiA+ID4gPiBhIHdob2xlIHNl
dCBvZiBudW1hIG5vZGVzIGdpdmVuIHRoYXQgd2Ugd2lsbCBrZWVwIGdldHRpbmcgdGhlDQo+ID4g
PiB1bmtub3duDQo+ID4gPiA+ID4gPiA+IGVycm9yDQo+ID4gPiA+ID4gPiA+ID4gb24gZWFjaCBu
b2RlIHVwb24gdHJ5aW5nIHRvIGRvIGFuIGFsbG9jYXRpb24gZnJvbSBlYWNoIG9uZT8NCj4gPiA+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gSSdkIGRpc2FibGUgaW9jdGwncyBpbiB0aGlzIGNhc2Ug
YW5kIHJldHVybiAtRU5PTUVNLiBJdCdzIGEgY2hlYXANCj4gc2FuaXR5DQo+ID4gPiA+ID4gPiA+
IGNoZWNrLiBTaG91bGQgbm90IGV2ZXIgaGFwcGVuLCBidXQgaWYgZS5nLiwgYSBuZXcga2VybmVs
IHBhdGNoDQo+IGJyZWFrcw0KPiA+ID4gPiA+ID4gPiBhbnl0aGluZywgaXQgY291bGQgaGVscCBj
YXRjaGluZyBpc3N1ZXMuDQo+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+IFdlIGFyZSB0YWxr
aW5nIGhlcmUgYWJvdXQgc2l0dWF0aW9uIHRoYXQgaXMgbmV2ZXIgZXhwZWN0ZWQgdG8NCj4gaGFw
cGVuDQo+ID4gPiBzbyBJDQo+ID4gPiA+ID4gPiA+IGRvbid0IHRoaW5rIGl0IGlzIHRvbyBoZWF2
eSBoYW1tZXIgaGVyZS4gSGVyZSBpdCBtYWtlcyBzZW5zZQ0KPiBiZWNhdXNlDQo+ID4gPiBub3QN
Cj4gPiA+ID4gPiA+ID4gbXVjaCBlZmZvcnQgaXMgcmVxdWlyZWQgdG8gaW1wbGVtZW50IHRoZSBj
b3VudGVyLW1lYXN1cmVzLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IE9LLCBidXQgZG9lcyBp
dCByZWFsbHkgbWFrZSBzZW5zZSB0byBleHBsaWNpdGx5IGRpc2FibGUgaW9jdGxzPw0KPiA+ID4g
PiA+ID4gTm90ZSB0aGF0IGV2ZXJ5dGhpbmcgKmluIHByYWN0aWNlKiB3aWxsIGJlIGRpc2FibGVk
IHNpbXBseSBiZWNhdXNlDQo+IG5vdCBhDQo+ID4gPiBzaW5nbGUgcGFnZQ0KPiA+ID4gPiA+ID4g
YW55bW9yZSBjYW4gYmUgYWxsb2NhdGVkIGZyb20gRVBDIHNpbmNlIHdlIGFyZSBnZXR0aW5nIC1F
Tk9NRU0NCj4gb24NCj4gPiA+IEVQQw0KPiA+ID4gPiA+ID4gcGFnZSBhbGxvY2F0aW9uLiBBbHNv
LCBub3RlIHRoYXQgYW55IGFwcHJvYWNoIHdlIGNob3NlIHNob3VsZCBiZQ0KPiA+ID4gc3ltbWV0
cmljYWwNCj4gPiA+ID4gPiA+IHRvIFNHWCB2aXJ0dWFsaXphdGlvbiBzaWRlIGFsc28sIHdoaWNo
IGRvZXNuwrR0IHVzZSBpb2N0bHMgYXQgYWxsLiBTaW1wbHkNCj4gPiA+IHJldHVybmluZw0KPiA+
ID4gPiA+ID4gLUVOT01FTSBmb3IgcGFnZSBhbGxvY2F0aW9uIGluIEVQQyBzZWVtcyBsaWtlIGEg
Y29ycmVjdA0KPiBzeW1tZXRyaWNhbA0KPiA+ID4gc29sdXRpb24NCj4gPiA+ID4gPiA+IHRoYXQg
d291bGQgd29yayBmb3IgYm90aCBuYXRpdmVsIGVuY2xhdmVzIGFuZCBFUEMgcGFnZXMgYWxsb2Nh
dGVkDQo+IGZvcg0KPiA+ID4gVk1zLg0KPiA+ID4gPiA+ID4gQW5kIG5vdGhpbmcgd291bGQgIGJl
IGFibGUgdG8gcHJvY2VlZCBjcmVhdGluZy9tYW5hZ2luZyBlbmNsYXZlcw0KPiBhdA0KPiA+ID4g
dGhpcyBwb2ludC4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBSaWdodCwgZmFp
bGluZyBpb2N0bHMoKSBkb2Vzbid0IGNvdmVyIFNHWCB2aXJ0dWFsaXphdGlvbi4gIElmIHdlIGV2
ZXIgd2FudA0KPiB0bw0KPiA+ID4gPiA+IGZhaWwsIHdlIHNob3VsZCBmYWlsIHRoZSBFUEMgYWxs
b2NhdGlvbi4NCj4gPiA+ID4NCj4gPiA+ID4gIkkgZ3Vlc3MgdGhlIGJlc3QgYWN0aW9uIHdvdWxk
IGJlIG1ha2Ugc2d4X2FsbG9jX2VwY19wYWdlKCkgcmV0dXJuDQo+ID4gPiA+ICBjb25zaXN0ZW50
bHkgLUVOT01FTSwgaWYgdGhlIHVuZXhwZWN0ZWQgaGFwcGVucy4iIC1tZQ0KPiA+ID4gPg0KPiA+
ID4gPiA+DQo+ID4gPiA+ID4gQnR3LCBmb3IgdGhlIHVua25vd24gZXJyb3IsIGFuZCBhbnkgb3Ro
ZXIgZXJyb3JzIHdoaWNoIHNob3VsZCBub3QNCj4gPiA+IGhhcHBlbiwNCj4gPiA+ID4gPiBjb3Vs
ZG4ndCB3ZSB1c2UgdGhlIEVOQ0xTX1dBUk4oKT8gIEFGQUlDVCB0aGVyZSBhcmUgYWxyZWFkeSBj
YXNlcw0KPiB0aGF0DQo+ID4gPiB3ZSBhcmUNCj4gPiA+ID4gPiB1c2luZyBFTkNMU19XQVJOKCkg
Zm9yIHRob3NlICJpbXBvc3NpYmxlLXRvLWhhcHBlbi1lcnJvcnMiLg0KPiA+DQo+ID4gT2ssIHNv
IHRvIHN1bW1hcmlzZSB0aGUgYXBwcm9hY2ggSSB3aWxsIGJlIHNlbmRpbmcgaW4gdGhlIG5leHQg
dmVyc2lvbjoNCj4gPg0KPiA+IEluIGNhc2UgdW5rbm93biBlcnJvciByZXR1cm5zLCBpc3N1ZSBF
TkNMU19XQVJOICh1c2VzIFdBUk5fT04NCj4gdW5kZXJuZWF0aCkNCj4gPiBhbmQgcmV0dXJuIC1F
Tk9NRU0gZnJvbSBFUEMgcGFnZSBhbGxvY2F0aW9uLiBObyBvdGhlciBleHBsaWNpdCBpb2N0bA0K
PiBkaXNhYmxpbmcgbmVlZGVkDQo+ID4gc2luY2Ugbm90aGluZyBjYW4gcHJvY2VlZCBhbnlob3cg
aWYgd2UgY2Fubm90IGFsbG9jYXRlIGEgcGFnZSBmcm9tIEVQQy4NCj4gPg0KPiA+IERvZXMgdGhp
cyBzb3VuZCByaWdodD8NCj4gDQo+IEkgdGhpbmsgaXQgc2hvdWxkIGJlIHN1ZmZpY2llbnQgKG5v
dCBhIHJldmlldyB0aG8pLg0KDQpTb3VuZHMgZ29vZCwgdGhhbmsgeW91ISBJIHdpbGwgcmVzcGlu
IGEgbmV3IHZlcnNpb24gc29vbi4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
