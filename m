Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5A615A86B;
	Fri,  9 Aug 2024 11:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723202368; cv=fail; b=G9tZr1uL/bupcaB3hFU8MJNvT7+cJ1mwNIhXccW+UJP6A/JGpbdBFek9+ROB6+Zcd7gYY/fGyDavPmANG50ILKX4pW8SFOY9oSxV67BOOxDf6iIe8kpvadwrQX54h+0R7CLQcBaEz04zxG8RHNBIiP3d8QVZVzi0pZpvoXTl0Do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723202368; c=relaxed/simple;
	bh=XPGFf6KrPgjk1b/2spJ6xFabJ2KKckIb96oVq+xRMvc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EnVa/mPAmsu0gCTQyq6D1Y32vjfF+FqccXtBZvWafVtfVW5Oa3eH8Ay8V/4m9pze7zyCG0P8lk/2l6AlaBHb939ZJQTFN/6CIjeQc4fbm95lOJEqksmVkuzYOXpj8TcdXTvJqxOJrnWAZOdYFm1G7lQRm5k+/MbmmRmKkNfK2zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NMR6/EIv; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NMR6/EIv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723202367; x=1754738367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XPGFf6KrPgjk1b/2spJ6xFabJ2KKckIb96oVq+xRMvc=;
  b=NMR6/EIvn+zD0rGklfnxcu1VVQTWfig5kXX/7tUyjkWqS4c6OZFz7GkB
   EPpWJnvCHPs3Hf773q3sEP2Np75yWnvYW7qiCTkSSiid06GvDOpKptuyS
   K7yqISD9HDDYYyI16xFHDUNzhudTqShqofioEANEsn2NnikzzuUDQavQZ
   m+JuxBKyQS5JuTA3Q0IcOtw+CpHQ8UsCgxCMzOrB8agV/I91yrCoqc79P
   CR3kii2daWpHiGcQ4hWuXOvBRQR+poXhpttIVbykRLnnJDwSckkIwWq3T
   /zTvB5lGp2WubmnFKsMMDBH4MlpHqf7AFzEHlnj8AtDjAUYqylrXrBg+n
   g==;
X-CSE-ConnectionGUID: pcwA+GvjTWiRg9zoZc8aMw==
X-CSE-MsgGUID: bNaRd/YLRXu7MdKu0p9sWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="21030477"
X-IronPort-AV: E=Sophos;i="6.09,276,1716274800"; 
   d="scan'208";a="21030477"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 04:19:26 -0700
X-CSE-ConnectionGUID: I68Pk8FxRkqqLlzcFXMXGg==
X-CSE-MsgGUID: IygYUZ4JQ2evAp220hmcYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,276,1716274800"; 
   d="scan'208";a="57620384"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Aug 2024 04:19:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 9 Aug 2024 04:19:25 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 9 Aug 2024 04:19:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 9 Aug 2024 04:19:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 9 Aug 2024 04:19:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m0xV+4gdzjBFCozAP84XdmsDpc5K3fitOCxM+TUSl/GlBZXyLOp/8vuKiSn+UFT+VqQQEcw4yLMZ61yl4bQaciXlMVb8QYNzIHi84R5tNR8T6DOyfmZDAgaH/uorf8wdr61dscv2uwRVnzYO8jiB+mLEaFdcEw6OBXigzErhK0TAoEO1Zjy40+NBt4CPZloRckkbmhQLKuCXtXEmgUkEyt46PTOwLMuuCxW9BoVD0GBNb+dCgpBSzegA/IHex21EuJ+CLpMOQhxwx4h8kY8cnTGlrRYEp1Gpn9ca3S/mTx3n0jbC7S10f16dNuRc5yhwys4IQxrlUAsT3sL9rFylKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPGFf6KrPgjk1b/2spJ6xFabJ2KKckIb96oVq+xRMvc=;
 b=Tt1/52OPNWFWbGUyeLspl7iAGN8MrIj7PxXyNeDWfpjob1oEsA7vBaU/FgTsZreUlf3PPIvsmBh2i/uKt3YEtc724l7C1U0YFJHr5NLQXINlirIKMMPST59yFQWsLNaT/n/c7e1ZbHgXHc9z1ES+gxjiQkmmY4SOm8wnSwuBbyVO6QozvjdZ9cM3XDttYl2eOGO5gtBpjHUx7ML5hmaH2Hx2JzrcC3fcdSjyL8THOzPYr5Dqfiw8W6XMl9YC1fpXYB2KISDr+f8vsBXDu1BHwGEAX/Mn2mffITBmPDJp6ExOKLZ2GINKKck8kKgQWyHIITWfDxMIhYmvacZXCSHsRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5892.namprd11.prod.outlook.com (2603:10b6:303:16a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Fri, 9 Aug
 2024 11:19:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Fri, 9 Aug 2024
 11:19:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Kuvaiskii, Dmitrii" <dmitrii.kuvaiskii@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Qin, Kailun" <kailun.qin@intel.com>,
	"haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "Vij, Mona"
	<mona.vij@intel.com>
Subject: Re: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
Thread-Topic: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
Thread-Index: AQHazrB4mIMKrvC2y0eY2IQtmlLA9bIGxLIAgBgc0wCAAB0PAA==
Date: Fri, 9 Aug 2024 11:19:22 +0000
Message-ID: <8ab0f2d8aaf80e263796e18010e0fa0a4f0686a3.camel@intel.com>
References: <6645526a-7c56-4f98-be8c-8c8090d8f043@intel.com>
	 <20240809093520.954552-1-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240809093520.954552-1-dmitrii.kuvaiskii@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5892:EE_
x-ms-office365-filtering-correlation-id: f95282ee-899d-4d33-035e-08dcb8651e83
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b0VUZlhzaGFjWk1meUEvTFp6V1pXRXRaa3FicGFhZ21zUHljOURCVzBFdXVv?=
 =?utf-8?B?TjVpQVcvbWJQMFNrekVqVmNzSjVPMFpNT1JrK1QyZkZJcm81TU90U2FMajQ3?=
 =?utf-8?B?eWpXajFNVzFiR3NVZUY3dGpLalJ0R3c0U093d01pL0pDQ0RLMzJoQ2xBQzhT?=
 =?utf-8?B?ZFh4Q1I4a1Bjb2IwRGJNWktObXBiR2lISXhUZFpEZFRocFFoL3lxK0VsRXM4?=
 =?utf-8?B?amRIcXg0VG5nUWFYRCtQMHZybTAxWGRoUUgrVGRkM2U1d3lMZkN4Y2g3WFZQ?=
 =?utf-8?B?N0NFakhNRUJHYS9uMkpMUXZuQWlFRVFXNmxrZFA2bVhaSjMyRTJYemd3UEQv?=
 =?utf-8?B?SGkxSnFMNTBmSzlubDZSQjFCSUwwWDdYVlN5ZFVPY3JVcDlvb1FIMno4by95?=
 =?utf-8?B?VzliZW5jUFJyejdmVnVuamU3eWdqWURqZWtFUmZ5QS8wRnA2aG9DdmlQanh6?=
 =?utf-8?B?S1NlaDRkSmJMN3A5eDB1WEJwQ2N4UnI2YzZlU29jS3V4Y2tMUmNGbVpKaWJ5?=
 =?utf-8?B?eWR5cFI2dk4zNGEwVTdRL3V0bVZqOTRqMUpNUG5HSzhHcFBjVEs5aDEvd1gv?=
 =?utf-8?B?L0pJZkdrVTFWc01BbVJlMkp6WCtmY3BMUWY5dHd0RXJGMkNuUFlKYjJPSmlW?=
 =?utf-8?B?OUZra2lnV2QzeEhzc1Q5c0NQTmxwaGJhRUFBZExEVFRKQ1JMQ1dFTGlGK25E?=
 =?utf-8?B?TzFGdDZIRE5jaWFzcEU3NUhKZk5BMTQyQUxhZjRSaTN4Rnl1N3FwMWxNb3Fs?=
 =?utf-8?B?NHZNZkp4Q1ovd3dQbDZxcWZrWUtMd1BmTk5NT3VhVExGTHBGa1MwTCt5ZzVu?=
 =?utf-8?B?RDVTU2hGaDduWm05alIxNmcrclRRUWdwUjhWVGU2RkplN2FpTjNHems5a2RZ?=
 =?utf-8?B?b3BmakxJRkU0WmpuQkpEanFMMnJSU1pkZndsVHkvSU0zekQwVmtndFgrK3JR?=
 =?utf-8?B?cURKUitjZDEya1ZwZ2duWXVMaXZDSGlKa0sxMmxRTWZqdm1TRm9Gc2JzZVFo?=
 =?utf-8?B?NHJWMGdnZXJ6a1JyRG9FMDIvQk0xV1pFRHNyQ1RxYllVSnhPczlCUkhzanUz?=
 =?utf-8?B?QU1Gb0xBdE1vWTlFeHY1WEJpWGRPdUpwdXpERnFkMHQ0d0VMMmI0N2xaaXU1?=
 =?utf-8?B?Q1dQdmRSTUl1NkhFNjJQZWxIYUFYWVgrQmFzdXFCK1B1N3RjTUJDMGZTMTdQ?=
 =?utf-8?B?cVJ0TVZqZUw1ajJJZFhvSVJkNGM4Z1RXeWVZN3czZXVsREJBcFE3OW53RU1E?=
 =?utf-8?B?V1Z4U0NWdkxyRDF6NTlubXBYLzBtbGEwR2U2dTN2WWFzbHRPMlNkd1RnVWVH?=
 =?utf-8?B?MkVVR2ZjTGxpelB1aC95Y20yYkwrVlJEZ2lLR3laSGQxNTdKOGpkeW43NzFK?=
 =?utf-8?B?UG5mNVlJOEpRTlFTVWtBSWVXTzVVZzZ2aEQ2QXNRdzRUNUppcjVCY1dIbG1B?=
 =?utf-8?B?Y1F0VkdMak90ekU3NGk5SXVxT1h5SjJ5cnJDQ2xIU21BdFVoU2pkNTdUQXFN?=
 =?utf-8?B?YjZpN09SUDdFRTU3VXpDSzlxekNuVjloYzR5UmNVa201cUlRSmVrL0NPemoy?=
 =?utf-8?B?cmtnR1NsVy9manoyNlFuNFFXUVFDVWhaVjZ6UGZpSExpREExZkxoT2NSZHJ4?=
 =?utf-8?B?TzNib1g1SmpLQXlkeE9tMXdGbHZxVUxRL1A4cmx0emphZ0xxZGEva1RVN3Uz?=
 =?utf-8?B?VTg0U3d1NWlxbWMwbTdoakViemVEMk0rZGY2MWd4VGlxQ2IvVzB4V3NlOVZO?=
 =?utf-8?B?bW1QbDk4OGhLcDMxalNXdG1HZllTM3dKR3lBOHRYMGlYRkZvZDZibmtaSG83?=
 =?utf-8?B?a210WVNtbVFzemc4WEdSeWNtendjUVhVc1doMEV6V1FBNkc3RXFsZGFLQ0px?=
 =?utf-8?B?bzhzSXpPYlU0aGJTZnkvS2trcTJFN0dtT05DdXRiS1IyUUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajZtb3R0SU9sZk84SFZGUitKTUVodUJlZ3UrVHBrV0h5MkxoamV4L1NFcFI3?=
 =?utf-8?B?VklFUGp4a3NEUHZwR0VBdExNcDgwNXIvdnZVUklRbTdEaFJnL0hHWitZais0?=
 =?utf-8?B?T3cralVUTGQ3N01jQ1ZJWElrRnFNckNaaERJZktqZVYrOW5kcjZ3MXJ2WDh3?=
 =?utf-8?B?RjV1WVljanYwelFMbzFHOTBtbW1kTGY2UzlSWHNXbDlmWVAyaUM4STliNmxC?=
 =?utf-8?B?NUpPSkF5UGo1cVFZNUNDTDByRWd1UGRiMmNQeTZwNWhBMWpFdmk3YmRFeWpo?=
 =?utf-8?B?N3YxNGFxcHdUOGlUQUF3Vmt1TEsyY0VOQWV1ZGxSc05KVnRiZG1LZDA5Wmt0?=
 =?utf-8?B?QUR3UWE4VUljMVpLQ0RsVkFZV0lOaVBzN3FldXNMVkJkM3pGald6M1NXSUJw?=
 =?utf-8?B?Zm44c25lS1ZDQ3VPa0RRejg4L0hvWFlodk5WS3F6NHYrSjRhUHZGYnNPb200?=
 =?utf-8?B?VGtuTi9rbWJJbWJZZmJRNUdoTm41ZDRrcms2Y3pramF1eUptcHRYRkxFaTNR?=
 =?utf-8?B?MDQ1T09KREwxUE9TdWIzeE5zMjVsSk1IY0hwemhNYVZJZXBjMUFabGtFbExh?=
 =?utf-8?B?ZUg2L1k3cG9DdEYzRzFmbDZxUFdEM3VJZzVQSGJ1ajJhMG5rdjdnVWdJdFly?=
 =?utf-8?B?M2ZHZCtIZkwrcm9NR0J4aThGanozRDdaZDM0WmN5NmpoZXZSdk9HUmNsREd4?=
 =?utf-8?B?NGVjZUhzK0RNWWFkYTV5Z0dIWGZWbHZ5Ym44YW04bkZURWptQXI3Wm9JcWwr?=
 =?utf-8?B?T3BaWm9BRzdCYWRHRW5QaUJUN1FibWJRNlZ5MUphb25qTkNxdUxIa3JzdjRv?=
 =?utf-8?B?cHVxMHZUUzJsTEt6NFVoTDBQVE5jZU5vR244TWV2REdsTFZPRzlCTmYxVWpN?=
 =?utf-8?B?cGhnbDBINVlpZkFXdkFhSUlRVDZraDZXbjltWHY1WnVXWjRuOXVaK1FCREY2?=
 =?utf-8?B?V29wT3NzYUxCVW9lUnBWSGsrakpCcnhiUllrTFZYeVltc2RJZXc5WXUzVnpa?=
 =?utf-8?B?aFkwems3VFlaV2I3WWpNaDlvcExXVUpSM09Kdit3M1ZjbnVZU0Jsa3JNQWFt?=
 =?utf-8?B?d0wyZDRheWI0TytkdXYrQmhSZHRKcTQvUUJLdytmRlc2ekxETitaSWdXYkVY?=
 =?utf-8?B?Q1lVSVZ4cmc1Nmhpa25rWTQ0U0Z6TGZqU1pkQ0l3WkpaZFVWTlozUzFodU1U?=
 =?utf-8?B?QlZLZmdONWE5QlJJdXBvZGE4WHpXSHBDMzV4a1AyalN4V3hjWmI0VHN1UnV6?=
 =?utf-8?B?SE5sK0Y5QVFzYnNBamVnSkRVQmplcWZ2Skd1b21xYmVBN2d0R3NDSXkxVGls?=
 =?utf-8?B?ZnlBYXhMWDUzdzY5WVF2NGt4NlI2RU1CRmpDWVQ3K2JmeFNXNnUydHA0UTBU?=
 =?utf-8?B?UmtrRGhWTTNWWFZnb29yMis5YTN6ZHBUSWgxRGE2YS9MQkV6Y2krMXhvUHdx?=
 =?utf-8?B?ZTVwbTArcVhURk1iUUtSUVFpckNNM2F6aXdpQkw3TkFNM0NzVFhlV2hUdm02?=
 =?utf-8?B?Ykd2LzBia3Vra3lkNnBkNGE0V2ZVa3AzNEFtOVpYb1FwWGRseVhhRHFRVmpV?=
 =?utf-8?B?N2FqVDNxUW4xNDZKQkFTY3lXZUM1V3lSOVFmdTVkc09pNzQ3dFhNbmk3NmZv?=
 =?utf-8?B?R2RNRjg0WFVDTmhIMGhGQzlJdlM2dm42YnJTc2dsdDFuN2VVbzE3TUwxeDBY?=
 =?utf-8?B?bGlETmp3MzVIbDhVT0J6aytxMXMrVjFQR1VJNmJqNzRCd2hUc1ZFMmx6QVY4?=
 =?utf-8?B?YU1vU2tvVjhidEdCeVhMa0kveGdkcER6NnJpcEJGcWU0SjVwT0VBKzBGZzVR?=
 =?utf-8?B?bkN3S2xFYVZwZFlvL2ZqcjYvbFE4Z0hFdUJtV2wyNG9SVXhpSmg5V1BEV21M?=
 =?utf-8?B?VGpNekxYYnN4WEp6ZDZ4QXdheXZwL242R1pQOVJBSTY2MFlYUjBiK2liaWJ5?=
 =?utf-8?B?VUo2cHF2V0xrbXBrSndSV2V6ZXd6emRXZmFnU3lKME9oOEg3Q3NPMlRWVFp5?=
 =?utf-8?B?Z3dWY2pXT3pnd011dDljck5vK0xhWHdFWFFZZTh4dXlpN0htRDhFdGJ2NjZE?=
 =?utf-8?B?bW4vNFpFMFQzdW4rUUZ6Ti9mSTVWRTZoM1N0MGFsWGV2d3ViMEFzZXRZVzBN?=
 =?utf-8?Q?SSYi4UZrpMkI1kZYKxqTpabal?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50A980F8EB9D4F4BBFC84925FCE628BE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f95282ee-899d-4d33-035e-08dcb8651e83
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 11:19:22.2380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a2HF4YEJb9lMi7UkzQw6Ec+st4ZB1ILf4qXaYoeZUjB1q4nrLcMsm4l4If0MwRt9uZ/a5dXEv9dAMb4TESd6qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5892
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA4LTA5IGF0IDAyOjM1IC0wNzAwLCBEbWl0cmlpIEt1dmFpc2tpaSB3cm90
ZToNCj4gT24gVGh1LCBKdWwgMjUsIDIwMjQgYXQgMDE6MjE6NTZQTSArMTIwMCwgSHVhbmcsIEth
aSB3cm90ZToNCj4gPiANCj4gPiA+IFR3byBlbmNsYXZlIHRocmVhZHMgbWF5IHRyeSB0byBhZGQg
YW5kIHJlbW92ZSB0aGUgc2FtZSBlbmNsYXZlIHBhZ2UNCj4gPiA+IHNpbXVsdGFuZW91c2x5IChl
LmcuLCBpZiB0aGUgU0dYIHJ1bnRpbWUgc3VwcG9ydHMgYm90aCBsYXp5IGFsbG9jYXRpb24NCj4g
PiA+IGFuZCBNQURWX0RPTlRORUVEIHNlbWFudGljcykuIENvbnNpZGVyIHNvbWUgZW5jbGF2ZSBw
YWdlIGFkZGVkIHRvIHRoZQ0KPiA+ID4gZW5jbGF2ZS4gVXNlciBzcGFjZSBkZWNpZGVzIHRvIHRl
bXBvcmFyaWx5IHJlbW92ZSB0aGlzIHBhZ2UgKGUuZy4sDQo+ID4gPiBlbXVsYXRpbmcgdGhlIE1B
RFZfRE9OVE5FRUQgc2VtYW50aWNzKSBvbiBDUFUxLiBBdCB0aGUgc2FtZSB0aW1lLCB1c2VyDQo+
ID4gPiBzcGFjZSBwZXJmb3JtcyBhIG1lbW9yeSBhY2Nlc3Mgb24gdGhlIHNhbWUgcGFnZSBvbiBD
UFUyLCB3aGljaCByZXN1bHRzDQo+ID4gPiBpbiBhICNQRiBhbmQgdWx0aW1hdGVseSBpbiBzZ3hf
dm1hX2ZhdWx0KCkuIFNjZW5hcmlvIHByb2NlZWRzIGFzDQo+ID4gPiBmb2xsb3dzOg0KPiA+ID4g
DQo+ID4gPiAgIFsgLi4uIHNraXBwZWQgLi4uIF0NCj4gPiA+IA0KPiA+ID4gSGVyZSwgQ1BVMSBy
ZW1vdmVkIHRoZSBwYWdlLiBIb3dldmVyIENQVTIgaW5zdGFsbGVkIHRoZSBQVEUgZW50cnkgb24g
dGhlDQo+ID4gPiBzYW1lIHBhZ2UuIFRoaXMgZW5jbGF2ZSBwYWdlIGJlY29tZXMgcGVycGV0dWFs
bHkgaW5hY2Nlc3NpYmxlICh1bnRpbA0KPiA+ID4gYW5vdGhlciBTR1hfSU9DX0VOQ0xBVkVfUkVN
T1ZFX1BBR0VTIGlvY3RsKS4gVGhpcyBpcyBiZWNhdXNlIHRoZSBwYWdlIGlzDQo+ID4gPiBtYXJr
ZWQgYWNjZXNzaWJsZSBpbiB0aGUgUFRFIGVudHJ5IGJ1dCBpcyBub3QgRUFVR2VkLCBhbmQgYW55
IHN1YnNlcXVlbnQNCj4gPiA+IGFjY2VzcyB0byB0aGlzIHBhZ2UgcmFpc2VzIGEgZmF1bHQ6IHdp
dGggdGhlIGtlcm5lbCBiZWxpZXZpbmcgdGhlcmUgdG8NCj4gPiA+IGJlIGEgdmFsaWQgVk1BLCB0
aGUgdW5saWtlbHkgZXJyb3IgY29kZSBYODZfUEZfU0dYIGVuY291bnRlcmVkIGJ5IGNvZGUNCj4g
PiA+IHBhdGggZG9fdXNlcl9hZGRyX2ZhdWx0KCkgLT4gYWNjZXNzX2Vycm9yKCkgY2F1c2VzIHRo
ZSBTR1ggZHJpdmVyJ3MNCj4gPiA+IHNneF92bWFfZmF1bHQoKSB0byBiZSBza2lwcGVkIGFuZCB1
c2VyIHNwYWNlIHJlY2VpdmVzIGEgU0lHU0VHViBpbnN0ZWFkLg0KPiA+ID4gVGhlIHVzZXJzcGFj
ZSBTSUdTRUdWIGhhbmRsZXIgY2Fubm90IHBlcmZvcm0gRUFDQ0VQVCBiZWNhdXNlIHRoZSBwYWdl
DQo+ID4gPiB3YXMgbm90IEVBVUdlZC4gVGh1cywgdGhlIHVzZXIgc3BhY2UgaXMgc3R1Y2sgd2l0
aCB0aGUgaW5hY2Nlc3NpYmxlDQo+ID4gPiBwYWdlLg0KPiA+IA0KPiA+IFJlYWRpbmcgdGhlIGNv
ZGUsIGl0IHNlZW1zIHRoZSBpb2N0bChzZ3hfaW9jX2VuY2xhdmVfbW9kaWZ5X3R5cGVzKSBhbHNv
IHphcHMNCj4gPiBFUEMgbWFwcGluZyB3aGVuIGNvbnZlcnRpbmcgYSBub3JtYWwgcGFnZSB0byBU
U0MuICBUaHVzIElJVUMgaXQgc2hvdWxkIGFsc28NCj4gPiBzdWZmZXIgdGhpcyBpc3N1ZT8NCj4g
DQo+IFRlY2huaWNhbGx5IHllcywgc2d4X2VuY2xhdmVfbW9kaWZ5X3R5cGVzKCkgaGFzIGEgc2lt
aWxhciBjb2RlIHBhdGggYW5kDQo+IGNhbiBiZSBwYXRjaGVkIGluIGEgc2ltaWxhciB3YXkuDQo+
IA0KPiBQcmFjdGljYWxseSB0aG91Z2gsIEkgY2FuJ3QgaW1hZ2luZSBhbiBTR1ggcHJvZ3JhbSBv
ciBmcmFtZXdvcmsgdG8gYWxsb3cgYQ0KPiBzY2VuYXJpbyB3aGVuIENQVTEgbW9kaWZpZXMgdGhl
IHR5cGUgb2YgdGhlIGVuY2xhdmUgcGFnZSBmcm9tIFJFRyB0byBUQ1MNCj4gYW5kIGF0IHRoZSBz
YW1lIHRpbWUgQ1BVMiBwZXJmb3JtcyBhIG1lbW9yeSBhY2Nlc3Mgb24gdGhlIHNhbWUgcGFnZS4g
VGhpcw0KPiB3b3VsZCBiZSBjbGVhcmx5IGEgYnVnIGluIHRoZSBTR1ggcHJvZ3JhbS9mcmFtZXdv
cmsuIEZvciBleGFtcGxlLCBHcmFtaW5lDQo+IGFsd2F5cyBmb2xsb3dzIHRoZSBwYXRoIG9mOiBj
cmVhdGUgYSBuZXcgUkVHIGVuY2xhdmUgcGFnZSwgbW9kaWZ5IGl0IHRvDQo+IFRDUywgb25seSB0
aGVuIHN0YXJ0IHVzaW5nIGl0OyBpLmUuLCB0aGVyZSBpcyBuZXZlciBhIHBvaW50IGluIHRpbWUg
YXQNCj4gd2hpY2ggdGhlIFJFRyBwYWdlIGlzIGFsbG9jYXRlZCBhbmQgcmVhZHkgdG8gYmUgY29u
dmVydGVkIHRvIGEgVENTIHBhZ2UsDQo+IGFuZCBzb21lIG90aGVyIHRocmVhZC9DUFUgYWNjZXNz
ZXMgaXQgaW4tYmV0d2VlbiB0aGVzZSBzdGVwcy4NCg0KSSB0aGluayB3ZSBuZWVkIHRvIHVuZGVy
c3RhbmQgdGhlIGNvbnNlcXVlbmNlIG9mIHN1Y2ggYnVnIChhc3N1bWluZyBzdWNoDQpiZWhhdmlv
dXIgaXMgMTAwJSBhIGJ1ZykgYm90aCB0byBrZXJuZWwgYW5kIHRvIGVuY2xhdmUuDQoNClRvIHRo
ZSBrZXJuZWwgSSBkb24ndCBzZWUgYW55IGJpZyBpc3N1ZTogZm9yIHRoZSBzZ3hfdm1hX2ZhdWx0
KCkgcGF0aCBpdCB3aWxsDQpmaW5kIHRoZSBFUEMgcGFnZSBpcyBhbHJlYWR5IGxvYWRlZCB0aHVz
IGp1c3Qgc2V0dXAgdGhlIG1hcHBpbmcgYWdhaW47IGZvciB0aGUNCnNneF9lbmNsYXZlX21vZGlm
eV90eXBlcygpIHBhdGggdGhlIHdvcnN0IGNhc2UgaXMgX19lbW9kdCgpIGNvdWxkIGZhaWwsDQpy
ZXN1bHRpbmcgaW4gZW5jbGF2ZSBiZWluZyBraWxsZWQgcHJvYmFibHkuDQoNClNvIGlmIHRoaXMg
cmFjZSBpcyAxMDAlIGEgYnVnLCBhbmQgd2lsbCBhbHNvIGNlcnRhaW5seSBraWxsIHRoZSBlbmNs
YXZlLCB0aGVuDQpJIGd1ZXNzIGl0IGlzIGZpbmUgbm90IHRvIGhhbmRsZS4gIEJ1dCB0aGVyZSdz
IGFuICJhc3N1bWluZyIgaGVyZS4NCg0KT24gdGhlIG90aGVyIGhhbmQsIHRoZXJlJ3Mgbm8gcmlz
ayBpZiB3ZSBhcHBseSBCVVNZIGZsYWcgaGVyZSB0b28uICBJZiBpdCBpcyBhDQpidWcgaW4gZW5j
bGF2ZSwgdGhlbiBpdCBjYW4gZGllIGFueXdheTsgb3RoZXJ3aXNlIGl0IG1heSBzdXJ2aXZlLg0K
DQo+IA0KPiBUTERSOiBJIGNhbiBhZGQgc2ltaWxhciBoYW5kbGluZyB0byBzZ3hfZW5jbGF2ZV9t
b2RpZnlfdHlwZXMoKSBpZg0KPiByZXZpZXdlcnMgaW5zaXN0LCBidXQgSSBkb24ndCBzZWUgaG93
IHRoaXMgZGF0YSByYWNlIGNhbiBldmVyIGJlDQo+IHRyaWdnZXJlZCBieSBiZW5pZ24gcmVhbC13
b3JsZCBTR1ggYXBwbGljYXRpb25zLg0KPiANCg0KU28gYXMgbWVudGlvbmVkIGFib3ZlLCBJIGlu
dGVuZCB0byBzdWdnZXN0IHRvIGFsc28gYXBwbHkgdGhlIEJVU1kgZmxhZyBoZXJlLiDCoA0KQW5k
IHdlIGNhbiBoYXZlIGEgY29uc2lzdCBydWxlIGluIHRoZSBrZXJuZWw6DQoNCklmIGFuIGVuY2xh
dmUgcGFnZSBpcyB1bmRlciBjZXJ0YWlubHkgb3BlcmF0aW9uIGJ5IHRoZSBrZXJuZWwgd2l0aCB0
aGUgbWFwcGluZw0KcmVtb3ZlZCwgb3RoZXIgdGhyZWFkcyB0cnlpbmcgdG8gYWNjZXNzIHRoYXQg
cGFnZSBhcmUgdGVtcG9yYXJpbHkgYmxvY2tlZCBhbmQNCnNob3VsZCByZXRyeS4NCg0KQnV0IHRo
aXMgaXMgb25seSBteSAyY2VudHMsIGFuZCBJJ2xsIGxlYXZlIHRvIG1haW50YWluZXJzLg0KDQo=
