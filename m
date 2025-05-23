Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874A5137C37;
	Fri, 23 May 2025 06:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747982117; cv=fail; b=XziGaQJ4PriDuRUj0cuPkNSv8ZrUJQgVRere9f2vMzj4lQH3oEvx9zz7ite8TvI+oyRj1YZp6SuhagwocZYqvo4jYSGuMHcZCcyA9aEgeUiGsshJmp+MTUtPVO0FA3mM1IW0/+8NP+0R5caSWy3ZOdxbpLvfoyQgRZbYqXHLgGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747982117; c=relaxed/simple;
	bh=ETnyIPLWUPWDJSxd+qgXuDS8fhdgQcDxcvpeLabsdY8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JNOq+IIQcLsTTP/8S4DnYg4Ay+qvwUt0HKIcEVIsYgv2Hq+DdjdVbMS+uW3jR+h4XWlee2IkF+n9UmudYT55Sr/YsGAn9+hvjkzVWsz6S+ufToG9VVJe1Ywaa+q0meFLFFnjrTUmpce+FeY9raxq4e4FtyDNG0EtwWa/cBwNb/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z+fq0rdr; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z+fq0rdr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747982115; x=1779518115;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ETnyIPLWUPWDJSxd+qgXuDS8fhdgQcDxcvpeLabsdY8=;
  b=Z+fq0rdr5esQR+I6dJ6N1vQ3CDx/wz814hzYovp3+MwboXo85OI5UnSr
   VKTWJ5EVle/bnXR1Sbbg/CDgjJFYq7gRxZhcc9DV4c0IKh0JHgRsOjCIy
   3y+vV1k6gECu52/nl+RxvBbnL0Pnnt0k7resWfgJ6HIhBOVCCXrfCQdLq
   GkOyPMrcLeJTHP2Vbko2yynGo2x6lawRBKIoBWTeHR1r3KcbOQrDBG4wD
   ZgyfgDAl6BBzxMfckp+dfSgoQU91gp6YsCKt2OFu61OMMqyswt/D3ujkQ
   sTLN3X6GeNTTt5HHmmVkXB/Fn1rkvT8cLGiUWRqmYwDtOsztRYn0OQaq0
   w==;
X-CSE-ConnectionGUID: DzbqfHNFQXmwzjpozvJEHw==
X-CSE-MsgGUID: XRT4i9beTP+J/556KJOAmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="61382379"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="61382379"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 23:35:15 -0700
X-CSE-ConnectionGUID: HIdv4Fj3QI2HFPAkhE3x9A==
X-CSE-MsgGUID: OuQN9NWKQICukSd8GxzjKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="171984782"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 23:35:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 23:35:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 23:35:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.68)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 23:35:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m2NYARwG/Az7xVdFufc5L2wFYlm5Fqk6E4ghfOcsaI5NW1Jupw2ARWySy48E0WjX7YM4GXtiD/rjnbhjBApBQDDOZKf7Kz371CEgUdzawOdgcg7b6w9mP5vA6IroSZ4kK4sSjJK683Y0k76Rz/rR6fmDsC9KDK6JqUvBVXizSBxwM1XeY4MtKCYBITW32aSoJCUq0mJ/k+cQuZiHKpcdT3NAI4Odq2tjmz9Fck+I936aDG4aX0kcG3C4YWnIyp1wcLtKMesklvthMaNDLsr+OGv6QW2NszqG1FFJqsfu4+5mxhz7OXsxquTTq6YdehIrcbH5jeLytlG7SFR/dhPeVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETnyIPLWUPWDJSxd+qgXuDS8fhdgQcDxcvpeLabsdY8=;
 b=KbRcyDHRdqDgRZbElvyyWp9HdOMYr0Aoas9/WELvTejN/7+4C+VhahrQDLvb+jAhaWUbZYpjT2pD5lRTM8jx11912VQHSiew9YSLX0q0kpm0OcS/O/aVFnCU4Rp0E5OyqkLMTGwtoTUygkpmtTnDvtwXdtfVq0q/eEkku+rXR8ekXp1zAis5/cPJLOLZGfdjnnjPxvuinBDW3rcYB7D1TeSo5Fumm7BPFwIQ3ij0CTw8cWTi7p/RN8MsiiTvrFEwoFzrLR/+GBve9GRC5gT1YGws/MPv3goRoXLxLE5gWQWM8yHaVVdQynv67AQXQx78SGEljOjMaJDrxsKF4uJdvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 MW4PR11MB6810.namprd11.prod.outlook.com (2603:10b6:303:207::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.21; Fri, 23 May 2025 06:35:11 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Fri, 23 May 2025
 06:35:11 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "mingo@kernel.org" <mingo@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: RE: [PATCH v6 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Topic: [PATCH v6 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Index: AQHbyvslcFIWNoGEr0Wq27eVATgJybPfWnMAgABoqPA=
Date: Fri, 23 May 2025 06:35:11 +0000
Message-ID: <DM8PR11MB5750B00C4B5D5ECB6FD7BBFDE798A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
	 <20250522092237.7895-3-elena.reshetova@intel.com>
 <633fcf4e77283018e7e72e333edb942db18140cc.camel@intel.com>
In-Reply-To: <633fcf4e77283018e7e72e333edb942db18140cc.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|MW4PR11MB6810:EE_
x-ms-office365-filtering-correlation-id: e2ef0826-c37d-4a8d-e559-08dd99c3f80a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WWlFbTBVNk02TkFOZzdJdTdqbGtJR0QyQUNLNVphc2JoS2VSZTk3SlppZURX?=
 =?utf-8?B?aFgyTER3OWF5QWJtNmw1Lysxb3pZL3hQRjE2VWw5Q0NJbmk2bEdpVXJtWGhK?=
 =?utf-8?B?TGx2WmJMQzRGT01FM0RSeGxzVVlJSWlneHlIWDl5dFRVQm9pRzZBOUsrQkZo?=
 =?utf-8?B?VXBXZnh5RFlrNlNOUVd2dXllYkp2OEZET3NjUjI1NUpsd2ZwQVVwRUxZTGE1?=
 =?utf-8?B?Q1F4M3J0TkhNd2tuSGFpWExZSWMxM3hmb2tQaUxUTUhnTUFzWERnRkg5Wkg2?=
 =?utf-8?B?MGY0STdNT1Y4dE0vQ3NmZUJlY015NEJrNFVCNmhVczBpaDhXU3hLejFGbWxh?=
 =?utf-8?B?Yk5JRHlqREV2T0pFbjVRdTJMbVB3SytQdkwyYmZ6d3kySHhWRFNPNVRZUTJu?=
 =?utf-8?B?K2RhU0YwZnpQS3cvMHJFZkVJeFY2SE9pUUVBT0pPcTMyWEtJUDdVWVJMcG9I?=
 =?utf-8?B?OTk5R2ZzU0RlOTJ5ck4rVVRQak1jZXVBRHpPOUdxRjB4KzJYQ0ZxQThub25D?=
 =?utf-8?B?dTdvanlMOHJzWFQxRk5DZ0JOUlNTNHhPQlAvMEUzWUNoK3crOW5teCsrSnJ6?=
 =?utf-8?B?OEI5MEQ1MkhVVlVWQXZ1ZExRY0RUREVpQUhsanBUWnVobEVwbTMwM0RhVWZW?=
 =?utf-8?B?VEdINTUzWDZ6UDQwTUdvZ3hoczNVV3JpUGJ3VlZqRlJoSEM2WUtNNE0zYkdK?=
 =?utf-8?B?eDJiWkpvdUhBVElIZFozUC9qWi9NcDJuc0NHMUF1YmROTzVDZnhiUlFCVWc3?=
 =?utf-8?B?U3doRDNwcTZ1QzFDVHB3cGQ4alBwMHoyWE1sMkFjbkxuSTlnOTNDS1R5TVhV?=
 =?utf-8?B?ZHFmb1hTZ0Rvc3NJK2h3ZWFsSmNwdEhYYjdCUVBLb3JQckJoYlB1MmE2Z2py?=
 =?utf-8?B?d1NBd3ovVWIxQS8yak5leUVsWllZWmk4OUV6azFRQnZoR3VhaC9IODJyOHlM?=
 =?utf-8?B?eUxsTmJ5VWVxRmNpTVdzSC9JNDhXMHBVcklnSTZwaHBQZEJ4MGJuOHlGUCtR?=
 =?utf-8?B?b2N1d0gweVhPeE9yLzNXUEIveTV6cFZmL1pRem9HMzZpVVpsZGlGSXlNMVpx?=
 =?utf-8?B?VmFKSnU0V0tLVDRlRDNiamcxZXVtcWhqZ0xyMWxsdWx2VVlnKzhFNnpwYU90?=
 =?utf-8?B?cEloN0IwUlI4WlpiU0h5Y1VISUxobnZOaFZ1d3ZhVDkzeDhwY01KSk5QNHgx?=
 =?utf-8?B?aE5KOCtaU2YzU3VhVjBNN093cXdpMVh0TnlJS3FocXlIYWF4ekdGNXdTbnBw?=
 =?utf-8?B?U2NPSDlYdnRVWDVKSjkyWS95YXNaQWgrVnVDWitMdm1aSFJ6Wi9OUUFpenpp?=
 =?utf-8?B?QWI1RDF5NEs5c1MxTWlaM3ZHcDVueUFTRllCYTFxYU9YN21UKys0Y0tnaEZ4?=
 =?utf-8?B?bE9MR3BmaWNiVjNWQ09aeU90Wk9mUUlmYTNZVDJKQUo3QVVobWNleW9aYTBE?=
 =?utf-8?B?SEVtVmxEcFlXT05FUEliVDZ6UTNrckozRDJPT3U4elRxVitra2FuRW5HRnh5?=
 =?utf-8?B?K01ZQlhoTTVmM3pGNFJINExxbDRJUnNlcnhMOTd4MVh1UC80TkIxazY5TTRl?=
 =?utf-8?B?WXNnUjdWWFIrV2JzL2IxcmlkWnd0cFlmNmNNMTBadW9VbW5wMFBjTmc3eEY3?=
 =?utf-8?B?R3l1UVl1NG0rdFBsTnZuQmh4bzQ0VXF4MFNBZ1ZqVTAveWFkYng5U2Q5VUdJ?=
 =?utf-8?B?NjluMWpsYXh5YWUxcWMzUUxwYnJYL3owcG9TRHVIcjcrcVFvMk5qeGpxSkhK?=
 =?utf-8?B?b0RBSXhScUtNQXE5YVlmR2JMc05ORlV5Vyt1ZlEwLzVrbm9wd2JTTUVubHRw?=
 =?utf-8?B?aVFaTWVhY3ZqM2ZwK0RmanNmSmdSMUd1QklZODlKT1VuM0tLTGVzRlZoTU5j?=
 =?utf-8?B?RzNmZEYxRkdoK0FEaGU0STdyaU1yaG1qS3NQTmZ0U2dWZWh5em4rNndiS1Yw?=
 =?utf-8?B?VmFrbFA2dDJvcEltTVNPMHN2N2VoNmVhU3BrQmgwMzJQNkVvdyt4K2F6WEho?=
 =?utf-8?B?NXhvblpvT3FnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXVoamU2bEhBeUUyU29neGxqY3UzV04zbVhKL2RnVEx3MzBXb0wwL3dBZ3dL?=
 =?utf-8?B?SDI5bEtQSTdnSFlOaVBHcHJFVEQwSkRtUnZrZVJKL21nZ0dDempPSDJvNmJ6?=
 =?utf-8?B?RGZXOXdraVo2RzdlOXYxbUVCZTBwN1QvMklXRDc5ZHhCRFJOR0ZEQTJLSXpG?=
 =?utf-8?B?SnZ4RTJ2WVBmdXJPeG42SFRJZGJIcFlGOFJNckErdWRSV1pxU2NxbGtiWXpC?=
 =?utf-8?B?ekxzQVBFaUI5dmM5V3V6VWNVWms0SVY1NDR3K3F4NDdLSG5mSENVYjJpdzNo?=
 =?utf-8?B?a3VRRVpqV3ZJZ1JkMHJ1WUFvVCtaRXBHRjBKNTV6RnJSTkdIK1VuK2tBQjlu?=
 =?utf-8?B?bEhOM04zcml3SWVBYUw2Ym1XYmVzcUVoOG9pclVhZm5JQzFtQVdNL0xOazFm?=
 =?utf-8?B?elg1SEl0cmJXZEcyZVgyN0tDaW92YUlVK2J6YjNpSmJxUkdNc0YyQ2V5TDcx?=
 =?utf-8?B?SjAzcC9PMXRPZTZycmFkSzFNbENuQzY4dnU2ZmN3alUrS2RKdkpqb24xUmZt?=
 =?utf-8?B?QlN0a21OZlpBK0FKU3RlWVlxUXdxN2hXSTJLbmQ2QzJ6TytNSVZjY05Ec3By?=
 =?utf-8?B?OWI2SHlsMWNzQXNVOEdLY3FzWWNKeE81amxpWEN5SWhsNkwrTzlkUnR0SzQx?=
 =?utf-8?B?TEYwTDc0d2dydGlrcXVhRzRqcFNDUEtSdmYveldBb2FJSFpiZmV3NHJBSHNF?=
 =?utf-8?B?TUQ1QXBobmdDMTFiNzlXbmxDZjlZZmc5VnBzd0VrRVRzeDQ1MFREc2ovVm5a?=
 =?utf-8?B?M005MCt0T2JIWWlKVTV4S2NRelhadmpsOVJmWEIxN2Ewd25rZ0Zta1V2dFhj?=
 =?utf-8?B?SVJ6RjVkVFQrYXF2cE9KcElIYkhsWnJPbDk4ZGFIcmUycGNFMWdNMGZuZWFB?=
 =?utf-8?B?TXpUdkxBTG00Z2tFbUFxZ2ovb29yVHRjMlErVi9rb1I4dGJ3WGQ0UW9aREJz?=
 =?utf-8?B?Z1RHeGJsK3Q2R1I1b0lhc3hMV24zdXRtOWI3RzhJVWVhWWpLNE9XbG4zbFJO?=
 =?utf-8?B?Qk1tYkRGOVhTSjgxY2dwNWRUSVAxMXYzZUlKSzErWW1aY0l1bGo1T2VxeHdk?=
 =?utf-8?B?NXlZR09VWHVnalVuK0hPb09vQlJ0NDNuVnZ2Q3dJMGphL2pZY2dzZHBXRjE0?=
 =?utf-8?B?alVpcmc5TWhSSVpoaUh4NVp6SjBWN1g3NXJKUUVuQnBhN0kyMjdKZURYMWFZ?=
 =?utf-8?B?Ymk4TXV3UVU2dmNHNG1jMGJWWVpQRG5KcDgxKzRkYjNRSFZhUWtId2QzZG9X?=
 =?utf-8?B?OHN2Wm1vMUp3ZzVuempBRHRNMkY3TSs1TENDQ1FIWS8vSjQ3NDFKdUh6SW4z?=
 =?utf-8?B?WHBScGRWKzR2cmkxRjI3MWJVK2p4ZWo1dzZmbGVVcHBDcHpxTTR1VnJUSi9S?=
 =?utf-8?B?RytIc0JRNWdSMUNuUDBmZll0ZkdXc1gzZ05ZUkZDaFVCREFLT3NWQnpIRTJC?=
 =?utf-8?B?WWVhUnMrNGRGQW0rN28yaER2U1F3V0ZqSzhURTB3Z3VIaUM4ZDh2YUMwSEtI?=
 =?utf-8?B?R09kTFRzVC92NjBIem0rZEViOHFhQSs0ZkdvYmliMVhzUnU3RytCeHZ0ckZR?=
 =?utf-8?B?dmJxR1JjOEhJVnJvRWJaakRrUnVVMnBlYktXZ0dDV2hRV1J0WTgycDhFUURQ?=
 =?utf-8?B?TlVtRG80Ty9tSkY1NVJSSGVMMkQ5T0ZiOGZneHVlYkljbzNPM1c3U2V1eFJJ?=
 =?utf-8?B?S1RUei9SdjlmRUdvS2hrLytsRk1BejBmZHEzWE5HSnJyRkFybXhiUytST3Q1?=
 =?utf-8?B?dUpnaGc0S0UvQld2NmRlWEZLN3NlblYvYWlpTngwa0ZnaktWTXplbTBRYkxw?=
 =?utf-8?B?RXU3YzVDelVUampYdlFuaHkyY3J4QkhtU0M5bG4rUlNGa0dQZlg4WDUrL2Fp?=
 =?utf-8?B?T2tzbmQ0OTNES0xqU0JaQzErNmR3T3dQMXBsVFZuVFA5T2JJOTBLL1REV2ZO?=
 =?utf-8?B?NXJsOUgwMkprSHJ3NWRrTS81aDFORTNNMmFFU2dDdHJKRGhsdXRDaE5VamEw?=
 =?utf-8?B?S3BDcWthSWxJL2VHcWlqSHRjOVl5aWI5K1FKMXRKVXdnOXBGR3F5c2lCTDA2?=
 =?utf-8?B?Mit2bFV1ZnRSU3BrWC9IK3VuNWllUk4rSVhaN0FaUzdvcko4ODhvaGZOOEJw?=
 =?utf-8?B?M1QvSkxZMHQ0V2dHWHhjc2RTVTA4ZzZKN0RocEZucFZxTXlTZE9mK2o1UUdm?=
 =?utf-8?B?blE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ef0826-c37d-4a8d-e559-08dd99c3f80a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2025 06:35:11.5220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PD4uvRcuwjrHG0FgC4yk4odbyU2Zn6ZgZNf9Y3J/lmvrE0opx+jExymDJXbdfGujt0LlW2+rcBRG9S8plbcSyDaan1TMvJltFZXEt2cTOrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6810
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiBTZW50OiBGcmlkYXksIE1heSAyMywgMjAyNSAzOjE4IEFNDQo+IFRv
OiBSZXNoZXRvdmEsIEVsZW5hIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPjsgSGFuc2VuLCBE
YXZlDQo+IDxkYXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IENjOiBSYXlub3IsIFNjb3R0IDxzY290
dC5yYXlub3JAaW50ZWwuY29tPjsgc2VhbmpjQGdvb2dsZS5jb207DQo+IG1pbmdvQGtlcm5lbC5v
cmc7IFNjYXJsYXRhLCBWaW5jZW50IFIgPHZpbmNlbnQuci5zY2FybGF0YUBpbnRlbC5jb20+Ow0K
PiB4ODZAa2VybmVsLm9yZzsgamFya2tvQGtlcm5lbC5vcmc7IEFubmFwdXJ2ZSwgVmlzaGFsDQo+
IDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBN
YWxsaWNrLCBBc2l0IEsNCj4gPGFzaXQuay5tYWxsaWNrQGludGVsLmNvbT47IEFrdGFzLCBFcmRl
bSA8ZXJkZW1ha3Rhc0Bnb29nbGUuY29tPjsgQ2FpLA0KPiBDaG9uZyA8Y2hvbmdjQGdvb2dsZS5j
b20+OyBib25kYXJuQGdvb2dsZS5jb207IGxpbnV4LQ0KPiBzZ3hAdmdlci5rZXJuZWwub3JnOyBk
aW9ubmFnbGF6ZUBnb29nbGUuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjYgMi81XSB4ODYv
Y3B1ZmVhdHVyZXM6IEFkZA0KPiBYODZfRkVBVFVSRV9TR1hfRVVQREFURVNWTiBmZWF0dXJlIGZs
YWcNCj4gDQo+IE9uIFRodSwgMjAyNS0wNS0yMiBhdCAxMjoyMSArMDMwMCwgRWxlbmEgUmVzaGV0
b3ZhIHdyb3RlOg0KPiA+IC0tLSBhL3Rvb2xzL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1
cmVzLmgNCj4gPiArKysgYi90b29scy9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlcy5o
DQo+ID4gQEAgLTQ4MSw2ICs0ODEsNyBAQA0KPiA+IMKgI2RlZmluZSBYODZfRkVBVFVSRV9BTURf
SFRSX0NPUkVTCSgyMSozMisgNikgLyogSGV0ZXJvZ2VuZW91cw0KPiBDb3JlIFRvcG9sb2d5ICov
DQo+ID4gwqAjZGVmaW5lIFg4Nl9GRUFUVVJFX0FNRF9XT1JLTE9BRF9DTEFTUwkoMjEqMzIrIDcp
IC8qDQo+IFdvcmtsb2FkIENsYXNzaWZpY2F0aW9uICovDQo+ID4gwqAjZGVmaW5lIFg4Nl9GRUFU
VVJFX1BSRUZFUl9ZTU0JCSgyMSozMisgOCkgLyogQXZvaWQgWk1NDQo+IHJlZ2lzdGVycyBkdWUg
dG8gZG93bmNsb2NraW5nICovDQo+ID4gKyNkZWZpbmUgWDg2X0ZFQVRVUkVfU0dYX0VVUERBVEVT
Vk4JKDIxKjMyKzExKSAvKiBTdXBwb3J0IGZvcg0KPiBFTkNMU1tFVVBEQVRFU1ZOXSBpbnN0cnVj
dGlvbiAqLw0KPiANCj4gW1NvcnJ5IGZvciBub3QgbWVudGlvbmluZyBpbiB0aGUgcHJldmlvdXMg
dmVyc2lvbi5dDQo+IA0KPiBOaXQ6DQo+IA0KPiBJIGFtIG5vdCBzdXJlIHdlIG5lZWQgdG8gY2hh
bmdlIHRvb2wgaGVhZGVycy4NCj4gDQo+IFBlciBjb21taXQNCj4gDQo+ICAgZjZkOTg4M2Y4ZTY4
ICgidG9vbHMvaW5jbHVkZTogU3luYyB4ODYgaGVhZGVycyB3aXRoIHRoZSBrZXJuZWwgc291cmNl
cyIpDQo+IA0KPiAuLiBhbmQgdG9vbHMvaW5jbHVkZS91YXBpL1JFQURNRToNCj4gDQo+ICAgLi4u
DQo+IA0KPiAgIFdoYXQgd2UgYXJlIGRvaW5nIG5vdyBpcyBhIHRoaXJkIG9wdGlvbjoNCj4gDQo+
ICAgIC0gQSBzb2Z0d2FyZS1lbmZvcmNlZCBjb3B5LW9uLXdyaXRlIG1lY2hhbmlzbSBvZiBrZXJu
ZWwgaGVhZGVycyB0bw0KPiAgICAgIHRvb2xpbmcsIGRyaXZlbiBieSBub24tZmF0YWwgd2Fybmlu
Z3Mgb24gdGhlIHRvb2xpbmcgc2lkZSBidWlsZCB3aGVuDQo+ICAgICAga2VybmVsIGhlYWRlcnMg
Z2V0IG1vZGlmaWVkOg0KPiANCj4gICAgICAgV2FybmluZzogS2VybmVsIEFCSSBoZWFkZXIgZGlm
ZmVyZW5jZXM6DQo+ICAgICAgICAgZGlmZiAtdSB0b29scy9pbmNsdWRlL3VhcGkvZHJtL2k5MTVf
ZHJtLmggaW5jbHVkZS91YXBpL2RybS9pOTE1X2RybS5oDQo+ICAgICAgICAgZGlmZiAtdSB0b29s
cy9pbmNsdWRlL3VhcGkvbGludXgvZnMuaCBpbmNsdWRlL3VhcGkvbGludXgvZnMuaA0KPiAgICAg
ICAgIGRpZmYgLXUgdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIGluY2x1ZGUvdWFwaS9s
aW51eC9rdm0uaA0KPiAgICAgICAgIC4uLg0KPiANCj4gICAgICBUaGUgdG9vbGluZyBwb2xpY3kg
aXMgdG8gYWx3YXlzIHBpY2sgdXAgdGhlIGtlcm5lbCBzaWRlIGhlYWRlcnMgYXMtaXMsDQo+ICAg
ICAgYW5kIGludGVnYXRlIHRoZW0gaW50byB0aGUgdG9vbGluZyBidWlsZC4gVGhlIHdhcm5pbmdz
IGFib3ZlIHNlcnZlIGFzIGENCj4gICAgICBub3RpZmljYXRpb24gdG8gdG9vbGluZyBtYWludGFp
bmVycyB0aGF0IHRoZXJlJ3MgY2hhbmdlcyBvbiB0aGUga2VybmVsDQo+ICAgICAgc2lkZS4NCj4g
DQo+ICAgV2UndmUgYmVlbiB1c2luZyB0aGlzIGZvciBtYW55IHllYXJzIG5vdywgYW5kIGl0IG1p
Z2h0IHNlZW0gaGFja3ksIGJ1dA0KPiAgIHdvcmtzIHN1cnByaXNpbmdseSB3ZWxsLg0KPiANCj4g
Li4gSSBpbnRlcnByZXQgdGhlIHVwZGF0aW5nIHRvIHRvb2xzIGhlYWRlcnMgaXMgbm90IG1hbmRh
dG9yeSAodW5sZXNzIGJ1aWxkaW5nDQo+IHRvb2xzIGZhaWxzIHcvbyB0aGUgbmV3IGZlYXR1cmUg
Yml0IGRlZmluaXRpb24gd2hpY2ggSSBiZWxpZXZlIGlzbid0IHRoZSBjYXNlIG9mDQo+IFNHWF9V
UERBVEVTVk4pLiAgVGhlIHRvb2xzIG1haW50YWluZXJzIHdpbGwgZXZlbnR1YWxseSBkbyB0aGUg
c3luYy4NCj4gDQo+IEJ1dCBvbiB0aGUgb3RoZXIgaGFuZCwgbW9kaWZ5aW5nIHRvb2xzIGhlYWRl
cnMgaW4gdGhpcyBwYXRjaCBhbHNvIHJlZHVjZXMNCj4gdG9vbHMNCj4gbWFpbnRhaW5lcidzIGVm
Zm9ydCBpbiB0aGUgZnV0dXJlLg0KPiANCj4gVGhhdCBiZWluZyBzYWlkLCBJIGFtIHVuY2xlYXIg
d2l0aCB0aGUgcnVsZSBoZXJlLiAgUGVyaGFwcyBEYXZlL0luZ28gY2FuIGhlbHANCj4gdG8NCj4g
Y2xhcmlmeS4NCg0KDQpUaGFuayB5b3UgS2FpISBJIGFtIGFsc28gbm90IHN1cmUgd2hhdCBpcyB0
aGUgcnVsZSBzaW5jZSBJIGhhdmUgY2hlY2tlZCBiZWZvcmUNCmFuZCBkaWZmZXJlbnQgcGF0Y2hl
cyB0byB4ODYvY3B1ZmVhdHVyZXMuYyBkbyBpdCBkaWZmZXJlbnRseSAoc29tZSBkbyB0aGUNCnVw
ZGF0ZXMgdG8gdG9vbHMgYW5kIHNvbWUgZG9uJ3QpLg0KSSBhbHNvIHdvdWxkIGxpa2UgdG8gaGVh
ciBzdWdnZXN0aW9ucyBmcm9tIERhdmUgYW5kIEluZ28gb24gdGhpcy4NCg0KQmVzdCBSZWdhcmRz
LA0KRWxlbmEuDQo=
