Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4531719ABC6;
	Tue, 14 Jul 2026 00:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783988533; cv=fail; b=CkcBNoVpmjq4PSmZ2V9wyxiS8uJOl/P5zm+EOh6jr5jCnnlMOZ5o/WcG1HdDFwOmc2g6RLFiI3aRe2pJKhPVg2z0z0nn4mE0LizXaX3G0PkjuZ0YwXDjgVhqaVR4bVlPthNY/wdNhHmeoyStWHuEoKCBN3IJEq1llKtw+qwFqjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783988533; c=relaxed/simple;
	bh=tAlNk1gG7byOOI/pn2ytNgbCpj6GeuGvxmbFueymwVE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c1sD876tZyx0Slnlr3IusoRpCRv4+ycpLYiOmHOy4xPv0lmAEG3MO7X5yHAJFfkf1eg4GvyEYGNdGuc/jT4Ln+zNZGjrGJF0/U8R7w1sF8Z6s2bpyg/zbh4S2o1wqo7077OKIsJLjW/eqBhv56QUtAYKruCJVQa+KgI47cYJ10M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CN4lp3rX; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CN4lp3rX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783988531; x=1815524531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tAlNk1gG7byOOI/pn2ytNgbCpj6GeuGvxmbFueymwVE=;
  b=CN4lp3rXIpceYXW7+Yo4qxsZeDi5hKITlekP+8m2NGXUYKpoA9I/BZuE
   Rc6zTglNj1aQjabKyPi8c+rp/7vT1RdsiyJTN/uhHCxrZiuEYzKbvnCmu
   sOZ7y7A55+oU57xYWFYuyIWRHpnp6dULylJY6dHwPKO13kfaQqk4APhye
   DcRLgQNHM/tRjdwUlnhjscyXp5UB5SPxdysOtod3hIoA55Rvy7+ClxhZc
   vvrsQ9OE7Bj6lkkFEXoETqfP/qdy38Jkqv8hVGbM7fknEORZjCNqORYjK
   Nn9h7AIZVVJLPob2mYPw5sJ5pEWG/E7kaMP7W9+P4t2jWoW2lHy+/Wq1f
   A==;
X-CSE-ConnectionGUID: Emfq95JCSv2ZnoJnmFEaBw==
X-CSE-MsgGUID: oiHuuewzSSKeN2+BgnzkXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84569257"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84569257"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 17:22:03 -0700
X-CSE-ConnectionGUID: qoKdbhF1TjeXRia1Ct3IuQ==
X-CSE-MsgGUID: nUkRn5RuRPClz/Kk5+gtpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="259549086"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 17:22:03 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 17:22:02 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 13 Jul 2026 17:22:02 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.46)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 17:22:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZEeAo4aNEFbvPzOtGCu4EgLBdBTQh0Gd114OCoese3RUX0zGI/WwerSF+nbumD9Pxch71XFaiTct9lokq3tbToM6iQztkulqMHBgBLwysUfZ+fy1RW8Pbd++IPM/FyGZQt+yz3o5WZ3vd0ekz9JRscl7U2AowffyZk4AlRN4buk1MrwySSMIWpm98At9XE6xgGRiQ+/d6WOj/uXpyQCZApaySeivua5wQgmt4+aU3fFFatMiZoS+eWtHo6ZfoCht+S291tFGmeqyqkK4SDUazhDyHbS34TO7WNCHN/JOKJf6gXnfpLWoiRpWxng7y/C2OT/iMAj8OlaoK2JcLi20zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tAlNk1gG7byOOI/pn2ytNgbCpj6GeuGvxmbFueymwVE=;
 b=p0bJShR2BqVgh1a4wnUFqRnL20/xnK2gWHkPtlr6jeJfOKNp2L+bqIB9uMiUZfyxbqEKHdi43DTTlBJXp9po9DxBCBpKi8zJdu+Uzlg74pvxfxWy4UwDGGJ1p26JQiDdVzlGbLshxapgUP1L+yZxzslazC3PKtK8v8K5l4/7NdPVaUQazRfHdCqyDYo322n4aPvSgMDfQxL0m4wHyo349WXZnozvrj1VAQnOiovDk5wKa8XO4arUvR67vmWqiOXs20fkdMaPKNwQDlT9/um/DQvgLbXoda8Ulm89pLc8KNsYNOy/6cyG2+KiXQ4vpivPZ+L5WieQfgtKlFhwlQcPmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5702.namprd11.prod.outlook.com (2603:10b6:8:21::10) by
 DSVPR11MB9580.namprd11.prod.outlook.com (2603:10b6:8:389::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18; Tue, 14 Jul 2026 00:21:59 +0000
Received: from DM8PR11MB5702.namprd11.prod.outlook.com
 ([fe80::a973:3a5a:91e8:49b9]) by DM8PR11MB5702.namprd11.prod.outlook.com
 ([fe80::a973:3a5a:91e8:49b9%7]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 00:21:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"thorsten.blum@linux.dev" <thorsten.blum@linux.dev>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org"
	<x86@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86/sgx: Use SGX_LAUNCH_TOKEN_SIZE in
 __sgx_virt_einit()
Thread-Topic: [PATCH 3/3] x86/sgx: Use SGX_LAUNCH_TOKEN_SIZE in
 __sgx_virt_einit()
Thread-Index: AQHdERxKSvski4dogE601j673tca3rZsK1SA
Date: Tue, 14 Jul 2026 00:21:59 +0000
Message-ID: <917f1afc4e625b63a3387672b567cacfa1ec5503.camel@intel.com>
References: <20260711100053.739588-5-thorsten.blum@linux.dev>
	 <20260711100053.739588-8-thorsten.blum@linux.dev>
In-Reply-To: <20260711100053.739588-8-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5702:EE_|DSVPR11MB9580:EE_
x-ms-office365-filtering-correlation-id: 32b3534a-418c-416d-16a3-08dee13deb66
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|38070700021|6133799003|56012099006|18002099003|22082099003|4143699003|11063799006;
x-microsoft-antispam-message-info: bMyTm/H9laK9pj+imypJTqDPRJD5ERIYinfj607Roawtyzzsxu4qa+bMZbtPrRlpebsDF/JlKc7XFysmlOO8eHF79HMmSP0HUhgfz7T94hHFeeEioCgLyWbQmirYNZIAqUs/xbSubZvdJq4znT711ItcjubmZBvukDH7kW19v6gliWNi8ygV7Mb1ImFtRdNvxexZl5jTu85S4/3mizZIvY/vPoQf860jRRbT0cco+AHZLAD8zFEX1QUnRwaNFiSSEFTRNV2kmleP25qv+uB61D7R539xkhN7QcOIYKDbEOCLjFkaB5DoZaisQp63scLWO9m17oCYMviJ4MLrheZKg2gcqKy8TjJqdgkYuTVzeBNnq++6hyyN6Gq8lp3oSMwd4YpaWTdInAmZXpNvh0LMbq5HS+n9jCR0UGwmIQKJlLCkXuprTC7VOqXkP1hFaNLXN3N4meJdFwn1M9Xs1Wa5H008j2ginJNH0LHQVAY4N9AKmzDRilm2/MybgQps4XLmX14KXze1e0yjbhlDPWbu6dZouHtbHXtK3onSbKJLNJZuCb6V5g8IBS8xtr5Yz6p0U/rlH0dc0pViNqiuucjbL7JqzXFpNz/s/zMM7mUmR2RdeDXwTjIzb4JXE7uXmgca8MHLjvFP12UR05X4Wtm2Qcww/0qRsdyIHLgtqY0zzjaioJbg9vcgHtBrDr7H199o1F1B3Y6BR6LHYOMTO4BoAKyuyQcrqYQ6Zj/Mg5L2mQI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5702.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjE4bWo0QVNxdm0vSFFZUkFDMjZzRmI3Q3N1TnFtNk1PZXJnRkswc2h0U3Zm?=
 =?utf-8?B?TlV6TWZDbnFua3d5TGxFVG9oZEVFRTRuMFFma3RvMUdhS0I3WjcyTGgyOXlw?=
 =?utf-8?B?RXVtbnEvclFwVDZRWVFycUFJaUdxY1NUMVZXem5qdkR5UWRWTWZCVUZKK0dw?=
 =?utf-8?B?a1IzOEFPbDdoeEFlQ3d3UStuUThjUFA1WDVlenJCTXlUVDRhWm93T0pQZ0U2?=
 =?utf-8?B?YlpnUGtrQkJ1S0dQNlZkRENWQ29WUUplTzVzUVNOUjFwUzkxN3ZWNjF1a1VQ?=
 =?utf-8?B?NjIrWTRUYTV4MmJYcUgyNitmd0J5Zng4a2thbEJxK1p0SjI0Vlc3Wkx4dnBK?=
 =?utf-8?B?ZkF1NUFKMnlXTXhCbkRvMXl0ZWJ2S0M1NkxaUkJaOEphcjdlSW9PaTFUQmpl?=
 =?utf-8?B?NjEzM1ozMGN5VlhWTUJPWWlLUDAvMzJ4WnBGRGlpSzlaYXhiYTVFekpDdTdr?=
 =?utf-8?B?RGY4Z1ZaQ0liNThGMzVvN0dUTXF2WUFhdnhyTWJ3WnVSWGZjNnlrSENZM01W?=
 =?utf-8?B?aUZVcVliMGpzUzFnZ29SUWNjUmE5VUVlU2NPRkNoUHVLMVZCMHhtd2lNRWtL?=
 =?utf-8?B?aFROOUd5Y2E4cG0wTTdzaGtNY05yV0pYbUN5SGpFUmxZcHo3TUxVejB1eG1F?=
 =?utf-8?B?cGdpSWNkSHE0RFJMVHp6bitVMVdzdTdhOWpmbFlCOGtoNmt1QXBJcjNXQm4z?=
 =?utf-8?B?SmQwN2dQeFVzNHpYbHN1Nmo5b1dVaFFnOEhuVXVFeTAzSFRWMm95TVZMOFcw?=
 =?utf-8?B?WUc3VUkreVJ4WXdCcFpYOUo3S3RMS05DSkk0VEUvS0RlYlRwWHU5SHlPdi96?=
 =?utf-8?B?aWNMcGdFb2pxcG1WRndYbzdhaDVMY2dYRUhEVjd6V0Nib3crU0x2NG5qR202?=
 =?utf-8?B?aTR6VkdoWmZ6cjZ5YmNNcDlYNGUvbEYxbFRtc0docVZ3Sm9ub25SSHdlMk5O?=
 =?utf-8?B?RDF1R0d3NVdITVJJVERpNHJNSDZCd2E1VTZJRDNqNjNNRHJYYnIzT3VpcUZq?=
 =?utf-8?B?YTl2aHg5RUJycnBOYnkyQjFFSDcwSE93aERlSlIyUzh5VWR5QVJEQ1NLRGln?=
 =?utf-8?B?cTl6b2grVzhzakF0Yk1hb3hDVCtkVUl0aHBMSHg5Z295NVh5Rm94ZS9MSVlU?=
 =?utf-8?B?em1xbHNNbXIzVmpZMklUNk5WZEFYWlpQMURlK0t1a0xmd2l0WnN6VVd0SzNk?=
 =?utf-8?B?cTViU0lJckZSaE5NWkFkVU1hSm91U2JrVytCcVNOLzdxZGR4MFQyMVFxU09n?=
 =?utf-8?B?VUFHMnFmZlhKdXViOW0vZHFBUmVmMXJEenBUNkxxQk5SVVhyRHRnZ2EwUzlZ?=
 =?utf-8?B?U29EdDhjOUxPd0pBc0lVNlA3SjFMa2JieE9CdDNucXFDTCtMRXlaUWZWVGts?=
 =?utf-8?B?ODc4SEN4MGVyc2U1L2FUT3pBdHZUMFJBajhNR1VQT2VNRm1QejRPWS9rNzlI?=
 =?utf-8?B?VWJ0R1dUN3AzazNFeSszSDZLYlJiVDBnRnRYZnVwdjJDWlZXVktUc29XUkxl?=
 =?utf-8?B?ZllnYVRJK253RDl2ak5QcTJFSmlVOUk4VnZZMlhYazg3NytoWmRQMWlWWTFR?=
 =?utf-8?B?YkFwcEFJNitXN1Y5bjlJamxONDJIQjhKNlcyenlSYUo5NjlWc25FckM5eEtR?=
 =?utf-8?B?aVNucDZzbllaenlYYmYyWmVQWVI4eXJqSmZEa2p4V2htaFNyeTJGb1Q0SFQ2?=
 =?utf-8?B?YnFlZ3loR2RYQmVNN1pCbExmcWpyNWVMM1c4MU5nd3BzK2hZSGV5ejk0SlBE?=
 =?utf-8?B?bkg3M1lnVnJWcDhJV0tCZ0tBUVQ5RFloT2RFa09jbis4c0txS3hEU1EvSi9y?=
 =?utf-8?B?cWdnQTYzdklqSVZJUXVDMEw2d2QrUkhPVU4wSGlMNzl0clVtb2Q5b1h6YzV5?=
 =?utf-8?B?Y0pabzVBb0ppbGl2RWJwNDZmYTRDNWEwU0xUZDJkUlhsNVBGTWVNZnRSMVFr?=
 =?utf-8?B?Y0lxTDFiQ2JyY2Z2Zi9VQjU0R2g4bXlWcFoxeUhLMVFtY0liWE8wcWVEZHFt?=
 =?utf-8?B?cGxaaDExZEgvVnJhSDFtU1ZqaU55RThWMTdKYnpwc00yTVg2d2dZNERrMzQr?=
 =?utf-8?B?NjF3T20wWU1MWVFSRml0R1dFTFB5dzN2cytYWTFLQnlGUTNmS2NlNWVXbVlj?=
 =?utf-8?B?Zm1IeUtkSnZCZUNGVVN2RVFSQWkvdmRDQUd5VDlFbklLRFNMYVNGZXdRL2dw?=
 =?utf-8?B?N1piWmgzUWIwSmVDMCs1QTJldUJsd1gvcFpwSzdvMzMvZGwzVkp2WGE2QVpH?=
 =?utf-8?B?ZlhEaVlvcXFZZ2FZdWhjSDlDb2gvSms2SllBU25Bamt4UjlDK2ViS003eDE4?=
 =?utf-8?B?bHcxcWt1ZnFpTDF6ZlBiVWRuZ2JNZnIrWkVnQkVBVU15UE45TlhTdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8EB0CA28860C204380527F5F9D1D57AC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: DzaFTqMAOUbA7icJo94ewUffu1TUY9iFr4iP13R6/S2h1b2QnoFcVcqTXS/ZDGRrZeMEdDpY55bogpxv7WHWq1DgYfsIQ2Cj3cBw2lT52dReo66f9jD2tqTF1laUaoykPGx2uqdY5TCnUiuVEvPPJyAp9kgA1AxW2bolCjLda2/o2qZi7Hleu7rYBbXgZsjbRrb7QglFH604Vg5K8ZPNNKnLjzlrMvAZI9DnA9mMHioqI5QCz4edTPR5iuUq/G4Mlr2VK2JuIs9t/qYhPcvvfIHCEcNjXgdSigb1SaolHSs+h9KeFAuVr0WlrBkshWH4KA1OA5M5bnrFeU0WZQblnw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5702.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b3534a-418c-416d-16a3-08dee13deb66
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 00:21:59.1135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z6X3GBvKuS+KNtHIyDyi7B4iWoD2ZVJXBRkM5iky7lyGmL3Dy0Q4oTPLBIEkI1w/QGhJKl4rLtGsycL1L7F4Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9580
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI2LTA3LTExIGF0IDEyOjAwICswMjAwLCBUaG9yc3RlbiBCbHVtIHdyb3RlOg0K
PiBCb3RoIHNneF9pb2NfZW5jbGF2ZV9pbml0KCkgYW5kIF9fc2d4X3ZpcnRfZWluaXQoKSB1c2Ug
dGhlIHNhbWUgMzA0LWJ5dGUNCj4gbGF1bmNoIHRva2VuLiBVc2UgU0dYX0xBVU5DSF9UT0tFTl9T
SVpFIGluIF9fc2d4X3ZpcnRfZWluaXQoKSBpbnN0ZWFkIG9mDQo+IG1haW50YWluaW5nIGEgc2Vj
b25kIGxvY2FsIGRlZmluaXRpb24swqANCj4gDQoNClsuLi5dDQoNCj4gZW5zdXJpbmcgdGhlIHRv
a2VuIGluaXRpYWxpemF0aW9uDQo+IGFuZCB2YWxpZGF0aW9uIHBhdGhzIHVzZSB0aGUgc2FtZSBz
aXplLg0KDQpOaXQ6wqANCg0KVGhpcyBwYXJ0IGlzbid0IHRoYXQgYWNjdXJhdGUgdG8gbWUuICBz
Z3hfaW9jX2VuY2xhdmVfaW5pdCgpIGlzIGZvciBydW5uaW5nIGhvc3QNClNHWCBlbmNsYXZlIGFu
ZCBfX3NneF92aXJ0X2Vpbml0KCkgaXMgZm9yIGV4ZWN1dGluZyB0aGUgRUlOSVQgdHJhcHBlZCBm
cm9tIEtWTQ0KZ3Vlc3RzLiAgSS5lLiwgSU1ITyB0aGV5IGFyZSBub3QgInRva2VuIGluaXRpYWxp
emF0aW9uIiBhbmQgInRva2VuIHZhbGlkYXRpb24iDQp3aGljaCBzb3VuZHMgbGlrZSB0d28gc2lk
ZXMgb2YgdGhlIHNhbWUgY29pbi4gIEFuZCB0aGUgYWNjZXNzX29rKCkgZG9lc24ndA0KdmFsaWRh
dGUgdGhlIGNvbnRlbnQgb2YgdGhlIEVJTklUVE9LRU4gYW55d2F5Lg0KDQpJSE1PIHdlIGNhbiBq
dXN0IHJlbW92ZSB0aGlzIHBhcnQuDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFRob3JzdGVuIEJs
dW0gPHRob3JzdGVuLmJsdW1AbGludXguZGV2Pg0KPiAtLS0NCj4gIGFyY2gveDg2L2tlcm5lbC9j
cHUvc2d4L3ZpcnQuYyB8IDMgKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9z
Z3gvdmlydC5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvdmlydC5jDQo+IGluZGV4IGRiNjgw
NmM0MDQ4My4uZmE5MTczYTkzODRhIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC92aXJ0LmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvdmlydC5jDQo+IEBA
IC0zOTQsOSArMzk0LDggQEAgc3RhdGljIGludCBfX3NneF92aXJ0X2Vpbml0KHZvaWQgX191c2Vy
ICpzaWdzdHJ1Y3QsIHZvaWQgX191c2VyICp0b2tlbiwNCj4gIAkgKiBBbGwgb3RoZXIgY2hlY2tz
IGRlZmVycmVkIHRvIEVOQ0xTIGl0c2VsZi4gIEFsc28gc2VlIGNvbW1lbnQNCj4gIAkgKiBmb3Ig
QHNlY3MgaW4gc2d4X3ZpcnRfZWNyZWF0ZSgpLg0KPiAgCSAqLw0KPiAtI2RlZmluZSBTR1hfRUlO
SVRUT0tFTl9TSVpFCTMwNA0KPiAgCWlmIChXQVJOX09OX09OQ0UoIWFjY2Vzc19vayhzaWdzdHJ1
Y3QsIHNpemVvZihzdHJ1Y3Qgc2d4X3NpZ3N0cnVjdCkpIHx8DQo+IC0JCQkgIWFjY2Vzc19vayh0
b2tlbiwgU0dYX0VJTklUVE9LRU5fU0laRSkgfHwNCj4gKwkJCSAhYWNjZXNzX29rKHRva2VuLCBT
R1hfTEFVTkNIX1RPS0VOX1NJWkUpIHx8DQo+ICAJCQkgIWFjY2Vzc19vayhzZWNzLCBQQUdFX1NJ
WkUpKSkNCj4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+ICANCg0KTm90IHN1cmUgd2hldGhlciB0aGUg
bmFtZSBTR1hfRUlOSVRUT0tFTl9TSVpFIHNsaWdodGx5IG1hdGNoZXMgYmV0dGVyLCBidXQgSSBh
bQ0KZmluZSB3aXRoIGJvdGguDQoNCldpdGggdGhlIG5pdCBtZW50aW9uZWQgaW4gY2hhbmdlbG9n
IGZpeGVkOg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K
