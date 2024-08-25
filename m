Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1E2801;
	Sun, 25 Aug 2024 08:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724575768; cv=fail; b=lZuaepyO+HcrIdmIR3/P3d3/ot6mQhoxcbgR24hDccg/bNHhZbPB6WUhD7VDQIXsizcKan0QFiUr507ehnomLi+RS6bDtPLyKQHnFgzd7XRL0qv0sPhcOvr8DUkD23yu8of94ldAdlwZPLqrn91Yqf64DeujnRFI/H5wpo7jVik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724575768; c=relaxed/simple;
	bh=dWJpOWy/sebtywUtVUVS6b6RSf0K61j+V3Cac0pBp3Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CdbMPFca5CO6nQK0JeQ6+gwWNAaHd7o7xyVybycO/KSMeGptWC4HysNsX03u7hdiawttNdYSnuldQcx3+jxJZO9Wfdcgu7zmH69+lKVsxNJFI/Kwr4jaEjq4t9ipDt9ucpkze9IkW22M9lmWZ+wNuIx2+aSrSHrrLZcqLj9FIaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gNU9skwT; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gNU9skwT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724575767; x=1756111767;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dWJpOWy/sebtywUtVUVS6b6RSf0K61j+V3Cac0pBp3Y=;
  b=gNU9skwTkrzd7vUftWOPJDTFKQcst/KbGSvdWzxq2H2GQvXvu5RJB1er
   HgqmKAEiELeznB6lvHeN1YmdnXC/sknxm/Xmhoa6OgDA0ESaPpxqnAQyN
   VeQcd/RKi5M1qi1/GewIvOa1DfF/aBkNP4aWOj7emO1xqucUFG6mWhL8+
   BR7+QWkDwERnhH1OnaowZQzzbvjXS98XYxeC1jetrITrN87FLf7+bunIe
   VJ1apIx9qrcq8ZU+WbSZ6vNeY4lpE0zEsO0C4faI4YNCtFGFlkMfbp/Gk
   ZQTKGu8TsD+exoueJVPnzVJncSFBWCv3oEVGcp32n/9sUox0J9SrKK7mi
   Q==;
X-CSE-ConnectionGUID: wPq1qM0FQA2vCnHy+KPHxA==
X-CSE-MsgGUID: q3vTQT1+QAyXDufcoQ5vbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11173"; a="22976309"
X-IronPort-AV: E=Sophos;i="6.10,175,1719903600"; 
   d="scan'208";a="22976309"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 01:49:26 -0700
X-CSE-ConnectionGUID: 4aQ7T6yiQoiGnY6kdfisow==
X-CSE-MsgGUID: 1Kjvrw7XRwm9GPanm7mFTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,175,1719903600"; 
   d="scan'208";a="62065560"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Aug 2024 01:49:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 25 Aug 2024 01:49:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 25 Aug 2024 01:49:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 25 Aug 2024 01:49:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ehhm3B8sePNu5nqScpmeeUdQcFETnmfBD4HLm7tCdVRMBtaCPRJTph3B1YW4Zbyc1HVyjo5e3hO6CFUy1mj35iYTMbVemEl+IoY5MnkNlBw0g4vnDcP9EOvVMtb+B/za/c/o4BRxKSIDwyWRYkxGVlKiEehWEbqtzQSuWIiGVr3GYgkJbQGK2er2N0a3xMMz0W4plcDH4DztnU4ssbajsKhrcgSoMutMu/utBAlkjK6WTvVFBHKKVGKEtKke/FBwnIhsCMhx/R7jCAacCqyz/TMGvTTy+ytO/2CTp9X+1o0+VKU3gUo8uXvM0k6cjbMmAClk2hYUBB7FzXR9yfubiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWJpOWy/sebtywUtVUVS6b6RSf0K61j+V3Cac0pBp3Y=;
 b=jx0DbhzYOit0DEih9zUxwj71LC4efw7z/QYadZCMwGNe5iyODV9OM5x9janPdeb4kT8f74t0IL1VCnXWASJuU8KAi0AUKvj4ynYQczJGhVuOSP6oRzBksGHwSWYwqdlWHqTblUuR2QYTpI6JiKWtR9DdKJkk/pEBEA0nSdqJjobzijZ6zj3uyCubjag/Xt6ZJwE3xP5KcXO/PwoTtDZJ2tpg5QBVP1MVRSHZdTtsv7P05HPHU8uA0/hAHumOjWdyFvqBrsLBhXKhPsS1M7CW9XlkR+p7LtxdQuMAE5Akyos/6lqtaKEi9MalLuAdQIXGZ/hzk2oCQmYwJbzP6+OSjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by CO1PR11MB5139.namprd11.prod.outlook.com (2603:10b6:303:95::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Sun, 25 Aug
 2024 08:49:23 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%5]) with mapi id 15.20.7897.021; Sun, 25 Aug 2024
 08:49:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "wangyuli@uniontech.com" <wangyuli@uniontech.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "xiangzelong@uniontech.com" <xiangzelong@uniontech.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"bp@suse.de" <bp@suse.de>, "guanwentao@uniontech.com"
	<guanwentao@uniontech.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "haitao.huang@linux.intel.com"
	<haitao.huang@linux.intel.com>, "wubo@uniontech.com" <wubo@uniontech.com>
Subject: Re: [PATCH v3] x86/cpu: Adjust the error message when BIOS does not
 support SGX
Thread-Topic: [PATCH v3] x86/cpu: Adjust the error message when BIOS does not
 support SGX
Thread-Index: AQHa9sdng/XBuweyTUGQUbxayS8cmbI3qcoA
Date: Sun, 25 Aug 2024 08:49:22 +0000
Message-ID: <8cc1f0a0a4cb03007d52c040c05bf77f2fa16d6d.camel@intel.com>
References: <2FA59E9E3461354C+20240825081741.3890887-1-wangyuli@uniontech.com>
In-Reply-To: <2FA59E9E3461354C+20240825081741.3890887-1-wangyuli@uniontech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|CO1PR11MB5139:EE_
x-ms-office365-filtering-correlation-id: 70cffbb4-3d2d-491d-51bb-08dcc4e2d0de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ejc3Q0kxQ1FPeHNhYXArUEtwTDNZZWZDS3FjS2lVejhpblpwR1hKVzhtWDMw?=
 =?utf-8?B?KzA0QVA2enBvbUJ5TWZjRWNIdFVKOE1GT3lEdlA0cU1ncE1pa1hPOFBpaC90?=
 =?utf-8?B?WjZmb3NlQ1N0R0d2aGNQN0JyM0pZTDJLbzRhbks2NTBXM2dYdW02L1Bac0Yz?=
 =?utf-8?B?Z28wclArODVuT3JNa1c1NFM5YmdONGQxTytKMjdPVVR3WTJXYkRHQjFiS0dW?=
 =?utf-8?B?RWlQdUhhVDRnbzN6OHEranFKUmFSbjlsQ0xEcGdPcHlCa2dzVzY0RWUxOVdI?=
 =?utf-8?B?R3lPK0haNWlrdmV6cFcveXVkNUtnamRvRmI3eEdLQ24zbHgyK1ZPNndSWlA0?=
 =?utf-8?B?ZlZpM20wREN1eGdSeHNwR0l6Y0ZDM0tzdlcySG9ybjlTUForc1FwVWd1cm8y?=
 =?utf-8?B?YWc5MXFaUzIyQUZQSEdPalRUUG92eXRuK3prVnBlclI1WnltbFJaVjhxV3ln?=
 =?utf-8?B?eEUxWXlEVk1GZldaRmtjYnV6TWpDVDM5UDFtK1FuNCtUdG9ob0I0ai9vTS9M?=
 =?utf-8?B?b2ljUHJ1cGU5anpESDJ1SCttd21LOXR3L1FkMFJEVWRrY2I0alh2RXhmQm5Y?=
 =?utf-8?B?RDRMQy9ocmZ2Qk0wTmZja1R6VmF4VUhmUEtVMkVaUWdQUWZoR2R4UFY4SVZB?=
 =?utf-8?B?NDlEbHErd0xGS0JrM25RbnoyM3JNTEJYVWhmcGxXbHQwZnUwU3JoWTFTbmRr?=
 =?utf-8?B?M2xkdDRyZk96Y01HNnFsc3lzNW9RaTNvbnhNaG1JOG1lMmluZHJ3RUtkaTNn?=
 =?utf-8?B?NFU4c1ZiaFZNL2IrY011ME4vUjd1NDM2cGlkRXZTQkJBUGZvZWNRem93ZG1E?=
 =?utf-8?B?OFhIL1lnUlNZZnVYYWlzbkdNWVo0UTEwMlRXakdUNERIdjE1MzJzUzlFeDV4?=
 =?utf-8?B?bGhGZy94aFFKRkpmNkNpUWkveXhlTW1YWUhqRXk4VEtpeGdzdklGQW1RTmRr?=
 =?utf-8?B?VDBVOE9rcmcwZEJnN256MU9ueklsYUxoMEVyWHFoUmpmVWdFcFRxSVh0b0Nz?=
 =?utf-8?B?Z2N4UWZ2WDJrWDhsQnNSR01vL0FTaUZ1cjlpVHAzT0N6YUs4NGJMaDltS0VW?=
 =?utf-8?B?TE54NmdEcGpCck93Y1JBVFdlYXFWbVA1anhuWFhNeC9WWHNMTG5BdklRemJ0?=
 =?utf-8?B?OGR1RU9LMHYrT05rSzJIOUp1VkNlN2c4ZTBNUkRkdFpONGczaEdjUTNsSURi?=
 =?utf-8?B?c3d5TWdTaVUva1VFOHNaRDIxdjNVVWM4VWhEOTM3emYzdEFpb3VoaWxIUkNR?=
 =?utf-8?B?cWpvdElnZEFBOWxqTElzM243VXl3bklJOUdqSWcxMmJITWZpcHNKbjJwV1da?=
 =?utf-8?B?aTJoeUlNNGF0WkhoV0dDUG9qTWlQU3U2aVVOVE1BVlhsN1ZlVjVOKzdHekdx?=
 =?utf-8?B?bDRydzZ6UnBPSGhqamJrNVRXTndBWkphLzBMRVhlZ0lYN3NyWnJNL2x1Wkd4?=
 =?utf-8?B?UitoUDFPb2hHNmFZdm51RjA5dkdwSUpHTU5wMjRZNHJkTnM5L3ZkOGRZK1Rk?=
 =?utf-8?B?RkFnQm1BSFdyYnNuTXNDSmg0WTdXY3lVa1haUlhhck9UaGRMTmxMZ2VYODZQ?=
 =?utf-8?B?OTlxUlZwSTdPeFRseFVhZmNQandHVmFGcHJ1c1NrZ2Y4TFBVQkE1MVlJWW51?=
 =?utf-8?B?MmM3QWp3eXNFVDZLZ1VDV0pBYWE2TVFPWTJoeXR5SU8xam14OTNGOUxNNGxP?=
 =?utf-8?B?aERsN0lyM29NSGlZWlZMU3Nma1dXK0hTVUJJVWVIYUVKaElyM2l6MVZuMXdw?=
 =?utf-8?B?R2wxR0hKMUxCTXVLREZrbFo4KzNnZW8yVFBLaHpQbExjQ1UwclJzNXJseksx?=
 =?utf-8?Q?swSpwIaqfaimPLrYKYoqbulvkL2sYmwhJSAbU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHZ3Mmk1MmJaWE4zaEYrVFFNZGo1SllEanpyc2hiRFVqZ2EwZk5JY0JCVjVJ?=
 =?utf-8?B?MjVQYzlZMWtRQlhweEhkbTNVYjdVR3lIZGpUZjBCVThpWG5GZ1dsZFlxZVor?=
 =?utf-8?B?cnB5UnBvaFB0NDViaDdMZnEvMmpCaTdhMTF2VkNoZElpakthdXorQ2d2MStP?=
 =?utf-8?B?N1BIaGxaOVh4K1oySE41bmhhM2ZLNERUUEViQm9CMUpsbEVwaDkrRWdwQmdT?=
 =?utf-8?B?ZnJXTGdXVitBSVYrN1ZwSkgrNGtYVzI5NGVubUo0VnM2MTRxTVR2bnBuLzNI?=
 =?utf-8?B?SHBYdmFrN0ltNkNqQnIyRS8xVy9rV21NeWNnSE9QWXJJQTdPNzdBVW41MmV1?=
 =?utf-8?B?emQzVTdpMlJ2M3lQOWFYWVdSVjAyQ1ZFODVZOTBTaVEya3BDSGNUSnp5Nlg5?=
 =?utf-8?B?bWwrVzdvTlptd0RFQ1U4MWptQUtNekZXbDB1elFHVlp0RUJYSDRGUnM1M2Ix?=
 =?utf-8?B?ckZjVU9ZOHFKRThmZEprVUlZeC9LZ2FiaUVORkVLUEljMmhrUlEvaU9uNWsv?=
 =?utf-8?B?OXkrQTN6OGxCVzk4T3B6cGFjYzVDS0dacTJhSXF6cHZjblBaejBYY3Urb2FR?=
 =?utf-8?B?TjZXTUdCaitqMUF2ei9pVEp6TGUvcHEzYkJVMjRycHRNZy93VTZWKzFuZXNn?=
 =?utf-8?B?MWlMeHJaaHRYT3hFRHJXNlZBdWhWcmVadElXRFRvWkNhcmRJZVUzTmJBeW85?=
 =?utf-8?B?UE1nZU1CQUdEUHdqMkp1eU15d3NTZUdrZG1SQ0xQWG5nTFVDMGVmNjBxdWRK?=
 =?utf-8?B?UFdzTWZINzRWbzRFaEhlWVBnNnBsWSsrMVhaWXJ5RkF6R0xESFhmdittREEx?=
 =?utf-8?B?RDVjUDRDMWczd3Y4SFRwRGI3N3I2cGttZlJ5VkRsZHprN00zNVFWZUhOUFpE?=
 =?utf-8?B?MVNoeVhHVjhnWk9Icjg4a1FQa01vd2NqZnlPRVROQWg0ZTQ5ZmpmcE1kcm5w?=
 =?utf-8?B?MXI4bTcrbEtzMFV6UzlDcXZTeDBsV0czQWxEempsanVkNWFzcUx2eXNIaUVR?=
 =?utf-8?B?ZHR4SXhMdjdLOUQyTzdSaXNJcVg1L2t0Rlg0WFZyOEFlelp2akpKdmFPQkFW?=
 =?utf-8?B?QzY5dzRTOWxDdGZHNFJlL0hVakk2bFd2dzRpczR0a3FuamM3bW5IVEJPa0tO?=
 =?utf-8?B?VjNPZFovMGV6cEszaTc5RTJCYS9ldmpTdVUrOHR2dm5JaU9CWHdtU1VoNUxm?=
 =?utf-8?B?Z0ViRWJLK2MzYklzZkRua2gwbDJiTXNtWW5Db2cwREJRelRsWEVhVDNyWnNm?=
 =?utf-8?B?clJIODI0WmVTa2ovU0RCTnh4YzBIS2J2RlJUNkc4Yk9DNjFiNW9Pc05wVkVa?=
 =?utf-8?B?Um03NHFrRTQ0ZUNDdU9BL29pa0VzdjB0L1poMTkxdkJWbkNIQ2dWVEk5QlNJ?=
 =?utf-8?B?Um1CRmk5RytFRmd3VWh5YVJBWUx4b2hUZ3ZlN2hqbWxudGYvV01WbkxUdGJN?=
 =?utf-8?B?WW1hYkNDMGswYjNJcThodGhvTGU0Wi9LbU1NejJZWkovUkNPMzRxczJBV0VO?=
 =?utf-8?B?dVNlRWhkTzVvbS9lZm1NcncvNWVDN09qNkdmVkthaHJ3UGZKODMrdUdHVnA5?=
 =?utf-8?B?SE16M1puTTF3MnpyQU5mRmR0LzdmZ0FqUXc5VURiTU5WNlBIamJzSHNNdUJW?=
 =?utf-8?B?RkNpWnF4cTRmOTQ5SmJFeTA0b3FvcWtCelVVL3JoODBWblAwb0R4QWxsUzRS?=
 =?utf-8?B?Qk9iejJBdUdSQ0JBUHRob21kOFcwYUZJS1FYTUh4a0NKbDlPRmRVaXBPY2x6?=
 =?utf-8?B?NlZYb2t5by9JU2xTWDI3NW1nZ3VoV0FaWUdzQnIyNWNVU1AvVTZ4dWtSM3pT?=
 =?utf-8?B?bzJCMkNhdzBJUnArMDhEVVNRQkZudmozWXJXR3VqWEVUdmx1TFdWdGtwemRV?=
 =?utf-8?B?SkJJclhzRDk2VDJDNTJvOEZjVnd5Y2V6NkZJZmRndW5UYTNmSXQ1RzcxTFJ6?=
 =?utf-8?B?ZlR1WUwyNXVaaXE2RUQybS9OYVYzczFReGJWVkpVdDVIcmRTSHFVSDdsb2o0?=
 =?utf-8?B?VGJtUngxVFVyU3I3WjhJWUN0RlI5QU1rWThiOGwvVHJiQmNGZjdpZGs4ZFM5?=
 =?utf-8?B?WGxiL2E0N1lhSTNxV0RTcEI0QlJyNnRHNUluNHY1V1cvUU9HN3Z0K3psTkcv?=
 =?utf-8?Q?MsN2Gh7HZ8p6wmqzgG/MWoBSU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8334334E9B9CB4F9635C411D6D0A0A1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70cffbb4-3d2d-491d-51bb-08dcc4e2d0de
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2024 08:49:22.5592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PHT+VZRzNMXYzYsfqhk18dxHcp7m57zVd+9VIKsw0ussAD2hXFSzdhS2CklHjdE64zdz2Lr+D8CxYjKLeClP1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5139
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI0LTA4LTI1IGF0IDE2OjE3ICswODAwLCBXYW5nWXVsaSB3cm90ZToNCj4gV2hl
biBTR1ggaXMgbm90IHN1cHBvcnRlZCBieSB0aGUgQklPUywgdGhlIGtlcm5lbCBsb2cgc3RpbGwg
b3V0cHV0DQo+IHRoZSBlcnJvciAnU0dYIGRpc2FibGVkIGJ5IEJJT1MnLCB3aGljaCBjYW4gYmUg
Y29uZnVzaW5nIHNpbmNlDQo+IHRoZXJlIG1pZ2h0IG5vdCBiZSBhbiBTR1gtcmVsYXRlZCBvcHRp
b24gaW4gdGhlIEJJT1Mgc2V0dGluZ3MuDQo+IA0KPiBBcyBhIGtlcm5lbCwgaXQncyBkaWZmaWN1
bHQgdG8gZGlzdGluZ3Vpc2ggYmV0d2VlbiB0aGUgQklPUyBub3QNCj4gc3VwcG9ydGluZyBTR1gg
YW5kIHRoZSBCSU9TIHN1cHBvcnRpbmcgU0dYIGJ1dCBpdCdzIGRpc2FibGVkLg0KPiANCj4gVGhl
cmVmb3JlLCB1cGRhdGUgdGhlIGVycm9yIG1lc3NhZ2UgdG8NCj4gJ1NHWCBkaXNhYmxlZCBvciB1
bnN1cHBvcnRlZCBieSBCSU9TJyB0byBtYWtlIGl0IGVhc2llciBmb3IgdGhvc2UNCj4gcmVhZGlu
ZyBrZXJuZWwgbG9ncyB0byB1bmRlcnN0YW5kIHdoYXQncyBoYXBwZW5pbmcuDQo+IA0KPiBSZXBv
cnRlZC1ieTogQm8gV3UgPHd1Ym9AdW5pb250ZWNoLmNvbT4NCj4gQ2xvc2VzOiBodHRwczovL2dp
dGh1Yi5jb20vbGludXhkZWVwaW4vZGV2ZWxvcGVyLWNlbnRlci9pc3N1ZXMvMTAwMzINCj4gQWNr
ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gTGluazogaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsL2EzMGY3NzAwYzc4MTdiM2U3ZTJmMmJkYjM3ZDVjMTBhMzE4YjJj
M2IuY2FtZWxAaW50ZWwuY29tLw0KPiBTaWduZWQtb2ZmLWJ5OiBaZWxvbmcgWGlhbmcgPHhpYW5n
emVsb25nQHVuaW9udGVjaC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFdhbmdZdWxpIDx3YW5neXVs
aUB1bmlvbnRlY2guY29tPg0KDQpIaSBZdWxpLA0KDQpXaGVuIFRob21hcyBwb2ludGVkIG91dCB0
aGUgIlNpZ25lZC1vZmYtYnkgY2hhaW4gaXMgaW52YWxpZCIgaW4gdjI6DQoNCmh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2FsbC84N3pmcHg0YTBxLmZmc0B0Z2x4L1QvI21kYzE5YjAwYzEwMTc3ZjNh
ZGQ5ZGVhZjUwNTIxMWJmOGIzZWM3MTEwDQoNCkkgdGhpbmsgaXQgbWVhbnQgeW91IGVpdGhlciBu
ZWVkIHRvIGhhdmUgYSBDby1kZXZlbG9wZWQtYnkgZm9yIFplbG9uZyBYaWFuZywNCm9yIHlvdSBz
aG91bGQgcmVtb3ZlIGhpcy9oZXIgU29CLiAgVGhlIHJlYXNvbiBpcyB0aGUgcGF0Y2ggaXMgZnJv
bSB5b3UsIGJ1dA0Kbm90IFplbG9uZy4NCg0KVGhlIFNvQiBjaGFpbiBuZWVkcyB0byByZWZsZWN0
IHRoZSBjaHJvbm9sb2dpY2FsIGhpc3Rvcnkgb2YgdGhpcyBwYXRjaC4gIEUuZy4sDQp0aGUgU29C
IGNoYWluOg0KDQoJRnJvbTogWW91DQoJQ28tZGV2ZWxvcGVkLWJ5OiBaZWxvbmcNCglTaWduZWQt
b2ZmLWJ5OiBaZWxvbmcNCglTaWduZWQtb2ZmLWJ5OiBZb3UNCg0KLi4gbWVhbnMgdGhlIHBhdGNo
IHdhcyBvcmlnaW5hbGx5IGdlbmVyYXRlZCBieSB5b3UsIGJ1dCBaZWxvbmcgYWxzbw0KcGFydGlj
aXBhdGVkIGluIGRldmVsb3BpbmcgdGhpcyBwYXRjaCBiZWZvcmUgeW91IGZpbmFsbHkgc2lnbmVk
IG9mZiBpdC4NCg0KRm9yIHRoaXMgb25lIGxpbmUgY29kZSBjaGFuZ2UgcGF0Y2gsIGl0IGRvZXNu
J3QgbWFrZSBhIGxvdCBzZW5zZSB0byBoYXZlDQptdWx0aXBsZSBkZXZlbG9wZXJzLCBzbyBJIHRo
aW5rIHlvdSBjYW4ganVzdCByZW1vdmUgWmVsb25nJ3MgU29CLg0KDQo=
