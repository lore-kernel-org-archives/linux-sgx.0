Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E9A264FB5;
	Tue,  4 Nov 2025 21:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762290108; cv=fail; b=rW58f1CYGz9coY+4hl0/j4c7iZ58vO1ixWiF5jqg1PxgVLTdui4QXv+n3gg0q78dkj5IRwu8QD4kktbPOWAQQYG9NbABGfWqiGslPZpasWct/49exedvqzjk9rOdqRZpl5kvaY8dgxTOhbVTsBxzmEhW+Fwvw7F8iAS51FeJusY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762290108; c=relaxed/simple;
	bh=shKam2JSv2BR4zdC+LPWNZwqgTVKt2+rFKtpszvMVqs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SLd5t5JAAV/qAol3quQccE44hneVBemH83zvoi8o6IED5ZzTzn90TZprgJkccXED4Wt53Dz/PDWOSBt+gzpHDKAvcGrrlumnav/pRoIOiPu58+eLIqFkkhqObKE5OdD9gamnNgDypupPPfLn7SI6pnjFl4QnDpnnWHUqIWmoQ+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YZduMJHO; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YZduMJHO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762290107; x=1793826107;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=shKam2JSv2BR4zdC+LPWNZwqgTVKt2+rFKtpszvMVqs=;
  b=YZduMJHO8wskJSf+S2yC2+wpePAwG9w3nbqo35vb4OO+GIlnUrooLdL/
   OltTQaOGE9DQgJEVti8/gebaTC5dYF+Bns3d6TgujoT4L/iifzmJNtZtX
   8/ptmznRPm9HyIb2CKFH0X8ER7NEhAU9F8nD4H9PrJuhnJgZrE0WpDhKx
   HjZhdUGuaEktu9aWrgEiqUauW3fV6NqxDzd8IRi1kmxXvIrC9EGvpknHb
   npdOhoOsKM1IPGZeGvlciCiyaiI9EdOX31WvUFOkRXFQkszB35lPWm3jk
   pgefCOPkQQqkJB0N83uUiaJJN/aEuDXb0Zx0N91lTK34ms9Q0aKnmUxSN
   w==;
X-CSE-ConnectionGUID: c9vU9gtXSayR1l05Y7pw3g==
X-CSE-MsgGUID: 6kF2qb8XQVibqXYRBP2maw==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="64435355"
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="64435355"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 13:01:47 -0800
X-CSE-ConnectionGUID: D2Cc0lUgSxazvSgmvZ82aQ==
X-CSE-MsgGUID: JQE5pCIhTB6XuIqItR0CRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="187562384"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 13:01:46 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 13:01:45 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 13:01:45 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.33) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 13:01:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KqOoP/YRhrAUz540J/tX0jcFRI90rR+hq2FUZTA8+QLfjpP9mKNBEraHOS3Tb3sPp4OW0fUAKHY1bTOeVOq+lkHwqKZ7C7WlPG/XUyRllRlxRRKRtamPEXLnquR0nVH4h18WHuTkNY4RxyFUQqIrkNoHh0BM1sPAj1K9BKtJqV2Oj+DTBASnVjpHqkTwyxgDgp74aTI+/AfTukKIqz6QSrGoyXfdebT7C5BhhFusLSi4g2f+wKOJqRYhxryYw3/i5sawE/aKkm5XmpJiyFk/hT8rMQAWR0WbUPesuszwCHKz4/n96IfhMgpjgH0QQ07owQBh73relRfc7Rbx5jyJ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shKam2JSv2BR4zdC+LPWNZwqgTVKt2+rFKtpszvMVqs=;
 b=U3HeMFehThgNcTQ8gQb9s46yM0gzRVu2SuIx2l15sEl/Z+3rU9MoMJaDoywvm9zjrOA85yaTWl3O8aCGoiwj650uzIQx7T0Y5E+1/G+hkHJiswwrMX00MkZE/dIAYayxbGSmH5IVCsZ1+HjLLE8Kq2CugMI1s/uAa0OZNfuT/fmJwaC5CV7C/FcPS97ii5uFXWV+up2mU7qpdIWQdcSQdPgHqHQTmM/5rVcI6YoCQ+2lZVRoMX8EhDyjO7iD8hsyTUDPUebss7gG/es+xyFZYrxr3vA9bFNrTcYRd7R/qb5phMkBc0rMI8bAaElUynpY2F1AMRzyUu4Exfj6LyF2tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB6614.namprd11.prod.outlook.com (2603:10b6:806:255::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Tue, 4 Nov
 2025 21:01:34 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 21:01:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thorsten.blum@linux.dev" <thorsten.blum@linux.dev>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "x86@kernel.org"
	<x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Fix typos and formatting in function comments
Thread-Topic: [PATCH] x86/sgx: Fix typos and formatting in function comments
Thread-Index: AQHcTKCcJImmZQBK5Eiwig+HlI861LThnxMAgAFF8YCAAB4egA==
Date: Tue, 4 Nov 2025 21:01:34 +0000
Message-ID: <d390d171e858722850aecae0af68c30b9eb0e134.camel@intel.com>
References: <20251103090103.1415-2-thorsten.blum@linux.dev>
	 <717cb54f7ac6dd1f94a5c57c10a8cb377eb199bd.camel@intel.com>
	 <71675CA4-D76B-4B81-B71B-8C2B79AAAC3C@linux.dev>
In-Reply-To: <71675CA4-D76B-4B81-B71B-8C2B79AAAC3C@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB6614:EE_
x-ms-office365-filtering-correlation-id: 2b471812-5364-4a07-22dc-08de1be5562f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cnBjTXl2WFhYOHU4cFdYZm8yR0oyd0V3K1BTL0VFQit1WlVSMmNHS2hmUlI2?=
 =?utf-8?B?ZEhobUJXWnZuNmpyMnRqOUEvRnpqLzhCUDR0UldBZnRVc3ovckx5bWVMQzNT?=
 =?utf-8?B?Si92K0xQMDRFUmNQck0rTjA5NHdaQTlVR09pRkFFZ201V3lNRWtkcFNQdHJ1?=
 =?utf-8?B?WUYrakVoMkhVQzRYTC9uRXdYVVlEOXNoSTM1QlNSV09YUlZUa0pTZFhqblIw?=
 =?utf-8?B?TXRaTFRVTmZDZmpDOHhQNUlWUmVia2JUWVphU0hCblNNUVhLelU3RVVCY0Fy?=
 =?utf-8?B?dDdMdWtLVkJEOFpPdCthVUJJbkp3ejhqTG1leDJuU1k3Y3g1N2hSbnNwTGJW?=
 =?utf-8?B?eXBlVVREeVplVzRFSGdybFlVS1FlWGNjK1B5Q1lINVVoTFBMb3ZlRENtbFhq?=
 =?utf-8?B?Y0FXK1FxZ0xXV3h6eXhQbENsam5nWHc0bDN1bjBNUVB2N05kRm9iNVUyc1Nk?=
 =?utf-8?B?MWZoZnVUYXhwNnJKMFFDNVNoQTJXRE9RV0JpNDhkeU9YTEtCOG9aOU1NL3pr?=
 =?utf-8?B?RW5UN0FJaDc1MnNScWpLUDFrcTFna29OWDQwU2x2YkhteUxjT1lOdVlFYkVm?=
 =?utf-8?B?eEJCVmxIaWc5Yzk4dUJvSm1CVWg3SmI4dUF5RkhTN0llbmtvbkR1UmFsOE9O?=
 =?utf-8?B?Q1dndEdIc241S1h4WWdOUklEdWJ5MVNhMlNHMW5QdFh1L25mWTIzVFYrM3Zl?=
 =?utf-8?B?aC9ZZmQxWFVzcGpPV05Zc1AydzFkRDlUbm9tM2RKaGtsaXU0TjhPWTlialJR?=
 =?utf-8?B?ZTcyMVJ4Nnh1MEM0ZDlUSmJtVWoyTlF0Y3BDU2ZVeUNpbjlXOVRoUDhJYjg1?=
 =?utf-8?B?L3J3aTlxa1V1aDdRMDlQa1U4UEhEeTEyRHVvV0MrSDBJb1E4ZFhyNUdIQlFF?=
 =?utf-8?B?VkZFVEM4aGoyd09WRXZnWDBCd3lHdVFla3FFb1djZmViZ0YzbFJyM203Yyt2?=
 =?utf-8?B?bUNubEZEU0htTlB3dm1ZYzRTc2pvdkYycnBCdUJkSWdzZS9TaXBDSmhLY1ZH?=
 =?utf-8?B?bys3UFNnU3FDeStUZWtMSFZxSEJUc0ZzckZwOHEzdXVYdHRVa2RlVVVSeFRi?=
 =?utf-8?B?clFDNVNYdDBlWkpJbDF4SmREaEVySndiZ3V5TkZMbU1NQVRqajR5RXZqOFJr?=
 =?utf-8?B?d2ZiQVk2WnFUZmpGNzNocmMxQkZUNG9JK2tGSjlYeEZjOXFybm9oNDI1ZmZ6?=
 =?utf-8?B?NERTMnFBcVRCdmJLb0FrN1JQUTlwRmlub0FubVRUZUJNQk9RZ1JWTHRFeGJ5?=
 =?utf-8?B?Z0JqVzFhRWtUR3dMYlpVaWpremxyMDgrbkhLRE5WaHZBT1EzckZQWDZFZndP?=
 =?utf-8?B?VmkzdEdadDNnblpSSGh0Q2JDc0ZkejJEMVk1ZGUzSnd6RUFvekRuRnNwTVEv?=
 =?utf-8?B?YWNCM3E3OERDSnd4enQ5RzZyU2FPbDNZV2U3SXU5Q0Y2MVpZUFN6eXJsdWRk?=
 =?utf-8?B?Z0htNGhveFVQRjJyV08xQktlLzFrZHFwUUg4UytVelRFUzl5eUdDSmF6NENu?=
 =?utf-8?B?ZVQ5b0ZSZkFlcmFCVmxPL21EZDFIejFvSUIydXd3WVJzTHZ0RmlFMU95TXpB?=
 =?utf-8?B?RkhNMFhZVWRyd1Nwa0JOL0NPY2tUMHZDUWtETXFGRkE4R3FKZ09WdjlzMXBJ?=
 =?utf-8?B?RHRSbVU3UWx3UkRWUlhKMGxYSHVmcUFYR25XYWFZYjFlSU1Yem1kWGhjR0Vw?=
 =?utf-8?B?R0J1MEd2SG44L2lDSG81Z1hCeWo3a0xsQUpoUEhCdEJ4S0x5Mjd3cnZPTGFi?=
 =?utf-8?B?ZG02ZGJndWtleXR2MWJkMXViVmlkcm1OU29jUXVQQTg0T1lTZTZnZW9ETlM1?=
 =?utf-8?B?NiszMHBaTWtMd2JxdjRLeDV4R25wMjRPYVBndXdkMW1yQ3QyUklVOTgrOFEx?=
 =?utf-8?B?d0d3bFcvS1dqcnVMVjg2ZDBFRXV5MEdOdjZQNGl5OTZqdnlFWkpKNnQrS2dY?=
 =?utf-8?B?dElQOUNnbUUrWWNncEJJM21UdHFxL3B0dE1HNXErREc2L3VYaFR5MXYwRFlE?=
 =?utf-8?B?em9mbDBmdWtUai8zaUxQRkU1aVFOOVk5RlFCY2JzZnVRRXRySTBrai9wdWZQ?=
 =?utf-8?Q?HwFWpH?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M09IdmJNTmZ1N0RDU1hKTm5YUCthZGpsL3lvb25qdTQ1aW9GOTFCZ1NjMndQ?=
 =?utf-8?B?V3J0OWg5ci80N3R2NlFkS3dxY29RRDJPc1V0MXF4LzhYakhvQVdtWDIyVXp4?=
 =?utf-8?B?b0ZSZE5YdUF1bGphRWpFV1BQQUdQQ3ZjRXRUNUw2dVpqQ2gvcXFpU0l2dXNP?=
 =?utf-8?B?TTZqczIzay9qOU1vVEQrazdod2NLOWFEdW5QSHhleXVEWnNOa0ZOd21DTEFk?=
 =?utf-8?B?WGl4R3I2Q3owWDBrN0Q5ZXhKMFNGbmhLa1B4QzdadzJtbG9sV2dWZ2RRalk4?=
 =?utf-8?B?NTlQT1FIU29RODIxV251TFp4OHR1WFJmcFdWMnY2S0YyY1BuTkpGNlRmWkt1?=
 =?utf-8?B?RUswME1iK050ZkhTdzQ5enNaRHIvQVRXcXJ4VUhKOGRGSTJBRlJVUnhSbExT?=
 =?utf-8?B?UXYzSjEwdUpDSUdTUkhmbWozeWl3TC84TXVFUDg3SlpsaTdWWHZnc080ZXJT?=
 =?utf-8?B?Q3FrMFRJNCs2OE8reEZPaDJGblAvS2RFaVBMR0FITlkyM0NpYnMrT3daUlZL?=
 =?utf-8?B?SlNPZFZ0bkQ2a0I5eC9GNDU5bXI1KzFoWnBMZGxrSWxaQzJETlZISjNuWjE0?=
 =?utf-8?B?NlUvSVJ5WFFnN2R6bkNrdk5LWVc3UHdmZ2xmU0EyNmJzeHVxTXJuKzlkTWY0?=
 =?utf-8?B?cC84MGNzUUNVMnFRK0poajNvV1lkTlF6QXR1OW8yVFRDU1lKODBkQ2x1ZFJU?=
 =?utf-8?B?MVRPS0MvanpjN3FUakdRWmc1RFY4TW9yUURBSFp6MFY1ZWxEc1loNy8wMzVV?=
 =?utf-8?B?WXdtTWRCQTVlNVdEdGtHU1JEQ05mU1BJR0hpY0hiUkQ2RExraEdZVFlqdG4v?=
 =?utf-8?B?ZC9QdGJONDNjWTc5VFN2VS8rc2J1ZkRjVWc0V2pqWUx0VjNSTU9EWFFMUyt4?=
 =?utf-8?B?Wjl4SUJUMDlOaSt3VXVYVTZWU0VVNGw2TU5PRkRyZEdESEVaYXdXVkpCbXZU?=
 =?utf-8?B?eE5HZ2xDSCs2b1czeGtoenFFZElaZkJNTVNhNFU1OTRvVGR4cFNhMEZiVkF2?=
 =?utf-8?B?WkxDYkJYV0haeUZxYVNYRmU5dVE5T00yUmFrZDVwRUcvL3ZycXdqWnRORGVQ?=
 =?utf-8?B?V0NaYUtFQnJhSGNnUkNmeG1nZmFIcXo2NXdEc1p0M1Q5dFJuUDNDNXhsZjZl?=
 =?utf-8?B?Y1IzQmU5Y1BRZzczMVpBYTBmUEI3S2FzUXBzM2Y0T0p4TzhXTEpWVklrZC9s?=
 =?utf-8?B?TEVvd2lsVTV0QUFTcmVpTmFSZWtmOGxKWk4ySi9JQnpCaTZnazBDSVJLVnFy?=
 =?utf-8?B?TkhDWVp6dWRFOTE2VFIvc1dIWWlpSEJXMTQyZXRNdm5SY2EzSWVCYXB5WnZa?=
 =?utf-8?B?OGxNR1dpcll6OHVmQXVmR2Z2NU9NWC96YksrV3FDUnBTTHRMdi9LK3JXeHRu?=
 =?utf-8?B?NlZZOHBtV2gwMms0MlplMXhQYUtXVlB6RDloZ2Y5K2VCV2l3WGhRM3RvdENW?=
 =?utf-8?B?NkswZVdDNTFsTXc4OW8yK2hWN0VFSkhmOWdjK1NzUXcyM2RhWk5kbnRJUytW?=
 =?utf-8?B?T3hFdW9naEI2UnBOZVV4YkhpVWVQOVZjRkNNT084WlFqaklhNnR5T1lvQ2t3?=
 =?utf-8?B?OGh5YlpZMVJGVE13b3U4dlRSejlKbVBjS2IveUdFU1kxYUt5NlQ3aE52TU9w?=
 =?utf-8?B?TTJMc3o2WnI4VVZOVUU4YTEwV2R6RUpkdzlxTWFabW8xR1ZVc1JwL0dWNzcw?=
 =?utf-8?B?YzBaWlFCaThEWVNFbVNkeDFOYVJTYjZmRzdETGY0UUk3NXBFRko3M1Bnbnlu?=
 =?utf-8?B?QmhFYWc0L2NHbi9yMjI4SXNIbzlJWDRTNnpwODh3UVFjRys0MGJmT01FMWpX?=
 =?utf-8?B?Q1VJelIvYVpuNVJ0VnZMM1UrTE5uakRyKzN2YU53dzY4aFp3bEJ1Ujh6YmZN?=
 =?utf-8?B?RjJjUFhUUUMwNUFlSll4TkxkS25HZzlEdFdFTUQvNmZmdUdvMkJTOVVLekR3?=
 =?utf-8?B?TVR2ZlJHQm50REJzVFI4aVUxUEJuUUs5c0wwTkRNMEMzU2RGWVBzeWs3TXpM?=
 =?utf-8?B?YzI4UXVpV0dTVCtTeWdnV3dYSG0rODVVOFFKckc2QnpnbjRaaFBudjM1M1lG?=
 =?utf-8?B?R1dFbmNySlNtZ0s1UFRVQi9qWG0yNmZvb3ZYK3lHZlhleU1PckVGdkpNZmNW?=
 =?utf-8?Q?qDDRPBEgP7wA2ulTU3XmT+uKF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6268A03CDC90DF4EB3A91C3884703A79@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b471812-5364-4a07-22dc-08de1be5562f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 21:01:34.0422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8/B0nO0Zmo5zMBs09HZhC4rOzd7bj6dsYslVstwMqE5H/vXCR+09icn8SmaDSF52A+SylWClSI6dub69HOOTyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6614
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTExLTA0IGF0IDIwOjEzICswMTAwLCBUaG9yc3RlbiBCbHVtIHdyb3RlOg0K
PiBPbiA0LiBOb3YgMjAyNSwgYXQgMDA6NDcsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gSXQgc2Vl
bXMgd2UgZG9uJ3QgaGF2ZSBhIGNvbnNpc3RlbnQgd2F5IG9mIGRlc2NyaWJpbmcgcmV0dXJuIHZh
bHVlcyBpbiB0aGUNCj4gPiBrLWRvYyBjb21tZW50cyBpbiBzZ3gvbWFpbi5jLiAgRS5nLiwNCj4g
PiANCj4gPiAvKioNCj4gPiAqIHNneF91bm1hcmtfcGFnZV9yZWNsYWltYWJsZSgpIC0gUmVtb3Zl
IGEgcGFnZSBmcm9tIHRoZSByZWNsYWltIGxpc3QNCj4gPiANCj4gPiAuLi4NCj4gPiANCj4gPiAq
IFJldHVybjoNCj4gPiAqICAgMCBvbiBzdWNjZXNzLA0KPiA+ICogICAtRUJVU1kgaWYgdGhlIHBh
Z2UgaXMgaW4gdGhlIHByb2Nlc3Mgb2YgYmVpbmcgcmVjbGFpbWVkDQo+ID4gKi8NCj4gPiANCj4g
PiANCj4gPiAvKioNCj4gPiAqIHNneF9hbGxvY19lcGNfcGFnZSgpIC0gQWxsb2NhdGUgYW4gRVBD
IHBhZ2UNCj4gPiANCj4gPiAuLi4NCj4gPiANCj4gPiAqIFJldHVybjoNCj4gPiAqICAgYW4gRVBD
IHBhZ2UsDQo+ID4gKiAgIC1lcnJubyBvbiBlcnJvcg0KPiA+ICovDQo+ID4gDQo+ID4gUGVyaGFw
cyB3ZSBzaG91bGQgbWFrZSB0aGVtIGNvbnNpc3RlbnQgaW4gZm9ybWF0Lg0KPiA+IA0KPiA+IEJ1
dCBJIHRoaW5rIHRoaXMgY2FuIGJlIGRvbmUgc2VwYXJhdGVseSBmcm9tIGZpeGluZyB0aGUgdHlw
b3MuICBNYXliZSB5b3UgDQo+ID4gY2FuIHNwbGl0IG91dCB0aGUgdHlwbyBmaXhpbmcgYXMgYSBz
ZXBhcmF0ZSBwYXRjaCwgYW5kIGhhdmUgYW5vdGhlciBwYXRjaCB0bw0KPiA+IGZpeGluZyB0aGUg
cmV0dXJuIHZhbHVlIGRlc2NyaXB0aW9uPw0KPiANCj4gSSB1c2VkIHRoZSBzdHlsZSBtb3N0bHkg
Zm91bmQgaW4gbWFpbi5jIGFuZCBpb2N0bC5jIC0gd291bGQgdGhhdCBiZSB0aGUNCj4gImNvcnJl
Y3QiIGZvcm1hdCBmb3IgdGhlIG90aGVycyBhcyB3ZWxsPyBIYXBweSB0byBzdWJtaXQgYSBzZXBh
cmF0ZQ0KPiBwYXRjaCBpZiBpdCdzIHdvcnRoIGl0Lg0KDQpJIGZvdW5kIGEgbGluayBkb2N1bWVu
dGluZyB0aGF0IChwbGVhc2Ugc2VhcmNoICJSZXR1cm4gdmFsdWVzIik6DQoNCmh0dHBzOi8vZG9j
cy5rZXJuZWwub3JnL2RvYy1ndWlkZS9rZXJuZWwtZG9jLmh0bWwNCg0KSW4gc2hvcnQsIHRoZSBk
b2Mgc3VnZ2VzdGVkIHRvIHVzZSBhICJSZVNUIGxpc3QiLCBlLmcuLDoNCg0KCSogUmV0dXJuOg0K
CSogKiAlMCAgICAgICAgICAgIC0gT0sgdG8gcnVudGltZSBzdXNwZW5kIHRoZSBkZXZpY2UNCgkq
ICogJS1FQlVTWSAgICAgICAtIERldmljZSBzaG91bGQgbm90IGJlIHJ1bnRpbWUgc3VzcGVuZGVk
DQoNCkJ1dCBJIGFtIG5vdCBhIGZhbiBvZiBjbGVhbmluZyB1cCBhbGwgdGhlIGV4aXN0aW5nIFNH
WCBjb21tZW50cyB0byBpdCwgc2luY2UNCnRoaXMgd2lsbCBqdXN0IGJlIGEgYnVyZGVuIHRvIG1h
aW50YWluZXJzIEkgc3VwcG9zZS4gIEFuZCBJIGJldCB0aGVyZSBhcmUNCm90aGVyIHBsYWNlcyBp
biB0aGUga2VybmVsIG5vdCBmb2xsb3dpbmcgdGhpcyAiUmVTVCBsaXN0IiwgaS5lLiwgSSB2aWV3
IHRoaXMNCmFzIGEgc3VnZ2VzdGlvbiBidXQgbm90IGEgcmVxdWlyZW1lbnQuDQoNCkFub3RoZXIg
b3B0aW9uIGlzIHlvdSBjYW4ganVzdCBjaGFuZ2UgdG8gZm9sbG93IHRoZSBxdW90ZWQgdHdvIGV4
YW1wbGVzDQphYm92ZSAoZS5nLiwgc2d4X3VubWFya19wYWdlX3JlY2xhaW1hYmxlKCkpIHNvIHRo
YXQgYXQgbGVhc3QgaW4gc2d4L21haW4uYw0KdGhleSBhcmUgY29uc2lzdGVudC4NCg0KT3IganVz
dCBsZWF2ZSB0aGUgY29tbWVudCBhcyBpcy4NCg0KVGhhdCdzIG15IDJjZW50cywgYW5kIGluIGFu
eSB3YXksIEkgd2lsbCBiZSBoYXBweSB0byByZXZpZXcuDQo=
