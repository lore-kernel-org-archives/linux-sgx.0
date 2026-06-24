Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E016221FF25;
	Wed, 24 Jun 2026 12:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782303145; cv=fail; b=dDNQIaLPpV2w5/Nn9ssdTkPimgnHvsr17tLSnBfCjDRhhf9CQu+6qlBPgpNxTkID/0txrgIILc2gnNJqphNVK/aB3W2HDgc/Ar9+EBl5FhFdPfGWYVGQRkItnxZI1vjZoITObHfqi31iSWImEAm0mqnjdbdc7sU4IINIZwhcD00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782303145; c=relaxed/simple;
	bh=Jexop0kDb1N5UsS+99N2zrrEwvbfay8uhOKmfBS2nCA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MgPj98QRPPtcG0kENCKDw+H/WFbFndjCxU2loFBd4cFccJJNyghzgC3S722e/JjQ2gTpMdUu/JY85lMG8vMrfG0idp4HF0NlVKPrmBlRQmswY2AQmnJKTxYloa82qeBZyclOsd//htlyNivYDbF5jRfdZSNUpXJSDSQ6e/q8UwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ktkJcGdp; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ktkJcGdp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782303144; x=1813839144;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Jexop0kDb1N5UsS+99N2zrrEwvbfay8uhOKmfBS2nCA=;
  b=ktkJcGdpboCaOWnZEAdcRTrKXxaOvnlDxIDzMa5453KtDuyyRh4P+07c
   t8e9NES7lvMEhawDaL28XnfiFJB7zLawqnMb47s9J4++oOUD86lfHWSP3
   XNF1doUKuOK6iqHZGlNcvKECPsru9QXQkcSJjJHGYAiHEBB4aRJg3kKuE
   B6Cf+fs4PyHkNDEJWtdM5TbtU15y+dKNw9ycJ6u7RI+OmYOe4cOxiD0nd
   n0jsfnPpJNYPs2ulEH2MMoI2F3pOfLg4BoBrx++rcI57VMCcA6vu8poTE
   QxZCq0UZOMarueXnoaOaXL1r6H7ImWmiFmrB2AT3zmBglp3HfLimozogE
   g==;
X-CSE-ConnectionGUID: 0S9erjTVRqiaaD3d2cyOeQ==
X-CSE-MsgGUID: HVchXnXaSHaGjVtlWq+pbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="93660079"
X-IronPort-AV: E=Sophos;i="6.24,222,1774335600"; 
   d="scan'208";a="93660079"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 05:12:23 -0700
X-CSE-ConnectionGUID: DgEuzuQQQHGET5Ni2xSazA==
X-CSE-MsgGUID: RKPYCQN7TveyQ0KeP3hEGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,222,1774335600"; 
   d="scan'208";a="254198022"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 05:12:23 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 05:12:22 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 24 Jun 2026 05:12:22 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.26) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 05:12:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+FiWvDXXnpecblxUv64SSBdHdZriydsxhhF8quNBlDJlpF9K9Cm3yLc1kqQALBTAKFyksESJqr9RK9oGNlViLUsQ5BBcDdDk7bFESOXmP6dslyZtNkUbS+aIXgOAGa2vlXPDQYmpTxN7fqzzFi09vRDKs/LtRcow4HrMiOXQPbD1tsqfNAcGwHleqJMX2QdA2HO9Gn0gNjAD82lU+ft9hVp5ZaIjFqqBypCWFmoChCDBK7VE655V9CtXA4nZ1d7ecldtKYBMQuRQEAmUXxPMZCdZwRYx3K9d0l1Xl3PD6pBaC3OZzg+YrdAJ4VdD7d4o8G9iDigfVMNbQNR79iyFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jexop0kDb1N5UsS+99N2zrrEwvbfay8uhOKmfBS2nCA=;
 b=OTMedWwoV1nJQMdGB9/D8WXi+g9iVUY1XVHareTrZ41blkhyMKkywC4+AQMnGXR4rl6btBl2ie1herz2aE+PDnUiONVo6rsGi45qKpMjsstcL66PbpLYxugVGQw/D0TOVI8L4LYXB4Kp3prGlr7vxhLXxV5Cz//BpkRQYfdgrnb5tcrANriWAxHLiuUXWz7bALcK2wXLZ0UyEfO4EtmkFXcLqT2NoSShBLEBlQ4w/qMpB09DjRJvYVn9Lup4PXIIcsDXKIttMeHzKppCFnxcskErVO60YC+VH6yTUzlFjB5M7/HGFDDxl4t2OmquzgZh0FQqS7iljmwKNuEYaUUHJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 SN7PR11MB7138.namprd11.prod.outlook.com (2603:10b6:806:2a1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.21; Wed, 24 Jun 2026 12:12:19 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%3]) with mapi id 15.21.0159.012; Wed, 24 Jun 2026
 12:12:18 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Miao, Jun" <jun.miao@intel.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Du, Fan"
	<fan.du@intel.com>, "challvy.tee@gmail.com" <challvy.tee@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"qiang.zhang@linux.dev" <qiang.zhang@linux.dev>
Subject: Re: [PATCH v3] x86/sgx: Fix RCU Tasks stalls in EPC sanitization loop
Thread-Topic: [PATCH v3] x86/sgx: Fix RCU Tasks stalls in EPC sanitization
 loop
Thread-Index: AQHdAr87yB3y2gO2pE6XboTGpTSlf7ZMAraAgAFl44CAADdNAA==
Date: Wed, 24 Jun 2026 12:12:18 +0000
Message-ID: <6c2d5ba234c4a79d13e431f344ab0c594123a33b.camel@intel.com>
References: <20260623032034.2819324-1-jun.miao@intel.com>
	 <50fe4d469227dc99c1672334021726cd5cc07856.camel@intel.com>
	 <PH7PR11MB84558F38F3AE88723204EBA29AED2@PH7PR11MB8455.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB84558F38F3AE88723204EBA29AED2@PH7PR11MB8455.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|SN7PR11MB7138:EE_
x-ms-office365-filtering-correlation-id: 74117c80-990f-4794-4e1e-08ded1e9d67c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|11063799006|18002099003|5023799004|3023799007|4143699003|22082099003|56012099006|6133799003|38070700021;
x-microsoft-antispam-message-info: 9BsLG9EL2to0aOzfOPJQD8aBHsOLMfOFp0FKSyf4xN4mgGlvNvZiAEqHFF3W7y+H1D0mtD13dMpkCIgSYSQtnU8iIjDbskZbi+U7fw8iMewzLaTbWsD6HDgRVW1SpRuAmEUbWpPvNPjGOAo0JTvuQqOdw3IwWc5o56ZotjZDMUj/H7r78FossRtTtud7FD5rTCYMeJ5qYNQRPNV5Pwd3AMlyTHAlPe7kUro/8nP0lisVaHjPO6R6eWBGJsFkvJl70vdylQw4895UxDZB1uzbrNw69MJdj5iT17GhDzdeaxEUfTD0cf4bwdxJJE+KBfTURuflED5zDGkzt+cAkim+uNVTmvwsXe2bGI/LdTEkMd6M29FRI/VbQEu9W8voSHVlbD/6dk6Si0NUBO8pWNKAQEqCmnjvb9y87x5oDMTepXqKyuWPisnwcVQU4chHzWtbXNXwzg1bwlsA7fVZqNReRdyAlYYbGIswQc1xpggHZKiKGDK14wiAAdNkAKe+tzfzg98Zkk7y8HfiWR52vlBrzCY+qLhQERpffi7pyrIhQqrgEn6hxqFgt20xchn1zRKNSz+ZUIYdWZMyHaQ1KOZkRbbtZ0g+/rLx0cwsf4ZFSxlVyYkeL6ejrKh6bhtr7b0A1QmEo4AIwFqXhYeebSWFaeOFW/1yq8VyMQ4rLqEXck2Pm/TDVMftfTDfBlOGGRyPwVtTDRUd7MSFCzMxXy+pLmNz6huxEVlRFMNUxq1gztE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(11063799006)(18002099003)(5023799004)(3023799007)(4143699003)(22082099003)(56012099006)(6133799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0VJM1FOVmpsbDNOKzEvelpjbThrRzBmTUZnb2xNajNyNEZlb0drT2FiaFUy?=
 =?utf-8?B?RStTeHEza3FjVXB0ZFpiV0NZalk3VWg0WG96dEZMcndqN0FaVTBKcGtvSkNt?=
 =?utf-8?B?bnMweUd1RmhybnZENU1HRlNFVzM0WklHMndsKzV0T2RBeU5iUmJMWndGYnJR?=
 =?utf-8?B?MkdNRTZFbVFBeS9BOENSYlMvRStWR2VON05PTkxDYWZvbncvdGpFSFYzUjBF?=
 =?utf-8?B?elFCSmxwL0ZERlJLNUNQR1NqUHFZM1R2M2wwTDF2NHpSMWN2YjVUbkU5MnQ2?=
 =?utf-8?B?NDJVWWwyS2dXbnI1MDBHaFdqYWIwOEM5R0YwTmhyUTRiUUd5elFSbEtVZVJX?=
 =?utf-8?B?UnRjSnBpdU5kREpabkloNytGQTRpcmd1QkRNSWdQRlFwdi9vOUJVWXJYSUd6?=
 =?utf-8?B?d2wwWm0xUTIxa1NFNEVwRWtJUGppUnNYclBPazNmL01KRVg5NFVNVXZSc0R5?=
 =?utf-8?B?cVkvZHZCSWM0RU1WUWtkZmtOaDl4QmtUOWxtTW8wdFVsWGY0TERDMUlhR2NH?=
 =?utf-8?B?VWFPYjQxcHo2UGxCeWlwTkZYY2tGMW1SR0JkeU1vakoxaXpkV0VSTGI2WUFj?=
 =?utf-8?B?eE1adytEQ3ZOSmZoQUx0cXIyWmNKamdsS3k5NVBEdXRiRWpJaHRQamIwZHYz?=
 =?utf-8?B?bWpCbWdERXI5UWZoczlhODlYY0tZRi8wS1dkNFU2ODBMSVgxcFdDdGM2ZEgz?=
 =?utf-8?B?OGhtWXhicTJSdmdOUFpjc0Z4eStMWnpkbnBOWkNvOVphUEpmSjA3ODNDMHVJ?=
 =?utf-8?B?NTBpQVlNS3F6K013MlZsNnMrVG54b0JuY2tzQkh4TDlSWE1rRGJGQm5PaFdx?=
 =?utf-8?B?YUZWdDdIUkZSaUlZWFNCMFB3MmNDN25SZWl3VUVnRFg0cjJ3THJhcmlEN3RT?=
 =?utf-8?B?ci9pSDVicVk4VUtPYVE4Tmt2NDNRYTNGeDhIMzRIZE1ZMjlHbWxjYzdXTlhp?=
 =?utf-8?B?SDZmSEpWN1BsaDBrMWdpY3NWUjg3WkJzRG9EVlBaUjYrYzN4Mm9mNmMyVEd1?=
 =?utf-8?B?bGg5U3paWUJQQS9GYVl1QnJhbHhQMjFMQWlReVQrbVJFNEdZRFRldThDSDVP?=
 =?utf-8?B?T29zUkw5dzRMVERzWXBqR0ljN3ZSUnhFdHhSVDc0UmtvbXZ5QXlUbUNLT05Q?=
 =?utf-8?B?ZnN2cWNKNy9RaTBNdVRQSHNmUEhHWmlOWG5hNXFFRm9Tc09GT0lsQkNjUWxZ?=
 =?utf-8?B?M3hQSWZGdkVjb2pFUzJXYkxDdzVsQXU3VStPY28yeDdKLzF5Ukg4NkdaRTU3?=
 =?utf-8?B?QnM1S1huaWtiZEdaOGRrMDc5TWRhYnk4S1prKzNKdU4rTExyR0xjb0pWQjhJ?=
 =?utf-8?B?T3R6SXlOWXB4OC9ORnlTZUZ0OFI3dFRVdmxOcG13S1pwN2czT2NGK2x6bmpE?=
 =?utf-8?B?eENjamVwVFpRaXlLRldvbVNDNHpJNGQ3MjdTS3g2TzYrRHAxMHJSOFZudThr?=
 =?utf-8?B?d0p2cm9sM2dpY1FOYWxXZHpoMUZqMzgrZ25TRHpRZzRnNlZJWGJhaGt1YW55?=
 =?utf-8?B?WTg3V0FQbU9CbnBjam5WTGhGWklmYlphcVZlOGMvcEdDVi9RVklIM0RTMkY3?=
 =?utf-8?B?ZWtVSDJmM1A0UnorR2tNQzErK3E0VUM1bTFkVGhvajdySVBzbnVjVnhQaGxr?=
 =?utf-8?B?YkM5dzR3Q0VRMlh0cTRBSHRkY2FSYWh0K3doQkE3SVhvV3VKMGJ3MG5wVnJR?=
 =?utf-8?B?WUNHSUQ4STNmSXNJbGw4Rk84RjQ0eG1FS21jUmRTVFJib3N2dzdQZDFDNGFZ?=
 =?utf-8?B?TTdOeDVTemM4SkVySWZXVERLQ0dnWUdOYXBlWEVDcmxKLzZNRzcwMVp3RHcx?=
 =?utf-8?B?M3VOV004enUyVDdMcDlGT3pXUVcwQnQzaGZrdWtlTm05bFl5VTQ2ODdOT1Zp?=
 =?utf-8?B?V2lXSUN4RXUram94ZVJFcGUzcHcxaTA0TE9ENjVTRFExR3NiR1F0QkdvU1dV?=
 =?utf-8?B?bm9INU5MbWxkRXNJUlBkTVY2RzMvdCtiYlBVT0ZIdDVCV2p6czdUaTFBclJv?=
 =?utf-8?B?Mzkra2lma1lMdkxqejlRcWpkWkI5ZFg2aUVFUmYrajhMNzRHOHlkS3J4MjRU?=
 =?utf-8?B?elJZMGNJUCtDY2k3NTVhRjd3UUlFc2d1MTVTOWFlQnFMRGRDaGhyT0NFN3M2?=
 =?utf-8?B?VGxNcXV5aVIzaS8xNzJqbTluVU9jNVY2VlYwR28xUmNDYTVTT2pOY1hFT3Nq?=
 =?utf-8?B?Y0FPOEFOZWZkemY4VFpCSk9rQ3FWa0ZiOXZManZXM3AydXhyeGNxTm0xU2h5?=
 =?utf-8?B?c2hEa1BOT2w4M3JDeXlHUWM5dDd0SmdFRER2RVNtYTFROEcyOXphTjBIUjdy?=
 =?utf-8?B?UlR0UGRFVmpOdlpvV2c5dm94SGtNMzA4QzNpYjRmSm9NKzk4ZlQzQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E503B0DADF2294ABFAC732C9B5A183B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: R2na4Z1WTJ5G6/Y92To2H6a4QxuGB4CuTn3CeyhmmtFmwxUbAxjtHtGqAZNJ0D2hhKZddfryX3Dz3eB9Mki77c2o3c4yKo/cvHiAT/cCDPPfU0KMZJTOi4KZaOJT6EjSImAQJ5KBqrwW7RRXlpnLsZufyH6AYEOu/2Szib41E61zsNYOuBJhaJ84uBSbjJzaWfL70ZOCcJINgytxZejSxvr/aDmT06fHlKGjPKPbc46TQ8/zbKoXCy69dGmfryyFQJg0v58FjU05rfchxlgqJ897Z5CNtJJwWEBXx7t+qTaYvV5EUqtVF4ooctTRvE1PT5nwezSMyksv0kqDUZlkmw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74117c80-990f-4794-4e1e-08ded1e9d67c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2026 12:12:18.8834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUgrysEdyZQKniNx6jlq5sVHHRiQs3ZBvR2NEgfLqH0qma8ryoX3DX/4Kj/O7UsItmvO9A0xr3yL1NUvFnOtng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7138
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI2LTA2LTI0IGF0IDA4OjU0ICswMDAwLCBNaWFvLCBKdW4gd3JvdGU6DQo+IEhp
IEthaSwNCj4gDQo+ID4gKFJlbWluZGVyOiB5b3UgZm9yZ290IHRoZSBsaW51eC1zZ3hAdmdlci5r
ZXJuZWwub3JnKS4NCj4gPiANCj4gT2ssICsgQ0MgbGludXgtc2d4IGluIHRoaXMgcmVwbHkuDQo+
IA0KPiA+IENvdWxkIHlvdSBtb3ZlIHNvbWUgY29udGV4dCBmcm9tIHlvdXIgdjEgYW5kIHJlZmlu
ZSB0b2dldGhlciB3aXRoIHRoZSBhYm92ZQ0KPiA+IHR3byBwYXJhZ3JhcGhzPw0KPiANCj4gT2th
eSwgd2hhdCBhYm91dCB0aGlzIGNvbW1pdCBkZXNjcmlwdGlvbiBpbiB2NT8NCj4gDQo+IFN1Ympl
Y3Q6IFtQQVRDSCB2NV0geDg2L3NneDogRml4IFJDVSBUYXNrcyBzdGFsbCBpbiBFUEMgc2FuaXRp
emF0aW9uIGxvb3ANCj4gDQo+IER1cmluZyBlYXJseSBib290LCBrc2d4ZCAoSW50ZWwgU29mdHdh
cmUgR3VhcmQgRXh0ZW5zaW9ucyBLZXJuZWwgVGhyZWFkKQ0KDQpJTUhPIHRoZXJlJ3Mgbm8gbmVl
ZCB0byBiZSBzbyB2ZXJib3NlLiAgVGhlIHBhdGNoIGhhcyB0aXRsZSAieDg2L3NneDogLi4uIiwg
c28gSQ0KdGhpbmsgcGVvcGxlIHdobyBhcmUgaW50ZXJlc3RlZCBpbiB0aGlzIHBhdGNoIHNob3Vs
ZCBhbHJlYWR5IGhhdmUgc29tZSBiYXNpYw0KaWRlYSBvZiB3aGF0IFNHWCBpcy4NCg0KPiBpdGVy
YXRlcyBvdmVyIGFsbCBwb3N0LWtleGVjIGRpcnR5IEVQQyBwYWdlcyBpbiBhIHRpZ2h0IGxvb3Ag
Y2FsbGluZw0KPiBjb25kX3Jlc2NoZWQoKSBhZnRlciBlYWNoIHBhZ2UuICBCdXQsIG9uIGlzb2xh
dGVkIENQVXMNCj4gKGEgY29tbW9uIGNvbmZpZ3VyYXRpb24gaW4gY2xvdWQgVk1zKSwgY29uZF9y
ZXNjaGVkKCkgbmV2ZXIgdHJpZ2dlcnMgYQ0KPiByZWFsIGNvbnRleHQgc3dpdGNoIGJlY2F1c2Ug
VElGX05FRURfUkVTQ0hFRCBpcyBub3Qgc2V0IHdoZW4gbm8gY29tcGV0aW5nDQo+IHJ1bm5hYmxl
IHRhc2sgZXhpc3RzIG9uIHRoYXQgQ1BVLg0KDQpBZnRlciBzZWNvbmQgdGhvdWdodCwgSUlVQywg
dGhlICJpc29sYXRlZCBDUFVzIChhIGNvbW1vbiBjb25maWd1cmF0aW9uIGluIGNsb3VkDQpWTXMp
IiBwYXJ0IGlzIGNvbmZ1c2luZywgYW5kIGFjdHVhbGx5IG5vdCByZWxldmFudCBJTUhPOiAiaXNv
bGF0ZWQgQ1BVcyIgaXMgZnJvbQ0KaG9zdCBrZXJuZWwncyBwZXJzcGVjdGl2ZSwgYnV0IHRoZSBp
c3N1ZSBpcyBpbnNpZGUgdGhlIGd1ZXN0Lg0KDQpBbSBJIG1pc3NpbmcgYW55dGhpbmc/DQoNCj4g
DQo+IEJQRiBMU00gc3Vic3lzdGVtIGNhbiBpbnZva2Ugc3luY2hyb25pemVfcmN1X3Rhc2tzKCkg
YXQga2VybmVsIGJvb3QgdGltZS4NCj4ga3NneGQoKSBjYW4gbmV2ZXIgYmUgcmVzY2hlZHVsZWQo
KSB3aGVuIGRvaW5nIHNhbml0aXppbmcgYWxsIEVQQyBwYWdlcy4NCj4gQXMgYSByZXN1bHQsIGEg
Vk0gbWF5IHRha2UgYSBsb25nIHRpbWUgdG8gYm9vdDoNCj4gDQo+IFsgIDEzNC44MDYxNTddIHJj
dV90YXNrc193YWl0X2dwOiByY3VfdGFza3MgZ3JhY2UgcGVyaW9kIG51bWJlciAxIChzaW5jZSBi
b290KSBpcyAxMzA2MzEgamlmZmllcyBvbGQuDQo+IFsgIDI0OC4wODYxNThdIElORk86IHRhc2sg
c3lzdGVtZDoxIGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAxMjIgc2Vjb25kcy4NCj4gWyAgMjQ4LjA4
NjQ5MV0gTm90IHRhaW50ZWQgNi44LjAtOTAtZ2VuZXJpYyAjOTEtVWJ1bnR1DQo+IFsgIDI0OC4w
ODY3MzldICdlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190aW1lb3V0X3NlY3Mn
IGRpc2FibGVzIHRoaXMgbWVzc2FnZS4NCj4gWyAgMjQ4LjA4Njk5M10gdGFzazpzeXN0ZW1kICAg
IHN0YXRlOkQgc3RhY2s6MCAgICBwaWQ6MSAgICB0cGlkOjEgICAgcHBpZDowICAgIGZsYWdzOjB4
MDAwMDAwMDINCj4gWyAgMjQ4LjA4NzI3NF0gQ2FsbCBUcmFjZToNCj4gLi4uDQo+IFsgIDI0OC4w
ODc5MzldIHNjaGVkdWxlX3RpbWVvdXQrMHgxNTcvMHgxNzANCj4gWyAgMjQ4LjA4ODEyMF0gd2Fp
dF9mb3JfY29tcGxldGlvbisweDg4LzB4MTUwDQo+IFsgIDI0OC4wODgzMDRdIF9fd2FpdF9yY3Vf
Z3ArMHgxN2UvMHgxOTANCj4gWyAgMjQ4LjA4ODQ4MV0gc3luY2hyb25pemVfcmN1X3Rhc2tzX2dl
bmVyaWMrMHg2NC8weDYwDQo+IC4uLg0KPiBbICAyNDguMDg5MDQ3XSBzeW5jaHJvbml6ZV9yY3Vf
dGFza3MrMHgxNS8weDIwDQo+IFsgIDI0OC4wODkyNjBdIHJlZ2lzdGVyX2Z0cmFjZV9kaXJlY3Qr
MHgzMWYvMHgzNTANCj4gLi4uDQo+IFsgIDI0OC4wOTAzMzldIGJwZl90cmFtcG9saW5lX2xpbmtf
cHJvZysweDMzLzB4NjANCj4gWyAgMjQ4LjA5MDUxOF0gYnBmX3RyYWNpbmdfcHJvZ19hdHRhY2gr
MHgzYzUvMHg1ZjANCj4gLi4uDQoNClRoZXNlIFsgMjQ4Li4uLl0gYXJlIG5vdCBuZWVkZWQuDQoN
Cj4gDQo+IEFmdGVyIHRoaXMgcGF0Y2ggdGVzdCByZXN1bHQ6DQo+IFRlc3RzIHNob3dlZCB1c2lu
ZyBjb25kX3Jlc2NoZWRfdGFza3NfcmN1X3FzKCkgcmVkdWNlZCB0aGUgYm9vdCB0aW1lIGZyb20N
Cj4gfjUwcyB0byB+MTAuN3MgKHN5c3RlbWQtYW5hbHl6ZTogNzI0bXMga2VybmVsICsgMS41NzVz
IGluaXRyZCArIDguNDgxcyB1c2Vyc3BhY2UgPSAxMC43ODJzKQ0KDQpUaGlua2luZyBtb3JlLCB0
aGUgfjUwcyBib290IHRpbWUgaXNuJ3QgcXVpdGUgY2xlYXIgdG8gbWUgZWl0aGVyLiAgVGhlIGNh
bGwNCnRyYWNlIGFib3ZlIHNob3dzIHRoZSBzeXN0ZW1kIGhhcyBibG9ja2VkIGZvciAibW9yZSB0
aGFuIDEyMiBzZWNvbmRzIi4NCg0KV2hlcmUgd2FzIHRoZSB+NTBzIGZyb20/ICBJIHN1cHBvc2Ug
aXQgd2FzIGtlcm5lbCBib290IHRpbWUgKHNpbWlsYXIgdG8gdGhlDQoiNzI0bXMga2VybmVsIiB5
b3UgbWVudGlvbmVkKT8NCg0KSWYgdGhhdCBpcyBrZXJuZWwgYm9vdCB0aW1lLCBJIHRoaW5rIHdl
IGp1c3QgbmVlZCB0byBtZW50aW9uIH41MHMgdnMgfjcwMG1zLg0KPiANCj4gWyBrYWk6IGNvbXBs
ZXRlbHkgdHJpbSBkb3duL3Jld3JpdGUgY2hhbmdlbG9nIF0NCg0KTm8gbmVlZCB0byBoYXZlIHRo
aXMgcGFydC4gIFRoZSBvYnZpb3VzIHJlYXNvbiBpcyB0aGVyZSdzIG5vIG15IFNvQiA6LSkNCg0K
SSBkb24ndCBxdWl0ZSB3YW50IHRvIGNvbXBsZXRlbHkgcmUtd3JpdGUgdGhlIGNoYW5nZWxvZywg
YnV0IHRvIHNhdmUgdGltZSwgaG93DQphYm91dCBiZWxvdz8NCg0KICBUaGUga2VybmVsIHJlc2V0
cyBhbGwgRVBDIHBhZ2VzIHRvIGEgY2xlYW4gc3RhdGUgaW4gYSBsb29wIGJlZm9yZSB1c2luZyB0
aGVtDQogIGZvciBlbmNsYXZlcy4gIFRoZSBudW1iZXIgb2YgRVBDIHBhZ2VzIGNvdWxkIGJlIGxh
cmdlIChlLmcuLCBHQnMpIHRodXMgDQogIHJlc2V0dGluZyB0aGVtIGNvdWxkIHRha2UgYSBmYWly
IGFtb3VudCBvZiB0aW1lLiAgQmVjYXVzZSBvZiB0aGF0LCBkdXJpbmcNCiAgZWFybHkgYm9vdCwg
dGhlIGtlcm5lbCByZXNldHMgRVBDIHBhZ2VzIHRocm91Z2ggYSBrZXJuZWwgdGhyZWFkIGtzZ3hk
KCkgYW5kDQogIHRoZXJlJ3MgYSBjb25kX3Jlc2NoZWQoKSBhZnRlciByZXNldHRpbmcgZWFjaCBF
UEMgcGFnZS4NCg0KICBUaGlzIGlzIGZpbmUgaW4gbW9zdCBjYXNlcywgYnV0IGJlY29tZXMgYSBw
cm9ibGVtIHdoZW4gdGhlcmUncyBvdGhlciBrZXJuZWwNCiAgY29kZSB3YWl0aW5nIGZvciBSQ1Ut
VGFza3MgZ3JhY2UgcGVyaW9kIGJ1dCB0aGUgY29uZF9yZXNjaGVkKCkgaW4ga3NneGQoKQ0KICBu
ZXZlciB0cmlnZ2VycyByZXNjaGVkdWxpbmcuICBCZWNhdXNlIGNvbmRfcmVzY2hlZCgpIGRvZXNu
J3QgcmVwb3J0IHF1aWVzY2VudA0KICBzdGF0ZSB3aGVuIGl0IGRvZXNuJ3QgdHJpZ2dlciByZXNj
aGVkdWxpbmcsIHRoZSB0aHJlYWQgdGhhdCBpcyB3YWl0aW5nIGZvciANCiAgUkNVLVRhc2tzIGdy
YWNlIHBlcmlvZCB3aWxsIG5lZWQgdG8gd2FpdCB1bnRpbCBhbGwgRVBDIHBhZ2VzIGFyZSByZXNl
dC4NCg0KICBGb3IgaW5zdGFuY2UsIEJQRiBMU00gc3Vic3lzdGVtIGNhbiBpbnZva2Ugc3luY2hy
b25pemVfcmN1X3Rhc2tzKCkgYXQga2VybmVsDQogIGJvb3QgdGltZS4gIEEgVk0gd2l0aCBhIGxh
cmdlIEVQQyBhc3NpZ25lZCBhbmQgaGF2ZSBCUEYgTFNNIGVuYWJsZWQgY2FuIHRha2UNCiAgYSBs
b25nIHRpbWUgdG8gYm9vdCwgd2l0aCBhIGNhbGwgdHJhY2UgdHJpZ2dlcmVkOg0KDQogICAgcmN1
X3Rhc2tzX3dhaXRfZ3A6IHJjdV90YXNrcyBncmFjZSBwZXJpb2QgbnVtYmVyIDEgKHNpbmNlIGJv
b3QpIGlzIDEzMDYzMQ0KamlmZmllcyBvbGQuDQogICAgSU5GTzogdGFzayBzeXN0ZW1kOjEgYmxv
Y2tlZCBmb3IgbW9yZSB0aGFuIDEyMiBzZWNvbmRzLg0KICAgIC4uLg0KICAgIHRhc2s6c3lzdGVt
ZCAgICBzdGF0ZTpEIHN0YWNrOjAgICAgcGlkOjEgICAgdHBpZDoxICAgIHBwaWQ6MCAgIA0KZmxh
Z3M6MHgwMDAwMDAwMg0KICAgIENhbGwgVHJhY2U6DQogICAgLi4uDQogICAgc2NoZWR1bGVfdGlt
ZW91dCsweDE1Ny8weDE3MA0KICAgIHdhaXRfZm9yX2NvbXBsZXRpb24rMHg4OC8weDE1MA0KICAg
IF9fd2FpdF9yY3VfZ3ArMHgxN2UvMHgxOTANCiAgICBzeW5jaHJvbml6ZV9yY3VfdGFza3NfZ2Vu
ZXJpYysweDY0LzB4NjANCiAgICAuLi4NCiAgICBzeW5jaHJvbml6ZV9yY3VfdGFza3MrMHgxNS8w
eDIwDQogICAgcmVnaXN0ZXJfZnRyYWNlX2RpcmVjdCsweDMxZi8weDM1MA0KICAgIC4uLg0KICAg
IGJwZl90cmFtcG9saW5lX2xpbmtfcHJvZysweDMzLzB4NjANCiAgICBicGZfdHJhY2luZ19wcm9n
X2F0dGFjaCsweDNjNS8weDVmMA0KDQpSZXBsYWNlIGNvbmRfcmVzY2hlZCgpIHdpdGggY29uZF9y
ZXNjaGVkX3Rhc2tzX3JjdV9xcygpIHdoaWNoIGV4cGxpY2l0bHkgcmVwb3J0DQpxdWllc2NlbnQg
cmVnYXJkbGVzcyB3aGV0aGVyIGFjdHVhbCByZXNjaGVkdWxpbmcgaXMgdHJpZ2dlcmVkLiAgUmVz
ZXR0aW5nIGFsbA0KRVBDIHBhZ2VzIGluIGtzZ3hkKCkgaXNuJ3QgcGVyZm9ybWFuY2UgY3JpdGlj
YWwgc28gdGhlIGV4dHJhIGNvc3Qgb2YNCmNvbmRfcmVzY2hlZF90YXNrc19yY3VfcXMoKSBpc24n
dCBhIHByb2JsZW0uDQoNClRlc3RzIHNob3dlZCB0aGlzIHJlZHVjZWQgdGhlIFZNIGtlcm5lbCBi
b290IHRpbWUgZnJvbSB+NTBzIHRvIH43MDBtcy4NCg0KKFRoaXMgYXNzdW1lcyB0aGUgfjUwcyBp
cyB0aGUga2VybmVsIGJvb3QgdGltZSAtLSBwbGVhc2UgZG91YmxlIGNoZWNrLikNCg==
