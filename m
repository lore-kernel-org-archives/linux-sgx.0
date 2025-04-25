Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E9A1F3B89;
	Fri, 25 Apr 2025 06:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745563979; cv=fail; b=HMEzjyf9RCFCJEaHOSFcL2nO45Q/RawxgpoeJKOST4y9YmwwLnsYCjfy8VNgC/Fr3wV0OvqlwAs83/31+Bz53cAfsfN+f9whOD5VAM+FgSSdBdR1VDGNdoNnDzQOJ5AFf7MPHKaPTDeWxSKHTjmIzTOIUiVY6NdpR/LbyXh6UVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745563979; c=relaxed/simple;
	bh=oJcPpPTSNFxxutP0jpXlAKv6wparwRtcnsPkIsmwQ6o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lRY2l4IXUbA7j29UFc0WIO0Ksg/ervwNZjVyjS0EgV9CifOtsqW8BwhyrpIS0thPmRp+K40SoWwLTeD/vpedr1iU0h9h87V3e47TkPEQVRCnoHfaVO7UnboWENiGGMIdxWPQzj/fH46fG1ZR1OaErEWf+dAgXzV9nxoLnISQEt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aNAKy9eK; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aNAKy9eK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745563977; x=1777099977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oJcPpPTSNFxxutP0jpXlAKv6wparwRtcnsPkIsmwQ6o=;
  b=aNAKy9eK5DO9a9lBQJWKfinTxEvhE7hEHF+yP3vhzHUCVcfUC0DDB8Vc
   GCO/xI0Tt+o5TKaQ/sD0S5O9XrxSysfxUTNepvyvQPxq15KGL8IEOmMf2
   EwPuqNIxg05ql5gvGr60ZcoxswbmzfXquhxpEC3tHbANwx6fndkbiutcx
   GJCLYTXhcyx+v9bfs6VCmVoMfjdVzAHYjd4Y6+z/ZbgiPxIbGmlLkfZAN
   A3rK5cj14IUqFHsikmiAakjgdiJqrXHyqtaTUL3fq44zTqdw0rIdamoef
   KhG4u2fdG3qwnoHqEcC36ZXrJyvDDPwXFkAO6O1acH8zLDZcKvJKPMOPk
   Q==;
X-CSE-ConnectionGUID: 2JQ2f9hyS6eUGeA2Vmh8KQ==
X-CSE-MsgGUID: l1nY+OdSQKarYUC5WV4MqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="46928865"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="46928865"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 23:52:57 -0700
X-CSE-ConnectionGUID: zqA7/Xl7Q6W3zjbXjd4Pkg==
X-CSE-MsgGUID: xXBchtYsRhqSVU75Te6tfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="133132192"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 23:52:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 23:52:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 23:52:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 23:52:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H/Mx5Kd/CBbIbOiSPF0pzb+2hCsTsBP6AFUghhyWsV+USmLCSCKXCV21JQT+UfyK4q9p6sFK5wgl5celLfrbnHTcO7Qult6nuer7Of9XSuV0RPvMZbrzfU5Rnz0es/ZnHRQqBkaKfW7HklQ9GKVu1AxB0j3AYFmIhxBJBq1UJ047C5s6Ipv9V3ApueP+/0qxXu7RbENG58cu+ecKYfqKOLFwtutsk7BRHMbSF6GeFKdMVwTfRY5uV9GAf36JZ2hdi8iw9886jLtxP5wX6i733ISm4bIyZJSlSR1SBF3ps67PfTPyzj4/NfPp/ySighMzvr1epNGSxfD/LK9RoeDH1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJcPpPTSNFxxutP0jpXlAKv6wparwRtcnsPkIsmwQ6o=;
 b=TLCBuU/lEzXV3B+Wsa8z1oNWk+5w1Trq1adY2sAbz7llLvHFSSQKjxXH9e68O8qEHIcXm6tq7zlwiQ7eqheBMsBTe+NnR/zMWIsuenR3SsFpxw/JKtMn0t5RaXZ3cLfoUrgaJFB3wEKnvwy4R1/6caLVAwiHt+ZPzbuz6lPVFY9hM9eza+WHR5UwGJ4pIXZ2/ecYnaUQ6xbyYpUq3nPHMerrICfvUkCyaFCpsEjdkrQK+lSHxsy5lFyjBWETbDYqQx23Y/vZVa2cF3Hfb2DTvR6j9gd5nQKQdBJzOQF1mxNcDavzdMasVcK30ZnVJHYoALK8fSiYHGPEB+EvNb4EJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SJ2PR11MB8516.namprd11.prod.outlook.com (2603:10b6:a03:56c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.27; Fri, 25 Apr 2025 06:52:53 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%7]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 06:52:53 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Scarlata, Vincent
 R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Cai, Chong"
	<chongc@google.com>, "Mallick, Asit K" <asit.k.mallick@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "bondarn@google.com" <bondarn@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbrfzujDHiSNozs0m8Z6fqnS5FZ7Oph/QAgAXK54CAAG1QAIACw3gAgABd6wCAAAZ2IIAANiqAgADdHdA=
Date: Fri, 25 Apr 2025 06:52:53 +0000
Message-ID: <DM8PR11MB5750AB0E790096AFF9AFD3AFE7842@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
 <20250415115213.291449-3-elena.reshetova@intel.com>
 <aAJn8tgubjT5t7DB@google.com>
 <f5cb3c37589791b2004a100ca3ea3deb9e1ae708.camel@intel.com>
 <aAefmNVRFc3me6QQ@google.com>
 <DM8PR11MB5750B37305B3B1FAE4F42D3AE7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAo_2MPGOkOciNuM@google.com>
 <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aApgOqHvsYNd-yht@google.com>
In-Reply-To: <aApgOqHvsYNd-yht@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SJ2PR11MB8516:EE_
x-ms-office365-filtering-correlation-id: 060db4e8-c416-4c71-f414-08dd83c5cd47
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|10070799003|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aDYrMjdaMFJmUWk0bWp0YXhFSnlkVTN1dk1uVkZNYk9ablFKc3I1allLNjdU?=
 =?utf-8?B?OE12Szg0cERHQkhEQ09lMWp1WlM0WlE2U3A2VUorNjk3aklKNDc4aHZHaTJ4?=
 =?utf-8?B?V1NuU0h3WUR5NWtOSFJNZytRUWthOGFncFBuOVgrYjU1VzFQNHpHZE9XVnpt?=
 =?utf-8?B?RWFiaXJzVE1KaUxYQnNMK1BFT3JPMTVaMzdicHRsRDAzVHFwcmhTdHUyQ3Np?=
 =?utf-8?B?bGlGSTlpMFozR1pPUGg1cW1TOTUyaUl6dVp6blR5TWdFNkUvR0lxbU96R1R5?=
 =?utf-8?B?T2tMb3VoUlRJM2FRT01FbnNBdXh4aXJqSVFUL0FvOEJMNGwwS1VIcmdyTEs5?=
 =?utf-8?B?ZjdNbnArcXdvcGFhUDM2MDRqZXppaXVyYkFTcFdSdVFhdVQ4TWZ4MXRYS0RE?=
 =?utf-8?B?bWpGT0wyZkRabzNhaVk2Y3E5RUQvREo2Y0hmSnl0Ym1JcHU2UEZxSkwvQlFD?=
 =?utf-8?B?dXVycFN4QmZKL2dzZy9nRjRvM0tldmlWQTQrL2FKSldhdCs0UWRER2JzdjFV?=
 =?utf-8?B?V0Urd2Vob3lXdWlIM01tNjhTdjNIcm13SVZVaW43RUc0cWxMWEhwNThKek5N?=
 =?utf-8?B?d3grYnZ2MWhKS2JuN01MSEdURmFkd3N5SkZQYTgyd1E4elR2Sms4c2xLM21W?=
 =?utf-8?B?WHNqSitxR001Q0hCZlE4ZEdWUmMyS1VTd29keFk2ek5pWUZ4eWpMMW5XSXhY?=
 =?utf-8?B?bURselRuQnFpTEdCZnE0MGlFN0FEU25UZGVZZFVsZ1BYbFJCcmtZUTRRMGRT?=
 =?utf-8?B?bHJEdk04Yythb1VSaDA2QjZBMzhUVDVpaXdDOE55d05MenBodUdwcDY5UXlr?=
 =?utf-8?B?SnhFWlNaVjg1dkFzZnNtSmkwU3pNdXpaUDZmbVdEbTVsK3Fid3pBcFI3U3Vk?=
 =?utf-8?B?emkxd1k2d0tXTFVhc2I3WXBxZTlHRW9BaUJCajdUbVNIVTU0TnBPTHg3Y0pr?=
 =?utf-8?B?VWh2NXNpYnp4eHg5ZGlEM1NCSU9KN2hCR0c2dmwyOE5peWlIejFOUkZ0RjBL?=
 =?utf-8?B?V2dDWUhETE5jeTFJL1FtVU45Qm55SURENy9va2p3d2YyaVE2cmxFdFpjblJw?=
 =?utf-8?B?OVhhalp4SlIwZWhYOHZXOHZzZ09ya1lXRnAyRFJqQ0JXOTNBbDlaemQxOUUx?=
 =?utf-8?B?THk2V0ozN05TWUVsOExGQ1RvdGxnejN2SmNtUUpCL2ZpdmhUVFVMdG9seUVa?=
 =?utf-8?B?TGJPVlJrU1dCR0RQUStlanNsQmZQV3Fia21UOUlMSFAzYkNSNDVGS2xYRjJ0?=
 =?utf-8?B?eDNOWGtIWXYvcU9Ga05aMlhTbGVZTmRORUFhbU14VUlQQnZycEZ6alB1Zmp4?=
 =?utf-8?B?NlM5K1NTZnBuYVFIUm94WUNxSi9scUZmV0FTZ0lqbmNqY3dZZGg2WkZwdks0?=
 =?utf-8?B?b0FGNVFnbWJXTWRRMXZrSDdYVEplZGFGRTl4NlRNWi80N2ZNQ3hLUzg0UkRC?=
 =?utf-8?B?dTNjZG05WWxOZWJ5WnNubkhDcmZ0VGRFUlZ2T3NBdUpQREt4ZHpTelhHVTd0?=
 =?utf-8?B?UGkvL0lXQzN0c3YwVmw2elJCaTdFanFQVVM0dU4vM0tOUlJ5Mks5V0xxc0Vz?=
 =?utf-8?B?WnVaL2NnaGR5UGpoSFJuK01peGcxQ28rRldHRWJWTzNYS25vU2F0MmkyTnJx?=
 =?utf-8?B?anJhMVpWdjlsM1FsL2dhK21zVXgxUkVpcVFrcUZGeHRYSkcwR1pkTDY2amZz?=
 =?utf-8?B?TXdLdkpDMkgwUkZBM2QwWWl0RG5qWDFvNTQ3NnkvUEVPcmVJSFI0Q3ZTR3J1?=
 =?utf-8?B?RzgxQmMxNTAzRUd1OXFGdVlwd2ZhVEpQYkU5MHIwdjNBajFPd3dKQXhzcWJt?=
 =?utf-8?B?Y1hvVURSWWs2dnVvTDhoa3JYNGJaN2xjbWttdTdzMVpmYmZPV0xGdFR3QlFk?=
 =?utf-8?B?ZXNKY0l1Z1JsMVBVVzF0ZHVHS2xkT2ZqT0ZUREhiWWkzNFpQNjExM1JickY2?=
 =?utf-8?B?eVJoQVRydlc5cGUvMFlhZ0dRSEl6K0VyZ0t6UFVHT01JRmJ5VVp6WVExS2NT?=
 =?utf-8?Q?sKO/p0HLIsfSCEKilkkTK6brV/huYU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUhlWHlWSVU0UUtQRUh3SFhRTDJBdGd4NVpnMDhNbEp6YWxhVERWLzlXOFFO?=
 =?utf-8?B?MGNHU1hOS3JUU0VQU0JCZ1dJZzhnZXBVRmFjNDZ3TnBhMENyMUhabGxOV3lH?=
 =?utf-8?B?MkNrQ1NBVUs5UUlqNUxiTGh5cXBWa1VDQlRQcEowKzF2bHNXUVJ4SkFDQXp1?=
 =?utf-8?B?VUdvMlNqTWRyakduUzdvc29pSGJXdVlDQXZGeGxLcW1nbVJoNlZ1TFRKNVV2?=
 =?utf-8?B?QzAzalNTTi8rRUZoRUhSZlMvRVZFU1BCVHZzOE1PNXB4Z1U3bmpyWVNhYXAx?=
 =?utf-8?B?TEdhdkdRR29BamN0K1ExdE9UdnJ4azgvWjFocW82blY3cmFLeHRmSDlWODlq?=
 =?utf-8?B?MHVyZ3lCZFUxQjd4YkluYTUyVmRxaVhiN3Y4c2dVSjBlcjFjNkI2aENTRXBr?=
 =?utf-8?B?UlBsS2k0ZVRaQzhWK2lPSkZhQVBIbXlvQmxyMHdaci90czExd1M0bkIzSXNu?=
 =?utf-8?B?MUdPOGRTbHNlK0tXODQ3bHpLS25wRTQxNkYyTE01Nm1MdWFpSmRrbjQ2ejFn?=
 =?utf-8?B?dkQzNG1WMkNBWDdQdmZzRFBXQVlVelBaRy95WSt4ZVArVW1jdU1EV1pxdWZ4?=
 =?utf-8?B?OVBVUlAzYlM5Zzh2QVhwK1VhdXF6cHJUK0dTa0J6K0hzbHBrTkxHQmg3emFY?=
 =?utf-8?B?bS9nRWUzYk9LTGRnRVVyVEJ6RHBVd1hYZkI1RlRBTTFvL1Z2SDhnSG1FblZh?=
 =?utf-8?B?MU5oNk9HUGUzbTJkc3A0RjZvTUxxNEtzVGozRlIzRjExQmQ4UklOOWlEcVVx?=
 =?utf-8?B?NG83YU0rdlh3VmZoVldhKysyV2I5Wk91VG4xbnZxNm4wZmpPZ2NuL3J0K0tY?=
 =?utf-8?B?NDhYQTYyNGJFZUZ0eTJZdU9wUW9tZytWU2p6bVZhTHFRbFdFRVYrMzU5TjVv?=
 =?utf-8?B?T1dWQjF4TWl6WkI4aytWdVlpL1lRRWEwTVRJdTRxbmVkTllxREJFSTA5aXMw?=
 =?utf-8?B?WUNzLzgvbE85Y055b25BNjlxNG5lNGl6TlNHaHF5OTVYeHN2NkVTMkgwZHNO?=
 =?utf-8?B?eUZhSTdhNG1zWTE5cy9QNm5LNUFUaWVlVUN4V1M1amcwMmJhbWQ4V2lXL2x3?=
 =?utf-8?B?TWlNa0ZYdlo4ZjVkU0hXZFMzQnJieTIrOGxDV3hlS0NkOWhaTHNpSjVwSFlC?=
 =?utf-8?B?dU9iNkZvenRZaitaU2g2cUNnZ2xicDA3NVNhQnhaUUZxbXJFZGg3eEs5Mlha?=
 =?utf-8?B?ay8wNEtQbUE3aVJ0WmtxUndkV2VWSWwzTm1GZjNaODhYdUJVTWcxVmZJb0xC?=
 =?utf-8?B?RGNvMnV1WGZWTjVOM043WTJXL1F2QXdua1RvQ3owK2NOV3RLWFNKcVYzNWRn?=
 =?utf-8?B?ajBMdFQ2TWt4Sm93Snk0R2lFRjhuaW5SUXhrcGp0enQ1bnArRmswY3J6cFZQ?=
 =?utf-8?B?UzJpdndHeFhscmp4ZGFRMkZkOXZzOXF3R2MrVTlPcS9hd3JpeXJnNis4WTNs?=
 =?utf-8?B?UUNoSEFJdlhPN1VwSTAzcS9tYlRiVEFMaDB4K1grbzArZFlmUTFWci9zZWZ3?=
 =?utf-8?B?M0R4Uzc5andZZElqZUE1TUhoMmtQWENhSjFVNDVsWG14YU9qaFFaMzh1RTRG?=
 =?utf-8?B?SGl4V0lRcTdwS3dOUG1vbWg0Nkt2aGdWemFWNWtvQnp5NWdQUmtkU3FUc3E2?=
 =?utf-8?B?QWR1ZEMrcnRBd2JKaHROZG1LTm5OOEttYTJCWUR3NXVGQVJPQkt0dCtyam1h?=
 =?utf-8?B?VEhMc0VmZUxZVTA2WGVod0hzMlFYdDQ5T1RKa0RVZW1qNkxDcm9yelM1a0xq?=
 =?utf-8?B?RjU0MC85SEJ1M2doRldGVEdaSlFTWS9Nc3ltVnJ2SDgxaDRzR0dsY1drVkJo?=
 =?utf-8?B?T0M3SHlyUThNQU5rUkZCYkRxSDBPUTVxRFA5c1VlSklDckNIN05uamtDcWFO?=
 =?utf-8?B?VUwvaFZsdXRLVFNtM2NuN0twL3ZNZVJaUVZQOW5PU0xYcVBac0toMjl6Ry8z?=
 =?utf-8?B?Zm9rTUNUY05oVi9mWmxVVi9ZSFo1cXVpZVpZVEpEZlBWTFV0VEFOdDNYdHZp?=
 =?utf-8?B?bXVWK0YrckFrejZVckpFY1hXNHJXd1dRTDFLOHFMYWZ3ZXBaL0tVZFExUG8y?=
 =?utf-8?B?U3BBNjY0dmhSbnpmMkpTRTU2Wmx0SzJCQVAvdWxkTFk1ZDZVcTUwNTNHSFZN?=
 =?utf-8?B?RFl0SVMzenVsaUxRbnhHeXhGQ0gyN1QzcDU1UDJoZ2lWUXAwbHE5Z3lGVkoz?=
 =?utf-8?Q?oWQDjT7jvsFNSetOjnIjZltF5PDqd4ksOct1uTJyw+Wl?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 060db4e8-c416-4c71-f414-08dd83c5cd47
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2025 06:52:53.2076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iUvtkCXryQJmuDk/iNFzv5rd+h+VZjYVzoOjvLU9tbDcK7hI8MTw0EwZTLuj8XV7euOgLBFPF8llvHC8iJVTQl0deR7Vk63hUzTntAY/qHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8516
X-OriginatorOrg: intel.com

PiBPbiBUaHUsIEFwciAyNCwgMjAyNSwgRWxlbmEgUmVzaGV0b3ZhIHdyb3RlOg0KPiA+ID4gT24g
VGh1LCBBcHIgMjQsIDIwMjUsIEVsZW5hIFJlc2hldG92YSB3cm90ZToNCj4gPiA+ICt2b2lkIHNn
eF9kZWNfdXNhZ2VfY291bnQodm9pZCkNCj4gPiA+ICt7DQo+ID4gPiArCWlmIChhdG9taWNfZGVj
X3JldHVybigmc2d4X3VzYWdlX2NvdW50KSkNCj4gPiA+ICsJCXJldHVybjsNCj4gPiA+ICsNCj4g
PiA+ICsJZ3VhcmQobXV0ZXgpKCZzZ3hfc3ZuX2xvY2spOw0KPiA+ID4gKw0KPiA+ID4gKwlpZiAo
YXRvbWljX3JlYWQoJnNneF91c2FnZV9jb3VudCkpDQo+ID4gPiArCQlyZXR1cm47DQo+ID4gPiAr
DQo+ID4gPiArCXNneF91cGRhdGVfc3ZuKCk7DQo+ID4NCj4gPiBXaHkgZG8gd2Ugd2FudCB0byB0
cnkgdG8gZXhlY3V0ZSB0aGlzIG9uIHJlbGVhc2UgYWxzbz8gIEkgd291bGQgdGhpbmsgdGhhdA0K
PiA+IGRvaW5nIHRoaXMgaW4gc2d4X2luY191c2FnZV9jb3VudCgpIGlzIGVub3VnaC4NCj4gDQo+
IEkgYXNzdW1lIGFuIGFjdHVhbCBTVk4gdXBkYXRlIHRha2VzIHNvbWUgYW1vdW50IG9mIHRpbWU/
DQoNClllcywgY29ycmVjdCwgaXQgaXMgbm90IGEgZmFzdCBhY3Rpb24gYW5kIGNhbiBiZSBldmVu
IHNsb3dlciBpZiB3ZSBhcmUNCnJ1bm5pbmcgb3V0IG9mIGVudHJvcHkgYW5kIGhhdmUgdG8gcmV0
cnkuDQoNCj4gDQo+IElmIHRoYXQncyBjb3JyZWN0LCB0aGVuIGRvaW5nIHRoZSB3b3JrIHVwb24g
ZGVzdHJveWluZyB0aGUgbGFzdCBlbmNsYXZlIGlzDQo+IGRlc2lyYWJsZSwNCj4gYXMgaXQncyBs
ZXNzIGxpa2VseSB0byBpbnRyb2R1Y2UgZGVsYXkgdGhhdCBuZWdhdGl2ZWx5IGFmZmVjdHMgdXNl
cnNwYWNlLg0KPiBVc2Vyc3BhY2UNCj4gZ2VuZXJhbGx5IHdvbid0IGNhcmUgYWJvdXQgYSAxMHVz
IGRlbGF5IHdoZW4gZGVzdHJveWluZyBhIHByb2Nlc3MsIGJ1dCBhDQo+IDEwdXMgZGVsYXkNCj4g
dG8gbGF1bmNoIGFuIGVuY2xhdmUgY291bGQgYmUgcXVpdGUgcHJvYmxlbWF0aWMsIGUuZy4gaW4g
dGhlIFREWCB1c2UgY2FzZQ0KPiB3aGVyZQ0KPiBlbmNsYXZlcyBtYXkgYmUgbGF1bmNoZWQgb24t
ZGVtYW5kIGluIHJlc3BvbnNlIHRvIGEgZ3Vlc3QgYXR0ZXN0YXRpb24NCj4gcmVxdWVzdC4NCg0K
T2ssIGJ1dCBpbiB0aGlzIGNhc2UsIHlvdSBhcmUgaG9va2luZyBib3RoOiBjcmVhdGUgYW5kIHJl
bGVhc2UuIA0KSSBndWVzcyB5b3VyIGxpbmUgb2YgdGhpbmtpbmcgaXMgdGhhdCBpbiBtb3N0IG9m
IHRoZSBjYXNlcyBpdCB3aWxsIGJlIGhhbmRsZWQgYnkNCmEgcmVsZWFzZSBmbG93IHdoZW4gZGVz
dHJveWluZyBlbmNsYXZlcywgYnV0IGluIGNhc2VzIHdlIGhhcHBlbiB0byBuZWVkDQp0byB1cGRh
dGUgYSBtYWNoaW5lIHdoaWNoIGRvZXNu4oCZdCBoYXZlIGEgc2luZ2xlIGVuY2xhdmUgeWV0LCB0
aGUgY3JlYXRlIGZsb3cNCndpbGwgYmUgdXNlZC4gVGhlIHByb2JsZW0gaXMgdGhhdCBpZiB5b3Ug
bG9vayBhdCB0aGUgaW5zdHJ1Y3Rpb24gZGVmaW5pdGlvbiwgDQp3ZSB3b24ndCBzYXZlIHRvbyBt
dWNoIHdoZW4gZXhlY3V0aW5nIHRoaXMgaW4gcmVsZWFzZSBmbG93IChLYWkgSSB0aGluayBhbHJl
YWR5IHBvaW50ZWQNCnRoaXMgb3V0KToNCg0KSUYgKE90aGVyIGluc3RydWN0aW9uIGlzIGFjY2Vz
c2luZyBFUEMpIFRIRU4NCiBSRkxBR1MuWkYgOj0gMQ0KIFJBWCA6PSBTR1hfTE9DS0ZBSUw7DQog
R09UTyBFUlJPUl9FWElUOw0KRkkNCigqIFZlcmlmeSBFUEMgaXMgcmVhZHkgKikNCklGICh0aGUg
RVBDIGNvbnRhaW5zIGFueSB2YWxpZCBwYWdlcykgVEhFTg0KIFJGTEFHUy5aRiA6PSAxOw0KIFJB
WCA6PSBTR1hfRVBDX05PVF9SRUFEWTsNCiBHT1RPIEVSUk9SX0VYSVQ7DQpGSQ0KKCogUmVmcmVz
aCBwYWdpbmcga2V5ICopICANCklGIChOT1QgUkRTRUVEKCZUTVBfS0VZLCAxNikpIFRIRU4NCiBS
RkxBR1MuWkYgOj0gMTsNCiBSQVggOj0gU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZOw0KR09UTyBF
UlJPUl9FWElUOw0KRkkNCigqIENvbW1pdCAqKQ0KQ1JfQkFTRV9LRVkgOj0gVE1QX0tFWTsNClRN
UF9DUFVTVk4gOj0gQ1JfQ1BVU1ZOOw0KKCogVXBkYXRlIENQVVNWTiB0byBjdXJyZW50IG1pbmlt
dW0gcGF0Y2ggZXZlbiBpZiBsb2NrZWQgKikNCigqIERldGVybWluZSBpZiBpbmZvIHN0YXR1cyBp
cyBuZWVkZWQgKikNCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KQWxsIGFib3ZlIHdv
dWxkIGJlIGRvbmUgYW55aG93IG9uIGNyZWF0ZSBldmVuIGlmIHdlIHN1Y2Nlc3NmdWxseQ0KZXhl
Y3V0ZWQgaXQgb24gcmVsZWFzZSBwcmV2aW91c2x5ICgoIEFuZCB0aGVuIGZpbmFsbHkgd2UgZ28g
aW50bzoNCg0KSUYgKFRNUF9DUFVTVk4gPSBDUl9DUFVTVk4pIFRIRU4NCiBSRkxBR1MuQ0YgOj0g
MTsNCiBSQVggOj0gU0dYX05PX1VQREFURTsNCkZJDQpFUlJPUl9FWElUOg0KDQo+IA0KPiBJZiB0
aGUgdXBkYXRlIHRpbWUgaXMgdGlueSwgdGhlbiBJIGFncmVlIHRoYXQgaG9va2luZyByZWxlYXNl
IHdvdWxkIHByb2JhYmx5IGRvDQo+IG1vcmUgaGFybSB0aGFuIGdvb2QuDQoNClNvLCBpdCBpcyBu
b3QgdGhhdCB0aGUgdGltZSBpcyB0aW55LCBpdCBpcyBsaWtlIHdlIHdpbGwgZG8gaXQgdHdpY2Us
IHVubmVjZXNzYXJ5DQphbmQgcG90ZW50aWFsbHkgcXVpdGUgbG9uZyBpbiBib3RoIGNhc2VzICh0
YWtpbmcgUkRTRUVEIHN0ZXAgaW50byBhY2NvdW50KS4NCg0KVGhlIHJlYXNvbiB3aHkgdGhlIGlu
c3RydWN0aW9uIGlzIGRlZmluZWQgdGhpcyB3YXkgaXMgdGhhdCBpdCB3YXMgbm90IGludGVuZGVk
IG9yaWdpbmFsbHkNCnRvIGJlIGluc2VydGVkIGludG8gc29tZSBleGlzdGluZyBTR1ggZmxvd3Ms
IGJ1dCB3YXMgZW52aXNpb25lZCB0byBiZSBzdGFuZGFsb25lIGNtZA0KZm9yIHRoZSBob3N0IG9y
Y2hlc3RyYXRvciB0byBleGVjdXRlIG9uY2UgaXQgdGhpbmtzIHN5c3RlbSBpcyByZWFkeS4gDQoN
CkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
