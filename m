Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A4F2E3705;
	Mon,  4 Aug 2025 07:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754293201; cv=fail; b=WYsdUR4kru6Q/NHBAerlrQ348pJFnL842lQgN5wM8bdJQUn2W6PZAkXVbr1cwcAqDzCVwXq/XYcurn1OAG8RbC7MN1VHv09uKAnRKXOcnGmZre8+4Tj9ZErFxUApjvHonHTkryXyzsGFDh2ivEQeoBXacNdbQdIE0vn1sD8h3jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754293201; c=relaxed/simple;
	bh=fNPGxlAvuUUVkq0YiPH6KYO88W/OTlu35gqWMAwLhbQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k4ja0WBnKsq7iK1G3f8hxvFdvB3B+b3if0fqxjoawBtwAKjdFaLyROJULQpiO/fAeYKRcjnMqc5sirjVkNCUS+UggiDu8MM88TarBvzJX84//peELVKHA0jNJC6iB7lZbcZCWCAJbB9OrHVAhv3JVcqTbjnLMd3XJGYd2RiI9ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FfvOj2zf; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FfvOj2zf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754293200; x=1785829200;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fNPGxlAvuUUVkq0YiPH6KYO88W/OTlu35gqWMAwLhbQ=;
  b=FfvOj2zfW/oBmtjWPu04b03ZXqpdF/TGPTEt904zXtrBpzMKVQZmOjsS
   9toFZdGUnIE6o7hJEqw1dDxXSud6bgotPAq2/J+7rElVRrG+71WA/M4vW
   ENRc0ue9/YOWIxDiIRgl7+UhoySelD9dc3ltoXE91ahN0zKsgfSyKph/E
   5O+sY4l4spY3PadeLLtg5Aja8CpdtcI/eTUsrnzlALZ2WANPI+1UaU7Ae
   Ik0uiV4MSKvsNH7SLrFMpAlaMApXvC02DVCzr2jBLaJfn0zoiVZSKGfvq
   RL9gkLJwGswyf2S3M60mTYWqTi/2rN+PZkJorLJ7A4JNJ2KHZRwJubV24
   A==;
X-CSE-ConnectionGUID: 4Op1jWHESp2GPDKgo6n7vg==
X-CSE-MsgGUID: Ri+WfJX1QseS7nLBDBZY9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="56683759"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="56683759"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 00:39:59 -0700
X-CSE-ConnectionGUID: Z1pPuUDlQaCchqGxX1/C/w==
X-CSE-MsgGUID: LfZ+frbURTSlDaPt71hAig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="169395794"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 00:39:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 00:39:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 4 Aug 2025 00:39:58 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.84)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 00:39:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D8okGBjECVfFcAKWYxJq9XrHNgC1XSHT80aYe98+Q1N8tBlaEseIUjTXo7pTomv9ig5OakiZi+6tnoGsTDdXzjECrW15p3d1HfXU+cj99+qYGL7V3G0WBrrWPHkeQHIdmAjP0vug+Oj43AT7tjNVmVnr6529Ye2oqVondc8yEaE/38YYHDOamnl9YwLIrqW/4BL09pWFYs+im+I+lErXum8T/uCZiAXyHfHAGbGYUu8raKkauV8WwLMRsF8IF+rjzNlYvpDj+oIbi+rwktMxdCxSo+ljuUG88Q0r7HSwn9MZV8/Dtfc8E897eZ3Zjs6b3Z3p15OrspYaj3V2z8NwlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNPGxlAvuUUVkq0YiPH6KYO88W/OTlu35gqWMAwLhbQ=;
 b=Jwv1txboS+hMrf5zKYuMeybfrSTunWoyUs8cbYE+802lAezDY6JzdlLhahnSZwZgVV8Ui0DGIPxQec+jtPu3uKa1g2sjfaK5cYL2dJ173zxMEdWqKPGM0sediMtLzWnJagt54ZYGybd4s4/P53ODAelLQNHPCkp7vUkdot32tyUtmLQHGqkA51v2sWU9RxTfGdQPNBPpUI3QMikMBumDEQHwnMR7fiQUfRfsZ9z+WmCfdcjGEEabUAiwDY+BEe+XYF1v63NZXkX5354Lg8OStsauJp3UONsYgZEB/gsmTGNjIQGM+wOhocUjedbtwEQ+KdOpObcnnZeRtSLdlD01uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CH3PR11MB8589.namprd11.prod.outlook.com (2603:10b6:610:1ad::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 07:39:41 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 07:39:41 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v10 5/6] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v10 5/6] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHcAtc4zaH3vwqP2kGx2jpaI2/+Z7ROCV8AgAQVrLA=
Date: Mon, 4 Aug 2025 07:39:40 +0000
Message-ID: <DM8PR11MB575000A8A359BA62379AD610E723A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250801112619.1117549-1-elena.reshetova@intel.com>
 <20250801112619.1117549-6-elena.reshetova@intel.com>
 <96866c15-2eb1-4df4-9e63-dfd5e40ecb91@intel.com>
In-Reply-To: <96866c15-2eb1-4df4-9e63-dfd5e40ecb91@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CH3PR11MB8589:EE_
x-ms-office365-filtering-correlation-id: 8eb24ee5-f1a4-4fff-d986-08ddd32a129a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WDk0QmMvQUw2ZmlSQVNncVprUldobEpwU0ZLa2kvUVRPbTdiRkZnWllQUWh3?=
 =?utf-8?B?dHBtbU1YdVJVNG1PRVE0eFRCRWlmS014clEwMHBiWkJsaS9lQkZ5UkJBV09h?=
 =?utf-8?B?em1BWlF3L2Y0c0E5cS9KYVQvZEp6UElkVi9UYXJXSlhhK2xoZFhmcmZyOVFy?=
 =?utf-8?B?QitjeHJoWWlwbzJqU2t0K0crMkU4dWV5emRTS1NhUkdIZ3lKMEdVNEdXL1k3?=
 =?utf-8?B?aFhZU1UzeG83OFZSNHU3YTZKSnUrUHFONEhCWFZleXNKdTRsVFlIRStaOUV3?=
 =?utf-8?B?d0hmYnQyc29FdFN4Wkx0NWsyVWx0NnE4YTF0UStjV1RnaUFLeDNqZXBBcXNz?=
 =?utf-8?B?aFVHWXhpYitMakt2bFFiYlFURkZSdEg2RjNzeWFIMG9xbDhBTVJZbGNiSnIz?=
 =?utf-8?B?TitsalZuRGl3SGZPdDlBeGwwdWVvNCtoeHNLWVRheFpvbjhRYXloSWdyMTBv?=
 =?utf-8?B?OUxManMyZ0lheEdHV1NSbjcyWG1FczEvUVp6RHlBb3FCUFkvTzZpZHlRcFpu?=
 =?utf-8?B?aGxnczlJSXJ3ejZTMXR4WlBHYTJlYkd6L0xMcWVXclNHdEVsQmdjTWR5WGR5?=
 =?utf-8?B?RnJuVllTWUxKbDV6ZFVoanpqUzQvMFVsRVF3MVVmYUhYV1V0SDZqcTRNZ0g4?=
 =?utf-8?B?M1l3Nm1oZTR2V0xIZVNQWDU5RXRYV1gyMUt5VHhWMkdBMDA0dmp1T0FvVytt?=
 =?utf-8?B?VkFENUsrOUQ4cERES3V2SEY4eWlZcXBDZ01GTU9OTkNpVVlTZzJXbVhMWVM5?=
 =?utf-8?B?MjBVMTYzVWd2VHVDQ1dlN05iRkRRZkRpdE9kQU5SOEFYTS81d1dkVmttMnZT?=
 =?utf-8?B?YmxSRzBMM2xPRVdSeW1FZDNXVVdjVllzUVZ4SUJLdXBITmVERjIwVUw0NWd2?=
 =?utf-8?B?NHd1Y2ZHZktMV29ubVA2OVM3eXIxUGdoRWh3TjNXbXdiOGNCYlViRTNsbTJj?=
 =?utf-8?B?M01WY3R5M0Rva0g0TmtzcDI3blZEQWw4Vk1aQk9MM3lqUmpCUzFmdzRnbE1i?=
 =?utf-8?B?RXRidkg2WWc3WXJDaG9oNVJJcmJxVDQ1U21jb0Y0cmtRMEMwbEpSck9kYjdn?=
 =?utf-8?B?eU9XdnowaW5yUko4aHFPZjVRZ3NUL3BzcDY0cklpZnlPSWd6cWFBU29vbGxz?=
 =?utf-8?B?K2RLOVd4N3p1MWZMYzNRcHRKSEVSdTlvNFFYcU95eUcxVndMVFY2QzlTeXlF?=
 =?utf-8?B?TEYreE5RZlhCWUJQL2pCMzBBVy82QWRRVnV1dkh6eFVBVWZpREw5T0xoOU84?=
 =?utf-8?B?TnpmS3FPZGNLKzRNZWF4L1dncUk3Qkc0QkYzRHZycWJtT09rejd4VjIzMlpP?=
 =?utf-8?B?RmFmQ0xkZENaN2g4ZjFmZ1p1SERveWJwc3N5Z0VWODV3VmJDTTQ5Und0a3ZM?=
 =?utf-8?B?Uk82b3NXSWsvZ0tkMzlyLzdLYzdXSmpxN1FVMnVDcURBUjJJRWFaSUJiTGM1?=
 =?utf-8?B?RExxUGU3VmVXdkFPNUg4aUZNSVZmUHdyYTFIQ3I2bmdBRnh2T21OTjRJcnZC?=
 =?utf-8?B?WXRJajE3aHlwNVNFenlZaVVOZEtJUisvRHZqU0lNUDMzWC9md0JyRnRoUGlr?=
 =?utf-8?B?eU9yV3FkaFc3dk9naEFrOXFycDB3TWpqVUt4VTRoUFVlMU5oTGJxU2ZsbGM1?=
 =?utf-8?B?UXJJWnE2UXpQdmJYN3VpcWJuOXNYZWVvTkZHZ2FWTXFKTGY1TVVJR3V3ZmlS?=
 =?utf-8?B?TXl4U3loSDI0bUhPY1kvRUhLenMvdnRLbVlodkYrRjVVTHlnWHgxKzg0dkJn?=
 =?utf-8?B?bTRXWmQyRFZobWtOYW5vK1grWmRTYmtyQUp6ZkV0MVpOZm1FTDNWL0RFYjVM?=
 =?utf-8?B?UlN3MEREQ1IzK0Roay9WdHE1WFpaa3hOc0FhWmFRckNFMjBtUHJMUnlLb0hl?=
 =?utf-8?B?SVZrMGRua0ZDbitiUGFRSTBzeXJWUFFaeEgyMnVkUndtUWdWbHhLNjc2USt4?=
 =?utf-8?B?eWlIMzZrK3FlaDNCWk01Wm9pYVVwRG1DQitUNkdBcVFaQ25WQ3V1Z2pLVkx0?=
 =?utf-8?Q?M2vkjdB1LTVpzO2Vo65qdvJMzauR1k=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFIvcEQ4MWVKcGZIYzBURU5obUgxT1FpNnM0Q3BMNUlHNWRXT0pGRUR0Sjcw?=
 =?utf-8?B?QVR4V1BZRWdndlh1dXIzZjBLSTRJSTdtdzkrRXcvWVZaUWZxd29Ed1JsSWY4?=
 =?utf-8?B?ZzZINTVFU2pxRkM5RklFT0FDTjlWMS82dGlRd2puVGwyMVA3SmNOcU9sUUs3?=
 =?utf-8?B?ejNPK0pSa0tOQXlvTEN5QmFwT2w2Nkt4bkZXemRWaDlUejkzV3BsWmdGQnVt?=
 =?utf-8?B?VTBrRjA1Q0prMEp1N1l2eitQa0dLa0dQd3NuMDdqeUplQm5UQkt2Y2tIVkxJ?=
 =?utf-8?B?dVhmRFZub0JhenRhdmtNLzFCVW10SXp0MkZFWGVmRmw3ZXpoam80MFVodU9W?=
 =?utf-8?B?YnV6c1VoNXo0RGhmQVRBVGt4RHJxZDlFWUVSMTd1RWJCV25lLzlJdTlwWFNq?=
 =?utf-8?B?bFp1U3NtN25xZy9NNnplT3FkY0FwQll4UGVZb3RnK0x1bXpjWlFXOW1QQThj?=
 =?utf-8?B?MjJTZHV2YVpyQzJ2QkpuUzQxd2xnV3Y3VlpNTHRGb2RqM014WkRlMVUvaTZQ?=
 =?utf-8?B?WHNWL1dRTG1jaFZWcjJhOXpZdzN5M0FrQ0VVWUpLSGZZYTVHaXNMSmVuUnNu?=
 =?utf-8?B?QVNuTXpuRnJwTDBUYmg1eVVJTkc5dFVCRFRQZThURkpKU3BWWlVLUlc1ZHM3?=
 =?utf-8?B?RENuVzJocWZmZ1BLcTVGZHZ0Q3JYYlg1cFR4dmd2YXdOMlhITXdvZm11NStu?=
 =?utf-8?B?ZkVaMzBqK3U4Z0hpbHdYNEZxYTJNR25Ycm9CdFRRSnF3UHU5aEhrOUFSNGF0?=
 =?utf-8?B?Z1pjN0JsMG5iOUF0ZXRXOURoNnpkSVpLWXdnMHRPRXhDVUdWYXhzNk1mRm1P?=
 =?utf-8?B?N1RrNkJLdHVwNjlULzlZbkhWTFlNVEZ6TE16REtMQ1VFNEVNOUVCa3JnMnJ0?=
 =?utf-8?B?OFJkUVBGYnhkSmNUOUZXdkNta3ZhZ3EyOE9TVnEzMStieWUxWUR0dm1MYnRt?=
 =?utf-8?B?Y3drOFlFTS9XdVdaWEdKWUY0YUxnMFZOOURHOG45RWE5cEw2dEJxbndFeVY5?=
 =?utf-8?B?cGVDM2htMXhWamxrY1BleVQvbHZoUTcrWGtSMDhzTDZ5TEF1M1FlMGtqWGhI?=
 =?utf-8?B?b2RHRVVyY3BpVGtwTk5ZMjV3RVlObnlxYUIxVHl2dGpiK0tlbERlUmNQRGRM?=
 =?utf-8?B?MHdmM21ITjlVRTFRNGJIY29FVWFCMUlndWxrOWM0blI3dmVDRFlRU2hXbTc2?=
 =?utf-8?B?NTlqZ09uUXBZK0N2eExiQTl0M255YWdVTExXZFVJWThYY1crMGkzY3VQTER0?=
 =?utf-8?B?K2ZidFNZRG5qYnF5Z3h5QnE4eTN3RHNRUWxIdUJNS1hjaTNtMmVKazljbUVL?=
 =?utf-8?B?Q29RcEEzWkhkTEIxOTFRaWhWQlh2OVBlSjlPNS9vSXRQUmhCZW05eUszaWgr?=
 =?utf-8?B?UnBpRVY5ZmEvY3cyaGJGLzlKenl2SDUvRVR2OHdiVldOeHFRRzR5cWFpeEw1?=
 =?utf-8?B?NFFDTVFuYk1pTkgxYmtqY3pER1FPd3ZxcGNLbGVqbXRzSGpJOVJnQ1BOeDV4?=
 =?utf-8?B?Q0tHWG1CbWFuRTk0UmtScE9LN20zRDduQ0dqVzQ3ZWxJTXh1SDB3akxObkFJ?=
 =?utf-8?B?L2pyZjBCM3VxbXdYeitBVzlHWkRDQUFnTjJTRE1NZGdZQzB0T1Y3dkpWWjBD?=
 =?utf-8?B?WWFNMzBVWjVIVXphL1dVSndHRitRdy9ySjl4TTN2cjJDZmx5V09HMUxYWTBT?=
 =?utf-8?B?ZEpVK2VLT2ZxUGVLbjhEUDdnV1c2aE5mdi9kVWoyNGw3T1AwQnFwTVgwNUNn?=
 =?utf-8?B?VCs1Y0hyK0tPejZMMGcrNHBZTFdoOHA0YndBRGlodGhMcXI5VWo1eUx3KzhQ?=
 =?utf-8?B?Yk04L1AwOHdOaXdGakZFWjczVnJ4Ui9mVnZnR1hodXUveW5YVGFTRmE1dll1?=
 =?utf-8?B?amo4SHE1dlZNMDltL1dWSXI1aGZvQ05Da3FFeDB1c2Z6dGdIQkIvU2ZmN1Bn?=
 =?utf-8?B?d2txOExWTHJZMWtic0JyZ1B4cjFkMjNZYldCalhTMW9xVE4vY0VqQy8vc2JX?=
 =?utf-8?B?SnY0bThLMzUxOVhCeUZhcG9mTkUxYzlNZFliRzl0bExHNlhqRkp3dnc0Y1Fa?=
 =?utf-8?B?OTdrdlowUjFuMlpHaVNvNlp3MmVDcnZUanBFSnMyd3UrQi85U1J1RElMMWQ3?=
 =?utf-8?B?elNmU0NaMzdUUFBTV3JPcTczaWRnanFiYTV5dy9HYkp3RXRLeDZrOVdMbVQz?=
 =?utf-8?B?cUE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb24ee5-f1a4-4fff-d986-08ddd32a129a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2025 07:39:41.0154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nxUwQgHmPQ/WDOpUiZbtamw2gLQ5I5j5V+L0lolir37bFHJR026dri3xrDYRHseciYyxz0RWen63Ljrwh+c7ouHiamO4zfPSyyjmCQvfNfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8589
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGFuc2VuLCBEYXZlIDxk
YXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDEsIDIwMjUgODox
MyBQTQ0KPiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4N
Cj4gQ2M6IGphcmtrb0BrZXJuZWwub3JnOyBzZWFuamNAZ29vZ2xlLmNvbTsgSHVhbmcsIEthaQ0K
PiA8a2FpLmh1YW5nQGludGVsLmNvbT47IG1pbmdvQGtlcm5lbC5vcmc7IGxpbnV4LXNneEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyB4ODZAa2VybmVs
Lm9yZzsgTWFsbGljaywgQXNpdCBLDQo+IDxhc2l0LmsubWFsbGlja0BpbnRlbC5jb20+OyBTY2Fy
bGF0YSwgVmluY2VudCBSIDx2aW5jZW50LnIuc2NhcmxhdGFAaW50ZWwuY29tPjsNCj4gQ2FpLCBD
aG9uZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBBa3RhcywgRXJkZW0gPGVyZGVtYWt0YXNAZ29vZ2xl
LmNvbT47DQo+IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBCb25k
YXJldnNrYSwgTmF0YWxpaWENCj4gPGJvbmRhcm5AZ29vZ2xlLmNvbT47IFJheW5vciwgU2NvdHQg
PHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEwIDUvNl0g
eDg2L3NneDogSW1wbGVtZW50IEVOQ0xTW0VVUERBVEVTVk5dDQo+IA0KPiBUaGUgY2hhbmdlbG9n
IGlzIG1pc3NpbmcgYSB0aWRiaXQgYWJvdXQgdGhlIGZhY3QgdGhhdCB0aGlzIGlzIHN0aWxsIGRl
YWQNCj4gY29kZSB1bnRpbCBzZ3hfaW5jX3VzYWdlX2NvdW50KCkgZ2V0cyBhIHJlYWwgaW1wbGVt
ZW50YXRpb24uDQoNCldpbGwgYWRkLiANCg0KPiANCj4gT24gOC8xLzI1IDA0OjI1LCBFbGVuYSBS
ZXNoZXRvdmEgd3JvdGU6DQo+IC4uLg0KPiA+ICsvKioNCj4gPiArICogc2d4X3VwZGF0ZV9zdm4o
KSAtIEF0dGVtcHQgdG8gY2FsbCBFTkNMU1tFVVBEQVRFU1ZOXS4NCj4gPiArICogVGhpcyBpbnN0
cnVjdGlvbiBhdHRlbXB0cyB0byB1cGRhdGUgQ1BVU1ZOIHRvIHRoZQ0KPiA+ICsgKiBjdXJyZW50
bHkgbG9hZGVkIG1pY3JvY29kZSB1cGRhdGUgU1ZOIGFuZCBnZW5lcmF0ZSBuZXcNCj4gPiArICog
Y3J5cHRvZ3JhcGhpYyBhc3NldHMuIE11c3QgYmUgY2FsbGVkIHdoZW4gRVBDIGlzIGVtcHR5Lg0K
PiANCj4gQXMgYSBnZW5lcmFsIHJ1bGUsIEknZCBtdWNoIHJhdGhlciBoYXZlIHRoZSAiTXVzdCBi
ZSAkRk9PIiBydWxlcyB3cml0dGVuDQo+IGluIGNvZGUgdGhhbiBpbiBhIGNvbW1lbnQsIG9yIGFs
b25nIHdpdGggYSBjb21tZW50Og0KPiANCj4gCS8qIEVQQyBpcyBndWFyYW50ZWVkIHRvIGJlIGVt
cHR5IHdoZW4gdGhlcmUgYXJlIG5vIHVzZXJzOiAqLw0KPiAJV0FSTihjb3VudCwgIkVsZXZhdGVk
IHVzYWdlIGNvdW50Li4uIik7DQoNCkkgd2lsbCBjaGFuZ2UgdG8gZG8gaXQgdGhpcyB3YXkuIA0K
DQo+IA0KPiA+ICsgKiBNb3N0IG9mIHRoZSB0aW1lLCB0aGVyZSB3aWxsIGJlIG5vIHVwZGF0ZSBh
bmQgdGhhdCdzIE9LLg0KPiANCj4gVGhpcyBzaG91bGQgZ28gd2l0aCB0aGUgY2hlY2sgZm9yIFNH
WF9OT19VUERBVEUsIG5vdCBoZXJlLg0KDQpPaywgd2lsbCBmaXguIA0KDQo+IA0KPiA+ICsgKiBJ
ZiB0aGUgZmFpbHVyZSBpcyBkdWUgdG8gU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZLCB0aGUNCj4g
PiArICogb3BlcmF0aW9uIGNhbiBiZSBzYWZlbHkgcmV0cmllZC4gSW4gb3RoZXIgZmFpbHVyZSBj
YXNlcywNCj4gPiArICogdGhlIHJldHJ5IHNob3VsZCBub3QgYmUgYXR0ZW1wdGVkLg0KPiANCj4g
RGl0dG8uIFRoaXMgaXMgcmV3cml0aW5nIHRoZSBjb2RlIGluIGNvbW1lbnRzLg0KDQpPaywgd2ls
bCBkcm9wLiANCg0KPiANCj4gPiArICogUmV0dXJuOg0KPiA+ICsgKiAwOiBTdWNjZXNzIG9yIG5v
dCBzdXBwb3J0ZWQNCj4gPiArICogLUVBR0FJTjogQ2FuIGJlIHNhZmVseSByZXRyaWVkLCBmYWls
dXJlIGlzIGR1ZSB0byBsYWNrIG9mDQo+ID4gKyAqICBlbnRyb3B5IGluIFJORy4NCj4gPiArICog
LUVJTzogVW5leHBlY3RlZCBlcnJvciwgcmV0cmllcyBhcmUgbm90IGFkdmlzYWJsZS4NCj4gPiAr
ICovDQo+ID4gK3N0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgc2d4X3VwZGF0ZV9zdm4odm9pZCkN
Cj4gPiArew0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogSWYgRVVQ
REFURVNWTiBpcyBub3QgYXZhaWxhYmxlLCBpdCBpcyBvayB0bw0KPiA+ICsJICogc2lsZW50bHkg
c2tpcCBpdCB0byBjb21wbHkgd2l0aCBsZWdhY3kgYmVoYXZpb3IuDQo+ID4gKwkgKi8NCj4gPiAr
CWlmICghY3B1X2ZlYXR1cmVfZW5hYmxlZChYODZfRkVBVFVSRV9TR1hfRVVQREFURVNWTikpDQo+
ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJZm9yIChpbnQgaSA9IDA7IGkgPCBSRFJBTkRf
UkVUUllfTE9PUFM7IGkrKykgew0KPiA+ICsJCXJldCA9IF9fZXVwZGF0ZXN2bigpOw0KPiA+ICsN
Cj4gPiArCQkvKiBTdG9wIG9uIHN1Y2Nlc3Mgb3IgdW5leHBlY3RlZCBlcnJvcnM6ICovDQo+ID4g
KwkJaWYgKHJldCAhPSBTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkpDQo+ID4gKwkJCWJyZWFrOw0K
PiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBTVk4gc3VjY2Vzc2Z1bGx5IHVwZGF0
ZWQuDQo+ID4gKwkgKiBMZXQgdXNlcnMga25vdyB3aGVuIHRoZSB1cGRhdGUgd2FzIHN1Y2Nlc3Nm
dWwuDQo+ID4gKwkgKi8NCj4gPiArCWlmICghcmV0KQ0KPiA+ICsJCXByX2luZm8oIlNWTiB1cGRh
dGVkIHN1Y2Nlc3NmdWxseVxuIik7DQo+ID4gKw0KPiA+ICsJaWYgKCFyZXQgfHwgcmV0ID09IFNH
WF9OT19VUERBVEUpDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAq
IFNWTiB1cGRhdGUgZmFpbGVkIGR1ZSB0byBsYWNrIG9mIGVudHJvcHkgaW4gRFJORy4NCj4gPiAr
CSAqIEluZGljYXRlIHRvIHVzZXJzcGFjZSB0aGF0IGl0IHNob3VsZCByZXRyeS4NCj4gPiArCSAq
Lw0KPiA+ICsJaWYgKHJldCA9PSBTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkpDQo+ID4gKwkJcmV0
dXJuIC1FQUdBSU47DQo+IA0KPiBUaGVyZSBhcmUgZm91ciBjYXNlcyB0byBoYW5kbGUuIERvZXNu
J3QgaXQgbWFrZSBzZW5zZSB0byBqdXN0IHdyaXRlIGl0DQo+IGFzIGZvdXIgbGl0ZXJhbCAiY2Fz
ZSJzPw0KPiANCj4gCXN3aXRjaCAocmV0KSB7DQo+IAljYXNlIDA6DQo+IAkJcHJfaW5mbygiLi4u
Iik7DQo+IAkJcmV0dXJuIDA7DQo+IAljYXNlIFNHWF9OT19VUERBVEU6DQo+IAkJcmV0dXJuIDA7
DQo+IAljYXNlIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWToNCj4gCQlyZXR1cm4gLUVBR0FJTjsN
Cj4gCWRlZmF1bHQ6DQo+IAkJYnJlYWs7DQo+IAl9DQo+IA0KPiANCg0KV2lsbCByZS13cml0ZSBh
Y2NvcmRpbmdseS4gDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggIGZvciB5b3VyIHByb21wdCByZXZp
ZXcgRGF2ZSENCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuDQo=
