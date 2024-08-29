Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2F85588E;
	Thu, 29 Aug 2024 07:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724917667; cv=fail; b=ZpiMZNGxR1BFyKqJeWPz2aq4N+6GPuyiS24gMRhR3S0gKm/fCkbReTwtJcDmjHIuhWnwDpWXSr8JhCSYjh146KnPM8DsnsJq8ZdOAkrqfYc8BSrqP0CrVUEn5G/f/Y6gUpaTajyjVZldqZZdN09tubdk+yY74/XUKi1N+15T6dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724917667; c=relaxed/simple;
	bh=0jTCOUHttVnLGnFcKvJpzQLmV0Wey9Coi0+Hz2SdiRw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uoGQlt7i5xy7OAYK8KLuH7WdWIWyc4H7oWLPWzOPGP0cC7Br8Nf/0kUGGTiEuE86rQiJnEhIcOdzhIM9gkd5G2JSlzInHUXM+T/tKksfcm5WJF2XdvUeGrP05tfJhkc9MWqBGZT2/4DNbRvgAs6EtBCu/kOwWUNk4aMOwdPUc14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FxC+5SNp; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FxC+5SNp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724917666; x=1756453666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0jTCOUHttVnLGnFcKvJpzQLmV0Wey9Coi0+Hz2SdiRw=;
  b=FxC+5SNpFGk2w5lyq0stY8FfpBlkYHkQCoiIIcKkkaRnzOU3mK83X+bz
   gTpaeAot1kAldE8u/Ki8nD/nHQuKoUAev4O4O0iMJC8W2gl40D9u6dSzu
   2Wdjq+j5pmFfZSXakFhgZfxht7fyTJakb2D1QbctvmkIZwqF5zroohhS3
   t+8CkmCM5wR1dcOr1at1so6Hq4Fols3oAMrIv0y9C8V1/7NuV3haH6ZZs
   MVQmsLx1eYHborbbqUvl/DW/tuy7VOonLiLbxhOkT3IEuNjPVV6ins9Td
   Un2N9OHI7w5bpmXOL2eTmnWxkCY5W3Vyau4jMNnofHRDu8q7j8LlIep+9
   A==;
X-CSE-ConnectionGUID: IV1Zv5L8QbaPSnwh7CyCmw==
X-CSE-MsgGUID: 8ShPKzMPQFaV0KioEwDDJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="23375531"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="23375531"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 00:47:46 -0700
X-CSE-ConnectionGUID: 0+SGF/+PT2SI13VUTyBjXA==
X-CSE-MsgGUID: x5Xh4qlFQXK28E9VJbzNfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="67856158"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 00:47:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 00:47:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 00:47:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 00:47:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 00:47:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H+sbF+QZS8R64o36JrA65iHY+hxxS2+pPD/ODzHwG2BEN6BYHopx75EgsfWEYaS6ND8421HLr+C///DNbY/Tv26YQ9ctLov3J3HdeVa5PeiAr3VGiRFkxUBPRU9JORa4hkAPaoXag1jN0DnFsOEZLSIE1v36tp1+CqURdRpGO3DgXORi/2bx5SnwEDdBs1d1IKe/WGOANRqY2+5GpVr1mDmYl+RQ17sLlyaxI/6IE20Qe5qqN6J+4WG8ZbUUkpEQzhJ3VswaDHZ9ohoDtoPezDPAvl0BaWvq1uJ09k5vaWoLfzgHAxetFzXqjTsFwddmM2Wf/7x+UOT2YEKeTKRjQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0jTCOUHttVnLGnFcKvJpzQLmV0Wey9Coi0+Hz2SdiRw=;
 b=NWg6aRSfqbmhDFgc8E//dc1UhdNe8PUDYoWFWdFP9B4EA+MFl1lEi7f/kPDNb/eg9SMjTH5SM7v0P7YXeKrysJ66BACdMy3j+B5f387qejvoMGFs8YyfH2k4Gv7x9sYEvQ12vqs5iHRw6/OaLp1Lcrf6RAQMQokt/1Dw8ya3mxTW6EsTBVYoU+K4zoaMwTa60xFBYfp7TWhIkgQaz8hRl2V9ngHzl+kI4tyWnWpd9mMoziETSV8EvqZ5+4HxRnWmmfz5w4iGxsz0bk417ofe+b1K+NpaUHgDSvX5HLoBoxjU+TvOSltYCH410v9HVMUqAYMkcJyG5b5lsqFEnaj6Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6462.namprd11.prod.outlook.com (2603:10b6:930:32::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 29 Aug
 2024 07:47:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Thu, 29 Aug 2024
 07:47:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "jarkko@kernel.org" <jarkko@kernel.org>, "Lu, Aaron" <aaron.lu@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Luo, Zhimin"
	<zhimin.luo@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
Thread-Topic: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
Thread-Index: AQHa+byF0Y9MrGV/iE28eEu2OnOLh7I92/kA
Date: Thu, 29 Aug 2024 07:47:42 +0000
Message-ID: <2cf0b2677ec6239a1fd7aa1b3ee101667c7b06b8.camel@intel.com>
References: <20240829023800.1671210-1-aaron.lu@intel.com>
In-Reply-To: <20240829023800.1671210-1-aaron.lu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6462:EE_
x-ms-office365-filtering-correlation-id: d1930f76-8e6c-462e-c520-08dcc7fedd47
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RVJseVN4dmYzazB2dDhSSEJYN1N1akdQZGQ2UFBTc2s5Y05nK25QSS8xdGt5?=
 =?utf-8?B?eTU2VFRWUGcvUEMrWHRIYlpzNTNGSHNGeUgxT08xT2ZobmR3Z2N0eUN0SnVj?=
 =?utf-8?B?bW5HTy9wcmV1czZjY3dSL29IMWZTMDBVOTFUQUhpaG1NWU1xV1Y0dTU1MXl0?=
 =?utf-8?B?TlNZVVE4ckxyV2dFZlZCck5iT1hvZkJFbGZ2ZSt3VzI2Kzhzb1QvbUlNcWZV?=
 =?utf-8?B?YSt6YWpNbW9aVWh1VnBOWXROejBOTm15VEs2MVRrNjhBR2FWRTJiWTVJOE9n?=
 =?utf-8?B?Uzh2V1VKMmxqcmVHa1doM1NKbjVPV0JvYld4ZGJYUjZiY2hvYU9FczdzamVa?=
 =?utf-8?B?Q2F1a29kQlo3RFliZFNoUW1TbjZuemFQSWFLZ25OSWdBTzZXNHJjT1pHRTk5?=
 =?utf-8?B?T3F6RnBmdnJlL00yOWhVNm84RjUxT3BBL0I4eFlhZ1c1QkpueUFyS3NFcE5I?=
 =?utf-8?B?aERFR1ZUbVZqM08ySlJhOFUrOUR0emFpeVlTOE5abzhHTTg1VlE2Nkw1S0ta?=
 =?utf-8?B?dVVNMVlYMmM5UC8yOUMvTEVuY2NjR2tGQ09BNzBhdGthT1ZCTXRlRlpDQktI?=
 =?utf-8?B?SVFIcFRJUHdjV0hHOVNwekdlN084ajBhRGhRWnZIcEkvS3JjV3I4a3VqNytt?=
 =?utf-8?B?dGlmNnRFWTcvQ2RDMkN0YkY5UmJmZ1BqSlRlcmF3Ym84ZGxibzBrTnQ4R2RT?=
 =?utf-8?B?aTBJbDJVZE11M2ZtYitMWGxUSU14RDBKMEFBTVlraHBLaHBCNkpjUjBrWG1x?=
 =?utf-8?B?VnZvd3BHdXM2dmFiek9KbEhGK2VjRXZUSmJscFlGQUJOVy9MQnJFQVlDOVdH?=
 =?utf-8?B?eEMvU0xZV0lXMEJ4Q2l2NXdKa3dERXBra25FYmhKWmZic2ZJZzlaZVBVWlgx?=
 =?utf-8?B?Y3Bva0N4dHVhNmlZNFhiUDBCanQ2SkwzbjMreDYyMnpXRUxBSGVibEY5T3Uv?=
 =?utf-8?B?a1AzNmtWYk5zZ2JKMjZNZlNsU0d1aUk2MWtSTnBlMmtjNlhNUGp5cU5aUUxY?=
 =?utf-8?B?YlhWRU1Ua1NVQ0JCQ0V3SWd5WkVEdS9POXFwT1E1ejY0Z1F1Yzh4QjM2Nmxa?=
 =?utf-8?B?SWJtM1ZycERwbmExTnV2cGdXSzM1SG5icXR4aDdzQm51RGoyc2x5NG5WLzlS?=
 =?utf-8?B?RXRUVzhPU25DblYyKzJXdWxIQ2ZTUGIweGtDK2xmRE1oQWoxSGZOOFZMbWk5?=
 =?utf-8?B?UVhtVmJtS0pieTZWUERBZ3EvQ1ZlbHp2cFFpWDRsTmF3amR6Nnc3aWpDellx?=
 =?utf-8?B?VWtDWkw5ZXAzNTJ6UlBQVDAvQVVmVUg0NkpYbVlxZ2NqaldzVHNKZUoyWDJ5?=
 =?utf-8?B?S2hyeEI3STJ2OTNvd01GSSt3TEdGdTlkR0RRSFhxZ3BiVnJxZFZpNnVveGll?=
 =?utf-8?B?YkhMZkJ3L0xVVDB3MEJSR0VJQ01McVlCSlhzVlljWnQvR28wMXBUUDlHYUpR?=
 =?utf-8?B?bFVIZzhLdy9PcUpGdExIT0lRalhZZys3Y24yZkNZWWR6VGl1bm5kdWdyOXZT?=
 =?utf-8?B?UXMzQnJjUlVQcGZzNVNQRFJUUTBNb1NwYTBTQ3IyY1hEQ2E4cWNmZVBCNitn?=
 =?utf-8?B?c2lSc3VOYjhNMmRXTDdHenQwbkRBVEc0ZjVPTFo3bERNZ1ZyZWJINTh5c3Jy?=
 =?utf-8?B?UE9wVWxoY2tYMDlPTmdpa05CVTRMbG8xNWM2bnpTcW9GSlA5azNWOHhVaFBp?=
 =?utf-8?B?RDVzalFsbzRzc29rZmJic1pJbVBPNWRCd2xlVHpUbmxzTGNacHp2UUhOc1p2?=
 =?utf-8?B?N3MxL1poTG5yTzVBcGRnSUNoeW01aitLT0JwL0p4YkZIYzlMTFFGenVXdDFC?=
 =?utf-8?B?Y3FkMjh2L0ppT3F5ZThLMzk5K29qQVB2d09UMUZRTzB2Z1MxTEdwWFRDcmVX?=
 =?utf-8?B?M2xUY1JUeW5GdHRrUDN5VVZtbEd3eWNpNWYwTjVFSmVld2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2pUaElqRjVxbzBHVTdyRERMWEtxQWdnSXdoY1dQaGRvUVE5d3MwZjdta2Iw?=
 =?utf-8?B?SWZ3RU84K0g5QzIya0ppWEZoMG5NNHBVRVd4TUNQaGtsdVNmZnRMNCszdG53?=
 =?utf-8?B?bERwU2JHVWgrOWpMTW43eGMyOGZDVW0vdHF6UHgrS0dMNzlNOWdvUEg1eEpN?=
 =?utf-8?B?eFp6Z08vQ3NRRmJkV1ZHMHB5eXJ6VXkzTEhVd1NLU1c1clpQWnpFNEFBM1JI?=
 =?utf-8?B?Mkk2M2RqT0wyTkxzdzNoeWYyL3dWM012YkR5NjlmVEoyMXFLMDk5R3p4eFZ4?=
 =?utf-8?B?WXJudWJEVmhMcVhPaWFHOUhmVzVsUE5CaFljY1MwZkQvcUcreXJHUGx3MGJV?=
 =?utf-8?B?VHFqNEZmZU1rallMRldka1BXVmJnVlVqSE9uUGJmZFl3U1gzWmdUZDdheGtw?=
 =?utf-8?B?aTk5dUdqWU53VGlLNXUzZVptQmVmaHJnS2Irelc4WEhEbXVaVW1MNk1ocDhV?=
 =?utf-8?B?djB6cVNjK09peDNUcFZiUzNUYlpVUk1qMFBQcVpwRi9IMy9QNWtLUFBGM1BL?=
 =?utf-8?B?Q25WT21YbjQ4WCtZT1dCSnh0QjU0dFh3UnRteERjZ3RXVlprQU9DUFRtLzY0?=
 =?utf-8?B?WCthRnVuem9SUTVOTEREbHROenRRQTR6cFRITkhuSkJydXJrTHJpejducmpF?=
 =?utf-8?B?c0dsallURFdZd3VFOVNsMkd6VWVOQ3VsMlJsOWJvOURYTHA1K0Z3ZnNpZFBz?=
 =?utf-8?B?eVZGMXFKQXZJS29UZ1F3QnFENDlLL1JxcmVkWGJhVVVoTUE1L1NldEhialln?=
 =?utf-8?B?VXFSMWZuRndmSWVoc1lORGtESkxNMVVNdHB6RmVUZnNGNWdxWGJ1UnAwK0Zn?=
 =?utf-8?B?OFVJcDJNVUs0MEE3SE51eEdNRE5kZE5pMW54WUlxc3RBRGE5SWxpU0hzMFhC?=
 =?utf-8?B?VXQ3bU9xcEtCOEF2OFRsVFNYa1F4SWFiVldVWEJ3c2QzbDl4SjVnS3cvL2RJ?=
 =?utf-8?B?VW9ielRWVW4waXZEV0VuN1RlTjl2aVpjWlVFT2RKQlhMcHlBc3Y1V0RtQzZ3?=
 =?utf-8?B?Y04zd0prNXJmVzJiUW4rRmdpYmt6d0IzWDBuRG5kOFNBRkxycmZKOENYaFRG?=
 =?utf-8?B?SmJwd1R6dFIrMml0eGhqZ1FLeE1Jd3FUcUZhVGthL3BRbUxIKzdnQlgxajQz?=
 =?utf-8?B?OGpiM3NWSkV1bytVTjR1QzFwZmVENzg5SEhlNy9QRVdOb3dWYnpIQW43QUU0?=
 =?utf-8?B?bEEvU2xpTjBIRlltdUs2a01TT2czOTlkTW9MTXlVclJLc3JnVnVLc0tRS2tK?=
 =?utf-8?B?Y2l5MmViUDNoY0RROHJ4WiswNlZmRnRVNlEzTldpSVNyckR3T0ZTZW1wZnQ5?=
 =?utf-8?B?bG1QTzAyaGgrSmxrc3REcE9yUjl5MEpZemZGMy9oWitRTEZWdzFjUEtaWDlq?=
 =?utf-8?B?RVZWdHpaNVZSMDhtZ3NRUGdKU1dYRHl3YVJrdWtlU3BZd0tVWkZkbW1nMnp2?=
 =?utf-8?B?SnZZVXVUbkhmUkVRR0JCdGZvbkpnSnpNSk9FZG1JMnhxVWlJdzAzanZZU2Iz?=
 =?utf-8?B?LzRHaU41UW5XRlpCaUo5cUM3K3JJbVFESXgrQ1N6SVhsbytidllnNGNmRzR0?=
 =?utf-8?B?aHRjbkxSZXNWMnFzWTE5d09xRXhRM01sNk9YanJ0RTBlOERlY3lpeWM4RTF3?=
 =?utf-8?B?ZDQxUCt4WU4rUTltY0FtVHlOWS9HU1pQbWlBRkNQYUVleXBnRTBLWk5vbFo2?=
 =?utf-8?B?OVJOR3ZtdkhlblRnc3h0Tm9waW0zZVBsQm5Cc0FSb2toTUppanBKbEZuK043?=
 =?utf-8?B?TWprNDJiS3FJei9ERnBGcGJ0SWtSdzRJZnRmQVBvcU0yak5LVlZqZFQvVGtD?=
 =?utf-8?B?RnJ0OUliVm84Tm9zeXpIb3VITjMvRFFRdzhKUDUwS1hRS1lQcWpuNzA5SW9o?=
 =?utf-8?B?cjNDdVFlbU9PUDhEQnlFTWRBelRuRy94TExOUm5pSTFGY2dONy9meG1sMng3?=
 =?utf-8?B?WW1XczlXWGtJZkZPWWMwU1VNSXNhUXlKNHd0TVhJSEpyQ3pIb2gzTldkR2hx?=
 =?utf-8?B?eUlISGlIck9kSWtKWVpDQnRwdnhPWWVBUjJJR2hLS0dxd3lxdXlONG1tSFlo?=
 =?utf-8?B?bmw3Rm5OTXVTbzRoYUZoSWZUMnZ5OTl6VHRHdGpZbm4zRVl6aGduT1lEK3ls?=
 =?utf-8?Q?Bp52RY/JGXQ2tlBOR2+GmKGeT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DEB03F548558DF41AC17A4848273F8F8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1930f76-8e6c-462e-c520-08dcc7fedd47
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2024 07:47:42.7406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cah26+4APZml5Ow7JHz3mFEXOe17YoOoV2/hDNNTnL934MI3PJ1bo3QVyY8SlYgGYGLisQx2HQDGo4jmmn54/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6462
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA4LTI5IGF0IDEwOjM4ICswODAwLCBBYXJvbiBMdSB3cm90ZToNCj4gV2hl
biBjdXJyZW50IG5vZGUgZG9lc24ndCBoYXZlIGEgRVBDIHNlY3Rpb24gY29uZmlndXJlZCBieSBm
aXJtd2FyZSBhbmQNCj4gYWxsIG90aGVyIEVQQyBzZWN0aW9ucyBtZW1vcnkgYXJlIHVzZWQgdXAs
IENQVSBjYW4gc3R1Y2sgaW5zaWRlIHRoZQ0KPiB3aGlsZSBsb29wIGluIF9fc2d4X2FsbG9jX2Vw
Y19wYWdlKCkgZm9yZXZlciBhbmQgc29mdCBsb2NrdXAgd2lsbCBoYXBwZW4uDQo+IE5vdGUgaG93
IG5pZF9vZl9jdXJyZW50IHdpbGwgbmV2ZXIgZXF1YWwgdG8gbmlkIGluIHRoYXQgd2hpbGUgbG9v
cCBiZWNhdXNlDQo+IG5pZF9vZl9jdXJyZW50IGlzIG5vdCBzZXQgaW4gc2d4X251bWFfbWFzay4N
Cj4gDQo+IEFsc28gd29ydGggbWVudGlvbmluZyBpcyB0aGF0IGl0J3MgcGVyZmVjdGx5IGZpbmUg
Zm9yIGZpcm13YXJlIHRvIG5vdA0KPiBzZXVwIGFuIEVQQyBzZWN0aW9uIG9uIGEgbm9kZS4gU2V0
dGluZyBhbiBFUEMgc2VjdGlvbiBvbiBlYWNoIG5vZGUgY2FuDQoNCnNldXAgLT4gc2V0IHVwLg0K
DQo+IGJlIGdvb2QgZm9yIHBlcmZvcm1hbmNlIGJ1dCB0aGF0J3Mgbm90IGEgcmVxdWlyZW1lbnQg
ZnVuY3Rpb25hbGl0eSB3aXNlLg0KPiANCj4gRml4ZXM6IDkwMWRkYmI5ZWNmNSAoIng4Ni9zZ3g6
IEFkZCBhIGJhc2ljIE5VTUEgYWxsb2NhdGlvbiBzY2hlbWUgdG8gc2d4X2FsbG9jX2VwY19wYWdl
KCkiKQ0KPiBSZXBvcnRlZC1ieTogWmhpbWluIEx1byA8emhpbWluLmx1b0BpbnRlbC5jb20+DQo+
IFRlc3RlZC1ieTogWmhpbWluIEx1byA8emhpbWluLmx1b0BpbnRlbC5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IEFhcm9uIEx1IDxhYXJvbi5sdUBpbnRlbC5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkg
SHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=
