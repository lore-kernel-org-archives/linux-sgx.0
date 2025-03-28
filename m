Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CF61AA1EC;
	Fri, 28 Mar 2025 09:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743154567; cv=fail; b=m/wZ8gTl3MuoxjY9Ksda7t6+q/DcGpQVrwvnPl3wEKvlCoYfQ9cYv9Mvv0Gq4zhSO2eSsrPAbdugFz/CKQBTt9Kz2844XovqPzYdAJUvhq2J8L4ePXZ2l0gL7HOk6ZXwQ4GiHOG6+6bBsJ8yWwGxa0HDoNwaK7VkIWy4lJFBL5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743154567; c=relaxed/simple;
	bh=TbdXhpEYvfSCr9FYmBO35hpml0hXuE3m483sTe8U84A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FaqBmHZv8bW+/p70MxWbmPar7DuamB59Ty7simIRomWmSd8BJ9ToPEQb4d1DFy+6NGGIAEOTQZ9z6Bka9e8eK0s92fbff8Ii/U85yGOeaF2lnGk4KTVjN+0etGvRN1vJKq/sddnH6QgTPgeWGjm5Tw9Q4bXjZdlR6GQcl6Xiq5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=maPXX0PE; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="maPXX0PE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743154565; x=1774690565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TbdXhpEYvfSCr9FYmBO35hpml0hXuE3m483sTe8U84A=;
  b=maPXX0PEH1/Y7EQLxcycUPcxy5e2QKwZR8voM4+C+TZGSFBT5iU7pdvQ
   El92qKPDVw2iynDTU3ypfj1e3bQSrOL6KTaDI6QSVqqZm54JJo2jf5wBY
   fbyc6a7UlTjGchHvNnapee5+HvI9dZrB+rXbhkK3VpCkPT9D6Wq5cNnGC
   m1mh3Tyh5xBdoj00V9Vki248J4ZJ5jgYNUonosHGiHfJKg7IawoM0IZZk
   vs+qEpO5EbKpzCn0mPo0rgbEvrL/RWzIomx0kG4NP86sj3IAk6l8S6GCB
   RGQ7CfhZ8D/CZm7WxBVaFu982S4ZVmmk7yXm40YIZkLA+b9ryrYhW3Wdz
   w==;
X-CSE-ConnectionGUID: QoamAF5BQoSyRzPx4eFuJA==
X-CSE-MsgGUID: P+AmqQg7R++cFCcVyZpOSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="48293579"
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="48293579"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 02:35:36 -0700
X-CSE-ConnectionGUID: aVWw1N2PSoK0MB1R3mHHcw==
X-CSE-MsgGUID: dQtVUa62T9+LHQIiWYAQWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="125402461"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2025 02:35:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 28 Mar 2025 02:35:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Mar 2025 02:35:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Mar 2025 02:35:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ACJX0UyV9XBf/CImiZiZxajbzQ/jtSFoRVMSy76lD1H7M5I0gGt9LybPLaG+ho/rj5hzgfIUO2pJ+VHdJHtHrhBsv1WkRg+XF117vbUvDAiyGFWfzd+HNRtuJ4ZcTrpf/1FPGByVjiuEUlgIyGd/Zg3noOg1PD1GKRewVfHi9++L71J4Y3fvYlfY0PGZN9jdtoHRVEZmq34cqkt5IjZcw4gnruV3j2ZmtoyL6TF3GYr4MWWvioFpUQrczGm/2xdOSo8PNfsVtEULDIi3qUAb6P6j87FCAaG7EttGPIraxf+Q80nJ4DHK6LxCQoEwcKKS2jUg03Az390pHvJTHmwa9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbdXhpEYvfSCr9FYmBO35hpml0hXuE3m483sTe8U84A=;
 b=r6YDaCAaOW2tIDxmZWUQBCw6ggDIT2Nox5y1NKV5qvJBil+hIHYqfU4oOEqEMhIeI4I832MtGGDej/EsMfWTJYtloFmheRk3Qd36pp8lRZi0u5srllUt4zwquO+pfSMEAtI4QrUXfFeuzcNNxV2dc+8RSWjYhqiHgpT4up96ObwkX+7TIkQt5Qx5dD8mYKdDHEnebiuPKqHWIC6sYrVbRph/ljQQEk2ogUifY5hiHEzGaCKOo6lG0HO5gB1DM0qLr9H/EDDmanXy5k3zJsJCDiG+x6s1ruIGQ/CT2AzG1JsmjtDtKUAOWvF56OMd6T4aTe7kuJtvlB9zoOPWV70WEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 IA1PR11MB6514.namprd11.prod.outlook.com (2603:10b6:208:3a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.48; Fri, 28 Mar
 2025 09:35:33 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.040; Fri, 28 Mar 2025
 09:35:33 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>
Subject: RE: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Thread-Topic: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Thread-Index: AQHbml52rO5WRn4U4UWiUGJJakHgYrN/tmkAgAJ/A3CAA6SegIABR0IQgABobwCAALEwoIAACvKAgAAORqA=
Date: Fri, 28 Mar 2025 09:35:33 +0000
Message-ID: <DM8PR11MB5750A5423709862939946F45E7A02@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-2-elena.reshetova@intel.com>
 <Z98yki-gH4ewlpbP@kernel.org>
 <DM8PR11MB57508A3681C614C9B185B04EE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RY8-bL2snpRKTB@kernel.org>
 <DM8PR11MB575029FAC2C833553CE422CFE7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-XDFDj8Tc5i-GBg@kernel.org>
 <DM8PR11MB57503621B1D7674404A62004E7A02@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-Zg5elc0xTwoxat@kernel.org>
In-Reply-To: <Z-Zg5elc0xTwoxat@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|IA1PR11MB6514:EE_
x-ms-office365-filtering-correlation-id: 1c2f30db-13a5-43f1-2539-08dd6ddbe30e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MGhrdFZIVklVbmYrOFJKZTIvTmtkSy9xMXlyUEthcVY0c1J2T0dCelZmcVlj?=
 =?utf-8?B?RmV5aXA3aTN0Y0hYeE9iekVPUUt0Qk1yYW9TVmhpU2tDeW9zVkg0T1ZmNWNV?=
 =?utf-8?B?dlgyOVY4MDlSc2VKcmpLbkJZZ3FKVld6emRaSXFGaUFkbklLMk56RHZkNWxv?=
 =?utf-8?B?Y0I5K1I4UE5DZGZOTkZLTUUybG1EQ1dLOGZ2MWhpTnE5WjVidlhnWk9qbHZy?=
 =?utf-8?B?bU90MDdRLzZkS0RiM09peTZ2eGZWY24wZEhwZXlyOGZZWmEvT09wQjJwSlRx?=
 =?utf-8?B?RzZyaTdGQkxKVE1WWUpZMWtXanhFSjJucmhnbGhpR0hkSUFDMEloQnA2WUtz?=
 =?utf-8?B?ZUNOazJxYlVnMm5ZYmtUS0pDZ1lIMHBlcG5zSnNxbGFwME5UTFRzekFrcllM?=
 =?utf-8?B?N1VpVHllbHlvVXpnQ3djYUN2NGFyUlExTEE2K3FwYmduYW5GUzhiTUlPbTNi?=
 =?utf-8?B?citadmpnYUxkUXJjY1hCV3ZCOThnWGRqcnFZeGhlTm5qU3hHR2t5YkNwN0s0?=
 =?utf-8?B?a3JBS3JoYWhyc09DNmtYNDFlQXIxb2d2cFNsd1Z0dzRoVVgrZW9HdUJKaVhq?=
 =?utf-8?B?ZlZSTGF4Y1NzSE93eC94YkU2SHNNdXBIWHJ0VFVlcUhGVFEyUmZVUmFnYVgx?=
 =?utf-8?B?dExBM3VFNHM2cXBGelZyUGl4WGplR25iUk05Uk9ja3JrN2pnQ2tuWk45WGt6?=
 =?utf-8?B?cXRNcW4rWFBJV1VOdUdzUHlvb1Q2L2djK2JnSVFmU3FVdk80c2NEVVMyaUtw?=
 =?utf-8?B?QlpnYjhkT002QXhlQ3Q3eGJ2QjlaN09EMVJES2RZNEQvNkdxd3NzeS8vekNo?=
 =?utf-8?B?MEZNaENGeWxjZzNOVXB1aGJwajh0T0RQa1hUMytjTStCU1ZRM2tPbGU4a1U0?=
 =?utf-8?B?cCtoZWNBVEFDcEM2TStZVElnZG53UlY1OU1PdHhZUnVlVVVKRldkb2Z2VDlu?=
 =?utf-8?B?N2VncDl3cUVsSDJxRTZrWndwc016ak5qVlVTN2M2QmJOd1VhVEUra1h4V3lM?=
 =?utf-8?B?YzlqRytUWVRQaVZlekF5QVR2SjM4TDArc1ZGbnBBNEppMW9Kdmw1eDgwbFMy?=
 =?utf-8?B?bC9KdHMwNDYvUmxuSVVjZVJrK1VUbk1ZWHpmYXI5Q3VvdVZBZGFMb1o5QlpH?=
 =?utf-8?B?VnYxME1CTHhxbEVOQUxwTWVnMmtLbkFMRnJtQTl5RFNDQ3pnWXZJY05NdVl6?=
 =?utf-8?B?U0ZuV28zRnkxQ2Z4MklVUkgyNWtTbmdEUG44VE5OUzloRVZsUEtidmNWQWRk?=
 =?utf-8?B?RW8vZjFlZ0pvWG9qTXBScEJtejcwS2NUUzRRL0RoN1JhTjdCWWpSa0xMK2I4?=
 =?utf-8?B?Rk1HclQ5Qy9TMlpUV2ZNTVhWbmlWSWVaUVpnenJNTEcwVWozMnc4dUF1bEhH?=
 =?utf-8?B?ejZTbXN4SEdVbHZUMkNjemtpbkxaNERJWndnMmROWUtqSmt0a3RUMW5ZR3lY?=
 =?utf-8?B?c2wxdUZveGdtNCtzaCtMOC9qK0Y0RG5OUGp2SWM4TDkvOUkraE4wUDVjRGhC?=
 =?utf-8?B?dVk4WmF5U29sZmxzUzdEK3pxa1cwY2U5enc2ZnFmYVY0bTBwM1pSc1NoNmpI?=
 =?utf-8?B?SFV5ellOTzBRT3VOZWtaRytjaC8xYTFBbG1QaEVMMWw4Zy9WLzdkcVpMRWl5?=
 =?utf-8?B?QWVaQitGNWs4NGVPQnRkb0s5czRkd1YvbzYyZnhtZHd4YW1saTFGM01sdEY0?=
 =?utf-8?B?YkptU1hpa2s4aHQza0ZUKzA2M2RUdVUydXdIeWNLT0hBSWZFcXFlS1JZOTgy?=
 =?utf-8?B?WFMwcW10Skg4dkxsZHdSYXJwZU4zZGhwaUtCU3FuYm9uTGF6K3VDcWYrUUJT?=
 =?utf-8?B?UlVBSC9uWC9jM1RZYlBENFBFdHVUOXBjUExUdUdxTTYrN0taYk1SZW1mOHYr?=
 =?utf-8?B?WHh2bUFmMzFKOXA5TUx2aWpyRk5PckJocmVTQkRPTjNmYjkwZGdKUkdFcWl6?=
 =?utf-8?Q?ZElZUuindEchvDivGSelPxpMoQgAII3x?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzY3U1FGUVIzUEJlOVVrVll4LzYvS0Z1empYdGJjdUZzTjV4ZXo1KzhtVGZX?=
 =?utf-8?B?ZkdGeHh1Nm5uV01NYlc1dG0vR3BMaVhIQzhiMlQxU0pwQ2dKaXZ4RDVvT2o1?=
 =?utf-8?B?TmdDa3FLMDhiVEpXWUZFVXFEUEtFSXlWbm5Sa2dwK0o2eXdOSnd1NFBMQng4?=
 =?utf-8?B?Vk93c21EbUxEbTRTUExnTWk4YjdVSHRsN1BoYnRzUEJpUG54bUFkSSs1c2tq?=
 =?utf-8?B?Z0JvZ2ExT2RuWEFyRXArVGpQR1c2SURrZjlWc3lsV2JxUzkvbzVqSysvOExa?=
 =?utf-8?B?cHg4VWlIcUthMXJPME1NNm5iSkpmZm5xK1VITkkyWmJMd0Yrbk5vZit1R1N6?=
 =?utf-8?B?S3h3NG9KZjB6aUlWaEJiTlE1RzZZQ0l6WG5YYW5CMXdzS21LNVBlck1LU3Jv?=
 =?utf-8?B?NUVHa1hza2YxSURxYXA4TTY2RjdFSzNIN0dNZE94YlRiRWNkbmVFcGQvejR5?=
 =?utf-8?B?cjNNYk51V1ltQkF0WVUwNzMyQ2ZITi8zSitSKzBnL0RlMDhlcThWYkgvWGow?=
 =?utf-8?B?YThZQnBMbi9Ib2YxZllrOVczUHZSdmVGOXpxa3pnRjRWUnd3dXB3dlZ6blZ2?=
 =?utf-8?B?dDZXRWxsbEhtSlRlZERSM3lEdkkxdG9uMW9xTGxhYUx0UjIwRHh0L1Ryc1pV?=
 =?utf-8?B?OEZvSzZac2RETWFBTmdpVU1mUUpHRHJBZENkazMwQThwbUprWGhUNUFOM2I2?=
 =?utf-8?B?ZXcxeUM0VTQ5UXZWWEdwZHp4VjFLeVdhTUpMTEh1NUhtUUpFaGdIUlRsWmpx?=
 =?utf-8?B?WUJHYjJ4WmFDRXI3REhSRXZBY1FnVEYyU241ZFgwQkZMb2hBYTZBWEtnRHdY?=
 =?utf-8?B?Yzl4aDFiYThKYmZYczJ6ZmZaaFc2UHR1V3piOTdZNVJUQVZsRG1pdTFVMFQx?=
 =?utf-8?B?K1paMm56TEhrU1llWmtKOXJpTzVuamxHM0d6cGl5c0dGckdhVGh0Ti9mT09l?=
 =?utf-8?B?WHh3NEllMjhCc2pCaVRQcHB5aGJLOTEvUDNuMXBPRG1uWVAxWlQzN29LekZQ?=
 =?utf-8?B?NXVvZW9pb0o0RWxJY2Z5b2FTc0dHbG4rZ3lzVmRQbjROSEVrWmdlVGo1c1hO?=
 =?utf-8?B?ZmZuRnJ4c2JCTDdiRUdhWW9sWWRWSXpQeUdjcWpxRGJwWjFNU1NGZHM3UFRh?=
 =?utf-8?B?MFQ5Y3A2MXU2Rk5pRXlDOXM1d1BqMnNmUlF5TlpIaDlVNFJycWNnc1IzcTZt?=
 =?utf-8?B?V3pVcFpkZlZ5SzNEUXNNS3VqbEZHZHBkV0RHVVB6bWNkaXJ6Tk1GMy9GVVZy?=
 =?utf-8?B?SkpzMU4vMjhua2hYd1d4M2I5ek5xaXZ0SWRjTDB5T2VZMFJvY0hHbXhkRHRW?=
 =?utf-8?B?dkJ5MlZYWWlUMGx4TXVkOWxqRVV5cUEyVDBGVUxxZUFHOEpNd1VJM0w0TVRy?=
 =?utf-8?B?L3VQSWJyNEp2Nlp5L1dmNzRadExvZ0k2ekxqSDl1UEhJdXZ6YzhZZXFaQmlz?=
 =?utf-8?B?KzlwMFdhSUdxUXdXVEZvNVZETlBMd0Uzb0w3YURlSDlIcWg3VlpTS1RjVUox?=
 =?utf-8?B?TnBOUXNJU1FJNHlwWDl1YmtwUHg2bFc4Z0VISXlYelhuU04za2xuRUs3bzhs?=
 =?utf-8?B?QWFRMmt3SEtOS2o2cUdMakNHVTUzZGQyQ29GODFiNW9lWEtGNkFpbTJiMHNG?=
 =?utf-8?B?Vi91b2Q5NDlteUZlbktId2U5NGlFTFhLcDNrR2RLSk1nSWkxMkcwekJkSEIy?=
 =?utf-8?B?MnhpdG1DbHNCSndLSXdudjJ5eFlEd2xEWngweFdkNnlwNWFVKyswbnZsZnlI?=
 =?utf-8?B?M1lIZkhwWWdPdFp6aXBJK0M5QjllQUpnSG1SR2xWZVhUZnArcGVYSlN1WDVk?=
 =?utf-8?B?Vk80WXZ4Nk52dWl0ek1QZUNYUTV1Q0NpMTJ5cG5iR3B0L2dZTWxSMkltMVRC?=
 =?utf-8?B?dUhYV3U0SFdPQUNZckQxemN5Q0FOODZPa3hjRzNndnNkN2VHNm9ST3FwelJD?=
 =?utf-8?B?V3NQRkxjUlEyQ3g5dE9tZFN2V1krUk5SMEJYYUIzMkJ6VEZYQVVMUy9yeVdm?=
 =?utf-8?B?YjY1QXlMS21XdkxHWHpxNStPeHhRQTRhN0VZTUtib2dtZG1Mb1grNEpvZG0v?=
 =?utf-8?B?bTVxbzhKNEFnT1BmdnY4ZlJBTTN6RHVZZWU5Z0F1aU9NeENwRThWT2E1eGpK?=
 =?utf-8?Q?YJTk34AVfU9Eel50/BBY8G7Ep?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2f30db-13a5-43f1-2539-08dd6ddbe30e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2025 09:35:33.0973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +VIh7FIVSHpWZ3wiW9elDErYwH3oC13IqAsdoSJADJqLm1MvHgB8j8X/q8q00skHLlLA/H632mfTUvrpxWRMpkXV0cKYxVYpWKSQxee6fuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6514
X-OriginatorOrg: intel.com

IA0KPiBPbiBGcmksIE1hciAyOCwgMjAyNSBhdCAwODowNzoyNEFNICswMDAwLCBSZXNoZXRvdmEs
IEVsZW5hIHdyb3RlOg0KPiA+ID4gWWVzIGJ1dCBvYnZpb3VzbHkgSSBjYW5ub3QgcHJvbWlzZSB0
aGF0IEknbGwgYWNjZXB0IHRoaXMgYXMgaXQgaXMNCj4gPiA+IHVudGlsIEkgc2VlIHRoZSBmaW5h
bCB2ZXJzaW9uDQo+ID4NCj4gPiBBcmUgeW91IHNheWluZyB5b3UgcHJlZmVyICp0aGlzIHZlcnNp
b24gd2l0aCBzcGlubG9jayogdnMuDQo+ID4gc2ltcGxlciB2ZXJzaW9uIHRoYXQgdXRpbGl6ZXMg
dGhlIGZhY3QgdGhhdCBzZ3hfbnJfZnJlZV9wYWdlcyBpcyBjaGFuZ2VkDQo+ID4gaW50byB0cmFj
a2luZyBvZiBudW1iZXIgb2YgdXNlZCBwYWdlcz8NCj4gDQo+IEkgZG9uJ3Qga25vdyByZWFsbHkg
d2hhdCBJIGRvIHByZWZlci4NCj4gDQo+IE1heWJlICsxIHZlcnNpb24gd291bGQgbWFrZSBzZW5z
ZSB3aGVyZSB5b3Uga2VlcCB3aXRoIHRoZSBhcHByb2FjaA0KPiB5b3UndmUgY2hvc2VuICh1c2Vk
IHBhZ2VzKSBhbmQgYmV0dGVyIHJhdGlvbmFsaXplIHdoeSBpdCBpcyBtYW5kYXRvcnksDQo+IGFu
ZCB3aHkgZnJlZSBwYWdlcyB3b3VsZCBiZSB3b3JzZT8NCg0KU3VyZSwgbGV0IG1lIHNlbmQgb3V0
IHYyIHdpdGggdGhlIG9sZCBhcHByb2FjaCwgYWxsIHN1Z2dlc3Rpb25zIGFuZCBmaXhlcw0KdGFr
ZW4gaW50byBhY2NvdW50IGFuZCBiZXR0ZXIgcmVhc29uaW5nLiANCg0KPiANCj4gPg0KPiA+ID4N
Cj4gPiA+IEFsc28geW91IHByb2JhYmx5IHNob3VsZCB1c2UgbXV0ZXggZ2l2ZW4gdGhlIGxvb3Ag
d2hlcmUgd2UgY2Fubm90DQo+ID4gPiB0ZW1wb3JhcmlseSBleGl0IHRoZSBsb2NrIChsaWtlIGUu
Zy4gaW4ga2V5cmluZ3MgZ2Mgd2UgY2FuKS4NCj4gPg0KPiA+IE5vdCBzdXJlIEkgdW5kZXJzdGFu
ZCB0aGlzLCBjb3VsZCB5b3UgcGxlYXNlIGVsYWJvcmF0ZSB3aHkgZG8gSSBuZWVkIGFuDQo+ID4g
YWRkaXRpb25hbCBtdXRleCBoZXJlPyBPciBhcmUgeW91IHN1Z2dlc3Rpbmcgc3dpdGNoaW5nIHNw
aW5sb2NrIHRvIG11dGV4Pw0KPiANCj4gSW4geW91ciBjb2RlIGV4YW1wbGUgeW91IGhhZCBhIGxv
b3AgaW5zaWRlIHNwaW5sb2NrLCB3aGljaCB3YXMgYmFzZWQgb24NCj4gYSByZXR1cm4gY29kZSBv
ZiBhbiBvcGNvZGUsIGkuZS4gcG90ZW50aWFsbHkgaW5maW5pdGUgbG9vcC4NCg0KT2gsIHRoaXMg
aXMgYSBtaXN1bmRlcnN0YW5kaW5nIGR1ZSB0byBsaW1pdGVkIHNuaXBwZXQgcG9zdGluZy4gDQpU
aGUgbG9vcCB3YXMgYm91bmRlZCBhbHNvIGJ5ICJyZXRyeSIgY29uZGl0aW9uIGluIHdoaWxlIHdp
dGggdGhlIG1heCBudW1iZXIgb2YNCnJldGlyZXMgYmVpbmcgMTAuIEl0IG9ubHkgZXhpc3RzIGVh
cmxpZXIgaWYgdGhlcmUgaXMgc3VjY2Vzcy4gDQoNCg0KPiANCj4gSSdkIGxpa2UgdG8gcmVtaW5k
IHlvdSB0aGF0IHRoZSBoYXJkd2FyZSBJIGhhdmUgaXMgTlVDNyBmcm9tIDIwMTggc28NCj4geW91
IHJlYWxseSBoYXZlIHRvIG5haWwgaG93IHRoaW5ncyB3aWxsIHdvcmsgc2VtYW50aWNhbGx5IGFz
IEkgY2FuDQo+IG9ubHkgdGhpbmsgdGhlc2UgdGhpbmdzIG9ubHkgaW4gdGhlb3JldGljYWwgbGV2
ZWwgOy0pIFsxXQ0KDQpTdXJlLCBJIHVuZGVyc3RhbmQuIA0KDQpCZXN0IFJlZ2FyZHMsDQpFbGVu
YS4NCg0KDQo+IA0KPiANCj4gPg0KPiA+IEJlc3QgUmVnYXJkcywNCj4gPiBFbGVuYS4NCj4gPg0K
PiANCj4gWzFdIGh0dHBzOi8vc29jaWFsLmtlcm5lbC5vcmcvbm90aWNlL0FzVWJzWUgwVDRiVGNV
U2RVVw0KPiANCj4gQlIsIEphcmtrbw0K
