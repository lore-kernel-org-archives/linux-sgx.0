Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E93F11CBA;
	Mon, 10 Mar 2025 01:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741570680; cv=fail; b=aM0/eY/GRp+GvHlxOoebgRFqRqtxx1HHrb+3c2kfsO4DMAdPvcHiXS9IBkdix2wApy8Xp004cgbJix13wYNAfeeqtnxCZ5zrJ8a33vhtKzJAh9RmA/xiU1Advz7K2N69E2YChgVqw9ynKCOvpx2ksLsba0jw7qL0IVeE+TZi+ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741570680; c=relaxed/simple;
	bh=cyaM0wiQM34Slv37j2BpWUGBSCF1i50CF/Uj87pNq94=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vh0J0QYlV4ToSV6GWm6FXYFXwxv6pEfoQ73y2Hll//CMuXCBalRWAo+dgJgY7+pMeXqvT6IGpiJSDyHhA3k/hf/fW4xTG3qOw+pp1bbaZbBwfRCFa3k1oPAruUOWNFg6rQ9u+Gt8MYo2hR9N+dfBHFwqIW5Ry6hEBgOH4hm4jNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hdDdi7m8; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hdDdi7m8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741570678; x=1773106678;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cyaM0wiQM34Slv37j2BpWUGBSCF1i50CF/Uj87pNq94=;
  b=hdDdi7m8zjWH0E2+W8lHSju8HpaEYD6qihNDKCfEVsh6tnkkEy+Zt0GO
   bthKItRVyP55D+KXDLHeYMO/12PnZj31ybVGV+5ZPj9zybwyfLPDr+wkZ
   9NavJLtaAvTzEZ4S+qWsYA9gUNurSoRZrYBUuGNb7uI+Jpk9ouswqEGeM
   78SCrkE2wnvlTEdV+Iq1JxIE437ckHMRwtAgx8mmUYxRTbQOvYHylOaDJ
   x3EDLCDp5zmxqWPL/3WEqFhGvsGt9xyVo2cPw97GkT8oNHdQ/kdmuWQOk
   AcN6sgJUn5gn4LqjgyvUU93ijYie/2wbCcZZ6u1hTr+klKbjn//AENv1n
   g==;
X-CSE-ConnectionGUID: Xh99GfKBQIajG629DWo6WQ==
X-CSE-MsgGUID: p++JCds+SiaMrBt7qmjPkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="60102548"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="60102548"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 18:37:57 -0700
X-CSE-ConnectionGUID: IeVUnDMxQVyH+Htk6WqNOw==
X-CSE-MsgGUID: 3CMsqEPyQ5uCZflr9fZJXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="120373537"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 18:37:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 9 Mar 2025 18:37:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 9 Mar 2025 18:37:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 9 Mar 2025 18:37:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnUMrIiQt4exAkmjDRPj2/lw1PrfKRXapH9lisEp5QLUno7UK7Lmj2hbn/vOzyQHX+F2ccXUmyMM323tO2FqR18UeKxmbaqTG2WAEQkycsguzmm2Gfo9P25UHObXZZfou/g+4e4o7P8/3bndTveNlNbIg8Qz3VjzpiUAQH+v5rlscL2BY+y14HjAQWmwCqkQAJwlVAkdrcyZYa0i7AXJIIDkuVdTR8Z1lU5zzBX5yiBadO4bqthElI4qJ98oQBpTYt2VjAz2NagkZJ34SZovKTc4+7pA4rSxOeWOULxO6r9dMPTEAN6gGOwsPNOAzMxZ67bWUaMvJWzNIcXmrHFqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyaM0wiQM34Slv37j2BpWUGBSCF1i50CF/Uj87pNq94=;
 b=T8UZ772cTpVZtEWL6v4YV1nihCDZRG7RGVZ/le6U+w+wcrKYC28QSDjKw1uoABfyPxFT+yVjc+O/YrC6XZyPd1JRI/TzzMFJIzCfBuI0R0VYoio9F0ba8WFiiu++W6RLd2NDEvG68w/m+ZcurFBT8Hrmu95dqnBcY3yK1j1R1evZQZldE/X6uTTBval+n7/YxxhpNbTloh1JkTzb88ZsKH5JM4AlZ2ykK1uu+c2eF42f6seGwQ68q2drJM1JOSDfc3BU7/sOvwKKX5v6DnMfDyvHLR+a2EBXpz6cM71OBJVXZK6zYAmPrRhJCbdMZSMHtyrun3L/JWhRNefo3Lzpqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8017.namprd11.prod.outlook.com (2603:10b6:8:115::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 01:37:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 01:37:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"vdronov@redhat.com" <vdronov@redhat.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is not
 enabled
Thread-Topic: [PATCH v2] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is not
 enabled
Thread-Index: AQHbkRf0K6BSg4x/uEaK4QGuVs2oTrNrl66A
Date: Mon, 10 Mar 2025 01:37:12 +0000
Message-ID: <c21c89d29f006945b6be7624599809b36574530e.camel@intel.com>
References: <20250309172215.21777-2-vdronov@redhat.com>
In-Reply-To: <20250309172215.21777-2-vdronov@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB8017:EE_
x-ms-office365-filtering-correlation-id: a96b5496-717b-4742-4668-08dd5f7414b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OVBvUG56dGJRb1o1WXRFYnpZekgvb0tnL016Wk5nM0NTcUJYS3NwV3d4dHF6?=
 =?utf-8?B?UGJPbVpqRXZFNDNyS2JiOG83Vk5wa2xsalZ4cmRZVzFCdWtLUlhSOWgwMUgx?=
 =?utf-8?B?U2JaZnR4c2NYbkM2L05OdTczQlBCOWNYdUFjKzlKTGMrcklQTllyRDA2TDhF?=
 =?utf-8?B?eTBJbDJmK1FwZzFMQTZCZmVDRk04eisvTW1jb1ZwR2hVZVNzZmJiV2Y4eWt6?=
 =?utf-8?B?OSttNVltK3IrNFdMVmErWjZ3Zzk4M0w0U1l1UG5tWnMwK3RuM3FEVnFuUm5Q?=
 =?utf-8?B?UjZHMkt3OXBjS0FYck91d3B2emIyck5vZUtUeGNzM2huSkJaMXFYNFFPRDNv?=
 =?utf-8?B?M3ZIQXExVWdNN0RwRXVFQXMyMThvZFBQbHFxNlJlRDJtVkNZMlZ6Zk1FaWpJ?=
 =?utf-8?B?VVFyWEhNb1JYaFFaMnZiUW5ZckRoUlNkNm9hNmY0RlpsZDNVWlVubHEzZHVi?=
 =?utf-8?B?bFo1OFBYQnhYNnFTS3JwamhmdzZ5TlFvdzlkeDVpb09ob2ZqdDlKVE52RGZ2?=
 =?utf-8?B?bnVsK3dBS2VQc0diaExtc3ovOTBWZUhvSkMvM3kreXNwME1CUkVUQmx4MjVB?=
 =?utf-8?B?YTZBZ0VJVk9RZnl0Yy80YU5oODA1YWtRcWdKSi82Q0FiSjE3Y1pKN1ZETE03?=
 =?utf-8?B?Y2ozdVhMMlkyQ3hMRnNyUTE2RkZLdW42RVdwSlBrU0k4SStLMW9pSmUrWTdw?=
 =?utf-8?B?QU9iMXVmbUdlY3BvRHVqOXZ2ZWV6bjluZzRCMmw4VlpWQTJCWnZ0M3ZVWHQ2?=
 =?utf-8?B?R1lEQVFKRzRIcXBCQVF6a0dLalcyTlRHWkZlOUcrZ0srY0NTemlhZ1ZNSnpa?=
 =?utf-8?B?akNjWXhnYWF5UUVXSEl4KytmeWF5RXNKc2VCSGxtcDJLL3VaamU0UVFIczQx?=
 =?utf-8?B?LzM3NmZuMlJVN2ZmTldyVU82Y205SVNZTVRTc3hjN0lFRDBSZzFXL0M3VFFY?=
 =?utf-8?B?TU04MmhTZlJvbXQ3QmJseVhkcEl1U3dyMHpuS3VZMk94TGhiQS9ZYTRXeHBw?=
 =?utf-8?B?RmhGRVdRZFp5bXNSTUhJa1VudU9tcjF3dUhHTFJJTWNhUWU5eEtXTnZ5UlRz?=
 =?utf-8?B?eno3SU4zTXZWK1lBRHFxQXRoNnRuNVcxVnRQNlJJVy8va1BDZVJYbVljdWRa?=
 =?utf-8?B?RXlsdTJva2RPKzZBc3Z2K3NVcW1xL1puTVNtUkFXWFBaWTNCUjFYOWowVkFz?=
 =?utf-8?B?cERhM0Z3bHU1cXRiWklRNTZUMkI1a0pTUTNqL2lRU2VRZEJDMStqZUZQWG9C?=
 =?utf-8?B?NlFjSFNBaW5KMkdPeG1TRTlRNXdPWE1wd1RobWR1UmNFak5LVHF2MzkvbU4w?=
 =?utf-8?B?VDVGUm9wc09GMXhaMDk0VGU4enNORytnMWNQTnQzcnNMeGVLWWRGamg3VzZJ?=
 =?utf-8?B?YS96b1pxcS9nQTVzMENLNHJUZzRwRUJUc3EwekRSUm5yRTZEV0VxSWY0REhK?=
 =?utf-8?B?TDdMWlhWcGdIeW1FamU0R1U5TExTTTNwdk9rUW41UnZkb2Nmc2F5VjNFQ1dh?=
 =?utf-8?B?YStUa21IbTZJQUwyQUJPMi93amRVUUpTQ0J2RVlJVjQwMENGc0F6TGswUnJ6?=
 =?utf-8?B?bzRsdVVMYXZiTDZZenVmLzJtQzh4K0ZodkJ4ckJDa1JzMFBkLzJJaVg3MUIy?=
 =?utf-8?B?Y1NsdUhTbDcrTTJ0SEJBMVNvNjkycW5ZMWo4Y2hYaU0rMFN5aExoKzU5TFlD?=
 =?utf-8?B?TFJrdWIyN0dNc3R3UDc5SmR1dDg2MFdCMUQxQm5xK21takJRMlhXUk5PWkxh?=
 =?utf-8?B?eEUyc2JxYTlxZjZKVlQ5THhwWG1VeU1mbUtMYWQ4cGN4VS8wNUVlZWpwcEFx?=
 =?utf-8?B?NXptbVZENU9aa1FIMHJrTnh2b3R2TXkyTEtjSTdmT3UxaFpDM2pwQUV6UUt4?=
 =?utf-8?B?TWJhT3lZM0cySDRRQWlMQURQQ0s5SmZyOE81VC8rNVlpODNXVjZxbzJ1MGZt?=
 =?utf-8?B?eGgwSXlBdGJVUFZjYTBKZHNkdGVTNzE0M2dzbm1vK3M5b0JmMml2K05vSmRx?=
 =?utf-8?B?cEh5NmZGeVh3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YitVMUovZi9aTHdqcE5aQzhaMEErZmljbmluSml1YURGZDhmQjVJVGYycS82?=
 =?utf-8?B?eDdXYitTUXFjclZmbzdNdjBieXJGa2h1Umh5V3dkdFlyQ0xJdUluZFV2cTBt?=
 =?utf-8?B?dkxaVk41LytQbHBPR0xIWkI4czZOaVhoV1hVMzFENENVeE9zUE1QZmM3Rit3?=
 =?utf-8?B?Z3B2b0k3M2lhL05nbGRIcE9LTjQwK3pjaXlHa1pDKzhnK0FZUXpRaE41TERr?=
 =?utf-8?B?REovZWlmSzFnVDVjMm1rNHdodVFlZTRiTk5kYU42TXB0L0l2VGg1SXc2UlVk?=
 =?utf-8?B?UFJuQjVJRmM0RmdXVGRJZUlxUmdTVld0WkRiRWVGd0VDTDNFZURNNTcrRmVW?=
 =?utf-8?B?Ly9Ya3BsNEJsS293ZzBqdnNXNis3T0YxYVVZaUFpTFI4anhxR2hXeFU5Lzkx?=
 =?utf-8?B?S1FOYU1YeUhQVTh2UmFkdzZFYlhxRTZPbGwxdDFYTE5CNDNoSm5KaGM1VHAy?=
 =?utf-8?B?eHYvZHRqYUNRRGpEenRmb3dNWE44MGgxZlF3dUpWNXN2T2dGUHdlejd0aFhL?=
 =?utf-8?B?ZTZ2QUdiQW8wdDJCeUo4aHhZVjNPRzlIRzlqdldjTmR1a1p2aTNzSURRMFBK?=
 =?utf-8?B?eG1WbmtabVRKd3dUdS9MYURQSjBDSzh3T01hVE9oZG9WdW13RUpOem5rbXRE?=
 =?utf-8?B?UEIwbmZFY3N0QmtNNktQbm1wMmFkNDBFdENYT2xBZ3NtcnZnck9RaStPU3Rh?=
 =?utf-8?B?MDJ0dEYyYjNKSXo3V2hnQW9xL1Q2alJZdzhrNlcxZ3Ixd0l6YWpPYVRMNnJp?=
 =?utf-8?B?ZHRGRlN0b044SVp3dCtCVGNOTkxGLytVOVJ1b1YrZFhNSG8zMXphQUM2LzVP?=
 =?utf-8?B?M3dsMG9lZjF5TlpteFdHeER2OFZMMTczYUgyU1VFZ0M3aDBsRlpZaXNyWGY3?=
 =?utf-8?B?cWRFV0JyU1lwdmx0SEcrMVdpbXkrYlhFV25zYURFVWFIZzBDL1p3YS90STNZ?=
 =?utf-8?B?ODJWa2JFeWhiWTlWa3FNK2QvMDhJOWFpek11SThvVFhRL0daNHVLdlJFL2dI?=
 =?utf-8?B?dXVhSnhLaDFpMlFBZWNGa2xadjVKbThuVmpGUlJ5ZkF3cUUzOTJiZExpOVpY?=
 =?utf-8?B?YVFuZ2huUktsaWJ4UEFLb0FGYWx3TXFPVy92QStLSU1GRlk5R0ExakkwL1Jp?=
 =?utf-8?B?My85cG5SOTBEVTczbDhLZHdTZ0VuNTJ1UG1FZitqZzJneHBERC8rZWFGWjhB?=
 =?utf-8?B?eFY3ZE5mV3dXVkIvTkRKcHpneFlEWURvZk5MRkV2VlUwZGtSNWdJWWRNSlFK?=
 =?utf-8?B?azJNVnN5SWFhVUlMTzAyeXovS2RFSHkweVZpQTZKczZ1OWxncVBlZjBZN3Jo?=
 =?utf-8?B?bVUwelVOZGtrRXEyNXZETFRib3I1ZUdXdCtTaWpTcjZRSFJ1NXRYb0ovdDM2?=
 =?utf-8?B?WGRmQ0R0U3ZYWDBYSlZoUjVmZU92bGpXK3lVQnoyNkR3UkFFSUkwYkcycUpZ?=
 =?utf-8?B?NzV3UEVmZDRwQ01kTFNxNlZjODBEeEswSG9oMVBIQVFHSTZTTjNNOTJpbFNT?=
 =?utf-8?B?c01BRjhkL2hIbEZlUm1JSkEzMnBmOXVTakwweG9HTTl1TUEyeVdBdEZ4V1Ji?=
 =?utf-8?B?cjJaRno2U0FVUEQvcy92U1pyejVoa1JraDhVYVUrR3lYb0NpWTB2T1VicCs4?=
 =?utf-8?B?Ynp0UFlLZXlXRjd5VGVpeUJnVjhoYWRsYkF5Y1Z4b1hYZDJjcDA5aXNUSlhz?=
 =?utf-8?B?elByYnphRkd5ZXViWUowcUtOdVJCOTkwWjZ4T1dua0lJWndEUDBtQkJlMWx1?=
 =?utf-8?B?Rm1rakhLaWZjVmFSZkIvdzY0ODljU005cjZvTTV0cVNsK1JlTDRXVUpzNUV4?=
 =?utf-8?B?OFpGRmE4cVNRc2RxZWdRMUdLb21HSzF2aDVISS9qenJxRUdVVXF4ZFZMeHR3?=
 =?utf-8?B?N0Ura1Rpbm4vdUhUeUVYSHR2bk1HazBlaVBwWjRRRUFUU1RFU2gwOHo5ekwv?=
 =?utf-8?B?aVpJR0ZLQ1pYb0pIMFlrcEkrbUNMNk1OMXI3aDdTVG45TEFDR2JFQlo3bU1r?=
 =?utf-8?B?YnlYSUErNGU1N3N4dStEYUNoK2tJVDQzS21seUhhTkI0MUc5ejVzZ01uN0xT?=
 =?utf-8?B?dllZM0o0RDJ3bjk0NlloTk5rbDB2YUYwKzM2MFpyLzlVTjdsNVF3S2lLOGZu?=
 =?utf-8?Q?zU7jEACA1lI8VV8PVFD2gIv6B?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E50DDF21B9BBF4982F71A30B9D04B0B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96b5496-717b-4742-4668-08dd5f7414b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2025 01:37:12.4646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AjqEzdEhABr4AOmscnbLVqzOr9Z5WLaKlD8ii6963FjLqkXVWn4MOZm+hB/jh8ShGo+K+yFnhUtxVdDK+E+/XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8017
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI1LTAzLTA5IGF0IDE4OjIyICswMTAwLCBWbGFkaXMgRHJvbm92IHdyb3RlOg0K
PiBBIGtlcm5lbCByZXF1aXJlcyBYODZfRkVBVFVSRV9TR1hfTEMgdG8gYmUgYWJsZSB0byBjcmVh
dGUgU0dYIGVuY2xhdmVzLg0KDQpUaGUga2VybmVsIHJlcXVpcmVzIC4uLg0KDQo+IFRoZXJlIGlz
IHF1aXRlIGEgbnVtYmVyIG9mIGhhcmR3YXJlIHdoaWNoIGhhcyBYODZfRkVBVFVSRV9TR1ggYnV0
IG5vdA0KPiBYODZfRkVBVFVSRV9TR1hfTEMuIEEga2VybmVsIHJ1bm5pbmcgb24gc3VjaCBhIGhh
cmR3YXJlIGRvZXMgbm90IGNyZWF0ZQ0KPiAvZGV2L3NneF9lbmNsYXZlIGZpbGUgc2lsZW50bHku
IEV4cGxpY2l0bHkgd2FybiBpZiBYODZfRkVBVFVSRV9TR1hfTEMNCj4gaXMgbm90IGVuYWJsZWQg
dG8gcHJvcGVybHkgbm9maXR5IGEgdXNlciBhYm91dCB0aGlzIGNvbmRpdGlvbi4NCgkJCSAgICAg
Xg0KCQkJICAgICBub3RpZnkNCg0KQW5kIEkgZG9uJ3QgdGhpbmsgIm5vdGlmeSIgaXMgY29ycmVj
dCBiZWNhdXNlIHRoZSByZWFsaXR5IGlzIHRoZSBrZXJuZWwgb25seQ0KcHJpbnRzIHNvbWUgZXJy
b3IgbWVzc2FnZSBzbyB0aGF0IHRoZSB1c2VyIGNhbiBjaGVjayBhbmQgc2VlIHdoZW4gaXQgd2Fu
dHMuDQoNCkhvdyBhYm91dDoNCg0KRXhwbGljaXRseSBwcmludCBlcnJvciBtZXNzYWdlIGlmIFg4
Nl9GRUFUVVJFX1NHWF9MQyBpcyBub3QgcHJlc2VudCBzbyB0aGF0IHRoZQ0KdXNlcnMgY2FuIGJl
IGF3YXJlIG9mIHRoaXMgY29uZGl0aW9uIHdoaWNoIHJlc3VsdHMgaW4gU0dYIGRyaXZlciBiZWlu
ZyBkaXNhYmxlZC4NCg0KPiANCj4gVGhlIFg4Nl9GRUFUVVJFX1NHWF9MQyBpcyBhIENQVSBmZWF0
dXJlIHRoYXQgZW5hYmxlcyBMRSBoYXNoIE1TUnMgdG8gYmUNCj4gd3JpdGFibGUgd2hlbiBydW5u
aW5nIG5hdGl2ZSBlbmNsYXZlcywgaS5lLiB1c2luZyBhIGN1c3RvbSByb290IGtleSByYXRoZXIN
Cj4gdGhhbiB0aGUgSW50ZWwgcHJvcHJpZXRhcnkga2V5IGZvciBlbmNsYXZlIHNpZ25pbmcuDQoN
ClVzaW5nICJyb290IGtleSIgY2FuIGJlIGNvbnRyb3ZlcnNpYWwuICBMZXQncyBqdXN0IHNheSAi
a2V5IiBpbnN0ZWFkLg0KDQpBbmQgdGhlIFg4Nl9GRUFUVVJFX1NHWF9MQyBmZWF0dXJlIGl0c2Vs
ZiBkb2Vzbid0IGF1dG9tYXRpY2FsbHkgZW5hYmxlIExFIE1TUnMNCnRvIGJlIHdyaXRhYmxlLiAg
V2Ugc3RpbGwgbmVlZCB0byBvcHQtaW4gaW4gdGhlICdmZWF0dXJlIGNvbnRyb2wnIE1TUi4NCg0K
SG93IGFib3V0Og0KDQpUaGUgWDg2X0ZFQVRVUkVfU0dYX0xDLCBhLmsuYS4gU0dYIExhdW5jaCBD
b250cm9sLCBpcyBhIENQVSBmZWF0dXJlIHRoYXQgZW5hYmxlcw0KTEUgKExhdW5jaCBFbmNsYXZl
KSBoYXNoIE1TUnMgdG8gYmUgd3JpdGFibGUgKHdpdGggYWRkaXRpb25hbCBvcHQtaW4gcmVxdWly
ZWQgaW4NCnRoZSAnZmVhdHVyZSBjb250cm9sJyBNU1IpIHdoZW4gcnVubmluZyBlbmNsYXZlcywg
aS5lLiwgdXNpbmcgYSBjdXN0b20ga2V5DQpyYXRoZXIgdGhhbiB0aGUgSW50ZWwgcHJvcHJpZXRh
cnkga2V5IGZvciBlbmNsYXZlIHNpZ25pbmcuDQoNCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVmxh
ZGlzIERyb25vdiA8dmRyb25vdkByZWRoYXQuY29tPg0KDQpJIHRoaW5rIHRoaXMgbWVzc2FnZSB3
aWxsIGJlIHVzZWZ1bCBmb3Igc29tZW9uZSB3aG8ga25vd3MgU0dYIGluIGdlbmVyYWwgYnV0DQpk
b2Vzbid0IGtub3cgdGhhdCBMaW51eCBTR1ggZHJpdmVyIHJlcXVpcmVzIHRoZSBMRSBNU1JzIHRv
IGJlIHdyaXRhYmxlLCB0aHVzDQpyZXF1aXJlcyB0aGUgQ1BVIHN1cHBvcnRzIFNHWF9MQyBmZWF0
dXJlIGJpdC4NCg0KV2l0aCB0aGUgYWJvdmUgYWRkcmVzc2VkLCBmZWVsIGZyZWUgdG8gYWRkOg0K
DQpBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAN
Cj4gYW4gb3V0LW9mLWNvbW1pdC1tZXNzYWdlIG5vdGU6DQo+IA0KPiBJJ3ZlIGhpdCB0aGlzIGlz
c3VlIG15c2VsZiBhbmQgaGF2ZSBzcGVudCBzb21lIHRpbWUgcmVzZWFyY2hpbmcgd2hlcmUgaXMN
Cj4gbXkgL2Rldi9zZ3hfZW5jbGF2ZSBmaWxlIG9uIGFuIFNHWC1lbmFibGVkIGhhcmR3YXJlLCBz
byB0aGlzIGlzIGEgYml0DQo+IHBlcnNvbmFsLg0KPiANCj4gTGlua3MgcmVsYXRlZDoNCj4gaHR0
cHM6Ly9naXRodWIuY29tL2ludGVsL2xpbnV4LXNneC9pc3N1ZXMvODM3DQo+IGh0dHBzOi8vcGF0
Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9wbGF0Zm9ybS1kcml2ZXIteDg2L3BhdGNoLzIwMTgw
ODI3MTg1NTA3LjE3MDg3LTMtamFya2tvLnNha2tpbmVuQGxpbnV4LmludGVsLmNvbS8NCj4gDQo+
ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9kcml2ZXIuYyB8IDQgKysrLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9z
Z3gvZHJpdmVyLmMNCj4gaW5kZXggMjJiNjVhNWY1ZWM2Li5kZjRmYmZhYTY2MTYgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+ICsrKyBiL2FyY2gveDg2
L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+IEBAIC0xNTAsOCArMTUwLDEwIEBAIGludCBfX2lu
aXQgc2d4X2Rydl9pbml0KHZvaWQpDQo+ICAJdTY0IHhmcm1fbWFzazsNCj4gIAlpbnQgcmV0Ow0K
PiAgDQo+IC0JaWYgKCFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1NHWF9MQykpDQo+
ICsJaWYgKCFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1NHWF9MQykpIHsNCj4gKwkJ
cHJfZXJyKCJTR1ggZGlzYWJsZWQ6IFNHWCBsYXVuY2ggY29udHJvbCBpcyBub3QgYXZhaWxhYmxl
LlxuIik7DQo+ICAJCXJldHVybiAtRU5PREVWOw0KPiArCX0NCj4gIA0KPiAgCWNwdWlkX2NvdW50
KFNHWF9DUFVJRCwgMCwgJmVheCwgJmVieCwgJmVjeCwgJmVkeCk7DQo+ICANCg0K
