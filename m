Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0412A275103;
	Mon, 19 May 2025 11:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654514; cv=fail; b=PWQGB/T9yhGEY8HxJupINo0Pawnxz4UJ0aOBXSiZSbbAxrBhMjE7Kj91Dc0+sMCVKADwIefiOL5oV5DPwvyzmryQZebx2y0eF9SV0u/GNu5fwMQA8kgIVvkB3KEsOyro3lNfBUQg9/MBSWeQfrMjHJluZDDgLGChRlagPW8PBUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654514; c=relaxed/simple;
	bh=KOZdfNWTJeQq0ttovOoP2J4/L2I2cwoNUzr5ExUxbkU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R+wURbl3oRJck35FlfkTqInlrTfX1uCAYCc09A+X+WJblYT3MYAsl+yq2U9u0PqrMo+xGkqzUNGmYoztV7EiTWihUBJ7WM4NIyTC4fSG5WrF1/fMNJF21V+LwlreuMsOdo+gmZlPHBq7RXKFgFDRXXHTAUmLN4KkQ0kI+848bbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1qqqFc+; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1qqqFc+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747654513; x=1779190513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KOZdfNWTJeQq0ttovOoP2J4/L2I2cwoNUzr5ExUxbkU=;
  b=h1qqqFc+4XXqaIPV6Te6WMSkjuWx0LNwSZVrZ12mpTWg69Umx7KIYusN
   XA8qaBlYweZ+f0arfzislsNjaGtnjigfl3Q02TZZZLGQjn4B6KxWFPrn1
   xqtKu0fZULWVl2jUU3k58RtRdGvtS5eUYzk2hgQBieI3NxVq9fSvJgV0/
   n9mmV5k8u29Rvp6L3f3Js37ko4ZQRBwj5ZRwlzu8qlDunKexwJ0xflXDh
   tFOkPnmfkVK43VHtEtzcqiPblr1yuEskaYYQCHfdlbe0XTqD0kKTRt+QI
   WrB76N4dvwGtdrOfk30WPLuFTb0RtJMiQAQRHCJosSLGcyVJrZN1/G8s9
   g==;
X-CSE-ConnectionGUID: IgtRTNkHTpiyg8MDFUmjFQ==
X-CSE-MsgGUID: YO0iBq85TxGTBNKD3fM51A==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="60183974"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="60183974"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:35:12 -0700
X-CSE-ConnectionGUID: R90lQqeRTRidS+xHTfcGiQ==
X-CSE-MsgGUID: Kf7CdJt0QzOuW7GC3od1dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="170377402"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:35:12 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 04:35:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 04:35:11 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 04:35:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=noUdsHxthAnjxxicNsENU0j5TtS9GXcwpbSOLB4sSktoM2tKjwL4vAPR7fa2fSAjIRSo8q54B8X6g744axQqKv0Q4R4t+hLDSfHPE5ot7+IInNYYY76AsyNFIvjU4YSXp++0wVHirRyRRuRY/YbSuX6P8uT+raANkL3j5vcVoYlDFf40LgLdu8TKRycUj0nuACxKahzupYtl+Ro3xZ+qAuADgrE+XYP7cE1JXzqio0ySFTj6FmqsGRAyHhpNmyXxYa9lgnyCiYfHC8my5t0l9PaB8ExdDyeN0B4GSJxwOSnRQ7Wz7IyIJQwU7Vh030uLQGG0lGGHl10mr5EnODygag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOZdfNWTJeQq0ttovOoP2J4/L2I2cwoNUzr5ExUxbkU=;
 b=fAqLCvqeDYfNPILx6nQyF7MmCvz99/hb9y4xXtgeiSpwJ7JP8NRwz+kHUhWQSCdsLIcKwzm8l1fxxdjihWVPMME5L/k+p07KtE2R1zIp47g67KiDhyU9fZFpgXru4zfHQHMIV6VyWwiyU3eNUJLoDgqpoGle7uRjOwaVmD896g0+r+pSBNZy9WRlLtI5CKRaEeXu34NEFyffKDixVZhH5vPZuLxbO6ShWsLfsQppyKlLp6+8bRkjzzpzg3MfuPyCevw7V+1rITN4NkB/vgEJJGd4FTasiPl0/Yloc4izVsncQ3kKrUNWV9/pgm9mLtJBw3Yzg/qCQ98rT6n3f78LNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL1PR11MB5956.namprd11.prod.outlook.com (2603:10b6:208:387::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.29; Mon, 19 May
 2025 11:35:08 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%3]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 11:35:08 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "Raynor, Scott"
	<scott.raynor@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Mallick, Asit
 K" <asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Cai,
 Chong" <chongc@google.com>, "bondarn@google.com" <bondarn@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: Re: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyI9ksgqZIsreHUKEItLJ2DPjZrPZxbAAgAANUIA=
Date: Mon, 19 May 2025 11:35:08 +0000
Message-ID: <84b0b4eab4444f6ddb407aee602826020a6f7e6f.camel@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
		 <20250519072603.328429-2-elena.reshetova@intel.com>
	 <c955515c5469dae17faa13ebda28459d7c998bb9.camel@intel.com>
In-Reply-To: <c955515c5469dae17faa13ebda28459d7c998bb9.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL1PR11MB5956:EE_
x-ms-office365-filtering-correlation-id: ce95d3c2-53e0-46f0-76df-08dd96c9352d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OFNRZXFoT1FWSCthZ3g2UVNQWG55TnRSYm1IZS9tRnhsYmdKNXVnd1lxZFZu?=
 =?utf-8?B?bzViaUtEMnlOcGxXb2p4cEYxekY0VzFLU3BtdDdraGhuWkVDL1JLZ0k0U2NH?=
 =?utf-8?B?NXQyc2EzUWh2S3VXc3FKWWxIU01SNzR1c0ZHTThlY3JwcXpoM04rbmtRaUZO?=
 =?utf-8?B?UzcreDlNWTdmbUhWT1g5UDhVUVl0c1JKejFrN3N2NGVDTy9xTXlnRFRrMith?=
 =?utf-8?B?M0VFcEw2clgyT3BTbTZaTzUxa2dXdlBlUjNFdUtQWVhZTlNKclpYSW9qQmhn?=
 =?utf-8?B?eXdoaXprWTU4WktvVXNKTDVocUkyMThldGxtdUtWWW82MUUrVUVPQU4reG5N?=
 =?utf-8?B?TmgzNUlrU2xPSEh0RlhlZ1NEWnQ4L0xwTXNYV25oSlRXV1Z5K2ZlblNrUE1w?=
 =?utf-8?B?ZHNPdFd5Nzh6aVpoM2x4WWFXdXh0bk8wMzBGeDV3dVNOdTUzeDU1ZUhZYlRR?=
 =?utf-8?B?U21FbnNsaUJxbjlkN0orZzFRenErQkdIUlJESkN6YzZHTG5PVUNweENxbGNw?=
 =?utf-8?B?aWpRRFllS05Na29iY2xDZFdCY1dUTGJHSlJzRTVqc0ZFMkZoaG1YZEhXcStB?=
 =?utf-8?B?b2lWd0RxcEQ3THY5bTRiWldYUzdLdHdraURxN05NcWp4Z1dxV3Fia0FKbUUw?=
 =?utf-8?B?TDFLUGdQL2FZbG1iN21Od3U0dE9NcVRsKzJrTjZReW0zWVQ1MWM4RDVlL3BC?=
 =?utf-8?B?bDMwM3lGUU5Zd3B4b3NEL2dCWEh4U1M4cmFCeEtIRW9Ca2xTUndaZGM3U1Uz?=
 =?utf-8?B?QWhCSXdPR3Fyc2tZUWxmblBsaGx1c0FTTFBOUkhqQ09qcGMrS0RmYnJaSCtj?=
 =?utf-8?B?SFN2RlRCTldrcjdHRWhoTjdpV0lFd2JqMHdJdk1xM1VCRnJYbWo5TTJFUGRx?=
 =?utf-8?B?MzR2dTdEa0dBbjJaQXNpdm5ZSksrVUp0SkViZG1mZldmc1VLdG1rYlAyNkVP?=
 =?utf-8?B?RnJGUXJ4bXFDL25hR2xsa25FVDRBeURBVE1LZFlTSVc4dXU5NmRaYzhsTnJ3?=
 =?utf-8?B?aDRYTjdFZ2hobFRIQmltT0haOWJNSGZXaGxmcmk5WXp4TDRuRURteFQ5Q0NM?=
 =?utf-8?B?U0tBNEFxVUYvblR0SXlQa1dKL1VwaVg3T0xyZmlPbUtrWUlMS1AzdEp1bUFr?=
 =?utf-8?B?WUIvTWpXbmtDSVhsaFkzekM5L2NQUHVEejMydHlPRTVOL2FlS1NsNFNuNWZV?=
 =?utf-8?B?VDFaZzM3Z3IwTzd5YVV5WDM1dlE5KzdnQUE1WVcwbkpIT2p4cmhsTkEvS09i?=
 =?utf-8?B?VnNnVWlNZ0NEZ1lJMjZ0czRRTzc5c0M0QUdEaFFhYTc3aEVBMXJxczV5RWxO?=
 =?utf-8?B?ZFBRaFA3cmRTVlNFQ21sWGJQOWpEYVM3TnZJUmUyNHdxeEV4MDFFUDV1dW5x?=
 =?utf-8?B?MFE4eWJ0Q21GaDBOd1VtaDgrdzc4UDN1L2JRdzcvWEJ2Y1paUVhlWjdWMDRM?=
 =?utf-8?B?MG5zRDVSdWhOdFJ6ZTV5OHVWMC9ObWFWVC9aUzRQSHV3T0ZVand0bXNDdDNv?=
 =?utf-8?B?UnhWVHBINWt4UFNVaFdUZGRiTmlOL0RMbEs5d3BoVWduUmdjTHZ1US9DUWps?=
 =?utf-8?B?U3YrTnBabGZ0Z29PcG1lRnB2MWZoNEFEVFJtSTlYWHhFWjRsemRPWndXQmUz?=
 =?utf-8?B?aG9iMWpOMkJDSkxpNGl6dDUrZy9QZjdNL0JiSE5IeUljMW4xZHZuYnJsYkFS?=
 =?utf-8?B?MVQ4VmdXZGJ5YTF2V2h1SnRrNURKcHoySEdOcHplMlhiL1hYWU9ZYlM5NVFy?=
 =?utf-8?B?V3R5MWhJM25USGwxbG11MEZaTFA0b3RaY2xlaUpNZUl5dFRyZHhJU1J6SDV5?=
 =?utf-8?B?VlFBcTg1TFJmQTJ0NkhlTEdHSnlod3o2aVF2ZFBzQ2xSQ2s2QUxTWUNiMkkz?=
 =?utf-8?B?eFlDdTkyQnpXbm1qcHkwdmVWc1pZZXdXQnM3Wk1xdWZacmtuejhzUjNMY0RD?=
 =?utf-8?B?ZmVsV2ZvV2d5N01SVTZyTSsrQVBHQS9QY0N1OVdlcU1hVjZqQ1BOQVJ5Tm0w?=
 =?utf-8?B?TlorZEFzRmhBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWJUV3A1OG1tYko3Q2RDOUh1L3FLQnVlRGRnK0tlYWEzQnN6a2dBNXNOb1Jj?=
 =?utf-8?B?Y0M0anhlRlNpL0xFdnJqbysvYURaSzFIODZiM1BodEJxcytsbWhIU1RNNkxY?=
 =?utf-8?B?WEQ2NkVuYnlmSU92R2t2K2VjYy95R25ENFNycWdvUE5nYlo0RDdqYTVzMStY?=
 =?utf-8?B?Q0FIU01IQW0ySXFNZGR1MWUzTG9sblFsdmJhNllqRW5yOU5hTUhaZnFkamdo?=
 =?utf-8?B?eHV0TXprblZ5VnBTU2V1NWtZa1hyb3UydWxDZkdlMWdjcXVEdllWM2ZBWHRi?=
 =?utf-8?B?OEdra1kzS0RpenFFMW5nSURjZERZWWc3R1kwMnNTYUc0dTRsNEE0UC9oOTFo?=
 =?utf-8?B?Zy9mcFVzT0tzeGdWWTVNTi9KMUNGVmxHOXJFOXZpbWh5VDRyWVJ4OWNuREJZ?=
 =?utf-8?B?SzkyVWlnUDJXTWRMTlY0MkNtSFpNa1JxMURDN2lmSlhEMm8wUGhPZThrVzRN?=
 =?utf-8?B?cW9KVXdkWHkxSlVjUU9uRkVqeE9VeStXc2h2RDMrMGM5QkRoVm11UEUvY2M5?=
 =?utf-8?B?TzhVUTZwb2NGWWVYbTl6RUkyVGQxZyt0TEFIU2h2dE1CQjBZL3FzRHhTSHpY?=
 =?utf-8?B?ZU56WUhmaFY2c1ZFU0ZISDBabTl3ajVyYTJKcDFJM2RJcnozRXJhMEk5SnBp?=
 =?utf-8?B?MUo4NmpTRncvREExZWVlS2pLWkFTYzdlZGZpak5uV3JhN3VjVWhxVWhMQnI2?=
 =?utf-8?B?RSs1bUhsT2p6dDQ1UXljdmdoRHFXQ3B3WUtYcTIyUmhmcFl5M3U5aytoQ3JI?=
 =?utf-8?B?THBLU0RFaDNDSDBDRnRvNVI5ei9aVk4zWW5CK2c5Z0FKbVlpUUJGZDU1OW5I?=
 =?utf-8?B?VCswdTBackNhYzRLSFlSclgyNWFSekJPUGdGZkwvanY2WnlwSTBHMFhvYlg5?=
 =?utf-8?B?S0xUbTE0RlVVcWYwMHpLeW1IeVZaakNZOHJFZU93amV0MzlYUFJiT29jOFBa?=
 =?utf-8?B?TDlnYkxYMFRMRXF4cGhqMjc2ZVhWS2J4dHViZnNnZFRqM2RoL21zZ0gzQjBo?=
 =?utf-8?B?MDFJMEdyWU9jcXFzQUJzUWtFRTBJK0ZvUllhMzg5b3ZmaWJwcXVRa1FrVWNl?=
 =?utf-8?B?OFlmVWJGSEw3QjhQUU9HT28ra0NpZldCWFJEcWdsckxYTTIyd0MvTTU2REhU?=
 =?utf-8?B?cC9hTDd6ZGZCTmduckxhd01Lb0Erd09qdVh4QmY4enk4UGNXWjNmWldEUENY?=
 =?utf-8?B?dHc3RE5zL001aHRad3VJcVFrYnpHQTZQaGw3MVNtbndsa3lEdkdiRFJ0d1dH?=
 =?utf-8?B?S0tBTkp2Nm44YW1DVjh6TnNzZERJTDZKOEplMVMxRUcrd2J0MkFvZTh4YVgz?=
 =?utf-8?B?RE1xZEVHOUE4bnhubUJseUVhNWMzb0x3SWlWQW9YQkJ2RDJ2aFg4RnJzSks1?=
 =?utf-8?B?eVpDKzBQNkVqNWwra25BREsycHVCS3h0aWNHYWlUcU5sMnV5ZGVDclBYcDlw?=
 =?utf-8?B?Vk9tSnZlTmVPMFRlT0ROdDI3S3MxUU13V3ZhbVY1TnBoMUdIVGkrbmFQS3FH?=
 =?utf-8?B?T2xGdjd0UEN2M0xURDhPc3dDcXhyQ2ZZY1YrNnBoNS96QWNxN0VrbjVyYWtV?=
 =?utf-8?B?ZVJXN3lYcnVnNmJiVUNwTjA5amd1bWt0VmF1VUhNMVBjSHFVNk1QdGNWcHl0?=
 =?utf-8?B?UlBnUTBkbkt4OHZGM1MyVmd5cFdtVGdQejJid0pqSDJKY2JsRk9FOU5TMjRS?=
 =?utf-8?B?eVM1VDlKdHFiakFtdW1ncEZDZ1ZiRFBrMWt5bEtETm9OK2FuSWpUa3MzMDF5?=
 =?utf-8?B?MzhRelEwaXdJQlN3T1VNVGpHU3dKamhGUHVlakVRZitmYytvWUtGa1p0RGk0?=
 =?utf-8?B?d2VKWUd5NndSMWgrUlhHOEtrS3gxWFVRK3IyeDB4MXpHbkIwY1R5aVhpbjY5?=
 =?utf-8?B?TzRUR25uV0hmWWR6RVZHdXkyU0kxN0NsQ0cyZnJRTmM0MHFqY2RrZC8za1M4?=
 =?utf-8?B?RWJHMW8vQUxkaGNpN1dXOHhHaFBFd3hYRVZ3WU5JU1VYMCszeThzcFNPengx?=
 =?utf-8?B?cDZ1UkdxbjRudm5tK0dDOGI2TklUVmkxZmdHNUg2UDlaLzByNnFGdDZ6SHV2?=
 =?utf-8?B?SVJLWXBRRnRCQ0EzaGVpTVk0VDhrNTBCcTJpUU0zOXovcXI0OGJsckRmZEFV?=
 =?utf-8?Q?UrgOlRHpkcCSY3xeS3sXX1Abu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D9571742D569D498E89FC87673D1E25@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce95d3c2-53e0-46f0-76df-08dd96c9352d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 11:35:08.0605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zd1uU5cyFcT2ZDRPlQbWYRBWmKtTd8DgScvFrfCEmrQlH5NZFFxNtQFLIBY0HvhTQ6z/B+cO8NPBLl9F1+QkqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5956
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDEwOjQ3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ICsvKiBDb3VudGVyIHRvIGNvdW50IHRoZSBhY3RpdmUgU0dYIHVzZXJzICovDQo+ID4gK3N0YXRp
YyBhdG9taWM2NF90IHNneF91c2FnZV9jb3VudDsNCj4gPiArDQo+ID4gK2ludCBzZ3hfaW5jX3Vz
YWdlX2NvdW50KHZvaWQpDQo+ID4gK3sNCj4gPiArCWF0b21pYzY0X2luYygmc2d4X3VzYWdlX2Nv
dW50KTsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+IA0KPiBXaGF0J3MgdGhlIHB1cnBvc2Ug
b2YgdGhlIHJldHVybmluZyBpbnQ/wqAgU2VlbXMgbm8gY2FsbGVyIHVzZXMgdGhlIHJldHVybiB2
YWx1ZS4NCg0KSSBzYXcgeW91ciBsYXN0IHBhdGNoIHVzZXMgdGhlIHJldHVybmluZyB2YWx1ZS4g
IFBlcmhhcHMgYWRkIGEgc2VudGVuY2UgdG8NCm1lbnRpb24gaW4gdGhlIGNoYW5nZWxvZywgb3Ro
ZXJ3aXNlIGl0J3Mga2luZGEgb3V0IG9mIGJsdWUuDQo=
