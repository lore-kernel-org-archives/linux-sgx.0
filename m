Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922A42FB98E;
	Thu, 14 Aug 2025 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755172144; cv=fail; b=Wjwdo12paECNjiI1KgllttX7KodYlW6dTMPWNSmF7DCET3VaS5F0y55/IG60F0lfXUDKEwmYQwBpIeRDAM65hJB/GVngxEL+HKtGEgbkn91vg7raO/Z81qDH7+7YItR6JwRiHbiV+J8lsjpLkPfwZ23uxheMAlrTvpPuc8wyqow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755172144; c=relaxed/simple;
	bh=xmNyZ7nlQihgfCgCy2qTftBvnJAX8UXEPoXPp2Tvq84=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dwDeP1tXuG/qgImGr9Dl4X27TSujLRDFtvybcJRXkFRsdZnHfGZ3BCL9kybiNaA+DaBgYFWRHxqeijcPQcA/55JfAL4al+7oYoszIVMnYQgQco9neKc04gSpx0RFu1i6veHotDVM9atkL2OTq14Po9lfOvuA4+70b2Fxmund5M4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GjE8GeOa; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GjE8GeOa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755172143; x=1786708143;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xmNyZ7nlQihgfCgCy2qTftBvnJAX8UXEPoXPp2Tvq84=;
  b=GjE8GeOa6zPEZRXwpIB7Hb+wKeZK21BbZXC/l/RnBAreHuy9VKdo1b50
   Bdgkqfow7R04kczaC7TvVvsQKrRPSbtvyJNEMo5i9k3FC2xvQjKPprfI8
   2nRNGdGZJcBbNmV3DjHgt+ajB8xLNTDWr1b6xBFz79nesCwWcSvyuwkZG
   T0efscRtNisqZkSg/q52XbW6j5TX53mdsdtGKEGr0HduLPJ/0Eo1IMqbM
   SBEbQ/MAYiKVTyb2R/Ki8laAiX5Doo4qynRn9p4tFIDoew71RT4rsp0oe
   CPFTQzIrBbm+rwc4EK9LY3n1NSQ+W3OuRnDctkOicYCRqwp+cdx0DiDqw
   Q==;
X-CSE-ConnectionGUID: 950qZnsbSpKa+vjHKjl6og==
X-CSE-MsgGUID: JjDRJdhmQC2hN3247dVrKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57388379"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="57388379"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 04:49:03 -0700
X-CSE-ConnectionGUID: HsaKKRVlTe2OZuwGpsEhLg==
X-CSE-MsgGUID: 3Uyz7cp3RZCnETSmFQ/wwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="171967052"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 04:49:02 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 04:49:01 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 04:49:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.76)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 04:49:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zDk6B9ViyDSP4EvisarsButxeB+ijY7yOg76aPGCMc4umbQmzyqD+5fPyK2DzWHuOGiKzIurAFClec4C9tIC8c/LBdSYUeT7EepCRkMHt+0zR2SgV8Zu8ljcMUVbVtqJXwVK/8se4UDBihZOgTxGkHep4GuNh2GgxAQ4NaU7ju4t77a9iA7olS7TLPZBvgCYC5BSTJpwwttfsV+5YBlnVHSFcuJjhRBpzQebOaOMQ1llvNK/KO5fRsBZZ7aVzpo2I/H6oUFXXZxMGTunHS7rFcNQptVEvBuFEO4qE60DzOxVd6WPbZvlCzkwkfm4dM+7QSom4fbqcc/kawquffudWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmNyZ7nlQihgfCgCy2qTftBvnJAX8UXEPoXPp2Tvq84=;
 b=c1uxLCarvJuOqYWVN0m22WxTJoUSIZgJp2f3u2p1mB5totfcR73Tl4Az79M5E6HmjRFn3yddq4Mf6a+uvpVECDTmAqVuyyE4m+1QjDtWFkCk4NW5cXmOZTrKBeno1xAzNmed55oCBOcRSAUfSH3W+vV4DJTgQrIsg5i2ENaj+SO1z0UIHmKGwmt/ggGZQT/wwpNEDTrBNjPCp1LzTL+eYmqHAngeZrhpNNZWbicBRpNXSfLTrgag1K8LNfdBEQbHSNuiK819ZUtP9v4+/ZcQZvWoLVC4hl8S10F0dpSikQvwhDNL54gWMC5H/uF33CzaJaRo7W6xA4miUYosxp3v9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 BY1PR11MB8078.namprd11.prod.outlook.com (2603:10b6:a03:52a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.15; Thu, 14 Aug 2025 11:48:58 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 11:48:58 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v14 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v14 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHcDO5KNGBQKN56qk6Tqt+5dMDdJbRh47qAgAAk8eA=
Date: Thu, 14 Aug 2025 11:48:57 +0000
Message-ID: <DM8PR11MB5750E0E7EE14FA87E9C48336E735A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
	 <20250814073640.1507050-5-elena.reshetova@intel.com>
 <a74ede5f4466572e33c92fceb69136b82c042d7e.camel@intel.com>
In-Reply-To: <a74ede5f4466572e33c92fceb69136b82c042d7e.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|BY1PR11MB8078:EE_
x-ms-office365-filtering-correlation-id: 31de9c23-61f9-407f-05ff-08dddb288ddc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|1800799024|7416014|376014|366016|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?OExPZFRsSWlDVzgyOEFPQTJMKytuS25iQktSU0pWMGQ3OWJyMXJzWWF3T1NJ?=
 =?utf-8?B?M2xjMllyMkk3T1k3bXlubFFJeXdNM2xtclJ1ZEVLR1huMU54dXFQYWFoV0k4?=
 =?utf-8?B?Y0ZLOWNRc1kwcjF2WjVwVzhSSEdyeXV1T3VlalhOYWRFWlA3SXBDWEoyZVp0?=
 =?utf-8?B?SUoySkFhYzM3R0tXWEo0NFBjWVgwUzZSb0dya1pDaDYwOE9DSDVBWkNnK3Q2?=
 =?utf-8?B?amxFTUh1V1J0a3pXVmJrUmZVOVN6ZzB6UWR6RlYrY2FsTGRWbm9mZHg3L3Ru?=
 =?utf-8?B?c3FWODB1R1VITW5SWEprNVhoMDB5WVZlcFdobXBqUGxPQWdjN1ZJRktiTUp6?=
 =?utf-8?B?NWlleWJFK1ZoQWRrVTE1YWhvVFM5KytCQmlwTFp6Qk9naEE4VGpOMHFDaCs2?=
 =?utf-8?B?ZzdvYUFXRGZaUUtlbERCb2kwWCsza0tiMmFVaHZrQWwwblRzY283YzRjbWtu?=
 =?utf-8?B?b3NwMjNDb2pGWDFFUkJCaE8vZk91VXVqUnJNOFA4NjRtaXVEUHlheTZuUTE1?=
 =?utf-8?B?VmN1NmlFM3Vkc1lwK2s4MzJUQ3NjYjlZdjRRcDltS2g3enNQWDBQTEFUQ0xQ?=
 =?utf-8?B?aDkzZzl2bC95Qy9IaFFWUjFscUMwcXlIYU1IK01CRmVmT0RqN2tRbmphaVFO?=
 =?utf-8?B?Q0xEeFNlaS9kYXJxTzUveWVEOW96eExlTy9CRHdtQS9mekNZb0dMZDcrN05Q?=
 =?utf-8?B?WG9PMnFKSG9SWHFOVW0rUnR1VGdWZS9aQjZ3aFpldllIM29YZmQ1akVKQlhF?=
 =?utf-8?B?SEo4clBYbEV2V0U0MWhPdlZRVkhuSzJXQyt2NGRRczUrbHBFaHd1RC9WUFY4?=
 =?utf-8?B?eXpzYXdHdWlnYlhrQjgzKzhMdG42eU1Sd2EwRVRNVkZZSDcwUDhRMXFoLy82?=
 =?utf-8?B?S25VVzJzQ1VQeVg5dy9rSUdpOGpxUDdybEplZWYzSEFXQlRzVzZ6bTF6K2cx?=
 =?utf-8?B?ekQyeENmK0pIYTB2S3pFdlRaNDF5ZzdhZkJkVU5rdXFsMk1nQjQvUjFmZzM5?=
 =?utf-8?B?SzhqbEpvTXZLL0MrbTV5S3dlc01WNFEybnlTdUJicEQ2c1BmUC8yWS9UZlRh?=
 =?utf-8?B?bkNqOHJxSHV2SXRiM0JnNFRqWHhuR3N3aERLZ1RXd2lBSVg1NUhobW9hUWVq?=
 =?utf-8?B?UEV3RXdCTStBMWhXQVBJZmJYM2Zqd1BIY0JCR0pIOWZtYW8wS1NxczZVVStI?=
 =?utf-8?B?MDQ2UXo3SG05bWlYTHJSTWJtc1Jkc3pjQWpWd2hldmFCVHhsZUhlQ3kvSUZm?=
 =?utf-8?B?OHorZ0hBSDIzMFh4dEk0SFZrRGJoR3dnNEQ2NWhhV1VyY3FSS2o1NkJhVlpy?=
 =?utf-8?B?NGR3ejRNbUo1a1M5cE1jYlB3OUVBOGlFSnd0b0ZyTUp4aFZNM3ZUMnoxVXZD?=
 =?utf-8?B?Y0hYSWt4bk9ySURFQVBzeThTYTdRR3cwc3FWZTVCbEVLcWVRaWtmNTV2OVhs?=
 =?utf-8?B?MExiTDFGV0xSdXhmMEZuSWE5R05JUUZqcTBsLzlMelpjYUdpRFJKdm13OXpK?=
 =?utf-8?B?RUhNeWpWbmFGWHRvd1V0WkhqZEVuZE9rR0g5bStSUVdzdGEvbzRNRmw3ZTYr?=
 =?utf-8?B?K00zTDRuSW1yNXZjWHhid0lTL1IrNk91SkdDd2V4UXVqSlVEcTZWTGxnenEv?=
 =?utf-8?B?MmlNWjJVOURTYVhldWxHcTYyWXFSeDREU2ZCM2tmWUhuUWlsek9yaHo5UWhv?=
 =?utf-8?B?ZVpoRnk2TXZsTCtYUXViOUsrbU5YN2RCNDJidzlYQXpFRVV0QUZLRmdEaWtV?=
 =?utf-8?B?SHNWZ25LajBjSjZWZXA4WWdKUU4vS1hBOFdlbkRNZ3dFd1hCeDlvcWJJYjRI?=
 =?utf-8?B?Z3N3dHc0RjZRVVVKcG5DN2xjNUxkL2VzOGZNVzNmU2ViVmJxUVNqVk9EMkI2?=
 =?utf-8?B?WVJ6YlpTenE3eXNvMGlUR3FOZy9nTEZ5TnlLZ2xQYk9makRLZG9oRllXeEZr?=
 =?utf-8?B?UXJ4NWJCR0FZaFgrQ2JHa1ludjBHTE02SW5VSkFOR3E5dlF3cHFudTF1QTJy?=
 =?utf-8?Q?vaKNOX667OFgEIEzs/0o/VqHAE4NnE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(376014)(366016)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2hVRGhMMi9aVEJFS2xyelBqdUt3WVRob1VCWUJ5K2lPczIxbzQ5eEEvVUQy?=
 =?utf-8?B?d21sbWl2a1RwL3BLUVBuclZ3KzVuWmNLbXRhYmVLVXdOOGNwbUhaKzFKdG9o?=
 =?utf-8?B?T3pWS3o5dFQwMU5OMmlodHlnZFRCRlM0TFhkNWJVdmxMOHBraWduRmJxL2dV?=
 =?utf-8?B?ckR5WVpJelpEY1BTWVpCTGZaVGovQWxHcDlXZHE0d1NLenJVMmk3UWtRbGxT?=
 =?utf-8?B?RDRrbUVGaFlFUVBiaWViQzRHeWtYRm4zZlVxVVVEVVdpaEZBUHY1am9QaWNh?=
 =?utf-8?B?OVhxQ05RT011VUxITVp4SXJ6Kzk3U3JoclJpcXZOazA1aTZjeU5NSWZ2bldq?=
 =?utf-8?B?L0hVYyt0WEFkWEgyak1JQ2Y0eUlJeXMxU0xIMlg4OGlYdWorMjhpVHg5aERV?=
 =?utf-8?B?TnltM1RSNWdWSWJiY0xZM1NaaEdJV1FwUzhHKy9UQzN6MUlKS1RqWUNtVnFn?=
 =?utf-8?B?U2FkeXRVaXpML0ErS2h2WkFxRFNEaU9rNFVXT1NYK3VCSFZFQlNaaHhRN0dR?=
 =?utf-8?B?ZmdHNjJoZlZYVWI5SXIrTm5aeFJybFhHc3EvOWlPa0hMaW52Z01LZGs2c2tZ?=
 =?utf-8?B?QmQvOVF4UC9qVmNBcjc0TldYUGhyY1FmUlZTM3dZNC9OK2xjZVhvWEFNU3J5?=
 =?utf-8?B?ek52SFRyWEY2cDhXUFd2Njh3eGVQaFhsNjF6Z0dmNkFnQ3lwRlVNRG1TYnFL?=
 =?utf-8?B?bEZYenk1TGwrRTJEQ2FnamZOY28yQUZudjR3M0oxZXNPVUJWMzM3QjYvUHRR?=
 =?utf-8?B?c3FBbHdoYktDVG9rUUhxS21VTTZQOG5xWlRkV0x4RVBBSnpsdTVsNFd2ejhs?=
 =?utf-8?B?eXZDS1BxRk5ZSEF4QjVpeDFldUVaTnhwSXNXaUlZeTN4M0h0ZkpTOW9iY1kw?=
 =?utf-8?B?Z2hBVVZHT1FsWWZpUmFpZ3pBUnM1bllST3VWWXM5bXd0S2Frd0FFSjQwWjFN?=
 =?utf-8?B?V0NzU2VSWVlXcEFBWWlLaUp2ekVRVVBsVDN3WDRGOUc3RzBjWEthd040Tm92?=
 =?utf-8?B?ZlVWcFFkMXptK1hGUGt0L3J4Sy9yNmhSUGtiNzRmK0wvMlYyZnNBT2N2ZFli?=
 =?utf-8?B?S0tYVzA1T1luOWlYc2orbllSa294eUptSk5ya0ZFNkF6Wm1KTkN6a3VjMVZZ?=
 =?utf-8?B?OWFGKzNFRVRoL1NSaHR2SEEyUlQzcWdiM1VLZUdhR1JUWnJOcWNGRWJXOFN1?=
 =?utf-8?B?TUl0RU5xUS83L1VnczRPcjgyTnYvZzdFQ2pweHZMS3JRS3ZBcWJuVEdISzdF?=
 =?utf-8?B?bGJXMGcwT1hWMTZvOVYraU1OUVpOaExPWkx6aXdYNDVhZFFkRWVQRU5NMWQr?=
 =?utf-8?B?czZwTjhhMm1ybUlyK21PZG5RcDRPSEIrdmtBT0lNRFRneHIvOFk5WlNOR2Iz?=
 =?utf-8?B?MkVUZy9iZ3p5ZjRCaFhydXV5WWNNcy9MSEhpRkhSWWhvTFJrRlI3VmU4c3Y1?=
 =?utf-8?B?SS9QaXJJblNSaGpWNTh0b1VMNXlNQmZGVW9FQ2dwZlV4M09PVlp1TWdGdFFp?=
 =?utf-8?B?am9jOHJjTWRoQjZ5MVZhT3JzVVdvS2prUzV0QTI1Mk82UC9Dei9uZHh5MDVi?=
 =?utf-8?B?KzdNYmcraDhhSkZRbFUwZXhKRjlMdWZ1SHZkVHE5Y0pjRFQxT1pQWStDbTQr?=
 =?utf-8?B?ZWFKdElFZ0JkZVI1dkhiQXphZFdmZ2w0SVIxcWJrZDhXa1NkVmVGbkNmamVy?=
 =?utf-8?B?eTk2bFBieUxDNEFGeGxBei9CUkUvYnZ3RWlWTTJmbEZRK2x5ZEFIWW5NQUtC?=
 =?utf-8?B?SUpzWXoyZmo0MGwxZ2VjWVlGOU9yN3d3RDlPNkZuSnlVSG1DSlVxY0pYSmpk?=
 =?utf-8?B?bkE2MjJ6K2p4UkVyL0FWamFNaDlqSTFCM3BwMW5aVmxnbUZyTjZ1R0t4YkMr?=
 =?utf-8?B?b1NMeXcyeDlZcXYzVlYyNDMyeExGTWgzcTB2ejNJRU9PdGNtNEdnRnZEVy9p?=
 =?utf-8?B?NEpIa1NvN2xwL2RkZTNkUmNLWnZ3clZ5TkhTQjd2T3gzSHlSZENGQU1zNFEw?=
 =?utf-8?B?TDlXbUZZRis3UWEwaDJoV09BcGQvRWZVOEpQVk5seTR4SG1pV1BhODF2alBF?=
 =?utf-8?B?UUFTbFZ1RHZsbTRPcDV1MXlYamgzRE1SUmpKQWNQbzk5VmlSYzVYRkVnUjdV?=
 =?utf-8?B?MEladS8zeHpTYkJZRnRDaUpHNkc4NzdCVFJFVEdTaS9FTHE2VFRNQlBVNTRh?=
 =?utf-8?Q?ySLxEOBWka0nqxyCV30XLOoIK8OQwLKZjcRYbjTbU+Cp?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 31de9c23-61f9-407f-05ff-08dddb288ddc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 11:48:58.1361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DX1dI6tG8VGOgN14rvo7jpGlSDA172sdiKIk+cVZYV1GQilDGdkmUDpOVpgzgs+HdM4Jx/ja467giM7xRfCywj88qyRRNSu1ITCnmjN4QPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8078
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCAxNCwgMjAyNSAxMjoz
NiBQTQ0KPiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT47
IEhhbnNlbiwgRGF2ZQ0KPiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPg0KPiBDYzogc2VhbmpjQGdv
b2dsZS5jb207IG1pbmdvQGtlcm5lbC5vcmc7IFNjYXJsYXRhLCBWaW5jZW50IFINCj4gPHZpbmNl
bnQuci5zY2FybGF0YUBpbnRlbC5jb20+OyB4ODZAa2VybmVsLm9yZzsgamFya2tvQGtlcm5lbC5v
cmc7DQo+IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBNYWxsaWNrLCBBc2l0IEsgPGFzaXQuay5tYWxsaWNr
QGludGVsLmNvbT47IEFrdGFzLCBFcmRlbQ0KPiA8ZXJkZW1ha3Rhc0Bnb29nbGUuY29tPjsgQ2Fp
LCBDaG9uZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBCb25kYXJldnNrYSwNCj4gTmF0YWxpaWEgPGJv
bmRhcm5AZ29vZ2xlLmNvbT47IGxpbnV4LXNneEB2Z2VyLmtlcm5lbC5vcmc7IFJheW5vciwgU2Nv
dHQNCj4gPHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjE0
IDQvNV0geDg2L3NneDogSW1wbGVtZW50IEVOQ0xTW0VVUERBVEVTVk5dDQo+IA0KPiBPbiBUaHUs
IDIwMjUtMDgtMTQgYXQgMTA6MzQgKzAzMDAsIFJlc2hldG92YSwgRWxlbmEgd3JvdGU6DQo+ID4g
QWxsIHJ1bm5pbmcgZW5jbGF2ZXMgYW5kIGNyeXB0b2dyYXBoaWMgYXNzZXRzIChzdWNoIGFzIGlu
dGVybmFsIFNHWA0KPiA+IGVuY3J5cHRpb24ga2V5cykgYXJlIGFzc3VtZWQgdG8gYmUgY29tcHJv
bWlzZWQgd2hlbmV2ZXIgYW4gU0dYLXJlbGF0ZWQNCj4gPiBtaWNyb2NvZGUgdXBkYXRlIG9jY3Vy
cy4gVG8gbWl0aWdhdGUgdGhpcyBhc3N1bWVkIGNvbXByb21pc2UgdGhlIG5ldw0KPiA+IHN1cGVy
dmlzb3IgU0dYIGluc3RydWN0aW9uIEVOQ0xTW0VVUERBVEVTVk5dIGNhbiBnZW5lcmF0ZSBmcmVz
aA0KPiA+IGNyeXB0b2dyYXBoaWMgYXNzZXRzLg0KPiA+DQo+ID4gQmVmb3JlIGV4ZWN1dGluZyBF
VVBEQVRFU1ZOLCBhbGwgU0dYIG1lbW9yeSBtdXN0IGJlIG1hcmtlZCBhcyB1bnVzZWQuDQo+IFRo
aXMNCj4gPiByZXF1aXJlbWVudCBlbnN1cmVzIHRoYXQgbm8gcG90ZW50aWFsbHkgY29tcHJvbWlz
ZWQgZW5jbGF2ZSBzdXJ2aXZlcyB0aGUNCj4gPiB1cGRhdGUgYW5kIGFsbG93cyB0aGUgc3lzdGVt
IHRvIHNhZmVseSByZWdlbmVyYXRlIGNyeXB0b2dyYXBoaWMgYXNzZXRzLg0KPiA+DQo+ID4gQWRk
IHRoZSBtZXRob2QgdG8gcGVyZm9ybSBFTkNMU1tFVVBEQVRFU1ZOXS4gSG93ZXZlciwgdW50aWwg
dGhlIGZvbGxvdw0KPiB1cA0KPiA+IHBhdGNoIHRoYXQgd2lyZXMgY2FsbGluZyBzZ3hfdXBkYXRl
X3N2bigpIGZyb20gc2d4X2luY191c2FnZV9jb3VudCgpLCB0aGlzDQo+ID4gY29kZSBpcyBub3Qg
cmVhY2hhYmxlLg0KPiA+DQo+ID4gUmV2aWV3ZWQtYnk6IEphcmtrbyBTYWtraW5lbiA8amFya2tv
QGtlcm5lbC5vcmc+DQo+ID4gU2lnbmVkLW9mZi1ieTogRWxlbmEgUmVzaGV0b3ZhIDxlbGVuYS5y
ZXNoZXRvdmFAaW50ZWwuY29tPg0KPiANCj4gUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1
YW5nQGludGVsLmNvbT4NCj4gDQo+ID4NCj4gPiArICogUmV0dXJuOg0KPiA+ICsgKiAqICUwOgkJ
LSBTdWNjZXNzIG9yIG5vdCBzdXBwb3J0ZWQNCj4gPiArICogKiAlLUVBR0FJTjoJCS0gQ2FuIGJl
IHNhZmVseSByZXRyaWVkLCBmYWlsdXJlIGlzIGR1ZSB0byBsYWNrIG9mDQo+ID4gKyAqICoJCQll
bnRyb3B5IGluIFJORw0KPiANCj4gTml0OiBpZiBhbm90aGVyIHZlcnNpb24gaXMgZXZlciBuZWVk
ZWQsIEkgdGhpbmsgaXQgd291bGQgYmUgYmV0dGVyIHRvIG1ha2UNCj4gdGhlIHRleHQgdmVydGlj
YWwgYWxpZ25lZCB3L28gdGhlIGxlYWRpbmcgJy0nLCBpLmUuLA0KPiANCj4gCSogJS1FQUdBSU46
CS0gQ2FuIGJlIC4uLi4NCj4gCQkJICBlbnRyb3B5IGluIFJORy4NCj4gDQo+IC4uIGluc3RlYWQg
b2YNCj4gDQo+IAkqICUtRUFHQUlOOgktIENhbiBiZSAuLi4uDQo+IAkJCWVudHJvcHkgaW4gUk5H
Lg0KDQpPSywgeWVzLCB0aGlzIGNhbiBiZSBmaXhlZCwgaW5kZWVkLiANCg0KVGhhbmsgeW91IHZl
cnkgbXVjaCBmb3IgeW91ciByZXZpZXdzLCBLYWkhDQoNCg==
