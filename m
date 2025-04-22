Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53BA1632D7;
	Tue, 22 Apr 2025 06:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745305151; cv=fail; b=KjHE/mRR5R/geBTRANFUMW8f80UwjK2U5ySjLvx4tM1u49sex4MONzEBmxkPrdKjNiRBWsgWlwOvWwGZiVtXSwNhhmJadc/RnQP9dxAC9w3Yfhn+2kCmhbTgU7QttNxVdocyj3SLD7lss41OidJM2QU/m9uwrQf5bIEoPTcG8Aw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745305151; c=relaxed/simple;
	bh=YOU8YaTJXfIwz5n2yIHtkdeXWuG3mBWbozESU/zjoTY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=joRu3zlh/oA2j4kBmA4OXWwWogxWhEW+pYvR/8MIp8s4lLG1yB2okMoqTH90S727XoaBO+U6dhDh9ZCSA3Brgst5u5liTOkV6WiSJsdnE7x5YyBLJQ8fH6miKF4e6WLyZuC1jKkdupIjCXL7kxo2vbyOlaHlt9DccI0mGVhnoEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=USc+L9vL; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="USc+L9vL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745305148; x=1776841148;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YOU8YaTJXfIwz5n2yIHtkdeXWuG3mBWbozESU/zjoTY=;
  b=USc+L9vLn+P86iaDg9YnSHCkogLcMHSxTiUmUOrWqqFNX3NzUnKNCMMb
   2xNnND28CHELrO5vbwlVCfpmOYwot4fbe2zbIeOpO36vOpgKut5mYj24l
   +SPrSKoc99SwDnhQJ0Tc95vXtt92oi4/v+EmFy+wkJZK52gjmTySAo2ZU
   /eBn9oT2qBHCSSB/dZpxWm3Z+3IogswEJj7FYrOk/JRCT6CL4deAz+2Gy
   nPPJYDQMt4EKQXzaleSCEZJXbaZZjNJ3pK1xmU2SP2TgZx6BHbh6TbiIc
   t1grRPHG69p7cy3t01ImkpqVylPTjdJ9Psws1bUbTqxXJAoZONMVrc6ke
   A==;
X-CSE-ConnectionGUID: n5nFrAFJSUOCILGfvMjFqA==
X-CSE-MsgGUID: lsdiq7ExTFC7JbiSKIt5Mw==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="46859983"
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="46859983"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 23:59:08 -0700
X-CSE-ConnectionGUID: Sc8jEs2iTGaF+zjICvZBuA==
X-CSE-MsgGUID: PUU9zfZhRn2+3dtM224OOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="131925532"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 23:59:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 21 Apr 2025 23:59:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 21 Apr 2025 23:59:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 21 Apr 2025 23:59:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rM5FW065FZEaxi9z1x9bypGl1eKmDFNIAmLrwz1lvSBTKr8YGnIHoc6XSRQXsBeXO7gX7V5b477wlAnPrXEGFy21lBXMAyULjp40f3Q7Pw4RdZ0OAiRjOF45/kWhbp+3jMClQBQUXaRq47511WRMb8j08eFt8EXugkGJ0rIURk9r2WK5rdeQB/N2nbGLACeP5IlbBLnRLNoTA9EVgUh0iyDhoKy/QlprHbEywqjrapZ5xRv6IqxByqzBoTRBYlDJg/usUO6f4rTOzHtxu21mOV0mHtfp/D26mlzd1d2YEabLxpINBDscvsX8cUIrUMtwTddnK6DdLb6vnYwDPnRsOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOU8YaTJXfIwz5n2yIHtkdeXWuG3mBWbozESU/zjoTY=;
 b=fFJ7o8QBlv4haFec70q+VCS9L9nxQOA7UxK3zsnhRP4Wr9KvkVnuAY18egbABs2/xGpIhFuNE6JeP8WHHrf1+jC4F0+R1B7pwek6zj4G0xI0J7Va4Jk6mF9/i1w2LRp35TLhwdrfZXj2t2jmnm0hzlAcLxKdM2k7oQ03L5oSHWZjke5vzW3bWk14iru0e5vOqvJY9TQolPUg43kkV98UxekcyN1rS2ZTQ6fR7yjsrpyFldXz5UWXU8Q/1Hsf4DUey3COaZbBS5t1TBgtLWmoSDv2IA1iGglq/Apdhpk7py6ftxob3LnemBcGL3cktIOlbvsWGVT3+LCFj39QdE4imA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5026.namprd11.prod.outlook.com (2603:10b6:303:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 06:58:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 06:58:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Cai, Chong" <chongc@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Mallick, Asit K" <asit.k.mallick@intel.com>,
	"bondarn@google.com" <bondarn@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbrfz+Y/CHaQuxfEeQ0lhbNBYyWLOl6JWAgABLiQCAAYMCgIABxn0AgAXOTAA=
Date: Tue, 22 Apr 2025 06:58:29 +0000
Message-ID: <3ed3cb1e1b5790f167e45c6713d9eb75dfde251d.camel@intel.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
	 <20250415115213.291449-3-elena.reshetova@intel.com>
	 <11f7e006073d2a4fa8fd6c609024a69ed40af9d6.camel@intel.com>
	 <DM8PR11MB5750C80ED4AB80C696F581EFE7BD2@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <6bbfb38a0cd66af3d3562a82adac835316b1f4e5.camel@intel.com>
	 <aAJfJ38wt2bnguhg@google.com>
In-Reply-To: <aAJfJ38wt2bnguhg@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5026:EE_
x-ms-office365-filtering-correlation-id: 375b71e6-cee2-4f6e-958f-08dd816b16e5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b0MzRzZlUUV0MnR6QmJBeXBSVWhUSmxnOUl5YUZuMjhhYmlTZkRvZ3dGeHlE?=
 =?utf-8?B?eE1URS8vdDBlS3Q5Z0MxRUExVlgxTTNySUhSMGNNd3RxOXFQN3d1YVVuSnFn?=
 =?utf-8?B?N2Q4bzNmdjI1aU5IaU0xSVZnZDNvUDVaYUcrbm5hQTRvRy9OVWdsTDU1MEpr?=
 =?utf-8?B?QTd0UG0zVmoxR0xxbnlXUW1MUkt2NmRSeDJsUHFwbjBhekdTaG1IcEp5ajRU?=
 =?utf-8?B?SE45akorZnpYQ1VUTWJKOWJYc3RDNXp2U3hqN0tSWHVnanFrQnVSdFNRRWlX?=
 =?utf-8?B?NjNRYUpmbmtEcU0vMW13ZlRaa0NHY0UrVEZ3SHplYWI5SUtXb0ZTNGF1OVFX?=
 =?utf-8?B?OHUvWERUT1I4UjJSRk4yY2dybFA2c3ZBcUNsWWIzMjluSVRESkZudThrUGJ2?=
 =?utf-8?B?Zmc1RXFKZGE3a2lpZitmYWVwL1pZOTJqUmtNeW0xMUh4RVpKaXo0M1VhS3JP?=
 =?utf-8?B?dHRRTzhpZWFRWHdiZGtjV0U3Zk14NEhLbnFUWFdBVU1zcEZYMFNEOE00emFo?=
 =?utf-8?B?NmJkR0pmNXlERWI1WVZtYzZRTkNUZkF2Z3dLT1Y2a0NGL3EyNFlsT0lzdGR0?=
 =?utf-8?B?TG8rUVVNYzBsQjBiVHZLWCs1ektKRU1BNDgxcVJEM01nczJYWm9lYW4wTW1K?=
 =?utf-8?B?MWdRNDhJd21OTzdGN0I4dm1zMzdJQmdtdkRpMU9QdUdqRHhoWlhPNjdKdE81?=
 =?utf-8?B?TUFxZHE5dUpuWUVlc0hXZHBPRDNhbGJIY0lMM2ptUVVQNzBnQTNsUmtoaHRG?=
 =?utf-8?B?ZTFudXI3aUlycFkrVGxBZjJsYlY2L1dWb3g4MGRZbTJLY2RQVUFhS0FXd2JZ?=
 =?utf-8?B?dzNiR1h1bmEvUEpYdkJtbkhUNXdtZkhicEZ6OTFxcVJhWUhRd1VTT09EbW5R?=
 =?utf-8?B?MGJkUUoxS0FOWEdFbXZ0cjNGYmRnSG9BcnpsR3BlZmZBTEdZeGdWM2xYQUtn?=
 =?utf-8?B?RXBCRzJFd2NpQ3BXT0t6OU9KcTlCRElFbGlxZ29oWUNpaVpTWXg3Z0ZDUHlj?=
 =?utf-8?B?OHR5UnNvZC9vbWNDWFZDYXVqWW52VU5tanJnZkFUWmZCWndyWGdSUDBvc0pa?=
 =?utf-8?B?ZitTQUNTKzhsNWQ3T1RJdnhNaHBNRStBVUFKVStDOEdwSTVqb0lIRHVMeHRi?=
 =?utf-8?B?QU5UYnpHNTV3YklGWUxTZU1nM25la0wrOU1rYkp5NGFlT1RRb2EyQTNXQUo4?=
 =?utf-8?B?KzRkZnhqME5aQ21nZ0wxc0I3c2x1S2RTbjdQWjE2dHRNQmtEVS9lTFpsdmVt?=
 =?utf-8?B?cHpDL09ibTcxVFhlbkFIdWNNZXhPM3NrWTcwU0d1b0p4YXMyTEE5UkxkTFlV?=
 =?utf-8?B?K2FNMnlUOEl3QUR6YlkxWmpDa0hFdjlRWEd1N2JidlFmOWdENHJBbzR5dmYz?=
 =?utf-8?B?b2xwNnRwYkM2THBiL1NrN0VTWERMSlorWXExcll6Y0s5aWtpZTd4L0pwcExZ?=
 =?utf-8?B?T09jQWZuZkxrWXFTSExoaEZaWlFlWUFhY0NYUTlEaTRWRC9jbDB4K1JxM2dr?=
 =?utf-8?B?ck1wc3hzdlAxOW1QOFFWdlB5a0dCL0dzQVBoek05QWw1cU40emJpd1Q1c3p4?=
 =?utf-8?B?bUIyNnNkMXlrdFB2ZWZsQUp3elJROEVOaFZ4TEhreDhuU0ZMaDhjSzZmUi84?=
 =?utf-8?B?Z00wbm5JRnhaWmFhaFNxMk9EYVpjR0NJc2hMeG1vRXBPSDdYTDgreWk1ZFdW?=
 =?utf-8?B?ZVpKUlVaelVyN2d6bkV1V2I3QnVRdlUwN1pJT0JxVnJPaTFwS3FGWmFNUHNy?=
 =?utf-8?B?eS9hZUZSSGRKTXRGQUFPdE9HSlN4QnN0L0duY1ZCaEVjblRtU0RHajAyejlv?=
 =?utf-8?B?aVZJS0J3c3BQZ2hTUjFqR3NoRERTRG5GWWIvVFJydnBHKzFkeGw4ZjBnTDZY?=
 =?utf-8?B?ei9ZS3djRHMweWlReGJSbXlwYmk2Y1B2Y0FzNjBRZ09SM21xU291MWFvL1F0?=
 =?utf-8?B?eGZXUWlGZjlkeW5OeEtTQ2N5ejVrNkRabk1MVGlGQW5TeVRLTWRMUWhqMXFU?=
 =?utf-8?Q?Rxt5DseZlBdXJnCLrEMPUC+LbjQpaY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0RPQzA0YXNwSDFIU3Jwd09rME1STTcvSHZGWXk2SC9jQ3YrK3NSL2hsVmZO?=
 =?utf-8?B?UFY3NW1NMjRhejVXY0dIaE51ZDdDOE4waGRPZ2pqenFKcFBNWlJrUE5ucmtK?=
 =?utf-8?B?NWlyVDl1RjRmbzRFL0dmbzlrRDlhUG5LR3hMS1RkMmkzR2NiMWljY1NmM1Qz?=
 =?utf-8?B?c1ZOcDlDR3hKK3JuYkgyMCtuaVJwM0YzaEs2Tkk3Q0kyNUF1dlA3UTlyK2Iv?=
 =?utf-8?B?Mmt2UEZwc0lMbE1XczdKRXdmYjQ1TWRrVFZoODdyRVVzVmFzRXNTRlZRKzB0?=
 =?utf-8?B?NlRpeTljUlpKUHJ1dkVndDBmbGJubFkydXQ5cWVPMFZvM3IybnlRZVBTa2Z3?=
 =?utf-8?B?dlFmMlVNbmdZWjVGdG1vVVEvbDBIa1I5OWlCMDlrSnF3Tjg2VHNnT2Z0dS83?=
 =?utf-8?B?U3BVd2pIWTBENXoyeDhNTXI0aTZmd0huS29FR045dkh5bHdpYlZTcmh5Z1kr?=
 =?utf-8?B?dnQ3bTFPQ2ZQWXBKRmZCeVpqNVZNYVJxMXo0Y0g2QmJ5dW0rcU9lZWdDeGtW?=
 =?utf-8?B?cnVseXh2UkNmdW9oTE1MWnk0dXJnWXhsRmxFM1BxMFRGbXJvTi9KdGxtVTNk?=
 =?utf-8?B?ZWhEaTl4VGhMczlib0JTNUlWbVVoeVJ2RzdrY1IrelpNRGltY0FJRVpGZnk0?=
 =?utf-8?B?NUpaZ3p0TitYc1BsN2E3VDI1a29EYlJ0VndhTUJtR25aUFJnQm5Od1JZbDNK?=
 =?utf-8?B?L3pHb2Mxb2RPSjMwMjRqOE5DVExZNC82QkR1UFEyN2h1alBKTlI3Z2gwOFNa?=
 =?utf-8?B?c3ZrMDA0eUp0ZjU0cXgvRUFTY2JZNnJUOUZ2UGt0QkRjWXdrYWpFd1hQS0Nt?=
 =?utf-8?B?WHY0b0dUdCtSaTZja1Y5RjBBZ005OXJJUmNGejEzcEp4QWY5b040YnplcXRJ?=
 =?utf-8?B?Vy82TjdvUUpLTGVrRmhoenBWZzBTZ3h2MkFPMm1Yc3ovSjFsYjlmczYwQXpS?=
 =?utf-8?B?cFJMTkxpQjR5SHVnd0tjUTlKU1pQY0NaQUlXdzQ4WFZSV3ZJU2JMS2hBQ2Rm?=
 =?utf-8?B?ZzQrZTJmcVoyRGR6VWVRQXRvOS9iM3prWThYMXhVWVVrNDNLdTBKMkVhbVBt?=
 =?utf-8?B?ODUyWFZSTEhkLzZkQ0tkU0ZkYkNSREwrRlJMazJCMkdyQ0hSdUo3ZTVSRWVy?=
 =?utf-8?B?b2wzOXJQUEFKUnJ0TVJEY0FKUWxHVGhHQnN3WnpHcnVQOUpGUGdzNDRvcWhT?=
 =?utf-8?B?WllxUmlRak1VTVFIU3ZqYm12aFkxaDJiUS90bWFxUVFmSGdSVU82NmROZW9r?=
 =?utf-8?B?YjZlR3JMK0N4WmlDcUl0SGcvZnoraFZmbjhQNjd4NDNka2RJYU5DVVc5bnNt?=
 =?utf-8?B?dHVlVy9BaUI3NjRpVjJOaU91QTFTTmVqKzF3Sm1KcXQxblo5U0E2K2V2dVh1?=
 =?utf-8?B?QmtUeDJJTFhnTEY0TGQ3dnFySGNDQzBqVlB0a3JYbVRJaCtMR0ZMVVBaSmNH?=
 =?utf-8?B?U0JjMW1JcFdlL0V0UXkxREo1em1NU1pqbXZsYWc5dDN4YWk4MHRSY3FBNlEz?=
 =?utf-8?B?dFg5ZHhsaVY2OThtKzlndjhTYWFWN05JTVZCOTBYdlhhOE1qTkxyWnBnZk1Q?=
 =?utf-8?B?MUJqQUMzeU9VbUNnMEF4MUI4L1JTMnVhcndRcGpDY2JkdTJvNFo1TUxNNm92?=
 =?utf-8?B?SmhlQ2tJZ0pGMXhSZEJRUjdkODZQZ2pHcVN5djE2eFNzQkc5QUtlcjA4Ry9j?=
 =?utf-8?B?RFNraGs0MlBZVnQwT1cxVmc5QlNGUFozdU1xV3FweVB5eGM5ZXhqK1hVa003?=
 =?utf-8?B?NjFORm1zdkZzSFV3d3ZFOU04VU9lWHlrWEp4V0xKRnhHOG9FNGl4ZDMyUllu?=
 =?utf-8?B?VzVmZ2RvV1dJWXhySXl0SUNRUlB0NURnaklPS21DRVMza2UxaFJGQVRDYTVE?=
 =?utf-8?B?VHREUHV1a05FSDZHV1hQVXAyQThkQUcwQnR4aUtJaWowT01FdEFHZHR1R0VO?=
 =?utf-8?B?a2hYN0dPaHpQdytCQStwWHpSNHdGb01UVWtpcUdua253YWF3dkVMaU0vekdW?=
 =?utf-8?B?NVpJbUNnUE5peWZmR05HSTV0Tld2VmcxUEdoZ3BJL3d1KzF6ZlpPWjRlVUVk?=
 =?utf-8?B?QnRRRm4zQ3ozQkZtQTlxakMyRlptTGd4OFF5OG1jOVB2cFNmQjB5dVc2VlZ1?=
 =?utf-8?Q?y0ol06dsPUUa/G6GTXEOZ3b0S?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D7C9F133E80554FB8C3A13B103C42BE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375b71e6-cee2-4f6e-958f-08dd816b16e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 06:58:30.1993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1v3ZcRlLLyR+CZRT9XXJBbqTORf5iINYoAGPotNcVRbnTSGUl4YxZDp8mFXFhIK1WaiforbXpvncTPlUrWr/6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5026
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA0LTE4IGF0IDA3OjE4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAxNywgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IEkgdGhp
bmsgdGhlIHNneF91cGRhdGVzdm4oKSBzaG91bGQganVzdCByZXR1cm4gdHJ1ZSB3aGVuIEVVUERB
VEVTVk4gcmV0dXJucyAwIG9yDQo+ID4gU0dYX05PX1VQREFURSwgYW5kIHJldHVybiBmYWxzZSBm
b3IgYWxsIG90aGVyIGVycm9yIGNvZGVzLiAgQW5kIGl0IHNob3VsZA0KPiA+IEVOQ0xTX1dBUk4o
KSBmb3IgYWxsIG90aGVyIGVycm9yIGNvZGVzLCBleGNlcHQgU0dYX0lOU1VGRklDSUVOVF9FTlRS
T1BZIGJlY2F1c2UNCj4gPiBpdCBjYW4gc3RpbGwgbGVnYWxseSBoYXBwZW4uDQo+ID4gDQo+ID4g
U29tZXRoaW5nIGxpa2U6DQo+ID4gDQo+ID4gCWRvIHsNCj4gPiAJCXJldCA9IF9fZXVwZGF0ZXN2
bigpOw0KPiA+IAkJaWYgKHJldCAhPSBTR1hfSU5TVUZGSUNJRU5UX0VOVFJPUFkpDQo+ID4gCQkJ
YnJlYWs7DQo+ID4gCX0gd2hpbGUgKC0tcmV0cnkpOw0KPiANCj4gVGhpcyBjYW4gYmU6DQo+IA0K
PiAJZG8gew0KPiAJCXJldCA9IF9fZXVwZGF0ZXN2bigpOw0KPiAJfSB3aGlsZSAocmV0ID09IFNH
WF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSAmJiAtLXJldHJ5KQ0KPiANCj4gVG8gbWFrZSBpdCBzdXBl
ciBvYnZpb3VzIHRoYXQgcmV0cnkgaXMgb25seSByZWxldmFudCB0byBsYWNrIG9mIGVudHJvcHku
DQoNClllcCBsb29rcyBiZXR0ZXIuDQoNCj4gDQo+ID4gCWlmICghcmV0IHx8IHJldCA9PSBTR1hf
Tk9fVVBEQVRFKSB7DQo+ID4gCQkvKg0KPiA+IAkJICogU1ZOIHN1Y2Nlc3NmdWxseSB1cGRhdGVk
LCBvciBpdCB3YXMgYWxyZWFkeSB1cC10by1kYXRlLg0KPiA+IAkJICogTGV0IHVzZXJzIGtub3cg
d2hlbiB0aGUgdXBkYXRlIHdhcyBzdWNjZXNzZnVsLg0KPiA+IAkJICovDQo+ID4gCQlpZiAoIXJl
dCkNCj4gPiAJCQlwcl9pbmZvKCJTVk4gdXBkYXRlZCBzdWNjZXNzZnVsbHlcbiIpOw0KPiA+IAkJ
cmV0dXJuIHRydWU7DQo+IA0KPiBSZXR1cm5pbmcgdHJ1ZS9mYWxzZSBpcyBjb25mdXNpbmcgc2lu
Y2UgdGhlIHZhc3QgbWFqb3JpdHkgb2YgdGhlIFNHWCBjb2RlIHVzZXMNCj4gJzAnIGZvciBzdWNj
ZXNzLiAgQSBsb3Qgb2YgY2xldmVybmVzcyB3ZW50IGludG8gc3BsaWNpbmcgU0dYJ3MgZXJyb3Ig
Y29kZXMgaW50bw0KPiB0aGUga2VybmVsJ3MgLWVybm5vOyBpdCB3b3VsZCBiZSBhIHNoYW1lIHRv
IGlnbm9yZSB0aGF0IDotKQ0KDQpBZ3JlZWQgOi0pDQoNCj4gDQo+IEUuZy4gdGhpcyBsb29rcyB3
cm9uZyBhdCBmaXJzdCAoYW5kIHNlY29uZCBnbGFuY2UpDQo+IA0KPiAJCQlyZXQgPSBzZ3hfdXBk
YXRlc3ZuKCk7DQo+IAkJCWlmICghcmV0KSB7DQo+IAkJCQkvKg0KPiAJCQkJICogc2d4X3VwZGF0
ZXN2bigpIHJldHVybmVkIHVua25vd24gZXJyb3IsIHNtdGgNCj4gCQkJCSAqIG11c3QgYmUgYnJv
a2VuLCBkbyBub3QgYWxsb2NhdGUgYSBwYWdlIGZyb20gRVBDDQo+IAkJCQkgKi8NCj4gCQkJCXNw
aW5fdW5sb2NrKCZzZ3hfZXBjX2V1cGRhdGVzdm5fbG9jayk7DQo+IAkJCQlzcGluX3VubG9jaygm
bm9kZS0+bG9jayk7DQo+IAkJCQlyZXR1cm4gTlVMTDsNCj4gCQkJfQ0KDQpZZXAuDQoNCj4gDQo+
ID4gCX0NCj4gPiANCj4gPiAJLyoNCj4gPiAJICogRVVQREFURVNWTiB3YXMgY2FsbGVkIHdoZW4g
RVBDIGlzIGVtcHR5LCBhbGwgb3RoZXIgZXJyb3INCj4gPiAJICogY29kZXMgYXJlIHVuZXhjZXB0
ZWQgZXhjZXB0IHJ1bm5pbmcgb3V0IG9mIGVudHJvcHkuDQo+ID4gCSAqLw0KPiA+IAlpZiAocmV0
ICE9IFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSkNCj4gPiAJCUVOQ0xTX1dBUk4ocmV0LCAiRVVQ
REFURVNWTiIpOw0KPiA+IA0KPiA+IAlyZXR1cm4gZmFsc2U7DQo+ID4gCQkNCj4gPiANCj4gPiBJ
biBfX3NneF9hbGxvY19lcGNfcGFnZV9mcm9tX25vZGUoKSwgaXQgc2hvdWxkIGZhaWwgdG8gYWxs
b2NhdGUgRVBDIHBhZ2UgYW5kDQo+ID4gcmV0dXJuIC1FTk9NRU0gd2hlbiBzZ3hfdXBkYXRlc3Zu
KCkgcmV0dXJucyBmYWxzZS4gIFdlIHNob3VsZCBvbmx5IGFsbG93IEVQQyB0bw0KPiANCj4gTm8s
IGl0IHNob3VsZCByZXR1cm4gYSBtZWFuaW5nZnVsIGVycm9yIGNvZGUsIG5vdCAtRU5PTUVNLiDC
oA0KPiANCg0KT2ggSSB3YXMgYWN0dWFsbHkgdGhpbmtpbmcgdG8ga2VlcCBfX3NneF9hbGxvY19l
cGNfcGFnZV9mcm9tX25vZGUoKSByZXR1cm5pbmcNCk5VTEwgaWYgc2d4X3VwZGF0ZXN2bigpIGZh
aWxzIChnaXZlbiBpdCByZXR1cm5zIHRydWUvZmFsc2UpIGFuZCBtYWtlDQpzZ3hfYWxsb2NfZXBj
X3BhZ2UoKSByZXR1cm4gLUVOT01FTS4NCg0KU29ycnkgZm9yIGRpZG4ndCBzYXkgZnVsbHkuIDot
KA0KDQo+IEFuZCBpZiB0aGF0J3MgdGhlDQo+IGJlaGF2aW9yIHlvdSB3YW50LCB0aGVuIF9fc2d4
X2FsbG9jX2VwY19wYWdlKCkgc2hvdWxkIGJlIHVwZGF0ZWQgdG8gYmFpbCBpbW1lZGlhdGVseS4N
Cj4gVGhlIGN1cnJlbnQgY29kZSBhc3N1bWluZyAtRU5PTUVNIGlzIHRoZSBvbmx5IGZhaWx1cmUg
c2NlbmFyaW86DQo+IA0KPiAJZG8gew0KPiAJCXBhZ2UgPSBfX3NneF9hbGxvY19lcGNfcGFnZV9m
cm9tX25vZGUobmlkKTsNCj4gCQlpZiAocGFnZSkNCj4gCQkJcmV0dXJuIHBhZ2U7DQo+IA0KPiAJ
CW5pZCA9IG5leHRfbm9kZV9pbihuaWQsIHNneF9udW1hX21hc2spOw0KPiAJfSB3aGlsZSAobmlk
ICE9IG5pZF9zdGFydCk7DQo+IA0KPiBUaGF0IHNob3VsZCBiZSBzb21ldGhpbmcgbGlrZToNCj4g
DQo+IAlkbyB7DQo+IAkJcGFnZSA9IF9fc2d4X2FsbG9jX2VwY19wYWdlX2Zyb21fbm9kZShuaWQp
Ow0KPiAJCWlmICghSVNfRVJSKHBhZ2UpIHx8IFBUUl9FUlIocGFnZSkgIT0gLUVOT01FTSkNCj4g
CQkJcmV0dXJuIHBhZ2U7DQo+IA0KPiAJCW5pZCA9IG5leHRfbm9kZV9pbihuaWQsIHNneF9udW1h
X21hc2spOw0KPiAJfSB3aGlsZSAobmlkICE9IG5pZF9zdGFydCk7DQoNCklmIHdlIHdhbnQgdG8g
YmFpbCBvdXQgaW1tZWRpYXRlbHksIHRoZW4gcGVyaGFwcyAtRUlPIGlzIGEgYmV0dGVyIG9wdGlv
biBpbnN0ZWFkDQpvZiAtRU5PTUVNLiAgQW5kIGluIHRoaXMgY2FzZSBzZ3hfYWxsb2NfZXBjX3Bh
Z2UoKSBjYW4gYWxzbyBiYWlsIG91dCBlYXJseToNCg0KLS0tIGEvYXJjaC94ODYva2VybmVsL2Nw
dS9zZ3gvbWFpbi5jDQorKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCkBAIC01
NjksNiArNTY5LDkgQEAgc3RydWN0IHNneF9lcGNfcGFnZSAqc2d4X2FsbG9jX2VwY19wYWdlKHZv
aWQgKm93bmVyLCBib29sDQpyZWNsYWltKQ0KICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7
DQogICAgICAgICAgICAgICAgfQ0KIA0KKyAgICAgICAgICAgICAgIGlmIChQVFJfRVJSKHBhZ2Up
ID09IC1FSU8pDQorICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcGFnZTsNCisNCiAgICAg
ICAgICAgICAgICBpZiAobGlzdF9lbXB0eSgmc2d4X2FjdGl2ZV9wYWdlX2xpc3QpKQ0KICAgICAg
ICAgICAgICAgICAgICAgICAgcmV0dXJuIEVSUl9QVFIoLUVOT01FTSk7DQoNCj4gDQo+ID4gYmUg
YWxsb2NhdGVkIHdoZW4gd2Uga25vdyB0aGUgU1ZOIGlzIGFscmVhZHkgdXAtdG8tZGF0ZS4NCj4g
PiANCj4gPiBBbnkgZnVydGhlciBjYWxsIG9mIEVQQyBhbGxvY2F0aW9uIHdpbGwgdHJpZ2dlciBz
Z3hfdXBkYXRlc3ZuKCkgYWdhaW4uICBJZiBpdA0KPiA+IHdhcyBmYWlsZWQgZHVlIHRvIHVuZXhw
ZWN0ZWQgZXJyb3IsIHRoZW4gaXQgc2hvdWxkIGNvbnRpbnVlIHRvIGZhaWwsDQo+ID4gZ3VhcmFu
dGVlaW5nICJzZ3hfYWxsb2NfZXBjX3BhZ2UoKSByZXR1cm4gY29uc2lzdGVudGx5IC1FTk9NRU0s
IGlmIHRoZQ0KPiA+IHVuZXhwZWN0ZWQgaGFwcGVucyIuICBJZiBpdCB3YXMgZmFpbGVkIGR1ZSB0
byBydW5uaW5nIG91dCBvZiBlbnRyb3B5LCBpdCB0aGVuDQo+ID4gbWF5IGZhaWwgYWdhaW4sIG9y
IGl0IHdpbGwganVzdCBzdWNjZWVkIGFuZCB0aGVuIFNHWCBjYW4gY29udGludWUgdG8gd29yay4N
Cj4gDQo+IA0KPiBTaWRlIHRvcGljLCB0aGUgZnVuY3Rpb24gY29tbWVudCBmb3IgX19zZ3hfYWxs
b2NfZXBjX3BhZ2UoKSBpcyBzdGFsZS93cm9uZy4gIEl0DQo+IHJldHVybnMgRVJSX1BUUigtRU5P
TUVNKSwgbm90IE5VTEwsIG9uIGZhaWx1cmUuDQoNClJpZ2h0IDotKQ0KDQpUaGFua3MgZm9yIHNw
ZW5kaW5nIHRpbWUgb24gcmV2aWV3IQ0KDQo+IA0KPiAvKioNCj4gICogX19zZ3hfYWxsb2NfZXBj
X3BhZ2UoKSAtIEFsbG9jYXRlIGFuIEVQQyBwYWdlDQo+ICAqDQo+ICAqIEl0ZXJhdGUgdGhyb3Vn
aCBOVU1BIG5vZGVzIGFuZCByZXNlcnZlIGlhIGZyZWUgRVBDIHBhZ2UgdG8gdGhlIGNhbGxlci4g
U3RhcnQNCj4gICogZnJvbSB0aGUgTlVNQSBub2RlLCB3aGVyZSB0aGUgY2FsbGVyIGlzIGV4ZWN1
dGluZy4NCj4gICoNCj4gICogUmV0dXJuOg0KPiAgKiAtIGFuIEVQQyBwYWdlOglBIGJvcnJvd2Vk
IEVQQyBwYWdlcyB3ZXJlIGF2YWlsYWJsZS4NCj4gICogLSBOVUxMOgkJT3V0IG9mIEVQQyBwYWdl
cy4NCj4gICovDQoNCg==
