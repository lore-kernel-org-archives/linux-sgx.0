Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A96A94F;
	Tue, 20 May 2025 06:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747722133; cv=fail; b=AdT5J/uOB6m8Z5ZcXl3aQoPLR1y4EvZJiauklxOi7U7t9U4/E2AJS8Itj1uRo2edEsQtuUjNl7MrQSFW+cWdvOCNALkXN9iFEVMrsxBA2N9cMr6WibrXlHdZ2bjP9WBIXTw5ZiFf5arCvpZR4KZSpJeGkhvlFrW6Ky4ut7uTFOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747722133; c=relaxed/simple;
	bh=eX5Swc5HWMV51rwhs+GndSfjNOU2LCq/VMRFk+8TcLA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MkKEVm7MO1PnIOGBDNCKyyvby0fIR+xARg0WXUpAo7kyeKnTMRlYflZaEyA+78OPfJUiSVHLxSGi64L4u8fh/bzscDPFUlXfOomY2VOtiLjXcuACq3ks+ySaKeuzwsC1YWoUM7h6tl2t83Sr/fFgWLcqHk6r9BWSJbShu/EFT1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lJn9Xups; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lJn9Xups"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747722132; x=1779258132;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eX5Swc5HWMV51rwhs+GndSfjNOU2LCq/VMRFk+8TcLA=;
  b=lJn9XupsNGdAfuwnMQ5kiMukUl90/8wSD7h8ZqUnIL8MkuXfUJmuaieH
   C1eSTTudYCy3S+pDsITSWsRig7EGvktEeBbJSzcvN5nGNKz6k2nbt+v3l
   MsbtgwfWcDEYaglJJwudko47O8DOF1vO2ZQw3l2QUQDT7QCKqpAh4n3Am
   AeNL5/7oF4o9qeXrA5xY/pCoPGPqLl7PxsOpPqqIaPT+aBBbFpFDp5o7n
   rnkJQQHhbDRO1vDKWHc7UutZOHWlCyclkoGT6M82FRtvafkDynHc+wBvY
   1qCdMDUE4nx7SLcUe998q7LXFAQ9jQ1kJIUVceXr1ejS7kxvFSYOxqO0K
   Q==;
X-CSE-ConnectionGUID: BItFpKjyTL6Vgk+KR6Sv3Q==
X-CSE-MsgGUID: 5VJMpv9sQhK+rNskTAHKsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="37256713"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="37256713"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:22:11 -0700
X-CSE-ConnectionGUID: x/xaTlz1QW2FubjwCRi8gw==
X-CSE-MsgGUID: 8NCVnSHDRQiS2w1nUXugtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="139322777"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:22:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 23:22:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 23:22:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 19 May 2025 23:22:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LtSHlVU51gRu5oYz/J+iPlPgHh+r1Z0Z7ZUhDFlHJNb0hoct9Vay79AXVvbw4cCFQa1io6mRDkkGvtF4NzoITW3KImbsYZoAv6DvPapqxQfflqUri0e7lLUtEUYG8m2ioeMCeHzMZT1uyC32FdC5dHdllRLiG9vphV0iQHcVOp19HJGI1YyfRRt25rDCqMgAeSNA72XwlervGxSk2RwKB3QiYwM+EKnpzPfb6B9KbS/VnNGY3O0qpft9RgLpWip9LEhZ+GofjslsBzwE0hGvk+MaSjFtw0ZlAdVqPrrsTwXuDpIpFUa8SxPJDESAwnRARw5GWcfb1IV7hT3XLmfXLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eX5Swc5HWMV51rwhs+GndSfjNOU2LCq/VMRFk+8TcLA=;
 b=KNTtHRVNF1tLLclFbKwC7ZLYqi4A6oiWWAI4h62LSTMj+0lLymKqB9DjDtIM0YooTa1IztEv1ca+jNEpzvdMhpsDUeDop7Py0jWyKheCvkEcF5hpMTrShUbEH31uI1KpIMWa9l664aV2rPkJKMjwIo5mOX82l2YaxmRKUz3NJYM6xW3RJ22g10GMJZUebEI1H4dtAz5kHNiiIY9d9aVFaaKl4fILtLb8fGRqdiyDZPCs+DCY2SsLomnMD3tUtvBBgmfEjJ2K89CDcf9tZIslFRrebw1OwtOQYg9F0O3zHLOXkXEEC6Lgl+Qwd97wR36Qs82hF+foTUAkVB9Edj0xXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DM4PR11MB6192.namprd11.prod.outlook.com (2603:10b6:8:a9::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.29; Tue, 20 May 2025 06:22:01 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Tue, 20 May 2025
 06:22:01 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "Raynor, Scott"
	<scott.raynor@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Mallick, Asit
 K" <asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Cai,
 Chong" <chongc@google.com>, "bondarn@google.com" <bondarn@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: RE: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyI9kSVxmTXaknEyFmJx4IavRXLPZxbaAgAAP8YCAALWGAIAAgjrA
Date: Tue, 20 May 2025 06:22:00 +0000
Message-ID: <DM8PR11MB5750579B7AFDBE49400AE5C6E79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
		 <20250519072603.328429-2-elena.reshetova@intel.com>
	 <c955515c5469dae17faa13ebda28459d7c998bb9.camel@intel.com>
	 <DM8PR11MB5750A29C0878480F6F19E39BE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
 <79eaa1d4671c7bc93910ca3399bf5b023c52efa6.camel@intel.com>
In-Reply-To: <79eaa1d4671c7bc93910ca3399bf5b023c52efa6.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|DM4PR11MB6192:EE_
x-ms-office365-filtering-correlation-id: 20ef381f-c2b1-48b0-7f55-08dd9766a195
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NE1pWk8ranU0MmQ0ODNiZ21DdnNDbUNNbUd4SFNOTmd1Q3NlVU9POHVMdnBE?=
 =?utf-8?B?N2FyZ21nZDBOWjBSdzgxNCtqWUlVOGY2K2RROHFTdkdqSlJGUlcwSSsyc0l4?=
 =?utf-8?B?SGVwM2htdjVuUEhnZFJWR1FaMTRTeHJ6bU55TFF2NjB0c1BiUGU1VGVVVmFu?=
 =?utf-8?B?eUpzU0kwRk5WZ1Z0NDhOdmlESmo2dkg4TUgxUUFseHB0aUFIQjFUOE9iVUcy?=
 =?utf-8?B?bHhUaXd0d2FlakljaTVyMi9jOVlMOC9Cdnh3SkpYZWVTYXlEcE9LVjRUODlr?=
 =?utf-8?B?akdpUm9NcjE3L3ozTGJSK3JFdjBmNFlOWHBuTTdPT1N0bUJBcFBuM0FXWVAr?=
 =?utf-8?B?ZHZ1ZVFza0xCdFlkQVh0Rmx0azVoTzlOa2RFajNiRUZMeUJKaXkxOFBZVDM2?=
 =?utf-8?B?bFVJam1KdXV2VGpOcklzeTAvNi9FblF6Y3pvSy9Ib3NDd0hJTkZvaXBxUUht?=
 =?utf-8?B?V1UrWWJUcGxaME1TSEdIK3FFZTMvSTE0Um81TzBxTkVkSk1zV0w4VnZlTW9j?=
 =?utf-8?B?M0kwcFc1TVNwWFJBY2NTSFVsWElubVZDVVBtemNUcTZOVXAwbVZtakRGOFpV?=
 =?utf-8?B?bzJMR0tuUWdLMVcyYTgrTml1czFYWDJ2OThvUjZ4SVQ5eWs2cnFOUlBRL3E3?=
 =?utf-8?B?R24vcTBjdWV4Q2VGbnoxV241R0VWUGNQbWVUN2JLdGplUUdIY3hTWVBham9m?=
 =?utf-8?B?R3pXZjFVKzRmM1NWM3d4U2ZpeERXY1RiYXM3azllUDJsUFhhVjYzaFlIREZW?=
 =?utf-8?B?NmY4dGhaL085WWxzM1BqMnN5OFpMZC82ekR1QXE3SEpaYWNYNS9acVJlcmkr?=
 =?utf-8?B?dEtkOE1scFNWNnNic1lFRFJtMGpaK0hoSk0wYy8zaCtDTWtkWWNXdDNidU11?=
 =?utf-8?B?UlFQRy9yV2hCQWZrL3ZBNEZ0dC96ZDJsdXA0TDRWeWdxMlJ1MHlBM3VaanhS?=
 =?utf-8?B?UHdTcjMzNXpGNTFpQUxtZ3piRTBFRS9XRDhkTDhxWURwS2wwM0tNZ0J3SnY0?=
 =?utf-8?B?SHB2bktMbUtuN0phQVdNc2hOckdIWllGK05RU2Q4RWUvZ3hEMTRuakd5WVhs?=
 =?utf-8?B?M0x5VTRFbHg0T3l1RUNpUXFjYVR6MFlmb1FzVGNvOG9yS2laZFVGMnF1V1dI?=
 =?utf-8?B?aTdUTjMxY3dXWk0wZ1U0YnB2eTgvZzZxSGl5b3o2Y3VRZVdkdTJLeWVOMmJG?=
 =?utf-8?B?N1c4bEpwM1hnZzJ3bmhQSXZtTEVjRURlRk1VaXV5U05DMW9lQmphenJKT2FY?=
 =?utf-8?B?L2dUMkdpV0pMSkhOc3FXTk1ZSmtNdzlyR1pQalVsMlhHSVozZ2pYMGxZS2xP?=
 =?utf-8?B?dFhaLzVUU1Iwc01rcUIzRmVLVHN5UXh4cGtwZ2RpeTdHZlg0ZVpQeWZmVVNF?=
 =?utf-8?B?UHkvQzZZUGlIOE05MStGV1FzM2FiV01ncDJrZHdNa2NiODcwRjZMMGIxMXNw?=
 =?utf-8?B?aUY1bHF3dGpzbkI1Q2hyeXRvSEVNMG1pZnJIZCtyRGtGdDNjb3l1Yy8xTlJ1?=
 =?utf-8?B?OE8yd1ErYmlNeUUwM0U5MFNYMTZUZ3VxTm8xWXg1YmF5RVNKYjQ5eFVMSDBO?=
 =?utf-8?B?NmttMi83UzFyT1loM3RXcWhiRVc3blZySmJ0N3ZhUmJBSHVGRkxQZnJ0WG5D?=
 =?utf-8?B?R2lZRS9KNXNBNE1pQTI2UUFZZVZIck8yaGpYNW14Wk1DSmJ4QlNRM0ZLK05z?=
 =?utf-8?B?Q1BMSVJ5bjRNT0h1Z3pkQ3NqZjVQR3NuMDN5ZXNEQWZxYStKNDNyai8zaVk2?=
 =?utf-8?B?bXlQaFZ4TklEb29ONk15R1lLWDJaMTZnNG9ITUM5c1JaeVpJV0VpZ0dkQ1JH?=
 =?utf-8?B?dkhBZzV1eXlkdGo4UVVvZUs4cWRkQkZsMG9ITU1RT2c5TXdXdFlDaFNMdGli?=
 =?utf-8?B?Tmk1QjJnVzhvS1lqbmk0Y1pTWU52bzFzUWk2OWQ3VHlvNDBNaG9XQnZzbVg2?=
 =?utf-8?B?R0Y4NHFyd3VCQW5ES2dreFFxNXZXVUtJRks4aWNwMUdxa0NQcmdDM3NFY3dH?=
 =?utf-8?Q?i3Z/2f9oVejEiNA/3sGNDwXs47bY3s=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elVrcUtpNkZjRFpnSWV3VnYvU1hBcHREd1BMSUx2SHRwckhNakd6WHc2WGh6?=
 =?utf-8?B?amZ4d0lrYlU4TFpjV1BKTHAwUnBaeUtiVUZMNVVLc2ZweFcza3MvamVxa2lz?=
 =?utf-8?B?UzVmZlRmVVdteG51cGxQcE53WUVsVjd5WjgvdldsMUhvU0psVzNVSEVTQm0x?=
 =?utf-8?B?aFhGY2JxSWpnSjVMYnNIT0tLYkdqRjdPTVVEV01aUnZKWUJ5Yjh2TDRLWU50?=
 =?utf-8?B?WTVPRHZzTWJyVVJOaXlub2hLRmh4aUVGL1F1K2d5SC9UdlN1WnVVZjFwWXJT?=
 =?utf-8?B?b2pYVU93NGhFRXoyY0JQVmFFcC85QStMRXZxdTUydzQrczc0Tzh5WXVzWXU3?=
 =?utf-8?B?Ymh3WlRLdENZcFZtdnVHSFBQd1g1Z2R2MGxzSFhCUW16OHRWeExyZDlrV3BD?=
 =?utf-8?B?YkVoeEZxeTJUMXV0UncrcHRwdnFGcmlsd216NHNjYWs1b3VTUzNDbVVKLzdQ?=
 =?utf-8?B?a0dtV1poYlNadDB2TjRIc0U0OWxvTDVlQ2x3THFta0Q4Y0FlYmw5RzdtQnpw?=
 =?utf-8?B?RC9ycitUVkkvUkNjckwxTkpaeFlqSFlWTG1nZGIwZnhrUFkxbklEQjljY1NG?=
 =?utf-8?B?amJlNEFlajdTZzlCODk2K0s2Y1FVSUYwcEM4WGs0RGtUay80b3J3SHlDT0dF?=
 =?utf-8?B?R1o2VUhnMVJCQlJ3ZWljMkdlZXNoVnJtUnlKc0pyZFN6YjJ4Qkg3RW1ZK1Iy?=
 =?utf-8?B?MDgrZ0FNQ1BNbURKQXJwL1E5NksxTHRZMFNFM3BXZnUrc3lYQkhpeGM3a1RX?=
 =?utf-8?B?RGljU1Nad0ovTjM0eVhQem04Wlh0MkN4eUhFREhjYm4rUXp4M1Rib0l2Q1Q1?=
 =?utf-8?B?N0xYaEd2Rk8wQkpUVzFlWWdiMDZydThKVFVKcjBNNWtHTXlWbDhZKzI0T2tM?=
 =?utf-8?B?REZLekFUOWdHOVhzN1htU01MYlptcThmTktlMEVWZ1JNb1BYcFdzL2dnVFNB?=
 =?utf-8?B?ejhDRVFYdHNUUlFNSExhdlJiU0l2d0hUTzZxTnNCRkdNMnljRTA4eFVHRmFl?=
 =?utf-8?B?ZlIrM0xuMFdSYTVzWGYrVDdlL2R0MEsxNEpZVXBBTGQ5THNXdDFzelhJVFp2?=
 =?utf-8?B?a0JMZEQ2R212M0ZpUWVxQjBzU29YbXBmMk5ISjF6ZU9hRmNsZFNCM1FjSHR2?=
 =?utf-8?B?QTVaUTd2Y1hhbzRYUHdQazJ1aDV4VHZkUnF1TXBvZG1nOHJsZTdEWmREMVRF?=
 =?utf-8?B?Y2k4UGI3TlFhejNhNjZBb2wrWjZyYVVILzVXWjZhOTE5L2xTTlBSYkQxYjM2?=
 =?utf-8?B?cTJWcUdLaUw1QjhWT29CSkw0N0J4L05CbVNEcE11UGlUdVc4SVdjeDFzd0Mw?=
 =?utf-8?B?NkppK0t5NzdxMk9LQTVMamkxbVViQ1R2ajNMRzgvRURVOVFwVVVVTWtIRklj?=
 =?utf-8?B?R1RnaW82YkxRNWhrWVdaaUYrR0U4cms0cEhmcmdpNEtmczdXYk9qMU9lVjVh?=
 =?utf-8?B?dkxNbG9uSDdQbWdWSnU5d3FPelcwY1VadHQ4YnRFL3E3R1BVQW0rS0pEY2Jy?=
 =?utf-8?B?ZVFUQlUreHprcko0dnByOGFCZEtrR1E1MmI0ZnRhVktBRXF1VHduYnVha1hJ?=
 =?utf-8?B?RldMbGhydURaWmxFRDBhMmhrWUtML2N2UXhKeEFSUW5VS2h0ZFVyc1ovTDZu?=
 =?utf-8?B?OXEvTHRhR3hiYVpwbXc2Z0pMc1hibEZJT0o3NjJIN0dhSWZqMk5NNEpGRS9y?=
 =?utf-8?B?UlhCVTBxemJjUS9HSTBwZ2Jpa0ZSZjV1L3hsNHdwdG9tbGVoNTBOOEpGdEZk?=
 =?utf-8?B?YmV1ODF2NE1VS1hiOVFCQXl4dlpzOENxK2NubWxlY1NGMXNVeXNONlhOWjlN?=
 =?utf-8?B?RUgwQVN6VTdpWk0vVmVJbXlpdGwzWDgzckwyc2p3SG0rSzBjSE1NWVBlZEll?=
 =?utf-8?B?cVlaaUt6WTZGbThpZENaKzdMSFZKeTMvUmtCb1NmMVRWK0F6UlFOOU04RVhL?=
 =?utf-8?B?OGhOVDZsSmw3SXhWdFdZTUUvMkdQSWNrMTJoZFBvc0luSStrdlhGNGRGMUxo?=
 =?utf-8?B?a05jaENjR2pIQngzRnRZUTFDN2NQdDVHZ08yU1NTbC9qRVlIalppcFpkY2RM?=
 =?utf-8?B?MXBpZXZaaGw3WGpzZlpKWE9LYjkwREt5cUZtVzlNWFlpTHYySkNDd3RZaGE3?=
 =?utf-8?B?eWVQM0ZYUi83NnpBNkVFOC9qRmMweTdPU29wbmhzQmQzNENWUFNZZm5xUGJU?=
 =?utf-8?B?VGc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ef381f-c2b1-48b0-7f55-08dd9766a195
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 06:22:00.9600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 73tcIFyux1CYi6mOWdn+/JADdFD8fW52eT559P33Fvpl7XBOMw/1XebFLVnfOdT7dvvjpABKH++GPSNoZRbSRgEUDcXXTaczvNSkZQy6TC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6192
X-OriginatorOrg: intel.com

PiA+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZHJpdmVyLmMNCj4g
PiA+IGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZHJpdmVyLmMNCj4gPiA+ID4gaW5kZXggN2Y4
ZDFlMTFkYmVlLi5iNWZmZTEwNGFmNGMgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2FyY2gveDg2L2tl
cm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+ID4gPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUv
c2d4L2RyaXZlci5jDQo+ID4gPiA+IEBAIC0xOSw2ICsxOSw3IEBAIHN0YXRpYyBpbnQgc2d4X29w
ZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUNCj4gKmZpbGUpDQo+ID4gPiA+IMKg
CXN0cnVjdCBzZ3hfZW5jbCAqZW5jbDsNCj4gPiA+ID4gwqAJaW50IHJldDsNCj4gPiA+ID4NCj4g
PiA+ID4gKwlzZ3hfaW5jX3VzYWdlX2NvdW50KCk7DQo+ID4gPg0KPiA+ID4gVGhpcyBzaG91bGQg
YmUgZG9uZSBhdCB0aGUgZW5kIG9mIHNneF9vcGVuKCkgd2hlcmUgdGhlIG9wZW4gY2Fubm90IGZh
aWwsDQo+ID4gPiBzaW5jZQ0KPiA+ID4gc2d4X3JlbGVhc2UoKSBpcyBub3QgY2FsbGVkIGlmIHNn
eF9vcGVuKCkgZmFpbGVkIEFGQUlDVC4NCj4gPg0KPiA+DQo+ID4gQ291bGQgeW91IHBsZWFzZSBl
bGFib3JhdGUgYSBiaXQgbW9yZSBvbiB0aGlzPw0KPiA+IEluIGNhc2Ugc2d4X2luY191c2FnZV9j
b3VudCBmYWlscywgd2UgZG9udCBhbGxvY2F0ZSByZXNvdXJjZXMgeWV0LCBzbyB3aGF0IGlzDQo+
ID4gd3Jvbmc/DQo+ID4NCj4gDQo+IEkgaGF2ZW4ndCBsb29rZWQgaW50byAoZGV0YWlscyBvZikg
dGhlIGxhc3QgcGF0Y2ggeWV0LCBidXQgZm9yIF90aGlzXyBwYXRjaA0KPiBvbmx5LCBkb2luZyBz
Z3hfaW5jX3VzYWdlX2NvdW50KCkgYXQgdGhlIGJlZ2lubmluZyBvZiBzZ3hfb3BlbigpIHdpbGwg
cmVzdWx0IGluDQo+IHRoZSB1c2FnZSBjb3VudCBiZWluZyBpbmNyZWFzZWQgZXZlbiB3aGVuIHNn
eF9vcGVuKCkgZmFpbHMgYXQgYSBsYXRlciB0aW1lLg0KPiBTaW5jZSBzZ3hfcmVsZWFzZSgpIGlz
IG5vdCBjYWxsZWQgd2hlbiBzZ3hfb3BlbigpIGZhaWxzLCB0aGUgdXNhZ2UgY291bnQgd2lsbA0K
PiBub3QgYmUgZGVjcmVhc2VkIGNvcnJlY3RseS4NCj4gDQo+IE5vPw0KDQpZZXMsIEkgYWxyZWFk
eSB5ZXN0ZXJkYXkgdW5kZXJzdG9vZCB0aGF0IHlvdSBtZWFudCAqdGhpcyogcGF0Y2ggYW5kDQp5
ZXMsIHlvdSBhcmUgY29ycmVjdCBpbiB0aGlzIHBhdGNoIGl0IG11c3QgYmUgbW92ZWQgdG8gdGhl
IGVuZCB0aGF0IHdlDQpkb24ndCBpbmNyZW1lbnQgaW4gY2FzZSBvZiBmYWlsdXJlcy4gDQo=
