Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFA68BE5;
	Fri, 23 May 2025 00:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747958957; cv=fail; b=rIgzdnCJJdeuSVjR4aRqX9Cu+58ZV4tj3xZkdrcIQS2uJeFvRiyd1es3jppkCADmLd3zZX6GJBshiN8X/oXwji0V4HYhfyluMlRucraW9RGE6jfGASoVlOLox9uB2xr16L97H+TvG7IYyZL2P/ZsZk8p1mwyziwinHtkCWYrBrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747958957; c=relaxed/simple;
	bh=ENuBpbms4dB743P0+ImnIUZdVxUHVqmwZ6nT+d/hbzM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NzC9zKtkxihcXEAmso4woJT4hl2hUO5cHLEnPf28lUStnPX/U2PHb6Vt4zbYUkZFyKIkJUvKGKAwyI0S/iTiBAws5WxDrQnvKYMtoZl9luVGPrV63Umd4SzMyQ4qUphneB1Z5Kh8KoJNA/2IDBZOgmIMxxCAuiQbjIXnw5J9tsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S+I12IV6; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S+I12IV6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747958955; x=1779494955;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ENuBpbms4dB743P0+ImnIUZdVxUHVqmwZ6nT+d/hbzM=;
  b=S+I12IV6YKkToRKRwP0hVu6rcLW5eIKFVWWtzLt1MRbUKmU8HstZfMLD
   BQv7pym8iUPEzCyJDZdZypXJ5qWh6DL/V8Tu//m54H6lgzCFh7QLaHRN9
   j7FvMdczbcrlnbOW7VLl1VSs5NyTQ4DYYciVEJ4XE7jcJ/ZmekPfSJJ/G
   c5TYZxRIRiX25KoDWhV3k5cQRZTmwoRmqoTpWZEIFF1WPHKKZ0Id1NKs/
   4zkco08R7GMB1ovPqYzqP9sGemONjIAakibHo7GWh2VMsQHfufhblSG2C
   5FxRdZ4DGct3VNf8FB3PusChLF6ZiwVw/NpK1cM3XRg7JdyNzDfpZ5sk+
   g==;
X-CSE-ConnectionGUID: pbbcnRKtSz6EuhWU41v6Kw==
X-CSE-MsgGUID: rWDIntWxRH+l57yGs1nqmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="49928556"
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="49928556"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 17:09:11 -0700
X-CSE-ConnectionGUID: 5miMU9OeRMKpaRiakDl5dg==
X-CSE-MsgGUID: HbtYvNvoRuSIkBlmiCu3Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="177971320"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 17:09:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 17:09:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 17:09:11 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.52)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 17:09:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HTcl5TXepc6XsvZBILjFDSYwBe4c/VKgkKZgAUp4cxe8fjTgsqZsMmKF68dGG0POnJfTNvKd5F2HSBn8o01zpo8N+CKcW6RdA2ze8yChNfajNsmJc0RbOGBq1KxGOyx8+W1R71rNeZr6RVTtksrkOVWjsr/7Odq+uHcuXokX1N2x8awRnj48q96SpG81GpV9d0g9Sbb6lmVuK8c7B0Zo2vEsb29EMYQUfSygt2po2nNcXhjJWMtw+1ynJF8dYAUiJlRh6OwiZfZ+xpuXsEvwQTv5/4Kx/7nmsUKzza4ztj3Dcq44TVcyya1K76YfU9ghTCdkD25oJXrLtZPgw1e9IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ENuBpbms4dB743P0+ImnIUZdVxUHVqmwZ6nT+d/hbzM=;
 b=QoTJf6veC7/B4ocdymTKJJ+hgbQsuEHeaennNc+wJaRwRwu37oOI63CHwVj7dnaUowXMWoDFtS5JMAKM2zKd9Kcp+2PB0t2mSlzdtBTUSLFWqPfpLC4Omzv+FHfqH6pnofxBPdd+gpkBTHjAhQtGN9P2+d5gSBaZGaeaw9l/R5FkDXiM6xJ6U0pfBui6Ltcl2qVDQ/yhGoT94GI/diMCGTC42UambecjRinJi6HeWD/AosP2K17oLzWPKMMWwSc24kAWAQUfKAt8FxJH5XhGUWheQuxJUkWIlqI8U67jZ7bF9iehbHa3ThtG2bCYPCioYOi3ee31ztYF+Uf52MzrzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB5996.namprd11.prod.outlook.com (2603:10b6:8:5f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.20; Fri, 23 May
 2025 00:08:37 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8769.021; Fri, 23 May 2025
 00:08:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "mingo@kernel.org" <mingo@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: Re: [PATCH v6 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v6 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHbyvst4f6SwnwsaEC7y2uGTTwB8rPfV6wA
Date: Fri, 23 May 2025 00:08:37 +0000
Message-ID: <5f952f793473bb0685c3315b1d93f7ae42c4a2a4.camel@intel.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
	 <20250522092237.7895-5-elena.reshetova@intel.com>
In-Reply-To: <20250522092237.7895-5-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB5996:EE_
x-ms-office365-filtering-correlation-id: c1b7550a-84e8-4cce-5784-08dd998df727
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cDA3OTI5UnNrbEpNS01VY1ljWWZUcnlaZlZIaFBqdjJwNHloZDJtS01yRVZS?=
 =?utf-8?B?RUxUcTFINGc5bDFzWHZ2L1ZjK2QzQ0JPRFZNMlNaZlNKNUtBaitYdjhSQTVS?=
 =?utf-8?B?NjJHN1VNRWJCSFU2UDkvQmNoQ0g4WGVMYzB5Y2tWTmd4Mzl5VHBGWkdSeFNi?=
 =?utf-8?B?amZPdnVSdjA3S3VpV25ENmNSVkJPL2cwV1dzTkdBbU91R3ZPS0Q5S2JuN1Ju?=
 =?utf-8?B?ZXVPZWNJb2FIVC9CeWpaRFZiRXh4dGpLRkJHTW9VUGJaYWQ1eE5kRnpzdkVp?=
 =?utf-8?B?K21sYjM3VFV1Rnk1UFd1dy9EM3FLY09ETkZhTUVtbCtrR2NMaVNoRUthMllK?=
 =?utf-8?B?UGNpaTRDWW5abkV2Mnc4aE1aWUxuZFNRN2FkNXdsZkppQklVN3VxYldYV0gy?=
 =?utf-8?B?RE94dnQ0dEthaE9HYWczODJCQUJDa1lvWnJIbEhQNmNjOFpKZ3YreDJjQ1ZO?=
 =?utf-8?B?NUNsd2tTQVJuejg3UU5SenEycElSVnY3d3hCVWVIRHZQWHVRdzdCSjRMY2Ix?=
 =?utf-8?B?SFJ6WndsVlhjVExOWGlWZzdBMWVJcTdWS1B0dzVFUzBxOVJBbEwyemlOMEQy?=
 =?utf-8?B?SW02aUM1R0c3cm9BSHJQaSsxNFBxMWQwWkhjUEJMaGQ0M1FxOW1KNXJyV2FF?=
 =?utf-8?B?Z084ZWsrWjh1ZWl6Wi83UEpjWU45UUQyQVRiY2p2SlZOSlhMc1FFMUpGWUsz?=
 =?utf-8?B?SHZHemIxeVVDN1B1bVArTEZRRlZZNFNZZ3hvZ1U5bE5FNTIvL2N5b3l1MmlP?=
 =?utf-8?B?WWdhK3gydnpyRFB6Ujc5UTlpYnFmTDducmpRS3ZkbE1hcnQ0Uk9xdzZPb0ZY?=
 =?utf-8?B?MytuUTBVMEtZbjd1TUo2YVE4ZDVTMENOZ0NoeW1kci9DMEF3aHVTTjg5VllJ?=
 =?utf-8?B?cTAvenJMd3RwOXYwc0lLZEMzQjljN3k2empzczNZR015SlFyRjg1eDhEcmFW?=
 =?utf-8?B?ZXEzMVF0dWxoK3JjUm13TENLbnBsUkFYUWdZaUFWc0xra3lNLzMxU014TzRl?=
 =?utf-8?B?bTl2NEVKQ2N6VWxXdjRBUEd2djJoQXdTTUM5MXl2aWl2b2dnaWxHQ3pxcTVG?=
 =?utf-8?B?TkpGMFo5Ti9pZDFiT3dDQzI0RXNHdUh1UHlKQ1JreHJuQXZFbDcyU1FWUXdW?=
 =?utf-8?B?bUFNeFE3MWRSbW9VMzdSTGVmMHp4MzhxM3AvTEtNNXZQQTZtakhEZnlkSWll?=
 =?utf-8?B?ciszMkZvK2xlYTZkbW8wR0xmVlBtUTlTbEJqUW82dExvbzY3TDdCMlk4RVBF?=
 =?utf-8?B?L0pkL25wWHNJb3J1c0tvOFhDNGJNOEJwNnRVOUZCZjJRWjJpTEdiQlVBcEND?=
 =?utf-8?B?QWN3QXZKZWswTEFqNi8xcDhHNzBJSDhPWXRFdVQzdUpxVGlOWm4rR2twR29l?=
 =?utf-8?B?aExJUjVqdDd3NGp4eURQaXhxeHlraDE3TldXMXd0djVvbXNVcHNZb1NMZWFU?=
 =?utf-8?B?eSs0dHlNZW9pYnZqVUl0U1VTVVpmUWhBTEptQ2hWZHMzVnBBSWRNMmdlQTBF?=
 =?utf-8?B?bmdYdmRrVzZIVklLMFhiUkxHUVV0ZWlVS2s2MHdRenBmOVBYSktrZHczV1B0?=
 =?utf-8?B?YlM0akxXUTdYSG0wWTVTZ2ZhSzRmSE9nWU9vUXlhakZUL3d0U0pkZVBpRERl?=
 =?utf-8?B?dGhBMWxWSmVDWUdvRUYvVjFPT0VJMEJ5SktsS2JLY1NvZXEwNWxOYVVtTjRW?=
 =?utf-8?B?TlVZeUZLY1dsVnZ2Nkl6MFdoZU1IeU12YS8rb3gxZktreFQ1SzFtR1krS3Uy?=
 =?utf-8?B?M01JSzY5TE9YZTM1aXNwUWxFaWk2cEY2R2d0Q1NkdEk0eG0vRS96YmYzMVh1?=
 =?utf-8?B?VlVUSnVXVHhRdCszdEJGeS9aaElaN2E1NGRtNCtXcnlsTGZBRDZ1S1Bua2xC?=
 =?utf-8?B?RTNpM1ZqTTlqYkhVZlNOSVVMTWFBdWhQQzR6djNPUTEwZlpjZmw0aTBrUThF?=
 =?utf-8?B?VC8zY25LZ3BZUVVLNDd5WVg4akUzQXJKcElxa2JMdHB1clR0V1VSTzJDR3hp?=
 =?utf-8?B?Yld1VFdldStnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFlKdWdtZVJadmxjRFllbVhmTlYrV1lRYXJzV0k0SmNLSXZ1T0txU05Kak9n?=
 =?utf-8?B?eGpkR2g0eFNKV0poelZqZThncHVsRVhYRGJPK3QyU0lkWkVpVWg3bHh5V0kv?=
 =?utf-8?B?RDA1Q2IxbzdDQzNhUnR1MWt4NWpRM2NPZ0xKeHhYZUszbXczaURmRUkvajlU?=
 =?utf-8?B?V0hRdjNNa2I0ckcvT2RGZVhndHRKVWJjZ0Fqd3ZYMUJuVU83K2ZtWm9Yamdi?=
 =?utf-8?B?eXBxTkx5UFBxYUtpcWU5K0NtWEJxRzJ5RDBSdlpXempCYWNPUm5UOFBJVjNH?=
 =?utf-8?B?QTYwYWxHTVZWWUQvKy85QU1lWS9tNm9VTjhGV0xKRm5iakMyV3ZrN0RLQjlx?=
 =?utf-8?B?dVphQmp3dzZWRXVUVjJOODgwQ1dNNytsSjQwNVk0WE5SVUIrcFVpWjArYjF6?=
 =?utf-8?B?dzV1TlJNaDBBS25CVjBZbitoU2VEOGNPY3hHVjkxbU1iWGxXcTVPSGVNOUw4?=
 =?utf-8?B?aEE3aStGMnVEMWxNcm5JWjI3TWQ2R0kzNU9venI1dmVZTGZmMVhJUGo5bDcz?=
 =?utf-8?B?SkM0ZjBnUTFKR3NpK2hpbGlkNzRyWEdOQUIrQnlxM1Fha2dPNFZ0cldhUSsv?=
 =?utf-8?B?M2p0VmlyVi80YlNlM2U2YVI3UzJvWTlBVHYvZGdhcklNKzRWbnlFWmw2TGE3?=
 =?utf-8?B?VE9YM3E4WjQzNlJ2VmVTMEJyMjVpUmp4bnNQbVJES25BZWdkc28vckFIdVVO?=
 =?utf-8?B?ZytuVVRUdTc0UDNaUXYwdWxJdFNRRDJoWUhtTSs4QXMzLzUzOGJycG52Tk1B?=
 =?utf-8?B?czU1UllFMGtrd0xDeVpyaHBrTXVlZ3Q5aW5jd1FYcFQwdU15eWxIa2RHTy9u?=
 =?utf-8?B?SkZQVEtXU0c1WG5ucUU1RkI2QUdlclF6MDJFcFplelhlUURmWGRsYzFMcmlK?=
 =?utf-8?B?dUtUUzU0Q2NqbkRwSHFFcnVrMFpacms1cW9WYW95ci9RT0FrQjVDL0R6YWVC?=
 =?utf-8?B?VS9KQXh6eUFJZzJzMHM0VjBnUDQwdm04Mk82QjczOHJkV1d1aEliL1M5d2tM?=
 =?utf-8?B?cjV5a3BqdmVCYnM4SHBMN1hvRTFjOUF5UzNpT1J5SC9iUllHU3JWTDlyM09P?=
 =?utf-8?B?cWZpV1MydEN1TExBeTQ3UG5jeG1nODhjKzYyU3JvTSthbDYwS1gvNjVJYTZK?=
 =?utf-8?B?bmVVNDNIdnQreDY1UXgvM0RadnVia1puQ0Y4bEVEb0Y3Ykp0ZkN1VG9nZ0Zt?=
 =?utf-8?B?Y0hDWW81S3g1aWJpYnFjNTA0R01wc01WVUdXM0h5ZnRSYUNWaDdpR0FrSWp2?=
 =?utf-8?B?OFRKOVZCdXZsMEtXV1kvaThxSWFGVytBcUNJeVNmeHgzRjdLT1ZZdFJOYjRH?=
 =?utf-8?B?MGdDdktybk5PWFBXcHRMYzE4NXY0c01xUVIwUm5TR0I3dkMyZjlGNXJsbUo1?=
 =?utf-8?B?eCtET0Y0aGt1V2x1RCtaR3BQdWN2N2x6RVdaaDRVb0tMNVZ5ZTR2eUJaVks5?=
 =?utf-8?B?Wm56c3NZTnpqTnNsL2ZENDMzQzZlYzZLRVB1djZEaHVwbU5hRlREVzhZeWNL?=
 =?utf-8?B?V3N6U1RvYXYvSFRrcW52ejFFcTJZL2xxWVZpMVRtdTNSTnVHeEplVXJqQXhv?=
 =?utf-8?B?WXdyMlEzUFl2QXd2aWU0bW9UUlBHL2g5d0hvL3JQNlZnSG8zZWxONEJ4azU0?=
 =?utf-8?B?cXNxWk9ZYUxMdE50UWZyQ0lTQklIZklpd3Bldm16Y2laM3c3dmNncDFmM1pD?=
 =?utf-8?B?Y2dqR2ZERUVYbWt3QmxRcTJUT2tlN3cxYW5KanNoclVXRFQ5bTFMSjZWdnAr?=
 =?utf-8?B?SjU2RjJjSEovWkN1NjJHUTUrMWtmNnQwb1lNeHFWR1ova3VuaHltVDJVK3lm?=
 =?utf-8?B?MGc0b3RMdTRVNmJ5YXhKZTBlcGFhaEpESFEwL2JvOWFtVDFPZWVjY1NSVUtH?=
 =?utf-8?B?YnEvS1lHYk5VdTlycVNxRTVGVUlQcWIvVlRqdzkvU2pUOHFMZEo5OW00Qjgv?=
 =?utf-8?B?REZhWlNsZjhTTENBTWlacmwrSFRRUUVWTDYzajZrUzBnL0NISTNpVHJjaXFM?=
 =?utf-8?B?Umw0V2o0QjVXTXV0TVFpanBLK0NVS0QvaTQ4eVdJVmZPQjBtU2dydmkxbHk4?=
 =?utf-8?B?Snp1eVUvUWR3aEdCMm41ZExTQkhyWUxUL3Bmd1ByL25DUER0SHFDQ3VuTDNM?=
 =?utf-8?Q?WYNake6rsX5LNSdAZ9m5rY8rq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E60530AFF1894447BEC2156ABEBAA8D9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1b7550a-84e8-4cce-5784-08dd998df727
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2025 00:08:37.2134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4VGejAAZ3DFb32gI22PFFm+w4KrN+L+Gt/nILyzUjdJ6pSM+9diWeUm5IPa6eJWqgty+zuj+fKEwPvMJn6XFJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5996
X-OriginatorOrg: intel.com

DQo+ICANCj4gKy8qKg0KPiArICogc2d4X3VwZGF0ZXN2bigpIC0gQXR0ZW1wdCB0byBjYWxsIEVO
Q0xTW0VVUERBVEVTVk5dLg0KDQpzZ3hfdXBkYXRlc3ZuKCkgLT4gc2d4X3VwZGF0ZV9zdm4oKToN
Cg0KYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jOjk0MTogd2FybmluZzogZXhwZWN0aW5n
IHByb3RvdHlwZSBmb3INCnNneF91cGRhdGVzdm4oKS4gUHJvdG90eXBlIHdhcyBmb3Igc2d4X3Vw
ZGF0ZV9zdm4oKSBpbnN0ZWFkDQoNCg0KPiArICogVGhpcyBpbnN0cnVjdGlvbiBhdHRlbXB0cyB0
byB1cGRhdGUgQ1BVU1ZOIHRvIHRoZQ0KPiArICogY3VycmVudGx5IGxvYWRlZCBtaWNyb2NvZGUg
dXBkYXRlIFNWTiBhbmQgZ2VuZXJhdGUgbmV3DQo+ICsgKiBjcnlwdG9ncmFwaGljIGFzc2V0cy4g
TXVzdCBiZSBjYWxsZWQgd2hlbiBFUEMgaXMgZW1wdHkuDQo+ICsgKiBNb3N0IG9mIHRoZSB0aW1l
LCB0aGVyZSB3aWxsIGJlIG5vIHVwZGF0ZSBhbmQgdGhhdCdzIE9LLg0KPiArICogSWYgdGhlIGZh
aWx1cmUgaXMgZHVlIHRvIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSwgdGhlDQo+ICsgKiBvcGVy
YXRpb24gY2FuIGJlIHNhZmVseSByZXRyaWVkLiBJbiBvdGhlciBmYWlsdXJlIGNhc2VzLA0KPiAr
ICogdGhlIHJldHJ5IHNob3VsZCBub3QgYmUgYXR0ZW1wdGVkLg0KPiArICoNCj4gKyAqIFJldHVy
bjoNCj4gKyAqIDA6IFN1Y2Nlc3Mgb3Igbm90IHN1cHBvcnRlZA0KPiArICogLUVBR0FJTjogQ2Fu
IGJlIHNhZmVseSByZXRyaWVkLCBmYWlsdXJlIGlzIGR1ZSB0byBsYWNrIG9mDQo+ICsgKiAgZW50
cm9weSBpbiBSTkcuDQo+ICsgKiAtRUlPOiBVbmV4cGVjdGVkIGVycm9yLCByZXRyaWVzIGFyZSBu
b3QgYWR2aXNhYmxlLg0KPiArICovDQo+ICtzdGF0aWMgaW50IHNneF91cGRhdGVfc3ZuKHZvaWQp
DQo+ICt7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCS8qDQo+ICsJICogSWYgRVVQREFURVNWTiBp
cyBub3QgYXZhaWxhYmxlLCBpdCBpcyBvayB0bw0KPiArCSAqIHNpbGVudGx5IHNraXAgaXQgdG8g
Y29tcGx5IHdpdGggbGVnYWN5IGJlaGF2aW9yLg0KPiArCSAqLw0KPiArCWlmICghY3B1X2ZlYXR1
cmVfZW5hYmxlZChYODZfRkVBVFVSRV9TR1hfRVVQREFURVNWTikpDQo+ICsJCXJldHVybiAwOw0K
PiArDQo+ICsJZm9yIChpbnQgaSA9IDA7IGkgPCBSRFJBTkRfUkVUUllfTE9PUFM7IGkrKykgew0K
PiArCQlyZXQgPSBfX2V1cGRhdGVzdm4oKTsNCj4gKw0KPiArCQkvKiBTdG9wIG9uIHN1Y2Nlc3Mg
b3IgdW5leHBlY3RlZCBlcnJvcnM6ICovDQo+ICsJCWlmIChyZXQgIT0gU0dYX0lOU1VGRklDSUVO
VF9FTlRST1BZKQ0KPiArCQkJYnJlYWs7DQo+ICsJfQ0KPiArDQo+ICsJLyoNCj4gKwkgKiBTVk4g
d2FzIGFscmVhZHkgdXAtdG8tZGF0ZS4gVGhpcyBpcyB0aGUgbW9zdA0KPiArCSAqIGNvbW1vbiBj
YXNlLg0KPiArCSAqLw0KPiArCWlmIChyZXQgPT0gU0dYX05PX1VQREFURSkNCj4gKwkJcmV0dXJu
IDA7DQo+ICsNCj4gKwkvKg0KPiArCSAqIFNWTiB1cGRhdGUgZmFpbGVkIGR1ZSB0byBsYWNrIG9m
IGVudHJvcHkgaW4gRFJORy4NCj4gKwkgKiBJbmRpY2F0ZSB0byB1c2Vyc3BhY2UgdGhhdCBpdCBz
aG91bGQgcmV0cnkuDQo+ICsJICovDQo+ICsJaWYgKHJldCA9PSBTR1hfSU5TVUZGSUNJRU5UX0VO
VFJPUFkpDQo+ICsJCXJldHVybiAtRUFHQUlOOw0KPiArDQo+ICsJaWYgKCFyZXQpIHsNCj4gKwkJ
LyoNCj4gKwkJICogU1ZOIHN1Y2Nlc3NmdWxseSB1cGRhdGVkLg0KPiArCQkgKiBMZXQgdXNlcnMg
a25vdyB3aGVuIHRoZSB1cGRhdGUgd2FzIHN1Y2Nlc3NmdWwuDQo+ICsJCSAqLw0KPiArCQlwcl9p
bmZvKCJTVk4gdXBkYXRlZCBzdWNjZXNzZnVsbHlcbiIpOw0KPiArCQlyZXR1cm4gMDsNCj4gKwl9
DQo+ICsNCj4gKwkvKg0KPiArCSAqIEVVUERBVEVTVk4gd2FzIGNhbGxlZCB3aGVuIEVQQyBpcyBl
bXB0eSwgYWxsIG90aGVyIGVycm9yDQo+ICsJICogY29kZXMgYXJlIHVuZXhwZWN0ZWQuDQo+ICsJ
ICovDQo+ICsJRU5DTFNfV0FSTihyZXQsICJFVVBEQVRFU1ZOIik7DQo+ICsJcmV0dXJuIC1FSU87
DQo+ICt9DQo+ICsNCg0KVGhpcyBwYXRjaCBhbG9uZSBnZW5lcmF0ZXMgYmVsb3cgYnVpbGQgd2Fy
bmluZyAoYm90aCB3LyBhbmQgdy9vICdXPTEnKToNCg0Ka2h1YW5nMkBraHVhbmcyLWRlc2s6fi93
b3JrL2VuYWJsaW5nL3NyYy90aXAkIG1ha2UgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvIFc9MQ0K
ICBERVNDRU5EIG9ianRvb2wNCiAgQ0FMTCAgICBzY3JpcHRzL2NoZWNrc3lzY2FsbHMuc2gNCiAg
SU5TVEFMTCBsaWJzdWJjbWRfaGVhZGVycw0KICBDQyAgICAgIGFyY2gveDg2L2tlcm5lbC9jcHUv
c2d4L21haW4ubw0KYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jOjk0MDoxMjogd2Fybmlu
Zzog4oCYc2d4X3VwZGF0ZV9zdm7igJkgZGVmaW5lZCBidXQgbm90DQp1c2VkIFstV3VudXNlZC1m
dW5jdGlvbl0NCiAgOTQwIHwgc3RhdGljIGludCBzZ3hfdXBkYXRlX3N2bih2b2lkKQ0KICAgICAg
fCAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+DQoNClJlZ2FyZGxlc3Mgb2Ygd2hldGhlciB0aGlz
IHdhcm5pbmcgaXMgcmVhc29uYWJsZSBvciBub3QsIGl0IGlzIGEgd2FybmluZyBkdXJpbmcNCmJ1
aWxkIHByb2Nlc3Mgd2hpY2ggbWF5IGltcGFjdCBiaXNlY3QuDQoNCllvdSBjYW4gc2lsZW5jZSBp
dCBieSBhbm5vdGF0aW5nIF9fbWF5YmVfdW51c2VkIGF0dHJpYnV0ZSB0byBzZ3hfdXBkYXRlX3N2
bigpIGluDQp0aGlzIHBhdGNoLCBhbmQgdGhlbiByZW1vdmUgaXQgaW4gdGhlIG5leHQgb25lLg0K
DQpCdXQgSSBhbSBub3Qgc3VyZSB3aGV0aGVyIGl0IGlzIG5lY2Vzc2FyeSwgdGhvdWdoLiAgV2Ug
Y2FuIG1lcmdlIHRoZSBsYXN0IHR3bw0KcGF0Y2hlcyB0b2dldGhlci4gIFRoZSBlbmRpbmcgcGF0
Y2ggd29uJ3QgYmUgdG9vIGJpZyB0byByZXZpZXcgSU1ITy4NCg0KV2UgY2FuIGV2ZW4gbWVyZ2Ug
cGF0Y2ggMyB0b2dldGhlciB0b28uICBUaGUgcmVhc29uIGlzIGN1cnJlbnQgY2hhbmdlbG9nIG9m
IHRoYXQNCnBhdGNoIGRvZXNuJ3QgZXhwbGFpbiB3aHkgd2Ugb25seSBkZWZpbmUgdGhhdCB0d28g
ZXJyb3IgY29kZXMgKG9yIHJldHVybiB2YWx1ZXMpDQpidXQgbm90IG90aGVycywgd2hpY2ggbWFr
ZXMgdGhhdCBwYXRjaCAqQUxPTkUqIHVuLXJldmlld2FibGUgd2l0aG91dCBsb29raW5nIGF0DQpm
dXJ0aGVyIHBhdGNoZXMuICBUaGF0IGJlaW5nIHNhaWQsIGl0J3MgZmluZSB0byBtZSB3ZSBrZWVw
IHBhdGNoIDMgYWxvbmUsIGJ1dA0KaXQncyBiZXR0ZXIgdG8gZG8gc29tZSBjbGFyaWZpY2F0aW9u
IGluIGNoYW5nZWxvZy4NCg0KQnV0IGp1c3QgbXkgMiBjZW50cy4gIFNpbmNlIERhdmUvSW5nby9K
YXJra28gYXJlIGFsbCBvbiB0aGlzIHRocmVhZCwgSSdsbCBsZWF2ZQ0KdGhpcyB0byB0aGVtLg0K
DQo=
