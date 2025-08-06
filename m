Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6549E1FAC4E;
	Wed,  6 Aug 2025 23:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754524188; cv=fail; b=lQgo9VTFou7ROHUKIiBTO4vNqaKIIWLfusVMXAguY1Q0cI+ePQBvDTyhZfWmdX2RKp/33bpjrdDdQkwe3SpV0QqIvuu9KAmZqaIRrrKgfQ7s+MB0zqStFIXe3iEP0iNyCWE0BYZbMsSOX8Se/AIjFuxKqi15P9Swm11KB5yXtWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754524188; c=relaxed/simple;
	bh=SRG488x6QuEXmp7L1vwOIN1agJtjdrRMukTOe41UTe8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cJm1pnXTBNP82OoJxSq+3zYdiTu7FLj4FywKsyLGppUN5iXuZLwlAJlW+M4NbNDOsBmG2wJBiMfTSJPP99zqWGQyB2JBMCIa1WCCtNcY4gn0VJyG5zxObwuzu2BmiEZGJsQ8+2LOQTk7ZJ+baOBKm8Brx3+dxYY66NMqwZkH0Go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jElcfugC; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jElcfugC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754524187; x=1786060187;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SRG488x6QuEXmp7L1vwOIN1agJtjdrRMukTOe41UTe8=;
  b=jElcfugCzi/y6hSPsAEfiW3LcG1OxG+2QAy3caB2esxgOz+NzycZL6sb
   cjMe59Zw43MD/ffHbsWkFukzErmW5RjPnNrWSX9u/ygF2NwGLqtysjU3f
   Z6BcmYh300EDsBKJP7vBA7WidWiQJFJUSsZ4LZulCNVxzDAci8StVdS7h
   9jRx6WqKhfzraq9ctKfOUfpbD0vJC3esEVH1eIfyKnc8zpEis6eWoW9AF
   CvAblOG+MYdZ4PVg0IsvTNQ+YG2qL36XQCCUVjfdUDU1ILOx6oGSdpEQj
   020mjcFfDznO6IPrYBsQB/dZHNf1p4NOdgOs6za34MYJdKyHFfna8vKaB
   g==;
X-CSE-ConnectionGUID: HcgQ0C1LToa8GLIq8g40MA==
X-CSE-MsgGUID: 9cDMKplRSGinSyCarX85bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67119372"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="67119372"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 16:49:46 -0700
X-CSE-ConnectionGUID: pHtBqdy9R62wa9f3wULWgA==
X-CSE-MsgGUID: duqRD9/xTnabdGeCYmlNVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="164915183"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 16:49:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 16:49:45 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 6 Aug 2025 16:49:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.63)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 6 Aug 2025 16:49:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=deCpOpzrIjrSzyujBvTEGm4bFYr50pnqVBBgZuifr2q3MYWtypzctjHEl/7yvPT8vJnUQFXK1Kyp2DavPnUMtQFg4CQCKNPB3/cXNoEEeNQVBuoKS2ecApSsXFv6XSmKr3XOzhTrGnDoOD67liXEpft/X8NIuscRxP089xniWc3XLpcdW7bxeXhS3vBQ6KwVv/yCSQmyNpPInly/R73LDSTVPqk2E3ZZTHC7L/3l0FwuXqtJUJ0l0FOk2NJluiqBNctlN39hovAswNF1HC1hGhIJRaHQbF4JB4DRBk+gcYPLf5kHWmK2JLJ3sazQkpxTLHojaCLZk13LSZvI5kymIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SRG488x6QuEXmp7L1vwOIN1agJtjdrRMukTOe41UTe8=;
 b=AyrWjEC1HRem6RWOZMQx0iGQFP0abHEQV3GlqHOezraBUA1ZpfiMwPGDml1umJG9dzswo8xZQSd/SHYOOfgXDRYlyAwvTe398bCxbJjKy2Sr68a+D67RF5tfo+px7WIhYsfQ+vLD2wufiCA9eYSDu3bBUyyBvsc1+NoUSk51S6ANwOJTHvkMHntltF8z5fJlChoAW7oajVD37C5599FnNTQ+EzHPQW3c0vrauu+7SUL9U0UYKsf2abanAnacbh4mbhhIDFiPC4F7oz2F0zEGjSSCIBNviM7L0rph4WOjhihl5EpNPtaY6oSptY0JWbI9hkrLMP6S1h9D+ZvrtM1mDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB5874.namprd11.prod.outlook.com (2603:10b6:806:229::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Wed, 6 Aug
 2025 23:49:41 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8989.017; Wed, 6 Aug 2025
 23:49:41 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v11 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v11 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Index: AQHcBqojKTrcWLF/aECHrKLiELSu2bRWTDgA
Date: Wed, 6 Aug 2025 23:49:41 +0000
Message-ID: <0f3ce0d9c5a43a70cb119d47c71dbba36264f29d.camel@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-4-elena.reshetova@intel.com>
In-Reply-To: <20250806081344.404004-4-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB5874:EE_
x-ms-office365-filtering-correlation-id: c80cbb7e-a876-4d25-f3b4-08ddd543e97b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UzE1WDdlNXZZb08zT0ZLN2ZEMzlzZy8vamlqdnVNK3F1OXd6T0VBaHZCajRv?=
 =?utf-8?B?TEdoQmY4eWtybyttdzEyT0kwMXJqMXdKcXF5K2x0bzQ1RnQyT1lET3hrb2ht?=
 =?utf-8?B?VzdlN0NBc3JmK2krcWZkSk9YZFNIcE1uS0xWb1VaSmY2cjZwR1FUOE9NZERh?=
 =?utf-8?B?QXNKMlVBbDRJS2hEYnppSnVON0E2WHcyYjZEWkNVOFdIdi8vRm9IQUUvMHJ4?=
 =?utf-8?B?QVlBalZGNEthak1zeVB5NmxlZkoyWmM2UDA0bWs4MkE0cmRMRkpCUlVRR1dh?=
 =?utf-8?B?NzlhSEZXUmEvYXRqSHA4cm1kNXYvckp3OTE0Wm1EOUZqeStGZWpTSlRBOFVx?=
 =?utf-8?B?KzhpdEdLSlhBWE5HZUE1K0xRTCtSQzFLUGIyaGRQSUVTam5NTkFEb3Z3M3p5?=
 =?utf-8?B?aXdweG9IQThZTTdvUVVNaXo1bnhjYTBPaGduRkhLTHJ2REt1cHJQNzRUcHli?=
 =?utf-8?B?aHRYOGxmYjAzeStScXQrbGN2TWIvVERmcDlZU09TbVdJWnFkMmRJZGF1b3da?=
 =?utf-8?B?R2xWcjFWM3ppVFNNWDJrNkF6NDFmb3BrSDlVNXFwZURBd2VrT2g5MXNReHFQ?=
 =?utf-8?B?UnkrNzVRSHdPTGtuaFUzT01nQ0tkMFpXakZGRmlLdnAxM1hJTE5VS0p1MVFz?=
 =?utf-8?B?b2hzRlpaNDVIWnVjakhBMnVhTG9oY29DQURSZlI3R21SK0M5Q1kzZFRtTnNz?=
 =?utf-8?B?NUJzejJKdnpjeXdTNVorWldHSXVhMkU3VUhhVHNGT0JOY3l2dWFTc1NNYzhO?=
 =?utf-8?B?Wmh1dGUzV1oybFpxMCt6eVo1MjUxN2swSVRTQytWMko4U0R1L1VFVzF6S0hw?=
 =?utf-8?B?UzQyRVhkbXZMbzZpZjZybkdhRWlhRTRuRHFKK3FiZEV4OWhzWU1RSEhBVXZw?=
 =?utf-8?B?VHVvMm5wd1duS0dkUlBhYUE3QVBhdFMwdzBYQmkvc1dpZzNiWndNRFpZdFpR?=
 =?utf-8?B?aFY1b3FtSGxUNW1xOTA0NDlyd05FMytMakVQWmoveHo4QmszckMrZHpVTjE4?=
 =?utf-8?B?bUdSWEdYV3d6WnFXejNsb0FtdDVEbC9VTkp1T3B2eklCcEJGNm1XckRabzNp?=
 =?utf-8?B?Vm9aY3U0Q2NUY1cyc1ZLdC9ZTFJBQVNUVDdta0VHbDdrdWg3SWQwSWhDcEhS?=
 =?utf-8?B?MXJaNktjQjdWYmY3M0ttUjE0aWxjNWxJMFJqWW5IejFncUxNc1BMSm9TNUpn?=
 =?utf-8?B?UFkyZWtkbGF0OWFtSXEybEhYQW1aUW44RXd6MTdqWWl5Y0JEb1p6Q3NtRDNK?=
 =?utf-8?B?YS83SUdCM1JkS0VPVkwrUzlwblR6dWVCWE5sWU1BR1RRQVIvQ1VBYldBM1Zp?=
 =?utf-8?B?UjFxcDlFRklmNGNydGxtL25KOWdDU2Y3QmY4bWNuM0VoSHNvZk9oNERpN2p4?=
 =?utf-8?B?d1lubWp1MjlGaUNXY1piVTBDOWpnYTNHdEttR2plSkFzVGU2UERrL0ZGNlVt?=
 =?utf-8?B?cFpvcG01a29XWHZVMUtIM1UxYTJpTGN0ODlteC9iOHN3d1AzWWR4OENoSDFh?=
 =?utf-8?B?aG1CRHRMbUhmcHYwTGM1NlVyam5xb1djcjlRTGxBSUJ1RkxIQ3RHM09UUTFI?=
 =?utf-8?B?T21XRTMwSlBLd1NtKzVXc21JQ0J5TTZyYmFWb0NRajRaOFJsZ1BMWnUrU0Jq?=
 =?utf-8?B?WERlTllwdkVXUVE0emdLZ1lsQTArOHg4Y0lOemx3VkNvbVR3OFAwTHFxVEls?=
 =?utf-8?B?TzRxVXJIY1JWaW1nb2p2azBxRE8vZnExWU4xMmlxbzdHMEdqemhHL0RuTGZx?=
 =?utf-8?B?dU9KK0Y0WmhZQVRTZE1xZzZ2aUxYVXk3RkcyVU5jUVhwMHA1eXIyYmlSeVAw?=
 =?utf-8?B?V2ZIUkFYV2sreERwMytKQmpIMkpjR2pUVnJGaXhZQ3NyS2Q3MUFJSmV1Rlpx?=
 =?utf-8?B?TWhsSEdLUEYwSGwzTWFPa2J6MUxIQkYvd3FhQUsvSjNzMERURFJoZFlaTG9E?=
 =?utf-8?B?eTlGaXQ0TmFSWXBobHFIOEZUWGZBN2dNRWVBMlFia1FnVXl3Yk4vN1pObU5o?=
 =?utf-8?B?Y0lLOUwxWWlnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0tQOHB1R1lEeStxR0RVZUh1blVyazd1Vk1UV0kydUlDNDE0RDRLamJzRm9C?=
 =?utf-8?B?VlBHOHJzeEpGdUIzcHQvOWFPYkxHamk4U2pNQnhINno5MEVZdjJZYUdXaFNZ?=
 =?utf-8?B?K2RqYmVtL2ZLZkVyZ2NHUlphQ2NLWXdvSTJJcUNZbVY1TFlQZzlHMjQ4THBG?=
 =?utf-8?B?cjIyZS9DNGhqcVArdkhwNjV0ZXpSbmE2T2FSOXFKUGNFdm4xeXpQcGRwdy8x?=
 =?utf-8?B?YUFub01RRE5ZV1lZaFhaOFUyQ3RuRGZmeCtXVitRTjU4dWlvTVJZM2VIQmpD?=
 =?utf-8?B?djdldDlPMVM5NTRyN0xKVnNiM3B4NWIrbGdvVm53eWhMWTNaL0tTMXdJWlhx?=
 =?utf-8?B?cDV1YXpkS3BjUlhrRmF4ZU90MnBSbGo3b0o4YzAvRFNqaURxR2tibC9rWDRZ?=
 =?utf-8?B?bGNPSkVKb3JUWjRHa0l0V3lnNlNjOVZQWUFEYm9MSE9ha3ZJaFRXMXNrc0xK?=
 =?utf-8?B?Tm5IMU9TR1cwTXhlZVd3YkFTamJWRUM4NkdIdUgrdjR1WkUyaW9RVXNmYk03?=
 =?utf-8?B?dWEvY2IwWkEvaEtYdW9aSkpKdjRTS2RtbytwUUIycGhmYXJ5Y3NnK1kwUEdZ?=
 =?utf-8?B?anN6OStiRDNURmNpeFBMRjIrZitFOTc0U3ZZa2ZFazV4dXNTaC90ejAvZ0xW?=
 =?utf-8?B?L0JvaVREMmhXNDJTc1ZOVDQrYnZjQ0dkVyt6Ujh2TGlsTFB2NjFGckhFbjJK?=
 =?utf-8?B?dDcxSFBTalJxV2ErZnpQSnZadFBJTFB5eUxQRWYxWG5Ec2FoK0VNZjdZUDZI?=
 =?utf-8?B?UGlDUDU4Q015bmhMSklwY3dYakVHYUlMLzJDSzZTMER3dEpoUWs4UzUxVlB5?=
 =?utf-8?B?Zk0wRnpSNGN4ZE0wMEFpUmZwOWFxVE5MeHVBR2ZEb0hQV0RFbjQ5SUJvb2xT?=
 =?utf-8?B?QlhiZ2VXQndTVmpVcDZLMGJBQklvVHJ1TVJnd0t0MDI0ZjhPeWR2NkZMdk5h?=
 =?utf-8?B?R3FFOHFmTllxaW8ra29ENnVwcDk5ZlhjSUVXZGIrODZkTHdYY09PM3UvQlkr?=
 =?utf-8?B?MmVsT2k3ZVkrK0ppbzI4YVJuVzZQc1YxZnh2a2JLVXpUUktsaVBiU2d4Z3BE?=
 =?utf-8?B?S0Q4OUJzcnhEK1hIdW1yd1h1akc0Y3EzZG5rTGQ1ZGpuMDNFT3JCTllGL3Q3?=
 =?utf-8?B?WkVDQzFXbG94bit2Nk9icCtldTI0S1ZXMUpSdEFrbWd1YkN5WmpaRk50Sm5t?=
 =?utf-8?B?VExVbDMwUW9ncHpCTndtT3U0MnJTV3JpWU15NG9GaGVPOFpGcFp1ZzJ6NXMv?=
 =?utf-8?B?U2tUblF1bld4ejJJZEFTVmUrOXRWOVFOUStkS0FFL0hQNTBldHJRaktCaGxl?=
 =?utf-8?B?VTliZjFORFVVajU4UXo3VmNkVHJDQzJCbTZySmFPWVRLK3R5eVRZOGdIaHc2?=
 =?utf-8?B?MUh3aVloNDFPYXE0elRYd3QvRjcwd3dSWTVkT1BpQzQ5cEF1cVA0SEJKMXAr?=
 =?utf-8?B?ck50M2FMSVUybGN5am1kRlhtZVp4d0pOd2dBNzd4RjQvNG9lYTlJTTQwMTVZ?=
 =?utf-8?B?c0N2UnBwZG9TcnN4bE01bFUyYWVVclV6K2dzNzd2RmZyVUo4WDJPbG9FTW9U?=
 =?utf-8?B?YW45TXBqbTRkTnc0bnBES1RSd2g4TkJ2ZU9WN2xUYXN5NFgzWmVXaG13Q3lO?=
 =?utf-8?B?bmlRQXRHdFNaZ2RWTU5GQ3BLUDRwVHVzZHVSOFhhOWVDSzBtQWVlK3VGTUZ4?=
 =?utf-8?B?S1JVcXlUNUdtSkdkb3ZQV2VZd0ZvdU1aOFlqWlVXZHJSTnBUWFZYVWViSDFu?=
 =?utf-8?B?SUJTWlp0bE51c1pUT0hwb1duNVJLcDg1QkJKT2V3NUVnTGJFMXR0b3JOMlVT?=
 =?utf-8?B?TDFjcVRkVGFNVUVWdm04RnhJWWlUTzA4YWFMWFg0QnBjbDcwcU1CM0xFMnY4?=
 =?utf-8?B?M25XcHpSVTNodEV0cm50RGd1SGQ1WS92ME4zQTNwekRiU0YrSHBzb3B0UzVL?=
 =?utf-8?B?NVlldjJpVStwUW1ZSEJyS2JZL01qZFJwb0tiVVg5dlNDUzlGWmJJUGVjbE5M?=
 =?utf-8?B?K3YreWt4a2hkMXRQZXBtYVA1c1A5WnFFUkp1ZkNhVTQ2YXNkdnFLNlB3dmdL?=
 =?utf-8?B?ZVQ2VFhxai9uWGpuNDAwd3ZFNnJOUGp2UlFWNkNWUUVPNG1tOERxSnFxY05E?=
 =?utf-8?Q?AyDkmPVu59agKlxDqg99DhwYt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2CB93A6F60D1C34AA9C2DFC8D1CA32D0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c80cbb7e-a876-4d25-f3b4-08ddd543e97b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 23:49:41.2589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D/Gl/TuDTlmw7LxoobhfQu6rJehkf+hHf0GgeX+tlG0pmigjsF/YWWcuWq0T3MNaLLhtPo2lsGA2OdyqXSN8kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5874
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjExICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IEFkZCBlcnJvciBjb2RlcyBmb3IgRU5DTFNbRVVQREFURVNWTl0sIHRoZW4gU0dYIENQVVNW
TiB1cGRhdGUNCj4gcHJvY2VzcyBjYW4ga25vdyB0aGUgZXhlY3V0aW9uIHN0YXRlIG9mIEVVUERB
VEVTVk4gYW5kIG5vdGlmeQ0KPiB1c2Vyc3BhY2UuDQoNCkkgd291bGQgYWxzbyBhZGQgc29tZSB0
ZXh0IHRvIGV4cGxhaW4gd2h5IG90aGVyIGVycm9yIGNvZGVzIGFyZSBub3QNCmRlZmluZWQ6DQoN
CkVVUERBVEVTVk4gd2lsbCBiZSBjYWxsZWQgd2hlbiBubyBhY3RpdmUgU0dYIHVzZXIgaXMgZ3Vh
cmFudGVlZC4gIE9ubHkgYWRkDQp0aGUgZXJyb3IgY29kZXMgdGhhdCBjYW4gbGVnYWxseSBoYXBw
ZW4uICBFLmcuLCBpdCBjb3VsZCBhbHNvIGZhaWwgZHVlIHRvDQoiU0dYIG5vdCByZWFkeSIgd2hl
biB0aGVyZSdzIFNHWCB1c2VycyBidXQgaXQgd291bGRuJ3QgaGFwcGVuIGluIHRoaXMNCmltcGxl
bWVudGF0aW9uLg0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBFbGVuYSBSZXNoZXRvdmEgPGVsZW5h
LnJlc2hldG92YUBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vc2d4
LmggfCA2ICsrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NneC5oIGIvYXJjaC94ODYvaW5jbHVk
ZS9hc20vc2d4LmgNCj4gaW5kZXggNmEwMDY5NzYxNTA4Li4yZGE1YjNiMTE3YTEgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NneC5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1
ZGUvYXNtL3NneC5oDQo+IEBAIC03Myw2ICs3MywxMCBAQCBlbnVtIHNneF9lbmNsc19mdW5jdGlv
biB7DQo+ICAgKgkJCQlwdWJsaWMga2V5IGRvZXMgbm90IG1hdGNoIElBMzJfU0dYTEVQVUJLRVlI
QVNILg0KPiAgICogJVNHWF9QQUdFX05PVF9NT0RJRklBQkxFOglUaGUgRVBDIHBhZ2UgY2Fubm90
IGJlIG1vZGlmaWVkIGJlY2F1c2UgaXQNCj4gICAqCQkJCWlzIGluIHRoZSBQRU5ESU5HIG9yIE1P
RElGSUVEIHN0YXRlLg0KPiArICogJVNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWToJSW5zdWZmaWNp
ZW50IGVudHJvcHkgaW4gUk5HLg0KPiArICogJVNHWF9OT19VUERBVEU6CQlFVVBEQVRFU1ZOIGNv
dWxkIG5vdCB1cGRhdGUgdGhlIENQVVNWTiBiZWNhdXNlIHRoZQ0KPiArICoJCQkJY3VycmVudCBT
Vk4gd2FzIG5vdCBuZXdlciB0aGFuIENQVVNWTi4gVGhpcyBpcyB0aGUgbW9zdA0KPiArICoJCQkJ
Y29tbW9uIGVycm9yIGNvZGUgcmV0dXJuZWQgYnkgRVVQREFURVNWTi4NCj4gICAqICVTR1hfVU5N
QVNLRURfRVZFTlQ6CQlBbiB1bm1hc2tlZCBldmVudCwgZS5nLiBJTlRSLCB3YXMgcmVjZWl2ZWQN
Cj4gICAqLw0KPiAgZW51bSBzZ3hfcmV0dXJuX2NvZGUgew0KPiBAQCAtODEsNiArODUsOCBAQCBl
bnVtIHNneF9yZXR1cm5fY29kZSB7DQo+ICAJU0dYX0NISUxEX1BSRVNFTlQJCT0gMTMsDQo+ICAJ
U0dYX0lOVkFMSURfRUlOSVRUT0tFTgkJPSAxNiwNCj4gIAlTR1hfUEFHRV9OT1RfTU9ESUZJQUJM
RQkJPSAyMCwNCj4gKwlTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkJPSAyOSwNCj4gKwlTR1hfTk9f
VVBEQVRFCQkJCT0gMzEsDQo+ICAJU0dYX1VOTUFTS0VEX0VWRU5UCQk9IDEyOCwNCj4gIH07DQo+
ICANCg==
