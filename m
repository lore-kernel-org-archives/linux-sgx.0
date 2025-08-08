Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA20022F75E;
	Fri,  8 Aug 2025 10:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754650206; cv=fail; b=GeTDbzvpxn7gLPf1SbRYmS8DY/Jy9Y1zePsSvpk6icG7HyB46IZZjORyhQhspOl0mfAhjlSv4XFUZpubPBvlRN19dCCmraUXx0my/k6hAheWoczVA5KCB/GHy3UfLYfZ33t+c/cpNb85RXiEcHguSfj2Rs3qTXORHISdJiZ3/q8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754650206; c=relaxed/simple;
	bh=pzJc5RrUKRv5B5FjipWNv7i9YrnROMQf4YSPdMpMQg0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z7mwPoyw/2xYmswJOuKvYmvJ9ipAkR+BAFgE48AU1/QGsmNXiQvZ5+AkNaA+UWOc8ywrflhh7Q76BczwR4oYbIXQ0ycq1ho77J8GER6UWxHowm0rJY87XvETdn3djRxEWhqZ+MQVAjxpmrf+piHv0ISw+MzM3mnwFjqs2iLZMo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MvXErjKU; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MvXErjKU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754650206; x=1786186206;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pzJc5RrUKRv5B5FjipWNv7i9YrnROMQf4YSPdMpMQg0=;
  b=MvXErjKUT4PXO9RgYYOC7NtAXlh1TIwHGNOvd08YsymCEj6nNN/YpTB6
   sQRp6fM1Xg+nV+unxe3ygpifKEiKHymUY2wJnbX5fuXbtU/WsUmg6kCWK
   S3EHqCadqPiOC5vc2HpmIj68+l07LtdlVJMNQDrWxCPYOgB+WFPjBx96m
   yuZh2AMRMC48fJrPs28hqjoV3Qj8LH1QmZwSdQyx5Zg2LjH7pLEwiD15F
   s7wkjeL+nkzzoRptOyC20GxRGjISpOnNfxxOsOlCoEcvffoDDP1g5Kur1
   gowXfb6HF2WSgsCaVmn36XUncLOgtNVXsaG3KvSHEgI1P24fJ7uEvgD9i
   A==;
X-CSE-ConnectionGUID: PhyWwxgzQbGiWcbM0/+1YA==
X-CSE-MsgGUID: yMCBvZ2XQI2voOhW5XHWLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="79555464"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="79555464"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 03:50:05 -0700
X-CSE-ConnectionGUID: iNdCtgj7QoiMAzchbW+oag==
X-CSE-MsgGUID: hVSihIFeQrSwDCYtV5Wurw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="202473634"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 03:50:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 03:50:03 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 8 Aug 2025 03:50:03 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.67)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 8 Aug 2025 03:50:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hdl/5I6jvlits5cvR4p/QiIt7AtBwp17LrINl4mxGsxLm4UTpasBdOGrxV2WN9DqwE6geByg8cjDeiK2kkdbmN6iQCpi+WD9A6DTpOCA1pbGuyCxeWFa+MbQc+Z7+HmBibSrk6KxeYyxYjIbQe+TlwHgWnx3o5itCn5rv+a/VUHcsA1l71U7wWQxAEBQcgjnvAS7JT9cuZxeUj/mtRnSXMlxseOiU3Qj3nx1vw0Xkprg5L1lmnDRrGQYF04VW//Gd1Y8X4YrjzsYEAoN/5bQHIvwfIzOMOTLLyIFhL3tiR0IAn9jQNQU2hsAjD+2ArKrdVQ4BO0LIXNswRHbq1kCiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzJc5RrUKRv5B5FjipWNv7i9YrnROMQf4YSPdMpMQg0=;
 b=WIXgO6E1DLY8MVKtV+WNc0BxhzZBLdnxh6R0rGcRuOLJGl0eXkL16QXgaWy3xXxQlnXOa0FccbhixuEfZATal9tTcRr/ttN7xczPMK7rl1m9sjKS5F/pSbDPOif5VN56ICTVVpZIBwE9wlscXGkKds7cBb7SKKe4IDWZCuPNKQMZmJ9ypLOFYET9up8qZZMwx37iJ/A69otSgQGxcAhxqDaO4p/vUj9BttEU9JcCdFhraU2Sqkcwq+s0JIY86bhWdg4f8sCxYHpBNMIRJPDiPFSforG3dvwTMASIEhlvGgva1ghOoK9bFpvEafdG3NRIXWCdH7l27FBKAGaHAJQeaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH0PR11MB5901.namprd11.prod.outlook.com (2603:10b6:510:143::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Fri, 8 Aug
 2025 10:50:01 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 10:50:00 +0000
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
Thread-Index: AQHcBqoj/DhY5IUTb06dCieKXSBgY7RWSg8AgAJM3YA=
Date: Fri, 8 Aug 2025 10:50:00 +0000
Message-ID: <DM8PR11MB5750309FC94AE599885F4EDEE72FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-4-elena.reshetova@intel.com>
 <9f6f6ea01acf4347632f5fa773d90c1d18ff6d42.camel@intel.com>
In-Reply-To: <9f6f6ea01acf4347632f5fa773d90c1d18ff6d42.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH0PR11MB5901:EE_
x-ms-office365-filtering-correlation-id: b2371499-a484-4c05-87e8-08ddd66952ff
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y25BakdlVXgxUllzTEJUQUtjRzRsNlZvRW04MGVEMzBtVHVJdU1tZzZEeXN1?=
 =?utf-8?B?RmF5d1dFTnBLQjM4anNRdTM1L1l0MXM5cVNtL0VZeENsYzVNQkVQN09iVHFK?=
 =?utf-8?B?R0M3NGxhKzVoSmtKb3BIcGlrNnFKVWQvQ3dEREFzK2E3YUxzK0wvU1owSnFD?=
 =?utf-8?B?MDhvc1QxQjVjRER0SStvSitqSmE4Sm15VFNDRE1YR204TVV4alRPMmVXRmJu?=
 =?utf-8?B?WWdHRGQrUUlSWi9SWXMvYWRMUUtDVVJ2SDh5T3A0WDIwdklXMllXcEoyL1FZ?=
 =?utf-8?B?QzF5bDhkOEovWlMvQUZQZXBKaVdGUldqWDVKNUM3WGlOU0FESGtVZisrUVdS?=
 =?utf-8?B?MFd4NmlzdzM2Wi9QRytnVWUyeHlFMDVNTnpYdGlYaG1mZjdOaFh0K3l1STVs?=
 =?utf-8?B?amZDS2ozWWFxamtpb2FVNlU4YzM0d0IzdWRWUmVoYUZ4alRlWEkyV1ZJMElS?=
 =?utf-8?B?QjJ4Qnd5MzhlbUsxcFYxc0JoVTVIVEVWci9kemFoUEd2WDdFbkZJZmVQekk1?=
 =?utf-8?B?OG5vMUQyMGVXQ3dGVThoZUxhQnJ5TjcrL2hpUnNUcGZIZ05KU1gzT0hBVTdv?=
 =?utf-8?B?eGlhcUlCMEtBYjlGbWNHd01nMDZzeHBnVm1VNmYzS3JHcVFTNkE0TE9Tc0d0?=
 =?utf-8?B?M0hiZThxekw0d1cwK1lDNnNOM3NSQVRIWUJyQnZCTHhlbGtDb0hvMS81QTB4?=
 =?utf-8?B?MVJkQXpKcmQrSlB4SnpkK1hVMnFVMTNOa25DaHp0WlRzQVl4WUk4d3RJZlFJ?=
 =?utf-8?B?MU1rY0JPL1Bod3FiWmVnODR4eTRmL21kSjdmRUV0d1BLa25mOE5YdUxpNEEr?=
 =?utf-8?B?WGRIUjhNODJFL29wUmNXTTJ6a0lGSTBNQ3UrVE9HNFJGRVMzdnhodjlNdHpR?=
 =?utf-8?B?Q2Q2MTZISE9zZHdBbjBpYXNoOE1mbVQ5Mk1FWGNBSTZjbTNuT3RaSlJOT1M2?=
 =?utf-8?B?UlRibkN5ZDBrS1FKR01YSnl6ZlZNczRlaExjWGJLdEhQenJ5eTUwekdmb3Q4?=
 =?utf-8?B?KzJWRzR4NmJla3VNQUd5aW5KTWRIdWo3WDZReEFwTkR6MXAxR2QrdXRrTk5q?=
 =?utf-8?B?UnYyakpmeWs4U3FubmpPUUFnZ2ViTlZVNld6L0V1NkVOZFpCUkRzM3RuYVNJ?=
 =?utf-8?B?ckgzYUQ3cUxrVCtKSUxreHpYVnU1WnJUOTY5YjlQWmNlZ3lxVlBxRnJoWERj?=
 =?utf-8?B?d21nQk5Md2U1ZUxoWmxCc2dGWTFLeXlQYzNLSW1abTJ1akJpbEpTUFVBZ0ZC?=
 =?utf-8?B?RElUMHhQWFZhbXU3MlBYVHdHSVcyVmQ4YUZLWDdkNTZsdnFnQ3BGODNRbVFR?=
 =?utf-8?B?TTVpR1pSYlR4S0ZUdnM3Nnd3dU0rcDRwTDQrV1U1Sy9Jc3ZHTDBVWWhEdG1D?=
 =?utf-8?B?enh5eCsyMjAzaTBrcXlwZDRvaFJPNXEwNnd2V1IwbHp3ZHNXVHUzTS9aV3h1?=
 =?utf-8?B?REtMdm8zU3hYL3VxYXp5dzdBWUZwOVFiOTB1VUxDUmtlWk10RGZTbVpjclZM?=
 =?utf-8?B?bU1pbHdNOTBLdjFrYmRobzkvSXNiSWZKYk5uQ0FaYWw0RmRpcFJkQ1pSb29Y?=
 =?utf-8?B?QjZMdlB4bkRBY2RwcnRtWjZLZlRBYXJZMUFOaTliTzc4Z2pOZ05XT2hCd09M?=
 =?utf-8?B?RktFbnBGZVZ6VFI2S1dXbHRDTU1yWXNrM1JOaFBVdDM4cWp1V1VLaGJGNHRB?=
 =?utf-8?B?N0ovRGkxdVgvOG9VSmRPZGppRVB1UjJUTnF5K1h5UEx6WkZZeDB5N0M0a0Nw?=
 =?utf-8?B?dVVwejZiTzduQk5oQ2paWHY1MzBud25tNVpJczZNd3BWWnBaK3dGUnNhT1Fo?=
 =?utf-8?B?RGc4a1lSZEsvaCtXRXdpbXBTTjkwTDBRZWdybHNJRTROQXovVEx6ZW9qQ25h?=
 =?utf-8?B?N1hIRjNCWG9DTjkxWEc2V3RhVlgxbDZCZlZTT29JcEsva2UvUXFQZlpRV2Jx?=
 =?utf-8?B?UGNORlhJaENBeU1pTWJtN0UrK2VTOXl1MXJZYVR3a28vMlB0bmhoTHBwQmg5?=
 =?utf-8?B?L0hUd09vMmd3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2tkbGVOU2tCTk1MOFBXVE5WTFA1NkJidW9QTE0wOWJQeGFQMnVqMElhZzR4?=
 =?utf-8?B?MWd2TlNTUDQvek13bUxiSXZVWFMwN3A3U1g2ek5wdE1VMDJvTGIvS1dYSWRG?=
 =?utf-8?B?UU5RQnUrSENDUmVXZXhmMFJBRUtvWXZubHg4aDIxODdxalVXRy90WkFSOWxK?=
 =?utf-8?B?akJtOGY4U21UaVBxV0R6YW4rL1hYM0Zkc2xXOXEvTkRkQUZobVhOREkyOWUx?=
 =?utf-8?B?S0lWUHlhUFYwK2pqalRMSEo1ZDFoUjVCeVFMdERQdXJNZFBoaE5pbStjNnUy?=
 =?utf-8?B?aGxCYWN1U3dCelZZd0oxUnMraWxnVytpa2NqVmwwVHROY3BLNEFiOUlkOXAz?=
 =?utf-8?B?OXJXN0pITXhKVWR0RGVKN1U4RW42SU8wOHhMTFMzeWZab3hIOVpJcE5XbTdt?=
 =?utf-8?B?WlFPWWxFOWUwSTJzcWU4YXFSdnpIeWFscVpneUZ6R2s4T0VoSTNVSjhnN1Nh?=
 =?utf-8?B?aHBqTEoxcURKMWNPdG1ZWTEydyt1dnlWQ2dPeUJ2NG1wYWZnN09tSERnVTFR?=
 =?utf-8?B?K3RlRVZqVHpEb0hxUmhBd1BhdjdyMUVkMU5CZkJpTUs3eC9zdFNZTHhaenBH?=
 =?utf-8?B?L2JoeERiMlBBeldkT1hGMjRBVG84QXEvSCtGOTZxVzVSL2hzTXVyRkxuZmF6?=
 =?utf-8?B?TmxSYy80bVc1dXd3MGJpdk5aM3V2cEpUZXpVai93ajRuVjhLUzBTSXRkZjZr?=
 =?utf-8?B?OG84Nm1tSHU1dnNRNVJib2dKeTk4OXp4LzJZeHk2VjhOUGFoMFd4cVNoNVV4?=
 =?utf-8?B?NzdFR0tPeVJJVkVtL1hLZ3dnV3BNN3BZZURHL0hrZmErTGl2U2pXRnU5TzFt?=
 =?utf-8?B?UUVDak5jclJjeTRHVEp0TVFVQWN6MGFaSXIwSUNLRmVnV0UxVW5ZZ0NoM0dz?=
 =?utf-8?B?a3pkNWo2WFl4YW1LQSt3WlVqWm0yZC9nS1JoMk1FeXR3dUNMRXl2ZVdqdHNO?=
 =?utf-8?B?OHNTRUw1ZW5NaWgyRTl0NW00aWx3NHJlNmN6c2p3SXBjWUdscm5zQWl4WmtR?=
 =?utf-8?B?NWNxSmw3cDJhcGFVTis0MzEwMFVxSS96Ym9Ic2NwRUVFYVdHaHIxUGRVaUh0?=
 =?utf-8?B?U1ExdEFBREdZcGwwN25ia2VTNmZjNU9Kb2wwdmRXMWNSMTE2d2tJZ0ZPRUVz?=
 =?utf-8?B?aDhwOFArdVhNUUg2dEVWS21uQUk4QkFCcE1IVlRlSENKSjlMZE1KV0JEclNX?=
 =?utf-8?B?c0NZUVdLMkpNSkptTnhXZU0xRkxDNjZ1TU9UUEVmZ0dGZEtGYlVUWFR1cnVJ?=
 =?utf-8?B?WHBvMVNuczF0ZzdVZ29WUGFnQnZ0NmNHUGlwYlZLT1oxeFVoYko3Q0tCZitT?=
 =?utf-8?B?djZFcUpRUERyUUIwelpENkI5SzRFTVVYRlA4c2YySGY4QWdQbEN1cmZxVHFr?=
 =?utf-8?B?UWpDTXVhTjNKeDFJM1lXWlkrQ0Z3NldyMk5ScmJkTHJJNlZXMDVjYldETXRk?=
 =?utf-8?B?WlVZajNBT0tPRWxmTm5aQ0ZPc05wSG12RTIwUXdNVGdLbTJTM084S0lQZko4?=
 =?utf-8?B?TmVwam1lK0FGRFlqaWxpY2NJQkdKc0J4QjJYZld0YXhDVVB5STRHNGZxZFlu?=
 =?utf-8?B?Z2I1YjNueDhsQ2UzclBKZkNMWlVBU0V3Wm83ZXhpTFAxR0ZqVk5HRmw4aURm?=
 =?utf-8?B?dE45NHp2ZzNVejlyMXBuOWozdmY4VFUzVU8ra0k1NnYrSUJhRjJBaHBYTUZ5?=
 =?utf-8?B?VUh0SHAvbmlDMzJTb0plL1k2ZXJ0WXEwaU85KzRaUCtudmpQcTdFcDE2MnMy?=
 =?utf-8?B?RUh5bWdpbktSN3B5eWNwbkpJOGkzK3luS2FLeEtnUHVnYWIvUEEvZW1Rc2g2?=
 =?utf-8?B?V0o3TUJjOFhBd1dxZVVTOEJ2eHdFWGhua1FlaTV4QU1ndFZNMFVLL1pzeVNw?=
 =?utf-8?B?Wnh6eTg5UzZrMXZCcVZoVk9SM1NxUWIrdzlPWWd6OHByb1E2TUwvU2VvMXd3?=
 =?utf-8?B?Y1pyMVdRT21MR1hZMXJ4NUFBb1VMVUU2TTRrWEJ4TVJUWGpIcVo3eXJGZ3Z3?=
 =?utf-8?B?T25GZjI5YmNBZkNYS2NhSUJlUk5PRWtIYmp4TUd1bzI3OEJ6TEpOc2hzcHp0?=
 =?utf-8?B?R0NsU0pCR1k0ek10OUJXNjk3OGVEdENOZUs3THVUZUd3SWVZSHE0dDZ5WEd6?=
 =?utf-8?B?ZHBUVXlhdDZON0lGVWN1akJUaElRZ0ZXY2E4UWFVcW5SUW1Ea1M5eHFhRm5v?=
 =?utf-8?Q?aUj7M97EA2NIbV/tn43ir+d0k9xm9+zWiVEWTH5u4T2q?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b2371499-a484-4c05-87e8-08ddd66952ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 10:50:00.8586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4vk9xXD0qT6YG7mx7dRmkps85ULeefaHUbDMBt3huGmVrvlMeSAC8mF5wYK29KfE6NLl4FnnT3JNfIcnpSUv26RkvlXR1jVlwo4zP+71vK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5901
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDcsIDIwMjUgMjo0MiBBTQ0K
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
c3RhdGUgb2YgRVVQREFURVNWTiBhbmQgbm90aWZ5DQo+ID4gdXNlcnNwYWNlLg0KPiA+DQo+ID4g
U2lnbmVkLW9mZi1ieTogRWxlbmEgUmVzaGV0b3ZhIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29t
Pg0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9zZ3guaCB8IDYgKysrKysrDQo+
ID4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zZ3guaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NneC5o
DQo+ID4gaW5kZXggNmEwMDY5NzYxNTA4Li4yZGE1YjNiMTE3YTEgMTAwNjQ0DQo+ID4gLS0tIGEv
YXJjaC94ODYvaW5jbHVkZS9hc20vc2d4LmgNCj4gPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9zZ3guaA0KPiA+IEBAIC03Myw2ICs3MywxMCBAQCBlbnVtIHNneF9lbmNsc19mdW5jdGlvbiB7
DQo+ID4gICAqCQkJCXB1YmxpYyBrZXkgZG9lcyBub3QgbWF0Y2gNCj4gSUEzMl9TR1hMRVBVQktF
WUhBU0guDQo+ID4gICAqICVTR1hfUEFHRV9OT1RfTU9ESUZJQUJMRToJVGhlIEVQQyBwYWdlIGNh
bm5vdCBiZSBtb2RpZmllZA0KPiBiZWNhdXNlIGl0DQo+ID4gICAqCQkJCWlzIGluIHRoZSBQRU5E
SU5HIG9yIE1PRElGSUVEIHN0YXRlLg0KPiA+ICsgKiAlU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZ
OglJbnN1ZmZpY2llbnQgZW50cm9weSBpbiBSTkcuDQo+ID4gKyAqICVTR1hfTk9fVVBEQVRFOgkJ
RVVQREFURVNWTiBjb3VsZCBub3QgdXBkYXRlIHRoZQ0KPiBDUFVTVk4gYmVjYXVzZSB0aGUNCj4g
PiArICoJCQkJY3VycmVudCBTVk4gd2FzIG5vdCBuZXdlciB0aGFuIENQVVNWTi4gVGhpcw0KPiBp
cyB0aGUgbW9zdA0KPiA+ICsgKgkJCQljb21tb24gZXJyb3IgY29kZSByZXR1cm5lZCBieSBFVVBE
QVRFU1ZOLg0KPiA+ICAgKiAlU0dYX1VOTUFTS0VEX0VWRU5UOgkJQW4gdW5tYXNrZWQgZXZlbnQs
IGUuZy4gSU5UUiwgd2FzDQo+IHJlY2VpdmVkDQo+ID4gICAqLw0KPiA+ICBlbnVtIHNneF9yZXR1
cm5fY29kZSB7DQo+ID4gQEAgLTgxLDYgKzg1LDggQEAgZW51bSBzZ3hfcmV0dXJuX2NvZGUgew0K
PiA+ICAJU0dYX0NISUxEX1BSRVNFTlQJCT0gMTMsDQo+ID4gIAlTR1hfSU5WQUxJRF9FSU5JVFRP
S0VOCQk9IDE2LA0KPiA+ICAJU0dYX1BBR0VfTk9UX01PRElGSUFCTEUJCT0gMjAsDQo+ID4gKwlT
R1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkJPSAyOSwNCj4gPiArCVNHWF9OT19VUERBVEUJCQkJPSAz
MSwNCj4gDQo+IEl0IHNlZW1zIHRoZSB0YXAvd3JpdGVzcGFjZSBpcyBicm9rZW4sIGkuZS4sIHRo
aXMgZXJyb3IgY29kZSBpcyBub3QNCj4gYWxpZ25lZCB3aXRoIG90aGVycy4NCg0KTm90IHN1cmUg
aG93IHRoaXMgaGFwcGVuZWQsIHdpbGwgZml4LiANCg0KPiANCj4gPiAgCVNHWF9VTk1BU0tFRF9F
VkVOVAkJPSAxMjgsDQo+ID4gIH07DQo+ID4NCg==
