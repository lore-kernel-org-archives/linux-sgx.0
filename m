Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897F78F5B;
	Sun, 21 Sep 2025 09:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758448790; cv=fail; b=k2jGJZy4RUxk/WiXeopsJkoxDinFlZmoaphxAjXFqqx9q4QBtO8wTiA/zHuSETE2XKxFHLx0jHvxn3SzGTAuqkUS991LFxoPcJSvQha70APwLyQKiMU+dfDLfCqxdv5/uApBGrlnpD7c1hrVIKJ0zY23jDZc767CfagZgz70TqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758448790; c=relaxed/simple;
	bh=TF2l8GcP/G2zV+uP7cTSl/RBk4uo8ArjmKiW9xdM2no=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=stFxap1f7I/MHxDOj9gEwEtq424agmsz3F7xqQLYIpzo2PANXcYx9ialiLSrjtaQzXQeiAZQHj/RpyJtDKRpW2cPs5Rl99FLXJsb1feCf9Ov/rsw6cv/8fBSIGcuJIp+YyowhREqad/UDcZpdAqnoG8PZslBRj33pGAvUPu9MyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXhWDt5g; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXhWDt5g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758448788; x=1789984788;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=TF2l8GcP/G2zV+uP7cTSl/RBk4uo8ArjmKiW9xdM2no=;
  b=OXhWDt5g8EE16Jh+ZgKTg1qMCHspNeCM3ynOIzbaNIII9f9n3lkGiMqN
   +e1BZAeIQDszrxZLwNmsVgkE90Vwrcc5C4b+vaTPnszkaatTwq/EIzHbX
   km9ZkWPvG0aU9IhFobbWyZI3VI0lGUJwQozmjHrWSuhYhO6DbgBCLp9Dg
   Fqk8TqNzAEjlYcOlxkBazujfThU70Ty5dR4jxXjAND/+3PZQ2nwSp8M5C
   zNeM0ivhlqUV82oBNU83GiwmQ8kI81syUzYPw/KF5HKD9DJU323kirY8M
   bW8pkgLsUacTmEcIOvhQdZsB8mmtH5R45TYEoTW2+RzD5pZJPjLD4A8vn
   A==;
X-CSE-ConnectionGUID: EO4+DFtURNeoNyqk8oEuQQ==
X-CSE-MsgGUID: 0qK8LIj4RY6XkMyW0RfKWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11559"; a="63367107"
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="63367107"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 02:59:47 -0700
X-CSE-ConnectionGUID: mMJDe/hcTvylQhoIZ1o4Ng==
X-CSE-MsgGUID: fzkw7URfTr+YTAcsv8+Kug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="176061321"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 02:59:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 21 Sep 2025 02:59:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 21 Sep 2025 02:59:47 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.50) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 21 Sep 2025 02:59:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b/nJ6GkhhrKIxb49np6RF7RkjVV44jN7jHHUIkQeXSyeNsfBpwfaEOji3gXPrhJeNkoNW4dpO5nu3eOc9CP7BuzFXZYGTZXQg3wMtP6FVReLBUD4x/ewnbA06orFXsRUAGWNAHqJq4lcN385S/dqGftN+9Iv7vCGEzjP/EEbWsuRaw7OVZcG6tOP1GRUrz++aG9brh/nLPvdk7N715WQuqYkgd14Emc9zLmvDNQtRX0AsPXr5TNtdnsUzCLeXQIGGotWSZajNzbBzl/VozbDvNjJvWbWIYWvYqa39zobOzUXrN5az4aLhcjVPLDbqIB33WmGsurV1fGdd3K3T5V09Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9j/BH/VOZOoAly4XjzQWA33iIV96+fPl1A4Xl0/1fXI=;
 b=Pp9tpE3v3VC8VwPO7r/4OzIkcC7VNbVPihRmQFN59JyTrW/TY69vc/Nz4THP6k1eyhXqEAn2Ui3QQA17ZkKpyDKdOJjiskL8w3dLc7vHnaveMRbvQSmy/ccb5YYAHhmj39UW5w5+I3jS7sDapNwVDguFZ1/y8Ay7hFyBzeamu8rI74N7+NWlOi6E1yS038xBlan/GVOsuedbVilSK8HLR0jnXJI911CwOnN1olwiM7Tp/00/JhQWheDO+sEexqgKWvtENK1ADPbT4GgfhCAn6JTHax64qFSaVtJRqdkW8Qs9/9SwMUT+sZrv90jz/wf458Lu595ilwWaizkVQQZTlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SN7PR11MB8111.namprd11.prod.outlook.com (2603:10b6:806:2e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Sun, 21 Sep
 2025 09:59:44 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9137.018; Sun, 21 Sep 2025
 09:59:44 +0000
Date: Sun, 21 Sep 2025 17:59:33 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-sgx@vger.kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Thorsten Blum <thorsten.blum@linux.dev>,
	<linux-kernel@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [PATCH] x86/sgx: Replace kmalloc() + copy_from_user() with
 memdup_user()
Message-ID: <202509211747.1edb60f-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250908201229.440105-2-thorsten.blum@linux.dev>
X-ClientProxiedBy: SG2PR02CA0138.apcprd02.prod.outlook.com
 (2603:1096:4:188::12) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SN7PR11MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: 511be581-b4f0-42b6-f8b8-08ddf8f59738
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1fvra3FSY6cLjc0B4ot5JAB+3iS8HIS8bqE83bK+5s7hWSwzQRjZ6k9FRsgh?=
 =?us-ascii?Q?nRTxAQR7zE49PUl44X18rTmi0JVRxlYaE5Rv3U3HFm4uG1jdvA76LeZM+fFp?=
 =?us-ascii?Q?ezDwl83Oj9rKjUBV4e+SLJmIrMAn2rYskQjftQb9C+aT+kESJswlngJaYWX6?=
 =?us-ascii?Q?JlYLTBYTkMyns+Q+Z8y+j4Hvl+8qMuBN/S0wJ1Fm3qh7qAHUjHJczHp2zRLv?=
 =?us-ascii?Q?98jAjfQnaJWRoOd6/E4USSow/frVKL3m0ktAdBbcOF8m/+VQAObT8+eKQCBn?=
 =?us-ascii?Q?xcHboIdmcTIgAfOf6M0u9Tj8335X0Q8Z9MazScEx9OPgX/dPM6TgqIeYF5rn?=
 =?us-ascii?Q?dg8GEJxZVoeEFKbX3zFI1mLovIXYYykuFKsWkFpM8PunEWXmxAVx4CSwR2HA?=
 =?us-ascii?Q?RGkQeD38trBZj82/xfpd2XSeeh9bFbE8GGM53ZVMU3OzzrsdMxw/R5Fz/yyb?=
 =?us-ascii?Q?dd3ZMQ+YG/Q14UIT+ocyFeCfJv6PVBJC5XcztOJUMypwtF6JziXj8G1nYfNH?=
 =?us-ascii?Q?C+KBsmT0s4Lh88BW6TQxOxo+waX9dQtpW9YBLaVCT+JkbLEUEW/oZZvI+8wE?=
 =?us-ascii?Q?NjG9t7/fSAwOyP25j/XoFG6ymi7qmvvNB97r2UZIVpeF+6LXnHVnx8NC++Be?=
 =?us-ascii?Q?u+n2fCR6c/S4ilUhYP/A8T+tesJUBw7kty7oE4+NFQ0JZrHrMs61ukvOwgwd?=
 =?us-ascii?Q?pwwY4FFKsSo1Gc044+Emz5zMg7YjyszEoZBljMDh9rd9fwEAn6zwQ5G8R4v2?=
 =?us-ascii?Q?FwKPfMl37qpuRfjIdIsSamVFKn+JTm3zXNlETBY4xdYpXsFDBqwnBvw7Pjkl?=
 =?us-ascii?Q?+s5ig9FmjrYs0YbQI+jXES9+/Uik7wnTkkle2XYBKcrFS37bZrNd4poglxVw?=
 =?us-ascii?Q?v1wy9+9w0+gy+ZyjiMk6K6zjLE968/NH6cgHeTu+mUdfZzp/LMQlvTFVsoHA?=
 =?us-ascii?Q?zqs9jUVFIkIFjKqyKb79j6tDLnTyEYKnwQ/Aotm8QY69zI7YlaXL7F3vSTb6?=
 =?us-ascii?Q?qqa9Tr5NHI3oT1wisG397wosri0eGz01lhwxQjj6iLzCj1nyEQo2IwV5ndoq?=
 =?us-ascii?Q?EF8LPgPC8fHlvXSxhCcmdOxcv2xqNO3oeBz81NZDBXMZ9FHbbmw5jtfcG7eb?=
 =?us-ascii?Q?V7Ok3STuq3pM+NV6BemZ5TE+2YqF2xWE0wQ3SrGdPoCUoJiOFCHmdI3q8VI7?=
 =?us-ascii?Q?zY39nTqnTDOHwRHoaQ45O0Ylb8mpR7qOgT9+cXuHVwjzqyXfWzR49627GyTT?=
 =?us-ascii?Q?gSSzR2/B0vTNjCtycZb3LDT63U+8D1veQTr3FbhGfYvMPMBn5wauHG9md1le?=
 =?us-ascii?Q?IcUVADUT7261Vz2fLcKlQ7b6x6i1jFPXiBAw4s2XZhd0C33jKE5LuXoHqPi6?=
 =?us-ascii?Q?T/eoWPNAzpxKP8lXEOp3xIIjoc+o?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hTMk2jEKiy0XMDaGE98ZbhPi5Lu1cO5ZKaHvZidoqvansGnxq/bhSyFDkKwQ?=
 =?us-ascii?Q?p9oXJbP+PN6DmxSbhOz2x4MmwIhp3CQAXMJ82gGI1wuAJtmabzo2AYpSvNmX?=
 =?us-ascii?Q?ibIR7pdIe332Wj2QSilkWt17j8vmwUgtI+7+e/ghFfYs1km9SmRKYKcjt2e7?=
 =?us-ascii?Q?n6BXt+htR71AM1GHDn+1sxfE+iomBnlId05Rwcr3C05+y9VH/wFL+azcc68C?=
 =?us-ascii?Q?0yIMRUu+4e9l2xcvIDj2AhMM/pjX6BqOpYflwzS5hdR/c5pDgckSRfkkTxCY?=
 =?us-ascii?Q?Eln0rYQyqVlSdi80AzJ9fOf/eUgjG9lVahtv9zHFsq5It/RE+YX2c2GVKBap?=
 =?us-ascii?Q?ysYX2j+EiSMF4Dz8nqubcIflZ0zSfbL98v+R1irg3dWB70hadBF37oY/1HmB?=
 =?us-ascii?Q?WOTpFJFyw8dl62gCW4PRiB25yxDbkBGyiLvkprs0bYCSbIaNvmyOiDwgepZi?=
 =?us-ascii?Q?HJgtFmr665U8R837FyqDj91/1qfp8zX77D2OtN5cEImKHauHt0DypyX15CKg?=
 =?us-ascii?Q?EAFalIj35S6No6aPy3bPHCkkmsSY2JuJW943WPeMeJ5Qy2znspL/moQ5KERT?=
 =?us-ascii?Q?vpLT2RXXbN9IiRjjLa4GRbQEVCe7yAmLuRSQTYSIzv3m6s+uWHhyBIAlTD19?=
 =?us-ascii?Q?L8gz6SbBepq/RWf0vE0lt/1Nkg5f+DHQWkvJ5sDAGw4wrh0oL2Yh7JcYd5yQ?=
 =?us-ascii?Q?8Qm28ZanZKCTO+ZHdJ2pdAXkLzoOLv7txZJ6DALMcB4oXKxd4lkO7YaC8ETC?=
 =?us-ascii?Q?Dvn8tP1GAo6K+p2wOFyM3zPTWYFX3yc3LbVKJxudQCXu+oL6+PP3GCIF0L1j?=
 =?us-ascii?Q?W4WoHyWfJZ9E3vV698sFIENH15cXDHARcLLLLFfnNsosUXYbmJSbWF13+m45?=
 =?us-ascii?Q?yiqQb0hiatEcuSEeiKA91rhk5gvBDVZ1PojBdTF4wJAZtKIcn0tH705WsFEG?=
 =?us-ascii?Q?l7XuWsimY/hACS+UJ++Spzx4oB4dK0Z/QXIGDugMs5KLwkjgv9qYJRN+dYOc?=
 =?us-ascii?Q?rDH293N4wLtEXL81ja6xsldsMN3ih2nXcGQHOp4Q5fUuazKtTnwIpUW6e5cC?=
 =?us-ascii?Q?4hfoX9AFd/11/r2HfPgJS+3P4jdqMaY/oQonKPZPsfKnjBoRZXi7VbKe+A7S?=
 =?us-ascii?Q?99wTFj7XI7lzwYF69MC+SJBwi0zGPgQiE+UkeGU8MBjg1S903/P9qhn0rMHC?=
 =?us-ascii?Q?0WeQNIqkrcb2io0ia7r6vSAwY1rP14GWh/QzRbO7S52iqo3CLhpi6pN6TTTH?=
 =?us-ascii?Q?cnDCeKvzvPRxVisryS3G2bkOWmkMpgOR4xqqzMaqFso0+l9nQrn3RB+HuTt3?=
 =?us-ascii?Q?dCbXqDubxk+pdFCFkNiklvzXgJbSw9gfU9TGss890LDZk2B7u18Um8sjmw2J?=
 =?us-ascii?Q?JR8Djpj22s0SxH6V/TvGNeMMd3Jgnn6QiPlVnZhUHyqhnlZSEUvL0IEgGHHT?=
 =?us-ascii?Q?FSHbB34K9di288tTOIvulBzQkAAQq26daQwdac+k5Pkxi8PciodcWz3lxSDV?=
 =?us-ascii?Q?8T8bOljrwMkDnjwYB+xXo/8HsbZmIyO2pRr4KXG5GcqxZ3JrBmvRrQaoXav1?=
 =?us-ascii?Q?26NJmys+4U4jOQXpyZO0j7D1KpjQhx6wH8QGniyx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 511be581-b4f0-42b6-f8b8-08ddf8f59738
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2025 09:59:44.6134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Og4dcCSem3yDGEnnuQwSwYSYBrlosxERZdllvqr/XXazjz7rRWMLtCfvzyUForhoYF/FyWm8F/ze/7iOvzFS/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8111
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "kernel-selftests.sgx.test_sgx.enclave.tcs_entry.fail" on:

commit: c407010c166bcf30f9400bf0a4a4ec81c0149b81 ("[PATCH] x86/sgx: Replace kmalloc() + copy_from_user() with memdup_user()")
url: https://github.com/intel-lab-lkp/linux/commits/Thorsten-Blum/x86-sgx-Replace-kmalloc-copy_from_user-with-memdup_user/20250909-041627
base: https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git ed16618c380c32c68c06186d0ccbb0d5e0586e59
patch link: https://lore.kernel.org/all/20250908201229.440105-2-thorsten.blum@linux.dev/
patch subject: [PATCH] x86/sgx: Replace kmalloc() + copy_from_user() with memdup_user()

in testcase: kernel-selftests
version: kernel-selftests-x86_64-79e8447ec662-1_20250914
with following parameters:

	group: sgx



config: x86_64-rhel-9.4-kselftests
compiler: gcc-14
test machine: 16 threads 1 sockets Intel(R) Xeon(R) E-2278G CPU @ 3.40GHz (Coffee Lake-E) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202509211747.1edb60f-lkp@intel.com


besides, we also observed below tests failed on this commit while passing
without this patch.

=========================================================================================
tbox_group/testcase/rootfs/kconfig/compiler/group:
  lkp-cfl-e1/kernel-selftests/debian-13-x86_64-20250902.cgz/x86_64-rhel-9.4-kselftests/gcc-14/sgx

ed16618c380c32c6 c407010c166bcf30f9400bf0a4a
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :6          100%           6:6     kernel-selftests.sgx.test_sgx.enclave.clobbered_vdso.fail
           :6          100%           6:6     kernel-selftests.sgx.test_sgx.enclave.clobbered_vdso_and_user_function.fail
           :6          100%           6:6     kernel-selftests.sgx.test_sgx.enclave.pte_permissions.fail
           :6          100%           6:6     kernel-selftests.sgx.test_sgx.enclave.tcs_entry.fail
           :6          100%           6:6     kernel-selftests.sgx.test_sgx.enclave.unclobbered_vdso.fail
           :6          100%           6:6     kernel-selftests.sgx.test_sgx.enclave.unclobbered_vdso_oversubscribed.fail
           :6          100%           6:6     kernel-selftests.sgx.test_sgx.fail



# #  RUN           enclave.tcs_entry ...
# SGX_IOC_ENCLAVE_CREATE failed: Input/output error
# # main.c:231:tcs_entry:0x0000000000000000 0x0000000000002000 0x03
# # main.c:231:tcs_entry:0x0000000000002000 0x0000000000002000 0x05
# # main.c:231:tcs_entry:0x0000000000004000 0x0000000000007000 0x03
# # main.c:231:tcs_entry:0x000000000000b000 0x0000000000001000 0x03
# # main.c:246:tcs_entry:Failed to initialize the test enclave.
# # main.c:578:tcs_entry:Expected 0 (0) != setup_test_encl(ENCL_HEAP_SIZE_DEFAULT, &self->encl, _metadata) (0)
# # tcs_entry: Test terminated by assertion
# #          FAIL  enclave.tcs_entry
# not ok 6 enclave.tcs_entry



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250921/202509211747.1edb60f-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

