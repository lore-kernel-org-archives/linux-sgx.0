Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9228634C;
	Sun, 16 Nov 2025 09:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763285828; cv=fail; b=irw+5KkVzIKTH8Yogsj9+pcyGOhz1XTCDvcYxSFOgSIOjpqJTUxQVdHMbWLYCE2mlWPYZ59zT0tcN5Db85TXAgQihP3sie2MelQ8Std2P1pJT0kjsQ7AXPlGQU6btscJetp7D6D2uCiXdhrFd5hU3Mh/crxAv/9DZetE2YFXH2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763285828; c=relaxed/simple;
	bh=TFotK3hpo232jnbxuLNbenGdRm47cJb6GIMSWD/M41U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TTvS44UthhjEqZcJMQAen8heztb/UOJcHi4R5aW1/iPZw7jxklp4RCfFSs+1YkvqDxGRMkQAIsHvoEBB0z5uD9q8YWeuiLv+pjCyZOE08zWDGdER8sS9OTukbs88RVdyqfRa44jRc28RDTxPbCCjTfH5kxWV/04w7HgtO1Brw90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U1qs61Pk; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U1qs61Pk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763285827; x=1794821827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TFotK3hpo232jnbxuLNbenGdRm47cJb6GIMSWD/M41U=;
  b=U1qs61Pkh9ccqIwgBk8NfhpZ6lmcOC8NhQHNYMlDDZge171SclO/N/7H
   UDbgfyMvrSejVo9H3hjHouXQjSZacuwqjdtQ5dihCM7P3n1aTOhojv28N
   /mn5975pXpLFuLcrIEdfISrfk2eAqeEuxeGJtpc9XKT2V3+uJ8h/G4Txd
   4v0QkC1veUTLpOpOTRW5MBnNZa+Sq5haU3fQf55NXenk5AavicUacLXOe
   +tc2S2Wz/GdkTGl0veBp+jEL6WrgWb29alyakYFBg3lNCZpzFFrBLwLf1
   hW+p7EaIzltlhISGvAx5UgtAKMC+yqHu4SXFFQxaaq3OgDni3DI+d8X9e
   g==;
X-CSE-ConnectionGUID: Qvd+NXJ2RuOuyLRCqxKBQQ==
X-CSE-MsgGUID: k4jhH2JuQxeANZ+CF+prmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11614"; a="87960219"
X-IronPort-AV: E=Sophos;i="6.19,309,1754982000"; 
   d="scan'208";a="87960219"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 01:37:04 -0800
X-CSE-ConnectionGUID: y96q2ah0QjKsKT/QjEljiA==
X-CSE-MsgGUID: 2+WkkvUkRd2V0VtRBhzD6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,309,1754982000"; 
   d="scan'208";a="221073985"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 01:37:03 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 01:37:03 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 16 Nov 2025 01:37:03 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.64) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 01:37:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m42vMdDFCGMBVL/yeHR0Lbv0utywfzj6L9sShBLMYj5ldJblmIq1FZLb3EOB+HAbPjOgy3ACMVvmB/aEi/ZRrJUdmZIpmu5rVZdjfHobTI/bCJfyIH7vyrM8s6JsTOLxAvenMjtJYZLFiNLbE6hEmHNNVyKA9JXqQ4EAQdeW+ZRwiwwoGMEdVfb3pw4xA0FYtmr0r38DclbLbluzSqaqZ6cCX/fpdL9QhMalK3z9lyFUYkT6wpWBeXmaqwMqH+3kwj4KEg/xIjlcEt7JHu6n9kDw//NKZ55sZLwSEd6LIqRhr6bA6AdQeHaM2vWIPTkuwa2rlhyYSP5/kxeB4kLD5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFotK3hpo232jnbxuLNbenGdRm47cJb6GIMSWD/M41U=;
 b=BzUS6FxaFEpADG3WE3iltDKZBiMitE68keetzgDGbLp5ELF0ZKft7ze7p0UojvOGassrwtY0uRz7UXxKOSt0rBwQEouzGdmYrNQVQeyTwe09N3o8TV3yOlfFBp6N6BfX1wEZSRVcwQ7zzoBE8cOqR9mfemzT0RNuajXnvjUh1S2jZCANp3xuzhQK5BM8UA+xYgBkVaNuK/HsQR1is32jtYAFql01et69k+rE+2joC8kBYGqZOAQQbDUVGs6zRcmEgdw7wBKAmZR2vopMSZNUOGyC4ip2tkK8QAwCnumsZP2fQr+65NhI2jB2UY5L1OolIqnqBwdPK/jznt9L1eg5sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH0PR11MB8236.namprd11.prod.outlook.com (2603:10b6:610:184::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.20; Sun, 16 Nov
 2025 09:37:01 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.019; Sun, 16 Nov 2025
 09:37:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "rdunlap@infradead.org" <rdunlap@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/sgx: fix enum kernel-doc notation
Thread-Topic: [PATCH] x86/sgx: fix enum kernel-doc notation
Thread-Index: AQHcVfRh1X+uhpyZZUuGad7/+zIQiLT1DTCA
Date: Sun, 16 Nov 2025 09:37:00 +0000
Message-ID: <0b9aeaf886d9b282ef8397d017f1e67c0ceb6a30.camel@intel.com>
References: <20251115055440.3700056-1-rdunlap@infradead.org>
In-Reply-To: <20251115055440.3700056-1-rdunlap@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH0PR11MB8236:EE_
x-ms-office365-filtering-correlation-id: e4471aca-64ea-4ac9-ea68-08de24f3b1b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cWpVUXJ2MmFHcnM1NzBmNEZWT0RkWWhhcXBPVUF6eUR4TytsOXU2VWlPOXVr?=
 =?utf-8?B?Y3hMNStZTUFQVmRUeVEwRm16bE00eHUra2VLQ0hZN2ltUCtxUkZ0MlI2cVlY?=
 =?utf-8?B?NGNOSG85dGxYNWdSYy9CMVZUb3dkdWR6amRwZTdVZlgvSi9aQldUb0VxNnlF?=
 =?utf-8?B?M2pmd3M3NjArOTRBazczTHJIRUZtSjkvcS9MaFlBS0Y2Vm16REYyR2IyU1Rp?=
 =?utf-8?B?ZVZMNW1MbzVZSmpXNXhoYkRscjV2OEhFakVIWVJZNlU4cUNSWVlxS3BlYmYy?=
 =?utf-8?B?c05EZFN6ZndsTVplT1lsUm1rS1NwNWdSZ2ZVTG5wNHRTK0FxMzlyc3hWMVpW?=
 =?utf-8?B?UUtNT1lTeUg0enZXZEdlWDRxUlR5QnhMUG14bVNKaUgxTWVuRGs2ZWdDK2NZ?=
 =?utf-8?B?YXBUWW9CcHAxbVlzaTVGdWNVcDNhbnVaT3hmeDM3NUduZWZQNE8yRkRKMjRi?=
 =?utf-8?B?TUtvaS9tdGNxd0ltMGZZc1ZlbFE5TUttSXRFYmR5T2txbnl5cnZNZmFoMitI?=
 =?utf-8?B?bGtWQ0RzWjdManZ4N0Fac0ZwWmQrRmZWRldDYXh2MlJUb0N2dmQxdXMwdktW?=
 =?utf-8?B?Q241VlkwbytaYnY4aDZWSmJMbWM3Z0pGVlAzRFk1L1cyZlNGZzIxN2pUamc1?=
 =?utf-8?B?bEdGUUFxZHUwL3pjZ3RudEN4a2FzejJsdkFDTVpXekxNL3lIQi83dEx3YmJK?=
 =?utf-8?B?RjQ2U3BLTzNKRzRublJlZkM1S0ZGdVdUVGUyOXg0TVczV1loK1U3N09ONDQx?=
 =?utf-8?B?dWZjWmRnM3kxTGk2WVd6S042OTBsbWF4bC9qODEwUVpESmlteGl4MkpuY2tx?=
 =?utf-8?B?VlAxcjd2U2x4eHlSOTRsUkZzcGxkbGo1aHRXcE93cThDWlA2enBiellMR0pO?=
 =?utf-8?B?Qm5HeFpjUCtmdzh4eTJIZmhheElDaVhyVjV6b2c0Y2FySjNzL2hTZ3F5SUxF?=
 =?utf-8?B?WFdjRmpDczh0dklrZVcwc0t2V3RGVXZ0YzFvWTN6TldQUVg0RmJxWlVuZmRu?=
 =?utf-8?B?RXlXeVFUOFFGcDdwTUhjbU9iL1J2ZGVRL2Y5aXBWNCthS2lnTTZsZm5yRVgy?=
 =?utf-8?B?SzJjS1d1SGdnLzhGR2h3R2M1a3VOMzFicUV1WG5iY1ZBMm85SThVTEQ5d3g1?=
 =?utf-8?B?eFZLRW1JallQd1Rrc1RyYWVVREwvU1Myd2dWcG1RTUYxb0prQUI2WFNDbjZh?=
 =?utf-8?B?bjE1dk1pMlp3OWIzdUlGMXRaZElBYVpGZHlFdk8rN011bnByTFF6OG5yQ2FO?=
 =?utf-8?B?eERyZHpSYTdXTGZXSHdMdG9oUWl4aWNWL0NsY1hxWjUxMDJQbUk1TTB4c012?=
 =?utf-8?B?MStDQWRRNE9lUW5KS2ZDMkkwKzFuNWlpenR0L0lFYVZac1JRWVh2V1JZNnV2?=
 =?utf-8?B?NXlRaTIrc1p3RWFDcUtSdjRnYitkTEJKdVdZbTFGVTl3T3Q4S3JpTkFVRVY1?=
 =?utf-8?B?Sm1JdEtWbUNnb2xQSGo2dkUzRzZPNEk5QnRTMzNCQldWQWtUMjhSZDhNVTRC?=
 =?utf-8?B?U2NRZXpUekkwTzd5OW15WVA3cGh1Y1FpK2V3RHRFZkVjYWU3QUZJMVdXSnFF?=
 =?utf-8?B?eEk2Nmx2VkgvVHhnVnQ0OHNMNENQbE5pQ3RJQk1USGpnYVBFNmloNUNSN1VN?=
 =?utf-8?B?R3BxN2dwQXZnRFBBbGo2Zk9oNXZmUmpzblJtbnprVDJSMUhWSEtmU3JXTjJO?=
 =?utf-8?B?aGo4TkVsMkgzL2ZGeVhsTEhYOFgvYVhKNEhtL0xjTFpTRWphWm1HSzdraTUz?=
 =?utf-8?B?R0R2aG9KWmZyNnU1aUFJcW50bm02ZXZxVU15UWdlcXdjakFUbEdzSUV6TzJy?=
 =?utf-8?B?VW5DT0JWRENXZTFnVXBpSmptQk52cE1GVndYREx0RGl2cWRkMkpFZnJNcHBP?=
 =?utf-8?B?c1JEdFJNZ1dLdCtvY1BFUTBHalNtQ2pmNE15bVY4TDdRRUdwQVVPQ1NLcWFw?=
 =?utf-8?Q?Kt6NaugEqhCqyRfDa1hYGw13V0wzqvOH?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WldUamw1WnFTeGdrWmdSNDJDa244M0pzSE44S0xyQW54c1ZCdG1zMExvMWFz?=
 =?utf-8?B?c25RTXBQQVpqQ0YyamxkSzMrVEJZY0gvY1BNNVErbXl1MzBhNStVcCs3VWNu?=
 =?utf-8?B?V1dxMStnNnJoSFRndUZ1ZzNGTnh3dGE5REl0UVN6Rm5XOXVJemIrd0JxeVBB?=
 =?utf-8?B?U3crcTc4anFXcnNESTE1Y1o5Q2NkNkpRNkVXZjh3TjFJM0lOWWhYMU5GSDc1?=
 =?utf-8?B?ZWhTWlRBbUlqeERON2ZoaE85Tkxrdk9oQXNWZG0yRkE2N0tWM0s1RHNyVm9P?=
 =?utf-8?B?ZnlzakE2K2lrbDM0R3E0MTVnWHpkbWx3N2RMWm9yVDlzREcyNjE4d3FXb3Y5?=
 =?utf-8?B?aStCQlZmWEZ4ZlFoME1rTTgrSTNSMFk3dFRhS0lScDBnMHR5WXptYmxJaXFD?=
 =?utf-8?B?bVhMYlkyMmdOSEhKdHBSUURHSFdVREdyNEFTVXMyNFQvOVJ6VU1weTVZVmNR?=
 =?utf-8?B?UEVSRHpOZ05mNFg4TUx2bW5BOXlDTHFHa1NkWkxTbExzYTRiSWpDamJqV2RX?=
 =?utf-8?B?Z2x2Y1B6Y0hMZjQvUXIxKzdTMXZFR0ZQZjNSM1VFMm5jdHY1SUFTYlZhMjR6?=
 =?utf-8?B?Y3JnZmZTUkZEbUV3ZUUraGc3U3dOV2J6Wi9mcW82Vmt1aStnblV5UXptNWpk?=
 =?utf-8?B?aWRCelc4eTQ2MzVPWFI4N3hkWEx1Y2RvYVU5eWZGWmVJS2xmZjA3RGRSRzZv?=
 =?utf-8?B?QVd4MXVWVk9mY29xSTlOZDV4RmR6Skg0MWJPSTZrYWIrTzA5bUZkREdPZ29I?=
 =?utf-8?B?QmZYME14dVNyWEtzSUlPOGVFT0o0aVYvOEZHT3YyeW5ZQ080TnhDeDI5ZjBZ?=
 =?utf-8?B?NUtqNnkxTHB4UndCWjl1S2YzVTd5Y3hzYnZoNnhSM1hkY054cGxMM2JsSVkr?=
 =?utf-8?B?Ni9oaldhVHFZUnhuNmZobDUzSndQTlhNcTAvb2cxUk1nS0daOEdqay9jbkIx?=
 =?utf-8?B?cnpZcGFaL2pwNSt2SkNRSVo4ejBNaGpkbUtNR2dVQTdqOG5LdEthWVdSVW5k?=
 =?utf-8?B?MForK1IxY0hlU0tjTzlGUWpqVGRJQ1BYVTZPaGhuRWtqMHJENHpIcmtrVVBw?=
 =?utf-8?B?RVNIOXA3bmVKYURpakFhMFFBT1JETFM5amZJbFhqdThuNG5HanJpRU1PYVpz?=
 =?utf-8?B?aUs3aStKbmc0RnRVcDZlbXhVMWV4cU9pOStVVGRJTmR0M1pJM1hzamcyNTVD?=
 =?utf-8?B?SHhTSHZ5dW4yQmVwYzUrK0h3MFBMdkJUUDRIVjhmUldKTjNTT1JzQm9RL21O?=
 =?utf-8?B?VWZEWU9vRmpSTngwTDR6RDUyc0VuS2pQWHc2VjAwbEVPQ3VxZmV4cHg1Z2Ft?=
 =?utf-8?B?TkZ2NnNNVFUzL0o0RnRpZFg3TnBXYzZIQXhlZjRXY0RvOWljdk5ZeU1Bbnk1?=
 =?utf-8?B?MGdRSHQxdy80enVCWnR6dml2NVVPakpCTmsvS01MRFoxOXlsRktya0IyZmFV?=
 =?utf-8?B?clZ1eTVEMkd5eGtUbmlsWllGYnYrWTE4cUdhODlvSTdtTU9NbDhYeE5BNUJC?=
 =?utf-8?B?WnVOR2dhUW9CWFEyVGdvakhGajFmZ05FYzBVdVhJbFVab0NpOTFudnlxY2du?=
 =?utf-8?B?U3VVV1Rrais2elBMdDZFbVhheGxVaGx2MHZKdk1TajllbGpDWHowMzB0WnJl?=
 =?utf-8?B?QXdGdmNlbVNyNVl4N1RmTWNJcTVZRm90blN2b3NLZ08rQkpiSjV2dXFyUmRx?=
 =?utf-8?B?aUM1cXFLWjJyaDR5QnVLditCcXZHWUZLanh4QjhWSUw2bzgzUmxsN0ZCOGFn?=
 =?utf-8?B?blBvL1hTN2xnL1gzcUV3QVVySHJ3WG5vRk85Mll3WGVoejBtOFlhRjJ6QXF0?=
 =?utf-8?B?anh5Sk5YOFpMSDgxenV1YkxDdTBXSlpWSVluc2ZFdTVrTDRYTnNqeU5aMXVj?=
 =?utf-8?B?V01LWG5qSEZzWHFoNlhHVXRZdHpzWGZvWWwvSTlTczBQY0RDS0d5d3VtdTdU?=
 =?utf-8?B?MWF1K25VRExRUjlVTkZTREJyOVIzUXhubFhpME1wSmJiNU84M056UkdSNVEx?=
 =?utf-8?B?LzFvSk1SMjBjTzF3TnpDa3krcGdYMGorMFhoV3YvWW5JVFpNUVN4MDY4eS9X?=
 =?utf-8?B?TXNOai9SWmNVQSt2VTBUZ25oQzN5UXpaanFhMW9xdW9wUXVaaXhlRFRkN21a?=
 =?utf-8?Q?YQA3SkoFt4N+/SOxr6+EAx1Ve?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76F6DB8B7928FD4A992B6CED7C647619@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4471aca-64ea-4ac9-ea68-08de24f3b1b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2025 09:37:01.0029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 00vqHFGBslA/d77iMN8KyOJJCfIdmWnmXvD6Qb7REZRFh130SMd+wyP4i8qatOz+7ZxqFih7CvX2pamE4ZdOPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8236
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTExLTE0IGF0IDIxOjU0IC0wODAwLCBSYW5keSBEdW5sYXAgd3JvdGU6DQo+
IFVzZSAiQG5hbWUiIGluc3RlYWQgb2YgIiVuYW1lIiB0byBkZXNjcmliZSBtZW1iZXJzIG9mIGFu
IGVudW0uIFRoaXMNCj4gcHJldmVudHMgYSBrZXJuZWwtZG9jIHdhcm5pbmc6DQo+IA0KPiBXQVJO
SU5HOiBhcmNoL3g4Ni9pbmNsdWRlL3VhcGkvYXNtL3NneC5oOjE3IEVudW0gdmFsdWUNCj4gICdT
R1hfUEFHRV9NRUFTVVJFJyBub3QgZGVzY3JpYmVkIGluIGVudW0gJ3NneF9wYWdlX2ZsYWdzJw0K
PiANCj4gU2lnbmVkLW9mZi1ieTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+
DQo+IC0tLQ0KPiBDYzogSmFya2tvIFNha2tpbmVuIDxqYXJra29Aa2VybmVsLm9yZz4NCj4gQ2M6
IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb20+DQo+IENjOiBsaW51eC1z
Z3hAdmdlci5rZXJuZWwub3JnDQo+IENjOiB4ODZAa2VybmVsLm9yZw0KPiAtLS0NCj4gIGFyY2gv
eDg2L2luY2x1ZGUvdWFwaS9hc20vc2d4LmggfCAgICAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IC0tLSBsaW51eC1uZXh0LTIwMjUx
MTE0Lm9yaWcvYXJjaC94ODYvaW5jbHVkZS91YXBpL2FzbS9zZ3guaA0KPiArKysgbGludXgtbmV4
dC0yMDI1MTExNC9hcmNoL3g4Ni9pbmNsdWRlL3VhcGkvYXNtL3NneC5oDQo+IEBAIC0xMCw3ICsx
MCw3IEBADQo+ICANCj4gIC8qKg0KPiAgICogZW51bSBzZ3hfcGFnZV9mbGFncyAtIHBhZ2UgY29u
dHJvbCBmbGFncw0KPiAtICogJVNHWF9QQUdFX01FQVNVUkU6CU1lYXN1cmUgdGhlIHBhZ2UgY29u
dGVudHMgd2l0aCBhIHNlcXVlbmNlIG9mDQo+ICsgKiBAU0dYX1BBR0VfTUVBU1VSRToJTWVhc3Vy
ZSB0aGUgcGFnZSBjb250ZW50cyB3aXRoIGEgc2VxdWVuY2Ugb2YNCj4gICAqCQkJRU5DTFNbRUVY
VEVORF0gb3BlcmF0aW9ucy4NCj4gICAqLw0KPiAgZW51bSBzZ3hfcGFnZV9mbGFncyB7DQoNClRo
aXMgaGFzIGJlZW4gYWRkcmVzc2VkIGluIFNlYW4ncyBwYXRjaDoNCg0KaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGludXgtc2d4LzIwMjUxMTEyMTYwNzA4LjEzNDMzNTUtNC1zZWFuamNAZ29vZ2xl
LmNvbS8NCg0KQW5kIGl0IGhhcyBiZWVuIG1lcmdlZCB0byB0aXAgdHJlZS4NCg==
