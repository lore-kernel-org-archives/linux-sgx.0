Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D026225797;
	Mon,  7 Apr 2025 08:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014227; cv=fail; b=HHh5jF5/sRrLessLkY1P9j0L1CBRug7UWIeyy5RewFxHKNi+bfHZoccROX8dOEcGQHeM+ZGs4Xuu1xQOaYqKq63j4xHgF9s0YoxiVtpkJlOsYOOb0V1YBleN6tRiay6xwhPO35hILWyklMoaiMGWb/1lvl4h4/RgSKn3Aieq8PA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014227; c=relaxed/simple;
	bh=O9j0aAYrOfcjSpHR8LkwyTgxk/UZ+rICvbwi6T0kI5s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=owKcson09h96tQ0VEWi0Ba3mZfVw/a9gdf5Uk/Q4EggMVL4IC0LlX2XW/t2CyYqqFhrKj8o0atqKJRsUlC2iroiM+J3mQ9dwn6yeLxH+PCdeabAm4QtjwryAWxMMGa9XrmN6/Bagw+2/ud1q+/e0EoNtP/nIgoUind2Eb6bWBXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a2r6bBXi; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a2r6bBXi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744014225; x=1775550225;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O9j0aAYrOfcjSpHR8LkwyTgxk/UZ+rICvbwi6T0kI5s=;
  b=a2r6bBXidZnaF5ISd0aSsQYFL1B941D+HiQV6f3VTD4SqK4+kdJnIUkD
   qwL1WPqkE2JzAEzWxNHhq6XN5AsJIkLFX1xcSB5IjzochcRd68f0nGsnw
   kULEx6GS3oMHroS7xskmMWCArVTkrme/dKtHVLVirg+d1Qa2GvJ0wxnPt
   Sq6HtbCasqmwy8Fysq030zvP0l62Htu+UPfTOKbOWzCETQartMWK/eK3L
   I1kl76YSnX/kKdAvFvbdsAOFWZVef+DMSfbG7eaR2MqlhtQFDxRUoFTZ8
   70KZiioONBSzhqx5SxCflUqhhse9XABuUNb1uDbS1bXAHuhCeQRAFkIxw
   w==;
X-CSE-ConnectionGUID: zKrFvHm4RPeYZT610n24ig==
X-CSE-MsgGUID: q1bfg+5dRRGtidncXrYydg==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="62782942"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="62782942"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 01:23:44 -0700
X-CSE-ConnectionGUID: s6dzrtJ/Q42BBr7uaXenzA==
X-CSE-MsgGUID: ni2J924oRN2X0t06s08PeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="127880605"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 01:23:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 7 Apr 2025 01:23:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 7 Apr 2025 01:23:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 7 Apr 2025 01:23:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epmAdXxmpnD5zKEzHmTmkNcvkxF/YQIVX4EO6vURovetQ1QP0hEat0CUDX940TuAioFGhbrws+Vf98B3XZz0EsFn7ReSCo+5zIVoiwvLr/prXLsnZRKK3jE9JPyJHTN88jkjmJNmUaM/CV15V4ylWOf2RD97LXl2zuHPbolxReT24KYS+Rb7RclxMFLAgrRFq0yY33/LZoUtUNSUD2PYicQpAGyReGTYMzGE5kBqJWBteakqeLt6PlPtpT6Vf/H2vBuqkjDsjpdSHci4SulIa5+aB1dUqZweL+05DrL9X22EsNgLobbGdcH66OpbZJctAQEFtOnPeMLN32UeOPZFtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9j0aAYrOfcjSpHR8LkwyTgxk/UZ+rICvbwi6T0kI5s=;
 b=jQ5/nZha5TmLAMHuC0qJrVdLiGDZytpWsUH5z6zs3G+8wo4ctP+gnq/cqk8uu3m6VfTdFZMF+3kLslqm7Wdnskhroex8wqHXvg5UJC74uizO4+xrKEV5OW1YK/5BEyU/PYsMIxRmmaJ0JyCHwbJMxFqoQE6+STWJDf6iBUxppCcNVWqzM454cYs+WFU89WTevDULAI2R1BzM8xWX6peokqQKVeUpZ4CyviqMSTv9FUKo3uUwEmUYKYvu7Pzm+iV3iQaV+z6fXh2Xe3QHoIsptSjMf0mz67mzpzI6H07JvyOlFQsUFutNUpR4fD3A5pPVH61wY8Pvf1/mCNKlQz0ijA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DM4PR11MB6142.namprd11.prod.outlook.com (2603:10b6:8:b2::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.34; Mon, 7 Apr 2025 08:23:06 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8606.033; Mon, 7 Apr 2025
 08:23:06 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Annapurve, Vishal" <vannapurve@google.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "bondarn@google.com" <bondarn@google.com>, "Raynor,
 Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbn+FDiJjsRSw2cUyPYDKGfVHjnbOI1BeAgAAEgICABAKjsIAArrUAgAEIZUCAAFLwgIABevGQgAH4xoCAAMDIQIAAEkoAgAS/YyA=
Date: Mon, 7 Apr 2025 08:23:05 +0000
Message-ID: <DM8PR11MB575046992BEACCD83164043CE7AA2@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250328125859.73803-3-elena.reshetova@intel.com>
 <Z-bhczXA6aHdCYHq@kernel.org> <Z-blOQ94ymUsDwPn@kernel.org>
 <DM8PR11MB5750C88DFC518EB77B0D613FE7AD2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-rU_JXWn0vCdBr_@kernel.org>
 <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-v4WfcLhmXbYvaa@kernel.org>
 <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-7dqQCiu5fWZ9a9@kernel.org>
 <DM8PR11MB5750131ED71BFF175E3E329CE7A92@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z--OuMuWx8jUdSU1@kernel.org>
In-Reply-To: <Z--OuMuWx8jUdSU1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|DM4PR11MB6142:EE_
x-ms-office365-filtering-correlation-id: 2feda76b-81bb-456a-7921-08dd75ad6c20
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bEZNWUhqM1BlRVNXQ0hXNTdYT1k2S0lubW1md0ljcERKUlV5TzYyM3FJdWs1?=
 =?utf-8?B?MU1kd1JJaHV3UWRFblhaWVNOQVFmdTE5V0JIOVEya1JSMTRxQ09MTWREVi95?=
 =?utf-8?B?enBGMHh6R3FhdTBTclhkMlpmbjFoS3I3aHROTTFkUUdwdVU0cjRFZk50THo0?=
 =?utf-8?B?NGo2RlFhZ0gvNnc3cVgyTE5TTUVLbDN2Qm1ra0Nvb0lHMFlPN1FEU3FGV0d2?=
 =?utf-8?B?cUZ5YVpqVzQya052UFNxYlIwc2VwSEJZbGs3RmcxbnNiQ1FYQnI5M29pYmgv?=
 =?utf-8?B?REFOODh4OW02ZnM4UFlINXAycTR4WERWWVYydHQxS2dXeGhFWWd3cVIvdTFZ?=
 =?utf-8?B?eS95OXk3dXBabThOaFEzdHIvRHpUZkt1em5MMUpraGhBRVdVRlBGdjZZTUda?=
 =?utf-8?B?dEFlYjV0b0ZGVkQwNzRTbW43R1RwOTk4MXhyR3VteDA3U203RDNmb0VMU2NP?=
 =?utf-8?B?UnBwbEcydzVCNnJEYTUzbFNUcWtLL1FOS0NmL255aERpZTZQbW5rZzhLYU5N?=
 =?utf-8?B?VFFWcUVYNGFsc0x4MUxCVEROVWpjSVZHVXhhZVFFdXNwci9MazFSamtkZ2Yy?=
 =?utf-8?B?L2N6Sm1BM3BQcjAzMWRpdTV5UDNUNUU0U3pGZVBRNWhJSUF6c1ZRQ09BbjdL?=
 =?utf-8?B?Q2JtSXdJMTVCSDJSczM1S1cwU0c2anRPa3NSOGZDNjViK2gvWElJczB4emd4?=
 =?utf-8?B?eEVOSkdBZ1dlK29lWlZpbmtQS3FYTU1Vd1lESFZZWmx1Z2Y0VUFoQXN6Qk1I?=
 =?utf-8?B?UTFXWkdsL1UyWTUzcmNJZUFNa2dmRG1VOXlObE9paGJPY0REdE9vcUtHUWdo?=
 =?utf-8?B?RHcyY203dFBzaUI5Mi9Bdi9naU50VDI2bkkwSzMzZ2VOM3cyZmRwdTNDQnZm?=
 =?utf-8?B?ZXRhVDJOTjVXV3ZhR0c1RDhSMEU1dlIrbERBQjJ0aE1uQnRET1IwUkxGeHVa?=
 =?utf-8?B?NTB0d0RjVldNZUs4eGtnK0liSm9IK0REZXFNZGlGTGVnVTlLM0cxcmtjTHJZ?=
 =?utf-8?B?TzN6YWRQRGJMaHkzeUNGYTUwTXF4N0VZVytLd1F6WGZqZ2xKKy9GeVhndjN0?=
 =?utf-8?B?S29Fc21UeDVaR1J4S1VZMGQ0ZWovbENvYkRhY1E5RzRNRWg1amhQcDFLU0U2?=
 =?utf-8?B?Yk05ZVQxdHRyTjRzcGVhcE9KYkV4cG5NcmR5QWhLaEVzVjk3UTZqcGtlWHB0?=
 =?utf-8?B?Um5VN0puS3dkdjk5M0M1SzltNHc5TG56UlFNRnhLNE9TRkUxd3BqaWpwNHhl?=
 =?utf-8?B?VGZUUzlzbGVOaFJZcWRDSUR0OXdkUmIzQW8xbmsxQ21qanplTm1XUTdWVGVa?=
 =?utf-8?B?d1REL3FkTDlIQkkrVVlnUjRsK2VydWRzRjVUd2ZNb3BIQmhDcUJuWWNVVldY?=
 =?utf-8?B?SWdyNUFVcis3eHc0cFVKWXZ6YnF2OUNneVJSQ2FOMjJoLzM3d05rWXIyWlBU?=
 =?utf-8?B?Wk1SdG5LaGdFWmxEaVlGOGNqMDFqR2dYcGJBa0VoVGFKUGZXV28wTVdteE90?=
 =?utf-8?B?M2c2MXFzOUFiWkdJdFcwOUlQMVVlZjhjeUU4MjFQdDluWlVYZWVQWG9OUGtw?=
 =?utf-8?B?RWViUDRWeEtWeXBXZjEvaERYNGJWcCttT3g0MkRkbUxOT0lncWVLSk9mNlpl?=
 =?utf-8?B?SE5TbXRFV0NRNUtZbnlqakJuSlVRekRpVFREMW9DcXErZ1QxOFJZN2FkeEo0?=
 =?utf-8?B?Z0F3V0E3SVc2aGMzS1h2dzJMWEdhUHJwbkpNMkcyVDF1Z3UzL3VISFdHbU0x?=
 =?utf-8?B?allZZlF5UXpaeHdSKytXVGFqUlpLaTFWcVRHdjNKRWNHTStqYXk2RXRaL1Zh?=
 =?utf-8?B?blZoNWtWSTlzaGpKRGgyWC9MMis0U2FLVkJpNS9UQ0MvR2pVenRKTVZVN3l5?=
 =?utf-8?B?d2NMdWRINVpZWkxvcnZEb010UXEybXBYQU5FVmVuSTY4NzJYL1VzOXpQR3hV?=
 =?utf-8?Q?FcLPwrMYm/t7kisod8bEXFO9sA/6NxcG?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ek9OSmxON0UxQXBucWhqdy9kWTVQVGIvTktkL0NKRGtoMmVFZWpRcEcxQjdx?=
 =?utf-8?B?S25qV0hBdjBTVHNOMEttT29uYTYvbVRFdmx6MlgyU3QyQWJBaFA4VmpJSSsz?=
 =?utf-8?B?U0tZazBORzBsdnhSMTBRa1dBdUZJWWxYek9hd0hFOXE5ZlZlQzZqYTBTbDcy?=
 =?utf-8?B?b0Mwc0tzNG0zeThEZndON1AzS2Q1YzQzMXZlK1V2MWpWSXhCWno3UWJzT3U1?=
 =?utf-8?B?SStLTzVlNEI2TGI2eXRDdURCT1RYR1BxYUFXZW94VmxEczNzQUowWHpvQ1Bo?=
 =?utf-8?B?SVhsTEtlWk82Vm1Td1FRbmFTOS9FNkltTHlOdTA0S1NCa2lqM3FCb0dOOXZh?=
 =?utf-8?B?dWJoblFLRWNHSlhlc1dBaHAzVm11L1IvZFZDR2NHeVBOY0pHa0ttZ0E1Vkkw?=
 =?utf-8?B?RGlOUUVZVEp1aWJER3FHbzErdkswSXlBN3hXZXc5eU81dHBzL3FTa09DeG9l?=
 =?utf-8?B?ckY5YkZacUNDRWFoZER6ckdaeWFzWFgxZzhaRUVtVXZjc3h2cysvVkRvdkll?=
 =?utf-8?B?aUN5ZnJnOW51U2ZvdEV4cTNsclZ1US9BN0Y0MHNtUGV4bzlYcGs2NXFOR1VW?=
 =?utf-8?B?cFFDNk1JTlVxRTZNNTF1SDdyNEF1dTFGbXFZOWQwTDVvYlRBRThZbUtYR2ZO?=
 =?utf-8?B?OWwvZzBqYXVHV24wcUVpTWtjNWFYSWZvb0Uvb093cXBSVnpmOHJCSFl4dzV3?=
 =?utf-8?B?UHltQmNhZ2tVZ09hKzdUeXRScE5takFtYk51NktacXBlb1B4czRFR2hBWEZt?=
 =?utf-8?B?czlTK0RZMkZFVWFjTFdTQ0xXUjN4ZXdOMWNTdE1uNHlZTTRHNXVzSFR5NVA1?=
 =?utf-8?B?TTUvaExvZktSRk14dUltUVhmaUJKTGY0ZG9hbUxJNTJCK2dOQ1hqWC83UHNz?=
 =?utf-8?B?T3JJcGFEWmVEeTVJM3JwemYxT0VKZFpGcDdjZnJGTDhHNVZ6RlBHb05tUE10?=
 =?utf-8?B?V3hwdUlqRnB2enZhdjBwUHNhZmxSWDViV3VFdmhRUG1FaVVkbUZNRUtNemZw?=
 =?utf-8?B?SWdmNXdCMXlWRjRIaVFldk5WYW9TWEhwQTgrQW0zcVdjOUg0TXlpU2hPWkxY?=
 =?utf-8?B?TDdiYU9jMUlnTVlxUU5NcnFEQXVRL3U3UG1XeWpsSk4rNDBKQXUzOUR0VXZZ?=
 =?utf-8?B?Qzk0T2FuS1pxc1FkV2thWmxBZk55Ujc4YUswUkJqVm15YVQ5eEFZNWxHQitI?=
 =?utf-8?B?alhQWnNsWlhvU3FuNlh1aUFTTXdxTi8xS3VFWXBnZlMxNmg3b0l3OC9Mellr?=
 =?utf-8?B?KzNEVFB4Ym9QOHlzQ1BENFFJQ2xldVJqNG1BZXpYdFpKd3RrU0lLRGhBQTVQ?=
 =?utf-8?B?cXJkSVZhWTlmZVUxTncxQk1sc3pDQ09uNTZpaVQ1UjZ0Q200WU9MVGxXeUI5?=
 =?utf-8?B?aXVabi9zZkFKOHFHaStFRGdRQW44dDVEVXpBL25zNFZCVitVaGFVZ014TTVs?=
 =?utf-8?B?ZmNSMzVLVkFrZ3BRanVKbXhyN3E1OEp5NDIxS1NOeHdVYmxuM1B5VVFiSjdW?=
 =?utf-8?B?c1FjdlFoYndpdEUyelRrRXhpRzlldHA2ZEVITFZhYzNjU2I5cGtXZS9Banp2?=
 =?utf-8?B?RHhwU3dsQ2xXdE11R2N5ckJRYkFycGZGQ2JYNkVSNnA1OTNzYnJjMGd3WUU4?=
 =?utf-8?B?a3ljY2NNanllWnNqQ2VyS3dMYUlGYXJoMGVZMk80Z3ZNNFJEYTZ6bE44TGJO?=
 =?utf-8?B?V2ZycHlTYU5kTVBlQkczbGR1VnJZc0xWbjB3VENzK0QrR3JiNTQ5NDNjcDBC?=
 =?utf-8?B?YXRCY05JQTBtVE56ZjZrL0VUQ3k4bHMyLytYTkt3MFVpeFo3dm82V0RMR003?=
 =?utf-8?B?WmVHV1lwcTg5QlFkSUFiUXJraUlXTzZTUnpMTGM2QXVUL0E3UGZmaDAzZXhD?=
 =?utf-8?B?WmI4aE5rdjFsaXdNb2c2MVBMZkRYTWpXbDFjaDFrL3FOWGlQSWdQZk1mRi84?=
 =?utf-8?B?TGNqeEJpOVE5VzZGcUJjSVg4d3ZGZVN3YmlobUpybllncTNKVmJBa0FZYjVF?=
 =?utf-8?B?R2ttZEpOMXh4ZW1MTVcrRFh0cWYzck5aeFQ3WW5PM3ZFSWZobXVsNG04Vjda?=
 =?utf-8?B?YWpDN0ROcFJvR0w2dVFCTnhrc0ZlVCtsUVJGZWVTS2tCcmkyUklvUTRObVg5?=
 =?utf-8?B?dnNDeUlXbVhqbzZLQkxRczBaUW11UnhDbThGaXFJMEkyVjNqMTA4aXY2UU5a?=
 =?utf-8?B?S0E9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2feda76b-81bb-456a-7921-08dd75ad6c20
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2025 08:23:05.7632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CfDaUp6uSiCW0M3BtXhMrU8uFNXJEe/+J/sudZsVuJZkD2/Bud8w850CUMKJcdLyXdsr3sDRC/y0AO6HEnD/4UYuapsflh2199dyb53xPOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6142
X-OriginatorOrg: intel.com

DQo+IE9uIEZyaSwgQXByIDA0LCAyMDI1IGF0IDA2OjUzOjE3QU0gKzAwMDAsIFJlc2hldG92YSwg
RWxlbmEgd3JvdGU6DQo+ID4gPiBPbiBXZWQsIEFwciAwMiwgMjAyNSBhdCAwMToxMToyNVBNICsw
MDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3RlOg0KPiA+ID4gPiA+ID4gY3VycmVudCBTR1gga2Vy
bmVsIGNvZGUgZG9lcyBub3QgaGFuZGxlIHN1Y2ggZXJyb3JzIGluIGFueSBvdGhlcg0KPiB3YXkN
Cj4gPiA+ID4gPiA+IHRoYW4gbm90aWZ5aW5nIHRoYXQgb3BlcmF0aW9uIGZhaWxlZCBmb3Igb3Ro
ZXIgRU5DTFMgbGVhdmVzLiBTbywgSSBkb24ndA0KPiA+ID4gPiA+ID4gc2VlIHdoeSBFTkNMU1tF
VVBEQVRFU1ZOXSBzaG91bGQgYmUgZGlmZmVyZW50IGZyb20gZXhpc3RpbmcNCj4gPiA+IGJlaGF2
aW91cj8NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFdoaWxlIG5vdCBkaXNhZ3JlZWluZyBmdWxseSAo
aXQgZGVwZW5kcyBvbiBjYWxsIHNpdGUpLCBpbiBzb21lDQo+ID4gPiA+ID4gc2l0dWF0aW9ucyBp
dCBpcyBtb3JlIGRpZmZpY3VsdCB0byB0YWtlIG1vcmUgcHJldmVudGl2ZSBhY3Rpb25zLg0KPiA+
ID4gPiA+DQo+ID4gPiA+ID4gVGhpcyBpcyBhIHNpdHVhdGlvbiB3aGVyZSB3ZSBrbm93IHRoYXQg
dGhlcmUgYXJlICp6ZXJvKiBFUEMgcGFnZXMgaW4NCj4gPiA+ID4gPiB0cmFmZmljIHNvIGl0IGlz
IHJlbGF0aXZlbHkgZWFzeSB0byBzdG9wIHRoZSBtYWRuZXNzLCBpc24ndCBpdD8NCj4gPiA+ID4g
Pg0KPiA+ID4gPiA+IEkgZ3Vlc3MgdGhlIGJlc3QgYWN0aW9uIHdvdWxkIGJlIG1ha2Ugc2d4X2Fs
bG9jX2VwY19wYWdlKCkgcmV0dXJuDQo+ID4gPiA+ID4gY29uc2lzdGVudGx5IC1FTk9NRU0sIGlm
IHRoZSB1bmV4cGVjdGVkIGhhcHBlbnMuDQo+ID4gPiA+DQo+ID4gPiA+IEJ1dCB0aGlzIHdvdWxk
IGJlIHZlcnkgbWlzbGVhZGluZyBpbW8uIFdlIGRvIGhhdmUgbWVtb3J5LCBldmVuIHBhZ2UNCj4g
PiA+ID4gYWxsb2NhdGlvbiBtaWdodCBmdW5jdGlvbiBhcyBub3JtYWwgaW4gRVBDLCB0aGUgb25s
eSB0aGluZyB0aGF0IGlzIGJyb2tlbg0KPiA+ID4gPiBjYW4gYmUgRVVQREFURVNWTiBmdW5jdGlv
bmFsaXR5LiBSZXR1cm5pbmcgLUVOT01FTSBpbiB0aGlzIGNhc2UNCj4gc2VlbXMNCj4gPiA+ID4g
d3JvbmcuDQo+ID4gPg0KPiA+ID4gVGhpcyBtYWtlcyBpdCBub3QgbWlzbGVhZGluZyBhdCBhbGw6
DQo+ID4gPg0KPiA+ID4gCXByX2VycigiRVVQREFURVNWTjogdW5rbm93biBlcnJvciAlZFxuIiwg
cmV0KTsNCj4gPiA+DQo+ID4gPiBTaW5jZSBoYXJkd2FyZSBzaG91bGQgbmV2ZXIgcmV0dXJuIHRo
aXMsIGl0IGluZGljYXRlcyBhIGtlcm5lbCBidWcuDQo+ID4NCj4gPiBPSywgc28geW91IHByb3Bv
c2UgaW4gdGhpcyBjYXNlIHRvIHByaW50IHRoZSBhYm92ZSBtZXNzYWdlLCBzZ3hfdXBkYXRlc3Zu
DQo+ID4gcmV0dXJuaW5nIGFuIGVycm9yLCBhbmQgdGhlbiBOVUxMIGZyb20gX19zZ3hfYWxsb2Nf
ZXBjX3BhZ2VfZnJvbV9ub2RlDQo+IGFuZA0KPiA+IHRoZSBfX3NneF9hbGxvY19lcGNfcGFnZSBy
ZXR1cm5pbmcgLUVOT01FTSBhZnRlciBhbiBpdGVyYXRpb24gb3Zlcg0KPiA+IGEgd2hvbGUgc2V0
IG9mIG51bWEgbm9kZXMgZ2l2ZW4gdGhhdCB3ZSB3aWxsIGtlZXAgZ2V0dGluZyB0aGUgdW5rbm93
bg0KPiBlcnJvcg0KPiA+IG9uIGVhY2ggbm9kZSB1cG9uIHRyeWluZyB0byBkbyBhbiBhbGxvY2F0
aW9uIGZyb20gZWFjaCBvbmU/DQo+IA0KPiBJJ2QgZGlzYWJsZSBpb2N0bCdzIGluIHRoaXMgY2Fz
ZSBhbmQgcmV0dXJuIC1FTk9NRU0uIEl0J3MgYSBjaGVhcCBzYW5pdHkNCj4gY2hlY2suIFNob3Vs
ZCBub3QgZXZlciBoYXBwZW4sIGJ1dCBpZiBlLmcuLCBhIG5ldyBrZXJuZWwgcGF0Y2ggYnJlYWtz
DQo+IGFueXRoaW5nLCBpdCBjb3VsZCBoZWxwIGNhdGNoaW5nIGlzc3Vlcy4NCj4gDQo+IFdlIGFy
ZSB0YWxraW5nIGhlcmUgYWJvdXQgc2l0dWF0aW9uIHRoYXQgaXMgbmV2ZXIgZXhwZWN0ZWQgdG8g
aGFwcGVuIHNvIEkNCj4gZG9uJ3QgdGhpbmsgaXQgaXMgdG9vIGhlYXZ5IGhhbW1lciBoZXJlLiBI
ZXJlIGl0IG1ha2VzIHNlbnNlIGJlY2F1c2Ugbm90DQo+IG11Y2ggZWZmb3J0IGlzIHJlcXVpcmVk
IHRvIGltcGxlbWVudCB0aGUgY291bnRlci1tZWFzdXJlcy4NCg0KT0ssIGJ1dCBkb2VzIGl0IHJl
YWxseSBtYWtlIHNlbnNlIHRvIGV4cGxpY2l0bHkgZGlzYWJsZSBpb2N0bHM/IA0KTm90ZSB0aGF0
IGV2ZXJ5dGhpbmcgKmluIHByYWN0aWNlKiB3aWxsIGJlIGRpc2FibGVkIHNpbXBseSBiZWNhdXNl
IG5vdCBhIHNpbmdsZSBwYWdlDQphbnltb3JlIGNhbiBiZSBhbGxvY2F0ZWQgZnJvbSBFUEMgc2lu
Y2Ugd2UgYXJlIGdldHRpbmcgLUVOT01FTSBvbiBFUEMNCnBhZ2UgYWxsb2NhdGlvbi4gQWxzbywg
bm90ZSB0aGF0IGFueSBhcHByb2FjaCB3ZSBjaG9zZSBzaG91bGQgYmUgc3ltbWV0cmljYWwNCnRv
IFNHWCB2aXJ0dWFsaXphdGlvbiBzaWRlIGFsc28sIHdoaWNoIGRvZXNu4oCZdCB1c2UgaW9jdGxz
IGF0IGFsbC4gU2ltcGx5IHJldHVybmluZw0KLUVOT01FTSBmb3IgcGFnZSBhbGxvY2F0aW9uIGlu
IEVQQyBzZWVtcyBsaWtlIGEgY29ycmVjdCBzeW1tZXRyaWNhbCBzb2x1dGlvbg0KdGhhdCB3b3Vs
ZCB3b3JrIGZvciBib3RoIG5hdGl2ZWwgZW5jbGF2ZXMgYW5kIEVQQyBwYWdlcyBhbGxvY2F0ZWQg
Zm9yIFZNcy4NCkFuZCBub3RoaW5nIHdvdWxkICBiZSBhYmxlIHRvIHByb2NlZWQgY3JlYXRpbmcv
bWFuYWdpbmcgZW5jbGF2ZXMgYXQgdGhpcyBwb2ludC4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5h
Lg0KDQo=
