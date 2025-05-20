Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118CF25D8E2;
	Tue, 20 May 2025 06:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747723423; cv=fail; b=jKTWWP7FU721RvFfKp32QWuU9iq4eKjkxQONLZOxfeNlimq22enGIrXpzA5LNKRL7Owf/EdbB7ZF/XSz/x51BRIKz4M5XtR+cjnTfub6WpMk8GFUnq58hOClncwOd85XI1I5PfVNBHvRw9aHQ3oaOCtY1YyQdTUIXRDtthZwees=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747723423; c=relaxed/simple;
	bh=nbrkOod4VjSkVDKrqAPWPKAE4ENtUkcnpfeg5vErOFc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UVbQuFRwlPoNmeZSZnAD5nhNIXmK3Ms2ufDHfkbu7w/mAr586nL7hjzjHZrbMFGF93WRwuk6ZoJdrEOK8EjACMc685+5uIMhBlzhchuvZBQOHyknZCsjfuCLMwUnYNxZ0C+6q3K9tkFhcEvc9kZdxz5sGe3CFVr6GDDh5V7K21M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I9z6+T9K; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I9z6+T9K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747723421; x=1779259421;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nbrkOod4VjSkVDKrqAPWPKAE4ENtUkcnpfeg5vErOFc=;
  b=I9z6+T9KsXEoKxjlB57j6IOT7U6tHstlBZbP24+D7IpY97+MC9I1/Pgl
   kNBctwYL2NUeg/C2kqvhHuvJV0HYJNARRMrwvYfp6Ckc6y4o4NYr5rscK
   O/GvmcETEbncnKTn5JLknjQdMTrutgUSA6BxbaPjX2MEUcpARw/C+qMju
   9me5u7cSJtjWaNyu89vwM4LbqDZWeLwQ0z6JBnyA7yH69dhfrcnByOzZF
   AC0xigzjp6r66g3hffQNfu4Gxk7CK3lqSoL4LIudlliCtSHtQL3jtg43N
   8D6L5PU/4xc/NMf7HP9RtkRzBHs+5GXKDZ1kvWY6QYgeQ4iYhxqvD8xng
   A==;
X-CSE-ConnectionGUID: gdTXGfrMTaOQDU7INvf+NQ==
X-CSE-MsgGUID: scK8MJAJTDG3Y4ilQRJcvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49624096"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49624096"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:43:41 -0700
X-CSE-ConnectionGUID: LfhPWFuETnamoXKO7CySzg==
X-CSE-MsgGUID: xYliREYnTU2NT5BVdQi3QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="139500981"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:43:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 23:43:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 23:43:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 19 May 2025 23:43:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uLTzWUnRAEEjMQoM7//K+6HoSTsA+PVOIInZgnSkTXTHNh7K0Cm7q3yTo5K1XuAAB0MQH+FKb8k/bNJb43LHQ8ZMzdEZ1jIOzOCcujTqjYyXONsuGtFmX6cMMd2cJqJ1R2IwAjTI56Be8cLn9OBuuCMwMhlRv1y66WGqCcRcZpqIvay4IjaJVuJ1oKMJH8lgAdMTq5ebwBkTd3UmBSlkWJBo/LkEpOVzYXhbNM+Gbg1VXw2PhyqaflkKr+YrwB0zFKcVYtFHCP6SzWz6uaT1T3Iw6N+KXTwJba9xWydtC/ZAZJa9VVZBY+B8EOlbQbbpcpf7e+FL6xuMy5waIMMiQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbrkOod4VjSkVDKrqAPWPKAE4ENtUkcnpfeg5vErOFc=;
 b=pEnJewArQYI5OnqvhORo2ObS34hI1DrwWINyzhT3BWneb6707QuCSUneC8rspP0dtu9FDYhRdzLr2p8YX4GCrWSev5BE9Jxrq2BuXXRAcBd2jb4w9UivuzyS3Y7VZF9L+H9kWTO6ou0ykewTkBMc++7cNkPhjw5j6Y351r1aWgVqm0H+pa/8MmQSp2Ol3WdReY7dB2cAHSeqYHMEKHRdbiwEv8w4Cqr2LG42P5qIHblVPdNMJHxevBKWusazgqb0VMEIibAvrC3SgRFPZyIetf4w9TOGBlXnAzBcplEcKnQ9wHFvtjzFKBdTHzOabgOdRJ8VXOjxp/BRlkjbZ44zbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SJ0PR11MB5919.namprd11.prod.outlook.com (2603:10b6:a03:42d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Tue, 20 May
 2025 06:43:37 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Tue, 20 May 2025
 06:43:37 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v5 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v5 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHbyI9qooAzhUPou02sbUcJOGJbyLPZlwOAgAA4QBCAABkkgIABKhFA
Date: Tue, 20 May 2025 06:43:37 +0000
Message-ID: <DM8PR11MB57508B2C1407546C4D8B501EE79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-6-elena.reshetova@intel.com>
 <aCrlFfl2lAzzHOA8@gmail.com>
 <DM8PR11MB57504A6B41329214262E16E2E79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aCspW0MweLoODLC8@gmail.com>
In-Reply-To: <aCspW0MweLoODLC8@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SJ0PR11MB5919:EE_
x-ms-office365-filtering-correlation-id: 63454b59-b8f6-4c3c-6b6d-08dd9769a638
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N0RMcGNkaENrSEpTVDF4bWdTdHBndytCUUQ2UVhPcGE4ZjE2UlYvS0pzZzBa?=
 =?utf-8?B?b2Y5RnFjREc5VHJKTjkyRmFxRDc4bnRBcndBSk1zTERzZmN3QTVJTlRZNnp1?=
 =?utf-8?B?c0t1aDNadUk2bEhZSFFBQnhMYVBmb29vekgzcU5ZSmpyS3hwbmdWOEZWZkxq?=
 =?utf-8?B?TGw1eXkyTThqblpzTWROd0Q2VzlmMElSd0NBK2tZV2tVUHFOaXhLc3F3OXlk?=
 =?utf-8?B?ZHZUZlVSNnBncEQ1QzJ5dC9sc0dMdEFzZStueS94N01SQUFjbFdJcFh0NTJz?=
 =?utf-8?B?aVVoK0N3LzNycmZQT3A1TVgrRktrZ2FqZUVWb3YwM0xQcUVSRmRSa2UvYzA1?=
 =?utf-8?B?eXJ5YzlzVWNzS2hMU1dEcXFDQ200N01hR3NuNlNJM1N4T3VwL0tJcmVzZmh4?=
 =?utf-8?B?V2l6bkNDelRhYzhyZkI0S0IycWR3bk5PQWR5Yk9YaDhxMVFhVGhBUDVyVzZJ?=
 =?utf-8?B?YWJUV0oxc3ZNWkwzL0U0ZDVYYzdIdE03TVpWNG9NbnFRcjVVbk94NXN5Sklx?=
 =?utf-8?B?dVo3VS9NMHQvVUJhV0N0MWlhbkhwMjdIOUpYeDl6MndCMi82V0NPMktpTFdR?=
 =?utf-8?B?a3NOTUdFVlpvVXFpbDdsWWRmSjRRTVBaQ3FES0RHWTFuenVyNWdpWGRMR2Vl?=
 =?utf-8?B?SGo5MStmRjN0T2x4clBUNnNZVDdLSCsxYW92YmRoVnNPTXd3cCt4L0ZTZEcw?=
 =?utf-8?B?VlZneFJqWStkbGM5WGtrQk43RjhJTDdpODBsRFJicHJkOU1iU2NEMmtKQ1Jo?=
 =?utf-8?B?Y1pKVmdiamRuM09ZbkJ6MG9JdXZ5aS9zUTZrNmZxcy81MUFDcjl2RkVoV3Vj?=
 =?utf-8?B?aTlCdFlIT1FPamlIa3NFMnRHa0w5bHl1eHRlcy96b3NtSmt0V2luZUpXeGhw?=
 =?utf-8?B?QXBiSENpdkRuTGFYOVVpMkltQXg3RjAxbExGMWMraWluc1hqZmZUNzRCKzhP?=
 =?utf-8?B?bzBGamhLSDh6RndLZmM3bzZmQWpUNExjUVl2dVlwYkxVbUJZR2JGUTlpWUhr?=
 =?utf-8?B?MnVoWC96Mmozdlc5azFCL0NsdWhGVmpMVXR5di9JQjVyYVZLQjBrWm1BWGp6?=
 =?utf-8?B?OGxNblZISk53dyt3b3pIM1krc3BrdmJ2TnpROFQwMUZvaUpiUWRGb243N2s4?=
 =?utf-8?B?eFh6cFFuTklobEFKRWlCdGVmSkpvN2duZlQ2Y2JiRnZ6cmFMejZibUZsMExv?=
 =?utf-8?B?MlN6ZytaT1FNMEMrWnQyc3ZWZDlRdXNJZFhuU3ZiSDJYam92TUk1S2syL3h4?=
 =?utf-8?B?b1lJV1hSVHJML2QxaEhrdFl0S0FBZzAvS2MzY0hzQVNVck1BRlE1eFBGcjNq?=
 =?utf-8?B?VEF5aGRpZmN1R3VzNE1MQ2ZPRXRSS0FQNFFWUE5LWXZ4Uy9aNFArZk9XdjNX?=
 =?utf-8?B?bUxndDZXVGVGYVk3MTdNL0xjTmdlZWRyaWdMWmlBMEQ4OERxODRuSWhBM3dk?=
 =?utf-8?B?d0JTNDB3VEhFY3NUWDd6WDRjbm5LeEtWWkZITjRGSkZkNDFFOVQwUHdUOTl2?=
 =?utf-8?B?bGRSdHNnb0MzZkZ5RXF3UjJyNzJ0VFordDhEVFp0MWo1STRYZWZQaDJ3Sm5k?=
 =?utf-8?B?MTZ0VFE4K3VsVUFkUHNlcmQ3V2FjSEVEU2ZVWGplK1pncmwzWGpGUWpQTkNj?=
 =?utf-8?B?RFB0RklzRjBiTmRmc3FJN0VzRkt4aWFkT2ZzWE9LNWFsQllwbFpvYmZaSkVs?=
 =?utf-8?B?am5FajlzTTFNTVZwOFJldndTSFo0WlZRWmE5aytCODE0OTdNTGwxQlZmYTJH?=
 =?utf-8?B?Ymp6QWNhM2ZQRnBaMmhMQWg4LzMxRzc5MEFZYnJLSDhUMUhNOWVSRUhQNVk2?=
 =?utf-8?B?VDFHVzlXK2FUSkZ4S0F0cDFQZk1mZFlvS1hFRXF4TDVqWThCNWY1WlU1TVRZ?=
 =?utf-8?B?bDU4c2NHRnVJTHZva3g5M2tROXRhbU9NRll4RmowOFhiakQxVVhLWjRjaWlN?=
 =?utf-8?B?cXpGL1F3VDEvblYyYm5ITVoyRVlTZEJ6Sm9WMGJMcmU5S0kzRHNXVWVoRWly?=
 =?utf-8?Q?7gd5uWNNRKu/bGlvwFCOUCgvhiF0qY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzdObzR4WXV6c2hQOWttWmNIM0ZHVXZZN1ZIb3V5WE5XMFlrREU3cXJoNGtO?=
 =?utf-8?B?UXVsRlkwV3ZVYUNjMXM0dFMwdUU4LzJzanVNbHROUGUyK0NoaEd3bXlEVW9C?=
 =?utf-8?B?aDZhNjJSMXNpekdEZkhjank0RHgwd0N5T0pJNkMvR0o4cnArSk5YQlA4VFEr?=
 =?utf-8?B?d2dnazBOeDkwcjBnZTRUZ2hsUXdxeHhGMnp0NG8vdHNXS3FLNWMxWG94WjNh?=
 =?utf-8?B?cGdUVFVpZnRmKzMvaDhMSHAwRzJZR1BLWGNVbzBiUkNDNm1PRjRFSWdRUzhI?=
 =?utf-8?B?bVVIUXpIbXpmRXdUNU9GY1BUU3pjVHl1R1RuMnhlSXRNRDJXSGFad1hneUUz?=
 =?utf-8?B?N3NldmIxeTJDVmJyOHJrSjg0VDM4RXE3ZUNBT1plYzZEeFFoTUVPRVBrbE4x?=
 =?utf-8?B?Ti9HZ0xtTjJ1eVJMNmNzcmY5NzZpanoxU21SSWdTbGt0QjZYVHhnWFFWeEpF?=
 =?utf-8?B?MTAvT0ZTdG43ZjVSMk9BYnNzbDByY1lFenpVTWM0SW1CNUNSWm9ISW1EUkxa?=
 =?utf-8?B?QStVa21tNjBFZS9UK21KdVFBVTFRM0R3ZHRUaHUwY3lEYlViRXBRN2RBV1RM?=
 =?utf-8?B?WE1yN1I1dzFkRHNOWmI5RWhia0tJUEdJbnBjVm5kOExwTndWWlcxajhJblZP?=
 =?utf-8?B?Wks2Qm81YWtaMDdPeHd1cS93ZmFHTXZCVVJ5Qjc0M3JSTTJnbXkrcm93eWFm?=
 =?utf-8?B?ZHNwbWdMeVozWnpXKzNqTXNjbXY1K1Z3NU9mN3VycUQya1hnQW5BOFZGejJS?=
 =?utf-8?B?MlNJUllLb0VTaFlqdWVOQ1BHWmhNcVFrWSt4N0htVHo1WkpaSDZJTUN4NU1z?=
 =?utf-8?B?NEUwSEQ1RTBSSFhJZFJxcEhNMnJ5ek1VRXlsSVVuSUdDTTIwRUFaSkNCT05K?=
 =?utf-8?B?Zkl4UnRXSXJCZFE2RzF4VllNcWtuR3BsUDcyYk1MamNpU09vblg4LzRiZ2lR?=
 =?utf-8?B?ZkdGWE5aSFZlS0dwNkQ1MGxuend4YzRFelMzRnoyUVlMcUR2V0NPNXpKRXlq?=
 =?utf-8?B?TnRKZXNyRG81TE90ZHJzR1ZpMXVHNzRmeXZpdVMrKzBpcVZjUDd3Y2pvKzE3?=
 =?utf-8?B?SjcxWWZCbm5qcWsxQ0crVmh4MXowWktLZ2JLek0yanlJYnRRUFNqcEhMT01z?=
 =?utf-8?B?UmNjWlk0YUdybjR3MDUyL21MZ013NjdUOENabWo4dmYrem42OGNFTzN0ejVu?=
 =?utf-8?B?UzljTHQ4M1ZDaUk0Tm9hNU5nb2ZmVkJTT3UwOGd6dDE3dHhVZ1lzTVBvUUNN?=
 =?utf-8?B?Vm1aalJvZEhZaFJiamhCcjRUT21CbTZ0dlMydGtXMUZNVXRDUitFTm53ai9r?=
 =?utf-8?B?cGo4a0c1d0hkTi9XSWVlc2l1Y1RoZ3MreTlnVUVRbytxS2c3MHhuaGI5NHM4?=
 =?utf-8?B?ZVVnby9tOFJPRFY5VTBFVnBKdzdCYUZXSFZBNjBIVFp6T01xVGhCOWljalRJ?=
 =?utf-8?B?VDZrdWNNL0ZJVnZQVWdpTncrcmZseGtyV0E1elRyYjNDR04xNGMrY3ovdDBV?=
 =?utf-8?B?eUtERnRLb2lnam94blZtTklIWDdxN1EzcjdXYzdLZFpLSXltdEZxOWVyTTZ5?=
 =?utf-8?B?Z1Zabkd3V052MTVnM3RBZFhsNlM0RGQ0U21HdGxDaXFLUlVoODZCMkJEVHlq?=
 =?utf-8?B?ekVCd2Fya1JSbjFhU09HcWhlRXZGNk1rdEdMODJjOWY1TkowME9INWJMWE1M?=
 =?utf-8?B?Z2RzU0ZmRHNsdyszM1JCUmc1ejJTdHdTcUk0d2RCTWRkU1ZGMFJ1RGZJR3hY?=
 =?utf-8?B?NnNseTZzTndMdm5JU3ZjNHFyUkFkWmx2YUtPWk9RK3NUR0NiNkY2M1NKN1Jw?=
 =?utf-8?B?ZXdZT1NjcHp6TytETDhaZi9QSTFDVkNoUFdiS09KbnVUbXBDRjVnYTBIeGdV?=
 =?utf-8?B?UFdTRHB5VDRvbVlMWmFNRGVabm12OTkzMEdwZk5oMFVSNEtTZGZENnNIOUlS?=
 =?utf-8?B?eTR5ZjhZMmRTbGo5SWJLcGlkSWlpZnZMclhkNkVvQ09wU014OVU4K0ZueWdm?=
 =?utf-8?B?d05EOU5RR3pzZ1J6OXBuQ1FkSGROeXdaWlNCWHhkRmpvS2RJRUxEN1JyT2po?=
 =?utf-8?B?T29vMFM3UVVGaFEwVzdwY2FmT2hDRW5iai9OSzhsa3lLaUQyWUlwYUlaZDFD?=
 =?utf-8?B?SjA3NHNPRHZiMkR0YmFaS2FjWnJFcFdNUCsxVjhSWis2ZWM5VzIrdGdDUlhD?=
 =?utf-8?B?RUE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 63454b59-b8f6-4c3c-6b6d-08dd9769a638
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 06:43:37.2469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /z1eE/p19qL2O9kEUPKGwiDXvgGXiv9KvTcI7+S6PMIFvJnFMzTZnGqnP+lIZFebzY7Vi+4xwMvJm5rBXhlacluLmZ5p3Dzu1m1fkvcqGlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5919
X-OriginatorOrg: intel.com

PiA+IFllcywgbWVhbmluZyBpcyBkaWZmZXJlbnQsIHNlZSBhYm92ZS4NCj4gDQo+IFNvIHRoYXQn
cyByYXRoZXIgY29udm9sdXRlZDoNCj4gDQo+IAlhdG9taWM2NF9pbmNfbm90X3plcm8oKTogICBy
ZXR1cm5zIDEgb24gc3VjY2Vzc2Z1bCBpbmNyZWFzZSwgMCBvbg0KPiBmYWlsdXJlDQo+ICAgICAg
ICAgc2d4X2luY191c2FnZV9jb3VudCgpOiAgICAgcmV0dXJucyAwIG9uIHN1Y2Nlc3NmdWwgaW5j
cmVhc2UsIDEgb24gZmFpbHVyZQ0KPiAgICAgICAgIHNneF9vcGVuKCk6ICAgICAgICAgICAgICAg
IHJldHVybnMgMCBvbiBzdWNjZXNzZnVsIGluY3JlYXNlLCAtRUJVU1kgb24gZmFpbHVyZQ0KPiAN
Cj4gQ291bGQgd2UgYXQgbGVhc3Qgc3RhbmRhcmRpemUgc2d4X2luY191c2FnZV9jb3VudCgpIG9u
IC1FQlVTWSBpbiB0aGUNCj4gZmFpbHVyZSBjYXNlLCBzbyBpdCdzIGEgbW9yZSBvYnZpb3VzIHBh
dHRlcm46DQo+IA0KPiArICAgICAgIHJldCA9IHNneF9pbmNfdXNhZ2VfY291bnQoKTsNCj4gKyAg
ICAgICBpZiAocmV0IDwgMCkNCj4gKyAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+IA0KDQpZ
ZXMsIHdpbGwgcmV3cml0ZSBhY2NvcmRpbmdseS4gRXNwZWNpYWxseSBzaW5jZSBJIGhhdmUgdG8g
cmV0dXJuIHR3byBkaWZmZXJlbnQNCmVycm9yIGNvZGVzIGludG8gc2d4X29wZW4oKSBub3cgdG8g
aW5kaWNhdGUgZGlmZmVyZW50IG5hdHVyZSBvZiBpc3N1ZXMgd2l0aA0KcnVubmluZyBFVURQQVRF
U1ZOOiB0ZW1wb3JhbCBmYWlsdXJlIGR1ZSB0byBsYWNrIG9mIGVudHJvcHkgKC1FQUdBSU4pDQph
bmQgcG90ZW50aWFsbHkgcGVyc2lzdGVudCBwcm9ibGVtIHdoZW4gZ2V0dGluZyB1bmV4cGVjdGVk
IGVycm9yIGNvZGVzDQooLUVJTykuDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
