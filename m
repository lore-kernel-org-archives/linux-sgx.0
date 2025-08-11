Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F3D2DAFAF;
	Mon, 11 Aug 2025 20:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754944630; cv=fail; b=TSZ2v4u6YvLS9PwQ2nhjTrd57hB/2Xyu/fIAr8bYYVxoqAKOM6/G01DEhBdKbl+xEkDnrBR+I0QOIyT0Zif34rC//kYo8DT2ZnkkEGLz2t7HzRj0pKNYZxhlYoXHcBWg4QG2EYHsQO4JbZLkxC31+5NVunq/Kj9CRAWuTPi8ywc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754944630; c=relaxed/simple;
	bh=3gu3R68KTua/I1x3AQqxunDuwuiNvYWEminO0RkhCB8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eWc0S36HJF9XUHA2q7ehsqdNEPE3uAX/8K4kzywz4o0XJ6G7SGSbyRCFrOxpIgXZbX8zg5FteNkHmXel7NYdevP2+pGoyVdRy+FlFmS7OtLOYyTW/Tn/gKIdtvkaTtbFmiJP6TcUCFqxov+xHqTMMBmcYbQvCtd+OnjUMMP5LUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RcQyHLTY; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RcQyHLTY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754944629; x=1786480629;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3gu3R68KTua/I1x3AQqxunDuwuiNvYWEminO0RkhCB8=;
  b=RcQyHLTYgdBToXSLKWio8lemHILEl9iVhddunoGSGqWN7jLc3hpYnEjq
   6xmNHcw8x1XRsV41DOtp379lCbmJ60P3o5odgQQJhFcjbLhN4XudoolPw
   s09Q8PtXrm8CAvDkaQsPbxQAIIqoxOuoNpo3yDllA8+rGOGlW5IgZeulT
   2FBIZSD5Y9s7YQMLQsXejp77Of6PS18gGkEhqn2Fdi6UyGfpPvXn/F8iX
   n1noPSlxJ/9W6O9tSC7Jne3cEe4RYd3f9hktyrZvCY7SRWKWYnJzzDJ4C
   tEM8B0qhoWL0A9J0mFN3tVKv7Tdl6PCcIvOnFCrQrGSRanEn3HsJ2qEj8
   w==;
X-CSE-ConnectionGUID: 6vtqJqgGQ2KKolIoTrlTrA==
X-CSE-MsgGUID: DAw0FxESTLe1rLNDHJfdAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57078690"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57078690"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 13:37:09 -0700
X-CSE-ConnectionGUID: ugLxfvHmTQaXw4ByL+gcEQ==
X-CSE-MsgGUID: ubr/iwwZSHWuUyHAyxtU3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="166807515"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 13:37:08 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 13:37:07 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 13:37:07 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.81) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 13:37:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EqEY8jF1KFDvzbUdV07ls7FQVTpOZCPiMgC7IWXoEphcc4wYW6etMmZA1LRp25BSa6dy1udZqhsAmau0yX18xlla6Njihe9VXKMugTNx/ukwT9JRUPZvTY6GpECIHkk4AIinsAa+3Cvs13kZ+fsHIM61xWZQaUNPeWizNt/jIwB1egyNe1TDw8Gv3m34d+HEox0teHX6ZpTCCa7k5nUGYZqUMTUXeM9rLOqZPQXV8L/HEGcuAPlh8IwlQp0PUkFYcaffxlm7/BmU8SFEZAkz9typT+BAcBZqeB+EtpoXeXzsKj7uip/nFNBVMv2axa1v04ufrDN31ZAROo+ztqHtIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3gu3R68KTua/I1x3AQqxunDuwuiNvYWEminO0RkhCB8=;
 b=WLIvMA6bhWNTkYbsi8u1SV1KSjuUa8hq1bHVLxfHCm42zTl6VjLGNkWTgNsVgEcatmok0b9yFW/twfm4td1l4zB89ZtLswWEEF0INjLnq2YteumWZurWCorA/pQhxYaHHwPO/Eyezwh9BSQOW2P4D30/h0TvN1aYdeaLSZmEspJdIwiDLGmftolp5oMTHpjSZs/GhbgDW5TSFWN+NZtxqRw8G41nn30IRsNMVzQ2Lbv2dKLqqPg9B+iJ9Bg2/bunraAMe1x0nXsOFdrV/AL5/a/s8C2TS2qLx1Na4d9LAbJYRQLwA+aakK1jeZRdtqhijBxQmstvdEFkOcbVb8G1DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by DM6PR11MB4529.namprd11.prod.outlook.com (2603:10b6:5:2ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Mon, 11 Aug
 2025 20:37:04 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 20:37:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"mingo@kernel.org" <mingo@kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v12 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v12 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcCp+LaqeuqQghWEO4k9X7rHVGNrRdRj4AgAAXfICAAIxogA==
Date: Mon, 11 Aug 2025 20:37:03 +0000
Message-ID: <d4005db70a0e3ebcbd25207397dd850a1ff7e22e.camel@intel.com>
References: <20250811090751.683841-1-elena.reshetova@intel.com>
		 <20250811090751.683841-6-elena.reshetova@intel.com>
	 <74fd32cecdd42cb45d88a96a1dbb6d74cb39594d.camel@intel.com>
	 <DM8PR11MB575066A9AF7D7055CBCF2EC5E728A@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB575066A9AF7D7055CBCF2EC5E728A@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|DM6PR11MB4529:EE_
x-ms-office365-filtering-correlation-id: b72dd847-fd06-4041-64ce-08ddd916d4ba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aEI3aUJWL2FOZkVxckxIUG02ajRkMTM1TE9IeVdQdE1OSjYrR2NXeHpPT3FZ?=
 =?utf-8?B?L3lhTzZ4K01qeWd1K0VyZUZqcUxEY2ZiVXE0Mk1ZVzZCWlRoWmR4VGNEdmNP?=
 =?utf-8?B?Mzk4MFFUbWFGN2RTUmFKaTlxSC96djU4SkdUb1d5K3hETGR1b3AzVlk1V25V?=
 =?utf-8?B?Q3dBRDVJcFBHTit3L09nK3M1NzZYelhXU3lwcndxL1pMYmNHeHBGTHgvUmNW?=
 =?utf-8?B?dzFXWThDV2YzOWEwMWJzeGNTRDBYYlNmbnRSRUJWUmRUdzEwM1k0K3JwRkpK?=
 =?utf-8?B?bkxYS09JdzF3dko4Y2NQVWEvRDU0eGoyMzhnWnZ3ODZpa2M0bEExak5aM0hY?=
 =?utf-8?B?UERBem95bFN3dnMwVWppYTZMQVBMc0FPZ2h1K3gvMmJCTGozMWNMVERFK050?=
 =?utf-8?B?RHNpZHk5M1Z5amxIdWxYMlpRSWlNUlhJZFY1YWsyUmJiR2FSajJjcStxK2RH?=
 =?utf-8?B?MTlxVC8ySmpBNUtDL3BtTmsxRWNyb3BtdnF5eldET0lLeUNXTkFVdXRBQ21M?=
 =?utf-8?B?YWpnRllxY0ZVM1Y1R0RUOU9lU2dxM2laWHFvV3lKeUcwRjdzeWIzQ2tTMDhk?=
 =?utf-8?B?SkFQSWxncWxYWXdZVDBDdi8zbXptSzRhSkZXY09jMmhUdlE1M0pCWmNGVnFr?=
 =?utf-8?B?Tll0R3hTZzZTVWpkZWF1K0ZQM08xRmRsbnNZWFp3M1lUUWNWVUVVVW1KVmsv?=
 =?utf-8?B?Z3VCQ3kxMXhEOHFoOHBHZCtxdndpOEMwb2N5bUV2YlhyNS8xTWVRTVVCcSsw?=
 =?utf-8?B?TzZ6eW5kaFFINm5jZ0ZMQnVTNXlqTE9aK3BkeGFiZ0d5eER0aEJ6bld3SVVw?=
 =?utf-8?B?SXVQM2R3OG9yTS9nTUY2bjZjVkg3MUZWeFpnd2s0dGw3elNUVTk4UkpqRnRa?=
 =?utf-8?B?MzhSblJSQVN6UjYxWUk3WmRxRVZVaWU4di9zNXZxdlR0R0s2K2hWaWRZN0cw?=
 =?utf-8?B?YTZPMjZTUC9NNm9tMHQxc1BGa203UjlmYjJTVmRtbEZNVDdUOWFMaGZFRmZV?=
 =?utf-8?B?blhkM1luc0w4Z0dGY1QxNVRVU0JVTHM3UzVwaTJrSzQyT3dZQ3lWaXdXREJC?=
 =?utf-8?B?N1NJT0w1OEo0VlUxWWk2VFJqY1VPVzJJK3QxRVJVYUdiUjhzM2pSbStGUitq?=
 =?utf-8?B?TzNDaThxeWZBbCtCZWhJbjJvWEo1cDdhMnNpak1jRHJxOVIrbXZrNUZmdTJq?=
 =?utf-8?B?ZnFjc2ZJZkwvdkN5d2dQeEZoTU53cVU5bC9GclVFRGF0MmlYSXhDdkM0SVBS?=
 =?utf-8?B?L01DOUN3VHAvTzA3MkljdXdiWC9Da1dpTmVCT21UYzVDL21Kb3hUVmVhcWhw?=
 =?utf-8?B?UzZkMlZtTU5sNldObk9OQlpvWWFqUE5IZWl3YjVqVTUvWm1sV2RBYS9SV1N3?=
 =?utf-8?B?a1JHYmdnL3JFUVRGeEo4b01KZUFxWVNsSFZ1MGFTODBseEp2Rm16Z0lGWkZE?=
 =?utf-8?B?RmJPYlpXTUJkaGdXWi8xNXBBbUx4eThaWTVFYjQ2Nnc5eXZoOHUyQW9ZQkpN?=
 =?utf-8?B?TzJudzFVQVNjYjdoQ0dLL3Z6dktWSEVEb3cyUVZPd29SYjlzSGV2aEdkTzRw?=
 =?utf-8?B?VXc5KzE4Szh0YTV2TkNFbWJvRGFaZHdGaU9TUEdyUVZUTUVNMWlrYTE5MmVi?=
 =?utf-8?B?blEzT3YvN04wOWR6K2xVZm1yeVBKdVdSRjgra1ZyQ2EvVlVUdmRhdVFJMHBI?=
 =?utf-8?B?VTcveXcxS0FTemkwd2lxMFJFU2I2Zi9HeTNSOG9RTUlFNDV5N2RqRlFpckk1?=
 =?utf-8?B?YVZucVV4TysvK3ZPRmZLRXE4eHZoNGdxOHRCS0d2WGNrMmdWZXdEbUR5Sy9y?=
 =?utf-8?B?RGZHNDVKbE9GWmd4L0wrbzU3OGQySVJnUDI1UVppT2ZWdnB6aUpkWFdqT2dn?=
 =?utf-8?B?VGYwQkw5UFcwdkY4VXgxOTRwVmFwUFY0WTU2V3grL2FHZllKWlZtZGx0R0dE?=
 =?utf-8?B?Z3pmVEFRMkhOcXg2R2JBd3ZuS0RnS2pzK2JIVmoyYjNMK25FcTBJRFBSU1BE?=
 =?utf-8?Q?N7K6M7yA8sIm52qSQPBT+z2ngBNvV4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWRLMjFDMUNMQm1kVWpWRlpTWFo0TFQralg0cGxKNVFtU1RHUURUR2M2NnZZ?=
 =?utf-8?B?dFl4c2pMeVpvVFpqdTl1SGM5dkYwNDBkWld5MTFjUmFRODZOeEQ4RFdtemFX?=
 =?utf-8?B?QUVVdTAwSGdIVVNocHdOdE5rcG9zNFpKZVRpOGR5QUREUVQrN2NDUWE1MitT?=
 =?utf-8?B?T056a2tOdFA5VU5NUmkwVG5IQWpJSmdMTTRBajQ1UWFwNWorSFA1enZHTnBU?=
 =?utf-8?B?cnZXcEd2b2hqREpvdGpEVkZsa3hVaVNsZzJXcVBJRmF2VFNjajBvempyOURz?=
 =?utf-8?B?ZENlb283cG5Qc0dPVGZOM0RwNDhQUEh5aWtPeGNhSWFMRU5LbDBSN3h3YUFL?=
 =?utf-8?B?UXZhcHB5SGJpVDN1RXoxQlF4elJycHVjR2ZTYU5Cazl3TEVuK2djRkdLNUV5?=
 =?utf-8?B?c3FaM0dLQVE2M2FTTU9Rc0t5bUFFZEJRNHJVcmhsZkNmVG5ORnE5R3RzaUds?=
 =?utf-8?B?K0xxT1prTGpzWWhtU0dxUFN0RHdvUXZFR2hBcG9DVXBOSkhCVklFNUxaY3Za?=
 =?utf-8?B?cnZwL3o0a1BFTWpid0R1Mmc5UkNvNmt1dS9YR2svV0dpMDFSTUNHdHBJQW9Q?=
 =?utf-8?B?RzlrU2sxMGdKZWF2ZytUOVRyU3pFSCtHcFJTSjlrN3NzQ3A2R2tIRWZCb2dC?=
 =?utf-8?B?QmI5dzJQUWF1TWpxN2ZsbTJZck9yc0R3U09SbkEyS1Y5ZFZkTURSN2VvaU1k?=
 =?utf-8?B?Qit0SW5DSkM4MzVaVERjY3FON3BDYVNNSFRWQnhDcmhaU0NQVnhoMVZURGhR?=
 =?utf-8?B?TWFlbDRVbmUvK0JrZWo4K0FYaFBSN3psRE5CNW5Ndk9MT3B1dUpiTHRZaGpw?=
 =?utf-8?B?L2pIdlJmbUtHOWtJTy9aSUJodHZWRm92cEFOcmhMVmJZYm1JeUtQbm5HUTYy?=
 =?utf-8?B?TnIzQU5FandkSEJpVE13T0gvdEljQVVJNzBsRkc5UUFvV1VsSTZ0M2lNUHdN?=
 =?utf-8?B?djI4bUxXSFhHYWF1SFpzUEtKNXdEbVd4KzkyZ2NtUmJ0RWVIUkxOOWNGWkp0?=
 =?utf-8?B?TkdKQ0hHRUFOdkNYTys5T2lJUDVpUldLR3ZTZXNObVZzWDN1NHhoUWRuekVz?=
 =?utf-8?B?a2MvYzN3QWFleFZmM1piWnl6dTBrYndGRWhFVHNPdmJCeTg1UENrNHBLWEJz?=
 =?utf-8?B?SElFNkdtSlpkaDByTEN3NndlZjY5eVdpQ2FxMCt3NWlLUThYeThoU3pGanpC?=
 =?utf-8?B?QVNMdnhjRzAyZkphT1RDVkw2Z25uSTdZSENnRWNRc1YrQ1FSMFRYUC9wcUVo?=
 =?utf-8?B?TjExbkVTdjRvaGp5RHhlcDNEelpLaVVzQTNNMkdYZDBTNkRXcW9WblZUWjVN?=
 =?utf-8?B?NHEwVFI2VXBpYWtsUndUblpOelBhRzZRc3Zua2puaHo4RnBQa0pjZ2lxMS9o?=
 =?utf-8?B?eU9sWGFQVnl4alNIdkxVNzZMdFFOSkdzRldyZmFuK0hlTHlBZThjK3pIOStv?=
 =?utf-8?B?enBkdlZkVFNHVm5qUjhRaWFiOFhvOC9Vc0krZDFOOUVqNkcrOUErOHdKYlBS?=
 =?utf-8?B?bWlUeEMyb2kyMi9nQmhWR2tpRDlNRXZROStlV3d4blBsamM5YjNmRkdIQnhx?=
 =?utf-8?B?NjAyUitKQlY3VVFUVm1ubUtFVGh5cks2b3Y5UHdWR2F2VmNxS0hZMVUvY1hq?=
 =?utf-8?B?OEVuQWYwblM1WXcrLzUwNWdhK2RUS3RwUkNiVmhkWitzK2M1ZUVpOE81Ymto?=
 =?utf-8?B?TVNjM0svQWNDWElwbENsZ0ltRHJiZ1ovR3hyWHAyb1pGdVNzdy9SOEZkSUh1?=
 =?utf-8?B?dWUvaU5KRHY0NUl4ZGVxdlVpNitmTVg3K2xMbEFXQVJ6MmQzbUdkRnZHV3dn?=
 =?utf-8?B?NEFpOEVtSk03Z0Q4ZDU3YmpEeHB5MDdaOVMxb2Q5RDl3cWxoUnpYaFF2R1Qx?=
 =?utf-8?B?U1JRRkxuWURlQ3Y4cmlrNjFHWE5IKzRyZGlWUzFKbFdrWHo2VFcvU2lma1hW?=
 =?utf-8?B?eTY1Ykl2MXFZcnlleW9oMVRWMWN6ZFVlOEhyK0tweHZneUowOWkxRDEvTEFt?=
 =?utf-8?B?NWRhZDRYWklFRnJnNUlJcHlYVTRuSjhaaGRNbytwK1VMaGxxcFlEQU5TVnY2?=
 =?utf-8?B?VFRrcnlUMGVJTHVwSXhiWGVrZG9abXdhMDVLZThBNU40ZmtZemo4bGdhUXdI?=
 =?utf-8?Q?8QqBr12I+UfxbwkKKj0110XmG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE9AB405C6CE9B4D82A243DDA4C81454@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b72dd847-fd06-4041-64ce-08ddd916d4ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 20:37:03.7718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NUj0i3bo3eR4fyTS+J8agFD8+TsZ8nkJoToGd4aHFP6WGW+ZRbR8TlVaE+hz3qhyggNOxKlRJw4wkdnGEcqU9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4529
X-OriginatorOrg: intel.com

PiA+IA0KPiA+ID4gDQo+ID4gPiArLyogTXV0ZXggdG8gZW5zdXJlIG5vIGNvbmN1cnJlbnQgRVBD
IGFjY2Vzc2VzIGR1cmluZyBFVVBEQVRFU1ZOICovDQo+ID4gPiArc3RhdGljIERFRklORV9NVVRF
WChzZ3hfc3ZuX2xvY2spOw0KPiA+ID4gKw0KPiA+ID4gIGludCBzZ3hfaW5jX3VzYWdlX2NvdW50
KHZvaWQpDQo+ID4gPiAgew0KPiA+ID4gKwlndWFyZChtdXRleCkoJnNneF9zdm5fbG9jayk7DQo+
ID4gPiArDQo+ID4gPiArCWlmIChzZ3hfdXNhZ2VfY291bnQrKyA9PSAwKQ0KPiA+ID4gKwkJcmV0
dXJuIHNneF91cGRhdGVfc3ZuKCk7DQo+ID4gPiArDQo+ID4gDQo+ID4gSG1tLi4gc29ycnkgZm9y
IG5vdCBub3RpY2luZyB0aGlzIGJlZm9yZS4uIEJ1dCBJIHRoaW5rIHdlIG1pZ2h0IGhhdmUgYQ0K
PiA+IHByb2JsZW0gaGVyZSBzaW5jZSB0aGUgc2d4X3VzYWdlX2NvdW50IGlzIGluY3JlYXNlZCBy
ZWdhcmRsZXNzIG9mIHRoZQ0KPiA+IHJlc3VsdCBvZiBzZ3hfdXBkYXRlX3N2bigpLg0KPiA+IA0K
PiA+IElmIHNneF91cGRhdGVfc3ZuKCkgZmFpbHMsIGl0IG1ha2VzIHNneF9pbmNfdXNhZ2VfY291
bnQoKSByZXR1cm4gZXJyb3INCj4gPiB0b28sIHNvIHNneF97dmVwY199b3BlbigpIHdpbGwgZmFp
bCBhbmQgcmV0dXJuIGltbWVkaWF0ZWx5IHcvbyBjYWxsaW5nDQo+ID4gc2d4X2RlY191c2FnZV9j
b3VudCgpLg0KPiA+IA0KPiA+IEJ1dCB0aGUgc2d4X3VzYWdlX2NvdW50IGhhcyBiZWVuIGluY3Jl
YXNlZC4NCj4gPiANCj4gPiBBRkFJQ1Qgd2hlbiBzZ3hfe3ZlcGNffV9vcGVuKCkgZmFpbHMsIHRo
ZSBzZ3hfe3ZlcGNffXJlbGVhc2UoKSBpcyBub3QNCj4gPiBjYWxsZWQsIHNvIHNneF9kZWNfdXNh
Z2VfY291bnQoKSBpcyBuZXZlciBjYWxsZWQgYW5kIHNneF91c2FnZV9jb3VudA0KPiA+IHJlbWFp
bnMgaW5jcmVhc2VkLg0KPiA+IA0KPiA+IFNvIHdoZW4gc2d4X3t2ZXBjX31vcGVuKCkgY2FsbHMg
c2d4X2luY191c2FnZV9jb3VudCgpIGFnYWluLCBpdCB3aWxsIHNraXANCj4gPiBjYWxsaW5nIHNn
eF91cGRhdGVfc3ZuKCksIGFuZCBhbGxvdyBlbmNsYXZlL3ZFUEMgdG8gYmUgY3JlYXRlZA0KPiA+
IHN1Y2Nlc3NmdWxseSwgd2hpY2gganVzdCBkZWZlYXRzIHRoZSBwdXJwb3NlLg0KPiA+IA0KPiA+
IFNvIGlmIEkgYW0gbm90IG1pc3NpbmcgYW55dGhpbmcsIEkgdGhpbmsgd2Ugc2hvdWxkIG9ubHkg
aW5jcmVhc2UgdGhlIGNvdW50DQo+ID4gd2hlbiBzZ3hfdXBkYXRlX3N2bigpIHJldHVybnMgc3Vj
Y2Vzcz8NCj4gDQo+IFllcywgeW91IGFyZSByaWdodCwgdGhhbmtzIGZvciBjYXRjaGluZyB0aGlz
ISBJbiBwYXN0IHRoZSBhdG9taWMgdmVyc2lvbiBvZg0KPiB0aGlzIHBhdGNoIGRpZCBleGFjdGx5
LCBidXQgYWZ0ZXIgSSB3ZW50IGludG8gdGhpcyBzaW1wbGlmaWVkIHZlcnNpb24gb2YgY291bnRp
bmcsDQo+IHRoaXMgYW5nbGUgZ290IGJyb2tlbi4NCj4gV2lsbCBmaXguIA0KDQpCdHcsIEkgbm90
aWNlZCB0aGlzIHdoZW4gSSB3YXMgbG9va2luZyBhdDoNCg0KCVdBUk4oc2d4X3VzYWdlX2NvdW50
ICE9IDEsICIuLi4iKTsNCg0KaW4gcGF0Y2ggNCBhbmQgd29uZGVyaW5nIHdoeSBpdCdzIG5vdCAi
IT0gMCIuDQoNClBsZWFzZSBkb24ndCBmb3JnZXQgdG8gdXBkYXRlIHRoYXQgd2hlbiBuZWVkZWQu
DQo=
