Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC0E2D0C9F;
	Thu, 24 Jul 2025 12:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753361311; cv=fail; b=EYx2a0gWWhoYF0mztjivXm//zwl04uQ77PqesbrBNGyLR6emb3P8kxcmgN2A1N3JI6O6X6emTj7EW1YQiD8GIW7An6sR7mzm8IHqmH3OAl28V0YQt50TeMkbyb3goLOY+U9FAoqRy3hTPGM/jlsW4ndK3tDfN2We9FGCosuioNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753361311; c=relaxed/simple;
	bh=0jJlUruOEH5U6wp0LjrHpo7rb9Oh27vKOwvAWGr+quY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cAXE58P6B+5hJ+u08hsBSgMQQwwYsrET+N6CQGByat04oIVEBL/5DYda/BETX1xWWnNey4H0kJUoK5sRHN8ZAc8f8ylbbJra35Hng9AGrY2rZZeQ4gs46+/Y33EcsAv5s8dzV5mK7/2GHhEkB2XNFetAXhFVqt4+xRg0aWoPesA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IfQ7UlAY; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IfQ7UlAY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753361310; x=1784897310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0jJlUruOEH5U6wp0LjrHpo7rb9Oh27vKOwvAWGr+quY=;
  b=IfQ7UlAY240ZZpU2HwyFGxj7MWsKNGJJWoqWiGGIgjg0rDJ6iEv/oUa4
   hBK5xgwmX32gxQM8aby4+56dtSKj+Yo1kS19KtQzxBf7qCK76d1x/VRAE
   iJhwzs9+Qvnnr4dEedyG4ATVY/vFxNykbrujmSEkmy603idHsvG6hpu/8
   k5wHzFUPahz3QUcqvkJsL+wAWDuPP3tIAfB2MGTSBUEcJ8T0K8jWAZ2OC
   Pi5hU5odhtXxfbbrK7l5PMpBawJBINwlAJjzMh5Epw+TvdUbHVkk4vCqH
   n7++WYXoSWCEiRRrHj18Vr0ln6nGEJTGKqXXDT0UKZ4quPnmT2po65orK
   Q==;
X-CSE-ConnectionGUID: ahCP1lLdTouDamobL1a3bQ==
X-CSE-MsgGUID: SodneN5TSamSTUucGZ8mlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="78220235"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="78220235"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:48:30 -0700
X-CSE-ConnectionGUID: WbODdcFXRZKH9b7+3bjPaw==
X-CSE-MsgGUID: Pw9vEDVjRYWsNJNkOj7VZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="165758134"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:48:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 05:48:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 05:48:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.47)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 05:48:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BQa4Z0WuB6GcwWEHsZb2JOpanHgh1Dt4KQnOR9fLrOl1DYxhAdZPqtKbCvj/ThTrtb0yRrHq7XY1KkqmczM5iTsi4WHPRNnxK+V/RLfYcnAyXrodMZgvTJZzJ8h18PzoQ5saMa90r4AHDC8rMSIE6OeA+gIQX12dAMc8DRYeOgy3fok60eh7vq14JajHlFuiEPQtkcMhMoUUWflWJ2NjcLk+QZl8oMilcAb3ebOifwN9YEx73u9ISRzmqg6OqD/SeJ4KsjpJIy9qdb+paN6gbDpaLpMKWM0U6Bqsj6jT4mhez8IyO8YQrLBk1J8THZ/NYDyKuZ5B70Dmu+oteWzUVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0jJlUruOEH5U6wp0LjrHpo7rb9Oh27vKOwvAWGr+quY=;
 b=nUj6Zgv4Ms8qHpLH4emQURAu57GagYnYI9pAbD7n82+8LY6LSWjq5yJS7rsAJF4X7ECuTyrT/Qxa1T7MZFQJcvhtXU4HrQOpIqbeBnGlAbZwS8eNPafn9IveCfDTaiPpF+K1OSUb8o3QY9tyeEJtHSOgbqSodnJPdY0jPLly438V6g4QHUeil8xFimUvbSVAfZNVdyMcQ0IpMd65aKYCYs+VIxaEPTQl+LJ6v2mMb8I/1ZGkX64349+NudpqtyX4/zqNLCSCWL37MGq3i7LHh8ZEwat8CiarGz6hszQYWVV1gLqaDGFQIOWb+4QFn51bMPG7GQFbN9o3hDh4m0kx8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 BL3PR11MB6362.namprd11.prod.outlook.com (2603:10b6:208:3b5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.30; Thu, 24 Jul 2025 12:47:57 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8901.030; Thu, 24 Jul 2025
 12:47:57 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHb/HGKXf61+ezBWECHdPwVOqpZB7RBHu8AgAAYdDA=
Date: Thu, 24 Jul 2025 12:47:57 +0000
Message-ID: <DM8PR11MB57502FB1B78481B436DFAFFEE75EA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
	 <20250724080313.605676-7-elena.reshetova@intel.com>
 <156919280fe6b1e01a81bb89f8850e72a6bfe077.camel@intel.com>
In-Reply-To: <156919280fe6b1e01a81bb89f8850e72a6bfe077.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|BL3PR11MB6362:EE_
x-ms-office365-filtering-correlation-id: c7f31949-2b61-4421-cdc0-08ddcab05101
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cU1BVTNHVmZFTjROY21vUk9vVzU1aWRVdjZ4dkNIc2NUQlpFbEJ1c3NOUkty?=
 =?utf-8?B?YnU1L29wYlY0UXUraG5IaHVHc1hlczI4bVdMMHVTYlprbzhDNENNVENYSVl5?=
 =?utf-8?B?aWZhN0FJaC9MRDJzVnZaYnBZSUdDZHhJVEZnNWVsSXRVZFZVc01yUzJuL041?=
 =?utf-8?B?d0YrMzN2SFVOc2JHeWFOWndVWFBFMkE2Y0JZUUhkaERwaW52RGpDRzhJZ0J1?=
 =?utf-8?B?QmxVTHA0cFBIQVNLVW03MnZVbm1hbmZDSTlQOHhLQ1NtRUxCdG5heERSb29j?=
 =?utf-8?B?bWtva1JxZFQ4M2gxb1pUdVkzZkc5SVVPVTNHSERqeVl6VE9KNWhiVHVkeHlY?=
 =?utf-8?B?d2dJaW1TaFBzSk5INTFMT0VrMThvaWkvbTloQjluUStvSTh5eUtjbS9uMm5E?=
 =?utf-8?B?M1IrdWhoMlpSMmJHK0paNG1nOGRCaUcwOW5YMkFqVFVNblNGeFZzcGs0cmJO?=
 =?utf-8?B?QWxHVk9QdkFVNHZPOGlSMWxheDgzR0VTbXM5NFFoay92SnoxZUtER2ZIbzZ0?=
 =?utf-8?B?ZkZIZHM4STRrejJEUThkTjRta1RORnErT3A5M2I2WmxoWG5DcnRIV0h1SjI0?=
 =?utf-8?B?T2NvWUhkMFJ0aytWWHJSV0tiZFNhRWgzdm0yVWNHMWljR0VCZDJrY3JmclJP?=
 =?utf-8?B?cFdwTW9QYUVQcEtJamdjU2FiWUttbXFOd0ZKSzYwaHcyaW5YYUpQdlVVUjFR?=
 =?utf-8?B?bU5VVCtZd2VxMWptem93dTByV2J5dWw5b2p6UjNzN1d6US9VMWZLc090Snli?=
 =?utf-8?B?dnF5YnFqRUp1aVBJb0pUcU1YbWxxRHZaeTZEZkhVdUVUdHoxbmdEcmxCblNH?=
 =?utf-8?B?NGF4NXRsUVB1UXNoVHZuTHpsNzl3dmpHM0s4cVMzaDNsNldhdlE0K0g4YklP?=
 =?utf-8?B?T055dTlXWGNPWFpoU3JPcXIxNmFlR2RXZVpJMVFBZEhEdTRyMlpQSFJSOFZ5?=
 =?utf-8?B?cUJ4UW9oakdNZ1p3Vk9xMEdzcG5ON2pnMXUrZXE4dVJhNkx6WUhjYVl2RVRT?=
 =?utf-8?B?TTNaWXNpT05weENTTHh3cHZYL2dONEFGRkJQQ0RRajUvSHNJU3RxSDhIWmk5?=
 =?utf-8?B?bUlMbjJUeTN1Z2xZZVNyU2lreENrWkVPMk1IQkl0N05mb25VM0RsdndMVldl?=
 =?utf-8?B?UHhuaDBObEliYnpRT0tnaFNFSXluM3NmRDFHeEtpVmRWSi93ZUp6SFhoQWMz?=
 =?utf-8?B?RE4wUnZQYk5yVm40eWJZa1AvcTBqTlRoR3c5Uk1lMHB6Zm9USWxBMVVvQ2NT?=
 =?utf-8?B?dWtnYUttdmpjelZpK0pqeDJRQjYxKy85MlhMVmFvVzZLc1RXek42clRnRGNB?=
 =?utf-8?B?b0FwUklkVlgyYjBKQ1hVRm80YzhES1ZQeDQ1QU5SU0IwTktOQVRaV0VtR3hh?=
 =?utf-8?B?QVRuQTROOGdZZWYrTTJKQlVhZkZhWGFId2V4dkhqRXA3anhsOFhGRWFPT08r?=
 =?utf-8?B?T0NicEFjZjJGMm5qeHNjMGRla01RdmUwTThTZHpiclR4K0wvUi84OFZwT3Zu?=
 =?utf-8?B?R1dwK3hPdHZIeEFEUUVCRExjWlh0YUZ2NGl4MUJtQ3cvbWtlcGZ3QVhBRDFi?=
 =?utf-8?B?d3ZNRXcyL3VGNFU3bDhpaU54MG1TN3lDMnZnZ1RGM3IzYTErRFErWU5jbUlE?=
 =?utf-8?B?T3JPM245TE42ZjdrNXJBb1AzdGFJNlBObnVlOVdEeHVOMHpScW9SYmI5bk9D?=
 =?utf-8?B?SHlDT1BFZko2ZXJ3K2tPSWNrZjhnci9SOE84ZytRODdEVWh2S3grU0F2SnpL?=
 =?utf-8?B?S3UwencxcDNGdHZwc2tsTVZUaVRDQ3VrbVFDUzB0SktQZWtoSjlteHFTbEZq?=
 =?utf-8?B?NTdQR091VVBNR0V5UGdDT1craFF0NFljUEJabzBubk1KZnBPTXp6K09PRzlZ?=
 =?utf-8?B?K241a2hHNkdRRzFtYWhaaHlMS1VETCtTSGtVUkhvSE44MDVTVnlQR3hUT0xB?=
 =?utf-8?B?WFFidzNmb2lNcVdabkVja28yMS8rb1dEb21BMUQyajNuVWlBNkxvNXVpT2tP?=
 =?utf-8?B?d211OWs5dFFnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3libXJjM1g2d0ZWTFh2WEhjbG1rTmMxd3VPemVjT0pTaUJHZUNHRDZSYWZ5?=
 =?utf-8?B?b1dac0ZOdWswRUFCVUtYSFp0UjB5MXM2WW5lVmFIamViN0dEeFVwUVI2QXdY?=
 =?utf-8?B?WnUzT0ZiQllONE9TcG0zbHBSZU9yNFozc2IzNTZnRnI5cTZWV01aZHNXYlRj?=
 =?utf-8?B?UmJRc0J3QUV4WkFBaDZHQmVxa0ZEcUVPRXFxVzV1RXJTMXVJYkZQUEdmYmRH?=
 =?utf-8?B?NUI5c2JqZ21QbkJIUTRtWWhvOFM4UlJnaUl3c2UzTDVIenlqVlIvcnBMMkw4?=
 =?utf-8?B?anhBc1VHa3F2WHY2MUtjL3BsSUM5cVdCeHhHb1Q0S0Z2cjFzMUN6U1BsR3Fx?=
 =?utf-8?B?Q1BDODQveG5NWFIzZmd3UFBQcnl6ZHNYODJSeTZjLzkzaFhMZEhNMUwvajdQ?=
 =?utf-8?B?NTZHR0k3UHpxdWM1ZFFKVSs2SmpCa0dxdVlEMEdnVUtlTE9kTTNrdzVRTWpU?=
 =?utf-8?B?dkhVaEN2azkyWHRwUlNrTUF6eGhyOEluVTVkenFwbDhsSm1kY0FyYmwyZW5D?=
 =?utf-8?B?cFBLRndrSkp2cXpNd2t4UzduNFA5Z3RLWml0eWVMM3dPdnZwaEJrS0NtMGNm?=
 =?utf-8?B?OExNaytmbGI5YUZvV0FDWHlKYVdMaGdPbjR2ME9SeFVIclBQTlJvbFFReWF6?=
 =?utf-8?B?akRJd3BnMEZYSkk4V2ZFOVhjaFNPMjl2eWkwUDZza0x5VUlCMkc0d0tTVWFn?=
 =?utf-8?B?cDBWeE9vNmZIMW16K3pZQjJnOW9DMHlidnd4Y25VY0dmcDQzZVdlSXNMY1hr?=
 =?utf-8?B?dFZUZlNadUlpQ1RaWXQwRnRLdkdkR2RYK2I0d2pGUUdGRGt2ZWs5bnY5VCts?=
 =?utf-8?B?VWhyakVUU1Q0RlA2ajM5dUpCSEpQeEFMTXIxU09BaUI1aldSMXdKNnhoRnJS?=
 =?utf-8?B?SXdOcDdQOGlYdkhYdCtTam5KSmJOQ3RLOUxVekZDK2dhVGZLcFRlUFc1bDVL?=
 =?utf-8?B?dFh2Wi80dkFpTFhUUTFISGc3Rks2NVgvclArQmNRK3FhVHlyM1RyT3BRRGNo?=
 =?utf-8?B?aHFENVVTRE1qR2YwRm91cVFrUVRTK0pOSTZhYTNkd09mMndBV1BjbnFjWloz?=
 =?utf-8?B?ekVHUFBIR0Zibmh0UDJOVm0xa2EzR1FUVDkyajZISURvYkVPYjJXdTFtV0s5?=
 =?utf-8?B?ZVFac2xINVY0blZ0QU1EbzExa2tiSjhUTFU1bEt3SWMzcGl3V1lRL1BMbStn?=
 =?utf-8?B?OUtGWkprTEhKaUgxL0pCWHkwNUdtSTdqRUd6Zzh0dWk0OEl1TG9BYjR3UG5P?=
 =?utf-8?B?cFl5YnJnbDdQN1NiK3NrTitIeTVrNkxuRUpqdGtlVVdZM28rNy9pZ25Xd3NS?=
 =?utf-8?B?N3dYcW1wV0VUcld5UGRhT1M5RUVaZTdsWlNvVExCUmxJWE05bkVtWjZtazZw?=
 =?utf-8?B?N29NaFI2Z2VxcjU4SWxHWnZra1VVbUN1cGdhMXlZdHNBTW4rQm9zZWhDYlV5?=
 =?utf-8?B?MFZGVW9icDdrUU9ZcFFVRlRxYTdPSFZlMHEzUnRvRU1vR3pBbGNxS0ZkenRC?=
 =?utf-8?B?Q1d5SHI3UE5nNjdLNy9Pa2ovVDhmeFNpN2h2MzB0S3g4d2pWY05iN1Bna1dX?=
 =?utf-8?B?ZFRockdoNFBoRTl3Znh4T09LSjhUejBhclpZZkg4YzM2ck9kVkFSVm1CYTli?=
 =?utf-8?B?WG9vd2ZvVWxNSkRpamxiY05ib0psRVVhdjRYSUZJbG9Pa2kvdUozeDNuMHl0?=
 =?utf-8?B?V0NGUm5hc3pZblp1S0lvSTJXalFUeFJKa2NtMnpvN3d4OGFERjlERGo3aGdJ?=
 =?utf-8?B?RXRGTm5OMWJPVDR2emhlSExoSmEvcGtZMEI2L2pXSGRCOHZIemozQmQ5NnQx?=
 =?utf-8?B?L2d6cFY4WmRqRTVCcjRIUlgrWnFKWnJWZGhOdE0yRVF0dkNBaUt6SHZPODRx?=
 =?utf-8?B?YkV2MkpnWGxZa3pTRjZwaEdDRHlkQzByNldSNWk4bmVORWRxa3JlWUFiQjN3?=
 =?utf-8?B?QXh6djFoN29xSU10cWROR0hkN05TRHJFZm12NkNtZldNK3o2ZHpPOGdWR3Rs?=
 =?utf-8?B?R0xhTEp6ekpYc2hXakZoenoyaENoamVoY3hLNkk4ZU9tY1RnbkphcW1ad3Vy?=
 =?utf-8?B?VkZLZFF1VzZLMDBGc2ZPK2VucjM4M3RqUDlCVmI1MmJBR0Y0VG5tL3NFcnB1?=
 =?utf-8?B?NU5Rbm9oaWowNmxncmI0QmFYQUtnNkxVRHZ1Y1A1TWxDVWdUODltd0Y4S3Ro?=
 =?utf-8?B?Q2c9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f31949-2b61-4421-cdc0-08ddcab05101
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 12:47:57.8496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bmAIrLNe89y4CzDKfXGQD4CLV96SmF7dNq9AlXLsuanTXhSbAPjX+e+89KffLSdO1Lgj7PkMJWVHRKO8TK0gJwvZB4Fiy9UQ5RF+xvrEBHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6362
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIdWFuZywgS2FpIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAyNCwgMjAyNSAyOjEzIFBNDQo+
IFRvOiBSZXNoZXRvdmEsIEVsZW5hIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPjsgSGFuc2Vu
LCBEYXZlDQo+IDxkYXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IENjOiBzZWFuamNAZ29vZ2xlLmNv
bTsgbWluZ29Aa2VybmVsLm9yZzsgU2NhcmxhdGEsIFZpbmNlbnQgUg0KPiA8dmluY2VudC5yLnNj
YXJsYXRhQGludGVsLmNvbT47IHg4NkBrZXJuZWwub3JnOyBqYXJra29Aa2VybmVsLm9yZzsNCj4g
QW5uYXB1cnZlLCBWaXNoYWwgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT47IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7DQo+IE1hbGxpY2ssIEFzaXQgSyA8YXNpdC5rLm1hbGxpY2tAaW50ZWwu
Y29tPjsgQWt0YXMsIEVyZGVtDQo+IDxlcmRlbWFrdGFzQGdvb2dsZS5jb20+OyBDYWksIENob25n
IDxjaG9uZ2NAZ29vZ2xlLmNvbT47IEJvbmRhcmV2c2thLA0KPiBOYXRhbGlpYSA8Ym9uZGFybkBn
b29nbGUuY29tPjsgbGludXgtc2d4QHZnZXIua2VybmVsLm9yZzsgUmF5bm9yLCBTY290dA0KPiA8
c2NvdHQucmF5bm9yQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2OSA2LzZdIHg4
Ni9zZ3g6IEVuYWJsZSBhdXRvbWF0aWMgU1ZOIHVwZGF0ZXMgZm9yIFNHWA0KPiBlbmNsYXZlcw0K
PiANCj4gT24gVGh1LCAyMDI1LTA3LTI0IGF0IDExOjAyICswMzAwLCBSZXNoZXRvdmEsIEVsZW5h
IHdyb3RlOg0KPiA+ID09IEJhY2tncm91bmQgPT0NCj4gPg0KPiA+IEVOQ0xTW0VVUERBVEVTVk5d
IGlzIGEgbmV3IFNHWCBpbnN0cnVjdGlvbiBbMV0gd2hpY2ggYWxsb3dzIGVuY2xhdmUNCj4gPiBh
dHRlc3RhdGlvbiB0byBpbmNsdWRlIGluZm9ybWF0aW9uIGFib3V0IHVwZGF0ZWQgbWljcm9jb2Rl
IFNWTiB3aXRob3V0IGENCj4gPiByZWJvb3QuIEJlZm9yZSBhbiBFVVBEQVRFU1ZOIG9wZXJhdGlv
biBjYW4gYmUgc3VjY2Vzc2Z1bCwgYWxsIFNHWCBtZW1vcnkNCj4gPiAoYWthLiBFUEMpIG11c3Qg
YmUgbWFya2VkIGFzIOKAnHVudXNlZOKAnSBpbiB0aGUgU0dYIGhhcmR3YXJlIG1ldGFkYXRhDQo+
ID4gKGFrYS5FUENNKS4gVGhpcyByZXF1aXJlbWVudCBlbnN1cmVzIHRoYXQgbm8gY29tcHJvbWlz
ZWQgZW5jbGF2ZSBjYW4NCj4gPiBzdXJ2aXZlIHRoZSBFVVBEQVRFU1ZOIHByb2NlZHVyZSBhbmQg
cHJvdmlkZXMgYW4gb3Bwb3J0dW5pdHkgdG8gZ2VuZXJhdGUNCj4gPiBuZXcgY3J5cHRvZ3JhcGhp
YyBhc3NldHMuDQo+ID4NCj4gPiA9PSBQYXRjaCBDb250ZW50cyA9PQ0KPiANCj4gTml0OiB5b3Ug
Y2FuIHVzZSAiU29sdXRpb24iIGluc3RlYWQgb2YgIlBhdGNoIENvbnRlbnRzIi4NCg0KU3VyZS4N
Cg0KPiANCj4gPg0KPiA+IEF0dGVtcHQgdG8gZXhlY3V0ZSBFTkNMU1tFVVBEQVRFU1ZOXSBldmVy
eSB0aW1lIHRoZSBmaXJzdCBmaWxlIGRlc2NyaXB0b3INCj4gPiBpcyBvYnRhaW5lZCB2aWEgc2d4
Xyh2ZXBjXylvcGVuKCkuIEluIHRoZSBtb3N0IGNvbW1vbiBjYXNlIHRoZSBtaWNyb2NvZGUNCj4g
PiBTVk4gaXMgYWxyZWFkeSB1cC10by1kYXRlLCBhbmQgdGhlIG9wZXJhdGlvbiBzdWNjZWVkcyB3
aXRob3V0IHVwZGF0aW5nIFNWTi4NCj4gDQo+IChTb3JyeSBJIGZvcmdvdCB0byBzYXkgdGhpcyBp
biB0aGUgcHJldmlvdXMgdmVyc2lvbnMpOg0KPiANCj4gSWYgSSByZWFkIHRoZSBwc2V1ZG8gY29k
ZSBjb3JyZWN0bHksIHdoZW4gdGhlIFNWTiBpcyBhbHJlYWR5IHVwLXRvLWRhdGUsDQo+IHRoZSBF
VVBEQVRFU1ZOIGRvZXNuJ3QgdXBkYXRlIFNWTiBidXQgaXQgcmUtZ2VuZXJhdGVzIGNyeXB0byBh
c3NldHMNCj4gYW55d2F5Lg0KPiANCj4gVGhpcyBpcyBubyBoYXJtIHBlciB0aGUgcHNldWRvIGNv
ZGUsIHNpbmNlIHRoZSAiY3J5cHRvIGFzc2V0cyIgaXMgYWN0dWFsbHkNCj4gdGhlIENSX0JBU0Vf
S0VZIHdoaWNoIGlzIG9ubHkgdXNlZCBieSBFV0IvRUxEVSBmbG93IHBlciB0aGUgU0RNLg0KPiAN
Cj4gSW4gb3RoZXIgd29yZHMsIGl0IGRvZXNuJ3QgaW1wYWN0IG90aGVyIGVuY2xhdmUgdmlzaWJs
ZSBrZXlzICh0aG9zZSBmcm9tDQo+IEVHRVRLRVkpIHN1Y2ggYXMgc2VhbGluZyBrZXkuDQo+IA0K
PiBJIHRoaW5rIHRoaXMgaXMgaW1wb3J0YW50LiAgQmVjYXVzZSBpZiBlbmNsYXZlIHZpc2libGUg
a2V5cyBzdWNoIGFzDQo+IHNlYWxpbmcga2V5IGFyZSBsb3N0IG9uIEVVUERBVEVTVk4gd2hlbiBT
Vk4gaXMgYWxyZWFkeSB1cC10by1kYXRlICh3aGljaA0KPiBpcyB0aGUgbW9zdCBjb21tb24gY2Fz
ZSksIGl0IHdpbGwgYnJpbmcgc2lnbmlmaWNhbnQgdmlzaWJsZSBpbXBhY3QgdG8NCj4gZW5jbGF2
ZS4gIEUuZy4sIG9uZSBlbmNsYXZlIGNvdWxkIGZpbmQgaXRzIHNlY3JldCBlbmNyeXB0ZWQgYnkg
c2VhbGluZyBrZXkNCj4gY291bGQgbmV2ZXIgYmUgcmV0cmlldmVkIGFmdGVyIGl0IHJlc3RhcnRz
Lg0KPiANCj4gQXNzdW1pbmcgSSBkaWRuJ3QgbWlzcyBhbnl0aGluZywgY2FuIHdlIGFsc28gbWVu
dGlvbiB0aGlzIGluIHRoZQ0KPiBjaGFuZ2Vsb2c/DQoNClllcywgeW91IGFyZSByaWdodCwgYW55
dGhpbmcgbGlrZSBhYm92ZSBiZWhhdmlvdXIgd291bGQgYmUgYSBuaWdodG1hcmUNCmluIHByYWN0
aWNlLiBTbyB3b3VsZCBzbXRoIGxpa2UgdGhpcyB3b3JrIGFzIGFuIGFkZGl0aW9uYWwgdGV4dDoN
Cg0KIk5vdGUgdGhhdCBpbiBjYXNlcyB3aGVuIFNWTiBpcyBhbHJlYWR5IHVwLXRvLWRhdGUgYW5k
IEVVUERBVEVTVk4NCmlzIGV4ZWN1dGVkLCBpdCBkb2VzIG5vdCBhZmZlY3QgZW5jbGF2ZXMnIHZp
c2libGUga2V5cyBvYnRhaW5lZCB2aWEgRUdFVEtFWQ0KaW5zdHJ1Y3Rpb24uIg0KDQo/DQoNCkJl
c3QgUmVnYXJkcywNCkVsZW5hLg0K
