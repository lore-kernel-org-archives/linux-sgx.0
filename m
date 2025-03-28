Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F152F30;
	Fri, 28 Mar 2025 08:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743150481; cv=fail; b=BFUm1rqIEL/Zw9pdun72Cqli5+tk91eDRLDhDJVuZUo89raQ+oi0zj6eSQlCRZzH6u2S9+3DmZ0KXTicRwBHZNDcgjPdMICsBXWd/GAGOuBm7xOQeeJ9LoNcSYBXAFAuu4zWNnVMhDF7cuE7ewqmybMJvC/8vizr0zPP6U/jO00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743150481; c=relaxed/simple;
	bh=MOIm/zJjbVhYBJqpBpemNqAMwu+D4rfe0KOWvi5ad9U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EPQn7oMvx/Ti7aZ3sSlfpEu8goTQZFt7n1mjf5DR0vBJ8QzFQXZPCf6G4NwoKeI+taidCbDnIm4SnJp2/tDPeE45NdfEzk10MtZrM3SWnYzAkEY3C3SXhZcKRFuQPbVqjSbAHmczMr4OdUdJOzp/fBUfmToRpW8bAZcZL4CMAwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j6gG0PZq; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j6gG0PZq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743150480; x=1774686480;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MOIm/zJjbVhYBJqpBpemNqAMwu+D4rfe0KOWvi5ad9U=;
  b=j6gG0PZqzjqapEKlu+IczDrUKiOXtCriIJaFhXfOb6u1/4po3/O1NTdS
   WW5IPXKkotV1wN0CnS2Ux8/03id2diiT1nEqAXPKDsgc54I1amCYVF0SU
   qYG2rAmsR/4FD7xwgIDiyoQca6nV2Om+LDKg+tX6e74iYkUA5UP0PZbF9
   ifbpKhW49b5TvIl5I0xZExC87kkFsBV7GOdqxluem7Y2V7OeuuJoeMaUX
   md8tDzEGuef4yVoDZuHqg1Eawr2WW14p9hqrqmYD2PgSh+9e66E7S6ZwF
   FitWmi+yulHdoJG9D3TManDVQV7iaB8z9dv5m/+gqdkiPsWr39MdVdqjS
   Q==;
X-CSE-ConnectionGUID: PWgZCtxdQaeWGOQZK67WvA==
X-CSE-MsgGUID: VOH0LCsASEeGQHfHmSsjJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="32108282"
X-IronPort-AV: E=Sophos;i="6.14,282,1736841600"; 
   d="scan'208";a="32108282"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 01:27:55 -0700
X-CSE-ConnectionGUID: SNaKg/fgS/GkipaHGjTRFg==
X-CSE-MsgGUID: E8ItdUFWTnmqZ4nZUbILyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,282,1736841600"; 
   d="scan'208";a="130443469"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 01:27:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 28 Mar 2025 01:27:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Mar 2025 01:27:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Mar 2025 01:27:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KyHogzrGPhoGpoQsCKmmECY7GbuCXceRyXAZr8F19LwRpAGP0/j3dfT3dYQpIupJYhWgZbimBC5CLL7CVuIqewqz8TdDM/m2DTNB5lf9b+3ypxAkiKgsaFbV1mhPCF6f207JPBUFFGApwKFIB5KxW8PRkDRpztgo2cPH7fbief5fPHDWAx4cFx5RYzkVm15C9ddZ3Hz7I3pXiCY9Bi4RoyzO3wBYFT3rhY2breryyT+uZ+6U7DAIZhjPehQKQ+6pbMZemKKVmqlHbZ9shh873hhAL/xn9BlWfCMPHQm2HCdB3q3Aop8NHkdiacr8YMU5QdAEoMAiia1Ii8co1Pgk9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOIm/zJjbVhYBJqpBpemNqAMwu+D4rfe0KOWvi5ad9U=;
 b=Lag7lxilQMLZvyH+qIc864QMxyG5ziwuPcxqfZ5jVqGra3UM4Be4ZyTgCIYua4RH50BYF02bdIs80i1ppZy9j5RomHkmzqCCP/fhn1LTZQFXdHEikSmxkg6EYMxI9Tg7Fc86eXUDG6p2przj6mhuFw38hsgrFtflJ+sLgzNqltMKAbAuUlr6CMHne7kGfEeEwtZtz3IBioifDUD4eHFMNU90pPkxLFI+Koj/ej8bWj3lUZoauQti2MreFvXm3s+dueNmqtoqj63TJiTmSuSojV8wUy+JSU9TPHFm1qO8I+ZRhFI6p2Fpn1SNm70irBIRasWrajAP1cdK5Y03fSzgYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 BY1PR11MB8056.namprd11.prod.outlook.com (2603:10b6:a03:533::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Fri, 28 Mar 2025 08:27:51 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.040; Fri, 28 Mar 2025
 08:27:51 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>, "Zhang,
 Cathy" <cathy.zhang@intel.com>
Subject: RE: [PATCH 4/4] x86/sgx: Implement ENCLS[EUPDATESVN] and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH 4/4] x86/sgx: Implement ENCLS[EUPDATESVN] and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbml5zm6Mg6JqIu0KJnS8UZti+urN/vCmAgAJ9k8CAA6gNAIABRhDAgABfMQCAALbdUA==
Date: Fri, 28 Mar 2025 08:27:51 +0000
Message-ID: <DM8PR11MB57501BCC966906CB02946986E7A02@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-5-elena.reshetova@intel.com>
 <Z983ZaTaWNqFUpYS@kernel.org>
 <DM8PR11MB575000AEB9CC3A318651AAABE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RfcpSBAybk-KjG@kernel.org>
 <DM8PR11MB5750FE25D4C8EC2297952845E7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-XA0oy_r9VBJPHI@kernel.org>
In-Reply-To: <Z-XA0oy_r9VBJPHI@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|BY1PR11MB8056:EE_
x-ms-office365-filtering-correlation-id: c57b45b8-c3c5-42b0-5bc8-08dd6dd26e18
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZXRiQUVRcTgxemYyQjZqRE5ET3Fwdm1hSUVPK21DSitYZkNlSEFxSE1KQjh1?=
 =?utf-8?B?aHJwRExnTG9ONW9MZUR4ckVEVlZwb1NrbUFtQ214T1I5WDJVbXFaQVIyUFNJ?=
 =?utf-8?B?MGlqa2s4ZWNTOG5xdloxOUIrVkFhWXN6V1VMeFpDcHVucGtKVHd6TVM3cnQ5?=
 =?utf-8?B?d3RES3MrZDhWTzJjNk9CTmRxR1VJT2VNTnY3bTV4Q2J5RTVHdStXK2lGTVkw?=
 =?utf-8?B?ZnJXd0VlOUE5YzJBWklVaU5tUUZuYVZ3WlBKZFRoQTNoZFJKRmdCM2Jpb0tI?=
 =?utf-8?B?cHBwYjhFU0Z6eVgxMHphQnExWnpsVWJmYmVuWjZoTGJNUG9CRFd1MXRtd095?=
 =?utf-8?B?RFZOR1paWUZ2cElzWDJTM08wVWFPNFI1ZVFRbW80WVNDenNPYm5GS1JFL21y?=
 =?utf-8?B?N04xcGV1Y3lwRktFZWM0dk8vVDkzT0JqM2hobjlTN0FSd2UySktRRDVYQUNU?=
 =?utf-8?B?UnBwL0lVQjZRTW1EelRZd3RSS2J2cXlsMUtIVDEvUTJUZ3cxdnNZWm10RnN6?=
 =?utf-8?B?bktGREVRQW1JMkZSN1R1Ynd4aGVIK2FIcGovZG5WakFmYVByQkhmelNZUWc0?=
 =?utf-8?B?NitJb3JCcjlRUWdhd2lTbEJWVUE4bDhGN2M2QStZcmpESlV2QVJ3UDNodzRq?=
 =?utf-8?B?NkVxSnNKMEhXSkd2RkxNYWNjb2hnVjdWcWNFUGN4ZzlicExRNTl4bFBPTCtD?=
 =?utf-8?B?b05ZcDNJWjZLY1QyV1lYMnFyZ1puWG51RVFMd2FhQS90bkhTSmVKeVQxSG9i?=
 =?utf-8?B?YmVoMFkzZHp6dDV2NENIZ2dWWGQ2bFVlTXhIZEhCeGFYbCthbjZXWlpVN29Y?=
 =?utf-8?B?QkZOZDZ0dnpnKzdvdjVoTWlNUU01YWowaSs4M0RoNkVZd0dpNVhXZ0tmZXJl?=
 =?utf-8?B?Q0hvZ0hQdVRYbkFCVVZWWHRHTWE3bzE3eFVsY01uSnNiL01DSWpCMmNnUEdR?=
 =?utf-8?B?cGVUYk9VYlFJdVpBV2NZZmNjenkvTjhOR0E2OC9DMnl1Mk5sRjZvdDEwRVFS?=
 =?utf-8?B?MkpScXM4eG92ZEcrRHNYMGpDb015TkM3WkxPalZSWGtFczNOZ1doeWMxNlQ2?=
 =?utf-8?B?Q1hMME02NityUTN0cExFcXM2L1Z6aktVb2hZQUdGTWlMek9lOWloMEx1dmo4?=
 =?utf-8?B?VTBWbHhiNkQ5MWhBSU9sQ2hNS3lnbkxwRy9QeVZXSXVQM0dTL3VhS1NsYkxz?=
 =?utf-8?B?S1FxT2s1b2M1UENhcXBOdERLNzVoYjhHQ3AvSnNxcWQ5aUJobE1haG43b0NJ?=
 =?utf-8?B?ZWQxbGMyOG80d21hd3pieU50S3N4SSs3ZlNZeDc5SjhEQjd1bkV3eWpOdm9Q?=
 =?utf-8?B?em9heFd5enJlWGZya1k5bVVsTTROUytGNmlaVk9nQk5DYUpKZmJTMjVhekh3?=
 =?utf-8?B?Vi9GOVpCeXBRdVV2bDdURUF2TlFJVE5acTRpOURGdjBWNUsycWJmTFZWemNR?=
 =?utf-8?B?dWZLRjhmc2ZNeks5OERCSnFEVExCUDF3dU9xS3hOOC94eTFTa0puWmZNR3dF?=
 =?utf-8?B?QVBJUkV6MFYwZnlqdjJLVVcrd1R4SFI0V091NVRiaWxBSmNqRllFVmpXMVNy?=
 =?utf-8?B?Smw2eWR6Q3BZWkpLSWJabGxSMVNZTkNZQ2gyRHNQcS9uNUdzcWt6YkZraFJt?=
 =?utf-8?B?YjB6Sk0yV0paUUFmdnZXRHpVQjVIR0lwSEVadlcxN3EwV2pGMFdUbVRxd0o1?=
 =?utf-8?B?Uk96TUVlWG9WYjZSRi9sdGJoWUV5OHNHbTVFOHFMdW00UEgzOFYzVDlSamFB?=
 =?utf-8?B?V3ZWbEFBTGtKWGRlUUxYN29qTGxXTXFLQ1Q5dzlGakhoUTUzM3BicXRRcVJt?=
 =?utf-8?B?a1ltNEYvcFo3aTFmdXZ3YUpUYU9LMEUxVWMxSDBMc3hNTkJpdlNHM3ZtY01K?=
 =?utf-8?B?a21HMmxOSDZxcXA2RnpBaVBFT09ZbWoxZE40VjYxQStkMEp0UnJOMG1LWEpY?=
 =?utf-8?Q?V0vnzMn2KY8nwtGcEhV5XHATh9yvENVW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkduT204NnZPaStGa0lKSjJ0eUNmUjVkd2J6T1A3WVNOVGFjcFozVzNYUW4z?=
 =?utf-8?B?czFmVnArakVxcEdyMlVFUVpmeTh0dHUrLzlZUlpDTi9uS1pEL21pWEFWS0JE?=
 =?utf-8?B?a1IzWTNvdG9oZXp0MVJKdEgvN0pNUWpwRlZPdXZjZDdFVFRoSWNxZ2gvcDBQ?=
 =?utf-8?B?L0Z1MVZBWmFadll1bWQ4NjBGWTNYZjQ4OCtxeUJXdkdvMDBXcEgwNmRjM2l4?=
 =?utf-8?B?WTIxazVBL3hiRE5hTUdTTlhXWHJMSWlpN0tvRHpkbFR6RGlqUlJWcWdTeVV0?=
 =?utf-8?B?NmNHb2M0aFBmSnpGVHNZcVpIQUdMU0xmQXE4Q21aei9IYW9lTyt3Sit1NlYx?=
 =?utf-8?B?VWtNYzRCWkgvcEMxSXhSUDNYeTk4UGhmQlJjckM0bTUvNVUwZHZ5UWJGMmVU?=
 =?utf-8?B?c09kYmxZenp1S1oyRTFEUXY3SkJZSkxiTUVnblpaYzBVU004ay9oZGFnb0do?=
 =?utf-8?B?U1Q1clFJVVRWaUdyaEY2RHJiTWtrQWJodjBpU1RSTFhqVVQveHU4RGgvako3?=
 =?utf-8?B?bk1uUi93SlVmTEdSb1dZZXRvZnZzcXJHbWpldkczWVVQK283bHUzMUJ3RHMx?=
 =?utf-8?B?SWlMWkE5OG5DcHVYelBWSkdiNyswOGVzNmVyQ0NLVytId3d2TEduTGpIWk5w?=
 =?utf-8?B?NCtTQUVTd1pweHkyNnhOd3J0UFpoV1pRSEYxWUhXU3NWMlBNK3c2bHQwZngr?=
 =?utf-8?B?OHE0bjFrTm9YemJlWW5rcno3bVpjbVFFQlF5bUNycmFTY29OMXNBTllhT05l?=
 =?utf-8?B?NHE1eWxmYXZyZkd6ZGk5aEc3eGFod1poclM3c3ZVTTlYNEMwNUVOUVVoK1Ar?=
 =?utf-8?B?SmRkZXgrWnZWSG8xOWo0Y3lub2hqRDhSNUc2WHZmM3A2dXZpcUd6RXhES1c5?=
 =?utf-8?B?TUkrVDR6ZDRUVXRkVkpqVVNhSEFieXFJa20zLzQ2ekZ3bnYrOVpuYSt6OFhE?=
 =?utf-8?B?SjlRT2JLYnAxUldIR09XeWd4Q2VOQkxmNEZhRUJPdkNCWUxvS2FkS3A5RSt2?=
 =?utf-8?B?SkFGbVFjT0ZWb2FLbHNud0xVVGxnWlppK1dlSkFiVnBGZVBkcE9NUkZUNnYy?=
 =?utf-8?B?K2FTa2Y1VE0xOTY5RHkxaFpsWjFBMW1NcU81cEJDQUVIYUVMalpFeFMvc080?=
 =?utf-8?B?OG5SUEpwdEdISGFaK0s2RnFnM1RteHU1dnVnMGc2RGpVSG8yZUtEb3VjNkJz?=
 =?utf-8?B?RjBqMFBISjB0Y21aKzRrTjZQektVKzZ6cU5IZDU1L1NWQWZ5cXVnTHlZWXdV?=
 =?utf-8?B?UW5NS3NIQ0EyUUJsSDZLYlVhSVhmUktqNGdETEp1UnNDbmxWRGV0NUFwR2RJ?=
 =?utf-8?B?U1M5OXpXV1hIZVNybWJndWlsYUw3S2p1RkpMK0liR0dRZ1NBNTRIb1NNdnh5?=
 =?utf-8?B?L0pwZ3dvSzdjUitxcXA2NDBFT0FpbDhOVlJJSWF4V0F1SUVZT0JTODFxSDln?=
 =?utf-8?B?WC9YdnNodWFUUDd3WHc2M0YvNHdCbENVOWFwSzc5WnIxOE5sSzNzTDl6aTV6?=
 =?utf-8?B?bzZ3cTdlb0pWSk9yeGpveldON3FnTExhWVhmTnNRVUpNUFJqWkVLQ0Z0clNR?=
 =?utf-8?B?ZUZUbDZhazF1Umc2bDVXaDBoenNuZU16UDVOMnVwM3NwYUU3MXNKeGF6bzVO?=
 =?utf-8?B?ZEV1cEc5ZlhYZm1YKzlQZHRRSzJzck5Fei96d01WMXdheUFKUis0ZHczdHZs?=
 =?utf-8?B?V292YkJEVEY0MlJqbjIzbHlxOUZIK1M1N3gwWnZoNDhVYXhwL1pSZSsxVzBh?=
 =?utf-8?B?YUJVNlRrVk90eTFRRFRZRnZoK0N6WUpkWFlYQ3g1OGhTUGlGOGNzeDFyRVM1?=
 =?utf-8?B?RHljMTNjdnNFRzYxZFQwSkJvS0NQV29LcXJVaUdCRVFtdS9Ta1Y1Z01ZR2VS?=
 =?utf-8?B?YjNrU2hmR3VMb2ZsQUVFYTZxcHBYb1VYVVNYYlMyTHp1ZE83RHhoeFRDdHFG?=
 =?utf-8?B?YThMcEZsSERPeXM5bTZLYWN2NFdkUzY5dUJyVEVWWUtnNnZKdW0zMUpLYjNZ?=
 =?utf-8?B?K2o2OU5sQWZ1a1pIaDlXR3hOSXNYSmRveFd6UU0vOUtlTTJpVHNZMU0vTnlO?=
 =?utf-8?B?eTJoU1BNNEg1em5CWHNRaFNjNDlwSHl5emJNTW8rRHVBV1FmYUc2dGdNOHVW?=
 =?utf-8?Q?9/zM8DU+H5VvZcGoBJ8P+V2Ni?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c57b45b8-c3c5-42b0-5bc8-08dd6dd26e18
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2025 08:27:51.3745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LbCmKe0u+lio5ZPd0FxvR16rGi3cFnWhi2kUYqaN+ytg2ivRBhGQ/G8klmomY3Vtg/wROoHfEC5uyYRPycpZwIijxlI6X4cfj5apQM/tH10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8056
X-OriginatorOrg: intel.com

DQo+IE9uIFRodSwgTWFyIDI3LCAyMDI1IGF0IDAzOjQyOjMwUE0gKzAwMDAsIFJlc2hldG92YSwg
RWxlbmEgd3JvdGU6DQo+ID4gPiA+ID4gPiArCWNhc2UgU0dYX05PX1VQREFURToNCj4gPiA+ID4g
PiA+ICsJCXByX2RlYnVnKCJFVVBEQVRFU1ZOIHdhcyBzdWNjZXNzZnVsLCBidXQgQ1BVU1ZODQo+
IHdhcyBub3QNCj4gPiA+ID4gPiB1cGRhdGVkLCAiDQo+ID4gPiA+ID4gPiArCQkJImJlY2F1c2Ug
Y3VycmVudCBTVk4gd2FzIG5vdCBuZXdlciB0aGFuDQo+ID4gPiA+ID4gQ1BVU1ZOLlxuIik7DQo+
ID4gPiA+ID4gPiArCQlicmVhazsNCj4gPiA+ID4gPiA+ICsJY2FzZSBTR1hfRVBDX05PVF9SRUFE
WToNCj4gPiA+ID4gPiA+ICsJCXByX2RlYnVnKCJFUEMgaXMgbm90IHJlYWR5IGZvciBTVk4gdXBk
YXRlLiIpOw0KPiA+ID4gPiA+ID4gKwkJYnJlYWs7DQo+ID4gPiA+ID4gPiArCWNhc2UgU0dYX0lO
U1VGRklDSUVOVF9FTlRST1BZOg0KPiA+ID4gPiA+ID4gKwkJcHJfZGVidWcoIkNQVVNWTiB1cGRh
dGUgaXMgZmFpbGVkIGR1ZSB0byBJbnN1ZmZpY2llbnQNCj4gPiA+ID4gPiBlbnRyb3B5IGluIFJO
RywgIg0KPiA+ID4gPiA+ID4gKwkJCSJwbGVhc2UgdHJ5IGl0IGxhdGVyLlxuIik7DQo+ID4gPiA+
ID4gPiArCQlicmVhazsNCj4gPiA+ID4gPiA+ICsJY2FzZSBTR1hfRVBDX1BBR0VfQ09ORkxJQ1Q6
DQo+ID4gPiA+ID4gPiArCQlwcl9kZWJ1ZygiQ1BVU1ZOIHVwZGF0ZSBpcyBmYWlsZWQgZHVlIHRv
DQo+IGNvbmN1cnJlbmN5DQo+ID4gPiA+ID4gdmlvbGF0aW9uLCBwbGVhc2UgIg0KPiA+ID4gPiA+
ID4gKwkJCSJzdG9wIHJ1bm5pbmcgYW55IG90aGVyIEVOQ0xTIGxlYWYgYW5kIHRyeSBpdA0KPiA+
ID4gPiA+IGxhdGVyLlxuIik7DQo+ID4gPiA+ID4gPiArCQlicmVhazsNCj4gPiA+ID4gPiA+ICsJ
ZGVmYXVsdDoNCj4gPiA+ID4gPiA+ICsJCWJyZWFrOw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gUmVt
b3ZlIHByX2RlYnVnKCkgc3RhdGVtZW50cy4NCj4gPiA+ID4NCj4gPiA+ID4gVGhpcyBJIGFtIG5v
dCBzdXJlIGl0IGlzIGdvb2QgaWRlYS4gSSB0aGluayBpdCB3b3VsZCBiZSB1c2VmdWwgZm9yIHN5
c3RlbQ0KPiA+ID4gPiBhZG1pbnMgdG8gaGF2ZSBhIHdheSB0byBzZWUgdGhhdCB1cGRhdGUgZWl0
aGVyIGhhcHBlbmVkIG9yIG5vdC4NCj4gPiA+ID4gSXQgaXMgdHJ1ZSB0aGF0IHlvdSBjYW4gZmlu
ZCB0aGlzIG91dCBieSByZXF1ZXN0aW5nIGEgbmV3IFNHWCBhdHRlc3RhdGlvbg0KPiA+ID4gPiBx
dW90ZSAoYW5kIHNlZSBpZiBuZXdlciBTVk4gaXMgdXNlZCksIGJ1dCBpdCBpcyBub3QgdGhlIGZh
c3RlciB3YXkuDQo+ID4gPg0KPiA+ID4gTWF5YmUgcHJfZGVidWcoKSBpcyB0aGVtIHdyb25nIGxl
dmVsIGlmIHRoZXkgYXJlIG1lYW50IGZvciBzeXNhZG1pbnM/DQo+ID4gPg0KPiA+ID4gSSBtZWFu
IHRoZXNlIHNob3VsZCBub3QgaGFwcGVuIGluIG5vcm1hbCBiZWhhdmlvciBsaWtlIGV2ZXI/IEFz
DQo+ID4gPiBwcl9kZWJ1ZygpIEkgZG9uJ3QgcmVhbGx5IGdyYWIgdGhpcy4NCj4gPg0KPiA+IFNH
WF9OT19VUERBVEUgd2lsbCBhYnNvbHV0ZWx5IGhhcHBlbiBub3JtYWxseSBhbGwgdGhlIHRpbWUu
DQo+ID4gU2luY2UgRVVQREFURVNWTiBpcyBleGVjdXRlZCBldmVyeSB0aW1lIEVQQyBpcyBlbXB0
eSwgdGhpcyBpcyB0aGUNCj4gPiBtb3N0IGNvbW1vbiBjb2RlIHlvdSB3aWxsIGdldCBiYWNrIChi
ZWNhdXNlIG1pY3JvY29kZSB1cGRhdGVzIGFyZSByYXJlKS4NCj4gPiBPdGhlcnMgeWVzLCB0aGF0
IHdvdWxkIGluZGljYXRlIHNvbWUgZXJyb3IgY29uZGl0aW9uLg0KPiA+IFNvLCB3aGF0IGlzIHRo
ZSBwcl9sZXZlbCB0aGF0IHlvdSB3b3VsZCBzdWdnZXN0Pw0KPiANCj4gUmlnaHQsIGdvdCBpdC4g
VGhhdCBjaGFuZ2VzIG15IGNvbmNsdXNpb25zOg0KPiANCj4gU28gSSdkIHJlZm9ybXVsYXRlIGl0
IGxpa2U6DQo+IA0KPiAJc3dpdGNoIChyZXQpIHsNCj4gCWNhc2UgMDoNCj4gCQlwcl9pbmZvKCJF
VVBEQVRFU1ZOOiBzdWNjZXNzXG4pOw0KPiAJCWJyZWFrOw0KPiAJY2FzZSBTR1hfRVBDX05PVF9S
RUFEWToNCj4gCWNhc2UgU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZOg0KPiAJY2FzZSBTR1hfRVBD
X1BBR0VfQ09ORkxJQ1Q6DQo+IAkJcHJfZXJyKCJFVVBEQVRFU1ZOOiBlcnJvciAlZFxuIiwgcmV0
KTsNCj4gCQkvKiBUT0RPOiBibG9jay90ZWFyZG93biBkcml2ZXI/ICovDQo+IAkJYnJlYWs7DQo+
IAljYXNlIFNHWF9OT19VUERBVEU6DQo+IAkJYnJlYWs7DQo+IAlkZWZhdWx0Og0KPiAJCXByX2Vy
cigiRVVQREFURVNWTjogdW5rbm93biBlcnJvciAlZFxuIiwgcmV0KTsNCj4gCQkvKiBUT0RPOiBi
bG9jay90ZWFyZG93biBkcml2ZXI/ICovDQo+IAkJYnJlYWs7DQo+IAl9DQo+IA0KPiBTaW5jZSB3
aGVuIHRoaXMgaXMgZXhlY3V0ZWQgRVBDIHVzYWdlIGlzIHplcm8gZXJyb3IgY2FzZXMgc2hvdWxk
IGJsb2NrDQo+IG9yIHRlYXJkb3duIFNHWCBkcml2ZXIsIHByZXN1bWluZyB0aGF0IHRoZXkgYXJl
IGJlY2F1c2Ugb2YgZWl0aGVyDQo+IGluY29ycmVjdCBkcml2ZXIgc3RhdGUgb3Igc3B1cmlvdXMg
ZXJyb3IgY29kZS4NCg0KSSBhZ3JlZSB3aXRoIHRoZSBhYm92ZSwgYnV0IG5vdCBzdXJlIGF0IGFs
bCBhYm91dCB0aGUgYmxvY2tpbmcvdGVhcmRvd24gdGhlDQpkcml2ZXIuIFRoZXkgYXJlIGFsbCBw
b3RlbnRpYWxseSB0ZW1wb3JhbCB0aGluZ3MgYW5kICBTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkN
CmlzIGV2ZW4gb3V0c2lkZSBvZiBTR1ggZHJpdmVyIGNvbnRyb2wgYW5kICpkb2VzIG5vdCogaW5k
aWNhdGUgYW55IGVycm9yDQpjb25kaXRpb24gb24gdGhlIGRyaXZlciBzaWRlIGl0c2VsZi4gU0dY
X0VQQ19OT1RfUkVBRFkgYW5kIFNHWF9FUENfUEFHRV9DT05GTElDVA0Kd291bGQgbWVhbiB3ZSBo
YXZlIGEgYnVnIHNvbWV3aGVyZSBiZWNhdXNlIHdlIHRob3VnaHQgd2UgY291bGQgZ28NCmRvIEVV
RFBBVEVTVk4gb24gZW1wdHkgRVBDIGFuZCBwcmV2ZW50ZWQgYW55b25lIGZyb20gY3JlYXRpbmcN
CnBhZ2VzIGluIG1lYW53aGlsZSBidXQgbG9va3MgbGlrZSB3ZSBtaXNzZWQgc210aC4gVGhhdCBz
YWlkLCBJIGRvbnQga25vdyBpZiB3ZQ0Kd2FudCB0byBmYWlsIHRoZSB3aG9sZSBzeXN0ZW0gaW4g
Y2FzZSB3ZSBoYXZlIHN1Y2ggYSBjb2RlIGJ1ZywgdGhpcyBpcyB2ZXJ5IA0KYWdncmVzc2l2ZSAo
aW4gY2FzZSBpdCBpcyBzb21lIHJhcmUgZWRnZSBjb25kaXRpb24gdGhhdCBubyBvbmUga25ldyBh
Ym91dCBvcg0KZ3Vlc3NlZCkuIFNvLCBJIHdvdWxkIHByb3Bvc2UgdG8gcHJpbnQgdGhlIHByX2Vy
cigpIGFzIHlvdSBoYXZlIGFib3ZlIGJ1dA0KYXZvaWQgZGVzdHJveWluZyB0aGUgZHJpdmVyLiAN
CldvdWxkIHRoaXMgd29yaz8gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0KDQoNCj4gDQo+IElm
IHRoaXMgaGFwcGVucywgd2UgZGVmaW5pdGVseSBkbyBub3Qgd2FudCBzZXJ2aWNlLCByaWdodD8N
Cj4gDQo+IEknbSBub3Qgc3VyZSBvZiBhbGwgZXJyb3IgY29kZXMgaG93IHNlcmlvdXMgdGhleSBh
cmUsIG9yIGFyZSBhbGwgb2YgdGhlbQ0KPiBjb25zZXF1ZW5jZSBvZiBpbmNvcnJlY3RseSB3b3Jr
aW5nIGRyaXZlci4NCj4gDQo+IEJSLCBKYXJra28NCg==
