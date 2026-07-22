Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB17384CCD;
	Wed, 22 Jul 2026 02:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784686690; cv=fail; b=feyEmZDAqH76H5fDjcG6PXdOTdLryHZNrKwcUARYPEs+JX+5yphVcw+0UQBD1AWL4JQSKzaXj7VN0dPMwpIgN4nlOHiy6zvhf0YdVLqWbZIdkw57Lydu5dDxm0loeKBlpwfpDkXjQAKMif/o0UTIVTiS2f+Pli8pHXCgK/ybhRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784686690; c=relaxed/simple;
	bh=kf52U5ubeJNcrg6OSsQv8MkBHjYDAjQh6C13GnoZFR0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a3GbCSg57kJ1KtMJNQQfX4ja/HbxpLcVucFhLeO5CHe4kz+89FI03aSdvxZr8mfwBNCE8yhm3D+WkgP9baFGGzmLxRVzonkWJ8PaDrhKGKZ3TIxFnGOamD3TnSzkFjavglvGufBQFcTlPciatOI/4rEZXuvyZs1+kpsg2DcET+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VfK8ERLI; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VfK8ERLI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784686688; x=1816222688;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=kf52U5ubeJNcrg6OSsQv8MkBHjYDAjQh6C13GnoZFR0=;
  b=VfK8ERLI3Fi0jFz/Pm8XcVExd2+oSfyya1sgcy+ulajYioFm13rsRpra
   xvMj3Qa3SKTS2R+YgcAQTNVhnGj97XHHxU7d3+ci8H7IZb+2ODSvVsfpl
   UBdGus5ilOtdxUCOZqaUzt6KBR3fCPjBA2CEHtW3SD5WZB7TJSf89fvRc
   Meh98Lt3Ii8YI2gedM/bJU2hcq/pHprRq7pRuTpfqhKX+Kn5AI+koYSSR
   xCGdNgdZA8WzD8rp+u5jot9HJ/dKc4jlXbKAG0QQo6pJBqCyUHzejlzMW
   CgL6hz7pe9QvvwapG9hv8X77tcZImUDq4xeuEMcOdC3hVbE7IQGC7OyiV
   g==;
X-CSE-ConnectionGUID: QpKoAnG9SU2sOyp9qA3RFw==
X-CSE-MsgGUID: s2BSKW4nQuaxoDubF1bM5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="96825241"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="96825241"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 19:18:07 -0700
X-CSE-ConnectionGUID: ABtOho6mQ3C0OE98OQ9qkw==
X-CSE-MsgGUID: Bi0BxOjWR4G7ZjSWzEUUNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="261507944"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 19:18:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 19:18:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 21 Jul 2026 19:18:06 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.68) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 21 Jul 2026 19:18:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CWJ2RUdehaf3t/8X5Q4GmJCf3l1jnzVQke/Ldnnb0p/6TXGnBfnenM3gGcvpv7QijUMVyW/Der8Zl8fWOyNdj0QqPmgGpC7dJNlbVIDmNOnH26/7k60voBLroB0OlKK5deCqjACXFRT6GC4pCRwjjUJe7yB57g8tMt7LJ0F9yl4MqiAhX2RbtPpvugWBrlZYhLyuS3P/AA89CEt5d/dQ23wX3c7XCr2UXPKUF3PF5ZXwl9kZHe2uatyX84+TydAy/aeNF6CqnGFcsNqX6oawfR6yKc74gUCAlcML5s2ljng7ye9V8HeU1ceNdEDWA0PDK4vVqOUq4+EpZEmCN7fM7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kf52U5ubeJNcrg6OSsQv8MkBHjYDAjQh6C13GnoZFR0=;
 b=dxgdu7U5n7vJ0fN3mySAOpspmYv/vVKbpVEa+WA6/ItbSPM4zifIua8l9lBBKkx54gpbOAhC/eLRZwjW2lDpy2t6N0x50F95JW0L2pPEHcjKfFpUWud7r1fgpvSGqB8EmcS/96i/RBOwX20JJV4ZYCN5Bp8M2Wv4JFudlhUkoGw0FKRX2uCcrh+n4hmYkTInIihEfCHnNks9Hsp5t6JmQuQkgHD3rwempfvF28NW12SKzSNJnGUBxDghTnJefhvz+zkQVfu2TLJ6fiWAOm5dot5QOdQBezxiYngQ9LwQ3Wik0ALwkGwMdHDF1vxIeSEYSBu9KHUJQ6sxsXLb2hZYcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5702.namprd11.prod.outlook.com (2603:10b6:8:21::10) by
 CY5PR11MB6209.namprd11.prod.outlook.com (2603:10b6:930:27::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Wed, 22 Jul 2026 02:17:55 +0000
Received: from DM8PR11MB5702.namprd11.prod.outlook.com
 ([fe80::a973:3a5a:91e8:49b9]) by DM8PR11MB5702.namprd11.prod.outlook.com
 ([fe80::a973:3a5a:91e8:49b9%7]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 02:17:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "yanlonglong@kylinos.cn"
	<yanlonglong@kylinos.cn>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selftests/sgx: use MAP_FAILED for mmap error check
Thread-Topic: [PATCH] selftests/sgx: use MAP_FAILED for mmap error check
Thread-Index: AQHdF/NrZ2NB8xzEu0q42R6yvwQfpLZ40LOA
Date: Wed, 22 Jul 2026 02:17:55 +0000
Message-ID: <4b9e4d1195c03e7db7660c2c7a94969ed50ef674.camel@intel.com>
References: <20260720025443.506-1-yanlonglong@kylinos.cn>
In-Reply-To: <20260720025443.506-1-yanlonglong@kylinos.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5702:EE_|CY5PR11MB6209:EE_
x-ms-office365-filtering-correlation-id: e0fc2145-d3da-4cbd-f7ff-08dee797711d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|11063799006|10067099003|56012099006|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: 6jj4qzkh+jk2rwPJF50RPFNvZ1RCGiXLl2fshz/kse0XhRhzEZR3B+QrkTu2oiHEKEKYHnBBkAfaiIfWxUQgcPZXCQ/KH1vlA+NtbRakJYDNYQDCpEHcbQ23pAXmx0juqLWRJDaP7z33VKOnt9mkF04GWgvVKbsEYtZrfDWqi3sVg9pPmgm2AEVpdSVrLekKC38Lkeoj3HZDZaCQAT0AKXuBgz2Bl14IiIBP7AcYmp8o0gFHMOHuiFsyJON5PT/dHNArug+7geFwSSv8/UO1igLwep8EU9APxMpOyL/XKYIVwl8W/++hV2XIeQWh69Gc5VHOv+PC0++vV3fpEPJxpZhRv2dkRgMYAiOdikKWuDxTF32iP/fTLug8CbjIjXeDDjWspqP0BjGDKw9BOVXE1lgeQyXZv24sjdQ2qqDIFKt9KJXyXerFbTDWrDITc/gqiy240NyIaaVwJlqJ0MMXFwF6eY05e5cnQuBXoHsRqh7/sqNF/IBdNPo5IYSW3NXbOvJ3WaQqAGeRlAZas5BLKs63+en6l0abmLHysy/9zL19COczdXIVGz0UwgJP8N43S6wu3whH32/ZniVthsRun1Ch2mo5yowBGQ6QuUQ82tyJuMFNLzttGyjyjP63XObarO//fclSH/5TzBMI/Thlt8uPjnQn4hncW6/MhGjwkLMGpeyGCOGJXRXFn1OrQVHSStYUyLu9PgbocS6pnPazuQH232dJuFFNzcSz2fubxC8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5702.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QklsRU1PMkhWdnhzZjVaMUFzZWFLV1ZGdTRnRzlYeGNJVzlVME15OTBLTUJJ?=
 =?utf-8?B?V0VDci9kQ0tPallkdTQ1dnNkQUlPb3pDbE5oS2N0R2xZTkc2aXRVOGN2OVhC?=
 =?utf-8?B?Wks5ajBXaGNRSm5FbUM3bm90SjB5QWJjdythQi9IN0tBVTlicGVNQ3cyUmhP?=
 =?utf-8?B?eklCU2NMRmZremp0SVkzMEVGN1Rlc0ZqMkNSZjI0RWpHTUVFeGZnSW5NRVRq?=
 =?utf-8?B?R3dMSmJxbWUxSjNQcG9IMHBiRG9mWlBuaWVycVpVblB1dkNpbVpKRTN0OENN?=
 =?utf-8?B?dXNad0JUcDBZS25JV0laSjlxL1RrRGtOa3BoOHZudkN4U2t4bEpMWFVqMHJD?=
 =?utf-8?B?a0lBNTliTU91RG5uSlJQVjkxcTl3QVhUdjNtSGVUWTdKT0VWcy9UcEM5c3Bp?=
 =?utf-8?B?ZkZ3ajRLY2hxc2djdWZFMzFvYlJMV0VmcDdaTElEcDNHUjZjNFZYZzlyVVhv?=
 =?utf-8?B?ZExWckxqSk1JL2pKd0RsdjB0TnVmQlJ1NmNOVk5DMDFoUnlqdUV4UkdnL1F3?=
 =?utf-8?B?Unc3VDJpS1MrVTY1bDlHNlA5Vm9jeE82Rk1Cd0h6ek5Hb0hHblZNbUVsSi8w?=
 =?utf-8?B?ZXdFeDZaM1JzWFo4T0hDclRxTFJ1ZThJN051WVdHNjJ4TXdDbWRyL3JuanpW?=
 =?utf-8?B?cGdNZmYyOWk1dTJVQVlTUUZjenEzbW05cTh3dis4TUxyZllzUzNETXRZUXlE?=
 =?utf-8?B?b0g3Rno0SElOckFGVzdFZEFVY1RGZzV0TmMxbEVxN3VDRGdQUWVSWFREb1ha?=
 =?utf-8?B?M3FvdkhuM3pPazZVcGVNVmNOdCs3ZzEvU1dMVk14bDc3Tk1rdTBMN0VabzNB?=
 =?utf-8?B?YlBwQzYvZWR0bUZyM3hqVTJlMnA5Z3JKeUgxeFBlZlpaSldFS2I1R3VqZUVG?=
 =?utf-8?B?dUFoVlNwdTZqcWZYMjdVMkN6REppa1JFMkc1N3JWUGwrdUZHcGl2UElDOVVi?=
 =?utf-8?B?K3lQOUhhZmRGRkEwN3d0S1dpZmhhdlhMVnppOUtUVDNoWUpnM0xNNWkzQU9w?=
 =?utf-8?B?RXo3TnJXTkRjMFN6di9VS1lpRGw4QXVYY29mOTlVUTZHbjRiUHpPMlFBUE9B?=
 =?utf-8?B?UHBCKzFzbzhydmJEazg0Vldjbzk1bWExY2YrTDBsaEMvdzAxWnJBN1R4bTFm?=
 =?utf-8?B?b2FhY3o4RkFpZE5qbmlzUjAwVldNZXJkdWxGVnJvaFF3SFo1YnAxeTFKWGpW?=
 =?utf-8?B?aXRneUpxYVJyU3ZIN2NpTlEzR3ZaMHMvUlQvOVptSDdidXNkYlVZU2xyLzBv?=
 =?utf-8?B?RVp5TENlczJIZjlsNS9aNGFLRFA3ektFWHBkWTh6WnhOc3YrcXp6MlAxWTNv?=
 =?utf-8?B?eUh0aVJGTE5vUzhvd3kxN0I2L042aC92NzBGSzBqUW1taDFQazNZc2EzOFNa?=
 =?utf-8?B?cHJuT2pkSmpDRWY3ZGxTNjZVREw5ZlJnWXk5cXdJaERUS1pIYnZNbEtiNWVM?=
 =?utf-8?B?Skg5dGNOV0RtSmd1U1hsWjlTM3F1OFc0TWZCVG5vdVpHbDRiQUtHRFpoTi85?=
 =?utf-8?B?Wlpxdm5XRnBxeXZlS1ZPNk9rTEJtcjd2VHRIeWJpaVJsUHFxYUNONVVYaHNk?=
 =?utf-8?B?a212ZVNHSUNISjJMclZHOTF1dG8zNHQwNUVQWklhY0JMR3BFd2c5bUswcGdH?=
 =?utf-8?B?RW9BY3VqSkVqaldITnF0U2MxWDNPT1AxdGFGOUhGdmIraGRCVXdQOXI1ZWp4?=
 =?utf-8?B?L1BLMzgwZDN2RW5va0dnMitYRU5zZzR1RjNRTW1qZ29GK2xhWVl3azd1NmRk?=
 =?utf-8?B?MmJxOE5IV1hrRzdjK0tlWTFyNCtSWGVTYjgzV2F0V0k0aEhkYVd6TWdYVmZy?=
 =?utf-8?B?cmh3cVZPczQ1bXIxQTZvU3pYTXVJb1dhOVFEOE9wNUFxbkJBOUlwYk1WOW1D?=
 =?utf-8?B?dmRlbEhCaW9Zcm9SV0M5SkpEZFJxSVFwdVlGbnIrTmI4T0w3NkNQUWx1WjVP?=
 =?utf-8?B?dmt4ZlFneFd1bE5qem0vZzNtSmNuMCtER211Z3BvZFVHcWlKZGo2YkViTXkr?=
 =?utf-8?B?dGgzT3VLN0l6cEdZOGRpTlcvNXV4SWQvZGYxYVhxaVhJRmJRbEozOWZBSUlZ?=
 =?utf-8?B?VWZ4c0VzSUpkVU5vQUdDOUhoTDJpWEVQRmhPY3lHM0ErUit3Z200MlJDVnl5?=
 =?utf-8?B?MFc0YzhTMmZpaGJNZjA3Qm9DOHhrSkRJUXIrT0FoQjRrSkRsUmlOLzRMQmUx?=
 =?utf-8?B?OVJLd1dTYXRZYXdnYjYvUFR3S2lodWxKNGpIZWxuUnZ6emJqdXZWY3czWTVJ?=
 =?utf-8?B?K2s1Y2tWSm1vS2wwN0FkN1dpZVVBRlFXR3E1Y0pxL3NhVW5sWHMzcU5ac0xN?=
 =?utf-8?B?VXJyU0ZVd1Fob2xyNWJwNENDT1dtQzNxSGxWSlZkYXJHV1BuRjE0dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5BD180DA822344F9E1BA50E795A7EDC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Dfxw/lfJkCJTpw6T28dQhToGo9JAUgxMqA7YUIXFiDUZe9scEJMuCvT3vVh3vYKHY2Da0V7dOgsCGq6M5BpLuIeE6x8oOxH51ZcP1h/cs98eg8CPzOsLsayZKDHsG5y8XtYjp6EwnL5iXRdu9p0T9iWFR+Zygi5yfVs0t1soNV5FguRyBgzV+/lw955O9/IEksm6iT9wcxnTsP1uheiaj85sUgs+VDjNxlm3hK+OrKiXj/c0oRf1U3azXcBnYBV55eMD6nA66JCVLX9QOG4Lk8izj9weixqZJ6zn7PhIhL9G90A7JBjrJNAXlDyIQqdQ5SmQ5NiFTW63yqNbK09QVw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5702.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0fc2145-d3da-4cbd-f7ff-08dee797711d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2026 02:17:55.6448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RCVv5pH78xGHNSbeOKTcAjbCKmHiustxhzTya008dUfkOfXf9573DXnRK94kDoXaaQpZ9ogOqI27ykmrcZJNHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6209
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTA3LTIwIGF0IDEwOjU0ICswODAwLCBsb25nbG9uZyB5YW4gd3JvdGU6DQo+
IFJlcGxhY2UgdGhlIGRpcmVjdCBjb21wYXJpc29uIHdpdGggKHZvaWQgKiktMSB3aXRoIHRoZSBz
dGFuZGFyZA0KPiBNQVBfRkFJTEVEIG1hY3JvIHdoZW4gY2hlY2tpbmcgbW1hcCgpDQoNClRoaXMg
c2VudGVuY2UgbWlzc2VzIHRoZSBlbmRpbmcgcGVyaW9kLg0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBsb25nbG9uZyB5YW4gPHlhbmxvbmdsb25nQGt5bGlub3MuY24+DQoNCkFja2VkLWJ5OiBLYWkg
SHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=
