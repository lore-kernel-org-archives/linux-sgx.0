Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6166F1FCF41;
	Wed,  6 Aug 2025 23:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754523601; cv=fail; b=NAUh9dSkdoYnmHZvghMPB94pKeIq1ByhMqNryyVN5mihCFjKo1oMg0Y6pfGe0kwymLUVE+Vz/fheDPf6OHR67Is/zpE1AOj4vNWx+RmA43QzdEAwf1Eb2wqFgzaKItdLMxK7o5Rab5peb0Pz7XTCUIWNoWKnD+JolaAIEtza7xg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754523601; c=relaxed/simple;
	bh=+GxRBRfq9i0o4p0upHoAd6KiY55jPGx3EJiQaz35FbY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MADTHAXJPEtfkva/gip6W6ag2rNeCVDjFiuOGbuYgcet83XwXs8KfnGKIQeTUBke61GnaZgdysu3D4AHSpjvxGNdPEtPkOm5rY/nuDFsjSpnJ7J27oBOQ2Wwn4pYyJd2gjeLOCz+6FzDHRiAh4uZb8Ct2L9uhSvv/6HkF5JcIxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lGdYYP9I; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lGdYYP9I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754523600; x=1786059600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+GxRBRfq9i0o4p0upHoAd6KiY55jPGx3EJiQaz35FbY=;
  b=lGdYYP9I6hWOUYm99U+0W29w55828vIw2TFuCVKuREvubHc0596jymyx
   Hc4lXHKV+KheBkWsZ0MghdZjdR5yfAW4nWCOVCYyLxjlkMlUemjV+2zGO
   ubx//XYg1whDan3NptfxLXuJhIxd3wRkZpsoNJNWraTeYtH3NfHi69VFq
   ojHeclzCkHPHmcSUA8ZfQ2105Bm5yXLrs/J1RY5ciheQgHxTgW6NzBDeG
   8WyEO1ZQUfjCd1gIMOJnFkO4ihyQM2Ua6Dgi701XzcXszPOb1fPhf+hGQ
   +EOrw3qjHkI/stFZynCrb5AnxIyO9wMr7EpFVfoTxdl8NAh6tdvmnVI21
   g==;
X-CSE-ConnectionGUID: CPqwlheLQS2UACeEx8fVbA==
X-CSE-MsgGUID: +jT7PNaiTtellJDlujiiWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56993393"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56993393"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 16:39:59 -0700
X-CSE-ConnectionGUID: 48V686gARdiYhrhpoR5IYg==
X-CSE-MsgGUID: AF7I0gfnRzmV+Vln0jrwRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="170170858"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 16:39:59 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 16:39:58 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 6 Aug 2025 16:39:58 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.56)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 16:39:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kmxD8JY/7II9WJdyanyasfx/gMB1KVKuiG4x3q7FCzu7lKjCCljsx66f0+OoZJ4kMVpQ1QwY+oj1aY8UqBSA6TtnXbiJDD3C2K1B6i4wZIumyB5n5GH4uVkSIPS9iMhoUS0yUhINQsWMIA5DZ0JKk+08Se1rQvMU/5yBif7uRNHLITQteHru7jF/ZTD39ykSwBhLGAsVxva6N/ibQ7uzIrzZDXRUNE1q9s55KPFnsBYBDlLwAztwhwaVIAGG8NsD1OYeUKo5B+xqBUTK/GiZGdGEJTaItEW/HeJBmYTlnNqpWrzgUghcEKvbr1jTzilSRYGnvsb6PdmxigPJOT5NPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+GxRBRfq9i0o4p0upHoAd6KiY55jPGx3EJiQaz35FbY=;
 b=adCE2a1XKfKVYSU0PyzmW6itLJ/NYGyiRi65AlRNxXpH8MGCoKyiMl/tpO1KpugDuuoGBEV1u2K1/x7cMe7VLDL4d/0lDeD84A6lThD6FVPEfd1bTHaTH2MMJMaoFctX0d6zahcX4P+BSKVXdYHj5uV8cd6i0j3rIenQiwWca2U9l8Sm64X/JZCtrmXTIcwRAXsnkF6urvC9rA30efjArIkASM0l92HfeYe7sIq+49ZBbRg/1SaGoMfXXYlD2Ql4/y44TdtjkNjCz/2cVD5NCf+5HGzlzsVG2U1viSSLdnq6aJGZt8gLd9GHMRclqoxXP/E7mnuXrSh89HPSM322ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB8039.namprd11.prod.outlook.com (2603:10b6:510:25f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 6 Aug
 2025 23:39:55 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8989.017; Wed, 6 Aug 2025
 23:39:55 +0000
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
	<linux-sgx@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v11 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Topic: [PATCH v11 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Index: AQHcBqohzrz7X0Gp0EGrcvQKOg+48bRWSX0A
Date: Wed, 6 Aug 2025 23:39:55 +0000
Message-ID: <eb6d3e9425f9e6d588a7528c579fc32606db319c.camel@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-3-elena.reshetova@intel.com>
In-Reply-To: <20250806081344.404004-3-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB8039:EE_
x-ms-office365-filtering-correlation-id: 04196c56-3b7f-41b3-7e0b-08ddd5428c70
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cUxKbFhvMHFvQWdZWWgzdVJ2NHFSb1pjdWZTcDVrUTM1RWhHc3NxR1ZyaldV?=
 =?utf-8?B?U1h4V1NSY1czcnFqU0lsUW1ybnQ4MU9ZRXVQK25DcmIvWnQxck5adlZwRTlW?=
 =?utf-8?B?UTJua2luS2ZmVmt2cW9aeE42VXR0K093TitkWkViVXBwUzVEZVdzVnRscW8y?=
 =?utf-8?B?TzlQWE1vcVArckhOeGJwV3RFVTVHUzkzUWlOR0ZlVXE4YWtYc1ZLU205Y0xM?=
 =?utf-8?B?YTh5cDN2WWdvQjZHRGZlVWZMQ3ZTNnFSVWUvUjdZOHczWDh3TG9NekFXRWFk?=
 =?utf-8?B?K1I0aVFwdnd2Zkk4UExtU2Jqc3FVNC82V1pvL1JtMDZOZ3ZEQXUzWlNLR0l2?=
 =?utf-8?B?WVNlMGZPR1hieE1pR0d4N1JTa09nSE1FcTZOUDFsdHpWZ1JZV1V4ZERYRjRt?=
 =?utf-8?B?eHVvRFdDMmZQd1o4dkR6SnFzWUFmS1Y5NzlGVFZ1TldOMXM0U1VNL3NybzJx?=
 =?utf-8?B?M1BsRW5PdVcrRGp5MTVHM2RhY0hXUW1WMWw5ZDJKeVY1emV4SmREOFZWMDBU?=
 =?utf-8?B?dUxaUldPWmNYazlXQkpvT25DWHl5cEUwakQxQ2R0cXo2ekpyeW9DUks4RXhY?=
 =?utf-8?B?d01jN2NpZFc0d3pQV3hQMW93Qlh1RGtXdVlGRis3TzA2Y2RLTzhheUxvQ3FI?=
 =?utf-8?B?WVFUalhZcXlGZjdpVE94eXNSUEVEUVRKUVdzS0ZwN3BNaVM0WWw3QXFmdndI?=
 =?utf-8?B?RlJTNEdFUmI5SjcxZER5VHBHVC9YdUpsanB0QzRHTEp4M1FSTFNDNU1yc25o?=
 =?utf-8?B?TUxpMGFISUJVSnZ1WWxMQXFBOUpRY0NLYzJFQTI5OTZOVHZTd3paTm1FU1RQ?=
 =?utf-8?B?UmpsODdhakRBb2M0Slo3WkhhSHIrdnkxSk9IcWVBWlIxSCtWdTR2SkxuMXl2?=
 =?utf-8?B?dDJBSTV1c1BlNjhVT1RKR2k5aWRVTXRLQ1FtUUVlb3BoaTZVbVRQSlUxdGNR?=
 =?utf-8?B?bmhYa3pGNGxwTWlwZHJFeENoMlFaZk04dytwdzBSdDZQU1EwNjJvc0JtSDdQ?=
 =?utf-8?B?NkxTTkxpSnl2cU1WM1dJeUZ2LzRVemRPcVRHNFdZd1FlT2pSQi9ua2t2R2tu?=
 =?utf-8?B?TFg2NEU4UGo5Y0RBVjBpNkhtKytrNW5rbTZDTlZwanp1L21kcDFMOHhzOTdT?=
 =?utf-8?B?eDB3U1RSdEMrZVgrUFdaMGwvM0JqNDV3TDZBVHB2VTVPNjcvV0NQdVA1VGph?=
 =?utf-8?B?ZEc1ekRabHE3Z0JJMHJhcGZ4V1doS2xUaHZQVDZLSWVLWk5pWHgwd1RWMVdY?=
 =?utf-8?B?ODBpNjBkYmVvV0JsK1F1OTI3QU80OFMvQ2NoVm41Rmk0dGthbU1oTVZCRHoz?=
 =?utf-8?B?c2xXNVBSV05DWHhQQlB5cC9FcU5hOEdpR1NNY0Jrd1NScUlLVGQ3dUVxRU9X?=
 =?utf-8?B?REx5UitwZ3VGRDlkbC9pazAwTjcxMWl2WUlnMHNScXJaR3huVForOEFqRjlM?=
 =?utf-8?B?ZzFCRDZSOTErRFViL2k1cFpIMXUzNHpYU3VLSUhWQnFtejBaSE03QlEzb3dh?=
 =?utf-8?B?Z2JSK052V0lFVk0yRzR6dWxSMzVLZmRIV1BGcmE5aUtpV3RkbGxxSm1yVE1a?=
 =?utf-8?B?Sis5RWxKemFTV1ZraTlyOHdWREV0bTBYUGhiT0pWSE5OUUgrZEs1bUZxT2dD?=
 =?utf-8?B?VmE1dCtkY3V2YWFyQm1wTFZkSDIwUWFraDM0dEQxMWozdEoreitqdXVpNE5U?=
 =?utf-8?B?bjd0V3ZhSU4rVFdydjFLYUxGRTRGZ1RMT3hzS2dSTFdFREEyNlBBazV0RzFR?=
 =?utf-8?B?bnFud3JGZ0c1NjZJUEp5TUF4R1JYQndxakRBSFZaYzJTUC9iTG1oUHNBNU82?=
 =?utf-8?B?dnRDbzJ3eVhMRWx4dGlxbEppbEIyUHJ5SkR3UG5JeXpqMFpUZCtaZjRReTha?=
 =?utf-8?B?eEhBVVdHTE85R1RpYUk1d3c3Q0ovOUtyNHY4OWEzR0tSQWNrazhLNXB0STZH?=
 =?utf-8?B?WElvNkE4SC84TjkvTHVFSXdzU1hwMzl1VGg0K01PbWlkR1I4ekFBRDlvZHJJ?=
 =?utf-8?B?WVZ1TDk3dUpnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjJXdHo0QUM5U2UycUEyQTh1UjBWTlo5K1MxZmVnVGVXMGRick1XRVJoYkNT?=
 =?utf-8?B?aFp0dVpiU1pZdEpkVlFwYThkV1B6MEQyTFAzNThqeitJV0V2MzNGcHBna2cv?=
 =?utf-8?B?cmhqWUU2ZnhJdHlod0tQU2xRUlhMdkNiZjNRUEtPNEZUNHR0V3hPTE5DV3pz?=
 =?utf-8?B?K2FpTWI2QnVLSllDNE5ERExqTDFKT3RBVXRidlFWbjhWRVNnMWE5ZHR4WjZP?=
 =?utf-8?B?Y1ZPY0ZkY1pUNGI3dGd6cGVCcEEvSUNWRDZJYjdkczRaZ21WaWZSRTJzTVNK?=
 =?utf-8?B?cmVMQzh1ZUZEVndzVEYrQmNxWitkY251VEErZTJBTk00ZUVHWE5yaW0rZVZq?=
 =?utf-8?B?SlgxV0lYeDVKU0Y4bFFqcWZ2MnFCN0Q1MkQyWlptSk1OTjloQ21DWTBFVWI5?=
 =?utf-8?B?YTB1ME9zMkZMYjlqSHpScUIwcFpBL0NvOU5aR1BNYllDNU5qZUpxb3FvaVdN?=
 =?utf-8?B?Z0xzQVZtZnVtdkhnT3hOK0dwU1VkZmhzVEdPSGJHV25lazVPTXMyMEFZUkIy?=
 =?utf-8?B?QXEvWVdjcy9WNWljTERxYXJVdjRZbWFQYlg4N3RHZHlndWJKNmR0cHlJYVhY?=
 =?utf-8?B?WURUM244M2M5WTVpMGRMZ3hKZmVvSk1FNGRwbTFoNy9XbENUVEozUDFlc2w3?=
 =?utf-8?B?cXBCOGt3cGZyOWxDSHU1a0pTRk5uS25oWHhFTzJ6c0RJUmpSOXdTSDZDdGVQ?=
 =?utf-8?B?K0d6UmZDcWIwVGZ2MitNaDQ2WHZiV0s3R1RMRHJMYVJBQUZmSzZxS3cwaWlG?=
 =?utf-8?B?dlExUUpHeHFBVm1TaU5ySlNTbEU1MHl4VWE0QkVMcWhIRXlXNFJUdkh4TVRz?=
 =?utf-8?B?V0I4VFp5MGVlQlE4YkxjYjhIRG1qRGliT0JidFJPUDB4Vyt3NnBmVENUNTBR?=
 =?utf-8?B?RkJ2U2lTeTNsbGVCMFY3SmhndG1xeXZVWDBBbHpXeWtESjFDSUVDSWpLdllZ?=
 =?utf-8?B?VWgzMjFONzZ4T25xaTBBZlVoZDRSTExnUVU3Z2tXVmU3Y1VqUXU5TS9XSXkr?=
 =?utf-8?B?bTRzQ1BuZXZMNmRMNDEzWEorNGpjR2hKQ1c3UDYveUNqVm02cXpKUUlSQjRz?=
 =?utf-8?B?VUNiUjFUWStod25ZQ28zekRnWXhJRUlvWldkN01KWDJ4dnd5NUI4cHV6NWJm?=
 =?utf-8?B?U01RcncvWFlaNStzT1NGVFhzc1hYZlZZR0JURlZqWHJpZDFBdk5GRjFjZGZ0?=
 =?utf-8?B?d3cwR0NRNmQ2MHVndTMwQ0FrUDNpNTZIWEoyZDlSTHl5YVFZSFJocUxmakt0?=
 =?utf-8?B?NFlFZUhhRFJzaXIxeTAyQmtCcGh5eDFQbHdNUWZ5TURLMXJaaWQwSExOWGtW?=
 =?utf-8?B?M2l6b2szWGxHbUg0WjhHNlBZbGdSNzhwY2tRMXBkL0s5Z01PTTVCZWl3WDJ3?=
 =?utf-8?B?akJwMnpjZ1A3MzUzSmhKeUJOZm55N3lmUWxBL2syZTNYazBsaW5zV1E1Z3lZ?=
 =?utf-8?B?NDZpeGpXU204VmdZUFc2Unc4ZHk0V3hFcnZGdFUzN3lxZkxYLzFNMFlkSFA1?=
 =?utf-8?B?WUV5MU9ldkxTdDR4SWxrbk9HaDE3VUQ3NkZCd2FrMGt3UkZJb0JYQ0tOSDdr?=
 =?utf-8?B?UUZ6REVNQWJuOUp4QjFuajFFTDNaa0R3TnRoWGZlRjBGOXpGdHBXc1RZcUhl?=
 =?utf-8?B?dnR1b3p6TzlpWkxGSzRrYzZ0akdGaUlDNXFrYnVTSlE0L1ZOOHpQOHh5VXRh?=
 =?utf-8?B?QTVYK3ROcnZ6S1lMRmpHR2FYbTdsdUdvakwvV2pUY2h5KzdBb0hzZXc4dlh6?=
 =?utf-8?B?T1JNQThNcDNMRGpOb0h3dmlaUS9rU3Y3eGdkYUJXKzBHazBFODIwdWNHSGhI?=
 =?utf-8?B?OU1FckkrNmYyMFhrdUJVQmxmMXNMenFoWjJ3ZnViQ2szY3NlMmV3MklmbGtz?=
 =?utf-8?B?UTF1VG4ydTRQbU9jU2RRY0xva1p0RXZaOFIxQm5Nb1lrUEJ6KzA5dGpMT1VE?=
 =?utf-8?B?ejlwSjIyN3JiWGpWOU4wY0JVbWxoVDRpWFQwWEp5Z3ltcTBWbTRjMXlYdTkz?=
 =?utf-8?B?R0pHNUl6d3JmQm45VDdvR09rQXZzcEhXL2xzbWVad0szaVJIbjdtT3hwSlZo?=
 =?utf-8?B?elZiRnMrMkpQbjdXMUc3UVFhQVdyK2wyN2hzdVhObEhwNjcxdmRyQXUyaWoy?=
 =?utf-8?Q?ESgrVfwCoKs6jtBluUEb2UL90?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F7B555574BCFF4D90D46D22332F3EC9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04196c56-3b7f-41b3-7e0b-08ddd5428c70
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 23:39:55.6759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZwdK/ZtF0VXnpB3W8UWx1ouUmvNGh83Kf04SW5VW9AQ9oVFb8K8CZjA1885LBDPtH4w4XEFHVajh1gMDtF5Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8039
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjExICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IEFkZCBhIGZsYWcgaW5kaWNhdGluZyB3aGVuZXZlciBFTkNMU1tFVVBEQVRFU1ZOXSBTR1gg
aW5zdHJ1Y3Rpb24NCj4gaXMgc3VwcG9ydGVkLiBUaGlzIHdpbGwgYmUgdXNlZCBieSBTR1ggZHJp
dmVyIHRvIHBlcmZvcm0gQ1BVDQo+IFNWTiB1cGRhdGVzLg0KDQpZb3UgbWF5IG5lZWQgdG8gcGF5
IGF0dGVudGlvbiB0byB0ZXh0IHdyYXAsIGFueXdheSAuLi4NCj4gDQo+IFJldmlld2VkLWJ5OiBE
YXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBFbGVuYSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQoNClJldmlld2Vk
LWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCg0K
