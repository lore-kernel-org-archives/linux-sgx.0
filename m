Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F191152165;
	Fri, 30 Aug 2024 06:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724998486; cv=fail; b=fdG0M3xP2LC1YFBbxjOxpP8bBSrNNzA9DcX6Gfl86Ei/DaubzkeSDXTfoAuHYKND5jHfF4P+Ibdfx6/rM73LdpM9vgI4wo7607+xWh1/T6PrsOptBlR+wUaC2F6GeaUj08RMIhJ8zbht72Zso0ORw7qWisEv0Da/6Kw9t8680Z0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724998486; c=relaxed/simple;
	bh=AsiJc6slhEZfGWsdB5ekxTM5+U4gX2h0ZBaJz98Uukw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oY/4pxFk1hjcnyUNxqBYVIxkDuhrKO1/sXN0xeiAlx9jRe8e552BXk/FhblagiLANxGd4HUr3KxwOjlOci2HHmGVUX/1hjSrvwM4nFrtKSac3TYOdUodzWdhR1fyhLnSfY8JDAuHvBEt9c98uo3lA7YluISl0uf7HTZTOhd1vhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IZSOa68t; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZSOa68t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724998485; x=1756534485;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AsiJc6slhEZfGWsdB5ekxTM5+U4gX2h0ZBaJz98Uukw=;
  b=IZSOa68tD1KrvtkAprgmZlQkhsPCDS8BXUjgJMv0iUsO1mxhFqarXv2S
   35Z9Djdpg4yDJPx2ublLCCLGGQlrNDVdFGUdayDcrCa1U7EmGwVUq1317
   hkorIzAM2hDmKj7WzKuGMpFPLSOEH218cQjMik6QQQchCWFq186FrAk3F
   PusGh3ImisFXBwXm5Rk7z4V1cg4Pp27g90bjHInv39aMQD/bH4mKGMbs8
   Al4Sg5s56tjMfgQ7CZOr9cBLhPFczyF6K7o9Wrtk7T8B99UdDH6AMwkKi
   62B8ms9UDNV1jrpeMilRfUGwd+Py0886uLnf5DIq6YZ1ZbDrD2flV4IJv
   g==;
X-CSE-ConnectionGUID: kqw6bg7eQBCLqSSlDAGd5w==
X-CSE-MsgGUID: eHhVSFxhTLC65i8lse6IPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="49011482"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="49011482"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 23:14:44 -0700
X-CSE-ConnectionGUID: Ij537j3jQ4qipNvwyhZvBw==
X-CSE-MsgGUID: WwJU4QmuQq6xZj8DqjC2LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="63792664"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 23:14:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 23:14:41 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 23:14:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 23:14:40 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 23:14:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IyGq+40DMtN2zrijzlxjci/9GelABF9XiHiYjQ/BAo1yFJi4Ftbe3modM7SAEeINvXexy5ZcFRwhwQzOIWsVZZ4li2ZpHx99Oa4+v8I/pSfZv7a+Vtc8tiMEWbwIa/00UjrRfFlCCz3Pqw4NK5FQZPvcrNe9Kvcx5RDuaAAxlcTJQcF/iS9Ddtocc0cal9u0NuXYMI+2KtupXMACIErhCW9jEDasojaeo109+ZVqeURX22RW6aUZ1fTkGTsspltvqq9CxxP5go8Z53fDDlVx4gTCo1v4LWVm2QALUaGeRSjgsn1xpKRq1PBN3Buasc3LDZb9aA7pmwhAS0Rd0G0BDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78tYikq+5L104hhYFHXa0GDLKtGx3IdsnSiw/fEekG4=;
 b=WFbSe02jWYglgqmmWx6STl7S5q/7rIQXnJJBuotnVWQWU0vE8f+aIh5WD6M4omb2Fsuw8lhBavkTtkz4lsjztGvTlWUEuaEdQzLiiJRR0v6BT4xEPWpEYYfeADSuyuyQ9wnsfB2UTvR002ePe53CfFBVNHPz2Ao/ARVj0j3ioHik5Mewfb/3SKa0DuLp7yLhn/oVDOTXrnzoAhCbW652xP6iegX3ab9DQzS+OGJDKQKkq7o2AxmK1hgvrJP2zlCH08r9WXNS6LL+a/gkBQ3zjgn4rRXdHJR8V5aQIAWSRGzHHY1lBlgDxp2UTjfDzTlqzpeHtuSt7oTFC1iiWTfMKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB6985.namprd11.prod.outlook.com (2603:10b6:930:57::6)
 by SJ0PR11MB4909.namprd11.prod.outlook.com (2603:10b6:a03:2af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 06:14:33 +0000
Received: from CY8PR11MB6985.namprd11.prod.outlook.com
 ([fe80::77ac:889c:cfd9:b9f5]) by CY8PR11MB6985.namprd11.prod.outlook.com
 ([fe80::77ac:889c:cfd9:b9f5%4]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 06:14:33 +0000
Date: Fri, 30 Aug 2024 14:14:23 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Zhimin Luo
	<zhimin.luo@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
Message-ID: <ZtFjPwNWS_hfs4px@ziqianlu-kbl>
References: <20240829023800.1671210-1-aaron.lu@intel.com>
 <D3SJOVADFM48.JNOIOZJ0J6OE@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <D3SJOVADFM48.JNOIOZJ0J6OE@kernel.org>
X-ClientProxiedBy: SI2PR06CA0016.apcprd06.prod.outlook.com
 (2603:1096:4:186::22) To CY8PR11MB6985.namprd11.prod.outlook.com
 (2603:10b6:930:57::6)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB6985:EE_|SJ0PR11MB4909:EE_
X-MS-Office365-Filtering-Correlation-Id: ae25f5fc-1058-48d8-f2a6-08dcc8bb040b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ruc422HRVIumQ3xQsisAKjvHMMlgFuGhjpA3FEAylmuwY+eoa5uNIY3He94x?=
 =?us-ascii?Q?9D+9hOstDWUoZDukgZvE6eFGiJk+4qDMPk+BK0/M45ZapUGc0SiS24sie7rZ?=
 =?us-ascii?Q?iMdr1qFhxzio008ebtaPa+nrLPDqF3Y1F3L/V1Fh/fKvDy6ncPzGIe5rh8wY?=
 =?us-ascii?Q?a0DjLf1vok7MKhbNHlvzTEyJHD/4cVtSFhs7jzGNTUwDLEsVGhRcXTGwvUeW?=
 =?us-ascii?Q?vM2vbOnTqGDaH33PX1KwGrRAO3E5BrMKWbCbl0razWlVU3za1BsdePeuYsVz?=
 =?us-ascii?Q?x2T/qMsTPCpyzZqyZb9aYpa/Zb7wulbw2BKKanSxrtIkiXIDklcFT3YTtThV?=
 =?us-ascii?Q?sN6w538LsIw9iZal803FW1Qwel1yDJ4FRub63XcRkIrB5UDR8zv27ac74kWG?=
 =?us-ascii?Q?HgDtY8/DyE+Ienzz/kSGYul4DIub42iKkUNuCez+XyGVe7WZZnXs5Wx8fUfB?=
 =?us-ascii?Q?f1JpX5VYr1ooNOtNtJrJkzxFWxB0/5OlniDHuOQswveFm9gihPdD5MBF353U?=
 =?us-ascii?Q?OEPKmfpKZVqGLB0t/nZ2qCj1eUWY5m/MDMc5+fDyXaOtCw7zVIORtC6tqxCD?=
 =?us-ascii?Q?XMhQYWy6noRQ5iW7t9ey8aLMa0a5mEbgPBQYZnPspGt6YBlcKLF4tJLfSfe9?=
 =?us-ascii?Q?tBwyDt+ncdZIGE8LMiX6djB8nJnSEc05Dzy0cwu1ZOqt+8zyOqXhDPNS30s3?=
 =?us-ascii?Q?jj10i03kATMmJ3Bgzxjr0co8urVt0bdji2mWEjf9k8TtJravr6URiZmgFtWa?=
 =?us-ascii?Q?JqavpUXJ4pNb3rwxBZ8/v+5tjguekVSutu1l8n2XfUcoymeZrZLrB9VQPz+6?=
 =?us-ascii?Q?eLAzIPi5mu08F86dOe6Zr5cutrzHMbkv6dWl5um0ZokI+01OFmGg4wQY1IHc?=
 =?us-ascii?Q?YBgvk6yy8wxxcHJh4rr4/ooBIiYW+87RI7UTG3j8FFtW9y3qIq07i56Kkrhm?=
 =?us-ascii?Q?e5LugZ2BXAqJ7uLY9bFVuU78c9Mn311JSG5U/sJsSKzquk8aBECggf88S+85?=
 =?us-ascii?Q?nNjTjQnX6bVId0cGmRwhTaUOwg7fFj9nOubHlzQ61N2e7GG4hq/V57aGx8+I?=
 =?us-ascii?Q?hwI8N+NtHlqNtvaiw1LLl3ZVyijnBQZ7VKECsFc9Sdh+FM4Bjofihg4vU2Kk?=
 =?us-ascii?Q?TXAYv8q5L5JtOcUyjRefAmmNi5/yRJ1Em8SpUY2C/2mNTcUcfs1Cd9m1FP+n?=
 =?us-ascii?Q?rD51Vyn0r1zHsxShf6aRNz/tl64cjIvvmeDzSgz+f0e71bt2/h3kdyHEZ9M0?=
 =?us-ascii?Q?3nRQm8kkz2vQyxhOIDUAZrrlB8sYbiV0OBJuXXN9znr4Q5pLU++Yeh3od/Qq?=
 =?us-ascii?Q?2n1uMDU7gqcEnBz6B+j6BpDP4z1MIJ8j0sqyS26y7oJodA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB6985.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c6brIHR2l3/2wAHb84vIoF/M0OMYbmLom+XYhpXOqb0f15q4KdJrV/Y+IwVL?=
 =?us-ascii?Q?GmKI/k0C0ZZGUrkSDGAGVgxX4eQx+A3B9ObCRSkn4ZQtyooEBEgimDEGRQGQ?=
 =?us-ascii?Q?Cw4BoQSVaFVaDoHEyepYJ2MVwP2FJPNx163kPTqhzEfsH5U0bF/WfKYvadsN?=
 =?us-ascii?Q?mzU18WLawOzbu+eHpvcDYymdrx7fb8avx87SW0Q+T7l4gQ4P8KapYg5fyu2T?=
 =?us-ascii?Q?m0ADnSkrA0RKRwvv35/bpjhFuw7/0+E0sii10YH6kLhdKv+EJMqV8u7nqQq1?=
 =?us-ascii?Q?TozbSpZzoB9aMuNstJDqUJzISLVA3eslEAopbRrYp8JoPrTNw/jAdhV57/3/?=
 =?us-ascii?Q?xKSPVbnkOT0pDICJXLbjzBmlNO9sKUG6ITCgq981A5AVdClDg4ivFXJAtRL0?=
 =?us-ascii?Q?95r53DFcaIGBGcEk/k6f4qyULazJDUBzTbww9tvQgkzpi2LNYqwoNYnxAvOG?=
 =?us-ascii?Q?CutMycK3yy1A3vIENEV9mNqgUn8IKPDG73mVSsTBWGCNYeBM741I83XMBl/g?=
 =?us-ascii?Q?MTN6U6k/ZTmKmnH+vED08Nj1Uk3/jgqCAFyYD9N5uoxriq+lwQJsAl0P+tCa?=
 =?us-ascii?Q?wepHRmr6T3zMksCCLMGEZSK/gSs/JayIM7p55yAmvUUAEKyqEcwzOZhyE+IE?=
 =?us-ascii?Q?9qBmpBbJVJhlfudV9QutXhx4G1a5ufG+0WCySYhdziAgVtAarJB+IfPU8nDo?=
 =?us-ascii?Q?sQVB69S3KwReBgeMGWrE5lsE9ef9vmXBBO1nOWuuTOcTym/zYt3ZpFL0JI0V?=
 =?us-ascii?Q?fKoOIEd0KU5YIhlHcxb7aCu0stRiricKo5j+tqefBlZBFyDOsPjP/ij26qup?=
 =?us-ascii?Q?73e5esKuPgAn2FcRwhrrVBuIsrz2dQnbT/HblW18vcj8P/HHNtatiZxfSUB5?=
 =?us-ascii?Q?ISzASn3uHcznkUBZRlMehlGTOnK9id0M0KXic14uosJOWD6cxTZq1MYvLoOg?=
 =?us-ascii?Q?uPOQboF5/g6hkCS9i9XJALfaZXqFgcR2buaQSN9kYVr8MDTt8jH2pTRXwbCw?=
 =?us-ascii?Q?oiOfZHsh5Fp7zGpFhsN3XcY5eIbLUEwFrfANA+DS0iYiyouyvQbtmLV/lTKy?=
 =?us-ascii?Q?cBXm1AzOcsIKf8S27hQAMA6UdE3+Za0IvX09A08x4WgaZYwRu3k0Vd1oAlEy?=
 =?us-ascii?Q?PU+vztxfmJcnMgZNmSTejrEq8OHlKm9pnDvLtXV7fvGGP21t/Hl4jM0DWfPC?=
 =?us-ascii?Q?oGMP28Qpc8/6dQfRvNXJbxv12oWRUs7CdAtne4eJYZVgT2m8rXtL4/JOBrCq?=
 =?us-ascii?Q?S5soinlLT2HTw/ty1hsoILGfV+brw1NUZi6dcn4aL06IazBHAqE5lvLAV4Q1?=
 =?us-ascii?Q?jFHvAiVJU6qI+/95a+WgIs5+rS7s2YUiRdwNAMh7i+lT1lHo8ZFoAGbk1Od5?=
 =?us-ascii?Q?L8qLGgojsw0cRyw/5ar0UsUzrh3sJGFGpCUmzLoXMa2kFk8fEdu5Y5Ry/YjE?=
 =?us-ascii?Q?X595sczKIP2fdFb/0zCHrjhPgPRdLSLZysPKd4M6kR+9sIlPmLdRHSiitBsa?=
 =?us-ascii?Q?aCePL1oI2/i6HOiMqdFYgWEZzCZSZHwqlGmAwANaigNfsoux/2Cjrh3mXHbu?=
 =?us-ascii?Q?itkmKiGji95jsZxThnTSZxJi4FH8R2Ln9Ooey1PA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae25f5fc-1058-48d8-f2a6-08dcc8bb040b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB6985.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 06:14:33.3053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7k8udPf2TXwPu8Dwriy4t9q0aYULSUg/1XCP2dAnB9Eer4KxvpE2CwkQ2Zufevp4nIWKC0pUjATD5XnJKbMBGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4909
X-OriginatorOrg: intel.com

On Thu, Aug 29, 2024 at 07:44:13PM +0300, Jarkko Sakkinen wrote:
> On Thu Aug 29, 2024 at 5:38 AM EEST, Aaron Lu wrote:
> > When current node doesn't have a EPC section configured by firmware and
> > all other EPC sections memory are used up, CPU can stuck inside the
> > while loop in __sgx_alloc_epc_page() forever and soft lockup will happen.
> > Note how nid_of_current will never equal to nid in that while loop because
>                                                      ~~~~
> 
> Oh *that* while loop ;-) Please be more specific.

What about:
Note how nid_of_current will never be equal to nid in the while loop that
searches an available EPC page from remote nodes because nid_of_current is
not set in sgx_numa_mask.

> > nid_of_current is not set in sgx_numa_mask.
> >
> > Also worth mentioning is that it's perfectly fine for firmware to not
> > seup an EPC section on a node. Setting an EPC section on each node can
> > be good for performance but that's not a requirement functionality wise.
> 
> This lacks any description of what is done to __sgx_alloc_epc_page().

Will add what Dave suggested on how the problem is fixed to the changelog.

> >
> > Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
> > Reported-by: Zhimin Luo <zhimin.luo@intel.com>
> > Tested-by: Zhimin Luo <zhimin.luo@intel.com>
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Thanks,
Aaron
