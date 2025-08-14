Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A597D2EA472;
	Thu, 14 Aug 2025 09:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755164146; cv=fail; b=ENy4wxB5fL/M2J1gEqCXAJdzf8AavZRtdnNG47u/4h9Lku6zI6T8dg5KOkS9nCqTEHAo9hKW2BQLCcAswYUKd3i8DJAFCX/IiWXBNHgyAit0tAVUN4RCZiuoOIQEQmCZY7715qUIEWN4Pr+HsjvAoEtqiW8kU01nukv7xpCNzv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755164146; c=relaxed/simple;
	bh=ZklxXwfyivVIe85tFhpnDCXOTH0JpexX6KVSCJpIM5s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a/Qj3HqCtRBgb4ZCHsnE6Bu8Wtu7EJdwNyENsigOktPdRZ7s61zThotJ6RIo+WQpMQK4GCL9AZuw9bl0naAHmK2QfZq2CzysH6p1Z8iJ0/G6ZGGZMhf3zg7p3+1VJwjghDrK6DltxhnODvnhDdDEz8kBXufSxqLiI3sG8waTKtc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T6R4S8z8; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T6R4S8z8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755164145; x=1786700145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZklxXwfyivVIe85tFhpnDCXOTH0JpexX6KVSCJpIM5s=;
  b=T6R4S8z8bLfM8QpCNqcGHP1cBWhkG8a7cwmRikDiCulnchTshyEyo4nU
   533z9Gon6RxL2fGClABgV9W0DFFHWlBsUfHlI74pQIvigCPZ9GRMDkt+n
   I1NIdnfWVIXaVW1R1fBy1dwOzp9rWGhbo26nSqJ4qS0EtN7B7IB9xu9DA
   3xcQaFzus+ht3wguSzUTA0hKiQ0bJ9+ltpKBtOj2A/8KijI8OU4C3WE6f
   f+MyA9NsowJJsgV3Ur4JeJS4frU07uHn7mGgnV3pk6wG6OpH6sOmxUf8E
   8FuvKMetoTB6V8Tq+TkKiC6mBEyIj2C24hFMb8syejxRQQqr+LUgpm8is
   A==;
X-CSE-ConnectionGUID: rZJeBX8eSHqSxES4qYu43A==
X-CSE-MsgGUID: pNLDQcleQuquiqIJYjpLdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="61100544"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="61100544"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 02:35:45 -0700
X-CSE-ConnectionGUID: f+QAkCIfQVyDIrlYngtuXg==
X-CSE-MsgGUID: nad0xx0cTuaemHL8TRqTvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="170844342"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 02:35:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 02:35:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 02:35:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.65)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 02:35:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M8PDq+tIrODk1zWdg8txynswKxk9m2Gj+Jq9YN8Ba4rzGNmhHauafSKWFGc5EmytIUwpHWjD872KEUBm1F2re1oKrdwPf6aGxHYCgQ6e0jwr1GVMPLRTvOahXSi8Q6D/U6WhOFCDv8/PYg6qNSgv4xX3VSdHXCH7QqFQVJc/mx3lLVZbORVl7lMBfdgycQjc13MG+bFxBbijK3/P7JzgpYFR3dp07KSp98XS08rrECzu0x3sZEMzwaErNVRCt5LckJDZDNth8kDKb+O5W9FvQZCTp7S+OGmT0KtAPD2ly+lgNQKqym6WsIgNdS86S5ZRpO1hrJYOa3GnjiQpEeKNag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZklxXwfyivVIe85tFhpnDCXOTH0JpexX6KVSCJpIM5s=;
 b=kFfa86hiVQMRNr7SH7EXz1F7OaGa/avWYGjv15YieuwRrHXRD4pnRr6sPXEWXnUfni8/O+H2rEoxQqWhgcSt+I1thlkK54bCdzZdhxgQqgoRAeBrpaDUP3LkXoFHcDljNGa3mIxaWwMKqTns+ePraE0z9P74HKvR0OvZ6e7iyrZ+As7OMHE41vgKtluhIXAJJnKAnQlIpHsAqQbvF76MHA4PqOXcU7zAWUamWt1nQ1nzgtXbF9WwJA0dgD+s3cso9b09/Gr9bvLJ3mBahHyk1nvKfI2U2xWuO8h7oac5urH3LWuJHgUwZtNS+qU3UXG/CBPucJGeaAUHnTIqI2beJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ1PR11MB6082.namprd11.prod.outlook.com (2603:10b6:a03:48b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 09:35:39 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 09:35:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Cai, Chong" <chongc@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v14 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v14 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Thread-Index: AQHcDO5KasBtAADxqku0BocXors/zrRh47YA
Date: Thu, 14 Aug 2025 09:35:39 +0000
Message-ID: <a74ede5f4466572e33c92fceb69136b82c042d7e.camel@intel.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
	 <20250814073640.1507050-5-elena.reshetova@intel.com>
In-Reply-To: <20250814073640.1507050-5-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ1PR11MB6082:EE_
x-ms-office365-filtering-correlation-id: c30b8ea5-977d-4587-19dd-08dddb15ee17
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UVI4SllBZnVNUW1IZlhma2U2VnNhcUtab0h6bzgrNzB4M0luZllGT01aalZa?=
 =?utf-8?B?dThzZHg2Y2U2UithTmtZV3JuNEEwTVY0T0hGaXRPYThpSmtWREJBdDdKQnlP?=
 =?utf-8?B?dmtLUW1NRnl1MEZQRy9FUkNONmh3VThPUU1RQWkzRGczSDZPOHltSzBHdVdU?=
 =?utf-8?B?R3FBaVM1SnZHZytqRk9Rb0pRQmJsOEhSL2Vxb2x6bC9KUG8xc201akFaL0hi?=
 =?utf-8?B?YlZlTitydXNvcDRXWHo5RTlxNDBmUjFqMnJTaktlUDZxVmhEVk1DWmhjK2Nt?=
 =?utf-8?B?Ritpbi9yaWVPUnk3V2txajZUWDZwZUl6UkNvVkpEdnpMRnpIZ2VUa09tNGJE?=
 =?utf-8?B?MTVYVktxbEVGejkvQlkrVWRxb1pMcjVMOVorbjdYN01sZlp0cWQ3NFQ4ZVY3?=
 =?utf-8?B?UnpLeE15NERwYUtkeC8vVkZOeEhzV2dicC9IMm1MZU9CUUJkSW1yaHJySTJB?=
 =?utf-8?B?TUZtRkhUQkd1UHVDRXk0dVVyV0tyUm1XblR5bVY5ZlluRUtBK01LQ0RuSFQy?=
 =?utf-8?B?VVlETFh5WjhJTEprOHA3dWczUWs1ZTh2NGM3NUM4TGdPQ1d1UVhzb0crQTdK?=
 =?utf-8?B?OEl5OVN4OWN3czZaNmV5aWowQVFkRGl2WG50NkpBSWtXKzh3YkdCY2RGSmsr?=
 =?utf-8?B?L3VBcnYwaWc0Mmd1b2JUZjgyWUIyMWlZcDE5OTNyc2JZZkZBR2VyT3FaT1pN?=
 =?utf-8?B?VmNhNDFmc2VrY1RJQU14ZUNxU09zRFdTSFQ0MWNqZXppSUFiYTgzQlY0SU5N?=
 =?utf-8?B?UmVaYUg5WUp6dm04SnZsaXVTcXVNSzArcEVBLzI2T1YzcVEyNm5idUJNTS9K?=
 =?utf-8?B?Mzk5TWZYbU9yTGErTHZTWHJwU0drRnlBelZ2WWtaRjJIOTN0V1IyektOWFdh?=
 =?utf-8?B?TUtqMFFQWklZdzY3OWhCU0M0cy83QklJVTY2QkVUSkVQWUNmZDJzV3lrS0lJ?=
 =?utf-8?B?SThQa1lBMzI0emJhcjlNdW5GK1d4c2VnRllxL0FFTlAreitLN3VjKzVpYlBa?=
 =?utf-8?B?dkJWMXA5cE1FUndFYTRQQm9hb1FQZGM4NWZia0Rmdm5xUko3V2k5dHhTZEQx?=
 =?utf-8?B?T0pGMTBOc1JEQlpFYmJsa1ZxWGxEdWtWMG1MS0kwZHk2QzEwVzY1UGNvSlIx?=
 =?utf-8?B?Y2V1T1lNdTIwM1UvMm1uOWJRbWwrajdDc2tOYlhnWEVzcDlBeHR3Q01oQjN5?=
 =?utf-8?B?cURsaG1BZkx3cnpYaGJtRjlFRWJjQzdDOE5GRXNLckxPWk5hY0ZPaXZmTnlR?=
 =?utf-8?B?d1BhRVNYeFF1QjhjNE8rMG8rVXpCbWVvdE9VNjQwd2R5Q2hGQWpmR2IyOWxU?=
 =?utf-8?B?VjlmZDBHZWUrS3JqejZETEFLTENLc1ZlbGpDeGtoTjA2Vm91THJmZFFBU2ZS?=
 =?utf-8?B?eUNYZzI4K0lsNXh6YUdZa25rS2E3T05tS2pUMHR6UlV2bjB0YkMyQUJ6MVRp?=
 =?utf-8?B?eGdZb2N4UDltdUVkcTdqK2pwcHJMNU1ndnhHbUhraFRVdE9CSFg3eG9OR1Vx?=
 =?utf-8?B?eUFXeEpQZnYza1pmVmFrdllSdUpNazRBVUxXUkllVi8wQXV6aUJaUFdseTVI?=
 =?utf-8?B?TXZ1RkRKM3VxU2FhMnBuUTRKS1g4TzBNSFRlemk3SGhDQi9hczJUK1JvSHRU?=
 =?utf-8?B?UTB4bno0cU5LWmZzZktFQ0l6M0tQdWRJdlpuSldGclV4aHBmWTIrbjU0cUxi?=
 =?utf-8?B?VTF3OWp6a0kyMG0vNlNoUVB3b1ljUlREZ1o3VEJMWEdER2w4TkhNemRXb3c2?=
 =?utf-8?B?c1JiNlpPZDNSZHYwMzRRL0hsYXRJYXRETUhuSHpzTlZ2dCt0em5rREp3dXV3?=
 =?utf-8?B?SGFKVTI3a3MxZEJic2ZhS2F5SS9SMVhSL2xQcS9HSXlPeVpQMnhHYUVhekRK?=
 =?utf-8?B?SlQ2YVdsbG93ZnJTNVd6VmxBNTYxcnNCOEUwWDcybTZHU0hGTU12MXdMa0xC?=
 =?utf-8?B?c0pXWVZGY2xnTlp0dmhnSE9mbFdoakVHWnFzaVFPdzhpVEhZOUt6Y1hkZkZu?=
 =?utf-8?Q?Orq4Hielx0HXrbbD+G/p4YShLp54dI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHhFb0hLOWpHZnBGUWZ4ellzV1ZhTVY5ZjJQcXIyUUdJNm92L1RVclJVSTR6?=
 =?utf-8?B?YmdMeUc5UkI4TXZqdUtGd2h1eDloMzExbHZJT0FGN3REVk1NUFhUUFZiWGZs?=
 =?utf-8?B?OTZ0ekNiU2RTN3VjaHFFT29JQUx2QndXcHZVSzRLU0lZWkl2UlZobEMvQ2NF?=
 =?utf-8?B?VWNYQ3NVR2tDdllTNzhNNHh2bHkyQlltZUxVNjl3TlJoWWFiY0w5cTF6UGJ5?=
 =?utf-8?B?Z2dSdDNSa0tDVkxNVmUwUUpGNUtrMHZudXh5WExsanFHVnNZUG5wKzE3QndP?=
 =?utf-8?B?M0VZcWV4c3paTUs2WU1KZXJmcWxuU3hLMHV3dkZiNzBTdTJPSG00d1Rqb2Zn?=
 =?utf-8?B?T21EcndabFd1cXRmWkYrck45MTB6SlVTMzdoaWorcnY5ckxFemNvWXlUNnV5?=
 =?utf-8?B?MTVJRXRiQjFzcm9kZEJlemJLbjlwb3VvVzllMzU5dlBvYm9uWDd4L3EzQmM2?=
 =?utf-8?B?dUF3V1ZJU0tidmQ0YWRjb2hobW4vV3ZTbkoxdFo0TE0vRVJYU21JenNCWEpv?=
 =?utf-8?B?MTBmdk1HTEVudldPOE9laTJwTjFIajg1TVhlOHBsOUFGS0lFR1J2V3QxYSs2?=
 =?utf-8?B?UDhjQU9hTVhySDFyVjIxSVg0Q1hvM0ZBRTJ5bEF2S1VVK1ZzS3Q3cEt5MDFz?=
 =?utf-8?B?ajZuWm0zUWk0UjhCd3lhYzliYXV6d2o1U2pDTVBvWUpZZWhFR1FDYUZrUk5U?=
 =?utf-8?B?VHh0SU9HWklhZGtsT0loc1p1a080aXhzemtramsrUUIxVE80SHUyeHh4dEcx?=
 =?utf-8?B?aW80TU5FUGRhbHdHTjQ5OFVvUnF5Qk5KTWxDVmU1TzZBTzRUdk1ZQ2E3cmhN?=
 =?utf-8?B?MFN2VDFsMXNqdmlGVjNSREpxQU1mUnNsNi9qZU9pd2gyN0dtdXY1amRvZjFU?=
 =?utf-8?B?ZXd4elFiYkMyaUZtQzBKRjRkTytudERnMEx2eEJJdWZOYlplU1dxeHIvQWFh?=
 =?utf-8?B?Wnk2TlZhazBCVnhhcXkrS05vNzc4NVZoQVU2Q3U3ZXMyVnVxSEx3NFhnMFJy?=
 =?utf-8?B?dnR3R2ZScGlmNFVETXBsVzd4M3hpelZDTmtGZTFnQXIzYkhydWgwYzBKVnF2?=
 =?utf-8?B?c1VPbWlpVW13cUZHTjF3d3ZrVW1FUm9Fam9QYWxzWVgwcTV3eDRkYmZuNS9F?=
 =?utf-8?B?Tm85UGxkOXBxRTFidGZoOTZUaHZHZHd5bUtBL2wwN1dxUjFuc3hqdjRYNXVF?=
 =?utf-8?B?WVpxOCtHYjdQc0RFSFZQSnh2UjI0QnNqdUtPMWxJeFVXNXVRVDhOeGtuL2tD?=
 =?utf-8?B?K3k5VTJDMmVtQkNiR2VRS0c5N1BSbzdtdEdNNzZGck1za2hlaXhyZFlKeDN2?=
 =?utf-8?B?eXZRYksyZ01mc242RGI4TWM0ajVrT3dwbnVtQTZCSm80eU12OHlaYlBuUW40?=
 =?utf-8?B?M2VFbFBlNG1OWHpobnlEVjA5OG1HZUhiVURCbG5BdkZEbFZuYTRKbkVLQkF1?=
 =?utf-8?B?QlhQcVhLdk5Va09tWDFRckh2ck1lYUp4VGRWOE00bmczT2EwUGU5YmJHblBs?=
 =?utf-8?B?SzVpQ2o2QmdJR1hLeCsremF5TDlKL2tlVWhUUndzOGllR3gvSGt1cWRBSjNR?=
 =?utf-8?B?QVJ0ZC9vTjR1bHNucXZrdkZXOEN2NGM0Q3k4elJWYk0zMGlacFNtUGgzaXVO?=
 =?utf-8?B?eTdOVDJLR0dVckpQZlJ5cGN4RzZSTlBJZ2dRemt3TnBXbzg2WGpidEF1LzI4?=
 =?utf-8?B?MXZhQzkxZVh5bjg4Z3U1Mnh0TlphVVhteldObHhQOHdJb3RaUlFNc2Jnd2xW?=
 =?utf-8?B?TjNEMmZJWFRuRndmdDhSdDhlNHJ2ZmI3ME00SXAyT2huMWVJbEg3UE9JaUgz?=
 =?utf-8?B?ZjV4USt6YWNjWHVzd3VXbFdtQ0htVGQ3M1hLTXZSWmFod0VKLzZ1dThYekQ1?=
 =?utf-8?B?ZFQ3cFhMWWtsY3FmN3d6U0NiSlJkcWpoSkhzdE12VGJQVUZFNVMzUzFvTGdi?=
 =?utf-8?B?NUNieWRjODBpUVViY09lRjBrSVMvVk5JS3UrMmtYbGtRS3Zqc3dyQU9RNHc5?=
 =?utf-8?B?UWRwR3dleWtuL1A5bzhCMUx1UHJjYWhyZHBwNEJQMUYyNXo3VWtGR1ZqOUdH?=
 =?utf-8?B?djNIM1VQZVpLbURMYlRxY3JzUWlnby9Wcm5RRDdqMkNHdnRWd2tmUTcvdTlI?=
 =?utf-8?Q?ZmxFGea+uBQC4G3hM7/s90dUI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D1D2D281A232943974B08460EA5BC46@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c30b8ea5-977d-4587-19dd-08dddb15ee17
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 09:35:39.1504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oEDgzT41y3a8QKF5echRR/x8ZkuUAw5lr56oHrZZ1ubdX11oy7wG3Gx9cIWEvftdCB6H/+zVJH9lteRBV24+kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6082
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTE0IGF0IDEwOjM0ICswMzAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3Rl
Og0KPiBBbGwgcnVubmluZyBlbmNsYXZlcyBhbmQgY3J5cHRvZ3JhcGhpYyBhc3NldHMgKHN1Y2gg
YXMgaW50ZXJuYWwgU0dYDQo+IGVuY3J5cHRpb24ga2V5cykgYXJlIGFzc3VtZWQgdG8gYmUgY29t
cHJvbWlzZWQgd2hlbmV2ZXIgYW4gU0dYLXJlbGF0ZWQNCj4gbWljcm9jb2RlIHVwZGF0ZSBvY2N1
cnMuIFRvIG1pdGlnYXRlIHRoaXMgYXNzdW1lZCBjb21wcm9taXNlIHRoZSBuZXcNCj4gc3VwZXJ2
aXNvciBTR1ggaW5zdHJ1Y3Rpb24gRU5DTFNbRVVQREFURVNWTl0gY2FuIGdlbmVyYXRlIGZyZXNo
DQo+IGNyeXB0b2dyYXBoaWMgYXNzZXRzLg0KPiANCj4gQmVmb3JlIGV4ZWN1dGluZyBFVVBEQVRF
U1ZOLCBhbGwgU0dYIG1lbW9yeSBtdXN0IGJlIG1hcmtlZCBhcyB1bnVzZWQuIFRoaXMNCj4gcmVx
dWlyZW1lbnQgZW5zdXJlcyB0aGF0IG5vIHBvdGVudGlhbGx5IGNvbXByb21pc2VkIGVuY2xhdmUg
c3Vydml2ZXMgdGhlDQo+IHVwZGF0ZSBhbmQgYWxsb3dzIHRoZSBzeXN0ZW0gdG8gc2FmZWx5IHJl
Z2VuZXJhdGUgY3J5cHRvZ3JhcGhpYyBhc3NldHMuDQo+IA0KPiBBZGQgdGhlIG1ldGhvZCB0byBw
ZXJmb3JtIEVOQ0xTW0VVUERBVEVTVk5dLiBIb3dldmVyLCB1bnRpbCB0aGUgZm9sbG93IHVwDQo+
IHBhdGNoIHRoYXQgd2lyZXMgY2FsbGluZyBzZ3hfdXBkYXRlX3N2bigpIGZyb20gc2d4X2luY191
c2FnZV9jb3VudCgpLCB0aGlzDQo+IGNvZGUgaXMgbm90IHJlYWNoYWJsZS4NCj4gDQo+IFJldmll
d2VkLWJ5OiBKYXJra28gU2Fra2luZW4gPGphcmtrb0BrZXJuZWwub3JnPg0KPiBTaWduZWQtb2Zm
LWJ5OiBFbGVuYSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQoNClJldmll
d2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCj4gDQo+ICsgKiBSZXR1
cm46DQo+ICsgKiAqICUwOgkJLSBTdWNjZXNzIG9yIG5vdCBzdXBwb3J0ZWQNCj4gKyAqICogJS1F
QUdBSU46CQktIENhbiBiZSBzYWZlbHkgcmV0cmllZCwgZmFpbHVyZSBpcyBkdWUgdG8gbGFjayBv
Zg0KPiArICogKgkJCWVudHJvcHkgaW4gUk5HDQoNCk5pdDogaWYgYW5vdGhlciB2ZXJzaW9uIGlz
IGV2ZXIgbmVlZGVkLCBJIHRoaW5rIGl0IHdvdWxkIGJlIGJldHRlciB0byBtYWtlDQp0aGUgdGV4
dCB2ZXJ0aWNhbCBhbGlnbmVkIHcvbyB0aGUgbGVhZGluZyAnLScsIGkuZS4sIA0KDQoJKiAlLUVB
R0FJTjoJLSBDYW4gYmUgLi4uLg0KCQkJICBlbnRyb3B5IGluIFJORy4NCg0KLi4gaW5zdGVhZCBv
Zg0KDQoJKiAlLUVBR0FJTjoJLSBDYW4gYmUgLi4uLg0KCQkJZW50cm9weSBpbiBSTkcuDQo=
