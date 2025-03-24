Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ADC25E820;
	Mon, 24 Mar 2025 12:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742819205; cv=fail; b=m4NlnWZVcdr/GH/f463VuvSEDt1b3a5DpbbGkJXNtOrD8y4MvQwXLnIhS5aoM4WUPVgVJ201lc9IklAMlPyBQSO8Neb/Js4V9C8HrbcZrbspcCcopeTdEa3sAnunoEGMy8taGrrWhG4uVq3C3HrgCZyxdw5P/pZ6fZhiWHXTzbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742819205; c=relaxed/simple;
	bh=93Fhl1fST8sngostW7GUzBut/sLzRr4tf5aDRo0Ctmc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O4LKM8A/hZdV0PpBFPRdVqKh2VY+bq+b3ke/VXrv+hlzOP2RQP2g0V1zOE04XpLodBfHRcK/pMPoG38q36+Gy4bmaNBEVd/RewxnzWwcjQrkUeAzzOfQbIdwAKAXFA2HG8VHswbQzRg+XQaoD7ZkqpjHXtq+EhhDsPUB7owlj5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ATgJk4GV; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ATgJk4GV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742819203; x=1774355203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=93Fhl1fST8sngostW7GUzBut/sLzRr4tf5aDRo0Ctmc=;
  b=ATgJk4GVdUieewqO4lFLIX8f3mRA4pjZ12hOSd78WcQOas7Uwv5OmJnC
   k050wDOK+CYPYNANCxnQ/uaXX2uq4ZVtHTycJ0tfqXKLSZtcKkDjVMiVk
   zqXCKsN77gP9Qwn3HFar2BjwYXEVlyPHbtyCVF6kS7UgPGtG2Zji3FCDq
   B06e0q4oY0N6hHDNR53SjzhaCmN3FwDBgAI6LdTRmL0mnQM3zzp03vwOC
   hKfdABuCvm4GxwqH/kBg0x9f98akezp8Hv+m6rCcb7JGlNMqsK3hmxOQc
   r/phjHOe5JbUToOA6J+wVuUfP1xUlLaGJKT/+hzSx4AnTIIDTPQKC2e3I
   Q==;
X-CSE-ConnectionGUID: abV4IT9LTHCKP4GkRTDZNA==
X-CSE-MsgGUID: zV3/DDbLSWq+PmgKLstWfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11383"; a="31620741"
X-IronPort-AV: E=Sophos;i="6.14,272,1736841600"; 
   d="scan'208";a="31620741"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 05:26:42 -0700
X-CSE-ConnectionGUID: pww3ybCDRdiyHadIQCJofw==
X-CSE-MsgGUID: T2vVw+ogSqCXGJ3qnGHBgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,272,1736841600"; 
   d="scan'208";a="124195416"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 05:26:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Mar 2025 05:26:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 24 Mar 2025 05:26:41 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Mar 2025 05:26:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dzf+yBJJ1BxEzo2yvjHCfSbilQyogksZtmMBQYLmzztBHqIjl2RRwwyFtKw/FiIKeBKahg0yqKDFq4xymQvhH3f2Uk2jFarFXOGoUsz9MvJ+n40a90CAq6Ver21+9DIe07lf2M3Enw0oOkk1nA8R0dYg5X+qzI8W0Mh/P0NrkyE7c+EVW7ZA0WVkikj5UqvUSzh+H93hraMVMVDP0q7J5Jd6FvaSiqmc/R8ANmKOatdpZihvqxvXpYUW/yqxmU7GdjMDm6vthQ/vlGR3xMTdMCNrTZuR16TEY03OH+sY/oEiBbXJm90SekxQVI+atKNTloziJ8ebUipMFaSpVlFNsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93Fhl1fST8sngostW7GUzBut/sLzRr4tf5aDRo0Ctmc=;
 b=sf7hKUWfsh++akS73sj1ArkcNH8USrYG5Kt4HwfAvU8xX932FWZsfmfGb3+Z1plnVYCkidyMGj7V9Kc3KFZo3vhAqdSxLaUEsTv6nORLNs8jHeDD88lGw6TN+6stkMiW6rXLjF3+DlMDfZyE04Hn82ZO53cfi5LEMTdwDGJ+Rtl3fz5lKyzqJUqm8JaaJEqy+W84j8ZFbM6lem4eHNMC66Yoh6oKgljVQnZUj5Qtkf+cSsJF++26fxjuzmiWh3kXa0n/HYT4iSDLMas/FLi230dacarbw1lGaBfCaICayaXJtCBUM0KbjOxWyYllhuHE5li0+Zpbsu53aOlc5ZiWew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DM4PR11MB5229.namprd11.prod.outlook.com (2603:10b6:5:39f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.42; Mon, 24 Mar 2025 12:26:39 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 12:26:38 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>, "Zhang,
 Cathy" <cathy.zhang@intel.com>
Subject: RE: [PATCH 4/4] x86/sgx: Implement ENCLS[EUPDATESVN] and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH 4/4] x86/sgx: Implement ENCLS[EUPDATESVN] and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbml5zm6Mg6JqIu0KJnS8UZti+urN/vCmAgAJ9k8A=
Date: Mon, 24 Mar 2025 12:26:38 +0000
Message-ID: <DM8PR11MB575000AEB9CC3A318651AAABE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-5-elena.reshetova@intel.com>
 <Z983ZaTaWNqFUpYS@kernel.org>
In-Reply-To: <Z983ZaTaWNqFUpYS@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|DM4PR11MB5229:EE_
x-ms-office365-filtering-correlation-id: 790f8095-c7e6-4c66-8586-08dd6acf2049
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cnFqbDBqQWV1enlRQkFNYkJmSG0xb2FXcUl5WmNROXU5bTBTdUVzNENPSU9n?=
 =?utf-8?B?SSt4M0VaekpkeE1JL1JvWWdPbElyWUhaTEU5Sy9jeGtyQTg1THUzazE5TmpS?=
 =?utf-8?B?cDNmSlF5TVR6cVd3bER5Vzk3ZUdKTjNzdi81NTc2UEt1ODNrSlNlV1lRS1Ay?=
 =?utf-8?B?K09BR25mQU1naU00WkhJWitaeFpPYXF5eVFDT2pDZTFRYUlrRXlhd3BsaGRD?=
 =?utf-8?B?RkxZT0kyZHkrMGo4Z2xESzFQWWZTS1VpVFNMNlYzY2U1R1RIeHgrM3U4T2Iw?=
 =?utf-8?B?MFhFck1iRjdWSkliNUN2Nnp3VHVVRTcyQjFLQWdFNXQ4L1hINHNoNnFoSm5m?=
 =?utf-8?B?YTZId1grTjNpTERzcTZXSmNrVTFxazF2N1VrR1M3QzZ4V0U2aDRPeWg4cTIz?=
 =?utf-8?B?RGN4NnRZU3pYSGlQQXlLd1pNOW1MVWxZQUI2OThibWhGUUVlMHl6cFVjRExl?=
 =?utf-8?B?d2h1WG5EWEpGNzhhZnZweW1zNW15V00vY0hwR2xRVzUvUisra0FuM1BtYS9G?=
 =?utf-8?B?ZlB5TkpNa3dWNWgyR3NVallsbGFJOCtZWU1tQ3ZSb0JvT29HZFZNaHYrOC9Z?=
 =?utf-8?B?azBxRTBhbVJZNHRuWXRkQ1ZGTVU3MGpWVkFqTjNrcUN2NXBLSG44elZzYTdl?=
 =?utf-8?B?K1plUGNxUjkwVzlHMmZndlRyNDRLdXd5eGJiRFEvbURKQzZwd09iOW5QMUY2?=
 =?utf-8?B?cDlXTGZWMnFQajNRQ1NhUzNEMjlCbm5RUmdnOGZwVW9ISXlNQVVON1JOTUM3?=
 =?utf-8?B?d0RVOHFldldFdG9PeFhMNmRBSjFBdU9mKzFpREpYWFpBemM5SUNBVmJyUzNF?=
 =?utf-8?B?ZVVZYTZjTS9WMnFYTG9LN1hrc1ZEMzdVcmFwZUpkSktmZGsyKzNmdFdnM3Bp?=
 =?utf-8?B?VjIzeDQvYUdGbjFPbWhFc25yd2xJRzZLZ3U4L3ByTDJvMThKYUJEM2RhN1lC?=
 =?utf-8?B?MGxpckduc0h2NWZDREdOVTRyajhYb0ZndVRIWmJRV2gyUW01UGIvS0JEbis4?=
 =?utf-8?B?TGZ0QkJJQXVzQkF4S3RYbFN0MU1xR0dWTkYrdHdMOVZhNU8wMDN6NGFLR1Mv?=
 =?utf-8?B?eTE2MVdxK3pFR29xWXdXRW9KUGFmTFV4OU1ablRVVFFFbTNFQjZVTDlYY1da?=
 =?utf-8?B?aG9wZjh1ejl1SXRQVUhYdnN6WmhuWEdURGQ4R3B2U2U4WEJjckphQWJBOXht?=
 =?utf-8?B?Y252M3RBT25NYmd6OG1mdFZPQXJCQkpmWDU1dDBlT05Nb1VHNW1xbVFkUUNr?=
 =?utf-8?B?NURYRG9QSnROQXMxdGVRZEVNRTJPWHNVMDVPY1g5Q1h5M0JDYll4SXdkcEFQ?=
 =?utf-8?B?WlNmdXg0NHV1RFhIUStnK3BsTlZ6NU9wRGErTm9VL3FHT2MwdEg4cm15VWJV?=
 =?utf-8?B?ZGhnaHVXcHlkeElZdXZjMHlmQUhWUlE1Nm1JN25HekdTaHVzUHh5N2R0cjRD?=
 =?utf-8?B?a3lLM3FGZmZNVy80c1NqNGpLYUR4bVVBREhTRmtxVEhwT0FpekR0RWtEZFgy?=
 =?utf-8?B?eDBtREhob2xkUzRpMU83SUhRWVdFcGNGSE4zNUtUcWd5QmFLYmhaYURyenVx?=
 =?utf-8?B?b3p1OVVPblV3SGhFQUZRYzZrSjNVekJFQTIvQ21sOG1uTU1yL1Bkd09RMzVq?=
 =?utf-8?B?QXNySkEwaUFTRFg3dUxramJIdG5CWjBtdTJodXNqb3lUWHlHZUhtcFpsUjJv?=
 =?utf-8?B?YUJCdWZ2cE1mVFZIeFVwVERlUVdPZnNjRzc4QzFKbXo0YmxFMlB3SXhrVnVC?=
 =?utf-8?B?aEVHaUFLRFVmeE9YZlZ1UDlTVkQ0L3ZBQ3c5cGM0SDlQTkhLNzV5REZXTjRj?=
 =?utf-8?B?RHpzWWwrQ28rOFh3bG0xZnk5OGtMTDBCMjU4MHZTVk9UODhXZmZ0anAxKzVM?=
 =?utf-8?B?cERoRG5RYXJyWlpydXBEcmJNWUNDOGZtZmN0MlN1dHhmbHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkJNc25zbGswQ0l2R3pjRW9RSHNRY05LWFhQbXhRNXh5SjJnSUdjMWgvRnJ3?=
 =?utf-8?B?OXA4VkhtTThZaGJaMmRMV3NZcXY0VGhoaG16djgveHdKdTNuLzhLdTQxUG1W?=
 =?utf-8?B?L3MwYzNCSjdrRUVISWdpQU1wejFzYVA3T2FWRmhpYWMwZ0RuNG9yVDlDY0lD?=
 =?utf-8?B?OVJKR2tGM3RxTk8xK0k4NGNMWWM0WTZZcG9zeVcvT1B4emk1cTBsRWhZWnFT?=
 =?utf-8?B?b1piTmk3NlNWWXdhalU5VTZwekRTTTZha0ZLNWRlekIwSGJ6eXRYcHJOMi82?=
 =?utf-8?B?TURVbGRqMDE5aGlaUUhzNWNlbUdwbG8yRG9sNmxaSHZDK1JTOVV1TnY1cmNa?=
 =?utf-8?B?MXZNdUdWcis4YjZnaUtpZEtDKzdKQllHRi9vRTZZVFc4VGRiTlo3VnhUN2ly?=
 =?utf-8?B?RTBwbEk0RUYxMWxtK3NBSG55cXZVM21mZ1VNM3V3SXQ1MDVZRnJ0UCt1dUo5?=
 =?utf-8?B?eW5DTWc5cWdHVVZkY3lRbTlzU2VyVFhOZmN2cCtEdW9pK2YwVDgrZEc2VElZ?=
 =?utf-8?B?WmpBNmpqbXpoMEgwN214cTNDdTZYTGtHcURXa1dBaWlWRmFFL0VmK3JJQVln?=
 =?utf-8?B?WUkwZEhieHlFRnQ5OXRZV3pIQUF0ZDZ4V09EV29wY09nM2g1Y0YrZTA1MkN5?=
 =?utf-8?B?WXlWdUtQS2I3UmtrTllCcWhPRE4raTZkMHNFc3pFSVJ5TmJkMzJTM3RDOTRm?=
 =?utf-8?B?Q0NXd0YxNkFFYnljWDhuVm0rZVE0TnMrd0NHbG5lQUVkUHBEeU9yVnBqampY?=
 =?utf-8?B?bHJvWXRnODRhK1YvWVBSVXN2MU54d3JuOEFXTi81S2hRNGgvdElFeTV5ZWJB?=
 =?utf-8?B?VlpOcXdERHJhbnpNM2ZRNklYc1Zaa3o4S0t1Vmk1aXY1dWlySnNnOWxHU0VC?=
 =?utf-8?B?YzkvU2FnUHZBcGtTdnBabHdEeVBXWGs1Rm1nMkhNQmhIMWR1ZGw5cU03UzlF?=
 =?utf-8?B?RkJBZkZIYzV5Zi9rNjFQU2F1cGpBcVlQR25pcnZERytiY0VGd0hQcUxDV2hx?=
 =?utf-8?B?RnhvenEzNXFBZVFBY2RBT0NrS2tyOGdQZUpQcnNQS0I2eDNSaVQxZTlqWktj?=
 =?utf-8?B?RDg5UWtUaGl5UG5sUUY5QjlsdVFJN3lGbTBZcTdxTFU0Mmlvemc2cUhjbzJm?=
 =?utf-8?B?czNNR0tCQ2NPb3dLZGpuNXV6UXlYUTZWZHdWVmVkRWpNREdJNkV1MllhTDBi?=
 =?utf-8?B?MWNBakJOMmowb3dGRmkwL1ZtaFFpeWd6MEY2OTFKUHRHbFNNNnRiWit5aERu?=
 =?utf-8?B?VFd5UlpGWVQ0aU9sTTNGWmw2ZHpWTjZtMEM0YVpmWG1oZjBpdEsvMUVnYWpm?=
 =?utf-8?B?WFgwUG51Rzd5UmtBZVl1M0tzOE9NWXJZMkpCemEyRjdLQ0xkdlZaL0UvR3h2?=
 =?utf-8?B?UnZYY1o1UlhScDBXVm1RdVZIZElNMkZSekRMYXdOb1BEYXpMRitqSTdxalVn?=
 =?utf-8?B?RGtlK2I1eFFLMlFpZ0UwdDErUHRxcmFmcmNjeG40Q0pxTEtxTXkwenJadTlh?=
 =?utf-8?B?Wk9nbFhuelFFa3NCQU9Zd05LNGREaFdSU0lWNkozS1AvNldma3dScWdXVnZm?=
 =?utf-8?B?SFVXS2NXUng2MnY4YzFvRUhQRXlJTGZlYll2Qi9jcWlSSjFIalcvamt4WEJ0?=
 =?utf-8?B?L1JRdzBUQjVBQ0RlK0Voa3ovOEIzK0hQcXJYRzBYS21vU3ozZElqVENpRnR4?=
 =?utf-8?B?SjlQamtuZlN6QlBFemx4Y3lyMnNLZS9xRzhWV1IrVm9aVzZLNy9LV00rYU9G?=
 =?utf-8?B?SnhKOVM4VzRPMWpaT0d0aStRcVgzQ3FFTTR6OTVaemtPR04wUkYydDh0ek1X?=
 =?utf-8?B?UTVhOVNlOUwxK3pzRjA1M2tTV1hUN2lOdXhXNEZhbHprK3ZBMkJtQVZucUd6?=
 =?utf-8?B?NFVVSi9BUWZCMDFBa2I2U3NBOFRzdkZST0ZtaGVzUTZHb3hDWHFIK2N5QStk?=
 =?utf-8?B?UjNkRytNek5BWXJGUFErVlVkV1FHUTVZZE9sRTRNMGJSUFBmTms5VndzVmVF?=
 =?utf-8?B?R0Z4NkdRUkxId25oVUxNNjJJalYzRXRaQTIxcm9hNG0yZWVZQ2xRRVBxeEw2?=
 =?utf-8?B?RWgybDIveWhzdnFJanpRS1FHN0Vmb0N0cSsxblAwMTBsbytPU1VkZWlHcVJz?=
 =?utf-8?Q?iCoPi3MSh4tJNxEYHoifP0dx5?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 790f8095-c7e6-4c66-8586-08dd6acf2049
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2025 12:26:38.8882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X3w7WSv9wmvWE+x0HbmSpk6M81VZgyBOyPVDKGUX+3WKTgpVOUdzhyKkBaOX1z7tftB+vuDtkvC0eQWaB0qdtIL7rjMolYYBex6fWDrIj7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5229
X-OriginatorOrg: intel.com

DQo+IE9uIEZyaSwgTWFyIDIxLCAyMDI1IGF0IDAyOjM0OjQzUE0gKzAyMDAsIEVsZW5hIFJlc2hl
dG92YSB3cm90ZToNCj4gPiBTR1ggYXJjaGl0ZWN0dXJlIGludHJvZHVjZWQgIGEgbmV3IGluc3Ry
dWN0aW9uIGNhbGxlZCBFVVBEQVRFU1ZOIFsxXQ0KPiA+IHRvIEljZSBMYWtlLiBJdCBhbGxvd3Mg
dXBkYXRpbmcgc2VjdXJpdHkgU1ZOIHZlcnNpb24sIGdpdmVuIHRoYXQgRVBDDQo+ID4gaXMgY29t
cGxldGVseSBlbXB0eS4gVGhlIGxhdHRlciBpcyByZXF1aXJlZCBmb3Igc2VjdXJpdHkgcmVhc29u
cw0KPiA+IGluIG9yZGVyIHRvIHJlYXNvbiB0aGF0IGVuY2xhdmUgc2VjdXJpdHkgcG9zdHVyZSBp
cyBhcyBzZWN1cmUgYXMgdGhlDQo+ID4gc2VjdXJpdHkgU1ZOIHZlcnNpb24gb2YgdGhlIFRDQiB0
aGF0IGNyZWF0ZWQgaXQuDQo+ID4NCj4gPiBBZGRpdGlvbmFsbHkgaXQgaXMgaW1wb3J0YW50IHRv
IGVuc3VyZSB0aGF0IHdoaWxlIEVOQ0xTW0VVUERBVEVTVk5dDQo+ID4gcnVucywgbm8gY29uY3Vy
cmVudCBwYWdlIGNyZWF0aW9uIGhhcHBlbnMgaW4gRVBDLCBiZWNhdXNlIGl0IG1pZ2h0DQo+ID4g
cmVzdWx0IGluICNHUCBkZWxpdmVyZWQgdG8gdGhlIGNyZWF0b3IuIExlZ2FjeSBTVyBtaWdodCBu
b3QgYmUgcHJlcGFyZWQNCj4gPiB0byBoYW5kbGUgc3VjaCB1bmV4cGVjdGVkICNHUHMgYW5kIHRo
ZXJlZm9yZSB0aGlzIHBhdGNoIGludHJvZHVjZXMNCj4gPiBhIGxvY2tpbmcgbWVjaGFuaXNtIHRv
IGVuc3VyZSBubyBjb25jdXJyZW50IEVQQyBhbGxvY2F0aW9ucyBjYW4gaGFwcGVuLg0KPiA+DQo+
ID4gSXQgaXMgYWxzbyBlbnN1cmVkIHRoYXQgRU5DTFNbRVVQREFURVNWTl0gaXMgbm90IGNhbGxl
ZCB3aGVuIHJ1bm5pbmcNCj4gPiBpbiBhIFZNIHNpbmNlIGl0IGRvZXMgbm90IGhhdmUgYSBtZWFu
aW5nIGluIHRoaXMgY29udGV4dCAobWljcm9jb2RlDQo+ID4gdXBkYXRlcyBhcHBsaWNhdGlvbiBp
cyBsaW1pdGVkIHRvIHRoZSBob3N0IE9TKSBhbmQgd2lsbCBjcmVhdGUNCj4gPiB1bm5lY2Vzc2Fy
eSBsb2FkLg0KPiA+DQo+ID4gVGhlIGltcGxlbWVudGF0aW9uIG9mIEVOQ0xTW0VVUERBVEVTVk5d
IGlzIGJhc2VkIG9uIHByZXZpb3VzDQo+IHN1Ym1pc2lvbiBpbiBbMl0NCj4gPg0KPiA+IFsxXSBo
dHRwczovL2NkcmR2Mi5pbnRlbC5jb20vdjEvZGwvZ2V0Q29udGVudC82NDg2ODI/ZXhwbGljaXRW
ZXJzaW9uPXRydWUNCj4gDQo+IEkgZG9uJ3QgdGhpbmsgZm9yIEludGVsIG9wY29kZXMgYSBsaW5r
IGlzIG5lZWRlZC4gV2Uga25vdyB3aGVyZSB0byBsb29rDQo+IHRoZW0gdXAuDQoNCk9rLCBJIGNh
biBkcm9wIHRoaXMgcmVmZXJlbmNlLiBJdCBpcyBqdXN0IGEgd2hpdGVwYXBlciBleHBsYWluaW5n
IHRvIHJlYWRlcnMNCnRoZSBiYWNrZ3JvdW5kIGFuZCBvcGVyYXRpb24gb2YgRVVQREFURVNWTi4g
SXQgaXMgbm90IHBhcnQgb2Ygc3RhbmRhcmQNClNETSwgc28gSSB0aG91Z2h0IEkgd291bGQgcHV0
IGEgbGluay4gDQoNCg0KPiANCj4gPiBbMl0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIw
MjIwNTIwMTAzOTA0LjEyMTYtMS0NCj4gY2F0aHkuemhhbmdAaW50ZWwuY29tL1QvI21lZGI4OWU2
YTkxNjMzN2I0ZjllNjhjNzM2YTI5NWJhMGFlOTlhYzkwDQo+IA0KPiBMaW5rOg0KDQo/ICBOb3Qg
c3VyZSB3aGF0IHlvdSBtZWFuIGJ5IGl0LiANCg0KPiANCj4gPg0KPiA+IENvLWRldmVsb3BlZC1i
eTogQ2F0aHkgWmhhbmcgPGNhdGh5LnpoYW5nQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBDYXRoeSBaaGFuZyA8Y2F0aHkuemhhbmdAaW50ZWwuY29tPg0KPiA+IENvLWRldmVsb3BlZC1i
eTogRWxlbmEgUmVzaGV0b3ZhIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEVsZW5hIFJlc2hldG92YSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4NCj4g
PiAtLS0NCj4gPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vc2d4LmggICAgICB8IDMzICsrKysrKysr
Ky0tLS0tLS0tDQo+ID4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2VuY2xzLmggfCAgNiArKysN
Cj4gPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jICB8IDY1DQo+ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9zZ3gu
aCAgIHwgIDIgKw0KPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDkwIGluc2VydGlvbnMoKyksIDE2IGRl
bGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Nn
eC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vc2d4LmgNCj4gPiBpbmRleCA4YmEzOWJiZjRlOTEu
LjVjYWY1YzMxZWJjNiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zZ3gu
aA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NneC5oDQo+ID4gQEAgLTI2LDIzICsy
NiwyNiBAQA0KPiA+ICAjZGVmaW5lIFNHWF9DUFVJRF9FUENfU0VDVElPTgkweDENCj4gPiAgLyog
VGhlIGJpdG1hc2sgZm9yIHRoZSBFUEMgc2VjdGlvbiB0eXBlLiAqLw0KPiA+ICAjZGVmaW5lIFNH
WF9DUFVJRF9FUENfTUFTSwlHRU5NQVNLKDMsIDApDQo+ID4gKy8qIEVVUERBVEVTVk4gcHJlc2Vu
Y2UgaW5kaWNhdGlvbiAqLw0KPiA+ICsjZGVmaW5lIFNHWF9DUFVJRF9FVVBEQVRFU1ZOCUJJVCgx
MCkNCj4gPg0KPiA+ICBlbnVtIHNneF9lbmNsc19mdW5jdGlvbiB7DQo+ID4gLQlFQ1JFQVRFCT0g
MHgwMCwNCj4gPiAtCUVBREQJPSAweDAxLA0KPiA+IC0JRUlOSVQJPSAweDAyLA0KPiA+IC0JRVJF
TU9WRQk9IDB4MDMsDQo+ID4gLQlFREdCUkQJPSAweDA0LA0KPiA+IC0JRURHQldSCT0gMHgwNSwN
Cj4gPiAtCUVFWFRFTkQJPSAweDA2LA0KPiA+IC0JRUxEVQk9IDB4MDgsDQo+ID4gLQlFQkxPQ0sJ
PSAweDA5LA0KPiA+IC0JRVBBCT0gMHgwQSwNCj4gPiAtCUVXQgk9IDB4MEIsDQo+ID4gLQlFVFJB
Q0sJPSAweDBDLA0KPiA+IC0JRUFVRwk9IDB4MEQsDQo+ID4gLQlFTU9EUFIJPSAweDBFLA0KPiA+
IC0JRU1PRFQJPSAweDBGLA0KPiA+ICsJRUNSRUFURQkJPSAweDAwLA0KPiA+ICsJRUFERAkJPSAw
eDAxLA0KPiA+ICsJRUlOSVQJCT0gMHgwMiwNCj4gPiArCUVSRU1PVkUJCT0gMHgwMywNCj4gPiAr
CUVER0JSRAkJPSAweDA0LA0KPiA+ICsJRURHQldSCQk9IDB4MDUsDQo+ID4gKwlFRVhURU5ECQk9
IDB4MDYsDQo+ID4gKwlFTERVCQk9IDB4MDgsDQo+ID4gKwlFQkxPQ0sJCT0gMHgwOSwNCj4gPiAr
CUVQQQkJPSAweDBBLA0KPiA+ICsJRVdCCQk9IDB4MEIsDQo+ID4gKwlFVFJBQ0sJCT0gMHgwQywN
Cj4gPiArCUVBVUcJCT0gMHgwRCwNCj4gPiArCUVNT0RQUgkJPSAweDBFLA0KPiA+ICsJRU1PRFQJ
CT0gMHgwRiwNCj4gPiArCUVVUERBVEVTVk4JPSAweDE4LA0KPiA+ICB9Ow0KPiA+DQo+ID4gIC8q
Kg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNscy5oDQo+IGIv
YXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbHMuaA0KPiA+IGluZGV4IDk5MDA0YjAyZTJlZC4u
M2Q4M2M3NmRjOTFmIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2Vu
Y2xzLmgNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNscy5oDQo+ID4gQEAg
LTIzMyw0ICsyMzMsMTAgQEAgc3RhdGljIGlubGluZSBpbnQgX19lYXVnKHN0cnVjdCBzZ3hfcGFn
ZWluZm8gKnBnaW5mbywNCj4gdm9pZCAqYWRkcikNCj4gPiAgCXJldHVybiBfX2VuY2xzXzIoRUFV
RywgcGdpbmZvLCBhZGRyKTsNCj4gPiAgfQ0KPiA+DQo+ID4gKy8qIFVwZGF0ZSBDUFVTVk4gYXQg
cnVudGltZS4gKi8NCj4gPiArc3RhdGljIGlubGluZSBpbnQgX19ldXBkYXRlc3ZuKHZvaWQpDQo+
ID4gK3sNCj4gPiArCXJldHVybiBfX2VuY2xzX3JldF8xKEVVUERBVEVTVk4sICIiKTsNCj4gPiAr
fQ0KPiA+ICsNCj4gPiAgI2VuZGlmIC8qIF9YODZfRU5DTFNfSCAqLw0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gYi9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC9tYWluLmMNCj4gPiBpbmRleCBiNjFkM2JhZDA0NDYuLjY5ODkyMTIyOTA5NCAxMDA2NDQN
Cj4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gPiArKysgYi9hcmNo
L3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gPiBAQCAtMzIsNiArMzIsMTEgQEAgc3RhdGlj
IERFRklORV9YQVJSQVkoc2d4X2VwY19hZGRyZXNzX3NwYWNlKTsNCj4gPiAgc3RhdGljIExJU1Rf
SEVBRChzZ3hfYWN0aXZlX3BhZ2VfbGlzdCk7DQo+ID4gIHN0YXRpYyBERUZJTkVfU1BJTkxPQ0so
c2d4X3JlY2xhaW1lcl9sb2NrKTsNCj4gPg0KPiA+ICsvKiBUaGlzIGxvY2sgaXMgaGVsZCB0byBw
cmV2ZW50IG5ldyBFUEMgcGFnZXMgZnJvbSBiZWluZyBjcmVhdGVkDQo+ID4gKyAqIGR1cmluZyB0
aGUgZXhlY3V0aW9uIG9mIEVOQ0xTW0VVUERBVEVTVk5dLg0KPiA+ICsgKi8NCj4gPiArc3RhdGlj
IERFRklORV9TUElOTE9DSyhzZ3hfZXBjX2V1cGRhdGVzdm5fbG9jayk7DQo+ID4gKw0KPiA+ICBz
dGF0aWMgYXRvbWljX2xvbmdfdCBzZ3hfbnJfdXNlZF9wYWdlcyA9IEFUT01JQ19MT05HX0lOSVQo
MCk7DQo+ID4gIHN0YXRpYyB1bnNpZ25lZCBsb25nIHNneF9ucl90b3RhbF9wYWdlczsNCj4gPg0K
PiA+IEBAIC00NTcsNyArNDYyLDE3IEBAIHN0YXRpYyBzdHJ1Y3Qgc2d4X2VwY19wYWdlDQo+ICpf
X3NneF9hbGxvY19lcGNfcGFnZV9mcm9tX25vZGUoaW50IG5pZCkNCj4gPiAgCXBhZ2UtPmZsYWdz
ID0gMDsNCj4gPg0KPiA+ICAJc3Bpbl91bmxvY2soJm5vZGUtPmxvY2spOw0KPiA+IC0JYXRvbWlj
X2xvbmdfaW5jKCZzZ3hfbnJfdXNlZF9wYWdlcyk7DQo+ID4gKw0KPiA+ICsJaWYgKCFhdG9taWNf
bG9uZ19pbmNfbm90X3plcm8oJnNneF9ucl91c2VkX3BhZ2VzKSkgew0KPiA+ICsJCXNwaW5fbG9j
aygmc2d4X2VwY19ldXBkYXRlc3ZuX2xvY2spOw0KPiA+ICsJCS8qIE9ubHkgY2FsbCBzZ3hfdXBk
YXRlc3ZuKCkgb25jZSB0aGUgZmlyc3QgZW5jbGF2ZSdzDQo+ID4gKwkJICogcGFnZSBpcyBhbGxv
Y2F0ZWQgZnJvbSBFUEMNCj4gPiArCQkgKi8NCj4gPiArCQlpZiAoYXRvbWljX2xvbmdfcmVhZCgm
c2d4X25yX3VzZWRfcGFnZXMpID09IDApDQo+ID4gKwkJCXNneF91cGRhdGVzdm4oKTsNCj4gPiAr
CQlhdG9taWNfbG9uZ19pbmMoJnNneF9ucl91c2VkX3BhZ2VzKTsNCj4gPiArCQlzcGluX3VubG9j
aygmc2d4X2VwY19ldXBkYXRlc3ZuX2xvY2spOw0KPiA+ICsJfQ0KPiA+DQo+ID4gIAlyZXR1cm4g
cGFnZTsNCj4gPiAgfQ0KPiA+IEBAIC05NzAsMyArOTg1LDUxIEBAIHN0YXRpYyBpbnQgX19pbml0
IHNneF9pbml0KHZvaWQpDQo+ID4gIH0NCj4gPg0KPiA+ICBkZXZpY2VfaW5pdGNhbGwoc2d4X2lu
aXQpOw0KPiA+ICsNCj4gPiArLyoqDQo+ID4gKyAqIHNneF91cGRhdGVzdm4oKSAtIElzc3VlIEVO
Q0xTW0VVUERBVEVTVk5dDQo+ID4gKyAqIElmIEVQQyBpcyByZWFkeSwgdGhpcyBpbnN0cnVjdGlv
biB3aWxsIHVwZGF0ZSBDUFVTVk4gdG8gdGhlIGN1cnJlbnRseQ0KPiA+ICsgKiBsb2FkZWQgbWlj
cm9jb2RlIHVwZGF0ZSBTVk4gYW5kIGdlbmVyYXRlIG5ldyBjcnlwdG9ncmFwaGljIGFzc2V0cy4N
Cj4gPiArICovDQo+ID4gK3ZvaWQgc2d4X3VwZGF0ZXN2bih2b2lkKQ0KPiA+ICt7DQo+ID4gKwlp
bnQgcmV0Ow0KPiA+ICsJaW50IHJldHJ5ID0gMTA7DQo+IA0KPiBSZXZlcnNlIGRlY2xhcmF0aW9u
IG9yZGVyLg0KDQpTdXJlLCB3aWxsIGZpeC4gDQoNCj4gDQo+ID4gKw0KPiA+ICsJbG9ja2RlcF9h
c3NlcnRfaGVsZCgmc2d4X2VwY19ldXBkYXRlc3ZuX2xvY2spOw0KPiA+ICsNCj4gPiArCS8qIERv
IG5vdCBleGVjdXRlIEVVUERBVEVTVk4gaWYgaW5zdHJ1Y3Rpb24gaXMgdW5hdmFsaWJsZSBvciBy
dW5uaW5nDQo+IGluIGEgVk0gKi8NCj4gPiArCWlmICghKGNwdWlkX2VheChTR1hfQ1BVSUQpICYg
U0dYX0NQVUlEX0VVUERBVEVTVk4pIHx8DQo+ID4gKwkJICAgIGJvb3RfY3B1X2hhcyhYODZfRkVB
VFVSRV9IWVBFUlZJU09SKSkNCj4gPiArCQlyZXR1cm47DQo+IA0KPiANCj4gCWlmICghKGNwdWlk
X2VheChTR1hfQ1BVSUQpICYgU0dYX0NQVUlEX0VVUERBVEVTVk4pKQ0KPiAJCXJldHVybjsNCj4g
DQo+IAkvKiAuLi4gKi8NCj4gCWlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfSFlQRVJWSVNP
UikpDQo+IAkJcmV0dXJuOw0KPiANCj4gVGhlIGZpcnN0IGNoZWNrIHJlYWxseSBkb2VzIG5vdCBu
ZWVkIGEgY29tbWVudC4gVGhlIHNlY29uZCB3b3VsZCBiZW5lZml0DQo+IGZyb20gZXhwbGFpbmlu
ZyB3aHkgYmFpbCBvdXQgaW5zaWRlIGEgVk0uDQoNClN1cmUsIEkgY2FuIGNoYW5nZS4gVGhlIHJl
YXNvbiB3aHkgd2UgZG9udCB3YW50IHRoZSBleGVjdXRpb24gaW4gYSBWTSBpcyBleHBsYWluZWQN
CmluIHRoZSBjb21taXQgbWVzc2FnZSwgSSBjYW4gZHVwbGljYXRlIGl0IGluIHRoZSBjb2RlIGNv
bW1lbnQgYWxzby4gDQoNCg0KPiANCj4gDQo+IA0KPiANCj4gDQo+ID4gKw0KPiA+ICsJZG8gew0K
PiA+ICsJCXJldCA9IF9fZXVwZGF0ZXN2bigpOw0KPiA+ICsJCWlmIChyZXQgIT0gU0dYX0lOU1VG
RklDSUVOVF9FTlRST1BZKQ0KPiA+ICsJCQlicmVhazsNCj4gPiArDQo+ID4gKwl9IHdoaWxlICgt
LXJldHJ5KTsNCj4gPiArDQo+ID4gKwlzd2l0Y2ggKHJldCkgew0KPiA+ICsJY2FzZSAwOg0KPiA+
ICsJCXByX2RlYnVnKCJFVVBEQVRFU1ZOIHdhcyBzdWNjZXNzZnVsIVxuIik7DQo+ID4gKwkJYnJl
YWs7DQo+ID4gKwljYXNlIFNHWF9OT19VUERBVEU6DQo+ID4gKwkJcHJfZGVidWcoIkVVUERBVEVT
Vk4gd2FzIHN1Y2Nlc3NmdWwsIGJ1dCBDUFVTVk4gd2FzIG5vdA0KPiB1cGRhdGVkLCAiDQo+ID4g
KwkJCSJiZWNhdXNlIGN1cnJlbnQgU1ZOIHdhcyBub3QgbmV3ZXIgdGhhbg0KPiBDUFVTVk4uXG4i
KTsNCj4gPiArCQlicmVhazsNCj4gPiArCWNhc2UgU0dYX0VQQ19OT1RfUkVBRFk6DQo+ID4gKwkJ
cHJfZGVidWcoIkVQQyBpcyBub3QgcmVhZHkgZm9yIFNWTiB1cGRhdGUuIik7DQo+ID4gKwkJYnJl
YWs7DQo+ID4gKwljYXNlIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWToNCj4gPiArCQlwcl9kZWJ1
ZygiQ1BVU1ZOIHVwZGF0ZSBpcyBmYWlsZWQgZHVlIHRvIEluc3VmZmljaWVudA0KPiBlbnRyb3B5
IGluIFJORywgIg0KPiA+ICsJCQkicGxlYXNlIHRyeSBpdCBsYXRlci5cbiIpOw0KPiA+ICsJCWJy
ZWFrOw0KPiA+ICsJY2FzZSBTR1hfRVBDX1BBR0VfQ09ORkxJQ1Q6DQo+ID4gKwkJcHJfZGVidWco
IkNQVVNWTiB1cGRhdGUgaXMgZmFpbGVkIGR1ZSB0byBjb25jdXJyZW5jeQ0KPiB2aW9sYXRpb24s
IHBsZWFzZSAiDQo+ID4gKwkJCSJzdG9wIHJ1bm5pbmcgYW55IG90aGVyIEVOQ0xTIGxlYWYgYW5k
IHRyeSBpdA0KPiBsYXRlci5cbiIpOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJZGVmYXVsdDoNCj4g
PiArCQlicmVhazsNCj4gDQo+IFJlbW92ZSBwcl9kZWJ1ZygpIHN0YXRlbWVudHMuDQoNClRoaXMg
SSBhbSBub3Qgc3VyZSBpdCBpcyBnb29kIGlkZWEuIEkgdGhpbmsgaXQgd291bGQgYmUgdXNlZnVs
IGZvciBzeXN0ZW0NCmFkbWlucyB0byBoYXZlIGEgd2F5IHRvIHNlZSB0aGF0IHVwZGF0ZSBlaXRo
ZXIgaGFwcGVuZWQgb3Igbm90Lg0KSXQgaXMgdHJ1ZSB0aGF0IHlvdSBjYW4gZmluZCB0aGlzIG91
dCBieSByZXF1ZXN0aW5nIGEgbmV3IFNHWCBhdHRlc3RhdGlvbg0KcXVvdGUgKGFuZCBzZWUgaWYg
bmV3ZXIgU1ZOIGlzIHVzZWQpLCBidXQgaXQgaXMgbm90IHRoZSBmYXN0ZXIgd2F5LiANCg0KDQoN
Cj4gDQo+ID4gKwl9DQo+ID4gK30NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2Nw
dS9zZ3gvc2d4LmggYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9zZ3guaA0KPiA+IGluZGV4IGQy
ZGFkMjEyNTlhOC4uOTJjOWUyMjZmMWI1IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2tlcm5l
bC9jcHUvc2d4L3NneC5oDQo+ID4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvc2d4LmgN
Cj4gPiBAQCAtMTA0LDQgKzEwNCw2IEBAIHN0YXRpYyBpbmxpbmUgaW50IF9faW5pdCBzZ3hfdmVw
Y19pbml0KHZvaWQpDQo+ID4NCj4gPiAgdm9pZCBzZ3hfdXBkYXRlX2xlcHVia2V5aGFzaCh1NjQg
KmxlcHVia2V5aGFzaCk7DQo+ID4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgd2UgbmVlZCBhIG5ld2xp
bmUgaW4tYmV0d2Vlbi4NCg0KU3VyZSwgd2lsbCBmaXguDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2gg
Zm9yIHlvdXIgcHJvbXB0IHJldmlldyBKYXJra28hDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
