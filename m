Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451D42110;
	Thu, 29 May 2025 13:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748526121; cv=fail; b=theFrdvrESj70aKigLMiDOIqGJ7RnnxY0GYx2hsBYN1YvZ1eVOP5/Fc/FwvD6Gb1Pahwn/yX0e68bZtXQqVFIl/rK0Rxa1K+BU2o+B0mw/HxOE8/3NjlEsIPE3lzaGiha/iO6gafh4trZ7vMngEYUcD0psB80KjRGNYEjY25tPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748526121; c=relaxed/simple;
	bh=0+xmcacveWVXfc0X571F4/46iO1Ssd7ufmbVzvbzu2I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a6o7tFtImsRqmDBbZ1CAC9ZcXe1fGjHUIzY9Fi7KIL5eeM+GW1e9xdPE0wGNE+d7vQH5Y/1eRtYboXZziQfmY+lyN+aOkcnSfT4roC1M+ve0Y5eDBqSJnKNUcbVoJH217m6Ba8ycReKwybLJsmrltYQtghdRcdkYJAaBmrDe12M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BY4wXiNH; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BY4wXiNH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748526120; x=1780062120;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0+xmcacveWVXfc0X571F4/46iO1Ssd7ufmbVzvbzu2I=;
  b=BY4wXiNHVF0IqhLCVEEGjSJOS7YNSBDDp+RN3b/HHS3TyWV5TnyoUiJo
   lkeT78CqKrc60xuKoT5JpKjqsIlyRr+Y6izZSi+GblksaRwVv3dMHXQoZ
   1yEnnGQ2MXxHUleybl6wMGwfDK7Shxs2lZfWTym/J7HzVirYddayB2IKf
   EK9taiAG0SKimc47XYXoNZgYHW8LNg7jh560+SeuTMcd55R0tPoYIFB2b
   siDFarPRkzq1bQMhxmkMBN6OI00z48AptSZ1U5ct6z0P+RM3sgIGH69a9
   UqQCd4DTa+srMrQHdzTEdiYdVyqxDfcyqecV+FsmtSonBs9G5nXsRws8u
   A==;
X-CSE-ConnectionGUID: uY34wiJHRd61NFPl5PNibg==
X-CSE-MsgGUID: U3JKlcPjSe2EJedL2jzQxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="50286844"
X-IronPort-AV: E=Sophos;i="6.16,193,1744095600"; 
   d="scan'208";a="50286844"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 06:41:59 -0700
X-CSE-ConnectionGUID: LgDifnssQ8i9MTiwMrRoTQ==
X-CSE-MsgGUID: 8JrG24bzRtuaS6uMgztNaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,193,1744095600"; 
   d="scan'208";a="174568403"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 06:41:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 06:41:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 06:41:58 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.43)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 06:41:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQSEJ1iBq51bXkM+0rb6yOFHzdndi/CBBuXIwMkK0aqNNhQhzAsv38Bop48TSPxNGAQtIxRrubA9J0G6Lj39skEUIakTbKAfZHH3x5M8WcPxxOwSzD47ytafsk6Imday9QBzx5s7cyJV3yEgKE2OCeW99gkBqaZf4E6Ll8q3zu0QT/jSzU7IdAg2D7GKMSK8mGUMVNFJEdWvC9i3nGmKB9jL7ugtTZ0xzvHb/VXQ3xsdErZ5ocZEbZN7tj40cZt7d6veA4ikxPNQP9ghjFM5lFRJJZBfiapUnOqA/tT9Agx4dJtRwNhQeOfezSHr3pwpqhiXt4RYEvsi4NpW/ta8jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+xmcacveWVXfc0X571F4/46iO1Ssd7ufmbVzvbzu2I=;
 b=dQqTCv8VdCYOU07+nbx19Dk/Ww7y4Jmq/pQFJaEcV/VIu7ZlNb4S5LS/7rPfu0CyiKzfSAY4nzoJnYJPehojyBvHRPnm1RiW1t0q7H5Jg4IIaEhY5E+DeBehUzeExiABmjSz6aBvq3SWfVqjpNcHMP6VwOnEUHRGucuxvt3STpAr0vtrPQzNKyQc1PIdLMGWtOhOuJnTLXKgQr3PvbZxUgduuoNOn/JcPfcbFGkpuUMA+AuxfB/z+P6y88G7c3JTlo0N9+ZUQa2RRGuYSQgoa3jtDW58UNpR5I/GiCGSwUy1eDUmynhC6RaCTbamYYidX6qj46+/KRxzoZhCTCEQbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 IA1PR11MB6122.namprd11.prod.outlook.com (2603:10b6:208:3ee::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.30; Thu, 29 May
 2025 13:41:54 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%5]) with mapi id 15.20.8769.025; Thu, 29 May 2025
 13:41:54 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "mingo@kernel.org" <mingo@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "Huang, Kai" <kai.huang@intel.com>
Subject: RE: [PATCH v6 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v6 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHbyvstsbmOCooYLUOhDTxRMjMaVrPfV7KAgApREbA=
Date: Thu, 29 May 2025 13:41:54 +0000
Message-ID: <DM8PR11MB5750BBF67BA29F9E2A7AAA77E766A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
	 <20250522092237.7895-5-elena.reshetova@intel.com>
 <5f952f793473bb0685c3315b1d93f7ae42c4a2a4.camel@intel.com>
In-Reply-To: <5f952f793473bb0685c3315b1d93f7ae42c4a2a4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|IA1PR11MB6122:EE_
x-ms-office365-filtering-correlation-id: b951943c-7836-4c4c-d365-08dd9eb6933c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?em1jeTZTU1dsaWR3WEVpL0pMay92ZXArS056MWVwc3hXTStRZHdDaW5KUHZW?=
 =?utf-8?B?dXJyU1hIZlhyV21LL0Rkd3p6M3J0eG02QUVzTU13ckEvbHRDcXZpRTJHdXFJ?=
 =?utf-8?B?Nkk4ZzBBUHYwTVlVTm1tTjc3UnRJZlhYeVlvaVBJT0o4WDNTbmU1MFJBbW51?=
 =?utf-8?B?WitOSkVVV2J6bWxCUEhBK2Q4aTJKb0NzeDR5SFBJZldEalF6dURpckU4VnRj?=
 =?utf-8?B?MGJHOVhYaVFlYUFnQzR4N21Ec29RbU5Ja0tkc3NvcnprTEUyNWk2ZjZiUlFQ?=
 =?utf-8?B?WDVYYVJ3NElUV29kdmo3M0ZIRnhpSmd4MW91RjhXcFVXUTQzQmJ4RXRpd1N6?=
 =?utf-8?B?UkgzUlFiSnRmT0JHVmdBaS9FL2FYcFJJT3lRUXBKSWp5S2pxYldENHpablZV?=
 =?utf-8?B?RUdWanR0V2RUek85UEZ2R3lqdWllaUxWQ3RJendRVWQ2ZFllc05IZHNLVlFn?=
 =?utf-8?B?TGhIU1RWZkpZdVJ2VzJVeWRSNWw0TmdERWc3ZkZZZFM0elc1ZkZ3c1JBcEtV?=
 =?utf-8?B?TGpTY2xSeDd3SnJXcXpFZGpRN0EwUFFJVHRCSndmNitTUHg3TCsrcGNzM1Yw?=
 =?utf-8?B?R2lVZ3lMd1lzMjJLa3RqRElPRHYzV2E5MytsdS9UZ2c3dGRHdXJYSzlwckNJ?=
 =?utf-8?B?eTVHVjNIZ0RzZU5oVWd5U2N2NHErNmFpYzdwV1RsQkY1aFAvRk9jOVRabE11?=
 =?utf-8?B?dE1DRG4zb0ppQmYzOXRWQjBPanF3T29zOFJxSE16NTg3bElJU3czUXJhRys5?=
 =?utf-8?B?bnJ6cnJzL1I0dlZvSmJIS0tCUmVRMnErbXRZNEs4MGh6dmtZRmM2OU5yNnBK?=
 =?utf-8?B?cHpDamVxUmlGbXJkZ2VLV0VqTDJxNkdlMDU3RzZWeDBmbThSeWNsZ0ZGeXk3?=
 =?utf-8?B?dlNXaWxUS0hHZVhVWWdvSEsweVAyZ3EraWJlTWxtNDB5VG1FRGFoczJGbWpX?=
 =?utf-8?B?bUJObXVaTUl0UEhteGt2SXRsdnU2Qmo4QXBFNmVjbzVHZGJmTzNIUlExbXZt?=
 =?utf-8?B?U0x3aVNzenEyU2ZjOVpOSFJuaTR5cmRQMDF4bUsvZGJmbnpUenJsU3J5OVRu?=
 =?utf-8?B?dTJabnZpNHFQSVo1SGdHSFNxS3FBc2YveG1hdXNGT2RqMHZwQkFmWDlEakZW?=
 =?utf-8?B?bERWK3RYWXVEdFlMYmEvL1dFQVgxSno4SVNML3BuMGRpeDRrS0MzNjZOcDZ5?=
 =?utf-8?B?eFVvNmdYYkZJaE8rcFBKK2RpcHJKelpPd1BPMDFMcFYwNTJhRjNaNmlCaWhE?=
 =?utf-8?B?bE93bjV5dUJpM1dkOU50eFA4b0RScnVkYUZLOWtGa2FiL3J4NW9jNjhIVkkx?=
 =?utf-8?B?aGxzeUxyLzZjcmFqNTZMeWUyVmtjMU9naFhPMlhRbGpFN0JBRWpQbEpKL2Jx?=
 =?utf-8?B?eU45TmEwRWJVRXpVdXlaTnBqTUFsSERQVHVEZUxGdjBKeTV5a2NmY2F4VkhH?=
 =?utf-8?B?YU51NmVNSXVHOCtUU29SalBUR3lNWExERWkrZFhxYXlSSUp5RE5TWU9MaFZt?=
 =?utf-8?B?YmJFbkMzUGFxRDRySTlLRSsyQ3lyaEJaRDJvMVZ2bXByM01OYmNNVFhFQUJ6?=
 =?utf-8?B?TEJ5UEtFTkExWEFRNXVOQjUwclgyQTFPU2RvazRTUXJUMTFKUm04WG13Lzht?=
 =?utf-8?B?UEJSL2tYVkNVZ2lnMGFrMCtabGkrUEJCRkJNa1BYNDFGejFVeFFsVnNaRXVO?=
 =?utf-8?B?QlBoaG5Qc1pEK3p3NGVhbkxJK25yNWs1M3h6VzVKeEJCQ0NLQXJ5UVcrT3N1?=
 =?utf-8?B?am9DYnhIRk9HKzdOSldBMGVUUlRRUStJdUJVNTNlaUk2dVpsRkk4aDA1MmpT?=
 =?utf-8?B?eUd5Z0tiajFzYk8xdTFYQUtkM2FFV0pGank2MkFvYlNqeHU0RnZ5ZFRRamE3?=
 =?utf-8?B?d3puWW1TdFN3L0VXZ01sbXVYZ2JPS0FZaWl5RFJ4RTdOaUxUa3lFTSsyK01i?=
 =?utf-8?B?eERRSlpzZHEwY1lScHhYZkpqWFhqWTd2UFdxTGl1OTRzdG4yN1hQdEo2VmFJ?=
 =?utf-8?Q?kE3vvZlxW5nKiCYWOADT1aPBC/yTZQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2VXbDdlTDRPejVOekZZdzFPaDAwekd2NmlHaUJmNXJiankxc05VeEF1L05m?=
 =?utf-8?B?QnYyeFZ0UEhMdzUzeGZnamRDa0JwajdVcWtpeHQrdVU0VzFrbktxTWhuTjdr?=
 =?utf-8?B?NjVXMENqRFNieW9Eb3VZTzRZRHh3dmNDM1JSVzhSUm9ZRmQ0K0ZiaUh3K2U2?=
 =?utf-8?B?K0ZxR29tZklJdkNNMW9KUGFtNE1hSGs0TmxjY3JPZWV4ZGNxQ2FRSFVYbVFG?=
 =?utf-8?B?ZHNtcmJ5aTh0S0pvYzM4N2Rqb0JrZjNxVU0rWE14NTVGUXE2Wjk3NG05OFJR?=
 =?utf-8?B?NW1naHFETWxXWG1zQ1NHRXpDUGY5dXNGMjJmcmY2QkFPSXlEVitYOGdPRmll?=
 =?utf-8?B?aFEwZEplNWJhZ3I4cnpNY2NJSGczSXM1WW1KcnNMVmdjWHpnWDZKZzdrV0Ur?=
 =?utf-8?B?aUYxKzcwN3U1cDFtM3hQTktCdXBVd0R4OTdiSURVb1l1ZHVRaHRYSERjaUVE?=
 =?utf-8?B?YVpNQkdrUjJ6K2tyVkJBTUdVNWVIRWhHeHdnRUVyQ1I0U0lJMXhRSExrSVRG?=
 =?utf-8?B?Yng0YXRNbG5QWWZLcTV2OUE1bGtvYXlGcWpCRmpJaFZ2cDhmczAwbXpHcXlD?=
 =?utf-8?B?RW8wYmorVko3aVFBTlo5VThGN1FXTk1rMjdGT2FpRC9BZXJ1T1Qzbzl5cFBp?=
 =?utf-8?B?cEVZOVRGRVZ2eDJMWmdXaWRSWXg5T2pLQXFwOWo5OW1JbnpQZHE4Q1BWNzN4?=
 =?utf-8?B?ZnptaXkxTUFGM1lPVjJzWWVIUnBpR3hqSlJ1cXBPTEVzRGQxQWpHYUZTNXRt?=
 =?utf-8?B?ckpzM054b0YwSE5HOXlveXZCTFkyMmt5L2xEeHYxY21SNU9nTmMxOGVhZUZZ?=
 =?utf-8?B?clF0YnZpckdtaFpLSFo2WjMzdEVqZUZqUloxV1l4TGFqR0xwdDErd2lqM2I1?=
 =?utf-8?B?dVg0SzRoQkFDTlBZODVjRzZ2SmFlWnpGYzROWU5Sc3huWHI1K0FQS1ZxbnZM?=
 =?utf-8?B?bCtneEJ3SDhZbytjdjdpRWNiSGZCdEVkL3BDSFBTdFFYdTNoRjFqY0tOQVVV?=
 =?utf-8?B?NXIrTlNHaERkZ2ZBa1V4YkM2OGg1bU96R2VtUUNRNkdvSFRYTVRwU3Z1WXVw?=
 =?utf-8?B?VU5WWm85aCtTaVVxaEtkdGVlOWFkblpiUmMwUEVIb3BvQVpKa2dWa3A0TjJs?=
 =?utf-8?B?Vyt5MDIxRmJOMGI3d2NidFJnWFo1bmpUbUMxb0JQbzhCa0txY1JMVnB3SXVy?=
 =?utf-8?B?aVo1aloyY1pPdG1MckdvYVZsRVplc2ZENnBvVkU0a1M1N2MxZVFpa2JJSjBv?=
 =?utf-8?B?ODZRS3Q3SXYrc2ZtMFRITkxTQmxNWG5rQTFtcDJMY2o4WjgvdnNuZ1c3YUZp?=
 =?utf-8?B?TjQxcU93WFUzUi9oYXFpV000SG1mS05xb3VhY1M4NEhnRjlnUU4xWnZaNlBt?=
 =?utf-8?B?RGxpR3MvMWhaS3BZTmVVQjFTOGJ4OS80YVhhRU5IM2dlYUdHVW1pOVZnajdj?=
 =?utf-8?B?VXU3YkkrUXoxQlVFK1V2cVRNQU9BcjRiT2ZJanZXbTladXY3VThhNlgwa2R0?=
 =?utf-8?B?YVE4cHBBclJqV1VNME5UaHJDRnVZUi9rTXVsM3RQb01jb1ZhVE9vejhMOTRv?=
 =?utf-8?B?K0d6RU9hUG5ndGcrNFpXQmZ2d0E4MmlZSnlqSVAySFhKNmN5TndldDhrS01T?=
 =?utf-8?B?WVVNcmQ0V2JMNW9vUHVlVS9VMzRSNk1DV0tudXVta29WTUlQNnZUVWZhYlBJ?=
 =?utf-8?B?T1BacXRxWkZzcDM5VmpacHpvK2lMcDFRMGt5SXJVMGFrQVUyaDFEVzFLdHVR?=
 =?utf-8?B?bjhyQm1GREN1ZzJCeVpQK2tWOXJFbk1SdFJHdkl2NUtaN1B6Um1tOTJ3bG43?=
 =?utf-8?B?dWg0YWVmSlU0em5aVHh0R2tzemVFY0NkTksyb0ZkZlo2VXJzdFBMc3hMWi85?=
 =?utf-8?B?NTlXUkk2SHEwR3ZXNDE2VHpnWnRZTXhxWk1meVc4ckp3eWRpYi9kc0RTSlVX?=
 =?utf-8?B?VkRYUUI5VUMwVmI4YXU2Si9SUUdPY1VBSUJ4eEdYNE5HMXZYeEtVaVM0UUJh?=
 =?utf-8?B?elpSUFZWRGhOWE5Wc2ZGckRnZkxDdFdEWVMzZ0YzSWxyTHUxSXcva3crbmlJ?=
 =?utf-8?B?RVNPNDhLQ0tKaSt0K256MW80bDJvc1ZqUVh4UG82dmNJUmc2TUJ3TXphZEhv?=
 =?utf-8?B?dGtXdThORldoa1phZHZKV2NCNlM4cGJaZiswZFdBd0VLczFHa1BFN0M3R3Z6?=
 =?utf-8?Q?Qqod+hMQhOqgPQpB61TQAM4Klv+3KQi5cU02dFm5qLoQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b951943c-7836-4c4c-d365-08dd9eb6933c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 13:41:54.7002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZJit7fLWwy5z+YWxzROZNLfJzVE9PiqoqvEoMhEfVChFgVWPZyhB3o8nwzkI82Ut/8D0tpq6MxzhQ7QTS1A/8YjQxYF4oIJB+ZntgIZgLDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6122
X-OriginatorOrg: intel.com

DQo+ID4NCj4gPiArLyoqDQo+ID4gKyAqIHNneF91cGRhdGVzdm4oKSAtIEF0dGVtcHQgdG8gY2Fs
bCBFTkNMU1tFVVBEQVRFU1ZOXS4NCj4gDQo+IHNneF91cGRhdGVzdm4oKSAtPiBzZ3hfdXBkYXRl
X3N2bigpOg0KPiANCj4gYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jOjk0MTogd2Fybmlu
ZzogZXhwZWN0aW5nIHByb3RvdHlwZSBmb3INCj4gc2d4X3VwZGF0ZXN2bigpLiBQcm90b3R5cGUg
d2FzIGZvciBzZ3hfdXBkYXRlX3N2bigpIGluc3RlYWQNCj4gDQo+IA0KPiA+ICsgKiBUaGlzIGlu
c3RydWN0aW9uIGF0dGVtcHRzIHRvIHVwZGF0ZSBDUFVTVk4gdG8gdGhlDQo+ID4gKyAqIGN1cnJl
bnRseSBsb2FkZWQgbWljcm9jb2RlIHVwZGF0ZSBTVk4gYW5kIGdlbmVyYXRlIG5ldw0KPiA+ICsg
KiBjcnlwdG9ncmFwaGljIGFzc2V0cy4gTXVzdCBiZSBjYWxsZWQgd2hlbiBFUEMgaXMgZW1wdHku
DQo+ID4gKyAqIE1vc3Qgb2YgdGhlIHRpbWUsIHRoZXJlIHdpbGwgYmUgbm8gdXBkYXRlIGFuZCB0
aGF0J3MgT0suDQo+ID4gKyAqIElmIHRoZSBmYWlsdXJlIGlzIGR1ZSB0byBTR1hfSU5TVUZGSUNJ
RU5UX0VOVFJPUFksIHRoZQ0KPiA+ICsgKiBvcGVyYXRpb24gY2FuIGJlIHNhZmVseSByZXRyaWVk
LiBJbiBvdGhlciBmYWlsdXJlIGNhc2VzLA0KPiA+ICsgKiB0aGUgcmV0cnkgc2hvdWxkIG5vdCBi
ZSBhdHRlbXB0ZWQuDQo+ID4gKyAqDQo+ID4gKyAqIFJldHVybjoNCj4gPiArICogMDogU3VjY2Vz
cyBvciBub3Qgc3VwcG9ydGVkDQo+ID4gKyAqIC1FQUdBSU46IENhbiBiZSBzYWZlbHkgcmV0cmll
ZCwgZmFpbHVyZSBpcyBkdWUgdG8gbGFjayBvZg0KPiA+ICsgKiAgZW50cm9weSBpbiBSTkcuDQo+
ID4gKyAqIC1FSU86IFVuZXhwZWN0ZWQgZXJyb3IsIHJldHJpZXMgYXJlIG5vdCBhZHZpc2FibGUu
DQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW50IHNneF91cGRhdGVfc3ZuKHZvaWQpDQo+ID4gK3sN
Cj4gPiArCWludCByZXQ7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIElmIEVVUERBVEVTVk4g
aXMgbm90IGF2YWlsYWJsZSwgaXQgaXMgb2sgdG8NCj4gPiArCSAqIHNpbGVudGx5IHNraXAgaXQg
dG8gY29tcGx5IHdpdGggbGVnYWN5IGJlaGF2aW9yLg0KPiA+ICsJICovDQo+ID4gKwlpZiAoIWNw
dV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVfU0dYX0VVUERBVEVTVk4pKQ0KPiA+ICsJCXJl
dHVybiAwOw0KPiA+ICsNCj4gPiArCWZvciAoaW50IGkgPSAwOyBpIDwgUkRSQU5EX1JFVFJZX0xP
T1BTOyBpKyspIHsNCj4gPiArCQlyZXQgPSBfX2V1cGRhdGVzdm4oKTsNCj4gPiArDQo+ID4gKwkJ
LyogU3RvcCBvbiBzdWNjZXNzIG9yIHVuZXhwZWN0ZWQgZXJyb3JzOiAqLw0KPiA+ICsJCWlmIChy
ZXQgIT0gU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZKQ0KPiA+ICsJCQlicmVhazsNCj4gPiArCX0N
Cj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogU1ZOIHdhcyBhbHJlYWR5IHVwLXRvLWRhdGUuIFRo
aXMgaXMgdGhlIG1vc3QNCj4gPiArCSAqIGNvbW1vbiBjYXNlLg0KPiA+ICsJICovDQo+ID4gKwlp
ZiAocmV0ID09IFNHWF9OT19VUERBVEUpDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJ
LyoNCj4gPiArCSAqIFNWTiB1cGRhdGUgZmFpbGVkIGR1ZSB0byBsYWNrIG9mIGVudHJvcHkgaW4g
RFJORy4NCj4gPiArCSAqIEluZGljYXRlIHRvIHVzZXJzcGFjZSB0aGF0IGl0IHNob3VsZCByZXRy
eS4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKHJldCA9PSBTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkp
DQo+ID4gKwkJcmV0dXJuIC1FQUdBSU47DQo+ID4gKw0KPiA+ICsJaWYgKCFyZXQpIHsNCj4gPiAr
CQkvKg0KPiA+ICsJCSAqIFNWTiBzdWNjZXNzZnVsbHkgdXBkYXRlZC4NCj4gPiArCQkgKiBMZXQg
dXNlcnMga25vdyB3aGVuIHRoZSB1cGRhdGUgd2FzIHN1Y2Nlc3NmdWwuDQo+ID4gKwkJICovDQo+
ID4gKwkJcHJfaW5mbygiU1ZOIHVwZGF0ZWQgc3VjY2Vzc2Z1bGx5XG4iKTsNCj4gPiArCQlyZXR1
cm4gMDsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogRVVQREFURVNWTiB3YXMg
Y2FsbGVkIHdoZW4gRVBDIGlzIGVtcHR5LCBhbGwgb3RoZXIgZXJyb3INCj4gPiArCSAqIGNvZGVz
IGFyZSB1bmV4cGVjdGVkLg0KPiA+ICsJICovDQo+ID4gKwlFTkNMU19XQVJOKHJldCwgIkVVUERB
VEVTVk4iKTsNCj4gPiArCXJldHVybiAtRUlPOw0KPiA+ICt9DQo+ID4gKw0KPiANCj4gVGhpcyBw
YXRjaCBhbG9uZSBnZW5lcmF0ZXMgYmVsb3cgYnVpbGQgd2FybmluZyAoYm90aCB3LyBhbmQgdy9v
ICdXPTEnKToNCj4gDQo+IGtodWFuZzJAa2h1YW5nMi1kZXNrOn4vd29yay9lbmFibGluZy9zcmMv
dGlwJCBtYWtlDQo+IGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4LyBXPTENCj4gICBERVNDRU5EIG9i
anRvb2wNCj4gICBDQUxMICAgIHNjcmlwdHMvY2hlY2tzeXNjYWxscy5zaA0KPiAgIElOU1RBTEwg
bGlic3ViY21kX2hlYWRlcnMNCj4gICBDQyAgICAgIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21h
aW4ubw0KPiBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmM6OTQwOjEyOiB3YXJuaW5nOiDi
gJhzZ3hfdXBkYXRlX3N2buKAmSBkZWZpbmVkDQo+IGJ1dCBub3QNCj4gdXNlZCBbLVd1bnVzZWQt
ZnVuY3Rpb25dDQo+ICAgOTQwIHwgc3RhdGljIGludCBzZ3hfdXBkYXRlX3N2bih2b2lkKQ0KPiAg
ICAgICB8ICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn4NCj4gDQo+IFJlZ2FyZGxlc3Mgb2Ygd2hl
dGhlciB0aGlzIHdhcm5pbmcgaXMgcmVhc29uYWJsZSBvciBub3QsIGl0IGlzIGEgd2FybmluZyBk
dXJpbmcNCj4gYnVpbGQgcHJvY2VzcyB3aGljaCBtYXkgaW1wYWN0IGJpc2VjdC4NCj4gDQo+IFlv
dSBjYW4gc2lsZW5jZSBpdCBieSBhbm5vdGF0aW5nIF9fbWF5YmVfdW51c2VkIGF0dHJpYnV0ZSB0
bw0KPiBzZ3hfdXBkYXRlX3N2bigpIGluDQo+IHRoaXMgcGF0Y2gsIGFuZCB0aGVuIHJlbW92ZSBp
dCBpbiB0aGUgbmV4dCBvbmUuDQo+IA0KPiBCdXQgSSBhbSBub3Qgc3VyZSB3aGV0aGVyIGl0IGlz
IG5lY2Vzc2FyeSwgdGhvdWdoLiAgV2UgY2FuIG1lcmdlIHRoZSBsYXN0IHR3bw0KPiBwYXRjaGVz
IHRvZ2V0aGVyLiAgVGhlIGVuZGluZyBwYXRjaCB3b24ndCBiZSB0b28gYmlnIHRvIHJldmlldyBJ
TUhPLg0KPiANCj4gV2UgY2FuIGV2ZW4gbWVyZ2UgcGF0Y2ggMyB0b2dldGhlciB0b28uICBUaGUg
cmVhc29uIGlzIGN1cnJlbnQgY2hhbmdlbG9nIG9mDQo+IHRoYXQNCj4gcGF0Y2ggZG9lc24ndCBl
eHBsYWluIHdoeSB3ZSBvbmx5IGRlZmluZSB0aGF0IHR3byBlcnJvciBjb2RlcyAob3IgcmV0dXJu
DQo+IHZhbHVlcykNCj4gYnV0IG5vdCBvdGhlcnMsIHdoaWNoIG1ha2VzIHRoYXQgcGF0Y2ggKkFM
T05FKiB1bi1yZXZpZXdhYmxlIHdpdGhvdXQNCj4gbG9va2luZyBhdA0KPiBmdXJ0aGVyIHBhdGNo
ZXMuICBUaGF0IGJlaW5nIHNhaWQsIGl0J3MgZmluZSB0byBtZSB3ZSBrZWVwIHBhdGNoIDMgYWxv
bmUsIGJ1dA0KPiBpdCdzIGJldHRlciB0byBkbyBzb21lIGNsYXJpZmljYXRpb24gaW4gY2hhbmdl
bG9nLg0KPiANCj4gQnV0IGp1c3QgbXkgMiBjZW50cy4gIFNpbmNlIERhdmUvSW5nby9KYXJra28g
YXJlIGFsbCBvbiB0aGlzIHRocmVhZCwgSSdsbCBsZWF2ZQ0KPiB0aGlzIHRvIHRoZW0uDQoNCkRh
dmUsIGRvIHlvdSBoYXZlIGEgc3Ryb25nIG9waW5pb24gb24gdGhpcz8gDQoNCg==
