Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D46DA48;
	Wed, 16 Apr 2025 10:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744799595; cv=fail; b=aEUPgl3snBmiJtXbgBOwPFotLl3+1Wxi+YjBP1xTbhwrnq16nTn34Zn6JftaOnYAMhEULGBZ9GxlhEZmO3IEBkFLQ/pemPmUHreHUwnsYat/0tKa70lf/FoxwwGySdjVPf+GTz8I1iYUuAnDsl8yFny5JfxmyVsQJX3zvNrzS50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744799595; c=relaxed/simple;
	bh=neU1YBUo9uwKkPLTQE9yZ4j2toubOykSSHN+V4+KNn0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oJBTxoQpmeh4Nq5DisBqEAR1XxUk/kYmtoo/M3/sTuAnSlR5vR/3SAEMgQAEwReFbLmNtQ8578T08U51d/fmFvWVM2xLGgMSr7J41CgOBJQkpCHt8NepZxAFx5m2ENR09P4LcYA3QAzNdkJkZVItSPomFRIoGQIckqU+vrg41qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MpYnuJSL; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MpYnuJSL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744799593; x=1776335593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=neU1YBUo9uwKkPLTQE9yZ4j2toubOykSSHN+V4+KNn0=;
  b=MpYnuJSLQ5ZMGd8yv0HH33uH1n5N9GUgBw2COSbDJv7u3rG0FStDRmz7
   EwrAu5qYJPW1mT3m+b8wjVxFFJD6ugn45Wx+gTrGSTiVo3yH9JNmSeES3
   vQSTT6WyIbyk6deDlREzf7wk966P0/IT+9M1clHKd2pM3H3FkG2mKPVjh
   jdjROu1/xAGdtiAc7Qr9RnRzxedIlDljBhMwn1W8E570ZijejW7OcZBq+
   BE9LHSYyT2BEu5E5G0WvBMyVPB9eixikWKvQt6FqOzbko7VFguW002F09
   2qaBX53gfyQMHCZXsambpWsy23uYaUyb6IORmzr3U0r04xZ/z7jqdV2oO
   w==;
X-CSE-ConnectionGUID: 3dk1U9OIRbWKRUf9mPqqow==
X-CSE-MsgGUID: SAXg53pLSnO/cBV38LYqeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="63878774"
X-IronPort-AV: E=Sophos;i="6.15,216,1739865600"; 
   d="scan'208";a="63878774"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 03:33:12 -0700
X-CSE-ConnectionGUID: 9uYcZHFQTlytRL0a8tzmew==
X-CSE-MsgGUID: 3HA+zCHVQNet/M8AECkq6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,216,1739865600"; 
   d="scan'208";a="161457747"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 03:33:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 16 Apr 2025 03:33:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 16 Apr 2025 03:33:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 16 Apr 2025 03:33:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lC1zrwsoQjqQwwvUy6KyN/+fxitpPidZs5x9ud7/HTeYimaFCHxGjhul1XxPDMK6SizF1djRf6AkWDl9m02mWC0P9qn2n9PKxHCxUMolQOg6cDGNqBo4pxIwsiN1Lwq4eEHFgMNzqDG03CLlSKfEKFrWPyFZka5nsFRoV2oJEtzlazyTLi7cMXWcBD3EezjDTd+7/B3cfLkXBwxvcTuPYmHDPHeKCxeXp6ZpceFeOr6vnjBBzTPDuE6MQefVXQpA0Kc8jBoxWm688BOhddJkVCCzymfNbMHAaj8nZv1yaUpTFsvsUB8Ig63SQ4a4QDrW4Rvzkq6bDcNFsaYcxfo0gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=neU1YBUo9uwKkPLTQE9yZ4j2toubOykSSHN+V4+KNn0=;
 b=J4qQ/OI1ojt2+vGIcrDYB1YjZ3pciGpfvELBHNMHkr5u8YvWSxWDYspAsuaVwy8m48HFqUGHPotMt/lJf6jKgqYv6HRwKxQ5jS8dm8uGrMOMptcNOo6ZdhgR6bBmSUe/BNRfr5f7/hZ7K5wmBOw2inTjC4in5o0Ev0ulMkTM5SNKrnhkMaRViBwpAoUf2/v5sfkj5GdOCzAENdFnNuny590CBTfk7FKwmYs6jrh4J8StxbnQ6GYy99LXrU7nTn2MlKsU5h3V0In9l0J4GxaXeVpFFWgDJop32IQRH0YH7cfdKlhIoXczXJLl/wZA16e3W8VJm7H8VNRxari8KL1P2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5265.namprd11.prod.outlook.com (2603:10b6:610:e0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.21; Wed, 16 Apr
 2025 10:33:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8632.030; Wed, 16 Apr 2025
 10:33:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Cai, Chong" <chongc@google.com>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bondarn@google.com" <bondarn@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v3 1/2] x86/sgx: Use sgx_nr_used_pages for EPC page count
 instead of sgx_nr_free_pages
Thread-Topic: [PATCH v3 1/2] x86/sgx: Use sgx_nr_used_pages for EPC page count
 instead of sgx_nr_free_pages
Thread-Index: AQHbrf0Y/ZNexD7Q0UufddZzE/vqKLOmGeCA
Date: Wed, 16 Apr 2025 10:33:06 +0000
Message-ID: <9e51630d0a376a2df426eace5c25b94641e69306.camel@intel.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
	 <20250415115213.291449-2-elena.reshetova@intel.com>
In-Reply-To: <20250415115213.291449-2-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5265:EE_
x-ms-office365-filtering-correlation-id: 77d15511-cfb6-4a02-41ba-08dd7cd21331
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K2tEN2lVcXI5MnlqeHpZczBEbHNnWGROZFVTdEhHUFRaZEhxc0hpN0dOUTR1?=
 =?utf-8?B?MlZndXlaMXVmeGFLR2w4eHI5N2N3aGNrOGRYNGpPTXpFbXVDOC9wZjdxcUZt?=
 =?utf-8?B?UjJ2ZTdqUUJ0V3hvNVBIV1pzbFBydm9EcElQOGZla0pUZjJ2Y09hV1lJM2lJ?=
 =?utf-8?B?V3NLOWlTUjBqNloyS0JuV1QwZW5XdmU2dGc2R2Nma1piLzdEeVVTSTVTK3B6?=
 =?utf-8?B?c3dSUmt5ck5leEFwVGE3N0dUVjVHbGdzNWNqbHhZUEtrSldTQVFWaXd5MEZu?=
 =?utf-8?B?MnE2VjRQWDdkMC9DU2dqNHdkQ2pRVEF4KzZPTHVEVTl2YkpPM0hxQkVteElU?=
 =?utf-8?B?eVZFSnA1U2NBRjQxcS9ZbTFyWU9xNGJ5Yi9TUUZXQjdCL1dFTG10ZEpYZDZC?=
 =?utf-8?B?elBCOFh3RnluZER4SFNEcEdLWmlrRStrcy9IRFc4M29mYTB2Tmg0c1Jva2hl?=
 =?utf-8?B?VGJqdk9NdjNWZmV6Skt0eUE1OE9vUk1pc2dlUXRlUmNLMjd4UTlQSWRlWTBZ?=
 =?utf-8?B?T2JhTW40NlZZNXpWV0k3d0dVYnYwNDY2bWxUaWNZWGZGb0lXbzdNaFhDaFha?=
 =?utf-8?B?bzNvb0dJR3JpTG52RnpKTDdVRm50OGJKQVRSSys4dWg0TFBUa3hEb21IclhI?=
 =?utf-8?B?NmRaeDlUNXhEZ3FqK0VUOW9aUERFV1cyMWQ1V2dSMTFPQVA2SHZsdXczMGIr?=
 =?utf-8?B?TUQ1dks4dzYyR1lodS9JaFNYK3VZY2RkTzA4UHYrSzY5ZDJxb1VXaWFRZFFQ?=
 =?utf-8?B?a0wrNGNQc3QxanBSUXdhWUlDWVI2ay91M3h0SjBVVFQzM09URmh0eWErQlJI?=
 =?utf-8?B?bG9mVUhETkdFajZGU01udUpKd2ZnUk5tbEJ3QzBQNnNlSUVNMVVOZ2dwRXov?=
 =?utf-8?B?bUtRUVFJckZvWC9acU5DcDFwaVVrRWd2T01KY3p2OGlielZvK1BKTDlLLzBz?=
 =?utf-8?B?QVhETGFhYVRPN1pGVjBPUjVSdUtCS0tsQTQ1d0J2TWdPeVRncktCLzN4V1k3?=
 =?utf-8?B?RFlRN0hJOXk0S1R3MHdxV1dHTnpCUjFFdFRYbm1udm4xbUFXcmhHVXNlZzNt?=
 =?utf-8?B?V2drWm1Kc1JyRjNkcXRpdWQwZGNVSm8rTkNCZklhWlhOLzM3NGtJZllNOVYy?=
 =?utf-8?B?OFNXNHVYbHFoNFVsYzhVQWtJSVM0dGo2WUVBVEZsNUxlVEZnZWlyaVMwMnV4?=
 =?utf-8?B?Z1NzcmhkTVB5THQxdUFUZlAxalU0c1VHUUZhdXdubDR2MjNjenN6dlllQkdK?=
 =?utf-8?B?R2dCV0pzcEJMYlNQRkxBK0lIeDBUNUNVbThVYjVIWnVYdzlYcmJFTEdoNnpE?=
 =?utf-8?B?T0h2QnJwRXJaQVlnNks0bFR3N2xVRHNlY24xVzZnYzNiUUdQNUpsOUdrYnZX?=
 =?utf-8?B?TndDQnlOaWZNMGpucVdQMTdkWlN6ZmRzRENDbWFPZnFqbXExUjBEVXlJeHBM?=
 =?utf-8?B?WlFjb3VyeHM1UWpMNmZaUDRRMzJuOTNRZUNwTnNvV084TGxGWHlOYTFuRlFC?=
 =?utf-8?B?eUwxYWFwRWc5a1dRWnY3aFdVZTlSWElJNit0bWhLWnQ5Tk9hc2Y5NG9qUElM?=
 =?utf-8?B?V1lmLzlUQ2o1a2VFcXZ1ZXNQKzNHVlhOK1ZFbEwvUEpJU1lYTG5pZmNTLzhD?=
 =?utf-8?B?NllUU1JHSkp5Y0NzWHlyRFQrOERpUHlvUFVoVnRHdmFJUlRGN09Gb3VIU00y?=
 =?utf-8?B?bi9IalVtVzRjNURTZXhKSFJxZWRDYWpwZ3hQdjltOFZaMElna0dQRndEd05O?=
 =?utf-8?B?dUFrbktlVUlZNURqK2VUcXJ4UmRlK3dmWGlibGxwaTM1UWlESS83VHZDc2Fj?=
 =?utf-8?B?c2k5bVJ5dk1FUjRBcW5EVTVqaEZ1a3lDaHlhNU1vQnAxUVM4YkdjbWNnWDdW?=
 =?utf-8?B?T1dUeExwUUVYdDJxQk9EVjdRVmxDdEZLMVhraHplNHNGMUhnaXgwZU1qVTBi?=
 =?utf-8?B?WnJxVUU2SVZoRCtBRnZyRWFQaW9SbVlERnpReFQ0aC9kNldtTHA1dys4ZDNU?=
 =?utf-8?B?VEZ4ZmhaNDRRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0J6K1NYZkE2djBIN283emVsa0NycklkVE9mS3NWQXd2Tm1BTXBPUkhxWVFk?=
 =?utf-8?B?ajhDbnY4NTJldFJFRXhFQ2xGbTFOZHVLT01RWkI4WTk0Q01KMEVienZPUldW?=
 =?utf-8?B?OVJkUkxZTDF6STROUzd0ZkR4Q0ZQQjQyTDF1YWdpN1Q3WVFIWWlPcU52a0cw?=
 =?utf-8?B?dERpeXdRdTEzb21RQ3VIZVhGUEZ4Ry9zOFVlNmZnLzhEYytUd2pxQWplb0lk?=
 =?utf-8?B?bkIvcm94NWY1QUw2ekpPS01SN1ZFY0VNSzAvamNBbU51VE12WXRQUk5NWkNk?=
 =?utf-8?B?dUYxNCtqdzlHanBpa1RGMTFUY0t1U2E5SDNEZ1VZRkpLaFBGSEJQaGpQNmtO?=
 =?utf-8?B?bjFxVVU4Q1BGeXpUSUdoVjFqNzQvLzNrN2tTV2RvSmlydUsweTIxVE55N3Zx?=
 =?utf-8?B?WVEweWovUjYzWjBzNWRtZDFRcmZ1R284M1F2NDNVR3lyZkQ3SG1uNzRuOWJl?=
 =?utf-8?B?dzBSbUpOK2xTZTFhVkhwcGR5WVhoOXplT3E4MU5GVmpWc2ZUbHJOV01TaTFQ?=
 =?utf-8?B?dmtaSXBwemU5WDM3NW82S1YxODl2ck82YzVKM2pZNjNjQjNoUEM3Z295bTBp?=
 =?utf-8?B?TVloWURnVG9KOVpQSGtzZUtranY2L1ZCQ1pKcnlVbVFueGV1YmI1OG1GMmZJ?=
 =?utf-8?B?V0kxUGltY1dFbC9SczNKYVpXMklWeEEvcFQ2YjNyK1piNXJLT0xhekNkK2g5?=
 =?utf-8?B?cDN2eEMrdE5NUGxMQ29WMkg4MzhYanlkNU9IUUNzR3Z3RnlsM1ZUbjZxT01P?=
 =?utf-8?B?L0V1RHRhWFY5am1nblNCOUZuSndTQzZWYnFxb1Nucno4SDloeDlIV2FzaTUr?=
 =?utf-8?B?bGh4ZjhHdzllRmdPcXkyOGMweDFxL2gvSE9LdUZucG9nZVpFVVNMSTJ4SEg0?=
 =?utf-8?B?TEtzUVQ1cWIrVEFSK050Szc0eW9nYTlIQWNKemZsTk1maUtPbTVjMTN3NHps?=
 =?utf-8?B?bzJONm5rSFRzY3MvanFtMUhub0R6UHFOSmt2WGFEVlkxU3dweEsrbG5teDN4?=
 =?utf-8?B?dXpyUXREQUpzY09ZTTByQ0R2NjhMNHFrNEY2RnF1eWFldWZWbG5TS21rRmFI?=
 =?utf-8?B?eXFjUTlQN3Yvdy83c3hpOHNyWUo4dDZDU1hzTjhSMTdPOVpLMHJIZzUwK0pH?=
 =?utf-8?B?WEJmVGtYQU9VRWJxMFJXTHpuRzRkbUlTbE1mbE5aK2E1V2Q1bjJFdS9TVEU5?=
 =?utf-8?B?NFJYMnVnbUFwK0MzaVZSNGEyTVlYamdLSG9OWTg5SURyT3dscGRoZDdDSktu?=
 =?utf-8?B?WXNyTDNjeko2TTZndFlqSFlFL251NjViMlgxTDk4dVl5WjluTXZDNHZDcE11?=
 =?utf-8?B?L0UwVXZXWkF1d2taQ09mK2xLZXpwMFMveDNwYWJ2dldTZmZCRitQdldxZ0F4?=
 =?utf-8?B?d0xvVVFIc3RYL3JIRlEvODQwVWFuMEJEMzFsZStPczVzMFdydjFLWXprZ01i?=
 =?utf-8?B?OHhINUZxcFJwVkVVSDRGRlpQNWk5cFY1VWhTTFZEbzk0dVpTQW9TRGJMQW55?=
 =?utf-8?B?SWhLZ2RQMjVmZFZOSlNrS25tRHB3Qnc3L2dML0U4NTJaN28vejFMbWNGSkF1?=
 =?utf-8?B?V1EvdVI4cTlrQjhGaGh3OVRnOWZCRVp4QWluTHdsbmVPWSt5dW5saU1BSlIw?=
 =?utf-8?B?UmpGNGtYYk1tL2xINXFJZHRpL0MxZGNXalppK2I3L2xVMFlKVXBScUQ4bU9o?=
 =?utf-8?B?a1VJcWdoSklrc0c3V0lvRlUwek9kd0k4djV6NHh6VWVuNCtQamsrWUk1SFVZ?=
 =?utf-8?B?SEFpVHpZZlczdFlBVVBkaUhsdXlFOFA0SG4zMmUxRXo3VEJsTXVlZzhiN2Uy?=
 =?utf-8?B?b01CUktDTGJEWEFkTkkyNGlXeUZiUzM5VTBLemROVEhialRIdTUvR3pWN28z?=
 =?utf-8?B?UVpiU3o3bUVKRGlpUDJBaUpwakpmcTd4SUVQbU5VQ2FESEhjeUtza1NoelhE?=
 =?utf-8?B?UHNvNDlrWEVtQlNEZTRxcFFiK012ZjMvODlydzE5SkMxUDhQZWhSSGVvVCtw?=
 =?utf-8?B?bjZZV2JFRnVMZStuWDh4TGVrVXJ6bHhVb3VrWnBna0x6QUtLa2JNMUxXUzlw?=
 =?utf-8?B?UkdLQjhtdDRIcEs3dTF2azJQS3Q0aUM0aHFMTW0wWmVyeHFJVkRZQ1U2T3Rz?=
 =?utf-8?Q?SUGb3LxS/g+yJPtVXMNLd/l5N?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAB6AFEB1656F443A14DC0BE8D4268AE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77d15511-cfb6-4a02-41ba-08dd7cd21331
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2025 10:33:06.3140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TniJJIgZhWSQ0auIwvyyPK890h9xFDCV5AfQlCVLaWASerjr3us8YXHKu6E4fLUyaTR8YCBbddTg58w9dcL18A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5265
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA0LTE1IGF0IDE0OjUxICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IHNneF9ucl9mcmVlX3BhZ2VzIGlzIGFuIGF0b21pYyB0aGF0IGlzIHVzZWQgdG8ga2VlcCB0
cmFjayBvZg0KPiBmcmVlIEVQQyBwYWdlcyBhbmQgZGV0ZWN0IHdoZW5ldmVyIHBhZ2UgcmVjbGFp
bWluZyBzaG91bGQgc3RhcnQuDQo+IFNpbmNlIHN1Y2Nlc3NmdWwgZXhlY3V0aW9uIG9mIEVOQ0xT
W0VVUERBVEVTVk5dIHJlcXVpcmVzIGVtcHR5DQoNClRoZSBtZW50aW9uaW5nIG9mIEVOQ0xTW0VV
UERBVEVTVk5dIGlzIGtpbmRhIG91dCBvZiBibHVlIGhlcmUuICBJdCdzIGJldHRlciB0bw0KaW50
cm9kdWNlIGl0IGZpcnN0IGxpa2UgdGhlIG5leHQgcGF0Y2ggZG9lcy4NCg0KPiBFUEMgYW5kIHBy
ZWZlcmFibHkgYSBmYXN0IGxvY2tsZXNzIHdheSBvZiBjaGVja2luZyBmb3IgdGhpcw0KPiBjb25k
aXRpb24gaW4gYWxsIGNvZGUgcGF0aHMgd2hlcmUgRVBDIGlzIGFscmVhZHkgdXNlZCwgY2hhbmdl
IHRoZQ0KPiByZWNsYWltaW5nIGNvZGUgdG8gdHJhY2sgdGhlIG51bWJlciBvZiB1c2VkIHBhZ2Vz
IHZpYQ0KPiBzZ3hfbnJfdXNlZF9wYWdlcyBpbnN0ZWFkIG9mIHNneF9ucl9mcmVlX3BhZ2VzLg0K
PiBGb3IgdGhpcyBjaGFuZ2UgdG8gd29yayBpbiB0aGUgcGFnZSByZWNsYW1hdGlvbiBjb2RlLCBh
ZGQgYSBuZXcNCj4gdmFyaWFibGUsIHNneF9ucl90b3RhbF9wYWdlcywgdGhhdCB3aWxsIGtlZXAg
dHJhY2sgb2YgdG90YWwNCj4gbnVtYmVyIG9mIEVQQyBwYWdlcy4NCj4gDQo+IEl0IHdvdWxkIGhh
dmUgYmVlbiBwb3NzaWJsZSB0byBpbXBsZW1lbnQgRU5DTFNbRVVQREFURVNWTl0gdXNpbmcNCj4g
ZXhpc3Rpbmcgc2d4X25yX2ZyZWVfcGFnZXMgY291bnRlciBhbmQgYSBuZXcgc2d4X25yX3RvdGFs
X3BhZ2VzDQo+IGNvdW50ZXIsIGJ1dCBpdCB3b24ndCBiZSBwb3NzaWJsZSB0byBhdm9pZCB0YWtp
bmcgYSBsb2NrICpldmVyeSB0aW1lKg0KPiBhIG5ldyBFUEMgcGFnZSBpcyBiZWluZyBhbGxvY2F0
ZWQuIFRoZSBjb252ZXJzaW9uIG9mIHNneF9ucl9mcmVlX3BhZ2VzDQo+IGludG8gc2d4X25yX3Vz
ZWRfcGFnZXMgYWxsb3dzIGF2b2lkaW5nIHRoZSBsb2NrIGluIGFsbCBjYXNlcyBleGNlcHQNCj4g
d2hlbiBpdCBpcyB0aGUgZmlyc3QgRVBDIHBhZ2UgYmVpbmcgYWxsb2NhdGVkIHZpYSBhIHF1aWNr
DQo+IGF0b21pY19sb25nX2luY19ub3RfemVybyBjaGVjay4NCj4gDQo+IE5vdGU6IFRoZSBzZXJp
YWxpemF0aW9uIGZvciBzZ3hfbnJfdG90YWxfcGFnZXMgaXMgbm90IG5lZWRlZCBiZWNhdXNlDQo+
IHRoZSB2YXJpYWJsZSBpcyBvbmx5IHVwZGF0ZWQgZHVyaW5nIHRoZSBpbml0aWFsaXphdGlvbiBh
bmQgdGhlcmUncyBubw0KPiBjb25jdXJyZW50IGFjY2Vzcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IEVsZW5hIFJlc2hldG92YSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4NCg0KUmV2aWV3ZWQt
Ynk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0K
