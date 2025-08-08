Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE2121D3EE;
	Fri,  8 Aug 2025 10:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754650182; cv=fail; b=WMClexMqSEa26NW835fAWpvpMTfBAR4zHdG6RHkI3Q+ic4PVVK23qq+qLqvrzi/Go1uwwzROpGpuFhoc/ffUBMIaaC1OHGVFFJ8/P/xx6vjthgGczwk6cnTSOA5NGy2RXXrI+XcPR11AB03K/wCqfkwhI5/i9hyLwc1UMpiVu7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754650182; c=relaxed/simple;
	bh=zVNwUqlgjJolxMAmDlLW8KWZx+mDGZIoDgL9A5fOcs8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SZcmzc9bg+dyDSWjEaz+vggiUwGj1k6ZgfaCdTNQhsZ1AtZrloC4CANt1J9QOjr0cWFo6wBkRE1dqzXtT1Sg3Pp/L1JFmrewMeIBfmtRkaPjn8nqfIJKe9RSvfgQ4UmRwJrt/n5ZLiE4ElvO4j0sHS54csVVYNPI1xnZ/vBQxDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZCqyHhH/; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZCqyHhH/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754650181; x=1786186181;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zVNwUqlgjJolxMAmDlLW8KWZx+mDGZIoDgL9A5fOcs8=;
  b=ZCqyHhH/Cixula6m1pZHxRBCnKdHglPU9PSlrAWkjCFfc/BLZw5SP/Ak
   TQ7Q+LxJZ7TpLiSiblJ/mugWKgL44cjHSKYocgd12OEo1mrvkrXY7lpe2
   LhOOXub2hjIQoJG3/8v81O0i88brnLF8XaWMN+/+PB4RrVZPXlp6it7u6
   kFQXA4u2VEjpXxwxN8AQoJ4ENHdy5vFlRyEWEUSJZcHbdsy9MbvI53l3+
   Q3vWEjob7KP06oNVyvEwXRSsVN3YP5u4QGUoZuyMj56gFTsywrTxWq91M
   NXvZww3EboAzWPBtQbAoU4c26r28gRH0hucYeOV6wMwVU7ybYL8BGfUn8
   A==;
X-CSE-ConnectionGUID: 8EILEXCwQp+6JYJYvTpCNA==
X-CSE-MsgGUID: jb+TROFfSXymus6uK30y3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="60621884"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="60621884"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 03:49:40 -0700
X-CSE-ConnectionGUID: KIyyATdOTGqvl4u3rU99Ug==
X-CSE-MsgGUID: 7Z2n3/pAQz28G5LAw46DCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="165317785"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 03:49:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 03:49:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 8 Aug 2025 03:49:39 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.73)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 03:49:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fzb/9tbXiIilaOlZ1b92iRLrCpx1ulSaAJu3zlHr2nBfE7x8BaUNOfJ/I+8GPUOOhYC/z0sf/4gjmWTnutvb9HVQGktx7a0oO2pl4wwnB4B/vyf0EUAdA9etOt2XkV7ZnFdtC35FVPDTkc0xk2Lba/TO3RuaZtMUadO3/V5N2xOGu6BUloc5+eHAlcdo6wp/RhRxpAKjlHMU9lRXd6bY8PImkpIKPZ0Y3bd3pYopxteq3UHohohhd5PqyJnKeQcoXk6RSbyMttULFvJpJWlbjc7emPz1A1AmP0eNMNtj+o51k0394rfyEcE2PUi8IKOMK9oNt8+mhx/V/x9tN3r6TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVNwUqlgjJolxMAmDlLW8KWZx+mDGZIoDgL9A5fOcs8=;
 b=bsfBhOFuY+XBjx5BEwJ6cyPo0V/xa36iSwzAgJ+03mlekTz0tsig3elmO7LoGRVj70fDRH/pQnTiOpW3MkHhtRK3TvxpMbyAik+Zx9YRprDr2Wa++vbAjSZNcMJXa7zK8H3KBJ70+y/i7F5JqupSg/OuBRy2FaDsQzPmSH2boqEOvx/T2UUNCDha/LNZNjBRgTAgIJfuOHQFKlCgPpHCOnIMZKrSXtwNBKW5bow61KA18PpKyZMn64YAWMPPe1FkbEMOIJPQzHZGBTWycGZBqAKOd2B34Y8ELtdp/OjzEHHuFDDdkhkJ1wsCzmm+2db1dc9RfIPbqloeX5brSCnqpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH0PR11MB5901.namprd11.prod.outlook.com (2603:10b6:510:143::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Fri, 8 Aug
 2025 10:49:31 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 10:49:31 +0000
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
Subject: RE: [PATCH v11 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v11 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Index: AQHcBqoj/DhY5IUTb06dCieKXSBgY7RWTDmAgAJKjIA=
Date: Fri, 8 Aug 2025 10:49:31 +0000
Message-ID: <DM8PR11MB57504D7EA288C50128D1C116E72FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-4-elena.reshetova@intel.com>
 <0f3ce0d9c5a43a70cb119d47c71dbba36264f29d.camel@intel.com>
In-Reply-To: <0f3ce0d9c5a43a70cb119d47c71dbba36264f29d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH0PR11MB5901:EE_
x-ms-office365-filtering-correlation-id: 26e156a9-b6bc-4f34-3242-08ddd6694178
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NHFzdVJCcWlLa2ZNN1ByRzVoR0c2VXBkOTZoRC91SGQvWTY5L0RBZnlvNzcy?=
 =?utf-8?B?bDBzczZaZlYwQ2lWRFNTa3FrMUpmL0cxSVdpUDhBeGZxaklBdTNsUlVxWm1o?=
 =?utf-8?B?UFoxc1R2dVRaSG1NVzVBRDdtTEJ5K0Nwc0hZcFV2blFnV0xzeXNNOEQrT1lG?=
 =?utf-8?B?YU5Kby8vVllmUHU1b3pYbTBXVVgwbXV6VjNpTHdtWDNlVjNUUGQxaUdTalR0?=
 =?utf-8?B?bmcwSjBxTE0zMjVSbUVCRjBRcGRleVdPQmhPWlg4cFFZZXJYbFlrSkVQS2lU?=
 =?utf-8?B?Tk5kN2NFM0x0UnVlakdoZTc3WXFUbTJwUWVTNmpwVi9MK3pHYk9tSVp4blZl?=
 =?utf-8?B?Y3V4OXdHMURZMTE2d1gwSTE4bExXRnMyQUxDOWdaOU1oS3kwQ3ZOVjFXQkFD?=
 =?utf-8?B?M3o1RS83TElJSnlUM0NpNmx2VnhrcHF5am1CS2g3UFZyaGNNYW04aHh3elNa?=
 =?utf-8?B?a1IxTHJKckV4eVhNYW5iRmxpQmhrQXZSNXBZKzRLcTFQbGlIb0hGMHU3U29G?=
 =?utf-8?B?clJla3hNTm41WjBwT3dPNFA1cUpJMzNwM0FQcjJESDMxOWt5TDJlTTE2NkdQ?=
 =?utf-8?B?R3lTWjJjUENXRTBGdVhlRytzNS94cVJjeXJFVlEvME8xdHZqS0N4bWRZY1Va?=
 =?utf-8?B?R085VlVqWFhzcklwVnozN2dsOWRQMnFBZ2htWWlrK0N1VGtlN3Z0OXU3alJD?=
 =?utf-8?B?VDVaNEVUV3pxR0tSbWRwRjhHT1FmY05hWDJnWDRkdEVtam1zUEl3bHpJQnZX?=
 =?utf-8?B?djg3QnBGTU52VG5zSjExZitFalh1eVNxRzROUlR6ZzdRN1FEemxtUGFud1dt?=
 =?utf-8?B?TGdjM214UzcrRjFDRktaWHpsQ3NyMXZ5NDJOY1BoSy80Z0RuTFNMTVlaaFl1?=
 =?utf-8?B?ZFo0WUVWa0l4M2YzV0d6WFEvMDBJMmtZUUJRbkVIdGRHTm91a3RDQWU4MjBm?=
 =?utf-8?B?VDNyQm56N3lpTWYraWw1dEV5TE12TEZ0OFBlRDhTMk9iaEIzSHRIRVkrdnM3?=
 =?utf-8?B?MVN5b1hrWFVXUTBjblJLcThHdUduU1c5WjVwWTZQRGJlMHNxa3d6RzdKOUJ0?=
 =?utf-8?B?WngvTitSMkpPd0dmYm9qWDZGOGFYN2ZEb2w1c25GbXlnRmdLVnZtWHVtUmxS?=
 =?utf-8?B?dkhkaFNrSXRuMnhhbndDM29ZWXU0VGVGUnRNOVJ3OENMRmdSSWlBNnJOK0xs?=
 =?utf-8?B?Ni9GZE9BYllzc3MxYmJ1MmZlT3BjODJiN0hLRUNqcjZiODIzWVN5YkNUOGww?=
 =?utf-8?B?LytaRm9MdkJ5VTA5Qmxuc0FSNzVnWUR4NWtoaXl0YVhBRHJ2RXQ1ZjdPbzdo?=
 =?utf-8?B?YWtPTDBwV0lHNDVnYUpFMitTT1gyVEpaZmlPYlNDSzZDajRjM1loeTdYMHVi?=
 =?utf-8?B?OG92cXdUbEFGSHROMUNCOE1YaVdjT0ZtSVU4M1NKVml2UzByb0kyZTNaelVZ?=
 =?utf-8?B?bldkWmJjN3lVczFuMVdSb1lGRzB0a0lJV09LbE5yaGdDN2U0YWVwM3Myc1dP?=
 =?utf-8?B?K2FtcGR6NmVoMnBrNVNXT1hKZEp4WnJKZkdaaTczQzAvZUtuc0RKWndna2M1?=
 =?utf-8?B?TGZkTXh5Z0N5SUpVQ1Z4WHpKNlhLWFlwZE1KaFRiWkhEYnh5Kzc1d1BtZEtw?=
 =?utf-8?B?ZlU5MFdrYkExbFA2ejlka1ZxMHFMeGplS3VndUU2VUJBbEVIYW4xNkVzcFFX?=
 =?utf-8?B?L0l0NkZxeXh6R0xNTzQvYU1nS0lqRjdhUzJORWlUbFozcHB5MWVVenBxVnk0?=
 =?utf-8?B?UEVoVHFKb0VqSHRZT3ZBeE96RUtnNThtUEY5OUZuVGZwRnE4RVhHUllvZEF6?=
 =?utf-8?B?cHJHbEZEYTNEZFVKN0Z0ZkZQcTYzUHl6ZHVOTFNXdFI2RHFFd2lzRGJEUnpa?=
 =?utf-8?B?STNJa0lXWVl3U2xLc09LRjRJbklCaUw4cm1rOWUvL1hzc29JMFQrOXgvUW1w?=
 =?utf-8?B?SVhCVENiYkxNWmNHZXBiWW9pdXU1aXpTMytPeGkxS3VzY0laQVBKY0E2Sk1C?=
 =?utf-8?B?Q21sdFdXTE5BPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2kwSngzY01JVmgxWGlOOWJsZS9lN2Erb0RWMVdQUkJtS0Y4Y05BeHorL0Y3?=
 =?utf-8?B?RFhFdkJ1SCtHRjZqNzhtM1lRYlIyK01CdGJCZ3RzM0dBSkNZVzdPckd1VWJn?=
 =?utf-8?B?aFRRZXZxVjNwNE1FRDBXMVVkMThSakdkMU9PTWZlMDFXYjg1cnJIR0loZDdj?=
 =?utf-8?B?WHdCWUtlb3pGUzBjckZVSTdFd1J1ZUE5Ui9PT1k5dEpVbXpiSk0wZU5MYkJS?=
 =?utf-8?B?WnY4WHBNbk5KK3pUT0VaNWY1bGJWbnYzazJNQlpuaHg3bmVPUno3cG9zRzV5?=
 =?utf-8?B?c1k0UTYzZUZtZ1hONmhNa2wycXNSOWp3Ujl0VDExN1pNTEpnUmVIaWw0SGxC?=
 =?utf-8?B?bisreTdBb0xKKzlFUWg1UVRtL3VYYjZBZUFFektWUk9xdFFHc1Z1TXFXd1c5?=
 =?utf-8?B?eEJLRkQyUlZDaHlNZ1Awc2VnVmg1Qmg5ZVpGbkNyYnpnT1ZKQ0Z6YXc0TldQ?=
 =?utf-8?B?RVhEMWZZanZYVlQrcGNPTkk0dSsyMUp3VnJ1SWlma1VZc3lnYU1KV29DdUxR?=
 =?utf-8?B?SGttc0tpWHk0RVoyZDN6c2xXc2tzUnlaVEdpMmtVenNlWjg1UlNhVkp3a2o4?=
 =?utf-8?B?OEZIMzhSMVdVUStSbEVJSllJUzlsaEJmN1FFY0hHcnhpQnpoZkhzY2J5VTBa?=
 =?utf-8?B?NWg5KzRoT0VnSytUMU9MMXIwUWxEaHJVU2hQZUZGYjMydTNtU3NTT0RYK2gv?=
 =?utf-8?B?T0NpMlp0aDFDZ2EwRUJRdGpVTFNtODN3K2NZdjhYUTl3YjJhVk5PMDhsd3N5?=
 =?utf-8?B?dSs1b21CYnVNVGhZSWtxbkthaUE3cDFmRC9qMnJpWDVTb3VuT1M5N0FmaDhk?=
 =?utf-8?B?VVJtNjUwak10YTJyOVhscVQ4R0ZEd3RDRHVmdnJJNGoxYmtSVmFLMGFRMGtp?=
 =?utf-8?B?MlJrNGpUdU05UXRSZ3BXNG5vckhQOWhPbG5lY295Q3RSQXpBQ2FJUll0MDFn?=
 =?utf-8?B?TFlHajlGaDFjVW11RWRVbW5YM09BK0NHRVVHcVRiRi9DUTMwaHlGaUJERTZQ?=
 =?utf-8?B?Y0xZc1l0TEo1VkFITHlndWQyZEFURUVIYW0wR1lmV3UxMG1JMjFIQjcrUmtZ?=
 =?utf-8?B?TEN6dk9ET1Rldkt6SHR1bnNCRUdNM3VCVy9GaXhCL1B3OFlTSDlaVEV6ZGtB?=
 =?utf-8?B?UnlwSUFwNTZQK3JZa1JrZGRQeHltM3czT2NTTElGU3lsVDRZVmNMSXRMb09U?=
 =?utf-8?B?ejIwVXUzQWdJREEvb2RmbDJIMEFncXorRFJxL3JnVXJndndkNXUxOWl1dXpt?=
 =?utf-8?B?WElLNkhBWi8wQ01zTThoRE1KZ250dDZUZUhVM1VNcFRaTHRlUkQ2cENvREh1?=
 =?utf-8?B?S3hFdmdZSmR3ZzFPVzkzNjRrRy9HSHNHK1UyUk5rTlZsWG5FblJUWnhRNlVs?=
 =?utf-8?B?Y1liREVqZERTZkRKSm1zd0I5Q2VPWERkMlZuWnFmT29FZUxrcy9WN2Jtemdj?=
 =?utf-8?B?TXRxUXZZdlBWY2U2cTllaUgyY2R3ZHJjd1ZUbWRYUVNmQXAreG43SDJ0aFA4?=
 =?utf-8?B?ZjNmaGxpYzNHVk9jYTIvU2MwVW5pdlZpdFNQdkwyMllQTFhPdDdOUlZLWGlT?=
 =?utf-8?B?emJkKzFWR0hreGJQeXVscmp0dHFPNDhRS0VadGllZEdpNVZZK28yMFV5dEw2?=
 =?utf-8?B?VlkwMGVkVWRoT2V6SlpnejcySDljYW9yZ2NvUm9JV1E0MUNoNFNGTXlWOWE0?=
 =?utf-8?B?S2lEcnJNaUhVY09sbFVDRG9OaFhhTEVaNHNzVEYwZlI4U2wwYjhPOGhKRERL?=
 =?utf-8?B?OHJQLzJuc2RtTmZjQWM2MWdyLzNIUXg3NmdFbDRLc2Z1dmw1K3dQY0ZxVUdS?=
 =?utf-8?B?ZHUxOGZMTGFrcmFqMFVpZ29SZzUvZW41YlVNYXpLZHgyNlZ4bTR6RWdyNTIv?=
 =?utf-8?B?RjkycXEvNU85dDRjRTlsSXJxazV3TnpndUZSQmdDWGM1ZjlkT04xNkdTVitM?=
 =?utf-8?B?TmxzUkF3QVIwWlBaMEdKRUdscmdDU3lwRk1kWjZuY0FEWWVLMVkyalMrNWdC?=
 =?utf-8?B?OWN0aTZhd1c2amJJNXkzSjZaVkVROGo3TXdWWWJPYUdsTFpDQ2xQYVg1RkRr?=
 =?utf-8?B?ZWNNM1Vyc1VUby9rOGxtUmhSYmxjM0lVbmpQZm92L3p3R2hUUUpzMzM2dVBN?=
 =?utf-8?B?WjRsK2xlSm00VmlzYkl0SjkzVWlTTXVCTHk2bVRZT0ZYNHRua1dQUW1YQmVH?=
 =?utf-8?Q?yYE4vJ4rxTvSFd3vYz0J6MA2AKdJBOuFLt/J67p54XD7?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 26e156a9-b6bc-4f34-3242-08ddd6694178
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 10:49:31.4654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ta2sbcTCSZJVm4lPDY58uVVLscmDFknhhzhogMVutOmnXkdasqqMwwptVKULqSelyyhvxAV8/OuCxNzL/uQMeMCUpnsXT9UmOgeOtObDVrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5901
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDcsIDIwMjUgMjo1MCBBTQ0K
PiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT47IEhhbnNl
biwgRGF2ZQ0KPiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPg0KPiBDYzogc2VhbmpjQGdvb2dsZS5j
b207IG1pbmdvQGtlcm5lbC5vcmc7IFNjYXJsYXRhLCBWaW5jZW50IFINCj4gPHZpbmNlbnQuci5z
Y2FybGF0YUBpbnRlbC5jb20+OyB4ODZAa2VybmVsLm9yZzsgamFya2tvQGtlcm5lbC5vcmc7DQo+
IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOw0KPiBNYWxsaWNrLCBBc2l0IEsgPGFzaXQuay5tYWxsaWNrQGludGVs
LmNvbT47IEFrdGFzLCBFcmRlbQ0KPiA8ZXJkZW1ha3Rhc0Bnb29nbGUuY29tPjsgQ2FpLCBDaG9u
ZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBCb25kYXJldnNrYSwNCj4gTmF0YWxpaWEgPGJvbmRhcm5A
Z29vZ2xlLmNvbT47IGxpbnV4LXNneEB2Z2VyLmtlcm5lbC5vcmc7IFJheW5vciwgU2NvdHQNCj4g
PHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjExIDMvNV0g
eDg2L3NneDogRGVmaW5lIGVycm9yIGNvZGVzIGZvciB1c2UgYnkNCj4gRU5DTFNbRVVQREFURVNW
Tl0NCj4gDQo+IE9uIFdlZCwgMjAyNS0wOC0wNiBhdCAxMToxMSArMDMwMCwgRWxlbmEgUmVzaGV0
b3ZhIHdyb3RlOg0KPiA+IEFkZCBlcnJvciBjb2RlcyBmb3IgRU5DTFNbRVVQREFURVNWTl0sIHRo
ZW4gU0dYIENQVVNWTiB1cGRhdGUNCj4gPiBwcm9jZXNzIGNhbiBrbm93IHRoZSBleGVjdXRpb24g
c3RhdGUgb2YgRVVQREFURVNWTiBhbmQgbm90aWZ5DQo+ID4gdXNlcnNwYWNlLg0KPiANCj4gSSB3
b3VsZCBhbHNvIGFkZCBzb21lIHRleHQgdG8gZXhwbGFpbiB3aHkgb3RoZXIgZXJyb3IgY29kZXMg
YXJlIG5vdA0KPiBkZWZpbmVkOg0KPiANCj4gRVVQREFURVNWTiB3aWxsIGJlIGNhbGxlZCB3aGVu
IG5vIGFjdGl2ZSBTR1ggdXNlciBpcyBndWFyYW50ZWVkLiAgT25seSBhZGQNCj4gdGhlIGVycm9y
IGNvZGVzIHRoYXQgY2FuIGxlZ2FsbHkgaGFwcGVuLiAgRS5nLiwgaXQgY291bGQgYWxzbyBmYWls
IGR1ZSB0bw0KPiAiU0dYIG5vdCByZWFkeSIgd2hlbiB0aGVyZSdzIFNHWCB1c2VycyBidXQgaXQg
d291bGRuJ3QgaGFwcGVuIGluIHRoaXMNCj4gaW1wbGVtZW50YXRpb24uDQoNClN1cmUsIHdpbGwg
YWRkIGluIHRoZSBuZXh0IGl0ZXJhdGlvbiwgdGhhbmtzIQ0K
