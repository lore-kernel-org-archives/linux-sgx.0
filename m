Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0222580CB;
	Tue, 20 May 2025 06:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747722741; cv=fail; b=Dz8xfoujLoOVRHdBhIFb/8cE55j+UHy3HzBMoBqxkUQFpRCxWIN3FjxlcSmuIztnq+uC1jS0KwjuhFWDD8YG3c19C1d6uy/Nw4Xom7eRMUR51v1V5spEHxhlzJKG2bsG1GwPQpZM6l9LodQe5KLd9kgQ+wRipnqVmvi6OV9X68M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747722741; c=relaxed/simple;
	bh=vC1HhlLZwzKHzo1X/5mNenWS6eLWDab/NSvYj7SDDN0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I3zMKqhkjKo6pn4SFWDZqQvnNet67JRh3DvUrjB1fKNx5IBiL+2OyB46t0LXTUKxhloS84LAGVPyNIIoJvb3k/XHWD+wjgmMTB0GSGzAThzedi2UZ3YNoFyJ7QsV6PJGQJHWM2cSZvkFyB8VVT66g1klkt3uuvek+zMqAVCMCe4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U3b5AYbj; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U3b5AYbj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747722739; x=1779258739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vC1HhlLZwzKHzo1X/5mNenWS6eLWDab/NSvYj7SDDN0=;
  b=U3b5AYbjkiryVwk9aWIuQFXwjFlt5HCaUzS5NxdrMdXy8nstF6V1C29I
   Kh4PICoK7ihYOaSOvRyQX34+0dgL5URXglEnDtYK0VXYPDnD3S99nMPXh
   PHAYvMPYkQAY1mzQmKWbeZxXGDB5vormhZRRb0iLc3wVNVL7kBo2SnXOq
   pV/t/nw+up18QMs3+NUiCAYc8g5cqYbA00lU8aohfH5cp6TGqaiAcg6lD
   IcdEVDtGOk9Zqzi/9OsWlRbKNDDRrWE2pqySaRXmqC38C4YULkcZAEouh
   oNuKfsSjOijkp8VLXStqggTmf2INidlqsg9J+aZdfa4MjBdC1/WNfaBU5
   g==;
X-CSE-ConnectionGUID: 3FgywtJWQMStrwelEluMlw==
X-CSE-MsgGUID: ShXMrRlURku/YXyZWyf2SQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49778926"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49778926"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:32:18 -0700
X-CSE-ConnectionGUID: bNZlgs3BTKCg51AGYsTcAg==
X-CSE-MsgGUID: GB1x0vdJSrS1M1hnAgTsVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="140603803"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 23:32:18 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 23:32:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 23:32:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 19 May 2025 23:32:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MV++2Nff/2WcmuNAcl55awGK7Ei3PuOHXveNKCzHtJD+nN+VWI8g1Xa4BrWe1evC7e0pMbG9BBol84815MRSnEx66nRaZKQDxmlF5JLtZ71CrWvMz0mo9qqvUvThc0f2W215G1dr2tPdi6ZTDPuTTkE7xyx6uPoHM3iHrJRC2dCNXNITt6Q0agwSwzzwHVfj85vQx076d7+f5GD6v6R7VKdHsUqIhqySTqxFAzLa165KgoQa66+CLTo0IVtgcnqu5ET499gvvpEufY0zS6d0NKYmjHcTBexMcNL1mqDij+kb0MH4cYB8ljv3oxdBQbxfNU6LtUBE07+oAdtTWCj5HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vC1HhlLZwzKHzo1X/5mNenWS6eLWDab/NSvYj7SDDN0=;
 b=HrJH0UUcWi33WK4TnL7gVGA2E186H/9Zs0Mm9wF/sjUoWHBFmN3qe+/occX0hCsTfYfhi0bVwCSKF0Du8p43XA575imra6Q16w3yMStRDqVCpX2UP6ySC6OURWwGFocOlTaFW5EogYKzPJjUDueMwDndcunTrMMHmRI9rvuTfeMup+cauEQcjSK9YiCE6Ty7TnYJVRT6tFeUZqKKB27pD3tKbAVJb4orcbM5BH6iMIxCXyUbna9WyiCuyXiqBqbWw7Bo/N20M+288Enwb1aKuLzEGcic12GSyHiZmj+aowYSa+/LH5LSXWl/qbnw7jFFcZglr0JTi+nZuXjGRx72sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 PH8PR11MB6927.namprd11.prod.outlook.com (2603:10b6:510:225::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Tue, 20 May
 2025 06:31:46 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Tue, 20 May 2025
 06:31:46 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHbyI9nyiauVlst/UyvS30ic5Ez1bPaRWWAgADJm+A=
Date: Tue, 20 May 2025 06:31:46 +0000
Message-ID: <DM8PR11MB57509295C87F7FB54B773107E79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-5-elena.reshetova@intel.com>
 <aCt3XZ0m40wuA9bU@kernel.org>
In-Reply-To: <aCt3XZ0m40wuA9bU@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|PH8PR11MB6927:EE_
x-ms-office365-filtering-correlation-id: 15c511af-d2bf-47aa-799d-08dd9767fe6c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SXVFVEpWWXZmTFdBeiswYitZSjdlZmo4VlFJcmJ0NE1EUFhlU21nVlhOV1Mx?=
 =?utf-8?B?Qy9QUFNkWGpGKytHZFEvT3lMOURBemlCZS94R2JNckF6ZHY3T0t5T01WeVVX?=
 =?utf-8?B?YUZVYW9aMmxWUzcveGw4YVZ3VHhuQnkyRHJCckc5YUtwYWdoSUx0QTdaWW4x?=
 =?utf-8?B?TVQxQlVmcUlFYm5CeUcxNHFmellaOUwvSFc0QU1BZzJ0ZXF2ditkK0VpSXdP?=
 =?utf-8?B?T0kzS3RsTWprOEVpVmRmeEpTemQ3SGN6Y2ZSZHdoa1FYbXJNM0p2QmluRXc0?=
 =?utf-8?B?RHpBK3o5aGlBODFlMG9VdzNxbzl1RW01REROanJjZXppbER1RUpwYmFpZnpG?=
 =?utf-8?B?Y0NtekRTZDNPOGdXZCtiR2UzdFgvdVNwN0kvUHpSOTIrYWZjdHNFcXE0cnBU?=
 =?utf-8?B?aDVQdEZkbkhvbExUK3JpKzNwbkh4TGRQd05ub1JEMzRQUTdwVGp0b29neXFM?=
 =?utf-8?B?VkErK05HVEpONEFxeld2NUJ0YTBvMkl6K0dKZlk0RlM5WE1Rd3pBNzZtY0k5?=
 =?utf-8?B?dmhBVTV2dUxtYm95aXRVNzcyamhqTndhT3l2UmU2TmE4ZVB3b21WOEg2MVBW?=
 =?utf-8?B?Y1RtSXRvMHlKMDBaTVhjMmJWWkhIMzg5eStKT3RmZVV1TzQ4L3lTQk5mb1pv?=
 =?utf-8?B?Sy8xcUhPaEhDTmJwaFN2dm9BQVR3Y1kyTnFzcWMxZExrNlJvS3lmQy9tL3BR?=
 =?utf-8?B?em1jcmkydXRlNndBdHB2TnVCREtpbHFVbUhyTVdaL2dBY0l4SHI4eXFvZDZE?=
 =?utf-8?B?dGVQVzJQUnV4WE5xNUlLemp4d3QwbURZZk9Fb2VlWWY1bUc0clh5UGV2RFkz?=
 =?utf-8?B?TEJqM09Eb3lHVng2Q0lLSFFuZ0RpZ1M4ZEpFdDZ1SjQ5d3d1Y0ZQQWxmV29Z?=
 =?utf-8?B?eFVKc2gxbTJpaEp6TERFbEpGeFBGeEFFeGp6VWZ2VndUaWoxMFR2WVpWMFly?=
 =?utf-8?B?a2xIOVFsS0FqQXFXZEhYcWo2V1FDTDNGMkhGZU5OKzBDYVUwRW0ybEw1ZCt3?=
 =?utf-8?B?SEU4Qk8xcVpISm12L2NBRHBINUN3YU4zdU96MWZqbTdBZTFtNHZ1bGZOSlBv?=
 =?utf-8?B?NTZzd3lqWENJRU9UOEtJQWNCUWFzRlM4Zk0vdFA1V09ucjNaRFhOSEE2RUlF?=
 =?utf-8?B?akUvdkFrSVEwOFVPc09wTDFETnp6aWtrdXdxT0NjY1h6UkxBTER2amt2b0dh?=
 =?utf-8?B?VEYzeG9rNTdkWlFsaGRiQlcwdzFYSFBHRGtXNElUYUFCemdLcWxzVFI5VW5k?=
 =?utf-8?B?aG1xNDJJVG1KNE5xZVVlK0Yxbmk4WDB5czhrbDBoN2N1c3JzR1BTYUNTVHJ2?=
 =?utf-8?B?Qktsa1FJT2xDUnpmTHBvejhxekowQ2xJOEdmYzVmM3VuSTVQVGpZTzFkc1lt?=
 =?utf-8?B?NGUxZGcwd25xb0VrNnl1a0xqYlI4UWFIVU5RWkYyN3JmU0c4VW8rN3JERml1?=
 =?utf-8?B?U20rUWoyRW1DNU4yWVNybUkxNlc5d050UElxSFNNaFZGRnBTNjFJWWJlL2Rv?=
 =?utf-8?B?eHBEWkZuN2JHNXcwazM4bmFyVEF1Rkw0MHp6bkZROERVSlBEYlZ4UHdSUERU?=
 =?utf-8?B?Y3ltUnByRUtibW5oT2ZaNHFmbUlISWtnNElmbDlTbm1Tak5IZ0FuTWtCeWMz?=
 =?utf-8?B?cmdZY1B4c2o2YWVYM1g1NFVGUzZEOVBvcTYyVjhIUUt4cnJURDN6NnVZWGx3?=
 =?utf-8?B?UkZLZmtvdnhzSDR4cTF2dHZRcFZ4bmp1Zkkzd0J1cVlCNlNZQTNwNDZvcEFK?=
 =?utf-8?B?Uk5ENnJ1Y2lZM1JDQlpEOFlaUXJ2WUFBSE9RNU8xQlRvTHdXTVYyL0U0REdI?=
 =?utf-8?B?eThFRjdsVWdhV0JienJhNXJ0Ym5YUVlzZ0d1NEIwdzM4NHdJS216V3FvL3Zu?=
 =?utf-8?B?c3lNMDlaeXhma1lZaHJLc3BNVnBxWWZxRm5SSldiUE5KdU5PbGpiNzhvRURp?=
 =?utf-8?B?QWVkbHlTMWx3Z2lveE5VUzBKOFJURHNyUE9ERVJQdG9Ganh6dkZVYzd1RTh1?=
 =?utf-8?Q?Wdljr4HyJEbPFm440GQ2T+8kpK8ZuU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0hsaVlCTDBCOERWTmg3eXlvTWF6V3FRSXhxM1U4TVB3RUZMUW5aOEp5NnNp?=
 =?utf-8?B?MVRHd3JSdmk2WnpKRTAyU01HdmVzZXVIenc4K1pYUlVzeUtFZGVrSlM5ZUJN?=
 =?utf-8?B?VEVqamhBeEdkN3UrcmN0L2hvTlhNUzFFQ1lXWU1jWVRFUlRNWXN3NW9aYXda?=
 =?utf-8?B?bmhUbUFvQ3NScTF4SDVzSHlSb2JGNVlSMWpxQkJQN1daQTZRU3ExRlFXVXBm?=
 =?utf-8?B?cVV2cnFCL2ZTaEtpeXQxcjcwOWljb3ZTSE8wb3lSNmRlT01iTzdFaVN5am5I?=
 =?utf-8?B?OE9HRWVCOTFCeFhIS2kzL2U0ZGp4ZmdFK1VJOEtmQ2F5U3pjOTNEdWplYW5F?=
 =?utf-8?B?ZkFmRWZvY0VCaHFwQ2EvdHF0TXUvbFRZQ0xiU2JFZnIvbUVwYlo2RFluUFly?=
 =?utf-8?B?MzFsR0ZERURLRjlmV3FNMHZqMG04ejlYdUxqL0RhZWNXaFlIdUNGR1Y1cytr?=
 =?utf-8?B?K2RUc0JiVk5obFJ4QWNoSDAyeTArc3BOZU1EMVIzK0lqVmxPZHF0ditLRVND?=
 =?utf-8?B?VFdoN2lCbWw5L080c3pYcnROYk8rYTk4T2MyejdzNFNQOGJmSGNUTmYxaG5M?=
 =?utf-8?B?b3pDQ0ZCMUhkUElncHFRVkRZcERHa3BhWlhpVDA0VnNKemlJTWxhZXpPOVVE?=
 =?utf-8?B?VURXTnovcFR2OTF3TXJRNTRaV09hczlzMHM0c2JoZk5UVXF5eXFqdHZPOWNr?=
 =?utf-8?B?cWRNZG1rc0h4NGNhQjN1MmU0T21SSHlBNWRZZzRHalRjOWZFQWJ5dWZsRFBw?=
 =?utf-8?B?WEFLQUh4TEtFWEF6emxnU2hnRS92MnhlVFFGU0hxUmdVRFY1MGdnQ2x5aFNH?=
 =?utf-8?B?TG1ZTEFTdzBxRlo1T2dXRjJBSVFmZENqZDlqOFROQkYzeEx5MGpIdkk1K2sx?=
 =?utf-8?B?OVZma2paTDAwdVVrQ1ord0ZoQitpTUxVeHNlN0ZZNDFzVFo4NEZpNDVuUTlm?=
 =?utf-8?B?bUpFdFFPZFdlczJZQzdrR01rdTZLRnZId0hjL2hVSkdpN1dwb1VPUWxNbWdP?=
 =?utf-8?B?Rmhjb3QzeW1iMGRuRXNaVU9vMW84SGJ4S09YTUs2OGw1NXNyWVZqaTA4YjlY?=
 =?utf-8?B?KzV0Sy94QThTdlZiSy9vMXdSSHo2VFRjaU1FMHNraEJhR3YxbWZKaGRKZmgv?=
 =?utf-8?B?b2FsVzRMRHBaL3FFbU1Bc1pxSk9jNzVFTjBGeEkwNzFESk1LRG9rRjNCTllm?=
 =?utf-8?B?MDFMdjNWZTA5Y0dkbG9sazZoM2oyRGlpSVl6b0dRMjdrOTlic3U5YitvT0dV?=
 =?utf-8?B?VUpqbWtqZjk2REI2eDdWd3FoaHFMOStRVnhVWDdzMkdaeFJSVVJ4R3VjTElN?=
 =?utf-8?B?MkpuQTZqc2ROcTRUK0t0VmIzYjNYQUFwaGVwendCaURBQUxkRWdQaHZSa3M2?=
 =?utf-8?B?VFFTRVpTelR5S2lTRlFVS2ZsZE5TeTlkUXNPWSt5bUR6dGdrVitUVG82bDh1?=
 =?utf-8?B?bUZGZC9sSjJRUEdCS3M5SitmNUp3TUZuQ2VkRWpOVUJLbWZ4YmxkZmxsWUJY?=
 =?utf-8?B?UWxZTmh1Z3pWNDlDSDAwQU1kM3JTVFZHbVFhODA3NGNXYnVtMUdHL1JBVWx3?=
 =?utf-8?B?cHJYdTZEYi9yUFhLYVdaU0VUSStPdGNtMUdCeGhiT0J1SU5BWWF0YUhBZ1Jq?=
 =?utf-8?B?a3N0cDVQYzBhOFVTZHlqaWpiSnhpdFBMb3lYQzdkYXh2Tmgzc3d6WXZOU2lr?=
 =?utf-8?B?T3IwQnBlcjBMYWUxcEplYlBCTm5rbjNkek5FQ3hpKzlWTDhSanhjRXZKMnZM?=
 =?utf-8?B?R1dGRzNjWGRZSDdiaW0rdHZMRW5HN3hzN2F2Q05JSFFnUVY1MUducldyUzBw?=
 =?utf-8?B?NUxzY0VHcURha0Y2ZUZBVGZKWDBtanNteHlUZnYvT2RCK3Flb0pYVjlxVXJF?=
 =?utf-8?B?YjN2MmNtSEVndmdRaVVNNm1OK3NBWklhUzh5ZVA5R3ZSR245M2ZkVW1MM0RS?=
 =?utf-8?B?RUdxL29UOElrVUZPbllBTHNMbzJ1MGI4SjVCeTJFdHRLRUpFK2ptWndXcEZV?=
 =?utf-8?B?TDRUakxPZlhDUXdPMkF6bmJ4TCtUcGNOUStYUTNSSmZvVnJGN1VXRmRtZ2R5?=
 =?utf-8?B?VjlYOFZncHUxeStSZnJZVEE3RGtFVHdVNUpnNUxiRkpjMlczMW1EZEpzOXZJ?=
 =?utf-8?B?dXR4VWFNNFFhM3QwMFVSTjFYR2ZzQlVmOWdIT3pLUlpFVmtvSzdGNUE5ZVNx?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5750.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c511af-d2bf-47aa-799d-08dd9767fe6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 06:31:46.1969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z/b5Aojr7lVf4DUQYfBJhXwSzjPu6BkC9lretKpI1gcIFynB/S8uk5T6AwWjcA2aFTz+muPTip/YYc2po3Sspzup8Z3J754yJcFDcn3LGio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6927
X-OriginatorOrg: intel.com

ID4gKy8qKg0KPiA+ICsgKiBzZ3hfdXBkYXRlc3ZuKCkgLSBBdHRlbXB0IHRvIGNhbGwgRU5DTFNb
RVVQREFURVNWTl0NCj4gPiArICogSWYgRVBDIGlzIGVtcHR5LCB0aGlzIGluc3RydWN0aW9uIGF0
dGVtcHRzIHRvIHVwZGF0ZSBDUFVTVk4gdG8gdGhlDQo+ID4gKyAqIGN1cnJlbnRseSBsb2FkZWQg
bWljcm9jb2RlIHVwZGF0ZSBTVk4gYW5kIGdlbmVyYXRlIG5ldw0KPiA+ICsgKiBjcnlwdG9ncmFw
aGljIGFzc2V0cy5zZ3hfdXBkYXRlc3ZuKCkgTW9zdCBvZiB0aGUgdGltZSwgdGhlcmUgd2lsbA0K
PiANCj4gSXMgdGhlcmUgc29tZXRoaW5nIHdyb25nIGhlcmUgaW4gdGhlIHRleHQ/IEl0IGxvb2tz
IG1hbGZvcm1lZC4NCg0KWWVzLCBzb3JyeSwgbG9va3MgbGlrZSBjb3B5LXBhc3RlIGVycm9yIEkg
bWlzc2VkIGluIHRoZSBjb21tZW50LiANCldpbGwgZml4LiANCg0KPiANCj4gPiArICogYmUgbm8g
dXBkYXRlIGFuZCB0aGF0J3MgT0suDQo+ID4gKyAqDQo+ID4gKyAqIFJldHVybjoNCj4gPiArICog
MDogU3VjY2Vzcywgbm90IHN1cHBvcnRlZCBvciBydW4gb3V0IG9mIGVudHJvcHkNCj4gPiArICov
DQo+ID4gK3N0YXRpYyBpbnQgc2d4X3VwZGF0ZV9zdm4odm9pZCkNCj4gPiArew0KPiA+ICsJaW50
IHJldDsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJICogSWYgRVVQREFURVNWTiBpcyBub3QgYXZh
aWxhYmxlLCBpdCBpcyBvayB0bw0KPiA+ICsJICogc2lsZW50bHkgc2tpcCBpdCB0byBjb21wbHkg
d2l0aCBsZWdhY3kgYmVoYXZpb3IuDQo+ID4gKwkgKi8NCj4gPiArCWlmICghWDg2X0ZFQVRVUkVf
U0dYX0VVUERBVEVTVk4pDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJZm9yIChpbnQg
aSA9IDA7IGkgPCBSRFJBTkRfUkVUUllfTE9PUFM7IGkrKykgew0KPiA+ICsJCXJldCA9IF9fZXVw
ZGF0ZXN2bigpOw0KPiA+ICsNCj4gPiArCQkvKiBTdG9wIG9uIHN1Y2Nlc3Mgb3IgdW5leHBlY3Rl
ZCBlcnJvcnM6ICovDQo+ID4gKwkJaWYgKHJldCAhPSBTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkp
DQo+ID4gKwkJCWJyZWFrOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBTVk4g
ZWl0aGVyIHdhcyB1cC10by1kYXRlIG9yIFNWTiB1cGRhdGUgZmFpbGVkIGR1ZQ0KPiA+ICsJICog
dG8gbGFjayBvZiBlbnRyb3B5LiBJbiBib3RoIGNhc2VzLCB3ZSB3YW50IHRvIHJldHVybg0KPiA+
ICsJICogMCBpbiBvcmRlciBub3QgdG8gYnJlYWsgc2d4Xyh2ZXBjXylvcGVuLiBXZSBkb250IGV4
cGVjdA0KPiA+ICsJICogU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZIGVycm9yIHVubGVzcyB1bmRl
cmx5aW5nIFJEU0VFRA0KPiA+ICsJICogaXMgdW5kZXIgaGVhdnkgcHJlc3N1cmUuDQo+ID4gKwkg
Ki8NCj4gPiArCWlmICgocmV0ID09IFNHWF9OT19VUERBVEUpIHx8IChyZXQgPT0gU0dYX0lOU1VG
RklDSUVOVF9FTlRST1BZKSkNCj4gDQo+IAlpZiAocmV0ID09IFNHWF9OT19VUERBVEUgfHwgcmV0
ID09IFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSkNCg0KT2ssIGJ1dCBJIHdpbGwgaGF2ZSB0byBj
aGFuZ2UgdGhpcyBhbnlob3cgc2luY2Ugd2Ugc2VlbXMgdG8gdHJlbmQgdGhhdCB3ZSB3YW50DQp0
byByZXR1cm4gLUVCVVNZIHdoZW4gU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZIGFuZCBkbyBub3QN
CnByb2NlZWQgd2l0aCBvcGVuKCkgY2FsbC4gDQoNCj4gDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4g
Kw0KPiA+ICsJaWYgKCFyZXQpIHsNCj4gPiArCQkvKg0KPiA+ICsJCSAqIFNWTiBzdWNjZXNzZnVs
bHkgdXBkYXRlZC4NCj4gPiArCQkgKiBMZXQgdXNlcnMga25vdyB3aGVuIHRoZSB1cGRhdGUgd2Fz
IHN1Y2Nlc3NmdWwuDQo+ID4gKwkJICovDQo+IA0KPiBUaGlzIGNvbW1lbnQgaXMgbGlrZSBhcyB1
c2VsZXNzIGFzIGFuIGlubGluZSBjb21tZW50IGNhbiBldmVyIHBvc3NpYmx5DQo+IGJlLiBQbGVh
c2UsIHJlbW92ZSBpdC4NCg0KSXQgaXMgYWN0dWFsbHkgbm90IHF1aXRlIHNvIHVzZWxlc3MgYmVj
YXVzZSB0aGlzIGlzIHRoZSByYXJlIGNhc2Ugd2Uga25vdw0KdGhlIEVVUERBVEVTVk4gYWN0dWFs
bHkgZXhlY3V0ZWQgYW5kIGhlbmNlIHRoZSBwcl9pbmZvIGFsc28gYmVsb3cuDQpXaXRob3V0IHRo
aXMsIHRoZXJlIHdpbGwgYmUgbm8gd2F5IGZvciBzeXNhZG1pbiB0byB0cmFjZSB3aGVuZXZlciBD
UFUNClNWTiB3YXMgdXBncmFkZWQgb3Igbm90IChTZWFuIG1lbnRpb25lZCB0aGF0IHRoaXMgaXMg
YWxyZWFkeSBwcmV0dHkNCm9wYXF1ZSB0byB1c2VycykuIA0KDQo+IA0KPiA+ICsJCXByX2luZm8o
IlNWTiB1cGRhdGVkIHN1Y2Nlc3NmdWxseVxuIik7DQo+IA0KPiBMZXQncyBub3QgYWRkIHRoaXMg
ZWl0aGVyIGluIHRoZSBzY29wZSBvZiB0aGlzIHBhdGNoIHNldC4NCg0KU2VlIGFib3ZlLiANCg0K
PiANCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArCX0NCj4gDQo+IFNpbmNlIHlvdSBwYXJzZSBlcnJv
ciBjb2RlcyBhbHJlYWR5LCBJIGRvbid0IHVuZGVyc3RhbmQgd2h5IGRlYWwgd2l0aA0KPiB0aGUg
c3VjY2VzcyBjYXNlIGluIHRoZSBtaWRkbGUgb2YgZG9pbmcgdGhhdC4NCj4gDQo+IE1vcmUgY29u
c2lzdGVudCB3b3VsZCBiZSAobm90IGFsc28gdGhlIHVzZSBvZiB1bmxpa2VseSgpKToNCj4gDQo+
IAlpZiAocmV0ID09IFNHWF9OT19VUERBVEUgfHwgcmV0ID09IFNHWF9JTlNVRkZJQ0lFTlRfRU5U
Uk9QWSkNCj4gCQlyZXR1cm4gMDsNCj4gDQo+IAkvKg0KPiAJICogRVVQREFURVNWTiB3YXMgY2Fs
bGVkIHdoZW4gRVBDIGlzIGVtcHR5LCBhbGwgb3RoZXIgZXJyb3INCj4gCSAqIGNvZGVzIGFyZSB1
bmV4cGVjdGVkLg0KPiAJICovDQo+IAlpZiAodW5saWtlbHkocmV0KSkgew0KPiAJCUVOQ0xTX1dB
Uk4ocmV0LCAiRVVQREFURVNWTiIpOw0KPiAJCXJldHVybiByZXQ7DQo+IAl9DQo+IA0KPiAJcmV0
dXJuIDA7DQo+IH0NCj4gDQo+IFRoaXMgaXMgaG93IEkgd291bGQgcmV3cml0ZSB0aGUgdGFpbCBv
ZiB0aGlzIGZ1bmN0aW9uLg0KDQpJIHRoaW5rIGV2ZXJ5b25lIGFscmVhZHkgcmUtd3JvdGUgdGhp
cyBmdW5jdGlvbiBhdCBsZWFzdCBvbmNlIGFuZCBubyBvbmUgaXMNCmhhcHB5IHdpdGggdGhlIHZl
cnNpb24gZnJvbSBwcmV2aW91cyBwZXJzb24gKSkgDQpMZXQgbWUgdHJ5IGFub3RoZXIgdmVyc2lv
biBhZ2FpbiwgdGFraW5nIGludG8gYWNjb3VudCBjaGFuZ2VzIGluIHJldHVybiBjb2Rlcw0KZGlz
Y3Vzc2VkIGluIHRoaXMgdGhyZWFkIGFsc28uIA0KDQpCZXN0IFJlZ2FyZHMsDQpFbGVuYS4NCg==
