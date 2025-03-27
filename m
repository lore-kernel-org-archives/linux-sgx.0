Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C542D19D08F;
	Thu, 27 Mar 2025 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743089915; cv=fail; b=NeUvbUkLpQWZvYFTSOOgmCxDOjiL85pQ+oVUfwvv0Uh7N5ZOdLaszVMgTj0j+NSkGhj1dPMWOXz2SD0AtUhfjhOxGNFpJxc3XGo19nOdVJp/USY3x+c5lDp6/wq6htMblmcBlfp2ejNy5fsKtH2pXOZbEGq+Fu8P7pGRyZROP6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743089915; c=relaxed/simple;
	bh=yjoXs0bmTOxbvzGvMlOlnK2tppIwiBqL1uscBsAACHQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g6GazrINy5bZlqlPXbVKa4GAE2Ra97r61IZJLh/+kiX39Og3ugzUcWFoBjTn3F6BKNCRf6ExmbIBCpL1e2PZIn9kEeWoF6a48zTJOyh8W//S2NJPNK9ch9hhllbUSDbVW4QPY5yMB7W+pwkJpF6SXbcLL51cWgZdYYBkrff3M8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TRXrgaw+; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TRXrgaw+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743089914; x=1774625914;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yjoXs0bmTOxbvzGvMlOlnK2tppIwiBqL1uscBsAACHQ=;
  b=TRXrgaw+ud+G1KzHYXnemDB4ddqhp48ngbIEa3YWDuRM/mAnGFYgQ8Ml
   DaYlfNt3u17rVuvYUylJFVU2YSgVLa9TazigZnq68o4kcIpt//G0zP3jH
   5c3KRk/eVsRD+5H4kZouhuQUE9NcoM/1gJZjeNjH4GnwGYmg8ILpEIVFf
   BvgOGXAt7aZZmD/uJuiwAcawCFCElRTbgOIas7GoE0Rg+Gyep7LZpFOKc
   r6jlW0iEhN2hYS7fGEhc8t4f5gcg4/n2VwysMNPI8Y4IOsItPIXl1FGNj
   t6j6XaKdK2CUaDOWyw0VxFEZ54PwBqwAemE2dBrzXGP40gNmVhNF0w78w
   Q==;
X-CSE-ConnectionGUID: P/2trgFzSzGpmp7vMeZ/wg==
X-CSE-MsgGUID: UYqEouQdRgOv/k3SMX3ehw==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="32033893"
X-IronPort-AV: E=Sophos;i="6.14,280,1736841600"; 
   d="scan'208";a="32033893"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 08:38:33 -0700
X-CSE-ConnectionGUID: eEexnez/TM2Fx9c36XDrXA==
X-CSE-MsgGUID: NeqpIRMrTkep5KZr2bJ7zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,280,1736841600"; 
   d="scan'208";a="125090196"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 08:38:32 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 27 Mar 2025 08:38:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 27 Mar 2025 08:38:32 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Mar 2025 08:38:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BXv+ofhfC0jWJJWQvGfLRZL/JeMFO2B7/N3satnYpX2Y+sbFbbWWVqboPzdzI3qSKuLRh5P6snGfR0yeLl8wVR+I0kpepDC6f4pFRkk0AgJTT3okU6jtPYe6lCx7kUccen2sZsSRbwq7U2fnmvYVSiTtcL///PpJuEhKxozcmtQNEn1t1aIeA8V84TrA4voiLF65VoJVntNXCNuItLXPT5sAHzgVx/EtRYyr79AKBN4rgi++EUgHd/O5Bzl2NSvsq6odQBqeaqbYvMA3y0wfqON2LPQ7mh6v2R8nDaylHP5QucC+9yF0myIqhEqT+mwBB56wFmr18fbWrPxOv+JRHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yjoXs0bmTOxbvzGvMlOlnK2tppIwiBqL1uscBsAACHQ=;
 b=Ans+VDyBw7QfV18K/I38gv/6nZ6XtV/Z53Xuskwni0nEi3RhP+fydKzWkQwKNOtS4bRqRrBqW3o+WmgQB9InzXnGvjcQTz26c1qz3zPe36BtB0mZmbkl/D0gqX0uHKK9kfvsc+AkDdcaPOrcXkRRAEZ22a7H+MLqV5BU4bcrTkkGxZEZlGCeWSEyTYvhhS9W8pNEtYuzD/0Aj144z37LIWfGNN9V0nNX9L1+kAgXGXPsafxhm0QDw9oW+a2dIlMSelDHewXKr/UtPW0bvTHpyZwNwlZngI5sh/rxxLKLIKghG84kFpofcpFgbyFevAJfItboq0HNU2zkx2u1v6oHKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH0PR11MB7523.namprd11.prod.outlook.com (2603:10b6:510:280::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 15:38:29 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.040; Thu, 27 Mar 2025
 15:38:29 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>, "Zhang,
 Cathy" <cathy.zhang@intel.com>
Subject: RE: [PATCH 3/4] x86/sgx: Define error codes for ENCLS[EUPDATESVN]
Thread-Topic: [PATCH 3/4] x86/sgx: Define error codes for ENCLS[EUPDATESVN]
Thread-Index: AQHbml5snyYEa5bXK0yUxAJfnWP9TrN/s2iAgAKF9jCAA6e/AIABRMzA
Date: Thu, 27 Mar 2025 15:38:29 +0000
Message-ID: <DM8PR11MB57502DD4D3E50D200D922C16E7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-4-elena.reshetova@intel.com>
 <Z98wDd_eMCFE40Z7@kernel.org>
 <DM8PR11MB575028B19C9C23E6EF31357FE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-Re4gqcCh0GSvKC@kernel.org>
In-Reply-To: <Z-Re4gqcCh0GSvKC@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH0PR11MB7523:EE_
x-ms-office365-filtering-correlation-id: f6eb6dce-c674-4282-5653-08dd6d456c4a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZWdUa2lzSk92ckl4Rkh2MjQ3emdBc1ZuT3U3OGtwajNhYzdxOUJCQndqK3dQ?=
 =?utf-8?B?d1lQRnYrZmFKbGxkbENkenZ1UDAxcWw2OHlid2ZvSHRZZTBzQzg2ei9LaGVp?=
 =?utf-8?B?RndkdjE5MGRIM0tsbFZHN01iOU1Uc3Q3WWdGcC9FK0VQaGlWS2ttYUxUNitk?=
 =?utf-8?B?S3NwMEYwejNwT08xYzNKK2xQVE5iVU1EdnFVcDN0Lzh2TVdvcE5waHQ3OFU0?=
 =?utf-8?B?QUpRcEtRU3RzZWcvNXJzNjVlWFpyS2xkOUYrcldRTkpra0tBS1hmMWdiZGht?=
 =?utf-8?B?cGZzaUpicW1CT0RGZE5KMENUYW5iVWE0QlpiL0FFaGUySmhVaXBWb0pIdlho?=
 =?utf-8?B?elFaZGo3MTdHMEpUYzFRRVZFOVNGY1BMaVVtU3MySEpQRmUvRWR1bTZwekNB?=
 =?utf-8?B?RU85UVE2K2dsSUZtbllESFBjdzQwZk5nWnBEUXhJdHRGL1VxS3dHV2Ezejk3?=
 =?utf-8?B?REtzeEhyeGV6Ni9ybHBTSFRidzA5WmF4T3BzZ3dBYjNqL3hwTVdVcDQzTWFH?=
 =?utf-8?B?TVVld0dPVVU0a09UdGpmK2hBV3dMa0E3UjRpSktnbWVNNzZIcnI2MWFTa2dr?=
 =?utf-8?B?R1BjNE1oWlNlMzhlVUsxU0ZRbDRjTWtrbjY0cUxsUkh6VmxFcjRzQVVVSmZk?=
 =?utf-8?B?YmRQdUwvaHlBMnVnUEluS29DU3gwY2ZuU2orYTlvY1pHdk1XUDlkRjQwODRh?=
 =?utf-8?B?YTcrQ0NFc0ZnaDZZSGtJOWZIVUYzeTNKTUdXeG54eFRaT1RIYURaWkNuMm1j?=
 =?utf-8?B?Tk5vell2cEtTSUlXRFlEbU1rdlVwd2RVUUdENjkycmRhWCtMWlJJQ0d0Uk9w?=
 =?utf-8?B?dkMyNVJKaTN6NWszZmZTYXZyWW1HR2FVaW5SanhyMjI0LzY5eWtQdm9HV01w?=
 =?utf-8?B?U3lLc1RDMWFZNUhScXRLTVFaK0tSRTd1TDdFUDhseVg5WDlWamJocGl6ZlM1?=
 =?utf-8?B?d01oRzJremc2U1ljb1ppUGxmNmgwalV2aFpCck5rdGtKTjFHRTVvY1U5TEJV?=
 =?utf-8?B?dVFNU1VSQWRqaUdpWHZnNGdyZjVBcWgreUw2NzFjQU1oc28xWWxkY1hTRjda?=
 =?utf-8?B?NFI5dUxuZkxBUWxLWFVXb3kwWEg5WmhXNkNqejQ3aEJlc1YxZXVpcFJZWEsy?=
 =?utf-8?B?YWltd1RBUzF5akxqdCtNdGdPWVhrd2ZrbndsT1dFK2RYckJVRTd1K2NwbTA5?=
 =?utf-8?B?NTAxNzkzcFdTNXdKRGY0c2tZWm9FdGtwTC81REFQNnZMR3gzZkNPaTRFTTgr?=
 =?utf-8?B?UEJneEdYYXZlc0hIZC85eSs0aE5zTEpaQmRuZ0p4SUxSY3ROSEUvZ0FFT2Ja?=
 =?utf-8?B?aEV4eFV1czE2YUM5R1pBSGc1Unh4d25FaWNLbnBSazl4b3ZTU2hrNTA5NG5z?=
 =?utf-8?B?aWM1ZGNLL1NNWGh5anp5NG1ubWxUdWdEWGtEcEU1RVdlKy9lQ0NNamxiNWNq?=
 =?utf-8?B?QWJpMVl1WkdxVVBsM2ZaYmhIYkNJcU11dkZ3MmdGR043RjQ3RENTK0VzdnRr?=
 =?utf-8?B?V3hza3BMM2hjNm5RNm03RVYrS003dnJwMFRmRkx5d3FnY1g4bXdOdW5TalU1?=
 =?utf-8?B?VzNiaXVlOFRwTndrWnh6VlcrOU52dm02dms0QU5ZKzNoZnpoS2RkUGV4TVZ5?=
 =?utf-8?B?WTUyY2NESlVTVmpYeGdHMnZOQnBteWZvcVVMYXB3TmU2TDFTd0lycmVjVEZR?=
 =?utf-8?B?VXhyM1RpSjhCSTY0K2JJOWNodDdjUWdzY2Flbk1SQnNwdGFqWWQxY2pMTzk2?=
 =?utf-8?B?L3FSQXY1ZEpycndiRktMT3NlZ3VsT3FEaEN2WTM4UXZLL3VNSEJmcXQ4ZGtD?=
 =?utf-8?B?cnZwTm1WOG9iNitxZ01BVVdMek82cGZEeHorL3IvRmhtSFk0TVZjL3cxem1q?=
 =?utf-8?B?MjBOeU9jV24rZHpRdW96WEd0b2g4Nzlocmp3ayt2S29RNW05VjhpOE5SSjhJ?=
 =?utf-8?Q?w0OeBX/mFb0xMzXSI5RU/SlY5gWeHagz?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzBUMzd3VDhKK1V3SzYydTVFSDhqNlVxT0Flck9BOCtnZnFpdzZzSXVYdm56?=
 =?utf-8?B?YkZrYk5kNHJxdzNTTXFCYU9HQUQ4U0lnVHR6dVBKN1F1YjEvdnZUckhFcDMz?=
 =?utf-8?B?aVJzK3ZxUlUzWVQyN2NVOC9ERTNOYjJxL3dFelhpa0E3MjJBTlpnNnEvMWh2?=
 =?utf-8?B?RHdZMjFhdy8wcERCMEs1YnJYbWtqckVjUHo2MnMrMEpuTFlDYTBqVUNDRkgv?=
 =?utf-8?B?S2FnZlFYRERUKzRKSkZ2dDFYT05NeStxZkNXM0pZRk1wRW10SHRZUWpFQ0dn?=
 =?utf-8?B?WlRLNmRHYWd0VUVDQXhGMmFLeUR1VXhRZlhaM0hBWndHdEV1UkpkZkM4NzJ4?=
 =?utf-8?B?Unh4VnM4WlhERnFuVDVXTkxLQzFxN1I1eWhFUTFDbHh5Y0tOazdKUzlwMWxr?=
 =?utf-8?B?MWhEQkhQc2ZDK0t2OHNabmdqcWczdWE4Qktkelc4MVRhQ2tUdFVjcU4yS1hR?=
 =?utf-8?B?VjM0aElaRTZpQ2MrL0F1WUFFQ0R0VEtVZDdUSk04MlRqY2NkYmR0S1Aveloy?=
 =?utf-8?B?YTBBTTVUQng5OWZBTEJycUh2YVJtRXRDZTZodmY5NXFqZ3R5dmYxQWdNaWFv?=
 =?utf-8?B?a0Zoc3pLUnhYTEhoZnZ2bnRzZGxuL0RXZVIzM210Z3lrSzBWZm1aUzBUVkxm?=
 =?utf-8?B?a0tIeHF5SUV3cXRVTG5MUStwZm5NV2psNnVDTHc4RUNCd0hTSmNpaTNYZ3RP?=
 =?utf-8?B?cGNMR0xUMTBZaDF5aVVaaEtRejVwSERtL09hTVp1RW1Ca05GUElvR0VaNzNm?=
 =?utf-8?B?UmRYZVBjVE1SMEtaVTFYVGZMWHVlV0xUQ0dkWkJyakl4c253bm1OQ1pBRzlt?=
 =?utf-8?B?eUY2STQ1L0JUbzRiQzZ4Y3BjWWxWSlhhMGYyVlIxbmVIWEdIOHllamZsMEsy?=
 =?utf-8?B?cllBcmlXZjRSeEpaaHpzUURlbUlINkNRekdFdXNCSVdCK1c2UUxyUGhUSmJy?=
 =?utf-8?B?NmFwaGJYUnRUYXd1ZlVQazMySVZpQUxzU0VnMzViZlVPcVp0aGZpd2lCT0lS?=
 =?utf-8?B?Wm8ycExMZDdlZDNRSVp1YTduTVpHdDZCdGt2ajBkc0pham1KQU1JNmtjNlVX?=
 =?utf-8?B?L3U5dU45a3lyUHVwUzlCUER1MENrbzdNU3VFeVJZdDhUamJ5VnFmRGpEYkNv?=
 =?utf-8?B?UDFpQnpCMVZvdWpGWlJKYjhwdlZnVlFFUmFHUEREdi9zYThuSE03bkNRUGJT?=
 =?utf-8?B?bStHY09rRUhyVWZwSW5kWXhhZGlUTStZVGJrNlI1NjNXVExaT3hiTk1aKzJW?=
 =?utf-8?B?V1BtKzZ6M2MyUENlTnRXdzVrTXRGbmRaQVVuQjl0ZTVXd09TZjV4a1Ruekor?=
 =?utf-8?B?MTFYODBSSUFMUGVBS3VXY0tIOTJHNmVyTE5yUHBoRTdFUE02S1JDLy80NG1S?=
 =?utf-8?B?NzRlejhORXFTaWwzbzZMMGszTFdTaUVvODErQVdRV010TFdtNFdsY2Z0UmJk?=
 =?utf-8?B?UHFUL2lOa0pyMXdvdlh1TDVFRm5rRVBTeEJacEt0UnBCcFV3WmN3RUMrTUNr?=
 =?utf-8?B?OGc3dC9WQ0JrZTAvNU1Da2RNUmVJenlzcU5Qak1aZXIwellvT3B2ODF4WFFu?=
 =?utf-8?B?ZlZMZ3lMSWlSZDRqL1dDc2IxWlQ3eEFaVW5PZVovd0VTOGxrdDJSWEszcC85?=
 =?utf-8?B?WjlqOEEwY0V5bzRwN0E2V1FxNzU0OUFpVTRaNk5ZSngzbzUrNzFwRmF1TjVr?=
 =?utf-8?B?MFF3UDUxL3RmNURvWGR3VXZldWJnSmdETzlsWDRQczI3dDdmaXI1K2pHTWNr?=
 =?utf-8?B?aTBSMGxCWHowU3FJS2ZnZDVaV3F1NldOZHp2a1VpRGxiRFJ0aUpsS1pONDFo?=
 =?utf-8?B?MDlmT1JFczAyRW80OHovSlcyRzU3YVZxMURJN2k5enNBY1NMQkxBeUphVmxl?=
 =?utf-8?B?bXlFaVhJT0hrMU9TVmZFQ0t0Z0ZoemRSZ0p0aTZjTklQWUlxZkRTdEFYL3VQ?=
 =?utf-8?B?NjhHVXRKUXliOXBMT2FLRDlBUVBTUExIR25QZjRtMmZ6dHJZUDR5WlR1emtq?=
 =?utf-8?B?a0RNajdnNm9Ca3hNMHR3S1dKaG9RR1dQTWM3YmZOUUp1ZTRTdEs1Nmg5Wi9D?=
 =?utf-8?B?VXUzSEtLWGZPclc2SmU5a0EwUjVTb2tLY3V3RlRmK1ZOc28xM1l2WUdYaVU5?=
 =?utf-8?Q?8SwgxAHfxnT3OTje648drbALj?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f6eb6dce-c674-4282-5653-08dd6d456c4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2025 15:38:29.3371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6NUPh6NXTi0tOPCWcEW8Vfy9ToJbsNCMWgaAUpfU0xsIAJOSMP0/s8CUYBUfO0Fvuaayl1+Ld518VWadGEj4qW3hydZe0pQIzzdqTW8YjFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7523
X-OriginatorOrg: intel.com

IA0KPiBPbiBNb24sIE1hciAyNCwgMjAyNSBhdCAxMjoyMToxNFBNICswMDAwLCBSZXNoZXRvdmEs
IEVsZW5hIHdyb3RlOg0KPiA+DQo+ID4NCj4gPiA+IE9uIEZyaSwgTWFyIDIxLCAyMDI1IGF0IDAy
OjM0OjQyUE0gKzAyMDAsIEVsZW5hIFJlc2hldG92YSB3cm90ZToNCj4gPiA+ID4gQWRkIGVycm9y
IGNvZGVzIGZvciBFTkNMU1tFVVBEQVRFU1ZOXSwgdGhlbiBTR1ggQ1BVU1ZOIHVwZGF0ZQ0KPiA+
ID4gPiBwcm9jZXNzIGNhbiBrbm93IHRoZSBleGVjdXRpb24gc3RhdGUgb2YgRVVQREFURVNWTi4N
Cj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBFbnVtZXJhdGUgdGhlIGVycm9yIGNvZGVzLg0KPiA+DQo+
ID4gWW91IG1lYW4gaW4gdGhlIGNvbW1pdCBtZXNzYWdlIG9yPw0KPiANCj4gSSdtIG5vdCByZWFs
bHkgc3VyZSBob3cga2VybmVsIHVzZXMgdGhlbS4NCg0KVGhlIFNHWF9JTlNVRkZJQ0lFTlRfRU5U
Uk9QWSBpcyB1c2VkIHRvIG1ha2UgcmV0aWVzIGJ5IGtlcm5lbC4gDQpUaGUgb3RoZXIgdHdvIGFy
ZSBvbmx5IHVzZWQgdG8gcHJpbnQgdGhlIGluZm9ybWF0aW9uYWwgbWVzc2FnZS4gDQoNCkJlc3Qg
UmVnYXJkcywNCkVsZW5hLg0K
