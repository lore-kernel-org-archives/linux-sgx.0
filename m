Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8C91F9A83;
	Wed, 12 Feb 2025 10:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739356718; cv=fail; b=GX9LRK77FurHVZY2h+PK/rK72D1wkCgBiuUR9791VO0GqDrzoIfZEsjKfKu+1xuctlrZE/AI9tF+M4GzFUs2HHler8Q0ywKZcQl6uFSGV66jln+uwyrMW4GrvLh/XIGrsb9TPX0uZWBBdVCETrAWHo5tkR2CHDdOvDPG7M7LlLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739356718; c=relaxed/simple;
	bh=77pZwJiYJLTINcWgNCsQBSfBDCvxZ39ToQBS0Joi+Gk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gOv7fu6UqcBKq8yHJEHChGZjr+dFmRmJJ6Hbi/PrVRhNpzZeXwDTmTdJ0JDCeZQHNG0GR8Du0DGhTXedVxRqT6bSqc101IP9O98G1u7iUDUy3lI9WWyfxmSB4/9djjkHuxznP8F7KTF55gGolQue8FmZJAwlZQQ5twActUqRDm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AXauujqm; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AXauujqm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739356717; x=1770892717;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=77pZwJiYJLTINcWgNCsQBSfBDCvxZ39ToQBS0Joi+Gk=;
  b=AXauujqmOhN/YLxGQk3TUkwcfnSxJMoNdzrl+DVENSxKfleRje0MooDf
   49J2Z1UhAFWPnLWF6fLqv18sifaMw+2O/qnjUpYUcZAzryUNbi68X1UK0
   gaSfzOFkp3JuAG4220upa6CxCM5QFd8ZWSuhydRVia+7Ox9OyK2RC93Tu
   rnqYXNwZaOPvtdiGUhfcn80MTGNYwe9VyEiHZSzvny0sqqj4IJ4AcBclS
   u9stQZ1dg8iTN7c0XiP0LuSA4iM8NyYXffIdn0ZQYtzqzajjkeXPiUeTJ
   Q21QTaA2s7kxsGOxJ6TF1ML5tXjighoM3a+MTs/MUy9RWL7mNcvZvZs0N
   Q==;
X-CSE-ConnectionGUID: /yA6ZTv2QVyIyenlA5Bc4Q==
X-CSE-MsgGUID: mkCUiX7RSNONQxPTfTOyYA==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="50651864"
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="50651864"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 02:38:37 -0800
X-CSE-ConnectionGUID: su7x7tfHSpeACv3ywNJSYw==
X-CSE-MsgGUID: nbMYjAkUS86bP6amVJd0VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="112615538"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 02:38:36 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 12 Feb 2025 02:38:33 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 12 Feb 2025 02:38:33 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Feb 2025 02:38:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YEI2E3VM1dqN0Da8LHhyBBsmFTtByvzRT7isOrTItQXn2oNY3hDfFVWwE6sm7hnh81sR3qF6dwTg0uYpxPqFs/SXrDrSC0rR6y0k1DwNouC5HKTWlohFwOIpDtvyHdQuUOjMOV9jiTK7fkZeXUJiGVTL9Et7gs/y+3rCBpY7gtwdDjWJAI1qTwau83g2cr/aa1OEN+w1b1TzyqHS7jdevNMECehNN+ToycVda+3zyAJoV6Ia+ig0IjlFoRfK8nBcM5mBxEianu4ZmYJsWIPAU1HpWjAxlt93C7uk/0s9V+gTeh94dxG2ZOKPswIhcJnUgEggstiQSivAWpwJW8S7vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbiZJmFthbGO2Y0/yP//fd4Jk9XayQxa32W1P6khdmM=;
 b=QfRsQ4C/PB9aDK3G7RwT6rRKv0y6VOpbR0PO+L5bMMmlGJ2NAz4IEnkTfeIBftnN5luVnJrAQfZ+UGY54ep0/+BomhDb7rdvaJWhrS1MQeVJenfILFA3JjNXWrx61k91s1XWQK86l9/KYAL2KW3CE3t1b+HiYrAiYsVnnYN1kQM9MV1bkCjGZQGlrsyS7oL2QEv2HUdcZpSHK8iNrpg+CNnJwa1MKJeKZnVDrndDscJdsYi+5WJj9EGQQ+YTijW6ppNu0yowQrQWDMciIvguQgQslx1T8mth0BIAVNdkTwLehjW3u39tkOg+P/g1Hw15GQ53mxVI7+YJJ7kM7ccVQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB7144.namprd11.prod.outlook.com (2603:10b6:510:22c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.16; Wed, 12 Feb
 2025 10:38:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8445.013; Wed, 12 Feb 2025
 10:38:23 +0000
Message-ID: <3de12591-e935-4f3b-9d5a-d13741a7ef62@intel.com>
Date: Wed, 12 Feb 2025 23:38:16 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86: sgx: Don't track poisoned pages for reclaiming
To: Dave Hansen <dave.hansen@intel.com>, Jarkko Sakkinen <jarkko@kernel.org>
CC: Andrew Zaborowski <andrew.zaborowski@intel.com>, <x86@kernel.org>,
	<linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tony Luck <tony.luck@intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, <balrogg@gmail.com>
References: <20250211150150.519006-1-andrew.zaborowski@intel.com>
 <3bd497be-54d7-43b8-a392-4bf82bf64679@intel.com>
 <Z6u7PEQKb-L8X4e6@kernel.org>
 <4a1c8b84-d8ee-414a-bd6d-a8633302dab4@intel.com>
 <7ed9b288-69a2-446c-9f7f-50ef6bc56673@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <7ed9b288-69a2-446c-9f7f-50ef6bc56673@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::11) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH8PR11MB7144:EE_
X-MS-Office365-Filtering-Correlation-Id: 71defa31-84d2-428f-4b53-08dd4b515fd8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cDN1cklHenBTa0I0dE1wWG1xTkpsU0NhSC9HRVNpZG4yWEtmOVBiTmtxUk1P?=
 =?utf-8?B?STdqR1lDdUFCTU42TXgreW5Hc05yaElvWFUvendwaExyd3kycThhcFlWU2dk?=
 =?utf-8?B?TEgvblJ5N1I3WEorYTB5aG1maTR4dTJPdkJ3M0UydVp2SExSbmFTTXByME85?=
 =?utf-8?B?T0hVaSt3N0VkdG03MUlmWDFJUUMxR0NmUzJEWVc1UDBhczJIdEU0bVA0eHA3?=
 =?utf-8?B?aUk5bUtzeGptbTZnYnN4K1dldnVQZ0czK2JWT3NibWZENExkaS90ZFRsTCs1?=
 =?utf-8?B?cHJ3OFl2dnRNQk9uZGszcHVhRFdsVFRlZGRMdWphMDR0T3RxYjg0WmVENnpD?=
 =?utf-8?B?M1YwaGN5b0NJN0RxUW1zdm1UVEVVek5xQTZBNlNlS0Z2TElSQ0szMUk0UmFi?=
 =?utf-8?B?M0w3NURnZWtDU2lualFvNGZqR0VERGd5WlJMU0xFZjV5VmhFK2hFRUJ3QVpH?=
 =?utf-8?B?V3BlVUduMTJhdmlWa1kvY1NId1pES05MM1UvWUNRdUNhR0pWWkozcUpNNk1W?=
 =?utf-8?B?MVNRblJLdWtydTBHZnk3d3pISlR5dU5jaFMvL2pEVjFaUUtPYitJeE5rcnpy?=
 =?utf-8?B?NElmbHQxWVVnN2c5cTZEQVRHeXduUmFWYSs0ZFRURXl6MFFQNk5yMFpCYTdB?=
 =?utf-8?B?dnpXT0FYeXNOQXl3Q0x0V3JqaVh6a0FjalNUdEljRVZsQ2M5OTJXNWpQcGd6?=
 =?utf-8?B?TENmeHpzSWhJbEQ3ZFN6eHpnOGNPWXZOa3EvUG44ZzJrZ0pNUHNwVkVOQXhQ?=
 =?utf-8?B?QWo2ZlhUT1JYWXR3bjdpMXowaUYwaDYreTZTa3hURkYwNzhPU01lcUVJNDlK?=
 =?utf-8?B?blRZbWkvb2I0aUJFTWlnd1lHV01KWEtYRTJHVGhyNDY5WVdLTXJGWGNUQ0gy?=
 =?utf-8?B?S25OalJidVJtdEwxTmMzUkQzWlp5YUYxVGFXQ1dQa002QmtQTCttTE1teG5B?=
 =?utf-8?B?dVVPT0xwMnlSMldUUXFHb0tXaU1LYzdHUzlvTWsyYnVMS3Zob0psVVZ1TXM5?=
 =?utf-8?B?M2JmaTZoUVZ5cXhYdnhnbjY2VTl6RWFqUTdNUGprWi9QcFBUL05SNGxaVjFI?=
 =?utf-8?B?QTVlMkdUZmk1NWtQTXBIR2V3UVpyTDlwUmc4bHR4eERzVUNISHRmTmU3WWZU?=
 =?utf-8?B?SGJxSHpHUnFPNXBQT0s5N01GaVJ1TEJGaFlOUDFiRDg3dkt4ZzRwd3ZGM29x?=
 =?utf-8?B?TjZLMm5zTjI2cmp5eFZHcWJhZ1k5Ym9RV2NkbVZlTTY4YXd4dk53blBxTnRP?=
 =?utf-8?B?d3EzaWY3eVdHcEVzUytWMWQwZjNnMGpMOFJKcnh1a2FlY2JKcksycVJpNmRB?=
 =?utf-8?B?OWRNRzAwTWZVckpwWkRaenNaYXNKSmxJYUFJTlJ6VWVpZ2FEVG5Od3VmZyty?=
 =?utf-8?B?TUo4alh2amlJQlNLcmkyT3VFSmE0WjZxanBUZHlYUVVUTkxhQ1VUTmw3REcv?=
 =?utf-8?B?dmo2Rm1ZUHo1eDBxR2VEZzR1Y1NseEt4WnBLSDM0VnphK2ZGc0s0NmRhUzdq?=
 =?utf-8?B?bzc3UEN3enZnQ1NVTlhGSW1sd2I0YzRLdDRrTVRMSHJrcUpoOTFCd3Zibjln?=
 =?utf-8?B?Vk5IaGRRRWxYQXdIVmJWNzNya0Zob2pRNkt5cVZBWDUyMWR1UTlmVHJBd213?=
 =?utf-8?B?TTdVSnJaWDdFbjNSWnZ2czlieXVHeUowV1hvUkltNlFycklkOXRCd1gwZ3dv?=
 =?utf-8?B?c1l2Q3VLenorQUdvZzZubzQwQnRqcU9TcFN6bnJRUG40MkUrOGYzZDk0dWU0?=
 =?utf-8?B?MHZyZjNhTENTSS9OV29RbUJLZzdlOVhLTzNNaVhUOGFOcUhaZG1wc1VMcnRF?=
 =?utf-8?B?NmZkdEJDRFVQTDFzdFkyaXRQTENzWEVXWWFqSllHbHNpSXRmR1hIUC9nT3NU?=
 =?utf-8?Q?ZFwsM5Ga+yPRg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGRiRFh0TWJtMTdSbHBjY3Nab3FOUVFnYjRKQUV3amxXMm9wbTU2Zm0xekRo?=
 =?utf-8?B?NVJJemgzM3pVK2pGVWEzVlA3ODFNbExqck9aQXNXSUVXSzVQTHF5cVlYT05i?=
 =?utf-8?B?TEIyeXg3U05NQVpiT1ZLVkpncnFlV2JFdXVnNlRTTC9ha3pXeU85RXRjMk9Z?=
 =?utf-8?B?b28rWW4xYW4zS1FjNmVGVXBmdm1BMWgxTDRRUGo3UU1GbE9mTkUrS2RTYUkx?=
 =?utf-8?B?Q3NqV3N5cXRTMlhMU2I5MmpVak1QNkxiRHJLN3gwb0Y3WGJRV09kUVpwN1J4?=
 =?utf-8?B?enNnZE9LZWZ0NjZudE9iWkxyV2dUYSsreDJaYVA5TU9yeXlpVHFVRE5wdktR?=
 =?utf-8?B?WHMwMWlab0pUT2NpWko4Mkc5Rm1TWnFyMzkzTXk1UWdEaVF2NFE0bTU2a2tn?=
 =?utf-8?B?TysySEhPUmcvenRTcWlCRU80MktmbFA4ZzRUeVhZV0R5Qk1vRUtaZE41L3N6?=
 =?utf-8?B?WHdLbW5zSVFNOXRkYWpjQWo2alVmNWxYTjBVamVmVXdZOThneVJpYjhMUlkr?=
 =?utf-8?B?VlFGbXlvRlBsSklWVjdaQ0xka0hNa3N0WER3Rm56aVpvRWNNREtjdDFidStW?=
 =?utf-8?B?am03bUNRcmlTcFByN3ZzVERTejB1dHY5WTFsQURVNWpad2ZndXJvaG0zazB1?=
 =?utf-8?B?alZYeEdRVkVnblN3YVdkR0g4RGFSSXVtVk91R01nb3NRcWdqWG05QnVGSHEv?=
 =?utf-8?B?VXI2L25XMnhzdTV2OVQveDZzN0NsejhtbzFyQWcrZTZRdDBYK0hNUmh4TEZl?=
 =?utf-8?B?eWRkOTd3bE9BRU03dGhGQ1pvT2tLbHhBdlFIMjYvVkFRaFl5Wnhia2RlZTBX?=
 =?utf-8?B?MVhaS0xpeVZONVpEeEJzdEpGL0dsSzJ0RGZVYnlHU21oVUVlY0NLQ3VwSmpa?=
 =?utf-8?B?Nkd5Ymd2eGxGOG1CeURERmF1NVRhQUdkMHJNZWhucGcvRXRDWW82SzJ6QmIx?=
 =?utf-8?B?cWwwNUpQWjBTNHNBUWN0VFVnSWxTMGh2cXg2YW44ZDd0QjBUWEVxaXpvY2tw?=
 =?utf-8?B?Q3JRdFdPM0VSRWd2Nk5BdTJTSDRQZGs4dzBpQllwaUFNWVRxb2Z4TUxzaHNh?=
 =?utf-8?B?MFBEMExiNExhYTkzcVREQW5IdElXaktZYzN0b2lZWk1Nc0pUQU1GRVFuREdz?=
 =?utf-8?B?MkhzTkJVSW9DVHI5T3daeEZWb29Ga2N4dmtWQ0lkNWgycnAwbWZjYjc0bVRG?=
 =?utf-8?B?VXBEdXhrNnpqcFczV3VjOTl2elZ2WWRpTS9LM1FTd0VCT3N5Q0hpRjZ2ekJO?=
 =?utf-8?B?UlZmQk1RbGE3TnVIeHh1WEwydjQ3SzZ4a09HU1hpRUtnOUdsYnBYanArMlZ3?=
 =?utf-8?B?dTVBWGJUc09xUWtJQmgvQVczZS9HVXpzQXV0a1VRaEpkbGEyT2ZTb1B6b09F?=
 =?utf-8?B?LzNySEJzUXpzVXpYSmpIUWdzcXJHTnY1WjZ2R2t2UTc3NHdEU0Y3UmJKTzlu?=
 =?utf-8?B?RUdMVjN6bC9DVkZ5YUV2elZWd2tJZzRySy93WVZYZDdkUnhwcWlBUXRXYXdC?=
 =?utf-8?B?MDRwazNOMHIzOS9iWUVwakVIbVczbXUyN1lyZCsxd3hXdDR0TURMY3RhTGx1?=
 =?utf-8?B?WU9aUFZCSzlUTmwyV05NakRYTDYveDFEcEpReWVET1NXZjBYZFB4dmI5UTE1?=
 =?utf-8?B?ZDNnNldIMDBBekV0dldZOWd3eTdBNGp2ZVpIOS9BMk00TmE1UVFSdS91MFNJ?=
 =?utf-8?B?eDRrWWZWYjBmRG5MV0NwU1VIb3hCYjhSZ2ZRSGN5Sk1hdGVYS0R6MDJ4dmoz?=
 =?utf-8?B?bVJpdTZYTlNTT3VQZXhaU2J3Ulp3b3lpWWtPNTR4Yk5ZZ3p5SmlIYVZPVDJl?=
 =?utf-8?B?bm0vMEN3Mm1hcHpVcnJSaTcwZnNVUTA4ME1CeEFZT3hYOVd3N1NqMEpSUHk5?=
 =?utf-8?B?Mlk1L05zc01scEZha2lIbENiRHYwMG5GeW1HRTlyVjZwRU9oQzQ0bDRqamhq?=
 =?utf-8?B?ZUxpRVVsZEJWSEtxYTJhZHZhSTJsa3FvaHAvWEV5MktpdllMcFU5dnBlWmFY?=
 =?utf-8?B?MFZTMU5mT0pNOEFMTThvMU92TU5wMkV5eFFxSU91azQ2aURkQVNKc0lOQmtt?=
 =?utf-8?B?TzdVUWFEWjA2WThseTdkNm9lVktjeWErYi9YRW5CUGphekJLYnVZK2liZmFV?=
 =?utf-8?Q?oTw7r47IOAosyHfN96EXKWp5c?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71defa31-84d2-428f-4b53-08dd4b515fd8
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 10:38:23.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9G0Ak0Ipm1jtZ4aM+75mMRqqv4yB/2hnI/ywY7RpYzTjucZ6cvtNjKUNqutlUjMyB5vmzd61oTcBaEDHLQbX/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7144
X-OriginatorOrg: intel.com



On 12/02/2025 12:31 pm, Dave Hansen wrote:
> On 2/11/25 13:18, Huang, Kai wrote:
>>>> This requires low-level SGX implementation knowledge to fully
>>>> understand. Both what "ETRACK, EBLOCK and EWB" are in the first place,
>>>> how they are involved in reclaim and also why EREMOVE doesn't lead to
>>>> the same fate.
>>>
>>> Does it? [I'll dig up Intel SDM to check this]
>>>
>> I just did. 🙂
>>
>> It seems EREMOVE only reads and updates the EPCM entry for the target
>> EPC page but won't actually access that EPC page.
> 
> Actually, now that I think about it even more, why would ETRACK or
> EBLOCK access the page itself? They seem superficially like they'd be
> metadata-only too.

Looking at the pseudo code, AFAICT EBLOCK doesn't touch the EPC page 
either, but ETRACK actually reads SECS (ETRACK must take SECS page as 
input):

     (* All processors must have completed the previous tracking cycle*)
     IF ( (DS:RCX).TRACKING ≠ 0) )
	......

Here the DS:RCX is the SECS page.

I think this also is consistent with what Andrew said:

   "I haven't seen a crash in either of these (always in EWB), ..."

because a poisoned EPC page being regular enclave page has much higher 
possibility.  In fact, ETRACK only takes SECS page but I think the 
chance that the kernel code can still reach ETRACK while SECS page is 
poisoned should be just 0.
