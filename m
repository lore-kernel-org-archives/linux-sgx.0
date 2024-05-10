Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE5F18EA1;
	Fri, 10 May 2024 23:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715384852; cv=fail; b=a9bVKrZ/4a/BU2G/sf6IqBTpbIUVZcpdsDxPBI8DoQjJYQwkGIvllWEPSM22t8QZTV891/F9WsKui15vCgf4fi3CthdBdtzd2YiPjNt9iVcEU6p+AycPeEKN/jwg2XAjxZF4BRaBU9yPGgSYbh401mFqJ69kBPHsvMkB+0Fb3FI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715384852; c=relaxed/simple;
	bh=+EWGptg/Pv24XwgkejEBv7tMR6RjRtWRqWzennZBptM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=omuZOss6ggXGyboe8AUjfw/0siEq+FWcQRq3lFzzPHRq6GpJL7qvDvnICkUbH9H5v1qzwgJSLVDq6623hVTtaT4C2uHFKKxcjHN8WGTtm03n7HNKOmIFSsxpixo/T03JZCv0mLl8oZzsRaoknECw6wURUljbqEfkcu5hWgWmc5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZsPlB/bK; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZsPlB/bK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715384850; x=1746920850;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+EWGptg/Pv24XwgkejEBv7tMR6RjRtWRqWzennZBptM=;
  b=ZsPlB/bKznrRgh6/cp114sVKKrD0oO/rmqqC+syPrhsFczCsQQg9IFys
   bRwH02piYn6c+cbSk6i1CCoxuHoyb5UY9QXKkQV1pzIfAp7vMlZCeUtqM
   rx0YECfxKmkkFEaZvSGjkPvchBggc/dDga/BBA6QXFpID/x6CRA0vLeUY
   6pE/H0MAe7WKkLs+MLrRz16Ph1oXg4rpdvtHYv1pa2zKFuRGBPfeba++X
   W5bX5jCpfUaZ2tq2JVNTRdELbQiSxzZj4xDihriezV2KxmEoBEfe2Q/BK
   7x1wWQWid6HIc2en5rbl0tJRmKYsmKjQlgghQAQ1Df1/S6FrZJfIaOh4I
   A==;
X-CSE-ConnectionGUID: Am7DreIsQOeTwtZCgJK2mw==
X-CSE-MsgGUID: 3ogjc+z3SvOCPgyzlNFM1A==
X-IronPort-AV: E=McAfee;i="6600,9927,11069"; a="11214787"
X-IronPort-AV: E=Sophos;i="6.08,152,1712646000"; 
   d="scan'208";a="11214787"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 16:47:29 -0700
X-CSE-ConnectionGUID: jBrGTsHMR9iTZmT47/O6JQ==
X-CSE-MsgGUID: prkaZ8trTz+i4s/PnvhN/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,152,1712646000"; 
   d="scan'208";a="34637044"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 May 2024 16:47:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 16:47:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 16:47:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 10 May 2024 16:47:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 10 May 2024 16:47:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvsjTmzbPlOCqteQP1TlQVWGXMwEgtEJXKPCJf6Szp9q7lswL4iTQ58q7G8DEQ103BV2agmzScxv8iSlTMnnZldrAjNo4ZAbX6bFIZCmr+EHsQtazD8waDB1Mu3J7apkKe62zmDeTA7Wyg0XiZMtMyPahXhtI/kbQs5ZQO8ueNBqltYYoGnx2HOFt8BBtX5hdQynpRaBIZQUVzbVJ5yxO8eydoLpBnMWlsy0Sdee5vlrXunn+tqqoc1y4E8PF4Y8js8s0CtrQo4P5lDllikp0b51e2uUoaS52S3y/3FpyNDebZsq4ZralFW2u7+i0U9FbZc2qTHmxcR73iMQA4iA2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GG/8zKjLRg4/NgOQXllqZUcuAy9w6JttBCgqrGYxRaY=;
 b=C++LhHdjpXcDvvD6yFDHwWBaEQxHaGKwNDyBho6OM+3XTQLwNcEX1262iQTueLziHUs/TmNn76tiK2ztWEAq8TuXmU+yXXFl8b/XnJRIMFEgbd4+gdN5K1jvm7cIgFq5w6SDSbC6cdjViGrkUGSvUEuyU2AAOGBRkaQrT/bAE/eha60Lq2O+IhobZAycKq/Y9oAZIVn2WIu+DLkIlmk2+l3ylUl3YvxKI2CB4YvlUcsKqMiD3uCKzcvwCw0gEkb4g/CWEdQwoJM2tEI5xfey1OjjPwB7EHM+6bloEYQ+h3qAkOs1KaH2U4A/g1FEy/GTn9y3gNzi5d2ZiPbjgYIrJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 23:47:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.046; Fri, 10 May 2024
 23:47:26 +0000
Message-ID: <4422e302-5802-451b-9daf-09d7668099e3@intel.com>
Date: Fri, 10 May 2024 16:47:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
To: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>, <jarkko@kernel.org>
CC: <dave.hansen@linux.intel.com>, <haitao.huang@linux.intel.com>,
	<kai.huang@intel.com>, <kailun.qin@intel.com>,
	<linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
	<mona.vij@intel.com>, <mwk@invisiblethingslab.com>, <stable@vger.kernel.org>
References: <D0WMM3MYQODE.3A89L7D6OVG3E@kernel.org>
 <20240430143701.902597-1-dmitrii.kuvaiskii@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240430143701.902597-1-dmitrii.kuvaiskii@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4881:EE_
X-MS-Office365-Filtering-Correlation-Id: a5436d15-02c9-4f7b-81b5-08dc714b8bb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?amdWaGlXeCtsYldUdENkYmcwdmU2YVJJVWg5MzQ3Y3JBb2RjYS9rSVVMdFBQ?=
 =?utf-8?B?ZUZ0Y3dHMTFSTUxJN2xiMGo2YnN3bE9YWEN2b0c2WnM2OXJlMEVlUjFOT0dP?=
 =?utf-8?B?aVZCU2VReE1CeEE0WDJGQmJlTGI0WFhuaFVrUyt6VWU0amFXMnV3bnliSGcz?=
 =?utf-8?B?WmpFQ0tyVUd1LzJqdWw0WjBwa0JtOVBST3l6SXFkMzQvSUJMbmFGYlNOTTVE?=
 =?utf-8?B?aHlzWHhQaU14SFY1VXRpQU9vSVRlemVZRlpoSUk5cWJBcFAydDJraG0zMWtx?=
 =?utf-8?B?RDZaWVdtUjVFemxXTHphRTFTQ1JsYzJGOGQzWEZPQW1xT2FxM3V0VmZxWjRs?=
 =?utf-8?B?Zmk2VTFUc21pMDdSVEpEMzQvZTVhSmdtbFIyRkowbkpOWmQ5MHhXRzh1R29X?=
 =?utf-8?B?WHFGMlNBSkJYOVZFSXJMYVlnbnZHSXB2a2Ftb282L2dWakhad0RVbWJFcXNx?=
 =?utf-8?B?TGdvbGRFL2dCZFk2T3o3MWJPZmxTYjNMc2xjcVBMbXEydTMyMlE4T09tWXN0?=
 =?utf-8?B?NTlVZEI2UUtsOGtTK3lxa2srL2ZFc09LeXhlMENHL2w2NUNaWHNMUlZkM2Ja?=
 =?utf-8?B?K1BaL1dkRk5kQlRIc0Npak9QaDV2UHV1STdBUEJpT3l0T1JjMjB4V2JUNzh4?=
 =?utf-8?B?UlhGLzZVTDhYNmU1Y0hHQnNlTE5tZ2w5U0t4LzVQMWt1Yi9hUDdrOEt1ejNy?=
 =?utf-8?B?aWtERGtCNjdXOW1nQ2loRElaRHRNUnhUaHFoclR1Z3Z2UEpVN0N2RDdYYkNk?=
 =?utf-8?B?c0J4UmNYUDd5V3Q4K1JJUjdyOEU2QUxSK09HT2RSYTIxUCtHa1B1VWFXUCtq?=
 =?utf-8?B?OWFsSjhuby8yZVpncUhsYUVtcE1GTnR3ZzQ2eVE0Q2VVN09LcWU2YXRTdHQ5?=
 =?utf-8?B?TTNyMGpOVjg5S2JDcnVXbnl6Vy90T3BqellTbHF4ZnJGT21FN1VGWHpmaVgw?=
 =?utf-8?B?bmVGbU9iM2tYNS9RQldBZDhsb09GTjJHK2tnNWpRMzNBR3BUcWk2Q1JTREpO?=
 =?utf-8?B?NnArT1lrR1ppTXp2dkhHcnovR3JyWXFXK0gxTEdlaExwdkZvZEJsdk0xcGFS?=
 =?utf-8?B?TEhHR1ZhVFUraFBIS2hnbWR5UzV0WkdPcVduY0FkRzNMcTBHL1JKYVgwc0Na?=
 =?utf-8?B?U0RxUWEzeVVXRCtLTlZaT2I4TGtpZGNVV09jbEF5N2V2YVNOcCtOR2l2bFdy?=
 =?utf-8?B?VXNTUVJTRVNrcUhicWhlYWJNcjdyYkpyNTR6K0J3YktPRnFJSEV5QkI2Z1hp?=
 =?utf-8?B?RFdjeVNwdmJCbEM1Z0FtSkpEay9waVFkSW4wbkoyeTVDb01CNUpJSDZ1WXBS?=
 =?utf-8?B?TjU0ajZCaDlQSmNTVzRpOVlWbGY5ZTFFRmpUVlBENkQ3Q2ZhVVNlSHNTMjNj?=
 =?utf-8?B?dXNOOS8vdTBmNFZuaGlDUFVxTjErYjVvZEQzeUFXaEUzSkdHWDFxVlBkbVFN?=
 =?utf-8?B?UHhqMytpVU85M2JmTk1DSjF1K0k5ZGNtWXZPZnVXYTZxUE5IMDR3aCtFdWM5?=
 =?utf-8?B?N1AyK2xZV3U1MWJuTzluY1pHTDc4SHB1dVluRzFaeEpQdTZQaG5WZ0l3THJF?=
 =?utf-8?B?cDZicWhSR2ZwcUdtNHpsTnVaRG9iREY1ODhYVDA3eTNKZDBjUkxzQk81Z0pp?=
 =?utf-8?B?dXB3eGRZbVMwNkxwSTYyK0lKb0cvbldqOTRPaE1xQmdDbnVaYU9tTEV6dk1P?=
 =?utf-8?B?R0pjZDJYK29yclRQdDZvNmhFdEkwbW14eVU2WEc5NzRsd2tzaGlYK0FRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0IzVWdMWkR5cHUwVUJtbzFNNXFDUHFpYmttOHlQK1V0Smd4cEJmOUlIQnpo?=
 =?utf-8?B?Y0JqM3hUWDRKUFR4eUpXRDk5eml3M2VRVFIzVFVENi8xQWFvQ0NBdFREeG15?=
 =?utf-8?B?MmhXeEhhUEtVTHpJSmY5K2FKNzhtSzYwcERxcjFTZWErWHVPMUVoN3RKM0NX?=
 =?utf-8?B?YmVjU0ZMWHlFVmdNT2p6U2wvQmpzQmwwaC9NVmdaZEtSMW5MbjdZV0tqM0Zl?=
 =?utf-8?B?S1c0THJJZnlkY3dkdmxmOGkwMkxZM21kNC8vcHZ6SWdxYmN3QkpHSk5GbTV1?=
 =?utf-8?B?N1FZL21GTEQyR1ovOFUyWWV6VVRjbGxFY2NGR3NLby9JcjhBRXFOWjE1Y2xO?=
 =?utf-8?B?Yk5mUHVjYjhVUHN3ZTY4d2ZTMlZYd2U5SVZPeXFlT1BSZllaZ2FIOUpDcHdx?=
 =?utf-8?B?eWNoMUFNVFZPQWx1bHpKTk9YUk13S2xRVXhZdy9QSStjU3RrQ0lJN1duV05x?=
 =?utf-8?B?Q0VlZUdaaHl0SmZWOXFsblI0MXh6d3hYK09ML2hhL2hWRVJibnJHMlNDN3o0?=
 =?utf-8?B?OWxRRHhLNGxXMjJvSDlkZ0NFMldhMCsxVUllN09RNHBPQ2VteWtFZ3FxS1Zt?=
 =?utf-8?B?S1N0Q3drbHVhajVSY3p2M3JIbVJMRmtxeWgrSW9Ibmg0V0o4SGFiaFUwTURj?=
 =?utf-8?B?d0RQWUcxMWJheHdFYnJ3K0drS0RKQVRvYk9rTUVIUTNXZzI5YlVFaWxXSTNX?=
 =?utf-8?B?WHZ3T3VnSEJLVEsxdVBQeGdleDlZZzRsQkR6SElGRFpibENKZlRXUjJxK2ZY?=
 =?utf-8?B?M1I5L2F1TURnNDR5TDU2VTVTRi8xeHQyWWc2Y1pNdlJMMzNLVXR5RitweFQ2?=
 =?utf-8?B?aDIyRFhTbUc5dENpM2FVamQ0SUZuU0hFb3pLUXhSZVR0Z1pacXI4Nzc4ckpa?=
 =?utf-8?B?YmFQbHlVU0wxVG11Wk9FMEgwK2pTdFlmK2pacUxwWFk0TURub0hvQTI4NFNl?=
 =?utf-8?B?TVRrVjJZMld4TWlKZWZUL1dmRWpISkNBNEQ4dHdwNWdzdTlCNHhiRUlrQ0Yr?=
 =?utf-8?B?T0E4TThFZVR4NFNxblpxVmQxMkVxOXVYa0Q2YkhMa2VMMDF1N1NYT0YxU1NC?=
 =?utf-8?B?QXc2djVXWldUL2NkVkZjcnl6c3pPendDcmIycjhnYmVvdTRwN2xxRjZycGFj?=
 =?utf-8?B?V3d1aXFBNFByZmpUUlRXM3hmK2gzaUhoeW80c2ZlMHBzVWtkR1dXL0ZoOWhx?=
 =?utf-8?B?Yk5ZRjJqR050Nk5QTlo3YzlvdmR6dXhzQjVwdTFaWEowWks1bVFiV0RzR2dt?=
 =?utf-8?B?M3l5QTRlYzU0NGhYU3ltS09aOXpWNy9za0ZBK0pIZ2h3UE83VGdFcitrYnJV?=
 =?utf-8?B?bTJiaU1hN0dBbmtGYUtZMEozMUFwak1UV25oQVJNQ3F4ZW5OOU1zM3BKNHAz?=
 =?utf-8?B?Kzk2c1B3ZVVvSXh5SDRLZFY4K2dBRnk2VmIrbU9MYmxHdUlkN3hDL2U3c2NZ?=
 =?utf-8?B?UnlmTjNxM0xYNXNQcWVtY0pwRmFCQUprNXlXOW5sbTcrVmZYaVk3cDRKcmlB?=
 =?utf-8?B?Y0QzSlRMd3EwNkdNTUU1L09yUEl2YlBYWmRCODE1YmVSSkhTRDdRYlRsdmFP?=
 =?utf-8?B?c2ZaYitRYWhCeG0rT25WenlNMTdVUS82MUE5UnJYRWpCUG5FN2xkcDYwZXJF?=
 =?utf-8?B?TDZhSURuUUFrRHAzMlJIMU0rV1MyZDQrNjFJQ0FvSmRIMXR6OGpHTVU5WU1I?=
 =?utf-8?B?Um9GemY0ckpEaS9qRytLYVI3cC9JNUhFRWtscytJZ1FKdGZQWFdHWFFKSWgy?=
 =?utf-8?B?Y0dhUmlMRmRMYlV5elM2dFU0cG5STGFIV3dmOEMyQ1RzblNrd05DYzZ2Z0dX?=
 =?utf-8?B?YTBtZzBtWGx4L0pqQys4L3NGQXUyU25kTFlFZmtXdXRBbnJQRFc2YnphdjhX?=
 =?utf-8?B?ZTAzL2tFWkk4cTVYSHhkYTh6ZG9WUDA2ZHdDYXcrY2xsaUlzdEFRc0JzM3la?=
 =?utf-8?B?dGdzUWE4TTI2V3I0c3RlL28zejgyNTc0Vnc3bVlOWTJQNVVXQ0EwYXJ0SElu?=
 =?utf-8?B?UWF2NTY4SVBQVXRYSEtKeTZJRXJ3V2lDY1B2UllSVE9Uck9wb01EN1J4Mk9z?=
 =?utf-8?B?MFlteGh3bEhMVUlPS3pjQ0Y3d1ZmZ215WThNdy9vK0hVOFpIUHdoWU9NWXFR?=
 =?utf-8?B?REc2NjZsV0NVUHNXQkx1bzMyT29hYS9sZDlRV2ZRSlBFMVlyTW9LcllpRktC?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5436d15-02c9-4f7b-81b5-08dc714b8bb8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 23:47:26.2085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cK+4U5HtEukMafK7/7y9OWEAGsOxmfV1C8cwlIwehKgZCs4YpNF+wO9eBvk5ibkEKSDo8SS0oR5eLWpg9FtsohNjF0QRy7KMko/m+7wyWNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com

Hi Dmitrii,

Thank you so much for finding as well as fixing this issue.

On 4/30/2024 7:37 AM, Dmitrii Kuvaiskii wrote:
> On Mon, Apr 29, 2024 at 04:04:24PM +0300, Jarkko Sakkinen wrote:
>> On Mon Apr 29, 2024 at 1:43 PM EEST, Dmitrii Kuvaiskii wrote:
>>> Two enclave threads may try to access the same non-present enclave page
>>> simultaneously (e.g., if the SGX runtime supports lazy allocation). The
>>> threads will end up in sgx_encl_eaug_page(), racing to acquire the
>>> enclave lock. The winning thread will perform EAUG, set up the page
>>> table entry, and insert the page into encl->page_array. The losing
>>> thread will then get -EBUSY on xa_insert(&encl->page_array) and proceed
>>> to error handling path.
>>
>> And that path removes page. Not sure I got gist of this tbh.
> 
> Well, this is not about a redundant EREMOVE performed. This is about the
> enclave page becoming inaccessible due to a bug triggered with a data race.
> 
> Consider some enclave page not yet added to the enclave. The enclave
> performs a memory access to it at the same time on CPU1 and CPU2. Since the
> page does not yet have a corresponding PTE, the #PF handler on both CPUs
> calls sgx_vma_fault(). Scenario proceeds as follows:
> 
> /*
>  * Fault on CPU1
>  */
> sgx_vma_fault() {
> 
>   xa_load(&encl->page_array) == NULL ->
> 
>   sgx_encl_eaug_page() {
> 
>     ...                            /*
>                                     * Fault on CPU2
>                                     */
>                                    sgx_vma_fault() {
> 
>                                      xa_load(&encl->page_array) == NULL ->
> 
>                                      sgx_encl_eaug_page() {
> 
>                                        ...
> 

Up to here it may be helpful to have the CPU1 and CPU2 code run concurrently
to highlight the race. First one to get the mutex "wins".

>                                        mutex_lock(&encl->lock);
>                                        /*
>                                         * alloc encl_page
>                                         */

Please note that encl_page is allocated before mutex is obtained.

>                                        /*
>                                         * alloc EPC page
>                                         */
>                                        epc_page = sgx_alloc_epc_page(...);
>                                        /*
>                                         * add page_to enclave's xarray

"page_to" -> "page to" ?

>                                         */
>                                        xa_insert(&encl->page_array, ...);
>                                        /*
>                                         * add page to enclave via EAUG
>                                         * (page is in pending state)
>                                         */
>                                        /*
>                                         * add PTE entry
>                                         */
>                                        vmf_insert_pfn(...);
> 
>                                        mutex_unlock(&encl->lock);
>                                        return VM_FAULT_NOPAGE;
>                                      }
>                                    }

A brief comment under CPU2 essentially stating that this is a "good"
flow may help. Something like: "All good up to here. Enclave page successfully
added to enclave, ready for EACCEPT from user space". (please feel free to
improve)

>      mutex_lock(&encl->lock);
>      /*
>       * alloc encl_page
>       */

This should be outside mutex_lock(). It can even be shown earlier how
CPU1 and CPU2 can allocate encl_page concurrently (which is fine to do).

>      /*
>       * alloc EPC page
>       */
>      epc_page = sgx_alloc_epc_page(...);
>      /*
>       * add page_to enclave's xarray,

hmmm ... is page_to actually intended?

>       * this fails with -EBUSY

It may help to highlight that this failure is because CPU1 and CPU2 are both
attempting to access the same page thus the page was already added in CPU2 flow.

>       */
>      xa_insert(&encl->page_array, ...);
> 
>    err_out_shrink:
>      sgx_encl_free_epc_page(epc_page) {
>        /*
>         * remove page via EREMOVE
>         */

This needs emphasis that this is *BAD*. Something like:
"BUG: Enclave page added from CPU2 is yanked (via EREMOVE)
from enclave while it remains "accessible" from OS perspective 
PTE installed with entry in OS's page_array)."

(please feel free to improve)

>        /*
>         * free EPC page
>         */
>        sgx_free_epc_page(epc_page);
>      }
> 
>       mutex_unlock(&encl->lock);
>       return VM_FAULT_SIGBUS;

This needs emphasis that this is *BAD*. "BUG: SIGBUS is
returned for a valid enclave page."  (please feel free to
improve)

>     }
>   }
> 
> CPU2 added the enclave page (in pending state) to the enclave and installed
> the PTE. The kernel gives control back to the user space, without raising a
> signal. The user space on CPU2 retries the memory access and induces a page
> fault, but now with the SGX bit set in the #PF error code. The #PF handler
> calls do_user_addr_fault(), which calls access_error() and ultimately
> raises a SIGSEGV. The userspace SIGSEGV handler is supposed to perform
> EACCEPT, after which point the enclave page becomes accessible.
> 
> CPU1 however jumps to the error handling path because the page was already
> inserted into the enclave's xarray. This error handling path EREMOVEs the
> page and also raises a SIGBUS signal to user space. The PTE entry is not
> removed.
> 
> After CPU1 performs EREMOVE, this enclave page becomes perpetually
> inaccessible (until an SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl). This is because
> the page is marked accessible in the PTE entry but is not EAUGed. Because
> of this combination, the #PF handler sees the SGX bit set in the #PF error

Which #PF handler are you referring to here?

> code and does not call sgx_vma_fault() but instead raises a SIGSEGV. The
> userspace SIGSEGV handler cannot perform EACCEPT because the page was not
> EAUGed. Thus, the user space is stuck with the inaccessible page.
> 
> Also note that in the scenario, CPU1 raises a SIGBUS signal to user space
> unnecessarily. This signal is spurious because a page-access retry on CPU2
> will also raise the SIGBUS signal. That said, this side effect is less
> severe because it affects only user space. Therefore, it could be
> circumvented in user space alone, but it seems reasonable to fix it in this
> patch.

The variety of the signals and how they could/should be handled by userspace
are not completely clear to me but the bugs are clear to me and needs to be
fixed.

>>> This error handling path contains two bugs: (1) SIGBUS is sent to
>>> userspace even though the enclave page is correctly installed by another
>>> thread, and (2) sgx_encl_free_epc_page() is called that performs EREMOVE
>>> even though the enclave page was never intended to be removed. The first
>>> bug is less severe because it impacts only the user space; the second
>>> bug is more severe because it also impacts the OS state by ripping the
>>> page (added by the winning thread) from the enclave.
>>>
>>> Fix these two bugs (1) by returning VM_FAULT_NOPAGE to the generic Linux
>>> fault handler so that no signal is sent to userspace, and (2) by
>>> replacing sgx_encl_free_epc_page() with sgx_free_epc_page() so that no
>>> EREMOVE is performed.
>>
>> What is the collateral damage caused by ENCLS[EREMOVE]?
> 
> As explained above, the damage is that the SGX driver leaves the enclave
> page metadata in an inconsistent state: on the one hand, the PTE entry is
> installed which forces the generic Linux fault handler to raise SIGSEGV,
> and on the other hand, the page is not in a correct state to be EACCEPTed
> (i.e., EAUG was not performed on this page).
> 
>>> Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initialized enclave")
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Marcelina Kościelnicka <mwk@invisiblethingslab.com>
>>> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
>>> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
>>> ---
>>>  arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
>>> index 279148e72459..41f14b1a3025 100644
>>> --- a/arch/x86/kernel/cpu/sgx/encl.c
>>> +++ b/arch/x86/kernel/cpu/sgx/encl.c
>>> @@ -382,8 +382,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>>>  	 * If ret == -EBUSY then page was created in another flow while
>>>  	 * running without encl->lock
>>>  	 */
>>> -	if (ret)
>>> +	if (ret) {
>>> +		if (ret == -EBUSY)
>>> +			vmret = VM_FAULT_NOPAGE;
>>>  		goto err_out_shrink;
>>> +	}
>>>  
>>>  	pginfo.secs = (unsigned long)sgx_get_epc_virt_addr(encl->secs.epc_page);
>>>  	pginfo.addr = encl_page->desc & PAGE_MASK;
>>> @@ -419,7 +422,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>>>  err_out_shrink:
>>>  	sgx_encl_shrink(encl, va_page);
>>>  err_out_epc:
>>> -	sgx_encl_free_epc_page(epc_page);
>>> +	sgx_free_epc_page(epc_page);
>>
>> This ignores check for the page being reclaimer tracked, i.e. it does
>> changes that have been ignored in the commit message.
> 
> Indeed, sgx_encl_free_epc_page() performs the following check:
> 
>   WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> 
> However, the EPC page is allocated in sgx_encl_eaug_page() and has
> zeroed-out flags in all error-handling paths. In other words, the page is
> marked as reclaimable only in the happy path of sgx_encl_eaug_page().
> Therefore, in the particular code path that I changed this "page reclaimer
> tracked" condition is always false, and the warning is never printed.
> 
> Do you want me to explain this in the commit message?

Since original commit did prompt this question I do think it would
be helpful to add a snippet about this, yes.

The fix looks good to me. I assume that you will add the "CPU1 vs CPU2"
race description in the next version, that will help a lot to make the
bugs easier to spot. 

Thanks again for this. Great catch.

Reinette
 
