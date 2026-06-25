Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14E9372EC2;
	Thu, 25 Jun 2026 01:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782351764; cv=fail; b=fAcrKhGSPC0MnGekTIcYAioSN+hi75DL1RCMb5PkuED972mYYpURO9tS28JH3P2u7yZqGUJtRPHA5wz4a+cLobDbZi8+MEOmCqcV1/DUTWcJe/0wykOlrHs3/NOSAzIcBqKeqg071ruGF6c/zSEQ/glKOzrQr8UulL3aTQS7nsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782351764; c=relaxed/simple;
	bh=Ldq6DaPnP9US5ChQ6fYp1ilsV/KNNPY5cdS2UnKVE8I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bMJJ9MyP6KFitLd+YJpRTUEf/Lqf1vNz3BNOVfa0m31DyNoqRJIqhtkwGCD3swplUj06WtIPs1rg8+jxSvQfKK7horOi71BurkfrkEB3rwce5/Bt68utaV3J8VBnQxbIB4EyvyY7BJRZJ5j+89/RCXn1ptHGTalys8WoMXxj89Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hhi8uQGT; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hhi8uQGT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782351762; x=1813887762;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ldq6DaPnP9US5ChQ6fYp1ilsV/KNNPY5cdS2UnKVE8I=;
  b=Hhi8uQGTMf2IrEeoLdyFo121UzuT4dT+ebXracJitxl+Hnvh5WufJq+w
   fjyYHIt48MvGfqzWjc2OtO8T9mL2ScUavafNKjAaGDA6RkvX21UxsQV7m
   gR4R+SKLqDDbS6zPn43fojDLkFqOaLfNgYFRmCskui2R5Z/vf+qf/fBAX
   V0x6Abtv5wocvbj/KlxqQE+DFikEzm7dk4A3+F4PXXJhPm53gLtB+Vqg3
   EK8pCATZciSkBfw/UbRvCAcET7yHTaSzd27XxV4YcfR10QLig1HbiTKzh
   /tfW7Jf4E3FyLl9Uhh31n9LdAbrw3VxgvnV80bhU3HM+beH3qLwNfM/t0
   A==;
X-CSE-ConnectionGUID: Aol3xQ1mSRSOXdNVCDL1Wg==
X-CSE-MsgGUID: mNTbNFSESaq+USVXBBAIwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11827"; a="86967077"
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="86967077"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 18:42:41 -0700
X-CSE-ConnectionGUID: mKOFId91Ti2ZYRGzghk1qw==
X-CSE-MsgGUID: +uZt+a82S3a3UKQ16m7Ouw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="247780896"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 18:42:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 18:42:40 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 24 Jun 2026 18:42:40 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.56) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 18:42:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oSfZYcolQEifwBXsEoEaCeY+twrlh9fvaN3b9DGquV+v+K/63N2V2BeDQaFi8s95pQzsK8Cb8rYDyb3dXMQ20xhQf/XmyyCbVcQTRBnJBwSg3JDX3mP8DjZfj+/synXpiXX4e0G51rRofnsR8sS/39jOpVpg1nZcC3ECgS6kBcCdz8Zc4Vc91QGPxBDsOQfHAv50XLfZ0UwDUgtGXwaR1LkVXB7hKhg2syPxSt6S3XX7TVVnbCmZemGhBAtm5r4u3esm6Rw6QK4pJHBX4IAkQxuJgusAJLCrBR3j1tlO8TykbYZpeo9QtZXlM11USZo5Pt2FzOH8FQpC42522HMCyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4I5NLl7Lf/Hrr5j25rR3pJKxBxuUAIAGAoxDxeIPKfs=;
 b=A9yko7QngEezbALBjMtfd/lCkQywlw58dk7sOy/pyF1ta46TetbI+/Zap7pq1m/zTU6QV7xxMyyLi0H5Gd56+wlppQdZ9GeQQ8yjn5qDMzLeMLoL5LHfj95Z5LNDsBLB3kYEtm8N5pxTspuu/A4O5TCtWzkDuoCxr0xPzJGWTLoFLxjf+YvOjiJrncAKv7enyxh44bpGHyTst3wIqF4mMYoz8IJPgW3mpEEqZUrO2aOePDEs8cFnXqkd73T7x8SJ6xFj8XamlXXiImng5ztpc+Lcg9uRCME7ddyyVRmNDBVJtO+6u/aQJRmWnFv+GYGpRZvc7oK7nuRMc+m6GHg4BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8455.namprd11.prod.outlook.com (2603:10b6:510:30d::11)
 by MN0PR11MB6010.namprd11.prod.outlook.com (2603:10b6:208:371::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Thu, 25 Jun
 2026 01:42:36 +0000
Received: from PH7PR11MB8455.namprd11.prod.outlook.com
 ([fe80::789c:dda1:63ec:6dbf]) by PH7PR11MB8455.namprd11.prod.outlook.com
 ([fe80::789c:dda1:63ec:6dbf%6]) with mapi id 15.21.0139.018; Thu, 25 Jun 2026
 01:42:36 +0000
From: "Miao, Jun" <jun.miao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Du, Fan"
	<fan.du@intel.com>, "challvy.tee@gmail.com" <challvy.tee@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"qiang.zhang@linux.dev" <qiang.zhang@linux.dev>
Subject: RE: [PATCH v4] x86/sgx: Fix RCU Tasks stall in EPC sanitization loop
Thread-Topic: [PATCH v4] x86/sgx: Fix RCU Tasks stall in EPC sanitization loop
Thread-Index: AQHdA+SJRd+aIaJVdUmq1HG/EOyYa7ZOSHIAgAA1FqA=
Date: Thu, 25 Jun 2026 01:42:35 +0000
Message-ID: <PH7PR11MB845529BA732329CFFC2C59EA9AEC2@PH7PR11MB8455.namprd11.prod.outlook.com>
References: <20260624142011.2965809-1-jun.miao@intel.com>
 <27a2dffc7c0d4af5898b7d9d6c65612f9868ca9f.camel@intel.com>
In-Reply-To: <27a2dffc7c0d4af5898b7d9d6c65612f9868ca9f.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8455:EE_|MN0PR11MB6010:EE_
x-ms-office365-filtering-correlation-id: 16a34f86-3758-4778-8273-08ded25b0883
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|4143699003|11063799006|56012099006|5023799004|3023799007|38070700021|6133799003|18002099003|22082099003;
x-microsoft-antispam-message-info: UgclFlF64oPHBx+gkp1brvFkqies9hR/T+Ca+TiQhKr4LuOc/I3m+4NAN/Y4keCur6P6pkLg/UO3K24vZSHtndKQM+BLqDvHSmWYdWjIbTrmIkFnyHYfDScZfmROjqXhkylg0xuc/8bJA8Sl8ZmCpansV0MTmtD2kAdMsgiMtLckd2tCJXsrD7266YroW0as7HLCDdhTRR4rtjAoZXAdsIWMqD4OsTV+iQG9tGV7kUOzEivfA/QbkBve5MVPUAKQy9l8SMH0Qqk+u9Za7nFLQWVMp0seK/n4V+DmanTW0M/LAC3jl8VNIPjGYSKvndb27UJIF+Ehf5fOxLdBbi9LykngBmplrAhb0M8eSnP6XkB8luqgfWYFCY35qLLQaBGwocgYs9O9A08E3xY1EeM2y6k8uRRPB3wxQGkdCTDkhEcVpR0Q4sE8E8r3sFsSYcqF9Ge1/54x9Z1XcymPBV2qX5rO0Qx6cNjth2fRhJ1TnXhZ2FEtgmrQ9oqwsjrbdZSZjljutpeaQvxiTQN7QwzfrSe50QhZ9NUwg4GRfTAPBAGizmERLsUW+9WLEHskJivcdp0ZU9npC8hrmEfZQFCFdt90E8eQ4SvkEHRpkROAOKBZtej20EX8XcdsIvMIaIFwzmmFwmkCMkZHIyviydAx70LS/gSYvKOqRKpfo02HsEdmy9ZCJ2edh+2tQyiTi9wp5nWHs3v7ZUnU6Pl4m23CtAuJzrRev1ij0IlBLJrs/Sk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8455.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(5023799004)(3023799007)(38070700021)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X/LE6Q1kaVHousL3lRpwUJ9tCnqBo/NSPQ3nuB+zPfx6hUEnWgQ5hKrQ6N4Z?=
 =?us-ascii?Q?WDMDWekVIKp8VVfWHRvxGraJcHTMTuE1Dfy4guEQZ1QQmJFlUnbX1eLO2cID?=
 =?us-ascii?Q?4Z6/bwXAVMzJqIDXocqYIDJN1EbSEcBt9aVWdzuxsiuLYqoSQDswzG3PmfBA?=
 =?us-ascii?Q?1NHQJ5BWy1y7PQrRzRPm0non9fAXtG0FjTH9OE4JXM5zIl7lhPmFInTOY9IA?=
 =?us-ascii?Q?6N67ci55MAOoykoAMjSdfMrrVu3J9AzSIseSuPLR6v2qob/izfORYrQA4OyX?=
 =?us-ascii?Q?/eBXpWz4ntWjiuMMc4RZhfTIn7wz0rsV7LLyWqscBX/czIrJme3Yep4xAVZt?=
 =?us-ascii?Q?6kXuSE+pv4phBk74tNeEKyLarnSQ4u3AvRT7sRupmLiQzHtk2nn6Ip7fgrwO?=
 =?us-ascii?Q?/Xi2qrxJgPTSkzxKrxHKI56cm8bK6UtxUYv80cDaZzyj4XquqDGSYTI3it0P?=
 =?us-ascii?Q?g1zHucgXmZ5nZkbmwIuCzhol8cy5sJngve0O0mnd9v3mwKqzSChNwbJnJkfy?=
 =?us-ascii?Q?mJZ5qjiRyJjx/ndtYcgra4C8ltW7hR7ROq6BTBLXgxTec8+kYt1JYQOKiy8G?=
 =?us-ascii?Q?heWVUNRcHg4B/MGgne6ljhlFpTcQKmpiH4KAOZ9KmK3yRskJjYeG8E9qlnZv?=
 =?us-ascii?Q?ggflPrxjYsEzu6xHOrbB30BnFAyPKCDK+bKCUrbBpRWrVkon3PriEXLouYtN?=
 =?us-ascii?Q?WgLNHJsDyPrxSDdEdhnhObC336fqfVEkqsEXgK/LhBvgMOMwSWG+ORJkxkkl?=
 =?us-ascii?Q?GF1P7JBald/wsG4lejmJGgekvhxJ+dy9JHIS1D8dWw2E1320h9rHZCbTP7pV?=
 =?us-ascii?Q?GRdctNo4SHl3SKHG5alqm/h3KCU7iGGVkDwBw/fjcYiLmLunKTksD8a7NWuX?=
 =?us-ascii?Q?GHz82hzLWQfL43dmEczqMs4PrDlJYqeN7DtjVjRJgXI9fGYyyaNLlKk/z30U?=
 =?us-ascii?Q?UmTFxszLMrNW79pwpRNoeydnI8/rSr7J56UbiZFxIhZZFB16xN9vlal7RTPg?=
 =?us-ascii?Q?G+UYTDVS8HtwJVI6c8+SqbKySgxx3Vin9NyFnmLlKlgVqcSTP4S4DBtCNJ+A?=
 =?us-ascii?Q?H5amtEE5ERMdXYRmeLWUZxnG8JZh10c68KBqxQiOdd5ppymerC+Y0AuxE63Y?=
 =?us-ascii?Q?BL+gs/CVJd3yk6CoQRUzDurc08Su35XEuWFgNkLRiy1+UEyw32WXzIulC6uq?=
 =?us-ascii?Q?oSSqXP8KXfdlyh4kifoJaY1isdurBl9M/Kb5fxSmPfOHetPslu+RhfYEkySX?=
 =?us-ascii?Q?6worHEjd28ZH50oF7nmDAPlFtiCVJpe6/Sjx/nByy/25UqnmIPVUdqvZjotM?=
 =?us-ascii?Q?EJFI+jT46SaPiCN3tlWNBHjsdAtUVZt1AmTDleDcSLRSE0PlWA52rt2D5buK?=
 =?us-ascii?Q?UTmti9XcdAP+l/m25sWKxQC3WW/355szDLu+sZnLm4pnbViTvnC94fB7vVPu?=
 =?us-ascii?Q?+LhxBt8RqqOJdZCvxnHZM6eL+nfmwE9AfrW2TSo3F+eHaapOVbk+aMJZtDtV?=
 =?us-ascii?Q?902jnZ2ctjNv9d8AerXtKNYgckBQfdGgyCOMLPt0bJMMyEANfpSmBuI7GfK5?=
 =?us-ascii?Q?ALfIep7ettcaUmdd2+aLbB+uqYhYYbKow8AGGsZdAWASMFuOa0QXawqmz91e?=
 =?us-ascii?Q?UUaf19bAcUMrW7IeGiAsMQKnBZh4goJyS0N0oGD/sqwxT0NU7inWWE6sFM0N?=
 =?us-ascii?Q?Dc/UT3CKhzedts0py/wDFllfOIPuDqSThS1N8WlOudCUGKUW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: PLz2D1ZAj56oB8LbF8HPg4jwQOP0rpKFte9YphlJkXIN9mRVZli8zoStI3SKeRVIeaT7J0aCA3bSUEr/7px6XBIB2an/oBbslY2BiSSCmoKfHMaEMqtCgGmDnQqQbYbhGiXid+cSioHMeLeu25QJkwqq7OudZL4nsCib3BAg/neD3Cz9kP6ZR4Xh2FtuyyG+ji2WnQUtk+S8tCXGLgkCFgj/bh3VZT8jfwEOHWyUQIT1S3CM6ubqnwogQPFKCKJ2bn5CYr5xHrdfAfyY/zq+xwKWChKSOdtvkLPbxH5DKO/LGZXkmyHtT9bg7x74Bs94b+r1j/W0VOy66ePb/LTYAA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8455.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a34f86-3758-4778-8273-08ded25b0883
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2026 01:42:35.9335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YqWQnD5eiuLG5QU1r8CfJLwYmYXmc7q5AiUtXY8an0xIC50SYfXcT6u6WXcZqty1/3hgP4u2n3uW73l1F8Bmkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6010
X-OriginatorOrg: intel.com

Hi Kai,
>Some nits in spell/grammar below.  Sorry I didn't go through any spell/gra=
mmar
>check last night since it was already very late for me.
>
>Btw, the v4 is quicker than I expected anyway.  We are still in merge wind=
ow so
>maintainers are not expected to review this.  For more info, see "Merge wi=
ndow"
>section in Documentation/process/maintainer-tip.rst.
>
>On Wed, 2026-06-24 at 22:20 +0800, Jun Miao wrote:
>> The kernel resets all EPC pages to a clean state in a loop before
>> using them for enclaves.  The number of EPC pages could be large
>> (e.g., GBs) thus resetting them could take a fair amount of time.
>> Because of that, during
>
>s/fair/significant
>
>> early boot, the kernel resets EPC pages through a kernel thread
>> ksgxd() and there's a cond_resched() after resetting each EPC page.
>>
>> This is fine in most cases, but becomes a problem when there's other
>> kernel code waiting for RCU-Tasks grace period but the cond_resched()
>> in ksgxd() never triggers rescheduling.  Because cond_resched()
>> doesn't report quiescent state when it doesn't trigger rescheduling,
>> the thread that is waiting for RCU-Tasks grace period will need to wait =
until all
>EPC pages are reset.
>>
>> For instance, BPF LSM subsystem can invoke synchronize_rcu_tasks() at
>> kernel boot time.  A VM with a large EPC assigned and have BPF LSM
>> enabled can take
>						 ^
>Remove the 'have'.
>
>> a long time to boot, with a call trace triggered:
>>
>>     rcu_tasks_wait_gp: rcu_tasks grace period number 1 (since boot) is 1=
30631
>jiffies old.
>>     INFO: task systemd:1 blocked for more than 122 seconds.
>>     ...
>>     task:systemd  state:D stack:0  pid:1  tpid:1  ppid:0  flags:0x000000=
02
>>     Call Trace:
>>     ...
>>     schedule_timeout+0x157/0x170
>>     wait_for_completion+0x88/0x150
>>     __wait_rcu_gp+0x17e/0x190
>>     synchronize_rcu_tasks_generic+0x64/0x60
>>     ...
>>     synchronize_rcu_tasks+0x15/0x20
>>     register_ftrace_direct+0x31f/0x350
>>     ...
>>     bpf_trampoline_link_prog+0x33/0x60
>>     bpf_tracing_prog_attach+0x3c5/0x5f0
>>
>> Replace cond_resched() with cond_resched_tasks_rcu_qs() which
>> explicitly report quiescent
>
>s/report quiescent/reports quiescent state
>
>> regardless whether actual rescheduling is triggered.  Resetting all
>> EPC pages in ksgxd()
>
>s/regardless/regardless of
>
>> isn't performance critical so the extra cost of cond_resched_tasks_rcu_q=
s() isn't
>a problem.
>>
>> Tests showed this reduced the VM kernel boot time from ~50s to ~700ms.
>>
>> Reported-by: Challvy Tee <challvy.tee@gmail.com>
>> Link: https://github.com/systemd/systemd/issues/40423
>> Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page
>> Cache (EPC) sections")
>> Tested-by: Challvy Tee <challvy.tee@gmail.com>
>> Suggested-by: Kai Huang <kai.huang@intel.com>
>> Co-developed-by: Fan Du <fan.du@intel.com>
>> Signed-off-by: Fan Du <fan.du@intel.com>
>> Signed-off-by: Jun Miao <jun.miao@intel.com>
>
>
>Btw, English isn't my first language, so feel free to use AI to improve th=
e above
>changelog if you want (I just did but not sure the changes are all better =
though).

Thank you for your detailed guidance. I was still a bit careless.
Got it all your review, I will review commit log through AI again before pu=
sh V5 to make it more perfect.

>Anyway, feel free to add:
>
>Reviewed-by: Kai Huang <kai.huang@intel.com>

It is my pleasure :-)

---
Warm regards
Jun Miao

