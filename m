Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AB0248F47;
	Sun, 10 Aug 2025 23:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754868592; cv=fail; b=My6K7s5n0jTY25XwzvEM7mPKDVfkMqK6fk4hGMge0RyrlnH2U9dlYKinxJZXopI+6jXQtEdjDMtwi/Ortof3355XqWZ29714XigzXoFYWMRFkVzBzriJZ8udFks5s9ZPn5EnhCqKDJvvcr6s24ZIANg15t8E/t+0CEgCGtU27tA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754868592; c=relaxed/simple;
	bh=Rdukvge5Oy3fIposQLVLCCMzNvpKe98GjtrwP++E0Ks=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YJGMXF0lsMCOnDnIblAl5QPPIMEuzqrRudSXX7pqBsKkIElqiTYgq7b/6fT/UT0mwkxhzvG1zY9wVqQmbCxkTkbONFVD9eayHYYXwWeqUQofW554J3inK4hhr0R5xiVhfvzoOke6OOH4qKzySlb8qYkRMq7wbAzeCRvZLSZACTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FU2iNMb8; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FU2iNMb8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754868591; x=1786404591;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Rdukvge5Oy3fIposQLVLCCMzNvpKe98GjtrwP++E0Ks=;
  b=FU2iNMb8a+5leI1cNDMQTiD8deiYe+ZpPc2qF8dXnKfJbWTh7gd1m3s4
   2FufhewHQEsb2OUXGfBAX+948K/5cQzKNCXDSdwSk2MbskdGdPy3PtlWH
   98nXzaDReTFF8tVU+uevfIXqhZARPhn/C6XE0QApM6oDA5nN5klDSdG9v
   6IYvOnWWWHgCEG7KPQM0bOKtp5awbrjkMbI7X4N3GXNnZo2NSy74aaHxX
   YZsZTtknjGgPlLCF1ohTyGbR3GnNoWW8JbXC0Y+JSa3JsDAwpejrpDpl3
   jNhMDHbB+FHaBZ+/sfnPIsh3IbnRtsRic2UQh/fvWV/MpgHfASq4GwYNm
   w==;
X-CSE-ConnectionGUID: dOLNexxJSfSAtbNT+/xZfw==
X-CSE-MsgGUID: NKxi28yERKGhjbcT5bHTCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57042687"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="57042687"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 16:29:51 -0700
X-CSE-ConnectionGUID: 62906hy/Re2/IXFF0xnPpg==
X-CSE-MsgGUID: f5/1yB6KSc68DR+mS/q/cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="169875669"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2025 16:29:51 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Sun, 10 Aug 2025 16:29:50 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Sun, 10 Aug 2025 16:29:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.51)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Sun, 10 Aug 2025 16:29:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B6LbJVrm+KaFuMnuRT8+JojWsXNyu0tx2u3oHhA3Fv/BIhePH0p3rIE9zibNL/lQoV6rUXJxFU7RmYsUtVZljq+ZS5lM5FEyhls9ZPs9rteyzDXK3OiyTrYDrHRdLk9ZvjpsX+k9sOyJZut+DDwq5R1Uk9g1/dF2VbU/AU70Vp+c4Qd6Pv20ZVNRsr5a7OjUWqKvXmAoO4mK7XSXiva59bFtWzKRTCoET4KL5hDK/6RB6iN5YVvGbKOwtwMYoFQWNO55ZBgcOtmRbwwkbU7IqbR+kb9ZkXzhAQ6P/akekORFZar2UuOp0WX3CwyW6DSPPn1WIq9URPdscmY2X4jdkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rdukvge5Oy3fIposQLVLCCMzNvpKe98GjtrwP++E0Ks=;
 b=RttJqA6L7IjhsPUjgHddkXRcBVFEh761YW0GfxrlvRhZkzEUpwkn1SblsAVrNfpIYYpoMCK4o/Co1LFo2N65s0g9jjtoCiI3B5J0ENBAVaAT5RHIUoRPm1jyC+EEVsK4zCU893dt1pguDgHuzabQecyyJtQC/2ZTTk8I8qhyGpWtpqXMp31Uwr6hWIE7mfLyuJiGH/TTaoRMl4MTwyhkiWfN/tdl4jZcTMh2uqIEYCK88CA8XryJcTcEorBeFBpxN/eVm+G/9cuXYPyXO5VMORcn1YjdpqqDhBpwZqiTLYIc5935fxn0KVu5SAp2YW5QUpG3mja66fwr5Zzq9kt6Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by IA0PR11MB7402.namprd11.prod.outlook.com (2603:10b6:208:432::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Sun, 10 Aug
 2025 23:29:47 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9009.017; Sun, 10 Aug 2025
 23:29:47 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"mingo@kernel.org" <mingo@kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v11 1/5] x86/sgx: Introduce functions to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v11 1/5] x86/sgx: Introduce functions to count the
 sgx_(vepc_)open()
Thread-Index: AQHcBqodaLJFFlxscEecQOaRuNjElrRWSScAgAJNQgCAA/mQAA==
Date: Sun, 10 Aug 2025 23:29:47 +0000
Message-ID: <8d67cbcff50370e2b40d6229b6106f51883a7907.camel@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
		 <20250806081344.404004-2-elena.reshetova@intel.com>
	 <048064e70c57f95372f8400522914f3ddbc6b94a.camel@intel.com>
	 <DM8PR11MB5750D6FD8A6F724BECBCC059E72FA@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750D6FD8A6F724BECBCC059E72FA@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|IA0PR11MB7402:EE_
x-ms-office365-filtering-correlation-id: efc1854e-86fc-4ecb-0bc3-08ddd865cb6e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NFhqR3MremQ5dE1kd1lqTDUwMTIraE9sL0VXenVLVzBKUDd0a2x1Vjg0VXE2?=
 =?utf-8?B?UmN4UURJWXlEN3E0QjNjb1pXZ09zRkY1QmJEVzJYVCtSb3RpZnlaaFlnMm9X?=
 =?utf-8?B?WVltYURnZC9sVXNXQnhzTWF5Y3Z0SFM0VEpndlV0cmQ4WkR0Q3F6RkJLT1Vm?=
 =?utf-8?B?c21FRXZWWjNnK05kK0dCYUxFSzBiM3NwZVVzTnQvMEZ6OXFaZDk0WTU0WndT?=
 =?utf-8?B?L2g5VnkweTlMMGtyWGhuQnB3L1VocHpMN0d6MzQ5SURnZ1AyVWNZU2N4RFI3?=
 =?utf-8?B?b3c4aWZEVGZTdlN2NDJUcG5Ka0VWZVI2MkZrbkkyVi9raEpaRTdzZWs1SGRD?=
 =?utf-8?B?SGw3d2N3aXFMYTJUMlg1RUFKNG1YOGNjUk4vNnh3R2xLa0pyeTVVV3pNaFQ4?=
 =?utf-8?B?aDFCWWVSMlFWMTZRcHpJc0hObVNPYlJPbi9Ca2pGQlI3SFRYVEpZR0lsZytl?=
 =?utf-8?B?bUpwa3EvSWFQZmJsVmJZamFaZXBlSFZORk5wZ1NUdWpvT1Brc3FhOU4xZ1Mw?=
 =?utf-8?B?VUdjbE5qTHBCcHk2YVAyWm1aSndabW5kcFdSU1Vhb01mNmlqMmpkallaeThh?=
 =?utf-8?B?ZGUraW5VamoxZEZzcHprYTRlc2FxcEVuanhieWZrdjdMaWN2MUpxbFNzUC8w?=
 =?utf-8?B?VHAxczJxeVFnY3p2WFI5YXBKaVU1ZUUxbHNaVmowa0lHNDA1NUJOSERmTEox?=
 =?utf-8?B?aGtLM1d4b3grcitwc3VtQnhyRmY2cGIzdVhQVUlvRHdHdVlkZlZTenJOTHFC?=
 =?utf-8?B?ZEZXMVM0RkFWK2dUaGcwVGd0MXUyb1JQbWNydVArK1VQS05KM3EvT2JWZFdY?=
 =?utf-8?B?aWZRVlEyVitIZ0RGSTlROXZMVnVVeC9MOElYeGtPSjNmbWxLZ0VibWNHZ0Ft?=
 =?utf-8?B?eTIzWi9JVEhnRTdnWFhvbDVqak9qaE4yTFp5dVl2YkZIS0F2T1BBMzhrSG5Z?=
 =?utf-8?B?THJaeXVvdXpWdTdJTnNkZmVPb0FvOUs4ZTYzT3d3Q2huZHZiK0NuWFNISjgw?=
 =?utf-8?B?aWtMMUhWZ3l3OUV4QVpoQ1k1Yk5LbXhMUG51QzBEc09GbEtLOGVNSHYyTTZa?=
 =?utf-8?B?REt4S2p0K3RxNEpybXo1SHdpdlZDZDJ6aFA0YlB4TFQvUjF4NUJvVmg2YTBB?=
 =?utf-8?B?ak1kMWh0QmtSUHF6SE5PWXk3T0tXcFp0NCtzdGNhU29iZ0l1R24yRmhNenls?=
 =?utf-8?B?Q1BDMi9QeGIyVHZ0V3JlZWNSZmc0UVc1MzQ2QUdRREl3bWErbzlXTUlyQVIw?=
 =?utf-8?B?dzVXd0lCQkErWkZCcExGWUVVSEpwcjNrdnp4YXJjWEt6eCtiaStLZXV3bmdO?=
 =?utf-8?B?dkl6WFhuSkhTK2dFWHBDUUtsRkNwMi9CbUFGOFlmWXVNQ3A1SDlKdkcrQ3Fq?=
 =?utf-8?B?dkxRcngrVzNDeUwxV0djVk9qMkNhbzI3TWJxWmZhRkhIS2RVQUROMmJKNWpn?=
 =?utf-8?B?b1d1aDhleVJlWEQvSlNVam4zRkt1NzZUOEtZRndTTCttbWhMMEZPcFlFT2lj?=
 =?utf-8?B?WlZraWJJa0cwWFN0WmF1U0p2cHBOODBjekw3djdxRzY3R3ZrWWM4RHRFRUk5?=
 =?utf-8?B?WmdyclNVL1hjYTIydjcxRUx2Zm1SRlRKSER4WHFyaGQwYXVGdllZN1VTMXBX?=
 =?utf-8?B?SGt3Q3g2enI1QUJqb0Q4VlZsZFZaTjVPUXUwVDZmWHRMWWVVbFJnZVZ1a0JV?=
 =?utf-8?B?M04yMHZiMjhuU1FOVnM0RHZYNUpZLzAwemFxeXRzS0tLYkF1NGZIRkoxelFL?=
 =?utf-8?B?dElhaUI2YmsyRmNMN2pYdHJSb3RtMkdVSEJhbWQrczA2V0lQZlIwdWV5elpl?=
 =?utf-8?B?MVFyYUtCSmVabHREbGI2TENIY1g4S2p3Z1RpSkRqclMwRG1jNmtnUnhrMXdh?=
 =?utf-8?B?cUt0Y0wvcmI5NU5kM2E4WkFPZkpJbDdzaGRYNHd1UGdNbUxNS1pQMnlQODNi?=
 =?utf-8?B?MnRURmw4VjZhcnNONXhUTDZJb3RSMXEzNjlQekhZalkxb0dUcktDaGhxcHRR?=
 =?utf-8?B?V29GQVU0L2RRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlNaY0VRRnRhN29oRVJ0aWJjTk1YRUYwR09COVJpSFFYN2RmZERsS3VSaHFr?=
 =?utf-8?B?K2pWL2owRVhKdHdVUXhjclphbTdGK21JRUtXMXFraVBGM2VIZ3Fac1Mzd3Mz?=
 =?utf-8?B?YXVEUXdCWXlXVmJ4M1FNQWJxQU1iYjBZWHEyMGZWbTk5TVNOTW00TUl4RFNw?=
 =?utf-8?B?QlV3VXdyRGUvZnRvV3Nrb1FFbW5xNlRVbFJJQ0lCYmhTQzU0d0NBUVkxZnhH?=
 =?utf-8?B?SDRFNGJ0T3pSaysxaXlJczVkS09iMDJIL0Y2aDRPWFlSTjBwNzEwQ29qTitm?=
 =?utf-8?B?UkluWm9QMlNCcjBpWi9JaWlEVktuZmVFWno0WnZ0WlNLeTdyamVRclBmVVlH?=
 =?utf-8?B?OEJ1bm5HWE1kZ0ZUbmc0bTZTZnIxY2FGckFENlg3S01RNzJnOUVTbUlLTm9r?=
 =?utf-8?B?QUVLZXYzNG9vblQ0ZkJZc3Rxc3BoT2N5cDN6dmxJVFNJVDRPS2kxSjc3V0ZW?=
 =?utf-8?B?ZjhoanNvcXJndE9ocVVzTmpkc3p1cktXTlQ1a1Z1WlpJSmhBOTNWdTcxNWwr?=
 =?utf-8?B?ZC9qT0Y1WUNBUjdmZzQyZWZYRG4yTWsxays2aDMwVUtkdlU3cTh1Q2VSOEVQ?=
 =?utf-8?B?OWkyV2V2U0V3OUlRR2NmQmV0MllUUFZjN3grYUpLOUQwTlJhT0Z0NkdtQVFw?=
 =?utf-8?B?enVnN1FhN3N6dm1UQUhiSnc1WkJyWUJwTlozK2VWd0llZWZlYnRzYjN0MDZB?=
 =?utf-8?B?KzJJclVyM3VyWm5aSE9USGpObjB1Nk1vVWljL0hRcXF2OExtMTFDSGZGZFdM?=
 =?utf-8?B?SlBwazlORTJvM3BFTnh2RFZjOHJUYkNKYU54K2Q4eS9tZGtaOGRuMzZLeENh?=
 =?utf-8?B?UVBhRkFqeW5Tb3pwUFJkUWVSUDkwRzBFUGN6OFhBR21KSDI0QW5YQnVicGFr?=
 =?utf-8?B?djZDVktNcnI3cGJrNGx1c2lRVWlncXFGWHJqM0lkYTBwR2g4TCtHV1ZEY1Bq?=
 =?utf-8?B?T3hzME5tem56L2xuRXdRR3dxUmtLbkZ2NnBNNG9GZFlwaThXNTBUWW9kOHlI?=
 =?utf-8?B?eG8vNGZHQXBIcFVQNHZYSDhJZXR2cWJPS3NFSU5DdDZ6U2tBYXBsNGZYejJE?=
 =?utf-8?B?ZnMraHI1S2ZaY0Zjd2QxaWkrSHNVczB4ZG5RZzZPayszd1RNTkZhcHNXSGt4?=
 =?utf-8?B?UjM2b0N4Z0t3YjViQWZSeXo1UHZxSklia2FxZC95L1cvSk5PaTBzZXBpNVJw?=
 =?utf-8?B?Tk9EZnYya0hHUW1hRXBYQTFuTGZObjdudXVjeFY1bHdOenpNNXlMbEJGamdq?=
 =?utf-8?B?YjhHZU5UVk0vaGJuZk5GOHBWcWtkdlA4cHFaWW0zTEdqL1J2dFFiTzFXUjA2?=
 =?utf-8?B?ZGFwalFVRWZPTi84QXNJSDVtc2EzOW0vV055Lzc2K3lCSmNoN2l4cXJuUU1L?=
 =?utf-8?B?TDl3bHluZy9PamY2b0svb3RXV0ppMGJHU25KbGptWFFUV0l0RjZVL3hwelR3?=
 =?utf-8?B?aks4ZTJqa1RMaHcwWmoyVTM4WHNQNmN3VEtoOEFYRm1DTkgzajF6RmIzRlN0?=
 =?utf-8?B?MDNadEhSaWtFc2FvTzUySDRYNzNwY2d1bVlGcUVUZ3lMVGlvcnk3aDQzcmkw?=
 =?utf-8?B?Z1htV2FHVzRyUU04dUtieHBNd1hTc0Vud0NXZUxYc0RHU0JaWjdmOVRsQXRW?=
 =?utf-8?B?Q3JabnhERlNQaWtWaEZocVorb1JIZ3RSbE56L0w0REVsUTNPUldlVVB5NGhC?=
 =?utf-8?B?enRqVUJrbXUrU1dxbis4U2ZyRUZsRnorcWswdnZuMU5aSkZqQXZSRnZoK1dF?=
 =?utf-8?B?aXlTN21IVEFiRTMxcHFaYyt4WHBaUmJjQVVobUdxMnZ0cjVXL0ZjdC9BRlFJ?=
 =?utf-8?B?aGc3U3dDTTFuWlFzNVBqbmVDb3RnQ2VkL2JRcnI3WmNpRlhxVDNnS2xZL1ZN?=
 =?utf-8?B?b2tNSkNsVGZFWm5DZXlPaEtxOC9hc21oY0ZlUTZkV0NwRFc2K2ovcFZMR3o1?=
 =?utf-8?B?MndsVTd4LzJ5NE1IUW0va3k3S1lVdW9FL1VZa1VNamIrS2RDVndLSS94aUdP?=
 =?utf-8?B?Y2JmRk4zdktzVjlLSjFFY2pLWitzMHdqY2RtOVQ3QzNHT2hSZjJYTndUeU1t?=
 =?utf-8?B?T2U2SS9KVU9rSGJMc2k1OE9yU2ZaS2VaakxnMkhGaHVMbzgzVnRoQ2lBNEVH?=
 =?utf-8?Q?O6nyAxgsuEahVtMFgV4N9THQP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E649920F2BA78449E14050CAFEEEA38@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc1854e-86fc-4ecb-0bc3-08ddd865cb6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2025 23:29:47.2259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h0MjcwPF0+XnMSExdfjQbB7XTV66XyvMd/XBiiQDaLo7mxtkKtu6P4YPV5f9+tdL8gs/D4VLhHwjEbpMSQI5yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7402
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTA4IGF0IDEwOjQ3ICswMDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3Rl
Og0KPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2VuY2wu
YyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2VuY2wuYw0KPiA+ID4gaW5kZXggMzA4ZGJiYWU2
YzZlLi5jZjE0OWI5ZjQ5MTYgMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC9lbmNsLmMNCj4gPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2VuY2wuYw0K
PiA+ID4gQEAgLTc2NSw2ICs3NjUsNyBAQCB2b2lkIHNneF9lbmNsX3JlbGVhc2Uoc3RydWN0IGty
ZWYgKnJlZikNCj4gPiA+IMKgwqAJV0FSTl9PTl9PTkNFKGVuY2wtPnNlY3MuZXBjX3BhZ2UpOw0K
PiA+ID4gDQo+ID4gPiDCoMKgCWtmcmVlKGVuY2wpOw0KPiA+ID4gKwlzZ3hfZGVjX3VzYWdlX2Nv
dW50KCk7DQo+ID4gPiDCoCB9DQo+ID4gPiANCj4gPiA+IA0KPiA+IA0KPiA+IFsuLi5dDQo+ID4g
DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC92aXJ0LmMNCj4gPiA+ICsrKyBi
L2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYw0KPiA+ID4gQEAgLTI1NSwxMCArMjU1LDEx
IEBAIHN0YXRpYyBpbnQgc2d4X3ZlcGNfcmVsZWFzZShzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPiA+
IHN0cnVjdCBmaWxlICpmaWxlKQ0KPiA+ID4gwqDCoAl4YV9kZXN0cm95KCZ2ZXBjLT5wYWdlX2Fy
cmF5KTsNCj4gPiA+IMKgwqAJa2ZyZWUodmVwYyk7DQo+ID4gPiANCj4gPiA+ICsJc2d4X2RlY191
c2FnZV9jb3VudCgpOw0KPiA+ID4gwqDCoAlyZXR1cm4gMDsNCj4gPiA+IMKgIH0NCj4gPiANCj4g
PiBHaXZlbiB3ZSBoYXZlIF9fc2d4Xyh2ZXBjXylvcGVuKCksIEkgdGhpbmsgaXQgbWFrZXMgbW9y
ZSBzZW5zZSB0byBoYXZlDQo+ID4gX19zZ3hfKGVuY2xffHZlcGNfKXJlbGVhc2UoKSBjb3VudGVy
cGFydD8NCj4gDQo+IElzIGl0IHdvcnRoIGl0PyBJbiBjYXNlIG9mICpfb3BlbigpIHZhcmlhbnRz
IHRoZXJlIGFyZSBxdWl0ZSBlcnJvciBoYW5kbGluZw0KPiB1bmRlciBkaWZmZXJlbnQgY2FzZXMs
IGJ1dCBmb3IgcmVsZWFzZSBhcyB5b3UgY2FuIHNlZSBpdCBpcyBqdXN0IGEgb25lLWxpbmUNCj4g
YWRkaXRpb24uIE5vdCBzdXJlIGl0IGlzIHdvcnRoIGFkZGluZyB0aGUgd3JhcHBlcnMganVzdCBm
b3IgdGhhdC4gDQo+IEJ1dCBJIGNhbiBjaGFuZ2UgaXQgaWYgcGVvcGxlIHRoaW5rIGl0IHdvdWxk
IGxvb2sgYmV0dGVyIHRoaXMgd2F5Lg0KDQpFaXRoZXIgd2F5IGlzIGZpbmUgdG8gbWUuICBGZWVs
IGZyZWUgdG8gaWdub3JlLg0K
