Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F0D274FDE;
	Mon, 19 May 2025 11:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654047; cv=fail; b=kKjBeNw0nZ49tNtFjboO6ZOHpNbAofLi1SvfoukBFp//4YFALTkypBfIJm3DL2jgJVz/M5uGJ9rrk7Ei6fIrojDGZtcBTI3kqtsMkDGgEBsSRnAigmgkHuZbvU+ZTbNR9KQy0heUbGAkN8360pGREA8rSXrMCgdXGOfInOM8l9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654047; c=relaxed/simple;
	bh=Dkoo/h7Ubw6BDKOtxJil1z9+pJ1Mkv1hzPy/4gsDPxI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J/KDIRhVcE30LluDUlJ1OWh+Vy3ezjD57cE0ZQSrjDwADMZFzZ0hMEWYUn6v2wQckd7fCqWxxJzEVqUAnfRAFYgFpvVjvPaTwoIqYWoOSs/E+LMnz+exTEc1yYOIR3odUpxxranM3690ZV6vxR8IR5FNiyJiVyiFOzknqtKQyBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DqiDR5qx; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqiDR5qx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747654045; x=1779190045;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Dkoo/h7Ubw6BDKOtxJil1z9+pJ1Mkv1hzPy/4gsDPxI=;
  b=DqiDR5qxqS6hniR0K/mvK8Z81G1cIBAdD3FItxBQvQGDJkTIGCO6khpx
   WJHbnwAAHDx9EEFS+GSE5E6t4SCb+QrnOC46h+XWNzvo5VoksBuioMijg
   4oYS1hHBUBatuSR0+Mivp0IEL/d6q/izpqoV9eCiDUzM6Q6GgMyunQgbu
   zJgEeCvVPXoxlYCq7lxTn/c4LkS3OdXGQckmOxb9l2Sllwcy46wsx++y6
   x34RMBoXTR2t84iROK4rPyZ5vy5L82jOKHpxABgIff8YvfHNQkHhAxis9
   eSkZj+P8Aru3u0iMQfKk/b9TnLe72FICTjDlV3+RjLbwJB3S/X3AxdMrg
   A==;
X-CSE-ConnectionGUID: tSvDNkHdTfmqaKsmGBW1TQ==
X-CSE-MsgGUID: erWmOeNVS1asQVsC0yFWKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="67105230"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="67105230"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:27:24 -0700
X-CSE-ConnectionGUID: ysAil2k2T2iWHSIkKn84Qg==
X-CSE-MsgGUID: PlyKk4pSQ1KzTBvlBQNI7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="144106767"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:27:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 04:27:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 04:27:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 04:27:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QULSicuu5iUG2/3vAupHDi8aKdVmPOZQ4ogVe+K4m4y6M91hAPEFH6r/p1MNBkwVjv3csd0QSRZgCkHcBQDdIFnfsIPEBgfOkT8RNviKPpyffnO2abUQ+YwEr6IQ2Gr9mbUZqXmZs0ng+/OcKtdMB24wbaG1bipobYYhDnUVShXfn1GDBQDY4Ns6PUJSON/FwcEmPlcHHSpCQF4UPMBtedWvoX2xHNTbYAThh0GRd86Qhc+U94Rq6FVFDxz9yTcA7FhoqBcuJmgirDnT+uoyF+fsk5h0wy6xgIBG+mZQ3THeZGUsFzBjeB7I2jAs2P6dIE5rKIXKo1I5VxqJjjW7Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dkoo/h7Ubw6BDKOtxJil1z9+pJ1Mkv1hzPy/4gsDPxI=;
 b=rw1/cZ+VxvEh/8HviGOKGoe2qhw/tJk8/zbohJ0zwNisnQz5xRtaGRPHU5ZjViZKMzE3cPNF06I1uvE4zEoxhipjhT7gdKucWGN28LcZHvttdB9m0Zagl9YSHdvjIK9d+9U/sVJ3ovWg6MI7jEB8x8AVXxgDhbjX4hhlEX/w2qHLrMUozE7okB+RVVc7NVAW3ztE0H20oXvVf9FAZs1uCltUTBk9d1bE9cqWo74H95UXaPrFJdljpYvDINdEOB6LrWDZ5Ips8EN34lctuMDyj8qYH/5IBS/tynkIN3xz/7B1oqWANU/7HTELBOiSg/UPpeehsqSMme5HbXUk0MefIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH8PR11MB6801.namprd11.prod.outlook.com (2603:10b6:510:1c9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Mon, 19 May 2025 11:27:07 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 11:27:07 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v5 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v5 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHbyI9qooAzhUPou02sbUcJOGJbyLPZlwOAgAA4QBA=
Date: Mon, 19 May 2025 11:27:07 +0000
Message-ID: <DM8PR11MB57504A6B41329214262E16E2E79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-6-elena.reshetova@intel.com>
 <aCrlFfl2lAzzHOA8@gmail.com>
In-Reply-To: <aCrlFfl2lAzzHOA8@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH8PR11MB6801:EE_
x-ms-office365-filtering-correlation-id: e3c65859-8d4e-481f-d72c-08dd96c816df
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?azlkTnNvT3AzcFM2bkpEUk00TmhDWXZCbnNBV1VuYTJldzBDc01TaStPbENJ?=
 =?utf-8?B?S3ZkN2FPdkkvK3Vyc2NibmJiUHJrUDY2ZVlSeE1uU3YzTndyTXRXY1U0bEw0?=
 =?utf-8?B?T2lEUVZTRFh5YnNsREN2ZEp6blQrcEhGb0lZVUtXVXBwRW9JMnd2UXdRNytC?=
 =?utf-8?B?d1RiWFdZRzZLR0ZaSzlEM2NQSVk0Qm5YS2IwQ2xUUWwzenFCUFdBSzEralhq?=
 =?utf-8?B?NCtiL0hGMDdKRU9EeHpvajJ1M2FnVTJaSjRET1FVQ3Y0QlRGNzV5S051dTR1?=
 =?utf-8?B?TnNBQmg0bUp3d2hTaVBiY1lsa2pHL2k3R05yV2FIQlBOQnd6Ukw0OFlWaTVU?=
 =?utf-8?B?TTQ0TVNNbWkwZWJrTm9KSWYxS2lNSkxGbHlhbkZxMnJ1c1RCdklnYnlMSVJ3?=
 =?utf-8?B?MWhwbVhxSGVSR1gzZVlGMU5tNmZxZVpCQU4vQzBPMVlLbThQUWNPRlczNFFh?=
 =?utf-8?B?cDYzdjVSd1FMRStSY3JDN3NEV21uK3JKcFh1c1h1OFBhcUFMb1FJRWdOR2Vx?=
 =?utf-8?B?aW5BZGlJSkFzcmtGMkpGSDBORHVUVlJqY1RrUHVWUEJlckZqd1JWdWI4QUdm?=
 =?utf-8?B?a1htOElOajk2TXU0OHF1VWZYQ1orNVZRRG1Pb2xPYjV0eWVuTHdSQXR3WmlK?=
 =?utf-8?B?d1hia1pQQWdsUnhHNnN3MDdtbXBhK2ZJUGxXNGdkOHdSdnp6cWdqMTBwZTI3?=
 =?utf-8?B?MTJZbnFzcnd6U0pVQkFVREIzVjlqaXR4ZTBNQmJTdGhNZUs4Q0I1TitZS21h?=
 =?utf-8?B?K0JVNE5lbzE2RUdYSFlYN0RZTWwrQVpaQmZOUjdpQkpPV1Z5QWtiWFZCVDA3?=
 =?utf-8?B?MnVjb09QSzFIWS9FYjNuMTd1a1NweTR0OVFGNDYxYTdoekc0TlRmTDFHQzVj?=
 =?utf-8?B?MWJleVBnQjFDeDJtUGhYTnEyZEZNQWVWd3dvWWwwUnU1TVhocmcvK3VIWjNs?=
 =?utf-8?B?aUg2NHFBZ2hBM3BOUEdSbjRWamZSbHRKTWtWcmU3K0szQTNsUVVWR2tiZWpZ?=
 =?utf-8?B?SDI0Q3NNcXNiUGVGVG5TV0FobHB6UWdCSGNiT3RIYmRhWk9wOHU0QWpXWUo5?=
 =?utf-8?B?Skc0VmkzSm5qbHhPdzVpN3B6UHBwbXlvWWJpeFE1OTQyb1VPUWFLWW1PeW00?=
 =?utf-8?B?S3dreUJVNHk1L1plOUgrTjVYUUFTN05FS1hJaFBibnlORGkxYVI2YUwxZk1N?=
 =?utf-8?B?YTY4RExzNFZ6QkRZVllvR21hMjN0MDl6N08xcDZXSlFwYjdTK0tqY09SdVky?=
 =?utf-8?B?Y3g3NExOZ1M3aENFWEFTYi9WNjRiTlFXNE9abG4zNkliUjNCMlZwSkhUZGYx?=
 =?utf-8?B?bmJTc0VBbGFVZGE3YlZ0bElaOWg0R3VyN0pEL1YwYzMxeTcrQjRvT3dYY2My?=
 =?utf-8?B?bjNUdU5ackUzdUE1YnZ5SFRGbE9GaEVHRitiMGpzaVg1OTYyRnUxdWswTzdG?=
 =?utf-8?B?K0dXZkNaOFpXZ0drVEgwS25peERhY1dWYmorLzMyODk4Y0hmeVRoOExIVmk5?=
 =?utf-8?B?M0owMDhTRTZYTFBuUS9GWEE5VWNPamFoV01hVjBNZnVxakJCVXlKUENBVHhB?=
 =?utf-8?B?VzNuY0NYbi9idUR0eDExVmtKNWdSR1B2L0EvU2k5TU9WbXlIMUNITUNmTWdp?=
 =?utf-8?B?SE0wNXhWQzZrb1Y4TzdpQllqaUpaMnFURzlzdzduSGhMclJaTFRmcm9weEVB?=
 =?utf-8?B?bXVYbXF4ZE9WQ0VScjN1aUNvTHk0bWVzU0gyRDRwYms0azVFdTFaYmJEbkRK?=
 =?utf-8?B?ZGxuSmpVM2xOdXZLSXFLVUNzYWdOcFo0dTA5aXhwSVhvT08wcDlKZE9WcnRw?=
 =?utf-8?B?SmdTTWg0ZGQxT2N4eE9tQ0haa0trU2FHaTNNMFRFWnFaMG1zemVGeUU3NW9O?=
 =?utf-8?B?KzJTakhMQTFISkZFV1FNRFlTQVVqZ2o0ZVBoYkxOeHFGQ3BCazY1ODRSa0xr?=
 =?utf-8?B?RDcrejI5Nlhid3duRyt4dm1YOFFaSEtzNEJZSVlwdW1qS2N2ZWdRTDVVb0VH?=
 =?utf-8?B?Y3ZQZlJvSWFnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDllZjhFN25xRndsbzZoNWJjVU8wUTFiMlhGZnVGSzYybFMrUW91Tms5YytC?=
 =?utf-8?B?bThJNmhCNEwrMDlYYkdkaVB3WXpFblhjdmIwakNjbjJiYnlFeENqRTYrWFBt?=
 =?utf-8?B?MFV1ZyszMnVaUzg1VzFYTzd2Um5VcmlBRWZzTy9YeUVINm5Ha2NUdnZoVnlv?=
 =?utf-8?B?cEh3YS9CL2FlcWVtYzhPSFlNbWJSN3ArSDVZWllsMnZSdnAwalRJVDFWY0wy?=
 =?utf-8?B?K2ZaUjBYRytyZjVuZ1lLSHlERG5mZzJNNjdYRVhKL2hUUUVnOHQyVWwzcEVx?=
 =?utf-8?B?QytKQWhjV1hPSWhUeTA4cnBsdFJrZnZLWGxUTTl5djdvano0amtFd2FVc1N5?=
 =?utf-8?B?ZHNHUzh0L1gyZnRYK2J4T2h4SEp1WHlpUXp4alIyMGNGaS9oS0NhV2tGVGRB?=
 =?utf-8?B?SDg0TTdyYVY4bFllMHZod3h4Nk51andXdzM4Sy9QL0hVaE1ZditDeDF6dk9B?=
 =?utf-8?B?R0R4eWF5c1FHanFycWVjeXNRQU16cXFDQ1lTRDN1bHgyREp1TWgrUmZaWFE3?=
 =?utf-8?B?TExoRURKcy9YZ0NGTkhCWWd1aTJ4TlJoL3NnQlN6VFBkOVN0My83QnphS2FT?=
 =?utf-8?B?SWRSMTNoZXVvVy9lUS9mSHNzQ1BjS0hEcGhPaWcydFpzZUErK1Q3OGFaYi8y?=
 =?utf-8?B?M2ZIWFYzYkxmV1MzeTZhUkkvbUh3YU8rNDNlcWdESTFXTGcrL0Zod3hUQktt?=
 =?utf-8?B?RFVNbG9CU2YraWpsZmVTaDgxVlJjYjVUM2hwMkZHRlpZZXJHUy9BUmxwZ1V4?=
 =?utf-8?B?c05VRStMUWRCN2Q5NFNHbG01bGtiM0pmaWM2MGY5VGh2bnFXN1JGWDY1cmRj?=
 =?utf-8?B?eGJPNnJOamZKeVhUOGV6OWRQQ00wVDVOalJPdVFJMVJwRmxTd2phQ295Q0VP?=
 =?utf-8?B?Q3VLZUk2UHo2bzNaTVhyK215ZEc4b0dtdzQ2UzJPaUZQdWJac0x0K053SlUz?=
 =?utf-8?B?MFBJYlBuR3NySituRFRCUEpaS2R1d2loeFpkQTNEdzhXREVqdUNrZWpobzdV?=
 =?utf-8?B?MTRSdmFMbTVpRmpBaVBlOUVEMEU0eXlOcGllblUySFpYcTd4Q1E3dGg1VUFY?=
 =?utf-8?B?UU1WWFZQL0R6U1plSHl4UVFrVG5scXRFcFVkSjd2Z1UrTGd4ZS95S2gvRDFE?=
 =?utf-8?B?WHZicmcrY2RiZXFjOXJMVXA4VitjcjZ4dk1Nbm1qeWtITnUwYk41R05mb1pJ?=
 =?utf-8?B?UEFrOXR3aUs2bS9tMEEvQ0Roc1Zoa3dLNFRNSkxMVXhqRVlrZHp6UnpQMCtR?=
 =?utf-8?B?bFYza2pZaXVVbExGSWhpMTllYlNucVpzU3pGSzBXeEViYjh5TkJCbFJmL2Q3?=
 =?utf-8?B?enlKcCtSV1lLV3cxL2NvSFdldWV5aWVYSG9TZnBrUFNYNjZXMWRsa3BvUktV?=
 =?utf-8?B?eWZCNjl3NEFlczdMcmNUUTZ1ZThHaWVpTlIyUGJzYkRkUWt0anp3V1diV2hr?=
 =?utf-8?B?cFZhVFZLVnVEVHFTekdSNFg1RlovSEttRlJTTDIyKzRhOGxXbGJ5dVNNMkJG?=
 =?utf-8?B?VzNPTGI4aUttcHZoRFF6WENIamY1bm9RckIwckEyc0pLb1lRM1lrbDM0NzJp?=
 =?utf-8?B?NllmTmQxUFJybU5qRmlzYWI4Uy9SUDBrdEtJUVpCNTQrd2p2a3NMekM2cE9o?=
 =?utf-8?B?OHFWMlJ6MmltOFFxNktXZDhwZDhXWWtCaFlvRmF2Vzl2R1dkVmZkSEZLQkhT?=
 =?utf-8?B?QWUvM1d2K3ZIYUI3RWtPRkthVU1renlqZldmeE9kQzRZT0RUTUhRWkJrdEZs?=
 =?utf-8?B?QWxWS3FlbFdDa1F6dWZSRGhaV0Q2RlFxR09BQUNOZVoxOUhEL3F0cTM3K2pX?=
 =?utf-8?B?NXFBa1d0aHJxaSs1ZHd3cjhxSlR1YkwzQkJkanc5NFVIaWxJT2ZoTmpuZ3VO?=
 =?utf-8?B?WkJ5NE53eVRSOFpWRSs3S1k2UGllcWJ3cXR0RXZ3a3R2ZWtucFpyOWJjdXRi?=
 =?utf-8?B?UWRVYlFMYXBIaHAvQWJPWTdQcTJKK1ZCQzhRS1loK2RxdEowYzN6K0x3a2NY?=
 =?utf-8?B?c1dPTmdRSGhGek5FbzJmbDN6Vm4yaDZxek1scGFwQ0wzdm9QNlY4OFY2cG1s?=
 =?utf-8?B?TitGaUR4UnBEcU95aExaaFZ0TE10L3RhN2pKTWtKV0JLb1ZaSHllaXduN1hl?=
 =?utf-8?B?MU5ERStzdHdtQzVsWmpHU3lUY0w0UUJqek5zSWRCRXg2V2dVeDFNSzVYUUZG?=
 =?utf-8?Q?W17W5F1PQPRsm3MA7w8XsHteZEx5tzrq5450D3Fizr00?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c65859-8d4e-481f-d72c-08dd96c816df
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 11:27:07.7819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3jRMCj2OEahVsdQdJ1g+UD6vXhFuFxvdOrmSBWawCBECiry9bmLp6pOm7EO9F8IZpolZO1b25BMsUIbBCNZX59hliWUAknBkiCjCneFHmjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6801
X-OriginatorOrg: intel.com

IA0KPiAqIEVsZW5hIFJlc2hldG92YSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4gd3JvdGU6
DQo+IA0KPiA+IEBAIC0xOSwxMCArMTksMTUgQEAgc3RhdGljIGludCBzZ3hfb3BlbihzdHJ1Y3Qg
aW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZQ0KPiAqZmlsZSkNCj4gPiAgCXN0cnVjdCBzZ3hfZW5j
bCAqZW5jbDsNCj4gPiAgCWludCByZXQ7DQo+ID4NCj4gPiArCXJldCA9IHNneF9pbmNfdXNhZ2Vf
Y291bnQoKTsNCj4gPiArCWlmIChyZXQpDQo+ID4gKwkJcmV0dXJuIC1FQlVTWTsNCj4gDQo+IFNv
IGlmIHNneF9pbmNfdXNhZ2VfY291bnQoKSByZXR1cm5zIG5vbnplcm8sIGl0J3MgaW4gdXNlIGFs
cmVhZHkgYW5kIHdlDQo+IHJldHVybiAtRUJVU1ksIHJpZ2h0Pw0KDQpJIGd1ZXNzIG15IHNlbGVj
dGlvbiBvZiBlcnJvciBjb2RlIGhlcmUgd2FzIHdyb25nLiANClRoZSBpbnRlbmRlZCBsb2dpYyBp
cyBpZiBzZ3hfaW5jX3VzYWdlX2NvdW50KCkgcmV0dXJucyBub256ZXJvLA0KdGhlICppbmNyZW1l
bnRpbmcgb2YgY291bnRlciBmYWlsZWQqIChkdWUgdG8gZmFpbGVkIEVVUERBVEVTVk4pDQphbmQg
d2Ugd2FudCB0byBzdG9wIGFuZCByZXBvcnQgZXJyb3IuDQogIA0KPiANCj4gQnV0Og0KPiANCj4g
PiAgaW50IHNneF9pbmNfdXNhZ2VfY291bnQodm9pZCkNCj4gPiAgew0KPiA+ICsJaW50IHJldDsN
Cj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogSW5jcmVtZW50cyBmcm9tIG5vbi16ZXJvIGluZGlj
YXRlIEVQQyBvdGhlcg0KPiA+ICsJICogYWN0aXZlIEVQQyB1c2VycyBhbmQgRVVQREFURVNWTiBp
cyBub3QgYXR0ZW1wdGVkLg0KPiA+ICsJICovDQo+ID4gKwlpZiAoYXRvbWljNjRfaW5jX25vdF96
ZXJvKCZzZ3hfdXNhZ2VfY291bnQpKQ0KPiA+ICsJCXJldHVybiAwOw0KPiANCj4gSWYgc2d4X3Vz
YWdlX2NvdW50IGlzIDEgaGVyZSAoaWUuIGl0J3MgYnVzeSksIHRoaXMgd2lsbCByZXR1cm4gKnpl
cm8qLA0KPiBhbmQgc2d4X29wZW4oKSB3aWxsIG5vdCBydW4gaW50byB0aGUgLUVCVVNZIGNvbmRp
dGlvbiBhbmQgd2lsbCBjb250aW51ZQ0KPiBhc3N1bWluZyBpdCBoYXMgY2xhaW1lZCB0aGUgdXNh
Z2UgY291bnQsIHdoaWxlIGl0IGhhc24ndCAuLi4NCg0KWWVzLCBtZWFuaW5nIGlzIGRpZmZlcmVu
dCwgc2VlIGFib3ZlLiANCg0KPiANCj4gRnVydGhlcm1vcmUsIGluIHRoZSBzZ3hfb3BlbigpIGVy
cm9yIHBhdGhzIHdlIGNhbiB0aGVuIHJ1biBpbnRvDQoNCldoYXQgZXJyb3IgcGF0aHM/IEluIGNh
c2Ugc2d4X2luY191c2FnZV9jb3VudCgpIGZhaWxzLCB3ZSBleGl0DQppbW1lZGlhdGVseS4gDQoN
Cj4gc2d4X2RlY191c2FnZV9jb3VudCgpLCB3aGljaCB3aWxsIG1lcnJpbHkgdW5kZXJmbG93IHRo
ZSBjb3VudGVyIGludG8NCj4gbmVnYXRpdmU6DQo+IA0KPiAgK3ZvaWQgc2d4X2RlY191c2FnZV9j
b3VudCh2b2lkKQ0KPiAgK3sNCj4gICsgICAgICAgYXRvbWljNjRfZGVjKCZzZ3hfdXNhZ2VfY291
bnQpOw0KPiAgK30NCj4gDQo+IEhvdyBpcyB0aGlzIGFsbCBzdXBwb3NlZCB0byB3b3JrPw0KDQpM
b29rcyBsaWtlIEkgbmVlZCBtb3JlIGV4cGxhbmF0aW9uIG9uIHRoZSBjb3VudGVyIGFuZCBhIGJl
dHRlciBlcnJvcg0KcmV0dXJuZWQgdG8gdXNlcnNwYWNlIHRoYW4gLUVCVVNZLiBNYXliZSBFSU8g
dGhlbj8gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiAJ
SW5nbw0KDQo=
