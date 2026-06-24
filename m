Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAFF3093CB;
	Wed, 24 Jun 2026 08:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782291267; cv=fail; b=oi8og8OrNunAGsyJz5KZkHAxwJ/u0Y/dtM+LPvLJBz6O3w+TsoBZZk2r1xBVYZBxHdY9vPhXywG0QvEMkAkRbLOsQYlDpNVQeqOCysB+WTKz6wlI6jMi46eIz0OydBVLW3M6w+D/k21v6yStcXaHYf2PBRgxAalXpgQdpfsMgLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782291267; c=relaxed/simple;
	bh=38Fs1Ex8LJUlNI48QxM8zogQycL1S3SxdRgpr8C4ibE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UBK9yIxQmJhiuL0DgguzSQMRkg2Up3q10EeXAsv8YbLft/HylKt+1uCi7vHphygLE+Bf9t3YX9FoUMaNzN8pakt6wCX4ot6pseiAQuUM2YDfzPXPw/VZVEQNJGF0Z7X7tSfIx4IIIt7cb3VcJ5o8oIL3ghuzJSZs5hrQSLX9Bxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L0chTkZa; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L0chTkZa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782291265; x=1813827265;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=38Fs1Ex8LJUlNI48QxM8zogQycL1S3SxdRgpr8C4ibE=;
  b=L0chTkZaNb/J3GJF+N4FzIN3iacFF3OW+ffJRyOHQl8scjKhllShflv9
   /TCBPTKVBi/6qlEg4IujdRJti2Wwbs4qMjVl5m7287PluN+IB7KQT1q+P
   kMql99VhNmhU/HJTyR1uenYBNBAuanR3kt9wKsDYv6WkdL7BxiLzDKH9o
   wB5Gyy0FZWL5SxJLhdSUh6JRhnG7XePxwNGqfl/8PwpG7c0iu8WxY6AdO
   N3gGUhCRCkCmfCR7mXK0ij68xSrYklg1jHfgA3QfbhD9JvD1z/cKPWR2S
   O+8aqlDm+piDRlWvIDcqP3+VWx9rHX9AlSTyFJS5t8W1Uok42+lhE5r8Q
   g==;
X-CSE-ConnectionGUID: DAPOrxjpR/KWn+YZ4LlOzg==
X-CSE-MsgGUID: aSdYFVPITmOORU4HuKMbSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="108596382"
X-IronPort-AV: E=Sophos;i="6.24,222,1774335600"; 
   d="scan'208";a="108596382"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 01:54:24 -0700
X-CSE-ConnectionGUID: 7xZQ0f3STYipE4pGvXXlEg==
X-CSE-MsgGUID: 5hM3J7IwRamdCPweatsT7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,222,1774335600"; 
   d="scan'208";a="247416122"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 01:54:24 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 01:54:24 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 24 Jun 2026 01:54:24 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.2) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 01:54:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fACzcWsrZru/kI88wxolzOfsr8UkDaS4E0RljiQcYxodBislxcmaFSEYEa5Rn6iRwdlGk293AYcyibbV3K+U10d3pus++ySJU6QP6xdV0YyMcndkJdVtj9dPIpbBiNxiK6vsApepMPd5yNRrM2A6Vyyv0y20HU8NrHybR53wjZ0IPx+V/vRPGMFY3SX2cb8AD9rAwB521uoUVXm7ke88U6oyBBOkeaoGMvgbXaLQBU2/VWuCermucmFcSq9v0+fix6/9T+MQHRKRy4bhwuE8AnttElL+Y37v3lMC/OzpA0881DH181mVM1luzlEqV4w2e9QD6BCqRmA+Z8HPs+8R5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38Fs1Ex8LJUlNI48QxM8zogQycL1S3SxdRgpr8C4ibE=;
 b=PEVVsLAmG/2VVmVQbzDany0ehQulHNT0BPL9ZaLRllVBMMuzImJqv9eOsmHifv4oInGlMQcJF0OA0jGlECDGReDb+TtFRpO4tGxlO7rWT2aaoGJS2gzIG9fPqTovpRg9hwzOr3K1Rn9vKf6MghqOM10Dyf+vNSpPLV2mESMx+tdbo6dGflIlT1glHLusfnIss68vFe+hREb8q6Ue4H0Dz/3CoE9Uls8ZtEdTapp+7J6AARPsp4HU8hMl8QHMK9OtUAtcIjU46oklj5TREOFA45nr1/kwX7lzXqm6+9PGdLHxoWcP99p5CAEmg8Np5YipsCA1GkyGWou7MT2tonKo6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8455.namprd11.prod.outlook.com (2603:10b6:510:30d::11)
 by DS0PR11MB7481.namprd11.prod.outlook.com (2603:10b6:8:14b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Wed, 24 Jun
 2026 08:54:21 +0000
Received: from PH7PR11MB8455.namprd11.prod.outlook.com
 ([fe80::789c:dda1:63ec:6dbf]) by PH7PR11MB8455.namprd11.prod.outlook.com
 ([fe80::789c:dda1:63ec:6dbf%6]) with mapi id 15.21.0139.018; Wed, 24 Jun 2026
 08:54:21 +0000
From: "Miao, Jun" <jun.miao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "challvy.tee@gmail.com"
	<challvy.tee@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "qiang.zhang@linux.dev"
	<qiang.zhang@linux.dev>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>
Subject: RE: [PATCH v3] x86/sgx: Fix RCU Tasks stalls in EPC sanitization loop
Thread-Topic: [PATCH v3] x86/sgx: Fix RCU Tasks stalls in EPC sanitization
 loop
Thread-Index: AQHdAr87UMKfMm0DwEGwMxyh46o7EbZMAriAgAFjuLA=
Date: Wed, 24 Jun 2026 08:54:21 +0000
Message-ID: <PH7PR11MB84558F38F3AE88723204EBA29AED2@PH7PR11MB8455.namprd11.prod.outlook.com>
References: <20260623032034.2819324-1-jun.miao@intel.com>
 <50fe4d469227dc99c1672334021726cd5cc07856.camel@intel.com>
In-Reply-To: <50fe4d469227dc99c1672334021726cd5cc07856.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8455:EE_|DS0PR11MB7481:EE_
x-ms-office365-filtering-correlation-id: 1311e845-afba-4f6e-57d9-08ded1ce2efd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|38070700021|22082099003|18002099003|5023799004|4143699003|56012099006|11063799006|6133799003|3023799007;
x-microsoft-antispam-message-info: tGfddAhL9B8LsRD5rL5TdhhOKeyjizLpjIAH372k5liMOOTvUNy397QyF6STXkPGbD46mFvggU8avGb6ScLpxAeRN5fCKvcUuH4AxufWk5A6LiiCEzq7pxkxM/jNhbTvDPltqqR6+4aixJFflr2gAzSMIsDvdJbv4wi5JS10TlPAieSXXxsKVzmPUn4J1qN+e8o5yOaCmsJ43/gFCyUuXVZqOGsuy7Polj0J0UAhs6VJ1/Bdqe5+zJaA7e/zi5imZQ1A7pbREjbOD91+AcpETOHrkWMkuJVr64q0KSwVKixNJoBhG+nePOXYS4W42709EnR99Gd6pr5fI4np8toFmVXAF1cE63H02fCaVEtIkqUBQag5yAE+5OHf6QRkYkbPHMqQAir0I/f4jBoto/jp8cP0/EjeQ6Eu/mDCD0jwkO8uo2jV8UuXEGn+JH3gWkkf6dxi0FSHk2SGdXZ4nFy8bKAYMF371hIfFx1gtf5ca6Priq463pfG6nMcjmhBv5QTdQvYAx+FKO1xRnOXxG3ouL/y+qQsF+dUjQf+FQ9crjAiNR+tIGMlXEvYQf3gOcnjhXjFh0sHzJq9NVRSRNuFt++iYYHa55kU3+T7GUHGLWylbbyB0NUh9lX7nvNJaEGsDV3fpNuZQUo8NGyKp3FhOA1W5/X2t5rfie9w2ogzIKF5IZJcLK/Ab+ZxIet5vS1/UipEgzoi6aANUv9C6rm5xqd1VQFAz8Vq2qsQAzGdUWY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8455.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(38070700021)(22082099003)(18002099003)(5023799004)(4143699003)(56012099006)(11063799006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUhicnJncDNCTkJWZk1zWFk1ZlVXazFNTm5sYllKMkIxVldib2xNYmxERHdV?=
 =?utf-8?B?TllaWWdjOXJQdGROUEtRcXlyMVpiUjhNdHE2QUpmT2JNb3FoOXA2eE93WUow?=
 =?utf-8?B?UGIraHVlMXVRUFozS0J6UHpNbTdWSGVPcmFJb3gyTnZDQzNQSXl0MUk5bml1?=
 =?utf-8?B?Q2xUVERWaEhLazF6MjFqeHVPSHhGbExVSmNVbFV3VEdjaHB6NktZVzh2RWt5?=
 =?utf-8?B?WTZJTXMrYzlPYmF1dmlwMm81bnJGRXVsMVE5VTl3WUxXZHZmd0JveGpFU1k4?=
 =?utf-8?B?RmV5OGg4TUZVQkhTUFFqdkRCTTZjUHM2ckhaMWVVNTNIQ0k0SEJwdEVUdEw2?=
 =?utf-8?B?RGVHT2x5czVzeHhuWllzY0RHYXJMdDlkQUlRbTRLdFJEc2ZvRm4xVno2YUpl?=
 =?utf-8?B?eStyZXoxRTlOdXV6elZJdFNmdjVRVVBhUXFyZE85dnZVTGJFZzhUOW5RMWFy?=
 =?utf-8?B?Mkt6WUFLbWREcksxQ3JBUEtEUkRjNzU0VVhWTDVSbWtmdVR5MVZCemI3ODAy?=
 =?utf-8?B?S0haelZubTlua3pNMjUzcDdzWWV0TlFjT241emlIejlNOG5WSzgvYVJYNUVa?=
 =?utf-8?B?cHZjdDc3ei9maHcyTnFxNDhlT1BaUDQyTGtOMmVsZ0hmSnVkNzE1czNZZDFL?=
 =?utf-8?B?eHNXdHdzQTV4bkFpYjBEckdPOFdLUmtweDJ1SlVBT1YwN3BySjNrRVJoK2JG?=
 =?utf-8?B?Q2pBYUVBWWRTSGtFMmllWnVtY0RTb2t5ZWxJZVdkUHhWSVYzWm4zTTI2Mk9t?=
 =?utf-8?B?YkxCSkdaekJYdEl1a0lDRTVtM01JdGhLRXVFb1BiOG83Q0d0VWhkWGVqT3J6?=
 =?utf-8?B?bUVhcW5udXlKTXhKQTg2eGhTaEdQZDVFZjR5NlJMK1B6TE1RcExLMGtwUkVt?=
 =?utf-8?B?ekJGZVh4M1lHTEVQSnhhZ1BPRmw5V0NrV0ZEajlQRTJNc1BwQVh4ZGtiVEE2?=
 =?utf-8?B?NHUxL0ZIcmZXQ3BxUHNtM2NCOCt3bGphZXdySEcwTitZTG44ZFZOem5FZ3NB?=
 =?utf-8?B?bm5aL05ueWt2bFNtaG4rZ0pnVjN6MEVNd2g0S0ZGUVh5ZDNtLytqb0lKQk9H?=
 =?utf-8?B?RjljZGowWTF4ZGhRYzFYOThiL0JvU3FLTEI0YmR1aFAwdElxdFZ1djBuOUYv?=
 =?utf-8?B?b1BLRG1MSHZFYWJORmxKWWhMK2FOM1lDTFdCd3ZpUFdROTJCK1ErNU1sa3dq?=
 =?utf-8?B?Wk03azNOa0FlbTI1ZHVMRFJzd1BJdGVKNXlETVk5NzlNazZlTGpMdy9aaUI2?=
 =?utf-8?B?b01GbGliMHpqdFRGRG4rMkp0T201RGpmd3dEQnNUNWJ3TVFnek45ZE14cDBw?=
 =?utf-8?B?Z0svVThoTThnd3YzMlc4ZVA0SFowam9oUUJxTVNLUWxpUXFWd1EyODRqcUw0?=
 =?utf-8?B?ZUZrYkh3SmxsVUNIRFRJc0M4ckZ3NnhOdTVUTStZSjBMNmxsRHg3NlNNbmlr?=
 =?utf-8?B?cXpIKyt4Z1JETm5Od3hIYlp6R2hkYUR2bW0vQnpOTW1lU2RjcVd1V05EYzF6?=
 =?utf-8?B?L2tqdkZoZnpVTmJEOTFuSmJCQlFaWWJDd1BnbzFrMXViNmIzY295cUlUZHlz?=
 =?utf-8?B?NzQwZE5RTWRwQmFyWE5CVUpJcjN3MUtheDQ1REJVZkU0eGw0WGpmekh1VTFh?=
 =?utf-8?B?NXJ4MHkycmlzTi9zWXBtNmtQZUxNRElvTWp3OXN5OTN3NEQvbTlJeUNFbVlp?=
 =?utf-8?B?NmQvb0hKTVovQTJYVWZrU3JHVXkvMWlieGRleGtTWVpieE90M0g3UVNHR3N0?=
 =?utf-8?B?R3V4MU56QUlNOE5OQTZyU05sblEzbCtvVkFrTU1hWjRYZ3cvRnBkcmZ5SGdM?=
 =?utf-8?B?WjFhSC9WSEFONTZpNE5yQ21TdHRnZTNacmlvSmc4R0JqYUdNWGpWdEdvcWNo?=
 =?utf-8?B?VWwwR2hNcEVRZXpQTW83dmhIeVVaeGpCQ1NQait5S3o5bk9sRHUzSjdrOEhj?=
 =?utf-8?B?OHNyOFprUFltWnlwamFiU3VCOXlRMHgxMGdrMDkrbDBBNVY5Yk5oSFBva3RH?=
 =?utf-8?B?TGdDTFN2VHhmeFcwK3RlOEV4b3crMjlTNmY1VGVSYy9WZURjZzZCeU4zeG13?=
 =?utf-8?B?b3pTY3RqVEJlMXBsdEt0Y2JHQ2NJdXpFTW5xLzN5cTBlcmhlaE9rWERvVkdI?=
 =?utf-8?B?WjY4aTRHMktLNnNKOGJsWnhoMmgxZVh4SkZTL0ZTc1FyUHpjYUdLeHh2UlNt?=
 =?utf-8?B?RkhaMGNtSm9DYmliNEsra1VYTmplYnlqb29oQ0xBODc3bzlpQVB1QnMrRFZx?=
 =?utf-8?B?b2RlRW5JZkhXV08zVXRvZzYzQVVFYlJHUU5DVlhMSXNFellCQ3hhbjNXaGRL?=
 =?utf-8?Q?EJ17eNsiaCRchpyIBe?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Ln1wkpXHEPo3v+AGUKzO05nevbKDKW9DTu1LqH8cLrdZi9+cFyEtqmIOlRPwWDczNzepwGB7EBnf5zcK+kQK4FManyEfN9q/JlDLvbTD13wbe3TCVx54b/2WP3zhlnjOtj68Y9LF0XM+tE1wkpI+TEH3CJk1vBvDkm4DEbfufxLhaVZCawGY5xyEqf8AQH/by8SsjSTeSIMTAzdkNV3P/krydLB3p6NQsq/lUZ6MyM6bweE/tEq4FH306AaCLFQxAzZKS29+gkdBAEOp7g9/lvshQ0QLmjkcqXIp/x8oGwJXae8EZkzdYKgGlu9oV7KnxRNeYUX7D2qvoULU5jfOzQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8455.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1311e845-afba-4f6e-57d9-08ded1ce2efd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2026 08:54:21.4443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: evtrFRti8CWpQ0hBOj05IixjHN1FqOJXXLyHiZFqHHnGFGh6s/lTiUKTA4T7TMQ9N1qbXwbXO7+sc8Bn0/dcKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7481
X-OriginatorOrg: intel.com

SGkgS2FpLA0KDQo+KFJlbWluZGVyOiB5b3UgZm9yZ290IHRoZSBsaW51eC1zZ3hAdmdlci5rZXJu
ZWwub3JnKS4NCj4NCk9rLCArIENDIGxpbnV4LXNneCBpbiB0aGlzIHJlcGx5Lg0KDQo+Q291bGQg
eW91IG1vdmUgc29tZSBjb250ZXh0IGZyb20geW91ciB2MSBhbmQgcmVmaW5lIHRvZ2V0aGVyIHdp
dGggdGhlIGFib3ZlDQo+dHdvIHBhcmFncmFwaHM/DQoNCk9rYXksIHdoYXQgYWJvdXQgdGhpcyBj
b21taXQgZGVzY3JpcHRpb24gaW4gdjU/DQoNClN1YmplY3Q6IFtQQVRDSCB2NV0geDg2L3NneDog
Rml4IFJDVSBUYXNrcyBzdGFsbCBpbiBFUEMgc2FuaXRpemF0aW9uIGxvb3ANCg0KRHVyaW5nIGVh
cmx5IGJvb3QsIGtzZ3hkIChJbnRlbCBTb2Z0d2FyZSBHdWFyZCBFeHRlbnNpb25zIEtlcm5lbCBU
aHJlYWQpDQppdGVyYXRlcyBvdmVyIGFsbCBwb3N0LWtleGVjIGRpcnR5IEVQQyBwYWdlcyBpbiBh
IHRpZ2h0IGxvb3AgY2FsbGluZw0KY29uZF9yZXNjaGVkKCkgYWZ0ZXIgZWFjaCBwYWdlLiAgQnV0
LCBvbiBpc29sYXRlZCBDUFVzDQooYSBjb21tb24gY29uZmlndXJhdGlvbiBpbiBjbG91ZCBWTXMp
LCBjb25kX3Jlc2NoZWQoKSBuZXZlciB0cmlnZ2VycyBhDQpyZWFsIGNvbnRleHQgc3dpdGNoIGJl
Y2F1c2UgVElGX05FRURfUkVTQ0hFRCBpcyBub3Qgc2V0IHdoZW4gbm8gY29tcGV0aW5nDQpydW5u
YWJsZSB0YXNrIGV4aXN0cyBvbiB0aGF0IENQVS4NCg0KQlBGIExTTSBzdWJzeXN0ZW0gY2FuIGlu
dm9rZSBzeW5jaHJvbml6ZV9yY3VfdGFza3MoKSBhdCBrZXJuZWwgYm9vdCB0aW1lLg0Ka3NneGQo
KSBjYW4gbmV2ZXIgYmUgcmVzY2hlZHVsZWQoKSB3aGVuIGRvaW5nIHNhbml0aXppbmcgYWxsIEVQ
QyBwYWdlcy4NCkFzIGEgcmVzdWx0LCBhIFZNIG1heSB0YWtlIGEgbG9uZyB0aW1lIHRvIGJvb3Q6
DQoNClsgIDEzNC44MDYxNTddIHJjdV90YXNrc193YWl0X2dwOiByY3VfdGFza3MgZ3JhY2UgcGVy
aW9kIG51bWJlciAxIChzaW5jZSBib290KSBpcyAxMzA2MzEgamlmZmllcyBvbGQuDQpbICAyNDgu
MDg2MTU4XSBJTkZPOiB0YXNrIHN5c3RlbWQ6MSBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIyIHNl
Y29uZHMuDQpbICAyNDguMDg2NDkxXSBOb3QgdGFpbnRlZCA2LjguMC05MC1nZW5lcmljICM5MS1V
YnVudHUNClsgIDI0OC4wODY3MzldICdlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFz
a190aW1lb3V0X3NlY3MnIGRpc2FibGVzIHRoaXMgbWVzc2FnZS4NClsgIDI0OC4wODY5OTNdIHRh
c2s6c3lzdGVtZCAgICBzdGF0ZTpEIHN0YWNrOjAgICAgcGlkOjEgICAgdHBpZDoxICAgIHBwaWQ6
MCAgICBmbGFnczoweDAwMDAwMDAyDQpbICAyNDguMDg3Mjc0XSBDYWxsIFRyYWNlOg0KLi4uDQpb
ICAyNDguMDg3OTM5XSBzY2hlZHVsZV90aW1lb3V0KzB4MTU3LzB4MTcwDQpbICAyNDguMDg4MTIw
XSB3YWl0X2Zvcl9jb21wbGV0aW9uKzB4ODgvMHgxNTANClsgIDI0OC4wODgzMDRdIF9fd2FpdF9y
Y3VfZ3ArMHgxN2UvMHgxOTANClsgIDI0OC4wODg0ODFdIHN5bmNocm9uaXplX3JjdV90YXNrc19n
ZW5lcmljKzB4NjQvMHg2MA0KLi4uDQpbICAyNDguMDg5MDQ3XSBzeW5jaHJvbml6ZV9yY3VfdGFz
a3MrMHgxNS8weDIwDQpbICAyNDguMDg5MjYwXSByZWdpc3Rlcl9mdHJhY2VfZGlyZWN0KzB4MzFm
LzB4MzUwDQouLi4NClsgIDI0OC4wOTAzMzldIGJwZl90cmFtcG9saW5lX2xpbmtfcHJvZysweDMz
LzB4NjANClsgIDI0OC4wOTA1MThdIGJwZl90cmFjaW5nX3Byb2dfYXR0YWNoKzB4M2M1LzB4NWYw
DQouLi4NCg0KQWZ0ZXIgdGhpcyBwYXRjaCB0ZXN0IHJlc3VsdDoNClRlc3RzIHNob3dlZCB1c2lu
ZyBjb25kX3Jlc2NoZWRfdGFza3NfcmN1X3FzKCkgcmVkdWNlZCB0aGUgYm9vdCB0aW1lIGZyb20N
Cn41MHMgdG8gfjEwLjdzIChzeXN0ZW1kLWFuYWx5emU6IDcyNG1zIGtlcm5lbCArIDEuNTc1cyBp
bml0cmQgKyA4LjQ4MXMgdXNlcnNwYWNlID0gMTAuNzgycykNCg0KWyBrYWk6IGNvbXBsZXRlbHkg
dHJpbSBkb3duL3Jld3JpdGUgY2hhbmdlbG9nIF0NCg0KUmVwb3J0ZWQtYnk6IENoYWxsdnkgVGVl
IDxjaGFsbHZ5LnRlZUBnbWFpbC5jb20+DQpMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vc3lzdGVt
ZC9zeXN0ZW1kL2lzc3Vlcy80MDQyMw0KRml4ZXM6IGU3ZTA1NDUyOTlkOCAoIng4Ni9zZ3g6IElu
aXRpYWxpemUgbWV0YWRhdGEgZm9yIEVuY2xhdmUgUGFnZSBDYWNoZSAoRVBDKSBzZWN0aW9ucyIp
DQpUZXN0ZWQtYnk6IENoYWxsdnkgVGVlIDxjaGFsbHZ5LnRlZUBnbWFpbC5jb20+DQpTdWdnZXN0
ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCkNvLWRldmVsb3BlZC1ieTog
RmFuIER1IDxmYW4uZHVAaW50ZWwuY29tPg0KU2lnbmVkLW9mZi1ieTogRmFuIER1IDxmYW4uZHVA
aW50ZWwuY29tPg0KU2lnbmVkLW9mZi1ieTogSnVuIE1pYW8gPGp1bi5taWFvQGludGVsLmNvbT4N
Cg0KLS0tDQpXYXJtIHJlZ2FyZHMNCkp1biBNaWFvDQoNCg0KDQoNCg==
