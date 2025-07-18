Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5463E1C4609;
	Fri, 18 Jul 2025 12:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752840210; cv=fail; b=S0UHBXvjcVRYtkre38c9fLqWi8YFBRd44Vss/2iwPXCyO2NxNVk9DRRgKQFeQslFHAaado5w9QRQLIQAl/IfolrTqj/NuQ/pymn6lN1t8x1Blk+jfvrYl0LlB1p6LW2Hq0eKzPATzcZT4Ox6qeftGHJXoxTEf4LtezDGlS3/l2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752840210; c=relaxed/simple;
	bh=GwOBHaJ5vHeP5/XWc/lNiDNTYQCS9ai5uM3XG/kWOjg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kc46MFTk83VnFTJ/512pVuT7rQCHyigBiQm0p+ZkRYBt7SD0m2JVWo9XQWuV5u4+w0U5AkIPdOferKQlm2XQvFL1CrYyjrc4l0Z7C9W1nnBZHflziTeaLQg5QM8muA2tV1UwiiRCqbfY0h627coy6FAI9IKAxMwP1a0TwJAoqEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SFDDoMXc; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SFDDoMXc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752840208; x=1784376208;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GwOBHaJ5vHeP5/XWc/lNiDNTYQCS9ai5uM3XG/kWOjg=;
  b=SFDDoMXc+hfVDikMSaXCIetrsQna+56Jm+saGAXGeX0Nc4N6geQjbC31
   nSIkJ7m2r6DVmKkslQrdzNZfdD28MnoOja0qKxEpeROZOxYwrQEjLJOdg
   EaU7XheMK+4s7s7mBbFzsWfNH5iuJ8qkxFSvhZvO/Sm6d6JWW1tFNAfNs
   OzxbOi6VmKlMc9jz2FXwB1bCzJQ8PX7QAtfdUNKV08Mq5rlsJwSvCvSUb
   meEzFS65bLu4Wk/DrZqhkegWImLl+2qO3ysUu1awgbykdzV5fPxvxUwHx
   J5Jqv2coYCqyJTFoyDDXq+RxlXrJimOEEOMFSGHbFr2+OapRvjP9Bz4Qv
   g==;
X-CSE-ConnectionGUID: 318kjn3dTbSpOc7tpl3VWg==
X-CSE-MsgGUID: arQJ+NfSRn6VuTwF49UTOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11496"; a="57746273"
X-IronPort-AV: E=Sophos;i="6.16,321,1744095600"; 
   d="scan'208";a="57746273"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 05:03:28 -0700
X-CSE-ConnectionGUID: 8X4qF6aKQi2csEVlqCYCBA==
X-CSE-MsgGUID: gi7YMq96QnKR+r7eE4AhMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,321,1744095600"; 
   d="scan'208";a="195172826"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 05:03:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 05:03:27 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 18 Jul 2025 05:03:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 05:02:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykGssquPjFPQS5OKiCRLC1GkhINm+FaqJfGNPiPQ6I+KJ4dClx0DBJuheF8syNoC5Z8iApC+qtRAJHqaZqT+dZR7oZRKylUF3qu1K0OZ1c+lfT7YG7gIwHsUaKe7/yFAqE3gTXNw+p6YFvXGxHx4KpCSbCxSLaPC0hVHtqTq2M++g70ucFvkzxKG9FH6DMwa79w6h5mOJTCXXYGKDP/B2/8oWpwRPxb302oOy+E7B7HRjevAue/Qk6gXMdqE1elSIbUQQJ7r6r2wBi5VwvXjGlP3QwpVctgyEUzgUeZ5lDrlXwuIettKCmfr0e3vTMRXEWodm6EvPGqGMlinfPJqhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GwOBHaJ5vHeP5/XWc/lNiDNTYQCS9ai5uM3XG/kWOjg=;
 b=aOkuHydm0xSex5i+jKWyv6Hwh5Qr2m9XOyHuIzMhg768STtdtKPXd/o9bBarld+BcxDZZiuJbYo6ITFHi09v59gZpSNpkSuOyG8uEzE4Chrfc5Zv5jiAWlIwe+f5hlXe9GRHztYZld9Kvo1EdbqlKF6avJyZYBqAIaelO7SnqQhX5swLekwNIbltkTbX3jnrhbk9tp4+vU37YgJCz7xCmMtaRshHnwjeHAHWHM+7if7NjShE+UTInrFIWrWQQWLndbMqodDOihqkT5CyRSPLqF4DL0jNW5zREte1vzXjMfaaaeeSvYDC0Vketaqkm/Wq7wpPzaNzPUWfuVZt5MNrGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DM4PR11MB6096.namprd11.prod.outlook.com (2603:10b6:8:af::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.27; Fri, 18 Jul 2025 12:02:26 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8901.030; Fri, 18 Jul 2025
 12:02:26 +0000
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
Subject: RE: [PATCH v8 0/5] Enable automatic SVN updates for SGX enclaves
Thread-Topic: [PATCH v8 0/5] Enable automatic SVN updates for SGX enclaves
Thread-Index: AQHb9YXNQ4zWIUQtREyUPaYsEeAc4bQ3U+sAgAB4liA=
Date: Fri, 18 Jul 2025 12:02:25 +0000
Message-ID: <DM8PR11MB575047AB38A75490E3974640E750A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250715124109.1711717-1-elena.reshetova@intel.com>
 <0dcb59cb4ccc186209ae90ea49611a37c6008fc3.camel@intel.com>
In-Reply-To: <0dcb59cb4ccc186209ae90ea49611a37c6008fc3.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|DM4PR11MB6096:EE_
x-ms-office365-filtering-correlation-id: b6a33631-da0b-4816-2798-08ddc5f2f62f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RXF4anluZlBnd1B1WkZLZ1Q3WjYrODQ3Ry9QTVVHSXlTWDQxNXVtTVpURlli?=
 =?utf-8?B?cGl6YkJaSExsOWxqOU1HRVFkY0ZoMGJzZ0FWUFMyTVhxK0tSRHNaZjRMYktm?=
 =?utf-8?B?UmE0UmtnV1BRZGdWV2ZIMkpLdnNDRXBPaTEvOXlFam94S1djU1c3OVNFT0sx?=
 =?utf-8?B?Uk5CbURWS2tvVWE5d2lBdm5HbC9NMDNxa3RqdFRCNDFZV0RzTytDRktvNTY2?=
 =?utf-8?B?TjlIMFRGdU9ISkFLUysrYk9kd1dtUUNRMXV2YnVCSkhMeUxmMENZOForSzlE?=
 =?utf-8?B?aWxNWldnV0lML2dMd3B1MVRxb3VFd0M0OVpYQU93KzdTZkdLaGVjT3B5dlNv?=
 =?utf-8?B?dGNHbnpZaGJ0Ym1odzFHS3h5QU11RTAzd1puMGFyMXNGUTdLeUkycTFDMFRG?=
 =?utf-8?B?NDZXS1N5blRka1NQYTJ3MjNUbUprNURjdWoyNHJ0bUh0MDdCRFd0ZE1DblV3?=
 =?utf-8?B?MWVNQUtoc2N5YUxYbmlQSVpuVXpSZkxIN0w5dnRtVE9ZZW9ZVEtGcXdHUkJs?=
 =?utf-8?B?YlRsZERWZE1zTVFtZ1dOQlZmTU5PWjRzRS9sQjNuVGRXREhVZnVKdVNxMStM?=
 =?utf-8?B?K2l2ODRUQmRMWU1oRm5aUlVKc1JvZUNhbUFGRzFoQW5zNVAwQVVQVnBrWlRs?=
 =?utf-8?B?cnBGcW9KVmduY3ViNVdjMEYyTmdvODhVYitzbDN2TFV3ZEFxYzZYamRYSW5N?=
 =?utf-8?B?MGMybGVQbjc0NThwWlYvSkFrV3g1ZS8yVWExUGRtUHk2SThzUkZRUFRDT2VX?=
 =?utf-8?B?b04ydm4ra0trc3BGeDJCQ0l0K3hZbDVwWkpIQnY3aWZUcTYyeDR6enhkc09a?=
 =?utf-8?B?UEg4TmJjUWhNaHNURVRicWp3VHcxdm11bFdJZXc1NnduUDdrdlNrSGtPVFE2?=
 =?utf-8?B?SkZmaTVnRkxHVVJvb1M5eEZ4dHY2YlNWWEtmWTV2TitHRE9rOXhsOW9KMWUv?=
 =?utf-8?B?N2JZR1lvK3hVMWtYeEwzWEVVNnRLbTlNekI2Z2QvOWdrUEVyRFcvWnJnTGlu?=
 =?utf-8?B?eldNUDI5cUtjUWJYVVpKY3pDZUFxRURvZUsrek5XVncvdGVheExsd0s2aGhC?=
 =?utf-8?B?OHlVZk9HTnZEOGdkWHF2bDR0a3Z5RlB2V2V6Q3JIVXpaVFlFbSsrL2dPOW0w?=
 =?utf-8?B?M2hXUHQxb0dQS2dyM0xSMVlqVXRHanZUcXpWb1pzb2JwR1hpU0hFSUYrRnYy?=
 =?utf-8?B?M1pTT0Rncm9pNi9icFUxL1F2aTNPaTE5VGo0a2E5amFCc3RBeUZmZWF0WHNh?=
 =?utf-8?B?NSsyMzYwS3VQbHd6ejlHL0s4dGxtY0Vid0hXaGtGZlY1aGNVOWZRcTEweFdj?=
 =?utf-8?B?RnVXVVF5RDRuMGxHZCtNOE9YanNTTmMwZlZiQXJOL3VCRURHTGpMa0d6TzdV?=
 =?utf-8?B?SHZGUmFEb1NxeTc0TWE0R05RQ0NQMWVJZVBrSlJLSHFCY2JpUlVFb3J2QVBW?=
 =?utf-8?B?SklnbjNBUkNTY2YxZG45NHFRRVMxMENaam9QVUI5ZGE1WDdDeTZ1NUpWcHg4?=
 =?utf-8?B?aVNFLzNHQ2lLVkVYTGUxaWNvSHJacTV5dTJTK3Bubm93NDVBaGxEaEZ2QU1E?=
 =?utf-8?B?azdONC9qTTlsYThEVXZLcVJhaVFpQzRIcFU3STdLb3M0M0NYT0lOaU9sS2FH?=
 =?utf-8?B?N1pzc1FxVFdidnlmbWkyem5kK0RDRDFuUkZSbmdPWlVqTFBJQWRjMzd2eVlY?=
 =?utf-8?B?Yjc5Vy9lZnpGVFFPTXBKN1R0OVdocWJYek15MWYwZC9BZFF3WXZnOG8wQkY0?=
 =?utf-8?B?S1VLcmJiU2ZSQVUyVEN2emdmNkV1aVpsdWl1cjF4amJTSkpWcERnT1dZeHRo?=
 =?utf-8?B?bS8zSDU4c1BNbGo1cGc1alBBZ1FRb2tQY1JtalRPRlljS3NJUmVESml6aFdt?=
 =?utf-8?B?TTRmUmNWSnhHYmFCTzZkQVRHczJOT3o0MjRWV1V4b3RueG01a2Y2ejJXODVa?=
 =?utf-8?B?SWo3eGY0SFd0Q0V5L1VSQ0grODROK0xxQnc4TTdoSzBqUXdZemNaeGN2V3Bu?=
 =?utf-8?B?a1lSYndqRkpnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkxxbUY4c3lzRmUvQktTMnRwcXFxaWlFUjZWOHRqbUExYk43cDYvcE1zdjds?=
 =?utf-8?B?c25RczJscEhrMW1Ybm1CTFBsa2VYcXFzUVd3MkIxL1AwTFFwSWxMaW5ucUNu?=
 =?utf-8?B?WkhhdldSUXZnMjFaTkpBRTJQc2duZG9GRGNyT3lNdUNYK091aXV6UEJkQWJa?=
 =?utf-8?B?WjhZZTVtTDJQanFrRFFLOU5KdStMMVRoSzFkdVc2RXU2amkxOVg3YWZRMjRu?=
 =?utf-8?B?YTA5NG5kKzMvT3UrUUdaNEhPSEpSWTZoTm5Oa3d2dXkxLzRjZW1Ybjd5SnFO?=
 =?utf-8?B?WmlKaFlDOGQyd21JWlFwWVRIQ1VXR2xjaDc3VWJpdDhiTDc3YlJrZGJDM0NN?=
 =?utf-8?B?WHNpNTdLblVMVXpFYzhmeVRHOFRKcFRkRTNJM0lLZGNYL3NyY1piOEh6N1gx?=
 =?utf-8?B?ZG9rZlpPWHZNdDZCbGJOSmZha3F1ZHJSajZ1SDZjOWtKankyT0Nub2QzeHNI?=
 =?utf-8?B?ckJuZEMzOFVmV0syZE1haktBdGU3RFBtZUtGT3I5aFNiMlRRN3krT2tqUCtR?=
 =?utf-8?B?ZkVjbU5NQ1E3VnhIV2ZsTWw4VlhEZFU1bHBDNHlLUHY3ZkltNi9FdCtHdFA4?=
 =?utf-8?B?QVE0emxqMVcwWnExeTRoYWZoaW5oVkt1TVNDaTV3NmRieGNldEU1ZE14T3FM?=
 =?utf-8?B?d3ZFVTFpZVpxdXp0ZnlHbjhoSTg4Y1dHYjVJQytsV1V3Nk1SUWpPM0FObDZW?=
 =?utf-8?B?dHZxT1AxMm9rNVp2b2IzWGFhVmtWMTJGZjhXMjFwdGViUlVnWFNKWmFEemQw?=
 =?utf-8?B?RDR0QVJGTkJJV3kydDZVV0pyZG8zRmtjblBIdjZzMWV4bTZuNzRyNmFHZ0Nl?=
 =?utf-8?B?TFQrS2N6bUticUdsR2l3WEtFS2dGUTlUUWhWZkl4cWR1TkFVcFpWT3ovTmZO?=
 =?utf-8?B?NWRRM0E2TUR6cjhxYkdjcUx4eW41by9qVCsyTzRUUktCVWU1V2pLVkI5MmtQ?=
 =?utf-8?B?eVpJZFFqVkJlaHVFMzk2YU1LMldaTkpsR2twU3YyY21TQmJCbzRVRkRPQ1hK?=
 =?utf-8?B?RFg2RjAvalFPZUFUSUlnUXJnbXpFQUlpS0dHckliWU9Td3VJalowQXZjb3VR?=
 =?utf-8?B?SXhSREpFUng5dWVEb0lyVG03WEIvaUFuRlBRY002U282REhrOFM5c2QrMkRW?=
 =?utf-8?B?MC9MZ2ZYaGpyTi95bnVNZWhsVzY3YStpWWdHejVhbElzRlVLV1laRE9HbnFn?=
 =?utf-8?B?am5QeG91cGpwMFk1L2JVSEJzUHNWNU9SdXJ6SXdjd2cxVW01SVhjYWpneGNr?=
 =?utf-8?B?YWlmd3h5SGRRMVNJaTZLaUZQMlR4NVNaRUgvaGtHZnJ4L0NBQVdrVmNJaHBi?=
 =?utf-8?B?RFZvVExKL1BvWTMwUlozTUp2OVA1Sk54SkVkNC84NXc5VG9taVFlYkJ1dWtG?=
 =?utf-8?B?RmRUMmYvallIUlhtNmd1cEl0ZzRvaTZyR1k5UlFjSytpYjQzcjhlZ2V2TXlP?=
 =?utf-8?B?L011V1RQRXpXVnpabTkyT0dGaUs5VTcyQnJML0tBcVd0WkxIaERXWHhHZGU3?=
 =?utf-8?B?OVp0UGZSdjJpN0Z0VEVNajF3NnM1RW1LUWpNM2tHczRGOWNoZ3d2dVJPSkIr?=
 =?utf-8?B?aWx6U08zM3NMRFZKbmNFemFMYktuTFRtN1crd2hRMzJ2K3FOUVEzdTdmT1Ji?=
 =?utf-8?B?aCtXOXVYaEpmTjcwdnRwckwzSEdrcWtZZ1NFWmFvWEw0QThxdkc5RTBQUzky?=
 =?utf-8?B?ViszM1RLL2t6cWJGc1kzdnNQYWlvRTd5N3hTamtueG9YaDFaTTg3K1prdGEw?=
 =?utf-8?B?TzBnSFg0cmw0WnBXbURZR0JaRnEySTUza1N2YzRwbXJqaXBHWmkzNHJzSS9O?=
 =?utf-8?B?SzNHbkRPeVRmM1hYemlabWdFc0FxZzJsMXNJRC83U1hEcytFN2lEMVlGUHl1?=
 =?utf-8?B?TmFCc1VDNVJGeVBRaHdPQ204M2NVVkZOSmpScGl0ckVmbHdBaTNjQjA5U0xl?=
 =?utf-8?B?UFYzWEZsdTRvTkV2cWF6clVnTzczSVVPRFN6VDhqRHgrcDNPaEk4NENyVFZO?=
 =?utf-8?B?VzByR21EdDZNYUx4cnNWUFpBWkYzWkZiV3FhQkpQZUoyUVB4TFBKSjcwbHpK?=
 =?utf-8?B?djU1T0VGTi9GeWJSWGFPak9oejFVZzRiUDBJUUFBb3BLUGh1T05BUmxuVStP?=
 =?utf-8?B?c2FPZWxTWDBOMzVPUHZLb2pabGl5K2kvb2ZnNERYYlBhRzRUN0lBMFdiK1NY?=
 =?utf-8?Q?TUahwaF+dM9fxpAY1Rnnqztna0AG6bjyHRvhjlLOqjO6?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b6a33631-da0b-4816-2798-08ddc5f2f62f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2025 12:02:25.9197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aZq2j7CbYDVK/+A6UIGhZKh9WS6gP58pYF0CrDXYEUVRI8fBvstW+GWR0UnrOs+HeR3OqHqBfTEn++XZUonEC/4FgFkV4v4/IQilyEsuZbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6096
X-OriginatorOrg: intel.com

DQo+IE9uIFR1ZSwgMjAyNS0wNy0xNSBhdCAxNTo0MCArMDMwMCwgRWxlbmEgUmVzaGV0b3ZhIHdy
b3RlOg0KPiA+IENoYW5nZXMgc2luY2UgdjcgZm9sbG93aW5nIHJldmlld3MgYnkgRGF2ZToNCj4g
Pg0KPiA+ICAtIGNoYW5nZSBzZ3hfdXNhZ2VfY291bnQgdG8gYmUgYSBub3JtYWwgaW50IHR5cGUN
Cj4gPiAgYW5kIGdyZWF0bHkgc2ltcGxpZnkgdGhlIHNneF9pbmNfdXNhZ2VfY291bnQgZnVuYy4N
Cj4gPiAgVGhpcyByZXN1bHRzIGluIHJlcXVpcmluZyBhIG11dGV4IGZvciBlYWNoIHNneF8odmVw
Y18pb3Blbg0KPiA+ICBidXQgZ2l2ZW4gdGhhdCB0aGUgbXV0ZXggaXMgaGVsZCBhIHNob3J0IGFt
b3VudCBvZg0KPiA+ICB0aW1lIGl0IHNob3VsZCBiZSBvayBwZXJmLXdpc2UuDQo+ID4NCj4gPg0K
PiANCj4gRm9yIHRoaXMgc2VyaWVzOg0KPiANCj4gQWNrZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1
YW5nQGludGVsLmNvbT4NCg0KVGhhbmsgeW91IHZlcnkgbXVjaCBLYWkgZm9yIHlvdXIgcmV2aWV3
cyENCg==
