Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C683A9D94;
	Thu, 22 Jan 2026 20:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769115430; cv=fail; b=qL9duX82RWHWWVarzk5jX++Qqdg99XzdIUBObviQnGZB6bIvBzSXz+QD1vOV1OC8czETH3KYVKqLHY5PM+I0Izn/KVOMQO/lYqEG/SAZoML3CUlO5DoHrhEssNLOf+Gq+MBLs+cEiCPqq13swVCJcuqxjiP7ojndqPuOkodPdqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769115430; c=relaxed/simple;
	bh=QTGvwXeG6OvVSbxsML89iWzdeP4cX5ASEzshYND+4gs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E4XETs+bocxEXGNL1mbKB8qnAdZhpoKONImYiEqLbr+MNn/Yj1lFe9Gpw57stH7k5VaWmRAMFL3r9YPSq3v96XjwsNZCTjjn+pcmjYvRFNdFHrNSPftGbg4UEf6WAn7F+PSg+qvhRIm6V5DrC+1cs9uPbXEfALCrdDWpK0pCFJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ccegPzzc; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ccegPzzc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769115426; x=1800651426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QTGvwXeG6OvVSbxsML89iWzdeP4cX5ASEzshYND+4gs=;
  b=ccegPzzcb9uSU12r+ubbI9kvrG5/uZobM6jqlTUt0tUcL2cKTbBuXzzC
   y8o2UYxHkyxbSwzUkxp4o8aaJcrD4CUJZ1TW0vLSAug3J5+62idOOEwAR
   NSh0/2SYF8vmH0oyLUjM12bvOiFdaPSG1Oeb43mOtQdE6tkaZ3b/LU41q
   NfhmkubmU/FJx6Ht3zqoL8aKScTEMa/dhpZkheee2u9thexe3R+NIC1q8
   1aH0PP7UmfPzhtO2Es5+V+KEHmpZZxUuE6RSJUttJRmOBZTUdAkqcZw4X
   wM7VmRU/WlE7/RVoDYhZMpNT31vWDwcwSzzhxHQ66iG8rmpB1niJB+ogO
   A==;
X-CSE-ConnectionGUID: oA3Kqzd0RMuUhky3UqDFMA==
X-CSE-MsgGUID: B8po6VnZQuaUzhZWZqPO1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="70534243"
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="70534243"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 12:57:02 -0800
X-CSE-ConnectionGUID: 3gab4ChGRi+pYq5CzMOVTw==
X-CSE-MsgGUID: diF6+sVtT96kWSULxqbXEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="207092215"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 12:57:00 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 12:56:59 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 22 Jan 2026 12:56:59 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.46) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 12:57:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HEX4myrVlKnTO720vYTsE4SUUhm9DjXyIbTuFu4PfhX+0RZys1JwbEjN+2oSE/pnenXqUwXAPlWc/8kvff0244iWXjL2TeipEfN3JgMwWr9tNA6Ud1NSpnOhJY3XDFc13Y5cy8cCM7a35aZBAl/0yNqgmCEP4xrxnYbB5aqyX0wRSWD/f009zKpx970hbiXtfqITTZ/qRlG2z/KwZtv+9R7PcwM4q8DCvs04Qnhg2HZ/+ZnaWlS6k0h/IDGoSVtbugCJaTF64KMu50luDURLK68szujDyRbCUOzPqfa5i51JwjWmhSzzn+oAV+BtGVIgn+I0+SEEesgp/fNF9+qLtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QTGvwXeG6OvVSbxsML89iWzdeP4cX5ASEzshYND+4gs=;
 b=SS3MsAnnXV0HduIuz59WI7PLTX1oBdcD4y5UH2CEj4+1D0IFqvLBN205jaUuTrX9ij83XLxu3iTUFSeZ6Npc2kU6hwBIbHx2ccYNJREWr5EV52McHgt0d9GwD3QUsVm6vR2g+AHcpj6H6xNjk2WlCAR2lMguSezX5xb+df4lCMG1/GvCq57jROM+Z2iyZxmTxKxYreLoggSZnSyv7SWfpKmMBi/hbKdObP6ZjTn0mE60u9P2XiTrUmudjO6mABJ3aozuUfBzeTj990hy1uT19TeylEMmxSHVbE8nZJ98bvE+ee26mAlEGuEioZDaNtjsYPv2isGZcut3VpFgb++TGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB5155.namprd11.prod.outlook.com (2603:10b6:303:91::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 20:56:57 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 20:56:57 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tianwentong2000@gmail.com" <tianwentong2000@gmail.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Thread-Topic: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Thread-Index: AQHci6Q5tvQw1foINE2mfXMlwjgvW7Veq/4A
Date: Thu, 22 Jan 2026 20:56:56 +0000
Message-ID: <5961c2655b49a7d384140c33d6897e53f89cb5fe.camel@intel.com>
References: <20260122133633.79792-1-tianwentong2000@gmail.com>
In-Reply-To: <20260122133633.79792-1-tianwentong2000@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB5155:EE_
x-ms-office365-filtering-correlation-id: 0ac5aa20-21f3-42d5-8fad-08de59f8c7b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?b080UG5wZXpsNFRLZXhKT0UwcmxQUkJrU3BjTUNsS2FRRStWSGtWamFXalVo?=
 =?utf-8?B?Z3ROOW9RYWkxcnBXcmw0ZXV2Rm9FUlNYZTJBMmNJU1RVNW9FMUV5cGg3cUtq?=
 =?utf-8?B?czB2eVdFeTJGL1Z4NHFMaDlPQUdCNUV1S2hNdVllR0tGKytZdXlPWVAxMjgy?=
 =?utf-8?B?QjlucDFrN21aR2JTNW9KbEUyZGV3Vjk3TnN6ZVV4aW1lRmFRU1F3YnZqbmV6?=
 =?utf-8?B?L0IvTDk3STZJWFdaaktxZExSNDRKMUJLbytJdHJ4TTFQZ0J3WE14MnBtWlU0?=
 =?utf-8?B?NWxJM09oSFpTaFRPdHEvby84ZVFsNkJTTE5MWXpUYi9IaWFPYzJVeTBsa0Jh?=
 =?utf-8?B?aWRLUU5qdmFJUjNzTDgwU2wvd0xGRUp3eGJIbFJscWFCOGN2RDB6TzFtWHpQ?=
 =?utf-8?B?dGc0MFBCSCthZ2hpT1ROS3NBYWE1ekVEQjRvQ3pScnpYeFFOTHIrSGxlRHM5?=
 =?utf-8?B?YWhIVjUzTHVueENWL0c5UXhsQ0xJNXpHNmpmR2ljSklLcUxGRjl5MVMyNlZY?=
 =?utf-8?B?NC91VExIaUtlaTFYOU9sTjZlTHUzUzk0cFlFUVE1Z0J6MGtERTZYWHN0V0RX?=
 =?utf-8?B?Q0JYVm8yenk0dlRqZGpPbDMzaG5xYTBEM3hibEx5OU1TYUVNSlRoUE94SDkw?=
 =?utf-8?B?YUN3R1NLZ1dPdEJoZEsvbU9TYkc5QTRLMjdzek9tbmNma3Q3YjN4dmlxQjZ2?=
 =?utf-8?B?TnRWWFhGenNwdUZtVExoZDVHUk9sMmhnSVkwbFo4c1JoLzFRQWVsNlZTMk9Y?=
 =?utf-8?B?VDEvUTZBMlpESlY3b1dZVmo2dEVnbWpWQTdpcXA0TzFYa2hNTUQzTUJjT2Ix?=
 =?utf-8?B?ZzRCNkNSVTdlZ2VaWGxZWUFWRGFVbFBZbmxBSG53U3B6UnJDOEZpaVRlR3pT?=
 =?utf-8?B?Vy9MVjlXRUgrNHRaV0JWd1RlTVpiRjRPdWRDbk1pbi92dHJRWURhYmpDSUN2?=
 =?utf-8?B?OS9DZ3ZZaG1CaXBKaVBtVHh4UWdmZEpvQk0wTGlJRFJYazJFektxc0xhQm1w?=
 =?utf-8?B?R3doMWxYMHFpd1Ywa2RUVGJUNW9VUXN5T1RkOGN4VWVwUEh4MlVsbEFSTzNJ?=
 =?utf-8?B?aHBaN21ZekRCaGlvVG02VXFNMlpmbHgxd1plSmY0eFM1Qk94Wk56TzJHazVG?=
 =?utf-8?B?MkgvV2NKSHB3TXdERTVINkl2NnYvYnVHRVdKYXVncnU5THVEYW9sSzlUQ1c5?=
 =?utf-8?B?STh5NnhQb0FNYmMwLzRLUVBRT3ExMktLUjU5VHRwVFJxWTIvc0tPN2JLc0Nm?=
 =?utf-8?B?dkE4RjBFWFJBbFB1U29vU3NsTDBIWTZoM3hxbUVIYk1ra296ZDFsWUJYM3Zv?=
 =?utf-8?B?UkFEZTdDOEVzZVpyTHpqRmNNTFg2RHgzd3hESGV1YVhDL3BTTmpXR0dOUHBT?=
 =?utf-8?B?N0Q2Z2cxTE90cjNteUVjWGt5dEpPWkxZNmwwblV2bzM1aHZUYXl6dnp4aGFE?=
 =?utf-8?B?WUNYSFprbHBnUnBTNHV3dlFYT2FGclhKQ2tHNm9CcDA2MUk3WXBRb3drbTBN?=
 =?utf-8?B?RVhGTXFTNm03eVh5ZkY5V0lFazl1NXMydmF3dGhGMkgrd0ZUYXUyajB4RXZN?=
 =?utf-8?B?dlJhWHJlU0VoVWZ6NnQ5WjZPWDdLWFdTU09vQXRoM0tJaVBpS0c1ZkJ0K0kx?=
 =?utf-8?B?TG9vVldiVC9KSzJlaUpwenlaN0J6MFVPTlUxOVBNMVdDdm9ybm1KVmxyb3N0?=
 =?utf-8?B?RVhKeU0wTHJGNDJXN1FTRnlTcW5kNUhHczduOGJ2QlIycUtMK3NDQWdNWWZx?=
 =?utf-8?B?ZkZXd3l0NnlZOVRGeFVyd1FCeGVwSXVoR1g1L1RMYStUV1VoWGNBZExWanhV?=
 =?utf-8?B?Wk1SVjVuNUtHSjRrTzBNNFlEaGhTS0hUNVduazVGbTFYYU5lMWI2ZzRYTXNs?=
 =?utf-8?B?QVVZZXRqamdiNHJkSFNvZ1VwWjZUWEE3KzhFWUVNdXpRR3Z0eVFreTdXVTlZ?=
 =?utf-8?B?MGY4dFM5Tk4yOUtLbHM2MkgydWsvM3YwemNwS2p5eVM1a0szMzFwRnVBc0FW?=
 =?utf-8?B?aGNEVExQb20vekdYVVNPSGNBQlNiOTEzN2hBU3dtM1ZtNlh5aDZCZGRhZktp?=
 =?utf-8?B?QU9kOEVIV0p0MXMwQThMMEQwaE9GeEc4eGhFNWNBeFM1UFN0cVMrWnhPb1JI?=
 =?utf-8?B?MVNUQ3BsRkhRYW4wOHBSVEVZYVpiWlcxL0J1N1R4NzhBTlRCZ3dzQmVkQ1Fm?=
 =?utf-8?Q?96uRz4QfKYLruOa5Tyb0hfU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmdoSXdLSUJwMmN6K28ycnVXNnZYbk5XMnJCbzFnTGFRRXJkdm8wTFEyS0FS?=
 =?utf-8?B?UVdnKzQ1YzUxaDhSYlVPeHE0S0xadHVFSGRGNFZmRGtQNEd3M1krMmw5clB6?=
 =?utf-8?B?MTIyQzhMTm16K0hENzJ4VisxMG1Venp2YzZ2ZC9KYUhyeS9UcTBGVXA3VmFH?=
 =?utf-8?B?VkZRTjJSUEpiT3BCVE4xT2tURk9GR3hWREJLekdaNk4xS2Zhb0M0K0o5eUFH?=
 =?utf-8?B?SE41RkU3Z3lzWlNUTWF2c0loWmM2NzlnM05nTVNqcG5FQmtEZ2d6MkF1VUF4?=
 =?utf-8?B?VEp3M2dJMStKSldRTW9WN1dER2xIRnBwVC9CdWZyVWRhZkJtNjN2djBCQXps?=
 =?utf-8?B?Zk5HTmRCTjZBR3F0SUNyMEc5Vmg2UXc2ajJ6UlFUNkxQTjMxYkI0T0dHNXFE?=
 =?utf-8?B?YWRWUDZFWTl1OWpRdFJ2bDVGeUFwaHlZVGI4TTNTMlV4aEFsT2ZqV3RwdkZt?=
 =?utf-8?B?L1hHZ01zNlhVYis5TnZjSXBmSjUvYVFwUUE5OHlCdU9SKzVZOEYzODlFZ25J?=
 =?utf-8?B?RTE3UGRVcFlEU0ZIUU90MXBFMkM5ZG1sWFo4YXllcGxvbVFuTjh2WXI1Sms0?=
 =?utf-8?B?ekY3NytadUlhOVRjV1hpSXhRMXFKMkxFcVU4aWVxd0preEt6ak1uV255S1py?=
 =?utf-8?B?bndCNUVyVGNVaStPcko0Sk1Fd1RYUmIwT3ZWc2E3ZHBFbjZOYUYwaCtJVHR0?=
 =?utf-8?B?M3hiTTdNa2E1ako3SDhFb01rZWJvY3hOczFlRkVQTi9yZmJWTTc4N015R1Fn?=
 =?utf-8?B?dXpjNHFITVR5Q0VvZGJ3OEpBa2JtbTV6ZW41UmpqeUlnODgzWHFTdS9CMFhx?=
 =?utf-8?B?dGl6eEdVa2xySWlDN1F1SVFITm5vd0dXUzlDalRRcGVKUGE2VHRFNHBRNXg5?=
 =?utf-8?B?TURTNnd5cTU4RG1EZnRjR0t0eXUyNUxjK3FmK0xIVHFaSkIxY3M4d0kwVG1L?=
 =?utf-8?B?M0p3WXkzdjkyQi95UVNtSHpEZDBQYTUwc0poLzFqcHNCNnhSMWZXeWE5VmlE?=
 =?utf-8?B?dlprWHRlYVNDdDdZTmpzNk9jZU1WdUhqUllsb0E3VGlGU1d6WWpoOHdwd2Fk?=
 =?utf-8?B?UTlCYzMvMW1JYmZJUkpZclNQKzE1M0FycDY3d3owQWVaY21DSmducERMWkRk?=
 =?utf-8?B?WVM0cGtNVHRIbjJ5ZmxCMkt5TGJKQ0xsTjYvUW5Md1FpUnArSXo0Tm5GVGtl?=
 =?utf-8?B?ZGJvRS9uMmx6RGx5QzV6Nlo4OUJNMGcyekxEK0sydjEyREt5VjA1VSs1b1ln?=
 =?utf-8?B?bU1JUGUrR1BwY3l5SnJ0QUJYeTRoVHRidFc3UWhFQ3d4WVBXOUhZNzYzbVFs?=
 =?utf-8?B?OFFhZksxUzVaMDQyYU5tbEZFaEJDZE01cGRtRnJxM0M0ZmZmT1B1U093WXVq?=
 =?utf-8?B?Q3BTN1krd0R1Z04yRjhtWFE5OGMrcnBnRDFXSDVXcHliaitJRTRySll6Z0Nz?=
 =?utf-8?B?YUF0d3FMcHJTZ2tBUTBHZ1d2Tm9YM2ZHeVA2eDRBeWFjWEVmZVlaYXJLZStG?=
 =?utf-8?B?VGlMTnZURHppVEg5ZEJBQm1CbVdXN2l5cjY5NVFwTWFwd2JxcjNhZVVlNEVI?=
 =?utf-8?B?dXZ6RlZaNTAreGdLOTFVcHhBcWg5N1NqRlVGM2JPbGxSdTFvQkdVTDVKYm8v?=
 =?utf-8?B?RUJLV1ZKc3JwYjlYVDZxdkw5dUZzeEgvRTVuYUJKVVVtZlk2WHBnTWE3d3hE?=
 =?utf-8?B?c2FNa0J2U2kwS2Z4YkhvTjNtOUlzcVFiVFB6aVRYWVF2K213ZEVCUzFFSmdE?=
 =?utf-8?B?bi9CVFhxRmRGNmIzcHpBTXNxZjF6d3VhY0c2akxaeFR3TVhwSm9MR0JnSFJU?=
 =?utf-8?B?UmxISGc4MUEraU42bHZGR3Fod1crcDVPbFd3RTRlZ1dlVkFMTk9iWTV4NWJ0?=
 =?utf-8?B?YWFBRW84K3JDMmkxV0dBZDBVTmNsNmlqbGFhMS9WWXR1ZGQ5QWJXMWwrR1h2?=
 =?utf-8?B?R3dBN2RGNXUyQkdGelZmQklKU3FTZ3dUK0t5QkRUU3VvUHhnbzdzbGhaRndD?=
 =?utf-8?B?V3pYVkFkMFFuL1pTZmNYeTAyaU0yaTQ0b081WWMwU2lKeHJ0bzRDbDlmTUhx?=
 =?utf-8?B?QWpzUUZHYklWU1FTMjA0Tnp6cEpUNGF1am1neWxPSkttRWF4c3ZQb0pjQVda?=
 =?utf-8?B?dGVWSlZMZTg1T2tZd0V2OGY4S3F5Q1h3ZU1mMnJ1OHM0d2Vhb0lZYmpjWU85?=
 =?utf-8?B?MU94dGJjMUtGWmFRWFFDWFl5VExCL3p1dVBsK29UQXFpZUVwRGoyb1lSNnJq?=
 =?utf-8?B?MTZNUyt5NGJHVWZqU0E1NWZHR2YrR2V0RGpHeitEU0NyamVUMXhSNG0zQnFq?=
 =?utf-8?B?ZUpqT1VzZ0VBR2Jmc3FSNUxibFFkZzdsbFFFL21wUUNTNjZ2WDNBdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BE6274AFBC7434CA713C1A24209DA78@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac5aa20-21f3-42d5-8fad-08de59f8c7b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2026 20:56:56.9659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fG4qlgi7PpT1hR/b55OeK8u0ZiWCwhHNbIkkntwrHpS1GqFXuCzbqDjQCvauYie0UMwURvqXXgeTlC5ty1VghQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5155
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTAxLTIyIGF0IDIxOjM2ICswODAwLCBXZW50b25nIFRpYW4gd3JvdGU6DQo+
IFRoZSB2bV9mbGFnc190IHR5cGUgaXMgdGhlIGRlZGljYXRlZCB0eXBlIGZvciB2aXJ0dWFsIG1l
bW9yeSBmbGFncy4NCj4gQXJjaGl0ZWN0dXJlIGFuZCBkcml2ZXIgY29kZSBzaG91bGQgdXNlIHRo
aXMgdHlwZSBpbnN0ZWFkIG9mIGFzc3VtaW5nDQo+IHZtX2ZsYWdzIGlzIGFuIHVuc2lnbmVkIGxv
bmcsIGFzIHRoZSB1bmRlcmx5aW5nIHR5cGUgbWF5IGNoYW5nZSBpbiB0aGUNCj4gZnV0dXJlLg0K
PiANCj4gVGhpcyBmb2xsb3dzIHRoZSBjbGVhbnVwIGluIGNvbW1pdCBkNzVmYTNjOTQ3NTAgKCJt
bTogdXBkYXRlDQo+IGFyY2hpdGVjdHVyZSBhbmQgZHJpdmVyIGNvZGUgdG8gdXNlIHZtX2ZsYWdz
X3QiKSBieSBjb252ZXJ0aW5nIHRoZQ0KPiByZW1haW5pbmcgdm1fcHJvdF9iaXRzIHVzYWdlIGlu
IFNHWCBjb2RlLiBBbHNvLCB1cGRhdGUgdGhlIHZtX21heF9wcm90X2JpdHMNCj4gdHlwZSBpbiBz
dHJ1Y3Qgc2d4X2VuY2xfcGFnZSB0byB2bV9mbGFnc190IGZvciBjb25zaXN0ZW5jeS4NCj4gDQo+
IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogV2Vu
dG9uZyBUaWFuIDx0aWFud2VudG9uZzIwMDBAZ21haWwuY29tPg0KPiAtLS0NCj4gdjI6DQo+ICAt
IEFsc28gY29udmVydCB0aGUgdHlwZSBvZiB2bV9tYXhfcHJvdF9iaXRzIGluIHN0cnVjdCBzZ3hf
ZW5jbF9wYWdlDQo+ICAgIHRvIHZtX2ZsYWdzX3QsIGFzIHN1Z2dlc3RlZC4NCg0KSG1tIEkgd2Fz
IGFjdHVhbGx5IGp1c3QgcG9pbnRpbmcgb3V0LCBidXQgbm90IHN1Z2dlc3RpbmcsIHNpbmNlIEkg
YW0gbm90DQpzdXJlIChob25lc3RseSkuDQoNCkJhY2sgdG8gdGVjaG5pY2FsOg0KDQpHY2MgZG9j
IHNheXM6DQoNCiAgQSBzdHJ1Y3R1cmUgZmllbGQgZGVjbGFyYXRpb24gd2l0aCBhbiBpbnRlZ2Vy
IHR5cGUgY2FuIHNwZWNpZnkgdGhlIA0KICBudW1iZXIgb2YgYml0cyB0aGUgZmllbGQgc2hvdWxk
IG9jY3VweS4gV2UgY2FsbCB0aGF0IGEgYml0IGZpZWxkLg0KDQpXaXRoIHZtX2ZsYWdzX3QgSSB0
aGluayAidGhlb3JldGljYWxseSIgaXQgY291bGQgc3RvcCBiZWluZyBpbnRlZ2VyIHR5cGUNCnNv
bWVkYXkuICBCdXQgSSBndWVzcyB0aGUgYWR2YW50YWdlIGlzIHdoZW4gc29tZW9uZSBkb2VzIHRo
YXQgdGhhdCBjYW4NCnRyaWdnZXIgYnVpbGQgZXJyb3IgaGVyZSAoc28gdGhhdCB3ZSBjYW4gYmUg
YXdhcmUpIHdoaWNoIHBlcmhhcHMgaXNuJ3QgYQ0KYmFkIHRoaW5nPw0K
