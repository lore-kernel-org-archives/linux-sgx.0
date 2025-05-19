Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906B02580D5;
	Mon, 19 May 2025 11:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747655024; cv=fail; b=mFId97WrudrtFW6UT7ukVvpDhCAWa9EUcP/TLgvb3dW1atyJxk1z8bGs/iM6877I99Gsxt8k04eb3OsOKcW5+J7DCbkHbLSK9dTEQ+pyTD9Id3It1hp6IOrCzYhbPUmxe/Y7eHZwl+ZuWnr16h4NRbzCQpFRTqfV0zHJ1L1oa8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747655024; c=relaxed/simple;
	bh=wEdv4svs/64eEqkGAUSBrUuNj8zC/ZErT8I88h8Bo6o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JW85PoYGoda4jR3QeM2TgtVoG+/kjy3GWnafr2ydWMTgP+NJReWlioFUem9LwQcINOcz8H1NehFHFAzKy1e5RfmUfA1TsYqwsa+96CczibdVWCoR7lMKNo50kZxETI3sHnUt3e9wpfaDMRttNiUkBJzb5Pdik0JSkSXrsbtY+S4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MemUlwBf; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MemUlwBf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747655022; x=1779191022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wEdv4svs/64eEqkGAUSBrUuNj8zC/ZErT8I88h8Bo6o=;
  b=MemUlwBfc+28g48f0L44fMcEY/XduHtjvNhM3ZYzZDXzJ/tsjF0JcGds
   EbWaedm60bKppGa7slex3HGaZC9ozh1wXaq6Td1SUJO+NhUAtA/bLw8l/
   HCf7+5pJtH0BMZATQ5A+ewt//9e3nrDi/QlnO2tHz7cyKAb9c+kTBfmPk
   9Pcdm9e+JG4zt3VoItEndpStZuAL6wTy28bm12EBgr3E5vwVpj4MevyC3
   YO3/xI7CVjPFGqb9fj7NfV05BKQ3xPjSI+yPLWT+H5e4jh+ESD0fx1ypy
   oRUJ+Ty3K8KkEgVgUCbtfUO5S4oUoaB4syINsSzfosAJQqND/mL4rrX8K
   Q==;
X-CSE-ConnectionGUID: iVoAO+qoSzm/W9xcFGwrZw==
X-CSE-MsgGUID: 9019PBQYSpqQ70RQFiE7JA==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="60203846"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="60203846"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:43:42 -0700
X-CSE-ConnectionGUID: 0VuepyjBQ+KQhY4u6tRbKg==
X-CSE-MsgGUID: 968ws2VuSzmuJDKcFI6Egw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139247879"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 04:43:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 04:43:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 04:43:41 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 04:43:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LKASHK7cgKj8B5Y1YukkCHu03n54byroeMunIrj2HOhjxtelvo2ztGJkCKS+8fi6XIOOwRLzy3kJ9qBXQ3uZ9IvhtT79BktvYzYtL4kZLTDdzXNwNhqvAfZ/PROuwlBhjG00UYTTNupq9jpQx4gWC9X1QNS0dPDgFxLKfuMjSBM0RTR+MCNq5Ytvqhjqbp4bJqFwAs5e7tw4uwNUr25YrG6xqRQyEIalcgdBDcjr3GfCx6pN9qlotjr0CFXv37RPZl55bQYyCg+cbAK9p2lC1c+8IcbkC/ZvO86vJEQmSbBVKPsi+p4j0isNq2pWfYttXoBbL7bD+jLpMGHkwlrGtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEdv4svs/64eEqkGAUSBrUuNj8zC/ZErT8I88h8Bo6o=;
 b=CynlFs/ZqfxO2lrv/h7mPdGl7U7f2m9eG4Hm+ws9AvXZkaCJa/ARtBtFv9XQPUuZSxhCE7TPAVYz91Hu7kBab0GREc3XqhTCoK32NwFFpy1be2W2Gi79EV8chOZb37YjW9RKcPEPVSoBb5Op5mKqh8a8olX2+y35QZuPJk5JEDcxivFifKTdqux4gfei+oQOuHxLjGo1/9hb7CkTkoj7i7oOKCS/fHN29FQfcg5IUJDV7oVanjDVVDrcG3vbBfv+yCSPi7f/UfzVEcFUQ0+xYCAHM3t/ET10aRznfwDFm0Njq3lojYg9qvR0qPMooSsIK3Ov/LdUlBQEMpFqJc86iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 DS0PR11MB7958.namprd11.prod.outlook.com (2603:10b6:8:f9::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Mon, 19 May 2025 11:43:36 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 11:43:36 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "Raynor, Scott"
	<scott.raynor@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Mallick, Asit
 K" <asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Cai,
 Chong" <chongc@google.com>, "bondarn@google.com" <bondarn@google.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>
Subject: RE: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Thread-Index: AQHbyI9kSVxmTXaknEyFmJx4IavRXLPZxbaAgAANUACAAAI6oA==
Date: Mon, 19 May 2025 11:43:36 +0000
Message-ID: <DM8PR11MB57509F762DA67BE80165103CE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
		 <20250519072603.328429-2-elena.reshetova@intel.com>
	 <c955515c5469dae17faa13ebda28459d7c998bb9.camel@intel.com>
 <84b0b4eab4444f6ddb407aee602826020a6f7e6f.camel@intel.com>
In-Reply-To: <84b0b4eab4444f6ddb407aee602826020a6f7e6f.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|DS0PR11MB7958:EE_
x-ms-office365-filtering-correlation-id: a13d716e-0d1b-48cc-ba9f-08dd96ca642f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|10070799003|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z2FWQ09wMzVDQ0xUcFVyS0dEeUEyT1QzdjJXbHFzeUtxdlQwWHFjVHRVNC9n?=
 =?utf-8?B?TGFFNHB1TjJSK0hpb3ppUDRuMytxSXVsekE0QmUyOU83MlRaYnJXS0J5eFRQ?=
 =?utf-8?B?Zm9CdEFSdlNmcnZXN0k0VHhnK0pXcmpuNjJVakwvNm9hbVE1MnhsQkhXN1Ju?=
 =?utf-8?B?TjVTYjhjTEoxZlhHd20yT0IrYWI2MkNRZzRQZVRDRmMxaXE4NW1QK2gzaDlK?=
 =?utf-8?B?RkFJQTlrdmpnTVlZVUJZT3lNL0F2Z0E5ZjdIdU91YzJMNDFsM3AyK3lmVjZ2?=
 =?utf-8?B?ZHJGTkRlS2pLajQ0SjBwNEp1RHFYa2E1T2R3ekU1R3laWEJXWUNtZzk1Z1g2?=
 =?utf-8?B?OVRLeEg4U1h3c0ZiS1BwVHhXcE1WVktFbC9qeEJlK1ErWHgyaUMwYzFqWG0v?=
 =?utf-8?B?N3NSeVZGRmp3LzJTcUMveU12enhEbllzUEdxMTFyb1lTcEhodDkwdTVrb3JZ?=
 =?utf-8?B?bUFiM080RnkwaVIvaUFRaVlCdVI5Zld3WHhyTXN4WXNhcksxbmRna0VqV0hi?=
 =?utf-8?B?b3NNN2VMOXVJL3NzN092NFBBTGQ3Mm4rLzhCSWczeFRqQXAxMzhObko1QnQr?=
 =?utf-8?B?OUZSMi9Zdnd4Wm1Ga0FUS1BzSVFaSlF6RWVxQWhkWHg2dHg2TzNvV1VUVVVH?=
 =?utf-8?B?OFlEMmZTTWVjeXVwL3lMNm16RHNYektzZUdoNW1td0hEVkN2SXBNdGxUSVR3?=
 =?utf-8?B?NURMOTVVR0RUTjBpclRDOGkwK3I2TTFaT2NRWFV0TExyc05odWc1cUdiWXMr?=
 =?utf-8?B?Qi9lQU1vLzRSSTB3WGVhRlppZXRpeE5SNGZFa2ZibmFkY2UwZDlZVm1UcHBG?=
 =?utf-8?B?Nm1vWlIrRGk3Z1hSRXIzZFhTQ3JzcFVvMHNzZDhJZUVOK1g2Q0xBMCtvVDFE?=
 =?utf-8?B?cW52QlU0d3BMYkhydlA3WDVUWVpuMmxsSXVnRkNoS2k4aCtvQmFYS0pWSDVj?=
 =?utf-8?B?YTNZY1NGZmpCcHNYMTdQT1IxU0ZzeXJuY2c1a3I2K2c0SjAyS1VNMis3VGhW?=
 =?utf-8?B?VktVNkh6UVVBUFdEMzJFbkhZUjBGLzhNZ0RwUDIyZGJFZlpSSXlGalhZa25r?=
 =?utf-8?B?aVpEYjAzZHdtS1FGT2htRTloMTNpMjl1Mkp6UlBGS3ZiQjRRbzhCOTk4M213?=
 =?utf-8?B?Qmp2TXRWS0RhOFk3WnNoTTRaTkdJY1lDWkpkeEhIdGhjTXo4VWxuN3l4dmho?=
 =?utf-8?B?K2tnN2VHSlBYMGx0T3Vjck45L08rMEc2cmREVElINU9YWEE1UHppSTNsUkhV?=
 =?utf-8?B?akY3RmIvMXJZd3YyUE9IUCthS3lqS1NjVFdjNmlYVDI5clRLRmgzcmFLRVVm?=
 =?utf-8?B?ZjVsUjFqb1pCMkwzNUg5cVZnaDJySStVUXZSbjloMnY5WWk0OXRuekJaUjVm?=
 =?utf-8?B?MnRzdXpMeE13ZWYzTi9wR1laN3NVWHYvQzZsejhjQ3JmR2djc1ZNWGpOTDRy?=
 =?utf-8?B?QTlvMi9iM1Y1U3J0ZU5hSU12Y1hiMzVUYUQwaTgyYVF6QklaMmxrbW1BVXpQ?=
 =?utf-8?B?OGZmSWNJQiszMFZlR3pWc2xEQXJhbkYvVDRJVE03Uk5TZXpydDRVeWEzV1ly?=
 =?utf-8?B?N0lsUEo0WUJtTkxPZDJFMm0vNE9VV09UNUoxR05CY3AxSnRudFNNQmFRbStV?=
 =?utf-8?B?Um90VnFFb0NRckE5M1hyWEtFbWphd2RXNkViamZyeXNDZW5QZ1R0Sm5ONFVG?=
 =?utf-8?B?anBVeDVPdXJMdzFBczk5TlhnTGdPRDR2d2dRdXlDb2Fnd2hmc0NXOXIzRVZH?=
 =?utf-8?B?ajNYWXZmdlFYbzZleVdVZDh6UGFldCt0bUNvelBwZVZnVmppNEtMdnlsbkhR?=
 =?utf-8?B?WFNablJGM2RwSXdmL2Z1cFlwKzlsdEFyL1pLUDVnTHJnWElRREs5WVUzWTN2?=
 =?utf-8?B?azViOWsvWjBpMTZ6VWlOZmEyeGZzYVNlQ1cvQTBVMm5XSnljdmY0Q3I3d2la?=
 =?utf-8?B?QmNSaUVncC95SG4zUUo1dmtDMlFoSjdqVXB5em1wY0lVazIyS2hJTmRrcDRY?=
 =?utf-8?B?VjQrbVU5MGx3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlJnNHZ5WWxmbGpIRW9mblk1T0txVkFxeEhJOXF3UHlxOWw4RVpYRXpGaEQz?=
 =?utf-8?B?M25CWWVlNm5TeXpaeVcvSmdaWDVjVks3SVhiWW9hYUhZdjJVTmY0S1ZkQTRO?=
 =?utf-8?B?d3VEcGhMY0NoZUx1Zm80NEVGYUlnVURpeEJKdTVySXJxOTJiQ3hyRWlqQ29L?=
 =?utf-8?B?N0o3c1B1SXJiMGdCZ2xKQjV6QmREZ0hnUTdmckpwVjl1Q1Q4REFWOXNHRlcv?=
 =?utf-8?B?cStoTjBUNnNBUEt3Q2w0aTg5amNmdnVOSnpvbkI2N0Z5bnVYN3ZpRlFJc1Zp?=
 =?utf-8?B?SSsyZHcrbVpGekkyenVNSEljN0dXblJQRkVvd0IvWkZXa1Y1STZnUUpXRzA5?=
 =?utf-8?B?WjhWVmRFbU82TDRQd1M5dVRLeUsydDFLOHVKOTU1bkVjVGVHQlBncUdWWWhl?=
 =?utf-8?B?Vk9ld1lzSm1oTDV4Vm1DdGZvMHlrVFI1K1Q2Y25JTGYvQWFHMTdOVk8vNWtS?=
 =?utf-8?B?SG16eWs5czFpTnp2YUpabE5PRDNnVmc2VHJYbGQ4L3VGWmxOQWRjdzBGQXRu?=
 =?utf-8?B?SDB1enExL05kemhDa3VhWlZEc3gyOVAxTlZUb2hUZVl5dTNtaFhBejRQQ09O?=
 =?utf-8?B?clVmM1lnbnFkb0Yrd0ErUE5WVmd2ZXJvaFYxZmNoRnk1OEFuT2dkQm9CRita?=
 =?utf-8?B?dDA4QWlDQjNmNFA4aE84NjFlY2VidHRKOFd1Y2pEYmY3dnZ3T2gvK09maGFj?=
 =?utf-8?B?eDdrOWxvRnE2SU1wYjZQdzJQYm1hUXA1SStRckxLQUR5cmxrSStGaXlqQkVP?=
 =?utf-8?B?NW1jNm9RTGw0UFlSV1puSTRzZURGRm9sZlRUSWpvd3lTQXpHblk0TlZEdGd6?=
 =?utf-8?B?UVpRb2tHQmVEWkpQTHVveXVFVTFFcG4vY1hiUFd6U0tjTlNqTFoxdWVUVHJz?=
 =?utf-8?B?WU5YakZmUnUvZUl5c1l0dWo2MU54enZDREF1bFh3RDBBQ3pvZlhtMEY3b2dV?=
 =?utf-8?B?WHlzUnhNY0ZhcVAzT01nWjhPb3I3Rk1iSElvU29YZDBVNUF5VGhtUFlPY1Yw?=
 =?utf-8?B?RnEyTGpiN08vSVF6RTlxRktNYVVyRjBkdjBpbzAwVGI3d1FRS3Z2SjZEYXYy?=
 =?utf-8?B?WXNFT1VkWFVpMUNwL0NNL2hRYXZKcks0NGpMaHlWZU9TVm9YbStaZjBJdnFT?=
 =?utf-8?B?N3h3UyttSWhpWWp3YnoraGN5UndHbHRoMVlHcE8yMGc1ZGJuZSs5K0huU3pY?=
 =?utf-8?B?dUJ6d0wvczlyQURrK0Z4WGU0MS9Jcis2L0lWbThpSytKQXMvbmZpdGZROFA3?=
 =?utf-8?B?L1pNSWl4dkVpVDh4N0VaWTF4TmgyRndZZ0JkenJqRzZFZ05UNTAxWUk3bmdu?=
 =?utf-8?B?N0R2MnR3TWxEbkw5Q3ZaTm1aaEw1WThKWS8yczlGVGtFRk1EdnYwKzFyZFc4?=
 =?utf-8?B?MUhMd2hTMmFwY2VUcDlKdkd2eVhrSUQ1MmdmdGZwRDZOWXBIcUVxUXhsdXIz?=
 =?utf-8?B?bFFPajI0ZzdHY3NpaDlWTjQ4YVJMRWlhZ2l2cWpPSDVkaXdvRUNiQkpPdUE1?=
 =?utf-8?B?T2JPdkdSMVJWU2p5TFdKenJYU0Q0cEVXRlg1UlRRcUkwTS9pUE5XRVpCS21M?=
 =?utf-8?B?YkFGc00vWE1ScE42VUhQTVZCd0h0YU1hK2Vka2V6Lzd1eGptSUIveUVxcXpX?=
 =?utf-8?B?eW1GSitwNGhKaUZwcXl5blFiZldobUtoOWpDaHNjMzlWeWtHaWVuQ0lUMVBh?=
 =?utf-8?B?RjR6eE02N2ZQNkcza0czSlAyUFI0RHo1V2FlU2dzVmZnZHdCenBqSkRNY0M4?=
 =?utf-8?B?UUcxK3BQWTM0aUR4TzRZNDc2T0hhN3VsWkNZYnBEQnZqdGowTkJJS0lHbUMx?=
 =?utf-8?B?WDNRbEVBdmI2d1BNUzVuYTVOZnduVG9QdjVwNzlkVHVBWWg5UFluYmtjbUJ5?=
 =?utf-8?B?TUQrK2VZU2hWV0twQ1RVaUQ5MGVnUTBhbGViWjZEVEpuNlZtYXZYTWV0cXNy?=
 =?utf-8?B?MEd5dmdSRGxWSzJHSklVbGdNMDdTb0pEbCtRQndGY2RnenEwcTdRWFFMN1dn?=
 =?utf-8?B?Wnkzd1pXcUtVb1V3a053b0o1QXJtaVRDMWJ3UWVtTUJQbW9YT1lqdTg3NUtM?=
 =?utf-8?B?WktnUStGdGtVZTMzMUJhYUZQOEVLZkNWR3ROUGZQaGphNDNWaEpXRzYxQVE4?=
 =?utf-8?B?bFhGSDJtL2dlQXRvSjczRG1Ud3lMa01QKzBCM3FKemM0V0VSL2hSMFEzaGpM?=
 =?utf-8?Q?O6tH746kqCwa21bCEXo+4uXi9xu+sq6Xc3fLo7BLAxAx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a13d716e-0d1b-48cc-ba9f-08dd96ca642f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 11:43:36.4530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D8BN5OJ1DfbOrpSbAx/tyVuH2hnjiZeeLvFFEgYkz70wA8faRpTytcDzVHDuZtD6dr+HZQX73zprHkyJCoYCWtVVm45OQxUrh5k3RrBjY4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7958
X-OriginatorOrg: intel.com

PiBPbiBNb24sIDIwMjUtMDUtMTkgYXQgMTA6NDcgKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+
ID4gPiArLyogQ291bnRlciB0byBjb3VudCB0aGUgYWN0aXZlIFNHWCB1c2VycyAqLw0KPiA+ID4g
K3N0YXRpYyBhdG9taWM2NF90IHNneF91c2FnZV9jb3VudDsNCj4gPiA+ICsNCj4gPiA+ICtpbnQg
c2d4X2luY191c2FnZV9jb3VudCh2b2lkKQ0KPiA+ID4gK3sNCj4gPiA+ICsJYXRvbWljNjRfaW5j
KCZzZ3hfdXNhZ2VfY291bnQpOw0KPiA+ID4gKwlyZXR1cm4gMDsNCj4gPiA+ICt9DQo+ID4NCj4g
PiBXaGF0J3MgdGhlIHB1cnBvc2Ugb2YgdGhlIHJldHVybmluZyBpbnQ/wqAgU2VlbXMgbm8gY2Fs
bGVyIHVzZXMgdGhlIHJldHVybg0KPiB2YWx1ZS4NCj4gDQo+IEkgc2F3IHlvdXIgbGFzdCBwYXRj
aCB1c2VzIHRoZSByZXR1cm5pbmcgdmFsdWUuICBQZXJoYXBzIGFkZCBhIHNlbnRlbmNlIHRvDQo+
IG1lbnRpb24gaW4gdGhlIGNoYW5nZWxvZywgb3RoZXJ3aXNlIGl0J3Mga2luZGEgb3V0IG9mIGJs
dWUuDQoNClllcywgSSBjYW4gYWRkIGEgY29tbWVudC4gSSBkaWRu4oCZdCB3YW50IHRvIGNoYW5n
ZSB0aGUgZnVuY3Rpb24gZGVmaW5pdGlvbi4gDQoNCg0K
