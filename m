Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096BA1A4ADE;
	Thu, 29 Aug 2024 13:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937788; cv=fail; b=boP0zsk773We5lUkTuzMllKBoHSzZunBy7MvsVkAVu4XRCqSBhURbOijGNKwucSDFJEwjhTHWdsl9UPz2yJgducDnOqUNb2Fhz9l1cSAxLSix11z3xAkfiAX3pamZsEI4mVyDLXCTKGZe8k/rOtIxyXNhpyV44uBI5/RPUwUO2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937788; c=relaxed/simple;
	bh=UUf/3/h9dJkPb+XlVt8ZrMZDbmm+W5t9luut96q1JMs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cCaIi82VtU4CHU3Itxjy6/kWUTSPx5+2Aao23bOWf4PunBG1rJSVnca/WD9GvqWlWOtVipRApjclR+40UZH7hWns4eUEwMDCuBgSmEdGdcc3wS8DiS6aLZH7RZsuTfFJR/XSRMPbYyihhIKP1UEE5CJ7JZe1f82TF5PRYsm8Ewk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KzmwHnfp; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KzmwHnfp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724937787; x=1756473787;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UUf/3/h9dJkPb+XlVt8ZrMZDbmm+W5t9luut96q1JMs=;
  b=KzmwHnfppBSlAKqMVCvHyobkE2mK3DU4e6p86YZ04FhE7Vjsb2LUsdL0
   whEX8aEamF1hnmdSbO5ceE6p8KLqpuk33JKlcqp6gcHHeawz0sVR2PkDC
   xJSqoe3Jn9jjt6bVDiAs2HF9CbqyX1WQT5RP4fRu2DhqzX/ap+2yGIjQb
   oJTdAe2I+MJ40SRh/j/9de3AqKa50vyIsD6j0I39Qvgou9F9A50Hy/p4d
   4izRTMBKUHGqJyza8s/n76xgn0/JBPqFt/cSxFTRQjsKi9E4tuzM+Jt5F
   02ZQO4ajTmT67SgcGwNNhcwa0kwMBnCBDVbyCN0Cm3JZJPQFpOUYOd8YT
   g==;
X-CSE-ConnectionGUID: EhdXFfD5S5O6LN/J36prsA==
X-CSE-MsgGUID: wZmVvvCkS1ilUjy63lMzmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="48914824"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="48914824"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 06:23:06 -0700
X-CSE-ConnectionGUID: 19ZAj+IqTx6vaf3pcR2ATQ==
X-CSE-MsgGUID: GVkaVVf2QE+CsZ+JB1bK8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="94304946"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 06:23:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 06:23:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 06:23:05 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 06:23:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYTwVnhm8BN75fPgJ8gEVceOlf2prYG9/6xgKuESDveaxar6dZZPes3pJ2/sgzE7wOEWLKcvOjtYzS+slWEQM77PswV00In3322XVijMyohFfXeMd6s56a1JaIsmHwf1d4Z7onnkyguxvE26jELw9QbNQIwEqXJzaaI+j5x0zAmXcfIVi0lFOjrwdELzLxtW9qVoreUBM7dCpipEEhDLtH9GSCJ2peY5F67bsUSunnRbbVhyYkk4UuMiUeixeVuFtoPS30+9AQFEIWJw2mcALYV9CxmVytQXR6EJTi33SCttUIuorXxzF54BOC3fVQFPTeq3UlrbiWR9lt5XpndERw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSBVbXtOwMsAw05aeTq+WaU77QBd3YQhgSirxy3Ieso=;
 b=MKhnjGZZpGwz3dxcTwRXZAQHX4FzRS53BtR/qI6dpKgIpB7gfQP6OrfiT0Lwy2byYDGsCSWgytDKLyQtxIVObhIKkfPtvg5v66im0CXs3gGRuUIjgTujuLLi8njJROZYz93fHZpb53kB03BxSbiSN4sp41QbKCtIOl7g92AOSoh7hnM6abq0nI+oNGFPsm+dlECLs+kGK81ecp3HSunf5xTkDnKyS3bf2Sq7ajmVqoORTMlPxY3fyTpkn/txyRa39eghw02DfIFoy8/WDFjSMhuY2ey2GUGqTwya+25bLy6XgFSHQ4cL3jNuzg8iuNJD895/cnPnFwk6mX7KQsFvcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB6985.namprd11.prod.outlook.com (2603:10b6:930:57::6)
 by CO1PR11MB4804.namprd11.prod.outlook.com (2603:10b6:303:6f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Thu, 29 Aug
 2024 13:23:03 +0000
Received: from CY8PR11MB6985.namprd11.prod.outlook.com
 ([fe80::77ac:889c:cfd9:b9f5]) by CY8PR11MB6985.namprd11.prod.outlook.com
 ([fe80::77ac:889c:cfd9:b9f5%4]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 13:23:03 +0000
Date: Thu, 29 Aug 2024 21:22:55 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Luo, Zhimin" <zhimin.luo@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
Message-ID: <ZtB2L2yOHP-Um5pp@ziqianlu-kbl>
References: <20240829023800.1671210-1-aaron.lu@intel.com>
 <66b93a394bbeb6cc23860efe61a1771ee57b86e5.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <66b93a394bbeb6cc23860efe61a1771ee57b86e5.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0121.apcprd02.prod.outlook.com
 (2603:1096:4:188::21) To CY8PR11MB6985.namprd11.prod.outlook.com
 (2603:10b6:930:57::6)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB6985:EE_|CO1PR11MB4804:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f744887-0ce4-4b7f-5e3b-08dcc82db607
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dJ8dwIuwP3kuxLI7GW4Y6qJOpq0ZE3cUIjxSVYfdjUgfFDVYiq0lCMnmBxi1?=
 =?us-ascii?Q?8DDrWXpyD1P/H5Dha0fRNjbf2Pvisk9rKlCK/dakdJl3VboJCZC7Hb9DJ4nE?=
 =?us-ascii?Q?JFew0aoTA+v+PJKQZ/w7C8nBDjUsUdMAs8polbagVkBBg88YX9aoGlEo4byy?=
 =?us-ascii?Q?UPaQlzumDpQrUiETyrRtukMKFjVsMlaJ4iUUbq3HMzNF7ndZ7KxIE/P7sGP/?=
 =?us-ascii?Q?RqBygwvs9LmzNfiuVVKgYk5nfwGh7E6vyojxDfO9Vw/hK35pXUY6V/fkFpu+?=
 =?us-ascii?Q?j140KcTCbTDoM4dGt4pulE8Wp7QtoAMrR1sfZ7ZpOyogppDux+gklPcqIRKw?=
 =?us-ascii?Q?L/alCAc1NctAD1RrhTA0BwPbWTBxfLe1Azvgajaz2EtRQjKAKhafeiNtTesg?=
 =?us-ascii?Q?4JUI8LiukMsenXbMTmUQmuqgq0TI/j8TG3+okd90VrmgT9sW9paDireBtT/l?=
 =?us-ascii?Q?WkG+3MIQANjQ26kzRCoCpTQKNVXDUOHXQ8IEGEPquI4X1iIWghM1ngCNopPm?=
 =?us-ascii?Q?xcUF3a9oc5DaGgjJ0qN5IChLaKfoV+iE0w8gvBSTiTbUtVYXjmC4yven2rBD?=
 =?us-ascii?Q?qn6e9cTQWraPL2avIKfy3K/2vtYcS9NCMaT50C8tMmfne5ShdRJXmurn65AW?=
 =?us-ascii?Q?MzH23vtMgTxjLalBKEL+Kd/iARoFtlzi9trrDDfMIChJCoWZgAafRJ2ZTFyQ?=
 =?us-ascii?Q?dWgK5euvNKfGetE8FokORCZwbkNLFxCze/jkgK2zZSC/IYJpGsZ6VLI4e3ls?=
 =?us-ascii?Q?YN0iX0vOauKhYrmhYso3Zrr+NPUWEiRbYRIMZ1FSmrFOT6Xs78pBUHHudR97?=
 =?us-ascii?Q?8N4OvVhASMsoNM0G2uXGZYTgEdfqmHyyK00+ZFL0eAaIdVzoG/5xKtdtMf0j?=
 =?us-ascii?Q?46aTVsNJ9iCTBT6zaXKsQvDUdj3p83qqbblRY0nhPy4r+fY/ddp8qoGlVKGl?=
 =?us-ascii?Q?K3efV6E+u6YXJA58eUSlkO8BgT1O4CM9PL9ruqSMD7dD5G5NFQNAQ7IlqOqV?=
 =?us-ascii?Q?oVHV6YvT90BVHbSwuyx/rkev6zTriYYfAQDJiczzuTEuQo2wfUdQy+c5NyYy?=
 =?us-ascii?Q?bkxHkn3XGAqcOIO7qi+z3yQvO+2aioaRU+HpaMs8EBSzHYYmst/TsGo4uoDA?=
 =?us-ascii?Q?mjxacEbMA0IGJQr88UyS2sHsFSxvoo/2/jG7G+HPg5k+PT74OmFUUn+X3Rds?=
 =?us-ascii?Q?tmlDjxm793YdQxj748fsUzNiAmcSVsjNX+c8MoZunoWBYIOI/WKvmX/kQE9O?=
 =?us-ascii?Q?lsq+ikYWPmKzDurzL3WFyUKl+6nyCQI5SdR8ewLnTOWXsN2p4p9Z2Dolc5oJ?=
 =?us-ascii?Q?Xrubm7ZinETeaNywI27YTCeOVqf7EMVh0S0d4C9BlSTGVw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB6985.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MM8kkSndsHKQV27uBVuDj/Il5RFjbDIvRvs/2b5k9P2dapaUf1E0XOn/z4Nh?=
 =?us-ascii?Q?/BqfZa+iocjKErFZE79whi/WHNylpPGIeQfKDGQgrvF10+14nd1o4LBwuR6S?=
 =?us-ascii?Q?B6fa/Dyh+7u/78S+XgMC1hyLhulMtm3KUogF7RSK5SqxK3M7L6Gedrg+s9Bk?=
 =?us-ascii?Q?p7rTxacYeposHSPU8GnYrYGiki7kgeufTCavMVyitAmQfLN0sbvXmzZ78elO?=
 =?us-ascii?Q?UfhC48Mx+3lzfAX0auTliasXtIO6osC23fgW7RbHO/HxYoomeW6WuWK0Me2O?=
 =?us-ascii?Q?9cGp9GmeIo3XwATixte/GAv7TrdJA8JUBB0tLxgLKmaYioqouC5m/OkGyY8d?=
 =?us-ascii?Q?InZpwYEdXBIoScffQh0azWyQfzOHgHYd10frvMpOYhk82DKLu6B6ExHAjUta?=
 =?us-ascii?Q?OHQCl665buLLs/eVxaO7C2abYfAqL+XRKuQO9WgSgLO5n8zoE9bxYWXrE94t?=
 =?us-ascii?Q?VqToOkQDWClKwTmYn2UNOBOCLFg8sKkgXVtSxESQmzroYuwLiO3/3mFenqgW?=
 =?us-ascii?Q?1EvywyE204vOujL7h+DZgdNjZswGagB1BceyHOJxsjK71Chdc/ROMI9ITiAF?=
 =?us-ascii?Q?tqRG07Yf+Svn0Wj9nnQrv+v8gGDEMTOKZE3b0F4zevrtnLAIttpY9oBXQ+Vb?=
 =?us-ascii?Q?mSDgoa+rYZ3HHf6v19VH32b072GXjA/goz1UDUDyOtHfKSdKU5//DXnIihxi?=
 =?us-ascii?Q?JpnrfAr4bfiLLVsiciZfHaRPwOrIJsV/GqS7ePUkqj6StyR40uTqD34NW+Uy?=
 =?us-ascii?Q?AGSY0LehkcW1qjM46AguyTcULfCmKTnLeY/DL0oky1M8eueQZpbj8D9VcOTO?=
 =?us-ascii?Q?K/VnaVR0UKH0oqiWtK1fhYz3XRk5I8VZkiw1bLGd7O4Q7oYf1DzaN0D7o6b3?=
 =?us-ascii?Q?uEGiX7Dqn5jiRrrtvuUgNLE1JHoltjGA/hbRMGXyPucUqRwQJBrLv06Zs33r?=
 =?us-ascii?Q?7M89GJePq8kKQ/IfHMmmmODwmMFbzYBjBCrb65voseK3hCh0oExwjV2/vm59?=
 =?us-ascii?Q?FAJ2BBexkjlmQJRXTKkYugPeErOqyrwxkk3RFfw5ic3t/iWah5rPq2uVTSoj?=
 =?us-ascii?Q?3452+is+iKId40LOBF0sqB5gr2b3wYqFOpZdOyx03GaMIXB8Qv8g8h62K+DO?=
 =?us-ascii?Q?LN2LG7i5BXJwWgfZb1/CBAG7HTeF6ZEOLz5NcC7tzTUPFVyKgw3+gLQV3vbZ?=
 =?us-ascii?Q?laxL6TP5i+d6452JFUqLqVtIzohh1kZobE5SoRwnmHvrYAnpdr/wAbJvsDik?=
 =?us-ascii?Q?jHNR+R2OE/RGOapxV34EtxdXgkL7tV5a1xI2xHochtFQQCeZoARxQVTjwCdG?=
 =?us-ascii?Q?Pp/HQZzitEQtTSu7syYFL71t8M0Rgcy76/jfYMJaTC8tNvx6276ecQOkyDId?=
 =?us-ascii?Q?hVPuUKK6+i+S9y5J+oorw/tSwRR5dMU0x7OnlaLpLDl77k3VC6lI78jDwXpD?=
 =?us-ascii?Q?kypwmUt+ZDwLhW7OCEDLUNtLLvcwBM6yB62zoEEPXowG3jDb9iBb97oTIRst?=
 =?us-ascii?Q?PZEE9PpKmTKQzzKe44Yg4+d8uGwZ7Uo2mnogi9o9Uvqyym9a22xqfDYgIYTC?=
 =?us-ascii?Q?6cxgK7e/bynb7s/tqJXhD9acTfvMT+E544LdgoZD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f744887-0ce4-4b7f-5e3b-08dcc82db607
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB6985.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 13:23:03.3680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +sjWvaVnEQwM6bTgSz/u/L/z14nhpvcwYJAepQ7sVBJPANSseJpKBHAf1W9sLsAXXwakgMSfums5ZUhUmUyJwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4804
X-OriginatorOrg: intel.com

On Thu, Aug 29, 2024 at 03:56:39PM +0800, Huang, Kai wrote:
> Actually run spell check this time ...
> 
> On Thu, 2024-08-29 at 10:38 +0800, Aaron Lu wrote:
> > When current node doesn't have a EPC section configured by firmware and
> 
> "current node" -> "the current node"
> 
> "a EPC section" -> "an EPC section"
> 
> > all other EPC sections memory are used up, CPU can stuck inside the
> 
> "EPC sections memory" -> "EPC sections"
> 
> "can stuck" -> "can get stuck"
> 
> > while loop in __sgx_alloc_epc_page() forever and soft lockup will happen.
> > Note how nid_of_current will never equal to nid in that while loop because
> > nid_of_current is not set in sgx_numa_mask.
> > 
> > Also worth mentioning is that it's perfectly fine for firmware to not
> > seup an EPC section on a node. Setting an EPC section on each node can
> > be good for performance but that's not a requirement functionality wise.
> > 
> 
> [...]

Thank you Kai for your detailed review, will reword the changelog
according to your suggestions when sending the next version.
