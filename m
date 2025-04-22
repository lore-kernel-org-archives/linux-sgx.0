Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64F02367B7;
	Tue, 22 Apr 2025 07:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745306625; cv=fail; b=TZuZndKkq4ebWKxd+RNvLH4HEkKGlqvFfdZyS4Woz1CZl96RKLVAdGCOMhAE3tMxBl+l3cbWtQcCrwqGgHlmArGUNuY+hvfTJpcmWCfKUzUGUT9JiTcDVo0vI2VfnNC991H4RMJaj1j3JhBx+5dRB9xkEmwoRp446FWFi8oXGl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745306625; c=relaxed/simple;
	bh=lXGEQ5toh/tsHe5ZdMMf/tVVArpGiXXBWd/tbsUFyaA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ObrSVrPM5OGtPuJAuYeE1rmtItT8++uy56UKwV2Sh89aWUy6jUrgLpfb1FE475pv4+45HHMpe7XmtOVCZcCLV1sxSScg1LsaxtPK5m/sWXN2oJFUDFHCmaFWPdDe2UyidLKQ9qrxtvl+vO0cvKIlvkrl0AxoUf7Ld0isFbku5JM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ndzz1v1j; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ndzz1v1j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745306623; x=1776842623;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lXGEQ5toh/tsHe5ZdMMf/tVVArpGiXXBWd/tbsUFyaA=;
  b=ndzz1v1jRub3s7aV4puZc3vwlNbZqwdQKwGqiUqi5+N6suyun6KG7TR5
   E7vrca5UPLrUHcvF4YHVHy6ZldV0/ramlRQelOZLwG9Si0m6go+4OZlol
   qy1VUBE77gf0PN6lxNETlxNCQsLdGxfpu3VDRPE4htTSc5tYTPC6cKEnF
   K/gJ30z+SpTKVUPUobAQe1Gijq6358NUMfbc9BrMWPfhdzMfXOGiiUnEf
   N85hcbKbMii5ubeLOGBQU3BqdloGW7hq2uqEiCsfft0Im4yXfAOFMx+L/
   30hBYw6F7R8xcJ4Hyz28CTWWbaTGn16cpP9KyB6t3JG6ac8+LydNRRsAJ
   Q==;
X-CSE-ConnectionGUID: QcrjJBIcQQyhaAoxppvb+A==
X-CSE-MsgGUID: 2LXcO6KzSgupTYJqQiIjzw==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="57515143"
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="57515143"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 00:23:41 -0700
X-CSE-ConnectionGUID: sqfuMoXIQa23IVdRSa6czw==
X-CSE-MsgGUID: K0OV8kQYSSW86ZW3igsOIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="132812870"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 00:23:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 00:23:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 00:23:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 00:23:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CwmzHrZPc66MPDESt0Rrc+HEFobvrYQP8iVpIzFruw7j4mVyXhOJSELYjhsrTQHvWVsQbGIytrtLStbafiI9IEMIDWKbJU0oEgthxyhAnwlCDnj+qEWlFqQrDJ9MplAWLZPAHVx0Xf8aBy7YQC7fIM6F4Wvz5LEGduR1x6rIvATEocRKzvFPa+93hGl/6W8qrGRbZdi91oumadgALkNiBlqf74qhEw2j2ZIE/eJ93M0dgOCUCrKZJSIlOfn2LQhmZ22ZSA7AGpkb5xUxzJJ+FRwxolfoTzkItg9BDgq5omBAmRunDRNAZI4Pj5K6iHuxW0z+7BuQ3AcAHTr3QCRr2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXGEQ5toh/tsHe5ZdMMf/tVVArpGiXXBWd/tbsUFyaA=;
 b=TOQLpi7QbhXghXXafGTEk9T2gFZHQSs9jEVpjTmaCcJHd2iKc4/CwtKSxxLJ7RoUNF7xKg/eMr7qyvSpWU6fmFSFM4/PJBDsF9XJmjSD1tv6vo2/uJm7fzy2qEGGWnzehmIE0JAm7jg4pWsSIRpXVVp/je44T/wD2N5/8bdNJ01GRaV0phmIDO2cTGpNEdJvwtPulwO+TeDsJAV/Ga+TTwynbAEhllq92I9Lrn+HknkQSvklsuHLTz7/Bhjv803poHJ7peMN3sGtOH5ZEOrK6nmPMoDA8b7GnaZOuyf6CCTzanUXAaXz8oW2ov/cF1fMNSJg0bfQn+Kj03r9Vb6uWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4714.namprd11.prod.outlook.com (2603:10b6:303:5d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 07:23:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 07:23:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Cai, Chong" <chongc@google.com>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bondarn@google.com" <bondarn@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbrfz+Y/CHaQuxfEeQ0lhbNBYyWLOph/QAgAXK4oA=
Date: Tue, 22 Apr 2025 07:23:17 +0000
Message-ID: <f5cb3c37589791b2004a100ca3ea3deb9e1ae708.camel@intel.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
		 <20250415115213.291449-3-elena.reshetova@intel.com>
	 <aAJn8tgubjT5t7DB@google.com>
In-Reply-To: <aAJn8tgubjT5t7DB@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4714:EE_
x-ms-office365-filtering-correlation-id: fb4014a0-b000-4ae0-df3b-08dd816e8d89
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z2ExRlU3RVlJNHk3STBJR1A5LzV5OWRPbldUZCtVTTEyUHRkSytGSVVDN21n?=
 =?utf-8?B?aDdtTGlqSisvQVQ4c0s4M2VERHRzNm5pa0RqeGF6SHRSbzRScm1aNmpUZ2Fk?=
 =?utf-8?B?SmoxMjJZcVdMUHljM2NNNkFlcVVIMm1FQTZGM3RmVlJrS3NXNlk4OENFanIx?=
 =?utf-8?B?Z0g0UU4rRjVOUklzNVJRMjBxVWpmL0dzWEtQU2MwUFJoYklvR3Y4dFAvVVFQ?=
 =?utf-8?B?NnRBWFkzeEpKaTI4Qmx6VU9FUHpCMWJPNFBaZ3ZmRUhESEczbENiU3JtNjJK?=
 =?utf-8?B?dmwyUXBsNndrM1FsQTZWVmpRZDJHeHRpNlRlb3BYM2hHb2d2V2xjd3hoOStM?=
 =?utf-8?B?VG1INVZFVmJITU1IWEhSM09jMkNBUEZiYWxuMUFqODdxTkJYM0xTb2tNS0hH?=
 =?utf-8?B?Y2c1VWlyUjJVOG5Gci9jemVZNm0wT3JOSndoVDBjWmtSZXVYMkQzY0R5Y0p1?=
 =?utf-8?B?R2xMcWludVpBbkMzRXlGb3Y0NXNNeW13MTVwd0MyZmpYSVdjeDAzRzJ5YXR4?=
 =?utf-8?B?OHRyWEQ4aG9SZjJYdzRUVlRKQTUrU0MyZEMwRUJXZk04S3RGS010dTFWdzJC?=
 =?utf-8?B?T01zK29sakRnQmlKR3lZNXBtZVVrT0xWOWthdUtsSDlRazJabmtENi9NYWww?=
 =?utf-8?B?aEFKOXJVZ1ozVCtVMkVIZ2h5eHFnb20zUHpXZ2t6cFQ1azNObmpVVit1T3dZ?=
 =?utf-8?B?M2NFd0srYlRlSWpUak1KT1pJb2czOHdFOXNRV2R1WVRpU1ZOMkUxTlI5VTgv?=
 =?utf-8?B?TjkyWThIVjAwaE81SU0xU2x0RjN3aVRVYzJqNXkydDFlYzFIaGdzaWlkU3JX?=
 =?utf-8?B?enlnN2YzVVRzb1FaU25jMVphQVJucUdWMG16c2k0Yis3QWtrQUN6TzQ0MVc3?=
 =?utf-8?B?WDhIeTRnUGw4Ri8vbVI1RFJxVTVFbEduVk5JS0wyNG5PZDFISlVCeE1maHhJ?=
 =?utf-8?B?N0N4WTlIM1BhdTBuM1hoNmFpeWlPcW9GcThJWkZlRmpuV3NwdGF3K3FKTGFH?=
 =?utf-8?B?YlI3UUV6Y1NycThIY1NXVGI0YjZMYzVCemNZbnJIWm9Jb2R1TE0yeUhSRW14?=
 =?utf-8?B?d0ZLSS9BUU1WZGI1S08rMTVadi93Zzh4b3dPMEd4bUxCRDJOVldjY1FpQzEr?=
 =?utf-8?B?YWZXcVlLWXlvRndMSjI3VjhEOEZ5QlhwS08xYnRpUHZ3WHpxWmxhR1N2b2l3?=
 =?utf-8?B?eUZiV21LeGdsS1BBU2w2TmMycmRKT1B2TjFSRXd3K3k1eHU3TEszdVNHMUpx?=
 =?utf-8?B?Mjl4dmo1ZnpYR2pGOVE4aXJUQ0N3ejZNQlh2S2h4U0FkVnAxV0ZKWjBVdjR0?=
 =?utf-8?B?SEpkOUVzcXc0WjkzWitONDdlODlBbUQ1bnZ2RXhjU0UrenljYTBGRWx6TE5a?=
 =?utf-8?B?MENremtKM0FVakExVEpDeDZYVXkrZWl3K3ppa05VNHl4SEtzZm50OVlTSW5v?=
 =?utf-8?B?dGdXVzVKeHFLRkpUOWh0Mk10RlBuZll4dUljMkhRSk1jcHpBS0xHWEJyeFcz?=
 =?utf-8?B?eUgxNWVUdkNQOWo4ZzlMRHVmQkdLMU14SUNsSURxTE5NczR4MWJTaVZUdGxi?=
 =?utf-8?B?R3FtdW43Rkw1YVNSRE9MbXV6RnlVV2trMjIvVGZnbys5N3JoMzh3QnJzWUdB?=
 =?utf-8?B?L0FDRHRYVUFHTXlic284T1poTzVBeEptQWo0Q1Q5eGdnVlFMS201ODNReE45?=
 =?utf-8?B?bm1HRVNGQ3RqN25ZRVp6TGt6R3c3QncvTDVhR3lGYUVnMjl0UHNpQnVNeE1m?=
 =?utf-8?B?bERwSFhPa3FKSHVOZ3NqVFhjcEs5cm9JY1hNdWFvMHdqbzA1d1dOSnFXbm5X?=
 =?utf-8?B?STJGOHVrQWlXNzVsTUVDMmp3eHhXTHlGbjZ1TjA1UFdibnNxbllQSjdUNmV6?=
 =?utf-8?B?aURMYk51cURraGZOR0RQVXVQV1dIZ01pNnhDVzcrN1BJSlh4MEU4bGgxb0hw?=
 =?utf-8?B?Y1RZOHJ4OEtwcWtBVWd5b2NKN045NlNEakdrRlA0Y2NOZktyMzU1aTdOYUcz?=
 =?utf-8?Q?GRA1M5OUTIK6h8kytBsrlED++xrQ3k=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3BvYk5Gd2tUbVN4QU0yeExiSi9vNzRERmRFVC94cFQzTG9ZVFI1OVZndUdw?=
 =?utf-8?B?TFJ6M3ptdVhHem5FS25HampaenFTRnJUTmo0ZW1TaGthZnJWK1JHbkNQYXBH?=
 =?utf-8?B?bzFxQ05BM2lyZXdxQ05ENFZCbTRXTFdUUDFVVXNhR1R6bFI5UXRaWVA0SDBH?=
 =?utf-8?B?YlhUN294cU43d2p4dUIrMWh6SklLVE9CdDY2UWFsWTQ0SnN0bG5xaGxhYi9C?=
 =?utf-8?B?U1lMN1FpMG5YaXlCQ2Faek9PWi9MdDBGYlEzdnh2WmpDN1BFc2NTaUVUdWFE?=
 =?utf-8?B?Z01zYW44bXlaZmE1Uk9FNk5aem0xc0xSZUVVTDFqN3JqMGtIVks4K2xEaUM0?=
 =?utf-8?B?SGNaK1M3b2c3aGkxN1NkckZlMEdPeE9WVVB5VXNYOXJ2aHYvV3NpWlZoM0Rj?=
 =?utf-8?B?cUtsWjRBQWVSdlVyZjZPbDR1bXVNTE1OS1M4ZGY1NUREMjEzbW0rb2JZa0hC?=
 =?utf-8?B?dXN4dGFzY3craVlMQzJidFlqY3N3eHlZbyt0bEZLYnJRaVQ2Wno5a0ZvSDlS?=
 =?utf-8?B?V1ErR2ZCV2VXTS9PQUY3QlJ2bkNrcmMrQy85b3R0aytnemUzYUVIODhvSkJl?=
 =?utf-8?B?Um02ZEFWUGRXRWt3S1Y1ZTE5UTY5TytiSjJveWVNd1FpVndlTk01ZkFxVGpK?=
 =?utf-8?B?aVFFYkhrOTE5MjQ2M0dLZzAwU3VQb1R3ZWo3U2tjYmYwM2o3S1hLdXpzMDQr?=
 =?utf-8?B?d1E3WmxEd3hrZHZDcWhUTEdMOHBPc3NYMG9KTzhDN04yWW5nc3VsTjg3eEt5?=
 =?utf-8?B?Y0ZZSkNtT2hyVWRBR3pvdnZ5QTh3QXMzNHV0RjJFVG1MMlBFOXhPSHIweExF?=
 =?utf-8?B?UDh2U3BtVWNQcHVoN2VYWnZWVFdCc3dSU1JhbmV0WnN1RWxKWTA2c1ZwTk5l?=
 =?utf-8?B?d1dBUjgwOGo4bE1mY3d1cVhpdnVtOXQ4Y2cyUTlqcjc2OGpydTIrMmRoVnF4?=
 =?utf-8?B?NXg1bHNzc0NkQnVmWXlKaHpzaCtJT01JWmo5ZS9OS3hrT2RxL213a2lYQXZ6?=
 =?utf-8?B?cmZXR0lVSUJSL01nZlpieG9qWVdheGtaOUcyMFVORzVQcGx6dFRHZFdoWEVp?=
 =?utf-8?B?eFF5Y3VYVWorbjZUS1R1WVcyVWR1cHJnSjZ6eTNIcUVTQWtUMzJzSnFNZ1pq?=
 =?utf-8?B?dEFnbTJYNkdZaEJPeWorVndPUlpOTi9nU05tWkxBMG8yK09tVkEwT0NIMVBM?=
 =?utf-8?B?QzZpTDQwY1VrbDM0dWRvNVlNcDNPU0pxMUNuNVZJcEs5NkdVSFU1Z3dJK1lB?=
 =?utf-8?B?TktlZ05qY0x4bW0vbXpCZkRHWGpBYkk5bnBGb21MaTJSNXNMNFpJY2ZaMlk1?=
 =?utf-8?B?QWgrdndkdDhLNzNDLzlCdGRneFZTVVY5Qy9uWCsxOVJ0QTRicFRSK2UyS0pp?=
 =?utf-8?B?NUhzbGNGVVYrR2REdmFjRmJrMVdoRklJQzFSajFmL3Qrc1NsTDM3NXZEMzRp?=
 =?utf-8?B?aW5Ea3czRUlReVJValZ0cVdSSk1vVlh0bE9sMGRXSXVZbU9mTWd0OXZQZmpz?=
 =?utf-8?B?QWJXTm55cjJJbEN2dEFmZ0RnbWhDd3FJUloxTXRneXAxZWpsekltRTBFMlVu?=
 =?utf-8?B?a0paY1J2QnhMeDlPNWplZXhIOFBCaDJtU25seDA1SEJHYzVYT21WREUxWmhS?=
 =?utf-8?B?cXQyVHFmT0NidGlISFdESVMxb3d3MWZidFJCMmpHZEN4anJlbjBNLzAyd3FN?=
 =?utf-8?B?MElWYWg3M0xuVlIwN3JaN1RpbzJsd3JLTEtCaEhFejBKUEoxeXFjTEs5dzAz?=
 =?utf-8?B?OTZGaE5iWG9XWDBSNmdwYnlZTVFuWGtFbytmUXZrcDFYbDhtZkxoRTcyelg0?=
 =?utf-8?B?OE9McVJmZXRxMHRaVGpzZE5JcEdHSkVHNDdjQzdsam5sZ1JBQ3ZkSi9xeEdv?=
 =?utf-8?B?UHBPZlY3VEMwZzhiOVpMQVpWSDZobHlnK05mYzR1SEZkMmxIS0hFd0UxVkJq?=
 =?utf-8?B?cmxBZGhSWDh2ekdOZWdKNU90SFBwWmlONmo1VmNzYU9RcU5zRXp6aDNwaU5q?=
 =?utf-8?B?TS96TGYwWXFHQzluay9tRTFIN2pRUWdHMURlQzUzRitrSEY3WVZxZFBaeXNR?=
 =?utf-8?B?UXBVWVM4YlNVU3lwNnNlWXowSERxMGF3V2pocmk0T0tJcFI1dmRWcDNCZVBu?=
 =?utf-8?Q?6Y8rfU/zhfpTqEAXbfhjlDXA4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9A86888DCB6A241880897A9C8FE548A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4014a0-b000-4ae0-df3b-08dd816e8d89
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 07:23:17.7350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m1CIxK1qTKwQmAnfLSz/O7NtPGYpQl2j9+aDpYhooeAZUf8vIe6GuJ1i+LlsF3/phU1Y+9o53YAmJofwoescUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4714
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA0LTE4IGF0IDA3OjU1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEFwciAxNSwgMjAyNSwgRWxlbmEgUmVzaGV0b3ZhIHdyb3RlOg0KPiA+
ICsvKiBUaGlzIGxvY2sgaXMgaGVsZCB0byBwcmV2ZW50IG5ldyBFUEMgcGFnZXMgZnJvbSBiZWlu
ZyBjcmVhdGVkDQo+ID4gKyAqIGR1cmluZyB0aGUgZXhlY3V0aW9uIG9mIEVOQ0xTW0VVUERBVEVT
Vk5dLg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIERFRklORV9TUElOTE9DSyhzZ3hfZXBjX2V1cGRh
dGVzdm5fbG9jayk7DQo+ID4gKw0KPiA+ICBzdGF0aWMgYXRvbWljX2xvbmdfdCBzZ3hfbnJfdXNl
ZF9wYWdlcyA9IEFUT01JQ19MT05HX0lOSVQoMCk7DQo+ID4gIHN0YXRpYyB1bnNpZ25lZCBsb25n
IHNneF9ucl90b3RhbF9wYWdlczsNCj4gPiAgDQo+ID4gQEAgLTQ0NCw2ICs0NDksNyBAQCBzdGF0
aWMgc3RydWN0IHNneF9lcGNfcGFnZSAqX19zZ3hfYWxsb2NfZXBjX3BhZ2VfZnJvbV9ub2RlKGlu
dCBuaWQpDQo+ID4gIHsNCj4gPiAgCXN0cnVjdCBzZ3hfbnVtYV9ub2RlICpub2RlID0gJnNneF9u
dW1hX25vZGVzW25pZF07DQo+ID4gIAlzdHJ1Y3Qgc2d4X2VwY19wYWdlICpwYWdlID0gTlVMTDsN
Cj4gPiArCWJvb2wgcmV0Ow0KPiA+ICANCj4gPiAgCXNwaW5fbG9jaygmbm9kZS0+bG9jayk7DQo+
ID4gIA0KPiA+IEBAIC00NTIsMTIgKzQ1OCwzMyBAQCBzdGF0aWMgc3RydWN0IHNneF9lcGNfcGFn
ZSAqX19zZ3hfYWxsb2NfZXBjX3BhZ2VfZnJvbV9ub2RlKGludCBuaWQpDQo+ID4gIAkJcmV0dXJu
IE5VTEw7DQo+ID4gIAl9DQo+ID4gIA0KPiA+ICsJaWYgKCFhdG9taWNfbG9uZ19pbmNfbm90X3pl
cm8oJnNneF9ucl91c2VkX3BhZ2VzKSkgew0KPiANCj4gRldJVywgdGhlIGVudGlyZSBhdXRvbWF0
aWMgc2NoZW1lIGhhcyB0ZXJyaWJsZSBiZWhhdmlvciB3aGVuIEtWTSBpcyBydW5uaW5nIFNHWA0K
PiBjYXBhYmxlIGd1ZXN0cy4gIEtWTSB3aWxsIGFsbG9jYXRlIEVQQyB3aGVuIHRoZSB2aXJ0dWFs
IEVQQyBpcyBmaXJzdCB0b3VjaGVkIGJ5DQo+IHRoZSBndWVzdCwgYW5kIHdvbid0IGZyZWUgdGhl
IEVQQyBwYWdlcyB1bnRpbCB0aGUgVk0gaXMgdGVybWluYXRlZC4gIEFuZCBJSVJDLA0KPiB1c2Vy
c3BhY2UgKFFFTVUpIHR5cGljYWxseSBwcmVhbGxvY2F0ZXMgdGhlIHZpcnR1YWwgRVBDIHRvIGVu
c3VyZSB0aGUgVk0gZG9lc24ndA0KPiBuZWVkIHRvIGJlIGtpbGxlZCBsYXRlciBvbiBkdWUgdG8g
bGFjayBvZiBFUEMuDQo+IA0KPiBJLmUuIHJ1bm5pbmcgYW4gU0dYIGNhcGFibGUgVk0sIGV2ZW4g
aWYgdGhlcmUgYXJlIG5vIGFjdGl2ZSBlbmNsYXZlcyBpbiBzYWlkIFZNLA0KPiB3aWxsIHByZXZl
bnQgU1ZOIHVwZGF0ZXMuDQo+IA0KPiBVbmZvcnR1bmF0ZWx5LCBJIGNhbid0IHRoaW5rIG9mIGEg
c2FuZSB3YXkgYXJvdW5kIHRoYXQsIGJlY2F1c2Ugd2hpbGUgaXQgd291bGQNCj4gYmUgZWFzeSBl
bm91Z2ggdG8gZm9yY2UgaW50ZXJjZXB0aW9uIG9mIEVDUkVBVEUsIHRoZXJlJ3Mgbm8gZGVmaW5p
dGl2ZSBFTkNMUyBsZWFmDQo+IHRoYXQgS1ZNIGNhbiBpbnRlcmNlcHQgdG8gZGV0ZWN0IHdoZW4g
YW4gZW5jbGF2ZSBpcyBkZXN0cm95ZWQgKGludGVyY2VwdGlvbg0KPiBFUkVNT1ZFIHdvdWxkIGhh
dmUgdGVycmlibGUgcGVyZm9ybWFuY2UgaW1wbGljYXRpb25zKS4NCj4gDQo+IFRoYXQgc2FpZCwg
aGFuZGxpbmcgdGhpcyBkZWVwIGluIHRoZSBib3dlbHMgb2YgRVBDIHBhZ2UgYWxsb2NhdGlvbiBz
ZWVtcw0KPiB1bm5lY2Vzc2FyeS4gIFRoZSBvbmx5IHdheSBmb3IgdGhlcmUgdG8gYmUgbm8gYWN0
aXZlIEVQQyBwYWdlcyBpcyBpZiB0aGVyZSBhcmUNCj4gbm8gZW5jbGF2ZXMuICBBcyBhYm92ZSwg
dmlydHVhbCBFUEMgdXNhZ2UgaXMgYWxyZWFkeSBhbGwgYnV0IGd1YXJhbnRlZWQgdG8gaGl0DQo+
IGZhbHNlIHBvc2l0aXZlcywgc28gSSBkb24ndCB0aGluayB0aGVyZSdzIGFueXRoaW5nIGdhaW5l
ZCBieSB0cnlpbmcgdG8gdXBkYXRlDQo+IHRoZSBTVk4gYmFzZWQgb24gRVBDIGFsbG9jYXRpb25z
Lg0KPiANCj4gU28gcmF0aGVyIHRoYW4gcmVhY3QgdG8gRVBDIGFsbG9jYXRpb25zLCB3aHkgbm90
IGhvb2sgc2d4X29wZW4oKSBhbmQgc2d4X3ZlcGNfb3BlbigpPw0KDQpUaGUgb25seSB0aGluZyBJ
IGRvbid0IGxpa2UgYWJvdXQgdGhpcyBpcyB3ZSBuZWVkIHRvIGhvb2sgYm90aCBvZiB0aGVtLg0K
DQo+IFRoZW4geW91J3JlIGhvb2tpbmcgYSByZWxhdGl2ZSBzbG93IHBhdGggKEkgYXNzdW1lIEVV
UERBVEVTVk4gaXMgbm90IGZhc3QpLMKgDQo+IA0KDQpJIHdhcyBleHBlY3RpbmcgdGhlIFNHWF9O
T19VUERBVEUgY2FzZSBzaG91bGQgYmUgZmFzdCwgaS5lLiwgc29tZSBzb3J0IG9mIHNpbXBsZQ0K
Y29tcGFyZSBhbmQgcmV0dXJuLCBidXQgbG9va2luZyBhdCB0aGUgcHNldWRvIGNvZGUgaXQgc3Rp
bGwgcmUtZ2VuZXJhdGVzIHRoZQ0KQ1JfQkFTRV9LRVkgZXRjLg0KDQo+IGVycm9yDQo+IGNvZGVz
IGNhbiBiZSByZXR1cm5lZCB0byB1c2Vyc3BhY2UgKGlmIHlvdSByZWFsbHkgd2FudCB0aGUga2Vy
bmVsIHRvIGZyZWFrIG91dCBpZg0KPiBFVVBEQVRFU1ZOIHVuZXhwZWN0ZWQgZmFpbHMpLCBhbmQg
eW91IGRvbid0IF9oYXZlXyB0byB1c2UgYSBzcGlubG9jaywgZS5nLiBpZg0KPiBFVVBEQVRFU1ZO
IHRha2VzIGEgbG9uZyB0aW1lLCB1c2luZyBhIG11dGV4IG1pZ2h0IGJlIGRlc2lyYWJsZS4NCg0K
U2VlbXMgcmVhc29uYWJsZSB0byBtZS4NCg0KPiANCj4gPiArYm9vbCBzZ3hfdXBkYXRlc3ZuKHZv
aWQpDQo+ID4gK3sNCj4gPiArCWludCByZXRyeSA9IDEwOw0KPiA+ICsJaW50IHJldDsNCj4gPiAr
DQo+ID4gKwlsb2NrZGVwX2Fzc2VydF9oZWxkKCZzZ3hfZXBjX2V1cGRhdGVzdm5fbG9jayk7DQo+
ID4gKw0KPiA+ICsJaWYgKCEoY3B1aWRfZWF4KFNHWF9DUFVJRCkgJiBTR1hfQ1BVSURfRVVQREFU
RVNWTikpDQo+ID4gKwkJcmV0dXJuIHRydWU7DQo+IA0KPiBDaGVja2luZyBDUFVJRCBmZWF0dXJl
cyBpbnNpZGUgdGhlIHNwaW5sb2NrIGlzIGFzaW5pbmUuICBUaGV5IGNhbid0IGNoYW5nZSwgYmFy
cmluZw0KPiBhIG1pc2JlaGF2aW5nIGh5cGVydmlzb3IuICBUaGlzIHNob3VsZCBiZSBhICJjYWNo
ZSBvbmNlIGR1cmluZyBib290IiBzb3J0YSB0aGluZy4NCg0KQWdyZWVkLg0KDQo+IA0KPiA+ICsN
Cj4gPiArCS8qDQo+ID4gKwkgKiBEbyBub3QgZXhlY3V0ZSBFTkNMU1tFVVBEQVRFU1ZOXSBpZiBy
dW5uaW5nIGluIGEgVk0gc2luY2UNCj4gPiArCSAqIG1pY3JvY29kZSB1cGRhdGVzIGFyZSBvbmx5
IG1lYW5pbmdmdWwgdG8gYmUgYXBwbGllZCBvbiB0aGUgaG9zdC4NCj4gDQo+IEkgZG9uJ3QgdGhp
bmsgdGhlIGtlcm5lbCBzaG91bGQgY2hlY2sgSFlQRVJWSVNPUi4gIFRoZSBTRE0gZG9lc24ndCBh
Y3R1YWxseQ0KPiBzYXkgYW55dGhpbmcgYWJvdXQgRVVQREFURVNWTiwgYnV0IHVubGVzcyBpdCdz
IGV4cGxpY2l0bHkgc3BlY2lhbCBjYXNlZCwgSSBkb3VidA0KPiBYdUNvZGUgY2FyZXMgd2hldGhl
ciBFTkNMUyB3YXMgZXhlY3V0ZWQgaW4gUm9vdCB2cy4gTm9uLVJvb3QuDQoNClRoZSBzcGVjIGlz
IGhlcmU6DQoNClsxXSBodHRwczovL2NkcmR2Mi5pbnRlbC5jb20vdjEvZGwvZ2V0Q29udGVudC82
NDg2ODI/ZXhwbGljaXRWZXJzaW9uPXRydWUNCg0KQW5kIGZyb20gdGhlIHBzZXVkbyBjb2RlIGl0
IGRvZXNuJ3QgZGlzdGluZ3Vpc2ggcm9vdCB2cyBub24tcm9vdC4NCg0KPiANCj4gSXQncyB0aGUg
aHlwZXJ2aXNvcidzIHJlc3BvbnNpYmlsaXR5IHRvIGVudW1lcmF0ZSBTR1hfQ1BVSURfRVVQREFU
RVNWTiBvciBub3QuDQo+IEUuZy4gaWYgdGhlIGtlcm5lbCBpcyBydW5uaW5nIGluIGEgInBhc3N0
aHJvdWdoIiB0eXBlIHNldHVwLCBpdCB3b3VsZCBiZSBwZXJmZWN0bHkNCj4gZmluZSB0byBkbyBF
VVBEQVRFU1ZOIGZyb20gYSBndWVzdCBrZXJuZWwuICBFVVBEQVRFU1ZOIGNvdWxkIGV2ZW4gYmUg
cHJveGllZCwNCj4gZS5nLiBieSBpbnRlcmNlcHRpbmcgRUNSRUFURSB0byB0cmFjayBFUEMgdXNh
Z2UNCg0KSSBhbSBvcGVuIHRvIHRoaXMgSFlQRVJWSVNPUiBjaGVjaywgYmVjYXVzZSBJIGRvbid0
IHRoaW5rIHdlIGN1cnJlbnRseSBzdXBwb3J0DQphbnkga2luZCBvZiAicGFzc3Rocm91Z2giIHNl
dHVwPyBBbmQgZGVwZW5kaW5nIG9uIHdoYXQga2luZGEgb2YgInBhc3N0aHJvdWdoIg0KdHlwZXMs
IHRoZSB0aGluZ3MgdGhhdCB0aGUgaHlwZXJ2aXNvciB0cmFwcyBjYW4gdmFyeS4NCg0KQW55d2F5
LCBJIGFncmVlIGl0J3Mgbm90IG5lY2Vzc2FyeSB0byBoYXZlIHRoaXMgY2hlY2ssIGJlY2F1c2Ug
Y3VycmVudGx5IGl0IGlzDQpub3QgcG9zc2libGUgZm9yIGEgZ3Vlc3QgdG8gc2VlIHRoZSBFVVBE
QVRFU1ZOIGluIENQVUlELg0KDQoNCg==
