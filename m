Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEF685956
	for <linux-sgx@vger.kernel.org>; Thu, 26 Sep 2024 00:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727309249; cv=fail; b=E1bGiugfIy8VCaEE99h2LiTDqeeKpa+Usg7Nn71AJZkFxZIIN8aPR+tve8x/mJ6dfNZM26NF5v4kR4m5FOsD8XQHqtMwDdTGDNGV/BpDUCk8zqKDVlCII2We9pJGi8c5IWIm8FuoEBRavPuVebrXCEUF7waC994W3RiyYm0rYHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727309249; c=relaxed/simple;
	bh=aEne93GsI0jmbKIp8H/SsRBUx8zUM8fpGpTlQ6HjgUE=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qgllgj4aVYORmOhW06v8BhVbywGisIn5yIuuzMwxXx2EzNnZ6eMMbqiA5c92IddAI/YfVRSS2eL6F4Eb5vZFDTJLrnF9RKLbBJrhqsTSmdf316w/AFIwuod7sDEiFPNP/iBLmFRoogirNRRtYlKnTnvb+pvOwsro8MgbJU5x8o0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KkEyCyMl; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KkEyCyMl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727309247; x=1758845247;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=aEne93GsI0jmbKIp8H/SsRBUx8zUM8fpGpTlQ6HjgUE=;
  b=KkEyCyMlC+0ywuSTHGAXsjjy4JEwkumMEN+svq7uuA/yWwCNDyu57blc
   tz2+MO/sOlV2ZjE2X/evQp//B0SDuuneBuN0drcPgB05d/MDYWN7UGbkq
   P/bgMCVhXF9ioW/iv0XMRU+buBo6jixsETIhBS9vdhEGsDebsQob60IR1
   OtQS6tjtx8VyuR/JNYDLozCtGSr9qi4lRdlvVotzwdNmzGh9C90NonwIN
   ACLkQXqRrH83yaO9i1vWIf32rMCsGrflFcj0tAZUeJ1DB589UYA5xR+fo
   iqogLE5jct4po6CmQjT3SPsUu03H+gTNIYz6xIEkghb2EA6JOAMMudxEM
   A==;
X-CSE-ConnectionGUID: jHS2FwDWSj2AVTrJIiX0JQ==
X-CSE-MsgGUID: gy8f1Kw+SyuR5iDM7jN6XQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11206"; a="26197994"
X-IronPort-AV: E=Sophos;i="6.10,258,1719903600"; 
   d="scan'208";a="26197994"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2024 17:07:12 -0700
X-CSE-ConnectionGUID: WTQbN59hSIGXoxIKYI0hCw==
X-CSE-MsgGUID: /BhyRmJURJql1oaDyr+xJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,258,1719903600"; 
   d="scan'208";a="95278373"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2024 17:07:12 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 17:07:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 17:07:11 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 17:07:10 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 25 Sep 2024 17:07:10 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 25 Sep 2024 17:07:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ks+rh1l5iXBPR3mP+7MXD0SYon/4pA+Xj1RDncgN0yHbifVQoB1WOBwkkQjRcF1kmF5goQdEor0zOJreQvosrEpMjTSdyOj9pM/7PGh2y6L8JyhFq8pzJVBFSSSD/CBsR3pSgIYaNe00wj2Qxh/jUh4f40vowcxip3KdkXfuJBzmGy2AmePfgMpiqLdAsB/TOFm+f8wxK3cuFbuYZrsdrXbkCzC6DXAYS97I2pwTHOkwrrNLYSaJ7CR+CIjfdfNHnTv6r4OFFtNMBHDquX+QjhvvLYhN5680b5DzwFjYUpwfn55eknsr8SwF/Ui7FlvWtKIOog8dBbAT3wNyLHmmtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWie9XE/uSf1tUQpTkz5BfUcrE17MMoMiT50mPiJOO8=;
 b=TLtTZeeikuIj2NILNIgeOLh13y/l84dld9I5pzM4DVy+lc8kH5QajNw5nmhMT71b+v5rp2ajXTzBE34aNKSN4Ud2ZYLlETFlmdBhAkZjmx06iYmlNNk+jKHhHA27NCLthaKvrhwEpR2qmBT6sgjz+vny5nhOx9q3Ie52wzFLOGYqWkJ8qkNGb4aY6XCWgKlUCNaijqgSOQz09Jd90DCyYGmetQMVIu4C58fivfqFq/h67TKKnx5bIG5c8YHpURg34QCXM8c25edUwJ/Wo47ndUXdAHXJY3k2HqyIuvbwhkYgyVlaaysA8D2k2TEoZRgCwiwtuOtqKCG/LX3rJePYIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5133.namprd11.prod.outlook.com (2603:10b6:a03:2ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Thu, 26 Sep
 2024 00:07:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 00:07:07 +0000
Message-ID: <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
Date: Thu, 26 Sep 2024 12:07:02 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: VMA merging updateds?
To: Jarkko Sakkinen <jarkko@kernel.org>, Jarkko Sakkinen
	<jarkko.sakkinen@iki.fi>, <linux-sgx@vger.kernel.org>, <linux-mm@kvack.org>
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi> <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0129.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::14) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c89c4ca-1978-4452-4feb-08dcddbf28b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WnZUSzk0UDE3UXQ1Y3kyZTVWTXNpTTRRZzBpWmUxZW5JbzhsMTBkampEYlBo?=
 =?utf-8?B?STVsMUdIS1JCNmFycGFKY1pPZCtjZkxjRFA1d05LZkZVZVZycHZSYm1rRnJM?=
 =?utf-8?B?VUVWQkFGRE1hNW5PcDNzSlUxVElBQzltN0FmVVhzSTdBN0F2MFJjYjdUZW92?=
 =?utf-8?B?eHNwejU3T3BFWVJYZ2hXWVc5Q25IS2tvWjZzUGtCaGtUWmNaWjJ2eUtTMXJu?=
 =?utf-8?B?cW5GcFl6ZmxkUjY4bzkwWVdSVXcyVHFZTlVFakphMkdVVEdLSkE3bTFXNFgr?=
 =?utf-8?B?RmxTc3c0eUUxdDROS3BvWVlVVmtzNFhSTjhMSXRQUWpoV2l5emVvZnJmOUZy?=
 =?utf-8?B?K2tjcGV1enh5QWNCTmlUVi8rcUpSZUJtUHpZR3c1OGRxR2czQjFaMWhwY2dp?=
 =?utf-8?B?cWtucWJ6Qk9KQVgzT1FVUUdTb04yTXVzTFp4dWFpS09SWkxiOXNLcmNhaktH?=
 =?utf-8?B?WHBOaHNZVXFqYWNBamRJWm1MRm9XNnB3ZTRiNStlNU5FMnU2ampZM3I2ZWtS?=
 =?utf-8?B?cnp0Z2YvZERGbWYxdlFXM3owS0I5T0hZMjZGNWxPWFB6ZEVnNmxON0dCMHpU?=
 =?utf-8?B?L1BrZjY3UWdDaXArOTMwNWJ6OHpvOThOeVh1Z0VES2NwZmFEanNMVTBmdWRD?=
 =?utf-8?B?cm1IU0JvaXVyckRQSjhUSUtEQ1VRMGJiQXJCNUZ3Tko3MFdySWxicWJFRkhH?=
 =?utf-8?B?aVhYV0NmcUtJWmFjY0lBVVkvbWU5TUNFa3BGZ2pnZXhRUFpmNVcwblpLaHBj?=
 =?utf-8?B?aDJSQ25GQjBwNXBNdHJoOHU1VW83bFh2dUhxRElQRzZycUw5aW95SVpXRGFN?=
 =?utf-8?B?Yzg3Tk8vRjlXQktDN1VDNCtrYysxdkRTRHhDRVRvaGRhU09OajNiZ1I1UUl1?=
 =?utf-8?B?WFNYbHNUUGMrRTd3TnkzYzBaeE5zbzZLOTV1SEphRnYwS25yaXNkWWdFZVQy?=
 =?utf-8?B?SXZCUEE2bnJVZ0taQW1Cb2JmS3gxSHZmTTFSL3k0c1d2aEdIMmdYbEhFQldN?=
 =?utf-8?B?c1BHR0lpWFlaTXRDTXJuRHV4WXU1Tlo3NVRvTEpMT083bFU3amd4aW43VWdh?=
 =?utf-8?B?SWVJNUdGNU9HTEdUSkZEb1c2NitCNXBMMDYrc3hyQ2NDWDM4LzVWVXk0TlpI?=
 =?utf-8?B?K1lGK3cwVmVXa01uT3VNRVNCMWRJWUhlVkxDY1dpTlo1RFlTTzIvTFFQbHFO?=
 =?utf-8?B?TkNsNjBaMDhOcDJvSG5wdzV1ZnRDcTlFV2l3VmY4alEzaHRiSTQxb2l1NDF5?=
 =?utf-8?B?YmhYZnlpQzJCL3k5Ui9YaEk3NzI4RUxSL2hsa0VsN24yM3pCeTUvd3B3ekV5?=
 =?utf-8?B?azcrYTNsOHNBVTVsbXhsQ1VQcVN2RndoaDltK0EwalFXeWVVWWpnMzRZV00z?=
 =?utf-8?B?Njc4MEd5dlJMM3BWMFI1NEI3eHI2bjFFYS9KSHNVY3g0YjdlbHdFZFV1cVdU?=
 =?utf-8?B?cm55SXJMV0JjNFBUbUhxRUJnM3VzSGxFNDQ3L1k1RkZKZGdSZUtwMG1QSUJH?=
 =?utf-8?B?NGxBdVFKU3MrR0Y1RkhxNHpQL2ZlNkZoMmJ3TFNmVG9rc28zQUZTNnNObmVX?=
 =?utf-8?B?TU5ReWFtaDI4cWNVVXlwUXBqWmFXWENJaXpweE5aZ3NVS2FZVFRsNHhGRldz?=
 =?utf-8?B?Y3FDRkpsUlRMSXRFclU4OEtEV2h6SVN2TlY1dTRWa0lsNXYwdi9MZWk4VDdj?=
 =?utf-8?B?S2dBaWljK1c5OUM1dk9ZN2F6cHVFeU0rcVROWDdsYmR3R1dpTDRQb2V6Vjhh?=
 =?utf-8?Q?G4UkTyv0OWZms+yGcM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2hRT093YnpkajdnVmU5R2l2REhrRFU4ZFR6OWtDbkoyWXdCOEpVd21YSlls?=
 =?utf-8?B?ZmJaOHNTcHFJQ0NETXlFMzZEVU8xdHVPYThhZHAxeDNzN2Y2YzVqc0VGKzhD?=
 =?utf-8?B?d3duN3FHZU0veEw1Q2JHejBKVmdVbmIrVi9VczdCQ3dJQjFDZnNsZHdLMWY5?=
 =?utf-8?B?WW1KQTFRUGJPWWxXUzUvVUZzQUNCV3cxMGIwelNIRTUzL1RjOUJ4dTFUdTBM?=
 =?utf-8?B?dUF5bU90THVOdnh5aU5QT1pQR0hXK3BxU09CTFZkd0JaZVY5dFZPVnlnc1Fj?=
 =?utf-8?B?dWxveFR3aWJCZG5ub0k1OXdUenA3NDVvVnV6amlzQ0E3TVNNSmhka0svemVU?=
 =?utf-8?B?WG91QVBuWU9adEJoTjR1ZzI5NitrOXNhTzJzOVpRV1lmUElOSWN4QVVTdSta?=
 =?utf-8?B?NllqVXpWMEM0dkkxZ3NLUHM5V296dXdPSlN4eG13RVRhdDR5MlQ1ZnhMc1VQ?=
 =?utf-8?B?ME95d05vbUc5Ylg4bk9NbzdHQTdCQWl5NVhZUS80L056bGdmYld4TlFQNXdQ?=
 =?utf-8?B?RzdwMFZjRlVpWXI3NFpCU0ZKL25Ga0h2SnJuWFZQaURzajh2ZHpmL0FEZ0tE?=
 =?utf-8?B?aVhmVUwwRHlwdmJjT1NuUjhNOWEyZnhOMG4wbDVqNEd2M1NGcDNmUXFxOFlD?=
 =?utf-8?B?bktpaGdUOGJSTkNQTXN2NzR2cXkrQ1Z0SDJrMlA3SFJYRFlKSmgvbTFJNzMr?=
 =?utf-8?B?a2NjVXVsY2dBd045aUYvbERRSXdhb1BPZXJaU0FoKzBlOVNPT1ZZenZTTFY5?=
 =?utf-8?B?SXowakVQeC9vNXlsMlpVUWdSL2MyTG96VkdEN3pkUTJ3aFcxS3F2cjhqZjU0?=
 =?utf-8?B?SlRIVms4WW90dVRWM3NtczNJMmxXUjYzbGtTdU5xaXdKbGJEK0FhMXNNU0NU?=
 =?utf-8?B?dUhzRDlNSkVtSDhiNnBCZUNHbzQ0elk4encwaGJVb1VIc0hUVXFRdUF2dHFY?=
 =?utf-8?B?dmRRZjQ0UDllZlZZeTJVc2VQT0ZJRzdydG1TNFVhaVc4bkxDUWQ1bmYvSjQ0?=
 =?utf-8?B?TnN0aFo2NkVuYUorWFl4aGJTc1pzQVN5R3pUMXUxcGN6bUxxTnZFd3dBMVVj?=
 =?utf-8?B?YzAzNTdBVDE4ekROUWVRT04vT0hmL095OFFjMlJMM3ZMMGIyNC9yZ25FcmQ3?=
 =?utf-8?B?VzBIOEdNUmdjbmxoTjBYdlRId3VQaWdxcjVmaFE1L2tVTHN1Q3QrYXd5a2VQ?=
 =?utf-8?B?RVRVVGlSM1VHWVdYRVRYVVRtSmFnaGhCSGwyK1lCL3lmZGhKVWhWMGpSM3Uy?=
 =?utf-8?B?ajFNdVJYd1hwaUcrbmJSUytrSEZ3T25taDVuRGRSbDVXdEdKOVg4bU1zcy9K?=
 =?utf-8?B?OXBvVnp3eXNVYW9BVHFGNlBVQ2JrV0tlazZsR1Zwd01VR2wrVERMNk9kZkpJ?=
 =?utf-8?B?WGt5eGFaOEtSclRlVXMzQ1k5dXozc1kydVR6TlF2bDRjWW1lWGFjZE5zaDRI?=
 =?utf-8?B?NXhwQVBnM0FWM2RqalQyUTBMTHU0UUkveGJQZFhKVWNQOGpHU3RFOGFWK0dE?=
 =?utf-8?B?Z3cxdmUxcTBnYllTWGtKY2tzS3NCZzFYaVMzb0d5RGk2MGVsSlVKM2ZNajgz?=
 =?utf-8?B?dmsxV2doNHN1M21NUXE3RDdmay9leUZvam1XWCtWVFh4TkpYalFnTkMrTDA1?=
 =?utf-8?B?ajhGMHdJcDdzN0ZsanJpWWo0TzFFWnFqTHVXcSsvNmwrSDd6THZGdUZsSHhm?=
 =?utf-8?B?ZkgxSVpDNTY3YTdYaVdpblVIVEFpdWZ0Z3o2TGtmVXdHRkVJUUdObThKTFRT?=
 =?utf-8?B?SFpVZzNGL3h6SXFIVWdyUEZ1SElVSzc1UnIwMG1HOHNRVzRLNjYzdUs1MHBC?=
 =?utf-8?B?d2ZneGhoMkNlY0liM2kyVEtvdzF2K2RTbW56dVQvTVpNQjIrUnJpVGo4SEha?=
 =?utf-8?B?eDVKVWErTXpOVVk0SDJCTnlkNG9vSllaV1Q4eEppdFYvdmlUcnJWMjBaUkdq?=
 =?utf-8?B?NmpSSUxDVzFQYzNVaHJ0SlNlNHpiVXNCUEtvWHJPVGY1ZnR6dnh0YXc5cTJ5?=
 =?utf-8?B?TWtqd1UzMnJ5K2tkbVkvbUsrQ3NqMG54VVZLN0M2Rk50UXZFYmFMZVdjVE5R?=
 =?utf-8?B?SFVncUZjdG9Yd2J4R3FMd0xhNDQvc1E3d2V6SlRqZGhLS3pZdG4zaE9hZ1JW?=
 =?utf-8?Q?biLEC58WX70aq3BYS0r1mesSi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c89c4ca-1978-4452-4feb-08dcddbf28b0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 00:07:07.2343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIabbeyI0x1EirPZ91/QELluAtCOI6ur/2BbtTlFqgF9dnUDvN3ZktTdMcLBgoeAQJXQtHG/QBNmhh1U81ZmXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5133
X-OriginatorOrg: intel.com



On 23/09/2024 7:48 pm, Jarkko Sakkinen wrote:
> On Sun Sep 22, 2024 at 7:57 PM EEST, Jarkko Sakkinen wrote:
>>> On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
>>>> Hi
>>>>
>>>> I started to look into this old issue with mm subsystem and SGX, i.e.
>>>> can we make SGX VMA's to merge together?
>>>>
>>>> This demonstrates the problem pretty well:
>>>>
>>>> https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org/
>>>>
>>>> It was result of brk() syscall being applied a few times.
>>
>> Briging some context here. This can be fixed in the run-time by book
>> keeping the ranges and doing unmapping/mapping. I guess this goes
>> beyond what mm should support?
>>
>> I thought to plain check this as it has been two years since my last
>> query on topic (if we could improve either the driver or mm somehow).
> 
> In the past I've substituted kernel's mm merge code with user space
> replacement:
> 
> https://github.com/enarx/mmledger/blob/main/src/lib.rs
> 
> It's essentially a reimplementation of al stuff that goes into
> mm/mmap.c's vma_merge(). I cannot recall anymore whether merges
> which map over existing ranges were working correctly, i.e. was
> the issue only concerning adjacent VMA's.
> 
> What I'm looking here is that can we make some cosntraints that
> if satisfied by the pfnmap code, it could leverage the code from
> vma_merge(). Perhaps by making explicit call to vma_merge()?
> I get that implicit use moves too much responsibility to the mm
> subsystem.
> 

Hi Jarkko,

Just want to understand more on the background:

Are you seeing any real problem due to needing a lot of mmap()s to the 
same enclave, or it is just a problem that doesn't look nice and you 
want to resolve?

I mean, this problem doesn't seem to be SGX-specific but a common one 
for VMAs with VM_PFNMAP (any bit in VM_SPECIAL), e.g., from random 
device drivers with mmap() support.  We will need a good justification 
if we want to make any core-mm change, if any, for this.
