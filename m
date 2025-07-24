Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6402741AB;
	Thu, 24 Jul 2025 12:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753360471; cv=fail; b=rII+ibeEDE5Tbe9iVlPoARkCnD7pbybvRomwau2Ksrlml/koI2gwsRjbcKjx/idlN0guZnUMV7xDzQUxLNzymJbZzvwg7ziO4I2Zx7M2eqCM/ORQ7htgxxTMkTNuJM02fm7Ja73TjhepJOPJtPDaO1swiudDL1FkKNkD9vHD0wc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753360471; c=relaxed/simple;
	bh=uY4B+MFcopj08i0bU4ZZ+1J8NTpsjfsg4Pot5kSMx0A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FsZzrXl5Ko+jH2xBhawUnSHmS+rMpEizIU3ck6IbpXs5MTMfKb5lJWcu6Krh7xPSC8oyvBua3yVZiV5oUV2XXtkIs0QmfEemazwl4qNfkmceMqYpvNrF9kJQ2xWMb8EPdnqsUa3BwRlAZhezemGG6+5QbHcoL89kkkAjnyum+hY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kSjAf4gR; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kSjAf4gR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753360470; x=1784896470;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uY4B+MFcopj08i0bU4ZZ+1J8NTpsjfsg4Pot5kSMx0A=;
  b=kSjAf4gRckOYLwyXJXFjxkPwSsd+C7sVrP1rHGosQjJtw2DETIL0q43Q
   7UMj6zQXny0WuayTA0Mw9GOwMGJq6OIRmEMjXiLFVlHIJFfxtKe/KqTiC
   cpXLEr/Z+oDH3Z9IS9oBUVDy3DXAVuJIY8vkkmgNfYtQBdw7CEte1iT1w
   +2B0esqZAmS/E5vawrndpbuAwEH6s5fT+ALcmCWl+2Y0CLj08sL6Yquj/
   b9+2gOy5EYZgmZrXkniZA9XVsgMtjWYxKru0tYTs67hSUF8e0ViqK0hPv
   AKrjFkP+wQJIwktbIeEZkHGU6tBvcpBI+ibQeg1mxxUoL0s18rH97TJFC
   g==;
X-CSE-ConnectionGUID: acdXzNXDTiqKh3MjJWzFsw==
X-CSE-MsgGUID: Uye3Ir8PQ0WiJrgjKIcD1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66745267"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="66745267"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:34:29 -0700
X-CSE-ConnectionGUID: DvEojG2NSpCTBMBxlBT73A==
X-CSE-MsgGUID: fKLcW2H8TtavnH3BWp1A/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="191126539"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:34:25 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 05:34:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 05:34:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 05:34:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wzsXI3x+IPX7dqpSaMFyceLYurwktOYlvGmAK4DfjktQDldtRexTRb9rdSdOjBlEiU3QpoWd2zmj7BOUNU8dTYpwA9wtXfqXHie9oChfiJaUhFyc0OKmL9jmuBwBzay3cuKt4EJc7a1pNdlobb8VIMXBha8/qEQpHCQ3z542WuRdfATpUVU1qrhIPcIDJ2ZHcDb/VMHDhJa5r1mgc3e3RlHpMDcSxgD9hD6KOSZ/mRNsQ8Y0qQyaipIorUUdfrsTXSnbxt0PLvth/ifls2RsEQCxQvXwgDVsEcUXSjrrFH2sPsfexYdyWVSufapkCTXIwSbcUKpkhc9I3LCSsHtOUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uY4B+MFcopj08i0bU4ZZ+1J8NTpsjfsg4Pot5kSMx0A=;
 b=XbkHeOrCZV4PPUVhlQ2KiGA+UD7yIXliBztfRjnJFoks1fy2L9M+XZlDyR1EheIRYZ3bOYXvr94IGyCqVo7PLoRHmWPvfwCB+n9oSmaD1I8jlv1B+R5RRZUUlFaqLdsApLJeh10iFboTETCQ6ldq/ngs9y468eteLjTj+F5Dij43OH39cCRJ9Ai2YD+4EWKpON+yRrYLrUFFnGEs6B/DxpmrKSXyIDrnXtokQtiPXbs4IVtAxaW6PyEH3Rh+o7q6LueDsXOtGbD0mYTxeGo6gQCbFSUnHJn5ywk5tw7xerLPYedP+Sbq6XZfEwJkzgap3gSR88iXeJMJ7pBH8OUAxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH0PR11MB4808.namprd11.prod.outlook.com (2603:10b6:510:39::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8964.21; Thu, 24 Jul 2025 12:33:49 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8901.030; Thu, 24 Jul 2025
 12:33:49 +0000
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
Subject: RE: [PATCH v9 2/6] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v9 2/6] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHb/HF+x2tOyBNVj0mdfu/GrVni5bRBEX4AgAAhfyA=
Date: Thu, 24 Jul 2025 12:33:48 +0000
Message-ID: <DM8PR11MB575050AECA6A18D871750F08E75EA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
	 <20250724080313.605676-3-elena.reshetova@intel.com>
 <83553a7287b495326a2f923afd3f6aec9cabd69e.camel@intel.com>
In-Reply-To: <83553a7287b495326a2f923afd3f6aec9cabd69e.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH0PR11MB4808:EE_
x-ms-office365-filtering-correlation-id: 8c4b145e-c2bb-4fb6-437f-08ddcaae570d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?blJ1QjloS0tRODZDend2YjZkLzZvSERzSUFFaERxNkJTTTVkbjFCckxBTHhZ?=
 =?utf-8?B?RndKSW0wU0lnc24yT1BOR2FGWnRFcTlLdTBBUnhpZTRHTWJjZEdqU0ZJN1JB?=
 =?utf-8?B?cUNQZGoxek1KZ0grRnAxUldGQWtkWVgwcU9UMVdiTS9URkgzczk5a0x5bjBv?=
 =?utf-8?B?ME82bS9IdEt2Y3VYOG5YYTlmWjBEOEtFeGkxNE9wb2phV0U2VnVheHlTeUZ1?=
 =?utf-8?B?SlFIN2x4UnRWUVMvNmhNeDQ1U3lqbitBTW5rTTU1c042TDhtVENZNk11UGJM?=
 =?utf-8?B?cmtwcWRzVFJqK3ZhRVUrd1VUL2o2ZjRxbzE2Ky8wUk9POFVYNnlMdGF6NFI1?=
 =?utf-8?B?ZkdSSXMxUFBUV2ROR0pQbVdiTFlPbGgzRDNOT0hWQUhkaE5yNDBFUTUwOEgr?=
 =?utf-8?B?U0xYcElQUjlFMDlFUUFIeHk4c2NLbGxVanJtUTQyUjBOSEoxR1RlZjhCYUpI?=
 =?utf-8?B?NnVvRUZNaCs5cFcvb01ZK3dCbEF4Ujd3QzU2UDM1bzJnMzliRlp0eGpRRzkx?=
 =?utf-8?B?S3hBRVhrT2FyNG5EdnpHRy83b245Yi8zL2NTQkQ2dlhYSVFrd0V2b3BtKyt6?=
 =?utf-8?B?YjYweEIraEZBVzZNQjZUNFMybEx6ck5JM0FsVEkxdzZ0TnZhbFVPRGxaZXZF?=
 =?utf-8?B?V3VxdjI3djBhRVQzZ1N6M3JiRHVsY1huRmxnM1FNd0l1S3pySk56OXdpNlRI?=
 =?utf-8?B?bXJqZW9jYm1FMUVyUTM5b2xYdVVTMDFBRHZrQk1JNmxXcll0Ykx5NzJObTZO?=
 =?utf-8?B?NGlrVFR0VGwxbDg0VVlBMml0NkgwN1drbCs1WktMeXVYQkZ3eWNYaldYMWJz?=
 =?utf-8?B?ekJEdnV5ZW1nVEtjS0dJUE1mN2ZyaDFLdkQyVEhxZE9vcEpackJyeUMyN0Mw?=
 =?utf-8?B?eXVIVEUzS01xZG5jbkFQRk5jOXE3cjFpNkFnSitrTGE3YkdicUpPbkRhKzRW?=
 =?utf-8?B?OW94K1lRYnJTR2l2ZW8xdUVIUnIzZXRWR1ZYbndVYUhPRHdvWkhQWVpmUUFr?=
 =?utf-8?B?aTIralgreVZyZklHWnJHeFd4OEpUYVY1emF4S08vNmpNcldja0xpeURXRVN2?=
 =?utf-8?B?TXI4N1ZjTHpXNCs5SGJ2MFMzSU5qU2tzdGZkL1ZaMG5rZEFRekdvNHE1RHA5?=
 =?utf-8?B?Vkxyb2dKSUZVSEluWjdmUHlmbFgycUM1K04rQkhTWHJJbnk2M2ljcXpyYVRq?=
 =?utf-8?B?WDN4ZmFaM2VKUUZTVWRYQTB2akVnejc4RU9PUGNCRUd3dVZTNDAvY2RiK1dQ?=
 =?utf-8?B?RURtNllqT0pkZ2h6Vm10aEMweHF5K2VvWE9yTmpiQkNuc0txQUh4a0JCbzEr?=
 =?utf-8?B?d0dmMTBaNjl3YUJ3N010SlhBdzBuMHR0aUFmWVRtVW5iTEpsaHJjUUZma0g2?=
 =?utf-8?B?bXB0L3d6RXljTGpuT3Jpc1FhbGxhV3B6d0w4TGJscTN5UTdPUUdUbnFLczNu?=
 =?utf-8?B?Wk1NTko5QnJOUXJwdEtidW5jVGRtUFY3ZU1XWXRzUWJCWWQ5M2VRZk9QUXhi?=
 =?utf-8?B?azladldaYk5YVzNSUHFxeFE3bE00dFFpenZaV1BmMEdvdTVySkFNYlBDcXhF?=
 =?utf-8?B?MlY2ZWVOMmdhWTI1Vi9PT0RTaU1MZ2hCL0RmSHV5MDFHakpQS2tqU1pkV1U1?=
 =?utf-8?B?OGRDOXhvdUxGZDVVZ0RreU5wSjluWkZuL2pEWnhGcGF0WGMvMlZwTlpFa0Z1?=
 =?utf-8?B?eW5yNlFRaHg3cENwOG9mNDArTlBqMnI3TVhwKzhESVNPYUlPWk4zS3lCeFJ1?=
 =?utf-8?B?QmUrYmdZRkZOY2w5UFhPaWhUSDdSZTlycHdYWVFxWGtHS1hIcEZoeU1nQ1pw?=
 =?utf-8?B?Z000NjBDdUU2WTdlUGQ3TDUvWDhUT1l5aGtqR1VmaEhFUldPTkd0eklSMzBY?=
 =?utf-8?B?YmhOUGxZWGZqbGZNZ1BoVXZhOHYvTlB5bG55TW5HTUFHUWNvK1NxWXp0blJk?=
 =?utf-8?B?NXQzNTFHOU45ZzUzbkE5enRqb3ZEbTVVaEFrbkhxeGxneWhtbk1sVEZHTDk3?=
 =?utf-8?B?b1JXSXZTSTN3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ek5FbjBSY1JsdkRxMFNjUTA5UmkzbUFzUW5EckRmdS9LZldrMnFrOFlRYkhG?=
 =?utf-8?B?S2FuTGIrT0xGcml6Ykp6eVUycEpsektBdTRZNGM0RUF3VUdlOWRkMGZZVmZp?=
 =?utf-8?B?cDZsYmRTbVQ0Y3QwNmZKcUdURzRpUGJXbm5NaXQ0QUdXbW5TVmUvNG5LNThv?=
 =?utf-8?B?NDFpQWhpWGZrRHBVSWRBMEtxa3d0Q0xBQ245UDdiaUxBVHJWcFJEa05mNnAz?=
 =?utf-8?B?YUsxSy9tZXc3eXdXOGo1WlZBTkQwU2JiWmpHbW92YlNENTB5a2g5TU8yVjBI?=
 =?utf-8?B?Mkp6TTFwVWg0dExYN0x4N0pnWTNaK3BqSGl2WWhFSFJVR0xPczRRZnczY1li?=
 =?utf-8?B?WDdSZlg0NmM2MTRzRVlSek04UThBRUJucjFhc1VoQUhKdW5vdm1xNXhrOUlD?=
 =?utf-8?B?NStKd1BxelM0dk41eXphaVVCc3RXR2FKWlFmb2VZK05VLzkyUTFpbVVjblB1?=
 =?utf-8?B?a1VYOTl5ZEFEMFA1Z1lrSkIxMEtNdE0wcS85aVVxanpqSDNrL3V0dmhrSzhl?=
 =?utf-8?B?VTUvSGxsbWJrZEozclkvZ1BBZ0F0eHFSZ0sxcWxBRm1yRnNMU1VuR3F2ZTZk?=
 =?utf-8?B?MzdtbC8vbnI3QktQVnhSWjZUMk9peFBLendLb0JsNU1PWjdSUGFvbkRMTk0v?=
 =?utf-8?B?QUh2M3FNVjltelVDZ1JvSTRyTy9DN05iTjVUeDJQSWQ4WEFkU09VbXo5VUlh?=
 =?utf-8?B?TXNvcmJFVTVwZCtXaUxwQ0hhcXdHM0JuQTlsenRQZVdweVp1ekxOQ25rdFJk?=
 =?utf-8?B?KzJGQlR1bFZkdEFvYi9GNG9naXZHbWlOZlVDUDN1M25ZVUxVK25YYkRrMFds?=
 =?utf-8?B?cUxSL2lxRzV6bXU3cFdQTyt1UXJDdnd4SVVvZi9ZVFpkU29sU2VTYXlQWVBN?=
 =?utf-8?B?dFQzYW16SEtpSHdnVk1vTExZWm5VanYxZVByQ3JNVWVabWYxbmRFMS9oVGxr?=
 =?utf-8?B?WkxETVU2YmhEQUJsTW9JSDNUS3VwY05zemlOM0E1NXdKMHI1MUpjY2p3dTcw?=
 =?utf-8?B?TmYrQklRb0RHZ2VKVVVibStGN1ovWHU1R0NxQklUUEpLZjA1WWlyVHNnTlBt?=
 =?utf-8?B?QjZnLzAwMGFiU0tmNjhoMnRRV2wwZmU3a3U1RkRCMEZlTForYXR5QlZmQzJP?=
 =?utf-8?B?eXd2YUJDajlmeGc2cGZFYUQvV2lHaGE4VmptcWYxSHpNa1FOaXdHQVZ3VjZF?=
 =?utf-8?B?enY2OERPNkoxdVl6Q3VVbnFUMEVLM1Nta2pOdFhiSS9QSFNQd3dkLzhoSDBw?=
 =?utf-8?B?dzJZdlJjckJTQjl0VFM4OFo0Z0JRRVdreTRMUGs3N2pEelQ2S29CbHN3VStI?=
 =?utf-8?B?SGtseExsSkxWdmRXSjFmeDdIdFZuN1Q3TFp0Wk4rZktWZXB1OWVrUCtMNkpj?=
 =?utf-8?B?bDA5VDloUm1rdytrbjlESENUY2cyOHkyZWwwK3hqZStZN2V2WXBRVkp5TWxo?=
 =?utf-8?B?czRNclVTWFQ2Y1RHajNUbDNGN1Vubi9NMGlUL0svWXVTTmxQL3lXdjZHdU9K?=
 =?utf-8?B?OXNOaTdpeEdzd0Y0T1JHSzdhcXc1aEJFbUFIMUdxZ056SytnTTZSaE02Rkh2?=
 =?utf-8?B?bCs0VjZwZS80NnVxL0pMRklCa05aVEkvMXNNcEJ5b2dxeGZPVFppT0ZjeGhN?=
 =?utf-8?B?SlRqYmdEKzJVZGVnZUI1NGxlam81amp1QUJSNVJ4UjNrRWU3V0xPbmprWitu?=
 =?utf-8?B?cXIvdDRGbEVLWmw5WERXVGZQbDNCUUtMb0Y2QlIzZkxhS3AyTFRHSUo1TTJK?=
 =?utf-8?B?N1h6ZEVNSkpQVGJkU3V6MGFMdi83K09PSjNwTkNDVGZwWUt0OVROdmJxNVdM?=
 =?utf-8?B?NkYvNnROYmRHMFRJODBiYm1aODhscHZFZDVpNVZNbGtWc2psSjVBTklvYm5E?=
 =?utf-8?B?SnFOcWhaRmpYeVNkQnpMYlpObHpYWEtzM2dTR2Nvc1VDbWhyN1NGZlM2MmNv?=
 =?utf-8?B?LzJWYUJqQ3FxRkNXTlRWY25Md21MSFVOWmZPbmMwVEUwajNET3plemRsditU?=
 =?utf-8?B?Njg0ejRuZUVia28waHZ2VzM3Z2xTZDZnOUhxV2xRWFVISTJ1YVAxY0FsU3R5?=
 =?utf-8?B?WUNhVmh4bWo2RUNBRUM2bUZmOHBldzZGRHFrVkdwUEJrZFFpYjdqVytNVjlT?=
 =?utf-8?B?VlVsb2szVFBvK3h1K2NHZlZPZlFMK0FzbktDekhCaldWUGdJWGhhRWdUSVh6?=
 =?utf-8?B?dUE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c4b145e-c2bb-4fb6-437f-08ddcaae570d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 12:33:49.0024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tLnG9yXtSGGpGLjb0UZ15f4OQmLa2iYDAI6h9Mg4rR6JwbKxXpQ91Idleq6rBlsdbx5tpKQ62D2Tcy773uaTBA9oSyuNy+EOPtTgVlmhzzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4808
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAyNCwgMjAyNSAxOjI1IFBNDQo+
IFRvOiBSZXNoZXRvdmEsIEVsZW5hIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPjsgSGFuc2Vu
LCBEYXZlDQo+IDxkYXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IENjOiBzZWFuamNAZ29vZ2xlLmNv
bTsgbWluZ29Aa2VybmVsLm9yZzsgU2NhcmxhdGEsIFZpbmNlbnQgUg0KPiA8dmluY2VudC5yLnNj
YXJsYXRhQGludGVsLmNvbT47IHg4NkBrZXJuZWwub3JnOyBqYXJra29Aa2VybmVsLm9yZzsNCj4g
QW5uYXB1cnZlLCBWaXNoYWwgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT47IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7DQo+IE1hbGxpY2ssIEFzaXQgSyA8YXNpdC5rLm1hbGxpY2tAaW50ZWwu
Y29tPjsgQWt0YXMsIEVyZGVtDQo+IDxlcmRlbWFrdGFzQGdvb2dsZS5jb20+OyBDYWksIENob25n
IDxjaG9uZ2NAZ29vZ2xlLmNvbT47IEJvbmRhcmV2c2thLA0KPiBOYXRhbGlpYSA8Ym9uZGFybkBn
b29nbGUuY29tPjsgbGludXgtc2d4QHZnZXIua2VybmVsLm9yZzsgUmF5bm9yLCBTY290dA0KPiA8
c2NvdHQucmF5bm9yQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2OSAyLzZdIHg4
Ni9zZ3g6IEludHJvZHVjZSBhIGNvdW50ZXIgdG8gY291bnQgdGhlDQo+IHNneF8odmVwY18pb3Bl
bigpDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgcmV2aWV3IEthaSENCg0KPiANCj4g
DQo+ID4NCj4gPiArc3RhdGljIGludCBzZ3hfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1
Y3QgZmlsZSAqZmlsZSkNCj4gPiArew0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwlyZXQg
PSBzZ3hfaW5jX3VzYWdlX2NvdW50KCk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJldHVybiBy
ZXQ7DQo+ID4gKw0KPiA+ICsJcmV0ID0gX19zZ3hfb3Blbihpbm9kZSwgZmlsZSk7DQo+ID4gKwlp
ZiAocmV0KSB7DQo+ID4gKwkJc2d4X2RlY191c2FnZV9jb3VudCgpOw0KPiA+ICsJCXJldHVybiBy
ZXQ7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4g
IHN0YXRpYyBpbnQgc2d4X3JlbGVhc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUg
KmZpbGUpDQo+ID4gIHsNCj4gPiAgCXN0cnVjdCBzZ3hfZW5jbCAqZW5jbCA9IGZpbGUtPnByaXZh
dGVfZGF0YTsNCj4gPiBAQCAtMTI2LDcgKzE0Myw3IEBAIHN0YXRpYyBsb25nIHNneF9jb21wYXRf
aW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLA0KPiB1bnNpZ25lZCBpbnQgY21kLA0KPiA+DQo+ID4g
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHNneF9lbmNsX2ZvcHMgPSB7DQo+
ID4gIAkub3duZXIJCQk9IFRISVNfTU9EVUxFLA0KPiA+IC0JLm9wZW4JCQk9IF9fc2d4X29wZW4s
DQo+ID4gKwkub3BlbgkJCT0gc2d4X29wZW4sDQo+IA0KPiBJZiB5b3UgbWVyZ2UgdGhlIGZpcnN0
IHBhdGNoIHRvIHRoaXMgb25lLCB5b3UgY2FuIGF2b2lkIHN1Y2ggY2h1bmsgaW4gdGhlDQo+IGRp
ZmYuDQoNClllcywgYWdyZWUsIEkgd291bGQgaGF2ZSBsaWtlbHkgc3F1YXNoZWQgd2hvbGUgdGhp
cyBzZXJpZXMgaW50byBvbmUgcGF0Y2gsDQpidXQgaW4gdGhpcyBjYXNlIEkgZm9sbG93ZWQgSmFy
a2tvJ3Mgc3VnZ2VzdGlvbiB0byBkbyByZW5hbWluZyBvZiB0aGUNCmZ1bmN0aW9ucyBpbiB0aGUg
c2VwYXJhdGUgcGF0Y2guIA0KDQo+IA0KPiBJbiBmYWN0LCBJIHRoaW5rIG1lcmdpbmcgdGhlIGZp
cnN0IHBhdGNoIHRvIHRoaXMgb25lIG1ha2VzIHNlbnNlIGJlY2F1c2UNCj4gX19zZ3hfb3Blbigp
IG9ubHkgbWFrZXMgc2Vuc2Ugd2hlbiB5b3UgaGF2ZSBzZ3hfaW5jX3VzYWdlX2NvdW50KCkuDQoN
ClllcywgYWdyZWUsIGJ1dCBhZ2FpbiB0aGlzIHdvdWxkIGJlIGFnYWluc3QgdGhlIHN1Z2dlc3Rp
b24gSSBnb3QgcHJldmlvdXNseS4NCg0KPiANCj4gWy4uLl0NCj4gDQo+ID4NCj4gPiArLyogQ291
bnRlciB0byBjb3VudCB0aGUgYWN0aXZlIFNHWCB1c2VycyAqLw0KPiA+ICtzdGF0aWMgaW50IF9f
bWF5YmVfdW51c2VkIHNneF91c2FnZV9jb3VudDsNCj4gDQo+IEFzIHJlcGxpZWQgdG8gdGhlIHBh
dGNoIDYsIEkgdGhpbmsgeW91IGNhbiBqdXN0IGludHJvZHVjZSB0aGlzIHZhcmlhYmxlIGluDQo+
IHRoYXQgcGF0Y2guDQoNClllcywgbm93IHRoYXQgSSBkcm9wcGVkIHRoZSBzZ3hfdXNhZ2VfY291
bnQgZnVsbHkNCkkgZ3Vlc3MgaXQgY2FuIGJlIGFsc28gZGVmaW5lZCBpbiBwYXRjaCA2LCBhbGJl
aXQgaXQgd2FzIGEgYml0DQptb3JlIGxvZ2ljYWwgaW1vIHRvIGhhdmUgaXQgZGVmaW5lZCBhcyB1
bnVzZWQgYWxyZWFkeSBoZXJlDQpzaW5jZSB3ZSBhcmUgaW50cm9kdWNpbmcgY291bnRpbmcgcHJp
bWl0aXZlcy4gDQoNCj4gDQo+ID4gKw0KPiA+ICtpbnQgc2d4X2luY191c2FnZV9jb3VudCh2b2lk
KQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArdm9pZCBzZ3hf
ZGVjX3VzYWdlX2NvdW50KHZvaWQpDQo+ID4gK3sNCj4gPiArCXJldHVybjsNCj4gPiArfQ0KPiA+
ICsNCj4gPg0KPiANCj4gWy4uLl0NCj4gDQo+ID4gQEAgLTI2NSw2ICsyNjYsNyBAQCBzdGF0aWMg
aW50IF9fc2d4X3ZlcGNfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPiBzdHJ1Y3QgZmlsZSAq
ZmlsZSkNCj4gPiAgCXZlcGMgPSBremFsbG9jKHNpemVvZihzdHJ1Y3Qgc2d4X3ZlcGMpLCBHRlBf
S0VSTkVMKTsNCj4gPiAgCWlmICghdmVwYykNCj4gPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gPiAr
DQo+IA0KPiBVbmludGVuZGVkIGNoYW5nZT8NCg0KVXBzLCB5ZXMsIG1pc3NlZCB0aGlzIG9uZSwg
d2lsbCBmaXguDQoNCj4gDQo+ID4gIAltdXRleF9pbml0KCZ2ZXBjLT5sb2NrKTsNCj4gPiAgCXhh
X2luaXQoJnZlcGMtPnBhZ2VfYXJyYXkpOw0KPiA+DQo+ID4gQEAgLTI3Myw2ICsyNzUsMjMgQEAg
c3RhdGljIGludCBfX3NneF92ZXBjX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwNCj4gc3RydWN0
IGZpbGUgKmZpbGUpDQo+ID4gIAlyZXR1cm4gMDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBp
bnQgc2d4X3ZlcGNfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkN
Cj4gPiArew0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwlyZXQgPSBzZ3hfaW5jX3VzYWdl
X2NvdW50KCk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJldHVybiByZXQ7DQo+ID4gKw0KPiA+
ICsJcmV0ID0gIF9fc2d4X3ZlcGNfb3Blbihpbm9kZSwgZmlsZSk7DQo+ID4gKwlpZiAocmV0KSB7
DQo+ID4gKwkJc2d4X2RlY191c2FnZV9jb3VudCgpOw0KPiA+ICsJCXJldHVybiByZXQ7DQo+ID4g
Kwl9DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyBs
b25nIHNneF92ZXBjX2lvY3RsKHN0cnVjdCBmaWxlICpmaWxlLA0KPiA+ICAJCQkgICB1bnNpZ25l
ZCBpbnQgY21kLCB1bnNpZ25lZCBsb25nIGFyZykNCj4gPiAgew0KPiA+IEBAIC0yOTEsNyArMzEw
LDcgQEAgc3RhdGljIGxvbmcgc2d4X3ZlcGNfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGUsDQo+ID4N
Cj4gPiAgc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgc2d4X3ZlcGNfZm9wcyA9
IHsNCj4gPiAgCS5vd25lcgkJPSBUSElTX01PRFVMRSwNCj4gPiAtCS5vcGVuCQk9IF9fc2d4X3Zl
cGNfb3BlbiwNCj4gPiArCS5vcGVuCQk9IHNneF92ZXBjX29wZW4sDQo+IA0KPiBEaXR0byB0byBz
Z3hfb3BlbigpLg0KDQpZZXMsIGlmIHBhdGNoZXMgYXJlIG1lcmdlZCwgdGhpcyB3b3VsZCBnbyBh
d2F5Lg0KSmFya2tvLCBhcmUgb2sgd2l0aCBtZXJnaW5nIG9yIGRvIHlvdSBzdGlsbCBiZWxpZXZl
IGl0DQppdCBiZXR0ZXIgdG8gaGF2ZSBpdCBhcyBzZXBhcmF0ZSBwYXRjaGVzPyANCg0KQmVzdCBS
ZWdhcmRzLA0KRWxlbmEuDQo=
