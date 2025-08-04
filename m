Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD23B15539A;
	Mon,  4 Aug 2025 07:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754291911; cv=fail; b=Cmg3NVJqWzQZ92uZtna0dy/3AlKuINls7LfHpkbOdYjj6xu8I4ssI283cZLe0I3v5bQOZ9VADaRRc5U57gy294KMwLKO6zA1DR6hjm2osvm5bXkgVVvbPO/nQAA5qujjjSerCiG2f/hjj1547cPJ3RzAu3uSvT9kwlD9JFm0OI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754291911; c=relaxed/simple;
	bh=YJFqDJzjPEcoSf80tjiOov7DgiaSrg+yln+8cr/NYyI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OI4dmghmQ54LSVh03SKHlbbRWGyssTpUIec3phw06+UStTKBIE0vGuDCrXDPrEs1p1je9Ugsyirq0R/ANofMHr7g2rhpoNjZaNHusiw8yNZMV8cwDgLWbdbfFRv8KYaTsfSOX5FMUH5UVMAEWmSwPg4GzrIk4lE1XWmChw1j7NU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WrIc9ooI; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WrIc9ooI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754291910; x=1785827910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YJFqDJzjPEcoSf80tjiOov7DgiaSrg+yln+8cr/NYyI=;
  b=WrIc9ooIuSXWOk1RUHTZbTvLEEAwe8g4PZZMEA0man09StJGiJezxuU4
   PTgRotz05/qAc1A+8+G6TZvPGbjj7Z1PRSlerK4LBw2LMFLDHyCkEAPSs
   JCnP3EffNKJvoEeEngtMK4HKJyZtPVtQwq0Si6ndiR/mj86AgSMlUOrvo
   6APVs6nRzAzHhJrPOgPPp0IH8gCIySQ24x1yjCgKMy5Anwm20E1/FHUlw
   h+b56BeRSsnUKCsMUdsGBCh+my0KLDda7qlMAeT8KW5vK1MyEgQGYhqoD
   mjxDpniPap2Bggd5cuUNFUJhkly5Qh0EbtBsCeqMyptxQSAJPffyQvHUN
   w==;
X-CSE-ConnectionGUID: jpdKrO90TmO6oBnzVrIqYQ==
X-CSE-MsgGUID: VtzfXzu/RIqQDHE/r7Qgpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="67121305"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="67121305"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 00:18:24 -0700
X-CSE-ConnectionGUID: lj9W1tKCRs+MGVnCPQAWJA==
X-CSE-MsgGUID: L5OWqnqmSBaSwu9cCQhX9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="187784835"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 00:18:21 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 00:18:20 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 4 Aug 2025 00:18:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.69) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 00:18:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQKxw/di3sIlOkUclV0flD+gKTy/aMCih0IDdlGWF5qkeBonZzn4mxQnO+wMHwOJR3tlursu7ojJALlKgnwdhIXwBxVPzmem+X+yu6Td6rSga8NFprofVgYvE1P3Ff1qhMXT9mUZ45vi3HRVdObZAjvN3WD2v7Ryt7mqLoQOv5s/DyFLedLCBgamPUAwTFrExA1wOm2u0ukadKM/MWJEdM9JLvKy+kz4DWrVw1UA2EbkADqnQAF5zme+GA4A9gPcUZ1SZQ/TL9vc6zEZ4EzvBnxOvP3sexyZysQj4RJtLJaiE7Mcj2Wg9pJyuwAJ50iIuwbSdlFluMf4WPYEM9iwKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJFqDJzjPEcoSf80tjiOov7DgiaSrg+yln+8cr/NYyI=;
 b=SZsp+tx1rBnyeLlvxrlVUX+eqOAZd/NUk/pckrzJbUpW0++OCRtGrBzxoUmQy/P/9zrshP4VgohWOHBK3DkXpFNpaSVSCay/OPWwWMGFGuToxc9/IeyD6RiiCxIn1fQkcELrgZAglLSuv5+B77l0LPcjRcUhW0DIYhDlHosXwqDJtMpoSY95wAOoD/d+nZJebwc8UFXMpmPDxZgyiiztW4buFdLhw+rWTMp2c6gA5OGUp7xHVck2pqf9rMK8n7d9mUcUWZy+9IUVbvqA71Xiq9H7C8kG6l/lYL1wz/uz7FqiJ00wt+IbS9vXwKoJgK5l4c2YHgftC4325XaGq4k8iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SJ0PR11MB5070.namprd11.prod.outlook.com (2603:10b6:a03:2d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 07:18:17 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 07:18:16 +0000
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
Subject: RE: [PATCH v10 2/6] x86/sgx: Introduce functions to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v10 2/6] x86/sgx: Introduce functions to count the
 sgx_(vepc_)open()
Thread-Index: AQHcAtctcEmNrNd9Z0GWxTUgcyrES7ROAa+AgAQYTUA=
Date: Mon, 4 Aug 2025 07:18:16 +0000
Message-ID: <DM8PR11MB57509CBF5603A9A0EEE5E01BE723A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250801112619.1117549-1-elena.reshetova@intel.com>
 <20250801112619.1117549-3-elena.reshetova@intel.com>
 <6e8e933e-aa00-44c9-91f2-b50b96d6c604@intel.com>
In-Reply-To: <6e8e933e-aa00-44c9-91f2-b50b96d6c604@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SJ0PR11MB5070:EE_
x-ms-office365-filtering-correlation-id: aa3ad481-8836-4512-ff1d-08ddd3271529
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RENpWFBFcUNVWmFVV0ZtTURJS1lEQm9tTmRJdUtVWjlQaVVCQ2RvK0pyT3lG?=
 =?utf-8?B?RTdseXgzMy9JRXRNdmE2ZTJYZFo1Q3lBcUE0LzJLcnNLQXlXUDgzU0lMSmxj?=
 =?utf-8?B?aDNIVDBUWnUrZ1RadWhEb3FxdzFyQkFYOHRQOHRHZ1hFUURQRDhFbEF6VEVG?=
 =?utf-8?B?ZHhTbXJ3by9yMTNwb2lzSC9vY1Q0YkxGbUdTK2l6RkYwY3BlcGdqckkzNjRp?=
 =?utf-8?B?MGlTdkZwNXdKZTJDZXo5ZCtzSUhnMEcvbG1rYnYydGxhWHdUaVVPOEIrazBR?=
 =?utf-8?B?WGxSaklzS0paNElOTTNGdHF4NERPc0JjdWRlRURhSkF1aTZMOEZWT0Rtamlp?=
 =?utf-8?B?Q2E0MWZmbG1QbWF5Q1VQdnMydjM1ai8vNWFVZzg2SmpBUkRkSE8zU3duazky?=
 =?utf-8?B?MjNUUG1peGxvSTk2UFBBeW1GZ0hWemQvUitvL0R6dnE4OWhFaTFySytDWlVh?=
 =?utf-8?B?V0Jja0Zmc0wrckY3UVZHbWRNaWZ1b00zbGRBcGpmV1lEc21xc2pRT0xmcGtP?=
 =?utf-8?B?eFpwQ1FvdXVmTDRUSGxLUzVxTFBpWGpHelhMQ2tHVW5iaEd1a0pacWVTSXl0?=
 =?utf-8?B?bGptVzBCTHBaNXQwNUZDU2ZlTUZxcnVGMFlOSDZmcDBBWnNhVFVPSWRkYW5q?=
 =?utf-8?B?ditKZkRISVRrWDd2WFZ4dWdibEs1clZTNEx0aWFJOTM0em9ZOFlVN2Rnb1A4?=
 =?utf-8?B?NDhXbVYxSy8ydDA0dS9pNUFzVW8rcHo4d0dkaXZEdEhGYUZRMDdEamRUUGs4?=
 =?utf-8?B?RVhPQTZkQ1RwT3Q3Ni9hV0JCcGpTbWtBTmdlUnFjdVkzVFdaMERaWG1WOVZ1?=
 =?utf-8?B?SVJrZzJFVkYxM1NkNjdlNGc3VVlsdEhzdGNRZ0YyNVVHSm5TbUFnZTB4Qkcr?=
 =?utf-8?B?enVyNnFBSEpXOGExMjgxanlHM0FuUTJ2ZnNaNVlsMjhCNURTb2xOUGRBaE1L?=
 =?utf-8?B?SlhmUE8rWVlGcmhUbTZJeWt3d3dOcllLNDNrSTBSaHhWT0sxRGlyeDh6U1VR?=
 =?utf-8?B?dUFmbE45Q0pTd21FNTRIVVMwQnd0WE92bEgxWmVjbEF3NktCbDJmdjN0YjIy?=
 =?utf-8?B?ejNEOEo1cDZYdlRtaUJvYmJCNWlwOWdvUmxTUTNVb1J0VzhZZE9MS2g5eE03?=
 =?utf-8?B?MlI4bGhnQTR3MHNGMGI1LzZNdTI2NEcwODEyVGtiTWNORTZNS2JoeGN2bzA0?=
 =?utf-8?B?UEpsRWVqdURnOFU5V2swcXJBLzg5enNLNmFPMWg3R2x4RUMwUmpmOU1hN3p2?=
 =?utf-8?B?Ry9ybzd5TzJGNmpZL3VzaWo5djJYWWdCcWxFRXc2SVVqbS9ueWhWVEtaMzdZ?=
 =?utf-8?B?cUluZ3BTWmorVXRpWFl0SDZFOXo2LzhXTXFTdjBsZDBtZVY3ZW1MTVZUMVlI?=
 =?utf-8?B?MVk0YThRa1VGWDZ2cHg5OWI1b0YyVFhQajNuU0UrbFhUZmpUaFdPNC9HZnVN?=
 =?utf-8?B?ejRkQ2g0YkUydUFsQzVCZ1RkbC9aL25nWm9BQ1NEaitkTnJCWStFT2pYcWw5?=
 =?utf-8?B?UkZKM0Z6SlhXZTg2YWxtWTZBMkd6YzgwRUpTTEd3Rm9Zc29CNnFqekZCaEFo?=
 =?utf-8?B?UXFnYlpZK0VVS3RXYjB1WEVIb0M0L3Fud3hoNXowSFZHbXdmSWVkQzJSbUhM?=
 =?utf-8?B?OTcxNm9nQkY4aVgxTkxoM0M5LzIyODRzTEpzcm1kL1hsdmNXNTJFWllhbEps?=
 =?utf-8?B?N2FUbFduSExkcm1LQUNlUVUwaTdQcHhYb08vSkN3a0krbzZ5Q3lkZGhNWnpV?=
 =?utf-8?B?elErTlkzblZYTkFOTlJ5S0VhdTJkcXlNdTZUT21OTTU3aG5MZUtsYUd1WHBL?=
 =?utf-8?B?UXZWSXdRMDA3RUxKeTJFVEE5dFRaMHB4eFNNUkdhVGx4VVMxWGU1ZWx0MWpK?=
 =?utf-8?B?UFZhVDJSQ1NsM1NWbDZZWFcwSS9xVERXc1Z3aVU4N2hTcFlLcmFHMHQ1OWdi?=
 =?utf-8?B?TXZVc1RNK1JtUnBLNkNSRVVRK2ptUzJmR2VJV0EzRUY0SkVWZEpwRFc2Uml4?=
 =?utf-8?Q?yXCE29rxBkU2taQ47JZ5PVt9nupKxk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHZ4YTZKNy95N3NsVEt5OGcrNGZsVFdBa1QwbEo2b3c2dmlhNS9ZT3R3NzBL?=
 =?utf-8?B?Wm5DMWRoaXd0cmlRL25JNVdKNWZJbXhBR1QrZVJDSGxRWjRJUGdBRVluejkv?=
 =?utf-8?B?T21Fb3VTNnFsYmJUc3hSMnUzZTlLZDErRFYwS2Y2RUtDUGk3ZkRiemNONlBE?=
 =?utf-8?B?RnZKNTB1LytVUFh6aG54Znk1RVd1em5sbjVYdGRtUVEwRFllclNmTXRvb2Rm?=
 =?utf-8?B?M254amxpY05IVFlxNXhzNHpWNy9lYTFtdUpBcTJIMGJFVjBjelJPaWRvZ2xs?=
 =?utf-8?B?aWg3QnZnc3VFNXZyRmVuWlA0M0EyalhhbHJrTU1TbjhFSTMzUlVacnlidGdy?=
 =?utf-8?B?d2FqNXhlcUVQWjZSTENkS1Q5OGxBL1VLbWRVTG40eHliZGQ5NlFZajZlaTBn?=
 =?utf-8?B?T0VHQTQyQ2haemlJOFJoN2VDOVloOWpRMDhXcWh6R285cE16Q0dITnNETS9p?=
 =?utf-8?B?ZllnSDIrRGtXYW9jMm9oRUtINUlLMW9KSU5HbTA4QmtDR1Y5TzQvcHp2aHJC?=
 =?utf-8?B?Q0IrQko2bVhMeDB1ZnNaM2RNcm5mVUVjZlhJOXJkWjZHU295Z2hTWi9saWtE?=
 =?utf-8?B?aUpPUHBCbjYydVJGUy9XK2UzNEJEbFRQZDcxSFl0dndjblVkcDc0dWVHSmlN?=
 =?utf-8?B?R2JpKzRCaElvSHhsTWFmeHVldnlxVjNaV0hYWGRaM0R0cExMYklNWHB5YjZP?=
 =?utf-8?B?REprZlQ3SEZnU1VEUjFISnR5dk8xRzFLWVIwbzdJQWFCVkVZeEZIT2E5aG9K?=
 =?utf-8?B?N3VxWktucXBpY29RWXA3TTN1R0MzL1JMTTQ5ejBqTEkvV0pIV1kwTVZOYVg5?=
 =?utf-8?B?aEhLKzBZaVFkc1ZUQ1QwR3dNSEw0VEUvWnA3aE5YNGUzaEZNSlhIZkxPZU05?=
 =?utf-8?B?dFd6ZU9nNmplMDNIR2I0aHVsakxtS1pXN3hGb3B3WGJ6dDRHODBaQ01rS01D?=
 =?utf-8?B?T3RVbFV5Z1FTWnJyUEtPWHYwck8rTzN6ODRFRktoREVDZUtnTEFuR3dackZW?=
 =?utf-8?B?NGw3Rjc0dXIrV2lOajFiU2tXZjhJUTNDQ0U3RUM1QWcrdzNIVDJsTGFlRFZE?=
 =?utf-8?B?dFE3UTNySE9Sb1BFNXhwQkhhMVdsWFNMQjA0RUhKTkJxeGU0RVJCMVJqRDhX?=
 =?utf-8?B?MlJtSVRoUXlGcm9nejUrTmJZMXJrbm9MSE5FdWZqaUxoMkE3NWRSUW5oK3ZN?=
 =?utf-8?B?bU9XeW5ianpGa1k0anVmSVNZc1ZDRllmS21KN0haVkZZY0E1d2FEQVlmY0tv?=
 =?utf-8?B?RWpvdU1VbnZNbFhQRC9aRDdteW1OTkZEVC9WcUJQUmlYekNRVmYzT28yT2M2?=
 =?utf-8?B?MThVSFFiL3NBVGxHcWZZWW5XajUxcEdOVEpZSnkwT2hMb0l5SGtOaWtnUHBn?=
 =?utf-8?B?dXBRSTNhaXlJREVQMUtwblFCK2psMDZnYmo0TGhMRVVaeGNOVnNHVnA2WkM1?=
 =?utf-8?B?dzJCZDhZWXJnam91clNaYTk4Vk05VEp4a2R6Vk5wSVBuVmJVZkZid3owWm4z?=
 =?utf-8?B?dW9Eak9ZTVZtK2d6OTdCcVpDaUxhWmQ2ZGZTaDZyWS9VYTZ0S3dZbmRzb2xz?=
 =?utf-8?B?cDBYV2YzQzFjVFBUeEJPdjJ1K1NHNjc1RjlTRHJHSWJDSUFRMjljQnRyQ0wy?=
 =?utf-8?B?ZFJtaGpLUVJUeVBDU0RJMG5qZHJwY01ON0hzRGo3d3hSV2pPOHNzRHlnKzN1?=
 =?utf-8?B?akRqZi8zTzBqVVAxaWFzbnUyakJHcUdza2tGNllWTS84a3d3ZFo2WjZmQlRT?=
 =?utf-8?B?eUFzTWlrY0RCMFArVDVSWjJpNERXM2JVMXI4QTdaa1gzcS85MTJ2cWt0NHlt?=
 =?utf-8?B?TzN4OFFDSHF6ZWZOdURWM0xjQ3VpaVdqZHdaYTR0RXZheURyUjhYdUlUTUVx?=
 =?utf-8?B?czl6RS93N0lsL2FLYTRPajZydWQ2ZDU3TEJ5VGtzNzJteFpwYU55L2ZYQlFi?=
 =?utf-8?B?c1dhcUZnckxCNTBmT0JDZVRqM3ZSV0lLbW9MSnVnZGZiSEtVV29PVmU0ZG1h?=
 =?utf-8?B?cWpJbVRtZTJ6Y1NxZFVzMU8zTFFQOGhrUUZWZmdQYW9KaXVYV21LYThFbzkz?=
 =?utf-8?B?b2ExdnlpMUdtUmZ5Y0ZTbS9EK0g5eUxMcTNQTEhLMkRJQmFjL0dDLzRTSDc2?=
 =?utf-8?B?QnZNWCtpaWpEVjF4azlqQ0xPMzBPaUE3L0lnMk9WcEI0aFlyaFFpRUU4cVhy?=
 =?utf-8?B?OUE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3ad481-8836-4512-ff1d-08ddd3271529
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2025 07:18:16.8350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +0kuAeonMM2qJQM6gcACBWNkbdljaW7nwcfOl3sVCFHBbFZzUp4ItX1bGenOMdEB5g9V52lwsGaU0v9vsw8/kUOhMZ4hudIA19sGZwqph3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5070
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGFuc2VuLCBEYXZlIDxk
YXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDEsIDIwMjUgNzo0
NSBQTQ0KPiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4N
Cj4gQ2M6IGphcmtrb0BrZXJuZWwub3JnOyBzZWFuamNAZ29vZ2xlLmNvbTsgSHVhbmcsIEthaQ0K
PiA8a2FpLmh1YW5nQGludGVsLmNvbT47IG1pbmdvQGtlcm5lbC5vcmc7IGxpbnV4LXNneEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyB4ODZAa2VybmVs
Lm9yZzsgTWFsbGljaywgQXNpdCBLDQo+IDxhc2l0LmsubWFsbGlja0BpbnRlbC5jb20+OyBTY2Fy
bGF0YSwgVmluY2VudCBSIDx2aW5jZW50LnIuc2NhcmxhdGFAaW50ZWwuY29tPjsNCj4gQ2FpLCBD
aG9uZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBBa3RhcywgRXJkZW0gPGVyZGVtYWt0YXNAZ29vZ2xl
LmNvbT47DQo+IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBCb25k
YXJldnNrYSwgTmF0YWxpaWENCj4gPGJvbmRhcm5AZ29vZ2xlLmNvbT47IFJheW5vciwgU2NvdHQg
PHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEwIDIvNl0g
eDg2L3NneDogSW50cm9kdWNlIGZ1bmN0aW9ucyB0byBjb3VudCB0aGUNCj4gc2d4Xyh2ZXBjXylv
cGVuKCkNCj4gDQo+IE9uIDgvMS8yNSAwNDoyNSwgRWxlbmEgUmVzaGV0b3ZhIHdyb3RlOg0KPiA+
IE5vdGU6IHRoZSBzZ3hfaW5jX3VzYWdlX2NvdW50IHByb3RvdHlwZSBpcyBkZWZpbmVkIHRvIHJl
dHVybg0KPiA+IGludCBmb3IgdGhlIGNsZWFubGluZXNzIG9mIHRoZSBmb2xsb3ctdXAgcGF0Y2hl
cy4gV2hlbiB0aGUNCj4gPiBFVVBEQVRFU1ZOIFNHWCBpbnN0cnVjdGlvbiB3aWxsIGJlIGVuYWJs
ZWQgaW4gdGhlIGZvbGxvdy11cCBwYXRjaCwNCj4gPiB0aGUgc2d4X2luY191c2FnZV9jb3VudCB3
aWxsIHN0YXJ0IHRvIHJldHVybiBpbnQuDQo+IA0KPiBQbGVhc2UgdXNlIHBhcmVudGhlc2lzIGZv
ciBmdW5jdGlvbl9uYW1lcygpLg0KDQpTdXJlLCB3aWxsIGZpeC4gDQoNCj4gDQo+IFNlY29uZCwg
c2d4X2luY191c2FnZV9jb3VudCgpIF9hbHJlYWR5XyByZXR1cm5zICdpbnQnLiBOb3cuIEluIHRo
aXMgcGF0Y2guDQo+IA0KPiBTbyBJJ20gY29uZnVzZWQgd2hhdCB0aGlzIGlzIHRyeWluZyB0byBz
YXkuDQo+IA0KPiBJcyB0aGlzIHRyeWluZyB0byBzYXkgdGhhdCBzZ3hfaW5jX3VzYWdlX2NvdW50
KCkgYWx3YXlzIHJldHVybnMgc3VjY2Vzcw0KPiAoMCkgZm9yIG5vdywgYnV0IHRoZSBmdXR1cmUg
aW1wbGVtZW50YXRpb24gY2FuIGZhaWw/ICpUaGF0J3MqIHdoeSBpdA0KPiBuZWVkcyB0byBoYXZl
IGFuICdpbnQnIHJldHVybiB0eXBlLg0KDQpZZXMsIEkgd2lsbCByZXBocmFzZSB0aGlzIGJldHRl
ci4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
