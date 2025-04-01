Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E551EDA2A;
	Tue,  1 Apr 2025 09:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743500169; cv=fail; b=DGvuevwWxDxqkPnlLd+Fjr7jPyeTO8eRBrxKwTHkPaHn+VX5JY9XTBABb8sXaspkkSHZeNIPMM0dYTDLMN/dsdDSBkTMSQItPOP1F8koTC3HlaSSYXDtgg7CF5KO7iNmUzuygLtjWk2hYdnlnhggXrVNJXAVO7aa6Qkgp6Y/0v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743500169; c=relaxed/simple;
	bh=5nXI8WARV9SYhnBJ9+ki0cmckXX9Et/bs90D8K0JFlM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bfpFe2X0ngHP7ydiWqER7tDmKu8pvVyE1RTWXahYDtfHT+1/GNzbrLAmSuyfGPRNJTgyw/M4EHCNUWwT3C3AWdQWtQfVyMkJeW85kYyIRkqxCnxPCYbnc7AMHd9LiyPTMNJZT6kljroAnAZCx3OGnVF45MhtEToHhYWLzv/AgWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f1Lv9sAa; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f1Lv9sAa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743500169; x=1775036169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5nXI8WARV9SYhnBJ9+ki0cmckXX9Et/bs90D8K0JFlM=;
  b=f1Lv9sAawkhvjAXWPghmFpEreiWhhJuzBV+hNnRCtUPv1+4Wm/nda7lz
   /0/6/PTB9Sbb+EX2crdX6HV28vXFYNaW1CsYgoew2CreFP7FdJOqpEfRA
   SU+4j3xMpVFWKiLKDZ/aMcDMLQHnAbounRqhmTHL/rKbEekXM31/8bMOB
   uyFK5KKPUAkpxfJSs87R5Xgw+fLhGPQlaDQ7Jhk6LbiEErc4naVXEhwuW
   1BnmoeULzF9YnhHXZR5xNm0on/e4QHtbi2bSyKUecRHdLzh4jpYJb1J97
   7r9RpYlo4+r6mPCrjSXXQoru94lFsZhWA7UvRtgHsOD64ULLwnA2Cuc6m
   A==;
X-CSE-ConnectionGUID: 95tNxu8bTtO9OgoE/LMadA==
X-CSE-MsgGUID: pIsSrvnfQ6OVIRqqf4TJXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="55008389"
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="55008389"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 02:36:08 -0700
X-CSE-ConnectionGUID: MWJcg+yMSHStTaKgDSrATw==
X-CSE-MsgGUID: Di28wvf9SmaNkdMgns1YZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="163567421"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 02:36:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 1 Apr 2025 02:36:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 02:36:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 02:36:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WkXuAB54aI50ay9RXTmPNXgj8974iDPlzx/m0H/mTSEIqhnj9aSvR+h7AAnTzsC0sEn5Y8cW/7vo8KSkvdMexlOlZaPn+rnV5DuNzdUdQpzm7x5UIBEOpZMLkgqVuPHkdnuD50jq+5OtPsis6H1hfZ3WeYQ+o+sO0L86NqTouPTeJv6n7yN/TojUhBYiJ3qt5uerlIAipDP/8LPJkCTGw4De6/Depz9PcRDhxqdmygSsU9ZVvPxKRFrvydapG0Dxu2XVi6aItWYCAy6JUBVz23tj+B728cP5c0QXUvpxPhGDPt/ukDciozY+YDKX/u4IAkyzYNPSjmTTwcAk1Q4otg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nXI8WARV9SYhnBJ9+ki0cmckXX9Et/bs90D8K0JFlM=;
 b=qdGqH+GTHUbh2tszsCE/Ithfncf2Vc1NSXigOpJLZw6T4wJqbi4Aefbb6TjIRsfShz7jqb6DTiJ90raob2RlSLCHkltOjoXndktCB3T/0+1Z28W4IEt2Y7ZAEZM9x6/6zq5Yuh5fNhFLX7uhWFi6+Nf5cCxRMirwGXefEwqE92dNR/keU5e6IzZOn/cxx45o7isPw+agASlj/n8nCi0bVBbb6acW0YnTDCaGDsOX5vhuTTyT/1Gr7FIGktM1qqfi5UmsmcZtgAL/g/VnymH2c0xkmH8p0RsruYhgzEcZ1AYoizWZq1QimLKfsKMWtbVtv2ZheAa+Ee/HnRwLWl5glg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CH3PR11MB8467.namprd11.prod.outlook.com (2603:10b6:610:1bd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Tue, 1 Apr 2025 09:35:33 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.048; Tue, 1 Apr 2025
 09:35:33 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbn+FDiJjsRSw2cUyPYDKGfVHjnbOI1BeAgAAEgICABAKjsIAArrUAgAEIZUA=
Date: Tue, 1 Apr 2025 09:35:33 +0000
Message-ID: <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250328125859.73803-1-elena.reshetova@intel.com>
 <20250328125859.73803-3-elena.reshetova@intel.com>
 <Z-bhczXA6aHdCYHq@kernel.org> <Z-blOQ94ymUsDwPn@kernel.org>
 <DM8PR11MB5750C88DFC518EB77B0D613FE7AD2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-rU_JXWn0vCdBr_@kernel.org>
In-Reply-To: <Z-rU_JXWn0vCdBr_@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CH3PR11MB8467:EE_
x-ms-office365-filtering-correlation-id: a096d03a-5813-47cd-3f73-08dd71008cbf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NHBJV1BYSEN2aDZIUjF1eW1DcDA2b3BFK09UWEFHeGRzTk5EUnRKdzlVcFMz?=
 =?utf-8?B?Mllzdm5GZTd0MHFZb09KdXNYWFh6eDFYQThLZ0hTbEF3WEo5eTFiWkd2c0RH?=
 =?utf-8?B?aWhlNk01MzhCSjRYMVZacis0c1FTVzNOMmdhdkJIV05TWmd4dUV6Vk1GVmhJ?=
 =?utf-8?B?U3pBMHJTVmZnb2Y5RGlMcStraER4M09aaW5OWnl3VnRLWlplZndLTVk5bTVR?=
 =?utf-8?B?ZjdIdzVwTmlsbXg3cTdybHJhdnE5cDNMcVk1RzQ3SVdLa2kzUWQxeG45TXJW?=
 =?utf-8?B?aWdzdURpTUZ2OVgySkpQQWFHcjB5S01abURKY2FYMmtMRU1WMjQrVmxGOWxI?=
 =?utf-8?B?ZG13eTJHRU1IUHNiN3B2SnIvN1N3VTltb0pEa0FXdE9kSGtFNVVVd2JuSDNk?=
 =?utf-8?B?Z2t6RlBTN3BVUmtrNHNaUTMxYU1QUlkzRjczbnB1aFp4RWZKMlNtV1RJV2xT?=
 =?utf-8?B?bkg3aGFoRkRTRGpQNlhZcTFzR2QyN2lTY3BtZlB6ZWljdDloVjhpMlhWVHF4?=
 =?utf-8?B?LzczK05sQzhDTXRSMFdvUUE5M3hnYkpRQmZVcm9RQ09wWjBrZ29SUHE2VUdn?=
 =?utf-8?B?eFVEeW14RXBnL0NPZmdpc2thMEs3ODZTby80MHpuVW1BREV5WktTWEZjQmY0?=
 =?utf-8?B?Y1BYYTB3WmlwRjZZb2ZZaHR3WWhWYTNjVXBtS1NIZDVpWHdRcG1OYUE1V09q?=
 =?utf-8?B?cXlnOFkzcHlMRUxzT2djdjNjekZEa2hjbUFFbHhyd3BocDNxN05rUTh2Y2xB?=
 =?utf-8?B?NkwxdkdIT3ZiNGowTFVPVzUyRnk4SUxHa2t4UFVBeDI5bHI4elZSYklBWXlm?=
 =?utf-8?B?c1FqL2wwc0FnME5tOU5DYUR3b2xYSnZuVjI3SUxuY1BBWnhWU3ZDT21NNHFD?=
 =?utf-8?B?ZmtNUDQ1MzdnZ1hua2hOelFRTXlHdHBmKzVqRFJvZS9LbWZQR1piY25JYXJJ?=
 =?utf-8?B?YWRGS25IOG5nS1V5cUZvMGFiTTNYMHBvQjBVNmZ2aCtkcW9oWlkrdUU3ZWJw?=
 =?utf-8?B?VVBvYjNvMXVXV3pVY1BJTVBtbkkrVUN4bVoyd1NldmIxaUFpTmxIcnovYWo4?=
 =?utf-8?B?clljK3NydEpheFNpd1pPbUlTcGZobVhjWGpYWE1iRFBVeW9lc2J2NG5Gc0dI?=
 =?utf-8?B?ZG9OTlBBNEZkVzNvZ2pXZHYxRVNhUVFscmJBSjdFMUUxWFBSYWVpTlFjRDlE?=
 =?utf-8?B?cVhCTG0yV1R6Uzc1UjlTR2dNNVNkV1ozWGwyUEhzcllTQ1N1YTEvU3BKOGN6?=
 =?utf-8?B?dnhpdmJ0d1p2UWg1N3JiTElHRGtQTW55ckYwc0RxMVBRd1owYXR3WVJNS0lN?=
 =?utf-8?B?QUtvM3oxRDBvVitrS2k1UThlNkIxQTh5cWV6VDBuVUZMaXJOc00rdmNVSE9t?=
 =?utf-8?B?b3BYUXNoa2ZsU2xkY1BHNjJ5WlF5MmlWWTJWTE95SjErTTZ5OGV1Y2ZOSGdK?=
 =?utf-8?B?dHQvWC9iRWIyVEF6cmlsbDJPREtWWTF5QjVIQXM5VmV0QzJOZEEyb1JyOEMx?=
 =?utf-8?B?ZnBXVHpHajE1dzBVSExlUUVLZXNxMzdaZFJDZmk3Q1Z5cTMvV3JYVVBjaEd5?=
 =?utf-8?B?NW9VSVh5Yy80cUVyNjR5RFZxRXZFc3N6aTJkSURocnBENGswNGJ1cTgrdDUy?=
 =?utf-8?B?bm1qU1VMUmFVRjlMSWJIYnQzTmtKaTJxYm0zb1hIWmFGRGtwWVBWaVlNQmUr?=
 =?utf-8?B?YWRGeVVaYXRaWUEyMnZlc2JPUTd5bmFxa2lsZDg1ZkNOZTJwbHM0Y1dEL3NI?=
 =?utf-8?B?aDlwYmx2OTFadm9QdDlhYTVoa1lWdURvaFZhV0p3eWs4dlYvL0k3L0lLa3Ju?=
 =?utf-8?B?OW5BNnJkY3dvUE1BWXVoNENyakdSTjd0MU4xSFRZc3AwOGFsMGtUOXVoVUxI?=
 =?utf-8?B?dWF6aG96eElzem5HSzlHYjk1Qkx0ejJXbEhnQ0k0RjB6KzJCK042eEVSaklT?=
 =?utf-8?Q?gj9JJj6UHt7QL7TGNz9Ked2nxnW/2a+x?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkV1cENmWS9HVWNWS3VNTW9mZlZrZnVMdDQrdUlxY1VROVA0VmFBYnA5WHB5?=
 =?utf-8?B?TUw1Uy9hOFJwaEdPRzBoQldjM2dsSE9zTitIZEtoQXYvck15dnRmL1g4R1o1?=
 =?utf-8?B?eEFZSy9LZDNHRkZWdk02dC9wYnlGTTZ1clhyVFUyZmVWMnlQbWJnVVJOaWkv?=
 =?utf-8?B?WG1tbEpsYzROM1krWGpxR3F4cGRuTi85eDUyS1d6ZWVLUENWdHJoU0hGbGh2?=
 =?utf-8?B?c2RTRmR5QTc5Y3NOMGRMQmZBOGVpY1Y5b3RBa2RON1hSVUtOZzN4bVJ0Z3ZY?=
 =?utf-8?B?cEcxeHF0Qk9qeEsxVkN2a2IzRW8zRFc5S256b2MxOS9jUEJaUWhwYWRXWHRQ?=
 =?utf-8?B?SitHUGZvY2ZvSFRtWE14emNKVkNOd2UrV3N6Qks5UEVyQjk3WFVEZ291Qm52?=
 =?utf-8?B?TXZGT2pxUk1uQVh4bzVkMUZsdk5kam5YVDg0VlNUTWJUcXY4QXN6TjJmN0VO?=
 =?utf-8?B?SUV4RktxOWJ4bDhCd1hhTmpXRlIxamFUcndVc0RmN3EreFFGRUhpdWxDWEF5?=
 =?utf-8?B?dUtsU0ZweEp1V0dTL0VWVTNpS2ZXL3lzR1hzVnpYTWo5SDI3U3FNUTBUWktl?=
 =?utf-8?B?VDRVeldUWW41NE5hcmZ4UUFZWGkwL3p1VW1LQmoxa3BRM0FGQnh0VGJFeVlo?=
 =?utf-8?B?YUV0YlNzSnNnNCtvVXpwS25wdXNOS3RsTGc3bTI3eUpUYWQ1U1ByL1dPSDFp?=
 =?utf-8?B?dmJoSnVKbWgzSGphS3A0bHBvREFvcyttOEpVSjd1LzFNczVadnlWVExPZUc1?=
 =?utf-8?B?bzNwN2RFWXFIdjhrbkdGbFArRmRFQis2UVpjVTA5ejJIMStDRGFpTWdUMkRJ?=
 =?utf-8?B?Mm43UEdNbk8vR0pHdzcwRUMrbllET0oxUG1LVk81WHFZY2dlTDNIWCsvQXNX?=
 =?utf-8?B?WXhJZ0V6WkxaWFJoMGtyYU1BRjlzSlFCZHpSRXlmTHY2QWcvZld6akRLb1Z4?=
 =?utf-8?B?dFNrZG1rU1RQN0VsRm5qenlHOXBDN1VQMGJVYTdCZUR0T00vY2RQbkFlWFNH?=
 =?utf-8?B?ZEZpSUcrVVdONEdhdnU0WHRJQVErS1R0T0dCUWpVVXFQaVRjT1dkR01WZTBO?=
 =?utf-8?B?bVN5WFl6UDBxblpNaGs4VVMxaDlKUFI4ODFyZm1ad1d3cTM5MUVlMmVJRWJB?=
 =?utf-8?B?UHE5alFZY0kxaVZyY0RBNGo4WnI4TkJJaWZhSlVrRGtiRHlaSm1OWHV3aG1B?=
 =?utf-8?B?Y3ZLc1cyT3RaUkpGeXNlbzUxWmx2QTZzUWJ2NkM3WENvM2hYV1ZnZnhTNjhN?=
 =?utf-8?B?RlFvTDJyNnF5TmZWRWp5UjI1SVc0em05RGpXdEhxN0FQOForVm9BZlZOeEM0?=
 =?utf-8?B?VXhnVkVpeXBDZzJhUW94cE9ibG55bTNyUE1CSGJwSkpKVFNjZ3IvL01RbGlB?=
 =?utf-8?B?eUJtc1lQeENTY1ZFem9oZXpDOVVUYWp4NzBUcGpONFFMWDNnTmdwSXJEOEF3?=
 =?utf-8?B?c3k4R2pCV3grb2tnemRQaDZLUFlNZ1h4ZExjVnByQTEwZWJFVzBDWkVwNkUw?=
 =?utf-8?B?TVNNbkVUWExGZVBoUGJlVCtWQS9MREpjNUZLL2dTekV3STI2amhYNFpCT0pa?=
 =?utf-8?B?WFA4dnNha3NSVUQxOWFTTzVVUG4yejhtMGtWOTNvNEZ4TE9JNDFkVHdEUXla?=
 =?utf-8?B?SnNEMUhzTVlaQ0d1QzlWemdpV3VpczA4RDc5V0pWb3VaOVQ5UnJycG1FVmxn?=
 =?utf-8?B?U1VzK2NIdWVaUWF5ODNIQ3hNYXZmSzdTWUliaWFtTFMyUnhrb1ZzSkdIeHhy?=
 =?utf-8?B?T29pZGpuSXdYY2RiT2dzTTZ2V2c4QmlQS0JkZ3ZxNXhpa3huaTQ1ZWNyNjF0?=
 =?utf-8?B?SCtDdFVzM0hpemdYTWFPNEk2VFlrYlBjYU9YVUNBMVNBaFJ5MGRIVjQ5QkRU?=
 =?utf-8?B?TGZ4WUF2bldyeUs0cTdCOGoxdEtkNDRKT1pZVmNYTGtCZlFacEpxRlRDSnBt?=
 =?utf-8?B?Z0syUlMxYTNVNzluMFdhQ3lWTzRzQ2VubmM3b3I4TWJuaVN0OUY0ZllzRElZ?=
 =?utf-8?B?NkF4WFpYVzRpYWJyQjJnbG5uVE43MDNFaVVBUHc2ZU9kSndWUkpuY0lwOUkz?=
 =?utf-8?B?K2pnb3B2WEdkSm9WOGxZelhEeVpMMUJUNWQrUHJENG1YYzV4Q0w1R0RRVDVN?=
 =?utf-8?Q?HafRsK2NFhL4bhJwyMiq8d8eR?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a096d03a-5813-47cd-3f73-08dd71008cbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2025 09:35:33.1530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n9/A7OOl0ob1+AfInHJEk6opOCZNkP8hJJF4EHTTcKsANor3KfN1oD3Sn2ljDOOEb43RjLVZZFbmkbwvNSdAU0JzjWDVyrif+OjonX5fq5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8467
X-OriginatorOrg: intel.com

PiBPbiBNb24sIE1hciAzMSwgMjAyNSBhdCAwNzoyNjo0NUFNICswMDAwLCBSZXNoZXRvdmEsIEVs
ZW5hIHdyb3RlOg0KPiA+ID4gPiA+ICsJZGVmYXVsdDoNCj4gPiA+ID4gPiArCQlwcl9lcnIoIkVV
UERBVEVTVk46IHVua25vd24gZXJyb3IgJWRcbiIsIHJldCk7DQo+ID4gPiA+ID4gKwkJYnJlYWs7
DQo+ID4gPiA+ID4gKwl9DQo+ID4gPiA+DQo+ID4gPiA+IE92ZXJhbGwsIEkgdGhpbmsgeW91J3Jl
IHJpZ2h0IGluIHRoYXQgImludmVyc2lvbiIgZG9lcyBtYWtlIHNlbnNlLA0KPiA+ID4gPiBub3cg
dGhhdCBvdGhlciBzdHVmZiBpcyBiZXR0ZXIgYWxpZ25lZC4NCj4gPiA+ID4NCj4gPiA+ID4gQXQg
bGVhc3Qgd2hlbiB0aGVyZSBpcyBzcHVyaW91cyBlcnJvciwgSSB0aGluayBpb2N0bCdzIHNob3Vs
ZCBzdG9wDQo+ID4gPiA+IHJlc3BvbmRpbmcgYW5kIGRyaXZlciBzaG91bGQgbm90IGRvIGFueXRo
aW5nIHVzZWZ1bCBhbnltb3JlLiBJLmUuLA0KPiA+ID4gPiBpdCBzaG91bGQgZ28gb3V0LW9mLXNl
cnZpY2UuDQo+ID4gPiA+DQo+ID4gPiA+IEkgZG9uJ3QgdGhpbmsgdGhlIGRyaXZlciBzaG91bGQg
dGVhci1kb3duLCBqdXN0IHN0b3Agc2VydmljaW5nDQo+ID4gPiA+IFZNJ3MgYW5kIHJlc3BvbmRp
bmcgaW9jdGwncy4NCj4gPiA+ID4NCj4gPiA+ID4gUG9zc2libHkgdGhpc2ggc2hvdWxkIGJlIGFs
c28gcmlnaHQgYWN0aW9uIGZvciBvdGhlciBlcnJvcnMgdGhhbg0KPiA+ID4gPiAiaW5zdWZmaWNp
ZW50IGVudHJvcHkiIGJ1dCBJJ20gb3BlbiBmb3IgY29tbWVudHMgZm9yIHRoaXMuDQo+ID4gPg0K
PiA+ID4gT3IgYWN0dWFsbHkgYWN0dWFsbHkgSSB0YWtlIG9uZSBzdGVwIGJhY2sgd2l0aCBteSBz
dWdnZXN0aW9ucw0KPiA+ID4gYmVjYXVzZSB0aGlzIHJlYWxseSBzaG91bGQgYmUgYSBxdWVzdGlv
biBmb3Igd2hpY2ggSSBkb24ndCBoYXZlDQo+ID4gPiB0aGUgZGVmaW5pdGl2ZSBhbnN3ZXIuDQo+
ID4gPg0KPiA+ID4gVGhlIGN1cnJlbnQgY29kZSB3b3JrcyBsaWtlIHRoaXM6IGlmIGFueXRoaW5n
IHRoYXQgd2UgZG9uJ3QNCj4gPiA+IGxpa2UgaGFwcGVucywgd2UgcmUtaXRlcmF0ZS4NCj4gPiA+
DQo+ID4gPiBTaG91bGQgc29tZSBvZiB0aGUgImV4Y2VwdGlvbmFsIGNvbmRpdGlvbnMiIGhhdmUg
YSBkaWZmZXJlbnQNCj4gPiA+IHJlY292ZXJ5IG9yIG5vdD8NCj4gPg0KPiA+IE5vbmUgb2YgdGhl
c2UgZXhjZXB0aW9uYWwgY29uZGl0aW9ucyBhcmUgZmF0YWwgb3IgcHJlc2VudCBhbg0KPiA+IGlt
bWVkaWF0ZSBkYW5nZXIgdG8gdGhlIHN5c3RlbSBzZWN1cml0eS4gU28sIGFsbG93aW5nIHRoZSBy
ZS10cmllcw0KPiA+IHNlZW1zIGxvZ2ljYWwgaW4gdGhpcyBjYXNlLiBJbiBjYXNlIHJlLXRyaWVz
IGFsc28gZmFpbCwgdGhlIHN5c3RlbQ0KPiA+IGFkbWluIHdpbGwgaGF2ZSBhbiBvcHRpb24gb2Yg
Z3JhY2VmdWxseSBzaHV0dGluZyBkb3duIGFsbCBlbmNsYXZlcw0KPiA+IGFuZCBkb2luZyBlaXRo
ZXIgYSBmdWxsIHJlYm9vdCAoaWYgU1ZOIGlzIHRoZSBvbmx5IGNvbmNlcm4pIG9yIG90aGVyDQo+
ID4gbmVjZXNzYXJ5IGFjdGlvbnMgbGlrZSB0YWtpbmcgdGhlIHBoeXNpY2FsIG5vZGUgb3V0IG9m
IHVzZSwgZXRjLg0KPiA+DQo+ID4gRG9lcyB0aGlzIHNvdW5kIHJlYXNvbmFibGU/DQo+IA0KPiBV
a25vd24gZXJyb3IgSSBkb24ndCB0aGluayB3b3VsZCBob2xkIHRoYXQgcHJlbWlzZS4NCg0KVHJ1
ZSwgdW5rbm93biBpcyBhbiB1bmtub3duICkpDQpCdXQgdW5rbm93biBlcnJvcnMgc2hvdWxkIG5v
dCBoYXBwZW4gKHBlciBTR1ggc3BlYyksIGFuZCB0aGUNCmN1cnJlbnQgU0dYIGtlcm5lbCBjb2Rl
IGRvZXMgbm90IGhhbmRsZSBzdWNoIGVycm9ycyBpbiBhbnkgb3RoZXIgd2F5DQp0aGFuIG5vdGlm
eWluZyB0aGF0IG9wZXJhdGlvbiBmYWlsZWQgZm9yIG90aGVyIEVOQ0xTIGxlYXZlcy4gU28sIEkg
ZG9uJ3QNCnNlZSB3aHkgRU5DTFNbRVVQREFURVNWTl0gc2hvdWxkIGJlIGRpZmZlcmVudCBmcm9t
IGV4aXN0aW5nIGJlaGF2aW91cj8NCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuDQoNCg0K
