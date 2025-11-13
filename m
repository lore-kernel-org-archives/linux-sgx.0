Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011071.outbound.protection.outlook.com [52.101.62.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F54730EF71;
	Thu, 13 Nov 2025 19:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763062320; cv=fail; b=XyOOVqF0dGOYL7BFxcUzbH8WPAfjJWn/znaAYmtfuPikUfLS1hRjnD32y4FX3PLNPYhxXwR+AY5EyT9Lp47kl7fXm+K8vsUdE+/1Ocs8DjWkO068b/svKemOAYisr+4248A33KMbd3lqxOBvlisP4bBr50RJbZ6QI3y8d4NONnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763062320; c=relaxed/simple;
	bh=e3+6IGEr8+4vv4Ulx38rP1tZLdT0w4hoiBIAIgVtj5g=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WsrO+RzziEjObz+fOs4mHssHjVzBlILvCBY1hGPL2eKGni4ZoZq0TMJEF7pRFqucT81ar4Phe8F5CW84zOfIAdTMEQe8pbmbgJGyvb951f8e7emVNM0+uhO+nK7x+Kmsz/TxKpqN3cZrhMUgCgcDr0H0Gq0wubD87ztBPBsiJN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=Lz3ILeGJ; arc=fail smtp.client-ip=52.101.62.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="Lz3ILeGJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MXXU+YKbSQfVm8Y79vDByWN3R3Zi726hkqxVeAvXRA3VFdiDQQ5a9Kc4XMvXYQYkW8wgraucXuA3ZSJMtazQedUhu44ky3Wwp27l86tF4QsEUyDcN3hNQr4WeavcGtIWsFwASkgcms15jiIOH7PR0B0A+HTf4LrVV5vP/d1cj3VkO8GJFdXWcYBQuV7I2x4CcJCdIAIt+o3+OklwzYQptflTbz22VXqHYmiwc5+zPqGknmKbOfoohv+cz7qZsGLoBqr/zt0oF8fRSVQRfBPXY4yRRqsKcA/EAfifs6i66TSeNimcrTt1rOyCgjDoPxUuP6V29PX40tE6X0KFvyMvyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVAzouyChDm/JIjnm6jZV00sxJ9sGIHidl3RinbIRzM=;
 b=ZDEQ+zPVzWdEEIhXRJfGIABWaP0t9Ch1PHMWECGF1nsYvhg2+6Q3qzIYVZ/F40L39RItfMnaZrlBjOsAkM0QphbrxEfAtTbT842Zg9USf+sZLJ+pd5/0LLJ5W8AbYK5HA2h23O5A93gyioqqcFDpVYqeMOMSFmZwVZu64p9Z0oyBBvbABXmWYlh/c05FKHZfScYNa+PqZnW7x8OFyRYNPB2pw1K+V3sRQCbscp/ZauXWq824KkpHYghv7pWMdC2GeLjgeLHPk4YMgLZQNx97yHCl7TV+mDNANjXsWkxfs2E8Bnl3yxH3ahqS6bi0cBFWE2nxY4lP2TxwCFQlzp4dtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVAzouyChDm/JIjnm6jZV00sxJ9sGIHidl3RinbIRzM=;
 b=Lz3ILeGJNcdcjD1Q0m3wohjFd5k1BsGiVBRWwWwqujtakMglgOS4d0RmqBCLb6yhjna/mnaK5BRtEm7WyY54YkVWgQPqx5wHGtJRjz4aVjDD4khvUKcAkTm/OzxN94oGbNaG1ezSOxJfVUwtxMInJX8BJg/YbJ2p6gxeUTOqYUs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by DS1PR03MB7822.namprd03.prod.outlook.com (2603:10b6:8:21e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 19:31:56 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::b334:94c2:4965:89b8]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::b334:94c2:4965:89b8%5]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 19:31:56 +0000
Message-ID: <7a44475b-19d1-451e-94ac-5b5e61969198@citrix.com>
Date: Thu, 13 Nov 2025 19:31:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] x86/entry/vdso: rename vdso_image_* to vdso*_image
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Xin Li <xin@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brian Gerst <brgerst@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Kees Cook <kees@kernel.org>, Nam Cao <namcao@linutronix.de>,
 Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>,
 Uros Bizjak <ubizjak@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-sgx@vger.kernel.org, x86@kernel.org
References: <20251112202258.1310754-1-hpa@zytor.com>
 <20251112202258.1310754-2-hpa@zytor.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <20251112202258.1310754-2-hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0353.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::16) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|DS1PR03MB7822:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f9618ab-0e26-48cf-7380-08de22eb4e83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVVWUjBTWS9BQW83czNUd3loQjlGWllDY2pZbEU4d1hlaGFxVlhkTFQvT0tZ?=
 =?utf-8?B?RTRRMzdKZ0k4R1NQNzRVeSsvRnhQZW9RSnlhRnZlWjlDeWY0MSsvSXp0eVdX?=
 =?utf-8?B?dUJpelVyamluamFOV3prdStxVkhmV3ZJSGxuRUpFNmJFWDlJSzJMY2VSUysy?=
 =?utf-8?B?MTNieDhwbVJtYnpVZ3RCTE1LVzlWVVZlOW45T1U1dzd5bi94SzZrWUlKbGJX?=
 =?utf-8?B?elAyQzljVlk4T1h4MFk4NllFdnJlT0lVeXRDUmtLUUI2Sks3ak9saUgvRlQr?=
 =?utf-8?B?S1NOY0pWaFdFZWY1MXdRY2Zla2JhK2VSaExCVTJ5OVovUkloRXFPQ1B4aDcx?=
 =?utf-8?B?STNldXNzdkdzamUxSitYZDhEOWlNaVB6QXhGR0NxZ1dyY3g5NVZQT2k5Z1VI?=
 =?utf-8?B?Q2QwQnNjQ3FDM1BZQnlkNk9UVVhRS1cxVHNrUFp2TitzSHJjOTd4RzRwSm41?=
 =?utf-8?B?UzdPSjIzUFVpRDd5cVZkRHhVK0EycFNVbDAxdFFHdk9JRFA5SXlORlV6U1dq?=
 =?utf-8?B?ekMvWVhPVjBEa0t6THlKdVliemovKzEzQkdDWGdHMDdVd2xMZ3oyRGJRZ1U1?=
 =?utf-8?B?QUZLdzhmeGl6TEhYYTFya2o0ZDg5amFUZkliMDV3T003MHVvSXdpR1kvWU00?=
 =?utf-8?B?eXNaL1ZFNXNyWGlUNndpVUZmaXJwVEx5Ym1IYUF4eVBqT1piQlhLeEw3eTlz?=
 =?utf-8?B?dWMzbnV4Unl1YVZkZTNycXFKUEJ0cmRnREFBcGdodjJCOFJkODRVeHIySDZt?=
 =?utf-8?B?dXJMSnR4RGpRdGNsVHZuNnU2MDRnVjhEREFvWktIQjREU2NmbWV6UEc4VVNI?=
 =?utf-8?B?UndNanBMbDUwMmFEZXY3dVo3dEMrbHN3NDN4U1NPN2ZTZnYrVjR4Zk9IYzMy?=
 =?utf-8?B?YXVFbGxMbkpRYWNsZUlFZkNyQXFRUS8rakhtMDlBYm9Oc3VnR1l2SU5vN0tB?=
 =?utf-8?B?ZTlZN3RPWnhSbklXRXNlTEJxdVFNVTdiTERuNkhVaVJuZVJnYS9LanF0QTIy?=
 =?utf-8?B?TXkwR2t6S1dVenE3QVJCbmE0Zzg2TDFlV0R4OXJ6UlZMUStzRHppNEZKdC9S?=
 =?utf-8?B?Wm9OamZCODNHOTJMZjY5UGNWaEZDdXdRSUppZi81VUhjK2VtYmxrTE5IMSs2?=
 =?utf-8?B?MmNHZmx0bDVKN2wyUGQxUXlsMUVVM3lVcnRQcDM0VktRMFJSTE1vN2Z4N0VY?=
 =?utf-8?B?T2NaeXB5UCtEUDBmT2t3WTZpTGV5eHErcVp4bFRnc0s3azJPY09aOXp5RWhl?=
 =?utf-8?B?QTVtNzRRMXgwbzdJbjNoQ2lSQXIyWUxwei9Qd2MweFBvR1h4aTJseFIzQTBU?=
 =?utf-8?B?Wnk0aEh1NnlmdkU1cm1Xc1FqYlVNWllJeFg1MmtibEhJTjlNVWFQMnlwWmg3?=
 =?utf-8?B?cU5jbzVKRU1BaTdNdmpUUEhIMzZrYjgwaFZ2M3VnUkp5N3dnbHZGcFFRbE1p?=
 =?utf-8?B?LzJMOFVZMDRWSyswRjkzRFd2NlJVSGJ1bU4wTzMrOU9mMGZ6YTBoMTdyc28z?=
 =?utf-8?B?eVB6N1RxWEZYOVdrUUFmNzhSYkpTMG8yNmxFNVU3TDN4NzJ1a1VNUG0yajMw?=
 =?utf-8?B?OXAyMVhvaU9NNlZxSFZoR1E5d3VKM1c0VEZFU01aRWZha3FudXQreHp5ZDIw?=
 =?utf-8?B?VlV1OXpjVy9OYmV6OGhkYWFwNnY5ZGl3RWtxdTcrVElaY1hXOGJwV3U4Ni84?=
 =?utf-8?B?YVhHQ0FYT2MrS1dmRTNxUDJGTGZob1FJTjVBcnY4enliT3lFdWRUYzNDbERQ?=
 =?utf-8?B?VGRsL0p2aURZeWszWFFpWjI5bE50Y3hzS1BSdUlxRUJFNmVJZGw3Si9qc0tG?=
 =?utf-8?B?V3lHS0dqWVRiRS8zUEFDRnVHQUtvM21SMVdjUTlUU0V5RzZxajBwMHAvVjBT?=
 =?utf-8?B?TnZnbXBhNm5OWjYrZjR6WC9kVFZtWlBWT1pKaGJ0b0s1alBWTWY5ZUlMbXc1?=
 =?utf-8?B?NnR0Qzcwclg0SnoyekIzNVMrQURwTXZNeTcrT290bXROZ0Q4NFJpeW5uVHl5?=
 =?utf-8?Q?f8SoDI/hkuQg1HyeQISZEeNjBFPGys=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2Y1aHhjMzFYR1hqSnU1b09URFl5NVV5UU1PNTR0aHB2VnlDY2lDQzJBNzJ5?=
 =?utf-8?B?ajB2YlBzakRmcWczVW9hME9qOXlNeDF6R0cwS2RKcE9GM2tzakxIcHNiU0pO?=
 =?utf-8?B?WW9pbFBpOUd4Z2I4K3hYRWJoRDZWNGxPUkpCNzlyWk5WakRudURybE5JY2Zn?=
 =?utf-8?B?NDJQSVhDRE5rb0tEVVMxbUVTb05yNDNEcTl6WlhkMkU1N3ZpTDAwenRvTGx3?=
 =?utf-8?B?Q1owakJzaHNtR3llYUp0VnE4enFwMFBaMjZheFl2NG1uVkV6RGJiZDVLWmRz?=
 =?utf-8?B?SWZLelF6WkZ0YmduWVpGRFBQd0F3enc0YUNWb2liNDB1ZjM0LzNLNEdCYm9N?=
 =?utf-8?B?LzhBSGJNSVJTWFp2N0E5eHB3V3FxZjljSzQxMlR0Rnk3SXFBdzRnQ1Q1anJo?=
 =?utf-8?B?Zzg0ZmQ5Y0QrQXk0TkFDSExKTlp2c3NuZTg0UnhtNUNwV2NIQS9BMUx6L3Fy?=
 =?utf-8?B?ZW85U1lBT2x1WjFNdjRDS1AyRUFkZlFCYTN5VGQ1cXRKbXRka3FRbEVwRVRQ?=
 =?utf-8?B?K29CdjhNc0FIS3ZHMGx3M0JFVXVvVHNQTUREcWlQVnJIK2VqeWRtdDhtUUVS?=
 =?utf-8?B?c3NFMU1CTzJZZ0hYSG1oWld3Qmg2M1NucU15RHZ1VitSRGtaOFF5WWdieWMv?=
 =?utf-8?B?TnUzZDBac3hldWl1SDJqakNUQ3M0cnRjcndnUUEvaU1OMVJMNzVEczhYVk1L?=
 =?utf-8?B?RlZETFV4YXpnYUVmUHAxS3pjNWdIaDl4MFhEaGFqQk1BTE9SVm5pU3A1aHl0?=
 =?utf-8?B?OTJlYmQ5cnpVMWJEbjAreGx0OWFENnJiZkpuS3E5UWNUUWNqUDl3bVp1Skl6?=
 =?utf-8?B?clp1SGxyN2dSZnV2d29IcUZ3Q1N2V3NhZUhyd2NXTTgvTXFQWXlPRXl5cnor?=
 =?utf-8?B?dE80SGVkNUk3dXhaSHNGTUtCcGxRRlhvblB6Mk56eFptOEZFdXAvUFFQSis5?=
 =?utf-8?B?THArUVdnbmVEM25RSU5pVHNiWHBoNzh2NU8xVXZsY0FPdjNiZ3M2Sm14ajNL?=
 =?utf-8?B?ckVXOVNCOGYydlFNTUJ5TWExM1FqUWY5TlFKZ1N6NVNRZTFEOW1oTEZZV3VC?=
 =?utf-8?B?aWx5bVJqZTQyQzRRc3E3OW1VZ1lsZTZCVHB2MEE4YWpRL241Z0pXb0dJTEo3?=
 =?utf-8?B?cVRUTVVYekdhMENGTnZMMHpCRld3VXJ4c2tUS1JGM29ueGtRdFRJaGNkcUFT?=
 =?utf-8?B?NFpDNjZsZVQ3Tkg5c0w0ODhVRmNuK2RIZXpnd1FlVkh5WjZoVHg4ZlNmWVVO?=
 =?utf-8?B?NldENkgzdC9qV3dteXJQZVJZSE9ybE85b1hhR0lJc3ludlRxRytmcGZXRGJy?=
 =?utf-8?B?eXpoQzJkdlhPUnl4TnBJZjgyL2NVRE1kMEtPYVlXMXg4WWU1S3Rkd01OcnBL?=
 =?utf-8?B?N09DbUk3ZWV2TDVjSWlCSnlTc3lXQUdvQlpwODRIa2FQRVozdm00ajFua2ND?=
 =?utf-8?B?VGRWbEdpVnBBUmswOFlYNHoybk1XTmFUeGQrUzQwcEw1MVFFM3lTcTJLVVU5?=
 =?utf-8?B?Y0NEQVU3SnRnV1ZIWWoySkxxL1ZORThQU0lzV2FFd3gxejlMT2xXeVJabXRS?=
 =?utf-8?B?cVBST3NBcmtucGdhTWZTMEFvRHFsYXVhaEZBVFl1Ym85dmdvelBBOGRUME1R?=
 =?utf-8?B?VEFZekpKemp3YXE1OWcwN0JHOXZYRHozUXJnZHVVUHB0eWpld1ZIY29xci9s?=
 =?utf-8?B?MU9WUVN0UFErd2g3LzlDTG9iM3QxUFF6UmRrc2VhWjNOM09aUzF6MHFKNXla?=
 =?utf-8?B?dnB3ODVvWUMzejNpZFBDUnREb3Jpek54YUo1NjlSb3A4Zi94V3JKOGVxdnR4?=
 =?utf-8?B?OGxBUENxWnFMUG4zWVZ0M3hBVDZrdldheXhaOEZ0RUVuQnRYaXk1MTFlKzRN?=
 =?utf-8?B?Q21RQ0w2OWl1SDRmUXlDbjlKZytIa2crOHVNZzluekdJaXVqNm1UQ0dONFRB?=
 =?utf-8?B?WDNkcDM2NmhPMk1ycURlV2pPMHNLNUJ1cjNzMFloYWpqSXFIY1BuZVZVYVpB?=
 =?utf-8?B?MHNTU2lHMk0xTXVyTERUVHJCSUVxV0RWR1lPKzJFMGt3bDRWSGJEd3pxY2p0?=
 =?utf-8?B?SHZpL1hSdWdrU3BSVkNBUnFMVEJJbFRTNlBLbzFZZExaOHlyZjRna2RNUmxH?=
 =?utf-8?B?UkFBRERLdEtmRFgzbExuLzBjVmJ0NW95alBFRnU0SWtJQWVTU0VscW0rdVpO?=
 =?utf-8?B?a1E9PQ==?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9618ab-0e26-48cf-7380-08de22eb4e83
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 19:31:56.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNdvHvCnRSM0Z7F2UwkguWProsNQGfjYqJXhZ+eNBuaD08+Pe1WaIYG9PBKCjcCNrvc2zoqyno9ILUghWTBOXulzhfns+QZcm3P48MBGdDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR03MB7822

On 12/11/2025 8:22 pm, H. Peter Anvin wrote:
> The .so files for the vdso are named vdso*.so, and these structures
> are image of the corresponding vdso.

I'm afraid I can't parse this, and it's not obvious what you're trying
to say.

>  Naming them accordingly is more
> consistent, very slightly more compact (by one character...) and
> simplifies the Makefile just a little bit.
>
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>

The change itself looks fine.

~Andrew
