Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CB3263F2D;
	Thu, 24 Jul 2025 10:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753352701; cv=fail; b=EzbYriV6FYEUPy4COXTxlNi66Wzyl2AJZXQmXQP6LjcGQLEVKJtGU9POFFCRP/UHbkeFYsUDIx5imr6YWk3sfihh6b245c7+ZmwJMXC7ouhm9hTugoL9p7fp3SxN04Kq4RZNeDLfkw3J/KG84Y3kSUKmbqI3iJCeSoJKl9fexcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753352701; c=relaxed/simple;
	bh=RBogmUQQWDuV5UQ6kiV3PRwcSsClN+IcWqwDhAqPNWM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lduO5yD7CAAVL5UytDGOkLtOWcy9g/22TWY9L9d75V5r9W54hlOU7+XZK0QxrEZkl/PDHYQb++ymexm8k+jPsge6bCKjpA+orh8KRo89V1gwjvtVenZNna+GzsFMcZPweyW1b+5ASxHe4rx6BS+JHk5inLuQE82JucqM08yDIL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D4Da8zWl; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D4Da8zWl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753352700; x=1784888700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RBogmUQQWDuV5UQ6kiV3PRwcSsClN+IcWqwDhAqPNWM=;
  b=D4Da8zWl1ZtNGgfyFA2cIE0u4LvGibkN5b3p6Eb6Wdqtee/LyDyjuUof
   5i3x7gt8gW6M2VpUCQBCv8wPC7Lgkeioz8M/g4Q5Boy7h4jpwJIP7ssEX
   ZVjQkCJaaxrpGUB8awvFplElbiiRJaVLaJhthrogk6J+/uhjShtPfBdmw
   a29meZ3qzB7GX524F1Ev9aDGOLgf3bzarGttaGBHcZ1/yRsFNbpSA8HmU
   zVqNr776flHlmmC0phJVsUEOQ4cSK0tk0Cqt2buihc1/KEmYK5399ugXd
   Lj3eOu7yDQa5karU/ZDmvcERzEEezMCbJByWKeLbKJnhMnYyrGum74aJT
   A==;
X-CSE-ConnectionGUID: Yf0Fb68dQVyzn4xCNnExgg==
X-CSE-MsgGUID: AxtGWhq7RjqX9ZuMik3s5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55807863"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="55807863"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 03:24:59 -0700
X-CSE-ConnectionGUID: TfLeEROARcqn/NbcZJNyyQ==
X-CSE-MsgGUID: eqnw1v1aRWOavzBSdZ2WCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="191080031"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 03:24:59 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 03:24:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 03:24:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.66)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 03:24:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YD5x2NkV+9xwRDPrF6C2kGkVyPNiG9n5hZadIMwHyV24nVN99WaMcoksFNsxXrzNBIKt+L5yncJIkqYZJP0QXDt79eXT+XB7HESSVlNsEMdcmciBmt2mftQsWJ5oWFipW1aUBIKO7jBzQUuBrrigCAyDfpRq0Ld8vYsejEgqN+IFPAsE7OdMSuvQ54NGpGAr0D/lPjEWCfH3x/r4xmycq0PZko+VEuQvCC57kxe3Dlue5L7SQ2zQrEwjqxr0w/snOfGOKiWfB/taaIU7LALpnwV0oU10SYfq+OLB0uTuVE3iVaoz2nzEF8srCNJoM6c9fMEfX8Kx6f955sEAhgDF9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBogmUQQWDuV5UQ6kiV3PRwcSsClN+IcWqwDhAqPNWM=;
 b=MdaQiP6TXEJaDaTg8MpyzVFsaKsr2lQgkCa208ydQKOYLZs+KEVli/OL1m8uK/S0TTudje9OEr/CViUgmzrn7ZGQ9lk2Z5pfuDXNd/lIw9BdQr0iF7Utw+f6nH4mOt+L6s2KUGDNALxO1vshAx6ezXSlBGNmOD0IuFdzb6OOIM7oTfkpqiq03H1HOYjFdRSXAPnC4SthjmIQ7rdTOB5lMaowG8Cuowv0P0zWSczBu767BhXLfrFO0xZQ0jU+3E2+qT4h9BIMrKytWcOfXmfF2QYRjQeubz0QnHYkRCSEA3tG3NfuOxH4j9DULaDqKWD0b+TxeOzukpUhYGzxjn0CZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB6890.namprd11.prod.outlook.com (2603:10b6:930:5d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Thu, 24 Jul
 2025 10:24:53 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 10:24:52 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v9 2/6] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v9 2/6] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHb/HF+HrcxE90R10qOEE11tN8nYbRBEXoA
Date: Thu, 24 Jul 2025 10:24:52 +0000
Message-ID: <83553a7287b495326a2f923afd3f6aec9cabd69e.camel@intel.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
	 <20250724080313.605676-3-elena.reshetova@intel.com>
In-Reply-To: <20250724080313.605676-3-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB6890:EE_
x-ms-office365-filtering-correlation-id: 53dcd04e-8669-4223-85a9-08ddca9c53ec
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VnRXOFM5V1g4QVVaSllVZUZnNWF3T1FMcFZRczZWYnFGaUN5SnJ4MFlOOVVs?=
 =?utf-8?B?T2VHL3Z2ZklWTml4ZnJxQVJKZXMwbDlqN1d4VW92dlFMa0pMb0pvQ0VpdlI2?=
 =?utf-8?B?UDJzWEVBc2cwWW11RVR2MHNKYUh4MWNHZlJ0UHNibHFYVEgyWDV2VGZzZDhr?=
 =?utf-8?B?aG0xSEx3ekxRL28yZ0c2amhndGVGbjhST0dWeFFjL2phMGJpSVdFNzFpRHlz?=
 =?utf-8?B?alJPV2szdVhSUEpFYWNSV0RqNTJqYUM5WlczTXFabUQzeUZyMVhjRnJjaEdZ?=
 =?utf-8?B?amJlZUtxeVVTNlUyL25NVnlpSnUvenJDTjBUbTFwNFkxb2ZWOWw3VDVSY1Yr?=
 =?utf-8?B?OHVqV3VCTStKS2JMRStvZnZScEZEd213QlgwUC9WZit4MTNjUEtPWlo2TmZq?=
 =?utf-8?B?dWdzQkNDQUlxakpLL3FaRG5iVXBwdWk5eWRMVno3YnZ5SHRFc0prb0doOW1W?=
 =?utf-8?B?RWJFR2NTSXVpMjVlV2tMOWNVeFNHME1hcTFmeGRsbE4vdEpJc3g0OWNlSWNV?=
 =?utf-8?B?Y2tTYUpjbStQTFhFbWRQemlRSlBhWUZMOGEyUVBSS1dRamlHRDArL3o4Q0ZO?=
 =?utf-8?B?TEdFb0ZQSTRUdDYvWk1TN0lFTXFOSWlLcy9HN3BvSU5Oak52akpLZitBU3Ny?=
 =?utf-8?B?S0I5Si8wNGhVK2QvMGNBYmQ4T3pMNmZiSmcwanR2OGRTWVIxaGxKbnZVbjd6?=
 =?utf-8?B?aUNlaTdoSkRrVmFaOVV6U20xdkpFY0pLSE93Vnkzbmk1c1ZTZmpHRm5NdUJw?=
 =?utf-8?B?dlB3dkYwZEl0NU9EYllWSVJOM2FhSmNsUmp0ZXlaRFFSbEl1dm1nRytNQ0dH?=
 =?utf-8?B?MFNnTlFaUmNHc2YrUnBXZUpXZS93YmpMdTlYSGNaYmVVc3hSK0xVdjlodHl5?=
 =?utf-8?B?djhTTVVIVHVBOFpDcytoYXdBWHdISlkwa0xwcHlSU25NQlphUE9kWHN0RUhx?=
 =?utf-8?B?Ykk3cGU0THRQRWp5N2VkMEdsZzM1SmZEZE0xVnBpTGMxNWhBbFFPeS9sbCtI?=
 =?utf-8?B?SnhNYnpKaE5Zd0Z5UXI3dW03LzVXV0ZlWGM5bEt3K2tONEZudytsYnVkTHdL?=
 =?utf-8?B?YWRLOTV2dWkyMXR2NmlIUER1QUtxc1BGaXp1MUdlRkY2UnVEV3hiU2pZc0dl?=
 =?utf-8?B?R1d2TXk4Y0QralZIenI5NW9RcENTTDZ1RmdqY0NqdDhWbytua3Z1dFNLTUhD?=
 =?utf-8?B?ZnFRQ3lITVVES1JlNWNZYWdaa3dxS1lQUkhwMXAwZFhoTVZUNkxWd2J3bUM1?=
 =?utf-8?B?UlFkZzdoUm9LR2pTZCsyWUlJRTBqSG0vUDF6ZFZXNkt4VS93Q0tFNkVqT0Zr?=
 =?utf-8?B?TUx2Sm1sRXN6aUtVWXEra3o0MzdzWmhLL05FNzJmVktIZ3piTGptYW9LaThY?=
 =?utf-8?B?YUowdkl4aUJhbTBEM2w2aitaQnd2MllDdGY1Q21EMThIbFBXeFdmUG9ka0dT?=
 =?utf-8?B?dFduMWQ1dEYvaFNxRm81TVlQR2J4aFFsTXVqaUltRU14MXRiUURCTlZ6YUdy?=
 =?utf-8?B?Ti8wQ3NUUUhIa3dLblFGcStNekV1ejhBMFg5MlkxVldMeDFwa0FQeUlzNU1H?=
 =?utf-8?B?RHdqZVhaN0hKUGlPcjFtQWxnSHJCclU3d3RlWEx1YkRzbGk5bnNhK1NjdTMr?=
 =?utf-8?B?MklUTXFRbVRPNTBWcWRiT2NPRWQ4Q1F1SGdjNFAzbnpBYlJZV21aZ1dTNTk2?=
 =?utf-8?B?UWZQeTZLOXhQdkF1dHJWR1RuWVFOSDN5WWkyZTh2V3JHTmc3OEZVbmp3OFRu?=
 =?utf-8?B?U0FiUVhlVFA4U1JGMytkd2wzb1dhOENrWEVaT282OE1GdmtuV3hDQlZCYVgr?=
 =?utf-8?B?WEtDNi9RVjhOdGhxQSs2aFA4TDlWdEJNSmtBMjBxWXNnZVhhdXM2L09VeG0w?=
 =?utf-8?B?TkpkNzRoK2J5bHFaOU9GYnJWcEp5b2FUMWZZNHZoTzhEUlcxdWJ6dFVRaEQr?=
 =?utf-8?B?ZFpPSGlzMGVmQTkxVkwwMEVEOVkrSWdSeEZhd2h5dVNRS3k3a0hBaGhtOFVH?=
 =?utf-8?Q?7k/KBnu6V7tJozI2+EH5C62KIxQHTs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWxlVjdEdGJETWhiQUEzQmYwSnIwNmZtQUJmR1FUQ05DbVhvOGkzSERtT1ky?=
 =?utf-8?B?TG9ham1QZWdpR2lqZVI1YjNOR2xLMFY2L21uQzA1V0hlYWpaQmZNeXJ4L2cy?=
 =?utf-8?B?ZHJLR0ZsRml5OE1nMEhPaERCTERnNlR5ZFU5NFBIdlFlUkp0U3ZIdThMWmNE?=
 =?utf-8?B?SEVoRm53dTlKSHBsQlpXcEMxVHNtUUsrRFI2NnR5TjJPYlRoNzlKOTJlRW1s?=
 =?utf-8?B?WkFUOVJnMmc2elduSEE2QUxIUnpTajJPbDF1cXcwZzRPWDV2Z0ZvTGRFTVJ4?=
 =?utf-8?B?b0JOOStLaWdENlIzQWEwWFBHRFg0c29iZXR1NWZUbjlBcmFtT096bHNJbTY0?=
 =?utf-8?B?L0lkaXlROTBocnU0eEN1bjV3aDliblJKb211Zm95Vi9XTTl4aVBIRS90Y3Y1?=
 =?utf-8?B?KzQvNG9NV2JiZWZ0dDVsNGgxNmE5YW1NUldZWWw5cWZkVE9tcDlLN3VwTk5p?=
 =?utf-8?B?QVBWZ2NVdGlubFkwMmZFVGgrb2hTS2p0S1ozMTFBKy9lODFUOTJqVlpvYkJu?=
 =?utf-8?B?RVBLUkhraUxkQU5aUU9KeEZHRWFFeVVod1k3cVpTeHlCNXJDcWZicXdldzMv?=
 =?utf-8?B?cGRNL29HbkZRWlRwZjhEQk5UUCtpbDMyTkxMV3JreXFsdXZ0aXhJMCt2V0Uv?=
 =?utf-8?B?UDB0WHNjRnRLbGNTaHBLbVQ5ZVZESHQyUlNMaGVkTHFYa1F3OUJKRUhUanhm?=
 =?utf-8?B?Q1RjQkJsTHMwYlo2UXNIN1YrRHlCY3ZkSFNSNDBJK21mWmU1bDBaVTFnYllv?=
 =?utf-8?B?Rk5UTldxaE4rTGFjWE8ya1U4cWpsb2V3NE9EcE95emtFMTVYUHBqaTBveDdS?=
 =?utf-8?B?N1V0d2NRcFpLM2htU2FNQ3duSWU5UVFZbVdzZ3h1dUcvN1lMT3ZnTGxtSzFx?=
 =?utf-8?B?aFcxZk9nUzlDblowamxxNXhSQUYwb0dsSi9uQjJIV2V2K0QzOERCb3VrV2U0?=
 =?utf-8?B?aTRITTdKWkxCLzU1dWdnR2IzWW8rc1ZDNlo5WTNXQVB2RVFMemNVUDM0RlRt?=
 =?utf-8?B?NWZ6WlB5V2k0c1J4Y2VYZmpCRUZqN2ZrNkRsb2dMM3hURVJLaXpTQ0xSeCsw?=
 =?utf-8?B?S294K1pGbHBmbFhyUnZ4N2hscUpWdnpXZU9PbnJDcXVFYTF2WlRoYlVtQTU5?=
 =?utf-8?B?M21ycm5reFNZQXVsUUxYQmpuWStFSkNtb3VRWEFvMC82eUJyaWlETUFzY0xU?=
 =?utf-8?B?SnBjRVc0YmFSVUpheDhnQ3k0aHN0aktLMGM4TUpqTzljNVQ3Uk8zWEErRWZT?=
 =?utf-8?B?T3NtQ1VTNkNacmpmUWNlSmMwaVFNdzc4UzlLUno3eVpOSC9XTnp1dFlzVFVx?=
 =?utf-8?B?alpNcC91VlM2dTRHeTBQNVYwTXpPdEtPeHRYZnVXY3AwNDhIL0pjVDZpNjFx?=
 =?utf-8?B?b1hZSW5HMU90eHJaQXR4NWZxczNJazhidjN3ejJnZlJ6T2M3cUsrNVVJZ1N5?=
 =?utf-8?B?NjhGNEJjcURkN2I0dDczajJUeWdLdlNubEo3L2JOaE4zRlJuUXB0TkpHcGFG?=
 =?utf-8?B?ZDNVTllzNFdkV0JYU3JrTEJpaUdISlNNVkZCdktwZjMyd3RWd2pMKzUwcTFU?=
 =?utf-8?B?V0R2d2FiM29peWd1NXF2cVFEcEdUeCtqOUlUM1JDQUNIMWVnTFlYM2FlTDF0?=
 =?utf-8?B?ODZMZHhMNmN5SzJETkpLZnBwb0xneTdJYTNRNjdISU9wNC9naEphcG54QlRX?=
 =?utf-8?B?Y2V2SmFlUEx5S29DM0ppV0RiRnZ4ZVhreVFwem1MQnhTZVhkeGVaNnM0YmtL?=
 =?utf-8?B?d2hmWG1vdnYvVTNjU0orY001aXN3VkxuNmpjc0tVTm0vRlhjeXBzZ3h6WUtN?=
 =?utf-8?B?VkFDTEkrSnIvcE9pcktiYzlWMmR0KzNyZTNVSmQrK1JFOWNXZm9lL2MrejF5?=
 =?utf-8?B?WE4razFianNrVVdrNXhBRU1qVW5FWGZ1c1ZvaXd4a0lDcVhEZk9HUXNvcXlz?=
 =?utf-8?B?MDU0L3Q1alpmeWpMNWZsL05xZk4yS29JbWVTTDBhVWV1RVA0WDhNbVl3dlh4?=
 =?utf-8?B?MzBqcTBRVWhFWmYwWHM4VUZrd0gxK1NscGZXQlhnN2Ryb3NYZFFhMkVacDBS?=
 =?utf-8?B?bjZabnliTEJKalhxYmd0SlVIZzlKeHRGT0JEYVdMc3BJWGRUem9admQxSmRO?=
 =?utf-8?Q?E8eOrv0yykQ3BUm1ZcZHRF4Zx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A268CB45997B8A41A5855F7A8363C33C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53dcd04e-8669-4223-85a9-08ddca9c53ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 10:24:52.8106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J3/td1C+QkKob+ZbpR0HvbbXMWY8J/napv8Q4fM4YPvOuMERt7Z2fsBeua1elSwGPcR6TwjapRP4Y0JvaNPRpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6890
X-OriginatorOrg: intel.com

DQo+ICANCj4gK3N0YXRpYyBpbnQgc2d4X29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0
IGZpbGUgKmZpbGUpDQo+ICt7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCXJldCA9IHNneF9pbmNf
dXNhZ2VfY291bnQoKTsNCj4gKwlpZiAocmV0KQ0KPiArCQlyZXR1cm4gcmV0Ow0KPiArDQo+ICsJ
cmV0ID0gX19zZ3hfb3Blbihpbm9kZSwgZmlsZSk7DQo+ICsJaWYgKHJldCkgew0KPiArCQlzZ3hf
ZGVjX3VzYWdlX2NvdW50KCk7DQo+ICsJCXJldHVybiByZXQ7DQo+ICsJfQ0KPiArDQo+ICsJcmV0
dXJuIDA7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBpbnQgc2d4X3JlbGVhc2Uoc3RydWN0IGlub2Rl
ICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpDQo+ICB7DQo+ICAJc3RydWN0IHNneF9lbmNsICpl
bmNsID0gZmlsZS0+cHJpdmF0ZV9kYXRhOw0KPiBAQCAtMTI2LDcgKzE0Myw3IEBAIHN0YXRpYyBs
b25nIHNneF9jb21wYXRfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25lZCBpbnQgY21k
LA0KPiAgDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBzZ3hfZW5jbF9m
b3BzID0gew0KPiAgCS5vd25lcgkJCT0gVEhJU19NT0RVTEUsDQo+IC0JLm9wZW4JCQk9IF9fc2d4
X29wZW4sDQo+ICsJLm9wZW4JCQk9IHNneF9vcGVuLA0KDQpJZiB5b3UgbWVyZ2UgdGhlIGZpcnN0
IHBhdGNoIHRvIHRoaXMgb25lLCB5b3UgY2FuIGF2b2lkIHN1Y2ggY2h1bmsgaW4gdGhlDQpkaWZm
Lg0KDQpJbiBmYWN0LCBJIHRoaW5rIG1lcmdpbmcgdGhlIGZpcnN0IHBhdGNoIHRvIHRoaXMgb25l
IG1ha2VzIHNlbnNlIGJlY2F1c2UNCl9fc2d4X29wZW4oKSBvbmx5IG1ha2VzIHNlbnNlIHdoZW4g
eW91IGhhdmUgc2d4X2luY191c2FnZV9jb3VudCgpLg0KDQpbLi4uXQ0KDQo+ICANCj4gKy8qIENv
dW50ZXIgdG8gY291bnQgdGhlIGFjdGl2ZSBTR1ggdXNlcnMgKi8NCj4gK3N0YXRpYyBpbnQgX19t
YXliZV91bnVzZWQgc2d4X3VzYWdlX2NvdW50Ow0KDQpBcyByZXBsaWVkIHRvIHRoZSBwYXRjaCA2
LCBJIHRoaW5rIHlvdSBjYW4ganVzdCBpbnRyb2R1Y2UgdGhpcyB2YXJpYWJsZSBpbg0KdGhhdCBw
YXRjaC4NCg0KPiArDQo+ICtpbnQgc2d4X2luY191c2FnZV9jb3VudCh2b2lkKQ0KPiArew0KPiAr
CXJldHVybiAwOw0KPiArfQ0KPiArDQo+ICt2b2lkIHNneF9kZWNfdXNhZ2VfY291bnQodm9pZCkN
Cj4gK3sNCj4gKwlyZXR1cm47DQo+ICt9DQo+ICsNCj4gDQoNClsuLi5dDQoNCj4gQEAgLTI2NSw2
ICsyNjYsNyBAQCBzdGF0aWMgaW50IF9fc2d4X3ZlcGNfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2Rl
LCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gIAl2ZXBjID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IHNn
eF92ZXBjKSwgR0ZQX0tFUk5FTCk7DQo+ICAJaWYgKCF2ZXBjKQ0KPiAgCQlyZXR1cm4gLUVOT01F
TTsNCj4gKw0KDQpVbmludGVuZGVkIGNoYW5nZT8NCg0KPiAgCW11dGV4X2luaXQoJnZlcGMtPmxv
Y2spOw0KPiAgCXhhX2luaXQoJnZlcGMtPnBhZ2VfYXJyYXkpOw0KPiAgDQo+IEBAIC0yNzMsNiAr
Mjc1LDIzIEBAIHN0YXRpYyBpbnQgX19zZ3hfdmVwY19vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUs
IHN0cnVjdCBmaWxlICpmaWxlKQ0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMg
aW50IHNneF92ZXBjX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUp
DQo+ICt7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCXJldCA9IHNneF9pbmNfdXNhZ2VfY291bnQo
KTsNCj4gKwlpZiAocmV0KQ0KPiArCQlyZXR1cm4gcmV0Ow0KPiArDQo+ICsJcmV0ID0gIF9fc2d4
X3ZlcGNfb3Blbihpbm9kZSwgZmlsZSk7DQo+ICsJaWYgKHJldCkgew0KPiArCQlzZ3hfZGVjX3Vz
YWdlX2NvdW50KCk7DQo+ICsJCXJldHVybiByZXQ7DQo+ICsJfQ0KPiArDQo+ICsJcmV0dXJuIDA7
DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBsb25nIHNneF92ZXBjX2lvY3RsKHN0cnVjdCBmaWxlICpm
aWxlLA0KPiAgCQkJICAgdW5zaWduZWQgaW50IGNtZCwgdW5zaWduZWQgbG9uZyBhcmcpDQo+ICB7
DQo+IEBAIC0yOTEsNyArMzEwLDcgQEAgc3RhdGljIGxvbmcgc2d4X3ZlcGNfaW9jdGwoc3RydWN0
IGZpbGUgKmZpbGUsDQo+ICANCj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25z
IHNneF92ZXBjX2ZvcHMgPSB7DQo+ICAJLm93bmVyCQk9IFRISVNfTU9EVUxFLA0KPiAtCS5vcGVu
CQk9IF9fc2d4X3ZlcGNfb3BlbiwNCj4gKwkub3BlbgkJPSBzZ3hfdmVwY19vcGVuLA0KDQpEaXR0
byB0byBzZ3hfb3BlbigpLg0K
