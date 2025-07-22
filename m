Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9BB19F121;
	Tue, 22 Jul 2025 06:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753166770; cv=fail; b=bj1VX7sMmcp9F7kRi3PDGtoLr+IenUWoc6itL/PWBOykEzBL1olfgo2lRiCdPCsJM9gjySSgv/x79IW4RdjEARZ1olwKmHZW3j6F6xEJ9P9mIyJWJ0emu2qb6kTG00NiCdj+QdVd/Edaz/a0tu/OYuOSJm4YC0F/ht54wn37PZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753166770; c=relaxed/simple;
	bh=Vy2uc53Z/1ZFw8cygqqk8/J7Nu+aLeaHQ8oVx6k8acs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ss27W4ofsDmc6BE9o2W4Sup/34LnQRJOdBuyhDr/j09cpbROjbxtX2w2hSqeWsybYaCEdpmsThTxO+9XLzRmOmwAXVA/u0weWfReV0vwSsnzLYnzVczPQ1JvfYS+8Tbyb8wi1TMMTNB295pvFaynDkHTqG5EYX8nr+atrxDm1jE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MNC3Iyy+; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MNC3Iyy+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753166770; x=1784702770;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Vy2uc53Z/1ZFw8cygqqk8/J7Nu+aLeaHQ8oVx6k8acs=;
  b=MNC3Iyy+6jEwdKQlpxWmjbdNB8JT1+0zYnBv3JJ9L/0ECf+T6OF+22KY
   wEW+1bXed18FONOoPZQB0mp1/uoch+UFN9pRmevXqqmX7pgQe2ntisXa6
   Se/FhABGwFyEslAu2789MhmftGZp31QEpU2aqoDWXSp+tFWk1GnxBvrVY
   kJ5FLiYyeCyT9Vak7D4kVwYfjtnTcHyZgW+EeZyrAmd7ZxrebBawYhtgB
   BLFQcfqg2YtIiKEk8eAKKzzTGfH0IIeegxyvIv0aQwja+BSfRknu0MJy+
   IPig2v9QAvlpyEc52G2k1LE2uo1n84U9ZmcWAqmyw7UsHQtPb6Cw0byg2
   g==;
X-CSE-ConnectionGUID: NSOgD4BQTry+HjLULMGHGQ==
X-CSE-MsgGUID: W2luQK6jSoCXayHM29JYqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="77940609"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="77940609"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 23:46:09 -0700
X-CSE-ConnectionGUID: nAGo1ot7T+qn9reIcic9rg==
X-CSE-MsgGUID: 2Ewad8LMRcac4yPcNlooQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="163599831"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 23:46:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 23:46:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 23:46:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.88)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 23:46:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=di5atf7pe7wXtXAvaXGaQ3T8m6Fd8ezgtq0Qb1frC+qj/kdcEEE7aBF3Gfwkk0kJ/arLMHHDLVop9d5W6Bu6TKT+65+OCgmMWQL22esjWCRLHFr67SsWETW5yfynO55AoQImxe/wXh4Pvy8olxn9SBECIoouNmKrxm11YY6NYpP+A6rIAiQTAvH9y6mGjqonuqBzJefVNSALDScCMcYxB4czsp1Nrky8+wO4pKm8fqQneW3vQv+3wo4dAepw6iYZgpHuyPBLn7QqBQj/ZDo3y5wo6CKOTht9XpKPdq5gpYdTmuJ3dSUA7MagLG0IfGvxvvr2KkOh8NEqgR41xb9Alw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vy2uc53Z/1ZFw8cygqqk8/J7Nu+aLeaHQ8oVx6k8acs=;
 b=EfSsMpxwkU9t6KOAtyIgMatqJKMyNJVPnG2gLQS+Dd+WV7hgteWwhX/LpsjE1Fjg2uYZdsgLC9GG64+E65EbGu1tLzWyFVZe+BvDK17cJOprjx03wb6h4SzPZ2fGZXQ7nxNycNnaoFxCToktwPnK27Z0/R8q3V7N5e105/Q8/hSn1yhPQQTWKnGIkpcPTUc+Ep9Bg7Yx1ekhSmYESbxl0vhAXkBQR7ImjkOcBEzB7Uw6ohPd6dnOwzzVsy5X4wl7P58hn6U5CbenwcjqfKtBTUxFvZGoOE5UiSc7i1x9FpZ1AEiRWSXeZSUIdkFZI11Od8u0BK5BqikSJ9uy+tELDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH3PPF4324011F4.namprd11.prod.outlook.com (2603:10b6:518:1::d1a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 06:46:03 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8901.030; Tue, 22 Jul 2025
 06:46:03 +0000
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
Subject: RE: [PATCH v8 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v8 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHb9YXOeXiSjPmR0Umx33SqxEWh9rQ801aAgADp7tA=
Date: Tue, 22 Jul 2025 06:46:02 +0000
Message-ID: <DM8PR11MB57509E1BD459582ADF8CC132E75CA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250715124109.1711717-1-elena.reshetova@intel.com>
 <20250715124109.1711717-2-elena.reshetova@intel.com>
 <4838ad3b-af1c-481b-acb9-9c33943a018b@intel.com>
In-Reply-To: <4838ad3b-af1c-481b-acb9-9c33943a018b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH3PPF4324011F4:EE_
x-ms-office365-filtering-correlation-id: 7b9f9197-937c-4c36-3b08-08ddc8eb6d27
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TjZ4UTRXWnU2RFZ4UWQybGpTd0JUWTQxb0VHSlVWdEtVNlNBRzFud081M25Z?=
 =?utf-8?B?alFYQ3JwWjZ3NFZ6ZzlVOFM5S2RYRWJYK0tOMGZFbGZzSlh4eHVGYUJQdWRm?=
 =?utf-8?B?b05MOEt4VE1sSXFBMVBvQy93VHlBVS9UM2RZTjN5Zm9PNGtwenNUZ0ZnSVFO?=
 =?utf-8?B?ZFRxeVNpbUdFRGdYZFNCbXNHRDYxL2d3YnM3QWlaWDN3UGlReGZ4V3RpeTZs?=
 =?utf-8?B?cjBBNWRVdENUTm9QUStEUHhRR25GaE1tWUoycDk2dlVFVnhLeHpQU0l1c2I3?=
 =?utf-8?B?dHVYaDIxYUJEczRaMHBaMVFacEpteVkzRDdXL0xSWVNlK1o3YkNpUUw5elFL?=
 =?utf-8?B?VlJJUEdqSVZJeVB0d2M3TzhHSlI0TWFaSEpuUko5bzZ1YTQvcGZQZlhvcTVw?=
 =?utf-8?B?ZW9XdjVYeW1aWmhQSmxYZDZyd3pyMmhBcWJNV0VkU1FYSWlRdEk3V1lXdXhv?=
 =?utf-8?B?aSs2cURVWHM4VHFKZ21WejUvTk0xdVl0WkpVL1RXUE5vZkFjWitzdUxMN0k4?=
 =?utf-8?B?RktkL3RVUVRSL255dHhpUFFiNHZpbnU4aUxNY3VVOUt6a3o3QWFoV1JWTjcw?=
 =?utf-8?B?RVdIMWpvTVMxS29NdEFVRWpyVXlvRmt5QzU3OGQzNGdKKzVkYSt3OEh3dzNy?=
 =?utf-8?B?aS9CRnRyWGh3YzVZcjI0NXFlOTlIMjJrTlY0bGdGTFRWT3dkbW1JRWxieHNP?=
 =?utf-8?B?dDRaV2RuU3pLL3VPZjNIRW9jK2xHREd1bFNzU3ptR1ZZaUcyRXZzNWhRVERG?=
 =?utf-8?B?Ynd0eXh5WHJ0UUZvRHBUUDZBUEEyTkZ2NjAwbTV3eWRlRldSYStxNWlzR2dW?=
 =?utf-8?B?WnBCM1BoeU1iQXNieUNMRW02K3Q0c2NmTGY0KzNYSnJLZlNiK3RGejZ3TXNo?=
 =?utf-8?B?dXVHMGhWd3pKcmlFTEVqKzhUOUtpalZhWFFxMU9RaERwc0prbDl3TzhXT0M5?=
 =?utf-8?B?SjFmWkptdXF2TXAzeUdncVhZVi9iS1NIcHN1TXp4STJ5MC9ER0VBY3R1eGF5?=
 =?utf-8?B?Nmo5cE9rMC9SSTZ6OFBybmpNNzZDeG1lZWN1c2I1VjdnMk02KzlWdDVxbjla?=
 =?utf-8?B?TzdPcmt6S0E5V2J3RUl5dzgrbW5VaUoxZis1UVFpb0ZCcVhCa3dhS1IzRFFy?=
 =?utf-8?B?SEVINlpuQ245akNPMzJBSkFJYXpwV2dWblN5WFB2UG5LYnZDWGlKeTB1QVdm?=
 =?utf-8?B?YU9ZSzgvNitCV1d5ZDNqOEVYNFA5bGNFUjRZTHEzS3FRM1daWCtWMUNkTmx2?=
 =?utf-8?B?K1lXR1lnY3JYNjZHTzU3Z1RXZmpOOCtORmZtNTdISDNCeDlCck1IRnZPN2x1?=
 =?utf-8?B?Vm5TUm8yUWZqT0liTmNKRWs4U3c4OWprRit2bzY5azhDSEhUdmtOKzE3WS9E?=
 =?utf-8?B?bHh0N2tTeHJrNVVaYUl1S1NMNmdPaHJlN2xYVERZSlBxdEFPZzNMZURWWFN0?=
 =?utf-8?B?VVFvZFh0SmdFdVJLWkFBUXNUSERpRk5POGNQZ0tVanZBU1BKVkQ2QU00VDRE?=
 =?utf-8?B?aFVQQlN3NDBhdlhpQm4xdXY5WlVHbHJ5dWhiVjZLNi95bkdVbU9NOUV0RFg3?=
 =?utf-8?B?T1hOYUt3bFVHcENJNE9UNXlZdnVhNVpnQ2hGRW5YcXBFWXdTd1lYZlNnYjFx?=
 =?utf-8?B?SURBdlpTd2pKcWE5eFpDZ0lMU0EvdWpja3RzUkY0RG5wOHdiWlRsZWt3L1lv?=
 =?utf-8?B?czVnS3RVZkZ4ZTB6eFV2ZkUvV0pxM2djUCs0RTZBTWlZWVAwckpkczlpcG9G?=
 =?utf-8?B?bE1ZTlRPSUNoZ3hVNFk1bFZmY0p0OEx3Szl2STlVeWpOb2xtSm5uaHcxdWhi?=
 =?utf-8?B?TmkyU1RRY2cyNWJ6ZEUrQmxxaHJwWkROank2RjBIVVhuemw0cXdXWUU4Y3M4?=
 =?utf-8?B?cXJWdjNzYTNuVWFad1JldFlENEx5RGUwZVVRY3FESU54VTR4OVVnS0p0Vk9L?=
 =?utf-8?B?bUI2Z1BPcFZrREQvaE1LbEZpb3g5ckFSZ1lkNzh3b2dOZW92TjdHV28rOWtZ?=
 =?utf-8?B?aEhUK3d6SHRRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXBtazFibTg3amhQSnBpdFN1VTdFcU9KTjRvVjZqOVh1TlVyRXV2Vm1ialFG?=
 =?utf-8?B?UXRIOVR3ek5WQ1VxbGduUDhUM1BGSTh2ejBBUGdCRU9IcmRHbHRTNWZ1bVdT?=
 =?utf-8?B?ajVMUWE4TTNlM2NQTVVrTmRvUFU0cWN4OUJUKzFvR1lpWWFTWThieXM4Sk45?=
 =?utf-8?B?VDZQNEdkOGRWMnQvSmZHRnpHNWZiVXdBZFVVdWlCK0lFUWhvcGRiUGJGQjI4?=
 =?utf-8?B?YVdudDAxd29WRUl6TkYwcWdIK3VxTEVuVldiZGc4dklKMjI2SFJ0UHJBaGNK?=
 =?utf-8?B?TmFLY2dNM2R4QmtFZWVrR1B3UkhOQVk3RDQ0RnUxV0dRdUVHZ0pGSmZPaGQz?=
 =?utf-8?B?RmhSMnljOHFTTjNFQU54LzBVR1ZjWEMrVjNtWUpURDZtaFZVTldncWN1SUQv?=
 =?utf-8?B?ZERLT3dnNXlQSVZVYzlFK0JzeEQ5ckppa3hOUFVxZjlyWUEzbEtsREduZE9q?=
 =?utf-8?B?K0ExWFhuYnZoTlVhbzNCb2RXeVlTc3ZtN1J2L2tHVnFXblkyeEpYUGJGZW1F?=
 =?utf-8?B?RjRTSC9uK1pUWldqYThRZXloSk1nRW1BMzRQeERiYmMxVTgyeHNWWm1tYjhj?=
 =?utf-8?B?eS9HYnJUbXVNUEx1OGZZS3RMc3o2QnltSlR1b3VrQm8zYjFmdTNWUDFoNzV2?=
 =?utf-8?B?dUdNTk5GVE9OZjcvRHoyb2gxcFVhN2E3Zzgyc1pOUlVKejkvTy9RcGZ6MkZq?=
 =?utf-8?B?dzA4ajFtYUlkdlNQMmE1bkh6dlU2MTRlaDJ6TWd3dU9WM0NwQlM2UDRSaDYr?=
 =?utf-8?B?ZThxRmFvVHdTOWtsUHRXSUltT2lqaGJwOHVsdFUvdkRsc2Rpek5wdkZkcitE?=
 =?utf-8?B?UmdrL3l5VWFCeFdXekQzZFNvc3hXMjNUK0JhckI2Wi9Xam1EREo5V2tlR2Vr?=
 =?utf-8?B?S3NuTEU4YjIxampabnZJazllNXZNR1BaWTRPYkZOQjROekpXSytUOGcyaFJa?=
 =?utf-8?B?NDBCQThqbjhPSlhhc3BYRHpQalhIS00ySE9HSTZQUHRGbE1FSDdTT1kzS3pL?=
 =?utf-8?B?bFB1M3A3alV2SlJDSXJTcHFndjMvK1A4V3JUdVFSVFEwVU1IY0RkZ1BhcjFX?=
 =?utf-8?B?cldheWh2WDkrQk1HQVdZK2h6eDNyVW14U281TkNrSW80c3FYdENwVFBiK2xx?=
 =?utf-8?B?d0pSSE42NzArU1dJcTVZS0R3QUsrcnRMSmE3bUJEZXVjYVA5dnh4Tml5RVdl?=
 =?utf-8?B?ZklZMnNrTVZPYWF1S09lTUxoY1c2M2FEKzZsM0w2UHFkSnl2ZytycUxRZkNz?=
 =?utf-8?B?ZjhTeXdHT3pqbTRJRTNkOEpybHRXWElUZFhBekdSZlZ5RFBIcnJWNUVEeEg2?=
 =?utf-8?B?OGU1ekVybU45SHhpYnNmQnFXdmVaSTJSVXJ4dXc0V2JEWWdQWisySWR2WTZr?=
 =?utf-8?B?VWo3TWJJcWRBZzdlMk9RSEhxcWZQSXFRM3hpcDZReGRkME5PbCtqMWF1WVAy?=
 =?utf-8?B?M2VTRjcyYXg3NU84dmRWb1o1Q1VlelRJc0hiUW8wc3lkNTl4RTVyYm5EcUEy?=
 =?utf-8?B?YU9NYXBCTFVNaXAxUGl4ZkVwNGRjc2dYNDJ3TUczS1ZpUERIR0VCeEY0WWNk?=
 =?utf-8?B?WUhETHRDTURtSXZaL3hJVUF2bzRoZm8xMUVGeFFOZCs2WTlOTEphdTdDTm5Q?=
 =?utf-8?B?Rk4rbU9wNG1UNFNNRnFCWEQ3aHhsQ1h1SzhpWDJTTjY4RDg2bTFLS2pBVDgr?=
 =?utf-8?B?UGg3RGI4bEMxdFNaUVJ2d2pTNGJSWHBEN0VPRXlZMW0yWXpzUUl1M1BqYng2?=
 =?utf-8?B?Y2JFRFlEenA3Q3FoNUEzQzBUTG43Z3IwZ09aeitLN1FYclVqaHRXTy9xK2Yz?=
 =?utf-8?B?ZjYxU3h5eUlsSXphYllnblltcVpwVk5ybDd4a1Bpd1MxdGpYRlJlcnBwMXFp?=
 =?utf-8?B?b05MUkg0eVFhakRzeUlkWmhsOEV0NlkrWXcycGJPMS9INTFsdTVCNHlTK3FT?=
 =?utf-8?B?RitpVmtxbWlPNTJiT1lVWXAxMEc0N29Td1U2NG9UWUZ2cy9PVzg0U3NLS1VX?=
 =?utf-8?B?RzEyZVF3eWhJZEMxNVREVGtoaDhsOHE1eVdVVXZBRUtOKzJ6RzlwSDg0a3U0?=
 =?utf-8?B?MHJVWUF4VTA2OXNTTnJmQ3NGZ2FNdWZ4cGZkTzEvV0x0QnphSUU0bzFSeGZP?=
 =?utf-8?B?c2tUejdxaDMzMUN3emJJTERlNDh6RXVycmdvU0M4c3ozN0xmWSthTkkwK0t0?=
 =?utf-8?B?YkE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9f9197-937c-4c36-3b08-08ddc8eb6d27
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2025 06:46:03.0048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EXciZHkmoBX7L/vq7vARjUz0dJ3FcG0KbMEthUMpB/uLIKyhTbWrr0/a9VFOQutzmqH+JDCSJxhBdsiqNhVDbA2sN8P+qDI6CZBee+OggPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF4324011F4
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIYW5zZW4sIERhdmUgPGRhdmUu
aGFuc2VuQGludGVsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBKdWx5IDIxLCAyMDI1IDc6NDggUE0N
Cj4gVG86IFJlc2hldG92YSwgRWxlbmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQo+IENj
OiBqYXJra29Aa2VybmVsLm9yZzsgc2VhbmpjQGdvb2dsZS5jb207IEh1YW5nLCBLYWkNCj4gPGth
aS5odWFuZ0BpbnRlbC5jb20+OyBtaW5nb0BrZXJuZWwub3JnOyBsaW51eC1zZ3hAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZzsgeDg2QGtlcm5lbC5vcmc7
IE1hbGxpY2ssIEFzaXQgSw0KPiA8YXNpdC5rLm1hbGxpY2tAaW50ZWwuY29tPjsgU2NhcmxhdGEs
IFZpbmNlbnQgUiA8dmluY2VudC5yLnNjYXJsYXRhQGludGVsLmNvbT47DQo+IENhaSwgQ2hvbmcg
PGNob25nY0Bnb29nbGUuY29tPjsgQWt0YXMsIEVyZGVtIDxlcmRlbWFrdGFzQGdvb2dsZS5jb20+
Ow0KPiBBbm5hcHVydmUsIFZpc2hhbCA8dmFubmFwdXJ2ZUBnb29nbGUuY29tPjsgQm9uZGFyZXZz
a2EsIE5hdGFsaWlhDQo+IDxib25kYXJuQGdvb2dsZS5jb20+OyBSYXlub3IsIFNjb3R0IDxzY290
dC5yYXlub3JAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY4IDEvNV0geDg2L3Nn
eDogSW50cm9kdWNlIGEgY291bnRlciB0byBjb3VudCB0aGUNCj4gc2d4Xyh2ZXBjXylvcGVuKCkN
Cj4gDQo+IE9uIDcvMTUvMjUgMDU6NDAsIEVsZW5hIFJlc2hldG92YSB3cm90ZToNCj4gPiAraW50
IHNneF9pbmNfdXNhZ2VfY291bnQodm9pZCkNCj4gPiArew0KPiA+ICsJc2d4X3VzYWdlX2NvdW50
Kys7DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArdm9pZCBzZ3hfZGVjX3Vz
YWdlX2NvdW50KHZvaWQpDQo+ID4gK3sNCj4gPiArCXNneF91c2FnZV9jb3VudC0tOw0KPiA+ICt9
DQo+IA0KPiBHYWguDQo+IA0KPiBJIGtub3cgdGhpcyBnZXRzIGZpeGVkIHVwIGxhdGVyIGluIHRo
ZSBzZXJpZXMgd2l0aCB0aGUgbXV0ZXgsIGJ1dCB0aGlzDQo+IGNvZGUgaXMgYnJva2VuIGFuZCBy
YWN5IHVudGlsIHRoYXQgcG9pbnQuDQo+IA0KPiBJJ2QgcmF0aGVyIHRoaXMgZG8gX25vdGhpbmdf
Og0KPiANCj4gCWludCBzZ3hfaW5jX3VzYWdlX2NvdW50KHZvaWQpDQo+IAl7DQo+IAkJcmV0dXJu
IDA7DQo+IAl9DQo+IA0KPiB0aGFuIGEgZm9vKysgd2hpY2gganVzdCBwbGFpbiBkb2Vzbid0IHdv
cmsuDQoNClN1cmUsIEkgY2FuIGZpeCBpdCBhbHNvIGluIHY5LiANCg0KQmVzdCBSZWdhcmRzLA0K
RWxlbmEuDQo=
