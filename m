Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7951A83E5;
	Mon, 19 May 2025 11:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654192; cv=fail; b=HkD1dErBHag/6I1X1TNm0/77BI7NpjCnMjcF47A8SJJDHvb/fAD0Oh4mWPFL/HOP4k/yVchlOiDzCQ8MbMK2SXuTVKpjGYGJC271oTgYc5x3XNtXZJGI2CJTZZjH7xat9wlAe/ZAynpcwNnbAx7l42qIlxNc52bYLvnPRn/ghAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654192; c=relaxed/simple;
	bh=0oixVGG4tsFQerUsU9eiQ3ePdGJm3gBTa2sc3zb2aoI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jbSEc58VSLA9IIw72ymKbCeOcFM1scNxLyU0zh0kSd/ANtK3UStNzi/l70np8a3vJLxuBwe4/hoRnEQeuwh/9mPht9/m6kKUL/7kvb5jwLBknQU820P+kP6LLsCbz6HBhTbyhiH/8A3UN5eiP/sQtWhGHjryI9gkKgi7htDxPOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3dQdaKD; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3dQdaKD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747654191; x=1779190191;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0oixVGG4tsFQerUsU9eiQ3ePdGJm3gBTa2sc3zb2aoI=;
  b=H3dQdaKDFfg3GJ/HHKdPW1JIecwcyxO3WAchZgi6hsVT/BO5YlHtYH1V
   ggKgxZzTIC2K8yztkBp2yJm3nZ9/nxlN8SK3qG0QuJYA01EinYvPYQuak
   8kJ1DN173/ufB+CC/pUnZk6ls/ZyV08fyWfnl0EhkPS7aqenHqXq9r0xe
   JUScUEdlluAF0kxCrcW4P83F6wotNA8VFMGuc+9beRIx/uy16IUzWS6xq
   3ZCxJMoeJG6J1ydt6wcc5qYvanNHuex6LbM895oH/zs9DqYyPM3uec3QL
   DUGuPiwXelZr1FooSygIbTAvzibVrNucku8PHINjSLkV5sM0L7Am+JMPO
   w==;
X-CSE-ConnectionGUID: olQuLpXzTD+TjjYL2fd0QQ==
X-CSE-MsgGUID: /q24PAVyRoqCVF6IrHNvCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="53347333"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="53347333"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:29:50 -0700
X-CSE-ConnectionGUID: PDvlEMVeRoeI3UAheNT8RQ==
X-CSE-MsgGUID: Ooc8VG/cRIS/XW9IXlUBww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139385899"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:29:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 04:29:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 04:29:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 04:29:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nao/8Io0RrChZVSqDUTbMrlaf6n3ODLYu4aejh1g+wX2O/Ve94a98nNGdm14W+HNQ2FT2Up50AeApYyP6JuvZ4Axt4Uw5uaDN1jZGLIaFtK3U8O1khkaVRDwLKrrFZ5z79mSCvkdufcZcwT9lP1sDcf7fS+/5IajPJ678cDkqCX47lIuaR5vypzP/SWbxz+zDgM4OT/ZJ4OzodsV+aSD+EovEFln1U5I6ZORCekUDEBSuEPwJGWDNUWYtGDJcUNiezC0eC+B9ZhJx22EmwMPBpxs2k8VAKz6agA6TtyYaogl/AVQWNJzUOHbBtp7KNuFC0i2SZ1r/RqqkdjQFPcatw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0oixVGG4tsFQerUsU9eiQ3ePdGJm3gBTa2sc3zb2aoI=;
 b=PY8be2LxIVKozelOfJejxqj5Jg5h4DYX3S2UPkARNF/+PabB9QzbPQM0B6FxySVhIpSuDkvKnmJwLoqsnXAJWGpnkr6dDm0PdcGSWrJiO7Pd3suuOsBjVPcyqJdGA81pQcD/u5lbNTB32ie/w6BwoNc71/YaKWh75S339+MT5GBlkUL+UfEcT+yn9HZuyJJ0uuKJXp2MTU36nctnUVjUfvUnOh7gzW0DQMH1u/J6TZoN/lSJfbWSmkxUjijEb8jvzmZ5aMnhNXqB2NyLlvSw4RI2/kpadZ6rMsSXwe4zv43wbUguNv5NpWbkj9vKwz/fGAgCX9cC4s8OP0toRjpTog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH8PR11MB6801.namprd11.prod.outlook.com (2603:10b6:510:1c9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Mon, 19 May 2025 11:29:31 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 11:29:31 +0000
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
Subject: RE: [PATCH v5 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Topic: [PATCH v5 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Index: AQHbyI9ne6S3zFxcgE6Pkc3/E4GOd7PZx0MAgAAKF/A=
Date: Mon, 19 May 2025 11:29:30 +0000
Message-ID: <DM8PR11MB57502BD6F5E9FF111F6B89E7E79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
	 <20250519072603.328429-3-elena.reshetova@intel.com>
 <09fbf33ae17587c204e7f436887c48367f6797f0.camel@intel.com>
In-Reply-To: <09fbf33ae17587c204e7f436887c48367f6797f0.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH8PR11MB6801:EE_
x-ms-office365-filtering-correlation-id: 6ed758f7-e9d4-4f76-b9e6-08dd96c86c44
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SkZsYWEvY1BIR3A3emVycUN1N3YzZnZOQklYcCs4a00zaEFyY04rY01ST2tH?=
 =?utf-8?B?OFh1aWNFdDNmOG0rRmNCbUZYaFhudGVMQWtGN2dLL2VhR3BWcVA3ZkY0QlUx?=
 =?utf-8?B?OXgrMThTWGI3NzFzZnNVTVhZZUV0MVdrdDlJR1pvdHVCcGhKanJYRlVTbjds?=
 =?utf-8?B?aDNJV2VWVGhtN3B1RkRzSGtScmZyWlc2NU1ZaWdkVUZMeGl3Zkc0Yzk4dkxn?=
 =?utf-8?B?YlBxN211czBhYVZ5dEN1RmVGaGZFZldpd00rQXE1Si9hMHdXTzdVc2NJeW9S?=
 =?utf-8?B?cDNtVGdzMTVpUVVZWmRKMUM2ejFZR2FPTlo3SjFaY3JhbXFhUlFPY3BXNXpF?=
 =?utf-8?B?YWZLMit6Qy9pNWJ1T1dVTy9Od1l4Qm5acGlYbDRraUhHK3hobVEyMWJwcVlY?=
 =?utf-8?B?QnhKQ1VXYll6Yyt5YkdyUU1iVDVkY2VkSElqQmZLTVQzSDZoeUdUSjFVbVhw?=
 =?utf-8?B?SnpMODBmaHE3bnVDZUErQWhVamhhVEtTRmZaNUsyYkM5VEFpZXhWUmd5VlBM?=
 =?utf-8?B?WjJ6OFpTOGUybTdVQVZqZGFsS1l3UWMrdXU4cTFUb1BGd2M3ZFR3MGcrVlJB?=
 =?utf-8?B?MURjK3ZyK3BRM0M4NmwvT282Zy90MmE1TTdRdm1CVnloQnFGZTlYMkpvTVZO?=
 =?utf-8?B?b2k3SnZQUVZKZFpGUDU4d3MvNlF3eFN5RXFIVkVUbUZPcFYyV2szaFllL0hy?=
 =?utf-8?B?TTdSZWlHaGJkVnpVVGVXQ3VFZG1MOEIzVE5oVENBcUcvUmVwbEppbnVId1VV?=
 =?utf-8?B?V3VnelFETm9uRHZ5ckhsSlVacm96Y0hWZTMycnRLc1N2eHB3UTVtS1VQMkxj?=
 =?utf-8?B?M1VnR2NNVFBIZFFQVUhBaG1sRGl2andidk5YQzRvS09XMlRPSkZyYzhrM1VV?=
 =?utf-8?B?U2dGVWdOaFNldXVmNnZoUFByd3FENUVPZ3ZTMjd4QzJBN2FUTG1lT1dIWFR6?=
 =?utf-8?B?WTRqSVBhVUl5UitwL1UzaStYajJtWnlMYzA4aDVoeVVwYzZTSEpuQ1VNdE1J?=
 =?utf-8?B?QnZVWHErMzBlMWtudlU0d2dNa3duM1pzOGJFSGd6MHJyaUFqUXFPcERRTW5R?=
 =?utf-8?B?cWRwUmVGYVlDSThqVXk0RllPTDF1RkpDZEdMSFp4QW5CbVJtZ0dIVjNtOTFT?=
 =?utf-8?B?Wm80R0pISHZhRlZEOXRVdHYvNk9namM5cExaTVFvY2lrSnZlMHpMZHZXWFJl?=
 =?utf-8?B?aHBzS1orbjR6NmRZdmNVTFI1Z0JnR2V0RllhYnhEOElZcktrYkJRajdhbWt4?=
 =?utf-8?B?QVZobUtDRnh4ZUI2TG1Pd29kMDFRaStCM0tLeXFITXhpcnU0MUc1MW1iSmpj?=
 =?utf-8?B?UE54RjJlRGkyMTJzZ25mRmtGRjBzQ3g2d1lTaFdKSEpSNFJQd280T0dJMmkr?=
 =?utf-8?B?SVBNRU9vVWZOTVFicjh5aUc3a1RTV2xtcFUxZi9WbXRhWWNJVWtNd3BVa0xq?=
 =?utf-8?B?djN4QUZ5dDU0YnBPclowN1IrOVVvZXVKYzJUL0JBNlVnV1VaT1Q3RGhsUzNM?=
 =?utf-8?B?L0tGQXdJVkxZSFhUKzM2THRNSU1mNXorYWNIZ29wbklTT05FbFB1MTc5U2Zr?=
 =?utf-8?B?WVVhMkVoSzBwK0YvQ2poM2xvV3NEVFlUY1h6Zit3MDdtSjVvcGY0TFpERXlr?=
 =?utf-8?B?YzVFeWlQWDRIanJzK0xZODJ6bHpTNVd1NU5sTGdDZ2ZUMkg0S2Qxc2lqZE1a?=
 =?utf-8?B?ZERQdUJmcWVFV1hrTytFcDM5cklFQTJSdWNibTY0a1FwZ0VuWXJzazdseDNs?=
 =?utf-8?B?ME1OYXVKQ000czR6RGh1bG9UVlovOGtTK3VOd1lHUkxRKzUvVldUN0dwc2Zp?=
 =?utf-8?B?bE1veTM4dHhZWm9SVXlvRWkrSnV2L3ZwYU5KNUdLSkxQQm10SDN1b0xENEh0?=
 =?utf-8?B?S1NZQ1NxRUZHdGxidXhBaCt3bXRUVDc2elQ0aDc3RlYvNXpVblpjTWhBSGx3?=
 =?utf-8?B?TkVFOHZOdlp4T0lGaVY3d1NhdVRSdDdFMllOaDh2ZWtvVDIwbE10UCtDTjB3?=
 =?utf-8?B?SlV3aUdkeEl3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUljVnNMcVluTHViTzRFVS9mWXRwZUJoQ3JwMXBoWUtNNFFwTWk4TWpidW1M?=
 =?utf-8?B?V1R3dzdOZ20ySW5sV1RxREJjVjRJelMrYUdmSHd0Mi9NVFg1MC92ZFpjZzJZ?=
 =?utf-8?B?NllVcTV6RVIwdzNyK2xSOTFXeXkrUzN4ZExubzRxaTJ1c2lPTzd2eE1IQ1lJ?=
 =?utf-8?B?anVqUzhRc0paT01vd1h3WjU0T3NoY0lXZStKOVBhSlR6Yi9qU282SmcweHVw?=
 =?utf-8?B?K251ZVNFRlo3OWhmUDFDV0R1TTFUU0Q4L0dYenRHVmdNVHNmdUd1bTFEd0RE?=
 =?utf-8?B?RXA4MG1JTmVjUjVlck5aL2xGQ0k5NUgranpOYmx4QUVtYkFHazJpbVRMTmYx?=
 =?utf-8?B?REduekpSb2hNSE10TGt1OC96alNnMkpNaFkwZHZEbW5TYzJiUXZSbXNaWW1B?=
 =?utf-8?B?b0ZUaEIzaWdSaDl6S2JJNjhFS2cwZ1NSQjNZYjVEME8xNDZSa2Rqdng5TEIr?=
 =?utf-8?B?WXJPT2RjR3B6NWFxeWM0eFkwTzMxNEp4ZjlveGs3aGNsNW9FbmlubWZoT1lN?=
 =?utf-8?B?WGpTTWMyeUVIVXJaWWN1T0JYNXFjQ05NcnFhb2p1WU1WL0NvR1dLZlVpanEv?=
 =?utf-8?B?S0JuTEpoT2QwWjVnZTlobGJRenlHR0dVaEhmYlQ2VVdnVXRWVjd2UnVaSzU1?=
 =?utf-8?B?WHptb2NiQUcxaHFwWTl4SDJkUlVPSFF4YjY2LzB5cFhhRTBSTmw3R2x6QnR4?=
 =?utf-8?B?VmpNZStsSnF0eDQ0cWVFTlJaYk4xQmp0OUtUU3hMTHBXcFRiNHlnNUllbzRN?=
 =?utf-8?B?Y3BtaXhOR0M0SWN5T3JhQ3pUVExZN05zN3l3ZXU0MEEyMUc2cHdxU1JseVRl?=
 =?utf-8?B?TS9kZHdKWGtyZjBNQngzZWhzaUtnR1JMRVNvM3lpZVcyR3Bxa2RDOEQ0alBa?=
 =?utf-8?B?cE0yai9pVkVGUEJGVmROcjZFNU1meHNnR0JuZTd4djJ0aWFqalFsYm9vMkNO?=
 =?utf-8?B?RXBTMEhUcFU4MHB0aTBhQm9kMVpWU1MvSDY2Zkp5MkE4bGlEbU5PMGlMNjE0?=
 =?utf-8?B?UERvMXBRUVRFY2VhK3FhZzFaeGc1Mzhic0YyaDE5UXh3NjNSa2dCOXdvWWxa?=
 =?utf-8?B?T3hUSStnS2o4bEpSbnRDUXhKcjF6aXROQmYxWm52ckRRczRVK3VqZi9ycjNs?=
 =?utf-8?B?L3hoUUVqK3hLWEFnaEFjTkowQk9tTThWUnM4N2d4R0NhZy9tMFd4MDNKYy9j?=
 =?utf-8?B?ZjEwanJNWEZnOWJINHNlMlBhN0w0WDZCcDBuN2N5cXRJVzdpSVNPTk9rUG5E?=
 =?utf-8?B?WUF3cW8vR0htamxWbXhCV1hqVGx0ZDdXb0ZHSEVFUjZtWFdOTlBEbEQ0eXJu?=
 =?utf-8?B?Y0hPUlNRY1lJdURnUnlxSmNCck9qVzROQmtzUWhBN3l2dzZXTERlZ0ZTS3hL?=
 =?utf-8?B?SnpzdnFkb1RaZDFGcTBTN0NOZTl0blk5SzJUNFRSa1F6RFdmZXl1WTgzMERS?=
 =?utf-8?B?VTAvYkp3T3VKYzFvNmV0TzdFNlJXeVlTOHZJRU5ybXkzUXN4WklHeVNtb3c5?=
 =?utf-8?B?N0IvVjVSRzgwaERObzJXKzlvQW9rZTY3MjVzYTcyZWpzeXFLZTRTQ0dyZXRR?=
 =?utf-8?B?SWVGWUpES2lOdk1KRGFiVksyeWVRRG5iN0pMQlMvR0ZJbnIyNTV5cjFJcjlN?=
 =?utf-8?B?VnNGL1NwTTdtQlphYkRPQnFna2JXQ1FhRmJQQnlKQjVvZWhPbm44MFVoVnVK?=
 =?utf-8?B?d2dlQjBxV2ozb0xnT01IRyt6VGxHdEliTUhKZTdUM0k1MjE4OGp1VjFKWjV6?=
 =?utf-8?B?Uk9CV0tESUxJckpFUzgrL1BZQ3JFMnk3SkJnTkVEcG9TSjRzVVlwYkhOUEhx?=
 =?utf-8?B?M1F0VTFIbWZIWVg4cFROV0drVSt1ZTQxYW1YaERhSFdocTMyRjJGK1JwZmNI?=
 =?utf-8?B?OW4xbTdOZVR3dEpJeE9zRmFJZlJwV2djM2V5MEJBUGYzWG9kVjdkLzkvK3M5?=
 =?utf-8?B?c0FyZ2tCd3pqeHpZbUZNeHNBMTNWOHFyWk9qZjY3ZkZjMm1zL2swb0JwcTRS?=
 =?utf-8?B?VSt2M2VFRFZaaEJGTTk1VmRYa3pKRjA1QVBhSWFlbnZKRHoxY1k5bTVMNWlu?=
 =?utf-8?B?Ym1GeVk3MFFXZ0N2MUhhSnptWW1JUk94aUdYSDVOUEFxUlpZQlV5Kzd1TVR1?=
 =?utf-8?B?UDFrS0dNZGlEYjlDRDZXZ0J0ck1uNklxeGFPa1VoTXY4K042SHhEWnY4RHJG?=
 =?utf-8?Q?M7iHCoMdPWJpg8RJecuWWooPC88JCypqhG+PrXI55hyy?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed758f7-e9d4-4f76-b9e6-08dd96c86c44
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 11:29:31.0218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c14NAsVOaprlqNjdcJ3XvkI5ncS8f9OI4E9oboy0Mtt8UI5z/Zr6htn0f2idueW+W6TVSeHgROZXaGFq7Br/6Ws3oIrZZ5B/OF4pPAONV1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6801
X-OriginatorOrg: intel.com

IA0KPiBPbiBNb24sIDIwMjUtMDUtMTkgYXQgMTA6MjQgKzAzMDAsIEVsZW5hIFJlc2hldG92YSB3
cm90ZToNCj4gPiBBZGQgYSBmbGFnIGluZGljYXRpbmcgd2hlbmV2ZXIgRU5DTFNbRVVQREFURVNW
Tl0gU0dYIGluc3RydWN0aW9uDQo+ID4gaXMgc3VwcG9ydGVkLiBUaGlzIHdpbGwgYmUgdXNlZCBi
eSBTR1ggZHJpdmVyIHRvIHBlcmZvcm0gQ1BVDQo+ID4gU1ZOIHVwZGF0ZXMuDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBFbGVuYSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+
DQo+ID4gLS0tDQo+ID4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmggICAgICAg
fCAxICsNCj4gPiAgYXJjaC94ODYva2VybmVsL2NwdS9zY2F0dGVyZWQuYyAgICAgICAgICB8IDEg
Kw0KPiA+ICB0b29scy9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlcy5oIHwgMSArDQo+
ID4gIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaA0KPiBiL2FyY2gveDg2L2luY2x1
ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gPiBpbmRleCA2YzJjMTUyZDhhNjcuLmVkMGMwZmE1ODIy
YSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlcy5oDQo+
ID4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaA0KPiA+IEBAIC00ODEs
NiArNDgxLDcgQEANCj4gPiAgI2RlZmluZSBYODZfRkVBVFVSRV9BTURfSEVURVJPR0VORU9VU19D
T1JFUyAoMjEqMzIgKyA2KSAvKg0KPiBIZXRlcm9nZW5lb3VzIENvcmUgVG9wb2xvZ3kgKi8NCj4g
PiAgI2RlZmluZSBYODZfRkVBVFVSRV9BTURfV09SS0xPQURfQ0xBU1MJKDIxKjMyICsgNykgLyoN
Cj4gV29ya2xvYWQgQ2xhc3NpZmljYXRpb24gKi8NCj4gPiAgI2RlZmluZSBYODZfRkVBVFVSRV9Q
UkVGRVJfWU1NCQkoMjEqMzIgKyA4KSAvKiBBdm9pZCBaTU0NCj4gcmVnaXN0ZXJzIGR1ZSB0byBk
b3duY2xvY2tpbmcgKi8NCj4gPiArI2RlZmluZSBYODZfRkVBVFVSRV9TR1hfRVVQREFURVNWTgko
MjEqMzIgKyA5KSAvKiBTdXBwb3J0IGZvcg0KPiBFTkNMU1tFVVBEQVRFU1ZOXSBpbnN0cnVjdGlv
biAqLw0KPiA+DQo+ID4gIC8qDQo+ID4gICAqIEJVRyB3b3JkKHMpDQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2tlcm5lbC9jcHUvc2NhdHRlcmVkLmMNCj4gYi9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NjYXR0ZXJlZC5jDQo+ID4gaW5kZXggMTZmM2NhMzA2MjZhLi5hN2UxZmNlZGNhM2MgMTAwNjQ0
DQo+ID4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9zY2F0dGVyZWQuYw0KPiA+ICsrKyBiL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvc2NhdHRlcmVkLmMNCj4gPiBAQCAtNDEsNiArNDEsNyBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IGNwdWlkX2JpdCBjcHVpZF9iaXRzW10gPSB7DQo+ID4gIAl7IFg4Nl9G
RUFUVVJFX1BFUl9USFJFQURfTUJBLAkJQ1BVSURfRUNYLCAgMCwNCj4gMHgwMDAwMDAxMCwgMyB9
LA0KPiA+ICAJeyBYODZfRkVBVFVSRV9TR1gxLAkJCUNQVUlEX0VBWCwgIDAsIDB4MDAwMDAwMTIs
IDANCj4gfSwNCj4gPiAgCXsgWDg2X0ZFQVRVUkVfU0dYMiwJCQlDUFVJRF9FQVgsICAxLCAweDAw
MDAwMDEyLCAwDQo+IH0sDQo+ID4gKwl7IFg4Nl9GRUFUVVJFX1NHWF9FVVBEQVRFU1ZOLAlDUFVJ
RF9FQVgsIDEwLCAweDAwMDAwMDEyLA0KPiAwIH0sDQo+ID4gIAl7IFg4Nl9GRUFUVVJFX1NHWF9F
REVDQ1NTQSwJCUNQVUlEX0VBWCwgMTEsDQo+IDB4MDAwMDAwMTIsIDAgfSwNCj4gPiAgCXsgWDg2
X0ZFQVRVUkVfSFdfUFNUQVRFLAkJQ1BVSURfRURYLCAgNywgMHg4MDAwMDAwNywgMA0KPiB9LA0K
PiA+ICAJeyBYODZfRkVBVFVSRV9DUEIsCQkJQ1BVSURfRURYLCAgOSwgMHg4MDAwMDAwNywgMA0K
PiB9LA0KPiA+IGRpZmYgLS1naXQgYS90b29scy9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0
dXJlcy5oDQo+IGIvdG9vbHMvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaA0KPiA+
IGluZGV4IDZjMmMxNTJkOGE2Ny4uZWQwYzBmYTU4MjJhIDEwMDY0NA0KPiA+IC0tLSBhL3Rvb2xz
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gPiArKysgYi90b29scy9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlcy5oDQo+ID4gQEAgLTQ4MSw2ICs0ODEsNyBAQA0K
PiA+ICAjZGVmaW5lIFg4Nl9GRUFUVVJFX0FNRF9IRVRFUk9HRU5FT1VTX0NPUkVTICgyMSozMiAr
IDYpIC8qDQo+IEhldGVyb2dlbmVvdXMgQ29yZSBUb3BvbG9neSAqLw0KPiA+ICAjZGVmaW5lIFg4
Nl9GRUFUVVJFX0FNRF9XT1JLTE9BRF9DTEFTUwkoMjEqMzIgKyA3KSAvKg0KPiBXb3JrbG9hZCBD
bGFzc2lmaWNhdGlvbiAqLw0KPiA+ICAjZGVmaW5lIFg4Nl9GRUFUVVJFX1BSRUZFUl9ZTU0JCSgy
MSozMiArIDgpIC8qIEF2b2lkIFpNTQ0KPiByZWdpc3RlcnMgZHVlIHRvIGRvd25jbG9ja2luZyAq
Lw0KPiA+ICsjZGVmaW5lIFg4Nl9GRUFUVVJFX1NHWF9FVVBEQVRFU1ZOCSgyMSozMiArIDkpIC8q
IFN1cHBvcnQgZm9yDQo+IEVOQ0xTW0VVUERBVEVTVk5dIGluc3RydWN0aW9uICovDQo+ID4NCj4g
Pg0KPiANCj4gDQo+IEFkZGl0aW9uYWxseSwgdGhlIG5ldyBmZWF0dXJlIGJpdCBzaG91bGQgYmUg
YWRkZWQgdG8gdGhlIENQVUlEIGRlcGVuZGVuY3kNCj4gdGFibGU6DQo+IA0KPiAtLS0gYS9hcmNo
L3g4Ni9rZXJuZWwvY3B1L2NwdWlkLWRlcHMuYw0KPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1
L2NwdWlkLWRlcHMuYw0KPiBAQCAtNzgsNiArNzgsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGNw
dWlkX2RlcCBjcHVpZF9kZXBzW10gPSB7DQo+ICAgICAgICAgeyBYODZfRkVBVFVSRV9TR1hfTEMs
ICAgICAgICAgICAgICAgICAgIFg4Nl9GRUFUVVJFX1NHWCAgICAgICB9LA0KPiAgICAgICAgIHsg
WDg2X0ZFQVRVUkVfU0dYMSwgICAgICAgICAgICAgICAgICAgICBYODZfRkVBVFVSRV9TR1ggICAg
ICAgfSwNCj4gICAgICAgICB7IFg4Nl9GRUFUVVJFX1NHWDIsICAgICAgICAgICAgICAgICAgICAg
WDg2X0ZFQVRVUkVfU0dYMSAgICAgIH0sDQo+ICsgICAgICAgeyBYODZfRkVBVFVSRV9TR1hfRVVQ
REFURVNWTiwgICAgICAgICAgIFg4Nl9GRUFUVVJFX1NHWDEgICAgICB9LA0KPiAgICAgICAgIHsg
WDg2X0ZFQVRVUkVfU0dYX0VERUNDU1NBLCAgICAgICAgICAgICBYODZfRkVBVFVSRV9TR1gxICAg
ICAgfSwNCj4gICAgICAgICB7IFg4Nl9GRUFUVVJFX1hGRCwgICAgICAgICAgICAgICAgICAgICAg
WDg2X0ZFQVRVUkVfWFNBVkVTICAgIH0sDQo+ICAgICAgICAgeyBYODZfRkVBVFVSRV9YRkQsICAg
ICAgICAgICAgICAgICAgICAgIFg4Nl9GRUFUVVJFX1hHRVRCVjEgICB9LA0KDQpUaGlzIG9uZSBJ
IG1pc3NlZCwgd2lsbCBhZGQuIA0K
