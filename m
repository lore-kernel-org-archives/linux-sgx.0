Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586FE2C80;
	Mon, 24 Mar 2025 12:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742818367; cv=fail; b=SbKWwUIOCg8+MVruiwyZJZu8mNtuhyG0nFBhizs8ydBuYKF5EkjlvOrL+4cJCIMDQljlINTCQZw6Ejjba+L0hqH2yShh0t5+40zuSV/MVGgePpqLxWfGGFAioMSLZOaN2MXPwSAqg3r+g8Vcz0RFY1mAsHCqNU9CuU/o2Yozga0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742818367; c=relaxed/simple;
	bh=C7KXBcdcEmeBDRgt6jf/qE9QXsNthM7i+3+1+u2TZWQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=irKcjMBdmwu4Zssy0oW8fHcCYwU2We3RQ26b+bjgaN0v5St3ejNvu1RobXNknzN/JitLtFghALe6NArGqTyQKqZ3V44AcRaZXcH8m9rrR0wzDfx2S+AMtUieUsVSAD3ZcSg/jlXHfW6R1ANyvGaFnhef6iW0NPcxrKcGkd4i1VI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JZgKY52U; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JZgKY52U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742818366; x=1774354366;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C7KXBcdcEmeBDRgt6jf/qE9QXsNthM7i+3+1+u2TZWQ=;
  b=JZgKY52UwP2mqSDBRZrZrvLY8zwiXZMQdLsSTE5mtROJMykHJi3Ii2lz
   DjGavrC0T0EB05CiPE+BxDiEZ2yGYUsG+G27Rc7LQR7wgvskRvcJ7f3L5
   8Sol5kCucOJKSBPC5RTe9nOAHb65dEW3qclEUYZmT5UPp6XpNv2BV6r5B
   5FWe5jsCo+Pve2uio+6MzXRzUNRbkg7fTQHXdbPv95SkaPKgcxLoKbsWC
   rYE7XTgGzhZNXG6zDk4hT/qYCcQMzibUJvtWamuDen5701KKiMSMbzage
   noic+uHN2oMEIyZes1QmVsDW7AGd7CxyfQJ3Oc3zwqmyb3n7iLrTKzVxn
   Q==;
X-CSE-ConnectionGUID: cTU14kV7SeKIlR+pNbvn+g==
X-CSE-MsgGUID: IFXAq/alSxihf8Lne7K80g==
X-IronPort-AV: E=McAfee;i="6700,10204,11383"; a="61541371"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="61541371"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 05:12:45 -0700
X-CSE-ConnectionGUID: yhvgg0aDQ8+Tlgcth5nGIw==
X-CSE-MsgGUID: u6jUR4Y8RaKZ5M8n5zU+EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="147235037"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 05:12:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Mar 2025 05:12:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 24 Mar 2025 05:12:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Mar 2025 05:12:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o4C5jWlLwRjWiR5frVzXPrPYQZDLit9kmt6yP4+1PbTrC7y5CTRdWfkN1sSe0Y/BAaBELmPAWWBTiDuektokK42ei5YPTUyR+oEAEPDKXDcT74RvCI2oYSBgwd94z5Kn0Kc5odJMTrYfxGDvb4+H4UOJ7tLluFm1vy2d/R3Qaylf0lHr5N7C3DrshfJ3hCmY6KsdNlr69E4nCPIIEGDJsCJ8KHA6+bP+gShBno5jryVK1jINGZmG87yZb49bkLHdmrt9e89Wa3jKOBf9zGoC1zDZI9Rw9tL1Wsr5ECegO6rHQ3DYcx3idwRBqIx8W5jQmepiWLwT1fcwJtVK/EYTeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C7KXBcdcEmeBDRgt6jf/qE9QXsNthM7i+3+1+u2TZWQ=;
 b=mAvqam0kv96dJz4clUnhNZaa2QbccUwBtsWqdQ+VLRSTVwcpLw8gLVaHVxu0fYHKCAEIOU5JWqRH2ap/5aPG6FsrKYFJcx1mY92ztkobeJBWKKtaBc1N0GA1SjRGrVxNSNWxFiGINdfNS2H8bhiBhA7GIbmhzcPVxCrkXRcUBOctkbZEmKWGW6vJ2omj3K/jI3DUpAwIOr4XMqM6y222rmFazUUFlYr3oAtmhgxbqn2gTc4EINYjpCoEEj4LBkROjvbp5ZwUHS7x9xRAR/4sSs2Q707qX1kxV1bC4wEReiyBbNmjpPC5hNJIZKAK6CQIJty7OaKeha601t3pEXS9yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CY8PR11MB7194.namprd11.prod.outlook.com (2603:10b6:930:92::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.42; Mon, 24 Mar 2025 12:12:41 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 12:12:41 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>
Subject: RE: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Thread-Topic: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Thread-Index: AQHbml52rO5WRn4U4UWiUGJJakHgYrN/tmkAgAJ/A3A=
Date: Mon, 24 Mar 2025 12:12:41 +0000
Message-ID: <DM8PR11MB57508A3681C614C9B185B04EE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-2-elena.reshetova@intel.com>
 <Z98yki-gH4ewlpbP@kernel.org>
In-Reply-To: <Z98yki-gH4ewlpbP@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CY8PR11MB7194:EE_
x-ms-office365-filtering-correlation-id: 542f5f17-4ec5-4eb4-9acb-08dd6acd2d1e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZDhpZHJZeUtvMHVHbHY4REFFeDlwU1ROR1V1dTRLcmh1QmowN0dhaHlSMjdu?=
 =?utf-8?B?ZWtKSXJOM0t0dWhDeUgvZUZhNHkwNmo3bU5pTExhQjg3bkJUMHJsb3ErRlIw?=
 =?utf-8?B?S0hRMzA2YzZQemhCTm4yRlF2b3NFOUk0YWNMQ2NaR01CdFlWWm5xaFE3U3NR?=
 =?utf-8?B?RzU2MVFrUUV3K1hwMDlzL0xKdDdkOTBrOGgvNW0yTnFlNmZ2UUtWWFRxNGIy?=
 =?utf-8?B?ajdKcUFpMHVta05DZ1E5d1F5TnpEc1BaVmNYbGlicWZoYW1qZE9PL2dwcGYv?=
 =?utf-8?B?NFcvVE1mVzIwaTcrb1Fpd3Nwc2ZTaUJTMFpwbHlQZEFwTndVdHBhejl4UjQr?=
 =?utf-8?B?aGp0NXlHS0ZzSU5BQldUNzROdXkrSUhnNDZTekRkM3RacnVLQ3l6MjZiQTk4?=
 =?utf-8?B?a1lOdDY2eVRLeStnM3BSZ2ZVUURVNnk3RGNBaXZZTUc4elZXTjFCdUtSNTVG?=
 =?utf-8?B?MGZOWE1hejg1UGx3elJKRGNYMU5LZEx0a1IvczlFbmQ0cDRBNWN0SGY0YWpq?=
 =?utf-8?B?Zm1HeGxqbEpJMSttOVRORWtMS1g3OFo0NVZiQVdMendVQTRGY2JrcFZHVTUv?=
 =?utf-8?B?VTJiQ0tNM2lWbGxRcGNHRzhQL3RmMTFxQkJLT3V1am5rTVRzOVdVOFBmY2dG?=
 =?utf-8?B?OUxZQTNqOFlZYTh1Q3k2S3ZBT3pFWGZzc1R6Q2lhVno0SUVkSDNGampDR0dH?=
 =?utf-8?B?L0VrcmFiMCtmMlRzK21mKzVDNWpIaTRmandpRTRJVXJ5RWplSmtMTUZuMGx2?=
 =?utf-8?B?cStrOWtUSC9QV2F6UjJuQ3Uvcy90bFBYSUd1UEU4NXpDVkVOdU9oOHQ0azll?=
 =?utf-8?B?WFpkRitNdG5jRUJ1WXNHN05kbDZUUXJqR1F3UFNoQnhmbTV3dEkyeTZiSFF1?=
 =?utf-8?B?RWRkakMzd3RjSjVlNVV3UG9pYVZoTExLRVFRQU5mUGNTNXFkVkpUSFU4MGdj?=
 =?utf-8?B?ZC91czBGSVRkcUkxNWprQW85WmFJekxxbW9QQnFiZkE5YXE3OGdzQVFrOWNV?=
 =?utf-8?B?Nm5mN1ZsYWRsUUkrdEFwQUNpS2tYZjgxenc2S0hYTEp1V05Wdm9HeTNnUmdS?=
 =?utf-8?B?dGQ4NjVXSHhBUVR3Y2FKNmZaUUc2Q3pDZ0NyazB6QUUvenhxRlhpcFQzVzMw?=
 =?utf-8?B?WE1rKzd3c29QRzBpQkNBYU1GVVVsblF5YTd0K2gvSGxmOUI5RC93cDBlbkkr?=
 =?utf-8?B?RjE3RkFTRnpSM09kazUvY3N6ZlBFam5BZXJGQTkzeDAzQkR4S1NKTFh5K0JB?=
 =?utf-8?B?cUg4MTkyUHR0ekNMZFNzMUFDaTdWS1k0ZDJhdHFJbkl1MCtSOVJxcGxKWlVv?=
 =?utf-8?B?N0piOE9wQ0lFY1haVVlVSTNlOU9xK2dNK1BQNWdDbFcvQmg2Z0JTWm9KY2Uy?=
 =?utf-8?B?KzFIYWE5TUcrdG5DYktWbDBzeWhtQWZ2NW5zWVNwbmRlZ3p1bFpPNUJLN05t?=
 =?utf-8?B?K0did3Z0Ui96YVJrdHhvUVByWnAydXEvY1RFRUhteml6cWVUTTJmeUN6Q2dk?=
 =?utf-8?B?N040bDFkbU5ueWFYWGFYOEs0QVhjVFdmUTVvWlEvRVNRN2lKWjhPajI5S0FP?=
 =?utf-8?B?OHRBdWJIbDI3VFRHSFhucFVadVZ3NUdyenNoQlBwdm0vNnU2NWlNV3dUb3BJ?=
 =?utf-8?B?VG8zcDNlYjBlTitVMTk1SVRvWDZqTklERm1FWmgyT3hvanBjVEw5Tys1V0di?=
 =?utf-8?B?aW1qTGlUUitNQnRTV0NnU0xpQ2R2eWdhb2JGYlNibDhCSUxGOFVWZjJ4KzFj?=
 =?utf-8?B?Sk44Tm5PRStZclVuY2QvUzFqc2JBNnRTWnd5NnVnU2YyMkZYZnFsU2tINWRl?=
 =?utf-8?B?T256eUxlWmJ0MHkyVlR2eFRHby9lejJVZXE2dDIvRjNhSi9mTnBvTTllbFRr?=
 =?utf-8?B?eFplSEdUcGlyMklJMkNabnYzZHlLbFR4SVlKRVVJb2ZKd3ZwLzlBVXJZRHpV?=
 =?utf-8?Q?xSKQNYmAepKpVqtxN7Ew+/CW8nONGmN+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTdwKzZEeFdTcXdrc1A1RFdKNVVaMGNuaW51N1J3bmRUc2JvQnBsRktCcU9v?=
 =?utf-8?B?T0FRemF6b2pHU003cWRRSGFIejhSK252SE1wVkR2V0pzdlFBcEtPMWk2aHNT?=
 =?utf-8?B?YzFGNEVKaGJMMjh2L2dkSWxZUXBvMVp5Qy9LNXdtK1dFTUl0VXdWUXlVaWtO?=
 =?utf-8?B?Z041SjhBWm04L21yUlVUTnlpQTBkOHFhbHJ5ZHVXWUQ2NEdoeWo5c0FpN0Mr?=
 =?utf-8?B?bCszYVNodXFMaVhKQWlIWlMrUUc5aTFPU2V1RmNBSDFheHF4aGRUQk1IS1lQ?=
 =?utf-8?B?MXljSHM0endaRjlmSXNzL2xJRWtyL01HQWFIZDNaOFlZdkplclVxQ0xjYVpO?=
 =?utf-8?B?K3BoSU1VbEx5YVl0YTNGS1RHSXRsYWFOQ2VaV2FzNHB0ZmFqMkdWL05JV2FW?=
 =?utf-8?B?S2hmQU1ra2VBL3pCQ3RUWlJwcGhmOW16emFSVTB1YlNyQUxVcEhYaFV5ZEtx?=
 =?utf-8?B?VnIrSmQ5ZWhaTGdrblphVU42ZHFCeWhLV1NNVnN2UStsOGpIVnhwL0doN3Jh?=
 =?utf-8?B?U1VOVzU4bjZ2MHhRUjdLQ2RhdTZJaWpGQ0t4UC9nSzVmRW9PbWZIZHVTQzNQ?=
 =?utf-8?B?cUpFWE5hZE9Ra3c3aTV1bS9MSFprV2owU1hpbGJNUHBzdXR6bHR2dTdCeDNt?=
 =?utf-8?B?eTJNb3ZBcXRNdkU3RWFXSWpCNU43NThnb0l6UTdDTzkzdkM2QjN1eDk3Znpu?=
 =?utf-8?B?OHl5NEpDd3Fkc0NETHlFTGJMQ2lCUk5nS1ZyaFBiaURkZXltMitMa29pOVRV?=
 =?utf-8?B?TmJlV1R3K3I0MGV6S1FZL0F1aW5PeGxiTC9KSHVJRDYvYlpVZlFIYkd2YWVZ?=
 =?utf-8?B?SVN6cUpTbDdGL29aYUpVS3pUZE0zcXZpNVo3YzBPNk9YTkc1eFpSUzdRNEYw?=
 =?utf-8?B?eDMxOFplSXhDWDZTbnpQY0drZXU0NGpzM3BVdHU0b0RoeUF1ZU1GMllYejFB?=
 =?utf-8?B?aEYyVkNNb1h3VlFqS0JiMVRIamdya1lHeFZxbXorVXdVQVplNTBoanJGeDJM?=
 =?utf-8?B?cUZBVTB1ZWNtWGxCM2E4MDkxaThHWEtEN0tnY0IrZ2xuaDQyVFoyYmxUVWhR?=
 =?utf-8?B?Y3BFdXhVU2xXcE03SjdPTzNZVUNFN3FGL0FqYnFqV2liaWduN1U0eWRtYXdh?=
 =?utf-8?B?RUNva05oN0pKM0lhZFFPODFSYjM0aDJ4NFRPQzFhcUMybC9XcWNDbDhOMEdo?=
 =?utf-8?B?dFZTQnc0SzFGU1UxVDUvUFc3UmcxUmJDWk1TZWFjKzVId1JieFZ1TkxKYUFF?=
 =?utf-8?B?Vm1vUkRLL2JQeXNaQ0IwV2QveDk0bnQ0eVpQQlNQUGhEN2lKUkJ3azJrVnNX?=
 =?utf-8?B?UjFWNmVyNkxJNjljNGNlMkNRVmkrQ0MvYmIyZzh4SVNoaTBRS201QlZrQkR1?=
 =?utf-8?B?Z3E1aUxFcThwR0RxMXZ6b2h2QWtIWU85dmVYNDQyNzRKdzBYaklmSHBWeER2?=
 =?utf-8?B?SDdnWVZlZzEvS3VtMVNHMGxYRjhGcTUwTU15bjBwcWp2eng5ZWMxVXZCTG1N?=
 =?utf-8?B?MU1oNDVHRklobWEwQXhnMVVxazFtS0pPbHdkc2xOUllIcmRnV2pTVHowejFw?=
 =?utf-8?B?L0VUVnpCRWt1OHpCams2dUZBQ0MvMWRtNzY3aXdXcGt3QkNFVU9UbmpQNW50?=
 =?utf-8?B?amJNQVlEMWRGL0R0a3c3RHJJZEkwOWRrNEIyNW9qdncxNEpDRjRXbkRJS1lU?=
 =?utf-8?B?SkJOQ1FIMVZkUjZwRDdUdEtTSTJ5VVhSUUlvUjRFV2VoeTFUazhraEVJQ0xB?=
 =?utf-8?B?RVN4TUEwYmZOR3lQRnJwWjVqWmVnZDB6NXE5Z056Z2FEZGpDZ0p2MkZjWmNN?=
 =?utf-8?B?UjYyNldmZ2FjUkE4NFFpZGFDcFdYQ2M4WUovZ2VDbXZmbXgzK012Z2lRTmZw?=
 =?utf-8?B?R3pZenhjaGRDYVVOSDZKa2xmM0Y3Um5pejZlaE5IZm1zekhTRnp6M1JXRXlG?=
 =?utf-8?B?bDBqWUdYdmZySzhoR1JsN1puUjBwNGxNMExXaEcyYkxlbHRBTmprb0oydlA0?=
 =?utf-8?B?TmdzaE8vL0N2TGgzdGc5aFRCNWUvY0V3cm5KRFZvamZwRE52OE5ueTBzZWVG?=
 =?utf-8?B?aUZxVVdaaXZlVERGNFAwQmM5dkh5Qmc3M2FjdG1hNXZubzM4MlZ0UkxzekRr?=
 =?utf-8?Q?+tvt70ypwAFG5moTSzlgq6Vly?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5750.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 542f5f17-4ec5-4eb4-9acb-08dd6acd2d1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2025 12:12:41.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7KUEQG3tZS6hBBN6XLwpbdtIf7O3fecpeZNUM7usoHStAizOudYKQ51FtcS3/rC1lvrj7y7yeCvFE/0vEfp17HKG3RVMNVGSHA8YdcKQw58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7194
X-OriginatorOrg: intel.com

PiBPbiBGcmksIE1hciAyMSwgMjAyNSBhdCAwMjozNDo0MFBNICswMjAwLCBFbGVuYSBSZXNoZXRv
dmEgd3JvdGU6DQo+ID4gSW4gb3JkZXIgdG8gc3VjY2Vzc2Z1bGx5IGV4ZWN1dGUgRU5DTFNbRVVQ
REFURVNWTl0sIEVQQyBtdXN0IGJlIGVtcHR5Lg0KPiA+IFNHWCBhbHJlYWR5IGhhcyBhIHZhcmlh
YmxlIHNneF9ucl9mcmVlX3BhZ2VzIHRoYXQgdHJhY2tzIGZyZWUNCj4gPiBFUEMgcGFnZXMuIEFk
ZCBhIG5ldyB2YXJpYWJsZSwgc2d4X25yX3RvdGFsX3BhZ2VzLCB0aGF0IHdpbGwga2VlcA0KPiA+
IHRyYWNrIG9mIHRvdGFsIG51bWJlciBvZiBFUEMgcGFnZXMuIEl0IHdpbGwgYmUgdXNlZCBpbiBz
dWJzZXF1ZW50DQo+ID4gcGF0Y2ggdG8gY2hhbmdlIHRoZSBzZ3hfbnJfZnJlZV9wYWdlcyBpbnRv
IHNneF9ucl91c2VkX3BhZ2VzIGFuZA0KPiA+IGFsbG93IGFuIGVhc3kgY2hlY2sgZm9yIGFuIGVt
cHR5IEVQQy4NCj4gDQo+IEZpcnN0IG9mZiwgcmVtb3ZlICJpbiBzdWJzZXF1ZW50IHBhdGNoIi4N
Cg0KT2sNCg0KPiANCj4gV2hhdCBkb2VzICJjaGFuZ2Ugc2d4X25yX2ZyZWVfcGFnZXMgaW50byBz
Z3hfbnJfdXNlZF9wYWdlcyIgbWVhbj8NCg0KQXMgeW91IGNhbiBzZWUgZnJvbSBwYXRjaCAyLzQs
IEkgaGFkIHRvIHR1cm4gYXJvdW5kIHRoZSBtZWFuaW5nIG9mIHRoZQ0KZXhpc3Rpbmcgc2d4X25y
X2ZyZWVfcGFnZXMgYXRvbWljIGNvdW50ZXIgbm90IHRvIGNvdW50IHRoZSAjIG9mIGZyZWUgcGFn
ZXMNCmluIEVQQywgYnV0IHRvIGNvdW50IHRoZSAjIG9mIHVzZWQgRVBDIHBhZ2VzIChoZW5jZSB0
aGUgY2hhbmdlIG9mIG5hbWUNCnRvIHNneF9ucl91c2VkX3BhZ2VzKS4gVGhlIHJlYXNvbiBmb3Ig
ZG9pbmcgdGhpcyBpcyBvbmx5IGFwcGFyZW50IGluIHBhdGNoDQo0LzQgYmVjYXVzZSBieSBoYXZp
bmcgYSBjb3VudGVyIHNneF9ucl91c2VkX3BhZ2VzICBpbmNyZW1lbnRlZCBpbiB0aGUNCmF0b21p
Y19sb25nX2luY19ub3RfemVybywgdGhlcmUgaXMgYSBmYXN0IHBhdGggdGhhdCBhdm9pZHMgdGFr
aW5nIGFueSBsb2Nrcw0KaW4gY2FzZXMgd2hlbiB0aGUgRVBDIHBhZ2UgaXMgbm90IHRoZSBmaXJz
dCBvbmUgdG8gYmUgY3JlYXRlZCAobW9zdCBvZiBjYXNlcykuDQpJIG9yaWdpbmFsbHkgY3JlYXRl
ZCBhIHZlcnNpb24gd2l0aCBqdXN0IHVzaW5nIHNneF9ucl9mcmVlX3BhZ2VzLCBidXQgY291bGQN
Cm5vdCBhdm9pZGVkIHRha2luZyBhIGxvY2sgaW4gZWFjaCBjYXNlIGFuZCBpdCBkaWQgbG9vayBt
dWNoIGxlc3MgcHJldHR5IHRoYW4NCnRoaXMgdmVyc2lvbi4gVGhlIGNyZWRpdCBmb3IgdGhlIGlk
ZWEgYnR3IGdvZXMgdG8gS2lyaWxsIHdobyBraW5kbHkgcmV2aWV3ZWQNCm15ICBwYXRjaGVzIGJl
Zm9yZS4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0KDQo=
