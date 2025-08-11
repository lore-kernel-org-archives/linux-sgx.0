Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D8D2D3757;
	Mon, 11 Aug 2025 12:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754914475; cv=fail; b=XIq7ejPQIM2EmBf/F5IX+KcPmEUrv9jXVFGC560z1rHuhGY1hEICIw0or0JPJJI1t+l6llVzejkQATL+z2UCQuYO+uV84pUu+Fn8ACOtfDohOUTGur/36o3sMxHR51bPUqIyvNjS7QAtrOisoQBw2Vppnl/LN/z3KXjEHPabhUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754914475; c=relaxed/simple;
	bh=fiTxqw98FGgW4n9GZg7NS7wkeYHS7kynwuwFFhTkD9k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hljdDQa7npNV4Tuz3xnvRTRQQGfqTRDYlFltM2U8gfNFNJlaFaJR4/NkyuRDPZ35lcLCfa6JyOh5ChACPb8XcBchRmrufW4QLxGDmu1EEybYxfS3gUBg0fUyEN2T4TYKc5Tn+Zx00+hrrbFVllRBQP9q9M2ZYlQt3aKQYKijv/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R6V/KdXM; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R6V/KdXM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754914474; x=1786450474;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fiTxqw98FGgW4n9GZg7NS7wkeYHS7kynwuwFFhTkD9k=;
  b=R6V/KdXMAQn7C7dQCAJoHmkyHmclYazXcePBZ8UbzoDawFXrwzBCDZY0
   TMB3B3iJuDop8XyHj/RO0GW+kwflF+S2nzsM7SNH/LzUn5llqvaR5aJqY
   JtQUX2h28BV43q14+rE3Mcd+MU0hqyXMc7R9jTa3rXRt2o7zjNiP+4Tg1
   XKNVSPISQEnWnZO9qKGgmJ4l0fxJ1ulB4XEmry2mC/jYjQ17xSbWunOvf
   nqlN0R+Zrlc+ywZ+aVTyDcE8mEdjwrWUkucAfYjRZxre4nm9TVOuWEOhM
   vYJoHUywfpiP1Tr798KYDz1/Ozu7oma8boFSNudD1QP8cnmtL7lFD32DD
   w==;
X-CSE-ConnectionGUID: B1wwyfmISG+cNafunsniIA==
X-CSE-MsgGUID: hK2Irt0VSB+IyXUneZc//A==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="59777308"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="59777308"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 05:14:33 -0700
X-CSE-ConnectionGUID: Mfu6PG6ZTxW0aAzSFusCtQ==
X-CSE-MsgGUID: taI9BxxFSJanBaAIfVZNzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165540742"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 05:14:32 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 05:14:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 05:14:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.88)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 05:14:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MKtzLR05WeHoci7RH16J9pEpuw79ZAGHKVc/zG5ZUyP4X77CsL6wYIdzMAQ2X1h5pjhRBQUlQqxtrfaZhBpes5oOtVVDrQjZNjPByXAZZwUdmSb5+HJqxSW9M+/E/WEgqmz+c4F16txg5eGYr5b+hisYizLfcuQuype3N3Sebqdlee8qq5Kfr5VPosoIWIVfwxLa//aygtAToWw2WGOJ6T8KA2jkUYRzwHt5VpLkjxpKdjZRHabOuBui1LlVoiyQluOxTcOO5lS94nK6wvRwBCj7O40WXWm/5m6/p/FNFRHv/pX7Jw3PIuP5L4knqUgMFrd2EGw4MqaMl8orbA7eRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiTxqw98FGgW4n9GZg7NS7wkeYHS7kynwuwFFhTkD9k=;
 b=uXQP8WUkhrOKDwDrFPdd58fl5Cin9qTgakHO3T2IL6yHNmPSF0/wU+2IIbdY4PC/NbKOHClEtLlZ01NwvVuLiUJLbKZP3rm4R65mJu8wlz9jF8JTh8gJzg/fxvZzxfAH191tPsr296cz7w+Ldyj0VO665NvVSTum6FthSohrRnlwHpOIIu+agayn1+46mX2ybcPdb6/AJ6ixTfqg0U6z4e2Xj2bxzttkQUKSvg24UzXiXQmfpY99JfWIJfm1fu2eH+dkKAiFasxtti0HK2gyVexsRFfCS7/t5sG27Wfr0tAycaLdr5+m2zcKKYxIHq44nhgH3QPl/3zvttaZ5vhxiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH8PR11MB7991.namprd11.prod.outlook.com (2603:10b6:510:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 12:14:29 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 12:14:29 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v12 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v12 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcCp+L2bMBZ6hkiEmTns/QIMZ96LRdRkGAgAAW53A=
Date: Mon, 11 Aug 2025 12:14:29 +0000
Message-ID: <DM8PR11MB575066A9AF7D7055CBCF2EC5E728A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250811090751.683841-1-elena.reshetova@intel.com>
	 <20250811090751.683841-6-elena.reshetova@intel.com>
 <74fd32cecdd42cb45d88a96a1dbb6d74cb39594d.camel@intel.com>
In-Reply-To: <74fd32cecdd42cb45d88a96a1dbb6d74cb39594d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH8PR11MB7991:EE_
x-ms-office365-filtering-correlation-id: 59ce5d40-44af-48c1-8434-08ddd8d09f55
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?d3VkNnorR0p4QUlkRWVBTkswaDR2Y3RQTUd4MFBMellYK1ZnR05hbTJ6ZXBs?=
 =?utf-8?B?bDBDYVNwczhTdDlIdWlJdVZJbTdvMFpnTXdBM2k5RGdRa2dtT0lDMG9HbEhD?=
 =?utf-8?B?SHNSVGxSVGY5S1FCM3NJcHp2RVhwNEJIM0xDM0FPajRHTU5wUUZSQ0doQ2Va?=
 =?utf-8?B?cXp5cWhqdmJaQVhERDAyOWdjRi9jZFkvWGYyRWhCWlA2clJ4Z1VsRHlYYUpi?=
 =?utf-8?B?UG9IL0dvbGJsKzZ6YUVIU3pQVUxmK2JBdUFqNWk5UEdybVU0TkM5dFZMZGcv?=
 =?utf-8?B?TUtzYU1OWkQvYjdjVHg3UnJLaVprenVNM1cvRmg5OWVldUtESTNjYksvWE1E?=
 =?utf-8?B?OFhRUkxlVFpZNFpEMUIzUjVKY2kwSDJ6NkpwVmpSUkpVRkwzVlRoK2J4bDBD?=
 =?utf-8?B?UFZBd2VvWmV3UW4yVlV5Uk9CRlp4eXNsQkpPbU83cWloZEVpcDc5QzA0Ui9r?=
 =?utf-8?B?allScWRtNnkzeGNhVGhnYit3Q0VrK3RTaUVpMVV2SVUrc1ZWRnJMc3JMN0xl?=
 =?utf-8?B?NTh6bGFTSjNvTkQ3MkxDeFUwK0N3MVc0R05VejJ2V3RTdjBDTklib0hNWGI3?=
 =?utf-8?B?ODdqK1YyMlF2Vk01Vnowc04xZ3VmNGk5ME0ybjlVU285RTBFdS9Vc2laOHBX?=
 =?utf-8?B?ZlNuNjJPaTlaUFAvYWZIQU5nUzFIbUJtL2p0aWo1amdiOXRZZkh0dUFwRVNt?=
 =?utf-8?B?VnRPMitTRXFCWTlsQVVwaGV6ekMvQVh2WVlXR2l6bENTRnNlOFpydVJEZll6?=
 =?utf-8?B?TVdUSEc4UEdtdDJsekxQZlg1RXk1VFFoeGV2UzB1TUR3Tk8xQ2EySTZ3NnRs?=
 =?utf-8?B?ek9TQUtHREVxOWZxeEQ1ZnVBam1Xd2UxSmVFbFk2cDlMNEZFSCtsb1N2dEhS?=
 =?utf-8?B?RmxFQng5WG1LdmpQRFdwYi9hbFJRRk0yYzFBbGJnYUxnZmdaVHM3YnRQQyti?=
 =?utf-8?B?bW5QUjFwTnQ0S0xYKzBkTXRxVDdudmdrS3FzcFlIdTFhc2dmVWtldy9Zdkoz?=
 =?utf-8?B?QVUrWFQwSTBnTjJ4ZTIrUGxMTk5UN3RvakNVM3dqNXJoNlZNNXZOUVZPdnk2?=
 =?utf-8?B?NzNKMWd4ZkRPeE9CT3RqNVJRQ0ovZ1ZHa3JsSnd2ZEI2WDBuOXJqNUNQYkhD?=
 =?utf-8?B?N2ovWG1XYWtaTzlGZXVrZDRkeWRLTG5YL1YycmdWYnhvUnF3MlNpWmhxK2pI?=
 =?utf-8?B?Q2pQU3g2UWllSGM3V0pTc1NESU9paTdRNmY5eDFqdkJubm9xUWVIcWpEWVls?=
 =?utf-8?B?dUN6d1JzYVVSTExMQjRVVXpCeUI0TlpiZHV6RkwybzQ0Z1ZHOFRCMkFnKzR0?=
 =?utf-8?B?a09JUnMzQ0YrejJ4RTEzUkZsakRhQmU5Z1ZNbGFxVDhuNUQ1UzBFdU5ndDZ1?=
 =?utf-8?B?UU5wL25PZ2NCMTZCK1p5N2lpZjUvL256aytPZ0N4MVhiVWxqWllvT0tKS1Bi?=
 =?utf-8?B?K3E1NUlHc1AyOWZEYStzdTE1SmJQNHJBNVJtUGJSSDFiRjk1Q052YTdjcUd2?=
 =?utf-8?B?L3FLcnk4QllORXRwTVpCOC9LWVpZWVdkR0l1OWtBemlTSUFielAvMWovZUZC?=
 =?utf-8?B?cHA3R0F5T1l2M0hrbER1VmxXRnQ4aDhFb0FjNEt0M3ZxQzJOS0JTdUZ5eE5t?=
 =?utf-8?B?eXNBMjZ2dFErWDhUZk9SdzNjUFZ4RmNraHJvd2VrcUlwQyszaXFCSUdNSkN2?=
 =?utf-8?B?Rzh3OUxFcE5uazZEWFg2bUoxOUtpR1Zya1NnS0lzSHFlUHNUMWw3S0g1RDBG?=
 =?utf-8?B?M2RXUTZpZE9xUHlJVHQ4b0xrZU12dktPclVROWZPcER1NW03VWZxdlIxd2t6?=
 =?utf-8?B?enFiWVEyelkvZTJmTUdsK3JOSERBVVpFYUlLUGZhRXZkUlpKOU0vSE8wbWVa?=
 =?utf-8?B?RjVSY0U5MU1qNTdEdWwyTnJxT2JnS1lBQVcyOElzOXZyVmk0L3BKeGtxTmRV?=
 =?utf-8?B?enNGQ1ROSHlreGYya1dJNURXT1JPT3hVN3dXd214aGFFaDRKS1RZREt1STU2?=
 =?utf-8?Q?wjAbw/prSDp9F+QpRCkrrN2E0oun60=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0JaQzU0cDUxRllTZVBRNlRhZmhqWmpqTVFSZVlDbEpENjFIZTljK2hqSVFH?=
 =?utf-8?B?WllkNlQzdXh3ZHpXWjZIekY1QlkvMTlMZ0N5MmYzalY2WlZiRUJvTWxEWnM3?=
 =?utf-8?B?UG4zY1pmQk5jdzlpUUJUQTE1Q1lhVkk5VDRKS2lmeGpoREsxUytGNmpQeVAy?=
 =?utf-8?B?VTE3SzI1WWh6akczTHMxRlg5Zk5pajRoRmp5OGFyNlhUTzdDZGVlQXJDdDVn?=
 =?utf-8?B?ZXlVRXhWcGlZVThIWmREZmJMTWNxR0d5bm9jd3NUYTFCWlhTTnVjMnRHQVdO?=
 =?utf-8?B?S3JyUGhwN2crTFlZaDdRRVlLUVpyekxDeGVwQVVTR0ZJWHY3eUZVYkN0bzBJ?=
 =?utf-8?B?ejZXYXNGREZPUktxNGJPOU1YQzlnb0VLVkpvTFR6eDlBZFJZdUhmQXZCVitm?=
 =?utf-8?B?TU11bUxhS2pFOTdyelZjQmY5S1ZmeFZpMVo2alE2OTJuL1pSNDVMdjlJdElZ?=
 =?utf-8?B?RHVPWmlnVWpnK0RUcGF6NkhtZXRhcXpOaDZkQjBHcG9UUitvNTd2bkxiT2V2?=
 =?utf-8?B?OEZDaHBoNVNsV0tXSHROblpHVEdGMis4eVpjVEhqUUlNalBxK2RqVklDNVJl?=
 =?utf-8?B?cWovOC9SckpBOTM2YU42UmM1TWJwVEVlZXh1UkxyQkxtMTU3N1MxSHhNVHdC?=
 =?utf-8?B?Z3lkMjdOTVhDeWcvb1dFQjVXSlE0L3JoQlMyWEwwZlBZS0xjMlpyRWxUN3o0?=
 =?utf-8?B?bTRpbzRqeVJVN3ZyVDRta0pGRG00WGtDalFRUmlFcDhQS0RvQ3J5OGJwczhj?=
 =?utf-8?B?RTRrNkRhUE9qeHcrVzJGVktpbUE1NnkrVHRIMW9BekErTVZGSUNJK3NJYWxm?=
 =?utf-8?B?YnVObDYxWFhhUW1ldUcydWFLRjlrR2JHNTFFcUhIWitCT2lqd2NXdU51QlVi?=
 =?utf-8?B?ZUhiTjFEUDdzYWJxYTRnbTRXQ2oxL0R2ZitpSFlVSVVMNjdEL1QrNW8zdGty?=
 =?utf-8?B?cmdlbDlyZHJwSmR2eW8zV1d1Z2wxQklXMmVNa2NHZzllR2YzeHpJK0tITGpx?=
 =?utf-8?B?OTlsYzU4akI3ZWF5Z1lIN3VEekR6ZXdyajZ0R3JSTHpuUTdEMkVUTjJrTkRr?=
 =?utf-8?B?b04yRmdRaTdPUEpBc2RVVjFRWUQwcDJoNXErUStQbDFZT1JtWi9NTkpuSTln?=
 =?utf-8?B?c0VVZWFxcGZONlMra2NKdHY1TU1odFZZVzNoQVZDWFhvNWtQQVVvRm05WnF3?=
 =?utf-8?B?Rlc5WHU4ZjZJd2JON251UWFMdDVmeVhhVWhYZ0k1S25HdVIrVjB1c1V5cUdJ?=
 =?utf-8?B?c1FvVFRDUzhxdDExN0hqem0xRFlqaTFhN1hwSTZhTk5pcHd1UXEycU9pY25w?=
 =?utf-8?B?VTRhVVBoY2twMGw4dVdTc2xpNjM2VFNmWWhPTGo2S2p1V0JWTTFJUHFnNWZL?=
 =?utf-8?B?QWc0SHNjdFE5RWpxTDBJNGdnWStPN0NUQno5UkxhUG84SVJXdjFiNUlHTUdJ?=
 =?utf-8?B?cXBhQWs2RGZjT1RMTEtwbmJBci9xQWpqdlZrT0xPSEk5K0hkUlNWSXlPU0I3?=
 =?utf-8?B?bWg3Z1RZOVFLZHRRWUlvc1hzL00vTWVFSmNPZXVoeG9PYUZ5RGZqdXJxMjhV?=
 =?utf-8?B?Zlk4WmxsbkUzU1paKzZ6YWU5dUdOb3gvcnJNcENMZGJreW9GMGhIVTVTaEgz?=
 =?utf-8?B?Q1RoTy9tNk96S1dBTCsxd1VSd2NrWmF0dFI5dmREemQ1VHp4WVkrWENQU2Fz?=
 =?utf-8?B?ZUxZRzNJbmkvcXQ1d3BlT0pzTnZpSFEyZFhCd2M5TDAzb0dOdUwxNEs1cjVs?=
 =?utf-8?B?eTBSb1ZtbzNKVXpJWkszT1V1dGxoU2ZPaXR3czJhREgrUEFYNXBtVGI0NENV?=
 =?utf-8?B?OVR1Y3IyMEw4REUyKzIrK2ZkVmd1bkFrR0IvdkZuRzdyT2VXTXZBUHc3U0d1?=
 =?utf-8?B?VmhzaXh2L0dDSElwQUxUMzhodXpKdzN2RERyUXNGR1JYeXpsc25rV3AvM1dH?=
 =?utf-8?B?dUNtbDUwS1FmRTZibVVHZzBtOEM0Qko1MEVpcitnRzFFMklIQXg5ZXlWNnRL?=
 =?utf-8?B?TUNZUzhXNnZ6aS8xOG1GL0s3YzRELys2NXY1OHhvRDZ0RnNMcFlkbk5uaFhX?=
 =?utf-8?B?N0ZDRlZBRVpva0xhWE1xcVd5VFBZMU9HU3BVYlJBYXZRT1Z2Vk9hZDN5azFY?=
 =?utf-8?B?c1c1OW1DL1RrU0hOL3FGZTU0Tkxad2hMRUR6dklWSXM5VG1JM1lGR1czWlRj?=
 =?utf-8?B?dEE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ce5d40-44af-48c1-8434-08ddd8d09f55
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 12:14:29.4186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SgIPbGADW6hI6jzcvt+82t6wRLmf60xx/oE7FcqPRjqUnBDqi7QqkV76Zi7ur+bX6uWRvauRc18OcPLifST4rvJJ++shwZi2gMsw+fY9wAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7991
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBBdWd1c3QgMTEsIDIwMjUgMTo1MCBQ
TQ0KPiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT47IEhh
bnNlbiwgRGF2ZQ0KPiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPg0KPiBDYzogc2VhbmpjQGdvb2ds
ZS5jb207IG1pbmdvQGtlcm5lbC5vcmc7IFNjYXJsYXRhLCBWaW5jZW50IFINCj4gPHZpbmNlbnQu
ci5zY2FybGF0YUBpbnRlbC5jb20+OyB4ODZAa2VybmVsLm9yZzsgamFya2tvQGtlcm5lbC5vcmc7
DQo+IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnOw0KPiBNYWxsaWNrLCBBc2l0IEsgPGFzaXQuay5tYWxsaWNrQGlu
dGVsLmNvbT47IEFrdGFzLCBFcmRlbQ0KPiA8ZXJkZW1ha3Rhc0Bnb29nbGUuY29tPjsgQ2FpLCBD
aG9uZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBCb25kYXJldnNrYSwNCj4gTmF0YWxpaWEgPGJvbmRh
cm5AZ29vZ2xlLmNvbT47IGxpbnV4LXNneEB2Z2VyLmtlcm5lbC5vcmc7IFJheW5vciwgU2NvdHQN
Cj4gPHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEyIDUv
NV0geDg2L3NneDogRW5hYmxlIGF1dG9tYXRpYyBTVk4gdXBkYXRlcyBmb3IgU0dYDQo+IGVuY2xh
dmVzDQo+IA0KPiANCj4gPg0KPiA+ICsvKiBNdXRleCB0byBlbnN1cmUgbm8gY29uY3VycmVudCBF
UEMgYWNjZXNzZXMgZHVyaW5nIEVVUERBVEVTVk4gKi8NCj4gPiArc3RhdGljIERFRklORV9NVVRF
WChzZ3hfc3ZuX2xvY2spOw0KPiA+ICsNCj4gPiAgaW50IHNneF9pbmNfdXNhZ2VfY291bnQodm9p
ZCkNCj4gPiAgew0KPiA+ICsJZ3VhcmQobXV0ZXgpKCZzZ3hfc3ZuX2xvY2spOw0KPiA+ICsNCj4g
PiArCWlmIChzZ3hfdXNhZ2VfY291bnQrKyA9PSAwKQ0KPiA+ICsJCXJldHVybiBzZ3hfdXBkYXRl
X3N2bigpOw0KPiA+ICsNCj4gDQo+IEhtbS4uIHNvcnJ5IGZvciBub3Qgbm90aWNpbmcgdGhpcyBi
ZWZvcmUuLiBCdXQgSSB0aGluayB3ZSBtaWdodCBoYXZlIGENCj4gcHJvYmxlbSBoZXJlIHNpbmNl
IHRoZSBzZ3hfdXNhZ2VfY291bnQgaXMgaW5jcmVhc2VkIHJlZ2FyZGxlc3Mgb2YgdGhlDQo+IHJl
c3VsdCBvZiBzZ3hfdXBkYXRlX3N2bigpLg0KPiANCj4gSWYgc2d4X3VwZGF0ZV9zdm4oKSBmYWls
cywgaXQgbWFrZXMgc2d4X2luY191c2FnZV9jb3VudCgpIHJldHVybiBlcnJvcg0KPiB0b28sIHNv
IHNneF97dmVwY199b3BlbigpIHdpbGwgZmFpbCBhbmQgcmV0dXJuIGltbWVkaWF0ZWx5IHcvbyBj
YWxsaW5nDQo+IHNneF9kZWNfdXNhZ2VfY291bnQoKS4NCj4gDQo+IEJ1dCB0aGUgc2d4X3VzYWdl
X2NvdW50IGhhcyBiZWVuIGluY3JlYXNlZC4NCj4gDQo+IEFGQUlDVCB3aGVuIHNneF97dmVwY199
X29wZW4oKSBmYWlscywgdGhlIHNneF97dmVwY199cmVsZWFzZSgpIGlzIG5vdA0KPiBjYWxsZWQs
IHNvIHNneF9kZWNfdXNhZ2VfY291bnQoKSBpcyBuZXZlciBjYWxsZWQgYW5kIHNneF91c2FnZV9j
b3VudA0KPiByZW1haW5zIGluY3JlYXNlZC4NCj4gDQo+IFNvIHdoZW4gc2d4X3t2ZXBjX31vcGVu
KCkgY2FsbHMgc2d4X2luY191c2FnZV9jb3VudCgpIGFnYWluLCBpdCB3aWxsIHNraXANCj4gY2Fs
bGluZyBzZ3hfdXBkYXRlX3N2bigpLCBhbmQgYWxsb3cgZW5jbGF2ZS92RVBDIHRvIGJlIGNyZWF0
ZWQNCj4gc3VjY2Vzc2Z1bGx5LCB3aGljaCBqdXN0IGRlZmVhdHMgdGhlIHB1cnBvc2UuDQo+IA0K
PiBTbyBpZiBJIGFtIG5vdCBtaXNzaW5nIGFueXRoaW5nLCBJIHRoaW5rIHdlIHNob3VsZCBvbmx5
IGluY3JlYXNlIHRoZSBjb3VudA0KPiB3aGVuIHNneF91cGRhdGVfc3ZuKCkgcmV0dXJucyBzdWNj
ZXNzPw0KDQpZZXMsIHlvdSBhcmUgcmlnaHQsIHRoYW5rcyBmb3IgY2F0Y2hpbmcgdGhpcyEgSW4g
cGFzdCB0aGUgYXRvbWljIHZlcnNpb24gb2YNCnRoaXMgcGF0Y2ggZGlkIGV4YWN0bHksIGJ1dCBh
ZnRlciBJIHdlbnQgaW50byB0aGlzIHNpbXBsaWZpZWQgdmVyc2lvbiBvZiBjb3VudGluZywNCnRo
aXMgYW5nbGUgZ290IGJyb2tlbi4NCldpbGwgZml4LiANCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEu
DQo=
