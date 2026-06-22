Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5E4338936;
	Mon, 22 Jun 2026 04:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782101697; cv=fail; b=PpvJIDqOUMJy2U0fyFwu3Tzr3hmQXl5Mx/rxKtgmA+FY0LNYt99QER16YTKDZR+AqhUoMGKnBPYHlHvRGBcCi2N7SJgG0rI28oK+Bq3MQD909zG6ITbBP1NU3diP+ZWMwp9PemNH6C2MUWmwoErnCdjUO7NXCfKoK3wqq9pbF5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782101697; c=relaxed/simple;
	bh=ivLH4z2SW2gIxaqyNGTmLMYLfs92YJUhYf2hOe2bH/4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H3P/ayAjTOKH9kigtKc7h8freG2gqGd+WBc0bq+8jJB66OFTNmHGtYYkO5EH1u1Ikp/rZ6VnCCLBdMaJol9Av2qIpxOU7E8sudicoEKkrkc781KdN0zgu21/Sb/Zq0Be7xahXrv8yKrRxbYfZORcVN6bJojbyoWHnFIM7KnyKgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WJSKwcUW; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WJSKwcUW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782101695; x=1813637695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ivLH4z2SW2gIxaqyNGTmLMYLfs92YJUhYf2hOe2bH/4=;
  b=WJSKwcUWmrNhTLVNA7QWXWRCdUXET0jpvHFqQp5+yhbED0t1JJHr73QD
   0FfTdj9IDhdHIBfYguEf3WVR/k7PItmyCXlZNk5PNUSTdQzrHCRzD52xd
   ZqKrZhd6ZuHFQLityHoXVRoSLJ+bndcIOrmaRsm0ldHCzL3XqX7/JLWWh
   YH6sMttv5TQ1qI8r3DSRQpfgPGwlqockgwuVsgW7D7sq8qUSnjevS7WOt
   TIWCL3ZSzUAZAX0idySM3qgiE8DPGvWD3Tl7pPKWSHZpRx448hofPUxhS
   w/8+Vpj2LTQ29j9BVVEiXHjqhL3P53FkWl/vIEgAADN9J5UIeYzU/uNLs
   g==;
X-CSE-ConnectionGUID: 6UDt0LygQsepKCjw63Aa3Q==
X-CSE-MsgGUID: +9mIUBeISC6kaDOvuyFFMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11824"; a="93942817"
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="93942817"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2026 21:14:55 -0700
X-CSE-ConnectionGUID: lJ12gxGjTxK4Ewa87vEs1Q==
X-CSE-MsgGUID: GqGptX6DRSylyCmQ+5OY2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="247985775"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2026 21:14:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 21 Jun 2026 21:14:55 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 21 Jun 2026 21:14:55 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.25) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 21 Jun 2026 21:14:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pilkLNObwzMFzXFSOFH4UzR1di2Q66IprX/RHn9DHWkby9Jx17Yp11P3BKzva8HBX5/eA9WrIA/hI/DNbbOdeDLQiONo2mu94oEZxWiVusBa8QMceNKuj+fd9/KRZ5jtH/x+/ptzaqc26wWBOSq3I2qyoT5jgrXi54Mj082unyxg9twfuI6ZcD9oXhVi9+b/GmSzHqYcaw0M/rGDP+3EPwHci1pEArpVDigkDHjKdtawd1ZmtVYopOCuEsamMbpPGkxA6uJCgp3128aFWRPwtI1aISDugE3qSGDgMl/ZdjCX1MAQ3+SjMVv2n/2RENVdAM/IVZV4gUo/h4E3FRt7yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ivLH4z2SW2gIxaqyNGTmLMYLfs92YJUhYf2hOe2bH/4=;
 b=FNZIRa/UEwuGL7GwZI3YXnkH1dbOyMrHCW+BsMjyhgnx410ygrw9lSDViQzKPr0NZhNYdGIxAaC+qHTKV1sNIFuJH+kZTxbtHEHtkntgy/JRLMuyBl2lODMidga5SZjnsLR24nq6gsLeBTsms9UIAxWG8TB3PF4z+1m5Jkdl3XXoYH7Y+4N4lAItefrXayNWssfRBht7lhqbXdI0Wwtd9nTGEwNSwsnZtGCFtuuR85XURkZdS2J2ayJtL+Vofoyzvl1mYYYAzzJJWG2O/EuUR+SSW7+gT3/Jvop1bDNLPXVt/HdQpd8BGf130Zhvvdbpbl/QVHDA1T3yIZiQkVF8/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8455.namprd11.prod.outlook.com (2603:10b6:510:30d::11)
 by MW3PR11MB4586.namprd11.prod.outlook.com (2603:10b6:303:5e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Mon, 22 Jun
 2026 04:14:53 +0000
Received: from PH7PR11MB8455.namprd11.prod.outlook.com
 ([fe80::789c:dda1:63ec:6dbf]) by PH7PR11MB8455.namprd11.prod.outlook.com
 ([fe80::789c:dda1:63ec:6dbf%6]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 04:14:53 +0000
From: "Miao, Jun" <jun.miao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Du, Fan"
	<fan.du@intel.com>, "challvy.tee@gmail.com" <challvy.tee@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86/sgx: Periodically yield in EPC sanitization to
 unblock rcu_tasks GP
Thread-Topic: [PATCH] x86/sgx: Periodically yield in EPC sanitization to
 unblock rcu_tasks GP
Thread-Index: AQHc/wnTGEuWwn32EEC2us9Mr7TnMLZFRIEAgAS2e/A=
Date: Mon, 22 Jun 2026 04:14:52 +0000
Message-ID: <PH7PR11MB84552C8B5409350D85C94F259AEF2@PH7PR11MB8455.namprd11.prod.outlook.com>
References: <20260618100432.2280834-1-jun.miao@intel.com>
 <1bf5ef6fd45bbc241bbfdd3d0a4102f78000e7c2.camel@intel.com>
In-Reply-To: <1bf5ef6fd45bbc241bbfdd3d0a4102f78000e7c2.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8455:EE_|MW3PR11MB4586:EE_
x-ms-office365-filtering-correlation-id: b4c80537-a0cf-47d0-61ac-08ded014cf59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|56012099006|11063799006|6133799003|18002099003|22082099003|4143699003|38070700021;
x-microsoft-antispam-message-info: zT7XiCp0Gru83AEyR0RfO40llS+H/ePpyhNgjg8Z/pbJQBO/Sl7JJHU5hx3iWFod1eeLIKcSLtNelZglEvffUOAfAOJx0XdjCUDijFQ55Xvyd9iRt0VC18v+AgmzgaZDBnRyPu/u2HFcCRXrqqeyV09AhE9/QYS2Nz+WOH0gAoJZAT0cx94Y6YQEue6tpAG9kzn+jGtXrmz1IlA/airg7VNFGKgNH36isXk8rZ0tIc1QfA0D+X/YFZrNRteZlt6DboH1BMpjHACviVoPHvcGjpdFrWtGZDWdf3ExLL4lAbKgLSOc4osM0cSXO9bOqng8juaxDZAL/LKvUUvZ65s3n+dhle6FqSH4IdFlOYtwchZROI1f/BULGRuL+YKbx8/VJVbJoZS7JlNn69BD2oa1wZ9Tw+OqQ8dFxuVMIxXItlf1EjRDhNJ72q3j3Zd0akhd+ZXT04Y6G/R8PGD6TPokwTZWDLTAPPyuXSIiTkVr7+y6ylThQj7+8tymhhZFjFWKwBbUiBEqzMVAEZU8zY7BoSFyY4ajz5HMhjgdxNbZKBClK5mx2F3awbrtnzhK8bQz4l4meUHweM4bvfHF/f7eLSyZC+8hlmxIZ8LjvipS7N0RKNxafsE+k+AyIRxK9jtOFL4koqZAwdL6CpUd2LGFxJ9nJzR4QFj6HB50wnxvnIIzofm1yMwcNiOSs9ACHxtFdllK20FgyUGEhLL6/icwi6IswXfUxIJG6KIsySLVSi4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8455.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZElKRlEzcFF4TmJPRkJQNURoc1VDbXhVZDF1VkVaOUw0UWZ0RUpTemFZRzht?=
 =?utf-8?B?Q244V3NTcXZvQ1VoS3hqT1BYMjhJZVNsd3VUajJhUm5iVkdkQVNyNisxNVZl?=
 =?utf-8?B?VCt2SGJ5TlFSZENJaGJzYkhUeVFOdFpXVE01QlRiTkxqc3FMVVR2Z2NFaWNj?=
 =?utf-8?B?WVRuYm9VMnJ6bjZIUUpvc0VmbjRGTU5kd1YxOEpLOTVZbHh4VFJHdWx1ZHdu?=
 =?utf-8?B?cFpibmFiSUlxRU1MVGlqVE9WZFBiMjlUTFJST3cxenYwK1I5SmFXNi9sdEFa?=
 =?utf-8?B?Z25SNkdJTXcydlJzeGlqekczR243RzV5TUVtY2NaTldpV29CRklvNDdUT3ZL?=
 =?utf-8?B?eDFwNlY2MUdac1l2NGNJK2M0akhYUmJMT3lURWxGbXZDMXJCWlVjY0pCVHAx?=
 =?utf-8?B?YnZDNXk0RjVjdGtveVNlamswSGF2ZGFvMXA2b0M5LzMxRnR2alM5TGFTVXhG?=
 =?utf-8?B?YnhJZHc1Y2RTbWk3VTJISmdaUjhvS1Z5YTNYZjZjNTl5aElSYjJwQis5cVl2?=
 =?utf-8?B?RnlWWXVRNmZzOUd6SUQ4MHc0N0ZkLytCWGQzOUViUldXQjh6SFIzMnF2SEF0?=
 =?utf-8?B?WWR3N1ZnQm9jRTUzS0JQS0dEQWJqZ3ZpNVM5Q2c5d2E1bm53cTZCQ2RsOVpK?=
 =?utf-8?B?dW9yaW03aG1BeVpSWGNDUGtPS0V1eXFvUEJyenkrWk1MUlQ2YUVYOVZ2NHRj?=
 =?utf-8?B?SEtxbER3K2MvaFpld1pmZi9mKyt5YjBaRm5RVXgxWE1vVnArcjVJVGpnUjYr?=
 =?utf-8?B?NitJKzVicVVRVkNjTHlhYmc3RmkwRW1CMmZRN21Ga0pxeUdJaFRpaG1ldVdK?=
 =?utf-8?B?SnM3VXVrTnpDUmFsd3RuZHd3UUhDclRYN3dXTUZCcWYrM0Y1M1lzcXg3NCt5?=
 =?utf-8?B?M2JsWC9iYytwNHZjZk8wek1MdzIxRE9LNXlLN3NLTnpyTm95ZHdZQk5yMmZW?=
 =?utf-8?B?c1JGeEVtUGxwMjE3THdBV042bmV0bE5qU0lMMmpQdEk0WmtYL2kzazNVVkFv?=
 =?utf-8?B?SUdRSGlxbXliaFBGTUVYRGwrUS9SMU5VM2R6UXh5VytBbGVaclhRZGFTWFVx?=
 =?utf-8?B?NGlYRmZTLzMvMzBWTFdoSDRLTyszOWg3c0NEUHFOckhsZXJNVHI5aU1KaE9r?=
 =?utf-8?B?UERMd0RrdEl4S3lDSGlwMHpaUXpDQXZvSHhNSGlrZjBwaGROWHJndFNIN3h6?=
 =?utf-8?B?MTB2Mi8yU2JMOXQ4TTZnbkVyVDliVDBVS3dkVUNHU3NKRkwxT3gzQy95N2Qw?=
 =?utf-8?B?b1NaeEVsVmRwTWttczZsL2lEaExQblBQM05iWCtLSDArL2pOdXFYZWY5S2NQ?=
 =?utf-8?B?SjRmTnpLMmt4Mkx0NlNMVHRUaVRvZ3ltMUpmOEZoMng0LzFmbVovTUJ3am5x?=
 =?utf-8?B?eE9qTXNrWVQrUUIzckFHanE4R0hNQUZ1ckFORERKbGlSYTd2elZ4TXc0MFA3?=
 =?utf-8?B?QS92bm1PeHRZeU84RTR3OTZ4UDlNRlUzNGs4U1pkZnRqUHVCNkNwNitrc0dO?=
 =?utf-8?B?Tm5GT2gwQitjR1hKUFp5MFVXNFMrSWFKa3dtc0FkT2E1QVdNeGNBdG44ZE5S?=
 =?utf-8?B?U3VhR2lxR0V1TW5waUxKcGh4N3lDeDdKT1pWSHhtNnppaWZDYlVCWU5KcnJM?=
 =?utf-8?B?SDhVQVYyUmIvckpNaGNtRlI3UnptcnBXa2ZrWkNXNE9kSTJqQ0t4U241TlJS?=
 =?utf-8?B?dUpIZ3VtbzRCM0lCNDVUNVhtdjBFbk1MQVEwcU9BOXY3OUwvai9uMGhkQnAw?=
 =?utf-8?B?MlNrS1AxdkdYaWptUUtQb3pjcllwSks4OHVsNWx5Vjk0eEdReS9qYmhhN00v?=
 =?utf-8?B?U1MyeklkZnpsQWp0QW55Yi9HVno1UGl4bXZVK0RlYzFjdGw4L1kyVm1NZ0dw?=
 =?utf-8?B?aTZGMXU5QkY1azl3WjhpTnpXYk1FcGJlTVBFc1dKU0tGc3FsUVRtWmUzZC91?=
 =?utf-8?B?TDdqdEJLNGVVekd4TGsvd0ExSVpNQzZlLysrcE85QlZqRnUybTBMYjluZlVu?=
 =?utf-8?B?NU4yWDJiOUxoallYaTRKUXM0aEEzRHg5ai9tbVYyTmQxTUx1V1MyWkVNMklW?=
 =?utf-8?B?bnYzTTAwOGlpMXdiWFFEVUc4OTYxU3V6Vmg3ZjgvN2ZUdWEreTFnbFFRVjFp?=
 =?utf-8?B?bkZjT0tPdi91TStDeWxCdWxBVVp6MkwxVzI4VTFpcExzaVRSOFpWUTVGelZz?=
 =?utf-8?B?c1VEc0VIZU1FUThpMXhNemgreDRWYlJKMUx6WldvQ1dLUmpHZFdxYkpHTm5k?=
 =?utf-8?B?alVpMEdzNDZySTFJT1dWLzZmc1R2OURicm96MGp6ZG41eFhuaFZnYzVQNndD?=
 =?utf-8?Q?tEWGmODXK2Zq/mMoFd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: BiDcY7Yz3u7XuYd7Lamv14p3bN0YxPY0/Pb2HY7mJVSZczkBifunwLDhxwTO7EvCinVHWPyL4Fs+J6JpfUoncI6z+boPacAISnrYANlCKNAy0zHjLC7v3mWd+9JqIJ+PfAV2DySMIHGvVnZotqBX4oJfeXka1/gx7XiX7Qd33CAKgmmHWYk6n4M11X6ppHyftEEEKc7frN5VV7MmgqlcRr50tnQmIeSMp/c4sazKAgQZqHSRF4Fkcx7sTS5WQo+Xp9W3ocPBmMsMvpY+ZNP4civBzFANO1Ty2nuJlLHF3yLwIvNBRI8VGo/s76WnO7nH26+6wBJVS1fPUQnA6YKHbw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8455.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c80537-a0cf-47d0-61ac-08ded014cf59
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2026 04:14:52.9283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MAmOM9yRescJ8jsDTiWc/mGXkY37DeIEgraMsqliivcCm1elWkZUQVTsrMSQAQZ4WWvumFdiLySTlkQKZj7CXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4586
X-OriginatorOrg: intel.com

PlRoaXMgc2VlbXMgYSBjb21tb24gcHJvYmxlbSBhdCB0aGUgc2NoZWR1bGVyIGFuZCBSQ1UgbGF5
ZXIsIGJ1dCBub3Qgc3BlY2lmaWMgdG8NCj5TR1guICBJIG9yaWdpbmFsbHkgdGhvdWdodCBjb25k
X3Jlc2NoZWQoKSBzaG91bGQgYmUgYWJsZSB0byBoYW5kbGUgdGhpcywgYnV0IGFmdGVyDQo+cmVh
ZGluZyBzb21lIGhpc3RvcnkgaXQgaXMgbm90IHRoZSBjYXNlLg0KPg0KPklJVUMsIGNvbmRfcmVz
Y2hlZF90YXNrc19yY3VfcXMoKSB3YXMgc3BlY2lmaWNhbGx5IGludHJvZHVjZWQgdG8gdG8gYWRk
cmVzcyB0aGlzDQo+aXNzdWUuICBTZWUgYmRlNmMzYWE5OTMwICgicmN1OiBQcm92aWRlIGNvbmRf
cmVzY2hlZF9yY3VfcXMoKSB0byBmb3JjZSBxdWllc2NlbnQNCj5zdGF0ZXMgaW4gbG9uZyBsb29w
cyIpLg0KPg0KPkNvdWxkIHlvdSB0cnkgdGhpcyBzb2x1dGlvbj8NCg0KSGksIEthaQ0KVGhlIHJl
c3VsdCBpcyBlZmZlY3RpdmUsIGFuZCBJIHdpbGwgYWRvcHQgdGhpcyBtb3JlIGNvbW1vbiBtZXRo
b2QgeW91IHN1Z2dlc3RlZCBieSwgc3VibWl0IHRoZSB2MiB2ZXJzaW9uLg0KDQpUaGFua3MgQ2hh
bGx2eSBUZWUgZm9yIHZhbGlkYXRlIGl0IGFzIGZvbGxvdzoNCldlIGhhdmUgdGVzdGVkIHRoZSBz
dWdnZXN0ZWQgZml4IChyZXBsYWNpbmcgY29uZF9yZXNjaGVkKCkgd2l0aCBjb25kX3Jlc2NoZWRf
dGFza3NfcmN1X3FzKCkpIG9uIG91ciBwcm9kdWN0aW9uIGVudmlyb25tZW50IGFuZCBjYW4gY29u
ZmlybSBpdCByZXNvbHZlcyB0aGUgaXNzdWUuDQoNClRlc3QgZW52aXJvbm1lbnQ6DQotIEluc3Rh
bmNlIHR5cGU6IGVjcy5yOWl0LjE2eGxhcmdlIChTR1gtZW5hYmxlZCBjbG91ZCBWTSB3aXRoIGlz
b2xhdGVkIENQVXMpIG9uIEVDUw0KLSBLZXJuZWw6IDYuNi4xMDItY2JwLmdpdC43NzIxNTlkNWYu
YWxueDQueDg2XzY0IChQUkVFTVBUX0RZTkFNSUMpDQoNClJlc3VsdHM6DQotIEJlZm9yZSBmaXg6
IGJvb3QgdGltZSB+NTBzICh3aXRoIHJjdV90YXNrcyBncmFjZSBwZXJpb2Qgc3RhbGwpDQotIEFm
dGVyIGZpeDogIGJvb3QgdGltZSB+MTAuN3MgKHN5c3RlbWQtYW5hbHl6ZTogNzI0bXMga2VybmVs
ICsgMS41NzVzIGluaXRyZCArIDguNDgxcyB1c2Vyc3BhY2UgPSAxMC43ODJzKQ0KDQpgYGANCiMg
dW5hbWUgLWENCkxpbnV4IGlaYnAxY3A2M2cwN2t6YnA5M3V6cmhaIDYuNi4xMDItY2JwLmdpdC43
NzIxNTlkNWYuYWxueDQueDg2XzY0ICMxIFNNUCBQUkVFTVBUX0RZTkFNSUMgTW9uIEp1biAyMiAw
MzoxMDowNCBVVEMgMjAyNiB4ODZfNjQgeDg2XzY0IHg4Nl82NCBHTlUvTGludXgNCiMgZnJlZSAt
aA0KICAgICAgICAgICAgICAgdG90YWwgICAgICAgIHVzZWQgICAgICAgIGZyZWUgICAgICBzaGFy
ZWQgIGJ1ZmYvY2FjaGUgICBhdmFpbGFibGUNCk1lbTogICAgICAgICAgIDI0M0dpICAgICAgIDQu
NUdpICAgICAgIDIzOUdpICAgICAgIDIuM01pICAgICAgIDQ4MU1pICAgICAgIDIzOUdpDQpTd2Fw
OiAgICAgICAgICAgICAwQiAgICAgICAgICAwQiAgICAgICAgICAwQg0KIyBzeXN0ZW1kLWFuYWx5
emUgDQpTdGFydHVwIGZpbmlzaGVkIGluIDcyNG1zIChrZXJuZWwpICsgMS41NzVzIChpbml0cmQp
ICsgOC40ODFzICh1c2Vyc3BhY2UpID0gMTAuNzgycyANCm11bHRpLXVzZXIudGFyZ2V0IHJlYWNo
ZWQgYWZ0ZXIgMy45MzlzIGluIHVzZXJzcGFjZS4NCiMgc3lzdGVtZC1hbmFseXplIGJsYW1lIHwg
aGVhZA0KNS40MTZzIGtkdW1wLnNlcnZpY2UNCjIuNzQzcyBzeXMtZGV2aWNlcy1wY2kwMDAwOjAw
LTAwMDA6MDA6MDUuMC12aXJ0aW8xLW5ldC1ldGgwLmRldmljZQ0KMi43NDNzIHN5cy1zdWJzeXN0
ZW0tbmV0LWRldmljZXMtZXRoMC5kZXZpY2UNCjIuNTM0cyBzeXMtZGV2aWNlcy1wY2kwMDAwOjAw
LTAwMDA6MDA6MDMuMC12aXJ0aW8wLXZpcnRpb1x4MmRwb3J0cy12cG9ydDBwMS5kZXZpY2UNCjIu
NTM0cyBkZXYtdmlydGlvXHgyZHBvcnRzLW9yZy5xZW11Lmd1ZXN0X2FnZW50LjAuZGV2aWNlDQoy
LjUzNHMgZGV2LXZwb3J0MHAxLmRldmljZQ0KMi41MTJzIHN5cy1tb2R1bGUtY29uZmlnZnMuZGV2
aWNlDQoyLjUxMHMgZGV2LXR0eVMwLmRldmljZQ0KMi41MTBzIHN5cy1kZXZpY2VzLXBucDAtMDA6
MDAtdHR5LXR0eVMwLmRldmljZQ0KMi41MDlzIHN5cy1kZXZpY2VzLXBsYXRmb3JtLXNlcmlhbDgy
NTAtdHR5LXR0eVMxLmRldmljZQ0KIyBncmVwIC1vICdzZ3hbXiBdKicgL3Byb2MvY3B1aW5mbyB8
IHNvcnQgLXUNCnNneA0Kc2d4X2xjDQoNCiMgZG1lc2cgfCBncmVwIC1pIHNneA0KWyAgICAwLjM1
NTU0N10gc2d4OiBFUEMgc2VjdGlvbiAweDQwNDAwMDAwMDAtMHg3ZTNmZmZmZmZmDQoNCiMgbHMg
LWxhIC9kZXYvc2d4Kg0KY3J3LXJ3LS0tLSAxIHJvb3Qgc2d4ICAxMCwgMTI1IEp1biAyMiAxMToz
NiAvZGV2L3NneF9lbmNsYXZlDQpjcnctLS0tLS0tIDEgcm9vdCByb290IDEwLCAxMjYgSnVuIDIy
IDExOjM2IC9kZXYvc2d4X3Byb3Zpc2lvbg0KDQpXYXJtIHJlZ2FyZHMNCkp1biBNaWFvDQo=
