Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F151125DAE0;
	Tue, 20 May 2025 06:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747723006; cv=fail; b=ISQtz1uVdR/GbrheBZRVhLW2nIrCpkfkgPKkkDSwB2pH0qpXGvZCriJtHEt6F2SfNmyEe20Wlxq3tN2zJKeERlxAMzAZJ9lRq7SMlEIcYY08nuJ4u51o9S1uPSw6TR84+fHprnC8oyBFq90afKG9tTqeV/xYqpAWROGfPOQAsW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747723006; c=relaxed/simple;
	bh=usDlqe67K5Q4AO2+alahN8Y2OgIJM5oZyDAnjDBqhao=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gUZdY42Emr7EX5DyiOmV21JqFBaV9VBaKrCQapzySZ1CviHERDJUFvrzHBOg6s1yUZPIcSqBf1lLHrmpTWPT5g5YX4BCn7NgZpTw9nubyHDa7+pUxuN1e9eTs5IHk4MMsf9ihFcHDtbQyZqzWW6M5HiSEt3SyGzpPWhtQreiE3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OWtwUsPB; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OWtwUsPB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747723005; x=1779259005;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=usDlqe67K5Q4AO2+alahN8Y2OgIJM5oZyDAnjDBqhao=;
  b=OWtwUsPBVrcqA3H52aFP8ZS7gVTVFCgc4i4oN0kyTQJJK1z98ogJQDpp
   E88ETbHuNSeF7BPalXreajDD+73JGUGy+DizN6fLg2XHWi2+eEv9hc1ZY
   KdyBnjTp7G3g+RIgGq3shewuq3c9Z0RaiZuAjYg6CmveNcPWnfHkazxKh
   Ip2lKy3jScPYxSD4uwilz4Ub68GnVPpn6r3onTi/oig+5p6z++3RdKLHB
   Y2pYwGYYsM235mISk1Qxk2LUgo7ir8FrhPr2Yh4i5mfFg6OGkFirrYSOK
   RiRNKf1SoMlaQykPZIrih5rDV1uUQzHORb4l/9X1kjfAImnHtLg3Vq5sy
   Q==;
X-CSE-ConnectionGUID: PxhFG3aaTbyL0HQOdoEXfA==
X-CSE-MsgGUID: oSsM7u16Qf+Wx9WceShXgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="48754866"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="48754866"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:36:44 -0700
X-CSE-ConnectionGUID: nYYwMjROSQam+cvd/CMQkQ==
X-CSE-MsgGUID: aGh/013LRhS+Lakn4W88IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="176714344"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:36:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 23:36:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 23:36:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 19 May 2025 23:36:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E1Qy2DBS8PL39DTrrByGY0hfgkTUp96VpWPgo1knX7IJL3LBTH/mtFewi17hvZz/gnGsmRyLaOVRfv9qDPu/eSpd2WtnpRTHPkZxiS1ppQvIQAjhZ+7QPK7yRzQVfneAvrqh83iKgJAlVe/Xn86WGb+LRhqFikNhG5wSwr1W7uojxWVNu1XGwr2L6lcWJrvORxT2zjXuy+vsieOX0LW0s2JGQAxNtA0uShso3bvC5HQpcNBjuLjqyxVxmum/+IAWnYKNQJdaUtXPhteP/o1EnnBvkdKS1XYXR+HSkBIV+vEcUCRUxayft3NedtYuEUeqiJ+MXtf54/IYUqAouBHHHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usDlqe67K5Q4AO2+alahN8Y2OgIJM5oZyDAnjDBqhao=;
 b=oCIBa5vnGelDiEj6VNcpT0Re7fq+HgAGIPmI17OJ2KXX1X4Em7iv2BfCbGNoKEcWWtrJ5GezMS1ne5k8nVg4U+GQa+cijo/0hyEmpxjGxhmBr7XiNwPUTPk0PGCnK7j8DAZLtz7j2ldSrn94W8tzyyawwmy30D6lqeYr2KbWB6kgcTs68/FlrpRXFMOOlSdWf3IxySOZC4T2zCLKy4hl9e1QijZoLygIHoppgMWuxJUy0CfeMI32WNc7/ktFbQ6mOkkOsDMWP2eKU8Qe2SkHbDGLQ5BY3I9JdU5SqDZ1zz0e8KiAWJT1w9+PzxGn16WyBFSP1CYzNzicBdRMftVrVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH8PR11MB6927.namprd11.prod.outlook.com (2603:10b6:510:225::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Tue, 20 May
 2025 06:36:34 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Tue, 20 May 2025
 06:36:34 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "Raynor, Scott"
	<scott.raynor@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Mallick, Asit
 K" <asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Cai,
 Chong" <chongc@google.com>, "bondarn@google.com" <bondarn@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: RE: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHbyI9nyiauVlst/UyvS30ic5Ez1bPZ0msAgAABgdCAALpzgIAAgluQ
Date: Tue, 20 May 2025 06:36:34 +0000
Message-ID: <DM8PR11MB5750A36D0EC47701322E0683E79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
		 <20250519072603.328429-5-elena.reshetova@intel.com>
	 <990841309a27d4f3e7c53b44d7cce0e555594a21.camel@intel.com>
	 <DM8PR11MB5750CC5686E413A88CF41D7DE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
 <0c2f968860af68e65cebaf4f99a764d28e8a1030.camel@intel.com>
In-Reply-To: <0c2f968860af68e65cebaf4f99a764d28e8a1030.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH8PR11MB6927:EE_
x-ms-office365-filtering-correlation-id: 894abc27-7818-4508-a119-08dd9768aa1d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UHRaWEtES2RQZDhyS1cyZ0orNS9RUWxRczF4ZXlLSndQaFgxWmJ1bEZlY0ZP?=
 =?utf-8?B?MDRjc3VadVZkNkl5TDZHa2Y0bUtaK2ZHK0Zsd2FZMUNFOElCR0RaNTc5M01u?=
 =?utf-8?B?OTNyYW53Z3VNdlJ0SGJLK1hmSGc0aXRCd1FqazhMd3QzVzhQdmlKYkNDclM0?=
 =?utf-8?B?R1hzZkR4N3FHdkc5UE12VFFTVEkyZml1UlZXYWlTYnBWdmtpaWVsckU0Z0Fx?=
 =?utf-8?B?ZzhqQXN6Q3NkeWNmdkJPcWJrUi96cnFyRlBUOHVINFJSN1hEWWpvRlJqUVlN?=
 =?utf-8?B?UWRRNDRQR0xKNDhOcEM3T1BWOXBxdmQyTUJlRHVvWjkrbElYWlZZbWxLUEZP?=
 =?utf-8?B?Y3haVVVVZXJIMU1aNGV2RjVpUVFZN0ZuWm1xcnF2cDJDdms4KzcvSGtaRi91?=
 =?utf-8?B?ZFBta0lyUm1DSEVmY2FqNTR6VGlESHFzbUtnQm9YNEZxMi8rdFhscDJjb3Fr?=
 =?utf-8?B?aFlOdTRsdEttcXVJVjN6Tm5vc2ZxQ3lRWkNoWGhpbzlkRTVZMnFoTEdqcGdt?=
 =?utf-8?B?QzRmbEU1UkN2enBYS3huQWlDK0paUzVBQWRMVWtXM2NST0gzdVo3M0hScVhQ?=
 =?utf-8?B?VWYrQXJlWWw4WVhSWDRhTFRCVVFHbUZPTUI3dkJ6eFhCaGF0OUNzQ3hQeWFZ?=
 =?utf-8?B?am9ya2RkdkxITFZoM2RSclUzZ3J6T2RHSjMzR2NKRkI3TWMzS1c5Qmh1dVp5?=
 =?utf-8?B?RzlONVd3R0FhT0pGRG01UWJKQkZUTFdJT2NsWDZ3RGs3WHpWSTdzT2gwMVAx?=
 =?utf-8?B?VzMrbFRDejIwUmw0d3A4RFUvNHZLc0ZieUE3R2dBcks5dmNRLzdIZW5td1hu?=
 =?utf-8?B?N3VRbkwyUUhGZkZBa2FqVTg3dnl4WHB0bEJ0aVV4ejRSRnNJYUxyS1RxT04x?=
 =?utf-8?B?R3djRHVzNFptZk9aNFVub3pseDlBbFhUUHJSVTlRSFpQVlRnL292a1o1cUh0?=
 =?utf-8?B?L1AwMDJlWHB6cTdJTFU5SU43RE5GdGtFN2F3T3NJdWxkWitIZmZWMk00dXNE?=
 =?utf-8?B?K3M5d1FKQ0tjQjRUaEh4d2ZSdkNqVlhPU3g0ZmhNTmMxMEVTQmg4TnNrUTE4?=
 =?utf-8?B?ZGRKaTl2MWh6Slo1SFRnTG1UZ2Ezd2hTaEtEck15bWRjRVQzSTlmNWQra0Jy?=
 =?utf-8?B?b3MxeEtrSjNOOGJiNFRxVHhqSnVhZzdBVDh0Q2N2Q3lkaG9jQmxmQUl5eDgw?=
 =?utf-8?B?Q2ZCaWJkSWJtZ3Z0RExaSlNPVmNQWjRxUzZBS2hjcnlOb29qUkVLRUZUa1BQ?=
 =?utf-8?B?UStlbk1lZXFpQnRUQjRzREtqRGRGM2pET2hjYWRHL2VPejdaKzVUKzBnWWRh?=
 =?utf-8?B?R0NRUGYyRlVuTy9qaFloTFBjM2VLcUVldVh1YkVpcTdwWXJCMkJld3pORDho?=
 =?utf-8?B?ZHJHNUh4eUZ3ZTZBU0VFUU5MMEN6VlNuTENCN0RjN3BIM1VoazNlZTYwc3Rh?=
 =?utf-8?B?Zi8rRmFHOWFxbEpKbExJYjJ5bjc3SHRHODR0dFlLODRwelY4Qm5sSkZxMGp6?=
 =?utf-8?B?N2EzQjZxT3VTZmRtU3UwQi9hRXRnMTZFdG55Y2Y3VE5sd3c5NlZpRnorL0VQ?=
 =?utf-8?B?bng2eFM1T0IxTEh5ZTJwaDBXSlZYcGJiMUFaOTlnL1dSWmg3MlZoNlJjaVF3?=
 =?utf-8?B?RXhsQUovNldrakdrbTNVUE5ZS3BIQjhGS0Rvd1hxMGIrbWFOTkVIZ2QzUWtn?=
 =?utf-8?B?ekh3aFRvcHo0SGdLb2lRK25vaGlMM1Z6NWhRY1ByM2F5c0haVDl5Z3hqNUQ1?=
 =?utf-8?B?YmRYYW1qYzNtTVl3RS9MVktQV0Q5M0E5SHN3OFhlSHBDUzh3NWZaTmJIaVlC?=
 =?utf-8?B?NGthZjNnZW9OeDFBT1lKR2ZDcjZscTJoL0gxTWR2RFFHUTRRMGpON29DUzBr?=
 =?utf-8?B?TGZmKzdlenRrQ0pHRkQwYlhVZTNsbUs1QXlRNVNMQUp4UERGejN3MEZic0RV?=
 =?utf-8?B?b0hZNFcvaFpNcEZocXlHUjBGeGFkSk9DeHdYdUdlNDZvQjM2dVRpZU9IamxG?=
 =?utf-8?Q?ZCPIWtJnadS5y2Vj0EVxvSaNRHGQ/E=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V211N2JPQzFWWndHSmVyaXRZNnd1QTdrRGV6WlpURVNxTUtPdURnSThKSldj?=
 =?utf-8?B?TDM5Y2lVV3BCcS9YYUNVaTJBRVIzNEJkUnJvcldOeXVzU08vdnRoTHM3NG56?=
 =?utf-8?B?TGllcWtjNG9IOXh6ajlvQVdUN1ZSZTZ5ZmJZaHQ2TDl0Y0F6SmtxakRrODBj?=
 =?utf-8?B?b25CeWJCQ0ZDc3pSNWdjclNTWlFBaFRDM2VsdGpCNmJ3UUdrUEVwR1NkM0lt?=
 =?utf-8?B?T1l0TkpzMk9XU3cwdElCcGgrZ2xoN29aby9TQmNIanRuYXlUMmN5OTFIMDIx?=
 =?utf-8?B?YWZvSjRIZTRWOVFydUhxYlRHWVQzZVRReTVmTVJNMGE1NjZGYkdCZC91aHdJ?=
 =?utf-8?B?elNXUTc3enU1UVBPUHJ4ZGtMdlhhQ0MwWDZqMHNLNk0yOTNFMHdFQngyeHJE?=
 =?utf-8?B?SSt1dU9Dd01CbXNhTVZ6LzhWQnJ5V291blEyeWtMMUZwKzZ4QUtKUzVUU1ox?=
 =?utf-8?B?VFpteGxVV05wMTZIREtSWkd0RVFieDRQbUdEbVppOGdjWjMwa080L2VOcmdn?=
 =?utf-8?B?ZTFXblQvT2dab0pyK3lPc2NocGIxSjI4dzVGalkxYnB0QjBXR2JlV1p3bzdI?=
 =?utf-8?B?b2ZzaFdYUmh2RDRxaUc0L2c1dGFaSUx1RjN3RWpkUWNtYlVNVUNBcVpoemFu?=
 =?utf-8?B?S3h3Q0FTUFlsanpNKzV3WGN6UzREQXNyOE81WTlBbjlYRFRzVGhFVkxFSlBv?=
 =?utf-8?B?WUpWS29UcU00c0hPSnRpWndxbndjcmtiWHZ4QzZVWGhQSmJqTEhGNnAyaTZk?=
 =?utf-8?B?eU54bWtiNHh3WG8zY2pUUHBRZ0lmOWxtRDQ4SkRSMkNYV0tRd2dtcllLc2Fq?=
 =?utf-8?B?OW1uRTU2dE5qMDhOd3RCVitseDcyRGF5Q1BuaHlaYmFhTkJCMEZBT0srRjlN?=
 =?utf-8?B?bFZ1UlNWZS9VSm1ZUHpjUXNpMnV5QmQzdTR6OXNVY1VqZHpUSUZjZHZTN3JU?=
 =?utf-8?B?NFNBcm5KN2hNejByVGNsYTlQcnNkTldOajM3SG9IMmJnb3UrR2JIQnZyRGM4?=
 =?utf-8?B?V1pmMUhyMGFvb3h1SXZrMGU3bGc2OEVMSEpQVlRCM2traXZsUTcvYTBRTGVy?=
 =?utf-8?B?R3lpV0RkTGJ2OEtLWEtSbDJWR0V5N3dhak1iaG5CVThHMzhWMzhoR0hUTUpl?=
 =?utf-8?B?dkR3QmsrV3B3VCtDcnZFVjdNOHM4enM3d0hyaE9wYytESUtBdkErZllUM3gy?=
 =?utf-8?B?VnNmOGxQTGVlUTlPMHRKLzVWV2NIMXhPWjlJVExPY3M1Zk5LV1NxL3RFMDYx?=
 =?utf-8?B?OVFFbkNDWHZHNmJvUm1RcWIzaXNYZlpDb2lpaTdVc0gvT2Fxa0dpdWJyQlFY?=
 =?utf-8?B?bWN1aUtZRUJ2QmtuTXg1bGRtUzBDaFhwVk12eUZ4TncwYnFMdG5KWnFwaCtB?=
 =?utf-8?B?WEN6L1p4cTc4ZExjaVhjeVp1R3dFK3YyU1luZjA1OVRESTczeFFMNHlQd2th?=
 =?utf-8?B?anZZUUMvVWtmdjdhVUhmUjQ3TlZOZjFoZ2cwc0tlZTVhaG9rRW1MV3BGRmJp?=
 =?utf-8?B?Z0tweG1aWUZTY3pSTC92cVRwOThuOVE5WXhET3JDYVVCWW1wZ1BnTWsxdmlD?=
 =?utf-8?B?U3l4M0tlc1JETExPdzVUVXVOMXRrWHhpY0Z3d25mdTFzVkhNSUtsYlNTWWtv?=
 =?utf-8?B?bkRaUkR3VzRZRzF5MnJSSndieWpNN2pnNWlHRjVWQyt4MDVRK3hxeHA5OTU4?=
 =?utf-8?B?ZE42RU82RnJGSmVIZWMxMlk5ZDNwQWFnR0pZU1p3a0JXWFVXRitlb3hULzVp?=
 =?utf-8?B?QURLQm5JNWxJL2oxS3dsSjV3alpiOXltUkxPa3FabWtDQ1cvYzFVanJRM00x?=
 =?utf-8?B?WlhLQjVRN2V0dzlZU0JSSmxLa2M2dnBnTmNNQXB6N3cyTGdPRC9KVEE2bTFO?=
 =?utf-8?B?MHJsZVFHTnY5N3k1UUZZUS8zOXNmdThrRU5CUjNrMnpoaS9UWHhjSWdaU2NP?=
 =?utf-8?B?YjBMVFV3UEJHU1B2UVdXeHZkYkxBYUFzMllsNzloSFRkSFZQYUl6MkVNVXVQ?=
 =?utf-8?B?ZWJGWHZncXFQcnhiM3ROc05ZOExaTEs2RmV2U0N1clk2ZktCdTdHNy9PMFkx?=
 =?utf-8?B?OS9UcTk5dWpWdnBEYmlXMHhJWGZqWjVLVFpIRnI2Q2tTTU1UUDNTQXlvK1FH?=
 =?utf-8?B?aDY5bHFna0FTd1l5ajM2T3ZqcEwvYzVsTXFEaW1OTEt0SVBUS2xjTWsvajFJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 894abc27-7818-4508-a119-08dd9768aa1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 06:36:34.2812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VjqSbhbbbiMgbM638HbKqNLECi4ynyGnjCWQDjAGyIDpg9Fjy81TfzV5MXGC8NFI5nlwHW9f8h4PuH6ibdu/IB4M4jFva22K8SwDlu3Xnbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6927
X-OriginatorOrg: intel.com

ID4gPg0KPiA+ID4gV2h5IG5vdCBqdXN0IGZhaWwgc2d4X29wZW4oKSAoZS5nLiwgcmV0dXJuIC1F
QlVTWSwgb3IgLUVBR0FJTikgaW4gdGhhdCBjYXNlPw0KPiA+ID4gVXNlcnNwYWNlIGNhbiB0aGVu
IHJldHJ5Pw0KPiA+DQo+ID4gVGhlIGlkZWEgb24gdGhlIHBhdGNoIHdhcyB0aGF0IHN1Y2ggYSBz
Y2VuYXJpbyB3aGVyZSB3ZSBydW4gb3V0IG9mIGVudHJvcHkNCj4gPiBzaG91bGQgbm90IGhhcHBl
biBpbiByZWFsIGxpZmUgdW5sZXNzIFJEU0VFRCBpcyB1bmRlciBzdHJlc3MgKGluIGNhc2Ugd2UN
Cj4gPiBhY2NpZGVudGFsbHkgY29sbGlkZWQsIHdlIGRvIGEgMTAgdGltZSByZXRyeSkuIFNvLCBp
biB0aGlzIGNhc2Ugd2Uga2VlcCB0aGUNCj4gbGVnYWN5DQo+ID4gYmVoYXZpb3VyLCBpLmUuIHBy
b2NlZWRpbmcgd2l0aG91dCBFVVBEQVRFU1ZOLiBCdXQgSSBjYW4gY2hhbmdlIHRvIHRoZQ0KPiBh
Ym92ZQ0KPiA+IGxvZ2ljIHRvIHJldHVybiAtRUFHQUlOIGluIHRoaXMgY2FzZSBpZiBldmVyeW9u
ZSB0aGlua3MgaXQgaXMgYSBiZXR0ZXINCj4gYXBwcm9hY2guDQo+IA0KPiBXZWxsIEkgdGhpbmsg
SSBhbSBzZWVpbmcgY29uZmxpY3RpbmcgbWVzc2FnZToNCj4gDQo+IFlvdSBtZW50aW9uZWQgaW4g
djQgdGhhdCBzb21lIHNpbXBsZSAodXNlcnNwYWNlISkgdGVzdHMgY2FuIG1ha2UNCj4gRVVQREFU
RVNWTiBmYWlsDQo+ICJyZWxpYWJseSBhbmQgcXVpdGUgZWFzaWx5IGV2ZW4gd2l0aCAxMCB0aW1l
IHJldHJ5IGxvb3AgYnkga2VybmVsIi4gIFRoaXMgc2VlbXMNCj4gdG8gbWUgdGhhdCAiUkRTRUVE
IGlzIHVuZGVyIHN0cmVzcyIgY2FuIGNlcnRhaW5seSBoYXBwZW4gaW4gaW4gcmVhbCBsaWZlLg0K
PiANCj4gT3IgYXJlIHlvdSBzdWdnZXN0aW5nIHRoYXQga2luZGEgInNpbXBsZSB0ZXN0cyIgY2Fu
bm90IGhhcHBlbiBpbiByZWFsIGxpZmU/DQoNClllcywgb25seSB1bmRlciBleHBsaWNpdCBhdHRh
Y2suIA0KDQo+IA0KPiBFdmVuIHdlIGFncmVlIHRoYXQgc3VjaCB0ZXN0IGNhbm5vdCBoYXBwZW4g
aW4gcmVhbCBsaWZlLCBzaW5jZSB1cGRhdGluZyBTVk4gaXMNCj4gYWJvdXQgc2VjdXJpdHksIEkg
dGhpbmsgaXQncyBxdWl0ZSBmYWlyIHRoYXQgd2UgbmVlZCB0byBjb25zaWRlciB0aGF0IHRoZQ0K
PiBwbGF0Zm9ybSBpcyB1bmRlciBhdHRhY2suDQo+IA0KPiBBbGxvd2luZyBlbmNsYXZlIHRvIGJl
IGNyZWF0ZWQgd2hlbiBFVVBEQVRFU1ZOIGZhaWxzIGR1ZSB0byBydW5uaW5nIG91dCBvZg0KPiBl
bnRyb3B5IGlzIGEgY2xlYXIgdmlvbGF0aW9uIG9mIHNlY3VyaXR5IHRvIG1lLiAgQW5kIHdoYXQn
cyBldmVuIHdvcnNlIGlzDQo+IEFGQUlDVA0KPiB1c2Vyc3BhY2UgaXMgbm90IG5vdGlmaWVkIGFi
b3V0IHRoaXMgYnkgYW55IG1lYW5zLg0KDQpUaGVyZSBpcyBubyBzZWN1cml0eSBpc3N1ZXMgc2lu
Y2UgeW91IGNhbiBhbHdheXMgc2VlIHRoZSBDUFUgU1ZOIHZpYSB0aGUNCnJlbW90ZSBhdHRlc3Rh
dGlvbiBwcm9jZXNzIG9mIHRoZSBnaXZlbiBlbmNsYXZlLCBzbyB5b3Ugd2lsbCBrbm93IGZvciBz
dXJlDQp3aGF0IG1pY3JvY29kZSB5b3UgcnVuIHdpdGguIEFuZCB3ZSBoYXZlIHRoaXMgdGlueSBo
ZWxwZXIgaW4gdGhlIGZvcm0gb2YNCnByX2luZm8oKSB0byBpbmRpY2F0ZSB3aGVuIGtlcm5lbCBm
aW5hbGx5IG1hbmFnZWQgdG8gZG8gdGhlIHVwZGF0ZSBzdWNjZXNzZnVsbHkuDQpCdXQgb3ZlcmFs
bCBJIGFncmVlLCBsIHdpbGwgY2hhbmdlIHRoZSBsb2dpYyB0byByZXR1cm4gLSBFQUdBSU4gb24g
ZW50cm9weSBpc3N1ZXMsDQphbmQgc210aCBsaWtlIC1FSU8gb24gb3RoZXIgbm9uLWV4cGVjdGVk
IGVycm9ycy4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
