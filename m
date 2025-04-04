Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E89944E;
	Fri,  4 Apr 2025 06:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743749665; cv=fail; b=A9CWG4/3lz+U+4v9WWtLNu6lGPDnolW5JzmWss1PL/70vIOjrv0ho5OvCuW3c0tyxIN0D2jjlVjv2S/zS0eRxnHfT8lPQQ/pbHkXq0cJJOo1ArZ3r10UtiDjl6fsTb7CDkXMkmNpfV6vDN/7OCJ3TFqmb6BhrR0M02D3OyWc+YY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743749665; c=relaxed/simple;
	bh=TOYgLa38nVBIgAJj4zBz8+ZZlnBenaMznMT1OPFpC4g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K5bO+kUKrzsUK/LMJPnV+wu27MkkPFNQvU5glZZYvQdKLwUWwxh0M/KvTCSvkHLvF3KtbRpsTU0BBwYT69h6ASQzfY90h2cb1snwIjhC/DEkJakIm1V9cH9KrKDQW9yiXq3f6MGUH9Wd2OtJP+OAQoZ0jLV6XRnxLiGr90ffbkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zp/zOl6o; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zp/zOl6o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743749663; x=1775285663;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TOYgLa38nVBIgAJj4zBz8+ZZlnBenaMznMT1OPFpC4g=;
  b=Zp/zOl6okFf8ZiwGnA47gWVCKQf3lqsGavJHYY6+jj93Pwb26maq6Z4W
   3qBWel8vFCu5PHHTXQ8cOgAyApteh154bBGGHtbqmHxJ8cIG7PJc0Npmd
   4+ObtMlzM8QMq+LUripwNWyq/yjhO24otKIweJNtsXkQABdBKBP2sTrhn
   CBrpVb8g9dLHB9QuMDKb+yCqdgjPhanM6qjuyPosnVNUvcdeQF+ozDN1S
   HEjYFMg6yNW1Cu2WsGjcHVuvpTRKyrbb8bqoosQXwxgvffhHvXUA7IHFi
   yhEfauQj2M2/XXykooaZkmoCJ+mgV5nNNDF9teCnZkwRfj5fhzeDa4Qnw
   A==;
X-CSE-ConnectionGUID: vCh1HT5BSPWYHIL4xr2Ufg==
X-CSE-MsgGUID: UzhV9JCuQl6vVlxDdSbPGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11393"; a="32784483"
X-IronPort-AV: E=Sophos;i="6.15,187,1739865600"; 
   d="scan'208";a="32784483"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 23:54:22 -0700
X-CSE-ConnectionGUID: aa0d2D9/QqeSUFRX3gtzag==
X-CSE-MsgGUID: RD05eOfuToSP1W59qGh8FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,187,1739865600"; 
   d="scan'208";a="132354421"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Apr 2025 23:54:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 3 Apr 2025 23:54:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 3 Apr 2025 23:54:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 3 Apr 2025 23:54:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D6Gzp+AOfl8k1Whz3ONL30gtY3nOv9Dm4D6VyXHBEwo9WFd0QBNi+dqXcix9tBsrJEKaQlA7uaq3d/c1KS9jM4kdIgaYv40x1/hhVBei1zctmhE1wVVBwYUNd2UPfMNZqvvOFU0ZnwaotK2X+sIBg7OysLuKg934wl4fghrNzIazHjP68ROzhFUDK4x8dihpPlpIK0m6/ApDlFWv8SWIw62/9plVXbuFNltDDxEO5AfswYJug+1WBBNuujEr8nbu/XW5LInbg3UZGljgZAaleMle2prOdQ3HXV88Snhok36Flxv/9o0/hKneKdP+Sxv3Y/beLPQeRb4qDBxUbqR8Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOYgLa38nVBIgAJj4zBz8+ZZlnBenaMznMT1OPFpC4g=;
 b=ZAyKQpBGlrcg3OteHw99A7/dJcbATnWq4+wTmR0HEHCno57Di7S8J/0p+ua9Z/ibu1Djy4Xxky9PQJ0Rv2GW4ZoQLmIyetIY3Bo9w2n4BLCEn9cx3XGVGCyL9dBSdYLSC0eE1+0bxMiD1bpB+hFjprv8j3TpHH1ygzA4dyZ3giAHmJb/MILfdRCD27z0KK5ckzxXHGCGzjDE6UT35uVgQKLLr5ePWirCCtf575uFSrUK4qo+5Fhc+VvF1oL8rKjFOEOl+IoeWtLyqcd+w2kebVdyvZ5q/6Swq1rGuomOpnt3x61a3JZ6r04hhhb1YHsIOcrbmY2F1JZ35bHsCdTyBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SA3PR11MB7655.namprd11.prod.outlook.com (2603:10b6:806:307::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8583.42; Fri, 4 Apr 2025 06:53:18 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.048; Fri, 4 Apr 2025
 06:53:17 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Annapurve, Vishal" <vannapurve@google.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "bondarn@google.com" <bondarn@google.com>, "Raynor,
 Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbn+FDiJjsRSw2cUyPYDKGfVHjnbOI1BeAgAAEgICABAKjsIAArrUAgAEIZUCAAFLwgIABevGQgAH4xoCAAMDIQA==
Date: Fri, 4 Apr 2025 06:53:17 +0000
Message-ID: <DM8PR11MB5750131ED71BFF175E3E329CE7A92@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250328125859.73803-1-elena.reshetova@intel.com>
 <20250328125859.73803-3-elena.reshetova@intel.com>
 <Z-bhczXA6aHdCYHq@kernel.org> <Z-blOQ94ymUsDwPn@kernel.org>
 <DM8PR11MB5750C88DFC518EB77B0D613FE7AD2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-rU_JXWn0vCdBr_@kernel.org>
 <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-v4WfcLhmXbYvaa@kernel.org>
 <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-7dqQCiu5fWZ9a9@kernel.org>
In-Reply-To: <Z-7dqQCiu5fWZ9a9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SA3PR11MB7655:EE_
x-ms-office365-filtering-correlation-id: 61e16ad6-e3b6-4e4c-3b53-08dd7345614e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VWhFVFUxVFkyTFNZREx4ejEvRkpYUldXcFF6dXBQS1daSnEyeVBTSDQ2MGpN?=
 =?utf-8?B?T042NGtTQ2pwVDJQN256RUFYbjNPRHVWdFdnUGEyYi8zNTRtRTlmYzN4b3hF?=
 =?utf-8?B?NE0rWkwvTWtlZ1hVRW90ZzJCUHVPeU9jaU5seVlPbFFNWXUxSlExU3U2SDQz?=
 =?utf-8?B?bDI2U29RNU1yZVNxNU1VRUNLSFRiOGJReFY4TW8xMjdCbFZ3d2hKaENpblJM?=
 =?utf-8?B?RFYzQ3FmK3RCOXZ2U3MyZ0J4cTAyYjc3UlF5anB2M2Q0Q3Y5Z0x4NVRadWUx?=
 =?utf-8?B?WVdTK3JCdXNkTHJkY0xJcWNBZDBZZWduZS9MSDA4TUFOZXcyaEJpNmp5emZM?=
 =?utf-8?B?QUFFTk5IWmdHb1p2YTRnVWFWQnJHOGNkdldqZHR6Z05BbW1JSlE0UHQ4RTJR?=
 =?utf-8?B?UmU1Y0d5YysrblVnQTdBMmhydnpMc2dvNzYxd1BqaE9VUlkyS3V0L3NLOVlG?=
 =?utf-8?B?Y1Q2UTNsVFhhQ1JTOHlzU1NoZFRNNG9Dcm1YOUw2U3dtMWVHbXZaMDFGNXFJ?=
 =?utf-8?B?WEI2MWJhdHRxYUVmdnV5eFFxMGhTOGR5ZGwzUGNYUGJYdU1MckYrbjFpcjdl?=
 =?utf-8?B?RDNidVpRM2dDSklCMGREVkRPM2R2MWN0dmIzaVFvS0hNajNqcHk5OG5yWWJQ?=
 =?utf-8?B?ZjVtbFpmQk1HdGZEcmZzeFBpUTJyTkZIaEtXUXhCUmU4RUFIaWpEOW00djVD?=
 =?utf-8?B?WnZobDcyeG5HYTdBQmdzT2dBZlNWdDNQcU8rSCtHY0dNU1NtTEN2VHdlVFRw?=
 =?utf-8?B?VTZSMGZ2cXVVM2M5MW9zTHhqbmpiRU9NbnpEL3lObHcxWmU0OEkrZXYxNjV4?=
 =?utf-8?B?TXByeGxoMlVjSG16dlZMWTNHc0pSWWg4Z3NKRVRKMVg3Wi9XanZubVdkUEx1?=
 =?utf-8?B?Wm5KUS9xTDM3RWtZY3FXcU1QVEl5QkY1cVJndFN2M3F4RlVxRzhaRFFMRzNm?=
 =?utf-8?B?TVhOcG1FU1lxV1dTY2M3VjZnL3Q3VVVzYVE0L3B4OHFYK3dLazY0UElnbGNt?=
 =?utf-8?B?c2xjWDV4c3UvTFlBYWJuKzhraHgvNmpJQ0J1NUpydlREekk4ejc0Rk5PNGNB?=
 =?utf-8?B?Q1lacnVOcnBTdnE2cERHbytSekRLZHBENlVCaDhMQS9rSXplZm51UG9aR3dI?=
 =?utf-8?B?bU1ISGhzVm5hTmZpVkNuUTB2aVNRQVg1QnluWkVrNmJvNGdpNTlScUJoZnlJ?=
 =?utf-8?B?MWJHbk96d1lYUlJwcDFCaEhoMEVFL2FucTBmdjRGeDJqbGF2VWw5QU9VRUFv?=
 =?utf-8?B?cjRsemVTbmtjckF2Tnk3cnVFZVZ1SndaWjNHV2RNbmljSWRWbUQ1eENieVht?=
 =?utf-8?B?RGNadkEzU3ovdTJ0VmRLVUJOZHBzd2J6UEYyN3JzTHRvVm1jVzZRS1JiQlp4?=
 =?utf-8?B?ejFHanRHdjZVbGNqcWFkV0VDSVlCQU1SR2VoY2ZZRHNJNTdPeVBGZEZ6TENO?=
 =?utf-8?B?VERLblNyTGRXMER0SkJ0WmdhdFcyNWI0UDBoZ0FZNGJ0Y1FlRTRMYlYveWRX?=
 =?utf-8?B?dEc5SUtJZzZSeUprWktCVHhZcE55K09HSW03M0JxV3p4aC9QamQvRkUrbnor?=
 =?utf-8?B?azRubWFVMTVXNVNrcHFpNit6a0F4VUJKenJmMGRHTjZFNVordGZHTkd1cjdG?=
 =?utf-8?B?eFh2NHFsaXdIOFIwSko1NFVWWForY25nSUdDODNjemZpWWRnUStGemVLY01P?=
 =?utf-8?B?N21GeE9qdVV0UzBFbWJVa1BDZldFcGJvbm1HOWlNelZ3NVE2MFQ0dnh0RnBY?=
 =?utf-8?B?SlFkTmVCelJBaW1FblJ2aGdLdVhmaVB1S1pCL0pDQWI3MXVsdmhlVlFJVlI0?=
 =?utf-8?B?TlRvU3NuWjdIS0pmYXcwN29Tb2JlTVdzZVp5NWRvUzlJekh2U2l3MkZoWHdw?=
 =?utf-8?B?SkFreERIckF5MlNLQlU5WmJFVVlqazJIWkdXVHlDVjVkaE90QlBFUThQcDVr?=
 =?utf-8?Q?00cYY9EFkcADNNXC5CnjS/7Ied1KjEpX?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDBTU1hPNGdPdnlBYTY0OHZRdERSOWtwWDlMSHh5Z0FESEtZRDU4ZGdmNmdv?=
 =?utf-8?B?NzRzWXZTNDI1S1NBTHUvc0FBMDNoQlNTZm11VW4xK0MvVUxuYzV1ZHpjNGVx?=
 =?utf-8?B?RnFjZFkvdytxdHJEekM3VXphZEJhaDE0NUpmREl0WjdjK2RvcE9HOWpoUEpw?=
 =?utf-8?B?TENteGxDRnpGN3JXb3VzT29EUVZaMWgxelpndmhLVkdlNjFXcU0ramU1RmJk?=
 =?utf-8?B?cXNCUGp3Zk9ESHVPdkxqbVUzckNwMCtiNkV0UlpXT3lDcWdFUTE0VHExMERR?=
 =?utf-8?B?MnMrY0E1eEU0cWZjRVhEUys2SGk4S1piZTgvUzNYRk5jS2xhZWZBVXBVRGZx?=
 =?utf-8?B?OWtYK1MvQktEbjNUaGMwMFlEWXpTeUo1UFgzSktTa2p5RHlsWnA2ejlDQ09Z?=
 =?utf-8?B?TXB5WXY4b2xuY3FSVGRxakY3OUlVbUg0cENEN09xMzRMTi9wQmZjRk9LTW9J?=
 =?utf-8?B?TDh0V0V2K1poVHNtUEZ3b2pVNEpmZXlhWTY0OE1vSVJuelZ4OHBud0ltTW9L?=
 =?utf-8?B?OFNNSzRoNWpFTE41QmVZZnp0aVVEVnZSYVNJWjlRTnR1Sy9UblhwU3JLUGRi?=
 =?utf-8?B?VmZKa3FVaTA1b21hUmdEcDV5TG5RUVlGNy94ckg3NEV2SDhqbmJyS1Y0Mzdm?=
 =?utf-8?B?eHRVbkhYcEFEQThBdnZhdjRVL1FIUnN0WTc3eWZuemF2NTZjQjRNb05Obm9q?=
 =?utf-8?B?QmwrVTF0d29DNDh1ZDFxM0JFcHByZzRBZWxyVTVLSVRUS1UzWEViTWZWKzB1?=
 =?utf-8?B?N01NREhkWTJTZGZpMlFKc1VWakh2bWQ5cjFOR2lJdjdZYk80QzlzYmtZTzFL?=
 =?utf-8?B?MGYvc3p3WXpCZzUvcmM3UmFPOEdRMnVrUVJaVW9TVXQzUk9CbVNHZ1lmOTlW?=
 =?utf-8?B?Zks1cFJVMXE4bDhCU2tyMzhHM2l3NkREZjFuUUFDNFFaL0dKQ2I4ek9LdFc2?=
 =?utf-8?B?em9ibFhMWWU3VDg0aHpteWw5SlhPWlVncjZBOCtSZGxhdWs5ZkFGR2QvT1ZR?=
 =?utf-8?B?MS8wR201eUkvVko5cWc2NUJuK2JDNkpXUTM1dnFKeDdlKy9MeGdjWjhmcUtt?=
 =?utf-8?B?SzFRb3lwd0RlbFErYUFkR0VaSkNFamZNcVRzdUc5UEc3cXFzeEthcXdiOUNr?=
 =?utf-8?B?dWdhRkZQT0ZlRVJhbEhYWTVOVFlNdW9pY2ZaSTFGNFQ3NGNENG1tTnhGU1ZI?=
 =?utf-8?B?YzkrT2JMVGVZdGplbkJEUVBRcS9HMUNPQkZmQkF2a1RLQmZGWUQzNjZ5OFpz?=
 =?utf-8?B?a0Nybk55YXU4RG9HdUJ1RzZiM0greXpCRUtNcTJyNGlkUmdaWjZhd0luTGJT?=
 =?utf-8?B?OEZQRXpjeEtESmF6bE1vbnFsRTE0ai9oYWdtZGhlZ3lKOEN2YjlIY1l5dFhq?=
 =?utf-8?B?WkpPS296ZlZrRUtlMnhvU2RsSTQyZ1p6UnUrVHd6eGU1Z0xreEVwMTI0U2tF?=
 =?utf-8?B?SkZoOHdPYksya0RXWWlvaENudjdnSUtuY2l1Sm9JeUNQK2p2K1ptLzAxc21G?=
 =?utf-8?B?ZlFXS1pHWTRyVk44M1d3cy8wazRwemFVWFk1Zmp2TkxlaUNuY1N6SVlqWVd1?=
 =?utf-8?B?Z0JrbnVxUzl0WElKZ01TSHpuMzZFQ1BaaFgxM2QwV0FkVFg2NVpvUURrSE55?=
 =?utf-8?B?ZWRUbEVscTJBRlFBc2g5ZDAwSWdqT0NpZks4MytjVGgzOUhoWlM2a2tHQWxM?=
 =?utf-8?B?VkIwejFlRmYvN2Yya1lRWWc2ekVSNWJLNExGU2lOY2VQc2tUNUl4dkcxOHk3?=
 =?utf-8?B?eWtObzFpc0VlcGdiSllDd0RCVldFNytma1h1ZWxLR21Lc2ZKcWZuSVBYeGl2?=
 =?utf-8?B?ZnBKK0VrV1MyTFNTK1FFQkhBR0M2M2VNSjFyYkhsYlc5dkl3VXlJQzQ4czM4?=
 =?utf-8?B?KzJGYzcyZkZIakh0eWxjajN5bWhldkxobTN5ZHh5cG52SXNHSVlTZ3NWM3Fm?=
 =?utf-8?B?Y1VINGg5ZGlvUjhmVUovVURvSW01MVhndkNqc1VqTWFIcnJUakMxSEdKY2Rv?=
 =?utf-8?B?dHJ5aURFQm4yUTlTZFkvaEw5V3hSZTdmbG9VMmhwdzhySGhJWFhTSnBVNTd5?=
 =?utf-8?B?RGhrT21ha0c1c29ITTl0dUh0eWV0R1FuWlV4YVdUekM1dW9zMGxuUWhRaENO?=
 =?utf-8?Q?TwieLXoc6IRGCaGLxFClyEzBE?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e16ad6-e3b6-4e4c-3b53-08dd7345614e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2025 06:53:17.8653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SdseJ0hpgUzzYGOHl0rlNjIrJxagEWx18qFi7fUeJOGnoPHdgw3aJVIT12YTonckQRWXwFSl22kyVpkaAF4X7O1jSWTdEY59VW0/YO3iq6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7655
X-OriginatorOrg: intel.com

PiBPbiBXZWQsIEFwciAwMiwgMjAyNSBhdCAwMToxMToyNVBNICswMDAwLCBSZXNoZXRvdmEsIEVs
ZW5hIHdyb3RlOg0KPiA+ID4gPiBjdXJyZW50IFNHWCBrZXJuZWwgY29kZSBkb2VzIG5vdCBoYW5k
bGUgc3VjaCBlcnJvcnMgaW4gYW55IG90aGVyIHdheQ0KPiA+ID4gPiB0aGFuIG5vdGlmeWluZyB0
aGF0IG9wZXJhdGlvbiBmYWlsZWQgZm9yIG90aGVyIEVOQ0xTIGxlYXZlcy4gU28sIEkgZG9uJ3QN
Cj4gPiA+ID4gc2VlIHdoeSBFTkNMU1tFVVBEQVRFU1ZOXSBzaG91bGQgYmUgZGlmZmVyZW50IGZy
b20gZXhpc3RpbmcNCj4gYmVoYXZpb3VyPw0KPiA+ID4NCj4gPiA+IFdoaWxlIG5vdCBkaXNhZ3Jl
ZWluZyBmdWxseSAoaXQgZGVwZW5kcyBvbiBjYWxsIHNpdGUpLCBpbiBzb21lDQo+ID4gPiBzaXR1
YXRpb25zIGl0IGlzIG1vcmUgZGlmZmljdWx0IHRvIHRha2UgbW9yZSBwcmV2ZW50aXZlIGFjdGlv
bnMuDQo+ID4gPg0KPiA+ID4gVGhpcyBpcyBhIHNpdHVhdGlvbiB3aGVyZSB3ZSBrbm93IHRoYXQg
dGhlcmUgYXJlICp6ZXJvKiBFUEMgcGFnZXMgaW4NCj4gPiA+IHRyYWZmaWMgc28gaXQgaXMgcmVs
YXRpdmVseSBlYXN5IHRvIHN0b3AgdGhlIG1hZG5lc3MsIGlzbid0IGl0Pw0KPiA+ID4NCj4gPiA+
IEkgZ3Vlc3MgdGhlIGJlc3QgYWN0aW9uIHdvdWxkIGJlIG1ha2Ugc2d4X2FsbG9jX2VwY19wYWdl
KCkgcmV0dXJuDQo+ID4gPiBjb25zaXN0ZW50bHkgLUVOT01FTSwgaWYgdGhlIHVuZXhwZWN0ZWQg
aGFwcGVucy4NCj4gPg0KPiA+IEJ1dCB0aGlzIHdvdWxkIGJlIHZlcnkgbWlzbGVhZGluZyBpbW8u
IFdlIGRvIGhhdmUgbWVtb3J5LCBldmVuIHBhZ2UNCj4gPiBhbGxvY2F0aW9uIG1pZ2h0IGZ1bmN0
aW9uIGFzIG5vcm1hbCBpbiBFUEMsIHRoZSBvbmx5IHRoaW5nIHRoYXQgaXMgYnJva2VuDQo+ID4g
Y2FuIGJlIEVVUERBVEVTVk4gZnVuY3Rpb25hbGl0eS4gUmV0dXJuaW5nIC1FTk9NRU0gaW4gdGhp
cyBjYXNlIHNlZW1zDQo+ID4gd3JvbmcuDQo+IA0KPiBUaGlzIG1ha2VzIGl0IG5vdCBtaXNsZWFk
aW5nIGF0IGFsbDoNCj4gDQo+IAlwcl9lcnIoIkVVUERBVEVTVk46IHVua25vd24gZXJyb3IgJWRc
biIsIHJldCk7DQo+IA0KPiBTaW5jZSBoYXJkd2FyZSBzaG91bGQgbmV2ZXIgcmV0dXJuIHRoaXMs
IGl0IGluZGljYXRlcyBhIGtlcm5lbCBidWcuDQoNCk9LLCBzbyB5b3UgcHJvcG9zZSBpbiB0aGlz
IGNhc2UgdG8gcHJpbnQgdGhlIGFib3ZlIG1lc3NhZ2UsIHNneF91cGRhdGVzdm4NCnJldHVybmlu
ZyBhbiBlcnJvciwgYW5kIHRoZW4gTlVMTCBmcm9tIF9fc2d4X2FsbG9jX2VwY19wYWdlX2Zyb21f
bm9kZSBhbmQNCnRoZSBfX3NneF9hbGxvY19lcGNfcGFnZSByZXR1cm5pbmcgLUVOT01FTSBhZnRl
ciBhbiBpdGVyYXRpb24gb3Zlcg0KYSB3aG9sZSBzZXQgb2YgbnVtYSBub2RlcyBnaXZlbiB0aGF0
IHdlIHdpbGwga2VlcCBnZXR0aW5nIHRoZSB1bmtub3duIGVycm9yDQpvbiBlYWNoIG5vZGUgdXBv
biB0cnlpbmcgdG8gZG8gYW4gYWxsb2NhdGlvbiBmcm9tIGVhY2ggb25lPw0KDQpCZXN0IFJlZ2Fy
ZHMsDQpFbGVuYS4gDQoNCg0KDQo=
