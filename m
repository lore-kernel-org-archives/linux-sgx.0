Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636D2182D2;
	Mon,  2 Sep 2024 07:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725263853; cv=fail; b=JUX8EJLsjx28AWXXYsptVXxnVdpf8h+PUNy8ww9Iqo38T3y3yIhPhp5e6vlJSrRsUwi1gwqJ8t1VLuZgaeHK6KdbLjR23dHwAhdeFhOW5h2R7JSiKE3bwuolHGXn2EWsR/cXLi4gpo5KBzGNMvFrFGaayQoGpdfynAwh1D/408U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725263853; c=relaxed/simple;
	bh=3/nX5z8z0mTjiKSRAUHryRPg3sBS5w6lrMrAqEO02hc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AORyKT4hr1bL56FuWlp6j7TjgXL+dA7PiI7y+HlJMvkhIBGfXGyrAa2FZlRn8vJGGtSqp97uNFn+u7JE6yPJLkXttQGx93wtX0vS0jyUjjPgqRf5D2tIXM1IGz/HekyDHttulLM3ZVgNI/jk/brczeorJ062bQ9TrHwddmNzyVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gk8pRW5f; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gk8pRW5f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725263851; x=1756799851;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3/nX5z8z0mTjiKSRAUHryRPg3sBS5w6lrMrAqEO02hc=;
  b=gk8pRW5fS5pykLZOcVLP86Bbwpt617sUV4FKUlTdfmeApNGOCE4iwEBT
   fpWPaOGTWG2C5BlOeXgvBkKWUD6dubR/cVHP84CvKjdrqY86CTZx4nGbn
   no7YcrxnbpKx7YmZ0u7RKV0KyuTsngIuZqx91RKedz6kHpG5K3Dp+HECq
   us3Ft7CnrCK9YeUOH9dyOdB5QXw2Laj/R76u0DhO2/w/KXr3EiXYUc86u
   rTRzTQqeqpTXGRPUhGnPdj+ml4SmOdEsVMhwYViCbnTttpbKxa2vGh4mP
   2QcnGkK5NJuFtfoN2N1riaTDI/G6KNhSNrRnIg4oIljbdBe/eEHZySzx7
   w==;
X-CSE-ConnectionGUID: hDI62YnQTKeTRWznOWD13Q==
X-CSE-MsgGUID: d5sDGhhTSC29z+heHhr/Cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="24014993"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="24014993"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 00:57:30 -0700
X-CSE-ConnectionGUID: uG/4sSALQQ++3839XTi/FA==
X-CSE-MsgGUID: YK2ZdRyUQIe60RJC5L2znA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="69160728"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Sep 2024 00:57:21 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Sep 2024 00:57:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 2 Sep 2024 00:57:19 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 2 Sep 2024 00:57:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpHZt6BRjJNmx9lMewG8vuMVSQvC1+P2bKf40GQcr2pbVc39O4+jdtWGlFo/VjgU8Qt+96VZQ5WTizOSOMSykgHRLDYybm3l+dA4bf1wox5vLyIjM/8kq1zgjviTZTLZUISHEBBco/99GDHDXRH36L7qAsJXlmd0OnatxReSKwjSqcPgPNfCYzS6X9O+rLBB8IH9fDc1uJgWvddojJcrms8vK5z0rj9ywf183cM52zY+cmIwG54E//XxNVS23avi8lEFoErCRggm2HzvXvvAgbvZ5X/ksLRZEgkL8pucSMsXqZ53x9S20Qwk1SYlXEfBOJV+NMyJdwueAT6rt3S09w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hT32dny80WJHnHWqLOluvs0kFEWISJqqGYKUQoi93OU=;
 b=WzUj354WQbU1f5OPvnuovDoNGdz3cFTipEeoZlWxbd8v1ox3W6BYh/cTwfBRp+WPEl7mPE6ueQs8cmlKcqxW0eXPmoLbWvNBdJ0QTGgYxPtMhTIWWe3VHIg7cHWpLR1tzqyEriEL6o5iSiJMFU9kjtTgK0F46kv0PvVBWvk4oRjL31iP2SPaI4lhfoefQcVqFCY3EPT4g9H384R/4sFv9JYiRzctwhGO9qhdUkbG7JT4JeP+gADXw1pS4nv6cofsBsjzxMxDjqYjk5GONTHM68diHmTTX7T5W5+9VNvvF0Tb8ENkpvrL4YZLWzL0HAqWH35/9YnGVHtk4hFC3TTEZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB6985.namprd11.prod.outlook.com (2603:10b6:930:57::6)
 by MN0PR11MB5986.namprd11.prod.outlook.com (2603:10b6:208:371::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Mon, 2 Sep
 2024 07:57:17 +0000
Received: from CY8PR11MB6985.namprd11.prod.outlook.com
 ([fe80::77ac:889c:cfd9:b9f5]) by CY8PR11MB6985.namprd11.prod.outlook.com
 ([fe80::77ac:889c:cfd9:b9f5%4]) with mapi id 15.20.7918.020; Mon, 2 Sep 2024
 07:57:16 +0000
Date: Mon, 2 Sep 2024 15:57:06 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <linux-sgx@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Zhimin Luo <zhimin.luo@intel.com>, Kai Huang
	<kai.huang@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
Message-ID: <ZtVv0mic9YUTpZO-@ziqianlu-kbl>
References: <20240829023800.1671210-1-aaron.lu@intel.com>
 <f2b0ffc7-f8f8-4ebc-99da-9139c372bd09@intel.com>
 <ZtFgem6_2j05S0MJ@ziqianlu-kbl>
 <50688c67-59a3-46e4-a2b5-10c1e93d4b3c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50688c67-59a3-46e4-a2b5-10c1e93d4b3c@intel.com>
X-ClientProxiedBy: SI1PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::18) To CY8PR11MB6985.namprd11.prod.outlook.com
 (2603:10b6:930:57::6)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB6985:EE_|MN0PR11MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c37c03f-d15d-434b-5002-08dccb24dcf1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sl7rYP3wkHE/xAjXqT+Kc611DDPfDDea10+0AMxAdq9QNo72Mz3gCq8WxFmW?=
 =?us-ascii?Q?dR7XovVoHxaCj1/3/vXBZsNejfm+DMofPFsq1TqcoR/9Jr4LTwnAFbsujOB3?=
 =?us-ascii?Q?z77UddNCtmzfvq+SGK5DdSNohhlN9/2o0lUi049jtHBwJ5xXFMzDMgO0GvVX?=
 =?us-ascii?Q?592jfQUt1RKSd8l/YMam3+wpy5XxDS3+Ci5ucNxDapRJAmb4aivJXsSfNWfm?=
 =?us-ascii?Q?Ntfxowm7VAKlwIFWHqv5WcDPzjl3OYVyzJ/fkwN8wdnyoAfY5oQgOfri5R9C?=
 =?us-ascii?Q?v91jOj6nRHe+4B6MNrAC/47OK8+Y8syc/veBXW6FzmhCQ837WPT2j3A+6aK5?=
 =?us-ascii?Q?riUti9vlx14WN7DvQi9tr+E2u52tSPNPhKi+TBd4zyXHiY6hvk7YIstqkzJ1?=
 =?us-ascii?Q?tRVCe82ePHSLZSa3NtVsCcov6wKbegFJlKPdIrHTQp+1yoItRVldx18vykv5?=
 =?us-ascii?Q?tbONH/Eybc/fMS227kXW8BI5ewADQLnbAputaHzTZoSGbQlWBPnuNvCOSnE6?=
 =?us-ascii?Q?y5Eb6iaR0nMQGXO2nI5HVP7QbJw0s7Z115fqEUVX30O8+R1EsigTONF7TVNG?=
 =?us-ascii?Q?lDadcic7OKv+4b1bFhY3LqJ/nvLrxgwvW9IWpRHClLytVmHWkeE5CS05KIfy?=
 =?us-ascii?Q?0cAlNBBfVe43jI1bWxt4z2Ifa74BWDb0g91ZnAQntc7Vm1Yo8dOKC/hPsb6c?=
 =?us-ascii?Q?fuZ+VKkMEu4KM0ESOzZNkaH1kYAcnQDf8dlW2JpE2S3eQRQlgW5Fv85MiX5v?=
 =?us-ascii?Q?iNsWBa1VoU6XoivwM3Sn+oUBbJh5epI047TxxsdzaTO5ZaiHaXcVWQLYjccO?=
 =?us-ascii?Q?9PJVsoSD+43Azs8kH9fjnUVLS/93S2dBLJNRbSWCLsQ+ZmoPn9bHOEx5k/+k?=
 =?us-ascii?Q?I4KleMpiqpa0g+xp78JklBAx3iUkRPqiYb94TxL6CTULubwKb7lUd+3h/rE5?=
 =?us-ascii?Q?BarmMfGR9KlsLjprCpx8Si27/FfPuVy/e+02tpxRKr2Hpg3qHoL5gT7LNmS2?=
 =?us-ascii?Q?y47mdS0Z9id4S60KK3U69GMOI2rHucRf6KElHmhiy8B9txx5jg9Qu3UPu3zy?=
 =?us-ascii?Q?Na7Vv1XwbtMviBmYlVIrIRZdL7TljLM70bOpmiebpJdb0ORAEFjYbYPewPje?=
 =?us-ascii?Q?5rTzW/t6s1cJpW5xWO/DckBGeZdSO7PBloQ3cdSDVEMVuCE+NjTxTSFAMmnf?=
 =?us-ascii?Q?xNrslWdADRz5DLM47FewTqWuAffgRqwVFES0G4QfQESdEmnHe3q4SDktgxD7?=
 =?us-ascii?Q?G5ux3cjvBy1tCDyWwAh8jW0Y+LZuAr452J5cv2HypcAw0L8QdRdwOgyHOSZh?=
 =?us-ascii?Q?1AqN1PqIGRxtO1NpNyLpj2lhNGMIUfIaKFfvUt81IPPexg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB6985.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rsQhn7qpJHW+IV1KegTwiXTWTLwnnzK2RC4gGYIm12I7+1Pw6lnxtGz5yDzf?=
 =?us-ascii?Q?eY3SM2srg1OIjMjRFMmhVmN6MjwH2/WQNQUY81gIeGA62UpIgg1pPx9u1s1C?=
 =?us-ascii?Q?vZ8MTF7RVLzA28n+4CAdxUKPU1gAmPBUeMyr7kOtbSjO2wx660grm2LePiX+?=
 =?us-ascii?Q?A1Qkbs/lBrWVwG2Y7CGMSBQ7FCe2iOmg/bo7OYei0uF+4SVEfpc146L03CFs?=
 =?us-ascii?Q?b/oJc3HP3DxshVPWf3QgofipK+dc56PVfEpdGSUKyooa9PEVDNTnokSkIW1u?=
 =?us-ascii?Q?qOUzS/SMMfI3GFyOQGWg3tRe1Hhm11xkD2ZB+WZssiWu2fYwMY6uW1gpkbDm?=
 =?us-ascii?Q?ao4XlSfn/sYDJAMRM+T/59xybB0qZvMuTcMvK+sft0dFKTwSqfJFJYUJBC5A?=
 =?us-ascii?Q?CQtzUtSTwSfJmO4xcft7ft92obc1dqrpj+9xMbsgemf/2W66OZW4cui8qnEX?=
 =?us-ascii?Q?m0GPD5ACMA9aDhVT3A/HvFgSeIB1+U0iuYbAxpFiM6nLuwepio10kXxtyUo9?=
 =?us-ascii?Q?0vU2nvtop+X6LyeIOLH/OnivtbpDXzFB5krn7kXcDSfJc7Gd8s7V9E+HN46s?=
 =?us-ascii?Q?S06pjLAwbQWDE6IZCizqPKdnYUNe+GBAVus1oNIykq80CbqtcQfSI4SxsT7p?=
 =?us-ascii?Q?wUyomNgDL3iY3GtEormjZvg5tVCA6XOiVBbQ9otTNQU6Yt2cofWLxwgXpHEi?=
 =?us-ascii?Q?ohM/lz7QZNHY9G1RebdBhL1h3z7earLK1X07qg8N1PV4+XkqZrFOmHKPNQ6N?=
 =?us-ascii?Q?2VXzBh8aCyladd3N3Hff6R/TW0CQu4MChnADOogDCnOfnZfKCFngSFCthRCy?=
 =?us-ascii?Q?RkrrkZ93g7ZWoH6t1lU11b0ZpF8yrMH063z072TYPLtjsqfWejrcUKjFa/rW?=
 =?us-ascii?Q?kdLDdU5D1TDKjYC+QC063r/8gYUsdIWFslAdDBYcJcloey1ocz/lVGpEuRzg?=
 =?us-ascii?Q?xC/S2YP8Ff+aeCgLA0ufw702aiRTDZWIne/ccJBzek/u0XlHaECfdbSJOCa0?=
 =?us-ascii?Q?ZpXDfubyO01n3Zgzk34FgCtyuJ4fpsZGUXn7QCc171aw20b5TPdH83MyOsiA?=
 =?us-ascii?Q?QVqVCrUNQukS0VeOsp2ap/kp/51Dt093aEGiBjAY1ViyHMY/tTjR7u1Chqkg?=
 =?us-ascii?Q?L9nX8NfmgsBMeh8l+53MbpFMqjKL4nChKzNhHF9Tiy8S+hUmBMTx9NgW8c1T?=
 =?us-ascii?Q?FneUf93vsajJxGqyxU3cQeDaAlSoiS5ZmVu9dxNBsyzGNMswGmt5Y+vj3gH7?=
 =?us-ascii?Q?HdeV4p8NdPFWvbqtzd3Q6rPa0MEAG4tIylF/vuT18sxvBogDJqdL+4l63I6k?=
 =?us-ascii?Q?Wx1kPdO0aF2NIsK4whJfJR6Mo0enwr66Ufuag0HNr1mvGd5+1z75vbFJc6Qk?=
 =?us-ascii?Q?bRdBpBvAV+JGG3qOoA0yRn4QsXQ2AEDhcyVqat+SVFj/PxlonaY4rciv6Xub?=
 =?us-ascii?Q?+fcqqotSb7fxuP3NvLsG7b/ySmTIBRCpS9ciTxy5X6tESb+oL9yIpUuhXWwo?=
 =?us-ascii?Q?s/KEM91quRNlgOZDSEb4GfPSHo92TtYKY5K8FIJzU7c5/7MPALvUJJVT0lbl?=
 =?us-ascii?Q?dNHtWJb+7p3Uzh4Qh17rsfMDz93JojyoiAlPQjYv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c37c03f-d15d-434b-5002-08dccb24dcf1
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB6985.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 07:57:16.7320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHXMLJtyCfzqKxB+ihA2P+gKheKf89u624/W4mmURzkRnDw6DGm6a38bPO9ka/r2Gn7dDic+wa4Mj5UXwgXVGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5986
X-OriginatorOrg: intel.com

On Fri, Aug 30, 2024 at 07:03:33AM -0700, Dave Hansen wrote:
> On 8/29/24 23:02, Aaron Lu wrote:
> >> Also, I do think we should probably add some kind of sanity warning to
> >> the SGX code in another patch.  If a node on an SGX system has CPUs and
> >> memory, it's very likely it will also have some EPC.  It can be
> >> something soft like a pr_info(), but I think it would be nice to have.
> > I think there are systems with valid reason to not setup an EPC section
> > per node, e.g. a 8 sockets system with SNC=2, there would be a total of
> > 16 nodes and it's not possible to have one EPC section per node because
> > the upper limit of EPC sections is 8. I'm not sure a warning is
> > appropriate here, what do you think?
> 
> While possible, those systems are pretty rare.  I don't think a
> softly-worded pr_info() will scare anyone too much.

Understood.

Maybe something like below?

From e49a78f27956b3d62c5ef962320e63dc3eeb897c Mon Sep 17 00:00:00 2001
From: Aaron Lu <aaron.lu@intel.com>
Date: Mon, 2 Sep 2024 11:46:07 +0800
Subject: [PATCH] x86/sgx: Log information when a node lacks an EPC section

For optimized performance, firmware typically distributes EPC sections
evenly across different NUMA nodes. However, there are scenarios where
a node may have both CPUs and memory but no EPC section configured. For
example, in an 8-socket system with a Sub-Numa-Cluster=2 setup, there
are a total of 16 nodes. Given that the maximum number of supported EPC
sections is 8, it is simply not feasible to assign one EPC section to
each node. This configuration is not incorrect - SGX will still operate
correctly; it is just not optimized from a NUMA standpoint.

For this reason, log a message when a node with both CPUs and memory
lacks an EPC section. This will provide users with a hint as to why they
might be experiencing less-than-ideal performance when running SGX
enclaves.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 694fcf7a5e3a..3a79105455f1 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -848,6 +848,13 @@ static bool __init sgx_page_cache_init(void)
 		return false;
 	}
 
+	for_each_online_node(nid) {
+		if (!node_isset(nid, sgx_numa_mask) &&
+		    node_state(nid, N_MEMORY) && node_state(nid, N_CPU))
+			pr_info("node%d has both CPUs and memory but doesn't have an EPC section\n",
+				nid);
+	}
+
 	return true;
 }
 
-- 
2.45.2

