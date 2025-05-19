Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C632741DB;
	Mon, 19 May 2025 10:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747651988; cv=fail; b=pY1ENGNqP67pP3J4uZqtdVvaoz+45Pnx8XWwc9CqbxMhHd1d0gUWf5/ip1uq0lFUXe3MYU8vSSJ9pJv24EkxkSK/dLJy3g7B+UyN9rPd+N58Kn8FYbWMpkhEKItGTlGI8tyVAfzQAk11T9ArUlL0wRpaai/n8AcX68bW3nuLTq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747651988; c=relaxed/simple;
	bh=rj3K+d0EO+hj2R7Rk1F0kKgRQnd6v1bBCXR4Z1zIWk0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WbsuE1fknIiBcste+Aa0K2me2TmLlSJIva6k4fAHrecUqY/7TgvYC/6hxJgE6JZJT8tTmp7MFXMwtU2uiEXQMdG7mHFIRvS8vCaVaH6QyB/OIzXEpmdHI8O8SBpPD7abNljaTHBNCw9uU6ulALuBf7dE88FSzilBQg1GMgKhpHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bm1wUA1w; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bm1wUA1w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747651986; x=1779187986;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rj3K+d0EO+hj2R7Rk1F0kKgRQnd6v1bBCXR4Z1zIWk0=;
  b=Bm1wUA1w9FX8lIQDIZnD58M9Gl7KfDOVyIahU3tQr9r51xuk9iuti1TO
   6mntHY+vI/sX2HOTGlVs5P874r3dF6iRn6g1cGq9aVcd+nz1jSb1IcrII
   1Nse6Q/1lY/ohewMHKhoJbcNvLmdggYZ67n2E/36KPkc5hJRkNAXyGgPe
   bwgPpERaJ4cJUQPsFcl1k3t7Omdizu/h25h8Zg5p0IEvRNOzB/zeQX0Eq
   Or9d1YQlcJ1FfVIlQARgXCkdizgQHjbD34SOJl38JEiOAtvaVN5SIA5ep
   2psyC2kc9mCWPuWGuqORjJVBOTGBDercTF83CNgvhBEDIHirRUaCJ16hE
   Q==;
X-CSE-ConnectionGUID: TlRV3Q2ARxGCt5HpUhGTDA==
X-CSE-MsgGUID: cNLl2H5iR56fZ72KFzXgRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="59775476"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="59775476"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 03:53:05 -0700
X-CSE-ConnectionGUID: Tgt1Vp9PQGq2PsG3qU5tqw==
X-CSE-MsgGUID: d+UOiHRCSdmGsZGeDGGR0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139829990"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 03:53:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 03:53:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 03:53:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 03:53:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PQwpbaZ78WSg5S9M6gbYoPcckC/x72EcMIxeK28PDn3yRO/dnXr0WdMAiVYr24ksJO6/a6jdJAkRjSqoOCVwb2FaJAzSCffIQw8RXuqGBUjcefwvup18JWxzrtWb7R+sSqZ72GkJn3omvX9DquuSmpWN650AB4/Xd6szwsYCGmFVB0yyPVCnoHeF2XsRPkcP/yvCQOd98eUSCx9iG17uWVY17milkkZRoQqsrgz7wUKiEoKqJ6xHi74POzxG3LrXURIl/8wU8Wu8XAkBZNqaocVlnkwUk1bppn9tcf5XdOjBbbPZz6ZxeN05KomgVKS6KE7om/zPPhYoHpAmNSZ20g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rj3K+d0EO+hj2R7Rk1F0kKgRQnd6v1bBCXR4Z1zIWk0=;
 b=Jzl/SRPX9+e+SZcfeIvfHZuc4Hn8Zole0ntof6HnAK49zlb5L9Zu97UZWDOKpHUiBpDyFQdJlMhtjqF+yYosvWRzTZJOSbxtxXeTG8+L9mvs9rc2H1R5g8L+qSVGo3CmGH6hGWfaON2cG9ifvBD8Ps//cn1Vz9XBjFISz7lk6RVtQtHM1+kwt3CwlKpZi2I7CJpz1ryrkU3waxTZMfMDnqmIqp0dxM8LZNTiiv1kIGELNe3ASxMlTf0RH3O4tQ1/x9kWTqgfYlMuiba2TMeFLlMqvqatvlxKbjNdfHbhVjgPhc4PlGjpujORBgZLo9cnlP+QAdaHsQogWU2s9oT1Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB7524.namprd11.prod.outlook.com (2603:10b6:510:281::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.29; Mon, 19 May
 2025 10:53:02 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%3]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 10:53:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: Re: [PATCH v5 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Topic: [PATCH v5 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Index: AQHbyI9nTd7gTasinE6HELR9HmQs77PZxz2A
Date: Mon, 19 May 2025 10:53:02 +0000
Message-ID: <09fbf33ae17587c204e7f436887c48367f6797f0.camel@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
	 <20250519072603.328429-3-elena.reshetova@intel.com>
In-Reply-To: <20250519072603.328429-3-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB7524:EE_
x-ms-office365-filtering-correlation-id: 768ba0cf-aaa2-4ac3-b07a-08dd96c3538f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MmxHYTBobytFeU1Va25aTmhGV0l5aUNZcTdhRW9yUzdnQ2tLN3BRSldyZ1Bh?=
 =?utf-8?B?RmpPK3N5ajRya2phZlAzYmkzRlllMFAvMkNSdFhJa0tFdFd3dUtZODdDWEFE?=
 =?utf-8?B?UVRWYWc0RGpHRUxNM1hRd1BuUzBoNXpuKzlVOVhCaUdEK2wyb0ErQ0FqRjRQ?=
 =?utf-8?B?UE5rdFlLUjNIZVZKVTIzNHo1Y1lTd2FLc2w0YkRpbjd2MUk5K2o5SitMUnhM?=
 =?utf-8?B?L0xCZnEwU05qcjYwSkQ5dlFaNkkzRG5zNGdaNytJM3dkSnloNmVXNGlYN0E0?=
 =?utf-8?B?RSt3NGhGbkZ2OUtMSW9STzF2dThER3JPWnRmUkF1Vk1BTEZVeWN1eWUxSHRj?=
 =?utf-8?B?MmxVUWZGNUFlUWRNWVpsVm9CYkVTaDBMYWIrZUN5TU5PZXhkZWdPOSt4VmJk?=
 =?utf-8?B?VktYdEhpRHpMd1BURm1ackMvVndGbGtJRWM1djU1bnV4eklMWTVaREg1V2FN?=
 =?utf-8?B?YWxYbHBONzg2UG04NThCNE9kY2ZSQTZLdEw5MmdYRStTeWNnSkc0bnZ1SG9n?=
 =?utf-8?B?bzJYOXFMcmpPbEJvKzAvZFhPWklMUWJzTno4NENZR0F1ODR3REhZREM2V3ZX?=
 =?utf-8?B?TmJiUElNUmpuTHRlTFpodVV5RkNqUjUveXBSa21tc3VhNEpMcFE3RmJrcHVP?=
 =?utf-8?B?OWdQS2ZhY3ZSdkt2NCsyOXZyNE1aN29wbU82cW1zQ1dTMHFzbk9XdDVMek0r?=
 =?utf-8?B?UHhQUVVwMDhEU0kvZnhtcHZWTVF1azdPZWVLQ29obm9CWkluMlNHTVJUdXZ3?=
 =?utf-8?B?RWM1VHM0dDlwSXUvVE42Z3hjY2diZ2M5YUcrcW1Pdm1uTkxoN2k3L0ZzVW12?=
 =?utf-8?B?eWdITXVkd3RmaktuUmpkUFBLOGRhRGFXU0p2Y1hwRGlXRUhpM2dSZTVnQ2ov?=
 =?utf-8?B?STZVQU5hRjE0QW9BdWZzTjNnMDhOa3hUZ1NqcytxeUttbmtudWUzWjM1SXJE?=
 =?utf-8?B?UHpZVGJ2UlM4ZFhmc0J5V1oxbW1wTnRNeURUd2VTMVNRZXFtc2g2T01NUnpz?=
 =?utf-8?B?RmhJdDdXKzlpeGhydU1WNDByWHVWSXpiYU1mUHNCVSt0MVBuNDZHMlQ0U0hX?=
 =?utf-8?B?Z2d6VWlERnVXUmRhd3BLQVAzVFNkUVRVMzdpdm5RSWI3ak1nVC9MU3o4ZGVk?=
 =?utf-8?B?NDBFMkJtMlV4VmdXL0k5c1pYZ2lwU3kxTU55OUR4dHBrdEx5YUtrZTRSWU1o?=
 =?utf-8?B?czVkMWU4Zm9mSGRtcjFDeUpYR0l6UHpSbUV3L05jMGVFV0UyZXJieTQzNis1?=
 =?utf-8?B?NU9zTFJuaEFWbEx5cUkrNlorZWkwZzZ5T21oTkU0TFJQbjNHdVRjVk1MQ0c3?=
 =?utf-8?B?UEc2K3hxN0Z3MXlPYU5jNi83cFFsdjlpMWlldTllaEVlUUVBTEVyQU1DYXA2?=
 =?utf-8?B?ZTFuZGcyVFBFZmJDeW83eFlicVZ4bElxbXRnZGluOExYTUhLWTRlSzE0UHZW?=
 =?utf-8?B?ZjlLNFQ0OVdKcU5OelVDR0RyL2RDN0tCZHlMeVQ3Ri9RUDRwMEZHajBuVkZ0?=
 =?utf-8?B?eDNPYjNzRVp3NEltYXVqaUxFRXMvQzhrd1I1cGNjVVZpU3dzMVdJbmpNOWpC?=
 =?utf-8?B?Zk4wc011aHBLL0xrZVdVNmJjRTdoSnBFdjF5U1dBeEdYWU5JWTBLSUF6bW1z?=
 =?utf-8?B?dzB2bXZZaTF1bHBOa3NWREpaa3hidDAwUGhSVzRpTDcvaGkzYUdUTWhBWGFz?=
 =?utf-8?B?L2cwcDJFM1VFN285Ti9WdUhLUE5HemNqK0lPQ3F0VEFMdXRvNVBqWUM2YnN2?=
 =?utf-8?B?L3QyMmNVeEtodzhDYTA1TytuSEJEaFc5WVpnSmVMQmRYaitySW5xR3Fib0hJ?=
 =?utf-8?B?dnhVVDliZ2FvTHJGUjZjOEpJWWhkZGt6Si8yNVMxSHByZTJUT0Nqa2oxbGJ4?=
 =?utf-8?B?dlUyUmJZQnRNemZ5RlhaanZyYi9SQ0t5LzFDQkIxalZrUEdlK0liM1NTeEhW?=
 =?utf-8?B?SDV1K2FkMzZKZDJoVW9JaDYvTEtTUjdIemJiVDMvNlZyaWxJMlBQcGFZYmVD?=
 =?utf-8?Q?Cu0m1gkTOcLRsxI4yl8Sqn7DapAqQs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1dQMExGQ3pXa3VIbWM1U0RKMTdmUTRDck9mL0JZcmhseEFmeEg1aHhGbVdX?=
 =?utf-8?B?S0VHK1l6MEhKZHUwdXV0M3dsaExOa0h1TUJDUEJRMkpscHo3cjcycXBkcjdS?=
 =?utf-8?B?ellaR0dMdVo3TkpPOS9OUy82MitCS0pHc0d6ZWl4NUU2VjhyaitXdVJNVVlu?=
 =?utf-8?B?QmlkSUorNnlQWGFxTzBnWm1Od281Sjc3U01xZXFBblpQSWNudmRmclJVcXVQ?=
 =?utf-8?B?akZLTUhxaDA1TjNKZ3JuM3BLWE1XNVBURk5zK3VBL292YkZkVUJNM1BCaVdk?=
 =?utf-8?B?NCtoZjZQdlp1bmtBc2t5R2hoeFhzdTNlWG9NbGlCRjZReUFDTXVWYU5ub3M1?=
 =?utf-8?B?RlRlREd2ZUpVdmpNUENSU2JzKzFYYWtjQWJsSERSWG5tZUc2L2Nrc2NTMG0z?=
 =?utf-8?B?OE56cDRCaCsrL0RvK2dZa25ET2dGUmtVcWIrZ3FQZFd3eDlrQ3lIQi91YUNq?=
 =?utf-8?B?KzYySWlIcEZwQkNCSDYwdU1jaTgrVjVrUGVGSTJsOVJndDdieEN5K01CMEM1?=
 =?utf-8?B?dTd0bnJWQmwrMW9jczhBcjk1WVR3VFVqTDR1d0N4WSt0M1l6VFEzT3YxQmR2?=
 =?utf-8?B?b1ZiRktFcTJ4ZmgyZVNsb0ZnNGg0emluZFNhalBpNEtwSXVHRkw1YWhwOXNy?=
 =?utf-8?B?RmNvOUlMUUFMZ0hveXQ0ZGVxT0dEbDBqVlRDVm1TNkRDZHgvT09pQVhwRncr?=
 =?utf-8?B?ZUpYZDdwa1A3VmlraS96ZEZVZEE1dWhHYXo2QjlxcjE5SlNCSzcyaFBGRFI0?=
 =?utf-8?B?ZmU1WDlNelVDYjhYN05MNll4RnU5L043NnZrUEdJQzVCdkFPOHBhWWh1UDBC?=
 =?utf-8?B?SGlSWDhtMEx6cjJHYUZHaElxM0NJVnpFd3A0TUd0YTUxa0RKUDdkKzJZR3lC?=
 =?utf-8?B?MldkQnBUZ3BMQ1E1NjdGeE1HdUVIRVlVZmlleHZDbG9ZOVhnOWNjSjdKMjFk?=
 =?utf-8?B?MGIxOU9tVkpkVUEzNXo3aHppMHNTSlNZajlpU1hlTnIwNzd2NGgxUERBejN4?=
 =?utf-8?B?K2RVT3EzWEU3U1ZtVnBLT3BWWC9rd2RxNHoxZlFrNXJSeC9yUE1XeXhlVUxv?=
 =?utf-8?B?Wlc2Tm1YelhjcFNielRNYVFiZkFFMnZwK1AwNFV6UDJuR2E2N0xrb3Y3cmxM?=
 =?utf-8?B?RmFPellncElVQmJnWmVicFlJWDR0WmdDNDI0YkRrTkMwWEJnT3FMRHZPM1pm?=
 =?utf-8?B?N2lRbzB5QWlTUVlqWkVEdDZDanhBYXZ5OUNwR1pUd1RJSFh4QytQTjgxV1Ft?=
 =?utf-8?B?R2lQdjJJY3U4NGsxZDdtR3VnN0Z0Y3MrNE9jNmxUSnBnSE1SL1NZOVNTdndk?=
 =?utf-8?B?b09IclJMWE1FVGo3SkFmNVNNWUtpNFNVdFQrdXpjc3RkamRwREhyYytIeUtk?=
 =?utf-8?B?NnNjUmpOeFlEUFlHd0Y1TndtK0VBRnN0bUVyWHlkOXczckVmbFNzclVMQlNY?=
 =?utf-8?B?V0pjaW9yTkVhNi95T1lyL1hXRjFYTVl4ZVNteEFGbDViQ1NpdTVXdUtuNGQ4?=
 =?utf-8?B?WnZsVkhMU1JuQlNWekVWSk5ZdVgyU2xRQVpCcHIzRVg5eVp0MTBJUDNyYXZ2?=
 =?utf-8?B?czIyMTBadmtSSmlrUFNTVS9BZ0QxVmZUVnoyWDEzdlhTYlRjZ0FPaS9kOWpk?=
 =?utf-8?B?SDlnSngzU1k3c3VBS0NVci9NdnlIMXFjNzdhdmtNaGtaSHBzYlVLRGZLeitu?=
 =?utf-8?B?dGRoTGhDUkxkb3gzM3VmRW9WMFBGSzd0NlV6RENvNGQyaTUxY3pqSTZCTFI2?=
 =?utf-8?B?aU1VNEFhdUZrMG5haXpUMDg3SEdsUjBJb1hEVUdwUWdCWGxEYUVFbTlBOTQ2?=
 =?utf-8?B?OEY1TEJpMHJIQUtPbCtiLzR5a2hSaWlkbmZiSjlhMVJaTkRMY05TTFFEaVhj?=
 =?utf-8?B?Y3FwandtWGFRbXlmbHZIUHFrNXkzLzh1OUxxN1MrU3lBVGpoaUswM01YaHk0?=
 =?utf-8?B?YzFsRGlMMmEzMEtwNFkxRWZlK3RIRWRnUzFEK210MXZiRnNtUldwdERvWURZ?=
 =?utf-8?B?cTBMMHRKeXo1TDBxR29kNEtWNXp6UmVENGJ6NkllQXVTajBnNC8xZmYwN1pX?=
 =?utf-8?B?TnNsVVEzZDVGaHVkZ0FmOFR2bUM3bDExRHFiNU1Sa3FTZ1hqMUI2V0JYUW9r?=
 =?utf-8?Q?dsvv/8nhCOmOtJ8fXDr/yDGny?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <873EFE472AD75C4C8515E1A94A40F9E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768ba0cf-aaa2-4ac3-b07a-08dd96c3538f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 10:53:02.0675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6dlKCw/YRRfI/UpRmtI0DV2g9a9uGP/Zuw56iKVy3Gr7m8FVfoIWi2o9IvHf+/QzcVmY8gK8CSBOkmmClNRNGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7524
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDEwOjI0ICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IEFkZCBhIGZsYWcgaW5kaWNhdGluZyB3aGVuZXZlciBFTkNMU1tFVVBEQVRFU1ZOXSBTR1gg
aW5zdHJ1Y3Rpb24NCj4gaXMgc3VwcG9ydGVkLiBUaGlzIHdpbGwgYmUgdXNlZCBieSBTR1ggZHJp
dmVyIHRvIHBlcmZvcm0gQ1BVDQo+IFNWTiB1cGRhdGVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
RWxlbmEgUmVzaGV0b3ZhIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFy
Y2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmggICAgICAgfCAxICsNCj4gIGFyY2gveDg2
L2tlcm5lbC9jcHUvc2NhdHRlcmVkLmMgICAgICAgICAgfCAxICsNCj4gIHRvb2xzL2FyY2gveDg2
L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmggfCAxICsNCj4gIDMgZmlsZXMgY2hhbmdlZCwgMyBp
bnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1
ZmVhdHVyZXMuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gaW5kZXgg
NmMyYzE1MmQ4YTY3Li5lZDBjMGZhNTgyMmEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1
ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVh
dHVyZXMuaA0KPiBAQCAtNDgxLDYgKzQ4MSw3IEBADQo+ICAjZGVmaW5lIFg4Nl9GRUFUVVJFX0FN
RF9IRVRFUk9HRU5FT1VTX0NPUkVTICgyMSozMiArIDYpIC8qIEhldGVyb2dlbmVvdXMgQ29yZSBU
b3BvbG9neSAqLw0KPiAgI2RlZmluZSBYODZfRkVBVFVSRV9BTURfV09SS0xPQURfQ0xBU1MJKDIx
KjMyICsgNykgLyogV29ya2xvYWQgQ2xhc3NpZmljYXRpb24gKi8NCj4gICNkZWZpbmUgWDg2X0ZF
QVRVUkVfUFJFRkVSX1lNTQkJKDIxKjMyICsgOCkgLyogQXZvaWQgWk1NIHJlZ2lzdGVycyBkdWUg
dG8gZG93bmNsb2NraW5nICovDQo+ICsjZGVmaW5lIFg4Nl9GRUFUVVJFX1NHWF9FVVBEQVRFU1ZO
CSgyMSozMiArIDkpIC8qIFN1cHBvcnQgZm9yIEVOQ0xTW0VVUERBVEVTVk5dIGluc3RydWN0aW9u
ICovDQo+ICANCj4gIC8qDQo+ICAgKiBCVUcgd29yZChzKQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva2VybmVsL2NwdS9zY2F0dGVyZWQuYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2NhdHRlcmVk
LmMNCj4gaW5kZXggMTZmM2NhMzA2MjZhLi5hN2UxZmNlZGNhM2MgMTAwNjQ0DQo+IC0tLSBhL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvc2NhdHRlcmVkLmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL2Nw
dS9zY2F0dGVyZWQuYw0KPiBAQCAtNDEsNiArNDEsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGNw
dWlkX2JpdCBjcHVpZF9iaXRzW10gPSB7DQo+ICAJeyBYODZfRkVBVFVSRV9QRVJfVEhSRUFEX01C
QSwJCUNQVUlEX0VDWCwgIDAsIDB4MDAwMDAwMTAsIDMgfSwNCj4gIAl7IFg4Nl9GRUFUVVJFX1NH
WDEsCQkJQ1BVSURfRUFYLCAgMCwgMHgwMDAwMDAxMiwgMCB9LA0KPiAgCXsgWDg2X0ZFQVRVUkVf
U0dYMiwJCQlDUFVJRF9FQVgsICAxLCAweDAwMDAwMDEyLCAwIH0sDQo+ICsJeyBYODZfRkVBVFVS
RV9TR1hfRVVQREFURVNWTiwJQ1BVSURfRUFYLCAxMCwgMHgwMDAwMDAxMiwgMCB9LA0KPiAgCXsg
WDg2X0ZFQVRVUkVfU0dYX0VERUNDU1NBLAkJQ1BVSURfRUFYLCAxMSwgMHgwMDAwMDAxMiwgMCB9
LA0KPiAgCXsgWDg2X0ZFQVRVUkVfSFdfUFNUQVRFLAkJQ1BVSURfRURYLCAgNywgMHg4MDAwMDAw
NywgMCB9LA0KPiAgCXsgWDg2X0ZFQVRVUkVfQ1BCLAkJCUNQVUlEX0VEWCwgIDksIDB4ODAwMDAw
MDcsIDAgfSwNCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZl
YXR1cmVzLmggYi90b29scy9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlcy5oDQo+IGlu
ZGV4IDZjMmMxNTJkOGE2Ny4uZWQwYzBmYTU4MjJhIDEwMDY0NA0KPiAtLS0gYS90b29scy9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlcy5oDQo+ICsrKyBiL3Rvb2xzL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gQEAgLTQ4MSw2ICs0ODEsNyBAQA0KPiAgI2RlZmlu
ZSBYODZfRkVBVFVSRV9BTURfSEVURVJPR0VORU9VU19DT1JFUyAoMjEqMzIgKyA2KSAvKiBIZXRl
cm9nZW5lb3VzIENvcmUgVG9wb2xvZ3kgKi8NCj4gICNkZWZpbmUgWDg2X0ZFQVRVUkVfQU1EX1dP
UktMT0FEX0NMQVNTCSgyMSozMiArIDcpIC8qIFdvcmtsb2FkIENsYXNzaWZpY2F0aW9uICovDQo+
ICAjZGVmaW5lIFg4Nl9GRUFUVVJFX1BSRUZFUl9ZTU0JCSgyMSozMiArIDgpIC8qIEF2b2lkIFpN
TSByZWdpc3RlcnMgZHVlIHRvIGRvd25jbG9ja2luZyAqLw0KPiArI2RlZmluZSBYODZfRkVBVFVS
RV9TR1hfRVVQREFURVNWTgkoMjEqMzIgKyA5KSAvKiBTdXBwb3J0IGZvciBFTkNMU1tFVVBEQVRF
U1ZOXSBpbnN0cnVjdGlvbiAqLw0KPiAgDQo+IA0KDQoNCkFkZGl0aW9uYWxseSwgdGhlIG5ldyBm
ZWF0dXJlIGJpdCBzaG91bGQgYmUgYWRkZWQgdG8gdGhlIENQVUlEIGRlcGVuZGVuY3kgdGFibGU6
DQoNCi0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvY3B1aWQtZGVwcy5jDQorKysgYi9hcmNoL3g4
Ni9rZXJuZWwvY3B1L2NwdWlkLWRlcHMuYw0KQEAgLTc4LDYgKzc4LDcgQEAgc3RhdGljIGNvbnN0
IHN0cnVjdCBjcHVpZF9kZXAgY3B1aWRfZGVwc1tdID0gew0KICAgICAgICB7IFg4Nl9GRUFUVVJF
X1NHWF9MQywgICAgICAgICAgICAgICAgICAgWDg2X0ZFQVRVUkVfU0dYICAgICAgIH0sDQogICAg
ICAgIHsgWDg2X0ZFQVRVUkVfU0dYMSwgICAgICAgICAgICAgICAgICAgICBYODZfRkVBVFVSRV9T
R1ggICAgICAgfSwNCiAgICAgICAgeyBYODZfRkVBVFVSRV9TR1gyLCAgICAgICAgICAgICAgICAg
ICAgIFg4Nl9GRUFUVVJFX1NHWDEgICAgICB9LA0KKyAgICAgICB7IFg4Nl9GRUFUVVJFX1NHWF9F
VVBEQVRFU1ZOLCAgICAgICAgICAgWDg2X0ZFQVRVUkVfU0dYMSAgICAgIH0sDQogICAgICAgIHsg
WDg2X0ZFQVRVUkVfU0dYX0VERUNDU1NBLCAgICAgICAgICAgICBYODZfRkVBVFVSRV9TR1gxICAg
ICAgfSwNCiAgICAgICAgeyBYODZfRkVBVFVSRV9YRkQsICAgICAgICAgICAgICAgICAgICAgIFg4
Nl9GRUFUVVJFX1hTQVZFUyAgICB9LA0KICAgICAgICB7IFg4Nl9GRUFUVVJFX1hGRCwgICAgICAg
ICAgICAgICAgICAgICAgWDg2X0ZFQVRVUkVfWEdFVEJWMSAgIH0sDQo=
