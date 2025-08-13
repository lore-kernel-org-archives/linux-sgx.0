Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6412F2907;
	Wed, 13 Aug 2025 11:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755083275; cv=fail; b=miMc3qL2j4S58c9HaBV4jb28ExSITED1QiINcd/ueFtvsyHuRj+Fx4aEdNDODeevXCtHaTz5blHM1XjL16RhRF1zDaM/ixCx+jDtJgu1Y710JvuMsUM4dy6vbrwshkl9HzPSrMqasY3shN8WovqxewFgt2J2sP4JLjG7TKYkIsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755083275; c=relaxed/simple;
	bh=aPcmkUImtHYF5IZbsPbu18Xivbkh1o6f89uwDd3fZ8M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EQ8BwM1xhrOTcOFJcV1EvXeOFtWU63MUS/BRMIw1qQ/EPRxbBB0V6O1ucm/Q8RgD6WvP9/z2GM/KmxxxVDaA8Geee/qeUFcXrIe2tnDpDOV62Zz12hOO9H4y9U8bObE+fpqUSNcRjOYWNu/gqglxQAoisHTvCJDjjteHqeHExw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eWcwsRoj; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eWcwsRoj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755083273; x=1786619273;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aPcmkUImtHYF5IZbsPbu18Xivbkh1o6f89uwDd3fZ8M=;
  b=eWcwsRojaqBucEjWbTyMdnBFH0YhURDllGoTCFdrvmM0gOUrfcv9eG1K
   6WZwUCx0EnBlXzpof66ZNi/s/FEFtAjdNSfg+HehpOcUsjlOunjlZSXwn
   AUFOrSJG+M0SisofxpsOhq2ax53IjKlbXJr8As5DORmKPcHD0mmEO5hhF
   gj0FiP98kuBpAhtUiLEvr8l8f2TE6bjeuxxrRRiA9AUa8hVsSRcksNJw6
   4/9iatuc8CdZtPR+FyuS7gXtJETVccaAyITwJJHUqDB//c+0yTku8ZRyp
   vm3ZoztnMrZsO8+geQ5GDVe0XTlQpc4Pu17GDZ+5+stALQWkIga1dYYHl
   Q==;
X-CSE-ConnectionGUID: pO/zLPtXSNyEIno5nPdGag==
X-CSE-MsgGUID: vKH8QK74QPCc7CAy+9WKRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="79946749"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="79946749"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 04:07:52 -0700
X-CSE-ConnectionGUID: UbmNgN3FQHm/cFCrObEUyg==
X-CSE-MsgGUID: zVyu2F4/Tr2xmR7z5XQeRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="171770735"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 04:07:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 04:07:51 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 04:07:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.67)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 04:07:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eWpeems9YPJ+xETIt6BNsbzSwsvoE9SWgBW7VpWtRolJU9lIJ72MSpS8NtWfSRODBEfjdRgAuYC0tPzc3cgpT0rb8mZe02EVjoVj+wOr3jaFx+25E2FZsw1Mb7HGR5vH2fGCjI7eKiBOu1MFtuL7Bubo7xvGqPzQVD6ERPvBPyQgaw9HjcgffoNjAStQ6e4st/zyewqJG5KHzfFf9f5vnRaSAUz1TlWtD2bMuptskdVS2nEMkGtyrVFTt2zR/VOU3sAUfk6rLJR0WRQzGnWXRto5Wu/bRR3NpvCsQmTTQJfH9HMNaj0SgC4qVrko39mb2nkHcYbZb/H/SMQn4CtZwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aPcmkUImtHYF5IZbsPbu18Xivbkh1o6f89uwDd3fZ8M=;
 b=zSRGnfbUL2V0MBmnDr3IxKYN0yzV03AbWqOp3GoeGJPW9u08++AxYU4zYzan3Qk1MqNWixN3E4YMcvRTKKoKVQfa5FmqwvmE0OfOg6PZolK+S+mv1uaDUih91W1REQbpaLs8/TR0JmBsFg5UjrYx5qn2kwWCSTQhB9Au5KuUPa7K3UCp+z8WA7GHssQHMT3SEXRC0aacBjFn7e7iqX83J1Nk4BQkoe18ku6m2CkzJ9lmYcOO5awCpnq1syhvt6DVY+Ruamjma9f8Oh5DydALC+2fQR5PoFEhXCin/UHU2cLphYOAZ3HuMR9XTxIBYNGCqElur54hXneftXQIJeE49A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB7765.namprd11.prod.outlook.com (2603:10b6:8:130::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Wed, 13 Aug
 2025 11:07:34 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Wed, 13 Aug 2025
 11:07:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v13 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v13 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHcDC+7Bq96bIYDx0WQiLX/nYRlzrRgbIwA
Date: Wed, 13 Aug 2025 11:07:33 +0000
Message-ID: <1a19722b2f979cf34125ec562523ddf0ea8e0b26.camel@intel.com>
References: <20250813085233.1369036-1-elena.reshetova@intel.com>
	 <20250813085233.1369036-5-elena.reshetova@intel.com>
In-Reply-To: <20250813085233.1369036-5-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB7765:EE_
x-ms-office365-filtering-correlation-id: a71cbd5b-2170-441d-2f25-08ddda599ac0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RXJaaWtsSndYcUdIZGJ0R2ZVSjBqZTFIVXA5ZlFsVS9JcFhPV2NURTF2WkNJ?=
 =?utf-8?B?NUVFYndoKzBrMTBndVh0RjdXcUlHaUJPd1pWVlNiTDNTWUlnNzBMMGdvTU90?=
 =?utf-8?B?R1duRE1mb09xcHc1cm9RVUtsanNYVHdMTU5OUkNRRzhYVC9odERtVEFjckJH?=
 =?utf-8?B?bmc0SmpNNmxzc2dXVGlJYzNBTlRubktpeFpUNnNscFhEdFU5c3laaUhoakQ4?=
 =?utf-8?B?Rnh6NFVwaWNwbnhxeGhZcVNUZGdnNEtxL1ZkamNBOUZvZWJKa01EYmZXWjEz?=
 =?utf-8?B?WjlIam9MY1NlUXRYQTdndmJ1eVJRTWQ3SU1EZnB6ZnhrWlVSelFjUEtJblVU?=
 =?utf-8?B?cHZFSUFFTytCQlV1cytrTHgrRVBZRCtEOGd1S2xRYldiY01QUWd2RmhGWmQ2?=
 =?utf-8?B?K2JFY2FwVHM3aDJZU1haTHh3RENLWUc2ZER2UUhkaFAzM0dHZkRZcTh6NmdI?=
 =?utf-8?B?UmwrZ25mNnRreXZPUFl6TXMzN2ZMdEszZ3ZNQ3ZoZWVnUU5mUlhVajVxaEJa?=
 =?utf-8?B?bkZwaEU3T3lyT1Y0bTVwSnl2Z0ZlbXh6NURtdFJ6OEt0OFV0MTZVekpJMzFM?=
 =?utf-8?B?VHg4cFByNHBRTUZrMVRkN0ZZTktJTmlMM2NNVmF3ZUx5S3R1YTBoWS9iMW9J?=
 =?utf-8?B?ZXkvaUsyL1QyT2VXN0p3T1JtUmYzb3IyQ3RHVEdCYkhqWkp6Y29GdHY3cXIw?=
 =?utf-8?B?YnpkNGRlTDdaZ21RUFd3MDJuODBNRjdDTGxwVmc3YWJrcU5sdHZnYlhHR0xB?=
 =?utf-8?B?eXNPZ1ZMVEZEZm1HcktiMHBMdzFHUGg4cWVrMGdvcTlrSGtuZ04zek1IV2Z5?=
 =?utf-8?B?dExCdWIxNzdKdEZ5UVcwdWpEVUV6SWdRYUV6c0c0NjZZUDhWMFUxcmJGN1h0?=
 =?utf-8?B?S1BubE92N1dBN3R6VzloRVRLUUJXY2JjYks5THF4SkFBcXNtekpuaWVLMk82?=
 =?utf-8?B?dHhHSUVuelRlRDFOeE5tVXlQdVppRVFxNU9VSkdCc1BaTGtYZ1BUaEFaQ1NY?=
 =?utf-8?B?Z3U2RWlhcXJFU1drdUZoNU1LMU51U0VDS0QybjFYTHZRamNvMTRNWHBiRGZG?=
 =?utf-8?B?dUNIaHFGOHV0UkEyZ3J2TnQ3MWdyWVh4N3JmNUgxdy9YdUt1anlST2ZRdTlP?=
 =?utf-8?B?UmNnZ0dhU0czZDhFd09tVldXQWVTN1drN2lYOFZLY0J0YUd2dkx3WTRYZysw?=
 =?utf-8?B?Y0JkbW5qMnpLVWJRcEJsc3ZzY3BVc21YZE4rVzkxNUVOMVRod21vOFErQ0Fs?=
 =?utf-8?B?d3hEU2FvdGdBenlUWGZnKzd4NU9hajg1L2RVcmpRSFoyTExPMkc0aVdvRXhM?=
 =?utf-8?B?eUxGMEJES252TXl2ZEtLYno3UExjVDRsbW1WNEYySU9nd0xDWTYwNm5HeFpt?=
 =?utf-8?B?d0VWRVg5Wm9JMW5WUUFUcHl2QjVFOVJ4UVpuZ1d1QmpUTEVDVHg1WnhkbEFM?=
 =?utf-8?B?SEdrTDc4YXhqUEdaL3dUcGFZbG1BUHVSWkcyRzZhemVqR1hDUEdHTm5QckNu?=
 =?utf-8?B?VDR6dUZ0UG1pRzFsZGJuZSt1cUd6K0pKSTI5SkRXbFIyNWgxZktyZDVjZkp2?=
 =?utf-8?B?RjFKdERvbVZ2L2lzb3ZLWWduZldrOVFpMlRrWGlWN3JSNXlVYlNuaUIxaFRr?=
 =?utf-8?B?SmlNQkw3dXRZNk50VU9PZVF2S2UxUFl3KzUvTnNKQmRNdWtIUlRQd3JSaTBO?=
 =?utf-8?B?MDB0cFBBbFZtblppQXFYajZsSEh0WFNUVlEzM3prejlZWW1EN3lIeVRHVUxW?=
 =?utf-8?B?OGlRNFBJVUh6Si85S2ZwUzRCQllnclhHSXpLbXlJZ3RoUHNLbG9lL1lnUXlx?=
 =?utf-8?B?WW5UZDdOeHdURDNOUHZNcDUra3Z3ZklCSGw2bHR5WVBLa0E1UWdQbytGRTZL?=
 =?utf-8?B?OE9QM2lFTUYwOThyWHRuZUpmbGNiRm50TW9BNHlrVzF6VXNPZzRTc3FtYlVM?=
 =?utf-8?B?VlU3eUs3WTZWdW9maHJpcG81RE5CcFFuU3dkUXFwOXBUUWdjU3U4RWFGclpu?=
 =?utf-8?Q?QZE7vNlepL83QmS5mNcwCAgRpCaon8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUFabjdTUzBscTROTThvTThZYkFKOFVsZEl6RlNVY2l1S1lFdEpmK2dLam9p?=
 =?utf-8?B?bFFWeXUrTWdYZ0tBcW51RXJvbEVzWWhEcjhwTHhhVGNnYkNDSEZCOXRUUTRl?=
 =?utf-8?B?K3phcTllOTJsV1hWc3hTTTZlZ21abEdFYzdzMlVqYnJENGNDWjNPc0l2T00y?=
 =?utf-8?B?bGhZYnRTQUFScFF2bmwwMFlwY3NzSnRLZnJBZm1KZ29oNktDOE5XMXFSdnFM?=
 =?utf-8?B?N1VlcVNKdUVTR0xZbHVaQXpNYldyblY2eHFyS1FncWVHeE8wdGR6a1pDa2c1?=
 =?utf-8?B?Y2lNbzEyYy93dVg4OHRWbGJ2Q0xYTFNGcUNhSmJ6ekRKTUs2MHptZ05ZV3ZP?=
 =?utf-8?B?em04SUZsci9XY0N5dWJqcnJJdUhtUXVUU3Z2SzFVeFNQRTFEUVQyMzF2R0ox?=
 =?utf-8?B?NDc2N3dBaXMrSUJOUHVTRDRiaG9RekpJUEI3cXNYd25IdWdKZThxTHZnTXJD?=
 =?utf-8?B?Y05QbDFRSkN6a2p3Sy9CQTcrdGd5TERiQTFCMlVreTlwSXB0eURnYzFzTDdy?=
 =?utf-8?B?NkdhaENXdlFhNjRsbVQ1SHJKM2Z0TXNDVndURWFraE0wdGZVVEVUUnhvbDFw?=
 =?utf-8?B?YWlQQ0psamRCeTB2dzNRYXhnQ2tkcTZkNEFWTXpWSUhJUlFKNmZIZ3A3THFF?=
 =?utf-8?B?bFRsQ0xGZlFkOENzN0V4djVobXluWFc0RlZlcmVPeThobGEvOWZ0Y3NDWEtP?=
 =?utf-8?B?YUJ4NDk3bVNQd2IrRkY0aktvVGZWUFBXb2JVSnM4WkxlZkRCWlRLa2Vra1Zz?=
 =?utf-8?B?b1V2ZDFaS0RHdWRLZnhPWStkdXNsUWUrbDhEMDVFOTdwYUs5LzNidUx2OUlM?=
 =?utf-8?B?RGRkUWNuUlJWWGZjSmx6WDAvQVhFTisxTHd4UjA4OEpDbVRYZnhSYnBXR0tr?=
 =?utf-8?B?OXByTmxac0IwVFRvN3kyaCtGeE5NcUtvSlpHajZlbEFaeUxETWFubGk4c1hq?=
 =?utf-8?B?UkE5N29zS2E0UlRFemxkL3JjTHVUamtwckNyYUtmNitIL3hhalJCTjNHaDBj?=
 =?utf-8?B?RzBIKzhuQmxHVXpQT2ZxM0o2U2E0bnNmOWJrU3dnWXI2aU1JMmFTaS9pV2Ey?=
 =?utf-8?B?dE02MEtuSENmWkFRazVDam1aMUYrY3pMUFh1ZmFiQWFVRk1ZU1BrNS9lOXF4?=
 =?utf-8?B?N1RGM3JHSVZLY0JURElkZEQwUWltNGhYZTJ5WXI3Z2xqNU40Q0pjajUzQnZV?=
 =?utf-8?B?Wk5RSHhiTmFXeTNyREppaXNUQXc1ajh0Vlk0QXdYY280YW1TT056YUlKbEU4?=
 =?utf-8?B?d2dXLzRHTUFKQXpUTTRhSWdhaEJ0VnlCbzlpSE5Pa2EwREV0Mm1Cbll4K1Ex?=
 =?utf-8?B?blFUS3IzM3ZUM0cweXlPLzNDTFVXVHowd25EeEtYdkZ5WnF2KzA1Tm5icWRa?=
 =?utf-8?B?eHRjUHl0RUMxLzJrd0hnSHFCQUttTUpobmwxMXdNSkVzUWhRM0dxWXlzWlpz?=
 =?utf-8?B?aDNGa0RTUnZXbXFKRlcvL05lQU9lN0RyL0RTNDVVcjVBYnVLd3JXcllmb2pM?=
 =?utf-8?B?QkRscTJZUmIyYnZrNC91ME1wN09hRmU5N2hONktManVqTGlWS0FaTCsyUWkx?=
 =?utf-8?B?ZGd2RGRmb3VqdmJ1MWFLYWpHVU5IZ0NrbEhxYThXcTJac0NoZWxJNC82OE04?=
 =?utf-8?B?RUduSS9xaURFREJ4bGI3azR3RUNzN1NkQ3pwc0c3NVA4ODBGNkpaazRWaVBq?=
 =?utf-8?B?dEZGdnZUSWpzQXhZckhOSVU4bStTRmtXZGJQa2FrYlNqWlNwU1QwVXF3TThy?=
 =?utf-8?B?TmFuMnY5Q0Jza2RNTVFreHNuZVhWZUY1R3lsemZDV0JVL0hGK0xqc04yYk5y?=
 =?utf-8?B?M2M4V3c4VytiOGlTZG50dFFPK3JENjRZbk4rMVpHeTFLNjhFa3BmMmtHSnU2?=
 =?utf-8?B?OHNoY2xRV3NqYm15NW9pZGJaRXFnVGdwVU02dUlWZWFxZUNYaWl4TGJoemVn?=
 =?utf-8?B?ek9EWTNtVEtSWTZ3OStHY1lBSjN3UXhzZmQvM1daaEkraDI3UVNwQVgvRlVU?=
 =?utf-8?B?cU9TUVZwOE84ZmZFR1hFbmNIb0pIWDVnci9sY3dTVXdocEwrTXZ1bHhPbHpW?=
 =?utf-8?B?TFNqRzJSemNORHlkVnM5azJ4WnVMSnhHRnVRMmorRWg5eGlHU3FmL1BNeitK?=
 =?utf-8?Q?z4DLQLogFIUCroIMz5J/eMcOk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60E7DFC38288884E9FC47560D95E314D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71cbd5b-2170-441d-2f25-08ddda599ac0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2025 11:07:33.9466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4LJ/SuMweiqdgd2lLDG4d7BQIypvKCqbT/71vk8q4+9YANF0Vi2IFNIygWczD/fxtb97VPtfw9L6l6mPDoCj0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7765
X-OriginatorOrg: intel.com

DQo+ICANCj4gKy8qIENvdW50ZXIgdG8gY291bnQgdGhlIGFjdGl2ZSBTR1ggdXNlcnMgKi8NCj4g
K3N0YXRpYyBpbnQgc2d4X3VzYWdlX2NvdW50Ow0KPiANCg0KWy4uLl0NCg0KPiArICogUmV0dXJu
Og0KPiArICogJTA6CQkJLSBTdWNjZXNzIG9yIG5vdCBzdXBwb3J0ZWQNCj4gKyAqICUtRUFHQUlO
OgktIENhbiBiZSBzYWZlbHkgcmV0cmllZCwgZmFpbHVyZSBpcyBkdWUgdG8gbGFjayBvZg0KPiAr
ICoJCQkJZW50cm9weSBpbiBSTkcNCj4gKyAqICUtRUlPOgkJLSBVbmV4cGVjdGVkIGVycm9yLCBy
ZXRyaWVzIGFyZSBub3QgYWR2aXNhYmxlDQo+ICsgKi8NCg0KVGhpcyB0aW1lIEkgYWN0dWFsbHkg
ZG93bmxvYWRlZCB0aG9zZSBwYXRjaGVzIGFuZCBhcHBsaWVkIHRvIG15IGxvY2FsLCBhbmQNCkkg
Zm91bmQgdGhlIGRlc2NyaXB0aW9ucyBvZiB0aGUgZXJyb3IgY29kZXMgYXJlIG5vdCB2ZXJ0aWNh
bGx5IGFsaWduZWQuDQoNClBsZWFzZSBmaXggKGFuZCBpdCdzIHNhZCB3ZSBzdGlsbCBuZWVkIHRv
IGZpeCB0aGlzIHR5cGUgb2YgdGhpbmcgaW4gdjEzKS4NCg0KTml0OiBhcyBzYWlkIGJlZm9yZSwg
dGhlIGstZG9jIGNvbW1lbnQgZG9jIHNheXM6DQoNCiAgICAuLiBpbiBvcmRlciB0byBwcm9kdWNl
IHRoZSBkZXNpcmVkIGxpbmUgYnJlYWtzLCB5b3UgbmVlZCB0byB1c2UgYSBSZVNUDQogICAgbGlz
dCwgZS4gZy46DQoNCiAgICAqIFJldHVybjoNCiAgICAqICogJTAgICAgICAgICAgICAtIE9LIHRv
IHJ1bnRpbWUgc3VzcGVuZCB0aGUgZGV2aWNlDQogICAgKiAqICUtRUJVU1kgICAgICAgLSBEZXZp
Y2Ugc2hvdWxkIG5vdCBiZSBydW50aW1lIHN1c3BlbmRlZA0KDQooaGludDogdGhlcmUncyBhbiBh
ZGRpdGlvbmFsICcqJyBiZWZvcmUgdGhlICclJy4pDQoNCkJ1dCBJIGd1ZXNzIGl0J3MganVzdCBh
IG5pdCBidXQgbm90IGEgYmxvY2tlci4NCg0KPiArc3RhdGljIGludCBfX21heWJlX3VudXNlZCBz
Z3hfdXBkYXRlX3N2bih2b2lkKQ0KPiArew0KPiArCWludCByZXQ7DQo+ICsNCj4gKwkvKg0KPiAr
CSAqIElmIEVVUERBVEVTVk4gaXMgbm90IGF2YWlsYWJsZSwgaXQgaXMgb2sgdG8NCj4gKwkgKiBz
aWxlbnRseSBza2lwIGl0IHRvIGNvbXBseSB3aXRoIGxlZ2FjeSBiZWhhdmlvci4NCj4gKwkgKi8N
Cj4gKwlpZiAoIWNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVfU0dYX0VVUERBVEVTVk4p
KQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiArCS8qDQo+ICsJICogRVBDIGlzIGd1YXJhbnRlZWQg
dG8gYmUgZW1wdHkgd2hlbiB0aGVyZSBhcmUgbm8gdXNlcnMuDQo+ICsJICogRW5zdXJlIHdlIGFy
ZSBvbiBvdXIgZmlyc3QgdXNlciBiZWZvcmUgcHJvY2VlZGluZyBmdXJ0aGVyLg0KPiArCSAqLw0K
PiArCVdBUk4oc2d4X3VzYWdlX2NvdW50ICE9IDEsICJFbGV2YXRlZCB1c2FnZSBjb3VudCB3aGVu
IGNhbGxpbmcgRVVQREFURVNWTlxuIik7DQoNCkl0IHNlZW1zIHlvdSBhcmUgb2JzZXNzZWQgdG8g
dXNlICIhPSAxIiwgcmF0aGVyIHRoYW4gIiE9IDAiLg0KDQpJSVVDLCBEYXZlIHN1Z2dlc3RlZCB0
aGUgbGF0dGVyIFsqXToNCg0KICAgIAkvKiBFUEMgaXMgZ3VhcmFudGVlZCB0byBiZSBlbXB0eSB3
aGVuIHRoZXJlIGFyZSBubyB1c2VyczogKi8NCglXQVJOKGNvdW50LCAiRWxldmF0ZWQgdXNhZ2Ug
Y291bnQuLi4iKTsNCg0KLi4gd2hpY2ggaXMgbXkgbmF0dXJhbCByZXNwb25zZSB0b28uDQoNCkFu
ZCB0aGUgb2RkIGlzIEkgYWN0dWFsbHkgbmVlZCB0byBsb29rIGF0IHRoZSBuZXh0IHBhdGNoIHRv
IHNlZSB3aHkgIiE9IDEiDQppcyB1c2VkLg0KDQpbKl0NCmh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2xpbnV4LXNneC8yMDI1MDgwMTExMjYxOS4xMTE3NTQ5LTEtZWxlbmEucmVzaGV0b3ZhQGludGVs
LmNvbS9ULyNtMjIyNWIyNzQ0OGRlODY4YTdiYzFiODZlZDdmMmVlNzg0MzY3YmE4NA0K
