Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6FE20C02A;
	Thu, 24 Apr 2025 08:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745483690; cv=fail; b=Fi/MKM+ckTnZXIfsR5JoeJsTH0R1Jn7OYS778sgapZ4LRdm4KZ+rcwVk0vPX3yzLI7VY5ugXC9cXkMLnPg/lViMn/NNOieNVY4KYOtPMXbFnIu7EIyRSn/z5il485Lgq+OMLGusBHG2aIjSlKYbCngbfh7e0bG4w9ajIyBzztw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745483690; c=relaxed/simple;
	bh=6Z+Sa9Hb3IyFrRv4fN2xaJKLOJiODS9Cqf5mOVB00eo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Eb1iPQWWWcVeOIpP8RFxzf3G7s4ZSUkuTKe3893XS9Vfdm0v5Kj+c6k5NvAevTHDvl+CouZUDRrAKe4yugwWrvJH8Vkx9cligWZAmF5yYnPPSLxi/7yK+oNGiKrB2RnDYyhoQPrWXRLQKZ0q4ITcGMJ57ymEtUdG9vjN6vkNhw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SwwKO0tw; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SwwKO0tw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745483688; x=1777019688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6Z+Sa9Hb3IyFrRv4fN2xaJKLOJiODS9Cqf5mOVB00eo=;
  b=SwwKO0twxzb6cYNH+o+2pAqPgwJeWqtJKoE3VwKtQBEnND8hqkgAowti
   YmAc3bgUqpGWAculoyQk0+a/yJVqOfdYV0osB+2V8F+Zi7Cg2cs5d24UM
   d1uk+bFcFJHnsUpiSg0MPtleKhBJIzBfd05/HvxOQvuJFbe4S0ZqKhzEF
   tpTEwcucKQKGrCAKpnKpz+yBLRbvr2NBPf+po/DEhIX9rLwzvrGZv3xJX
   XQ4Eg80r/7qmr3Rh12IJLp5l92RyEzIu+pfdcQupwSOGkFNRIWFp91TK9
   Eg/grW8dH+ReISHnyxP9fEbtOfRh9VsStnFRSE+36aDdVovvcTnvrRKOS
   w==;
X-CSE-ConnectionGUID: nBvo3Cm9RrWeyP8Y06WR1w==
X-CSE-MsgGUID: 020r5rBYRbGB7mOWfApldg==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="46335733"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="46335733"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:34:45 -0700
X-CSE-ConnectionGUID: gb8lPBEtQb+3VtZYhN+qfw==
X-CSE-MsgGUID: 4YHxYO4GS6uLjETwK4tSBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="132391649"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:34:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 01:34:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 01:34:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 01:34:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IH7uOzmNP2/ksoS8+nZMhj1XPUZgHeqZZ+k2cHFO2GWKpix0CUKhTyn4U/H7XzRJqpGRAwYRIOwGVdUr2dl2zzoptcGNuXmEp3YjS0cFrRpHbK4KYUSpK/Vbs9rvdYmSkB/LgiQsMWICk/0AynLtnxdfqzfCETnZQiaxEOcxLjYRFc5VRgSK6WSOExOpuRdCPV3LA56foId1wMo6nOA06hqc4k/LgWUveAkqfcHNUKIrRahGEIpAQVT4hrgovdtfH0a0D29cEjSJUpstxhQG7tLKMuuNZOlF0Ggl5d39DjSZ6vLDPNHlbUsVGAwrPNZu3qRv0ChluD3TA0kmI1aCQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Z+Sa9Hb3IyFrRv4fN2xaJKLOJiODS9Cqf5mOVB00eo=;
 b=oxND2kIY/JJ+Oo3/cFRKD3p7ELWOz5O97uAK6bpfn3WlGzmfxSQQN6xwjfhvbUPEE3RTEKhZiLfuwYoLmCD2sDpojrrIznCzfne8r6t08opbnDGR2jBm/NHJ7onwAgSjalMWwGO4uULjQq1jiqJ83p2Dif1/3kdtjvpzZDMil0j9gbUvk0GvhspPwMTa3X7d0vdLHHUxPjMA7dY/DxfbeIT5Gd9qjySSaoSGCtVzg1BR+bBNr+JHKNPwfL+JMAW59jh6V90y5yj0pVs7RSG2bh3piiFR1njMsrL4oDEv93e8jwlJbHiqbYB4pe/alJeLknoccGURKgAZrE803W6ErQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 LV2PR11MB5999.namprd11.prod.outlook.com (2603:10b6:408:17d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Thu, 24 Apr
 2025 08:34:38 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%7]) with mapi id 15.20.8678.021; Thu, 24 Apr 2025
 08:34:37 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Sean Christopherson <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Cai, Chong" <chongc@google.com>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bondarn@google.com" <bondarn@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbrfzujDHiSNozs0m8Z6fqnS5FZ7Oph/QAgAXK54CAAG1QAIACw3gA
Date: Thu, 24 Apr 2025 08:34:37 +0000
Message-ID: <DM8PR11MB5750B37305B3B1FAE4F42D3AE7852@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
 <20250415115213.291449-3-elena.reshetova@intel.com>
 <aAJn8tgubjT5t7DB@google.com>
 <f5cb3c37589791b2004a100ca3ea3deb9e1ae708.camel@intel.com>
 <aAefmNVRFc3me6QQ@google.com>
In-Reply-To: <aAefmNVRFc3me6QQ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|LV2PR11MB5999:EE_
x-ms-office365-filtering-correlation-id: 977f855e-c006-4a4d-d3b3-08dd830ad985
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NkphNjRZTjN4djBFVk5LYzNLRkNPNjlOOVJSb1hZbER0QjliTGdWaVpwRFd6?=
 =?utf-8?B?M2ZDL0QvaUN3VVFKWm5iNzBvYTI5RmRPam1uR25acUlqVi9NU2syQ1RwclVx?=
 =?utf-8?B?TjVYSS84NTcxbkFCRFFrcVozTU9TSkRVaHpPaTlCSFJZV1dkclY5cHBFd3BW?=
 =?utf-8?B?UzBQQXdRdkQyVjNBQUxyNDlJUUxDdHltbDVXODlNM2RrWWE5Y0NOZHVjUGJt?=
 =?utf-8?B?cDdVVmloODJOYlBJWXJFV0JjR0xMdW00RnVnWjFFK28ydG5FbWJvU3NRc3Jp?=
 =?utf-8?B?eG9KeHhHNlhZWVVhMjJ6amFrMkh6UUxFSng4UE42b3Q5Y29OaWQ5elNMem5S?=
 =?utf-8?B?Rm11aVpWbkdBdnAxRzIrSUhtNHJET2laTDhXZlFBNFlTUzI4VFBvaXNUNS9l?=
 =?utf-8?B?QnJaNnBVMlY2Mmpoc3V0ZnBVVlVWWEE2Yzd6VmVHSEUwbGgxSEoyTFl3MHdF?=
 =?utf-8?B?Y2NuS0JtQjM0WFZrSi9xY3pua084SWdtVHNxais3ZmZtb3Mrb3NSWEZ2Q1l0?=
 =?utf-8?B?ZXhWam8wcldLZFdKczZCMmZRNWtCSFZvK0R1elc4bDNUaUt1K3pOaDNkVGd6?=
 =?utf-8?B?ODNBS0RXVU9KbDkzMWFkaEo3OWlJQ2hyN1lyR29NRUIxTTRkU01HWUFGV05I?=
 =?utf-8?B?cW1MVEF0THRYN1ZVa0g3YWpNQmVNNHdZTWwwWVNWMjJRV2tINFVkbEVVdHdE?=
 =?utf-8?B?YVpKNXQ5c3pSUHBTUlYvUzBzVG01dFQ5SGdSeUZJRll5cE5MSCt1NEtST1Rk?=
 =?utf-8?B?R2pka3piSG43Y05QY2tlYmpJUmYzNEduNUNydDcxaDFseTd6L0FZNjlJbW1l?=
 =?utf-8?B?bmR3b2xQd0FYSEo2dUYyMGo3YnNVbFpkSnE2c1FDajVkRFFsRldhUEdxTHAr?=
 =?utf-8?B?SVc4bmlYM3dJZENwOVM5RnVwbGg5Q1BaWnkxNXNrUFVDbGd3elJGMUdFMWJp?=
 =?utf-8?B?VGNhMkgyYmFKODB0RldTOEpkQ0ltRlFtSDg3MkFQay92SG5DTU54eTlxbzF0?=
 =?utf-8?B?dE0yYVNVbkJFbjdMdWlpVmJJMC82Ukw1djY2Tzd2TnJsZlREeDlybSs1NkJy?=
 =?utf-8?B?WDFMSzdKK2dHV3RnYmI3QTJ2Z0lrU0RXZkhkVnNYQmFCeU1ubWk1dWpEem8w?=
 =?utf-8?B?cmNua3JoK1c1bUhicXpxVU1YL2JjY2VETWFyZ092UzhxUW5PekZYUXltNXZi?=
 =?utf-8?B?K2Q4T3FDclhNREJaajYwUzJoMEp6a05wS3EzSE10TUZNeExWWmtYdkxWSEdy?=
 =?utf-8?B?ZHlBUU1DYUZ6YXhCZ0Nta0hyeVQwZVJjQ2dwOUIxcEVTTnI1czhTM3NCNkFM?=
 =?utf-8?B?VEZYZ0pNK2FXdjlxWGNGeEtNUXIrM01rWnpsYkJHL09sTGJpVHd0d1ZMYTZM?=
 =?utf-8?B?SDBKSjFld2FabVBFU3RCV2RyelFiOTY5cndMSFE4MlhBMGZDSnhEMERxZ0px?=
 =?utf-8?B?cVZWL3NSbDRYWXF1R3JlMDFyTnlsMlpEcy9VV2NZS0dWcGZmempkN092MUxM?=
 =?utf-8?B?dWlJUmd3Mi9MVk00YXY5RFBVY1dIM1pEQlJscGNPb3B5S3NBN3ZhMWxPK2lo?=
 =?utf-8?B?bUdMRnFkZ1U0YTZsc1VFSnZabCtYRVI4UFlPUVE1NmpJUzYvbk9LRy8rdVUy?=
 =?utf-8?B?am5TYW5XSmpITFI4eFpBSmdzMXNBbUVMQWt5NW9FakRGM1c1dTliODR1MGY5?=
 =?utf-8?B?NDNkbXZXb2dzMVNMU2llOFJPUFRRTGJIZEhqU1J4c1Fwekp5NDJQcVVJM2p5?=
 =?utf-8?B?Vzg5VHlOQ2o4R0daOUNpdE90MlI4MFVYcDNSK2Y3RDlUNW1TK3k5U0c4ZDhC?=
 =?utf-8?B?cGthQ3dzTnlSQWNZSytXUU5YUTJNazlBOEJWQk9DL0hQczkyMFpBLyt0Yjg0?=
 =?utf-8?B?Ujl5TnJhZmhxczRTZDVTNXZTcmZSOVNFSVhJbGF1d1FaT2xBSVJ0cmZSaEMy?=
 =?utf-8?B?c2o4Y01tOEJSRVRBdStpaG84VUd6MTdEamZDbWpSNnRsNkJ4OVEwcHA5VkM1?=
 =?utf-8?Q?F/O07uqFkh7GlQObKG6Ftv9t7fGSO4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTBnMlVSOGNJT1BjK2tEN1ZoUk9GRVE0VE5RMndXcm01QUx1NGV4UXJ5Titl?=
 =?utf-8?B?TmRLeXNCWVRGNDFUclNiV284SXB0SlFDNHRodnNsdktzcHZaKzFNWVZuRDN5?=
 =?utf-8?B?N1luaDkwVXA2RERMa2Q1ZC9yZzMxRjZQTWIvc1RYUXRZR1BMZnJjc1NTc09r?=
 =?utf-8?B?WHlpdDY3ZzVZSk9sdzlQZmlyRUU4cm5VeVI1eTN2ZGdUMEphN3g5VGx4RjVF?=
 =?utf-8?B?ZVQ2Q3hHZEtFUHJ4cEN2QzNlOEYwS09lSU1qVUttb0dvTGh5aGh3ZjFwM1Rr?=
 =?utf-8?B?RWFJYjRXaDZEUG5mYU1PcmlKNXZpMkhqMUpwVTZ3YUhkOTE0QlRrYUdkU2l0?=
 =?utf-8?B?a1NmeDVtWkxWY1BMbTVYSllaY3hkaEJDdTdWRTljdStlQWFnd2FsNHc4UjJp?=
 =?utf-8?B?QUJqZ3NuTy9DT0xFTldZMENYSXdSdFBpL2hjN0FQUEVKTlhDeDIxWVhYNlV5?=
 =?utf-8?B?S2Z6L2IwQ1A5RCtpQlE3K0tMMExEMlpyQTRERFphWlF0WnFlM3R3K3pQdkVv?=
 =?utf-8?B?OUs4Q3ZDdXRRTk82cEpaRlU0UkpMNW44RUIvZXM4Qkk5MDExOWtXVThhTjRU?=
 =?utf-8?B?aVEvNVV1TzNyYUZ0YUhsZ1FUOXRMMEhvaEhoUVFIRGRFbEFQbHRzV2RqQzE4?=
 =?utf-8?B?K2EwOERrT2g5T1hRck03Slp5eGJORHBBRDFuenlYUDRqR1RQRVVXRG1oMmto?=
 =?utf-8?B?QTlhN2dpSFhsKzdNOUNTeEkzZVRpNWwxZTZEYTdtM1BRa3duWTBKR0lzK01Z?=
 =?utf-8?B?NTBuRFpURmdyMnBEaTZ5MysxV1JkUU5URUtqRkJmbW0xZ3NSUjcxK2tLNTNv?=
 =?utf-8?B?c29KN2ZrUU9qM2JZa0J4Y0NrZU1FVWlaVFFQN0FNWkQvc2ovZ20yUWhYMTJq?=
 =?utf-8?B?MldaSXNuNWdMUnl0YkpaakRkbzJIRzVIeWFpUmx4OTZCTTYrOTc1cXl0QnhB?=
 =?utf-8?B?WDlDbURqOGhiYVk4NXg0SUpSQ2lOUVVVWUxHRkRhbnB2VXJ1TElvVjE0dmZ4?=
 =?utf-8?B?a05DUFZqaGtFN3grZ2Nwd01QNWRocFdCall5L3JMK3FDU25NOGF4T050MURK?=
 =?utf-8?B?dmhOQ0UwZWxyZmdEeUdsaDMvRmxIbEFrVkFZSHVMMW54UjFaWC9RZnhDdmQx?=
 =?utf-8?B?dUVyWVpHT05kV2w0OElPcmxUd2hMdWo1YlBPM2J3OWVkeXFwdXVRU1ZIeXdm?=
 =?utf-8?B?Z2U2aHlTQUtyRUdZSUdwcTBrNUNub0VlSUNFT1g3ZFpHRVR5M212YmhCNXl5?=
 =?utf-8?B?UnRoUFJ0aUJCelZ5dGRqR2I1MXVGQUtRbWZCYWEwWlR4VEJZU21saUwxWXRz?=
 =?utf-8?B?Wmw2cng0Y2wvUU5sMlFlTjQwd0JKZ1JoY3cxb1ZraEw1dTBWdmNwcmx1cG1W?=
 =?utf-8?B?cUk0MVhmVFp5OWdmZHhBZmZBTkhpS3lIdVB5aTFsK1lEb1NjOFJQL29SS3JE?=
 =?utf-8?B?SWRiajdvQzgwdkhhZTVndDZQK2dJVUd1RmJndHc0UVphemk0SVdMWURiRDNr?=
 =?utf-8?B?bU80WW9lSGFHVytRMnBxQmllSFBEckFEMHN0THNDeGtiMHhORXpJb0UvQlNl?=
 =?utf-8?B?dGFtVzM1Z2hFVEQ2aVc2Q1NFQ2lZT1JhSjhrcTBoZjV0UFlBUHJvcTNvSlIv?=
 =?utf-8?B?cFlRRmRqNFFVaHplZktxUG9xbFAvd0VmT1hrWjNGSTlOa2NuRVJpeThOaStG?=
 =?utf-8?B?eDd0dmliUC9uazM5aE44Z1k0OUgxM2Jvem9COVpOVXQ1UTExcTVEcThmZlJB?=
 =?utf-8?B?ODRvOEdPYStkKzd2NmIrQ1JBU1JPMW1IYi9qK0ljZkdTb0xndU1wVkJQWWxs?=
 =?utf-8?B?UzFYVWIxdmlVTTNZcmNUeVFXYlo1TDBNZVhTR3UrZXE5cWZKcDhwY1dOMUNQ?=
 =?utf-8?B?RnVuemtGR08xQVE2cEJGZ2JKUjVodFdMRnBSZW1ENTQ1ejhYL0RzUnZobFJa?=
 =?utf-8?B?QVAyNWhCQXBuRENDbzRRLzNlOVJBSG0zSVdJYTZWWlBSd1IxZGNvT0s5SFRB?=
 =?utf-8?B?ZkJPZW9RVm43RHVxdkxBR05BWktWeW1hOXdyOEx2WjNnM1kzc3dkT04yQ2t0?=
 =?utf-8?B?M1NyMFRLdFlGRDZ0SVNKR2NFNk1UZitaakRTcW1SRFYvUzg3SW4vRjlwYjRV?=
 =?utf-8?B?TmhvTTNDTFI5bUFEN3FSTjJoem1tc2hjdE0zUFJoVk1tU2dadVFlUzMrVFpq?=
 =?utf-8?B?V2c9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 977f855e-c006-4a4d-d3b3-08dd830ad985
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2025 08:34:37.8244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mEHoO1+JghF4pz41A0fwOPHaGslJMrIW8oWRSloTaf0L+nz36Sl1LnoUmHzR2rj1gfPh/L4Hd1uGNHY1Rwr61jnlRTHJiWR8CEcVUT83wVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5999
X-OriginatorOrg: intel.com

DQo+IE9uIFR1ZSwgQXByIDIyLCAyMDI1LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gT24gRnJpLCAy
MDI1LTA0LTE4IGF0IDA3OjU1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+
ID4gT24gVHVlLCBBcHIgMTUsIDIwMjUsIEVsZW5hIFJlc2hldG92YSB3cm90ZToNCj4gPiA+IFRo
YXQgc2FpZCwgaGFuZGxpbmcgdGhpcyBkZWVwIGluIHRoZSBib3dlbHMgb2YgRVBDIHBhZ2UgYWxs
b2NhdGlvbiBzZWVtcw0KPiA+ID4gdW5uZWNlc3NhcnkuICBUaGUgb25seSB3YXkgZm9yIHRoZXJl
IHRvIGJlIG5vIGFjdGl2ZSBFUEMgcGFnZXMgaXMgaWYgdGhlcmUNCj4gYXJlDQo+ID4gPiBubyBl
bmNsYXZlcy4gIEFzIGFib3ZlLCB2aXJ0dWFsIEVQQyB1c2FnZSBpcyBhbHJlYWR5IGFsbCBidXQg
Z3VhcmFudGVlZCB0bw0KPiBoaXQNCj4gPiA+IGZhbHNlIHBvc2l0aXZlcywgc28gSSBkb24ndCB0
aGluayB0aGVyZSdzIGFueXRoaW5nIGdhaW5lZCBieSB0cnlpbmcgdG8gdXBkYXRlDQo+ID4gPiB0
aGUgU1ZOIGJhc2VkIG9uIEVQQyBhbGxvY2F0aW9ucy4NCj4gPiA+DQo+ID4gPiBTbyByYXRoZXIg
dGhhbiByZWFjdCB0byBFUEMgYWxsb2NhdGlvbnMsIHdoeSBub3QgaG9vayBzZ3hfb3BlbigpIGFu
ZA0KPiBzZ3hfdmVwY19vcGVuKCk/DQo+ID4NCj4gPiBUaGUgb25seSB0aGluZyBJIGRvbid0IGxp
a2UgYWJvdXQgdGhpcyBpcyB3ZSBuZWVkIHRvIGhvb2sgYm90aCBvZiB0aGVtLg0KPiANCj4gQW5k
IGhhdmluZyB0byBtYWludGFpbiBhIHNlcGFyYXRlIGNvdW50ZXIuDQoNClNvcnJ5IGZvciB0aGUg
ZGVsYXllZCByZXNwb25zZSwgSSB3YXMgYXdheSBmb3IgZWFzdGVyIGhvbGlkYXlzLiANClRoYW5r
IHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgcmV2aWV3LCBTZWFuIQ0KDQpJIHNlZSB5b3VyIHBvaW50
IGFib3V0IHRoZSBpc3N1ZXMgd2l0aCBTR1gtZW5hYmxlZCBWTXMuIE15IG92ZXJhbGwNCnVuZGVy
c3RhbmRpbmcgd2FzIHRoYXQgdGhpcyB3b3VsZCBoYXZlIHRvIGJlIHVwIHRvIHRoZSB1c2Vyc3Bh
Y2UgdG8NCnByZXBhcmUgdGhlIHN5c3RlbSBmb3IgRVVQREFURVNWTiwgd2hpY2ggKm11c3QqIGlu
Y2x1ZGUgc2h1dHRpbmcgZG93bg0KYWxsIGhvc3QgZW5jbGF2ZXMsIGFuZCBhbHNvIG1pZ3JhdGlu
ZyB0aGUgU0dYIGVuYWJsZWQgVk1zIG91dCBvZiB0aGlzDQpob3N0IG9yIGRlc3Ryb3lpbmcgdGhl
bSAobGlrZWx5IHRoZSBmb3JtZXIpLiBJcyB0aGlzIGFuIHVuYWNjZXB0YWJsZSBhc3N1bXB0aW9u
Pw0KQmVjYXVzZSBJIHdvdWxkIHJhdGhlciBwcmVmZXIgdG8ga2VlcCB0aGUga2VybmVsIGNvZGUg
Y2xlYW4gYW5kIHNpbXBsZQ0KYW5kIGFzayB1c2Vyc3BhY2UgdG8gaGFuZGxlIHRoaXMgKG5vdGU6
IEVVUERBVEVTVk4gaXMgbm90IGEgY29tbW9uDQphY3Rpb24sIHdlIGV4cGVjdCBpdCB0byBiZSBu
ZWVkZWQgb25seSBhIGNvdXBsZSBvZiB0aW1lcyBwZXIgeWVhciBtYXgpLiANCg0KSWYgd2UgZm9s
bG93IHRoZSBhcHByb2FjaCBvZiB0cnlpbmcgdG8gZXhlY3V0ZSBFVVBEQVRFU1ZOIHZpYSANCnNn
eF9vcGVuKCkgYW5kIHNneF92ZXBjX29wZW4oKSBwYXRocywgaXQgYWRkcyBtb3JlIGNvbXBsZXhp
dHkgdG8ga2VybmVsDQpjb2RlIGFuZCBpbW8gaXQgc3RpbGwgZG9lc27igJl0IHJlbW92ZSB0aGUg
Y29tcGxleGl0eSBmcm9tIHVzZXJzcGFjZQ0KIG9yY2hlc3RyYXRpb24gc3cuIEkuZS4gdXNlcnNw
YWNlIHN0aWxsIGhhcyB0byBnZXQgcmlkIG9mIGhvc3QgZW5jbGF2ZXMgYW5kIA0KU0dYIGVuYWJs
ZWQgVk1zIChiZWNhdXNlIHN5bmNpbmcgd2l0aCBWTXMgb3duZXJzIHRvIG1ha2Ugc3VyZSB0aGVp
cg0KZW5jYWx2ZXMgYXJlIGRlc3Ryb3llZCBhbmQgdGhlc2UgVk1zIGFyZSByZWFkeSBmb3IgRVVE
UEFURVNWTiBzZWVtcw0KbGlrZSBhIGJpZyBvcmdhbml6YXRpb25hbCBjb21wbGV4aXR5IGFuZCBl
cnJvciBwcm9uZSkuDQpTbywgdGhlIG9ubHkgdGhpbmcgdGhpcyBhcHByb2FjaCB3b3VsZCBhZGRy
ZXNzIHdvdWxkIGJlIGFuIEVQQw0KcHJlLWFsbG9jYXRpb24gZG9uZSBieSBxZW11PyBXb3VsZG4n
dCBpdCBiZSBtb3JlIHJlYXNvbmFibGUNCihoZXJlIEkgYW0gcHVyZWx5IHNwZWN1bGF0aW5nLCBJ
IGRvbnQga25vdyBxZW11IGNvZGUpIHRvIGltcGxlbWVudA0KaW4gcWVtdSB0aGUgY29kZSB0byBk
cm9wIEVQQyBwcmUtYWxsb2NhdGlvbiBpZiBubyBWTXMgd2l0aCBTR1ggYXJlDQpydW5uaW5nPyBU
aGF0IHdvdWxkIGJlIGEgZ29vZCBvdmVyYWxsIHBvbGljeSBpbW8gbm90IHRvIHdhc3RlIEVQQw0K
c3BhY2Ugd2hlbiBub3QgbmVlZGVkIGluIHByYWN0aWNlLiANCg0KQmVzdCBSZWdhcmRzLA0KRWxl
bmEuIA0KDQoNCg0KDQoNCg0K
