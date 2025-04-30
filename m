Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A059D3C6BA;
	Wed, 30 Apr 2025 06:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745996022; cv=fail; b=PECRgAjhDW3T7e2DhH6EVINIQ43h/jNWm/ssWvnDqjvzqZQCBWVE4S36V9rVRkRwgD16uhvBZ2hPMr6qtY1XBG2giagrguPkbzX2I/599eD88JzzJAcEYP6aN2Pd0pF4r8C5uXGCOlAljiGS70zbbnTsRgi2+YX5H0YibAiB9y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745996022; c=relaxed/simple;
	bh=ipe9x/K2Z/XURKHQagGucXf255PMoAaLJpVKFlrp9yg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r1qPS/FVvcW6wVfzgSu+LHfQdnHMoAoQop5capfodtUivXkQuM+5MYpuzWbqptkit65A+LHAY1hffgjcpky2kuLq7B3ADVPSixMfdHlbM7xwb31FulIjP+gsMvWQFwguU5Oiv0KSLTD1nQrage4ZEQT0zoED3u8dEJx4H5z4lGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZMfwIbAW; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZMfwIbAW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745996020; x=1777532020;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ipe9x/K2Z/XURKHQagGucXf255PMoAaLJpVKFlrp9yg=;
  b=ZMfwIbAWIGg/VPw5IrwcYG1AhuzpOn6a+9jwhgIm9rUTWtrCKbzKT6B0
   UP/g4ZKkm5bbvj1n3FlADeYXTbLQ+rEwZzpkQafhya/48DS34c9EinukA
   1kdN1MkuWR/+EtxF2mGuHwKl7I+seFKKKZXAXpw9fdrBrQxP/xsT1Dj9G
   vbLt4RGCXVhpqLQJuSapJ1NiD5ogV5dUNcEuQBjrINjaiFNKqIZxYhzXa
   hBsXApTnvpGyMJUT6Jpaw5KQe7rnIQxyXw6U8PXrloo5jQLXQ9xA0jNkt
   bJwh4W1HxnjFvZZ0j6FC0ckH9HMQ1lWVXMvYQ+n3t9t2GRJDFZP7hl2gM
   Q==;
X-CSE-ConnectionGUID: ICL807iES4GCFkHJuPsWeg==
X-CSE-MsgGUID: oPztE1TyQGi80mDihkIZUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="47655740"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="47655740"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 23:53:39 -0700
X-CSE-ConnectionGUID: 1chRTygjRHqQXk/6yx9gzw==
X-CSE-MsgGUID: VKmuAhkfQKqxUYM0k/+JZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="164981983"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 23:53:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 29 Apr 2025 23:53:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 29 Apr 2025 23:53:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 29 Apr 2025 23:53:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bmnqTxXm3lwjShtL/CfP4GJiMIYz7vxqMAmV7kgeuRfeD+uvfpH12+UP0yj8JVo6RTxUMq1jivB2Gx+gfOQJEBj9TDA6Ke+UhIW6wjsFARhx1POMB4Y15pgDOs9rvehP6kj/SeHKWTKtXUcMviPGL8W9ZD7927XzOOio8RpYTGuSKOQBL9siUcKAlV/+PBCrfW2ltY9wA3gaG+gqn4uHtH8w7jcXadxDustHcDXqVtxTq8c/stDzvAeojXYTgv7N4VirVq8hDwIZ54dy0Y1uF2BKoDb9Je/g4RuNFZkZnKXZfWD3kKo28mMnepaAsdrir21MNr4K9x4j/Baig3zUOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipe9x/K2Z/XURKHQagGucXf255PMoAaLJpVKFlrp9yg=;
 b=bNy/l4blSE8ppiLoIZx3mBemcKm/22342cs5JH4hdEjTL4V/lUMsJXURNQS+Lz68wHuGFOASL0olPYbpFOXMYKk1cLIeDnQFIvYXQhGS4fRxqosRYmN4/I7CH41zAO9fyz8f04nnYo0Qi00njfmopJSLFp9PIR6B7J9igxmxI2q0cPmAUr0UudEm6tqOS6LPzbXLnEe8yXJE3FlKaGPblr804Rj/EdAaWU7j/yW3plqVEabz3SJlZVz1hdID4HKKBUhDltDuz4GHWHtjO/X0r0mFpzUuVXRUO+BkDqVwENAb8Kzj55qX+xMhw5L7lXdZpJrozd+3F/5yvQLXZ2l6JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SA3PR11MB7628.namprd11.prod.outlook.com (2603:10b6:806:312::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Wed, 30 Apr
 2025 06:53:32 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%7]) with mapi id 15.20.8678.028; Wed, 30 Apr 2025
 06:53:32 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, Sean Christopherson
	<seanjc@google.com>, "jarkko@kernel.org" <jarkko@kernel.org>
CC: "Huang, Kai" <kai.huang@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Cai, Chong"
	<chongc@google.com>, "Mallick, Asit K" <asit.k.mallick@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "bondarn@google.com" <bondarn@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbrfzujDHiSNozs0m8Z6fqnS5FZ7Oph/QAgAXK54CAAG1QAIACw3gAgABd6wCAAAZ2IIAANiqAgADdHdCAALsMgIAABskAgAAXsoCAAAu/gIAADsCAgAAFLwCAAAnhgIAAAmEAgAWa6ZCAADM0gIABBeNg
Date: Wed, 30 Apr 2025 06:53:32 +0000
Message-ID: <DM8PR11MB5750200DFF8CF40E3539B688E7832@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <aAo_2MPGOkOciNuM@google.com>
 <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aApgOqHvsYNd-yht@google.com>
 <DM8PR11MB5750AB0E790096AFF9AFD3AFE7842@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAutUaQvgEliXPUs@google.com>
 <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
 <aAviqeAdGn-w1GpK@google.com>
 <fbd2acdb-35dc-4e8c-9bd9-e84264f88648@intel.com>
 <aAv445Sr71NUJP1X@google.com>
 <db1fd062-5a66-4942-82e2-c889dd645a7b@intel.com>
 <aAwFhaqQDLXoqbmv@google.com>
 <4b4ecaa1-2ace-43bf-b71b-0de78bcf113c@intel.com>
 <DM8PR11MB5750B39557F5062038D0E551E7802@DM8PR11MB5750.namprd11.prod.outlook.com>
 <8db47bc1-445b-49db-b932-96aff0eb58a9@intel.com>
In-Reply-To: <8db47bc1-445b-49db-b932-96aff0eb58a9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SA3PR11MB7628:EE_
x-ms-office365-filtering-correlation-id: 56eaad29-8f75-4004-2e37-08dd87b3b8e2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V3h1OXpjQm9tUFM1Y2FVOUJQL2MyMXlGNTh1YitMdFllTWIvSlh4VWZ5TjM3?=
 =?utf-8?B?cGtubkxIK0p0M0VwYng5Mkg3TFYzTmxCVVZXcnk1QUY2R2F5akZXS2FFNmZT?=
 =?utf-8?B?VDNKU3VSbTVGVHBPOXhSWGhackt5T2dBUjRhZEFxS29rZ0QrZ0ZFWXc1NmZa?=
 =?utf-8?B?VWpacU5tM1lvQUJVamhScENIS3Y3aS9iYjBya3hhTUc0UVZtcnpSV29CZlk0?=
 =?utf-8?B?UGtLdzhwRUptMzY4WHlqdG5FcTlNbjJGbnNyZ0dEcjlidEVSZ1k5TE81ZGh3?=
 =?utf-8?B?YXJSU1FsZGxlZEdIZnVlbVpDdXJKT01aOTh5b1J1a0lod0paY0I5OFMzaFBT?=
 =?utf-8?B?eGlwZVRrc01nVHVjcEZyM0ZRWkVxdzMrdUdqV2FSZTBkMzVmN2JKTC9jSE9h?=
 =?utf-8?B?STA4c2JLdUFSMEZnRmV6ZTFpVk5sbCtJWTBVUXpUVmFEekppS05xc1dYRGJ5?=
 =?utf-8?B?ekhPMEJBZHhRSDdSeXROU2xva3kybkE1bmpUQXFIbXB3NUVUWUcwMVJQb1R2?=
 =?utf-8?B?Q01uZnZxdEtCYU5zS2ZnOXdKL3lUcWNNS1FubkNTZXZJUkpKZ0g4ck5wQTVv?=
 =?utf-8?B?TGtDeUI2S1ZmbElJa21HZzlXRnFDWjRnZWxKTFJCZElhZnRTSjE1dm83NXYy?=
 =?utf-8?B?SFdNcWh4U3FsblZJMUhoTFJQd2wwOW9ybjB1azVmMlVOWEt5NFFHbW9GUDZV?=
 =?utf-8?B?SzVqRlNqWWFKekJvZ2daYlBHbnc0QytyUUZyaHRZd2hJQVdrVFBlcURIc2Z5?=
 =?utf-8?B?ZEVmWHpjTEoxRTZkd1A4cVBvRzdTQ01TZzVHRzExYVB2bElQREVRZjY1NlpT?=
 =?utf-8?B?WGdkNkZRN2NEejg4Tkp0OFNDeGhDVHVQSGgxUFFBSVZUdEtUOVU2Q2VINStz?=
 =?utf-8?B?bU9OTFJYV0tVVUhSTWpKL1VtdjJmSFJaVjhrUDBjRElGcGlacjhMNjJWcjhX?=
 =?utf-8?B?ZkhQOWdGcVFqcGxhc25PM3ByWENtY3FIS3NUaDRhSy9IYWlsczcxM3M4amhw?=
 =?utf-8?B?VnoxRThPbmsvNzBEZTlBVHBmWlY0dnFNazF3VXR6cElOT3EweXNvdVRMK2ts?=
 =?utf-8?B?eGZHVzlqVGpXVFJKUDNDbWRCd0ZSd3daa2pWMXM4cnpkNlBtZzdvUjhyWXhv?=
 =?utf-8?B?UU4yT2FvT1BkbVZpU1J2WnZQS3JkMVlyTFYwVXpuM0E2S084aFJaSm9maGFz?=
 =?utf-8?B?MDZzTXVmWmxwNURNVkt1cFJ0K0RLbVBjZXJjaTMyVUVUclhOU3ZFTGJ0UXUr?=
 =?utf-8?B?NndaN0NmcUFNbGs5QTE1Z0lBRE1kUTY1dFJORVFDM2h1a21sd3RLVm0vTGla?=
 =?utf-8?B?UXp3VmIrK1lmZjZFdnFoWDdLZFNiWk9qbzBnciswYm0rQUhuamJIaFhCTmVO?=
 =?utf-8?B?RXNWSy82cjVvNWZFOE1wcThwcGI1OGxjQzlnNEF0TVlMSUVHS1RjNE1ENzMx?=
 =?utf-8?B?bXlESVVuZm53S1dsMjVuczNtY1FQVGFKVHViVVU3VEFxdmJtK1NidFRuN0xU?=
 =?utf-8?B?UzZxcHVIN1FFdUZTcjdrcTN5VUM0c0FjRWFJdVdpNFZmcFJDbkhoa2VmRlA3?=
 =?utf-8?B?OWx5V3NhY2NsTVhSeXVDeEs0VTlwZFVFQVpsaENEaFdlcWF3dEgyL1lpc3pV?=
 =?utf-8?B?S3ZZd25JRThCdjZPSkxhdTk4NU1Ja3h6OEk2b01KU24xWHU4TlhmRmpCQ2dw?=
 =?utf-8?B?OWpzYVQwaTN5NENhSjgrUU9wRCtaT21RTDQ1cGxJTHIvM1d2N2hYOXg2RGtQ?=
 =?utf-8?B?Rmtpd0ZsQkZ6TFNZVUhxOEJDQ1Q4VmNmNGdXWERGeDNzUjE4Yk9JZzNLYUFv?=
 =?utf-8?B?MHhMNENFbkVqSzRpdGJjL2hDdjdHQ2tiUWNMeHRlM3U0b0pZWE9PTExZdE1S?=
 =?utf-8?B?VDA4N2VFcDluZTJsM1VTVlg2SjJZWndvWk41MHd4QmVUN2RMM092NkJXSUN2?=
 =?utf-8?B?RUgrODJvM3BLUitXemRGQW96cWYvTDV2WndqU2FPeWp0Ym1KVTVsRGRUb1ZU?=
 =?utf-8?Q?e2cgpDP73RLAqc69svuiXIp7i1NXdI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0NCSEhNUDd0cUZvd2RFcHNHRUZEVytEcmt2ZmtvV2Q0TkxRaC83NSs0SFJG?=
 =?utf-8?B?UVJsQ0xwTDlZbERLZll4TWNOMDBkbVhoRC92bk91RkRaU0ZhQVo2cUx2VVc2?=
 =?utf-8?B?SnNaT2lFWWFsRUxJUGxBSHNmMGdKNXlNcitVSW9wU1BHMSszRTc5ZTZkdEtS?=
 =?utf-8?B?emsxSDdST28wZ3VwYjkrN2g1ejlHakZUTEtIUkhCQXloVU1PdGdDMmJRK3BM?=
 =?utf-8?B?L1VRVUxZZnlPbGxZWksxZCtheWp6T0VGa1pKeTdMSFdjek5UNkMyMktVTzNN?=
 =?utf-8?B?aTdEQWNWQUUrbkh0clRqN09Sb2s0K0hqVHh2Q0NkeGpmbUZmK1M1b3JBUVNp?=
 =?utf-8?B?Q2hONTVNUHhaUWg5c1JnNFI5ZzFpSWRaNnkvTStsMmZ6UC9hT3dIVnM1dEhI?=
 =?utf-8?B?YzdhN0lZeVNIUmR1TlE1ek1oTXlqaUYwNGR5ZHBFa3pxNkxtR1hWZkVVOVRN?=
 =?utf-8?B?cUd1QUEwY1NRNjZqbTFxZDBwNTFVQlA4ZXZnS3I3Z2NBM2NqYmNIQThJRDkx?=
 =?utf-8?B?QTFBUk02N2hXUmp0MVR5RnRRSWU3aHU4bkdvQi9xblpCSnV4NlFFN3U3Vnhy?=
 =?utf-8?B?REJIUXJsS01PY0huUWZ6NDQ0QkRxc1o0ZHBmME5GZUozQ1ludGx2OG90UXB5?=
 =?utf-8?B?TjhmdHE2L1ZZcjM4MGdTN2NRRkJpTGxNRmFvaldMRit2SVBOS2gxKzJHaVBm?=
 =?utf-8?B?NWw4VndXSzhxaHZFaDNOa3VLR3BNSmcyaXBUSHdnSVI1VlU4QWMzYmF6RnN5?=
 =?utf-8?B?c3VjcjFBTDIvSUl0aW1rK2NPbjBEU1FGaUwzMzlSQUs0Q1lyS1N0S1FVTjQv?=
 =?utf-8?B?VWZNVnFJWTZXSThESkE1emlyUWRCbWl6MlhlQzMzaGhWMTJqNzM4UXBUczhK?=
 =?utf-8?B?a2dka0g5cTJKU1JsaFo4V05oQ1d2YndOSTV5WjR2SUdMODR0Z3M3UFMveC9Q?=
 =?utf-8?B?WURmbm9tK2VHMUJkVUJuK1R2Z2dWYnhWNlNubGgxdFVWdHBScERkbUVvUC9C?=
 =?utf-8?B?eDFxUUZsVmtrUG56ZG5Od2hSTXR6Rm95RncydHBoVGRQSjJnN0djQWRzb1M2?=
 =?utf-8?B?bGQ1Q0QzQjFmaFplVDE1WXJDbGc5b3hBM0dhcCtFakFtSU0xNVVDY3U2S3R1?=
 =?utf-8?B?N29RYm8yRmIwK202ZUN6Q0pjSXpEQVVKSjJqTWxvTnBmSmtPS3VwTWc5QXMr?=
 =?utf-8?B?L0t3Y200QmNaKzAzcitFUDJpbGZnOFBpRWpjU1JXaUFoZ1pZdVRnSFVERjFY?=
 =?utf-8?B?RFBub3huVE9jQ0gzSEQ4QlI0SksrMWp3aHU2S0J5TnlvRVAwSFNlU3UxYTdJ?=
 =?utf-8?B?SFhyL0djTTZFUm9JTGp1ekxqMnlia0M1T2E5NHdac09zdU9RN1p5YllnUXhm?=
 =?utf-8?B?azRQNDVZNUZpNTd6MURiSlRQTkUwbktyYjVQeHVIWTcwMC9Mc2NxbjNHODM4?=
 =?utf-8?B?YmZtK01XdnpjUWRBWlBxa1RhYkZlbjJsQUxlWGl3Q2t2QmVVN0lEN2xwM0ha?=
 =?utf-8?B?SmVvMWJOZHFSV1BubDhVOGtCS05iVkhSVHB2OHVsSnc4SDNOeFMzcTR5ZFFT?=
 =?utf-8?B?NUN4NEVWR1h3a0IrS2d1Y25LTDl3eVZOUVl3dFlLbUh4Z3RtUWhmd0QvZ3lm?=
 =?utf-8?B?TFNucDd2VGZnNmlJd0x2Y3hQVHltZ0NkZ2JlMEI4dnI3aWlDZHE5Znp0OW1v?=
 =?utf-8?B?cWpmSlpORU9obk1DYXY4Z0dGaXVmc3hyOFJ2bHliYjI2dGJZYitsNlMvWDIz?=
 =?utf-8?B?RTdRN2dpWm1Da1pINGNFS1plejRoMXppQkxaVHhyZzVwZEc4YnRCaTFBcjM5?=
 =?utf-8?B?WTZGUDFHeWltb1EwZkY3anIrUzh5NzBubFhqaEwyK3lGWCs5VEVWTVl5NkVF?=
 =?utf-8?B?Q2Y1U3RDK0JQdmFtY1VkTVBJQWJualpLOWtTUW8rb2w1YjdKYlhYRXhOMGR2?=
 =?utf-8?B?Tno0RXgwYXNCd3VXUHdYOWdUcmIzb3Q0WVdWNk5yZWRFZUNGQlEzL2lXS0tN?=
 =?utf-8?B?SXMyeHJqSkRkOHBFdTArZW9IZUdoWDhhZUZpd3dQT0tnMWNlYzAxM2pURmNK?=
 =?utf-8?B?cVpiblg5ZkpybXBnOVlpRnZzVWZoeFU3ZGI0WEgwQzAvcHB6UExJTTdwNGR4?=
 =?utf-8?B?SFI3aFdaNGd0WGRNSGcvNnY0RlRuaVFQbFhuWk9FQmhrVTliK1BkeHFGS2Vw?=
 =?utf-8?B?UkE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 56eaad29-8f75-4004-2e37-08dd87b3b8e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 06:53:32.7135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lKQK0mbgVwV7hc9BpGIoXkXtXnhS+E44GSzak9ViNxrV1fSdfiev3G6RZSArg7ST5FjaZ/D0PW75e7xgjpO57HGKcK9HY3GyIM44wImXpVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7628
X-OriginatorOrg: intel.com

PiBPbiA0LzI5LzI1IDA0OjQ0LCBSZXNoZXRvdmEsIEVsZW5hIHdyb3RlOg0KPiA+PiBPbiA0LzI1
LzI1IDE0OjU4LCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+Pj4gT24gRnJpLCBBcHIg
MjUsIDIwMjUsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+Pj4+IE9uIDQvMjUvMjUgMTQ6MDQsIFNl
YW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4+Pj4+IFVzZXJzcGFjZSBpcyBnb2luZyB0byBi
ZSB3YWl0aW5nIG9uIC0+cmVsZWFzZSgpIG5vIG1hdHRlciB3aGF0Lg0KPiA+Pj4+IFVubGVzcyBp
dCBpc24ndCBldmVuIGludm9sdmVkIGFuZCBpdCBoYXBwZW5zIGF1dG9tYXRpY2FsbHkuDQo+ID4+
PiBXaXRoIG15IEdvb2dsZSBoYXQgb246IG5vIHRoYW5rcy4NCj4gPj4gSSdtIGNvbXBsZXRlbHkg
b3BlbiB0byB0aGUgaWRlYSBvZiBhZGRpbmcgdHJhbnNwYXJlbmN5IHNvIHRoYXQgZm9sa3MgY2Fu
DQo+ID4+IHRlbGwgd2hlbiB0aGUgU1ZOIGluY3JlbWVudHMuIEknbSBtb3N0bHkgb3BlbiB0byBo
YXZpbmcgYSBuZXcgQUJJIHRvIGRvDQo+ID4+IGl0IGV4cGxpY2l0bHkgaW4gYWRkaXRpb24gdG8g
ZG9pbmcgaXQgaW1wbGljaXRseS5dDQo+ID4gQ291bGQgeW91IHBsZWFzZSBjbGFyaWZ5IGhlcmUg
RGF2ZSB3aGF0IEFCSSBkbyB5b3UgaGF2ZSBpbiBtaW5kPw0KPiANCj4gSSBzaG91bGQgaGF2ZSBz
YWlkIEknbSBvcGVuIHRvICpldmVudHVhbGx5KiBhZGRpbmcgZmVhdHVyZXMgYW5kIG5ldyBBQkkN
Cj4gdG8gcHJvZCBhdCB0aGUgU1ZOIHN0YXRlLg0KPiANCj4gTm90IG5vdy4NCj4gDQoNCk9LLCBz
byBpbiB3aGF0IGRpcmVjdGlvbiBzaG91bGQgSSBwcmVwYXJlIGFuZCBzZW5kIGEgcHJvcGVyIHY0
Pw0KSGVyZSBhcmUgdGhlIG9wdGlvbnMgYXMgSSB1bmRlcnN0YW5kIHRoZW06DQoNCjEuIEtlZXAg
dGhlIGN1cnJlbnQgYXBwcm9hY2ggKHdpdGggYWxsIHN1Z2dlc3RlZCBmaXhlcykgdG8gZXhlY3V0
ZSBFVVBEQVRFU1ZODQpkdXJpbmcgZmlyc3QgRVBDIHBhZ2UgY3JlYXRpb24uIA0KDQpQcm9jOiBT
aW5nbGUgZmxvdyBpbnNpZGUgRVBDIHBhZ2UgYWxsb2NhdGlvbi4gTm8gbmV3IHVBQkkuIA0KQ29u
c3Q6IFJlamVjdGluZyBFUEMgYWxsb2NhdGlvbiBpZiBFVVBEQVRFU1ZOIGZhaWxzIGJyZWFrcyBl
eGlzdGluZyBiZWhhdmlvdXINCihub3RlIHRoaXMgY2FuIGJlIGNoYW5nZSB0byBvcmlnaW5hbCB2
ZXJzaW9uIG9mIHRoZSBwYXRjaCB3aGVyZSBldXBkYXRlc3ZuDQpmYWlsdXJlcyBhcmUgaWdub3Jl
ZCBhbmQgRVBDIGFsbG9jYXRpb24gY2FuIHByb2NlZWQgbm9ybWFsbHkpDQpNb3JlIHVucHJlZGlj
dGFiaWxpdHkgdG8gc3ZuIGNoYW5nZSBjb21wYXJlZCB0byBvcHRpb24gMi4gDQoNCjIuIFN3aXRj
aCB0byBTZWFuJ3MgYXBwcm9hY2ggdG8gZXhlY3V0ZSBFVVBEQVRFU1ZOIGR1cmluZyB0aGUgc2d4
X29wZW4oKS4NCkJ0dywgU2VhbiBkbyB5b3UgYWdyZWUgdGhhdCB3ZSBkb24ndCBnYWluIG11Y2gg
ZG9pbmcgaXQgc2Vjb25kIHRpbWUgZHVyaW5nDQpyZWxlYXNlKCkgZ2l2ZW4gdGhlIG1pY3JvY29k
ZSBmbG93Pw0KSSB3b3VsZCByYXRoZXIgbGVhdmUgb25seSBvbmUgaW52b2NhdGlvbiBvZiBldXBk
YXRlc3ZuIGR1cmluZyBzZ3hfaW5jX3VzYWdlX2NvdW50KCkuDQoNClByb2M6IE5vIG5ldyB1QUJJ
LiBNb3JlIHByZWRpY3RhYmxlIG9uIHN2biBjaGFuZ2UgY29tcGFyZWQgdG8gb3B0aW9uIDEuDQpD
b25zOiBUd28gZXhwbGljaXQgcGF0aHMgdG8gaG9vazogc2d4X29wZW4oKSBhbmQgc2d4X3ZlcGNf
b3BlbigpLiANCg0KMy4gZXhwbGljaXQgdUFQSSB0byBleGVjdXRlIHRoaXMNCg0KUHJvYzogQWxs
b3dzIGNsZWFyIGV4cGxpY2l0LCB0YXJnZXRlZCBhY3Rpb24gdG8gZXhlY3V0ZSBldXBkYXRlc3Zu
LCBhbGlnbmVkIHdpdGgNCmluc3RydWN0aW9uIGRlZmluaXRpb24uIA0KQ29uczogZGVlbWVkIG5v
dCBhY2NlcHRhYmxlIHRvIGNyZWF0ZSBuZXcgdUFCSSBmb3IgdGhpcyB1c2VjYXNlLiAgDQoNCkkg
YW0gcGVyc29uYWxseSBsZWFybmluZyB0b3dhcmRzIG9wdGlvbiAyIChidXQgd2l0aG91dCByZWxl
YXNlIGZsb3cpLg0KT3BpbmlvbnM/IFNlYW4/IERhdmU/IEphcmtrbz8gDQoNCkJlc3QgUmVnYXJk
cywNCkVsZW5hLg0K
