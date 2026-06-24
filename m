Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5D92F5474;
	Wed, 24 Jun 2026 22:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782339829; cv=fail; b=Xg57CfongQqlWRJcx8pP40AV4tuMtFBwatCc7HfSyrZQTEKYx9osC9w+SiYwyWOkV44lrkdj69R9y+3xRlSzaAbzc4Uk9hbZQKvaBP3B1yOO/AYL2mWOv+yWHsACJ3aZWd/35zN0iFTbd5NuR1XR570PcGVTTTSWU+iORhEKD5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782339829; c=relaxed/simple;
	bh=Suwlc4dJabu3gnVpzKBIu+kqrOHCGbPjM3du08fDMTA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V5ktLWhOCevnw7EgWM8cnDtYIjolR2LfijnZ5Aj6TEQKHtoesmOZMigsrQs6p/c0NKudSbkhsMx8ZGlXlfc0YboGLVtWoFcRfdKofvgepkfQc6xoJ4QUCZUCu2pVG+sNo/iAxO37TCLcgyqnyEgjFt8g9lGv2VoUZ41FqRL2YYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lie3ZjOV; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lie3ZjOV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782339828; x=1813875828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Suwlc4dJabu3gnVpzKBIu+kqrOHCGbPjM3du08fDMTA=;
  b=Lie3ZjOVkstbGRBOJ3dzAYKGU+MLHkvVaDGMTOvnHLJ43cG7ZpSS1BHy
   WyuzUEK1AvGpkAun4UTp5c8rGnDBvyqpIhTzO+LRjWhof4gey1xM6Exx+
   x68BFAo35JiPDUJHwIe+aJmqNMMPi/7UkKEz2T3SqYRe0rrG9qx4AaMqV
   b+MHL7gCOc4YcG4m7DXVL+zRkD/FI/bfKB0kzIcvxfGz0ZzdtTSirJfnV
   CC+PTVQlowwUJeyfZAqloSeXtuDQOKDnmhkwZPgB/Gp4mqpEo3Jc4gv34
   x6WBsyHqXoVPExQTdWuYhe9t6OujBxWlTz4y/9O1BcdBsF5iv7D8QtCgI
   g==;
X-CSE-ConnectionGUID: r8JXiooWRFijs8Lzor+yPg==
X-CSE-MsgGUID: lliEA6hESnGUXIQvnumlaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11827"; a="83236645"
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="83236645"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 15:23:47 -0700
X-CSE-ConnectionGUID: br+/CG5STwi3DfF1EOd+Dw==
X-CSE-MsgGUID: 90n4kdgJS0Gd3ntfVXm2Ow==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 15:23:47 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 15:23:47 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 24 Jun 2026 15:23:47 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.62) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 15:23:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JeXnQ1WuEqIDPobKqupfBWn79SXaJRyuE1G14LwTc8Q1fV8UbdtIA88KPybR5C3bL+qnSzMwDYza27TYI2is6GqC8eQ5o+f9HLxYbEIdw64u79gwxPTMdeu9heXP+GLMJnoJswzDtFpTz8104zrFcnhrSo/kNMEj3jD1C2fAPkLjLq1zt2QcPZu4Y5qiJ3eVL1HU6CkCYwGJMbFb0/Pn58Q5CEzJyNdHQY3rYXtNY8jcU2Xd9LX6oLL92g9MwtHcGRu1AeZYmtaU5+mWDAsBjA8BaQU7S1oHlzBWDQg0YVAOe1QkqPevCzO3dNk/kukA+sb04hKZ/xtzFSIdbRRbLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Suwlc4dJabu3gnVpzKBIu+kqrOHCGbPjM3du08fDMTA=;
 b=CyZjILhbdsydmxB5LhUGUKR6PjLF7CHR8Ysbm3dZYdG22GJ48/MRJ6pnQUdEaLi5xH5uxgykpTsRr8xgUs/XK7PJcWEBqupwznZGG2Aw3QDjBMRCrb6lqvilYYKr0UEwVbq7ZsjmhToOkNrbabJiifGpC0tVmklWfWDhTTFFleSaAQXp9g208F7Z9ckb5yk4uHfMwSm6msvLw8z85Hco569pfN/oT9M+sJtfz4yNj23nOw4OMZYZSp7dksgiF2nScRkd2bJ/y4GVIcKHmSTLCOHKBVpsbKmx7w1jV7NlVpGZul+cQGgwCJ16rojTgSLvDTSjgVsL6hDs6kR/+fGS8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB2647.namprd11.prod.outlook.com (2603:10b6:a02:be::12)
 by DM3PPFEF920636F.namprd11.prod.outlook.com (2603:10b6:f:fc00::f5d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Wed, 24 Jun
 2026 22:23:44 +0000
Received: from BYAPR11MB2647.namprd11.prod.outlook.com
 ([fe80::32d7:4779:29d3:a1ee]) by BYAPR11MB2647.namprd11.prod.outlook.com
 ([fe80::32d7:4779:29d3:a1ee%4]) with mapi id 15.21.0159.012; Wed, 24 Jun 2026
 22:23:44 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Miao, Jun" <jun.miao@intel.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Du, Fan"
	<fan.du@intel.com>, "challvy.tee@gmail.com" <challvy.tee@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"qiang.zhang@linux.dev" <qiang.zhang@linux.dev>
Subject: Re: [PATCH v4] x86/sgx: Fix RCU Tasks stall in EPC sanitization loop
Thread-Topic: [PATCH v4] x86/sgx: Fix RCU Tasks stall in EPC sanitization loop
Thread-Index: AQHdA+SJQ+kf3PIYd0G2IMMXBRXrp7ZOSHAA
Date: Wed, 24 Jun 2026 22:23:44 +0000
Message-ID: <27a2dffc7c0d4af5898b7d9d6c65612f9868ca9f.camel@intel.com>
References: <20260624142011.2965809-1-jun.miao@intel.com>
In-Reply-To: <20260624142011.2965809-1-jun.miao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB2647:EE_|DM3PPFEF920636F:EE_
x-ms-office365-filtering-correlation-id: 025faa74-f172-4ab1-439f-08ded23f40d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|18002099003|22082099003|38070700021|6133799003|5023799004|11063799006|56012099006|3023799007;
x-microsoft-antispam-message-info: 7mN3v/fp5961FLBg2bZhwNLUicZFtu0RVKUOe1y0lxUS03mC1z8qOYQsZQlgzfcV6DCY9lHWZ0DSPfiAGJXYRHQceS9qhdIm6NuVB3UsXZ7ZUJb/emamvYLTuljpHRDp9yN0aHowznn5/601qBEBHF6wo2B+25TyxIiPpqgM6pEOE/aR0oWyS5I1/rKxuFRiQix3TsNxlgzaf0Nd0WJINytth5acHYWvmdghtZekYXlHy/Mmzu6b1L1HCfRWM7NhmYI8XdNMBxuhHfqfhm5piO/bbrRA0bbPHCQNGCX7q+Q8p9ILhEmCqxPIjoix6J+Squ690xWDEAXJgL50gYDJ80lHKSVSFmIotV+vwffZUl7KVfp3b0MTinTmmLjBKmGd8s2LC0lBM6mgGgv9PttUps29GOGVEIRMtc0sZkyqn00EJ+YKfI4GRhu9fQ18HtL8iaA6ZBKGh3MYrgqhhJb9NXjn0zCSddenP4X1CBcax+GAXmWIbGIbc5HiLUqRY1jnnTQi+vUsY0VOTL280Ql6y8NjD7i/ntevOyNNu5eQxfV49CmPrb4PGiAPfYy5K5fZHpwsNzCqhbhPi3yiTTMI10HcWpsvkWySUKCtB0aAzRUagnCIR+h6QauVprFsWJ1/jPJiox+286OvwhCuFHuThf9cNN1Ax1/bRtP0ftc+2PXaxhHHW59ew5CMaz+fqlL02uG3S6taFuy1NfTffxrfvYbXg/FWT20TXb2chftJ6EI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2647.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(38070700021)(6133799003)(5023799004)(11063799006)(56012099006)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUJQMkNSU1lqdjZlTnRHZkJpd3d2ZDhCNE5iaTRzSlZUT09ld2tqK09JaDZT?=
 =?utf-8?B?SmdiZklmcWhWWUR4T05VSVcvTTZyRDRQb2pYUUhQa21vcTlZK0JnYWxieUlm?=
 =?utf-8?B?aGRyQ3pJTU9uSm5Sb3ZzUE9Pd3JlMm0zVFVIOWRETEJlVkdaSEg0YVZVa0NM?=
 =?utf-8?B?bWEzcHVic2YwUFQ2QlpXU1VFMkJ5bmhQdGRKR0xDSmdnblhGN2NiZHlhSmNK?=
 =?utf-8?B?d1FzZTlHMGxhVGRUak5xRE9tbnFqeE1oZ3lzWHVwT2o3YnFoSytyMDZLbDBO?=
 =?utf-8?B?c3RGZHhRM0o4RDNZQXNpQ0VQQjdkMXh3b1puYlgrU3VsQVZoYlVMbjZwY2hB?=
 =?utf-8?B?UXp6MVBMMXB5WHlMUTZlOUtWaUlYdDEzc3BJamhYMCtwVzRiUjhSdS9zYzFX?=
 =?utf-8?B?N1dFdnF2QmhHUmloSnhNWEgyYWtGNGxuTnYyM2l2RGtDa0JkSTdoQlNpRkFQ?=
 =?utf-8?B?U2VxUFBMMjdxbFRxNkMrSGpPZkV6MzMzb3hIMWFpRFplWXlzWTY4d3N1VnN0?=
 =?utf-8?B?SURxVnhhVjM5VWVpT21BdklTTjYvNldyOTNoSUgwOURmRWFXc2Z1NTNrNVp5?=
 =?utf-8?B?V0tqanNkK2twL3ptQWFxZDQwcmxCT0QxZnRWOWR4VVluS29KakMzT205VTVM?=
 =?utf-8?B?T1FXcmt4dXBVZnRaOTZoMDNMM1YzR1VXcVZKZ084TFFwa3VydWY3N0FPZE8y?=
 =?utf-8?B?bTZaSW9RakNPTWRGbTFWRnBPRUtFb2M5M2RaVG5aTFJJWXhvaEVnQW44LzJV?=
 =?utf-8?B?cllCT3M5dDZJWmRxd01ZcWVwSTI1aWpKcTZpR0oyZW1PUFRndHNEUXJBdGk0?=
 =?utf-8?B?alRaQ3BvMmg0TXplcVRCUEdJT3llOTZ2Zmw0NTVtd0N6REdQTFFjY3lVRkNp?=
 =?utf-8?B?TEh3L2ZoRGdxZTN0UCtBZTB3TTNUdHJNUm1TMlBSZE9qZzRJekM1bStMcVYy?=
 =?utf-8?B?c0wwaDUwK0tOanNsKzlxZUZRMk5MSUZxQythVytTWXFtbnRyUjhlRHJITWFD?=
 =?utf-8?B?NEpWN0s5VlJlQVBBSElVeFZvOXBxN1FIanhNVDRSaktzR0lCL1I5QzU3ai9E?=
 =?utf-8?B?VVNmVHN1NUx0NW9lYzBDa29BS1dPaFdOS01wNWIvcFFLTy90UHVGdzVob0Na?=
 =?utf-8?B?Mnc2akxSc2lvMC82UDdJdDlRZ2NmdUlYcUUzaHU0bUxsUGxiaWxsZEszK0xU?=
 =?utf-8?B?SVJlYnJkMm93TXhvYk1XSTdqaWpHc0xWSldNYXp4Q3MrYVVmWU1mVzhMY0RN?=
 =?utf-8?B?RmY4cXZrSjdPT3FWM005dzdTaXE3ZWkyZjZuc2I0VUljUERkUVdTMzhyMzVO?=
 =?utf-8?B?Rmtsd2xtR1R1TkJFU3VMclRKb3FMbG9Wb292VXNEWEZpSnJKSEI5ZlV1WC9l?=
 =?utf-8?B?Zlh1MHFISlpVcTVmZTgrd2JlK2h4aGIvN24xbnJxZTBpbUxGcHFSTW1NM3JU?=
 =?utf-8?B?T3NQL3ViQXFXTW9ERTdxcURtd0I3SWhiMWJyUFFUbEFjTFh0YktqWTMwTEtF?=
 =?utf-8?B?M2hpMXNqL21rODRIcjRFd1ZZT1I1U0Z3cWk3U3RzYUlqTDh1RmZleHZhVHlv?=
 =?utf-8?B?SityRHYwdkRKcnhrRWpYZXNGQTU4dmtwc3hqWGVKcDlrN085Wk55R25LRW4z?=
 =?utf-8?B?V0J0Z3BVTjRYcnEySUNOOHBzL1lPRGdMV3RaaWJnRnZJOXlncFVZaCtGTHJQ?=
 =?utf-8?B?ZElSa3p6OFVUZVo4cXZ5azQ1L3pPZHZEZVBiVzdrYmwzeU9IZmxiaFVrQWlU?=
 =?utf-8?B?Z1hiWGxKbXE4YmNEcyszaXlzZnl2RHRiY2pDbWV4Qys4UWlEbnd5cDhxV09W?=
 =?utf-8?B?SnZOUHZXeXZTNUpVQXdicUZLWHBWeEVMOTVoQ2JzMFRobVBMdFRsV1RtREFL?=
 =?utf-8?B?Rkcvd3B2YStJbEhNUUs1ZWREOU1PaGNpVlNiS09UdDQvTDAvNzdFSG5MZ0k0?=
 =?utf-8?B?YmgwR1RPNzRxM2pLUTExQ3RtYkJiZzJZMXoxVDU3OGgrNHNTV2hvclIvOFNY?=
 =?utf-8?B?OUEwSXl6M3BZNVpkVnBscE9VTENjNWRBa01MeHVLcFlTTWUxTWJyMzdyYmxn?=
 =?utf-8?B?VW1WZ2xkWW1wNVVWUlBCQXJLc2pmNEkzQ0FZc2tyRjNCUlJ3NnFGMTRkZGtV?=
 =?utf-8?B?WldwMDg4SDRDOXo5Nzk4RDJaV3ptYktIeFdHZDM5L0JYNzJJWlM0TjlycDd3?=
 =?utf-8?B?ZnY2MnNNeFhDYXFCRE9QeUIzZGd1R0lxeXQ4V0toVGhuelBnUXJOaldvcXcz?=
 =?utf-8?B?eUlLWGtUNDRsN1JPbkJIYS9zeE1qbjA1OW15d1FhRFBoMFhhY291NFN6bjRX?=
 =?utf-8?B?NWJCQkpLQ2lmSm15dmNQT0h5VmNlZFhvNnYrZWIrVVZ4OGJIUm5UZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9236B3C3AD0E76458EC7C408DB8A10DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: N5CLTRlgxtjiPeLsTc8cG8J9ihZqoNIXw/jIBoB9nt9QyDtqsdDAxWqUb51c4FqAibKY6ihXDpvfk3WEpAVfxamV/aatwgJZal58zKKHMb43FR1ydA11Cozec5z9yv/4i7gUi5TvBUNI5pXpnPre1uHxvciNO/GkdggfnMBlfWPwTu3ergbPxVXUvGi8MyHk12NnzerTsWQyTC7qOBqvVciwIjT6+0owwDEgfoYKFwHPW9WLePS660Xp1UuQlBTP0MvxZkvFsJ4Zkb1V0Qnp5UKbmiZNioXIXQ8ZJlIYa3iE9EWSt6ovTOT0ayuRsmxJaYTRvUAyb4Ja1Xuypfm81A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2647.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 025faa74-f172-4ab1-439f-08ded23f40d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2026 22:23:44.5417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yDDKbE5W3vUy3Grg1OnWiAG2dOqjU3v0WT/gLZ0CHZfF6S/SNuxlSabhjFxXYJltDHImO5ABbwarJG30hxpfPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFEF920636F
X-OriginatorOrg: intel.com

U29tZSBuaXRzIGluIHNwZWxsL2dyYW1tYXIgYmVsb3cuICBTb3JyeSBJIGRpZG4ndCBnbyB0aHJv
dWdoIGFueSBzcGVsbC9ncmFtbWFyDQpjaGVjayBsYXN0IG5pZ2h0IHNpbmNlIGl0IHdhcyBhbHJl
YWR5IHZlcnkgbGF0ZSBmb3IgbWUuDQoNCkJ0dywgdGhlIHY0IGlzIHF1aWNrZXIgdGhhbiBJIGV4
cGVjdGVkIGFueXdheS4gIFdlIGFyZSBzdGlsbCBpbiBtZXJnZSB3aW5kb3cgc28NCm1haW50YWlu
ZXJzIGFyZSBub3QgZXhwZWN0ZWQgdG8gcmV2aWV3IHRoaXMuICBGb3IgbW9yZSBpbmZvLCBzZWUg
Ik1lcmdlIHdpbmRvdyINCnNlY3Rpb24gaW4gRG9jdW1lbnRhdGlvbi9wcm9jZXNzL21haW50YWlu
ZXItdGlwLnJzdC4NCg0KT24gV2VkLCAyMDI2LTA2LTI0IGF0IDIyOjIwICswODAwLCBKdW4gTWlh
byB3cm90ZToNCj4gVGhlIGtlcm5lbCByZXNldHMgYWxsIEVQQyBwYWdlcyB0byBhIGNsZWFuIHN0
YXRlIGluIGEgbG9vcCBiZWZvcmUgdXNpbmcgdGhlbQ0KPiBmb3IgZW5jbGF2ZXMuICBUaGUgbnVt
YmVyIG9mIEVQQyBwYWdlcyBjb3VsZCBiZSBsYXJnZSAoZS5nLiwgR0JzKSB0aHVzDQo+IHJlc2V0
dGluZyB0aGVtIGNvdWxkIHRha2UgYSBmYWlyIGFtb3VudCBvZiB0aW1lLiAgQmVjYXVzZSBvZiB0
aGF0LCBkdXJpbmcNCg0Kcy9mYWlyL3NpZ25pZmljYW50DQoNCj4gZWFybHkgYm9vdCwgdGhlIGtl
cm5lbCByZXNldHMgRVBDIHBhZ2VzIHRocm91Z2ggYSBrZXJuZWwgdGhyZWFkIGtzZ3hkKCkgYW5k
DQo+IHRoZXJlJ3MgYSBjb25kX3Jlc2NoZWQoKSBhZnRlciByZXNldHRpbmcgZWFjaCBFUEMgcGFn
ZS4NCj4gDQo+IFRoaXMgaXMgZmluZSBpbiBtb3N0IGNhc2VzLCBidXQgYmVjb21lcyBhIHByb2Js
ZW0gd2hlbiB0aGVyZSdzIG90aGVyIGtlcm5lbA0KPiBjb2RlIHdhaXRpbmcgZm9yIFJDVS1UYXNr
cyBncmFjZSBwZXJpb2QgYnV0IHRoZSBjb25kX3Jlc2NoZWQoKSBpbiBrc2d4ZCgpDQo+IG5ldmVy
IHRyaWdnZXJzIHJlc2NoZWR1bGluZy4gIEJlY2F1c2UgY29uZF9yZXNjaGVkKCkgZG9lc24ndCBy
ZXBvcnQgcXVpZXNjZW50DQo+IHN0YXRlIHdoZW4gaXQgZG9lc24ndCB0cmlnZ2VyIHJlc2NoZWR1
bGluZywgdGhlIHRocmVhZCB0aGF0IGlzIHdhaXRpbmcgZm9yDQo+IFJDVS1UYXNrcyBncmFjZSBw
ZXJpb2Qgd2lsbCBuZWVkIHRvIHdhaXQgdW50aWwgYWxsIEVQQyBwYWdlcyBhcmUgcmVzZXQuDQo+
IA0KPiBGb3IgaW5zdGFuY2UsIEJQRiBMU00gc3Vic3lzdGVtIGNhbiBpbnZva2Ugc3luY2hyb25p
emVfcmN1X3Rhc2tzKCkgYXQga2VybmVsDQo+IGJvb3QgdGltZS4gIEEgVk0gd2l0aCBhIGxhcmdl
IEVQQyBhc3NpZ25lZCBhbmQgaGF2ZSBCUEYgTFNNIGVuYWJsZWQgY2FuIHRha2UNCgkJCQkJCSBe
DQpSZW1vdmUgdGhlICdoYXZlJy4NCg0KPiBhIGxvbmcgdGltZSB0byBib290LCB3aXRoIGEgY2Fs
bCB0cmFjZSB0cmlnZ2VyZWQ6DQo+IA0KPiAgICAgcmN1X3Rhc2tzX3dhaXRfZ3A6IHJjdV90YXNr
cyBncmFjZSBwZXJpb2QgbnVtYmVyIDEgKHNpbmNlIGJvb3QpIGlzIDEzMDYzMSBqaWZmaWVzIG9s
ZC4NCj4gICAgIElORk86IHRhc2sgc3lzdGVtZDoxIGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAxMjIg
c2Vjb25kcy4NCj4gICAgIC4uLg0KPiAgICAgdGFzazpzeXN0ZW1kICBzdGF0ZTpEIHN0YWNrOjAg
IHBpZDoxICB0cGlkOjEgIHBwaWQ6MCAgZmxhZ3M6MHgwMDAwMDAwMg0KPiAgICAgQ2FsbCBUcmFj
ZToNCj4gICAgIC4uLg0KPiAgICAgc2NoZWR1bGVfdGltZW91dCsweDE1Ny8weDE3MA0KPiAgICAg
d2FpdF9mb3JfY29tcGxldGlvbisweDg4LzB4MTUwDQo+ICAgICBfX3dhaXRfcmN1X2dwKzB4MTdl
LzB4MTkwDQo+ICAgICBzeW5jaHJvbml6ZV9yY3VfdGFza3NfZ2VuZXJpYysweDY0LzB4NjANCj4g
ICAgIC4uLg0KPiAgICAgc3luY2hyb25pemVfcmN1X3Rhc2tzKzB4MTUvMHgyMA0KPiAgICAgcmVn
aXN0ZXJfZnRyYWNlX2RpcmVjdCsweDMxZi8weDM1MA0KPiAgICAgLi4uDQo+ICAgICBicGZfdHJh
bXBvbGluZV9saW5rX3Byb2crMHgzMy8weDYwDQo+ICAgICBicGZfdHJhY2luZ19wcm9nX2F0dGFj
aCsweDNjNS8weDVmMA0KPiANCj4gUmVwbGFjZSBjb25kX3Jlc2NoZWQoKSB3aXRoIGNvbmRfcmVz
Y2hlZF90YXNrc19yY3VfcXMoKSB3aGljaCBleHBsaWNpdGx5IHJlcG9ydCBxdWllc2NlbnQNCg0K
cy9yZXBvcnQgcXVpZXNjZW50L3JlcG9ydHMgcXVpZXNjZW50IHN0YXRlDQoNCj4gcmVnYXJkbGVz
cyB3aGV0aGVyIGFjdHVhbCByZXNjaGVkdWxpbmcgaXMgdHJpZ2dlcmVkLiAgUmVzZXR0aW5nIGFs
bCBFUEMgcGFnZXMgaW4ga3NneGQoKQ0KDQpzL3JlZ2FyZGxlc3MvcmVnYXJkbGVzcyBvZg0KDQo+
IGlzbid0IHBlcmZvcm1hbmNlIGNyaXRpY2FsIHNvIHRoZSBleHRyYSBjb3N0IG9mIGNvbmRfcmVz
Y2hlZF90YXNrc19yY3VfcXMoKSBpc24ndCBhIHByb2JsZW0uDQo+IA0KPiBUZXN0cyBzaG93ZWQg
dGhpcyByZWR1Y2VkIHRoZSBWTSBrZXJuZWwgYm9vdCB0aW1lIGZyb20gfjUwcyB0byB+NzAwbXMu
DQo+IA0KPiBSZXBvcnRlZC1ieTogQ2hhbGx2eSBUZWUgPGNoYWxsdnkudGVlQGdtYWlsLmNvbT4N
Cj4gTGluazogaHR0cHM6Ly9naXRodWIuY29tL3N5c3RlbWQvc3lzdGVtZC9pc3N1ZXMvNDA0MjMN
Cj4gRml4ZXM6IGU3ZTA1NDUyOTlkOCAoIng4Ni9zZ3g6IEluaXRpYWxpemUgbWV0YWRhdGEgZm9y
IEVuY2xhdmUgUGFnZSBDYWNoZSAoRVBDKSBzZWN0aW9ucyIpDQo+IFRlc3RlZC1ieTogQ2hhbGx2
eSBUZWUgPGNoYWxsdnkudGVlQGdtYWlsLmNvbT4NCj4gU3VnZ2VzdGVkLWJ5OiBLYWkgSHVhbmcg
PGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IENvLWRldmVsb3BlZC1ieTogRmFuIER1IDxmYW4uZHVA
aW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBGYW4gRHUgPGZhbi5kdUBpbnRlbC5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IEp1biBNaWFvIDxqdW4ubWlhb0BpbnRlbC5jb20+DQoNCg0KQnR3LCBF
bmdsaXNoIGlzbid0IG15IGZpcnN0IGxhbmd1YWdlLCBzbyBmZWVsIGZyZWUgdG8gdXNlIEFJIHRv
IGltcHJvdmUgdGhlDQphYm92ZSBjaGFuZ2Vsb2cgaWYgeW91IHdhbnQgKEkganVzdCBkaWQgYnV0
IG5vdCBzdXJlIHRoZSBjaGFuZ2VzIGFyZSBhbGwgYmV0dGVyDQp0aG91Z2gpLg0KDQpBbnl3YXks
IGZlZWwgZnJlZSB0byBhZGQ6DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0Bp
bnRlbC5jb20+DQo=
