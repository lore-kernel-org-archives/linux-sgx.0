Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329AD1C1F05;
	Mon, 11 Aug 2025 10:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907815; cv=fail; b=OOodeWeHCocj5d9yNYv23gKv4gf/wkqRU75bt+6poyorH9zyyONjVuQMnMKXQ+d/biED+GNIVghEx0CGzZLs8ix0DL4vswM3pixeHYt3OstAdAdDoAAWaY2PUzglt951cMutqqmNW12vV2fhk0o3+8HKvcynFctEGNd2uSvtdnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907815; c=relaxed/simple;
	bh=YVDzstYOcbG/fXKR//XoWQl5GXMs+Y6tyOoRUllh0yI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=auArdBEocycdIb3n1kL99uxXgrADbYFAURduUUIzZeqR33qNGOB6gxSqU5Qf3B+FR3T95utWr3w199J7QWQJ0tDQWcEsYZa7cIrctZ6dggUwgJ5bTPFRlX77DV0CEQUbh3dr3QR2iiVWEp6dpcg/9fNAID9MFOFZgsXPkOzuX1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VCKzMmVA; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VCKzMmVA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754907815; x=1786443815;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YVDzstYOcbG/fXKR//XoWQl5GXMs+Y6tyOoRUllh0yI=;
  b=VCKzMmVAzFF7/jaOjSBXju56QzUbj+S8qHx/Lo+rSnk8UrkdB+/2yc/8
   +Hjp5WJ3PeVX4cyl6WOxg1tyrEpcgs1AC4YllqapzIAdOIoJeAZzcizBv
   UPhK3As9yNXZhsH8fW+WwqJ3t7BI/bWY2tPMhidAUIa7j/Dcc8gAlTeoY
   RvhvGVsItipcevtGWPOwsOqH1cY99/0tsp4EMyKobR+FtBU+0DkJDVcHM
   2B/PJdo+wOCvXFr+OhKKf6vYR8IjHsJvjGNExdDdprEdSeOu4XJ5Dp5Cg
   BCg3XxYkC/xeo6+R2e90x9fJgWoKYWwygfaepAj29oNDceyskFmcajW4s
   g==;
X-CSE-ConnectionGUID: XMfLtE+BTmqi4b1p38EKdg==
X-CSE-MsgGUID: 6+oSr3/NSUyEdrVOcF6jfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="68237039"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68237039"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 03:23:34 -0700
X-CSE-ConnectionGUID: 6SlkvY/ESfCKzkTmbt77Yg==
X-CSE-MsgGUID: u7Qzqen2Rhy3OnBcZ1uP6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="166675314"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 03:23:31 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 03:23:30 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 03:23:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.69)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 03:23:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YtzzSDDyClLDQKCJmMuYFozoz4g7p8HrnEhS8gXjqo4VTInb0CLCvzCJNnqQp/3zmyc7A5qTxLXyrFlwi91PyIsdJLoF070acJvD+KxSnO4SnjNvC1u2mQOiD4i5Lgq8u2eoRiLhxoRoaYz3EdOKeXdnqCPqQ5tN5yC4QiscBlMTlhJ+7VXpfQOzHYPfj9UdsVIyyWCg/o0KJcaVm5M0v5NgIYIA3JthXobL4lla7qzdvCc+7D+JsMCMfajPNurd+vofXqsA+9gdFUIyvzqiNiyQpI7YnOhHsW6fCLxW8GuWGryXS6LgrFUFmNwE54ARdtHnJqsnVWhJU+HUfopNCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVDzstYOcbG/fXKR//XoWQl5GXMs+Y6tyOoRUllh0yI=;
 b=AraLvmEFA6tXplODgXQ52UCX4QHp6NWhXhkfCgomqi6N7qk9m6k9+49QMtrvlFfVLomj5vOsMSuIoy928K4QwXuGv9gdEoWwv99gx4AP3MJz1Edw6ZipOcQr93/A56wHNRrq1z3m++rNNp3K70+q367sB7GxsO1e04SfQiF8JY+vyvFqE6Ayc/GRDwQBBiMtVZBZ3tdDHSiTsM4SIPaZUCZw9BBFVusD/USaQIyW2FCjwjNQC988mm3m2Pn2wV8mm0LXkSprxnq5CnvFcIojy2Sr7DWr44poGIoHQQ9C2rcLCsnRXzZM5MF+PAWIEiwLWkY8il0LBobBFWaKkGtYtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW4PR11MB6840.namprd11.prod.outlook.com (2603:10b6:303:222::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 10:23:27 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9009.021; Mon, 11 Aug 2025
 10:23:27 +0000
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
Subject: Re: [PATCH v12 1/5] x86/sgx: Introduce functions to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v12 1/5] x86/sgx: Introduce functions to count the
 sgx_(vepc_)open()
Thread-Index: AQHcCp+AXgL5KCk8IEC4/0r523dnr7RdPq+A
Date: Mon, 11 Aug 2025 10:23:27 +0000
Message-ID: <72d687ff28096fcf3c90b3b4783de902fbaa721a.camel@intel.com>
References: <20250811090751.683841-1-elena.reshetova@intel.com>
	 <20250811090751.683841-2-elena.reshetova@intel.com>
In-Reply-To: <20250811090751.683841-2-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW4PR11MB6840:EE_
x-ms-office365-filtering-correlation-id: 83755f1c-8392-4c38-4dc8-08ddd8c11c71
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cEJSb1AwMHdYQzRlS28rdDRkWUZKQ0Z4b081YmpVdDhtNWVsUk1lSjRmWTBQ?=
 =?utf-8?B?UFo5cFNiUDNHOTY1RzJUZ3pDUFlFMTJ0RmpwTks2TXljL2QzcVpjME1NZlYw?=
 =?utf-8?B?bWpJaWZZYkppY1c5WlBkdElRajZKUnZZSTlBUkJmNyt4Mnd0aEZXaStQUkJQ?=
 =?utf-8?B?ZERkNHhyTkl2NnpoNXhZQmNSTmFoenU4Rk1rU0JCWnorM0MvUjExV1U1cTMv?=
 =?utf-8?B?LzdiRUNRREJyS3o4M3FsRWxqam1NTXlKbXNDRWVEWVhFRXFrOGdUT1VQb2Vj?=
 =?utf-8?B?d2t5dnpyMXdRTnNIMGJiVnFXV1V5SWMwTm0zTzhMaEtGRm1uanZsK0hlSDZs?=
 =?utf-8?B?Tmh6bStXdUZ0cnhoZjNESnN1YUVRdXN3SVFLOFZ2VzVHMGl5UitQK09uV29o?=
 =?utf-8?B?eXJ0cHJyazEzbVIyeWIrYUZ5NWJEYWtMTlhhUkJlMm1YWFNLbk1LVzROZW5x?=
 =?utf-8?B?Vk9FVnFVWWZTTVlFMCtuZ3JyUENzdmR0NkdzUW84cHY5TzRFZ3JWMnJtaGFT?=
 =?utf-8?B?VDhVYUhpT3U4VytUa0M2c1lSdEdtS2xQVHZad0srT29qQjhIbW9CbGFDazk0?=
 =?utf-8?B?SnViUTVrUWJYTnE3dmZkVnZ6bUZzWjBYTDJkU2ROdXNyMjVRNndWdHpJSFFG?=
 =?utf-8?B?Z1hZbHZ3NERrQ29YWjF0ODFHbWNvd09KT0R5dndrbHpGaVh6dEV3MHVtVVZ3?=
 =?utf-8?B?U0g0MVdnTnVUekZjUnc3TU5rTlNlNThpQkljZDJRNUhzR3UwVmdsKzN3SmZa?=
 =?utf-8?B?SWRlWUh2NlBHeXBNRHZrM2hlVmMvcGZMUW8vMWJJVU0rVjhuYks0MEFhb1ln?=
 =?utf-8?B?NFF1cnNiK1pzRGdGMlBiZTBQanYzZ0lrMnJiQldBK1l0bDltZXgrVkxSbjlE?=
 =?utf-8?B?bkFHQ290ZE0reW5MUnVKZHdyRXdGQUV5VmQwQ3k1Yy9kbWVzUS9naGcrVXc1?=
 =?utf-8?B?NUp3RlZCVEpGSHpDQkpSNm1TaFFRdWNxWVNBcUUzVU5hVlo1emtIb0YvOCtm?=
 =?utf-8?B?Zmx4Wmc1OEdZMWRnZCtBYzU0OEg4YUJOdW1Pd2ozejIyNWdWWXlzbFJPaU1w?=
 =?utf-8?B?SlBQbDF1SG1HNU1hUnEzZUhzeXhBWEVKbUt6LzFneTgwSjN1OUIrclgxblRj?=
 =?utf-8?B?cnlzL1pBNW56ODZSNWRFaUhvSGlmeUQ1cmhFdFUwWFBFNWpjRFNpMVk1SStH?=
 =?utf-8?B?d1NpaVhmNTlmbXZiQXRWWDhBUml2UmI5V3U1Z2c5ZzVmd250VmRPSjdydER4?=
 =?utf-8?B?bmtHYTRCQ1lzMnNHa3NCeFh3MmcyUXlaMWM0VEdyNzA0Nyt3TVFNRzNpYnNx?=
 =?utf-8?B?K2VJNGo2Z1I4aTdvWURoZjFMaUx5UGJYV0puZi8zRjlwL1d6bjc4T2w1MndY?=
 =?utf-8?B?RmFkK2cxV2NpUWx3d01EY1BYRjAzcFQ4TXpaU2xvMVlrbHRwZXZGN2J3blJY?=
 =?utf-8?B?RXRVMFJVYVpxMFVpdmhTSXJwT01xVENxZXVadnREcmJuMzZyakZmUWJTcng1?=
 =?utf-8?B?b3h2cXZvQ1hSclRmU3FveTNzSEFIUVEyL3BLcm5kVUd2ZFNCY05ucDBETWRx?=
 =?utf-8?B?Vkh1cXVwTXhrMlVGTDQrYzRxSHBRWWNTM1UwYTg5ZzV0dThHM044UnY0ZjNs?=
 =?utf-8?B?cms2VEV5S2RVMURZWFFqMERFNDg4SjlhZTl0VWhxUHh4dmhuUFA1aDA0QjJw?=
 =?utf-8?B?U3VtK2YyRzdPamJZa2xyc0c3dUR5YkJpVkgwU25aM3pYZzFBUExJbGdkOGhn?=
 =?utf-8?B?YlRmeGlSc256aXdkZDB3RENEdnNVUUJlUkg3SkhDU3p2RXY2dStIdDFyd3FG?=
 =?utf-8?B?NFRmUmRRMnNYeVV5Q0Z5SlpRQmdicHZrNmVnNGkrUTRPclZ5V0NvM0dGNWRH?=
 =?utf-8?B?UDZhOWdOaWNMdkpDcVJZZUgrR2ZGVGdPeTA4aWNLSFpxUE5lSFB1eEdDQjVY?=
 =?utf-8?B?YmdBTTVydGZpWmx2SGNIZXE4bUlUalFVSE53ZCt4UmtTUnRnOFF6RkZzb09s?=
 =?utf-8?Q?s6RVFd9kK1j0bNggbKy1SFr15+etpE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZS9qcDI2UnI5SUdKaTdHSWxwV3dOc3Jjc1JUVlZ6TkZHb1NkWjNSeUl3Q3c5?=
 =?utf-8?B?alFTM0VveFhTNmRGYzBNR3dHaDVnNDJRekhENGV1TWVwak5pOUVGYXdmUWNF?=
 =?utf-8?B?Snd2alM5UnFKdXYyVS8rRFVBcFBpUW9MQkVCRnFpc1RYUWhyMHJuZUVQenpy?=
 =?utf-8?B?aVZMZUgveWRpVTNnSHg2OFFRa0NjZmNwelJmeHBLRGYxVWdGN0VrVDc5emFs?=
 =?utf-8?B?MHh3ZjNIcFNsM2dVaUZ3QW5PeW1hVDYyQ1pFQnByeDVud3EyaGlPeTdNSHAw?=
 =?utf-8?B?OVNudlZHclhhS2tKTTgwVUNValhjMGNoMEV5V1E5SmhUak4xR3BEaG12RE55?=
 =?utf-8?B?MUZzbGJWbmdRRkNFWDQxcVBiaGxWWWp6QkdnN1Z3Z3ZTNzJjRDcxYitNeVVY?=
 =?utf-8?B?eUZONlZnaVpvdC9VUlo1QTMycVNCVEQwSWJxam5JMFJTNVduODZEcm5seUQz?=
 =?utf-8?B?WVRxcXBLMnYyQjhtZHpUWDFCYkhJRkF0aDVXWW5Qd2laOWdmcmhJV1Z5MGdP?=
 =?utf-8?B?Z2hTMnpSTkJLNTlTeTI2WUZaMVNCYUpVSHlXQlo5anExOWhkNXBVUCtyUGJC?=
 =?utf-8?B?ZnQyT00zWlVQV0hhWE9oWEZhUkFqNGFnQSs5cnBzcW1qT0FyY1IrdjZkZUsv?=
 =?utf-8?B?TmVqQjU3a3lTaHhQMjBaUEFiZWE3TWs3d0RJYURIRDBsTlZhQWJJVDFKWGJU?=
 =?utf-8?B?b2IrYUl3bG1OZmpWRmM1WEttbFBDRFZ6NEtCSVZpUFZiWFd3ai9lZkYwTmJB?=
 =?utf-8?B?UFJrcjZhYzdwOEIwZm03SVplcDVSckZqS1VkR2pUTUtpMFVHb2xvQ0RHNllk?=
 =?utf-8?B?Szh3a0FuTjNYVG9pbVJmWDNSbGM2WmE3VXpRdjFuSHlaMERlU0lrQVhPYU0x?=
 =?utf-8?B?Nnl5OTBseG1JSTUwNmRHUEZPUDlZSm9EWDBMa2lBRW1CekllRlhZRFo3a0tp?=
 =?utf-8?B?OGY3M3FJZEUwNXdnd054Q3NDQ08yM28rdG1LeUtzdlVoeldZVEVjSnJqdGZB?=
 =?utf-8?B?b3d1am9la3p0bk1vSUE1YVVPalpBbEpLNFFEVTZibS9ZRGVIVFdHNG0xMnVi?=
 =?utf-8?B?WjQ3NWVUUWxoMnppdDU2V056ZXA4UEQ2QTNGYUdJSHc5OElKOGh0aks2bTZo?=
 =?utf-8?B?MVhHSjBLVCs1SjlXcVJuVVhqL3huajNmMG4yRGlmMVlqdldvZkxPTkRDZ1Ay?=
 =?utf-8?B?ZHN2Wk1ta3RGZWxTSjF6NUl6MmNjVXh1emd0UTZtbTN2UEZwdmRXSEZad21o?=
 =?utf-8?B?VnFIY0R4Vis3THJiMWwrTzNTRmRObFpFUVF1Z2tnOWpna1c4THZUN3RDd0xu?=
 =?utf-8?B?SStFeU13VkJ3dG9Md0VEK3NhcHJtWFRzNjEyZnkzN0Q4RHUvTTZXZW5uUlN2?=
 =?utf-8?B?TVlXeklTNUgzZWp1TldsV1RJYjRlSFRWYVVLMEY1LzgwTnZ2c2dJRUtqTW96?=
 =?utf-8?B?YlFkMFlDWkVSbFNBVFYwYm1ZZ1F2cVdYWFMrSXhwRG9uWE5wQ2crbjVFeHdP?=
 =?utf-8?B?T0FuTE1wdHBUUTd3TlQwMTlHL3ZzYmRacWNmdStqVU5HajRoZW1RYUpNRjY4?=
 =?utf-8?B?dUovYlpHTzRXcldJMFNNRkxSd2dubXlLcEozV3hPWEFZNkdraHNKelIycmZx?=
 =?utf-8?B?S3k1NW8xRGdsWXhITXN3RjloNFhTdjI1UFhQRU9VOUNXVm5naEt4MSt4RytW?=
 =?utf-8?B?bm0zWHZSWDc3em51NVdXVm9taTZIRS9ZV0c2Znd1a2pZeHBkOEpyMnBYUjQy?=
 =?utf-8?B?UU85MnAxVk9QOFdCUng5eEpraUFmR2xGTlh4Z1ZrNXRHVGFYbk1XTHZRVWxC?=
 =?utf-8?B?bnh2N1gyNEZCdVBnOFo1VHVncEl2TGgyb1VtVGJwMmJRMnlWTGtLSWN1bjVk?=
 =?utf-8?B?OFk3bFROZWZWMk9UaWpIRndzSjVoa1lqQU1ZZkhBSHppUFl3RW5ubkpkb1Rx?=
 =?utf-8?B?Z09yKzNFaDVJa0YvTlpraW85dFRHZTdmNmxMR2V4WEtLMlUrRXZ3U0tyaWNi?=
 =?utf-8?B?azJJQVRma21wNnkxZHV0SlhBdEhhRzFET01iQXhFYkJxWGc3b0ZiRlVGZys4?=
 =?utf-8?B?Vng0NXFkeTVIMjhXWmlKZTJabmlPeHdDbDdsMTJnZURKcEptMTkxN2w2WHI2?=
 =?utf-8?Q?2WYk6kVG8+gKWVphYwqu6PRYH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <889CD11B6EAD314DACCEA11BB06EF50A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83755f1c-8392-4c38-4dc8-08ddd8c11c71
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 10:23:27.3749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: etDgKhgXtEdVjbuatFNSAxpUHRezKb7hIQiC3Iq48To0Z3Sh5nKcU6jd56IVclahFY60XuXFdeMUxHqT/03Hlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6840
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA4LTExIGF0IDEyOjA2ICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IEN1cnJlbnRseSwgd2hlbiBTR1ggaXMgY29tcHJvbWlzZWQgYW5kIHRoZSBtaWNyb2NvZGUg
dXBkYXRlIGZpeCBpcyBhcHBsaWVkLA0KPiB0aGUgbWFjaGluZSBuZWVkcyB0byBiZSByZWJvb3Rl
ZCB0byBpbnZhbGlkYXRlIG9sZCBTR1ggY3J5cHRvLWFzc2V0cyBhbmQNCj4gbWFrZSBTR1ggYmUg
aW4gYW4gdXBkYXRlZCBzYWZlIHN0YXRlLiBJdCdzIG5vdCBmcmllbmRseSBmb3IgdGhlIGNsb3Vk
Lg0KPiANCj4gVG8gYXZvaWQgaGF2aW5nIHRvIHJlYm9vdCwgYSBuZXcgRU5DTFNbRVVQREFURVNW
Tl0gaXMgaW50cm9kdWNlZCB0byB1cGRhdGUNCj4gU0dYIGVudmlyb25tZW50IGF0IHJ1bnRpbWUu
IFRoaXMgcHJvY2VzcyBuZWVkcyB0byBiZSBkb25lIHdoZW4gdGhlcmUncyBubw0KPiBTR1ggdXNl
cnMgdG8gbWFrZSBzdXJlIG5vIGNvbXByb21pc2VkIGVuY2xhdmVzIGNhbiBzdXJ2aXZlIGZyb20g
dGhlIHVwZGF0ZQ0KPiBhbmQgYWxsb3cgdGhlIHN5c3RlbSB0byByZWdlbmVyYXRlIGNyeXB0by1h
c3NldHMuDQo+IA0KPiBGb3Igbm93IHRoZXJlJ3Mgbm8gY291bnRlciB0byB0cmFjayB0aGUgYWN0
aXZlIFNHWCB1c2VycyBvZiBob3N0IGVuY2xhdmUNCj4gYW5kIHZpcnR1YWwgRVBDLiBJbnRyb2R1
Y2Ugc3VjaCBjb3VudGVyIG1lY2hhbmlzbSBzbyB0aGF0IHRoZSBFVVBEQVRFU1ZODQo+IGNhbiBi
ZSBkb25lIG9ubHkgd2hlbiB0aGVyZSdzIG5vIFNHWCB1c2Vycy4NCj4gDQo+IERlZmluZSBwbGFj
ZWhvbGRlciBmdW5jdGlvbnMgc2d4X2luYy9kZWNfdXNhZ2VfY291bnQoKSB0aGF0IGFyZSB1c2Vk
IHRvDQo+IGluY3JlbWVudCBhbmQgZGVjcmVtZW50IHN1Y2ggYSBjb3VudGVyLiBBbHNvLCB3aXJl
IHRoZSBjYWxsIHNpdGVzIGZvcg0KPiB0aGVzZSBmdW5jdGlvbnMuIEVuY2Fwc3VsYXRlIHRoZSBj
dXJyZW50IHNneF8odmVwY18pb3BlbigpIHRvDQo+IF9fc2d4Xyh2ZXBjXylvcGVuKCkgdG8gbWFr
ZSB0aGUgbmV3IHNneF8odmVwY18pb3BlbigpIGVhc3kgdG8gcmVhZC4NCj4gDQo+IFRoZSBkZWZp
bml0aW9uIG9mIHRoZSBjb3VudGVyIGl0c2VsZiBhbmQgdGhlIGFjdHVhbCBpbXBsZW1lbnRhdGlv
biBvZg0KPiBzZ3hfaW5jL2RlY191c2FnZV9jb3VudCgpIGZ1bmN0aW9ucyBjb21lIG5leHQuDQo+
IA0KPiBOb3RlOiBUaGUgRVVQREFURVNWTiwgd2hpY2ggbWF5IGZhaWwsIHdpbGwgYmUgZG9uZSBp
bg0KPiBzZ3hfaW5jX3VzYWdlX2NvdW50KCkuIE1ha2UgaXQgcmV0dXJuICdpbnQnIHRvIG1ha2Ug
c3Vic2VxdWVudCBwYXRjaGVzDQo+IHdoaWNoIGltcGxlbWVudCBFVVBEQVRFU1ZOIGVhc2llciB0
byByZXZpZXcuIEZvciBub3cgaXQgYWx3YXlzIHJldHVybnMNCj4gc3VjY2Vzcy4NCj4gDQo+IFN1
Z2dlc3RlZC1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IFJl
dmlld2VkLWJ5OiBKYXJra28gU2Fra2luZW4gPGphcmtrb0BrZXJuZWwub3JnPg0KPiBTaWduZWQt
b2ZmLWJ5OiBFbGVuYSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQoNClJl
dmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=
