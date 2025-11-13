Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EDD13AF2;
	Thu, 13 Nov 2025 01:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762999154; cv=fail; b=WY58aQlW3Jmvj7EzhD4dxNdOoSVGQgIEoOikLqE3Fb/Pt1oEP0/KdTydtiyND9RO+xzl78HmHz2EKamtHBG06MdjGHo0/DpoAw4BRGjSlVH49BvoBYMmG5ca5+ygdkODxMU8MERKChbxIh4cT4hFzSe3fqDbTFLrwqQ91usCrjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762999154; c=relaxed/simple;
	bh=fvbDCKhSUaEbgB4f62IQygsfu673NipFZfs5RNlCbNA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CIjRa+IRsk5iVRHy1Tlnysr8b4rjz0GOTEulHRuKpUrgIifmW21u1+wc+au7FKM7Jxjm8RVl7UuzRz9qLmySSwciYjSrK6t4bSpyx6Z9TiAYXB2Yew4M+CIXCY/qQKMqmvlXVSAITQHCya+J7gDvOxXhSEmJlEcBppyhBqtKwkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l4adSRwI; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l4adSRwI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762999152; x=1794535152;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fvbDCKhSUaEbgB4f62IQygsfu673NipFZfs5RNlCbNA=;
  b=l4adSRwIoH3ysLv3oHeUsLVr/e2MmINaZoYS00vLC23rsLcGdf8ccCEQ
   GlNbxNtTxsP29e+4PKMaJ/ZpAQAn6npFB//9rZF+JdroeC7c1VL8/TnL5
   1IZ/sKDQjMkVmwe5RvAD0zWaK+UgZUyCc8OURSLW96M92DDnVuMJ+UAO6
   5f4251/Glf5R2r2BoU3YKOQz74Wi5dqjlyp8X3kc3MP+e9BgTUeQckbJ5
   bjCia8sogwn+o2w0YpU/rv6ENjH/aHiiT/bEeBMdUyPrwHSjnZo/eycuw
   Baote0ymLnPkRxd2tkaebDlxanj8csY5Tbju3mpTPnJbT+iHMPZa0eddF
   g==;
X-CSE-ConnectionGUID: MJZFIZFQSpSyRKt18Siy7Q==
X-CSE-MsgGUID: UH8Z2T9HTwKR7baGm+1fMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="75754086"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="75754086"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 17:59:11 -0800
X-CSE-ConnectionGUID: Uc5pkdnbQP6PM7i9NlclMw==
X-CSE-MsgGUID: kmQOAtthR4StELyUyrv21A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="189226841"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 17:59:11 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 17:59:11 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 17:59:11 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.65) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 17:59:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l8ly7A15OG0W+ogreLzDNuzaJcX5pYnXRkTKYEvLMTlPnHNKajUWuwRT6jkt6DzU71Imylv2ZttDqLuWCJ8OsQ2XduqRT9AuHQUwCD5v3I6YlS3a7MBNDkVIpCYCudVUYujcYMP/Zi2l98vI6cGPEWPJjzru4p03HIiYNL+u0g801odGzr1DOYyF4NKVXkRRdG2SfTBMyidT2SsNeo6RT2oiCnMqli9gBnDVdm0+GIoxiU2KRN7ujJ+u4ZTUGB0BQKixK8PUONxXiOcL9CsUho3PPN8HyS18rWMbH8udp/PlXA+OIAfb1eNrlcmipzL6DsutuWVlFj55LQCCBvxYbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fvbDCKhSUaEbgB4f62IQygsfu673NipFZfs5RNlCbNA=;
 b=gtznqvG5T+7xeL33HYkqnOEyLliIyuBadBBwkLt9C2zU5O1gMiDnyavT7D8KWn4iMFSTZj7x0Tc1QQu4YhzeXSyPQtddsGZGuOC+TZb4mFdiyXqHzSs7XPOvYvZ0Oy8SN/++TBkSwijIAeeQEPgrjaQGENrATLZlJ58NLZmXcfDJvxoES6y8/hZkFXJuTkdoHmxlHBFTd98/Av0fOdEWivAFyJH9XI0xf5lSyYKNb6DM43NsaLtONmqNCKestTKn0Tna8dgPEGRiR0b4jevPe1gj0gjBGquY36+YAgEFk/nwfOiHGQfj/RQmdFjiFmKbQ7a1WFapSLgUZuEV1MyKGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 01:59:09 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 01:59:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86/sgx: Add kernel-doc descriptions for params
 passed to vDSO user handler
Thread-Topic: [PATCH 2/5] x86/sgx: Add kernel-doc descriptions for params
 passed to vDSO user handler
Thread-Index: AQHcU/e0zV2XTh00j0W5Lh1D0RJ2G7Tv2j0A
Date: Thu, 13 Nov 2025 01:59:08 +0000
Message-ID: <9adc3a5437cf7d9af99642a0df837bbd0237bb58.camel@intel.com>
References: <20251112160708.1343355-1-seanjc@google.com>
	 <20251112160708.1343355-3-seanjc@google.com>
In-Reply-To: <20251112160708.1343355-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB6779:EE_
x-ms-office365-filtering-correlation-id: bee9d269-5ff9-49f1-a454-08de22583bcf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TUFzZTBXNTEwaE5LVzlxZTJJWmFtdittaFk1UzB3N3VBcFlBeklDVEtqTEV3?=
 =?utf-8?B?eGFzalVGWDBnWEpTR3NPc0hteXhhUXFZUm5CTTJWRXVLK1l3S0VvUFJmTi9R?=
 =?utf-8?B?dS8zMkw5Qmc1anhnckVSajg5YUVrMzZneFdGWUV1ZDZySk83b3hsZkZWcGlu?=
 =?utf-8?B?a0Mvcld0MEFESUc1REZna3FtN3psUzZheDdwSkFIRHZObjVvQ0JmMm1UcUZl?=
 =?utf-8?B?ZENQbEIvWkt5dnlMQkFWRXFTS2dEUkx0ME1paDBnWkt5RC94dUo2SWlyMGFj?=
 =?utf-8?B?RXpheVpYMVBjcU90a1VudE5qbzhjOWlHUU1aNERNQTJsYzIxdnByR0dyRW5t?=
 =?utf-8?B?UFdaODdPRVdLWU5IVDg4djNsalVBM2lCemVoL0hRdDZ4Y1E2cnNCeDRyZVla?=
 =?utf-8?B?L2xpU2lEUGhKZlR1ak9ybFEwMFF3UHhweWp0WGVHQkN6cmRtUmFpTVhvVG9j?=
 =?utf-8?B?TFRtWURVaTBEdlhWZlh5d21OUEZOTTNmL2dwZUpNRnFja1FsVmRiK3dGZlRB?=
 =?utf-8?B?TTBkaERIWVViQ2xvKzhKbEVZbjZsZVM0c2pZVEJteWZMOXVBU2cyT0tlcVBn?=
 =?utf-8?B?d3Q1LzhObWFjeUZvY0pHa2pXKzQ5NS83R3lNTmVMUi96b1lMeURHOVZvMUx3?=
 =?utf-8?B?ekgyQkhOVEMxZmpKdmtyRXpjbzNFMHliTHdQSWdHOFN6VjJ3TEE2aUdBc2E5?=
 =?utf-8?B?YVhrZjczVUpmbmVBNmhsSUxUa1JsZkFXeUxNeHRRM1Y4TFBFbHdQMHJzQSt2?=
 =?utf-8?B?RTBSOXR0akNpZTF4NXh6eWVxNzBwOEphZEJEUGlWOWNRaXhaQVVHdVpyTEht?=
 =?utf-8?B?T3VpQnZsdmJQNlRtOFJnREJHaEQ4cktYQTRzVFNsdFdwYTIwSElzbzVwMkdM?=
 =?utf-8?B?Y2xnUFl5MXFwamlwenJrVnNYbWJvakRvb1NmazdkWWttN0hFTjZuSjI2NHJ4?=
 =?utf-8?B?N3g3TjZaT3I5cnU0Zm9aV2V1ZGI4ZWc4NWJWQnlXK3lubURINGhxR3RuRzV6?=
 =?utf-8?B?SGxxVUs2aGVXcU9iWldaUG9vQVlQZmVDd2daaHVZbkcrcFRBVFZ6QTZzaCs4?=
 =?utf-8?B?bWY2d3lKY2ZwdXBxQzhvTlV0RkVDeFdLTVpmL201dnc2dzFQUndubEg0Q0xC?=
 =?utf-8?B?alArUDNLN2czTllPTG1hNVBMRHkwL3pMOHFkN2hyaUNzenEyMEQwTHgxSjZJ?=
 =?utf-8?B?OGZ2TWtoNWE4YkpVWDNNUHFsSkkvWnJPZFlZK1dWOHowM2lkanhYTC9RQ0sy?=
 =?utf-8?B?c2wyVUFZRkF1YjdmZ29JUUsrZ3lKU0hWZEcvczdZVWtqVGVtL3FpUzRBUUwx?=
 =?utf-8?B?cGtXMURXb05kTEdNNmZGN0oxZmhoYzl1YlJYc002VUlQdGFnTFkzV1k3bDRT?=
 =?utf-8?B?TEw4b2dVWDVDdXBiMjM4SkRNSmJCZUNJSWhTWGVUbUR1YWJ0cnpsTU9Veis5?=
 =?utf-8?B?aWNETmR0eWVyNGFOaE1mcysrMVZ1dHdtK20xYkVOM0VkR1MvN1p2ekpUYmF1?=
 =?utf-8?B?RHBUaWxmOGZnMVZ0bUs4Q3ZVczFtNW03TzJDOXVMaXR5OWFQK3NxR050V0Fz?=
 =?utf-8?B?RzQrckUvanh0SFptYUxmUFFxYllHNndxM0x6cmtaRTcwSEcvWnJZMUlTaTZT?=
 =?utf-8?B?dWpNL0NkSElMcDVaUkc4YXJEajlXVUJScnhpTWh1a0lUbk8yclUxNkZYdm81?=
 =?utf-8?B?ZXRyampYQ1JCV2dDOCtyanZxQXlHQTg3MFNvK3lPNW1JcDJaQUlEek0rL2RI?=
 =?utf-8?B?N1BoY2FVN2RBOC94TXZCQVV2ajdkeDQvSnRjN3l0NUhub3YvQmFpNFZEL1RF?=
 =?utf-8?B?cGRWM3VwSzRGNnhUa0IwejBKNGdxVkVnTGFYb296enUyZVJoa09vaVB2ajFM?=
 =?utf-8?B?TmYvakhMMFlIOEVrNmppOHNmdDhpMnVqeTFkZjhIaExkNkZpZ2ZDZ0ZTNkhL?=
 =?utf-8?B?ZXZnd0RwZDVUSWtVeDNzWUpLaUVGdzFYQUc2TWFmQURYQWQwRHpaakpoVW5T?=
 =?utf-8?B?S3JXRS91UEM3NklxOGJQcXZrWTRVY1VpNm40SnV0MzV5elRrc1ltcGlFNVF6?=
 =?utf-8?Q?46lzBM?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlgvSHhnb1ZlQ3VQeE94VTExVUNwNWRLUThnTkJjNVYvZThaVDY2L3RkNkR0?=
 =?utf-8?B?RUloRklaSXFIWHNqMkhTc1RqMGtUSTgvdlFKMTl1Ums4RDN1akJMOUE5UTRt?=
 =?utf-8?B?K2JDaEdISm4zUEZrOXNUd1NISWxnSGltdG1SaXU5MVNXWW5KSHBXWTVJYS9S?=
 =?utf-8?B?QXF4OHk3c0RJaWdZK3MvS2NGTWI0ZW5hdWl4eUNBY2tkZytJSUh2Y3hlN2Fy?=
 =?utf-8?B?bzJyenY0T0Vadzl4TW9HWm9BcUp2QWErT0NoblNMejl3eG9IaitVMGNiY2R6?=
 =?utf-8?B?UHJsQTZIOWlLa0N2bzNHY0lPZ1dzNGd6ckFOc2dmZkg2Ujd1QlpLYWRxMVNk?=
 =?utf-8?B?ek1HZjg4S2FPaXl6eWt5bENJMnlPeHVHRFZzM1NJdjhaWVhqYTYvRysyNEx2?=
 =?utf-8?B?amdCYzBnWG5iRXV4d25FY0VacVNGZzNkcGZ3UURReUppcmpHKzRCUjJmN1Qy?=
 =?utf-8?B?K3R0VFBacXdiWURqelM2ejNmZjI0a2k2ZnAzY0FIaUF2d2lTell1cVd4eGps?=
 =?utf-8?B?NTYrMGJLZGJXZGY2QWR5S2Zmc0FJVzlSNDRGN3Z6Y2tUaGVvc01lNElUWlFL?=
 =?utf-8?B?WkpQbkZTcmY4K1hTUlVOVmo3N3RoRjhxeXR1bG1VbUVQUWR2YnhzSTdEVUpO?=
 =?utf-8?B?RllzS3FqUzlnVlhPRG44bFdmTHg1ZjJSQ2p3YlJXWFdnUnF0dWpwWnFYbi94?=
 =?utf-8?B?L1llaG55Q21BZG00VGEzMGdELzErTFl1Vmk2eEJBQ01EajdrSnFIUkVLY0Ir?=
 =?utf-8?B?NmlJMkNhTG9FcDZLNGhvVndyU1I1QldwR290WEE2YytHZXExN3FoL244elpj?=
 =?utf-8?B?ekRSdElDVG1rVEdIYWlRRjV0SlNOVUtLcEFhQlhGR2RVaDY0TFNqdUl1QTJ5?=
 =?utf-8?B?WUtDMGd2Smx1M3paNCsvTDR3aUNaUjNsaElTNmJYTy9oeTdXSUdITjRkR25w?=
 =?utf-8?B?Nmw1TzNkaHBNTWsvMmlVTkJzUFY3UzNpeUgvcjBhRi9vMjNpamlvdTR4Mkpy?=
 =?utf-8?B?NTVIdk9PcEdxNGlPV1g0cFd3ZmIxK2Q0VWtpQUNQQ1RVcG9wSnZ1NXVMUUYv?=
 =?utf-8?B?elRiMlo0YlhOTmZuWmVGdWZSYWlKNGUzL0w3UFVNMm1jQXVJN1lyTTRUZDd5?=
 =?utf-8?B?cUZvaVpUV3JEZ3FXVWVhanM5VGZhTEpYZnVodUdZYWZ2dWNvL3pYWmpvM2Zj?=
 =?utf-8?B?N0RlOVNDVEorZTBNaTBTQjd6endrUXdlaWV0eHIzRUJEbndyRk1tSGZ2TUE2?=
 =?utf-8?B?b3p6VmQ5ODhJM0VqWHNSSWZzSWtXc3hqbnJPVFlYemdmNHh0dlJNN2VIYldh?=
 =?utf-8?B?ZDBQbVorVGkwTk9PWFZvbDNaY3VGRDF3KzhFVG02amNjZGkxeWwxNzR4dkdn?=
 =?utf-8?B?ZDVjRk91bTdKeU5Uazd1SjF4K2hPS1ErRW9QNVNRQlZyUFpINlZMYmlRVWpv?=
 =?utf-8?B?RjJKU1QxRnZvUGVJcnV2bHQzY1ljWkVBejdUQVEyQWd5RkI4QUc4c0xRUi9C?=
 =?utf-8?B?MS9IRy81cStUYWNQVHZJYmV0T25uMHA2Q2l3SlpjRkJQdjlDMWd2cXROS0g5?=
 =?utf-8?B?MVpQYmF3aWdJR2hBRWxWajRVYlV2U2syeEdRSjVHWkNYM1U3SUNYWjl5c3JL?=
 =?utf-8?B?aGZhRTMxL3NCdHpwY3JwQ0Q2QS82Ny9DM3dEV1lWdjB5RGx6b0I3aCtBOG9L?=
 =?utf-8?B?dGxwM2NEMjZobnJIekIxS2k4WkhhT0NUQTkyNFRKOWRPYVJzUzhTTWIybEor?=
 =?utf-8?B?T29DUmQ5WEsvTzl4KzJJaUgyQXIwSTZRekF1WDhNZTVZTFN4cHdvcjBjT2xF?=
 =?utf-8?B?YkpacnFGREp6OTl0Y0ErTmxqZ3V2OWw0RWZZM3JPNnhnS3dZeis4YXBvSXUy?=
 =?utf-8?B?QzkwWFdUN2dvaDlFbHpJbFl1SkdFaWVVVys4MGdUa2ZjS01IK1BXZElvbmtT?=
 =?utf-8?B?Sk1wb29jWm95WnllU01XVGNiclFvNkhzMFkxMlNuQk1waVIwbXdYaFhhYzQ4?=
 =?utf-8?B?RC9NVk9zYzdnVkNsdStWdDViSnlEWmlOSjdJclpSM0h1clFMc25Pa0R5SHNl?=
 =?utf-8?B?Wnc0Mk1rMzdzVldtZDhjZGh4TW5UaU5rUTYyR2w0WEluOExPaERZYVdaeUJU?=
 =?utf-8?Q?RPUyBPOsOmPyxoBPa5K1lR8Dp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE93C4AA9F111F4694F70A803EBCA308@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bee9d269-5ff9-49f1-a454-08de22583bcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 01:59:08.8858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XxZAtGO8uUHMAPk6nDSzV9KD0GbjEAycmG1hBsFQ8DixetvPMPVi7KeQiOGCcz83pazY7DKfsPVLjR49fneeFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6779
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTEyIGF0IDA4OjA3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQga2VybmVsLWRvYyBtYXJrdXAgZm9yIHRoZSByZWdpc3RlciBwYXJhbWV0ZXJz
IHBhc3NlZCBieSB0aGUgdkRTTyBibG9iDQo+IHRvIHRoZSB1c2VyIGhhbmRsZXIgdG8gc3VwcHJl
c3MgYnVpbGQgd2FybmluZ3MsIGUuZy4NCj4gDQo+ICAgV0FSTklORzogYXJjaC94ODYvaW5jbHVk
ZS91YXBpL2FzbS9zZ3guaDoxNTcgZnVuY3Rpb24gcGFyYW1ldGVyICdyOCcgbm90DQo+ICAgICAg
ICAgICAgZGVzY3JpYmVkIGluICdzZ3hfZW5jbGF2ZV91c2VyX2hhbmRsZXJfdCcNCj4gDQo+IENh
bGwgb3V0IHRoYXQgZXhjZXB0IGZvciBSU1AsIHRoZSByZWdpc3RlcnMgYXJlIHVuZGVmaW5lZCBv
biBhc3luY2hyb25vdXMNCj4gZXhpdHMgYXMgZmFyIGFzIHRoZSB2RFNPIEFCSSBpcyBjb25jZXJu
ZWQuICBFLmcuIHRoZSB2RFNPJ3MgZXhjZXB0aW9uDQo+IGhhbmRsZXIgY2xvYmJlcnMgUkRYLCBS
REksIGFuZCBSU0ksIGFuZCB0aGUga2VybmVsIGRvZXNuJ3QgZ3VhcmFudGVlIHRoYXQNCj4gUjgg
b3IgUjkgd2lsbCBiZSB6ZXJvICh0aGUgc3ludGhldGljIHZhbHVlIGxvYWRlZCBieSB0aGUgQ1BV
KS4NCg0KUGVyaGFwcyBhIG5pdDoNCg0KSSBhbSBub3QgdGhhdCBmYW1pbGlhciB3aXRoIHRoaXMg
cGFydCwgYnV0IEFGQUlDVCB0aGUga2VybmVsIGFsd2F5cyBzZXRzDQpSREkvUlNJL1JEWCB0byBl
eGNlcHRpb24gdmVjdG9yL2Vycm9yIGNvZGUvYWRkciBiZWZvcmUgaW52b2tpbmcgdGhlIHVzZXIN
CmhhbmRsZXIsIGFmdGVyIHRoZSB2RFNPJ3MgZXhjZXB0aW9uIGhhbmRsZXIgY2xvYmJlcnMgdGhl
bS4NCg0KU2luY2UgeW91IGFyZSBhZGRpbmcgZGVzY3JpcHRpb24gdG8gdGhlbSwgc2hvdWxkIHdl
IHNvbWVob3cgY2FsbCB0aGlzIG91dCBpbg0KdGhlIGNvbW1lbnQsIGlmIEkgZGlkbid0IG1pc3Mg
YW55dGhpbmc/DQoNCj4gDQo+IFJlcG9ydGVkLWJ5OiBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJAY2Fu
Yi5hdXVnLm9yZy5hdT4NCj4gQ2xvc2VzOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAy
NTExMDYxNDU1MDYuMTQ1ZmM2MjBAY2FuYi5hdXVnLm9yZy5hdQ0KPiBTaWduZWQtb2ZmLWJ5OiBT
ZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4
Ni9pbmNsdWRlL3VhcGkvYXNtL3NneC5oIHwgNiArKysrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA2
IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL3VhcGkv
YXNtL3NneC5oIGIvYXJjaC94ODYvaW5jbHVkZS91YXBpL2FzbS9zZ3guaA0KPiBpbmRleCBhNDM4
ZWE0M2JmZDEuLjBkNDA4ZjAwMWFjNiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS91
YXBpL2FzbS9zZ3guaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL3VhcGkvYXNtL3NneC5oDQo+
IEBAIC0xNDMsNiArMTQzLDEyIEBAIHN0cnVjdCBzZ3hfZW5jbGF2ZV9ydW47DQo+ICAvKioNCj4g
ICAqIHR5cGVkZWYgc2d4X2VuY2xhdmVfdXNlcl9oYW5kbGVyX3QgLSBFeGl0IGhhbmRsZXIgZnVu
Y3Rpb24gYWNjZXB0ZWQgYnkNCj4gICAqCQkJCQlfX3Zkc29fc2d4X2VudGVyX2VuY2xhdmUoKQ0K
PiArICogQHJkaToJUkRJIGF0IHRoZSB0aW1lIG9mIEVFWElULCB1bmRlZmluZWQgb24gQUVYDQo+
ICsgKiBAcnNpOglSU0kgYXQgdGhlIHRpbWUgb2YgRUVYSVQsIHVuZGVmaW5lZCBvbiBBRVgNCj4g
KyAqIEByZHg6CVJEWCBhdCB0aGUgdGltZSBvZiBFRVhJVCwgdW5kZWZpbmVkIG9uIEFFWA0KPiAr
ICogQHJzcDoJUlNQICh1bnRydXN0ZWQpIGF0IHRoZSB0aW1lIG9mIEVFWElUIG9yIEFFWA0KPiAr
ICogQHI4OgkJUjggYXQgdGhlIHRpbWUgb2YgRUVYSVQsIHVuZGVmaW5lZCBvbiBBRVgNCj4gKyAq
IEByOToJCVI5IGF0IHRoZSB0aW1lIG9mIEVFWElULCB1bmRlZmluZWQgb24gQUVYDQo+ICAgKiBA
cnVuOglUaGUgcnVuIGluc3RhbmNlIGdpdmVuIGJ5IHRoZSBjYWxsZXINCj4gICAqDQo+ICAgKiBU
aGUgcmVnaXN0ZXIgcGFyYW1ldGVycyBjb250YWluIHRoZSBzbmFwc2hvdCBvZiB0aGVpciB2YWx1
ZXMgYXQgZW5jbGF2ZQ0K
