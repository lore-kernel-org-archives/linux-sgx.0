Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B735226982B;
	Mon, 19 May 2025 11:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654152; cv=fail; b=bNTuYj/0eNOw/T88hm5r7BYBlGtE+rRrs8WvHEXjwlHSN3MebE0gX5fzihkJHY9Dm42WvRTKCUIbvEm+2jUimjCHW50zU+G1yTJ9tV6wDxElpjFRWXtBziOltbu20a01XM6+Md4SmGzIyOl9as9iFaZg3W7LtDPDeI65VWca+4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654152; c=relaxed/simple;
	bh=lBpaXWUEvYNR2aNKdlqYhar9AeTO4n0l0H6F+5qwTTA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ReG7S4xo6AhdUwYGhCQZdbKKaO021d6fmdbeXUPyoI8ZtbySlyZ2KWf+gr6M9rBeEdiQ2hIZDU15i2TMlAu2P1LeiHoboTVOjpwhJdG6RRKSQDZLgbShzvCYXnsCXU5TIEl2Mxb1lqzYGm7rB0S0+g7jOcb0MmZhZbfNZdZvGjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DQcWw5UB; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DQcWw5UB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747654150; x=1779190150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lBpaXWUEvYNR2aNKdlqYhar9AeTO4n0l0H6F+5qwTTA=;
  b=DQcWw5UBoaqguTlsXtOrGQ8/BE+J6ZBxQpeXcuCsBNA1RM2ZBrRuP9fE
   iCJC6xSDiDdhVqzQRZOXQL6qB9Bt0Fx/rsBiPvtsllqOqS73VunrjSOwI
   cQS4PKbyyEYSjGJKjrNP3PXrFiBU/8VsOGVMP95nMNskpGI97VmiRZsaR
   vYPU9lRihXuz2O9eesVhcqBGCZ7URgnAdrDqagrwN56yZnseVfTTBi7ap
   mvXbexqr1HY9rqVbv5WOR78zF5ucmzSKtDUksfj2OjbiZvAq284lY6UWx
   1xiaSip/Zra6GO4jA5lzO7jdweG2MyzxGTBoACamKvz2bNMn6W1+cSHA7
   A==;
X-CSE-ConnectionGUID: v0LZD5MEQrWCYjJA0dAnOg==
X-CSE-MsgGUID: bQF2aJSeTOSUyAZJrNQDkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="67105528"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="67105528"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:29:10 -0700
X-CSE-ConnectionGUID: q1mhhc+CRsaK8vOcN9hGjw==
X-CSE-MsgGUID: BN/TKgicSHKSkxIigIpZdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="144107022"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:29:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 04:29:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 04:29:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 04:29:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DjFdQRoIgyk+3MFCPIeywCHaN2sNw74UtXb4XMEJIrPwN2foeEftS3OwsqdtERCu0psylT6MqItk3Y1zPjARbWkC5Af5XnDHogPJC937xXlM7Ny/X5errjFbG1zXZoWIW1T0WcfDCSbQ5NWDuU9j7nsm5ic9CFdVnY68ZQzjheA1bszchCbebbgNRQgCv8pPJBmM7OxS3AF2fIBbslA3Wss3vhoDCryrQI1yNMeJPx4VipgWNV9tJPnygEcAPnuHyoBxYPft3eO15W4tlxt/cw5IevEaxhQVzgOyw+PMvDfBaTA8W1UZtKDGH9SSfKKmRSXDAT9de9sT551j8RSIyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBpaXWUEvYNR2aNKdlqYhar9AeTO4n0l0H6F+5qwTTA=;
 b=ZmoAGA0V4ikw5P4TPm2gREnaiIca1ZFlrpKMBqbIUzAYXlcu2EFR/ebo71RcTIRvYt67Eq2b52MU3hBOKSxfPjshIxjRAN90T5uegJH+qWpv4TRsAHfHArpsQNQgKaC4ZINv+5lKV88CqmFTUh+sX5DStIFSSIHWrcejbkDXpp3X0FDkLEsUdCcOYf47bCEXrPNmNCDoAi49rEyYRHHP7W9cg/EpoA8CDdynjpCsdXzAufawyctUhQXVR+X6Mdnmgb9rlOLOzrco+KjmepD5Gl6RXEn1wesdKINZn+65cWSBWZuPpLhd6C/wOtPPWMbU83naHWSiTEi8A7wKYw5UXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 LV2PR11MB6069.namprd11.prod.outlook.com (2603:10b6:408:17a::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Mon, 19 May 2025 11:29:04 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 11:29:04 +0000
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
Subject: RE: [PATCH v5 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Topic: [PATCH v5 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Index: AQHbyI9ne6S3zFxcgE6Pkc3/E4GOd7PZk1iAgAA9mKA=
Date: Mon, 19 May 2025 11:29:04 +0000
Message-ID: <DM8PR11MB575081096D343262E17F53EBE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-3-elena.reshetova@intel.com>
 <aCriAfYTS7Xz3so9@gmail.com>
In-Reply-To: <aCriAfYTS7Xz3so9@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|LV2PR11MB6069:EE_
x-ms-office365-filtering-correlation-id: f49acb30-9f45-46aa-d3d8-08dd96c85c95
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YmlxeUkyY2dsS0dPSTBtWXREMHZWb0dzVXVJeUk3cFFJUzJqdk4rU3ZlODlr?=
 =?utf-8?B?WlFTR2orWGVzNXN0WFk3Z1l1Z3QxSW9YVmovSUJQc0tOQjY4bDhlYmhZZUJM?=
 =?utf-8?B?dG83SGpCUkdXK0tiVFFmaHZYVTJvUVgvTm9SWXorMWFxV1lVRjN4ZVlaRWly?=
 =?utf-8?B?WHIyMXRBWXlpMnk5NlZvMGFrK2hMTnlLaU9zVEFXVGRjTHlhaWtpZGpEanRa?=
 =?utf-8?B?MVR3WjB3UzJRODBPNWVycmhDRGZ1MDFkb0NVMDltem12V1QrT0tPN2dPT3pj?=
 =?utf-8?B?NXpnOGJzN1EyeWI2Y3pBeHZXTHR3ZHI1d2swMk92R1d4UHJOeWhReTJ5SWhF?=
 =?utf-8?B?emEyOUtVeitrKzBHUFVlOWdrK2Y1b1I3YlVHWS9hTnd1b2hRRWJFUW53VFlt?=
 =?utf-8?B?QlhwZ0lROUFheTBnamJ0V3ZMMmJ1K3l2WmNQbGc1SXlnY3NJZ3ZwRVNlK0lL?=
 =?utf-8?B?N1pmUGRtaVdBK1VxNEZsUkJzWFdHMHNzekw4WlhDRFlmMmdpRk5HMWhQSWIx?=
 =?utf-8?B?T1F6TGVpTG9wM0E3WE9oMVFyU1BnQW85NUowSzRvLy9FYUtyN2JsS29VSVht?=
 =?utf-8?B?Q0JNWlBYUS9YMzhNVFhoNms5dStlZ3U1eHh0YVR1SkhhSENPTnQrUEQ2aXc1?=
 =?utf-8?B?RFNtR1c0NU8yQUZ1M2JoV09SZ3k0ejlkUDlVWnVPRnlObk00RURsOW5FMngx?=
 =?utf-8?B?a1ZCK3RadEtzSFdNRlByQjI1azR4a1h3V0JteUcvQTJ0UTd0UE5INkphTzZO?=
 =?utf-8?B?VEQyWm1uQWhGRElyZzVFZVQ3NFgybVJ5OHRvRktscHZUTHg0UjhmM285dGl2?=
 =?utf-8?B?RmJJTTQzbGpRSzF0TUU0aWNKVURzOTRGcUFvekZhOE9HY1pmSFFnZ3Z3UmhG?=
 =?utf-8?B?SGUvWDcvelBraUpmTmxPVm5jNXZoTXhrSE05Q0l5N0QwcXU0WDZWYUpkbytP?=
 =?utf-8?B?bDlFWWFIODVVSGQ1QTM0eldPQmgrck02MDhobFNNaDNiaEM4RUROOVdNSUNs?=
 =?utf-8?B?Q09jNm00bmZyL3VJSWFPQUdFNGQ2UERQRXhqc1J2ZG51aFZDNUY3R0M1bS9S?=
 =?utf-8?B?QUY3M0hlWkY2QzFyS09odHlWeE1VcnBtTjVtbjJQWm83ZDNRRStkbmZxdEJQ?=
 =?utf-8?B?ejJOdFQrem1iWmpMbUNUVVhVTGhRTndpaGoxdEtjSS8rUjl2bVUwYVF0QmdU?=
 =?utf-8?B?eWZMbEZEWlVmWkt6Y0k5RTlqY3J4amRLUXp0aWNON0EzZWRTZGgwZ09kTHhw?=
 =?utf-8?B?djhFYVY0UGFyUUJ3Sld6dU4ySnJuSW1ad0RxeFBCMkhCN09sWlA5c00wS3Ez?=
 =?utf-8?B?STlJUVlmZmJNTHpVU2RaYkxISUpOZ2FuNkhpOXp2YnZZOGJhaW5YQ1VRYzZP?=
 =?utf-8?B?Um9PTUU3azlmN0dnTDVlU2Q0UzJ1bER1QmZJdU1jVzR4UXJIS0xkb0kwNDQy?=
 =?utf-8?B?WUs0emVHVk9mTXJvck1ZdWR0dU5zVXRJS3UvSUR5QjdIYW1vdXhLY0srRmJK?=
 =?utf-8?B?cHlHM0E5Tk83ZnNwQVFxSGl6Y05oTDIwSnZpKzU0d25HRTVSOXZzS0gvOEsy?=
 =?utf-8?B?NVdjMzhDUDdjbGFVTnVlSGdKemtPbFVrVjd1VUpGWEtIWWlvcE04SXovZEJE?=
 =?utf-8?B?TjBqQk05WkV6TGdpUmttUDVGQWtNcDRJQ0RDK2tqTXFqZ2gyZElpRHNvSTJ0?=
 =?utf-8?B?NkY2N2Y4SU9uYVpYbjIzRXVIVlV3K0xxcEVWaWc1Z1dORG5MRm5VZllMTVlx?=
 =?utf-8?B?d0ZlWDJESy9NTTFLWU1hUmN3eGlldEpaSWJQaFdVaStuNm1yQWNzM0lZSGNT?=
 =?utf-8?B?MTlpR1FvUjZKa0RWWkFuNDdUT2o5WTcvelkxY3FEaUttdTJDNFd5am1SeVZn?=
 =?utf-8?B?em9NMlFrOTJCaFRBRE9uc2FHTzh3ZC95QzRvTE5oSUFBcm1Na3pnWENmc0J0?=
 =?utf-8?B?S0NRYkE5YXdSS054dWs1bUJDU3hqbU5JbFdwaWZoUkNkcmlLU3hoSk9NWUR1?=
 =?utf-8?B?ZXdYOHhYQjF3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUJWdGQ5QUFseDgzeDV1NmwwencyYmIrT2libVYvdWdBTURFb3llQStWaFFJ?=
 =?utf-8?B?NWFUaU9wVE9wSE15NmhuZlZOQVlpb1k3UVZLb3dzU1YyRXlPUVV5YTY0d01L?=
 =?utf-8?B?TGtBUVhKTXIxZnk0QlBrSjJZc2FnUmpDYm40aHk1Y0J1b2dhVVZNa2M5UVpy?=
 =?utf-8?B?ZHlXNUpRTFM3VTlPbFo1UERoOFBkbGZSWXVyQko2RTZIQlY0MEViM1ZMNGND?=
 =?utf-8?B?V1Vubis3UU14WmpnOTdKd2poaTU1b1UyTXlZUWdqWi9nV2w0QkhSWGhPWVoz?=
 =?utf-8?B?ekhJVlRsVFRDSlpYSGtUMVpDZmkzYk9TajJiNFJ0Z0h3OUY3bzR3ekdtcHU4?=
 =?utf-8?B?UnhaQkhBZURDSkgzOGx1Q011bENlcUhLNzZQZzMvWmZvT0EzbFRia0JDV25X?=
 =?utf-8?B?TTJKNW5ZNWVqRTA0ZDlUSHJKck1ObWVtUkhJWlhOSElQSE5qZnVXTENNSTdS?=
 =?utf-8?B?Sjh5YnRaQmFjMkVhZW1mcEdqSk9ZRGVvT1c5UzdhSURRbkwrY2Y4MkhYRXBy?=
 =?utf-8?B?NnFxZU0xQ1F3MXFsR0NKOXlqcHhUN1N0b1U0bzhuS2JwcGdyUnJsMDd1bHp1?=
 =?utf-8?B?M09pYzJkSWh1WHAvcXBaSm9PS1RPdk5xSGZybFhmM0krTWlsQmVKMk5Ec25U?=
 =?utf-8?B?VFNTbEF2UkRDeHF5aDdDQVgwcHBsMksxdVR2Zkk4SDN1aTRpY1NkV3lLamVI?=
 =?utf-8?B?ZzhndXRQR0hlNi90YkIwdmQvVUJZRFFpT2VDOGdOT1pnazdob2dYTWdEOFAw?=
 =?utf-8?B?Y0o5Y2JDeVF0Rjg0emZUQ3UwL0x1dFJKY3VaQ2UrMjV0NXFUajhEQUlUeHdn?=
 =?utf-8?B?WmFyNUNhUktnU1VOVXRZaGdXZjRVeGptd2ZwUGV6MHhJazdhTzVnSk9xM1Jo?=
 =?utf-8?B?a1dQeFhQbHllQ2NuVitvU3hTN1A5T253NXc1amE5QThhUEg1dnhwK3UyVDg3?=
 =?utf-8?B?ejFMZ3Z2UEY5UHVMNzBoRE51MDZEVU9wR3BMenhGZThxQzRyd21iRnNQVkdx?=
 =?utf-8?B?QzRpOWtidnRrUmhyQXNrdURRdGZUWXZvZE5WUmk2RzBoTzBnVWZDZ3A2L1Iv?=
 =?utf-8?B?dWF3WDc0MEs0Q0lMcGJ5dk51V205cTJPRXhJUERRdnpleWtvc2lrU2ZuVnU2?=
 =?utf-8?B?TUczTWwvL2p3clhLSktXcnEwamQxakdQbjJvMjJsaTgybU9lZjl4c1VsTXNu?=
 =?utf-8?B?MjdrVUUrRWkyK0pjOFp1OWNRUmxTS3pvMEUzd0lwNHlSZzRDeHI2NVBydlBJ?=
 =?utf-8?B?T2kvNG5sUHJoMmE5VTBEQ3Z4NXpMMnk0ejNtak1hSGJHNHQwaHhhVVgxOHlB?=
 =?utf-8?B?cEY3VGFrdU5QZlRmS3RZOW9oRkRRTWVVcWJ6aXR6d3pnZkZWa0RnTUdTYUNJ?=
 =?utf-8?B?Z2tXTUtmUFh3Z1FLVVYzRGRSaU5QUkk2TnZaM01RcXlScXNMc0xwbnpNaGUy?=
 =?utf-8?B?d2JsekEzdmlRZXNrVmwwVkx5SUJtZEpiNkdJZHpOc1AzcFBTOHN0MGRRTmMy?=
 =?utf-8?B?dDZPSlNkYVNQeEQ0SSt2cy9PdkwwY0wzQ2tVZm83ODVCOWpRUTEyaHNQVytK?=
 =?utf-8?B?VXdmbWRlb0JoY0JIOW9lSDRQZzU5eFV1TkZDWlF6QktkbFhHOU1vVnhhem81?=
 =?utf-8?B?cERySFIrbTN6TFZZWGpySFFuK1lIem0yT2RmRWZFTlFTYURtbU1VUE8rL0VQ?=
 =?utf-8?B?MGErcHpsblJNbUJwWHFPVkdjbzQ0ZEc4K080bCtORUFsNXRPQlQ4QWRObENF?=
 =?utf-8?B?NlhPM0Z1OGs4cjNCRDdGSEpQNDErMFN4aFBQOStHRE5oeTNnbDF1U2R0VUsr?=
 =?utf-8?B?VFJwVkNvNmczdkZZa09PTjloK3pBQk9CbUpuTW9ya2QwQ1hhMGF0d1RBWG9j?=
 =?utf-8?B?YVBDRVh6V0ZoYm9KQW1VVXVwQ0VoMXdETHZUZ0ZPcEU3WVFxd2lMU0tuUDg5?=
 =?utf-8?B?TnNkQVhUWGh0QUZidnRMZHV4SVZuYlBqRkhQZUUxejJzTUtHNEpsbnlCU1J1?=
 =?utf-8?B?dU92YWxmc21yV3JLSUM4RnJnSW41dW1LYkJlSEo5SmgzZ2poNGowdFZTRkZY?=
 =?utf-8?B?eVk0T3AxcE1SSmE5L3RGUWREeG8rVVR2WW10bWdONlhJNTNLTDFOcDhBOG11?=
 =?utf-8?B?dkwrMmFta0pyTU8xd2s1dVFtbXpCb2MvT0o0ejR0aWxETHVvRDRpbHlyQzNx?=
 =?utf-8?Q?6PRO6XhxicKxm1+VWQrqOWI7Q7PcN9Ila/scZ+z5SOdM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f49acb30-9f45-46aa-d3d8-08dd96c85c95
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 11:29:04.6788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0q7/tFZLyLziRNjrCZww8k0gZi8bWO50NkbvenSeeXW+IIuAB9dqMfT3NcFJDRHC197gqKfFa8aVrmT9wP4bonL2fzIxVI+uHDmEsacV4vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6069
X-OriginatorOrg: intel.com

DQo+ICogRWxlbmEgUmVzaGV0b3ZhIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPiB3cm90ZToN
Cj4gDQo+ID4gQWRkIGEgZmxhZyBpbmRpY2F0aW5nIHdoZW5ldmVyIEVOQ0xTW0VVUERBVEVTVk5d
IFNHWCBpbnN0cnVjdGlvbg0KPiA+IGlzIHN1cHBvcnRlZC4gVGhpcyB3aWxsIGJlIHVzZWQgYnkg
U0dYIGRyaXZlciB0byBwZXJmb3JtIENQVQ0KPiA+IFNWTiB1cGRhdGVzLg0KPiA+DQo+ID4gU2ln
bmVkLW9mZi1ieTogRWxlbmEgUmVzaGV0b3ZhIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0K
PiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlcy5oICAgICAgIHwg
MSArDQo+ID4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2NhdHRlcmVkLmMgICAgICAgICAgfCAxICsN
Cj4gPiAgdG9vbHMvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaCB8IDEgKw0KPiA+
ICAzIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9jcHVmZWF0dXJlcy5oDQo+ID4gaW5kZXggNmMyYzE1MmQ4YTY3Li5lZDBjMGZhNTgyMmEg
MTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaA0KPiA+
ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gPiBAQCAtNDgxLDYg
KzQ4MSw3IEBADQo+ID4gICNkZWZpbmUgWDg2X0ZFQVRVUkVfQU1EX0hFVEVST0dFTkVPVVNfQ09S
RVMgKDIxKjMyICsgNikgLyoNCj4gSGV0ZXJvZ2VuZW91cyBDb3JlIFRvcG9sb2d5ICovDQo+ID4g
ICNkZWZpbmUgWDg2X0ZFQVRVUkVfQU1EX1dPUktMT0FEX0NMQVNTCSgyMSozMiArIDcpIC8qDQo+
IFdvcmtsb2FkIENsYXNzaWZpY2F0aW9uICovDQo+ID4gICNkZWZpbmUgWDg2X0ZFQVRVUkVfUFJF
RkVSX1lNTQkJKDIxKjMyICsgOCkgLyogQXZvaWQgWk1NDQo+IHJlZ2lzdGVycyBkdWUgdG8gZG93
bmNsb2NraW5nICovDQo+ID4gKyNkZWZpbmUgWDg2X0ZFQVRVUkVfU0dYX0VVUERBVEVTVk4JKDIx
KjMyICsgOSkgLyogU3VwcG9ydCBmb3INCj4gRU5DTFNbRVVQREFURVNWTl0gaW5zdHJ1Y3Rpb24g
Ki8NCj4gDQo+IFBsZWFzZSBiYXNlIHRoZSBwYXRjaGVzIG9uIHRoZSBsYXRlc3QgeDg2IHRyZWUs
IHRoZXJlJ3MgYmVlbiB0d28NCj4gYWRkaXRpb25zIGFscmVhZHkgaW4gdGhpcyBhcmVhLg0KDQpX
aWxsIGRvIGluIHRoZSBuZXh0IGl0ZXJhdGlvbi4NCg0KPiANCj4gPiAgLyoNCj4gPiAgICogQlVH
IHdvcmQocykNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9zY2F0dGVyZWQu
Yw0KPiBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2NhdHRlcmVkLmMNCj4gPiBpbmRleCAxNmYzY2Ez
MDYyNmEuLmE3ZTFmY2VkY2EzYyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NjYXR0ZXJlZC5jDQo+ID4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9zY2F0dGVyZWQuYw0K
PiA+IEBAIC00MSw2ICs0MSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgY3B1aWRfYml0IGNwdWlk
X2JpdHNbXSA9IHsNCj4gPiAgCXsgWDg2X0ZFQVRVUkVfUEVSX1RIUkVBRF9NQkEsCQlDUFVJRF9F
Q1gsICAwLA0KPiAweDAwMDAwMDEwLCAzIH0sDQo+ID4gIAl7IFg4Nl9GRUFUVVJFX1NHWDEsCQkJ
Q1BVSURfRUFYLCAgMCwgMHgwMDAwMDAxMiwgMA0KPiB9LA0KPiA+ICAJeyBYODZfRkVBVFVSRV9T
R1gyLAkJCUNQVUlEX0VBWCwgIDEsIDB4MDAwMDAwMTIsIDANCj4gfSwNCj4gPiArCXsgWDg2X0ZF
QVRVUkVfU0dYX0VVUERBVEVTVk4sCUNQVUlEX0VBWCwgMTAsIDB4MDAwMDAwMTIsDQo+IDAgfSwN
Cj4gPiAgCXsgWDg2X0ZFQVRVUkVfU0dYX0VERUNDU1NBLAkJQ1BVSURfRUFYLCAxMSwNCj4gMHgw
MDAwMDAxMiwgMCB9LA0KPiA+ICAJeyBYODZfRkVBVFVSRV9IV19QU1RBVEUsCQlDUFVJRF9FRFgs
ICA3LCAweDgwMDAwMDA3LCAwDQo+IH0sDQo+ID4gIAl7IFg4Nl9GRUFUVVJFX0NQQiwJCQlDUFVJ
RF9FRFgsICA5LCAweDgwMDAwMDA3LCAwDQo+IH0sDQo+IA0KPiBTbyBpdCBzaG91bGQgYmUgb2J2
aW91cyBhdCBhIGdsYW5jZSB0aGF0IHRoaXMgbmV3IGxpbmUgZG9lc24ndCBmb2xsb3cNCj4gdGhl
IGNvZGluZyBjb252ZW50aW9uIG9mIHRoZSBzdXJyb3VuZGluZyBsaW5lcy4uLg0KDQpXaWxsIGZp
eCBhbHNvLiANCg==
