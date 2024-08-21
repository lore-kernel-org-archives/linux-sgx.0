Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AD11D12FE;
	Wed, 21 Aug 2024 11:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724238937; cv=fail; b=LC6KTlYHR81ZqV8kkoABzp0I64UYg15hUvhvHF/T3QZrjtO2ffOk30ONz26RsKAaq8iSRGNO+DfnLTUl10yslwuV95iIYhTAtz/Q5UROPl2twOQcFEolSiodKGQH1B7Idns70uvBhIFPvRjurUKPRRLeyLIRyvTvE3l5ANDooU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724238937; c=relaxed/simple;
	bh=YpmGkyp6nI1ZoqUHYpJv9RLjLg+1KM29Ao/s0eRS2OI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vc0I/gDWXT2eHEwYfpWtukDQQlVwEhPEk2ylbrorSYbnmiyFmWP5IIcHxh9hH5AlXC3Feh1aq7Ijjlr3er2bzmAiDTI3mDlPgLUbGcmX1nTurRTBBSbrUHCj39zBssJMZx2CmU/h13azynhMTxFbrykDZL++89cSzvFuezyl2W8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AcGDdN89; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AcGDdN89"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724238936; x=1755774936;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YpmGkyp6nI1ZoqUHYpJv9RLjLg+1KM29Ao/s0eRS2OI=;
  b=AcGDdN89ea05hcWMv6AwlFAl4fmd3zYsjzip2IV7WvtjPCzIW/1t4qta
   UrnIjuRQ+ygL1OqFhZWwWdtPfXb0Vxen/V0G7/bZqHgKJHv6hxIkOqF6X
   U8LeNqXgg5d/hx4IUXQh0T9nI9yAygo1qfmmZrMG8C0hMjlX2o4Fu52D/
   paVElQo1eUaVRIjUxdUG0wt7xuz7BXn8J9ZAqe6xwdHtSIhuhDwA+/41l
   SA3rgjvZV7mfZzokhWFEpzW/7SEveQyATAFzQrqaBSEYJmLpZ9my02zSU
   sxatE1CpTyhuAxi7KDfHsuvqjMlXuUkjj8dBhlxq0/ehd3YCQ28zd6xUh
   g==;
X-CSE-ConnectionGUID: N1C2ox6ZQoWl0ljzlEBXMw==
X-CSE-MsgGUID: khPieycPTQ2LqgHCjdXDWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="22725601"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="22725601"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 04:15:35 -0700
X-CSE-ConnectionGUID: 9AM9V4n5QTOO+resFa5x/Q==
X-CSE-MsgGUID: pPGTbH/GTZWHKn7ncCv7dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="61032318"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Aug 2024 04:15:36 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 04:15:34 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 21 Aug 2024 04:15:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 21 Aug 2024 04:15:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 04:15:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yENL4QliQGQ41wOauxbfs3Ek0vl34vCJAhXYYY/y2lPKxq+Rq37uzrvch5uN+lzfrpoe3OJDE//3oJT+lIl53vvV/Tmo9M1mJ/hinbAHA/DqZ8Qf5i448c0SC5wVn0nF2upOjVg/IsLv9g7g0k63iLU3hfBpghLFdEnicYVJ+zA4K8y6iMjkxLGMZ1YF/ZRFOz3kx3x9SIKwWX+QOe6A7zw2llL3fp+G3LXzFguBusZWNIxw44Y5jlQ5hdKBr5Se1PME1ws/Lvadf2mo9QkcoAs/sX4ujzXQ2LfwTUpgwNdhl1qTf7CxFezslKPhWoYKt74fJu+eRO660pGzXBVBRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpmGkyp6nI1ZoqUHYpJv9RLjLg+1KM29Ao/s0eRS2OI=;
 b=wcoS759Kaq7h4phdGxRh0yiOGyuBu78CJfEkTrX1jzXONXT3XMoXFJgc8eT5QbDDvpVC/CsSF7fnC8qIfIo0kFeMpUYZSe+79An1uITNd3/YAGEbYtByEAkCSsrgV3+LHktd9Xkrg40tpg8HaPuSVH7wozE2HnMORcMfhwYyfq6RmslcZrySlt3L9bF8lfRGPVK5Q2mAbuBKqEXEZ7LkBBpNhpWW8jwCS5u0Gor4lcj6ugIppyhLK95IGdsR9xa/gYUKZw1scSQyQUI55RWz9mv9CW6K0C/ofxeAhgRLq73Yf+89KT/np/Tjqk2eDHNxuub1b1yo/C8QFAsVrZNDiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Wed, 21 Aug
 2024 11:15:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 11:15:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Kuvaiskii, Dmitrii" <dmitrii.kuvaiskii@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"mwk@invisiblethingslab.com" <mwk@invisiblethingslab.com>, "Vij, Mona"
	<mona.vij@intel.com>, "Qin, Kailun" <kailun.qin@intel.com>
Subject: Re: [PATCH v5 2/3] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
Thread-Topic: [PATCH v5 2/3] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
Thread-Index: AQHa87Jiu1Pv5ea1OEODRsRiHERS/7Ixj3UA
Date: Wed, 21 Aug 2024 11:15:31 +0000
Message-ID: <dfeb01252e0c4280be507a6580ad1202c363330d.camel@intel.com>
References: <20240821100215.4119457-1-dmitrii.kuvaiskii@intel.com>
	 <20240821100215.4119457-3-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240821100215.4119457-3-dmitrii.kuvaiskii@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB7097:EE_
x-ms-office365-filtering-correlation-id: 56f7a6c7-6363-4fde-9a10-08dcc1d291e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a1Y3N01UL29LU2FDNGtmMllmZGdTZlJqc2tjQXR5SHIwUkxOOGNYeGZMdGNy?=
 =?utf-8?B?a2pVenVRMGp0MUZXUlhXYWNYVXY4Y1ZCV1dBd1pUSXd5b2xabE9Pc3gvdnRJ?=
 =?utf-8?B?VkY4VnlXMS9iNDVTN05ROEZXZDFnN0k5R0tMcDhaYlFrOU81VFQ0VnA1TUs4?=
 =?utf-8?B?Rjc2SWxTcnpxeXpnRm9jWjR3UWNLWHEvYk9FS25jekJOaFk5aVRkNi9kUGVy?=
 =?utf-8?B?aWJXSWtZTXlBcUtUMEY2azlCOEdvSEJ5L2hSZEsrY3ovTXNjeXlIb1dOa25E?=
 =?utf-8?B?aUFtYkdPblNRM2tJZ3NBb2crRk5RQ3hYRjFtMVNZK295eVA3YkFGR3M3L09U?=
 =?utf-8?B?Yys2QSsvbjNHclBFanlIMm1IUlBidDdwUTZ4c0RWdFBSd09hc2tITEVZa0hP?=
 =?utf-8?B?NVNyeFVtOHZXdGVqTE9VeS94SWplVk8rQ2syS1NGNjFJdnFwNnl6Y0VqaWxs?=
 =?utf-8?B?OSs1dUdqQlJ4d3piOFMyT24zaTVZT0VDUUNrdmdycEcyR001MHo5ZjJ1cktI?=
 =?utf-8?B?S2lDSDRVaTY3SUxUc0hpK0huOXlpUjUwYzdFMTN1VWxIYkdVZ0tsQUhSdGdC?=
 =?utf-8?B?RjZtSUNFaVB2dFdTME9tbnRma2RjcmdRQUo5bHQvelcwL2gzY0wxZG5FQlhR?=
 =?utf-8?B?UkVJN1RIaHR0dElUV0JRc0tQYndWeVB0Ly9wSzNuOGlDS0VZazRFWmNoNWJT?=
 =?utf-8?B?aUN3aE1jZmpGeCsxUGw5ZlJPZ3Y5WFlCeWJsM1ZmaXRvTUJQS212UzdHZ09l?=
 =?utf-8?B?eUtOUGRnNk0wUjkrdURPV1BWUHBTTGo3R1NMdW1uYkdDc2hzNTNvWFpSZDJj?=
 =?utf-8?B?VkdMbkNURllFcmZaK2liQStBVFQ5UUpZRmRSZDl4N3B3blJpbnZqaVlLKy9v?=
 =?utf-8?B?L3ZTVGU4V2FyQzNSNVdrL0oxTUZGQTRVL3hDU2U1Ni9Ibm4xL2E0RHhKWXpU?=
 =?utf-8?B?N1Y3U2cyMitZVTV5cit6dmcxVFA3WVltT1Y3WS9zaUlZWGJ2dVE1dGVKbS9n?=
 =?utf-8?B?YitoWWRJYmJwTTVTd3FiUitNTG5xTEZrVk8zVW5kdTc5cVFDaHNDUW85VmR2?=
 =?utf-8?B?RDYvcis2YTR1WmZ0QThjNTBpREljeGJsNDRudVRLSjIvbVVVSHdXM0lSMTl2?=
 =?utf-8?B?RS9yMTBSMk1KRTRHZFV1VjFXQytxb1hXZjNkZVBOZjhjN2EvUkVFMzlJbFRD?=
 =?utf-8?B?SWZNNTdNNFFwVHJQU0pFWjU5K2JOclhsV3RzSTNseUwyaWEwVzM0aHE4UytF?=
 =?utf-8?B?eHVkTFZJK2V5ZVIxWGtYSVBDQXhMTWtTb2lrekJNZUhxWnpoaFhzVUc0Ym5K?=
 =?utf-8?B?NUFnNXBjenhHa2t6WGZ4bUFwZ2VwOVF3YVZSc0RFZFp6bjRML3ptY1hkM3Q1?=
 =?utf-8?B?RnpEM3dwdVpURzFqSUJ2dGJqUmVrS1djL1hLSmEzWUNZUjN4RjBGOWN0WWZu?=
 =?utf-8?B?R1VCeXRWcmxsaG1BeVIrTzFveXQ3cFZRcEhueGRxNndpTVptNFhyRWs1cVNr?=
 =?utf-8?B?aXVqUEg4bWN1SmthZUs1cG12UVM1Yk1lZHloMVZNd0ZTUmIxdzhNbTRDQmJQ?=
 =?utf-8?B?UWlkOXZubVMzbjFURmovNlR4U08wN1dYQk5WRndsVEt6dHhsZ3EvMjZKWDlC?=
 =?utf-8?B?dWlHaUlzbFVRNXJ1b1JheGRjUlFjRmh6aDJaUkxqVXZpVlRQeVFsK1FpMDVN?=
 =?utf-8?B?RGtoYittU2xLbE9IVHpjREFpOGdxVjM5TW50NEtKbldYYmxheG85MmNZbUov?=
 =?utf-8?B?VG41ODBkbEVwbjQ0d1lZOHIzcXRudE5NckpwUldQR3VXZGdkNDYvclNnQXFG?=
 =?utf-8?B?d3VVdko4bkJ6VlorN1ROS1IyRlFKV0ozanYzVTdLcGlTNEw4alBCU1ZyQW1k?=
 =?utf-8?B?OHFnMWRuVWE0MzJxODk1bjdyUVRFSCtHWm9vbWR1SWRFaUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFE3Vm5zTitYd2laZVUrT1dWeG45K2F6MFhjTlhXTWhxWFd5aldkY0ZKQU93?=
 =?utf-8?B?bEsxbitLSk5RQVlSZUFTRmY5c0VBV3p5TXpBSEFHb1BXR2hmZ3hWcFJ0cWRv?=
 =?utf-8?B?N0dMZ1hTOHFaYWlKUmFFUDFmemRybHNPSEJ1SzNjQnFYTVA2R1o2QTM0U1pE?=
 =?utf-8?B?d0V5QU5qdGpVUmszaS9PSlo0QUpDS1JneVQyeHM3RG5jbVV2bzF4OTVmb0dl?=
 =?utf-8?B?ekRxY0hvaFZibitZWitZS0o5a0dKOU02TnB0RVZSMURScWFZcHlUTFZBajZG?=
 =?utf-8?B?ZWc5M2h5bEJxY2VlVjFBNTRsd1Vpc1BZM3hjNlJNZTUwUjdFMm8vd0hWN3dv?=
 =?utf-8?B?RGxBc2x2Nzd4ZzFYbEFCaFV5MVBRaW5qNk5iRUFiZlkxZW8yU0Mra2c0VEFF?=
 =?utf-8?B?OFlabmJQeHhxUDIrZHFYNUhEaGlSQ0ZiWFVBSnJIaW51a3FHN0p1RGNjbVU2?=
 =?utf-8?B?dmtXSE5ZMXgrTUZTa3hFdFEvdlJEK3loekF1UEJLSlhMUFFrN1dtQXNMekd0?=
 =?utf-8?B?QXg2d3pCVHB3VUZWWmM3SEIzbkRZMjM3NHVMejRFOUJvU3BDRml4aENQcGpy?=
 =?utf-8?B?dlM0NStsb3d6c1hEbnVjYWU5VFF3ektGamNVelQyamo5Z0pWbTd6RFNnaU1m?=
 =?utf-8?B?ekgrMzRpSUNac1JUZkplTWdZTGlmTytrVXU3bDFZT3VoQjlaT1lRYkhhMmgv?=
 =?utf-8?B?eVZ2b2c1b21iMzcyMlRpSXVKek5QSnFrN2NnbzhQMXdPWmlWZDlKdUF0UHZ1?=
 =?utf-8?B?NHp2L0U3dXdmV2xJV2V5Wm9oUmMyZlJLMWZGYnZEU2pQaVdWTEsrSVEyeDNF?=
 =?utf-8?B?NkQ0Q3dUTFBWODlGZkdYaE9xbnFEL1BUTG5iVWhmZTQzdnBBUWMyOGRSSFZU?=
 =?utf-8?B?UTcrSmZFZStaN1B5WVFvaUpWb2pNR211dGhhd1EzcEk1OWcydUJaam5mZjF5?=
 =?utf-8?B?ci9DRmdFOVdzNm9DVkNxU2RpSVp3YnVsUTJBQklVVXFDNit2ZlliZVdQUzNX?=
 =?utf-8?B?NTJwRGNybU1zTVZ6d1A1WUFwMW56azNLSFhGS3lXNkxOSXhhL1BCRnlUTlpG?=
 =?utf-8?B?SU1DQ0M0Uk9LNFByS3lUcGFyVjQ1YlVNSEtZelNYbmhFYm1ybFgrakphUDFS?=
 =?utf-8?B?Y1dndmJIVVp0OFYxVDVIbDFrMDExNzhhOVdTdXFPSEthOHplVFpIUFZYcW9r?=
 =?utf-8?B?WEhzWW9rb3p5WUdpSE5MeS9KMFlldjg1QkM1aWJ4cDIwazFzRXBQV2VZSUp3?=
 =?utf-8?B?eTcxLytQK1NaZVN0L3MzZlI4c1g2dU14YkFkNDM2SGF3UmwvQTJBNDdvZXEy?=
 =?utf-8?B?bkhGbmFGZldpY0JyUzdaY1pickRvVjk2OWk0OW9mVTJGQ1RWSG9mbE40RURw?=
 =?utf-8?B?QTRHWE9pQURXT05XMU80R0xBZkI2Q082K3lRRThESHlmRnYvTERIcHVFdERa?=
 =?utf-8?B?UWhZZW1aVVVXWHY5bjFTQkk0bWNKTjFuNzNxZk9yUnlMaUEwdTdzN0hQR0Fk?=
 =?utf-8?B?TkRQL1R1WC9HVStldVlhcnBYREZoN3ZPWmNnekJmVDBjVHFMcjBtcTU4SG9M?=
 =?utf-8?B?ejJTWDJuSVI2VGxnY3R2VkpnVnkzUEgrdE1Ud2VYbWE3WnlVK0luaGxkMzE2?=
 =?utf-8?B?ajJPV2pnYnRJKzBhaVRUekNMZWRzUTJLV0VEdmRiWm40RXVCcmV6bVdoSnB6?=
 =?utf-8?B?bzk0ZGVNOWN2UlJvRjlEL0IzZnBodVpVeGFCN0RKcEpiZFVpOVFNM1Ixb1lu?=
 =?utf-8?B?bEJmMmd3TUg3RjRmR3NXcm9vRUtsSmd1anFKbCtFRDgwTVpXZk1zbEpEWGN0?=
 =?utf-8?B?UVluQ0RqQjNySFVBeFVTTlhyakhUY1F3TE1tVmRxZTB5NWhxRE9odkQyaHJQ?=
 =?utf-8?B?c1VHZWJsWlkyS0owcUlWMFdnWkZtWkJiQTZKQ0twdmg5VEhzZnFMcXpqUlJn?=
 =?utf-8?B?UGJ1WUJORi9xL0N2RlMvbGg4blZVdXRkck4wTlkvN3c3bVlReEhFVG1oRG10?=
 =?utf-8?B?YXlmTnpWRW4xSFpCcEx4ZFp5RVZFZVNib2hEbWp0Y0RVRWtscWxGR3JVRWEr?=
 =?utf-8?B?dENrQU40SFRoVUtTblJudzR4MkxBaWVHZktVR1lka0RpcTJXRXJ5Z0dMbnhr?=
 =?utf-8?Q?EA1yao/DpFvcE+zqfTkvrFH0V?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C400C8B2897FC47BD877141DB99BA08@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f7a6c7-6363-4fde-9a10-08dcc1d291e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 11:15:31.4895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZj7BSNL5U56h4HnI6Lpgli1/sJkTApApy4xrkQN4UPog68+Yf9G2dxJ6aLFRo5hBPL4crskUxXPThUBKXBAKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA4LTIxIGF0IDAzOjAyIC0wNzAwLCBEbWl0cmlpIEt1dmFpc2tpaSB3cm90
ZToNCj4gSW1hZ2luZSBhbiBtbWFwKCknZCBmaWxlLiBUd28gdGhyZWFkcyB0b3VjaCB0aGUgc2Ft
ZSBhZGRyZXNzIGF0IHRoZSBzYW1lDQo+IHRpbWUgYW5kIGZhdWx0LiBCb3RoIGFsbG9jYXRlIGEg
cGh5c2ljYWwgcGFnZSBhbmQgcmFjZSB0byBpbnN0YWxsIGEgUFRFDQo+IGZvciB0aGF0IHBhZ2Uu
IE9ubHkgb25lIHdpbGwgd2luIHRoZSByYWNlLiBUaGUgbG9zZXIgZnJlZXMgaXRzIHBhZ2UsIGJ1
dA0KPiBzdGlsbCBjb250aW51ZXMgaGFuZGxpbmcgdGhlIGZhdWx0IGFzIGEgc3VjY2VzcyBhbmQg
cmV0dXJucw0KPiBWTV9GQVVMVF9OT1BBR0UgZnJvbSB0aGUgZmF1bHQgaGFuZGxlci4NCj4gDQo+
IFRoZSBzYW1lIHJhY2UgY2FuIGhhcHBlbiB3aXRoIFNHWC4gQnV0IHRoZXJlJ3MgYSBidWc6IHRo
ZSBsb3NlciBpbiB0aGUNCj4gU0dYIHN0ZWVycyBpbnRvIGEgZmFpbHVyZSBwYXRoLiBUaGUgbG9z
ZXIgRVJFTU9WRSdzIHRoZSB3aW5uZXIncyBFUEMNCj4gcGFnZSwgdGhlbiByZXR1cm5zIFNJR0JV
UywgbGlrZWx5IGtpbGxpbmcgdGhlIGFwcC4NCj4gDQo+IEZpeCB0aGUgU0dYIGxvc2VyJ3MgYmVo
YXZpb3IuIENoZWNrIHdoZXRoZXIgYW5vdGhlciB0aHJlYWQgYWxyZWFkeQ0KPiBhbGxvY2F0ZWQg
dGhlIHBhZ2UgYW5kIGlmIHllcywgcmV0dXJuIHdpdGggVk1fRkFVTFRfTk9QQUdFLg0KPiANClsu
Li5dDQoNCj4gRml4ZXM6IDVhOTBkMmMzZjVlZiAoIng4Ni9zZ3g6IFN1cHBvcnQgYWRkaW5nIG9m
IHBhZ2VzIHRvIGFuIGluaXRpYWxpemVkIGVuY2xhdmUiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZw0KPiBSZXBvcnRlZC1ieTogTWFyY2VsaW5hIEtvxZtjaWVsbmlja2EgPG13a0BpbnZp
c2libGV0aGluZ3NsYWIuY29tPg0KPiBTdWdnZXN0ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5n
QGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRG1pdHJpaSBLdXZhaXNraWkgPGRtaXRyaWku
a3V2YWlza2lpQGludGVsLmNvbT4NCj4gDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5o
dWFuZ0BpbnRlbC5jb20+DQo=
