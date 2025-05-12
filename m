Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F081E32B9;
	Mon, 12 May 2025 12:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747054489; cv=fail; b=Gtfo529T+OeXBMbndkLK7tQB5pDXKYuPEtn7SUbDSMK84xU1D8N0zBLSt1hqpJ8mvRDNx4wn4TOfibwdbpNPtJBAOVAMpQVe7wUbyscXuJ1ExdSQ3Xdfmmu4QwJQyPxkBgTI2sEr1Ov87g8z0QWlXRqTMF+gN97RRl5DCpuKsYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747054489; c=relaxed/simple;
	bh=Sb+mmOJ8rejYDBoxle0mBBnpwxgUyC8osOYr8Pbfw3c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uWKCx++yZ6ti5V/Gz3bQYMHZb9FMJWRiapM8U0QfvvvtCQ4UCOJkCT1CLCLh1imQjZb2BzSm5A6Q0oU4JYfaqHQT4BHTgR69OYeVtXR5M/hKA3LQaZxAelBKgJd5vJUPjsb01efhYWHA3xdvGJdS+JxlKezMXJS2FtVsOR/bZWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dNIjCdUd; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dNIjCdUd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747054488; x=1778590488;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sb+mmOJ8rejYDBoxle0mBBnpwxgUyC8osOYr8Pbfw3c=;
  b=dNIjCdUdq4CFGaMvWlHpc5KeUth31bBJ8FoVKGtKWh9FbmfjMKwDEnqo
   WWs/bZfY099VQCr7VDJeR+cwa1rHuRKIzYKSeG3I563Dk1qFCGPKwxKNk
   7cQf8NDZmj4ojOTAYpinhPEQxWFL4QnGw8NzBb2bI4Nw/uNqJU8tLn4K8
   mv9t+eJmQlhL9aE6UebE4PWRkwJwPAqC2vTyPCl/gQLktLRuAh+QtHzgd
   3g2Era8+X3ATxC6IEWAQWDBzwYq1xk3I2q+eAB8FSPV2+ESWvV5GCrXPQ
   RZPij3ExcHRzUndD9vZYxDWEbOMzCzz8E3IsYXkcHbaCll1TPwyxcHyHh
   w==;
X-CSE-ConnectionGUID: 4+Z2+eo1Qweyc2ykFBByAA==
X-CSE-MsgGUID: z4cGlWTGTZi1uckfJw8kjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="59481468"
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="59481468"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 05:54:47 -0700
X-CSE-ConnectionGUID: XLrEgb3UR9C7z+qWF0cF4A==
X-CSE-MsgGUID: Pzznk2OmQ6q6Idq/5uW/fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="138326109"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 05:54:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 05:54:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 05:54:46 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 05:54:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVrJ+MvZ8exhHfNZTjkkeecokfiLMt94S2rDa8bqSZ8ZEflXohSrIyp2W9WYFKv3tEbB/hv+eoNuvn1dMoxB5+JLvkzitoa4/SwoZhZucw4QHhb86sqKZBXP1t+tAoR7ifN7ANGa17PIS9QNoFsCeHzi1BFMyYaLO1S9U8kmJDOQruCuTbusQSlSo7BOpVCiQseWCgNTi6PZEvqv10Er6KlPZ3kdL+o93tpkN+P3h5PB+scRTC2LSCO4MLaXHD3a+WUQZzhFeFAVKkOlp/nYY0MqG9RNVoauykJBkRO2oebjUQc0F/hHl8TjI5nXAYlYkwnkScfWls2AYzBtOvh6AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sb+mmOJ8rejYDBoxle0mBBnpwxgUyC8osOYr8Pbfw3c=;
 b=rftf4p54fi6dpnPb7MvLQg837N8MPfkwrTxHij/r1havwGZ6M8k/dT9FYDweFhgNGXjoDCfHqwhQGYwPp0AR5Vi03qP/YViOWsB1mnx4jTi+24YscYLKh+uJLWg0j10SytkKxpgmFLxEp0U4fdsUU2H17Jba3dcGHHSEv3ZBlR31U9UAMuv1fRyM+e0HzZ5JT9icHmo6gfvwknxzuJloEokT4Q3BELfsQKvvQf6X0QBlq6QF1zeKS37wCU+VZ/yuG/GFeFPArQZYQsbBEdNxv4hNLRciX7GdsSR8F7AiemcFhYJ4aeShyzYBdNGJmBvSNECLH2SSdNWqXdElB6Ho8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SA3PR11MB7434.namprd11.prod.outlook.com (2603:10b6:806:306::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Mon, 12 May
 2025 12:54:15 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 12:54:15 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v4 1/1] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v4 1/1] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHbv0FzcDl1rDYTb0CkYUTLrcXms7PHVPiAgAFpZgCAACOdgIABTplA
Date: Mon, 12 May 2025 12:54:15 +0000
Message-ID: <DM8PR11MB5750FA8798AF68845D81717FE797A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250507111542.709858-1-elena.reshetova@intel.com>
 <20250507111542.709858-2-elena.reshetova@intel.com>
 <023ab74f-82b7-41fc-ab20-0c0089f1f348@intel.com>
 <DM8PR11MB5750FBF44109B8CAD5574922E78BA@DM8PR11MB5750.namprd11.prod.outlook.com>
 <21752778-b6c8-42aa-8be6-db93a30a570c@intel.com>
In-Reply-To: <21752778-b6c8-42aa-8be6-db93a30a570c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SA3PR11MB7434:EE_
x-ms-office365-filtering-correlation-id: c5bc7026-692e-4c4c-120f-08dd915419cd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MUZPekZ6R3VVOW5yYkNTaDVDRUc0ZjJnWTB5TCsyNnJVZXJQSmZJMk4xdmNo?=
 =?utf-8?B?Y00vd1lFQ2tzNEtYcmZHa2p3SWpLS1dZYzBHYlE4b1BJc3FWc1VuVXh0UmQ2?=
 =?utf-8?B?WTV5RTZMeFRyWElzQUhvMVFlOXhzditpU2RDNXo1U1ZWNWRncXgwREwyaWJi?=
 =?utf-8?B?dTJtNXE3d3JxSzJDTXJYUVBWb0pDd3BFWk1NV3Z0WGcxbGVtTk5Qbk1KSEx1?=
 =?utf-8?B?L0NWTis3QzhCOEo1ejFVWTJwbFlyOW83bE5Yby8zNjdOYUg1RFpnMUtFNloy?=
 =?utf-8?B?bmtrV1hGTjZjWFdsN0NwaXB2bFJneks3QituVmhPc0QxcEFlYkVZbldjKy9N?=
 =?utf-8?B?V25KZU5iWlA0UjRsTU8yK084SHpCdHFlcHNMYzRwUmsrY3VRY1ZndFVFY013?=
 =?utf-8?B?UU1YcHZSMEkwamM5M045UzBkT3ZpVGNRU0pULzdEbWN2SHc0YlFIakd2aU1M?=
 =?utf-8?B?YXhjZEhOS2pMNGV6dzFyQjhBVkJ2RmtBbk1ZWmRaV25ROG9FcGwzY3J6MGxx?=
 =?utf-8?B?N0JUYlZZL1BpLy90WWNFZlQ0cEVIMDczMGZFZ1NCdzMvNGRTeVZJQWNiVmlS?=
 =?utf-8?B?YWRUQjN0OXluSjJMY21lOEx2T0lYZHB5WjJuMUV6Z2pZdyt3QXY2SngyK2VH?=
 =?utf-8?B?M1B4ek9KdGtvVVArTTdkb080ZE55blIzYmEvZlhiYTBqQUtLcUMwRUhPdjA3?=
 =?utf-8?B?dnhGWlhIZ2Q2d1dSMzVkRDZTcDZFZXY2ejVncERLUytTM0dBalF0N05EU0Y3?=
 =?utf-8?B?L01rOTZIK3RNTml1anowKzFSZGYxN3EzRlVpMHB6Mlg5endZTXI0ZDNjQUY1?=
 =?utf-8?B?MlRDUXN3QzkxWDdVNDhiN0xkL0xQemVwakJaZlNEZzh1aFRNN3JaaGpleGgz?=
 =?utf-8?B?MGN3TFZ1dXBIV1k4OFk4YnJzY3NpSms4NTdpa2pmYW04bndvOWEvNFFUd0ZQ?=
 =?utf-8?B?bC95czd0dmQzZzJITG95Zm1udHp1eFhqZWhEQm9LM0lmVVErSXhxN0pXTXpJ?=
 =?utf-8?B?bWxWdzJDY09ybEJxaGpLZDl5cGJyMWpJV2poZmhJNElsRE8ya0QxYjlBWmVr?=
 =?utf-8?B?WlhmV2lJZjNncUhDbFJpNkp1S3Bod3RYRHFOSGRodGV6STA2TFpYV1p4Wjk4?=
 =?utf-8?B?cHQ5OC9sajY0OFRHQzcyZ1JVeWJjcVQ4T0NNb0sxSVhRcFQ1dDdLeGppWS84?=
 =?utf-8?B?NmpCZlJzZG9CRUlRK3d4WmlhNEMxaW5CS3p3eHdiYXQ2VlJ5RjBEN2l1elhl?=
 =?utf-8?B?SUkxYnBrSG9nU2RSMXoxVGszd2NpUXl3TXpmYk8wdnRHV0grMlNzeHJrbzcy?=
 =?utf-8?B?SXBxVktFYldaRjVDZTRDNzlXSUlHNDlTNWs0SGpyZUZINFdLYnMxYzg4ZHJy?=
 =?utf-8?B?WVdjbG1lZEIzaHVoRnNzQVV6VkZIa0ExQys4eW43Q1ZPczNUemtDVUl3b2Zr?=
 =?utf-8?B?VFE0aWJPdDBoQ0NaaXhPZmdkN2w2Um5xZnRrYnNoVlNOcFNiUktsZ2cxcm9L?=
 =?utf-8?B?ZlNtY09oZ21WWk1OVU40K0JOZmZnOHRXd3hJN2ExdkFKbjIzdXpzK3BSYUJi?=
 =?utf-8?B?ekdodmFXa2FhdFVjZGE2NmdEQXJUZjM5d1pRNDVIdlZKRXFrMGpKUTg0TVg2?=
 =?utf-8?B?WGdrZktTcjUrMWIxMzJWR0oxUTZIR3RrOTh3b0Zhb2djd3lJekxBSEVrTG92?=
 =?utf-8?B?aTBrK2hsOGUxZFFYZnhoWDEyQmdCT2xOcjUwRWZaVnpzK3o4ZVA3RjVNWUV6?=
 =?utf-8?B?eG9VbXA3TGJlUWdpT1FsY2VFTXQrN3hWd2VjNWpaNEtrd3kxWnB2aXVVNHUv?=
 =?utf-8?B?dXM3R2wyTXpJS1ZBR083ZXMydXFRTDE4UUoxZ1MwVVN5cVBCSzZ4VWpUZ3cy?=
 =?utf-8?B?aDFvbVIvOHZMQmxmT0VVNmdzQjVxTXBTUlcvM0VXQWEzajQyZTZYOGdkb1V5?=
 =?utf-8?B?aXNKWWNITWYwaXNVbEdnNHduQmk5N282a0lTODhuUXhJQ2kxRUFVMDFVY3FX?=
 =?utf-8?Q?1NUKYkmbrCY6yP94BQV9aVastaA6TY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3FvcDg2L1lOT0kvTUJYODFLdmdSYmJuVUZqbEM1UEFORjE4d2l2R3dkM2tQ?=
 =?utf-8?B?b01wNVlPaVB0WktSSkhDQ24vTVNZTXk5S2ZRWEY1WmV6Zyt1cDU2VmhwRFh6?=
 =?utf-8?B?UzlOaWJLNjgwM3l0UGNnTXJNM3NidDk0eHVLY1BnUkp2MGJrK1hLa050TE0v?=
 =?utf-8?B?RmJRRzZKeHBzb0tGZjE0M3Z6akN2N29zbWtSSmhvQnJZRnpIVkFCRzlDSlBF?=
 =?utf-8?B?aGpDRjA5NWZQMXpHQXRTbmJtREg3Vm1KTUpPbzNHZHhqRytoaEZ6SEFORWtk?=
 =?utf-8?B?ai90dEZvUnVySVpyZGNydSsxR3M5bTdycnFSTVlkaUtiLzdheWxYK3FwU0RI?=
 =?utf-8?B?c2I5dy8zbEI5SEUxZTlKczFhS3A0VUJjYW5yT3N0aXRqVFhibFpzNktWVE9D?=
 =?utf-8?B?MjBvRklxem1OSGJTOWhrbkZ6akNCQThxTU5QeHJQWW9EdWJKVEprZmg0ZnJw?=
 =?utf-8?B?cDdOcU1JenEyWElHQXhRaERkZVowV040UWJqc2dEZUFvZWdrTmpySFFubFZP?=
 =?utf-8?B?cTVVUWlHakJlK0h3cmJic2tQTjZPYnkvYnNIQjNCTjVpbjlscFhpY1NyOVI1?=
 =?utf-8?B?MGhpMmJzTUVZdmVvSmJTa2RYSlBCNE1FQ3MveEtzaDFMYXRqdWhHS1VmYzE2?=
 =?utf-8?B?a2xSbVM2L09mU2ZBcVJ3bktldloyRENVY0Q5NzlTK2RUN0F3ZWRuaWxFNWFD?=
 =?utf-8?B?b2V4eEUzU09VazBpRHE5WU9PemorZjEwanRPTGlmWXJYNi9rRmNUYXJrbUpF?=
 =?utf-8?B?b0kwaHlNTVd5YjVhN0dDMzdkUUVhM0R1SGU2ckJ1ZGpIaWpDZDdSaWZ0L0tk?=
 =?utf-8?B?WmpRcUo5QUVrSjFDUytMalJib1RQY3M3S1RsMitWaE9RMnk1c2E4VjJpUzJ4?=
 =?utf-8?B?QUEybVNyUCtwYTFzQWlsdDNGcFlJSHZydmFLSmFVUE95RVFRWFFoRVFwcUxZ?=
 =?utf-8?B?bmZ5ajU0R3gxS0FzZ3A5UXRvcFVlOXB4ZVpVY2UzcFllSE51bFU1akNUVGhM?=
 =?utf-8?B?RmNPL2VHUFEvZVBKSlR0THlLZWZXMlZvT25TZ3kvbXY1MTh6b3doWlp5SjRB?=
 =?utf-8?B?aGZqSUhDbnhJL1ZISm1GeldZZlora1QrbVNyYlZYeHFIQWJObmRGTUErWUo3?=
 =?utf-8?B?OVBSK2x3clJzTzBBbW5iYmtNS2RYcmRLZ1pwMzdDQnpyNmp1UFIyUWYrYkp5?=
 =?utf-8?B?VkxKRjV4OGZ6NjQ3NnhWeDVpRHdmbkpNazdNWGZXTjYvc1FWY0JFY1JsdSsw?=
 =?utf-8?B?aXhKT3U1R084U3k3RVByWUJtNmNSZGdTeUdab2ptd1JZa2RCTVBHSFhjaWR4?=
 =?utf-8?B?NmpTbjcwbFlpekcvV1VER2tsSHZXd3RwMjRtRW9hMVIyMTVMOFBHd3lzQlNk?=
 =?utf-8?B?YXhXQnhnd0NNWkZlb0NRVUp6anNPVFY3YnoxeGpVS2xrSmdsRlA1SEZ3S3Jt?=
 =?utf-8?B?MStUQ2tTN1IzUURSU3VZaVVpdkNZOGhwV25nZlp1bFEwWEdZZTh1VU1VK01H?=
 =?utf-8?B?Smx3QVdmUDVNdVlsVDUwTTlDcm40L2cwRWs0Yi8vM3duc2NHdnRwcGJhTXVp?=
 =?utf-8?B?YWUyRTNZTjA4STN5ZDA2VlpMaGFkcWdOeG54bzcwWGUzZjVsRWk5d21nS0hM?=
 =?utf-8?B?dG5Na3RHb1hTT3ZtVnEveU9rQWRpWFlFWDdES01YeSsvRzYzOHgyc25EV2NW?=
 =?utf-8?B?azNJYzlzM3pmS1NqSlFjby9RNkdWclY0cC9vbUVzVjdEWlNMNzhkQkNNL3d3?=
 =?utf-8?B?NnYySEJlYWNpMGpFR1l4eFZ2aUxaUzlURkF6RXBXblFCVmFoR1hKQVNPMEtY?=
 =?utf-8?B?MU5zeUYrOG5GcVFoY05HOVkwb2xOZ0Z1MXBJcjJ2ZVVDdUREVVhNR1Npc21j?=
 =?utf-8?B?WVppK2UwY0lKOHdJOG1pNzVPWHRRQ2tQMXV5a2JvbEd1cTdEdzZRMkFQZFdE?=
 =?utf-8?B?NmsvYTVOV3lmVk55ZjRwUmZWNlM2RDVQa21Wd3BqWVptS2M1QlJrK01wYTJ2?=
 =?utf-8?B?Q2lrODdma0FSbnpQdG9lcWZESkVGYVlRSFFkMGZXa244NUg3QWFWQmJtTWZ5?=
 =?utf-8?B?dDlVYUpFRmN3RDlHUnk2RFVsMzhOelkvZ2VFTlltOS9NUmx4UTNpMzZDYmFv?=
 =?utf-8?B?TlIvWVdtbHY2VVQ3emE4b3M4V2tsQnpoV2FKYWNtTytwQVBJd2lQNm9iN2VT?=
 =?utf-8?Q?2rZMoIrC9SUuf5oSGpTwgdSzanVX6giEwoLSO+zNJy1i?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c5bc7026-692e-4c4c-120f-08dd915419cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2025 12:54:15.2168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8OXN+LulBqJirEaWb11oWaVsScbIlOc0vaTh1P11mfC+vMdhslrmpIwuJKUkXCH7SeFHc8isrla5k00FSuxLk1IsXeB1fl8jbnS6GNgISSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7434
X-OriginatorOrg: intel.com

PiA+Pj4gK3N0YXRpYyBib29sIHNneF9oYXNfZXVwZGF0ZXN2bjsNCj4gPj4NCj4gPj4gV2UgaGF2
ZSBDUFVJRCAiY2FjaGVzIiBvZiBzb3J0cy4gV2h5IG9wZW4gY29kZSB0aGlzPw0KPiA+DQo+ID4g
WW91IG1lYW4gWDg2X0ZFQVRVUkVfKj8NCj4gDQo+IFllcy4NCj4gDQo+ID4gU0dYIENQVUlEIGlz
IG9ubHkgZGVmaW5lZCBpbiBTR1ggY29kZSBjdXJyZW50bHkgKGJ0dywgSSBhbSBub3Qgc3VyZQ0K
PiA+IHdoeSB0aGV5IGFyZSBtYWRlIHNwZWNpYWwpIHNvIGl0IGRvZXNu4oCZdCBzdXBwb3J0IHRo
aXMuDQo+IA0KPiBJdCdzIG9ubHkgdXNlZCBpbiBTR1ggY29kZSBhbmQgZWFjaCBzdWJsZWFmIGlz
IG9ubHkgdXNlZCBvbmNlLCBhdCBpbml0DQo+IHRpbWUuIFRoZXJlJ3MgcmVhbGx5IG5vIHJlYXNv
biB0byBhZGQgYW55IGNhY2hpbmcgb2YgYW55IHBhcnRzIG9mIGl0IGZvcg0KPiBhIHNpbmdsZSBp
bml0LXRpbWUgdXNlLg0KPiANCj4gPiBJcyB0aGlzIGEgcGFzdCBkZWNpc2lvbiB0aGF0IHlvdSB3
YW50IHRvIGNoYW5nZT8NCj4gDQo+ICpUaGlzKiBwYXRjaCBjaGFuZ2VzIHRoaW5ncy4gSXQgbW92
ZXMgdGhlIG9uZSB1c2VyIGZyb20gYSBzaW5nbGUNCj4gaW5pdC10aW1lIHVzZSB0byBhIHJ1bnRp
bWUgdXNlci4gSXQgYWRkcyBhIGdsb2JhbCB2YXJpYWJsZS4gSXQncyBub3QNCj4gYWJvdXQgKm1l
KiB3YW50aW5nIGNoYW5nZS4gSXQncyBhYm91dCB0aGlzIHBhdGNoIGNoYW5naW5nIHRoZSBzdGF0
dXMgcXVvLg0KPiANCj4gSSBkb24ndCByZWFsbHkgY2FyZSBhYm91dCB0aGUgI2RlZmluZS4gVGhh
dCdzIG5vdCB0aGUgcXVlc3Rpb24uIFRoZQ0KPiBxdWVzdGlvbiBpcyB3aGV0aGVyIHdlIHdhbnQg
dGhlIGEgc2NhdHRlcmVkIFg4Nl9GRUFUVVJFIGJpdCBmb3INCj4gJ3NneF9oYXNfZXVwZGF0ZXN2
bicgb3Igbm90Lg0KDQpJIGRvbid0IGhhdmUgYSBzdHJvbmcgb3BpbmlvbiBhYm91dCB0aGlzLg0K
V2hhdCBpcyB5b3VyIHN1Z2dlc3Rpb24gaGVyZT8gDQoNCj4gDQo+ID4+PiArc3RhdGljIGF0b21p
Y190IHNneF91c2FnZV9jb3VudDsNCj4gPj4NCj4gPj4gSXMgMzIgYml0cyBlbm91Z2ggZm9yIHNn
eF91c2FnZV9jb3VudD8gV2hhdCBnb2VzIGJvb20gd2hlbiBpdA0KPiBvdmVyZmxvd3M/DQo+ID4N
Cj4gPiBJIGNhbiBpbmNyZWFzZSB0aGUgdmFsdWUgZWFzaWx5LCBidXQgZXZlbiB3aXRoIGN1cnJl
bnQgbnVtYmVyIHdlIGFyZSB0YWxraW5nDQo+ID4gYWJvdXQgMl4zMiBlbmNsYXZlcywgaSBkb250
IHRoaW5rIHRoaXMgaXMgcmVhbGlzdGljIHRvIGhhcHBlbiBpbiBwcmFjdGljZS4NCj4gDQo+IEkg
ZG9uJ3QgbWVhbiB0byBiZSBwZWRhbnRpYywgYnV0IGlzIGl0IDJeMzI/IEkgdGhvdWdodCB3ZSBo
YWQgc2lnbmVkDQo+IGludHMgdW5kZXJuZWF0aCBhdG9taWNfdCBhbmQgd2UgYWxsb3cgbmVnYXRp
dmUgYXRvbWljX3QgdmFsdWVzLiBBcmUgeW91DQo+IHN1Z2dlc3RpbmcgdGhhdCBzaW5jZSB3ZSdy
ZSBqdXN0IHVzaW5nIGEgY291bnRlciB0aGF0IHRoZSBvdmVyZmxvd3MgaW50bw0KPiB0aGUgbmVn
YXRpdmUgc3BhY2UgYXJlIE9LIGFuZCBpdCBkb2Vzbid0IG1hdHRlciB1bnRpbCBpdCB3cmFwcyBh
bGwgdGhlDQo+IHdheSBiYWNrIGFyb3VuZCB0byAwPw0KDQpZZXMsIHlvdSB3b3VsZCB0aGluayB0
aGF0IHdyYXBwaW5nIHRvIG5lZ2F0aXZlIGlzIG9rIGluIHRoaXMgY2FzZSBhcyBzb29uIGFzDQpk
b250IGVuZCB1cCBoaXR0aW5nIDAuIEJ1dCB3aGVuIGl0IGRvZXMgaGFwcGVuLCB3ZSB3aWxsIHRo
aW5rIHRoYXQgRVBDIGlzIGVtcHR5DQphbmQgYXR0ZW1wdCB0byBleGVjdXRlIEVVUERBVEVTVk4u
IEluIHRoaXMgY2FzZSwgZXVwZGF0ZXZzbiBmYWlscyB3aXRoDQpTR1hfRVBDX05PVF9SRUFEWSBv
ciBTR1hfTE9DS0ZBSUwgZXJyb3JzIGRlcGVuZGluZyBvbiB0aGUgc3RhdGUNCm9mIHRoZSBzeXN0
ZW0sIHNlZSB0aGUgbWljcm9jb2RlIGZsb3c6IA0KDQpJRiAoT3RoZXIgaW5zdHJ1Y3Rpb24gaXMg
YWNjZXNzaW5nIEVQQykgVEhFTg0KIFJGTEFHUy5aRiA6PSAxDQogUkFYIDo9IFNHWF9MT0NLRkFJ
TDsNCiBHT1RPIEVSUk9SX0VYSVQ7DQpGSQ0KKCogVmVyaWZ5IEVQQyBpcyByZWFkeSAqKQ0KSUYg
KHRoZSBFUEMgY29udGFpbnMgYW55IHZhbGlkIHBhZ2VzKSBUSEVODQogUkZMQUdTLlpGIDo9IDE7
DQogUkFYIDo9IFNHWF9FUENfTk9UX1JFQURZOw0KIEdPVE8gRVJST1JfRVhJVDsNCkZJDQoNClRo
aXMgaXMgb2sgb24gaXRzIG93biwgYnV0IGluIHRoZSBjYXNlIGFueSAqb3RoZXIqIEVOQ0xTDQpp
bnN0cnVjdGlvbiBpcyBleGVjdXRpbmcgaW4gcGFyYWxsZWwgZHVyaW5nIHRoaXMsIGl0IG1pZ2h0
ICNHUCwNCndoaWNoIGlzIGdvaW5nIHRvIGJlIHVuZXhwZWN0ZWQgYmVoYXZpb3VyIGZvciBsZWdh
Y3kgU1cNCmFuZCBzbXRoIHdlIHdvdWxkIGxpa2UgdG8gcHJldmVudC4gU28sIEkgd291bGQgc3Rh
dGUgdGhhdA0KdGhpcyBjb3VudGVyIG11c3QgYmUgZGVzaWduZWQgYWdhaW5zdCBwb3NzaWJsZSBv
dmVyZmxvd3MNCmJlY2F1c2Ugb2YgdGhpcy4NCg0KPiANCj4gQXNzdW1pbmcgdGhhdCB5b3UgYWN0
dWFsbHkgbWVhbiAyXjMyLi4uIEl0IGlzIGl0IGFib3V0IDJeMzIgZW5jbGF2ZXM/IE9yDQo+IDJe
MzIgKm9wZW5zKj8gVGhvc2UgYXJlIHZlcnksIHZlcnkgZGlmZmVyZW50IHRoaW5ncy4NCg0KV2Ug
d2lsbCBpbmNyZW1lbnQgY291bnRlciBvbiBldmVyeSBvcGVuLCBzbyAyXjMyIG9wZW5zIGF0IHRo
ZSBzYW1lIHRpbWUsDQpiZWNhdXNlIGVhY2ggcmVsZWFzZSBkcm9wcyBhIGNvdW50ZXIuIA0KDQo+
IA0KPiBBbHNvLCB0aGlzIGlzIGtpbmRhIHRoZSBzZWNvbmQgcXVlc3Rpb24gdGhhdCBJIGFza2Vk
IHRoYXQgaGFzbid0IHJlYWxseQ0KPiBiZWVuIGFuc3dlcmVkIGRpcmVjdGx5LiBJIHJlYWxseSBh
c2tlZCBpdCBmb3IgYSBnb29kIHJlYXNvbiwgYW5kIEknZA0KPiByZWFsbHkgcHJlZmVyIHRoYXQg
aXQgYmUgYW5zd2VyZWQsIGV2ZW4gaWYgeW91IGRpc2FncmVlIHdpdGggdGhlIHByZW1pc2UuDQo+
IA0KPiBJIHJlYWxseSB3YW50IHRvIGtub3cgd2hhdCBnb2VzIGJvb20gd2hlbiBpdCBvdmVyZmxv
d3MsIHNvIEknbGwgZ28gaW50bw0KPiBkZXRhaWwgd2h5IGl0IG1hdHRlcnMuDQo+IA0KPiBJZiBp
dCdzIGp1c3QgdGhhdCBhbiBleHRyYSBFVVBEQVRFU1ZOIGdldHMgcnVuIGFuZCBzb21lIHJhbmRv
bSBTR1ggdXNlcg0KPiBtaWdodCBzZWUgYSByYW5kb20gI0dQLCB0aGF0J3Mgbm90IHNvIGJhZC4g
QnV0IGlmIGl0J3Mga2VybmVsIGNyYXNoIG9yDQo+IHVzZS1hZnRlci1mcmVlLCB0aGF0IF9pc18g
YmFkLg0KDQpXZWxsLCBJIHdvdWxkIHN0aWxsIHNheSB0aGF0IGEgcmFuZG9tIGxlZ2FjeSBTR1gg
dXNlciBnZXR0aW5nIGEgI0dQIGlzIG5vdCBhIGdvb2QNCmJlaGF2aW91ciBhbHNvLCBidXQgeWVz
LCB0aGlzIGlzIHRoZSB3b3JzdCBjYXNlLiANCg0KPiANCj4gSXMgNCBieXRlcyAobWF5YmUgZXZl
biAwIHdpdGggdGhlIGFsaWdubWVudCBvZiBvdGhlciB0aGluZ3MgaW4gcHJhY3RpY2UpDQo+IHdv
cnRoIGl0IHRvIHRha2UgdGhlIHByb2JsZW0gZnJvbSAibm90IHJlYWxpc3RpYyIgdG8gInV0dGVy
bHkgIGltcG9zc2libGUiLg0KPiANCj4gc2l6ZW9mKHN0cnVjdCBmaWxlKSA9PSAyNDAsIHNvIEkg
Z3Vlc3MgaXQgd291bGQgdGFrZSBhbG1vc3QgMVRCIG9mDQo+ICdzdHJ1Y3QgZmlsZScgdG8gb3Zl
cmZsb3cgdGhlIGNvdW50ZXIsIHBsdXMgdGhlIG92ZXJoZWFkIG9mIDJeMzIgJ3N0cnVjdA0KPiBz
Z3hfZW5jbCdzLiBJJ2QgY2FsbCB0aGF0ICJzdHVwaWQiIGJ1dCBub3QgaW1wb3NzaWJsZSBvbiBh
IGJpdCBtb2Rlcm4NCj4gbWFjaGluZS4NCj4gDQo+IEJ1dCB3aXRoIGEgYXRvbWljNjRfdCwgeW91
IGxpdGVyYWxseSBjYW4ndCBvdmVyZmxvdyBpdCB3aXRoICdzdHJ1Y3QNCj4gZmlsZScgaW4gYSA2
NC1iaXQgYWRkcmVzcyBzcGFjZSBiZWNhdXNlIHRoZSBhZGRyZXNzIHNwYWNlIGZpbGxzIHVwDQo+
IGJlZm9yZSB0aGUgY291bnRlciBvdmVyZmxvd3MuIEl0J3MgaW4gInV0dGVybHkgaW1wb3NzaWJs
ZSIgdGVycml0b3J5Lg0KDQpZZXMsIHNvIEkgd2lsbCBjaGFuZ2UgaXQgdG8gYXRvbWljNjRfdC4g
DQoNCj4gDQo+IEknbGwgYWRtaXQsIEkgd2FzIHJ1c2hpbmcgdGhyb3VnaCB0aGUgcmV2aWV3IGFu
ZCBkaWRuJ3Qgc3BlbGwgYWxsIG9mDQo+IHRoYXQgb3V0IG15IGZpcnN0IHBhc3MgYXJvdW5kLiBZ
ZWFoLCBpdCdzIGEgbGl0dGxlIGJpdCBvdmVya2lsbCB0bw0KPiBleHBsYWluIHRoaXMgZm9yIHRo
ZSB0eXBlIG9mIG9uZSB2YXJpYWJsZS4gQnV0LCBJJ20gaG9waW5nIHRoYXQgd2l0aCBhbGwNCj4g
b2YgdGhhdCBsb2dpYyBsYWlkIG91dCwgeW91IHdpbGwgY29uc2lkZXIgYW5zd2VyaW5nIG15IHF1
ZXN0aW9uIHRoaXMgdGltZS4NCj4gDQo+IEknZCBhbHNvIHZlcnkgbXVjaCBhcHByZWNpYXRlIGlm
IHlvdSBjb3VsZCBkaXJlY3RseSBhbnN3ZXIgbXkgcXVlc3Rpb25zDQo+IGluIGZ1dHVyZSByZXZp
ZXdzLCBldmVuIGlmIHRoZXkgYXBwZWFyIHNpbGx5LiBJdCdsbCBtYWtlIHRoaXMgYWxsIGdvIGZh
c3Rlci4NCg0KWWVzLCBvZiBjb3Vyc2UsIEkgYW0gc29ycnkgbm90IHRvIGFuc3dlciB0byB0aGlz
IHBvaW50IHByb3Blcmx5IGJlZm9yZS4NCkhvcGVmdWxseSB5b3UgaGF2ZSBhbiBhbnN3ZXIgbm93
LiANCg0KPiANCj4gLi4uDQo+ID4+IAlpZiAocmV0ID09IFNHWF9OT19VUERBVEUpDQo+ID4+IAkJ
cmV0dXJuIDA7DQo+ID4+DQo+ID4+IAlpZiAocmV0KSB7DQo+ID4+IAkJRU5DTFNfV0FSTihyZXQs
ICJFVVBEQVRFU1ZOIik7DQo+ID4+IAkJcmV0dXJuIHJldDsNCj4gPj4gCX0NCj4gPj4NCj4gPj4g
CXByX2luZm8oIlNWTiB1cGRhdGVkIHN1Y2Nlc3NmdWxseVxuIik7DQo+ID4+IAlyZXR1cm4gMDsN
Cj4gPj4NCj4gPj4gT2gsIGFuZCBkbyB3ZSBleHBlY3QgU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZ
IGFsbCB0aGUgdGltZT8gSSB0aG91Z2h0DQo+IGl0DQo+ID4+IHdhcyBzdXBwb3NlZCB0byBiZSBo
b3JyaWJseSByYXJlLiBTaG91bGRuJ3Qgd2Ugd2FybiBvbiBpdD8NCj4gPg0KPiA+IFRoZSBlbnRy
b3B5IGNvbWVzIGZyb20gUkRTRUVEIGluIHRoaXMgY2FzZSwgbm90IFJEUkFORC4NCj4gPiBUaGlz
IGlzIG5vdCBhIGhvcnJpYmx5IHJhcmUgYnV0IHZlcnkgcmVhbGlzdGljIGZhaWx1cmUuDQo+IA0K
PiBGYWlyIGVub3VnaC4gSWYgeW91IHdhbnQgdG8ga2VlcCBpdCB0aGlzIHdheSwgY291bGQgeW91
IHJ1biBhbg0KPiBleHBlcmltZW50IGFuZCBzZWUgaG93IHJlYWxpc3RpYyBpdCBpcz8gU3VyZWx5
LCBpZiBpdCdzIHZlcnkgcmVhbGlzdGljLA0KPiB5b3Ugc2hvdWxkIGJlIGFibGUgdG8gc2hvdyBp
dCBvbiByZWFsIGhhcmR3YXJlIHF1aXRlIGVhc2lseS4NCj4gDQo+IFdlIGhhZCBhIGxvb29vb29v
b25nIGRpc2N1c3Npb24gYWJvdXQgdGhpcyBub3Qgc28gbG9uZyBhZ28uIEkgYmVsaWV2ZQ0KPiBv
bGRlciBDUFVzIHdlcmUgbXVjaCBtb3JlIGxpa2VseSB0byBiZSBhYmxlIHRvIG9ic2VydmUgUkRT
RUVEIGZhaWx1cmVzLg0KPiBCdXQsIGV2ZW4gb24gdGhvc2UgQ1BVcywgcmVwZWF0ZWQgZmFpbHVy
ZXMgd2VyZSBwcmV0dHkgZGFybiByYXJlLiBOZXcNCj4gQ1BVcyBhcmUgbGVzcyBsaWtlbHkgdG8g
b2JzZXJ2ZSBhIHNpbmdsZSBSRFNFRUQgZmFpbHVyZXMuIFRoZXkgYXJlIHZlcnkNCj4gdW5saWtl
bHkgdG8gc2VlIHJlcGVhdGVkIGZhaWx1cmVzLg0KPiANCj4gU28gcmVhbGx5IHdhbnQgdG8ga25v
dyBpZiB0aGlzIGlzIG5lZWRlZCBpbiBfcHJhY3RpY2VfLiBTdXJlLA0KPiB0aGVvcmV0aWNhbGx5
LCB0aGUgYXJjaGl0ZWN0dXJlIGFsbG93cyBDUFVzIHRvIGZhaWwgUkRTRUVEIGFsbCB0aGUgdGlt
ZS4NCj4gQnV0IGRvIHRoZSBDUFVzIHdpdGggRVVQREFURVNWTiBhbHNvIGhhdmUgUkRTRUVEIGlt
cGxlbWVudGF0aW9ucyB0aGF0DQo+IGZhaWwgZWFzaWx5Pw0KDQpUaGlzIHdhcyB0aGUgcmVjZW50
IGRpc2N1c3Npb24gSSBhbSBhd2FyZSB3ZSBoYWQgb24gdGhpcyBtYXR0ZXI6DQpodHRwczovL2xr
bWwub3JnL2xrbWwvMjAyNC8yLzUvMTU5NQ0KVGhlIG1lYXN1cmVtZW50cyB3ZXJlIGRvbmUgZm9y
IG9sZGVyIHBsYXRmb3JtIChza3lsYWtlKSwgYnV0IEkgYW0gbm90DQphd2FyZSBvZiBhbnkgYXJj
aGl0ZWN0dXJhbCBjaGFuZ2VzIHNpbmNlIHRoYXQgdGltZSB0byBpbXByb3ZlIHRoaXMuIA0KDQoN
CkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
