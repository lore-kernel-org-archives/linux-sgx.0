Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53342C18A;
	Thu,  7 Aug 2025 00:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754526247; cv=fail; b=FxKGhvV9YSm7VJfsta992nEDt8OGN4UvJfeRk4iXiYtN6CR6vTSlhpqYLWhqPOsPM9pGXzEzoGkL8oArdEPAzw7Bme1FL+dsYWQ8FGk8Tq6iET7xN/P7chlNdWIaYajMTYfk7IC+mNQUQHtu3j08izt925zpbgcXBWhudrKdhz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754526247; c=relaxed/simple;
	bh=m36vrdCJNot0xqQaPAPy/Ob0Vdioyb/7CU581Njolp0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VSNlMLkHqHq6fEiNpFhs46ZDSSQMSqILsW8ufsyKdCrsuTwpapiDGMMIL21bDamOoFsGwmyo5ayafvSVJOEfsSyyE4CmWxzRwNhZO/QhkW8GM2JL30pdAVyklrJb+N6+j5qBrSE/E5+cwbsy75GIPw+p302TVT4nn81wUaVtO1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XfUP7feP; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XfUP7feP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754526246; x=1786062246;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=m36vrdCJNot0xqQaPAPy/Ob0Vdioyb/7CU581Njolp0=;
  b=XfUP7fePVplll3PK1WPywS5rkRGsYdpwlj519w4Qy46kmCSs1NzC0bOJ
   iVWgMkZp4colXrdWGvr9ET1R6D8ulRlY/dMezk+xTz7a8tSSgTcR1rN/a
   ApUIHvVAwnSTL7kAlJaEVV3Z1sEKrdusOjih8IdxtD8pqbaJs2M7eDiBy
   eFuTZs67cz1joJR/TbwyeMu0YphkEZgCRKARXq6QicbgvI4Jj7cijK13L
   nAawpJvLQe8uN3bWzO8hdyVhCozOoTHxo8+CR1lRXa1k1m44LAZTz9Vmq
   msiqIMdE177cMi9TGevaAWbiG5m+7MV2FWaT39u+QhN5NPLpGh4lDBUN0
   w==;
X-CSE-ConnectionGUID: c8Sf3sDFTKCivh5K8ymv9Q==
X-CSE-MsgGUID: 85oZYIE2S9amn4sv+yWVDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56564315"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56564315"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 17:24:05 -0700
X-CSE-ConnectionGUID: 8md97dfCT62BsVpn8qvH1A==
X-CSE-MsgGUID: /hiaJ4R/TvOo3irmP3bCXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="195889329"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 17:24:06 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 17:24:04 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 6 Aug 2025 17:24:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.80)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 17:24:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ytE858dAqr7XTVZE0qXENPjHOa14hDaznG8S5BcZGrkzGwH4oarDE9mP/mKqdSVZxXfrA/iECBgR89ZMHy6aNNzJZ9ONuZUdOR+IMxdGwpZbdVRJjx0BNQMpy+e2fa411nWCf71OPPNEtn2C9WcYDbTlsUnuF/eDbUbAaCoABxIeimqTWUo9aSPZ8TDnhFRZhHOU6tTE4k4unUxAbfQ/EhHRtJD5LA1FAr0qWBtkRWhYP0J9qXh3uxLHcyyl/QpSh/Gg4eTEKVJg7XKgLU0ANX695/XfUJtMalLcBQyJ7XQTgN1SY2qG5JohSJtoKu8LJ8I9j8pmsn+et6u5e6eXFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m36vrdCJNot0xqQaPAPy/Ob0Vdioyb/7CU581Njolp0=;
 b=Yv3vRi327dQm1wiYiy+UPnyVmGAINNJAP/oZhmOYvd1iPwcXsbW7blkBQYMmWvM4EkMOGZM+Hox+QCwBkCtfkvt1c3V0WtMeSKkb4SQmSoCOiipIqQ1yIC/X1podJ8BdFeVZnyr26IWo28rw/6Wlan47STqlpZzvrO+2f8mZwewPuw56iTu/1N66+U74GnzBGf+cigk/cmmhCHkUMhxqjQ2nlTPvxsfZktlr8KMRgSwADd4HhdfBewaZMe7edoCMrWdxADBfWHCwo+UeXCWlV5ha4mi6MnASLVQ021ncm6Zsdnarhc4ZfqDB+pE9LlKDKpyZ7D0EXSzRO4NSquzpUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB6142.namprd11.prod.outlook.com (2603:10b6:8:b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Thu, 7 Aug
 2025 00:24:01 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8989.017; Thu, 7 Aug 2025
 00:24:01 +0000
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
Subject: Re: [PATCH v11 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v11 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcBqotX/RsOvWfdUWRjPC9YObd6LRWVc6A
Date: Thu, 7 Aug 2025 00:24:01 +0000
Message-ID: <819aa3e7857d8213cfbf84356834a5a57eb75074.camel@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-6-elena.reshetova@intel.com>
In-Reply-To: <20250806081344.404004-6-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB6142:EE_
x-ms-office365-filtering-correlation-id: 86d21d11-fd1a-44fd-8c3a-08ddd548b597
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R0J4RVJSanJBRkU4MUdoZWN6V1JrVG42UEMrUWpadDZOdnlCS0lUOXZzWGNs?=
 =?utf-8?B?dDZTSTRRVHVibHhXNHVjcmZFa0hwYVhTUWd6bjE4Q210Q0licVl2UFZNYlBM?=
 =?utf-8?B?bWZzUG83b1dqdkhXT0FHc0QzZzZHcjBtRE1mdlJoVS8zRmVHaWE5TnE5Q1Qw?=
 =?utf-8?B?elk4MEdxb0FMbUxldmhDV2c2bStKVm1vQUFWWEpSeGNGdlRPUlp3c2pDU1N3?=
 =?utf-8?B?T2dYOHh1MVNHS0IyRWhPeUhieFhnZmYxVXNTY3RET2o2bmgvNlJVdGVTTnpB?=
 =?utf-8?B?aVJwRlpXSnVheGk1ZHJaU0xSblBQQnRCUXdGMGdTWURQVm9oNUp6cm5YWUtV?=
 =?utf-8?B?NVBVSVFUWWFaKzE2U2xqUm9TVmd6emdWTER6TVZ0bE4vMEpiR3VFVkJ4Y2xi?=
 =?utf-8?B?RUtBaDd4VDZEM01WMXdjbFNuS0VuRmYyZi9vdmhHaHdMdU1Cc3l5N1JobGRG?=
 =?utf-8?B?UUF6S24rbnFIL0luS1Z4bWlLbnhIREs2ZUpsM2xKQmFwc2xqd1BVZFFXZlVI?=
 =?utf-8?B?NCtDYzliVStqQUYzT081ZGpDa3BiUVFELzdpczNuTW5nL1V5a1JWMU41N3J5?=
 =?utf-8?B?a0d1S1BHenljVW1wS0ltYlFHVm9Zd3ZnVW9ETzJRcnVRV3A5YXJsZUZ3NHpM?=
 =?utf-8?B?QmUwdDkycGUvc1RGWUxoS1Y1TXVpRW5lZW0rNU5qRkRVUG5qRlMrSUlqUVAv?=
 =?utf-8?B?L0txL1NHVDFNNkVpMHFwMStmb3lLMXh4c1BJazM3MU5XMVZHeTk4WkRkZTJQ?=
 =?utf-8?B?Z21MS3BzTklnOTg2QmFJejh0Sm5DeVlaWnM5MGNsR040T2ZlVUJuYzA5Tjhk?=
 =?utf-8?B?UTFsUml4a0taTzlVL2dqK1NMK2VoaDhVbkh4cUF4YTRFM2x0OTdGM1VlRGVj?=
 =?utf-8?B?bkc0dnFkd0djd2pjbEcxRmZ5NG90Yml0Qjc0eGtDZGZ3bFBZSHR4ZEJXSXF2?=
 =?utf-8?B?MGZXMExBaUVEb2lHUmVmS04rSEw5NXE1dTQ1dnVNOEg5WUZYWU1SQTRJY25h?=
 =?utf-8?B?NjgvZjFYLy9wd3Irc2UrTnJhcFQ1UUF6OHdJeHQ4TWZOSU5xNWE0SDgwNXR1?=
 =?utf-8?B?eEFQV0FlLzQzc0ZBa3NQcnJVZTJOQThFWDJKL2JzeTlmMW91c3QwaTFScEdL?=
 =?utf-8?B?YnRmNCsrWE5uemlvS01vQlg3V25VamsrcWlpUzVIMVRTRkFZcGJxMU1GR2Y2?=
 =?utf-8?B?WlRXZ1BHOUp1RE4wQ0xwU1NCVnYveWRqSlIxVXFSc0NEbTQvOS91TlVDdEx5?=
 =?utf-8?B?ZWg3Vzk3blAxRjV2WUQ4djM1MkFmejM5RUJKbzIrWWJwcTArRTllVU5JaEJI?=
 =?utf-8?B?MEk5MTlvajI5bjdQRVpwOWdiT2NMcVJWRFo3VDNkNXVaSzdmL2RLYWt1YXBP?=
 =?utf-8?B?Tm5ZWDJXZ2FQcEc3enRGUnBuWkM5REEvbjF1QldwbHozZytBbU1lckw0OTFK?=
 =?utf-8?B?MXg2L2FycEc2Z25YVEg1OERmMTRZblJiZWFZamxjZ3o3dC9ycndmQi80MnQr?=
 =?utf-8?B?L3MzS1k5UVpCVjNtcDZ6WEJNMmwzNXBjYWl2dnh3VEt5dUNsWERPL000Nk9o?=
 =?utf-8?B?bXBCcHZCVVl2bnNQVCsyY1AzbFZDSFFZSkZQV2tGNkRzZ2o4V0JrbkwyakY3?=
 =?utf-8?B?TVNya3Jwc3BpS2hJQVNXNWwvNGh6SEpwclRpMDBRMEZGR0Q3bTZOdlZCWHFx?=
 =?utf-8?B?MXZ6UjFMd0twTm9QV1pTalZSOHJ3aWgvN1g4YjhDWWxkazRwL3pzMXFCZHZa?=
 =?utf-8?B?QXRyK0dGYWw5YnNFY2x0SFRDR1EzS1hnOFZnZS9DQWE4TEpONFNkY29mMnBs?=
 =?utf-8?B?UGhockdGNmUyWTdpcWg1bXhJeERHLzMyaXU4bytoNUFEblQyQkdRa1JpYlNU?=
 =?utf-8?B?QWhHS1g5N3VnU3hwUlRhR2sxampZRDNFWU5POXVZZ1B5c3pNTE5jTlhuV0tT?=
 =?utf-8?B?V3JOTFpWelFFWU1oMnlkeFdiYTgzeHdCbHRBQWpEUE14WjREQ0YwNW0zTmsz?=
 =?utf-8?B?dWdoM1c1dHlnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnRLYkZVTklWQzV0TzRNK29oUVNFK0lMd1JUc0R6dnM1M3o2cTZzTzVxZU9S?=
 =?utf-8?B?TGl2NzF2WlNMQW1wMVJGOTVnczM5TkJWdDc3TkhQYzdIY0NURERwV09XTk5i?=
 =?utf-8?B?NUkvbGdQaEVvRzRCV0dPT202MDVubXc0Y0pqS1Qvd1E2bHQwNDlGQXY1V2Z4?=
 =?utf-8?B?Z0NZZGs1SHZxY1dlMzdsRzF1SzlPZnhDbVVZNUx3T1FQaFlINnFEY2xxL1cr?=
 =?utf-8?B?YW1CeHcvRUNHUlB3VHJReGc1MmFnVkVmTUpPcEROdFc2THF1WWdKVVRCZzZC?=
 =?utf-8?B?aWY0MFhFVW51UldYRUFaTFVydlQyMmQzcWI1YmxLZCtJNjNma1p3V1dKMjVB?=
 =?utf-8?B?dkc0TlhzdlVabzFIVXNxQ2FKcVJhN3JaNFU4Q3pnMllBSXErbHZZVkg3bWdu?=
 =?utf-8?B?dXVYRE81U3l1N1FoZytxRHhTd1F3K2dnYmJKVFlkUEdGbDhKYXhYc0NadE1G?=
 =?utf-8?B?RHIrdHlqRXp2ek0ydHc0VXlDTWZma3NrKzJaTStEVVlzbEFBUloxYkRYbnQ4?=
 =?utf-8?B?b2t6QURFdDFEUEg1bUxlZ1RjVkROeHJDOUlOMzNyc2FzY09IbTJhVDF1dnlP?=
 =?utf-8?B?WUYrdXE0TVdxMzdab1hES2JrZTBpc3lVaytLQ3dlTG5IcjVtaUo1Q3FrN0lV?=
 =?utf-8?B?QW5JaGdZRjRiU29aM0pvbWhkUzFQc2dRWFJCV0hQc1RWT1VaRHp6Sm8yTGE1?=
 =?utf-8?B?YmxQT1MrVmx1RFJvT0Fxc21SU3I3dEFTVHFpdVRSVXhvNURWck9aeVdMZmF5?=
 =?utf-8?B?WWtmUGFsdGU2K0E2eityRjJMUzRhaXBjWVduMGhLekUzTUJzd1VQZHpEQVlt?=
 =?utf-8?B?bVZIRCs2M0NIczA1dzJBbjlYUlAvTUlUUmNXMlA0MW8vaGZ1TjZnQXBYTUZz?=
 =?utf-8?B?VnpaVGZXT1h2dDlYRUZsQ25abER6T01lYy9OUmljSUF6UEYxcnVTdnc1ZTQ5?=
 =?utf-8?B?TjRON01xQUdWNjM4RzBQM1hWK1lVS2ZmaHVFUVpsTnp1TncvYTkvekRoZGts?=
 =?utf-8?B?NFA2Z1Q1VjBDRTI4WUlSTHJCSGlNZVpHM0JZOW92L0gvOGovdEo0K0VicGZS?=
 =?utf-8?B?WG9oWGQvWGc3V1NxZkcwc2IyMWwvZVMraU53bnprNm44c0E0d0pxaWZCS3Bo?=
 =?utf-8?B?WXVLTFN3eE00Q2JObnJRaHZXc3BvVWFqY0JiSE9xblZLWFhNd1FiZmVGQ2JN?=
 =?utf-8?B?Yzc0cmRSSldzV242cS9CRkhBSWpEWFpPU2lrNnlHZEdFQitMV2luck05UFZt?=
 =?utf-8?B?NllIeFRsaW1UZDVrbHBWRTdlbjVza2J4Q2JySmxOQ1UwRzNrR2d4M0Q1VFZ5?=
 =?utf-8?B?bUhHaW1pQjBxVmdVZDMyUkcyR09UVjB4K0ttN3Z6M2xXZm1uYnN0VEZ2Sk5Z?=
 =?utf-8?B?OTI5OXRUMUZLVzAxeUJkWCtEbHNwYWVpV3ZKQ0ZxYXMwUWMxWmZNTXF4Zks0?=
 =?utf-8?B?OVJGSld1OHJOdHNrZlQ5OXRWSUlUL0l4NU5zNEdXT3IzYi8zQURpTDl3cXN6?=
 =?utf-8?B?eENnODdGd28wNERtbjhzbnBXR2piZllPVW05d3VjY1R5WVpXNGxxMlRvN2o1?=
 =?utf-8?B?VGNuUzJzOHQrRjdHUmhIV1JPTTRLT2czWHhOR0dCM2xTT0dIand4cTQyZUh6?=
 =?utf-8?B?ckcrNjc5d3VURGJidGY4eVoyZTFhK2VUMElYTTI4aFRHajlFZVhHWkVrK3lK?=
 =?utf-8?B?OFJ4OWlSV2trNkhlSE93MUZxRDRNTFh0d1pjaDBJcWFodzB5eFNEeDYrMTdl?=
 =?utf-8?B?bE5wVXpJem1lbnJ6WENEYW9GdWdDZi93eU5LVTI1OUFFdjJYbDBWUERrRTh1?=
 =?utf-8?B?N3BuamtxcWRJMk0yK3I2d0dGRHZoU1REVXAvRkZnUTFnZjJxU0tDWXNZUjgx?=
 =?utf-8?B?VUh6TExmQ21wWnVERXhjRGU3Qi9Wb21CeDZzaDRxYXdldVBYa0VaZ3BSbEoz?=
 =?utf-8?B?MjNzVy9WMEVGQmhPbTVVNWVBUDk4bVFsWkdXZ1RIZVhtWGtEYmRuY0xscUJJ?=
 =?utf-8?B?Rzc4SVdnSmV3RURuWkZMWmJtQ2MwVHc0ZlQwcFZkUGQzS2x3WGJRZ0x6Nzdp?=
 =?utf-8?B?RXgvMW9TUmh2eCtodFBkZ1lHVXNXWlVTbFVuZWdoMjRCQXpiU0swVlhFa0ZI?=
 =?utf-8?Q?p41PXTLx9drlYjxymJ1jh0m8p?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <680D2FDCD063914FA64D138582F538D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d21d11-fd1a-44fd-8c3a-08ddd548b597
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2025 00:24:01.7326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JtZLsWNr/dTaSqYdA2uLHkjkr1chGSVfNDltl8RPp34Kps4z6xBa0wNbptwxtK/fUn9znUgu9zY29/PtbAaO+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6142
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjExICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+ID09IEJhY2tncm91bmQgPT0NCj4gDQo+IEVOQ0xTW0VVUERBVEVTVk5dIGlzIGEgbmV3IFNH
WCBpbnN0cnVjdGlvbiBbMV0gd2hpY2ggYWxsb3dzIGVuY2xhdmUNCj4gYXR0ZXN0YXRpb24gdG8g
aW5jbHVkZSBpbmZvcm1hdGlvbiBhYm91dCB1cGRhdGVkIG1pY3JvY29kZSBTVk4gd2l0aG91dCBh
DQo+IHJlYm9vdC4gQmVmb3JlIGFuIEVVUERBVEVTVk4gb3BlcmF0aW9uIGNhbiBiZSBzdWNjZXNz
ZnVsLCBhbGwgU0dYIG1lbW9yeQ0KPiAoYWthLiBFUEMpIG11c3QgYmUgbWFya2VkIGFzIOKAnHVu
dXNlZOKAnSBpbiB0aGUgU0dYIGhhcmR3YXJlIG1ldGFkYXRhDQo+IChha2EuRVBDTSkuIFRoaXMg
cmVxdWlyZW1lbnQgZW5zdXJlcyB0aGF0IG5vIGNvbXByb21pc2VkIGVuY2xhdmUgY2FuDQo+IHN1
cnZpdmUgdGhlIEVVUERBVEVTVk4gcHJvY2VkdXJlIGFuZCBwcm92aWRlcyBhbiBvcHBvcnR1bml0
eSB0byBnZW5lcmF0ZQ0KPiBuZXcgY3J5cHRvZ3JhcGhpYyBhc3NldHMuDQo+IA0KPiA9PSBTb2x1
dGlvbiA9PQ0KPiANCj4gQXR0ZW1wdCB0byBleGVjdXRlIEVOQ0xTW0VVUERBVEVTVk5dIGV2ZXJ5
IHRpbWUgdGhlIGZpcnN0IGZpbGUgZGVzY3JpcHRvcg0KPiBpcyBvYnRhaW5lZCB2aWEgc2d4Xyh2
ZXBjXylvcGVuKCkuIEluIHRoZSBtb3N0IGNvbW1vbiBjYXNlIHRoZSBtaWNyb2NvZGUNCj4gU1ZO
IGlzIGFscmVhZHkgdXAtdG8tZGF0ZSwgYW5kIHRoZSBvcGVyYXRpb24gc3VjY2VlZHMgd2l0aG91
dCB1cGRhdGluZyBTVk4uDQoNCkEgbmV3bGluZSBoZXJlIHdvdWxkIGJlIGhlbHBmdWwuDQoNCj4g
Tm90ZTogd2hpbGUgaW4gc3VjaCBjYXNlcyB0aGUgdW5kZXJseWluZyBDUl9CQVNFX0tFWSBpcyBy
ZWdlbnJhdGVkLCBpdCBkb2VzDQoJCSAgICAgIF4gY2FzZSwgc2luY2UgaXQncyBqdXN0IG9uZSBj
YXNlLCByaWdodD8NCg0KQ1JfQkFTRV9LRVkgY29tZXMgb3V0IG9mIGJsdWUuICBBbmQgdGhlIG9k
ZCBpcyB0aGUgU0RNIGFjdHVhbGx5IHVzZXMNCkNSX0JBU0VfUEsgQUZBSUNULCBzbyBpdCBjb3Vs
ZCBicmluZyBzb21lIGNvbmZ1c2lvbi4NCg0KUGVyaGFwcyBqdXN0ICJjcnlwdG8tYXNzZXRzIiBp
biBnZW5lcmFsPw0KDQo+IG5vdCBhZmZlY3QgZW5jbGF2ZXMnIHZpc2libGUga2V5cyBvYnRhaW5l
ZCB2aWEgRUdFVEtFWSBpbnN0cnVjdGlvbi4NCj4gDQo+IElmIGl0IGZhaWxzIHdpdGggYW55IG90
aGVyIGVycm9yIGNvZGUgdGhhbiBTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFksIHRoaXMNCj4gaXMg
Y29uc2lkZXJlZCB1bmV4cGVjdGVkIGFuZCB0aGUgKm9wZW4oKSByZXR1cm5zIGFuIGVycm9yLiBU
aGlzIHNob3VsZCBub3QNCj4gaGFwcGVuIGluIHByYWN0aWNlLg0KPiANCj4gT24gY29udHJhcnks
IFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSBtaWdodCBoYXBwZW4gZHVlDQo+IHRvIGEgcHJlc3N1
cmUgb24gdGhlIHN5c3RlbSdzIERSTkcgKFJEU0VFRCkgYW5kIHRoZXJlZm9yZSB0aGUgKm9wZW4o
KSBjYW4NCj4gYmUgc2FmZWx5IHJldHJpZWQgdG8gYWxsb3cgbm9ybWFsIGVuY2xhdmUgb3BlcmF0
aW9uLg0KDQpwbGVhc2UgY2hlY2sgdGV4dCB3cmFwLg0K
