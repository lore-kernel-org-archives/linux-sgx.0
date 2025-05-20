Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3489025CC73;
	Tue, 20 May 2025 06:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747723576; cv=fail; b=k66WxGujWInH5KJHUV2MgiOpNNqXFyp0N+g5beuIdfxJSjS7ClsxQaCO3rpN6ULlYwHnhs+UkIx0PPCZjHC6Fb8qR7luCHi7TYM1UXZs7T2+C13XV1IPmD14DgoDPAKy3Aq6TgvtdAWVPlrtEMsI44QS13rkDEyLywIX3CLdggM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747723576; c=relaxed/simple;
	bh=icstaAtoc9ynkgUku448/4sIAEMKcgoJ9WGq02AcNQY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JMPsoy18DLgjDZVGu94+F4DPRL5A9g9KUrQdJF8R50LXCnyLO7FdKTIiA5IjePu2sN01HMZWysPRcQdSxEaXTCodikPma9ZXmb1n7lrZL/fSfuLlMLTx+LFs/+JDJzNGa5JhFZ8s4OSs3YMkUYhQpStfEAbyifTjlpm+Qn0GRrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fRfJSM8z; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fRfJSM8z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747723575; x=1779259575;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=icstaAtoc9ynkgUku448/4sIAEMKcgoJ9WGq02AcNQY=;
  b=fRfJSM8zV4MpsRTMgAlletHplcfAjcyhqrLcPKOJmUIAocfKLJCCCiap
   UUH4dgl6EmVGQHvpzYwMNiriZxn0ZGh3ETkhFJPVkDXqu0xOO2vbXq0xE
   EwMz6X8KVmVqOt1NCZD5roPlV84mBAxqhbB45Tw17ui3zTvQjrKE6e51L
   2bUJUA0y8KmgF4LBcwHsjpgotw7TC4Ity0TBdbUnVqmTuCZTD3Wv0msdv
   sDrRrePZnc8br+gjdlcc2h95mx+VdW8XOTcsUtKR96yDvQq59oniNyp9m
   3r8qzz4uagq2uzFWbVMcHY26La1rAbczho7ToMmK+soyoKFHL/9Q13uld
   Q==;
X-CSE-ConnectionGUID: uQiQpDFrSFq/3IQriz5bWA==
X-CSE-MsgGUID: sw+ykmg4SWWgISNyP27JjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="53455677"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="53455677"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:46:15 -0700
X-CSE-ConnectionGUID: r/K5vczIRkSNoXr2hwND3g==
X-CSE-MsgGUID: hZbt1cTuTYC/keKom/lS4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="140605667"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:46:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 23:46:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 23:46:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 19 May 2025 23:46:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j1W2paHNja0nN7BwYBQU+l58nBGCD4Wsdt5mLrpcdyUHsCQsGceL/u7gPLPFC7DHUw8o5cPZEajP70wm1F9P5w0JHUfmBQSGiskEpA6mKCJAXLExP+t82j5M7CleF1ZXGXj1rvLzp7fTNrE+rSeBhgG3WQrM276Wp8WXUHZb1k49P3rHJoogoesU+bibxfzYjBRxCA4LsD82S+eYeCbPjA834Xq2Xf8CA8a3SSQeAB+pih+bmHlxJCTeSHE3plorjlTcx7lQGfWH7q3XwitpUV1wUwwNzq6wHhp7RL0lgq892MzxS/pogpklbsbJoAqRSRtUx/1AG3sr4quaiwu4LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=icstaAtoc9ynkgUku448/4sIAEMKcgoJ9WGq02AcNQY=;
 b=uWplO5s5EnOwmEVUNHmPms0zQvZ3xN28jVrVCPwWO8xB1dZSt7Gf7qXE5KMRCHnk40wFXTOsR/5QaNzKxrHok50hKvdINmd+qmeFlNBL7qJWBBLpKusyI5tyzQbd1AV8748saNdRQqTRael81vo3/r0FbrO/j7r+vQLVaMBNDN25cqv7XQheSKCZDViQ0io7jL/Ua9XpqAHNTs5zhDuiLZwJ1YJchGYuwP0NSWQeRvtaNWZXCZxFHFg9+I8k/u6lLF/ixUeYHh2tQlcWPho0xATkmD/7B0xkdlAgvUc6p1UVLnSPyBiSfQngXG5hfTwAF337WQTEcZhQ8D/JgJ7mZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SJ0PR11MB5919.namprd11.prod.outlook.com (2603:10b6:a03:42d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Tue, 20 May
 2025 06:46:05 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Tue, 20 May 2025
 06:46:05 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v5 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v5 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHbyI9qooAzhUPou02sbUcJOGJbyLPaR5qAgADMixA=
Date: Tue, 20 May 2025 06:46:05 +0000
Message-ID: <DM8PR11MB5750E1B5B13F616BB67AF80CE79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-6-elena.reshetova@intel.com>
 <aCt5Nx06rItmWcYR@kernel.org>
In-Reply-To: <aCt5Nx06rItmWcYR@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SJ0PR11MB5919:EE_
x-ms-office365-filtering-correlation-id: 5e87a554-d019-44ed-9123-08dd9769fe72
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K29QYUdIZlo2emJLak1TcTZIZkpMZWNhc2UxbUxtanc5ZDk3dGNzeU84R05N?=
 =?utf-8?B?ZmFRckRPR0c2ejg3QS9ka2tzeG5aTjkzTFVrVHluemNOd2VCQVJoZlBlUjZq?=
 =?utf-8?B?aVhkb00rWFpmSmlhTVBYam1Cd09RNnlHWGJRVnVreGltRkxuYTBrcVB4byt2?=
 =?utf-8?B?NzhGSnZkL1p6MjhiWXUxamtlbk42d1Y5bXlWMjRHd25SK0dzYzdPSFBqb0Vh?=
 =?utf-8?B?ZkhLMGRFWHVhL1F1MVUyaXJRMllKTVExVEliK1YrUFZsK1k1R0NieEtYQUpH?=
 =?utf-8?B?ZFh6Y3FVdGRCQ3ZCYmp0eU5YUkVRTFQrVWUxL29aY1pBejl1dXpmZUtpanUr?=
 =?utf-8?B?SEc0UmNPM3VJQk4rc3NYeDNCYjN4d01WY0VJVWs0ck5oL3VoNThSUDQrakNY?=
 =?utf-8?B?SFpONDVJcmNSZ3RLUzdFQ0YvZFZrZXFVako3QTQxc09QRndsK1lFNk1CVW0w?=
 =?utf-8?B?eUhVaHhxNW9wV0NlbVVTNHlWa3J4UjV4TkR1bzNSS3VsZmdxbkVuYTQwZmxC?=
 =?utf-8?B?c3hSVXRha2orOGJxdHduVFczbHdONGdQbDlvNkdUbExMMEJoZUlvVVdBQlRT?=
 =?utf-8?B?eEVaeHFIVW9LTkZUd1h0bC9vMldzdzBIK3BiYXkyeFR6MXR1bVVYNnNIeDNx?=
 =?utf-8?B?bFVPVU5qN0VuK2ZXUkhGKzYrSk1nY2JTdVNFSm11d3hWdTVlM3EzUVl0a1RO?=
 =?utf-8?B?dkhLb2NwZmxBWGNmN1hCNUxEUmZHYVB1QjNqODF1UldLRlJ1czV2bHV2OTBW?=
 =?utf-8?B?WURjeEVqSnBDREJHMzdZRWt6YnV2b2REK2NIZVNTTDJCMk0ya1dSZUFCTTBm?=
 =?utf-8?B?STFldkJBR0RlNnYwQUJZbGhNdnl5UlBVa0s3ZzFYSWE3RmNWU3llVjVpaE1V?=
 =?utf-8?B?RjFMb2MxRzFMNktON3ovWDZ3L1liZGhMbUp1S3hReWJCUXBiUTdac2lmZHkw?=
 =?utf-8?B?OXZvbDJwQm9pQXhVeVQ4Q0VFaTRScnNIMHYwWldBMlRibXpKdndPdjF0M3g0?=
 =?utf-8?B?SUtuK1pBZDVKWnM2V1Mwb3ZoWmZrVnozdUkrZml4dE9EZld2UVg3TlBuajd5?=
 =?utf-8?B?WnUrRXp6MlFVZVQxeXNpL1VNR0RSSFFZU25rNFZTRkMzelNkRWxCanhJVEZL?=
 =?utf-8?B?UlBLcG5ZRkdwTmJLVXQveXUzR2lSMEZLdHVNSVp0RDhtdXVTNUNFL3dsWTZL?=
 =?utf-8?B?bXBjdTQ3dW9QV3RjOEV3WnhtaUg2WVlWL1dmaER2V1hlOG12VW0wMDRIQWM0?=
 =?utf-8?B?Qi9zanZGYlM4WUpZeWtzdFJmQXpUcWg5QU4yZmRFRXhKWWY5MlNiMTVQZGVl?=
 =?utf-8?B?c3MrWnJmMHY0dld1WUhXUkdLRitzdEVJRkZraHNoTGxOMXVpMnFhT3ZkbWl5?=
 =?utf-8?B?czlwL2xwN09TVDd0RVZXQ2w5ZnM4eW8rd3FMcU1WMlBKMHh5dzlWYWZwcVFI?=
 =?utf-8?B?cUxVSityWmtlcEJmOU1JcXlIVFA0OGdkbXUydjFBZHBVc1htSTh0MUxRQ2dr?=
 =?utf-8?B?WVRjQ0labDZRZ0krWkZQcmkzREdsR3NjKzRHZ1k1NERoTVFsZWtmWlpHbWt1?=
 =?utf-8?B?TGl4S0p0RnZ1Ri9XcUM2Q0FzN0VQcEd2a1MyRnRLb05ZVkVaSzdiZjhrVDhB?=
 =?utf-8?B?c0J4OFgvaG85NDV5R3FleFU2WUhNRER5TXozeWJ6R2tDZFN6NXpFODdKeHFt?=
 =?utf-8?B?dlc2VnM4Wi9GbjU5OG44QUw1RFVHUlhHMFNRTjY2c3h6OU1vT0JESkVnSW8v?=
 =?utf-8?B?MklkeDJqNkNvV3ZsYkVvR1hlRnI5c2c4RXNIaFFzd0ZCQldBUVd3UGRORmRk?=
 =?utf-8?B?bTlpS1UwOGkwRGdKNTFZQ01RL1IySFMrMjVsL2wrMzc4VzhQVjBJNnNBLzZB?=
 =?utf-8?B?bzN1ejhMb2Y4ZEg5c3hiMVJlK0thdGJMeXZUeUpvckRsd3RQSXp3RGNkOERv?=
 =?utf-8?Q?HrSphCEtSUw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXFHYkIxcTVkVURSZStKencxWTJnSC9UL0V0Z0xkRFU5UUxnV3Nza3daVFVv?=
 =?utf-8?B?T2twOTIvQlFEWTJQS3kwUFltZ1hCQzZobTRsY1YwblNpUWlVYlZ3QzN5bWo3?=
 =?utf-8?B?MTIvempUTW9GRmNEd3FGQmduRzNJbDh4azl0TmcxZUtsc0pjcVBVTE12K2FP?=
 =?utf-8?B?NnBoWHNZU0I0SXBnZ2x0MmZwR1ExdVg0bnBxbDlmT0lpWjhtZ3N1Mmo4K2dj?=
 =?utf-8?B?bWxGQW1zUTBrWkdlWCsxK3orWkl1OWVqYkdwRzRDUDFsaFRraXZhakRDOStE?=
 =?utf-8?B?eEZMTDkrTkpQUzRoSC9KYXFkMTAyTC9aNmE4WHBtTElNUm5OaTBjY2VzU3VU?=
 =?utf-8?B?Ulg2M2JrTXFaWnAzdHlPajc0S3FqdkdnMVZ4REhSQWVadGN6dUttSGdvSVFN?=
 =?utf-8?B?bUNGUHRTYXo0Y25MTkVrcGJaNnc5NEQ4bzBhMTRLTjBCRjlLNWtSM29ZK1Vu?=
 =?utf-8?B?UVJuMFJYUUcvTWxjSGFmUjVNaHZ6QUk1b3dqVUFKZmM5N2ZoejZXNDh2Q1k5?=
 =?utf-8?B?YXFTTlVzREtTMHBIRjhZck9FdE9sc3NhQm12UGZWTTRuYzdqUTVGdUxHeENu?=
 =?utf-8?B?WHZMUytoZ3BTeWcwNHlyVzJ1MWRKQmNMb3VPQy9jYVM2RmNFWGk5MEp5WkNP?=
 =?utf-8?B?MFhra25VLy9EZncralJRYVNzL3FFdXdpYUU1ZGFkaEJwQWF3U3pXWVpmRDQ4?=
 =?utf-8?B?NFM2Q1pYZVJDc2VlcDRMdmFyS2ZLV3d3RzVERisrS3N3QURpRUVxV2F0RTJq?=
 =?utf-8?B?c3JGWjdsUWsxdDgvQ1NoRVdnemtROVQ0dGdqWjRqa2JvNE9qUDJWdS8vSVJy?=
 =?utf-8?B?ek1pUjkvWWV5enpOOVJxZUtCMDYrMjkzdlREaHk1R1JodW9aNTRRU001ZkRE?=
 =?utf-8?B?TytvM09MMU14a0dYVU1wTWRWckd4WWlVK1djYXE3YmpLYWpDR1NrL3lYTFA3?=
 =?utf-8?B?N2QwbkMrbklZWGdIeG0zNzBqcGQxUkg4WU4yTGlpUlFWWGpobVNqSkRrTFh1?=
 =?utf-8?B?YVJXbzZTS2NWTDYzTlpkekRKVnpvVitiQjErZWpLRE55NVdYcWg4UytWd3BN?=
 =?utf-8?B?eVNKMzhTY0NXVU9vcEZWZ1FJcHhRa2cwMkhwMXRaUjlMNmhTRUFGdm5MYnJj?=
 =?utf-8?B?c09TUGhzcXFTL0VzbWxzeXBORDRrSmtrZ216bUpIb3RZVjdBby9QUURYOEts?=
 =?utf-8?B?bFQwbGV5K2IrbGtnVU5aWkxRdGlPVkVoWStSNjd6dDZ4WEFtRTc3SUFndlZw?=
 =?utf-8?B?SC96SXgyUzU3Rkc4MWJWSm9XMWcyblZoTU51TEtyam84aEwyZ3VpbW5sSHNO?=
 =?utf-8?B?TWRqNlBJMVVkT0JXNThPMlhGTWx5VTlFTWtxUHZyTVhkbmdMT0x2SDgzbDV5?=
 =?utf-8?B?KzF5UnFwOUtmNmxpM0x5RFlOc2c2N3JueGRnZzVYVG5NeHJKYnVKMFMyYTdT?=
 =?utf-8?B?dmRWZHEwc0dqcUVBWkU2Q3pzbWRWR2lrVjJ3eXp4ekh6cVI0Tm5hYkl5enVM?=
 =?utf-8?B?bzVUU0tXSzd6V1RiN29iUFVmNm40YjZ3NGhJbS9ISHV4YnVNTlZzT0V2Qm5q?=
 =?utf-8?B?R1VaWmQvUEEwamVoL0VEcE1XSGpxNUd3Y09WejZ1cWliZzJ5VGlGZm9WSXY2?=
 =?utf-8?B?NjY3bjBrK3F1U2NqRElGR0d6UCtmZ3VtdkRVazVuWWpUNDhPQkFYNjJiNTR4?=
 =?utf-8?B?WWQzVXVmOTV3VTFjc0IwcmRKZnJ0eVRmMFF1ZllEdFUyc1dBdUpNLy9KWCti?=
 =?utf-8?B?S1p0TVd2Tkt3SURYb25sWVJVaUNyM1pvRUtsLzQvbTkwd0IyYVZwdURjY241?=
 =?utf-8?B?NU1HZXJHb3dpcDl5bDQ5N1JHYk5meGxwcExJeVJuQWx1UGFrMzlkTWV0YjRG?=
 =?utf-8?B?d2kvQWpCdDBxTy90TG1sR1FEZmpwbHJVTVdUUGNnczd4ZnU0aVVxTVljQ0Zu?=
 =?utf-8?B?SGk4RUlyQ2hIUVQ5bVJycXE5U0ExLzNrZ2hBWWdqRVpFMGRJZmRCSzRwRGVB?=
 =?utf-8?B?NXgyNSswNHZ2VmRiUFRWNm9xc1o4L0doMlpBYXN2Myt6S2dDWXdpUFMwRzFl?=
 =?utf-8?B?VVRyVWQ3ZURIYm13YW45S0lWZm41SWlPd09pVG9LMkVTVWF3NlVRRlkrUHVO?=
 =?utf-8?B?b09DT3QxamI1bEFkS20zckFOaDMyMDNXbXZ1Ni8zNldWa25RdEh4NkxBNkhP?=
 =?utf-8?B?enc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e87a554-d019-44ed-9123-08dd9769fe72
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 06:46:05.2285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: em/zXTtT6vZqRYgUDQRWUiV3Ai/DiXfTj2Xrvd4JQDo9b5R1GOuPGkDWMdMWtj8RdLXx0zMbDDnKRfGUWbFHGGwTQc5ODtS2SFq8lpWHBjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5919
X-OriginatorOrg: intel.com

PiANCj4gT24gTW9uLCBNYXkgMTksIDIwMjUgYXQgMTA6MjQ6MzFBTSArMDMwMCwgRWxlbmEgUmVz
aGV0b3ZhIHdyb3RlOg0KPiA+IFNHWCBlbmNsYXZlcyBoYXZlIGFuIGF0dGVzdGF0aW9uIG1lY2hh
bmlzbS4gIEFuIGVuY2xhdmUgbWlnaHQsDQo+ID4gZm9yIGluc3RhbmNlLCBuZWVkIHRvIGF0dGVz
dCB0byBpdHMgc3RhdGUgYmVmb3JlIGl0IGlzIGdpdmVuDQo+ID4gYSBzcGVjaWFsIGRlY3J5cHRp
b24ga2V5LiAgU2luY2UgU0dYIG11c3QgdHJ1c3QgdGhlIENQVSBtaWNyb2NvZGUsDQo+ID4gYXR0
ZXN0YXRpb24gaW5jb3Jwb3JhdGVzIHRoZSBtaWNyb2NvZGUgdmVyc2lvbnMgb2YgYWxsIHByb2Nl
c3NvcnMNCj4gPiBvbiB0aGUgc3lzdGVtIGFuZCBpcyBhZmZlY3RlZCBieSBtaWNyb2NvZGUgdXBk
YXRlcy4gVGhpcyBlbmFibGVzDQo+ID4gZGVwbG95bWVudCBkZWNpc2lvbnMgYmFzZWQgb24gdGhl
IG1pY3JvY29kZSB2ZXJzaW9uLg0KPiA+IEZvciBleGFtcGxlLCBhbiBlbmNsYXZlIG1pZ2h0IGJl
IGRlbmllZCBhIGRlY3J5cHRpb24ga2V5IGlmIGl0DQo+ID4gcnVucyBvbiBhIHN5c3RlbSB0aGF0
IGhhcyBvbGQgbWljcm9jb2RlIHdpdGhvdXQgYSBzcGVjaWZpYyBtaXRpZ2F0aW9uLg0KPiA+DQo+
ID4gVW5mb3J0dW5hdGVseSwgdGhpcyBhdHRlc3RhdGlvbiBtZXRyaWMgKGNhbGxlZCBDUFVTVk4p
IGlzIG9ubHkgYSBzbmFwc2hvdC4NCj4gPiBXaGVuIHRoZSBrZXJuZWwgZmlyc3QgdXNlcyBTR1gg
KHN1Y2Nlc3NmdWxseSBleGVjdXRlcyBhbnkgRU5DTFMNCj4gaW5zdHJ1Y3Rpb24pLA0KPiA+IFNH
WCBpbnNwZWN0cyBhbGwgQ1BVcyBpbiB0aGUgc3lzdGVtIGFuZCBpbmNvcnBvcmF0ZXMgYSByZWNv
cmQgb2YgdGhlaXINCj4gPiBtaWNyb2NvZGUgdmVyc2lvbnMgaW50byBDUFVTVk4uIENQVVNWTiBp
cyBvbmx5IGF1dG9tYXRpY2FsbHkgdXBkYXRlZCBhdA0KPiByZWJvb3QuDQo+ID4gVGhpcyBtZWFu
cyB0aGF0LCBhbHRob3VnaCB0aGUgbWljcm9jb2RlIGhhcyBiZWVuIHVwZGF0ZWQsIGVuY2xhdmVz
IGNhbg0KPiBuZXZlcg0KPiA+IGF0dGVzdCB0byB0aGlzIGZhY3QuIEVuY2xhdmVzIGFyZSBzdHVj
ayBhdHRlc3RpbmcgdG8gdGhlIG9sZCB2ZXJzaW9uIHVudGlsDQo+ID4gYSByZWJvb3QuDQo+ID4N
Cj4gPiBUaGUgU0dYIGFyY2hpdGVjdHVyZSBoYXMgYW4gYWx0ZXJuYXRpdmUgdG8gdGhlc2UgcmVi
b290czogdGhlDQo+IEVOQ0xTW0VVUERBVEVTVk5dDQo+ID4gaW5zdHJ1Y3Rpb24gWzFdLiBJdCBh
bGxvd3MgYW5vdGhlciBzbmFwc2hvdCB0byBiZSB0YWtlbiB0byB1cGRhdGUgQ1BVU1ZODQo+ID4g
YWZ0ZXIgYSBydW50aW1lIG1pY3JvY29kZSB1cGRhdGUgd2l0aG91dCBhIHJlYm9vdC4NCj4gPg0K
PiA+IFdoZW5ldmVyIGEgbWljcm9jb2RlIHVwZGF0ZSBhZmZlY3RzIFNHWCwgdGhlIFNHWCBhdHRl
c3RhdGlvbiBhcmNoaXRlY3R1cmUNCj4gPiBhc3N1bWVzIHRoYXQgYWxsIHJ1bm5pbmcgZW5jbGF2
ZXMgYW5kIGNyeXB0b2dyYXBoaWMgYXNzZXRzIChsaWtlIGludGVybmFsDQo+ID4gU0dYIGVuY3J5
cHRpb24ga2V5cykgaGF2ZSBiZWVuIGNvbXByb21pc2VkLiBUbyBtaXRpZ2F0ZSB0aGUgaW1wYWN0
IG9mDQo+IHRoaXMNCj4gPiBwcmVzdW1lZCBjb21wcm9taXNlLCBFVVBEQVRFU1ZOIHN1Y2Nlc3Mg
cmVxdWlyZXMgdGhhdCBhbGwgU0dYIG1lbW9yeQ0KPiB0byBiZQ0KPiA+IG1hcmtlZCBhcyDigJx1
bnVzZWTigJ0gYW5kIGl0cyBjb250ZW50cyBkZXN0cm95ZWQuIFRoaXMgcmVxdWlyZW1lbnQgZW5z
dXJlcw0KPiA+IHRoYXQgbm8gY29tcHJvbWlzZWQgZW5jbGF2ZSBjYW4gc3Vydml2ZSB0aGUgRVVQ
REFURVNWTiBwcm9jZWR1cmUgYW5kDQo+IHByb3ZpZGVzDQo+ID4gYW4gb3Bwb3J0dW5pdHkgdG8g
Z2VuZXJhdGUgbmV3IGNyeXB0b2dyYXBoaWMgYXNzZXRzLg0KPiA+DQo+ID4gQXR0ZW1wdCB0byBl
eGVjdXRlIEVVUERBVEVTVk4gb24gdGhlIGZpcnN0IG9wZW4gb2Ygc2d4Xyh2ZXBjKW9wZW4oKS4N
Cj4gPiBJZiBFVVBEQVRFU1ZOIGZhaWxzIHdpdGggYW55IG90aGVyIGVycm9yIGNvZGUgdGhhbg0K
PiBTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFksDQo+ID4gdGhpcyBpcyBjb25zaWRlcmVkIHVuZXhw
ZWN0ZWQgYW5kIHRoZSBvcGVuKCkgcmV0dXJucyBhbiBlcnJvci4gVGhpcw0KPiA+IHNob3VsZCBu
b3QgaGFwcGVuIGluIHByYWN0aWNlLiBPbiBjb250cmFyeSBTR1hfSU5TVUZGSUNJRU5UX0VOVFJP
UFkNCj4gbWlnaHQNCj4gPiBoYXBwZW4gZHVlIHRvIGEgcHJlc3N1cmUgb24gdGhlIHN5c3RlbSBE
Uk5HIChSRFNFRUQpIGFuZCB0aGVyZWZvcmUNCj4gPiB0aGUgb3BlbigpIGlzIG5vdCBibG9ja2Vk
IHRvIGFsbG93IG5vcm1hbCBlbmNsYXZlIG9wZXJhdGlvbi4NCj4gPg0KPiA+IFsxXSBSdW50aW1l
IE1pY3JvY29kZSBVcGRhdGVzIHdpdGggSW50ZWwgU29mdHdhcmUgR3VhcmQgRXh0ZW5zaW9ucywN
Cj4gPiBodHRwczovL2NkcmR2Mi5pbnRlbC5jb20vdjEvZGwvZ2V0Q29udGVudC82NDg2ODINCj4g
DQo+IEknZCBob3BlLCBkZXNwaXRlIGhhdmluZyB0aGUgd2VhbHRoIG9mIGluZm9ybWF0aW9uIGlu
IGl0LCB0aGlzIGNvbW1pdA0KPiBtZXNzYWdlIHdvdWxkIGEgZ28gcm91bmQgb3IgZmV3IG9mIGVk
aXRpbmcsIGFuZCBuYWlsIHRoZSBnaXN0IG9mIHRoaXMNCj4gY29tbWl0IGJldHRlci4gVGhlbiBp
dCB3b3VsZCBiZSBlYXNpZXIgaW4gZnV0dXJlIHJldmlldyB0aGUgY2hvaWNlcw0KPiBtYWRlLg0K
DQpJIHdpbGwgdHJ5IHRvIHRyaW0gdGhlIGJhY2tncm91bmQgdGV4dCBtb3JlLg0KDQpCZXN0IFJl
Z2FyZHMsDQpFbGVuYS4NCg==
