Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6BF2C15BA;
	Fri, 15 Aug 2025 06:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755241171; cv=fail; b=SmxnwoTH4DT8IYmWJSIdB5m1Qe02y2D0kVHMT92tW748EuAA7WHjfHacrBeeo7u4fSiOO5IZ0GBt2loSt57+wGkN+UPBru4FUe9ldFCZabcgX1SlKdZFgGTF84bzjCsXKT5JdWkbI+DM1dl5NZf8+TldRLJPIqy+9uO1AA4IJPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755241171; c=relaxed/simple;
	bh=MCeIASs9jyiWW6q6YeQU+TemylnSqGto+ywF1kng5Ds=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WfAlV2rdufbvLB8loHcXWmJyQJ7mGnvXo/OzxqU39ocfoLvxG1iZXz/dDDXezFWlF8TIuhshBABxr1KFjQv5Dr2shzGfAiTHqH+bVAM3GHU75+ynMvNTUwkXduv0ziF5JExz5GhWei4/NWYrSPtVjeGhB/9KbgbaaaKXhUZcPbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IynnDV3Q; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IynnDV3Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755241169; x=1786777169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MCeIASs9jyiWW6q6YeQU+TemylnSqGto+ywF1kng5Ds=;
  b=IynnDV3QOi7peR6f+wnZbW+PkUTtVEyloGLkFicUIPw/+c6nY2lOpFW3
   LMxkc70pheM6FDbMldJ3HMCXrQ054ts8cyNYNdCpiB7OE8TRXJFPXWU01
   F1NtpH5JYJ5rWy7d51x3bOrKhWcLJGiaMPOkx/IGKVGzCA73V8eABeVzD
   keZnWDUZBlWAVYMenc/f86uoZSeQ1yN4RKpiBXRp+OtdlKV5uVXAxon8w
   1K+48Z41He5u+quaUpHnUpAO7l/nyCm+s93J/fnxyTDe97yXKBZ8Ks1oJ
   bDa4L09YJ0hMOBOCaIL9KT4lS5pJWL/jsCCIux5thAsMDKbqBEsx+DqO6
   Q==;
X-CSE-ConnectionGUID: dxTsrDhTT++zvupdCeHkGw==
X-CSE-MsgGUID: it7wkxarT9ebph5sYb02Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57520214"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57520214"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 23:59:28 -0700
X-CSE-ConnectionGUID: SdRK6BKiTxi5r+kW/5szug==
X-CSE-MsgGUID: wDAJzBzOSP6+s5g+ivkTfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="171152444"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 23:59:28 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 23:59:27 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 23:59:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.40) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 23:59:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J/TtQZk2keDS+oPyp/yR9EXFDcKMfCNsouCg2xKExgoQDWcVurkcDQphj0u0QSBPXSq8p1GHKNZGZ6UydqlXaJoMc/tkGHDR25iExFeKOA3JCq9P89gVAgT0+0y7d7Sp9D1jiAvrMRx1Wv6+N7hv1+VF2kw5dSAJ0MgPyAmqi1goW8uvUbtcs43uIDGvN8SXMx/N1L18vmYwv+he9hEs8nyLNJtpGdA5v1BO4Mp27DIvnPJtwpflz74XjrScIRPP/zOjcY2EUSwoN6SJHMDqkGroWuFLyiTQC8bq0dKLRYedLyfbhc5n9MZD22/vr/CyD7GEK1TYZCnBmg1Zu5AeEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCeIASs9jyiWW6q6YeQU+TemylnSqGto+ywF1kng5Ds=;
 b=IUyn/c4PGvV7qIhy1kyy/kdap3cSQ/0jvswit8776mCNEv/Db4o6lKtTd4sbpipNRTSf1IaSO9qpZJoRKLbpOZjFSO0pCxe8KFWf9Zhe1MNBv/SFRNXw8tss4GYUpr9WV32xgFpVYu/2y8tSk+154owEG6Ck3W3dxKQl/f4sABEp00+GQMdU7RkebAG3oIKjl2GVV93T7eW7SB51UH4els9asR9E++LSM+HAcKZoK0Tjg0kBgO7ZkSW8zfJB2GEf80VIb/Brk2d8gvLJl+oDjbxKdKlvD2qyzHYo3GnqT7RVjeVH0PjO74H8PgLqL5X6rJafwtdW/dDnhGgtu+/bvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SA3PR11MB7979.namprd11.prod.outlook.com (2603:10b6:806:2f9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.17; Fri, 15 Aug 2025 06:59:23 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 06:59:23 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHcDO5T+cs1fW4tzkm5n6kKNVsmGrRiXVoAgABQ6YCAAJi68A==
Date: Fri, 15 Aug 2025 06:59:23 +0000
Message-ID: <DM8PR11MB5750EADDEFCA1160E6E75B0AE734A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
	 <20250814073640.1507050-6-elena.reshetova@intel.com>
	 <4baa3bd4-cbc3-49b3-b8e6-09a2079c8363@intel.com>
 <31d0ac3b0b25efde64d502755e7c5f4717fb7f38.camel@intel.com>
In-Reply-To: <31d0ac3b0b25efde64d502755e7c5f4717fb7f38.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SA3PR11MB7979:EE_
x-ms-office365-filtering-correlation-id: 635628f6-6954-4ddb-d7bb-08dddbc94421
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?R0hWWVMwSEFtMGZMcmc4NUROQVh0SERuSS9FV0RscG93VG1NbVhoWVV2Z0xY?=
 =?utf-8?B?ekxxYzQ5ZjZFZXN5cmhQWVIwOGJPYjhwOGFKK3F0czdJZnFXRXFNSmZldUdw?=
 =?utf-8?B?UFMyOWhVempVN3ZpSUFCQ0tWRlFnZ3ord3psbUJLdXMvTEE3WUVXd2lCdXZk?=
 =?utf-8?B?RnNORFN2YXQ1U0VKSkMvSnEwNUg4eHMyYW1EOHAxT3AxQmJHbWpqaVJhaUla?=
 =?utf-8?B?SGdSV2QwcUNUM0hDaVNUMjNPSE1kL3hDYllpYlpSWnIvSC9GNmZGTjRUOGJ5?=
 =?utf-8?B?MGpsWVV5b1VRajBaS3lYalVRTTBaTFhSc09hMnV4WnkwZitKN1JPeHdJVEpt?=
 =?utf-8?B?WWNNK3BRVlhUMExCbVMxWU1XS2NXa3RaZXhtOXFWN3VKeUhHZjhZYm41TzN2?=
 =?utf-8?B?TTkzNkJBdUlSOVJvL0NGWVk3WjJldmdUVGtvakI5dkIyZlBBLzE2RjI4b1g0?=
 =?utf-8?B?SkNROTdOQmZsMDYwbFlLNy9UdzlubmFrZjdCcDg3cGNMVWxQS0MwZEhZNkNL?=
 =?utf-8?B?Z041eFhuWWFKcWZta2JkYml3Tmd0aHp5NWcxQW9pMmZhalNvMkV2QXVneUZB?=
 =?utf-8?B?L2p2SFFIaFBsS1BYcUhhMmRYQzB3VFZETDFTVUQwQ3RRRUlRblUxQTJoMkxl?=
 =?utf-8?B?bXp6cldRaWFwZjNSbFo5b3BQQ2cxL1lndXBUZW5sUHR4S2JBMnVFcDdvaFVQ?=
 =?utf-8?B?dGxkZU5yYjN6OUhqWmlheGwyckdPK201clZUQ2hKTEFTU3FhUXRSL0NyTGl5?=
 =?utf-8?B?UlVuZmNnUlNWVmZ0ZkNNNkVkK1ppRVR5Y0pRRml2MW5ZUmVZWkF1SGpEYmFL?=
 =?utf-8?B?Q2ptUmJGeHFWbDl3Z0kxS2lHcTNRN2VEMS85ZGV1ZHN4ekhDK2l5eDZvUFRS?=
 =?utf-8?B?ZThVRytvcTkrK1AvZU5WUzRFeVl2dU1kOVhNZXZNMm50V3MzM2lzMENmTnRz?=
 =?utf-8?B?UjRZMlVFcEdKaGxOWFNMdWo4cUROTDBrM0R5bHVzeE1UWGdQT0Z6THhFbnN2?=
 =?utf-8?B?Wnh1SEthYWFqNS8yUUJuY3JyVS9oNmZ1OHQrWDJUOC9hVmloT1F0amJVQlBR?=
 =?utf-8?B?dFUwa1Z3UXhoUWRDbHB1ekN6UThmc0ZGWDRTam51aVJ1dWpnMzUxdW82K0VF?=
 =?utf-8?B?NU45b2k0OTREYWNtVWtkeDkwT28wbWovQkg2Skc1eEhQdCtrbWFUVjNNamVs?=
 =?utf-8?B?S3Y3cVhEZndpMVVaM2FOVWo3bEJaTW0zTEhVRm1nckFobWZUaTZJanpjQnNK?=
 =?utf-8?B?NDNIRGoxMnNTd0dZMy94UVV3S05RVFJpdUxNWWRObUxhVXVpTmtCd1JCQVQx?=
 =?utf-8?B?N083Qk9CdEpBSmdvalpYTDR3Slg5NW42MXJhcUJxSC9qNG9wOGtDcE9FZWM5?=
 =?utf-8?B?dDFSN25qVW4vV3RRWld5QTZOekVBRWRRd3ArRUsrOUVFWXdNWEw3S2hSazlS?=
 =?utf-8?B?TmRFeWd1TldXazJKNU0zSnpKZE1JT05lN1FYR25GSmk4NDZiQXFnR3Q4NG5p?=
 =?utf-8?B?NHFJdDZFMlovOU5XMVUwN2pDNU1vVUlNNy9IMTR5WUhrRUJQNVBjR3VUZWgr?=
 =?utf-8?B?Z3RUaTZLcGsyUDM1MVRaOXY1VHZsKzJjRW1hblpqZSsyRFFWcS8yU3ZENHI3?=
 =?utf-8?B?ejlKSHNZRjZLZEZsTVFKc291SzVGN0FsMHdETU5pRTMweDRmVmlJZGprZC9l?=
 =?utf-8?B?REdLL2s1OEluKytsMWRhTTgwOTFUQytWd2RKNFNCMnpKZUluTERCb3ZSU3dq?=
 =?utf-8?B?alBzSnhleHdSNlhFaTJKYkNzUXB0SWdPWDdpQlI2U2lxT1dYY0J1eHdsL1A3?=
 =?utf-8?B?Nkp2aHJvdmQ4ZGQ2cWdtdlpkVG5XYUUrUnFUc0hId3JzMmRjKzBONkZ3NE9o?=
 =?utf-8?B?aVB5NGdwUUNTVUtwTjd1Uld2RFBESkFNT1VKWEdjMUEyNk9pNHZrNlg0QkZw?=
 =?utf-8?B?RmxIWkxwTFFheTV1czVsclp3MnlvSndmWUM3OFBvQUNSK2pPWUxQbGFGbEZ4?=
 =?utf-8?Q?i83aUfQPRA0SOASx+EsJD0/c5jzKEo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0VPbEJFMFJQU0RHWU91TUxmV214aXMwREJ3UXM3Qm5KYVRhRTl6UXRVRjZP?=
 =?utf-8?B?ZVNLN3BnR05aK1FpbnNKSU9weWNlVkE1b1BpcWE2ckErcU5UdThZaUdSWU0y?=
 =?utf-8?B?N0ZRS0ZubE95cFJ1WGJ3b0RGc29UVzk3dytycWo1ZFRhdTJKT0JmTmd6eWpV?=
 =?utf-8?B?NjNYMlluUURpeG5PN1lUVHBwVHR0aWNYdE83NDU0OUVmWGEyWTdTdXZDenhU?=
 =?utf-8?B?MFg4dXdJWlMrVHVNWTZhMldUdzlqL0ZsakFWTGZ0dXJtdXZ4VWFhT3V5V2JQ?=
 =?utf-8?B?aENkL0pRekxaeno5Yi9vVG9NRWJzQzY0cUYxK0hNTXErY1V6UU1lV2xKM3Fj?=
 =?utf-8?B?a1ZJSmtHOUkxZS9HRkViQ1l0S3F2ZERVclBQQnk1MlpvMXNybUNmbUJERkZ3?=
 =?utf-8?B?b1NKU0FmL2lXbVFkaUp1ZUhvRElpUFBkVE9FKzRqOGRkeXJVY1FMY0wyT08r?=
 =?utf-8?B?dnViUDBCb3F5Q3IzZVFzNGhHWXc0WU54S2YyM0xJbmsvQVhmb2lReG1SK00v?=
 =?utf-8?B?MVBlVU9qQkkwLzBiNHgySis5aS82TWxRb0drcXhTcGZ4b1hJNDEzRlNkdExQ?=
 =?utf-8?B?Q0J1eEZZaFVueWhZWkFJUVB2VGxyQ2N0aXBQRy9lZ0VuRWdCaEJ3RkMrSHkz?=
 =?utf-8?B?RElnL1R0RWJkQ2tZaVJXZnpVLzlITVRvR2pNcUxCMS9MeUxRUGg1Ty91ejgv?=
 =?utf-8?B?amtwNFRycGlmNFRKZkc2VE9LOG8vbkhvNHBHV2tZdzJCdGl1RFNicjBBZFJY?=
 =?utf-8?B?VHArMnpiZTRTeGFhN3l3ckpHa1dCdS8zWEZoTk5ESkZsTVdjKy8yRkRMMGQr?=
 =?utf-8?B?aDF6TEZ2aWVkU1Vockd6UXg5K1dhNHVsa3Y4RTRsYnA1T0Y1RENmMTROVlpy?=
 =?utf-8?B?M0lKcmUxbVZpRFVPaFhmcEROam9vMWIxbUxtMDVmaUkxLzNCdlR3MVhKcGVa?=
 =?utf-8?B?c0I1NnI0OVM3UzJIV2Z5UnRpNE1UN1d1S0F0QkdEcDZxVEZRanA3Uzk0dmhy?=
 =?utf-8?B?Z1drRk9aNXBNaG85Uy9iZExjZ1h5d1dnQkJWRVdnYjdkWVZQazY3Um1nZ1Nq?=
 =?utf-8?B?WGdjeFJ0QnBtRjVlS0E3M2pzaklURWhrM1JwMlJRVHFoTzd3UW95V3c1dXp0?=
 =?utf-8?B?N3dRb0xyYmU5OERtS2dxaG1yclQ2MTNUNjZsZ1MySFFmZWtuTkl5RUc1b0xo?=
 =?utf-8?B?YnA3QzNlWFVBdmFTdXl3V09TNnBjc3RpTUZUVEx6YXpNUVdRdm4yRFdEeVRH?=
 =?utf-8?B?M0FXeS9uY3VBU0FsYnFHaEkrdnRxMjBvZktHTGdla3BMS1JTMjh6aTB0S3Q4?=
 =?utf-8?B?VUk0N01lOTNjVWdQSlhob0E4azRGUGdMM2FvTHdvL3RFM0dvZVZVektCS1ow?=
 =?utf-8?B?V3o3MndGdG1iWnNIOVN6RmFVYXRKdFIxNERzZG1KQXlzOUpKUHlkcXByNTcw?=
 =?utf-8?B?Q0QxT3VaU0tkK3A2dTBVRzhwQ2wzd2RtVzdWaytFZ1RJeHJPSHFDVk9OSlZC?=
 =?utf-8?B?a3ZYSi9RZlBpaVQ1OVJ0RVEwdEtKamtSN0UvT1lROXZmMUNIb25SRTFDWnlM?=
 =?utf-8?B?RFpFMHFKSFJDZWxxd01jZUZ5bzlsR2lFWE1YTDdkdGxXb0dpV0IrbklKK2NN?=
 =?utf-8?B?b0dFK3d1eGRuN3FMTkc5WHl2aUdkTWxuMkhPU2hnWGxueXJFcC9ESzB1RldN?=
 =?utf-8?B?cWlRZ01UT09Fa0R5S0lsMzBEcHVpTDhXYnlOanBRRE9qMThLdTdKZG5EZkF6?=
 =?utf-8?B?MlBOcjY3TUkxRDBOL0VtbXhqOHN1Mi9FS3FRVnJVVURrZ2djdSs1NVMxTTR4?=
 =?utf-8?B?cHdZTDA2Rnp0WEpNOWZHekdtU1pybm4wNWwvN1pLTEN5RDJHbnRKL3lHWTBS?=
 =?utf-8?B?NWRLd2hUKzlwdGVZemZaRU54Nk9IT2NucThtK3FQMWJHaE9DWXhnRHdqUFo5?=
 =?utf-8?B?RVlOM1dYLzFpaktiVU9ReTJSTjMyTW80TmR6ZUR1ZFRlR0xNazIwcCtkS3l5?=
 =?utf-8?B?eVZneFNZVWRyTWVsOEZSZmdhclNvaHo3WnprVEwxMjVCbDYvTDl0dlFPWk9x?=
 =?utf-8?B?Tlg5YUNNQ05zRThweGZISFdFbEw0M2hTbU0wY0E3SXY2eEN5Z1BXQWlFSHl4?=
 =?utf-8?B?RlprQXgwdEJMWTkwNHhmRVdGeGRhZXgrSGpHNWpPSlRuU2dhcXNFY2EwUUQw?=
 =?utf-8?B?b0E9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 635628f6-6954-4ddb-d7bb-08dddbc94421
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 06:59:23.4271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RIB6pRK/gGZkAPLV9CxslfTROM7rxXrccp4SOwaRR+aQTtdHrlgL5o7SzE+dusvrzjmS4Kv6rUhWMWWCNZZmBfkIZzeDhzufU9O1HMfXJIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7979
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSHVhbmcsIEthaSA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBBdWd1c3QgMTUsIDIwMjUgMTI6NDEg
QU0NCj4gVG86IFJlc2hldG92YSwgRWxlbmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+OyBI
YW5zZW4sIERhdmUNCj4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4NCj4gQ2M6IHNlYW5qY0Bnb29n
bGUuY29tOyBtaW5nb0BrZXJuZWwub3JnOyBTY2FybGF0YSwgVmluY2VudCBSDQo+IDx2aW5jZW50
LnIuc2NhcmxhdGFAaW50ZWwuY29tPjsgeDg2QGtlcm5lbC5vcmc7IGphcmtrb0BrZXJuZWwub3Jn
Ow0KPiBBbm5hcHVydmUsIFZpc2hhbCA8dmFubmFwdXJ2ZUBnb29nbGUuY29tPjsgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZzsNCj4gTWFsbGljaywgQXNpdCBLIDxhc2l0LmsubWFsbGlja0Bp
bnRlbC5jb20+OyBBa3RhcywgRXJkZW0NCj4gPGVyZGVtYWt0YXNAZ29vZ2xlLmNvbT47IENhaSwg
Q2hvbmcgPGNob25nY0Bnb29nbGUuY29tPjsgQm9uZGFyZXZza2EsDQo+IE5hdGFsaWlhIDxib25k
YXJuQGdvb2dsZS5jb20+OyBsaW51eC1zZ3hAdmdlci5rZXJuZWwub3JnOyBSYXlub3IsIFNjb3R0
DQo+IDxzY290dC5yYXlub3JAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxNCA1
LzVdIHg4Ni9zZ3g6IEVuYWJsZSBhdXRvbWF0aWMgU1ZOIHVwZGF0ZXMgZm9yIFNHWA0KPiBlbmNs
YXZlcw0KPiANCj4gT24gVGh1LCAyMDI1LTA4LTE0IGF0IDA5OjUwIC0wNzAwLCBEYXZlIEhhbnNl
biB3cm90ZToNCj4gPiBPbiA4LzE0LzI1IDAwOjM0LCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6DQo+
ID4gPiArLyogTXV0ZXggdG8gZW5zdXJlIG5vIGNvbmN1cnJlbnQgRVBDIGFjY2Vzc2VzIGR1cmlu
ZyBFVVBEQVRFU1ZOICovDQo+ID4gPiArc3RhdGljIERFRklORV9NVVRFWChzZ3hfc3ZuX2xvY2sp
Ow0KPiA+ID4gKw0KPiA+ID4gIGludCBzZ3hfaW5jX3VzYWdlX2NvdW50KHZvaWQpDQo+ID4gPiAg
ew0KPiA+ID4gKwlpbnQgcmV0Ow0KPiA+ID4gKw0KPiA+ID4gKwlndWFyZChtdXRleCkoJnNneF9z
dm5fbG9jayk7DQo+ID4gPiArDQo+ID4gPiArCWlmICghc2d4X3VzYWdlX2NvdW50KSB7DQo+ID4g
PiArCQlyZXQgPSBzZ3hfdXBkYXRlX3N2bigpOw0KPiA+ID4gKwkJaWYgKHJldCkNCj4gPiA+ICsJ
CQlyZXR1cm4gcmV0Ow0KPiA+ID4gKwl9DQo+ID4gPiArDQo+ID4gPiArCXNneF91c2FnZV9jb3Vu
dCsrOw0KPiA+ID4gKw0KPiA+ID4gIAlyZXR1cm4gMDsNCj4gPiA+ICB9DQo+ID4gPg0KPiA+ID4g
IHZvaWQgc2d4X2RlY191c2FnZV9jb3VudCh2b2lkKQ0KPiA+ID4gIHsNCj4gPiA+IC0JcmV0dXJu
Ow0KPiA+ID4gKwlzZ3hfdXNhZ2VfY291bnQtLTsNCj4gPiA+ICB9DQo+ID4NCj4gPiBIb3cgaXMg
YSBwbGFpbiBpbnQtLSBzYWZlPw0KPiA+DQo+ID4gV2hlcmUncyB0aGUgbG9ja2luZz8NCj4gDQo+
IFNvcnJ5IEkgbWlzc2VkIHRoaXMgZHVyaW5nIHJldmlldyB0b28uDQoNCk15IGxpbmUgb2YgdGhp
bmtpbmcgd2VudCB0aGF0IHdlIGRvbid0IGFjdHVhbGx5DQpjYXJlIG9yIGFjdCBvbiBkZWNyZW1l
bnQgKGl0IGlzIG5vdCBhIHRydWUgcmVmIGNvdW50ZXIpDQphbmQgdGhlcmVmb3JlLCByYWNlcyBo
ZXJlIGFyZSBvay4gV2hhdCBJIGZvcmdvdCBpcyB0aGF0DQp3ZSBsb29zZSBiYXNpYyBhdG9taWNp
dHkgYWxzbyB3aXRoIHBsYWluIGludCAoKA0KDQpJIHdvdWxkIHBlcnNvbmFsbHkgbGlrZSB0byBn
byBiYWNrIHRvIGF0b21pYyAodGhpcyBpcw0Kd2hhdCBpdCBpcyBleGFjdGx5IGZvciksIGJ1dCBJ
IGNhbiBhbHNvIGp1c3QgYWRkIGFub3RoZXINCm11dGV4IGhlcmUuIFByZWZlcmVuY2VzPyANCg0K
QmVzdCBSZWdhcmRzLA0KRWxlbmEuDQoNCg0K
