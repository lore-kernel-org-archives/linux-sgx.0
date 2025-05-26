Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523BE1C84C4;
	Mon, 26 May 2025 11:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748260127; cv=fail; b=a5xwbJ5B4cNwxOexuBGage+XHWivswD/nTJmbqXfVbAerhIM5T34HTstQsoZ/H7mykJv1YRQ/rZSfE1+8BdcjF87tCZavHy2hJ8rrrEYFnoqdyFvNK1PBcgJAQv0qDaY528QhL4KV8dacw8PaThDqeOmfp7wpuEWt8tFASvI1Q0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748260127; c=relaxed/simple;
	bh=Hclb/69E0ZcTAnJExlzRM6n9bg9TaGmoTiq3F6tV7Zo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iJRizyMtI9HcA3OldAxTXGHgSWFzXWvCBJFDkrhGggngv2CU76DxkzxkJIjTsu+eZilk0Z7DAp/cIKeiFTJFNe6MiGBh/RjEnjcgd4oCRE3ByvItPuCtbUnGzJbexqsl/ocW6YN/sCYviQvXBbfZXlCV56+CXZIEjzljQ5fPPCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Knt2ZsLY; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Knt2ZsLY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748260125; x=1779796125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hclb/69E0ZcTAnJExlzRM6n9bg9TaGmoTiq3F6tV7Zo=;
  b=Knt2ZsLYgNuObFPqIXHjRdbSpfrReCcHQ6cQiogOXwKK/at5O8hEweC4
   G6rUlZsy7VHs9HwhGsQw/M/7Jj6jjpIFuWsgSy+npRclD3v1DSzUG9ruD
   f1QOFy9YbrAcSREiS+TWjSK4IZRR0saGLnYAw19yqiDDJDkv9luGWe1cY
   jK53/7erXBOurGdTFgoqt1uca9WcLjX+vpPrh9nXeIqYzPlV7QRiWoQgo
   dO7Rc+Y2gpHcOCI95vvvtN9W8x9tL9WGbVxj9eph9HudY51m77bBoarC9
   7e6jo49DMR9fv2cE/NgUcJha7JdQJ4wI5XotqXBw5TUm10Dvo+jBEyaMa
   g==;
X-CSE-ConnectionGUID: 3aQ1sFNxR3uOLD/gu1fyig==
X-CSE-MsgGUID: jHXNsEDJRWaZOEtRBSvIhg==
X-IronPort-AV: E=McAfee;i="6700,10204,11444"; a="50158413"
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="50158413"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 04:48:44 -0700
X-CSE-ConnectionGUID: Ppxffqh8TZu7QOrmGep5kA==
X-CSE-MsgGUID: /QiO5h21Tk63csYiFHsfOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="147354165"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 04:48:45 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 04:48:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 04:48:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 04:48:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d52J9ay62bZh7fLXYxuPxTzM5fKQA5P+HDodgKTuA8JtBuEOFTtOMUpil4dLcxnldmAqjuElUUMQrr1CtVRwPWNm8Ug1fA2gEPpKE3M6XSPzJ0snGWSLx+QV5uk6gNzROl0gzwz3bnnK5iYgz2dGqHyrDTwpkRHUkDUXjTklbaLZ5w0vEPO5D0QtMq61Wc1yr2ALTDZqxD2EZHaqhqXYrSg7DtYpX3JxpANzbgwLiUUAMRImV0b02RFIr6sttR+ouEjn8OtQFNmTXlpPcUDmOxE7FsmxT3pM3wkhSVAwJIDPrQS/9Iol0eA+gFbXMbNrQpVqlrXky+k3iLx1fy7ftw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hclb/69E0ZcTAnJExlzRM6n9bg9TaGmoTiq3F6tV7Zo=;
 b=B54s24fU8AeJ3/e2fTqvjklJWIPnMZ7dBMljbNTkVueeJHBPDjJjvsn0i3ycLNbPOk6cqBxeGRr35eAi/lzUOeBlX3GU+HFMcJ3uk0b5+OwqORSOpoxmsmgsZp2vZ15pk+g41Tw3b6T4GpXinoWPnxmUunw3dg8cBfpyLcD83DazUyhTEky0Sa1s0nlD+NZVElDGBJxRLPJIBy/Rbdf4OHfAEhcrQOmc4RuKz/iji4EJTWocnFFI1K9zR448RCg9sydO/98YswAzjoyEk3E6gz35cpntdtecZlSAEKQdMg8q1gos7lG9GWo/LulOha3WThWuZeTzYvvUTs2CKrCORw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CY8PR11MB7012.namprd11.prod.outlook.com (2603:10b6:930:54::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.24; Mon, 26 May 2025 11:48:41 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%5]) with mapi id 15.20.8769.025; Mon, 26 May 2025
 11:48:41 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "mingo@kernel.org" <mingo@kernel.org>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyvsquqNiUCfiSU2V76ezJnd3LrPgX96AgAABVgCAAIJkgIAD7bLA
Date: Mon, 26 May 2025 11:48:41 +0000
Message-ID: <DM8PR11MB5750CE4BF50652829EC0639AE765A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
 <20250522092237.7895-2-elena.reshetova@intel.com>
 <aDCaH2WAMhLhFAVE@kernel.org>
 <d7ae8e13-2b44-4466-b345-fb06b40a24d3@intel.com>
 <aDEIn4Ra6HMEVy9R@kernel.org>
In-Reply-To: <aDEIn4Ra6HMEVy9R@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CY8PR11MB7012:EE_
x-ms-office365-filtering-correlation-id: 13d52e94-306f-4362-4a71-08dd9c4b42ab
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U2M3cGZUdGl5THVrclBLK0tVTDE1dU9IRG83YmY2c0RRS0IxZkFnRm9jTUhC?=
 =?utf-8?B?bkdzb0d4ZkR5cE0vaFNqWXpJaTF2RVplK29xbS9BL3drQ3FrNXAxQW9vOTc5?=
 =?utf-8?B?VXF2SW4ySEM0Y2RFU2RheEFnRm1vVGd0QUlFMnhpSE4yd1BvZStKaG1NNXFr?=
 =?utf-8?B?enJraDBVaFpoaTRvSGo4NWUwTnZhTVB1ekVyZjJqVjBKc2x0cCtqNTVFMVVL?=
 =?utf-8?B?cnhSMFc3ZTZ2a0F2cG9xdlphMG5TcExpbW5sQlpGbncvYURHSVB0QWpYWVZO?=
 =?utf-8?B?K1lwK1VvZVJTeWdwMThyeWl6a2s0VGh3MmtRQ1oxMktqUWVHbE5maHZ4ZU8x?=
 =?utf-8?B?cXd5TmpyZnJDbnB4eW80Y1dEUnkxNGRjNU9ldDZLeVhKRm43V29uYlk5WkNn?=
 =?utf-8?B?aXcxZnlyS2s3enEwZXprUWFXcDRCbmRLSzk0bnE2MFNmeGI0cG9kejZ2ZTdN?=
 =?utf-8?B?Y0EzL3I2NVFyMUQzb0R0ejFET2RleVNCakFjSGdvd0IrOHNuZWNLbFV5aG1l?=
 =?utf-8?B?bTVUY1MrTlZibzhNZy9RbzEzaS91L08xRndCczlQNVdWTU9CSC9jUXgwQWg5?=
 =?utf-8?B?Wk1FMzlNTW1kUUtNR3dmbXdJaXZ1Y3FkZmJubGkrdG5oZ2hSdVdlWG55dTBI?=
 =?utf-8?B?L2RJeVpJbkp3cXo0ZXJYTS9saStaQXErVitjMUZYbVhTWXh1TW5ZZVpQOTlG?=
 =?utf-8?B?SjUxeVJlQmh1Q1VEZnZ0SWh0WVczbHJ4UDI3N2xDWGZZcnBhMEZNV2t6eElm?=
 =?utf-8?B?eG5PZ05hN0l6MWd0Z0E2OTVkL3BCcGt2dUs2clcvYUw3azJoWEFGME9PdVpw?=
 =?utf-8?B?M1RVYlp6UE1WdHhVVS9IYVFTYklUZEE1bGYyTlJjUFZlRU1sWHloK3d6bHVL?=
 =?utf-8?B?ZVdUNGlaaWpQSjBsV3ZMK1lFNnhDSEEyOG9VMTlzYi9Rb2R5V01nZ1d3ZWkz?=
 =?utf-8?B?M0FBd2dETElsbS9sazYvRlVJZHF5RThJNVNONEJpb0JxeW9jZHlETVhFODQr?=
 =?utf-8?B?ZzBoTkQvaU5YYkFwZWpNVGp6T3FjeGlnNytVc2ZFVmljMUI2Wk5TYnZuY3Jn?=
 =?utf-8?B?aUIrMThKQkFPbkcyTmc1ODNrcTVjNVBYNWZPMmI4NDlUM0VVbTR2SWZhdThG?=
 =?utf-8?B?dDJuMW5ucmtlVjVncTU1NjlUY3ZyUStVZnJoRENFNlA0NlRlMGFKTURRTVNQ?=
 =?utf-8?B?TktROG5jbGJNYXJjbTJTYTVFYWFERmlFZEN5aWx3dVJqZUFXeHJLUlhKcTRV?=
 =?utf-8?B?WEd6RUpEMFlvVkJRTzJvM1IrbXNKTkRlNENPdGhBUHdzL24zcnNJUFBUaE1Z?=
 =?utf-8?B?Y0lPdGs4aU5VRzVCaHY5Ry9rSFJqSjBNaVlsNWZZaE5rNjVEajg3Z2dUTDNE?=
 =?utf-8?B?VWY2Q3oyQWhjQ1VyWHFGWXJiTHVtdzd6MHhLN1FOSTg0aURYS0VXSEVwNkRj?=
 =?utf-8?B?QVQ0enJVWm9LV0VoMjk4N2tPMW5OREFnbFV3UlRmZ0NZVE5CRy9ncmZVMW5O?=
 =?utf-8?B?aUVlSndpaFhSTGxBS2d5Q09MQkhGMUowQ3NvRXlNRFRYbmc2QTNWbVZNdDds?=
 =?utf-8?B?VEU1VDMxNUg5Q2NWUzlxK0hEbHN0UzJaeU5aSm14TldKd3htTVFGTUE3VkVB?=
 =?utf-8?B?bHhZeGhaNWdVK3ZwajNKS1ErVzMxWitrbjQ1eEZBSmpLRStRZXJiQlFSN1g5?=
 =?utf-8?B?bzlHb1RwRVVObUJtRFdDKzJUMGtzWW9WWWpWK1ZtQ1l4SEh2ZUx3eitYbkN2?=
 =?utf-8?B?VkZPb0U1Ly92UEVEWjZwRjB3NnhTTzZwZzZGVzJFK3pGNWNJVVQ4ZzFlZGIy?=
 =?utf-8?B?dm9XcXhXVFBqV0NvMjFSdVF6enMvdlp6RHZxd2RtcHEvemdXeE5mYnlSZnVL?=
 =?utf-8?B?Sm1ZZElEbThPdzFOUmZmV21uY1RFZERVY3FYTXdKUm1TdWVYUzdlVElmelp6?=
 =?utf-8?B?Y1lBWE5xRHFxWU9WTHU4aWE4M1N3NjFuVVVXVTJSYmpxb21EaEZENExoanA2?=
 =?utf-8?Q?SmdkWkmoTbA19aA3fOAwyFYvTePDz4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEtWL3UyeVVzN3RVRjd4NGJnNjJDRU5zUkswdWR6U0VMRHRMWHBub0h0dmxk?=
 =?utf-8?B?U051Ry82S0ZUK0RNdkpBL1BjSjdmUXhxZ0tFeTJrQUE1TnZ5eGhGaFRFWEZh?=
 =?utf-8?B?d2RKdDlaVEhwbGJ6THc4b1N2d2R4a2NBSkNXTEtOZURKUEt5b2NBTS8rSC80?=
 =?utf-8?B?WFNBR2V3bDRzQU93dnFETEtxelAyelhlUG02VXlrVm1sYTNCRHRPRkpwc3FN?=
 =?utf-8?B?UUpZY3pLNjI1VjJ4TVdsTDhlK2ljUTNnM3BSTjFJS3ByZVFpNmVvbDA0d3FF?=
 =?utf-8?B?SHg4b3RXbHgzN3FLVi9HOVNibDFTT2hlUkpPa3QzQXFqWTgzMG1Ccys0dmgy?=
 =?utf-8?B?d3V3S2ZDN0taSTBOQzJ4V3FLSUNLS2p5U1VVT3hmaENNN1cxRndEVHgrOStu?=
 =?utf-8?B?SVM4eDZSWWp0WkkzQ3RmcnRxaXU0dHNFMndibEFLSVVqNnBzZVJGb2p3ZVpY?=
 =?utf-8?B?aVF1NnBidGhFd3BaRWxuYVh3c2ozZ2Q0YjUwU0h4TFVpTGVDVzFyOGdEM29C?=
 =?utf-8?B?RlpTOUs4VkRjTEd5cFhsVWp3V1VidTYyYkxjWHRwdURPb3k0VmhWQ250eDZP?=
 =?utf-8?B?SkVxZTFyWHM3SXduYUNMV2I3UW9iYk1DSTJrcitlbThvZlVualB0ZFNXM1A4?=
 =?utf-8?B?MTIrQnVzMG9ncHhVVnlCOTVVL0t0TnowdkFMSDNpWWxkZStCMXVlcjV1aW5o?=
 =?utf-8?B?bjhNTjY3cmdPUjVoQ1JQbE03eGRmMHFYbFpHUmlkYmJEZDhkK3h0b3ZUYnJS?=
 =?utf-8?B?dWZUYVZSUzBHR1pHUkZzRlhCL3BVU29DaUhSaGxReHVQQ3pHYlRpRkp0eTYv?=
 =?utf-8?B?bk1maWJiRDJYRSsycTRuMjZRS3VON2U3aXVZOVd4ajUycVlyMHlWdG9FejN3?=
 =?utf-8?B?MDVhajZyOFRtaUFvOTdralhtclJJVUQ5SzhnY2xTTkUreHJwa0RPYWNxQU85?=
 =?utf-8?B?Z2hkQW9tZEJSU2ZLMXZEUzFuQkRpcXFJejV0R0h3WWhvZWlZWGF3cHYyYTY4?=
 =?utf-8?B?M1M1U2ptdFRadk15ZUwrbnM2MStlZnM5Z3FqaFVQVS92MllFVzZkUS84YkV2?=
 =?utf-8?B?SHhETmdsRzdpT2xrN0tvM1piaGx5T2M0ZkVLR2RkNUpzQ2gva2p5eXQ1Ukhj?=
 =?utf-8?B?UVNrV0pnSXdkWlFuZVVSR3pKMnBmWmhNbXI2NzB3S2UvZ0lzYkV6d2djYlVD?=
 =?utf-8?B?M21VL0loVGhPWGN4SzNGU1hST2M4UnNGREU2eXc3cFo3eWw5RWxjbWpuanVN?=
 =?utf-8?B?NFgyczd1Tmg5Y3lZVGxEME5ReWZyL0lBQ0lxOXh6YStud1hiTlZMVkxsVkY2?=
 =?utf-8?B?NFF0R2FFQUt3RzdzdVowRk5iOVJlcjlkSFBSSVpCVWx0R1pkRGZXbWNBcWt3?=
 =?utf-8?B?Zm1MK2lveG5WaVcxL3BqZWlxWXA3c0lucUJqQWZ5YWZtRG1XOTBuUXhITE04?=
 =?utf-8?B?QnJOaWorandwUEZSK0laUFUrNldIOEZsV2V1Z3FXQWNjRVo3eEpxRDRoNnNM?=
 =?utf-8?B?eWtoQnBteEFuVk8wUkc3Z3ptWEV2NGk1dktxM2ErU0VkUTZwYWxsSlhETzV0?=
 =?utf-8?B?WWYrdW5DdjVzOFdzZkIrSW1rL3lid0d4a1BOUlFBWGYzVUQwRjBma2NXUStF?=
 =?utf-8?B?TTNYY0Exa0JBQlZVZ29FTGxvbFVIQkRzQmFHSnFwOXRlZkdKamlpOWlIZFB3?=
 =?utf-8?B?VUl1U3QxOFBNYUpiSU1WM0dRSnpzRmE0RUh1anpvTFlIcU0wOWx1VjhPR21x?=
 =?utf-8?B?bkYrRkZ2eWJpOUVQRFpoN00wa2QvcHY5ckRDOHJGenErTmxCR2tjcTJVZFQy?=
 =?utf-8?B?Q1FILzAvNUJiTnQvamZnV3JNZFNQb1RiaHRrUkZvUGF1N3M2UmJTNUN6Uk41?=
 =?utf-8?B?MzBqNks0Q1JJdEgzcmxnTDBWRE81Y0liREJJeEsyTFZqbU0yYU1QNVBKRGpx?=
 =?utf-8?B?OFRuVlVuSm9sNk8rQ1l6RitPa21PcjViRHhmblJnb2liREFqQUtxWHRSRm9I?=
 =?utf-8?B?dTU5djdCejgwdUp5TjkrUUpQdzNzcTVLVHRERGxIOVZSZ3JwOU81RzdoeTJt?=
 =?utf-8?B?NE9aUzlCOU9lNXRFT2EwNXZHSU42WWNZVmkwZ3pZdUp4eFlJZWlvdW9GaG90?=
 =?utf-8?B?VmpzVTFvZllRZ1c1OS9IQVhjbmsvWWt3SjkyalVDb2NNUTNIMzlkNG5CSGNn?=
 =?utf-8?B?ZlE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d52e94-306f-4362-4a71-08dd9c4b42ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2025 11:48:41.1015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6O6ckqONCw4qzIRNJs7voaEFVvdtGnsQ0K8lpdKCYZJGcX6JeHu89Vj0bITd2VtMtuRQMP11djIKiBV0HQshi1ptikfCob3U3IekTknOPas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7012
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFya2tvIFNha2tpbmVu
IDxqYXJra29Aa2VybmVsLm9yZz4NCj4gU2VudDogU2F0dXJkYXksIE1heSAyNCwgMjAyNSAyOjQ2
IEFNDQo+IFRvOiBIYW5zZW4sIERhdmUgPGRhdmUuaGFuc2VuQGludGVsLmNvbT4NCj4gQ2M6IFJl
c2hldG92YSwgRWxlbmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+OyBzZWFuamNAZ29vZ2xl
LmNvbTsNCj4gSHVhbmcsIEthaSA8a2FpLmh1YW5nQGludGVsLmNvbT47IG1pbmdvQGtlcm5lbC5v
cmc7IGxpbnV4LQ0KPiBzZ3hAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnOyB4ODZAa2VybmVsLm9yZzsgTWFsbGljaywNCj4gQXNpdCBLIDxhc2l0LmsubWFsbGlj
a0BpbnRlbC5jb20+OyBTY2FybGF0YSwgVmluY2VudCBSDQo+IDx2aW5jZW50LnIuc2NhcmxhdGFA
aW50ZWwuY29tPjsgQ2FpLCBDaG9uZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBBa3RhcywNCj4gRXJk
ZW0gPGVyZGVtYWt0YXNAZ29vZ2xlLmNvbT47IEFubmFwdXJ2ZSwgVmlzaGFsDQo+IDx2YW5uYXB1
cnZlQGdvb2dsZS5jb20+OyBkaW9ubmFnbGF6ZUBnb29nbGUuY29tOw0KPiBib25kYXJuQGdvb2ds
ZS5jb207IFJheW5vciwgU2NvdHQgPHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggdjYgMS81XSB4ODYvc2d4OiBJbnRyb2R1Y2UgYSBjb3VudGVyIHRvIGNvdW50
IHRoZQ0KPiBzZ3hfKHZlcGNfKW9wZW4oKQ0KPiANCj4gT24gRnJpLCBNYXkgMjMsIDIwMjUgYXQg
MDg6NTg6NTRBTSAtMDcwMCwgRGF2ZSBIYW5zZW4gd3JvdGU6DQo+ID4gT24gNS8yMy8yNSAwODo1
NCwgSmFya2tvIFNha2tpbmVuIHdyb3RlOg0KPiA+ID4+ICt2b2lkIHNneF9kZWNfdXNhZ2VfY291
bnQodm9pZCkNCj4gPiA+PiArew0KPiA+ID4+ICsJYXRvbWljNjRfZGVjKCZzZ3hfdXNhZ2VfY291
bnQpOw0KPiA+ID4+ICt9DQo+ID4gPiBJIHRoaW5rIHRoZXNlIGJvdGggc2hvdWxkIGJlIHN0YXRp
YyBpbmxpbmVzIGluIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4LmguDQo+ID4gPiBHbG9iYWwgc3lt
Ym9scyBpcyBvdmVyIHRoZSB0b3AuIEV2ZW4gaWYgSSB0aGluayBkaXNhc3NlbWJseSAod2hlbiBk
b2luZw0KPiA+ID4gZGVidWdnaW5nLCBidWcgaHVudGluZyBvciBzaW1pbGFyIHRhc2tzKSwgaXQn
ZCBuaWNlciB0aGF0IHdheS4NCj4gPg0KPiA+IElmIHRoZXkncmUganVzdCB1c2VkIGluIGEgc2lu
Z2xlIGZpbGUsIG1ha2UgdGhlbSAnc3RhdGljJyBhbmQgbGV0IHRoZQ0KPiA+IGNvbXBpbGVyIGRl
Y2lkZSB3aGV0aGVyIHRvIGlubGluZSB0aGVtIG9yIG5vdC4NCg0KQnV0IHRoZXkgYXJlIG5vdCB1
c2VkIGluIHNpbmdsZSBmaWxlLiBUaGV5IGFyZSB1c2VkIGluIGRyaXZlci5jLCBlbmNsLmMgYW5k
IHZpcnQuYw0KU28ganVzdCB0byBjb3ZlcnQgdG8gc3RhdGljIGVub3VnaCBvcj8gDQoNCkJlc3Qg
IFJlZ2FyZHMsDQpFbGVuYS4NCg==
