Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2542C2877C3;
	Thu, 13 Nov 2025 01:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762999200; cv=fail; b=Mrw8nCoxhcGYRi0c8XERaQXmiGQRn82qC4jvEHToq44netGbwXEiN+DoBSOK+QzVC4K+ZnKuAsNVqs56axAyK5uomzWN866itIdnMSELyV3o8RtKPnfC8KGmC5LZsS1/OQg5Lish7DiKJxstL9n/lTAVxY3SpqDBcVgodLxOT0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762999200; c=relaxed/simple;
	bh=QRPTMKegDBeb46U+EindTEFCoJ2dqDM1COzICMlQBy4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LVuT34obDHtB1mQtPDIt7G7EGznazSWYcfk0X28tfnVzJeve6v8gn2P6PlXOb3KCbaO7cUyelM5C/ur6z5bJyYoc4K8OK3tr6bnAfLG8A6qC+yB1OmMoIjV6rMYTw6kQ1oC/XGFODJOyzkLB29aTdsdND607h85SAJHlF3TajnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RIkt003Z; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RIkt003Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762999199; x=1794535199;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QRPTMKegDBeb46U+EindTEFCoJ2dqDM1COzICMlQBy4=;
  b=RIkt003Zi4WtpNHydn9x9Xm/iB093XS3J7HQBM4+G3CLSKO4O+eswkLL
   yNeybBaleUu/fia2PCHI4Z+xRlPMxlQm3sQ2vyp/LCtF0nR3GoHihDI/r
   DWmlG9aVUmTV/1syODNz9Fe15/HEXmXuWmer9+qFlPxXcfZ3zDKa8jSM4
   9Kf7Nons+jE19DjX52MeopMe4ZgroHRBYSGYbvR4J26wY3uM8X0+tT0rO
   JeLpia7gvAqmhjg2cGRWBK6thd5vJCPLuQlwBuY2w/s13+GXvVnXbj2eW
   ost13J1c/G9YMnfNP+EItlTAq58sXzrA1MNyDDvc5EUynuPKDF9hpyQfV
   g==;
X-CSE-ConnectionGUID: i+zDDXa7SCW2piexN7JG5w==
X-CSE-MsgGUID: O+RazudUQHSPiHWP2KCEbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="65226930"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="65226930"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 17:59:59 -0800
X-CSE-ConnectionGUID: M4qr1I5UTRGMpYZnC0y8Hw==
X-CSE-MsgGUID: 49Cdow8KTsi182yOjLluvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="188622039"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 17:59:58 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 17:59:58 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 17:59:58 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.34) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 17:59:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rXajLAoh+pmg1edNYKWkUGUB195R7+G8ZpMUdlDlFJD0UhK67+nThubRQlbHS0jmZO+vDUYnPr9H6QGVqWsmiviak7vBOF0Vf/AgaX+gUrQLUfDmOhPOFPs61lZc/Ru374WI884vnBbPMcHcMCo5Wj7xkrGkMVrPZJIu2+36l/mHaFVV2FRQZFe1cv9ABWqZcto85xi4dwoY2aiZb/OBYNXg8oafwZfjUOun3xcKysUGfc86QR69GuQLtsKJAdAWBKZwZOqWthKXkLVbQqE32+euYK10ZLlMTNE2lLvP/T/NqfsugFVIozbvFbauWDoJfd4zGM7RuoAoyCNoAmzQQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRPTMKegDBeb46U+EindTEFCoJ2dqDM1COzICMlQBy4=;
 b=cAAi3FE1xsLXzx0uHj2gtfWjuiMdc9nP0L0nZp+GuYXQn5QVQNkSCvx3elUYb02YBRNJ/H45EcbrVaoKDpxlXtHW4FrPuOPo30bja28vCLtIZKfV6E8aLbypw1ZWHBJP0wYpBfcCd59Po22ARtd+b96vlWpr8qbzTFGmsuOTgNJiRuPDFcAY+NIGORICofomUv2GQgGT7Y/lWlWtQGXRvvqIeVswcTUZOTE9j+ERVxx9IH+wX1Ic8osXSVrw7hpDBi2Wc593aTGzIMOvppSiw/GOO+N5wOFLM37Oc6r9BncWJ9qYK+eEOCMG0WHU6blgOs9sMK7GWx/HJH0XoIc3ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 01:59:56 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 01:59:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/sgx: Fix kernel-doc warnings
Thread-Topic: [PATCH 0/5] x86/sgx: Fix kernel-doc warnings
Thread-Index: AQHcU/QdM0YVwNNEcUOh+pcyWzewdbTv2nqA
Date: Thu, 13 Nov 2025 01:59:56 +0000
Message-ID: <b575bb793a05c80f3999534f18b102535c32fbcf.camel@intel.com>
References: <20251112160708.1343355-1-seanjc@google.com>
In-Reply-To: <20251112160708.1343355-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB6779:EE_
x-ms-office365-filtering-correlation-id: ea49eef5-2a71-459f-d2c8-08de2258581c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NWtPTEY2Smltc2ZBVVM1VHVMLzhwcU1DVUlYWkxSODN0WDRoL0swK3ZiVTVE?=
 =?utf-8?B?TGhCZzcyVHpZd1I4SDF0NUs5eG8rVmQ4S2NobGk4ZHpBLzRWd085enlmUzd4?=
 =?utf-8?B?UzRFTkRYWm9HeUNrTE55dWIrbXlhN3hhSFBZOUpvb2lhV3Rua3pxZ0FTT2Zl?=
 =?utf-8?B?TktPTXY4UzRUTkRYU0tML3NSVjhETjlaVGZUYXM4U3N4V0ZRTmR6RlhkNE5l?=
 =?utf-8?B?WnFic3BnNlMvNUYyRWUvWWNFcTlNRm53TVFoQzdmd1RsVGZDNGFFOGFUVEFB?=
 =?utf-8?B?ckY4K21mbWI2VEdrSDRFSmswVlV2dWEzSDg3a1lyWWNQV1R3MHVodjBKMU1I?=
 =?utf-8?B?S1FXSUwzdzJ1ZFNGYysxbENEa2x2bWp0dytLT3ROYzE4OTdzMFFLZ2VFMWpm?=
 =?utf-8?B?dVVLc3NNcFJoa1ltbDlJYnQ3ektWTVBVQ3BXZ29wSGpCNHZNQjFWeUgzUHY2?=
 =?utf-8?B?dnZ6dXNPUDhRU291MWR1ZURRcTIwTFZjelEwckZnRFNUaEF6VFIwZnVUc2Zk?=
 =?utf-8?B?T2sxbGZKd0NSMHg5d1hnTGNMK3AzSzJSUGtIcVBEZGtkWjJVellPRHcwdFRz?=
 =?utf-8?B?QXZ5aTNFRjZEblhaYktSY00zRlBxd0dnek92WXp5UFN4Y1oxMlpOZlM0cnpq?=
 =?utf-8?B?VkVPNjNNUEFwNTg3dVJDOE8rbVhNMStZeWJ2SGhiWk5CYjJ4YmcwemxBZ0pT?=
 =?utf-8?B?WWpyamlHZXpibVZMM2Z3Q3A3VkFvTWdSS3ZaWHZPRTdwVWR5N2Q5Z1Y5UW5I?=
 =?utf-8?B?dFp2dVp6M1cyZ0dNVHRQTlRyVzhLeU9QelBkTUFZaktsa0dCc1BkSUNVVDAx?=
 =?utf-8?B?Z0k0RC93N2VBSno2NGNhS1BDaGNiZk5mR1hUejMwK1d2UzF5UWcrSnBsYVNM?=
 =?utf-8?B?VnJoMnJOM0RuU25FRG83bkdrRFpLMEIxeW1mOEVYWkorVEVvd2tyZ0lUeUdF?=
 =?utf-8?B?MDk5ak5mTUJncUphWHVrQmFaeXNBRmI2cWUwQVVLZmplbHV3UVR1enluU1p4?=
 =?utf-8?B?K3phRnFJTmlYSUQ3SDR6U0ZxcEpQbjdmZFhMVHArSlJzT1hqZThxd0JVRk91?=
 =?utf-8?B?NXFkbjkva0NXeGFwNmtrYzR0dE1ZaFBuYUhyeTBoOWhZeitaR2dXVnI4bnNK?=
 =?utf-8?B?ay85aDR2Ylp3ZTdoRTBEVWQxWXRBalNLdHVrV2ErNVA1SHpVVDZwcGx1NGxy?=
 =?utf-8?B?aklyajEvUzc0VWc1NDFYVnpkM3JVVExnUkRldUdlMjI4VGoxWlVBdXZCMDVh?=
 =?utf-8?B?Njh1N2kwVG90UU12RDJCY0NSMWNCNDRHeWtwV2pYT1VsQ1YrWmlQZ3pDd25F?=
 =?utf-8?B?ZFE1V1NOQTlIZVVFbXdLbGx2aHpKc2ZCeVZNRWdOU1pNNVRpbVlTc0RFQ1oy?=
 =?utf-8?B?WjltdTNkTWJodHFiQWFFbU5vU2VlTDMwelh4dmN6R04vQkxSRXlzUk1HT3Vp?=
 =?utf-8?B?ckVmNm5VOWdiU2EzUzVPYk11UWZxdXR4QmFUWHR3cmpaRVNGTlIxVUhpcmg5?=
 =?utf-8?B?SjhxVGtvUThXWHZITm1DNjk1NDR5NVZ4cXFEWmk4UUtCVSthMFh4R2pPSVdW?=
 =?utf-8?B?N1VyUDkvK0xHcWtoUENFZHNoVndiL0RmMzZHVFdZZDJ5UzN1cVdzckUxbUh5?=
 =?utf-8?B?d0lydWVyQld4ZGNIaXJ3eFpLWjgzSXloM2JUZmhRU3JJZ2lZU1EzU3pvUzdw?=
 =?utf-8?B?MmkxN244dC93WllmcnFKMGhFbHMvMjVZNjRuaGVtMkgydEMwdXBXTjYyKzl2?=
 =?utf-8?B?SksyajdEeVBHV2lxSVJUVGhJT0FVcDJ2b2dPMGpUZ0RoV21ObmMyT1NsYjQ2?=
 =?utf-8?B?NmFRa1RNa2JkS2VzWlpEWDI1ZnRsMTIrSXhDOWJBQmtuRmdYbkJ1dFZ3Wk1r?=
 =?utf-8?B?cjdjZlhES1ZCODkxWGx6OW51TC9XazF0UEdaU2JrYmtSTWFJZFRzSkFsVXNV?=
 =?utf-8?B?SGhiMWxQTHFXRjROcHREeGxQRk1rb1VjK3ZwdzZrczRCU3J1MWVtUHkxTG9r?=
 =?utf-8?B?eWpkcVNsbkpGYXYxaWhoYUVmb1BsVmpxSVNiejljTDZDUGR0NHFRbldxSmM4?=
 =?utf-8?Q?oHMtAu?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UElGamZVb05FNkkvWE9rQVFHd0FLQmRVajVaS0NmU3YwK255ZG1EbGoxcWd3?=
 =?utf-8?B?Tm9ITEEzWWNDU2JwajlnUkM5eTNvaE84aHcrWHBtSXNleFEzT3drWmNIY3cv?=
 =?utf-8?B?VDZNNnhybU1wakZrbWcvRGJRbVNhRXlWN1paNTJlUzZKYW5BK1Y2ZE1oZUZB?=
 =?utf-8?B?akh5cUVsZGwzdDNTM0ozd2l0VWJ2UTZpbENoT2NiTFFjYWVCNHVEYlRVNk9Q?=
 =?utf-8?B?eVZVNEFzTTRNWm1rb2M5WjB4Y295VEp6eEpYWUhocDdWQUMzcWROeGNYVlht?=
 =?utf-8?B?V3V0S1loeFpxNjRZQWNwdm9ES1B6S0MyNEd0OW9JaDNFN0tLMUZuVjNYcEU5?=
 =?utf-8?B?NVRJZHBYSVNIMkZNenVobUIvcG1wTnVzblRxMHJqSEVzR1NINFMxbTQ2bzBF?=
 =?utf-8?B?QkdtY1FaWVMvMlhMUGdGYUxlSnoyb2xRN0tmSHdrc3dDNmJzODBDSnh5Vzlo?=
 =?utf-8?B?VXdJYXcyRTdaVlppWXlNN0hxbG5iYk9SQndJK0psTWw0OW1QQkM2eHlhMG93?=
 =?utf-8?B?VkdhVzBiWkNXd04veXdiYTRIK0twSlVoalFFaGJjRFdmb0JTd3hxNlo1SzA2?=
 =?utf-8?B?cVdpQ1FTNkZZODRtSGFRWG9PRVphWHdhS3F0Z3hjUzBlaHJxOXNDaGo5Rk5Y?=
 =?utf-8?B?Q0tGS2EreVVnM1RDandZWnE4ZTdTYWNiMlRIMkw3bkplaWx4cHpuN29SbnR4?=
 =?utf-8?B?ZEcxY2Q5TGduWWpwbFpNMkMyQk5ZdUluYzBNR2xXbzlaRGs5MWxPZEtXSVZE?=
 =?utf-8?B?cytJd2xHcFh2Z3VONGF5VEhlRmlFNm5XTkwvQVF4QUtxalJuUVQwQ3VNdHpt?=
 =?utf-8?B?WTgrelRZcTd6MExlRDkwNWhCWTlxYVd6UW42aC85WkFnUEdOSGh4d2VvV0M0?=
 =?utf-8?B?U3NqYlpIb3Q2SE5iYzdkcGF1UFV0Qm5BOHhBZ1FSSzc0ck4wTHQ1S2RNWVE4?=
 =?utf-8?B?eG5zaWNrY1hGM2x5R1ZmYkN0TS9uczBwMWJzNnQ2YnYvUUpzSFo0L1oyNGts?=
 =?utf-8?B?MUcxQ1VhMVo4WXZvY1pSS2piRmE5aXB5bndES0JvcmJzZkZmVnI3L2oycnBD?=
 =?utf-8?B?MkVzSDBtUDYrVENsQlhYUmFCRXlCd3FNODRPeW9oK3RTT3ZMUERIN2thR0RQ?=
 =?utf-8?B?MWlWcTJCTDdvRU1peWZSbTNPM3BySlBzNkFFQnFFS2pVMTlMZFA2T0F0MCt2?=
 =?utf-8?B?S2xzeCtxUC9CT3dtbzVVOW9CVUZPY3FaZ2JPWVJhMEN4K3BZZkJuTGZ0ay9X?=
 =?utf-8?B?Q3BOclQ2YmZ3Y0xraW9Db2cvVXpvSW0vU2ZyUlhkand3R2lBVmtQR2xCLy96?=
 =?utf-8?B?d1V1NmlKZjFjc01sWnFnUUloYzFlRk9aVWp0T1pYUm1BN0NzVlVNbVZUOFVk?=
 =?utf-8?B?dFFuRG1mYW1SZDlPcDJCQTFJZmtuWkNuNFBnYUxNcC9pZXY4S2hPWW52bExP?=
 =?utf-8?B?TnY2ZWgwNFlLY0g4Y2doSUJ2MmF0a2I4MStZcWJqSiswVFdYMFZEQ2MxcjZD?=
 =?utf-8?B?M1o3Vkd6aS9QUkZFMUJQSGszR1pvRnlIUlBaRWt0ZE5kb3dVWEsrRUgxTmxT?=
 =?utf-8?B?SkpKR0l1d1lWYVhIUVdKVFZJc2FVWk9VNzd2ZXYxd2djV2UxQURPQzg2aTdV?=
 =?utf-8?B?aFhicHAyZDc3YzVWbmpLY1dmSnhabWh6TUZINEkxN0J3UGZsbGlzY3dGZGRx?=
 =?utf-8?B?ZjlISDd6cURhVU5oaVhQSGNDZDA1dU5EdGVRdGcxUzhlVkt6TXpoVHc4Q2cr?=
 =?utf-8?B?ZWFnekZzRGM0WUdnTUZsUmhObGdIMm1iMldnMWo1ZCtJWEhrNlBUWk9wUWl2?=
 =?utf-8?B?Mzk3SDRTcE01emtmd2k0aklrWFFiemJFMmd3Tnova0pQdEMxb3dIY1Q4cHBF?=
 =?utf-8?B?b20zbFZzdDkyUTI5Y1pZZ3RlS1lablc5T2VjbDJFYldlcW5DS2F1NEpXTTg0?=
 =?utf-8?B?UURqaFk5N3d6S0crYzlveDdCY1JnNU5sSzRvQTJ5RTNnVFU0NnhvTEh1UXVv?=
 =?utf-8?B?OURicXM3OERzcUdTRGdLVndvSndHWFRObTg0SkkwZ3pPSWRtamViN3NyR1dY?=
 =?utf-8?B?Q0JyZXBmcmVpOVViVEladm4yWUlxVjhKaVVudWxBSmo5RFlUS3NkZDI5UFVW?=
 =?utf-8?Q?DqBzSg7uEjBqOC7hGPEaUNiJ7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99C6FA9D6F1DFE4696959488ACA13C2F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea49eef5-2a71-459f-d2c8-08de2258581c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 01:59:56.3648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 113ZlU/Rm8UkSCXazmQqC2x9sDXhMmmIBRM8pX8culh5a0DfRpW71p6geH+XkqypKEgm5UooJO4n73+MWZ9Q2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6779
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTEyIGF0IDA4OjA3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGaXggYSBwaWxlIG9mIGtlcm5lbC1kb2Mgd2FybmluZ3MgaW4gdGhlIFNHWCBjb2Rl
IHRoYXQgaGF2ZSBiZWVuIGhpZGluZyBmb3INCj4geWVhcnMsIGFuZCB3ZXJlIGRpc2NvdmVyZWQg
YWZ0ZXIgcmVjZW50IGZpeCBmb3IgIm1ha2UgaHRtbGRvY3MiWypdLg0KPiANCg0KRm9yIHRoaXMg
c2VyaWVzLA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K
