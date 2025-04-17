Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5676221324F;
	Thu, 17 Apr 2025 11:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744888359; cv=fail; b=bG4oMSP9CQfnAoGwUVkiwvKBbBGyMjJc0aDT+tsDLco21qPs+RggxPocIvC9qxiFoezDE2v8hhwXs1pwu2HXHrE6zqa+hNexP6ZDN+kUXk5Jr8yJ9VBX1QeuWMytzbt7KHf6w54lDEmbXgMqdv7JJrZdl9vgDvv4t6iav+vZWMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744888359; c=relaxed/simple;
	bh=dCKxYAzP5XDAUNMuCx8BCDryVJC2XtRNt94HssGMTVY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oaGWhk99Z1c2srKQ+J1S+JKDklPE7iqQ/eq/WZgMj6nYvzv4Dk+JOAn87S8IYwCf1OQPpPq7WctuoqdUHeQ+vEYnjF6GNN/+Ig0J0yYbH6/oNzrpHnGuNbC2NdakFIoMBlaijAU4M2RCBaCQM2ye2cJtSK9AAJtk3/OkYWRv1E8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E3dKBuC6; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E3dKBuC6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744888357; x=1776424357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dCKxYAzP5XDAUNMuCx8BCDryVJC2XtRNt94HssGMTVY=;
  b=E3dKBuC69V/bIm2Cq7ITT4lknftwQzNZN8fMmyjOBH015AXE7TTAo7c7
   S/cr0m1HaiRGOIUwMwia1JD9TmEC1VAMQfRKaqSUqEltDWu+rflmnoVI9
   SAi1qpeHkL+Fj2srWfogWpQojeJXQlfy10w7QUKJJ2qcXMalTHU8kKdnR
   IRwEiolk5+lY0ErUHSYYrrlD2XYR4RElhaq4zUPnHBlZaM1wsJx9nK5Xu
   9cvq0Ws8QdlGZc7n2l/cTRVRjLuz1OdSn1Y+JrEtkTS2FBUAsSFmzWaZ9
   pztrmfn/R1VzBarkV8zl7QMjqnJ3PP5K/o93MtQk86YqPmiDP9lEFYcnj
   w==;
X-CSE-ConnectionGUID: YH6IBv/lSgqLmyxSRJz/lQ==
X-CSE-MsgGUID: Rflp061IQoqADtP4nIPFBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11405"; a="57854229"
X-IronPort-AV: E=Sophos;i="6.15,218,1739865600"; 
   d="scan'208";a="57854229"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2025 04:12:33 -0700
X-CSE-ConnectionGUID: oPLSVOrJSred3eYvfR8A+g==
X-CSE-MsgGUID: v3I+Yi6CQPOoxE+e+4hqfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,218,1739865600"; 
   d="scan'208";a="135628058"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2025 04:12:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 17 Apr 2025 04:12:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 17 Apr 2025 04:12:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 17 Apr 2025 04:12:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URFEf+I7k1/oT7H6UtRxOeKCQRoDcS/t+uyxKSwPXvbdrEtSpF7rg1lZsbXC8JSWvzTBQMGKjhuy0fVHPevbRXxWJbhvh96EzpNGB2sMAb0s6lofT8fpL0JYTX3GHbAZ3ULtGrhvvRZ0xp0uolDBrq+uTnG2KgN+mz2gU3TSbcaxskIsWMF1/lkzlzgwTvwOHqMZ+9B1kCxz3SFN/JYE7Vmrle0MouTiXFMjG2Zj8365xj5zBWQ7tIHj1zvHo8TD/XfupbpjGJpYFXwnfIxRIZi9HEckU6J8CXuCeeTwHgRcFhOOa53so9f2ce3Q8pFHiyoMmc1JqRouRb5siZdYFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dCKxYAzP5XDAUNMuCx8BCDryVJC2XtRNt94HssGMTVY=;
 b=XG2aMfDqbC3netkKNv0cv2Cio3cdFB987cAZUrj8MjQH1ny1NU6ZOZVTStzFLpJz1ZNE12EoeZ+miB+KgShw9r2O5XnIG731WtCD3eXpX6Zny4FvysaIqxHzIdtqaN5Y8pdZfLo5ogvbeEFP7ANVnVhB8nG7Y6H+jxJBz906Nral1TTMrg4PU645MovxVSeT8q1tbqPVoKvFz42jg/12vju41X++nIqyZGAAgqhIlHxKjgliz0pomspdY0Bscxqn+6g/gFIY/1A0/Sq3EfYP8EYy+I86VFXcazcq4yHjO5CqruyyD+lSW+s8Cn6Udh6YktAJMRixhgC7ZEMQFpilwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB8198.namprd11.prod.outlook.com (2603:10b6:208:453::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Thu, 17 Apr
 2025 11:12:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8632.030; Thu, 17 Apr 2025
 11:12:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
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
Thread-Index: AQHbrfz+Y/CHaQuxfEeQ0lhbNBYyWLOl6JWAgABLiQCAAYMCgA==
Date: Thu, 17 Apr 2025 11:12:08 +0000
Message-ID: <6bbfb38a0cd66af3d3562a82adac835316b1f4e5.camel@intel.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
		 <20250415115213.291449-3-elena.reshetova@intel.com>
	 <11f7e006073d2a4fa8fd6c609024a69ed40af9d6.camel@intel.com>
	 <DM8PR11MB5750C80ED4AB80C696F581EFE7BD2@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750C80ED4AB80C696F581EFE7BD2@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB8198:EE_
x-ms-office365-filtering-correlation-id: dbc6326a-b0b5-41f3-2f03-08dd7da0b1ef
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U2dZeUJRR3dOb2xCL2VKd1B4TVM4ZVpBbHd1T3ZnYmE1eWN0YUlheWtpM0Zn?=
 =?utf-8?B?S1FIMGVXVzdkRVpaNUJReVFoS3lZTFc5MjF5bUQ3SXlScTV1NE9XV2xmWm1x?=
 =?utf-8?B?dEI3dlFqcnVBaFVYSWhzdFgrU3BDNkNyd3pTYjdnbE9RbmxXZlNOVkEzMU4y?=
 =?utf-8?B?L005NUhSVXJvVjlhaXp6c2dmditjTXFBVEt2clZsK3VpMUhlNHRzdHVwbndq?=
 =?utf-8?B?SGJza3I5V3NTTHJzc0ZSNC9TeVlydkx3MVVDWFVXUUc0blZSeFNrVTJHd1ZI?=
 =?utf-8?B?ZEoveGIvb0pwOW5TU0twdE0xVXpLb2FRWXZ3bVNIdWVQUzZmRGhJZ3RzcGgv?=
 =?utf-8?B?VkV5cWxCVEFGdlJxSnc3dm93RDc2bU9Ub2VjZVNBUStMWFJXbDZQeitHWW1o?=
 =?utf-8?B?bktMa1Q2T0xEeldlSFVyZnA1V0wzK2tyNUdLeUoxdGFsaU1yaHROaVMrNlFP?=
 =?utf-8?B?NngzOGxabzVuQ3htdzArYnpRZHI2OW9CQ3Vad2ttdGp5V2VOL251ZjJFWFdT?=
 =?utf-8?B?dkhpMXdVUkNDQktpQXQ5blpvZnBMTlA4UC8rM21pVDR6ZElra1N6TXBDaGZN?=
 =?utf-8?B?S2trK2NobWNGQTVMb0FRa244bzY0NkN6YlNuRUhndGtjMWJTN296N1VIOUl4?=
 =?utf-8?B?L3cyaWtScXlycUpIQWZQQkpRaThFcjE2TWs1NkRJOHVyU29wY0k5eW8zdWF0?=
 =?utf-8?B?dDdaeWVFUkxJK2RlSThqanBzdGxKWHNWMVkrY0VjV2Q4N29PZTMvekxtWXpN?=
 =?utf-8?B?NnhrMTdJbDVlcFVmOHc3NVkzNVl4bVBiOVc1RkNYYW40WEFqZlBrTGZIVDRI?=
 =?utf-8?B?SlJ1QzBYbnFQME5RbzZJMEwyMGFkeXRCOFIwb0laWGJUenZYRzFUZUpKRnFO?=
 =?utf-8?B?S0l4eENBQkY0Z2hTY0pvUnFQMkZOakd5ZXl6ZDg4aWFLYUphVjVDNTdCVzFB?=
 =?utf-8?B?WktydjlLUllqdm1tY0R4NzZwNU54RkFPUDVTYTZiZVFMM01vcFlBZmp0NVJW?=
 =?utf-8?B?dFk0MlJscTl4dUs2TDBkVEVQVlRMelBNVHpuNUtnUHZrVUl3NW12UlpGZUFM?=
 =?utf-8?B?WjRHUHZyUlh4ZDFweHRtV24vb080TXJxeEpqb215Yzk1RXArRk81Y3FnbjBR?=
 =?utf-8?B?T2VoWTVnMFZWb2RWSlpUajc3ZndGU0NJZ1BSMjRzamgrSWIyUXZQUGMyc1BE?=
 =?utf-8?B?NUhrc2lvanVzYmVPKy9BMjZ2TXpHV2tySDdGVzJNTDhZNUNFTEU1VTh0R0Y2?=
 =?utf-8?B?eklPVkdCdXh5NCtUQnpId1NlQm1HS0tnV3VvWHpyY2RNUU1GUGZGajdxUTAx?=
 =?utf-8?B?YWRVc05pRnZVR2hEajluS1hVNnVOU3IyNTBrZnNiWk5DVWg2Mm1YdEFYUG1w?=
 =?utf-8?B?azQ4UFZ6N3hOdXdLOXFXWTkrOHh6a0lZaVVJREgxM2dzOTJSQVBVTUEzS3o3?=
 =?utf-8?B?VHUxWDFwckF4b25nWlk3T0VRQkJZaDFmckpnd1RkWjZLS21sazRlSGxITmcr?=
 =?utf-8?B?SGZ1NzVSNFpKbTFMWmphakxMNXpWS1BIRXNlK0pnZnJzOTkwSFVITDVXbnpR?=
 =?utf-8?B?NllHMk9ZaTVNbTJyYjA3czM0dlpvTGsyRkVXWTdlQWdieFpOeitjTlltNVFW?=
 =?utf-8?B?TUJQUDlEMWx4L2NRUkpqajliK3VjRCtRTzMrYmZRQ3QrWUxsZWpYY2NnY0w0?=
 =?utf-8?B?d2x0QUlWSGNPK1EyckE2UTNLK0oxbjNyMVZHTHZGeVoxSVM3TCthWDVDZUFj?=
 =?utf-8?B?bzhHNlpmRnJZZDNmVnFMbzVwREVTMjdjZDZxNWROeGhGcmlVQkNxRlArcGpl?=
 =?utf-8?B?akVzY0pwR05pR1lsMEl3eTZYSGJoR21FRGZtYkZYRUx4M0t1WXcwdFRlbmRi?=
 =?utf-8?B?QU9GakJsZGs0ZHRmMFR2cFZxc1ZkTjZKSEcyUWV0dDc3ckVCN01LQ3pzK1lS?=
 =?utf-8?B?bmJ2WGFYL094Yk9ON203VlBVMVoveVdCZDVlbjR3SkQySTBHckJDaEZ0YUFF?=
 =?utf-8?B?VEh5cjRua1lRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUVoUm43Y2lVUkVRMjBNVm1TZW1kNnBXNXZxbzNPd1pZQVNwTWt6aFVDOGdU?=
 =?utf-8?B?ZlR3MnN4VUllWDI0TjNRWU1sMnp3RlNscEpJRktyRWZQNWVRenRXMkpqQ1NQ?=
 =?utf-8?B?bWhlRnczOThlZWYxekdrMUJWdFFqcGs4dmdGRGdHNkYxNnZxSUFFMXlKWnp3?=
 =?utf-8?B?M2VNSnB0aEJyaWtEdHo1OUxMVDU0OFhYMC9ocDJSRGQ3dURCamNaWXBtdGVE?=
 =?utf-8?B?MnYrT1NDMGhteTVKeFNPM1I4Rk1IOVltVkxVZDA0am53RnA0ZVJZSWFUM1Ju?=
 =?utf-8?B?WHlHMDV1aXV1TnBKUlpzVXF2SXBFc0FBYUdCTXhxWXh1TWdHTS8reHlIaWxI?=
 =?utf-8?B?S3JmZDNndmN4TnY2ZmNHUmZtV1IyOW5obW0zTms3OFBuRllyUHRtRkxlY3Ft?=
 =?utf-8?B?OTZDOEZNVE9BM2puOWZDSjdPMm94Q3JBRkZEN0VpdmVBRG1mRk5kNjdpMTBv?=
 =?utf-8?B?S3YrV3d0OGVVYjFocGhURk5SY3FHTktpemhtaVhEdVN4K21ST0tDdnh4MlNt?=
 =?utf-8?B?OXdDbU9DRzhWdnZrT0VuVUpnbHNnTHNGWmUyUVdPR2d1TzdHWnhaa3VqMEZ0?=
 =?utf-8?B?M21DNUJBSzNwUkkyZjY5NENyQ0ZMTXNkbk1yUERpSkk0NjZOckFGTDZqRStn?=
 =?utf-8?B?a0xLVHgzdEk4RWtlSHY4TE9SK09oVmNXS3RtbXRmOUllczZWVVVIV0FoZW5Y?=
 =?utf-8?B?STJONHNkdzFvMDhjQXFlVWpGYURCc2NwcmorU0tPZlVIbkZSTEFRVlZhVzFV?=
 =?utf-8?B?VnErbnI0OXpYck8zeDRPSmJvdytWSjlYdENLbTNsRVlmbCtOb0pPWjMxaW1q?=
 =?utf-8?B?K08xMkY4b0UveVE3MGVCVWU3VFJrM3NUdTVaUXI2bWI1YjkyT1Ntc3ZwV2o0?=
 =?utf-8?B?VEU5OEFpL3Z4ZUxseTVpQ0FadzFUanFEQmMvRGZTWE8vVmZLOHpDRy9lNUdR?=
 =?utf-8?B?VzlnQ3FVSTdwSDRhU1VQOW1tMFVucCt6Ri9SZ01Rb1p4SjJhM1RXTkMyTDdt?=
 =?utf-8?B?cXFwdW9hQnBNK0lic0lBbmtqcmUxYXlHeDhZV3g5UmxVWlNVVSt1THdpSXN5?=
 =?utf-8?B?UkVjM0hIbGJzQm5WWEJoYUFpbGlqd1VZNnV1bGJhYUJLdUxzTFRwejUvdlN0?=
 =?utf-8?B?S1dkdnhaeTIyNHdRQkNOQzNFQWZHSE5TRENWNmpYblZCL3hKeHF0cGNvK1Rl?=
 =?utf-8?B?THVuRnJnaG1CYURydmx3OFdwSUlxdU1hSkVlWktDZ0s5c29ZSUcyQjhtK3Bm?=
 =?utf-8?B?bzJuWEMrSE1CaXc3aFdmbzZPWERRYnNHNUFjSnFQL0NxTU42b2dlNTI1dzFr?=
 =?utf-8?B?TDY1YldZaTB6amZRY0hFdVIxYVFhWHNrMUY3dWhaeVJrSFZsRXNVR1lCbnJD?=
 =?utf-8?B?Mkk1dTVtQjcrN3duY2xvRDR3WWY1VHlhMDFCNkRzZjlsYk1ZNWVCZXppcjg4?=
 =?utf-8?B?RDlyR2dZdmdGa1ZKdENmUk9YdzFKUzViaWFGcHlXRDNpU3BNeDhFSVY3Q0xt?=
 =?utf-8?B?WTBLRERISldEUHBuM1ljRWdWWmlkaWd5UEJuaTBxT1ZpeWNMOTV2SHEvWWM3?=
 =?utf-8?B?R2szNnlqaFV2SGVNWUZkVW1DUFRSY1lkVEs2T0ZPakw0cTljUjFxL1VoR3d3?=
 =?utf-8?B?MGtOZGJ2NFJNUHBhbTNIK1VFRzhMM1hNa1RsSlhhWmVPVDdDb1RKWHhVSmJK?=
 =?utf-8?B?RktocndpQXZObUZoRGRVbW9laXpOZlBYM0V5ZkNEZTNZTjBFNW82L0tiSGFr?=
 =?utf-8?B?aE9wWEJJZGtrU2E2eFUvaFBpTkxzZXBZVFFRdWN0bGFYWkVqZk1udEd1UE00?=
 =?utf-8?B?QTlUUXRjVkRIOWF0N2txeUIrM3VFWEM2Q1BpKzV3OTM0QmpzU2R2YWpQR0xB?=
 =?utf-8?B?WEJPa1BpK3FiQSs5ZVNWb0NQNHZzRlpKNlVCSTdqVUV4NVNTMU9IZ1Nxemly?=
 =?utf-8?B?VnN6Z3lTQXkvWDJBcGptdGV1cWxEMmx1c0lOSGRCZlI4aEFUS04yMHBZSXNQ?=
 =?utf-8?B?VnJDaHJGNGdLK1BVQTNkb1NuWlp6MUFqNm5MNk9DZHU1R3BabDJUUit1ejFT?=
 =?utf-8?B?STAwYSt5ZFZ3Z2V1VDdyR0orbGJqb3RvSys2ZjR6ak0vV3ozTWpSbkV3d2hq?=
 =?utf-8?Q?7Am0G9oGjbwq5ZoNQiBZfyng2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D41EC5E2699C54F8A9108C035E02992@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc6326a-b0b5-41f3-2f03-08dd7da0b1ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2025 11:12:08.9628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wsMvs0LtxbNjwEvIR1wzN0SZTOz129SxDzFRCFy6m8nyul9A7NpPcZJZSH83Z8J+0wxWjRUxj8/qmUubY7bvhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8198
X-OriginatorOrg: intel.com

DQo+IA0KPiA+IA0KPiA+IFJlYWRpbmcgYmVsb3csIGl0IGNvdWxkIGFsc28gZmFpbCBkdWUgdG8g
cnVubmluZyBvdXQgb2YgZW50cm9weSwgd2hpY2ggaXMgc3RpbGwNCj4gPiBsZWdhbGx5IHBvc3Np
YmxlIHRvIGhhcHBlbiBJTUhPLg0KPiANCj4gQWN0dWFsbHksIG5vIGluIHRoaXMgY2FzZSwgd2Ug
b25seSByZXR1cm4gZmFsc2UgZnJvbSBzZ3hfdXBkYXRlc3ZuIGluIGNhc2UgdW5rbm93bg0KPiBl
cnJvciBoYXBwZW5zIGFzIGFncmVlZCBwcmV2aW91c2x5LiBJbiBjYXNlIHdlIHJ1biBvdXQgb2Yg
ZW50cm9weSBpdCBzaG91bGQgYmUgc2FmZQ0KPiB0byByZXRyeSBsYXRlciBhbmQgd2UgZG9udCBw
cmV2ZW50IHBlciBjdXJyZW50IGNvZGUgRVBDIHBhZ2UgYWxsb2NhdGlvbi4gDQo+IA0KPiA+IA0K
PiA+IE1heWJlIGp1c3Q6DQo+ID4gCQkJCS8qDQo+ID4gCQkJCSAqIFVwZGF0aW5nIFNWTiBmYWls
ZWQuICBTR1ggbWlnaHQgYmUgYnJva2VuLA0KPiA+IAkJCQkgKiBvciBydW5uaW5nIG91dCBvZiBl
bnRyb3B5IGhhcHBlbmVkLiAgRG8NCj4gPiBub3QNCj4gPiAJCQkJICogYWxsb2NhdGUgRVBDIHBh
Z2Ugc2luY2UgaXQgaXMgbm90IHNhZmUgdG8NCj4gPiB1c2UNCj4gPiAJCQkJICogU0dYIGFueW1v
cmUgaWYgaXQgd2FzIHRoZSBmb3JtZXIuICBJZiBpdCB3YXMNCj4gPiAJCQkJICogZHVlIHRvIHJ1
bm5pbmcgb3V0IG9mIGVudHJvcHksIHRoZSBmdXJ0aGVyDQo+ID4gCQkJCSAqIGNhbGwgb2YgRVBD
IGFsbG9jYXRpb24gd2lsbCB0cnkNCj4gPiAJCQkJICogc2d4X3VwZGF0ZXN2bigpIGFnYWluLg0K
PiA+IAkJCQkgKi8NCj4gDQo+IEkgYWdyZWUgd2l0aCB0aGlzIGV4Y2VwdCB0aGF0IHRoZSBjdXJy
ZW50IGNvZGUgZG9lc27igJl0IHByZXZlbnQgRVBDIGFsbG9jYXRpb24gb24gYW55DQo+IG90aGVy
IGVycm9yIHJldHVybiB0aGFuIHVua25vd24gZXJyb3IuIFRoZSBxdWVzdGlvbiBpcyB3aGVuZXZl
ciB3ZSB3YW50IHRvDQo+IGNoYW5nZSB0aGUgYmVoYXZpb3VyIHRvIHJlcXVpcmUgaXQ/IA0KDQpb
Li4uXQ0KDQo+ID4gPiArICogUmV0dXJuOg0KPiA+ID4gKyAqIFRydWU6IHN1Y2Nlc3Mgb3IgRVVQ
REFURVNWTiBjYW4gYmUgc2FmZWx5IHJldHJpZWQgbmV4dCB0aW1lDQo+ID4gPiArICogRmFsc2U6
IFVuZXhwZWN0ZWQgZXJyb3Igb2NjdXJyZWQNCj4gPiANCj4gPiBIbW0uLiBJSVVDIGl0IGNvdWxk
IGZhaWwgd2l0aCBydW5uaW5nIG91dCBvZiBlbnRyb3B5IGJ1dCB0aGlzIGlzIHN0aWxsIGxlZ2Fs
bHkNCj4gPiBwb3NzaWJsZSB0byBoYXBwZW4uICBBbmQgaXQgaXMgc2FmZSB0byByZXRyeS4NCj4g
DQo+IFllcywgaW4gdGhpcyBjYXNlIHdlIGdldCBiYWNrIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9Q
WSBjdXJyZW50bHkgd2UNCj4gcmV0dXJuICJ0cnVlIiBoZXJlIGFuZCBkbyBub3QgcHJldmVudCBF
UEMgYWxsb2NhdGlvbnMgb2YgdGhlIHBhZ2UgaW4gdGhpcw0KPiBjYXNlLCB3aGljaCBtZWFucyB3
ZSB3aWxsIHN0YXJ0IHBvcHVsYXRlIEVQQyBhbmQgY2FuIG5leHQgdGltZSByZXRyeSBvbmx5DQo+
IHdoZW4gRVBDIGlzIGVtcHR5IGFnYWluLiANCg0KWy4uLl0NCg0KPiA+ID4gKwlzd2l0Y2ggKHJl
dCkgew0KPiA+ID4gKwljYXNlIDA6DQo+ID4gPiArCQlwcl9pbmZvKCJFVVBEQVRFU1ZOOiBzdWNj
ZXNzXG4iKTsNCj4gPiA+ICsJCWJyZWFrOw0KPiA+ID4gKwljYXNlIFNHWF9FUENfTk9UX1JFQURZ
Og0KPiA+ID4gKwljYXNlIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWToNCj4gPiA+ICsJY2FzZSBT
R1hfRVBDX1BBR0VfQ09ORkxJQ1Q6DQo+ID4gPiArCQlFTkNMU19XQVJOKHJldCwgIkVVUERBVEVT
Vk4iKTsNCj4gPiA+ICsJCWJyZWFrOw0KPiA+IA0KPiA+IEkgZG9uJ3QgdGhpbmsgd2Ugc2hvdWxk
IHVzZSBFTkNMU19XQVJOKCkgZm9yIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSwNCj4gPiBzaW5j
ZQ0KPiA+IElJVUMgaXQgaXMgc3RpbGwgbGVnYWxseSBwb3NzaWJsZSB0byBoYXBwZW4gYWZ0ZXIg
dGhlIGFib3ZlIHJldHJ5Lg0KPiA+IA0KPiA+IEFsc28sIGl0IGRvZXNuJ3Qgc2VlbSBTR1hfRVBD
X05PVF9SRUFEWSBhbmQgU0dYX0VQQ19QQUdFX0NPTkZMSUNUDQo+ID4gYXJlIG5lZWRlZA0KPiA+
IHNpbmNlIElJVUMgdGhlIG9ubHkgcG9zc2libGUgZXJyb3IgaXMgb3V0IG9mIGVudHJvcHkuDQo+
IA0KPiBXZWxsLCBpbiBjYXNlIHdlIGhhdmUgYSBrZXJuZWwgYnVnLCBhbmQgd2UgdGhpbmsgRVBD
IGlzIGVtcHR5IGFuZCBpdCBpcyBzYWZlDQo+IHRvIGV4ZWN1dGUgRVVQREFURVNWTiwgd2hpbGUg
aXQgaXMgbm90IHRoZSBjYXNlLCB3ZSBjYW4gc3RpbGwgZ2V0IGJhY2sgdGhlIA0KPiBTR1hfRVBD
X05PVF9SRUFEWSBhbmQgU0dYX0VQQ19QQUdFX0NPTkZMSUNUIGZyb20gSFcsIHJpZ2h0PyANCg0K
UmlnaHQsIGJ1dCBhcyB5b3Ugc2FpZCwgaW4gY2FzZSB3ZSBoYXZlIGEga2VybmVsIGJ1Zy4NCg0K
V2hpY2ggbWVhbnMgaXQgaXMgbm90IGV4cGVjdGVkIGFuZCB3ZSBzaG91bGQganVzdCB1c2UgRU5D
TFNfV0FSTigpIGZvciB0aGVtLg0KDQpJTUhPIHdlIGNhbiBldmVuIGFkZA0KDQoJV0FSTl9PTl9P
TkNFKGF0b21pY19sb25nX3JlYWQoJnNneF9ucl91c2VkX3BhZ2VzKSAhPSAwKTsNCg0KdG8gc2d4
X3VwZGF0ZXN2bigpLCBlLmcuLCByaWdodCBhZnRlcg0KwqANCglsb2NrZGVwX2Fzc2VydF9oZWxk
KCZzZ3hfZXBjX2V1cGRhdGVzdm5fbG9jayk7DQoNCnRvIGFzc2VydCBzZ3hfdXBkYXRlc3ZuKCkg
aXMgY2FsbGVkIHdoZW4gRVBDIGlzIGVtcHR5LCB0aHVzIFNHWF9FUENfTk9UX1JFQURZDQphbmQg
U0dYX0VQQ19QQUdFX0NPTkZMSUNUIGFyZSBub3QgcG9zc2libGUgdG8gaGFwcGVuLg0KDQo+IFdo
aWNoIG1lYW5zIHdlIHByb2JhYmx5IHNob3VsZCB3YXJuIGFib3V0IHN1Y2ggYnVnZ3kgY2FzZXMu
IA0KDQpZZXMuDQoNCj4gQW5kIG1heWJlIHdlIHNob3VsZCBhbHNvIHByZXZlbnQgcGFnZSBhbGxv
Y2F0aW9uIGZyb20gRVBDIGluIHRoaXMgY2FzZSBhbHNvDQo+IHNpbWlsYXJseSBhcyBmb3IgdW5r
bm93biBlcnJvcj8NCg0KWWVzLg0KDQpJIGRvbid0IHNlZSBhbnkgcmVhc29uIHdlIHNob3VsZCBj
b250aW51ZSB0byBhbGxvdyBTR1ggdG8gd29yayBpbiBjYXNlIG9mDQpTR1hfRVBDX05PVF9SRUFE
WSBvciBTR1hfRVBDX1BBR0VfQ09ORkxJQ1QuDQoNCklJVUMsIHdlIGFsc28gYWdyZWVkIGluIHRo
ZSBsYXN0IHJvdW5kIGRpc2N1c3Npb24gdGhhdCB3ZSBzaG91bGQ6DQoNCiAiSSBndWVzcyB0aGUg
YmVzdCBhY3Rpb24gd291bGQgYmUgbWFrZSBzZ3hfYWxsb2NfZXBjX3BhZ2UoKSByZXR1cm4NCiBj
b25zaXN0ZW50bHkgLUVOT01FTSwgaWYgdGhlIHVuZXhwZWN0ZWQgaGFwcGVucy4iDQoNClNHWF9F
UENfTk9UX1JFQURZIGFuZCBTR1hfRVBDX1BBR0VfQ09ORkxJQ1QgYXJlIGluZGVlZCB1bmV4cGVj
dGVkIHRvIG1lLg0KDQpTbyBteSBzdWdnZXN0aW9uIHdvdWxkIGJlOg0KDQpJIHRoaW5rIHRoZSBz
Z3hfdXBkYXRlc3ZuKCkgc2hvdWxkIGp1c3QgcmV0dXJuIHRydWUgd2hlbiBFVVBEQVRFU1ZOIHJl
dHVybnMgMCBvcg0KU0dYX05PX1VQREFURSwgYW5kIHJldHVybiBmYWxzZSBmb3IgYWxsIG90aGVy
IGVycm9yIGNvZGVzLiAgQW5kIGl0IHNob3VsZA0KRU5DTFNfV0FSTigpIGZvciBhbGwgb3RoZXIg
ZXJyb3IgY29kZXMsIGV4Y2VwdCBTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkgYmVjYXVzZQ0KaXQg
Y2FuIHN0aWxsIGxlZ2FsbHkgaGFwcGVuLg0KDQpTb21ldGhpbmcgbGlrZToNCg0KCWRvIHsNCgkJ
cmV0ID0gX19ldXBkYXRlc3ZuKCk7DQoJCWlmIChyZXQgIT0gU0dYX0lOU1VGRklDSUVOVF9FTlRS
T1BZKQ0KCQkJYnJlYWs7DQoJfSB3aGlsZSAoLS1yZXRyeSk7DQoNCglpZiAoIXJldCB8fCByZXQg
PT0gU0dYX05PX1VQREFURSkgew0KCQkvKg0KCQkgKiBTVk4gc3VjY2Vzc2Z1bGx5IHVwZGF0ZWQs
IG9yIGl0IHdhcyBhbHJlYWR5IHVwLXRvLWRhdGUuDQoJCSAqIExldCB1c2VycyBrbm93IHdoZW4g
dGhlIHVwZGF0ZSB3YXMgc3VjY2Vzc2Z1bC4NCgkJICovDQoJCWlmICghcmV0KQ0KCQkJcHJfaW5m
bygiU1ZOIHVwZGF0ZWQgc3VjY2Vzc2Z1bGx5XG4iKTsNCgkJcmV0dXJuIHRydWU7DQoJfQ0KDQoJ
LyoNCgkgKiBFVVBEQVRFU1ZOIHdhcyBjYWxsZWQgd2hlbiBFUEMgaXMgZW1wdHksIGFsbCBvdGhl
ciBlcnJvcg0KCSAqIGNvZGVzIGFyZSB1bmV4Y2VwdGVkIGV4Y2VwdCBydW5uaW5nIG91dCBvZiBl
bnRyb3B5Lg0KCSAqLw0KCWlmIChyZXQgIT0gU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZKQ0KCQlF
TkNMU19XQVJOKHJldCwgIkVVUERBVEVTVk4iKTsNCg0KCXJldHVybiBmYWxzZTsNCgkJDQoNCklu
IF9fc2d4X2FsbG9jX2VwY19wYWdlX2Zyb21fbm9kZSgpLCBpdCBzaG91bGQgZmFpbCB0byBhbGxv
Y2F0ZSBFUEMgcGFnZSBhbmQNCnJldHVybiAtRU5PTUVNIHdoZW4gc2d4X3VwZGF0ZXN2bigpIHJl
dHVybnMgZmFsc2UuICBXZSBzaG91bGQgb25seSBhbGxvdyBFUEMgdG8NCmJlIGFsbG9jYXRlZCB3
aGVuIHdlIGtub3cgdGhlIFNWTiBpcyBhbHJlYWR5IHVwLXRvLWRhdGUuDQoNCkFueSBmdXJ0aGVy
IGNhbGwgb2YgRVBDIGFsbG9jYXRpb24gd2lsbCB0cmlnZ2VyIHNneF91cGRhdGVzdm4oKSBhZ2Fp
bi4gIElmIGl0DQp3YXMgZmFpbGVkIGR1ZSB0byB1bmV4cGVjdGVkIGVycm9yLCB0aGVuIGl0IHNo
b3VsZCBjb250aW51ZSB0byBmYWlsLA0KZ3VhcmFudGVlaW5nICJzZ3hfYWxsb2NfZXBjX3BhZ2Uo
KSByZXR1cm4gY29uc2lzdGVudGx5IC1FTk9NRU0sIGlmIHRoZQ0KdW5leHBlY3RlZCBoYXBwZW5z
Ii4gIElmIGl0IHdhcyBmYWlsZWQgZHVlIHRvIHJ1bm5pbmcgb3V0IG9mIGVudHJvcHksIGl0IHRo
ZW4NCm1heSBmYWlsIGFnYWluLCBvciBpdCB3aWxsIGp1c3Qgc3VjY2VlZCBhbmQgdGhlbiBTR1gg
Y2FuIGNvbnRpbnVlIHRvIHdvcmsuDQoNCg0K
