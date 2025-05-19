Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC773208;
	Mon, 19 May 2025 10:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747651655; cv=fail; b=WY1lzhgO3pf/YNN4XagjqcEM/wipoR9tRJhgf70z3HDDfI2yEmAyWrP64nUyhCqYSPEVaDHHeIvFMUuRE8RjTh4SylyUXXnUq4/IecybSZeupQ8dztB42zgfduwBSNtLl+PoVp4pNdxaettfHLb8GRw3aZliaHrwVZ3D6Ld0iCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747651655; c=relaxed/simple;
	bh=qw3goXT/HKP7IFBmsg1uba9MncP9ysd20KCFKR2L7yU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mWzzaC0GATbnOivDEnZcr+GUZc8y1Nu6Fk5HBp/wZFJ9ECecZCl9MTg/XWE5wk3uE+r5IIFZMUOSJJiZznW84+Ep62yXZqMLM2pTiCG6RJGSyR31GJMLvciT4a8Ignoq0jqka6bP2lO9ekBzOpyFxrro4M2xyVCYVhP2TEDlNzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gLNKAbzl; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gLNKAbzl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747651654; x=1779187654;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qw3goXT/HKP7IFBmsg1uba9MncP9ysd20KCFKR2L7yU=;
  b=gLNKAbzlJyJ9OOXJor42LoeTN4SxFvmBFlTmGU5OwF2rlRAechE2mPZS
   JtFJkanphPSdMftfJzpkQdf3dR/gTMXH/AFPGfeErLe4DsQu6iHjL035m
   GHi2IN6F1faTvoJeMYE1ElB7EZiCR9C96w9pX35YBTpkzGKJjL/0zgEMQ
   7rTLiVDIaApKyo62zQW8eVXBisxhrH6WEg60B7WKLpPFbD7bTItY1GixX
   XGJHGV9a8DwQpQbRB/iV60EYz/azBu/oJIOISqWfD3F4DDOnlwDO6ridf
   9BwXOGkfRGvK7IQA+Az56ARa5RATH8oZCFqZzQXRRE5td+3qrZGxpA8HK
   Q==;
X-CSE-ConnectionGUID: jAE7FXutRSuTOtMjpnfugA==
X-CSE-MsgGUID: f7cSYwvvSwuDi3AWwxeqLA==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="66959693"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="66959693"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 03:47:33 -0700
X-CSE-ConnectionGUID: vv2++HdHQm6X8nTttPtMfQ==
X-CSE-MsgGUID: 0xUzruB9RY6QuYDubI4Ysw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="162625389"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 03:47:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 03:47:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 03:47:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 03:47:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jtAjfcNPc6tuqtjyG8r/Xk1+WGkNfTKw1DiJzPmSWdaCsWmrslX1YEs4zJrED1Uaq+0KMRKd0hGHLoiD7qSefQRmZa8GkVVh4Y3/PXc2jufEBtgpYex4H8+ZERI1HI5jo/uzJ89BOZ/3aDMGdjOdb0gQXSbgdFrjgeFrCI/ulUo/ugfHdN+3d3JDV65w0VUFG+yUmvipD8QQUO+Z6iK+nXXwsdQvEKEQk49gypKoPH9lnNkGlxzfzXM/fSigqn67Ieee79iM6mQinlKCKXkKjrCy6/dKvHY4AjlY+toW3uty03hJxL2DtZoownGBT+KDtgbzx9vO6VnrcnqD7eRY2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qw3goXT/HKP7IFBmsg1uba9MncP9ysd20KCFKR2L7yU=;
 b=RQRGGbultBdpz1UGoUycI3yHOnKKA0XfkpMfWyU/f3UaKI0v2Gud5PrIdwsbn7IBAv+Y6pijlibvwPLoNuURkJBIr31kbExJZRtJfwm48yLJxU1SVTsC/ioDOvhUhG3+dRQcyMU4MfNu5QJCxIqaIqxySIsN+UNtD0h0xzKBjIQ/BbW6gQUiJW6yKCqZqvkusnajEolShFfXMjWabmYxKZLnUQ7AsSZcp+nVmQmlxj3EtpGjnLu+ASV6Jd2ZsQq6KB/1N9Cq32sv6voCFMR6qPIspUo3SH4GLmsRaAVoDew6Kws+F62yEco/32AoqdSKn4PkuLWlph34QqJy6gfD7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB7524.namprd11.prod.outlook.com (2603:10b6:510:281::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.29; Mon, 19 May
 2025 10:47:29 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%3]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 10:47:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "Raynor, Scott" <scott.raynor@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: Re: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyI9ksgqZIsreHUKEItLJ2DPjZrPZxbAA
Date: Mon, 19 May 2025 10:47:29 +0000
Message-ID: <c955515c5469dae17faa13ebda28459d7c998bb9.camel@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
	 <20250519072603.328429-2-elena.reshetova@intel.com>
In-Reply-To: <20250519072603.328429-2-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB7524:EE_
x-ms-office365-filtering-correlation-id: b0a60190-953c-4697-8ee1-08dd96c28d25
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N0VQamF3cnZiTWJUTjNCdlhxRFZJZG4rNVVnVDkwQVNoc29ZN1ZGdlZSVVJq?=
 =?utf-8?B?RnBYWE9ndVVHbjdhem5HSmtscXkyL2IwNFVuVFNyRzArd2hkN29EU0dCUHlD?=
 =?utf-8?B?Lzk5Z1hXM2s5d0E5WmxzZ1pCT2JDYWYxdXdJYkY0aDZ6bUk0bFlsOFBQclh5?=
 =?utf-8?B?OVlXNnUvcEc5TjB5cHI2TnA4SFo3TVFzTWIyY1U2b0JZalI2a3cwM1Ura0d2?=
 =?utf-8?B?Rk9UU2M4M01IK2pqa29ndTVMZFJaNGkzUWJpdlJhNWpJbVc3bXloSWZYWXRa?=
 =?utf-8?B?K1k4a1ZkQ3NjdWhnd0NrVmlRSTNYTWZ6ZEhKeFpNcW1NNE5RV0JuMkl1NVQ5?=
 =?utf-8?B?MWg5eTJwSkZjQS93M1VYOWV6OHo3a3NlSG8vK1Y1UVdzR21Zd2FRNkRDV2Vo?=
 =?utf-8?B?ZUhtTmlSTDJsNENZWDJ0bE9IN20ya3RlVFJqUWUvTjh5WElZZVNwR3ZiYU9M?=
 =?utf-8?B?eHRsSEhES01sQnhEQVU5MGtjUThUMWpUbmhySWNKN0JPZjlDTExDR2RTSTBV?=
 =?utf-8?B?WXlPWHNoMno4TlhzTVJLT0NtUHMxczl3ZVdRV0daWWZaOHB5YmxlY20vZmJE?=
 =?utf-8?B?c09tMVFLSTVvTFpqQmlhbWdHU2RQMHV6Q0VVc2lZVnZMQ3MrYVora1gvL081?=
 =?utf-8?B?ZCtBaURIdGcrVjdxQlZrRTQ0NC9NVWdzWkU4TDBOOGJ0QzNPVU1BUnAwNGgr?=
 =?utf-8?B?cVBTWHdTQ092NXJNMHI3Qi9LWEJBMGw3Ym0wQk9jNjUvTTM2bUtYVnM5aitm?=
 =?utf-8?B?SHpSOG15M0dHeVZ3bDRNRHcvNGQyaEdhTjVkYmJSTzI2UlRyMmo5WHh1THEw?=
 =?utf-8?B?cVBrZWNWRGpOSm0yQ09ENWJkUnF1R1hNUlpINVNxTGV0NnBXM2lNUzJ4SVpH?=
 =?utf-8?B?Ri9JbUJNTEQvbDdrcnRBYmhXQ1BsRDdZZklUQW9ROFl0bW9yRnRIemVjcXpK?=
 =?utf-8?B?TVppcm8wUk4reWp2RFlvVktqWGIrQmRQY0M4RkV0Zlk1NFB2QWNqSlVNQXc2?=
 =?utf-8?B?emxBUFRKRk1mUUk5amZUTVhDZGtkanROSDY0WkE5WlE5ODFBOHoyeVFuSFk1?=
 =?utf-8?B?bklkK1BoQWN2eWZtOWtZQitSYnZJZFpZSkpkSjg2ZFpCbGdYUVlockJzVVZW?=
 =?utf-8?B?cjJGK0lFdWJ1MlNXU0FJY09YTVhJUmRPM3BNMGUrYWF2eGZyK3VSc01ZZ0hJ?=
 =?utf-8?B?aklEU2RHVGx4WEN5Mkl4Ky9VZWRCeTREdUc5YU5sOVJOWDRJR1RiUWdBYlRr?=
 =?utf-8?B?c3BUQUhNc0NrYzNOZFA3RXNWU3ZtVmtZcnBPSk15bDF1NTRqbW9MN1Q2bnNk?=
 =?utf-8?B?blYzL1pMcXRFY2FGcW9pbzVzRXFYdnNFYnNyclVtOFRLYnlmS0FzM04rNHJB?=
 =?utf-8?B?RXBHdGJBY1U0Y3c0U0NUOWhOZVBCVVhxNlNXbFM2U1BFYk9KSW1RaEJHR0xL?=
 =?utf-8?B?RituNXRHZ2RtejlTbXEvRlkvT28vMHMrWkRJUUZybUVHK01DMVZHQm1kSGsz?=
 =?utf-8?B?cStLTXV4aGU1cTRiWG1OT3pJbGVoUDF6cG5kcHlWUWFsMnZxM1J5ZXlKdmZq?=
 =?utf-8?B?MFBDaU9aM2RGbDBMRStUeTdFOVJ4ODBRQTJORWdhMlMwOVVXL2FSNGd3alhI?=
 =?utf-8?B?MzFvOUV5MDBMd3JzVlA3a0lROU96Q2U2aFNscVhFaFNFOEhwa0ZlOXRNQUIz?=
 =?utf-8?B?aFZRK094c0JpZnIxSnBzWEsydk03cTJLK09aL1pvK0plMmpzaXRYQzB5NEY2?=
 =?utf-8?B?V3RtUGxsOXJwck9hOFNPeDkvNUhxVHUwWlFRVHhlY1FsSFVGZERJaVNmaVE0?=
 =?utf-8?B?ZHRyLzZQeTVuSC9SZ3Q5aERJRUV4MkZiMFEwWGV0Smhyc1Rpc3RscDlMZDdV?=
 =?utf-8?B?c3lMcVVMVE45SjRIYW52cUJhWngrUjNhazBDUVNpQWZXY2lZa1ZqTFZSeEFE?=
 =?utf-8?B?b0FGVkg0OXJ2SzhXRnc5d0E1MytPeUFJdjE3YlpRQVBLeDh3TmFWMzBJNmlj?=
 =?utf-8?Q?qm0R6Pdzya8BX5O5oOX8Gfn0UQeIQI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTZEKzlZM0c1YURvU0p0OXJkMGgvTUpTYWNVUTEzWkhTYlEzWXAwdUNVMGRj?=
 =?utf-8?B?anR4cEZKWlRSd3lVYTdDMzd4MUNwOHpBaVlWU1ZNUWE0dDBEWmlmVFBaNXh0?=
 =?utf-8?B?Q3lMNnJxZDhialQvTjNrbDFxUmNZdmExRUNTVXZtNElFaVRENjdYZy9kU3N2?=
 =?utf-8?B?blRHLzUvZG01MWZIRTRxdVYxQk0yWHUvU3h4cHlsU2pQWkU3UU9peE5WQVZn?=
 =?utf-8?B?bTI1ZmhydG1QM2hiaVM5Z1F6WTlXSUdjOU1lT2Z2cWdEbWovcUpFSzg4c2E3?=
 =?utf-8?B?bmJ0SjRrci9ta3VBTXZhd1dZVWs2NFJGWlJhR0xhSWlhM1k4bE1tL000eGwr?=
 =?utf-8?B?NmVTWjY4bWd3VUFaUlBwbG1OSXhQUUZzSStTZnZSRVJNdjdub2xnQVptcHJ3?=
 =?utf-8?B?SlkzaENQU3NyUzBDTG00ZVM0ZUNZNit0ZmV1ZWI5R3QvMk1SbGp4emNFdDJp?=
 =?utf-8?B?R2RNZ0xaSktqKzJtK1p5VisrUzhjRm9xT09lZk9MdFZiVU1aNXczb1kyWWk0?=
 =?utf-8?B?R2VzZk1QZ2dvRnAzV2hjWmtOdlYveEpWK0xuOTBGL0VoRXJaSTA5RnZFeHpF?=
 =?utf-8?B?NFJxWXpaK1NiSGJBRy9SNVJnaUk2bk8yOE9iam9NYS94SFZGVjN0WW8vT0ox?=
 =?utf-8?B?dVVTL0l6S1h1SXBTZG5rb2d0czExNTZrbXRqQnNoN29PZnljUFdOa05mV0hP?=
 =?utf-8?B?ZTl6Z0hycVdpK2JFOU9WWVY1OFFDRUltZG8xVG9HYjRWekxXYVV6dVp6QmRG?=
 =?utf-8?B?MzJyT2lQUmFuRnp6LzU3WW9PZXNLUytiUEt5c0FWQzVQOGtMd1FuZmlXNVFt?=
 =?utf-8?B?RFdMbVhUUnFLZ0RpZ0NNVURaTHVVUjJ2UFYvMkFoamd4T0JreWM2VkdNWUxt?=
 =?utf-8?B?TWFrY0pZSy95MFR3NUVlbkx4Y3VVQ1B1QjRqQ2d3cHVhN2JnTGpWVFljc0tL?=
 =?utf-8?B?S0ZPRjlJTDVqdDEwYVVwaS9wK2YxNXFJRURFQ2tFOFdxZnFzaDZScmhGd1Fu?=
 =?utf-8?B?YU1QMFhkVVdvc2pZUHBEbG1abngzRk5WSVVCbkRlamVGcEJ4UlcxK01KdTRU?=
 =?utf-8?B?N0oyUDVITFQzUndWN0RJbFVOSTlMdExUYzRPVDNLTUxBT05GR0JRWTBCZzJM?=
 =?utf-8?B?R1RDbyt1OC9ydStvbXFXMjJ5U20zREtEWEhtRXl4VVFqV2d1amVTUFFKVVRS?=
 =?utf-8?B?cmIrK2QvWTVZMzl0OC8xRnNReFZEY1dLQW9nVGJudEtOY0ozeTlMVys3MGNz?=
 =?utf-8?B?K2lDdkdGMTJHcGs0Vzlac3pybUtrREtmNGszU2t6dlZDOU1ZdzFSZmhHcyt1?=
 =?utf-8?B?c2xmd0lhTGpFSDdFZVZDQXpmd2xQdzIrK3JIZ1lUNWlUVVdjNnVoclZxZ3dq?=
 =?utf-8?B?ZmdqLzdXR3pyOXZTM0RhODFTK1hWdW9IRzRQbFFYVVhSVVpMUWJySEVTSWti?=
 =?utf-8?B?RzlaMVZBcmNVVjVYOXVpYVViYjRGN2NVa2NqSDhSVW91cXgyVWVodU5ZM2pP?=
 =?utf-8?B?cWNETHlxYkYreGsybEJMM01yWThDOTg4cTNKWjFhci9nK3NoN3pERVNaUXlw?=
 =?utf-8?B?WnAxV1ZPb0huUDNVK0lQeThUY3lHWE9IV2VwZkd5LzI2T0Q0TUlKMy9hQ2Uy?=
 =?utf-8?B?Mmh0Z255cWR6RkUvZFVabzh0cERTZ2V5VzNzZzBhY1NzUXN2WkJidU5kTWcw?=
 =?utf-8?B?KzdKNkwyeXdpWXZ5Wk1pbTFMaC9yOVBIYzVpaks5cmh2dGx5WEZoSkJVTTE1?=
 =?utf-8?B?MUFlakpyUXBSNnY0dlhXeFdPMDM5NXVHZWQ2d0tzMTBEeWpGd0xmUmViTXNO?=
 =?utf-8?B?WXFCcWdteUtzV2RsQ2pVb1JKUlo4TWNWdGRZSWlBUXFjcXpUT1RjeEd2RWZ4?=
 =?utf-8?B?OEU1TXZONk5obFVPaVpyS0kxajNKTW5rT1RFWTZHYXlNZ2FmOFFwSkNRK25C?=
 =?utf-8?B?UmNlZDl1ZVJIY25LRHdxYkNIa0lvWlFEblNDWXp0ZlBzV29kdFVZUlBBUHRN?=
 =?utf-8?B?bGZkRkYrbUJhSmRaZ3Vxb294VGV1bnFHT2FtRlBJSSt5eFNtV1hTWDQyUFVY?=
 =?utf-8?B?bTFKdG5oZjUwVXNQWUVhY3oreldkUzh0dkV6bksyUCswd3RvZG5YKzY2c1Ft?=
 =?utf-8?Q?4xlJzK0QyNeasoAgkaKSHc69p?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <449400E1C2817045A43828BAFF150CC7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a60190-953c-4697-8ee1-08dd96c28d25
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 10:47:29.1628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ew9GnmwFiNG+3IEXwg5G2tKm64/FrGv4wTq2is39oQkQKGru4H8W2u5sIiw4lvzfelBIUGajHl7VL+6xLTps6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7524
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDEwOjI0ICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IEN1cnJlbnRseSBTR1ggZG9lcyBub3QgaGF2ZSBhIGdsb2JhbCBjb3VudGVyIHRvIGNvdW50
IHRoZQ0KPiBhY3RpdmUgdXNlcnMgZnJvbSB1c2Vyc3BhY2Ugb3IgaHlwZXJ2aXNvci4gSW1wbGVt
ZW50IHN1Y2ggYSBjb3VudGVyLA0KPiBzZ3hfdXNhZ2VfY291bnQuIEl0IHdpbGwgYmUgdXNlZCBi
eSB0aGUgZHJpdmVyIHdoZW4gYXR0ZW1wdGluZw0KPiB0byBjYWxsIEVVUERBVEVTVk4gU0dYIGlu
c3RydWN0aW9uLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
amNAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRWxlbmEgUmVzaGV0b3ZhIDxlbGVuYS5y
ZXNoZXRvdmFAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2Ry
aXZlci5jIHwgIDEgKw0KPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbC5jICAgfCAgMSAr
DQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMgICB8IDE0ICsrKysrKysrKysrKysr
DQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9zZ3guaCAgICB8ICAzICsrKw0KPiAgYXJjaC94
ODYva2VybmVsL2NwdS9zZ3gvdmlydC5jICAgfCAgMiArKw0KPiAgNSBmaWxlcyBjaGFuZ2VkLCAy
MSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9z
Z3gvZHJpdmVyLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9kcml2ZXIuYw0KPiBpbmRleCA3
ZjhkMWUxMWRiZWUuLmI1ZmZlMTA0YWY0YyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVs
L2NwdS9zZ3gvZHJpdmVyLmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZHJpdmVy
LmMNCj4gQEAgLTE5LDYgKzE5LDcgQEAgc3RhdGljIGludCBzZ3hfb3BlbihzdHJ1Y3QgaW5vZGUg
Kmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gIAlzdHJ1Y3Qgc2d4X2VuY2wgKmVuY2w7DQo+
ICAJaW50IHJldDsNCj4gIA0KPiArCXNneF9pbmNfdXNhZ2VfY291bnQoKTsNCg0KVGhpcyBzaG91
bGQgYmUgZG9uZSBhdCB0aGUgZW5kIG9mIHNneF9vcGVuKCkgd2hlcmUgdGhlIG9wZW4gY2Fubm90
IGZhaWwsIHNpbmNlDQpzZ3hfcmVsZWFzZSgpIGlzIG5vdCBjYWxsZWQgaWYgc2d4X29wZW4oKSBm
YWlsZWQgQUZBSUNULg0KDQo+ICAJZW5jbCA9IGt6YWxsb2Moc2l6ZW9mKCplbmNsKSwgR0ZQX0tF
Uk5FTCk7DQo+ICAJaWYgKCFlbmNsKQ0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2VuY2wuYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUv
c2d4L2VuY2wuYw0KPiBpbmRleCAyNzkxNDhlNzI0NTkuLjNiNTQ4ODlhZTRhNCAxMDA2NDQNCj4g
LS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbC5jDQo+ICsrKyBiL2FyY2gveDg2L2tl
cm5lbC9jcHUvc2d4L2VuY2wuYw0KPiBAQCAtNzY1LDYgKzc2NSw3IEBAIHZvaWQgc2d4X2VuY2xf
cmVsZWFzZShzdHJ1Y3Qga3JlZiAqcmVmKQ0KPiAgCVdBUk5fT05fT05DRShlbmNsLT5zZWNzLmVw
Y19wYWdlKTsNCj4gIA0KPiAgCWtmcmVlKGVuY2wpOw0KPiArCXNneF9kZWNfdXNhZ2VfY291bnQo
KTsNCj4gIH0NCj4gIA0KPiAgLyoNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUv
c2d4L21haW4uYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiBpbmRleCA4Y2Uz
NTJmYzcyYWMuLjgwZDU2NWU2ZjJhZCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2Nw
dS9zZ3gvbWFpbi5jDQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiBA
QCAtOTE0LDYgKzkxNCwyMCBAQCBpbnQgc2d4X3NldF9hdHRyaWJ1dGUodW5zaWduZWQgbG9uZyAq
YWxsb3dlZF9hdHRyaWJ1dGVzLA0KPiAgfQ0KPiAgRVhQT1JUX1NZTUJPTF9HUEwoc2d4X3NldF9h
dHRyaWJ1dGUpOw0KPiAgDQo+ICsvKiBDb3VudGVyIHRvIGNvdW50IHRoZSBhY3RpdmUgU0dYIHVz
ZXJzICovDQo+ICtzdGF0aWMgYXRvbWljNjRfdCBzZ3hfdXNhZ2VfY291bnQ7DQo+ICsNCj4gK2lu
dCBzZ3hfaW5jX3VzYWdlX2NvdW50KHZvaWQpDQo+ICt7DQo+ICsJYXRvbWljNjRfaW5jKCZzZ3hf
dXNhZ2VfY291bnQpOw0KPiArCXJldHVybiAwOw0KPiArfQ0KDQpXaGF0J3MgdGhlIHB1cnBvc2Ug
b2YgdGhlIHJldHVybmluZyBpbnQ/ICBTZWVtcyBubyBjYWxsZXIgdXNlcyB0aGUgcmV0dXJuIHZh
bHVlLg0KDQo+ICsNCj4gK3ZvaWQgc2d4X2RlY191c2FnZV9jb3VudCh2b2lkKQ0KPiArew0KPiAr
CWF0b21pYzY0X2RlYygmc2d4X3VzYWdlX2NvdW50KTsNCj4gK30NCj4gKw0KPiAgc3RhdGljIGlu
dCBfX2luaXQgc2d4X2luaXQodm9pZCkNCj4gIHsNCj4gIAlpbnQgcmV0Ow0KPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvc2d4LmggYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3Nn
eC9zZ3guaA0KPiBpbmRleCBkMmRhZDIxMjU5YTguLmY1OTQwMzkzZDliZCAxMDA2NDQNCj4gLS0t
IGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvc2d4LmgNCj4gKysrIGIvYXJjaC94ODYva2VybmVs
L2NwdS9zZ3gvc2d4LmgNCj4gQEAgLTEwMiw2ICsxMDIsOSBAQCBzdGF0aWMgaW5saW5lIGludCBf
X2luaXQgc2d4X3ZlcGNfaW5pdCh2b2lkKQ0KPiAgfQ0KPiAgI2VuZGlmDQo+ICANCj4gK2ludCBz
Z3hfaW5jX3VzYWdlX2NvdW50KHZvaWQpOw0KPiArdm9pZCBzZ3hfZGVjX3VzYWdlX2NvdW50KHZv
aWQpOw0KPiArDQo+ICB2b2lkIHNneF91cGRhdGVfbGVwdWJrZXloYXNoKHU2NCAqbGVwdWJrZXlo
YXNoKTsNCj4gIA0KPiAgI2VuZGlmIC8qIF9YODZfU0dYX0ggKi8NCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3Zp
cnQuYw0KPiBpbmRleCA3YWFhMzY1MmUzMWQuLjgzZGUwOTA3ZjMyYyAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYva2VybmVsL2NwdS9zZ3gvdmlydC5jDQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9j
cHUvc2d4L3ZpcnQuYw0KPiBAQCAtMjU1LDYgKzI1NSw3IEBAIHN0YXRpYyBpbnQgc2d4X3ZlcGNf
cmVsZWFzZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gIAl4YV9k
ZXN0cm95KCZ2ZXBjLT5wYWdlX2FycmF5KTsNCj4gIAlrZnJlZSh2ZXBjKTsNCj4gIA0KPiArCXNn
eF9kZWNfdXNhZ2VfY291bnQoKTsNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0KPiBAQCAtMjYy
LDYgKzI2Myw3IEBAIHN0YXRpYyBpbnQgc2d4X3ZlcGNfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2Rl
LCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gIHsNCj4gIAlzdHJ1Y3Qgc2d4X3ZlcGMgKnZlcGM7DQo+
ICANCj4gKwlzZ3hfaW5jX3VzYWdlX2NvdW50KCk7DQoNCkRpdHRvIHRvIHNneF9vcGVuKCkuDQoN
Cj4gIAl2ZXBjID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IHNneF92ZXBjKSwgR0ZQX0tFUk5FTCk7
DQo+ICAJaWYgKCF2ZXBjKQ0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCg==
