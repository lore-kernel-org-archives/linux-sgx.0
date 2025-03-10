Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6552A227EAF;
	Mon, 10 Mar 2025 10:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741604092; cv=fail; b=iP5uN+kpCeT20C5txpvYAJLa/iO4VHuok9/EcIbhIZ9/lFl7zYU8hQpbSB0gZ0odyoqipSzXt6TbMXWsCVpzmYJ/wQTJO9p9jPKE880vYqh5QqF8HScxU6GH4cqzsigLQ/lyO3cJFgy8N7OY8QcfbvA9v6rhPTEJNoXMFexhE7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741604092; c=relaxed/simple;
	bh=VyzOeYCUxXX+I/SHw+VabB5y9EAVYUWMwmRFFeS0Eo0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ngq7J173Z3Yr0yZrnG8zniXKsOh2lsmATNzLzpzEuV1dHEz19zEvu37s0ZD5ZfVW4uGonVqnbQLHKNFg5U0CliluOWSwyN7PAMecpCtr7uZnd0Xt3G/Z+MU3OYJy2l8qt3RftftMz8vEV3KbYt+d4NoChYX+jLAWiCL4FFUm0y0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MMb3XqRb; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MMb3XqRb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741604091; x=1773140091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VyzOeYCUxXX+I/SHw+VabB5y9EAVYUWMwmRFFeS0Eo0=;
  b=MMb3XqRb75n0eoDtRQ+PweLRnZfESOiaJ+jevL+F2HW7aXbxqwtydhNC
   2HatHo1EwO6tVe4Vqu0srhxd4UtcCB0AC2qGLYlOtFfWWTHICwikY00EP
   MAtczI50aKvmBHGy+TG53thyZbSaw325TZaUFX9i5ayYhA/0YvnA6rtwy
   kQ0A5RJwpx6PMmXwpzOHrqZCELHcvQ1mc7rff0qsVDVu8oj1Qw1uxj4tk
   lUFkEM373FClksOoGTIDtX/eb+JrrAejtluhYrPd0fQeCdU0Idn46GbjS
   /f641RB8GPL7TUtxbQtVmBC+GgpfRJYotnLxPGXyl4zyEvAkiYfpIUV6s
   A==;
X-CSE-ConnectionGUID: PeOksraKSSmqL8B5DzRlzQ==
X-CSE-MsgGUID: mQGocrJIT4KCRt9N90YAbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="46380052"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="46380052"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 03:54:48 -0700
X-CSE-ConnectionGUID: cRXT+ZBMSM+lQqZFH4erLg==
X-CSE-MsgGUID: ekMybdR6QCC7WrbPFyKmpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="124868007"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 03:54:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 10 Mar 2025 03:54:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 10 Mar 2025 03:54:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Mar 2025 03:54:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hoWRXFXGj1B8BrgtWXF8NbE+rYpvCnDlFIX/NUnHl+JB/5qhB7NobO4WLyagPqTai2/JZM+29DzRjEyOw45rOQCmVfS1DbEf5MjrsPHbzrcI0NnMxwPq/8t8ugbARuhfVoM8V8TnYUQRpyoGtpSHo9L0kfAUFACe5gR5x7pPN4hVign5JcL5Gtoe6ZUZMzQJQrtWzhGhm/2P6Tb1uxad+8ZWy4S2nZbTUSeRXHhnh/K3dLWp/U0DA4Am8LDDIiUJYdAXJKMm2E9uJHX+Hw0PIDx38ngC+gumzWXTw3elacsEbl3aLtCdnYxTdEh2pADMQJZ9z1bXW/M+0TNNGcxe6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VyzOeYCUxXX+I/SHw+VabB5y9EAVYUWMwmRFFeS0Eo0=;
 b=STT0TNrg/hZFTqvK7Y5uLLhIFl+r4k0Tu3PDLVeCrrUWEbUsiusG5by8EFwnoLFHcW0mQ7hK9H/+kgZ+TGdKh8z8BU6IfwxmBAVRzKRA41bT0ZIKrDN2EzXcXMsen1zcT+QncqNkchWUDKSPkLzlB5hPUxIQDq06GUzVFOW1vY/MpSmqnYHOgXudqXbu2I+wW6fdOPE7MB7aKqbRwcuSAYEB37DTQO1oKWLy4cXTqYlhvC3ahJ2I5poZu6VV5tK8XBwn8BULDypTScbojkyDCvXpEE3a/CmbUO+5ZyDsz29QMTGfd40abLa37b0VqTzLWPxMc1U6RiJsTx55XP2taQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6995.namprd11.prod.outlook.com (2603:10b6:806:2ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 10:54:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 10:54:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "mingo@kernel.org" <mingo@kernel.org>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"vdronov@redhat.com" <vdronov@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH -v3] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is not
 enabled
Thread-Topic: [PATCH -v3] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is
 not enabled
Thread-Index: AQHbkZhk8Qiipx/TDEqdAyY9+tMvMbNsMmgA
Date: Mon, 10 Mar 2025 10:54:35 +0000
Message-ID: <d91942f7782fe1e1f1491de86d60bb14b2d5e781.camel@intel.com>
References: <20250309172215.21777-2-vdronov@redhat.com>
	 <c21c89d29f006945b6be7624599809b36574530e.camel@intel.com>
	 <Z86l9WiiP_4bFC8q@gmail.com>
In-Reply-To: <Z86l9WiiP_4bFC8q@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6995:EE_
x-ms-office365-filtering-correlation-id: 9143dc5a-93ad-4ddb-439b-08dd5fc1f256
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L0dZcUw3bjBFaDdnVG4rNGE4WmRpcld4WDY0a3ZZQTdkaVgyVEpxT1dNQjBw?=
 =?utf-8?B?bGY3ejRVdXdNSGNrSmZBWmpkZVU4VlRmK0c3WEI4MEhjSE9xdVUvZUM1aEZW?=
 =?utf-8?B?cmZVRDVIMGxTSnZHcWpmVWQyMU5RbmZsY2YvWEl1K1ZPYkVpMXJCaGJtNmJi?=
 =?utf-8?B?WTNZR2hXSzIyTE1KNG1zTnpySnoyUlE5c3d3RlBnR3U4dURsTy9Ndy93ZHhv?=
 =?utf-8?B?MTRhWVJyUWJINnpNTk5kLzFPTlVHT0djWUlWMW5Kd0EwU1FteTBQc2Fzc1RO?=
 =?utf-8?B?YXE2Qzdyd2VRNm44czFTSFkyUENieTBJQUpxTDZsNi85ZGtLdy82UmcwWS9x?=
 =?utf-8?B?T2h4YnhzRzMwemR0REU1M1h1YmdlZ1RPMjVOUWRwSFJvNHY5S0Fmbk55ZHZC?=
 =?utf-8?B?QTNhdXFoWTBsTHgrdG1FQ0wxUzkrK2FhUEJsdjRWTnBNNWE0amxvbVc2THZn?=
 =?utf-8?B?YlpmOGlXL2xuQXgyS2FtdS9nOVFha3VQRHprS0o5MFdnaWpMemJvd2VLN0Z6?=
 =?utf-8?B?QzFMZXloVEhCUm5WalhhbVd0Sy85UTNTQnFBQXFlVFhGUTlXc2FCSHR1VE9v?=
 =?utf-8?B?b3JLbW84WDFjSVN6R0dLbXNYQTJPY3l5MUVTNjd6K05UR2xjV3lpM1hPNDZV?=
 =?utf-8?B?dWlxS05BV25Jd0RxR2kvMTRwaXN4STNCWGdpdTlCY2Yxbk5MM25yR1ZXQnB2?=
 =?utf-8?B?NXJrY3FJMVlBMWthZWtmQTZuN0ZxRzdBdVNxWVpYWk56em1yVkJNV1AzckxX?=
 =?utf-8?B?YUd1KzRJZWFTbjRVVkVwdmNHbXhsaG5sV2hLQXRmWWJZd3N0VE5UU3BjdkNR?=
 =?utf-8?B?R0hyemJHNVI1dUpNaUNMd1QzR2FsNUpUWkhXZXlxb2dBQk5mOFpsVUZiQWln?=
 =?utf-8?B?SUhzSnk5TEhhcHA0RlZTQ3RTMWM3ZGZCLzBwcCsxSjlGUkFveHU3cHZ3UUpG?=
 =?utf-8?B?RTYzODBzNEtGc0tVTHN0RzhZMGxjZFhYcytuU3dDbGIzYkpvdnZ5djVmYW83?=
 =?utf-8?B?ZlE5VmcySGdlZGgreGJNdHVlZEowUzFMMFBkTkRiM1ByWjVYMERQU0RNRnRS?=
 =?utf-8?B?OFJORFV5eDBkTno1SU9VZ2QwWmR2K0JieHlsRmJ4aHJZU3NZNzJQbUYwaDRZ?=
 =?utf-8?B?WXhxS1dIVXRrRFV4TGFDbmJIZkVYakxQRUNPaDVqS01tVFJocVlPT1A1UjZy?=
 =?utf-8?B?a2NKL1dNblVIdk5VeHdJM3hMRWl2bVFqRmtwcW9CT0hJbU9qVFgyV1RMT2VZ?=
 =?utf-8?B?cEZZVkhzc2tOaXRJdUxYZmV4YU5ESzAyWVZCc0REL2xWZHZ1THgwSFdDL3Ix?=
 =?utf-8?B?c25qa09wVXJnNHQ1dkFyZ0xVd3VlbDlnd0lQNlM4MWlrUk9qZXMzRk8xYm5u?=
 =?utf-8?B?M1RCVytrR0FIVHNjN0hJK08rQTlZbmFTWmluSWRSSkV3SW4vcFFmSFJ1eEN3?=
 =?utf-8?B?ZUdHYXdWeUtSYUtWaS92NnYyWmtPdXcwZHF5L29uR2pMdzI1aXdmakxicnVl?=
 =?utf-8?B?QTZ6ZGdzRERUZmRWdnFUUUJacklJcGZZYm5KakE5T05vUTFBdlNJalZ3b3pa?=
 =?utf-8?B?MENXbGg0dmp0RC91eXBKUWVzVXJiTktvOCtsNS9YMTNuRGNSUVBjU1FFWEN0?=
 =?utf-8?B?NHRXMjRXNExsbkRCUUdQYU9iMEpteTNTTXE1d3c2alZvMjBNQjladlZiU3c4?=
 =?utf-8?B?bmZvYUl1VSt5OFg5R29UZERySU1yWGRBcEtZaDdieE1FM3RQL2xPVUo0Tjd4?=
 =?utf-8?B?QWJwSjNMV2pjVldZT0dTTldNNi9IVHlBZVBFT0pwL242N0NCWUdZUjhyK0k1?=
 =?utf-8?B?bmlUSGhKVE40bkFPVkNvUWhjTlRQaHdTMWFoSUpyTEs4VDljR2ZUQndwSlRW?=
 =?utf-8?B?UWFIYXd2azdyNVJGSHRXWWp6Y3JQREhKdDhwbWUxUWpuUE5palhPUmVJR092?=
 =?utf-8?B?Sk43V1gyQTNLVUo4MHRmWGNvaXF0Vld3eHVxUjV1dlc1YnB6OGIzamdaQkg4?=
 =?utf-8?B?ME8zNituaE5RPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHhNandPekEybVpTMm9NNjVmbXVkbVlWajk4V1lJcUNGallZZXMzQVlxbnht?=
 =?utf-8?B?WWtGWUFUb2VLV3JxakZtK1RWTjNIOWd5ajgyeE5XazZGUjRvUDM1bkxsMEJ6?=
 =?utf-8?B?VjVQdktlTGVyMk5VakdRNml1USswNWFkOXg4dnY2OGZIRTJEUXpUTm9xSGtE?=
 =?utf-8?B?c3pnbDVhUkt3a2VJVFRvam43NVJFYVVUZUU3Y1VLdnNLTmZjSUhWTW1CQ09X?=
 =?utf-8?B?ZUc4b1hGRHJDNzljdlhGRmR5YmFWWUxHbU5nWmY3OFlJbGtwQWM2Vy80VzNu?=
 =?utf-8?B?RkxXK2JuU0xHUk1oWFBCNXh6K2I4SkNqdzYzV0hqdEkrN3U5UTZYSHB4Mmdi?=
 =?utf-8?B?Z3BqTGFFRCs0YjE0eUhUUmV6S3psU2RTbHRyWEt5bnBHYmtRUWFnbTM5OGhB?=
 =?utf-8?B?dCs0aEdIRGpSMUZZV2hVa1BUa0ROaXV5b3VFK2J3Ty9Bem0zZTlvOHZ6d3F4?=
 =?utf-8?B?ZWZKQXZZL1hOZzIzMHBZaFR5dVBmeWprTkdCYzZTcW9wM25OV0NVaUhCdVJZ?=
 =?utf-8?B?UjhWcE1SYjJVQ0E2aXkyQ1Q0NU4xYmZtaWh0TGJrd1kyK00rN2NTRzNxUWov?=
 =?utf-8?B?Mk96RVpsamJqdytieVVldlhIMFdYczJIQnlBaHY1SjYyZytjOWhsSE9QdTl5?=
 =?utf-8?B?cHU5NDRGamthYnU0azJzb3pDZU9qeERUWUZobzkyS1lLQ1RoMGU3RXRtd0th?=
 =?utf-8?B?aU1ZNUVkS3FLZjg0ZU9LdFdhWHMzQnpPYVNIalZDOHk4R3hGRUxsWmQrU2Y3?=
 =?utf-8?B?Y3doNHoyZnlMZzhXaXdiQnd3dlNkZVJIS2dYbmc4Q0hjWmh5OEwwNnFVLzZ4?=
 =?utf-8?B?Q3dOb2FhL2hQZXpOVVFmeDhJMlEwUDJ2SFNjYlNoNVZETEYxQVlRNWF4S0JM?=
 =?utf-8?B?SXN6cXFLNTF4Tm4ydzFNNnhzYS8rYWJ2cXlOVXJxWXNScFk5aDVRbEFJRGJx?=
 =?utf-8?B?TFBUWVRsZUlmbUNnRUoyd1hhRndudVMvbmhGT3c0L2xFd3VVdVoyQjRSaEVu?=
 =?utf-8?B?eHlYTzl3NndyVHdhWGUySmxZaXVVRXUxU0Z6K0hLc1B4WjU1NHMzdSsreEtT?=
 =?utf-8?B?TTBTYlp5b2ZSS0ozcys2V2pQSzc3T2pqeHVtaVJHTjRKbTNMdWhGREF2TlVk?=
 =?utf-8?B?RzVXN3JycEFmMlF5R0lzL2h5NmJiVlNiQ1NLR1FqVDN1MU1BYk1MZDR5b0pF?=
 =?utf-8?B?T0JCK0dEM3R5bDdER2dRcE03dS9zZU9NdDVXQ29oMll3NEdqYVBvZ0EvcGZI?=
 =?utf-8?B?QzJWdDNaSEV3UVZqamtWUVNLMGJ6UVJiU0wzOXJXaDR5Zit2ZHltbUtxUzlJ?=
 =?utf-8?B?VWkxSTV6SkhGek50azJNWkFPZHJ4WVZMMWs1L09GNDZoekRDNkQ2c3luNzJZ?=
 =?utf-8?B?QmwxSi8vUWVjUVYvcGhmanZjNWExTEpGbG5hbkY5TDUrKzF3TGxabnNGTmh0?=
 =?utf-8?B?SlkwdnFKWE8zQkJCd2Fia2FXV3pXRHJ6SnVVR2NiUmEra3BXMzcvMUloVUM0?=
 =?utf-8?B?VTRmS0hSTnVsdGlnNSt1T0xiK0pVT29OMU9MNEdYS1NPTWdFbmhzTEZmbjRG?=
 =?utf-8?B?bkR6eUxCdWhic0YrVjY3bkJtRkNocXh5SnNJT2hmSkp2WWFLTjV0V0Y0NkZz?=
 =?utf-8?B?OWxjZEpqVHYxdVVrd3FNaU00M2V1Q3N5WTV3a1pIdVlOL0lpSldaUCtVZEVJ?=
 =?utf-8?B?ZkVNMlhONktwM04ybDR5S3BKdzNDNFQvdGxQcmErYkV0ZE5TRFE4Nzg4empY?=
 =?utf-8?B?R3lRb204bGZaQmRRRzkzUHg5MnBrcm9LMktVVnh0UUhvdTNiTHV5RXNPTGho?=
 =?utf-8?B?NE0waGo3RWZseFZwK0FJR21tb1lWRE0xejVaY2tWbUdRcGlpbmFOUy8xcklG?=
 =?utf-8?B?dENFUExBdXBPNmUvWXRoLzlhems5blkyUE5oQWV1Si93Qy9MRkhtLzJUWFI2?=
 =?utf-8?B?aHd3U1JnMHVHV0V3WC9IYkRCNjV0b0kyZ0Q5RGtkUXBXMVBYMnlKRUhHNmd0?=
 =?utf-8?B?Q1Q4Z25CSkNPWVVOcHREekJvbVQ3QjhxVWM3U0ppK2Jxc2VRTm5iQ2JSbjYr?=
 =?utf-8?B?cHZmWFRMTE80eXI4ME1aT1dISlRFR1hHWjRJZzRlQ1IxZHoyQmdwTzJ1dzZB?=
 =?utf-8?Q?DJOImW6vdSS/xMqvnmtDhGjYv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6565A285F1CC7A4F8745898ED9A31787@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9143dc5a-93ad-4ddb-439b-08dd5fc1f256
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2025 10:54:35.5464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3QY9R85852C3T/HfDy1l58QjTo8s9FW9swnRP+HHQ0HIv+7PLSraItirqLsP28Rm3m5K0xX53QUs7/MiQTLabA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6995
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAzLTEwIGF0IDA5OjQyICswMTAwLCBJbmdvIE1vbG5hciB3cm90ZToNCj4g
KiBIdWFuZywgS2FpIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gU3Vu
LCAyMDI1LTAzLTA5IGF0IDE4OjIyICswMTAwLCBWbGFkaXMgRHJvbm92IHdyb3RlOg0KPiA+ID4g
QSBrZXJuZWwgcmVxdWlyZXMgWDg2X0ZFQVRVUkVfU0dYX0xDIHRvIGJlIGFibGUgdG8gY3JlYXRl
IFNHWCBlbmNsYXZlcy4NCj4gPiANCj4gPiBUaGUga2VybmVsIHJlcXVpcmVzIC4uLg0KPiA+IA0K
PiA+ID4gVGhlcmUgaXMgcXVpdGUgYSBudW1iZXIgb2YgaGFyZHdhcmUgd2hpY2ggaGFzIFg4Nl9G
RUFUVVJFX1NHWCBidXQgbm90DQo+ID4gPiBYODZfRkVBVFVSRV9TR1hfTEMuIEEga2VybmVsIHJ1
bm5pbmcgb24gc3VjaCBhIGhhcmR3YXJlIGRvZXMgbm90IGNyZWF0ZQ0KPiA+ID4gL2Rldi9zZ3hf
ZW5jbGF2ZSBmaWxlIHNpbGVudGx5LiBFeHBsaWNpdGx5IHdhcm4gaWYgWDg2X0ZFQVRVUkVfU0dY
X0xDDQo+ID4gPiBpcyBub3QgZW5hYmxlZCB0byBwcm9wZXJseSBub2ZpdHkgYSB1c2VyIGFib3V0
IHRoaXMgY29uZGl0aW9uLg0KPiA+IAkJCSAgICAgXg0KPiA+IAkJCSAgICAgbm90aWZ5DQo+ID4g
DQo+ID4gQW5kIEkgZG9uJ3QgdGhpbmsgIm5vdGlmeSIgaXMgY29ycmVjdCBiZWNhdXNlIHRoZSBy
ZWFsaXR5IGlzIHRoZSANCj4gPiBrZXJuZWwgb25seSBwcmludHMgc29tZSBlcnJvciBtZXNzYWdl
IHNvIHRoYXQgdGhlIHVzZXIgY2FuIGNoZWNrIGFuZCANCj4gPiBzZWUgd2hlbiBpdCB3YW50cy4N
Cj4gPiANCj4gPiBIb3cgYWJvdXQ6DQo+ID4gDQo+ID4gRXhwbGljaXRseSBwcmludCBlcnJvciBt
ZXNzYWdlIGlmIFg4Nl9GRUFUVVJFX1NHWF9MQyBpcyBub3QgcHJlc2VudCANCj4gPiBzbyB0aGF0
IHRoZSB1c2VycyBjYW4gYmUgYXdhcmUgb2YgdGhpcyBjb25kaXRpb24gd2hpY2ggcmVzdWx0cyBp
biBTR1ggDQo+ID4gZHJpdmVyIGJlaW5nIGRpc2FibGVkLg0KPiA+IA0KPiA+ID4gDQo+ID4gPiBU
aGUgWDg2X0ZFQVRVUkVfU0dYX0xDIGlzIGEgQ1BVIGZlYXR1cmUgdGhhdCBlbmFibGVzIExFIGhh
c2ggTVNScyB0byBiZQ0KPiA+ID4gd3JpdGFibGUgd2hlbiBydW5uaW5nIG5hdGl2ZSBlbmNsYXZl
cywgaS5lLiB1c2luZyBhIGN1c3RvbSByb290IGtleSByYXRoZXINCj4gPiA+IHRoYW4gdGhlIElu
dGVsIHByb3ByaWV0YXJ5IGtleSBmb3IgZW5jbGF2ZSBzaWduaW5nLg0KPiA+IA0KPiA+IFVzaW5n
ICJyb290IGtleSIgY2FuIGJlIGNvbnRyb3ZlcnNpYWwuICBMZXQncyBqdXN0IHNheSAia2V5IiBp
bnN0ZWFkLg0KPiA+IA0KPiA+IEFuZCB0aGUgWDg2X0ZFQVRVUkVfU0dYX0xDIGZlYXR1cmUgaXRz
ZWxmIGRvZXNuJ3QgYXV0b21hdGljYWxseSBlbmFibGUgTEUgTVNScw0KPiA+IHRvIGJlIHdyaXRh
YmxlLiAgV2Ugc3RpbGwgbmVlZCB0byBvcHQtaW4gaW4gdGhlICdmZWF0dXJlIGNvbnRyb2wnIE1T
Ui4NCj4gDQo+IFdoeSB3b3VsZCBpdCBiZSBjb250cm92ZXJzaWFsPw0KDQpJZiB3ZSBhcmUgdGFs
a2luZyBvdXQgZnJvbSBrZXkgZGVyaXZhdGlvbidzIHBlcnNwZWN0aXZlLCBJIHRoaW5rIHRoZSAi
cm9vdCBrZXkiDQpyZWZlcnMgdG8gc29tZXRoaW5nIHRoYXQgc2l0cyBhdCB0aGUgYm90dG9tIG9m
IHRoZSBrZXkgaGllcmFyY2h5IGFuZCBpcyBpbnZvbHZlZA0KaW4gdGhlIGtleSBkZXJpdmF0aW9u
IG9mIG90aGVyIGtleXMuDQoNCklmIHdlIGFyZSB0YWxraW5nIGFib3V0IGFzeW1tZXRyaWMga2V5
IHNpZ25pbmcgYW5kIHZlcmlmaWNhdGlvbiwgdGhlbiBJIHRoaW5rDQp0aGUgInJvb3Qga2V5IiBt
ZWFucyB0aGUgcHJpdmF0ZSBrZXkgb2YgdGhlIGxhc3QgbGV2ZWwgb2YgdGhlIGNlcnRpZmljYXRl
LWNoYWluLg0KDQpIZXJlIHRoZSBrZXkgdXNlZCB0byBzaWduIHRoZSBlbmNsYXZlIGZpdHMgbmVp
dGhlciBvZiBhYm92ZTrCoA0KDQpJdCdzIG5vdCB0aGUgcm9vdCBvZiBhbnkgY2VydGlmaWNhdGUg
Y2hhaW4uICBUaGUgTVJTSUdORVIgKHRoZSBoYXNoIG9mIHRoZQ0KZW5jbGF2ZSBzaWduaW5nIGtl
eSkgaXMgbm90IGludm9sdmVkIGluIGFsbCBTR1gga2V5IGRlcml2YXRpb25zIGVpdGhlciAoZS5n
LiwNCnRoZSBkZXJpdmF0aW9uIG9mIFJFUE9SVF9LRVkgZG9lc24ndCB1c2UgaXQsIGFuZCB0aGUg
U0VBTF9LRVkgY2FuIGNob29zZSB0byBub3QNCnVzZSBpdCkuDQoNCj4gDQo+ID4gSG93IGFib3V0
Og0KPiA+IA0KPiA+IFRoZSBYODZfRkVBVFVSRV9TR1hfTEMsIGEuay5hLiBTR1ggTGF1bmNoIENv
bnRyb2wsIGlzIGEgQ1BVIGZlYXR1cmUgDQo+ID4gdGhhdCBlbmFibGVzIExFIChMYXVuY2ggRW5j
bGF2ZSkgaGFzaCBNU1JzIHRvIGJlIHdyaXRhYmxlICh3aXRoIA0KPiA+IGFkZGl0aW9uYWwgb3B0
LWluIHJlcXVpcmVkIGluIHRoZSAnZmVhdHVyZSBjb250cm9sJyBNU1IpIHdoZW4gcnVubmluZyAN
Cj4gPiBlbmNsYXZlcywgaS5lLiwgdXNpbmcgYSBjdXN0b20ga2V5IHJhdGhlciB0aGFuIHRoZSBJ
bnRlbCBwcm9wcmlldGFyeSANCj4gPiBrZXkgZm9yIGVuY2xhdmUgc2lnbmluZy4NCj4gDQo+IA0K
PiA+ID4gU2lnbmVkLW9mZi1ieTogVmxhZGlzIERyb25vdiA8dmRyb25vdkByZWRoYXQuY29tPg0K
PiA+IA0KPiA+IEkgdGhpbmsgdGhpcyBtZXNzYWdlIHdpbGwgYmUgdXNlZnVsIGZvciBzb21lb25l
IHdobyBrbm93cyBTR1ggaW4gDQo+ID4gZ2VuZXJhbCBidXQgZG9lc24ndCBrbm93IHRoYXQgTGlu
dXggU0dYIGRyaXZlciByZXF1aXJlcyB0aGUgTEUgTVNScyANCj4gPiB0byBiZSB3cml0YWJsZSwg
dGh1cyByZXF1aXJlcyB0aGUgQ1BVIHN1cHBvcnRzIFNHWF9MQyBmZWF0dXJlIGJpdC4NCj4gPiAN
Cj4gPiBXaXRoIHRoZSBhYm92ZSBhZGRyZXNzZWQsIGZlZWwgZnJlZSB0byBhZGQ6DQo+ID4gDQo+
ID4gQWNrZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gDQo+IFRoYW5r
cywgSSd2ZSBlZGl0ZWQgdGhlIGNoYW5nZWxvZyB0byBiZSBhIGJpdCBjbGVhcmVyLg0KPiANCj4g
SSBhbHNvIGFkZGVkIGFuIGVycm9yIG1lc3NhZ2Ugd2hlbiB0aGUgZHJpdmVyIGZhaWxzIHRvIHJl
Z2lzdGVyLCBhbmQgDQo+IG1hZGUgYWxsIDMgZmFpbHVyZSBlcnJvciBtZXNzYWdlcyBjb25zaXN0
ZW50IGFuZCByZWZlciBiYWNrIHRvIHRoZSANCj4gL2Rldi9zZ3hfZW5jbGF2ZSBkZXZpY2Ugbm9k
ZSBuYW1lLg0KPiANCj4gSSBhbHNvIGluY2x1ZGVkIHBhcnQgb2YgdGhpcyBjb21taXQgbWVzc2Fn
ZSBub3RlOg0KPiANCj4gPiA+IGFuIG91dC1vZi1jb21taXQtbWVzc2FnZSBub3RlOg0KPiA+ID4g
DQo+ID4gPiBJJ3ZlIGhpdCB0aGlzIGlzc3VlIG15c2VsZiBhbmQgaGF2ZSBzcGVudCBzb21lIHRp
bWUgcmVzZWFyY2hpbmcgd2hlcmUgaXMNCj4gPiA+IG15IC9kZXYvc2d4X2VuY2xhdmUgZmlsZSBv
biBhbiBTR1gtZW5hYmxlZCBoYXJkd2FyZSwgc28gdGhpcyBpcyBhIGJpdA0KPiA+ID4gcGVyc29u
YWwuDQo+ID4gPiANCj4gPiA+IExpbmtzIHJlbGF0ZWQ6DQo+ID4gPiBodHRwczovL2dpdGh1Yi5j
b20vaW50ZWwvbGludXgtc2d4L2lzc3Vlcy84MzcNCj4gPiA+IGh0dHBzOi8vcGF0Y2h3b3JrLmtl
cm5lbC5vcmcvcHJvamVjdC9wbGF0Zm9ybS1kcml2ZXIteDg2L3BhdGNoLzIwMTgwODI3MTg1NTA3
LjE3MDg3LTMtamFya2tvLnNha2tpbmVuQGxpbnV4LmludGVsLmNvbS8NCj4gDQo+IEJlY2F1c2Ug
dGhpcyBleHBlcmllbmNlIHJlZmxlY3RzIGFyZ3VhYmx5IHBvb3IgdXNhYmlsaXR5OiBwZW9wbGUg
c2VlIA0KPiAnU0dYJyBpbiB0aGVpciAvcHJvYy9jcHVpbmZvIGZpbGUsIHRoaW5rIHRoYXQgdGhl
aXIgaGFyZHdhcmUgaXMgJ1NHWCANCj4gZW5hYmxlZCcgYW5kIGFyZSB3b25kZXJpbmcgd2h5IHRo
ZSBoZWxsIHRoZSAvZGV2L3NneF9lbmNsYXZlIGRldmljZSANCj4gbm9kZSBpcyBub3QgY3JlYXRl
ZCwgcmlnaHQ/DQoNClllcyBJIGJlbGlldmUgc28uDQoNCj4gDQo+IEkgYWxzbyBDYzotZWQgbW9y
ZSBTR1ggcGVvcGxlLg0KPiANCj4gU2VlIHRoZSBmdWxsIC12MyBwYXRjaCBiZWxvdy4NCj4gDQo+
IElzIHRoZSBkZXZpY2Ugbm9kZSBtaXNuYW1lZCwgc2hvdWxkIGl0IGJlIC9kZXYvc2d4X2xjX2Vu
Y2xhdmU/wqANCj4gDQoNCk5vLiAgRm9ybSBTR1ggaGFyZHdhcmUncyBwZXJzcGVjdGl2ZSwgTEMg
KExhdW5jaCBDb250cm9sKSBpcyBhIGNvbnRyb2wgbWVjaGFuaXNtDQp0byBhbGxvdyBydW5uaW5n
IDNyZCBwYXJ0eSdzIExhdW5jaCBFbmNsYXZlIChMRSksIHdoaWNoIGlzIGEgc3BlY2lhbCBlbmNs
YXZlDQp1c2VkIHRvIGNvbnRyb2wgcnVubmluZyBvdGhlciBlbmNsYXZlcy4NCg0KTGludXggU0dY
IGRyaXZlciBkb2Vzbid0IGRpc3Rpbmd1aXNoIHdoZXRoZXIgdGhlIGVuY2xhdmUgaXMgTEUgb3Ig
bm90LCBpdCBqdXN0DQp0cmVhdCBhbGwgZW5jbGF2ZXMgdGhlIHNhbWUuICBTbyB0aGUgbmFtZSBz
aG91bGQgYmUgL2Rldi9zZ3hfZW5jbGF2ZS4NCg0KPiBTaG91bGQgDQo+IHdlIGhpZGUgdGhlIFNH
WCBmZWF0dXJlIGJpdCBmcm9tIGNwdWluZm8gd2hlbiBTR1hfTEMgaXMgbm90IHByZXNlbnQsIHNv
IA0KPiB0aGF0IHBlb3BsZSBkb24ndCBnbyBvbiBhIHdpbGQgZ29vc2UgY2hhc2U/DQoNCk5vLiBL
Vk0gU0dYIHZpcnR1YWxpemF0aW9uIGNhbiBzdGlsbCB3b3JrIHdpdGhvdXQgdGhlIFNHWF9MQyBm
bGFnIChvbmx5IFNHWCBmbGFnDQppcyBuZWVkZWQpLg0KDQoNCg0K
