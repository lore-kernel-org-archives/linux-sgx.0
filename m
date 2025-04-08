Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C192E7E1;
	Tue,  8 Apr 2025 00:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744070797; cv=fail; b=XzJ2Urrw7qZSXmht6hDgWNvkHK3vVcxAXhcclz6DhSnOMV0wqG0Qcfqy8jbvSdhcERJ2kVQ2BjLKRBOloMdDtTqWOFKImKESiicw/E+nSKY5JKi/8vibYHhCE1LNHKOKE07ANQfgJ/W7tu+areUpvqXLxWRqRUBAbDOFT2Fjg+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744070797; c=relaxed/simple;
	bh=/VLzby+Bma9bBhE/UEyzz17avZyucGuMjL45GhZBu1Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n4SjzrtdFQzgcYfRI23JhEXCWXFrORRfhSj/hSjzmjt74lbm4zMhrSgmYbeAZr+N/bpsluy1k0EbUd5VclZIMZNVMmTTHxbmgYtn0pvu41oQADhYlN3OhAOsZTF3RUrkyoqumNwvjRti9k1YCn3s6nfizI3a/uIQ3zj+zDkLP2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hKWD8YzW; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hKWD8YzW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744070796; x=1775606796;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/VLzby+Bma9bBhE/UEyzz17avZyucGuMjL45GhZBu1Q=;
  b=hKWD8YzWGUJ9zIy/M3VtqM2wOsAvhwp6nwerBhhsul67+xgghWcRjWEy
   dDV2gBbCIgV04rpzqsPmhi+XfoNBE98wYn4l/9/LdlQ06elrD5n7mJ8Bu
   MP8asRrFmaxUeQ7R8U+pBmqdeA7ZrE0qfDTz6OzaV62A0S8glCn0zm4rd
   10JbQHAWoSPDM4y2JBobTORiFtCxyfmC1P1zf5X6MvYSAcveiifRpvm/w
   60K00VijMpwf8xKydugsHds9L5lDUzyzKQ046NTl6o1LytpkBmSKAIGW0
   JWX5/NABYscsgaEUcIGuQDoZ2nBWC1y/wvFWVSj3Vqy8F7dl1GjX4Ee6C
   w==;
X-CSE-ConnectionGUID: PBKDP0e/QcC9QHOp6kcgOg==
X-CSE-MsgGUID: rQzet4H4TRuIl3Z6Dv039Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="45618106"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="45618106"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 17:06:35 -0700
X-CSE-ConnectionGUID: /RVXgfQ2SGGhu89wQ3y/pA==
X-CSE-MsgGUID: ZjJP1mzHTYmI6XJVgmuGuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="128634724"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Apr 2025 17:06:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 7 Apr 2025 17:06:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 7 Apr 2025 17:06:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 7 Apr 2025 17:06:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wBI8106MHqCa3v0NicpSPums4gp8omrHT+Vs5gB/dlrQQI2ABKhcuv9X6KrS5WadaowKfNNoxlJp6cqFBlAMaHoPyivZfGhCQaqXUmLHu01q0EzEui4Dw6baQ4TRpHssXjpxGNrSK2MUVWl1ZsM6BgTFwy8wav6CXnPQCuLWWdyV0ZGU0QQ8Bv+0fkqHR8C6PBhx/JvJct7cobMCK8OBrwAVxrjCmNQJRTif8logPILRhGAFsoeFIy3aUTs2AA18BoHJjQlTOUNHXdxStw9X9F5sERH13BI+hpEIDbP1C22Zf4gvILBZOQSKwGEF5F81jPjhaGIgLkp4bKtubYiiEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/VLzby+Bma9bBhE/UEyzz17avZyucGuMjL45GhZBu1Q=;
 b=wp/wfJJPOnAWsguX34dsVbRuIMKKusKIWZOItgblTotDz7CVSQ5BZX49db7TMn660mMJNTI6ad3aInzOhVBuTkse8MrVhUdE1LI8aXFnjLmkuj/1/OKpx4TYENG78V39sXwZ+/bR+cXg5UiE+K5yQXqwniSnGtO7Tthtp5dpjAWyEaUBDjGO6mxkI0UC046W1Q8OeZv0d/YjWBcukIySNvm5lTdpzgC7wFyEjFpZmy48uhtQkFW6FHHGhLxKA3szvza3aYYb5yJnlXTesCfCKa2NIkLz0otQEm/kApHdmOb3osE7QsCg822drlm7dzTJUb+7xS51aKo+Cb8Y4/TU3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7794.namprd11.prod.outlook.com (2603:10b6:610:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 00:06:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8606.033; Tue, 8 Apr 2025
 00:06:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: Re: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbn+FbDddn6LLQpkO2vjabIxCh+rOI1BeAgAAEf4CABAQqgIAArS8AgAEJIoCAAFIzgIABfHKAgAH3RYCAAMO+gIAAD1QAgATAwoCAAQeUAA==
Date: Tue, 8 Apr 2025 00:06:32 +0000
Message-ID: <a0a803275d317f88afdd757afa30e84a26b05656.camel@intel.com>
References: <20250328125859.73803-3-elena.reshetova@intel.com>
	 <Z-bhczXA6aHdCYHq@kernel.org> <Z-blOQ94ymUsDwPn@kernel.org>
	 <DM8PR11MB5750C88DFC518EB77B0D613FE7AD2@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <Z-rU_JXWn0vCdBr_@kernel.org>
	 <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <Z-v4WfcLhmXbYvaa@kernel.org>
	 <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <Z-7dqQCiu5fWZ9a9@kernel.org>
	 <DM8PR11MB5750131ED71BFF175E3E329CE7A92@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <Z--OuMuWx8jUdSU1@kernel.org>
	 <DM8PR11MB575046992BEACCD83164043CE7AA2@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB575046992BEACCD83164043CE7AA2@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7794:EE_
x-ms-office365-filtering-correlation-id: 1a4ddc86-882d-4eac-3e6c-08dd7631380a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K2VUc2FuNmpKSkNHZ29keXFtc1R3clJxbVFjbkd0eXZDd3M3NWoySENMa0F4?=
 =?utf-8?B?SXdvR2xPZ09OYTdyWGFlZFREelVOelVQZ3VaZUhua0RjRVd0OHRvTjFVaUdZ?=
 =?utf-8?B?V3FUWmo0YzBmVldxRi95U0VldFVpREY0NHEweWI5NEpFdk5MYjYvaUdIdmpN?=
 =?utf-8?B?NHJxQzlmY3J3Q2J2SXArSlVaVjByaG9zVzNFTDEycXE3ZlIzbFcwaVROSEpH?=
 =?utf-8?B?VVp4eVRqRldBdHRHNWZnZE9zNmVQYUc2Y295ZlFaMDdlL1lDUDlPbEdwRmJQ?=
 =?utf-8?B?aC9yc3ppUkJhMlZaM2pMUm1WZmcvRDVWbTUzWFF0eElLVGxQVUdGb3NrOEh0?=
 =?utf-8?B?RUZaSU9UMU1SSS9OOFlYTGEvdWgrZTlVcEd3V1lHS0Z3RFFYWW95N1ZFTTU2?=
 =?utf-8?B?dGlOdzQ4Z2ZaQmhtMS9EWUhMS2hIbnFjUkpHNm9XUHZOQXhuLy9jOGloalNr?=
 =?utf-8?B?V3hKS0ErdUx5REw2SHdQQUkrUlFnNllTNnl5d2RZSHhyYUhDL21oYTVDdGE5?=
 =?utf-8?B?bEhpV2FRbHptV0l5a1VLM1p5UWEvT2IvdmNMazBCNGt0QjdweHA0aTRleE5y?=
 =?utf-8?B?Rjc3d2VKWTVweE1RWmtGR2cva0dyT3NFRzhPMzhmOFNCNlU2NUJZMHFvamFt?=
 =?utf-8?B?K3ZDSklJNlBYVzZOWXBCTzNKSnJFSlFpSG9ld0lPQ3VuU01sSzNKQjBHU2g1?=
 =?utf-8?B?VVZIejF3ckx3UDhhdlc4VmlhOEFPSTNjSWh5SlViY1hQd0hPajdYaGhPYzNt?=
 =?utf-8?B?TjY3aHlhMDBHZDFCNWpkQ1hNdnZkci9ZTFpTemd0eDgvcGFOaUhLUjAxL0pM?=
 =?utf-8?B?WmZnWjZ2MGFXK3pqVTNuWTEzbXFrU21pdUJtT0tIVDRJb0RQV1ovR0lSbnZJ?=
 =?utf-8?B?RjRqZUFJbzJjd0h0aThZTGNXT2hvTGxuR3pFdi9DeHpra3hKdlFEUER3Q2xT?=
 =?utf-8?B?cVcyTzUvU0dtTng1UjR0bXgzcEFFMU5HTkk1UEZiNC9uczBVYndmM1VRTVZJ?=
 =?utf-8?B?aTNuSDVWL3VIOVRDYll6dkdJbTlzZkYxTExwTldpTU00dDZOREZidmJZUTNa?=
 =?utf-8?B?NGhha3hMZy9uVkRycDdSRHpBaEoxUXpYaFRZdXdDN2hFNUVFdlJYU1ZuNWRq?=
 =?utf-8?B?YmE1b0cwR095VXpEZ0c4OGdhSGdDY1NOQjg2cDZZWDZMK0JFMnA4ZDE5dW4z?=
 =?utf-8?B?dExldS9nRXNwREpsdlhQMko0R3hYZmR5Zjg4V2doQWxWYXRXZmRyZTJCLzhK?=
 =?utf-8?B?bFdlSkdvOTlJa284VkVPNFVBZFVrN1NXcFZiV3YwNVZRVkxMRU5SUXFHS1NC?=
 =?utf-8?B?aFVTWmljOE91L1JTbVJCZmFKTTRDVUZKVDVIWG9MeXZQaDlWdllreGVJVklH?=
 =?utf-8?B?bk1sbkdtL0xCd0FwL1hCR3dTMzNPb28yODNzamZjZ0ZSZjF2ZkRnSktaTExM?=
 =?utf-8?B?REpYckIvc1VHZGtjRk40LzVGenN0NFZWd2hxNnNYRFlUNmQ4WGx5UnN3RFNl?=
 =?utf-8?B?RFg4amVoY0xvTmlYd0kxZFhCRE5MQldDNTN4R2xLeExmZVgwenlmSWdsekIw?=
 =?utf-8?B?U0Z0bmxORXpDaE91QjN5NTA2czFWQUV2aitkRFpObXc4QVBqZzlZVDVBclI1?=
 =?utf-8?B?UmpuY2JoaXkwNmR5bHk1WUp1SG1sYklyb3RwZWZYdFJ6ZlJNeHhOWXVoRWxI?=
 =?utf-8?B?TnNLM2RKK1J6TTNGSmZ0TGY3elhxOUtjeWN4MFYxdi8wWWRvbzNBNVkrT0Zt?=
 =?utf-8?B?eVV4T1pEclY2VFBnZTYvcFhYWFFlR1pwN3RBU1Y2RUNSSzBSL3VTc0U2VUhZ?=
 =?utf-8?B?c0ZMcTRnbWJpSEQ0NEJoZjRjdk5oUDNVUEVhVGJBUkcxUDcxUDNreWFSODkr?=
 =?utf-8?B?SGNlRmxDUGJCWXlVMzk5eTVoanRBQktvMnFGYURoUXJISVdXOU1vNm9FbHB4?=
 =?utf-8?B?MWdCMVVPdVlKQlRvMDlkdEh1YjFTc21GZk81akRmc3Vva1l6M0h5ZkQ1Uk9O?=
 =?utf-8?Q?kLbTsG2/CZlT1yid9KI3vFoIdS1pKM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFZRcmNyUmZnZXJOdVJ6WUU4ODcwd2pLVnZ5d3RhcmJoTUQydEZKUnRGdS9R?=
 =?utf-8?B?TmttZmJHZG9xNTVYWU5XQmZkZFNMODQyUThkeUJTTWNXWkp4b3hoYWF6Ulh4?=
 =?utf-8?B?dk16cHdxMWlDRDd2QlB0VHJyVllUTnhlRUw3bjN3SXhNQTh4NGpwQ0M1bnlM?=
 =?utf-8?B?eWs2bFh2elQ5Q09TT3JaRXNUbW91TmZadFM3TTFsVzdDUjNuT0VQS2t3UUFa?=
 =?utf-8?B?Nmdycm1CY0hHKzdPV1NPejFENjlxL0JNS3lCM29rRWt0eHkrWm1zZ3VvaTRa?=
 =?utf-8?B?OVJCUVhwbXhHSngzKzdFZGpnYUFqMmxjQ1M4M3pLbXB0RWd4U3VFdHhOdThP?=
 =?utf-8?B?RVdmVnhkNlZyNnFkbkNLakR1b2NIVTFGTTdNT284VDBrUU9oYzJpZll3RU9V?=
 =?utf-8?B?cUtpTVphTk1QdTFRS2ZOck5iWEJ5SUNWWTYyWmlVSlB6YklPelMyNDByTVly?=
 =?utf-8?B?cHRtOTJjaTl1ck9HTGQwYXdqZnNQRFZiME1LRzAyVXNGRWF0cnlQN3MwdFlL?=
 =?utf-8?B?QkZPVDl6ZzBjZXMwKzduaEYwN09SVGpueUhINlN5TkdkM0s1TDVQUzgzYkg3?=
 =?utf-8?B?RW9wSjR4cVdwdjdrTDBvdUlFd3FzNGhtSGhYQlYzZm5KREFROEMyQTROVjg5?=
 =?utf-8?B?bkF0RkNhOEp2OGx3Y2E1RUlHNUZjNjVUSmNNdkFjS3lFRjdVbjBEdGlScnRD?=
 =?utf-8?B?eVBuU2dnZk9LbGxqZ000MTV1dTF6VnB0UlY5bVViNmJjaWdiWXZhUmFMeVFp?=
 =?utf-8?B?UWxUWWR1S1I5OW5idW5hb1p0cDhkeldoWUZuQ0VsbUI0NlZESkplbVozbzlt?=
 =?utf-8?B?dlZCNk5JV3RuTCtPY0oySnVTWGNEdEdjNHFYNjhrV0cvUmpyTDZ6bW13dkZL?=
 =?utf-8?B?dVprQ0xPWm1VRUQ4YVh1ZXVONGdPc04wS1hpT3dvYUVxQkVrU0ZoMWFjU0hI?=
 =?utf-8?B?QVprc2tROW1NNTB2R1p5bmF5UmZNRmVZYzdLZDV5YWVhdkVZWk4xT3diekZM?=
 =?utf-8?B?OHdsOURMRGtDRUExZHkrQ0puaU5RWWE5N2hRZ3U1UFRpQ3B5R1B1anNxM09Z?=
 =?utf-8?B?YUJvTTExbytjcG43d2dFYUNITThlZ0Jkb2RSRTcvVWx6WnAxd21Sd2tlQ2My?=
 =?utf-8?B?NDluWVFsblpucDl0NmRsT2dSQVYrVzQxUU5nYlRwdFV0RlRaNHV6NUFnVHRi?=
 =?utf-8?B?RjE0YzdhU1MvNXNkTmhrS1M4dVZ5UjJvbkNtclhCWWtRMUZob1JSWFJLZy9n?=
 =?utf-8?B?RjRhRUxjRU1TNUxJaDBjSWM1S3g3dVJxQzRKNmNhVUJMQnhvYVlzUXFpbnFH?=
 =?utf-8?B?bUJxL2d0bjhhS05ETzA3cURTWjZFTnZmdjFjZU5BL3FKOWF4cEc3YkljM1o5?=
 =?utf-8?B?V2NIT1Z3cFhhMnNiL084VXNLQ2xub09kbEJXUWdTVDZxN0R2SUJpR1NMeTh6?=
 =?utf-8?B?QUc3MGhXazE3cHg3cG5pQ25UYTluSzlPdTBjUEJ6cVJBS3doekk0NVVHUTlK?=
 =?utf-8?B?aWVLeGdKNjJ5dHI2Qyt6ZVJ6NUl6bnNyUlhWb1Rwc3oyeEZCUndKZFB5VEF1?=
 =?utf-8?B?UTNSemt1WXNnV3hZRVNySlNidUVtU1laSTJ2Z0l0T0NFZFVBNWNYRDFUWUdD?=
 =?utf-8?B?b1BDckxkMHJNOFpya0NaWVptSi8zVlhYWEZvRUN6UUNmWVJhTUF4VG0yb3pM?=
 =?utf-8?B?dWFldU1JcklsL0IwZEg5aitGN1pBZUtDdFlTRGRmOWdXd3JFOFk2NkwwZGF1?=
 =?utf-8?B?cSsrVXAyWi9KbHg5UEZtYkVkZWRFMHhYdzRFeU1WbWdmeFpnTG4yTW0zUGdO?=
 =?utf-8?B?aUZRUE5VM2hUMEhXVzdGME1kMjBPSFFkSEZVVExWUmYxN0JnVmMyR2Rsb0cy?=
 =?utf-8?B?V2xkSTYwMHMvTnA5MzA1ZHJBdSthcTVWcDdZOG5ocS9UTmYyVDQrdHRDWlpk?=
 =?utf-8?B?WXpjbWsrSFZoL0VFKzhzL1g3cGo4S0Y2ZG5tKzh5UkgxR0pxemJNRFEvSDd0?=
 =?utf-8?B?ZExIMWhybEY2QU9Sc0VBZ0VxbENOZHRncENOVEl3SU4zeDJzeVBYOTZhL1Fv?=
 =?utf-8?B?aUNNSS9nYVlFc2ZPdXd3QXJ1UTNMUUZuN1p0M3RmcnA4OWEvc0dONEZNUWJG?=
 =?utf-8?Q?o9xeuZZDDTfWDAknMiLI6s1Ei?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4FFE83411B99E4CBC971CEEC59A5007@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4ddc86-882d-4eac-3e6c-08dd7631380a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2025 00:06:32.1783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mqi2hhy/5LC5XTmyqLFM80PSGrxMz5WdoA8P4ueyyLgVHbnqayLKVqAVFNoXwrLwE3Uv6YPcCi6tQftetcWhVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7794
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA0LTA3IGF0IDA4OjIzICswMDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3Rl
Og0KPiA+IE9uIEZyaSwgQXByIDA0LCAyMDI1IGF0IDA2OjUzOjE3QU0gKzAwMDAsIFJlc2hldG92
YSwgRWxlbmEgd3JvdGU6DQo+ID4gPiA+IE9uIFdlZCwgQXByIDAyLCAyMDI1IGF0IDAxOjExOjI1
UE0gKzAwMDAsIFJlc2hldG92YSwgRWxlbmEgd3JvdGU6DQo+ID4gPiA+ID4gPiA+IGN1cnJlbnQg
U0dYIGtlcm5lbCBjb2RlIGRvZXMgbm90IGhhbmRsZSBzdWNoIGVycm9ycyBpbiBhbnkgb3RoZXIN
Cj4gPiB3YXkNCj4gPiA+ID4gPiA+ID4gdGhhbiBub3RpZnlpbmcgdGhhdCBvcGVyYXRpb24gZmFp
bGVkIGZvciBvdGhlciBFTkNMUyBsZWF2ZXMuIFNvLCBJIGRvbid0DQo+ID4gPiA+ID4gPiA+IHNl
ZSB3aHkgRU5DTFNbRVVQREFURVNWTl0gc2hvdWxkIGJlIGRpZmZlcmVudCBmcm9tIGV4aXN0aW5n
DQo+ID4gPiA+IGJlaGF2aW91cj8NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gV2hpbGUgbm90
IGRpc2FncmVlaW5nIGZ1bGx5IChpdCBkZXBlbmRzIG9uIGNhbGwgc2l0ZSksIGluIHNvbWUNCj4g
PiA+ID4gPiA+IHNpdHVhdGlvbnMgaXQgaXMgbW9yZSBkaWZmaWN1bHQgdG8gdGFrZSBtb3JlIHBy
ZXZlbnRpdmUgYWN0aW9ucy4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gVGhpcyBpcyBhIHNp
dHVhdGlvbiB3aGVyZSB3ZSBrbm93IHRoYXQgdGhlcmUgYXJlICp6ZXJvKiBFUEMgcGFnZXMgaW4N
Cj4gPiA+ID4gPiA+IHRyYWZmaWMgc28gaXQgaXMgcmVsYXRpdmVseSBlYXN5IHRvIHN0b3AgdGhl
IG1hZG5lc3MsIGlzbid0IGl0Pw0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJIGd1ZXNzIHRo
ZSBiZXN0IGFjdGlvbiB3b3VsZCBiZSBtYWtlIHNneF9hbGxvY19lcGNfcGFnZSgpIHJldHVybg0K
PiA+ID4gPiA+ID4gY29uc2lzdGVudGx5IC1FTk9NRU0sIGlmIHRoZSB1bmV4cGVjdGVkIGhhcHBl
bnMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gQnV0IHRoaXMgd291bGQgYmUgdmVyeSBtaXNsZWFk
aW5nIGltby4gV2UgZG8gaGF2ZSBtZW1vcnksIGV2ZW4gcGFnZQ0KPiA+ID4gPiA+IGFsbG9jYXRp
b24gbWlnaHQgZnVuY3Rpb24gYXMgbm9ybWFsIGluIEVQQywgdGhlIG9ubHkgdGhpbmcgdGhhdCBp
cyBicm9rZW4NCj4gPiA+ID4gPiBjYW4gYmUgRVVQREFURVNWTiBmdW5jdGlvbmFsaXR5LiBSZXR1
cm5pbmcgLUVOT01FTSBpbiB0aGlzIGNhc2UNCj4gPiBzZWVtcw0KPiA+ID4gPiA+IHdyb25nLg0K
PiA+ID4gPiANCj4gPiA+ID4gVGhpcyBtYWtlcyBpdCBub3QgbWlzbGVhZGluZyBhdCBhbGw6DQo+
ID4gPiA+IA0KPiA+ID4gPiAJcHJfZXJyKCJFVVBEQVRFU1ZOOiB1bmtub3duIGVycm9yICVkXG4i
LCByZXQpOw0KPiA+ID4gPiANCj4gPiA+ID4gU2luY2UgaGFyZHdhcmUgc2hvdWxkIG5ldmVyIHJl
dHVybiB0aGlzLCBpdCBpbmRpY2F0ZXMgYSBrZXJuZWwgYnVnLg0KPiA+ID4gDQo+ID4gPiBPSywg
c28geW91IHByb3Bvc2UgaW4gdGhpcyBjYXNlIHRvIHByaW50IHRoZSBhYm92ZSBtZXNzYWdlLCBz
Z3hfdXBkYXRlc3ZuDQo+ID4gPiByZXR1cm5pbmcgYW4gZXJyb3IsIGFuZCB0aGVuIE5VTEwgZnJv
bSBfX3NneF9hbGxvY19lcGNfcGFnZV9mcm9tX25vZGUNCj4gPiBhbmQNCj4gPiA+IHRoZSBfX3Nn
eF9hbGxvY19lcGNfcGFnZSByZXR1cm5pbmcgLUVOT01FTSBhZnRlciBhbiBpdGVyYXRpb24gb3Zl
cg0KPiA+ID4gYSB3aG9sZSBzZXQgb2YgbnVtYSBub2RlcyBnaXZlbiB0aGF0IHdlIHdpbGwga2Vl
cCBnZXR0aW5nIHRoZSB1bmtub3duDQo+ID4gZXJyb3INCj4gPiA+IG9uIGVhY2ggbm9kZSB1cG9u
IHRyeWluZyB0byBkbyBhbiBhbGxvY2F0aW9uIGZyb20gZWFjaCBvbmU/DQo+ID4gDQo+ID4gSSdk
IGRpc2FibGUgaW9jdGwncyBpbiB0aGlzIGNhc2UgYW5kIHJldHVybiAtRU5PTUVNLiBJdCdzIGEg
Y2hlYXAgc2FuaXR5DQo+ID4gY2hlY2suIFNob3VsZCBub3QgZXZlciBoYXBwZW4sIGJ1dCBpZiBl
LmcuLCBhIG5ldyBrZXJuZWwgcGF0Y2ggYnJlYWtzDQo+ID4gYW55dGhpbmcsIGl0IGNvdWxkIGhl
bHAgY2F0Y2hpbmcgaXNzdWVzLg0KPiA+IA0KPiA+IFdlIGFyZSB0YWxraW5nIGhlcmUgYWJvdXQg
c2l0dWF0aW9uIHRoYXQgaXMgbmV2ZXIgZXhwZWN0ZWQgdG8gaGFwcGVuIHNvIEkNCj4gPiBkb24n
dCB0aGluayBpdCBpcyB0b28gaGVhdnkgaGFtbWVyIGhlcmUuIEhlcmUgaXQgbWFrZXMgc2Vuc2Ug
YmVjYXVzZSBub3QNCj4gPiBtdWNoIGVmZm9ydCBpcyByZXF1aXJlZCB0byBpbXBsZW1lbnQgdGhl
IGNvdW50ZXItbWVhc3VyZXMuDQo+IA0KPiBPSywgYnV0IGRvZXMgaXQgcmVhbGx5IG1ha2Ugc2Vu
c2UgdG8gZXhwbGljaXRseSBkaXNhYmxlIGlvY3Rscz8gDQo+IE5vdGUgdGhhdCBldmVyeXRoaW5n
ICppbiBwcmFjdGljZSogd2lsbCBiZSBkaXNhYmxlZCBzaW1wbHkgYmVjYXVzZSBub3QgYSBzaW5n
bGUgcGFnZQ0KPiBhbnltb3JlIGNhbiBiZSBhbGxvY2F0ZWQgZnJvbSBFUEMgc2luY2Ugd2UgYXJl
IGdldHRpbmcgLUVOT01FTSBvbiBFUEMNCj4gcGFnZSBhbGxvY2F0aW9uLiBBbHNvLCBub3RlIHRo
YXQgYW55IGFwcHJvYWNoIHdlIGNob3NlIHNob3VsZCBiZSBzeW1tZXRyaWNhbA0KPiB0byBTR1gg
dmlydHVhbGl6YXRpb24gc2lkZSBhbHNvLCB3aGljaCBkb2VzbuKAmXQgdXNlIGlvY3RscyBhdCBh
bGwuIFNpbXBseSByZXR1cm5pbmcNCj4gLUVOT01FTSBmb3IgcGFnZSBhbGxvY2F0aW9uIGluIEVQ
QyBzZWVtcyBsaWtlIGEgY29ycmVjdCBzeW1tZXRyaWNhbCBzb2x1dGlvbg0KPiB0aGF0IHdvdWxk
IHdvcmsgZm9yIGJvdGggbmF0aXZlbCBlbmNsYXZlcyBhbmQgRVBDIHBhZ2VzIGFsbG9jYXRlZCBm
b3IgVk1zLg0KPiBBbmQgbm90aGluZyB3b3VsZCAgYmUgYWJsZSB0byBwcm9jZWVkIGNyZWF0aW5n
L21hbmFnaW5nIGVuY2xhdmVzIGF0IHRoaXMgcG9pbnQuIA0KPiANCg0KUmlnaHQsIGZhaWxpbmcg
aW9jdGxzKCkgZG9lc24ndCBjb3ZlciBTR1ggdmlydHVhbGl6YXRpb24uICBJZiB3ZSBldmVyIHdh
bnQgdG8NCmZhaWwsIHdlIHNob3VsZCBmYWlsIHRoZSBFUEMgYWxsb2NhdGlvbi4NCg0KQnR3LCBm
b3IgdGhlIHVua25vd24gZXJyb3IsIGFuZCBhbnkgb3RoZXIgZXJyb3JzIHdoaWNoIHNob3VsZCBu
b3QgaGFwcGVuLA0KY291bGRuJ3Qgd2UgdXNlIHRoZSBFTkNMU19XQVJOKCk/ICBBRkFJQ1QgdGhl
cmUgYXJlIGFscmVhZHkgY2FzZXMgdGhhdCB3ZSBhcmUNCnVzaW5nIEVOQ0xTX1dBUk4oKSBmb3Ig
dGhvc2UgImltcG9zc2libGUtdG8taGFwcGVuLWVycm9ycyIuDQoNCkUuZy4sIGluIF9fc2d4X2Vu
Y2xfZXh0ZW5kKCk6DQoNCgkgICAgICAgIHJldCA9IF9fZWV4dGVuZChzZ3hfZ2V0X2VwY192aXJ0
X2FkZHIoZW5jbC0+c2Vjcy5lcGNfcGFnZSksDQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHNneF9nZXRfZXBjX3ZpcnRfYWRkcihlcGNfcGFnZSkgKyBvZmZzZXQpOw0KICAgICAgICAg
ICAgICAgIGlmIChyZXQpIHsNCiAgICAgICAgICAgICAgICAgICAgICAgIGlmIChlbmNsc19mYWls
ZWQocmV0KSkNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgRU5DTFNfV0FSTihyZXQs
ICJFRVhURU5EIik7DQogICANCiAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUlPOw0K
ICAgICAgICAgICAgICAgIH0NCg==
