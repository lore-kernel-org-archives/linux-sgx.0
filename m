Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275272C158A;
	Mon,  3 Nov 2025 23:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213636; cv=fail; b=nZP93tXfylrMQ5N1LPVTxUqsjpj8BaSOmlEX2tVPxI8tJk/rtwqenwSvAUIcMM+ExrLA6mavSBfiWjQvX4GxVz3hVRG6PWapqdAwQJLVcy3z4pBGvxJjFw+AGdyUMiD7t+NJaI34TmtghfunnRItzbTHe7Nw0RVLSxj/qCdOWHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213636; c=relaxed/simple;
	bh=1/tuP9zK9hiJagHLBhmd2wrbvUsFQlh0R2EKYo3x1N8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KV7EzTyFA3Zi5LWTQIFZZQPR9lWw6/K9Gve7pjknX+SpGHzSlrCOZYtz65IF9MEwTeWRnn7kETeGJB8K8HIhOOkAfrVJ2B+nIj140ZFlAFrhqb6JKhai1fB0Lyy4XlvhkXS+erhGuFRXVB7Lx2FGxn/S4rydRnbnHPnecXO90sQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=frUdVD/n; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="frUdVD/n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762213635; x=1793749635;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1/tuP9zK9hiJagHLBhmd2wrbvUsFQlh0R2EKYo3x1N8=;
  b=frUdVD/n4D+w/gidO4nG3t5ZxR/JcUpBP2BWDdjWbhQsn9TdOxLjM8Jw
   qF0XhK2jDbe6zitpp7QifQxO87yGHQVd/kqfaGwYGcpKtbR3Hez4D0CGx
   9T6m3U1fts6fXOOOU5lwp1pL7WWOWI5CXR00csGLQe8euGLy8b5vfzJzo
   GVG0/kc/oRxJwoj9cbtHSAXK2eTvORbtkyFpXmyNPSekrgQfeJwpIHvB8
   LRLsxPwAXGuGHiQjpOQ6gjvYXm7ESRvxRXXyop1IE8e7LZePUyNm3Qz7Q
   VNB3Bu5EC21xfCMG4y4Ar4WZEVyY2rBzhaRQ47s+Ww2EvlCAcSJWBbYeP
   A==;
X-CSE-ConnectionGUID: TtqN5wHeS06Kbgge/3klRw==
X-CSE-MsgGUID: lsZ7RgneStaTh9cnmN6hiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="51869522"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="51869522"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 15:47:15 -0800
X-CSE-ConnectionGUID: fmwCZ+HuRtKG47AmKmiqrA==
X-CSE-MsgGUID: JOtnK0OkTtyy7M8a5NGhjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="187721855"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 15:47:14 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 15:47:14 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 3 Nov 2025 15:47:14 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.64) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 15:47:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vh+ppFmVzRVM5Xwub8bjos6mFteerZnN5WChvN0EAXA/2Y+uQhNqpxgiSrlX+sNwqaOcF6kAh3oxouiS5mbm9+NlKwWTl4uIPBffG6sm+5Ym9UB/gAxbXm0mrd+8cKM5hEMLyOWUOwudZXpIfgQEQsx22nPO4ZBqD0GQoZ6gbQb3TWWMYJx3OlPXEFZTGbtGU6oZ5Y+C0f0DxzPVHW2W32Z4eom/suGmDxL3WCJM5h8jjciGgX12Bu/ppR8sMW/iKYjt00oTJt5JB8yRJfkmqXiCv73mYMqupb23GK/yy1gT/bcl3SKki/njmJNzQSS82WbdW7nhMUlFTOGlgUxMVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/tuP9zK9hiJagHLBhmd2wrbvUsFQlh0R2EKYo3x1N8=;
 b=WS7Jl1c8GPjdYjnm3sjEHoFjSM3OjezsDGLdcICLnxm4BK0Ei6V3QSLKHFB5tFXCNHEyU+OZG2j9944QONEBxtbStSvByHX0AvIdh8wDc3+nRBK7eDOODZ0uIKfqg0VTrnSXf4yJkHB4QyjbGo9RtyjZ/oJJ8rsAKNLnyoOaiUUByRJGiRAimCnwOWR97DjbwnwPTjrTJAtm3aSI1cJbuSOaWfPAuZN2GN7eNa2whliFk8scosDGrT1S+4WL5ZSpKe9X9ZTzg9px7qeQjEKfo+F57Ss+P+tuxQuRa8UpsLk/YQhrMwd2DM2ggxYBWXi/Tf+y/YPlezNLSz86fDMsTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ0PR11MB4990.namprd11.prod.outlook.com (2603:10b6:a03:2d8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 23:47:11 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 23:47:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "jarkko@kernel.org" <jarkko@kernel.org>, "x86@kernel.org"
	<x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "thorsten.blum@linux.dev"
	<thorsten.blum@linux.dev>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Fix typos and formatting in function comments
Thread-Topic: [PATCH] x86/sgx: Fix typos and formatting in function comments
Thread-Index: AQHcTKCcJImmZQBK5Eiwig+HlI861LThnxMA
Date: Mon, 3 Nov 2025 23:47:11 +0000
Message-ID: <717cb54f7ac6dd1f94a5c57c10a8cb377eb199bd.camel@intel.com>
References: <20251103090103.1415-2-thorsten.blum@linux.dev>
In-Reply-To: <20251103090103.1415-2-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ0PR11MB4990:EE_
x-ms-office365-filtering-correlation-id: e631058a-c43b-4a31-2b18-08de1b334edb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bFFlMEx4YUhXUkI5dmdVZXd6UTJYMVEwZHVxNDM3V2FVYjZyeXBBbm5vQ0Zi?=
 =?utf-8?B?blN6aEVuNGxBL3k2b3g0N1lIL0NlQXhJQ2J2MGRVMy81WHdCWE95K3ZxV0xm?=
 =?utf-8?B?QlhwTUEyblpMYTdQcmRtYkVaeU1UbEdzZ1YxSGFsYktSQnUzeEFkczNUMkRj?=
 =?utf-8?B?b0Z6VjNQVTEzUmV0K3hHc3NzWVVLamxFaDYvQWw3ZTZDVWI2VzF6V05rOXVW?=
 =?utf-8?B?Sk94eXYwNEJYZ0syTzBZdmVNY1ExeFZUSTlGZnJyRjBuMUx3eEdUWitYVE5P?=
 =?utf-8?B?QTBiaVFXTEVqQ09UT0kzQUhVZDhwSTdOVzJac2NjeWtJZ1VIVm9XNnJHMlZ6?=
 =?utf-8?B?WnQ1QVBoOXpidEMzWWlTVHJ2bnFWZ2pkcjFXUGd0OXc3WnRLRnFWVFdnUXZu?=
 =?utf-8?B?bDFpLzhVeGZRUGVoamZkdGtQVXV6Rk5DQll2NStlVTdMWXBqK3B6dUxCaGQ2?=
 =?utf-8?B?SVk2MHZQMzNZcWtoVy9HdW5panRjV0JlQXd2YjVkS0RXZEFxV0hsVE5iOVdW?=
 =?utf-8?B?MW1NVGFHUlliS3JsRmJuU3FEdCtyWnZhNkROSE4xZnkveGR3cUY4aE9ORFFT?=
 =?utf-8?B?SFB3M3dnNDBIZExRQmVnUWNKNVYwbWY3elFqZW5ENEJLckorOW9zRzNKOFQ5?=
 =?utf-8?B?clE5WTJ4Q0pjMjhhZk1HbkgycnhXcnJSTkp4MUV0SEF6ckhKR05yeVhPM1J0?=
 =?utf-8?B?RDlsNVRHMUtybHZqNnlKOTlKb2wrSDJiMlJWMjdnUUtjVkZXZjh0V281b1Ay?=
 =?utf-8?B?L3dUaS9LS2FjeWpCWnBSdXJ2NjBDb1RucmY1d3JYQndGdWRINUs5T01uYlQ1?=
 =?utf-8?B?WjlVNTJMV3NJTVJscUI5d05sTnZHVU1ubFJFUU9MajhtaFVlRzEyd0wvNkQ3?=
 =?utf-8?B?U0tjQXUxQVIvTXg3QTBIcFAyc2ZiajJWbis4NHFXRGNTOFFrUC9aTGpPR09u?=
 =?utf-8?B?L1ArUmEzVU5sdEV0dmJqUXlzdmljdG1qOFpLTy8ya1crSUxtb0o1VlhZdDRh?=
 =?utf-8?B?NzRJY3ltWEVLWE5DSUw5c1hYcnpFMUg5dTVaTEdHemsxRDNYL25QMzMwdWwy?=
 =?utf-8?B?VGQrZkNCaUdGTUVray9vRTlzTVQ4OHRZT002aXNCTzg4YTI2dElkVTlHcXE1?=
 =?utf-8?B?TVVtMDZZK2pacVNKME5VM0x6ZzRGRHZtbkRSL0E5NWRVVzBidXl5R0E4VVRQ?=
 =?utf-8?B?UUhIeVA2T1oxckZOdWxSM2hpbTZiUWUySkxZNjRRWWRiVWkxYzVPMTdvQ0Rs?=
 =?utf-8?B?dDFiRHFNVjUvUFFSeE92MzIybWh4VzlzeUlYMXc4VTJmaUltTHNzM0JwTG1O?=
 =?utf-8?B?ZUpsUWFiZGtoUWd3d2ZFYTd5d2dGUDJ4UUtHUjNoTWpPanc4OFlnSnNaVlV4?=
 =?utf-8?B?N3diRDhON1RoL3MreXFYZ3RzeHhzdzFrRTlNa0dDUkpvOGpIaHFqaERwWjZ5?=
 =?utf-8?B?eXVjWlhZbUJtbHlaeDN1SkFKVTNTTEdXQVo4TmRBT1F5WGVuT0s0UXBMSXJI?=
 =?utf-8?B?NGpJUW5RVnRid3hPTlE0aDRpWGpCc3NBMnhKVzZMSDdpdjU2NGlSeXpSVEJH?=
 =?utf-8?B?YjYrYUk5cTJ0dHpDdHd5WE1mdEFKejBHeXNzMTZ6ZWQ4ZFlCcVBSaWpCTTlN?=
 =?utf-8?B?cVg3cjhWWHVqd3RjWnkzTnR1NmlGUUtEd3RWV1orS3kydzRrQlEvMzA4SHNQ?=
 =?utf-8?B?MmFkVllrbVBSTURRUkZKQzJDcjhGOTR4TkZKbHV1VStIb2U3Zll4LzlTZFlF?=
 =?utf-8?B?T2xHVVpYa2lvaVphUTkwUmR4S2l2VFdCNlpQZEpreEVqdU1YUk5wY0VzYzg4?=
 =?utf-8?B?alNmdjRyajg2VlNWS3pGYXlBbFFCMTlHRTJOa3hXWmFpZDdMdEpxQyt2dHAv?=
 =?utf-8?B?cUNKRHlHckk3RUY4ZkpZYmx1bnJNWEdFaktPd3h4MEtxa010Um1vRHlmVng3?=
 =?utf-8?B?ZUlrb1NhUlpEY2NhZkZSR0tTamJnb0ZzT1hXZWRIcFduTzBpQlQ4ZFVxMGJp?=
 =?utf-8?B?YzU0MGRlcXJQWjI5bkFyMUFPR2IwOU53V05IOGxHNWR0cVNyUVRxdnZyU0JZ?=
 =?utf-8?Q?jQERgv?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjcxRGx3NFVpNmY4ME5JRnd2bVA0SVozOUwxdXVuaExmN0p1ZkE0dzJJSWNS?=
 =?utf-8?B?MzdlbVU3NXBGbEdXdGhxVFljWGdxYnZCeXh2dDh0c1NUQitNaFJYTUl1VUFw?=
 =?utf-8?B?cUoxR3RXVThtNVBoNnF6SWE1Uk92a3pyV0RkdlNlekloOTM2bGd1WjZkbUZW?=
 =?utf-8?B?b3hDWFg2UzlscHpiZGQ3UE12SW5rVnZXTHVHS0FyU3BseHdBNUVuTUxrUEhr?=
 =?utf-8?B?Tm12ZXNyVzcvSUZacE5CZlRLbVlrazc3Nzk5QW1GeWJ0Z0E3QkQrRTA1Rkww?=
 =?utf-8?B?ci9nZTJsQmpvT3M4eC9aZngybmVmWnhwejdEeW9FMWhMalkzK1FjbnZoekxk?=
 =?utf-8?B?dHBsY0hFaEFTNmYrNnV2UW84Q0NQZzF5NG1MdVlnZ0xOVmdwbnplWE56YWFL?=
 =?utf-8?B?UDVGV3lZeUIvNjBBdGVFZUh3T2x3S29WV0hRNU9hcUQwTVQyc2Z3WmU3a1l4?=
 =?utf-8?B?NzdNR0FNckRlN1QrV29WUThXS0VGL2RHUllrZzgvalRuazFqVUl5bFpOdFU1?=
 =?utf-8?B?a1J2U3dkZXgrcmEwODZmUC8xNHRYbFlTcndoNS9za3ZSSCs4cE9pRklHNDVU?=
 =?utf-8?B?K29zQ09DbkNCQkR3cmJZWll3QWFyYi8rdlhYVnIwemxadDlRN0RqZXlwSDI1?=
 =?utf-8?B?MG9WbjREQXA2SGV0cEVOQW1OQ0VrNkFtay9ZeWtrdmRuVkpHS0JIMjI1R0VB?=
 =?utf-8?B?MDZCQUx1UlFrZkNZR0gvK05MODhGSzhKb3YwekMvQ1RvNUMwcnZ3Q3JUTXhh?=
 =?utf-8?B?dVRjcmI4YjFzVmJCR0g2Sjl2MWhGZ280VXcyV0FHMVJZajgxNjFYbkZhcURC?=
 =?utf-8?B?MWZlaS9mR0grVkcwaUg1L3JnenQrUXJIVFd2dXU0bEl4dXNPTGhKQ0Q1b0Ju?=
 =?utf-8?B?dEhJSHFoeEJwbFM5c29tbVBjNm1jZVNyS1BPcDg5VjFFMmsxWUhhZkRmNHRm?=
 =?utf-8?B?UFE4UnA1bVhobk9md1E2YlVHREpyMm1pc3ltUWg4QlBqbEkrRHVyT1RPK3pV?=
 =?utf-8?B?MDUvdml1NXpXL3ErTDhUY1U3YklkanlwTVkyODZUcGE5dGI5TSt2bFIxZGtH?=
 =?utf-8?B?bGVNM25od1krVUdQNG43Wnk1dEoxR09MQ2VoMHRGdVFSejdJQ2kvVWdQOWVE?=
 =?utf-8?B?YUZjQks2R0k2ZzVZNTlkUDU3VWJrT28xNmVueUtJaXdaZW5HNkRuY2RjQ2kx?=
 =?utf-8?B?WkUvaDROTDhwNjgwaUZBMmM0NkZhbHFHbDhKV2pLUEdqc3dKMFZoRWxRQWdo?=
 =?utf-8?B?VUQ1VnlIU0IvZytGOCtycy9acHc5cDVJZjRPZ0QrYVU5d3VtSGVxbmFncnZZ?=
 =?utf-8?B?cUZ0VHVtZjJBMnEzczBJWU5EM3ZlOWlmUXJNcXNEbThIckZhT2pqWTNMeVZP?=
 =?utf-8?B?aGFmalp0eURtY2VkNXg0a1dGU0VocEF5R1VEcUE2YmpMR0JPK3g1eTBPbFRt?=
 =?utf-8?B?WDdEMmJMcjRlUDJvbGQreTYxT3hWSVQrcEVoTWY2d2RMc3phYkZQK3BwTmN5?=
 =?utf-8?B?bU80cXQ1THJ6VEt2dTBZUFJPTTBiaFBncTIwcGk2TER3VUFMbWp1WlhOdUda?=
 =?utf-8?B?UGFSTklxd3NGRXVaRmV6VCt3QnQwRzJmWFRqS085YVdNcHFDWmxzZHVLNTVJ?=
 =?utf-8?B?cDlMSldERUh5cllBNlk0bHJYNmxvZFJNWmp3SW53bnB5T2s2NHd5aDZTK2RU?=
 =?utf-8?B?dVhZUWVhSTRnV1VhMUFVQnh2d3I5UWw1Uk1HY2JIOG00SzVUK1o4eHlxdlNF?=
 =?utf-8?B?RHllcHdpdFJqclhvZ2FWV1VJRnZ1b09ob1FCRTdYRDY0UEsycHR6M3B4WmR5?=
 =?utf-8?B?VFEra2VrMmkzTGVBQnRvMFBsMHc5c0VPZzZjRTE3dlo1ZVVrejhmekFVR3Ri?=
 =?utf-8?B?cEpjeGNyV3oycTJEdHd5VEd1dUl6Ny9ubitEdnRnVm9nZ0VFc1R2OFNPNko3?=
 =?utf-8?B?QUswb3Ric25FNXJNVk9vSEdldFh0djRVL0xGZlEyNXNFL3RxRFlYTlkwUWJ5?=
 =?utf-8?B?UWZiNUd5S1NnRGJFYmNpMEE5V0ZXZGhvQk9KekdGcnV6SmhFZ2Z2aFh1blJX?=
 =?utf-8?B?ck5hdit3YU93WjFjMEVLLzNWQm5lc1lrT3A0VjZBOFZaa2ROOUg5OVdrZThw?=
 =?utf-8?Q?BkA0NthyEgXcN2u7TXHJvC6up?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4930100B73DB9846A8D78C1DCDFB7BAD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e631058a-c43b-4a31-2b18-08de1b334edb
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2025 23:47:11.3308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AeshiMB8Vn/KX3DP8pH0ST7E/HIag7cTZq55OPAmbkxroIYx43KDHqhGMRNpTDXFagSJ+aJHIwq7GKHEuuH08g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4990
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTExLTAzIGF0IDEwOjAxICswMTAwLCBUaG9yc3RlbiBCbHVtIHdyb3RlOg0K
PiBGaXggdHlwb3MgYW5kIGZvcm1hdHRpbmcgaW4gZnVuY3Rpb24gY29tbWVudHMgdG8gY2xhcmlm
eSB0aGF0DQo+IHNneF9zZXRfYXR0cmlidXRlKCkgcmV0dXJucyAwLCBub3QgLTAsIHRvIGF2b2lk
IGNvbmZ1c2lvbiBhbmQgdG8gYmUNCj4gY29uc2lzdGVudC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IFRob3JzdGVuIEJsdW0gPHRob3JzdGVuLmJsdW1AbGludXguZGV2Pg0KPiAtLS0NCj4gIGFyY2gv
eDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYyB8IDggKysrKy0tLS0NCj4gIDEgZmlsZSBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFp
bi5jDQo+IGluZGV4IDJkZTAxYjM3OWFhMy4uYzMzZTJiNTZhM2ZjIDEwMDY0NA0KPiAtLS0gYS9h
cmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL2Nw
dS9zZ3gvbWFpbi5jDQo+IEBAIC00NjUsMTEgKzQ2NSwxMSBAQCBzdGF0aWMgc3RydWN0IHNneF9l
cGNfcGFnZSAqX19zZ3hfYWxsb2NfZXBjX3BhZ2VfZnJvbV9ub2RlKGludCBuaWQpDQo+ICAvKioN
Cj4gICAqIF9fc2d4X2FsbG9jX2VwY19wYWdlKCkgLSBBbGxvY2F0ZSBhbiBFUEMgcGFnZQ0KPiAg
ICoNCj4gLSAqIEl0ZXJhdGUgdGhyb3VnaCBOVU1BIG5vZGVzIGFuZCByZXNlcnZlIGlhIGZyZWUg
RVBDIHBhZ2UgdG8gdGhlIGNhbGxlci4gU3RhcnQNCj4gKyAqIEl0ZXJhdGUgdGhyb3VnaCBOVU1B
IG5vZGVzIGFuZCByZXNlcnZlIGEgZnJlZSBFUEMgcGFnZSB0byB0aGUgY2FsbGVyLiBTdGFydA0K
PiAgICogZnJvbSB0aGUgTlVNQSBub2RlLCB3aGVyZSB0aGUgY2FsbGVyIGlzIGV4ZWN1dGluZy4N
Cj4gICAqDQo+ICAgKiBSZXR1cm46DQo+IC0gKiAtIGFuIEVQQyBwYWdlOglBIGJvcnJvd2VkIEVQ
QyBwYWdlcyB3ZXJlIGF2YWlsYWJsZS4NCj4gKyAqIC0gYW4gRVBDIHBhZ2U6CUEgYm9ycm93ZWQg
RVBDIHBhZ2UgaWYgYXZhaWxhYmxlLg0KPiAgICogLSBOVUxMOgkJT3V0IG9mIEVQQyBwYWdlcy4N
Cj4gICAqLw0KDQpBY2sgZm9yIGZpeGluZyB0aGUgdHlwb3MuDQoNCj4gIHN0cnVjdCBzZ3hfZXBj
X3BhZ2UgKl9fc2d4X2FsbG9jX2VwY19wYWdlKHZvaWQpDQo+IEBAIC04OTgsOCArODk4LDggQEAg
c3RhdGljIHN0cnVjdCBtaXNjZGV2aWNlIHNneF9kZXZfcHJvdmlzaW9uID0gew0KPiAgICogL2Rl
di9zZ3hfcHJvdmlzaW9uIGlzIHN1cHBvcnRlZC4NCj4gICAqDQo+ICAgKiBSZXR1cm46DQo+IC0g
KiAtMDoJCVNHWF9BVFRSX1BST1ZJU0lPTktFWSBpcyBhcHBlbmRlZCB0byBhbGxvd2VkX2F0dHJp
YnV0ZXMNCj4gLSAqIC1FSU5WQUw6CUludmFsaWQsIG9yIG5vdCBzdXBwb3J0ZWQgZmlsZSBkZXNj
cmlwdG9yDQo+ICsgKiAtIDA6CQlTR1hfQVRUUl9QUk9WSVNJT05LRVkgaXMgYXBwZW5kZWQgdG8g
YWxsb3dlZF9hdHRyaWJ1dGVzDQo+ICsgKiAtIC1FSU5WQUw6CUludmFsaWQsIG9yIG5vdCBzdXBw
b3J0ZWQgZmlsZSBkZXNjcmlwdG9yDQo+ICAgKi8NCj4gIGludCBzZ3hfc2V0X2F0dHJpYnV0ZSh1
bnNpZ25lZCBsb25nICphbGxvd2VkX2F0dHJpYnV0ZXMsDQo+ICAJCSAgICAgIHVuc2lnbmVkIGlu
dCBhdHRyaWJ1dGVfZmQpDQoNCkl0IHNlZW1zIHdlIGRvbid0IGhhdmUgYSBjb25zaXN0ZW50IHdh
eSBvZiBkZXNjcmliaW5nIHJldHVybiB2YWx1ZXMgaW4gdGhlDQprLWRvYyBjb21tZW50cyBpbiBz
Z3gvbWFpbi5jLiAgRS5nLiwNCg0KLyoqDQogKiBzZ3hfdW5tYXJrX3BhZ2VfcmVjbGFpbWFibGUo
KSAtIFJlbW92ZSBhIHBhZ2UgZnJvbSB0aGUgcmVjbGFpbSBsaXN0ICAgICANCg0KIC4uLg0KDQog
KiBSZXR1cm46DQogKiAgIDAgb24gc3VjY2VzcywNCiAqICAgLUVCVVNZIGlmIHRoZSBwYWdlIGlz
IGluIHRoZSBwcm9jZXNzIG9mIGJlaW5nIHJlY2xhaW1lZCAgICAgICAgICAgICAgIA0KICovIA0K
DQoNCi8qKg0KICogc2d4X2FsbG9jX2VwY19wYWdlKCkgLSBBbGxvY2F0ZSBhbiBFUEMgcGFnZSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgDQoNCiAuLi4NCg0KICogUmV0dXJuOg0KICogICBh
biBFUEMgcGFnZSwNCiAqICAgLWVycm5vIG9uIGVycm9yICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICovDQoNClBlcmhhcHMgd2Ugc2hvdWxk
IG1ha2UgdGhlbSBjb25zaXN0ZW50IGluIGZvcm1hdC4NCg0KQnV0IEkgdGhpbmsgdGhpcyBjYW4g
YmUgZG9uZSBzZXBhcmF0ZWx5IGZyb20gZml4aW5nIHRoZSB0eXBvcy4gIE1heWJlIHlvdSANCmNh
biBzcGxpdCBvdXQgdGhlIHR5cG8gZml4aW5nIGFzIGEgc2VwYXJhdGUgcGF0Y2gsIGFuZCBoYXZl
IGFub3RoZXIgcGF0Y2ggdG8NCmZpeGluZyB0aGUgcmV0dXJuIHZhbHVlIGRlc2NyaXB0aW9uPw0K
