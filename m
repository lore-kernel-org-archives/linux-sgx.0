Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9123D170B;
	Thu, 23 Jul 2026 09:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800665; cv=fail; b=dUVlRxsjsx5jAzvI5K/imrjQoe8amC59ZxzSZIe7B6ae7b6W8dHvdsLlwwSjtr+1HCpqic6e7KV/ZAZGGWWHj/bEbwfkW9PHyQohc4wHIhxyA6gypSleCKS8gH2W60e21KvpgkkeZUsiAs7WwB6xeDpPxsPutQnqMMUwHLX+wLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800665; c=relaxed/simple;
	bh=NoZaFUgxpvWQL4kxlsh1T3/6A9HXDI8bIeWAVyz6A8U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kmn+3O41pWoffXI4QuT7aV+Y3UtFuwvA8tdgk+Sct8OMHet1ujwWDv5S4AfweryYCllXm5W70teoOa7RPhq89AQdUWReHO5fv4KPIx7o7UojjLLuvGEFAwETIRIVumkfiXm34AteUZovnVd6pcUqmnmz0f1aFdn75B8b1UYRiUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UM651f0S; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UM651f0S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784800661; x=1816336661;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NoZaFUgxpvWQL4kxlsh1T3/6A9HXDI8bIeWAVyz6A8U=;
  b=UM651f0S6nFmCCetnVzpBMw7MHEqk3ceL7kl7ArEj8HOaXZn3R0NNY3M
   N558NEIn3pv+oZfvIrQFSp2fGKMAOVltZGsRPwKKtrp1hP4oI9GV1trqG
   5YSyl1b8nzRMvAGzqRBnE2ys3pDQDfwKiwMSabH7YYM4FMavK4D8raLLB
   sfq051r5YAofe2UTXAvC8RlohHgu1JBYTawVfZ/46P94pDdRXuEg63V7O
   ESCLhwJuN94yj5iIppYvUIImNoLcGjQI6OcEUvCqgWgZVZfw0yGw3THw1
   3fGOLBu1hDVlSjhLVi1mlO60X1b4bplqwmO9mOyETv78sb1VSbktdL6zU
   Q==;
X-CSE-ConnectionGUID: v0M1AnSATNieshSk23sXCA==
X-CSE-MsgGUID: tiCuR9bYRF6e7aAmxXJtKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="87991307"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="87991307"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 02:57:40 -0700
X-CSE-ConnectionGUID: 3B1xZkrlTu+25rco7NUhEA==
X-CSE-MsgGUID: RP6dH2oVRFycb3ciYUHp1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="282879984"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 02:57:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 23 Jul 2026 02:57:38 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 23 Jul 2026 02:57:38 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.71) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 23 Jul 2026 02:57:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g+4z9EEAqXYy9cl4rG8/3y7tns+2MRBzA1GtTD/fQbn6UrBy/92FfRhtmRapuUzbcETkZRo9Mgf/YOpE3ZSadfHSuIjWQetq8PXJYBP077ZD9qQpFgF7A3GlKekKCfmPA97dgMAFsIQTmiwUzL4YjCqk3ceQJhnAcZpHFEVx+FU857NrI8ov5hDuiV9xs8gflEjFsqJT5YpBl7/TZvZSu7kJH+ucn03ehM49SUjlb5IhqDKNna3XCy7GkFVsnjF4p/0wluDCmvB+5XPgBYzDfug+L5BP2CgVkLpIekpULKigrtfWQyb3ZVjWv9prHIPwuBWmoQPIc4tzxixNXWvaiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYmg+toIFaAjsqYolEN+Jo0VPvHO6mm5kxupHfHAJ+I=;
 b=K+Rj7vqDIUwunDD3U8YM2VTJ+G2CDUFeg3J7LQUhkfli108mYPFTFgssWm6YlwfDgGUUcXbOAuVNivdSdheW3o+GHoi0sXhdVqIFoAd5/n7zh1EhhewBp5cvbgvXuB8SRTq0jQSDRPs5FQ1Yqubu5gopaHJI5oxj1QMSMMCQLcX9A8801hWEp4tRmVE1qTnnWg07zPzVfTzfUvyannXilI18h4ZcUDCWMi0YlMq3L7BcgmsoLkwcnOrdm7DZV0elpXDNpgoX5LseptcgTEAv9Kc/UdXy6rD45f+GU3GQB7Igpjk1RwO6zSbmbH3btJjNZXfNbpx2wS2eOfi4EQ8CUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8455.namprd11.prod.outlook.com (2603:10b6:510:30d::11)
 by SA1PR11MB6758.namprd11.prod.outlook.com (2603:10b6:806:25d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 09:57:34 +0000
Received: from PH7PR11MB8455.namprd11.prod.outlook.com
 ([fe80::789c:dda1:63ec:6dbf]) by PH7PR11MB8455.namprd11.prod.outlook.com
 ([fe80::789c:dda1:63ec:6dbf%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:57:33 +0000
From: "Miao, Jun" <jun.miao@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com"
	<hpa@zytor.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "Du, Fan" <fan.du@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "challvy.tee@gmail.com"
	<challvy.tee@gmail.com>
Subject: RE: [PATCH v5] x86/sgx: Report RCU-Tasks quiescent state in EPC
 sanitization loop
Thread-Topic: [PATCH v5] x86/sgx: Report RCU-Tasks quiescent state in EPC
 sanitization loop
Thread-Index: AQHdCsihjuMu8AA3PUi8sgDhMp0B/LZlNwmAgBXEiRA=
Date: Thu, 23 Jul 2026 09:57:33 +0000
Message-ID: <PH7PR11MB84559DCC54D746868A3424D39AC02@PH7PR11MB8455.namprd11.prod.outlook.com>
References: <20260703084810.145567-1-jun.miao@intel.com>
 <ak-hG4mo57WiP616@kernel.org>
In-Reply-To: <ak-hG4mo57WiP616@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8455:EE_|SA1PR11MB6758:EE_
x-ms-office365-filtering-correlation-id: d9a0dfb4-4661-4a42-39c3-08dee8a0d151
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|5023799004|11063799006|6133799003|4143699003|38070700021|56012099006|18002099003|22082099003|10067099003;
x-microsoft-antispam-message-info: 0giJyJeagq9tOn5KSegDi0hdLOHeZAbARQxo8Pbub9Vrst/q2BBjxhSd1eKTieiQqkSdyCUQmm4HhOPeBrNHOLxQmmdjWMnHry65pvrq2Q2eEdJNzlX1AeLIsCyMp2vbx8ddVImVYcxJzwQrhrnmCr2NBHL9BPvJT2OE3FlRs04ic9eGWeYvzu/Gg0chObQqo3/m3xwQOuiFeCzrRtkZyPPIADb4ZSzLFn+vfLCpImURHxTom+Qj4NC7iBtXRDK1A/kNFOiVKoHooJNs1EIzUJUCMFz680k15WataVrRdN/IP9lhrgNuEJQc0la1geZiSYGa6/pZwfVpQTkaz7PYKZfNsD6lmTKNyciKvigKsp5c05nv8LL4PNYbnLZLzd2eL80MsMIfLxMpfZmxp/ITwps+PCExu4taQ/xLhZMJ4/pY6N6wi860G2uVSRfG5O+HgK++0RH2O4ygjYyiv8qTwibOezFmbUSgNkqzDiPboWhAvFGRqP/4kVuLRWGNgH+g01yw+QhL6T6xciSwBe+1jf1arz7B9terHGrqhrug5xBqsSr171YRssvLCC4EdkV3jUGZP/pDdIIM/NPWSHYwzmjwrtlwQgn+7ov+1tD3Lb9h8zNufuE995rxkVEHj19o3h9Xcz0W4Qk+V7oEEpfigmoJ5hwfsiGiehhozfP3qT5CUm/qoGcRPp3j7fZ9rkNkmcy1/W5niNYj3AuNZM75Im3NYwfcGCNa0+u93KM5oiI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8455.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(5023799004)(11063799006)(6133799003)(4143699003)(38070700021)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ezj9WxsHTY7kt+9XyH/1LApN06oHyT+vnudNPDm9YmRxnOzr5b2J8qIA06Qp?=
 =?us-ascii?Q?gFOkxatYo2uBBIrGpwIF1GdNeOFZDEbHf0W9nFBGU2x3smJ0IF5IzA0+cwwy?=
 =?us-ascii?Q?hgVOfTOjPJiZevlSW3uyQyXXHPpjWfZ01TURiVsbbWI4J+Xh2Ze5O0sXCIig?=
 =?us-ascii?Q?e6j5lYJ8vKwPMrmjpM7fXklrZebMlr5XeVuvjP2IYDldSbWsyIgnPZ1iWpzO?=
 =?us-ascii?Q?eDWLZn8WFfnC0GjsvA48NCL3LSfVUedPxyQTiyzkClNMAqjeLO7JsVghiA/a?=
 =?us-ascii?Q?oAUiieyAIVaSl37tc0Mf6jbbVaNumKER4ZuUQl5nlWFxVQD34JOQ3a2+Js+p?=
 =?us-ascii?Q?X9SJ/0hXLn4wH/1FSNRcoyuZF13UlVbHMQivJ1zrogy+BTf+K494WVGcCeuP?=
 =?us-ascii?Q?ujICwYjUUZ+5LcwOOCV/j0h0b3ZEEHfea7rHCcu3Ef2alK5epjUeMVGnZY+s?=
 =?us-ascii?Q?i84fVlDOQawUyV9e82PLw9ZHJDFj7Bt3BEkRrT1I3lRlDMjH46BmcTIl7Hgc?=
 =?us-ascii?Q?4SHcmWpPG4/B7hkDaJXQznQz9/FUrQzwO3tR5I9vj4T0oAwFxThHc0qaC4l1?=
 =?us-ascii?Q?Sw4wgCKTp6YXtpSVZaRz4Vh2RtiHQoqwed7+/PWyM4/V9uE1Op1auTVMa3uo?=
 =?us-ascii?Q?NBEeMqLZ/+25dM3uY+5jPHOk90ms7j7tWdm/3B2Xx7snbq9tlv9l6uAHArBl?=
 =?us-ascii?Q?kss0vLaYJy+NV81Gn1j1QeDNFXJxXeUSq5ZfSyFVtW3eH436rrxVtpZQ17sB?=
 =?us-ascii?Q?2YP2fDUZ7AcILOQDV8vfE/pL5jACLaxPhgEF1D0W5l7jAVGwjgxvCNTNyo+2?=
 =?us-ascii?Q?nTjfdEpO3hQ4e4IdIIBxmPzZ69qA3GccdCHhpqg2p1l7CAeDQXgjICu7djAE?=
 =?us-ascii?Q?Gd2oyVJH103RBRv7ThaY471hI2SOD1Np72oxDayHLCfWbxV1cjjvuu9K04rQ?=
 =?us-ascii?Q?1w8e1WV5gNxRGufFycFsb8Pb9fQ3kDswYRv9x/qjx9ZfiEkPvV0IayaI0Qft?=
 =?us-ascii?Q?Zbv3Fp8bzdCPmeGXrqQCADH9LBzU1t0Kir/inL04h3mj3/E9t0n2007oQ2NG?=
 =?us-ascii?Q?wVfD4XYsE880mUB+4WhYu/Fxwzhqttitv9CKb5VkXaLQEV1DNTYLknOeGEIu?=
 =?us-ascii?Q?V+VGRZuV84ZpMyYHAuV0i3cfNcv1dmInQXMQU7Uypl+FNYLN3ZKAAwSjM38z?=
 =?us-ascii?Q?/s5qCX8tVE/GUtVHS0qHGRi8erEabkq0m0v6OyEmK4UO1zBSJLJ/PNFBt7+S?=
 =?us-ascii?Q?ZkTYIR/s+3xTQxYQPyLdLod+/WFslkR534rOhLV1uFCSPmrK7MRQHkp5EfnV?=
 =?us-ascii?Q?kjzUQ4kiww3o2wJY5/XPtdf+bnLbXfsHPIP1Jvdzs2beV2kjRlgFq7bzrL7j?=
 =?us-ascii?Q?eoLqv9aTsI1u6xsX0sDTxJHTsqJSw1aANTQAf/Qqq0p65Ws504Bevut0vNve?=
 =?us-ascii?Q?SzqPJ8eeas6tjUKBvJTipREsoCNIt1dEQ10WiqQH6VjiYzwdyyLYer5FlopE?=
 =?us-ascii?Q?vjBKO7n0YJWUh2RFzVQx6ylfiePCgKgAkkqkOZI58zEihmDB4N3yWJ7R1XKX?=
 =?us-ascii?Q?jEpqkDMkRHQVu/a8onGFhnkcnWAqCjvRedHlcPChk/gH/JaCaS7j/rgPYbGm?=
 =?us-ascii?Q?YEqPtgayTBPmQI6d97Pl4EqV1YctfjabR7BLhHHztrTzJyf7/b7gatm2TBR1?=
 =?us-ascii?Q?aV3AHpVF8qy6u1iL5GiHWCJMmZe4PrB5tRESJF3YJKm3apa+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: aMWI/ROyFkCCgiW2SCaeu0mKNMn9bwmQVFIymIzDCe9cy0fkw/1PX9fFduG8D/0qmyWg6cpcmyzJMJSHP5oS8Dkgpq/mYG+Rt1aDlL+WjcpC1rIhBbWGHYDtK0AP5rTseihoht5BOCaPXkiYb2eVHLkoJZMTrfDxwvsy31rAJqQ2rWlZAIVyaCixVpb9v3wyoupI47OP/XPNuaviQCBXLQ3wPuKLkP1Ae1hz17H/vxy0lr0AKRdCk/M2iHb9WNv6rpbmFAwQ2GOQoLi8SW04RLSA0kgweh77fX3CKm4XKLR+DvjyBhzGft8SNKatjqHI/Yjd+H+wZSu9TAH+DJtkTw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8455.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a0dfb4-4661-4a42-39c3-08dee8a0d151
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2026 09:57:33.6810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qm6czEtXroje8K0C+P9GyhE8TYEhv4zujmrkZgIVVAzcBLbNlE5X0NXLoiEFBHHBxwSChDm+VuVgxEzZw0VvtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6758
X-OriginatorOrg: intel.com

>You should probably also say why cond_resched() does not trigger
>rescheduling. E.g., put that and delete the first sentence as it tells not=
hing
>and is confusing.

Hi BR, Jarkko,

How about I place the explanation as a comment above the code at the v6 ver=
sion ?
See the description below.

Warm regards
Jun Miao

>> --- a/arch/x86/kernel/cpu/sgx/main.c
>> +++ b/arch/x86/kernel/cpu/sgx/main.c
>> -		cond_resched();
+               /*
+                * cond_resched() only schedules when TIF_NEED_RESCHED is s=
et.
+                * During this boot-time loop that condition may not happen=
 for a
+                * long time, so report an RCU-Tasks quiescent state explic=
itly.
+                */

>> +		cond_resched_tasks_rcu_qs();
>>  	}
>>
>>  	list_splice(&dirty, dirty_page_list);
>> --
>> 2.32.0
>>
>
>
>BR, Jarkko
