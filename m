Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361D21F9F7A;
	Thu, 14 Aug 2025 22:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755210690; cv=fail; b=dNqQIQGzwgvTJpUsof8zuYDuJoIWxB6DCyfZT11Yz4EZQVNSggrABfnfecxv6nEoK5rI6G3CrDT7lyAr2h3D7pzisbeJarb5IN34WC7iqclPVnw5J49HBAq0nOAc8aqkBL133pCd+n6xv4pxxpI5bMBVKn915o5DmgYhReaPNWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755210690; c=relaxed/simple;
	bh=mMwn6hxe5M0fjzYOMsiEHTc8G9bVN/2UnNJZaQWP5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RpzybsSu3EJqP1kivr3Gesx6IqHyJf5lI6Vh6TPNnra8XkJJWecb+pR3Q8p4w+mFixxCyY9s8XCfXxTAU1STHyC6tx6Trvv/Md0dkqPArbvTEfsrhkgShuvE/lMdGgs+EPpJv/z1HZcuQbXq2LAR5GNGfVJiMuX4vLxeLMFokKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=COoh6O1N; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="COoh6O1N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755210689; x=1786746689;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mMwn6hxe5M0fjzYOMsiEHTc8G9bVN/2UnNJZaQWP5dM=;
  b=COoh6O1NwX06JGLH2QS0sFukpvz3uaSaTA6USNva/GoydVIm/6nN101H
   d1zUHvqF35pd8unhK/OxwX3z9GuQwnaD+G9Vtmy2+7kkDe37TPAY9FEAu
   DnSbqZoFHcvIMJD9O+OTER7yGy4PHUgcx0aII403C2h2b6DckSrTrAO3H
   RT27FoTHgFpzZiyqJt55wxbSYzmjNvI3Vu/IGoH4HOORJSIOYRauIvgqO
   sThkQoLcK46cLLr/sSayLDalC9bwA3SISYFdYRNBzIFBA7copsWG1c/Hw
   Wr/4BUvAfoMdYHyz/hFsuKdIO6E3q0sg6kz1Y0e039bLAxAhDASllv+rq
   w==;
X-CSE-ConnectionGUID: V4EyQAMEStepdT0VQW+/0g==
X-CSE-MsgGUID: hsUek14USteoaW0vEbYXbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57450098"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57450098"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 15:31:06 -0700
X-CSE-ConnectionGUID: z5jicAFMQe+7RMrtufnKyw==
X-CSE-MsgGUID: qX6EJrFaSIGssznSgYtiFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="167681028"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 15:31:05 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 15:31:04 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 15:31:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 15:31:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rKsMmLz5TsLrGrvIBOh5AxW/+mp1LG0OPr3NKeBkajQ43EyHaGX9UypT4eI9MLnlyPfPdDtNPuk+bgCvTFE26dRfqKNTunR3NQUbEvxbVO5/OL5lG+srjDS9KthjXEULXTAr3x4ZwoJ9LYnTeuhDoTF2R1NgoV6peVaAdFaQTqlEF/UZfbuocTKb+AgBteND+J73PuMTqTVyBWkwRLqfB9mM54JIm/SjkI4YwzrphUlAeiPanI9UnGDgZBWcyWXWN9nH8//+lcqQVX37HOCnYsoJWq2MkmNYfvKLEBunvbipPFF1In0zDCBfuMcZmRCR1NVQer0t/wNZP4eGYj95/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMwn6hxe5M0fjzYOMsiEHTc8G9bVN/2UnNJZaQWP5dM=;
 b=AO4NATH58Ke4b/LtQHhPopSTWX9Sdis04uNE5G1PduNKTHrnFuJOlqgSdyWUUsTUuULo+JNCKYT65VzaQ7Bz/u/xF/LwVYaxAnT6h97c1KQBw6d8uoYB+zuMDgVzdSf9BeUxdWTcTaO1iRPOXcFU+O+AEAvD66uUZO0HyVDNe229vl/nOTeth/8YAYh3/OLUqqbOGCJSBKpKQMm88RCG6mbOUuZXSguK+/cKziE4q1QehHsivUqMbh1doK5Qrz+8pzMLMB9LfQOqGkYj1Iu8RHOf+pxFZvkKyKgNNaq4qLNlilfcpGrhG1SP5zdEsszfNnpjfywsnUvW2gYKCKzBNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL3PR11MB6386.namprd11.prod.outlook.com (2603:10b6:208:3b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 22:31:00 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 22:31:00 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"mingo@kernel.org" <mingo@kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v14 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v14 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHcDO5KasBtAADxqku0BocXors/zrRh47YAgAAlQoCAALNggA==
Date: Thu, 14 Aug 2025 22:31:00 +0000
Message-ID: <f5e9a2fc1b3f11ed8bf1525a53d0f7ce830200c5.camel@intel.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
		 <20250814073640.1507050-5-elena.reshetova@intel.com>
	 <a74ede5f4466572e33c92fceb69136b82c042d7e.camel@intel.com>
	 <DM8PR11MB5750E0E7EE14FA87E9C48336E735A@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750E0E7EE14FA87E9C48336E735A@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL3PR11MB6386:EE_
x-ms-office365-filtering-correlation-id: b1535fbb-8201-4ceb-638f-08dddb823eff
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WkVNdlc0MVdrUVJiNTROSjhMT1lCeC9CSDRqZlM3MUEweHpoTDZJemt3VTF3?=
 =?utf-8?B?c0lVMWlibVNZVWM0MS9GdjJMbmRZUDc3MDRDM3pHOW9lMVdLK2VhcVpmbXNS?=
 =?utf-8?B?M3VHdkc0c0xrVWlLb3l6U29jVGdZRXUrNjVTZnUxOWlTdlU1d0JzZFpmZzJ3?=
 =?utf-8?B?ajRFYzljcEVieTdKbHd3Z2VMWEoraXlsOHdYdDllVVJiOWFJMDAra0JUZWdz?=
 =?utf-8?B?aEJYM1VnbnVqU1h6RWhZemswN09DVGhaMG10Vkl5amNtY09acUhUOXl6ZjZM?=
 =?utf-8?B?Zkc5VGdpTjZ1OUhRSEFCRGVPUnduVGhLMmVDczJpWEJicitQeFFtbEo2cGdF?=
 =?utf-8?B?bE5wNDhESTJ5NlpCdUlST0lPTk1VdVhJVFJ2dVRVK21tOFBjUFJpWWFzbmh6?=
 =?utf-8?B?a1R3c3Z0Sm5oOHhwdkl0eXcvRThaK3BCcHd0VlFSUVRqL2hXSE1KYTlsRkE2?=
 =?utf-8?B?N01nNXUzOEFIN28rNndPYm1rUUdJamxxUTk3SElLUjI5SUVONGZwTVdtOWJZ?=
 =?utf-8?B?RkdQL2NyOHRVK1d2WUZvV0RuRzNBb1R6ZmpTcUdqUHk4N1UxUm5OUHFmZVRp?=
 =?utf-8?B?NEkxM1hxdWZwRStibmpWSk53OXVBcER0RHg3YSt0YlZ5R1JHMUc4QkVmU2d3?=
 =?utf-8?B?bDQxK094bmJVbVNma3N1VmdvMjAwMUpETFhiZ3BpeldQS25PQ2VJSUg1eTRp?=
 =?utf-8?B?akNjQlpqMFkzUDlvMy85SFNOUTR3K0lGU2I2K2ZlRzB6NDJ6UGhKTm9ndW9W?=
 =?utf-8?B?NGZiMlZNekR3cjlIS1JPN3RRaGlpM09VblZwdFcwcmEyK0dzYjZZUUo1cUM1?=
 =?utf-8?B?c2pZZDUrUkUvMlpYRWlrMHhjS2dtakpVRlo2ZHIrVUgvckNoS2U4M0NQTm11?=
 =?utf-8?B?OUVNc0JxVURlbW9HbW16dWdHeU95dE5DTjJFU292OEw3OE1JZVNGemd3WEtv?=
 =?utf-8?B?aXo2MnpGR0hoRUhiTnZqbGYrL1V3VzY3OEVVdVlGQzFTV1F0c3g5Y2prWFhD?=
 =?utf-8?B?aytOdXQ0WWNPQ1hoU25tTzBTaEJrYTlmV1BxUWd6RHBRM2pzbkx3UmxGRzFR?=
 =?utf-8?B?K0ZTTW1UWUpkalE1cm1EbWV1NVI2QU83OVY0RE9uNWJPMUoyNmZndXZoNGN4?=
 =?utf-8?B?ZlF4cGNsKzRJbW5CTFpHeTRjM3pjeGZGQUJFamNoWTk2cTh6dW1Cb2xTcnR5?=
 =?utf-8?B?aEhHTzBYbmduVGQvNll1OHExaDhWb3JIOFJlZmxnQllmUVBySTFjTkRiQUVE?=
 =?utf-8?B?bjFXYnlVYm5SNkxiWUh1TmhaTy9yYmN4WGFWR2hqcUZmazRDM2hpbHFTUEpM?=
 =?utf-8?B?K2k4SlRraTFSaEp0ZnFiQmNxeThtNzRHb0JjRGJHdWF6ODZiQUVzQjFJeHBR?=
 =?utf-8?B?VGZySWc0STZlOVcyVTVwcExCQS9LSTV6QnFlbU1aRElLOUw0SExaUGpsVHRm?=
 =?utf-8?B?R0FzT2Y1dy9LeTY4MXJ2TjEvTGFyd0VtRFNCbnZCMS9TMlJpdlZqeVppWGpI?=
 =?utf-8?B?WGk3K2xGVURxMURGR2tnaFRqOUorOVNtdHk3UmJZcStadWk2NjB0eGoxSC9s?=
 =?utf-8?B?TEdWMkdpKzQ1K1JYZUVhOUpQQTlZTGxZK2FaNitoZ09Pc3dORDVGZzRKSnhm?=
 =?utf-8?B?bWMzK2t6VWpGS3RjN0VqNTVKTkJQY3hDaWlRMkcrUkFHd056UDBlVDFCcFlk?=
 =?utf-8?B?M01GNURJa3l4ZFpzTmVIaEJYMEpUdUV3bmg0dlpPQTJXZTlZNGVxU1NGMGxY?=
 =?utf-8?B?b1kxL20rNy9FeWUrOC9PaFdsZHY1RkhEVjVPSXVxQldGR1pRam42TVdEdWhs?=
 =?utf-8?B?ZlJxNkkvWTdtT2VJKytMTk9nQThCNVFkQTlWVGd1MVhrdHBCb0tCa0pqVHlL?=
 =?utf-8?B?Y285ZGFhM1p6OTdFY01BWkJPSDl6QkdGTDFobEhDa3FkVTlyWVdmQ0hjYjd6?=
 =?utf-8?B?dGZ2Z0k4eE1VUXpEOVJkM0ltNFJlODNCdDIwUXhmYXhiYXZ0Szc3cFZ2VzNt?=
 =?utf-8?Q?hJ741wLBP4liFmk8rm6EYiz9Vrjc3Y=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFo2SmFIQXlsNjZCcWlTYjNqMUc5OFljODdjZFo0aG1FRUVucFBmR0JWYUcy?=
 =?utf-8?B?Y0x0Tk1TNXRDYm51K0dwWTQzbTAzQSs4YTZJSzFTTXVtekQ2REdWajFUL3Ew?=
 =?utf-8?B?L1psczdaeVYra3dvTmJiUHBHUEZvNTRqTm05d3JjT1ppaDJxeU1XMDVia1oz?=
 =?utf-8?B?eTBoeU95SW84aTN0RDAyUFhvaHhZOU1pTVg4RFcxNGRvZGF3bHlHdWx5UUdy?=
 =?utf-8?B?bmpCZ25iZjBFTXAwZXVjbE5DZW8wVnl3eVhOcjU2N1VUR2ZGNGRYY3RmWkJS?=
 =?utf-8?B?M0RhV0RDOVpxNnNNdnRLOHVFampiRjBvR29pQmhCZE9KM3d1elcyb29WVVdO?=
 =?utf-8?B?elJISm5USUFhSjlhbkpKbExpWG8zeXRLdGNNYmVsSHZ5SUZmVUhhb3JQMkZT?=
 =?utf-8?B?dUptMnpCUTRTTU43U3UwcFovTkVmM3NNVFFGUDc1S0RvK3RGbEdtY3ZHeDZS?=
 =?utf-8?B?ZmxYYUZ3TG5sMVFWZkdRNTM1RE94eFdOY1cwZFFOUitSblhJWlVBbG1IOEoy?=
 =?utf-8?B?SzArZ2QwaG5SbE93ajFzU1pwS2xGcC93ZXVEK2NVOXdLdXQxdGxqMXljOGhv?=
 =?utf-8?B?dEVyWlZwb1hMQUNrYkdNKzNWYnJHUFVySnJuRFZyMmFsMzdBOFBQMHRSaC9P?=
 =?utf-8?B?Z2s1UnROdVc0OVVYSkEwdjZtcDYvODhGbzBNZVRxM3BKS2N1Q05tZUZJMms1?=
 =?utf-8?B?SlErZXZFOGFibWRPV3ZSMnNHL1F6MUZiUWZEMTM4Y2NIeDJFK0dzTUNyMkhl?=
 =?utf-8?B?b3pFZ09sWncvNjlQdUFhNTBnR2JaTG5lWDZzbmV0MmZVTVU1YnBkdGlsUG1r?=
 =?utf-8?B?bEZFa0prNEc2K1lZeXpWZGV2cHVFc0lHdXltaHJIWXdBMHBya0xiY3JyRk12?=
 =?utf-8?B?MnNZYzJuZkhmU1orZ01xZHU5TW1Eamgva0xzVXBnWmh5MFlLNjNzYnU5UGVs?=
 =?utf-8?B?UVdOVU55WkN4aW1WMzFTbDZIblAxamRwbm53TDhmYW50V3BIRnlHUHlJN1Fh?=
 =?utf-8?B?VHNMVm51VmRZK2F5RE8yZjZ1RUlaT1JvV3NLeXp1c2MybjdESDZTT2JnbkZz?=
 =?utf-8?B?RU1QdTJWYjBEWmFBWGZyK3RhT3Y0MEkyNEpnTVNiOFFoRXU3dElZUmNYc1hC?=
 =?utf-8?B?eDEwUVBKWkt2dTB3a2RXUlBHQmV1UFdscjNlVG81VmpPZHVPbEMyOE5IWDAy?=
 =?utf-8?B?cnBiVUdCeDdEL01JeXZUMFNVaDRXaHIzNUxHL3JWQlhoTXI0QzJBR2dsVkpp?=
 =?utf-8?B?SThmVFpNUVJ2R2RYWTU0QmVoeTZlbVA5d291YUFsUlBEWHBidWs1dDF0bWNH?=
 =?utf-8?B?b0NWc2VxM0dFSGpwOWJiOTBFS1YySU1vUmFpamxRWWpqRnRORFZLZklwKzRm?=
 =?utf-8?B?U016RDY5QmMvNGNXYkZ1RFM0bFpoZzZRMGk2djJiL21vTU0wWHp5M2tQUDV2?=
 =?utf-8?B?UVZmRzNpcXhLbnVLVWYxUDFVSHhYVUhvMHdnRy9PV3Fwb1U5Mm9RQmRITXYz?=
 =?utf-8?B?VXk2YUcyNmtHMkZJSkJMRC9nTFJYOHh5eXNxY252ekxEQ0NTRVBxaDFGQUZi?=
 =?utf-8?B?dG90UitWN3YxZUQwdWkyenFvcHBHdHREMFR6NHk2QUFFbXNSelBtdmI5enNz?=
 =?utf-8?B?bkprSCtVeDBNN1JheVlrZmJlbUVOSVJObDAydjJ0RHhNMFljOWoyaXpFRUxh?=
 =?utf-8?B?RnJjcmpneFJiNXVUMTVLTDYxTHJaWG9Jekk0YVhLWm1MSjQ2TTdRRld5Ym5r?=
 =?utf-8?B?TnBhLzFlZjA1NjJFb1NVSzJXOUNhN1gxRkVSL25EMDY5dUpDbFI1dVR5UEZD?=
 =?utf-8?B?UEcwdXJCbEF2WHVGVVdqNlBKVHJoTWpuNCtscXc4RzFNRmRPSG5aTGVVWmMw?=
 =?utf-8?B?RDNpWEdWZExQL0wwSmJaaEFEd3pXcCtZUGFxcVFSZlB1UW5Vck9odmtNZDUx?=
 =?utf-8?B?WE14bGFOQVlPNTYzY3hEZWZNTlhXSDdYcnZNQUc2S3BEV0R0SUlIVlh1cmZj?=
 =?utf-8?B?NzRLVjQ1bDRDakdlUXFWenVBVXB2em50bEltby9TaGFyaVhXVlcwSUJzY1pM?=
 =?utf-8?B?bk1oaHViRjFWcGMwRng2bXRzRFVwUGxpaS9MWnZzRTJpMldjcndyNW1MTU1r?=
 =?utf-8?Q?nO8TlUDVO9NXCzaMz0UVwWAnX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CEC70812D0DE94EB37F4BBAAD00E8C1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1535fbb-8201-4ceb-638f-08dddb823eff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 22:31:00.5163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3DDyaMP7s/+DvkJ7pWwzWgmBr2kzpKUHq58AFmI7MGTrUNg2gbqD7uBfEmzg6Hroh/r8ZYmSdV3bci9VcowY4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6386
X-OriginatorOrg: intel.com

DQo+ID4gDQo+ID4gPiANCj4gPiA+ICsgKiBSZXR1cm46DQo+ID4gPiArICogKiAlMDoJCS0gU3Vj
Y2VzcyBvciBub3Qgc3VwcG9ydGVkDQo+ID4gPiArICogKiAlLUVBR0FJTjoJCS0gQ2FuIGJlIHNh
ZmVseSByZXRyaWVkLCBmYWlsdXJlIGlzIGR1ZSB0byBsYWNrIG9mDQo+ID4gPiArICogKgkJCWVu
dHJvcHkgaW4gUk5HDQo+ID4gDQo+ID4gTml0OiBpZiBhbm90aGVyIHZlcnNpb24gaXMgZXZlciBu
ZWVkZWQsIEkgdGhpbmsgaXQgd291bGQgYmUgYmV0dGVyIHRvIG1ha2UNCj4gPiB0aGUgdGV4dCB2
ZXJ0aWNhbCBhbGlnbmVkIHcvbyB0aGUgbGVhZGluZyAnLScsIGkuZS4sDQo+ID4gDQo+ID4gCSog
JS1FQUdBSU46CS0gQ2FuIGJlIC4uLi4NCj4gPiAJCQkgIGVudHJvcHkgaW4gUk5HLg0KPiA+IA0K
PiA+IC4uIGluc3RlYWQgb2YNCj4gPiANCj4gPiAJKiAlLUVBR0FJTjoJLSBDYW4gYmUgLi4uLg0K
PiA+IAkJCWVudHJvcHkgaW4gUk5HLg0KPiANCj4gT0ssIHllcywgdGhpcyBjYW4gYmUgZml4ZWQs
IGluZGVlZC4gDQo+IA0KDQpJIGRvd25sb2FkZWQgdGhvc2UgcGF0Y2hlcyBhbmQgY2hlY2tlZCBs
b2NhbGx5LiAgSSBmb3VuZCB0aGVyZSdzIGFuDQp1bm5lY2Vzc2FyeSAndGFiJyBiZXR3ZWVuIHRo
ZSBlcnJvciBjb2RlcyBhbmQgdGhlIGRlc2NyaXB0aW9ucywgbWFraW5nIHRoZQ0Kd2hpdGVzcGFj
ZSBiZXR3ZWVuIHRoZW0gdW5uZWNlc3NhcmlseSB0b28gbG9uZy4NCg0KUGxlYXNlIHNlZSBiZWxv
dyBkaWZmIEkgY2FtZSB1cCB3aXRoOg0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2Nw
dS9zZ3gvbWFpbi5jDQpiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KaW5kZXggY2Zm
NWM0ZDIyYWMyLi5jNjQ2NzYyOGRhMDQgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC9tYWluLmMNCisrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KQEAgLTky
OSwxMCArOTI5LDEwIEBAIHN0YXRpYyBpbnQgc2d4X3VzYWdlX2NvdW50Ow0KICAqIGNyeXB0b2dy
YXBoaWMgYXNzZXRzLg0KICAqDQogICogUmV0dXJuOg0KLSAqICogJTA6ICAgICAgICAgICAgICAg
LSBTdWNjZXNzIG9yIG5vdCBzdXBwb3J0ZWQNCi0gKiAqICUtRUFHQUlOOiAgICAgICAgIC0gQ2Fu
IGJlIHNhZmVseSByZXRyaWVkLCBmYWlsdXJlIGlzIGR1ZSB0byBsYWNrIG9mDQotICogKiAgICAg
ICAgICAgICAgICAgICBlbnRyb3B5IGluIFJORw0KLSAqICogJS1FSU86ICAgICAgICAgICAgLSBV
bmV4cGVjdGVkIGVycm9yLCByZXRyaWVzIGFyZSBub3QgYWR2aXNhYmxlDQorICogKiAlMDogICAg
ICAgLSBTdWNjZXNzIG9yIG5vdCBzdXBwb3J0ZWQNCisgKiAqICUtRUFHQUlOOiAtIENhbiBiZSBz
YWZlbHkgcmV0cmllZCwgZmFpbHVyZSBpcyBkdWUgdG8gbGFjayBvZg0KKyAqICogICAgICAgICAg
ICAgZW50cm9weSBpbiBSTkcNCisgKiAqICUtRUlPOiAgICAtIFVuZXhwZWN0ZWQgZXJyb3IsIHJl
dHJpZXMgYXJlIG5vdCBhZHZpc2FibGUNCiAgKi8NCiBzdGF0aWMgaW50IHNneF91cGRhdGVfc3Zu
KHZvaWQpDQogew0K
