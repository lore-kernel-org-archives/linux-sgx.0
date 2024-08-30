Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1603E1494B8;
	Fri, 30 Aug 2024 06:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997772; cv=fail; b=tCELJp6B+9q8YRyW6vY7YzsK0okT+g3bEZstaZYRAb7HoclsXWXk0eelZQ5EjNG4PCLaEYKf443703rhEk5POg4yCb5hjc1wPNKIuogjQnb9Ty+OENUEK0yCSxKYKkcA0yGVZ5RUmUV4QxaykIPKoKj5nAkmYg8csZUiGRYLllo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997772; c=relaxed/simple;
	bh=tp2Ht+pDFE09Lh9hTB+NJw1vGSBWOGIUuvPfXumZXSo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oVgcMEEGmZq+n6r8MrEPiLkuotGCWmds+RzEtOOmWh4RC1DjKfhYjaGW2hrxmtlMri0yjCT9yRpNx56sB+j3+R9lqP+eYSIsLoFFrts61bI+rTrgavgWEztNfmyESUVUps9zYKF29dx453JCPE8A4kM8+0gDW4DTZRCOJxeB1Xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EOZF8lns; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EOZF8lns"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724997770; x=1756533770;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tp2Ht+pDFE09Lh9hTB+NJw1vGSBWOGIUuvPfXumZXSo=;
  b=EOZF8lnsOmynVODbjjzuLFgwVQ2phMYxxhYbf2dXrmizr8HxC9/2FMUm
   ng2+BU6GscwGmNupCBgMaxSx9k1GlORyX8pl3hyw8vIMGsJ7Na4ol9K+a
   RCdpgfrKXAlS0L+oYkvlugDPxm4mG7ASsSgecVAyFCLH+/VL3rKfYXrN7
   fh5TAXPvdoIQl1PFL/BfMyxwa4LEU9O3BUoyiEGYRrzbn99DgsJr+eGZT
   FHsP8IxGzGaZN7SX05pIopeVBvhJw4GB7+Ruk7/878Jjmmqokr3tQO2Uw
   x9wyeilUO9xidWSHYdEZQwUKCHAld+/jpNXtKPMqF7MCHz5yqA6LG0grQ
   Q==;
X-CSE-ConnectionGUID: usbgRn0QQIi3fMLLFtEdIQ==
X-CSE-MsgGUID: 9oQjbuQuTSCLHtUJwrvavA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34786782"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="34786782"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 23:02:49 -0700
X-CSE-ConnectionGUID: Zw3B2DtLQJeFWrt2XMJjGA==
X-CSE-MsgGUID: z8gdYk53QEiEvbqi+mPOxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="68639297"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 23:02:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 23:02:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 23:02:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 23:02:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FhkD1lDKMkUpHTHOL32CgHMc4puIbhX0wZvURkno1EAFBBMQyvQTlWBeGnIKaMn/JPw+eAA8M31vvrYfq+vst0YY/I5zQ5KSeDNeEXdAfFnh3Pa89gI3NHe3aDJGm2PuaZ6TotQDSaY+07UIWNeRcZAMtSZAODdgyO8RRbFD8Fv8GISPWAAcEkZZHmSkP9UBbSaq8+bGZj0F4kXrhG95Acrk/qxAfrslgZWcYTjKbrlkRctDGh4Bb25USkvA5ah68T6jOWt0CEkc9xXz0P7Vq5EWxZJgwSpeTGetnO+uRKt1ECOPMxGoOMRyOWo2/Is5yFvgyKJPbKglMYIv418L1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydFi1FBfHuylF+IFEmGcWNwo/yaybT9uDUfyEay/t6w=;
 b=jLhX9W/dhNTGHS+x7F/rb5LCIQM5O95rTvOb/zBZYAfCgDFWsiSHm4Kt9wMz0rC7ffw2L9dfMARzC6GYSsAsAspqrkm4UJuo2gx3Stx6qQSmXlTK/uGLi2s6cOVvdkxHVGWgQsVjsUZmeHGFBz67ChCRl+LqzboeykXHhBunCG2Hv635SExJ2ScP0+XVIi95d/JUbxhOEjUGfgL1GsDcJ2jDq+RSUTUAwlWvBVVB6MWZby1lMrPv8uYKHNR7jrTfGa6q8wkxNTg5aYsrl4FPc+hSkLEHTx8PP4s14nA9jzV4W/zCItaVRwi9xlWrEIh9GZnmM+fwZo6LFIi55Ppd4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB6985.namprd11.prod.outlook.com (2603:10b6:930:57::6)
 by PH0PR11MB4984.namprd11.prod.outlook.com (2603:10b6:510:34::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 06:02:46 +0000
Received: from CY8PR11MB6985.namprd11.prod.outlook.com
 ([fe80::77ac:889c:cfd9:b9f5]) by CY8PR11MB6985.namprd11.prod.outlook.com
 ([fe80::77ac:889c:cfd9:b9f5%4]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 06:02:46 +0000
Date: Fri, 30 Aug 2024 14:02:34 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <linux-sgx@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Zhimin Luo <zhimin.luo@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
Message-ID: <ZtFgem6_2j05S0MJ@ziqianlu-kbl>
References: <20240829023800.1671210-1-aaron.lu@intel.com>
 <f2b0ffc7-f8f8-4ebc-99da-9139c372bd09@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f2b0ffc7-f8f8-4ebc-99da-9139c372bd09@intel.com>
X-ClientProxiedBy: SG2PR04CA0153.apcprd04.prod.outlook.com (2603:1096:4::15)
 To CY8PR11MB6985.namprd11.prod.outlook.com (2603:10b6:930:57::6)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB6985:EE_|PH0PR11MB4984:EE_
X-MS-Office365-Filtering-Correlation-Id: 394d67c4-c032-4312-4cf4-08dcc8b95e87
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jke4/0By+ehluatXCnbV5zkPDczMaCIYvOMDCAdVI4CQp2ra+8etHDmXQo/T?=
 =?us-ascii?Q?uwFv6UbAMmzOpy+LmLLLS8en3M2fN4QuugwHwTZQKLB3WaAOS/C4oToihphK?=
 =?us-ascii?Q?7XUUDXCjlPmnZpPEQ0kFCyTFwgebQAyiFIFAvzAFNnO4gos9fY/zmi86Duef?=
 =?us-ascii?Q?S8c2jVCQdZ6Jn2083ER+mRFhTPDxI5jiVJzidgGqiC1eJbhEoWRfZkLjdHUr?=
 =?us-ascii?Q?drrMDvjL+4Mndo3BUfRwDc24D2azgM/dUEWhScOo69YCBuYlu8mPjzAixl3w?=
 =?us-ascii?Q?dEEgOBku1mXlJO5Cc70vjgHQHAeZrbnV+rGM1ySE/vgMUDZmvY/TMEh7NEBW?=
 =?us-ascii?Q?5eprsQhSoimliunmB2J3xTk+IpK0m1AGUxyP4SK2YqmtUjMKWm3R5h6bY1y0?=
 =?us-ascii?Q?rK4i0XIRPq9mBZbA89OEKAp+W3to0NMWuLgKkpGPh0ncpTWCAnA0+6WRsqvp?=
 =?us-ascii?Q?C4OAVrLhu6gIrje8AqjTKEURJdZywbdzcHIu4zot5kINJKlUVcRY1ga2yC2P?=
 =?us-ascii?Q?yTQYM8w9r/9pKWg6GVIvt5UJXJcN1Js23IUsf+0DLvo7tAaqllcjL0oPi1Ll?=
 =?us-ascii?Q?dFFyesg5g655yk8BA20VcELHoH6qg8KHH4YjgcgdjQYBZHCXP3pTf4imD6lN?=
 =?us-ascii?Q?rI8iWTGk37r3eS0Ip6ih5tTpt06JKsDM5wHWw4zAI+DuWCmzUxswbBowoldm?=
 =?us-ascii?Q?/IfbQHaAfb6Tk+ZgADUNe/LCXIKO9rLuAhPiRTMdiTVfaQWCHIlYqcYXcrJF?=
 =?us-ascii?Q?kd2cml25oOfcacay3JhFZmFQjctVcDDhR1x2DRZ3nZIaCxrohd7E6tLxbB5s?=
 =?us-ascii?Q?uRNzbMKBPCGgEpqRaGfyaPVhli+WTEbaeLGtv0il/yPTrXXBTxF54wH/NdI1?=
 =?us-ascii?Q?RCLWyIN4SM1tJKV/cvAaKEumvKKDzYkNgDATthZfRUasm54FVBGVe7HNWCdW?=
 =?us-ascii?Q?aw3DPBm426Ghx4+cE4UhfaDY7saVwDtQTa+f8q0SlWPkbyt7YmPIknl6yLwM?=
 =?us-ascii?Q?yALuHQbTgmFO/DP1ULETWl2JUSwvgsQn1ku7kpAN8bankfsmUQ+Q2aqF0ivF?=
 =?us-ascii?Q?FF/Y02P/zh9hBXBYi+FHtHzjCO1Rr+VHXdv/XPSnO7sKWggT/am8xELTUAXI?=
 =?us-ascii?Q?Rs9e2F+AjXTo46rWYI+lhlYe0OAE9FXmSS24rnlYG2KyiSKFrWBfOYQHKVLY?=
 =?us-ascii?Q?BoVEAHhjFZuJUYSGwlirf4eE7FYghUiD6ehziigon4P9ZEtv2WJLv2Fc9n5V?=
 =?us-ascii?Q?LBLJfeAJzYbkw5EYan6czVm9h03K0kGvdWblioNXg9JCWYHJ0nqhxpTPrgm0?=
 =?us-ascii?Q?Qq/z0pQAnzVGu+D/dDalVq99GcTDlhFisOHiHxupoPJeOQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB6985.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8LMysu7l+5LTL2hD0LUumX2el9h+ToeS6yI1aLvQRvvlKimCV5/Ip788zx7i?=
 =?us-ascii?Q?Pph8j777pocF3Ke8wk0eIFM/ihYDiBJxrm95xSBcjbFJsQ92JrmHj+rozT4A?=
 =?us-ascii?Q?9QxC4rhtzLR//BbkawX9eTrU2XKZDMRbquQwMDvwjoDhLJWhNHsVXeojQtOM?=
 =?us-ascii?Q?HOgeksyGGx2Noo7CsUN7fLZtCFV5uwtVFC4od+sbOz9nCfZRQiaveseeWyT7?=
 =?us-ascii?Q?rY+vPntkSfpVj9CmwsB71eL4Bxa28xgMMcafoP7Fu3ERRgukzb3HXxRggNaR?=
 =?us-ascii?Q?fXZekXEWA1EwAAS9oEdY8CQYC8lKetQ1y+VNzC8cg5gKNyzBCqE3Q1Y6xBOm?=
 =?us-ascii?Q?LRcjd9RjmMDTVElsViUf0xvDd2+gg75EQqCi2E15juLfHf78yrRs05HZVMtM?=
 =?us-ascii?Q?sQhVaMR1V1M4DsUIusdImnrXkaHAtEbd5cfTJmDVMmm9lhFg+8pSK8hV9wBg?=
 =?us-ascii?Q?2pAZL7lGcdtOHmzbibFDWXOLgIH0Pl4PTVwZwLQIYes/WCI2cGf8hvTX+Atg?=
 =?us-ascii?Q?PCo96TrrUgMQGNmLBOnnis0T3wOg+4GXPkvtVkFJTRlBhy2DmLf6EJnybqzK?=
 =?us-ascii?Q?ivoNX3iarLh4Y7lniv/w0xaoB+wHBi9FnxQXa1Hwf6oVPg4oToZtdpR5zY2I?=
 =?us-ascii?Q?XhHw5Os1brB35u/lYK2+EQ4n2HXnWoAG0KHQ92zzm+jWbWBX6fIeN2J3ZSyo?=
 =?us-ascii?Q?AW7LQD40YTGbqjYwjXlrM52YV8GXhksCGappV4qWvIa5CZ2iO1EHaWHxpm4d?=
 =?us-ascii?Q?Yj9zhivpwSI+Gz6l+VTD+KDuSN3r6ABCNF9sKJ82rFoj9a2Z4+cgdYwQFMsX?=
 =?us-ascii?Q?JihH7o93BA9Egomc2LOl8mL/Hg4Qf3BiFaT4943EIcgPHmcluNXmKObSbMNN?=
 =?us-ascii?Q?vtoJtz5NjddWv5NxRMPet8J3MWHqeuaZp01On+kWfngminAKEg58ynusD4ph?=
 =?us-ascii?Q?pRUkQXhSVPFB0NFuJrxroOn0F5s0VA0bp42ceTc09wCz5ZZl1I8szNSFY/2A?=
 =?us-ascii?Q?kbRXQHwYuwqMXC0LxefT6eds5Ppv6LcvA1T0DclysdafKvVfCQrXbSXRIvRJ?=
 =?us-ascii?Q?X8oXSDgQI4/YHxaaOAo3hoMB3uPhLa7fnlP9Yc8B0TkArSArKhx3WxW12auB?=
 =?us-ascii?Q?9lcZB5wDPsFbMLZLT1HYVF0Eh0ZiAyFbgmnvjQq1U46VQpmDw8kwfaBvQgcu?=
 =?us-ascii?Q?25jQN9nwKuTw7dzlazzIuBUL9JAQaPFs7SjZr6dZ8USLEaBYQgrcAOa/LKwP?=
 =?us-ascii?Q?M3fLUsoRq9cfnyMwpMj44X3buBRoxFsD6XYN6O5kzWglERjoG+k/kFv/D8Ul?=
 =?us-ascii?Q?Ha5jnJgkju7EZKcBkUYQkqB/we+d070qXiVxzTSQr6UFhxvbCklN2dVcyKat?=
 =?us-ascii?Q?ZyOdQtkfNlKIh/2Z/8L6uJ1RYGzV+6cVPc5HgVyrM0raHrpEAlURzlpjhb14?=
 =?us-ascii?Q?AWQiQZ+K0uDRxyjMRkgUvp42rCsykb2IFwI0vcvFpyX/4DbBOeABa22jxupP?=
 =?us-ascii?Q?NXZ2e+TTNPnE5LnT0GWZDznOBrnu9smJ+ooRCqOjTffS95mtK+zdBSCahneI?=
 =?us-ascii?Q?d8gjvgGer4AFFgiQVpgiiCDjF+DVXCAZ70HTGI2n?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 394d67c4-c032-4312-4cf4-08dcc8b95e87
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB6985.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 06:02:46.1766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRLrmD5qJ3ituX2NRliNpAZYffHcN5m8hKbzTzn+UePbMqbCEzS3CjsmJdOWrV+VrOE8Zb8042QtK9UIuTZ5qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4984
X-OriginatorOrg: intel.com

On Thu, Aug 29, 2024 at 08:17:53AM -0700, Dave Hansen wrote:
> Generally, I think it's a bad idea to refer to function names in
> subjects.  This, for instance would be much more informative:
> 
> 	x86/sgx: Fix deadlock in SGX NUMA node search

Indeed, will use this as subject, thanks.

> On 8/28/24 19:38, Aaron Lu wrote:
> > When current node doesn't have a EPC section configured by firmware and
> > all other EPC sections memory are used up, CPU can stuck inside the
> > while loop in __sgx_alloc_epc_page() forever and soft lockup will happen.
> > Note how nid_of_current will never equal to nid in that while loop because
> > nid_of_current is not set in sgx_numa_mask.
> > 
> > Also worth mentioning is that it's perfectly fine for firmware to not
> > seup an EPC section on a node. Setting an EPC section on each node can
> > be good for performance but that's not a requirement functionality wise.
> 
> The changelog is a little rough, but I think Kai gave some good
> suggestions.  The other thing you can do is dump the text in chatgpt (or
> whatever) and have it fix your grammar.  It actually does a pretty
> decent job.

Thanks for the suggestion.

> 
> Also, you didn't say _how_ you fixed this.  That needs to be in here.
> Something along the lines of:
> 
> 	Rework the loop to start and end on *a* node that has SGX
> 	memory.  This avoids the deadlock looking for the current SGX-
> 	lacking node to show up in the loop when it never will.

Will add this to the changelog, thanks for the write-up.

> 
> The code looks fine, so feel free to add:
> 
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

Thanks.

> 
> Also, I do think we should probably add some kind of sanity warning to
> the SGX code in another patch.  If a node on an SGX system has CPUs and
> memory, it's very likely it will also have some EPC.  It can be
> something soft like a pr_info(), but I think it would be nice to have.

I think there are systems with valid reason to not setup an EPC section
per node, e.g. a 8 sockets system with SNC=2, there would be a total of
16 nodes and it's not possible to have one EPC section per node because
the upper limit of EPC sections is 8. I'm not sure a warning is
appropriate here, what do you think?
