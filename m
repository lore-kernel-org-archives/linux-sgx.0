Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B6828A1CB;
	Tue, 22 Jul 2025 06:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753166712; cv=fail; b=ncvpq2cK6JJAi1NXlCQSHa0DfsJ75NNLI4b6hNijLtu8CZiM3D+PSf/08bGxBWmVYaSGrsZV3CHUcfsG8AU495wSfmv9crYoQPFxKaUY7CviSVb+qC3YFutTTROm3pCeBwYJQ7/QQw2eee+NQ5aoPqqUiaCSwFSEGLRe9aT4De0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753166712; c=relaxed/simple;
	bh=B/JQF+wwtheU3jCkv4ZHjQTZubA+PigdvMcq5pg3298=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BABaqDatXp9pCRnrtj4qp1s86SEU9vtOEx2V7Ni3hYrtZ5W8ep7/gfTuhyhGw8U3kfn90eg5iYwOhDKf7jN6hZVXNPqgmDrOQzsLrP2KmvatGJf97Qn7Cv4+poRHwppkDxpCVicc9iUkaiLjQyIHThTks9zA1BzUKjjHT1Wc0qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i5cTNaVt; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i5cTNaVt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753166711; x=1784702711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B/JQF+wwtheU3jCkv4ZHjQTZubA+PigdvMcq5pg3298=;
  b=i5cTNaVt1P4yz7U6VAgfb7LfnUcfxigH8jdNpzkQoND7pq0xrvEYPgSY
   sMmngqyLsvhKS66AO5Lv3QzwljjXJh246G4DPpqgDAAr8X0iVGHUJQl81
   SL20dyLb0RE6vBftnlBrnG4mK6+4ZrF1WiHDk2r2kq6loFZKKY2E+6unO
   YxG4jg7tO1d+/xuOrxbBicaC1LftznMyL92h4nusmTkE0/287vGHCK3Uo
   XElnQOO/yLeKWb7PC23CUMqcIt3bK5cwTMIzwVIm5DBNAZ/Mw9RhPeSg1
   YU1Vyf9BVEQPQNKkkafv0pkhrUJRK2/bednGs8Z34Nq1MCuQR0soDTJi4
   g==;
X-CSE-ConnectionGUID: ssbHvX21TCSGgXGs8dAQ8A==
X-CSE-MsgGUID: ge4jbM8PSHyH9rcMPME4Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55360758"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="55360758"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 23:45:11 -0700
X-CSE-ConnectionGUID: /rQ++Nq6TaOIzsJ/7slWzQ==
X-CSE-MsgGUID: IDfo2DG9T5KnmrbQ0wHcbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="159366793"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 23:45:10 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 23:45:09 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 23:45:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.74)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 23:45:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A5f5d8whlhcJHfRrnnYazqEdaO6hxmWFV36zkaNSLRry+LRwsuWk4JiK07wFP5C0FgwDDNXhRK7cbQNCC9Kd2n8gzI+qGXifJmeZ8II3GZCbJWdlW9u71MGiH4g7k5pKCbuvSLLchyJwBWJZTCI91WVbpzAdECH7uSX8KwVLdsxPlWDg6Q8R2/SJYryEGL82a4bbpPAQwH5/2ZqcSGxWO+vV1DsX/PpSitUD/sZgn8eQhViUmU/LiQGMxzL0q9RbXpPTxSFtr9VHlTYdfzFZ17HXfN4cvc/70LfAR5wpb1oYqXOg3DGQoh7kJNDRPS3vsV0nR90FMNKitjjYJeELPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B/JQF+wwtheU3jCkv4ZHjQTZubA+PigdvMcq5pg3298=;
 b=IPIke3hBS2MUnEuUZRO/3W0GHhAc8bwJv3KQxnq50TCV9QTsX2EwH/35dIMIG+Rz/yfjY1h61arJsMA5aTnPQ94yJY5I+SB4KuDHPcSRFAyWo6VGjmv7vnCiiGOC6i6nybj3s7vouSnM8Gg+99rXgWt3crSRHOrxfd3Xo+0JzMncayzWBrm0cZtZ6BZR874dy+vmQdjZZdqqf9Abs7hb266EBTmzamEIA6/hZLFqY5vR3arGKNajTj4eRrb+be2M6XLn3JxC21uvVxdZ4gf5R1Mbe/HaQmqKzAaxdRxfE2qzhtcipKLuZOo+7iP2+x4f+QwH+pX6azMM3Yi2IE3EdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH3PPF4324011F4.namprd11.prod.outlook.com (2603:10b6:518:1::d1a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 06:45:04 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8901.030; Tue, 22 Jul 2025
 06:45:03 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v8 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v8 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHb9YXOeXiSjPmR0Umx33SqxEWh9rQ5UcMAgAADygCABGcBwA==
Date: Tue, 22 Jul 2025 06:45:03 +0000
Message-ID: <DM8PR11MB57500C83B0C612C026D1965DE75CA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250715124109.1711717-1-elena.reshetova@intel.com>
 <20250715124109.1711717-2-elena.reshetova@intel.com>
 <aHt-RLfgVM-HfTh_@kernel.org> <aHuBctErYserfuce@kernel.org>
In-Reply-To: <aHuBctErYserfuce@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH3PPF4324011F4:EE_
x-ms-office365-filtering-correlation-id: 931fe29b-0f30-4553-e4f5-08ddc8eb499c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TjFwNzNwT2pYaS9MRTVRZk85ZURqN0UwQjF6cmJPZ3JYVlNib2NMOFhEZEd6?=
 =?utf-8?B?VHFrSDNubjlRYnl5aWlLNkdrdHBacHErTWQwdHAzY01aK0w4YzN3b0tKbjBo?=
 =?utf-8?B?Q2tmYWtVRzJiWFFDUjR0ZlhxQTZjNDAwUm9SNTUrRkxlcmc3ZEFqNlBpMi94?=
 =?utf-8?B?VlQxREQ3aFFjMUJQcStyTVc5UDAyVXRkRVdJQlRZRXY1cFRXN0wxSzRVTXRO?=
 =?utf-8?B?VnJ6OURHMlFPVjIycVlMM3kwNXNpTk5aSXRDWWhVck1ubWhFSklNL05lZlRC?=
 =?utf-8?B?a3JtWTg1N29jb2Vvd2ozZ0YyRFZGTnNvM2xWU3pFUG1ra3E3d1RGZzJqZjRn?=
 =?utf-8?B?T3luM0dwcXB5cFVMankzc1haVzdmcGZLbzFMc0J5bThKRmdDaGR0OHdNemZF?=
 =?utf-8?B?bHo3eXRGYzBQbEZPdmZodGxMNm9GWCs0NzhwTGsrWjJ6VDA0NDI5ZHJpU2lL?=
 =?utf-8?B?b0tvdWdXYndoQmY5SGFEY1FDVlVFcE1td3YvMERUd3pPck1KVy8vWW1Rc2Ja?=
 =?utf-8?B?SXhydlovT1lRVEdLbVFEYU9JZVh4a1JUcHkvQlBqOTgyWDk3U0JNQnRyWWFj?=
 =?utf-8?B?dkVwVytkMDViRG4wemdyRUJVb0NLWU9EUzd0bFVBZzV5OStqZFdTS2QydDRh?=
 =?utf-8?B?bm42YnNpVndTalFRUnRkbWFoS1JFc0NDUUhQdloxNldRMGFxOEwyL1ZycEpY?=
 =?utf-8?B?Y0Y3aE4xK1FPbmw3bWorbFlEYXVMOHlnMENERWw1RVNSK3RneU93aVE4Rm5G?=
 =?utf-8?B?b3E1UmpyekI3MVBIalU3SEdYaDJsaXdaZDMwZzA5Mjhxb2tLb0l2OXU0VTR3?=
 =?utf-8?B?ci9NOCtvcGVrVGJXN241bUt2OXJJN29XSUhuUTB5dXFSbXpaMFcxNUppeENp?=
 =?utf-8?B?em5IMEJyNUZsVitsWXRnTzFRTWd3NlRhVjRRdzFVRE5oelVObHArcGVITEND?=
 =?utf-8?B?UUF0dG9EeTFPMUNpcE5HSVh5bUVtTGRNbHc0VXpRVGg0anBvenIzTm9uKzc3?=
 =?utf-8?B?ZlZ5ZG9FUzdwdzNEYkp4VGNoSjAycnl0bDJGYlcrNnhObDJlbmsrL0tOZkZG?=
 =?utf-8?B?Y240VHdRY1FCekJzcE1rdmRmYyt1ZngyQ0VPa2kxMXladlFJTHc3MjVycWQw?=
 =?utf-8?B?a3lyMjM2MUlKTk1wQm1pR0U0dHdzbjFkN1IvaGxDcnFVNkgrbHlFYWc1NE5s?=
 =?utf-8?B?dzhuUTBQdkJDYlFxSmtpM2JUZUtuYU5wK3N5b2RWOUJhK2Q2ZTFZclFkQUZ0?=
 =?utf-8?B?K1NCLzlVYUR3U2VsWFlMSGdwMW92dkZRdHY0TnhxU3NFaFd6SzRGUzY0bkp5?=
 =?utf-8?B?VG54dlpJNWZKQ0VaQSs0bjl5UzMrem9VZGtJaXlSSXEvMThWenFLYVZtZlNU?=
 =?utf-8?B?a2Fsck5kMndnc01PNmMzZlp2LzB4TWZQSHVjaENoVjJ2Z2V4WFNzMWZyMno5?=
 =?utf-8?B?Q2J6cDdJdFlwL1A4UkI4M0VGWUR2L1ZiTm5EYllsOUdmbW1YQXI5YTAyM0M1?=
 =?utf-8?B?MzBUWjBma2FqaWh0alBkbEtlSGZIbE1oZDVkSjh5bmxtSUVROHRiMStzRkE0?=
 =?utf-8?B?cnFwZUd5bHFBbU84c1NWMmxiYThxNjBkOE9EZVFaTDg3Tm5RMEhadlhaTTVQ?=
 =?utf-8?B?cXNTcjB4OWVVS2Vqd0FDUDg2MTErVFJFTHAyYlpwZm9tamRkdFB5WWZPOWxv?=
 =?utf-8?B?Z1hxQlRMTTA5Q1ptOUJPWlFpL2VqNVpZWGJLUFdwUkhwbGkzdUxwQnU1VEtU?=
 =?utf-8?B?NkdseDkyUmlMbWo4Q29jem4wY05ubVZ1dFAveWgwTmdORGFtYlRQc1BDYVVx?=
 =?utf-8?B?ZVRDVytoUjZlNGZORVFTdDVvVmJ4UEk1Ry8vWG40ek5wSVd4YzNqTFhZbitG?=
 =?utf-8?B?RStZVTlwc29DUEdPQ0hwNHpZWndlSHhDRzVJUXIrMTNrRldEQ3I4ZnRxS3ZD?=
 =?utf-8?B?YVJ5amR2Rnc0ZTBtL0V4YXBZam1obGd2OGw2Qkl4b2V6MzhPcnRLRVNuYS8v?=
 =?utf-8?Q?FO/rv+WdVJGBiX3v7FT+vX42FeD5Gg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MldBUmpTUC9ibE12aHlFOVNsMUJDRDQ5cGJ3ZndkbHR1SXhSYlo2dVdwaVYz?=
 =?utf-8?B?L1pKWmZ0Q0VHSnl2K1ljaUlXRGpjdUNHQmljd1Y2RDZEWkhLUk9uVGdzWEJY?=
 =?utf-8?B?UC9WSjVuWXpLUWp4TzIxSUhEaHNFK3pqRmwyTGFTem56YTJUOEdyQWNRTWh5?=
 =?utf-8?B?am9KSVRPa0ozZEs4TUtTZi84dVJDMjJsUXJQTndnR0JDWFB0aGhtSnhOSU9C?=
 =?utf-8?B?YU9oMlJOVkRabmRFZTlyc2xEbnJ6ZWJta0U0bFdZVXpqQmxuQmhMMVlXRVRM?=
 =?utf-8?B?dUYrSDVlYUVXbWpqUEZ0S3h5MWxtUnMwck5jekRERDNUVjJmVUh1YXRqcDlz?=
 =?utf-8?B?aURPVTdveHR4c3djY25aanU2alQxQ2NweVlGa3pjb3RoeVJ0Nzd6ZDNCZ3dz?=
 =?utf-8?B?NmovTklqS2taN04xaWk2ODQzZnRRUXpZWCs0b2t6WE81cjdZa0JOczVWUnAy?=
 =?utf-8?B?QkxyTjZzeGQ4V0x2bFljMEVyMFVUbGZVbHBJdy9rbmpGL1B4Vm1kdVVGaHNs?=
 =?utf-8?B?ZjRXTmJoRyt5VDEwSVBTTUxKR0tWS0l3T1NXV1N5TWlrdVZ1aXhQbkJJNVFz?=
 =?utf-8?B?RFN0Sk4veEVRQVNNWjQyb000S0NYU1NiMVFJRFlzWlpCL3dFYm9ydDduR09w?=
 =?utf-8?B?WnJJY24zb1ZhaEhsQmZWeDhycW9YZzhQd0FmOU5xUEpKdHdyWGluVmpMck4v?=
 =?utf-8?B?WE00dUxHRktReHNTU2w5eFY1S29Ka2Z1NFVhUGlDVDFOSmVLWk9qbE5rdmxt?=
 =?utf-8?B?amVsR0UyRGhsZDQvK0FQM0NKQ2JRbmdQQTUxQXY3aWcraHFuVDR1di9zT29G?=
 =?utf-8?B?U2xkWUpNRllybkRmYlQralB6V3ZTQ2xuNXhHcHNnTnhGZ2llZXB3RkZvYjAw?=
 =?utf-8?B?eFhnVXJMaWQ4MkxYVXFFdFZJcDdpeUFEdFJiSDdGT0xXTjM5NXVMdUZ6SlBP?=
 =?utf-8?B?c0tGWGZtZ1c3MmtSVHBEZXIxdnNCMjVyVlpDbXR6cTJ3RGhKdlNicEN1R2tL?=
 =?utf-8?B?cSt3dEpOSVVSc1NnTFkrSFpMZElHTFdma2I0Q0RjK2FYdW01V0RjWkJrYnox?=
 =?utf-8?B?aUMzQUQxL2diMUZ4TUtUZTNkNEpTSFVRR3ozWk5jY2xwZzdHNS9sRnVMV3dS?=
 =?utf-8?B?Q09XY28yVmlTQ2lyMHhKNi82TSs5SGRyT0xaQ1FRejBNbHVWOFFrdVZyTnk1?=
 =?utf-8?B?R1Z4NDZkc3ROS2N1bTdRYlM5QWhaaFBXWkt2b0lybG5ZYkhXY2RlOEF2RjhX?=
 =?utf-8?B?cmRURGVmRWwvS3Q1Rm94Z0d6NCtwZzVjMGRybXp2djBCdU0rY2VRZ1hCZG1V?=
 =?utf-8?B?dmdVWlRuWlZmcDl5RXFQTUFVZ2EzR0czSWRvbHVEZmhFVnhqRDRLMjFPai80?=
 =?utf-8?B?aG5VK0I5SGVqdjBOb2FUeUc5Y0tOWlgxVEp6aGt0YjNhaWg1M2FhczZUUEJ0?=
 =?utf-8?B?a1dDMUFPRG13WEw0Q1dORUVxU2FIUnBUMHpycHVxcDc1NWY0QllPR1lNc1N4?=
 =?utf-8?B?Ui9vSGhCamFwczhwS0JQRFBZNXBOR1lBVUhMaFdKeDNOcVRKZFhkU0x4RE9Y?=
 =?utf-8?B?S2k2ejdkK25nb25ZOHpXZndGM3BiQmxvUkd3dG5pYjdlTXdLdDMxYko2WXlC?=
 =?utf-8?B?TXk0emRXa2FhMFdxT2x5WmhzUGhuN2FZUjdQblFXZTBQeVY1SVFJeVdzK3J0?=
 =?utf-8?B?VXFsYXJFemhhd1NXWVp0anlueFdKUUtZNHV6S0dpZlU1YmpUN2dWQzR5cENQ?=
 =?utf-8?B?S21XanBuT1dhU2ZDcVVwaTFrK0p0bllhanJNNG5MQlI3b2hNb3QwOWNLc2ho?=
 =?utf-8?B?eE9malkzTCtHTG9sZ2lORlMzWGx3QmNON2FaTlJZK1Z2cFdONXRVMmlwNUFR?=
 =?utf-8?B?UUtaRFdOZlBieGZGR0pEZ01vNy90V3Zrby8zYkpCRjVXYm9PRnZMVkJiUEt0?=
 =?utf-8?B?RnVNcytZRWU4R2VsRGFhc2p1YlkxdnRIRTArUmRnVDR0N0N0eE0zMDJRZ1dP?=
 =?utf-8?B?U2dJV1pyNTlwclZpODhrZEF4UmZYN3QyZytTK0ZISEtDZFNYNmdZNHRzNVNH?=
 =?utf-8?B?SVl3Uy9rcVMzRVRVQlZmaDRRZ1k5WW1KRHU0cUQ5ekszL2hHaXNnZU9GaEVU?=
 =?utf-8?B?K08rTnpQSlVkcFlZZVpON1ZOb3NXVmhEOTRDZ2xzazh1czh3YjhPenVQNmJP?=
 =?utf-8?B?dWc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 931fe29b-0f30-4553-e4f5-08ddc8eb499c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2025 06:45:03.4317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JJziIfih8VvlJ/m5Pds4dAYQn+lx7SgA8dtMYKE5J6mnn1SWs4MI9dS0Jo0mEeJ+UlJG6lfFT86VNmBrMV+SHuODW/JH8Y4E/URQm6xHXpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF4324011F4
X-OriginatorOrg: intel.com

PiANCj4gT24gU2F0LCBKdWwgMTksIDIwMjUgYXQgMDI6MTU6MTZQTSArMDMwMCwgSmFya2tvIFNh
a2tpbmVuIHdyb3RlOg0KPiA+IE9uIFR1ZSwgSnVsIDE1LCAyMDI1IGF0IDAzOjQwOjE4UE0gKzAz
MDAsIEVsZW5hIFJlc2hldG92YSB3cm90ZToNCj4gPiA+IEN1cnJlbnRseSBTR1ggZG9lcyBub3Qg
aGF2ZSBhIGdsb2JhbCBjb3VudGVyIHRvIGNvdW50IHRoZQ0KPiA+ID4gYWN0aXZlIHVzZXJzIGZy
b20gdXNlcnNwYWNlIG9yIGh5cGVydmlzb3IuIEltcGxlbWVudCBzdWNoIGEgY291bnRlciwNCj4g
PiA+IHNneF91c2FnZV9jb3VudC4gSXQgd2lsbCBiZSB1c2VkIGJ5IHRoZSBkcml2ZXIgd2hlbiBh
dHRlbXB0aW5nDQo+ID4gPiB0byBjYWxsIEVVUERBVEVTVk4gU0dYIGluc3RydWN0aW9uLg0KPiA+
DQouLi4NCj4gPiBUaGlzIGlzIGVzc2VudGlhbGx5IGEgd3JhcHBlciBvdmVyIHByZS1leGlzdGlu
ZyBmdW5jdGlvbi4gSSB2b3RlIGZvcg0KPiA+IHJlbmFtaW5nIHRoZSBwcmUtZXhpc3RpbmcgZnVu
Y3Rpb24gYXMgX19zZ3hfdmVwY19vcGVuKCkgYW5kIGFkZCB0aGVuIGENCj4gPiBuZXcgZnVuY3Rp
b24gY2FsbGluZyBpdDoNCj4gPg0KPiA+IHN0YXRpYyBpbnQgc2d4X3ZlcGNfb3BlbihzdHJ1Y3Qg
aW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gPiB7DQo+ID4gCWludCByZXQ7DQo+
ID4NCj4gPiAJcmV0ID0gc2d4X2luY191c2FnZV9jb3VudCgpOw0KPiA+IAlpZiAocmV0KQ0KPiA+
IAkJcmV0dXJuIHJldDsNCj4gPg0KPiA+IAlyZXQgPSAgX19zZ3hfdmVwY19vcGVuKGlub2RlLCBm
aWxlKTsNCj4gPiAJaWYgKHJldCkgew0KPiA+IAkJc2d4X2RlY191c2FnZV9jb3VudCgpOw0KPiA+
IAkJcmV0dXJuIHJldDsNCj4gPiAJfQ0KPiA+DQo+ID4gCXJldHVybiAwOw0KPiA+IH0NCj4gPg0K
PiA+IEkgdGhpbmsgdGhpcyBhIGZhY3RvciBiZXR0ZXIgc3RhbmRpbmcgcG9pbnQgYWxzbyB3aGVu
IGhhdmluZyB0byBkaWcNCj4gPiBpbnRvIHRoaXMgbGF0ZXIgb24gKGVhc2llciB0byBzZWUgdGhl
IGJpZyBwaWN0dXJlKSBhcyBpdCBoYXMgY2xlYXINCj4gPiBzcGxpdCBvZiByZXNwb25zaWJpbGl0
aWVzOg0KPiA+DQo+ID4gMS4gdG9wIGxheWVyIG1hbmFnZXMgdG8gdXNhZ2UgY291bnQNCj4gPiAy
LiBsb3dlciBsYXllciBhbGxvY2F0ZXMgdmVwYyBzdHJ1Y3R1cmVzICh3aGljaCBoYXMgbm90aGlu
ZyB0byBkbw0KPiA+ICAgIHdpdGggdGhlIGxvZ2ljIG9mIHRoZSB1c2FnZSBjb3VudCkuDQo+ID4N
Cj4gPiBUaGlzIGNvbW1lbnQgYXBwbGllcyBhbHNvIHRvIHNneF9vcGVuKCkuDQo+IA0KPiBJJ2Qg
YWxzbyBzcGxpdCB0aGlzIGludG8gdHdvIHBhdGNoZXMgKHRob3NlIGFyZSBub3Qgc3VnZ2VzdGlv
bnMgZm9yDQo+IHNob3J0IHN1bW1hcmllcyBqdXN0IHNheWluZyk6DQo+IA0KPiBQYXRjaCAjMTog
UmVuYW1lIHtzZ3hfb3BlbigpLHNneF92ZXBjX29wZW4oKX0gYXMNCj4ge19fc2d4X29wZW4sX19z
Z3hfdmVwY19vcGVufQ0KPiBQYXRjaCAjMjogQWRkIGEgbmV3IGZ1bmN0aW9uIGNhbGxlZCB7c2d4
X29wZW4oKSxzZ3hfdmVwY19vcGVuKCl9IGFuZCBmaXh1cA0KPiB0aGUgY2FsbCBzaXRlcy4NCg0K
U3VyZSwgSSB3aWxsIHRlc3QgYW5kIHN1Ym1pdCB0aGUgdjkgbmV4dCB3aXRoIHRoZXNlIGNoYW5n
ZXMuIA0KDQo+IA0KPiBUaGlzIGlzIG5vdCBzaW1pbGFyIHNjZW5hcmlvIGFzIHRoZSBvbmUgSSB3
YXMgY29tcGxhaW5pbmcgd2l0aCA0LzUNCj4gYW5kIDUvNSBiZWNhdXNlIHNlY29uZCBwYXRjaCBh
ZGRzIG5ldyBmdW5jdGlvbnMsIHdoaWNoIGp1c3QgaGF2ZQ0KPiBuYW1lcyB0aGF0IHdlcmUgdXNl
ZCBmb3IgZGlmZmVyZW50IHB1cnBvc2UgaW4gdGhlIHBhc3QgKGp1c3QNCj4gc2F5aW5nIGJlY2F1
c2UgdGhvdWdodCB0aGlzIHN1Z2dlc3Rpb24gbWlnaHQgc291ZG4gb3RoZXJ3aXNlDQo+IHNvbWVo
b3cgY29udHJhZGljdG9yeSkuDQoNClRoYW5rIHlvdSBmb3IgZWxhYm9yYXRpbmcsIHllcywgSSB1
bmRlcnN0YW5kIGl0IGlzIGRpZmZlcmVudCBidXQNCkRhdmUgaGFzIGEgZGlmZmVyZW50IG9waW5p
b24gdGhlcmUsIHNvIEkgYW0gbm90IHN1cmUgd2hpY2ggd2F5IHRvDQp0YWtlLiBXaWxsIHdhaXQg
dW50aWwgeW91ciBkaXNjdXNzaW9uIHdpdGggRGF2ZSBjb21wbGV0ZXMgb24gdGhpcyBvbmUuIA0K
DQpCZXN0IFJlZ2FyZHMsDQpFbGVuYQ0K
