Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25FC1D8E01;
	Tue, 14 Jul 2026 00:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783988685; cv=fail; b=WfXAmvrEdmdFG2pzYcv2GfiKn+ERS8uT7b+HrP1uxsGWQdYUxLDulUd1tX2DyZEhOHYUb2FYwezX/E1ZLoriABLRJlrcD0X6vfStW+fWsQGaEliNueclUQO6UwI5uAxOT/+Bt8Nj5PV5V+07Lg1dUkstGBXkrilrs1H83d+XemY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783988685; c=relaxed/simple;
	bh=Sn8aZ8wj067iP6U9k2LIOCUqs79eCba5uhkbTkw6MqE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uXzVS9HpHpkJNomn5o6TIGK/05Czwmc/YDLuGHyI3EESmMAxKANvERmB8l934aFVcbsS4DaalYpPPGIA/2awjA0U52P3+Ti55rmVGkzl+R9pgjgMZN9yiJH9WqEOV5OQoq2MvwR4I8wrzs+6clJi8O55F3Fygpc8R7bCyCPVIgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q/EyCnRE; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q/EyCnRE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783988684; x=1815524684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Sn8aZ8wj067iP6U9k2LIOCUqs79eCba5uhkbTkw6MqE=;
  b=Q/EyCnREjXIVmqVMuV0VxC4sfMUep2YtVqhYDIKciA3ymevv3jp4M8Or
   hdVLqKebKqnuPxllI+ObGVHfprju6deznUKcMk24S7XwwJMKfnI4wb7NZ
   XGaXBlJJnvI8iP44fT2Wnhu8YisINVxNEbZ9j2XiWz9lT4QIxqc0CjCxi
   gfipmyqQlX5k73uWgv0vsDvzyzweN01vVLTI2khlcOu36pwlr342y0X9X
   jb++LKBpD4MrLJx0CtgR0FV6ND29ewToyWqbeOEN39dXQ4QAmKAxJgpsy
   ABXzG1JDVbQF3pAfz00Zd0YP2gCehmIPQQT0bobtRZHBjW8BycFi1lNns
   Q==;
X-CSE-ConnectionGUID: qyYaCl//Se+y7O003YvoLA==
X-CSE-MsgGUID: /WG4peywTM2lXXFE6BPtLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84460697"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84460697"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 17:24:43 -0700
X-CSE-ConnectionGUID: ephPinRGRRGaavs/5WZf0g==
X-CSE-MsgGUID: DHokn8MUTPuHbSF0ErHpEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="251751655"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 17:24:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 17:24:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 13 Jul 2026 17:24:42 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.14) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 17:24:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BNAE16gwbdJP0R6tJTp62BPZ2BomFp2vc6cGGxxsNCPG1y9zChFp91p9SnSEVygYKWIbIqe5EtgvEtCzBNsTf6ySfEVL6JKzhbiEu15gETjnow7/msUjDG+Wt4RIblyKUnYbTaOmWXYLkYZvBDzNZ2JiHDKgkFjL8GgmRkO3lhvXemKCW1Dk/9JAdQhjjhBYYUWP996N8Tqvxzrajiq7DDj0lfTwQY4sdeJTS5SdhOGCR/vWg8xEnJKHYKTYF57dsbgQJM0qyK4cnceIn2zlRQ65sDMYf1L33Mjc0jPD9NV4/md56hBrnjoQPNKl/1MrudtjkmJzgbTwpJFsJ5C+rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sn8aZ8wj067iP6U9k2LIOCUqs79eCba5uhkbTkw6MqE=;
 b=nl5QihZM+moYyQiYx8rBATFOkjX34TLHrFeOO+3KHBqcJzOop1kNfrjCn6zC8EfCGCDORc+oG9Jgg/CyNObkCTLfA07xpa6A+I7nqAJuBMDeAke5I4UzaDiezoQoUdTSntxKk8Zyrq0jJqb8hzwGzWzQuB/iFd2CuS2eujXT26UKuzMFvC3dcIrcx5CrBfk7Dhfe+dbzC/HdR220RUoKBdnQSIUvSxJ3k1hJ3HLLSzPYSMTyFHb8Bg+qvk4k4TgoFC/Qod/PcuSZk2w2Ut6OMui4kP1N48A2gMSoUtFqfdls6bL35SWcwTDLXsb2ewoX40alKwhc1IPNm7SAq8KCEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5702.namprd11.prod.outlook.com (2603:10b6:8:21::10) by
 SA1PR11MB8317.namprd11.prod.outlook.com (2603:10b6:806:38d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 00:24:39 +0000
Received: from DM8PR11MB5702.namprd11.prod.outlook.com
 ([fe80::a973:3a5a:91e8:49b9]) by DM8PR11MB5702.namprd11.prod.outlook.com
 ([fe80::a973:3a5a:91e8:49b9%7]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 00:24:38 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"thorsten.blum@linux.dev" <thorsten.blum@linux.dev>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org"
	<x86@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86/sgx: Remove unused size and count definitions
Thread-Topic: [PATCH 2/3] x86/sgx: Remove unused size and count definitions
Thread-Index: AQHdERx/dK/wVUdtbkaWjlvuSixWC7ZsLBKA
Date: Tue, 14 Jul 2026 00:24:38 +0000
Message-ID: <4e6d8f164ea0092043b9d57633ec619d37d94a93.camel@intel.com>
References: <20260711100053.739588-5-thorsten.blum@linux.dev>
	 <20260711100053.739588-7-thorsten.blum@linux.dev>
In-Reply-To: <20260711100053.739588-7-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5702:EE_|SA1PR11MB8317:EE_
x-ms-office365-filtering-correlation-id: 97a689fe-35e9-4d4f-d740-08dee13e4a3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|38070700021|56012099006|11063799006|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info: ZWGszaAdvD+uCGj5CN+1kgZSgTzJ1a1i1cGe8J7C46QAOpkwwS5VCHU+rXMuv+PoivyOiZ9kshgV+iGVwVXa69rY8xPBq2AgkVmHaAEp3cKWO438fyNZ8jwrQRDkERWKTRL7wqMnJ1IggmMQjznQuRb6aZko5+VQBSzEhm1Tj+O+JMhqMpbUu5rradhGciFPyaBd2LuoMcdrx1mjGNY5ObMIQowJVobYaGOx87Tm9uK+7OETa4HpAK4TAhbJJS5VZuk3SvDPPxeuHtLlYcU+U2epPsGcuI7JiIKi+5ISfQ1Yl61yGofWAaBY3/NPVXaZAR69kaXo3wD+wlJ6ObaZpvAG+zHLKTCL+jyG5oZmh+0/AMpsQGDhiPP4u1hT3i11XtWPp6Fi6FZOtAimX2tcfVv5BW/XKX13w1rG+w6adOpQ2upejMJent5vlihZyJSVKILPqxjr0J99ubk6zFbo4Mz4M2BIdGM8iDdzfJUYsyhb0MzMOnMZWgkndzD57AkrJuiSHYsRGWsW+P4IBkol0seHvSrmkcnTFDYtoQHma7mcqj/hIJD4SssS72zOKA9R3qj0Gd046EVYo8cXOvYleDLIksR3Y0+HhCP6eVA9QKiNyHId7nMcCCmldDCU5LPbgSaOzif94ZpZXwJjBoFlq0PSo8r4eTHRwc3vsMNpezKtxWsePcFfiMQzeQLmDKly13/uXSQTvDVklcEQ2GHeVMhMQxPX+Ffwy0P8mj8/t5U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5702.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekcxeHVIQWE1RWxqVGtTdlAvK1RXY0syeUk3OVd2M1YrMVZNd1lGOTQ2TStP?=
 =?utf-8?B?MG52d0IwMHlGVEJNcE1RUExOMytYTGdPTlk1ci9ONHdmNk1VSWZRbW9JWkhs?=
 =?utf-8?B?OCtnenB4TjU1NzZlc2RoRU0wanpWd1ovei9pVTRDT0MrWFdWWk1vY3RlR2JF?=
 =?utf-8?B?Zis1SW5IbUt2LytKQ3c5dE1VbStuTUFaZktZandhSjdNTC93emovLytLM1c4?=
 =?utf-8?B?K0xGcnlIM3FrODMrVG5QVEpXa2FOdldMYjV6M2NuRml4NktUNDdLSjJPbFZS?=
 =?utf-8?B?MGhuVXhlaXJwTUw0TXUxV0ZUbFZQUEYzeWxxcEZhbnA4bWEzeWR3VjJrVlNB?=
 =?utf-8?B?M1QvS2RMWDRMVDhvWm1DTTZZa3JpYXZsbFNGOFFIaExNeCsyMytCVE5vN3h3?=
 =?utf-8?B?K1ZpTW13bXljUzdISW1DOGVUQlV6N1U2YXliKzE0ZUxaUVZoKzFmNDJibFQ1?=
 =?utf-8?B?Qk9JSmMxdnYzUlpNVWhtbHhtUWlVK3RYVDBBbTFBcWw2YzMwU1UyY2xvcDEv?=
 =?utf-8?B?TEh6cXdaQ3EzeDZKZzVIUTlFUW14Y0R1NTY5VTZCQjFsWmltWHpXWTJ3RTVE?=
 =?utf-8?B?RnVBWjhBMVpnMFhNS1dubkYyNDRyN291ZDNrWUk2Rzl4UFA3Y3JJN0MxQnBY?=
 =?utf-8?B?emNMWURSbDFaV0YzOWI1RXN6azF3cERjVVpyb0lEVFBFaGszQ2lFWFpUV2J5?=
 =?utf-8?B?RC9aQlpjTjhteUdjN2Z2eVc0WFJuczZYMy9zcUc5NnZHL0JwUndUTlFDYWkz?=
 =?utf-8?B?aU1KbW02UE5mSHNQYlBNRWV4ZlNnY1RIa0FEZ3ZIOXVVbzYvb3RKSEVBRk53?=
 =?utf-8?B?cUp3Y1RvY0o4QXY4c08vTXRYbU0vTEtCZHdNZytuOW5XWUJ4cTdMOUxGSDM4?=
 =?utf-8?B?ZzJ4UWwyZTYrQ1lTa05MM2QzTmx3YTB6NTRqVU9Ga25tcTgwV21Bb0FvTHpu?=
 =?utf-8?B?KzNxemRqTVFQZEswMnhCaVgraU8rc1ZVdFU3OEhQdWw5d3U5c29WRmxXdDhm?=
 =?utf-8?B?M2hqQzNOL1IzcnhzYmVsVkE3SC8wQzJINnVUejRseW01NWIrYjFqTTRhVmxD?=
 =?utf-8?B?UWxsMW56K0RoZGdzbDRYTFFNYmMrd2FXR1MyYWgwM3ZEdnpVU2hBZHltYy9U?=
 =?utf-8?B?VkdWTXZ0MmhDMkdYbU5GMU1ndUsxQlIxNTEzTUQ4eXN2N2pINGl6b1pSQ0ZC?=
 =?utf-8?B?RzNBUWZQWnQxd0pJeFpjMXAzbWlKV0prY1VGMndqamYwVnl5OSsxdGpjNnRM?=
 =?utf-8?B?RkxkR0F2di83OUdUUDJOOTMvQlU1REpxRGxla2JkaktHUVRtZ1VjWVg0U1My?=
 =?utf-8?B?UmVNTFFrbzcyRG1uZ1JVbUVvNWJQV3luc0xWS2NNWDBYVWtPUXFtSzYwMXMw?=
 =?utf-8?B?QjdpZDhLbzBYeCt0SmxjUllSTkRyQXgydS9DM244OVk2NlZRZW1ORVRuNnk4?=
 =?utf-8?B?czl6bFNLczArcVRrZk4xV3RFcjNaZHo0aXNxdjVQZzJwT3dPVWJzTkZIYnM4?=
 =?utf-8?B?d05BSGVQWTZMY3p4REhnWXN0MzQxRTAvUExMVndLckcvZWdKM3FvdHVnS0Zt?=
 =?utf-8?B?M2NJWXI0SU4rSWxlaUZZZGVSQ0QwSHBObWtQWkdqQzV2aTRoUENmdmxZUjRD?=
 =?utf-8?B?UDdQcTYrbkF1SEtmVTJpR2FBYS9nK0NoRmFPakxZaEZNcHB4WmxoSURDeXhP?=
 =?utf-8?B?YVowd0h1am01NWtOZkh6VWdBU0s0cTVXRDdOcW5kSWlsWDcvNCswb1l1K2xv?=
 =?utf-8?B?a09EWWl0ZXA2SVFWVWNSZ3lQQ0l5ejVLTWU0aHZ0RnJ1b2hsdEZobjRKNUkv?=
 =?utf-8?B?ZlkydkpMVFdPdHlvZWhRVklCVm9iM0FOTGszT3RPSjdrbTF1RE5kblZKM25v?=
 =?utf-8?B?ZnZVeFFlMWVhL1NnMnZra0lkbnJsb2ZaNFk4TVIzeTJpeSt3ZWFZOUc4TFJH?=
 =?utf-8?B?VEVFRHVHMnE3b0UvdSthNmpVM2RJMWZ6TkVQTnBLYkRSdWF5U09nc2lJYUhh?=
 =?utf-8?B?UERGT0tpTE40Ym1hTkV5V0p3M25RSjJwRzdSZGtNdk1vSHVyVTl2RUMwRnd3?=
 =?utf-8?B?eGV3ZlNkMDZkbDRrMFpFTDJsRldlczYwbnpsRlVGemZyWERiSmRlaUNMRmlN?=
 =?utf-8?B?TTV2YnZ5S0ZsS2RZRUYyaVVrWjVDY3V5OGlidTVSRjF4dHJjMFN6dXVoN2I1?=
 =?utf-8?B?cGtQcCswOFRjMlprSjlpRDI4aFkwbWQ5aGxHblUvNWo5SXlEOUI5bjVpd2xx?=
 =?utf-8?B?MUZtRUptN295VGgzSVEzNTNMb2VqRm95N2dQUndVbzV6b1QzV2owdjlpMjhr?=
 =?utf-8?B?ZU5GQ0VuRDgwK0hzaGFMOTU4aDZYd0hBekJ4dVFLa1RnaTBINzdCdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71D5A88E5EC43444AB7081FA769B31AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: qii8RvQbjqNVbfDtW1jm5bAB8hVAzyMjWrHcQsxvK3UPcIKdJPBK/8yPV1cu1F008ibgp/NcdyM8xlDzlk/Fjdsu+IUwfCydNikrWZRIVQbywOSqT8Wca+g8WWufgN3UXHlDp5A/zpxVFKnxjmYRE+GzjBHCDAdg9r/BkoTPvTn6V//j/MAjuKBDA+fyD4vZSOitbiyH0jc7UtTALhlnr2BjmgUSjJNkMYprxAbA4k/b/bt9z3Kknk9aCdUKj3qDcPQuzgF+iF/IwYUQtXrK0CLumxCrMH50/k5VXDNqqcz8Au+j0PdM0nQjSUoqRtaOXdpAdX0GCQWGGlx9lsHdgg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5702.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a689fe-35e9-4d4f-d740-08dee13e4a3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 00:24:38.2400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DtA1sBc3YnQFWsJlh80SWLuRYPdQdYkITrcZ5KOIdNmV27kV//Lyqz9hUE2zoKVoi46hegFRT+Ns4o5dxebubA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8317
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI2LTA3LTExIGF0IDEyOjAwICswMjAwLCBUaG9yc3RlbiBCbHVtIHdyb3RlOg0K
PiBUaGUgZGVmaW5pdGlvbnMgd2VyZSBhZGRlZCB3aXRoIGNvbW1pdCA3MGQzYjhkZGNkMjAgKCJ4
ODYvc2d4OiBBZGQgU0dYDQo+IGFyY2hpdGVjdHVyYWwgZGF0YSBzdHJ1Y3R1cmVzIiksIGJ1dCBo
YXZlIG5ldmVyIGJlZW4gdXNlZC4gVGhlIFNJR1NUUlVDVA0KPiByZXNlcnZlZCBmaWVsZCBzaXpl
cyBhcmUgYWxzbyByZWR1bmRhbnQgYmVjYXVzZSB0aGUgc3RydWN0dXJlIHVzZXMNCj4gbGl0ZXJh
bCBzaXplcyBpbnN0ZWFkLiBSZW1vdmUgdGhlbS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFRob3Jz
dGVuIEJsdW0gPHRob3JzdGVuLmJsdW1AbGludXguZGV2Pg0KDQpBY2tlZC1ieTogS2FpIEh1YW5n
IDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K
