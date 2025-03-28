Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7C3212B18;
	Fri, 28 Mar 2025 08:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743149251; cv=fail; b=FX66JToCr5BZH94UjtXAaBSDpIOXsuoBGt4UOw8CS+s3jDAQ735Yf9TFSdop9iUP848PVf0RrzxEh/cQs+Asbsd3yqTMs7Mvqdtp9BARBKMytCJ/BFVm6/KNo0HVUbaF1zew8wlETjOAMDsX3nx/f/Ug3JepA2FkKLhRrSftELY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743149251; c=relaxed/simple;
	bh=iXQEZGT1pypw4ykMBQmu99QyNDJQkosNtw0mrjAH6Ig=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lyx5yFbWDQFkO1G4Ym+jz8/79q1eT2ll1VZM0rn2euyxsYY/Ly9cCBQEciBQ8XlkpguhXA6MaPcXc0ORz2hpTHgtXreiUWjHTJS8PYbV87B1iV6/+wCnWYMZERF4DeuPQfC+1DBziGYOMM5sJgqQ4WZoRqlYQX+3SIY1XUypw/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HPi0Y79b; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HPi0Y79b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743149250; x=1774685250;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iXQEZGT1pypw4ykMBQmu99QyNDJQkosNtw0mrjAH6Ig=;
  b=HPi0Y79be0ULipi394KOl+tKgRX1KQrB6y4u9cBjM2/gzdDOrz+GXtCM
   Vr0tU4vB/zPJqylv61dW/QUOq6ZU/CCE3DukDb2yD/3UPNV3IWT1GS4bq
   r+KU//GURT/7F9QAfl1es7dn5nEobCNsRJkJn7cM/V7JOz8KmzO0bXclS
   8/V5O7wAwJ3SJuIyUmxcL2+D0BZIQd/lb1gn90//fR5IFdovjI5C/lyWI
   GY9NEDc5aOPN8Bp2XnPf3KfzSX+p1/jW191GCkSyC68d9NSex8rx2+hE2
   1cvUAwZWw83jrHGqFvOkT1zArXrBJLNxjkIHmumDcMyd42wIZbkVyKlF2
   A==;
X-CSE-ConnectionGUID: 24OWR5vTT/m8aMtlGlBLrQ==
X-CSE-MsgGUID: +P3QA7p1QMmwQUHtVNDnwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="44421805"
X-IronPort-AV: E=Sophos;i="6.14,282,1736841600"; 
   d="scan'208";a="44421805"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 01:07:29 -0700
X-CSE-ConnectionGUID: TFFRJsCPQGOnKOYRKoKJAA==
X-CSE-MsgGUID: SilEK0WzSRatol1vo5zKRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,282,1736841600"; 
   d="scan'208";a="130481481"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 01:07:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 28 Mar 2025 01:07:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Mar 2025 01:07:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Mar 2025 01:07:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R8U0LmwY4FFx8S27Na43Znqj9HCsp1/asPOX8+IAsSWxDZlKWbU+INslvY7W/ph8x4h1yA+nW1+0d8NNI5ik/lSdSd5HLDZdeEHRY+4fGNvTwqjHJlJH4gbkj7CdOIh6T1IZpojG3Jqe6AltxOAg5dCa6u65+WIUiVBcWc8wJlpo5HFolMeACLxEWG5Vq5TKrCBSGxSBLZfcwAIXkACni9+vZ6bMA2zPfkTX0XZtxn7o8o4syoPpkrAxh2FKK7rTEg/7B+b1WLpdzrEavvqb60Ch9bSNH6ra2XVnnzX3adaq+aNy4Vqkcmcl21EBTrjFHy4vDdQi3NIkm8SNbhuoWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXQEZGT1pypw4ykMBQmu99QyNDJQkosNtw0mrjAH6Ig=;
 b=nD6b+qqkpQs0CTk5iGZE2oW7v6ccX03RB7OYdmCd2j6YucYQx4mz86qnv9lLgbEEnZxxm+PKGrjq8ZlztEF+Rwff7F7nQwDxb5A89EtQTAWJlK89ZjKDrxH/m5lu/FQBbrQWFmlw8f1o0wEn5ZXv35h9Rz2HHUnqTWEeda+BN+mt+im9L2FLb2sQosr7MjUYfBZ4RzZQxj9CXZF5XC1GDeEfaZAE4XP+0awMsBLQXpcFJGn7DnkH8QHbHay6UWLeRYMJqiD2ZI6yu79CyxVFaFqmvGX5YzPvnZe9mX+7UPucmrOOW3PkzvtRcEcUaQvKBp2ahF8E2RJxmT4PG+0Unw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 08:07:25 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.040; Fri, 28 Mar 2025
 08:07:25 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>
Subject: RE: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Thread-Topic: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Thread-Index: AQHbml52rO5WRn4U4UWiUGJJakHgYrN/tmkAgAJ/A3CAA6SegIABR0IQgABobwCAALEwoA==
Date: Fri, 28 Mar 2025 08:07:24 +0000
Message-ID: <DM8PR11MB57503621B1D7674404A62004E7A02@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-2-elena.reshetova@intel.com>
 <Z98yki-gH4ewlpbP@kernel.org>
 <DM8PR11MB57508A3681C614C9B185B04EE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RY8-bL2snpRKTB@kernel.org>
 <DM8PR11MB575029FAC2C833553CE422CFE7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-XDFDj8Tc5i-GBg@kernel.org>
In-Reply-To: <Z-XDFDj8Tc5i-GBg@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|MW4PR11MB5911:EE_
x-ms-office365-filtering-correlation-id: 7969e6e2-34e6-42c3-b346-08dd6dcf931b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T2JNRjM2YlJ5NWpMb0NBRGltYkJEN09LSWlwdklINjFBdDAyUDdacDlraTZ4?=
 =?utf-8?B?VXRPM1l0dnIrSG53a2YvUDZsTzlYcTFjS0szeHZBeHdYS05scldPdUgyME9J?=
 =?utf-8?B?K1UxVlB4ZDR3KzVhT3FiMnVtUTJaaDhlUmVLajEzQVpnRndtRkt1elZTY1Ir?=
 =?utf-8?B?aTZEdlpGYUkwYmN5SUtlc1dNeEtQaThVc2tiazAzVGM4RHROR1doWldFQ1RV?=
 =?utf-8?B?OFQxTldrZ2tFS0RuTmhPamJzZEIzL3Q3Znhib2dxRW05dUNrWGRKV2FWdEhv?=
 =?utf-8?B?aGdmdDNkcVU4QVNJN0VhR2FLQ1JlanpMQXpzdFlLbnowbzZhV3RTYjdDSDJh?=
 =?utf-8?B?UkQ4TzMrTUl5aFZsYlk0TFFiNmZ0bm00U2pjc2pSQkxQMlFqR0VIQVRzTnJR?=
 =?utf-8?B?YnMraW5tL1ZxazlweW8rOU53SWswc2dMb2tUbU52ZHJWRkFhbzROQ0wwL3Zl?=
 =?utf-8?B?TG1LRDk2UTE5dkZxQ040R0wwR2hWT1N1RGEzZVRBdGNxVXNyQkpkL1BEWGhD?=
 =?utf-8?B?MWdGMTh2KzM4TFlTUDhSU1NpOHBmdENUS0J0MEhZcVcxWkFhbHA3dkFUS00y?=
 =?utf-8?B?U3NSa281K2R0emZBVkpGV0U5ajlaYlF6bnRpWlFIeUNRVlZHZU9XWTVoUUEz?=
 =?utf-8?B?cFNNYVZDVkJGMVR3Rkd3M2RCVkVKeU1WSy91bnFvUEJ5QSt6eDZLeUVqUjNp?=
 =?utf-8?B?WVM2WHRMSVZkQ2Mwc21lUkZidmJHdmJCMk5aR3F0Nmk5bTlUMFYzL0hpcnpN?=
 =?utf-8?B?eWk2Y1RndFFaeHpkS01pNlA2dmFVRXVWaE80Q2t4Q0tSTVRxa1Fka09BMVZa?=
 =?utf-8?B?YW1EcUhsOFhaR1BkQkVGRTMxak9sWjBXV2hKYXRPLzFPZW9tYUFJeE5EWnRt?=
 =?utf-8?B?Y2psWFU3MmdFNlN3SVh1NjBjdStXUlBqM25oVVEzRUZQbGp5RXByemxCRUJn?=
 =?utf-8?B?RGxCZk5VbHdGRFRid1FsNHRQY0VjMlRWTG1uK2x0TElhRVlFb0wzWFFKWSto?=
 =?utf-8?B?ajJwendQR3JqdUVDa25yOU5OdGl0ZEdxM3Qwa1MwTjgrNUgyRUEvYmVMQlVa?=
 =?utf-8?B?VFIyU1JnZEFpTllpTXdOV2hzR3BLRnozVTI3WlZUY0hBOXNTWTd4ZzM4eTl5?=
 =?utf-8?B?b3ljbU1UTjV5RDZnU29pTlFhVjM1Vy9WaE41dFNFM3A2cFdOT3hzVEtmQUZL?=
 =?utf-8?B?QVNkVkcrNUtVajZqOGlkZ3E4R2JyMUZvcnNmay9OdnZPZS9wVEZtanJDdTlY?=
 =?utf-8?B?U2o3V1lmZytwM3F2V213YVhEeXRtd1lONVhOMmJBalB5a1NtbnA0dXYxOTlK?=
 =?utf-8?B?UTF4alVKZ3RscnBvSEZmMkNmalpBbXJFQ0VtRDBqSmY2QVV2UU15VGV2Wkxo?=
 =?utf-8?B?R21KSUtWZUIxaFlmKzZGSy94WWdrYUdzcjBIYWFqRG5RdE11a0xGMzdDOFlD?=
 =?utf-8?B?cGVEOVU3enRsVFN6cTcvOXBncHkwbjhoNUlwRHlobGs2M2JDdEdNYjFwRWRi?=
 =?utf-8?B?MVlBQmx3MlpxcmRQbkxJU1NwOUZQanVVYVQzTWlmWHl5SlhxTE1OeFlEZkhL?=
 =?utf-8?B?M09Ja1ZoWUxiaFU4WnliVit6S2V2OFpzUVAwSUhmSEhyK3QzdUROQWs2d1JP?=
 =?utf-8?B?R0dQazVNQ2lSbUtHbFdhakNESGNDTm96dmFkam43SlczR1JPdnA4M1RQTUVs?=
 =?utf-8?B?MEZTd0pyUW44VDFmdEtuenlidExWWUwySllXaEJSUFpyN29wVnNlcDRWYlc4?=
 =?utf-8?B?R1M3am1EdTRGYTFmalk0SFpwcVZ4VzRoQ3BGREpxTGdxTEQxSSt1eTZpTUNj?=
 =?utf-8?B?SWVIZ1NmeVFKSXJIMnRkVS9WUFpOZHNSc0Z1RThPektCeUpndzloYi96eGpo?=
 =?utf-8?B?KzM5eEdGaHZ5VTJFSEgxUmI2MnJkYWlONTlsVmVFbnVRcHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2ZPbXhKSlJtTC9CbXFKTTZiV010ZE40WTVrVktCcXlmYWJ5Tmdha0hYOWNt?=
 =?utf-8?B?a0t2MDd5U2ZCNTJRUHZaVTU1VHVZWGdjVlVWU0RwYW1Db21VSUFpQ1hNQ0Q5?=
 =?utf-8?B?RGZyU3l2ZnhyV1J6Y0Z6dTU4UlcvUVBzWk1GQUh4K3I3ajNpVW83TzIwZHIw?=
 =?utf-8?B?anJKdHk3YnVkVVJ4Nmp6S2FrN3o1cHVGa0RoVGdDY2czM2ZzUzVPU3pnV2tF?=
 =?utf-8?B?RVZDMGR4NHppcnA2bnl4azcxS0F4dlZXNzVlZTI0TENIVTkyWHVFZVc0ODRs?=
 =?utf-8?B?L3JaZmFsajYwUEpRQnhWTlhJS1IwSmtLWk03ZUtZVXlMSE1CLzZNZE95Nndz?=
 =?utf-8?B?MHprVWIwbnZsR2ErWFN3M2VaenQrQzhqNFN5SzZIc3FZL2NzNVB3NG9Hc09t?=
 =?utf-8?B?MjFMR3d1c1dUZ0RLeW0vMkJSYlB2MG9udGlLYnNsR08yL3hRaDAzOG9Obk4y?=
 =?utf-8?B?N1NtbXBSTmVVcUhPRm84MEtFWVZvK0FCOXk0THVkS0ZDNitrNS9ZcUdBaU94?=
 =?utf-8?B?K0x4QW01WkJWbFhPWjNjU0NvK055RWdvSFNlV0lCeTZZY21FSmpBMjJhYmtq?=
 =?utf-8?B?S1Q3MFF3SXZzcTBBcGhMc0tiYmdPRjRadklacFB4TktVVnRwdWRBNlZUQ3ZI?=
 =?utf-8?B?MnlyQStUdXhUZTNwZFRqWVVneE92WDkxdnhESVNGOEdNMHpWY3Q0RHVKdWho?=
 =?utf-8?B?ZWEvaVIyZFUybEpYaDQ2T1BwL0M2Sm1xb0JCWkNmRXJwdXJpUCtuZjc5L2hT?=
 =?utf-8?B?MUhPQ3JSQUJPV3BuQm9vL2Z6azlsc2FQUy9DditjSDYzR2p0d1k4VUl3MDJX?=
 =?utf-8?B?emZtZDVJTmlJd0kwZU80TmV1TzRXUUh2WnNobGpJQnNxU3Y5RUYrV24rYzVt?=
 =?utf-8?B?UVg4ZXEyOFZia05HUng3alpZYTI5UW4wN2ZjajBNOWhmcEdiY1JRaEx3bW9J?=
 =?utf-8?B?Y3hvOU41R0ljZzE0MzJweER6RVg3SDc1bXplWklHdFlZNkorb3pYWDRkVDVK?=
 =?utf-8?B?ZDFvbDBTVDB2K0dKZ2hpRFVZRnNXL003OTZIak1LN2dRelgwK1R5Vmx4c1Y4?=
 =?utf-8?B?MUl0SFc3bUozMGhYNUdmN2JMc0JYeGhWSGE3QjNsYm1PeFBqMmZoNGFMWnFS?=
 =?utf-8?B?WmdUUDlqUXh2elFRSzkzMVVQUmtCa1JqMXJGWXVBcGNRdEJxMWFZV2RZUlB1?=
 =?utf-8?B?d0R0SStvcXFpSU1nUFZwR1hlV2RjcktjRlR1NlNBUld0anV0UG5QRWZOTWFn?=
 =?utf-8?B?eHBib0NxREdhbHRaM3BlYlJrSlJUc0tFR2lPYmtUeW9JOW5nOW9rMTBna2Jy?=
 =?utf-8?B?ckpCWGVsVUJlTHRWcmJPYi94UmZsSFZMaDVXWTM2b2xTRWFXQm8yNSs0RUk2?=
 =?utf-8?B?a296NHNLOWFRMVhBRHAxalU1STkrcWtxYno3Z1c2NmpOYXRjUEJXN2h3em1o?=
 =?utf-8?B?UHV1R3QxNlE0UWpqT1lMVS9SUldJQWh5YWFGRFFXWjRtcTFVMFFvZFNzSG1X?=
 =?utf-8?B?OGFlMjllUDROd2ZSTk1MUXhoT3EwajhTN0RWWUVrWVFselYrQXdJMWNFaGhq?=
 =?utf-8?B?cjN0aEFNSDBvZERmYUUvVGFWd0RCcVhJSlRVYnl6dXlOTlBEQ2diVzN5dWp3?=
 =?utf-8?B?Mi9qTUNmUSt6bEFnQmtsaUNLN0Qyb0RqMmorQ0grWWFHeDliTm55aFl1RzZP?=
 =?utf-8?B?azBOMDFDOC82M0lxeVdxWXU0R1VxTzM3UiswLzdzRndzenpXZTVkaW1DR08r?=
 =?utf-8?B?cm0zRFVydS9HcU9QU01xSyt4a1dianZyRGdEeEdPeVpJU3J4SkNzNFBzSWc2?=
 =?utf-8?B?eVJBM1JSZm5CdEtrTEYzSVJrTVBmY0JOU292ZHBlTytjeVkydDRVeFN0RDJV?=
 =?utf-8?B?Q3dzUkx3a29oelJBWXZjV2JsMDZUNVNkOFB6Wi9MbzllVVlvbkMxTWdPdTVU?=
 =?utf-8?B?Yjl5QlUyQi9wQTJ3dExQclU5STRhWnovVnZTUHl4VzExSDJPbkRZSGJtTzF6?=
 =?utf-8?B?YTBMRlNmd3FpMXh2dThpdUkwOWpVdXpjZ3Y2T1h6VmUvVEphNzhkMlRQWCtt?=
 =?utf-8?B?UDRab3lxOW1CVmV6T0Njbm52KzZzUGFyZ09HckQ0b2QzaWtMbGdEMDVSVi83?=
 =?utf-8?Q?wyIcB3Tm34WXtUKibCw83QVhI?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7969e6e2-34e6-42c3-b346-08dd6dcf931b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2025 08:07:24.9834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ERmaC2KOIGPMH467rdVsc37n9zzZYZ8Tjzqvbu5LSKPSh48eR9S8lmpOSFWyggm73iBJp/7Gbj/ouQ67hUJ+0NSrCKSvO5LFwh4fK27dxCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5911
X-OriginatorOrg: intel.com

DQo+IG9OIFRodSwgTWFyIDI3LCAyMDI1IGF0IDAzOjI5OjUzUE0gKzAwMDAsIFJlc2hldG92YSwg
RWxlbmEgd3JvdGU6DQo+ID4NCj4gPiA+IE9uIE1vbiwgTWFyIDI0LCAyMDI1IGF0IDEyOjEyOjQx
UE0gKzAwMDAsIFJlc2hldG92YSwgRWxlbmEgd3JvdGU6DQo+ID4gPiA+ID4gT24gRnJpLCBNYXIg
MjEsIDIwMjUgYXQgMDI6MzQ6NDBQTSArMDIwMCwgRWxlbmEgUmVzaGV0b3ZhIHdyb3RlOg0KPiA+
ID4gPiA+ID4gSW4gb3JkZXIgdG8gc3VjY2Vzc2Z1bGx5IGV4ZWN1dGUgRU5DTFNbRVVQREFURVNW
Tl0sIEVQQyBtdXN0IGJlDQo+ID4gPiBlbXB0eS4NCj4gPiA+ID4gPiA+IFNHWCBhbHJlYWR5IGhh
cyBhIHZhcmlhYmxlIHNneF9ucl9mcmVlX3BhZ2VzIHRoYXQgdHJhY2tzIGZyZWUNCj4gPiA+ID4g
PiA+IEVQQyBwYWdlcy4gQWRkIGEgbmV3IHZhcmlhYmxlLCBzZ3hfbnJfdG90YWxfcGFnZXMsIHRo
YXQgd2lsbCBrZWVwDQo+ID4gPiA+ID4gPiB0cmFjayBvZiB0b3RhbCBudW1iZXIgb2YgRVBDIHBh
Z2VzLiBJdCB3aWxsIGJlIHVzZWQgaW4gc3Vic2VxdWVudA0KPiA+ID4gPiA+ID4gcGF0Y2ggdG8g
Y2hhbmdlIHRoZSBzZ3hfbnJfZnJlZV9wYWdlcyBpbnRvIHNneF9ucl91c2VkX3BhZ2VzIGFuZA0K
PiA+ID4gPiA+ID4gYWxsb3cgYW4gZWFzeSBjaGVjayBmb3IgYW4gZW1wdHkgRVBDLg0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gRmlyc3Qgb2ZmLCByZW1vdmUgImluIHN1YnNlcXVlbnQgcGF0Y2giLg0K
PiA+ID4gPg0KPiA+ID4gPiBPaw0KPiA+ID4gPg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gV2hhdCBk
b2VzICJjaGFuZ2Ugc2d4X25yX2ZyZWVfcGFnZXMgaW50byBzZ3hfbnJfdXNlZF9wYWdlcyINCj4g
bWVhbj8NCj4gPiA+ID4NCj4gPiA+ID4gQXMgeW91IGNhbiBzZWUgZnJvbSBwYXRjaCAyLzQsIEkg
aGFkIHRvIHR1cm4gYXJvdW5kIHRoZSBtZWFuaW5nIG9mIHRoZQ0KPiA+ID4gPiBleGlzdGluZyBz
Z3hfbnJfZnJlZV9wYWdlcyBhdG9taWMgY291bnRlciBub3QgdG8gY291bnQgdGhlICMgb2YgZnJl
ZQ0KPiBwYWdlcw0KPiA+ID4gPiBpbiBFUEMsIGJ1dCB0byBjb3VudCB0aGUgIyBvZiB1c2VkIEVQ
QyBwYWdlcyAoaGVuY2UgdGhlIGNoYW5nZSBvZiBuYW1lDQo+ID4gPiA+IHRvIHNneF9ucl91c2Vk
X3BhZ2VzKS4gVGhlIHJlYXNvbiBmb3IgZG9pbmcgdGhpcyBpcyBvbmx5IGFwcGFyZW50IGluDQo+
IHBhdGNoDQo+ID4gPg0KPiA+ID4gV2h5IHlvdSAqYWJzb2x1dGVseSogbmVlZCB0byBpbnZlcnQg
dGhlIG1lYW5pbmcgYW5kIGNhbm5vdCBtYWtlDQo+ID4gPiB0aGlzIHdvcmsgYnkgYW55IG1lYW5z
IG90aGVyd2lzZT8NCj4gPiA+DQo+ID4gPiBJIGRvdWJ0IGhpZ2hseSBkb3VidCB0aGlzIGNvdWxk
IG5vdCBiZSBkb25lIG90aGVyIHdheSBhcm91bmQuDQo+ID4NCj4gPiBJIGNhbiBtYWtlIGl0IHdv
cmsuIFRoZSBwb2ludCB0aGF0IHRoaXMgd2F5IGlzIG11Y2ggYmV0dGVyIGFuZCBubyBkYW1hZ2Ug
dG8NCj4gPiBleGlzdGluZyBsb2dpYyBpcyBkb25lLiBUaGUgc2d4X25yX2ZyZWVfcGFnZXMgY291
bnRlciB0aGF0IGlzIHVzZWQgb25seSBmb3INCj4gcGFnZSByZWNsYWltaW5nDQo+ID4gYW5kIGNo
ZWNrZWQgaW4gYSBzaW5nbGUgcGllY2Ugb2YgY29kZS4NCj4gPiBUbyBnaXZlIHlvdSBhbiBpZGVh
IHRoZSBwcmV2aW91cyBpdGVyYXRpb24gb2YgdGhlIGNvZGUgbG9va2VkIGxpa2UgYmVsb3cuDQo+
ID4gRmlyc3QsIEkgaGFkIHRvIGRlZmluZSBhIG5ldyB1bmNvbmRpdGlvbmFsIHNwaW5sb2NrIHRv
IHByb3RlY3QgdGhlIEVQQyBwYWdlDQo+IGFsbG9jYXRpb246DQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jDQo+IGIvYXJjaC94ODYva2VybmVsL2Nw
dS9zZ3gvbWFpbi5jDQo+ID4gaW5kZXggYzhhMjU0MjE0MGExLi40ZjQ0NWMyODkyOWIgMTAwNjQ0
DQo+ID4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jDQo+ID4gKysrIGIvYXJj
aC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jDQo+ID4gQEAgLTMxLDYgKzMxLDcgQEAgc3RhdGlj
IERFRklORV9YQVJSQVkoc2d4X2VwY19hZGRyZXNzX3NwYWNlKTsNCj4gPiAgICovDQo+ID4gIHN0
YXRpYyBMSVNUX0hFQUQoc2d4X2FjdGl2ZV9wYWdlX2xpc3QpOw0KPiA+ICBzdGF0aWMgREVGSU5F
X1NQSU5MT0NLKHNneF9yZWNsYWltZXJfbG9jayk7DQo+ID4gK3N0YXRpYyBERUZJTkVfU1BJTkxP
Q0soc2d4X2FsbG9jYXRlX2VwY19wYWdlX2xvY2spOw0KPiANCj4gDQo+IA0KPiA+DQo+ID4gIHN0
YXRpYyBhdG9taWNfbG9uZ190IHNneF9ucl9mcmVlX3BhZ2VzID0gQVRPTUlDX0xPTkdfSU5JVCgw
KTsNCj4gPiAgc3RhdGljIHVuc2lnbmVkIGxvbmcgc2d4X25yX3RvdGFsX3BhZ2VzOw0KPiA+IEBA
IC00NTcsNyArNDU4LDEwIEBAIHN0YXRpYyBzdHJ1Y3Qgc2d4X2VwY19wYWdlDQo+ICpfX3NneF9h
bGxvY19lcGNfcGFnZV9mcm9tX25vZGUoaW50IG5pZCkNCj4gPiAgIHBhZ2UtPmZsYWdzID0gMDsN
Cj4gPg0KPiA+ICAgc3Bpbl91bmxvY2soJm5vZGUtPmxvY2spOw0KPiA+ICsNCj4gPiArIHNwaW5f
bG9jaygmc2d4X2FsbG9jYXRlX2VwY19wYWdlX2xvY2spOw0KPiA+ICAgYXRvbWljX2xvbmdfZGVj
KCZzZ3hfbnJfZnJlZV9wYWdlcyk7DQo+ID4gKyBzcGluX3VubG9jaygmc2d4X2FsbG9jYXRlX2Vw
Y19wYWdlX2xvY2spOw0KPiA+DQo+ID4gICByZXR1cm4gcGFnZTsNCj4gPiAgfQ0KPiA+DQo+ID4g
QW5kIHRoZW4gYWxzbyB0YWtlIHNwaW5sb2NrIGV2ZXJ5IHRpbWUgZXVwZGF0ZXN2biBhdHRlbXB0
cyB0byBydW46DQo+ID4NCj4gPiBpbnQgc2d4X3VwZGF0ZXN2bih2b2lkKQ0KPiA+ICt7DQo+ID4g
KyBpbnQgcmV0Ow0KPiA+ICsgaW50IHJldHJ5ID0gMTA7DQo+IA0KPiBSZXZlcnNlIHhtYXMgdHJl
ZSBvcmRlci4NCj4gDQo+ID4gKw0KPiA+ICsgc3Bpbl9sb2NrKCZzZ3hfYWxsb2NhdGVfZXBjX3Bh
Z2VfbG9jayk7DQo+IA0KPiBZb3UgY291bGQgdXNlIGd1YXJkIGZvciB0aGlzLg0KPiANCj4gaHR0
cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjYuMTMuNy9zb3VyY2UvaW5jbHVkZS9saW51
eC9jbGVhbnVwLmgNCj4gDQo+ID4gKw0KPiA+ICsgaWYgKGF0b21pY19sb25nX3JlYWQoJnNneF9u
cl9mcmVlX3BhZ2VzKSAhPSBzZ3hfbnJfdG90YWxfcGFnZXMpIHsNCj4gPiArIHNwaW5fdW5sb2Nr
KCZzZ3hfYWxsb2NhdGVfZXBjX3BhZ2VfbG9jayk7DQo+ID4gKyByZXR1cm4gU0dYX0VQQ19OT1Rf
UkVBRFk7DQo+IA0KPiBEb24ndCB1c2UgdWFyY2ggZXJyb3IgY29kZXMuDQoNClN1cmUsIHRoYW5r
cywgSSBjYW4gZml4IGFsbCBvZiB0aGUgYWJvdmUsIHRoaXMgd2FzIGp1c3QgdG8gZ2l2ZSBhbiBp
ZGVhIGhvdw0KdGhlIG90aGVyIHZlcnNpb24gb2YgdGhlIGNvZGUgd291bGQgbG9vayBsaWtlLiAN
Cg0KPiANCj4gPiArIH0NCj4gPiArDQo+ID4gKyBkbyB7DQo+ID4gKyByZXQgPSBfX2V1cGRhdGVz
dm4oKTsNCj4gPiArIGlmIChyZXQgIT0gU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZKQ0KPiA+ICsg
YnJlYWs7DQo+ID4gKw0KPiA+ICsgfSB3aGlsZSAoLS1yZXRyeSk7DQo+ID4gKw0KPiA+ICsgc3Bp
bl91bmxvY2soJnNneF9hbGxvY2F0ZV9lcGNfcGFnZV9sb2NrKTsNCj4gPg0KPiA+IFdoaWNoIHdh
cyBjYWxsZWQgZnJvbSBlYWNoIGVuY2xhdmUgY3JlYXRlIGlvY3RsOg0KPiA+DQo+ID4gQEAgLTE2
Myw2ICsxNjMsMTEgQEAgc3RhdGljIGxvbmcgc2d4X2lvY19lbmNsYXZlX2NyZWF0ZShzdHJ1Y3Qg
c2d4X2VuY2wNCj4gKmVuY2wsIHZvaWQgX191c2VyICphcmcpDQo+ID4gICBpZiAoY29weV9mcm9t
X3VzZXIoJmNyZWF0ZV9hcmcsIGFyZywgc2l6ZW9mKGNyZWF0ZV9hcmcpKSkNCj4gPiAgIHJldHVy
biAtRUZBVUxUOw0KPiA+DQo+ID4gKyAvKiBVbmxlc3MgcnVubmluZyBpbiBhIFZNLCBleGVjdXRl
IEVVUERBVEVTVk4gaWYgaW5zdHJ1Y3Rpb24gaXMgYXZhbGlibGUgKi8NCj4gPiArIGlmICgoY3B1
aWRfZWF4KFNHWF9DUFVJRCkgJiBTR1hfQ1BVSURfRVVQREFURVNWTikgJiYNCj4gPiArICAgICFi
b290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfSFlQRVJWSVNPUikpDQo+ID4gKyBzZ3hfdXBkYXRlc3Zu
KCk7DQo+ID4gKw0KPiA+ICAgc2VjcyA9IGttYWxsb2MoUEFHRV9TSVpFLCBHRlBfS0VSTkVMKTsN
Cj4gPiAgIGlmICghc2VjcykNCj4gPiAgIHJldHVybiAtRU5PTUVNOw0KPiA+DQo+ID4gV291bGQg
eW91IGFncmVlIHRoYXQgdGhpcyB3YXkgaXQgaXMgbXVjaCB3b3JzZSBldmVuIGNvZGUvbG9naWMt
d2lzZSBldmVuDQo+IHdpdGhvdXQgYmVuY2htYXJrcz8NCj4gDQo+IFllcyBidXQgb2J2aW91c2x5
IEkgY2Fubm90IHByb21pc2UgdGhhdCBJJ2xsIGFjY2VwdCB0aGlzIGFzIGl0IGlzDQo+IHVudGls
IEkgc2VlIHRoZSBmaW5hbCB2ZXJzaW9uDQoNCkFyZSB5b3Ugc2F5aW5nIHlvdSBwcmVmZXIgKnRo
aXMgdmVyc2lvbiB3aXRoIHNwaW5sb2NrKiB2cy4gDQpzaW1wbGVyIHZlcnNpb24gdGhhdCB1dGls
aXplcyB0aGUgZmFjdCB0aGF0IHNneF9ucl9mcmVlX3BhZ2VzIGlzIGNoYW5nZWQNCmludG8gdHJh
Y2tpbmcgb2YgbnVtYmVyIG9mIHVzZWQgcGFnZXM/IA0KDQo+IA0KPiBBbHNvIHlvdSBwcm9iYWJs
eSBzaG91bGQgdXNlIG11dGV4IGdpdmVuIHRoZSBsb29wIHdoZXJlIHdlIGNhbm5vdA0KPiB0ZW1w
b3JhcmlseSBleGl0IHRoZSBsb2NrIChsaWtlIGUuZy4gaW4ga2V5cmluZ3MgZ2Mgd2UgY2FuKS4N
Cg0KTm90IHN1cmUgSSB1bmRlcnN0YW5kIHRoaXMsIGNvdWxkIHlvdSBwbGVhc2UgZWxhYm9yYXRl
IHdoeSBkbyBJIG5lZWQgYW4NCmFkZGl0aW9uYWwgbXV0ZXggaGVyZT8gT3IgYXJlIHlvdSBzdWdn
ZXN0aW5nIHN3aXRjaGluZyBzcGlubG9jayB0byBtdXRleD8gDQoNCkJlc3QgUmVnYXJkcywNCkVs
ZW5hLg0KDQo=
