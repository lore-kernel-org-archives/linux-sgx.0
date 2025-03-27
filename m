Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C34140E30;
	Thu, 27 Mar 2025 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743089498; cv=fail; b=KpiyqVgsrFMT/0euvLC0n7hqKA34WjiaLzZnqvoQWzZxe+DVbOdegoBEPNcxqQ//Y5pKTPrRfS7pXGHYvwTra6Mx9Ol0k3zI+2c1Jo+aKOuRRrDIxIIYJeM3jZEMrakFbpxoaiiX8eTjO7AswEB6qCqJ3R8O03ifk6bXk5PUTxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743089498; c=relaxed/simple;
	bh=IMcx/KTensDDPJuQ1I7KWHfXg8Hr+AepAXwCGLHZ528=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SVvNtVkOJ30hbtQQmlrrfC5TpiaOWCkc6flCj233/dCQg63kkFiuifcVPBCh/TjYfCcPGj4VOWY+yqDjEc6L5qx62KyH6F1k2f6fvDmX/GvtpcVbL7as5oGDaQVd0BKwWNot7QGbMz7rNClTxUKkB/zqEFGpIJDBHKP5Zlwh3lE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jib+GXv2; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jib+GXv2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743089496; x=1774625496;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IMcx/KTensDDPJuQ1I7KWHfXg8Hr+AepAXwCGLHZ528=;
  b=Jib+GXv2Sy/QcPUk2VKacYeCtCt2ZR89MDSb2KPEq4T6VtDcHhm1FtIa
   xA70uemF8a10levTUMAArF7mP1tFva5rqs8jYegTmD7FDxasWwc5XcCyt
   70zpXX2yJuDHWQNiGdTP8E1ZS2uRYu/8OCw57dv5g09EeID5mTM0ing/w
   zm6ZdHRUPem7EvIBcIsYZibvcThjZDivQ3FCdl7lhQidVF93B9QEBmySH
   ZFOe0jdt90j9KvPaI3aH9O652Hvlp5YkuuJqnaAgnQLNV0D1p1YnA/waM
   o3e2QDigYTYbHtfITaglgRkoPOHxCl6J/Kd/JFm04W90enaI96cJVcRhM
   w==;
X-CSE-ConnectionGUID: rYMt6ENBTIK6B00YxgFvZw==
X-CSE-MsgGUID: qzy/isnsSserGTvcMlVDsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="61962284"
X-IronPort-AV: E=Sophos;i="6.14,280,1736841600"; 
   d="scan'208";a="61962284"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 08:31:35 -0700
X-CSE-ConnectionGUID: gR8cAsG3Q0mFsbDVo4MkEw==
X-CSE-MsgGUID: Vd6vCx8oQCOauEKqdf5wyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,280,1736841600"; 
   d="scan'208";a="162407773"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2025 08:31:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Mar 2025 08:31:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Mar 2025 08:31:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Mar 2025 08:31:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BWrlSMepzTwfqNOUJHXybGbD32KRDGMonhHT3Jqoa7QpNgxx2uE21egZ3ZQDexfzrQGSsG+Nlanf/CoSfz6UGAMpJDuHbfgpj0aPy2I58mtr4SNChQa57yu3CIZd7m7QNg3WZ1pgAi/7Hv5b/85reqtITo4YdoEKxkF/6QLxU8eiu4PqPSUVWnHqiPmJvOMEAgI4CPqDz2NVS7KGzuSdlJJrLw1yLmXzoqMzx7B7ducjulJijXURgN34237AF2nkYeLEkwbnDtQWRS/pFhxtiYfz6R7GHzzL9GGG8YET0m89+TXPZ+taQCp0YuuqT35Gl/KYgPdTlVMUM2lOQ99bSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMcx/KTensDDPJuQ1I7KWHfXg8Hr+AepAXwCGLHZ528=;
 b=prF8brmuUd4CDVx5ryPRLXPIBHLaSUOxlyM4qKdBZskICJ1Mb6OyAbrZ9vk/Num02xDxmvI6wM/7nsdQW5hP/peRB5VgaUGo0YOGwexIlQfwmQc67+yfMr9//2JPP4cJwCR+CCTPh80N1CvhepmrBF2WyscNmlArtf+ZG0cOXtd5TQU683nRparlcXOgAvWRJWn5aqZbezdcEmyIWosEmilAJOJxQ+7Bz+AMSBSyAfgn2XyuGPrV1O/cr/0fUTeO8quxbyWDbaP7I71Se6Ahg8UvcpR6/DRwofwhEnqknEcUrVBofxLUlgKERkK38R1gTUdmmldhajPHLASYnfxw/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SJ0PR11MB5789.namprd11.prod.outlook.com (2603:10b6:a03:424::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Thu, 27 Mar
 2025 15:31:31 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.040; Thu, 27 Mar 2025
 15:31:31 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH 2/4] x86/sgx: Change counter sgx_nr_free_pages ->
 sgx_nr_used_pages
Thread-Topic: [PATCH 2/4] x86/sgx: Change counter sgx_nr_free_pages ->
 sgx_nr_used_pages
Thread-Index: AQHbml5v6wUxy5pYpkGncBs5Qx0PeLN/udYAgAJ9lCCAA6krAIABRO8g
Date: Thu, 27 Mar 2025 15:31:31 +0000
Message-ID: <DM8PR11MB575001F32AD2F55043EAA670E7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-3-elena.reshetova@intel.com>
 <Z981ciAqpknQ3hRF@kernel.org>
 <DM8PR11MB5750B9CBBB7A51CE3A0F006AE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RecEZhXshD6yma@kernel.org>
In-Reply-To: <Z-RecEZhXshD6yma@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SJ0PR11MB5789:EE_
x-ms-office365-filtering-correlation-id: e74df07a-d33a-4b43-2724-08dd6d44732f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OG0wNlNYWmY0YTJwU3V2dWE2TUZaaU1QaEdudDFYTU1neEZwUm9iUzR3MWNz?=
 =?utf-8?B?d3k4a2J4YktPSzhKMWZKaWxUa1Vpd3hZQlRLZDZVSlhxMlFpT3VSZE55elNm?=
 =?utf-8?B?dDJtemxXTTZYcjZVUkF2UXpkdGVZa0F0QWw3UlJIME9kTHFLZEJNcU5HN1dn?=
 =?utf-8?B?RWoybkIvQlNPWjZKZUlLaXFJNnRBNjlOeEd1VDZRMlM0NmMxMmxLUlQ1c3gw?=
 =?utf-8?B?aFU0L1NXMllxRlpNYlZHbUtlRVprdDljMERlekV1WklnQzJxUWp4RWF0OWp3?=
 =?utf-8?B?Q0VINXFVQnZybFpmYUcwN1RzRkt1NHIvRGQvdFQyODNrSXJOV2JQOWdSY0FF?=
 =?utf-8?B?UzlEekJwL0FpS0F2dWFxQzlIMjJaaU5CdXNQakVuN0UvME9ML2E4Yk1MTUhZ?=
 =?utf-8?B?bDVNd01VcGxsRkU5dGMrTUMrcmhKYXpac0ZPcGpNK3pnV0RXaUVkZDFpMGdY?=
 =?utf-8?B?c3B2ZzJkOXZkNmVwSytCZWYyWWxhaHJ4RlU0N3pCdGUvRll3NDEyeWY2RUJV?=
 =?utf-8?B?OU1GS043dXgwZ1Rqb09tMEMrNnFoZU1pTW1rV1gxWDJhdkYycU8yRG4yWXJF?=
 =?utf-8?B?SFFUYmxvODdWMmxDMUx3SE9TYUFxcmpQU1F0REpNQkNNa1lKSndyRlpNeUFr?=
 =?utf-8?B?dG9VdWdGZjZ0b2c0TG1sN1FBYjBiU1RmZ1o2eHRvd3dhTFJ5azhTV2JSSm51?=
 =?utf-8?B?aDB1c2V4SlhsR0Y2TEwrTExsMXU3L3o5ZjBzbmE3Snk1VGFQb3BNU2o2d1Zx?=
 =?utf-8?B?alRLRVJhR3FGRGtKL0tLYjRKbEhZaTR2b1ZQMnk3elc3OXNTb0IrcUlGVUJm?=
 =?utf-8?B?RGJpY1YwWEVEODYzanM4eGVDMmUxcEllU1pNcHhOeDJ6WEJTc2tSNnJLd2R0?=
 =?utf-8?B?WnFIK3RId1hsaXJjdVZCYW9KQVg1V0ZINFpSYzNIQ3FJZEE1R3FGZVdnZGNa?=
 =?utf-8?B?Vm5Ra3kyL1lSc0N0MjRBRHlMV2hsaytOMi9HQ0g3WnZ3WE9jY1Z0RG1RS3Bw?=
 =?utf-8?B?c0tncWM4Q3FSQjR3blRWbkd2Z0g5NTd2U0lZRGk2Y1hFWUpyY1hDSUhvWUc1?=
 =?utf-8?B?dGJiWTF5QjcxZWQxWXdnY0lPc3B1UW5jQVJ4aWJlWHBKR1czR1BsQUEvYU1V?=
 =?utf-8?B?K0g5RjVsSVlvVUFhbDQzdC83ZmpxVHp3MU9jejFtd0FMT2swUTVlaVdLV0Z4?=
 =?utf-8?B?S2RjRk90U1NtS2NxaWZBUXRpZkxFblJlQmRkK0FURXdUUWJvR0RYb0dqWmxh?=
 =?utf-8?B?K1pqTTFSdFFmOGVEZWlGL2Y1QS8ydEJPVjluZXJRcjdubWFPTlN0MXBjR09x?=
 =?utf-8?B?aXc1cUVCOTRGYVV2dW5velorcEgrbzBFeE0xTUpKcE9XMEI1TEl3SmRYajZD?=
 =?utf-8?B?MDJwSDZtTVNFKzhuNC9QWGZEcDZpNFZvY0JIMXh2bCtTaGVyTEU5TnlTb2s4?=
 =?utf-8?B?TDVGdXdRNUVtUkZ6Rm1jdW85OXdkOWNYMFhiOHZ0NUgwS2hzUkx6U1Y4VmJ1?=
 =?utf-8?B?TUh1TWZmQnFybVkwVWhEZERSZHMrc281azNPS2xReWFJTktkY0kwNld0dlNS?=
 =?utf-8?B?dU5UWWw1ZmlabEhWWmw5cHZGVEwvNlM2anJzZ2pDNWhLU0dIZXBySVo3THM5?=
 =?utf-8?B?MG9rUk1GaDd5cEZQWkRIbEZpVnByRjRwckNqSVlHbzdSVDJodkl5OFdFYXdJ?=
 =?utf-8?B?RUFOWXdTb3hpV2lSY0VFSStkMDltTUVzQzFTR205TXhQTW9QZzVwNGNyU25i?=
 =?utf-8?B?Y0JKczVlZUZNWDhlV1hobkNvaUhHOWR2VEowQ0VTZXlMMTdOZDVLbk9jS0hW?=
 =?utf-8?B?Sit5bUFkVU9yVTRISmpIaTF0L0c2ZHY5Q2JaUGFMUUdvVDBiSUNuK1g0Rllo?=
 =?utf-8?B?ellCNElpam9ieGhFVjZ2b0xPWGN2c3V2dlZ2OXNCbjJFYUk3UXpHaUNpV3lt?=
 =?utf-8?Q?iPjvKw2fkNL/R79zTQzoIXw3cSj2O2AK?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K25reDlHdDMzVlBuOHQyei9pcFBNbktZb1NlaXBGd3diRXRBbGNoM2p5d2Ru?=
 =?utf-8?B?MFZsdlhhTjU0c1BPd1hndCtoRGt0djV6anpzZ1hkZlZhNko4YkxvODZ6dUgr?=
 =?utf-8?B?Q21WV2ZHQ3ZGbGlRVnZEQytFZ21KKzBBcnQ0VEMxaUZaL3ROUDl0eVNNNFZY?=
 =?utf-8?B?NjhVL294UzNmTVVGOTlpaGNhcm5yd3FaR3lrQzI1b2pOVEMrUzhvcmRYZ0M1?=
 =?utf-8?B?eTZHQ3lubFZuN1YwTUhYb3d2bjFEc0tWMXFvSnhRTm9IcmdXbjZ1aHMxVVhS?=
 =?utf-8?B?SWNaNjVSeE0ySHlXemlEN2o4azFxZmU0MmVEMWR3SDZvSktibm9kbXBiSkVx?=
 =?utf-8?B?OEJTbWcrUzVSQnROSW40USs1VUVpMFhqZk1JUVV1dzJkckNyMTJkN1BCa2Z6?=
 =?utf-8?B?TjN0U2dlZXJ3c1VFSlhkSGw1bnpNK2dtVU52KzNQeVlUVE1HZ1VXZ2VYWFhD?=
 =?utf-8?B?UjJQWHVTV3J5bTRHdnI2MmpwQm81NjRlaU9yVVB6OUF5NTFyUmxuZUpleWk3?=
 =?utf-8?B?UzZ0MGxjUlZiaE95KzI0TDBRN2tORFVFRTFoM0wwdTQwL0swQnExQldRM1pF?=
 =?utf-8?B?U1Rwb1A2cjd1bEJEVjBBZ05tY2U4eVRKdmUvY1Mrdm9MWHljOVUwSkJzdFVM?=
 =?utf-8?B?b1RBV0hsMVJvQkQ1SmdmQ3RlMVp1bHlUQ1BiRW9GUGFGTzhsamlhTmI0OWR0?=
 =?utf-8?B?ZVJJanlkL3ZsZndGVFFNWXlnMmFCV0dqeEN3Tno4d1RUcmZmNDdydXp0VC9N?=
 =?utf-8?B?NHNCbGVWRFBtTmFkV2RtbHZQSVdnczFFQjdSN0hHUVBKSnF5Mkl2Q3llQXZj?=
 =?utf-8?B?U3FOTGkwQ1EzbjAydjJua0g3TXVxV2hXQWk5aUdUdHJHU0c3aU15dFBtNE92?=
 =?utf-8?B?cU1WTnNVdGRwYWZhN2xCbE9RLzJvREZra3N2cUc5cmY0QUIwcnRxMFVaVzdK?=
 =?utf-8?B?SjJGMWVkOC9rWjBCZ21kZnJGR1diTjZVUHBmUzZBNTF6SmczQVY5MHIwL3JH?=
 =?utf-8?B?bEtKcndHQm5GdnNKYUV3d0laM3JmOWtSVHJtaVp3MGMrQzZ0TWkxbHpBbis4?=
 =?utf-8?B?U1loUmxIb2dJek52d3ZSUWlJbXRlNFBmMnBmUlh0SjlsWmMzQ1hWUWNzUXVP?=
 =?utf-8?B?bCtxY3N5NWJ2cUozeFNDems1ekoyZW56NytaZVJZejcxRDc5ZkJqKzlwa01s?=
 =?utf-8?B?Z2RLelR0cVFlZ0s1QUdhVFZrbytKQlZNRWc3a2RmZ3hXbks0UWpxRk9vVkVa?=
 =?utf-8?B?dDZBZndPRDZYY1RWejhxdjN3czBaTnlJajh3ekJwTXlnWllwM2Z5R1krNVY3?=
 =?utf-8?B?R0diQjQ0RXY1QzBTc2xCR1NOSTN3ZGZwWWJYS3NwZjJiT09lOWhzb1FaWWY2?=
 =?utf-8?B?WWpUZk9CTlFJL1ZBbGhYWW1QSUt1ajlFTlZjRHZRS1k1U0dEeWxZcXJsNXh6?=
 =?utf-8?B?TVpzRll5cUVNVENZcFNScURCMWxNbkljanpuUkpYTWpDajY5ZG93RVFINTlq?=
 =?utf-8?B?Nm1IdWpiQnhSbUFJbHI2dys5TjlCYmhJanQweTBLcHUyME93RTQrSTRYZkU1?=
 =?utf-8?B?RHE0QlJlRmlqdlVxZkNpS2xUOFB6cUNXWENPV2hUNGd2Y1AwQW5zNUJKZHBz?=
 =?utf-8?B?NkwvaFdVZ0l3K3M2MUpPTGF1cSthMmw5R0tOK0c5ayt3TXh5Rk9iZVBRV1cx?=
 =?utf-8?B?NWp2OS9hWi9RbHVhM2xxSWsvNW4wYnZWbUZOSjQrRVA5NzJXemQwNGRiSTdG?=
 =?utf-8?B?SVNMZTZGNisxY0FlVkhLSkduMC9NWER0eEJPRjg4ZHZjM1NUL052R2d3UjBr?=
 =?utf-8?B?dTZpSHpXY3ZUMld2VVI3QUtWL3kvY0JqU1Nza2RmY1ZwRXFBMytaM2xXTmJz?=
 =?utf-8?B?Z2xYR3lOK0hndHh4bHJxTVgzbE9kK3RNc0lmWlMyTnJ2VCs1WHlFUlhUbEpZ?=
 =?utf-8?B?S1QwRTJTWEIxVlJLS2p4WFk2NW1LTlYxb1c4b3RkL0wyWjRocUdWSG9RTVpi?=
 =?utf-8?B?WUFaeHNPMTlROEt2Y1UzaDRxUUpwYkpFcUdTdTdoS0FpelNaN3pGNmNMTW90?=
 =?utf-8?B?TlczSmlXL3M4WTNreGt3SWRTdXRzbEh2STB6OG5MZjZOOXBGT1NRcHZGZ29w?=
 =?utf-8?Q?wyAxzAdaNemRhT3Bhn/gIVn8b?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e74df07a-d33a-4b43-2724-08dd6d44732f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2025 15:31:31.3521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 37S11RG3qjbfxPMfcA4YqwXruPLiQaVXohx+XqXf1Gm52SavX0V06RD+sd/sOfHzbTWUWl6XYSa581EY2HbWhf2gFa0HN/3c5+//nJIjCzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5789
X-OriginatorOrg: intel.com

PiBPbiBNb24sIE1hciAyNCwgMjAyNSBhdCAxMjoxOTozN1BNICswMDAwLCBSZXNoZXRvdmEsIEVs
ZW5hIHdyb3RlOg0KPiA+DQo+ID4gPiBPbiBGcmksIE1hciAyMSwgMjAyNSBhdCAwMjozNDo0MVBN
ICswMjAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6DQo+ID4gPiA+IHNneF9ucl9mcmVlX3BhZ2Vz
IGlzIGFuIGF0b21pYyB0aGF0IGlzIHVzZWQgdG8ga2VlcCB0cmFjayBvZg0KPiA+ID4gPiBmcmVl
IEVQQyBwYWdlcyBhbmQgZGV0ZWN0IHdoZW5ldmVyIHBhZ2UgcmVjbGFpbWluZyBzaG91bGQgc3Rh
cnQuDQo+ID4gPiA+IFNpbmNlIHN1Y2Nlc3NmdWwgZXhlY3V0aW9uIG9mIEVOQ0xTW0VVUERBVEVT
Vk5dIHJlcXVpcmVzIGVtcHR5DQo+ID4gPiA+IEVQQyBhbmQgYSBmYXN0IHdheSBvZiBjaGVja2lu
ZyBmb3IgdGhpcywgY2hhbmdlIHRoaXMgdmFyaWFibGUNCj4gPiA+ID4gYXJvdW5kIHRvIGluZGlj
YXRlIG51bWJlciBvZiB1c2VkIHBhZ2VzIGluc3RlYWQuIFRoZSBzdWJzZXF1ZW50DQo+ID4gPiA+
IHBhdGNoIHRoYXQgaW50cm9kdWNlcyBFTkNMU1tFVVBEQVRFU1ZOXSB3aWxsIHRha2UgdXNlIG9m
IHRoaXMgY2hhbmdlLg0KPiA+ID4NCj4gPiA+IHMvc3Vic2VxdWVudCBwYXRjaC8vDQo+ID4NCj4g
PiBPaw0KPiA+DQo+ID4gPg0KPiA+ID4gWW91IHNob3VsZCByYXRoZXIgZXhwcmVzcyBob3cgRVVQ
REFURVNWTiB0cmlnZ2VyIHdpbGwgZGVwZW5kIG9uIHRoZQ0KPiA+ID4gc3RhdGUgb2Ygc2d4X25y
X3VzZWRfcGFnZXMgYW5kIHNneF9ucl9mcmVlX3BhZ2VzLg0KPiA+DQo+ID4gSG93IGFib3V0IHRo
aXMgZXhwbGFuYXRpb246DQo+ID4NCj4gPiAiQnkgY291bnRpbmcgdGhlICMgb2YgdXNlZCBwYWdl
cyBpbnN0ZWFkIG9mICNvZiBmcmVlIHBhZ2VzLCBpdCBhbGxvd3MgdGhlDQo+ID4gRVBDIHBhZ2Ug
YWxsb2NhdGlvbiBwYXRoIGV4ZWN1dGUgd2l0aG91dCBhIG5lZWQgdG8gdGFrZSB0aGUgbG9jayBp
biBhbGwNCj4gPiBidXQgYSBzaW5nbGUgY2FzZSB3aGVuIHRoZSBmaXJzdCBwYWdlIGlzIGJlaW5n
IGFsbG9jYXRlZCBpbiBFUEMuIFRoaXMgaXMNCj4gPiBhY2hpZXZlZCB2aWEgYSBmYXN0IGNoZWNr
IGluIGF0b21pY19sb25nX2luY19ub3RfemVyby4iDQo+IA0KPiBZZXAsIHdob2xlIGEgbG90IG1v
cmUgc2Vuc2UuDQo+IA0KPiA+DQo+ID4gQWxzbywgaWYgeW91IHRoaW5rIHRoYXQgaXQgaXMgaGFy
ZCB0byBpbnRlcnByZXQgdGhlIHBhdGNoIDIvNCB3aXRob3V0IDQvNA0KPiA+IEkgY2FuIGFsc28g
c3F1ZWV6ZSB0aGVtIHRvZ2V0aGVyIGFuZCB0aGVuIGl0IGJlY29tZXMgcmlnaHQgYXdheSBjbGVh
cg0KPiA+IHdoeSB0aGUgY2hhbmdlIHdhcyBkb25lLg0KPiA+DQo+ID4NCj4gPiA+DQo+ID4gPiA+
DQo+ID4gPiA+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlcyBpbnRlbmRlZC4NCj4gPiA+DQo+ID4gPiBO
b3QgcmVhbGx5IHVuZGVyc3RhbmRpbmcgaG93IEkgc2hvdWxkIGludGVycHJldCB0aGlzIHNlbnRl
bmNlLg0KPiA+DQo+ID4gSnVzdCBhcyB1c3VhbDogdGhpcyBwYXRjaCBpdHNlbGYgZG9lc27igJl0
IGJyaW5nIGFueSBmdW5jdGlvbmFsIGNoYW5nZXMNCj4gPiB0byB0aGUgd2F5IGFzIGN1cnJlbnQg
U0dYIGNvZGUgd29ya3MuIEkgb25seSBuZWVkZWQgdGhpcyBjaGFuZ2UgdG8NCj4gPiBpbXBsZW1l
bnQgcGF0Y2ggNC80IGluIG1vcmUgbG9ja2xlc3Mgd2F5Lg0KPiA+DQo+ID4gPg0KPiA+ID4gVGhl
IGNvbW1pdCBtZXNzYWdlIGRvZXMgbm90IG1lbnRpb24gc2d4X25yX3VzZWRfcGFnZXMsIGFuZCBu
ZWloZXIgaXQNCj4gPiA+IG1ha2VzIGEgY2FzZSB3aHkgaW1wbGVtZW50aW5nIHRoZSBmZWF0dXJl
IGJhc2VkIG9uIHNneF9ucl9mcmVlX3BhZ2VzDQo+IGlzDQo+ID4gPiBub3QgcG9zc2libGUuDQo+
ID4NCj4gPiBJdCBpcyBwb3NzaWJsZSB0byBpbXBsZW1lbnQgaXQsIGluIGZhY3QgSSBkaWQgZXhh
Y3RseSB0aGlzIGluIHRoZSBiZWdpbm5pbmcNCj4gaW5zdGVhZCwNCj4gPiBidXQgYXMgbWVudGlv
bmVkIHByZXZpb3VzbHkgdGhpcyB3b3VsZCBoYXZlIHJlc3VsdGVkIGluIHRha2luZyBhIGxvY2sg
Zm9yDQo+IGVhY2gNCj4gPiBjYXNlIHRoZSBwYWdlIGlzIGJlaW5nIGFsbG9jYXRlZC4NCj4gDQo+
IEhhdmUgeW91IGJlbmNobWFya2VkIHRoaXMgKG1lbW9yeSBiYXJyaWVyIHZzIHB1dHRpbmcgdGhl
IHdob2xlIHRoaW5nDQo+IGluc2lkZSBzcGlubG9jayk/DQo+IA0KPiBJIGhhdmUgZG91YnRzIHRo
YXQgdGhpcyB3b3VsZCBldmVuIHNob3cgaW4gbWFyZ2lucyBnaXZlbiBob3cgbXVjaCBlLmcuLA0K
PiBFTERVIHRha2VzLg0KDQpObywgSSBoYXZlbuKAmXQgYmVuY2htYXJrZWQgdGhpcy4gVGhlIHJl
YXNvbiB0byBjaG9vc2UgdGhpcyBhcHByb2FjaCAodnMuIHRoZQ0Kb3RoZXIgb25lIEkgc2hvd2Vk
IGluIGVtYWlsIG5vdykgd2FzIHB1cmVseSBsb2dpY2FsIC0gbGVzcyBsb2NrcyBhbmQgYmV0dGVy
IGNvZGUuDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
