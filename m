Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2BF18CBFB;
	Tue, 30 Jul 2024 22:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722379716; cv=fail; b=sicZPS++vOvt4aZsGwozca074mF99GnHcttuBnTRN7ZlA4JtbRDr+Z3g2cNA4tbHY5WCN50pNIUlzR61n0YJ4qx9IWxncmz3+jUuFh7SHQxoKitYoEN486aLlVe7JjVhLTpHHbVq+VzSnpjUVOUB+c03LGtmduuIo6hkCJvP0wQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722379716; c=relaxed/simple;
	bh=2Yhy5hurG4AWTPo7Lvqn59wFF8LyX3178zBW8Eoyzt4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Purjv/yshnb88bndc2uwx/JKDlD6jBAu3QXj0idH3O/TN3sMX0sjhbuQsBGx0mW9/LYDwcAjuJbAzvtrF/IbkgGYEJvegSy6L1Z4eMvfOtL1U4Zi/CU3SPmBZQM+MV4MtsHfERLC2qLGpdUa7Rbj9fhCIBlALbF9+PJiICxiJTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nuXAydN1; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nuXAydN1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722379714; x=1753915714;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2Yhy5hurG4AWTPo7Lvqn59wFF8LyX3178zBW8Eoyzt4=;
  b=nuXAydN1LaSt15g6YE+zOH6sqD7v6ZB1SfMtlBKk6vtwtoQ/4BXUmtxo
   KedVbX0eQ8CrZubyF+3WfqN8irgK/gRw3lY/0T6mOVdYzmLmDrRrq38Oe
   Pawyuo7NI0HL3sKpmnrWt/djPewAvEURflxjCt1JdQEoF38EeIAHldoRT
   +7FrGgI+87AbDipF8QW180y74ujg8BpP4/KE41SeI2zrn9/jjUaqfxs4e
   OjVQE8gBWEhru80Z/kWli4mqFi3nICdxSgr4/J7wGQf5S8QT3HR8nb04W
   t7fSENQEr8pw4Whkjao5L0qSW+uCYHeTVo7wo9ieo9o61Hph9CTyRPty/
   A==;
X-CSE-ConnectionGUID: E+Tt43aIQoi4e8Jg2N9VNg==
X-CSE-MsgGUID: hE9vz9oVQcW9kjuOG09O8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11149"; a="20073092"
X-IronPort-AV: E=Sophos;i="6.09,248,1716274800"; 
   d="scan'208";a="20073092"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2024 15:48:33 -0700
X-CSE-ConnectionGUID: zuofIIe0TuWUM9kmg3qx7A==
X-CSE-MsgGUID: gfvDZZg6Tvy3jSnEjiWaOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,248,1716274800"; 
   d="scan'208";a="54482986"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jul 2024 15:48:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 30 Jul 2024 15:48:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 30 Jul 2024 15:48:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 30 Jul 2024 15:48:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gh9Llm1mcEtC+Qw3gjhpR22dhsedVXDpJI3kwZtpMia5itEomvnBmlACgH6uLB+yVo5fWESkbokyoPfB2w3WCnB7tLFmgbkPUDo7GjgjYUm4GDRwrAOQX7wftwP9CYMwrlGWn++K2nY97qFL8BNPAZCQa9ahKk3Z5URgdsMm4O+Eh2ZIHiVyUNnBYqTbEGvfzfmIm57F4JlcvuqC5aPJc/nBaPj+EvzeO6fbWNkSTwecY200k7zczx5nBfsyxUV/+t/qSra5Su3tzIroFsm7YMYkp8wRcXTG9hnTYS5lvJK4fUsrb1j0vT3ZIBc3uHSeyv0kEypnmUDcIwikxN1syw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Yhy5hurG4AWTPo7Lvqn59wFF8LyX3178zBW8Eoyzt4=;
 b=wChN2HFBpsYVwFZxukxmgew9yB4vLwXkNBw+O85lIMpWaI8rSb/tyFZVks62sApIzHhKsx8Hb/D1CtwF191B/7LW6E50Gg3hQXJbrnKCtIzD7t9m5C25CI0d+QWT4Axw0ywU2mS+QZi4D3rW2y9SOVUMFsvMO4SDNXJ/OQoPRCTLbAB2zfCcub2wpPOdjQ6qbQp6VOhtMLwx2CYVtNYoClVrfhz3S88hPOMBaWY0njsOX00u8Z+gUiV8NFPpPSFi0kj1otjmEAjKFZE8kOzr14UUB5P3Zkq0041qkik9U3UQYpedpi7mAiaZwFHuD80oilP9gGDC/CM9Q9FE9uQYPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6724.namprd11.prod.outlook.com (2603:10b6:510:1b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Tue, 30 Jul
 2024 22:48:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7807.026; Tue, 30 Jul 2024
 22:48:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "baimingcong@uniontech.com" <baimingcong@uniontech.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"wangyuli@uniontech.com" <wangyuli@uniontech.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "xiangzelong@uniontech.com" <xiangzelong@uniontech.com>,
	"wubo@uniontech.com" <wubo@uniontech.com>, "guanwentao@uniontech.com"
	<guanwentao@uniontech.com>, "haitao.huang@linux.intel.com"
	<haitao.huang@linux.intel.com>
Subject: Re: [PATCH] x86/cpufeatures: SGX: Adjust the error message when BIOS
 does not support SGX
Thread-Topic: [PATCH] x86/cpufeatures: SGX: Adjust the error message when BIOS
 does not support SGX
Thread-Index: AQHa4is//1JBM77EBU2dmsGlk3Tz+bIPKv6AgABkQoCAAFGWAA==
Date: Tue, 30 Jul 2024 22:48:29 +0000
Message-ID: <9b1b4ef92b8d70bf8072fbbd07f70f82335b9040.camel@intel.com>
References: <D345627B0A699F37+20240730024931.1026933-1-wangyuli@uniontech.com>
	 <a56bc12f6c60107c935db31d7330d28980ac4d5a.camel@intel.com>
	 <ZqkpSX8xfbny7L0e@google.com>
In-Reply-To: <ZqkpSX8xfbny7L0e@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6724:EE_
x-ms-office365-filtering-correlation-id: fd46c1af-de7d-4912-55be-08dcb0e9bb6d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MTZhZ0RPL2syVVhGWjgwYXh3eG1BSUVIMnhzNkt4LzZlUm5GakRYcU14U3pX?=
 =?utf-8?B?YkZiS2JjMzF6ejBWaUp4ek4xdU9vR2FkclZ6eDJ6b05BSmNXQldvcXRjR0pm?=
 =?utf-8?B?RU5TZXlBNGplUUZRUDJxRkdlV0ZLS2RPV1cyVmEwUnJsV3JCcGZ6ZllYN2Ro?=
 =?utf-8?B?YWNUQWtVNytnRW1yak85Q0FTOURzNEJURFAxd2YvcmRJckpGbWxBb3NRMUQ0?=
 =?utf-8?B?aXZMZVZBNCtMZGJDaHhTS2tzcUhSeENWdThzZHhKb2FOMytSeS9vdXF4cVJM?=
 =?utf-8?B?QXh4dkNpL2h6ZWpmY0EzMi9VRWl2d1ppYlRtUTNJZUluVkQ2LzBHTWRiWUFL?=
 =?utf-8?B?Umw3SXh5UmQ3b3loSmdBS2NUZDVsQmJBdWN6cWhFaEJUcVd2VlJEZFlUN29K?=
 =?utf-8?B?UkJMaEFLYlpCSnlqYjV1NmZOUUU0T0J3a1Y4eTNIUzhqd0hPSkNoclRCQjZu?=
 =?utf-8?B?M1JDeVRpTDVHeVlnU2ZLc1UxR0dhSXNHVFJXaFZ5aytaWnFtU3BVdHNHNmVv?=
 =?utf-8?B?dHlFc2dJellmQ2RNMlJRVDZXNkVUUWhFZ3dVTWFrMFBHZHlzVVVLZnhpRWs2?=
 =?utf-8?B?VS9IejhIaHNYbi9xMGQ3NVF2bklGN1BJR2ZRVTA4WmQ5b3FyUldNUmVoWXdS?=
 =?utf-8?B?ZUp5cVJNMG1ONXZYaG5wNXZZa0w2Ui9hRDhBZ2pSSG4yMFd3YW1XU1dOcUw1?=
 =?utf-8?B?S1NVOXRncGk4VS9Qd2c3ZGozWmZNdFNIVkhmNkIyZWovdmxYZXVYOU5TWlVq?=
 =?utf-8?B?V3dKOVN3WEtKdHUwemxZR2lSSHUwbnRUdmI3Z29jc09tV0toRHVNMWVpTitH?=
 =?utf-8?B?aHQ3ZmZ5UkJjUytYN2hVNml6bnQ0NVphbU85aFRQSEJQNjJMbW1BUzFzaENM?=
 =?utf-8?B?UXl0R3lwZDdUZHZLY3BPNVo5SWRlZllPcmt3TEM0eWd2bTczY2w4U1g0OENF?=
 =?utf-8?B?YWxYblVuT3p5cEhVVXFnSnZDV3JPc3dWN1k4emZaTDNRNmZDbWZhc0dqT2Zp?=
 =?utf-8?B?UGpQWDgrU0ZKSVlrbFF4T25IZ01ielNtQm9reFFhaWlIbzNSaVlZaExMSGox?=
 =?utf-8?B?Y0ZmVXZSVk5oT05LQkJWMXRnOThWRVFlYi94NlA3MnRwM3EzRGw1WjlYZ1Rn?=
 =?utf-8?B?a205N2RpTGJGZm1YMG5URitmTk83Ri8wbm9KcktFWTZLWUlIaDRSUGFtdm5J?=
 =?utf-8?B?WUtlenc5RnRNeVR1UHR3ODNSTWVmSEJFci83aXNDZFl3dUJSU2JpZ3I0cDJ0?=
 =?utf-8?B?Tmk3T1M5d2JtcGl6ck9FdHdpWW51TFo0d3pnMUFwY2pRQjNEMGxlMm1uZStr?=
 =?utf-8?B?K3NUQWxGaDA2am1YN0QrbXNhWmF1N2IraGsxNnhaYkYrajArb3BSeklUc2VK?=
 =?utf-8?B?TGJXZzZFeWhqUEptcXF4enhlTW9oUFhKRXkxQ3c1UGk0c0tIY2JEUUJCVjgv?=
 =?utf-8?B?WVlPMHZybTE2bWt6ZlFRUS9QWncrd1NuK0grRVhJQ2ppM2M2Qmp3RjRoTmZi?=
 =?utf-8?B?S1E0b29XWjRXcnRNV2xZN3hkelNZTEVMRVNnd3AxR3lReXNyMS9yaWpheXE3?=
 =?utf-8?B?WFhYWHFIUCtXK3UzRkV4N2lSR0l4YXlxRS9BV1hoSGxjQ1dsaGQzSUZ5TGtE?=
 =?utf-8?B?S1VJWkg1UFh2cHdiTUxuOU1rdThEYngweXd1T0V1TFFWckh3ak9YczduRGpm?=
 =?utf-8?B?WlZXMzlXWDREMWIzTjBOQXBzVzlnc2NZOHV2MUlOTDZtazNmWndXMzJSRTdX?=
 =?utf-8?B?MkhLZFAwUEVGYXVoTW83RThsdlVWRjBmQllEYTNIcWpabWJmQTNqODZiTXpX?=
 =?utf-8?B?SStLZ0NOUmtJaUpENmdaSzdNNXRUZ3lKVnpmcEZtQkJ1NWFyVjRzTklhVzZL?=
 =?utf-8?B?NytDZ3EzQUJyNXEzY2g4OUJvcjRhVHZERHluWnZCalBTNFE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk1JVUlsaWx1OVZORmlmQ3RmUm56UjJWSS9MNldwc3FBbHFPNFdQdEYwODRo?=
 =?utf-8?B?cnJEa2k1NG43NU5RTzAyQXZZOS8yTU9URHhSY2N2dWRQb3JENGl2Qm5OaEs0?=
 =?utf-8?B?anFPM1RVa3FtSTlOV0RpZFNYL21rNnkrK2hYVE94ZlVOdWN0YnpNUkwrUWQz?=
 =?utf-8?B?dUMyUEkvOFVzMGRSTTU1RmlkWXNRS1MyRjVrbXdVWVpZVGF6SDBIbjBJbDBG?=
 =?utf-8?B?SGZkbHFZdEVmRUZHM3dwNkRFeEhLNmVZY1M1TVJPd0xXcnNxK3hsTHJmTThm?=
 =?utf-8?B?VC8zNGdEeUY3UXVjVnQ3VWpWZVlCbzFBbENvbTA2dWJ6bE05WWNoT21VRFNQ?=
 =?utf-8?B?YkV2L2MrOFdiczI1VG9zc3Q4NFNKY3hCSGQzeUFZR09FUHFNWHcxL3ZCM1FL?=
 =?utf-8?B?Qis0c3NhNnFBNGxCUWxlMUhkbGNUQWNnb3JWVW51TW1pd3BXVTVEbDBUa0Ju?=
 =?utf-8?B?UWw4UUFTUE5VWnU5Q3NSTVltT1FUSmVZTjY1UFBLUi9DSGxuaDJzVy9BanFu?=
 =?utf-8?B?Zm4rZ2hjSDZsMzBjUENZY2xtNjNQVlE1WTFtZC8vM1hHditGemROY3lkQnNu?=
 =?utf-8?B?b2I1RXJwRHNRWFd6dkNvb1gxK3BKem1YSWhQRjQ3Y3BuczFGcGxVR3k2QXQr?=
 =?utf-8?B?TGlWY0xOOFNyM0Z3dHJ4RGFmWHBIeUFJWGR5RWN5d3VJclZUVWtpYi9seHRk?=
 =?utf-8?B?SHhMKy9MUnhkaEVHVWJzbTFnL1VIZWRBNXVNRG54ZXhpYjJQUjFwNjRxTEQx?=
 =?utf-8?B?Z0xueWpSUWp1OVVVK004cnRsTlo1MkY3c2FxOTV6dyttaWdNQlpXVUVKTnMv?=
 =?utf-8?B?RksxczFJTWVkOVdJZ1dEcmI1ZTdYN0dBQ1RWcnE1aitMUTRTY0ZySnE4S004?=
 =?utf-8?B?Y2l0bTZZdUJkdVVDaVphRE5rMzdUZk9TSyticG9mY1Y3Tmp2a3BmMXBHSXFJ?=
 =?utf-8?B?N1BlalZLUHJTcldaaDdKN05BVjg5eUtVL3lPeFZHTlVUaXJNZmNMMHYrdk5k?=
 =?utf-8?B?VjRMV3oydzVkMGxWYmM5QlVyU2doZ2dQYmJmR0lnclFhWmEzMUhXTVQxWDZE?=
 =?utf-8?B?Nnh1QjVBS2xOMGkzWEc1V1BtQ0NKUllFcWRVM3l0bmNIK29lNWtMNGt1VFc1?=
 =?utf-8?B?YTNZVm9wOURnNjRGamRpVXVMby9TWnlpVkQ5a1dhTndRcDMrTlpub0NYQkhL?=
 =?utf-8?B?MGdzWDR0ZFRzYzJ4aE1La20vWWQzWU5uVWRlRGp5Y1JVaVFpZWJLbFFIQmQv?=
 =?utf-8?B?QWxtY1J3dXVORmNybkltUzNpVnB6WW5VV3FZY3lRYUk1b2RBYU51aldJSHhZ?=
 =?utf-8?B?OHJETzdDNm1ueVY1K0ZJaVJrQm9CY2xJZVRlSmFtemgzTVZYQlN5alVvWFFH?=
 =?utf-8?B?aVVGRXFWRGROYjZBakN6cHh1SVNPVUZmd2QxQ0JvR293YW9jazhQUitaL0Er?=
 =?utf-8?B?L1BDZ1phbm5LdHB5S1BoTGMvbGF1V3pVWm81Y2M5bzFzSGdDUCt6NnJIekYr?=
 =?utf-8?B?SFFRSTRkS2FFUlpEbFQ0dGZtNk16d0RWUkFQektEWS9PQ2lWMnRxL1UwMER6?=
 =?utf-8?B?enZMNTV2ckdNS1NPSDhhaCtDSFBLdHV3NHBvMGFqSzloRnBlRm11VndSbEdM?=
 =?utf-8?B?c0Nja3NmeGNuNUxTdW44V3RiVEN2dE9GajJKTTdtK2V4aGduem84THZOVlBK?=
 =?utf-8?B?ZE1CL2VNbTUzMW5jK1l1VVo1T0o3R0x2b2c1TjdwVUdhQUNZN3hCcDJWdW5a?=
 =?utf-8?B?dGIxWVJLcjZ4Q3N3R2cxLzBqTERQc1hFcnhZQXE2enpmd2VFTGdwN1RiVWwy?=
 =?utf-8?B?WlFRdTZrdzRVRU5weWhFSzY1WHdady9qOXAybHFsU0ZnZmFqdHFiTUZyamk5?=
 =?utf-8?B?TXVOZXN1aVFRZDJOSUFsUE8wZHNpOG5Ubi8rVWIwa2JhZ2RtZ2ptbDZnYUhH?=
 =?utf-8?B?Uy9INVVPNFpnNkpPQ2h0bWFHaTFuK2hSYlBoVytQNm01UzVQTDJEQTd5QSt5?=
 =?utf-8?B?MUZoaFB6MUdINW13WWxaaFJTKzJZM3grQVRKdVQyWFQ0MDhvSmJMV3RaOXlD?=
 =?utf-8?B?cUpLc2V3Q0ZkZHRxK2RodzNwczZtVDUwSVZYTFRrQ0IvZDBmNHFFZmZ2Ykgv?=
 =?utf-8?Q?kurzEuRD4WW4YHZunWtmIEABR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2067F71421AA084792F864BC4C5267FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd46c1af-de7d-4912-55be-08dcb0e9bb6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2024 22:48:29.7710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4LOl6hN9AqfGBFyBUwAQe23wETGh5rL1DFvB/2R5LQ1TsvEAUgBCkDWQ4DS2SN+8pEutnruvL+zGBolm7buJ2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6724
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA3LTMwIGF0IDEwOjU2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEp1bCAzMCwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNC0wNy0zMCBhdCAxMDo0OSArMDgwMCwgV2FuZ1l1bGkgd3JvdGU6DQo+ID4gPiBXaGVu
IFNHWCBpcyBub3Qgc3VwcG9ydGVkIGJ5IHRoZSBCSU9TLCB3ZSBzdGlsbCBvdXRwdXQgdGhlIGVy
cm9yDQo+ID4gPiAnU0dYIGRpc2FibGVkIGJ5IEJJT1MnLCB3aGljaCBjYW4gYmUgY29uZnVzaW5n
IHNpbmNlIHRoZXJlIG1pZ2h0IG5vdCBiZQ0KPiA+ID4gYW4gU0dYLXJlbGF0ZWQgb3B0aW9uIGlu
IHRoZSBCSU9TIHNldHRpbmdzLg0KPiA+IA0KPiA+ICtsaW51eC1zZ3ggbGlzdCwgSmFya2tvLCBI
YWl0YW8uDQo+ID4gDQo+ID4gVGhpcyBtZXNzYWdlIGlzIG9ubHkgcHJpbnRlZCB3aGVuIFNHWCBp
cyByZXBvcnRlZCBpbiBDUFVJRCBidXQgaXMgbm90DQo+ID4gZW5hYmxlZCBpbiB0aGUgRkVBVF9D
VEwgTVNSLiAgSSBjYW4gb25seSByZWNhbGwgdGhpcyBjYW4gaGFwcGVuIHdoZW4gdGhlDQo+ID4g
QklPUyBhY3R1YWxseSBwcm92aWRlcyBhbiBvcHRpb24gZm9yIHRoZSB1c2VyIHRvIHR1cm4gb24v
b2ZmIFNHWCwgaW4NCj4gPiB3aGljaCBjYXNlIHRoZSBjdXJyZW50IG1lc3NhZ2UgaXMgY29ycmVj
dC4NCj4gDQo+IEZXSVcsIHRoaXMgY291bGQgZWFzaWx5IGhhcHBlbiB3aXRoIGEgdmlydHVhbCBt
YWNoaW5lLCBlLmcuIHJ1bm5pbmcgYW4gb2xkIFFFTVUNCj4gd2l0aCBgLWNwdSBob3N0YC4NCj4g
DQoNCkhtbS4uIGl0IGFwcGVhcnMgc28sIGlmIHRoZSBvbGQgUWVtdSBkb2Vzbid0IGhhdmUgU0dY
IHN1cHBvcnQuICBUaGFua3MuDQoNClBlcmhhcHMgIlNHWCBkaXNhYmxlZCBvciB1bnN1cHBvcnRl
ZCBieSBCSU9TLiIgb3IgIlNHWCBub3QgZW5hYmxlZCBieQ0KQklPUyIgaXMgc2xpZ2h0bHkgYmV0
dGVyIHRoYW4gdGhlIGN1cnJlbnQgIlNHWCBkaXNhYmxlZCBieSBCSU9TIiwgYnV0IEkNCmFtIG5v
dCBzdXJlIHdoZXRoZXIgaXQgaXMgd29ydGggcGF0Y2hpbmcuDQo=
