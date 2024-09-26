Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D4D4C9F
	for <linux-sgx@vger.kernel.org>; Thu, 26 Sep 2024 00:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727312053; cv=fail; b=FcROvQi2Gn5OTpYzRKKuYBUGfRN72fvAIfE8NlKzG2LAXDtW+1Tk9/K2ETS/pK+d44oFAVoi+ddoBmpwybA1XQxrWUAGPp76wfGc3uhhkNARpZeTSnONsoQp7nJQGs4jMCZIbkmCmlYnNcWIr5wyC8XfRsAgiCkXuZFxC9K/cs4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727312053; c=relaxed/simple;
	bh=eJZwQE07dTavLjliMHMbK9zgTh+/JqSj03Zsmz2xzFA=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BSvZckp8TmU52CNsZeZ33N6mIRuvu3jIvGcjZSCwdbN6iP3IT8Pl2ajgWtRF2i2ti8Kt3mHw/O5CSWcMbz3NB1jKTo3nTMwoaGeAIl3RAdT0NwLQBZbbwnBK+RHVP9Esqf6OHFRGsjdtQWuUCIaEl2PT80HjTyku4KwMX04Q+wU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LL7PEjRz; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LL7PEjRz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727312052; x=1758848052;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=eJZwQE07dTavLjliMHMbK9zgTh+/JqSj03Zsmz2xzFA=;
  b=LL7PEjRzA53mZt/GoC+Mjx9+CWwat8JTTULxXD/maWiqH/MkypqlZ9mZ
   V2LV9eoI3XXPDZoDVjzTUZuk3GiHgTFQzZtZFUzly7Q2ADK/KpUZqMEMz
   Fz8St37iQswl6J/DRXKzo/DMe+aOH+gwgLbTsl3JHo1gYbojyoyHcvgj9
   kxMpZIcWb0ZDdvaW0XqNuOUV1+vhmNK1ouNc6/Hl0dGecxQGw61L9D50Y
   DWZxD/Q5LtDqDo41Y4dQs56YVhFvmbrb7dnubeLTuqVeE/yb6QfP+hvdQ
   2uuooOKLbrtKjtcjaB3XLv2xLqZHBRZKRoGtGvEOE1xL/dm02Tx5M91by
   w==;
X-CSE-ConnectionGUID: tgVPZDmtSWishVSVu8CJMg==
X-CSE-MsgGUID: X9yjXlCqQtOwbYVsCITj3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11206"; a="26567860"
X-IronPort-AV: E=Sophos;i="6.10,258,1719903600"; 
   d="scan'208";a="26567860"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2024 17:54:07 -0700
X-CSE-ConnectionGUID: axDFilekS/OBwXM9Bko6tg==
X-CSE-MsgGUID: XVI7ImDwSV+hA/2pwZL1Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,258,1719903600"; 
   d="scan'208";a="76042010"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2024 17:53:59 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 17:53:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 17:53:58 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 17:53:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 25 Sep 2024 17:53:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 25 Sep 2024 17:53:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fKAhABPhaGwyQSG0ywAr6pGAsXHx4ZM1SHAKr8tfLOw/DSRsSjWOMw0ncojz6QCEi3P7+Oq2KlYITT+iudOYqvmJbE+5e885sfTKjGjQWrD/14dLPsFrN1g3rQRq1MBrGuvyR61LgxMTR7ipIsBWaXmSrpi0CG4rWuh4WhGKSuUPj0miZGnwBCHOkAuFNdhMRLa6ukmzQ54/zzOhiVlMY09iz7QGdXOx4vbCnb36ZQU9NWqgc5ZLtdjV1/m4atc6e3yeHKUApkxdJjFSL1K76kRjLoWX8cZbpB4g1v7wkSJfm/VkUqEQFY8ZBngZjfarNSXbxj3xqLXCKwUb2LPUEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJ9p0d7xxUUrbSzIqIXPPGASoS9AZgwvh29EGBNq3zI=;
 b=acluBK/o0Q0bXN881DehzynABD/HkYcm6NKa7hfljW49Q2kWtmP1Clr0rKEjZoYCOHaj/A5IEl0KtsW/yaMBnRrRJeRBN2at5Tq7P3sx7rZbT+3KhOuIK2VKgznudqfipi6ozEvcVzv6CIPRnSG7I9MKQFAiIHE6L0Eq9mgx2mKG0t2n7/4DB3KwBIBh8vr5GN5VLpo9ogpidwDsaAZ2L+aUUw7QckkkBWKjjotT6Ln/HWcXO+hU6TjWQdn92MR3xpBnABj14CPh/s57suRL6UFTNoZ8CZy4RVIkUOmP5I1LzvCWz1Vpj2+dQCFtvaYa9WRVt5yG4jLwALXmzqAn8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7588.namprd11.prod.outlook.com (2603:10b6:510:28b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.28; Thu, 26 Sep
 2024 00:53:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 00:53:50 +0000
Message-ID: <f25ad4ab-9843-411f-befb-d7d20ca99bc9@intel.com>
Date: Thu, 26 Sep 2024 12:53:45 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: VMA merging updateds?
To: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>, Jarkko Sakkinen
	<jarkko@kernel.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi> <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
 <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
 <D4FSKQJ45J56.38A19ZT8CDTR0@iki.fi> <D4FSOFDIBTSU.395W5ZC73BU4N@iki.fi>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <D4FSOFDIBTSU.395W5ZC73BU4N@iki.fi>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::30) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7588:EE_
X-MS-Office365-Filtering-Correlation-Id: def7d971-202d-42d1-6120-08dcddc5af3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZDJTT3kvL3Q0ZXgzalR6U0oyTzBTeEZyUGZWczNoU05CczFnL0F6OFF5UC9J?=
 =?utf-8?B?a3hqRjV3alVxdHN2QWdwKzdEMVBKcWVOalc3ZEJqZ0lkcHhzN3ZzaDVsWmtE?=
 =?utf-8?B?OE0yOGQvZExxa2tabW4xY1NEcWFCY252WHYvemVQMVA4cloxb0k4UUdCc1lk?=
 =?utf-8?B?V1Ard0FVclF0cnpCKy9HbCtmZVVnOGhGSDRUdEwzUzhWWFJiZFlEZFluQUV5?=
 =?utf-8?B?T21JeThhYUdZUmtZVW82bC9kNnM5SlNzTkNqdDJzWkx2L3VtVTZmOU9xMjcr?=
 =?utf-8?B?eC9Xck1ja2JWVjFRNStOK0dwdEVUZmN1Zkt1WXFaWC93RjR3K3RZdzREaW1r?=
 =?utf-8?B?OVNOWUNLTzVQaHRtVFNSL0FWSDNSNmZGekU0TFRIek9ZM1Z0NkM1L1hkUzRY?=
 =?utf-8?B?bkU2TGY1dVpub0xKcjB0RE5Ic1hhVENjYWJsTjlFTEY4WDVkYXRaMC9OUmh6?=
 =?utf-8?B?RVJsVUp0ZW85dkd1WlVBM1JBRDdNQUtlRDZoSHJ0a2NhRUpFOGpHenRkMUpZ?=
 =?utf-8?B?eVVRc3M2SHRVOUNUSWxLdG9HcVc3NDUyNWdKdXR6aFYwYmZtODlCaW1Yczhx?=
 =?utf-8?B?UTR3RmJBOG9hRDZOclVzcTVybmhqSVg0VWR3cEd1OGpoRldVbmtCMThUbnNC?=
 =?utf-8?B?bVFnOVcvUHQ3OVNlY2xaKzl6clZjT3A3bHVUaFozY0wwZHh4VUFRK3RTYkdN?=
 =?utf-8?B?NDlnSnA0czI3VW5zTitROS9CQnk2c09SM3VWYTJKdXdEd3pSSlZsYU80UmdU?=
 =?utf-8?B?TDlZZzVXV1J5TU1IZVpML2lWTDlzdGRsazlVUXowZkxia0c1YWFQWlVIdy92?=
 =?utf-8?B?UUhFdUhZWEUzZWJicGV3R3ZWUk1ua0MzZjhRb0t4ZXpuMkEzTHM2LzB0V3pR?=
 =?utf-8?B?WWFuNytVZVo3eTgxQkljN2d4S29WYXNmZHQwQ0R3Y01DQzc0QUJJcGZta1A5?=
 =?utf-8?B?bUt3dkJJc29oSGpJd2VUcWptYm1FczhEMzAxalB5T1kwcEMvYjJNV2o2dCs3?=
 =?utf-8?B?TE9nR0VuSUsySWs4d2NFeTkwdWRuaVlXRUtENEZ5RnJXUkwybFprb1ptVjA0?=
 =?utf-8?B?c1dCQ2p0bFJIZS9ZNm9UNkFZbjJ0TVF5WGZ0M0c0ZHdPWXhIR0MyN28rOUd4?=
 =?utf-8?B?V3RyY0xlQTM0SzhWdjlJdE8vQlhoNG5ua005SzI0SFdQRG9najJsOTBwUjJZ?=
 =?utf-8?B?cFdGN2tzWXZuV09kTEI4Z044bHdWaFR3YmxPci9yRHB0VW8zbTkrakdIVDVm?=
 =?utf-8?B?WFgxdlNGaG02ZnhnMVNsZG0rWWIwUjJNOWtpcE5GYlhLWnMvQ1k2bkF4ZnBk?=
 =?utf-8?B?c3lMbWhIN2RwYW13OWhBYzdYTmJhMW93OFJQVDFGMnVBTjVVY2pPbERhaUpa?=
 =?utf-8?B?Mjh5Y3lzVmJFKytmM2Q0NER2amFxUXpnb0JtK0dPbW9aOFhuZzMrOVRsWndy?=
 =?utf-8?B?WHFyS0t6V3FYRmNpMlh2eUFIQ3F3Tk5pMllGNCtXc1hWb3cvSU9VbUhXaDRm?=
 =?utf-8?B?cmVJV2ZxWER0akhyWkNjWmpXblVMVE1qa20rWnRrZGNwUE1NczA3dXROVVV5?=
 =?utf-8?B?WHBHL0dpTk1mdjIxTVJ4LzdpMTZWVTRxM3k2VUwzWFcxNmpKSW1KSXVRTDBY?=
 =?utf-8?B?VGxLNVZFTGMzazNPWThlUUpMcm41L2tGNk9kY2lvUE4zK25xYU91bGdySGhK?=
 =?utf-8?B?QTM1cHIzS2ZjakRkYUgxZHh2YkpKam8vaDZUUkVxRWJzZEFSZy9mWnZSRlJR?=
 =?utf-8?B?Z2REbnd1VVNjdWVxNWtjVHV3SENlUFZXejJDd0JnNVEvS2wyWk52UnFxc3pN?=
 =?utf-8?Q?tnUsy5xTLTabq8QFMSyZuele9R2PqsQRkw/Ww=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlMrN1orbjFoVWE4Y085M281RzROem80aGNvUGdjWVFSTTFpc2ZWZGZTWnpo?=
 =?utf-8?B?azhDZ25lQ3VSVzVpRkZmMjEzV1BPWUdBTmUzRzB2WlRHRUQ5aHVZWndVdmhK?=
 =?utf-8?B?bkdCOS9OZklTVzRJNktueW00ZmU1SG5aK3BRRWpNazUrb3RGZXp3MEtNYjBP?=
 =?utf-8?B?ZGs1VDZwRExyRkxCN0dSS3YwVVdEZnZzTWJUVWFhS3VEblV2Wm1Za0NlZzJ6?=
 =?utf-8?B?cEQyWnNCdGRPck9XUVc4S0xHNVBaS05NOStsVkhYcEpYN0E4dXNONEZaOFlj?=
 =?utf-8?B?UU4zZVJSUGhpdUUyQ0U5dkhZUXVrR04zclM4bkcrMUltZXJ0NnZ6NUJ6YXZt?=
 =?utf-8?B?UWJzRlBqRm05V1U1RFl6Q1V0VkJCSWd0U3lHVFh1eHFidEJzWjVFU2d0MEk3?=
 =?utf-8?B?Z3V3WGg5eFNJbXY0VloyNmpYV0dYQ252d3I4N24wSU5OK09QQ2plbWQvQXJ2?=
 =?utf-8?B?UjZnTTdqSkptdys5NlFsdjFobWhGSUxBTkplaHUxaDVzUUcxNzZldk90R0xy?=
 =?utf-8?B?ZmZqQ2JXNjRPSk11MkFUdXJlSVUxK2tNbGtsaHNlcjdBaHVpNnVoREN4RTNI?=
 =?utf-8?B?MlZrd051VnBLU0E2UXdJaXdiYlplcUFrcHg0ZmFWakJuMEdxbmdGNE5hK254?=
 =?utf-8?B?VUphQ1hQUnFNVkFxR3UyQVdlTUJjOFVHNzlUYVBIdDhnSXVvaEduUUYzQi9W?=
 =?utf-8?B?ZmVRMmM2NlNWQlpRNHh6eTBCWWQvTUduL2ZISXl6dXByR0cvQWVJM3BPT3lw?=
 =?utf-8?B?K3FDeXo3ckd6OGZSbUNFTXg2RkEzTmRpMUFsYS9pRmFWUnBwK0lWeG54aGcr?=
 =?utf-8?B?YTZuVlhjNHdFUGxJYW9ROEEzK2FidSs5K1dLODZQSXlnVk1NK3owUTdNd0VD?=
 =?utf-8?B?UXFPNHpLUWdEUU15QWhXTlEwMURNUWJkMHhDaG04ZzBCdy93N2kxODFqcm1n?=
 =?utf-8?B?TDdocnU0YjNnT0lZcEQ0eG13c1lYSWxEempXU2FXcFkxWUI5cHNEOXFaUEZx?=
 =?utf-8?B?K1FXYzM3Y0trZ1J2ZHcxMCtodk1OSWJWU1FnUUhzMWRjZ2pCWW9BTTN4QnEw?=
 =?utf-8?B?UWpGOGhiMmlPeFpxQkQxekQ0Si82TCsyZGlKUUppbDNBZTFtNnoybVpYTkdY?=
 =?utf-8?B?YnJXQlFxRktTYjRQQXRnVnp0bzdyUFUrTURtdCtEaWdnNUJSakhXMXBVL2oy?=
 =?utf-8?B?N2paQVRxSnE3anhiT0x2ZjZnOWxWV2NyWDAxdGI4M2FLRERYeG4xZC8rRkZJ?=
 =?utf-8?B?T2pHZ0hzVVpYb1BpVWhQaEx3S2R1eC9iWlJvSDBBNHJtZkRoWnhHTzhpTTVL?=
 =?utf-8?B?ait1NDdoQUFUTlpocU5lMGZUT1EvYXlJbjN5QVA4OFl4bFp1MkNwVDV0L1NB?=
 =?utf-8?B?UmtMbUxlR1dnYmFTZGV2cjVZWll3OUlLNjBSbVNqSU4wSUF5SFM2T2FzT3JS?=
 =?utf-8?B?NWlqT1p3YjZhMW9zeWI4NnRPc1NZSEhIcXpESzBPeW9ob0lDaHg0aVVaNGlN?=
 =?utf-8?B?a2V0ZmFMQm4wdklYMFdhWFpSa2ZKT3Q0WHJkbVNpc0M4cU11WENzajZ0dXFE?=
 =?utf-8?B?NHpoRHo4dlNVWTFMWlpvV2FPdEIzQTRUV3o2aUpqbDV3N1M2SXR3c3IveWhP?=
 =?utf-8?B?bHNOT2twdjNYamZBU0VXcWNNMC9xYzdmUjZsWkMwTXRNK3NqaGdQb3B1bE1y?=
 =?utf-8?B?MEJCOTFOS1BtWm5KTGEvMkNPYjV6U1NGOG9ibVJ3WkhveEdMNC9WVDlrM3VG?=
 =?utf-8?B?VSsxakNBeXhXOWJ3SG5wYVllREJVRXRhcDdjbmdaT3FwcmNsNC8yMDRVRzZB?=
 =?utf-8?B?Q1ZsaEpxTjArM09BaXFPTXNlTkZOemdNM3U0eThhTktwRWgwQVdzM3ZpVGRK?=
 =?utf-8?B?UHA2OVBrMjlkNDZhUjRkdTIxdFYwWS9ueUFOMHQwM0hucStldjBPRDA1VVFp?=
 =?utf-8?B?Y0NWUE9TcjVJZWtUWE9JNUN4WUU2UDBmL0E2T2l1Z2pvY2pscTFtbWNoTHFj?=
 =?utf-8?B?RGhDVDFtUTIydlZNb0UxVnFya2tiRklMTE1VTmpISnYwNG41TnlZZGhSTlpF?=
 =?utf-8?B?UU9Zc3oxZjRXRnVLN3Yvam4yekF2ZHFiQ2ZyaGdqNmN6M2JiTzgvb2pzZmRp?=
 =?utf-8?Q?BhWwO2g9r/KIjNhg/Ir3OEktg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: def7d971-202d-42d1-6120-08dcddc5af3e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 00:53:49.9694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hwo0ip2IwLggA0WvH8kuaNb3/2/ca1C21JTjLkwpRppd6355se9sjbqUHOc1jyW59O8tStjGcQLOaCel73bqmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7588
X-OriginatorOrg: intel.com


>>>>>>> I started to look into this old issue with mm subsystem and SGX, i.e.
>>>>>>> can we make SGX VMA's to merge together?
>>>>>>>
>>>>>>> This demonstrates the problem pretty well:
>>>>>>>
>>>>>>> https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org/
>>>>>>>
>>>>>>> It was result of brk() syscall being applied a few times.
>>>>>
>>>>> Briging some context here. This can be fixed in the run-time by book
>>>>> keeping the ranges and doing unmapping/mapping. I guess this goes
>>>>> beyond what mm should support?
>>>>>
>>>>> I thought to plain check this as it has been two years since my last
>>>>> query on topic (if we could improve either the driver or mm somehow).
>>>>
>>>> In the past I've substituted kernel's mm merge code with user space
>>>> replacement:
>>>>
>>>> https://github.com/enarx/mmledger/blob/main/src/lib.rs
>>>>
>>>> It's essentially a reimplementation of al stuff that goes into
>>>> mm/mmap.c's vma_merge(). I cannot recall anymore whether merges
>>>> which map over existing ranges were working correctly, i.e. was
>>>> the issue only concerning adjacent VMA's.
>>>>
>>>> What I'm looking here is that can we make some cosntraints that
>>>> if satisfied by the pfnmap code, it could leverage the code from
>>>> vma_merge(). Perhaps by making explicit call to vma_merge()?
>>>> I get that implicit use moves too much responsibility to the mm
>>>> subsystem.
>>>>
>>>
>>> Hi Jarkko,
>>>
>>> Just want to understand more on the background:
>>>
>>> Are you seeing any real problem due to needing a lot of mmap()s to the
>>> same enclave, or it is just a problem that doesn't look nice and you
>>> want to resolve?
>>>
>>> I mean, this problem doesn't seem to be SGX-specific but a common one
>>> for VMAs with VM_PFNMAP (any bit in VM_SPECIAL), e.g., from random
>>> device drivers with mmap() support.  We will need a good justification
>>> if we want to make any core-mm change, if any, for this.
>>
>> It requires essentially replicating core mm in user space.
>>
>> It's a manageable problem but feels silly since logic in merging
>> is mostly 1:1. It's not a problem for me personally as I'm not
>> making any money from SGX (more so to Intel).
> 
> I.e. in the case when you want do a syscall shim. You fix it up by
> maintaining reflected version of the VMA database in the user space
> and remapping everything based on that for every possible mm-call.
> 
> I've implemented such feature in the past for Enarx so it is entirely
> possible.
> 

Just want to understand the problem/use case better:

I _think_ I got what the "syscall shim" is.  But can you elaborate why 
is this "syscall shim" related to the "kernel unable to merge contiguous 
VMAs for the same enclave"?  Assuming the kernel can actually merge 
enclave VMAs, how does it help on the "syscall shim"?



