Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31F3270EAE;
	Mon, 28 Jul 2025 15:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753717591; cv=fail; b=HDSb09mK68IlNjbSralG8FAr5QwlY4DUGPEKAdV5730paRLfcGXVk91rfFc6/xbS1leQQ/6CcoP9g38u03yggNpomsC7r5YtYd0GXmR4+AtcJW9XdO6iAUyN1y2aarWd/MNfc85aYqiv40g2Ae6nkebOFmWR8rbyf18XEi06gF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753717591; c=relaxed/simple;
	bh=SuT3hDOtQO5Eb0odedYbPCBLYuAfUiwIUIRsDIIs1Ec=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NY0SQB+nx70YaUZMWtUN62GlYoOcLO/5+fs8VfNTDVPW2LUQRj6NxrRQOLdfreGtLfwvyN2kgAUs9pPhnQJISAo3ntk2JeeLxCEvPovVL1eg9kywXCCW6YLt6LydQmqc3YY4Dzq4ItzOc9vSneODdBmlnjvqA9UrLWdfJx9SUbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NfUTMEgz; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NfUTMEgz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753717589; x=1785253589;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SuT3hDOtQO5Eb0odedYbPCBLYuAfUiwIUIRsDIIs1Ec=;
  b=NfUTMEgzwhbYd92AJwU7+I6HN9nqp2iYyUaDiy0kKGUmvE5qgZ30j4Ud
   sASGYlUijjPVguMtg3J3N5y7E922lQPcPDJe9rXZiVjI5qULAPa0uFRaf
   po1q4BWGbBInkZPIh1yxKt28gHCVKA+E31zgSRYs1/SE3DjwtRUvQrk1L
   9ZFeVw6/QB2T89JYtL9xnkxDd+cJ1IZoH++FDdZ3FUSIWCbfetoYBQdnK
   qoZhTHzc0r7PP3k9w7YTbXG2tXu2krb68Ol4A0Lmaw6EUGvo4Zodrl+GK
   f1RKj8CuRJran8piS2ICCxLk+K6GxnFsfuM0ol6bO5AVrRgrAr2Fiomc+
   w==;
X-CSE-ConnectionGUID: yIp7L8V3R0ibuRtZAPvBpQ==
X-CSE-MsgGUID: 1BP/7UhYTfq5SyNZUX9ANA==
X-IronPort-AV: E=McAfee;i="6800,10657,11505"; a="56062038"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="56062038"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 08:46:28 -0700
X-CSE-ConnectionGUID: QpA72aXVR9e8NuhtxqFPOg==
X-CSE-MsgGUID: 9TjxZ0BKSySuT0SVXyzAvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="167853603"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 08:46:29 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 08:46:28 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 28 Jul 2025 08:46:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.71)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 08:46:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0waxOaBrhh7CV7kcDlHdT+v6YGnHBDR5k7tKEjhChIWfgZriFEBuyZp31sm4eEPyHhjWwAzRGAYlZX5hscGB4vNSnaXCJ+osdGBN46kUJ1rzAfRkmIiCfjJG7hF4N50eG0YJeazdzHfOJ+Ecm+gLfNbnel5WRrNVG4R9AQJoVFWgac2z5Owmm2vH2D6ya4Ethe6kVDsSKBrTdynmzGZ2bLzYyntbJVsmlWhCLKmBXJJg5HeXLpdhkMLQw6DH+On6Ha3WT0606XQEncGTNUx+VySYj0fZ2K9U2bxUU7fvdAySMrx0AtfVBbE9/N5J8lJsZJ0+RLqHlQxBFQAXo/FLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SuT3hDOtQO5Eb0odedYbPCBLYuAfUiwIUIRsDIIs1Ec=;
 b=hRwKV24IZooe7cwr8HOqv92nqpZkNTyXoVyI8ktStyD5XddQSKkktlaiEIr2t0Cg8QTpisy4pJ8TbW4VQiTJixu+hFY4MMDLZECMDLQgPh9BQcj2x+H+p4cSSPHv99URQC4qkC1NfHUygoh2WIM9BBVs4rouDINfG0Xeot3ciQbDm2SRoU/eNAc0E0m02EREH3qZcEFTjoJxIyS7+CilKxCEiUBQZMhNe18OQP3Z0xdcVQTgawXNH6BoeQGykwfdFiZfnrLiBGiCt+j9OrLZuIaixNxb7zIM0S4TOO+mif08ALJZDvX2hwEqE8uzTZQ9jjXYHi4A0lbM5q59WCU1sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CY5PR11MB6319.namprd11.prod.outlook.com (2603:10b6:930:3d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.29; Mon, 28 Jul 2025 15:45:51 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8964.023; Mon, 28 Jul 2025
 15:45:51 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHb/HGKXf61+ezBWECHdPwVOqpZB7RBHu8AgAAYdDCAAI+TAIAACBCAgAXkkpA=
Date: Mon, 28 Jul 2025 15:45:50 +0000
Message-ID: <DM8PR11MB5750849B39C1719ED4AA69AEE75AA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
			 <20250724080313.605676-7-elena.reshetova@intel.com>
		 <156919280fe6b1e01a81bb89f8850e72a6bfe077.camel@intel.com>
		 <DM8PR11MB57502FB1B78481B436DFAFFEE75EA@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <7a9e68954b23418fab09edd64b47dc8056f7f8e8.camel@intel.com>
 <e6ff5068a4e5b0e3463ed20657772f476eaaf070.camel@intel.com>
In-Reply-To: <e6ff5068a4e5b0e3463ed20657772f476eaaf070.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CY5PR11MB6319:EE_
x-ms-office365-filtering-correlation-id: b14857d4-ddb1-483e-7158-08ddcdedd455
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|1800799024|366016|7416014|376014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?TGRsa2ZBWlJoZzNJdjkrM0lSUkdkK2g3SktSWVJMWFAxaW1QSWlvWERVQnpz?=
 =?utf-8?B?aEFLMVBOSmZCUUxoRHhscjJmakZpNjA3RGVsay9nUks1OHNZSGFZVnhkZlVR?=
 =?utf-8?B?Y1JuMkRhVkR4VURNaWR3Y3kzYStsMmRIbEsrTENXdzY4R3RoWTdJSktsY0U1?=
 =?utf-8?B?WlBHMkxXd1psMkttcWFuek1Mdi9SQkYxSFVreG9IaUR3aG5iVjdWd2ZMU3Bw?=
 =?utf-8?B?TWM0bEpwV2Nhbnh1TFdhVXBWVk55eDZVUWIxS0wzR2hxNlQxYmVaa3h6aGcv?=
 =?utf-8?B?QjNObDRhOUZYZGlpN0piSHh6cnNTM0lEMHV3d2I3WXpCZ0lwTklUSHp3cy92?=
 =?utf-8?B?OURDSng0dDFuSWp0emJucnI3T2g5RG9CZHljNnpyN3RwRk9OM3QzVllyWnFH?=
 =?utf-8?B?Tm5ZOUJ0aXlSNEtqU3A5WHFjcHMzbHpDam5mWHZVdTJpK1E5SDd1VW45QTh0?=
 =?utf-8?B?L2NETGsxcVZkWkxxdSswaGUzQkVsK1V4by9nOE83V0NKdU93aWgzOXFJQjFI?=
 =?utf-8?B?S1JqNTdjd3RMTGlRQ3Q5ZFpMbVVqcDV2YVdHdkVUU1lEQmgyWVhGRTVtZndt?=
 =?utf-8?B?VmhiM3ZpYndBYjZUT01DdU5hcjhMQWxXb091ZnJsT252QVJRTS94UmVTL3hZ?=
 =?utf-8?B?UTJMUnpCS2JQeFBUbGFKU0phSThSakFoZUN6MUp0KzJSb1hvQXI4TWRySUdr?=
 =?utf-8?B?aEpJMW5Mc2ZzbitMQ3RrRVcvYmpxQUlpSjZ4dVVmYjhTaTJJRXd4aHZmODRz?=
 =?utf-8?B?TnhKd2R5RTkyOE81ejZINEZqcXlwc01zRlZEN0hyQ3FzWVlaV2JjQ3Z3dTc5?=
 =?utf-8?B?V1FRd1J3QXRzVmR6dHlidTFQU0hvTHJENlhLKzZ6MDRWK2xYblVuclRvOVlu?=
 =?utf-8?B?QklvRXpKQWo4ZitPbW04dnpUeWtWVVpxN0VBZGRMMDNrNXFaMkZqTXIweDlr?=
 =?utf-8?B?aDZBOHNWUGdOdktvcmlySUNzZ2NYVWhvdkpqU01Edkt4QnhrRCtIUWtPNEZZ?=
 =?utf-8?B?WU1yVGtLd3I5R3NjU09CUC9zeGMreTlvOFEwbjdXdkFyck4rd2hvTnNodnYz?=
 =?utf-8?B?MjNYWGJXZWVzQ0w1Z0Z2UzFnZWRLSi8rSnZiZ2JzZm9PVWxjeXQ5VDRwenN2?=
 =?utf-8?B?cmVYY0xzSmlZalhTU05OTlNnS3RhVzJ6OU4zYm5nTFpzMFZVZU93b2NkNW82?=
 =?utf-8?B?MElWRFkvNlc2dmw4WGMra3lMQ0plRXlsaEFyd0NnVGZqMTlJd0Rsb25oc3Fm?=
 =?utf-8?B?cTBrbUprUG51WVc1Qm85OW5oOVI0OXF3WXJUamdicHhZWDZVS2Y1OHZnZElp?=
 =?utf-8?B?VXkrMzJzb2ordHZiVU9xS05CM0JrbUI3UGVDNFlJby9reG41c1AvOCt3b3hs?=
 =?utf-8?B?VDhDSk9zTFBocGFhaytGQWwyc1M2QTlJVEttVlpyTGRkS2xPMXZlWWdUNFlu?=
 =?utf-8?B?bTVwbDMvRXc5K2ZIZjNvNnRlZWJubDJ6UWxreDFka3VpaGNmeFZOeGN1TTc5?=
 =?utf-8?B?WlBIWXAzeVBHdUU5cURRekdnQVEraFRYU2dBUjhkY2RneTRtcFd5anducStD?=
 =?utf-8?B?cmJiK0NtQnpIVEIwM1orSkpwSjJrQWVVUmNFR0tRSXEzcHBsOEg4dm5sMWVK?=
 =?utf-8?B?VGo1OW5kRlVMTUF2ZzZDeDNlWmNMNDRiWmgvOFlPNGdRWk1PVG5NTVZzdHVL?=
 =?utf-8?B?dTVtTlM4WmRzUHhsU2YzRHhYNjE3ZkNiamg5dml4OXRiSGFRZXFyQWVWRnBL?=
 =?utf-8?B?MUpwdjJjR3AvMnNSWDlWbDFoUVVROE9Cc3VseEt4cTVnYitMK2xMVjMwaEhm?=
 =?utf-8?B?Tllnc1NmaVVuOVphSzZMcnNpSkRaUXdMYXJlb0o0RUJITDZRc1VBWTJDSU81?=
 =?utf-8?B?U281Qnh2SXdUdzR1ZHdIMEhFa0c0aXBielBIbEZXWE43Yjc1d3l2N2EzeWtx?=
 =?utf-8?B?RFdCeTcvN2tGcDdsMHlDYUZGOVZKSHNmQ2xtV2FkZExhTGd3NGJkNlIzWFhD?=
 =?utf-8?Q?oWN7PM89K7vVsR6xsVea7Vm49d39YE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(7416014)(376014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1ZBZ1VzMDdQbEZIbTVBc3ptYU0wcGt1eXcxVlgvTDEyLzlSdUpBNVNvR1kv?=
 =?utf-8?B?YnFrU1VTeG0wc1FVeVZCSWhRK2RSNS80aEdVNFB5OWlsaThBTHBRdzdCamxR?=
 =?utf-8?B?OG5IVlBHcEdyNUdaVGF0MzdxQUFkZHE4eGV6Y0krMW5Fc1JQZWFncEVlNkZB?=
 =?utf-8?B?YVQvUTN0NDRORXpLblJXbEhQalMxYkRaTU52UHhVd0NNNlhxRzJNUjk0djBw?=
 =?utf-8?B?NDlSa1Q5SHZsejU1ZW5MeGFhZkhlanFPYVhSV3hxMzJQaHNWY25CSURmbTUw?=
 =?utf-8?B?SzllS0RYVFNsT2tWOFhrY25PbW1zckVHMllaYllmSnFGSy81aStkS29sVXdi?=
 =?utf-8?B?ZVBpeVhGOUVZT3JWWFRKNGRHNldkWnZzVHBaS1A4T1F4QVpLMHlraFZUbFVX?=
 =?utf-8?B?S2EwN1Z5MTZzc042ZERlZGgyQkE3OE9ITnhBdlV5aFZnVzBsK3UrVGZuVG9z?=
 =?utf-8?B?UGUyTXRCWjkvamxmMmFTL3p3YmF5cWtUUmxERk44N3BkeXBJRVVkZm9FRkRE?=
 =?utf-8?B?Ui9IV1I2Rzlha2NVQnNvQlUyanZFaXhjS0U2b0RyaXgyMW8xRWxKTmZzWHNM?=
 =?utf-8?B?a2tzaTlMQkpoVzNjeWUvVVM1RjExNXBLVWJ5ZjdUZHZFa0RkOWFCNmRuUndY?=
 =?utf-8?B?OSswVVBKc05EOE1QUCtjREZETjlMNUNoUy9xQkc1VTNUWTU4TjltcFdVaXk2?=
 =?utf-8?B?UmFYTUJpejdQblhvcVpSd1AwY1BtY0hXNE9WVWFsekZpMG1jYzJNMmFnTlI3?=
 =?utf-8?B?REdkLzNjTmMvNUFKTWxISEdIR0R0RWRzdjNVeWFkZklyK0Jaem5ZckV2ZFRD?=
 =?utf-8?B?cTZPQ1MxZWljMFRHT0JXaU5PdjVOU2dMemlUaENwc2ZtQ05WVFpLMFFnNUFX?=
 =?utf-8?B?aWFzYStSNFRBeHdBUGNoaHVmWWkzVkUxVEhhdUdFOFlSUTBScnhhZlh2eVFP?=
 =?utf-8?B?aEhLRDRINll6cDZ2Y3J4N0VRUTgwejN1NnJyQkE0bUszU0hhNVFCR1E3WmNB?=
 =?utf-8?B?ZzJXUjZvT2VicmkrT0Jua2hPaHF0YWJheDNlbWh4Z0t6S1BpRmZ4SVlkbzkw?=
 =?utf-8?B?bWhLNEprR201ZTRpd0FLTUxIYjUrKzladFliL2k2TjFsV2l3azJueFVVNlp1?=
 =?utf-8?B?RFdJRHZSYWxtNDJuQTgvalVjVGpRT2MzVXYzVE5Yek5IZFBNUGt1Y0RZWlRv?=
 =?utf-8?B?OXV6Q1dXZDR5dmdhMXN4SHJXbDJHQkg1VVhFWXhseGNrSUNRQTFDdG9mYnFo?=
 =?utf-8?B?REtXVjc0K2pqanNKbXBRTHV0R0pLK3llVHFCd2psV0QwM3l5ZTNNWnFJQkd0?=
 =?utf-8?B?ajZZT0tGWGtjVE1KalE5MVBBWmhTbTRZZm8zNUdaNUhkTW5hNmhXTXBvam9v?=
 =?utf-8?B?SlpDRmdRZ0NBZUZ1K0FrK2JpVVoyY2tZY2ZidjdtdklCQjl3eFpEbHNhdTlL?=
 =?utf-8?B?VDZIR2ZjcllydExrYmhHbHdCSFRUSnBZQ3M4T2pZbkZ5TmtqWDhYRUpwekhP?=
 =?utf-8?B?YUZSN0pUemloR3gxS2JZbUFKQXZJUWpWSEpwbkcvTnNnM3BSTlJ3ZVRjV094?=
 =?utf-8?B?dmlvcnl4ZWlMWFRCaEl0WDBTWjZ4S1dHc1RSNmI3eWR6WFU2WVJ4SVZaUGU2?=
 =?utf-8?B?UXF3Vm0vMUpkZjJWVTRGZnZpYWlNSVkrVlptQU9lMjRzRkZyckQ3VEcrUUZ0?=
 =?utf-8?B?amdRR09HdUx1UG5qdHIyN2ZXU2lqQ3k0NlJoT3B5MGlkY3dzN1ZZQ3UzQXo1?=
 =?utf-8?B?NGZKdWpZYkxQR0MvVXdSWWVxMlRlSUNaRFc2Tk1yUklmV1liaVlpNCtDeWNR?=
 =?utf-8?B?YnBicGIwUFRUUVdXSTIyRHFXVC9lcXA2N3NTcWNnN043eFNLbDExOTVBQlla?=
 =?utf-8?B?bjRPNENmQWN2SktWbWNBOVlhcEhMelFROGV6V0xyYlJYa0ttd0tHWXZnaHVv?=
 =?utf-8?B?VFVpcGVqUW93Zzl0T3JOZGtYTTRuZndobW1JVkVETzRnSlVsbDZlS0N3elZN?=
 =?utf-8?B?SERLbllJY2J5bXdaSldQUGVFTlhWRjllODJOclB5d0V3Wll1bzNPdFlpVTJG?=
 =?utf-8?B?dWplRGp0YTB2OG5jM0hzMzZWQ0IrYVhtUEZnUjhHMGZMZmVCMlhQL3A0UWs3?=
 =?utf-8?B?bHBvZXZCN1Y4SExuNEhPUE5TY2M5aU1UUzVhdUY5YlMvbGhJcjYxczY2K2ZT?=
 =?utf-8?Q?/8BO5mTKjFd2Bx/WYHgMIOtBTnTnwuWxEGDh5EkrU/oK?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b14857d4-ddb1-483e-7158-08ddcdedd455
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2025 15:45:50.9543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O3klDInVQbmU8cgEPJVINTmY49sk5cWCsYRom0USABXtkEpwj6Z+ZRPhM+8S5jSBlgzjXtABIROVLStWUkV5OddAJ/aDvNbJcMnr8A6xZAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6319
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBKdWx5IDI1LCAyMDI1IDEyOjQzIEFN
DQo+IFRvOiBSZXNoZXRvdmEsIEVsZW5hIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPjsgSGFu
c2VuLCBEYXZlDQo+IDxkYXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IENjOiBzZWFuamNAZ29vZ2xl
LmNvbTsgbGludXgtc2d4QHZnZXIua2VybmVsLm9yZzsgU2NhcmxhdGEsIFZpbmNlbnQgUg0KPiA8
dmluY2VudC5yLnNjYXJsYXRhQGludGVsLmNvbT47IHg4NkBrZXJuZWwub3JnOyBqYXJra29Aa2Vy
bmVsLm9yZzsNCj4gQW5uYXB1cnZlLCBWaXNoYWwgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT47IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IE1hbGxpY2ssIEFzaXQgSyA8YXNpdC5rLm1h
bGxpY2tAaW50ZWwuY29tPjsgQWt0YXMsIEVyZGVtDQo+IDxlcmRlbWFrdGFzQGdvb2dsZS5jb20+
OyBDYWksIENob25nIDxjaG9uZ2NAZ29vZ2xlLmNvbT47IEJvbmRhcmV2c2thLA0KPiBOYXRhbGlp
YSA8Ym9uZGFybkBnb29nbGUuY29tPjsgbWluZ29Aa2VybmVsLm9yZzsgUmF5bm9yLCBTY290dA0K
PiA8c2NvdHQucmF5bm9yQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2OSA2LzZd
IHg4Ni9zZ3g6IEVuYWJsZSBhdXRvbWF0aWMgU1ZOIHVwZGF0ZXMgZm9yIFNHWA0KPiBlbmNsYXZl
cw0KPiANCj4gT24gVGh1LCAyMDI1LTA3LTI0IGF0IDIxOjE0ICswMDAwLCBIdWFuZywgS2FpIHdy
b3RlOg0KPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEF0dGVtcHQgdG8gZXhl
Y3V0ZSBFTkNMU1tFVVBEQVRFU1ZOXSBldmVyeSB0aW1lIHRoZSBmaXJzdCBmaWxlDQo+IGRlc2Ny
aXB0b3INCj4gPiA+ID4gPiBpcyBvYnRhaW5lZCB2aWEgc2d4Xyh2ZXBjXylvcGVuKCkuIEluIHRo
ZSBtb3N0IGNvbW1vbiBjYXNlIHRoZQ0KPiBtaWNyb2NvZGUNCj4gPiA+ID4gPiBTVk4gaXMgYWxy
ZWFkeSB1cC10by1kYXRlLCBhbmQgdGhlIG9wZXJhdGlvbiBzdWNjZWVkcyB3aXRob3V0IHVwZGF0
aW5nDQo+IFNWTi4NCj4gPiA+ID4NCj4gPiA+ID4gKFNvcnJ5IEkgZm9yZ290IHRvIHNheSB0aGlz
IGluIHRoZSBwcmV2aW91cyB2ZXJzaW9ucyk6DQo+ID4gPiA+DQo+ID4gPiA+IElmIEkgcmVhZCB0
aGUgcHNldWRvIGNvZGUgY29ycmVjdGx5LCB3aGVuIHRoZSBTVk4gaXMgYWxyZWFkeSB1cC10by1k
YXRlLA0KPiA+ID4gPiB0aGUgRVVQREFURVNWTiBkb2Vzbid0IHVwZGF0ZSBTVk4gYnV0IGl0IHJl
LWdlbmVyYXRlcyBjcnlwdG8gYXNzZXRzDQo+ID4gPiA+IGFueXdheS4NCj4gPiA+ID4NCj4gPiA+
ID4gVGhpcyBpcyBubyBoYXJtIHBlciB0aGUgcHNldWRvIGNvZGUsIHNpbmNlIHRoZSAiY3J5cHRv
IGFzc2V0cyIgaXMgYWN0dWFsbHkNCj4gPiA+ID4gdGhlIENSX0JBU0VfS0VZIHdoaWNoIGlzIG9u
bHkgdXNlZCBieSBFV0IvRUxEVSBmbG93IHBlciB0aGUgU0RNLg0KPiA+ID4gPg0KPiA+ID4gPiBJ
biBvdGhlciB3b3JkcywgaXQgZG9lc24ndCBpbXBhY3Qgb3RoZXIgZW5jbGF2ZSB2aXNpYmxlIGtl
eXMgKHRob3NlIGZyb20NCj4gPiA+ID4gRUdFVEtFWSkgc3VjaCBhcyBzZWFsaW5nIGtleS4NCj4g
PiA+ID4NCj4gPiA+ID4gSSB0aGluayB0aGlzIGlzIGltcG9ydGFudC4gIEJlY2F1c2UgaWYgZW5j
bGF2ZSB2aXNpYmxlIGtleXMgc3VjaCBhcw0KPiA+ID4gPiBzZWFsaW5nIGtleSBhcmUgbG9zdCBv
biBFVVBEQVRFU1ZOIHdoZW4gU1ZOIGlzIGFscmVhZHkgdXAtdG8tZGF0ZQ0KPiAod2hpY2gNCj4g
PiA+ID4gaXMgdGhlIG1vc3QgY29tbW9uIGNhc2UpLCBpdCB3aWxsIGJyaW5nIHNpZ25pZmljYW50
IHZpc2libGUgaW1wYWN0IHRvDQo+ID4gPiA+IGVuY2xhdmUuICBFLmcuLCBvbmUgZW5jbGF2ZSBj
b3VsZCBmaW5kIGl0cyBzZWNyZXQgZW5jcnlwdGVkIGJ5IHNlYWxpbmcga2V5DQo+ID4gPiA+IGNv
dWxkIG5ldmVyIGJlIHJldHJpZXZlZCBhZnRlciBpdCByZXN0YXJ0cy4NCj4gPiA+ID4NCj4gPiA+
ID4gQXNzdW1pbmcgSSBkaWRuJ3QgbWlzcyBhbnl0aGluZywgY2FuIHdlIGFsc28gbWVudGlvbiB0
aGlzIGluIHRoZQ0KPiA+ID4gPiBjaGFuZ2Vsb2c/DQo+ID4gPg0KPiA+ID4gWWVzLCB5b3UgYXJl
IHJpZ2h0LCBhbnl0aGluZyBsaWtlIGFib3ZlIGJlaGF2aW91ciB3b3VsZCBiZSBhIG5pZ2h0bWFy
ZQ0KPiA+ID4gaW4gcHJhY3RpY2UuIFNvIHdvdWxkIHNtdGggbGlrZSB0aGlzIHdvcmsgYXMgYW4g
YWRkaXRpb25hbCB0ZXh0Og0KPiA+ID4NCj4gPiA+ICJOb3RlIHRoYXQgaW4gY2FzZXMgd2hlbiBT
Vk4gaXMgYWxyZWFkeSB1cC10by1kYXRlIGFuZCBFVVBEQVRFU1ZODQo+ID4gPiBpcyBleGVjdXRl
ZCwgaXQgZG9lcyBub3QgYWZmZWN0IGVuY2xhdmVzJyB2aXNpYmxlIGtleXMgb2J0YWluZWQgdmlh
IEVHRVRLRVkNCj4gPiA+IGluc3RydWN0aW9uLiINCj4gPiA+DQo+ID4gPiA/DQo+ID4gPg0KPiA+
DQo+ID4gWWVzIHdvcmtzIGZvciBtZS4gIFRoYW5rcy4NCj4gDQo+IFNpZGUgdG9waWMsIGp1c3Qg
b3V0IG9mIGN1cmlvc2l0eSwgZG8geW91IGtub3cgd2h5IEludGVsIGRlY2lkZWQgdG8gcmUtDQo+
IGdlbmVyYXRlIENSX0JBU0VfS0VZIGV2ZW4gU1ZOIGlzIGZvdW5kIHRvIGJlIHVwLXRvLWRhdGU/
DQoNClRoaXMgZGVzaWduIHByZS1kYXRlcyBtZSwgYnV0IGFzIGZhciBhcyBJIHVuZGVyc3RhbmQg
aXQgd2FzIGR1ZSB0byBzb21lDQppbnRlcm5hbCBkZXNpZ24gY29uc3RyYWludHMgcHJlc2VudCBp
biBJY2UgTGFrZSBTZXJ2ZXIsIHdoZXJlIHRoaXMgd2FzDQpmaXJzdCBpbnRyb2R1Y2VkLg0KDQpC
ZXN0IFJlZ2FyZHMsDQpFbGVuYS4NCg==
