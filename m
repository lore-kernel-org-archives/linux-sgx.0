Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEFF4C81;
	Fri, 16 Jan 2026 08:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768553856; cv=fail; b=RbAnTAIFVeK1/Pm7bAza77ws/urnZlyGopdYaBeh4oHf6AS85N6YKuZFoYFQ+pfVWG4uOEjB+yT5HIpNxUd5BbyHiC9GYVhUy/txdUkpIRwKRMpH8JZnKuTB6LhVr9Ej5oOmDKYkEDHODUjVKiFrcGYdsOPznnF5cNAvY50/Z5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768553856; c=relaxed/simple;
	bh=XDVOWIcIex2R45M4I6X1ujzMDif2FbwecIMfNuzfBZo=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=qN0kVJUlboddwLXmDEWjntTCdrd1vSta6Nx4ExgF7MRCbWRSWW7JAsRU9D3KDhi/1lmOmetFslQ1/k/V3XXcsNcoAHE+ZrJN6dAQhvtlK25C8dkfKXfD7/8+tXvslBn4QkzM232wwf5SdR8Nya2rI7OOAlPyddehp71BUNi/tNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nYIWOrF3; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nYIWOrF3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768553854; x=1800089854;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=XDVOWIcIex2R45M4I6X1ujzMDif2FbwecIMfNuzfBZo=;
  b=nYIWOrF3ioBzHzrkQgq5QJujk/G4coJ5ltamPZIZwMVZwvmwfXUu2IWy
   ggVKS/etG0N9nXQtkbSyqtWW74isaJvffw1lfwwoPCp9POZCMsqLgWmb5
   g9BqbL1us8/pBY0p++V0PbYHx7ZyuMZ73pe98Ezv8RwPg+2WnVIA6MUj8
   VRE0oaOQ5AQqDqQQiiT1mMwv+wbEULGvVm5kC1KF1rm2je0LEnFwB8wqO
   pCqn990A+UDBVmUD3s59civ+fK9yMptFpVmmu1NlB5yDa0ufA0wKlXoSO
   OfCC1VC2Kgu3+JO1NWKMS1JcDvJnN/1+Bfn4Vk71tPsgjyXSGOO72vL4u
   w==;
X-CSE-ConnectionGUID: mQ8f0P1VQG+dbgPz3274OQ==
X-CSE-MsgGUID: twVzl9gGTH+KiC02FbcoAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80982558"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="80982558"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 00:57:33 -0800
X-CSE-ConnectionGUID: ne5O8JGSTbaVUB1w+DMotQ==
X-CSE-MsgGUID: RR3QdLctQZ6tZnP1CGslNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="205613905"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 00:57:32 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 00:57:31 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 00:57:31 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 00:57:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ajjdH0LI+vW7InjSlLlR2tdxXk2A801TNkha81LKprwh7N8J/PlsNoRM8/13hKV6NfQxCEmU8jb9CcEWOCayj0zIO51U69AqlW3VJOgNeTQQmGYQ0MDlFAPxZE1cDrxztRQiClAOlOxPm/bqBVOHwe8TIyPECm3Ih8aXfrleWN0+DMEoXeipvq70e0J/OtyTlQ4bBxDt0gc816mPdn8r/sd83ieGemrb0T1zlXhdK8C/ANH4XRIYIwiD6goqVxTgxhe8HznWcVbfN3yEP3HHYS7E8k+OH8TyWxo3Lge0qAooV94HD3aVzdvw4dCX/uSxjMvNY64LaKZaDC6w8lPXug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3oPa+2iGIHLbJVcXASfaBgy/jkgtQ8WrlnNrCukg4g=;
 b=XhCBtfBgGEhqZMfArERL2+nW2bdpRlv9pFuH2a85jDix3EEdg4ROtggKBJDY3jtaw1WHob5CEODPZ8W2Pa6zBSblxNpthFCZIbgBbC+gWxhAODcsmDs+r5L0ce7u7Kx2j7wo1JCBPh77w8jlxHfHvXTjnRZ5hswMunvM2l0vQzUJHrMY0LQgdhGnUOVa3/eWvcouAB+LculVLxKWvmEMLDZuA3iBqEOW5n1Te1CVwOu0XXyVnxSPjG1TmbGiM3RuG2h9zvJBAgXnIRtVwULg26QJEckfJF8JnbSFCXeUUiXYbu91TAFgODdmbqQ8LovBcK3q16GrxXbBkz849tB/Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CH3PR11MB8416.namprd11.prod.outlook.com (2603:10b6:610:17f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 08:57:29 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 08:57:29 +0000
Date: Fri, 16 Jan 2026 16:57:20 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [daveh-devel:testme] [x86/entry/vdso]  4a3273d119:
 kernel-selftests.vDSO.make.fail
Message-ID: <202601161608.5cd5af9a-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KL1PR01CA0090.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::30) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CH3PR11MB8416:EE_
X-MS-Office365-Filtering-Correlation-Id: f9ee83b7-d6aa-4521-d1fc-08de54dd4638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GTkts5K7Eklz87vujJFroTuMkYQf6hyw1JHnfmzhhMzJX0fFGay9s8gJkT7K?=
 =?us-ascii?Q?vyNJc0ZEH5ffRRkzvLOWCtS3khg6sEo3SfeSQkK4IDSeq1Ih3go96BlB5Qtz?=
 =?us-ascii?Q?IWRc7rrW0Cj/69yGkr3m9vg7bnmrvsDOihlXb5v+ilJmUfGZyE7OsVYvCZJF?=
 =?us-ascii?Q?z879+OaA3dC8ALGIan9H6lhnHPiU85EwtltQRBzDVon/VZkI+E1vB5ekgJHz?=
 =?us-ascii?Q?oGlFsavuSpNXvGbpnCNdffn/wPYhYLETOnCT8s2oZ3bC4VGe1nLWFYQMn6kb?=
 =?us-ascii?Q?D/N8jspkVYrfz7sGck946EsRqip7N800HFerCUA2sdAav0T1yZXRoyLh3MA9?=
 =?us-ascii?Q?cNWT4In+Hk3oWQM7+73VUvsRb4CiY3V/+Bo9mvj7B8N251f5nMhlGjKWWq0o?=
 =?us-ascii?Q?pRUyzSKGCBAIEVFSj2cNTseLx4eXfKbXPn6ZW398iiArTYyulgxkU7r98gMF?=
 =?us-ascii?Q?u6GP3T09VuL59LlIg4zrKLG0COAWcIMyxGZNw82+IfDTLx3EP5/QJbAwTDLf?=
 =?us-ascii?Q?10HqhzcfMCgh0isk0HMUwKCxWVwY4KJsuzQr8pWPK2AlvHTFq5Lzd1i+8TWD?=
 =?us-ascii?Q?6Qa3ThvHjpokUvevhWOZZjEVZ22N9BGpPJhZRiO/vqV8Z0bH3RSh/tEupR3p?=
 =?us-ascii?Q?ReH2mXa6vjK7gPBv6WU7K/Gh5i57O1HR5FUXFFKUYg4nsUaCXK34Cf86xjqz?=
 =?us-ascii?Q?BuvHeyglBYN9IaKg/oAzPjWHSh9dO3puAIxuXy3j4LOo526C3FlZs0kgdAo1?=
 =?us-ascii?Q?foGkMvRtKkl4TYGnyRdBGY5yQ4O7w0Esi6IaWy0Hu4SkkOMwpskJNg8RBlD3?=
 =?us-ascii?Q?4keueu1EZWEJgWuYzljlpqn3st5unAq5fGpaK9kemR2Wry9iCBRSjSGq1JLq?=
 =?us-ascii?Q?zlrFJNS4/p8nJULtI+m9rOkMr9uiQzoRh1z67GuYo7QQqxLTgScTOJkWhP6g?=
 =?us-ascii?Q?2RmWkMQunTuP3tZWiy06GeQWr4Td7Hd2NkmpXeTcAsQ4UBwm3/dB0MWoe9GE?=
 =?us-ascii?Q?4khfgZO3FxAbjYm5UtDuLHSSlMiZFiWz1V1SaKz+NNCElWdMz+RgNq/IOFMn?=
 =?us-ascii?Q?f7+iWwjXz2XDQf4ikTgA8B/gOUaLZLUzaDRsWL+BXkaLPtUMwBeoQr2FPd51?=
 =?us-ascii?Q?lXoVSaXtdskLkEjav1lYuQ5AjCOS0OLgL+ze3XufmT22mZuD/gQqlNyij+wx?=
 =?us-ascii?Q?T8iJGPqTGqI1BDW6Pv4cMhSUSU05Hy+R2rQZwN4qCm3R2jZD5dYv8o3b4Gy/?=
 =?us-ascii?Q?FCfUIukKHph0CKgEOCvKWs/8N2UT3EvQhzgw8Q7kGj/NgHqbG750m1G1/++V?=
 =?us-ascii?Q?NW6cTfP9TdbkliETMlmnHNni8pTaNbH59la2wbU0lZ6QRqJz0sPCaLZUZypP?=
 =?us-ascii?Q?R9KRPYNXnw7Pw0xBtY9sxfiZ9uO5fxq8GKAEpBZT3cdWaHrb0QLldedtqV77?=
 =?us-ascii?Q?iGgahxqAIO75BUppJrXDC1Y6b6IZEcO/2Be95TdlmiyueeuKPwYRBC0Mu2D6?=
 =?us-ascii?Q?D/xYachlEXeJtdo/Zm2bvwacv7+Lb37a9aGZHzv3cPks930FggD4AZTjI9R3?=
 =?us-ascii?Q?yARh9jOvlezDx5ETuWXOJLcw1VdThL9Z0j9BpDDJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cNW61GS4TcumZW53Vh4u/r2Rp4CIPmWi8Grh+rcv8mMVUSbYXFo7es1ofPM3?=
 =?us-ascii?Q?fBk/iBS0YQnujtkg53cWZJeC/kkjVIMiki4ptyxo/FgHGkR6qY91LQTINp0X?=
 =?us-ascii?Q?TgLbuLLpnTtFfdN8ApbVcpUQ1t9rTrzVnRy5YsV5f6lFo6DMSA1WZDUYJoms?=
 =?us-ascii?Q?tpTCKEuosJgVgYUGu83yBcAkACgTXBLboFuVrhVxYW7yzg0uqNnWHcUJGq2M?=
 =?us-ascii?Q?jNevL45UHxOUZ05PYqGLN6k5tlDTxkmnAk++LEXRCKQi/shXqAStav+gXYem?=
 =?us-ascii?Q?Lkp2BSDxvjTOmW4nFS8dPbqA/+Ta+DQ6iLVk2kV2DYW2uBM5PHigt2CBFcfx?=
 =?us-ascii?Q?I+ogmg8WRQ/s6PTdhFwWQ8k9CDp+4DpS8cTBUZC9N+blktgcl/duwMCyDsaf?=
 =?us-ascii?Q?r+3T4FvvpGKYL4HE+DoEdel6VQx/8/EoLXLGwVa7Dtom0Gtvi9Qa7S+fLrup?=
 =?us-ascii?Q?mgkFZX9Ba3kx5D4L+O35mpJenCJA0kWSvk+zxK4Ld1VDKz6aiORFHaU4Z/4x?=
 =?us-ascii?Q?SQ7sQ/ygs/6oht8DQNdeC9w+3s/bUimEwZbO8meRINxTErSeBwcLpOZkD2pF?=
 =?us-ascii?Q?Y0nubwT7+GOhsOW7T7jfyTWCAdBF2/2qmcWhI/BX8P8h8rPkZWjcfIdQ0Iaw?=
 =?us-ascii?Q?fPLsj6NSCDFul9fTvv/ZZ59SWy/SDNV9ZsNQh/b/vqTV5rffJGnTVIN1joCM?=
 =?us-ascii?Q?4rMo98bxRwwfwE/0MVYtUv5LdetDqyyVFsyQdjkxliRoYNagtnDf1A77sK6Y?=
 =?us-ascii?Q?9o3t1pW3brC2j7jUHvtt8UZsgWMPQHwOHIvMG739NdSHL9RM7HU+k59h2UK+?=
 =?us-ascii?Q?go+W4SNjNYARPxFW8mdgDPeISQGdsnKRESC1yvEffM1Ez8PeGXaxJO0n6um3?=
 =?us-ascii?Q?Krf7oyTAKny7fyBBONWhuS6qrZCDiWQ0162wkUc3A4DzD8LXsOy/apxdQlP8?=
 =?us-ascii?Q?vQdNsZZmJ7Aa49ZGWwO5GFHnv6MMsfNtfWA1wQYAtRq+Qz53CWAhPuu/KgTH?=
 =?us-ascii?Q?H2kAWFiXAt9oyHHhAOQ9w2unjOj5KRI0a5izpQXzZMiOfciIESBOxpkPJubk?=
 =?us-ascii?Q?3iu//zifORzhTaHJbE2t54vTcM+LaIySeGaicDj2YjUQtlcosgRR97/XdNWf?=
 =?us-ascii?Q?rQhDn8WnXekbsolR3Hjrt+bj12fU5v38xg0hJL3CQ/jhkuTlyEPohK0f6wlV?=
 =?us-ascii?Q?ge0uNiYxEpfY3TKx9goWCkS8586BHOugMFQheXK4y2Wokt5FmyRfAVjrA/IA?=
 =?us-ascii?Q?VnB1o2XTC+PpqTDDcb6jFAcPHaiNdXUyyAlljlP94bVjTXndInGhwUxwE0uf?=
 =?us-ascii?Q?sxGYks06EbkyppU/pkeWx7OvE9qeTjV2yf/XeNngBWT6SBNPFhb2m9bsViuC?=
 =?us-ascii?Q?Jf7vxDnN4rM3pN/voRn59VCc3MUJrQ6+0IPd3l8dDNq32Iian3TmE1YLlMPg?=
 =?us-ascii?Q?Qou7yohrBRakqNaL5+Z2LDiQ0qc86oM69RCBSvyRiiQKrPwA53HpSy+63opf?=
 =?us-ascii?Q?qTDa0QkzuWmENVIZzW+cO3Bnt5GYE+7RA0rz7SV4zx//81FANqIiKeVwZlhe?=
 =?us-ascii?Q?1rOml/AwqGa71HHm9/Jwwnd01PPQM/+o/ra7WwXXWi/ADmUB1BoUym6faxpS?=
 =?us-ascii?Q?Amw31IHCR4kx71KuOSpgNLJ8Lyaq4Sh28Nb6G3O12SDABsEREQ5LEYo7nZZW?=
 =?us-ascii?Q?b9vtX+LSlAYzx+6Y2xt2eQugJ2q+JfuX2DU7KNJMvkBkKLL1+ILhRwobwM7p?=
 =?us-ascii?Q?pcTh+E6aYw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ee83b7-d6aa-4521-d1fc-08de54dd4638
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 08:57:29.0189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCYLkMFbqTggxvMK4FqG6lLs/pwa9N4+tCWmTt5Et8FqE2cIJjcCJNZx9U/U9so1c1tfLtPix4S9vUyzRrpR1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8416
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "kernel-selftests.vDSO.make.fail" on:

commit: 4a3273d11995f55d8b3a00c2879955066c1f88b2 ("x86/entry/vdso: Refactor the vdso build")
https://git.kernel.org/cgit/linux/kernel/git/daveh/devel.git testme

in testcase: kernel-selftests
version: kernel-selftests-x86_64-f0b9d8eb98df-1_20260108
with following parameters:

	group: vDSO


config: x86_64-rhel-9.4-kselftests
compiler: gcc-14
test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-9980XE CPU @ 3.00GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601161608.5cd5af9a-lkp@intel.com


KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-9.4-kselftests-4a3273d11995f55d8b3a00c2879955066c1f88b2
2026-01-15 21:09:02 sed -i s/default_timeout=45/default_timeout=300/ kselftest/runner.sh
2026-01-15 21:09:02 make -j36 TARGETS=vDSO run_tests
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-4a3273d11995f55d8b3a00c2879955066c1f88b2/tools/testing/selftests/vDSO'
  CC       vdso_test_gettimeofday
  CC       vdso_test_getcpu
  CC       vdso_test_abi
  CC       vdso_test_correctness
  CC       vdso_test_getrandom
  CC       vdso_test_chacha
  HOSTCC  scripts/basic/fixdep
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_32.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_x32.h
  SYSTBL  arch/x86/include/generated/asm/syscalls_32.h
  SYSHDR  arch/x86/include/generated/asm/unistd_32_ia32.h
  SYSHDR  arch/x86/include/generated/asm/unistd_64_x32.h
  SYSTBL  arch/x86/include/generated/asm/syscalls_64.h
  HYPERCALLS arch/x86/include/generated/asm/xen-hypercalls.h
vgetrandom-chacha.S:19:10: fatal error: ../../../../arch/x86/entry/vdso/vgetrandom-chacha.S: No such file or directory
   19 | #include "../../../../arch/x86/entry/vdso/vgetrandom-chacha.S"
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[1]: *** [../lib.mk:225: /usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-4a3273d11995f55d8b3a00c2879955066c1f88b2/tools/testing/selftests/vDSO/vdso_test_chacha] Error 1
make[1]: *** Waiting for unfinished jobs....

...

make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-9.4-kselftests-4a3273d11995f55d8b3a00c2879955066c1f88b2/tools/testing/selftests/vDSO'
make: *** [Makefile:211: all] Error 2



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260116/202601161608.5cd5af9a-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

