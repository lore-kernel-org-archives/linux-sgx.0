Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD7E1E5B7D;
	Wed, 16 Apr 2025 11:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744804285; cv=fail; b=bypPCQHKJjrafMmxnLAZe/cte2431RYV/nWGQDd8B7OiAepkFEVOZZTI5BEJv89pL+HYxqFTiskOTcsFH8m2zltYppan57/isZ5yU/erLmhQOaYicvB8gVO4mDb0aTZpfwAf6TzmBhVMoLHKRLiLxLtEBhEfaefBXrDUpur7ZRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744804285; c=relaxed/simple;
	bh=GuRJiZOcpuF56/AActyvzMCHKh1kQwv5pRl8/uAxKqU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GHgEZFnhYU5E11PKWSaVk/dLD/LnynJuHPUEo0cZoAWQrZNAjsNtkuuC7T3cXoM5p2FZiKSQ1iUdaUu/aiArSDK7/OQfpjcDj/xiWTH7tcQ/6/T1i8vmpC7F7seWL4uI14FOFLJMpgB28OrKxwXeLIuCNYwg3iuafIm6bRVs+ns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hJ9LUEtj; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hJ9LUEtj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744804284; x=1776340284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GuRJiZOcpuF56/AActyvzMCHKh1kQwv5pRl8/uAxKqU=;
  b=hJ9LUEtj40Og/1k/YuYVCRUDxBrOqX+bgsbWCHQDa8925F0/JPIKQsLY
   1DznM2SyVJKLFswWzoJ0oUss+PE6W8/XWaUkz8cQJAK+5t3tGOSyjErQK
   leXIUtdXn2hVXY8Uyw2un5pmq5kGPaze7rZdoJsH8W5ffT/M6n0ibjoC0
   t/99XqXiYSrV3mbPWZfXSxr5bWv0vklGFj7Qjpaw9k0KEn5MSbSHRGy8r
   hObsjvggyMOOsv7VbKsOmikn5U+izCMo8rura2SYadWLx+UtmNMUDlCJe
   J47JAnn4KLcrBy0d77CkQkAHTW50iFEoQiZYM4eYfD7qQwUq+JZ3N8rvx
   w==;
X-CSE-ConnectionGUID: yRpUHSx6QZCwJxpLFCp7nw==
X-CSE-MsgGUID: 4AMElRKwRBKJC+P8JgmtyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="57735790"
X-IronPort-AV: E=Sophos;i="6.15,216,1739865600"; 
   d="scan'208";a="57735790"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 04:51:23 -0700
X-CSE-ConnectionGUID: yVGpOBJjS4Ss3NwTSOMiYQ==
X-CSE-MsgGUID: SiKaJivDRKulz5xo7dQiPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,216,1739865600"; 
   d="scan'208";a="131358815"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 04:51:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 16 Apr 2025 04:51:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 16 Apr 2025 04:51:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 16 Apr 2025 04:51:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIgHaw92hYr/HGjHeAcROLN+2kdXcHPhGFsutYkhXD/Aj0A0FIAL9DB7hoOD5cvsfa3IunORIfP7tIfCbTFVoAq5UcyWnCUnFXxi5J5ZzdCmh8nEPICO++XNSo5pl5GQ5WsLVSmDBrdSeK48kU8GFRfOdArEeAY1gMULH9caZla/lbDBq3OkNCJ/vbtIJDfsMyKXPzQurLJ6SsbNohfKDEChTTn/gPjYCU2Rqaxbxz4R6GJ1vcGB5Qtt8VVy0HdBZFxq7IAS/kleYwr0HQXKFf2W3FzN4p75W+aGPmGmFQq3M5ucMYPDmIc2GJ4iXMeTgB5Hr9HhGCwwBCKghTH5kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GuRJiZOcpuF56/AActyvzMCHKh1kQwv5pRl8/uAxKqU=;
 b=PCG+ZlkbtJU52dG+PFD0/88PzxcMSNOymGHqPD82djGR/1780forNq2Vyqpvc+B1knK8MkWUOl1T9dTERUPXKbeeTjOD6DpAkszMJesC5OfUXbJL5bpXzPhONHcb7WNXzyPrVqtrHkkXRlZj2UAKMaSV8HMw/yEWGzzESRoiFOmSdhtCP/O1GyiezQ3cL6hO0BEg8WUx3jwPU708pSWN/9DmUqyCOv8AUXDSSpnaZscXkmjOPMBpcKFgr3pha8GbeOanvrhVxn+dSX3OrbhXsf8IKCmDzTLLh4fc88ohHL6iXNdHRc+J+pVzyXxIrsxFourAiMfXteaehDSZHfsIXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 LV8PR11MB8772.namprd11.prod.outlook.com (2603:10b6:408:200::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.32; Wed, 16 Apr 2025 11:50:53 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%7]) with mapi id 15.20.8632.036; Wed, 16 Apr 2025
 11:50:53 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Cai, Chong" <chongc@google.com>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bondarn@google.com" <bondarn@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v3 1/2] x86/sgx: Use sgx_nr_used_pages for EPC page count
 instead of sgx_nr_free_pages
Thread-Topic: [PATCH v3 1/2] x86/sgx: Use sgx_nr_used_pages for EPC page count
 instead of sgx_nr_free_pages
Thread-Index: AQHbrfzprm2QX6/IZEy34CUjpUZFELOmGecAgAAVkiA=
Date: Wed, 16 Apr 2025 11:50:52 +0000
Message-ID: <DM8PR11MB57508706F680790B3FA4CE44E7BD2@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
	 <20250415115213.291449-2-elena.reshetova@intel.com>
 <9e51630d0a376a2df426eace5c25b94641e69306.camel@intel.com>
In-Reply-To: <9e51630d0a376a2df426eace5c25b94641e69306.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|LV8PR11MB8772:EE_
x-ms-office365-filtering-correlation-id: f9b98dfc-83af-4ba3-662d-08dd7cdcf0c1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y2dUaGlJTVAzZTR3VXA2RFVtMTJNYUZtb0lyMXh0dE82K2RyM3RSYXRPV2lw?=
 =?utf-8?B?UUJWb25lbUp5Q0ZpS0V0Y3QwMDVUSGdNZ1pzZFo2UVBkNXBUbnpBT2JVWTZ5?=
 =?utf-8?B?bW84RmFxaDNlZUJwdGF2STdvNS9wb05PVlZUMWw3MkQyK01TVGQ0TmZ5a0RX?=
 =?utf-8?B?akIyaUZuQTdzOXJDS2k4cTVFVE9wSnFtZlJ1cDJ5WVoyN01FQW5xbGNBUVJ1?=
 =?utf-8?B?bGxCOENRMytocHBWRlJ4dEVMUEF2eFh6R3l0V3c0YUZqbVhtNmdoTFpZblZL?=
 =?utf-8?B?TWMxVnIvM3ZCcTB0OVlJMnVHNzRoSFk4c2ZRWWRGZFpHd0NpZFBVZWtwYnRj?=
 =?utf-8?B?SllrRWMrRWNoUHVNS283V1h5emFROHMwTS8xTk9oSXE0Mzk3VkF4Ni8zYWw1?=
 =?utf-8?B?OGRMZFdPSzRsdWdNRmkralpNU0FzTlpvNWJRWG1qZmJHSko5M2xrZFg2QXk1?=
 =?utf-8?B?b3VkK005em13cXZVaSszWEcrbzAzdUZISStmazRkSlNBbVhaN0NOTktxUUxM?=
 =?utf-8?B?a0NEb3dYUU9odm1iZ2RkOElKc2RmVEQvK3lySHQ0VEk4dFJrN1YzTkRnL3lE?=
 =?utf-8?B?WnQ2V2dBMHdFU0EzSzI4SVhFcnJzeTZYMHEvZExGT3I3MW5NZHZGUWpuMjBt?=
 =?utf-8?B?dklVbUViRTR1ZEJJekhvYW0xRStoL3BGQlNMeDBFbGhlTzZYUG9hUk5FQU9j?=
 =?utf-8?B?NVJsTHUyeGdYbkRlb2d3aUNSdHFGcjVtdTdIV3FKbGJBNldKRTRHYXpMdjd6?=
 =?utf-8?B?bnhKUHR5MU9wdWVmRE5OOWpWQ1Q1MXg5YnFtb3Q2MkVhNTh4Sys3UzhSQ0c2?=
 =?utf-8?B?dVJNQXV1MGlWd2pZdGtEa2FTS2t1aVNJczh4bXR0OHhQak12MExQVE92VmNN?=
 =?utf-8?B?NGh1U3RmNDMwOGRFeUR5MWVzSE81YWhUcE9MckUrRnZxNmQ0OE1rOHBnUE9y?=
 =?utf-8?B?QUdtdGJ6UHhvclE1dkF1UTJGczFoS2lGVWxZdFk5ZEUwZDczK0U3aEVWcnJC?=
 =?utf-8?B?ZFhYRWRsNHJyRGhnOGRIY3lzbWhiNHBPakY5bzhyT3BBNVRFakhDN3QzVHgx?=
 =?utf-8?B?RmwxTE1nVnBnT1BPTFUyRlN3SGUwYTkwSDdXK0o1NHlORDhKTVdVRjN6YjVa?=
 =?utf-8?B?aVVtUVIrNjNoRDJ6OEg4cXlPQmhhSCttRjMzVjhPZHRYL2VHV25iRityZk5M?=
 =?utf-8?B?cFlUOVJON3pPRnJKeHJaaHBlK29Eb0ZsZG9YSnM4N2hWRi8zRk9NRHlHVzhs?=
 =?utf-8?B?MjdQeFFuN3hGa0Jqb3ZDZmZoM011cEcvek1RRStjcjZHZDlOY05zN2xFdDN3?=
 =?utf-8?B?cmt2a2gxT2NwVkdOaEl4a2N1cVBsRmdyRHp2a3RHc3NuVnpuTm1nZ0hENVI3?=
 =?utf-8?B?N01jOU90dDBvekh6V0Roa0lyVmxwQTEvVW9STW1jVko3TGl2NmxnZ3B0REdO?=
 =?utf-8?B?QUd6TWlMd3lMTjlLS29YMTduMU85ZW5OWTV5N0dnN0VPL3RsMmVZenc1c3FD?=
 =?utf-8?B?VjFkemN6aUFadmNVb0NvYW1QWmxGd09OOWhST3RsZ2hwYmNKT0VZVDU0RTRU?=
 =?utf-8?B?eEk2bm1YZDQ1R0JNZjN0aG1hTFluU0tHQndFZksxYmJqRW00dG9tRGFKQlVS?=
 =?utf-8?B?R3lSRGtJTUs4ZS93Z2hvS1FHUTdvc1E5d2NWVTA3bzBmSFpPK01CZTQ4VytJ?=
 =?utf-8?B?N2FkYmljTjlOaGpSL1JTS3dqQTMwSXZ0YjBsU2tLOXJRNEdEaHpHeEpSVEhU?=
 =?utf-8?B?aTVkd3FseENMVTgxYktxN1YyZXdSWVUrd2ZHdXdNc0UvQTY4ajBJayt3VW9L?=
 =?utf-8?B?NmVRb3IxNkR2NSsxemZscGVUcjNlTWpMZWd3dGxLMFNHWHd2ZTlOSitQSVBo?=
 =?utf-8?B?MDV1ZWRzcXl1REMzY3hRYmZTb1M4ejdYNWlyLzJ3TzQxMUlSZGl0V3p5TU83?=
 =?utf-8?B?OW9ONXFVNFI1K1JsTXUrRmRqMzl6blBZVHZCR1JwZ2pUczNxWVJmTVNacXFl?=
 =?utf-8?Q?RGkgzTM3LWdnwy4EZfXlQsu/xNeBcU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUVlMHhCUHIvRjBlMGVMdmM2TmVYVnlxUkloM0d6dDdLUXNXdldnVk0rZEh6?=
 =?utf-8?B?RWZmNmtKSXNsTzMwUktUcDNackhFdmpDWkllRGlNelF0QjA3TlhUMkJRNEpY?=
 =?utf-8?B?Q3V0WklFZkF6Q2JVeTFpdStHQjZPcWNvZU9CRjVlL01oMlRoSVlVbkRCYkNw?=
 =?utf-8?B?OFFwbm03bWhKV3R5YUVrQnE1RW5UZ1pQK0JETVRRZ1FBeE5kbWorU3BGQkF4?=
 =?utf-8?B?dWRocWdGaHpreDErMjJrZUVUYVpDaDM3Mkl4M2hHNS82WHlkeTd4N0pwcU5R?=
 =?utf-8?B?YWV0c2VZZWxCL2JaelBwK1AvYmkzSC9QV0V0emRZaDl4emlwMVZCdXlzeis2?=
 =?utf-8?B?L1N5Wk0zc3JIcjVVZ014S1FXUndLYnRzQmxHWU0vdVo4cm9QcTVlaThkMzB4?=
 =?utf-8?B?Mit4MzgydnB4NFR6b21JMzgveUJOODN2VjcvMUV3aGxuT3kyeHUzNGlvRWI2?=
 =?utf-8?B?Qy9nSXlmTHVJNVpla2VKekNMSXpNT3lKMWY0bFlrZFlVbk51NVZ0WTd3OTBM?=
 =?utf-8?B?MjI2U1BTUXMzaG40Yy9qQ3RoV0pmTmZDZlNpRkF4aGpQeU1HNnpYalg5Q3ll?=
 =?utf-8?B?NE9Ea3FPWWZscWtuZ2h1RkU4bE04V3RXclJJN3FKZmthMHNzVjFOWngvanFh?=
 =?utf-8?B?elQ2R1VsNHNqaHFvVm41bXpwTk04MzVuT2NPbVhoV2w2N3VLODYvYmFqOGNJ?=
 =?utf-8?B?MUhkU1lqdHdIUEZpaXh1Sm1mdUFjc25TQjhLcHBvdVgyVlVMNUdOaWwxeUhj?=
 =?utf-8?B?TmRUT2M5M0dvSlhHd00zNWdKc2FzdEhDVDRaTGh2MXUzY2hGeEhOZnRRaXpU?=
 =?utf-8?B?cTZtMS84NGJUdEZmVVlTaTY3NFptYzRRREhFN3VPak9mcnBoRnhtTXRLU1Zw?=
 =?utf-8?B?c2ZseEVsek9VK3B4eEtNaUZwTjBwTDRsaDFWYjV4VmYrdEJXN0ZjVzR6MUwx?=
 =?utf-8?B?VTZOeGpMalY4QS9mdXRDejBzelBaa3NDck9LNFYrSkZCSmtHd1BCSnBNVEJS?=
 =?utf-8?B?by9lWFNyVGtKcGZzOGlwMDROWVRaYWQvaFFkN1U2S2pTZ1pTKzU3US8yS0FW?=
 =?utf-8?B?N2xEb08wRTRCOW1QNnhDNDF0NC9JUkpJeWdJa2x0QWwvTm5tc21KcjRaMjhK?=
 =?utf-8?B?VFBpV3B5VHdVTXlJQW8vOE1JK0xuWUdKTHh1ekFjUzNNZlRUL1pOaTlpRHdi?=
 =?utf-8?B?ZmlSc1ljL0FCaTJWeW1uQVd3RFI3anZpOG5QK3QwR2NhL0l4RXNZVytnWXpw?=
 =?utf-8?B?dTd0aGZDbXlxckFMWURmMnVSVlJpWEdHVEtqVlpuS1czTDl0MDRhNFdzT2sr?=
 =?utf-8?B?dDFzZ2kyMzR0M1dkcVQxOWwzVnRQbkk3ekxPU2MxZTZDcG1qM0NjNUk5OGNw?=
 =?utf-8?B?cEhsVWcxMmtXSGFtbnB6WXZFbzlrZGNrWnlHVlZVTFBoZGtUaTUxMUFVckxn?=
 =?utf-8?B?S0JLRHFrK2JqVWNMTU04bFdZRWNWdWRwbGNqMEN5YzM4dzc3OXdSRm8rQVNX?=
 =?utf-8?B?aDVhaVFFVWNScjJmM1kxdnZBYWdqZXVyRlJzWU56dUlHOTludUNtMXBEdUFU?=
 =?utf-8?B?Mm1GTkp3VllXTjBVZHUyanI1OGRhYi9jbnAzZ0JaNDMwUGkrSmdVVWFBODRG?=
 =?utf-8?B?MzV1Ti9IcTVIanM5dExSNno5TVcweFdES0hDekx4OFZ3TVl5UlVyYkVrcmpF?=
 =?utf-8?B?MGpjQ2VqUHRaRzJFWVM5MnJuT2EvbHJ0MEVoMnFLeTVIOS9BcHlYV2tBc1Fh?=
 =?utf-8?B?aWZMMDEyRWV0dmlrMm9HRStqbThmeUR4Q29aSnVZZC8zVkh2QUFEWndiZjY1?=
 =?utf-8?B?WXcwdS95S2o1R1JUN09oUkxJTDRPYlptTlhnNkFETUhsKzRYZlJ1R3NQQk1T?=
 =?utf-8?B?Q2pTeVVwL1RoY3hmODdGcUZwY2hRMEdvRktUS3J4cnJzU2ZRL1lKcVdQQklh?=
 =?utf-8?B?d25jTVRXVDFFdGtqb2lkcTl5TXViWCtaclM5b0V0a2RrTExmaURYMTB2c1Ux?=
 =?utf-8?B?U0MrUXZqTW5lNVp2dUllZW5VQXF5b1J3aWVPNzZWZUNsTUtKVDlzd0xDakhZ?=
 =?utf-8?B?dytnZHpwR01KVE0vM3VzYWc2VHRIVHNsWHpVQ1l5Ky9TL1dyVHlsMkpVaUVp?=
 =?utf-8?B?RkZCVkE4a0ttTG9iYThzbUQ5bG44NXJQZWhpM2ZCV3ovbG92VUlsa0RrbVlN?=
 =?utf-8?B?eFE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b98dfc-83af-4ba3-662d-08dd7cdcf0c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2025 11:50:52.9754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d0tkpUqtU+yWfJeTEqoFFD35zwcdKzXR99VWUizeLLGVb0CKXUbSy8hIk9lvj2XxPhfx9vf7C2asv6G+w0KQmyVHeNZlQAd/prYjC6hsUfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8772
X-OriginatorOrg: intel.com

IA0KPiBPbiBUdWUsIDIwMjUtMDQtMTUgYXQgMTQ6NTEgKzAzMDAsIEVsZW5hIFJlc2hldG92YSB3
cm90ZToNCj4gPiBzZ3hfbnJfZnJlZV9wYWdlcyBpcyBhbiBhdG9taWMgdGhhdCBpcyB1c2VkIHRv
IGtlZXAgdHJhY2sgb2YNCj4gPiBmcmVlIEVQQyBwYWdlcyBhbmQgZGV0ZWN0IHdoZW5ldmVyIHBh
Z2UgcmVjbGFpbWluZyBzaG91bGQgc3RhcnQuDQo+ID4gU2luY2Ugc3VjY2Vzc2Z1bCBleGVjdXRp
b24gb2YgRU5DTFNbRVVQREFURVNWTl0gcmVxdWlyZXMgZW1wdHkNCj4gDQo+IFRoZSBtZW50aW9u
aW5nIG9mIEVOQ0xTW0VVUERBVEVTVk5dIGlzIGtpbmRhIG91dCBvZiBibHVlIGhlcmUuICBJdCdz
IGJldHRlcg0KPiB0bw0KPiBpbnRyb2R1Y2UgaXQgZmlyc3QgbGlrZSB0aGUgbmV4dCBwYXRjaCBk
b2VzLg0KDQpUaGFuayB5b3UsIHdpbGwgZXhwYW5kIG1vcmUuIA0KDQo+IA0KPiA+IEVQQyBhbmQg
cHJlZmVyYWJseSBhIGZhc3QgbG9ja2xlc3Mgd2F5IG9mIGNoZWNraW5nIGZvciB0aGlzDQo+ID4g
Y29uZGl0aW9uIGluIGFsbCBjb2RlIHBhdGhzIHdoZXJlIEVQQyBpcyBhbHJlYWR5IHVzZWQsIGNo
YW5nZSB0aGUNCj4gPiByZWNsYWltaW5nIGNvZGUgdG8gdHJhY2sgdGhlIG51bWJlciBvZiB1c2Vk
IHBhZ2VzIHZpYQ0KPiA+IHNneF9ucl91c2VkX3BhZ2VzIGluc3RlYWQgb2Ygc2d4X25yX2ZyZWVf
cGFnZXMuDQo+ID4gRm9yIHRoaXMgY2hhbmdlIHRvIHdvcmsgaW4gdGhlIHBhZ2UgcmVjbGFtYXRp
b24gY29kZSwgYWRkIGEgbmV3DQo+ID4gdmFyaWFibGUsIHNneF9ucl90b3RhbF9wYWdlcywgdGhh
dCB3aWxsIGtlZXAgdHJhY2sgb2YgdG90YWwNCj4gPiBudW1iZXIgb2YgRVBDIHBhZ2VzLg0KPiA+
DQo+ID4gSXQgd291bGQgaGF2ZSBiZWVuIHBvc3NpYmxlIHRvIGltcGxlbWVudCBFTkNMU1tFVVBE
QVRFU1ZOXSB1c2luZw0KPiA+IGV4aXN0aW5nIHNneF9ucl9mcmVlX3BhZ2VzIGNvdW50ZXIgYW5k
IGEgbmV3IHNneF9ucl90b3RhbF9wYWdlcw0KPiA+IGNvdW50ZXIsIGJ1dCBpdCB3b24ndCBiZSBw
b3NzaWJsZSB0byBhdm9pZCB0YWtpbmcgYSBsb2NrICpldmVyeSB0aW1lKg0KPiA+IGEgbmV3IEVQ
QyBwYWdlIGlzIGJlaW5nIGFsbG9jYXRlZC4gVGhlIGNvbnZlcnNpb24gb2Ygc2d4X25yX2ZyZWVf
cGFnZXMNCj4gPiBpbnRvIHNneF9ucl91c2VkX3BhZ2VzIGFsbG93cyBhdm9pZGluZyB0aGUgbG9j
ayBpbiBhbGwgY2FzZXMgZXhjZXB0DQo+ID4gd2hlbiBpdCBpcyB0aGUgZmlyc3QgRVBDIHBhZ2Ug
YmVpbmcgYWxsb2NhdGVkIHZpYSBhIHF1aWNrDQo+ID4gYXRvbWljX2xvbmdfaW5jX25vdF96ZXJv
IGNoZWNrLg0KPiA+DQo+ID4gTm90ZTogVGhlIHNlcmlhbGl6YXRpb24gZm9yIHNneF9ucl90b3Rh
bF9wYWdlcyBpcyBub3QgbmVlZGVkIGJlY2F1c2UNCj4gPiB0aGUgdmFyaWFibGUgaXMgb25seSB1
cGRhdGVkIGR1cmluZyB0aGUgaW5pdGlhbGl6YXRpb24gYW5kIHRoZXJlJ3Mgbm8NCj4gPiBjb25j
dXJyZW50IGFjY2Vzcy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEVsZW5hIFJlc2hldG92YSA8
ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4NCj4gDQo+IFJldmlld2VkLWJ5OiBLYWkgSHVhbmcg
PGthaS5odWFuZ0BpbnRlbC5jb20+DQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgcmV2
aWV3IQ0KDQo=
