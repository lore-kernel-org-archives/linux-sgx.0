Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8822571B0;
	Thu, 24 Jul 2025 11:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753355595; cv=fail; b=IolLHPxrotttIk8Ea1izhjOnpx5c0cbjnZoTYD7YplwLFf0FqfwF6+MaCt9Q1Gg5jOND1grk+M1MbuUjczlDOhKFyNN7bA0icAk7L5rqw5JY00OoiQUgiisu47+fLVmanEiDGwkvSTar8JBtLufPSY3xmsUqQ2GpyexCFTXAp2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753355595; c=relaxed/simple;
	bh=tU1lSY7vo0DWba7sYC1+pLaBBrj/BiKxgAI93bjnzMs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G6t59HRPQh5nHWstZHez0b85POsMzPRWExoMWGArRwgryMk4aKEWJehSVrnZ3oaQOWBoiNbbJN/Wmzc8u51ledKTLPIj+6xRwttSxGNOWt4eFIDYaRwsZcob2SrprY5GP/ZIN8IH2WI0NudemLhYtDETaauELltY5M07aZl5wrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MGjEHAjB; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MGjEHAjB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753355593; x=1784891593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tU1lSY7vo0DWba7sYC1+pLaBBrj/BiKxgAI93bjnzMs=;
  b=MGjEHAjBLU44qL/W1Aeo0vCve+69PlbkG7V6lb9yX/d9fd6tSDbVkRH9
   Ube4jbxRGulnM4zRwuqljzrv8V+dsMON4t48m67WytMQ8R+1uERXlDBVA
   7hTWwG4LuL891GSPKZbXw+fC9602V44RhFq6kNG4x95lBVfdEUwLNy+80
   EXjWCFk+hNZOvY9ERpKTj5G+885wn4eBDvgrtfnqIzPuFC+xxjrzunFM+
   Mnu+0SU6DVI00L+UpVewb+++quDJyKskpI1HQq9Ng4oe6k01h54iwtUIL
   m3IxEpgdgH5ZOhIk8Kg5kCHfHKsJtU+sX+MAGN3Ts1+hSN7g5CNrt49/S
   w==;
X-CSE-ConnectionGUID: XtNebRTZRhyeCTft0qy7Kw==
X-CSE-MsgGUID: 7QixO/8VQBeNaPIZ+Q/sOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="54878193"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="54878193"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 04:13:12 -0700
X-CSE-ConnectionGUID: tI2yLJWaRR2xAjABVwS5EA==
X-CSE-MsgGUID: A9gTYDKyTTKUQceH4xdtOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="197303751"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 04:13:13 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 04:13:12 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 04:13:12 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.74) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 04:13:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KiUyQEGpTNFL+h1DoZRFcxZVJU/M3a9RBORF2ifHY6N2mR9bvA9pUU6W0F8VVKhocKgl22I4G/c0LQ5PH2ZOJOoQ4RsbBTqcm7IePOVlODqlI0HSNfB3MYzTnfEyyOiqC4SjdJAxlIOeWQHZsdZk3U2a4gd4jQk7R3yIQREo4F1bac/DWMrMqlcptgoaSiE4j9cyfsvZBIC3dMIO8QjonWKgaVQDa7L68sgZ/nY613tsvLERr6A1FV/eb6bBMqSKG98qF9XLuwLvtB3vYC8lK1wvl3CMB3gvb08Frp9KzLudr9cwKueM8e32DGuWkdjzuMay6CFRKxMUP1lHzdD7BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tU1lSY7vo0DWba7sYC1+pLaBBrj/BiKxgAI93bjnzMs=;
 b=D/hhcOERAqDdo76KQVe0to+SFlFOjngZ2h8opMD6QC09fVitIpfjvstF/24aC0TVgN6MvP1Bx1LiWgqXTG8AKrqE8sSqGe+qQt9Bgy+32+PKSnsvMyhDS4W6VjIVdoDPWTuxjVZ04B9ZKX4EFLBU4XnLxWwAH1DMQ391Ea4TRkdNkvN33qfCWqFQgi3CnpNuXngSJtv8Aqq+F26IkMzR5YZcLf2VESVOwuyFDlfR/k+RBa043xSxV2CpvgAdhcjRV4nM3b6Qqaw23Srane9mLuYT7xBFUH4g58NSu3Jp/M2ISEQG16PbMMTV/wrcPvcA7J9Q4lDbuMz3uMG4ulLtpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL3PR11MB6316.namprd11.prod.outlook.com (2603:10b6:208:3b3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.28; Thu, 24 Jul
 2025 11:12:58 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 11:12:58 +0000
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
Subject: Re: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHb/HGK60dfSRXjp02uNG1v9X+jQ7RBHuaA
Date: Thu, 24 Jul 2025 11:12:58 +0000
Message-ID: <156919280fe6b1e01a81bb89f8850e72a6bfe077.camel@intel.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
	 <20250724080313.605676-7-elena.reshetova@intel.com>
In-Reply-To: <20250724080313.605676-7-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL3PR11MB6316:EE_
x-ms-office365-filtering-correlation-id: 1a7b8631-864c-4f8a-c234-08ddcaa30c1e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WmRXZTNnVmxRWkJaM0VmWHhzZzBGeXNnSEgzUVFQV3dTYS96T2FlK0J4MWJG?=
 =?utf-8?B?STk5QzJVNzJNQU53QUl4dW5HM3lSUXNPYmxLNytQKzlBSlZ3bDJPbGQ2dWdr?=
 =?utf-8?B?UVRybGZkenpPL1kzK1E3aCtBRGlqNlkyTmJ6b0pxSmhiVXJqM042c1lLKzYy?=
 =?utf-8?B?eDVHTy9ZeFVPNkpmNHM5bGplSVp4c2JHZjJMYWsrTHZ3Z25kQnh5QkFFVGlt?=
 =?utf-8?B?NG9uQzV0YkwrTnpvL3Y2ZDJFOTBaSHlKVzFYV0dwYUg2d3NQS1VkcXRCMlNj?=
 =?utf-8?B?OU9sdGV6UHZpMlBoK0E1ODdZVU0xQ1YvQkZOc1lNbGNSVXNoKzRtNnFjOEtQ?=
 =?utf-8?B?alNreUVqd0k5cU5COUcvVXJzQi9zMUJNRmUrbWNoL0pMQWMzeTJqS0VGWFMv?=
 =?utf-8?B?OXl1VFpwelZycEVsUG9BRytZc3NqODZ4eEhPS0szcDlBQy9RWGJWYklxb3B0?=
 =?utf-8?B?NnJBK1RiNDAxWkw1MXdRTDZhSTRyUnVLcWhzTmtWMVZ3OHhoNnM3R0diNU5q?=
 =?utf-8?B?Q0ExSko1bVh4T1psdnFjaFpqUDVMUkd2Ly9Wb2w4YVZhc21GYWcwU0JaYTNJ?=
 =?utf-8?B?Q1J6ZERWUXp4bGZIMVozV05QUEdBU3Q0N0Q1NTZSVk00VWxFSXNRNERGWEd2?=
 =?utf-8?B?NkJwYys0S3hXbFJzQkU5K2FVb0tyd3BEeFNGc3J5b1g5Qy9YL3RoR3duemI2?=
 =?utf-8?B?cUpSb2xzL0JobWFob0NCKzF0cVpiazQ4RVI4QzA5cm1BRjJzLzBzT3hRekZL?=
 =?utf-8?B?RkRmR2JxSjA1STRkc3BpTkNuYmdOb2JOYVFyT0dvTmRrUFkvWDB5a2lodW1Q?=
 =?utf-8?B?YjYxZjBFN1NUYndmUE9TdHpWc3JrTFdsM1lKNnRyd1ZDa3FIN1JjWFYyaXUx?=
 =?utf-8?B?cmhXTENYM2h3S3d4MHlpMDhLN1dua0E4S1VnenV5RGpocUJPUFhYRFIrUkRw?=
 =?utf-8?B?VFl5eFVmdXhDZU5nbG10RWN3Qk5ENGdnd3k1aDZqbElnZXVtMVYvTFczYTA0?=
 =?utf-8?B?eWlKT1ppRmRGUGNybFVyVTVheGZ4ZDZmcDNuWmp4TkVNV2gwSTN0YWpHTllX?=
 =?utf-8?B?Um4ya2VIWmVSYlNKUU1zb2hhVzM2dVJyL0JZT0JRTmRvaS9QNmJwaU1xUEJh?=
 =?utf-8?B?T08yTkdrUDlDS0VCS1F4MzlPeCt5N1Fua2Q2SEdEWGxRYit4MEFRSC9rR0d4?=
 =?utf-8?B?V2Y5NXBsZHRBSzFLVStocldpSkRUU3hMWUlZMUxrQ1F1ampna2FvK0M3Qi9V?=
 =?utf-8?B?dEdoVUJpdFkvS1RXWVI4d3Z5elU2d1JDQXl3MW56UFU2NXZaVms1Y0hHZFZD?=
 =?utf-8?B?TlVQTjBTSjFFbkM4andzbmp3d2xtL1dsN0pqejFVRUtmQWU0SXRNeW1rdFE5?=
 =?utf-8?B?Vi9nTnRFSGpxSCt3SzhpYmw4Mk9QUDBrUS83M0FEeHl0aFNUQmZkNDBIb2dY?=
 =?utf-8?B?TnVWRVBPZmx6YXpSSmRUZGM4U050NEo0Zm1uWUtDYmF6OFQ3cmxNVWpnUUhD?=
 =?utf-8?B?aDB0MnhBQ2V0UHN6VXNuUFV2RUR6STV6dGlKeVdydm5Ja1JkTUhxeWxNNDFO?=
 =?utf-8?B?TjN6YkVhUldQZmhkKzg0and3aXhsZGUyQWh0WUZGUHhJWG1GeFppRzJNenNs?=
 =?utf-8?B?Tzh2alI2ejJyU0tOZDRkNzNkY3hORjQ5QkZmajhmY3hZc296V2doUXVydHJ1?=
 =?utf-8?B?Uzd3bmprV2J6L1VLa29zYVVJc0FyT0dqS2x6T2EvdlpsZHROemhpVFlBb1lV?=
 =?utf-8?B?MmViajZveVc3R1ZnNVplbWI0bTl2cnA3M2JLeUJFa3dscHlyMHlidzFyVGFz?=
 =?utf-8?B?TlByeG1reURyTTNjV2F0dXhLbTdQR0hHanlxNENmSW11bzV6RHRpY3B2eW9a?=
 =?utf-8?B?VmNNVVVnRUR5cHJXeTNuVjVLVU5LZmRtaktuc0ZLUnRVUXI3L1BtOGVYQjFu?=
 =?utf-8?B?ZzZkZlRqTm1WZ2JXK3ZrNm1aTCtQcHFtUDRja3F3aUVhVHJBejZ2eHhiMU4w?=
 =?utf-8?Q?7Noy+QhpEjxG8mlFcTCnqJnwX4w6eY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWd5UDJJYnVUeUxIdkVRSkkzRXJpRjF6YmY2Um5mRkQ3V1hJQU5pSU5NYWdP?=
 =?utf-8?B?MHlDU1RyNUZ2SmE2NUxiTERyYzN3WlVCWXBKT0h6VzhOcGdHZ3drL09HTS9I?=
 =?utf-8?B?eXN0ZmlPL0xaWitZU1g0QXdQaWZ2MzJ6RFVvRFgrNEFoNkxjZHk3TjBxRjQ0?=
 =?utf-8?B?bjJWN21IQ25FOEk5WW9Wd1RqSnliZzVmQ3pmb1BRK2xUNlA3bnducDJGVHF1?=
 =?utf-8?B?KzZCZ3p2Q3J6RHg0bFZOTzBGdFlzNXl5NlZZcVY5R2dWYW8yNkVEa28xaVpu?=
 =?utf-8?B?RGRGRkN3WTBqLzV5ZHVNMUVHWk8zUHdEb2t6UWoxQ2c3VXZZenlxNGcxQWtH?=
 =?utf-8?B?NXErSG1zeVNKK21pVUJYUHp5bFRzQ2o2NHFVenVpTWZsbWRQVFFYbjlTZlZY?=
 =?utf-8?B?QmpUU29WeVNVVDF1eXh3T3BmVHVwNkFBakwyNGRhV1JyYVFWUDVCSFhQNFVw?=
 =?utf-8?B?cXN3TE5YTzV6UEhQZVc0YzNCNEdDcENEYW40Z1lOUnBYNU40cWtzdE9XL3VU?=
 =?utf-8?B?MnVGYVVUKy9sSDJjdlJoT0pFTE5pdEdPSTM4ck1vZXRLR0htL3ZXbXFjWEFa?=
 =?utf-8?B?M0pKTU1MMTBBVDBjZHdYdjlmTkVKeDZIa1crLzIrODdiMmRhdzVHTWtMekMx?=
 =?utf-8?B?M1BRNjlhcTZaK09wUFpVZEhqMGxlYzFFelBBczhieGhJRGtuVjF3NVpkZW1E?=
 =?utf-8?B?Lzgvc0FOL0VmUkVycm8zSjdBMjRvVGhQSnZRUjUzRlpOR1U4djQ0SFJjVUJn?=
 =?utf-8?B?ZG5vRzk4UUNaWjZBS2NaTGpNYXhtcWhCT0JvTGlUV3MrR29NalRybmt2TkM3?=
 =?utf-8?B?MlVhUWdtN3pXVW5Dbi9EdmNqYzB4T1g2TGROaTRxT0RsVVpzOWpYRHJicko1?=
 =?utf-8?B?UTgzR2YzaUFlREkzVWdlOWhiNEUwdzBuVXlaRmNmZE9oWktCQk5tOUFRL3FU?=
 =?utf-8?B?VzZDYmlVeXFzVHFIWVRRa1FxSGhVYXUxTE1MLzYrcVJoWFVrQm1Ua0xpL2xK?=
 =?utf-8?B?RVZxYS96cFZxNlFhcGhVcU5TLytLd3VZYmpPZnlwcWpFQWppMCtOOW5kZE5v?=
 =?utf-8?B?TGlsR3VQOHNCNVQyU1Q3Nk8rWS9hRXBOOEV3WnM2cnpSN0NRVXNXWlJwNXRx?=
 =?utf-8?B?bWpDVFEydFhqZjBYS00xTUd3V3ZvUTBBbnRBZHB1VGpaS2RFd1FqMzY3SUZQ?=
 =?utf-8?B?RkJOemNYS2N3Z0xaQkRKUGZqTzFzbVdlZWFCVjB4b25WeFcyM2JlQk5uQ205?=
 =?utf-8?B?WnZPU0M0aXBkdklUODZKYkZFSUZ1bll5UUg3cUx6L3NFVTNmTGVGZ1F2MEZS?=
 =?utf-8?B?UWRNeUdRczViRW5MWWRzZ2ZpdHJUd3FHVlJPeC9hT1F5U0c0MjZQaDJFTFls?=
 =?utf-8?B?UzZnWjJxcGxiZXN6c1lQRXJhSEQ0Yk8wUVdieDhpSUtOSXhtOXMxSWdOdFRz?=
 =?utf-8?B?RStKblBseWpIMlVwSVhtejZIVTVFR1d4dE90Qnc3ajBDRVF5Wk1DbTZiUk5p?=
 =?utf-8?B?Y3ZYUXExVFo2WkZMU2xqRmkrZnNyekRzVndDVnNjNnZyQ3VHZ1gxMjFSbUxz?=
 =?utf-8?B?em1oQWdNWHIyL2NYcnJMd3hHUzNTRTJiZUZaQzFqbFc1WUpWekhvenFnZXZM?=
 =?utf-8?B?b1U2MjVjcFpDV1diejcxeFFpWkRMZWlQSVNZOThWRjFhaHV1T0dlemNNQ2RW?=
 =?utf-8?B?Yk4raHVURHpQSzhGOHlHdTZyUVpvdVBBRWhNSWhYQ1VEY0lKNy8wcUtLc2pU?=
 =?utf-8?B?YTkvcS9YOGQyYWtWMXZ6SXV2Um91akdsZzNDMExYcjJzMkdXQ25la2dCekhz?=
 =?utf-8?B?TlRYd3JTQnJaL3JQWmZlTXNnSzk1djl2MG8vYUcyN3lmMEczNk5MZkV6RXpE?=
 =?utf-8?B?L2FtWEg0c1RTQjlESWt0a3p2ck9hV3Q2RFF4Z3FIaW5KandUa3JGYVIwZkJy?=
 =?utf-8?B?WkJGRGJNdUh1RTNnZmh1aUg0bXhWcU8zb055RFJIWm1TOEVGVTRwQm9pOEJl?=
 =?utf-8?B?Qm1peVdRcFVTWW0rSk1Oc2VNQzFvNWl6UWUzRDJjdUo4VHVpTnBrNUhkTkxn?=
 =?utf-8?B?VXQzQ2N4K3d6R3pEZ2l2bjMvaDRaRUZwZ2ZUYlQ4S2x2dnlVUDNQWEpIZmx2?=
 =?utf-8?Q?HzQyuW0TwgaZ09XRO0pNShL+U?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1436840DD4CC2545B1F67C1A475E90BE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a7b8631-864c-4f8a-c234-08ddcaa30c1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 11:12:58.7933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TepTq5ksgZH90gpnoB+u5OLrprFuA3ZgcJVzcjNWsbz6T0lcViHNE+m1yyR3TWQhYsKuOV2s2AFCr2O77RXVNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6316
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTI0IGF0IDExOjAyICswMzAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3Rl
Og0KPiA9PSBCYWNrZ3JvdW5kID09DQo+IA0KPiBFTkNMU1tFVVBEQVRFU1ZOXSBpcyBhIG5ldyBT
R1ggaW5zdHJ1Y3Rpb24gWzFdIHdoaWNoIGFsbG93cyBlbmNsYXZlDQo+IGF0dGVzdGF0aW9uIHRv
IGluY2x1ZGUgaW5mb3JtYXRpb24gYWJvdXQgdXBkYXRlZCBtaWNyb2NvZGUgU1ZOIHdpdGhvdXQg
YQ0KPiByZWJvb3QuIEJlZm9yZSBhbiBFVVBEQVRFU1ZOIG9wZXJhdGlvbiBjYW4gYmUgc3VjY2Vz
c2Z1bCwgYWxsIFNHWCBtZW1vcnkNCj4gKGFrYS4gRVBDKSBtdXN0IGJlIG1hcmtlZCBhcyDigJx1
bnVzZWTigJ0gaW4gdGhlIFNHWCBoYXJkd2FyZSBtZXRhZGF0YQ0KPiAoYWthLkVQQ00pLiBUaGlz
IHJlcXVpcmVtZW50IGVuc3VyZXMgdGhhdCBubyBjb21wcm9taXNlZCBlbmNsYXZlIGNhbg0KPiBz
dXJ2aXZlIHRoZSBFVVBEQVRFU1ZOIHByb2NlZHVyZSBhbmQgcHJvdmlkZXMgYW4gb3Bwb3J0dW5p
dHkgdG8gZ2VuZXJhdGUNCj4gbmV3IGNyeXB0b2dyYXBoaWMgYXNzZXRzLg0KPiANCj4gPT0gUGF0
Y2ggQ29udGVudHMgPT0NCg0KTml0OiB5b3UgY2FuIHVzZSAiU29sdXRpb24iIGluc3RlYWQgb2Yg
IlBhdGNoIENvbnRlbnRzIi4NCg0KPiANCj4gQXR0ZW1wdCB0byBleGVjdXRlIEVOQ0xTW0VVUERB
VEVTVk5dIGV2ZXJ5IHRpbWUgdGhlIGZpcnN0IGZpbGUgZGVzY3JpcHRvcg0KPiBpcyBvYnRhaW5l
ZCB2aWEgc2d4Xyh2ZXBjXylvcGVuKCkuIEluIHRoZSBtb3N0IGNvbW1vbiBjYXNlIHRoZSBtaWNy
b2NvZGUNCj4gU1ZOIGlzIGFscmVhZHkgdXAtdG8tZGF0ZSwgYW5kIHRoZSBvcGVyYXRpb24gc3Vj
Y2VlZHMgd2l0aG91dCB1cGRhdGluZyBTVk4uDQoNCihTb3JyeSBJIGZvcmdvdCB0byBzYXkgdGhp
cyBpbiB0aGUgcHJldmlvdXMgdmVyc2lvbnMpOg0KDQpJZiBJIHJlYWQgdGhlIHBzZXVkbyBjb2Rl
IGNvcnJlY3RseSwgd2hlbiB0aGUgU1ZOIGlzIGFscmVhZHkgdXAtdG8tZGF0ZSwNCnRoZSBFVVBE
QVRFU1ZOIGRvZXNuJ3QgdXBkYXRlIFNWTiBidXQgaXQgcmUtZ2VuZXJhdGVzIGNyeXB0byBhc3Nl
dHMNCmFueXdheS4NCg0KVGhpcyBpcyBubyBoYXJtIHBlciB0aGUgcHNldWRvIGNvZGUsIHNpbmNl
IHRoZSAiY3J5cHRvIGFzc2V0cyIgaXMgYWN0dWFsbHkNCnRoZSBDUl9CQVNFX0tFWSB3aGljaCBp
cyBvbmx5IHVzZWQgYnkgRVdCL0VMRFUgZmxvdyBwZXIgdGhlIFNETS4NCg0KSW4gb3RoZXIgd29y
ZHMsIGl0IGRvZXNuJ3QgaW1wYWN0IG90aGVyIGVuY2xhdmUgdmlzaWJsZSBrZXlzICh0aG9zZSBm
cm9tDQpFR0VUS0VZKSBzdWNoIGFzIHNlYWxpbmcga2V5Lg0KDQpJIHRoaW5rIHRoaXMgaXMgaW1w
b3J0YW50LiAgQmVjYXVzZSBpZiBlbmNsYXZlIHZpc2libGUga2V5cyBzdWNoIGFzDQpzZWFsaW5n
IGtleSBhcmUgbG9zdCBvbiBFVVBEQVRFU1ZOIHdoZW4gU1ZOIGlzIGFscmVhZHkgdXAtdG8tZGF0
ZSAod2hpY2gNCmlzIHRoZSBtb3N0IGNvbW1vbiBjYXNlKSwgaXQgd2lsbCBicmluZyBzaWduaWZp
Y2FudCB2aXNpYmxlIGltcGFjdCB0bw0KZW5jbGF2ZS4gIEUuZy4sIG9uZSBlbmNsYXZlIGNvdWxk
IGZpbmQgaXRzIHNlY3JldCBlbmNyeXB0ZWQgYnkgc2VhbGluZyBrZXkNCmNvdWxkIG5ldmVyIGJl
IHJldHJpZXZlZCBhZnRlciBpdCByZXN0YXJ0cy4NCg0KQXNzdW1pbmcgSSBkaWRuJ3QgbWlzcyBh
bnl0aGluZywgY2FuIHdlIGFsc28gbWVudGlvbiB0aGlzIGluIHRoZQ0KY2hhbmdlbG9nPw0K
