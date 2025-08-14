Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD89C27876E;
	Thu, 14 Aug 2025 21:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207638; cv=fail; b=EiEgdRERhpx89G9PdUnQ22QtENZa3yL0qmIqJXboVknKSXwTJr3wSrbU1py9xgS/ibCwuGkTGSdz5LHIOft13COjUjMzN+ymZXQPDqjeQzaQ6sLoTiRPyd9lo68loxkVbFIuB4CuQEbpRc6RCNEi9fRR4tetLB9MZpPg/1h82hY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207638; c=relaxed/simple;
	bh=JvB1Nk2tOzhymQnt4+AQjSqiM9HVPOm4BkX2d1aThts=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uq2C5DkQ9Ibo5kuvm67SSUTcSYwrvTztkNuouTzzBAArrlWb9q7Pe6P5TzeCV64qlLBgalOT396WJgb1tWpRxx+W4myQQ2iXnwPCyZteqhSvJd7IjEkmjf/+jhdXILdLay1WP3Q1v4PrIx5OvQCELtz430Vnb1aZGX7siqtbzuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bijnbiSH; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bijnbiSH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755207637; x=1786743637;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JvB1Nk2tOzhymQnt4+AQjSqiM9HVPOm4BkX2d1aThts=;
  b=bijnbiSHSkUkAr6PsOQKIN6sMEdWbPLyFiIswiVj5ZC23gwN2RRFI6gc
   kxbrJFOCDgvLnUEpH8UDUUUX9ptPV4cPw+XjHt2EktV9hcjzoP1DiKldR
   5UVFyPzNEZKLsj+Im77Mx7a2Xl0on6IZiCG/y/kejr86zvcaeRvFiB5hH
   sbVhL2MzTGbC/U5w9Xqb51MBwLixmymerGEhgOIdbw6g40eGajRs23c5+
   E7Jdn3KrUJVyW6EQNQ4odXTcrkM3AxpgAhVvdMll7G+fNTlwDnCuKUvQI
   Mc6Z9soGttmkJgr39eYNHmkWZJ4G30N984IE1xRRbk2UrPiS1MmIADluZ
   A==;
X-CSE-ConnectionGUID: 387In5M/TPiBely1a6mghA==
X-CSE-MsgGUID: nkCiiNVdR5CsSbdywgUbog==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="68990328"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="68990328"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:40:36 -0700
X-CSE-ConnectionGUID: q5iA6ZnYTZaaF8JqIbNI8g==
X-CSE-MsgGUID: eG/1AWHpTvaxT4rOdsflcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="171325619"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:40:37 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:40:35 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:40:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.60)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:40:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HahbHi3Ilzh+755HCJ0u8hO0j0yzNuqrHPSVvVw7qbQKOMQ60twJEp9f4A/FDGj4ZWv0JXnNNluOUSU78D2pswdDv0uklMEo2JFERppT0vqxs0Clc9JRARB06pq/11oyx6pAnL3sFiMWMHJ/XlySA0rzVAKPCNVs1BLsQLAuz2rlmIpYejkLhTnlNwda1+R3cpjdFbFRDKB2uAWJsXgQVNhvt3k5xwHaxC/LfTBxkGdlNAYNgP/dI/sNjcMxxbdwXDUA+MPSs0GbJ4oePpHNkg/S49VzC7MpWMYBjCJu6x4dMwG4vZrS/NthflnYIzxVhhjrj/bVODHhvrirKWURcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JvB1Nk2tOzhymQnt4+AQjSqiM9HVPOm4BkX2d1aThts=;
 b=As2SXgFBJNpWssp4NtqopT/jksEWmnKULecdXnZzivnGGcZf7mpkKJIMulzuiMVnwbttg8PT/jSWNBd1zlVglyP9YdFeZ7Wc/B8m/VkG2G3iCSNEobRfFA3dcQOdXCa1ae0u3sp0INQymO5afCfFl8sRr0iLJGxa2AlrxHoy2lwgYEwTIkoc12ZntKhqEJHxw5mQs5FBD7TiF3bGLeJnp/DpTGnq3qxWp4uigtHVCr6j1xo86Kx02PllAO6EcAQVZDmExg1emmZ6ikULXbEfAJrIPhh5SXDLsjBe/E9n7obEXc1MM1vqTKT5gAKZvBklFdtSdEm/4GoacAPQpzLXFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB4854.namprd11.prod.outlook.com (2603:10b6:510:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Thu, 14 Aug
 2025 21:40:33 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:40:33 +0000
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
Subject: Re: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcDO5TnQHIa6baW0CdldyvXyq8LrRiXVoAgABQ5QA=
Date: Thu, 14 Aug 2025 21:40:33 +0000
Message-ID: <31d0ac3b0b25efde64d502755e7c5f4717fb7f38.camel@intel.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
	 <20250814073640.1507050-6-elena.reshetova@intel.com>
	 <4baa3bd4-cbc3-49b3-b8e6-09a2079c8363@intel.com>
In-Reply-To: <4baa3bd4-cbc3-49b3-b8e6-09a2079c8363@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB4854:EE_
x-ms-office365-filtering-correlation-id: cb395f51-cafa-42f5-4515-08dddb7b32d5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dDd1Q0RqZXBDNnFudzgxWXpUOVdMZHdPbVcxWXExOFNaQ3QzTmpsUVY2b2sv?=
 =?utf-8?B?UXQ3cFpTN2Ztdlk4a3BqWWJQaEFHYVliZURnUWJnMCtJQStIN1RkOXlpNGw1?=
 =?utf-8?B?UkRkK1NLc05RVVZHVC9Sa09PNlNrUmhBaUJwUVRzMVF2SCtqQmxpdzFSME1T?=
 =?utf-8?B?U1lvTndWdmFxeUZDbXZ6OVZxbGoxbTJzaFdocm5vOWpUWkdUa2JhYUE0bUJv?=
 =?utf-8?B?aXR3MTg4a3RFb2tuQ1J4Z1lVWXJHSVlhM25TVWNMeTBHMm1iekpsNTFhdWV4?=
 =?utf-8?B?eTZPTjNsL2s0Vy95YWcxaWRmYnVPOEpOWlB2aUt6cGVUWTErMkQ0aE1DeEt0?=
 =?utf-8?B?Sml5RjJaSlV2WkxlcC9DbS8xdStYQ0hOUW96cWZvUTRFTkYzc3pqbjUxUXZ4?=
 =?utf-8?B?b3I3MjE0K2xYd3ZDNUgyTk1CeXhjMytrbHRvcG9aVnR6UjRWRFBrd1dld1R1?=
 =?utf-8?B?bFZhMk44L1lnS1ZKRWNRVkI3WHlTcDN3bWYzaExmUDZIYnNpU2l0VURzMVYx?=
 =?utf-8?B?S0tCUTFEQUJyUnNXODdjUXJFbFZ4NHh3L2ZDUkF2K1dpWTc0eXFObWhrRzF3?=
 =?utf-8?B?Ym4vWXZ2Sjhrd3FMNXpVNlVNMXB5WVRGMytBbjJiU2hOS1Z0U2xHZFJoRUhu?=
 =?utf-8?B?Z1JjTXlSWFhTZGljRk04RExVczZDK3paNG1pKy82b0ljTlhZalcwYVRycUU4?=
 =?utf-8?B?T2dtcUhTN2R1V2l3V1A1QWFWYzVHV2xGSmpZOHFMS0dQeXlGNVRsOWFBd0pv?=
 =?utf-8?B?Q1A2YVYyUEVuVURGaUlkb0kwZzlha1JHUytNZlhSUkszM21GTHVmc0cwbXNL?=
 =?utf-8?B?dmVoeVdyZE8rQ2tzaWxBVnhlajZmdjh4ancydTdhQUd1RFVOWHprTFFETGND?=
 =?utf-8?B?MW1WVzB5eUZiL0V0cU9EbjVtYXIvaGJVYS9zQ2ZTaFZmTVlXcHBpV24wZ2t4?=
 =?utf-8?B?dXhqeFdDMUd2cys2b24yMWlNeUwzWXJFaFhFeExYYThEVHM5RGF4Q2hJRC80?=
 =?utf-8?B?ekdEUkVBaERkMEdXZk9Td2dUSkFuTzN6ak5hZmRRaG5CemswelltSTNXSHMx?=
 =?utf-8?B?RnBzYWNQUmN5d0ZnVCsveUxnYXgzN0NBK0FiVGd5SnhrUnNISnFwUXlHdXNB?=
 =?utf-8?B?azRIOENSME5zOVpuZ2x3YWhhTFpJdlVOWk9sL0svcWtDZk11V2JlUXdac2Vm?=
 =?utf-8?B?NG1JNlJoU1NYREFDVHl1N0MrUGlKTlZZU0x1cUJFZVNCS0NKNW9zcTRUcWY5?=
 =?utf-8?B?UVcwTHloQUZGNzZ0amt0QmtmMENncElqTzVscmRrNUIxQm5jUmFFd2I4UWNQ?=
 =?utf-8?B?VWU0K2w1YXpidms5T0tFdE14WVhacUJRTjc0bzdxc2JDKzFmUzlNaEhKTE5N?=
 =?utf-8?B?cm93WEpLSTZvNUFEckxtWi9VSmRsN1BkUnpLbDhZaVR5dFZBRFMrbjlkQ3Mz?=
 =?utf-8?B?a2R1SkF6SERIbXp4U2EzU2dFeHhtVHpFMmpIbmVmMnpZajczTFpNWW5XdHdy?=
 =?utf-8?B?d0ptUUVYZjB2R2lFemo5RUVURlQ5dGhtRksvNjhGNFNVdWk1UHpmUUxTbkJ6?=
 =?utf-8?B?WUdFenhTRUphai9PTStsbmRlTmhTbEFwSDhqY0x1U3h0d1B0cEVGS1Q1YWp4?=
 =?utf-8?B?UE9xNWMxbzU4UXJIdjZ5eHNoREdQcndIampuRU1HbHMrNzlUM3JseWs2eDRu?=
 =?utf-8?B?RXRsVXRvUExpS0VYczZvWEVXL05qSThBU0Z5bW1YcENqNFJLdnlWVWlHTlFG?=
 =?utf-8?B?YjlNZEFBeVVOTjd5OGtoZzZwcTNtSUlNdFJrdnJWb2pScmg0KzUzOGdHeXZm?=
 =?utf-8?B?cDR3cE0xK0tHV3RSK0pLL0JnWEtMbjFCcGFqa2RNL1JHd0l6WDdMc1BqYnE4?=
 =?utf-8?B?enZLb2p4WE81bC91MlQ5RE0raVpEeENpU2JlQ2FjVnlPRVdIN2lBMEpnY2dM?=
 =?utf-8?B?bzkreVNmWlBhclhZVEZlbVJWU2UzRFBGWE5sOGNlbFVFK1hBek05UHJRKzFq?=
 =?utf-8?Q?bHEL4ZPSPWd1hm1vHr/3UWhJbxTDFU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0RLWkdBWS9TclQ1dHp2c3lZQ0dEdEl2YmRSQ3NyeStLUWhjeHBvS0daMUVK?=
 =?utf-8?B?QWxITjlZdmlUUHl2ZkV4RzdsRUQ2cW4ybTdjbmJtVmNtbmREdkU4N0tyazVh?=
 =?utf-8?B?UHhmOWc2eTdlU3lIbnlac2RmYTNkVWpsZlluQVVONk84Vzd0ZndmZVRKUDhD?=
 =?utf-8?B?S0tidjVtRFo0TWRWaTZhOWlVem5MbWRvZUdDSm5SSjlSR21tb1BFYmxuQnBQ?=
 =?utf-8?B?Z3BHNiswNG1OUkRSblBCMXd6T28vQjhaT0hrL25DS3RUUzM2a2w0bGJsZFcv?=
 =?utf-8?B?MTBJT05RNDc3NXJZbmpjeGlOKy9uQng1eHhxVjdHVTZVcVZwRFJIT2ljWG1G?=
 =?utf-8?B?OG5VYUlsTzR6WUpEODlCYTRtVkJoOFZEVzZLc1dUMUhmTVZOWjR2blplVTFZ?=
 =?utf-8?B?Wm5XK09oSXZaUUE2a0pLQkZSdHc1UzNqZXVEeXlXWFpwNWJWTFBUY2VYN3Zx?=
 =?utf-8?B?bzRzQTI5cFNaNHNtVDlrSi9CK2FPckNjdzhTV29jNVVQeHVjK083bXlrb0FC?=
 =?utf-8?B?dzY4T1R5VDlLZGJzT3Z1TXB5WWwyNTJ4bHB3ZTVDUmZQQTNpYWROYllQSEsr?=
 =?utf-8?B?YkFUYlVoSjVmOE4yMGc0MEZNOW9ZQjJWMWNYN1AxYmpFUHl6TFZyclRmcDNv?=
 =?utf-8?B?Sll3aG5KL2orek9aWFpwZlBoWHRFTEU4Z3IyYUcyOUEzQXliZ2cyQytjZlpS?=
 =?utf-8?B?OEpxeFhUYS9JU0RxVTEySUxRbnBlVUl2WE1QeU9lNDJlSnNvWnhRZWpSemY4?=
 =?utf-8?B?UXZRUEVFMlU0eDZxdlkxV0NKNW5SUkZMeGVyRVlqUkt6MmlmWVVZaEtrOGll?=
 =?utf-8?B?WEdFcXMySXFHRm9INHZMbVo4VFBuUElkWm1YUkNmVDRrZkRCMU1MUGtiN0tk?=
 =?utf-8?B?cWNsYU5OSnFTUE5iUWpKOG9zbk1RaXNjZU5mUUxFam9aelN5SXliL2ZWQXpX?=
 =?utf-8?B?T2hDZmtqWEdiR3BuT3lUTWNHZmhtd010aWNoS3M1NHJJK0ZGOHZrZ09iTkRh?=
 =?utf-8?B?d1pTQ2RKbkZxaU9hTzIwd21GNzdZVkhUdnQ0UmNCQ3d4L09BaExsR1lqRzk0?=
 =?utf-8?B?ZVdGL1JUNlVmbXp2S1VSZVJOZXZqbU5jelZBcEhoQUZKM09GTzk3Uk9xRlRF?=
 =?utf-8?B?YkwrRUJyV1VvYjNKOS9GRUNMR3Z3SkpVRXpGdi9iUzFFWnpvbkVOWmJJZjdJ?=
 =?utf-8?B?enJMSnVZbnU0UU41MjQ5aWlHWmwvS3J5Q1krM1VaMzdSVVFGZ3lxOEQrVnA4?=
 =?utf-8?B?L0Q3L0JDaitQUDgydEdINEdoYmhJVXdsQWxDakIvL3lIcWN0aHpVUWtiOUdQ?=
 =?utf-8?B?blk0MHF4bEIwSWpDaFI0Z1dDRHN4RzVzRE4rNE5ITTJ0NS83QWJ5TzNTbmFB?=
 =?utf-8?B?NWgrenpmeUlBWkltMUYxeTBSeDc5ZG1TVkZvS0RCVFJ4QlVNR3B6WHBndHI4?=
 =?utf-8?B?N2UySDhqVmY2WVE2UDdubEw4YzQ1OWNSd05CV1hJczJlY0dLcmw3MVUxQ3RF?=
 =?utf-8?B?NU9NSmw4Q1BLQkQ2b0lUYk83SHBlYy83UDc5NkVmbmFtdHFZSmp1WXU5WVRt?=
 =?utf-8?B?ZXVkTVhvT1V2UHB1Rko4a2VneWZWZmxGQzFyUHFIVDM4a2Y1eWhIci9aVEYx?=
 =?utf-8?B?US9xV1A1d0NESUhsZkFKR2diR1ROWFZWV0drdENzSmd6VTg4a2xwS2dxaGVo?=
 =?utf-8?B?UFRmK1J2V3FwTWFydElkd25XV0pkUFZBRmoxOVNlZXZxbDA0T2hhd1BEczVu?=
 =?utf-8?B?MFUzN0p4Z204Nktza3RkMHZsQ1FsOEUyTndRWWgvTTFHSlpRemxvQ1pOWnVM?=
 =?utf-8?B?TGRkVnN4aXpWWVp4N1krNWtBT3V2b1ZFWUM3Q3pBT2N0UUxmMXR3eGZGOWs4?=
 =?utf-8?B?Vml3NExHbWp6UWt3a0FLKzJ0UUNDZUpiUmNNa3FhQU54OWtqdDF6aUErTHUv?=
 =?utf-8?B?L25OeVdOZ2pmZXRJVklnMDF4cFJkWERkYXVhczdObysrNklkRG5MdnBuTXhv?=
 =?utf-8?B?WmV3ZWxQbjBpL0h3amtQUjVtMUJSb0h2ZVRmbjBoZUZwc0lrWktScmRKZmFV?=
 =?utf-8?B?d0J5cTRVVWE5RnptZGhEcTdTbHlmK2hmYVMvcHNSVS9iY2tGYUQzK3FZK1Bl?=
 =?utf-8?Q?nin1hd7TKCJibFL8CMFfaalGm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <095E11B631BF694C9E786F98FDD779F8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb395f51-cafa-42f5-4515-08dddb7b32d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 21:40:33.6299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLzBt3zkVZp+UV3EU3iQ7aZlzGECrd9T9vg+fYL954eebCt8OitAroCAn9RxKiSqZS4fh+X5KDz/fcrRzYwNxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4854
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTE0IGF0IDA5OjUwIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOC8xNC8yNSAwMDozNCwgRWxlbmEgUmVzaGV0b3ZhIHdyb3RlOg0KPiA+ICsvKiBNdXRleCB0
byBlbnN1cmUgbm8gY29uY3VycmVudCBFUEMgYWNjZXNzZXMgZHVyaW5nIEVVUERBVEVTVk4gKi8N
Cj4gPiArc3RhdGljIERFRklORV9NVVRFWChzZ3hfc3ZuX2xvY2spOw0KPiA+ICsNCj4gPiAgaW50
IHNneF9pbmNfdXNhZ2VfY291bnQodm9pZCkNCj4gPiAgew0KPiA+ICsJaW50IHJldDsNCj4gPiAr
DQo+ID4gKwlndWFyZChtdXRleCkoJnNneF9zdm5fbG9jayk7DQo+ID4gKw0KPiA+ICsJaWYgKCFz
Z3hfdXNhZ2VfY291bnQpIHsNCj4gPiArCQlyZXQgPSBzZ3hfdXBkYXRlX3N2bigpOw0KPiA+ICsJ
CWlmIChyZXQpDQo+ID4gKwkJCXJldHVybiByZXQ7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJc2d4
X3VzYWdlX2NvdW50Kys7DQo+ID4gKw0KPiA+ICAJcmV0dXJuIDA7DQo+ID4gIH0NCj4gPiAgDQo+
ID4gIHZvaWQgc2d4X2RlY191c2FnZV9jb3VudCh2b2lkKQ0KPiA+ICB7DQo+ID4gLQlyZXR1cm47
DQo+ID4gKwlzZ3hfdXNhZ2VfY291bnQtLTsNCj4gPiAgfQ0KPiANCj4gSG93IGlzIGEgcGxhaW4g
aW50LS0gc2FmZT8NCj4gDQo+IFdoZXJlJ3MgdGhlIGxvY2tpbmc/DQoNClNvcnJ5IEkgbWlzc2Vk
IHRoaXMgZHVyaW5nIHJldmlldyB0b28uDQo=
