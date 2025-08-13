Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669D62EAD0D;
	Wed, 13 Aug 2025 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755093197; cv=fail; b=EmDjkS9TfxouypNF/V2oS+rgLCWV447OmiTO8fzanRzTkTLZMRKzYENPeYn4QDWbptO5uX6gc9+1ACHSJxLxgipx4P33lxbedw20UzAHVVMnBqOjDTbMYs6m2K3JG0mEyyLpBKKjLYlrKk6I3otFfCQRS1MIMTsIehF5BkyYt4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755093197; c=relaxed/simple;
	bh=p4HWwey9fOeitlZ/jlAE1g1KIN2/FemMZBjWvcKlTqc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IJWrPXSnZdwYistY8XoJ4kr1qMmTqy9jjQvwSY/G/kdvGFeq95FXoA09ch4nfR6Ae36UoML54t7WSHUjyEBWwZQs6WDsqEhR8qkoNkJClATpppW+vquan7kGz69HuRWEu5hS5meEaAlrm967rUdkuVGEz7Q6uezPDu40sUiME+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MBwRw5XS; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MBwRw5XS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755093197; x=1786629197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p4HWwey9fOeitlZ/jlAE1g1KIN2/FemMZBjWvcKlTqc=;
  b=MBwRw5XS/ZFhHYh8A/hiFY8adMPtnoJCNWJCrC1AMnBrG1wLB6KOuRJI
   81+0knPYBBgBTeyiiEHi3OygQKnG1hTyvn5kLhLv56UZf6hqRmGt90EAO
   kWE/FDmPSbNV05+BXE5RtSje/xtS42Y5HZ47BJKEIMDnrvF+NZ249ar0x
   Uta90eKOc2vGpJL2AMAtZvmZH3+KGJv2pMRFx3g27gzzouhXnQ4oRGMf+
   SKUjHkGUyP2ER0l3OvGLQwjx4kvQKZYa+dnTgZwCRjyMoAXBz8gv3mLdE
   iAW16b30Sv2OkTRvRd8Ajpyfq2G2si1UJfEjiMiAL7/H3PhyvgXojJo2S
   g==;
X-CSE-ConnectionGUID: DpAzjBmsThGemvbMnebUzA==
X-CSE-MsgGUID: 9B/jNW/wSK6nmWvNbW7vJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="68841574"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="68841574"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 06:53:16 -0700
X-CSE-ConnectionGUID: jpnvF1wrQmakHJwGwQXyNQ==
X-CSE-MsgGUID: QUMqjDwxTSaFfW+B24kzIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="166846121"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 06:53:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 06:53:14 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 06:53:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.47)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 13 Aug 2025 06:53:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twb//U1x3Z2nqgj9lSIWvkT357DV95ZYSDTV+GB+yDyFMx8NSB15Td+ufMMXXJumISQf1BQeIYiU5KtqVm/2OIhWUkMcLjYyfaTN8IAL6ynpwonNrsClsRmSU4+MbNkfLjJlsHlO7uluR3p/Kww7RMg/jjukiYshZTPe6OYMlG+k5ItNIA4oix/yPAYVZ6TcsmICkfh/8QFqLTQx4lmAHYOAj/CNdyUw5KOLxalXGDOcZgFkM9Toulg3WSV7XlVSs2ZzJn4J03SdNP7aZ1p46i8hy/TIcjpqQAlGsvJ2sZmV+17dcCKlqWj0V2Rngj9Ui2LSjbKIuUY6MSVPuUWOvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4HWwey9fOeitlZ/jlAE1g1KIN2/FemMZBjWvcKlTqc=;
 b=IwKAsDHvlo3O5jC2iokQDW+Cv7ekDU/04Pd1mCH7ghsSmcBftmlqWz/qzmwMobvT2JYctCyqD67VZCzNyYkaV7PDw5vhxDUt69a6iQqfOJ6exUB3pul/gM8tqTsPzhTk3Ki769l0jWzn4rkMq+J0M1l5B2YqQmR0Ol8FQKmAwvIZ8fD2R3uV8JhEC4zMpDgCg9sUZeoB94RHtU0/EveKHKVN7krofdKhl0cYKgzBsN6177/6+27gbOfAcdzUzLOnTbX/w8H+6Dvnl7lY+LRuNt+/asTVbKEEYnKi6YY5GKXEoGv9mvtoCaLGaYRjQaRZ9AqyteqQUbwjsIRS+AngyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SJ5PPF3F833FA49.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::823) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Wed, 13 Aug
 2025 13:53:10 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9031.014; Wed, 13 Aug 2025
 13:53:10 +0000
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
Subject: RE: [PATCH v13 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v13 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcDC/ArELcfdxBdkeXQ7HX6Db/qbRgbKqAgAAt0iA=
Date: Wed, 13 Aug 2025 13:53:10 +0000
Message-ID: <DM8PR11MB5750D8CD3471F8F191B4AA69E72AA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250813085233.1369036-1-elena.reshetova@intel.com>
	 <20250813085233.1369036-6-elena.reshetova@intel.com>
 <c4fd656e3abc77a9bc0c04aef3e6354fdc40b8bd.camel@intel.com>
In-Reply-To: <c4fd656e3abc77a9bc0c04aef3e6354fdc40b8bd.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SJ5PPF3F833FA49:EE_
x-ms-office365-filtering-correlation-id: 596887e2-1b01-4000-e8c1-08ddda70bd64
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|10070799003|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?VFIxZUlnQTlYZlNNVnhpMGI3d3R3VUtCYkJNaFZGZzZBVE9EQzZxcGJrYVIy?=
 =?utf-8?B?T3g5VUhhd2FTMklsM1FWL1dVSE5xT0g1UkhheitGcnJKMUVCTDV3RzJDdGdT?=
 =?utf-8?B?eXdpaGlUSCtFRFN4QlZQYnF3SFhOd0FRODg1c0crdmZlcDkvVjZ6NGlISHZ6?=
 =?utf-8?B?UHl4d1Bqb0FwWVNzQVlYc0ZmQ2tTaG5RbC91Q2J2MUFNNE5vQXNJUU53eUlX?=
 =?utf-8?B?d2hjQ2tyTmZGRjBBODV4SDh0WUREcFRPb040RWJSOHBjRk9nd2loYlQ5Zi91?=
 =?utf-8?B?MHloalJPRjFONEVHbjBMcVNENzFyaDdrd0p5YUdZVVlMT0ZoMVVHaThZOWR5?=
 =?utf-8?B?d01FZnFxVDc0aXh5ZHY0NGs2YmMrZGhzNGw0QXI1YnRSUnpXWHFyajFkdlcz?=
 =?utf-8?B?SkNQKzhhRXdmMG4vQmh4b0planZMVWF1ak1Eb3h1WDJrQWEzS1ovZWJBamlz?=
 =?utf-8?B?MmFXNzlwcEtKWGpvUHA4QmZuOUtReVpnTGNKSVBhWXJJenNGcG5ncGZGSGNT?=
 =?utf-8?B?VUlhbUVCREE4ZUlBSTVZY2pJWGhScU50NTFKLy9zRUVGdFF3d05GUERxWHZs?=
 =?utf-8?B?eFJLaGRWa0RCUWNIOHd6VVlCbmdjeHp4Y1pwOFVSSUFiUWNKVVYwTnd3NGtw?=
 =?utf-8?B?KzZCOEY3blIzRnpNa2h4cWpGRHZCRzcrRHpLcW9YQ2dKZ0k0b0xLVnp6Rm1s?=
 =?utf-8?B?K0NwR2Z2RUJkcjhiYW9OWGt5ZWdTNkZ6WW8rcVFjQUlBUVllREtuZnAzUzcy?=
 =?utf-8?B?R3pGeWZ4c0huSWJkZ3NILzk0OWtQdDFqMG8xdW9CTFZ4OEZJUTZmZWc2emtU?=
 =?utf-8?B?VkRtMGRmQlk4WTRKZFhpM3RYRzZLcUxsa3RUelNoempndGNkZWtiTmh2dFFk?=
 =?utf-8?B?cEt0cWNZZkFoNDlxRnpwSVdnMXNrODluNzlCdHRSUTFXVWZSZit6d2EzaHFL?=
 =?utf-8?B?cjdGOE82M0ZqazU3d3VyQlExK1ZGdyszejZKaysyVjNUS0JFa0FhTHBWYk03?=
 =?utf-8?B?M0g4QVliR3dEak45R3dXaTZiRTNnbGx2YzYrK09sYi9TNnR3dGNSZURyYVgw?=
 =?utf-8?B?dkZjVzI4dU9sTnRoRkxsZ2Z2d2FTMzQ4K1F2bGtDWkUvNGZnQ0s3SitvWE1P?=
 =?utf-8?B?NE9uSnJSUHBoTlExM1M4TXB3QnFZVXJic3ppTElXd0V0VzMxWEloL3NDR2Qz?=
 =?utf-8?B?Skd6ak5OVDA5YlhiRS9Pb213VlMyQm1EK2hHaVhzVjZwbUt6c0ZTS1JvZFZT?=
 =?utf-8?B?bUV5V3RMblBONWtpSjVhM0hIZTZtdGVzYzFUQ1dZdllFaHY3YWRuWWZwL3ZC?=
 =?utf-8?B?T2dPenZlYlI4MlhnVnNZbXpmTEV0WFNicXRiK2ZXa3pVWUZPZGlpTmFOOXVi?=
 =?utf-8?B?S0p1cU9vYVdtT3NtdU5FMVYzbTlQS2xaTHlPTkhITGJLc2J3WUJQVXR6M0Yr?=
 =?utf-8?B?OHpRMStTbjJONUluUlFNZGhXSW1Iek94elFsSXpqTG8yelMyeTNKVnZQWExu?=
 =?utf-8?B?ai9RREpNYkIzZ1ZxM0NXVEpNWndiQTBMYnZFamhvVW82WVVQSVlwT2VvSXJl?=
 =?utf-8?B?Qkpic2Y5d2s0bVFMREhVQ2Nyclk0RFNkTXlGNDIwSHRTT2FwK0szdUJsZHJp?=
 =?utf-8?B?UkZJTXZkeFVkeHdybXFSNzF5MzdOaktZOEZaQ3hGYyt4dytGeEZ2SkFDaHla?=
 =?utf-8?B?SGxOQVFHUExYY0MvbGk0WjZTa2VSSU44ZkRXRlRqRGgybVZ3WEVhQXhnNFIw?=
 =?utf-8?B?VTZuQldVR21PcnRodXl3WkMrN2JEWWlCUHBKMENTWkdOZ1RmRXhpQnpmUGRE?=
 =?utf-8?B?dGxtTjAwK3RodmdpcHJrdTVGeEhJSGtNTW5WSGN0dUFVbnh0THFQUVVodmdS?=
 =?utf-8?B?ZXFhWjNPUmdKd2Y5ZmtOQjh1TGhleCtiYkdzLytWd3g3YWlOWHk5ZnhwNk94?=
 =?utf-8?B?NEtkTUZtWWs0RW1qSFQ2T0pKTXpPNGVPMm9BK2Fqd1VsajRKV2NyVHd2MzN6?=
 =?utf-8?Q?Dxw+kvpJ1Jcawu7sXKLhrH7t3UxbZE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(10070799003)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZitPTlhtYWJrNzVVcDhoSXk5Z29lZ2tkNXZ4ZmVEcGVhRU1wOGIxRDlFSVJB?=
 =?utf-8?B?MHN5QmtFU0pPM0ExQWx5djA1TFd4YnpKNEVvbEswVGREQjVtZmdNTFlXS0t5?=
 =?utf-8?B?bDYzREVzWGp3SW9LbXI1aFpjakZiSG1aS2hxckpoNFdDZ0dMTVBFVmdhRVVT?=
 =?utf-8?B?cXplVW1yMVpQOGJJNnlOT01nem9CanU2K1VVbGIzaHAzRys1K3VIOFhTU3JY?=
 =?utf-8?B?eFIxNUY1MFhtQ1RtQVhKelo2SDRRRzRBZVV1c0FjNHJEVHlmcFJaOEZwd3Qv?=
 =?utf-8?B?c2ZPdGc1VkFCcmNIR0pYOFBiVUx1S2NJUXhKOEQ4Q01uT0loZWU0WVJRRm5L?=
 =?utf-8?B?dU1oY1NXeXpSY250OVE4ejNlZ0N5WndpanN0bDJpMlNaN0ZXSEJadU9CR2hi?=
 =?utf-8?B?d0JYWGh0UFJ0SEhTZGFmY21sV05rc1d4VU9CLy9xeU5iQnZkVDN0TVk5VjZy?=
 =?utf-8?B?cElneGVjcGlLVVMzdWdSZEdzNWQ2QTA1T255cW10cTBEWTJZZEVKY2xVaTJz?=
 =?utf-8?B?SEtCT252VmdVZnA2dUd6R1o2RFpTc1NPUGhQU3RqYlpMWjRWNUVuTkZ3RHRm?=
 =?utf-8?B?UWF5Z2hHNFdJelB4NGNMNFVXbnhwSE5Qem9id0ZSakxnOGd0WWQxOTN3N2xi?=
 =?utf-8?B?a3pvRVliRThCZm5sVU9WRnJ2dHZ1VjVzdDVRWG43WnNaTFcyTlJUcCtmUCtH?=
 =?utf-8?B?ZFZKMzZPajlFd0kvOGpZSklCMnRDWFFPVVJRM2R6dzhRcXExZDAxMUpSSVFR?=
 =?utf-8?B?KzFlQ2JlaGxrajlaenNoZW04SzFIQWJaOTRaZmtwTTNRVTE2Q2lsVDFISHRS?=
 =?utf-8?B?RWJEUkxtY0c0YWxHYno2WTA4a0M1OUY1ZHN1WjJ1ZkxPMkpQS05ETE40a2Na?=
 =?utf-8?B?Y3pnTDVpWU9XU2RYZ0VTL08yemQxRXJUTGVPQWxQQXlwalhmY0pvdlRlUC91?=
 =?utf-8?B?VXlpMjZESnNWQXl2emFBaUFndEtvSHhhc2JLMUZWbUMwNTJwb1gzRGk1WVVL?=
 =?utf-8?B?dU9ZREhPZk5kSThSaXI4TTRGQzVodzgvSlN1NHY4ZnBnN1ZXUDdkYXlONFBl?=
 =?utf-8?B?WVpmeWJ5em5SdFZ4WkRhMEt3NjVja0t2WkxpeVNBSlZYa0lTQlQ2UXNtdTFY?=
 =?utf-8?B?bldWNGpDR1pJMzNCaExNZUlBRkNYclRYWlladHNBUzc5QWhWcDRNb1pTc3d5?=
 =?utf-8?B?Vm52K09LeFUvenpKRTRLV1VVdHhrSEMzOVBiWXFRcjd0TEVaUFVDMEFSVXJk?=
 =?utf-8?B?OWxGRlJ1N3FsbGdtbDdTYndLUVpkd1VibERQL1MvdENUOTJoQ1BWZDNBZWwv?=
 =?utf-8?B?eExndUEyL3hYMGJFZFlMTXJMclNmK08wS3VtNlRMTGpwdXh1aWZwMXNCZTM0?=
 =?utf-8?B?VWVpNkJ4MjltcGtpN2w3eFBvaEY2bVp1Q0NSditRYUJBWmpKenAxdG5KejJq?=
 =?utf-8?B?RXNPUTNCb0UrRFNNdWJDZWxsUkh2ZHBUbnYrWFhONUFkaDRtWjJoSUxEY3Zw?=
 =?utf-8?B?WGhzM3ppeTE2QzV3b0tnb0ZraUkxdTVlSFFwcmhmOW92UGgxaWhZRnIrTGN0?=
 =?utf-8?B?bjRIVWpNREh1K0U1ejU0ZG5Dc213SUJ5VWxDNCt6dWMvSHM0MVE2OVpIZEZI?=
 =?utf-8?B?SVFjVGl3dHZ1RHJBeE5JQWJMVGFubGxxNlp1Ym1YZWQ5RVQxT2FGZndLb3pV?=
 =?utf-8?B?YkYya2ttQ0MweFlTblhXRysxSU42eDJtU25TUVJNZGxZMVd4SWxITG5Jb1Fj?=
 =?utf-8?B?MVpBcDJWZDdadzVSVmtkYWVjNlhaTndyN2tLQnAyWjJBOVYrVWU1dzVBWDBO?=
 =?utf-8?B?YWMvMTlQUTcwREJ0cThXdGRsMnkvQ0cwQU52OWpQNXYrcVA3Um92aEVmQ0Rw?=
 =?utf-8?B?SGZwejFWUkFXSkFnS25oaElYTUpHY1ljWkNSTCthMzEzdFY2RGc5citlMlJ3?=
 =?utf-8?B?V1pmM2psWkU3K2ZnVUoyblIxV3VMQ3ZHN2V6M01GZHNVcWM4VlR6WWhody9t?=
 =?utf-8?B?K0Vwb2pRZythRXg2TDY0a3J2eWR0aWdGN05ibmRwV3dLbDR6ZEVjTFBGWHJs?=
 =?utf-8?B?d2NUVU5KRE50R1NySFNjYjhjL0M5S1pEYkYrbDA5S0ltdFVoOHBnWVpENFk3?=
 =?utf-8?B?QTdBYkRBMXFUdXNMc2p4TVN2emU2L09rNS9ET0dNRXpxYUc5NU1SR0dUNkhz?=
 =?utf-8?Q?wRbodQpzKN354HTlg69s4xuPyf286RZ5sa8JxScblV+9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 596887e2-1b01-4000-e8c1-08ddda70bd64
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2025 13:53:10.4859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WbYR8v1gNTCh4/edyLd+MGrryIkKAWuPJngbXuADdiS2X31SbeplcbfgO6jiBKFvojTBT4ZyJXBs32+DyF49bjYai82Wi2B1PaE9x48vKI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF3F833FA49
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgMTMsIDIwMjUgMjow
OCBQTQ0KPiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT47
IEhhbnNlbiwgRGF2ZQ0KPiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPg0KPiBDYzogc2VhbmpjQGdv
b2dsZS5jb207IG1pbmdvQGtlcm5lbC5vcmc7IFNjYXJsYXRhLCBWaW5jZW50IFINCj4gPHZpbmNl
bnQuci5zY2FybGF0YUBpbnRlbC5jb20+OyB4ODZAa2VybmVsLm9yZzsgamFya2tvQGtlcm5lbC5v
cmc7DQo+IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBNYWxsaWNrLCBBc2l0IEsgPGFzaXQuay5tYWxsaWNr
QGludGVsLmNvbT47IEFrdGFzLCBFcmRlbQ0KPiA8ZXJkZW1ha3Rhc0Bnb29nbGUuY29tPjsgQ2Fp
LCBDaG9uZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBCb25kYXJldnNrYSwNCj4gTmF0YWxpaWEgPGJv
bmRhcm5AZ29vZ2xlLmNvbT47IGxpbnV4LXNneEB2Z2VyLmtlcm5lbC5vcmc7IFJheW5vciwgU2Nv
dHQNCj4gPHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEz
IDUvNV0geDg2L3NneDogRW5hYmxlIGF1dG9tYXRpYyBTVk4gdXBkYXRlcyBmb3IgU0dYDQo+IGVu
Y2xhdmVzDQo+IA0KPiA+DQo+ID4gTm90ZTogd2hpbGUgaW4gc3VjaCBjYXNlcyB0aGUgdW5kZXJs
eWluZyBjcnlwdG8gYXNzZXRzIGFyZSByZWdlbnJhdGVkLCBpdA0KPiAJCQkJCQkJICAgICBeDQo+
IAkJCQkJCQkgICAgIHJlZ2VuZXJhdGVkDQo+IA0KPiANCg0KVGhhbmsgeW91IGZvciBjYXRjaGlu
ZyB0aGlzISBXaWxsIGZpeC4gDQoNCj4gWy4uLl0NCj4gDQo+ID4gKy8qIE11dGV4IHRvIGVuc3Vy
ZSBubyBjb25jdXJyZW50IEVQQyBhY2Nlc3NlcyBkdXJpbmcgRVVQREFURVNWTiAqLw0KPiA+ICtz
dGF0aWMgREVGSU5FX01VVEVYKHNneF9zdm5fbG9jayk7DQo+ID4gKw0KPiA+ICBpbnQgc2d4X2lu
Y191c2FnZV9jb3VudCh2b2lkKQ0KPiA+ICB7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiAr
CWd1YXJkKG11dGV4KSgmc2d4X3N2bl9sb2NrKTsNCj4gPiArDQo+ID4gKwlpZiAoc2d4X3VzYWdl
X2NvdW50KysgPT0gMCkgew0KPiA+ICsJCXJldCA9IHNneF91cGRhdGVfc3ZuKCk7DQo+ID4gKwkJ
aWYgKHJldCkNCj4gPiArCQkJc2d4X3VzYWdlX2NvdW50LS07DQo+ID4gKwkJcmV0dXJuIHJldDsN
Cj4gPiArCX0NCj4gPiArDQo+IA0KPiBUbyBtZSwgSSB3b3VsZCBwcmVmZXI6DQo+IA0KPiBpbnQg
c2d4X2luY191c2FnZV9jb3VudCh2b2lkKQ0KPiB7DQo+IAlndWFyZChtdXRleCkoJnNneF9zdm5f
bG9jayk7DQo+IA0KPiAJaWYgKCFzZ3hfdXNhZ2VfY291bnQpIHsNCj4gCQlpbnQgcmV0ID0gc2d4
X3VwZGF0ZV9zdm4oKTsNCj4gCQlpZiAocmV0KQ0KPiAJCQlyZXR1cm4gcmV0Ow0KPiAJfQ0KPiAN
Cj4gCXNneF91c2FnZV9jb3VudCsrOw0KPiANCj4gCXJldHVybiAwOw0KPiB9DQoNCkkgY2FuIGNo
YW5nZSB0byB0aGlzIHZlcnNpb24sIGJ1dCBmdW5jdGlvbmFsaXR5LXdpc2UNCml0IGlzIGVxdWFs
LiANCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuDQo=
