Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3962B25DCF0;
	Fri, 15 Aug 2025 12:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755259548; cv=fail; b=CoQy1hgZei1IOO7kTXTpD/aKTMZPOXaz4h4NQs6gz4UbBTDgSoOL2gkP19E8EIr3Uk92VItVxe9RSVyE82ZXEdHbQ9QCksKHAGMymyJmBnRdCRz8Ww5DMmZQNX/f73DkLc/AVmaJ7LWkBnECTze9NHGz/xJev8TxBoGCfJZ8zt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755259548; c=relaxed/simple;
	bh=wA6Sb9eQaW4sr40ejinVOSu7jQ34LT5VuFli8HRGENE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dMngHZfGWldc949J4xCM+ba+/gywNo58oQ0zl9NKXpZD9bu5hA3pICNAH9O8wpPdRZb9mTW5XaBCpUyBeT5aUGHJyyZ0cAuZk/Ln78AWC0av44niFY7u4RPDnIYlt/kB6o5v9tFf96tLI3zJHpfzaFvXf87mDWFJy7idy6zo5wA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PaVQzuX+; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PaVQzuX+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755259548; x=1786795548;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wA6Sb9eQaW4sr40ejinVOSu7jQ34LT5VuFli8HRGENE=;
  b=PaVQzuX+GB/ClMCrYDxbSaNkJgwBD8MJDfaTuwJpPNgo42C43TZwsF+7
   3kd4ZwlePoaOWg4rGOaZiKj2n1CSkSf2DwOHtAI7FUOX7TdmN4+PoElP7
   4oaC7poIIDNAwydsjWF7WUsNYjcEi4yd2ihbXyZcqnsG5+MHgH5CE+d3l
   k6K88U2SNKee3t3htg/Fh0Ik+KDaF5dJQgkhsbao6D2NvMfHpESJfDQzU
   Jd0Ocgvb6gNb61GcQhLQam7taqT1zRiwe7PJECv2YiQ4n2rdWCNzKk8UX
   F8fjtgKHOA032/WUbyHIpSs/FQtv1zQGHtgtTNHiftoaS32HK382fsC0a
   Q==;
X-CSE-ConnectionGUID: S+57vOZMQ2qq2OoFptsSkg==
X-CSE-MsgGUID: rp4pCxlwRg2ZulmF6kLycg==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="69028833"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="69028833"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 05:05:47 -0700
X-CSE-ConnectionGUID: PhdTntVzRkWiOa7hIQf+kw==
X-CSE-MsgGUID: eEaDqQGfQ2+E8tPZ4tpBYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166188263"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 05:05:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 05:05:46 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 15 Aug 2025 05:05:46 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.46)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 05:05:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tkjO7sttb/BV69gvkR0TaNrAsplzi3FvGm186Yhl0jTII17e5yM1Q460WaWZoaObH/w261RDEAOUCFJEq88xk3rlJhfGThCrSHWt7lwoTU0VcqlNkgRm/wn2PMU0JuLaiN/2Y4ml03UuxcQrZe7PCp4vbxenVnU8HCuF+nx5mYnSxWhWzXSwvWgPmIa4Dh9JREUdtjgUv0luP7hKXN8MoSFI6WYPiZS5fjQddSnOKDueD0fAugStFABotHBSClCVvBcl0blcgfzIIhyY5Hd3XOm6JS8rNiwtv2K7V6lmvk8TgPiog/v+deyYmTQWhwx+dce3/43Jq2wgTujxAgDdkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wA6Sb9eQaW4sr40ejinVOSu7jQ34LT5VuFli8HRGENE=;
 b=cu4P7m0Grh2/V45Qqq3+IPseP8+S4eqRRZQmEo+2dNBOe9S+A8qrhM0tKJgdj+928fYSklX886bd/y3L33lGNxG3oDuz8vjHOdu84osi3NKzkDS7w4EnKs2aizPG0H7kxD8OCHQZj4ypSoO5OEspBolFAQuW7fjCsspIDJxYhdMyG8yH63R3bQdpj0cK3QfnXnlJAa9Q/72j2QjH1scujV4ULXPAW5vRHMS9FdaCR1oM0/fFYmmrpDTcZT/RQTUNGRhFchwgAZB+F9IYtRbV0qnwsWW4fMXchEmeMNYNi0GbGROgYurzUtO7oXN7m6PBpLNOP71bQ8ZoBM83YaNyZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH7PR11MB7513.namprd11.prod.outlook.com (2603:10b6:510:270::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 15 Aug
 2025 12:05:42 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 12:05:42 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"mingo@kernel.org" <mingo@kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v14 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v14 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHcDO5KNGBQKN56qk6Tqt+5dMDdJbRh47qAgAAk8eCAALOwAIAA44AA
Date: Fri, 15 Aug 2025 12:05:42 +0000
Message-ID: <DM8PR11MB57500E1E866CCB986CDEDA32E734A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
		 <20250814073640.1507050-5-elena.reshetova@intel.com>
	 <a74ede5f4466572e33c92fceb69136b82c042d7e.camel@intel.com>
	 <DM8PR11MB5750E0E7EE14FA87E9C48336E735A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <f5e9a2fc1b3f11ed8bf1525a53d0f7ce830200c5.camel@intel.com>
In-Reply-To: <f5e9a2fc1b3f11ed8bf1525a53d0f7ce830200c5.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH7PR11MB7513:EE_
x-ms-office365-filtering-correlation-id: 4d102bd5-6f07-4c30-5ee3-08dddbf40ec7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a1dLYnlwOGM3VEhEM2ZEZHB5SXRCVTVtSExCcnR5UGgrTUdTcnpQUjI0UlEy?=
 =?utf-8?B?TVpTMmxScjk0Yk0yRHpzZWZEYlZiMG5oYjI3cVcyYktjWXBGb2NzbGtHMms0?=
 =?utf-8?B?cndqMWJVTXhET0p4bm54Qk90M1g3QVRtQ3BTV0tqWG4rZzNNTEx4bTJJU3Zn?=
 =?utf-8?B?K3ZEN0xEUWZuVTUzQWdxRSt2ZnlGUFFVVzVvS2lpbWE2RHpYWHMvYk5vTG5u?=
 =?utf-8?B?eE0zWkl6Um1hUVdWelJsdmpiZXcyTHpuTVRNMDR6SkY3akVNYkdRQVhHR21S?=
 =?utf-8?B?QzJEUlJlQm1ZNmtVSGxBeGp5WGE1NWZoeTFqNDNSU2I2a2NIU1NQSVFnMXZ4?=
 =?utf-8?B?OWxlYkdQVlhQTjdNN1N4cUtrYkkzVTlWSVFJWmlhOVVzZjVRN1B1SlNPRDNx?=
 =?utf-8?B?eGtGSFA1TG9JcGV0RUk0d0dDVXdnMTRrdnRaK3RQaytFNnhobnc2RDVJdXg2?=
 =?utf-8?B?L0JON2o1MEl6U2ZBZG8ySFZRb3k0U2oxeW1iNHNlYlRMOUFoSDk3YTF0U3g1?=
 =?utf-8?B?VFg4NkZ0dzlGN0NkRWlBYUc0ZWJIWkQ3Yzlrdk5PaGgxYmpWWEl3dUZLNklO?=
 =?utf-8?B?R3RkRXU3QU9TZGR3b3ZobHdNZDBmL3ZzNkRDTmFPbDB1YVBiL0V2R3hWdUh0?=
 =?utf-8?B?U3I5eTQxZmI4MUM4ZThFRmFXSXRlYzRrZzc4TXo5c3FWaFU2MmZldzhlZmht?=
 =?utf-8?B?TnZxQzc4WXZaRW11bUFOVWg2VHBIcUFJaFM0TXc0K25WNEo3dGQ3Qk4wdWVC?=
 =?utf-8?B?NkVsdFFjMUNvNTh2VXhQMDBicFNlUW8vZS9mNVM2VWcyQlU0MXRFS0x2dDdE?=
 =?utf-8?B?WjU3VUZNLzF6eHJ1eHNmaEJuRDF4cWhldFQyczlBRnhsR3QveHlnRGZwYlBY?=
 =?utf-8?B?WXkwVHNENWI5SzFjMUQ0VTJrRE5EOURQb3gvYUQ5cmdsVmMydWR1aUdKOTJm?=
 =?utf-8?B?UGNKMVhqSG5TMmROV0M1bVFVdUhkcm1GV0pMYnNGSjVwbllZUWpYSWdmWHIz?=
 =?utf-8?B?aFZ2NHJXdGxOSTdxU3BBbW5jdjdsK0dYOUEzZEQrbHYzcVA5UXFJb2I3OERu?=
 =?utf-8?B?T3IyUUsxcnJxMzJDVFQ0alc3NER6V3lRanBybStjUEN2NzB3K2Zad0Uvc3A4?=
 =?utf-8?B?ZU0rMHJhT3NrSWs5bmtZd1M2MEE3azg3MWFpaUZuNU5IYlRxNGJVNDIxTlhS?=
 =?utf-8?B?cC9UeXZIeVNvdFhyWFpUbXovaklTM0xuVWtMMmw4Kzlud1pRdzJ0TDJqSlk0?=
 =?utf-8?B?RjVocjZwcm1YdE1KUGd5Zmozenc3akQ0UXVrTHZhQ2dmN1dKYzJKc2V6bjg2?=
 =?utf-8?B?ekhWK2QzcERNNDE0ZDlUMzdMelozVS9mUDhYRE1MaEY2L0dKZE52RkQ1QXY0?=
 =?utf-8?B?Y3NBbWFDaXRFM3J1SmxPaGtqa1FpSVBlSDErZ1NrbDJvbUJPUmMvVHV3OXBT?=
 =?utf-8?B?YUN4SVRUVDc5L0pnVjdQRnBUZENzOEVobHBKSFVKcGcxT3dJTW1wNjNTckJw?=
 =?utf-8?B?R3FNZytaanEyZHc1TGExUVhNMk9OYlpid3c1aFlNMUxVb1drenZ1YXBDMEU4?=
 =?utf-8?B?SmxVaGl3UW1XTnI2RlFoMmdleFl0OUtrL1dUc09yWkJwcnR0KzFjVG1jUWlQ?=
 =?utf-8?B?UTJOOHdNQ2JjTi9mQk84MGRSNmNTMzFtU21hQXNwMCtsSnFSWFBxL1pmUGxQ?=
 =?utf-8?B?aVMxTDd3VGlxRVVza2JOckwyV2RqZGNLN2NIc2hvWEE0TmZQRGt6cFlJaW82?=
 =?utf-8?B?MnVtcXhyUVJFOTJwRDExNE9UcGMyWjBuOFl1Y0lMQUJ4bmVoMGZkbGIvSkx4?=
 =?utf-8?B?K2NFa2xmeE5sVUpYMVJncThoSENSU3VjcU5CMkxBR0ZudDV5VGlOTjNpYVcv?=
 =?utf-8?B?MXJ5bjl2RVUvcTlyYU1TR0dlZTZITGFITjkxTnRrYmZLeHpxVTZvR2lITFhn?=
 =?utf-8?B?ckZ3VURRckZlUGpER09takdaZThJUlNhUStBT1QrN3ExeFlHQkYrWHR6TGJ4?=
 =?utf-8?Q?DdQ2c8J7paJOy5nFA0HMkAJp70TM6A=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDUvVjkwT2dBMnllMGdnTW5pTzM0NlRCRlhUYkJjWVhzV09FaTNpVEg3YTk5?=
 =?utf-8?B?c3FiYnNnWWozeUx1dzNHRy96elZGY25QMW9ORFBhWW96ci9TQmM3TG5CdmIr?=
 =?utf-8?B?and3Sm5IcVRrMTBZVEROTjFkbnI5QitLbnUvMXZ0Q1lSYzNlSGtMc0Q0L0pk?=
 =?utf-8?B?dzJDN1ltZGpJRFk5cm9KZVRqNW9qWk15MEFLT3lCSGVRc2FBTTNHTkZBMnpP?=
 =?utf-8?B?WDJTbUxQelc1UjhyZlcwUmoyRzJXSG5wYlVwODJ1SEtRNXhSQWJaYmZDdkVk?=
 =?utf-8?B?d1J0dGwxN0ZEM1B6R0VlK3luT1dTR2hQRUtYR3pPdTI1bmw2djd4YytCYzZp?=
 =?utf-8?B?QWF2RjExT3Y5UnBUMlN0L1YrM0lIak1ha21MeW50VHc2ZGZBREdLSkg3bXFS?=
 =?utf-8?B?OGovcnk4NkJiRnY3THV3ZHVVM2txVXVyQnZoRGhGNm9XZjU5dWZscWFFVVVL?=
 =?utf-8?B?ekZ3NUlJZHNJSlZHQzhoMkc4bVdZTHZkQytuL001RGt5Vzg1SW1rWlR4RlFI?=
 =?utf-8?B?U1ZpZ3VDd25La3VzcGpJRzlHQjVycFVMNFNmaU1iUnN0czZvUXcyait6aUtu?=
 =?utf-8?B?b21HdUZBdWJGenZUNXo1eEwzR3BlU0wzWjB6Ky9Xb0JnZ0hTTi9JcENqNEFv?=
 =?utf-8?B?by9yYVdVYnU3UHN4UE5sYnlSVllxTEd6ZDJqRTJsbFVrTlo5T2xzTW5xZjE0?=
 =?utf-8?B?ZmUvK3NST05EcWw4MDN2NmlPRVhKd2d1blFaVVlodFlZMWZmSzhwa09zeldo?=
 =?utf-8?B?L2FJVGhlVDhGUCtVR2FoVzBSaDNvTmd1dUF5ZjQvbzdYS3lQNjNWOGlRMGYy?=
 =?utf-8?B?SkFrcGlDNXdnVGtLd002b2R2Vkh2VDFSZmNNUmh5STU1YUphd3hQQUN2cm90?=
 =?utf-8?B?Q1JOTGpFWit6VW43ZVBHbDBPcFB4dFJKRkJuRXdqalhhTTIvc0RQaXlBRVlv?=
 =?utf-8?B?VHEyY05wdy9iVUtLRm9FaXJHWmJKb2FLNWNOd3lVWUpMOVpBMlU4eFdqRGdo?=
 =?utf-8?B?QW5zSXl0OEM0K010Q0NYaERiai81cmoyWmt1dWJkMnBoNTNBQ2RZNmIzOGpS?=
 =?utf-8?B?OTJWREkvbGh4KzVTRmpzeUhTbnBiYjlVTHE5RzZwR0s0Yms1Wlk5UkhZMkZm?=
 =?utf-8?B?Z1FxWS9HZkdCSEp1SWd0RHJ4T0Q2WFVIa2w5VzVPVDcvUWRSaWJWUm1mVWtR?=
 =?utf-8?B?WGhKNEdXTWgzYVRFTU9tRGsraEtZVDNwRmhPeEpZQ3p5L3FCbTlpYjVKZm0z?=
 =?utf-8?B?dTlkbWVRYThKK3pZRzZXTTZzTFVZbDIxeVUrZFNsYXZTTHUvODg0NGw0M0cv?=
 =?utf-8?B?MWthcGF2WkxaTEsxTURTek5yWTNwNy93Z1ppNGthbjVBT3R6cGtmWk4vZER0?=
 =?utf-8?B?ZVNxU3oySmVWSjd1bVc2RHMzUElmMFhvU1ZIWkhJcDhBNUQ3RnE0Zi9DREdZ?=
 =?utf-8?B?RHg0VzNySFFrbTNkekdDK3JxRkNUTlUzcVoxN09FL2JOd1NNNHpGcENEWHNV?=
 =?utf-8?B?aWJHb2RlMXMyTDJQQkVVcFFTWno1OFJKU2ZQTzN2dExjWEFWbWJoa1RHa0sy?=
 =?utf-8?B?amwxVlRheXJSU2J3SHRwc3ZSd3VBeDFIcXVNVEpBWU9lNzhqSmVXeHZyWndJ?=
 =?utf-8?B?ajJvc3M5NVB5TjM5dHlENytScXI4VE5WY2dWNVFYZUs0by9qdlp0MHVPanJG?=
 =?utf-8?B?Vlhya2szTFFwUUkxSnZyNGpjdXdNUjJIdlJNZlFEbkxIL1krOXgybmhCSEsy?=
 =?utf-8?B?cjdFUERZNU01QjV2cG5hVkFvMjdrbEJMWnBJYmFqS3dHVnZCcXJjWXdWOWo5?=
 =?utf-8?B?S1NyL0o5VTY3NVdDOEZOdk5TZkIwQTlndlVVQUhEek4waEUydHNPL01vaEp4?=
 =?utf-8?B?YXBVUVlneEI4YmNOK3pBOXZXSzNrQW9yY3Nka1hyT0l2VFFCVTZNNElMWXk4?=
 =?utf-8?B?ZkJDNmlYeGJPTUROelJwS09Nb3lUOXZHKy9mcW5MUHRhd2NFbnVwM3dEN0hC?=
 =?utf-8?B?enVkTWxaaVNIUnA2WEJ1SUJ1eVdvQjNPR1NFZFBZWU0wY2NoM3pPTEU2U2sv?=
 =?utf-8?B?bFdKZVU2VWgwNHB2eWV4cVgzQkswN1I0QUgwMHZ0ZVhsdmU5RFRtR1NiSmR1?=
 =?utf-8?B?YVlKYW44cmlQVk1GQ0FMaXZuNWtuN2FrVFN1d2ZLc2lXNXY1WFRaYnBJUjZR?=
 =?utf-8?B?dUE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d102bd5-6f07-4c30-5ee3-08dddbf40ec7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 12:05:42.2736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EpE3fHWh5mHhqh7ExS/hKifmamNY6OQgcM/esuglikW6Wvc7H/Pv4eBaHTeJFuTxChQfV9FekSNJO/sGB7d+KbTbvekiaFd1KCH8Vyie0z8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7513
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBBdWd1c3QgMTUsIDIwMjUgMTozMSBB
TQ0KPiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT47IEhh
bnNlbiwgRGF2ZQ0KPiA8ZGF2ZS5oYW5zZW5AaW50ZWwuY29tPg0KPiBDYzogbGludXgtc2d4QHZn
ZXIua2VybmVsLm9yZzsgbWluZ29Aa2VybmVsLm9yZzsgU2NhcmxhdGEsIFZpbmNlbnQgUg0KPiA8
dmluY2VudC5yLnNjYXJsYXRhQGludGVsLmNvbT47IHg4NkBrZXJuZWwub3JnOyBqYXJra29Aa2Vy
bmVsLm9yZzsNCj4gQW5uYXB1cnZlLCBWaXNoYWwgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT47IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IE1hbGxpY2ssIEFzaXQgSyA8YXNpdC5rLm1h
bGxpY2tAaW50ZWwuY29tPjsgQWt0YXMsIEVyZGVtDQo+IDxlcmRlbWFrdGFzQGdvb2dsZS5jb20+
OyBDYWksIENob25nIDxjaG9uZ2NAZ29vZ2xlLmNvbT47IEJvbmRhcmV2c2thLA0KPiBOYXRhbGlp
YSA8Ym9uZGFybkBnb29nbGUuY29tPjsgc2VhbmpjQGdvb2dsZS5jb207IFJheW5vciwgU2NvdHQN
Cj4gPHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjE0IDQv
NV0geDg2L3NneDogSW1wbGVtZW50IEVOQ0xTW0VVUERBVEVTVk5dDQo+IA0KPiANCj4gPiA+DQo+
ID4gPiA+DQo+ID4gPiA+ICsgKiBSZXR1cm46DQo+ID4gPiA+ICsgKiAqICUwOgkJLSBTdWNjZXNz
IG9yIG5vdCBzdXBwb3J0ZWQNCj4gPiA+ID4gKyAqICogJS1FQUdBSU46CQktIENhbiBiZSBzYWZl
bHkgcmV0cmllZCwgZmFpbHVyZSBpcyBkdWUgdG8gbGFjayBvZg0KPiA+ID4gPiArICogKgkJCWVu
dHJvcHkgaW4gUk5HDQo+ID4gPg0KPiA+ID4gTml0OiBpZiBhbm90aGVyIHZlcnNpb24gaXMgZXZl
ciBuZWVkZWQsIEkgdGhpbmsgaXQgd291bGQgYmUgYmV0dGVyIHRvIG1ha2UNCj4gPiA+IHRoZSB0
ZXh0IHZlcnRpY2FsIGFsaWduZWQgdy9vIHRoZSBsZWFkaW5nICctJywgaS5lLiwNCj4gPiA+DQo+
ID4gPiAJKiAlLUVBR0FJTjoJLSBDYW4gYmUgLi4uLg0KPiA+ID4gCQkJICBlbnRyb3B5IGluIFJO
Ry4NCj4gPiA+DQo+ID4gPiAuLiBpbnN0ZWFkIG9mDQo+ID4gPg0KPiA+ID4gCSogJS1FQUdBSU46
CS0gQ2FuIGJlIC4uLi4NCj4gPiA+IAkJCWVudHJvcHkgaW4gUk5HLg0KPiA+DQo+ID4gT0ssIHll
cywgdGhpcyBjYW4gYmUgZml4ZWQsIGluZGVlZC4NCj4gPg0KPiANCj4gSSBkb3dubG9hZGVkIHRo
b3NlIHBhdGNoZXMgYW5kIGNoZWNrZWQgbG9jYWxseS4gIEkgZm91bmQgdGhlcmUncyBhbg0KPiB1
bm5lY2Vzc2FyeSAndGFiJyBiZXR3ZWVuIHRoZSBlcnJvciBjb2RlcyBhbmQgdGhlIGRlc2NyaXB0
aW9ucywgbWFraW5nIHRoZQ0KPiB3aGl0ZXNwYWNlIGJldHdlZW4gdGhlbSB1bm5lY2Vzc2FyaWx5
IHRvbyBsb25nLg0KPiANCj4gUGxlYXNlIHNlZSBiZWxvdyBkaWZmIEkgY2FtZSB1cCB3aXRoOg0K
PiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiBiL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiBpbmRleCBjZmY1YzRkMjJhYzIuLmM2NDY3
NjI4ZGEwNCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jDQo+
ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiBAQCAtOTI5LDEwICs5Mjks
MTAgQEAgc3RhdGljIGludCBzZ3hfdXNhZ2VfY291bnQ7DQo+ICAgKiBjcnlwdG9ncmFwaGljIGFz
c2V0cy4NCj4gICAqDQo+ICAgKiBSZXR1cm46DQo+IC0gKiAqICUwOiAgICAgICAgICAgICAgIC0g
U3VjY2VzcyBvciBub3Qgc3VwcG9ydGVkDQo+IC0gKiAqICUtRUFHQUlOOiAgICAgICAgIC0gQ2Fu
IGJlIHNhZmVseSByZXRyaWVkLCBmYWlsdXJlIGlzIGR1ZSB0byBsYWNrIG9mDQo+IC0gKiAqICAg
ICAgICAgICAgICAgICAgIGVudHJvcHkgaW4gUk5HDQo+IC0gKiAqICUtRUlPOiAgICAgICAgICAg
IC0gVW5leHBlY3RlZCBlcnJvciwgcmV0cmllcyBhcmUgbm90IGFkdmlzYWJsZQ0KPiArICogKiAl
MDogICAgICAgLSBTdWNjZXNzIG9yIG5vdCBzdXBwb3J0ZWQNCj4gKyAqICogJS1FQUdBSU46IC0g
Q2FuIGJlIHNhZmVseSByZXRyaWVkLCBmYWlsdXJlIGlzIGR1ZSB0byBsYWNrIG9mDQo+ICsgKiAq
ICAgICAgICAgICAgIGVudHJvcHkgaW4gUk5HDQo+ICsgKiAqICUtRUlPOiAgICAtIFVuZXhwZWN0
ZWQgZXJyb3IsIHJldHJpZXMgYXJlIG5vdCBhZHZpc2FibGUNCj4gICAqLw0KPiAgc3RhdGljIGlu
dCBzZ3hfdXBkYXRlX3N2bih2b2lkKQ0KPiAgew0KDQpUaGFuayB5b3UsIEkgd2lsbCB1c2Ugd2ls
bCByZW5kZXJpbmchDQo=
