Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288B021D3EE;
	Fri,  8 Aug 2025 10:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754650071; cv=fail; b=ii/zkWe2646rDdnas6f34C2rx9fNnJJ46koXMBcS3mrnA8IU3yC+RIjHge1q23y1YYH77sdeLMV5OsZ0rI+ejkOiiFQF1qacwwn8IB7bNkzPvTaxvxNiujvVNs145Ca+z7rDFSsINd5I3zK4sfAveToyZ3XfAr992pcGfXnWtjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754650071; c=relaxed/simple;
	bh=vg+p800vp2ebI63esa2N7UYb/kJrgP3QnU9g/Ba3HZc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OqgLm+05zssbzKny8uGJJqUcz1d9fznIg+FOX0l2FlGbqjuvbOqg1fkXpCtM0qlIqJQMJRRp+sz3tQjfbyJyvXfncmcQ9sLOH/UZJ/J7rAvE3i0vYpl5kjgIXm3fpLAC6+JImLzJfM10kweErdgLRA1sFn7wq8GjYqJ9t9cFgXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y2OHSH4g; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y2OHSH4g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754650070; x=1786186070;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vg+p800vp2ebI63esa2N7UYb/kJrgP3QnU9g/Ba3HZc=;
  b=Y2OHSH4g4C6j4eSnc6EAK+UtERDavCN7LuTnaqjLvgHtXb9YpN4bLz9c
   5Y0C4wiD2MCeN1RuT1TbEfjNC997b5NHwW9z5XkbtL1Q2i42k/v8e9SS+
   FrVjR4CJuoVaHhOv+kfU/YH+yAhWaVcO+N+pv6Iad4YyOHQ0wpnHoA4T8
   VY8zJKi3ka1gsBaYjMqHZgH1cm3tg53hrysbwue+pzyHa16buSpMxpdmX
   BYTqoLwGxBXuTOLw6YXzeQG8oalCrYBb996asSS7785RH9GaQ4VUH1l8t
   RT9m8fuxFYDjMDnZyoy5N0u4vuJZuAua7FRWGKcW45l+XyKE1GWVdManU
   g==;
X-CSE-ConnectionGUID: RRXE9LO2RPGIqjjBmXGxFg==
X-CSE-MsgGUID: UYGN0ouzQHuMbPR2wndZrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67265919"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="67265919"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 03:47:49 -0700
X-CSE-ConnectionGUID: PuLAbqfSRwGJi31o52wjtQ==
X-CSE-MsgGUID: jmsku2G9RD2zT2PmoM/2dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="164519596"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 03:47:49 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 03:47:47 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 8 Aug 2025 03:47:47 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.65)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 03:47:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqUgXpERp/GfgKbHNmHJxjwLTCGJgJfL/hqAdca0eGXGoaHOLltMOozlwd756vKTcpXRs7D6AryBQgG/vO4tfudraa8aTl5m4qxHXpI3kdCvonYnaoc5CS97YuQTR87gPAVhZirlbLqijVoxMPLVnrm3HK1zavOOTPJVV4LdTSFldBN+Kbtg1zkfFY7zZhp5JDgatJX9M1oc9J2Szaxfb2fygRSrtoWwShmXFzqrlUo2SUwg4qcpXx2pMUNfbJ9nKivu9SpA1tKMVENYR6Sc54dgE+ETgQPNUkCb+hAhB3ITS3CrrFfBiQ9O7J4Agz776njKnixZTJRA42WaMl1dpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vg+p800vp2ebI63esa2N7UYb/kJrgP3QnU9g/Ba3HZc=;
 b=wqOXyGpGUJaRmted8eOJoWX94SumLx7hpYsQAaWpflx6zZnl8BnhrIozdtoxQhmps1xKRRLna1nKpN9OO8zWIGZiwoB0IE8/Q70kTzdZDxU2/14t5gf/g+QsyVdWizTGwSKTRDYDLAFGRf9HI53+G6R8UVz3qCMQA+vjO+DyZPPZeRcxoiUgxDtQ6SxsgsEH7LJrcdjT8HUqgRm4nMhmBs9EFtEzOD8AWydrt2iKSrX8d8oBo4rZCvf2kTo1s4ZJw3ol8+YV9SfLCeCkr7rUC0ZrhkVxNQeDxyRbcTJqLQ9F9DJF4cXEWxmhYVlt5FQ7AZjs+9Z+BdTO5xa6ju9VGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH0PR11MB5901.namprd11.prod.outlook.com (2603:10b6:510:143::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Fri, 8 Aug
 2025 10:47:44 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 10:47:44 +0000
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
Subject: RE: [PATCH v11 1/5] x86/sgx: Introduce functions to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v11 1/5] x86/sgx: Introduce functions to count the
 sgx_(vepc_)open()
Thread-Index: AQHcBqodCIueMwmnM0OScPbkoFc/LrRWSSuAgAJKq5A=
Date: Fri, 8 Aug 2025 10:47:44 +0000
Message-ID: <DM8PR11MB5750D6FD8A6F724BECBCC059E72FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-2-elena.reshetova@intel.com>
 <048064e70c57f95372f8400522914f3ddbc6b94a.camel@intel.com>
In-Reply-To: <048064e70c57f95372f8400522914f3ddbc6b94a.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH0PR11MB5901:EE_
x-ms-office365-filtering-correlation-id: a61aabc4-1a1d-4e35-bc49-08ddd6690187
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WTJDYmNOMWNCOUtWRTJIaGhtTkc0S2ZvRnQ1TDlRMmpQa3AyQWJBRTdqQ2sy?=
 =?utf-8?B?NFpINzNpbEhxa24zWnU3SkhwMEg1anA1TVM4YktQQzFZUmY2NjRUUis3ZnlP?=
 =?utf-8?B?UlFMTDZMUWQva1ljK3hmUzlNdUZHUmY5cFJpcmRya3lUNGRaOGMySVE4YnF5?=
 =?utf-8?B?ZWtDK3kvc0xLZWZwZmkyWU92WmhXQ3FGZ0FMKzd0NjlXZlk1Wmw4KzhpeVVq?=
 =?utf-8?B?c1JBZ1JFU1I3YXJPY0RQSTBWMkprYTNVcFBITEtjTjY4RXJjeFl3SllzOUNy?=
 =?utf-8?B?d2RFMlNrZHhQaTRwVmw1WDB0Z3lhMVJlaDRZbWdYSGFGVVQ4ZmROQXFoS2FJ?=
 =?utf-8?B?aVNHdWlHQ1BwQXZiRXpwSWw0ZThuLzdleldRRHhUalVIWkQvZ0F3SHdtMmF2?=
 =?utf-8?B?VzlHZXZSRE9QMkdFZ3hubUNBYnRuOGxCcC9vS1I5OVRWZDV1SXdUa0ZyVWFE?=
 =?utf-8?B?WFNYMGVBNFppd0k5Z2N4VWovdzZSNHJkcFZwU1U1VWRobXVDVlJMQ2c1SVF5?=
 =?utf-8?B?dU5TUEpmYUZwZDE0N2t4TUwrT0JUeGhOMHV6VU5xWG0reC9oNU1iKzZmMFpa?=
 =?utf-8?B?MUpsU1Y0aE95bTRnMngwTVFCMW5mM2loQ0d1bHNRNDByWTlpdndaSW9iSWQ4?=
 =?utf-8?B?b1pVdzlIWXg4SFdodzkxRTNCUHA4UG5aTk8vWHJrOUxtREZ5Unp4NFliWm9B?=
 =?utf-8?B?SjJjSC9CTE5xNjZvTjRNdElTT1pzT0tmSDFRRnVxMmt5b01FRXRKZ0J0SVAw?=
 =?utf-8?B?elQ1TnFRcmRKeGx5YThyK2x2czRDNFFlTHQ0L1RGZlFKTHVFSGhkS3BHNzlE?=
 =?utf-8?B?WXdnQVZobEhjOVo4a29XQ2hiQ2M1a2sxcjJ2dktSYUhsM3VsMWd3dU4xNUow?=
 =?utf-8?B?d05VaWFHOEhRZmRTd2JYeGZJb2pvTGFyQnlVRGNOb0xqeldIUUptRFBUVjJ4?=
 =?utf-8?B?UEp1djhrR1FYVkdVR3liYnlFRThRSFhlcE1SZG9MNGZIUWVrR3FEY2Zmam1X?=
 =?utf-8?B?ZFJIakhKNXJaeDJoS0E4VTlUNVBVRnN6Nkx5cW16ZzJjU1lDa013U21IbXFn?=
 =?utf-8?B?UG5WVGRNQitvS0FlT2NZdEVqOU9PZGJNMktOQmJxQnp5TXJKRWVlSXZvR0lF?=
 =?utf-8?B?a0VpT3dvMnFRNzE4V2pkWWlMclIxdUdqbUNBZ0VZcWY0Z0hPbFJWcXA1T3Fj?=
 =?utf-8?B?ZWllZVZtMzVPRGlCVS9Rb3piNFBaSW1ubE1vSGNxS1dVVGNqVjVNc1lMMmFw?=
 =?utf-8?B?U3NHSlpFampsVHJuQ3JweEVSMkZWOC9vZjhQNEQ3dWJPYlpBUVJjelhuRFg0?=
 =?utf-8?B?bHd6UGpSSWYyQnJzQUVWUEhDcW1QVnRZM0puQ3Zjcmt4T2lEWTZoVE44M3FI?=
 =?utf-8?B?bjNQZ3l6SHJHZmQyWVM3dU5YRGh5SS9lQ3AyYzRWL1M5dUxzdER5TEMrRHc0?=
 =?utf-8?B?VGlMcmFkMWlCK3IxcTZLOWF4ZVlxTmcrV3FWbTB2MG1LNG1iNEZjQW93bm5k?=
 =?utf-8?B?OUFJdld3dm9CQkJ0TWdwTXlGVG1LNE5pUVRHVGgyaUNNbDJFdkx5YzJkcE56?=
 =?utf-8?B?UDFoZDNQdkEyMndWSFBrMUlDeG5aditUL1RLWm03bFlZaHIybFE0NmtsSnVB?=
 =?utf-8?B?MzdZVUFMdzI5SStjcjVpWGdQTkFUd0tvUlF0MWVoQWNJOGkvcVgwZS9jRSt2?=
 =?utf-8?B?MUhBaEJaOWhJdkdkY05OTFVZcGJqTzZJbFBNR3MyV1IralY3WEZmWjRBcUZX?=
 =?utf-8?B?Ry8rNGNENEhLd3hQTXliQzlOcG12NXZmNWJWRWpUMkZGOEJZSkFsaDN3S0dJ?=
 =?utf-8?B?Ui9XZzNBY0NQUGg4R0VZMGJrb1h0ZDQrRG50ZE9XWmdLaW5rRUtrVU13VGRT?=
 =?utf-8?B?NnhyZkNWenlwTnBLTDc4WnZ6UTFldnNhcmN3SjczYTlwakpZTW9DWnBJalNT?=
 =?utf-8?B?dzBPMlRuMUMvTzBuaGxUQXZmVmdmZk92eTk2aGFJQzZlbmZsZnlXaEg0WkMx?=
 =?utf-8?B?MFJhdCtPajlnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXVhUEhXQWhLa2NBRHZEblVySlIvbVV4K3dPakFFYzR3TFhKanJtU2l1SzdV?=
 =?utf-8?B?STBDWkRrck50c0hCRGhINHFmQis5TzB1bjFWczhHT2VRNnhybk1IRVQvb3Zp?=
 =?utf-8?B?WUtJS1JSL2lsVEJzMnZyVkJNdWx4czJQQzhXdHpyVURoNlhTd3Q3NE1VSFFw?=
 =?utf-8?B?WGRHZW1uZ2JQRlZBNW9wcER3cXJ3UzF5bHROM29HdTVWTjRkRGliYmVncnlr?=
 =?utf-8?B?QWtFanhUdE1hOE9VZklicFp2MlUwMWo0M2JOZ0RUVCtoazhLTTNjMzI5UlZE?=
 =?utf-8?B?NXYvL0JwUkdURXdkMktKMTBUdlNjK29HcnBoTm1ncVJNN2hwNVFYMkZib1BF?=
 =?utf-8?B?ZG5VWk4zMGF2QTl2YVkzMzR4K0pBSndkVVZLbFJGZTdCM0x0UENGbWFlNHI1?=
 =?utf-8?B?bkNmVGtPcExXZUdHVWtIOWZSc240ckgzbmZ2R3N0aWZsZlpyY053MlF0aEVD?=
 =?utf-8?B?UWVFNmgvOG5kUW5LS2dLZVg3YkMxdnBGQ1FRTW1HWFlqRDRRSExLVnBPWU5m?=
 =?utf-8?B?dmF3eUZZQTB2ek11TWJhSi9zdG5mNHVvVUF4UmlTMUFwd0dQNlB3RUtFbU9P?=
 =?utf-8?B?ZGl4N0pUeVppTzJUWjVSdEJsS1ozeFlOdEhvcUs3Vnh3ZXplcStTcENPY0NE?=
 =?utf-8?B?SGF6cWthZVc3UVNpaHlSRXIvb0hJeHNmNERhTmFlZ2FyaGxDVDdUNThyRWN0?=
 =?utf-8?B?dytUUWV3QkdxZ0F1Y3lKc1RtRWVOQUMyQUx3RUZpeCtZYk42cEZNNnJ0NTBv?=
 =?utf-8?B?bU1QcFBJQ0M1OFdmT1ZrVHpac0poWjRrdktIM2FXdjVBY1J0QmhlY2NZQm43?=
 =?utf-8?B?cjdaOHBURzBUVGsra1loWFBJK0dHZzNtanUzMVZyVnpBQXZRMnE1aW0yNUc0?=
 =?utf-8?B?Uk50bHhQa29TSSsyVVhUTE04SXNOOXlPQ3VJYVVlNHBRSi85dnp1Q2docXpQ?=
 =?utf-8?B?QW43bUpPRFVwdUU1ODlZbVBmczdhc2lWUGxBY0FSaVJJRmZFVml1ZlEvVUJS?=
 =?utf-8?B?SnRPQlVaZWhVWlQ3WEk1a3YzanZNTk9Dc3hpbnRyMW9mQkVmUzdVTHZ5Qzl3?=
 =?utf-8?B?bFhBTDVwTXpzZUpNTkhHWk56TmpzZXRFOUM1bTNvV0NvNGdHalZTb3ozZFF3?=
 =?utf-8?B?NTF1MEhuZ2JacGFzcjhTcmhaczVmcm1QaUdxaGFaMEhLeW5Xa3pZTitRZ0hJ?=
 =?utf-8?B?bW9tUmtuN2pQRk5INlhuMDFqWnNFNW1MZU52NFk2OUEybVBkK3pkUlptRE96?=
 =?utf-8?B?MTJ0T1pPMldSQWhDM0VYVmIvMnU3cDYyWHlIWEVxRWFnYjVBSHErRmQ3OFBn?=
 =?utf-8?B?VVpQcC82aTQwb2dTdkJmZ2ZUTVV4SVFIVUFZNHA2TzdmNjI0VlJCTDV4TE4v?=
 =?utf-8?B?SE45WnlqNFhUTnJCZk1weTdhU0xhUm9UNWFiOUdZLy9yV1lyNjNrbkdmR0JY?=
 =?utf-8?B?RnVVK2MwdkplaEFQRGlzdTNUZ2RaS3VrM2lSWFlUVWZyT2owNnlENzU1STJi?=
 =?utf-8?B?LzR0Y24yRzZ4OWZHYSsxRU1xQnlSa2d2NjgrRlFsUjgxOXhER2FpclQ1YzMy?=
 =?utf-8?B?N2NGV2JUMmNHRklJR3F4aTZSQU1FQjlOa01nckNlS3k3YVBtSjBYWElYcXQ1?=
 =?utf-8?B?TFpWVUlPcGJBK3FPaWxBalVyaDV6L2lXQy96bnhEWkgvWnZUeTlJTnFUWllN?=
 =?utf-8?B?YWVqUjFaNzlDYkVBcXVDU0QxM21rbjFpcGY3VVAzR2tvdjlXNmI5RVVqQmFr?=
 =?utf-8?B?Q2x3Sis2WWpiQ1FrNHBSd3FEeXlpRjdhblNhRFRWMzNIeHg2WExMWDYyZmZS?=
 =?utf-8?B?MFo2RVRrNG1kZzJLWGZBY2hOeVk4amhlRjVvaXozMTN6VUxNQTlBZ3pieVJT?=
 =?utf-8?B?cm1iUFpEMlBDVy9RSHdmYWt1dGhQcGdJREFvcDUxU2RZVWJZTElTUXZlcG9y?=
 =?utf-8?B?UFFIWkJ5cGVLQkFKMWpHU2lKQzNQWHNCVzY1SzZzMi9iZmcxajRWVjg3WWpI?=
 =?utf-8?B?UWlrR2lvVzJlZXU1T1AxODhqbS9INTVBYWh5NlZLTm5hbDJBUlVDbGttd2E5?=
 =?utf-8?B?VkE2YWovNjJVWGpuZ1lxUXNieDdjaktRTE5JRjBJM2FJZ3BjTjhyRHViZGRo?=
 =?utf-8?B?Q3QxWUVyd3liQU5IRjhSaVJvZmpRVnBLTEVSRTgvVWhJRzkvc2dsb3l4SDlr?=
 =?utf-8?Q?FJII2r6iB+sFRdsXj1Nng6dmIdFW9h7WmzTwjAupbPYu?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a61aabc4-1a1d-4e35-bc49-08ddd6690187
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 10:47:44.2031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lK5H8lISXtj8YxzYyq/c4Rh04A6uhJlJLbUwpuhjjEyYx8/MtL1kF5mbMOEHe6THLnZSnr29zaapUcsrK4umiorhQlOsZcwANilKXYn8y9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5901
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCA3LCAyMDI1IDI6Mzkg
QU0NCj4gVG86IFJlc2hldG92YSwgRWxlbmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+OyBI
YW5zZW4sIERhdmUNCj4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4NCj4gQ2M6IHNlYW5qY0Bnb29n
bGUuY29tOyBtaW5nb0BrZXJuZWwub3JnOyBTY2FybGF0YSwgVmluY2VudCBSDQo+IDx2aW5jZW50
LnIuc2NhcmxhdGFAaW50ZWwuY29tPjsgeDg2QGtlcm5lbC5vcmc7IGphcmtrb0BrZXJuZWwub3Jn
Ow0KPiBBbm5hcHVydmUsIFZpc2hhbCA8dmFubmFwdXJ2ZUBnb29nbGUuY29tPjsgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZzsNCj4gTWFsbGljaywgQXNpdCBLIDxhc2l0LmsubWFsbGlja0Bp
bnRlbC5jb20+OyBBa3RhcywgRXJkZW0NCj4gPGVyZGVtYWt0YXNAZ29vZ2xlLmNvbT47IENhaSwg
Q2hvbmcgPGNob25nY0Bnb29nbGUuY29tPjsgQm9uZGFyZXZza2EsDQo+IE5hdGFsaWlhIDxib25k
YXJuQGdvb2dsZS5jb20+OyBsaW51eC1zZ3hAdmdlci5rZXJuZWwub3JnOyBSYXlub3IsIFNjb3R0
DQo+IDxzY290dC5yYXlub3JAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxMSAx
LzVdIHg4Ni9zZ3g6IEludHJvZHVjZSBmdW5jdGlvbnMgdG8gY291bnQgdGhlDQo+IHNneF8odmVw
Y18pb3BlbigpDQo+IA0KPiANCj4gKHNvcnJ5IGZvciBiYWNrLWFuZC1mb3J0aCBhbmQgbm90IHNh
eWluZyB0aG9zZSBiZWZvcmUsIGJ1dCBzaW5jZSBJIGZvdW5kDQo+IHNvbWUgaXNzdWVzIGluIHRo
aXMgdmVyc2lvbiBzbyBJIGZlZWwgSSBzaG91bGQgc3RpbGwgcG9pbnQgb3V0LikNCg0KVGhhbmsg
eW91IEthaSBmb3IgeW91ciByZXZpZXchIExhdGVyIGlzIGJldHRlciB0aGFuIG5ldmVyICkpDQoN
Cj4gDQo+IE9uIFdlZCwgMjAyNS0wOC0wNiBhdCAxMToxMSArMDMwMCwgRWxlbmEgUmVzaGV0b3Zh
IHdyb3RlOg0KPiA+IEN1cnJlbnRseSBTR1ggZG9lcyBub3QgaGF2ZSBhIGdsb2JhbCBjb3VudGVy
IHRvIGNvdW50IHRoZQ0KPiA+IGFjdGl2ZSB1c2VycyBmcm9tIHVzZXJzcGFjZSBvciBoeXBlcnZp
c29yLg0KPiANCj4gRmlyc3QsIHRoZSB0ZXh0IHdyYXAgb2YgdGhpcyBpcyBub3QgY29uc2lzdGVu
dCB3aXRoIG90aGVyIGxpbmVzLiAgSXQNCj4gYnJlYWtzIHRvbyBhZ2dyZXNzaXZlbHkgQUZBSUNU
LiAgSSBwZXJzb25hbGx5IHNldCB0ZXh0d2lkdGg9NzIsIGJ1dCBJJ3ZlDQo+IHNlZW4gb3RoZXIg
cGVvcGxlIHN1Z2dlc3RpbmcgdG8gd3JhcCBhdCA3NSBjaGFyYWN0ZXJzLiAgQnV0IHRoaXMgbG9v
a3MgdG9vDQo+IGFnZ3Jlc3NpdmUgYW5kIG5vdCBjb25zaXN0ZW50IHdpdGggIG90aGVyIGxpbmVz
Lg0KPiANCj4gSSBhbHNvIG9ic2VydmVkIHRoaXMgcHJvYmxlbSBpbiBvdGhlciBwYXRjaGVzIHRv
by4gIENvdWxkIHlvdSBjaGVjayBhbGwNCj4gY2hhbmdlbG9ncyBhbmQgcmUtd3JhcCB0aGUgdGV4
dCBpZiBuZWVkZWQ/DQoNCk9rLCBJIGNhbiBkbyB0aGUgNzUgd3JhcCwgSSB0aGluayB0aGlzIGlz
IGNvbnNpZGVyZWQgc3RhbmRhcmQuIA0KDQo+IA0KPiBCYWNrIHRvIHRlY2huaWNhbDoNCj4gDQo+
ICJ2aXJ0dWFsIEVQQyIgaXMgYWxzbyBvcGVuZWQgZnJvbSB0aGUgdXNlcnNwYWNlLCBzbyB1c2lu
ZyAiaHlwZXJ2aXNvciINCj4gZG9lc24ndCBsb29rIHF1aXRlIHJpZ2h0IHRvIG1lLg0KPiANCj4g
QWxzbywgaXQgd291bGQgYmUgYmV0dGVyIHRvIG1lbnRpb24gdGhlICJ3aHkiIGZpcnN0LCBzbyBw
ZW9wbGUgZG9uJ3QgbmVlZA0KPiB0byBmaW5kIG91dCB0aGUgcmVhc29uIGFmdGVyIHJlYWRpbmcg
dGhlc2UgImhvdyJzLg0KPiANCj4gSG93IGFib3V0Og0KPiANCj4gQ3VycmVudGx5LCB3aGVuIFNH
WCBpcyBjb21wcm9taXNlZCBhbmQgdGhlIG1pY3JvY29kZSB1cGRhdGUgZml4IGlzDQo+IGFwcGxp
ZWQsIHRoZSBtYWNoaW5lIG5lZWRzIHRvIGJlIHJlYm9vdGVkIHRvIGludmFsaWRhdGUgb2xkIFNH
WCBjcnlwdG8tDQo+IGFzc2V0cyBhbmQgbWFrZSBTR1ggYmUgaW4gYW4gdXBkYXRlZCBzYWZlIHN0
YXRlLiAgSXQncyBub3QgZnJpZW5kbHkgZm9yDQo+IHRoZSBjbG91ZC4NCj4gDQo+IFRvIGF2b2lk
IGhhdmluZyB0byByZWJvb3QsIGEgbmV3IEVOQ0xTW0VVUERBVEVTVk5dIGlzIGludHJvZHVjZWQg
dG8gdXBkYXRlDQo+IFNHWCBlbnZpcm9ubWVudCBhdCBydW50aW1lLiAgVGhpcyBwcm9jZXNzIG5l
ZWRzIHRvIGJlIGRvbmUgd2hlbiB0aGVyZSdzIG5vDQo+IFNHWCB1c2VyIHRvIG1ha2Ugc3VyZSBu
byBjb21wcm9taXNlZCBlbmNsYXZlcyBjYW4gc3Vydml2ZSBmcm9tIHRoZSB1cGRhdGUNCj4gYW5k
IGFsbG93IHRoZSBzeXN0ZW0gdG8gcmVnZW5lcmF0ZSBjcnlwdG8tYXNzZXRzIGV0Yy4NCj4gDQo+
IEZvciBub3cgdGhlcmUncyBubyBjb3VudGVyIHRvIHRyYWNrIHRoZSBhY3RpdmUgU0dYIHVzZXJz
IG9mIGhvc3QgZW5jbGF2ZQ0KPiBhbmQgdmlydHVhbCBFUEMuICBJbnRyb2R1Y2Ugc3VjaCBjb3Vu
dGVyIG1lY2hhbmlzbSBzbyB0aGF0IHRoZSBFVVBEQVRFU1ZODQo+IGNhbiBiZSBkb25lIG9ubHkg
d2hlbiB0aGVyZSdzIG5vIFNHWCB1c2Vycy4NCg0KDQpUaGFuayB5b3UhIEkgYW0gZmluZSB3aXRo
IHRoaXMgZGVzY3JpcHRpb24sIHdpbGwgdXNlIGl0LiANCg0KPiANCj4gPiBEZWZpbmUgcGxhY2Vo
b2xkZXINCj4gPiBmdW5jdGlvbnMgc2d4X2luYy9kZWNfdXNhZ2VfY291bnQoKSB0aGF0IGFyZSB1
c2VkIHRvIGluY3JlbWVudA0KPiA+IGFuZCBkZWNyZW1lbnQgc3VjaCBhIGNvdW50ZXIuIEFsc28s
IHdpcmUgdGhlIGNhbGwgc2l0ZXMgZm9yDQo+ID4gdGhlc2UgZnVuY3Rpb25zLg0KPiA+DQo+IA0K
PiBbLi4uXQ0KPiANCj4gPiBGb3IgdGhlIGxhdHRlciwgaW4gb3JkZXIgdG8gaW50cm9kdWNlIHRo
ZQ0KPiA+IGNvdW50aW5nIG9mIGFjdGl2ZSBzZ3ggdXNlcnMgb24gdG9wIG9mIGNsZWFuIGZ1bmN0
aW9ucyB0aGF0DQo+ID4gYWxsb2NhdGUgdmVwYyBzdHJ1Y3R1cmVzDQo+ID4NCj4gDQo+IEl0J3Mg
bm90IGp1c3QgInZlcGMgc3RydWN0dXJlcyIgb25seSwgcmlnaHQ/DQo+IA0KPiBFbmNhcHN1bGF0
ZSB0aGUgY3VycmVudCBzZ3hfKHZlcGNfKW9wZW4oKSB0byBfX3NneF8odmVwY18pb3BlbigpIHRv
IG1ha2UNCj4gdGhlIG5ldyBzZ3hfKHZlcGNfKW9wZW4oKSBlYXN5IHRvIHJlYWQuDQoNClN1cmUs
IHdpbGwgY2hhbmdlIHRvIHRoaXMgd29yZGluZy4gDQoNCj4gDQo+ID4gLCBjb3ZlcnQgZXhpc3Rp
bmcgc2d4Xyh2ZXBjXylvcGVuKCkgdG8gX19zZ3hfKHZlcGNfKW9wZW4oKS4NCj4gICAgIF4NCj4g
ICAgIGNvbnZlcnQgPw0KPiANCj4gPg0KPiA+IFRoZSBkZWZpbml0aW9uIG9mIHRoZSBjb3VudGVy
IGl0c2VsZiBhbmQgdGhlIGFjdHVhbCBpbXBsZW1lbnRhdGlvbg0KPiA+IG9mIHRoZXNlIHR3byBm
dW5jdGlvbnMgY29tZXMgbmV4dC4NCj4gCQkJIF4NCj4gCQkJIGNvbWUgbmV4dCA/DQoNClllcywg
d2lsbCBmaXguDQoNCj4gDQo+ID4gVGhlIGNvdW50ZXIgd2lsbCBiZSB1c2VkIGJ5DQo+ID4gdGhl
IGRyaXZlciB0aGF0IHdvdWxkIGJlIGF0dGVtcHRpbmcgdG8gY2FsbCBFVVBEQVRFU1ZOIFNHWCBp
bnN0cnVjdGlvbg0KPiA+IG9ubHkgd2hlbiBpbmNyZW1lbnRpbmcgZnJvbSB6ZXJvLg0KPiANCj4g
VGhpcyBjYW4gYmUgcmVtb3ZlZCBpZiBteSBwYXJhZ3JhcGhzIGFyZSB1c2VkICh3aGljaCBhbHJl
YWR5IG1lbnRpb25lZA0KPiB0aGlzKS4NCg0KQWdyZWUuIA0KDQo+IA0KPiA+DQo+ID4gTm90ZTog
dGhlIHNneF9pbmNfdXNhZ2VfY291bnQoKSBwcm90b3R5cGUgaXMgZGVmaW5lZCB0byByZXR1cm4N
Cj4gPiBpbnQgZm9yIHRoZSBjbGVhbmxpbmVzcyBvZiB0aGUgZm9sbG93LXVwIHBhdGNoZXMgZGVz
cGl0ZSBhbHdheXMNCj4gPiByZXR1cm5pbmcgemVybyBpbiB0aGlzIHBhdGNoLiBXaGVuIHRoZSBF
VVBEQVRFU1ZOIFNHWCBpbnN0cnVjdGlvbg0KPiA+IHdpbGwgYmUgZW5hYmxlZCBpbiB0aGUgZm9s
bG93LXVwIHBhdGNoLCB0aGUgc2d4X2luY191c2FnZV9jb3VudCgpDQo+IAkJCSBeDQo+IAkJCSBm
b2xsb3ctdXAgcGF0Y2hlcz8NCj4gDQo+ID4gd2lsbCBzdGFydCB0byByZXR1cm4gdGhlIGFjdHVh
bCByZXR1cm4gY29kZS4NCj4gDQo+IENvdWxkIHRoaXMgcGFyYWdyYXBoIGJlIHNob3J0ZXIsIGxp
a2UgYmVsb3c/DQo+IA0KPiBUaGUgRVVQREFURVNWTiwgd2hpY2ggbWF5IGZhaWwsIHdpbGwgYmUg
ZG9uZSBpbiBzZ3hfaW5jX3VzYWdlX2NvdW50KCkuDQo+IE1ha2UgaXQgcmV0dXJuICdpbnQnIHRv
IG1ha2Ugc3Vic2VxdWVudCBwYXRjaGVzIHdoaWNoIGltcGxlbWVudA0KPiBFVVBEQVRFU1ZODQo+
IGVhc2llciB0byByZXZpZXcuICBGb3Igbm93IGl0IGFsd2F5cyByZXR1cm5zIHN1Y2Nlc3MuDQoN
ClN1cmUsIHdpbGwgY2hhbmdlLiANCg0KPiANCj4gDQo+IFsuLi5dDQo+IA0KPiA+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNsLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC9lbmNsLmMNCj4gPiBpbmRleCAzMDhkYmJhZTZjNmUuLmNmMTQ5YjlmNDkxNiAxMDA2NDQN
Cj4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNsLmMNCj4gPiArKysgYi9hcmNo
L3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNsLmMNCj4gPiBAQCAtNzY1LDYgKzc2NSw3IEBAIHZvaWQg
c2d4X2VuY2xfcmVsZWFzZShzdHJ1Y3Qga3JlZiAqcmVmKQ0KPiA+ICAJV0FSTl9PTl9PTkNFKGVu
Y2wtPnNlY3MuZXBjX3BhZ2UpOw0KPiA+DQo+ID4gIAlrZnJlZShlbmNsKTsNCj4gPiArCXNneF9k
ZWNfdXNhZ2VfY291bnQoKTsNCj4gPiAgfQ0KPiA+DQo+ID4NCj4gDQo+IFsuLi5dDQo+IA0KPiA+
IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYw0KPiA+ICsrKyBiL2FyY2gveDg2
L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYw0KPiA+IEBAIC0yNTUsMTAgKzI1NSwxMSBAQCBzdGF0aWMg
aW50IHNneF92ZXBjX3JlbGVhc2Uoc3RydWN0IGlub2RlICppbm9kZSwNCj4gc3RydWN0IGZpbGUg
KmZpbGUpDQo+ID4gIAl4YV9kZXN0cm95KCZ2ZXBjLT5wYWdlX2FycmF5KTsNCj4gPiAgCWtmcmVl
KHZlcGMpOw0KPiA+DQo+ID4gKwlzZ3hfZGVjX3VzYWdlX2NvdW50KCk7DQo+ID4gIAlyZXR1cm4g
MDsNCj4gPiAgfQ0KPiANCj4gR2l2ZW4gd2UgaGF2ZSBfX3NneF8odmVwY18pb3BlbigpLCBJIHRo
aW5rIGl0IG1ha2VzIG1vcmUgc2Vuc2UgdG8gaGF2ZQ0KPiBfX3NneF8oZW5jbF98dmVwY18pcmVs
ZWFzZSgpIGNvdW50ZXJwYXJ0Pw0KDQpJcyBpdCB3b3J0aCBpdD8gSW4gY2FzZSBvZiAqX29wZW4o
KSB2YXJpYW50cyB0aGVyZSBhcmUgcXVpdGUgZXJyb3IgaGFuZGxpbmcNCnVuZGVyIGRpZmZlcmVu
dCBjYXNlcywgYnV0IGZvciByZWxlYXNlIGFzIHlvdSBjYW4gc2VlIGl0IGlzIGp1c3QgYSBvbmUt
bGluZQ0KYWRkaXRpb24uIE5vdCBzdXJlIGl0IGlzIHdvcnRoIGFkZGluZyB0aGUgd3JhcHBlcnMg
anVzdCBmb3IgdGhhdC4gDQpCdXQgSSBjYW4gY2hhbmdlIGl0IGlmIHBlb3BsZSB0aGluayBpdCB3
b3VsZCBsb29rIGJldHRlciB0aGlzIHdheS4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
