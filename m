Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674D730C602;
	Fri, 23 Jan 2026 07:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769155113; cv=fail; b=FxYiZYsANEEdxUT3KW4ziKMULC1Qyp2MVgeWbmkcSQ2cd0xj9WRwSq/vB30mkXf5NiB9mAqpbP+VIoVtxBBI9ry+505tR+NnkiXLL/VhJxRuWGjEPuAgJaEbMsnC3tRALyHZ6kR80+D7IuPt2ful48RIazJW6dog71cVCovJM24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769155113; c=relaxed/simple;
	bh=nl2l9O8tI2VYkTgzBDaFsbK4QVMUIaeLH+pWv+WsUMQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EvdQJ1+eXhO9SbCxiYH37YZjCilJLcV1or079C0ZWHu9gMVGUDdAmNoIaku3VNKuI6LTmO32cVV4vjsaJ0Lq39PK+kby0bOnP1bXr7LmqiTHsqOt+wrnKKFvtwD0pmOItDOcRoRNAmBtJ/TA2MrN5ss5AJ1H+uDOrddLfj82hhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=af9cZdGj; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="af9cZdGj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769155112; x=1800691112;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nl2l9O8tI2VYkTgzBDaFsbK4QVMUIaeLH+pWv+WsUMQ=;
  b=af9cZdGjqgxRs3LmdTFJ1qsiSaxov3MR3sqBdgQx4wjXmjK1FsQRai1m
   9gkI14WXlFsg2CUaaBdJ2YN7Q8caHi05ZjZQlnY2fbkGqH8sLMzLSopm1
   ZgS4Q/yM9HNVfPhqE3ZxA14Z52C+YRsozA1r22zkYvhE/0kOlbJemcIlp
   78Kmihc9VIS/W7YeqQhK773uVp/9RIRGbSlk0frNt7uY0CxVr3zCuY+GB
   A/9Hb9kav92j02/ReAnsaXBIsmvPNLUCdwJ8uslX9flae2TR2Kzu77Sf5
   /ZH4hBVYu2CVWnS2r0WSNYq96RDRfzKbdA3Y7pfAcx0uh54rEIT/BeqSU
   w==;
X-CSE-ConnectionGUID: Sj40OmkaTfy/X7J7chdD7A==
X-CSE-MsgGUID: KuzpHawJQIqflaQq4StRLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="80711706"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="80711706"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 23:58:32 -0800
X-CSE-ConnectionGUID: Uxuoj9duRLyWuTJTAUyw7A==
X-CSE-MsgGUID: uncsNV8+TqqGojwfwdhkmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="211830314"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 23:58:31 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 23:58:31 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 22 Jan 2026 23:58:31 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.57) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 23:58:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EGxJMOve/7d5XoTiN3G3ype/Enp1GocgKzhnPSkxvLy/mYKmFlwdoD7lLYkKKOwt7PrcRCjLHIuq6L8NtXfrxezu7l1U+XnBfQmkvX3Pf1L5l9uJP5X3aKYTtsg/oap0KpeGaf9GLFbbAB1ufGsNcncDtBN1aUhkmDT0ecXqJlQINAkj0wfrX7P38nO5pwqMZDhS0gFKTQ5FLGQAgXdoKzmeXk5sKEEn8yNX0jAZHlgsNX/vDeIBc7C3L5PrnLLUEN2x92n/vo+AaKrULNZRGNVmP5itF3iDxzYchDl44dMbKpcK/t4lWfN7ljwvMukt6HX+EDSSl3LoGFgYfWR9bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nl2l9O8tI2VYkTgzBDaFsbK4QVMUIaeLH+pWv+WsUMQ=;
 b=rZERxtyar/TzvkIA4cypHu7y2RViLtHy9F20YYAnywy2RQQw7+hsiVGeQMC8LW6Wrk2dzOsAQ5e6mwufdUniGrV4nf5ZMCZHfm8m11XDY/uxlO/p86f70JbEUg+YR46va6GOrdw9/8GDIE/Wg21sUGrfkm20f9OTCXr58g5GgJIu5gDLRbxiz6dTehE/6NJWQRuxVCokclFtRK/0QONTtpp+cK5JS94bbfyOyT4669RQUrBJ8WuuU9zyV4hQMSXspIrqfwP4KJNyGWCEp7ZQlvZtwBQOytsnyrbwDehPoZTIElpTBxT+nmWNcoGLyLEuchU3y9qVA8iSQHgqOVUt7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA0PR11MB8397.namprd11.prod.outlook.com (2603:10b6:208:48b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 07:58:28 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 07:58:27 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tianwentong2000@gmail.com" <tianwentong2000@gmail.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>
Subject: Re: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Thread-Topic: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Thread-Index: AQHci6Q5tvQw1foINE2mfXMlwjgvW7Veq/4AgACeOoCAABqXgA==
Date: Fri, 23 Jan 2026 07:58:27 +0000
Message-ID: <2c33338d030f086d490f6e8e8d02667ff37143ec.camel@intel.com>
References: <20260122133633.79792-1-tianwentong2000@gmail.com>
	 <5961c2655b49a7d384140c33d6897e53f89cb5fe.camel@intel.com>
	 <CAGPELS7JdxTY5hthmTyU_yDxdG7xR2k0hoA1ZqV_Lj+8LEkO2w@mail.gmail.com>
In-Reply-To: <CAGPELS7JdxTY5hthmTyU_yDxdG7xR2k0hoA1ZqV_Lj+8LEkO2w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA0PR11MB8397:EE_
x-ms-office365-filtering-correlation-id: 258ab965-9019-48d4-3f52-08de5a553131
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?elNGY3B5SEJ5TDl4cExVR04rZG5aYzg3UUdtT1NmUkk4NitSQVM5S3luYnR3?=
 =?utf-8?B?a0ZCdkQyNjJOM0lWUVlESEF0TUhGY3RlUlg1L2ZNVEFKOHJMTFU4U2xLMzI1?=
 =?utf-8?B?VWp2dnlCNkN2bjZWalNQUE5ES3daNEZxNmxTSGJJaDJ6QTNVenRkMGJ1TTVp?=
 =?utf-8?B?Y1pFNHRDQWNGM3RIeWo2ZXdVUjZLa1cyNjZ0Y042VjBpS2hvOWhmV1dub3pq?=
 =?utf-8?B?S1ljTHJVZTVNNkRGUS83VHhRaTgwYTFER1dnMUJzUHVFN1NuQkhTclFHK1Qr?=
 =?utf-8?B?bm5RZWYwdEk5MHBMM3dHRUs1UVRvRXhqZXRQdnFnQWpGU2I4RWgrR2JmTFJX?=
 =?utf-8?B?ZlFGb1NEUDBweTY1aXZ5d1djcHRYSStoREdKNDNiVE05dUdsanJBa1R1OGxC?=
 =?utf-8?B?cnpsR0IvUzlTQ2lUT3NFOFFCY0JMeVpmUFc3MjJCQzRyVGhmS0ppeDEwNUR1?=
 =?utf-8?B?NUZJK0VRKzlSaWFvUGQ1WkRvc1M3RmgrVnZXWTl6SWxnVElPQkpFSTJpY0Ny?=
 =?utf-8?B?SFZwbVptOWM5VWNyMHNKMmp5b2xKdzFwdllWdEQyMVZjQ2lXUVdaTnZxVnBk?=
 =?utf-8?B?b2dBS0ZDSkJjZ3lDSklQdGFCc0hBajVYRFhKbkxDNkVOWUZ4QzlUS1FaM1ht?=
 =?utf-8?B?dlNtQ0tGOTBTVGlhNEdJYmNkR2RCeG1VV0ZBUC80dzRuZ1Y5UC9MS3Y5b2d0?=
 =?utf-8?B?eHpZbDBTMnBuOG5wMTFMTkVxZlQ3QlN4cTdyM3BTOWdCNHUwRG9UVHNFaUY1?=
 =?utf-8?B?Y2hUQmdzUWluTm5jNlJLbTNIVFMzOU42bWxtVGhFNUZRYWkrZEVoY3ZBZzhQ?=
 =?utf-8?B?ZUNlc0ttZ0NKY0pibmZQQ0wyVUdJQXBkRnRuUGdxbG5uNmV4N3M5MkRIbExU?=
 =?utf-8?B?NGdSQk13YnZtWjh5eVk4alk1SVJSTnhyenFxUGpZcnBTd2VLSEF2dER2Nytu?=
 =?utf-8?B?VUNOZ0hoQ2dSZS9qQjRqQ3RzUVRZWnZJUEhOK2NRdlpUalM0VmVKb3FsN1Zr?=
 =?utf-8?B?clRCMFljSkpMTGZKbWt3SlVTbzhUbUhzSzM5ckkxVjh1ZFpJZG1uWENoRlBL?=
 =?utf-8?B?REhBSklPK2JDb3JJdFkxQzNpT3hlcFBXL2k3U2dvYUZHaDVOa2NXYlQyRS92?=
 =?utf-8?B?U1RCWHJOVURkOXkwM1ZtcWtuMWtQY3VPeTNkV2ZKZ1ltUFZkdlVDZThyV1U2?=
 =?utf-8?B?WkZDSU5QWVpETHZ4N0tWa1haNnlCdGpyUmliSTd3NzFWZVNkYWpMUDFOK0t6?=
 =?utf-8?B?bUpsQ242My9zUE41RDdKdVJYQ2wvZXhpMm9mN2hsWU1OR245QUoxQnhFNlBa?=
 =?utf-8?B?Q1pZUStHREU0bXJuSFcvL0ppZ21XZ0toSGpHU2lpWDJVTEFyNndVMERwdEhH?=
 =?utf-8?B?MG1xNlJSdFpyTXBzK0VET05kcHNHMWRZWHIrMDJkYXFGNTJOUERNKzVnTDc5?=
 =?utf-8?B?TXlLbWpwdVV6UlB1SWFsaENzWUlDR0RQQzRib2FIWlEwVFQ4cW16M0YyeUJq?=
 =?utf-8?B?MFBuVzRxS2RjMTBmS3pENzFIcmpXL2NWUW92eGdQRTlZQitnYlB3U0NlY0FZ?=
 =?utf-8?B?SW9rc00zRnIrdG0yMXE5a1hmR0lSN3dXQ3JYTU5wNU55WUg0ZENzMGNXWlNC?=
 =?utf-8?B?bC9OQWV2bWtQQ1gwakhzUGxTb3VaRnVyaWl6VkZadGUzTmFaWks4OHBJK1Vw?=
 =?utf-8?B?NERtY3J2dzl6dWpGcjlNY0o1WlhZNElCUDNJYXZudXBKam9Ud2tjc2dUVTJS?=
 =?utf-8?B?ZkE5RjYzSEEzZkdUdUtJT0VKMmJvQTdVRWpjZDErYjgzMXBrZEwrVnV4OGpL?=
 =?utf-8?B?d3NKWEJpZHVDYVRyMnFmbmtUOS9weGV5ZjluM0dDN3VZcGlZSWQ3NGxrNWdK?=
 =?utf-8?B?M1czeEhSVjFpVTRialdoTXhtVHdOZkxYVWhPdEhLVGp0QzcyMGNrQ1lFcEFG?=
 =?utf-8?B?WGVNYkVCK2s3NDlrWGJQa2o5cnNZMlJrL0s4V3JFK0U3c2taMGs0enppMUJD?=
 =?utf-8?B?eXY1ZVpwTDBrQVZGM2FMSEF4emJrd1hxSTA4MVRSdWpIbkYwZEZwTUx5MHdB?=
 =?utf-8?B?TjcvRWNrODhyenhENzRRVVB0dHlKbVlHVW5RT1VISERNemlBMnMyTS80R09z?=
 =?utf-8?B?V3RrcXVKaC91Z0lmWjJSSE1WdWZCWVlpaU5tdjVXaUR0YmtnMUs1R3dnYkc1?=
 =?utf-8?Q?o8zGkm3FYSWXnXseEu/uOgk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGNSNG1FbWJjcS9aUmJXSk5TREhwNVhRYkpRNnJ1UklVMXltUWZBM0ZacDdZ?=
 =?utf-8?B?eU53eU1xZW1CZzZUZHBzSFJsczFOY1AzQ3F5dWo0S1lNVHRabFRFMTExVzFW?=
 =?utf-8?B?QjF2eHNTejFlcmtiQXI3aFkvaUppVi96VlE5TTFOTGl4cm4wQ1BNWkRaeE5v?=
 =?utf-8?B?cS85cW5TS3lVa0tZRlFNbnF5ZTd3WUc3blFMeThmQmZ1aWtJT3JZS2pVNXJT?=
 =?utf-8?B?NlRiaGtmWWxobWx0dXppUWU0VGV4ditlNE5qaWtmR1hFWkdwdHdzN2IvLzNw?=
 =?utf-8?B?eGthQVBIYU5SOHViNVhmaThVSEhwaXVqSVQxWTJmS2RUaUpjMzFYSk1Sb2hr?=
 =?utf-8?B?eVpkRm0vVW5IWCtLbFZrT3huaCtjWEpJUlp1b2NzTVlGQmFZWUZ0ZTVRWVJn?=
 =?utf-8?B?MkpJNWRsYzRUL3FmRTVieTBNK3hkV0lzZnpwV29NblR1OVJBaWZCNHR1Mjht?=
 =?utf-8?B?TnlwTm0yNWhXaUlZdkd6ejlra2NGME0yYTRMS0I1SzIwQzc1ZnVPQW5MNWps?=
 =?utf-8?B?M21JUVRvMlAvaUlzMUY4N3V2Z2ZQYVRUNmRsTTBnRnFIdUxRb1Iyc1k4UFZv?=
 =?utf-8?B?RHZOSXdoRG11Q2NEV2ZqenRZa0F4SWpPQThoU3hWUTJiOUtkUUREQU42Y2dP?=
 =?utf-8?B?dnRpZUFFZkRGY2tjYVVleFp2Y3FWOVYzY0lUMFNEK2l2VjU2SnNBL2pUTi9T?=
 =?utf-8?B?cWZ0MUovZmY1YzVqM3VQVk8xZ1RITDl5VmcrUnVYa3loWlQxSmNFaE5jcFpP?=
 =?utf-8?B?eHdHVHBaVzBscEUyYklBWGNycHBvdDVUeEEzbGlqSndJSG5oa1dUeTFuaWtC?=
 =?utf-8?B?MFM3S1hqMXcxSTl2a2hTQjR1WmZxbkZ5QSsvSEN0dFBnOFRhRWp5Q0lxYjg5?=
 =?utf-8?B?eDRsbUwvMUp4b1NsUFpOamExUGU0dFErNDhMTkZOenE5Zjd6SVQ3QklIUVBl?=
 =?utf-8?B?VHhndzVQcGJEdmIrV2Y1S2UwNHlOZlVINEEwakdGRjBuOCt2MUtxL1hld2J1?=
 =?utf-8?B?QWtMRUoxdnZYRTk5TTQwdHJjL1ZOQkVLNWY2TWhSV3kvQ3c1a1JHTGRFYnVD?=
 =?utf-8?B?bjZMQmtlSzFSR1VCMUxlQ3hyY3h5TUpMcW9Qbnpock5CNTJxb2tFSlZLb3ZB?=
 =?utf-8?B?OUdDZk1jcW1ydXMxOTVNcUZpSDAwWHRMeG5NcHcycVdmcWN1UGdTdXVPUnVx?=
 =?utf-8?B?KzZsc0hHZ3lQc3ZTbXMySUZWR3M5cWhpV0RxODY2MFdhWmZTcXNJTmRLUkxT?=
 =?utf-8?B?Vy94OU5RSVNHcW9LZEFxSkh1QkQwaHNweXJrRy81SENldEhGUHJpZnZJK0JM?=
 =?utf-8?B?b3pqRGpRRXg1YTVHbGMxLzR4SWFMMFpqSmZCSjh6TFdZbXBhM3FEVXNYQ3pW?=
 =?utf-8?B?K0xqaG9ycmZia3JiRW1EbjRGVDlDeFdiRUJSU1NtUDh6eDZBRTNjUXF1OGEx?=
 =?utf-8?B?Si9hV01oTzFuRiswZk5yZTZCQTJuWCtST0ZNTlNTYnpvbmRESVJGdWZCekE1?=
 =?utf-8?B?SzJrbzRpZ01Ca0k4NG8wWGVCa0REZk9QQm13N3F2c2s4VEdlQldpeXFaSGRW?=
 =?utf-8?B?dGZodHlQMm1ZR0NFMTRtL0cvdG9VRFZ4Zk9Pa0VYNEc3T2JTdkhJdDZrQmpW?=
 =?utf-8?B?S2RBMGE0azFxSTVudG5obWJweE1ZR0tPNHVjSm9HQUtnbzhMQ2FNVTFkWStJ?=
 =?utf-8?B?T28zUzlEN0ZpcEdpUHArWm52UjYvenRaUkdUbzJncDRwSzVNcUV1UUtRd0d1?=
 =?utf-8?B?YSs2VFVlOE9uMU1JZlJMejRBVCtOaTE4ODNCSmc3K1ZBemZIUkEyMDc4Wkp1?=
 =?utf-8?B?OGJyMklGdnZVUC9ZM1duK1pZa2NuTzNKcTVmbDlWQkxNSWVNVWlxT3JpQWlO?=
 =?utf-8?B?LzY2aTlVczdyVGgrQlVBaloxTlRiQ0JTZ0l2ZDJrU09BS3JucDNZdzhxdnVz?=
 =?utf-8?B?VGQ1ZlloVlNnT1l1S3BpTHBEZWE4S0VZS09vZDVvc2xKdEVhdTJ5eGUxN0Qz?=
 =?utf-8?B?REdScVVzTjNpWkcrOEhaU3dseXJlMUNaRnZROGY0bWNTMEg0c2F0dEZjbkd6?=
 =?utf-8?B?M1RLUGlwTUtwaFJURDFPRU5JVEFrL2JubHM1STcyd1M0T2s2amFieXRpWkUv?=
 =?utf-8?B?TTcwY0Y3UFNlTE81cWVFN3lIYktCRnRtU0h2aGRyV2VSeXliVHErQlpMRDYz?=
 =?utf-8?B?SzVDaDI2aGRxVTVML0J1UzlnYi9jdTFMeEZNeDBPS2QxZ3pYK1lYK28xRXkw?=
 =?utf-8?B?T0tid0pRdmZxaHZUUzAyZ1NMbVE2Q2dKdnQrM3FuVTlaWVFhR1RTdW04L3NB?=
 =?utf-8?B?Tit4akdYUEFpQ0xaclVwNkxJOS93dGZXb28wUnpDYXJBL3A0S05yQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B797CC073A86BD4B8C66283917818258@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258ab965-9019-48d4-3f52-08de5a553131
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2026 07:58:27.6567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LB8WtVGwT9ZYA6sVvkuJ21CWxyDMw5aj2jfhev5j7GFTab0z84OC/BJTE3c0OHIpJHz7JCP/ZiQ911drf97ToA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8397
X-OriginatorOrg: intel.com

DQo+ID4gV2l0aCB2bV9mbGFnc190IEkgdGhpbmsgInRoZW9yZXRpY2FsbHkiIGl0IGNvdWxkIHN0
b3AgYmVpbmcgaW50ZWdlciB0eXBlDQo+ID4gc29tZWRheS4gQnV0IEkgZ3Vlc3MgdGhlIGFkdmFu
dGFnZSBpcyB3aGVuIHNvbWVvbmUgZG9lcyB0aGF0IHRoYXQgY2FuDQo+ID4gdHJpZ2dlciBidWls
ZCBlcnJvciBoZXJlIChzbyB0aGF0IHdlIGNhbiBiZSBhd2FyZSkgd2hpY2ggcGVyaGFwcyBpc24n
dCBhDQo+ID4gYmFkIHRoaW5nPw0KPiBZb3UncmUgcmlnaHQsIHRoZSBidWlsZCBlcnJvciB3b3Vs
ZCBiZSBhIHVzZWZ1bCBlYXJseSB3YXJuaW5nIGlmDQo+IHZtX2ZsYWdzX3QgZXZlciBiZWNvbWVz
IGluY29tcGF0aWJsZS7CoA0KPiANCg0KQWdyZWVkLiAgSXQncyB3aGF0IHR5cGUgc2FmZXR5IG1l
YW5zIElNSE8uDQoNCg0KPiBJJ20gZmluZSBlaXRoZXIgd2F5LCBsZXQgbWUga25vdw0KPiBpZiB5
b3UnZCBwcmVmZXIga2VlcGluZw0KPiB1bnNpZ25lZCBsb25nIGFuZCBJJ2xsIHNlbmQgYSB2My4N
Cg0KSXQncyB1cCB0byBtYWludGFpbmVyKHMpLCBidXQgdjIgbWFrZXMgc2Vuc2UgdG8gbWUsIHNv
Og0KDQpBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K
