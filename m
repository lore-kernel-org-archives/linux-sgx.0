Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACDF2701B6;
	Tue, 20 May 2025 10:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747737786; cv=fail; b=RLTKWOcvLXpyGjN/PDdB4hDja2ikKpJMgLWoCTJMOzIDcvQcN+3g4owqPxkjx5zb6/Pvr2wZ5i7NQGrEgHMmQiM73VsVs3bTxJxtZtsTeeDPq0VT396WiWtPL3ak5lcSukO1jYj99f/iFHOpwKYQUZO58X0qAqYVlQ7S66jked0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747737786; c=relaxed/simple;
	bh=qZ1PPKXDd1vsh2y17ZEMGDFt1RSRf9E2v9CAeLzsvYk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bFvDLLEBFSVTiTdYmi3lO5VjoFsh/nZKEtfz6zeUzIo/XGL8yC/++L+ThS73a6yKR3S9+ahkVnkij5IOPQZ1YCNx5DjFY5WHcHA+NI2dw4HucdBfnnY9jeThc373D17cW4GDkFyCxlvkriWsShuUoFosRkNpjj2nd6InHsx5qqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n+ZkqJab; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n+ZkqJab"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747737783; x=1779273783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qZ1PPKXDd1vsh2y17ZEMGDFt1RSRf9E2v9CAeLzsvYk=;
  b=n+ZkqJab7UFy+i+9gHi/rpRVTUFmn2Ni2nT+GZGrT9etYI0NXEBifnz8
   67AqL/lAyFIlzjQ9/F6L9tixoNKdloAjBqLq7n6rfOY1mCyLRqYaPyymV
   ghbiDZxYtur3SYxxQr2NMyC5M+PVYdcqYvunvurIYSRc8t+SEOh0vjEwr
   Dw+3heGBj87l93EF4+WWw7oyiQOH2ypxOW8xDrNtiQB4FJBY70pidyvuR
   0Vw+GAspqBKEib0hobqqoBF8UwSw9f9SfiRX4gVVK+Q5pZ26V9YCxZlZI
   L7m+/bZ5UUjDBxjyph2+iJz2BdAeXwdXId/aXVJhK7fhg/riOwZZXv0CN
   A==;
X-CSE-ConnectionGUID: NH+pbRhETMieO0tYIGqB9A==
X-CSE-MsgGUID: 56krcU4FSeWb+Q73bTqIPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="60323314"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="60323314"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:43:03 -0700
X-CSE-ConnectionGUID: Z3VwXxILQAWKU1HMpA73kA==
X-CSE-MsgGUID: LOxPWqiyTOiQanHL15CtpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="140188342"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:43:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 03:43:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 03:43:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 03:43:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=byVX9v9LnTOcwqVEVUn8jcJ1o5aKYOKn3dGw9+ZNS4EmH9G4YBQmZBnkh0Hs2gx6zLNZTO24VX3kqdwbaOnvxxTwpUaAMY4VOMMNZfjq1+TajCme9O8VQiH1kkndGfv0+q8YKRSxrtxFCyCSWfkuc+NnZf+eB0YjOhIIozT0KIj/YM7jnfJWtPNjryeny8UaJCiBn+UfxXmh2iq5h04GSNdkdwma2sRfZjLf+P7PBxAz6yCSRk34YwnlvKCtebbhSFd/iL1uWihPDXJqzV/89ew1e94PzvlWg9CRLxkIuzN2TaKiRncoB/vcfJ4vmX7Wya5YCNhslUD5iw2pif2rHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZ1PPKXDd1vsh2y17ZEMGDFt1RSRf9E2v9CAeLzsvYk=;
 b=c4JT21mZ6X41rO3vi8sr9FZjI/O9lLJ9+VAb+ezWOTmLbe7TLVOPDi6e+GUZ/rlFJOewuGScKvHMgqzkxUwLmXkjZ95BMT9JtSDxSVlhepz8x93vFi9pXkKSHZLTGDjB/tshlZY5GEthjiZmxzVuXIVdc5LheTBPejVP2oievN1ufiVlyhs4dftXyYFb3YURYNIz6Sy4MCSO1Hy07sRR4RbsE6gJAngAk4/vPo8a7ADZHUTI1j2y8xU2S2xIIJVaauYAhgE14zHBYEqCjMglURPVE34NnRF6aT8FNZwT1UljdofjlQfE9N5o9Jdn/TMitiGzd7diisdDffgrN2gAHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by SA1PR11MB6967.namprd11.prod.outlook.com (2603:10b6:806:2bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Tue, 20 May
 2025 10:42:58 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::53fb:f921:ce74:2045]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::53fb:f921:ce74:2045%5]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 10:42:58 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Raynor,
 Scott" <scott.raynor@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Mallick, Asit
 K" <asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Cai,
 Chong" <chongc@google.com>, "bondarn@google.com" <bondarn@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: Re: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHbyI9nK0GX+MCyyECBUnY05vaI+bPZ0mWAgAACboCAALmIgIAAg5UAgABE0wA=
Date: Tue, 20 May 2025 10:42:57 +0000
Message-ID: <510db3c8fbf8a5e2c7687427438ad6110d46cf0a.camel@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
			 <20250519072603.328429-5-elena.reshetova@intel.com>
		 <990841309a27d4f3e7c53b44d7cce0e555594a21.camel@intel.com>
		 <DM8PR11MB5750CC5686E413A88CF41D7DE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <0c2f968860af68e65cebaf4f99a764d28e8a1030.camel@intel.com>
	 <DM8PR11MB5750A36D0EC47701322E0683E79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750A36D0EC47701322E0683E79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|SA1PR11MB6967:EE_
x-ms-office365-filtering-correlation-id: 46f0bdd5-8e50-4e3f-0304-08dd978b15de
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a0ErSGxLTVdXYWRtWGRmMmxYR0M1VGZjWjJUZExBcjZwcmgxQ3lsNTRZUmQy?=
 =?utf-8?B?QkNpWkgxMGFleVJSbFFCOEFiWEZudzdVcDJJUXBuanFSWlNTeS9YVG5Kb2tu?=
 =?utf-8?B?Y0pWVWQ3ZkZYTFR1eTBEdzc5ckJMY1M3dlJUZUt4Tkg3RFNJc2c1VklvQVlF?=
 =?utf-8?B?d0pTNnorN0lwNEU0d3BWNGRjbXpNU244Tm5xbDFpYWgrMCtKcy8zZnhsZ0Jp?=
 =?utf-8?B?blo3N2lXZ2NDd1VVaUV3a09YUUpSWnNTd2w4aEUwRWZPOXNiWW5aN1VTTWll?=
 =?utf-8?B?dDJaZ1BmOWF4RE1xK3FTR290T2VyRUNBejdxTDU3dWNOMThjYUVSWDIrcTV1?=
 =?utf-8?B?Y1E3Zzk2a2lqK2lIZExlWmJKdEg2aHJjYzdTMlRCVS9GL2NPdVpOYWVzVXAz?=
 =?utf-8?B?TEloRVlCRWQ3VGdIT0I0ZGdraEQ3SjNOemJYaC9mcENMNlJqeWVMTGdGbnQ1?=
 =?utf-8?B?NitrZXZieUxkclRBTTZ0aHp4eWR1dXR5Z3hMdmZoYSt0U2llTHZpOWI4cDVC?=
 =?utf-8?B?dlNaN3N1VEJSWDhJczNWZGtkMUY4d29tSGhleUtFNm5DQlFZZ0lKOG9iRmYy?=
 =?utf-8?B?TEpERHNBOUk2RVExNFczQ2x5VEdlNE9TWCtlZnlVUG1BdWRDQUwvaXdScXVW?=
 =?utf-8?B?dGg1bldLVk8zTDdWcUs2NlBpRTV5ZHVSMnVwTnovaU1lbmxzZytnekJ0SWxm?=
 =?utf-8?B?eGsrYldNZ20xNHNFUVFveG9hWndLMFd4bndWNnVUZ044bjhUbTZFVjg4b2tt?=
 =?utf-8?B?NU95MXZKcG5nQlM1Zk9LRkVZZ3hsZkgrNUYyYS9haHpoR1JwMXZyTk1rNVRM?=
 =?utf-8?B?Q3pwVU5paTNHR0ttcVJSQ1dHZFdwYkNBYmJIc1VoKzM5OGx3NkE3bmRBcURN?=
 =?utf-8?B?aE1ub2hYS1U5RmR2Rk05MFpxTjR0VWt1MDhibjdxUHU1QnlBTW5GcVZGbFMv?=
 =?utf-8?B?U3d1TUNEUnUzbGUxTDJkL0h4bitqMURsYlJvdU9YNkU2VjhCMzg3MTlseW84?=
 =?utf-8?B?VUhQZzNBbmxIYmJZb0RDMTNzdGtWbW9jeXZDaHIxZ3oyYmlSK3NrM1MrNE9G?=
 =?utf-8?B?M3hXVi9wcklMS2VDalA0UFFseGEwdks3RWRiMEhOcTJpbDlJTW1XejZ1aGhD?=
 =?utf-8?B?aGllMmlnWVp4dGlmZGxuNGhqNVk2T0VydDhQY0xmSFZUNVdycmdrRVV3YlhY?=
 =?utf-8?B?WTZDTC9GemNDcEkvNXZPd0VnRXVKc2MwRTBlcDRLWjdlNnN4dTNDeXh6ajVD?=
 =?utf-8?B?Sk4zbkpqUkkvZmFMUkR2eFp2Z2c3OXJ3bHBxeTVtd0d3RE9JWHk3eFBEdDdq?=
 =?utf-8?B?UWlFZW94YjNJb3MwUkE2SGl2NWgzVG84WGtSdkp0ejlkQVRiK3NISkpPNUxl?=
 =?utf-8?B?ZjZyMlcvbXB5SWFkTDFBMzdqZ1pLTGpBdEFSTm1tOXNnRnY3OFZCS29kU0Qz?=
 =?utf-8?B?Q0FITmNsR09RUytRWktmU2ZSallQUVJhaFVQY2RKM25HS2E0cGFIcVZUcmpj?=
 =?utf-8?B?UXRBamNLTFpYaCtOT0JUMlM5VXpxU0pXK1FpalRIQW5nM3dRYVNtb2tKc1lO?=
 =?utf-8?B?U3RlTnVrRjBucTdYRERKTGNsTGs4ZlJrcFJlNzdYSHByQnUwYW0zVUMxZTdV?=
 =?utf-8?B?YlhmeHJXVFhXa3o5ZVlGSmdhZExsd0E2dDJWQnluTFVBWmhDdk5wM2lBNHlL?=
 =?utf-8?B?KzlWdko5S1lzMTg2YkZiTjQySk1uWnJYY24vcSsyQmZidGRHOFFRcHJyRkFt?=
 =?utf-8?B?VWZjYUM0YUZGVEI4N0dyVkdzalRYV3Bjdlkwb0VjNm1RNnBEdzVWRUdVYjg2?=
 =?utf-8?B?YjlpVXQ0RmI1Q0xUTHJOWTlmcUxNSy9Oc1N0QWkrOUszbExHOWg3ZmkxeWdw?=
 =?utf-8?B?UUgvU3dVaFZFVGNSOFBiaU90WnNpOHVPK1NJZ1RiTFhQNU1xQ3lxMWxGY282?=
 =?utf-8?B?aHo0UmhyQXhCM0JuRW9TUVZOZ0l5UWNXTHFWVDlhQm1nSUgvdU1lV2E0bnFG?=
 =?utf-8?B?ckVvaTljSUFBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3ZUVWJkczk1enBxV2U2VjRuc1I4ZVhaMHJhL3orRlF2eHBheFQ5RldELzBT?=
 =?utf-8?B?aVNBUk9BTG1Ib0ZFU1J4dmVsdDlUc3QwM3c4S2NocnM2Q3lQMTNYcDVVeDho?=
 =?utf-8?B?MWR6bmhVanErdk1pM2U5RWdNQ1F4anlGOG1uSHdtQU1CYjVFS0E4NU11dUpm?=
 =?utf-8?B?K2cwK3FnaE5xWktSM0s0bXIxSjNHaUlkSHpqUUxmL09oNndBR2IxcVRmejVo?=
 =?utf-8?B?TStKdlVhNVpIQXdLTmVEcEVQRzBFUDg4eWMvYkd3OFI5VWE2MVhtaGlzTzdP?=
 =?utf-8?B?bk5mWE1PMzlPUVRvTGQ5SGhwK1NPSzFiZFpQWHhYTVhidlZmdlRqVHQ0QUJT?=
 =?utf-8?B?NURSWGRNUmRudlBqZTY4ZWtMUXFjU2R1bXlHMkZzREUxdlR6WWVHYzlKU0RQ?=
 =?utf-8?B?cnIxN2h1dFJsTUtneEd0M1FubDltS0J2T2ZiYVVCUWtsMmZ0YzhzN3g2dzRn?=
 =?utf-8?B?VWlWNm1yVmlleTVxb1NtTmd5elBIV2xCRk8zM3hBOXpDdEJ5emxwTDNEZkti?=
 =?utf-8?B?dDdjSFpSODRDczdJZUpodzROa0FKZkwvbG52MFMyUzNBakRRS25jaytHeU5C?=
 =?utf-8?B?dHVNaGVVcnpzeWhHZ1hYbHVtRkRMVXlXM29iSkszT00rd0Q1b2xyNk9GaVpp?=
 =?utf-8?B?OHJaZVo1SVkyYldMcTZrdnVjb2p0M1RqMElMVGxZaTZFYzNaNWhvR3ZGNG92?=
 =?utf-8?B?THpuVUNJV2ZCR3lrVnVsVndESW9yODNxaTlteUpIUDArb2piOW5GQTNGbzBE?=
 =?utf-8?B?M1NobGNjRUVRSHJXenhndWl1Vks0Mjg3aVY3VlhrRUhCTnZhQnMrck82SVJk?=
 =?utf-8?B?S3R0UXhaVUI5MTVzZFRNcGRVTk5IbjhEOWlsL2dKN0pyODBJd0VSQTdRVHZk?=
 =?utf-8?B?ODFqWCtybHRVZXFyak9NZ3luS0dOWk9QdjVIekRFTlVyVmc2TnVjcnRmQncx?=
 =?utf-8?B?Mk1LUEY5aStqTnRpRWpHVEkrdUhtRkE5RGc4UFhjRHgrQjJKOTB3SkRGd3Nj?=
 =?utf-8?B?QWFzOFlWK3c4TmxEOVQvWW9LMzJjaERhK2NucWZNcFZJRE1uYnpQdk9DNG5P?=
 =?utf-8?B?LzkvTGYxNGR5eTM3cVdGMFFJcEFnQ2VVMHgvc1RFdlUyM3hFcUF3U01sSTZy?=
 =?utf-8?B?YTBYbHRjRy9jQnkyb1c3VkZnRlJFVkxZb0NHSlZRQ1FjRHpDaExrN0dNN3Z3?=
 =?utf-8?B?Mk84SFdvYWlzZ2JNMi83NjNiWmFSMkQvMHRVYVc2ZnNHQjFWR1hsN1BMNUFR?=
 =?utf-8?B?Y3NWYnUwTG4zallUYUttdTNWMnJMVjQvRTV2NVpSSzZlT1hFWm1BbDVncHRP?=
 =?utf-8?B?eXhpb2htby9aT2xLMGwrN3hGZ1RXdENRMTlHUjA5bUdRUnB4Ukttd2w3b0c5?=
 =?utf-8?B?cmxFOUVEVXpKZ0lZTUpHaVV3dnpIQWRMdGZMbDJscU5RRFQ3TjgxVTQwbDdS?=
 =?utf-8?B?MzFjamJSRVNUSnZrVnRYVTl3N2lZa3pkcGV5Q0U3VWp1bktxdkkvTmNuNUUx?=
 =?utf-8?B?S2c0c0crTThyZFVySHBzQWpNdlBGWmQvblVrT0xPWWp6cHdDTEVEQjJRRTMw?=
 =?utf-8?B?dlFvU3l1T0V3NjBoWThSM1dqbjErb0pheG9kdEJtaytJZDlBSkRuRi9jN1FL?=
 =?utf-8?B?S0Z2TXUvZ3ZuS2tUUnRjR0Vya1BOQWtRQThDK090Y3ZiY3BhcUtONHg4bVBl?=
 =?utf-8?B?ZHArdXdHem5JRFRmQXdjU1p0UGxmTmZZUDZVY1Y3bmY2M09GTmc4OWRRaDVC?=
 =?utf-8?B?RklhVGN1MzFjd2ZpaUhlM1Z0OGFDb2VlYk9ZRng3d0pYbjZ1ckt0Q2txVmh4?=
 =?utf-8?B?NEdpT2o0dnNoeEhUcm1PenVUR0VWTWRqUDNXdy9Wb1c2SUFLRWQzZ0c4czJu?=
 =?utf-8?B?NWNHT1V4T0FYYzZMOGxlNFh2VUFDakFZN2pnZlhYTmlRdHdZbFQzV2RtcWVL?=
 =?utf-8?B?bHdkUkdxcElSeFdWV3NGRHMveW1hSDVaeFUybVpZMlppbjRvRXZOL2l2SFZr?=
 =?utf-8?B?bjhNQm9rSDBSTDh4ejhRdVVTdDQwVmN1MXZwZW5yVEsyRHFlTmdBQ1pHakkz?=
 =?utf-8?B?REZZazczNmQ1OXpETU5GSzZtU1JYTyt3azgwNC8raFloTHpDZnJ6bVh1akRq?=
 =?utf-8?Q?j8h27gjHzUAr7ht2R3msyDIjX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <137A7CD825054647989606130D6EF897@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f0bdd5-8e50-4e3f-0304-08dd978b15de
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 10:42:57.9045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cwHh43114sIG8ZFv4Qdg2cYZNvdyRn3WnFgI17VrLlyTCfaI8Sy57LjwiIyJ2w9mq+FtE6PtEXBFjl9YQ/p97Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6967
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTIwIGF0IDA2OjM2ICswMDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3Rl
Og0KPiAgPiA+DQo+ID4gPiA+IFdoeSBub3QganVzdCBmYWlsIHNneF9vcGVuKCkgKGUuZy4sIHJl
dHVybiAtRUJVU1ksIG9yIC1FQUdBSU4pIGluIHRoYXQgY2FzZT8NCj4gPiA+ID4gVXNlcnNwYWNl
IGNhbiB0aGVuIHJldHJ5Pw0KPiA+ID4gDQo+ID4gPiBUaGUgaWRlYSBvbiB0aGUgcGF0Y2ggd2Fz
IHRoYXQgc3VjaCBhIHNjZW5hcmlvIHdoZXJlIHdlIHJ1biBvdXQgb2YgZW50cm9weQ0KPiA+ID4g
c2hvdWxkIG5vdCBoYXBwZW4gaW4gcmVhbCBsaWZlIHVubGVzcyBSRFNFRUQgaXMgdW5kZXIgc3Ry
ZXNzIChpbiBjYXNlIHdlDQo+ID4gPiBhY2NpZGVudGFsbHkgY29sbGlkZWQsIHdlIGRvIGEgMTAg
dGltZSByZXRyeSkuIFNvLCBpbiB0aGlzIGNhc2Ugd2Uga2VlcCB0aGUNCj4gPiBsZWdhY3kNCj4g
PiA+IGJlaGF2aW91ciwgaS5lLiBwcm9jZWVkaW5nIHdpdGhvdXQgRVVQREFURVNWTi4gQnV0IEkg
Y2FuIGNoYW5nZSB0byB0aGUNCj4gPiBhYm92ZQ0KPiA+ID4gbG9naWMgdG8gcmV0dXJuIC1FQUdB
SU4gaW4gdGhpcyBjYXNlIGlmIGV2ZXJ5b25lIHRoaW5rcyBpdCBpcyBhIGJldHRlcg0KPiA+IGFw
cHJvYWNoLg0KPiA+IA0KPiA+IFdlbGwgSSB0aGluayBJIGFtIHNlZWluZyBjb25mbGljdGluZyBt
ZXNzYWdlOg0KPiA+IA0KPiA+IFlvdSBtZW50aW9uZWQgaW4gdjQgdGhhdCBzb21lIHNpbXBsZSAo
dXNlcnNwYWNlISkgdGVzdHMgY2FuIG1ha2UNCj4gPiBFVVBEQVRFU1ZOIGZhaWwNCj4gPiAicmVs
aWFibHkgYW5kIHF1aXRlIGVhc2lseSBldmVuIHdpdGggMTAgdGltZSByZXRyeSBsb29wIGJ5IGtl
cm5lbCIuICBUaGlzIHNlZW1zDQo+ID4gdG8gbWUgdGhhdCAiUkRTRUVEIGlzIHVuZGVyIHN0cmVz
cyIgY2FuIGNlcnRhaW5seSBoYXBwZW4gaW4gaW4gcmVhbCBsaWZlLg0KPiA+IA0KPiA+IE9yIGFy
ZSB5b3Ugc3VnZ2VzdGluZyB0aGF0IGtpbmRhICJzaW1wbGUgdGVzdHMiIGNhbm5vdCBoYXBwZW4g
aW4gcmVhbCBsaWZlPw0KPiANCj4gWWVzLCBvbmx5IHVuZGVyIGV4cGxpY2l0IGF0dGFjay4gDQo+
IA0KPiA+IA0KPiA+IEV2ZW4gd2UgYWdyZWUgdGhhdCBzdWNoIHRlc3QgY2Fubm90IGhhcHBlbiBp
biByZWFsIGxpZmUsIHNpbmNlIHVwZGF0aW5nIFNWTiBpcw0KPiA+IGFib3V0IHNlY3VyaXR5LCBJ
IHRoaW5rIGl0J3MgcXVpdGUgZmFpciB0aGF0IHdlIG5lZWQgdG8gY29uc2lkZXIgdGhhdCB0aGUN
Cj4gPiBwbGF0Zm9ybSBpcyB1bmRlciBhdHRhY2suDQo+ID4gDQo+ID4gQWxsb3dpbmcgZW5jbGF2
ZSB0byBiZSBjcmVhdGVkIHdoZW4gRVVQREFURVNWTiBmYWlscyBkdWUgdG8gcnVubmluZyBvdXQg
b2YNCj4gPiBlbnRyb3B5IGlzIGEgY2xlYXIgdmlvbGF0aW9uIG9mIHNlY3VyaXR5IHRvIG1lLiAg
QW5kIHdoYXQncyBldmVuIHdvcnNlIGlzDQo+ID4gQUZBSUNUDQo+ID4gdXNlcnNwYWNlIGlzIG5v
dCBub3RpZmllZCBhYm91dCB0aGlzIGJ5IGFueSBtZWFucy4NCj4gDQo+IFRoZXJlIGlzIG5vIHNl
Y3VyaXR5IGlzc3VlcyBzaW5jZSB5b3UgY2FuIGFsd2F5cyBzZWUgdGhlIENQVSBTVk4gdmlhIHRo
ZQ0KPiByZW1vdGUgYXR0ZXN0YXRpb24gcHJvY2VzcyBvZiB0aGUgZ2l2ZW4gZW5jbGF2ZSwgc28g
eW91IHdpbGwga25vdyBmb3Igc3VyZQ0KPiB3aGF0IG1pY3JvY29kZSB5b3UgcnVuIHdpdGguIA0K
DQpSZW1vdGUgYXR0ZXN0YXRpb24gY2FuIGNlcnRhaW5seSB0ZWxsIHRoZSBjaGFsbGVuZ2VyIHRo
ZSBlbmNsYXZlIGlzIHN0aWxsDQpydW5uaW5nIG9uIGEgY29tcHJvbWlzZWQgcGxhdGZvcm0sIGJ1
dCBJIHdvdWxkbid0IHNheSB0aGVyZSBpcyAqbm8qIHNlY3VyaXR5DQppc3N1ZXMuDQoNCkUuZy4s
IHRoZSAiY3J5cHRvIGFzc2V0cyIgdGhhdCB0aGUgRVVQREFURVNWTiBmYWlscyB0byByZS1nZW5l
cmF0ZSBtaWdodCBoYXZlDQphbHJlYWR5IGJlZW4gbGVha2VkIG9uIHRoZSBjb21wcm9taXNlZCBw
bGF0Zm9ybS4gIElmIHdlIGFsbG93IGVuY2xhdmUgdG8gcnVuLA0KdGhlIGF0dGFja2VyIG1heSBo
YXZlIGNoYW5jZSB0byBzdGVhbCBzZWNyZXRzIHRoYXQgYXJlbid0IHJlbW90ZWx5IHByb3Zpc2lv
bmVkLg0KDQpZb3UgbWF5IGFyZ3VlIHRoZSBlbmNsYXZlIHNob3VsZG4ndCBoYXZlIGFueSBzZWNy
ZXRzIGJlZm9yZSBpdCdzIHZlcmlmaWVkLCBidXQgSQ0KdGhpbmsgaW4gcmVhbCB3b3JsZCBpdCBt
YXkgbm90IGFsd2F5cyBiZSB0aGUgY2FzZS4NCg==
