Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA801494C3;
	Thu, 24 Jul 2025 21:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753391674; cv=fail; b=N/O7JCiWVbBjrnpFKF/wvRyrVQsFHUlukfXgIhP+tHA7X+Nif8nRold0h9E+00B/Y8z0o2sRp49OFLh1TJ8XWR1OHRv9DR+F5EUDfrx/xCxYP1SWyRrH4bjKefkAvepzvYNGAfr4ic4yzyDITieDRhXgL58FWvS59NN532ll5nY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753391674; c=relaxed/simple;
	bh=uFsMLPMh8mxU9isNFU9A7yH6a7gaEtD/SMc47aUvKsQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HT3HEiOXoFm19dzhXDtRBR6FQc+MS1HppolZPKKgT6HQ7sJt4TLJi3FF6KHclcC23XEdRNUyfLMdYTxKGJYg9lNJZzCz29+CCu7y6WjjFuUo/IHdadQeQ+BnckTEdVWzY8LK4B0heXQzxwZDgOlgykNfRs0K0UEOJ/PYcfD+/9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UvfHZChs; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UvfHZChs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753391673; x=1784927673;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uFsMLPMh8mxU9isNFU9A7yH6a7gaEtD/SMc47aUvKsQ=;
  b=UvfHZChso9mpPydfc5hRFmRFKcQBRKBtt9yJnA/peVTZef6/X4ayos7j
   mV/gqmJuUnBcwTka/CvgdenygYF8N7h+TpyOaneQnmGxenJwVhkBd8Upn
   DOucXyKLDXkXhwSWqpoCQvbhgqpEwmaEfC3ZUKTVC+2Gy8QDlxcu1mXox
   SMKHoLVQeoIM4z9PRthwvj8nBc76+1htZtUDam1xs+FGXt6Walr3HK/PL
   b90gsMGPfxdJ9/O0EC6KHuxepUX1qsBrzLWb3gCziM57NEUrr/y0f5Yt3
   eJA+e05fpXfMYuMpG4+jOr/TRUq6dJe8uM77tH6kvpDJyIOo05EbR+jHP
   g==;
X-CSE-ConnectionGUID: irh47/tnRPyMWwo9fg71sw==
X-CSE-MsgGUID: FZV8nAO7SjOMh45U49UGBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="59527922"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="59527922"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 14:14:27 -0700
X-CSE-ConnectionGUID: gq0SQAccT9q7ndFFsxvt4g==
X-CSE-MsgGUID: XdKgknN+QYeZ3Jm8vcgBtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="197590084"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 14:14:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 14:14:26 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 14:14:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.71) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 14:14:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oucsHDSBmfpYd9N5qbE3IOhgMP75D06ivm9iTJKY/Ev3qcsSEkOWgSkCmrBIIOq27jXqPjuG0ZOkrrsXRcHrhGF5bmh0rmv3/ITkbmH6n6OSkCZGPi0yfeoA8MM16zh5ZoTJAo/ZR/3o/XWRKIyQO72u4ERbLa7rO8AejOCKReic7OdTnA9GWRNcvozVvZgLwbiLzfioUretWj40iReVFoq4+LuMdb6p18QDj90ZbvM+7AtVKs1UU7aj1/2q75B3KQ4EOEihwoa7VMJv6/NU0xNM3UFVLwiONtTe/tbSFsVHIhNoViIpiEaaguxmsswXJns3MjAldBlMuY6uWiGCHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFsMLPMh8mxU9isNFU9A7yH6a7gaEtD/SMc47aUvKsQ=;
 b=NSuZO0AP6Il0o9Bg28K3JuTf/8iXZyKcrnx5+F+GC05BbON3OuUV8wjWfMi4cGG997R/a+Rg+X+cvcblQvjIwLOfUf1S6x2x5IQkpVaH3NEXnbLfTgB5JSB6owc/x9hDYgq/XC/1a2pzO+yc36ux6B/yFcSwwyCVXbfUJ/BHxacTObCr8GWnLwvSeWRn6NOLMCrKbkvZoKA7gCLI4xsS3CW8/RuVpWrRlGy0Hk1L9WpJoYo61oQqq5nGcfz2iY/5xBAlX6EIztp+/DV/MuLS3ZiBw59lGzHlhg4h6bc4GSzWMJ/22RRD6Z01nhlsjy+MhycgfkF0unPKKVeOz+NL1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW5PR11MB5931.namprd11.prod.outlook.com (2603:10b6:303:198::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 21:14:23 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 21:14:23 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"mingo@kernel.org" <mingo@kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHb/HGK60dfSRXjp02uNG1v9X+jQ7RBHuaAgAAakoCAAI18AA==
Date: Thu, 24 Jul 2025 21:14:22 +0000
Message-ID: <7a9e68954b23418fab09edd64b47dc8056f7f8e8.camel@intel.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
		 <20250724080313.605676-7-elena.reshetova@intel.com>
	 <156919280fe6b1e01a81bb89f8850e72a6bfe077.camel@intel.com>
	 <DM8PR11MB57502FB1B78481B436DFAFFEE75EA@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB57502FB1B78481B436DFAFFEE75EA@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW5PR11MB5931:EE_
x-ms-office365-filtering-correlation-id: 0f4b3407-66a5-4dd2-cdd4-08ddcaf70ff8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eDhNMFQrRFZwUEJYK0FaeENxM3A1dkNUdU1IUEVZa1RNOXdJNWVVejVpSTB1?=
 =?utf-8?B?eG1KdC9pMEZ0b0lvcjlGOGphazRRSEhvbTA2dU0yRE9PTWJaTzI5ZjR2cjZX?=
 =?utf-8?B?S2xGZWRVaHV5bmtMZFBrNFhVSHJST0MyblBRL2hHTDZqWWppTzlHVzQ0YkVW?=
 =?utf-8?B?YmQrQ1RKeTQreVNnQzRwdmVIRzJXck9qUzhubUZ2OW1lZ3doaldKd3U5bHVa?=
 =?utf-8?B?V1NIYytGWGkybTFwVHpYKzlwaGsyczAzdE1hUmc5MWxlS28zclg0bjh4VEhh?=
 =?utf-8?B?bjRVM09CUFdVT2RLdlFQbGxuaDg5Q1NuVHFDRVZJT1pCaHI3a0VmTEZTeW5p?=
 =?utf-8?B?R1JYR2R2bTE2UEZaSnhCUW0zMDJRZ3RZa2RwVFVlZVJ3U0VXV3l6SU96NDVw?=
 =?utf-8?B?YTJ4Smw5cmVkK0FRSWVMdGRNRXdTZGk4b1ZPQjN5dmd0WEhCdGsvcU9lVFE1?=
 =?utf-8?B?ZE4zd1RBbmhjalVrTXlOYi9ZdUNiaDhCa3MxcVVkcm1NekV4MTRYNTkzcjhv?=
 =?utf-8?B?blpVeW5renA4MWFVM2M1YkhOdjd4M1BIV2pJbTVKZk9ybE9kTFBqZWpCblR5?=
 =?utf-8?B?WWdoTCtIKzhsRUJpZEhCNWkvaUNvM29YNWRGYlg2b3ArQnMrZUJJU3BpemxZ?=
 =?utf-8?B?S3NMTjV6YXIycklUbDFnZlVoQXhpUjVQVm84K1Fjd0R6eW5WaERNaWpBK0l1?=
 =?utf-8?B?YWhEeVRPbDFHbjJsZlNFWGN0cEJyQzVGUlJSUUg5aHlTVEJoaHBKak16UEJv?=
 =?utf-8?B?a1NjN1FrU0xCTnhzVFdRNktNREtIMWxhY0IwK3NOZ1ltSTNZZHBXbTAwdS8r?=
 =?utf-8?B?QzBYNXQ0ZE9URFRzblh5RDErbERZbmpCMDZUV2JFTisvVVZZYWNDTmFwd3hs?=
 =?utf-8?B?aW5KWU04dG9NY2cwT3F1Z2ZyRDJhYWEyVkJGRkZMM00vbUhuZ1B4TFZNY1N3?=
 =?utf-8?B?VHBzMlFXS3dpblFXZjM1U0EvbjlLSWl2MU02STRYWU5vUWpJaXdBUVR5ZFNG?=
 =?utf-8?B?UHQ5NnpFbWNTME5CTFZYVUMrRGk0dUhKajVPTDRZWFE3clc4Qk12WVc4L3Yz?=
 =?utf-8?B?bmc4ekpEWDEwM0QxNi9LMEhndm1JQ0Y4V2F5QUtrWXBkZnlVb3M2RkFkM1Ry?=
 =?utf-8?B?VDRvSERiNDBBdHZhS0pNelBZcFljbkhROU05dHFwTDc5VXhjc0dXWDMrRnVB?=
 =?utf-8?B?aVVHNVpneU03UTVMSkxEUDZDNTZtZXY0eEYzdHhPcHZhNW8rRHlCTTduK2FF?=
 =?utf-8?B?NWFmOTRPUGZuTnEvRjlONndKd3o3b1dGUW55RU45eUxwNVFLSXQzOCtzeHBr?=
 =?utf-8?B?Kyt5V0RBdDEwTGlFMHd2QnEwaWw5QWV4b2tuRWY3RlRsMmR3ZjFLOFc5RFBR?=
 =?utf-8?B?OVQ0blhlNGxEZndqWit5UG5nZjVIaSttdjVVZGJZTXlMQlRJVlAwWkdjUHhP?=
 =?utf-8?B?QnZMcjV4VVhQSFJrL09sQnVzWGcxS2FPOTFVZExYKyt4N3B5c0RSdmhSSStL?=
 =?utf-8?B?Yld5cmxRM2tGN0YxN2FhbUtiT0tiTVRISG1vbm05cnNLRE0wWktYNzhEVWx0?=
 =?utf-8?B?VXhRbkQzOEJnU29iOTNyVXJZRGxnSXVwU3MyaHlNTjBSaG16RHhqeU4vTEVi?=
 =?utf-8?B?cjExakpNaS80bmw5eWxJcU52ZWE3OGlKQzdmT2lrbE4rWTYrWTIwQ1pTVHNx?=
 =?utf-8?B?TFBrNzJTbGlYNlNwOHF0aU92NkRkYzFKTlVQMGVoVnlNVFViZDh6VGdoTzIx?=
 =?utf-8?B?bE9Ga00zUzlUcVBEQzdkclgxb04rQ2V0L1hDcEJCNUM5VGo4b2NBdFgydERp?=
 =?utf-8?B?OEtaSnB4RlpwSzhYaEtzU3cvMlJubXJrdEhUUm1rUE1kRlpTUi9IbDhVK0xB?=
 =?utf-8?B?bEdoNEROMGFiem1uZGtCeG11MUttYkNVSjlwblk3cXpGR3VGR3l4VUhSY29D?=
 =?utf-8?B?VHlhL2RONHVTNjFpaWg3RlZUbTNlWVVFSmhQMkFDNTZjejRlNC9WT1QxYzZt?=
 =?utf-8?Q?/+TbrFlg5770dkY4pWiVJ4+edE7KRU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnNHNFNLVVhSM25FUzQxc0hiY3FKc21NSkFUZ1o4Z3hMMVhQeklybW9YbS9G?=
 =?utf-8?B?WnlkVXdxWVdoUFZKS1lEU0dXWEZnOVNBZnFodjA0OWliK1R3Y04wZC92OG9W?=
 =?utf-8?B?dlczaFozME9YUkZrUVhBQ051SStZUEZ2MDlyYTNlRzlCbGg2NUdieWRMZmN1?=
 =?utf-8?B?N1NmMXZ3WXkwTGRUWVJPdU1NeFdmWSt4VURBcnF1Y2JYVHM4YUEwMklWdnQ0?=
 =?utf-8?B?MTBKdlJZMkNQeUNVcERiUVNTUzVhbzZ1a3NoMmtpNURRcDZLRUxINE9aejdE?=
 =?utf-8?B?WHhiaHdNeVNadENScmFXUk9wdys3SURxcUhKOFJCZ1Q1UmdiVm12ZG5qV0lK?=
 =?utf-8?B?UC9SUFgyOGdNRDR2TXBOemtJTE82V2RDK2JNNG5SNGdPeUZQN1hXdUFnTmwv?=
 =?utf-8?B?eW1Fd09ZaU1UdzNpZXJJdGJYdkdtVGxDVTcvcnVPMFV5S2tZZktuTXR4Q20y?=
 =?utf-8?B?Ujhiay9iZVpiblA4eU03YUFoTlZrd3NiaG4ydGk3cGNaMTJSWTlyUGJiSHdo?=
 =?utf-8?B?NHQ1aWk0RXRnZzdOcVhudDU0dHJwc0JyYXdLTmFmOTM2TEFpTTBkMTRnc0Rq?=
 =?utf-8?B?VmhtWlA0bUtITkRUMjhoQkE0Y3NWVmtEbzJYR0FuOW84ZkNSanFKWitrMFdM?=
 =?utf-8?B?ZWJqMUcxOGVNUWhEbFJMNkgzMkxHRXdFNzdib3JkVEdNYlNRVGIzSFlHcDdw?=
 =?utf-8?B?RU9jYlhSclVlRFIzMlVXNGlIMnByUWNOSVp4V1RlMG1aS0F5eEtkUFUxZUph?=
 =?utf-8?B?UnY4eTQxWDMzUkd4WXBscXZ5VXJHc000TE14eU5SK3VWNElmVnIzY2F2VGRM?=
 =?utf-8?B?TG1YbXdvb3dCbXpoNmtGaE84b0FPVmM4VktZSzhMcHNpeHpvRzd0SWhFRi94?=
 =?utf-8?B?UUVxVk9yRm9vVXhwWi9FMjNJenVTZTlTZmZvcUNJVkxOUVR4YTFBWkFMN3BO?=
 =?utf-8?B?Y1VWdG5qWDBLVGUxUjNHWTluRW9laEtBTno2K3JDUTRTZDZXVS9aZUZPbEc3?=
 =?utf-8?B?cTluM2lSNHZqaThxak5mWUJnRng4SlgrVHNVT0VncW5Bd1hKdjd4UmNBVWp4?=
 =?utf-8?B?UnNXYlEyZWo1R3lwaDRqWVZTVGlRajJHVDhvR2pObG94VHBVZFQ1Qmx1KzVk?=
 =?utf-8?B?ZTMweWVDRk5YbWg4eDNiL1BvRC9DQ21IWFVheFpySWJkMGRMdXJISHhqRmpv?=
 =?utf-8?B?WWpyT01KajMvKzEza29jNFBGVmx2Vys5c3hrMHBHY3gwa2NsVyt2aG51YnJL?=
 =?utf-8?B?ei91bWpiS1NlOXdRUzhja25lMmtRaGpOZzhLR3hlaUNVL3hCeVhjNWJPUzg3?=
 =?utf-8?B?OVZhUkVuU1BsUnlyeEpUYVJnYnFuNm1SOThDakZjbFJHRXA3S2U4em8xVUVU?=
 =?utf-8?B?OFA4cHcyS0lKQ2tEbzhiWXQydm9iMDJmYlhsVmdmQlUvQmw3Z1ZGY3A3MHhO?=
 =?utf-8?B?NEFlQ29GMXptbC9ydFp4OEFuSWR2eFhyT25RUVBNZHg1UGM1ZEQ2RFQ4cC9O?=
 =?utf-8?B?enQyaWcwdC80TE52TUFiZUExU3NkeTduaVkrRzZQNzJmdzRaSVFZbm1OcTZ3?=
 =?utf-8?B?R09tRkV5TGJVMmxwMVRGU3B6R2RFcTdlbzM2azJtaTBlckVjVlpDNzRFeXVG?=
 =?utf-8?B?bW4ydUFDbmJpN0UvNy9JUUZVd3NMK3ExWlFaNUhFL242V1VBMlIxZEVoaXB1?=
 =?utf-8?B?UmVMV2JwYTJ4clNxdzVwUUpsclZ2SE81ekljUUZrbDlHcmIwWGlLZjArbTNh?=
 =?utf-8?B?U3d5Y1oyNW0xY0FHVGtucUhUNE52NC9hT1BCanFPekZCWTB1eWFTUngxMkln?=
 =?utf-8?B?UmRMZ3JJcFpJZjYyV0M3cVBrQXU1VWlBeFFWQW93RjZBTWsxYU1iTnR2RHB0?=
 =?utf-8?B?MENBam5mY0V5SUtlRFRHOTlEUGdvejdKekVXNjRzZzlxeFBLYStFRUxwaXBG?=
 =?utf-8?B?bVdXbWViM2taa0YxbXU4QnhzdlhZMXN4UDhPWS9DOTRGdlhFdlkzUEpWdU9h?=
 =?utf-8?B?Y1JrQUNMUk93MXBLY0NSSHpLWmMvN3E3UWNtR3dxOFR3d3RMcVlsRStJOTQ4?=
 =?utf-8?B?VWlkOFp3Qm51aHIzNEJDaVBHTVJ6b1FNT0c4bi9qcklON2RKS0xlYXFLdWJS?=
 =?utf-8?Q?aNTnyzrTKyi+PGQQmOtjZ7Dwf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <154E9FDD02E4CF46BF5BE038900F516B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f4b3407-66a5-4dd2-cdd4-08ddcaf70ff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 21:14:22.9617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bbr2YWxalwg+nPHn8gMSOQDtsek1tRYuzGHkaw/iuSazhG0/4lhLwZhO+7kbdPEQuod5kuaQwgi95Hl/JYTffw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5931
X-OriginatorOrg: intel.com

DQo+IA0KPiA+IA0KPiA+ID4gDQo+ID4gPiBBdHRlbXB0IHRvIGV4ZWN1dGUgRU5DTFNbRVVQREFU
RVNWTl0gZXZlcnkgdGltZSB0aGUgZmlyc3QgZmlsZSBkZXNjcmlwdG9yDQo+ID4gPiBpcyBvYnRh
aW5lZCB2aWEgc2d4Xyh2ZXBjXylvcGVuKCkuIEluIHRoZSBtb3N0IGNvbW1vbiBjYXNlIHRoZSBt
aWNyb2NvZGUNCj4gPiA+IFNWTiBpcyBhbHJlYWR5IHVwLXRvLWRhdGUsIGFuZCB0aGUgb3BlcmF0
aW9uIHN1Y2NlZWRzIHdpdGhvdXQgdXBkYXRpbmcgU1ZOLg0KPiA+IA0KPiA+IChTb3JyeSBJIGZv
cmdvdCB0byBzYXkgdGhpcyBpbiB0aGUgcHJldmlvdXMgdmVyc2lvbnMpOg0KPiA+IA0KPiA+IElm
IEkgcmVhZCB0aGUgcHNldWRvIGNvZGUgY29ycmVjdGx5LCB3aGVuIHRoZSBTVk4gaXMgYWxyZWFk
eSB1cC10by1kYXRlLA0KPiA+IHRoZSBFVVBEQVRFU1ZOIGRvZXNuJ3QgdXBkYXRlIFNWTiBidXQg
aXQgcmUtZ2VuZXJhdGVzIGNyeXB0byBhc3NldHMNCj4gPiBhbnl3YXkuDQo+ID4gDQo+ID4gVGhp
cyBpcyBubyBoYXJtIHBlciB0aGUgcHNldWRvIGNvZGUsIHNpbmNlIHRoZSAiY3J5cHRvIGFzc2V0
cyIgaXMgYWN0dWFsbHkNCj4gPiB0aGUgQ1JfQkFTRV9LRVkgd2hpY2ggaXMgb25seSB1c2VkIGJ5
IEVXQi9FTERVIGZsb3cgcGVyIHRoZSBTRE0uDQo+ID4gDQo+ID4gSW4gb3RoZXIgd29yZHMsIGl0
IGRvZXNuJ3QgaW1wYWN0IG90aGVyIGVuY2xhdmUgdmlzaWJsZSBrZXlzICh0aG9zZSBmcm9tDQo+
ID4gRUdFVEtFWSkgc3VjaCBhcyBzZWFsaW5nIGtleS4NCj4gPiANCj4gPiBJIHRoaW5rIHRoaXMg
aXMgaW1wb3J0YW50LiAgQmVjYXVzZSBpZiBlbmNsYXZlIHZpc2libGUga2V5cyBzdWNoIGFzDQo+
ID4gc2VhbGluZyBrZXkgYXJlIGxvc3Qgb24gRVVQREFURVNWTiB3aGVuIFNWTiBpcyBhbHJlYWR5
IHVwLXRvLWRhdGUgKHdoaWNoDQo+ID4gaXMgdGhlIG1vc3QgY29tbW9uIGNhc2UpLCBpdCB3aWxs
IGJyaW5nIHNpZ25pZmljYW50IHZpc2libGUgaW1wYWN0IHRvDQo+ID4gZW5jbGF2ZS4gIEUuZy4s
IG9uZSBlbmNsYXZlIGNvdWxkIGZpbmQgaXRzIHNlY3JldCBlbmNyeXB0ZWQgYnkgc2VhbGluZyBr
ZXkNCj4gPiBjb3VsZCBuZXZlciBiZSByZXRyaWV2ZWQgYWZ0ZXIgaXQgcmVzdGFydHMuDQo+ID4g
DQo+ID4gQXNzdW1pbmcgSSBkaWRuJ3QgbWlzcyBhbnl0aGluZywgY2FuIHdlIGFsc28gbWVudGlv
biB0aGlzIGluIHRoZQ0KPiA+IGNoYW5nZWxvZz8NCj4gDQo+IFllcywgeW91IGFyZSByaWdodCwg
YW55dGhpbmcgbGlrZSBhYm92ZSBiZWhhdmlvdXIgd291bGQgYmUgYSBuaWdodG1hcmUNCj4gaW4g
cHJhY3RpY2UuIFNvIHdvdWxkIHNtdGggbGlrZSB0aGlzIHdvcmsgYXMgYW4gYWRkaXRpb25hbCB0
ZXh0Og0KPiANCj4gIk5vdGUgdGhhdCBpbiBjYXNlcyB3aGVuIFNWTiBpcyBhbHJlYWR5IHVwLXRv
LWRhdGUgYW5kIEVVUERBVEVTVk4NCj4gaXMgZXhlY3V0ZWQsIGl0IGRvZXMgbm90IGFmZmVjdCBl
bmNsYXZlcycgdmlzaWJsZSBrZXlzIG9idGFpbmVkIHZpYSBFR0VUS0VZDQo+IGluc3RydWN0aW9u
LiINCj4gDQo+ID8NCj4gDQoNClllcyB3b3JrcyBmb3IgbWUuICBUaGFua3MuDQo=
