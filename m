Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9B51CBE85;
	Wed, 21 Aug 2024 11:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724238719; cv=fail; b=OCdSexmqC9A84t5geDHSBA4/mbx/xrkMjT0leVXnmeQWYH38CahFlRd/D6j+2P5ZlC6FQwcnKQF0Bsu4kE81YIC47h42+13vDl0wMSb18DSF0tk7uqMVgOCTJTpA1Rbr269F0gqcqXRT6XCQA6oSJWPjJBbB72Z8D7zUgncRYjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724238719; c=relaxed/simple;
	bh=6tw60sAkTR2uNAuz8MRg3/KemzCNgj/38TxZLDAEhTY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PpcruYsYMWl41D+LdRLSHTGBe6SKoYGgHNFcFPduVIVOBvJX7I2xROvgVG8WIO0/fnzUSaD6TFmhjwHQ89LCUFifYNbquYizczstugSQ6LzhcK+63+poobtSk3CfMHRsZWmJY+2eJJIxnPmVqtwGX0oMNgV0vL40Ys9dV6m+HqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iw4SwAJr; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iw4SwAJr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724238718; x=1755774718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6tw60sAkTR2uNAuz8MRg3/KemzCNgj/38TxZLDAEhTY=;
  b=iw4SwAJrjG4lvSWW1cXmgcZEMSxVcwfg3jMLA2UWSgnThi4pTIZ8/oID
   a0nEbbbgLqu/kPHeuyAHqPRxBaKAFOh5keHqWyquNMyQnT2wp09t/FEil
   GjFcxa1o9vjnGTPHjVBI1AV0pfISLfkyfg6L+cJv0GshUwp/pavnhpuxx
   7k/fVbAQxgjHCJOU0PXjKYyg/HjClFGmmuDn3oQ9+N0dRh0gZVWKM9xno
   LCchXFBzwVnm5ZNAn6K+O/6tXPUGg9WZCqgD3uzwJw12qCE86Rr5kGFIa
   Qpr1vt9ppyDYV0WZYdKAzNVQpocheBQbcafID2Emj+q0ZMwOd3RgfK6ea
   Q==;
X-CSE-ConnectionGUID: mQEIaC8YSKS6GJlDhxcU9g==
X-CSE-MsgGUID: 8FiI/R/dThGKt1BxQ5em6Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="22562329"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="22562329"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 04:11:57 -0700
X-CSE-ConnectionGUID: GTipvFZ2SaC64UVThGwB5Q==
X-CSE-MsgGUID: 9cvn58ruSPqT/PstNzb9dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="98529164"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Aug 2024 04:11:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 04:11:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 04:11:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 04:11:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 04:11:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oYqj0NCXJDRFGZJDIsMqwOZj7/j6k6FIMWDTSDCcySD2xYLSQ0bFq0YK66M1/Jbgzfhr7GZF39IH2+66NROUm92jtnfgybj3jbAdJKZ9NAONoK9VCfk3ppaXw/PmUtyvyFhML3AwiCJOOMh1aJalrDWUHlcVpzvw12v5eA8ARcnzLJ3WVKt0rF1IdURYd+xkk1BLp+a+ydgW1HqScP8xbZDT0goCGm6KadXNcUIFlVseNUcBxAQPKnKPUEg1VhaAxtQlolMh21J2OwA5czV/JvF559FsghWMjJLvBGb1g0VV7hqdavlGBhwp12V17wXAEj6VhT4ba+fxgK77S/dZ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tw60sAkTR2uNAuz8MRg3/KemzCNgj/38TxZLDAEhTY=;
 b=B5Z9NNk7UZ5Ga1Kpmvs6So+QxZlQ1/wrc7vV6LRkN35PYu7OPt9FRCs2Bxk7cicbrfz/d1ZT5crBOSQm3H+K3sgHR/7ox3qP1poaZ1Tli07+UUeeb+sHvNiM9xiZAXy0+xl+p90Gfdc+eqcheJ96VDjpI2dDBpZOTcaNZg7zS9oeJN8Qhg6PbQaRFGUgWHefwCiqT/bP+NqKgay5/Fq5aiD7CV4rvQZAtMCrvxvLsV3ZrYvniZldnukj2F9Die+uWYfniZa7+HuN8xqUc8drr/Mn1MR2pEvR5pFHp857s0HlIiVsmdizRanGWOCCHXqSlHT932UlNA2tiJFeb1qZZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Wed, 21 Aug
 2024 11:11:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 11:11:51 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Kuvaiskii, Dmitrii" <dmitrii.kuvaiskii@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>, "Vij, Mona"
	<mona.vij@intel.com>, "Qin, Kailun" <kailun.qin@intel.com>
Subject: Re: [PATCH v5 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
Thread-Topic: [PATCH v5 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
Thread-Index: AQHa87Ji3mMSBxK/C0yTLrO8rnHNGrIxjm6A
Date: Wed, 21 Aug 2024 11:11:51 +0000
Message-ID: <c9ae406e8751b2969322be83ea5afba08e0d6e13.camel@intel.com>
References: <20240821100215.4119457-1-dmitrii.kuvaiskii@intel.com>
	 <20240821100215.4119457-4-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240821100215.4119457-4-dmitrii.kuvaiskii@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB7097:EE_
x-ms-office365-filtering-correlation-id: 5d470cf7-4976-4bda-f181-08dcc1d20e9b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WkJRaE1zSGV0VUhpQjBIRXFTS1lMV0JMbE9GcDArNGV3ZC9hQkZxZFN2N1hX?=
 =?utf-8?B?MjUrUFU5MlBZZU1LbXFIQW41UitLaGFUVWRDc1drYjhVcTV1QkhXcmRlN0FI?=
 =?utf-8?B?YXp1WXlXUUIrelQza0thYTJxMDd0cUZZSTBUNWtlSVhIZE5heWtYSHltbTBR?=
 =?utf-8?B?WDdEdFpPTWNjQVluSXc1bnJzUEM5UnJuVjV4SEZJUkRPeFh0b2JBRUpoS25L?=
 =?utf-8?B?M0xEWGdEZGV0L29mV0U0U3gvY1pZVTE2dUx2QzFzYkdYdHRQTmo4TjcyRlhN?=
 =?utf-8?B?bERDbjBrbU1qa1NGR1o1MnJYNlEzczhmMVhXdUhaTE52SSt4MmVtM2x0S21D?=
 =?utf-8?B?VGczeksxYkhpQW8zcFVRK2Z1Tyt0SnpRRktDMTkzTWVZVTZTT2IyVDRUYm1n?=
 =?utf-8?B?b3NXVExnaHFBLzRoenArZjFxQ0RhNjRsNTgrZG04ZlRJUWtVSE9nVnFDY0w2?=
 =?utf-8?B?QnFiUU1qeU4ydUN5c21nT09rdVoyWTQ3Nm9OeXBhNXFMdXQ2SHd5RU5EbDM0?=
 =?utf-8?B?TjNhV1dKbEY1OVV3QU4rZTc5LzVQTHN0RURwWUptcHFGK0dBbjVIay9iNDRQ?=
 =?utf-8?B?ZjV0ZVV5RCsyMVhDRy9MSy9qaFpwWFFsemJNd3VNbnVuWHM0NVQ1V0xMNFd0?=
 =?utf-8?B?dnM0N2Y5UkI0bnRES3FvL3BCcjB6T1BFRUV4TmVabzhXR0drVERtTzFqZzZP?=
 =?utf-8?B?ZHVSc1pYci96OWhlOWlkNkg2UkhNZTBwbVB5amFuaUF4dE5mNTVaWVFVUlpo?=
 =?utf-8?B?aEVVYm1ZSzNIQ3d6YWNEM1VJbGRIY2E5YkNUdWtnU0xsUG9hdFZmcTh2T09K?=
 =?utf-8?B?REpMTDdtWlJnRHZiVlF1TDUxb2RDMk13amZDcThJQ01BTkNGWG1BMzZmeVp6?=
 =?utf-8?B?Z291NmFCcFpTSXp2WEExS2psMk4vU2JmdmRpMmk3TWJ1UlZxeWtORVJXMmRV?=
 =?utf-8?B?clJnVFZlcy80dUhvYjdKeU5EM28xdjllZE5RbzkwZE1vcjVHb0JzdGdVc3Rj?=
 =?utf-8?B?aFN5MkxES2J0bnZzTmZEN3BpbTVpODN4dUJtN1pHSkl0c3N6aHZaM1BHSzFv?=
 =?utf-8?B?MUR2QjhFV2JKRnpNMm1mME1XRmducGRldWFHckRodWRFUGRiOThRQXBuQXBl?=
 =?utf-8?B?VnNvNnhHVmVOcjgySmVmU09zWU4xQTFZL2JYZXFybjF3czltZkp0RGpCaWNj?=
 =?utf-8?B?MTVrcU9PRTd1M2Y5aVBaNHlDaWJPd3NEWkE1N0lsVU9ZQStJSktQcXFoYlky?=
 =?utf-8?B?MHpBWHRJNG5tbHFoZXFRN0pEN0xVVkJFcUJQTGFNL2lQaHVQamhab3kvV3Uv?=
 =?utf-8?B?NmVFZGs1WldQenUxMWE2dlFBelRIcXVabmdsVFBZY09xZmNNSlhiOFU4NHZO?=
 =?utf-8?B?K3BnaVVqNVFmYm9qcElTRlR3Y0k5T3RGWDhtb1M2TmhKbm9NMVZ1b293YUIy?=
 =?utf-8?B?ZTdYZTFUY0xIa296QUh4Y0l0VVVVMStPUnpoek5jc25TUWQwQXpabm13WE8v?=
 =?utf-8?B?T2dWRnFBczMrbngzYUdsNGNMK0RTSURzZ3VxdWE2cDgyRkxtRkh1bFJwR0U5?=
 =?utf-8?B?UGdvYTlOVE5vWXNSd0Npc0p6bUsyclhnOTFPQk9GaEM5WXZvTFh2SUZsMFFS?=
 =?utf-8?B?aDFYNUZ1dHF0eVNYTm0wMjBhN0ZDT1JFdm9FVHNFWkE2aUIzTTV4V01NWFZC?=
 =?utf-8?B?NVl4UG4relZCY3l2M0hEelo0MTBra3hnWHRPYVJPSXZuN0YwUzVxQTA4NEJr?=
 =?utf-8?B?L0tHZGQraDQrL3lQbDRVcFo5cmlPSVJnMncrZ0I1SkI3MUhORWtrRkgwYWFS?=
 =?utf-8?B?WVV6Nkh6QVlnWHhmZlNja1Y1Rk9TYjRUYjdKZGxoYmFLcTdhMVNLZ0lPNll5?=
 =?utf-8?B?YkFDcUNPZlBCcVYvKy9QMXh6Ni9vNDRrT1ptdWFiL2xjNXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1k1VXRqUW5MejRqWmdERDFUekJUeEZEb1k3MUQvYmNoZDk0SGlINzBWczFJ?=
 =?utf-8?B?Znl5SXBHYU9hYUJWNmtMMHZNSDYwOEtqem1oT1o3Q2lDYXVIRkE3YkM4dFMv?=
 =?utf-8?B?VUIwenBiejRyQmt0UWt1TkpmdXYwd3pHVWkzOGhrNGlacmx4N2hLUitQdTNj?=
 =?utf-8?B?aEtadUtZSEhHenNNSmlkLzIvcm1jWUgrKzBHUDdHY3o4b2tTSUk2QVVIYnl0?=
 =?utf-8?B?RWwydzFLT3FncUhieDdPQXFWYm92VGhxODk4YnlLSEVzSG12RjVab3BLUHdZ?=
 =?utf-8?B?dTVrZ3prWERYMTMzRHVXOHBPRkd5M3hSWk0vS3UwVHp3ZU0ycjBoS0dGTXRj?=
 =?utf-8?B?SEpCTU9jMVB4UGNQMUlYYmRSdVlaazdaM1d0WUY3V0UvUU5RSS9KaHhhdnly?=
 =?utf-8?B?Vkl5S2svU1ozUGFGY3JiazhpNVRTVk9VL3NBSTJBK25mMU80em5DQk84dmU1?=
 =?utf-8?B?cE1ncHRVcjIyWnphK21BQ1FZN29BNFF1MHdjQlp5Rm1hWWpwNmJNaVNONjVo?=
 =?utf-8?B?enZRZG1JeHRrVTZhUnRlMVdxZjlHOGtEWTlmTW5pUmo2SVBWVHVjV09Vc2pk?=
 =?utf-8?B?Mlg3TTZwTnlLRjVndURWS2xnbllCRnQvRUd0UnRuTEowbVlONC9qenlvWW5C?=
 =?utf-8?B?akRONU5UQksxaTNDNU9rZ0lyYmFscnVvd0FtTHNLY0dCZkEvNUpHSVdtR0lw?=
 =?utf-8?B?WGM5NldzdkY3YzJycG4xb1FxeGRCS1cyMjVWdmlIc2RJYjdheXlvWWN4aFkr?=
 =?utf-8?B?QzM0SVlJMnVxQnJRclBvUW1OVVd4YktMOWNmTUhJd3JlQ1ZBSDkrdEMwbXFD?=
 =?utf-8?B?NjhpNHluY096M3pROEI4TytFTEx6d1djUXN3Q3FvTGJwTktsMTgwWXVpYUs4?=
 =?utf-8?B?MDNyYVZSVVVaUENDYU44NkVlTitEejAxbFhnd2hZanQ1TVhOc05JcWw4NkhL?=
 =?utf-8?B?dlJGNG1mMXZrSlRaYlBKeEVNamg0dEVDU1M0ZG9SWlZXU2l0UEZYUC83UFlB?=
 =?utf-8?B?SWo3RlZtTlZOM1J1Mkp4cGhzLyttMnNrUnI3cURrQk0zR2lpejRTN2R0cTln?=
 =?utf-8?B?eUtGSWVNbEdiYmU2ZTU2VkJqUlpEYUNCSXZTR1RpMVlSN3BVUzJtSTIvbW5k?=
 =?utf-8?B?WTVvM0ZIbkw2cE5wL0MvSFhEMElZenZ1MlJxaG81VzJMZEl6bGtpTWg3aWZy?=
 =?utf-8?B?YlR1Zmk3dE1ScHZPK2o2TjU1MnpUL3dkell6M0YxWjZSWEZEdGRNVVJDOUR1?=
 =?utf-8?B?V1NUZTBBV21FZDh2M1VlK0VrWk5uc2hCY1Z0KytxN3o2SThrZVVTOVE0T01V?=
 =?utf-8?B?MzRuTjZRZ21WOTJEYm5TRlErZnZNcnJ4azlxTHFwRUxNMFRXNlViQmdHVVor?=
 =?utf-8?B?eEo0c25CWWJMUGZJREc3Y0U5UURtakpzcGtTcXA1QzlSa1pTRTgybjY5ZUhS?=
 =?utf-8?B?WjByczFHcVdwMlV4RnhKdksrN2hwUnNrTEhVV1R6TGlOanAwZ0JDTUN4VDBH?=
 =?utf-8?B?dU1qaHBiampvZXF2RURjNVhyWUs0MEswRWZLU1pIVUY5dWNhTmRmZkViZDd2?=
 =?utf-8?B?eE82eFk5TWxQSlFKR1U2V0VzbThUSXBUaXRHaU9lUmZJbFphbElZNFRuQXpB?=
 =?utf-8?B?ZDdKNjAveFhybUtTQjRtVHVsMjRXYnFRWG5POEpxRytnZEtwQk1ZME9GVVZE?=
 =?utf-8?B?elpsODcrRjROM2VGaUpzU0hPa041UVF4YWVKUE4xRkwveXo3WFRiUEpxMHRV?=
 =?utf-8?B?TFZReUpHS2hoY3MwZG9FOVQ3ZERSbThWSEdkMkNiOWlCankyMmZEampQQm5i?=
 =?utf-8?B?enJUMU1HSHR0eWpjTFNoYVV0bkpLR3BVdmJCUkVRUkhUTUZOb2poNkJWMzlV?=
 =?utf-8?B?QUx4dEVGT3RQTUlqY3hEYWxsZFpIbW40anlHZkc0VTVSSTYxWkE3SHBrSkZY?=
 =?utf-8?B?TWp5Yzc5NDhKS3A4OExKLzh3ajhiSGt2eFdwbDZiRjZQZG1FbGRySGt0emx6?=
 =?utf-8?B?NDBjK3JkQXJnVFN2TmljUVQwNmJMbjAwY2ovL1FXUS9HK2FCem1XLy9tM05w?=
 =?utf-8?B?N3J2ZStjVjFINGJFNFY1eE9xM1RacThnRlFZRVZUQlZSVzIxVGJNUmlqR0Z2?=
 =?utf-8?Q?k8D6YQdMvJzR+lzu7TyD2fkq+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03E402CC7FB88E49AA1BE7C77DFCAF94@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d470cf7-4976-4bda-f181-08dcc1d20e9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 11:11:51.1598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fJDwgDUGHmiFaKVkVJwrWKoHkdCP/hd5h90wSVVvAc3oik35i0EGzNJ9qAGxotD9F6flKWaXKB0Aw4GgxtMLfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com

DQpbLi4uXQ0KPiANCj4gQWRkaXRpb25hbGx5IGZpeCBhIHNpbWlsYXIgcmFjZTogdXNlciBzcGFj
ZSBjb252ZXJ0cyBhIG5vcm1hbCBlbmNsYXZlDQo+IHBhZ2UgdG8gYSBUQ1MgcGFnZSAodmlhIFNH
WF9JT0NfRU5DTEFWRV9NT0RJRllfVFlQRVMpIG9uIENQVTEsIGFuZCBhdA0KPiB0aGUgc2FtZSB0
aW1lLCB1c2VyIHNwYWNlIHBlcmZvcm1zIGEgbWVtb3J5IGFjY2VzcyBvbiB0aGUgc2FtZSBwYWdl
IG9uDQo+IENQVTIuIFRoaXMgZml4IGlzIG5vdCBzdHJpY3RseSBuZWNlc3NhcnkgKHRoaXMgcGFy
dGljdWxhciByYWNlIHdvdWxkDQo+IGluZGljYXRlIGEgYnVnIGluIGEgdXNlciBzcGFjZSBhcHBs
aWNhdGlvbiksIGJ1dCBpdCBnaXZlcyBhIGNvbnNpc3RlbnQNCj4gcnVsZTogaWYgYW4gZW5jbGF2
ZSBwYWdlIGlzIHVuZGVyIGNlcnRhaW4gb3BlcmF0aW9uIGJ5IHRoZSBrZXJuZWwgd2l0aA0KPiB0
aGUgbWFwcGluZyByZW1vdmVkLCB0aGVuIG90aGVyIHRocmVhZHMgdHJ5aW5nIHRvIGFjY2VzcyB0
aGF0IHBhZ2UgYXJlDQo+IHRlbXBvcmFyaWx5IGJsb2NrZWQgYW5kIHNob3VsZCByZXRyeS4NCj4g
DQo+IEZpeGVzOiA5ODQ5YmIyNzE1MmMgKCJ4ODYvc2d4OiBTdXBwb3J0IGNvbXBsZXRlIHBhZ2Ug
cmVtb3ZhbCIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6
IERtaXRyaWkgS3V2YWlza2lpIDxkbWl0cmlpLmt1dmFpc2tpaUBpbnRlbC5jb20+DQoNClRoaXMg
YWxzbyBuZWVkcyBhbm90aGVyIEZpeGVzIHRhZzoNCg0KICBGaXhlczogNDVkNTQ2YjhjMTA5ZCAo
Ing4Ni9zZ3g6IFN1cHBvcnQgbW9kaWZ5aW5nIFNHWCBwYWdlIHR5cGUiKQ0KDQouLiBzaW5jZSB0
aGlzIHBhdGNoIGZpeGVzIHR3byBmdW5jdGlvbnMgaW50cm9kdWNlZCBieSB0d28gcGF0Y2hlcy4N
Cg0KTWF5YmUgaXQncyBiZXR0ZXIgdG8gc3BsaXQgdGhpcyBpbnRvIHR3byBwYXRjaGVzIHdpdGgg
ZWFjaCBoYXZlIG9uZSBGaXhlcyB0YWcsDQpidXQgSSB0aGluayBpdCBzaG91bGQgYWxzbyBiZSBm
aW5lIHRvIGhhdmUgdHdvIEZpeGVzIHRhZ3MgaW4gdGhpcyBvbmUgcGF0Y2gNCihJJ3ZlIHNlZW4g
dGhhdCBiZWZvcmUpLCBiZWNhdXNlIGFsbCBTR1gyIHBhdGNoZXMgd2VyZSBtZXJnZWQgdG9nZXRo
ZXIgaW4gdGhlDQpzYW1lIGtlcm5lbCByZWxlYXNlLg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5n
IDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQo=
