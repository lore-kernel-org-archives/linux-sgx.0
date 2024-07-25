Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AB51114;
	Thu, 25 Jul 2024 02:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721872874; cv=fail; b=fGo6qXCGREPc/1QLmE4V36PYygL3LK3HMhrOMMYIbvN/+XxvX2lpUtxPQzz9y3t/NhmoEyX63N2Vudxkx8POWMeseX+0r0iUyhmJQoz2mUiy9p8MjidAu9WDJftmIFVpV+/9mXZeIfvfjpdDETkmiTj2Ih6a3OmXph2GAHIRdGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721872874; c=relaxed/simple;
	bh=NtD8r3XjVxTj6j61ovb5h2Rtf3EWGlvJLsiZktf6CHs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HaBKhlDz3wsKicHwikiPBnbwn1+DbK9vXPPtl1zLTYlR71jWTIsOdLvZ+WlROL5EENX/EOl502kIooHEOErcnrwhTJqmz1vVP89Vt/Pq78TqCKBFSFOsY2KaOuGZxTvcKOhQp5Ke4EUUDWeToOAczQDgHpJfR3ibIT6vFEb3ono=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eN1ba/Ux; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eN1ba/Ux"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721872873; x=1753408873;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NtD8r3XjVxTj6j61ovb5h2Rtf3EWGlvJLsiZktf6CHs=;
  b=eN1ba/Uxrz3rjob5+DQZ+lsNsBhWVKuVgprrgcwZf1haRAT51WqjpR2y
   ywOYyIih4N8unPOdbLwJpIf6xNRhMUixdRHH4w05Lb/MD0pcNqVKXGlbd
   YSxXYzybcwPnZK0eBtIiyZS3eOhSTpAsoRg0DnjcyE0M8OCH73SVSS5dM
   udm9OqOdy/izz/13NBgQ/Wvg7YNlYzj95o/bmYDdUwjwkEx4FKtAdbR0Z
   lKMTS6KikWNT01B7/2MgasfKuUrnGOw0jsO8byy7EHkQnShEQdVhJhHSK
   sBFQt5a56In0RLev2OluU4XyaX9fBXHELy/JSQFPC4abAJ0zCJASFz/IO
   Q==;
X-CSE-ConnectionGUID: Bz0i25CuRKmzlMKjywHPZA==
X-CSE-MsgGUID: yjT6BMI+QBy2nW7jOfMkfw==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="19724472"
X-IronPort-AV: E=Sophos;i="6.09,234,1716274800"; 
   d="scan'208";a="19724472"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 19:01:13 -0700
X-CSE-ConnectionGUID: h2/BNoD2TPmj/X6CrqgaSg==
X-CSE-MsgGUID: i0n1BnCoRwiZviXwJxkrvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,234,1716274800"; 
   d="scan'208";a="52699682"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jul 2024 19:01:11 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 24 Jul 2024 19:01:11 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 24 Jul 2024 19:01:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 24 Jul 2024 19:01:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 24 Jul 2024 19:01:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H6wFjf9R8WdZdkIkpc22YEizL0oQ3ErRkIHg1ztl22CT+fYvnzSvrlArmf6I26TdSPO1cW4F8jhjKo5oe89XVROyb/7zNw81uU1vc8OpTdALQC2QNJHHklpLnQaRZtlHe7wOt+Y1/Sfs1NlJzkvIaKKfHWwxRruJ8SfWeLZX0Dmu2/mTmU37WYcluD7LgpUrXwQQiPt2OtptIBfQQh4WikBWQSf6QqCRj1u3XWL/uhNAYhCm9gOhJ2tvFSH+UBYOKg/equB3bnCkKg91Ybbrqwak4H5C/ER5+kfdbvVQlyfygl7z+Jwpbzo2AVe7jp/4eQkCIObtdg5FwCrl09x3pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46KavNNl2oJ9AJ6ePnY52is0yX2f/T3lmolGXpSGJGo=;
 b=chZzyE1W4+uRV3W1g1D8LXXgoqxBnwsyGKGwkzfxh4ibKgqcdULFPIky1zGaqFushBOJLEU2R8n3zHgjuS9btdB57B6/la/yzF6Sdrbugvrg0/2njoyg6k9TMdb9hcea1YS1vXGHYboYTrIABftz3I6zGjuFgibt/BdKlwnZdYPL1h1tvdMQYwNKt5Z3p/Eol0py+fT/igwcbILXnno1IoeVRdLPoycDmoF8XT2ZhvIbd7Yzico5/JxHlNkUQSyjaFO0iYaa+wDc5HYCQuuRNLkxEec0NbYWEuns9S9453czA/tVvLwRIdBPHSX2ZI5r6W62UIWHZMEChDP2ZmzP4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6273.namprd11.prod.outlook.com (2603:10b6:a03:458::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.33; Thu, 25 Jul
 2024 02:01:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7762.027; Thu, 25 Jul 2024
 02:01:07 +0000
Message-ID: <35441491-99cf-403b-9e64-9d7b0453e59e@intel.com>
Date: Thu, 25 Jul 2024 14:00:59 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED into
 two flags
To: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>,
	<dave.hansen@linux.intel.com>, <jarkko@kernel.org>,
	<haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
	<linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
 <20240705074524.443713-2-dmitrii.kuvaiskii@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240705074524.443713-2-dmitrii.kuvaiskii@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6273:EE_
X-MS-Office365-Filtering-Correlation-Id: e3bad6ac-4683-46b0-619e-08dcac4da5dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bFh4aXI3Z0NKMFp1YXVzcExFUHN1T3JGRTk3YTRPeHdOS2xscWJTcVJ2Zyts?=
 =?utf-8?B?V2Y4bGRPbDFLUzZ1Rjk1NUEwdzhHQW1jSWxQNUJwZjh6U3VRSDB2ZllqYzN6?=
 =?utf-8?B?eUxyOEgwNkc5c2lwTHZPMkJ0MHkzNGN4b05WRHVyL1MxNEg5WHo4UE5rT042?=
 =?utf-8?B?UzJFMnpWdXBOS1lpYmV3dk0rQzNVYUpYdEcwOWtmVWsxcGNmWlByeWZMcFV0?=
 =?utf-8?B?ZE5yUytnUm1lM0FwcUxhdlVHUXA2VXM0dDBMNDNOcnVVeHNscEZtUkxVamVp?=
 =?utf-8?B?YTJsL3pUUVZWalBoZnJ5UlMvczVLYmk5OXNBdmRWT3dGTVg3b0FhZ0pVdWJi?=
 =?utf-8?B?NjluK0EvaHBtUzFJZHh5L0ZkS0NQZUdrQWdwbGNHTVVjYW8rblJIcVlnVXpI?=
 =?utf-8?B?Ly9UOUlSVmREWnBYM0Z2SmwxSyt6Tmpnb09tMVdLOXdFWW1Wa2NLK2ZBOTNS?=
 =?utf-8?B?ZTVKalJQMm9veGlDWjRSYkI2dG94TENPUmgxdE5zN2ZNcS9KelRPT241Nk1C?=
 =?utf-8?B?OFNvQ1BMdnV4RGZScUJpM2FZaDZKVStTZENxdSt2WnhJVlNZcHRpM08zZzRR?=
 =?utf-8?B?ZVJra01EQUpreC95V2VQd0F3NWY1eU8vOXQ3bWtDQ3FKclRaYTJnb21Lb1E0?=
 =?utf-8?B?Y1VHemdKNkJYMGFuL2NxeDRBY1NOczRqd0RDU3Nna1pXb0pjMHBuWHd6aUhp?=
 =?utf-8?B?WmNqVEpCdUpvcHZtcVVTazJCSk5wckd3bVJWMlFXUUtFUUtzWE1iRllNa1pR?=
 =?utf-8?B?a0M3T1pxWkphV3o4TG5KalVBNm5MRnJWd0VHOFFkZnFrVzhpTWU3eDcvSzZs?=
 =?utf-8?B?eURQdkkxS3VlajRMdzJoUXVKSzdpcFhXTVUxZ2VSQTlzZi8xZUk0RHBjYzc0?=
 =?utf-8?B?WnluTG1sa0lWb0xQaE1BYTJMZmxDaVlJc2JRSC8vYWNiRjVGTXFsMWllWE5t?=
 =?utf-8?B?cHV3TDJJQ2w1Z05VdkdBeGlhVS9HKzRnbmVGejJZRlJiZlpmWUdwZGw4KzlD?=
 =?utf-8?B?dkdRYUxYWTU4ZzZSd0hGdDdaUGVHSlMzRzNINkdoQ0cwTURlSFdjTUl6YTFV?=
 =?utf-8?B?YUx6QWhpMGRQb3hiL1B3dk5sYXRubDNRTXFjYWMzYTBTaHptMmZibm93UDVs?=
 =?utf-8?B?ZnJTeGI2bXZWNEpkNDNDeFJwcFNaT0FmQjRBUmxIa29hMGtqL25qbk5Dak9Y?=
 =?utf-8?B?V1I5cXVibDhNR01HdW96R0R1QVpOUTVVNHhkRkUwblpxbG8vRDhzNUs1MWU3?=
 =?utf-8?B?cnVyMnA0VGxNMlIzeEdrcUFhNTZVZ3NlMmVjdXowNDl4Ry94emlRbFROakhp?=
 =?utf-8?B?ckVkNzlmRWJiblNyd3FLRmRsRHlJME5VUVZFZGNSZk9oOUg2SDBQVnlxd1lL?=
 =?utf-8?B?OHJ4MmdPRkUxV0ZHek9hZDFzWFE4ZUZyOG1lZVM3cWtqaHBzYXJnVmFiSTBW?=
 =?utf-8?B?a0pDSU52VjdVam9KaGx0SEtUaTVMNGFjZnFOdWtxRXRucHU1cms0QnlxU1pM?=
 =?utf-8?B?UXFwYy9DZmxlUFdxbjh2VkJ4V0l0SE1DSHVZdzFkRFMwVFhldGd0bWZudzhB?=
 =?utf-8?B?a3RQNzZMMWJwME80d2srdG9pb1M2TWNWenB2Nm9idmEwWDRvWW1sVWM3ZEtx?=
 =?utf-8?B?WjlWaXJRS1hSWmVrRFpQZkpJS0dXRHZWKzBJQXRQYUF3R2t4ZUFsb2d6aXpB?=
 =?utf-8?B?c0dkaC9QSlRnR3VCdHhjWVJlYU5Xd0dXcVVGZkNCd3JDR2ZsMkU2bUh0ZWow?=
 =?utf-8?B?K3Y4amh3M3p0QVRWNzhIVlFYRGs5ZTRCdi9ES0gzdnBOS2lWM3YyUjJMQ1lz?=
 =?utf-8?B?d1ZFYmhNZ2lJUFRKc1hLUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlI0M0Vjc25PU3N5T0FUa1NrYWlyazVzVDYzcVJLVzNPRjRGYll5TVZqWEZr?=
 =?utf-8?B?eDYrb0hobUFjaXQrKzhVTXdzNnVmNmdGYlNCNjY1WncwdEozSnIrYmdsMTJ2?=
 =?utf-8?B?UldZV1NKM29BSDZvdU8rV2s1SHBIRFRrMmhHRGE4R2l1ZWZPWTdaTHlZUG9r?=
 =?utf-8?B?Y3JwZmtJRVFoNTl0WkRzTDNsZ3R4aGhIeTBzMXZVZUJMUzl4L1FzYURCcFIy?=
 =?utf-8?B?TksyQURBMkhhYU5KWndyWkE4blZDek5nblEwV3BZVjZ0T1hxbTA0ZHVCOFFV?=
 =?utf-8?B?aG1vWmRqTnlBU2xwL2R2RGdYUGdrU3EvWElhM3hON2RTWlVoQXpWK3E3N0dL?=
 =?utf-8?B?VVE1SWZBVTFwMFpRNjB5TTU0N2dpUVBJeTFZeUJnSHJrNjhyRUluanc5ckgr?=
 =?utf-8?B?eFg3dUFJZ3pFeGNjbVU2TzQ0NkF5YllMY09YVytRdlVnSk02WHZiWlY4SUFW?=
 =?utf-8?B?eG9yaS9kMjUzcFRvQlN0VmFNdHVjVXRZVUNzMXVpajFiQmVaSkc0ZmxGb05t?=
 =?utf-8?B?NloxN3NwWXErd1haSXpoQ3ltcUl3UDlneGQyV0ZnNlhHcXRJUVFTelFDV0pR?=
 =?utf-8?B?citGWm9DZDV1aC8wK1k3UGJta3hQbXJTenFMMkNLWUdheUNDaVQySWx3MjVz?=
 =?utf-8?B?V2hHd1g4MW5GT3pDMGVZNzhiRHZnbzIzckZXdjg1M0xWZXRCRzQrQnpyZmNL?=
 =?utf-8?B?RGR3TnNhaWRyZVUwdzRNZXdMSyt6MGlhV3BSYUtOSWJCT2hnMURVTWJqSGJX?=
 =?utf-8?B?TGhRYUtnWWFRdEdqLzJ4b3FQUmtueithUWVyU1ltcUdjWHZlekZXV0lHSGgx?=
 =?utf-8?B?T0hEa2F5clExeEsrY1kxY1hMSURQZUJVV0ExQ21ybm40QkZjNW13Ui9RWHAy?=
 =?utf-8?B?YlRWbGpLSkd0WjlPOWlVNDd0Si8yNUR3a1NodTJrNHU1MDQrY1IyU2IzdEZi?=
 =?utf-8?B?VW42cWRZbmZLMW5mTURueUhqMGpDKy80WURNcWhyMFBzVWYxeUJTNGx5bUpZ?=
 =?utf-8?B?eWs2K1lSVzZqZW9lWnhlbU4xaDE3QU9wWlFDRU5CRytjMkdqR2xBWDEyVkQ2?=
 =?utf-8?B?UkU2ZkdWZ3pFc2FvMlNpT0NIdkJIdkxNTkVCT3JlbFZtZ2QwaUtzc1BaNVgr?=
 =?utf-8?B?NVBzNWlYT1ZJUVp2SWh1Y29DLzgrZE9DbEFmQjl3SWloMWN4eE8vMTd5Z1po?=
 =?utf-8?B?QXl4Z3d3VHdBaDRSekhLN3FFK0FEcmdIYkhNMnB0VjRxbnVHUzFTdER1Nysw?=
 =?utf-8?B?akZ2MGtDdU5rS1l1cDFzNExJaTZYVEZpS0dPOGcrM2ZSMWdXSEVXSWY3N2U3?=
 =?utf-8?B?OW16Y2pWa3NuVEN3UGVUaGNuTWdlUVIyYWNlbE1RQjhWaUV2ZkpaSkpQWnZI?=
 =?utf-8?B?VERlekxJenhLQlJyZXBjSmZZQVgyK0crWk1UUHlIWjJlU29FUjR5Kzl2WDlp?=
 =?utf-8?B?Q1FlTHdteHprTnBtaTJEOEJjQlNYMVIvL0VZY2RFZWQ0K0x6OW5yVVE2a2Fs?=
 =?utf-8?B?eXR6Mm1wZDZ2R3E0WUM5eExmZVMvRlJhYlo0dXprSFhJeU1CTFhtdzJ1R0I3?=
 =?utf-8?B?RkZoZzV5dFJiOHNmL2IzSVRVcU5IekJmWjJaZGwxV0J1bDFrN3FMd215K3RN?=
 =?utf-8?B?WHZxWVA5S2M1S0RXcW9kWXlISnJudzhjYzNidEc0LzlIT3RKanpoR1g3bVRR?=
 =?utf-8?B?cUExbm5ENnNpOTFrZFdEK1Y5aVZoTklIazNBS0dHdUpEc2E0OU1nMDhvSG9W?=
 =?utf-8?B?amZZNlV6OGFDVEhvWkVJZEIzVExibGhZSThqSVltYmZLc1Eya2dWWHNKeXFQ?=
 =?utf-8?B?MkwyZUVuNTVpN3Q4Zmo2YzcxUUxPcSt1Y3pLd0ttM0xiVWgxUkdORURZZk9y?=
 =?utf-8?B?d0pLSW5HV0tISTR6N3RiWE1reEtBUk1RTW1JdXZ4OS9wZHpnUEpwdzF3ekhj?=
 =?utf-8?B?aGNQUjZxRTBFZ1lJaGZLOEVYaGxnOGM1V0d1MTJGY3Bha3ZwYmoxZzVjcmo0?=
 =?utf-8?B?Mlo3UFpZczRvTU9BN2E2Z3BEaG1CZUN2TitOT0drL2FtZEpTQWQ4WUl1ekJr?=
 =?utf-8?B?Q1U3QVoxU2pIZlJ5Y1ZheUZoSUltVk5MN2J6NE0xT3J5akFXWWlaMitWQ3FL?=
 =?utf-8?Q?XBWdX2i8Ifl8x0Pk+Q4D+Cpbq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e3bad6ac-4683-46b0-619e-08dcac4da5dd
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2024 02:01:07.6725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OYIL0/xUvGAeF9dBh8vkyANRcAF92Hn/AY2mfaemhR9W6kpl4A0/01CQXGpYLCLk304TXO4e4ATq/ZpNIFqQlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6273
X-OriginatorOrg: intel.com



On 5/07/2024 7:45 pm, Dmitrii Kuvaiskii wrote:
> SGX_ENCL_PAGE_BEING_RECLAIMED flag is set when the enclave page is being
> reclaimed (moved to the backing store). This flag however has two
> logical meanings:
> 
> 1. Don't attempt to load the enclave page (the page is busy).
> 2. Don't attempt to remove the PCMD page corresponding to this enclave
>     page (the PCMD page is busy).

Nit:

I think the SGX_ENCL_PAGE_PCMD_BUSY isn't that accurate, because 
obviously the actual backing page is busy (i.e., cannot be truncated) 
too.  So the current SGX_ENCL_PAGE_BEING_RECLAIMED is also fine to me.

But truncating the actual backing page can also be determined by 
SGX_ENCL_PAGE_PCMD_BUSY I suppose (if needed in the future), so this 
looks fine to me too.

> 
> To reflect these two meanings, split SGX_ENCL_PAGE_BEING_RECLAIMED into
> two flags: SGX_ENCL_PAGE_BUSY and SGX_ENCL_PAGE_PCMD_BUSY. Currently,
> both flags are set only when the enclave page is being reclaimed. A
> future commit will introduce a new case when the enclave page is being
> removed; this new case will set only the SGX_ENCL_PAGE_BUSY flag.

As replied to the last patch, IIUC EREMOVE ioctl doesn't seem to be the 
only case where the BUSY needs to be marked, so let's just say something 
general but not mention the removal case specifically.

Anyway, feel free to add:

Acked-by: Kai Huang <kai.huang@intel.com>
