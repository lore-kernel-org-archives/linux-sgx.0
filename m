Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573352586CA;
	Mon, 19 May 2025 11:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654901; cv=fail; b=Oy+hq+0NmC6DEtoJ2mZrxxKk2z8+ydvmCp0Td6PgoxugQYk7qmhjp775Ot9cy8bW1zone4sZXw/QsRF7HMd4wLCOtU8jpz96ejz1KRQ7J7SCp3bgK8q36E5+hYT3vv1akZeYqcrIpRPQ5H1CJO/kFAZvn1wqva9W1zcn1c5OAgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654901; c=relaxed/simple;
	bh=/Uok+W6u3uH2VcKZ4rq324WG5S8t5XB5pZa/Qaor4vw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IJIT1VWqSvhfxbwYOgKKkqFXVwTc3t3voUFMKtBVoo2ynkYJBHkzL7RENDZKC9QOouLmtYvD4q9yBoUlJ4uO0f74qVN3g5231gtDzuWn9TffIKjLeTwIe45662tiO/IJktJokakyVW41Rsc/mGYtx0HYeHR+sh04wBq02JEzbXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FbALYHM5; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FbALYHM5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747654899; x=1779190899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/Uok+W6u3uH2VcKZ4rq324WG5S8t5XB5pZa/Qaor4vw=;
  b=FbALYHM5EZKDJ+RrDjzVG2yMiDrlF8XjBz3W1TqLkcIlt0UYGEdb9b6L
   HOlP6B2wcLVGqiQp8TW5Ij+2s7ZpVGEyzqSC1ofuhsnnm0t4NNhSPZ5bk
   qFK+2GB1IwG9MXo3vq3npnSKlk0/mcZEnqhpPZdMRZ1nVH4xE36yvfIMg
   ZQDFuAdVD06b3pfvBCnb9/CX4kROu20oYB/z2c799yre/9BaJWLd1SDXb
   o5KUcGX5VpkHYDJp+4v7wf8D2hGtQo9mVKvEoCiGnJgaJByfaJOroRfHb
   zi8YVvtqZKrMiUBv/OUfl89FbDegssNzmSq4n/homoT61GpZI5lkrk1xx
   w==;
X-CSE-ConnectionGUID: uTHXGKbgSoykzy2PIuXlgQ==
X-CSE-MsgGUID: bpYBI2RzSkOLV2nLd4jayQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="60203632"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="60203632"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:41:38 -0700
X-CSE-ConnectionGUID: BJOHzDReSmit6mDH/reUFw==
X-CSE-MsgGUID: L3YMPE4YTjirZZHVPj7C6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139247585"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:41:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 04:41:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 04:41:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 04:41:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qbMg/gcAk1XPljAmJnr5K2fOqqz5SOaBjetAoSEzhal44UxbJYbxnMyztGKPzqKNvWH2v09cLfm4fmDxT3UPHXWPGjXiU4RZhWvMIquxzihlcKvNI/XouDmlCF5XKO2Qq1l+NtZR4mx2a3PpfnYr4nIOkAgYX+k2nP+xo48ODuQ/SOdSU9+4Tu2o0OkX2vXm6OREU87JasOyDuh8KIy6ZgfGQpOMritHhZYlBr8QONgjTXQiwRZ3v25MKhNEHh3f4GuKExzD1jEf+t6s8A7qmJ4eP8V7u5bAsgaNpfOEU7ODFLv0EsV7woxIY9CNc29d71pU2s95bQBzJhtVGbpTvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Uok+W6u3uH2VcKZ4rq324WG5S8t5XB5pZa/Qaor4vw=;
 b=IDxXEGFkCC6WZFMa/JpMcHyfUWG1rcTldbc027yMcm5IIeGWQkHBTx0Pvsnxlwn2NoJf0oo+4kOzSxA5nUzz5k+Dk+wn1eLr2bhyuJIAxrDgMg2//9nig0qiOHedIHU6qOdwf/APMcZxmIlnFqBUYe7/xtGv0cYF5xitW+BS+prF6AMviDQpAVGUkUgESeiMwTNHHvdMfJng3Go3H1PqNWdyLoaOvrNJ8vYW5H0JuyCzU4HLAGAdXNpZjaDwFwHnRqkxVTa78VGAct/FrUrRGz+yBOViWpnkYv9vQtHgb/Omwb8iEIX6EyVjoT6ls+gQRmERhtVbD+RMT6eIvolRzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DS0PR11MB7958.namprd11.prod.outlook.com (2603:10b6:8:f9::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Mon, 19 May 2025 11:41:35 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 11:41:35 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: RE: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHbyI9nyiauVlst/UyvS30ic5Ez1bPZ0msAgAABgdA=
Date: Mon, 19 May 2025 11:41:35 +0000
Message-ID: <DM8PR11MB5750CC5686E413A88CF41D7DE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
	 <20250519072603.328429-5-elena.reshetova@intel.com>
 <990841309a27d4f3e7c53b44d7cce0e555594a21.camel@intel.com>
In-Reply-To: <990841309a27d4f3e7c53b44d7cce0e555594a21.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|DS0PR11MB7958:EE_
x-ms-office365-filtering-correlation-id: f2770648-5884-4f3c-eac7-08dd96ca1bfa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|10070799003|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZCtiNTJRenJGK1cyL0xNSW1FSG9vWE1HUnhyTnV1N0ZDcEhnbGdrck0zUEdG?=
 =?utf-8?B?N21SbjE3OFdSTlhmRFNSbzFrVytpRzlZb0lEa3hrWHl6SjBtT3RNNXBNUHJw?=
 =?utf-8?B?TnFZWXJ5Ynp5ak1teE9ucEVVekx6MDBmRks4Y210UlZVMmNBT2diYXVSeTA5?=
 =?utf-8?B?UmpDaFZ4VzYzK0RBWnR1VU9HS2JvT0d1RUcreXhnc2krQ1lxYW45aUttcEhU?=
 =?utf-8?B?OGVlajVvOXNGek9RdUZiTFFLaUUyN2J5WFFpMlRwemIxQnRwbzNPVnFLYVh2?=
 =?utf-8?B?cGxkdXlWeGY3R1lhRGFQUmxlZCtDYkhkZ3JjNWpSMEFtTTVkdFNUTzF3Zm93?=
 =?utf-8?B?ZWY2WThnemppVFFCM1RJc3pmdS9ieE1UOWF4dG5LQ3JqOUxvZ1YxbDFTVG5T?=
 =?utf-8?B?eFRUS2Q1UW9IcVB1dk95WlF6azZDMTZQWUlvNHNybTBYN0IrQlZ2SUVOQXlC?=
 =?utf-8?B?RGdaak9USkNiVldhQ2N6TTN6SXo0b2drNHpjN0pZSUU3NFRzYk9FV1lNbXl4?=
 =?utf-8?B?WmRBMVdFY0daMXRiV0RReWlWSy9LeXdaRE0xUytISFNrWk9uUlVoZ1VvMFJM?=
 =?utf-8?B?UHl2QzkwRG1JT2lnTGx1NE8xMUpxMy9mUU14Ky8vSnkwKzVOOTc5RFIyK0Y5?=
 =?utf-8?B?aWVqVkIvc2EraENXNVF4d2JlSGtiWldvNmgxc1Z0ZHd2V1RYWDJhdXZ6ZHRO?=
 =?utf-8?B?TDNEUnVLT0Vlc2NlUWZQdFNSaUE1Zm1pMjdTWUd5N25md0dVdjk0ajE3U2Y2?=
 =?utf-8?B?NXdpNER2OGo0TjJOcWQ4TWdEQkNYZTBMdmU3ZmducVAycXhLNXNOQWN2VmdW?=
 =?utf-8?B?V2djQzN0TCt3R0RIdlJybzBtN2tpbjl1WHJPUDhCaTUyS2EweGZ1cG1qdElV?=
 =?utf-8?B?aDJuc01sRW1pTml2ZmdlRjdJclY4NHdFKzB1cEpaUTZjR1Fycmx5aWJ3aE9j?=
 =?utf-8?B?WTFWMkVlb0hHekxTdjYzamV0MVN0NXh3OHFZdnV4SDJxRmZzdTBVY3I0V2Yw?=
 =?utf-8?B?bTZqNTZKTC9rTkw5UEJvTWF0M3lhSXdaZlJUaS94MHVkRFdyTGl0OWtPSkpq?=
 =?utf-8?B?TTlMRzYwUFhRVkJQMk55eGU3cU5adEhzblF3RTIrb2FuelNUSUdtR2krTi9H?=
 =?utf-8?B?VXFGd09HRnpTQ2d0NHc3TC95cXBObzhlcXp3ZXFhN0gyZ2RqakpkQ2ZqV1Qz?=
 =?utf-8?B?VzlvbFpXbXNyKzYyWDhrQkp4d0pUd1lhb3BjTHRRNmxBR1NQWmYzc29CQzVK?=
 =?utf-8?B?RWZUZmt5TUd4VHBTMUQ0UGJnVWFoYStOeGlSZURVNHdVWWVVYTBJY0cwaVk1?=
 =?utf-8?B?RDZEWlBPcWxaUTh1cnFlV2Npd1JWMmllV2xFTklFSmxVKzdmYWQ3cVgrVU5P?=
 =?utf-8?B?dTlHVGRPWlhqRzFTSE5KemRLUnV4MkZGRk96REI5d24zTUpZQ0dlS054dVMr?=
 =?utf-8?B?b1dvN0tVV0xZbzVnZm93RHI2WGpKYmFETlhGMDkyTWtENW95V0ZXTjV2TThr?=
 =?utf-8?B?SnlnenVPa0wwcXJoM0RxRWwzZXFlY25lWGJNZlRUUXlGc3pvVXhsUXBmTGpP?=
 =?utf-8?B?UEk0RkQwM1pvU2xGOWQ0cGtvSkVZOE5RMTRwUjAvcWF0aHJ6bnZycDFmbnQr?=
 =?utf-8?B?VkJXbnpzZG5lVTA3a29FR2FiMVYrd1paNUgxUnlvRndxN00vSEpreWVNNkFh?=
 =?utf-8?B?RGp4UHNiYTZQbVlxci9ldUZ2SFBkRWZJTmVHeThmelNET3JMa3hoaC96R0JP?=
 =?utf-8?B?Rm1vU2wvcFkzdWZ3QjNTZmVKQThsdXh4UGR2WDgyMG1qNVAveE1LSjcrVXlB?=
 =?utf-8?B?YjM2c2Nocm9BeHg5NnVzdFJiaHV1Q0FWdkNyaTVFZ0xPeVZ0MnpDYkJ2TVpm?=
 =?utf-8?B?cHZLejZCRnVPNTlYbThDR2hsUGxrcmc5a1VyUnNvbXVITVhEaTRXRTdDYzhE?=
 =?utf-8?Q?D+MfGfPNC80=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTM3cHNaRVF6VnYrTUlhNUtockIxR1dMdXBZN00xWjJBMWxiRFdMZjF6ckJT?=
 =?utf-8?B?QVMzcGxFdC9pcWxTaXQzYmtDTDMrVk1qMHRHbTJIelZCUHlRd2cvK0c0cGti?=
 =?utf-8?B?Tmp2T1Jtcys5UzI5eGxPMDhlZTd1U3JuTk53RXZJWS9kVWhGeGV2cmN6MmZQ?=
 =?utf-8?B?L1VFKzZHK3VTTXZlV2tFTlBTaTAzOGNLUU5sSWZpZTBwOTlCSkJNWWlzNFF6?=
 =?utf-8?B?dnNnOUV0Zy9USHZWM1B3VE5SYWVRRU1kWkhZdW5pSlh6ZURNOXI3YXRqUHJS?=
 =?utf-8?B?WXB6RmxRN3FRakl2R09QeXN3d01xRkhsNm5IZkh2OVM0SGtnaDYyM3paN0FC?=
 =?utf-8?B?azRYb3gzcHRVNE5kSXVpenhWbXJOMm9FdEg5STdTMFpZMHVPbmloaEV2N21H?=
 =?utf-8?B?dHBIRWg1R2hNc0JUQTN5YTBnNGpLa3E1WlFUNjY2dEZTNzlXYk12Qnh6M3Jp?=
 =?utf-8?B?R1pzczBIazJiVWNoSEQzaktNYThZWDBQcFFzUExSd3Z3USt1QWJuemRPMGll?=
 =?utf-8?B?eDVjSVY1ci96Z2xJZUpQWENIZXdZTjFrV0ZUcmo5dTg4MWFwTkZKaGJYMVJP?=
 =?utf-8?B?Ky9jeVQ2Zmx5MmxjZUdUalBGMk1wRlBoSWl1NjlXLzNDbW0vb0Y2TmFORXEr?=
 =?utf-8?B?ZTVGT0FzNDBvemRPT2tiRUhYcnFacDdrYWZ2VlJXNzFHRnZYN3lROVVGT1FI?=
 =?utf-8?B?TnVDTGdoV2dUN0h4U09tRWpXQzdKTWI2MkxoTSs5R0tPZ2pHUzFDdVdTM3NO?=
 =?utf-8?B?ckNxOW9YOHk0L3BScUpiUlpyais2RUN0YUc4YXZTUXp0YVhvWE9NZWRlK2kw?=
 =?utf-8?B?Uko4MzN6dGtnL0hQejY3M3FRMjhxMmNSa1FVUG5UTUY1emtET2lZVzR2U0V1?=
 =?utf-8?B?NmdQUTkxcmJlQlBXTVRtVWpXZDdURkZhTll1b3g4c1lGak1UZVNUWVF2aTBV?=
 =?utf-8?B?dUsvVFIxQXcvK3pJK09hUjFjbm9rOUZiOUVOdHVtSUpmSklMSWhKS2hzTk1K?=
 =?utf-8?B?WGdkSUR6TUU3RmxNeHV4ZmtVUkZSVUFTdjFyZTNLUDdUZmdLeHRCcC9reWZJ?=
 =?utf-8?B?Q0RET3dkRXVtN2I4bC9xQzFmbm9sTm82M2RrT0lDcFgwOHEwcEtxVHV2VnFl?=
 =?utf-8?B?WmZYVHl3Q3Y4QmJyRUdWQjBSYzBIVlFCTFdWemFXNWFtellJV001V281MzFG?=
 =?utf-8?B?cy9rSDlMNWpqV2pQMnV0SzlVU3lIWnl2czJiYTFreVVCZE5zdnAyM1UzSEtF?=
 =?utf-8?B?OVFSMDNFUXRDTjhxNzMrdXR5K2M1V3FRVFRGVlJXNTBTbzNFOGRZR1N6WmtL?=
 =?utf-8?B?YlBXS1Z4VWFBYWlmS1ozYjNWRXQ2dndBdTJQUFFrY2k5S3k3YUxTVUJ6K1NK?=
 =?utf-8?B?UHZxVWV0QVRMMVEyME0xT3pVQ3RIbnM5Vk9nUU5GVWVYKzFFT2Fvd1oxSllD?=
 =?utf-8?B?cjI4QkFLQnhFWDIxK3ErNWI4U2tOTjgzMG0rbWpWa1ZLZlU1Zmpna2lsbnlT?=
 =?utf-8?B?S3g2NFJWUGZNcU16YzNSczlLdml4d3ZXcXZ5R2VaL3hQQWwxaXd3Nyt6UnU3?=
 =?utf-8?B?Zk5MV1dXNjE2ckxYbDFzYTF2NzBrVjZHZVRNSkpIVkhDN091bWZuU29zK3RM?=
 =?utf-8?B?MTRCT2NMZW02Rm1lTjhpNTJKWkR5UnNsMDFXOFY3K3BFNVNHZ1VOdHdsY0w1?=
 =?utf-8?B?R0JPTURtT1Z4SjExdHRZOU5vQWMrRE1Ba0tyV0FyYlM5LzB0aUhuL1UzeUp5?=
 =?utf-8?B?UG9MbzZWTTZwM0l4VXZvV3lTTFNPT0dvRFVhcHArOWY2QXhiQmJMemRNVndP?=
 =?utf-8?B?cVZyMklBbHBIN3NTdTUxeEV1SmNTdmwzRkFoZ0J3anMzdnc2aTNrVk0za2xW?=
 =?utf-8?B?TVBYQW9teUkwNWkybzh0NitHOVlOcWxxbUl1bmU4L0FmVk9TS1YvNTB1dFdI?=
 =?utf-8?B?dWF4akFuRlA0T2s4NHllSU0yQlRNQjk1MjFqQWFNa2NXaXNDUXVSNG9iYVk5?=
 =?utf-8?B?UUZPUjg2UjdWK2c3d0ZsMGtja2VOWDZ4d0hwWEwvcWxzM2hMT0dCbzJLSm9L?=
 =?utf-8?B?U01wN2RaRXF2RVFERHRhMFNtS2FhNEo4cStDUzZvRWI3UFZEVTN0N3dVb1Rt?=
 =?utf-8?B?ZW5oQmp0T1Z1cXpseUJaY0k5MnF0cHpEbElvV3kzV3NIOFZicTBVcldQSkdW?=
 =?utf-8?Q?iEjmzIe3cOEjcgyaRG3fEDKnob4+jXg45vfq681CXSAm?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f2770648-5884-4f3c-eac7-08dd96ca1bfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 11:41:35.2898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nc6aTHw9HvykmnSfjWTiTbex0LQIi+XTRGXFnpeHj6Qr2j6auOHdehIYA+W5BLQae9bCfjXcJb2RCQrh25ULEbpwe3K1zp11A7BWDho3UFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7958
X-OriginatorOrg: intel.com

PiBPbiBNb24sIDIwMjUtMDUtMTkgYXQgMTA6MjQgKzAzMDAsIEVsZW5hIFJlc2hldG92YSB3cm90
ZToNCj4gPiBUaGUgU0dYIGF0dGVzdGF0aW9uIGFyY2hpdGVjdHVyZSBhc3N1bWVzIGEgY29tcHJv
bWlzZQ0KPiA+IG9mIGFsbCBydW5uaW5nIGVuY2xhdmVzIGFuZCBjcnlwdG9ncmFwaGljIGFzc2V0
cw0KPiA+IChsaWtlIGludGVybmFsIFNHWCBlbmNyeXB0aW9uIGtleXMpIHdoZW5ldmVyIGEgbWlj
cm9jb2RlDQo+ID4gdXBkYXRlIGFmZmVjdHMgU0dYLiBUbyBtaXRpZ2F0ZSB0aGUgaW1wYWN0IG9m
IHRoaXMgcHJlc3VtZWQNCj4gPiBjb21wcm9taXNlLCBhIG5ldyBzdXBlcnZpc29yIFNHWCBpbnN0
cnVjdGlvbjogRU5DTFNbRVVQREFURVNWTl0sDQo+ID4gaXMgaW50cm9kdWNlZCB0byB1cGRhdGUg
U0dYIG1pY3JvY29kZSB2ZXJzaW9uIGFuZCBnZW5lcmF0ZQ0KPiA+IG5ldyBjcnlwdG9ncmFwaGlj
IGFzc2V0cyBpbiBydW50aW1lIGFmdGVyIFNHWCBtaWNyb2NvZGUgdXBkYXRlLg0KPiA+DQo+ID4g
RVVQREFURVNWTiByZXF1aXJlcyB0aGF0IFNHWCBtZW1vcnkgdG8gYmUgbWFya2VkIGFzICJ1bnVz
ZWQiDQo+ID4gYmVmb3JlIGl0IHdpbGwgc3VjY2VlZC4gVGhpcyBlbnN1cmVzIHRoYXQgbm8gY29t
cHJvbWlzZWQgZW5jbGF2ZQ0KPiA+IGNhbiBzdXJ2aXZlIHRoZSBwcm9jZXNzIGFuZCBwcm92aWRl
cyBhbiBvcHBvcnR1bml0eSB0byBnZW5lcmF0ZQ0KPiA+IG5ldyBjcnlwdG9ncmFwaGljIGFzc2V0
cy4NCj4gPg0KPiA+IEFkZCB0aGUgbWV0aG9kIHRvIHBlcmZvcm0gRU5DTFNbRVVQREFURVNWTl0u
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBFbGVuYSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92
YUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2VuY2xz
LmggfCAgNSArKysNCj4gPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jICB8IDU3DQo+
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQs
IDYyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwv
Y3B1L3NneC9lbmNscy5oDQo+IGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbHMuaA0KPiA+
IGluZGV4IDk5MDA0YjAyZTJlZC4uZDkxNjBjODlhOTNkIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9jcHUvc2d4L2VuY2xzLmgNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC9lbmNscy5oDQo+ID4gQEAgLTIzMyw0ICsyMzMsOSBAQCBzdGF0aWMgaW5saW5lIGludCBf
X2VhdWcoc3RydWN0IHNneF9wYWdlaW5mbyAqcGdpbmZvLA0KPiB2b2lkICphZGRyKQ0KPiA+ICAJ
cmV0dXJuIF9fZW5jbHNfMihFQVVHLCBwZ2luZm8sIGFkZHIpOw0KPiA+ICB9DQo+ID4NCj4gPiAr
LyogQXR0ZW1wdCB0byB1cGRhdGUgQ1BVU1ZOIGF0IHJ1bnRpbWUuICovDQo+ID4gK3N0YXRpYyBp
bmxpbmUgaW50IF9fZXVwZGF0ZXN2bih2b2lkKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gX19lbmNs
c19yZXRfMShFVVBEQVRFU1ZOLCAiIik7DQo+ID4gK30NCj4gPiAgI2VuZGlmIC8qIF9YODZfRU5D
TFNfSCAqLw0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMN
Cj4gYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gPiBpbmRleCA4MGQ1NjVlNmYy
YWQuLmZkNzFlMmRkY2E1OSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3Nn
eC9tYWluLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gPiBA
QCAtMTUsNiArMTUsNyBAQA0KPiA+ICAjaW5jbHVkZSA8bGludXgvc3lzZnMuaD4NCj4gPiAgI2lu
Y2x1ZGUgPGxpbnV4L3ZtYWxsb2MuaD4NCj4gPiAgI2luY2x1ZGUgPGFzbS9zZ3guaD4NCj4gPiAr
I2luY2x1ZGUgPGFzbS9hcmNocmFuZG9tLmg+DQo+ID4gICNpbmNsdWRlICJkcml2ZXIuaCINCj4g
PiAgI2luY2x1ZGUgImVuY2wuaCINCj4gPiAgI2luY2x1ZGUgImVuY2xzLmgiDQo+ID4gQEAgLTkx
Nyw2ICs5MTgsNjIgQEAgRVhQT1JUX1NZTUJPTF9HUEwoc2d4X3NldF9hdHRyaWJ1dGUpOw0KPiA+
ICAvKiBDb3VudGVyIHRvIGNvdW50IHRoZSBhY3RpdmUgU0dYIHVzZXJzICovDQo+ID4gIHN0YXRp
YyBhdG9taWM2NF90IHNneF91c2FnZV9jb3VudDsNCj4gPg0KPiA+ICsvKioNCj4gPiArICogc2d4
X3VwZGF0ZXN2bigpIC0gQXR0ZW1wdCB0byBjYWxsIEVOQ0xTW0VVUERBVEVTVk5dDQo+ID4gKyAq
IElmIEVQQyBpcyBlbXB0eSwgdGhpcyBpbnN0cnVjdGlvbiBhdHRlbXB0cyB0byB1cGRhdGUgQ1BV
U1ZOIHRvIHRoZQ0KPiA+ICsgKiBjdXJyZW50bHkgbG9hZGVkIG1pY3JvY29kZSB1cGRhdGUgU1ZO
IGFuZCBnZW5lcmF0ZSBuZXcNCj4gPiArICogY3J5cHRvZ3JhcGhpYyBhc3NldHMuc2d4X3VwZGF0
ZXN2bigpIE1vc3Qgb2YgdGhlIHRpbWUsIHRoZXJlIHdpbGwNCj4gPiArICogYmUgbm8gdXBkYXRl
IGFuZCB0aGF0J3MgT0suDQo+ID4gKyAqDQo+ID4gKyAqIFJldHVybjoNCj4gPiArICogMDogU3Vj
Y2Vzcywgbm90IHN1cHBvcnRlZCBvciBydW4gb3V0IG9mIGVudHJvcHkNCj4gPiArICovDQo+ID4g
K3N0YXRpYyBpbnQgc2d4X3VwZGF0ZV9zdm4odm9pZCkNCj4gPiArew0KPiA+ICsJaW50IHJldDsN
Cj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogSWYgRVVQREFURVNWTiBpcyBub3QgYXZhaWxhYmxl
LCBpdCBpcyBvayB0bw0KPiA+ICsJICogc2lsZW50bHkgc2tpcCBpdCB0byBjb21wbHkgd2l0aCBs
ZWdhY3kgYmVoYXZpb3IuDQo+ID4gKwkgKi8NCj4gPiArCWlmICghWDg2X0ZFQVRVUkVfU0dYX0VV
UERBVEVTVk4pDQo+ID4gKwkJcmV0dXJuIDA7DQo+IA0KPiBTaG91bGQgYmU6DQo+IA0KPiAJaWYg
KCFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1NHWF9FVVBEQVRFU1ZOKSkNCj4gCQly
ZXR1cm4gMDsNCg0KWWVzLCByaWdodC4gV2lsbCBmaXguIA0KDQo+IA0KPiA+ICsNCj4gPiArCWZv
ciAoaW50IGkgPSAwOyBpIDwgUkRSQU5EX1JFVFJZX0xPT1BTOyBpKyspIHsNCj4gPiArCQlyZXQg
PSBfX2V1cGRhdGVzdm4oKTsNCj4gPiArDQo+ID4gKwkJLyogU3RvcCBvbiBzdWNjZXNzIG9yIHVu
ZXhwZWN0ZWQgZXJyb3JzOiAqLw0KPiA+ICsJCWlmIChyZXQgIT0gU0dYX0lOU1VGRklDSUVOVF9F
TlRST1BZKQ0KPiA+ICsJCQlicmVhazsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJ
ICogU1ZOIGVpdGhlciB3YXMgdXAtdG8tZGF0ZSBvciBTVk4gdXBkYXRlIGZhaWxlZCBkdWUNCj4g
PiArCSAqIHRvIGxhY2sgb2YgZW50cm9weS4gSW4gYm90aCBjYXNlcywgd2Ugd2FudCB0byByZXR1
cm4NCj4gPiArCSAqIDAgaW4gb3JkZXIgbm90IHRvIGJyZWFrIHNneF8odmVwY18pb3Blbi4gV2Ug
ZG9udCBleHBlY3QNCj4gPiArCSAqIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSBlcnJvciB1bmxl
c3MgdW5kZXJseWluZyBSRFNFRUQNCj4gPiArCSAqIGlzIHVuZGVyIGhlYXZ5IHByZXNzdXJlLg0K
PiA+ICsJICovDQo+ID4gKwlpZiAoKHJldCA9PSBTR1hfTk9fVVBEQVRFKSB8fCAocmV0ID09IFNH
WF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSkpDQo+ID4gKwkJcmV0dXJuIDA7DQo+IA0KPiBJIGFtIGEg
bGl0dGxlIGJpdCBjb25mdXNlZCB3aHkgd2Ugc2hvdWxkIHJldHVybiAwIHdoZW4gcnVubmluZyBv
dXQgb2YNCj4gZW50cm9weS4NCj4gDQo+IEl0IHNlZW1zIGluIHY0IHlvdSBzYWlkIGl0J3Mgbm90
IHRoYXQgaGFyZCB0byBjYXVzZSBFVVBEQVRFU1ZOIHRvIGZhaWwgcmVsaWFibHk6DQo+IA0KPiAg
ICAgQW5kIHRvIG1ha2UgaXQgbW9yZSBjb25jcmV0ZSwgSSBtYWRlIHNvbWUgc2ltcGxlIHRlc3Rz
IGJhc2VkDQo+ICAgICBvbiBwcm9ncmFtIGZvciBzdHJlc3MgdGVzdGluZyByZHJhbmQvcmRzZWVk
IHRoYXQgd2FzIGRpc2N1c3NlZCBpbiB0aGF0DQo+ICAgICB0aHJlYXQgZWFybGllcjogaHR0cHM6
Ly9sa21sLm9yZy9sa21sLzIwMjQvMi82Lzc0Ng0KPiAgICAgVXNpbmcgdGhpcyBzdHJlc3MgdGVz
dGluZyBhbmQgZW5vdWdoIHRocmVhZHMsIEkgY2FuIG1ha2UgRVVQREFURVNWTiBmYWlsDQo+ICAg
ICByZWxpYWJseSBhbmQgcXVpdGUgZWFzaWx5IGV2ZW4gd2l0aCAxMCB0aW1lIHJldHJ5IGxvb3Ag
Ynkga2VybmVsLg0KPiANCj4gUmV0dXJuaW5nIDAgd2lsbCBtYWtlIHNneF9vcGVuKCkgc3VjY2Vl
ZCBpZiBJIHJlYWQgeW91ciBuZXh0IHBhdGNoIGNvcnJlY3RseSwNCj4gd2hpY2ggbWVhbnMgdGhp
cyB3aWxsIGFsbG93IGVuY2xhdmUgdG8gYmUgY3JlYXRlZCB3aGVuIHVwZGF0aW5nIFNWTiBmYWls
cy4NCg0KWWVzLCBjb3JyZWN0LiANCg0KPiANCj4gV2h5IG5vdCBqdXN0IGZhaWwgc2d4X29wZW4o
KSAoZS5nLiwgcmV0dXJuIC1FQlVTWSwgb3IgLUVBR0FJTikgaW4gdGhhdCBjYXNlPw0KPiBVc2Vy
c3BhY2UgY2FuIHRoZW4gcmV0cnk/DQoNClRoZSBpZGVhIG9uIHRoZSBwYXRjaCB3YXMgdGhhdCBz
dWNoIGEgc2NlbmFyaW8gd2hlcmUgd2UgcnVuIG91dCBvZiBlbnRyb3B5DQpzaG91bGQgbm90IGhh
cHBlbiBpbiByZWFsIGxpZmUgdW5sZXNzIFJEU0VFRCBpcyB1bmRlciBzdHJlc3MgKGluIGNhc2Ug
d2UgDQphY2NpZGVudGFsbHkgY29sbGlkZWQsIHdlIGRvIGEgMTAgdGltZSByZXRyeSkuIFNvLCBp
biB0aGlzIGNhc2Ugd2Uga2VlcCB0aGUgbGVnYWN5DQpiZWhhdmlvdXIsIGkuZS4gcHJvY2VlZGlu
ZyB3aXRob3V0IEVVUERBVEVTVk4uIEJ1dCBJIGNhbiBjaGFuZ2UgdG8gdGhlIGFib3ZlDQpsb2dp
YyB0byByZXR1cm4gLUVBR0FJTiBpbiB0aGlzIGNhc2UgaWYgZXZlcnlvbmUgdGhpbmtzIGl0IGlz
IGEgYmV0dGVyIGFwcHJvYWNoLiANCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuDQoNCj4gDQo+ID4g
Kw0KPiA+ICsJaWYgKCFyZXQpIHsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIFNWTiBzdWNjZXNzZnVs
bHkgdXBkYXRlZC4NCj4gPiArCQkgKiBMZXQgdXNlcnMga25vdyB3aGVuIHRoZSB1cGRhdGUgd2Fz
IHN1Y2Nlc3NmdWwuDQo+ID4gKwkJICovDQo+ID4gKwkJcHJfaW5mbygiU1ZOIHVwZGF0ZWQgc3Vj
Y2Vzc2Z1bGx5XG4iKTsNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwkv
Kg0KPiA+ICsJICogRVVQREFURVNWTiB3YXMgY2FsbGVkIHdoZW4gRVBDIGlzIGVtcHR5LCBhbGwg
b3RoZXIgZXJyb3INCj4gPiArCSAqIGNvZGVzIGFyZSB1bmV4cGVjdGVkLg0KPiA+ICsJICovDQo+
ID4gKwlFTkNMU19XQVJOKHJldCwgIkVVUERBVEVTVk4iKTsNCj4gPiArCXJldHVybiByZXQ7DQo+
ID4gK30NCj4gPiArDQo+ID4gIGludCBzZ3hfaW5jX3VzYWdlX2NvdW50KHZvaWQpDQo+ID4gIHsN
Cj4gPiAgCWF0b21pYzY0X2luYygmc2d4X3VzYWdlX2NvdW50KTsNCg==
