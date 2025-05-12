Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195DE1DE2C2;
	Mon, 12 May 2025 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747058085; cv=fail; b=iz7rMscGHoLypjamRrHfh1fRK3VdASCabEbDZFqH7ukgUjihyTuiaCSMIfrxvWvag7UWl4qqh4IC7N6A49YxrJCCckJ4NoIhjYhS7ev5RqdlQODpskL13ESH8kpRLhP2ZRphv6t1NwpV2lPRFCevtW0GfAF6+IOTMPHu5T0CEV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747058085; c=relaxed/simple;
	bh=2AL0haLB4FjB8MujDVTslzhw0BovVxFk5ZtL6dib8No=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=olbTY8rTYzcdcscjAba/udoX2VkzqZa5AlxF0pE7trcLhgC8fNZs1W59l4fksmJzG/3510dQIfPrSHXgtmgoFLhpK1y6JTQ7VwH1Bub0+pH6jZ//+5FPvkdJJeULNrtLUw+yBBnax4UpkSrlKmzKeV/VehviyH6dm5MlgLcNjf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScjSAcJ9; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScjSAcJ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747058083; x=1778594083;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2AL0haLB4FjB8MujDVTslzhw0BovVxFk5ZtL6dib8No=;
  b=ScjSAcJ9kGnpTmrv4OZVYgy7hOemVB0+fPsaarCH1vLjP3KO7a1kTVlm
   VbilMRo7G3wZZwOZbbj+9NRdeHgs2ntOxlmovp9EASoywZNVTgTb2g3Di
   vifBHLeB91VPSNqTen08IZb7gMZpSJ04KuKAvuf4W0uicrLCxH2WE5411
   XRb2bj5ar09fuNsp6oGYQGnK8gtli3Es1eDPtGl4IXmhmOsDd8y87W+TE
   U4z7WvYeWOfzUlpO1pLt5h9Sc9Ikj9a1Wlv81BS6sZEuz9q8A9ljMkfAX
   KDTdtkJNHW8PDOhs+fu42asJ/5vv1Rh8dmdm9+iFgpeEwryBmttseFEK7
   g==;
X-CSE-ConnectionGUID: t/Lg5UImSKeRkE3Nkbu4Nw==
X-CSE-MsgGUID: MsdgRShbR8S7uhi7iaWvWA==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="59085066"
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="59085066"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 06:54:33 -0700
X-CSE-ConnectionGUID: 6/T7TRe4SfuMe085zDUA1A==
X-CSE-MsgGUID: ZuPHtd/2SSmOSfbEvTLeVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="138313058"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 06:54:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 06:54:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 06:54:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 06:54:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HPHvhxn7fNeIWC4vligev6VorbdLnFdCEya/Z4UoeN7peD70sL7uvCZFn/wmInemGckPrTuFZzKqfzl+jVWSHQpNDfTg63Bxt2wYVhYfTfZYZLi9M54utJb5CFZBTy8eABopkV2KDVKGdNiZcGwJYax9v7kW3L8RSVfzixTpeafZB5lD/uxBfVBz9K0zPo4dOcrwu/aNOKAeS6J7pmlC6GjtHljoXmE07ZiY6N419VbOqtosANM/iMLmPUx0J6tuvT1/yGV7syK65YbyqtdgxR/G+qza828xw60m0mur/NKHrLWjKZ0UmA61yb3TjgbtHpUESv2ZHMRt5M/n3n97aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2AL0haLB4FjB8MujDVTslzhw0BovVxFk5ZtL6dib8No=;
 b=W2lnZByli2wCHd84C8qk7GHUaO3NmKablL6uMLb8pg+vhiN2HudTC8zpSIbpvyoqRmQ1zI/+GbXwvd5Yk+XPhAvEAwZtqyZkeY0xnGGvQcRiSPUamRyNpe3K7JxK1gyk8WASx4Uo77Y+pqmy7DNqnGrZaF0/HF60MXtldAeQc/gYtlDIyRh6g1EeWeHLwAvNSCh6EtKkO+NciE6VGv7EieBXxR4H4CToil/IlfRDzhE2Rqs4ZJyZYzG4G8b0nl+mkzc1xRRfdGIi9XINBO5E0QdbqzNkW11uRmBe7tI3KBHhyD5v6qeVqOWi4nvbZy4/T4z/2yTa3+/yrzUTdRdGpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH7PR11MB8528.namprd11.prod.outlook.com (2603:10b6:510:2fd::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.28; Mon, 12 May 2025 13:54:02 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 13:54:02 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v4 1/1] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v4 1/1] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHbv0FzcDl1rDYTb0CkYUTLrcXms7PJLMoAgAXfNjA=
Date: Mon, 12 May 2025 13:54:02 +0000
Message-ID: <DM8PR11MB57503358E2C40D9BE2E25E1DE797A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250507111542.709858-1-elena.reshetova@intel.com>
 <20250507111542.709858-2-elena.reshetova@intel.com>
 <aB0QZP4Mi4hydNSx@kernel.org>
In-Reply-To: <aB0QZP4Mi4hydNSx@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH7PR11MB8528:EE_
x-ms-office365-filtering-correlation-id: f5657525-bfe3-4732-0d2c-08dd915c741e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZDdOMExRZzRvS2c5NWNNUWd1K2pPVC9iUkJjMEZ2cGZiS2g2OWdTVGdCejho?=
 =?utf-8?B?TUI0UjhDREtDYnQ0WUFwSkNkNlQ4ZnpGK1hQbkhlRy9pQTFxbmlPeTIxekNa?=
 =?utf-8?B?Y2JqNDNscW5iZkxDY2dGSXU1YXNnbUkreGxSeVhHVkNVbld1SFFLY3Q3MFI4?=
 =?utf-8?B?QlJiZmpHa1h0MXdPQ3ZkR05NZjNtcUE5ZjMvR0UxZEM5RW1aVG9KY29tanRO?=
 =?utf-8?B?TGRuUFZOeWgyKzhGdUxOM2syb2U5TlNwOGlGQkxENkxLa3l2aFlTcnc4d0pX?=
 =?utf-8?B?NEw3WEIzdkF2NDRWKzVZUi9xaHJ3cVl4ekRpMVg5cUV5TGp2MmFmR0lCWC9m?=
 =?utf-8?B?WVMvelZiaVY3SUE0eVZ3aHBWRVpxRVd5bXE5NndhYVdVV0c2MXdGWm5iL0Vi?=
 =?utf-8?B?R3JUVk83N1ZMcEhIYW1taU91OS9LcWNMbnBtQWNRZTg4TDNqdUt5aGd0b05F?=
 =?utf-8?B?U3UwbnhqYzFyK0loOHhEK2UwM3pCRmFDSHRKaFdoVVlwNXEzOE9tN01ZMk5v?=
 =?utf-8?B?NHJXOEliQy9rZG9DRzNGSDlyTVhBc3ZNcjlzQTRjOVBKU3hITTBVVnBWUitR?=
 =?utf-8?B?c2VaclgyZFpMa1VRdDNqWWpqL0J6SGxXbWVyS2t1amhEMjIzSFFCMDhWSFBL?=
 =?utf-8?B?N2ZWNEJBVnhrWWJHMTl5RitJNUJVSU1LcG5kSElQOUI4MWVhZVZZOEgvVmYr?=
 =?utf-8?B?MGZiSUxteEg5ZG15RmFnbjVvS1JBQzhmRFc2VUgya2o1aFMyMzNQVmMzL0RG?=
 =?utf-8?B?Z3dyOE1nWVhuSlMvMVVZcnAwdUtmVGd4Y2FhTVVOS1NEaUt2SmtmOEUyZC9O?=
 =?utf-8?B?Y01YTWFyMzdvL1BUTHZnRDFQdXFCL2g2U0RqVE5adXJDUEZSRmZjVGxwcG55?=
 =?utf-8?B?ekV0SGY2Yy9jZmR2b3dUcG9VYlNIcWVzNWsvOWIwdGVDTCtFYXIydGdjNzUv?=
 =?utf-8?B?Q3ZKKzQ4VjBxLzNrb1hHYnZYcGpYSGFXeVRlWFVhQmhTMFFsek0rNU1TQnFR?=
 =?utf-8?B?UXF6d2hPencvNFdINTJld2xzMk1PY3hCNHlZWkFXc0paaUN5Q0c5UHZON1VP?=
 =?utf-8?B?cWJjbURLdFRCdE1LdnluYnpid0ZtWWw2R3ZaVXN4QXFoQm9jSnlLdHN1Uklh?=
 =?utf-8?B?ZEdiL09wL0MvY2dvZ1lEWi93TkJiWHZKTFcxV294UEdLaDI1aVB6TEtUNWY1?=
 =?utf-8?B?dGd6RVV4bG5WbUpSajB2L2tVWE9LKzNYRGlYcnFnUmVBSXVxOVlUVytISVBy?=
 =?utf-8?B?TUlDaTJiMmxHbDZMYXdzZS80bjZYak95REhIMHMrQ1c1RmtWSFd0ek9TL3Vx?=
 =?utf-8?B?SkFDc1gyZjIvVXdjekM3R1h3OUQ5U3NMTStidkFGSkFqeCt0Q1pQdzBqQVg4?=
 =?utf-8?B?M0hZSUJ3dEErTi84UEwzTUJzeW1wTVRZK1NrLzNIRE1PMTluc2RpeUN4ajdR?=
 =?utf-8?B?K2NINjZVV1Z1QmkwcVJuNVBJSlp4cTVKSTNDbGo1a1dkUnFseHE3aVhhb1VM?=
 =?utf-8?B?aHFYVlFLKzgvbG52UkhPYVVZdnBCamkvOG0wM092bGVBc0xxZDNVT01RaFdt?=
 =?utf-8?B?N2tKN3hnMmkwTnpXbitRcy84eFFtK0YvUkJIMEdkaExrNjc2TUIwcFZWUzFL?=
 =?utf-8?B?M1YzNWVRNFRkRkhrd3ZYbzRvbkczT1VONG1mZEcwSXBwb3ZIZ3drRkdDTk1C?=
 =?utf-8?B?enUzSFk2WEVJMStxRFVpSGNyRzY1VDY4clAvVXZhbWVwclMyR0g0Y3RERmxT?=
 =?utf-8?B?WDhMNms5L0hGbStTeUk2NytxcXA4NVdoNm1CUW1DOHY0VWxMd2NZUDRiclRE?=
 =?utf-8?B?N0p4ZGM1aExTa0xWb0hGQldjWGQ0Rk16NVhLZjhXY01LNXZBUDNXYXNYS2tE?=
 =?utf-8?B?TEg1QW5qVytzMTFzQjBISFN0VFI2TzlUbFZpMTVPdGVsdkpkYy9nZDNvVTIz?=
 =?utf-8?B?WlFCZVIrOVd4MFBsQVJNeE1peTJSRklNZHpEemxjT1NIOEkyTmR2eko5S2I5?=
 =?utf-8?Q?SRkWOkiczWZNpsK60iGjZQ52TxDypI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3QzVFVMa0VZMEx4VjBLeHRnRDdtZXAvSUlyQmRva1o5M0sxOU52Sm9UWHFn?=
 =?utf-8?B?cjVmSENUUm9EMUg1UkRxa2p1U3B2UHlHbnRBb1lqVmhWT1BTSVE0SisxaitG?=
 =?utf-8?B?ZmZreHd6MmJ3dHBickFyaDV4Zjk4WGZYYjJaUmRGb3JhVE84WWlnb1VGZGJU?=
 =?utf-8?B?U1Z2Z1RtSVZhdFlYckp1U201SDRBWW4xRDhFNzVURXhGei9IbHk2TDlhVExq?=
 =?utf-8?B?S2RXNWh6Y2R5M3ZNekZpb2l5V2lMRml3QktrYjY3dVpHSWJrd2FaUWtnc3px?=
 =?utf-8?B?V0JlRlY4WlRFcW1qS2ZqTDhPM1ZNczRnVXc3b0JoWFBsMnFjNGJBckRRQ3lK?=
 =?utf-8?B?MFUvVk55R2lHVXdCUENBT21TYml6SDhiNDVoT1FOZHB2eWdpNXhESnlhK3px?=
 =?utf-8?B?cWlUUmRub3A3WUJ5SkdUTGpaQUpLcE5ycDZBZkphM1pvSlFFY1luNENjUFI2?=
 =?utf-8?B?VktLdGh2M1YwYVBHV28wajFsY1NGNmtSN3JzQ1ZaQld2U1lsY2JVeS82Q1hy?=
 =?utf-8?B?NTRWWWRTV3dpYUFEQmpzT21kazJRZ3l2Y05RblBkVTlHVWlxWkg1bDVRRCtj?=
 =?utf-8?B?U216dms1b0JSYnhaUDk0QUU1SklvbEM2bWRHcVZ6K2k4ZEJ6SU0yK2ZOL21o?=
 =?utf-8?B?OEk1ZXN0Q0MrdkhDWHl5b25ucG16RXNxVEdTeldIbHNzejdLanVVcWRpMStP?=
 =?utf-8?B?cG14dno3R05WWmRCckxjMWFlU3plR080UnhHdG1FbjR4MUYxVFpvT0FnTzkz?=
 =?utf-8?B?MzVNYW8yZUpQTFdxZDFsUkYwd0dqMVN4OHNDQzcxRVpqaTliNlVNNDRld0lK?=
 =?utf-8?B?d3NPbzZ1VVZLd1NnNkRKcGVFR3lzTzNtQzFzamRUL2tyb2xOSHJhSzR1YjJm?=
 =?utf-8?B?ZWdIWFhGb2VGTTFKK2VyMTFBUUhvUmxNWWRtRDlxYlVhTk1zSmFBWGJobEdx?=
 =?utf-8?B?cVB5QWtoNnNNdVVGbVdMQ0t4VmIvck5KUkFyQ0tzRVYwWi9FTDAyNVRJSFRJ?=
 =?utf-8?B?VDdOOEJ6ZjRDdStZRTNvUmVtWDRldUdIMWI0VUpBdkl2c0sxYmpsS0RmUHpO?=
 =?utf-8?B?L2FjUExnK092QzI1VndnU2NqeHpuS3gvOERpdW5vV0pqYUhxUWk2cElTTFlZ?=
 =?utf-8?B?TEhHNHJzTGpvRFlxeDY5SXRaT29UczU3aFpIWm52QnVFMmlyNmtSK3pTcjZj?=
 =?utf-8?B?OXpRQ1FQdkZiQW1uWWNFTDRrT1oxZlJxRlYwRjVwQmJtamExUDlWdTFJZTAr?=
 =?utf-8?B?YlRQdjVjZm1OdGU3STRTUjJZOER5VGNmaFJNR2l4QmpGWlFKM2VFaHdEMU5Z?=
 =?utf-8?B?RGpvWWdtcUJhdjI0aDY0L01CSnEvUTRBUXBIWFhxMDQ2eE9QQ0cxSTVCNzJO?=
 =?utf-8?B?TW1hUGQ0RFlZVVFzS2dOYXJUWmVMckl6eFA3Skw2NFZ4aHFXMDBrU3BFWVht?=
 =?utf-8?B?S2JiZHJERTJEMWpESGZWSTJuL21iWkpuV3NyalJzcUpPNytGR0RIOG1tV0dn?=
 =?utf-8?B?Mlh6S2xsL25mbXhVaUdyN1pmVHZ1RTRRSVJYOXZaaWJpbnQzem5XbXA4SmVx?=
 =?utf-8?B?bGpSZmoxSU1NYzFrL0xUQnhyL2MvRUFGUWRqdnRyVXBsRmF6MDhtNFRWOU1F?=
 =?utf-8?B?NnRJYzU5czUvcGMvNm9yWWk1TG9vRGpiSW1UU1Z2aVZTeUlaWEYvNENBUDlB?=
 =?utf-8?B?NUdWcUtqOUE1Ris3d1dMODZJTlpmSU5LNzY0MmZhMGJUYmZYN2hSb0YrVE53?=
 =?utf-8?B?d0c5Y0VkYmdTanpEd3hVZnJsYVZuSkJ6T0c1dmJNc1Fmc1ZmdG9SQmlXT01Q?=
 =?utf-8?B?MHVEZldhQ0h4ZWE4ODVZejhBeThkbmMwaUU1OUZjeGh0dmQwRkFhYy9xUGdr?=
 =?utf-8?B?SlcyenVVWHYxNXluemNkQzdGMEYxZG83WjhRNGM4YU5HMENFVnU0WEtRTjFW?=
 =?utf-8?B?M1hvYmNnMVBxVFc3cHdTQVBVZVhwNFg5K0NXbitMRE1YQ2dnYWR6WjM4U2R1?=
 =?utf-8?B?Q2xaK1k5Nk8zL3RvWms4dFhWUGk0bWtTSFJCQWFVQVlpd1haN3kyejZNbFpS?=
 =?utf-8?B?ZXF1TVp5M3BEak93cmhGZUVXK3lpY1FnMFl5SUFxbWhranMyd1BHY3plNm5Y?=
 =?utf-8?B?MTVnUStYUDAvVUpiRUkvK0Q4LzdzNjNOa0FXZmh1L1NrNFF6V2xXVE9GK0JP?=
 =?utf-8?Q?DhSXqnjDSOxNF4xiMuzN1zi1lsO+eht7vkjbtUg0N5sG?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f5657525-bfe3-4732-0d2c-08dd915c741e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2025 13:54:02.7265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dnVyGJhhDN7KzEtAon47styaMfFZ1ftZdGtVe65CMaa03a+10/a0BRR01P8dugKy5gdxjTXT+KELwW/BNiWNHY+kCqDy0k8EhF0OCJeIBSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8528
X-OriginatorOrg: intel.com

PiBPbiBXZWQsIE1heSAwNywgMjAyNSBhdCAwMjoxNDowMFBNICswMzAwLCBFbGVuYSBSZXNoZXRv
dmEgd3JvdGU6DQo+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9k
cml2ZXIuYw0KPiBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+ID4gaW5kZXgg
N2Y4ZDFlMTFkYmVlLi42NjllNDRkNjFmOWYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva2Vy
bmVsL2NwdS9zZ3gvZHJpdmVyLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9k
cml2ZXIuYw0KPiA+IEBAIC0xOSw2ICsxOSwxMCBAQCBzdGF0aWMgaW50IHNneF9vcGVuKHN0cnVj
dCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlDQo+ICpmaWxlKQ0KPiA+ICAJc3RydWN0IHNneF9l
bmNsICplbmNsOw0KPiA+ICAJaW50IHJldDsNCj4gPg0KPiA+ICsJcmV0ID0gc2d4X2luY191c2Fn
ZV9jb3VudCgpOw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsNCj4g
PiAgCWVuY2wgPSBremFsbG9jKHNpemVvZigqZW5jbCksIEdGUF9LRVJORUwpOw0KPiA+ICAJaWYg
KCFlbmNsKQ0KPiA+ICAJCXJldHVybiAtRU5PTUVNOw0KPiANCj4gVGhlIHJvbGxiYWNrIGxvb2tz
IGJyb2tlbiB0byBtZS4NCj4gDQo+IExldCdzIGNsZWFuIHVwIGVycm9yIGhhbmRsaW5nIGEgYml0
Og0KPiANCj4gCWVuY2wgPSBremFsbG9jKHNpemVvZigqZW5jbCksIEdGUF9LRVJORUwpOw0KPiAJ
aWYgKCFlbmNsKSB7DQo+IAkJcmV0ID0gLUVOT01FTTsNCj4gCQlnb3RvIGVycl91c2FnZV9jb3Vu
dDsNCj4gCX0NCj4gDQo+IEFuZCBsYXRlciBvbiBpbiB0aGUgc2FtZSBmdW5jdGlvbjoNCj4gDQo+
IAlyZXQgPSBpbml0X3NyY3Vfc3RydWN0KCZlbmNsLT5zcmN1KTsNCj4gCWlmIChyZXQpDQo+IAkJ
Z290byBlcnJfZW5jbDsNCj4gDQo+IEFuZCBmaW5hbGx5IHRhaWw6DQo+IA0KPiAJcmV0dXJuIDA7
DQo+IA0KPiBlcnJfZW5jbDoNCj4gCWtmcmVlKGVuY2wpOw0KPiANCj4gZXJyX3VzYWdlX2NvdW50
Og0KPiAJc2d4X2RlY191c2FnZV9jb3VudCgpOw0KPiAJcmV0dXJuIHJldDsNCj4gfQ0KDQoNClll
cywgdGhhbmsgeW91IGZvciBjYXRjaGluZyB0aGlzIQ0KV2lsbCBmaXguIA0KDQpCZXN0IFJlZ2Fy
ZHMsDQpFbGVuYS4NCg==
