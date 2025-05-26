Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4DF145B25;
	Mon, 26 May 2025 23:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748301601; cv=fail; b=RP0bNTUWdJqIBGYv+B2qsbnA2qqqO5QH5wHItrf0cgTCLAynUvtON9aY/7QtZVq8TcJzjCOq2Isdkf8wGNRDj49qzM+bO3xtcoIwN4vFfgqdE7Y9NbCPQswVCpjz1l1x1IZoQHpX7Xwhgbqw4PD4S2BBObWaNVaPUrtWT6hVun0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748301601; c=relaxed/simple;
	bh=WAVHaaJeL2TiyB6KFY5SLESAZgZu1O8Lq006PMbWvyU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M3OfkGl7oYCs7NUCp4m9M5Q1ijX2JVwFQ4AhHHGLXoJkCj3kJHovNL1mHj7yc3Mw6XWju8dSl0CyrwRvjF3qqAlE/skzVUMD1xLFJO5geITcGrpA0xClMqhgeQ/gJgX4igHpjLwClu01Kcz9HvY4ZFDuhzHfUyOe1caO6pcFw+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fdVNMjbI; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fdVNMjbI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748301599; x=1779837599;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WAVHaaJeL2TiyB6KFY5SLESAZgZu1O8Lq006PMbWvyU=;
  b=fdVNMjbIg31vonYdIXJlifh+PGDA8/oP8TN2sknFdcLX7qcR9k9i+zOe
   yTfVE9QtNgTR0BHr53rE5ex67jmobrNsfe8ry09CgF0TrQQ49nceF29s8
   T233PEjvq2D9iDAESBiBeLw75ou+0NLlGgxkCcGFP3YefLpUl0kzm5cSU
   XsGvt/2SIxe6pP/RN9I4W2J0xuaPHqBAJ/Mh6VX7ObBDX5BTJdZX4PK4o
   R1tOlBbWgyguQhd3jFP2hVS3FpZz1P48uemMBdDvKhWSxXh1+t1TUqtwT
   KPqueJ9V1D9sO80TVl4ckvnL+0jJzhraYYZmC6zUrNUiIJAf7XXx6pEvU
   w==;
X-CSE-ConnectionGUID: XDesvmZ5QAWvdgVmzQPkbA==
X-CSE-MsgGUID: of+kalhcRzWrpF6BouGZOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="60906986"
X-IronPort-AV: E=Sophos;i="6.15,316,1739865600"; 
   d="scan'208";a="60906986"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 16:19:59 -0700
X-CSE-ConnectionGUID: oG2WWuQvSSOoGz5bkyYa8w==
X-CSE-MsgGUID: GFERrVz+RZKB0jtPTE5Baw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,316,1739865600"; 
   d="scan'208";a="142550555"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 16:19:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 16:19:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 16:19:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.80)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 16:19:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OT8rHkNENLGlk69UvmcFhyCT3v/2XsiF2nxpZzZ2No/erBuPA0B+dH3eo3fYD+tfjPnWLd6mc6L5uPTlNizcVDd1/F01QFtqXDL3kGVtJlcDjQy6aBigfrfs9gGpzVgtLszJeTcdIcA04McfjXdnxNka21U68paMqpOiht27kk+LqXt1U7KcFAAo+DqeRezElevsYwpLy1P4LpB8otmHNR+5Z/OvoqSBA2Lq0ZDYrYV4PRJoVBvdg8T+O6vCoY5QFUk7rDIO5L44QwcmvyOU1BSHBMw9pxuVolsLOix03+rsyixIfStdMcjt2SXQ33V2xTMU5Tkl3uF2Uz4cA3tlqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WAVHaaJeL2TiyB6KFY5SLESAZgZu1O8Lq006PMbWvyU=;
 b=K5GoDslbHsdUo/Hhr9VoXaO2OweD2du3eVABjHtYu3AL0ANUHoPpSo+SiB0Uvwsz+/E3vzeiQUxmIsQN3pgunmAMJLBhSMLc+1Y3DvgM+zp70Gx6nnNmsh5EMEHW9CRoD1BJfnw/LCZmQkkNnbDtgOWDOUQTOqBhJQ2rKtKrN68txozo9nzUrhg1kRSmKZJL01kHISNRDlxduyY3bBiA4as83CGFw+pNu+n/zoLD5bgiIyfxf1cQ+1bGQBFQ6dFPcC9YKR8M4ZpehubytuYL+Ngo2HUvqRr4Z7XwX91Pykp/iNNTu824CRorNgcNoNWEoPbVTyH/VZl+v3Fz/ivltA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB7948.namprd11.prod.outlook.com (2603:10b6:930:7f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.22; Mon, 26 May
 2025 23:19:53 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.025; Mon, 26 May 2025
 23:19:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "mingo@kernel.org" <mingo@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: Re: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyvsqikasBRxiE0uGzmSkN8xM/rPgX96AgARxbICAAMIYAA==
Date: Mon, 26 May 2025 23:19:53 +0000
Message-ID: <b0b96b9c7445f39c653f5cbea0f808c8bd53cd1a.camel@intel.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
	 <20250522092237.7895-2-elena.reshetova@intel.com>
	 <aDCaH2WAMhLhFAVE@kernel.org>
	 <DM8PR11MB5750056460866A573DBB8603E765A@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750056460866A573DBB8603E765A@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB7948:EE_
x-ms-office365-filtering-correlation-id: 2b33ef9b-0cd5-4a62-a7ef-08dd9cabd1f1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U1ZGTWtXZXV1ckRybjc2d1RVVGxVdHlROUVOM0Jac2ZDcElyYUtKTWRSSUZt?=
 =?utf-8?B?N2xiTkFmSDFHK2NlU0ZISjdDeFBsSnR6UU0vSVlFYW5QTnN2eFFXTDlWYUlU?=
 =?utf-8?B?bzZjUDRNUlVLQ0NWeGNYWmNNVDd3OFduVmRmUThjRDh4eGhMMXBjREVyb2J2?=
 =?utf-8?B?MnF2R01GMmk0UVpiQ3ZscXhYK3UyR3B6T3N6Y0cwaHpKU2lYL1VlWUt4VkJz?=
 =?utf-8?B?cnBkZmcwVnFENys0Z2ZrbXJweDNNajN1d2UxSnBpTXQwMDdNblZ4MFJZMXVX?=
 =?utf-8?B?U29XMWlhR2UzVitXbExEcndwNXhuYmhTSHNJUHJRTmtKd2QrbzhEUCsxaWd2?=
 =?utf-8?B?V0VQMUNNOVpLSVk4R1BKM0xOWUR5aTl5TXBPL0paZVp6TTBNSU5qZlVDcitY?=
 =?utf-8?B?RmZDZ0N6WkNNTUxDU1h2anZLRFFoWW5WTll6THNCYjJWMDRWbkdlemJhRmEr?=
 =?utf-8?B?ak5ZbEpkc3FySUZaZ2d0VDRHQzZRTjRBVjM1YVlmdjBrSjAxYVBSRkxNTDBk?=
 =?utf-8?B?bDhmMk4vQVB4aVBidXVrSncyR1lBaUpqQVkzRHlxVTJBR2d3c1daVkhpWWtC?=
 =?utf-8?B?UVZkNjR5Rm03bFE3R0pTR2ZrbnJpanBRcy8xSWxkOEhWREgrc3VGeUFLL0Nn?=
 =?utf-8?B?aUovL2tjYVRFcUVrMlFDZkhVRGZxNXB5MjZRUHJpMFR3cHl4UVNsVWdJam1o?=
 =?utf-8?B?Nkk1Z1ZROGdPRGJCYVRORDlxSnYrUjNqYUt5dUFxVjZESnBmNGtYdmZ3MFNE?=
 =?utf-8?B?cGdoZUZNWmc4dzVNVEIzVjY2WmtUMFp6VEYxMDc3VWZDN0VINWppek40dnJY?=
 =?utf-8?B?L1lxN3BkclBDVEIvWThlajI1SWZEWEdRRUsrclZNRmFabjNzUDYxMUlhajdB?=
 =?utf-8?B?VVVTeEVkTUpvRW5VSU9SdWpvaDV6VHV2UDUrMGlqSUJaZjVsQ2dLL2huejZk?=
 =?utf-8?B?d1RFeFpZSDdMOStCN29aZnhPSGJtQTdPWkYwM3krQk1tK2ZhSEdUK2Y1K2ZX?=
 =?utf-8?B?Mlk5eXJ3SXRyb0VWeE15bHNRaGx0WjBQU2d0dmhHT2VGRXE0WGRmYWR4YWhX?=
 =?utf-8?B?bk9DREkySDVIeWR2ZHNCajFLNS9kWnljajFVRFVuTitYVHNoSlMyR09WMnhu?=
 =?utf-8?B?eCtVL0hBaEh6ZXFLYXRES2ZyVG01L0JmNTJTaXZMS0lnTHRoaitqdXZQUXlt?=
 =?utf-8?B?dGdxLzAyeHBDQ1QzMjNxS2FjTTA2TndOMm5Sb2ZEN2U2bitKOGZ2b3RLN0FE?=
 =?utf-8?B?ZE00MDRleUtiTVh6Ynh1aSt1bnhYODFVUHRWUnlBMSszVnErZ3VYa2tkRmJU?=
 =?utf-8?B?eWY2Rm8rMnp4NUcwRXlqbUVxSGRSTVlxalJxM1oyWHArSmZtbEdsb0duWWRy?=
 =?utf-8?B?b2V3aCtQVjZDS3VBRFY0bE9CcWo3eFRCUDgwV3BZLzJlb0NGbkdhWVljLy9E?=
 =?utf-8?B?WURPM3VQdEE3SFFqU2lFbzl4L2J1aDNoc2hhdFI5UzJvdWw2MUtsdzVrZHlS?=
 =?utf-8?B?aHExaDZQc3ZQS0ludjdJbnBPM2w5QkRmbFUzVXFhdDVLZkVaMFlkcGxnWnor?=
 =?utf-8?B?VEMrYnVWM3hPYUZESU1VS05wQjJYZkI0TlIrcGZJUWZPY2tuRVo2ajYrN3pL?=
 =?utf-8?B?MGFGZlFGSEVkT1NYcmZOaTVQTkxxSG5aejViR0tBMWpPTmRuLzZvYXZ3bE9E?=
 =?utf-8?B?LzMrbGIzTUFXeXY3NnhScnMwTVE1V3lwcENXcld2NzdwTUR4dnNQQXU5bkFy?=
 =?utf-8?B?Z2NpVVkwbkU4RWV4YjE2S3R4cUdkZnVjc1J5aTJwL2xqazdrZEVKYU14eDlh?=
 =?utf-8?B?d3VmdCtIYjRIOXZjTHllL1NEUngzbGt5ZmlVYWkrMEhTeHpJRzh1M3VkOHRU?=
 =?utf-8?B?QzZqMlh2SkNrVTlWempObkcyNlBWOXRjUjRISFMwWEsyRXlSVndwKzhSRlZK?=
 =?utf-8?B?N1NBT0RXZkptUjVCMHoyekYwWiszMFFoOE5aeGx1Qll3TElQMEdzNHZpNVJ1?=
 =?utf-8?Q?9c8Cp3f9evGSRUgUrRQLKZc0KsXKPI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2hYRzVBOHlGN1dtbzZkclFBelM2MEZmV0hrZUZMU0JPd2JGdW1Nd2pRRVQr?=
 =?utf-8?B?OXc0bCs4UjBlZE55MW8vNWpyVHlTMTRkaWJtTllwQWJZbTdjTXhUeVZJOHRv?=
 =?utf-8?B?L1d1RTdYeVNxbk91bFlwU3VXUG9BZWtKaFJyQnZOWTE3dEZCRmIzbW1sTmRl?=
 =?utf-8?B?ekwwZ0x1VnM2L0JZVGZiZy83MlpwUU03c2srdlcrOGZCZ09YN2M5T21lT2JE?=
 =?utf-8?B?M0V1cG5RSlAwT2tTRTNUSGhKSnZtdTlGSWYvNHBPSG5Kak5zRmNnbS83clNQ?=
 =?utf-8?B?dG5oQ1JEVkVXWkI5bkRRSzMvUFF1d1FIR1IvMHZPdHZVUG1GaXdmR0JoSjJU?=
 =?utf-8?B?cUQ4UWhCa2dOZVhOTVVldnZxN2hxWE1QalVQck13NDJqUUdvUE5ySHlQdW00?=
 =?utf-8?B?d1QvUDFqQXJXcUMzRnk5ZlhwQ3c5c0tBbnUyMXhadk9yTGJBMVpLdTZXNmVS?=
 =?utf-8?B?UUR0THYvTEhTZzRZZUZJd25lenVEZUFRTDhjVjlvTHZmdEVtRUNocHZkUnBF?=
 =?utf-8?B?d3BrVWtQS2toQVF0akVVMUk1b1pibHN6UTFNN1dSb0treHhqVGlwck9tQVFL?=
 =?utf-8?B?emNMRTROUXd1OEl2OFFIY2ZWZXltMk00YTVsaXJuNHFUZFlyYU02UmRRZWxq?=
 =?utf-8?B?aXRQcEpRMWlVdWtMZXp5VVljeWo5TjdOaWVmVmptaVUzSUFVb3pNcXBLeW1o?=
 =?utf-8?B?NGo3aE5kTGxSMTBOUVFCd21RT0h2M2lSdlJFOVFzOG52WVZPTTlxd1NTVXdk?=
 =?utf-8?B?N3lMa2p5dUdaRm4xek5DZXNuMnNIdjNYcVRjUmk2MTUyakZERkdvS3JMM1JV?=
 =?utf-8?B?MUtHay9OdjRHUnVKYTUxZmJyYUJxbVdITGRSKzVXem1uY1RuKzJMZ2xWSU8z?=
 =?utf-8?B?SEptYTR2QUYzby9EeDdXQ2VMajFBTHZDUFZybk9RUHNwa3VyaWYxazRRRStW?=
 =?utf-8?B?OG9iOFlNQTN3ZkQrNXVVSDRvSExMa1ZTeVpaaUNkelVja0lyKzJUWk5Ed2Ru?=
 =?utf-8?B?R09mNi9TTnJNT0pJRDQxeTU4cG5QQVZKa3pUQXorM1dOVWdiR2lKVlcyRTBJ?=
 =?utf-8?B?d0loa1hodGRDTHpsaVdaVUJXTlZVRkg2ZWl4c0lhbGtzUjR3c2dJZE9HaUkw?=
 =?utf-8?B?dWMyU3VKdndOUUx3UVlCd1B6c1A3MVJ0cjRoSXBFMzBtTzVBOFdXVnV2Z1h4?=
 =?utf-8?B?d1FxQjNsZHIyZE1qQmdnUlMwNlN3d01ieTFwMG14aXdGaVZESVM4MXlkeWtG?=
 =?utf-8?B?amZZc1BPa3dVM01IZDdubUd2YmR5SlY3QjFFUUZBb1JzOEVUTFJCL2NNbzZk?=
 =?utf-8?B?WmF4SHNEWTNTYUtnd1krLy8rRTZLTDZiM1hEQlp3T2ZUbXdBYW1haWVyeVh3?=
 =?utf-8?B?WS85M2lDYXhYdDNnbnJqdkFFRTZHMjVRdlJPZXZ3ZEN6M2Uvdzh4eitXZDNr?=
 =?utf-8?B?U3d2aXRkVkJGUnRIekdoelZxaVFNVExVUTZpbzVDRUo3Mlg1T2pGYlFWZW85?=
 =?utf-8?B?QmVRUnVRbzVES05DNnZ0VE84d0tqWWZMYWJvR0V4a3RmRXJkUnY4anBlMnNI?=
 =?utf-8?B?bWgyUmhKWkxkMFViK240cVBzWDdRZ0IvaTVrQ2NFRG4zLzAvNWdma1hZQ1NO?=
 =?utf-8?B?WEs1K2hxT0hsNU1pdzF6T2hETm9RWnF0YitiaE5YR1ZtVjQxMnVRU1ozUWRC?=
 =?utf-8?B?N0xjNUdQcVE5WHEwTjlkY2lCMjJ0dE5SOEROT0dMWk54cWdYT3N6cGczc3BM?=
 =?utf-8?B?KzhzOVJkVnN1RTN6OFV0c0Z4Y2R5S2pqemxQc2tPV1VlM3dZb2ZUR3Z0bW1l?=
 =?utf-8?B?V3FWRDlGMVYxRUUwVnQyQ0RNNjdLWlFKU0VCT3dJdnJwOEt5QjlNd0U2cnp0?=
 =?utf-8?B?VDZaQzIrbUxXNW5zL2IvSDBOVFp3VmlIVVQ1dEdjcGVMM2Z5VkNjVFgwM1l2?=
 =?utf-8?B?Sk9zTVE1OGxGWHZrdkFKWlpMYzl0Tkp1Q1kwYUI3akgvYXNJMjRlK2V6SVM0?=
 =?utf-8?B?Zmp6SU5idlVxSVY5bDRiM0hpbnRjU1d1SWwwcjBTQTFOOTJyZW1yUmZsTS9o?=
 =?utf-8?B?Q1ZCVlZSTEJIaU11YTBPVThrVWZScFpqbmNIWjI2WDdSeThyT0VKUVd1RGtH?=
 =?utf-8?Q?Py9TMZKz2m9WWBdHgJHSJIjgH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02957083275F6B4CB23EC1AB0BD9BE0D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b33ef9b-0cd5-4a62-a7ef-08dd9cabd1f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2025 23:19:53.1922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5IPi2hqxrluOk/qdGBX6LKTfKKjwJPlCoDrqdxOmq5zl17KRlkzAQ7pU/NvueoVyImnt3+5umVEcCwjzfp4NyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7948
X-OriginatorOrg: intel.com

PiANCj4gDQo+ID4gPiAgLyoNCj4gPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC9tYWluLmMNCj4gPiBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiA+ID4g
aW5kZXggMmRlMDFiMzc5YWEzLi5hMDE4YjAxYjg3MzYgMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNo
L3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9j
cHUvc2d4L21haW4uYw0KPiA+ID4gQEAgLTkxNyw2ICs5MTcsMjAgQEAgaW50IHNneF9zZXRfYXR0
cmlidXRlKHVuc2lnbmVkIGxvbmcNCj4gPiAqYWxsb3dlZF9hdHRyaWJ1dGVzLA0KPiA+ID4gIH0N
Cj4gPiA+ICBFWFBPUlRfU1lNQk9MX0dQTChzZ3hfc2V0X2F0dHJpYnV0ZSk7DQo+ID4gPiANCj4g
PiA+ICsvKiBDb3VudGVyIHRvIGNvdW50IHRoZSBhY3RpdmUgU0dYIHVzZXJzICovDQo+ID4gPiAr
c3RhdGljIGF0b21pYzY0X3Qgc2d4X3VzYWdlX2NvdW50Ow0KPiA+ID4gKw0KPiA+ID4gK2ludCBz
Z3hfaW5jX3VzYWdlX2NvdW50KHZvaWQpDQo+ID4gPiArew0KPiA+ID4gKwlhdG9taWM2NF9pbmMo
JnNneF91c2FnZV9jb3VudCk7DQo+ID4gPiArCXJldHVybiAwOw0KPiA+ID4gK30NCj4gPiANCj4g
PiBNYXliZSB0aGlzIHdhcyBkaXNjdXNzZWQgYnV0IHdoeSB0aGlzIGlzIG5vdCBqdXN0IGEgdm9p
ZC1mdW5jdGlvbj8NCj4gDQo+IFRoZSBsYXN0IHBhdGNoIGlzIGNsZWFuZXIgaWYgdGhlIHByb3Rv
dHlwZSBpcyBhbHJlYWR5DQo+IHJldHVybmluZyBpbnQgaGVyZS4gQWxzbyBlcnJvciB1bndpbmRp
bmcgdGFrZXMgdGhpcyBpbnRvIGFjY291bnQNCj4gcmlnaHQgaW4gdGhpcyBwYXRjaC4gRG8geW91
IGhhdmUgb2JqZWN0aW9ucyB0byBsZWF2ZSBpdCBhcyBpdCBpcz8gDQo+IA0KPiANCg0KWW91IGNh
biBjbGFyaWZ5IHRoaXMgaW4gdGhlIGNoYW5nZWxvZyBvZiB0aGlzIHBhdGNoICh3aGljaCBJIGFs
c28gc3VnZ2VzdGVkIGluDQp2NSkuDQo=
