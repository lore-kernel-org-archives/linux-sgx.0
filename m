Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEEFA94F;
	Mon, 19 May 2025 11:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654576; cv=fail; b=f4ZLIs2eL+nyDeCUFoXh/uNmSKkTnNi9cWDNPTXqm+BXy1chOkPSQq3SJHsuXDchJtp4EJOOQWmhtpIfTlQR9596Jg0vNUUeTyuwqh9eaqHKpQhfC5W5AEF+I9UDj9boA3r+BGkXvVPkpvnjzIkY5ihw+uhdTZhlSBWUk3uKFAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654576; c=relaxed/simple;
	bh=qkcb9s6UkXmFC+ETHbiQ6x7z2sndEYB/UbYHEpiHVP8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PO0Vb24gZ7s8W5X5uRazmlKphy64938ybZ+JaHdDfYiU6oZs9o3/p2vMcudo0wbBWuTlzJBkfFgLwQ3U+HBfScTz3whXmFn2W/L4mm2HPNMyer0mw4flT1CU8tnph/3rdkRr7GIubuQvAxHPONRLRUk/E6RkqCje1C3r3NR7Duo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ODsHsLEZ; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ODsHsLEZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747654574; x=1779190574;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qkcb9s6UkXmFC+ETHbiQ6x7z2sndEYB/UbYHEpiHVP8=;
  b=ODsHsLEZA60/EeYfl0J4vtrv9Z+csdEHWgKMnl0kKPEnAFB9cx6KKC/R
   wC/lp+JZpetHxxifMf2+XwjNyZvFFcnDFmmDvQHenbVFDEhfJNb4h7MAE
   CjgR+wX/gA0AYpmM2emmArbXhhRQ8A5iZRVM1+Vl0RbZ/wZhgAa1M4hSb
   Y5PyhZA3rDgbKDvWqk+zNePmw49pFI6SOWCUQU9wEQNJjlOpzuBP2pfH0
   /ZtADGLIda9lY1ptCqB5Gb54Wf7C8o51UILeBoQ4bIASPlv/2BuKxOpwI
   fKOxZmRfaUJxHB57vz5MFVOtt24XOHmOQQs9hDnXWZ33405uKKw00JvSn
   Q==;
X-CSE-ConnectionGUID: 1fl//yEHTcOv03XXm2/NTQ==
X-CSE-MsgGUID: AhpSh9b3QRuu6NL81Usj4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="49653887"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="49653887"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:36:14 -0700
X-CSE-ConnectionGUID: ScBwGzWOQ2Oxv+7XUHCNoQ==
X-CSE-MsgGUID: ui0q2sVlSP6QI2u2kGRtDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="144597434"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:36:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 04:36:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 04:36:13 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 04:36:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V0Mf6BP32lFogY3lYRBgwt3hrZEM7/wbSK7mhEqAkMuo+6Lblj9FUM3VSIXxnLCpebUJ63qI0+NYsto6yPQ3Jh3N8aouXlOkSUTNPCpEV6IiqMzKO2C/KIulyR8Dqo68YgANSAYV86bEm5cLxXskT3tFPVn037yN/9E2ku4RO7GkcihXiyOk7vGnsyZqtcYk727xwICcjtHB97IRmX16Rn+BzAuHqH30l/34QNSglCnP6ZOZc6muned5kLWYM6F9/UlKfnrrb1U/iaVbadlIqcw0QlsPTvbgV1+vp0Z5+10gEyaJJMl6OIzICyYIwQ5e6MVSxHTnSfmJWFbnsd4nbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkcb9s6UkXmFC+ETHbiQ6x7z2sndEYB/UbYHEpiHVP8=;
 b=XUwKCsnTowUyHMsFUY5vHxiqoKQvhzRAkGeb/4WfHEa86xIqgOf1YX2Yo+5QSnuo87lp5+/5xojgqShRDlJPlvsK0GKfHxpqTeimdjKN7Ji2a4c/4tISkG+hURKRQOensXetPoTBdCa/QdSXdub1gepoTxWMR61/WPgb37QYmDtJBsEZLvQZp9yf7iakP+7eC49rMQ2eNPv73QWzgrShcMDz1DAM65UGYZDxXtfYj5BeCyDR6diQvIASQLiQXaY4r6uLhLNb2sYEue1w7B8nTOwk+CgoPTN0DI+d5AT0VYE9N0y5EBDvRzBe8s0CLoV0iQtx+htdfyxFtAyebl6CeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL1PR11MB5956.namprd11.prod.outlook.com (2603:10b6:208:387::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.29; Mon, 19 May
 2025 11:36:09 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%3]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 11:36:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "Raynor, Scott"
	<scott.raynor@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Mallick, Asit
 K" <asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Cai,
 Chong" <chongc@google.com>, "bondarn@google.com" <bondarn@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: Re: [PATCH v5 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v5 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Index: AQHbyI9k5V1wyfbKYkeoYjGeCi4KwLPZyJSAgAAJI4CAAAGUAA==
Date: Mon, 19 May 2025 11:36:09 +0000
Message-ID: <5bdc23827265d1aa53a8e30314dbb049c424c3a9.camel@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
		 <20250519072603.328429-4-elena.reshetova@intel.com>
	 <b6f3e810d75fc79b4bb1612ce1cd9da4b60a0e1d.camel@intel.com>
	 <DM8PR11MB5750D757F7218259CEE77387E79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750D757F7218259CEE77387E79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL1PR11MB5956:EE_
x-ms-office365-filtering-correlation-id: 89c749a6-f659-4e1c-4ee7-08dd96c959f4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K1JGQXJyZStYU0hPSThRTlRTdXY3OVBlNndSTWJGOE8xMzY1ejVDOFFTa2Ry?=
 =?utf-8?B?dHZmY3hTRUxJQU9KeUZmVWd6QVFFcVR2RGNxZCtCcGg1c3hOUDFZL24xVkJL?=
 =?utf-8?B?UlR6eStaUjdKeTVSSHpteVpPWmZQN1dkeFhJWGxsc0RkakthZkkvdUlUNTVW?=
 =?utf-8?B?VEdnMDNCaUc0Y21QN3hHRGl4Q1h2NTZ1QVVsanlVbVNqaFdsSUNBQjJVZTBq?=
 =?utf-8?B?eDRkclBuYVJsMmdtdWo5aVJmaXp3U21IdE9mZkdrOWlPOHJOZEdFbjBBY0hG?=
 =?utf-8?B?MksweHJMbk9xaHc2U01Pa0hqWW1BTDU0MGtCckdtTThQWWFPazVwNzhpV0ND?=
 =?utf-8?B?dE5Zc2dpMVByRU81S3FpaUcrbE56NXl4cnN1Qjl2SStxb0Q4M3lYcUNyb29D?=
 =?utf-8?B?UXg4TWhhY1pSdlYrQVFNb0lxMkpDblFPdHRGaHArcG9TaytISGY4eGVHTDJi?=
 =?utf-8?B?bnI5SmpyOVNhU2ZrSkpySnpWNDVNUnFpVm5kQWVSd0ZHOFBua21BT0ZQd0ow?=
 =?utf-8?B?Mnh6YzArYlM4ZFdCUGJhTkw4a3A4ak5NZlpmZ1VRZGVLSkdoaE4wVUxrSmgr?=
 =?utf-8?B?UkN1MnlsNmFuUzFYK1BJM3UybmxENitnYlVIYVNhTXhOOGovOU5rZXJQUnFV?=
 =?utf-8?B?R1JJcHlsbEtMRTladFlURE9ZK2lia290elVFSkpDVU5zYldzaThVckZ4MVhh?=
 =?utf-8?B?R0RZM3hMVXpRbVhzT1N4UFZWSDhOSlNvRndOaFk5cGRjT1lVS1U5c0VPVWRX?=
 =?utf-8?B?dnZDNUFYU2FuR1VYVlhOM0xZUjdwaE45R0FtbEJDYjBOekQweEhKdDNnL1FV?=
 =?utf-8?B?ZWlGRy9NeVY5MzZ1V1grRWZsRGVWWWtZTkd5b0VOaCtuTlNBdDJvLzN0bm5K?=
 =?utf-8?B?UjZ6TmVTWmxaVDVnOHN4azBPV1RhZmVaTlRjVWllRmRMRFowZFRMWVpHRlBF?=
 =?utf-8?B?UnpmbnBGYlp3T0gzSzBCaFQ1bXVFK2w2ZXh1SjUxSW9GblFlZ0tuT1EzSWo1?=
 =?utf-8?B?aVd6a1h4TUoxbGFUUkNRTUpIWm54dTIvZlpTVzd0YmM0MWkrRVhkOHJubHZY?=
 =?utf-8?B?amFPU0NVMnk4ZGVUQlI4MFc5cGZCSjlhMkgveEV0ZXMxcUxqRHoyMFJvQTR3?=
 =?utf-8?B?SU9RK0NDTTJETkhFRHN1WnJlOVg1MnZCUnhnZk9OWFpEbzhpZ21GUlk5WVZn?=
 =?utf-8?B?azd4ckxlaldON0pDMGVXb3ZRM05rRFltS01UcEJCS0NTS2pJangyWlFYaHFB?=
 =?utf-8?B?OGhVMTNPdktSUTM2c1JsQVVlenNpajY4WHJ3K0M5MUJISVdKVGpQY1BJbkFS?=
 =?utf-8?B?RUQ1MVNFTkdRcjl5RmMvbkpHNWkxZjhsSVBiKzdHOHgvekJ1SkIzVHZyeS82?=
 =?utf-8?B?cFowTUJYdVRvY0F3TGp1VVl0NzJqUklNZWtMakt6YmlwZTNKb2Ztc01tV1Vk?=
 =?utf-8?B?MEhYZ3dYOGlEUDdFcTlreUtVYzU5MFFhSGFEaE12NzNTZmFPNU1DZC9MTUpS?=
 =?utf-8?B?M2JUSGVYYWduOC82cnZiMCswbFFmNXl2VC9Uc1VyTWV3aTBpdXZ5MVN2YW4v?=
 =?utf-8?B?YkJiMWJ0VlVkTWcyM1RCZnF3bGpNdldDWGZMcy9OYXlQa0pIemwxMWYyZ2Z0?=
 =?utf-8?B?aUU1T3MyV0dHZTF5NVd6ajZMcTd0YndFblNZemo3UjZVOXlaRGpuSWx3YTdn?=
 =?utf-8?B?a29uS1o3U2xxZ3AwNVBuZ3laM1ZSb1dMOU9haDVkVGVRRnlzWHpQSXhUaktM?=
 =?utf-8?B?d3BWUFNkV3V5M1FFelR0dFFXSFFZdjM1V2JIRkFQRDh1Zm1xb1FWYkk0VE8w?=
 =?utf-8?B?eEFwZkpPZ0sxSEhQZXp4akpXVGxCM2ZGMmFoZFZpUThhZkJhN2ZGYjBScEF2?=
 =?utf-8?B?UU5WZUlQTlE2aytMT1crMTV3TWpScmFSTHV1VjUrbVZaN0hWRDQ4WlBETnhV?=
 =?utf-8?B?UnkrQm93d1hVRE45UlVPQi85S3ZKWklZV0FLQnpsRGo0WUhKNTRCamx6aFlt?=
 =?utf-8?Q?OSB9Jgv+r5WWFMR/bT3oQUXHjoKSJc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnhwQmhHTHpTUHZ0Q1k2RGV3U09hSWZEeHR0RnJ3ZVFhOC9Da2ZOdGN2YXNv?=
 =?utf-8?B?MU9SS0dPSnk4QTExbHpnZUtJcmhBRjhVdzRkWjVnam45RDkzbkFCNlEyTHor?=
 =?utf-8?B?bC9rRnl1ZWw2M3J1VGhzQ253VEZXUmZRdGZnRitoQXBnNGkxV3pUZmRnQmhI?=
 =?utf-8?B?cXBRS2w0R3VpOExLZUloYi9pa0hrZ283dWRrYzkvbFQ5Z2JRbEpLaWNTRDVP?=
 =?utf-8?B?K2UvRFN6K1d4WU8vajlNbStoU3dJS3B0VUlwWUp0M1JGQnBRWHZBT2V3NENE?=
 =?utf-8?B?b1hZeHlrU01XeDg1SkF2RmFiRDYxY0ZKbytEeWhSTzl4RVJWKy92dFB1cjNt?=
 =?utf-8?B?VG0wV1I3VUF4UUpmaU55U2JheHdtdzVIb0hER0FCbzFNZDcyQlZFRUhMOGdB?=
 =?utf-8?B?Uk1EdWVOR2ZGcWkrOEluTzBoMVNmMUFtczdFZFhMcHJVaytpYmIvUmVKNXBD?=
 =?utf-8?B?SjRtcVBTc1Qwa3JxOGt5ZWhFVjQ2SDQ1M1BBbEJPK2tMMmZLejhGdlEzUThs?=
 =?utf-8?B?RGpGLzlNK2JZKzhYQzcrTFQrd3NwcEcrdy9MVWg4QzhwV1k4YWxFVlkwM3Y4?=
 =?utf-8?B?Zy8xMmdOU2F1bWZ3Y1ZrYnJGb3VWWnNXaXkxdU1ZZ1Zwb1d0R3RRRE9UMjV6?=
 =?utf-8?B?ZVZLTlppVW5oVWZCaXEzd1ZOdmF5bmV3V25jSERZV1FiOFVyVmtKMUVQSHht?=
 =?utf-8?B?QStaT2xpN0FtbVRHZ3ZSRjh4bG1mbHNvMm1BMTFhZWFUdkFDd1ZvYXorMVFE?=
 =?utf-8?B?UDJXbzJmK25CanplR29LdEdIQVVXL3VLV1JuSGJjNFFETWZoSHo0M3Z1NUJT?=
 =?utf-8?B?Y1JFWkRkTHNwanUrSUpRZUJZZHF0dVliOFhqSGV4Rkw4Y2NYemlRWk5vRnlW?=
 =?utf-8?B?S2lJZk84MnhoWmhDZ2ZrQk1lN1IwYzIwazdReXJleDFkcDkvSnVnQjJPME5i?=
 =?utf-8?B?SlY1c2RtbmhlWmRsRGQxWEZZenZOVDJ3MUlNbGY1YVNwSDYwMlp4ei9UYjRX?=
 =?utf-8?B?R2hPMHBQV21WY0VkYnFMbGZGNE9FMVM4dCswNy9nNW9ZcEErUURJTUdwZUFS?=
 =?utf-8?B?QldCSzdGL3B5eDVQNk9wS25hcU9kVENaZWV0WnBQUGN5dVc2bCtoV3dQTWU1?=
 =?utf-8?B?RXM3MjBGT0tLR1FMSTdxYU5hL0JuRVp3RXJSQUVvVUNtdDZrR0NuSjVNcTZO?=
 =?utf-8?B?UWc5Q3JBdm1OK3RISG5mV3JwRjd2ZkZmalc3QmdoQzFEQXdWdDhrT0VOZndh?=
 =?utf-8?B?eEtUQUk3ZEltZmZXdEpVRWdJOFhLSHA4aURHWHFRUEhIVThNZkJ1SGMxdDNw?=
 =?utf-8?B?SFNtSTVKMGczUlBReGNiMGRTTzhrQTdNMUdmZUE5ZUVCR2tDVmpaMTl4OUZk?=
 =?utf-8?B?eGVUOWM4akNkcURUMVBWc0lOaUhOOXU0UU0vOXNhL0NIMTcrNlhBaVVIeWV2?=
 =?utf-8?B?L21uV1ZPWTRsdk1uNW9Wc2E0TXpSTGRGdHpkWWhHeWd0VERxb056U01aUVFX?=
 =?utf-8?B?QUYvZHFjVERjYUZ0bVBiTDV5SjE4eWQyUmhpUG5TbVFDMWtLR1BlRXBaWTRR?=
 =?utf-8?B?Vk1ENVJPNVZib2Z0SklnSUlJMkpNY0p2K2plSWM2OEhPWit4VFlZdFZkOGFt?=
 =?utf-8?B?dmNFMU5lMTY2c2JhUTNIa2wwMEJkakhFbmZMV2pWSndtNjZta0Q1UU9ITEQ2?=
 =?utf-8?B?NWtodVJBY200Q1BoV1NmY21jakpUejltL1RianBuSURzU3JzdTNQRWJ2bkdz?=
 =?utf-8?B?ZW5paERpWEpROXBhWmhVS0N4a3FmczlsTWwvRzNjNFg1U3pVSTQvaHQrcDNs?=
 =?utf-8?B?T0ZjWTBJR25zbHhlQUMycEVnQUdPMTFyc1k3amIzTkFVd2l4SHhSZW5YWmJI?=
 =?utf-8?B?NXlaTWRKeHFsMmZ4MERzVFNKaEczZmpPQ1IvbzZhb0NnbWFqbEJtZStYcVlU?=
 =?utf-8?B?R01DMXZsUFVRMnZoK0ZiN3RjTVkrOHB2VmkwblcyY0xhdmxMcEovNlVUaEpC?=
 =?utf-8?B?R1dYTEM3dVV2RERHT0o4ZVRXbDhBbDVseUZ2Si9BeXpaRlRPSVhRUmxhUkpD?=
 =?utf-8?B?ZWxBL2xhYlpDa3FXUmE2WWlPd3l0TklXRHUvZ2NnUHdtRHVlRXpCa1RpaVZk?=
 =?utf-8?Q?cZzyBlc23S8j8UlxqdKkIHvj2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1F8343C5C024A4291504EDCC5FFA7B0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89c749a6-f659-4e1c-4ee7-08dd96c959f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 11:36:09.7715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3AukeOT+7FWwbELU+u+uyHTPUdQ6GpvuyVdvQCDQX1eH54HpjSic9Mwd9w+ByXxkjKPXKI5JzigKzCLt0fBCfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5956
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDExOjMwICswMDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3Rl
Og0KPiA+IE9uIE1vbiwgMjAyNS0wNS0xOSBhdCAxMDoyNCArMDMwMCwgRWxlbmEgUmVzaGV0b3Zh
IHdyb3RlOg0KPiA+ID4gQWRkIGVycm9yIGNvZGVzIGZvciBFTkNMU1tFVVBEQVRFU1ZOXSwgdGhl
biBTR1ggQ1BVU1ZOIHVwZGF0ZQ0KPiA+ID4gcHJvY2VzcyBjYW4ga25vdyB0aGUgZXhlY3V0aW9u
IHN0YXRlIG9mIEVVUERBVEVTVk4gYW5kIG5vdGlmeQ0KPiA+ID4gdXNlcnNwYWNlLg0KPiA+ID4g
DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBFbGVuYSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92YUBp
bnRlbC5jb20+DQo+ID4gPiAtLS0NCj4gPiANCj4gPiBbLi4uXQ0KPiA+IA0KPiA+ID4gDQo+ID4g
PiDCoC8qKg0KPiA+ID4gQEAgLTczLDYgKzc0LDExIEBAIGVudW0gc2d4X2VuY2xzX2Z1bmN0aW9u
IHsNCj4gPiA+IMKgwqAqCQkJCXB1YmxpYyBrZXkgZG9lcyBub3QgbWF0Y2gNCj4gPiBJQTMyX1NH
WExFUFVCS0VZSEFTSC4NCj4gPiA+IMKgwqAqICVTR1hfUEFHRV9OT1RfTU9ESUZJQUJMRToJVGhl
IEVQQyBwYWdlIGNhbm5vdCBiZSBtb2RpZmllZA0KPiA+IGJlY2F1c2UgaXQNCj4gPiA+IMKgwqAq
CQkJCWlzIGluIHRoZSBQRU5ESU5HIG9yIE1PRElGSUVEIHN0YXRlLg0KPiA+ID4gKyAqICVTR1hf
SU5TVUZGSUNJRU5UX0VOVFJPUFk6CUluc3VmZmljaWVudCBlbnRyb3B5IGluIFJORy4NCj4gPiA+
ICsgKiAlU0dYX0VQQ19OT1RfUkVBRFk6CQkJRVBDIGlzIG5vdCByZWFkeSBmb3IgU1ZODQo+ID4g
dXBkYXRlLg0KPiA+ID4gKyAqICVTR1hfTk9fVVBEQVRFOgkJRVVQREFURVNWTiB3YXMgc3VjY2Vz
c2Z1bCwgYnV0DQo+ID4gQ1BVU1ZOIHdhcyBub3QNCj4gPiA+ICsgKgkJCQl1cGRhdGVkIGJlY2F1
c2UgY3VycmVudCBTVk4gd2FzIG5vdCBuZXdlcg0KPiA+IHRoYW4NCj4gPiA+ICsgKgkJCQlDUFVT
Vk4uDQo+ID4gPiDCoMKgKiAlU0dYX1VOTUFTS0VEX0VWRU5UOgkJQW4gdW5tYXNrZWQgZXZlbnQs
IGUuZy4gSU5UUiwgd2FzDQo+ID4gcmVjZWl2ZWQNCj4gPiA+IMKgwqAqLw0KPiA+ID4gwqBlbnVt
IHNneF9yZXR1cm5fY29kZSB7DQo+ID4gPiBAQCAtODEsNiArODcsOSBAQCBlbnVtIHNneF9yZXR1
cm5fY29kZSB7DQo+ID4gPiDCoAlTR1hfQ0hJTERfUFJFU0VOVAkJPSAxMywNCj4gPiA+IMKgCVNH
WF9JTlZBTElEX0VJTklUVE9LRU4JCT0gMTYsDQo+ID4gPiDCoAlTR1hfUEFHRV9OT1RfTU9ESUZJ
QUJMRQkJPSAyMCwNCj4gPiA+ICsJU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZCT0gMjksDQo+ID4g
PiArCVNHWF9FUENfTk9UX1JFQURZCQkJPSAzMCwNCj4gPiA+ICsJU0dYX05PX1VQREFURQkJCQk9
IDMxLA0KPiA+ID4gwqAJU0dYX1VOTUFTS0VEX0VWRU5UCQk9IDEyOCwNCj4gPiA+IMKgfTsNCj4g
PiA+IA0KPiA+IA0KPiA+IEl0IGRvZXNuJ3Qgc2VlbSBTR1hfRVBDX05PVF9SRUFEWSBpcyB1c2Vk
IGluIHRoaXMgc2VyaWVzLg0KPiANCj4gDQo+IFlvdSBhcmUgcmlnaHQsIG5vdCBhbnltb3JlLiBI
b3dldmVyLCBpdCBpcyBhIHZhbGlkIHJldHVybiBjb2RlIGZvciB0aGUgRVVQREFURVNWTiBjb21t
YW5kLg0KPiBEbyB3ZSB3YW50IHRvIGRyb3AgdGhpcyBvbmU/IA0KDQpJIHRoaW5rIHdlIHNob3Vs
ZCBkcm9wIGlmIGl0IGlzIG5vdCB1c2VkLg0K
