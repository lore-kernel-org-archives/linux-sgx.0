Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B18B33CA;
	Mon, 28 Apr 2025 06:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745821549; cv=fail; b=E8ykattULCxrEWU/FsPtuQEXJWsDM3PE6MSJEzT3ozxK8ds2gkgGv6dy5x76byDd/sHJBW6tg26R9ARrpAhmofGcPKCc0q/Qcsp/cdFnFMSn1ivHq0GqeyJy35w3V4QAVlwc8FHSJHtRqCieYOpn2M13Btewa8BzmuKQrDBcKOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745821549; c=relaxed/simple;
	bh=mfrKhj/fsb92c7pFheVWnqokP/3Ady2xRWcV//7INs0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RA9MrIgad15uW0cb5FAjSDMB6zPdUUU9bZ+h3W9yYLMKu/Qj/HWSvjRRiXpSW1n/Z+A8lxUKYlU7OHZU0M+xTwYYZkbSkP1JC2U3RDaw9yEyJaelLKF4F0qodqz8VOMgXKe5h6A9vioFrnS9zgeeagrZ5NOH81xe4Uuqs1kMEzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nv+aTWEG; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nv+aTWEG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745821548; x=1777357548;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mfrKhj/fsb92c7pFheVWnqokP/3Ady2xRWcV//7INs0=;
  b=nv+aTWEGoKlNosYqAyv1snf4SEEtB3VT5oL6MNRgNhSzP3hAtCzUWCL9
   buyimAnhyRlMIoNe4e2wA7ydJ2BTUCLSLYLYHPT/EBh+GKGlutdjYunoG
   KfOQASEs17MXjnsH/JN7Q9cl5hBVULMbpuKYUaj6Q+8IdpV2rB7DbQuJ1
   Lizm1K7AXweIQb2i3ajJAoyhIUyL9mqLfCU+m+qOnTT0tr88en89NulyI
   WsyoPlscJTigh1sgxzgt/QEKR0JwGhSxnPSkbEbRHC9wKMe1mW1Ed/7Nb
   iKMeoCPq/+94aIPbZMyiYeCx1oM1QrNNL6i15aADyUUrYPCGoI191F0vW
   Q==;
X-CSE-ConnectionGUID: HKSI40wdTFq9XfPF1LE1aA==
X-CSE-MsgGUID: n7tHv6koT6WAgeXUJEKGqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11416"; a="35008241"
X-IronPort-AV: E=Sophos;i="6.15,245,1739865600"; 
   d="scan'208";a="35008241"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 23:25:46 -0700
X-CSE-ConnectionGUID: ithqpz0zTEKGoPXAWx3gag==
X-CSE-MsgGUID: hLOPVZeKQx+hSCoO0qGMHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,245,1739865600"; 
   d="scan'208";a="170648123"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 23:25:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 27 Apr 2025 23:25:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 27 Apr 2025 23:25:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 27 Apr 2025 23:25:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iUTtVRfB6usmCxVRdfvZ3NftAGTFz8V8jJ1KPA+qNqGKxzQ2O1QWhgcLO05VNDZJWa+wzcAFPq9r24p7khxljKtkeDKDlqshHMa8Lb1p1efprvXAPyD7lSHofWZ0QbGda0Y64oqu9rNO06KXHarDfuYzqKJVYJ8nJD6oL/tcNRSKy/eB96bTXnq6OA3JhceO77XtPfZs3XcRiamO+wT+C6AxRHOQ9a/fbL3to1iGIQuEyGR3EB9V5QjO1BngHoCPuMP6DZXrnoEouBbLzxDrSXvPYN3Zmh6sX2dzoIE+4V8Xrz0T0BiVqSFKQXQLvtMJTj+uW6LcZWjUm7j+AJks0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfrKhj/fsb92c7pFheVWnqokP/3Ady2xRWcV//7INs0=;
 b=Ga/WWcbQBqkzWQmx9Qv/ze9u1QRda5YbxOWyeb/fnh2YyuQbhw4DeLGPCBAckhpYibTN95OQmNDlzqeTdE9TbKesIqqWpGG+/KhsyA0fee25PAqQDzVZVwS5YDSS3GJVDFTjlGABmOyd304Nc4izX/ujNhJR0RVTrqEQ44L5b9FA8ZRdVas4Yvw8mdI33oJwbSpMhQmCcD/8ZkBMmLaoxVs8qTHaobyS1gO43bUbVe/w/M1t7dtNy8UFOj7kEVsXSncHRjhe320dyOvV03aXm4Agdl+a074IjRTdFpAtsDRrFU8nSTZtEcO+fcuMUwJ3i/dgSia7QDYEY5qC/gigcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CY8PR11MB7798.namprd11.prod.outlook.com (2603:10b6:930:77::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.31; Mon, 28 Apr 2025 06:25:27 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%7]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 06:25:27 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Scarlata, Vincent
 R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Cai, Chong"
	<chongc@google.com>, "Mallick, Asit K" <asit.k.mallick@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "bondarn@google.com" <bondarn@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbrfzujDHiSNozs0m8Z6fqnS5FZ7Oph/QAgAXK54CAAG1QAIACw3gAgABd6wCAAAZ2IIAANiqAgADdHdCAALsMgIAD+b+Q
Date: Mon, 28 Apr 2025 06:25:27 +0000
Message-ID: <DM8PR11MB5750CBAFDCC9388A100E2E95E7812@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
 <20250415115213.291449-3-elena.reshetova@intel.com>
 <aAJn8tgubjT5t7DB@google.com>
 <f5cb3c37589791b2004a100ca3ea3deb9e1ae708.camel@intel.com>
 <aAefmNVRFc3me6QQ@google.com>
 <DM8PR11MB5750B37305B3B1FAE4F42D3AE7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAo_2MPGOkOciNuM@google.com>
 <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aApgOqHvsYNd-yht@google.com>
 <DM8PR11MB5750AB0E790096AFF9AFD3AFE7842@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAutUaQvgEliXPUs@google.com>
In-Reply-To: <aAutUaQvgEliXPUs@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CY8PR11MB7798:EE_
x-ms-office365-filtering-correlation-id: 835eb066-88a6-4a24-fcb7-08dd861d77a1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MFlKSFV4eEhZU0xOYWtrc2Y0MFl3Q3pkQThNQk52NGtHcy80SkFuQ0FHdU1h?=
 =?utf-8?B?SVBMUGRSOTU5R3N2OE9pS0M1UzdDcDBEckNVSDQ3WVpmVEEvVnFyRCtlSGxr?=
 =?utf-8?B?QXJWRk9hcWRWVS95UzlMd0V5UzhHTDM3UFNFSnlGdEZPYThpUmNmNnc2c3NG?=
 =?utf-8?B?MmhWMk1zTnM4aGZmcTV4bkxMTFk0UjI3MnNCTUEvVktVdWVwRm81QjhPRXpH?=
 =?utf-8?B?S3ZiOVlEbXlKaTczQTlsb05LYjY3OXVRbTV1M1NFbW44RjNjRkhVV0pLcFBa?=
 =?utf-8?B?UXhwMysvZnBrSnN6alFCMGpIL0xwWjBrNkQ4aFRlRXZUeHp5VkxMRzY0a2xw?=
 =?utf-8?B?K3ozOHRQYndxbEVVd0lzaXkwZWMzQjhBVWVnMlFueUh0Yzd1eG9uQ1NESXJT?=
 =?utf-8?B?K2E3TXZLUUpHWmNGOG1QSkw4RUpTdjJ2SmVHbTZFaWR4Rk5JemxDSWJmR2d0?=
 =?utf-8?B?Tll3ajljZm0rTWU5c0tFNkZZcDFpdU55Y2l2bitnTVU2eVJsRnp3WCtjcnpI?=
 =?utf-8?B?RHQzTWZtejUzM0tuVE9QQnhtUWttQmo4YkNUNE5WL0NGUDZJZ0ZoQXZEQUcr?=
 =?utf-8?B?TFRlaVh4UXhYdExvNXhNS1NiRzRnNnlmWXVSWXplN2VpcE92TXZXT1hDTi9I?=
 =?utf-8?B?YlBkRkR3MkNrNDkwS0tVUEtsMXU5ZDVhK25QVU4rNjM2NHcyT1d1SUlONGU4?=
 =?utf-8?B?TGQ4SXUybFdySWtHa2lHT25QOGIyYjROWmY3dmxnVWxxZ3NEbkZkSS80L1VK?=
 =?utf-8?B?SUhyN0lvY0k2YW5Xd29UYnRlWDRzeDNrTnpPWnJJUlprTVhMWmdrVUpDQ2xr?=
 =?utf-8?B?WDM5YXg2eXBHVVlvNXR0ZmFvcmlpV3luWG5YMFFMQWhUOUFwa2YyRWpWTjdh?=
 =?utf-8?B?NWUrS3JRRENuQzBMd3JzOE1HYzBwUjVSYUNFT0JDdCttemN3VEJWdDAxTUF4?=
 =?utf-8?B?eGhRN0dnVU5Gc0FnZ2xKZE1UR1dVMURXTkZHeE5ydFUvY2tHbjhYVHlrUzhq?=
 =?utf-8?B?NGx2VWp4UTNnQi9NYitNK0NvRzBGWGk0cmpjbmMwQ2lSeHFwZGZvbnVBQjZy?=
 =?utf-8?B?SjdwQ3FkdmtHNnVxUVVuVDk0WWNiYXQxdFQ1TGg0NG81RHpXU1hQMjJ4OFhz?=
 =?utf-8?B?WklLU2tRbTVOZk14SCt0SzZCZi91bWtHWnRQdEFoVUhuZ3FJZVpoRG83VXBy?=
 =?utf-8?B?WVJpcFArcGRFMCtSUUdNMTBMVVhydGUvM2xpTUROS1VUek9YS0wyOGFKWWgr?=
 =?utf-8?B?K1NEcVlDZTFVTDRYRFJVV3BGc3dMR2dOejZKSHFBbFN6S09TYW1WZTVZVGEz?=
 =?utf-8?B?dDV0YysxVFgwaWF6U1hkMHFTWmZhSjJDZlRQZXF1cnVwaEg0SmJyUThuL2xt?=
 =?utf-8?B?UzlLYnozaWhUelNGaEJ1dWNZVzhsUGQyWXhMcnk5SldiZVNSdHlQenVaNUdT?=
 =?utf-8?B?UGhtU3BFQndkcXREeGI1S2lLUERiOTVuT0kvY2VtWWdQWStlK0F2b2VQaEY4?=
 =?utf-8?B?bWowZDl4YmI2bmw1Wks3S1lIRjFDRndrVUdUMnFObmhIaWNHZkV5NDZGZ3Vi?=
 =?utf-8?B?TzNDdVoweHhWemwvRXE3YXlMSk9vdE9qTGxSNmI1TVR4S0c2bkZXckpJSkRz?=
 =?utf-8?B?c2Q5bERMN0YxMnl3dTlVcnBjOWc3d1JDaTAwNlFpM1pEaENnbjc3cC95bGJp?=
 =?utf-8?B?VVR4SjFWWFdoZmFJOFVNQ3RHdVVtVFVrYWhva0dzZDlPVXpPZGlKLzZwb0R3?=
 =?utf-8?B?RzhCdFNaK0RuanRhRmJWOTNpdzB5SjQxTDlyNDUxVmxOYkIyN0lPQ21PMWhh?=
 =?utf-8?B?MnNVNFl4RnZ0TDlqbTgzUk0vdGlhY2h5bE1KSTlsT0JPRWZqckVWclVNZTFV?=
 =?utf-8?B?NmpxMTAzS09uZXh4WnZjMjVQVmtIT0lyTkFDQUY0ZWRzOGlJZ2Fsd2poNlox?=
 =?utf-8?B?YmFDZjZITm1VS0tIeUhMT1NhUUdCenBJcitNZms3ZjM0VVVWMU9kWDQrMWhk?=
 =?utf-8?Q?pK9tzhuaGE1d+0jGyD91eZWunalc6g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0xkbThNTnZNbUVsemtIM0VJYUIzdTJWamFDZkRjVk93WitLemUrZGxVaHAz?=
 =?utf-8?B?MXVqK0pXdEVlMnJjbmM5MWN2YXBuZ216dVRTQjBva3hMVWFvZlVBNFRYNFEv?=
 =?utf-8?B?MHpTRjJhOEZBSGVSYkdQM2lYNklFQjd5YUFIZGdpWDQxSFJtbjZSVmhXZEth?=
 =?utf-8?B?MDdKcWRQZ1p3dTREaGg4RmUrUDZaWkJ1Y3lrSHdlOFZ1TzZFMjJuVHJWYXd2?=
 =?utf-8?B?NXRDbk1wc3JnSWkwSjREakVGbDFSY2ZHQUt6SjVNeWthLzhJcklnczEzaFcy?=
 =?utf-8?B?U3lIei96Z0o0bWMyeVJDQnkvb3I5UGJtUDJQeU5JZnF6RDNjNnJCeDBEeHhG?=
 =?utf-8?B?TXNubSswT21lRGVNTkJycCtnVzRGeVg0bnNYZCtHTFJ3bUM0VE1zZFBwcVB4?=
 =?utf-8?B?MmZodndXZ1QxeXhRWDRxQS9wamowdDE4WEUwM3NmZDlKNjdtM3REUkRvWmh5?=
 =?utf-8?B?UUdKUUxwOE5rYlpKUXFySkZRUDJkQmpIOWIxZDFmbGZ4a2hFMFhqU0RwcVRz?=
 =?utf-8?B?V0F3NmowRzFPYkRXQUxjQm4ybXhQeVVucmcvSTBsbmttdlVxcWdlWnlaNUJF?=
 =?utf-8?B?WUZVY3JwdXFIVjhxSER5Y3NLTVVDdGNJdHoxK2lRRGVhandJR0dTL25wSU13?=
 =?utf-8?B?WEVHRUwyT1Rac1p0SXVjUnQ2UWNTU1RIV1dFVWVCemJVdW5VV24xd0hnKy9C?=
 =?utf-8?B?SmFmbTNZR2JGV2tJbW5jQWhadDd0bll4ZlBwRElDaUpZMTRKMzBVb1pOV3Y4?=
 =?utf-8?B?Y2wwdmE1UHh1SDk1ZWhGbW9NR2dHMGpjeERGT0hPUitvQ0trTkE3SE44SjVD?=
 =?utf-8?B?UC83NkRBTlh4L1gvbjNaMEZGR2YrOGtZaUJobzVLbDI3eFdFOVF1SUJzSk1J?=
 =?utf-8?B?RUl6RElHNnlocis2dFkwQnFxNjJYMEJtNXZ5WmhxUldWUDArTXg3cTJCZ1ZX?=
 =?utf-8?B?enptQlJ1ZDRKUGE0ZjlhaXk0dGEySTVvZjBDNTVvQ2NJY1RmMk1yNVhCOTYx?=
 =?utf-8?B?NjJGekN0bXhCVW9EQnlRQ3dhWUM5azN5TVE5b2Z3dFU3U1UzLzl3R3oxc0dX?=
 =?utf-8?B?VUJITFNueHBGbiszZzVEYTdEQnd6ZCsyYm9HMDVhZ2U2aFllanNmRDBHQy90?=
 =?utf-8?B?SDNWbXVLVXU0VlNIT3RocXFrcDVxZk1Mb3k0SUFmVS9kNW9xQUJ1WTYzQytX?=
 =?utf-8?B?aFBVUWJzL0EyV3hhd1V3MGV2a1RzSmtRRlcwV2hKMUhrMmY5NXJBZkJaU0h0?=
 =?utf-8?B?SzVydGNJbW5YazI2ZlN3T1BrWlRDZzlSb0lsL0dDdjhrSFFPRUVvV2pwd0U5?=
 =?utf-8?B?Vk9GZUZzRGI1aHdVbzlPWThadThvdTYvYUlUdER5ZHRxeVNsM08rbXd3RkEx?=
 =?utf-8?B?SHlFbFhnOG5wdnNlVlJjdFo2cHRIUEVsLzJGME1SOFcyRVNUR3NLWHc3NHpB?=
 =?utf-8?B?OUIrblRPWWt3OEhJbmxzeS90aWhsYkZWdXA0aStuRGFzOTZIemNNKy9nR1pu?=
 =?utf-8?B?blJveTFUWXdoQ2JNVTdkM3JuYkVvWGMzekQra0NmbDMyQ25XMjNPb3p4UlRN?=
 =?utf-8?B?M1dVYWlhaVhVdHdScER5Z1U1RHpTNFNwblBNb0U0UmVGSHBlUlE0TUlVcGRN?=
 =?utf-8?B?SnJIaHY1Vm92RVN4dDllcUVUc0owODd6N2h1VVJvbndWREQxK2lacE1mWlpG?=
 =?utf-8?B?bzNWV2l3b2tzVElra2pyRmswTW1GM3JyeC9rTXJ4Q09Ld0Y0em5STVBvS0d4?=
 =?utf-8?B?YVU0VHNDSDB6RFRxWWRUa3V3a0lTdUUxRExqRlZNODhoUGZyYlpSdlF3UU42?=
 =?utf-8?B?elBVZ2xDcHBrNDgyYkV0cjM2UVIwcFNiN21VU0x6YnpqdlFYYVNhbHh6OS9y?=
 =?utf-8?B?THFJKy9PNFVLQ0krSFY3MEhzb1laemxtQnA3VTNwVkN4YlppaEdYbUV0T1Fm?=
 =?utf-8?B?eDl5dzVBeXNsck9UcGFRWkV4Y1Axc2IraUZZQTdtTXZ5NlBVdi9md2ljU3Zi?=
 =?utf-8?B?RkwzalRwdyt0ZmJ0bjE5NFIvZmpQOXRXdjZPbmMzcUExMVJRd2tNY1FuQnRC?=
 =?utf-8?B?QjRYY0FNc1ZTUjRwVHMxMHEweHA4QWNtRmtvZ21WbVJMVUp3YVhmVnBTc0lL?=
 =?utf-8?B?cExQMzdzMGNmcXVwWVhIdG9GdlE2UE0yWkNlUCtiR1ZxckFkdG9aSDY5TDU1?=
 =?utf-8?B?eEE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 835eb066-88a6-4a24-fcb7-08dd861d77a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2025 06:25:27.5342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zt9m4waN+13WhJbOJU01ZVL9U3p9ujiMB665FwBm+F1nFtORzLaOol0754Xe7cF+KerV7Uas+QdmCl+IZp2431EEKM6V+kZP4Ui0RiVJzWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7798
X-OriginatorOrg: intel.com

PiBTbyB0aGVuIHdoeSBvbiBlYXJ0aCBpcyB0aGUga2VybmVsIGltcGxlbWVudGluZyBhdXRvbWF0
aWMgdXBkYXRlcz8gIEkgcmVhZA0KPiBiYWNrDQo+IHRocm91Z2ggbW9zdCBvZiB0aGUgY292ZXIg
bGV0dGVycywgYW5kIElJVUMsIHdlIHdlbnQgc3RyYWlnaHQgZnJvbSAiZGVzdHJveSBhbGwNCj4g
ZW5jbGF2ZXMgYW5kIGZvcmNlIGFuIHVwZGF0ZSIgdG8gImJsaW5kbHkgdHJ5IHRvIGRvIEVVUERB
VEVTVk4gZXZlcnkgdGltZQ0KPiB0aGUNCj4gbnVtYmVyIG9mIGVuY2xhdmVzIGdvZXMgZnJvbSAw
PT4xIi4gIFRob3NlIGFyZSBlc3NlbnRpYWxseSB0aGUgdHdvIG1vc3QNCj4gZXh0cmVtZQ0KPiBv
cHRpb25zLg0KPiANCj4gRXZlbiB3b3JzZSwgcmVqZWN0aW5nIGVuY2xhdmUgY3JlYXRpb24gb24g
RVVQREFURVNWTiBmYWlsdXJlIHJlcHJlc2VudHMgYW4NCj4gQUJJDQo+IGNoYW5nZSwgaS5lLiBj
b3VsZCBicmVhayBleGlzdGluZyBzZXR1cHMuDQo+IA0KPiBXaHkgbm90IHNpbXBseSBhZGQgYW4g
aW9jdGwoKSBvciBzeXNmcyBrbm9iIHRvIGxldCB1c2Vyc3BhY2UgdHJpZ2dlcg0KPiBFVVBEQVRF
U1ZOPw0KDQpKdXN0IGZvciB0aGUgcmVjb3JkLCB0aGlzIHdhcyBteSBpbml0aWFsIHByb3Bvc2Fs
IG9uIGhvdyB0byBkbyB0aGlzIDopDQpTbywgSSBwZXJzb25hbGx5IGFncmVlIHdpdGggdGhpcyBs
aW5lIG9mIHRoaW5raW5nIGZ1bGx5LiANCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuDQo=
