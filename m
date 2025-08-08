Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3576E23535A;
	Fri,  8 Aug 2025 10:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754650782; cv=fail; b=coZNua1JDyVasFvd8GoegmMt2niyIfzbrRrbbCPREYSbRwqkE8pMyAiRI5G7MF9MJz76sEdJlbaiAIGwZYASyPHp2zjQyinfSgNAps0ynuVv9tRbN3kuTl3TGa9lyh2K5jLxMQ5XJhm8N8ALSG/FC3x7Z6OoyGe1MLDMBi/XhFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754650782; c=relaxed/simple;
	bh=C2/CtdeYs3ainOmXVZfdfWMaxWsAtBPCe4g4MC4nyEw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h/AhDbayvbKWFdMOqlTvEMw/lsVIOiMG7B9Sou22rSRCgdjKrbLHPiccEQqfG7YMEESvPDclmLebGKMwxy7lB55Nky4YCvTPoMXwXounYyM1D2L3njqSAM6OppNpTgHCFDp7D5ZSZU0echGjYquN/mmnq/xAQNmrIRv+XOLwoo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bERP+YAb; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bERP+YAb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754650780; x=1786186780;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C2/CtdeYs3ainOmXVZfdfWMaxWsAtBPCe4g4MC4nyEw=;
  b=bERP+YAbbfOVcXbFpawDUK27Ujl8y63Ba2ucd7DrWWvaEJG4JsRr+VCC
   nTRzwhp9CbQdRX1Y2HbD9oXEHEXWopYz+VmzUQaizW9uO2rb70djrZKow
   19tSbuIwI+x3un3rS6IwoPwY25rx2qZeijLOjChpNtzSlJN29XdGUT62Q
   F3vdKvUzSzYQZdlPvAolFyy3fQflda3QOvS0Wi/FasyJs8hYdAVsAy0RZ
   5vDW/Y2rksfpqQJeLjtOf6/ljt8t5ZYRAUhUBPMN501RIy6fHqrNNR8wZ
   1J8T7kHvPH5hT2glLUWggkh0G5hx4JLq+oXwJFQXXvAnUfSpmxafqbMAx
   Q==;
X-CSE-ConnectionGUID: 7N4m7zonTkK/BXyHU6O4wQ==
X-CSE-MsgGUID: qGZiz6apTHO4j3yQMlP7+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="57139367"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="57139367"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 03:59:40 -0700
X-CSE-ConnectionGUID: 4aI9skXlTMm/OCQFnPUrTA==
X-CSE-MsgGUID: jKnRoFaTQY6WpQbXHULDZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="164959912"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 03:59:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 03:59:39 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 8 Aug 2025 03:59:39 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.44)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 03:59:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P2kp1jp/n+HbvR1QJmHJBMN+OY5T70nlUlEDiF00SjIEkljTW3Ii2ppkl8+hX1/G8MJvwtc18tRzA3qRDaIa+YM3ru4xE22X1g8Pxrs/AXszFAgLvBMuOuvN0okzAfxwDdQDx1tV9Hv97gfKIE+cr6fnWYNNANvr6PFfoe9Vy5pifgk6v3G6berigd2DUhHADq7Np3N7Fm21QPC0WAm77w3qa8Du2Aa7/Hrq7bGXN8JFkn1kSfQaULalkXg1zad/er/U2yNc8K7g91XboNs+3PZ0Ljcn3urT9YUn6vd0gWP2JEA8OSOpJV81hjoNigabRUKXMWHMbxxX81OMFMqTXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2/CtdeYs3ainOmXVZfdfWMaxWsAtBPCe4g4MC4nyEw=;
 b=n5fs/BmOWeROzTHIufUywn17iEHKWLmmal+SjAmrG0DQ5El/A/KLEBs2A76kWERO7uLB18OZTQ3L60p1nZhcA4wZLOdqhTfkAdtt8PskvnSYzTr2e2u1Mv/Inc4FWRBPlxA4bouwy2YzESysstju24AyD2XnNY42V99ALgrAGkHHzm7KogmPMuTj+oGCmPjMAStpY8MujSfY6eZsRQ+OhzMuKL7eoH0FRdbmU6/Nj6M1uMfbbkrF+mVbYg9aqhoaAedyHEQaFiQcFF1H//IYanlgn8igy6yzkIUtezY4oMtWVppwXWglPz0V2wdl6/SSDvhmiKXlASXmlOObDIX3WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH0PR11MB5928.namprd11.prod.outlook.com (2603:10b6:510:144::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 10:59:30 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 10:59:30 +0000
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
Subject: RE: [PATCH v11 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v11 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHcBqopAex/Cj9AqU2EsibuMOcEyrRWU0kAgAJD9cA=
Date: Fri, 8 Aug 2025 10:59:30 +0000
Message-ID: <DM8PR11MB57503CDDEA0D6BB5913E9CC1E72FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-5-elena.reshetova@intel.com>
 <010d5bdbbeabbb37f822e30a2451df7feedf051e.camel@intel.com>
In-Reply-To: <010d5bdbbeabbb37f822e30a2451df7feedf051e.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH0PR11MB5928:EE_
x-ms-office365-filtering-correlation-id: a3762f93-dc30-411f-099d-08ddd66aa693
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|10070799003|1800799024|7416014|376014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?YkV2Tk9UdDZCSDdqUUhZU2FKZ2pDS2Nra1NsSHJwbzJDNlRjaXQyeWlwY1hm?=
 =?utf-8?B?SGVMZjhxTHliYUlscHgxSlUzZFZrN2xGQ1RLOHVicS9TRk16ZXltSE52Tlh6?=
 =?utf-8?B?QjFKc1FwVU80QXlaRXNMWkVJOFFMM21tZThneVgxQzJQRzFsOTFxTTgvRTV3?=
 =?utf-8?B?c0Y1NmpTWk5YcGZEUmlPc0RwLzhUc0tkWFRoNnYrVGQ4YnQ4Y3RiZnJMbUNt?=
 =?utf-8?B?MHNQd1NiVk9COVF1THRKMkQ1MVJNRFJCUkxjS0xIcWxkTi9JZElxNkdZUk5l?=
 =?utf-8?B?bVRuZXc0WW5IQUkwcWxQR0w0T3U5ZXRPYTEwT05qak9ibVF4dGoyWnluTzlK?=
 =?utf-8?B?RmlqUEpSTWN4SlluYTl5RGVYS2J1TExXbHd1aDltOXVwaU15WUlENURRNmtM?=
 =?utf-8?B?WmxFL1Erc1E3dDNGZ1REZjRVREJGZU4yQzZkc0RBOFVHT3pmREpCS0hxb2h1?=
 =?utf-8?B?cFJxSU5sL2JhWnN4VVAyZXpYTU1Ld2RqTEZpeWwwZmszZDlLcDFpU0xSOU4x?=
 =?utf-8?B?b2YvSDh1THo1bnBqNzNQMHNMQmdra0lHZm9PNndQZDNlb0JBcWpUYXFBRkhp?=
 =?utf-8?B?TTZUY2x4N1EwTmZadlp3OFl6dnh3c2ViM2tWYU5GTE5PMlo0VFlXd2IzeGFs?=
 =?utf-8?B?enF3ZjJWa1J1UGFQTEVtaTVEQ0paZ2RVdTU1R1BWNnhQdW9IY0ZpZ0x4dmd1?=
 =?utf-8?B?L25Fc0hyK3piT3d0OE1VZ0dKejlHd293WDFtYlZnQmNacUhqMjllTCt3VHJI?=
 =?utf-8?B?ZkxPN0hTMFZFRVVhUHBMVnBtUjFMYnJmL3ZlSzVyV1MzZTdsd1lGQm1iL29K?=
 =?utf-8?B?eW1aWmVjcTJOTmNQWkp0cGRZeVVlWk5BVndiZFVQMXVYbFVGcmN4NUJLcGZC?=
 =?utf-8?B?M3JyemUvQ1RncTUwbjZ5SW82bTNGNGd2cTkyUWZFU2JKemNqdGFNSFBhU21n?=
 =?utf-8?B?NnBOcS9YT24vbGRQTjZVdFh2NzZSRlJHYUV5VStUMkhPT21PQVQ5b1VONCt4?=
 =?utf-8?B?b3BCcVlGYmwrMVJuZ0RmeGhPODhHSkh0aHpxN1l2TzQwYk1UaXZycjA2aXlR?=
 =?utf-8?B?SUFSN29Wb1ppSG43dDJDSXZZVk5hR0pYSGFGRFNEaXk4MGsrbVFOZWM3OTNP?=
 =?utf-8?B?MlpsM3RRL1dydHdRbXhjV3NYVlRRd0tEWitSRm9oeGZTdlVyMlJZS2VFbXZT?=
 =?utf-8?B?M0Fod2RacDBGTU4zOXVJWVdSZnY3UCtIRjdpd2RxWDNmY1N5bG94RGUvMkQ2?=
 =?utf-8?B?RHMzanQ1ZG1JOENMK2d5Nk9vRUdoeUgzM2Q3WTV2UEtQZVdlazdLZDRadWp1?=
 =?utf-8?B?T1F3TlU0OE1PZEJhalJFZStYVlpsbXZ5UzN4bFpvVSswc1dGNSs5TFhkTitW?=
 =?utf-8?B?WFdEUW9MRGdVeFJUK0lHSEowSW5tb3h3WUJnbE9QTTVIRG1LbnkrY21WQmZK?=
 =?utf-8?B?a3lYbVZKQnZYWEZDVjlNdmY3U3JvaUdYeCtkL0MxM0l0SWxjRTBvMUhsN2ZW?=
 =?utf-8?B?V0ZkTnFZQ0ppRVRUekNOUTZXeU94Wk1kUWljUUphd1Y5bWhFaGJpbkRxZmEz?=
 =?utf-8?B?b3NYemVkZklSTVNEUU1KV2hCZytXN3Ywbnl6STNMZkE1KzJ2TmJxMEcvOG9V?=
 =?utf-8?B?V3FGazlVSm1KdWdzS1FaU0hITm9Wang4L2FGelhKdVFtT3Npc045NjdobkQ4?=
 =?utf-8?B?SWh1a1VDVllUcDNWa1NPR1dlL2hXNFZTS1h2ckRFNmlHUDBUQVdDZ2ozRXox?=
 =?utf-8?B?Q2xoOHF5Qzg4RExGbTdvMXFnRkpZaEl0WjN6TkRxNUVnM1kzQ3BjNzFwM056?=
 =?utf-8?B?bXRadS8vRTlqY084b1ovTTFaQVd2ZXIxQlVCd055OU55YzZjTHMvR2R4bjd4?=
 =?utf-8?B?eEhQVy9yV0h0bVE0M1pQZ3p4RzZaaGVMaFdMVFcvVDBqNEJmMldINGlaOEtW?=
 =?utf-8?B?dkpYRGxuRGtGZDhEZ084RkZSN2VlRFFDOTlOeEQrLzFOTjJKdjYrTnVDOUc4?=
 =?utf-8?Q?pUrDhaEORuAB8rQalQqO69YFc/QRV0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(7416014)(376014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mm1HeUU5QkliaHAyQ0UrckdnVlJvWUoyS1hCK1RWY3A4MWFSbFM0UHFHVjdi?=
 =?utf-8?B?Tnh6MlNVaGZKS2FadkdRR2U4RWNnNWh5TThKL2JqalRFa0VvWWpZVC8vUHda?=
 =?utf-8?B?WXFZQWpvSzJqeEdLYVp4dnRYL1hvekQxRUFzalJpLy9rcFFERXpRYWNsMTVQ?=
 =?utf-8?B?cFBtejdDK3NPRWR0Q0l0Vy9tSTZvN1lXODZJS2c1UWxzK1ByMmFhRG1YN2xE?=
 =?utf-8?B?TVI5dGJObFVVM05aV3I1Z1lpRlp4ckFKbjIxU0RBN20rTG1qbUd1WUQrdXN4?=
 =?utf-8?B?TWQrTGVubmx5L2NWbEY3SE02YlFpeC82S2hkTGhlTVpCenFwTWdjbHRVallX?=
 =?utf-8?B?ZnZWQ29UemsvNlRhR0ZrblZNUTNQb2loQVY0bm90cFprVTJQTWhmemZ6RktS?=
 =?utf-8?B?R01uM01WYUNLVitaYWJsRG5qTzhQbForVFlZQ0w0dlpLdVk4b3ZnSkJpRkFI?=
 =?utf-8?B?enVFSDRjMVQ2dWxpOXJDYWkwdmpDMTVCZ01MUk5JQ0dpZEoxNlhuTFl5UXFZ?=
 =?utf-8?B?VDQyZFQ5bWFxMXZhTGY0NWM3UUUxRWJGZUxQUzhqbDhoUjBJSjdkTlBJL1Er?=
 =?utf-8?B?YzQxQlcwYlZiMWlsazdSSU1GZkg3cjJNMlZrNk9QbGIvUTdGU25vZFA3T0Jk?=
 =?utf-8?B?RTZNeHorNy8yVnhSNC9vM1NhOXk2b3RIVG1FVGcwZEYzOG9CMFVYSXZvdmVY?=
 =?utf-8?B?Y3BGUUFBdDFhV1VuUFZleWpvK1p4QVhsRzkraFJHeDNGV0pvM2N1UjNYT09T?=
 =?utf-8?B?ZVNERlRSRHBqN004WGJWVWpYM2Y3YW9wcTZxbDFzcGMxT1h3cTJuR1pYbGRM?=
 =?utf-8?B?cVVaR1IyMjRreHZhL0YzUklXM1RkbGdsUnR1UmtqTE1EbVE5TXJyQmNOY1I0?=
 =?utf-8?B?MC9kK1EyakpYbWxteU43ODhUVXF4SWVaUUw3S3lBL1RuOVltdU51Nmg5T240?=
 =?utf-8?B?TERXcEtJZEtCVmtSdDhaZngvM0p1M3RYYmJKR0tLUmoxbDl2R2tSMlRxL204?=
 =?utf-8?B?R0kxQWw0bk9majFCTlRNWm9WM01hS2VaYldUclVNU3g2YWRwbno2d29zVDRz?=
 =?utf-8?B?SDFPMVp6M3FhbXZCaEY5OVphL2xLdXZLUy8rQ0lFQlQxT2VId3V4RUE4czgv?=
 =?utf-8?B?dk0zQ1RaQ3BYSWVsWDFjcnZ4QjlSZHorUHRxbDIrODhlYVU0dndLRDR3cGF6?=
 =?utf-8?B?U2I0dUFHejEySUJtOEFwQ3NTSFNNcThtOWpIVzJ1VHFxRmZVaThpUVdvVDB1?=
 =?utf-8?B?SG9kTGlmRXErR2Q4ZzU3L2daeDZsQXRiOUcrUExRdGJVYll0d2JFOHorVHNO?=
 =?utf-8?B?OHRvZmIwWTk4YU0zcFlCSGZFVFUvOERGMUR0SWlFV20rL3NjR1pQWW9zR1pX?=
 =?utf-8?B?Rkd6SkhEdEV4Y2hyaDBGbTUwRWdaODN6VFpENjNhZkU3b2ZxVjZESnN6aVM3?=
 =?utf-8?B?bnFWWWl0KzRwUkZwc2UzYm91Y3ZnMG5tRVhDOGxpcW1sVDcyWGd4SXpXTi9m?=
 =?utf-8?B?OUQvbjhhRjZnTm1kNlNGTVZoV1JvS0tpcHBLRlpGNm1JWFpiaVcvRTBnUnB0?=
 =?utf-8?B?RVdFMjV6aDVadjZsSVJZRVVha3JidVFKQUs3dHVmTWlVd2Mva0ZaYlR2RWpr?=
 =?utf-8?B?MXliOUtQVFU1NUJ1Rm5EdEI4Qzc4WmxXSEtWMHBTcldDWXVWNS9HTHkzZEVk?=
 =?utf-8?B?bWR2YnFMaXAzd2Z5ekRPMk96Y0U0OWFxaCtuS2NUWmZQSURTSUNoRkdKZWZ3?=
 =?utf-8?B?bXNhaTc2d2tpVWI0VFpzTUZDUExHWUlPK2hkQmxvVEMwS2ZnbGhVdVpaWi95?=
 =?utf-8?B?Rnp1ZnpCVXBtZ2tsclNVWFlxd0tGQmVTM0VTVEIrSVNkcGhsellJZ0w5cTVv?=
 =?utf-8?B?R1VMNzNlYlRzUEZzUUVBSjhpYjZaY2xOZXVzd3Q4WkEvaXBHTUxKNEVHc3B5?=
 =?utf-8?B?V3NLeVB3NGVoN0c2WUwrdHdQbHFISDZuMjFDNGpFUUpqek9rN21IM25CcTl3?=
 =?utf-8?B?UWhhYW1NRjdBbnVFNWZ4dUZHVzNUeGlyUFlCTThlNTR2R0VDRnpyc1hmcnFR?=
 =?utf-8?B?SE8xMS9XemVQekw2SVh4Vk1YZllBMFVoWjVPcDZPd2R0UFRYczBSVFVPMXc3?=
 =?utf-8?B?ejkwRGFQMnNyaEs3bFJuR3l3K1Rjd254U1pZU211NGlYaDlBdU12YjN6VTNS?=
 =?utf-8?Q?lDuFBqQk5g2BWZlljPoBuWvDKirdRnB+o76HcUxWIcqx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a3762f93-dc30-411f-099d-08ddd66aa693
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 10:59:30.5098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UPxe7V1UWFG+wQOgL4JBqPYwdzbolKXonrlckNpgEjdpRtMh/1c6JEYx8IlcPRlkRbP74tFoZ1lSa67chQU0zY0ZN9gDOuJCu8huc6pLpZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5928
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgQXVndXN0IDcsIDIwMjUgMzoxNSBBTQ0K
PiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT47IEhhbnNl
biwgRGF2ZQ0KPiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPg0KPiBDYzogc2VhbmpjQGdvb2dsZS5j
b207IG1pbmdvQGtlcm5lbC5vcmc7IFNjYXJsYXRhLCBWaW5jZW50IFINCj4gPHZpbmNlbnQuci5z
Y2FybGF0YUBpbnRlbC5jb20+OyB4ODZAa2VybmVsLm9yZzsgamFya2tvQGtlcm5lbC5vcmc7DQo+
IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOw0KPiBNYWxsaWNrLCBBc2l0IEsgPGFzaXQuay5tYWxsaWNrQGludGVs
LmNvbT47IEFrdGFzLCBFcmRlbQ0KPiA8ZXJkZW1ha3Rhc0Bnb29nbGUuY29tPjsgQ2FpLCBDaG9u
ZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBCb25kYXJldnNrYSwNCj4gTmF0YWxpaWEgPGJvbmRhcm5A
Z29vZ2xlLmNvbT47IGxpbnV4LXNneEB2Z2VyLmtlcm5lbC5vcmc7IFJheW5vciwgU2NvdHQNCj4g
PHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjExIDQvNV0g
eDg2L3NneDogSW1wbGVtZW50IEVOQ0xTW0VVUERBVEVTVk5dDQo+IA0KPiBPbiBXZWQsIDIwMjUt
MDgtMDYgYXQgMTE6MTEgKzAzMDAsIEVsZW5hIFJlc2hldG92YSB3cm90ZToNCj4gPiBBbGwgcnVu
bmluZyBlbmNsYXZlcyBhbmQgY3J5cHRvZ3JhcGhpYyBhc3NldHMgKHN1Y2ggYXMgaW50ZXJuYWwg
U0dYDQo+ID4gZW5jcnlwdGlvbiBrZXlzKSBhcmUgYXNzdW1lZCB0byBiZSBjb21wcm9taXNlZCB3
aGVuZXZlciBhbiBTR1gtcmVsYXRlZA0KPiA+IG1pY3JvY29kZSB1cGRhdGUgb2NjdXJzLiBUbyBt
aXRpZ2F0ZSB0aGlzIGFzc3VtZWQgY29tcHJvbWlzZSB0aGUgbmV3DQo+ID4gc3VwZXJ2aXNvciBT
R1ggaW5zdHJ1Y3Rpb24gRU5DTFNbRVVQREFURVNWTl0gY2FuIGdlbmVyYXRlIGZyZXNoDQo+ID4g
Y3J5cHRvZ3JhcGhpYyBhc3NldHMuDQo+ID4NCj4gPiBCZWZvcmUgZXhlY3V0aW5nIEVVUERBVEVT
Vk4sIGFsbCBTR1ggbWVtb3J5IG11c3QgYmUgbWFya2VkIGFzIHVudXNlZC4NCj4gPiBUaGlzIHJl
cXVpcmVtZW50IGVuc3VyZXMgdGhhdCBubyBwb3RlbnRpYWxseSBjb21wcm9taXNlZCBlbmNsYXZl
DQo+ID4gc3Vydml2ZXMgdGhlIHVwZGF0ZSBhbmQgYWxsb3dzIHRoZSBzeXN0ZW0gdG8gc2FmZWx5
IHJlZ2VuZXJhdGUNCj4gPiBjcnlwdG9ncmFwaGljIGFzc2V0cy4NCj4gPg0KPiA+IEFkZCB0aGUg
bWV0aG9kIHRvIHBlcmZvcm0gRU5DTFNbRVVQREFURVNWTl0uIEhvd2V2ZXIsIHVudGlsIHRoZQ0K
PiA+IGZvbGxvdyB1cCBwYXRjaCB0aGF0IHdpcmVzIGNhbGxpbmcgc2d4X3VwZGF0ZV9zdm4oKSBm
cm9tDQo+ID4gc2d4X2luY191c2FnZV9jb3VudCgpLCB0aGlzIGNvZGUgaXMgbm90IHJlYWNoYWJs
ZS4NCj4gDQo+IFBsZWFzZSBjaGVjayB0aGUgdGV4dCB3cmFwLg0KPiANCg0KWWVzLCB3aWxsIGRv
LiANCg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogRWxlbmEgUmVzaGV0b3ZhIDxlbGVuYS5yZXNo
ZXRvdmFAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9zZ3gu
aCAgICAgIHwgMzEgKysrKysrKy0tLS0tLS0NCj4gPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gv
ZW5jbHMuaCB8ICA1ICsrKw0KPiA+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMgIHwg
NzMNCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDMgZmlsZXMgY2hh
bmdlZCwgOTQgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vc2d4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9z
Z3guaA0KPiA+IGluZGV4IDJkYTViM2IxMTdhMS4uMGUxMzY3OGY5Y2JkIDEwMDY0NA0KPiA+IC0t
LSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NneC5oDQo+ID4gKysrIGIvYXJjaC94ODYvaW5jbHVk
ZS9hc20vc2d4LmgNCj4gPiBAQCAtMjgsMjEgKzI4LDIyIEBADQo+ID4gICNkZWZpbmUgU0dYX0NQ
VUlEX0VQQ19NQVNLCUdFTk1BU0soMywgMCkNCj4gPg0KPiA+ICBlbnVtIHNneF9lbmNsc19mdW5j
dGlvbiB7DQo+ID4gLQlFQ1JFQVRFCT0gMHgwMCwNCj4gPiAtCUVBREQJPSAweDAxLA0KPiA+IC0J
RUlOSVQJPSAweDAyLA0KPiA+IC0JRVJFTU9WRQk9IDB4MDMsDQo+ID4gLQlFREdCUkQJPSAweDA0
LA0KPiA+IC0JRURHQldSCT0gMHgwNSwNCj4gPiAtCUVFWFRFTkQJPSAweDA2LA0KPiA+IC0JRUxE
VQk9IDB4MDgsDQo+ID4gLQlFQkxPQ0sJPSAweDA5LA0KPiA+IC0JRVBBCT0gMHgwQSwNCj4gPiAt
CUVXQgk9IDB4MEIsDQo+ID4gLQlFVFJBQ0sJPSAweDBDLA0KPiA+IC0JRUFVRwk9IDB4MEQsDQo+
ID4gLQlFTU9EUFIJPSAweDBFLA0KPiA+IC0JRU1PRFQJPSAweDBGLA0KPiA+ICsJRUNSRUFURQkJ
PSAweDAwLA0KPiA+ICsJRUFERAkJPSAweDAxLA0KPiA+ICsJRUlOSVQJCT0gMHgwMiwNCj4gPiAr
CUVSRU1PVkUJCT0gMHgwMywNCj4gPiArCUVER0JSRAkJPSAweDA0LA0KPiA+ICsJRURHQldSCQk9
IDB4MDUsDQo+ID4gKwlFRVhURU5ECQk9IDB4MDYsDQo+ID4gKwlFTERVCQk9IDB4MDgsDQo+ID4g
KwlFQkxPQ0sJCT0gMHgwOSwNCj4gPiArCUVQQQkJPSAweDBBLA0KPiA+ICsJRVdCCQk9IDB4MEIs
DQo+ID4gKwlFVFJBQ0sJCT0gMHgwQywNCj4gPiArCUVBVUcJCT0gMHgwRCwNCj4gPiArCUVNT0RQ
UgkJPSAweDBFLA0KPiA+ICsJRU1PRFQJCT0gMHgwRiwNCj4gPiArCUVVUERBVEVTVk4JPSAweDE4
LA0KPiA+ICB9Ow0KPiA+DQo+ID4gIC8qKg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L3NneC9lbmNscy5oDQo+IGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbHMuaA0K
PiA+IGluZGV4IDk5MDA0YjAyZTJlZC4uZDkxNjBjODlhOTNkIDEwMDY0NA0KPiA+IC0tLSBhL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvc2d4L2VuY2xzLmgNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwv
Y3B1L3NneC9lbmNscy5oDQo+ID4gQEAgLTIzMyw0ICsyMzMsOSBAQCBzdGF0aWMgaW5saW5lIGlu
dCBfX2VhdWcoc3RydWN0IHNneF9wYWdlaW5mbyAqcGdpbmZvLA0KPiB2b2lkICphZGRyKQ0KPiA+
ICAJcmV0dXJuIF9fZW5jbHNfMihFQVVHLCBwZ2luZm8sIGFkZHIpOw0KPiA+ICB9DQo+ID4NCj4g
PiArLyogQXR0ZW1wdCB0byB1cGRhdGUgQ1BVU1ZOIGF0IHJ1bnRpbWUuICovDQo+ID4gK3N0YXRp
YyBpbmxpbmUgaW50IF9fZXVwZGF0ZXN2bih2b2lkKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gX19l
bmNsc19yZXRfMShFVVBEQVRFU1ZOLCAiIik7DQo+ID4gK30NCj4gPiAgI2VuZGlmIC8qIF9YODZf
RU5DTFNfSCAqLw0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWlu
LmMNCj4gYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gPiBpbmRleCAzYTVjYmQx
YzE3MGUuLmQ4YzQyNTI0YjU5MCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC9tYWluLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4g
PiBAQCAtMTYsNiArMTYsNyBAQA0KPiA+ICAjaW5jbHVkZSA8bGludXgvdm1hbGxvYy5oPg0KPiA+
ICAjaW5jbHVkZSA8YXNtL21zci5oPg0KPiA+ICAjaW5jbHVkZSA8YXNtL3NneC5oPg0KPiA+ICsj
aW5jbHVkZSA8YXNtL2FyY2hyYW5kb20uaD4NCj4gPiAgI2luY2x1ZGUgImRyaXZlci5oIg0KPiA+
ICAjaW5jbHVkZSAiZW5jbC5oIg0KPiA+ICAjaW5jbHVkZSAiZW5jbHMuaCINCj4gPiBAQCAtOTE3
LDYgKzkxOCw3OCBAQCBpbnQgc2d4X3NldF9hdHRyaWJ1dGUodW5zaWduZWQgbG9uZw0KPiAqYWxs
b3dlZF9hdHRyaWJ1dGVzLA0KPiA+ICB9DQo+ID4gIEVYUE9SVF9TWU1CT0xfR1BMKHNneF9zZXRf
YXR0cmlidXRlKTsNCj4gPg0KPiA+ICsvKiBDb3VudGVyIHRvIGNvdW50IHRoZSBhY3RpdmUgU0dY
IHVzZXJzICovDQo+ID4gK3N0YXRpYyBpbnQgc2d4X3VzYWdlX2NvdW50Ow0KPiA+ICsNCj4gPiAr
LyoqDQo+ID4gKyAqIHNneF91cGRhdGVfc3ZuKCkgLSBBdHRlbXB0IHRvIGNhbGwgRU5DTFNbRVVQ
REFURVNWTl0uDQo+IA0KPiBBZGQgYSBuZXdsaW5lIHdvdWxkIG1ha2UgdGhlIGNvbW1lbnQgbW9y
ZSByZWFkYWJsZS4NCg0KT2sNCg0KPiANCj4gPiArICogVGhpcyBpbnN0cnVjdGlvbiBhdHRlbXB0
cyB0byB1cGRhdGUgQ1BVU1ZOIHRvIHRoZQ0KPiA+ICsgKiBjdXJyZW50bHkgbG9hZGVkIG1pY3Jv
Y29kZSB1cGRhdGUgU1ZOIGFuZCBnZW5lcmF0ZSBuZXcNCj4gPiArICogY3J5cHRvZ3JhcGhpYyBh
c3NldHMuDQo+IA0KPiBEaXR0byBoZXJlLg0KDQpPaw0KDQo+IA0KPiA+ICsgKiBSZXR1cm46DQo+
ID4gKyAqIDA6IFN1Y2Nlc3Mgb3Igbm90IHN1cHBvcnRlZA0KPiA+ICsgKiAtRUFHQUlOOiBDYW4g
YmUgc2FmZWx5IHJldHJpZWQsIGZhaWx1cmUgaXMgZHVlIHRvIGxhY2sgb2YNCj4gPiArICogIGVu
dHJvcHkgaW4gUk5HLg0KPiA+ICsgKiAtRUlPOiBVbmV4cGVjdGVkIGVycm9yLCByZXRyaWVzIGFy
ZSBub3QgYWR2aXNhYmxlLg0KPiA+ICsgKi8NCj4gDQo+IFlvdSBtYXkgd2FudCB0byBtYWtlIHRo
ZSBkZXNjcmlwdGlvbiBvZiB0aGUgcmV0dXJuIGNvZGUgdmVydGljYWxseQ0KPiBhbGlnbmVkLiAg
QW5kIGxvb2tpbmcgYXQgdGhlIGstZG9jIGRvY3VtZW50YXRpb24sIHRoZSBmb3JtYXQgb2YgdGhl
IHJldHVybg0KPiBjb2RlcyBjb3VsZCBiZSBpbXByb3ZlZDoNCj4gDQo+IAkqIFJldHVybjoNCj4g
CSogKiAlMDoJCS0gU3VjY2VzcyBvciBub3Qgc3VwcG9ydGVkDQo+IAkqICogJS1FQUdBSU46CS0g
Li4uDQo+IAkqICogJS1FSU86CS0gLi4uDQo+IA0KPiBQbGVhc2Ugc2VlICJSZXR1cm4gdmFsdWVz
IiBwYXJ0IG9mOg0KPiANCj4gaHR0cHM6Ly9kb2NzLmtlcm5lbC5vcmcvZG9jLWd1aWRlL2tlcm5l
bC1kb2MuaHRtbA0KPiANCj4gT3IgeW91IGNhbiBzd2l0Y2ggdG8gdXNlIG5vcm1hbCBjb21tZW50
LiAgSXQncyBhIHN0YXRpYyBmdW5jdGlvbiBhbnl3YXkuDQoNCk9rLCB3aWxsIGZpeCB0aGUgZm9y
bWF0dGluZyBpc3N1ZXMuIA0KDQo+IA0KPiANCj4gPiArc3RhdGljIGludCBfX21heWJlX3VudXNl
ZCBzZ3hfdXBkYXRlX3N2bih2b2lkKQ0KPiA+ICt7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4g
PiArCS8qDQo+ID4gKwkgKiBJZiBFVVBEQVRFU1ZOIGlzIG5vdCBhdmFpbGFibGUsIGl0IGlzIG9r
IHRvDQo+ID4gKwkgKiBzaWxlbnRseSBza2lwIGl0IHRvIGNvbXBseSB3aXRoIGxlZ2FjeSBiZWhh
dmlvci4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKCFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFU
VVJFX1NHWF9FVVBEQVRFU1ZOKSkNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArDQo+ID4gKwkvKg0K
PiA+ICsJICogRVBDIGlzIGd1YXJhbnRlZWQgdG8gYmUgZW1wdHkgd2hlbiB0aGVyZSBhcmUgbm8g
dXNlcnMuDQo+ID4gKwkgKiBFbnN1cmUgd2UgYXJlIG9uIG91ciBmaXJzdCB1c2VyIGJlZm9yZSBw
cm9jZWVkaW5nIGZ1cnRoZXIuDQo+ID4gKwkgKi8NCj4gPiArCVdBUk4oc2d4X3VzYWdlX2NvdW50
ICE9IDEsICJFbGV2YXRlZCB1c2FnZSBjb3VudCB3aGVuIGNhbGxpbmcNCj4gRVVQREFURVNWTlxu
Iik7DQo+IA0KPiBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgdGhpcyBpcyBuZWVkZWQuICBXb3VsZG4n
dCB0aGUgRU5DTFNfV0FSTigpIGF0IHRoZQ0KPiBlbmQgY2F0Y2ggdGhpcyBjYXNlIGFuZCB0aGUg
dXNlciBpcyBhYmxlIHRvIGZpZ3VyZSBvdXQgd2hhdCB3ZW50IHdyb25nDQo+IGZyb20gdGhlIGVy
cm9yIGNvZGU/DQoNCkRhdmUgaGFzIG1hZGUgYSBzdWdnZXN0aW9uIHRvIGluY2x1ZGUgdGhpcyBj
aGVjaywgc28gSSBoYXZlIGFkZGVkIGl0LiANCg0KPiANCj4gQmVzaWRlcyB0aGF0LCBpbiBfdGhp
c18gcGF0Y2gsIHdoYXQgcHJldmVudHMgc2d4X3VzYWdlX2NvdW50IGZyb20gYmVpbmcNCj4gY29u
Y3VycmVudGx5IHVwZGF0ZWQgaXMgc3RpbGwgdW5rbm93bi4gIEl0J3Mga2luZGEgd2VpcmQgdG8g
anVzdCB1c2UgaXQNCj4gaGVyZSB3L28gc2VlaW5nIHRoZSBhY3R1YWwgbXV0ZXguDQoNCkluIHRo
aXMgcGF0Y2ggaXQgaXMgZnVsbHkgdXNlbGVzcywgYmVjYXVzZSBzZ3hfdXNhZ2VfY291bnQgaXMg
bmV2ZXIgaW5jcmVtZW50ZWQNCmZyb20gemVybyBhbmQgdGhpcyBmdW5jdGlvbiBpcyBhbHNvIG5l
dmVyIGNhbGxlZC4gQnV0IEkgZGlkbuKAmXQgd2FudCB0byBtb3ZlIHRoaXMNCmFkZGl0aW9uIHRv
IHRoZSBmb2xsb3dpbmcgcGF0Y2ggc2luY2UgaXQgd291bGQgbG9vayBhcyBvbmUtYWRkIHRvIHRo
aXMgZnVuY3Rpb24uIA0KDQo+IA0KPiA+ICsNCj4gPiArCWZvciAoaW50IGkgPSAwOyBpIDwgUkRS
QU5EX1JFVFJZX0xPT1BTOyBpKyspIHsNCj4gPiArCQlyZXQgPSBfX2V1cGRhdGVzdm4oKTsNCj4g
PiArDQo+ID4gKwkJLyogU3RvcCBvbiBzdWNjZXNzIG9yIHVuZXhwZWN0ZWQgZXJyb3JzOiAqLw0K
PiA+ICsJCWlmIChyZXQgIT0gU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZKQ0KPiA+ICsJCQlicmVh
azsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlzd2l0Y2ggKHJldCkgew0KPiA+ICsJLyoNCj4gPiAr
CSAqIFNWTiBzdWNjZXNzZnVsbHkgdXBkYXRlZC4NCj4gPiArCSAqIExldCB1c2VycyBrbm93IHdo
ZW4gdGhlIHVwZGF0ZSB3YXMgc3VjY2Vzc2Z1bC4NCj4gPiArCSAqLw0KPiANCj4gVGhpcyBpcyB1
Z2x5LiAgSSB3b3VsZCBqdXN0IHB1dCB0aGUgY29tbWVudCBpbnNpZGUgdGhlICdjYXNlJy4NCg0K
T2ssIHdpbGwgbW92ZS4gDQoNCj4gDQo+ID4gKwljYXNlIDA6DQo+ID4gKwkJcHJfaW5mbygiU1ZO
IHVwZGF0ZWQgc3VjY2Vzc2Z1bGx5XG4iKTsNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArCS8qDQo+
ID4gKwkgKiBTVk4gdXBkYXRlIGZhaWxlZCBzaW5jZSB0aGUgY3VycmVudCBTVk4gaXMNCj4gPiAr
CSAqIG5vdCBuZXdlciB0aGFuIENQVVNWTi4gVGhpcyBpcyB0aGUgbW9zdA0KPiA+ICsJICogY29t
bW9uIGNhc2UgYW5kIGluZGljYXRlcyBubyBoYXJtLg0KPiA+ICsJICovDQo+ID4gKwljYXNlIFNH
WF9OT19VUERBVEU6DQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKwkvKg0KPiA+ICsJICogU1ZOIHVw
ZGF0ZSBmYWlsZWQgZHVlIHRvIGxhY2sgb2YgZW50cm9weSBpbiBEUk5HLg0KPiA+ICsJICogSW5k
aWNhdGUgdG8gdXNlcnNwYWNlIHRoYXQgaXQgc2hvdWxkIHJldHJ5Lg0KPiA+ICsJICovDQo+ID4g
KwljYXNlIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWToNCj4gPiArCQlyZXR1cm4gLUVBR0FJTjsN
Cj4gPiArCWRlZmF1bHQ6DQo+ID4gKwkJYnJlYWs7DQo+ID4gKwl9DQo+IA0KPiBEaXR0byBmb3Ig
YWxsIHRoZSBjb21tZW50cyBhYm92ZS4NCg0KT2ssIHdpbGwgbW92ZSBpbnNpZGUuIA0KDQpCZXN0
IFJlZ2FyZHMsDQpFbGVuYS4NCg==
