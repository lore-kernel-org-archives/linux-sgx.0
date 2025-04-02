Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8FB1E531;
	Wed,  2 Apr 2025 13:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743599492; cv=fail; b=u7tr9ny8AcLSrUDONr5iKJaLDRjcAwf5A34jHVrn+UogtDYOZlxdw4BfY+Z/Iips7rov8kUZYNRI4k8JjfKqec7r4WDH1CrZF+cbHrLavWCKTicjnd8bRpIapFZUFmb1J/suU31s6uL3wij25euEZ5D/HYTr6lGFg0uVLrKseTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743599492; c=relaxed/simple;
	bh=KeSEObwSSw7GCzpNnPqqeEPLpTcainCxvBJVGTgxc1Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WfaUEPChOmyNOZr7hit4OoHNWCjRmDBJH5QFwc7Li+zV9A+tc3pD0+AhAQKdy0sEaBGP7EE/ofpjbNjm4mONz1iqgcB0Nw4ahgz6/6DuXLAa70eTdKAuHzo+/k4QkDLHLIQV4j4Pna2Z7SAYkKOHYx/fmXgSBfUvUcEUgzNgAgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lMW0tz/E; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lMW0tz/E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743599490; x=1775135490;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KeSEObwSSw7GCzpNnPqqeEPLpTcainCxvBJVGTgxc1Q=;
  b=lMW0tz/EXPAdivtywCfAbUXcFeiStmtjKbM1mJFDfdShRhFK7WegHL4n
   SA8w767h0O81C+1TdVupoONv8WXhom4NJ4R96uNl7I+4DS7FaA5pO213y
   dHfdAKv0J0hHfUb+Db6+0rGvxsuakC9M8zL+vXgfKYi5ama8Tum5+uo5e
   NJpfrh/4wpiX5FD2Ja3QzwWLFFcIUxG8tebYmC56ER4Gk6tuC5MqYwCjB
   bj9nFhbsfoeqQfmUsWkdC3PC787KCL9Ob7bwLvuY/S6gWkJGBQ8icXXu8
   mqesRtMEJ+xA6h7twxC2e4cGI7tt/iPf0UsAdbwuFjMxYJKDJ7rTQpkU2
   w==;
X-CSE-ConnectionGUID: Gv5Wp6haRJeLxJMaNslYGw==
X-CSE-MsgGUID: stDiTmmeQSeqHJ25gSRoIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11392"; a="45088491"
X-IronPort-AV: E=Sophos;i="6.15,182,1739865600"; 
   d="scan'208";a="45088491"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 06:11:29 -0700
X-CSE-ConnectionGUID: W9gBlwgxQPOumloD+PjpMg==
X-CSE-MsgGUID: hV+rWHXhS62qLQ8kvqxBKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,182,1739865600"; 
   d="scan'208";a="126592501"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 06:11:30 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 2 Apr 2025 06:11:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 2 Apr 2025 06:11:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 2 Apr 2025 06:11:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JIhgr+hJoWZqgI9u0U4Ph14jIC4KODAvKQCgLxplGtcnodSymgHC3SyFg1ryhp7btQC/A8+KSYbGrFuQCPADKjeX1r1558VC1utr6qZqUfIu9jhdf9s3U3IXb8dFiYScZfEhoKIhydBYU/GZWzVPdXGP1yZjAUbJvSzlsJ97LZVTLF7ExZyvf0yez3WpddCEZrrHrsI4h+ltnrSjEf4uFGeC6FGq2rZtMHnoFFdMiqguPCerIKnD+nQdxcyvrZ1jPThPTJZeDzRY1be5ei2zx5dDNVD/rNQYFxKvlh2ZEnro36eMSV5+qlYR34/ZtJH/6NPP0EN54lGu7mBUv+KZcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KeSEObwSSw7GCzpNnPqqeEPLpTcainCxvBJVGTgxc1Q=;
 b=Zn5g6KXn110M6qvuDKJD5/En9arZLylVe75ku5ijRxVT/al/bevtP+GaMzrbpEaKEgWunhS76UN5CKpMLkZ4o40/rpqLITfFP3tgv3tatfuuPTp036pAzU/ksLTz7wInq7DtNQ93Kwk3jpAcQLcTmn8uBIEJW1njb11a/AY9W9BVfoQWLSv20yZlN5wbfAVBwH8mxD1FziNekPfrz1ptZpuCs2T3l9p1uweZqCqfKlYchE6LmCt9iKETjlFPvuV1wR/CKQwAi0LcgOycOpBHKES/jrc1zzjL7XVNp/TKqSXvEYRxntOZy0WzjPidvHLQjV/MhXQIe4RX228ya9Wu/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SJ0PR11MB4976.namprd11.prod.outlook.com (2603:10b6:a03:2d7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.49; Wed, 2 Apr 2025 13:11:26 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8534.048; Wed, 2 Apr 2025
 13:11:25 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Mallick,
 Asit K" <asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "bondarn@google.com" <bondarn@google.com>, "Raynor,
 Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbn+FDiJjsRSw2cUyPYDKGfVHjnbOI1BeAgAAEgICABAKjsIAArrUAgAEIZUCAAFLwgIABevGQ
Date: Wed, 2 Apr 2025 13:11:25 +0000
Message-ID: <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250328125859.73803-1-elena.reshetova@intel.com>
 <20250328125859.73803-3-elena.reshetova@intel.com>
 <Z-bhczXA6aHdCYHq@kernel.org> <Z-blOQ94ymUsDwPn@kernel.org>
 <DM8PR11MB5750C88DFC518EB77B0D613FE7AD2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-rU_JXWn0vCdBr_@kernel.org>
 <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-v4WfcLhmXbYvaa@kernel.org>
In-Reply-To: <Z-v4WfcLhmXbYvaa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SJ0PR11MB4976:EE_
x-ms-office365-filtering-correlation-id: 9a6fe323-3ed5-4d4d-9b8e-08dd71e7df8e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Yi9LTlJOekMyZm83bUZuNUttZFg1YzN3aGVVMWZZcTB4K0xML3ZadkhMSVRW?=
 =?utf-8?B?ZFF4a2JjY2J5NCthNTVaSmV3UGtwSndPR0VzTUhwNDFyQUVlWjdBeUwydFRz?=
 =?utf-8?B?S2loaVQ3N05lc1F2R21EVDU3R3hLTkhxQnVqUmFzaVp0SGk4WWtsUVZ4VlM4?=
 =?utf-8?B?RTI1YnRnS3gvYlVENXRQNlRmQWJzRmNSYngvYktUYWl1SDBiQ1JsSkhsY013?=
 =?utf-8?B?RC9MelBsSTFla3BLTTBKaWRMYkNPeHF6Z01rd0F6ZXJ3cTlKa2NybVRlTHl3?=
 =?utf-8?B?SnZlSk5ZYm95OUdRMTRrY1Y5ZmI4eGxsaUVMZGFKREYvamoyamRmaXBtK0hM?=
 =?utf-8?B?b2FZZytXT0svcFlwMTl4YnpQZ20xaG5NU29kZEpIbFhRa1FpcGNxTk5WQ1Rx?=
 =?utf-8?B?dnRqNytoaSsxdVN4cytVREExNXIzMTJPSy84TnU1ZUk3aGZnMlc1a1ZFUk5L?=
 =?utf-8?B?N0RuM0FxRXBJdWh6aVc3Z01hVGtNRHRkMVFjeGg5Wk04NGdlV05UUWJ6VDIr?=
 =?utf-8?B?OWN5Q1Q4cEpkemJoWUlmUjN4ODdTeTd6dVlGaXliUGNIRCtHYWdRUTVzVG90?=
 =?utf-8?B?NmNrVnhBd2Q5S0tJT2FsK001Q3p1QVNDZFA5STVoQnA5QmFvY3FrZ3V1ZHVx?=
 =?utf-8?B?aFVvbHNmN3h0aWszeG5GNTA2dkVDOEtDS2hXT0s0V0tHcW5aekFwb2RFdng2?=
 =?utf-8?B?VlU1VncxUEFUdENrYjI3RjBvUENPZ05hQkUrd0pSTFZrbk9UaFMyOHBCZ1Ev?=
 =?utf-8?B?TUN4UHVaSzZOMFVXMEdxUnZqaHdFbnhwK0RBT0ZWdDBBaFNDb2hDZCtUNHNW?=
 =?utf-8?B?bklsU1JSSkpSRVFqYk5nekdydXNHUnRud2pYa1Zid2FyTk5xTzNaYlY3N1ZG?=
 =?utf-8?B?U2s2ZVI3U09ORVdYZktZcHZDSXY5TzJmbzZtM21YdVJLb01BYXZKSjkwcWNj?=
 =?utf-8?B?OWp2M0JabXJrUHlTbTZTaTc4T0tJcWZhVkJpcUhVTFpQMmEwZ1FFaFl3aklq?=
 =?utf-8?B?WTY3NHUxM3orOWtKZTAvNVdua0k0SWUvTG9VNlVFWmg2NWg3TVV6RlRpSDkv?=
 =?utf-8?B?WHkzWWsvbnhCMDlHOWl2dUsyb3YrdmZCZWg4ZnFVdjYvWlcrb0VCN2M4YWgr?=
 =?utf-8?B?c3M1OSswMHVlYlFvdy9raU1iUm5UVmQ5Zld2YXpnc2tCMXNuVmJQUGoxMDE5?=
 =?utf-8?B?U0h3aTIxNHZsNUNMRmd2VE5WTXVjN3NWM1U1bXlJeURTK2VsaU5JOWhyMWV2?=
 =?utf-8?B?QWpzZGtlRXlWSS81WXc3MDNaN3E3VE9UVE5rT2ExelcxaFZOazV6eTFnbUdq?=
 =?utf-8?B?ejVYYXNxNFJFR3dqL3BnMHJtcnRjVSs0Z1h1N1ZrQ09wTGN3bmJrMmkxOWxR?=
 =?utf-8?B?WWxpZGR4RWtWZXk0RG1FNXQ2TUQyRGZnc0JXd2NrL3h3Vk9ReUh3KzRiRmxD?=
 =?utf-8?B?MmduaElvbkUwMDNlRDJJeVc3WXgwQ0ZKc1hIYWdHdFNVVUlqVjYwckx2YkVZ?=
 =?utf-8?B?d1VSY3BHekxnRVBFKytReS9RMExkMTVRZGQ2cjZMU2ZZcXNzdVdQaVFVVWVV?=
 =?utf-8?B?NTBnckpkM1paZmx5R2RzeW0zaGphKzkrSUpDVFFqQjZYRDBRMm1NcWcvQnZY?=
 =?utf-8?B?S2F6bUsyVForRjB3Q1Bwc2E4ZUx5R0VwQllCdk5yTXZLblpBWUE0c2VoditM?=
 =?utf-8?B?VUFLR2VHd1RJcU8zQUowQ2ZXNjZ2cnZkSmJIOVd6eHJOaWVvWloxUDVWVU1N?=
 =?utf-8?B?TGU3QlV0a0JjZ2xaelUvZW1kbHo3azluLzVHVFZrOEdqdXlvYndYaVRaSTgr?=
 =?utf-8?B?VEZTZ0hpekU1VVQvMzVvZDlOQjY1SjA3SEo0MnVkb1F0RkdvWTlkV1ozY2RK?=
 =?utf-8?B?RWpoS0hZM3B0YkxoM01sbmlmSjFBb2wzaW5KTzJROFluRFI2MkhyZFYrc2dC?=
 =?utf-8?Q?RTJ4XFM9Gm6om8U0TTx7P/eksIb25Xox?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3A5OWxoc1p6VmU4ZTF1VnlzV1dhWDh6ekRaTlk1SVpJMFY4ejZiV2VwNTRW?=
 =?utf-8?B?RkRIb1VMWC9MOTR5VStOVFRPNHRLZGRXb2JTeWZYeXp2U3BHVWg4VER3eDJV?=
 =?utf-8?B?eUZYcEZiZmVVbCtZck8zQm8vZDlIYmR0dExrcTRiWWIvYkZ4TjBDcVYwN2Z3?=
 =?utf-8?B?cE5JTytSOFAzRDJ2ZHVQYzdDQitZNGxBSEw3enUvQndSUEllTW1odFVkREdU?=
 =?utf-8?B?S3IrcmlVckQ3Tmp0ZXdobFVWMW5BaDdtR3FPazUwTHdnMVZaRlVVNWJnY0Qv?=
 =?utf-8?B?MDlrYmVwQUpUU0hsU1VXUEZoQm1RLzFmY3J6emVnTXNteFo0UzdkbHg1dlNk?=
 =?utf-8?B?U0wzMU5ZTUE2M2VZbDhsWjUwdDExRkxUY2xJZ296ekd2Zm5pays3WDh3V2lw?=
 =?utf-8?B?U2RtbUIwSmE0dUJnZ1ZYTVM1M1JwZHVXNXpnZnBqNDVnckdpcUFvSGdxdzF6?=
 =?utf-8?B?WUVtYzZMSVQzSERLRXNlTlZ4L1VuTW4rWS9JZ2ZHRjRPQTBKU2VndnBNemo4?=
 =?utf-8?B?STYwNjM2RFZGUjh0VXcxc2hEQVJZWEVibTZZZUhaVzhUUXFFVjkrMERkbDRX?=
 =?utf-8?B?MWZiMWJpbGloNE0yN1VoN3U2TlArTzZES3pIakNuRWtKeEVrMU1nOVRUNnNR?=
 =?utf-8?B?RHN0NUVwK2YyeFRoVzZJNTZSMjAvMGQvdXR0TSt3eDZzRVpUblovTXB0QzlG?=
 =?utf-8?B?N1ZNVk5icFlLeVJjanpsdmVmY2ZKRHpPdTRXQ0p3K3IyL0RONCtYb2MvbitX?=
 =?utf-8?B?aHVlV2Naa3RnRXcxZGFObkdUV2ZlcmRqM2U0Vm1DK052TmlHTi9ENFQ3Q3Qv?=
 =?utf-8?B?VnpYaUNBMU5oeC8zY0gwOGpQQVFQMFRBZXhucWFlZnl5REordFNoaXFYUnlV?=
 =?utf-8?B?Smh2Nkk5Uy95enorWHgzTjhFNk5KSVU1enZlVnZGbytPc2h2dEVwTmtPVlBJ?=
 =?utf-8?B?RXZ2YTJCRWY0YVdHZ1hjSElnazhTNGVhZWcyVVdLeHUyWHZ1dzdhQjZ0bCtS?=
 =?utf-8?B?SENOZGtiUkhKdUdoT29BeGJiSmxpcEFLalVKVW1zQm5aSmtDa1pqTU9BNjRX?=
 =?utf-8?B?MXVkeHZIbDYxcklTSE56TGN3a3h3Vy83N28xbjhzR1FOSkczc2s5VU8ycDBr?=
 =?utf-8?B?bzU1VC9CM25oSFhDNXlZLzFWTkg4MEpRZUlHUzlWVjNzRWJkTXptc0RrbnNK?=
 =?utf-8?B?SzRMcGRKTXR3MzNYTk1STklJUk1TcGVjWFlkQy9ub0RtM29mTDNvZWdGcHEx?=
 =?utf-8?B?SUsraXJ5RjZLdVpyaEx2ckh5Um01Q2g1bDBLbFArejJpUDdNQUNWdFdqblhQ?=
 =?utf-8?B?Vkc5cEJCZ2RGNmxscWZ5QVJjUTJJMDc1ejFkOUZyRDN5cDAyb05WbWFyVTlx?=
 =?utf-8?B?QTVnMndOWDRLVS9qb1A2NXUvOEtjNTAxSG13SVUycFVzbmNCemo5cVVORkYz?=
 =?utf-8?B?bFJlQ3NFYyt3L3BjUk5ZS2R5dVBISmJycnVhRFpQMkpTdkJOdkUxSWlSMmhR?=
 =?utf-8?B?dUQ4UnZSZ3NlQ1hxVDdLQ1VveUEzcks3cEt2UG5DU1BoNkd6SW5pelFRbUcz?=
 =?utf-8?B?VElhQm5KckU2UnM1bTNwMC9NNkdtVnBuRzdWb3NQa2o2bkREWGpwQndtZWg0?=
 =?utf-8?B?Lzd4b2cya01VTk12a2drdlF4eUhlWHA3WU5MbEtQeGxCMmhYc3pKdnJGQmhK?=
 =?utf-8?B?SnB3ZFh0Q2V2MlovWW44VUQydUdoakVvTUg1ejlTb29JaytyZXpSaVNKa0k5?=
 =?utf-8?B?QXg4SHMyZDA1SUwrVmpNdW0wczZPUkhyT0JNOFdSUWZDb0crKy96eWJqOUla?=
 =?utf-8?B?UFIxeEpiMTBoaDlRR3RBeE1tbXltUzJMR2VuME1SUFp3WGpsa0tMc01sK0pN?=
 =?utf-8?B?bUF2T0I1Q1JUMHF5cVFDVitlQ0RhNHVHYnJaRExPRVNuNkQvOWtvaDFWSkNG?=
 =?utf-8?B?Zm1wNGY4RXZ6ZWd2bk9ocmNxREgvUTVkTy9weUxLSko4ak1HOGp3U0h4bFVO?=
 =?utf-8?B?VXhGWVV1K1psOE41UUtUaU52R09iWjJpMUk3MStuK1NVYXFyKzhCK2pDOGxH?=
 =?utf-8?B?WXRvZGU3d1BpdlFYd0VxaHJSZit4V2xMZ0x3emg5L3AvUnVkR2RaYTVzZ0lp?=
 =?utf-8?B?UG5QR2luSFNqZDJMdERlb3VTTTFsTElZSzdhZEROYUk4SGtHZ2tnczdydWQr?=
 =?utf-8?B?Qmc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6fe323-3ed5-4d4d-9b8e-08dd71e7df8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 13:11:25.8327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z04wvTeK/Bi88hfyNlaMsUSGYREBidF3t2Yey7kXbSE/iZGHm/DUQFpkBVYbkzHaV+Z0bD8JcZm/2tXeICL9GK9Hycv2/8TlFtDTEr2GK/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4976
X-OriginatorOrg: intel.com

PiBPbiBUdWUsIEFwciAwMSwgMjAyNSBhdCAwOTozNTozM0FNICswMDAwLCBSZXNoZXRvdmEsIEVs
ZW5hIHdyb3RlOg0KPiA+ID4gPiBOb25lIG9mIHRoZXNlIGV4Y2VwdGlvbmFsIGNvbmRpdGlvbnMg
YXJlIGZhdGFsIG9yIHByZXNlbnQgYW4NCj4gPiA+ID4gaW1tZWRpYXRlIGRhbmdlciB0byB0aGUg
c3lzdGVtIHNlY3VyaXR5LiBTbywgYWxsb3dpbmcgdGhlIHJlLXRyaWVzDQo+ID4gPiA+IHNlZW1z
IGxvZ2ljYWwgaW4gdGhpcyBjYXNlLiBJbiBjYXNlIHJlLXRyaWVzIGFsc28gZmFpbCwgdGhlIHN5
c3RlbQ0KPiA+ID4gPiBhZG1pbiB3aWxsIGhhdmUgYW4gb3B0aW9uIG9mIGdyYWNlZnVsbHkgc2h1
dHRpbmcgZG93biBhbGwgZW5jbGF2ZXMNCj4gPiA+ID4gYW5kIGRvaW5nIGVpdGhlciBhIGZ1bGwg
cmVib290IChpZiBTVk4gaXMgdGhlIG9ubHkgY29uY2Vybikgb3Igb3RoZXINCj4gPiA+ID4gbmVj
ZXNzYXJ5IGFjdGlvbnMgbGlrZSB0YWtpbmcgdGhlIHBoeXNpY2FsIG5vZGUgb3V0IG9mIHVzZSwg
ZXRjLg0KPiA+ID4gPg0KPiA+ID4gPiBEb2VzIHRoaXMgc291bmQgcmVhc29uYWJsZT8NCj4gPiA+
DQo+ID4gPiBVa25vd24gZXJyb3IgSSBkb24ndCB0aGluayB3b3VsZCBob2xkIHRoYXQgcHJlbWlz
ZS4NCj4gPg0KPiA+IFRydWUsIHVua25vd24gaXMgYW4gdW5rbm93biApKQ0KPiA+IEJ1dCB1bmtu
b3duIGVycm9ycyBzaG91bGQgbm90IGhhcHBlbiAocGVyIFNHWCBzcGVjKSwgYW5kIHRoZQ0KPiAN
Cj4gVGh1cyBpZiBmb3Igc29tZSByZWFzb24gdW5rbm93biBlcnJvciBjb2RlIHdvdWxkIGJlIHJl
dHVybmVkIHNvbWV0aGluZw0KPiB3b3VsZCBiZSBob3JyaWJseSB3cm9uZyAoZS5nLiBiYWQgZW11
bGF0aW9uIG9mIHRoZSBvcGNvZGUgb3Igd2hvIGtub3dzDQo+IHdoYXQpIGFuZCB0aHVzIGl0IHdv
dWxkIG1ha2Ugc2Vuc2UgZGlzYWJsZSB0aGUgZHJpdmVyIGlmIHRoaXMgaGFwcGVucy4NCg0KQWdh
aW4sIHRoaXMgaXMganVzdCB1bmtub3duIGNvZGUgd2l0aCByZWdhcmRzIHRvIHRoaXMgb3BlcmF0
aW9uLCBFVURBUFNURVNWTiwNCmFuZCB3aGlsZSB5ZXMgaXQgc2hvdWxkIG5vdCBoYXBwZW4sIHRo
ZXJlIGlzIG5vIGluZGljYXRvciB0aGF0IHNtdGggZWxzZSBpcw0KZGVmaW5pdGVseSBicm9rZW4g
d2l0aCB0aGUgZXhjZXB0aW9uIG9mIEVVUERBVEVTVk4gZnVuY3Rpb25hbGl0eS4gDQoNCj4gDQo+
IE9yIG1heWJlIGV2ZW4gQlVHX09OKCkgaW4gdGhpcyBzaXR1YXRpb24/DQoNCkkgdGhpbmsgdGhl
cmUgaXMgYSBoaWdoIGJhciBpbiB0aGUga2VybmVsIGZvciB1c2luZyBCVUdfT04oKSBhbmQgYnJv
a2VuDQpTR1ggY29kZSBpcyBsaWtlbHkgbm90IHJlYWNoaW5nIHRoaXMgYmFyOiB0aGUgcmVzdCBv
ZiBrZXJuZWwgaXMgZGVmaW5pdGVseSBvaw0KaW4gdGhpcyBzaXR1YXRpb24gc28gYXQgbWF4IGl0
IHNob3VsZCBiZSBXQVJOX09OKCkuIA0KDQo+IA0KPiA+IGN1cnJlbnQgU0dYIGtlcm5lbCBjb2Rl
IGRvZXMgbm90IGhhbmRsZSBzdWNoIGVycm9ycyBpbiBhbnkgb3RoZXIgd2F5DQo+ID4gdGhhbiBu
b3RpZnlpbmcgdGhhdCBvcGVyYXRpb24gZmFpbGVkIGZvciBvdGhlciBFTkNMUyBsZWF2ZXMuIFNv
LCBJIGRvbid0DQo+ID4gc2VlIHdoeSBFTkNMU1tFVVBEQVRFU1ZOXSBzaG91bGQgYmUgZGlmZmVy
ZW50IGZyb20gZXhpc3RpbmcgYmVoYXZpb3VyPw0KPiANCj4gV2hpbGUgbm90IGRpc2FncmVlaW5n
IGZ1bGx5IChpdCBkZXBlbmRzIG9uIGNhbGwgc2l0ZSksIGluIHNvbWUNCj4gc2l0dWF0aW9ucyBp
dCBpcyBtb3JlIGRpZmZpY3VsdCB0byB0YWtlIG1vcmUgcHJldmVudGl2ZSBhY3Rpb25zLg0KPiAN
Cj4gVGhpcyBpcyBhIHNpdHVhdGlvbiB3aGVyZSB3ZSBrbm93IHRoYXQgdGhlcmUgYXJlICp6ZXJv
KiBFUEMgcGFnZXMgaW4NCj4gdHJhZmZpYyBzbyBpdCBpcyByZWxhdGl2ZWx5IGVhc3kgdG8gc3Rv
cCB0aGUgbWFkbmVzcywgaXNuJ3QgaXQ/DQo+IA0KPiBJIGd1ZXNzIHRoZSBiZXN0IGFjdGlvbiB3
b3VsZCBiZSBtYWtlIHNneF9hbGxvY19lcGNfcGFnZSgpIHJldHVybg0KPiBjb25zaXN0ZW50bHkg
LUVOT01FTSwgaWYgdGhlIHVuZXhwZWN0ZWQgaGFwcGVucy4NCg0KQnV0IHRoaXMgd291bGQgYmUg
dmVyeSBtaXNsZWFkaW5nIGltby4gV2UgZG8gaGF2ZSBtZW1vcnksIGV2ZW4gcGFnZQ0KYWxsb2Nh
dGlvbiBtaWdodCBmdW5jdGlvbiBhcyBub3JtYWwgaW4gRVBDLCB0aGUgb25seSB0aGluZyB0aGF0
IGlzIGJyb2tlbg0KY2FuIGJlIEVVUERBVEVTVk4gZnVuY3Rpb25hbGl0eS4gUmV0dXJuaW5nIC1F
Tk9NRU0gaW4gdGhpcyBjYXNlIHNlZW1zDQp3cm9uZy4NCg0KPiANCj4gLyogPC0gdGhpcw0KPiAg
KiBEbyBub3QgZXhlY3V0ZSBFTkNMU1tFVVBEQVRFU1ZOXSBpZiBydW5uaW5nIGluIGEgVk0gc2lu
Y2UNCj4gICogbWljcm9jb2RlIHVwZGF0ZXMgYXJlIG9ubHkgbWVhbmluZ2Z1bCB0byBiZSBhcHBs
aWVkIG9uIHRoZSBob3N0Lg0KPiAgKi8NCj4gDQo+IEFjY29yZGluZyB0byBodHRwczovL3d3dy5r
ZXJuZWwub3JnL2RvYy9Eb2N1bWVudGF0aW9uL2tlcm5lbC1kb2MtbmFuby0NCj4gSE9XVE8udHh0
DQoNClN1cmUsIHdpbGwgZml4IGluIHRoZSBuZXh0IHZlcnNpb24uIFRoYW5rcyBmb3IgY2F0Y2hp
bmchDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0KDQoNCj4gDQo+ID4NCj4gPiBCZXN0IFJlZ2Fy
ZHMsDQo+ID4gRWxlbmEuDQo+ID4NCj4gPg0KPiANCj4gQlIsIEphcmtrbw0K
