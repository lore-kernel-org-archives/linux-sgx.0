Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9FFBE40;
	Wed,  4 Sep 2024 01:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725413971; cv=fail; b=FdP02onzC+J3HqYoG3hYBo7NsXOh1xlbc8cRqNHIZV4S7u4dv9qyXdslHzUyIREgTXiWd0Rjnt0eLwMVBkGraOvAPgWDvpiWc4ZMO3jqXEHh5K529GStZatacITX/Lhd1xVWhFlwbriuioRUqb+l5Qdtju42VTDjIaKAKXWdoLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725413971; c=relaxed/simple;
	bh=c5AmlxxVd835t9M4amfvSFhMGapiy+Hrk2KWbER4h34=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Xnt/TNazznmAvfK+iTXC3hpuUys/F37nLGHanhMAhFoMxU+eGLmsNhJRhwaizlImDUrkWRh2iW3SZvoRJcHSTVGyNI1va59CbZPvqs4ndNWNItGhQ8+sX3H0HGYtccleD6yQ9T4bXNEXVlJvesy0fIbbYOg9R+oxwKOeV7qWB+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ne9WcB67; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ne9WcB67"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725413969; x=1756949969;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=c5AmlxxVd835t9M4amfvSFhMGapiy+Hrk2KWbER4h34=;
  b=Ne9WcB67KRSu0pLQgXk3PqR9H4ML+UBWkqnTeJG7/sJE2KsFkFQDviq4
   1fPtQCLPNzLiL3enfSFuIg/k6blwP1c0E0B/MrT/5cp5yEjiUTogHr+sG
   PyiuGtPJx9EB8oQGHQjQ3nODPTNPAkMw/vemFIhfxUewgcqriSkW4kktO
   wHqnkzLgWASERfA+we01vBQnPi8bN/4dp2fhH3fwFE5Ox0mXrMU+0rCwP
   2ta1X+CI5ZiMBxUvKFGGkC7gOVuu7EAZucEvAO/hLyDyTkZBp0UQN2IOb
   OnOiZaneFBonVf/oS5KhqIPzZGbm5xJDEKCpziPmeHpmgsVRG4eeH+8y0
   Q==;
X-CSE-ConnectionGUID: Ii1GmSIWSFCYoyQ6XX8yMQ==
X-CSE-MsgGUID: 9bQHaQ5dT6GbVVAxz6TwMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23559473"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23559473"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 18:39:28 -0700
X-CSE-ConnectionGUID: wv7wlLJ3RR+UEQJjs7HI/A==
X-CSE-MsgGUID: x8pobfncQzaqJ3wObUoBmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65608463"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 18:39:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 18:39:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 18:39:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 18:39:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 18:39:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WAu9AeYWjIe3tIYBWjuDBlTkuyGAuv3zf9jug7L6JZdkfCFSbc5OTHCi2rrtIcYyLlikQcjd832iapybhqn7UqTw3Bu8tDceVWRcnXLmgLbU/CPZSrQ3z3Wozqxp6rlngVwlWF/GtPsuARPeljNHOMnYCLYtIZMtwsdVbNf0XoSA9AiGIC246+3dWhgBBOpeVxC5zcz8zqY8xr7DN2+/DKZXZoU0ZVhycTnp+Utbssr9ch+7idsWl+5OL5qd6uYovm/apkmMttwu2SDZRU055bXCFwsfsd4X7NHL0fpaDYeWJPGztLqCKmxWAPv1ZzjHCKbWhchrW5dgQ0zILXggaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kgo3tQ8ZoHpVrHgcW7a5JeBzSc9uqYf23wBXBVYW8BA=;
 b=o8b7ABo0v6F+4ybddoFD/rtgvdWBA0ba9Tt0bfBwEtnyonfuWNnBw6UkI+mNgXZ8gWcfgY5WRcazac/RX/orxvhkp99hZQ2dpDtuugiz7XYqp1RSZGR6I6caO05Ss27j1/X8dLshbYW1iaUP9Jbp7BL/2YhHkGahlHKZK46HteO2lMo16o9GgmcExoFroT2lw4/8OZNr4kGzJTpdJi24fDC6uHmw5AnRCvswVKIbIoUBjI7x3K9L13DVs5kJWk6ZReNL5UA3hOW9DsYH+L5+cujpNSdMKljmP6L3p/AxwSLpilzP6KEnRM/fh8oqRae+7Pn/0l0Hf5WUpQ8GNm9stA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB6985.namprd11.prod.outlook.com (2603:10b6:930:57::6)
 by SJ1PR11MB6299.namprd11.prod.outlook.com (2603:10b6:a03:456::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 4 Sep
 2024 01:39:24 +0000
Received: from CY8PR11MB6985.namprd11.prod.outlook.com
 ([fe80::77ac:889c:cfd9:b9f5]) by CY8PR11MB6985.namprd11.prod.outlook.com
 ([fe80::77ac:889c:cfd9:b9f5%4]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 01:39:24 +0000
Date: Wed, 4 Sep 2024 09:39:16 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Zhimin Luo
	<zhimin.luo@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
Message-ID: <Zte6ROmqrwdCSIn8@ziqianlu-kbl>
References: <20240829023800.1671210-1-aaron.lu@intel.com>
 <D3SJOVADFM48.JNOIOZJ0J6OE@kernel.org>
 <ZtFjPwNWS_hfs4px@ziqianlu-kbl>
 <D3WS02D8SZMG.62T9IWX6WZI4@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <D3WS02D8SZMG.62T9IWX6WZI4@kernel.org>
X-ClientProxiedBy: SI2PR04CA0017.apcprd04.prod.outlook.com
 (2603:1096:4:197::15) To CY8PR11MB6985.namprd11.prod.outlook.com
 (2603:10b6:930:57::6)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB6985:EE_|SJ1PR11MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: 81663cbc-3e58-473e-0575-08dccc826821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wpWqoT9V2V8k6eS9laj+fQxWYfrXoc5TblBYuPqnfKULVzHhl7ZyF5biq+Pv?=
 =?us-ascii?Q?Hqw93k9lgilK/r8RqwgUXv0yb1eOMhb/8DxZehGwVTMSOO03SGnifpFbHisV?=
 =?us-ascii?Q?JvD1l6/P/E/Eudfhz0IHWL7GjX8zuHHAVEWwhT65yMKRSvRUUlL00rc23HyN?=
 =?us-ascii?Q?UbgFL9fOJGPCQJgOs1hsgu4ZBZvm7Zy0gcuh2CKNeB2Uc3uxyG2s8x5OsTKF?=
 =?us-ascii?Q?qjgtPQRR+c2x6EW4xFQk6UAZbEOkHqw/zVrU9fr0LybBG2czYK218ruS6+83?=
 =?us-ascii?Q?+ZGcuQvCU+SUGR9bh5pO7hpAQFUvXrbTn+rCMVwSN4Y3+JG6rP69XzGG8uqA?=
 =?us-ascii?Q?YJtEWhOJyQ+QNeoax5nWC9Pl8q1Ir7ctGWLHWOxlCjYLQ/hPBn6xAKiN4MAD?=
 =?us-ascii?Q?3xFHccPMYHyqWKzhZckOFGvsfA/WjyiZYap11KYaqZldeWyk6qprhTyRSZ/w?=
 =?us-ascii?Q?ho0MuiEnPtRCLM4BU8cIH3z4OLEd8psVB8V1sYi9STIHKFseBTIJMpXgRiIj?=
 =?us-ascii?Q?bmeWXyzktgPgCbjQfoW/5TXhv260/EicZC0137MjRau7eBmZrgHHYbPfu5At?=
 =?us-ascii?Q?GX8n+fGCCLiLWwPPkAmEIJTDOGGgd2ZMz5GWOR5C8Rmw1nOlBxkPo1Nkp5WJ?=
 =?us-ascii?Q?7YOWllHMLVlsweDfNFP5Gw9IEXRmP5MYdLW8JHFPq805ArxrzhlBOUG6lR7c?=
 =?us-ascii?Q?A9Lf578XOwJFCmcHijw3IpEcDMzWLeJJFIiRxl/uriqY+6tRHFsJT/6EfkYb?=
 =?us-ascii?Q?N2ZcIW2OYzJlffbTrihS32xSwUaLTt62NJXczwRanvY8QGTJo+DUb8eeyJiX?=
 =?us-ascii?Q?g+08qiGnJHDbQxZVVWOCYcsaIrupL1Z6mLBipK8opUt9P9qlFb5j1DU/enP5?=
 =?us-ascii?Q?U13i/gpokios+dKSnnf00qH64ZuFCqPF4bIwxunhaDcrsIwRMJ+ImdvbB7j0?=
 =?us-ascii?Q?+ELXmcbQC7FxlQFPXYaeVDi8UaukkvEMCkyrmxfKIJD8Qr8L1aO6/gLqYMws?=
 =?us-ascii?Q?XYLV7nvzYCfTGPW5x9pKisWjjBSe+dHm/ei1x+nB7qKJ3Vua321g1OWbw6hi?=
 =?us-ascii?Q?YpN3WL/h62IC8EL0XUULSzC/CTTPhZfg2BdSw7/MKIZPyNTjV8qQaug2qRXR?=
 =?us-ascii?Q?tBDnfIGh2X7ZgVjH4quk4c7MTzE1dVfpQR4pudMcDYX/7GCuuNBjOTh78b9B?=
 =?us-ascii?Q?2bW+pocYqxHfrJehZUTDd99twAFLMJTCzKd2mIhr5ShLC35IBFf0X9GGfXUC?=
 =?us-ascii?Q?zFi//vg9HIC2F1Bjou/0tDeOAXUvPr9sJH7nPATNxlEkLa1bEV1udsr48NtM?=
 =?us-ascii?Q?gaytntV9JaOIRrY+LfcBwznh6H/lelG35N7pzErH0lqKMQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB6985.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rGlc+ywIhrKLCgfuu53FwAblPuONlwwjxKRomEDBMjYqWO33KPaT5j5aPzpq?=
 =?us-ascii?Q?rTzja/DJfRASYF3TNIX6ND97F3zM3yDaasXX15VsSZW4AVzvO87B5vOVpAXV?=
 =?us-ascii?Q?vvACVjZM2xhFmz8YuXGMgB6MxoJoi3pzl2SmLK/3bj0hO/FUpc/iM1cgmK7d?=
 =?us-ascii?Q?CUPjgQ4vKfb0N/Xs30YBT320WDX6Ga0eP+8oXjTfju81PvTFHiY4P4smOwgQ?=
 =?us-ascii?Q?hcmiqU1gHJCeqB1mIbgnNrhmPo+mokQcYTV5n5JAa43GGU7MSzCavba+jiim?=
 =?us-ascii?Q?FSSnvMQobZ5eObNn/acq2S5LcopBpFb8lgFYFvxeU71HZ2VTTr9T/FVCWPMB?=
 =?us-ascii?Q?YP2C/MFMtsjCj9g80wtFTAtgX6OQnYhQHxNydHDvaICRL3iXHbLz9LwuqxIM?=
 =?us-ascii?Q?VnQ+0GwTRGWoF8KOjuZMBxgsm8Tw56Ah1TltSbrsaopnpxyTVlMvlRQ+gRNg?=
 =?us-ascii?Q?kdQxar/0ye2CqtcB4yVFcPel2yYlKHXPAOtwfpVgQY0zKL91fo/xfX55KlgJ?=
 =?us-ascii?Q?nPh1OFk6z6gkQyB1ewkt+GjKiwljoUu/ElwGjK5Xn1Y8XP0dwts5r1ZSpGtX?=
 =?us-ascii?Q?8Mj9TRR4ls7A35umTc4OVknqt9axVA0a8ofqgmTJl0z/hC3lRiCFAySuecnF?=
 =?us-ascii?Q?Z5mJVVWLB4dP7ZvRaUbk49drNpXcWTEibPbWFiDClWMYBomhtrJN2oHDsfHN?=
 =?us-ascii?Q?9CqOqkcu3XNKfDqzW1v32mBrRcfdCGUF7Zl6VV6aqrb0e9qR9vEhkVDEmvQJ?=
 =?us-ascii?Q?cgttzEiNcaxAXNjt+Yld+OPBaCWvjKVf0e1/ZDjmouOn44rAWQuJ00NghiYT?=
 =?us-ascii?Q?D8FiaSmgafLFUJReW2+/hJjF0JF51Nos75vSZALIUFLJ3N4UE+VFQAMt41Jx?=
 =?us-ascii?Q?KE3hF+cQNxw9rPb4G9oIhZWa4vK8IW/yTYwrrd/eA6bMsJJ4pkgpxfH3FL+v?=
 =?us-ascii?Q?0pWWn+Ks9G9n2s6J/aFBE+OeBATGbv1gOImklYm8IeZHjjBZoqpV89Po/P3D?=
 =?us-ascii?Q?bFdGnuyqF9lQKLXQkGtDXXXsRd1XF0WrBaGZUSGb+unLioTs2IIbeYWtkn9q?=
 =?us-ascii?Q?bhf3lhpNm7akiSbbJqveHLnkbJcbhYGB6H2u6+BCwOOCY+61f/fUtXkJHm8z?=
 =?us-ascii?Q?QYeTAu1R2DZkHhTk1T6D9FvFs7FVdKe+mXAXf9GYua7YiLUGAp55wrlEj8+6?=
 =?us-ascii?Q?6m1r0MZE8jAkQlfIXmCf0VWClNJhLMEp5iQB1hh3OrK3GgZH6UpZJTwrUhjZ?=
 =?us-ascii?Q?80m0SWff6vtplq3mGoMJYJiOzY7qOOI56IF6PapaC+qM/AlhoqSFd5M9QVN9?=
 =?us-ascii?Q?u0Fz4Qu1UK5Lt6JjyD7ojBgZt0XMkPtDuyWY4pTPQ5xwX6s5YSbLVfqH+p15?=
 =?us-ascii?Q?pycxzKrI+Jk6Qs50/u6nePWemsnGbkEPXFS+QZSq3fPrzxHRCF++J+Rw0LrD?=
 =?us-ascii?Q?ubSJ0jDgW9CQI+O9XwkmhdBIBwWvsuNftL+BjOXDBg8nOjWn1WFvehyPARAq?=
 =?us-ascii?Q?E21ndG6WJnYdujD1Yn6iLc2jgk8P7JqX2E3NnpJjNXCjcspxmLdugblG5MEX?=
 =?us-ascii?Q?RyxDjQAAsg7wkGx2IsiZsuo4xB4SeU9MWUzsbFNt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81663cbc-3e58-473e-0575-08dccc826821
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB6985.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 01:39:24.5637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDQLHR2xSnDXptRHNLPXtL3MXXxMl4PzrpwGgqbR236JIE8CajYynoUkThic0NCejhYkK2mg/U4JhVaz3OYOBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6299
X-OriginatorOrg: intel.com

On Tue, Sep 03, 2024 at 07:05:40PM +0300, Jarkko Sakkinen wrote:
> On Fri Aug 30, 2024 at 9:14 AM EEST, Aaron Lu wrote:
> > On Thu, Aug 29, 2024 at 07:44:13PM +0300, Jarkko Sakkinen wrote:
> > > On Thu Aug 29, 2024 at 5:38 AM EEST, Aaron Lu wrote:
> > > > When current node doesn't have a EPC section configured by firmware and
> > > > all other EPC sections memory are used up, CPU can stuck inside the
> > > > while loop in __sgx_alloc_epc_page() forever and soft lockup will happen.
> > > > Note how nid_of_current will never equal to nid in that while loop because
> > >                                                      ~~~~
> > > 
> > > Oh *that* while loop ;-) Please be more specific.
> >
> > What about:
> > Note how nid_of_current will never be equal to nid in the while loop that
> > searches an available EPC page from remote nodes because nid_of_current is
> > not set in sgx_numa_mask.
> 
> That would work I think!

While rewriting the changelog, I find it more natural to explain this
"while loop" when I first mentioned it, i.e.

    When the current node doesn't have an EPC section configured by firmware
    and all other EPC sections are used up, CPU can get stuck inside the
    while loop that looks for an available EPC page from remote nodes
    indefinitely, leading to a soft lockup. Note how nid_of_current will
    never be equal to nid in that while loop because nid_of_current is not
    set in sgx_numa_mask.

I hope this looks fine to you.

> >
> > > > nid_of_current is not set in sgx_numa_mask.
> > > >
> > > > Also worth mentioning is that it's perfectly fine for firmware to not
> > > > seup an EPC section on a node. Setting an EPC section on each node can
> > > > be good for performance but that's not a requirement functionality wise.
> > > 
> > > This lacks any description of what is done to __sgx_alloc_epc_page().
> >
> > Will add what Dave suggested on how the problem is fixed to the changelog.
> 
> Great. I think the code change is correct reflecting these additions.
> I'll look the next version as a whole but with high probability I can
> ack that as long as the commit message has these updates.

Thanks.

> >
> > > >
> > > > Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
> > > > Reported-by: Zhimin Luo <zhimin.luo@intel.com>
> > > > Tested-by: Zhimin Luo <zhimin.luo@intel.com>
> > > > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> >
> > Thanks,
> > Aaron
> 
> BR, Jarkko
