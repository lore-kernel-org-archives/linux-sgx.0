Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5974156B81;
	Tue, 12 Aug 2025 04:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754974595; cv=fail; b=JUr5xREOt741JAMbDOEJfUJhelXUTxrJKvbdyYBNguz3SxYc2ZLSNVyz0rTs33sxh7SU1AF77+1Z61Gkouvqbl0cbsrg/W6y/Ao2dhAqgFBmAiRWjxEbbXgPZrOps7qnCSqwAWKaUaEFoTAOWIFAuDgyFD8IO59ge+fNKlINk2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754974595; c=relaxed/simple;
	bh=MrvR4t/z8yRkLnFbfBS7MUq8Jz1J4qmm6y7RkYG7ISQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mDsw0cP4Q9M2Y8uLnJTaoB+4LFk/QcbFDsryH0z1tRn6mo0PPyzcV8ve4xNxEUm4W3Yi96HLkrBTXcyBLULrpVdEnloRoDzBYAjndEqD7uaM1mbp7NkYONfoKM9yYI9p19f2CnXldvRRTN2E8rrQtync8i1XnPEA/7TfkMNcShU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cd11Z9BC; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cd11Z9BC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754974593; x=1786510593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MrvR4t/z8yRkLnFbfBS7MUq8Jz1J4qmm6y7RkYG7ISQ=;
  b=cd11Z9BCnsJ3e7mMDQS3J/U4b8rnItdCnq/GoAoHNPjwTr/LmgE57ixC
   pDzUVuj1D06ltNYkKRkF9tEHN8uYSIoTaldP0ctuaZMbKnpzcrzfhLj2V
   W51JUuYSXdd3Q/g9umPNvqJsIqDHde+iDNI8TZwC/ML4Pu/DxNMFQl+Xk
   vRqepVMyLa+vKRdn7wi8+/guEJ1mGvkhqKeqN6IRECfiBMCMWt+jWrggY
   iZQlldXrpZ1fGqw3fhr2qYPACNSKQvneBnQ6R5Yq036+/89FhJx/naI6z
   oUFLehXz6D4vuSEhey35YbB8Hs9mtNH+Abheiz4Vptcq2uVuXhe5tM/mD
   w==;
X-CSE-ConnectionGUID: KZ1bUrZJQpmAlMbJmRKLHw==
X-CSE-MsgGUID: 4oS0bgvySP2Hk5tI+vcvFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57106833"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57106833"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 21:56:32 -0700
X-CSE-ConnectionGUID: GJvBx1YTTGiaDQwCNTNdRg==
X-CSE-MsgGUID: tYDIOJHOS9GSD8lLCdiQUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="166892369"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 21:56:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 21:56:31 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 21:56:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.62)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 11 Aug 2025 21:56:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m+BzYMjbTarxtkmxkCs7ZMeP+E3ggKJGe/zKzr4W/fdzsNQ2sEGAROPHEfsg1bylFp43I/Dj1sNkl1b3r224cpIpbvhz+l6lYGWJ0KncCNZt/R+qZAT41dGSeuIvKQXHrj+AAA0acf8D5GQTUOo1M9bfRHxiVulqy898VVYt+y569NbGaS2tO8oPiLTfgnLHjlOvG9XXOx1XfjWAhhM+/bKJIuTcqX1jJ3O7elVuxZJkv7eJxG4JxSymneFSnSQbD6zH4kAAY8hPm5Sy1jAhBgpSlphLgJ3dH58whN1DmPOjuC0TuKScOfXol12x1F2/UsduD0sxu2DqRD76NVEnyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrvR4t/z8yRkLnFbfBS7MUq8Jz1J4qmm6y7RkYG7ISQ=;
 b=Mo6jE1+QSat7VUcVDKOOSswRjPTR1fzz6mTKWqhac8CNA89dJ9GJXGk32m921mwksoD36u0awVzq1dRVXkk+lZTy5MBi2XkeE0u/4xE/CML9sjmJeDEwyw2hyIq6YSA29vCxqFZQiersTAHEG8inEOQ77yEToEBFBWBhaIpGzkOnP6DN3+hrUqc8sr6ezAeetRg5bwmrLlZbkNxQBa7WBIesdGEmvD35gpD303p44AGzL0fKWOo+RoSMHzL9hnoZIx0qaVdFCLsi+Phkgj3KGGvnoKga2iya18LZJ4a9s6iao9tBTQYQSYEJ+OORBXFFksySosOyuwu5EN1AUuErSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 MW3PR11MB4700.namprd11.prod.outlook.com (2603:10b6:303:2d::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.22; Tue, 12 Aug 2025 04:56:28 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9031.012; Tue, 12 Aug 2025
 04:56:28 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"mingo@kernel.org" <mingo@kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v12 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v12 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcCp+L2bMBZ6hkiEmTns/QIMZ96LRdRkGAgAAW53CAAIz8gIAAi3Gw
Date: Tue, 12 Aug 2025 04:56:27 +0000
Message-ID: <DM8PR11MB575052556CC247B621082110E72BA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250811090751.683841-1-elena.reshetova@intel.com>
		 <20250811090751.683841-6-elena.reshetova@intel.com>
	 <74fd32cecdd42cb45d88a96a1dbb6d74cb39594d.camel@intel.com>
	 <DM8PR11MB575066A9AF7D7055CBCF2EC5E728A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <d4005db70a0e3ebcbd25207397dd850a1ff7e22e.camel@intel.com>
In-Reply-To: <d4005db70a0e3ebcbd25207397dd850a1ff7e22e.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|MW3PR11MB4700:EE_
x-ms-office365-filtering-correlation-id: 57260995-67d6-4bcb-f3cd-08ddd95c98c9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aUZnZkpqKytVZlZkTzErcDB2Y0I1VllUQVR0NTIwQ1dLdHJpMnZVRXk5OTVn?=
 =?utf-8?B?UndtbXZzNG5seHo4eGt5aXdvZktFcUhwMEJtejFvM2crNlpqajF0b2FMNkVY?=
 =?utf-8?B?UlBVaHpWb0hxOG5iZ3U5UnRuN0dRajUzVHJSNVpzR3lwREpFOVpOaTFDUjNU?=
 =?utf-8?B?U3BZYWZKNUlFWkQ1bkRCaU1lcFVTYXFyT0dpQ242eHNaNThaUG5zVVl6QTRz?=
 =?utf-8?B?algxY2p6WkZPT0VkVW11NkFpQzBUZjJGQnZHcHJ4NWRNWmFHQmpsdGpBOHU5?=
 =?utf-8?B?dnRncWY2Wi96aGVyOVU5bUNkYnllNThjdXVZTkR5R3ViUE1zcXMxN2kzYjVR?=
 =?utf-8?B?bURxUGNBenQ3b08wQjdtQlR5dmNlQUs2MnJINkRsODRYY1ArVE9KcGlWQmlM?=
 =?utf-8?B?WElCQzVoV0h0bUtyMzdJSDZOK1d3TVBNbzYzNUdjeHZSR2xMZHVDUWx4dzZI?=
 =?utf-8?B?VTI2STNBL1RJTG9nTHRkMGVqcXRJdms1STNPZ3V0WnhhallZNXl3SkpLanor?=
 =?utf-8?B?ZkxpZTY2cmo0dC9kdm5WZnhyNXRFTWw5U004ZUZGeWk1bzdJcDBvU00wK2dr?=
 =?utf-8?B?Vk4wVGYzNXZXVXF1dlhZNVQrWkw4WTVrVGhMaUg0ekVVRUQyQi9pVCt4VHNZ?=
 =?utf-8?B?K3pyRmk5dHlzdE1aLzVoWXdySThUQWxTM0swalVwSHh5SEdCdytzWUFtS0Vr?=
 =?utf-8?B?L1BkZms5ZzFMTU1uZkVnZExwaFMxK2NMM3BnSmZpbTJpM25hUE9DcjNnQ3Nr?=
 =?utf-8?B?VGt6MnpmQ3B0RktIcGp4QVgxS3Nxencva1F5dS9LTXNPT0tuQVJQcjl0d3U2?=
 =?utf-8?B?U3JSNW1SbzNUVTFpeGc1QTYycFNjTE56US96eWhlVjJxRlFwejFOcHhkU005?=
 =?utf-8?B?VUJMZ1d4S2o5YzNQMWtEMk50UDFoM2FhaWJvT01kT1NKM1hmOGVIdnlXSkIr?=
 =?utf-8?B?cS9MeFRMekIySElscEtGSXNQYjFYWXRoSXk1WE1seE1IamppeW03ZjJ5WlZj?=
 =?utf-8?B?V0kybzRwWkp2OVJ2bitHZlRTbEc3ekxabmhMQkV5MUNaV1djQ1VFQUllSFIz?=
 =?utf-8?B?V0x6cmVUcnl6ZGN3Q0l1a1VrM2orcWFDMEx3bjFiaG5yQ1VLMFJiLy9ub2NY?=
 =?utf-8?B?dmlCd0pPaFJsNkF6bFYzRFBJcEZ1enF5OWl6ZUsyc1dPQUlLbnlFTXg5MThD?=
 =?utf-8?B?MWhMeHQvb0hDbXE0dm54V0w5UmplY0IvM2hCdWZKVDhBWjlUK2ZIZUhld1g0?=
 =?utf-8?B?SjRjb09hVmswQVdBR0VUNm5nWDlBZXc3S0V3SzRzdjZtaDRNUzM5eGNVRjll?=
 =?utf-8?B?Zjl1Uy9PL2Z4MUIrdTlFTGxoSmlYVUxsZExuNHQ5MGloSWR4V0pmaWl3RW9z?=
 =?utf-8?B?UUFDeU5qTG04WmxkL25ndll4M0FjOW1jbjREdmxiZ0U0T2FRc2VVQXd4K3ZM?=
 =?utf-8?B?WTU0UWdTUUhpTzdjN01lcEdGWE5XaEpBcWpJeVh3MVdWenB2ZUVranFwWXhT?=
 =?utf-8?B?ZE9RZVlHVjZUNXdDVDRMV1oxVVpsU2hUTmlna0t0RjRWWiswNnZhNThnU3hu?=
 =?utf-8?B?WFpieVNNVkRBYU5SU3lJMlU2U09WRGRuVjU0SlNkZ1VzZFQ1OUxJa3dENzk2?=
 =?utf-8?B?L1llRnVSQ28xdERXTVk3QW56cmdpU0REQWUzWVBZRHIyMTI5TTY2TVYrRzc1?=
 =?utf-8?B?VXlsY2oyVXFadjNvVkJQbjZsOGlIY0lRSml6MlZxTzhQOTNaY2VkNHpPeFMv?=
 =?utf-8?B?RVVBU3Nld3l4VXdVeWxyN1VTZDJ2QmVNdVkxUkRZWlc4ZTh4c2I0dFJNVnhY?=
 =?utf-8?B?SXBOTGN1OHV5dmRTREVUYWRrd25INHlNNkl0N3pjUWcwbTRpL2RpR2RSZ1Jq?=
 =?utf-8?B?RUh4bU5FeEpuSDltaVpNaDNYYWZQN2JNbVZrRGF4RW1VdmN1YmptbWJ1czR0?=
 =?utf-8?B?RDlYdHNIRmgxUklCT0JDVU51WXdlMjFLSktXNHJYc2s4azBMY3o4V0R6d0FQ?=
 =?utf-8?Q?Gy/F3xerPsbqqw/O8s0DF9dKUjiKJo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHhleW1ZUUM5ckRuKzZBNlhSVnBDdVZlUzRaZms3SUozVUJzY3l5ZTFFREkr?=
 =?utf-8?B?c3lCYmMyMFVzU0E3ZVRvY1hwQWhQSDdJblE2KzRBT2dISlFWSGhUZEdZQ2p4?=
 =?utf-8?B?NGFHVXE4NS96cG9PWUJNUWxLcU5BQTZVNGNKWkpDNy9aWFdQdExoRVp6ZFZI?=
 =?utf-8?B?UXFXbFFFUzg4WWg3ZWVTeFZTZ1NiTU9NTTNRR2hqWldTbG16SDZLSUVES2Nx?=
 =?utf-8?B?b0xWTkJkbHlGa2dtM2h2SWdWZ1o0VmtJbXliOGE2SWQ2b2xRVTdLQ0dOY0hV?=
 =?utf-8?B?ckNhSmNQcTZBaW5RQ1luQjZMaW5MaGROay9uTXVUQ29FcjIvT3FVUEdFWE0z?=
 =?utf-8?B?SityYUNvNlZNVXRaVytXdVBzU2w3Z2tGZjMveUxYT1RaQ0c5Y0FOYlhKZkd2?=
 =?utf-8?B?Y1BKamhLWndFdWgzTmIwSkdlSEo5SnNKUG9MMWlRTndYM3BtQS9NUG9uLzFq?=
 =?utf-8?B?ai9SVk5CTFZNMWJNUHBSOTZobFo0NVhjUGs2ZU93Q3dxUUFzaDI1OHBxYm1F?=
 =?utf-8?B?c1Ewa3VZdCtHajd0ZTV6QzN3YlFKRDBjSm5oVmVXZUs3dy9JTW5Ma3ROZDJT?=
 =?utf-8?B?RVpDc2t3ZDduOEVRRzZtZ0JERVFlbDNSa1BOYTJ2WW9NL3ZHMTJOdEZuZ2p2?=
 =?utf-8?B?MWp3TG1oWlNoUTNvSlZlMnRlaHByL2E4MGt1OG9UUmVQS251ZVRQZGdZQUJU?=
 =?utf-8?B?aTlnUlM1c3ZNRG1wVFZBbUJ2SVdhbnMrVFJwSGE3a3lzSGJCL0hBc0YxQ1BE?=
 =?utf-8?B?c011RVoxaWhEZjVaYkg1YjNTWFJqNThNMGV2OHp5YTNtQk4xeTQ0M1M0ZFd0?=
 =?utf-8?B?M2NjSVk2V2JMVzUzdVBua2dPcDdEdm1MTUovS09HNlhjVVNWN1dvOFlkRDZG?=
 =?utf-8?B?NHlhVzc4aFFHSjBXUUlSZEFkU3NlRFphRkdFUXVJd3ZqdWdtYWZmWGhhNjVp?=
 =?utf-8?B?cmVzZ1VtNG94czlxQ0FjRENXaGd0YWJuNmc3YjV2akh3dlpPWTZFTVlYaC9R?=
 =?utf-8?B?bTdvQjZtUkxpRFZCbnJ4Y0NoTUZCS2swdkd2ODJGSmN4TlNFK29aN3dQd2Vm?=
 =?utf-8?B?NzVLSUZVdkpsamlEYXlpUFJOZXdyRUk4VGZSMklnUDJPeVFJdDNTTFlQVVYx?=
 =?utf-8?B?S3ArdmpyelRVUjBBMzkxZ2taeGdkdGRUWmdsZFFsWGJ5cjE5aHJIa29VVlgx?=
 =?utf-8?B?ZVJuS1JYNFdNaiswL1FLS2Jlck5EVEdGYnBaS3plY2ZnOG9vZENnN0s4Ukdn?=
 =?utf-8?B?SUg4amNxSytHVkF6c0U3czE2bHNjQUVuakxqQS9NTFl1RXdUSmlCTGE5dzRE?=
 =?utf-8?B?M0J0bkVINlJlMktUV0QvTVZneW9DU0RVSUJha1I2ZUFHeDJYZkloandNeHh5?=
 =?utf-8?B?NStJNURpemVjZ2xDc2c2cEIwM0ZwYXFWTC9nY2pjMitKazluQ0QrM1EwdFBL?=
 =?utf-8?B?KzNOL2ttY0RreHdNMUw2aHc0c3g3dElWd25Ma0QvUHdSV0ovMTRZSVBkMnNw?=
 =?utf-8?B?bDcyN2cxdWpxZXBQRzljQklJZFAxMTl5REFFa0d2eWNuNzF6cVdra3VtY0Ey?=
 =?utf-8?B?Yy8yOUZjVk81R0tkL3NpZ3E1YXRxRmJ1VmFDdHZ1Zm9XZVNrQjV0c3JkSDRo?=
 =?utf-8?B?L1ordy9sR2VjamIvUkxwWnVEV0VpRWhjOXdjcnM5d0F2Ni9ucDk2bDlLR0lk?=
 =?utf-8?B?VnN5aHZiWkxNV0Fmay9CVlhvUHhTR0hRZ1NHRkFzRjA1VkFVdC9OK0JMbG9Y?=
 =?utf-8?B?SVJpeXd6WEIvYVlMZjRGdnk4WURzbWo4Wk1NUkJKWDFNSFBKSmdsbHZZMTds?=
 =?utf-8?B?alphZEVTc2xucHQ2TTFzZFJpTGc2Z0pFek5OblFDc0NCTlhoNDBwNjlkbmhN?=
 =?utf-8?B?aWZudEFhRzBSdmNGY1RGeHlPU1FSRVJjMFZJeVBYRlcvazlFRmtoelFPUGJP?=
 =?utf-8?B?ckhxdTNBVTdYVlRjTnhMTldhOWFuYzVsOElUVXZvNUFIczJTQVRpWXNuOXpF?=
 =?utf-8?B?THN6T28rRDFLYzBNNm5iWnkvcFBiQVlJbWNxN1lFT1VoNm10VXk0Wk1BR1Ux?=
 =?utf-8?B?Z0pzN2FKdjB4UFluSWtqMGhsQ0NrUi8wUW5FZFBaZlBKa1BDS1RYQW9iWWh1?=
 =?utf-8?B?OERPNVMzeS9vYTJ3dU01bHU3VjJOaktmclZicU5rTjU5VHE2cHZ1K0QwMGFI?=
 =?utf-8?Q?Rtz177UUsucIi4HMlb28DRnY1yJjDtgu6z9/ZgGSBt/N?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 57260995-67d6-4bcb-f3cd-08ddd95c98c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 04:56:27.9477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dh3N9Qfs2DGFHPWlnWCsfGIocsK4/2Grp6x9aTotJnDGudWjDrGNgoPfpHUyF2FIzPE4LfTkwQnym/1QgXCX98BYWDSCk7DAEvteATnR8fk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4700
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBBdWd1c3QgMTEsIDIwMjUgMTE6Mzcg
UE0NCj4gVG86IFJlc2hldG92YSwgRWxlbmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+OyBI
YW5zZW4sIERhdmUNCj4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4NCj4gQ2M6IGxpbnV4LXNneEB2
Z2VyLmtlcm5lbC5vcmc7IG1pbmdvQGtlcm5lbC5vcmc7IFNjYXJsYXRhLCBWaW5jZW50IFINCj4g
PHZpbmNlbnQuci5zY2FybGF0YUBpbnRlbC5jb20+OyB4ODZAa2VybmVsLm9yZzsgamFya2tvQGtl
cm5lbC5vcmc7DQo+IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBNYWxsaWNrLCBBc2l0IEsgPGFzaXQuay5t
YWxsaWNrQGludGVsLmNvbT47IEFrdGFzLCBFcmRlbQ0KPiA8ZXJkZW1ha3Rhc0Bnb29nbGUuY29t
PjsgQ2FpLCBDaG9uZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBCb25kYXJldnNrYSwNCj4gTmF0YWxp
aWEgPGJvbmRhcm5AZ29vZ2xlLmNvbT47IHNlYW5qY0Bnb29nbGUuY29tOyBSYXlub3IsIFNjb3R0
DQo+IDxzY290dC5yYXlub3JAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxMiA1
LzVdIHg4Ni9zZ3g6IEVuYWJsZSBhdXRvbWF0aWMgU1ZOIHVwZGF0ZXMgZm9yIFNHWA0KPiBlbmNs
YXZlcw0KPiANCj4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+ICsvKiBNdXRleCB0byBlbnN1cmUgbm8g
Y29uY3VycmVudCBFUEMgYWNjZXNzZXMgZHVyaW5nIEVVUERBVEVTVk4gKi8NCj4gPiA+ID4gK3N0
YXRpYyBERUZJTkVfTVVURVgoc2d4X3N2bl9sb2NrKTsNCj4gPiA+ID4gKw0KPiA+ID4gPiAgaW50
IHNneF9pbmNfdXNhZ2VfY291bnQodm9pZCkNCj4gPiA+ID4gIHsNCj4gPiA+ID4gKwlndWFyZCht
dXRleCkoJnNneF9zdm5fbG9jayk7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlpZiAoc2d4X3VzYWdl
X2NvdW50KysgPT0gMCkNCj4gPiA+ID4gKwkJcmV0dXJuIHNneF91cGRhdGVfc3ZuKCk7DQo+ID4g
PiA+ICsNCj4gPiA+DQo+ID4gPiBIbW0uLiBzb3JyeSBmb3Igbm90IG5vdGljaW5nIHRoaXMgYmVm
b3JlLi4gQnV0IEkgdGhpbmsgd2UgbWlnaHQgaGF2ZSBhDQo+ID4gPiBwcm9ibGVtIGhlcmUgc2lu
Y2UgdGhlIHNneF91c2FnZV9jb3VudCBpcyBpbmNyZWFzZWQgcmVnYXJkbGVzcyBvZiB0aGUNCj4g
PiA+IHJlc3VsdCBvZiBzZ3hfdXBkYXRlX3N2bigpLg0KPiA+ID4NCj4gPiA+IElmIHNneF91cGRh
dGVfc3ZuKCkgZmFpbHMsIGl0IG1ha2VzIHNneF9pbmNfdXNhZ2VfY291bnQoKSByZXR1cm4gZXJy
b3INCj4gPiA+IHRvbywgc28gc2d4X3t2ZXBjX31vcGVuKCkgd2lsbCBmYWlsIGFuZCByZXR1cm4g
aW1tZWRpYXRlbHkgdy9vIGNhbGxpbmcNCj4gPiA+IHNneF9kZWNfdXNhZ2VfY291bnQoKS4NCj4g
PiA+DQo+ID4gPiBCdXQgdGhlIHNneF91c2FnZV9jb3VudCBoYXMgYmVlbiBpbmNyZWFzZWQuDQo+
ID4gPg0KPiA+ID4gQUZBSUNUIHdoZW4gc2d4X3t2ZXBjX31fb3BlbigpIGZhaWxzLCB0aGUgc2d4
X3t2ZXBjX31yZWxlYXNlKCkgaXMgbm90DQo+ID4gPiBjYWxsZWQsIHNvIHNneF9kZWNfdXNhZ2Vf
Y291bnQoKSBpcyBuZXZlciBjYWxsZWQgYW5kIHNneF91c2FnZV9jb3VudA0KPiA+ID4gcmVtYWlu
cyBpbmNyZWFzZWQuDQo+ID4gPg0KPiA+ID4gU28gd2hlbiBzZ3hfe3ZlcGNffW9wZW4oKSBjYWxs
cyBzZ3hfaW5jX3VzYWdlX2NvdW50KCkgYWdhaW4sIGl0IHdpbGwgc2tpcA0KPiA+ID4gY2FsbGlu
ZyBzZ3hfdXBkYXRlX3N2bigpLCBhbmQgYWxsb3cgZW5jbGF2ZS92RVBDIHRvIGJlIGNyZWF0ZWQN
Cj4gPiA+IHN1Y2Nlc3NmdWxseSwgd2hpY2gganVzdCBkZWZlYXRzIHRoZSBwdXJwb3NlLg0KPiA+
ID4NCj4gPiA+IFNvIGlmIEkgYW0gbm90IG1pc3NpbmcgYW55dGhpbmcsIEkgdGhpbmsgd2Ugc2hv
dWxkIG9ubHkgaW5jcmVhc2UgdGhlIGNvdW50DQo+ID4gPiB3aGVuIHNneF91cGRhdGVfc3ZuKCkg
cmV0dXJucyBzdWNjZXNzPw0KPiA+DQo+ID4gWWVzLCB5b3UgYXJlIHJpZ2h0LCB0aGFua3MgZm9y
IGNhdGNoaW5nIHRoaXMhIEluIHBhc3QgdGhlIGF0b21pYyB2ZXJzaW9uIG9mDQo+ID4gdGhpcyBw
YXRjaCBkaWQgZXhhY3RseSwgYnV0IGFmdGVyIEkgd2VudCBpbnRvIHRoaXMgc2ltcGxpZmllZCB2
ZXJzaW9uIG9mIGNvdW50aW5nLA0KPiA+IHRoaXMgYW5nbGUgZ290IGJyb2tlbi4NCj4gPiBXaWxs
IGZpeC4NCj4gDQo+IEJ0dywgSSBub3RpY2VkIHRoaXMgd2hlbiBJIHdhcyBsb29raW5nIGF0Og0K
PiANCj4gCVdBUk4oc2d4X3VzYWdlX2NvdW50ICE9IDEsICIuLi4iKTsNCj4gDQo+IGluIHBhdGNo
IDQgYW5kIHdvbmRlcmluZyB3aHkgaXQncyBub3QgIiE9IDAiLg0KPiANCj4gUGxlYXNlIGRvbid0
IGZvcmdldCB0byB1cGRhdGUgdGhhdCB3aGVuIG5lZWRlZC4NCg0KWWVzLCBvZiBjb3Vyc2UuIA0K
