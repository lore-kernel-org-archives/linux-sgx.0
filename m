Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF75245028;
	Fri, 17 Oct 2025 06:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760681962; cv=fail; b=ZxjYap0aBfHgArmY4dtMn1kKvIimowobevVeNU/Pm+4E/jCbwCpxHkEhYWOE1ArpdKzjKstQ5v+t/apn/mJgYru93+nEV2kUDjsWljwgNQDxTNM0mB+IUFve+Y1aIqFLi7y+y1V8HzZESMvJlF4EaF0zfqMOyOfVOudEXwKLi8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760681962; c=relaxed/simple;
	bh=sgCtZMormjb5j3Krm0FYJqXOWtI6ohLYwRAIio2j46k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mj+M5aiW46gQmgVZ8grGHzn7pSNd/q0EO3AtzvQDymFP3oj/Pg+TVXErsJ+9gIfKY0O9E8V0ijGIIlHNHyKs6TGfEVRZkE/Sbz/XMJisQTyCvc6Oo+wkGMlkFnH661C5m5SCWpI/id5wYutlPy8PHJSTqpXLMNAx0gIipm1mbu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hno/REpj; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hno/REpj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760681960; x=1792217960;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sgCtZMormjb5j3Krm0FYJqXOWtI6ohLYwRAIio2j46k=;
  b=Hno/REpjPDT6kfdmv00l7d81G7VHtAdVO5ewFRA5m3fMFP3nSvTqz/0J
   INSlZnuds7xtQuHgrCejM9EnOh7ujzEJA/9bB2AzVU5FaVuZdRwe7OCFE
   SwsndUba4tmbpmSGSpN4xQR2lW8n2S0SSclXKNMK3QyMrKFLc0DwnlleE
   JKi7D4HzaqcV62J68mvnsT+2Q1HGcbJm4/5GPl8+VL02kUQWjN+tCm+dR
   LF86yH1hpyaLQ9usClPTmi4X4ctQsHvwaGV9kTMpvo4mSYmkhdle8qVj8
   A6H66XW9dDtWx1lpfhbpVIznX2YCXIs2jSFT2TD1mIVls4AhW+PI0G0Y0
   A==;
X-CSE-ConnectionGUID: ksJi0kDSQzWCYDErDGRCug==
X-CSE-MsgGUID: Mn+qKyezRMyrMLP1SpDIxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="50454723"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="50454723"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 23:19:18 -0700
X-CSE-ConnectionGUID: JvkFechJRNiPCjD6hs+QdQ==
X-CSE-MsgGUID: 6V2+7DhXTj28/z594nBOfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="182210018"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 23:19:18 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 23:19:18 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 16 Oct 2025 23:19:18 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.9) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 23:19:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f2gOhX3NaF9Cn5sS+TBVaddDxBY9cZGvbkxh3yOLndl181NwAk7SXxh2fcxfuVoE8O+l44+ockvHuBeeynv3Nz58yUBsbOaPnp1wrtm9v81+zh8DezC9j0CDmO/EbaCyYg6QcXeGmJovGaxAdW1utw1I0RN2GLCBhfasGiqkCVRZa49tV+2efKTEZEzMajw+gnmhNPxZPNLVL8LpSryyWKmrKsPglCkYLTAU2Bq+Bp/br9fV/n0hB6c7+fbvJYvuVbOzdbMxstw/4I9oGEoNwh+gjexRN+jSnGm4yqyJNC++k7DSlkBlL1GuYTQmmuB+sd5Shclk27gAhSzY6lJ06Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sgCtZMormjb5j3Krm0FYJqXOWtI6ohLYwRAIio2j46k=;
 b=ekulaVWMEC4jOWo9LWTnBEj+OGBnu+ozZuZpkY0AQ3l/vLW+PNj/jmIVKuT9MKVWlWp50pZUre4P+P45aSvPplq5fNOakF27xRlQ2qbDRkPtqlFvzTDFd86AFsDbtG8RchskFXJLYZXxzikRgbxwLkzFofKCcbbil2uh0HrEvw4e8EdI4Sr4VdCBF7SpyoQSAc6dFbX4hiam4gfxcPQaKDPCMMzgYHx9dhEFhec0KVhHlNQtvzRuefcUocOzH7C6GLwVaazaORj7WzYCAKKNjKXEIOWuOC3rMdhklkYw3gEyREJJw/Bawmrq0gx4MQaukL83OdpGRzWcOVcr3TCaNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB9495.namprd11.prod.outlook.com (2603:10b6:208:59f::17)
 by DS7PR11MB6248.namprd11.prod.outlook.com (2603:10b6:8:97::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Fri, 17 Oct
 2025 06:19:10 +0000
Received: from IA1PR11MB9495.namprd11.prod.outlook.com
 ([fe80::fb49:1b0e:8ebc:254e]) by IA1PR11MB9495.namprd11.prod.outlook.com
 ([fe80::fb49:1b0e:8ebc:254e%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 06:19:09 +0000
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
Thread-Index: AQHcOcOALbIWU1EIjk2Yv6FNR/GCfLTDtSuAgACl/rCAAPxngIAAkGMQ
Date: Fri, 17 Oct 2025 06:19:09 +0000
Message-ID: <IA1PR11MB94951925BFFE305C5ED5589AE7F6A@IA1PR11MB9495.namprd11.prod.outlook.com>
References: <20251010085346.292287-1-elena.reshetova@intel.com>
 <20251010085346.292287-3-elena.reshetova@intel.com>
 <af0ce2a2-8a7d-4a67-a58b-33d01099e75b@intel.com>
 <IA1PR11MB94954D6EE807C00D5A29E520E7E9A@IA1PR11MB9495.namprd11.prod.outlook.com>
 <6ae8a9d4-7c91-450c-904c-76264e211624@intel.com>
In-Reply-To: <6ae8a9d4-7c91-450c-904c-76264e211624@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB9495:EE_|DS7PR11MB6248:EE_
x-ms-office365-filtering-correlation-id: 9eb0a31f-c848-41ef-e4c3-08de0d451596
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?SFdQV3lNRFQ2U0dnam5vZGJoeW1DeEUyVTVYU1M4S0JmZkJ2Uk1sNzYzY2c5?=
 =?utf-8?B?V1ZRelpDeHBPRWFqazlpSi92eWVuT3ZWcDAxMzdQcVpjd0drTmhUeWhCaVpu?=
 =?utf-8?B?amtiM3FwMGRubi9va0t1aDd2Q1MzMnlibnBGUENublNBQW1GTlFCdy8wVzk0?=
 =?utf-8?B?L0NTek0vcndrNHpjZ0wvTkVWaGRXUGdKS0tqb2JWQzRpdUQyU1YvVHpBa1Vv?=
 =?utf-8?B?WlFLWDFlek13SytpQXZSMGlPaWxoT0xic1NNU29TSVhiNW4rUitXUmQrcmll?=
 =?utf-8?B?d3hKOVJwNmc4czBQVjkwUEc3VVBIUE5zUlE2dSt4dG11S25CWlNqRWRlTmhu?=
 =?utf-8?B?WXV3Qk9RVkV5dGJENE5oamJRMGZBazFLT2g2NUpISXptMkJOZ1pxTkphSUoz?=
 =?utf-8?B?clJ3N2JhZmt0T3hiUVpraHVrZTZsNVFBeStZN3pDYzRMU3A2c0pwN3RJWGdM?=
 =?utf-8?B?bUZZY3FON01tRXMrcVN0c3I1akRoaW1VY2g4NThUTHdzZjlqL0F4SE1Ram9L?=
 =?utf-8?B?SG85dW1KVTRtdlRxeGJ4WkNaTUw4UGgrendyOW1MdVB3cmpXWnd6QmhvaXBI?=
 =?utf-8?B?YlNYRGl6RVB0Zmp4NnJGR2V5L3pSQlRBMUZ0NWNybDBWeXJnV0dBaG5kUWtL?=
 =?utf-8?B?ZlZxaHhCQlNxL1pjUTJhNkhIVXVNaXlVTmpqd0NHb01WQngyU3V1Vml3dE9o?=
 =?utf-8?B?eFpPLzV3WmFuc1NhbmozVk11QmxmZG9xK0owN3ZnTElBL09JelFLblhNV3RG?=
 =?utf-8?B?UkVJVk1WZkNLdzY3VUsxZzd2V0JqeVJPQVk2akxRckNFZktjbUJDNlZTMHJB?=
 =?utf-8?B?ZndLdjZmbnZBcEM1akF3dlBXMGJGdDBzZVljRWk3ajU3V2ZINmlwLzViNVFH?=
 =?utf-8?B?N0E3VDg2eDJ4bW4zYWZqZWhvZXRwVmcxRWxLMFVLYkc3aHl3S25nMDJFZnJi?=
 =?utf-8?B?UERudlNRc3VNaTQ3VTZnR2xOdDB6Q21EM0Q2ZGlXdGd4azFwSWl6WDN1SWhD?=
 =?utf-8?B?ZmtNRDBNRlorbCtIUml4cUVpNU5wTFNXbmlzeEhySHVzMnlRSzRwNHl3bngz?=
 =?utf-8?B?eEdlbFV2akNPRC8zSVV3V1lvVE5QUzVnL1dHN2d0cmJYbmRNTkNURmRwdUhB?=
 =?utf-8?B?T0JMWmRROUZCUWpDVGpqWWJUZ3hicEpWL1htZndiU1VnNmpGYVQxdFc4QnpL?=
 =?utf-8?B?Sm9mYmVKa24vV1BpUlA2OE1IaTBEamdjWmpFZFE0N3RLaUNCN2xvY2NiWFhW?=
 =?utf-8?B?TVpSUG81ODVXZS9OYS83dHhRYXQwcHNXSElqUm5Iak0yUkdvaTgwdXcxem9y?=
 =?utf-8?B?L3hJeXNCNGRmdk80NTdwdlZLUTJlYVJwcDIvWmFUOXl5OTRjS01uM1dBcXlX?=
 =?utf-8?B?T1Z3WUJzcjZJcXRQbzVxM0RJbTRjYzV4K3lUTW52Vk04T0pWbHRvVmljRDNC?=
 =?utf-8?B?ZXBkdis4WDBTcEdDSXJFQ1lzTDlOREk4REs1VHlDeEZPdjA4c3FTbndleEJD?=
 =?utf-8?B?cytDY2U3ZjR2bnVsUnArdmNva1ZUMDJuOExtRFg1L2pxMTAvY3NwZmZJWnVO?=
 =?utf-8?B?Q2d3YXJuZzNTNmdJYUlrTEVBbE1GWFphYjRWUzZBYklrclE4V0ZTdE9XaGQ5?=
 =?utf-8?B?YXJWSjlOaEtOd0Jmazl5VXYwdmR4L0ZnRHlucmVCc1NDV0xIcWdOclRXRWpS?=
 =?utf-8?B?V3NpUjFCL3Ztem01aWdBQWRsSTBqZ21zT09EcHpQSDNlTHFPbmpzbVFUUHlv?=
 =?utf-8?B?U2RDaUQ2N21GeWdHeEFHeVl3eW41ZFVqMzR0WkZ0WWxoMXF6UnRZcHh3N0wy?=
 =?utf-8?B?c3dPZVIrYVUrdFIxem1TUnRIdlpTZ3hSRGJBOXBkTFdSZ2YyL2ZVNklYNEI4?=
 =?utf-8?B?RnNzMGcvVmRrdnNZMTBYODRTYlczcWJxV2Z5NWI3M2NDNDFSZkpFb0htNmd2?=
 =?utf-8?B?cVp0WkFNdTZJT3NhV1BWUXljTEQ1alpPTkRlb2dmNmNEVlB4ajIyL3BNa0F6?=
 =?utf-8?B?cElyNFMyV0lvSE9uWHpPakZtYjFzQm9adjBZQnV2WmN2N05QWUNscUF5MlZw?=
 =?utf-8?Q?9F73Lz?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB9495.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkJJTU9Ea2l3dllSQlRlaGtaNytXbnYyTkY3SFUzcGxOT0EzMUFPNktEeGsr?=
 =?utf-8?B?SjVOdEh0RWVleFJkMjZ3RU1BTjNudUpoK3RWR1ZaMHBXVGFGU2FiNnB6TGlY?=
 =?utf-8?B?UEtnVGNXb29FRnNiYjVRZXdVK1d2TEJaRGFmNDhCSDJSWmNKSGlyMko3Qi9h?=
 =?utf-8?B?bUtkS1pTdXpMcUhEMVI5RGpFYzl4MDhoYnpHYU9xZ0kzRnpaempUOGtNNEcw?=
 =?utf-8?B?SFNqQVFxbERvTE4xWUpnZXY4S3dlbGZZdDI4ZHdPeVV2SjZuMDYxeUFsdERt?=
 =?utf-8?B?WTVMbCtNb3Ura2dVa3FOaG9Ob3M4bTZFUFUvV1F1ZjhBdGVRK0JBajhNQStq?=
 =?utf-8?B?VWlNYXVPT29wdVYwc3hGNHFibWVuWEYzdE1UZVIyTG52dWlwMUY5ZHNBYzZM?=
 =?utf-8?B?Wk1Ya25DNjhFVnJVeGZjK2xzTEdFUnZJNmJ2SlZkTmc2WDBaQTlUZStRR05Y?=
 =?utf-8?B?cWw4QXBJT2FaMVJZTklXRFp6R09MNU5HTFNaQzRrTzFqejhMaFNSRHZEZmFG?=
 =?utf-8?B?bDZFSll2M29od1BjcW01Yk0vUHMyQWZLak5vandaQnA4eDVHdE1VaXJRTmNm?=
 =?utf-8?B?NVNycXZwM2FJOHlUaHcra21wVmY3VDVNZmdvRTlNdjk4ZUhCMWV4c1cySUNM?=
 =?utf-8?B?aE5VN2tlWU4vZU1GN1lJbjRUYUFFRCtvcVc3Um1LRmhHTW5TQ1JsWUpwZmVV?=
 =?utf-8?B?TGpEb2FyRTl4MkFWMHFtVXllaWNhR3IyVHdVbFZ6MkdSdi9Sc1JwOFBDR1pQ?=
 =?utf-8?B?dkRBSGRxTUZsclVWTlo1OHZyVEFUUkZXSGJscVBLL2NKNmNKb28zQ3FobHhI?=
 =?utf-8?B?V0VENGxmKytOeXYxcmxRcy82R0pkeWRmZGxDNVEzZXRCMWg1dExabjArQ240?=
 =?utf-8?B?a0dnZEtVc2tHdVowU3hlSEhHRG93ZW9zcWNCVExpRTZZM1FIY0xtclB6bVJk?=
 =?utf-8?B?MTVQRm5adGg1MDBuMFZVRTBWNm11U002YnRuYkNxOXZXRmN6M0pJc0lobUEw?=
 =?utf-8?B?eWNPVVEwaXlOYkFXNmVzN3c0RGsyekZRYW1ZTGxsNmtCR29xdTFYbDIwdkEy?=
 =?utf-8?B?SGtRdUxXWEcycHN0ZkNMYlpzYitYS1oxTUNTMkRqaU1oTEcwcGxscCtoek1B?=
 =?utf-8?B?NmhySVZKUEpFaWxMR1owTUJjSmlzOFdZWUZXbkRsa21TSm5adGIwbVdsWHFs?=
 =?utf-8?B?c3NmQlRGaWhyVlJQU0tMdm13WXJFaUs5Y2dUODNlcjBTYnB2QkgzZUdPc1Za?=
 =?utf-8?B?VTNyMC9ITEplVWhUWjdkWlRhd0kyM0t0bUJIdXhWallEQkMwR051REYxcEM5?=
 =?utf-8?B?QnNDbCtBbnRGSXp6VDJ4cVEzaFhkSVRvOVhFaFp3WXk0ZnlXVnppZnNBTzZp?=
 =?utf-8?B?M2Y5N0NPQTNCdkJBSnBGSDJ6Zk1MM3VaTlhJajNCQXV3VXRvWmp2a21ISmVw?=
 =?utf-8?B?M2RuMDNRYnlicXhTUEN0UlpsTnJNei94cmFQQXA1VkFscFNyejlZcVlhTjBL?=
 =?utf-8?B?T1owdEVyWm8zS2ttK0xHN09VK3NKWXlaU1lxRG5NMm5TUXRFRHQ1d244c1p2?=
 =?utf-8?B?RWI0SkY3S3A2ejZXTm03SStEZWs1aWxHdDQyV0hPS2pndWdUeFVEK0x5QUxD?=
 =?utf-8?B?aEhYVEZPMHdQWWVnckVvZnViWFdrLytzazkzYmU2akxtSzdsOGNsakhGT2ov?=
 =?utf-8?B?bnZFbDZ5YytvdkFOcTdKbUg3TE1tNEZyYWl3emQ4VHpQZEY0QS9TN011Nits?=
 =?utf-8?B?TVorTUtEbUQvVmJIR3poZ1dXT2JmUjUvQXg2TFppV0tNOE9IbVBqYjBsV1dC?=
 =?utf-8?B?R21ESXRLZC91WjBsUWpDcjRXMno3RjNVOVErR3Rnam5wSGovVEtzdllINHlp?=
 =?utf-8?B?QTRiMWpoVlViNzlDcUhWM0RwWEdKbmlUb2tCVldDYktUMThJVkF5TUVxQUdI?=
 =?utf-8?B?VklLZmxpaWx5V3JqN21JU3BocnBZR0w5blZWZUpmcWVWS0FEQllwS3NzOW5I?=
 =?utf-8?B?K09wa1NsU3JKL3ZzWHE4RUV5MTBURTE1SHNQWW9HenJzRjAyRloxOU5nUEtT?=
 =?utf-8?B?YlA3NDZMc3YvZjI0UElJNEtYbVNrbUx5VDdCVVN0OXVYZkNMeUFrbzlNYUZp?=
 =?utf-8?B?VGtuSUlkU2hQZnpBZmdIc0ZOb1pJUjl3dWs3SWtldjg2TXFlZXo0SmE5MEhZ?=
 =?utf-8?B?M2c9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb0a31f-c848-41ef-e4c3-08de0d451596
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 06:19:09.9163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M4lw1AmKRv414e4qiIDBy7LSAq+OI+94F2xWSoCfDf6paXTG3lvNP7MbTe0hJX6x9jjfajFepPdXMXEPzuBLuEoScGy7i1+DdogwA0iUiso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6248
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIYW5zZW4sIERhdmUgPGRhdmUu
aGFuc2VuQGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDE3LCAyMDI1IDEyOjQx
IEFNDQo+IFRvOiBSZXNoZXRvdmEsIEVsZW5hIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0K
PiBDYzogamFya2tvQGtlcm5lbC5vcmc7IHNlYW5qY0Bnb29nbGUuY29tOyBIdWFuZywgS2FpDQo+
IDxrYWkuaHVhbmdAaW50ZWwuY29tPjsgbWluZ29Aa2VybmVsLm9yZzsgbGludXgtc2d4QHZnZXIu
a2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHg4NkBrZXJuZWwu
b3JnOyBNYWxsaWNrLCBBc2l0IEsNCj4gPGFzaXQuay5tYWxsaWNrQGludGVsLmNvbT47IFNjYXJs
YXRhLCBWaW5jZW50IFIgPHZpbmNlbnQuci5zY2FybGF0YUBpbnRlbC5jb20+Ow0KPiBDYWksIENo
b25nIDxjaG9uZ2NAZ29vZ2xlLmNvbT47IEFrdGFzLCBFcmRlbSA8ZXJkZW1ha3Rhc0Bnb29nbGUu
Y29tPjsNCj4gQW5uYXB1cnZlLCBWaXNoYWwgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT47IEJvbmRh
cmV2c2thLCBOYXRhbGlpYQ0KPiA8Ym9uZGFybkBnb29nbGUuY29tPjsgUmF5bm9yLCBTY290dCA8
c2NvdHQucmF5bm9yQGludGVsLmNvbT47IERhdmUgSGFuc2VuDQo+IDxkYXZlLmhhbnNlbkBsaW51
eC5pbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjE2IDIvNV0geDg2L2NwdWZlYXR1
cmVzOiBBZGQNCj4gWDg2X0ZFQVRVUkVfU0dYX0VVUERBVEVTVk4gZmVhdHVyZSBmbGFnDQo+IA0K
PiBPbiAxMC8xNS8yNSAyMzozOCwgUmVzaGV0b3ZhLCBFbGVuYSB3cm90ZToNCj4gPiBTdXJlLCB3
aWxsIGRvLCB0aGFua3MhDQo+ID4gUHJldmlvdXMgdmVyc2lvbiB3YXMgYmFzZWQgb24geDg2X3Rp
cC9tYXN0ZXINCj4gDQo+IEp1c3QgRldJVywgdGhhdCBtZWFucyB2ZXJ5IGxpdHRsZS4gRHVyaW5n
IHRoZSBtZXJnZSB3aW5kb3cgaXQgc2hvdWxkDQo+IF9tb3N0bHlfIGJlIGd1bmsgdGhhdCdzIGFs
cmVhZHkgZ29uZSB1cCBmb3IgLXJjMS4gQnV0IGl0IG1pZ2h0IGFsc28NCj4gY29udGFpbiBjcnVm
dCB0aGF0IF9kaWRuJ3RfIGdvIHVwIGFuZCBuZWVkcyBhbm90aGVyIGN5Y2xlLg0KPiANCj4gUGxl
YXNlIGp1c3QgYmFzZSB0aGluZ3Mgb24gYSB0YWcgaW4gTGludXMncyB0cmVlIHVubGVzcyB5b3Ug
aGF2ZSBhbg0KPiBleHBsaWNpdCwga25vd24sIGNhbGxlZC1vdXQtaW4teW91ci1jaGFuZ2Vsb2cg
ZGVwZW5kZW5jeSBvbiBzb21ldGhpbmcgaW4NCj4gdGlwLg0KPiANCj4gdGw7ZHI6IEJhc2luZyBv
biB0aXAveDg2L21hc3RlciB3YXMgYSBidWcgaGVyZSwgbm90IGEgZmVhdHVyZS4NCg0KVGhhbmsg
eW91IHZlcnkgbXVjaCBmb3IgZXhwbGFpbmluZyEgSSBkaWRu4oCZdCBrbm93IGhvdyB4ODZfdGlw
IGlzIG1hbmFnZWQsDQpub3cgaXQgaXMgY2xlYXIgYWxzbyBmb3IgZnV0dXJlLiAgDQoNCkFuZCB0
aGFuayB5b3UgZm9yIHB1bGxpbmcgdGhlIHBhdGNoZXMgaW4hDQoNCkJlc3QgUmVnYXJkcywNCkVs
ZW5hLg0K
