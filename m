Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F9213AD1C;
	Fri, 23 May 2025 00:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747959514; cv=fail; b=KNVkH5oRm2ccJF32xoxUOJnCh9fQgQASayG/EO+6+7CV5nQ0W9Qnf+A6bajuIixyA71evYGyiyEZuZFS2cSG1sFu9RyShFFRFwxgq3Ub6n+KqG+/v8rz7VE1qAhN6QFysdgheyE/YmttOuntTmpjJxk8ohuS5YRGXYH3dqrw6/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747959514; c=relaxed/simple;
	bh=yqUuTcfOCYNi5aTFWFws+YOeKbI71rgRwwH4SMWXizk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WlJYjtNQgbYqIKu++kLx+y5iJ3GPUOaXhxHXG85bO8fL/EwEb/1EDSi7Yvr4RpcKU5k9B7GWmGVicg2LhHZ8v99kvZK0Ksp88NMw9cCKSSc8RD+K4x108yGkcElen2owiRyqq/gUaORlLylydFcebXU9QX7CB9g/X3KwdtZIKjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ha0nIG2S; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ha0nIG2S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747959513; x=1779495513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yqUuTcfOCYNi5aTFWFws+YOeKbI71rgRwwH4SMWXizk=;
  b=ha0nIG2S5Q4WH6RZzeqp2WCwQD+S19plFn5CIl21w/8qBnESLHt9qT7s
   UjxevF2msDUpaqCPoWqNlCDohx2B1d9dTWA/qwtRW95eEf27eLUA1ALx3
   n5BdS3ZKC2RBnx954u5c1Rl/5x2tYlg/Y7lC+8jSAdbkDqngkOB/J1U8h
   vY8M5yxfLUoe/fPxtjl1TroJ7FfoecCDOavP0/tvVPoyItjGX7oeFOcCr
   APOApAGVQFLb2txdItvmlLebNPLJU3jS6MQPwWP/cdmGbF29FYAH7t4Wi
   ORNk2AD1ALltk/6MM4dpG5p6BPnLV2A6lq/I/R70FJlne7/3MmB+u3Xkx
   A==;
X-CSE-ConnectionGUID: jmrJz6TKR7aEjw7ljCeuoA==
X-CSE-MsgGUID: 3f4vaydST5CFOBgNjVsySw==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50155544"
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="50155544"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 17:18:32 -0700
X-CSE-ConnectionGUID: lT5JSlMnSDWfU4xm2KCQTg==
X-CSE-MsgGUID: MDowUI7RSeWIwa4zt/tpgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="140710646"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 17:18:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 17:18:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 17:18:31 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.88) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 17:18:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HNPhvmJ5D3q1/JgJ83YcDrhF9wuGNM5AiVTSrc457O5BF8UlLgrKorqdk+ZAbx3+DXscQO/vquwznBGml/nGfOwq0gzvjfC/QwCIplB4/opWKmQ+ODUdLZd3WRgRna4t48B4X7bAzES3UgoyTaqHZ6Zmh4btrFRfPRiQVYtts1Wt3V8dzgpyfbOnhR5hoARMD610bNmSWcB5A6r46FB8fx5zjk3QHIvbaqu7/ngapD5H0JYFVNRwmc6+hvSl3Z1u9yxyROP0O2Z6VktSR8DcgvjNdD9y7VIoPBWdxAPXpczoSoBKvpoXmjdRSd+5Nlei12wxQh920nf0ofcgAdW7Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yqUuTcfOCYNi5aTFWFws+YOeKbI71rgRwwH4SMWXizk=;
 b=xplZGiHuLAfd5Axin+MvY8dO7vYrZEXhyO05jNzuCmKzlTc8puccnGsntBR/evr+gDRC/qUS/t+UVc62uUfPhvHQWXboHk/h1jr120k2MfUK5qoKlDmjApcYL/PuRhrFBUK7vxI2UofXMVXHH4h2jCd9X1JdaG4C16lw8cCuD0IJXNkuVQqHu40PQAtq4vEUJwfCFdVJBBqWNKDss2p3C5PpYA9hp6AJz7tBpUTgelFU/i1nZ0UA+p2DeWNBAQIcpCwBJ53kLa+8aThtCb11Zxmk2U8ChB3Ew8kVk4C9fMB8+9/ze3QlIfXDUqj+Vhl6ZLQyjeL85Co6zbLckXhDgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH3PR11MB8210.namprd11.prod.outlook.com (2603:10b6:610:163::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Fri, 23 May
 2025 00:18:28 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8769.021; Fri, 23 May 2025
 00:18:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "mingo@kernel.org" <mingo@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: Re: [PATCH v6 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Topic: [PATCH v6 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Index: AQHbyvsloRxpRoZksU2IViKPkEQ5yLPfWm2A
Date: Fri, 23 May 2025 00:18:28 +0000
Message-ID: <633fcf4e77283018e7e72e333edb942db18140cc.camel@intel.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
	 <20250522092237.7895-3-elena.reshetova@intel.com>
In-Reply-To: <20250522092237.7895-3-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH3PR11MB8210:EE_
x-ms-office365-filtering-correlation-id: e16f07ba-9524-47d8-fa14-08dd998f57bf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Ukc4S0o3Y2NUQ1RRcGZCNDBOSmNxR05QK3Bnd3R4ekw1Q1lDaWtudkR3MUEx?=
 =?utf-8?B?eXpXT3F5QUwvOUUzMmp4YlcxeGVQWWFuYVZwOWFMZWZhWFVyVkxTMllYWlZF?=
 =?utf-8?B?U0xoZkFrRXRkemh1WWNNRmJKdVU5eURNTDAvc1hsa1padlBXOEdCM0dKRGov?=
 =?utf-8?B?eXlOd0tuS2REaXBIdXRlazA4NENaVVpCbzFjQlRlWFZiS21Jb0JZanVpZWVK?=
 =?utf-8?B?TmJXbGFycWg5ZjNQeWdEbjN4Y2JzNWRJbmd1cjJ0UVJ5ODN1NDFlZVdkbDRL?=
 =?utf-8?B?d05NSDRWK0duelEzVFlPM2N3Y3NHWFZKVi82UXp2SUt0MVUxd2JBWGh6Y3M5?=
 =?utf-8?B?SWdJYU5Ea1NHd2c4c3ZFNE9IeEdZRmJCUksrQk1sbU1ObkhqalZpckxXSnhM?=
 =?utf-8?B?bnlDU01KQm1kWmM2cUQwdnVkdE1mLy9sTVplNHB6SkY2N2tWb2JqT0JoQ296?=
 =?utf-8?B?aGxSRjg5Q3RNem0vY2p2SmJNdU82aEVVcUtXRzdmWHUvNENCSzdJUDFtYlRD?=
 =?utf-8?B?c0h0NXM0UTJRelBjNjhUSjNJV29lV2dPUlNjZW5DYmE0b0FoZFJYNW5zMS8w?=
 =?utf-8?B?Zm96azdhUGs0bG8yMkdSWnpXWVUxaE1STUFLT1Y2bkNuQWlYVDhvc3lpellm?=
 =?utf-8?B?ZWkyUnM3bHFacmRFdkpRb0hQSFkvUkIvdGZUa011THlZYVp2TU9xdERWSldk?=
 =?utf-8?B?ekthR3NLdjFCVDhOVGZWM1l5QUdTcUk3VVpVOEZLN25hTCtuRHlITXBEaW9z?=
 =?utf-8?B?Ym8zcnlOVjNDa0NLSUprMWNGMW5Sc1RoZzBvTndnVjMwSGxpVlRnZ29kTHA2?=
 =?utf-8?B?bzVwR0FHcll2TXUxallhTTB1T2FiT1Q0UnRNdVA0L1NOWks0U3FSQi81enFj?=
 =?utf-8?B?cXBsZmdSTm1PYnR1OFQyWVFGSmJFV2xpdlNpRGt3d0RpMytJcWxieFMydERD?=
 =?utf-8?B?dXpjZnNkSDNBTUpldUR1aVpFTVZjTVNwbmFsaGsxNldjL0dmUjhkRSt1VkpM?=
 =?utf-8?B?bHhnR2VPOXdScEpISkQ0ajhRYmJJQzNrdVZGL1YrQmZ3NEdnMWU4WHZTU0Vv?=
 =?utf-8?B?Z3lHREFibG0yVTh5R3VQM0VWcUJ2cXhUd2N5aEs0WjRGWElBTHZBR3Z0aDll?=
 =?utf-8?B?UFowYmlwSENRVTdnckIrUHFVcnZtZTk5RWpoY1hwZEJ5Rm4ySHhXbzROUUln?=
 =?utf-8?B?d0hodjltZDlYemYvbXRLMDlVL3pLY2cxcU1ERHk5RUpLK25YcjBLVUk4Z2d0?=
 =?utf-8?B?YXkxM0xRZkRLREQ4VFBHcXVuRmdyUmpvbTRQT2dIRnMzalp1d0dVSEJJT1Zn?=
 =?utf-8?B?T0xQNmxxL05QTEw2Q1FEUm1EZDVTTVgwcUJaMXg2WHdKSnpOZHNNQml4eGdi?=
 =?utf-8?B?R3ZQL0Q4SGFyZTQzMzJvTGxmMjJJSEpJUGJCaWNpWEhxM2JJN3hic2I3OUwy?=
 =?utf-8?B?a1V5QjIvTERNZVR4djRFL2JuazVld2RWdkdhSlFXM1laMlFhNGZNMll2N0lU?=
 =?utf-8?B?cTZtSEYrWWJ6NTdDeUxNN24rQUhsN3R6UFgvUFZ6MmlqUUhJdlhrc2hvWk03?=
 =?utf-8?B?ZWNoUkp1VEpLZXA5S1hId0hsdmNkVnkxRWYxc0NXREptTDh1SnFnRDl1RFF3?=
 =?utf-8?B?VEhzMXhseEk4NCtnSURldlpKYytrdjh3ZmU1TXN4UHBPOUtYUlVhRk1hOHk5?=
 =?utf-8?B?WmtYSWErVWpabzh5Y2tPTUxBblUxbmVHY2JXMlppVW9tQ3F4Q25qcUNqYjA0?=
 =?utf-8?B?Mkg3TlBwcytCWE1qQUJIbmRiRFZyTG1zNmdiZkZWMjRNTFF6bnlnMDAwa2sv?=
 =?utf-8?B?UEIyK2NIRnl2MXplYm04UFRpQzBmNVN6NXg1SEdIM29kMHdOR2U1eWRyT0Rz?=
 =?utf-8?B?KzYwZk8zOUZnbTk0Z0Rvb3VWZnJLOEt4anc3aUVSVHZsWDVVczR3UUx5TWxo?=
 =?utf-8?B?dXAzQjR4QnEwallpWkVGL2FwZGdTc25xL2VLMTFST2dTUWx4aXlETDl6eTlE?=
 =?utf-8?Q?VUfCcuDo6vxoMUfg75PnXDRm4FRuLI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlJJeXpiMVNjaEZSYm9YZHNIeFhuTHlYblpka2o5UXQ4WkljK0tzREc2U2ty?=
 =?utf-8?B?RmRJbENtZzdaVUtWeW5sU0lmM1ZUUzFoYThYam5JcnF4N1ZZY2M0THkzbTdv?=
 =?utf-8?B?RWE4bHhtMXdwc2ovR1AwYy9GQi9kVHl0NWEzMkxoVUZGZDg2ZS93b2tyamZy?=
 =?utf-8?B?RXFydDZLbVJhNmlJcHV2QmsydlJPY1BHbDFBOVIzdSt0QjB3Z216UUtkYUVv?=
 =?utf-8?B?WW5oK1BmcGlUbC9xTzFQcmRqcnJ2S09mQUZSbTNybmZkYTlvSkFxNWNicTE0?=
 =?utf-8?B?QkI5eFVBRjJPZHdWcTU3UjN3ZkIyVVZvNzhkL1dNUEUzN1djMmwxV3ZjdVZY?=
 =?utf-8?B?bWgwYkNMeDBwK2c3cTNYRTNDUkxCSHJIMEs3TkRGVDBsdVlkR2kyUjFXQVdH?=
 =?utf-8?B?dmhkMmtLbnFIRWRyRUswZVAxRFQvZGpoNldiNk93RVVaNE1BY2gvcmpKT0J5?=
 =?utf-8?B?N2ZvL3BqdjR6YS93OTVkTmpXQ1FXSFlMZzdDaEZMWWcrcnVBOGhNajZDbXU2?=
 =?utf-8?B?Wm11RTJDK2gzYURBcEFud1dnM2JpNnY0bHh6aXpsb3h1MlNHM1ZEQmhWSTRz?=
 =?utf-8?B?azhiWkdIQjh2WHNkV0IwNzlaY2JoOEhBVkcyVVB5K3p0c0RqUkRCak9BMFRQ?=
 =?utf-8?B?cEFYQWN3ZDVnOTJ6NXZxMEc4SDRnQmZUZXI3UGZPclpJdGM0WTJOTGhnQmUv?=
 =?utf-8?B?SytoT2xua3B1ZGtmdGtRRUFod2tSNkJ1TVN1WWFUSTN4T0N2NUxRUHFrZ1VF?=
 =?utf-8?B?Q2tWU050eThNS2Y3RlVpT3ZXaW9yd2xkaFFXMnhwb0FxenRkRVJjamUwaGhW?=
 =?utf-8?B?L2pZV3FRTXNOVFJUaDZMcXBhQzZza3JVZFNCbkF0ZFIvd2FLeFcxRzVjVHFa?=
 =?utf-8?B?UVg5MHlQWkFDYzA4VjlQdEpXYVF5QW9qS244OXhLQjQvV0xvbTQ5bEpONXpC?=
 =?utf-8?B?cWRESnRCUlFmT2FEbzN3RFJOR05mS0F6OTNjZnNKMTA4VGVrMnFXQ3FNV3VS?=
 =?utf-8?B?SkdpbSt4TTY4ZFc0U05wL3NVdGlxcmhrRmp6cUZFellYUDI0SzBCdjVaRkpv?=
 =?utf-8?B?c0xCUllzZXNXaldHMzh5RlVabGtrSThnRWh1RFFDTDNob0xrdUNWWmZjL3Bh?=
 =?utf-8?B?ejNMZ2h4Tk14bDRBejBvRDhtRlg2U3MyanRSKzI5OUlkbU1URmtXaFJWc2VV?=
 =?utf-8?B?WmNpSjhxZ1YyNFJNbmxpYXUwQmI1dTNENUdkRXZoUkUzU2ptb2tlMHJRNm1a?=
 =?utf-8?B?Qk1peXpjYkJFV1dONFBnZ0RGNXFaVGttY0xCLzl3VzFKV1l3c3oyT1kyUmNr?=
 =?utf-8?B?UWhlMEF3cWRhNDdTS0svd2N0SGlIN2VoQVlKWmZqQW12OVZ3NmVwZzhCd2FH?=
 =?utf-8?B?eVlaeU92TTBBRjlvYm02Y0dyKzZaald5S1REZmJnbVZ0TmNkUG1idFdTOUN5?=
 =?utf-8?B?QkY5TlA2d0l0OEJVSVNRd0EwQW9CdlJjaU56VlZWK3JKRHNoTGh3ZHRjMzlV?=
 =?utf-8?B?RHJ5Tk5MeXdJY3FnQXhoMGM2Q2JsNUp3QTRJdm9VRHR6dGhlWWJqbDZZMWhX?=
 =?utf-8?B?cE1ZM1NPK3ZCREMwRVovTWsyMHB5TU9BQnZETUl6K1BOUE1SK0lyRkd6UlRk?=
 =?utf-8?B?WjhubzdCZU1uekg1MnA1eERkbkF2UzJkSHR1bjVPa3FTVUszWHA3U0NzY2lW?=
 =?utf-8?B?UUk1aHdibi8vVFhXRzIzWXVhbzJlOVBzNHdlTVoySGtOS0RBc3FETUtrSW5B?=
 =?utf-8?B?U1V2bCt3R2dSTGtnVnRUQzNPUWFlckFZaFpnOWcrUnMzZXN0cnZPcDhSNkhR?=
 =?utf-8?B?bUdFdVFmSVZOc3QrRXNaRnBleDVWRkhpeW1CUS9SdmU0aDRuNDJadytucWsx?=
 =?utf-8?B?VWs4QVY3YWN2c3lkZEhWaS9IeHZFV1hRT3p5elpXRk1PMzU3bkFmWFNLR1o2?=
 =?utf-8?B?bUk3K0FDeHNuYVpFaFA3SVIzOFVVS243YlByTnhSdnFMTWZ1bU4vQXNxcVdU?=
 =?utf-8?B?TWYvV3AyQXlyd2lzdThKaWRkR3FKemM2V2YyTFVCUDQrbVhjQlRRRmJiZENI?=
 =?utf-8?B?QVY5RkYxbWlRMzRjVVJzM0lRZnI2aUJwN2o1eU9GR293Mm5VRzNKY2RwclZ5?=
 =?utf-8?Q?8XPnsslAQW/UcEgVeE2uw7B6Z?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <74CAE06D98385D48B35A77CFC39960FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16f07ba-9524-47d8-fa14-08dd998f57bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2025 00:18:28.7744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZSEioWvEfuvsxA0l+Otu1P969l9xMPD07FNqSOIBja86C5mHhPPJuRkYsdhkLrOiCqDOS26tgWtInKJZh1Am4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8210
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTIyIGF0IDEyOjIxICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IC0tLSBhL3Rvb2xzL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gKysr
IGIvdG9vbHMvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaA0KPiBAQCAtNDgxLDYg
KzQ4MSw3IEBADQo+IMKgI2RlZmluZSBYODZfRkVBVFVSRV9BTURfSFRSX0NPUkVTCSgyMSozMisg
NikgLyogSGV0ZXJvZ2VuZW91cyBDb3JlIFRvcG9sb2d5ICovDQo+IMKgI2RlZmluZSBYODZfRkVB
VFVSRV9BTURfV09SS0xPQURfQ0xBU1MJKDIxKjMyKyA3KSAvKiBXb3JrbG9hZCBDbGFzc2lmaWNh
dGlvbiAqLw0KPiDCoCNkZWZpbmUgWDg2X0ZFQVRVUkVfUFJFRkVSX1lNTQkJKDIxKjMyKyA4KSAv
KiBBdm9pZCBaTU0gcmVnaXN0ZXJzIGR1ZSB0byBkb3duY2xvY2tpbmcgKi8NCj4gKyNkZWZpbmUg
WDg2X0ZFQVRVUkVfU0dYX0VVUERBVEVTVk4JKDIxKjMyKzExKSAvKiBTdXBwb3J0IGZvciBFTkNM
U1tFVVBEQVRFU1ZOXSBpbnN0cnVjdGlvbiAqLw0KDQpbU29ycnkgZm9yIG5vdCBtZW50aW9uaW5n
IGluIHRoZSBwcmV2aW91cyB2ZXJzaW9uLl0NCg0KTml0Og0KDQpJIGFtIG5vdCBzdXJlIHdlIG5l
ZWQgdG8gY2hhbmdlIHRvb2wgaGVhZGVycy4NCg0KUGVyIGNvbW1pdA0KDQogIGY2ZDk4ODNmOGU2
OCAoInRvb2xzL2luY2x1ZGU6IFN5bmMgeDg2IGhlYWRlcnMgd2l0aCB0aGUga2VybmVsIHNvdXJj
ZXMiKQ0KDQouLiBhbmQgdG9vbHMvaW5jbHVkZS91YXBpL1JFQURNRToNCg0KICAuLi4NCg0KICBX
aGF0IHdlIGFyZSBkb2luZyBub3cgaXMgYSB0aGlyZCBvcHRpb246DQoNCiAgIC0gQSBzb2Z0d2Fy
ZS1lbmZvcmNlZCBjb3B5LW9uLXdyaXRlIG1lY2hhbmlzbSBvZiBrZXJuZWwgaGVhZGVycyB0bw0K
ICAgICB0b29saW5nLCBkcml2ZW4gYnkgbm9uLWZhdGFsIHdhcm5pbmdzIG9uIHRoZSB0b29saW5n
IHNpZGUgYnVpbGQgd2hlbg0KICAgICBrZXJuZWwgaGVhZGVycyBnZXQgbW9kaWZpZWQ6DQoNCiAg
ICAgIFdhcm5pbmc6IEtlcm5lbCBBQkkgaGVhZGVyIGRpZmZlcmVuY2VzOg0KICAgICAgICBkaWZm
IC11IHRvb2xzL2luY2x1ZGUvdWFwaS9kcm0vaTkxNV9kcm0uaCBpbmNsdWRlL3VhcGkvZHJtL2k5
MTVfZHJtLmgNCiAgICAgICAgZGlmZiAtdSB0b29scy9pbmNsdWRlL3VhcGkvbGludXgvZnMuaCBp
bmNsdWRlL3VhcGkvbGludXgvZnMuaA0KICAgICAgICBkaWZmIC11IHRvb2xzL2luY2x1ZGUvdWFw
aS9saW51eC9rdm0uaCBpbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCiAgICAgICAgLi4uDQoNCiAg
ICAgVGhlIHRvb2xpbmcgcG9saWN5IGlzIHRvIGFsd2F5cyBwaWNrIHVwIHRoZSBrZXJuZWwgc2lk
ZSBoZWFkZXJzIGFzLWlzLA0KICAgICBhbmQgaW50ZWdhdGUgdGhlbSBpbnRvIHRoZSB0b29saW5n
IGJ1aWxkLiBUaGUgd2FybmluZ3MgYWJvdmUgc2VydmUgYXMgYQ0KICAgICBub3RpZmljYXRpb24g
dG8gdG9vbGluZyBtYWludGFpbmVycyB0aGF0IHRoZXJlJ3MgY2hhbmdlcyBvbiB0aGUga2VybmVs
DQogICAgIHNpZGUuDQoNCiAgV2UndmUgYmVlbiB1c2luZyB0aGlzIGZvciBtYW55IHllYXJzIG5v
dywgYW5kIGl0IG1pZ2h0IHNlZW0gaGFja3ksIGJ1dA0KICB3b3JrcyBzdXJwcmlzaW5nbHkgd2Vs
bC4NCg0KLi4gSSBpbnRlcnByZXQgdGhlIHVwZGF0aW5nIHRvIHRvb2xzIGhlYWRlcnMgaXMgbm90
IG1hbmRhdG9yeSAodW5sZXNzIGJ1aWxkaW5nDQp0b29scyBmYWlscyB3L28gdGhlIG5ldyBmZWF0
dXJlIGJpdCBkZWZpbml0aW9uIHdoaWNoIEkgYmVsaWV2ZSBpc24ndCB0aGUgY2FzZSBvZg0KU0dY
X1VQREFURVNWTikuICBUaGUgdG9vbHMgbWFpbnRhaW5lcnMgd2lsbCBldmVudHVhbGx5IGRvIHRo
ZSBzeW5jLg0KDQpCdXQgb24gdGhlIG90aGVyIGhhbmQsIG1vZGlmeWluZyB0b29scyBoZWFkZXJz
IGluIHRoaXMgcGF0Y2ggYWxzbyByZWR1Y2VzIHRvb2xzDQptYWludGFpbmVyJ3MgZWZmb3J0IGlu
IHRoZSBmdXR1cmUuDQoNClRoYXQgYmVpbmcgc2FpZCwgSSBhbSB1bmNsZWFyIHdpdGggdGhlIHJ1
bGUgaGVyZS4gIFBlcmhhcHMgRGF2ZS9JbmdvIGNhbiBoZWxwIHRvDQpjbGFyaWZ5Lg0K
