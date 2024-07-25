Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4F21114;
	Thu, 25 Jul 2024 00:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721868740; cv=fail; b=OPxIQWYAQPyT2hkR+lm+97Qh2oPf4v37jxT+6//18iLuQwKvf3XBsPkIgeQOZVjkk2FQ/QmKuqhZF2YCxLIpQfaxkg6Ae7+ukDheJlMWhWBMFK4V6oQ2GltTgtcPg6Emu07a3faNnaMSU+Mvvw8r8Czd6ohhghetGyNAKYWaM9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721868740; c=relaxed/simple;
	bh=/fnl66FPb8ied9kDPdzmt3+bMA+CrbxNCD9uUKCCGwQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qm8SKjatiGSFoROA8lfwoVjKqgveVbLfuxnvPWyvqojKz+mOb8AxlSAgGd6+3L4GrDg7XJuBQdzdTJ8joNsZu21fU7j1XShvd941eA/OK6JjHhIHPtjtzxqmpI9kIvBGBnP0X19gDJtQ+Vq4BdvqeOYLZj5O5Oahq/YJ5fdsC38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OI6FZhNO; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OI6FZhNO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721868739; x=1753404739;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/fnl66FPb8ied9kDPdzmt3+bMA+CrbxNCD9uUKCCGwQ=;
  b=OI6FZhNOJzuVxfc7rJxb/Fi3qtWpgzGvGeXVAetQDrdd4X1bZ8e91Cfk
   7UxNWB47wMU232oEyGMMjOwrl/F1rRyGhyFx/l9fDiqIooQA1JR/taEjP
   BFs90xGr5CCkFbK/HdwEaR7BQ4bW46HYbd8k/idIDWo7TCgic2TL7V7Xe
   ZcUKu4AYXqguJ/s8viKAwz7e45PA01IiZPHUYLVlWzwGCH+fOAj/OEEZX
   21Mz/FzuGy92qX0wsvk3sWgMWGFQ1yRWCjdauW2ze0ECDzVzlxEigW8hJ
   b+11ZGtj9Eg2L2Jr/zjYZg65BUV+Vk/u+VsgcI3G/LkzdvWFv2s3sI8kP
   g==;
X-CSE-ConnectionGUID: FbvKPzpiQHGS9HCv8A49KQ==
X-CSE-MsgGUID: Ku1L9AoST9eXyOp+h7j7Zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="22490551"
X-IronPort-AV: E=Sophos;i="6.09,234,1716274800"; 
   d="scan'208";a="22490551"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 17:52:18 -0700
X-CSE-ConnectionGUID: 3RfLNTokS9q3kZBLCWeygQ==
X-CSE-MsgGUID: wd4ABQdkShOj7MkxtIYw6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,234,1716274800"; 
   d="scan'208";a="52631021"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jul 2024 17:52:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 24 Jul 2024 17:52:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 24 Jul 2024 17:52:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 24 Jul 2024 17:52:16 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 24 Jul 2024 17:52:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lHWsUexVqbSkR7zcxxmF2OqneIO0bo1S55PnkrpRmzqnktkm8w5KkY7BBXwtpCQ4SSPMdXqcPoz6/lpdaLStOFK5G0A5ycOOwiw/nsPtUoL/rJGV0GzCYs3fs3fmyufRivM32kMW+tLfg28YECSN9Q1bWSwj39jqjAr6KU8rNl5QcGUVZ9ngd4j7IEtqAodkX3atJNcI7aFb2C4LlulxpimTwYUmoYE0iHr2wqoO2RpN87NgaNga3M+QGChj/ocdtPvbLnekRTqmbGkSDQsZ2lo5AcH968reCfhuQd0wCcOB2HfQEOljSoTIjJBphGCqFlAelcgMAZn8pXyEhuU/bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqEufy7HYScYEnML9t5Rpmj/Go5wg90HQloT3u8Kyt0=;
 b=iUbqIcZ5Q2lrWJaJiCQqu0LOID9vcdOhUmrVqPhE6xfe18LU4J3mUFJYSNwZCmCyY8fCACfWoogxiqEt7kuSsyu5bNSDrT52ouJZHIB4EPflr+gPNnVPN+x7uVQm1HnpGUGHnhaaThLkje7Bm/6O6s7in13jM3ghNY9KoeQbRa585nh2xFdR+GL91m77j9D1OM/tdI0O1BLNr+hY/rCg7zQM/VgA5I90Yko4FCbIEFo7zvmE3oKSfu9vu5pNgXYW344RGwD8UVScaEC4y0BZ3QXHWP5blYFtGvkcDzUCgo497iCfL1dCoqkA9dMuX83tK2HQL+3R+WiPCGGCtNJW8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB8179.namprd11.prod.outlook.com (2603:10b6:8:18e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14; Thu, 25 Jul
 2024 00:52:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7762.027; Thu, 25 Jul 2024
 00:52:13 +0000
Message-ID: <016c34af-399b-480e-a99c-eaf3e397d33a@intel.com>
Date: Thu, 25 Jul 2024 12:52:05 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
To: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>,
	<dave.hansen@linux.intel.com>, <jarkko@kernel.org>,
	<haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
	<linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>,
	=?UTF-8?Q?Marcelina_Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
 <20240705074524.443713-3-dmitrii.kuvaiskii@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240705074524.443713-3-dmitrii.kuvaiskii@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::32) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM4PR11MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 772d4b70-8794-48d3-a194-08dcac4405e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SmRjcDdmbHc0QU1BN2FjRXpkMktwNUZ3MjdGM29DUlRldlFOVENmMDF1Q1ll?=
 =?utf-8?B?SzFzczYxdnk2VGRlTXIrVzhJcnludFdqVGlacXNzQnAzYkJ2Znl6N1ljbTAx?=
 =?utf-8?B?VDJJWm1IZUpCM0pobFJtVk5nQ3Q1ZWFGbFlCVWF5WTdRQTFxeTRDSC9HLzVt?=
 =?utf-8?B?eVdKSXc0VHVUQlk4YW9PTG9KeFZZRTVYb3RuZ1A3NnBlTXhpcm1sV2NzY0NE?=
 =?utf-8?B?UjJURm02UVdFVjgvV0FtR2ZaYzBXeW9Ddi8rTUlyd1JTbVpsWlFoczg5OUds?=
 =?utf-8?B?bUxSWFNWb0tveVJucFVacXg1UEdidTNKQ3piUEt2MzROT0dEUkNPNUFXQzJY?=
 =?utf-8?B?c1B3L0VOeHEvQ2xNQk5vdVdRWFc1eUxTL2hYdTQzcjNCZHJCa2lXbXdiQlZW?=
 =?utf-8?B?QnRWZElqemVLMjlZMFE4T01CaDRBWW1JSGFNOHZvdWtzYWZJZVFPTm1JQld2?=
 =?utf-8?B?OERJR2RFdkljRTRaRTN0UUFtSTQzOHlyRGMydUdFMTN4U29id3d4QTZEUC9m?=
 =?utf-8?B?M0JxaGR2ckdBLzM5Z3VPZGJJdHgrN0IrSjRZNk1XYnZsL1NQR25GZUVMUjg2?=
 =?utf-8?B?NUwxanNrTHAzRjZvdWVvZGcyMzlvRDVBR0JlRllmeE1XeUdDQXNpVzl1YWgr?=
 =?utf-8?B?UjBJYkxmSWJ3RE1tYXh1Nk4wTG5nc1QwMnl3NTdVL2hXZ1lCK2cySUZ5MlEr?=
 =?utf-8?B?RDNxenYyMjBlU1VCUW5NQmwrTkJ1Z2paaEhPUjZUSDI5R1RVTk5ZekVXdHFx?=
 =?utf-8?B?MEVCNjhZTWZCMmtNV2RZV2krSUFXSDArcjdNSEUzMTNGSFFvOFdqaXRJMHpl?=
 =?utf-8?B?RFdITHVESys3d2lBQXlYVFFiRUN3dnFmZzA0cUI0Y0d5YWk3SlFaNWtuUFNP?=
 =?utf-8?B?OHZWY3pLZFVBNDNiU3pKR1Mwc0NKZnMzSDRFR0pwSlQ1ZUsyNDNQbU14dHM3?=
 =?utf-8?B?V1NIMGxJQ0k0SlpYUHRFTDl6MWJCanhuOFgrU09YZW0vZ2xVZXplVm8vUmhl?=
 =?utf-8?B?RVVtTFVtdUoyZG5taG0wZFdEYXBIWG5qa25jc1JmNzFLdG1hZVFoOUFUZXJR?=
 =?utf-8?B?MnYyRDVta2JpVHJSOHBOMFdoZGFGY0xxTVBKMENMelphcmJJRmtEcXZiY2pq?=
 =?utf-8?B?dUE2TXJTdUZyN0Qydk1PMFV2VWtDOXFJR2grdnkzL25pcDIzcVNFbFhNdUxv?=
 =?utf-8?B?cHV6eWxvdXozRzBuUUM4Y3Z3d0oycXUxeXpQeW52NnZTc3pQME1jMVM5Y3hN?=
 =?utf-8?B?QWVpbVZnZXROVCtjWGVhUmY1ai9wL2VOYW82U0I0S3daT1pLQUZkaXR0MEJ2?=
 =?utf-8?B?UEFqT2pLVlhBTFo3bDdXVU5uRlpwQThRdHdiUlJDWjk5emY2QUd5WXVDQjNj?=
 =?utf-8?B?VTZzRXNtWVVwcGR5cFIwdFZFVTVFOFhOTjQvRCtpM0dqVk4zaVFFaE4zTUZR?=
 =?utf-8?B?aS83RTFYUXZQeDFiSS9STHl3ZmVTbGtudElpVnVYYXNvYkRLQnNpMHNjTDBJ?=
 =?utf-8?B?TUhRYU12a1VhSmpxSDhCMlRCSHVPaGtTQzNoV0VVcmRsS21jZy9pRzFHUDkr?=
 =?utf-8?B?b0ZDdFNNQUYyd0dSUTAyb3NiZEcyK01YRUY4Lyt4TkxudGtNL0hKZkl5elZR?=
 =?utf-8?B?eWZ1ZDBaRjBEU0FLNU9Gd3VzdFZpQmZrMXZGLzgxT0xZQUZVOXZrd2M2MWpT?=
 =?utf-8?B?QlZpQUFUczI5TVR4YWZWVHJuRU5yc3NndjAxMm9KZXNuaSs5UzRqL0hHOTdM?=
 =?utf-8?B?VEZQWVpSUHhtZ2tmK01kbkIvcEZkcGJYV3NMZk1vOXNVMitOYVpscS83cmtS?=
 =?utf-8?B?TUdJMFRVWlRmdWlOZk53Zz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1dhbGl2YklqM2lqMnZTUVVUU1VKbElSeSthOEZmRlFBN0twS0l0dysxbFYw?=
 =?utf-8?B?ajRkQ0paR05XK0lmTTZhaWNtbXNDSndZRVpvaVZRV25NZ05jbTdUOG9takVS?=
 =?utf-8?B?ckVneEY2N1ozS2oxTFpUSTBmbDJBME5qV0QvbFBnYVlBU01VLzhncGVxV0pn?=
 =?utf-8?B?WWdxOTBITjkrVzFuNE43OG0vTGNZY2tjc21ZNTRBUlI2VXF5ZExwbGcyYkQy?=
 =?utf-8?B?VElzTDNheW9NOUpJOFljMjRWR2EvMzF2b01BeFFoMFB2a1liQnNtNWQrQnV4?=
 =?utf-8?B?QnhtcFBUUC9jRDZSUmJNdFpGb3V3Wkg0VVh3eVA0dmVoS1o1WkJ5aUZOZG04?=
 =?utf-8?B?UTJoK3hiTmdkOTZXMGlSU3psWkd4aXB5cEtNMjM0bnNrV3puc0RrbWk2OFhU?=
 =?utf-8?B?SVpkTWRjYk4rVHAzeGZDS2ZJYzZqREpoa1laQzZOWml6QTFwY21NRk8rQ3Zl?=
 =?utf-8?B?eVBIdmZXbEl5a0dTVGRENWtMaDQrQzAxb0NkWm1aUjRTekRoRDVsK2R5cmJT?=
 =?utf-8?B?NTRsZ3oyWnk5U0tidUFDMnJkenowRjdOZDFyajdIQ1VGYWw2SUpIZGFQalJG?=
 =?utf-8?B?YXVyb2FHK0JmUUdNRlNISERUbVJwUnc1ZE1LL0dmV0JkRC80UlZheEJxbUcw?=
 =?utf-8?B?eDNGUEFLRXhrRkduZjNPeUlpTHJlSnNhcGdjSGZCRGxobTArZmNTQ294VEN6?=
 =?utf-8?B?cmlURWNlTW81V2JDMzZEeUNKd0tNdDVSUmRrOXZBNjBSSllRL3g2SEt4SmFl?=
 =?utf-8?B?WGJjYWRsYXc2RHM2OFJjS0lPS2NzTm9Cb25ZQlpzZWlaNGpEOFJXSFJBcEY3?=
 =?utf-8?B?WGlvVksyTlJyVUpOakJFRjk2QktYejhSSjNPakZGeG9ZaUxsU3BiQnpCV0Fh?=
 =?utf-8?B?NCtQRXZvbXIzVzhLUi9RNFBpRGNJVS8rb0xCbVFHNTA3YVlkaGRDMTV2V2tp?=
 =?utf-8?B?c25QN3oxb0V5RUtxakVucUo4cUhXSVZmdFJMQkh1Sk5naXlwVHl1cG12ZnNN?=
 =?utf-8?B?OFRRd0tCQ3lmWS9LNHFKTmN1c1dldXdIS0RNN2lDSVIvYytSTFRQNGZ1b0l3?=
 =?utf-8?B?T29vREdRc0wrVTRvTDBXZzFQelh1NnE2cUNBNDNDN3NWZ2hHeHJtcDJOZk96?=
 =?utf-8?B?ZUQxYWs5YktOc3g2QXV2M0ZtZHZMbWtlN3Ivd3daSElTYmRKRmVVanlmYk43?=
 =?utf-8?B?UUlWZ1I4aWhaVXdjL2hMalVtb2xzdk5TQ1hsUTJpMnY1K3lSbzMzUTVGa0JD?=
 =?utf-8?B?R1UvQXpGOW03Si9YYm9mN0lIdGRFL05EZ2FxUzBPc2FSY2xwNnlaUnQ4ZnNq?=
 =?utf-8?B?TDVvYmdSbkRod0JCUWRrazRBaWhnbWdQY0I0YldtM2pCSlFJeEVNWURVTng2?=
 =?utf-8?B?WHNsczMySU9rMUJubFFEdXhtYnlvNUhuSVVVQnR1aDRxc0RuYTNwaUtRWUVV?=
 =?utf-8?B?dzl4UDVSKzNIOEtiNVVhbmQzV2N3WDRTUlgwczBUVjNScWt4eVVtWTZzNUxK?=
 =?utf-8?B?OW9vSGtkNVNhZkhQcGZGeFl6NjNIbk1GNFBJcUl5MVdzSmlYc0ZSSGxNZmF2?=
 =?utf-8?B?UWMrZWZoTEZXUFArNGpWdHpOZWFNVXhKVzZ3T0JRd3ZRVnJ4azduVFNwVnpx?=
 =?utf-8?B?dm5EOEV1SG1RVzVqUUprdGFQNlZEWTNSVUJ2WEZnRUtXRGpNOFlQRGoyZlV3?=
 =?utf-8?B?VEVydWxHdHF3MlZneW4zdzRjdEppY3E2R0V5KzI0OHIzanZqNkcxbmRYaWlK?=
 =?utf-8?B?UFoxd1greU9YNTRVbEl1eTFZR2RFVTQwYUJxdk9MT2xlemtNNXpwV3JWS1BI?=
 =?utf-8?B?NFJDeXdvQXdSeDM2Mk5YM3dlTGE4NGFIQjFoTDZkcWlSTldHNlhMWCtYU1JS?=
 =?utf-8?B?YkxvREJwZEFFUTRWY2N3Q0NNUHpBWmJ0MkpadllyaDJac3p6S1d0b1NRV1R0?=
 =?utf-8?B?eXJhN3I4TWJ1eTgwcnBNY1EzK2tETC92OUpNQXV1MFZQZFlGQjJCTE40Ylp3?=
 =?utf-8?B?M2dDRWw5K1BkTzVCZWdXRXRBdHI1SzZTMll0VU82WkJTbDhKdC9kMSs2UjdJ?=
 =?utf-8?B?WEM0enN3Wk5HTXJXOVhkc0Z2LzlTeWpPaVNZbUk3YTNaMFlsY28zd1c1Y3pp?=
 =?utf-8?Q?g2j4CpPgSm7e3cHiv/lMJylKK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 772d4b70-8794-48d3-a194-08dcac4405e3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2024 00:52:13.8084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KP4yl4N/wYDSlXKMQIr4ULjyd+6FZzD5VBJ+s5LOfwAq1A1bSSndtqtDloosn/HfZjOZ3uHJKb04qsWR9grtOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8179
X-OriginatorOrg: intel.com



On 5/07/2024 7:45 pm, Dmitrii Kuvaiskii wrote:
> Imagine an mmap()'d file. Two threads touch the same address at the same
> time and fault. Both allocate a physical page and race to install a PTE
> for that page. Only one will win the race. The loser frees its page, but
> still continues handling the fault as a success and returns
> VM_FAULT_NOPAGE from the fault handler.
> 
> The same race can happen with SGX. But there's a bug: the loser in the
> SGX steers into a failure path. The loser EREMOVE's the winner's EPC
> page, then returns SIGBUS, likely killing the app.
> 
> Fix the SGX loser's behavior. Change the return code to VM_FAULT_NOPAGE
> to avoid SIGBUS and call sgx_free_epc_page() which avoids EREMOVE'ing
> the winner's page and only frees the page that the loser allocated.
> 
> The race can be illustrated as follows:
> 
> /*                             /*
>   * Fault on CPU1                * Fault on CPU2
>   * on enclave page X            * on enclave page X
>   */                             */
> sgx_vma_fault() {              sgx_vma_fault() {
> 
>    xa_load(&encl->page_array)     xa_load(&encl->page_array)
>        == NULL -->                    == NULL -->
> 
>    sgx_encl_eaug_page() {         sgx_encl_eaug_page() {
> 
>      ...                            ...
> 
>      /*                             /*
>       * alloc encl_page              * alloc encl_page
>       */                             */
>                                     mutex_lock(&encl->lock);
>                                     /*
>                                      * alloc EPC page
>                                      */
>                                     epc_page = sgx_alloc_epc_page(...);
>                                     /*
>                                      * add page to enclave's xarray
>                                      */
>                                     xa_insert(&encl->page_array, ...);
>                                     /*
>                                      * add page to enclave via EAUG
>                                      * (page is in pending state)
>                                      */
>                                     /*
>                                      * add PTE entry
>                                      */
>                                     vmf_insert_pfn(...);
> 
>                                     mutex_unlock(&encl->lock);
>                                     return VM_FAULT_NOPAGE;
>                                   }
>                                 }
>                                 /*
>                                  * All good up to here: enclave page
>                                  * successfully added to enclave,
>                                  * ready for EACCEPT from user space
>                                  */
>      mutex_lock(&encl->lock);
>      /*
>       * alloc EPC page
>       */
>      epc_page = sgx_alloc_epc_page(...);
>      /*
>       * add page to enclave's xarray,
>       * this fails with -EBUSY as this
>       * page was already added by CPU2
>       */
>      xa_insert(&encl->page_array, ...);

Seems the reason of this issue is we allocate encl_page outside of the 
encl->lock mutex, and the current way to detect "whether the fault has 
been handled by another thread" is by checking whether xa_insert() 
returns -EBUSY -- which ...


> 
>    err_out_shrink:
>      sgx_encl_free_epc_page(epc_page) {
>        /*
>         * remove page via EREMOVE
>         *
>         * *BUG*: page added by CPU2 is
>         * yanked from enclave while it
>         * remains accessible from OS
>         * perspective (PTE installed)
>         */
>        /*
>         * free EPC page
>         */
>        sgx_free_epc_page(epc_page);
>      }
> >      mutex_unlock(&encl->lock);
>      /*
>       * *BUG*: SIGBUS is returned
>       * for a valid enclave page
>       */
>      return VM_FAULT_SIGBUS;
>    }
> }
> 
> Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initialized enclave")
> Cc: stable@vger.kernel.org
> Reported-by: Marcelina Kościelnicka <mwk@invisiblethingslab.com>
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>   arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index c0a3c00284c8..9f7f9e57cdeb 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -380,8 +380,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>   	 * If ret == -EBUSY then page was created in another flow while
>   	 * running without encl->lock
>   	 */
> -	if (ret)
> +	if (ret) {
> +		if (ret == -EBUSY)
> +			vmret = VM_FAULT_NOPAGE;
>   		goto err_out_shrink;
> +	}


... isn't done in the current code despite there's a comment for it

         ret = xa_insert(&encl->page_array, PFN_DOWN(encl_page->desc),
                         encl_page, GFP_KERNEL);
         /*
          * If ret == -EBUSY then page was created in another flow while
          * running without encl->lock
          */
         if (ret)
                 goto err_out_shrink;


And this patch actually does that.

But instead of using xa_insert() to detect such case, where we have done 
bunch of things and needs to revert of all them if xa_insert() fails, 
could we just re-check the encl_page inside the encl->lock and quickly 
mark it as done if another thread has already done the job?

Something like below (build tested only):

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 279148e72459..7bf63d1b047b 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -339,6 +339,18 @@ static vm_fault_t sgx_encl_eaug_page(struct 
vm_area_struct *vma,
         if (!test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
                 return VM_FAULT_SIGBUS;

+
+       mutex_lock(&encl->lock);
+
+       /*
+        * Multiple threads may try to fault in the same EPC page
+        * concurrently.  Re-check if another thread has already
+        * done that.
+        */
+       encl_page = xa_load(&encl->page_array, PFN_DOWN(addr));
+       if(encl_page)
+               goto done;
+
         /*
          * Ignore internal permission checking for dynamically added pages.
          * They matter only for data added during the pre-initialization
@@ -347,10 +359,10 @@ static vm_fault_t sgx_encl_eaug_page(struct 
vm_area_struct *vma,
          */
         secinfo_flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X;
         encl_page = sgx_encl_page_alloc(encl, addr - encl->base, 
secinfo_flags);
-       if (IS_ERR(encl_page))
-               return VM_FAULT_OOM;
-
-       mutex_lock(&encl->lock);
+       if (IS_ERR(encl_page)) {
+               vmret = VM_FAULT_OOM;
+               goto err_out;
+       }

         epc_page = sgx_encl_load_secs(encl);
         if (IS_ERR(epc_page)) {
@@ -378,10 +390,6 @@ static vm_fault_t sgx_encl_eaug_page(struct 
vm_area_struct *vma,

         ret = xa_insert(&encl->page_array, PFN_DOWN(encl_page->desc),
                         encl_page, GFP_KERNEL);
-       /*
-        * If ret == -EBUSY then page was created in another flow while
-        * running without encl->lock
-        */
         if (ret)
                 goto err_out_shrink;

@@ -391,7 +399,7 @@ static vm_fault_t sgx_encl_eaug_page(struct 
vm_area_struct *vma,

         ret = __eaug(&pginfo, sgx_get_epc_virt_addr(epc_page));
         if (ret)
-               goto err_out;
+               goto err_out_eaug;

         encl_page->encl = encl;
         encl_page->epc_page = epc_page;
@@ -410,10 +418,11 @@ static vm_fault_t sgx_encl_eaug_page(struct 
vm_area_struct *vma,
                 mutex_unlock(&encl->lock);
                 return VM_FAULT_SIGBUS;
         }
+done:
         mutex_unlock(&encl->lock);
         return VM_FAULT_NOPAGE;

-err_out:
+err_out_eaug:
         xa_erase(&encl->page_array, PFN_DOWN(encl_page->desc));

  err_out_shrink:
@@ -421,9 +430,9 @@ static vm_fault_t sgx_encl_eaug_page(struct 
vm_area_struct *vma,
  err_out_epc:
         sgx_encl_free_epc_page(epc_page);
  err_out_unlock:
-       mutex_unlock(&encl->lock);
         kfree(encl_page);
-
+err_out:
+       mutex_unlock(&encl->lock);
         return vmret;
  }



