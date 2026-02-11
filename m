Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E38369217;
	Wed, 11 Feb 2026 10:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770806343; cv=fail; b=pf7q113zQnCFuTedh7GMHa4hOWRKPe8giaADL9m0TyXAQ0t8CdGDNFbQDlNNtEsyoLbGbr3GY5xqyvRYc4LXbRz3VzrpsepEFv5nPasQe1LbeEHwZWRpk+5/TB6Ww5yOD4SeGL40DqGlznoOF+YNIHg7wvoxzT7+pnyR1wOgqMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770806343; c=relaxed/simple;
	bh=6NNb5B5UVNnlqZ3lqF4BViZekOaA2uHYy9aZ+x9CVB0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jW7Ta1T6Gr6xFHdMVuKP47VpqW8xmEglxyvL+tMr6zL4HYxK7L1ewNc4At7bVYyoDUT1VkqBdNu/81+QMbPMwmZXI9GoQpnIm/wy5FadzcaXUjwRnhV1DH01E23Wr9zs7B1nc1u2uBHAICinvHlB644MET2tSryxeTrqHsYBz6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l/7KR/od; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l/7KR/od"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770806342; x=1802342342;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=6NNb5B5UVNnlqZ3lqF4BViZekOaA2uHYy9aZ+x9CVB0=;
  b=l/7KR/oddefGpbf/Lahb2Fe5lP/0NxaSTqvL2NAZIweTKCyCJKMSjpaY
   Te4Y/uSrBR2+4WJB/p9wE7pe1EVJfdB3Kj+SM6vVMeU+3DB5VpYQ8ppkb
   rqCUQ7sxKveo6F3G/Aw6asJg2sBlAE0W1QF8f0so/ttbX+110Lq4Fv0r8
   N5edGN+X8cZ6f8hr5BlUAlVq2PDiDTt7/iGA3orLchfj2Vl0r1h+WHACa
   bwsLZywjk18S4Z3AcW4WKWVQ6Nv1D56IqPXw+xZG3jK85nkBcWsTFKVcb
   qk0u8B0Dc4KnZRXjkbVNCwWjngtEW/ee9qi5j2yVlLf7V0g9zPMJf/6vh
   w==;
X-CSE-ConnectionGUID: Fk+gERrYSbqLnzkEpUUiiQ==
X-CSE-MsgGUID: gxJ6392KRqa11t1zI5G8nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="75798083"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="75798083"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 02:39:02 -0800
X-CSE-ConnectionGUID: zLkdCGkcReunhIWAbfeN3g==
X-CSE-MsgGUID: YygpNDQ1RZy5FOFlSeEsNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212304528"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 02:39:02 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 02:39:01 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 02:39:00 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.20) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 02:39:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fFj22/wcuCIZPRPLcXXx/RohKmaD2Ik3zfd7YYxS9/YvJLGQ+2qG/qGdnDj13qy114gCMLhA1RIQhVRoXVauA8tZsa3TmB/NUX5VLQ8XylHaxQKEtAvydLRMCz2e4wg67vSrepyaFrxfmpz5O/9glugmHWEnVxr+KnWILfhVF6l/wzRu0kN+3DphqS6p6nqIFkeW2owFKuINxOMB9a3GKJJbSsMGVONpKQcMTAIjG+m6F0hiDRILAVtVK7esxY9fj3yDMxAhV9v66AY17kvM+0/GvN1jzn7z65koWUpLb8W2qiS7xrat+bXFk9KlNQ9hb00bpPxTgT0urND1J+zu/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NNb5B5UVNnlqZ3lqF4BViZekOaA2uHYy9aZ+x9CVB0=;
 b=hFNqOsi+LRdazXO+6qxIFSxhxUS8fKEG+D23ZxfRIfLlCj3xnANDLDvq6PIIKs6SJ8F4y5TjKRq4lmgdnzEEahxkjIwOWcahFI8/DgJ1lAWwh14hoymiPsCmobskkbun7lPw6Xfp1a4CtPrTWk0k6hMVG43Qr4DLZM+Le25v/Rv7fVy3RyX/vjgFqkxSsZDwERF6KPoFq+DgrS18lmUX1a2jeLg/T0eu4iRa+JQRRaPwarT/xmrU4oEwpmCi7DLLQDdUwFC7cKBhgyf1gpZQVpHHgHqe/mn8VW/zW7dnKRIwG1l1KoL3Xfzuu9Y8D2Bs0MQRUk2wsUa/ihhfMUfREg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by SJ1PR11MB6276.namprd11.prod.outlook.com (2603:10b6:a03:455::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Wed, 11 Feb
 2026 10:38:53 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 10:38:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "jarkko@kernel.org" <jarkko@kernel.org>, "x86@kernel.org"
	<x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Fix SRCU list traversal
Thread-Topic: [PATCH] x86/sgx: Fix SRCU list traversal
Thread-Index: AQHclkJ8M+GDKwVKHEOH3q7a0h3fkbV9WLAA
Date: Wed, 11 Feb 2026 10:38:53 +0000
Message-ID: <4adb6d4704e678e2d28b840ceaa7eda74cfac6ee.camel@intel.com>
References: <20260205015357.3635-1-lirongqing@baidu.com>
In-Reply-To: <20260205015357.3635-1-lirongqing@baidu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|SJ1PR11MB6276:EE_
x-ms-office365-filtering-correlation-id: 8ff2ce0d-be8c-40a8-f161-08de6959c03f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?UElqM1lPemN0aGlvNzhJU3lvbWkzMDQxOGRleDJCNGxEaGVLQ1QvMVhBbmhq?=
 =?utf-8?B?WGNZakxrZUJRcThkaUZOekVTRGFXOVlhYVVIeFJjZ2pYcldYcmZES2tmUlhx?=
 =?utf-8?B?YVZQRHFuY1hmaGw5eGE4aTd3QVVuQ2xVNzF2Wk9PL2tMczVabkJVYUdKTHpG?=
 =?utf-8?B?bDdWUjY4UGtVYkNBQUhPa05BWGdlSy9GZjRoaXEyMDN6TDJFaitId3FZZjBU?=
 =?utf-8?B?QmhTYU96UStCVjEvdU8zS3dyQVZ3VjQxUVM2NzVJTGlkOHZCWEF6RFE1NGdn?=
 =?utf-8?B?L0hISHBSNmpoUTRGZ0NwbWs1V2JYRmJOTVBnMmNRTmxqT0xtUHNma0Jlbi9m?=
 =?utf-8?B?Mlpsbk8yemJjZEVKVWQ0dHdNY2h0SDh4MHVzYzBXcmtYWkR1YjFhckwwSDEr?=
 =?utf-8?B?Z3J5cUgyYjhtL0hjNUFSZytsU3A3cFErNDhGRUpOQUFNYTQ0enkzUGZJS21r?=
 =?utf-8?B?MnptR3lHaEExVnhSQ1JZMnNqOWx5aWwwYnJycXFqY1NyZ3B4QlNlUi9OMXdj?=
 =?utf-8?B?MEJvT0FQOFBJYlRQRHpvZkZ3YUhTeHRJUnYrWmU1eDJXMzRYTUExOThESGNk?=
 =?utf-8?B?ZHE5YjhwRk9Xd3p5NEg0UHd5TzhuYTFnUkNHNWljb09FZVlrQm51eS9XKzdB?=
 =?utf-8?B?VkdUN29FRm1mRmZDQ1NEb1RkTUpTUzc0MWlBeHFVMTF6TEVhZDFhaTVVcEdM?=
 =?utf-8?B?UzB4SWJQTVhyWUhzTkI1SzBkSWgzVmppaHBWVE9SZERCYXVRZ1NUNGhYNHFW?=
 =?utf-8?B?T0FYZGpIaXppc0YwV2o5Wmx3L2hScnpiSFk2Y2R1Sm1Rd3pqekZCNWczTXc0?=
 =?utf-8?B?dG16QmJXZlJVeXM1aTFsdGc1bmo3cFovWHQrb0E3eTcxbkVza3IvZTdlOWxt?=
 =?utf-8?B?cmszYTdUSC9qRTEzeXdKRlhrSFphVWlhWEVRYzB1d25UMVFqYThKeVhIYUdv?=
 =?utf-8?B?ZGpHTzlaWDIzQjJPL1ZCOVgrdHJpNzFHUTV6VjBDSVlqVEROQ3pycm5BNzk1?=
 =?utf-8?B?ZkgwTVEwcTg3UUx5NU55Rk05UitHc2tNQXkxSmdtbVQ0c2k3M05CWmc2UmNw?=
 =?utf-8?B?c0IxdS9aV1dvK0dQcHVxYXM0L292WTFBYVZGeStsckdvTytzNzRGbXdLeHRC?=
 =?utf-8?B?RkJIVGpzMnlCelg4WERsSExRdXRXREhuYUEyNmFKbnFYd0RYbllsdkEvWVhv?=
 =?utf-8?B?czRpT1RvQm9yMWRwc1VTQWxUT3dFQ1dPa2dNZXFpRXJYdUVjcEMrczhiRFlt?=
 =?utf-8?B?S29UVDVlaTRVbnJBVEoxUTkveHZMeVlkZENuWEJIUDh3cTJNVVA4bjJ3dm5U?=
 =?utf-8?B?RGFaa0pEVnF5cmlGbXc1K1paSDZJQVA1Z2hYL01oVzRITkRkalJRWGJpeXVZ?=
 =?utf-8?B?SmtETndvM3VVOTMzSTFBNzhacDgrMW93bUx2K0crRXJiTGlXNVV0Wk82ZFJL?=
 =?utf-8?B?MUptUGhqV3RiYnhiN3lVdTdIT09jbDVzV0VyeVpCeHArMDhJQjFJS1NYSDVx?=
 =?utf-8?B?dUFTbTRGaDVGdUhteVBEaWNqUVM1dDBJWFQ2UUpGZ3lwRCtkN1VSZHZINkVh?=
 =?utf-8?B?MWRYOElkekppKzV3TjUwdW1vY2tMZlJCa0R6WEdLZkR0Qi8yNE4yT2FpOFBt?=
 =?utf-8?B?VzNJUCt3ZVgza09OSllEK1hyWmsrTGdFclhYNHRDcTlWWVpiTVhjLy9FRUhx?=
 =?utf-8?B?aW5pVGY0QmpnRWF5ekdKVGdyYjNXeFRBTU5LTkkyMFJlV2xRY2tQTURZdklE?=
 =?utf-8?B?WEZTdlJjb2MzSmYxVjNVQ0xYMU55NjkySWthd1JmRlZwb0tUMzlLWmtOMEpp?=
 =?utf-8?B?b1RKVWlwWGFPdVladG5lMUczVGJjRTZxMlZpZ0VRakszU2lnMUFuSGtpVTNT?=
 =?utf-8?B?SElWUWkvWVRBVzMxU0RhSExjQlVuT0dEaXozUTkrZmtYc2xpeC9XSWlIdWFo?=
 =?utf-8?B?OEttNHBKRmRNZllIL3FqOW0vSEk0OERDcEpZNUlQRFFNYlNtM1hzbC9lTXJo?=
 =?utf-8?B?SnJKVGM1UjRFVXJPb1ZDSWtpYUlRdXBCcUxCM2xNb3BjZXM0YnpSU2ZXRnBk?=
 =?utf-8?B?SGU4UjFRV1FoTVpOMS9GWUh0dEgvZDI1RCtxcXljamVXbnUwVUFrL3Vnb0hh?=
 =?utf-8?B?Wm9VdE9BdjRFMlFmamczMHV1YXZIeHh1amNXOWpwdHpUSDdWSno1dFVVY2Vo?=
 =?utf-8?Q?1OfYSeSpV5cZkx++N5uwS24U/A/HfWPX5o9trPi3CVlO?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?am1hVllyUEpSY2dTSk5KUjRjeit6Smxablp4dEk2ZGoxYzhHc05TMmQxakU1?=
 =?utf-8?B?MTJvNTE3NUd2MlFrN242MDAySWcrRG9CdEJneDcwcE1qNENTb0RSc1ZDQkVQ?=
 =?utf-8?B?NVBWSmp3SWRwYUxtZWx5NjNZcGpuZ2FBRno2RDlKSTErZmtob2tQWi83SWFM?=
 =?utf-8?B?RkhIS2VRUGhOMUFzT1pnY1JWRUJlbDA2NmNXcDBaVVlhdnRtR25qUEY5SG13?=
 =?utf-8?B?M2tIZTZBYkU2dC9HRkdOUkV3YjBTU0FJUWdraFEvUVhYbVdScHdMWWVZN1V2?=
 =?utf-8?B?Qy9RVXFhTjhIQ2xYb2lXbEpSemcxZzhXaE5BbjFTTm5LZldjK1RUUTVDc3pp?=
 =?utf-8?B?aHIwRjEwVURGWDNnNnVsRGdSQjRCYmdzMVVDZGxWd2VGcXpDRzlROFREMktG?=
 =?utf-8?B?TUlxMEVaR3RNaGNyMlFmMXpKMHRMZ0x5WVpETEVvVEY0RHF0R2JnTzljdWpl?=
 =?utf-8?B?VHRtOTJ3L1htaE1uZU1oUVlNZU4wbGtPQnFpNE9ZaStBNTl0K1h6QVdHZUhE?=
 =?utf-8?B?NFZhcGNuR1BwUVB1YlZscVdoYkliZzdmMnIya042Z2tzTDZmb0FuUUI4V2h5?=
 =?utf-8?B?Z2FsM3dNYnEvMUgrVkQzN0MrcUVJRGNMNW5VZXlvb2Q4SVAxc0dsQVpad0g3?=
 =?utf-8?B?TnhYVnNPUjNBMjhIK3B0bEFZZHJBZDZieFpYWU5DeU1wY3NlQVhkaDYwaU51?=
 =?utf-8?B?SnBZa0FycUFTRE13YXJXWUR4Y3E0TTBjVjRjQWE0WURWeVhWSFJ4UnBPMERw?=
 =?utf-8?B?QzRtUVorZ1hYeWNsUGZ4cmxiL0dJY2ZSdnJ3dXhycDdKd3JVQ0k4M1pJMTFa?=
 =?utf-8?B?UzJYcExRRnJqcU1OcFpzcXF1RGxlVUFSOWdZYm00U3RQRG1jTm1PT250WEh5?=
 =?utf-8?B?cEhWU3ZwYTh0UUQ0T3VGYXl3L2ZTZUJhWElDVkwzMjIxdTNNQ1BaR21HS3VK?=
 =?utf-8?B?WWQ5SjArUElneHI0THoyajdSZGdjQ1VWb1R1MW8vVkwwQnVmbVZkQWpIUFVV?=
 =?utf-8?B?WThkdnUvVW5mSGE3bmlndU5uZFdKVStTTm1mWS9wT0dKTGppSHh2SWdod1Fr?=
 =?utf-8?B?NURHS0wzYUVSeDNxZHNxWVB1MWhqOGNZVUlnVi9kVTdBMTJkTkdzcFhsdU0y?=
 =?utf-8?B?ZUgyekVuckQyVTBaVlVMNEVJMmNSRStKQXFCRko2eWpjc1dXTTMvY01JdGJD?=
 =?utf-8?B?MFlrWUZlck4yU295UGNkMUZpMWFiTDdsZ2dURnJ2LzlNVnM3YTJGU1ZQbDgw?=
 =?utf-8?B?aXFuWTdJQTJPVEYzMmtQaThPWFNCSjVCWVg4aEFwNWp1UEtvTzQxNlZFZ2JF?=
 =?utf-8?B?NEl6T0pGaElnYjZxSFhMZUFsejVBMFJYTVU1bDdseFhDakJwS243WHFJT0xT?=
 =?utf-8?B?R0tuUlhndXFKVm9xWEpGczB1WUtsZjJ6dGxGdEdYR3lCWEZJakxYNzdhMi9S?=
 =?utf-8?B?Y1N1VnVVR3dqNHBrNkRYZmZiSjU5anpycWh6bjI5U3U1bnJrS1hmSkxMc3pv?=
 =?utf-8?B?YU9PWVNPSlBrYStqL1R5WlBHTEVkMlF2QU9QaVlTUnhvQzZpdGV2ekQzaS9S?=
 =?utf-8?B?b3lSYTZybG9CMU9XTzNrU1JFTVNjWEY4T0RIOHhJMUNZYWgvL25kSWJ2cGJN?=
 =?utf-8?B?QWlPWmlyN0UxVEpjTGpDcnJzN0hLWEVJSnE4MnJrVEwwQjVOTUE3R0YvYlNu?=
 =?utf-8?B?ZS9WVFVuM2FUQVIvRjA0RDlBUHMzUjhPcFdLekJVVGVoeUYyUHdpOGU3Tkg1?=
 =?utf-8?B?QzNDM1hqY25NNUp2RldSVUJGNHdNRXBHNTVWcmJnU3d0TWNEMk1icnNwZXRJ?=
 =?utf-8?B?eHVFM3h6N1IzQUwwNzFVN0RCWWZrK3FTbFRod2dOTGF6RGVCYmRKbFU1ams0?=
 =?utf-8?B?MFZsM3ZKS0djODFzOGg5RkN3SVU2bFRhYkVsK2hWckpnWFIzMDZmM3FFSVox?=
 =?utf-8?B?Q2FWRWl1MDdJWVJoQnpBUEFpd004NjcxdWtMRGxLQnpRc1JsOEU0cUdwUzRz?=
 =?utf-8?B?OUU4TWpFSmU4RTFMVmo0VDZoTnpxMHZXNTZwa3BSajJIczRJK1I3b3RwSWxx?=
 =?utf-8?B?cFNHY0huV0hCYXJET2dHTHl0aWtuUjZEcmUzSmwrUHd5MEo5dnBuWFdLd3JL?=
 =?utf-8?B?Zzh2bTRJZCtiSHlZNGFJc2Qrc3JSY1AvTjY5dFMyRUNsNHhRVmlIYUtydGNH?=
 =?utf-8?B?M2ZYWEdRQ2dvNFN4dmJQMzBQdFExQkgvTEFzSHdZNm1HNzlSK244WldTVncx?=
 =?utf-8?B?cWlzcUNaRmVhTGpvRXcwZlJ1ZnBIM25nTHFjczU5NmY2bTNWaHBGM1VacG1j?=
 =?utf-8?B?b0tMR1pUZ3IxQVJWWWc4SUFVOXlXVTNjUm9ING0vTUJXRDBFaTBMdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <688E180C90BDF94A984F8FE799A95296@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff2ce0d-be8c-40a8-f161-08de6959c03f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2026 10:38:53.1434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vw/GhKCHV78ZTUa8cR5aFFfP1M02YnUumwMyo7zxuIqDMcY+3rfnz1QTWup5luhaYVGjlGszHyKyJFd/cyCfCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6276
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI2LTAyLTA0IGF0IDIwOjUzIC0wNTAwLCBsaXJvbmdxaW5nIHdyb3RlOg0KPiBG
cm9tOiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+IA0KPiBSZXBsYWNlIGxp
c3RfZm9yX2VhY2hfZW50cnlfcmN1KCkgd2l0aCBsaXN0X2Zvcl9lYWNoX2VudHJ5X3NyY3UoKQ0K
PiB3aGVuIHRyYXZlcnNpbmcgdGhlIGVuY2wtPm1tX2xpc3QgcHJvdGVjdGVkIGJ5IFNSQ1UuIFRo
aXMgZW5zdXJlcw0KPiBwcm9wZXIgc3luY2hyb25pemF0aW9uIGFubm90YXRpb24gYW5kIGF2b2lk
cyBwb3RlbnRpYWwgbG9ja2RlcA0KPiB3YXJuaW5ncyBhYm91dCBpbmNvcnJlY3QgUkNVIHVzYWdl
Lg0KPiANCj4gVGhlIGxpc3QgaXMgcHJvdGVjdGVkIGJ5IGVuY2wtPnNyY3UsIG5vdCBSQ1UsIHNv
IHRoZSBTUkNVLXNwZWNpZmljDQo+IGl0ZXJhdG9yIHdpdGggc3JjdV9yZWFkX2xvY2tfaGVsZCgp
IGFubm90YXRpb24gaXMgcmVxdWlyZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMaSBSb25nUWlu
ZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQoNCkFja2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFu
Z0BpbnRlbC5jb20+DQo=
