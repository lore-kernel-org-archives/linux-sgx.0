Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A471D7984;
	Mon, 19 May 2025 22:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747694768; cv=fail; b=JScWasYAoHWsScRoCJ3tvAfoe7+ihGg1KEUW+PPbhl0K/s571c7YNwpehAd0jvYGB08KVilb6xvSzv4ojiIf/fuX+PCgBP8cu++LwRk3ZorK9dHuYdnWKUwgB4iifsQ0XFLYEEG2Z7JJsdHxRl38cQWUYWHeCWS5usBbJOtiKtk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747694768; c=relaxed/simple;
	bh=vf6ywxFyaP0c2Kw4Oxr3pXpegLowYqx1+AxCYlrJ35U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HTRf5IFSXXvIu8hkLQ2sEE6u8kFg7Oruu9YI6mWFsYQduqXoTZBhpVBcohrJ6HMRWbAt5fX7YvQBpjM7ZorVbbswYPuohzwTEJ4wLjBg74a+Cm4r80YEKUYR/xmT6+FFDJBi3bu/YKR3VvHKekUUefFNV7gwIyeiDOZi1CFu8Bo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y2WnjUDu; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y2WnjUDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747694767; x=1779230767;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vf6ywxFyaP0c2Kw4Oxr3pXpegLowYqx1+AxCYlrJ35U=;
  b=Y2WnjUDu1HrBMuQ+iYx4OqjN0jDcHkWOqWD6A8/V5cwQDWOoX2O27/fh
   musLJ4wnrTijVuHrr6Q63a7hwtvp7KFKcePLhUvZy8/mGwFDNl4p8BTD0
   P6iJJNntUOLwzotwl212qD/LYm/NmVppjruoWZIWwyynVqNG4YdU+Ic0g
   irbbtS6dg2U5DQ0duTV388WoOb/ZALfOa+QrCICVUb4OQsDo3x6GBzGqY
   k40PF/z0I+1y0dF/LQ5Ua0+/DobB2Ldmygq+hzJ+tuT1E/lYDbNibU/NK
   sedsFGOAPTlXNiPI9+66VLgY/DPRrGTeKWJlQ465ymLky01Gn+cPUSCN+
   w==;
X-CSE-ConnectionGUID: 0Y9h6mO6RL+cbihRQOhRGA==
X-CSE-MsgGUID: Z2HCfbXuQpCDWfeC7I5Q9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="60265670"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="60265670"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 15:46:05 -0700
X-CSE-ConnectionGUID: 4QeesCATTsmMrlgg5vtJrQ==
X-CSE-MsgGUID: Pn2DO2JeQJGPz4SU9PCCCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="162803309"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 15:46:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 15:46:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 15:46:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 15:46:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yh9n2B0UkDWiMfCem6Wn0W026GuNHDS4/1fnHuE76RCswqls6SOhnJ+crv0RXxpGoxF2hFtAhnjLuBI3Bp6G1F1tAF6CiA8DjUJHaWVAKXKw+pSX7mFMQYG0k6wQWVOhSkmylKraGi5uD6a4v+30QO7qPpAbpPRfZFrKeZ0B5x5MmeEVEns3nxpI2iA2AF4os3zhc20YGVM0Ujb97j05LC+GCHrff6+uX49/l9WtmF7sVdVi9g8i7F56jM8TEbOCBnUBxUG1xivB+I/E5wcDx5wEEkAdRSGA2B3odH5qu6aOUyxkBMjxTaw5oUIPnBMORaMa3N6qNnwA5REywPsdtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vf6ywxFyaP0c2Kw4Oxr3pXpegLowYqx1+AxCYlrJ35U=;
 b=cwaO8etD/jZMfUk4/ox2WvpseDfzmDgnm9/d5PWEIkQqUD73P/2aKA5zx0eywcLluquENuNlBzIZUAdz4YnPcQ3HLcGQ6YTMp4/uHr5cPHsTPJABUuKahaq+ZRAW5wjJgu5ywUWYKoo1/kaDUOohMWKdvq5zZMlTailN61+A7+U2VXlyxufow+ejZjdCbMyqhbKGRmUnp21MADdFXxfuAY1H1fSRDiOa/BBy3r8ExISQvc2UT+QqVe4MlUCkdQ2dMQvdA9dsKiEhhxOz/ILYPdHa0tvAcM2ZMEYe55NB9CJbZLa8S4x3fvtcwQzJEQC/V7oLVQpOf1jY0IN7JTH3wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA3PR11MB7486.namprd11.prod.outlook.com (2603:10b6:806:314::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 22:45:42 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%3]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 22:45:41 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "Raynor, Scott"
	<scott.raynor@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Mallick, Asit
 K" <asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Cai,
 Chong" <chongc@google.com>, "bondarn@google.com" <bondarn@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: Re: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHbyI9nK0GX+MCyyECBUnY05vaI+bPZ0mWAgAACboCAALmIgA==
Date: Mon, 19 May 2025 22:45:41 +0000
Message-ID: <0c2f968860af68e65cebaf4f99a764d28e8a1030.camel@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
		 <20250519072603.328429-5-elena.reshetova@intel.com>
	 <990841309a27d4f3e7c53b44d7cce0e555594a21.camel@intel.com>
	 <DM8PR11MB5750CC5686E413A88CF41D7DE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750CC5686E413A88CF41D7DE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA3PR11MB7486:EE_
x-ms-office365-filtering-correlation-id: e572ef90-ef99-49ab-7209-08dd9726e257
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dHVWRzJoMnFjM0VabXBuVHU0UmRNdUZZaVNFc1JxYWZjc1U1TDc4NGI5dlJ4?=
 =?utf-8?B?d0QwaFdCbGRXVkxsbStnQ1pjSHdrcFRxVU55VWx1MXg2bGNSM2oycktZK1Jn?=
 =?utf-8?B?cU1seENiSm4vaXlkS1Y3Y1ZWWnk3WGVrYzdpNGFYS2RiQTFqazVlMEc0RmFY?=
 =?utf-8?B?MzNiVkx3eXVqM1FwYjhDcGMrRVpJWjVxbWV3WUQyN0wrS2tLWFFueHdreGE0?=
 =?utf-8?B?cWJOdU1zTGZZWERIZ0szMXRsbHZnQWtvZVBGeVJ1QUZ4c3k0WEdIdlF4OVVr?=
 =?utf-8?B?NWwxKzdFWW9RVFNZWUhmUWs2RUZmNmpOUi9TUGJTdmVNcFRLU3RzUVhNYU9a?=
 =?utf-8?B?UUE1YUJMYkkycFNkVGY0c24xYkxIL0szSDlNZ0JXOE5zSTYrbStlZUhZSVJI?=
 =?utf-8?B?WFQ0YWZXdlZITldWanRqc1oyVzhoR3Q1NmJySTVCS0tRNGZ0SHRycDN3UjZn?=
 =?utf-8?B?amNGUXkrL1EwYi9GNWZlWVRiMEpMS2xNcnlQdURRT0pWQmd3L3E5SXM1QTZX?=
 =?utf-8?B?TG5HemZnTGtCemJwcWpXaXZvbDZBK3BWb0lnMTZSdFk5czQ2aHZpcHJNbUVp?=
 =?utf-8?B?TnZKQTJQYnpHa1VrK2N4NURCZXNzdXdHczlHYjNVSnBUNFVJellNdFpQNkFj?=
 =?utf-8?B?c2RaejBIUXh0VkZ3Ni9SUGlkNytpVStSWVdHaGJ1WHJMOWEwUjhISysyQkdV?=
 =?utf-8?B?dk5HQ2hoRFdYMDlGTWNVb0ZFaXgxSmpJVExWbkQ2aXBiZXNOZnpodzhXWlg3?=
 =?utf-8?B?RUo0QWxJMGZ1TjVZWDdGYXlFVFQ0SlJFdklOZFRPZi9uTDRhZk5Mdm03MElP?=
 =?utf-8?B?TktjM1h0a0cxbXhjNFRYVzdxdDJxREh0NWJHUnBOdFBlWmpmL1NQNHN1S0JP?=
 =?utf-8?B?dXN3MmtwSkVQMkpGQldDK2F2MGtRNzJKTVRKczlMRjA5U2tUZGs0WnhTbElS?=
 =?utf-8?B?dCs3QUk3ekVsUTdKdkcyd2s5dlNuKzU2NGY3TnZQVmV5YkFJbjNhZWJSczZw?=
 =?utf-8?B?TVZTaFRxNlRXb29xckEwVGkyMmNZOWNpMCsrY29RRXJ2dTdiYmlhRnlBeGM1?=
 =?utf-8?B?MWxEUUtTaVpMOVBUa296UVJvNDV2a1Y5aDMzQ01FZVkxT0NYZ3o0bStENmpy?=
 =?utf-8?B?YmZydXdBTE9ZZWxwN0xpOTZGNFFyeUJhSmZJV0JhK015dEVod0hFanZjMTl4?=
 =?utf-8?B?VCszVVRCbWtIMjlZRjFHYUZQckNFaXJITDFsSXJmbjY2eU5hanZ3Vld3dGhs?=
 =?utf-8?B?UTJ0MFZEWjBRZkVmUi9nVFpIcXZMUUVyV1kzWWp5R0krMmprVE1zajRWbUNM?=
 =?utf-8?B?U0lJNHFlV1dKRFNibXJyRytwL1JOR0grbjJTdGNXNnZrc1lPUXVnTUpWUnYw?=
 =?utf-8?B?dzA0MW9vaEQyNHlQZVVaL0gxNjZGeTQ3bVJRSUs0SXl2bXFzaXdIZWxGSnA5?=
 =?utf-8?B?NDNrQzFBcVJ1SHFaa0oydGlRbU5zak5YTWhWYTVYcTRtUzdvU3FsWnNGeWN3?=
 =?utf-8?B?MExkaW85NHVvcE9UWXBuemRRcFkyMllhRWFvRWFhNzBLaDE4a2NwczhoVnRi?=
 =?utf-8?B?Q0VzQTZNTU1ITUdmamZqNHB2OUYrRzJpeCttNzF6bWJLb0lMZTVMeEI2clBJ?=
 =?utf-8?B?NVE2MTB4OXZMVjN2akNueTZMWXpHZkZVLzYyWHNJazNmbkNZbTEwQUVSSGdJ?=
 =?utf-8?B?cjVCdGdNS1pCMWdoaUxTN3grK2ltc2Z6TWpSNG4xM0V0T2Y2SEhMbWhraFFs?=
 =?utf-8?B?MjhMMEVPRCt6dzZVOUJQY0ZiTndRM0tTejltT1UvdTlzVWVNTXZYUWl4WCs5?=
 =?utf-8?B?UXUydzdyTElPVnBFY3NjU2k1bTNaVG5lbGtxeXRPVTZwMHg3YUk4RnBORjVG?=
 =?utf-8?B?a2I0N0ZvT1ZCSC9LczlLTlFsUjJJdk5IdHFPNmFrUDZSWVBsMlRrSXdsRi9a?=
 =?utf-8?Q?0Bxg4nKBwq0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTlkUWcvR3dSSXQ1RXdqQ0VQTDVHcDhIMzZqdEwxSHpUbVJ1cTdMa0FuN3U1?=
 =?utf-8?B?S2tCVFY4bnpxaThYVElDMnc5YnN2SGFZVFdKQnJINzFnaXQyVU9nRmVHQUVn?=
 =?utf-8?B?VUtEbGdYSGZMcEQxUXBqNGl5cVYzUDk4ZDd1TnFocm80S3d5T1IxZEVqcEZW?=
 =?utf-8?B?R0E3ZHoySEtHNElnR01TL3QxamdQdWhzRjZIeEgzUFZkaFB3b2VqT21Jajdy?=
 =?utf-8?B?TFVVU1BHdEtLMHRtSlNkM3lqNU81encrelRFdFhSdjhYbVI0cW1ieHBRd3ZL?=
 =?utf-8?B?QXNaS3FhSVhySkVkc0h0VjcyWDNhTzVDVnNFZ0FtbGpldU5KS1pBQ2FPazhY?=
 =?utf-8?B?TWx1c1N1MEVFVy9UZkJTdGtoQng1OGk3Tkg0dWpTeUVES0VENGMrK1N2N252?=
 =?utf-8?B?OEFaTHp4WHRhMFhoUDdRN21zU3FZV29pSVB1a1VxMzlwQWluT25TMDl2YnR0?=
 =?utf-8?B?enhOeWpON3huWWxSam1sSzc0bWhuNlRjWGx1V3ZxTm1JOFJzSUhVUG4xWGNJ?=
 =?utf-8?B?MnlZMkhPTElIS2FvVmsweFJkajlhWjNaTUc5NkVLVmVRek5ZdHA0T0FQZVhZ?=
 =?utf-8?B?eWlpR2dMVlQybjZhbW5iU1FhS0w0eU9meXRTa3RRVFFaaDE5VmY1eXFqaFRO?=
 =?utf-8?B?QWtzR24weGovTThyVDdwRWRYdmxFdHJQMGpXUXlDb2Z5OFZjY0hvK3hpekxs?=
 =?utf-8?B?WTNTOFNCUHJ6VkVLdXZUdlB6MEY4Y09qVnM0TzROT3pvejBTRXNaZUFhK0NO?=
 =?utf-8?B?ZVFUSVBLbENYQkgrWGNYRFpPb0ZnSWI2MGs2eXczU1F0aU9vTnN0UjkvUWk2?=
 =?utf-8?B?Slh4UmR2TjdkS05aTmlOSkdlRVd5QXE2aWxSeGRLTzQxR1JNeHg5Rk55NC8w?=
 =?utf-8?B?M2g5Z1gyVXdacWhBRStLMVN3Mm1KNXFENWdmUlhLVUc3NWIxbXlHeWNObjh4?=
 =?utf-8?B?VXJYSys2K1hEa1hnTWQyVkQxS0htVzNONXRaRnpVc1VKRk5rc0s4OUJTd2RV?=
 =?utf-8?B?RTd6cDk5cXRuUDh6b3NldE5Uc3MrelVuV2U2bWpwTzZGckVoSXdpYnpHNmVz?=
 =?utf-8?B?cXpQSm5FcDA2TlNad1RkWjZHYThVZ1dzdUNSczVYeTBxQ0tlMlk2cHI0VUJF?=
 =?utf-8?B?YkcrK3E1ZmhqckJYcE9HcFNJWGQzOFNUZXRVdFFLd05BaEVySE5tbVBiRDdF?=
 =?utf-8?B?MkoxRzg2Z0NMM2pZdVFjZkR6UGZWb2dUeFEzKzQxZWlVK2RQOUk3Q0pyK0wv?=
 =?utf-8?B?U1I1VExndEppclZVMGF4enJhZ281T2h3U1JHUHRWcGRqTkN5OC9qWGlNazZm?=
 =?utf-8?B?VlJHUWdrRmhuWFpDYloxcDNvbnp3b3J0V3F3ZHRnTlBRWGlwMzlxbGFPY0tS?=
 =?utf-8?B?b0UyMHNwNzFCL0tEZmU4U1JPUVNISmVRUnhqNWJlSUpPdVplQmFEU3IxaHg2?=
 =?utf-8?B?U0l5UVBrdXNzVlFEb0p2dXNlSUxoRUlyWDN2bFR0TndJenFOblQ1M25OUEZp?=
 =?utf-8?B?andVaUhXWk9seW13enF1bk45eWExOWgxTjQwQ3ZXVjYxUmhQUVNLTHhpOS9T?=
 =?utf-8?B?UVlDWjJ2WnZtUzNzcXdDSHpvRVFVQXR4bktzdE00OFZmSW1lZmhBTEJwTTVa?=
 =?utf-8?B?cDEzbXE3Rld3QlJBWnIvU1dSM3NhN0VHK0tPblE2VUhrbncxQjZ0MmxKTHlI?=
 =?utf-8?B?ZFhBbjBGUHYxaE9xMGRHNGpTUzJ1WnBNbkdpeDQxODMyQ05RaHR2TVJoMXhT?=
 =?utf-8?B?WFNDNnlTbFJROC9YTllwbE5KYllvNXlYZ2s0UHJpdGtESU4wUEF0eHdkQTlD?=
 =?utf-8?B?UE95eUxPeFpyazRqbDhrRGt5MUh6dWZmV3ovSFd6ZzhnZytCczNlVS92bHZl?=
 =?utf-8?B?YmZuVmt2dWMxazVxbE8zYk95VG1jT254ZDRPbnMxRmxrV21zMzNhbG9YcXFS?=
 =?utf-8?B?cjRKM1hvVUp1L1crVWwxM0FjWHp3WEtLVmtVZCtuRytJV3JySUFjSlA0cDBh?=
 =?utf-8?B?SWhpNGxJWEYwZnlBL0pjWFgzcGhuMmk0N1Y3N0xtZ3hLVzQ5MFNlRzdxRXhR?=
 =?utf-8?B?VUdZKzNZTWRkb0pBRndkR3E1Nms4M1hCWkpsYkxEUGdHNGx6aWZlbkczVllt?=
 =?utf-8?B?TUtDSkp3NExjaGRlT0hTQzVoZGlicDZ1eGtCaWxyT2pUTTZWS0RGSFNtb0FL?=
 =?utf-8?B?YVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B293FF452E1EB4FBB9C1E64DA553842@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e572ef90-ef99-49ab-7209-08dd9726e257
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 22:45:41.8325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a6H6skQlX4X4pFSfs06SVdz+waaQAi5h7akapcOKk7JBl+tSnEH6LI+CqYzfDQ7zvvMokg8wGFKjbMGnbdrtbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7486
X-OriginatorOrg: intel.com

PiA+IA0KPiA+ID4gKw0KPiA+ID4gKwlmb3IgKGludCBpID0gMDsgaSA8IFJEUkFORF9SRVRSWV9M
T09QUzsgaSsrKSB7DQo+ID4gPiArCQlyZXQgPSBfX2V1cGRhdGVzdm4oKTsNCj4gPiA+ICsNCj4g
PiA+ICsJCS8qIFN0b3Agb24gc3VjY2VzcyBvciB1bmV4cGVjdGVkIGVycm9yczogKi8NCj4gPiA+
ICsJCWlmIChyZXQgIT0gU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZKQ0KPiA+ID4gKwkJCWJyZWFr
Ow0KPiA+ID4gKwl9DQo+ID4gPiArDQo+ID4gPiArCS8qDQo+ID4gPiArCSAqIFNWTiBlaXRoZXIg
d2FzIHVwLXRvLWRhdGUgb3IgU1ZOIHVwZGF0ZSBmYWlsZWQgZHVlDQo+ID4gPiArCSAqIHRvIGxh
Y2sgb2YgZW50cm9weS4gSW4gYm90aCBjYXNlcywgd2Ugd2FudCB0byByZXR1cm4NCj4gPiA+ICsJ
ICogMCBpbiBvcmRlciBub3QgdG8gYnJlYWsgc2d4Xyh2ZXBjXylvcGVuLiBXZSBkb250IGV4cGVj
dA0KPiA+ID4gKwkgKiBTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkgZXJyb3IgdW5sZXNzIHVuZGVy
bHlpbmcgUkRTRUVEDQo+ID4gPiArCSAqIGlzIHVuZGVyIGhlYXZ5IHByZXNzdXJlLg0KPiA+ID4g
KwkgKi8NCj4gPiA+ICsJaWYgKChyZXQgPT0gU0dYX05PX1VQREFURSkgfHwgKHJldCA9PSBTR1hf
SU5TVUZGSUNJRU5UX0VOVFJPUFkpKQ0KPiA+ID4gKwkJcmV0dXJuIDA7DQo+ID4gDQo+ID4gSSBh
bSBhIGxpdHRsZSBiaXQgY29uZnVzZWQgd2h5IHdlIHNob3VsZCByZXR1cm4gMCB3aGVuIHJ1bm5p
bmcgb3V0IG9mDQo+ID4gZW50cm9weS4NCj4gPiANCj4gPiBJdCBzZWVtcyBpbiB2NCB5b3Ugc2Fp
ZCBpdCdzIG5vdCB0aGF0IGhhcmQgdG8gY2F1c2UgRVVQREFURVNWTiB0byBmYWlsIHJlbGlhYmx5
Og0KPiA+IA0KPiA+IMKgwqDCoMKgQW5kIHRvIG1ha2UgaXQgbW9yZSBjb25jcmV0ZSwgSSBtYWRl
IHNvbWUgc2ltcGxlIHRlc3RzIGJhc2VkDQo+ID4gwqDCoMKgwqBvbiBwcm9ncmFtIGZvciBzdHJl
c3MgdGVzdGluZyByZHJhbmQvcmRzZWVkIHRoYXQgd2FzIGRpc2N1c3NlZCBpbiB0aGF0DQo+ID4g
wqDCoMKgwqB0aHJlYXQgZWFybGllcjogaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMjQvMi82Lzc0
Ng0KPiA+IMKgwqDCoMKgVXNpbmcgdGhpcyBzdHJlc3MgdGVzdGluZyBhbmQgZW5vdWdoIHRocmVh
ZHMsIEkgY2FuIG1ha2UgRVVQREFURVNWTiBmYWlsDQo+ID4gwqDCoMKgwqByZWxpYWJseSBhbmQg
cXVpdGUgZWFzaWx5IGV2ZW4gd2l0aCAxMCB0aW1lIHJldHJ5IGxvb3AgYnkga2VybmVsLg0KPiA+
IA0KPiA+IFJldHVybmluZyAwIHdpbGwgbWFrZSBzZ3hfb3BlbigpIHN1Y2NlZWQgaWYgSSByZWFk
IHlvdXIgbmV4dCBwYXRjaCBjb3JyZWN0bHksDQo+ID4gd2hpY2ggbWVhbnMgdGhpcyB3aWxsIGFs
bG93IGVuY2xhdmUgdG8gYmUgY3JlYXRlZCB3aGVuIHVwZGF0aW5nIFNWTiBmYWlscy4NCj4gDQo+
IFllcywgY29ycmVjdC4gDQo+IA0KPiA+IA0KPiA+IFdoeSBub3QganVzdCBmYWlsIHNneF9vcGVu
KCkgKGUuZy4sIHJldHVybiAtRUJVU1ksIG9yIC1FQUdBSU4pIGluIHRoYXQgY2FzZT8NCj4gPiBV
c2Vyc3BhY2UgY2FuIHRoZW4gcmV0cnk/DQo+IA0KPiBUaGUgaWRlYSBvbiB0aGUgcGF0Y2ggd2Fz
IHRoYXQgc3VjaCBhIHNjZW5hcmlvIHdoZXJlIHdlIHJ1biBvdXQgb2YgZW50cm9weQ0KPiBzaG91
bGQgbm90IGhhcHBlbiBpbiByZWFsIGxpZmUgdW5sZXNzIFJEU0VFRCBpcyB1bmRlciBzdHJlc3Mg
KGluIGNhc2Ugd2UgDQo+IGFjY2lkZW50YWxseSBjb2xsaWRlZCwgd2UgZG8gYSAxMCB0aW1lIHJl
dHJ5KS4gU28sIGluIHRoaXMgY2FzZSB3ZSBrZWVwIHRoZSBsZWdhY3kNCj4gYmVoYXZpb3VyLCBp
LmUuIHByb2NlZWRpbmcgd2l0aG91dCBFVVBEQVRFU1ZOLiBCdXQgSSBjYW4gY2hhbmdlIHRvIHRo
ZSBhYm92ZQ0KPiBsb2dpYyB0byByZXR1cm4gLUVBR0FJTiBpbiB0aGlzIGNhc2UgaWYgZXZlcnlv
bmUgdGhpbmtzIGl0IGlzIGEgYmV0dGVyIGFwcHJvYWNoLiANCg0KV2VsbCBJIHRoaW5rIEkgYW0g
c2VlaW5nIGNvbmZsaWN0aW5nIG1lc3NhZ2U6DQoNCllvdSBtZW50aW9uZWQgaW4gdjQgdGhhdCBz
b21lIHNpbXBsZSAodXNlcnNwYWNlISkgdGVzdHMgY2FuIG1ha2UgRVVQREFURVNWTiBmYWlsDQoi
cmVsaWFibHkgYW5kIHF1aXRlIGVhc2lseSBldmVuIHdpdGggMTAgdGltZSByZXRyeSBsb29wIGJ5
IGtlcm5lbCIuICBUaGlzIHNlZW1zDQp0byBtZSB0aGF0ICJSRFNFRUQgaXMgdW5kZXIgc3RyZXNz
IiBjYW4gY2VydGFpbmx5IGhhcHBlbiBpbiBpbiByZWFsIGxpZmUuDQoNCk9yIGFyZSB5b3Ugc3Vn
Z2VzdGluZyB0aGF0IGtpbmRhICJzaW1wbGUgdGVzdHMiIGNhbm5vdCBoYXBwZW4gaW4gcmVhbCBs
aWZlPw0KDQpFdmVuIHdlIGFncmVlIHRoYXQgc3VjaCB0ZXN0IGNhbm5vdCBoYXBwZW4gaW4gcmVh
bCBsaWZlLCBzaW5jZSB1cGRhdGluZyBTVk4gaXMNCmFib3V0IHNlY3VyaXR5LCBJIHRoaW5rIGl0
J3MgcXVpdGUgZmFpciB0aGF0IHdlIG5lZWQgdG8gY29uc2lkZXIgdGhhdCB0aGUNCnBsYXRmb3Jt
IGlzIHVuZGVyIGF0dGFjay4NCg0KQWxsb3dpbmcgZW5jbGF2ZSB0byBiZSBjcmVhdGVkIHdoZW4g
RVVQREFURVNWTiBmYWlscyBkdWUgdG8gcnVubmluZyBvdXQgb2YNCmVudHJvcHkgaXMgYSBjbGVh
ciB2aW9sYXRpb24gb2Ygc2VjdXJpdHkgdG8gbWUuICBBbmQgd2hhdCdzIGV2ZW4gd29yc2UgaXMg
QUZBSUNUDQp1c2Vyc3BhY2UgaXMgbm90IG5vdGlmaWVkIGFib3V0IHRoaXMgYnkgYW55IG1lYW5z
Lg0K
