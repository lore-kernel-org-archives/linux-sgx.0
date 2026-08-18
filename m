Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF4637F728;
	Tue, 18 Aug 2026 11:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787052488; cv=fail; b=oLYB4ie+nkHL0HYC+Rcd3Vb2VRnB9tPX3QIg9TJ83CMUudkBWCzNU1kKz7r54aWtGIMYN/XGhhT53fJe9VOYTMTQsxM9GaFWRKvdw4uiue6SoRFUDnjcot44/x84Od1oi+rSvr9prG3A1OaBXcez0+t5/IxUi8ZPFfLHd3GZ684=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787052488; c=relaxed/simple;
	bh=AlRXAMDRS4niP58iYjb32LaBl5fgMX4ERXX0FCt4ZPE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HeZxzriqQTJMzn5ku/tg7vhRGsG4TGBaSnk5H23r7fau0CBCX/xBhOlIJAAiFl7ipSAif1m7iBWkgFMAwHQ6AEws0JIx04OipMGTrp1i/oQUeb1pkaEpatSfqlaeeC1ImQpbRaKMAF2tF5tuuSTTRTHIK/R5tPz6HvEJWL41gj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JJiVNei/; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JJiVNei/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787052487; x=1818588487;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AlRXAMDRS4niP58iYjb32LaBl5fgMX4ERXX0FCt4ZPE=;
  b=JJiVNei/im9wZhuvF5/czFjN0jQQ3Bym2HVLGvxLDL9vCsBuMhBanvNf
   s6+0nQroCnPhsUEQXdM+El9Y/78AfwL2usDwdVEPPCu2TFum335qM004v
   VSF3i5FMMvj74jnPtpZFncF92BKWOfNo3DnyKEMi/oq+K3ktRgyievCEg
   tN/YFb8vUkYAxbNJYOWt+eCnsIwYHXrrCiWsTNahHn3tSwwWEHsNcCCkb
   RbHrHjqJpL3HnZ1vrpPnCaXiJzCqPH3zCyjNXiaKrGQ8Nn6IpPDqSJ+Du
   avp+ZLPLZ+Dc0kPhKvGkZ9IWMLlau7VGvwAk1tWgr7Tui6bDFiFC+zC4w
   w==;
X-CSE-ConnectionGUID: AWptDxKfSx6iLpMcrP2brg==
X-CSE-MsgGUID: MG/J3mdlSreAoOMMlpUi7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="105075146"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="105075146"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 04:28:06 -0700
X-CSE-ConnectionGUID: gAgLmuDWS1KKUBI3BLVvxg==
X-CSE-MsgGUID: MLVyUAHgTByNpM1Qn3YtJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="263470553"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 04:28:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 04:28:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 18 Aug 2026 04:28:06 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.26) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 04:28:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VS91KUENvQulTfhkRo9uFekt51aMrl2z/xIxbXBoa2uOtF1AZLjWtld47Fb+VPvFAG6uihafcE9/59BVWYR+tDOuRW3lStbeoIczVqdbFECoJ4UbL4bLKG9P69yXERXvJDhVxy9Nw6bgb0sW55kLQp6KJS04gYR5vaFwM3zBJ/LtWTZv6UTnw8xnSLxdkNKs7tMZkngaRaGLH4LPDrvZ75Qo/8eAVl3NA1GVqxK3TBnnrIbCjDNbm7HO5W/2/MxI66fNilbumzkiyyavLVmhUb5gOyuFhVanATvhqEGcW8AVwdf8igRWGLvBfVlARvsiGiImfBKdkpEVEtDzDpVfOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlRXAMDRS4niP58iYjb32LaBl5fgMX4ERXX0FCt4ZPE=;
 b=qoHb6lpbujZeSYfuBFdvCOUBciMmHjdupwxOpxr1SY25Gv4IHTnf8c9JZNezuRAvMKNLIIh8UcpmSTJ8s6AJZuRFxw9Gwc1QLlLuzCgPn4fb36Rx+y1xNsZpgxWNPIk9mZfERva0HbnYFyEPp2jgthA4gkcdRN8VvlL2bfIrcXwipQyD+IW08a3ew4fXLkOCUrxBE/24E8D2Upj1I375tYyIsAK8jjz+6br85j9BwpVKPmlpeSVtz8P8f5+ENguZh2sTomXYYdOUUGyqxLEWQHjA9qFBEBqW0Te0+sGzSq90qL0Oiy8vIF8sRpDjynb1uGsIon2SKL6m394U8ybwlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5302.namprd11.prod.outlook.com (2603:10b6:208:312::7)
 by LV3PR11MB8604.namprd11.prod.outlook.com (2603:10b6:408:1ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 18 Aug
 2026 11:27:58 +0000
Received: from BL1PR11MB5302.namprd11.prod.outlook.com
 ([fe80::f19c:833c:9f41:f3de]) by BL1PR11MB5302.namprd11.prod.outlook.com
 ([fe80::f19c:833c:9f41:f3de%5]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 11:27:58 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "ruoyuw560@gmail.com"
	<ruoyuw560@gmail.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "bp@alien8.de"
	<bp@alien8.de>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/sgx: Drop enclave reference on MMU notifier
 registration failure
Thread-Topic: [PATCH] x86/sgx: Drop enclave reference on MMU notifier
 registration failure
Thread-Index: AQHdK/LKLgCrkTlIVEmppMepKhlmSbajsVSA
Date: Tue, 18 Aug 2026 11:27:57 +0000
Message-ID: <327d1c155170de5bd6b1865850a00b26d7e1b3be.camel@intel.com>
References: <20260814134020.1386599-1-ruoyuw560@gmail.com>
In-Reply-To: <20260814134020.1386599-1-ruoyuw560@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5302:EE_|LV3PR11MB8604:EE_
x-ms-office365-filtering-correlation-id: 875da7bd-dcd4-4caf-d1d1-08defd1bc133
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|11063799006|10067099003|56012099006|38070700021|22082099003|18002099003;
x-microsoft-antispam-message-info: iMIuoFBmJVRHcObAhBg6RxB0pVYAa3fka+GQ8uhrQL00ZflUxBT/ZTS504BbRLIyMbipbeDwBWdXZ7jQOJCI6WScaAkEjRfdgMfH2cyB5sFZ3oMupk6UGkEMUQW4Z26POgufTSSqdtdK9t4WUyCCYiObAbrLR6s1H2AJLww/XKAC5AONUN/pEhB0UO6gYPWXETXvOTN7dVmN4/j0nyuUkZVkuYHiSuhsRWl2brK5tbMbfotaO/TtT/DAfuRFsV3Lb6CAt2Y4K3Xro3+CHmQMOodfb9Fjyqn0QYI0z59TBTQT/f57W7jczHSTadLz+F1UboAyOInoveCNubmTwuWuNCjratfskD7YvhkuzMV4DRvfEp0/y49EhsCDEPPs+3nM0B33jJPsFFsF8anE3Hq5iDx64EY5ZigARmj/coLx5VLJAAV6WYOFxrs6wb7AItj5nvDbZhVhIeOSzUejXT6eSVt5oh99S5AQ7+NtqG4OCVLflfQRvDqTVmCYLBybcdns9i/hx/hKQmUP9RqvTsmcv1odOaGdeZwc41SOi5z7OCidQhU9Mh0GdaRTi6u7VmJETG/L5UIPt7OJFAzVhfkRGYE7peKydYvzht6qp03cEnE9Bmbl+svgESt6Uvtdw1NeiJkLbVnIcfNArSC4G01NzoAVDyCI3r+SW7Imx+FI0zDWdZ+/Ftt7ctRYoCapqkZsm7R97C6QqBRoBYrAwqwpBEdx3WeZ8YbhC1XGllXxrlA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5302.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(11063799006)(10067099003)(56012099006)(38070700021)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3QzR2dOWkRISDY5RkxmZmJxYUFIZTFRODZTWnpieERpK0x3TWFTT29VVnJO?=
 =?utf-8?B?c25NRWhiTVB4VVJFWHRLT1FlcHNrWEhGTlZ5VmN5WlVQKzJOYkxNNE1oa1JM?=
 =?utf-8?B?ZCt2aWxiTXd2MU9YOFBWT0pYNHhMV2VNQjlZOHdudnhrTUx2UWNkeC9jeDBD?=
 =?utf-8?B?Q2w5eWI4ZE9RTHgxRTdFTXZiOXF5dWJsbUkySFA2YnArZ0VDQk9VYnBmenN6?=
 =?utf-8?B?SmhXVk5JQlI1YTN3V2QwOUZSUE9kVFB3R1A1ZWlUK2pIU0lSbjFvRWVHWVVM?=
 =?utf-8?B?eGJFd1MwZDMzMVNaWGVodWxIL3dhNjJFQ2lObExuYXdtcXBiOXZRNGFEWjdT?=
 =?utf-8?B?RDV3cUdXUzVBVWwxQUFGckhReGc0eUNtcDBUY0tRdW9FWXZXczNZNWhZWVhH?=
 =?utf-8?B?UjVTSWt2L0tFSDFBNi9OeU4wMFBOaFRkZUplaGlkK3BMNElKWlhxOGdXLzNK?=
 =?utf-8?B?RW5xaWszM2tONlQ0RFV1UEV4Q0g5MjhnSmNkM1NUV3c3c2x0UUg5Ty9kMWRE?=
 =?utf-8?B?dXFNT1FjQm1sTzFrazRaWHhUYmQrbzIwQVBTUzNBckdzL1BZQWd4Ri9BMXZE?=
 =?utf-8?B?RWVtdkUvN0NBWFFzK05tY2xkdXZlRGtjY0txcjJJYkVwbDB0MVpmYlpzTExw?=
 =?utf-8?B?N0h6U3ZtVTI0K052Z3QwMW1RRS9iNWNndmRiMFVIdWhGVmZOek9pUlMwV0lW?=
 =?utf-8?B?NnN3dzdJdy9PbjBPaUNjRHU2cENlbHlTcGc2YnJURW0wK1ZQS3lqZ0RhSHFq?=
 =?utf-8?B?b0ozcHBNZlJCejVQUmZvQzltQ0x3TE9SOHZJNE52T1B3VlBOQmQxYUdkMkNj?=
 =?utf-8?B?MGFvR0xrNEZTRDlXTXRLSWlpZnh1WHBUVVZCYzlpNzRzQWU3VjdkcGN2N2kr?=
 =?utf-8?B?aEFCaU1Wb3FUODJ4MFZmc2RrcDN5OEJ4aWtwTVJ2aEtxTzNRbkhiYkNjTk8z?=
 =?utf-8?B?ak42MUlxUjNVdXNrR3Q5OTdtS0h5T2xVTThudllqU2hFVytrRnNuRXlXVC80?=
 =?utf-8?B?Qjl0eW9KQnBhRHZweDRhbzRYVHRNNFZQNjZJZmVmc25vN1hpMHAybzhUUWw3?=
 =?utf-8?B?TzE4LzAyR085bzR4Q3RzTzlMejNuTDhkY1Z5eERHOXBlU0VtOXZpc2tYUkhx?=
 =?utf-8?B?QXN5UlJzcUFMcHdSU1pheUNvT0tuOExwdHM5ek14c0pMa1c4b2dRN1d1Vm5O?=
 =?utf-8?B?YlhKcHhqWHpLMEdlWTM2YnRjcnVzZ0tXTnR6Q0ZFVVdTcE9CV1R5LzhCVTBn?=
 =?utf-8?B?RUY0U3VFd0lKWkVVL1dvekZJWi9leWpGVkY4SEYwWXdnMDgrdkhURDcwZnlF?=
 =?utf-8?B?QkJCeGVjRFlWVWhvM1NJZml1RHdVUmNtZEVrQzBuNE5MOFEra1NrRmVSR2tv?=
 =?utf-8?B?T1pXWlR5THN2bnZsY1pVcHBuampXRWd6cXl5RUVzMUpMdnRkakh0VGV5bjZG?=
 =?utf-8?B?anJqSW1rUFFnOXJPR3JzZEdXZ1hqWHF2aWZpcTgrMnF6Zis5YXFrN1crd3RF?=
 =?utf-8?B?Qk1udzMyS2s0bGh2VmpIbEo0bmdGTi9nK1FDdUlUaSt4emZiQk1WQW5hVUkw?=
 =?utf-8?B?eU5HMzdUb0twTUxCckpWVXVkUzVpVkU4bFJMRjc0dWlTTzZIS3lCS2pzL0x3?=
 =?utf-8?B?enNqK1g0T2RaY0trOXFBMjVvUXpXR0loSjlEVHBhRmpNRk50T0NQZVpXUzZo?=
 =?utf-8?B?amlzOVFHR25Na0ZNVUpsMEh4WDJkUWFKNjF3bWxQVzErS3AyUlA2K2RXd0NG?=
 =?utf-8?B?RThNYnU2eW84REljN0xDbEJSN2lrSmNnWTJtQWw1dUVjOEhDZFJFanBtUzk2?=
 =?utf-8?B?ZTEvL1FVYUtzT1RFYzYwZGl6ZTQyaEs3ZjkrNkFOM2ZmYUFMbmxGNTA5NVgz?=
 =?utf-8?B?UEJLbytXMFRPbmNlS0tzNEtKNXRacUhUZWp0ZkNRdk5DUXl1VVlmN3pJeXhk?=
 =?utf-8?B?QVFHWGpHT3pZSk82WVJZUHZ1dm13aElHRVZKNEdDeG90REFPSUNoU0dzeGpD?=
 =?utf-8?B?RU5Zc2RZbllqaWtrZkhwdU9xSHdIRWNsZnRhdjlsZVhndk44MWNmMFk2SlR5?=
 =?utf-8?B?ajl4Q0RHR0VNYlZDN01ZOXFIRWJyNmtWYllPblgva3hEYkFnYXhmV3kzRGlz?=
 =?utf-8?B?OHZ3NDZ5R2NJSlpNZXMwZ3JkOVRCdURhbEd4enc1WnZYY2NMd2VnMUdHMUU0?=
 =?utf-8?B?UXJvcmNrbnh6SzJqN25TQVRtL3ZkNXByalM4QmhjQTZleXFOQjFHQjA4Ullx?=
 =?utf-8?B?Nmt3ajFDYldZNmdIQ3lPbENWcTlLaXlYQzQxZFlBS3Z6RU5ldWZQY01pTlN2?=
 =?utf-8?B?bExESFlFcFV1Nm1JZmNIQ0NEWXJNbmw3Z20rTjlzbzZJcHo5YmNiUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2A0F0270D60114B8F93D187C03365B5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: be3Fu5p+0C3zwTcVBNclLFMHCGl/fIUd7gruk7PbKv7PGE1kucD4YZvPQiEmrvbq2Fe8jbtlu0uaThERRpWZlCaBfF0cSJqifgpWoqmaM/ajx1Q19i+QmcDKCbEpUK3yBgzNIQZLL76KqFtzIu5NKZg77Iq8CU4IdFbtmRS++HTeeOv482IuGNGQhjpLMhKMEZBecPPw8hDH505cJCJw0IMA0kySj4RYkBo/wn6/vVq4KBlpJ8xm/CcOzEqbaecXJbAgpUAM7da0n7adc2oKv3vC2/F/9fHkcca2nIR/oUsZk1GC1pZSqIgmyvpnVxIu9f/LSlr+/bqmwACN//dc6A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5302.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 875da7bd-dcd4-4caf-d1d1-08defd1bc133
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2026 11:27:58.0498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TtrDpVIPVd9PM/ne+4zeKn3e71iai/IusaY0Onh+OTYXRiU7wrpRN8w81D+hOXIqmdmwatgK60Wv/BjHUg/xtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8604
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTA4LTE0IGF0IDIxOjQwICswODAwLCBSdW95dSBXYW5nIHdyb3RlOg0KPiBF
YWNoIHNneF9lbmNsX21tIGluc3RhbmNlIGhvbGRzIGFuIGVuY2xhdmUgcmVmZXJlbmNlIHNvIHRo
ZSBlbmNsYXZlDQo+IG91dGxpdmVzIGl0cyBNTVUgbm90aWZpZXIuIHNneF9lbmNsX21tX2FkZCgp
IGFjcXVpcmVzIHRoYXQgcmVmZXJlbmNlDQo+IGJlZm9yZSBjYWxsaW5nIF9fbW11X25vdGlmaWVy
X3JlZ2lzdGVyKCkuDQo+IA0KPiBOb3RpZmllciByZWdpc3RyYXRpb24gY2FuIGZhaWwgd2hpbGUg
YWxsb2NhdGluZyBzdWJzY3JpcHRpb24gc3RhdGUgb3INCj4gd2hlbiBtbV90YWtlX2FsbF9sb2Nr
cygpIGlzIGludGVycnVwdGVkLiBJbiB0aGF0IGNhc2Ugbm8gbm90aWZpZXIgb3INCj4gbW1fbGlz
dCBlbnRyeSB0YWtlcyBvd25lcnNoaXAgb2YgZW5jbF9tbS4gVGhlIGVycm9yIHBhdGggZnJlZXMg
ZW5jbF9tbQ0KPiBidXQgbGVhdmVzIHRoZSBlbmNsYXZlIHJlZmVyZW5jZSBiZWhpbmQsIHByZXZl
bnRpbmcgdGhlIGVuY2xhdmUgYW5kIGl0cw0KPiByZXNvdXJjZXMgZnJvbSBiZWluZyByZWxlYXNl
ZC4NCj4gDQo+IERyb3AgdGhlIGVuY2xhdmUgcmVmZXJlbmNlIGJlZm9yZSBmcmVlaW5nIHRoZSB1
bnB1Ymxpc2hlZCBlbmNsX21tLiBUaGlzDQo+IGJhbGFuY2VzIHRoZSBhY3F1aXNpdGlvbiB3aXRo
b3V0IGNoYW5naW5nIHRoZSBzdWNjZXNzZnVsIHJlZ2lzdHJhdGlvbg0KPiBhbmQgdGVhcmRvd24g
cGF0aHMuDQo+IA0KPiBUaGlzIGlzc3VlIHdhcyBmb3VuZCBieSBhIHN0YXRpYyBhbmFseXNpcyBj
aGVja2VyIGFuZCBjb25maXJtZWQgYnkNCj4gbWFudWFsIHNvdXJjZSByZXZpZXcuDQo+IA0KPiBG
aXhlczogMmFkZTBkNjA5MzliICgieDg2L3NneDogTWFpbnRhaW4gZW5jbC0+cmVmY291bnQgZm9y
IGVhY2ggZW5jbC0+bW1fbGlzdCBlbnRyeSIpDQo+IFNpZ25lZC1vZmYtYnk6IFJ1b3l1IFdhbmcg
PHJ1b3l1dzU2MEBnbWFpbC5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFu
Z0BpbnRlbC5jb20+DQo=
