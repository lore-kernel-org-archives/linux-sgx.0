Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F659B67A;
	Mon, 19 May 2025 10:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747652274; cv=fail; b=X0atL0Kmg1zmCfPwhJTNrvHHmzt3mIONGR9DwtwPYOshUoVMxNdEoNQyztlctL9mjL2K1zU/K9q5VWIkgCSRuUvhhkMpgCWB4LrQ9oi7WMNs9ehFqYCXvR/OoMI9XWB4ZZrPkSnE0agfBkyrGQKtekoae1rBrQ1FpqGyTfNGp+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747652274; c=relaxed/simple;
	bh=ElXCjv6bARncBiPPR5dfPoJbIXPqvPXFD7IwVWCdfHY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZcTpQ6jLN/YE/P6Ziowv67A5+3zJyTBpJoMU1pyBxpVgSOhBYCMj31IuZxBB5IHl99h7l9kR4IcerQ37nAVhxoBvTV/m2MUFKa/xcuKCL9YJHTX/018FFpduLmSGFe5Lr7QxQ+uXZY5DD2Dya2Pfq9QIWdf1IalrGgq/Vb7wFWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lWS082C7; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lWS082C7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747652272; x=1779188272;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ElXCjv6bARncBiPPR5dfPoJbIXPqvPXFD7IwVWCdfHY=;
  b=lWS082C7Yrahdt0LvDwQRR1TEhBJB8oIFn9oYr0n3PF/fgngqodzprVZ
   6cQU2x92hdUArbX6rxlg7mN27O7VxLAX0PSDbdWkFpIK3+HLf6SsM/GC7
   n0cndE52p1o+Lw/XfiHVCPOyMQfl7EEaDrlH1vlsHM499YgYt5BVypaII
   N66ZI/sK7fqEujIzvVPvXalummDWGQU8wzd31KRfrnH81ez2qufvqOwa7
   Uo1wPvFn/KYXTb4ffcS9w2qo3JXpshh+NOgt6g2Bd693wZrwHv+GSen5b
   z9W0F72age/NDRN1izUtW6otlbATHo8iRtVW8EFwRVCPfHVFwcxxm2oHA
   A==;
X-CSE-ConnectionGUID: JhI0OehBRGaECxmWNFEvsw==
X-CSE-MsgGUID: E4kbjS2pR0C046nKQyq5wQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="59776449"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="59776449"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 03:57:52 -0700
X-CSE-ConnectionGUID: J4xDbHkOROOjkoQT9k8UdQ==
X-CSE-MsgGUID: 8OZ7YPM/Rh6KNWJWPJkPrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139079444"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 03:57:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 03:57:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 03:57:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 03:57:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yUHbA3r/SmhA5TI8Izcs7x/2wGyNlch+1O9XCdZeMqLi/DKs9kV9YLlHev08c/tJlNC0+P2U9hcBGzXiz4UGWDVcbF3DK8XYNhiMYg4+SV7+PLtt5sFCi/sj5AVVHuo13PR7DFQKo7GLFnHF2q6BRzmF3MV1YJNYVuDRIu5I/3V+SpGMLbPpaXY9NtZLpojx4aTwBThxTnTX70KM4dt4SqYxjY59ujrJENCL43LWpUXPE5/LvzAJBxOW4L9Xn/goNDX0LYO940GID5cYJTaWQPN6KvGzg28t7r2iPPEpTEtV2Rl2x0jAXegXEUiaSCDkjHiD+nodxqtcgXcOpAUg4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElXCjv6bARncBiPPR5dfPoJbIXPqvPXFD7IwVWCdfHY=;
 b=EJPhMRjltYFaCZP1dnm8N91dCceZJaOssOpbPY3UCqnHKrhKgJmloyAzq9zM9PR4gojo5NsUhp5gV3z5nG2RDICuXjbBkGCUyB0Aiu6uaenmXKYImo88HJ2ALkKkZKRN4oBLPGyAhGZ1gKCqBqMQuxY1oj5iNjiCfDrTCt1lyncNpSqnY2XzsQiRxE2eKKirjYae2LSAuyU5cVFG/IZbAf2J4az44SQARMpcx7rUALgSiu2naO32QQx5HtX7vosFr2QRSWrKyB/TNSQKhWL3mAY/bWQkY537ZFR/jH7P6eDUGsCV5xd8il3beJ08qSytMeq8GXW3xExGEmSHBz7Wmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH3PR11MB7894.namprd11.prod.outlook.com (2603:10b6:610:12c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 10:57:49 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%3]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 10:57:49 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: Re: [PATCH v5 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v5 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Index: AQHbyI9k5V1wyfbKYkeoYjGeCi4KwLPZyJSA
Date: Mon, 19 May 2025 10:57:49 +0000
Message-ID: <b6f3e810d75fc79b4bb1612ce1cd9da4b60a0e1d.camel@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
	 <20250519072603.328429-4-elena.reshetova@intel.com>
In-Reply-To: <20250519072603.328429-4-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH3PR11MB7894:EE_
x-ms-office365-filtering-correlation-id: a55a6814-0741-4cb5-586b-08dd96c3feca
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aTE0SEpyakxmT0tKMG9BdXQzN1E4dlhmem42QXVRZ0xKYUhlbnAxdDR3cHcv?=
 =?utf-8?B?YnhjNUYreWQ4Ym5WMlNLR1I0RXk4dXZyaTFOQUtHdk1QUnp4bG1RYkpvTUli?=
 =?utf-8?B?bG5lQzV1Mm0zNFFLYVozeXExbURrMEI0WjNLeGh1MUFtY0NZSWtlRDFaeTBP?=
 =?utf-8?B?bXpFZGxPaG9hTGsvNFo3ZVpHeFZ0dWVGYzRBR0NCbGk3WXRxWGNGVEFnYU4w?=
 =?utf-8?B?UHFlRUZxTnk1aklJNDMySTlYRmJBWVQ2Q1NRTGR4RDNiVG03cDJHQXFKMnZO?=
 =?utf-8?B?aEVnZy9tQ3ZxRmJEOEdVNlpsOVpxd0FuZGYrRDJXZ0xPVldvakZnZEJOZnBI?=
 =?utf-8?B?SC80ZFFlSC96Smc3cEZNVXhwaHJPcFB5TW4vN21uL3R5QVFMQTY5WC9uY3V5?=
 =?utf-8?B?cWxOaUNJQmZKaVhWdHBoQzhBcjJMam9rYTNOWWFOS2F4Nk9MYklKL08xM1E1?=
 =?utf-8?B?YWQ1cXZqaWZoMC9pc0hHZjlxZXZDWHNIUDZ2SWtKSmQ3di9Sa3NqNTZmelNZ?=
 =?utf-8?B?WTAyY1hySDFPaENBNmU4L3lxTGR4NUxScmlYK0NteE1ZZm5Ram1nVkdlNmdL?=
 =?utf-8?B?MTd0TUk3SmRlK2xzeHlaVTMxZWg5Z3JjVnJiRGNnd2JhTWs3N1BQNTRyVW1I?=
 =?utf-8?B?L3crTUxUeUkrMmVycXhHWFZYK0FVamNuYXl3dm1pNisxTHc5cUhjaVNEOC8v?=
 =?utf-8?B?SEJtdk1XZ3orRXZmQnY0R2RlbUMzUUlvVkR6cDJpMzF5N05lZ1lFaW9lSXk0?=
 =?utf-8?B?RGZtbjZ2Q2Z0OUpOYkFmVGJHZC9qVElYWXZ5Q3grdGkrV0JyK3hZL0E0QXdx?=
 =?utf-8?B?bzlsNXVBOVZFUHRSL3M3bzJpa3FnTHBXclFUUWVRQ0JiVTBSMEs5SWhQYzF2?=
 =?utf-8?B?Vi8zTGh4OWZDTkNoYzJ3VEpUaVNGclg0WmJhd1JIMWRuRGxrVStMbFlKYnRq?=
 =?utf-8?B?UytFcGh4NXptTW5DbU0yVGM4K2piMzZqamk5c2hKQ3Iwd2FnNzdNa0szckI1?=
 =?utf-8?B?T2hHUWJlL2ltZk5qWjN2Z2c3TGwwRFdrdForZnB2WEhCTTJJNnVwTzQ3MndI?=
 =?utf-8?B?YmRhS3ltK2hUQjZrbWV2K1pDaVVOejY4ZmNWQi9xaGpBamJJdFEyMThjc1Iw?=
 =?utf-8?B?amRnc2MyM1MzblpYZm5yM2JUTXpSUXFXRzY2c1pQb1lGb1ptWmZDb1VuSUZn?=
 =?utf-8?B?TWE1cjhxVE1qVlFBV1RnSUFVUEJKN1gzMGtCa1U1bVduQTZ2NHQ5bWpnMXFF?=
 =?utf-8?B?d0tTcE1tSk53eFFTaGIveFlIQ3drby85UDZoVi9MSGM3QmhXSUxzRE1qZ3Ix?=
 =?utf-8?B?QmtUSDJYYTBBK0Z6RUxYd2piQ3hpVVdWaFVvRFV4QVNNYnlwNDYyT3RvaFIz?=
 =?utf-8?B?ZkloS2paalpoVVJHdXpSVEd1a05sZFZjQmFJMit2VXdGOFVHTmo1dGFnVmlO?=
 =?utf-8?B?QTdSc2RzS3Q4NGhJbFRpbTRVQ25icE9IV3NHV2wwSUs5MzZzS3hVSEplbldn?=
 =?utf-8?B?MUpqTnpEdS91U0dLR3p6dEhWdWk3Rkl3ZXY4Z1M3NGEwQXdHbURsbldqczJW?=
 =?utf-8?B?dW9aSlo1a2FSUmx0TDlKbjdSeENlZ0tLNGswRUgwdTQ1a1J5UjN4TEFQWmto?=
 =?utf-8?B?NUVONm8waU96eWlVdE52eG1xZURGaXI3TjFtdjhXUE1iOXRkUVBKOVl3TmhN?=
 =?utf-8?B?YjlJRzQvWDlqSVlXL1l0bmdpdUpocEg4RXJ6R1BHYXFFVEppdEN6UVlQZlhI?=
 =?utf-8?B?VlByYVdoZit4SmtpMFRwWlhINlV2ZStyUlZ6cjdUR1IybG8valVMWml4VTBE?=
 =?utf-8?B?dENKVXZtSW9DS3l2WU1UK3Qwc21jbkU1LzBFYnVBMFp3THN0bTVxa2Z1bHVH?=
 =?utf-8?B?TW4rWnFBbnNzZkthOFhHOHFRVG9zRlAwWThXVVU4dUQwNFpLOE1BeldUVVFJ?=
 =?utf-8?B?MnFWT3k1Nmg3c1BKR3JOUnlpTjdITE1yR2s4RmFlN3RHMDRiNUFuWk9GYXBI?=
 =?utf-8?B?YlN1VkJldjBBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emJjajNsNDFRcFkwckU2SU9oQWtNVldGdGM5Y0h1YXdsbWxHdjFlbXhMNlhU?=
 =?utf-8?B?SVNJbTFRYXFVdy9OTmdjZDBBQVlmbUw0dEhEdmJ1Z2ZvZWZPVFhBMlNYWmlq?=
 =?utf-8?B?cm0wVU5FSDcrWk5iNW9sazFiQXNsWGo1VXh3MUY1eitjb3ZpYWlzaGtKR1dB?=
 =?utf-8?B?QktHWE5SR2E1MEE3cy9vZXIrOWpWTk9UYmo4WCtEdmpVRTJUNEZtaHdyeCtQ?=
 =?utf-8?B?aFkzdkV2SURPMVk2cW5KQmRqbkZONDVTMmNpUFhwQzVYOXZzZEVMK3lEcXJR?=
 =?utf-8?B?THlTZlpQaUdITXBKdml1T2swdERsQlI1NTQwNGt1ei9EUU80MSthSHgwQ01h?=
 =?utf-8?B?cEJkVmtqemZpdWZ3NVlLeXMrK3lkRzNRYldkb3FMMG9LcWpWY1lhbmdtaTQ1?=
 =?utf-8?B?K0xDT2s3VWg0RDNVOUNvK0psQmw5cldIdVBZQU5wbVJ5MW5oQWs4QTRkMENq?=
 =?utf-8?B?aThqRnRsT2lQVXNySkR5NTIwazA0WU4xdTlsckVybk5aZnA3WkV2S29KL3Vk?=
 =?utf-8?B?QUF1YlB0dEdyN0RXTDlBRUs3MjFPYnJSTmY0UnZlYlVsa2YvWGgrT3Jjb3hI?=
 =?utf-8?B?YUNYdThraXRlalZBZk1OTVZvSzFYOW8ydnVmVkJVTTF1QUU2TmsyeWw5dldm?=
 =?utf-8?B?UnBBWVFBUEtBOWc3TTNQSGl1MC9zdTFrYXcyT1UvdW4ydStRVi9pbnRpdk8r?=
 =?utf-8?B?YnJjeTZpM2dsa0p6cXFDWFJUN2xTWVVJVDQ0a3A1ZmdVTDgwYVRxWEF2OU9r?=
 =?utf-8?B?M0RvUkN2QXptV2M3b1dSeU9WZ3dsVG0wdHVubE41bmtDcENERDBvQzVWc1NE?=
 =?utf-8?B?NlVRcFFJRnNMK2g5QXhTb1hoUVZvekpLTUp1Y3c1TEpNajRhWGJsdEFaMzJr?=
 =?utf-8?B?WStFMTZ6ZE1PbDlVUFN0azJnbE9lZlV0SVptZzBGSmx3S2sralFMUlRhaTd6?=
 =?utf-8?B?LzF4N29tL0R6dFkzYjlkTUo4OWV1bFZMVFFZTGRYQ3YveVE3Z3ZvVFFmZmMr?=
 =?utf-8?B?QkxZUmt6Sk0vejk3ZUJPOEEzckFSRG9uV0hpdWw4TDE2TW1xQjNRaWRHNW4z?=
 =?utf-8?B?WDQ0NTl1TW52K1h0UGQwMjM4MTQ2R3V0NmE1TzRGVENkSUpLeTJ4ZENTK3FV?=
 =?utf-8?B?TUwxcE91WlkzMDZCTWhyWGNpWDZJRFA0UnE3QU1WOEtQTzkrTXBKMnJiSmdZ?=
 =?utf-8?B?SHRxTGFzWU9ybmxrWUZZZWk2akE1WFQrc05LTVB0RnRTdVZUZXExUHMzQkF0?=
 =?utf-8?B?SWpaR29BSStLVWlaV1Z6aGRqb2ZraDFDTURYZ2RlSGRXVHM2R1lFYkNiTTVo?=
 =?utf-8?B?VE9aZGVDc3lVa0U1eUs4Q2lYQ1hYNFVPbmhKODh0dnpJT04rRzFmSnFOR1o1?=
 =?utf-8?B?Sk9jcENOUElXb3J1NDlNak51dGxuWnJxVFNBOHdqTEJBMGFOTUpieGRibElq?=
 =?utf-8?B?SHhUQ2c3WUhmYWdEQnZ6UFVvT211Zlc3T2tTcWQ5c1ROdEg2M2kxM094RVc2?=
 =?utf-8?B?d1Q0Rnd0Y210SlZrWjl4RXZvcDdITVVuQ1krWm1VV3RkcFUxRGlSNXBBOUM2?=
 =?utf-8?B?TFpmZ0lvY3UzdmNOaE90Q0tJRUNZN0Jma3VaaTVjbEJWNS9yd2N2eHhVS0lP?=
 =?utf-8?B?VDZuNzJkSDVZZGNRd1hpdVczWmpWWmsva1F1TEVMV2FFejF3bGh3YmJ3bTdN?=
 =?utf-8?B?bGZSNDFzVE1paUdqLy8wWnZMd2RYYjlXeEI0bmNDaDQ2MUkyUEw2QTBkSnVl?=
 =?utf-8?B?NXVEQ1NydFU5c1U0eGEySThIZkpXalVpMDNqam15aW4vT3psR203cVo4SHZI?=
 =?utf-8?B?Z29rUGxvMWVmeGc4bUpLbDFmWVBKck12dXBoUVl4M0pnd01BQkJlYk91MFl4?=
 =?utf-8?B?M2t0K3F1Tmg3TkZRc05wbVlQYnNtU3pPR2hDTmZVanhaWmM3TW1JeVNSc21p?=
 =?utf-8?B?L29mdFBoS1phVDdhRTNzcWFIWmJNV0k3Tng0QnkrSzVWUCtXSVo5MVhFUGdh?=
 =?utf-8?B?M25oS09hSFpDbjRDcFpoaHJQaVpqMmg1dGg3bHFodVdQWjMxNHpoUS84NUJu?=
 =?utf-8?B?dVJxYmE4V1pLT1k3UE9JT3pGY3NxK25xaTdaWFB1RHhVSm11QTlRd05haDdK?=
 =?utf-8?Q?eZrWpeHpokVxBMUTVS96Ex2is?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <271D765EB85E62439F89430B5A1FF4FB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a55a6814-0741-4cb5-586b-08dd96c3feca
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 10:57:49.3434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uvMa09Yq1It4CqYpK1jKKP2bjJ/5u3qNEi6/ZBqAr/iA+EkfpSFAtc/meomhgUQSk3oEm6W0mGqoNrqCgrEv9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7894
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDEwOjI0ICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IEFkZCBlcnJvciBjb2RlcyBmb3IgRU5DTFNbRVVQREFURVNWTl0sIHRoZW4gU0dYIENQVVNW
TiB1cGRhdGUNCj4gcHJvY2VzcyBjYW4ga25vdyB0aGUgZXhlY3V0aW9uIHN0YXRlIG9mIEVVUERB
VEVTVk4gYW5kIG5vdGlmeQ0KPiB1c2Vyc3BhY2UuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBFbGVu
YSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQo+IC0tLQ0KDQpbLi4uXQ0K
DQo+IA0KPiAgLyoqDQo+IEBAIC03Myw2ICs3NCwxMSBAQCBlbnVtIHNneF9lbmNsc19mdW5jdGlv
biB7DQo+ICAgKgkJCQlwdWJsaWMga2V5IGRvZXMgbm90IG1hdGNoIElBMzJfU0dYTEVQVUJLRVlI
QVNILg0KPiAgICogJVNHWF9QQUdFX05PVF9NT0RJRklBQkxFOglUaGUgRVBDIHBhZ2UgY2Fubm90
IGJlIG1vZGlmaWVkIGJlY2F1c2UgaXQNCj4gICAqCQkJCWlzIGluIHRoZSBQRU5ESU5HIG9yIE1P
RElGSUVEIHN0YXRlLg0KPiArICogJVNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWToJSW5zdWZmaWNp
ZW50IGVudHJvcHkgaW4gUk5HLg0KPiArICogJVNHWF9FUENfTk9UX1JFQURZOgkJCUVQQyBpcyBu
b3QgcmVhZHkgZm9yIFNWTiB1cGRhdGUuDQo+ICsgKiAlU0dYX05PX1VQREFURToJCUVVUERBVEVT
Vk4gd2FzIHN1Y2Nlc3NmdWwsIGJ1dCBDUFVTVk4gd2FzIG5vdA0KPiArICoJCQkJdXBkYXRlZCBi
ZWNhdXNlIGN1cnJlbnQgU1ZOIHdhcyBub3QgbmV3ZXIgdGhhbg0KPiArICoJCQkJQ1BVU1ZOLg0K
PiAgICogJVNHWF9VTk1BU0tFRF9FVkVOVDoJCUFuIHVubWFza2VkIGV2ZW50LCBlLmcuIElOVFIs
IHdhcyByZWNlaXZlZA0KPiAgICovDQo+ICBlbnVtIHNneF9yZXR1cm5fY29kZSB7DQo+IEBAIC04
MSw2ICs4Nyw5IEBAIGVudW0gc2d4X3JldHVybl9jb2RlIHsNCj4gIAlTR1hfQ0hJTERfUFJFU0VO
VAkJPSAxMywNCj4gIAlTR1hfSU5WQUxJRF9FSU5JVFRPS0VOCQk9IDE2LA0KPiAgCVNHWF9QQUdF
X05PVF9NT0RJRklBQkxFCQk9IDIwLA0KPiArCVNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWQk9IDI5
LA0KPiArCVNHWF9FUENfTk9UX1JFQURZCQkJPSAzMCwNCj4gKwlTR1hfTk9fVVBEQVRFCQkJCT0g
MzEsDQo+ICAJU0dYX1VOTUFTS0VEX0VWRU5UCQk9IDEyOCwNCj4gIH07DQo+ICANCg0KSXQgZG9l
c24ndCBzZWVtIFNHWF9FUENfTk9UX1JFQURZIGlzIHVzZWQgaW4gdGhpcyBzZXJpZXMuDQo=
