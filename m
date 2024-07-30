Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C100318C336;
	Tue, 30 Jul 2024 11:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722340665; cv=fail; b=aNJtwOglAu2T4KSe8z4FOg7EmF9wVFq8x2m93wtJsC3hlXPfnEgFbE/QYp1yt/eHtHrIXlmdLUaa+3JHO99Ov2m5kcbos4cWNUSlVA6O9+byW73mhrmFJgr1wKWbEeTOw1pNcE7GCoyy3kf3sDXf2FSWKX5BNq8wGYRF/1JPQOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722340665; c=relaxed/simple;
	bh=UCINmkA//cHPR+wCVoMsPNSuS93ZxB6J+QKjYS3iDAY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tBpO3unWbaCf1aWPzWysrvDm++nQphwVRUxAcDonk9ODingEz4gU6N39tyTyt4Oqizr52dOts2XZwfUFcKpomA9F/tU4vC62zApQgk97z0cSDO373ZsmOf1AQ8pHwDe6wyCioREWDJ4k86H+gPaEXymuSbdO44m226OX4oE1LJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lo/vaYdF; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lo/vaYdF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722340663; x=1753876663;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UCINmkA//cHPR+wCVoMsPNSuS93ZxB6J+QKjYS3iDAY=;
  b=lo/vaYdFqXimLqi3WAhCDhkqBnIGyO9FBEK7MoFxwzUbrDQU0YIdMiDU
   Jc3YTT+g1C+V3NkVHiLzCufzWeRBwbSs+Ya3gU9qs6bHmdHrPPbtoeUnG
   iEaPa+SWdWz8Yf6BkwVMwfqpedcOBT0yXKidqQzBsqF4iZSKgfxTX5i8z
   CBUxfYT1DsAEzqjlm/RavpXsJSnDTrc9azSYF8F6PVN/c9EWiUS5eVRoz
   2psUinoE0m/Zy4lbK7qD+3r3FmyqEBKr5ZL6UvbQ2VMGt/EjbocM7afYy
   ZsYh292+LiY03xON3CgFyLgpWNP91ZDBeabvD2o7FO0ICyAsnun+AcJ9D
   g==;
X-CSE-ConnectionGUID: MToDdAZrSc2oM7UJPhJYIg==
X-CSE-MsgGUID: kaZrFqxmR4e9p7Fy6BhL8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11148"; a="23938495"
X-IronPort-AV: E=Sophos;i="6.09,248,1716274800"; 
   d="scan'208";a="23938495"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2024 04:57:43 -0700
X-CSE-ConnectionGUID: JkfbJ/CWS7iREZO3nWQ5yg==
X-CSE-MsgGUID: tElTxjXuRoeest5rainZTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,248,1716274800"; 
   d="scan'208";a="77546026"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jul 2024 04:57:42 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 30 Jul 2024 04:57:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 30 Jul 2024 04:57:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 30 Jul 2024 04:57:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ax0OTJNG8GQnrQ7WhQCbi2hXpv5wSffrfCy4sGR4P16Uo6bU93q0RKuMUgoEwXJthLbmwCS0QcSx7ZKIIajDytAfDQvRmhgLCVBjPXSDy9oZvhPr80uvx59+QmJLk65SiG4fS+nc+o1/cW+2I/fjEOSyfSKv75YkmrWsmEl/43DA6zUz16y2urFQy+O99Iwges1leWfzmQ23uc8p9sbsT2PgeiNvXU4P/XyoKZfbR0T54e+72ptKYfhGxmzRWvLTc7ql8AVi3N2Z4gEZeXJ36L85J9fRFHrC8fIg+95FswNZ4uF8826dGhm6+i9XuAcZXitCnJ7yVdOZ60hY9ALv+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCINmkA//cHPR+wCVoMsPNSuS93ZxB6J+QKjYS3iDAY=;
 b=gN6qnsQ3tSX353QCWy1C1KuClzoHK5sWLvTA7iH61A2bqK9CqU8q8v9/G6FzjkIEZC/nDJfrdsPE5JubmgIBt502rdAIjSwWY24MJFqPiS70hh1/DVhHbAp62MsJFfL5XTi1u/PzUZA54DlEfmpcUoiVrkJYyUSc2mHbLxOM4gNYh2jFkkVq4RWxCW44k98LYqO0WGv4fPcuQmuHL9GOQ+pqHHqpzCwpvEtDj6BynE0sHJ7HgEUu4eIJ0DKwoGvD/fpm7O4FQ8LWrP05/e6NF2SOFm5erZSeqYyfitrv4xYe2DJN6zDCPPJrhf9VUdjas3SDn9l7c+GTNnTWPOKaLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6683.namprd11.prod.outlook.com (2603:10b6:510:1c6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Tue, 30 Jul
 2024 11:57:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7807.026; Tue, 30 Jul 2024
 11:57:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "wangyuli@uniontech.com" <wangyuli@uniontech.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "xiangzelong@uniontech.com" <xiangzelong@uniontech.com>
CC: "baimingcong@uniontech.com" <baimingcong@uniontech.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"guanwentao@uniontech.com" <guanwentao@uniontech.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
	"wubo@uniontech.com" <wubo@uniontech.com>
Subject: Re: [PATCH] x86/cpufeatures: SGX: Adjust the error message when BIOS
 does not support SGX
Thread-Topic: [PATCH] x86/cpufeatures: SGX: Adjust the error message when BIOS
 does not support SGX
Thread-Index: AQHa4is//1JBM77EBU2dmsGlk3Tz+bIPKv6A
Date: Tue, 30 Jul 2024 11:57:39 +0000
Message-ID: <a56bc12f6c60107c935db31d7330d28980ac4d5a.camel@intel.com>
References: <D345627B0A699F37+20240730024931.1026933-1-wangyuli@uniontech.com>
In-Reply-To: <D345627B0A699F37+20240730024931.1026933-1-wangyuli@uniontech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6683:EE_
x-ms-office365-filtering-correlation-id: 5d7c9b49-12c7-441f-7b96-08dcb08ecf74
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UW5BeE1iQ1pINTVaeHdVeXlINEJUUEp2djVPZE9OUTJiOFBJNWxQMXNZclMv?=
 =?utf-8?B?dlpHTDh4LzBhNmZPQ1dsa1g0S1ZZaDdjQWpjb01lR25rRjMwZTFkaXF0aG4w?=
 =?utf-8?B?VUVzcU9zdXNuYVlCNnRkRHhNSHVVQ1FqNVBDMUhTU294Ni9nT3dweTNHbWJS?=
 =?utf-8?B?RUpHYTY3SGlkZjdVeWprZTJzV2tITEJHRkZady9VVDdXeUdYYXIxZ1hMeUli?=
 =?utf-8?B?djFHUzdibHl6QVJZWUpBRzU3Zi90THVITEtpWnUwd1pLcmJMNmZJVzFKbDJV?=
 =?utf-8?B?Ynd5Vm8ybG9CUzlGYTdVWDNNYnEveTRpT0QvNy85OGh3OGFWWEhLaUpqalc0?=
 =?utf-8?B?OEQ4VWRzN1NhU3FtTVQzSnY1TldKdDRzRzFMbFZBVG9Kc3hYT3IvcmdjUEs1?=
 =?utf-8?B?ZER5Vk9QNlRBYTZmcTI1STY2Y2k4YW1EM2NOdnhBTzdCV3ZFRjZOSUhGRVEw?=
 =?utf-8?B?b1p4R0haVjZtVnhVYnNpajZ2UVpkRklhc0FNelhQTTV6TzltOTV5cHlra0Vj?=
 =?utf-8?B?dUptTUVNMWVsZGxWNmwzWkJsNnN5R2NNZGJXRFh1VkRXMGZ4QmptN2w0dWtP?=
 =?utf-8?B?ZWJzSzZTRzFsVTA1YVozWXpkbDd5Sy90K3Y3K0ozbjBZZklZdXMrbXVXOVJk?=
 =?utf-8?B?a1NsMXVPZTFHeU44Zm8xYlUwYWxaTWRaRkdvaDdER1piZzJ6TU1LdGtLNVBW?=
 =?utf-8?B?ZlBnd3NoQlVudXpNQkRQYnZKUzRkMW9LaXNZbDhQT0g5WFRuR3ppNFJDZ0tH?=
 =?utf-8?B?enB1TExYZlBScEtrVmtjRjFER3lPZzlJZDAxNkRSVVVUSHhUdDBkRk5UVFRp?=
 =?utf-8?B?ZmlSaHRmdm42bG1STmtJcGFlbDhFdE5XTGpsMlBrYXBEN0k1NjI5S2IwT3hR?=
 =?utf-8?B?czhKWUVIUEEwcGoyZDRTWjdHcDY0c0s4WDIvVGJxVCtUejVpRVhrZTd1UFMr?=
 =?utf-8?B?QnJCeUlVR2RZS1RmdjZUekNhRC9FLyt0S0tjWmNrQWVFSTJBU2psSVlrNy9Z?=
 =?utf-8?B?eCsrQ3NnaEFTOUpPajUwdU5NMGtaWDZ2MXY0OG5BOFJ4dzFWTXJJQTJRL3dX?=
 =?utf-8?B?RmxPMnpwYkh1YzE5Zk9OaHl0bFRNU1YzT3pXeXJlZ3NlQ3pYVkEwb2VKVlZQ?=
 =?utf-8?B?dDFUdE5XRzMxUTNiVXNRZkNmYVh6ZnByUVNERHNUZkxCaTZBYk1aYW5UcVMw?=
 =?utf-8?B?UGo2THUvOEJQalBLejN1MVZ2bk1tcUIreDYyTFc1ZDNCZXl5ck5YVTZkdVB4?=
 =?utf-8?B?TWtCbU54SThObXI0aWpNUEMwUTJnbllTQi8yL3RjQ3Q0UUZFSXFXc3JBTHBy?=
 =?utf-8?B?RTNwZWs4SUhreHVLcHNRQ1hJV3ZxVlpCYk1hczFKUTZQTEpudGJzN0hoTUNj?=
 =?utf-8?B?dTRxSW13TkZ3bTlMd3JwZDFENjFYaFI4bzA3UndMbE13dnJRS1dGUnhUZ0Vj?=
 =?utf-8?B?OUVzOURVRGhxS3R2bTFBbWxHNGFRNVI5U0ZZVTB2MXpzZnFKajZGR0VzY0Nn?=
 =?utf-8?B?Z2Vrd3BuWlcyTDBUQkdndThRd2F0VGJkdjhVdEYxZmgwMUVPNS9XVmMwVEkz?=
 =?utf-8?B?bHArdXd3Zjgwd25uVzRsQXNKaHI5V1VsYVl1c0RXUlR5NTNaSEt5YU9veG4y?=
 =?utf-8?B?SEZJSmtRdDIyR2NpZVJiRWFOd3lPOWh3U2xsdUxLSSsyRCtSSno2ci9NYTBM?=
 =?utf-8?B?Q1ZJUmFpcUZES2s3SFNxNStwVE1lbzdNclJzS09CUTN2YjFFbkp1SlcvOWlJ?=
 =?utf-8?B?N0JjMWVIYWhkTC81OVBuVzQvamdhbTNrTno3NXV0RHdybk1EWlRudUVpblVC?=
 =?utf-8?Q?nsUwondeBkNlRUobMGYnMWfp0tRdaFQhVGpMg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTJMSTRXNlpURGF4bVJyeGtLUFU4WkJLczRkWFJxaGdreVRlVldJejFjRHlY?=
 =?utf-8?B?NWxHSExkdUdOdE5ocEM1UDBqOGtQREZPWUFwdEw2UllIVWYvVjZGY2tLZnZr?=
 =?utf-8?B?cGtDL3Q0UUViOTZ3K0pha3dEVmtEcjZaRmpLM3hiZVNpTkZvUmM1L2dpYkJM?=
 =?utf-8?B?c3VKM3hKU1NTb2w3UjBvNm1nZlMzYmxOQ2ZuOGVLOEVxKzN0MHk2UGNTRmMy?=
 =?utf-8?B?L2FBNmJaRmw3cEhBenBEK0JRK3dObDVSRU5nSFVZNVVXUGloV2VnQkRQMksx?=
 =?utf-8?B?OGgvaU1ZNVZYbUlyWTY1Zm5BelRZa0puY3hFZENVQk1sWW9qeHBKNU56RmZN?=
 =?utf-8?B?eDBFMjZyRVUrSHpBYVI0MmVNajVxdCs5ZmJPL0NONWgwQzBmeHlMMzZ2MEdD?=
 =?utf-8?B?ZXh3OW9jbVVzVFljRG5vYklPOTE4TWE0TTVSQVN0b2FxbFU5MnBjNWIxVWFz?=
 =?utf-8?B?eGxxRlVuUlluVGdDRXI3eXp3TlFlR2Y3b0FKT0Y2NmNUS2ZEbUU1MDlhQjhF?=
 =?utf-8?B?VFBkU1g0eXVseDBRVU54a3RNNVRINElOaDlxUUk4aWdrYmJSUGZBTlltdFg2?=
 =?utf-8?B?MnJVUWJQK0dJYWxHMlJFczVGRHpjYUFwL25yL2F6cy9nZXF1VktaNkd0eVRU?=
 =?utf-8?B?Y0kxQTB2YytIM3I5V28zaVlwa1lGOVR2U0lKNUVzc3AvZjc4WFE0ZTZCYTJp?=
 =?utf-8?B?RjdoV1NNLzdIeWd4c2RCYk9zU2xROThkdU9ETS9oZ0JWZHQ0WjlTekZYVjg1?=
 =?utf-8?B?dDA0OVM3SlpGd2Mwck1KeFkyNkxoa0xDSlVJWmN1UmxzdzNZSDlLUWlPUnZE?=
 =?utf-8?B?YUd1WTYrV0FQaHJqYTJYSXJNMTJDNWIxQkgxdUQrazNqY2VmdFBHWDdweXM5?=
 =?utf-8?B?SWRtR3dneitENnpWY21tWFYrTS9ScWhDZjdraXlrWkdqdDhvZzZxTUN3T2Zs?=
 =?utf-8?B?czQvYXNrUnBxVWEzSEFrN3hkc2FRNFRoSU5GdkUwMHFwZ1hkbTFBOXE3T0tm?=
 =?utf-8?B?TFdHWUJnWnZYWmJqZld6U3RZaW9sQlZxb1c4MEY4MnFOejlHR25acWVicG8x?=
 =?utf-8?B?ejFXMWVvVWcrdmxQcUpSUFB6UFpZYitRaFJYTzVsalFNZitlZGFtT21IMm9C?=
 =?utf-8?B?QUtxWlkzdVhkZ1V2OUlNUzQ3b3IvRnJMeVlCVkczYXQ3MnlLSFBJamRTNmU0?=
 =?utf-8?B?SDdyTWdiWUx0aWh2SHFoZ3R1WkdtYlQ4R01Mb1Aza0NvT2hsYitRc2lkeWZw?=
 =?utf-8?B?c2dvZCtkZ1lTL3JXNnh5SlR0VGt2bzlyb241K01tUXkyYVdjTXkxTGxGamNt?=
 =?utf-8?B?bmdzQnhycG41b1pZcWxsWG81NkpZcnczbHZhR1dRRVhUclZZK0FZaTRaRVhR?=
 =?utf-8?B?aityc2tXMUdjeCs5elNhTkFML0NoMVFvcVh3NmNFWFpaSUkycjJLVUJWUENw?=
 =?utf-8?B?bUZHUW5NeTlHbXUzeUdvK3ozVEdzUjZkWnVMRTJqTVRTV3VQYXF6NWZHSzFB?=
 =?utf-8?B?MTBtMWNJQjVVcE51d0pYaFNKTjZjTHhoVUU2VFNPNjFvbkZrU3VobG5wc0Yr?=
 =?utf-8?B?ajh4YUlVSEJDaFdRQ256bVcydUtIL0VaZHU1eEhSK1IweFpVTXBnaDA0c3ZN?=
 =?utf-8?B?V0dqemNsUTZINnNUNFVQZEg5SmJkL0FYay9vOXpmSjBoTjF3YnkxVUkzeWNk?=
 =?utf-8?B?ZlpNTUp5YnQ0Q0N0eVI4d0c3STVaNHNQZzY5Q21uMDhKRlI2VXJ1T2hTS0p4?=
 =?utf-8?B?SWM0Y0t6QnBqRzVJMlJ6WEFSSUlkRllGWkliK1NTczl4U3psNU5lV09kWUhM?=
 =?utf-8?B?Y0ROeGJtOWJVWTZrWkIxZFNycHRxQ2hRbUhhM1g5Z21zQ0QwR3NXU2dOZTFT?=
 =?utf-8?B?Vzk5WmdhbUx1VzZhc3NTM2RhVzRtYlFQbWNYbWxIcmZOT3I2VHVYSndPdG5z?=
 =?utf-8?B?UnVLd3IxUXJnSmVoU0IzTHN4OEthczlYcGlKd3FhWlpxeXgwSGhMNWNYZnJO?=
 =?utf-8?B?YkFjYlNvRmxrTEt6YkhtY3AyMC9kdG9iS2lIdTFtRURGblJ1Y0dKQ2kwVmJG?=
 =?utf-8?B?RUFzT0pRSWVDZnRYdWxzK2RTandKVGt2c2YrOUNlaTJTUXRXeENEK3RHU05Y?=
 =?utf-8?Q?R0iPuOnX9eupW3Oag6+OFtTeB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B03A2FEBE30F6A4A9A20633932B2D974@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7c9b49-12c7-441f-7b96-08dcb08ecf74
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2024 11:57:39.1570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wrnczyXhWYfUfXiIIszZeb938A5L0CdbVI/+/QI4WWcnsTDdLFYqq//iYpXEyqLYeCxebf87QmRA6BiHUMFS6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6683
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA3LTMwIGF0IDEwOjQ5ICswODAwLCBXYW5nWXVsaSB3cm90ZToNCj4gV2hl
biBTR1ggaXMgbm90IHN1cHBvcnRlZCBieSB0aGUgQklPUywgd2Ugc3RpbGwgb3V0cHV0IHRoZSBl
cnJvcg0KPiAnU0dYIGRpc2FibGVkIGJ5IEJJT1MnLCB3aGljaCBjYW4gYmUgY29uZnVzaW5nIHNp
bmNlIHRoZXJlIG1pZ2h0IG5vdCBiZQ0KPiBhbiBTR1gtcmVsYXRlZCBvcHRpb24gaW4gdGhlIEJJ
T1Mgc2V0dGluZ3MuDQoNCitsaW51eC1zZ3ggbGlzdCwgSmFya2tvLCBIYWl0YW8uDQoNClRoaXMg
bWVzc2FnZSBpcyBvbmx5IHByaW50ZWQgd2hlbiBTR1ggaXMgcmVwb3J0ZWQgaW4gQ1BVSUQgYnV0
IGlzIG5vdA0KZW5hYmxlZCBpbiB0aGUgRkVBVF9DVEwgTVNSLiAgSSBjYW4gb25seSByZWNhbGwg
dGhpcyBjYW4gaGFwcGVuIHdoZW4gdGhlDQpCSU9TIGFjdHVhbGx5IHByb3ZpZGVzIGFuIG9wdGlv
biBmb3IgdGhlIHVzZXIgdG8gdHVybiBvbi9vZmYgU0dYLCBpbg0Kd2hpY2ggY2FzZSB0aGUgY3Vy
cmVudCBtZXNzYWdlIGlzIGNvcnJlY3QuDQoNCkkgY291bGQgYmUgd3JvbmcsIGJ1dCBJIGRvbid0
IHJlY2FsbCBJIGhhdmUgbWV0IGFueSBtYWNoaW5lIHRoYXQgZG9lc24ndA0KaGF2ZSBhbnkgU0dY
IG9wdGlvbiBpbiB0aGUgQklPUyBidXQgc3RpbGwgcmVwb3J0cyBTR1ggaW4gdGhlIENQVUlELiAg
Q2FuDQp5b3UgY29uZmlybSB0aGlzIGlzIHRoZSBjYXNlPyDCoA0KDQpJIGRvbid0IHNlZSB0aGlz
IGlzIG1lbnRpb25lZCBpbiB0aGUgZ2l0aHViIGxpbmsgYmVsb3cgd2hpY2ggcmVwb3J0cyB0aGlz
DQppc3N1ZS4gIEluIGZhY3QsIGl0IHNheXM6DQoNCgnpnZ5idWfvvIzkuLvmnb9iaW9z5YWz6Zet
5LqGU0dY77yM5q2j5bi45YaF5qC45o+Q6YaSDQoNCi4uIHdoaWNoIGlzDQoNCglOb3QgYnVnLCB0
aGUgbW90aGVyYm9hcmQgQklPUyBkaXNhYmxlZCBTR1gsIG5vcm1hbCBrZXJuZWwNCm1lc3NhZ2UN
Cg0KQW5kIHRoZSBsaW5rIGFsc28gc2hvd3MgdGhpcyBpc3N1ZSBpcyAiY2xvc2VkIi4NCg0KUGxl
YXNlIGNsYXJpZnkuDQoNCj4gDQo+IEFzIGEga2VybmVsLCBpdCdzIGRpZmZpY3VsdCBmb3IgdXMg
dG8gZGlzdGluZ3Vpc2ggYmV0d2VlbiB0aGUgQklPUyBub3QNCj4gc3VwcG9ydGluZyBTR1ggYW5k
IHRoZSBCSU9TIHN1cHBvcnRpbmcgU0dYIGJ1dCBpdCdzIGRpc2FibGVkLg0KPiANCj4gVGhlcmVm
b3JlLCB3ZSBzaG91bGQgdXBkYXRlIHRoZSBlcnJvciBtZXNzYWdlIHRvDQo+ICdTR1ggZGlzYWJs
ZWQgb3IgdW5zdXBwb3J0ZWQgYnkgQklPUycgdG8gbWFrZSBpdCBlYXNpZXIgZm9yIHRob3NlIHJl
YWRpbmcNCj4ga2VybmVsIGxvZ3MgdG8gdW5kZXJzdGFuZCB3aGF0J3MgaGFwcGVuaW5nLg0KPiAN
Cj4gUmVwb3J0ZWQtYnk6IEJvIFd1IDx3dWJvQHVuaW9udGVjaC5jb20+DQo+IExpbms6IGh0dHBz
Oi8vZ2l0aHViLmNvbS9saW51eGRlZXBpbi9kZXZlbG9wZXItY2VudGVyL2lzc3Vlcy8xMDAzMg0K
PiBTaWduZWQtb2ZmLWJ5OiBaZWxvbmcgWGlhbmcgPHhpYW5nemVsb25nQHVuaW9udGVjaC5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IFdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPg0KPiAt
LS0NCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvZmVhdF9jdGwuYyB8IDIgKy0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2tlcm5lbC9jcHUvZmVhdF9jdGwuYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvZmVh
dF9jdGwuYw0KPiBpbmRleCAxNjQwYWU3NjU0OGYuLjRhNDExODc4NGMxMyAxMDA2NDQNCj4gLS0t
IGEvYXJjaC94ODYva2VybmVsL2NwdS9mZWF0X2N0bC5jDQo+ICsrKyBiL2FyY2gveDg2L2tlcm5l
bC9jcHUvZmVhdF9jdGwuYw0KPiBAQCAtMTg4LDcgKzE4OCw3IEBAIHZvaWQgaW5pdF9pYTMyX2Zl
YXRfY3RsKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykNCj4gIHVwZGF0ZV9zZ3g6DQo+ICAJaWYgKCEo
bXNyICYgRkVBVF9DVExfU0dYX0VOQUJMRUQpKSB7DQo+ICAJCWlmIChlbmFibGVfc2d4X2t2bSB8
fCBlbmFibGVfc2d4X2RyaXZlcikNCj4gLQkJCXByX2Vycl9vbmNlKCJTR1ggZGlzYWJsZWQgYnkg
QklPUy5cbiIpOw0KPiArCQkJcHJfZXJyX29uY2UoIlNHWCBkaXNhYmxlZCBvciB1bnN1cHBvcnRl
ZCBieSBCSU9TLlxuIik7DQo+ICAJCWNsZWFyX2NwdV9jYXAoYywgWDg2X0ZFQVRVUkVfU0dYKTsN
Cj4gIAkJcmV0dXJuOw0KPiAgCX0NCg0K
