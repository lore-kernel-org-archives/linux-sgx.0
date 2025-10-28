Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7641E23BD06;
	Tue, 28 Oct 2025 06:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761634221; cv=fail; b=bB8WIMjNPYR7xbLNopXBy/UUphP4BHvIwd717PQANF5CaE9f+k24RG1cW6r55o19VGGxzcGfu6+ZZfIu8RKQHhvco6usPcXX7I1Z9u+M5+s4QPWTEqTAx+x91p4G99wJsG/G8S3HBcqfFxLSq/QnLip3BKIgs1bFCQm/x93qn/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761634221; c=relaxed/simple;
	bh=p65NAjWXyiQyUgy1oes8gxhUQEYyzjJ4g70e/QPok2I=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sJNm43wVL1bYsJuIWcBVqaSO3YSI1va5ZLtxz/bPJmDYHCEtLpEDYPeBudvvnJP7HeMvuMUTh6W/qNohKL+ZZ/XdEpUptw8L+ukjBmLhrqzsoRdYsDZIhujeiTHL9J3/vncs8UNErVKaa83oU+XTmQTqph/AWNEnnORogesRS9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AncXim5k; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AncXim5k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761634221; x=1793170221;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=p65NAjWXyiQyUgy1oes8gxhUQEYyzjJ4g70e/QPok2I=;
  b=AncXim5kqFnSIswsi3JQIUgIBEFAHsrf2jE2CnwWyrBDjukvtOWYJO+y
   Mn8vh2lMdtw/2S2bKFXD4c1q3aJgMbVN2+U5t102OYiR9fSod5dFEUCQN
   bG7mWPu6FSEWbs/ZpM3BZGHLTplziV1fhTQKWaZ63Hh6Dpfd/NHrHMIec
   LN1jHMx6vozg8X7iRqx8VMK59+pXN2s/aPY3mo3bLQNuIrzpWdd/55uWc
   w5Emb+zXnYF1/u+eOmbB+/ZBlhoDIfNlodLeLL3196QONMzPRsywmLxbP
   ISEwWWNpdRl4zem2s1YhbwxRQ8LQ54IfoHmAWs8cFbOgC2JoZY7nF+mfI
   A==;
X-CSE-ConnectionGUID: hmb9EohUTQOrfGhrhn4N3A==
X-CSE-MsgGUID: Y8hmy3BWQVmys/B5VyLLxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74845852"
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="74845852"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 23:50:20 -0700
X-CSE-ConnectionGUID: ekdKQ1nzQW2y+sIfOdotog==
X-CSE-MsgGUID: 9JXh/fzEQPy1xTxdkP9pmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="190386908"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 23:50:20 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 23:50:18 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 23:50:18 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.63) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 23:50:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJIgBtZLWQs3g3XzQUjr60jP7pAd1uvrqpRHlC4V7TKt97ZET2Ztkdkk94QKL+afb7CWmOxa6lQGgIPojItKW6E36R3MQ6NoC6ENtvpIrZnb8q1ztJOIWcpBd5CXtVQF7fG/Af8Xn3EvuSXU7Zil3pD+TRnRPgymI/ryajaUj4OZtHpTeQR/0Z5epnGwhCozBKM0MiNly0Y20pWhfgmYeZNnnCM2qajJftHXqED6az9YbNzWDPcQ9wZjIvpyRffiPvHUv1RpiI2uli/4C0bPpBSK0LtKRzpf4pU+MhFLF6br76nVMrvhF/ik7Cj/6AKuOknWAsM3m3MXSbY8NAE3oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JppxGeiCodWVHksojoalC9Bi4BmOeah2oiaRLSudz4U=;
 b=h/kv1lsN3ePa+rV2vrG+daFuqEoJovlqmI3pPcIITjJ1b1Q0cMfirb+Iu6ZSj0dzbFXB2CAdOyzUZBY0cYVYQvKoryWI9aWe8W69Rdi2zcbSrkaraLdk/CgaPW2CeukDwIxGPkoUE6YxI4yrI6zKnDKMakRHaB6wMgp74nK4oe8Q/Ua1R9c3WKrXb4Xw1y/SyDufCB3z1ptqdefOZdpKriL+KTyMzt+AQt1luezorZZo1T9uB2J7QjMY/mGLTK4K3Kz+p48eTe1onAyHmCEEp8M/sfN6M8VDGf3Jq0D/FM52Dwc55FnnLO6Nikc6j71lrtzWPJqPpF05pkxf1t8jag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21)
 by CY5PR11MB6343.namprd11.prod.outlook.com (2603:10b6:930:3c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 06:50:17 +0000
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125]) by SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125%7]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 06:50:17 +0000
Date: Tue, 28 Oct 2025 14:50:02 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Theodore Ts'o
	<tytso@mit.edu>, Thomas =?iso-8859-1?Q?Wei=DFschuh?=
	<thomas.weissschuh@linutronix.de>, Xin Li <xin@zytor.com>, Andrew Cooper
	<andrew.cooper3@citrix.com>, Andy Lutomirski <luto@kernel.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, Brian Gerst
	<brgerst@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar
	<mingo@redhat.com>, James Morse <james.morse@arm.com>, Jarkko Sakkinen
	<jarkko@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook
	<kees@kernel.org>, Nam Cao <namcao@linutronix.de>, Oleg Nesterov
	<oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner
	<tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, Uros Bizjak
	<ubizjak@gmail.com>, <linux-mm@kvack.org>, <linux-sgx@vger.kernel.org>,
	<x86@kernel.org>, <oliver.sang@intel.com>
Subject: Re: [PATCH 3/6] x86/entry/vdso32: remove int80_landing_pad
Message-ID: <202510281407.1fbe8f8b-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026221208.1938173-4-hpa@zytor.com>
X-ClientProxiedBy: KUZPR06CA0011.apcprd06.prod.outlook.com
 (2603:1096:d10:30::15) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8587:EE_|CY5PR11MB6343:EE_
X-MS-Office365-Filtering-Correlation-Id: 983a3762-38e5-47d9-86ec-08de15ee40c4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QuhszYk5MWfjzOpDuivjEjdo1Xu8DJnGmu46rZp/4D8uNWCntF8iqOWdCSSE?=
 =?us-ascii?Q?dMVhimK7TX69f7FcQnpTuheInb7yxxVjr/iK/GVYJj9XRLlPUXOwCVusXUL8?=
 =?us-ascii?Q?Lhk3HpS0pQQ3zP13h6bM5GRARPWkIxPSgThOJRpHa5StYuOOpEi7mEfzsval?=
 =?us-ascii?Q?uLLSmagvdAEDfgoAEVt+Bnp2ff2c2Si/mmdsoyHXC+9yiecQoNrzuhZsNGgx?=
 =?us-ascii?Q?6XvNtFLVTqPfBjprvn8L5p6CwyXAxE7QJzq/do4ai/fN6RudYYUguScRtpDc?=
 =?us-ascii?Q?uLKHSvr64k5bPiTEDM7/oq9cKvY2OJf332GWePyxXCL2eiaD5YS6+1yvjZ95?=
 =?us-ascii?Q?dFSF7hwQb38NFTuk1czkdRDfpf+1/l/E/+p9iZw3gP68KFQnNIxIUTCMe9tv?=
 =?us-ascii?Q?bAUbc9vfhkbewjXEIW6DDp0hpRIzthwRnKbN53sPqBCG/pzWQGxAnk4QcROb?=
 =?us-ascii?Q?VMZ/cyqWQ6iW4U5N+yGvKN63AILZItPJCM8VNc8PXqg0PtIgIHJgaPpqtg92?=
 =?us-ascii?Q?BnsAwZS6iA7siLF8OV2CyXXrYHr6pGm2rrRj/IIkEx/vO5P8vC+3Kq5RoJ8y?=
 =?us-ascii?Q?ADaf0qJZMHpKox+WDiDLjiHwaSj82JlH9nVQ92k8geOh0PCIiZQgjQwkZeIv?=
 =?us-ascii?Q?CBxpIQAGJYfwHwrB2kacj9Nnd9la57/fB3a2Jn8FbrsT44nCiJih0Ln3p1dX?=
 =?us-ascii?Q?5CFJbq9cWqkt0ZzTy9QR7RVXj6zMwkMHP6RyrEzBHk1HTEvsxGNbOkzTlrAx?=
 =?us-ascii?Q?XHoOAZrXQ2u8SbRXBJO996P07HPSP38zQXmuw7x6VHWuVra+DIoERIQgA//B?=
 =?us-ascii?Q?k5ndV/z5OD/1lcDdo1MPyt0E/s1czxFRUg9bsQe4hC1vgEu0+m0ZnmvuJxiK?=
 =?us-ascii?Q?D7lLTFVImevoS38QL1DXBpffA79hSj9d13M7SGAS5uEV5sT/JUtffC3MnA5r?=
 =?us-ascii?Q?u1r9PwfXuOVhMZ8Zr6bD/3ywM8FstBLNfuXYHG/3iMEhZJler9FJruBOnTKT?=
 =?us-ascii?Q?Yfg6MFyKdNpmJqLzlzKzug9XSCKm88uLZthLrVzfLrDvoZpBVxKkstAmj0QK?=
 =?us-ascii?Q?TR12rWVj0tTI+Op2S2/qYGZdZwJbVmtGVEYWtYbDfHKu1yTbzhMrlTbS7dt0?=
 =?us-ascii?Q?gLe+STIdQ3+UwCtjxRb0vZREMpCNIyKF1h8RHUcwtVfUNZWYdxr3Cj/QUEmU?=
 =?us-ascii?Q?oV2j6MbcYmGoq8bwkymCtICtLSzGK17UWFgk6bcCjJxvno7OKM06P/Mi+I+9?=
 =?us-ascii?Q?nSD8CANJPtiFKp5M3mNuNRhSSoVZHezRs8scebf+ooGXWRrYIdg+qO1Lz4mL?=
 =?us-ascii?Q?G7Nk+av+S4+kopAvcwhWhUOnBmREydJE+ORsYhOrCOuf1tmfciRX4tJNhIkr?=
 =?us-ascii?Q?QV6QXYMN+s8iLCbab1I9O4OF0b+zCo8hOV9Ju8s5JaoFb5xAc+Rr4kr2Bljd?=
 =?us-ascii?Q?qNMWktIRruM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dx2kTZUlVZB14+GqPePkzp8uHU8+fsslQgPu1cTlH9MNtKnFfWINdkmWQm0C?=
 =?us-ascii?Q?2s4WBX5YwupkD7Pab9BdfzVO+jHiaqe3S3gzorkb8pFr7gvsZmFNcIAN8UhR?=
 =?us-ascii?Q?rwWn9GpkpFCYs3eENyGJMjtAXFg/X9nD8fMdYynKN5nmLZY5JBzBnHh2X7DB?=
 =?us-ascii?Q?9vwjjvtGyZRLo2Sd4thA7C46i71DS00Gfwe4zX5SEeC15s/RazLIhiRfDEW7?=
 =?us-ascii?Q?R7XCIHbdISHHCrzJgHI7qGmvCD70CuOeOJxaRBQJ9MQ+uxTDyp5Qc/2LyNz4?=
 =?us-ascii?Q?ZCA+eF/e7LJS/NpoP+nCagKHT3KUdrDBRA+2mre7S7SlOBnh5nfME18eW80W?=
 =?us-ascii?Q?18aWtaG/yTmzBnbJbqAHoFhjHY0L1nlqOBbkpwmkQ9SiB4QiOlmJLjTxXh2U?=
 =?us-ascii?Q?Z4v9A1zcZeIXZTxEOaiB6KlSwyHVZAHNTqPLzYc5MIcuHSE/2aWGxdlN1/oZ?=
 =?us-ascii?Q?u+N2YC/WhTlvrN/9gVU+BAmbo2F4FCwOoKK0VbLAYs5NmjsU6pJv9dyJt2Zi?=
 =?us-ascii?Q?n4gh1kRr0w3GZ+5vCaym/VaTXlJe/XUrzmds3x455ib6UaJ2IsvyNHgu8o4N?=
 =?us-ascii?Q?MGhkjDVIoQSdgYj5E0cepQORk5U/+02DYTS0F50LwsSr60GFDW1qn+8WIcFI?=
 =?us-ascii?Q?H7O4drH/4vRuBqqQOiMzDd6fY1/p33CFHP85j2IszQPdiMLsG4W01CzJ3pS5?=
 =?us-ascii?Q?23WdUtmCuHiYEeufkZzNiecWNz3WFHKNMOreplvSy4w4iW806grZgKl4hvUd?=
 =?us-ascii?Q?yfEXU1Mwr3KFroGtZ+NBSJKM1gtGq4TTIY1UH2zQr8VVaCqqARZKSZ1B7bzN?=
 =?us-ascii?Q?zvJj789kdcB4PhZFHJvjy0IUKwhatG/aVxelnHTbuk1O8PuPvAM99hnyUGQz?=
 =?us-ascii?Q?l+X7jzA97fhxKR3V1WoQqs+CI71KPfVQXCt6cNYdhcLaub/NpL2qb/fWIpI/?=
 =?us-ascii?Q?DTFzRnvvqx09TBlrKI6LoM+2pMeP/V9T7ERTbWRlpYUqG/6rFH33TG/E73s4?=
 =?us-ascii?Q?zELY1TztrrGAGNswn4Emcbu5Xgt7q9uWPqdaGDXbjRzISVYi7ScOJ4nOzwAY?=
 =?us-ascii?Q?vJTmEeheAi6f6CxYlAqgXYj7Rzskqml6uvEBGGGHrv1kCfQ869VqeD7QJ1P0?=
 =?us-ascii?Q?D2+6z5bbt+uL4r3t5IAjkqRJTO7gk4Ux8j5u6Ib2U+JZGVvIExAhF98HSa3a?=
 =?us-ascii?Q?/jlyxoksBG3n4yZLG4nxALqdaNiIjE2e9AQGqMKv1lngKtfibYy6Ye7CbeLT?=
 =?us-ascii?Q?8fMwEDvWHWyUEU+OyxFwHASPrCQmxLx2X3TJYRV1N1TzGKTIHO88O3IOlURz?=
 =?us-ascii?Q?9xsaAEZp8ymUf8mFvFnqMo1cFCmh+nrR1FPc3mQg+5MYcri8fo7DUaldKV0w?=
 =?us-ascii?Q?JoyAm8lSkGjgkOrN/FBNeAk+7kFmeo7z6u8A+a5WxXIsUl1ZJj8yngSYjj+f?=
 =?us-ascii?Q?LXzzeEjO0hvIdKWIdfq701DFnYYbyXPYClWz33Y3Oo3xr8ZGHkiK86C14P8g?=
 =?us-ascii?Q?tXX94vnSyLvEbKw8Z2eFBjnL7LQndZ2bDvB0RipRV3fm0rzk+tocSg4iRP/C?=
 =?us-ascii?Q?nuXmFHc+mgLJA94jN3h1spBMaFXJR5sxoqLhxQPGuG/oioAaw2tATEVpcg8h?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 983a3762-38e5-47d9-86ec-08de15ee40c4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 06:50:16.8912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJlUHUOVu64A3u7xDlBDBnmxFaI6w3P+r8y8TtxdeZzRGPMc6qhG7g+zIYgg7mOf7Dn/VHJr8GeludIFhzAJhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6343
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "segfault_at_ip_sp_error" on:

commit: 19009b8428dfbeea0ecf043c063cf3336282eb2b ("[PATCH 3/6] x86/entry/vdso32: remove int80_landing_pad")
url: https://github.com/intel-lab-lkp/linux/commits/H-Peter-Anvin/x86-entry-vdso-rename-vdso_image_-to-vdso-_image/20251027-061505
base: https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git ad74016b919cbad78d203fa1c459ae18e73ce586
patch link: https://lore.kernel.org/all/20251026221208.1938173-4-hpa@zytor.com/
patch subject: [PATCH 3/6] x86/entry/vdso32: remove int80_landing_pad

in testcase: boot

config: i386-randconfig-002-20251027
compiler: gcc-14
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+-----------------------------------------------------------+------------+------------+
|                                                           | 28c61beafa | 19009b8428 |
+-----------------------------------------------------------+------------+------------+
| boot_successes                                            | 6          | 0          |
| boot_failures                                             | 0          | 6          |
| segfault_at_ip_sp_error                                   | 0          | 6          |
| Kernel_panic-not_syncing:Attempted_to_kill_init!exitcode= | 0          | 6          |
+-----------------------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202510281407.1fbe8f8b-lkp@intel.com


[   12.230099][    T1]     selinux=0
[   12.230498][    T1]     prompt_ramdisk=0
[   12.230942][    T1]     vga=normal
[   12.231367][    T1]     audit=0
[   12.231748][    T1]     ia32_emulation=on
[   12.246128][    T1] init[1]: segfault at 1 ip 37fad006 sp 3fb8051f error 6 likely on CPU 0 (core 0, socket 0)
[   12.247169][    T1] Code: Unable to access opcode bytes at 0x37facfdc.

Code starting with the faulting instruction
===========================================
[   12.247782][    T1] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[   12.248459][    T1] CPU: 0 UID: 0 PID: 1 Comm: init Not tainted 6.18.0-rc1-00004-g19009b8428df #1 PREEMPT(lazy)  515832f7b4d7c2dccd9418532bf066894e2da3fd
[   12.249461][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   12.250250][    T1] Call Trace:
[   12.250556][    T1]  ? dump_stack_lvl (kbuild/src/consumer/lib/dump_stack.c:122)
[   12.250943][    T1]  ? dump_stack (kbuild/src/consumer/lib/dump_stack.c:130)
[   12.251324][    T1]  ? vpanic (kbuild/src/consumer/kernel/panic.c:404 kbuild/src/consumer/kernel/panic.c:511)
[   12.251677][    T1]  ? panic (kbuild/src/consumer/kernel/panic.c:365)
[   12.252001][    T1]  ? do_exit.cold (kbuild/src/consumer/kernel/exit.c:1027)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251028/202510281407.1fbe8f8b-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

