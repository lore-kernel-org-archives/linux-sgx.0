Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2981C01;
	Thu, 25 Jul 2024 01:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721870534; cv=fail; b=uvNcnbRdZNHqxsh5VSZeQhacCegPev6QMNmeSSekilGrX4BB+XO8c89wnFhZSSx0p+Kizyqa7aZdzSQ4G5DMbiTwW64kYVbce7jGb0EYqT+D9mxf720TTelhYlRUrgvF8GGqbxNg4k8msn1vFEEJF1txNQb3YNtkSmrvhBxlWFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721870534; c=relaxed/simple;
	bh=5oL3w0SRSCEgLKhjieVM+RCq3Bzwpbp3pbQlM88Tzw4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X6WyeX2xQ01RCXUqq8Qw2V7igwwIXXP9/sDwzjv55g5LMQIvGb7sZ6/hqnZt7cBTpXy0ST84FOJI6EuBwqUc0l2MDSaU6bUEWuS8greZPYqy4imZHeDr8Q6f2YfHcTkk2N6xrWK/XU9Y2UQPtaWz3Vv79n7pesxXbXLIn3O1Ouk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CafVG5aM; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CafVG5aM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721870532; x=1753406532;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5oL3w0SRSCEgLKhjieVM+RCq3Bzwpbp3pbQlM88Tzw4=;
  b=CafVG5aMAYsyrxm/gpblSjJuCbWEzerbhF0ARtpGcXlxQVULl+llRk/C
   eobR2bG+sj0d6VH1nOqkfEhwYjbN7EOd8Bd0AoQHJhfFtjT0LEcyT+iAD
   gKskluvrftTjUxHHMyfYUbFvGsioEjKufUZ6cTUqEntYJjVNkmNLnOCgc
   v5GmtSddqTSmG9P43s72Dojsjatyb6Q7blsUZJ7XdmtPhnR4n6BTEHD//
   kuBdWUjfk1Ee41nCXdFMDC1CpQBHpRkcNtSSBHSYbnrPEfZEJ10qxeUmE
   jTKaFXpMqW1zM2J7EPo1x1qxmBwf/YNOHNb7KDRlPXh3aBqddOjchu3g3
   A==;
X-CSE-ConnectionGUID: aNYqSPPpQ6KkVQfT9Iut1A==
X-CSE-MsgGUID: aVCvWAa3TPGOO2oq+gH58w==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="30249709"
X-IronPort-AV: E=Sophos;i="6.09,234,1716274800"; 
   d="scan'208";a="30249709"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 18:22:11 -0700
X-CSE-ConnectionGUID: 2wUN9/D7QiywEGsS9EcyXg==
X-CSE-MsgGUID: Q9/kIEslQgCWexiXazAqjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,234,1716274800"; 
   d="scan'208";a="75986417"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jul 2024 18:22:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 24 Jul 2024 18:22:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 24 Jul 2024 18:22:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 24 Jul 2024 18:22:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nySW0zV3amoosXxxpfOOoyla91yd0hR97MSCUj6uarBShHkuM2g/89wT9c/GHasobuQpgDl8dXOY8Z/olLTKinIcAGaYhoeZGyqNIxDZRdcvrah08jlh64xuw5mPoIYoEFus+wS3iMClQKUhi2cXXc0rOvasG5vBhxqvm4VuHxUYn1LyPKEh+bwEeSaULdOTAUKl/HOTnhusI/HVdOauIXftTHPN36XI+yEXgvoVUNQZwQvl8xAfQgzrelMux3OyftAl/ULu52H/SMC9Rrg5AfXZTxDy2CNbscr0eZrop4kC91HhuJlCeVINH0utG+kK2Hk2y/FtJF04yU8/Ks559g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pUtOOn3bsFWZQP4WNp/t15WcfYQjU4I5kkoaTv3kajs=;
 b=llOMbbUwLhN5ug1w+Gs7ImQ5xH71XFpiFuovQKpd4YYMVQYMDvmk2XuLWvnFWLizPjXM6WzzSgzvsTThw5WWVIK6R5XktgpkfOZ4WT6aWmu5vHBLlzfAbDMt6rFmw1IburXQAWn24XwtANqMIgDehI816RtZmvghPyvLWvu513qjPnkE/L+XJai/0uQ9bXENxAhoFmOocYRohIJwkuw+sSdypgiJAmDbtOfW6aIls6u24b5EGbbfh9n4GT88Y1YA8XDq3vaVdnRz9X65QFVZqWL2gf+dihfTcv/kHSUnD+7VBREbR54dK1YcLV0BDXg17by7dqN6B9BC4vOIiHjBCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6499.namprd11.prod.outlook.com (2603:10b6:510:1f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.25; Thu, 25 Jul
 2024 01:22:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7762.027; Thu, 25 Jul 2024
 01:22:04 +0000
Message-ID: <6645526a-7c56-4f98-be8c-8c8090d8f043@intel.com>
Date: Thu, 25 Jul 2024 13:21:56 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
To: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>,
	<dave.hansen@linux.intel.com>, <jarkko@kernel.org>,
	<haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
	<linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
 <20240705074524.443713-4-dmitrii.kuvaiskii@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240705074524.443713-4-dmitrii.kuvaiskii@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a03:505::14) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB6499:EE_
X-MS-Office365-Filtering-Correlation-Id: d8592801-d553-438f-f969-08dcac483126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cG5kUFB6a0ZiNXJsLzB3SkY2WWYxYzVYNnlMUVBPcUlieENvZ1phRnkrQUpK?=
 =?utf-8?B?MXpjTytHTEJ4c3BrQkgwMW5tWCtlSUgwMVg3WW81OGxJQ0RmV3ZBazVqeTdZ?=
 =?utf-8?B?Rk5MTm1VMlBVaGlGZlN6U3hGU2tHUTMyRjN1aDZxZnRUR2NDbHBZWXFEV3NC?=
 =?utf-8?B?Uys0M3NGVmxzMVZxOWQxRnFpM3JVWEJGTEwwTGMwVlBRdElmNzZJdnYzdUZO?=
 =?utf-8?B?UXhESFZwWVNUWXhodmhhdTFOOVIzdlR6MzVDUmRmYUpxUk5JSURzVTZEMFZs?=
 =?utf-8?B?M3FLK1Rjd0VheGh4OFl6Ky9UL0docnl3NnFSQ0ozMnlWSm40dVo3ZmloRUU3?=
 =?utf-8?B?YnJJMFZ5aEN6VXRIVUhHUDJXTHBnMnNONUpUcDhUMlUrS2g3c1Znc0t0N0Fw?=
 =?utf-8?B?MHRyTCtSTnZZQWlPWUdOQTJVU3lUUVBrdmZZVWVjVVBLT3c5Yk92bXpDMWdx?=
 =?utf-8?B?MGh1ci8zMklVVjNPbmtRWWRzdGppNmVqOVFFU0hRVVNicjFTeG9VNTRjWHF5?=
 =?utf-8?B?ek5PblAvajdHQnZ5dXVTWHFsRDBYdkh6dmpSaStDTk5uZ2N3SkxkOTFCTzdQ?=
 =?utf-8?B?NVA2Z1dYUWZ2akZTeWR5MFhoR2Y3ZEQwQ0dzWVFab1Y2U0xhTTBiNklmSEFo?=
 =?utf-8?B?WjdYTkFoMTNDYVFSQkJmaU5zQlkvZStMb2w3YUYxQ1JJRkVWL1V1UjJJTWlW?=
 =?utf-8?B?MkRsbTBjZklSYTlJaUI4bTBxdFF4STc4VGJTUUJKSVh6N0lQb3dzWXo5akx3?=
 =?utf-8?B?cWw3OXZRbW9ZUXNMd2g1VFFNaG9zNkRkMkpjMVZLT0JlYnF4ZEswajk4aStC?=
 =?utf-8?B?c084MGtZK1E1eWQ4ZVBzQlo2MERiWGxXV1RBcm5INlBsWkRRVml0RWtHdFJi?=
 =?utf-8?B?ZDhkR3IvckJEYjBnb3V5WTcwT2VoOE1JMDEzRFhneXNxdndocGNtOStIa1Zp?=
 =?utf-8?B?ckZ1enM2c3BvVkFkYVJWNTVZQ2w4V20yUHdibXJSR2ZNVG1JZlFPOGdRWHEw?=
 =?utf-8?B?TXlrbTAzS0ZtVEtma3FjTVpBOThKaUN3TXZ0UzZNTWNqaXJQL0NKYUZIL0FC?=
 =?utf-8?B?VWxGbFJSb1hkaTBUVVFFMmRacXdwc0dxdlo1cGs0dExERC84aUlwRFBJT1ph?=
 =?utf-8?B?QnN3d0hmbkN3SWhKb1pxWCtMM056dzNBa25sNjZuaGNhck8xMUdPSlVMdjZi?=
 =?utf-8?B?Y1NuWWZLK3Z2OWJpRUJ2RHlMZ1o3Z1p4QmJhNVZ1QjJ4TFN6bEJpTHpGYWRK?=
 =?utf-8?B?MHZMdDNQN2d1cnJiaEdqZmZNVW5CMVQ1MmJUQkthc2RHM2JXSEpwWnRSRU8r?=
 =?utf-8?B?MGIyREs5K1dPR1AyamlETVlKTEo3WHNRdTlGa3l1eVphMzA4L0Zna0V4L2Uy?=
 =?utf-8?B?Sk1ITUZJZUJQZlM3TjBRZTFqWk1peEpPMGhkR2t0Vzk0MWlKekwzcS9yN2xt?=
 =?utf-8?B?czJLT2lnelcwZWIySUZQeHhRT1lxd2hjVjUvenNRNnBLQXpiZFU4SG81UUVK?=
 =?utf-8?B?dDZuRVZ4cGdhQVVOSEZJSEJWVjBTSnFyS2VCQjNTcDk5ZkJSYnJ0bXJMa3By?=
 =?utf-8?B?cXBBRWJvK2R5blNMN1BDQXdNY2pOQm5hRUFCUlVYaGxCWEJQeUNFMi9Pb3g0?=
 =?utf-8?B?S2d3Tm5mVGtCaWw5eitKaTBLVlNFaVlQK01kMzNCRnBCb0JwVjNBWjV6cjhW?=
 =?utf-8?B?SDBSd1MzaUJiYkZBRTNvbEFMTUpvQ1UrblNHTnE5VEo3Z2hIcnoyVmZKbjhX?=
 =?utf-8?B?UEJ5QUQ3YW1LVU5hanZqTVlkZUQ3VUpwSzFLcXAyNHNnVDQ2d095ZUZvV3FL?=
 =?utf-8?B?aW84OVBUT1I1ZmM4UDBnQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3NIU0NFNU9pN0VKaWRiS2s1bmRmWG1KL1VIUkw0NXFZYjhVdU5sclBMdTJQ?=
 =?utf-8?B?b0dsdEdLa1JzRTVkYTRSaUEzcTBrN0E1YXRNY2ZkTU8xaWluLzZ6L1RHZEtl?=
 =?utf-8?B?VWRxd25VSG9aL3lTN0l5UkdKcFVma29IQWlzSmE1b1hQTElnS1RBU2FXUWs4?=
 =?utf-8?B?WUZ6K3pydVR2ckc5SURoQVJCdXcvbHVPUmo5cjNsMWwvMGlMN2NOeXdVNFFQ?=
 =?utf-8?B?bnVrU01yVWhFWDhLWEc5dEVia3lmanFwWXhwa2lyWE1oNnFXK1JiNlhSS1ha?=
 =?utf-8?B?cXJpTjlUcCtjQjBNS3VGRjRscTc3bHlVNEMwUXZjdFlEUTZTZS9UYldNdU9D?=
 =?utf-8?B?MHlMT0hqSENQQ3I4WjNmRDlOYUhiMkhtaHZXaUVHbjBEL0IrZ2dMMG85cDdH?=
 =?utf-8?B?cDl4WGM0Ry9PUjVmckFuV0FrK3ZpNWNieVdFanRmK2JCYktiZVhaVk1OR3RO?=
 =?utf-8?B?Zk81d2sxNkg3S25RMXR6ekhKekdwYmJPeHpoNGJKOEhMd2h1QWhzaitzSHV0?=
 =?utf-8?B?ZG9CY0FOWkd3Zk5TdHR4M0g5WEZYR0Q5bDJiODE2YVNPZHFYV2gxRVU5VnBt?=
 =?utf-8?B?dFFVZXI4aytGNVBFanJZendEMkJTKzBxZWZURFRHS2x6QU1vNlZqVTI5Yldy?=
 =?utf-8?B?THhIa1UrbWM4YlVOTndsU1NQT3hSMnFDRG01L3BiUWdtNDZlYmk3WGxUOUZC?=
 =?utf-8?B?dGtiY1AwWW56WlF0aFFrZ0M2L0dTZlBWZ1hxcHVJVnVVMTRLVTNsV1NlSlRv?=
 =?utf-8?B?WjBOdG9vU01XMDRRODVmVGVSRmU1bHFtVGhTbEtrZFB2SVNKOWZtazFrSjAw?=
 =?utf-8?B?VjU1MlRpdktxTWhvMzZOWVl4MzR2VGFXSWZCTERFOFRwdUE2Mzh1N2Fxd0dL?=
 =?utf-8?B?UENZSW9obyszNTZJaDd0UHR1bXZYeXR0NzI4b2NCL1RVZmJLZDh3SEh2bnZY?=
 =?utf-8?B?MldKcFVtYm0xMk1JRlJlYjhlaEVLUXNCZEZHdkxWaXdkbW1aWXNVWEZtRnJ3?=
 =?utf-8?B?Q3hrVHVFNlliNEhOaXVodTBBbWdMSFphZ2Q0T05iTDVsMWJVZnE5YW1kM0RH?=
 =?utf-8?B?Qkw4cmxjTU9oamxGWnpvSWxyZURyYXhDMkRsREFRRFlxdXlPOXJpNlBlZ1JT?=
 =?utf-8?B?ZUhaV0JEbEdCUDl4Y1hKQnN6dEZmSlVkdWVIeityRXZzOFNtQW82cVc5S0d1?=
 =?utf-8?B?c3NaaUhIVTIzZUdpOHB6OWpUdEppNEd2Qk85YzZ4bS9hbWVpYkZ5ZG1NNjZF?=
 =?utf-8?B?ZnA4amd2MFQrT0NITVd6eXhpY2xwU25TbE04STJCbmpRZFhwSGU5cVdpcDhn?=
 =?utf-8?B?d0taeFl2dGxYblJOWCtmOXZqYmZKM05jRVJGcEEvT0Z4NjNjYUM4L1djR0lp?=
 =?utf-8?B?YzdVYVl6R2tuQmlHS3JnY0d3eGxiTEIvaGZXS1FRNjFtYmJLWWJnVFFDWVRr?=
 =?utf-8?B?VG43UHQ5U1A0OThYSWxaMFExT0V5aUhkdEc0VWJOYW5YU1FjbmlOSFZ0bFZX?=
 =?utf-8?B?ZjlETEdYOSthdmcyRTV0Nm1QSlc1UithNU5GTnIzTGlnaGx4M1FocG5CSjVl?=
 =?utf-8?B?QUtZYytLT003Z1M4dFdlcFFoRHlCZjdzOXcyYXA0bWpCVHljYkQ0NGUrSk9y?=
 =?utf-8?B?b2UzRjdGeGZBNDZ2RGw5anA4c3pRckh1dzVDS1NaRHFLcW8zdWZKejhac2M0?=
 =?utf-8?B?UGRMOEo4ZVUyeWxnU0I5QTRrVEdwdjhBcXdySXFNN3N5M0VocUpWd2hzMzFx?=
 =?utf-8?B?cXJZWE10a1RFVHZ3dzVlOTFYTUVJSGgrUWhMMExGSzZFU1g5eXVGaEtaQWRj?=
 =?utf-8?B?UWtsQ2J1Yjc3Sk52UkkwWVFpanRvUkJHVGIxZmorditUQmRBWlR3TXhRVlFk?=
 =?utf-8?B?SWR6MFgvLzFUWCt3NkphQkYzdUJFdXNkNmYvT0JxZnhhSnNlVGhXUGw2b016?=
 =?utf-8?B?eVpjVmFRdE1rUmFQdHc1cUJMM0pzVGxnU3I4eDR0L0gralVrZ0t4bHNCRlhG?=
 =?utf-8?B?TTJBVkJNMHl0MDNOM0p0b1FHRjIrVkdZTHhDdmpvZFFBa0RnUzhNdkhGTHZ5?=
 =?utf-8?B?TG1EUFhVYlJVakpFZFBudmJZcE8wTjBiV0I0OEVjRkhkTk8zZmgzeWFXck5t?=
 =?utf-8?Q?v2ywveO23I5xHI45pqeHOO7nk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8592801-d553-438f-f969-08dcac483126
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2024 01:22:04.3551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzyZ4HybItiSbdkDwlU6bmXSz4VMjzi8oRQTVwjC3W9fBgaECsYK9INPuaY0DtU0OpavQjVQpiJg2BjoyKkfbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6499
X-OriginatorOrg: intel.com



On 5/07/2024 7:45 pm, Dmitrii Kuvaiskii wrote:
> Two enclave threads may try to add and remove the same enclave page
> simultaneously (e.g., if the SGX runtime supports both lazy allocation
> and MADV_DONTNEED semantics). Consider some enclave page added to the
> enclave. User space decides to temporarily remove this page (e.g.,
> emulating the MADV_DONTNEED semantics) on CPU1. At the same time, user
> space performs a memory access on the same page on CPU2, which results
> in a #PF and ultimately in sgx_vma_fault(). Scenario proceeds as
> follows:
> 
> /*
>   * CPU1: User space performs
>   * ioctl(SGX_IOC_ENCLAVE_REMOVE_PAGES)
>   * on enclave page X
>   */
> sgx_encl_remove_pages() {
> 
>    mutex_lock(&encl->lock);
> 
>    entry = sgx_encl_load_page(encl);
>    /*
>     * verify that page is
>     * trimmed and accepted
>     */
> 
>    mutex_unlock(&encl->lock);
> 
>    /*
>     * remove PTE entry; cannot
>     * be performed under lock
>     */
>    sgx_zap_enclave_ptes(encl);
>                                   /*
>                                    * Fault on CPU2 on same page X
>                                    */
>                                   sgx_vma_fault() {
>                                     /*
>                                      * PTE entry was removed, but the
>                                      * page is still in enclave's xarray
>                                      */
>                                     xa_load(&encl->page_array) != NULL ->
>                                     /*
>                                      * SGX driver thinks that this page
>                                      * was swapped out and loads it
>                                      */
>                                     mutex_lock(&encl->lock);
>                                     /*
>                                      * this is effectively a no-op
>                                      */
>                                     entry = sgx_encl_load_page_in_vma();
>                                     /*
>                                      * add PTE entry
>                                      *
>                                      * *BUG*: a PTE is installed for a
>                                      * page in process of being removed
>                                      */
>                                     vmf_insert_pfn(...);
> 
>                                     mutex_unlock(&encl->lock);
>                                     return VM_FAULT_NOPAGE;
>                                   }
>    /*
>     * continue with page removal
>     */
>    mutex_lock(&encl->lock);
> 
>    sgx_encl_free_epc_page(epc_page) {
>      /*
>       * remove page via EREMOVE
>       */
>      /*
>       * free EPC page
>       */
>      sgx_free_epc_page(epc_page);
>    }
> 
>    xa_erase(&encl->page_array);
> 
>    mutex_unlock(&encl->lock);
> }
> 
> Here, CPU1 removed the page. However CPU2 installed the PTE entry on the
> same page. This enclave page becomes perpetually inaccessible (until
> another SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl). This is because the page is
> marked accessible in the PTE entry but is not EAUGed, and any subsequent
> access to this page raises a fault: with the kernel believing there to
> be a valid VMA, the unlikely error code X86_PF_SGX encountered by code
> path do_user_addr_fault() -> access_error() causes the SGX driver's
> sgx_vma_fault() to be skipped and user space receives a SIGSEGV instead.
> The userspace SIGSEGV handler cannot perform EACCEPT because the page
> was not EAUGed. Thus, the user space is stuck with the inaccessible
> page.

Reading the code, it seems the ioctl(sgx_ioc_enclave_modify_types) also 
zaps EPC mapping when converting a normal page to TSC.  Thus IIUC it 
should also suffer this issue?

> 
> Fix this race by forcing the fault handler on CPU2 to back off if the
> page is currently being removed (on CPU1). This is achieved by
> setting SGX_ENCL_PAGE_BUSY flag right-before the first mutex_unlock() in
> sgx_encl_remove_pages(). Upon loading the page, CPU2 checks whether this
> page is busy, and if yes then CPU2 backs off and waits until the page is
> completely removed. After that, any memory access to this page results
> in a normal "allocate and EAUG a page on #PF" flow.
> 
> Fixes: 9849bb27152c ("x86/sgx: Support complete page removal")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> ---
>   arch/x86/kernel/cpu/sgx/ioctl.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 5d390df21440..02441883401d 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -1141,7 +1141,14 @@ static long sgx_encl_remove_pages(struct sgx_encl *encl,
>   		/*
>   		 * Do not keep encl->lock because of dependency on
>   		 * mmap_lock acquired in sgx_zap_enclave_ptes().
> +		 *
> +		 * Releasing encl->lock leads to a data race: while CPU1
> +		 * performs sgx_zap_enclave_ptes() and removes the PTE entry
> +		 * for the enclave page, CPU2 may attempt to load this page
> +		 * (because the page is still in enclave's xarray). To prevent
> +		 * CPU2 from loading the page, mark the page as busy.
>   		 */
> +		entry->desc |= SGX_ENCL_PAGE_BUSY;
>   		mutex_unlock(&encl->lock);
>   
>   		sgx_zap_enclave_ptes(encl, addr);

The fix seems reasonable to me for the REMOVE case.  But IIUC the BUSY 
flag should be applied to the above case (PT change) too?
