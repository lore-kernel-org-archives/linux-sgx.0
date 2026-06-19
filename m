Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7352A40D581;
	Fri, 19 Jun 2026 04:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781842120; cv=fail; b=E6DD7foL5fJnSUja0EGnXO5OnA527x8d/qXJizaVbNk/Kf/Dw7RpCGnj/fyffzrVdOdTq2CsHw6/WchA7bGnYmSgOfmpasmubVtYr7C6FgFBxqhvsZQZ2vrgx3wrKHZ92YuCRt/1WSxfUfERsCWdtLkuKS3DUj2GDbCn+y2Mq2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781842120; c=relaxed/simple;
	bh=rZLDs8OfFPgaaCRNHC5hBhAzB8K9KLkuMXfdN21Oxgw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aZIdSsnEkIPxrD0d89wcL07riokRbD5xkPHHArnEMZSRchz2qlvhmYo3C6/FC72858y7AbD1lkGp517fmYXz2MSd4i3DzqNulFnPJBJt2I/O16nOGz8k0uobjc5lPDg6iVkjai6tS6Sgg/5RpTpPgZPwEH4XDRIq5vQwF6pKKPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F7zLMgkF; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F7zLMgkF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781842119; x=1813378119;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rZLDs8OfFPgaaCRNHC5hBhAzB8K9KLkuMXfdN21Oxgw=;
  b=F7zLMgkFzZpg6bclmPPnkCweZqrfDZj81bxCtdUU09I3PCKboBXAzGvp
   lJT/aDdb8lXev/5kaBbq3SO2JbXjPMZ7owhcQBCLGLkkca0QF1/p11a3h
   8gYm+b6RZLid9Sqnm6FCIBCWwgeUb/BDmX+G4/KFjR+T/v5rXPc3KktuC
   m4cznycUbQ2/nUk1alzclZ41zkPHov1crUPlCE+qT9nEonEAZxU8/T9or
   pa8uL7vJ4f1Li1yt2hbrOejwsPW8TmwCgV1/78yLzzsX9zljlTvoM6KKp
   zfyaqLSZ828Vi9u4Q2PHscBae+Z+tq8Z/R+jLZ2VK03VmSqEhamz0xSP7
   Q==;
X-CSE-ConnectionGUID: GziWNzGsQXilECv+7IO7CA==
X-CSE-MsgGUID: RMKbyslYQXedyid5s/9ebg==
X-IronPort-AV: E=McAfee;i="6800,10657,11821"; a="82583236"
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="82583236"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 21:08:38 -0700
X-CSE-ConnectionGUID: fKvJMANwSNi4e6vXNLTiVg==
X-CSE-MsgGUID: /b5tBqBXRLOxQjlCkOdJGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="286664781"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 21:08:38 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 21:08:37 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 18 Jun 2026 21:08:37 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.62)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 21:08:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UcNVeFS8A6fQDdHyb33mSwjP7rFmjKbRlxhmcmwkxRLZNqrJpHGzCkiMV69eWjbXcX+/a50Z3gNAl/wlbkewsuanjWxM97HKaLT/V4dVWQ4sMelabUxaojLE36k464l4flpAX3ZDERCc0W7q4h5pHlzaUMiu6m7XC9+txMikxzgYS5ay2YQ7/OlPEbnTvb4XscUf9b4wAlVQGHRcY5BeSqmXnATocKl9hQ11w5eA8IXUzm2IPoqBpcmwbkMP06+7WkYaMMu25te2MKFs4H1haoIoOkWG6t69W8X0OmZyGCO30q844ukEs11L6bMwYlA1I17H6Xydj5/bwaNekgx/SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZLDs8OfFPgaaCRNHC5hBhAzB8K9KLkuMXfdN21Oxgw=;
 b=uoF6vg2Ah+lltWh0EoOxevMRShSLJGmQJe0EiwouxBD5CS11UcTNzkljG2ZrPwpgsNvxa+TKhEt41O6IeghhchgHdGNtQSP8JoyBLncH9vpR6z8TWEEwodkOVEKsA851gzOkXYbNHfJD0fBcnLsPLLWPxqZpEJcWBs8Qoh93Hq2MOATzAwtbgN9v2JA4QUBf9c+UhEktmcquind7JyMiCKUGPz6B7byD+J0ytHocy9VltOMODc3tHR9Spct7iL0WOTJBoPE/FuS/2Dfk+XnyhTvItLELPF8FTa7/nusyZ5OqmGtDC38DLq3xSaqhrwjL7wT4fMrd4X/8dU7hu+ZgcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 SA1PR11MB7013.namprd11.prod.outlook.com (2603:10b6:806:2be::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Fri, 19 Jun
 2026 04:08:32 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%3]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 04:08:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Miao, Jun" <jun.miao@intel.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Du, Fan"
	<fan.du@intel.com>, "challvy.tee@gmail.com" <challvy.tee@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Periodically yield in EPC sanitization to
 unblock rcu_tasks GP
Thread-Topic: [PATCH] x86/sgx: Periodically yield in EPC sanitization to
 unblock rcu_tasks GP
Thread-Index: AQHc/woFuh5l6gfif0qPlUa1s70YFbZFRH4A
Date: Fri, 19 Jun 2026 04:08:32 +0000
Message-ID: <1bf5ef6fd45bbc241bbfdd3d0a4102f78000e7c2.camel@intel.com>
References: <20260618100432.2280834-1-jun.miao@intel.com>
In-Reply-To: <20260618100432.2280834-1-jun.miao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|SA1PR11MB7013:EE_
x-ms-office365-filtering-correlation-id: 845c307f-e41c-48c3-b88c-08decdb86d65
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|5023799004|6133799003|56012099006|22082099003|18002099003|11063799006;
x-microsoft-antispam-message-info: 7uudSQuMhSVyRwyU+nGGQHilpdDbjcox9aZf32atY4TZm0hl2f/TJmsV3tsVbKF5t1s0V9HhkoNn8BjaicF2eCCXVdK+d04mgKyMmQUUbd3H1M44n6ri5cVkj2s2+MIP6BYbmNsjJSd2b7rYhsO0F7ax55CnDipHKsa4cxfWp9g5axXemmDpOBVVDMZOiV5RGGuowPojHvAkVXRH7dkIWXDNeTcQaonL3ZL4PakKf6q1yWI9W47ImZJ8Lo9i+KWv5tExrheEDl7tYpMAiauopt2GUYmdQ4OSv6wbRuMACGrAGPot2wdpQ+wO0VVY0+d208mJeabgdmV9wfjMYlo7TBVHWb9hxM5avIuFtFsRo/c2TKEeAKkXdxk4ioL5eoF6HlpnfZju3EzLEH22CysYCXoXoGjw3DH2Uw4j02Yb2t3bmu7DM9xAcce8OXzdYPIY9vkmmDowI9P9kxGzPzUa76t4cBrwqlXFlquNWzfDoAxC1BAKrZ1EkOhXsULrClFNKair5W3LkKsl6swvQBsU9fmJhX9VI08T7lNQkgUr2Vc6OvNISEMcWp+EoYXuW94ylRYd1bB7xkmlui7GeEBxid3Gi5piIFTD4CATv7/Z0G5bo/ww0DBBnAW22/FFt+y+6p6Kogqco0yJV8YAbaw55j30oSIw8s2mqKV5mgAOxJkc4zHXp3vLVGy0WST5G8KECVZ7arxxpdDRqhuLqql3qHruYMv1UUgSSHE/sbpJyq8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(5023799004)(6133799003)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWRaWnN0VmwxU1VndWhoY1FlZUVtNytnajRCNjZMNWxsK1pqZlR0MGVxYzRE?=
 =?utf-8?B?a25rYkt2b3p2YVcvYW9aNWswaEZGWnVEamZmYXgreDdYVEYrd0ZrbGE0TWRH?=
 =?utf-8?B?VEVGVG5rT29xNzJReHA1RG12MWp3WmRBZVJIWTJaL0R5Ny9iTk9YUFBKKzJs?=
 =?utf-8?B?RHQ5djRuSDJtTHZoeHNnKy9IVWQ1MkowVXcyazRKT1hERVR0bjk4UXlSb0dW?=
 =?utf-8?B?U3I4SDUrS0FyZ09jU21RYmdOODlac0lDcFVxNGNWSkhBRzU2TFk2dlRWYXg4?=
 =?utf-8?B?OUNHaVdCSUlZeUIxMXFmT2hNZzRIdWhocEQ1bzUxdWcySEpLcnRlM0FpY05K?=
 =?utf-8?B?YU1lUXZvNHJsbzdHVXdWY1llTXFjV0RabXUyVDNNcC9lRXd0bTFTYXVkVTRR?=
 =?utf-8?B?dGQrbTQwU3lSZGlNYnpwOUEySE1YS0RsUEdxTUlvNmFjRGtWeW00d01LUjRn?=
 =?utf-8?B?RkhNWXpjekgzRFFMNWcrWEhidElKbys1UW9NcmdOOXVraFNpY3lqaU44K0VY?=
 =?utf-8?B?K0s5cmJMOXNrZ05IUTJlWC9BV2Y0ZWh1Rjg5RVRUUmFtYllXSm9jL0k3bDB5?=
 =?utf-8?B?aEdUcDkybXNMOS90SHVJeEhDT0hFcGl5YmZtSm10UlptL254ZWhYV3k4Nk1L?=
 =?utf-8?B?ditlM29CSHg0WlVEcVpJVXU4NFI2SUdwY21PMG1Za21RTFV5bEZzZ21GQlpl?=
 =?utf-8?B?bU9DeEJqeFEwNUlOeCttKzRQK0htbzJFT05kdFZBQzFEZnNzRnZpc0ZHNXJD?=
 =?utf-8?B?UExDUGpRMHdHS1VLbEt4VHNXU0RITkYyU2RiVGt6R1VTQ3FBaCtOQklEQ21z?=
 =?utf-8?B?b1ovbklzMDV3eUIrc1FjTElJNThXbUtxcUczMnJoOW0rL0N4Rk1ldlByOG1Y?=
 =?utf-8?B?YkFBWXNMTU5oTW5SdXlLeXNxSFltcnRjNkQzeDk4SytBa0RWVk5IazZvWjVC?=
 =?utf-8?B?cjI5Yk1VU3JqaWowK2NwVnA5NFZFQ2krYWZKWlljTWxYSE9XWkZiTXZSVXpG?=
 =?utf-8?B?dVV5Ulg4SHkxTWhybDZPZk11bVdZSWlQUHQ2dUNWbFFFVEtYeldEYVN4bEJi?=
 =?utf-8?B?NDNKZ0huSWNtT0ZmdHUwcTRLSW1tSDZ6ODhjZXNVUDVHU1RybHEzUXZ2cXgw?=
 =?utf-8?B?Z0tnWkxrbVYwZWM0Y3N6cmIzZGZKYVhXR0x6b0t0a1hjMWk4SzQ4UVVUSEMy?=
 =?utf-8?B?aERJRk1xQTkrUkd5V2tHNHc3Qjl4WGd6N0l6Q2VBK29KR24vNHpaeFU5T2xq?=
 =?utf-8?B?Z3ZMZ0VybURpelJOSW1iVkZKSCtla3pzQzErNTNsVUZKR3NlVzg1N2NpRk0v?=
 =?utf-8?B?SitmaW1wZjMyQnhvMUdOODJSV2M2QnpDWkh0elVTSWUrNkU3dURQSHJQZlFZ?=
 =?utf-8?B?cjRIQ2dYUXBPTXhZeE44a1ZnbnJOOTBzcENDRExMWStlalNxOHdDWTZ2dllZ?=
 =?utf-8?B?SUpYYlZYR05BeDVweHM0U0p4UkRwbGc1VzlubWxlR0ZIeExwVTdwR0RCL3Ni?=
 =?utf-8?B?WHlIY1Nsb1UvYXI5eVl1VXZlV0l2VndEYVVGMjRmbUpONWpPMHlWWTdkUEw2?=
 =?utf-8?B?SGhCVEhYbHB2TC84dG1mMUdsMlZoa1RkWkp0SGxiNncwMUkyNkE3V1VOZDVi?=
 =?utf-8?B?SkpoZnFGMGFrV1RUalBSd2FnVloyLy8zQ3U0UFZSSGNhWXNBWmJhQVBYc205?=
 =?utf-8?B?T1VxMFl3ckt1d3ZQbkt1OWYxS1JkeWxKYjhhTnJsYjRpUUtJaVNWYnQrNENS?=
 =?utf-8?B?UnIzaGgyS0NJdWxEUmxEa2hDOHRna0lvemFPc0greHRNNXRtaWtLd3NyZWZr?=
 =?utf-8?B?NXJRV2ZRcVNHVlo0VDd2RUtHb1FvdUFIbXNTdjIwZUhDRkFTclllQkNIamp6?=
 =?utf-8?B?UTBaY1pmU3AzWTd1YW96T1ZDa0F0SDlkV0U0L3NPN2FkcVN5VGFKQThMSitx?=
 =?utf-8?B?R1p0ZjR1am9FR0Y3YklPMXRXLzYyb1V0UmZTd3BtL0lMTG5GRDJCNVpPRFFD?=
 =?utf-8?B?QkNDck9JeGNjRW01QU8xRHFyMWtKa1g5YjNMQ2JRdUtxSDVRZDhzN0poQlBo?=
 =?utf-8?B?YStXRU1pN1VWcmtYWEU5WDM2S0FQbTR5MUxrekNJL1ZKVVB6UllwbG0rTEZj?=
 =?utf-8?B?aGZRTUlQZTZPWkExM2ZGbmR3QzBaejJ4TzgyMkhPZGo0QW1tTFV3SDYzL3Vw?=
 =?utf-8?B?a29QQlZZVHp6em1yNXJMUWRwYmM1d2JwQWZUNWZ2MVIvYXNBUk9vN21BQndk?=
 =?utf-8?B?NFkwU1dFNGNjV1VaeW5GdTkvR2pqUGcwY3lpYUJYNGxrNlJ1MFlaVHg1UlRt?=
 =?utf-8?B?WkRZYXR3WlhoNjhkdzZnc1NnWnVlTS9SUXBRd3pwa1A0Y1VhT3JzUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2B237CDEC91E24091DF66678D2F9144@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: VcA5g1BT17rXmu85xF8aJRQQXymD2ff0YM8Ai0f2J24RrgvIBRqFDLvxHVAvtlC8hqQMac0S5GXuNRwUI95VtZNW65QP+J2BO9fjFlEGvkqO5uR7kypN3bcCCrJGY+wBDGbM5mB/ONdqhrJwvHF5zcH6uQaGgx2Sakmpdipgn6UG3vKKLlTw2sYi3hyuLhc4t/t+v6KGdhTyPvOyzkP2n6iTu5jciOaBSRfP2uiCICYGrgJERjUwgdSvfSpEYdBZmquBNFqlPcw0b6ucK+hXQy0zSu6vtAENpH7DLUXdc53qSRyNLRbAotnxNhfblP1pWBaLMgF58kHgwpJwUjYohw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 845c307f-e41c-48c3-b88c-08decdb86d65
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2026 04:08:32.6053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tr2yfI2+9Dx/P3X9G9NQ1Vo7Scl2ZYIXs8SBGjf1UT78EMJO1kHrtS3weOn5dMBmJL1cpOe5aIWbyY6uZJ17jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7013
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTA2LTE4IGF0IDE4OjA0ICswODAwLCBKdW4gTWlhbyB3cm90ZToNCj4gRHVy
aW5nIGVhcmx5IGJvb3QsIGtzZ3hkIChJbnRlbCBTb2Z0d2FyZSBHdWFyZCBFeHRlbnNpb25zIEtl
cm5lbCBUaHJlYWQpDQo+IGl0ZXJhdGVzIG92ZXIgYWxsIHBvc3Qta2V4ZWMgZGlydHkgRVBDIHBh
Z2VzIGluIGEgdGlnaHQgbG9vcCBjYWxsaW5nDQo+IGNvbmRfcmVzY2hlZCgpIGFmdGVyIGVhY2gg
cGFnZS7CoCBCdXQsIG9uIGlzb2xhdGVkIENQVXMNCj4gKGEgY29tbW9uIGNvbmZpZ3VyYXRpb24g
aW4gY2xvdWQgVk1zKSwgY29uZF9yZXNjaGVkKCkgbmV2ZXIgdHJpZ2dlcnMgYQ0KPiByZWFsIGNv
bnRleHQgc3dpdGNoIGJlY2F1c2UgVElGX05FRURfUkVTQ0hFRCBpcyBub3Qgc2V0IHdoZW4gbm8g
Y29tcGV0aW5nDQo+IHJ1bm5hYmxlIHRhc2sgZXhpc3RzIG9uIHRoYXQgQ1BVLg0KPiANCj4gc3lu
Y2hyb25pemVfcmN1X3Rhc2tzKCksIGludm9rZWQgYnkgQlBGIExTTSBkdXJpbmcgaW5pdGlhbGl6
YXRpb24sIG11c3QNCj4gd2FpdCBmb3IgZXZlcnkgdGFzayB0aGF0IHdhcyBydW5uaW5nIGF0IHRo
ZSBzdGFydCBvZiB0aGUgZ3JhY2UgcGVyaW9kIHRvDQo+IHBhc3MgdGhyb3VnaCBhIHF1aWVzY2Vu
dCBzdGF0ZSAoYSB2b2x1bnRhcnkgc2xlZXAgb3IgcHJlZW1wdGlvbiBwb2ludCkuDQo+IElmIGtz
Z3hkIG5ldmVyIGxlYXZlcyB0aGUgQ1BVLCB0aGUgcmN1X3Rhc2tzIGdyYWNlIHBlcmlvZCBzdGFs
bHMsIGNhdXNpbmcNCj4gYm9vdCBkZWxheXMgZXhjZWVkaW5nIDYwIHNlY29uZHMgb24gbWFjaGlu
ZXMgd2l0aCBsYXJnZSBFUEMgcmVnaW9ucy4NCj4gDQo+IEZpeCB0aGlzIGJ5IGludHJvZHVjaW5n
IFNHWF9TQU5JVElaRV9SRVNDSEVEX0lOVEVSVkFMICgzMjc2OCkgYW5kIGZvcmNpbmcNCj4ga3Nn
eGQgdG8gc2xlZXAgZm9yIG9uZSBqaWZmeSBldmVyeSB0aGF0IG1hbnkgcGFnZXMsIGd1YXJhbnRl
ZWluZyB0aGF0IGFuDQo+IHJjdV90YXNrcyBxdWllc2NlbnQgc3RhdGUgaXMgcmVhY2hlZCBpbiBi
b3VuZGVkIHRpbWUgcmVnYXJkbGVzcyBvZiBDUFUNCj4gaXNvbGF0aW9uLsKgIEtlZXAgY29uZF9y
ZXNjaGVkKCkgZm9yIGFsbCBvdGhlciBpdGVyYXRpb25zLg0KPiANCj4gV2l0aG91dCB0aGlzIHBh
dGNoLCBpbnN0ZWFkLCB2aXJ0dWFsIG1hY2hpbmVzIChWTXMpIGV4cGVyaWVuY2UgYSBsb25nIE9T
IGJvb3QgdGltZXM6DQoNClRoaXMgc2VlbXMgYSBjb21tb24gcHJvYmxlbSBhdCB0aGUgc2NoZWR1
bGVyIGFuZCBSQ1UgbGF5ZXIsIGJ1dCBub3Qgc3BlY2lmaWMgdG8NClNHWC4gIEkgb3JpZ2luYWxs
eSB0aG91Z2h0IGNvbmRfcmVzY2hlZCgpIHNob3VsZCBiZSBhYmxlIHRvIGhhbmRsZSB0aGlzLCBi
dXQNCmFmdGVyIHJlYWRpbmcgc29tZSBoaXN0b3J5IGl0IGlzIG5vdCB0aGUgY2FzZS4NCg0KSUlV
QywgY29uZF9yZXNjaGVkX3Rhc2tzX3JjdV9xcygpIHdhcyBzcGVjaWZpY2FsbHkgaW50cm9kdWNl
ZCB0byB0byBhZGRyZXNzIHRoaXMNCmlzc3VlLiAgU2VlIGJkZTZjM2FhOTkzMCAoInJjdTogUHJv
dmlkZSBjb25kX3Jlc2NoZWRfcmN1X3FzKCkgdG8gZm9yY2UgcXVpZXNjZW50DQpzdGF0ZXMgaW4g
bG9uZyBsb29wcyIpLg0KDQpDb3VsZCB5b3UgdHJ5IHRoaXMgc29sdXRpb24/DQo=
