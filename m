Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C1521FF57;
	Wed,  6 Aug 2025 23:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754523726; cv=fail; b=fXsvhn9UGZuJsbzTuDs2gdT/WbEWUOVrl5vmKot7uGcTbPZ3byH+3ZUaZC4Hn4aveLKj4AE22gxBhgSxxJ/YyD3Y9nyYP6O7WBkchamzeZ0sL4MrNPtCzOsF8Sv0f9GV9x1EwmB1tQkM89OJB3RFX4ReyJ15irwZh5tDgfQ8BIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754523726; c=relaxed/simple;
	bh=G66JZBFniU+6k/9bh1tFHMsmrWg/4cR/aoLOwIKzYRo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Xnx+S5c3w7jQ7aj36+e4yzHd3hNDEQLNep6flundNFfcwhvUPOnEdqbrLL23bjGdZREtbG1ZrZzWNLYF61zxIpAClHqNHCLW459zndyIdl6+fu1kvYmpJyvx5gcfDrvL/bt9mpt5t+HzQ7wRXXFpJaSKdtDQKQBtY/EMXauSLkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nX9Ys74X; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nX9Ys74X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754523725; x=1786059725;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=G66JZBFniU+6k/9bh1tFHMsmrWg/4cR/aoLOwIKzYRo=;
  b=nX9Ys74X2RV4SjNVez/Ujtjejx+SIXTKhXCyq5YwI7dxqoiG4e7ygWdg
   czd9z7pVF5sFmqiqL5UkD9/8lqWyt3c1PdtR922ygNgdthHtPZKwsAMdl
   1XAds5+MdiC/K2tLu6WN79t8WC4PJPSmAHkotxcwCPdT3J+XcLHKMXETi
   eEFdravvs2iKca9+gvgNxO/nVAuQmDTusH2CX47JcrUIzc2a5iPktTsXx
   nrAUxAgPPBf5vW5eMPHj86DBcF1/ZtqeabIJxg9u7d8nvWr1R/s7sy9/5
   BacNAhDK3jbjqUg/jEl8aZeBVf8yfn8YRKU1uIj11Mji34l7z1xurWN4t
   w==;
X-CSE-ConnectionGUID: +f2psDSDTxGvqrTlHOtk9A==
X-CSE-MsgGUID: E5Z8xfy/TRqp/6NB5O3hVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56993516"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56993516"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 16:42:04 -0700
X-CSE-ConnectionGUID: 8xSwIx4CQVy537YqOBPxQQ==
X-CSE-MsgGUID: N/V7kmAlSxy7XD7FAYw2xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="195739315"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 16:42:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 16:42:03 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 6 Aug 2025 16:42:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.87)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 6 Aug 2025 16:42:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w/BA9FyCcfcREWiDTBPPGrM9yIGNUzilsK/YJmQ21sMumntLz1ycWUC8wlqhCWcvh5nY103Ku9wP8NqBADH0sxC4LNmQ9l70YAg0XRv7DGMbssGT3k4iNE3Mx+WSPzbm6VV/EWzm8l1LQlCKXihNqqOwqEPgj1njRwZFKBd56QADpB+ON8UP0MJ5wcDgQJnsPvlTOCiL8QwT4L4P01Tl5rtMhAGqLPIfCk9/4cpU74Lf0fAAXpJhT5MfhVkRSFDe7JuNavTLR1ZCFLJOidUM3SbzZQAveRxut2Xue/w2CqfNSiDKWCi1vxY8pINb2aDCteIurhndgMpjKyYP4adoCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G66JZBFniU+6k/9bh1tFHMsmrWg/4cR/aoLOwIKzYRo=;
 b=kw8uh//PR9ZK3gchvdVQQRbyUpZlmf2/OuHxgCX59eyEyUYSPAV1YvnzKvC+B3qlBbroR+wc1GhJZicMozaCdQmcgmM/2WnmWdocTb6anDl5JQcn6vdfp3D4SV37MYyHZVXteWmxsMBR5fDYwu5wL4PI9F3RvwkLzpV8INA7a71yQu/IEheutyKBEY6nOQsZmjXJVuG2ABMHqge9wUILKMv7pGDhC5Ofqy9LmPmB5VqB8Z60UQuswhOmzDUJxZ3DWDxa3wEfwwCxcFkn8cHCsQutrpj5Soft3amByQmzyB03AUVq/AZT42gI+UVbOY4quLpFmXNmFJT5UtubM8M8rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB8039.namprd11.prod.outlook.com (2603:10b6:510:25f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 6 Aug
 2025 23:41:56 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8989.017; Wed, 6 Aug 2025
 23:41:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v11 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v11 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Index: AQHcBqojKTrcWLF/aECHrKLiELSu2bRWSg2A
Date: Wed, 6 Aug 2025 23:41:56 +0000
Message-ID: <9f6f6ea01acf4347632f5fa773d90c1d18ff6d42.camel@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-4-elena.reshetova@intel.com>
In-Reply-To: <20250806081344.404004-4-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB8039:EE_
x-ms-office365-filtering-correlation-id: ac86562d-c4dc-4173-d7ac-08ddd542d483
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Nnc2WHhrcmZmeXpkNE1kSnNxQnU3ZkZKUDcrUjU0Tmp6emJQU3JSUTNxUmxt?=
 =?utf-8?B?Y1FrNVBIQlA3V25PcmdjZDhLajJOU00yTXN1MzB2Nlh3SjF4YktOcWxtNWlD?=
 =?utf-8?B?Z2JTaEduTXF5M1dnaVFuYmx2Q1pMRUpKV0doR2llZmlaZmdVTENWVktBQUdp?=
 =?utf-8?B?TFZOdHMxSFdYRTlacXRaS0pTVS9NVE9oYlQ1VTJ6M2hHVUx2ZVIxVTIwWUg0?=
 =?utf-8?B?MVF4TXg4QVpsY0dVTk04SXRRY3VKYU42bXVEczBsZjM4ZVNTZHB2MVdrM0di?=
 =?utf-8?B?ZGhoc2I2Ny84WDZpQkRxL3YyNGo0bEUzOVR2VXRHK2l0KzEwVFF1Z2RHTEJU?=
 =?utf-8?B?aEh3NkNKbmVNZkJ2R1NDc2pnWjN0TmY1Qjg4MTczNlJxV2I0R3hMQ1hRSFll?=
 =?utf-8?B?RDNuOXhnc3B4QWdESnM5NGNIWkZGbC91anA1TlNDM2YvOGZXRndrUVd4S1RG?=
 =?utf-8?B?eG5tMlduRGZySWQyQXE2YzVwU0Q1N3VXY1g3b3N0WWozUVlEeE5YVVpob1NI?=
 =?utf-8?B?dlZlM2FJVTJiKzBoWlN3VE5naXVkYU1FbXpSQzdEcjY4WS81TjRjbThEL3I3?=
 =?utf-8?B?aVNhSDZ6UlNtNUc1TG8yZzJzSGZqSElCTnR4Y2FkS293aTZqRzVqcHlVTm5w?=
 =?utf-8?B?SGtSTiszUFA5elVKZHRZKzdKRng3NGM4OC8wclAwYzI2R2RNNTVJTE8xUTdQ?=
 =?utf-8?B?ZWx5QnIvM3FoYXBuaS9mUDBlY2V4ZmtZRE12NlJScytSbnB2WUNzUjZtVGxj?=
 =?utf-8?B?M3c2N253cVlEWWQ5Yi9QOHhZOXk0Wkt3MDNEeG1CR0lXengvTk5BQlNsTTJK?=
 =?utf-8?B?NDlVL1F0a29hZTVOMXh3MEVSTFBveEhmSFdNN0k5WDhhSU5yczJRWk41Sit0?=
 =?utf-8?B?QjhSV095aTBDMEQ3TE5FRGg4MG5jUkcvaDhhZG1MOHhFRFZtME9mdTgrdnhn?=
 =?utf-8?B?dGNwWjhhQU94V1I4SXZXVW8vSXdaL1JxalVTMHhMbEhSVEcxcVNBSzRJVUVY?=
 =?utf-8?B?S2xhc1lYTk9DalYyUkV2bTNCa3dWdHJCUnp5aWxFY3hRUzlpdk5rSi9keGVY?=
 =?utf-8?B?S3JCdHAvdHNYTzYvbXkrU1FhcElHQ2ZMUFBENTZ5V1IxVEVZUTlhK29uNWp0?=
 =?utf-8?B?MkovczhlOXR1ZmhNdDhVRmNaT3VjNXVzR2tnbVpMdjZ1Y0Q3VHE2d1RJVjdh?=
 =?utf-8?B?MVJKWi9pUVRTSlFVVEpiTW5RbGFpNFJpWFh2MCtlVHhQMDZsU25Sbys0Nmpy?=
 =?utf-8?B?OFJXUUF5VFlNZ2hlcXk4cU1NMk8wdVFMTmdBa2xJallxd0dOTHl4RGN5WFB3?=
 =?utf-8?B?dUQrVTdWczN1ZFBVclhoOFh4VjJybkd3OUhML0xtTWZWZmZ5WlBBK29zRnd6?=
 =?utf-8?B?YjRJVVk0bWZ2V25SeitBM0xaM25scWU5VWo0OXg4OFBON1RBdlBxaXlwcExh?=
 =?utf-8?B?N2pBQUE1OGkyeWM0T3JybzhOZ2taazFxQmNkUTdJZ3BxUVdxY2xWSml2OE0r?=
 =?utf-8?B?VUdQc1RGM2F6YUhPaVA1c0FWYjg1TjdJUHNDSW5RTmltd2ZPNjNyUzA3Y2Ix?=
 =?utf-8?B?eWgzRDdNcU5CaGkxVVpXN1pLK1NnS3RqSkFKdFJUMWlsSzNMOWhQNDlGaURh?=
 =?utf-8?B?SGo2eGxIY2lic1c3STNmeGlIQ21tSi9PeGhqOXhFelJyVkxmZGVWQjh4T2FL?=
 =?utf-8?B?ZTVnOTRycGpOUHJibEpGU3NsUUl0emNwdGFhNDB1UkszK0t0NHZtNE10ZTEr?=
 =?utf-8?B?OUNkelNuaWd1U3BNV2MxUjdmaFozazh2MnVJWE5weDlwZ1B2S0FKZ28vZkx3?=
 =?utf-8?B?VXYzZWtndFE4Z2E5NFdUdzNiUDl6OXYyWXVzL21lVENtMDlFOXlWL0xBRk96?=
 =?utf-8?B?QlNIT2R6WDlwUGxWK01YcUlFcHRaOTJ1Nmllak01eGJmNmpuV0ZUWjlhRTNN?=
 =?utf-8?B?eFdUUlV6Z2YvemFUak1vQzF3ckUya21OeXJwV3NqTmtoSjg1RFNrbzYyMmxK?=
 =?utf-8?B?WXBlZVhETFNRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2VSaUt0WTV6T1E4OFNKamxsL3ExYjlRa3R2ZlRLYVNoWWFMb09RR2k2Sjk2?=
 =?utf-8?B?Sm9TNTh2dFpFTC84TWltOE00cFVzeWpUaE5naVB5a0Y5ZnUwSGhFZml2Yysr?=
 =?utf-8?B?MVp1YnBBZFQ4bVRIcUdJS3FNYUhQVUo0M3Zudy9QcWphRmZ5MWVpak1xN2lu?=
 =?utf-8?B?NWhnWXFiZ1FQcTNmQm9VK2YvSmwzSTdXQWRTS0NTSWVmWE5FRDRUQU9GQ2pD?=
 =?utf-8?B?UWVzMmJsNXk3ZGJ3WlVrbG05S2J1YWljeTBxc3QzZXBFaENTN0p4anpOVWE1?=
 =?utf-8?B?ZUhFNkRpWDdiTVhTZE1oL3NjcWF2ZVJWbXFSR1EzU1JXOWFDcFhtZVFsVGhO?=
 =?utf-8?B?RG9wNzg5RWpoMjZEUXAvSzRSR1BWR1N6YnEvWk1pRWJwQlAzelQvallwVkxn?=
 =?utf-8?B?MC9BNGU5ZW1OclNVNld0TklVZE4yVUdoYUk5R1ZYbHpjb2RlTlA1NHdTN3p4?=
 =?utf-8?B?RndMWGhMWGZYZFVRS1ZVWmZXQzUzYVk1bXNlZ0h2RzlCSlh4UVFjSHFkSHVV?=
 =?utf-8?B?SzVHZ0dyNGJxeit5ZnByd3FLci9TUXlleGt1cUU0RExkSThMeXJjT20zdW00?=
 =?utf-8?B?OXNNcFhhVGxacnFpcjg3MWd0ZkIwUVZYNEVkRFVhclplT05OTHlQbHBqV0RU?=
 =?utf-8?B?QlJXWTBNYU1SSjNjNGNjQ3paYjNPMmJFZk9rQmFYVmJMelhCbE41Tno5NDlv?=
 =?utf-8?B?eTc3V3o5V1FGWlpNdDJVTjk0dDJvQ2F3K1NvN2U5RUFLdWgwbkE1Nk1TSURD?=
 =?utf-8?B?cXFiM001VmR4dGhCaWVFaGhHYU4vYk1xTlE5KzVPSmFBdmxwbW16aWdZamFk?=
 =?utf-8?B?RjVlcnpxYjQxeXFWd2NOWkxveno1Y3NaVDhGRFpjMllEME1WTzQrNzF0L2hs?=
 =?utf-8?B?U2k5WWtjWUlCc1lIYkVPZzg0QWFVNENTUUFtZDlCUlhSQ3IvV2RNUXZWRXds?=
 =?utf-8?B?N294ZlhXTGd2VDROTzYrVW1NQWNVWnQydWovV2hTU2pEZ3VEOFBPZ21rQ2o1?=
 =?utf-8?B?anFQRVFFUVBPaVN0NlUxcmFlTXRTd2xnaGI0K01sdGxYWHBPYmFxNmhISmg3?=
 =?utf-8?B?dHA4Q0F2V3krNXgxNjByMmkxTDJGVzJTMVRiK1pFVWVVLzIzaTN3TE5XMFNR?=
 =?utf-8?B?Wm5IcXRITjc3aXFxcXNZWUNTS0dLV2Fxc1QxVXNzZWZ0VWJJY2NEdWRIMFU2?=
 =?utf-8?B?OFpiampLaEUyK2hBL3VGZzN6YUpldXhjbFgwcU9GNmNUKzdvbHRFbDNNbWRz?=
 =?utf-8?B?eDZDRXJXcUc2TFdEVUNvd3djVllyRFgwWmlBbkNTZnBKRGdRWG91bTMwWW1i?=
 =?utf-8?B?SlFGd2pUQmZ2L3M0SDFDRDBJdis5Z2F5ejdnZDIzUWJKQ0hjaVMydjBvOVcw?=
 =?utf-8?B?aGJJUlNRNXpMRjRjdnlVNzNKWWl3R1JqS0xYNzYrVDlzbWQ0aUFNdnZuZWwx?=
 =?utf-8?B?L294Ylk2WVArZ0w5aU95ejg2OERrM0hWRkF4S3BMVjdFYkFMQjZ6QjJ6cUh3?=
 =?utf-8?B?d3dWMGxpbytCY0xQc04xcGtOVzZWL0FyK2hoOHV4TWVQbHVHekx0ay9TRWVr?=
 =?utf-8?B?dW5iOHRla2lkVXI4UGxTbDU2YnVkQmJZMEY0TU80dklzYzR5M21YV0NWRjBj?=
 =?utf-8?B?K0ltYzA0U21lTlZwSHNvK1dCbDRKcCtqT3R6NXQ1UW1JdjR1cUVmOHFybnJZ?=
 =?utf-8?B?ZkZzT1ZpYUJLZThvZEw4U0szSzFnWlBzNXJmMFRtTVc4YzF4M0VHZUlIcFpn?=
 =?utf-8?B?cUkzUXJGektDZEJhajd2ekQ0OWFJaFg4S3grUWpyK0lBNU1kU3pIcmF3Q2F2?=
 =?utf-8?B?SXZyWTZPeHpYM3JmcmZIVzRwZ2tkWDdtVHduTXk4a3RvZXBKV1FWbnV4OWJ5?=
 =?utf-8?B?UFMvSHJUSml2ZmNTYUlJeWxweUgwUGNocmlscDJCTTdYTnRKQTVKdGVsT3FR?=
 =?utf-8?B?L0xhOWRTK0Q1Y2VjT1dqUzFtTFY2NE1lU0Z3amhlUHJnTXlDQjZobHRGZDha?=
 =?utf-8?B?QkM4OHBWQUd2VmxveUoyZVhaRURkZFd4d2FCWHdzcnkzVEI4bGx4SjVJc0Fm?=
 =?utf-8?B?QnFqUHlCZHFRcHJCNE8rZXRaVnZ5YmY0RTJkT0hYRDVqazhuak1kNFZZazF3?=
 =?utf-8?Q?RVThdvUHepcJJhaypc31k6ZCK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04184EF9B13B3C4A9FE6AB7C8163D98C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac86562d-c4dc-4173-d7ac-08ddd542d483
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 23:41:56.5897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0jm40Yt3Dq4ArFIaw3l/++1zSvccqzgau9ev55MnOtn7dW/peo5kdc9MFiR68xTMV373pJWPpQTRGcNQ0W2zMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8039
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjExICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IEFkZCBlcnJvciBjb2RlcyBmb3IgRU5DTFNbRVVQREFURVNWTl0sIHRoZW4gU0dYIENQVVNW
TiB1cGRhdGUNCj4gcHJvY2VzcyBjYW4ga25vdyB0aGUgZXhlY3V0aW9uIHN0YXRlIG9mIEVVUERB
VEVTVk4gYW5kIG5vdGlmeQ0KPiB1c2Vyc3BhY2UuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBFbGVu
YSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94
ODYvaW5jbHVkZS9hc20vc2d4LmggfCA2ICsrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NneC5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vc2d4LmgNCj4gaW5kZXggNmEwMDY5NzYxNTA4Li4yZGE1
YjNiMTE3YTEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NneC5oDQo+ICsr
KyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NneC5oDQo+IEBAIC03Myw2ICs3MywxMCBAQCBlbnVt
IHNneF9lbmNsc19mdW5jdGlvbiB7DQo+ICAgKgkJCQlwdWJsaWMga2V5IGRvZXMgbm90IG1hdGNo
IElBMzJfU0dYTEVQVUJLRVlIQVNILg0KPiAgICogJVNHWF9QQUdFX05PVF9NT0RJRklBQkxFOglU
aGUgRVBDIHBhZ2UgY2Fubm90IGJlIG1vZGlmaWVkIGJlY2F1c2UgaXQNCj4gICAqCQkJCWlzIGlu
IHRoZSBQRU5ESU5HIG9yIE1PRElGSUVEIHN0YXRlLg0KPiArICogJVNHWF9JTlNVRkZJQ0lFTlRf
RU5UUk9QWToJSW5zdWZmaWNpZW50IGVudHJvcHkgaW4gUk5HLg0KPiArICogJVNHWF9OT19VUERB
VEU6CQlFVVBEQVRFU1ZOIGNvdWxkIG5vdCB1cGRhdGUgdGhlIENQVVNWTiBiZWNhdXNlIHRoZQ0K
PiArICoJCQkJY3VycmVudCBTVk4gd2FzIG5vdCBuZXdlciB0aGFuIENQVVNWTi4gVGhpcyBpcyB0
aGUgbW9zdA0KPiArICoJCQkJY29tbW9uIGVycm9yIGNvZGUgcmV0dXJuZWQgYnkgRVVQREFURVNW
Ti4NCj4gICAqICVTR1hfVU5NQVNLRURfRVZFTlQ6CQlBbiB1bm1hc2tlZCBldmVudCwgZS5nLiBJ
TlRSLCB3YXMgcmVjZWl2ZWQNCj4gICAqLw0KPiAgZW51bSBzZ3hfcmV0dXJuX2NvZGUgew0KPiBA
QCAtODEsNiArODUsOCBAQCBlbnVtIHNneF9yZXR1cm5fY29kZSB7DQo+ICAJU0dYX0NISUxEX1BS
RVNFTlQJCT0gMTMsDQo+ICAJU0dYX0lOVkFMSURfRUlOSVRUT0tFTgkJPSAxNiwNCj4gIAlTR1hf
UEFHRV9OT1RfTU9ESUZJQUJMRQkJPSAyMCwNCj4gKwlTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkJ
PSAyOSwNCj4gKwlTR1hfTk9fVVBEQVRFCQkJCT0gMzEsDQoNCkl0IHNlZW1zIHRoZSB0YXAvd3Jp
dGVzcGFjZSBpcyBicm9rZW4sIGkuZS4sIHRoaXMgZXJyb3IgY29kZSBpcyBub3QNCmFsaWduZWQg
d2l0aCBvdGhlcnMuDQoNCj4gIAlTR1hfVU5NQVNLRURfRVZFTlQJCT0gMTI4LA0KPiAgfTsNCj4g
IA0K
