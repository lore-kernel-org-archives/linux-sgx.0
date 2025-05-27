Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FBC35973;
	Tue, 27 May 2025 08:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748332952; cv=fail; b=uewMZPTcIc0cSyQ2F4iigqNKbT+FyPMKUywuIYRQwjorsbouHbxUWgCfh3cC0yl93UmBAV5IOChrOVoAavE9xjAs5ImEtbehMSnzj1VH7X8OkTcfB9jebc/5Zgmk+0u2kLY/JqudsRpjaM7e6UmVwqP2qEKw0GeynbaYna5q42Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748332952; c=relaxed/simple;
	bh=DPIFoJGXsQismhRWv7tHMSI3ToYsNu4/DyvDnUDZmxY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F+RArijJJftitDAqHVjs/C1RdDwxUhwaapFGoAjbmTcwiWCsiigYxNlROUTgWQQ1wYq3g9ErL2iI9yQ4iszAPZODfrF/d9ye3Vzc5UOq5t2lmP6FXBdklC1a9iXN368Kd6BzjFEGcOB602PZCyfj0aKG1N4KnYs+I10l/Wq4eDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JuiCkhm5; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JuiCkhm5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748332950; x=1779868950;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DPIFoJGXsQismhRWv7tHMSI3ToYsNu4/DyvDnUDZmxY=;
  b=JuiCkhm5G3VEUirQ1viguKSPtPIQ1e+5zEYDfW1JDcYMm/KRuAMQuICQ
   00Bbtpdwa3Shd9+tPzI4Igwnja3RfDUtIOJTfN9Lc4RUg1MvHsEgbVrfC
   CsdqpClM71QLxdlmFmEosMoLXttgz9SL1zTI0pm94APyUJpB7nyxHbvdx
   0rMBVc0mgGqGRu+QxRIg6EOWQMKx0C7rIk1YDPoYXUh8xnW0790+kYZ56
   FQ/ZRAdRCx8FQUdgcJhAN0B9rKJmMIU0OBxTpZI9YgEPymHPHJMMDacVp
   EftSlYNvUyTikAdXiSTIBN9in5vvTgOzMYx4VdzU6zclRWLVqdnfcBQsO
   A==;
X-CSE-ConnectionGUID: A1l6i82rS+m1Vau1vEIkvg==
X-CSE-MsgGUID: A5KwmBGWSH6bZkmsc0dHAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="50189625"
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="50189625"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 01:02:29 -0700
X-CSE-ConnectionGUID: LK9J5LwrRMO6mNA0B3hGkg==
X-CSE-MsgGUID: lk9K22dAQf2V/HIt2IwpuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="165900173"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 01:02:28 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 01:02:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 01:02:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.86)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 01:02:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ONz+lvIHJLcMMm+93MFgmfl6C5RlI0VuGNXtnQgrNaexsX5zfs+3R4YySL8agncXj7nGGRUYcoHGUCHfJHlt05KDRV8srSBxsj3B/dvU+HREx09SsWQ/of/K3zKim6RXAut6RBSRfs/QFjHDDqW7V2MwBdZcgmmhGOQzVngOpxxMwaSQ5uS9Ugsi7AD4k7c1wOlba6T2wzdUBhZraUb9nWfkPPpQ72qWKSxVrUJH+mAEzqlo+3oXUUhE16LOI2PfcNruaOGbVvYNIO3Nu62/v6t60yfLEi5xDuhiu80yrmr7QvpSub12maHt+xjo12mmxwgoYYnB8cBud+mn0yEr8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPIFoJGXsQismhRWv7tHMSI3ToYsNu4/DyvDnUDZmxY=;
 b=Gr5bJvB/uAkjF+VXq4gVVBWkGV/vQwL46pE2qC/o/qMeHIPt3AjPesFOEspwEp0YzjPlJMc75iQ1rbO1rhGELxgA6qdKyjAQOZJaaUCn3eK9j8MPxemLIQ8DmaERyKDbB9mWYCegOZZSOC5X7fwialATtN3tNpceHr2cBmNlJkX2fJJHBPbsg84sevVKBHt+meZ774CGJfWatahVJ5vQcM37lCANJD0m0NOjR1f9BAgv6zwZ25HzQuLzF9/Ujtp0q+aN4xpqx5HMaczI1vmt1IGRI6RRtz1WFWsdVhK8OGC7xjpBjFKzYO+IZuTYTLSk4fXf/GASQ/w+hsnx3CLsmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DS7PR11MB6247.namprd11.prod.outlook.com (2603:10b6:8:98::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.26; Tue, 27 May 2025 08:02:24 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%5]) with mapi id 15.20.8769.025; Tue, 27 May 2025
 08:02:24 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "mingo@kernel.org" <mingo@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: RE: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyvsquqNiUCfiSU2V76ezJnd3LrPgX96AgARwvYCAAMLNgIAAkZ3g
Date: Tue, 27 May 2025 08:02:24 +0000
Message-ID: <DM8PR11MB5750BBD9551D9FEE3D501F1AE764A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
	 <20250522092237.7895-2-elena.reshetova@intel.com>
	 <aDCaH2WAMhLhFAVE@kernel.org>
	 <DM8PR11MB5750056460866A573DBB8603E765A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <b0b96b9c7445f39c653f5cbea0f808c8bd53cd1a.camel@intel.com>
In-Reply-To: <b0b96b9c7445f39c653f5cbea0f808c8bd53cd1a.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|DS7PR11MB6247:EE_
x-ms-office365-filtering-correlation-id: 32107ad4-6ffd-43b0-f54e-08dd9cf4d0e7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?dEhET2U0eTdaV296OGdLU21mdENHaTN4ajc4N1Z6dGZZMjNHWFNYQS8zazd6?=
 =?utf-8?B?akZITUxTRWZkM3BFQ3pXMXdZY0xvTXh2UU9BNm1LNmNJSTJkSFBqbDQ4UUlG?=
 =?utf-8?B?NVp0Q0NIN3ErNkVRRStiSFM2YkYySVcwTXdxZzRCZDVRdkR3eVNiWEVhODZL?=
 =?utf-8?B?YjVvVFg2K0VVcXRxMERFRUwyVlRSeCt0cmJSRm8wVVlZL3NFNTZYVXN6ak0r?=
 =?utf-8?B?ci9GZDVqNjdrTW5Gd3E3aFlsY1V6TlM3QnNzUDFLNjlhcG5hRzhFOWtxcmEz?=
 =?utf-8?B?bHZsbXVBRW1yL29HU3htR0VSQzNJcXF5THphMWd3QnV6VVducnBsSVY4VmpE?=
 =?utf-8?B?eDQ2YlRFa29sSFNCalM2M1ZtTnUxZ1hLTGVaSGVvdS9mVndEeCtTbWw2UUhP?=
 =?utf-8?B?VlpIaXN4SC9OM3lyWUJ6Vk5aTWlBMlozSWFITzFOZFphRGZQL01vRDFtd25y?=
 =?utf-8?B?K1ZyaC9qVklBekN4U2VKOVBFRkRYc1ZJSllQSlpBK1kyd2lybjJSZGNjRFhq?=
 =?utf-8?B?L3QvZndDTy9VQStZWkltTUh0Z2FaQTFDdXZzanBGK0pYY0xqWkhxUDBXb3hu?=
 =?utf-8?B?aW42bUpQZXQ2MEdKQ2E4bU5hRWJoR1NZcDQwemVPZ00rRlk5cWlMM0FHaDMx?=
 =?utf-8?B?dUhGYlRtUzU4Q1BNcnA5Z0txcVU0cXIrQjdyZ1VmbDBYOXJzaGFkWU0xMk43?=
 =?utf-8?B?L2p2Z2t0R3BMYUVaL3BBU3crRHBFWlhwV3JSQjZINTZuNGJzN3gwK3UzZU1v?=
 =?utf-8?B?WnVlYXZWV2c0MGlvZHd5cVhUMklkemUxOS9YUmtTc2NuV0UvUzBEOHNvSUQ5?=
 =?utf-8?B?QXIyaUxERWppT2N2eVZQVjJrQVlzNFUvM0xzelFCcWdUaVQ0ODlVellFeWJH?=
 =?utf-8?B?dzhteXpjM25RWXB3aUQxeUJYQmdkRDh2TEJMb3NxaDlDb0JBY1RGbkZOYnNa?=
 =?utf-8?B?OEFhQXBPMFpzdnIwME9QMnNsM0xGM1J1ZzZLSTJUTzhUNCtTWmxLWE1neUU3?=
 =?utf-8?B?UHhjcXB3RWtpdWV2enEraWVISzBEK2lvWFJhVGhQd1k2R1pmTmJJbG9jMW11?=
 =?utf-8?B?ZlR6RTluREw2Snl5Z25nUjhGUk1nRmJVN2FFZ1U5Qkk2ZUJhMkltUENnMXZ1?=
 =?utf-8?B?cFdCbHBodUt6VTlPUEdlWUp2SVR0MkN6SVYzaU1OdksyS09Hc056M3BXSTl4?=
 =?utf-8?B?eHZIeUZ6aUxXMm9ZTWo0YVJWdWNFNTVpMWtmN1JjR2JmekFFTkJ5ekZWcVhK?=
 =?utf-8?B?bXJLWTg5OFdLbjlOY2RMSWxIYkJ0eXFhQnMyeXBjS3VOZDdEQlJkUlBZR09L?=
 =?utf-8?B?WDRnSERmRmZCZkFHYU51NlhMdG5mSlo2L1BNMUVteTdlUzViS1gxem52b3hj?=
 =?utf-8?B?eTQ3VFB5WFl2KzEydk53WnArV05FS01GdGpZRUZ5ZFptci9iZFRCWXdPZGw3?=
 =?utf-8?B?TU9ubFF1OHNGTUUySDlOMCttY2xWOGs2Y3p2Q1J4bkI4THdrbkF4dml3VmFr?=
 =?utf-8?B?UXZ5STVRQUd2K2d0RDZPRDlHTnNxMlB5ZjhQQ0hUVHJoT2N6a2NaOURwY1NS?=
 =?utf-8?B?WDYrL3JaQkRDY0RwNkR2NzFyUDRPSlQ0cU05UHVad3A4cXJ3NzlqV2VGZmNC?=
 =?utf-8?B?RlBVM0tQTVg4ZHhTek03ZVN0U3VjL3BtUWpXQ0xjWFpNM0lIMTFQdk1Tb1hD?=
 =?utf-8?B?V2RnUEtFTWMwaDV1bFZMMXNzVFg5T3hzR3RvMENPRkViL25mTldEY2x1Q3Y5?=
 =?utf-8?B?Vk5DK2lQRVFUeUdWb2xTZFJZdE1vNmxlVWpBYzRteXBRelEyNGJCcVprRHZG?=
 =?utf-8?B?REZsMldhUSs1S0l6TGdZWCtNNE05d2FRSEd5ZUQ4Q2FQNEtNbXp0SDVNWTBn?=
 =?utf-8?B?MlVRQWxyaVZBTEpuWDkvcHdjMzlvY3NVVTdRT1QvRjJvZkQ3Umc2d2hRZVd2?=
 =?utf-8?B?MHpMQnJaajlkU0dvakU1NzNOUjRUT2QzUExXV0ozbEVEdVZpNWwzeklURmNQ?=
 =?utf-8?Q?IewSoPdPc3QeU/G2w164KpkXFRHQx0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V25qZ2d1SFdiTEFHeHl6SVZhRm05cXJTMzVlUHpUNGVxNU5mRDJCZkdlRExG?=
 =?utf-8?B?enR1MSszbGZMNjVUeTNINTZ4YnorZnRDS1lwRmlnbEtqUFErOEdlcnFFRWpV?=
 =?utf-8?B?bDNScE5LTENadlQ0RW0xd0JRdXc2TmYwOTVLdTFiWkFUZGE2SHFHV1pNVnJs?=
 =?utf-8?B?N0Q1K3JTR3NZU1J5bjloRFlOVUc5SFI2VHQzSE9rTUgzQUxSaUFvWGtPaTVC?=
 =?utf-8?B?RjE0eHlxV1dpWFNWUVl0QTJQU3dvRCtIOXkwalN3RkRTMFBWUzR0UVp3RE9j?=
 =?utf-8?B?Y3E3aE5sbFcyd0p2Ykx0eDFBUEVrTm0ydG1aN3hNV2lGSHNrMmd5RjFBai8v?=
 =?utf-8?B?eXhtdjMva3lJZGpyNzB0cGpuTDRKNE8veGMySlI2SHdtUkxjbi9qQjQ1REhY?=
 =?utf-8?B?ZFpVUUlwODVETzA1bENhaEJqRlp4dnhkYjVQS09MMWlzR05pbCtKd0hVZnh4?=
 =?utf-8?B?YXVjbzlsTVY3dW1wVWFjaEdrNll1dGJaMDZZdCtFdUttdFRJR0R4SVZNelZG?=
 =?utf-8?B?bG8zb3BDQklQV29BTFZvRkJZZUE2WnZySmVIcHBUT3I1bTVuTTZacmNjZGxQ?=
 =?utf-8?B?UFhsYjQ5M0xPRENyS0ZWNWI4MlFlYVVhQmVleE40NEp0YzhURFB2ZWkrTmQ5?=
 =?utf-8?B?VkdwU0FNZjUvZS91b2NvcWpOZFliSWZLb05xT2tvcVdUZGxPQzBncU5wV3Nt?=
 =?utf-8?B?alRkaTNteThFVHhYaUhBUUNMSjZ5bEFVelhRa2U5RUZOdEFxcXg1VkhLOExM?=
 =?utf-8?B?TytIWU9Uek9hS2FLaW5SaGZ0UW9WYk4yRmZiS1RRdG5aYlQ3QU1WRSt5MFpL?=
 =?utf-8?B?TDVPVWF4dTY1L1d4MzNvelZQaCtuMWUyb1JBbEdYWitLZG1OWlU1bFNjNmx4?=
 =?utf-8?B?a3c4WDJQcDd5NzNXcGZBeFFBZWlmalFkbVdnRng1OXl0WG5weU03dnNZenhw?=
 =?utf-8?B?dm1wWnVCdEdLQXM1YWJvTGUrQWdCSGRGVWppdWdpNVBzZm5mZkFlR0JJVUZY?=
 =?utf-8?B?T2hDRGE1RlNVS1NkdGFhTnI1TSsxdkIrUDlJNDFTd0NUYzBuQVFjQmVaZVBm?=
 =?utf-8?B?cXJYNnppNUdmaG1UUjNTRXNaUWtDbnJCWTV1cjRocHdOWjdVOFZWeTM5Z3Ez?=
 =?utf-8?B?SEtkQ2pZRWNPbXEwUXYwWm9mM1IwZ3g2Wk9mbE9CYnFCRHlBUkkydTYzVG43?=
 =?utf-8?B?eDhzL3JUMkNhRDR3S1lldFVjdlAwdEFSYU9nMHU0bWpCM3FHS1YrakhtbXJ0?=
 =?utf-8?B?TkVBQkRCZStEaDREbFNCaERZTitWOVExMFA2bTZhSEEwaHlUZDZzNmtGcWUy?=
 =?utf-8?B?S09MY1Q4Z0dnQzYxbFY4ZWRjU3Y3Y284SkhIcDRPRTNmRzJNRDlNQmt0NkhD?=
 =?utf-8?B?WDQ1ZkJVeEhDT2JYWEVmYWZNaWh5cVJlU1lSYlNEMFE4d0pRdnp5UUZlUmFL?=
 =?utf-8?B?YXNpbFVmVnY2aXFORXVGNE12YTdHRk0rV2FFTVl5SzJ6TnBqdkFmenNOUGR0?=
 =?utf-8?B?aVVQSmNQMUk2WXpVSGdFTExZWHZtY2plQVhneEFVWHlQeUNteEoxUk1CWWtK?=
 =?utf-8?B?cFJzZ0U1dUw1TDFkNDB1Qnl1N3A1blpkYWduc3FXd0ZlK1RLcXgyZ1V4ejBG?=
 =?utf-8?B?cVZBSHJueXFZUityajdSakNpaGtaODF1T2dnK24zWjVDdW5Qd0xhcUg2bmRJ?=
 =?utf-8?B?ZkNSeG5CbEZ0SFdhV0Z2Y1VVRUdUUkZJU1RiTUtRMzU4S3ZZc3lZQVREbU9T?=
 =?utf-8?B?aUZoZXdaVnNpMCt5ZG5WV2pmTSszTlJXYm4wRDJNWG50Mm1zL2ZWdUF3TkFn?=
 =?utf-8?B?cTczQTQ0Z0xZL3pCSjFab3dIcTgxcjE1Y1BQbnBsSTRMLzBBZUE4dWNRazJ1?=
 =?utf-8?B?L2hWQWp1cktaVHN4WW5XK3FWbXJKN0ZtUFRJaG9LSThXRGRCOXNBYldrRWRE?=
 =?utf-8?B?SlZZSlptbElkb2tZV3B5TjRKbnlrUnJrUU1CQ2hhWW9zWDhaVUpKbGRub0hO?=
 =?utf-8?B?amxhdEdrZ2ZNZjNwb24rNDZOeXgzMVZ5OVR3TFVESHQyVHBRdkpBK1orWDFh?=
 =?utf-8?B?VldITVBtdG4xYm9SYll4WFFWYUwzTUVaTHUzUHBwSnBIMnBzaW44dlVqZHZy?=
 =?utf-8?B?UVdkVld1cDBvNThCNDgrRDk2cFpVcGE0OHl2T09UT0U0ZjE2Rll6VzNHSUIr?=
 =?utf-8?B?UUE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 32107ad4-6ffd-43b0-f54e-08dd9cf4d0e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2025 08:02:24.7234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NX6SoONj0h2xP/31xVri8VGLIR6Ab3Wevi56oG0q48SzfmQ80ggPmKvlRDknM6EMBDaAfm7ZhQ10ZCgtxyMVxknAkIz4E7QX2BUWPrSLRBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6247
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogVHVlc2RheSwgTWF5IDI3LCAyMDI1IDI6MjAgQU0N
Cj4gVG86IFJlc2hldG92YSwgRWxlbmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+OyBqYXJr
a29Aa2VybmVsLm9yZw0KPiBDYzogUmF5bm9yLCBTY290dCA8c2NvdHQucmF5bm9yQGludGVsLmNv
bT47IEhhbnNlbiwgRGF2ZQ0KPiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPjsgbWluZ29Aa2VybmVs
Lm9yZzsgU2NhcmxhdGEsIFZpbmNlbnQgUg0KPiA8dmluY2VudC5yLnNjYXJsYXRhQGludGVsLmNv
bT47IHg4NkBrZXJuZWwub3JnOyBsaW51eC1zZ3hAdmdlci5rZXJuZWwub3JnOw0KPiBBbm5hcHVy
dmUsIFZpc2hhbCA8dmFubmFwdXJ2ZUBnb29nbGUuY29tPjsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZzsNCj4gTWFsbGljaywgQXNpdCBLIDxhc2l0LmsubWFsbGlja0BpbnRlbC5jb20+OyBB
a3RhcywgRXJkZW0NCj4gPGVyZGVtYWt0YXNAZ29vZ2xlLmNvbT47IENhaSwgQ2hvbmcgPGNob25n
Y0Bnb29nbGUuY29tPjsNCj4gYm9uZGFybkBnb29nbGUuY29tOyBzZWFuamNAZ29vZ2xlLmNvbTsg
ZGlvbm5hZ2xhemVAZ29vZ2xlLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY2IDEvNV0geDg2
L3NneDogSW50cm9kdWNlIGEgY291bnRlciB0byBjb3VudCB0aGUNCj4gc2d4Xyh2ZXBjXylvcGVu
KCkNCj4gDQo+ID4NCj4gPg0KPiA+ID4gPiAgLyoNCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiA+ID4gYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3Nn
eC9tYWluLmMNCj4gPiA+ID4gaW5kZXggMmRlMDFiMzc5YWEzLi5hMDE4YjAxYjg3MzYgMTAwNjQ0
DQo+ID4gPiA+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiA+ID4gPiAr
KysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gPiA+ID4gQEAgLTkxNyw2ICs5
MTcsMjAgQEAgaW50IHNneF9zZXRfYXR0cmlidXRlKHVuc2lnbmVkIGxvbmcNCj4gPiA+ICphbGxv
d2VkX2F0dHJpYnV0ZXMsDQo+ID4gPiA+ICB9DQo+ID4gPiA+ICBFWFBPUlRfU1lNQk9MX0dQTChz
Z3hfc2V0X2F0dHJpYnV0ZSk7DQo+ID4gPiA+DQo+ID4gPiA+ICsvKiBDb3VudGVyIHRvIGNvdW50
IHRoZSBhY3RpdmUgU0dYIHVzZXJzICovDQo+ID4gPiA+ICtzdGF0aWMgYXRvbWljNjRfdCBzZ3hf
dXNhZ2VfY291bnQ7DQo+ID4gPiA+ICsNCj4gPiA+ID4gK2ludCBzZ3hfaW5jX3VzYWdlX2NvdW50
KHZvaWQpDQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsJYXRvbWljNjRfaW5jKCZzZ3hfdXNhZ2VfY291
bnQpOw0KPiA+ID4gPiArCXJldHVybiAwOw0KPiA+ID4gPiArfQ0KPiA+ID4NCj4gPiA+IE1heWJl
IHRoaXMgd2FzIGRpc2N1c3NlZCBidXQgd2h5IHRoaXMgaXMgbm90IGp1c3QgYSB2b2lkLWZ1bmN0
aW9uPw0KPiA+DQo+ID4gVGhlIGxhc3QgcGF0Y2ggaXMgY2xlYW5lciBpZiB0aGUgcHJvdG90eXBl
IGlzIGFscmVhZHkNCj4gPiByZXR1cm5pbmcgaW50IGhlcmUuIEFsc28gZXJyb3IgdW53aW5kaW5n
IHRha2VzIHRoaXMgaW50byBhY2NvdW50DQo+ID4gcmlnaHQgaW4gdGhpcyBwYXRjaC4gRG8geW91
IGhhdmUgb2JqZWN0aW9ucyB0byBsZWF2ZSBpdCBhcyBpdCBpcz8NCj4gPg0KPiA+DQo+IA0KPiBZ
b3UgY2FuIGNsYXJpZnkgdGhpcyBpbiB0aGUgY2hhbmdlbG9nIG9mIHRoaXMgcGF0Y2ggKHdoaWNo
IEkgYWxzbyBzdWdnZXN0ZWQgaW4NCj4gdjUpLg0KDQpTdXJlLCB3aWxsIGRvLiBUaGUgcmVhc29u
IEkgZGlkbuKAmXQgZG8gaXQgaW4gdjYgbm93IGlzIGJlY2F1c2UgSSBhY3R1YWxseSBhZGRlZA0K
dGhlIGVycm9yIGhhbmRsaW5nIGluIGNhc2UgZXJyb3IgaXMgcmV0dXJuZWQgaW4gdGhpcyBwYXRj
aCwgc28gdGhvdWdodCBpdCB3YXMNCnNlbGYtZXhwbGFuYXRvcnksIGJ1dCBhcyB0aGlzIGNvbW1l
bnQgZnJvbSBKYXJra28gc2hvd3MgSSB3YXMgd3JvbmcuIA0KDQpCZXN0IFJlZ2FyZHMsDQpFbGVu
YS4NCg==
