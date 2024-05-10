Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9D018EA1;
	Fri, 10 May 2024 23:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715384878; cv=fail; b=kMauAz9WId/kwzG2Nt9lBKlLrHaQ3yxEtSae0avVn0SIB+0dE/zyBFMeEWaHAddChpgG8dbhJ33VW2zz0s3Fk8bdIjkbaDql5hVCP/fX9ZBRFjZFXmqGXwU8BcfMczgEJJ2u4EUFpem9TYWAIEersdtVLTzL8+ekZL10Um0gP7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715384878; c=relaxed/simple;
	bh=bM925SuFiUxv3FYYb8WU63Ax/Nh2gxhsPXeI6Vatfmw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QHqGGX39HYbXHIT3acOxzBVHFTS1UVr3Uw6gV5Nk5qTVhFUhokIIWsGjn1NegckO6j9X24PcRgvwWTSvupvgwawgSvuMlC7SNRnk9jn2LYTAX8QrR07tcRjxKGKuRCdQFdW1BmoCt0VWUu+QpaPOUwyH7KfpU+cJpcPLEyjvSAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HTO/pG7+; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HTO/pG7+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715384877; x=1746920877;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bM925SuFiUxv3FYYb8WU63Ax/Nh2gxhsPXeI6Vatfmw=;
  b=HTO/pG7+bV3BzzHyOkonNENHd3U6LE2Sruft+UPmiWIDIV5n1oQlYBlG
   W12maOA4u2aKNfQGCakwZyk5Fh/kcQw7awYemV0fqH9LeXdqS3RENwGjh
   /yTStCEcQ35c+rvUjrBs50YlOxpj8Dx1WSEI06ST3y0KzgFi/v4Plgeiu
   W4IgnvPFwn4N4tPdEU0Re4VwvaydeDjR5Y2A08TBBB4SiHbhrUUKA1DR+
   EffvTvOANW46SPZgcqW9QUGVCQl/by/GItAwmWUOt/UzFlbi6ocZctqJN
   CwOCKpsCegXB3Byexq6UpuGFxWuWxutIFn0t3kSHHjMB5MdwmonVrETTZ
   w==;
X-CSE-ConnectionGUID: 5uSI8oI+SWuYTh52Qaz7Iw==
X-CSE-MsgGUID: T3JpDVe9Tbu9fPLLq7KB1A==
X-IronPort-AV: E=McAfee;i="6600,9927,11069"; a="11252816"
X-IronPort-AV: E=Sophos;i="6.08,152,1712646000"; 
   d="scan'208";a="11252816"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 16:47:56 -0700
X-CSE-ConnectionGUID: p/oVwvIXSD+mur6gDxV7kw==
X-CSE-MsgGUID: ySLgozQnR3ylloaVaUB4KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,152,1712646000"; 
   d="scan'208";a="34312262"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 May 2024 16:47:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 16:47:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 16:47:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 10 May 2024 16:47:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 10 May 2024 16:47:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4WQUJba9vyH9kCszKLP6qriEQP51ZwaFyTpiuX1vO0vKodutnxr1V1+S0OMbZVtL8IAxprFzNkuZIoFStVTJ+UmXVS7guetLcTMdGqh0yoFI89IFBs+Yx7gGEDFRs2u3igigSxQCKEJRy2OzZKDRYEyeZNvcoBQggtk4msuNMRpjFNDO14MLdI1FThmL6NlUO6AlpnZReitWPAhhLeF4ipsGLApJZO0jD1Ep6Vpi+OEuFIDgGf+H/TaB0Ub9UVnPyFML5EspVTiGzxSc0+EbJOHwE1hLrDJeyCXpq9DUyvoVizzMmo/ZNPuG4HBXJBvuW5JZXomKWYlEVcbvREpfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSFFjQIhL9MlJyDDgmOBeUcJqJLpea2UsE3uGUfREmA=;
 b=ConAUoxkysPqWC2Xaaq2h1qULIftI9O3VitX5Mp87V9pmbVRLuG27QGWWDJ/F6mAZcRLxi48gPYYMWpGD9C/Mxl8+SLCqg01AzXKFY7+saQgVnAd51c0EsoUMlSKtRx/cKvyjZ70NqCqeL1lSAG7Y1KH7BqMWiJPwm2qM7vKSCm3szNaehCThjxD1SI4kFOwRCycZo55mBdzaKHvOqWkDqQdVJwV24qRlnFm5PlpDJBZPIL6AjNYaHJW7p4odnC8zVsT6dGSGvw9BO4yQ4CPNn/3p21OBgNrN+g0g6DNnQis/8aG7DuwTwyiAws8xeuH+smxwuN6K8SdsN7koymuiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 23:47:52 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.046; Fri, 10 May 2024
 23:47:52 +0000
Message-ID: <22eaec04-a950-413e-b9a0-885a077475e8@intel.com>
Date: Fri, 10 May 2024 16:47:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] x86/sgx: Resolve EREMOVE page vs EAUG page data race
To: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>, <jarkko@kernel.org>
CC: <dave.hansen@linux.intel.com>, <haitao.huang@linux.intel.com>,
	<kai.huang@intel.com>, <kailun.qin@intel.com>,
	<linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
	<mona.vij@intel.com>, <stable@vger.kernel.org>
References: <D0WMR6UESTUC.IMBRWMJ80RHQ@kernel.org>
 <20240430143816.913292-1-dmitrii.kuvaiskii@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240430143816.913292-1-dmitrii.kuvaiskii@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0013.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4881:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e8c3ab2-b838-4e22-f38b-08dc714b9b80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TzJnTGdFV1prL2dIR1h1V244SEJJNkZac0dTNWlIaUdwUVd5a0RXMVdRSHg5?=
 =?utf-8?B?dC9jR2pPWUV3b1lXRWFQWEdzMzk1aHlqSWx2Q25HZHBCTUFTSzg3Q1B6UVoy?=
 =?utf-8?B?bjBrUEtGM2xiRUZ0eVEvQ1BIb0w3OW5raUFGUktoemR6OHR3ejByWUdCZzJk?=
 =?utf-8?B?cnZyenRwajNjaG5CcTVUWm1uYVBOakc1QlV3ZFNBdkI0WUhtOUxlTWZjOE12?=
 =?utf-8?B?NDFKWGVLbnk2TzdGaFlFc1JyUFdNL2hjelFBZXpXUmRGN0l4MXZWY2VBa0RB?=
 =?utf-8?B?MzVLODRRektiOFBOcHo4eXU4alViNDZubDBPK2IzbXBCUWFpY2kxNmgybFdF?=
 =?utf-8?B?aW9ZcVd6UCtBdDBrYU1FVFFLWnlFWnRaYU43cjY3QS9KRXVMWVpSOGxHOTVm?=
 =?utf-8?B?bVYrOTJHc0QvNTdWZnIyY3UrTEJzZ1ZvRW9VRDE4V2V5Ym5SdnR1MlNCNklU?=
 =?utf-8?B?SFZ4MFgvbDVzekluVFRydi8yZk8zVmlKUG1BYVliM1hUMTJqL05uam1CUXl6?=
 =?utf-8?B?UzJ5R01UdlpxTmFwZWxnclBFQVU0bjFRNkJlUGlCTTFxTVRyb0NtV2dzTEt2?=
 =?utf-8?B?a3FXTlFpZ1phenBEYkw1T3J1bWRnTTFZRUlUZUMvRllkRFVrSE9Mb0U2dXl3?=
 =?utf-8?B?dWdZVkhwNTFsMkJ1RnRQOTBTN240dVhWOHM3T05SR1hqeCszZU9JR0dnYlcx?=
 =?utf-8?B?WUw1RUkvekp4MmI4aXJqOFZEL3VqbU1jMGNqQXl4UHZSYTREZlVpQnR3VWRz?=
 =?utf-8?B?YTBwcUoxV3pBWmZod3liaGFxMG1kdW5Fa05hQUp4NFpzaC9wVGhjZGc1VE1R?=
 =?utf-8?B?RWcrbm1nZHNIZ2VMUms1YnR1TDFKSmpxcHAxaWxxVk9KV1JidnpYWlRiNEtU?=
 =?utf-8?B?YXVMQW9KWWVKa3BaRlZKZzl3OUZjY2MwSkNucmhyL1VxVXBtUllHdDlXdklV?=
 =?utf-8?B?TVZTSXE5S1ZPeWh1WFF3LytCMTZsRmxKL0FJcm1YanZ5dGd1UlVVVzNScHp2?=
 =?utf-8?B?TDVLMTY0bnJBUEkyb2Y3anladWhsTkw1QVkwNnc5THBQdms4VEg4QTdTazlT?=
 =?utf-8?B?amkrc0xlSUJVQmlBNnNFT0N3TEcyUm82cXVFeVJzSzFUSFF6RmRHM2JhRmtt?=
 =?utf-8?B?RS95YXp5V1I2M0hWc1NzUjJhMUFLTG9Oa3NjUmpneUdKc1JuMVM5YXpLWWtq?=
 =?utf-8?B?L0EwTklLMHYzeFJ2bzUvcW9HaFBuMWMreC9jRUZHVUtSV2xQb0JQSkg3clBP?=
 =?utf-8?B?OTJqNUM0bUk4YTJVK1ZZOEZkMkFkMXdpM1hiNGRRWHV1Vm5HVmhkK0JMOThv?=
 =?utf-8?B?L3Rqd1V4dU9VTFlvaG9lR3QxRC9MSXdDemVralVkNXZwMEpCc0ROKzdUTFBN?=
 =?utf-8?B?anpHdzZQOEt2T3krYUVtbUk5RUZmblh4cE5NM1BkcGs1UmJXNU1WR1cyMEpB?=
 =?utf-8?B?d1RUbVFBWTJGWktXTXhMaXlyY3FvTUwzSjBjSDE3RUZ3ZDVpNElLUlhGTTRa?=
 =?utf-8?B?QkdTcmFxYzZyZEVSVC9wR2VTYTFULzdTdUgxd0dDYmFwL1ZrbEIrcWxKVk1r?=
 =?utf-8?B?QVgrTFNvRTVXL2NQa3NVZUVaVlU1Mks4Ly85cCtBQmtmNFdVTDhGMkprdHZE?=
 =?utf-8?B?dmhCdmhKMUZ6b3lsb0UxWlloN25PVXc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzJvK09CZ2pWVCtNQUNiZjg5ZlJic1RBNyt4Q2lIMksvczJWTFBscGNJb3FH?=
 =?utf-8?B?TXJ5NVd5cHA3alVTUFpIMkQ3VGYyb1FMUFhSVW8zT2pIWk5VZzlGdWprL2Js?=
 =?utf-8?B?aWd6ZERRRi9za2VQTFlwYTlYMkc4UW1NUktoK21uR21uQzFyYkNFR0JaNWVL?=
 =?utf-8?B?QlBTdzFiRXFRT1A1Slg4eXdscWYyS3ppYUtxQk5vSVZxUnBuZ1o4dTNNU3lH?=
 =?utf-8?B?bWljV29jM0VGRXJXYzk3V2Myb0JxS3FLVHBKQzZSaTE5Wmp5Z2NsVkNtSnY2?=
 =?utf-8?B?YTlEblJMbW1iclJVY1h4aVdWc0xBeE5vaitoUlRldjhRMWFFdGZ1VTREaVRs?=
 =?utf-8?B?ekN0MUVoTlNKRFdYVTIybjVrOEYvWFZmQnFoT0pvZ3NSQ0JXSXVxTitNZFE2?=
 =?utf-8?B?cDc1akMvWFM3YytuNlhsQWVHRk1EUFFGb0xJL1JaNnE1UGEwTmxVMEQ5NWE5?=
 =?utf-8?B?S2lwbXlqbkxpc01BMVQ3YlEvQUoyM0VyT1IvN2hQZy9JVFRCdHEyMllaYk5W?=
 =?utf-8?B?aTZUNkN6WTBmdE1DSXRJNTlFbktkU25vZ2IrOVdPUWdZL3Btc2srZVpjb0pr?=
 =?utf-8?B?cGw4WHBub0ZKa09QNWZOUThockdhNjFXdm5IODg3TlgzbmZYaFZHQlQ1WmVy?=
 =?utf-8?B?eGFFRTJiOVh6YXczQlpLVjVlellsTGowaTA2SXpXMHo5dVpXaHByTms1U0tU?=
 =?utf-8?B?WjFUWWtPcjMyMDF2NFBkNEQ3T2VEWnVleHl0TTA2dzBOeDkxclZQdWZKUzY0?=
 =?utf-8?B?QUZ4bzhzV3ZsMVBGNTJNa3MzVFE1dHhlekNxdnFYNW1GNXAwbk5LSkZ4SjVR?=
 =?utf-8?B?N3cvd21nQmFSZ0hta2RFZEhVWmNNbVJ5ZGFDc3VrU1JTc3FYYzhwSmt4Z0Fq?=
 =?utf-8?B?NytKRExob0ZONEZlSTdxZmN0NzBCdnY3blZOK292VDBrbW02MlNDa202WFlx?=
 =?utf-8?B?MVRCbWZQWGtiaHF2WTZnQmhnOW1vcUlJenU5SUZ5QktxYTBnZjdmUXhQeUVq?=
 =?utf-8?B?UVA4K2ZjdnUyZkRPMG82dDlsTzdwTHpQa1JkNHBLWDNRWHlrVTRLVm9PVzlM?=
 =?utf-8?B?d2V0SHNiSGhvTVNSWE5zcUV4aElxK3NXTUVhUHR2YTN4SUtOV0tGQ29RYTZC?=
 =?utf-8?B?TnRqREgzSnRsc2lqMXhRZElUcHVMZnNEM0RYNWdOUG9yMDBoa2JETkpmM0Mz?=
 =?utf-8?B?Q0dRV2FnU1dTOHVLZ2JJK2VpdkVwVmlkVVczeU4vaTFmYUxSRnBvMENMekQr?=
 =?utf-8?B?YTA3YUFwYjQ0S2tIMkh1TEVVRktISnNmQUgvWmozNUtXTzhkdHJBU2ptMjVP?=
 =?utf-8?B?d2VFVWdMWXZ5ZnVRTkF2eXFTeVluWXAzZ1dVdDVwYUpkaWZ1K1hJc3N0NCtI?=
 =?utf-8?B?N2IzcHUxcW5xZzdTWE54dnNwend4QXJFSy9INjliNVhrYnc3aDVnb3VPa1Jq?=
 =?utf-8?B?UHVDTFhNMVJmbHlOaWh4R3I0VnF6RVAySk0wU0ExY3hwUFcrTTZVdTdESkd0?=
 =?utf-8?B?anI0RjBvMmR6bitsMmtlMUxTZzhyN2k0R2xTOXRXMjhEOEEvaWlIdFYzZ2ZP?=
 =?utf-8?B?TWxVaUdpSVJxbDBYemhhT3FzYTNsUk1DV0JRN2NIQVhmUGdXMi9QUmZmR1Nv?=
 =?utf-8?B?Q0NKWGdDUWhXVkVReVdzQ3o2M1B0d1AwR2svWXJRMUFtYXVhbGRqWUExT2M1?=
 =?utf-8?B?VzAyMGRnZ3g0S01EcTVUV1lHUHlRN3o4eFgwd2NONVUwV2hyNllVQ0xFWlU0?=
 =?utf-8?B?eU9aOTNNNkRnNjBLTTdtS21TSzZzTWhuNzRtbVpkVW9rZGEwcWwrMkxYaW5K?=
 =?utf-8?B?VkQvQXBMMHhlQ3BpT3NQa1p4cW1nVlBiSFdDTUdOOUUweE5uV0I5c1psOVFK?=
 =?utf-8?B?NHNXTVdFUEZlekJlcG12U2M0bGhvSkIyUUdUM2grcjY5RS81R2VMZWZ2djZi?=
 =?utf-8?B?OXJ5N04reFU0b3IyWXU0dnBIc1NaZTdOWWdxTDk2NlN0Mk9CcUs0dWtSWXVz?=
 =?utf-8?B?aE02OVI0WHA5UmFoTXB6NEdhRjFrNHc5YVBOZEhqSUVod09NVVlYV3JOQVlI?=
 =?utf-8?B?R1orRWd0TDkwVHM4T2M5cEdWSSs2YlZGNVR0Q3Vka3pVc2F1eXBmMW5WL1V5?=
 =?utf-8?B?L3JnMjk2VUlrN1FUU2VZWG1DNERueWM0MlVvYmJManp5Z1U1bStmcmpwSVFN?=
 =?utf-8?B?ekE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8c3ab2-b838-4e22-f38b-08dc714b9b80
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 23:47:52.6133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PCqfWDBuH6vb/whW1N0gb5p0idCoWOIypNhft/idNmDGokA9f7vk2dsYqofKRzG4FavUSqQaO5hHeRI9CZoz/VSuEt433RxYCzE01GyHE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com

Hi Dmitrii,

Thank you very much for uncovering and fixing this issue.

On 4/30/2024 7:38 AM, Dmitrii Kuvaiskii wrote:
> On Mon, Apr 29, 2024 at 04:11:03PM +0300, Jarkko Sakkinen wrote:
>> On Mon Apr 29, 2024 at 1:43 PM EEST, Dmitrii Kuvaiskii wrote:
>>> Two enclave threads may try to add and remove the same enclave page
>>> simultaneously (e.g., if the SGX runtime supports both lazy allocation
>>> and `MADV_DONTNEED` semantics). Consider this race:
>>>
>>> 1. T1 performs page removal in sgx_encl_remove_pages() and stops right
>>>    after removing the page table entry and right before re-acquiring the
>>>    enclave lock to EREMOVE and xa_erase(&encl->page_array) the page.
>>> 2. T2 tries to access the page, and #PF[not_present] is raised. The
>>>    condition to EAUG in sgx_vma_fault() is not satisfied because the
>>>    page is still present in encl->page_array, thus the SGX driver
>>>    assumes that the fault happened because the page was swapped out. The
>>>    driver continues on a code path that installs a page table entry
>>>    *without* performing EAUG.
>>> 3. The enclave page metadata is in inconsistent state: the PTE is
>>>    installed but there was no EAUG. Thus, T2 in userspace infinitely
>>>    receives SIGSEGV on this page (and EACCEPT always fails).
>>>
>>> Fix this by making sure that T1 (the page-removing thread) always wins
>>> this data race. In particular, the page-being-removed is marked as such,
>>> and T2 retries until the page is fully removed.
>>>
>>> Fixes: 9849bb27152c ("x86/sgx: Support complete page removal")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
>>> ---
>>>  arch/x86/kernel/cpu/sgx/encl.c  | 3 ++-
>>>  arch/x86/kernel/cpu/sgx/encl.h  | 3 +++
>>>  arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
>>>  3 files changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
>>> index 41f14b1a3025..7ccd8b2fce5f 100644
>>> --- a/arch/x86/kernel/cpu/sgx/encl.c
>>> +++ b/arch/x86/kernel/cpu/sgx/encl.c
>>> @@ -257,7 +257,8 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
>>>  
>>>  	/* Entry successfully located. */
>>>  	if (entry->epc_page) {
>>> -		if (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)
>>> +		if (entry->desc & (SGX_ENCL_PAGE_BEING_RECLAIMED |
>>> +				   SGX_ENCL_PAGE_BEING_REMOVED))
>>>  			return ERR_PTR(-EBUSY);
>>>  
>>>  		return entry;
>>> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
>>> index f94ff14c9486..fff5f2293ae7 100644
>>> --- a/arch/x86/kernel/cpu/sgx/encl.h
>>> +++ b/arch/x86/kernel/cpu/sgx/encl.h
>>> @@ -25,6 +25,9 @@
>>>  /* 'desc' bit marking that the page is being reclaimed. */
>>>  #define SGX_ENCL_PAGE_BEING_RECLAIMED	BIT(3)
>>>  
>>> +/* 'desc' bit marking that the page is being removed. */
>>> +#define SGX_ENCL_PAGE_BEING_REMOVED	BIT(2)
>>> +
>>>  struct sgx_encl_page {
>>>  	unsigned long desc;
>>>  	unsigned long vm_max_prot_bits:8;
>>> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
>>> index b65ab214bdf5..c542d4dd3e64 100644
>>> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
>>> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
>>> @@ -1142,6 +1142,7 @@ static long sgx_encl_remove_pages(struct sgx_encl *encl,
>>>  		 * Do not keep encl->lock because of dependency on
>>>  		 * mmap_lock acquired in sgx_zap_enclave_ptes().
>>>  		 */
>>> +		entry->desc |= SGX_ENCL_PAGE_BEING_REMOVED;
>>>  		mutex_unlock(&encl->lock);
>>>  
>>>  		sgx_zap_enclave_ptes(encl, addr);
>>
>> It is somewhat trivial to NAK this as the commit message does
>> not do any effort describing the new flag. By default at least
>> I have strong opposition against any new flags related to
>> reclaiming even if it needs a bit of extra synchronization
>> work in the user space.
>>
>> One way to describe concurrency scenarios would be to take
>> example from https://www.kernel.org/doc/Documentation/memory-barriers.txt
>>
>> I.e. see the examples with CPU 1 and CPU 2.
> 
> Thank you for the suggestion. Here is my new attempt at describing the racy
> scenario:
> 
> Consider some enclave page added to the enclave. User space decides to
> temporarily remove this page (e.g., emulating the MADV_DONTNEED semantics)
> on CPU1. At the same time, user space performs a memory access on the same
> page on CPU2, which results in a #PF and ultimately in sgx_vma_fault().
> Scenario proceeds as follows:
> 
> /*
>  * CPU1: User space performs
>  * ioctl(SGX_IOC_ENCLAVE_REMOVE_PAGES)
>  * on a single enclave page
>  */
> sgx_encl_remove_pages() {
> 
>   mutex_lock(&encl->lock);
> 
>   entry = sgx_encl_load_page(encl);
>   /*
>    * verify that page is
>    * trimmed and accepted
>    */
> 
>   mutex_unlock(&encl->lock);
> 
>   /*
>    * remove PTE entry; cannot
>    * be performed under lock
>    */
>   sgx_zap_enclave_ptes(encl);
>                                    /*
>                                     * Fault on CPU2
>                                     */

Please highlight that this fault is related to the page that
is in process of being removed on CPU1.

>                                    sgx_vma_fault() {
>                                      /*
>                                       * PTE entry was removed, but the
>                                       * page is still in enclave's xarray
>                                       */
>                                      xa_load(&encl->page_array) != NULL ->
>                                      /*
>                                       * SGX driver thinks that this page
>                                       * was swapped out and loads it
>                                       */
>                                      mutex_lock(&encl->lock);
>                                      /*
>                                       * this is effectively a no-op
>                                       */
>                                      entry = sgx_encl_load_page_in_vma();
>                                      /*
>                                       * add PTE entry
>                                       */

It may be helpful to highlight that this is a problem: "BUG: A PTE
is installed for a page in process of being removed." (please feel free
to expand)

>                                      vmf_insert_pfn(...);
> 
>                                      mutex_unlock(&encl->lock);
>                                      return VM_FAULT_NOPAGE;
>                                    }
>   /*
>    * continue with page removal
>    */
>   mutex_lock(&encl->lock);
> 
>   sgx_encl_free_epc_page(epc_page) {
>     /*
>      * remove page via EREMOVE
>      */
>     /*
>      * free EPC page
>      */
>     sgx_free_epc_page(epc_page);
>   }
> 
>   xa_erase(&encl->page_array);
> 
>   mutex_unlock(&encl->lock);
> }
> 
> CPU1 removed the page. However CPU2 installed the PTE entry on the
> same page. This enclave page becomes perpetually inaccessible (until
> another SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl). This is because the page is
> marked accessible in the PTE entry but is not EAUGed. Because of this
> combination, any subsequent access to this page raises a fault, and the #PF
> handler sees the SGX bit set in the #PF error code and does not call

Which #PF handler?

> sgx_vma_fault() but instead raises a SIGSEGV. The userspace SIGSEGV handler
> cannot perform EACCEPT because the page was not EAUGed. Thus, the user
> space is stuck with the inaccessible page.
> 
> This race can be fixed by forcing the fault handler on CPU2 to back off if
> the page is currently being removed (on CPU1). Thus a simple change is to
> introduce a new flag SGX_ENCL_PAGE_BEING_REMOVED, which is unset by default
> and set only right-before the first mutex_unlock() in
> sgx_encl_remove_pages(). Upon loading the page, CPU2 checks whether this
> page is being removed, and if yes then CPU2 backs off and waits until the
> page is completely removed. After that, any memory access to this page
> results in a normal "allocate and EAUG a page on #PF" flow.

I have been tripped by these page flags before so would appreciate
another opinion. From my side this looks like an appropriate fix.

Reinette


