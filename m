Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DA31EA84;
	Mon, 28 Oct 2024 22:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730154558; cv=fail; b=lE6/7sBzNT27VH1kxO5iYEad8aQOIsbceABJeUclbFYpnPmxIeCJjQYwtM/Mza2I2Ako1A/k/rMSQHdoeLKLtpIywf5kHJD3J8suBILL/GD8/2hkTvRDZjowNwuPtRg/V0/kOptZOq4bCbRaDxS2HEZQCT8kYUoZkpRVKrOnl9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730154558; c=relaxed/simple;
	bh=ZGUfB5TZSbfirrGqY4xWxQwdwzrEBirifX0F+odSgNI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BwWTLhVS0qE6RcgQngzo3+RXvuhMvn1FffbAfl1rZl8vyFzT4vKAzIk2Znrr87aF5JvmYSJX40DgOQKzmDyFizzBqhFOy4nGY8e18LGhMRvAfx5ypfUewVZM+5dc5qzm5/VOHU+xzBrsCArIN3fj/E+4ee6PZJTlEqM8EvXJkuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iVAC9Isg; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iVAC9Isg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730154557; x=1761690557;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZGUfB5TZSbfirrGqY4xWxQwdwzrEBirifX0F+odSgNI=;
  b=iVAC9Isg3GbKjmQNkxs+3q7onXCeEGPykcDmHF18Qtxuq2TItYmTYHCM
   z9iUXzs2l8UFn7OJgFou1DziVLwmlJ7hiGlqJdyLLd3LA0HG+oGl11dbM
   S1LLtCTbWoeTuHy7t2O2srwtgxBYFMvZnTaLvretxnK5pVEPE3sn5sd2t
   il6lEEJBWESLDpBstZGWhPlxbfwFddZnCHdiChSprXmPMwdmNPcUW6wNb
   +LQZVjLuN9bCV/HqAnPWfz3p3+bakGOSqqsJ8JxehPDN4OXad7V49r8Hm
   stpSlbqyN1B99Xk61gEODw12fDAnrZwSLtMakhD1VrUyl3qYU5W7wF9Xc
   A==;
X-CSE-ConnectionGUID: iAf363ULSXe6C09MtCU3Bw==
X-CSE-MsgGUID: 64fp8cz6S6S1m541DXAx8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47236331"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47236331"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 15:29:16 -0700
X-CSE-ConnectionGUID: gRU8p7+1RoW9cmbs3oZV/A==
X-CSE-MsgGUID: mg/5QLOhSq2JDoIXdskuQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="81912483"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 15:29:16 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 15:29:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 15:29:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 15:29:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tUYV6edSqNLDURJtLbh2yzXYcyAYnQWXk60ZEKz6HdFpjd2dJD8MZBo+vU6VfEM0CD/uB35ZDunoTio4aazI/q4BPkiBF/qvXFm8Kb5vB5TYHK6y8ZtMKmW9W0+WIigTvWhijft8Jr8+UYWvP8hdID3b1Uqnj4v9dUpZ5KQAf7m7xIm5tM20WX6fSCQaqSnsBDkei9CUo/Hkma4+VF48oj/cPbkq2K9XXFyK4HhRoNX4DS66GYXxnh8j+2FiQRvvp84eXMAqx/mgY5Hmd9li9Vy8fasathcBn4E2GsE0IesKxO4ekvkYZydP0wpROOXXwSeEO/QeOHiqkH0UnlDUXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JlqW53xSrJrnCyo65grO4gw4v6bCZLAy23EeqMr71iQ=;
 b=b4LCWqwmJ525TCZ13IzeJHPZ184ao+ISf63RgYRJhWYmUXe0YZC5Rc/H7g7RQnHNuxOBgVuDEGBKp2QuPhNurIVeVWZSKX6KN/uwt8Jw0Ihl4NIBfT1wult/+jJXASYA4wa2Ar7/5cis9OCeh9N4ltJBr5luFJnTLQ9RTy/ZrJZ+v0eVEQS/t1ZG6G0Dwi1DvUx+e5AWWqTv6RbF71PtJEOqVb9xTMkSoTcT0GaVYMY9AdbNFsuL2u5lPk070vEZxbY3TkHTv1IeXwy+mx9pKSWA135E8/WobuYsLzhHCcXExcoC4NLFMzThE8Paw2PCh2h8S3Q9Um6JKc2qNy9OrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by PH7PR11MB6650.namprd11.prod.outlook.com (2603:10b6:510:1a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 22:29:07 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8093.021; Mon, 28 Oct 2024
 22:29:07 +0000
Message-ID: <cd663aa6-28a1-4c03-9258-511285316c0f@intel.com>
Date: Tue, 29 Oct 2024 11:29:01 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] x86/sgx: Use vmalloc_array() instead of vmalloc()
To: Thorsten Blum <thorsten.blum@linux.dev>, Jarkko Sakkinen
	<jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20241026113248.129659-1-thorsten.blum@linux.dev>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20241026113248.129659-1-thorsten.blum@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0048.prod.exchangelabs.com (2603:10b6:a03:94::25)
 To PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5983:EE_|PH7PR11MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 28501b9a-55d9-4aeb-b34a-08dcf79fef69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VC8vUmtuN0gwaVBtNlVlYUxkTHBEc04rcU11Z2tkMFl6WnpUYnRwN214a0la?=
 =?utf-8?B?TExkM1pWSTB4UmZJaGM3bFZYSko2NUl4VEJVQ3RpdVNZajAwbmpNcThJVWR5?=
 =?utf-8?B?QUpvc0tZZGVCWUNXMWUzRytvRW15ZDNPSzU1ckZsN2VZUUZTNVVKVWR6MkR5?=
 =?utf-8?B?RUpsZEpNNHFSUnA0ZksxUE9FODB3UStrMmNUN3dLVFM5a1JtaHNoWlZMUCtZ?=
 =?utf-8?B?VTBMV1ptRHFvM1VoOUlRczF5VElPN0JKQnBVVHludHZaZDk0SEhRVjVmc2gw?=
 =?utf-8?B?NFVObW9IeXZuSm5oYXRnNVVpT3lyM24xSnllLzI1akg3WHRVdXhmUXJDNUxh?=
 =?utf-8?B?akxzUEd2QTlCakpMUWJJdEFBbmswMjJYdG1lQ3JKOTBXcUUzQzhOTkF3L1Yx?=
 =?utf-8?B?eGkyTS82ejNQaTZxc3Z2eEkzRjlYZktUYXg0dnJiUHpvUG5FaFZsNWlxeFc3?=
 =?utf-8?B?c24yYUVpRWFPU2lXNDdqVmdFakxhTTB1cllXenpiM29QZkNNMjFhVlhZUWN4?=
 =?utf-8?B?aWZ0YVY4dTNuVkEyMFIwL09JN2RHS2hHRHN0QXE5NUtubEtYMUJvYkhPZG8w?=
 =?utf-8?B?YXV3N3VFYnpsOU02dDFlZUROckx4YUd6VHRZbExzMFZ3d0wrVzRlRjN0QjJa?=
 =?utf-8?B?MzlFRHQxMEJYY0NwN1hHaU1KZFlacFNMT2tzVzd2L0NQOTJZdHQrTDV2V1l6?=
 =?utf-8?B?dEx6UjRLMFB0eXVMNFg4ZnF5Q2JuTGd2WWJGaWladkFUN2dkL1hrbDZ4NllC?=
 =?utf-8?B?NUtEbTNmS3FrMmhGMHdmN2ZWQVdGNzF0eGFrckw0aXJXb1ZodnBmZlVjVHhk?=
 =?utf-8?B?eDI0SXV5WGVNUGFDbXNYVzN1TzUrRDV3ZFA2cnhZcW1wczdCYkh5VmdLM1Aw?=
 =?utf-8?B?WTFVcVNTWEowRW4yaE05a3JZN3BHblZwTWtqZ01zek03UVVyU01JT0Q5M2xy?=
 =?utf-8?B?aWlGWnFpUFFKd2pTSWhkdlVEdmFVNEV4ZzR5YkZtbm1pN1l2OFJ2SzgxTXFG?=
 =?utf-8?B?NHJZRkw1bmpsZDh0cTB5dDRvMFVUWWlYZ0htRVJ1MjJYSGY5TmtsRVVPbDJv?=
 =?utf-8?B?REI4S1ZqeTY5SVk5amduaDVVOXY0ZXpRQ3VFQ0ZDdTRPL3lzVWpNYW5WMXNa?=
 =?utf-8?B?TThtSUE2eFNkRjRWVHIySnd2MUJ2UkRESEJaeXN3bGs4MitTeEptejRUS3BO?=
 =?utf-8?B?bHAvUG5wVnNUN05aUnJGaEJ0RXZjcVpobGdYa3AwYzVXRHdEbVZuZzBPMUZ0?=
 =?utf-8?B?OHMrc29mVjRIYnV1QXhReE1teVl3bDU0NDlSQ1dMeG41cUZQYlZnR0JCczht?=
 =?utf-8?B?SnBodzRHMGxXVDRsbGpub3Bvbkg0V3MxaFNQNmR3K3E3OThReGN2MVVMQmJD?=
 =?utf-8?B?Y29lY1lGQ2dzQXJjRVNub1I3QlhrbUk4cE1reldhTTI3NmhOK2Z4SUFvVU5Y?=
 =?utf-8?B?d0taOXhQQjJYVmJpalRHRXZxMlhTbzE3TzF4ZGlBMVgzV1o0N04vNTJEejBx?=
 =?utf-8?B?WFJ2VWswUnlYWUFGZlZYS0FDemFzaXR3WGZGcGJpbUp1VzZmVjRCTzFjVFhU?=
 =?utf-8?B?SDkzYktnVlloazRhZ0VQUXBVcm50K3lJcFVURkhEZjNBeStCZm00TzlxekY5?=
 =?utf-8?B?YmI2RWM1QlIzQWZZRzFtaXBZckxKYjIxNkUrN2NEMVZNbDYvYXc0ZjlXQ0pz?=
 =?utf-8?B?WW9ncFhyQllZbEdORTJEYjNPK2tLU2FsYnNvaXJnY1JBYXE0VlgvTjNFZ1Qx?=
 =?utf-8?Q?0Dim3O2kEVNUnpaaBcDoLMLRHtiCpjhEc7cFZuj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzQrMlFwTkthOWxBY1RvWnZNVFFTa0VLNTBBcHowWjJFUENKbXRMbE0xalBk?=
 =?utf-8?B?b1orUFdQYUVVYjVjWmJGdEhPNHhMekFnZzhEWENUeWdNSVZWdlBRSmU3MUxX?=
 =?utf-8?B?RW1zMFFBa01VbHlQazdiM2daQmNyekRYYlNyMHF6bnd4VXZ3ZkF3a0VGVTVm?=
 =?utf-8?B?WnZUY2VkL0pwSllHY09DZzBiODgvbEhWY1FwU0hsanNjWXYxVUhiS25rMm1I?=
 =?utf-8?B?ajJIWnhzN3NLUnlQZzV3d0NaS2dEY3VDOHF2ZG1XdXFSUWdkRnJpR1JBOGFM?=
 =?utf-8?B?THVRbkJwQ1Rzc1JhYkE0aXVTTE1Cclo5RU9FNExab1lwSk04T1V5WmxjUW9F?=
 =?utf-8?B?a1lTVkZsQ3ZpY1hCVGZ3K3g5VDM5WDU4c3J6K3d4UGo5TkUzTXlwSWhHU0xn?=
 =?utf-8?B?ZFd6U1VyR1JyNzRPRXI3OHZnY3JxaEtmQ1JtVFYvQ3R2MTA4LzRpam5rS3Np?=
 =?utf-8?B?b1EwZWlvSG1UTzVpbG1jOXo2R0hrTTh0SGQ0YUp5TWoxUW9MR3hhaHRJNHN5?=
 =?utf-8?B?aVg3LytZbVJYdWUwbkNYeHhmL1ZmeXh0d0NGWGtmdzYwOGxZRGZ4eXNSeVVB?=
 =?utf-8?B?UEVQRjV2QUpmTjcrYXNvd1BnNmt2aHRrWDNJbUFkbll4MUhuemRkcHB2Y1ZV?=
 =?utf-8?B?WWFXTHZEbGY1dzZ0YWoyZTYvTTFaSWRGZXM2eXpYZG82QXY2dlFUNkdrNkRN?=
 =?utf-8?B?TGxWelYrTXZzR0s3M0RBVXZXaWkzL3NNZjFZZ1ZLN2Q4c3VZRmMrT0tRRXZT?=
 =?utf-8?B?VGp1NnliZUc0RWFnYjdxSXN1RUs5NUs5LzkxdlQra2NxaXFHV3AxbFdoYlZp?=
 =?utf-8?B?MElUYW82ZDkySGIwc0NTVVJ0b0tmRHpXTUJWZ2V2NzFGNStpUzRFREdHakF1?=
 =?utf-8?B?eUg4KzYyOSttblhwUitlMExXQVNHMXArQ0xJWUVva3p5OUhOa2hnaWF4RFEy?=
 =?utf-8?B?KzV0cHB1VE11ZytDNExUYmtURjZPREdxRFBvekxvS1FUbkR2Wk1yNGE3SUdz?=
 =?utf-8?B?ZUpMVitHZnZrOHloSWo2ZVhFMlYreGFOUVA2TU5TYkpteFhpajMvR2J2WXdZ?=
 =?utf-8?B?TS9IWTVHdE5YcFV1MFo4VGVzeDRFdkNVeHU4OXVtdjQ5Vm5Ea3VrUTNrYWI2?=
 =?utf-8?B?WTFlcjVxVTIwRHlPcnBaVmZqclcvUktTWFRwYVlVQ05tNGxyWHpuaDdyQnA5?=
 =?utf-8?B?SEZvWWtiZDFhNjB3MXYvM0R2Q3BaNzFXd3RhOWwxVmRoVWNMbzZNMVZMYlJF?=
 =?utf-8?B?cG1Xc2pmdlN3S2RsRkprVzlDRmxKS1FPb2xMcTJZZm9ZelFiNmFkK1pSZStH?=
 =?utf-8?B?VEs3VWVSMWRXZ3lzbEplOTlQUEt4K3o4OXgxOXhzdEdxQ05lNGJ4REowMjBr?=
 =?utf-8?B?L2hwemdxN3lSL1pOWm9CSFhmbnJYbU1NQUszVGROTDUwa0xqSm83WStlMmZn?=
 =?utf-8?B?MUFiSG96OUNwTlVDcHJkU2ZJU1dMZjljTlN5ZlhIalZRNUZCMy9xNjlBcita?=
 =?utf-8?B?cU5UbVNIdXZoWHlOS1FiWkZzdDIzRVdRQmYxMVFiYWIvaDA0c2c1eXlPNWN4?=
 =?utf-8?B?OWdWTmZEai9EWGtBcFh0d1o3akwySDNncmduODI4d3hXRW1FZFlDOGtCeWI5?=
 =?utf-8?B?WVRBZ1prYURPTTNqd2xFRkljNjRjQjdFY3R2bjFZU0NiMFcvY1NuLzRDOTMx?=
 =?utf-8?B?UTBIVDF4b3dXcGJvWmdscTI3Z3JhL3gyYk9iV3ROUkg5NDlsck54bEhkMUVj?=
 =?utf-8?B?SFh5V2ZGQXJlVkhVY3cvR2hzLzdwdTJtVHc1R0x5aE9yNVBHMjZvMDJNc0lL?=
 =?utf-8?B?RVN1dS8vcnhQcVdvanRaekc1YWdDb3RmN0NueTFhOFlETG9xazdJTHYybVpw?=
 =?utf-8?B?dXcyMVRhek5HTG44MzgrQlI3S21xdGNod3g4TkNid3NVYWZNWEVocnRmTFpU?=
 =?utf-8?B?VlJKYmZSRFlaOVo5Z3JpQ21yNGkrVkQzcU5MR01XcSsxUlVDbmsxSDFIVXYy?=
 =?utf-8?B?dURMeHI1Um9GNmZERVROeGdoaFRNOTJkQURQU2JiOXZOQ0laNFFVOEdWYVlt?=
 =?utf-8?B?dEVmUTBLTWNzUmlqKzhQRmp4SDdENGlPdmpScnBiNEVDNGhNckRuQ2FRL1BX?=
 =?utf-8?Q?nydW7CuXm1WHGXb9AXXIdn50B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28501b9a-55d9-4aeb-b34a-08dcf79fef69
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 22:29:06.9802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hr4BuoQEqt/kjhambnCtKy1voWSuoVdOTkcDzpjfGPQ2+GE6gSz8P7wJVnoclxn0EkuvZnHH32blww33IAGpyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6650
X-OriginatorOrg: intel.com



On 27/10/2024 12:32 am, Thorsten Blum wrote:
> Use vmalloc_array() instead of vmalloc() to calculate the number of
> bytes to allocate.

This says nothing about _why_.  Is it because we want to take advantage 
of the multiplication overflow check inside the vmalloc_array()?

I don't know whether it is implied we should always use vmalloc_array() 
for array allocation like this, i.e., when we see vmalloc() is used for 
array allocation in the kernel we can just write a patch to replace it 
with vmalloc_array() and send to upstream.

I am fine with the code change, though.  So if you can add one more 
sentence to explain why (it's always good to do so), feel free to add:

Acked-by: Kai Huang <kai.huang@intel.com>

> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>   arch/x86/kernel/cpu/sgx/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 9ace84486499..1a59e5956f4b 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -630,7 +630,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>   	if (!section->virt_addr)
>   		return false;
>   
> -	section->pages = vmalloc(nr_pages * sizeof(struct sgx_epc_page));
> +	section->pages = vmalloc_array(nr_pages, sizeof(struct sgx_epc_page));
>   	if (!section->pages) {
>   		memunmap(section->virt_addr);
>   		return false;

