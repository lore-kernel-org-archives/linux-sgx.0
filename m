Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1E54A21;
	Mon, 11 Aug 2025 07:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754896886; cv=fail; b=TWtvmuBJKcR6cLQ7qlvtPSMc8948aKIQEiU7aVrel9eLV7d7bb7YTjUiQb5ctftBGUi4+18LoypO56FLCQxmOChHiZzr8caNnwlemxiqTIEPpz+EOE20S92ooZMwUu9Ozfj+7N7BIBYTs5/IomgjPA0PX6yRqZ+e7rdVROyf64U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754896886; c=relaxed/simple;
	bh=I8GDJ5F+F+W9o7wXjSWndKHmTNYmR6mawCm3Dtcsmhs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YIx/1A2UV5wZMSX1f+f5NLiJeJYWa5huJSOW/0hVv/KynxGq0dUdzW0YPTtpVK9X1YnqSSFZRr8aUAn3tycyC+3XGY/npCi3y0OcxzTDIGFq1mN8pUmixBUM0NJCy6c2JW3BVisU5l+YMz8f1FF0BFpkZY2BBihzFCI2ijsTmpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kIVilKZq; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kIVilKZq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754896885; x=1786432885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I8GDJ5F+F+W9o7wXjSWndKHmTNYmR6mawCm3Dtcsmhs=;
  b=kIVilKZqZll6YuqYOhyMiHtZgEGoPIX2D1z5BkBFixopN7+HjgRkHn/x
   pB2r3gOdieYAy8Rscq7ztNvGduoFlTSlZKz+Z5vJEI/V8u+/3JlYC1old
   wGj8vxm4k+qshwsP/7jT+QYYknpo6bG8vbUCUQtA2XwWpevLtl6cmQMSB
   VMSsjsD3Ssiso8zd3Da94yQfRR5QtFFZqOVvX0zduZk/X1Mc+dupUw5rF
   gRyR/lnRhp3obG8nutnzzCwdOFfCZgKIrMygCr4XDt3vWYB4t0fJY7+mn
   mV23qZyzhR9LrtAdT9Jf49TfLMhkTH/G+j44X5/ezeCVAVhYJswguyrAd
   Q==;
X-CSE-ConnectionGUID: NOQ9ZN7eQfusNdysC8mRFA==
X-CSE-MsgGUID: 3ikU6i5dRl+SOXO9MMZLPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="82583680"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="82583680"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 00:21:25 -0700
X-CSE-ConnectionGUID: p2eY9m3pTfug+uPUfTXvlg==
X-CSE-MsgGUID: 5oAXCAWiRbOqJj/vxXmR2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="170053443"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 00:21:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 00:21:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 00:21:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.62)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 00:21:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VU5d6b9jIga82udpf+H4ENSVPkrdxSkN24EftGD3iYLVHO1lUdCBmyqeJV3oyJGC0ow7Z901MYS4wlwhPAbQgjrrVq7wVhzzSB8u4e1swucsaEXdBXeQdLGuMoIe0XuQd4zjWW8KLzOuLtzfj2/v8m+aMw4gN0AjYeXipULWPv5Dz0D7zaPf4ca+am1Fz9elBuJUBOSZWoB8UhAebzC1iv3bpbVc3OO3ZVi956h5E8+4ebv/4uqZFJosvY/ZyOaTVs0AXiF4G8e1lJbzHZfNJ2/wlIAErukdyU7Mf1uNI/S+J/c3olTSJbXgNOgIjFTZcJuYRAKONWG5Qyg7fugy+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8GDJ5F+F+W9o7wXjSWndKHmTNYmR6mawCm3Dtcsmhs=;
 b=w0XQ2/IwFbJzV/hSdc2QsdQBsOJbOE2UnhrlgA2iDKVZN6d5tq3gpAmCLGxuc42Is88M0TSSsS/TRuZF8RFVn/8+RtRBQRYuUzGQAbtK6yxgzjFNxxg2pyt8DkdI3r7n/R7rg90aTWm1knUX6HMX61pSLTkOt5I9fVlpyH8U62XdRAVNTMKGIAmqIO/XvmtAuxZ6Mcn/1q8hdSoREOqglKfi9qj7thddfrrYZrTFlexI6OqCpSFxxS1likMifsUzOCZ0ZTghrX3kHN5P4hmq/6RithztKkvlLJQ4mkQA74UdqZ3I3ibTgvIMkpaa9o/nzDtlT76o0XBuYM4JQ4Y6vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CY8PR11MB7921.namprd11.prod.outlook.com (2603:10b6:930:7d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.18; Mon, 11 Aug 2025 07:21:16 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 07:21:16 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v11 0/5] Enable automatic SVN updates for SGX enclaves
Thread-Topic: [PATCH v11 0/5] Enable automatic SVN updates for SGX enclaves
Thread-Index: AQHcBqoYu/Z/sCjaXUi+A79+60kMWrRaI4iAgALwFDA=
Date: Mon, 11 Aug 2025 07:21:15 +0000
Message-ID: <DM8PR11MB5750EE0009D46F6CB44845BDE728A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
 <aJci8Zt9iSb3LurZ@kernel.org>
In-Reply-To: <aJci8Zt9iSb3LurZ@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CY8PR11MB7921:EE_
x-ms-office365-filtering-correlation-id: 8d76a879-bb2a-49eb-f43a-08ddd8a7a8d4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TjJidU0zeC80Zlp1Wk5OTVB3ZjJyRFhnb2ZYWWVoNTVjeHBUTkk1S1JmWlpm?=
 =?utf-8?B?NmNnVkRlL2xTVm9pNUpJUCtDQzkrNFVmSEVWai9hbDNSbEVVbkx6T29LaXVh?=
 =?utf-8?B?N2RQNTI3YjRUL0pSc3VCS0ZxUTdhd1M2TVJJZUczNitDV08xTXYzRDJpdDN6?=
 =?utf-8?B?ZFg3Uk1NbHBnWDFDOUtqckJSVWNxMUx4eXFER2RjVzNybHVCMFlseDAvR0Jp?=
 =?utf-8?B?enZSYVpSalE4VkhDbWFtZ09PRUliVDAwVlNsNWNVMmJrWHZsSDVpV045aUZt?=
 =?utf-8?B?UE9Wdng2Z2tRakt3OE9TU1BHNkJlbTVBM2haRDh6THFKNjE2SG9IdWdZL2Uz?=
 =?utf-8?B?ZkxqNmZBRHAwdTI5VmxSRFBrQXNHbWpXbFF2SUJzOXdHMTlXekIyRHVVVTF1?=
 =?utf-8?B?R0VuRzBuSElLUGNsOXhwenowQnZHcHBwRTlFSEhQOU9adnlLbnVMQm51Tkhw?=
 =?utf-8?B?ZEJqM2x2dkRFcGNTQ3NHVW9vdjc5K2xINysvQmlKUithM0gzeFBlRWtRL0dr?=
 =?utf-8?B?TWttamF2Wlg5ai9pVUU1VjhEVXgwSGErNG1zeE5tMzhIK043V0hzN0V2eTdM?=
 =?utf-8?B?a3ovTFN5UHhpcyt5VjBRbHJ4T3JvYktlVFozcUlETTBGWE1XREVyUkg3ZnIx?=
 =?utf-8?B?NGNlWWpqVjlMUjU1Q2p4aVY5eE52bGIyRHpYbHgwaXJnRkMyN3FjV1hRWHgw?=
 =?utf-8?B?cEZpMi9WVEZwQVh2eVE5T2VRY05yamdQbUtqZUpOTGVQNStEMTkyUmczVExX?=
 =?utf-8?B?dC9sMWJPTit5WndZT2tjVFloM0dLMENXNmVlZzkxbFVLU2tOQk9pVXd6cnVT?=
 =?utf-8?B?MUJHNnRzRW5INGM5cnBzTUdCbXdQRFl3NkdONGJLUTZwZ0RMVnhGTmJBWlZ5?=
 =?utf-8?B?OTJjam1nM3BWOWNnNzV2dHdDdWZ1UnJkaEdMQmY2S3NNSXdRNEV5cnlVbWhC?=
 =?utf-8?B?dHlCeFZVMTNOdU1uS2tERVZpeTZGVFZmUndJeHV2YW1yNThIRytLOTJIV29X?=
 =?utf-8?B?TXpCZmlYQWtPczRmamd2NnVFTU1XeFZYRVk5N2plS01hTzR6d1FPRXpNaUhh?=
 =?utf-8?B?RVlKL1BDdmhnVVRsb05LNDRRVWZoSXZEWDBESDNrY0duRDNRemdUL2RSWVly?=
 =?utf-8?B?U0EvNllEdWFHWTFNQTh1TFcxUndtUnc1clpLajBVdnZWVnRYYVNRaHZSMzNR?=
 =?utf-8?B?V0hsT2lxdE5ZYmZaUXNqRVdNbzJmd1ZMYmp6Z2pUSUdqaGdSZFZ5dzlOREZV?=
 =?utf-8?B?TnV3TS8wSFJYT2NsMU55RkZzMVg1TjF6QW1lcXZOYWcrU2c0RG45TTdESktZ?=
 =?utf-8?B?VlA3OUt5a0xtUEdReFRENkI3c1E2dWZTdHlvVVBtVjl2QlAwZ2F1UWRWbDYw?=
 =?utf-8?B?Y1ZPTGU2K1JDSlZLL3BqdGlXdXI3VVRFQ2JUNU5IU2VZVWorYkhERmpLYTIr?=
 =?utf-8?B?NTFnUUwyTktXd0NDbkRWODYrSGFRN1Vrdy8zZVNoUUFEalo3MFhnQ3pZbHlY?=
 =?utf-8?B?eXc1VExMdHNVWkRCRSswNWx5U0FCZnVqVjJzdGpMOEpXQlQzVjIrNWk1KzYv?=
 =?utf-8?B?d09ZTStiNXQyczZyZ0NSZERhV3IxVDhlZXpWbWgxZHJ0TEFHRVgvUisvWUFh?=
 =?utf-8?B?bVhYU0tjVUdRdCtqZUxEeXBkbjFIZGJsWndnMFdhMUNzUk84WmpydVRhQk4y?=
 =?utf-8?B?eXpzVk5LWnhGZjBNNXVydk93dEhGQUo1bHBHNTkydU1mMU5pMTVkSFdqNE1X?=
 =?utf-8?B?bFgwS00wQ2Zqd2JzZjdaTkVuSHo2ZFJSbTllVHhvSlVZRFpSY2dsbTJxb2JM?=
 =?utf-8?B?cjZOZDBneGNwZGwveHZWNkhVL2NKb2g4TDdNN3FYajFabzRiYk1EWnhmbGRQ?=
 =?utf-8?B?QXJscWtCUVV5VDNhb0JTRFRyWEorY2tXVEdYcko4aFhGUTgzbjh4NU5panV0?=
 =?utf-8?B?elpsUmFZanFITmZjZmpXaVJTU2VJSFZyNjcyTEJwaTNhWVV4QTJNUHVDaFVB?=
 =?utf-8?Q?bIbUT5/Go84hm4c0Sz0S3zOmFQpXmE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmJPZE8rYmkxL3hjUEJpNmMybFh3Q0FZMlN2dVFTQ0JXa1pwVkg5c282YTZj?=
 =?utf-8?B?Z2RyVFNDMFhLWjNJYmRJUFhkN2hnYVNhY2haWHVadFhwdjV2dFVkMGFqaGVx?=
 =?utf-8?B?RE9vNXFnZWJVbEoraVNUOW81VmY1QUsxeVBxckZtTnoxNmw5MlFsSTNaYWN3?=
 =?utf-8?B?T0JJU3dzUG5NMC9ucTB1cHAyRHJxOFNUeW1ZMHVJazQrRTB2bnRNdWg0VktQ?=
 =?utf-8?B?UFc1WmptbWRicEZHOVNTQjFMRDRZNVhlRFVrcmFBMFdOUS9nNGd3MUl6em1t?=
 =?utf-8?B?QnBpWGJFTmlWVkVDbjQrd0Z4NzVkL041dHVIVFR4RlNmYVFLNDdCT24wTnd3?=
 =?utf-8?B?ZzNpOVc4dlpZOXh3L29sb0xZcDdIQmFlUmpkelE5b0J3UXdrU0tYODhkeFNi?=
 =?utf-8?B?NUpiejBoSWFLcTVJWThhYkZGZFVQN1RMYjAyQng3Mmo1U3NRV3ZyWnpRREc3?=
 =?utf-8?B?czJSSHFsZDk3dGErQWFYeTA4WEJsbEtmV1ZmZXJEN09FT2F2UjhzbWs2RkJ2?=
 =?utf-8?B?eXc0ZTdiT0RoTEVmb1hJdGZKaURjcnB2T2JPQlREWEpyMW9SU3NSZnRCSVFo?=
 =?utf-8?B?d0xyUlExVVZSL0hOVlYwa3VTaStNM1BveitIVHNXOXZkdE9ERFhIZSttWFRY?=
 =?utf-8?B?M2Vtd2hjU01RR2xEcXBVUkd2M29VVTd1Q2UzemNWWGRJWVlYaisxWTdsemJL?=
 =?utf-8?B?R21haGljU3IxSnYrRzJydXFlQVBlQWtjUENjRXVHWVZHSjZ4ejN0TnM4Y1Yz?=
 =?utf-8?B?ajVDaUJ1ZktVVk01eDVuQ3JKcWFJOWRHZFJTa01ZeW9SMHRkMHp1aDNWZFEy?=
 =?utf-8?B?YVpTNElUa3doL05JaVpPYjZ1UUozaU9XejVUWW1POHlIRzVUSEhtMi9DV2Ir?=
 =?utf-8?B?R3pTTzBhUWdLMFd5M3NPYzBkMllkY1RINGV1QmVuN1NUYmo4cktJODZ5UjVF?=
 =?utf-8?B?WjF5YmZKQm1abE1MTjRFUUVGTkpXYUx5elZRYjZvVTJSWWFGQSt3dTQ5cVdw?=
 =?utf-8?B?Zzl2MUxOK0RING52cnVQMGpsaXFUb1JjTW54TzhKYy80REtmVENaMlBaVUdM?=
 =?utf-8?B?RjlYbk1LYnA2SkViUFl0U2lPREhRMTRWbk9zWDd3Q0hBdlZsWlE1MzJPWTZ0?=
 =?utf-8?B?OTN3eG0xTFdTM29YSHBpWjJ5QVF5UlFaUEpVenFhVXZwd09IL1FJQk9KUng0?=
 =?utf-8?B?L1dPSHNlcEpNNkQvWjhENFB0ejloTjlrdmJVZGxCM1NhaWZNMlJqV0tKVUNJ?=
 =?utf-8?B?YVFueER0T1ZjTm1xZG9IZkRXNDRkODFyMXVGUmtBTHZJVkdaazZxWEs1Zjd4?=
 =?utf-8?B?TWVFbklUdEJyVktlbmxQMmZFZE16NURxbFlTZW44bTYzbTl3SEZKcUhWbVBz?=
 =?utf-8?B?dkp1Zk8wLzlaaVBMWEtyRGE3dW9SRk1vZ1Bjb01DdDV5Q0FvQmVrOEZMR0Ev?=
 =?utf-8?B?RnoyWW1IOEpDaTZ1cU1tYW5taVFhczBibUN1WG9QbVVHYzZJVEFhaUFZbDhE?=
 =?utf-8?B?aXZOSGt6STRVdFFkbjB4cG9UOGUvRGV0R1ljYnJLTGRFaHdzQ1FHeXkzTjl4?=
 =?utf-8?B?dGN5VXBSSGozWkNRMVVGRGsrdnNiUzk3eksrbG5zU2dab2EvblYvZk5OSnNV?=
 =?utf-8?B?MDk2dXFQOFg0S2o3dGRNOGlQYllvbkNjeXc5ZHdETWkraWhvMjNOdm1zemdi?=
 =?utf-8?B?VW5pd2hxcCs4VS8raVRYNEd0d2FhbHdYYVlYQWxON0FKQTZhYXhWdVp4YlRi?=
 =?utf-8?B?TzQyV053RXNMbnBwdjZSb1g0d0RFMG5PSVQ3WWdXWllXeXZ1TzRUZU5RbE52?=
 =?utf-8?B?Q1RUMjlrbkhjNVVoaEEremU1eWlldG5zTlpmekJnckkxQ05MR25xZmRNZGd0?=
 =?utf-8?B?dm50Mk9IdlI0ZnVJNkZ1aUhxYUZ3WTB2blAyN1A5QnY5SzNUNUo2TFhRbkxJ?=
 =?utf-8?B?d3VZNmNMSkFmcFNLbTRRUnBDV2hUMDVDNk9ZNDBwUmYyQXpxZ0xKbnVVNk02?=
 =?utf-8?B?WmtRMnU3L0xDQ2x0SGFiMU14eENJaURvOGs3cUl6bFY1UVQ5aXN0MEVDNjZE?=
 =?utf-8?B?cmsrL09rRFBmODNiMFNER2dyTlJ5T3NFM0hwYXQvSjRxRUNIdDVMQmRqSWoz?=
 =?utf-8?B?ak1jS1A5Tmgra09aSWRSK0JNY2ZveE5Va2dSbi9aaWxmQ0NFTmxwbDVDSmpB?=
 =?utf-8?B?OVE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d76a879-bb2a-49eb-f43a-08ddd8a7a8d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 07:21:16.0128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GvwqGKCRWhbRix46I9P4IOZjqli8ptSGE/HWgvaQFaAvGcp8A+Zq1qLN2ZyzuXnni8SHPs9j5rEnVGcjp0cKDJN3jw9AQSd27qnx7qwBmBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7921
X-OriginatorOrg: intel.com

PiA+DQo+IA0KPiBMR1RNDQo+IA0KPiBSZXZpZXdlZC1ieTogSmFya2tvIFNha2tpbmVuIDxqYXJr
a29Aa2VybmVsLm9yZz4NCj4gDQo+IEJSLCBKYXJra28NCg0KVGhhbmsgeW91IHZlcnkgbXVjaCBm
b3IgeW91ciByZXZpZXcsIEphcmtrbyENCg==
