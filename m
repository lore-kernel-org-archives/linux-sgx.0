Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B72965192;
	Tue, 14 Jul 2026 00:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783988608; cv=fail; b=Z/Sh+GfyBrQUCMlh6/FqH1iLLDoH6A/blwKovJQEXBOlzth6nNxPvTMEReEYUNNbm61jW5t1VCYr2CdJJ7QiK24S/N+4RY0cTnWb+X0efkFXlCHPtrtc4nXY36NLLK3MEzmXaKGmYqmKQTC1BVooIPUI9HRA9O5Av00fp8BVLKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783988608; c=relaxed/simple;
	bh=LzNi0Dv8bnCFAiYN+jo1vQeJcmZrhS4MA3v8naX1ij0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G+a2VVWKUQBr3CfJcEEZgXnWc/M0fasm6VV2nZ0LH7CYvipsWVVybcXAJAXcvUuZuRunT2gKmM+LfSsD7PR+ydtJ6OZ96S5Ad93/BBUwt3odQ3fTNhK/iEGe5mdk5xqks7SOp1DnwpOyaXBc2dzirux5esjP15wJ/qw22WUXrzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OwcvHXHM; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OwcvHXHM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783988606; x=1815524606;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LzNi0Dv8bnCFAiYN+jo1vQeJcmZrhS4MA3v8naX1ij0=;
  b=OwcvHXHMfF+ad65s6Z9fN6P+omJWy3jJeh1c/gXrsaSuXUrgmmgPlTJs
   LwxdfCNN95iyugR2KuhzK+MPoKJkLaSIuPxwk2sJu8YfhFKB7UOiTGO81
   N7kfbdR+xckIdQgArylQXyp4bmaBGPq+lOTQnR7R7RoM3F6q4dKXTGHag
   8rR7eFsQqTYnz5Jny9rNK/P2Q1rXwJEZOmzLwpEVCvpMUdOds/yOnHw/f
   8Ts/TmpCvMFzaI7z/vGALRiJjTtX7n94bZawN3mA1GXKWvp5F0NvPAk57
   dGwhQsFsRUAl6J8dx4jao418jigXVN7j/+QzYyH3zm53liqccKhWP80hx
   A==;
X-CSE-ConnectionGUID: K8hXrWayRCqA+HMq4OXkMA==
X-CSE-MsgGUID: KbkHB1sJTEewQHnvWeZnaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84569347"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84569347"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 17:23:26 -0700
X-CSE-ConnectionGUID: ImElOzWZSVuIZtNfQrtrWQ==
X-CSE-MsgGUID: XOKPFt5XQma7eSh/zIgBSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="259549310"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 17:23:26 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 17:23:25 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 13 Jul 2026 17:23:25 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.22) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 17:23:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fg0TtVbP8W6TtQiTauwc/7r4D5XZOarTkl+i7S50BOt9OP6QYE5FtshQ3bihaZ7tbO7qBOj1qvvHXDSfBOgu6srUFNj+qq68oHP/iVYXexnkJ92uWI1rTG6CBRjEl9jfDbR2qX400VzbnSAjerGBty1uB4DAECKGs+Vpjx0k4I5X94zskHJxUULIoGqLENTZZ+CLWbb9bGd2B7NCAohA6km29Ea6n8zPyGJi2o9BR9D5M8QOJX5oCKV3L3zHi3qQEaF5vdJM//qi3qCHrtqO2IigIhhWjbVOgWQEmzXR6o878/jezxKv52iGEo0QiZaDNuqfnVZq1JKBUvdAQsqHGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LzNi0Dv8bnCFAiYN+jo1vQeJcmZrhS4MA3v8naX1ij0=;
 b=thEuJwOPwYpm1gEEQgd0llsX8l6zqhfNJ5m7aHb/Z+KXO1fUqj7OunEMNhetlGwCqbCnByfv7qrPv3k1L+wzdtgXzQh780o/P+whB10vjKVBhq63FOvUNz7XSQ6/ndc8pGuvAHx/ZA4L4cEMtW8HQMpf3YZQFKUr19u8n+Z0GDooC5YUiifITedtqYJqWHKPyJmtx2uTiaGlzJ16ZxOmkXTbl5tAZ3XSFwsfHOy4VOrmQOrjFBgisqfbNpEfqA7bQ+LKWaXCG/OA/J3om0qoaarsrDWCfI8JASksZaONJRBgsJ7196KGBmRSANRFGW9KBEooE+nfJOPTUythqCV+UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5702.namprd11.prod.outlook.com (2603:10b6:8:21::10) by
 SA1PR11MB8317.namprd11.prod.outlook.com (2603:10b6:806:38d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 00:23:21 +0000
Received: from DM8PR11MB5702.namprd11.prod.outlook.com
 ([fe80::a973:3a5a:91e8:49b9]) by DM8PR11MB5702.namprd11.prod.outlook.com
 ([fe80::a973:3a5a:91e8:49b9%7]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 00:23:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"thorsten.blum@linux.dev" <thorsten.blum@linux.dev>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org"
	<x86@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86/sgx: Remove unused TCS definitions
Thread-Topic: [PATCH 1/3] x86/sgx: Remove unused TCS definitions
Thread-Index: AQHdERxuxsXsz2hTu0+XBAqu8Sbw/rZsK7iA
Date: Tue, 14 Jul 2026 00:23:21 +0000
Message-ID: <45c57e60515defe6a95d3f1bc1b13ae7c5f430ca.camel@intel.com>
References: <20260711100053.739588-5-thorsten.blum@linux.dev>
	 <20260711100053.739588-6-thorsten.blum@linux.dev>
In-Reply-To: <20260711100053.739588-6-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5702:EE_|SA1PR11MB8317:EE_
x-ms-office365-filtering-correlation-id: d6c3a37c-59f5-4d02-85b4-08dee13e1c6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|38070700021|56012099006|11063799006|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info: 1is5lGq83/Fo8qwXejM44+FZiIHZfsgT9/7dWjsOPzSgRP8Tq0LEBkc71vUu/K6lPoOtT1B4huyw2P/DhMFmziKxqy5uzF1jxPQJ7ZoCAg30lHkTvsZE1T30v9Kun0Ya3d7OSKlnXNIQM3pa6l/ehW5fuFScDSaRr3cndo8kYJoZyvoXiPJHX7WkWYt3k/Q3ANqE2whlCRU2exSIyKz+IFXYEX7L7CL7xdJ7bj1r9YLWDYK4o4PnoKo+3PWTtPtkQteU0OeTuJLAlhe+Y1rW3XXF3GoyEy0E2cKF5KZkuV9Ma49/IC4VHS8I2jV6FJKCtn3tsjcJ4BLWUO7vTrMqPJi0HealTM5kyLV0inUYoVIeRsd387MI4vywSXs0h0jt2DAKO6rzqryRLIS9RfrgtITci62In9WvuvZ2xicuNpD6U7zHbejRf85IHCCkouFNAztNBPBHvQfh7wt0Zqn5BXhJGeSeXVdocMBSakbREz1OYYDolaYeFuHTq+zBsegPG2YwRDcqo0mDDWTrnYwds44kWolX+oTh19JRCtOJxi0fOeNxM1Vxovp1iIEbi37PpXsoPHvH+N+WdokWLRceRyeyaKrsaKwQH0LH0H0X0aIKj8hcMLtpOisVU9GPZGFTVnw01llj9MCEY53k17kVew/GA57JTXREcVxozyaxU1B06r8j0Slz8p3t23JyK10O1yx8PWqwipZLd8vUdflaG9csCVXCejRn0mV+08VtJvw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5702.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3d2Ui9jbDlPQThKNk1qSWNRUzhoaVAvQnNRQ200bEdEMUpLRXpzSjdqdVJr?=
 =?utf-8?B?bkYyODZZNTdtY2tVbDBhU0JlSE10cXNrRm5CaUNDa0RkZFgrOVNhNGZvV1FC?=
 =?utf-8?B?VGRQT1lzRmlvLzdVUnBGVHh1aUg2Y0JNY0VSYklGOGFNQW96VEZYN0RMdkgy?=
 =?utf-8?B?TkJjWGtFVEFuUDJjenlqZm9QNmN1djVNa3lPd3Z4cGNaMjBRUUE1VjdQRGxH?=
 =?utf-8?B?aHFiSy9rWEd5a1dmYXNwbm1Hc0JFQTFpRmxoWTJxRU1OcXE0eWM2NGMzb2tq?=
 =?utf-8?B?WS9VUmFoVFNJODZGYVd6ckhzR3k4cnVlOFZhblB4UlAyV0VGbExFN3J0NEho?=
 =?utf-8?B?L3dzT3J4Yy9MVzFQbVlHQ0RiMUhuV0R1SG81cEdKOXUzcXNGQkp1MmtOS3ZY?=
 =?utf-8?B?SVo1eUFOVzlkK0pLTlE4dzRVSW9DOUY5YmErSXdPdXhOSHNqQXFKby8xcFR3?=
 =?utf-8?B?QTFBeGJqcjRXMjNwQmNOcHBVeDZlTEluNzJidEg0elpBRUpuV093bU91TTls?=
 =?utf-8?B?UlVRdGpNL2lBL3JXZ2R1eXcycXU2TFlsOVM0TEkwc0hNWHBuOTZLUGM5dFNh?=
 =?utf-8?B?M3hWOUorYW5ka0RlNW1mZGt3dE1YdkdGYm0vdEdBYWkrQzVYUXNnUENuU3pw?=
 =?utf-8?B?dS9ML1oxVjRob1ZwVm56SlZIUkFwYTk1dWlnK0c4alB1RUNSd0xCcHNQNmhO?=
 =?utf-8?B?dnFxckI1ZitESVlUa3V2UGdPT2t4L2lDUnB1bldGQ0U4a2lZZDNhQ1dGMjgr?=
 =?utf-8?B?YTNGV25NM0RRWWRZbnNmL0VVVDB1Mk5JSmxncEtZdnFJUFlQUm8yWGJBVXNI?=
 =?utf-8?B?dTVyOWNpUlNJdlVwZUpXNnAyb0RseWpmRml2L0pPK3NWM21XNEEvdjgwSm90?=
 =?utf-8?B?aFY2ZS8xT3ZZZGVpNVB1dnpHa1NvK05PNUZyNXdzUm9tM3piVmVhcG9EV1E1?=
 =?utf-8?B?a2x4QXNmTmFoSlpmY0k5bU44bmEvSi9FdjhxR3gydy9Bdm4reVFXdms5aEZI?=
 =?utf-8?B?eFNVVGl2VWNqcU1BN1liSUlBVjBGU3RDVjR1YkduSnR6ZW1BbHlNNUYvTm5Y?=
 =?utf-8?B?K0syUkU4WDlWQUNYTDIzK2F3L2hwVWI5aGtaekh0WTlrbG1jTDVpL29rRUp4?=
 =?utf-8?B?Uk5WcElNQzdyTUMxVTBrb3YyQlZlSk5aTFBVQnpZb1U2Y29MOEp0REVxV1ZH?=
 =?utf-8?B?dDRtS0s0bW9WdmYxbVYwNnZPYjgwRHYyU1VzRHVNT0ZNald0VWFuVTh4VDVX?=
 =?utf-8?B?T0p0YjdqYlFabk1ZS1JEaE50dnJub2Q3UFJ4aVF3UHQzS2lKQW9LNjVLUHhy?=
 =?utf-8?B?c2dxZFZBVUdXMXNUQWtvZFRiVmJ4amFla2NUK29SLzMvNm52dXd1QXNoMzVX?=
 =?utf-8?B?M3V4dTVKMk5RRHkwRnc2Q3pyQ3M0d0xGZERnTHJpUzJMMXpRUVlabzBkSFRx?=
 =?utf-8?B?cHNDQmh0d2V4cTBCZUZzV0xEYkZCenJxZ3ZmN3YyL3pFYmNhcFRkYS9PTndl?=
 =?utf-8?B?NDNIak44bEN6SHFkUnpRaEVWZjB0czRINmp4bDlQQkxDbXQyK0dwTkY5QWtI?=
 =?utf-8?B?TnRpbDJZYTdzU3lLSmd2YU90WXVMQ21YVXVHMHlFOERKWWw3eE5NdzRFMzNo?=
 =?utf-8?B?M2JlcjNQZzdIb3lkTGFWYWJsYUdJQnhVcENRSEpKRTk5QmlHZXJZNUV5ZFlB?=
 =?utf-8?B?ekRPbnAyNlRYVU14cXdxUDBQa25IMlN1UGVYWmFGcjlUN0FESXl1NmlZRmpm?=
 =?utf-8?B?dVZ0SVIwL3ZWcFFSTlZka0JWVWcrZVJyZzdMc1RSR3ZYQldDRzZlc0FTUm01?=
 =?utf-8?B?MlVOTG9zODVCWDcrVGhYNlk4ZnYrSDZoNHgybzNvNW5KK1VnT21zUUZzSk9K?=
 =?utf-8?B?bGxvSC85QmNkcnp3ZmpOVVh6QTQxZ253RUt4UGZEQlRJR2NrTGVUVkZvS1Vv?=
 =?utf-8?B?STc1Tk16dEN0NnFLK2dSWGlBemRxRFFnYU1XU1dHWTVvdlRMRXdmbXFHMkRE?=
 =?utf-8?B?TXdFTHNsR2RKMjdNV0NtMzlFY21wZ0pTZnBwd0k1bTJ0ZXV3MzMzY3pkS2wy?=
 =?utf-8?B?UW5zNWFSbXlyMXFvcUhkY1VPaVp2K3hKNzdwTThrMW5WZml3THRtU2ZSYzZ1?=
 =?utf-8?B?UVV6OEloVHErQ1RzZEJUMDlqZ0JSTjdFeTM0UGJ3eVNwck51NFJ6d1huZXdX?=
 =?utf-8?B?dDJRb0R6Sng1UklhNm9sTHQ0RlJ0ekZPOVg0ZzJHQ2hCUHoyTjZFRUxPVEp6?=
 =?utf-8?B?QUJNMk1rZ3VrV0R3STdGTEFrQkZEcTdHZncyWHRTRWlWc1cwVzZhTTNuVnlM?=
 =?utf-8?B?eGNDeDlGcUNWSUxnb2RxK1ZqWk1tekd6R3AyeVYwdzJkNWwrZUFoQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21B7BD664B923E48AA0F7AFC6F02D4D9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: kj+ls/NtxevBYrDMh3HqyaRW7yuzXrS9+XrUiWXUjpFfymCGHg/YIoAORZg08sfEeAQLImwIWCg2ew5tGp0OP9OGn1mSoE5d1tdxCxmHD1zJTzg1ur9fVXtGJhFN4Hs47Larmn3UetdTGz/I/3rnw9NHaMEVE6xpRm1yT8VsIliw8K8zypXy87G22jpYS7oRoHTs945St2uNgvB6rjeZrRSuvhsBSKr99jRGdqZG0vMKCCCb3jl6sUzwcVC6oY3Xy251scqQ0/TpgtmID54tBlF00nH9e1fhzEne5CUPQT8giKKnD4tXKxd3MKAKhlOvnntqOfBz4+ALW8Ah/aXhkQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5702.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c3a37c-59f5-4d02-85b4-08dee13e1c6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 00:23:21.4369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KPQz7PYPtS/MAj6dDKbUBJZxaZ2lJzi6XaZTJdFJ0CYC7cuRFcZNy75ziB8JQQ7phoFCzemYXOcXVa+ue2ejOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8317
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI2LTA3LTExIGF0IDEyOjAwICswMjAwLCBUaG9yc3RlbiBCbHVtIHdyb3RlOg0K
PiBUaGUgVENTIHN0cnVjdHVyZSB3YXMgYWRkZWQgd2l0aCBjb21taXQgNzBkM2I4ZGRjZDIwICgi
eDg2L3NneDogQWRkIFNHWA0KPiBhcmNoaXRlY3R1cmFsIGRhdGEgc3RydWN0dXJlcyIpLCBidXQg
aGFzIG5ldmVyIGhhZCBhbiBpbi10cmVlIHVzZXIuDQo+IFJlbW92ZSB0aGUgdW51c2VkIFRDUyBz
dHJ1Y3R1cmUgYW5kIGl0cyBjb3JyZXNwb25kaW5nIGRlZmluaXRpb25zLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogVGhvcnN0ZW4gQmx1bSA8dGhvcnN0ZW4uYmx1bUBsaW51eC5kZXY+DQo+IA0KDQpB
Y2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K
