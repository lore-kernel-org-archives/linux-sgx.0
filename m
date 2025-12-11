Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7CA18C31;
	Thu, 11 Dec 2025 22:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765490532; cv=fail; b=etMKaWFrEpDjryMz5vLOnbvVgjow3IANJc9oLxc/9zdUL4QmX6DQR5aRbuVgGGAsO9n/HIn7wDLnbyl8qq1BDNcWkyEmojN/c/Gy0qBjRR/VHP7H7mVpYPR3MvtvNWNkZr7bG1i94OkxWE0dxzciqnQd7aMZVOKa3L4L91v/YKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765490532; c=relaxed/simple;
	bh=lF2zlBHQLo+99ghDeu6hTjlEDzN93UwAuLSDsXnguho=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HM/mE4OCUXwrPfZ8dSXQXEdLUJ5/2M3U2ON4UCFZ8rGyWwXLzUSKe/c624sewZFm38PnXQa97HN1oQKRJb4Vz4FJJ4zm/Y6d4rIm51s1haq8GjVIsePjONiyPuIHBL39vl9XuCBySCNvbaKCj4y+X+A/vurykfVaoI7MFOxRuNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FaSWcH9G; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FaSWcH9G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765490526; x=1797026526;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lF2zlBHQLo+99ghDeu6hTjlEDzN93UwAuLSDsXnguho=;
  b=FaSWcH9GP+0Ou+rmtKgm/RbqakMU2SVZdO7Ee11pEQ0dEFR99kR45uyq
   KFbPyByee9TOZh6UHXepIBLyep+w2BTTtfXYrMFHej45Ak6IQCnO4CcAg
   l+oNN9FqctjZLlrOKJYgJnoqXR3d9D9eQocxKq94LnoVpbzD4HwbOF4eV
   quHfux4NkedmVYRgw1v/t8jiIk23mkbK+aLGeMVcMy4cbMV6wdLHni4nV
   283KQXTg/vhyRgB2340ujkSKmrPmg2O3pRmNJHAr99GwBl7WUtAkkbYR0
   iNNKrskxYTHV0vRQK/xcgUzxc+lAgVKJjUY2fiRnwz5rucnEjaRdkXf/l
   w==;
X-CSE-ConnectionGUID: 46mj6gUrTs6jDHgbL1hGzg==
X-CSE-MsgGUID: jntv2769R7qt0q44/x/8uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="67530802"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="67530802"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 14:02:04 -0800
X-CSE-ConnectionGUID: yo6dD8FGQL2u/v0VIm/BWg==
X-CSE-MsgGUID: dQGAhMM2R7Ci7fzgKrwDvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="201992132"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 14:02:04 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 14:02:03 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 14:02:03 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.11)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 14:02:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BFnYu5XBZ02McyvnA3w9PQ5OuMRxTGsvh73OlWFjDbEIXDmHDZQ6DV/xArgisDPgjbNkSt93tgjncinHThOkfZisNjdK98nkZxk3Q3J0tbL6ORySX9amir366as41bh/w0PklJNaxcH9lOg7YiU5SujYhiTAnP0jRK2VDVve/aK2ZPjWryvf38dPRC4H/6FJh4ThWwFus/5kOBUG20TXYNfiUS9tbbMIDbYI6ewNGArXGtQQv/6HaoNZDHNXQwX6al706ebzA58GbFpFR59GjNzy3n5auAupRJEA+eyMymbuMdQ+nvEiydPH3ozaCQ/WjRx7hpE/aGckvLwTgVl9Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lF2zlBHQLo+99ghDeu6hTjlEDzN93UwAuLSDsXnguho=;
 b=Je1lW91QA61c9J7PAWLdLwWcrP9A8CaIELNWIkh8ucslE3Tt3GMKdLlMEnumyBR7XaQTNjcd4rFNBsFm6meKsrid0NiwMeinpIHu1K2fomgH8tq/ZfLXjKTaqdhDT7N9NC6C+cG/YtSNc2l1Mj9Ee5jT/0RWPNffUddv5nQK3g2b7H0bIxlhALGHCjLNOEiFG/WVEGmxGW6ClQgLcsqgmBnoVjuyFvf7G001ZtBNclK44juhXSuPVvbIvj+KPFB/wqyA+9d9MPWOj5W/7RQCQ4meTvvRsuti+SQnunXsYip95Sea2ek8JxUAfuTa4GyfbqH9eswKyy5eZ4bd59T9Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 22:01:59 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 22:01:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "jarkko@kernel.org" <jarkko@kernel.org>, "x86@kernel.org"
	<x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "thorsten.blum@linux.dev"
	<thorsten.blum@linux.dev>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Remove unmatched quote in __sgx_encl_extend
 function comment
Thread-Topic: [PATCH] x86/sgx: Remove unmatched quote in __sgx_encl_extend
 function comment
Thread-Index: AQHcadSTZa3Ou3+wok+M1Xv1PoTI8rUc/9+A
Date: Thu, 11 Dec 2025 22:01:59 +0000
Message-ID: <92722b5c2d67c1711e201a6f42febcee98468d51.camel@intel.com>
References: <20251210125628.544916-1-thorsten.blum@linux.dev>
In-Reply-To: <20251210125628.544916-1-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MN0PR11MB5987:EE_
x-ms-office365-filtering-correlation-id: 6ccda933-17f3-4841-5b64-08de3900e883
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aW1vQmRjV01nSFptSUFHa3Q0SktaakxvOEdzWk5rVjNKMTRnbndhekNqZ2VL?=
 =?utf-8?B?SVl0ck04ZFRUdTFmVnl6UE9xc1grcFIxU01OVllGSlJlUklPSE9JT3J5SlZE?=
 =?utf-8?B?MmlpbGdESkRmaHB2NUNJb1N4dkxKZnlpWkc4cE5weUYzVmFrblhpU3VFUHZX?=
 =?utf-8?B?WmNjZ0djR285VXYrN3J1b2o4a3J1c0R3RnUzZ1MwUWdGTE5TN1pva3lGL3Fv?=
 =?utf-8?B?Q3dGcklHdkZrdm1jY013QlBHckl6QzVlTEcvMWtnZWRSZWc3ZmF2d2RYci9N?=
 =?utf-8?B?WWRrVzV5R0d2aXgremdZMTVUNjRsVXA4b1lveERReStyOWtnM3lrL1JhZUhs?=
 =?utf-8?B?azVLZ3o0MjJncE9Qd0NrQ0E0ZEdCVmU3d29aVC96Lzcrd0JjRmRMV1VMblVB?=
 =?utf-8?B?R0M0ZERLQkwwZ3VRUDRWeTZtUkJIR05HV05lVWc4UVdyTm5TamRLYVJLa2lI?=
 =?utf-8?B?ejlpQlZnYVBGN1kzK0o5UlBLSGZCaXlIU2l4QXZzZkR3UHhtSStiZHJBWEcz?=
 =?utf-8?B?TFBUQjN3d3NzQ1lka2FraWlXVzVHVC9KYkZXUEdOOE51M2RGTUlOeS9UbSs5?=
 =?utf-8?B?bGZiclVxTFZDZjVKeHZpWklWdmZjUWhnZEZLQTFzcUxmcU91Q1RhY1VsSkFa?=
 =?utf-8?B?RlJHUVRiVmhpNmVyU3R1SmZpUlk5NEhqKzVXVi9TeFdJVTNNMUxFZ3dZYXcy?=
 =?utf-8?B?cnJ3WDBsNFVCeTlCWUJLZDVEUWlKd3BBZUEzS3BYTjFOMEltZzM3KzBkak92?=
 =?utf-8?B?ZkhPVmRSdlIrTDRXZGM0czBiVlQzNExFZzJsVlBHWTk5TExMdlpGcnQveHZM?=
 =?utf-8?B?d1dseTRRT1l0RDRlcVZDQTdUbHArc2hXNkYzTTIvZTdRU1VNL2Zld1ltSmdx?=
 =?utf-8?B?bzNzSkwxei9KbWZobTJxSmpOQ2tpbXZHWGhyRFE3Z1VzRjcxZzhOZUhKa0RD?=
 =?utf-8?B?b0RwUzZDTFk3Q1UzYlY5K3QwNWVieElLNXRKaW14cUNkY0dFeFk2b2RPZ0dZ?=
 =?utf-8?B?UXFMR2xXelMyMlpQMmVVTy9tMXNDL28xbi9IbWw2Q2E1ZmNhSGg2bFBzSmZY?=
 =?utf-8?B?eHNhY2w0dGZaUllpWEYwaFQzZE1ZSkNZSnlNUFMzblpEaTFva0pVRUtYTzYx?=
 =?utf-8?B?RXZPMDljdDFHYTMzc091NnF0dUs5bVF6TFdyL013aFNMVFFGbUFNdXV2dk5Y?=
 =?utf-8?B?d2VyREpoMVpHaEpsWXdPcHF1V3UyblZRMkp5U2ViL0tNa2xqaDZBVkQzVm5I?=
 =?utf-8?B?QlJZS0RhY0J2RERCQ0VibUlZQWl4YXFFeTRKUUYxb1hoMjZRVVV3SWNML2R1?=
 =?utf-8?B?SXl6WitpSmp5eW5qQUNndkdvTDcxODdmWVR5QzhmNHRNZU5rZ2hWMkVDSmJx?=
 =?utf-8?B?UmdQTzhyUlpZblRLL3NxNEdiS2hlQ2YwbmxLOHRqcFlJcUJEWFkyTzNHeWpY?=
 =?utf-8?B?L1hFZEszS1gzMEcvbHNwVVhpL2NpNndxbXhaZG8xQUR0MVFzVERrRVBxc3No?=
 =?utf-8?B?Y0tma00vN0ZTMGRvZnR5dVlFZlZoakdaeThTR3BNYU5VS2JVdDFPM3o3VDFB?=
 =?utf-8?B?dGhqbUVmRHRwN3lXZDVpYnlWSEJYTk8yNDU1YXJvK0Nxa29DVlp2NFRsZGRq?=
 =?utf-8?B?TEVGRExnT2FwN2tPUVVDckxOVS8yeVFOQ1hVcGhmcnR6ZDgzN0F0Q052YlNi?=
 =?utf-8?B?YkhWaGNhaG9GZjdJZCtIUG1zRWhaRVlFZncxeXp3UmNuNWd4bFh1VGo2M2RZ?=
 =?utf-8?B?TjBMajU4TDJPamlucFJ1aHZoUHRtRmtEMlN1UHRPcGpiSE5KT3hzaGRSM25D?=
 =?utf-8?B?ak1QdUQ4YUkzRTBUWkxJU0FudEJXNkhGdEZldkVmblY4UHBTcnZJdGVYbWNF?=
 =?utf-8?B?amVUckxCT3lXb2VyUnB6MTZRWFNjNis2SDQ1L1R6UDNTS3VUNXorK2hVdk9H?=
 =?utf-8?B?NExobmUrbU1ScTZ6UWVwL092TDRWV01TZHFPVkduU0Jmc2twS0Q3M1pyOWxI?=
 =?utf-8?B?bnlmRmRaeUh0S2VxSDZHV3Vadk94QjhiTXI0UFVxK3B2NDZtNGlxK0ExZkFF?=
 =?utf-8?Q?cck+As?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTFlNzcwTEU2U2IyLzMrUWovU1hkdlpOZ0FRWTRremhrQ2Z5ZWlXbkxZUjNN?=
 =?utf-8?B?VXhZcEd0OEF3QUZSMytWVnZEZHR4elFqMmIwckovaWx4WWpIcEV2VmdGM0I3?=
 =?utf-8?B?TGVjOHdtTXhiN1pOcUF6Vk1OUGpvRHY2UHNMOVArMERaY1B1SkFMK3h3cStx?=
 =?utf-8?B?QThjbGhrenZoekwwNFlOZXdjS3NGeHBsRWY0RzR1WUx2NFM3cHVqQUkyK2hy?=
 =?utf-8?B?eUN6VmFwODJibWdiUXFMY1NUUnQ0dmxjSFlQY3daNWZvM2kyQTFQRkhSS1p3?=
 =?utf-8?B?VlJwbG5QdGZmTzRUSFB5RXd6Ym5MOFhnM0QxcXZJVGJvOUpSVUxEWkdKNEdI?=
 =?utf-8?B?R2hCRlE5TTZJc1ZnbFZJZkhkTElUSzh0U25JbXoxdzZhZW82cFh2bGVrNDZO?=
 =?utf-8?B?MXVFVXNqOTRtdDArWHNiOXpLWmtBdDlkMXpLcklvS1NUdGVOejlVRkRKdkFx?=
 =?utf-8?B?RUg2UTdpKzNQbXp3cUQyTXA3b2dQOThBVE13eXkrNWdhTU9ZUmpZdWRweS80?=
 =?utf-8?B?c24zbHN0TUh6Z3hpb2JlN3B0SFdtUEpZYVgycWQwbEVPMzd1c0FqZmF5cmdV?=
 =?utf-8?B?T2dNNGR0T0J0NEpmVnJjdDFMU3ZBY1RCM1JleFhIelpxWkdBVGdEVGNyS2Z5?=
 =?utf-8?B?cE83UU94ZldKcUpSYXphSnRtWjBxZ1FzYUQ4cllVVXdtTVl4MTMvaUhBTGl3?=
 =?utf-8?B?R3Nuem5aYnQwMmVlZ1BjckE3Qkc4M2dYSXh1bU1MWEhJN0FabzR2UndMUjdB?=
 =?utf-8?B?bEJNcVFjbzFrZHpoeE9yYndvWEZTMGdNTUs3d1F2clNvNHlleDMvVU5FeFRU?=
 =?utf-8?B?ODM2Yno0MEw2MEk5ckw2a0x0L3krSXl3MmE3VHRaZlljdUlOTmdHR1Rqakth?=
 =?utf-8?B?M1lEQkRYYlFudHhvQ3pGZUJ0MGQxa3U1aForRFo1SVNvVHB3TWR3ZWhCVDV6?=
 =?utf-8?B?U2VtU3lHTWRvVTExRnU2RDlUT3kwaHluL2p4cjdkM1pCMm1wb0pBYzZkbmhB?=
 =?utf-8?B?ODQrNlVBNzI4SDk0aGE3QjdaK2YyU1k2OXFkWjlrWlJOVE9kaVU1Uko4M24z?=
 =?utf-8?B?dmdvVWtWUEhQQ3FRWFlJdWROUEZlMi94OU16eTRHY2N4azMxeE1VR2xncWM4?=
 =?utf-8?B?a2Q0N0sraUFsQXVoZjR0NnRFeVNOUXhqNDdzOUJTcm9wdDZidmN2cUtWQisz?=
 =?utf-8?B?VkpIUlRxWVFBcWYwVlhvUmc2dnUyNHErTVFFck9MaVlHSFNjNjNCamNnenlE?=
 =?utf-8?B?Z1pFSThiUVcraHlXcTZHWWdSTnZTOGRlTTAzcnE2NVM4eFAwMkNqb1FwQ1Vm?=
 =?utf-8?B?di90NlVDSDVkbS9CcVVlaFlIUEY1OWNJelpJOUZEaDRTNCsxZncrYVNDQmxY?=
 =?utf-8?B?L08zZzdRNU9kUFcvaGs1TWFQZHY3MkJMMFRiRjgrRGRzWmp2SThDMzNJKzcz?=
 =?utf-8?B?MGhMSldqYlh1WHF2OTNDVXh5Znp1TGxvNmEvMEJxVno4VTB3TE9pQVJaZlFV?=
 =?utf-8?B?b0xudmhFWWxwTHY1SU0yMFZzekJQU25GTzZFdTJya0dhSGxsb0h6ODUyUHZj?=
 =?utf-8?B?WVZPZzVvLzMxWTdpRlRES2U1TFZuNTRxTDhzOEJ3a3JtSzJ0OUdGNVBhN3Bm?=
 =?utf-8?B?R1FpdVlLeTl4M1I3R0psVnFpNnVTOHhuNkFrOVNWbnJWN1lWcFJFa3NlcUdG?=
 =?utf-8?B?eFBncDllYUY1b0I1ZmY3ZzYwWkxyWUQyc2tsWG1Pbk9hdndvSGxQREF4bkd0?=
 =?utf-8?B?bGlpTVRsTWhqaHBaTVRweFh6dnNEL1FUU2RWNVpMTk9UQ3ExVnYvbUFHVzJB?=
 =?utf-8?B?YTluRjAwYm5kYlpGNWgvL0pWUjlrRFRsR0VQZ3l1WU4yMVp6NVAwVWorV3Ru?=
 =?utf-8?B?NmxGVDN2VVM0UUFDUTU2Z0RES2d6WWtYbDZmbXhndkkySTVsL0dUQnA0R1d5?=
 =?utf-8?B?TU9wMUZoKzZnc2pKTzArVm1uM1N1SmZJZVZEdXVqODcxL2dwc2U0OTR5YXJu?=
 =?utf-8?B?bjU5QWdlcnZvZnp3Ty8rNkwwOFFzTVZDT1RMSHZvNm9YNEptRU9oMlA0NHk1?=
 =?utf-8?B?STdPVERIVnZYek5yWXZ4QmJ5N3laZnd1Wm9XRktxV2YwRGNHcnlpa1lDd1FU?=
 =?utf-8?Q?CXSVnjDWG7GeECZ0CLsOON1lN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABA66571F78EAE4FA9E9C45656D55DDD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ccda933-17f3-4841-5b64-08de3900e883
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2025 22:01:59.6332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eGVuOTyLjlPEstJ9vQbVQNyYAHYUpYO0eWQyAbyLswhLqbRYSl7AGx1c93JLhBiTTPlQcgLoWGtP7Tmnm0OuuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5987
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEyLTEwIGF0IDEzOjU2ICswMTAwLCBUaG9yc3RlbiBCbHVtIHdyb3RlOg0K
PiBUaGVyZSBpcyBubyBvcGVuaW5nIHF1b3RlLiBSZW1vdmUgdGhlIHVubWF0Y2hlZCBjbG9zaW5n
IHF1b3RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVGhvcnN0ZW4gQmx1bSA8dGhvcnN0ZW4uYmx1
bUBsaW51eC5kZXY+DQo+IC0tLQ0KPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvaW9jdGwuYyB8
IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2lvY3RsLmMgYi9hcmNo
L3g4Ni9rZXJuZWwvY3B1L3NneC9pb2N0bC5jDQo+IGluZGV4IDY2ZjFlZmExNmZiYi4uOTMyMmE5
Mjg3ZGM3IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9pb2N0bC5jDQo+
ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2lvY3RsLmMNCj4gQEAgLTI0Miw3ICsyNDIs
NyBAQCBzdGF0aWMgaW50IF9fc2d4X2VuY2xfYWRkX3BhZ2Uoc3RydWN0IHNneF9lbmNsICplbmNs
LA0KPiAgLyoNCj4gICAqIElmIHRoZSBjYWxsZXIgcmVxdWlyZXMgbWVhc3VyZW1lbnQgb2YgdGhl
IHBhZ2UgYXMgYSBwcm9vZiBmb3IgdGhlIGNvbnRlbnQsDQo+ICAgKiB1c2UgRUVYVEVORCB0byBh
ZGQgYSBtZWFzdXJlbWVudCBmb3IgMjU2IGJ5dGVzIG9mIHRoZSBwYWdlLiBSZXBlYXQgdGhpcw0K
PiAtICogb3BlcmF0aW9uIHVudGlsIHRoZSBlbnRpcmUgcGFnZSBpcyBtZWFzdXJlZC4iDQo+ICsg
KiBvcGVyYXRpb24gdW50aWwgdGhlIGVudGlyZSBwYWdlIGlzIG1lYXN1cmVkLg0KPiAgICovDQo+
ICBzdGF0aWMgaW50IF9fc2d4X2VuY2xfZXh0ZW5kKHN0cnVjdCBzZ3hfZW5jbCAqZW5jbCwNCj4g
IAkJCSAgICAgc3RydWN0IHNneF9lcGNfcGFnZSAqZXBjX3BhZ2UpDQoNClJldmlld2VkLWJ5OiBL
YWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=
