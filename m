Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88A14F98;
	Thu,  7 Aug 2025 00:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754525704; cv=fail; b=N0T8/1tVmGy+n0b76VzEkn1aLi0B+0Ii1TipfLl4hGLr6x752R6YOlrnl6TKGLBYv45/Kvc5e7bvxKKJTx8ek/rCzmC2iltcy+w0tcEwCYlaAbzV84Cc1l+Ud7PVpiJC/a8EBwkZujcv8A6rtJy2ba6nSKnWylZDx/EoD+CbqcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754525704; c=relaxed/simple;
	bh=p7wYfG6+phs3sW+gQwnzjB1+WyRTydRKv7BA7lWhXI4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ER4w7+7tj0+Wv+eAjPmJy+rHj04qhs4ln6G1DwF3ZwLeYQ71L1qsFlXwjdXJXTYeliNbkEGAhyGfU11vGAL69wtW/3R4Ly6bGAarGeVAqBfyC194MR2ewYU3i7TNbBjwOOuTaSG8LoGmXmeA0aZ8+pInuPob14W01Qw17EJKjJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GExDCyJW; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GExDCyJW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754525702; x=1786061702;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p7wYfG6+phs3sW+gQwnzjB1+WyRTydRKv7BA7lWhXI4=;
  b=GExDCyJWDnB9nd7GxS1svu3MN/eI7VSZS2t/xaqq6GoxvPxaIjrbX/Zc
   VmGNoav5nlbfwTLbDoid856Xq0vJ4xDlt+5cJcJVAJ9HHpXmFsyLzk991
   Uv1QqYRwxHoMiaxSjx0vioswjx9oV4xgehcohUeXqsYBkd7xhX1i/tIhB
   L94QG7opx8bieR605wG+SBRElHWcpkTnZgd5zNJZyblX+J/e4TLqwLBkq
   sk5Ph4K2UnkIpK3wgVOk8dxmmRMh+XK1Uxlz5VA0Qi6gJvwxQIVsT+rN5
   r5xZXtvapov5lgxQo6/nnI24SbK388FRudwI/IGa9daCt33Dum6MzLp0j
   A==;
X-CSE-ConnectionGUID: yOUH8Eq5QjmqSkncdKbKsQ==
X-CSE-MsgGUID: DQexJfbQQaCsBJ+vwdFa7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56748670"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56748670"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 17:15:02 -0700
X-CSE-ConnectionGUID: A6NoouVrTU2VF43/6MwGsQ==
X-CSE-MsgGUID: efw3vypLTxeatbDUNkqyxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="202070768"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 17:15:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 17:15:01 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 6 Aug 2025 17:15:01 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.65) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 17:15:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M0kSMhhJmcknFD40VWZRC1l0eFmTfWOMeNDiHLLJItWU9Es72Uy5321AoqqY0FP/xlPP/9n4p8cUikiltIwnGBOa81T14eGghHtM8E+9HXgHFFaMMNiH3w4uNn1loZ1dv6gKYjCNy1xRg0ZIsBwCUnDqh18dYXtdFq29xh3goWTZGyB5B2MsyGz7SlCv/jl02YV3dsc0/ICJ0BDOfutKQRDegDzANVLN0KOBTjR0AhjjD7s4gdHmIwftWGYZqIguozeQ71H1LBj9G53Aq0ORpAbRuZvuGsLVgv9Ihd7eoKNQtrEaBVbvGZG678oVlo+jdxZVTGTeeAr+jY01ld6Svw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7wYfG6+phs3sW+gQwnzjB1+WyRTydRKv7BA7lWhXI4=;
 b=VpgNX1Q4HWhxS0yqmK/LQPGmAmyUbg/EgtC9cDBIh1B3FKPm932qjgDrCL2yUy/tFM905t3mr/LanbtceVrwvRvSfIRHivd5NFBgjg4JIqhwOcVV39XOK2MAyHlz7s+OGk6YuH56CrtNYYluwEEeNyJYQl/sM7i+eEPTrUduk5p8pF0cUFIu9YvBJZrgwn+QvvtbAR8iKBDzc1w+7vsaOzamUPBhSb/bzaq4PE4CGVdRzVIDJL8FP0yg/FMWbYn4nUhGthUohciy1MHOUSNkXVSaiN64Xl/Cuy4KFDKEL3RuHpwQR1dy1Ibm8MdiEqhxq3Ek2bfpdWt1Kp6o+ta3FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6675.namprd11.prod.outlook.com (2603:10b6:510:1ad::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Thu, 7 Aug
 2025 00:14:58 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8989.017; Thu, 7 Aug 2025
 00:14:58 +0000
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
Subject: Re: [PATCH v11 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v11 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHcBqop4njn8s1W90GYZRAV67hftbRWU0QA
Date: Thu, 7 Aug 2025 00:14:58 +0000
Message-ID: <010d5bdbbeabbb37f822e30a2451df7feedf051e.camel@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-5-elena.reshetova@intel.com>
In-Reply-To: <20250806081344.404004-5-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6675:EE_
x-ms-office365-filtering-correlation-id: 6eadcb4e-71db-4f6e-6fb5-08ddd54771e8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZkRvV2FJQXNLU3BMNnZVRU5EcDlBYVZPMnhkYkxRSnBMMnhRRzUyRUZ5OW1s?=
 =?utf-8?B?VHVXYXRlazZvTHpiS3BYb1BWSEJMdDNITUxrSVlZaU9IeTJWUTZ5VURSWDUr?=
 =?utf-8?B?aVJmOGhJSnlVcGY3YXBiV1ViRWZjcjJwaVcwbUxJVVlZbGpuRTBRejhZT0RH?=
 =?utf-8?B?NEIvaUlkNE5zSFVWMHdHYTBHZ1ovMytUWTZaMlluN2s1b2FIWUZHWkpsYThN?=
 =?utf-8?B?NlMrWFF4NEZWVzZyWWpUV3FKbWw0ZTMweFJHNk4ya0l2ZElkZFRYbGozTkwx?=
 =?utf-8?B?MDhiYjYwT1pLbDVjbnJEczFUUVhWeG00WmRaUHlPZDc3T0UzbzZSd1gvcTZh?=
 =?utf-8?B?RnljMTVpbHVjZWFSWU1BTFN0OVZNeWgrWUZaelkyRmU2NWhpYzRZMUZrZDRz?=
 =?utf-8?B?eVprNm94bDJsSUpQRzRzbVFQcmpUVDNPMlpLeHVBdDdsbVBoU3h3aERxaFdY?=
 =?utf-8?B?NlJ5VE9vb3Y5Q0g3VC9QYTlDbEk5bVJVWkwwanN0eDBxMWZyN0l3dzRxM0hy?=
 =?utf-8?B?VVhtZTgwc2lzc2FaMkM4cTlicnBndjlQTXovdEhibVlLYzFPMGEvWklTWXN5?=
 =?utf-8?B?SDFNa1FJeEVjVDh5M2tUZmc3Q0xLRWhrSHdxQ05qclRhUXVlVG1BSEdCQ1lw?=
 =?utf-8?B?L1FkK2NSWjVSNTFDVDN3YUY2cUI5WXVNb2xHb3BFSXlpUURzbHMwU3p0OVIy?=
 =?utf-8?B?YkpiSTFublJzeXVYR2I4ZHJHZVRWWVdMUDJNWHo1NG0rb3BwQ1I0QUpOUXYx?=
 =?utf-8?B?TnNHNUhVcXhoWXNjbWNLYzVIbGNFekFIYzRLSkU1d3p6dGZXNy9tRzhhcEFR?=
 =?utf-8?B?L2dHSjVNL2xROGM3VlhKMldLSGtVVXVLTEFOWkVaUEl1NXFxZk1zbDl4a0ww?=
 =?utf-8?B?MFl6dTNBayt1c2VubStIdEwyaFhnL3ZuVlhBWXpTTjJnUGtZZFY0NXZvVmZS?=
 =?utf-8?B?MWZYSzNJSTdtajJUeGdCdlczTlQ1L3I3T2RnR2JscXNpZDZ2U3BZajUxTjBN?=
 =?utf-8?B?U1lSbzl6V2cyNTlxd2JzYlJZZEdPSTJ0Ri80MWRPL2xpanN6Tlk1UlVsVTlZ?=
 =?utf-8?B?UThLYkZlY1A2ZW5WYS9jdUs1REV0djRaQWNyYlRQZmxScE9kUmVwbXJQYTNI?=
 =?utf-8?B?QnBFMDN4aUFDS0ZCbmdjMFA2QTNRbEI4L2dWVExDMDJtU0pMSElJd1dIWmNa?=
 =?utf-8?B?bm5rRFlUcXF1dTkvK1BDUGUwbS9ISERzL3ZlTnZtT2EzeTI3NnRpMU4zZjNH?=
 =?utf-8?B?RnIrN3ZWWVZEL1oyaEcyVzFtOEUyM0lKbCtnSzJjMEMvbmhTNENWRkk0SHJt?=
 =?utf-8?B?bHZZRDFCQUduYlpHY2NocEwvVjUzNHAyWlJMVmt3TTZNKzBybVhSZlluVWNu?=
 =?utf-8?B?VzNKTUQ1c2NGM09rb3lIa3QwTGltUDRZVlFuUDVMMk94dmlVUXpFQXVvUG9H?=
 =?utf-8?B?Q3FCei9LTENpN2QzeVgyZE5lOXJzVS96N0VJcUlPdzRtbnorc21lRndxaXNz?=
 =?utf-8?B?VldZbWFDV09qMHFPWjBvUVh5S3VBdGQwL3pUTU1nOURmTnpNRXNEMTJYR1NE?=
 =?utf-8?B?WTJkQWxwVS9GaUszK0c0dHRVNE9oandwUWpPNnYxNXVQeXlwbzNMY2R5czlP?=
 =?utf-8?B?UURUOEszaFMrYlBwTGNQSG91VHFwdHNyTDJwaUg5dXVZSHF4bkJ5ZDB4cmRu?=
 =?utf-8?B?YmNMQnFselM1b2dtUnh4cGkwYkZXbFBkaGV5SW1TSTZHNjVKbk9IY2gyKy92?=
 =?utf-8?B?MUs5RElRNVJ5SE1XeU5zd2NRUTRHTUUwWkRKcWR2dnJ4ZGEzaFVtVnhRblYr?=
 =?utf-8?B?OXJBK1lWTER6emtYOXJ6L3BzSGNQRzFmS1E2VkxOeGM5TmluRk9LLzJHZ1R0?=
 =?utf-8?B?OC82cVZjS05WbERhd3NzZXk5TWZndnNHSDlxOXhNWDhqKzlqUnNGZ3A5VS9m?=
 =?utf-8?B?RU00UGtoRGw0bEFJUnNPaEpab0RTTVVYVnRyVm4vTTFHNE4zbm9JN3NWWEhK?=
 =?utf-8?Q?FZAw/a3hOUkyU2I1w1wLN95+xof4Rc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SENNM0ZnakZ6RGpNN1NUVzRxM3gzZC9nZHlCRzBnYnowczF5TVBqQW1UU0hP?=
 =?utf-8?B?ZzM0TGk3WGZaeE9Tc2RaM1lEMDIyaXpOcnV4NWRSVEN0ZGY0dHJoOUNsYktx?=
 =?utf-8?B?eFZrckwzUXFydUcrR2NUS1NxTm9hc0ZraklLbXpsOVFCUVhaYm9TdDVyNWM0?=
 =?utf-8?B?K1ZhU3QyN2xKTGRPRzUyV3R2K1hyVUtlalp0U2wvZHNMakErNkJOcWl2NzYy?=
 =?utf-8?B?WWJLT0xKVUtnVjNPTWxqNkRBVTZVWTVpUHI1Ti9hd3YwT0Q4V0FFaXZZdVdW?=
 =?utf-8?B?MmU5b0lmUWFlVCtzQVRLRTRTbWVVRExGSDB5MjdWbDdmQzdmclJqYkMzVE1w?=
 =?utf-8?B?Z1FJUGd0MjlKM1ZPUks4TVNuTTFVZk5KM2RWbmdPbGhveDNQNFFzcG8rYVFj?=
 =?utf-8?B?WXZZbllidmR6R3Mzc0FEYVFVNWRjbTZZbzQvY0lJcEk2SlpMY1pnRnVLcm5U?=
 =?utf-8?B?TWRVN1J5N25HSk44OWc2UUJINWRidGVBRDkrdE9zbHpmcVl3Rk5Cdk1Pa1JJ?=
 =?utf-8?B?cm1XeU9lWkZJajV1Rng0QkRlaTR0NldXZEtvR2w5OFJ3TjlCZHFyN2hrRVEy?=
 =?utf-8?B?cTRxVWpsZ1dHeHFHNEFSV0Njai9pa1dwMTMySTg3eTB2c0ZQZE9HM1pPeXRZ?=
 =?utf-8?B?bi9zYUp4SXFKemQxZ2JwWm9YQlRwQXZKT1dKQTBFY2lmQ051MHowOVlPdTJR?=
 =?utf-8?B?dEcybGtWU2ZXeXVSQWNlUE5oY3E1b09aRWxKYnRteEpvalVCcGc3ejhwTnY4?=
 =?utf-8?B?RXcwSG5VOVdZL2RiY3o4L0k1WHNycFdnbHMvMzJKVnZ2MkpHaTU2OVNuUEdR?=
 =?utf-8?B?am5oUEpoVVltMDZXclZuN0hnb29aLzJvbERWNzByN0hhSC9aNE9ZdFJKWTJ0?=
 =?utf-8?B?VW5sT2Zya0VGczZUQXU0dTI5WDBVb3gzMnZFQ2YzVG41VjhvdjBPbnJRSndE?=
 =?utf-8?B?cWNhTy9iS1NmTzNvNHZRanRqWm9DWEl2TVVram1WSFAreEplQVcxQTUwZmlx?=
 =?utf-8?B?aFB4OVJ3NEVrMU1TSmVwVjQ3N25SZ2VFVDlybFRkNjJsNVlUUnAzWXdPRW1a?=
 =?utf-8?B?dlJ1dzVBSVM5cVdMTmppY3MwYVptWDEyTE1FYm5NVFVrMWJLdjZSN3RNU0pL?=
 =?utf-8?B?SFNPV3hoNlhXYWFJKzh4T0xIazhlSnFFMjk0bmZwNmdkdlNlcmJZc3NYSk41?=
 =?utf-8?B?N2JLRHE1L050MDBJRzRVRDFJeHJtSjNFalpTWTBOeWlDNVNobUVBanpZTUpo?=
 =?utf-8?B?dnR3SVdGRFAxN3dldG4wOGhudEF1Zk5yVnhibnFDMkRhK2t0ZTY5d0Urczgy?=
 =?utf-8?B?TmExY2doMmpXd3JnN0IrYjZaTWxSb050SHl5cC9SY2dUamZUTnJyTVkrL0dk?=
 =?utf-8?B?bkdGUjF1NDhMQVpGYXM3ZnZLbGg1cnBrcU8xbkFKRE1PUllPQnI3Zmszd2Qx?=
 =?utf-8?B?NUdackhPaHVQSmVuUS9mOXhVc1Mzd0hrN1JEanhuOXpWUmVPSkpKZ0ZUTUlR?=
 =?utf-8?B?ckVqbWoyS3kxTWJEZkJpS3RXUkF1THdDNVVmWHNiMmd3TTlCZEM5bC9SQ2Ex?=
 =?utf-8?B?dVdtK3RrbTFxRTh5K0Vob0dPdG8vOVhGZmVrYSthWHY5MUV3WFB1d3ZHeFpr?=
 =?utf-8?B?WHJDYjBnTnV2MzlXNWl4QVB1bHVJVXJQdWVhUkc3TkxqR1lVR2ZDd2o5KzU3?=
 =?utf-8?B?QlE4bzB1dUJuREFnOUlnbHNvYi9IZUNkNUduN0VkZGxzUWRiYlpYS3VuY2VY?=
 =?utf-8?B?L0JLbkkwYmY0QzR0b3NYdkZwMTZxL0I1cFA2cnAzMm55MEwydDd2RzJ0YURo?=
 =?utf-8?B?TUVYQ2hIWGY4K0c1ZWdZTDFYZ0dqKzFpSkFpajJuR2VscUpYQzkySVRrUVN0?=
 =?utf-8?B?RTU2QnpHSU03WWtPdUZIOGtoWnNyeXhMVWlGaEZtMzRVK3BQek9YcXpaeitt?=
 =?utf-8?B?ZnU5VlRHZFdDWXRvREZpd3BOYUZRTk1oUEZSMGI2TzdJZU9iVzVhVDZFcVhB?=
 =?utf-8?B?ZytDSWdBd2hXS2dMTHVxckhUVklWcjhudUQ0czJ2eG1OSlJRSktMRTVxcUZG?=
 =?utf-8?B?Uzc1Mnl5R0tYWTRoMWJzcEFuZDFKc1hHa0Z4VWdhd2R1YW43cjFUZ0M0SnZB?=
 =?utf-8?Q?CNLT/K26Y1Bf2e0KLAimziPC+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50487C23B9F4BC4393F39F69E82D9254@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eadcb4e-71db-4f6e-6fb5-08ddd54771e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2025 00:14:58.6833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HEOP7DtaYONaEY7iU2zq8ESFxnCRtZtp84H5r8q6co+letzR23L2laDDGfFGCS+t8pBlNpl7XGcYTlP8KwACTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6675
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjExICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IEFsbCBydW5uaW5nIGVuY2xhdmVzIGFuZCBjcnlwdG9ncmFwaGljIGFzc2V0cyAoc3VjaCBh
cyBpbnRlcm5hbCBTR1gNCj4gZW5jcnlwdGlvbiBrZXlzKSBhcmUgYXNzdW1lZCB0byBiZSBjb21w
cm9taXNlZCB3aGVuZXZlciBhbiBTR1gtcmVsYXRlZA0KPiBtaWNyb2NvZGUgdXBkYXRlIG9jY3Vy
cy4gVG8gbWl0aWdhdGUgdGhpcyBhc3N1bWVkIGNvbXByb21pc2UgdGhlIG5ldw0KPiBzdXBlcnZp
c29yIFNHWCBpbnN0cnVjdGlvbiBFTkNMU1tFVVBEQVRFU1ZOXSBjYW4gZ2VuZXJhdGUgZnJlc2gN
Cj4gY3J5cHRvZ3JhcGhpYyBhc3NldHMuDQo+IA0KPiBCZWZvcmUgZXhlY3V0aW5nIEVVUERBVEVT
Vk4sIGFsbCBTR1ggbWVtb3J5IG11c3QgYmUgbWFya2VkIGFzIHVudXNlZC4NCj4gVGhpcyByZXF1
aXJlbWVudCBlbnN1cmVzIHRoYXQgbm8gcG90ZW50aWFsbHkgY29tcHJvbWlzZWQgZW5jbGF2ZQ0K
PiBzdXJ2aXZlcyB0aGUgdXBkYXRlIGFuZCBhbGxvd3MgdGhlIHN5c3RlbSB0byBzYWZlbHkgcmVn
ZW5lcmF0ZQ0KPiBjcnlwdG9ncmFwaGljIGFzc2V0cy4NCj4gDQo+IEFkZCB0aGUgbWV0aG9kIHRv
IHBlcmZvcm0gRU5DTFNbRVVQREFURVNWTl0uIEhvd2V2ZXIsIHVudGlsIHRoZQ0KPiBmb2xsb3cg
dXAgcGF0Y2ggdGhhdCB3aXJlcyBjYWxsaW5nIHNneF91cGRhdGVfc3ZuKCkgZnJvbQ0KPiBzZ3hf
aW5jX3VzYWdlX2NvdW50KCksIHRoaXMgY29kZSBpcyBub3QgcmVhY2hhYmxlLg0KDQpQbGVhc2Ug
Y2hlY2sgdGhlIHRleHQgd3JhcC4NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRWxlbmEgUmVzaGV0
b3ZhIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2luY2x1
ZGUvYXNtL3NneC5oICAgICAgfCAzMSArKysrKysrLS0tLS0tLQ0KPiAgYXJjaC94ODYva2VybmVs
L2NwdS9zZ3gvZW5jbHMuaCB8ICA1ICsrKw0KPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFp
bi5jICB8IDczICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgMyBmaWxlcyBj
aGFuZ2VkLCA5NCBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zZ3guaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Nn
eC5oDQo+IGluZGV4IDJkYTViM2IxMTdhMS4uMGUxMzY3OGY5Y2JkIDEwMDY0NA0KPiAtLS0gYS9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9zZ3guaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9z
Z3guaA0KPiBAQCAtMjgsMjEgKzI4LDIyIEBADQo+ICAjZGVmaW5lIFNHWF9DUFVJRF9FUENfTUFT
SwlHRU5NQVNLKDMsIDApDQo+ICANCj4gIGVudW0gc2d4X2VuY2xzX2Z1bmN0aW9uIHsNCj4gLQlF
Q1JFQVRFCT0gMHgwMCwNCj4gLQlFQURECT0gMHgwMSwNCj4gLQlFSU5JVAk9IDB4MDIsDQo+IC0J
RVJFTU9WRQk9IDB4MDMsDQo+IC0JRURHQlJECT0gMHgwNCwNCj4gLQlFREdCV1IJPSAweDA1LA0K
PiAtCUVFWFRFTkQJPSAweDA2LA0KPiAtCUVMRFUJPSAweDA4LA0KPiAtCUVCTE9DSwk9IDB4MDks
DQo+IC0JRVBBCT0gMHgwQSwNCj4gLQlFV0IJPSAweDBCLA0KPiAtCUVUUkFDSwk9IDB4MEMsDQo+
IC0JRUFVRwk9IDB4MEQsDQo+IC0JRU1PRFBSCT0gMHgwRSwNCj4gLQlFTU9EVAk9IDB4MEYsDQo+
ICsJRUNSRUFURQkJPSAweDAwLA0KPiArCUVBREQJCT0gMHgwMSwNCj4gKwlFSU5JVAkJPSAweDAy
LA0KPiArCUVSRU1PVkUJCT0gMHgwMywNCj4gKwlFREdCUkQJCT0gMHgwNCwNCj4gKwlFREdCV1IJ
CT0gMHgwNSwNCj4gKwlFRVhURU5ECQk9IDB4MDYsDQo+ICsJRUxEVQkJPSAweDA4LA0KPiArCUVC
TE9DSwkJPSAweDA5LA0KPiArCUVQQQkJPSAweDBBLA0KPiArCUVXQgkJPSAweDBCLA0KPiArCUVU
UkFDSwkJPSAweDBDLA0KPiArCUVBVUcJCT0gMHgwRCwNCj4gKwlFTU9EUFIJCT0gMHgwRSwNCj4g
KwlFTU9EVAkJPSAweDBGLA0KPiArCUVVUERBVEVTVk4JPSAweDE4LA0KPiAgfTsNCj4gIA0KPiAg
LyoqDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNscy5oIGIvYXJj
aC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbHMuaA0KPiBpbmRleCA5OTAwNGIwMmUyZWQuLmQ5MTYw
Yzg5YTkzZCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbHMuaA0K
PiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNscy5oDQo+IEBAIC0yMzMsNCArMjMz
LDkgQEAgc3RhdGljIGlubGluZSBpbnQgX19lYXVnKHN0cnVjdCBzZ3hfcGFnZWluZm8gKnBnaW5m
bywgdm9pZCAqYWRkcikNCj4gIAlyZXR1cm4gX19lbmNsc18yKEVBVUcsIHBnaW5mbywgYWRkcik7
DQo+ICB9DQo+ICANCj4gKy8qIEF0dGVtcHQgdG8gdXBkYXRlIENQVVNWTiBhdCBydW50aW1lLiAq
Lw0KPiArc3RhdGljIGlubGluZSBpbnQgX19ldXBkYXRlc3ZuKHZvaWQpDQo+ICt7DQo+ICsJcmV0
dXJuIF9fZW5jbHNfcmV0XzEoRVVQREFURVNWTiwgIiIpOw0KPiArfQ0KPiAgI2VuZGlmIC8qIF9Y
ODZfRU5DTFNfSCAqLw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFp
bi5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jDQo+IGluZGV4IDNhNWNiZDFjMTcw
ZS4uZDhjNDI1MjRiNTkwIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9t
YWluLmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jDQo+IEBAIC0xNiw2
ICsxNiw3IEBADQo+ICAjaW5jbHVkZSA8bGludXgvdm1hbGxvYy5oPg0KPiAgI2luY2x1ZGUgPGFz
bS9tc3IuaD4NCj4gICNpbmNsdWRlIDxhc20vc2d4Lmg+DQo+ICsjaW5jbHVkZSA8YXNtL2FyY2hy
YW5kb20uaD4NCj4gICNpbmNsdWRlICJkcml2ZXIuaCINCj4gICNpbmNsdWRlICJlbmNsLmgiDQo+
ICAjaW5jbHVkZSAiZW5jbHMuaCINCj4gQEAgLTkxNyw2ICs5MTgsNzggQEAgaW50IHNneF9zZXRf
YXR0cmlidXRlKHVuc2lnbmVkIGxvbmcgKmFsbG93ZWRfYXR0cmlidXRlcywNCj4gIH0NCj4gIEVY
UE9SVF9TWU1CT0xfR1BMKHNneF9zZXRfYXR0cmlidXRlKTsNCj4gIA0KPiArLyogQ291bnRlciB0
byBjb3VudCB0aGUgYWN0aXZlIFNHWCB1c2VycyAqLw0KPiArc3RhdGljIGludCBzZ3hfdXNhZ2Vf
Y291bnQ7DQo+ICsNCj4gKy8qKg0KPiArICogc2d4X3VwZGF0ZV9zdm4oKSAtIEF0dGVtcHQgdG8g
Y2FsbCBFTkNMU1tFVVBEQVRFU1ZOXS4NCg0KQWRkIGEgbmV3bGluZSB3b3VsZCBtYWtlIHRoZSBj
b21tZW50IG1vcmUgcmVhZGFibGUuDQoNCj4gKyAqIFRoaXMgaW5zdHJ1Y3Rpb24gYXR0ZW1wdHMg
dG8gdXBkYXRlIENQVVNWTiB0byB0aGUNCj4gKyAqIGN1cnJlbnRseSBsb2FkZWQgbWljcm9jb2Rl
IHVwZGF0ZSBTVk4gYW5kIGdlbmVyYXRlIG5ldw0KPiArICogY3J5cHRvZ3JhcGhpYyBhc3NldHMu
DQoNCkRpdHRvIGhlcmUuDQoNCj4gKyAqIFJldHVybjoNCj4gKyAqIDA6IFN1Y2Nlc3Mgb3Igbm90
IHN1cHBvcnRlZA0KPiArICogLUVBR0FJTjogQ2FuIGJlIHNhZmVseSByZXRyaWVkLCBmYWlsdXJl
IGlzIGR1ZSB0byBsYWNrIG9mDQo+ICsgKiAgZW50cm9weSBpbiBSTkcuDQo+ICsgKiAtRUlPOiBV
bmV4cGVjdGVkIGVycm9yLCByZXRyaWVzIGFyZSBub3QgYWR2aXNhYmxlLg0KPiArICovDQoNCllv
dSBtYXkgd2FudCB0byBtYWtlIHRoZSBkZXNjcmlwdGlvbiBvZiB0aGUgcmV0dXJuIGNvZGUgdmVy
dGljYWxseQ0KYWxpZ25lZC4gIEFuZCBsb29raW5nIGF0IHRoZSBrLWRvYyBkb2N1bWVudGF0aW9u
LCB0aGUgZm9ybWF0IG9mIHRoZSByZXR1cm4NCmNvZGVzIGNvdWxkIGJlIGltcHJvdmVkOg0KDQoJ
KiBSZXR1cm46DQoJKiAqICUwOgkJLSBTdWNjZXNzIG9yIG5vdCBzdXBwb3J0ZWQNCgkqICogJS1F
QUdBSU46CS0gLi4uDQoJKiAqICUtRUlPOgktIC4uLg0KDQpQbGVhc2Ugc2VlICJSZXR1cm4gdmFs
dWVzIiBwYXJ0IG9mOg0KDQpodHRwczovL2RvY3Mua2VybmVsLm9yZy9kb2MtZ3VpZGUva2VybmVs
LWRvYy5odG1sDQoNCk9yIHlvdSBjYW4gc3dpdGNoIHRvIHVzZSBub3JtYWwgY29tbWVudC4gIEl0
J3MgYSBzdGF0aWMgZnVuY3Rpb24gYW55d2F5Lg0KCQ0KDQo+ICtzdGF0aWMgaW50IF9fbWF5YmVf
dW51c2VkIHNneF91cGRhdGVfc3ZuKHZvaWQpDQo+ICt7DQo+ICsJaW50IHJldDsNCj4gKw0KPiAr
CS8qDQo+ICsJICogSWYgRVVQREFURVNWTiBpcyBub3QgYXZhaWxhYmxlLCBpdCBpcyBvayB0bw0K
PiArCSAqIHNpbGVudGx5IHNraXAgaXQgdG8gY29tcGx5IHdpdGggbGVnYWN5IGJlaGF2aW9yLg0K
PiArCSAqLw0KPiArCWlmICghY3B1X2ZlYXR1cmVfZW5hYmxlZChYODZfRkVBVFVSRV9TR1hfRVVQ
REFURVNWTikpDQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJLyoNCj4gKwkgKiBFUEMgaXMgZ3Vh
cmFudGVlZCB0byBiZSBlbXB0eSB3aGVuIHRoZXJlIGFyZSBubyB1c2Vycy4NCj4gKwkgKiBFbnN1
cmUgd2UgYXJlIG9uIG91ciBmaXJzdCB1c2VyIGJlZm9yZSBwcm9jZWVkaW5nIGZ1cnRoZXIuDQo+
ICsJICovDQo+ICsJV0FSTihzZ3hfdXNhZ2VfY291bnQgIT0gMSwgIkVsZXZhdGVkIHVzYWdlIGNv
dW50IHdoZW4gY2FsbGluZyBFVVBEQVRFU1ZOXG4iKTsNCg0KSSBhbSBub3Qgc3VyZSB3aGV0aGVy
IHRoaXMgaXMgbmVlZGVkLiAgV291bGRuJ3QgdGhlIEVOQ0xTX1dBUk4oKSBhdCB0aGUNCmVuZCBj
YXRjaCB0aGlzIGNhc2UgYW5kIHRoZSB1c2VyIGlzIGFibGUgdG8gZmlndXJlIG91dCB3aGF0IHdl
bnQgd3JvbmcNCmZyb20gdGhlIGVycm9yIGNvZGU/DQoNCkJlc2lkZXMgdGhhdCwgaW4gX3RoaXNf
IHBhdGNoLCB3aGF0IHByZXZlbnRzIHNneF91c2FnZV9jb3VudCBmcm9tIGJlaW5nDQpjb25jdXJy
ZW50bHkgdXBkYXRlZCBpcyBzdGlsbCB1bmtub3duLiAgSXQncyBraW5kYSB3ZWlyZCB0byBqdXN0
IHVzZSBpdA0KaGVyZSB3L28gc2VlaW5nIHRoZSBhY3R1YWwgbXV0ZXguDQoNCj4gKw0KPiArCWZv
ciAoaW50IGkgPSAwOyBpIDwgUkRSQU5EX1JFVFJZX0xPT1BTOyBpKyspIHsNCj4gKwkJcmV0ID0g
X19ldXBkYXRlc3ZuKCk7DQo+ICsNCj4gKwkJLyogU3RvcCBvbiBzdWNjZXNzIG9yIHVuZXhwZWN0
ZWQgZXJyb3JzOiAqLw0KPiArCQlpZiAocmV0ICE9IFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSkN
Cj4gKwkJCWJyZWFrOw0KPiArCX0NCj4gKw0KPiArCXN3aXRjaCAocmV0KSB7DQo+ICsJLyoNCj4g
KwkgKiBTVk4gc3VjY2Vzc2Z1bGx5IHVwZGF0ZWQuDQo+ICsJICogTGV0IHVzZXJzIGtub3cgd2hl
biB0aGUgdXBkYXRlIHdhcyBzdWNjZXNzZnVsLg0KPiArCSAqLw0KDQpUaGlzIGlzIHVnbHkuICBJ
IHdvdWxkIGp1c3QgcHV0IHRoZSBjb21tZW50IGluc2lkZSB0aGUgJ2Nhc2UnLg0KDQo+ICsJY2Fz
ZSAwOg0KPiArCQlwcl9pbmZvKCJTVk4gdXBkYXRlZCBzdWNjZXNzZnVsbHlcbiIpOw0KPiArCQly
ZXR1cm4gMDsNCj4gKwkvKg0KPiArCSAqIFNWTiB1cGRhdGUgZmFpbGVkIHNpbmNlIHRoZSBjdXJy
ZW50IFNWTiBpcw0KPiArCSAqIG5vdCBuZXdlciB0aGFuIENQVVNWTi4gVGhpcyBpcyB0aGUgbW9z
dA0KPiArCSAqIGNvbW1vbiBjYXNlIGFuZCBpbmRpY2F0ZXMgbm8gaGFybS4NCj4gKwkgKi8NCj4g
KwljYXNlIFNHWF9OT19VUERBVEU6DQo+ICsJCXJldHVybiAwOw0KPiArCS8qDQo+ICsJICogU1ZO
IHVwZGF0ZSBmYWlsZWQgZHVlIHRvIGxhY2sgb2YgZW50cm9weSBpbiBEUk5HLg0KPiArCSAqIElu
ZGljYXRlIHRvIHVzZXJzcGFjZSB0aGF0IGl0IHNob3VsZCByZXRyeS4NCj4gKwkgKi8NCj4gKwlj
YXNlIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWToNCj4gKwkJcmV0dXJuIC1FQUdBSU47DQo+ICsJ
ZGVmYXVsdDoNCj4gKwkJYnJlYWs7DQo+ICsJfQ0KDQpEaXR0byBmb3IgYWxsIHRoZSBjb21tZW50
cyBhYm92ZS4NCg==
