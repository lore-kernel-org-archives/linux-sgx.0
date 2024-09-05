Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC6165F0E;
	Thu,  5 Sep 2024 22:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725574584; cv=fail; b=Cz9mILVqldcywSwlgAhxX+Me24XvWyGoFmNLSPBA1nesNQ94Zqza2VEcFMQcML5lKjMw0PnVIzA+7j0uR3hmd6XAX8p7nj7uj2cYkmfPJ3qv3K/tV/TiPu48ETsejGA/H4FtEMJZl/XkanB9l66iQSILvL0m2I9s8O5vDOUzOO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725574584; c=relaxed/simple;
	bh=giS75qs4LuSLcUR0mc0EkN0kHQ+Slxaz4hCqsLwN/+8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Yu1rZhOEfH2GEOBTkx+jEsp8ixpInaiuLtjbPaH+bQ2S/L1X1GopyAkCNeo4UftGd6TiEZ+bSj2ZsjtleyXCK3pLYnY9ZtUS1vRqOZtKGxD7ILSdpiJPw7UHoK2fb31f0T+8Z5VZOq3+G0L+RfpYVkqEOpF+56ltIejft9MFk+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M1OboACG; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M1OboACG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725574582; x=1757110582;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=giS75qs4LuSLcUR0mc0EkN0kHQ+Slxaz4hCqsLwN/+8=;
  b=M1OboACGhdGsSuBj/rRuYbSwtyTbs/wWjR58UItrosCykwcjUo27v8Rk
   gE4M6y2dHdhoIz1J3G5WN6Ue7HiTx77T7ZCI9PwZLSgrB2LbmwKjjInyg
   CZ88uf6YBFeyaVyC6phskZISEGRG069wXYhUuSJmk37Q/qMaqIsofPdo7
   aCGKU12Dq/0xSIBO6MJ9vms6N4/q2Cpt9vavgL2YcOjet+pum8L0A22pE
   IhdgmAtOceIUdidP75O/Yqs1fodw8z7h61Hotcbc4D0JJAlI9TOzJurIv
   h4ErqVHl1EECUA5wN8G8XHX4PKjgiPYOBgQgekSphRIcTT+fusRKqdO6F
   Q==;
X-CSE-ConnectionGUID: L7ZyfGlXR6yxHZZ99+U4OA==
X-CSE-MsgGUID: 8ygcS8YxT0ecfZPeupv89w==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="46851349"
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="46851349"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 15:16:22 -0700
X-CSE-ConnectionGUID: c+avBbbhSFK2wBx+4DW5Yw==
X-CSE-MsgGUID: XaI8ti9tQ4WzYkRR8xhocQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="65416966"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 15:16:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 15:16:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 15:16:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 15:16:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sr37lg6zvkc3Z6FUEUJf7z68oM22SyDjbhAA3TF3VLbD5dt+I1NfVn8KIC+JdubYk0wID/4QGDXHL2n0UWKiWzbUnmhfP6P093YRwqt5496NWdPx/GmHbWNykU2Z+twskzEhep2wfhnQVCovNchIlozc1d0VPr5TBtcfRQo5PNnUp8BBShgwWAdcJ4UoJoRc+0M/N2yAGCxq4VxoGabiag9VNvcSE5oR3HW5DllpKjvbpRxSRS/NMymxc/xOPXcVw6Sf1JvFzNkaB9lqh6NdV2PJRe8Qgjybn8ItYkHqKdHdZy36K/7O/L4uH1fZwiBY7GYXdhz5hJpV/u2RyLBOoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTwJQuHUbJehJZbKBNtbqPXJmY8p6an9jUIS6VgC6gU=;
 b=VDcjNZJnjsrr+gRXdLyQ5Z21aabE2tw+IAEQxU7U8Om9LI14ZhO4akzMufLCnHuQqXDYi3rfp2wIZ0ty57FfpCL+nNi2DDbQ9nmvqP8yM4qWCn6ht8jcoOYvv501jePY2u9Q34novDxflwgRnS8wc4LMEJ/ZJios9XPE3qfOBI3UllJKIhFg56I1eZqnpblKhBFLTB3bCl9ULDiUsqG9pOfO/raSLsXb3Bk82pBRzeAxuzrZZHhF6Wnm4MYFcc4tjNJk9KVe63OmLeMWyODvni7AfJn0y0tkZXvP5HxbUv7Yb9K8yh6Qy/OVZjnVd0/r0/BpPN7rGFa7iDf6EdELgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB8004.namprd11.prod.outlook.com (2603:10b6:806:2f8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 22:16:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 22:16:19 +0000
Message-ID: <a64525db-7339-48dd-922f-79348183b5d9@intel.com>
Date: Fri, 6 Sep 2024 10:16:13 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] x86/sgx: Log information when a node lacks an EPC
 section
To: Aaron Lu <aaron.lu@intel.com>, Jarkko Sakkinen <jarkko@kernel.org>, "Dave
 Hansen" <dave.hansen@linux.intel.com>
CC: "Molina Sabido, Gerardo" <gerardo.molina.sabido@intel.com>, Zhimin Luo
	<zhimin.luo@intel.com>, <linux-sgx@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>
References: <20240905080855.1699814-1-aaron.lu@intel.com>
 <20240905080855.1699814-3-aaron.lu@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240905080855.1699814-3-aaron.lu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:332::21) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA3PR11MB8004:EE_
X-MS-Office365-Filtering-Correlation-Id: bd1bf913-b7f6-4bd1-5763-08dccdf85db7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SGtMYXJOUDhXVjlYTW90VzllTkNlZmora1JsSHlSaEdtR2xFa1AzbHVMWjBS?=
 =?utf-8?B?ZHNwbDNIK2xYMGJycFptRU45R2hmTDVMN2ZuZ1FYVlZCVFRmMmZxWTBMZ21o?=
 =?utf-8?B?b0FSOUdmQXRLZkhmM2NjRUhBSGxVZUkyMGtPYkM0SWtUaHhpTE0ySEpGWHRo?=
 =?utf-8?B?VTI3bWJtV2x1TWhLVllTa0orSlgwZzBnVUQ2NVVDZ284K1E4VTh4WXpxeS94?=
 =?utf-8?B?b0J0OEhlUiswdkZIeGluTzRXMkVER2JNaGdzdEQyS3k5c1RYd29aUE1jRDRU?=
 =?utf-8?B?YXIxVTRqeDJDMDdGcjRLOGdmbnpnWklodUpzTjBOWE5TSlEva0FUU0ZHSzcz?=
 =?utf-8?B?N2U0Mzd4SkxPVytMbE9seTkzSllCbHdrVFQrd2lSVVF6akJTV0NVNVZOUGR4?=
 =?utf-8?B?Ni94U3kxYldBMlY3cFBkZDg3cnFJdkdGcnZhWm1KSC9XNTRVZ1pJeVdwdCtW?=
 =?utf-8?B?UjFGcFVMaGFtRDdwaWhONjdsenpMOGYrWHAzeEZTSXFadWVyK3NZMXR4OWxn?=
 =?utf-8?B?WmRRalJ1RTNOVTFNSHVRYzdlM3hDZXJ6ZStmdEx1Nk02TlZ3ZWpiUmdHMVUz?=
 =?utf-8?B?cFRjb2cyUjdNREhQMFJZREl6OEpIM2YrU1k4UkQvanZaUjlLcXhEakpKNU9q?=
 =?utf-8?B?eXFoSkh3eHc1TmpnWStRbXBLaGt5WGhKSEkvNm5kOU5ETWhaYVpQY1JFdXZn?=
 =?utf-8?B?L2E2VmxkZlRkQ2oxblVKbXJCYXNieVZseDRDZnYwWjNHeXFwWXloU0JFWE9J?=
 =?utf-8?B?eUlLQVhtSExJeUlFREZvakpDSW4xWVc4UXNlOUFpOGdwS1N5TmgrS09WOG5D?=
 =?utf-8?B?OG1CSXJFV054Z0pWck5jeGkxVTNSRWlMZExpTk1RWVZLZWtBQXJTaFl5cms0?=
 =?utf-8?B?Q3FnSm1kMWdEVzM0YUdYaEdHVWFjb1cxY2xZeVBNdWZvd2hWL3RkNGw2ZTNE?=
 =?utf-8?B?Y3ZXVFJaNnhhanhVdktJVk14K0JUTm5aMURkbkJ1RmlCZEJVeUpqdDVoMU9i?=
 =?utf-8?B?MEF5NU9xWWtiRmwrejFVV2dQS0FMVXdKbHRTV3RQWUthQ0w4b3RTRFJ2UWFN?=
 =?utf-8?B?MEhQNnpNSmo1aFU3bDVmcnAyY0laTnpsajNYa2pJZ3c0blZCWVhqZHdvM3No?=
 =?utf-8?B?WjB2R2E0OFdyaUo2dzFxc3p6NXhxVXlhbHkybCtmNXB1QkVsdEsrQkk5OVVQ?=
 =?utf-8?B?RzFiL05hdjMvZ01Ld1dqMnNUaTVDVGFicXZFSHBqaW1uZGJZbnBqNFlKdDJJ?=
 =?utf-8?B?L2lPbFRuRStsZVA3NW8zOE9ML3U5aHpRYWVQaUNXclhCTXVoMGM2UWhHRVZ5?=
 =?utf-8?B?SW85ZTVoVS9Sa0d1bWIvK2JNUzh4Z3BpN2JTNmtLSWJTYmJuZEFzMTNaSElh?=
 =?utf-8?B?dThQMUJjUVlTdUZjNTMzUXY4ajBjQTUyUXdDaXZTM016UkdRWC80cDNCdTBN?=
 =?utf-8?B?M1dJMFdBbnh1T25tdlFnSmxsaFkwVlFwNncza2ZOZVQrMnJBU3NRVmxHaTJX?=
 =?utf-8?B?QjlrU3NSYzlwS21SeER3VDZWMEhwd1NTVzU4ODE4c1BYMTJEUlcyRHZaWGxH?=
 =?utf-8?B?Y2pUSm81QWgzMGhUSXRUd2tkZEFBdXZwaUhPc1g5a1ZCRkpsdTBYUmlLSHUw?=
 =?utf-8?B?UkJCc3JNcWxWWnY0bEI0STdaeldRZW1hNjVLMDNDcWpKc3l6K2x4WWdjVElB?=
 =?utf-8?B?WkJHaGlQaXowRGtsSXVyVUVPSTQ3RXV3YWx1eTlWeUYzcHRXU2F5YzUveFdt?=
 =?utf-8?B?MnZOaEdtQXEycWdDLzlZUzJTSTN6bHQyOVVLVlNZTHZHNzR2NWJqamF0czlo?=
 =?utf-8?B?Z3dLMUlyYm5BY3drMnRzQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGNuQVFTSVozM1JTN1REdG13cng0N3pFeFdTcC9WVnNzTHlKNUxiUExIaEZ2?=
 =?utf-8?B?OGJqak1QOGduWUxHV2RUb1BQYWtpeVF4NHpGUUVwSTZSNHRsUzFISXVYYncr?=
 =?utf-8?B?OTgzRlVMck1xMjhNNnNLL010dndnTlpESkNiSU0vOEkwZ3RBdjRNbjZ0RHg1?=
 =?utf-8?B?a0dxVHhlOHBBeEtlQVc0cVYvNXRnTVE3RjBoUjJ5UUVsdkFNZkJKTDVzcmlh?=
 =?utf-8?B?YzR3c1F5MVJ2NkprWFBDdzVWQS9lU3BYbU9CeU5TOFpkQTZEQUV0ajUwYmJU?=
 =?utf-8?B?cmw1cWRiTnNUTjZMV3lueDhtREpjck5DYVNuZ0xCVCs4ZHpSZGVCZDg2RG44?=
 =?utf-8?B?YUVLRFZpdDVSV2hueVZqMnpzVzdKbk9kMFVWV0hUMXRWd21BakxpWmxnU1RX?=
 =?utf-8?B?OFNRT2tHWWV3MjdjVmF1VnNOenpLQUJPcmt4TEpMNWxDZUROcWlmSTAvajJQ?=
 =?utf-8?B?cGJxTUNsT3A3T2tNNnZiY0lJbDlVNFVVVU80bGRqbXpRY3BLRmc2cW9zNW5O?=
 =?utf-8?B?SFFOZlpyemJGa21JQ3VmdDVDZWRzZ3pBUlFGWW1hcEoxR0hkZGU5THBvKzhW?=
 =?utf-8?B?WFVIelRkbTNnZzhDQnZwdUl5bUlOOG1NK0huai9oSWVrdk1QK2d6Zi8xL0RP?=
 =?utf-8?B?RFBGRko3VnNxWFVMWjZ0VThBaEYweVZWRFZUdlorVHU0QlM3UGs4ZUhlNk9w?=
 =?utf-8?B?eXUvblJJZTg3VkExZzVsdTFQWVo0endzMHhMZzV3bk5hMFRvUnBJSitRRC9U?=
 =?utf-8?B?RTBYOEJ5Y21UakVvYlRNZ2tLRmY1dWN5dlJiUko4OFZTWXFpSnVaM2NHeGEx?=
 =?utf-8?B?VVNBQkJkcUhoMTQxWStwajdWc0JEbTB1RFNxcDRvZVd2QkFTMVVnYWZhWmxL?=
 =?utf-8?B?N2hKYlBsR3lxZnd2TENNQkxXN05BUU15dlQ2K1lqN2puYUZIcjhPZjR2dlRu?=
 =?utf-8?B?elByeHhRZWMvcTVzRXBBamFKcDc0Tm9kRkJXV3BmemVSLzFBVTlxNFVnWTZa?=
 =?utf-8?B?cjhZZlBBc01BemFyd25aSDgvVExNWlArMzhXVmhja1MvZnpoamExQ05VQXky?=
 =?utf-8?B?aXZkTXBxbmkrTnhHM0d6N0JxZmlvSnNhdGxhRmtIMmpyMnZzWUx1OUNhWXYv?=
 =?utf-8?B?azZTcU1xUE4vMnM2Z0JNVHlWU3hSazM0c1g1WjFwRFN5WUVxYlA2U2dsTVU3?=
 =?utf-8?B?bnVoYzh3VWJ2cXJhWU1zV0ltaDFRcFJ2bzdBSmlYUm9lZG12Z242eHZsb2Z0?=
 =?utf-8?B?K3BHVDVyWlFDbXZoZW10b1dWenpCNzYwZXEzRzYwczF2MlBYU3lzWDZTalFW?=
 =?utf-8?B?bE9tckI2OFMwTFZwdGt6c3BYak1oRVQydjNtRFZrRlJzR2FJdmEreHRraUNz?=
 =?utf-8?B?citPcytwVlUyT2dMYkJoa2QwRVpoTUlTYVhoK3NXdlZzRDgwazFiWXh3NlZC?=
 =?utf-8?B?QWU4L2pNY0kzTTVQSk1RVFVUQi81aVZHeDFXM1lQeXVaT1R2c3RPbll6KzB3?=
 =?utf-8?B?Q1BCb3BhemN0cWdEN1BTRXdVWGttTlB2QXhNWGhhcWNtMGl3V3Yrazd1RVFG?=
 =?utf-8?B?WDczcndHSVFuMTZkeHhONkJiZkVMVXdBVXNpdjFBUHRHMEdxVm9ucDI2aklQ?=
 =?utf-8?B?NU9GMEZ1OUVydjhXSEx0WWV0NHdaU0xpT1E3THFsYTZ2eUxkakFYSmU1M2N4?=
 =?utf-8?B?OEJab0psVklpQzVrMUtROWJ1VnRPU3djQWRHTE1UT2IxY1gzemFZUW0xZEgv?=
 =?utf-8?B?NHdCV2wxYnRXUlpUS21tOGJWTlZqckdWMzRXcjRTWDFwTXcwcVhlY0lMc0Fv?=
 =?utf-8?B?WE0yS21sM2RzbGNHNERrbm5naHJCaisrdnBMeXc0Q2ZoeG9xYWQ4SkVLM2xX?=
 =?utf-8?B?alVITVk1dDN0WitEQi9kYTNtYWVVWE5meTZRWEVVTHhkUFUyZ1pUQTNkZnBa?=
 =?utf-8?B?WHIvQjVMWWdOQ3Q5REZuQU1jd1EwaE5Dbk4yMUZyTTdtWTBXcmJlWVJySHk0?=
 =?utf-8?B?MlJZeFRpYzRXN2pTVTcrckJ1WXoySlphTXpYeHdiUnJPNXA1dDZodjJVVERR?=
 =?utf-8?B?OUovbEs1bU9Td0dRM21GNURyN0V5MTN3djVsRVg1MjE5SnpuU0poWStnYkh1?=
 =?utf-8?Q?5ZK1e3HERRQYVqtqPjTJmcO0I?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd1bf913-b7f6-4bd1-5763-08dccdf85db7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 22:16:18.9278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFWnH/EGsHH53b9xxsXnceHQzh23wVgqdgB13iJXvQCvlF7lKEu8t4sxedmnL6Ocg27wzU+RJx9cx3CTQKfvRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8004
X-OriginatorOrg: intel.com



On 5/09/2024 8:08 pm, Aaron Lu wrote:
> For optimized performance, firmware typically distributes EPC sections
> evenly across different NUMA nodes. However, there are scenarios where
> a node may have both CPUs and memory but no EPC section configured. For
> example, in an 8-socket system with a Sub-Numa-Cluster=2 setup, there
> are a total of 16 nodes. Given that the maximum number of supported EPC
> sections is 8, it is simply not feasible to assign one EPC section to
> each node. This configuration is not incorrect - SGX will still operate
> correctly; it is just not optimized from a NUMA standpoint.
> 
> For this reason, log a message when a node with both CPUs and memory
> lacks an EPC section. This will provide users with a hint as to why they
> might be experiencing less-than-ideal performance when running SGX
> enclaves.
> 
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Kai Huang <kai.huang@intel.com>
