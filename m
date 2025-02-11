Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C41B1F03C1;
	Tue, 11 Feb 2025 21:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739308704; cv=fail; b=mYdUPqm2z8faen8/5AKY2am2bkSaBlyRpcqi1t5cunHDz4mNPQfjOohyJOZ3uNkEIJWUM9EDCpohbWKq2L8rg17pc1apUoJ/qQcPfaTEvE0cgnXe/2mwLfmI6ZEI5TPbxbPjX0M9XLuhE155X8PCGaXj/mXx5usAVZkMxvHrw/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739308704; c=relaxed/simple;
	bh=kV4Fe1KhXTgp3QGzeM3fxrLr5PUE3l/TEGClTziBwkU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HwBtO3tnSRbhMYkp/deBjQn+FXUU4fgdK5InfZlGsHQpJa6CIVKJDWXPVgb01ZN+i5HWkxUFhXHLnCBwL30dqFNnY7WxVTZeKip92/HdT6leWHjPOBaa0qIA75OUKr22yGNyxTul6w8l5KW/CH4Z/fIiRZKTkYqJ0MG5wkmBi3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KuKVzKOU; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KuKVzKOU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739308702; x=1770844702;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kV4Fe1KhXTgp3QGzeM3fxrLr5PUE3l/TEGClTziBwkU=;
  b=KuKVzKOUdfdkcdGtv1nRhoSeHC6nsWs0exN+mjkp/cNFD68BIr7Zqnj6
   YfYzKsHSyrm5hIU5CN5fJrsWrkH1qwIJc3FNTHU/zQaGQp2hFst29sTvg
   VgSAng0BMIVPV1VXffIeEo5x89tq4fwjRqNmQWp6QeR9UajQcLA0X+pKP
   r4g+25ayxGbrDu56jp9HJ6YRB43hoAXv+4tjctqtiBF5nXosqLIf5b1td
   ycDyvTWHvjVJsDKH3gNhMIGhRQMSE34vMuKwmBIGPTb9Gywiy3p8xI0GY
   zF6v8MxXbWCJ3Iqnrw5F+tF8UCG/CIQeroaNZ/+iyN1jmBu82L9/uh7ME
   g==;
X-CSE-ConnectionGUID: 2kinr7MgSP6Z3U6s0iFmzw==
X-CSE-MsgGUID: lkKVZCSPQxi6bLW4bYyZqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="51378906"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="51378906"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 13:18:21 -0800
X-CSE-ConnectionGUID: 28bteGzNSdeXv4y3KCNeGQ==
X-CSE-MsgGUID: ES4sgJf9QnK5gAZwq3Im3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117803910"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Feb 2025 13:18:21 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 11 Feb 2025 13:18:20 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 11 Feb 2025 13:18:20 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 11 Feb 2025 13:18:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCbF842FSp5RBFKKZtfMvr89tUUsJC+2uuZjKeLg/6qix5xBMXShnWKYVDxlvgv1L2iIvSCoZZQRoORT4URURlFZzQd7NZIncrt1a3MG/O3e4YC2VrKieORPa3peJgZL2LIewpZAOXQUJlw9cV01PICrzUhuDpX4Z1EC5zgzSwFD+HYhrRFBjjRDzn4VASIERlqf2SNCfpfKLT6tmJVxvg48PIsGK/PnYUpWKetZqQNbjTsSZZIR0IMdNvRqQdxSenLWz3HMk/P/1QBTpIlrqSsRlj16fzMP4geGI2W8rzF37oZkhtk75jBpaIGL9WBLCSVisgMFF455EvDMf1bZkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yl1YOXR5CD6NdlShhL4+QfouK5lX81XXoL3diqKB5ng=;
 b=laOde7ZZHHWtTEZX60lTz39kcvWdaJ//OshqvZhxTMYvxwnrkBOyDuKEiEISNyFx57V6Yjf0oxgTEwAE9RrpwJ2MxEHi4bSNDFu/Db+mFsrzIkGDZcRJ7ZkdscNQr5K96QlucCx4rtYyQ/tUf5cDLmLI8T6qpl3HSrfxK4AfX1n/9UdKofUIIdmbuBCijfRFouPVasAlW3dkq8AjDXuawYN06hW+zlslQNA7tqLGguJ8dkxE9/FVlTldNJKT+9AHfq36Ri6pyUx+CPBrZZUJW8Pcsez2dxDA3tZ/pWrFVmubmJqyAw2FdACy87xTGq0irT8Ai9pPoxwOz+N3pdNo6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4798.namprd11.prod.outlook.com (2603:10b6:a03:2d5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Tue, 11 Feb
 2025 21:18:18 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 21:18:18 +0000
Message-ID: <4a1c8b84-d8ee-414a-bd6d-a8633302dab4@intel.com>
Date: Wed, 12 Feb 2025 10:18:11 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86: sgx: Don't track poisoned pages for reclaiming
To: Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@intel.com>
CC: Andrew Zaborowski <andrew.zaborowski@intel.com>, <x86@kernel.org>,
	<linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tony Luck <tony.luck@intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, <balrogg@gmail.com>
References: <20250211150150.519006-1-andrew.zaborowski@intel.com>
 <3bd497be-54d7-43b8-a392-4bf82bf64679@intel.com>
 <Z6u7PEQKb-L8X4e6@kernel.org>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Z6u7PEQKb-L8X4e6@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:303:dc::27) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4798:EE_
X-MS-Office365-Filtering-Correlation-Id: f86b2d1d-9617-4fbf-077e-08dd4ae19b04
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y3RQMkQ5cDRVWTV1Tmh3aUxucmZCMm54U0dETHNJVFZKdjFaQUkyaVhHUG9Y?=
 =?utf-8?B?Mjhta3FXcU9Sbk02SDNwNUhOUjFyOXhTL09IVFJhdE9DaGd4Nm5Jd1gxdXlZ?=
 =?utf-8?B?R2ZaUlFZVlV5QjdGUWc5NVNsTndsbGhsaUpEWXlYV1RxTzJKcTU2MEd4eHlN?=
 =?utf-8?B?d1BRNldwNnlQN2ZlSUthMFJUeW1ybGJRQnBXK1BjN0JHSlMzbU4relNwRUMv?=
 =?utf-8?B?bTlNV1NBcUE5ay9oUFZ2dEJwTXhQTEFhYWk4d0NpRE0zSTQ2WmQxYmFtYmRT?=
 =?utf-8?B?SlNvb0Z4aDlrMzNMYkk2OUtpQXdNV3R1SUc0THVzK0k3T1k2cUFBYmtJZ3RV?=
 =?utf-8?B?YzlXby94RDhPZGVoQldjdnZvOXdKZ0xhbXdoU3U5V0hnbnR4eVU1Vkp6TSty?=
 =?utf-8?B?VkJUM3pNMTdhUGRzSGk0RHQ5ZEovb1RnN29HSlN6RE43bUp4L2d0UWVnTG9H?=
 =?utf-8?B?TU1iOStHdmV0amQzTGJKNVZuV2lPdmJyUVpCSTdPUkx2REZEY25pZlRuR2Ny?=
 =?utf-8?B?V0xLeW1Wakdlc0VEenVwaEx0clh2WjgyNFhmYlQxQlVpNnlnZU1oZGpGbVZU?=
 =?utf-8?B?SDlFMERoZ3BnNW1nYkhyY0MyRjhSY3RaTzJTTS9ITStOc1RLTkxWbEJ6Uk1k?=
 =?utf-8?B?QzdlVVcwNW11LzRwMFhtc1ZkZTNrZFgyZVZqVFppNkZsNDU4YXdmNzJnZDFq?=
 =?utf-8?B?ZGhnNFFhZHhpeFVoaW4xTXJQQVFqMDJScFl4R1ZEc3BlUjVYdWREUDFjN2Mv?=
 =?utf-8?B?R2sxNTBXUGxOc0pPaFlrMUtnVHplWEQ2UUV4TmJ6QmxDbzgwY1JUZnRxcmZD?=
 =?utf-8?B?T1NoRDhkVitzV2tqdDFtKzgwbitubDB6dDFXTmUrYWNaVnFWSzh6RWFISVhR?=
 =?utf-8?B?RTBpL2FCYkR5T1NYQTUvRkpIdGlDTGpvRGxnTnJaU0k2Sk5rZnVMZG55Y2ph?=
 =?utf-8?B?WlBjUUladi9aSkY0eDRVY3NEWWNIM21rNnIrYjRNRFZrUTJlWDZMZVlseWwr?=
 =?utf-8?B?Tmh3K1psTUI3Yzlxd0NVSG1xczhpdzNYQWF4N3VQclJtMUxtR1VGL0xxbEpH?=
 =?utf-8?B?bytYT1RDSjYrWEVNRjFWUUppY1p6NDQ2bmFNQVZISDZ0UzhTQ2VMWUVlQ05B?=
 =?utf-8?B?TFU1Q1pmbkV2RkZoVlRoYlcycTRTbVk0ckpwMG9IRDFTQzlhMTFWZk9mVFdI?=
 =?utf-8?B?YkhkTERmRWFsUEZaUUMxdTZyYVluMHBhdWNRS0hlM29vZnFabDNNWFJoY2Vk?=
 =?utf-8?B?V05ibWR3alJoNzM5SXFQVk51U2oxbmZDUHBPSnoxaHV5VHFIaGtNSWRGNVFy?=
 =?utf-8?B?RERLTUJYcWo1eXFJazRJWldiMzczSjAzSUNJLzBDbktST0FkUFVSR1EvN1FZ?=
 =?utf-8?B?OGE0bDQ5MmV6UVlnZ1VmZjRSSWlmQVc1WFRnbEJjelJhQUhMZkcydHhNZ0lQ?=
 =?utf-8?B?Tm1DMWswRExqdndHSGQwMHd4MDlEbHhVSUFaaW1zVkZUUUFoR0pldUMrZVFo?=
 =?utf-8?B?aG1QbzF5Vk1PTGdHR250MEhhTnhvd2R4ZXp3dkFTcG81NEt1WUFXZk1MNnJR?=
 =?utf-8?B?N1ZoWVNBK0V1dDF0VWdTK1EwTlJZalBpbGRNZ3FRQjllKzV6Z1M5dnR5MHBB?=
 =?utf-8?B?U29NVWNGQnA0RUt1TU1WUW1kdUFLMnRkb29ISEFwbU9SOWFmd3lxdjA1emRO?=
 =?utf-8?B?enp2OWFldTZ5VXNSK1J0QTJTY0dhcXRzRXREUVFmNWlEM3BieTErNExtVmto?=
 =?utf-8?B?VlUrOVVWeC9idW5kK3NpR09LSVo2SGFXSHhNTGJ4VUNmejFxcEpzZGpiODJZ?=
 =?utf-8?B?dVlDOTJUYXpKcTYxWDBIQU9RMnJxZXk3aUFjUXd2QTdsUFROOWx1dk9NQjBh?=
 =?utf-8?Q?L3QWSwd38W/xr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDc0YWFoejY5SmZUK09KV0pLOWtoZTN6d3hpM1pTOUpuWk92cnlFRDMvbWYw?=
 =?utf-8?B?NGNlbUdZUndFcm5tYTQ4QWI4bGExQndpM1VZZVlBUjh1QW5xRmd6MDZ0UkRK?=
 =?utf-8?B?QUxnVk1uTVVaU1hSc3NTTnEyOVI4Ni92elUxS0RkQ2QrK2NBQU5ha1RKdm04?=
 =?utf-8?B?VnA3cVl5cHNxaFdkMmZaVUdZcXcvd1VzL2dCV3VQQWJLamsvbU55RGE2M0c2?=
 =?utf-8?B?eHBtOHBOcHJkOUNRQTY4L2hnQjNtbktCL1NFRjBCQ1FBQVZZM001VWhKd3Zh?=
 =?utf-8?B?MVEzRzdoZXpsV0Z1dEtOakxJandQMW14TWxabXZWUHo4MjU1TVFBZmcxR1hJ?=
 =?utf-8?B?SlFMM1dWN05Tc0U1bTlGQ09DTHBpVStGSFdHV0p0WmdhYkRrTnZsMW1vUDg4?=
 =?utf-8?B?Wk5rdGptNS9Ic0gxTUc3VkUrdnE0VG1BWVJkVEpMSjhXeloxcHJlQm9HR1dH?=
 =?utf-8?B?a2RTS2tLY2pCMHUxYy8vU2VaWkFzQXhnZWtwN3N0QTZXd1F6azQ1NmxDQ3Rw?=
 =?utf-8?B?TGN3aGY4bFh1b0NBZTdXWTBVNnlubXdSMTFCR1lrUjBUNkwrR1ZPcWtJd1cr?=
 =?utf-8?B?WFJjSUI4NHFzOTYwNk1OdUtwRjZMMllYTlJiMlg5NkJRWlZxSTcxa1ZCd014?=
 =?utf-8?B?elBUL3l4ZXZDR3I5ekludU95ZFZzdEdiL1RXQXlZWU5DckhUNTJjbUhXaFJl?=
 =?utf-8?B?b1JmSEw5OU1CbXRENUZTMkRHOW53YkJyUkM1aE5KTGpsV1hTZFB2ZnhQS3I4?=
 =?utf-8?B?OE9ERmxzR0E1NGtBaHhlMW9ZZW1uM3A1SWEyKy9WR2p2c09lYjlrMG5QRHg1?=
 =?utf-8?B?aDMrcFRqcWR5ck54QmtqdE04SlIrRXF2UllrS2JyNTlWVStJUHVETjU4Ulpq?=
 =?utf-8?B?ZmIwcUdueWpnK0d2TERqdHZ0ZUxubXhDL0dZRHZVaDRKTU9LaUVQNEFCTCtN?=
 =?utf-8?B?d1cvbHEwdWJFZElxUlpIenNOdUZXNXdmVnRXbk1MeUU3S0pLblY3clliempn?=
 =?utf-8?B?QWg2Y0lMaERJWWFSS3BLSzhxNjJ6K2c3WEQxcy8wYmxTK2x3UHNvL2JjVjRE?=
 =?utf-8?B?M3htbDJqalpVS1ZQWjJ2Vmx0NVhBelNLY0doTmtHU0JmZmNNS0hyaGoyMnZr?=
 =?utf-8?B?L2R6bkZ5eDBpMWZMWUVzVGhsUDZrWnJ6VkNrRy9RMmN6cS9NSktnQnVDUXpz?=
 =?utf-8?B?ekxwVjBFdCtycC96MkRpcEFlN3ptMVBJWThpRm9lSlpXYUFhNUlnZnNRQ2JM?=
 =?utf-8?B?K254QzM0K1pxTWlSVGdRbnhzNkZyRWVobGFkY0V0TmRtSkR2TTFHMjE2RW5m?=
 =?utf-8?B?RzR6NkcxOU5PVzdUbG9URlhmZzdoSjVlVHZvOStjOXFPQzBpZzZsM1g4UVI2?=
 =?utf-8?B?cVRHbVV0TXpwVlZhd3M1VEthcW0zSy9UMk1GRjQyNTdoRW9tTFQ4dnA3ZWsx?=
 =?utf-8?B?MTREdDhOL2JlQ09KU045QnUzdnc4T0d1ZnB6dUJjZ2xYYnZBbHhNaEp1dmlY?=
 =?utf-8?B?WEdYQm1zTThyK0ZiT2dkWUM5bWdaUHo2Zng2V25JK2pWeVFwTWEzT2tJSW40?=
 =?utf-8?B?d2RuZWZ6VnRxTVJ0TmRrYkxWOHZTZ1dyQ1hkNWhlZHhkbWhGTVFaU1JUdGZ0?=
 =?utf-8?B?dGJhcS9LZDc2aTR6a0M0MzFNUG0xMUNHNFBTcVNHV2lDNUVmb2ZaWXh2enVt?=
 =?utf-8?B?WHZLUlhkUmlabmZVQmhCQzFoekRUMzhWUjZYeThRdFpQaVUxVVJ0dkNoc2h5?=
 =?utf-8?B?RkxoSGtXdjFwT0ZCTjBtZDdLamkvNVFqckxHLzBmUEhXQlkwSlpPckN1c1Yv?=
 =?utf-8?B?dmhHYXdGR3R1Unhsb05ndW0vMVFRYmtWbXRxNWt3a1Q0YWdsU1J5N3Z5M2Ji?=
 =?utf-8?B?V3c1R3MranFKRVhjd0JQNUt4aVdMTkU0c2U3c0l4M1gycnVXbWZQd2x4Skdw?=
 =?utf-8?B?YjhuNWxFdmVybW4wK3p1NjMzYkppZnlRMC95ZTJJcUJZSmczZFBqUmNURmJM?=
 =?utf-8?B?bWxLVlFkSkxUNFJMYjR1MFdJM2ZtVFErK2x3aDVRQ3V1eHdVMXFVUGZGY0k2?=
 =?utf-8?B?M2JOSXFsam40NXBRL2JjZG15NFh6N1hadFRXRFltditWK0NqV1dyWFJaZmhI?=
 =?utf-8?Q?SiXZbhCYcIcxKr3bQL2dt/8ND?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f86b2d1d-9617-4fbf-077e-08dd4ae19b04
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 21:18:18.7215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFYghwKmCWFqkG7RwP7JTeLJbOxy5EgELLOBePLCC6/lv1s7AhHEJNN5CP7YtxN3DQ5c1W0iqCEyvO6K8viBGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4798
X-OriginatorOrg: intel.com



On 12/02/2025 10:03 am, Jarkko Sakkinen wrote:
> On Tue, Feb 11, 2025 at 08:25:58AM -0800, Dave Hansen wrote:
>>> arch_memory_failure() but stay on sgx_active_page_list.
>>> page->poison is not checked in the reclaimer logic meaning that a page could be
>>> reclaimed and go through ETRACK, EBLOCK and EWB.  This can lead to the
>>> firmware receiving and MCE in one of those operations and going into
>>> "unbreakable shutdown" and triggering a kernel panic on remaining cores.
>>
>> This requires low-level SGX implementation knowledge to fully
>> understand. Both what "ETRACK, EBLOCK and EWB" are in the first place,
>> how they are involved in reclaim and also why EREMOVE doesn't lead to
>> the same fate.
> 
> Does it? [I'll dig up Intel SDM to check this]
> 

I just did. :-)

It seems EREMOVE only reads and updates the EPCM entry for the target 
EPC page but won't actually access that EPC page.
