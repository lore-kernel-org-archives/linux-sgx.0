Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDB92749C4;
	Mon, 19 May 2025 11:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654233; cv=fail; b=ZcZQ/BHN7KthZNHHBVfPxVvwuahUcauY2EGQl28w4U/g5Ax2NcTryhX56i7thfIZCiGpQTnyVtJ+oy60Bv64pUyMzJR4Ouez/eI+R1XLOBEey7WtKcpt/0V54K2NPTHl/ZJKHspdVQOFZL5sTuIQZxhBY2S7/X7oUuc0RHGwK04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654233; c=relaxed/simple;
	bh=/YCnfbaHPlabPpnbvHc+Q/3kseeETLVEo3FxPqcEPao=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NMBCmieVoAQNVQRbT7oWl/5N2wNhFbaIR/VLq71/TkUtaeZ/NuLqfcxxCflG9JLNxoa6EpEGOD/sxSJWxJPd7pt7E31fOzHL9h4B2JxdigwdvoxfUDqeAjJXuZ3gXPCrvh/8kRaRWfT7JLH0BInwb0cBPGT3wL0ISR0gCdgopGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DkupS6rp; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DkupS6rp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747654232; x=1779190232;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/YCnfbaHPlabPpnbvHc+Q/3kseeETLVEo3FxPqcEPao=;
  b=DkupS6rpnkkPy1B8h+nQyXCLOij/IgZlBRLFzJSkDXKVPpAD80d/1k4E
   TqI1uhgSwV+mseLpNfK3QqiB1J879PCh35mivSVqPGyxDB+mc/UCNuIEZ
   0o3IArY++fpi4iWC2t5eNlrs9ssW9YAJN6loPPXtDx5O6NADNJMnWSuCH
   qmwTpXxbfumIB0AE/fE88pzJTf/cSUw486iXNCyXxtiZiPDG4cC/diDMO
   ELHf9+JilHeAtcBcAbjvSq6C/7mejJ2R7QkY/bfT8XmI/NpKfHHDW7C6j
   ZARFSBcZhXxTmQweqDOS2pcui9HpTPvZL2kl2qg7qjdr5LiZqkc2iMM1F
   A==;
X-CSE-ConnectionGUID: 4Wq09ATNTweC8nlbb0GZ8A==
X-CSE-MsgGUID: OaMud0iaS2WpTFMAHgSXdg==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="67105702"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="67105702"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:30:31 -0700
X-CSE-ConnectionGUID: ljb0SBlvSR+LScpnPqMtLQ==
X-CSE-MsgGUID: 3YXGtpsyRF+itCulHZX4bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="144107238"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:30:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 04:30:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 04:30:30 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 04:30:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oquqgcPD1e8zFjKwQoBYwwStVLF3FJ2/9HKeay3jQC/GEswtbGk/fevvgAhVYC3SOTW7cO2TX89Sb2pwfCa5D5ujsX2ihAvLpOqr+20qWvpT9m+vG860+LLAOsQVquvq/to/pnlEE7KOUJGkCEtIzkJXZp5pOADL7mvHPcsBKL1kbB/FnL4rcogKDGSJ8bvzbo5Xl1plRQb1n+0J7vN54f4oeQkQJYmZlWlzCYjvMGjf2n4YEwT8+fw8Y650dsBBM0pCxU9p1CuzcntvZkImh0wown7PJFkkYgZbe4DsGS8EMczy0BXkCEgiSlzaRu+71w/XgTB/kSVCv82+80E2aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YCnfbaHPlabPpnbvHc+Q/3kseeETLVEo3FxPqcEPao=;
 b=P57fyzFKmFvBZ0Y/d2prnTpstkgX43hjPno6BQoDxnYbXLDMpVtwEkTyok1uT+uWZ8Izu77XzuQS/ijAO4wdZE4oLjmm8mbVmMal9GmS1rnrVnf8lCQ7bP2A4oM0GNMB4AhPcY9pg104+jGgY7mM0U8rgHEHRf+F0i8t28eDboltFU/QFA1yh1OBmmtA46ZajyVNbAZUWTKAF9JvSIh2tfP1tVFmV4OEsaIIEft/Uju6iRTPxOA0iIL457lnrNkA/df56WURMf3G+Yy1zENogdZEUpMSwXSzTVB2Vr7QV/C4pkAzZH8/yi4ztifQ+ui0+TXTyx43sJu1iDFu3aUGww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH8PR11MB6801.namprd11.prod.outlook.com (2603:10b6:510:1c9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Mon, 19 May 2025 11:30:27 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 11:30:27 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: RE: [PATCH v5 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v5 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Index: AQHbyI9kmVV/4ckV+EGi7nNCcU1m1bPZyJmAgAAI7uA=
Date: Mon, 19 May 2025 11:30:27 +0000
Message-ID: <DM8PR11MB5750D757F7218259CEE77387E79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
	 <20250519072603.328429-4-elena.reshetova@intel.com>
 <b6f3e810d75fc79b4bb1612ce1cd9da4b60a0e1d.camel@intel.com>
In-Reply-To: <b6f3e810d75fc79b4bb1612ce1cd9da4b60a0e1d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH8PR11MB6801:EE_
x-ms-office365-filtering-correlation-id: 4332d345-ac14-4f1a-21a0-08dd96c88e11
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N3JJYTRBa1JrbkIzeE9vV1pMYmRZYjhVOStFajZjWkcrY1M2M2VMbVlPVFYz?=
 =?utf-8?B?MVhKMmNFZnowMGpQby8xRDhVckVZcDZLampXS1gzaEhlT3FNUFRsb0hwYmdJ?=
 =?utf-8?B?SHBnYXBqLzBhMjE3SzlvcURZVis5aFFFZHBXNjRCMm5XU1FwTnllQjJINW5q?=
 =?utf-8?B?YWQ3cjNMOU43VFlIREI3RlUwenV4ZmpabVFicmFDZ1ZYdVRBK3JUcFlUZmZ5?=
 =?utf-8?B?bmRBWDl2eG5oMkxBYmFuOS9aYy9RaUVZWERNQmJZQjJTdjl5NGVGVjNiU1hx?=
 =?utf-8?B?VXc2YWlaNlhVT1d1U01OM1ZWYzA1TUpRSWYxWVpSc013b2pWc3g0eHlub0p4?=
 =?utf-8?B?aDVNdndTdEUxNGw3RWhhV05hdUlsM1piQTBnaThsdnlFNmQ3bXhYZWVMejNQ?=
 =?utf-8?B?bXVJYXdvWERiNi9FMDNvclZobCtJbGROb0ZxRnhHbWE4NjdaUVR4cXJWc3d1?=
 =?utf-8?B?S3grYkVDSStmamNFOEtneEVFVU9DNUErK3FGNzVPZlBvNUlOckVCQWhKWE00?=
 =?utf-8?B?UTJ4UHhWZjJrbnRZSUNVUld2Mjd1L2xCMjMrR0hGVTJmNG01MFIvelV5ejNL?=
 =?utf-8?B?UzllQkdaYWs3MEp4WHFWak9OSWVpUG15T1RPdEQ0ajRmRTFlMGdpcmVSV2hw?=
 =?utf-8?B?YnJGcE1RaE0yWFNzRUVxa3Vsb3FmVlBCMGg2K2dtYnFSbHNzc25tZzdrVkZu?=
 =?utf-8?B?eEFJVnNpejFOVEN4dWZVWlNCK1hGdTRsRDZMWHFmRXRYOVRrVVF1R2ZPdDFH?=
 =?utf-8?B?RDNERVJRaUk0RjRITjNXTEo1RnNGbTN3VWJIc3lNWHRoQ25iOFVFai9wTDFT?=
 =?utf-8?B?R2ZZd0s2QTc0c3N5UXp1Z2xEVnVHZWhoZnhjaDlrVzVGdnMwa1ptaGtuK0Y3?=
 =?utf-8?B?YzFXeE5zNDFKMmc1RGIwM3RVQlZ5eFhvYWJTWTAvM2tQRURKaWI5cFNQaFdU?=
 =?utf-8?B?M0U0UVkwY04zRzRFc2VwUUVkVWtEVGI0WEM0Zkg4RHBDaEtwYUZ6UDlTTXhC?=
 =?utf-8?B?MU16Y0NVeFhNS0ZaODZ2V1ZzdWFYUXR0THU3U0VvSEJSZCs4YUhwWWpEMkZo?=
 =?utf-8?B?dURkejVIbWRhWUFncGdFVzE3MXEzdHdKZVBYaWp3NkpGNnFvbmZxaFlReWYr?=
 =?utf-8?B?cWtCMG5oNzBrZmFVY2dWUVlTVEFiWWlNY0pkREFiQVRaZ3dQU2J3R00rdXVH?=
 =?utf-8?B?RnRxTDJNemt0ZG1FRnRlUEVWYm9qMENQRnZRalhZdHAwKyt3NWw4VWdUMkx5?=
 =?utf-8?B?dlJZWFZIMXVST3FzTUltSDBFbEp6SjlNcXJjY0MyVWo0aVZLa1pmak1YOWhH?=
 =?utf-8?B?VEYydDgxRWdLa3NjQjljeGkxUzZTc2FLRUR0TVo1Y2VlT0F5NWRhT0llNFIx?=
 =?utf-8?B?TkhDUm51TGV5N1dsalIxYlhtKzVYNDAxRURxbUt6cVVhZGY0cVNSd1dlV3Fz?=
 =?utf-8?B?b3NtMzhWTzhJNmo1R0ZHcUh1eURXNnJvbXg0cFZ2Uk5DUmsrc09lMnRmTW1a?=
 =?utf-8?B?SjNqOEZmSXBBQjY5VnlMVHhuNnJCaHdESVVWSWthOXhiVitjNlVlZzB2aXBI?=
 =?utf-8?B?UUthTUZwaWZBbjNvVGZhNlZMdnJiT3ZUZUNUR0R6Ris3M1ZDS1dVTUhUano0?=
 =?utf-8?B?Q1hsZ3VwVzVydHR0R3g0azJxdDdXMmtLc29yY09yREIzbmZaVk83SUE3TUVv?=
 =?utf-8?B?ZGpxckV6cVN4TVpEdE8wdUVMWWdqRHlwc2JtVDhhZzdNcnYxTUd6VVd5dXNh?=
 =?utf-8?B?RWl2emxOOEdLK3pBeEFuY1JYeGZjK0prZTg2V293RFh1Tm81aXZRY01XdGRI?=
 =?utf-8?B?bU9XVFdSeFBVeXhMMi9Ib2Yxc1FwL002N0pqWk9jUkJ1NG1qQXE2eGZEUDBT?=
 =?utf-8?B?UnBSYnBKQ1VpSUZYRVVzZmNXbjRjdnRKV1p5MUwyY3Z4MEVGeDVPUlY5VlIy?=
 =?utf-8?B?bG04SEl1d1h4OEdxdGRpQ3NBQVBFMlA0bzVjS09Bb3p5TUJlbzZ0ZWNiOXpQ?=
 =?utf-8?B?Vm1RQXRSRkFnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDBTYmZEMS9vVHJLeWU2bHQ1RFpuUDd0K21oTVFjdEJQVGsrYVhXN3JNQ1Nk?=
 =?utf-8?B?K012d1N0T3F6Q0NUQ0xtck8xci9kZ2dwVXNwN1cvUi9XT0F3UTYrd1M5ZHJ3?=
 =?utf-8?B?V0JYRnVBNTRhMEoyaGNDYVQ0Q0JkenZyTXNTME16RTZoeUNaam4xRG1lYVZR?=
 =?utf-8?B?aHNSdUlUOUFudDl2ODR6Wmx6dFFJQjNneWl5d2x2MmpFaEwxRkJCL3EwVDNV?=
 =?utf-8?B?KzQzQ0ZuOXNiZUI5VFNKQXNNWlk4WGZTemZzR3dmTXN1ZzA5S0ozNThUeCts?=
 =?utf-8?B?RXdmU0pMVXFrSmpKbkw5NVFFUnpCYkZ1M2gxeDlSYTFsZk1nUTh6aHF1azVl?=
 =?utf-8?B?RnllYm56QnJsZUpHSVI3cHE0UXBTQy83dG9tdnNYY2QySW9DdlRDYm1tRVN0?=
 =?utf-8?B?cFhtY2EyRloyQUttbWcrWUFMNDBDR0NiVW5pRXlQaU1HN3QzRllYY1orakZY?=
 =?utf-8?B?aDhhWGtrVjlmRmFVMTdqUk10UjZmUWtET2hISnVoV045MlpnUXJ6RzRNa2gr?=
 =?utf-8?B?RkZ2ZHV2S3BqTnh6V244My9sbUZLOWU0VThabTVKQTJlbjBOalBLMVRsdkZp?=
 =?utf-8?B?NzZsQ3BPMWZtSHhONWdobVRzNzhJc2xTRjNObDhKMFAwa1M2QitSck1SWmY3?=
 =?utf-8?B?blRrR3JlcGJSdXVhL3I4bytGZE1aTTFQQXhnOXlRQ0JEZHRFTzdlNlJydFQ5?=
 =?utf-8?B?SUY0dDBjLzVZVUR1N251SFdzaExaV0pWVm9ZL3RnQ2dxaFN3RWFQS2llcDdp?=
 =?utf-8?B?WmtvU2lhNXFYWWs3MHZYY1JTb0lRdW1IbkVpcFMweGtqZDVzRit1MUFNVkV6?=
 =?utf-8?B?blJTN1JnSHcwRit4ckVLTllxdDZleGdlMStpTlBFY2dEM0l5eThaMTZNaHha?=
 =?utf-8?B?bi9HSDNCK3hBZjlTUFp0MVNZQUd2Y3FmczdtZUZzVWZsdDYzazFyVXkzVldy?=
 =?utf-8?B?WTJkbzExZW0xbG8zUHdjdnhMN1lYTjNtTXFmWVdqdmxtNzVrd0lqcVMzZjdk?=
 =?utf-8?B?L2wzVjNyWmg5SkdkSDNyeUJLQ1lLZHYwcFpwSDFJUkIxWGlqY2IrNEZya1hB?=
 =?utf-8?B?dk5uZEt4SWxnQkZyRk5aMEV1L3VRMjBBREhkRkJVM1hzYmVERUhEQ0xsV3ky?=
 =?utf-8?B?QmE1THdDbHRwemZBY1JDM2s5Ykd0MVNiWlNjVHF0OHBnMURKcktOTjFpWTRQ?=
 =?utf-8?B?cHZ0M2FvMHFmTkhYakpycmluNFN3ZnhUSDUwQWVIZVhmMmNDVitNMjhoY1Bm?=
 =?utf-8?B?YTRRaWhGNExIQXFuTStEdEc4L0tMVDE1cVliMlVqWHV3NDIxQ3VOYzFmTG96?=
 =?utf-8?B?aGQxZE9ia1ZZbkkyNStVSFBxSUU1M1Nob0tjcHpVekkzWGdvWHI2Q2k1SmlR?=
 =?utf-8?B?d2Z0cnVtdVdodUpXOE9DMXVOb2JHWXl4bXgwNENlNzJ2dWlYL1R6WFhrdUFw?=
 =?utf-8?B?cnVGcmlySXB6OU8ySVpDSE5FN1FFbDF6SnhNaW9Ma1hEZis5R2xtTWxzQXYv?=
 =?utf-8?B?ZWF3MUxwQ0lJVXhHcHZEMEtHRjk4WE92S1B4aGZXT29Kakt5anE0M2RScmZp?=
 =?utf-8?B?V05HMzlLNGd0alFDOCt1UlpZQ1lYbnlVL1hFc3Z0NVI0eDk1V1FmbkJjdlNV?=
 =?utf-8?B?UHo3b05xdFF3ZVR5S1hOaFBRVzRLNmkzRHVTVmFMZ292VW43WGdveFh0d1ZL?=
 =?utf-8?B?bXVxNHJIS2E5UCtucFVBdmkxYWQ1ZENVS3lPM21SYzBzM1IxSTc5Y2JvU1A5?=
 =?utf-8?B?bUZnSUhYN1MvVjZIUHovWWRGd0haSFhqaEhWblRVWTNDS2VMWmVJdVprc1dq?=
 =?utf-8?B?MmIrYTNGU3VjdmpiQkY3Z3pGeXlvTlNWbmhwWVAwUTM3Wnc4K2VnbWNEcXYx?=
 =?utf-8?B?dFNrZ011eVF1V1JQZVN4cmE4M2pkeCtGWU1LRG1FZjlJTThXT1Q1T3JrL205?=
 =?utf-8?B?WHo1WmkwLzRCSmJ6UnRUNElyVnUyU1Awb3BpMFZBZ2VOMGwycFQrM0psVEF6?=
 =?utf-8?B?aXQvYlIwQStCc1BNSXhhYUdZNmNUUithT3NCdkVlTGVLYWQzTnVkOWVuTXUz?=
 =?utf-8?B?OWQvemd2OTVOZ3pZdjlPdTlxQjVJTVBHbkJKUjNKc2NiWjhKNGJlU2JwaHBo?=
 =?utf-8?B?ZWFhUHk3dE5YUEtva2p4S3JyaTZpUXYwN2hvZGkvVWs5aTlFWm1zMzFrVkxW?=
 =?utf-8?Q?IMq0GFa7p0+BONnLn4UhJNhfT7Jg+vLlWvfRp3hElYxx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4332d345-ac14-4f1a-21a0-08dd96c88e11
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 11:30:27.7354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E95+c5SSoObGTrqY7VF8u0OgYC1F6RYfSXQYR0ecpg8hW+cYkyeu/iH5y7kLIz3FDAOwUbe5UleoirUccQHvtRdvIH4GsUtJSQr8wiDLUTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6801
X-OriginatorOrg: intel.com

PiBPbiBNb24sIDIwMjUtMDUtMTkgYXQgMTA6MjQgKzAzMDAsIEVsZW5hIFJlc2hldG92YSB3cm90
ZToNCj4gPiBBZGQgZXJyb3IgY29kZXMgZm9yIEVOQ0xTW0VVUERBVEVTVk5dLCB0aGVuIFNHWCBD
UFVTVk4gdXBkYXRlDQo+ID4gcHJvY2VzcyBjYW4ga25vdyB0aGUgZXhlY3V0aW9uIHN0YXRlIG9m
IEVVUERBVEVTVk4gYW5kIG5vdGlmeQ0KPiA+IHVzZXJzcGFjZS4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEVsZW5hIFJlc2hldG92YSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4NCj4gPiAt
LS0NCj4gDQo+IFsuLi5dDQo+IA0KPiA+DQo+ID4gIC8qKg0KPiA+IEBAIC03Myw2ICs3NCwxMSBA
QCBlbnVtIHNneF9lbmNsc19mdW5jdGlvbiB7DQo+ID4gICAqCQkJCXB1YmxpYyBrZXkgZG9lcyBu
b3QgbWF0Y2gNCj4gSUEzMl9TR1hMRVBVQktFWUhBU0guDQo+ID4gICAqICVTR1hfUEFHRV9OT1Rf
TU9ESUZJQUJMRToJVGhlIEVQQyBwYWdlIGNhbm5vdCBiZSBtb2RpZmllZA0KPiBiZWNhdXNlIGl0
DQo+ID4gICAqCQkJCWlzIGluIHRoZSBQRU5ESU5HIG9yIE1PRElGSUVEIHN0YXRlLg0KPiA+ICsg
KiAlU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZOglJbnN1ZmZpY2llbnQgZW50cm9weSBpbiBSTkcu
DQo+ID4gKyAqICVTR1hfRVBDX05PVF9SRUFEWToJCQlFUEMgaXMgbm90IHJlYWR5IGZvciBTVk4N
Cj4gdXBkYXRlLg0KPiA+ICsgKiAlU0dYX05PX1VQREFURToJCUVVUERBVEVTVk4gd2FzIHN1Y2Nl
c3NmdWwsIGJ1dA0KPiBDUFVTVk4gd2FzIG5vdA0KPiA+ICsgKgkJCQl1cGRhdGVkIGJlY2F1c2Ug
Y3VycmVudCBTVk4gd2FzIG5vdCBuZXdlcg0KPiB0aGFuDQo+ID4gKyAqCQkJCUNQVVNWTi4NCj4g
PiAgICogJVNHWF9VTk1BU0tFRF9FVkVOVDoJCUFuIHVubWFza2VkIGV2ZW50LCBlLmcuIElOVFIs
IHdhcw0KPiByZWNlaXZlZA0KPiA+ICAgKi8NCj4gPiAgZW51bSBzZ3hfcmV0dXJuX2NvZGUgew0K
PiA+IEBAIC04MSw2ICs4Nyw5IEBAIGVudW0gc2d4X3JldHVybl9jb2RlIHsNCj4gPiAgCVNHWF9D
SElMRF9QUkVTRU5UCQk9IDEzLA0KPiA+ICAJU0dYX0lOVkFMSURfRUlOSVRUT0tFTgkJPSAxNiwN
Cj4gPiAgCVNHWF9QQUdFX05PVF9NT0RJRklBQkxFCQk9IDIwLA0KPiA+ICsJU0dYX0lOU1VGRklD
SUVOVF9FTlRST1BZCT0gMjksDQo+ID4gKwlTR1hfRVBDX05PVF9SRUFEWQkJCT0gMzAsDQo+ID4g
KwlTR1hfTk9fVVBEQVRFCQkJCT0gMzEsDQo+ID4gIAlTR1hfVU5NQVNLRURfRVZFTlQJCT0gMTI4
LA0KPiA+ICB9Ow0KPiA+DQo+IA0KPiBJdCBkb2Vzbid0IHNlZW0gU0dYX0VQQ19OT1RfUkVBRFkg
aXMgdXNlZCBpbiB0aGlzIHNlcmllcy4NCg0KDQpZb3UgYXJlIHJpZ2h0LCBub3QgYW55bW9yZS4g
SG93ZXZlciwgaXQgaXMgYSB2YWxpZCByZXR1cm4gY29kZSBmb3IgdGhlIEVVUERBVEVTVk4gY29t
bWFuZC4NCkRvIHdlIHdhbnQgdG8gZHJvcCB0aGlzIG9uZT8gDQo=
