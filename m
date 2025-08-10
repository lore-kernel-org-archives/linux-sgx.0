Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E7335948;
	Sun, 10 Aug 2025 23:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754868524; cv=fail; b=ZIwxN/s3ODWlpuPakVdvqWyKUZDknnqRNyISz63kg8vv56J82lSoAn8yi4M13jL9+1kb4IJDh7UPc2PxDIdAlODG0PUJ+WFpcSeOfKP5W3vIjlT3iz2Y6qiM1U18V/P5mv2F/HU3GS9F5n4RPqn1ZtvjMsOOlfxgqlNDl2ZfM2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754868524; c=relaxed/simple;
	bh=4/BNsUOvsXRrYhsGbOi4PGI+2hrjgrphAjtHQXTEWvA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=egmKvgRihKEMhYZ3gQUpSMLihLN6YAWEiIGCVpz2woDJvPmaEbDYfVzNfhcqPsOEvjNOlC8FEHTavSKjA8oTOpSr8Hee+YrgXi1iXmNYcp2c8ljo9jTOzUa7Od5HBQXyFj1B/Z/w1KexpXWyozGzXYfe45njax74jekVKqVYpi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lIsnQVdS; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lIsnQVdS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754868523; x=1786404523;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4/BNsUOvsXRrYhsGbOi4PGI+2hrjgrphAjtHQXTEWvA=;
  b=lIsnQVdSysz3w6k8HZuCKW76jyijgUO5qeyFHp3nbIDpHqnN+DbGvBqb
   PUc3HRWUn6JB2KV06y43qUw9E4rI3uDD8R86YblvnnMQKtWW/kBG3Biag
   f4olJLqH1b3s+bPH6GdCqmi8ApnWypUd7Vj0RfjI693oPqGKLT4/W9W/i
   VA9j8IW2JZWnJUwbI4Sd2m8FwppvRzxFXfSkSAr6hhZCNQlUuGJwpIqVm
   TUBqF3cxqhX2uxgOMpDbifd8B5ts6WNpdc7eHgKhDIZlIIEN2+LKf8s0D
   tW+Z+9VghJHNTGkAr9HYkOjO3YqqpjdCYKuizEFcDEWbSbWOjilbewkQv
   A==;
X-CSE-ConnectionGUID: l9ulhtG3QnyznFDUZeEHhw==
X-CSE-MsgGUID: 6QPbxDVyTWWPUC85wi+TlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57199528"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="57199528"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 16:28:42 -0700
X-CSE-ConnectionGUID: syr/Ns1qRtG1ZPQtD8D5Dw==
X-CSE-MsgGUID: VgqU9XnSQDypMCPxGsrMAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165010142"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 16:28:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Sun, 10 Aug 2025 16:28:41 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Sun, 10 Aug 2025 16:28:41 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.79)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 10 Aug 2025 16:28:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GdDtf7P3Dh2bvXYDwJBfaA20KpadpS/IelOBmv2iazSEP+IbGXmiXD2oBR9GWx0cEfnDAZKsTHCG9RlP8/WS8RXCWeLp6XExZ8LftZ0nF7XWpGWyJ7/ZZnQ5xNV/KLyzS1TmtbpcAhJQrqfZhA0j5W/cH0MXrJbQRXglDVKOt7JSZo9yxlgigS30AfjoR0Vws8yFgrSpUd+c7G2kdZFPqpEnRf7Setcyx4Cf4NuWl5E+X0TuiJJz7enJQ9NaEb9s5QPLQcbPbplwt+xa7LMIN9zH1bqARS8JhBemJIEa9wJ5RMXslkiRyy+29PqVwdBlEBlhIV/py3Doj62aneFOXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/BNsUOvsXRrYhsGbOi4PGI+2hrjgrphAjtHQXTEWvA=;
 b=wVv+TfjrXoQdPiOsqK7UAG45aazRkNhBFa9b6o++YbKBQbLMfyeEqAhte7hSkzHgbr08/C56reMAsANZ2t3TpcsL3l8zwSsb8pxYz34x/OgfOw3pvhD/01L7SlSA2g01ZF40hN6bmEUrN0u6Dzs+huBSVZRjst0JvRhD9A/kYroQAeCBx/Sx50h3xKlqtT4qtSNCBQ0F4meAnznB71G5u1ZUaYgxtxXVzREPowTt25I5cjc2s5MFUtoLNBSuaeC/7H4tU3GRSo0CNXEIjnIa2sefvECE7KdiY6eyLAykzpIk9GcnTTkREE5J1lcc57ghp2H9AxMP2wVdiFc3MOkJcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by IA0PR11MB7402.namprd11.prod.outlook.com (2603:10b6:208:432::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Sun, 10 Aug
 2025 23:28:36 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9009.017; Sun, 10 Aug 2025
 23:28:36 +0000
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
Subject: Re: [PATCH v11 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v11 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHcBqop4njn8s1W90GYZRAV67hftbRWU0QAgAJGbwCAA/XzAA==
Date: Sun, 10 Aug 2025 23:28:36 +0000
Message-ID: <60e4d316844eb2125f252c941aa7a0d3d12f44b4.camel@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
		 <20250806081344.404004-5-elena.reshetova@intel.com>
	 <010d5bdbbeabbb37f822e30a2451df7feedf051e.camel@intel.com>
	 <DM8PR11MB57503CDDEA0D6BB5913E9CC1E72FA@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB57503CDDEA0D6BB5913E9CC1E72FA@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|IA0PR11MB7402:EE_
x-ms-office365-filtering-correlation-id: ee6fe2b7-d4a5-492e-1d56-08ddd865a145
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bDhFdnBBRmFFeno3cUE0OW4yVHJ5bkZPK1dvV3RIV2tRL0dSc0dwYmE2dFBw?=
 =?utf-8?B?S08vem4vclV2NU1qbGYxbGJjZVRwbXhjTkpqcXlNNVdOYlh0TGY4ZDVISTRl?=
 =?utf-8?B?NVMyY1gzd2JvU0JjdmhwMFNkTEVQZ29PQmxuQlFobTE3SDBrK3F5Znh6U0tv?=
 =?utf-8?B?MVdtOW9NMUxaRjJkYWV5c2F5MllZVHhnK3dTa0hDRE5yVSsyNWMxc1o3MkJJ?=
 =?utf-8?B?WnFTWk1oRlV4MGJxK2JtbnFGZmk5YitnRGZvckV3UmhsMHJLQU1iLzhsTjl2?=
 =?utf-8?B?eExhZkROck1QVUJ5blZ2RE1yV3ZvOE1zTzJJcXNoczlxYUFrVkpYa2JxRm9t?=
 =?utf-8?B?SGtBUEZ3QmQ1VjJja2JKT3pTaG9mQVFNSmFaOFZzbjVTZDFPdEp2N3VRekVD?=
 =?utf-8?B?M1JJUTZXaGdJYTd6OVVzYmlzUG95a0hFTTc5dkdOK0FnTFRjbitLQWlDUmZJ?=
 =?utf-8?B?cGdxUEduLzVtU3c0d0ZzUGZ0UkQvaVRXTE10VFRUbThoT0htR1NBbFV1T0ZL?=
 =?utf-8?B?Q1pjSEkrc08wSFZPNi9FVWJMVWFPY0plbTE4ZG83WU1XL3g0c1NteEdZWXRr?=
 =?utf-8?B?NzFUVkFUY0dLZTE5S0ZIUWFaaXcrLzlzSVhFejNKTnEyN2Y5Z29oWWFHdnFO?=
 =?utf-8?B?N3l2d3FxYi9ld2EvYVJGTlhlYkU1NFF5MDF4Qk9hK0I2L3ZDSHdsbmdtNHBh?=
 =?utf-8?B?cmV6cXZ1aWh4QXZSUndCUGVEdE1GTmRoNDJzNHFMR2lrdVlqMUVCekFqTnMx?=
 =?utf-8?B?MzM1M0crdENsZTh1TjFBQW52SHZrckF5am9RcFhmNCt2SENoSk9tWE9hd2ZK?=
 =?utf-8?B?Vkx2NklOUEttVDFIejNrRTR4R2pUbWhFZVJ4b21JcFduTC9HMXRQYlVDU2Nw?=
 =?utf-8?B?SDFrVUJJSmp0Y0tkZi9BWU1TOFN2YmxWMmdqNmFjSCt1ZXlCUHhFVHJ4Q214?=
 =?utf-8?B?QjUxTzluUVZuTEM4amhXMjNnY0NTYjkzdm5EeXBXbEhFZkF0RXBpSVBDclpG?=
 =?utf-8?B?UXByTk9tY1QxeU16U2MyVFdRQ3ZoblBFZ0VXcVBLQzlSSVdLQUZvOEU2YWF3?=
 =?utf-8?B?MTF3R21zdEx5T2NXTmorVEhqdWExalZBZmRIWlhoNFFyeHAybEJmVnRxY0ZM?=
 =?utf-8?B?MlExS0JjNC9pY1F3MEVDUHJEaXIrbDdzSGF0SGVYRFJqTFF6K0wxTFlPVTlu?=
 =?utf-8?B?NnVWQW4xTHZTYkNHV3BONHgzcStYQ0Q4TEN6azdkaW81NVFLRGZEUkx4Nm01?=
 =?utf-8?B?dGh2Nnh0Z1h1cUdVc3RDZUcva2cyVmJFek5YcUNjNWFJblIydFkrUTNLTUR2?=
 =?utf-8?B?WHpzYTdicm9RNzBaMTk3RWppa3hOcTRndEcySkRCbFVBVmJvdUk1TlgyWkMv?=
 =?utf-8?B?cmJ6bi81b29QT1JpQnhDSnZaaEhrNXB1Yk9KTTZkN0tKRW94bHZiQnBlYzh5?=
 =?utf-8?B?TWJFa1dpUmx6a3dDL2QyV3NjVE1YMzNvZWQ4ZCtZbnh2RG5kaTRTQjFnTkFx?=
 =?utf-8?B?SXpZb2pVV0pqMi9sT1FXallTNkQzeVZvT0dCditDOFZwQkU4Y2lrWlFPNU15?=
 =?utf-8?B?RHhpTDk2SHlxNlRxQ0tlaElwU1RlUlRzRGxHc1lTT1JObXIyVGVPeng3Vjh3?=
 =?utf-8?B?RmRldUhSWWdybVpSN0p1OFZpNTExWnhDWldvakl4YjF4OWJIT3UzbTBLM3Ju?=
 =?utf-8?B?bkwzWThpTnhZSEJhQmhhVHNGSkk2Yi9PSUxuYlBObEhISDlqNE1aZ0xHSXp2?=
 =?utf-8?B?UnRTaWp4L0JOTG1Eczkva3pBY1BrTmlVUkxJcnlZVjdDN082VUhaVkJJUHZH?=
 =?utf-8?B?dCtrREN3NnlXZzFmeldHeGFVbmhFaXhOQ1FwaWJ3OVlwUC9uK0JSblNXSU5K?=
 =?utf-8?B?TFprWFBDa08vNXBUc3BoRkNnYUhhb0srS0NNdmk2bHNOOUVHV25XcWRDajBI?=
 =?utf-8?B?a3R4eVc1VzdSVHNBY1pHVXJqTExucVYxUTQrVFVRQWpobU9zRFBwbTJsNkRz?=
 =?utf-8?Q?ZuYBopDdhMMixNF9i4piQGJ5N4byB8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1VIKzB6VG5KeUxTaWMrTUhDWVJMQzVIZnRaZ1BldUxVc3Niak0vc2NEL21O?=
 =?utf-8?B?UUVKV095aktPTUZib1NoMzd4cEE1WHY5RDNFVk52WTdCNkRwbk9TTHJqLzVy?=
 =?utf-8?B?OFZabkxRMUxqelkwdHM3Yk1GYkVCSGhOR1lsMlI0QXlHYU1vR1BxVlVpQjM4?=
 =?utf-8?B?WjNpaXh1SHVWK3VIWnVUNktyQnZ4WGlsUStpaHlyTlJSeHduUjQ2dnF6cFc5?=
 =?utf-8?B?YUt5emFUTTR5ekpWK085c0xOR0taOVpwOUN4OHhHZGZSeUVDWkhKRC9UOFBL?=
 =?utf-8?B?VWVnUXo0dU1ocjdxY1ZhUkxHdEFTRkM1Mkd1N25iY3d5blNteGVmRHRha2t3?=
 =?utf-8?B?bVlEdWNCbjg5QlRyZit4TUFXMGRoS1Y1QWJUa0NqVlVtL3BUNlBjWG5yUkFQ?=
 =?utf-8?B?eUpzTlI0aTZaZVMrNHA0UHcwcnRpdnVzRXFWRS9IaWxRMDB2TUFYZ2xRcXJ0?=
 =?utf-8?B?eWRiRnI4ZjRudE1EMWNzdm0yWmhObFk0M3JMODRkMzlOa1AwaW41NkZ4TmxX?=
 =?utf-8?B?RXNuRUpFWklscEFNa1lFcVNFSUg0YUFzeTVEVlcwY2FZSXhZVktGR3dUSDdU?=
 =?utf-8?B?ckRvcEY0N3lSR0MxUUs2S1dXY0ZKdWErODE4UnNoTXdDNUdrdm90aWRVdWZx?=
 =?utf-8?B?QzRxOUwwaUp3NjlGZHRRdmdqUE9jYTE5SmJoWnVGVlREZ3FpSFZ4TWxVbHc5?=
 =?utf-8?B?ckdwR0NHZytPZ1pIczh1L1NGK3dxV1pJaWNOMVhDN0ViaVliN1hoOHJLaGc5?=
 =?utf-8?B?MVhVRHY2YjVSeDVYdGZzZEZLbkxFTE1ERkRKSnRINXhieFdQcG5Da2dlS2dQ?=
 =?utf-8?B?TGRDVTdoOVFtNnkxaVhIM2czM01EUVM1VnBGUWc5MWdYUUM5dHpXOGdPVFQ5?=
 =?utf-8?B?V3UrWGttVWlVekZabWpSam0xZGh1VkpNSFJFVDJ6NXRQZUcyS3VvWFBrWGNB?=
 =?utf-8?B?QVpFZEZ6QjZYcmk0UE0ySE9jaGRLK1VKVUlXdEQzM0xPaUhKbGkxMUhqb3hS?=
 =?utf-8?B?eS9uWjlRR3hlZkF3WDN5eDIvZlJRYU9yZTl6czRINXBqb2dRNnZvS05FK2NM?=
 =?utf-8?B?cjgzbVZyZ0hCMWtpRFpPU0ZtcTdERWM1bVh0OXBXdEFTSm1oNjRFZWVOSGpW?=
 =?utf-8?B?TGJBUTFjVjBFZjU2SHE5SzV4VndnSmVwaHk1UFk3N2JYM2xsc0JjZkJLOXFE?=
 =?utf-8?B?U0VnU1M4ZHVXVUhlZHZtbElJWEg0Y2xlTVgyek1tMDc4TzkvckUyOTJDZTJW?=
 =?utf-8?B?OE9wUjdnR1p4SkhnN0pNaVdYVE01YytjWUNQdzRlejB3bXNzV1hiUGs2RDFm?=
 =?utf-8?B?VUx0ZXZ5bzZDR1h1TjV2a0YvajgzOGxxKyt3WkhCcjJCSmdNK3pESkxYWTIx?=
 =?utf-8?B?L2NQMW1wTzJlU053Y042akxPS3lodXp2YWhtQUhma2UvYzhRZEsyNzJxRUJk?=
 =?utf-8?B?WVI2Z3NIaXA3cGVrRlNDUnlSeHlZNTY1S0ZOMVE2ZWFFRHpvL2U3TWdMTUhG?=
 =?utf-8?B?Tmg0WDlaVWM1ZkRmQWdJc3lheURWZ1JCekpGZ2NWb05XV040eFpqR25PZ2lD?=
 =?utf-8?B?SEtMbDNQNUtqUzRRcjNMZnNNa1crOUFvb1dTRjV0YmNtUVRocGszNFpkcUhL?=
 =?utf-8?B?bS8zV1pwWC9kU245OU1jKzA1cEl3Y2pzNFY3Ri9nY0g2SG82emhQbjVhK3lH?=
 =?utf-8?B?eW90dzBiL0xZdlFFTUhuTEZTai9iaEdFdW1RYVpSNDBZYTZrZVZHbERDUTFK?=
 =?utf-8?B?SFMwNFkvajVnUjdwNCtLMmlzRVlqcU1aQlpmc3I0RzhSSUdWdkd5cFlyakRU?=
 =?utf-8?B?a1NLbzArQXU4TmlCT290cWRXeDlHWjl0Q2pmMDNTV2VTR3JWQzFERW5sakJt?=
 =?utf-8?B?YldJNTdPMzFob09waGcxQS93NnQ0WTNvcmM4VEFqTjRxV2JrcGxYT05LTXIy?=
 =?utf-8?B?ZkFpYWZkOUFSeHpNNTkyVWtFeUFjVzI0NEZkL3hFTmdHNWVjOVluRTdxclo2?=
 =?utf-8?B?c2UvQWJPSXo2VEl0UFFXUlNrdm1DQ1p0WVdGejljUGR6M1V4QkwxZzZSaVNG?=
 =?utf-8?B?NnlkZmlDNG5HWmFHUVZtanY2MkdTNUVRdStGVDMrcTNVZlgxSW84R1paZWtR?=
 =?utf-8?Q?7qFv1UFmKMyJZVicZZR8QQ4fe?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D10DC5134C352408192533AE9AEB896@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee6fe2b7-d4a5-492e-1d56-08ddd865a145
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2025 23:28:36.5219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s45E0HVtOS0IyZl8039B4jCdoelTQdimkBgVd0jJYDN5P+VWYCs46EKgq9FAO+HdpMbXavRKx+mx1n6tXihKTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7402
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTA4IGF0IDEwOjU5ICswMDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3Rl
Og0KPiA+ID4gKwkvKg0KPiA+ID4gKwkgKiBFUEMgaXMgZ3VhcmFudGVlZCB0byBiZSBlbXB0eSB3
aGVuIHRoZXJlIGFyZSBubyB1c2Vycy4NCj4gPiA+ICsJICogRW5zdXJlIHdlIGFyZSBvbiBvdXIg
Zmlyc3QgdXNlciBiZWZvcmUgcHJvY2VlZGluZyBmdXJ0aGVyLg0KPiA+ID4gKwkgKi8NCj4gPiA+
ICsJV0FSTihzZ3hfdXNhZ2VfY291bnQgIT0gMSwgIkVsZXZhdGVkIHVzYWdlIGNvdW50IHdoZW4g
Y2FsbGluZw0KPiA+IEVVUERBVEVTVk5cbiIpOw0KPiA+IA0KPiA+IEkgYW0gbm90IHN1cmUgd2hl
dGhlciB0aGlzIGlzIG5lZWRlZC7CoCBXb3VsZG4ndCB0aGUgRU5DTFNfV0FSTigpIGF0IHRoZQ0K
PiA+IGVuZCBjYXRjaCB0aGlzIGNhc2UgYW5kIHRoZSB1c2VyIGlzIGFibGUgdG8gZmlndXJlIG91
dCB3aGF0IHdlbnQgd3JvbmcNCj4gPiBmcm9tIHRoZSBlcnJvciBjb2RlPw0KPiANCj4gRGF2ZSBo
YXMgbWFkZSBhIHN1Z2dlc3Rpb24gdG8gaW5jbHVkZSB0aGlzIGNoZWNrLCBzbyBJIGhhdmUgYWRk
ZWQgaXQuIA0KDQpTb3JyeSBJIGRpZG4ndCByZWFkIGNhcmVmdWwgZW5vdWdoIGFuZCBtaXNzZWQg
dGhhdC4NCg0KPiANCj4gPiANCj4gPiBCZXNpZGVzIHRoYXQsIGluIF90aGlzXyBwYXRjaCwgd2hh
dCBwcmV2ZW50cyBzZ3hfdXNhZ2VfY291bnQgZnJvbSBiZWluZw0KPiA+IGNvbmN1cnJlbnRseSB1
cGRhdGVkIGlzIHN0aWxsIHVua25vd24uwqAgSXQncyBraW5kYSB3ZWlyZCB0byBqdXN0IHVzZSBp
dA0KPiA+IGhlcmUgdy9vIHNlZWluZyB0aGUgYWN0dWFsIG11dGV4Lg0KPiANCj4gSW4gdGhpcyBw
YXRjaCBpdCBpcyBmdWxseSB1c2VsZXNzLCBiZWNhdXNlIHNneF91c2FnZV9jb3VudCBpcyBuZXZl
ciBpbmNyZW1lbnRlZA0KPiBmcm9tIHplcm8gYW5kIHRoaXMgZnVuY3Rpb24gaXMgYWxzbyBuZXZl
ciBjYWxsZWQuIEJ1dCBJIGRpZG7igJl0IHdhbnQgdG8gbW92ZSB0aGlzDQo+IGFkZGl0aW9uIHRv
IHRoZSBmb2xsb3dpbmcgcGF0Y2ggc2luY2UgaXQgd291bGQgbG9vayBhcyBvbmUtYWRkIHRvIHRo
aXMgZnVuY3Rpb24uDQoNClN1cmUgbnAuDQo=
