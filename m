Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76C22DEA8C;
	Thu, 16 Oct 2025 06:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760596708; cv=fail; b=mxATR4uZmbuR94gOC55w4IkQCl8WVhTB01A6JnbzpCAB9wdvtZelCgNEoNTFdZxtt+yVeHqpb/gAqYXKW8K+hw7tVxkdolXtrARSidwQia+Bukm6n5bgadFVKjoHfKzDSKdw8dPJ/XJon2t9Rp0oS4uwfZBXkQQ8pGpOSxJ0s0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760596708; c=relaxed/simple;
	bh=CT1+yGQAny4tkHOnsZZU0zyXIsdlTyiUPfXoRvTi0bA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O3IjUvqhNywpA3Ci12sCZHiSTfLexLStPg1H6FkMS1jI2/Dzhb6DW+KXgiJey/G3jwozu6SPp51fIyXIPhLIIAvFqrNAXlQAqg49kXO34/6st4dZ5U1ySMK7sBJmHTai2uLK9EaOZ8ihq/JsZkbihXCl6+oCB9fiiTqLQoUwD3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QU51Ix8p; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QU51Ix8p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760596707; x=1792132707;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CT1+yGQAny4tkHOnsZZU0zyXIsdlTyiUPfXoRvTi0bA=;
  b=QU51Ix8plNCjNusK3DB2hUZuagtMPOCnDhGGKUH+ZaFRkmEe+LCS7UUO
   R8Ayvx98iClwMXL9D9E/iqhzy+CawLzvQ2i3PIXXUDIccrWFprioxAfTI
   kk3I1pT9trLActlkYeAnQBZzCQH0T/Gk5R/B/iQU0avvGOEkpPVL0mQHa
   CsirpJbaL1Gopgd83dMtcYnESS/QxGTLHsaRJBtjmCpU2q1UneVWI6oyC
   Y5bA7/ep+yYetYvtlk3ZLXOcQku5Cepyh0ey8V4O4pBhNuV0ILDSPnqH0
   SBStNLJrZlL2HSWFbQ3NeMhx4fcA2wYK6PInxxqRvIysRy7uCwaK1Pnwc
   w==;
X-CSE-ConnectionGUID: sHcOUF2bQB2/3Dw17fdsRg==
X-CSE-MsgGUID: aj/H/8hNT2u7ZXnAQ5c23g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66611683"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66611683"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 23:38:26 -0700
X-CSE-ConnectionGUID: n6HXrYr9TJStHyMlegfSFA==
X-CSE-MsgGUID: aDc+PK47R+yymsnLwvrp6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="181928074"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 23:38:26 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 23:38:25 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 15 Oct 2025 23:38:25 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.33) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 23:38:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQUuQeu/hOCY1XI7k4ibar93830Hl3+kKkbBLKIoO9RkJ0mi9BkPE6xsjE453oVTNwnX3zo0ZFbTZgZ52K6jlF8Q//T/yd1Y6A0ir6+wWC+/RiKDV42OwPMlgGtnMxbQBhoXfd04NEfKWmz2U7SO+TvrAqe0r4WAuvFWlvARxnYt+mdZfbh6IVJs5zviXiTqoR4WbsW5L9GM7qIZoz7VPf0pVmR5R4hxP8fUrqlGtybkb47+kFhOmQalgPZMW74G8jYDECE0kXcCYV8cZpoTWo4eMA1oWgl0hyPc+pmsIruc0G7Gv8dAf7/FellPvy5FkQDUEdOMvqYxB92PagDXaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CT1+yGQAny4tkHOnsZZU0zyXIsdlTyiUPfXoRvTi0bA=;
 b=frF0nr6ZNkp46w4LbPzEQdq0UDUNSA/0CUpdcPgSFN/oFg+SecldhtA1e9ch0Viu9d6/iw8s4lEcKQskHbHPWGvmcvy6Wx3J6XTZivi04hZu+aqwHQDo+ihizpcglAUw7pjPGOLkJ7CkN44gKmaigUyZs5GRouATiGYIB1pqOI/xg9Xco8mro3Pkkl0M7rmRMT1/EdnHIRbNadhjaP6XBrSbYfaQhkdK/ZsImsVYddC/z8CbKnywPtn5+K7lfubAAjpaVVKF7sre7TpK3JLW/Z2RpGPm9wpm5PskDZpLdfQZ2daESplwFS2DyyOCIPiCf555FK2p4ElEG8u5LliWQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB9495.namprd11.prod.outlook.com (2603:10b6:208:59f::17)
 by DS4PPF0442004E1.namprd11.prod.outlook.com (2603:10b6:f:fc02::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Thu, 16 Oct
 2025 06:38:23 +0000
Received: from IA1PR11MB9495.namprd11.prod.outlook.com
 ([fe80::fb49:1b0e:8ebc:254e]) by IA1PR11MB9495.namprd11.prod.outlook.com
 ([fe80::fb49:1b0e:8ebc:254e%4]) with mapi id 15.20.9228.010; Thu, 16 Oct 2025
 06:38:23 +0000
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
	<scott.raynor@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
Subject: RE: [PATCH v16 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Topic: [PATCH v16 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Thread-Index: AQHcOcOALbIWU1EIjk2Yv6FNR/GCfLTDtSuAgACl/rA=
Date: Thu, 16 Oct 2025 06:38:22 +0000
Message-ID: <IA1PR11MB94954D6EE807C00D5A29E520E7E9A@IA1PR11MB9495.namprd11.prod.outlook.com>
References: <20251010085346.292287-1-elena.reshetova@intel.com>
 <20251010085346.292287-3-elena.reshetova@intel.com>
 <af0ce2a2-8a7d-4a67-a58b-33d01099e75b@intel.com>
In-Reply-To: <af0ce2a2-8a7d-4a67-a58b-33d01099e75b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB9495:EE_|DS4PPF0442004E1:EE_
x-ms-office365-filtering-correlation-id: d7e54409-4800-468d-3c7a-08de0c7e9a76
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|10070799003|1800799024|366016|376014|38070700021|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?bEkxejNUdEMwOHZZRm1qNysvV0J3VXdoN1pqMzRNWnZHWUYxZVRqakFqWVM5?=
 =?utf-8?B?cVpMcmQzc3M5eVpFU2dlNkdmV080ZXFGYzFLTkFZYlMzMWJEZUpsN1VndldG?=
 =?utf-8?B?SzhnVDFObUpzRXQ1Sk1tYTRGbzNLbVNWbEdJU3dVVmJ4bXZtTjdyVC9aNzVy?=
 =?utf-8?B?YmY4V2VvZDlpZjJpUmp6bG9qdzlWa0t5ZnJqNUJzSnppQmhEcjNrS0EzVGdo?=
 =?utf-8?B?QzhiSDBRckVEQ0NSalVQODY1Nlg0ZDZaU0xrbm52VjVoSEk0YkNHZkJTWXly?=
 =?utf-8?B?T3Z6R1NZMDBMY1hCUmR3WGVkTVphcWF1eE9vZVUzK1U5WVVNQWxXR0xCSXpL?=
 =?utf-8?B?N1dMejI1Y0lwSkZwaDdpMVI1KzFJMlpFdFk3Y3ZUUFJOdENyQXRmWXk1aUFY?=
 =?utf-8?B?aExrVjZKWExMdkRlcTNOKzFSMUQ0SFlUUFNxTUt2Q1V6UkJBVjEyd2NKdCtu?=
 =?utf-8?B?dTlDZEFEaWRkT1Zqa1NSWG4xampJbTVVMXVKNnlDem5mRXFUWUltK24zRWJV?=
 =?utf-8?B?M2s5L2pCTTFNZEVSd2JhbERCMTNSZDFIcE5KalBYMk43MUY0QU9kVXZpS21Y?=
 =?utf-8?B?cS91eE9xWFBzS2tXZlFzOUhYSm9HZnpqUklNLzM1bm83U2gwMytTZFlmR3oy?=
 =?utf-8?B?bWxBT1JSbU9GQnpoSzMyWEhKVHdZTlpyQzk4ZlFhbktmaW5FeFQvOW9zNFlS?=
 =?utf-8?B?blZ1RmpWcG1wSW1uNnYxVjNhVjNCeG5TY0lIZG9rRnVtZG5UZ0xmV09OSWVu?=
 =?utf-8?B?aHVCcFBlNVlVdkhWVkp2QWJBdFgrQ2NadVNkUjBTQVZ4TFpLUWxwdUplS2ZE?=
 =?utf-8?B?Uko3Nzh4cEZXNUVac2Fkd1Ixdzk3cmlsS2NzRlh5NkVNQjhJT25CcCtXWmc0?=
 =?utf-8?B?d3J5T2hlVm81dWdWd1YwSDd0TFE3SFU4QmpuSC9oSU4yM2tpLzVZcHpWM3Ax?=
 =?utf-8?B?Y1Nrc2tGQ3MydTVYZE5DRzlINHRWU0dzNHhzc2hlUmJaYW14ek9sTXdHV3pj?=
 =?utf-8?B?UTZCZVR6b0RWSlpwZHduTmhCQ25zdW9qc0o4MmRlcVlBczdFeU9jeGxEb3Iw?=
 =?utf-8?B?RTdvSHdxK1pkZE5YR3lZNGdHWnlqTUVsVGo2OEdkdlNxZ1QxZDJsakRCUWkz?=
 =?utf-8?B?bElrMkhydWNTcDU3ZFpvSFY1clNwQU8xVlVYVUdPQkk5TmRkSUxQUmlQek5x?=
 =?utf-8?B?ZWcwTTd3VFRGdmJJNzNFSTl3TG9EMUI2RURzb2tNcUNscnNxbXNWMGE1Wlo1?=
 =?utf-8?B?d1c4YzZtOFkvK1lyTDc4dE5pRm4rSzF0ZXN1ZEJPWHBiOU9VYzVYcDJEQjBC?=
 =?utf-8?B?RUoxalgvVlBDUjVjTE43b2t1T3k2eFBlMUZZRVNUSjcwS1MxMUpEcU94R284?=
 =?utf-8?B?NW5OeDkzTyt0QTNBTnhsS2FNR25rQ0VEYTNXY0JKM3NGWDJKcFl6NUFjRURm?=
 =?utf-8?B?NFdyNWpYMVI5Kys4dEVhREg5ZWJ5d2ZnaXhuR0xIREF0YVU1RkdQa0hvUWJv?=
 =?utf-8?B?NjdzL3plU2phSnpSZ1JWSE9VTW5CNTB3SkF5RGNVeU12U0tyTjl2VVVQNFRY?=
 =?utf-8?B?Q244Szg2Wm5KTDlkNnJoSW9DYUtZalpXRzRvY1dtTHRnUk9DMitodHhUakVv?=
 =?utf-8?B?V1dkaU5xcnBHQ25wa2RvWlh6QmhBdlNHRUhXOGZvNnJzaS9wQkRJQ0RZaXla?=
 =?utf-8?B?L00yU2lNZHpkZHk5Ukl3dDNRSE9HekxtYlM0cEgwMUpySlIvN2ZmVkZvZWxC?=
 =?utf-8?B?cU9YbjRDZjF6Z3JMYms4eGlCZUZIM3RBL1pDZG5TWTA4dlN1bUtRck1KRjl5?=
 =?utf-8?B?U2FDYzlsN2Jkd2dSUVpaNzhwNXZqdmpYVW9ERlNiM1VYbjhwY25oUlJvK0NQ?=
 =?utf-8?B?UjAwUDZPQU1DUTVRZXJONGg3eFlGNytHdHR6S0xNYm5EQkROM0pUUGZ2b0pj?=
 =?utf-8?B?R3hJRnZkWGxqMVI5UExKK3E5MDdZN1dnQ24xSlBPQ3orZG1UNDJxR0RrajBn?=
 =?utf-8?B?dTZkdllxNjNobEYvMnJJWFVXY1B6azd2eVZ5UDVOejVWUlliU1NnYWJCbjhC?=
 =?utf-8?Q?yd6/2V?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB9495.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(1800799024)(366016)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmtuSDZnTlBVUU1hc1FEWWh1bkhmUTFWNCtoQS9ncis5OXhVTCs4T0Z1alAv?=
 =?utf-8?B?ajQ3emZ4N1BGU0JrdzYwb09qTlhVaFo2bkFoZ1J5N0ZQV25nZHJMNmpXTnA4?=
 =?utf-8?B?dGk1TittcHMzeWNGbFVRYUlkUXBZSmN1bXlOcnNmN01UNDVCMFVidi9GQzlU?=
 =?utf-8?B?V0srMjhxMDJxUWNhdlJydU1naVVLdzZOekFrbFJreHdhSFBEd0w3aTJSRjZr?=
 =?utf-8?B?ME9VTnNFbDJ4RUNxN0Ewd0ZxTDV1QndxSFU2cGludnBXQmtDQnZjb1Y4ZTlW?=
 =?utf-8?B?Z0hSTGcwc01JZ0IzNEdGVzcrdi91UkZrOWNoNXA3ekplazNhWHpQcjgxNGxM?=
 =?utf-8?B?dWVnamNGY0lINXVBQ2QyN3VKMUVxUVlSenh3QlVvNk9QdHMrdHliV09lbmc4?=
 =?utf-8?B?MTZqMmg1N2V1cG4vTlhhb2JnZjlhTWJqY1laNm1UeFpMYUpYcytPby9sVjVG?=
 =?utf-8?B?OEVoYkdrNG1sUU1sZXlLVGIrUVVTQXh5Tm1XZWQvTGFjbitwYWhTanRMVkpO?=
 =?utf-8?B?ZGs2a0NJYjNlMjRybHZOSjA1T0tldlgrRWtiR2FPRmp3VitOWkdGdTlwQVFX?=
 =?utf-8?B?WEJvUVd5MnhQL0RnQlFjNjRHNWh3SHdPb0kwL3JvcGd6bFZTdlA5VTA0R0hV?=
 =?utf-8?B?UXdBSENsTnNzNDJBRjlXeTVrTnI0R3NMTmlxY3JLdEhxZ2U5NUN4eVp2V0No?=
 =?utf-8?B?S2JVZmVkdEErbUY3T2Z0STR4YTlHOGFMWDVsMElMUXRlc1M2OTh2N2VSeXRq?=
 =?utf-8?B?dmVxSlc0dnFiU1ZqOGc4N2hYRHpvL0tTU0t1cDZWbnFwYSt1Y2pwTThvcHJO?=
 =?utf-8?B?d1krWk81cG1aZW44VGRjSWJnV3VmNW1pYVBCTjdKRnYxWlV0cm00V2NMSytw?=
 =?utf-8?B?aUhlL25UNjZxOVlNTHN2cWphVnpkM0N4UHpKdDRFc1luYVp1K3FzTnRveHNh?=
 =?utf-8?B?c0dsQmZXaHp1Y1prWEUxRCtKSW9tU2hzalF1TnQvMUNFMUxzbjBPcFUwcWYr?=
 =?utf-8?B?bFo4Yy9VTDJXWFRNb0R3azc3QmgyT3JwTkxNcXo1dlQvbHFmOHI1MndHM1cy?=
 =?utf-8?B?OVp5bG9XVVNvY3c5QzZhWnlQMytYQS9RU2pqOHc3WE51MHdEOHovTDFuODA1?=
 =?utf-8?B?ejRna2dWNjlSSzdHaXVuZFY1Ymhvb2VUYmozNWNOZTY4cmhrbWt4b0N0UTRC?=
 =?utf-8?B?NFFDZ0JFN0k0cVQ4N0x5MzBiYzVITmtBby9zSVRPMGtjMHV4ejRscm9PSERt?=
 =?utf-8?B?ZkVIenVJeGZnZjNKTHp1VFBVNlBqemhUZDVjdVVnL25OUEdYZmlyeC9hUm14?=
 =?utf-8?B?WERwOFhRNEp3Y2dpeEV3ck1BMUp5NGVDZExWYzhRNlRHS1pPK2F4RmltSE9u?=
 =?utf-8?B?QjN3dDJmWkF3L0c0eTU0M0VNamN5WXFwZ21ReWVDcHFFYzFGRFdOVHp4SzQ3?=
 =?utf-8?B?MGZ1WTdlb0dHcDA2N20veUdRYzE3OWQvaXhLanYxRWNZbGM1YzlQcmxNUmI0?=
 =?utf-8?B?WXZxOVk1bEM3c2I5T3dOSmtXRi82Nys4eTl5aTZJUDNsS1Y1VldqNzlNblhY?=
 =?utf-8?B?ZHlKLzJFOTJ6Rm1DMXJDbmVDdWdoVlY5ckc5N0dMc1VhMkwrYUhIZXMyV1l2?=
 =?utf-8?B?RGVWS1hkZndTNFlzOCtQWGxRVmFsWDZmUlZmTzEzMEhQZmJneTdaMDB5L2tP?=
 =?utf-8?B?WWNuSlBGd2k4ZVpUc2NaaTBCWk01S3JhMC9WY2NIcld6cGMxcHd6V1V6cmU3?=
 =?utf-8?B?dkhsdTZ0dFl6L3I1dFJvbWtEK0dCZUxzOVNZT2ZOd2hYZXRLdEdiNWhidng1?=
 =?utf-8?B?Z1U0SnJCdFBFNDlkM1diMi9COTFwR2lGUE1tSS92YUorVXpPMTM2aXpiZ24y?=
 =?utf-8?B?RnovbzRPVjRrTW1zbUN4STdtM0FNMHB1NnhtMWxlYmFqeE96eGFONHk0MDc4?=
 =?utf-8?B?OEM1c2E0RXNsbEQxdHNyUUFTU2JXTzRHcXdTOXZDRjBhTk91U3Y3ajY1WXZT?=
 =?utf-8?B?VlhuSTV5eUk3QWo0TmhLWUU5cGErZG1PRS9iYkdnU3l2N1hVN05KWTR0TTlC?=
 =?utf-8?B?YTdISXlRVXF0T1h0WUswTkY0dDhCb0x2L1hDUVh0clVsUGY4amVDMXJKNFlF?=
 =?utf-8?B?MW95WmNWL0lDQktTeXVIRmdVNk5OQWVHeDFTSHVqZkZSM01PUVVyTzBrN1dR?=
 =?utf-8?Q?JsYuR9N8q6vuoRp8KvJHKTI6Nw9S/pOcyVj5u5Qk78yH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB9495.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e54409-4800-468d-3c7a-08de0c7e9a76
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2025 06:38:22.9671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bRUjyzX5xK3noMubiXtywaXoRy7igH07zWHNQOlw9BTGJ5L7Z7dhTAuKuUyvnGfiR+qwWYV11+OltiMRh7h1Utbyc+FeSTPN17f8I6DQSDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF0442004E1
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGFuc2VuLCBEYXZlIDxk
YXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgT2N0b2JlciAxNSwgMjAy
NSAxMTo0MyBQTQ0KPiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVs
LmNvbT4NCj4gQ2M6IGphcmtrb0BrZXJuZWwub3JnOyBzZWFuamNAZ29vZ2xlLmNvbTsgSHVhbmcs
IEthaQ0KPiA8a2FpLmh1YW5nQGludGVsLmNvbT47IG1pbmdvQGtlcm5lbC5vcmc7IGxpbnV4LXNn
eEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyB4ODZA
a2VybmVsLm9yZzsgTWFsbGljaywgQXNpdCBLDQo+IDxhc2l0LmsubWFsbGlja0BpbnRlbC5jb20+
OyBTY2FybGF0YSwgVmluY2VudCBSIDx2aW5jZW50LnIuc2NhcmxhdGFAaW50ZWwuY29tPjsNCj4g
Q2FpLCBDaG9uZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBBa3RhcywgRXJkZW0gPGVyZGVtYWt0YXNA
Z29vZ2xlLmNvbT47DQo+IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+
OyBCb25kYXJldnNrYSwgTmF0YWxpaWENCj4gPGJvbmRhcm5AZ29vZ2xlLmNvbT47IFJheW5vciwg
U2NvdHQgPHNjb3R0LnJheW5vckBpbnRlbC5jb20+OyBEYXZlIEhhbnNlbg0KPiA8ZGF2ZS5oYW5z
ZW5AbGludXguaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxNiAyLzVdIHg4Ni9j
cHVmZWF0dXJlczogQWRkDQo+IFg4Nl9GRUFUVVJFX1NHWF9FVVBEQVRFU1ZOIGZlYXR1cmUgZmxh
Zw0KPiANCj4gT24gMTAvMTAvMjUgMDE6NTIsIEVsZW5hIFJlc2hldG92YSB3cm90ZToNCj4gPiBk
aWZmIC0tZ2l0IGEvdG9vbHMvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaA0KPiBi
L3Rvb2xzL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gPiBpbmRleCAwNmZj
MDQ3OWEyM2YuLjMwNzYxYzkwNWI3ZCAxMDA2NDQNCj4gPiAtLS0gYS90b29scy9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9jcHVmZWF0dXJlcy5oDQo+ID4gKysrIGIvdG9vbHMvYXJjaC94ODYvaW5jbHVk
ZS9hc20vY3B1ZmVhdHVyZXMuaA0KPiA+IEBAIC00OTUsNiArNDk1LDcgQEANCj4gPiAgI2RlZmlu
ZSBYODZfRkVBVFVSRV9UU0FfU1FfTk8JCSgyMSozMisxMSkgLyogQU1EIENQVSBub3QNCj4gdnVs
bmVyYWJsZSB0byBUU0EtU1EgKi8NCj4gPiAgI2RlZmluZSBYODZfRkVBVFVSRV9UU0FfTDFfTk8J
CSgyMSozMisxMikgLyogQU1EIENQVSBub3QNCj4gdnVsbmVyYWJsZSB0byBUU0EtTDEgKi8NCj4g
PiAgI2RlZmluZSBYODZfRkVBVFVSRV9DTEVBUl9DUFVfQlVGX1ZNCSgyMSozMisxMykgLyogQ2xl
YXIgQ1BVDQo+IGJ1ZmZlcnMgdXNpbmcgVkVSVyBiZWZvcmUgVk1SVU4gKi8NCj4gPiArI2RlZmlu
ZSBYODZfRkVBVFVSRV9TR1hfRVVQREFURVNWTgkoMjEqMzIrMTYpIC8qIFN1cHBvcnQgZm9yDQo+
IEVOQ0xTW0VVUERBVEVTVk5dIGluc3RydWN0aW9uICovDQo+IA0KPiBTb3JyeSBJIGRpZG4ndCBj
YXRjaCB0aGlzIGJlZm9yZSwgYnV0IHdlIGRvbid0IHBhdGNoIHRoaXMgdG9vbHMvIGZpbGUNCj4g
Zm9yIGluZGl2aWR1YWwgZmVhdHVyZXMuIFdlIGp1c3Qgc3luYyB0aGUgbWFpbiBjb3B5IG92ZXIg
dG8gaGVyZSBmcm9tDQo+IHRpbWUgdG8gdGltZS4gVGhpcyBodW5rIG5lZWRzIHRvIGRpZS4NCj4g
DQo+IFNlY29uZCwgcGxlYXNlIGRvbid0IHNlbmQgdGhpbmdzIGR1cmluZyB0aGUgbWVyZ2Ugd2lu
ZG93LiBUaGF0J3MgYm90aA0KPiBiZWNhdXNlIHdlJ3JlIGJ1c3ksIGJ1dCBhbHNvIGJlY2F1c2Ug
SSdtIGdvaW5nIHRvIG1lcmdlIHlvdXIgY29kZSBvbiB0b3ANCj4gb2YgJFZFUlNJT04tcmMxLiBJ
J20gbm90IHN1cmUgd2hhdCB5b3UgcmViYXNlZCB0bywgYnV0IHRoaW5ncyBkb24ndA0KPiBhcHBs
eSBjbGVhbmx5IG5vdy4NCj4gDQo+IENhbiB5b3UgcGxlYXNlIGZpeCB0aGUgdG9vbHMvIHRoaW5n
LCByZWJhc2UgdGhpcyBvbiAtcmMxLCByZXRlc3QgYW5kIHJlc2VuZD8NCg0KU3VyZSwgd2lsbCBk
bywgdGhhbmtzIQ0KUHJldmlvdXMgdmVyc2lvbiB3YXMgYmFzZWQgb24geDg2X3RpcC9tYXN0ZXIs
IHdpbGwgcmViYXNlIG9uIDYuMTgtcmMxLg0K
