Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163722F0693;
	Wed, 13 Aug 2025 11:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755083300; cv=fail; b=ROV96DJe7jqjikmEysReU/po+SC0AuU/YBVYFMH3Jt3Gcw6u3+WWtbUgTT+yL397yjolYFIT2gbie4h/3wp9698zfJw6WN1enEAeWbHTK1MCfzTagahQ1NQEzpS0d0ZFrl31EuKYsZqQhzkszfCeAKweyqETFVMx09f+F/L1gP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755083300; c=relaxed/simple;
	bh=nunhn0xejNQt7kjr0bWQy5IOE3KJijXrk0CMGtI5ju4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mGvKzubi7YUz670lqzwHVsrA0TYHTQkAmETmvKI2Lhu98ZPQVOvdT59EuRTC334UK2do+M71c9ss7/XOK4aRC6Kme95qGGuRbDdHd1KedUTc+G5o3da1+97t6Z2aYp60muilz0NacJA6+HJVKT/l2vmR7p8N8t5njAneuMLBsuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lyb6DJXZ; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lyb6DJXZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755083299; x=1786619299;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nunhn0xejNQt7kjr0bWQy5IOE3KJijXrk0CMGtI5ju4=;
  b=lyb6DJXZiHnukEGrs0T0nR1s+1E9kJ7a/vYeyrp8Ju90pYar5FeMv/Bj
   pRuWq5c+oVCW20XKvBtCglYQeujWStY7tOHc/E3XPK2ftwyKa0jwvJrsA
   cRsDPwCdCe//g9cYFM1Nrs8SL1SAD0NH6TvJBEGN/WthoC+rnxKjjeI7k
   Hdsls0a2LscROof/vA6knfaqAZwTYVtmQh7KwBz2OLaI9NjSKHYPdqz/g
   9uBe9M0US7qD0vnoseYicniInevSvf0h5MiHuD8uEe9O19WXvu5lArPes
   IIDqy9x5gzWGJvVKoNLM+RGQaSOdqHgo4BFc2hMEW8Ny1SyMRa0ok/z51
   A==;
X-CSE-ConnectionGUID: Fc5ybJ4nQEGkBap2aESgFQ==
X-CSE-MsgGUID: 2SXSCLVXTcGfKCrSU8ypzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="74950319"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="74950319"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 04:08:17 -0700
X-CSE-ConnectionGUID: m/j6ot/gScaVXopKUpIzww==
X-CSE-MsgGUID: EkbBzMzbTEqhgToo9BDO9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="165628349"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 04:08:17 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 04:08:16 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 04:08:16 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.67)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 04:08:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F22YLrfaSPMgNiDKidE+9UQOZDBPvIcm5oiqJ6JjnxK6bh4aisAyd5RtAoAZSkjlducz8Era52Ha4WJ2oLOe4JCZHPnNuN5WKDucmpgIV9EA5D2Se+jbGsT9SnC0zNjGL1wbL8Utiq9kF8UNbTsKjKRGKVil2BIc1t4S8IiKELpKUN9icg8dguD7unkU8L4MZ94a6UZesIg47dynUIjc58vq91WJDuqwkDfk3JsXLN5TPMYfSdeejEAwA/GBA85gWGEu0L4ru9rBD5J+b7WnSpM67eSgbY7u8HWWR+Z63sw5s8Rf6RxvjZPxM5LsFxr9Igahrmg3O9Rxx6C5N794BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nunhn0xejNQt7kjr0bWQy5IOE3KJijXrk0CMGtI5ju4=;
 b=kf8KwH7U6Ia8Yf8VVxM2Ps7ue/dNs5KPpbOKS1Jlx1Hpf7j9BhCZqBb8uxa166Qlc18NO+qanasbP56vaG+u94pqEOBOjfcOmD6Ieb5cstMplFIhbs5HYNhFRDpQYAuXNzMAW4btMRiffWkQ40qCumS8ly1Uo4Oo5t4JOaSMflq4JuYPewdK1p1+DaQFMU52QbT8kSch0XtqkI/2eZ+jw9jUd28yWUU45K7OUz0fnmtFPM/0NklFuk6hU2MW8QQUNUBb7SlAmCIwrkvz3d0GuA0i51ZpZG4UW1Z438ZSAee8L0MW275c+fdqCbwP+1HSG1m8SQRhzXV/KMVwcuv3Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB7765.namprd11.prod.outlook.com (2603:10b6:8:130::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Wed, 13 Aug
 2025 11:07:55 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Wed, 13 Aug 2025
 11:07:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v13 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v13 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcDC+/MsQJyZQteUGFkEpaqpnf4rRgbKYA
Date: Wed, 13 Aug 2025 11:07:55 +0000
Message-ID: <c4fd656e3abc77a9bc0c04aef3e6354fdc40b8bd.camel@intel.com>
References: <20250813085233.1369036-1-elena.reshetova@intel.com>
	 <20250813085233.1369036-6-elena.reshetova@intel.com>
In-Reply-To: <20250813085233.1369036-6-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB7765:EE_
x-ms-office365-filtering-correlation-id: 61d3812c-9881-4a76-6dbd-08ddda59a7cc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U1kyRnhlY0FSV0ViNnZQRnFsYy9ZemZ0cDNadEd2NVFnTFRXckdjVUYrcFoy?=
 =?utf-8?B?NlpOaVpEK0FsU0hUd0YxdG5peHM2N3plcnkySkhPOWVJbC9ReUdXYUFNMFdq?=
 =?utf-8?B?UXhYaDJrbkkxNVNHaWw3L0dBTVhaU3UzdjRDWG5mcFdkTEZUaThsRGJvVzNU?=
 =?utf-8?B?di9qZ3c0TFZ3S1RidFNxRVhoR0xVcXZJb05lOGtDS2FmVVU3em5OYk94OVJV?=
 =?utf-8?B?eGphUGtvWXdLTkxCVlh1RUM0Z241WlJ5V243aFk2a1JJbGMwUDFiaE1EYzla?=
 =?utf-8?B?MitpcXBFZFZDNkpWWmtiSXkydzF6bHBpdUVVcmd6ZDhwekJpaVpmTTRSOFF3?=
 =?utf-8?B?anp0NEg1aDA2Y3ZWbFpNeWNjNDl0RWQ5bUcwRG9ySFZtZU5EMjdSc1RyUldX?=
 =?utf-8?B?Q1ZTendaVGoxSXFtUkNlTzlQTjZFdnRzSXBzUFpraFFIL0dQaHVYb2FMR3Ez?=
 =?utf-8?B?VC8rRVphMFMrdWhnbDdRYXpxZ3Q0Mkg5eERqMTRPS29hQU5vbmhVR0ptTmpm?=
 =?utf-8?B?eU5WQUNnWHMzUmFsb2VHWlB6UXdDc2p4bHUwczJlZGlqRjBERjB0bExaVjd1?=
 =?utf-8?B?cDdkMXp4Rk44NEU2VmVSa0ZybjFpQzI3aEFtVWsrQVF3TTV3WVo0bG5JSU5J?=
 =?utf-8?B?aVZTVHU4R0ptRlZ3U3dlUGRGZldWcnE5Q0kvU05Sa0JxQTJyZUtoVlc3ZzdV?=
 =?utf-8?B?VHJJcEhEbnVjamdrUWcxemJzSnVBQ1ZVSGpKOTdVOExrTVB6bHZRNHBCZlFh?=
 =?utf-8?B?WEVKbGtjZGNSN0lMZjdab21HdGNneWZpQVRwbERNejQxVmlQajR0VUEvTS90?=
 =?utf-8?B?eWd1Wk5yOTVhL04welNEOFltYWRLZFMrWGJtM0U4c0ZjUUVlTmVvTHBxc05h?=
 =?utf-8?B?K0FHc0F0T2NVTWU5M0gzN2VCVDNMSCs4UjFaZThZWDJTNkNVK1F5RHZtTDli?=
 =?utf-8?B?Yy9UZEdWTDlwS25yaDBOdGtHY3VXYUFGK1Z6MHJlOHlSYWhkNlNDUFh0V0la?=
 =?utf-8?B?ZDlGQXd1WFY2bDFYNy9RTzhEa1BDMTN6TUtXZzdsbUVEckZxSnBJYUs1dnhG?=
 =?utf-8?B?WUxZdFNrN2FJWG1UVmxBNUtra294ZkI2eU81Zzl3dUtpQ3Zza0luM2lnVWNM?=
 =?utf-8?B?OUJXRmRPNW5vZHQ0T1ZFZDlWa0lKb1E4U3FQM2ljS05ZS2djVlkxdkQ3dFA0?=
 =?utf-8?B?R2F3amhSNXJhM3JzWnhER05POU1FYjZsbHRpM2ZKdmt0QjFUWHJ4T0diNDdo?=
 =?utf-8?B?cTRiT2tsV0xPNXhNcHI0dXZGWUlpZEQ1bWw2T1gwek1oL0p5eWg2YnlIU2N6?=
 =?utf-8?B?a21ROG5RR0dTbWphamZITkRRSTZiVTNPQmc2Vkk5N01EOWc5Zm5mTTVaZi9G?=
 =?utf-8?B?TjZkSDNDcFFURmZ0Um5sNFRwNUxlRTROaUJrL1FNcktLYmVxbVVoc3EyUnJw?=
 =?utf-8?B?UUdMdlFpNTIzWGdCVjQyYTE5SmlrSHJNOFhObzk5eWZGNys5M3F0L2thYUVN?=
 =?utf-8?B?SjQ2eXBOQXJWQk1EbHhaYTF3cnZkODVtZnh0M1J6Z3YwMzQvZGlnekxLUDM1?=
 =?utf-8?B?MlJ0TXYrSlcwbmhraGxBNU1DRU1zTkp4WmF6TVBxaStWNmpETDlxRUYwbmwy?=
 =?utf-8?B?SUJMTkdVVDUxMTRDRlJXUWsrRUU3K3FXNzdhZzRyT3VTMk16L0hTUmtZNFdF?=
 =?utf-8?B?YlpFMUJTQlNhM2VYUjU1cy8vVm1DUlYxWjZmczJHaDZCclVQUUtjUm5Fa3pG?=
 =?utf-8?B?TmhaYTRxemNmNFc4SUptY011SUV3cjBvVEtDcUVhYzVtNVd3WFBCdUZLRUxs?=
 =?utf-8?B?bEZvME1ENjh3UER2SWlhT0tjQlhzTGg0THYvUlJrb2pFcGlhY2dsQWJESjJF?=
 =?utf-8?B?dmZNK1paVjBXdS9RR3pqM0UvTlEyQkhvOThLUTNZOXJtc0MrQ0JQUHNOajAz?=
 =?utf-8?B?eHBsVVZwVG5pcWdzbjZnMUxxUUVJYmlrV3BuSVdNcFVlcVJHUnphNXJCVDdU?=
 =?utf-8?B?L3o5eFREUUdBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TURwL2RPc2txUWFhQUlrQlpsQ3MydzhuSTI3Q3hhY3ZOY1BFV3V0VHpLaHUv?=
 =?utf-8?B?TVQ4LzRIV0dkWHhHekRvWFBHV2F6QjBiWVlzdHBtNmtBWlFuWTIzL2F0Q21J?=
 =?utf-8?B?NmJaU2E2ZXhsTk9GRnZ1aTNZSGwyZmM5clgrN0sra2dFSk41MVhLWWZ1STFP?=
 =?utf-8?B?RnY5ck5COGdrekJCNTNVdS9hWEZKbllLN0x5eFNmZUh4T1dta2hGemlsUjl6?=
 =?utf-8?B?SUlTYzNWLzFOR2c2N0UzUGlML1NGMzMwNVdJWk14QTBBM1JjQ2ZwUE9KYWl0?=
 =?utf-8?B?Ris3L3UvdGFDYWt5TWgrSHowZ2Q4bjNVek1vbkc4UVV0S1AvTFFiVWRtTmFF?=
 =?utf-8?B?cU5HTGl3UEhIUG81ZG85eDc0dUtZNTc3RmZYUG9ucElHWkd6bWJGbG9QS0Vw?=
 =?utf-8?B?dnRDL3NZaGR5WktpdFpieGtVV2pzbU5YblBsOWN2N2hBdnRNTHc1VlBYMnh0?=
 =?utf-8?B?MjVNckR3RHk5UXlBbmdBVG94WTB6ZWZDbW9uVDc5NWZqZlNHNUdFVHY1TGFE?=
 =?utf-8?B?cUJWSUNYN3FnMGtIYnBjTUxCWFVmbnhpdjNiYi9jeHZKdGVjZTBZcHR0aDYv?=
 =?utf-8?B?SnRYNUtXSSs2WWhIZUJiY2diSzRFVjQ4bTMyMUd1WFZRR3Z1c2QrVXluVXJB?=
 =?utf-8?B?NENYTC8wSnJWOXhxQnNucGk2VmtBcE5xb2NZemlxWWhkdTJxNzkxaGFCc1Fm?=
 =?utf-8?B?czAwUTdjZUxnOU9lTk9MTjRCQkFtNWxvK2UxU1pxMUtLZjJtLzNQajRXdUZr?=
 =?utf-8?B?WU51MjkxWHhGRUpnVkZGU2RDZ2xRR0piMEcrMzhCRWRhU0VmUVJvdTJUR2ZU?=
 =?utf-8?B?bUhHK21JczVZc2VTNGFrZXVrckg5RUROei9ra3lWSWdQdmFCUHg4Y3poclV0?=
 =?utf-8?B?YU5PWDZJWTFLc0VSUDRQMHRXbnorbXZQUnBKSDFHWlRyQVgrTmdJMUdBT0l2?=
 =?utf-8?B?dk5DRDZYK25IN1UwTjRTRC8zaWpwdm9tK1lrd29BUHhzdVR5VUNoQzQ5QTVV?=
 =?utf-8?B?SkhSNWVHVGlXdE8vTklxV3JGTm42TEl5WHB2Zm80dGVCUEkzOVpJbkQ5aDRm?=
 =?utf-8?B?UUFqQ1NaVEJKbjZMTWU5NFdtUmt6eThoQnpRWFBWM0Z3Nm9BclM1enkzN2Rs?=
 =?utf-8?B?cGRsSm5PWTBSdHo5d1pSdU94ZCtMVjV4RlRKUlZCUFFJTXd6OTVwSFpKNEcv?=
 =?utf-8?B?WmwzNlZlTmhFY2QzU21nTkJqSUljM3dpYXpTVGlNWGlxU3k3U1lIYnd5bG1t?=
 =?utf-8?B?V01RSzR2S2NzV1JTTVgwakVlTUNISHRNVEU1K1NNWDNGdWZWQkI3UXROb0FY?=
 =?utf-8?B?ajhzK1FyQkJXalJINEhlSkNObVJ1YXhaRTg0clF6c001SHI2TzdjRk1PVWpz?=
 =?utf-8?B?UmFtUmZUREo4WGZWenJRc2JhWkZCa1FWMjVHRVRGY2lzbXhLZUp1MVNIcDgx?=
 =?utf-8?B?TEhreEEwVDVxZmllSXhwdXFUMjVpemV3M3B4OE5NWkhsYkZZeDFqSlJSalp3?=
 =?utf-8?B?cSthUkcxZ2VaV1ZMMHlydFB6QVRmeEtuNmduOTZkNER2ZVZqVm9zQTJXbUdN?=
 =?utf-8?B?dDNYNXZsY0F4c0s2S0RaZzY5amFCNTZZZ2FlWmUyRVdDZGtyUEFPYml2YU4w?=
 =?utf-8?B?dlYwU1lWUFY3cWV3aHpOL1JnUHlscVVUQUtwR3h0RlBiUkZXazArNVVlejBO?=
 =?utf-8?B?U1VoR1Y1c3VMc1RuazVLNGpKckVsZGo3WUF6c1FINnV3dFlsWitERG9yWksr?=
 =?utf-8?B?VnFDVHRiaGtUM1V4dUFDVlRNTHIyeHc1THQwR0JBUzBjd1ZMVm0yTHhSZHA3?=
 =?utf-8?B?RmlZK0UvT3MvaVpxdmp5NGtiOW5VcEc3Y0J6ZjRJR0hyY01pRm1EKzdMNk1x?=
 =?utf-8?B?eGNmMkRZQ1JtUDJ3Z0N3VEQxTzFIS2ZQZFZrNmM0QTBUZVI4dTlOZjZONkpQ?=
 =?utf-8?B?bmpsNnRNbTcrTFpZRGtaZlFvakY3YzRZV1h4cmE4bGdpRmpHUWhheXFjaW9i?=
 =?utf-8?B?V2RhSnlmaFhNbmVSK1lEMWQvcUJVcCtoamRRc0MzZXVIRWNENU55RFg3RWJX?=
 =?utf-8?B?Z3g5YWFtMXd5ekJXVUFCNWhFRGpkZy9aVmxWb2RLTG5rL1NHSk9sN3ZHa3pE?=
 =?utf-8?Q?JnEwiqAk7eu74gt0zta9LE3HT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA055F829FC55D47AD49801DFC594DEA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61d3812c-9881-4a76-6dbd-08ddda59a7cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2025 11:07:55.8524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1EEs9VX/h8neinZ2+ubsGrrd1I32cnouTfQD7bMRmWgk4vttxzYGvCArtqjklJlhpgU1hshiU4jmwzMeeHlRhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7765
X-OriginatorOrg: intel.com

PiANCj4gTm90ZTogd2hpbGUgaW4gc3VjaCBjYXNlcyB0aGUgdW5kZXJseWluZyBjcnlwdG8gYXNz
ZXRzIGFyZSByZWdlbnJhdGVkLCBpdA0KCQkJCQkJCSAgICAgXg0KCQkJCQkJCSAgICAgcmVnZW5l
cmF0ZWQNCg0KDQpbLi4uXQ0KDQo+ICsvKiBNdXRleCB0byBlbnN1cmUgbm8gY29uY3VycmVudCBF
UEMgYWNjZXNzZXMgZHVyaW5nIEVVUERBVEVTVk4gKi8NCj4gK3N0YXRpYyBERUZJTkVfTVVURVgo
c2d4X3N2bl9sb2NrKTsNCj4gKw0KPiAgaW50IHNneF9pbmNfdXNhZ2VfY291bnQodm9pZCkNCj4g
IHsNCj4gKwlpbnQgcmV0Ow0KPiArDQo+ICsJZ3VhcmQobXV0ZXgpKCZzZ3hfc3ZuX2xvY2spOw0K
PiArDQo+ICsJaWYgKHNneF91c2FnZV9jb3VudCsrID09IDApIHsNCj4gKwkJcmV0ID0gc2d4X3Vw
ZGF0ZV9zdm4oKTsNCj4gKwkJaWYgKHJldCkNCj4gKwkJCXNneF91c2FnZV9jb3VudC0tOw0KPiAr
CQlyZXR1cm4gcmV0Ow0KPiArCX0NCj4gKw0KDQpUbyBtZSwgSSB3b3VsZCBwcmVmZXI6DQoNCmlu
dCBzZ3hfaW5jX3VzYWdlX2NvdW50KHZvaWQpDQp7DQoJZ3VhcmQobXV0ZXgpKCZzZ3hfc3ZuX2xv
Y2spOw0KDQoJaWYgKCFzZ3hfdXNhZ2VfY291bnQpIHsNCgkJaW50IHJldCA9IHNneF91cGRhdGVf
c3ZuKCk7DQoJCWlmIChyZXQpDQoJCQlyZXR1cm4gcmV0Ow0KCX0NCg0KCXNneF91c2FnZV9jb3Vu
dCsrOw0KDQoJcmV0dXJuIDA7DQp9DQo=
