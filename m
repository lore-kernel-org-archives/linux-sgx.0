Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E21D277C87;
	Wed,  6 Aug 2025 23:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754523541; cv=fail; b=ale+PK1rPznHwr+nYRZtgE56yRGSlpxDHVetzE4r18yEfSgvfyXDklxV8G13+IoYkEYLPJRiklc/8TWhVRRdYfMp7EH67Tg/vXO6uF8BOn7bdjetBSnBMde0RDJ1gOj04uqNLh4sypqOcDhCLbmZ9DZTenANBcbvte/byANUrss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754523541; c=relaxed/simple;
	bh=mtAqcxRMDvFinL89ff9IGzF/OCJY6lTAFjKKVofWXOE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n612Ul3pjt5CCee/zSfh4strdQo76cQDYgB64WwqGmrEdU4kyuIoS9CWkt3LUpPC1Dx0TCpnlixa19PIJR4YFE2PDjM2DKBshR5YSfIiMXaTiOOANrp6WVr4pW/vbMiTlgrlebokmX3rO7EBBFYhytpe6OIHb0gzclEkqCfrNsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HaZAwheu; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HaZAwheu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754523540; x=1786059540;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mtAqcxRMDvFinL89ff9IGzF/OCJY6lTAFjKKVofWXOE=;
  b=HaZAwheunHqEZ84Ad9Y4BwNe8vcwmBSD62syoCYZhSi2fcmvatbzK+5i
   DzisGEiS5cWRJcfZxefSHprQ+eoSXHb30ygRdFKFeoQGm+FcsyTyqLyHy
   00txl9m7lYdtQDUH8HfFVgzzz5FAA3EWjf4wZ5F6X3pfdujGvgDS2LN+P
   eZPSqtne15CztptvAd9WWD3f7rXzKQ8qY+bDOdw+gC266Ww1lIHyItddl
   DWepANi/SA4gQwE7akbmfxjuhkihrvPocSHpi5SqrhwRvfMNeMrA5tP3r
   s5o4mazahlaPTEg8BTi4rtHC2b1gVUsgDGd0jwuH9Oj/PYdAZvvxYs4Kh
   A==;
X-CSE-ConnectionGUID: 3VRFyjEPRlKVA10AbAmeQw==
X-CSE-MsgGUID: 0YWhXh1ESTq2am6b94JYEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="60483505"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="60483505"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 16:38:56 -0700
X-CSE-ConnectionGUID: f2w01oUPR7emUWryxBA+Cw==
X-CSE-MsgGUID: YzvUe5SDQbWQLHv98qOQcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="169337559"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 16:38:57 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 16:38:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 6 Aug 2025 16:38:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.41)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 16:38:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mgM7IxXA3AGZW1BOq1fkKlIgP/4ETo2eDiN6TVLK+lgXE+buzGXeYb/Aso94r4BgRAfvUc2lbDpDizFQHd1odUN9Hze6t/k2oSSBsMjscNrM/DwVFQO3sYg+LE+9viFwEP4tAscrZWciCv53tf8Asir3TCWPW6ADUnTYdbSdixkmG9T4JYu3LaSTmlTwGfLppMCerVlwVHa0hJWjxxtVjfZcxE1A+sBG8Vl8ATJ6tS30psTVAp9NAop9QFzHtCVah7B9o27dN3YzJIPvah/ORktjbF9yMoEzenOFlxucenCN1d5w/H99WvBaBCLHpDjb/OKkEWYMhuSMjLaOjrK8GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtAqcxRMDvFinL89ff9IGzF/OCJY6lTAFjKKVofWXOE=;
 b=poYhLTLaYpmHMqg9TLmXokfbhPaCvrSkvXtkLkSYDmdG9xMBONb3oVkpP1+c3M+OqKex210Bt+UM1upB6IyKl9UJtJfAojvFSgRkEcH6paGljFWwIB4mMSK4UPkYxZNR31fDOLX0VH/8vBqFta5xRC079vgpPbtviMXP//91vMCw79AeKJV4idpXcF8x8QF0mQ+EciaZbZhJMQWdirNw5c4bkgpur9eEwBhkiwnDg8jChpw5MG60/KHj25Iae2XFMx1/nxVJPy3xDVDyItEXW/36lZyL504IbaP4cbv6nl+fuNrXb+wNI9uHu++5b6TYWAzoT7awMeencQ1rIXz0CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB8039.namprd11.prod.outlook.com (2603:10b6:510:25f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 6 Aug
 2025 23:38:52 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8989.017; Wed, 6 Aug 2025
 23:38:46 +0000
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
Subject: Re: [PATCH v11 1/5] x86/sgx: Introduce functions to count the
 sgx_(vepc_)open()
Thread-Topic: [PATCH v11 1/5] x86/sgx: Introduce functions to count the
 sgx_(vepc_)open()
Thread-Index: AQHcBqodaLJFFlxscEecQOaRuNjElrRWSScA
Date: Wed, 6 Aug 2025 23:38:45 +0000
Message-ID: <048064e70c57f95372f8400522914f3ddbc6b94a.camel@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
	 <20250806081344.404004-2-elena.reshetova@intel.com>
In-Reply-To: <20250806081344.404004-2-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB8039:EE_
x-ms-office365-filtering-correlation-id: 8c508321-bf4a-49d6-1ebe-08ddd54262e2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UnVyTXhrbXdoUmhyNTlnVmMwVjRTUFlJQXZML3pQSis5Z3N6Z0Y4VkIzZytk?=
 =?utf-8?B?VGNqZ2VPdGloUWpRSHJyZERsYnEwMm8vd3Z5N1Uyd05vQUc3bFJjTnZINTU5?=
 =?utf-8?B?K1A3YzQxYmU3ZUM0M0V6Tm9HcWgxTzFnTllGbVU0WmoxMUZiMVVWdXl5YS91?=
 =?utf-8?B?QTJmdUs1YkFMcVQra1lCRkRTYzFBMVU5b0xMaWQrZVIrMEJMVVRPSWMzeHZk?=
 =?utf-8?B?T3I3Tm03TGl1WHdnT1c5TjBoM2xrdXd5dlRTckdVeFdIaXU0a1dIZFMwd0Fj?=
 =?utf-8?B?L2JWdVIxbmRaODNrSDdLTDAybW5SaTB0WkZnQmdtTEgyOWpmc1ZDcGFYN1FL?=
 =?utf-8?B?OEcwTmlCbEtKRlZKQjVTeGs3RlFtMXBoRnJiMzdxYVN4UzN0OVdMbHhNQVVt?=
 =?utf-8?B?L1ltVnF1cmNGQnIvYUpnbzlUdzNUMFJwclhiN0QraWQrWjUxUUp0TGk3ek50?=
 =?utf-8?B?NlRpd3VqSStsakY4TGZGUlQ2aGJuVndTaHNsSVhnaVp3cSt0YVloWmU0aUNK?=
 =?utf-8?B?RTkycG5udDRTUFM5SlBoV2N6Y2V4b2QzcjJZSVVJb2s1dHRzSkVodFNncWNR?=
 =?utf-8?B?VEs3ek1rc1ltdmgvWlIzc25xOTE0aFdyM1ErWGlRNFRVS3IzZVpaeXJ2bFBX?=
 =?utf-8?B?TStpM3BaWlZVU1FIMmszd3lqeCtnZUJjdDdKQktDVURKRE1najgxcXhkNmpB?=
 =?utf-8?B?TEJRUHJEd1dBbEZGMndmRjAyeWhpTUxLSEozc0VFM0JLejNiR3RSbkZhdjFF?=
 =?utf-8?B?S2htT24vbmJOMStoV2pzU3RWUWFlU2ZKSnBJa1dJZDE1MWNLTkVYVWcvSkdP?=
 =?utf-8?B?NW1MdkNCVlhaazJPdllsSE40bHZaY3NXUVhta1psUnQ3UUhLbEw3VUtRdEJa?=
 =?utf-8?B?R2ZOKzUwQ1g0Rm5xaDM0R2ZNVnRLck42MkhpcWhoclcvNFI5SjJvRmpHU3E2?=
 =?utf-8?B?eE5jaVAxcmdOQVBMaHJ6eFUwVWV4TXRRdVZNR2hORm9JbEU4N0dCeG9VOExj?=
 =?utf-8?B?SW56Tm8wOHVyRnVJdFBnckhCajRuVXJIRTBSRjZqak9vMnpEbzhZNFdlRlAx?=
 =?utf-8?B?SzlxY0Via3NpRmJ0RThMQTFjMEhEeWxnRnNnNWltY2dDNnFXMzJJaW9HNDBD?=
 =?utf-8?B?Q0Q3OXFSY0lJMVdZck1ZU1cvNXZkNmJqZlJZUXE0cjJHak5zcmFkSFlBN3pP?=
 =?utf-8?B?azlnWWRNZFdxMStWQnVGUDhkMDNtdnV5MkNRNnhnbFZZYTJMM0hFSjFvRFFw?=
 =?utf-8?B?aDRJYWZQR08zZkFoMGF0R3YwdlZHOSsvUXhPMURhN0JKWnE5MXFaMjAzS0Y3?=
 =?utf-8?B?allSWk1TQWsxVXJTSS9mdjhRcVFZRUE4ejArajM2TGNaejAxV3ZuM0FybERa?=
 =?utf-8?B?blZCNksrZnV2M3BIb1J4cWcySWxka1BWcFNZbG1ER3dTTmt0bjJsWXJjS0ha?=
 =?utf-8?B?MldHWWRpUkZPY3RzRjlONHJuSURjbzNPVWJsL2s3cGlwY2dNNGhuczdrcEZC?=
 =?utf-8?B?VTdNT2IxS0x6NW90VWdYcXY3S3R3VW1NVDZqYjFkOG9tcmw1elZTSzdSZm5i?=
 =?utf-8?B?emlENzUydUZHUi9NYk9GWS9GWVBQQm1pd3pONUJBVUIzZnlFOTlaeHVIZ3Rn?=
 =?utf-8?B?Ly9waGhXT3lLVkhTTk4zeWpaUU04YWFrREtZZ3RMV3RnTHNkaUNueklpRUk5?=
 =?utf-8?B?dXFmbktsdTFKS0hiWGQ0bmdGbHNmY3NneE9adUpseFh0U005ZlQ4andaQW1E?=
 =?utf-8?B?MS9SQjRmOTV0Q1BTNCt5SzVxM2szSVMwRUJHdmEzVmUxRW0xZFlDMkhKd0tn?=
 =?utf-8?B?ejBhQk4ycXZDNTBneE9sSjkwenpxVW9uOU1jRmhPQnNMQlBPVVZSeSt2RmdU?=
 =?utf-8?B?dzlsZE9nS0tuQm42am8vNERmRHBoUVIzV2NKZlFKTXE3UjJwdGU5RUZ0cm9l?=
 =?utf-8?B?SlJWTzBpVGJaaG1MZ0dIZUkyUDZOeTdTMmtSaXJDd3F4Qk1DZlRVa2JqMUdW?=
 =?utf-8?B?cjlIbzZZekRRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTJyaC9Vck5DZVVuTDdVVGEzS3lTZ2tSL28wcE0za0R3ZGM3UHhTQ2JhaUU0?=
 =?utf-8?B?d05wQVNEdHdnV0h4VHVRQzFwT2xVTmlyQ1VCMS9hbXRnWjJhS3NBL2tkMUNv?=
 =?utf-8?B?MmIxMGRna3BBRzNPYm93TTIrbmo4WTZUOXorMStXZ1NnTU00L3E3TnZsTXU2?=
 =?utf-8?B?YjFGM0ZhUEw5UjFmVEZCbzBqNGZpck41RWpPNnJ1QkhjdDMyOXNHSXRncUw4?=
 =?utf-8?B?Tm5xUHhCL1pmYklHQjRjQzV4MzkwZUIySGFvVFlrRHBsUXN6RnVBSGpwMi90?=
 =?utf-8?B?Y2N0TlU5M1ZOOERndXhyR1RJYThUUUpmc1RmQ0xrWXkvR2VnOVNxbkpwUmt6?=
 =?utf-8?B?Wkw3ZExXb29CMkNyT2tqOGc2V3lnZHNGaExVM0gwamRMUHFpSEViRjBjclI5?=
 =?utf-8?B?S21wZTR0UmJkWWQyMStlaEFQUmY2STVreTlWQlRsd2VpNytIeFMrVEd1bWJC?=
 =?utf-8?B?U2RNYUlPWitMMUhIYXdaS203ZkhqUzB5RVVscGRPMENwNDdiZHpTenZScTdI?=
 =?utf-8?B?c1ZCY2JNY0xENm1JOUI3a1hmcXpWcVhQd2FWVmZ3K01sVlNodktXakVjRWll?=
 =?utf-8?B?R29kZ29jampZdGViSFFENGJPcy82eDU1RWZ5Y2xhTmZ6em02R0c0andUeVVF?=
 =?utf-8?B?a21FZ203djBXZ1o0YnlwaWd2VlJYaHh1c1JZcFJ5dnFjTi9wYUtEWTd0V29R?=
 =?utf-8?B?V3lkT2VuL2ZKNkdwZWpsMmIxT3F2Z0g2d1M4NTdLN3hVWlMxT3BTV0s5M1dB?=
 =?utf-8?B?QnkwVENsZTBXWG9USTc5eFo3S0F0U3JwdzF5R211N2ZJNW1hbjA0M0dvUVhp?=
 =?utf-8?B?MllXQ254aExENXhNTTZ2dkZaYzZYZzNSTi9ORlViRXY1aEpZdCs1YTJ6TnBY?=
 =?utf-8?B?d3NZNTJYL1lBdWVzN0thYWtBbStSek9TcFpEdCtMeTl4SkVKWDBNMklLSzIx?=
 =?utf-8?B?VENwdUFGS3BRTlRLRnB6R1gxRENTR21ic1pWK3hGQk1PYjg3OENjVVluWkdM?=
 =?utf-8?B?eDhtZEF5K3FjS3RCbmVHQmQzK1lHSHE1RmczV2JHK2pXNVhSc0NhZm1NL203?=
 =?utf-8?B?T2d3bUZaYWJWajhHNm53ODVGdDF1TUdXdmNkZVpYQVZ0Q0hYb2tUbnJjRjg3?=
 =?utf-8?B?a0wxSHhLZXpkWVk1N0FvUlUxemhncHZqL1pXbUQwVzY5MGxocmZzcVRsbzJK?=
 =?utf-8?B?bzJ5TVIwcTd0NjNmZUREbkFEbDk4cjhWMUNvYzVYalIySkJDZXFrTVNadXF4?=
 =?utf-8?B?N1NXMWpRSDkrOWhGNThSeEpkbGxkdGowRWV3Mjh6SlpDcE9SR1FyMHlyQ3Vo?=
 =?utf-8?B?bk1MRHV4MFpQMWVTQWhmbWQ0OHB2R2pBUUtpaHk5NGNnTW9DSW10Vm1JV3VG?=
 =?utf-8?B?WGJrWEhrTndacFhpYWIybGFORTNlaTVaUFNGc1JUamM2UmZZREFIZ1hGay9v?=
 =?utf-8?B?dlplblloOXhZRnE1Qk15U2llZ2JkUGFYa24zdHVZNDBkRXVJMUFKR1d5akx4?=
 =?utf-8?B?bll6OHVTZTQ1Q3dVWHhIWmR3YnJUOXl2WDJSVFB5YUlEU3JnYkcrQ25ZYjY2?=
 =?utf-8?B?elc2TG12SnFSTk5XbjVsSFEreFVMcW40VnpEM05JN2VwdlBDelZBZ2RBaCtB?=
 =?utf-8?B?dlZ3MWg4ekRXT0tuTjNiemlGcTFvMDNoa3RQMHNJN1VFNGNJSHZ1OC9Ma0VO?=
 =?utf-8?B?U1pYTFMvOGRVWDZ4TUpWT3g5dlhkVUk4ZEM3SWU1M3ZNUmN5Nk4wb2h0ZUZB?=
 =?utf-8?B?cmFMeXJYOXNUNWxOODJvaHpMbGJMcGlpQnJwbmsvNjh6T25rWldwVVRkWGJx?=
 =?utf-8?B?bXgyUXJOWmFGQUhESDA5djhiTk1ydXFjdUo5ck5lRWFxd3FCeVk4OE05OE1u?=
 =?utf-8?B?OGllbm9NZHVKSmFqV0ZmR2NOeVNJeUp2d2RmU3hXZEtSWHZpcjl6WitIYUNt?=
 =?utf-8?B?RmY2UWhvaXlFSWpFbTBoRGJiWUdzOEhkV1h4Ni9vdmJLZVVEdmhhMGtodVNP?=
 =?utf-8?B?WHAyTmhoK29hak42VHJXYUVOenVSbzZmdGlpZGMwRVFvVE5nSUlnSVZNVEE4?=
 =?utf-8?B?QWdiTUlEL1VrWktYZHRsSVVKZWxmak1GMmtoUDdXY2tuTUxrRE5JNzV0WFlh?=
 =?utf-8?Q?4+BVTKnzgMIRdgHdcll83p5AX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <831D13DECC0E7745B708769B9098820F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c508321-bf4a-49d6-1ebe-08ddd54262e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2025 23:38:45.9403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CtzpuLWKIRtU75H90c0bkbym0ihxGTbkRDqNyIxwGf8e827rijkwNXxD54dEr6O8alUbcqR6p4dvJNEUGQNlHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8039
X-OriginatorOrg: intel.com

DQooc29ycnkgZm9yIGJhY2stYW5kLWZvcnRoIGFuZCBub3Qgc2F5aW5nIHRob3NlIGJlZm9yZSwg
YnV0IHNpbmNlIEkgZm91bmQNCnNvbWUgaXNzdWVzIGluIHRoaXMgdmVyc2lvbiBzbyBJIGZlZWwg
SSBzaG91bGQgc3RpbGwgcG9pbnQgb3V0LikNCg0KT24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjEx
ICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6DQo+IEN1cnJlbnRseSBTR1ggZG9lcyBub3Qg
aGF2ZSBhIGdsb2JhbCBjb3VudGVyIHRvIGNvdW50IHRoZQ0KPiBhY3RpdmUgdXNlcnMgZnJvbSB1
c2Vyc3BhY2Ugb3IgaHlwZXJ2aXNvci7CoA0KDQpGaXJzdCwgdGhlIHRleHQgd3JhcCBvZiB0aGlz
IGlzIG5vdCBjb25zaXN0ZW50IHdpdGggb3RoZXIgbGluZXMuICBJdA0KYnJlYWtzIHRvbyBhZ2dy
ZXNzaXZlbHkgQUZBSUNULiAgSSBwZXJzb25hbGx5IHNldCB0ZXh0d2lkdGg9NzIsIGJ1dCBJJ3Zl
DQpzZWVuIG90aGVyIHBlb3BsZSBzdWdnZXN0aW5nIHRvIHdyYXAgYXQgNzUgY2hhcmFjdGVycy4g
IEJ1dCB0aGlzIGxvb2tzIHRvbw0KYWdncmVzc2l2ZSBhbmQgbm90IGNvbnNpc3RlbnQgd2l0aCAg
b3RoZXIgbGluZXMuDQoNCkkgYWxzbyBvYnNlcnZlZCB0aGlzIHByb2JsZW0gaW4gb3RoZXIgcGF0
Y2hlcyB0b28uICBDb3VsZCB5b3UgY2hlY2sgYWxsDQpjaGFuZ2Vsb2dzIGFuZCByZS13cmFwIHRo
ZSB0ZXh0IGlmIG5lZWRlZD8gDQoNCkJhY2sgdG8gdGVjaG5pY2FsOg0KDQoidmlydHVhbCBFUEMi
IGlzIGFsc28gb3BlbmVkIGZyb20gdGhlIHVzZXJzcGFjZSwgc28gdXNpbmcgImh5cGVydmlzb3Ii
DQpkb2Vzbid0IGxvb2sgcXVpdGUgcmlnaHQgdG8gbWUuDQoNCkFsc28sIGl0IHdvdWxkIGJlIGJl
dHRlciB0byBtZW50aW9uIHRoZSAid2h5IiBmaXJzdCwgc28gcGVvcGxlIGRvbid0IG5lZWQNCnRv
IGZpbmQgb3V0IHRoZSByZWFzb24gYWZ0ZXIgcmVhZGluZyB0aGVzZSAiaG93InMuDQoNCkhvdyBh
Ym91dDoNCg0KQ3VycmVudGx5LCB3aGVuIFNHWCBpcyBjb21wcm9taXNlZCBhbmQgdGhlIG1pY3Jv
Y29kZSB1cGRhdGUgZml4IGlzDQphcHBsaWVkLCB0aGUgbWFjaGluZSBuZWVkcyB0byBiZSByZWJv
b3RlZCB0byBpbnZhbGlkYXRlIG9sZCBTR1ggY3J5cHRvLQ0KYXNzZXRzIGFuZCBtYWtlIFNHWCBi
ZSBpbiBhbiB1cGRhdGVkIHNhZmUgc3RhdGUuICBJdCdzIG5vdCBmcmllbmRseSBmb3INCnRoZSBj
bG91ZC4NCg0KVG8gYXZvaWQgaGF2aW5nIHRvIHJlYm9vdCwgYSBuZXcgRU5DTFNbRVVQREFURVNW
Tl0gaXMgaW50cm9kdWNlZCB0byB1cGRhdGUNClNHWCBlbnZpcm9ubWVudCBhdCBydW50aW1lLiAg
VGhpcyBwcm9jZXNzIG5lZWRzIHRvIGJlIGRvbmUgd2hlbiB0aGVyZSdzIG5vDQpTR1ggdXNlciB0
byBtYWtlIHN1cmUgbm8gY29tcHJvbWlzZWQgZW5jbGF2ZXMgY2FuIHN1cnZpdmUgZnJvbSB0aGUg
dXBkYXRlDQphbmQgYWxsb3cgdGhlIHN5c3RlbSB0byByZWdlbmVyYXRlIGNyeXB0by1hc3NldHMg
ZXRjLg0KDQpGb3Igbm93IHRoZXJlJ3Mgbm8gY291bnRlciB0byB0cmFjayB0aGUgYWN0aXZlIFNH
WCB1c2VycyBvZiBob3N0IGVuY2xhdmUNCmFuZCB2aXJ0dWFsIEVQQy4gIEludHJvZHVjZSBzdWNo
IGNvdW50ZXIgbWVjaGFuaXNtIHNvIHRoYXQgdGhlIEVVUERBVEVTVk4NCmNhbiBiZSBkb25lIG9u
bHkgd2hlbiB0aGVyZSdzIG5vIFNHWCB1c2Vycy4NCg0KPiBEZWZpbmUgcGxhY2Vob2xkZXINCj4g
ZnVuY3Rpb25zIHNneF9pbmMvZGVjX3VzYWdlX2NvdW50KCkgdGhhdCBhcmUgdXNlZCB0byBpbmNy
ZW1lbnQNCj4gYW5kIGRlY3JlbWVudCBzdWNoIGEgY291bnRlci4gQWxzbywgd2lyZSB0aGUgY2Fs
bCBzaXRlcyBmb3INCj4gdGhlc2UgZnVuY3Rpb25zLsKgDQo+IA0KDQpbLi4uXQ0KDQo+IEZvciB0
aGUgbGF0dGVyLCBpbiBvcmRlciB0byBpbnRyb2R1Y2UgdGhlDQo+IGNvdW50aW5nIG9mIGFjdGl2
ZSBzZ3ggdXNlcnMgb24gdG9wIG9mIGNsZWFuIGZ1bmN0aW9ucyB0aGF0DQo+IGFsbG9jYXRlIHZl
cGMgc3RydWN0dXJlcw0KPiANCg0KSXQncyBub3QganVzdCAidmVwYyBzdHJ1Y3R1cmVzIiBvbmx5
LCByaWdodD8NCg0KRW5jYXBzdWxhdGUgdGhlIGN1cnJlbnQgc2d4Xyh2ZXBjXylvcGVuKCkgdG8g
X19zZ3hfKHZlcGNfKW9wZW4oKSB0byBtYWtlDQp0aGUgbmV3IHNneF8odmVwY18pb3BlbigpIGVh
c3kgdG8gcmVhZC4gDQoNCj4gLCBjb3ZlcnQgZXhpc3Rpbmcgc2d4Xyh2ZXBjXylvcGVuKCkgdG8g
X19zZ3hfKHZlcGNfKW9wZW4oKS4NCiAgICBeDQogICAgY29udmVydCA/DQoNCj4gDQo+IFRoZSBk
ZWZpbml0aW9uIG9mIHRoZSBjb3VudGVyIGl0c2VsZiBhbmQgdGhlIGFjdHVhbCBpbXBsZW1lbnRh
dGlvbg0KPiBvZiB0aGVzZSB0d28gZnVuY3Rpb25zIGNvbWVzIG5leHQuwqANCgkJCSBeDQoJCQkg
Y29tZSBuZXh0ID8NCg0KPiBUaGUgY291bnRlciB3aWxsIGJlIHVzZWQgYnkNCj4gdGhlIGRyaXZl
ciB0aGF0IHdvdWxkIGJlIGF0dGVtcHRpbmcgdG8gY2FsbCBFVVBEQVRFU1ZOIFNHWCBpbnN0cnVj
dGlvbg0KPiBvbmx5IHdoZW4gaW5jcmVtZW50aW5nIGZyb20gemVyby4NCg0KVGhpcyBjYW4gYmUg
cmVtb3ZlZCBpZiBteSBwYXJhZ3JhcGhzIGFyZSB1c2VkICh3aGljaCBhbHJlYWR5IG1lbnRpb25l
ZA0KdGhpcykuDQoNCj4gDQo+IE5vdGU6IHRoZSBzZ3hfaW5jX3VzYWdlX2NvdW50KCkgcHJvdG90
eXBlIGlzIGRlZmluZWQgdG8gcmV0dXJuDQo+IGludCBmb3IgdGhlIGNsZWFubGluZXNzIG9mIHRo
ZSBmb2xsb3ctdXAgcGF0Y2hlcyBkZXNwaXRlIGFsd2F5cw0KPiByZXR1cm5pbmcgemVybyBpbiB0
aGlzIHBhdGNoLiBXaGVuIHRoZSBFVVBEQVRFU1ZOIFNHWCBpbnN0cnVjdGlvbg0KPiB3aWxsIGJl
IGVuYWJsZWQgaW4gdGhlIGZvbGxvdy11cCBwYXRjaCwgdGhlIHNneF9pbmNfdXNhZ2VfY291bnQo
KQ0KCQkJIF4NCgkJCSBmb2xsb3ctdXAgcGF0Y2hlcz8NCg0KPiB3aWxsIHN0YXJ0IHRvIHJldHVy
biB0aGUgYWN0dWFsIHJldHVybiBjb2RlLg0KDQpDb3VsZCB0aGlzIHBhcmFncmFwaCBiZSBzaG9y
dGVyLCBsaWtlIGJlbG93Pw0KDQpUaGUgRVVQREFURVNWTiwgd2hpY2ggbWF5IGZhaWwsIHdpbGwg
YmUgZG9uZSBpbiBzZ3hfaW5jX3VzYWdlX2NvdW50KCkuIA0KTWFrZSBpdCByZXR1cm4gJ2ludCcg
dG8gbWFrZSBzdWJzZXF1ZW50IHBhdGNoZXMgd2hpY2ggaW1wbGVtZW50IEVVUERBVEVTVk4NCmVh
c2llciB0byByZXZpZXcuICBGb3Igbm93IGl0IGFsd2F5cyByZXR1cm5zIHN1Y2Nlc3MuDQoNCg0K
Wy4uLl0NCg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbC5jIGIv
YXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbC5jDQo+IGluZGV4IDMwOGRiYmFlNmM2ZS4uY2Yx
NDliOWY0OTE2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9lbmNsLmMN
Cj4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbC5jDQo+IEBAIC03NjUsNiArNzY1
LDcgQEAgdm9pZCBzZ3hfZW5jbF9yZWxlYXNlKHN0cnVjdCBrcmVmICpyZWYpDQo+ICAJV0FSTl9P
Tl9PTkNFKGVuY2wtPnNlY3MuZXBjX3BhZ2UpOw0KPiAgDQo+ICAJa2ZyZWUoZW5jbCk7DQo+ICsJ
c2d4X2RlY191c2FnZV9jb3VudCgpOw0KPiAgfQ0KPiAgDQo+IA0KDQpbLi4uXQ0KDQo+IC0tLSBh
L2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYw0KPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwv
Y3B1L3NneC92aXJ0LmMNCj4gQEAgLTI1NSwxMCArMjU1LDExIEBAIHN0YXRpYyBpbnQgc2d4X3Zl
cGNfcmVsZWFzZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gIAl4
YV9kZXN0cm95KCZ2ZXBjLT5wYWdlX2FycmF5KTsNCj4gIAlrZnJlZSh2ZXBjKTsNCj4gIA0KPiAr
CXNneF9kZWNfdXNhZ2VfY291bnQoKTsNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCg0KR2l2ZW4gd2Ug
aGF2ZSBfX3NneF8odmVwY18pb3BlbigpLCBJIHRoaW5rIGl0IG1ha2VzIG1vcmUgc2Vuc2UgdG8g
aGF2ZQ0KX19zZ3hfKGVuY2xffHZlcGNfKXJlbGVhc2UoKSBjb3VudGVycGFydD8NCg==
