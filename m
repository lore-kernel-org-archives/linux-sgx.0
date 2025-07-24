Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AF62D12E0;
	Thu, 24 Jul 2025 12:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753360844; cv=fail; b=poBEVch2OVouapcGg+JxTyEssd3Csoh+BD46ztDp8RECCFJeEjizZZ6Sr694hq8O4e4jGD5Z5JXdK+zkbevobWfpwUIWSW+XIEFsgiG+SwTGdb2hhhBBvpuUFfUrpa5eQEuIlmZSDJs9nDqozv6ABmSg8des+M2fJ/KKivM5PRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753360844; c=relaxed/simple;
	bh=fsWqe5LbXdBfEXVnusio05nf9zwtmRAQmiKYCyzQV1I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d+dfZYjqLTc4EYWh4FCYCjGptN4ixeV3LEeuUD+VOZQkw4zsLRrUx/s47Di/EDKZ4EuWDH+Wrb7QeHARbs0blmDG++SQhTjFF+efNPZExw3rM0DhQfMYyBGGo8iju1mi4oRHG6tJDGbVafPzptsnliFwsvFmipUkYJsxwIq+HhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HqzAt64X; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HqzAt64X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753360843; x=1784896843;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fsWqe5LbXdBfEXVnusio05nf9zwtmRAQmiKYCyzQV1I=;
  b=HqzAt64XcdT4RTeyL6s+FZ3/cqyeyEmZpQTec+MZIw2n3jEOH/1cyrGU
   ImpObdadFJh4ZeTdBD+RoqZ2gHr19aZuZQD5RErHug8Nd99+4gGVjle1c
   oxfnJK05Xh0K3FXgo2NuqFgU0zXkyaqrwsa2OzrU66Mhv0sOERYskvy0P
   rKrRtEnKPatZBi1E6cCE2+lF6RS1QVzz96YFBzEndr6nc/Ly5RJswdCcG
   MHqaYGS5LPkSsMlIj7PPZrEQt4HUC09eWJzji4+yYO6GHLKw1A3aTlRTm
   kO9LP3YeVj/cbfQf7TIqv99KvIvxlTlbZbRnRizpj7hGb4xMWuvz6pVUo
   g==;
X-CSE-ConnectionGUID: 78PtM3YeQzKvSGEO/o/qNA==
X-CSE-MsgGUID: JRtXMpjRTGq2ktljozMyAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55611604"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="55611604"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:40:43 -0700
X-CSE-ConnectionGUID: FSjgy0PVRdySUGa8zzMPLA==
X-CSE-MsgGUID: R7K7NYz0Q+OZGwt8HfTVhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="197341996"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:40:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 05:40:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 05:40:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 05:40:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dcDIS7fpAGzq7FtGVhndQLHg3X59WeyeAYNrENxw0CgDKRVmdnxQxhludXhcjMs1fmD6rl8nVe383ZK4b3XqVGN+eO8aBYqZo4uaJLN13eq/foZwQGxUNxdy6gBvTjLGWOeywjdVMzJ9b11mZE9AaVbc+O3PVwTrZYRuf1G6zFkUOWN5E21i2fmDa9dZV9yFk9gVL54FP6Vb9OHh2F2a/a16RUbAuMbiRhFHVizStHWUncrc1tEWSvIKIs11bztX1XbeDsKURoBxSMvAcUcjqkuXyKI5T9VkcapaYb3VtLqi6GHHS6K+Qu3tdSPUDR/2vt7q2rAFIMA0/IKn0e7dEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsWqe5LbXdBfEXVnusio05nf9zwtmRAQmiKYCyzQV1I=;
 b=rFi3zfaRBSi/JT7Mqy4Xq6zUIcctXSug2eAnQQl40Mw8/m/drlY5TRrzps11FUGT1CLuVlFHRMnEcyu9CvOUVtS2p/Eje2vL+qL0+QvHlYsqu/NkT+ao6WOg6kmEj8WWvZLIib7GQwcWUmk6cMB99LlGqftzaFBJFC3BccQ2Y8L11supQaoETTRhYCTtjaMKe5+VFaPSuz2gJTVxllMgDH/T6b9dZTpeEJpSQhcatGaD77dpbeNaM+Z6SgDnHJQe5ci9bcu4p188iSeVn3h3rlonxCgXyR2IWzOk0CeymYYR618Is3nD4AFL0qMfWUJlh8i0SiyUxNy8qWBY6/9kgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 IA1PR11MB7319.namprd11.prod.outlook.com (2603:10b6:208:425::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.30; Thu, 24 Jul 2025 12:40:25 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8901.030; Thu, 24 Jul 2025
 12:40:25 +0000
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
Subject: RE: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHb/HGKXf61+ezBWECHdPwVOqpZB7RBD7AAgAAnX0A=
Date: Thu, 24 Jul 2025 12:40:25 +0000
Message-ID: <DM8PR11MB5750A23F16C7F94816C0411CE75EA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
	 <20250724080313.605676-7-elena.reshetova@intel.com>
 <de38822919d93dd5074becc707d616022fad03c2.camel@intel.com>
In-Reply-To: <de38822919d93dd5074becc707d616022fad03c2.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|IA1PR11MB7319:EE_
x-ms-office365-filtering-correlation-id: 47f92427-7c2d-423d-55b3-08ddcaaf4347
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VGlUVlJMVXZzZ2g0UGlnSlVFdVJDWDBhaHlkbXlXZ3hoVGx6WVEvTTVYR2l0?=
 =?utf-8?B?a0ZJbEROQ1BvTDVpSTF1N3R2dXV4ZlFHWThKWHZYaDB0anB3RCt2OUFjRDdG?=
 =?utf-8?B?aC8yd2JlSUY0K0FLbnA2czFqMmZvNElvVHNhU1E2QzhxNml3d1lNVVdpZ293?=
 =?utf-8?B?TFJSa3BCdWloS0MzRFJCRkVGTzZNMlNQYUNNa0tlQWVoT3dLS0JmblRnYWdw?=
 =?utf-8?B?R0RuTzVaRy9RN3NRVGFPakFPZCtKZGl1SjVRTGk2V3oxbE0vNitZVUpUWHpU?=
 =?utf-8?B?OXlwSTlsVFRjdHV2aDUvK044MWljMnhGRjI1aEdEL1ZzYVk0OW5qVzg5Q1V5?=
 =?utf-8?B?bkNYRFFka3FVQzVOaHc1VHJDV1VkaTRnQ2tLNWhxRHIwNkIzQ0lGdEErZGNU?=
 =?utf-8?B?Q2h0Q3B5OHVJWWp6M21XcUxDM2VrMmF0L2NOUVJYdHZOWnhwS2ZLYkxrN2pm?=
 =?utf-8?B?bjZSRUNxV2xaTGc5YkoyVW1BU1U0VG96Rjk5UGx3RmFoWGtQUlM1TnQrUHd3?=
 =?utf-8?B?alU5TVZvdmdmeWpXY3pIMUlaa2VVMXJiZk01Q2YzRlhJb29hc21iS09Gb1NH?=
 =?utf-8?B?eE42eVUrNUpIY2xyekthVCtFcnJFS284UmJjVVNVcjUxSUx1U1ZOZUFLWmVK?=
 =?utf-8?B?SXBKcDR6Y3g3a0dVZHhJVXcwWUVSY2hzTXhORjR0ckovSEVBY0hWOXVpRVVF?=
 =?utf-8?B?UWt2R2dkejNncSswUkdNTlBwTkVhd01OVEpoVmN5bXVlQ3ZDdVlacFQ3cGdB?=
 =?utf-8?B?U0RHRHJKTmxHaVFib3RzejBhZ3FzK05TcEtuL1FGRUNFTFZxcFArUXMxNnlX?=
 =?utf-8?B?eVZSc2w4aVV4anh0R2Z2NnZ0TnMrTGRQSTgwaW1EL2prd3dJTmNFZ2hmWXdo?=
 =?utf-8?B?dnNBUHlDVG1ZRzhneVV2UDRGb084V2FIWXJTUnlNQ09kaXh0SkpOUElJc2xO?=
 =?utf-8?B?YlRiMHZ0VHRPOUpUNGI4Q2lMdzBZdExJYTAwNW5SUzR1Zk82em5CMlRBSnFv?=
 =?utf-8?B?aGVXc2F5STIvSkExUWRsL28vS2NjYytyNEFHQnhSWmJubHRXZkRzZzNvYkJN?=
 =?utf-8?B?Z2JneXRmWkJhZVI4alZFTDRNdU03UmIva1ZGa290OE1EOFR3SXFnZlZrZ3RS?=
 =?utf-8?B?dUdTV0kvVHRPYzRxWWUvaFBJVEhQQVRoMTVlY2Q1Tko0Znp0SzVZQ0Y5Q1o2?=
 =?utf-8?B?aXh6WjFIbGhwL0hiUlI3WlNvWkpaNklKRGRBemFSVVpLR0RjY1RXMFBwcnNX?=
 =?utf-8?B?R28vamZFY20wSU83UmtVK2g2N0Z3RVAxc1pWeEZ6QlJrNnFrT0pST0FUN0FC?=
 =?utf-8?B?aUhib25xTjZQL0VVMTA2YzA1RCt1bVllaktaOFVBZ2RidUIzZjhCUVJycEEx?=
 =?utf-8?B?eWlKTmtCK1hhaXNnUkg0MndGWU04TnlJd1ZrM2FkcnZGaXQ5eFNDbUJqTE9n?=
 =?utf-8?B?QXowUXFhaGVpUE4yNm1VSkVhaVVlK1pQZlY2amQ3Q0lmNVFNckhXSUNuRS9n?=
 =?utf-8?B?aUFBbG1RMlkxM25sc1lrNEZ2Y21zcjFWNGV4eUJub1BCMzBGL1ZOZUt6RFY5?=
 =?utf-8?B?emxvZWZhR24zOW9zYzJWUmRmVVhWak9DemlyZ0JCeE82L1BuTzYyRFBIWTNW?=
 =?utf-8?B?a3Nzak55Rk5lTjJxeFpwOGZ6QlVhVWd3ekpVRVA3YWo5aFp5ZzBMM01IdHo3?=
 =?utf-8?B?UFhIRm9ROVIvdU8xcGFYQmx5cytCTUs4Y3kwTktKZXpCRTJPK290ZjRSUm41?=
 =?utf-8?B?ZklWNU5YNHh4SEV6T0p0SnlpMVpnZ0hJWUMwbXFTT0VtODFuSEdNOFI2bG1k?=
 =?utf-8?B?QzM4SmQwY0lEVkpxQ1FyY0FadVBvUGcyOVpMRXRYcDUzek5pKzlIa2VqU3Jk?=
 =?utf-8?B?VFpHV1o4Zk5EY0srZk1WeVlLcHBNVnZIVE1ZdWR6VzZGT256ZHBrQndkd3hu?=
 =?utf-8?B?eWVrUzg5THBXVnBLbmg1bjN5V2MxMThCa1U3QVdYYVM1UEFUNFNDTFZraXgw?=
 =?utf-8?Q?z0wJGJnc/vWWYCMkw7J4e0SAHxtctg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWxKNjNDWmR5WHZWQ0FGTjNVRHFNdExlZm00U0Z3K0xIOEwxNFFPUWU0T3Bl?=
 =?utf-8?B?eERLUGJlZWNablRWcVE1emxidEVvZElWYlFCVkowT0tkZ2EyZjR1dFhta3Ro?=
 =?utf-8?B?WGt6bW5yOE11c1VFYVJ3ZkNXKytROUVHQy85SmVsbWVrQk1ZV1R3OStuZ0Fr?=
 =?utf-8?B?U3VrQWxUSDNKYVk0T0grVGx1ckltcEgzNlV1TTZ5SVp6QUcwS1lTVm96cW5Y?=
 =?utf-8?B?V0grYThldWZyT1IyYWlNaDZQcXQ5b2NvYkV2djNlOXJrRWhZcXNZWjRUeU9r?=
 =?utf-8?B?MlRzcEZ5ZFN5aFpOcmI5cDJFelhoemVleXJXNm55YytoeVFINis2UGMxNWts?=
 =?utf-8?B?ejAxK0VrNXh0MThHaDFaTTFXbGFIbVUrNFFXbXN6WU1ySTA2RFM3bzh5Rkhl?=
 =?utf-8?B?ZzVoTExlK241clNXRXpOMjJjaTVPMWhKS1RhNEJ0MEsva0pzclM0Q0ZObi9I?=
 =?utf-8?B?KzZ2UlFzU3ZOb0c1SjdnNkx6WDB6Vy92QTZ0TlkxWC9INlpPdW5TclpwT1Bm?=
 =?utf-8?B?MmtxYkV2KzBYbHFoL2JVczZFSnVEaUNOc21wMUhySXlEZzZEQzVPNWx5dDcy?=
 =?utf-8?B?ODQ1bU9KK2V2MGdoUllGOFp4TDJUNjZYU0ptcSt6Z1ZCeUI0VDFVSnRuNkY2?=
 =?utf-8?B?eUZRd2hMSHkyZVF4TWZvUEE1L3ZkbFlNUnVkVmQvcnJ5NlVBTk50V0JNLzQ5?=
 =?utf-8?B?U1RXaHNNOUR5L2lLbko1Q3piT0YwdXlxMnBSTytwSGdTbDdyL1FOcUtCZ1dt?=
 =?utf-8?B?aC9tTElWZlBMSHFTeFJ6cXJpRGVmZlp0SjNoc0hSeE4wTmVkMzJzN0w3Tkp1?=
 =?utf-8?B?cDAyenZBRkZGWW4vSFRtcTBYZ2N3QUFQTC9tQjAzQ2FLSUtNV3YzclFZamZM?=
 =?utf-8?B?SFJZajVkbnNmK0ZQOU1EemxuMmZPN2RHdlZwem93MGtTWlh2dzQxaHVRWnpZ?=
 =?utf-8?B?NE9uaDRQZ3dPQ243TmEwNnJNUEkwMUpaS2VGNTh5RVRqRlAyWWxRcXNJVmZQ?=
 =?utf-8?B?RDRSbWhMbVZqd1I1YlhERmtsZnFIWWZaNlJ2aDd3YXkzNzFuNlQ2TlY2bzd3?=
 =?utf-8?B?N1dVc3FtOHF0TW43Z05raFYrK2l1ZzR1dmxQbGhseXEvUTNIYUtBSjhkekl0?=
 =?utf-8?B?TjBtb29HTVB4OVVMTjRWK2dCYjN6d0tMOVZzTjNpT25ITDBRZ2o0dHBHT2c5?=
 =?utf-8?B?KzlXZ3FmWkVYSjI2L2pnK2pISkxQcCtrdzVBZEdabm1nVlJFNmgwWmRVd3Vs?=
 =?utf-8?B?RDVTNlk5T01xL0JNSVR0OW5TWnpBVHdoRFg5WXkzZUVwRzYzRzFFdTArQzQr?=
 =?utf-8?B?dHZRTERTNmNMZDJYNHdEcGE5RE9xTWdCakppNEQ3VXFTblNoajM3b2U4b2sz?=
 =?utf-8?B?TU9uUHcyU3BERWFwV1Z6RlM5RStiYjNyUTdaQW5oaXhVUVVtMEswZU5TNVNk?=
 =?utf-8?B?bWM3SXpLSFJ0RGVOdFh6enRETWFRWTNmVGlkWEtEdkVvK2pUMjh6QnFxSE4r?=
 =?utf-8?B?MzFPZXRCOWZYMll5UnhCaGFvQjNwUnFjZzFWRDNSNitSell1bVQyY3VUM0dO?=
 =?utf-8?B?SEdkeTdoQ3pTSEVIWkV0SmVPWDJ3RXZGemJzTDBPNzluTzV2WGo5Y0p2TjQw?=
 =?utf-8?B?eVJvaDJPT2RyQUNpNmo2N3NocmErTDNxV08xUWlGVmpqcUl6a0hLQ0R6SUZP?=
 =?utf-8?B?Z1FRdGlJaGVzdjhEa2JrdEpjczFEOFV3emhCcHZEU1Mzb2UrOUNPYUFqUmUz?=
 =?utf-8?B?NWRHQjUwTUlSWUszenk2RnV1VmRUcW4wSXlidDByUnUvZHBmcURvYVUvdnlQ?=
 =?utf-8?B?UHZSakxocVBucy9uVmxiTFdRemV3b05QTG9aM3dBdGRhTDgzZzJxeWljdzY4?=
 =?utf-8?B?YjI0YWxlK010MDQyVTFYWjB0TGVJL2V0T3pTUGQ4L01FajR2akl4bk42NHRT?=
 =?utf-8?B?SkpIenljVnVtMmYxSGpnRnR1cUxTMVp2RG54UWplckQrWllXYnVQSHhEdmxl?=
 =?utf-8?B?U3FrTEpLc1U4eWN0RXc2dE14M0RLbEs5S25QaUdvaVRBeVhuYmpwN2FzYW1s?=
 =?utf-8?B?NXV6cFBCSUdEVmxZZlcvNjU3QnlaeXNXU2FTTzhCNWNXaFZocjBLV1d1ZjRN?=
 =?utf-8?B?V0lWNzFzTnlUV0doYVpGWXdNUXhEdjBSSWZadmJFVjRJN0pkTDdZSXNWcmNu?=
 =?utf-8?B?Vmc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f92427-7c2d-423d-55b3-08ddcaaf4347
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 12:40:25.2974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oGTgLB4EEBrOYSaEayXKCuPMCKnkbIyGyohHCN5DJHxfgcstKtRTzqy7ILuGPegDSDEqkur8Y117llB9P/nAhab9KtTIvDa+6qpSAMrn7CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7319
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAyNCwgMjAyNSAxOjE4IFBNDQo+
IFRvOiBSZXNoZXRvdmEsIEVsZW5hIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPjsgSGFuc2Vu
LCBEYXZlDQo+IDxkYXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IENjOiBzZWFuamNAZ29vZ2xlLmNv
bTsgbWluZ29Aa2VybmVsLm9yZzsgU2NhcmxhdGEsIFZpbmNlbnQgUg0KPiA8dmluY2VudC5yLnNj
YXJsYXRhQGludGVsLmNvbT47IHg4NkBrZXJuZWwub3JnOyBqYXJra29Aa2VybmVsLm9yZzsNCj4g
QW5uYXB1cnZlLCBWaXNoYWwgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT47IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7DQo+IE1hbGxpY2ssIEFzaXQgSyA8YXNpdC5rLm1hbGxpY2tAaW50ZWwu
Y29tPjsgQWt0YXMsIEVyZGVtDQo+IDxlcmRlbWFrdGFzQGdvb2dsZS5jb20+OyBDYWksIENob25n
IDxjaG9uZ2NAZ29vZ2xlLmNvbT47IEJvbmRhcmV2c2thLA0KPiBOYXRhbGlpYSA8Ym9uZGFybkBn
b29nbGUuY29tPjsgbGludXgtc2d4QHZnZXIua2VybmVsLm9yZzsgUmF5bm9yLCBTY290dA0KPiA8
c2NvdHQucmF5bm9yQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2OSA2LzZdIHg4
Ni9zZ3g6IEVuYWJsZSBhdXRvbWF0aWMgU1ZOIHVwZGF0ZXMgZm9yIFNHWA0KPiBlbmNsYXZlcw0K
PiANCj4gDQo+ID4gIC8qIENvdW50ZXIgdG8gY291bnQgdGhlIGFjdGl2ZSBTR1ggdXNlcnMgKi8N
Cj4gPiAgc3RhdGljIGludCBfX21heWJlX3VudXNlZCBzZ3hfdXNhZ2VfY291bnQ7DQo+IA0KPiBT
ZWVtcyB5b3UgZm9yZ290IHRvIHJlbW92ZSB0aGlzIF9fbWF5YmVfdW51c2VkLg0KDQpZZXMsIHRv
byBtdWNoIHBhdGNoIGd5bW5hc3RpY3MgKCgNCg0KPiANCj4gSSB0aGluayB5b3UgY2FuIGp1c3Qg
aW50cm9kdWNlICdzZ3hfdXNhZ2VfY291bnQnIGluIHRoaXMgcGF0Y2guDQoNCkkgYWdyZWUsIHdv
dWxkIGJlIGVhc2llciB0byByZXZpZXcuDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
