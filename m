Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597CC1B813;
	Thu, 29 Aug 2024 07:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724918211; cv=fail; b=XAW4R2/hlTbG1IxkBQl/6iguEOlp6qSQdulXkd6kZQ/VUonYnj6hBBB0HNq0Inoi54rfsBlTufNIVHLpevphJEWI9gqFU5iju8KcRZs7Bkjz+zANwM/BKlzKyqN9GbAYIQB29py3+bqfyQdMwr5Qppf39u1nLFRTJIzon0AomsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724918211; c=relaxed/simple;
	bh=3AYMNqg3zSeEccTdCz5XWo8W7P094dqHjcYk9ubYKLA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=STYH5dpbVcXzgnN32VWyMyu4BFoJUkzIh0zNQk3s2eumrGnfWClFFfTTP8FfkPlOgIOZtrWrohEv6nQBX4L6fF+ObZwvrRm3xIyKnn/GXcSnAOfhRukQjWXpUNG3THJqFRmLVuo/XwYGgA5eYDvNE4ys+4nX/2Wr2kzqTc39DwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=miy5/Fhn; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="miy5/Fhn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724918210; x=1756454210;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3AYMNqg3zSeEccTdCz5XWo8W7P094dqHjcYk9ubYKLA=;
  b=miy5/FhnMCjGo68O7gV5zXqS4/wsgks3krErDDHXUraLI4iKtVF44nqj
   eNrdEQINzz5olGNoeqJgR2BwjAuKV9uPkQRtuLBLoKiy3O1POMbFPpxI2
   6jdjCZaYw0crxJc7ka8eqGRjQlgC8RL2C1HQMleTJM0puJqZIN+oFRXax
   qGddbflO9c9NEVDSPEbqM9iAEjjPcKv8LQ+Rd5+10c7XU4ZG75xpnAari
   HBi9Z1XLG/TdgECYm6N2ogDORRtakgjV3i22pE1QuEaGGuYPTi+8gwlJh
   y5M/4SlTy2nCy9rBh+zvIfxLQEVIgTAe+KS2Y+K/+2CJYfK/lKbnM61rs
   Q==;
X-CSE-ConnectionGUID: NP1XzfKuTBC+FL/g73fh0w==
X-CSE-MsgGUID: ZdYhe9aIRge+0WySw8o03Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="23293670"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="23293670"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 00:56:43 -0700
X-CSE-ConnectionGUID: Ek0UbsgGSmKcLPTNmUo4Lg==
X-CSE-MsgGUID: 7UHPEVViT+yx6v1MwIlm6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="63437824"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 00:56:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 00:56:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 00:56:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 00:56:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 00:56:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+RnjLCfBnY5UQZv5gsvHgyJOiqo13p953MOacJPiqM9mRsunOCN6qj3fDaH0EZMDAqKc1G5CVRxyn8Es/2z+TmCCNVRIQO0PSMg9WZ2yyT6KnMHNoCB8Oowo8Yh052IkmkHP6jXVMt036+mMp9Y3o2TWcQtnQ0oaW6rlZWoqqu1AUglQ+EWhXF5i1uO/n1OYO3HCnCPuBvrXSOi7OmWCXJzNYw1wjhpmmywql7Arbeix6uZYH/k73QXzCQ7SaJR+v2/OGJ7FKgEFEBLlKKnuF6HUSDG4TFznyGgUyhwVdXl7CNld0HiTNUibb4l17HeTmsNKU+WfcMg28qdzWNNxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3AYMNqg3zSeEccTdCz5XWo8W7P094dqHjcYk9ubYKLA=;
 b=sQ2Zc3kOy3A/z4Y6MFZiedgtGly9bFktqHulCtgpl3vSvq3kQtnJqt4jH+8Qb2L9W7P1PK0cRA1olvDXTrpKESii9Kk4yiqqrOLsFeqfQBb7SK66Idyeik639BtlucS6n47YVLI9oWVBuiXxb6/u6SetGifAm7UBzf7VqWoq7cNBnL4YdIRiaVnU5HL3LUz1rC2JKdNPce9rxV26Rs9TlZFdhxydS/tpxjqpAgElOeTw+KZh5/r8y4lI6cXKeLqv2DDZXohZdjcgMtO8RZFWe4MDLWGeH+p35JLRqTpCM9IP4GQQP/b7CtxZYToamDGxBaGyOxd7ua5VUdeA3UUE2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6229.namprd11.prod.outlook.com (2603:10b6:208:3c6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Thu, 29 Aug
 2024 07:56:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Thu, 29 Aug 2024
 07:56:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "jarkko@kernel.org" <jarkko@kernel.org>, "Lu, Aaron" <aaron.lu@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Luo, Zhimin"
	<zhimin.luo@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
Thread-Topic: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
Thread-Index: AQHa+byF0Y9MrGV/iE28eEu2OnOLh7I93nmA
Date: Thu, 29 Aug 2024 07:56:39 +0000
Message-ID: <66b93a394bbeb6cc23860efe61a1771ee57b86e5.camel@intel.com>
References: <20240829023800.1671210-1-aaron.lu@intel.com>
In-Reply-To: <20240829023800.1671210-1-aaron.lu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6229:EE_
x-ms-office365-filtering-correlation-id: 462c19bd-9557-4da6-99b6-08dcc8001d52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QVlieWljRUFpaDlRYnlLdmEwNkI4VWdyME8vQ1Y2aG8ySEJNcUZhTHlKeHFD?=
 =?utf-8?B?a2tLNmxmZFNNS0M3VGV4b0tkRWp4U1pGZm9CR3Y2d0VVSG4rY0V5WjVrdklW?=
 =?utf-8?B?WjZUUmpyaCt4U21Md05VTGhjRnZpV3phZGJsRWVaMC9vM3JVcWpPaEpiaE9z?=
 =?utf-8?B?RTRMM2F0aThmSHJQTVRqdFZQbXBENnFLVGRwRElCVGljTlo5K0Q5R0p0aW1G?=
 =?utf-8?B?cUd4SkE4dG12eEdqaXVDZ0RwSDdKU0FpTG9KVDVHV1ZCa2JOMTRoa1AyOTVQ?=
 =?utf-8?B?c2F5TnRwZWNHOElRQWpMYWNNWHVMYUhzRm1lRTZGVkozaEVSMmhpclN0dUUx?=
 =?utf-8?B?dHJvdURuNXdiRVJBYWZFK3lWQ1NxT1FIdS9QZkJFak1kL2VMZWZnQWpFNkpW?=
 =?utf-8?B?emxnN0pLOWVvM3dQU0xQUVJNZUY0V3cvOS95YmJwUVJJVWNOam4wMHBtMlZR?=
 =?utf-8?B?ZVgydmpENzB2VjFDOEZkRnpKVkV6SEJHVGhUcTliQWxTM2kxb0dKeXRFR0p2?=
 =?utf-8?B?cnYxUkZPSFY0Q3pkNEM3L1lpSkFwR04zdzliTFFIMFdhTFNZbEdzajFTU2Z3?=
 =?utf-8?B?Yys2d0hFSWgzRC9lYWhFcHZYNXJ6K0Mxbnlvck9jS0FRWHJSL3BPdmNEUTZL?=
 =?utf-8?B?RU43dVVQME5DYXNIbDZDdktxRUczbENzVU0vcnNZTVNablFlV3czZlQ2SVkw?=
 =?utf-8?B?T2NNN3ljVDAvS1VUKzJnaXdlT25qSUc4eHgyRHByQlFhczhLRVp0K1V0OEJ5?=
 =?utf-8?B?YXovck5HQWtWLzZYMkxjR3lBcGNYalQ2NitaMDlwNnA3WFBBNmJqOVdDelg2?=
 =?utf-8?B?WjhsSmo1QlRtTkoxaDZQZjd1c1pNN0xqbWhBYlVCMzNEN09BZWNKSnBLZ09Z?=
 =?utf-8?B?bDVIQkxrL3cxbFo4OGx2c1l0WFlIMkp0eGc0RTJGdTluWlB3aFhmcXU3Y3ZS?=
 =?utf-8?B?bUZDMXVQeXoyQm9WeElSeXUwb0NpMUpRTXVxYXV0NU9yY3FUL3k2Y0lZSkZG?=
 =?utf-8?B?STd0TVpwb09aT1dmcjhxT1dyRVlvb3VGWkx6aFoxSDlBME1WQ0lka0Y4OWV6?=
 =?utf-8?B?bzh4KzVubHY0TERYdnEzdGhjTitJTlpCWHhyUXc3VVhGeUF6M2phN2s4UHBu?=
 =?utf-8?B?b3JBOVNCTVlDT0UwRkVYTSt3RXlCd0s1RUxaekhidDBIODZmOUpNT1YyTE45?=
 =?utf-8?B?b3JwaGZXTis2TktPOTZqd0dXWWhZR05odjMyVmg2QThpU1YzemZ1SXlvTWVM?=
 =?utf-8?B?ZkNPR3dtSVZFTFF0VU1VaU43aFhrN0UyMlUwUVFpVkJQQXRTamRIY1FiSDAw?=
 =?utf-8?B?RG4zV0RNZ3hJbG5reEE4Z0swUE4ydWRyclJlK0xnWDBFSG5KSEpKY1IydTZz?=
 =?utf-8?B?VDE4c0VsdnhWN3AxMXU0YXhHeTcvbXZsK0dENEpDU3hiYWNVTXRwVDdUc1gv?=
 =?utf-8?B?WVBZRndyTnNFaEJCRjhhbFN3SklGNWVjQ016L3Juam5TbFdPclVIM1ZCV0Iz?=
 =?utf-8?B?a1cvSW1uSUgxSGhmVWFwbXdRMGpTUnlEeTZQamJmQXp4RUZkdEN2YVo4M1d6?=
 =?utf-8?B?d0J5U0cxU09DSnJXelQvSXZmMSs0dGU5cytVZGlRYVBrWkIxU3NIWWRReEZW?=
 =?utf-8?B?Qi9HTCtZdnBwdEFqams2SnhlZHorbzk2aURQajNTSUFhd1Y0N1c0VEJrb3Y3?=
 =?utf-8?B?UWJqRXZwMldzT0IxYVR0QWpKMitGQXJMeWphUlF0Q0lRRTBtUmJvQm5oMmxB?=
 =?utf-8?B?WDNxTklBRkNMSmR5VmQrbnJlWXRNSkI0ZXB6U0ZZUVp0QW5lTGdWQnJ2dTFD?=
 =?utf-8?B?VlVUQkFwdCtYOTRoMDNqTWE4OCt4VFFtQTB6R2tmSlp1OGM2ekVsWmhMdEN3?=
 =?utf-8?B?VXRKRzNnaXhFMGJBZlpoRFBjZWV3Y3JGWXd4UWJhY3FoTFE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHVZeHNwakZqQ0V4TGtucm5zaDF4UFZSMEg2UXMveWRwSGVxVVM4UlUwYmZr?=
 =?utf-8?B?SFZYZ3UwZGxyN3pPODRNcFA3WHpvb0xCOHFMRTBpV3BhcFlrVUtVVUM1U2dJ?=
 =?utf-8?B?dWdVVVRYZm9MRGZJZ2JrZWhDWVlVMFUzM0xtM1R2NkpmMGw0SXpRU0FEOTJM?=
 =?utf-8?B?b3YwZmxFUXJZK2ZMcE5aVkxuMi9hR0lYM3Y5NUVOb2xtUXZFY29NR2I2UnNC?=
 =?utf-8?B?endWYk9ZL045RnMwclg2L3g1dWpMc0UxQ1Z2UjdmWTVDV2V4S0hjdE5kZXAx?=
 =?utf-8?B?MTV0dDBpWkNzMXE1M0gxNFplNklBT2RxS1lVYkxpZ050ZUtBT2orYTh1dG1C?=
 =?utf-8?B?aFM3Z3hqVHBucVExalVoWlFXSVJUcitqTlRYTlF2ZDB4L1N5aXljdU5uUk91?=
 =?utf-8?B?a1lFWEZGSXhNd3V5Vi9ZSFZGcndIL1hRSDVrL3ppRVpyT2hENk1sY1RhTDIv?=
 =?utf-8?B?T0x3N293SS9QU2RiMGFTUjNLRUp3K3VGdVFJL2dONXhkTmFONTI1KzNFZVRa?=
 =?utf-8?B?TkxLS0lrWEthclk4bS81dERhRXdrdnl3VEprNmt3NXVjcUduRmVDZDMxbHZD?=
 =?utf-8?B?UUJoamtrQVliQXdybGt3U2gxYkdoMlVUTUgvQ0tEOWRiRHRLNXZFRnlLdmNn?=
 =?utf-8?B?VytYci9QSkp2UmJiY1FDY3VwMWxjYllRTy9lMmh5M3dCUzhrY3VSMGVBSWRz?=
 =?utf-8?B?MTUwZFpDbE1GOWhqall3WHJTckp0a3d5WXBocnFMZGNKYzJ1bjdBMzBCNHht?=
 =?utf-8?B?aXFzTms1M210M0lyWmdNd1FHUEhxeHA3MXF6TXJrTHNzd0drS0pNZVVHMW12?=
 =?utf-8?B?TW9IQzVKbkJRMUJBTFJWblhnekptWTMyV1BaZCtCc3RBV3R2RWZldmtXL1Vs?=
 =?utf-8?B?WFZCbXdTU1BNekc3eW1EUnJ4b09rYy9yQWlMZjFKeEpKUGE5QklNa3dzUm1x?=
 =?utf-8?B?dFNzSnFoTEVaZGFJY1g5N3NWNE13djVtMWdrWG81T1NNeVc2WUNzTTl3SGE4?=
 =?utf-8?B?ZTB5RDFiSDdRSjZsZHJHWFhjTHBvQnNIdEJKNlliK29UZkRKQjRZTExyOHBS?=
 =?utf-8?B?ejMxNUc0ZEx6U2h3R09FajJVeWtFOFFCcEtaYmpTUUk3SzlOTDVtVC9XQkFS?=
 =?utf-8?B?ZnpDa055dFFGdnN1S2tRMmdTajNGZFZCdUJCSkQrV09KR0ZKYjNUTDN2Q1Fj?=
 =?utf-8?B?YlRPZGNyb3lsdzlrdElWNW5GZUhISTFsZUc5MGtDNDlvMzNIOTJWdHFkcWl6?=
 =?utf-8?B?Y0tvMExoWGVzekNodVpvYzd4NWVmT01QNVZPZWRNY2dQVFl4VkdRMTBkZmU3?=
 =?utf-8?B?VGJBWnZYc0tCMzBSTDhqMG5pOER0ZEthYlZ3YWZ2NExHMCtCbWh5MkY3d1Bo?=
 =?utf-8?B?ZnBweUVPNHRBVGs4bEE4azBiLytyMGVrYWRhdXpYYzRneCtQaUE4cmVvYmlt?=
 =?utf-8?B?dURtMEljeE1ralV6TzJwemRkQ3c3dW9zcnJlazVZS1BSK0F4RmtlcmhlNEY4?=
 =?utf-8?B?SDlpK3hIcC80MjNwL1YyaWlkaVAvZ2ZOUHh0TWZ6RTg2SnZjNWNpZzdPUWpJ?=
 =?utf-8?B?RzA4TCtadVJPazh4UnllaWI1S1hpNUxqVnkwVjFGQ1JPRmhHUDBNSEdYZFNw?=
 =?utf-8?B?VWZSNmVpQU1VNVNQemI2ZmZjaEU3KzVGU05lZC9uRSsxTUxQa3EyWEFHdkJ1?=
 =?utf-8?B?RlppdFI0NU80eE5peEpnZ0UyOU9UNmpHSjA1OWZscFJDQ2NGblhEU0FvL2VO?=
 =?utf-8?B?aFNVYUw0WlV2UmVVQU41YTl3R002VDhCVy84RThNQWlLQzZQR1BjUlJ0NHNU?=
 =?utf-8?B?YWxKSGV5V2dwa1Y2ay9ERzBITllVaE1Pcjl5a2ZRQXp1aWpMSndmTk15YmRq?=
 =?utf-8?B?WDh2enh6b1c5cTIxSkxRdlhhR1dsa3ZEUkx3cUZic3RRdS9kY0NDaHgyd2w2?=
 =?utf-8?B?NXVXTXphN1Q4MHdGbnZINXMyTnkzT0FRWTd1ODd2dWxyTCt2WWdRV0dpNXIv?=
 =?utf-8?B?U1hETU5VSWVGOUh2VWpOdDd3M3BLdTlTY3BtaTlBbHlzOGJPM05OQjVLVTNL?=
 =?utf-8?B?N1Nvak1nR2NWcGpxUHRGZmhhQlFDYXc5QkxxcExleVZHKy80VHZrZ0dNa3A3?=
 =?utf-8?Q?GuMCG07Nv4aG2Ke9pBfFbx/5g?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DB2CED0D651574F84D99B1C234A8EAB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 462c19bd-9557-4da6-99b6-08dcc8001d52
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2024 07:56:39.7037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dgFiKWGuVndqIuwFHem9F0T3gwDyRDMV/f+bU7QL4wR2qD3puBL7UTVoXod++Qoeg1q089xa2XXMMn0SDUMdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6229
X-OriginatorOrg: intel.com

QWN0dWFsbHkgcnVuIHNwZWxsIGNoZWNrIHRoaXMgdGltZSAuLi4NCg0KT24gVGh1LCAyMDI0LTA4
LTI5IGF0IDEwOjM4ICswODAwLCBBYXJvbiBMdSB3cm90ZToNCj4gV2hlbiBjdXJyZW50IG5vZGUg
ZG9lc24ndCBoYXZlIGEgRVBDIHNlY3Rpb24gY29uZmlndXJlZCBieSBmaXJtd2FyZSBhbmQNCg0K
ImN1cnJlbnQgbm9kZSIgLT4gInRoZSBjdXJyZW50IG5vZGUiDQoNCiJhIEVQQyBzZWN0aW9uIiAt
PiAiYW4gRVBDIHNlY3Rpb24iDQoNCj4gYWxsIG90aGVyIEVQQyBzZWN0aW9ucyBtZW1vcnkgYXJl
IHVzZWQgdXAsIENQVSBjYW4gc3R1Y2sgaW5zaWRlIHRoZQ0KDQoiRVBDIHNlY3Rpb25zIG1lbW9y
eSIgLT4gIkVQQyBzZWN0aW9ucyINCg0KImNhbiBzdHVjayIgLT4gImNhbiBnZXQgc3R1Y2siDQoN
Cj4gd2hpbGUgbG9vcCBpbiBfX3NneF9hbGxvY19lcGNfcGFnZSgpIGZvcmV2ZXIgYW5kIHNvZnQg
bG9ja3VwIHdpbGwgaGFwcGVuLg0KPiBOb3RlIGhvdyBuaWRfb2ZfY3VycmVudCB3aWxsIG5ldmVy
IGVxdWFsIHRvIG5pZCBpbiB0aGF0IHdoaWxlIGxvb3AgYmVjYXVzZQ0KPiBuaWRfb2ZfY3VycmVu
dCBpcyBub3Qgc2V0IGluIHNneF9udW1hX21hc2suDQo+IA0KPiBBbHNvIHdvcnRoIG1lbnRpb25p
bmcgaXMgdGhhdCBpdCdzIHBlcmZlY3RseSBmaW5lIGZvciBmaXJtd2FyZSB0byBub3QNCj4gc2V1
cCBhbiBFUEMgc2VjdGlvbiBvbiBhIG5vZGUuIFNldHRpbmcgYW4gRVBDIHNlY3Rpb24gb24gZWFj
aCBub2RlIGNhbg0KPiBiZSBnb29kIGZvciBwZXJmb3JtYW5jZSBidXQgdGhhdCdzIG5vdCBhIHJl
cXVpcmVtZW50IGZ1bmN0aW9uYWxpdHkgd2lzZS4NCj4gDQoNClsuLi5dDQo=
