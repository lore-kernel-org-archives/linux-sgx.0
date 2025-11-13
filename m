Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687CD2C181;
	Thu, 13 Nov 2025 01:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762996889; cv=fail; b=HGjZk9kDgSJSUCrZVsurgP6/GT8LQyp0PH46g+acLxIEuoVgGH+vXRHnwR46ZPt0a4r3D8ANuCCx20i5lSqgt0kKexKhYw/YAp5Ge3Bo2glQhM1MeORYejsLgs/gznKFO9T/Fghe1FJHFLnMpkxhKh45rI8TbNpIs7+ts+54nC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762996889; c=relaxed/simple;
	bh=2eJnNnSrJA8kcAb05sXcllp29crzcTLN7d/9sxzp+qs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YcooBwEEInfeX/e0rH5aFt9YqVVszDB0i0G7l97+7WaPpLXO5gjzaO5fprR6n/sXnz1POhBO+2100wWX/rzGyxOLpBe3Z8ZYaHj/6zjEbP88KwS/cher32/XZhyQgvHGDA1EIgXJ5KfC9uYFL1VIEs+XZNaFL2GTwHZy2kyiq2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PFRGFmAo; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PFRGFmAo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762996888; x=1794532888;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2eJnNnSrJA8kcAb05sXcllp29crzcTLN7d/9sxzp+qs=;
  b=PFRGFmAoNSECiJkSfQtHSB0yXNFHOwyTmlkb17mgchCkb86noGyxodwW
   8/BCgqCAqtMOBWYIMGf6am4yAPMY7rN6BQfC4yY4jqroWbxbemMyGIUcC
   Tl7ESReeepQtwCaNNAN9y2oLwe/9cMo8disntG14xhv9SAhhH1r+fzWWR
   Mru/+6Whr/YI6KmXyx1MTPGUTy+yqiUmHi74HmytANDG5GTiTlmTY4+gq
   W4kw4Bi+jhxXf8luz2ZgbpwtWc+AIuvWAU2YrBKiVTrCM4+phWNY87PvN
   yGCoB0w2hHh91hspwfljfg2jrsY6cQgUzDciuzS7cd2bCx10TpF7kfbSb
   w==;
X-CSE-ConnectionGUID: pKvzHKRETWyhqd311fN+5g==
X-CSE-MsgGUID: 934cMAgsSpCot/yYsuyTPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="87714154"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="87714154"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 17:21:27 -0800
X-CSE-ConnectionGUID: P4nM+XglR1C+Kt5AHghB2g==
X-CSE-MsgGUID: mEDqKhOGRlONOwpdQ+YVLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="188650381"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 17:21:27 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 17:21:26 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 17:21:26 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.54)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 17:21:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H1Z837IRf+i2Y5dFY9qORu+JpnIOvnnu3P0e3UwRFMOTyJA1lv25NMLmOixBM4Q6U6bwysfXlnM+h0TNxd7R3Lj7ig8NMsQ+fmA89o7hgnwB/0D0Z+8b6DM9KloCOcqH1a2aNgCuOCiY3ziJYkiCvdddv4kcnSEjTd5RJK4HbZmfco8dEC0T3rpg/P+Yau92jIb7yIFmnQGcHNEFk+U/2bsb79Oytz8rzie3NHfNzJ7+2TzU7RCdZ6wUAWMUp2Ab9x5S/W+dXE3HgCtHRRQSSEG21xvYhQko/sIiQTQh3PIsry7xtb51erGM9gzC22vkRVhuc/NxXiwH66KEeiijTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2eJnNnSrJA8kcAb05sXcllp29crzcTLN7d/9sxzp+qs=;
 b=SwRZfEdNByWO4j41EbcwGTgU8Iz1jKSK1IEBmEDl1o9PUXysIxdYgibjlZncRXK5EyBmk5TZJEtxQ5wX/wWZX+/QT8h5CGC88E5u2jUsE5cjJTPL10WcrzSLr9laFId9KLsM0eVAl4LsPeOwanKMewQbNNt3hVZl2dm8d9kZ/QCCchcqiJiHZCjGWW3JaBCpt/9TWDC9TeLIpE4UsAu+MHdr02khmzv8jnN+xa31f39t45jKTw6V/OdBQ+Aqg9YINn4a3GGVUcLZ/JcqkdPUzvgreF5UUCAv8AUukDBFMi6eFhsm+SOJUcBTVj51hlSeGx3SMoNQEjvjWimkHRUSxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM3PR11MB8670.namprd11.prod.outlook.com (2603:10b6:0:3d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Thu, 13 Nov 2025 01:21:24 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 01:21:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] x86/sgx: Remove superfluous asterisk from copyright
 comment in asm/sgx.h
Thread-Topic: [PATCH 4/5] x86/sgx: Remove superfluous asterisk from copyright
 comment in asm/sgx.h
Thread-Index: AQHcU/GD2kXkCzJRpUybsX24NTufXrTvz74A
Date: Thu, 13 Nov 2025 01:21:23 +0000
Message-ID: <e9d4460fe1b6658d562edfdaf0261e70215636a6.camel@intel.com>
References: <20251112160708.1343355-1-seanjc@google.com>
	 <20251112160708.1343355-5-seanjc@google.com>
In-Reply-To: <20251112160708.1343355-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM3PR11MB8670:EE_
x-ms-office365-filtering-correlation-id: 4181d82b-63c4-4324-3808-08de2252f5d3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VUZkQ2ttdHEwcVBCY2Nha3RRWGtEUXlRT1dubGNpZTVXRjBXK2ZRUEVha0Jq?=
 =?utf-8?B?ZmRqWmFrQUs5a01saDB5WmE0bWY2Um1CdUh2UjNFNlIxUXhnRkRKZnF5RjRB?=
 =?utf-8?B?RFA5KzkyTTR6WklTZ2VmZlNEL3c0MkswSTcxMGp6WlF2N3BTRFJPcjE5RkxF?=
 =?utf-8?B?SGY5TUM5VFFxc0FLN3ByWnFRR0tUKzBTckd2UFQ0eElJaUVNbTQ4eWs3OTMr?=
 =?utf-8?B?cHRvRzBVekwyVm84b3pGRjQ1OU80V2tBMWNRZnQrNm02VjhnN1JKeUdPQzFT?=
 =?utf-8?B?Q0JPTkMyWnMxV2JldTZQWW56YTFKN1p4SVpKaTNvU01ybFdpOFFrUnNWOG0w?=
 =?utf-8?B?blJ3WEIvV0k1UHYzRVh5TDYxeldCeituOW5uR0JjK1dWVU5TL3AwM1Zta3ZX?=
 =?utf-8?B?ZHMyeWx1SkFoZlhNczBLTGttN2pYcXU3bWF6N0FHbXdYZE11NjFxSDdONEZh?=
 =?utf-8?B?ckUyM1FFUGpoZnJReHh5ZjBQM1M5N3FDK0QxOUYrN3lTZ09pRGl4OE92c3dO?=
 =?utf-8?B?R21FYjh2WExabDVkK2pUMG1sSHMvcVdjYVhESFhuQ0lPMFNzR04yVWhSQnY3?=
 =?utf-8?B?WDVCT0hRaVV4UmdCamk5Y3FDNU8zdllLNXRMblFYR1N6bzY0OG1odzRKbFZj?=
 =?utf-8?B?WXgrT29OWVhSOHNydWJyaHAwVmxRZUk4MWU3aFJHYzN3STVSMFgveit5SERX?=
 =?utf-8?B?ODVITm1QYzdEMzNyYWJXZXJqeitQWlhPRmo4dzEvb2pzTzRZSG1BcUllMThw?=
 =?utf-8?B?dzlZQWxsdFUvTHZweUFEZjdNcXNFaUZtaEdiN2pvNFg2NDNvTE53T1hyZ3Na?=
 =?utf-8?B?VjRhN0x2YU1iUUxBc0huUzU2d3c5Q1pBeFBiRHFtTncraHlLUi9PeFRBOFF4?=
 =?utf-8?B?RnN1MW9zaitLRDNOU0doSVc1UG1tR0JkZlkxTjBRR1VuV3VJQ1E2QWJzZWhw?=
 =?utf-8?B?aGJvUTZHYUxKZkc2djFYUmxQckN0UzhyZytHd3VnSzF6czNMY0htaUtTa1pl?=
 =?utf-8?B?MVAxaXpFdU1yUVRYUTAvUzNXMXlMUit6WjdLWlU2U1A5VzZrYVJuSDZEbDhu?=
 =?utf-8?B?eFVQd0J3RFhVNWJTSWt3M0g1b2tCYmRnRXdiVU96VU9GSUtlZTg0NXNhTEpL?=
 =?utf-8?B?ZGFOWkFzMWJQSjl3b1FHWUFmaEZVNlFHenhMa3RvNmZsSGtXZ2ZWamxsOUlJ?=
 =?utf-8?B?K0VTSURYNU1jWmdGNFA0dWlYM3NtUDB3TG1Yc2pKbWFwM2xvNHNtaWcvQnZB?=
 =?utf-8?B?c2NlTjJZRlhaRHN1NGl6YlZpb2s3b0VzNU10bEFJQjdqWnZYcW9UYTFUclhD?=
 =?utf-8?B?ekZCMHVXMkFVZ1ZLUllsWVRQb05Cd3VTUldRd1pob2lpdkZwcHBUNkQ5Znpx?=
 =?utf-8?B?WEhXU0txakFoS1lGSnhtenRlemlSYjV3cklVbSt0eURWNHB2ZHBtZlBOeHRQ?=
 =?utf-8?B?Z1BsczZKUXFqS1FGaUpLbWozNHQ2dkhHYy8zQVFvSTBvdmpvRlU3dy9sY0pa?=
 =?utf-8?B?OW1iSG8rTSt3T2FUWG9Kc3EzSmRvdHJ5TWh5S3NnWlRtUktETkNpR0pPdUx3?=
 =?utf-8?B?MEtONVU4NnpwRTQxZ2JZOWtRZ05KdzdtbVBrTEN4UFJ1dFVvMjV1c0xySmdo?=
 =?utf-8?B?ZzRVRTVlcDk5Q3dZTncyRWtCTzNiY2pHMUdGN0ZOblZMdnpnSnJTQmxiRDNo?=
 =?utf-8?B?cnQ3SXlrRDlRZ3RnZWExNyszYzRLMmxrNWloV2hTQVhhUjdIQW9TTWxvYWFs?=
 =?utf-8?B?MXBKUGVzRm9uOUM2a1VUTVRMNThQcU9NVi90eEk0WVUveGVBRGgyQUthY0hY?=
 =?utf-8?B?MU0wWlJ3M2t4YUlmb2xlNUJlK3JqUmhubGFlMXB6MTg5SlZQRFhleHRSeHhD?=
 =?utf-8?B?N1hRQkRBbVFMNUp4SEdUMGRqTmJ2ZnByODR4dVBIUE01eUlUWHBlWE1tUklF?=
 =?utf-8?B?K29ZN1grTlFQTWRWRFJhWGdQaWYzaWk5NnowNVEzVlpOcXlWSW45b0ZwMmtO?=
 =?utf-8?B?eVd6dGRxMGk5bXFPYkVDWVFhQUN1ZElsZHZ5MG5PSGZNWlhqOGM0d2F5T3B1?=
 =?utf-8?Q?LRfzrY?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1EveHp6dHFXamx3K01xK2lYNTZTeDI3VkhFb2xPdDBraGVuVXYwbVF2T2Zk?=
 =?utf-8?B?U1laOTZEMDBnaEwwZDJNYlVYWFlMNmFLNm40SWdJZVRrYlZyVHYwUUlGSVdG?=
 =?utf-8?B?ZThGZEJ0VWtUdEE1VG5pUEpnWVErMjhSYXFVR0hBYWNhaGVxdVVleFlFVEN0?=
 =?utf-8?B?QTl0dC9jVkxKRDBEWGRlYzJXVnpkYmRBOERhaEhCODJZY0FQanVKbjY5SGQ5?=
 =?utf-8?B?dysvNkNMaVd0UFd3ZmhOeURtalBNK1RxWFd6dlF2MDIxRjZXN1NCaTNISHVy?=
 =?utf-8?B?VWt3NzNLNEZWdzcvQzByZ2pMSytRYmlFZ3RjRVRKek9lTk1kK0IveTVDZkpZ?=
 =?utf-8?B?NWNzbC84czZyN2RlM2FxWVRmUnFPSE5rc0FudnRzWFhoTS8wZTNhbHl5Y3RW?=
 =?utf-8?B?UHlkZXc5QzY3dVlxOWl6TWhwWkgvSUNIbXpQUDNjajNNaVMxNk1MQ3FKTytj?=
 =?utf-8?B?QlJBMUdVVE1STUVEczY2ZXF3NDkzblNib1p0TDdRbUpJcHFjUC9IV1JDZWpR?=
 =?utf-8?B?YnlCSTIvRGdPRk9aWW9XWUcwTkdDN0RpVnJ6VVkvQlpqMkhpekxhL3dqS0dM?=
 =?utf-8?B?K3hrNzlyRTlLakFudURuUVNNMG03eUZrVGRFSklnbWJWVDZuZDI1Z0wvKzZ0?=
 =?utf-8?B?S2pyQWU5bXRFZmZ0emtyanlFRmhCanNHN081M245cnBaNmhSdzVzMzhvR3E1?=
 =?utf-8?B?R00wYWdEZXdiQndhUFdrajhQV3pObWpwLy9jM3B1b010MVBEVHovbU55Z1pm?=
 =?utf-8?B?WFNBZE96WC83d09TR2swcHZaM2xwRGM4cTVyam9iUHV0QWxrcGhIRDZkajJW?=
 =?utf-8?B?UFBPc09WUklxa0pydk44UnhwZkJjVEgyRUlNK21VVXA2a1paZERGV1NZcE5R?=
 =?utf-8?B?eUkwRnFNakl1c0pNY08vVEtnNDYvayt2OXJoZkVzdGVBNXVTM2syenp0ZGkv?=
 =?utf-8?B?OTdKL2Z2UmttanRpN0hzVklSV0c1U3dkSWg4WjNmVnlFNzJycFhGanBzT3pv?=
 =?utf-8?B?OXpXN2dPZHhYTXYzWFk0VFNvQmxiSDlkWEY3VU94aGRFcEV3YkY4VzNla2RV?=
 =?utf-8?B?YzA1L2FmRVdYaGdkZXY3cVFEd2FESXRYWkhvbVZ2eVBwbFhsYUtXcCtPU3Vo?=
 =?utf-8?B?K0Q0ZGJ1K3RPekx0YzlISDhzU00rU3BqQSs4MXJCMnhkMENHa3hPSmlOeWFh?=
 =?utf-8?B?ZHdhTGYyR3hMSDBLMVdTOVlWLy9rcVYyMHM1QnBoN2sxZW9BbzJPNkwzamV1?=
 =?utf-8?B?ZDc1SUNoMUcyOGVVSlptZTFvQUlobFRVZDVjNzV1RkVOc01IVHFEZkFvbXdW?=
 =?utf-8?B?amJXbXJSY2tKWDF1UFd5c2FPRXZPWTdBYzE4T0tZclR6cERwdE1Tb1lML0Y2?=
 =?utf-8?B?N254azlWQlh3VytTN2dBTFpJME1YNjFuRXdHZVRMdzlYZEF4Uk5jU3hEWU9E?=
 =?utf-8?B?Y0YwZkVNeFgyOXozWFVVOG5OMWRhMHV6L3JTby9XejRCQnkrRlRGNjFta0Yx?=
 =?utf-8?B?eTNkTWJNRm5SbGluRGE3eWg2V3pBM05XWkVsbXBtN1M2bmV0L0hoaDhIdDNx?=
 =?utf-8?B?Y1pjRmlkWVo5cWhDaW1XemlPeHh2ZnFhLzhTM21OME1oK0xqTTJFU25wdys3?=
 =?utf-8?B?djhyM0cwSkVIb3JDNWRYN0hiaFdWaVVKMlVsVTJ5OEE3OUQ5YWROSHNHNG1m?=
 =?utf-8?B?UWRRRzVOWmF1aXA0d1RkaktZVUMwQzNXUXNzUmxIOGxPYXdqS3k1Z0ZaVVJT?=
 =?utf-8?B?clJHYXJWeVg3Mm93akNkK25SOElDbnhVajBVTmhtbjEzVTQwOGRhckU4akRa?=
 =?utf-8?B?Q1JTSERaOHY3OXFxZXlkVDJUQ05DdDl2eC9EeHdmOFloaFFzU3hsY2RIeHc3?=
 =?utf-8?B?YlNrRVQ2a0o0V2hyQjk5TTRXd0JubmpNdC9PMmN0UGxxdCt2andMYlVFUk1M?=
 =?utf-8?B?NTZteWJlSUc4MThjVldUaEdZM0FEdWVjUzJCT0x3UVJPUzhLTjk0QkhlL1pT?=
 =?utf-8?B?Njh4UTQ1S2ZmSEJVYTYwUGZhUjF1VjJWOTFnZlZhRGFtNTV4RFBhT09rU3Zw?=
 =?utf-8?B?T1FSRGJpZStCNU85Q2FXN3VxRk1zZ0NmL09ZT0EyTlhOTmthVmpyT2VOR3Ar?=
 =?utf-8?Q?erQIDjljcSogOeBXiNsnf40JQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBB18429942DF541ADAA2092A97F11DA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4181d82b-63c4-4324-3808-08de2252f5d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 01:21:23.9948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6MPZUl/HCto3xgfTf+er8pKM1S3Hipo8i9lOD1fkUm+pQ0ekMDo6yU72SyVF1M5v4ItJVTUYdxJG7I5S3hLDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8670
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTEyIGF0IDA4OjA3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEcm9wIGFuIGFzdGVyaXNrIGZyb20gYSBmaWxlLWxldmVsIGNvcHlyaWdodCBjb21t
ZW50IHNvIHRoYXQgdGhlIGNvbW1lbnQNCj4gaXNuJ3QgaW50cmVwZXRlZCBhcyBhIGtlcm5lbC1k
b2MgY29tbWVudC4NCgleDQoJaW50ZXJwcmV0ZWQNCg0K
