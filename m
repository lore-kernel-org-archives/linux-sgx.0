Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6466920B7FB;
	Wed, 14 May 2025 07:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207997; cv=fail; b=JuO72grIE6nLcZlHbQOFCWhihE9Z2M4EDDuoeDjg4E+aj7qAxw4OwXOHEduKQ9r32acs8a3kGUeUzajpahLY052Y02dKsViBl5njJ4upGjihI3dpuPyxjhZkGqEbFSPciNPGim8Idt4lshU06WXpRBa2+9J+OeqTF94pxajnCHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207997; c=relaxed/simple;
	bh=1UBDk15xXvW37s+LmUkSdUCVdoaqGz7i/UTtpExcVGE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aNupQB86HabhT4KjykgIsoNTLHlKlX/P4dqvAccoR12WYQrovrii+qki3zupzYmMDkQGCFt+BDnAWl6Xrolxljy+OBbDBGOVP+Nd4/grHam+5lzPqzDQsq2AnspkrIdVWKg9jF9nwXp5ySVYt67aX83ZEr1LfPeWLWFOrHR2wnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FzH+8Mhx; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FzH+8Mhx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747207996; x=1778743996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1UBDk15xXvW37s+LmUkSdUCVdoaqGz7i/UTtpExcVGE=;
  b=FzH+8MhxunBH4UhjuS7f7zJdTXZZzI/h40H/ZgDQFNNccLU/hOAIepN5
   up+VqX8MxEso6jHtDortqyeZA9ORcaYPKFolvBRmhFd/OuUMiRi3TUbQ9
   ALjoraOrCfDxHrmOZmBHfdyHhBlk5dDsFPxaWIuODnaYXscmtMkrcNFzT
   yAikG9SJjsaoiF9oaKIbHOyo/UeqkkklqrOraZjfWAgGG/owHp1YuABs6
   BVoSeN5DFFrPoU+pKAnDVB6zmtfCjcvKy4JkXEw9I4tfzP4f4Rxu5LZHo
   AghruVmnW8IWEsDBSruxVhUmUukKu+BwTXdP8MtoxoY5sV4WccXECvQRV
   A==;
X-CSE-ConnectionGUID: y946eKqoTDO9CckoTfw4KA==
X-CSE-MsgGUID: SFA19/Z6TAq6WZxBBUcdeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="48958036"
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="48958036"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 00:33:15 -0700
X-CSE-ConnectionGUID: xwU3LyVlQu+2fJ4O6hTmiQ==
X-CSE-MsgGUID: kLl4hZ0fTkSnLZUhhyb7gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="137877508"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 00:33:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 14 May 2025 00:33:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 14 May 2025 00:33:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 14 May 2025 00:33:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NWU39CxDK3CtrD5NY4c+QFZhCqmbqpHLbQ6CJHeCYs6iQ9vQaYRAJctuVatmJRmeKZD0DihcEZF1oII4kPhlkGoO+0BjsVYoe59u/3zW0hSlfFc6LYsTCfDW+91VwV40llq002LPj63gTHn8J6I8cgGg5NooFdbwzuh4i4GoVgfJ0/PDrXNMVPSocK2LSt3beMaaDFFdNfJdeCGd6sKfU3k5Od1/Zb+Hr+mb5a3ZHyyEwy9vcXDpQUB8epTQI1XyhvzjnD8HnUFalRVhGZ0pdIxKLm00tXAoe4a+FgSpLkmhFSUPn9V5BwHg+b+T53fp+ExKrPkfCWQ/g6DBvvzu0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UBDk15xXvW37s+LmUkSdUCVdoaqGz7i/UTtpExcVGE=;
 b=C5JN/9Eg4uWwGo8NfHPuvpHrMPK43mf0nxGNdru3p70prmRP+WLjdEkhMlWVO/qFc6/1yz01w8F9nqaUSJ3Zqn6GZghStNruiZwOHLBGvqOAJ8vLIWvLlZ1t9m5Px77v1EBBxGVRWSHu2hqqVZ4We+uU4BvBDsMlEnKLC4waGfmq1eMLiDKahCnQtgAWfUlLxGLZyBW/Ggl9iAyW53hXTnzmdMaaMBP4lQkHtM+J7qVD9l4elldyCBmqwaS+xj0Ab2qzXhSUXCp5QG9dcPKX1uxrxKs8UGAmU8uIHt+FpAah17KWNjLvTzKV03MFd9LlrlrYBwVxe3hNAlNzeBjG4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 MW4PR11MB7162.namprd11.prod.outlook.com (2603:10b6:303:212::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.30; Wed, 14 May 2025 07:32:40 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 07:32:40 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "bondarn@google.com"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v4 1/1] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v4 1/1] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHbv0FzcDl1rDYTb0CkYUTLrcXms7PHVPiAgAFpZgCAACOdgIABTplAgAeUS5A=
Date: Wed, 14 May 2025 07:32:40 +0000
Message-ID: <DM8PR11MB5750202F36E2AA2443FB5762E791A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250507111542.709858-1-elena.reshetova@intel.com>
 <20250507111542.709858-2-elena.reshetova@intel.com>
 <023ab74f-82b7-41fc-ab20-0c0089f1f348@intel.com>
 <DM8PR11MB5750FBF44109B8CAD5574922E78BA@DM8PR11MB5750.namprd11.prod.outlook.com>
 <21752778-b6c8-42aa-8be6-db93a30a570c@intel.com>
 <DM8PR11MB5750FA8798AF68845D81717FE797A@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750FA8798AF68845D81717FE797A@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|MW4PR11MB7162:EE_
x-ms-office365-filtering-correlation-id: 1fa36052-960a-44ee-c86f-08dd92b981e0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cmpwVkg1VTZROWNzeWdiUEJTSWFhYmNxQmVQMFpPeGFvQ2kwR21IeExqVCt4?=
 =?utf-8?B?T01sRjEwUlNONUpicTNnME9Gc24vTDlZb0VhbGdLKzFNT0hvREo0RkF1VUVa?=
 =?utf-8?B?NzE5MW9ZMGRVb2hDNlJGNUJmWm9rZG1BK2IwV0w1aW9EOVlTaldWbVVKamtw?=
 =?utf-8?B?T1RybTE3bnAzM093eU9Fc3VobHdYUXNmMHBQM01zeUdhZVFKY1BCakRKSDFV?=
 =?utf-8?B?ZG5WNXlhRytCMjR6eDFYMkFjZ2kxRi96NE0wZjRYNW5NQzdhV0UxQmJWazg4?=
 =?utf-8?B?YzIwQUJHQjdIR0lyV2QybVB4YWZMVW04MVV5QzBNT2dsc3VNa3o2ditTVXFP?=
 =?utf-8?B?OUNzUnVkcFZqNlVOWHFqMVY2VlplRVp4eXdhcjlRdGQ4Yzg4K1dOZXRxcXB3?=
 =?utf-8?B?bmRNTGN6VmVRRThMNDZkYWdzcjhvWTZheFV3WGVKNFJrR21EdlY2Z2lyblgv?=
 =?utf-8?B?WkEwOXNLM0haeHdiOHNKVk5zNFdxc3pYQ2lPWE9FS3BiaHUyVEl1MjRBQWtI?=
 =?utf-8?B?NXJiVlpzc3IrNjJNYkdLL3E1K1M4eG9ZUS85UTNPcjZpYzNUQm1kamw3bDJV?=
 =?utf-8?B?bjBBQzFvS3lrVzdPRzQxRlBUK29vTkswR1laM21VNERRcno2WTA5dlFBaElj?=
 =?utf-8?B?bERGRjNtNHU4QkREYnpSWXQyTFV3c3BxQjJLcGxMb0dHTUtCVmd3QTR1RWs4?=
 =?utf-8?B?ZmZGYnZKdURZeElUYllOL2FhMGdjN2xLc2x4NTJtdjVVRFFvazZva2dsb1p3?=
 =?utf-8?B?WEo4a2lCa0JKek1vR3dZODdGL1VnRkZLdWJZUnFRcUJCVURYTURNRVV6UEVG?=
 =?utf-8?B?VTVXMkFpTDlmVVI5aG51MitYeTN6OUVSb1k0REREajAyam9TRFppbmEvcTNz?=
 =?utf-8?B?a1V5K1ZlV3Fkb0E0S2t6SklNTTNwRnVyeWVOWXpKMHVqeUtETGEyZHN0R1cz?=
 =?utf-8?B?WTJhWkE4R3JYUEw0enZuMi9SZ2J3NTNEKzNtUmxIa0hEZUtvU25PYWI5N0F2?=
 =?utf-8?B?MGhRTmhoOExPQ3l5ck0xQUlQbWp0OXR3UnJ5KytYcUpxbHlhYXV6azBFamdD?=
 =?utf-8?B?bHlQWVB2ZlVWbzRyTmpOdzB0ZWhEWTIwKzQzNkZaOG5icGZ0TXJOdmp4S0RX?=
 =?utf-8?B?ZVkyZUxIZ2NJTnZvamdTYWdYTzlBNUowOHE5WGVGRW03cHE1aGhBUEpxNGR2?=
 =?utf-8?B?eFR6R2lPRGljMmw2VHl0L25JTVhsbzRjV0J5dzVrUjJjeDhIeHNiMXl3eSsv?=
 =?utf-8?B?dVdTaW02c3dnd3QwYWcyZmx6QWpGaksvNUhCWkVDVHBUWkdTcVRPZG5hd0ph?=
 =?utf-8?B?bnpuSHkzSndYVDdrcDJBYkkxZjJDTTZJa3UwOVlmMDdtMjBvUkEyMUdKT0pv?=
 =?utf-8?B?N3E4eklXTzB3Q2szeUJNMDV1VURtbXdQYTJrenp3YXQ0eGg3cXUzeUFDYm9n?=
 =?utf-8?B?ekUzaUZ2STJqSVU2cWVLOEVuMTIvbGFpN3NuNCtqQVdKSDE5TFFQQmgxazVV?=
 =?utf-8?B?MThvVmZUeDJkRkZkOVc2UUVhOU8vNXBNQTRvR0o0Uy9NTnRIQXc2dGpLdFha?=
 =?utf-8?B?UWVxdUlSUHdTc0hyZFQvK3RvaVNOS3JweHRTSEFaVnpvZnNVQXNzemg3Y1Zj?=
 =?utf-8?B?M2Y0Ui9LSU93bXF0eXRva3IrSWlURzRzdTIvODhlQTRnYml5dkI4MHhrZXVh?=
 =?utf-8?B?VWpqeHFJVy9XZlVoVGhucGkrbWt0dGhZY3pvMXRVVW5zRGRsRmtlQmJ5QnZs?=
 =?utf-8?B?bytnS0ZZaUlueDdkUEZoL1VlTWxYL1g2ZWNIOWxHVy9FdmZBSDZ5VEhaUzJM?=
 =?utf-8?B?Z2tlN1U2L295Nkk1bUpxcENiYVlHV0hlQ01oL1dGUnFSKzZqaDN2UFA1UXJ0?=
 =?utf-8?B?MHFqdlkrZVM3aENHNkNIeXpML1NmaTVRL3YxU1IzNDZiQ3docytJb2dNNm9W?=
 =?utf-8?B?a1pJbnhYbDJscGlPZ0orUWw3ODlGU3pSZTVlc2VyejFxRSt2SDBFQkpYaHVp?=
 =?utf-8?Q?hIBbLI3Sys1zA8W9OK59BLBvCFxAuA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2JmbWFhdlU3Mk90NHpVWElweWwyWWVTZGZSbUpMZmRBQUN1QU83RzhEZkF0?=
 =?utf-8?B?cStBRm5TS211RDM2UWtQWFhoLzVHZFA4ZlJMNFFOd293c2VRTFZtZ3p3RU55?=
 =?utf-8?B?VjNaQTBqanl5YWZVcHFNSG5PcVhCUHF5YUR2WmtKcnI4cjRwbkNJMkQxOHVq?=
 =?utf-8?B?aWlUeUVkb1d6V1dqb0x5RlFpbkh5dC9GR2J5aHJJWVQyWnhJZEk5RzQyZ2lP?=
 =?utf-8?B?bzdoVXpVTFNwRm56R0lHS2ZEeVpCaThEcHREbTZwSmJBOHFhQ3JvWFF6NTBV?=
 =?utf-8?B?ZXNJWlJndm5mSVVteXJOVjJrYjc2bkMvT1ZMZVlrS2hKcG43Z2d5MURoWm1B?=
 =?utf-8?B?ZHJzUHNrRFBJWk5uMCt4TUE2MTJ0VmhqVUZzMHFRY3h3SGVtYm5nSlpwU201?=
 =?utf-8?B?ZHRTc1hCcC9WckQrR1l6SFl1Nm0veHBYOHF2RlVFZmpXcDR3OEEwSlgwdlhw?=
 =?utf-8?B?b3hhaHZUZWdLMjBTbktlRm45QmtiTnRULzJBR2hvTGd6SDhZT3VwRkNqQXRQ?=
 =?utf-8?B?SlJXckt2Wm9YL2FkMlNHNzA3SXIybE1OWHVHYjRxTTl5RWlCd1lZRnB3RldQ?=
 =?utf-8?B?VkdBM1hRMnhicnFGSmlLSThGUTU4allBWHExWDVIQXNiS0x6MktIT0xKTnJB?=
 =?utf-8?B?MFIzT2o5Z3JmbnJYRGlHenUrVFhScE14anNHbnJNSk1qci85ZXh6RXkzdCth?=
 =?utf-8?B?a1ZUa0I0QWREZEhkcXBqcTA5NWYyeSszVjVEWFp3Uk5LZUZyeUVzaFlKWko3?=
 =?utf-8?B?cWdVNS9yUE9JNnVmL3pmeWFva2VEV2U2WkM0cXhlbjltRkpsR2VtbGR6VXZu?=
 =?utf-8?B?anFHYzUvV2NIZFdoZnZ4NEdVVENGWGNyeUt6Q1NaQmJzUWRMSC9ncVV6MVdP?=
 =?utf-8?B?R0ZKMFBXNjBtY3cyVnVKYlJyK3JXV1F2ZEt1cDdQQW9IRFV3V0hUUlJoTWxa?=
 =?utf-8?B?SVBWOEw3TS9saFNlclNJbUthdmR1UThsZWo1NERFMFArSGlKL3BzMlBOTm14?=
 =?utf-8?B?U3dQWnlDcFFHRDdPWEs2blBoVHBvUndmMnFVWThRbjFlYmRtemxKd1N1M3hx?=
 =?utf-8?B?TUplQkoxaC81WEhsZmc5UjJ1V2t2L1JxR1lEQ3cwaUV1ZTMxeURyN2VoMGZU?=
 =?utf-8?B?UkRmSDB5ZDdORjZDejYveDZuRVhtUHhkcTJxcXczVkVpWUV1OGlmR09tbEpW?=
 =?utf-8?B?c1h1dmJ6RmkyeTdsd0k2NGZxU0FnTWk0SlkzMit1Nk1OWWJoMlRsZ0JRVVN5?=
 =?utf-8?B?ay9UMTVId3IvbFBtQnVldUEwSHZsN1ptQjQzRmh4L3lhM21ER2wwQkYzVGZh?=
 =?utf-8?B?YlMvL21ZQTFqU3oreUFBOEZyTlRuR0JNVHlrbkt3cytrNS9MWnJ6N1oyR29x?=
 =?utf-8?B?U3ZVbGoycm02K0FaQTlaMk9KOUZzUnllcXd1TG5xcTFtOEVXZmRRSlNpZlhR?=
 =?utf-8?B?MjQ1dDJ3TXF0b0pvTDk2QzZrUlloL2JxdDZjWlRYZWZ6Y0RtNUxMeUt0Y05p?=
 =?utf-8?B?cGdycDJWMFlxOVZzVjNTUnFlK2oycDZjbUZYTDZjMk94a1l2RU5lZVNUdFBi?=
 =?utf-8?B?OFhKUEZUdTZKR3ZUZHlUd0V2MzJkbzV3VnBaM2hONzB3N0lyb2ZtRXhzVUIw?=
 =?utf-8?B?NDY3Z2tjSEJSeHl3ZERweVpjdHlpQUUxY2lXNEdncUFaekxiMXV3ZndwbmIx?=
 =?utf-8?B?blpwL2p3RHVmbnhJMmZCTklCV08xcGxWTzFMTllPNS85bWFMMlNFOVFrTTVX?=
 =?utf-8?B?dU5Lc3RmcXIraXZCdHRJbFdYb01CMVNvR0QrcUp2NGNDeXg0TzVLZUtKSXlC?=
 =?utf-8?B?NVZKK2ZrL2hvTTZmZTMraUt1SDNwMXlHWHhsZUo4Q1Vwb2N1YjRSUG1iWGNX?=
 =?utf-8?B?WFZuRllkRlFxU3VraDZGdUNkTldJWW1zWU1JTmxvN1lGOVVlc3FOdWVRZUtL?=
 =?utf-8?B?UHNvaHdWYzNVLzQ0MTc5ZFUzam5aWjU3RzBYYURERnA5bXZqUmdZUVZCazhX?=
 =?utf-8?B?djQwbkt6RDV6ZHNPK2t3R2RRenk0S09Xa0pjTm1uM1hqYmRFVEVlZmIzSWhS?=
 =?utf-8?B?YUFsTkl2TFIwQjdsaVEyck9ZZHNRa0RlQzZIZWc3VlJrRHllMnBhWWZsODVQ?=
 =?utf-8?B?QW42VjlxRzN5elRjYmZlR0FjVVJqdjZ1SWljWVdITU90VmJPOElUOFpycitn?=
 =?utf-8?B?R2c9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa36052-960a-44ee-c86f-08dd92b981e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 07:32:40.1924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1EpKzCJCwdefHZXLteuEmnNDVinpcvJaB4cm3wO8ke8OKM4j7Ns9k0w5OdF1V9vScXuLV4+kkbCM3cq0gFmbYBKwaFsHU7QvVdo992TJZ7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7162
X-OriginatorOrg: intel.com

PiA+ID4+PiArc3RhdGljIGJvb2wgc2d4X2hhc19ldXBkYXRlc3ZuOw0KPiA+ID4+DQo+ID4gPj4g
V2UgaGF2ZSBDUFVJRCAiY2FjaGVzIiBvZiBzb3J0cy4gV2h5IG9wZW4gY29kZSB0aGlzPw0KPiA+
ID4NCj4gPiA+IFlvdSBtZWFuIFg4Nl9GRUFUVVJFXyo/DQo+ID4NCj4gPiBZZXMuDQo+ID4NCj4g
PiA+IFNHWCBDUFVJRCBpcyBvbmx5IGRlZmluZWQgaW4gU0dYIGNvZGUgY3VycmVudGx5IChidHcs
IEkgYW0gbm90IHN1cmUNCj4gPiA+IHdoeSB0aGV5IGFyZSBtYWRlIHNwZWNpYWwpIHNvIGl0IGRv
ZXNu4oCZdCBzdXBwb3J0IHRoaXMuDQo+ID4NCj4gPiBJdCdzIG9ubHkgdXNlZCBpbiBTR1ggY29k
ZSBhbmQgZWFjaCBzdWJsZWFmIGlzIG9ubHkgdXNlZCBvbmNlLCBhdCBpbml0DQo+ID4gdGltZS4g
VGhlcmUncyByZWFsbHkgbm8gcmVhc29uIHRvIGFkZCBhbnkgY2FjaGluZyBvZiBhbnkgcGFydHMg
b2YgaXQgZm9yDQo+ID4gYSBzaW5nbGUgaW5pdC10aW1lIHVzZS4NCj4gPg0KPiA+ID4gSXMgdGhp
cyBhIHBhc3QgZGVjaXNpb24gdGhhdCB5b3Ugd2FudCB0byBjaGFuZ2U/DQo+ID4NCj4gPiAqVGhp
cyogcGF0Y2ggY2hhbmdlcyB0aGluZ3MuIEl0IG1vdmVzIHRoZSBvbmUgdXNlciBmcm9tIGEgc2lu
Z2xlDQo+ID4gaW5pdC10aW1lIHVzZSB0byBhIHJ1bnRpbWUgdXNlci4gSXQgYWRkcyBhIGdsb2Jh
bCB2YXJpYWJsZS4gSXQncyBub3QNCj4gPiBhYm91dCAqbWUqIHdhbnRpbmcgY2hhbmdlLiBJdCdz
IGFib3V0IHRoaXMgcGF0Y2ggY2hhbmdpbmcgdGhlIHN0YXR1cyBxdW8uDQo+ID4NCj4gPiBJIGRv
bid0IHJlYWxseSBjYXJlIGFib3V0IHRoZSAjZGVmaW5lLiBUaGF0J3Mgbm90IHRoZSBxdWVzdGlv
bi4gVGhlDQo+ID4gcXVlc3Rpb24gaXMgd2hldGhlciB3ZSB3YW50IHRoZSBhIHNjYXR0ZXJlZCBY
ODZfRkVBVFVSRSBiaXQgZm9yDQo+ID4gJ3NneF9oYXNfZXVwZGF0ZXN2bicgb3Igbm90Lg0KPiAN
Cj4gSSBkb24ndCBoYXZlIGEgc3Ryb25nIG9waW5pb24gYWJvdXQgdGhpcy4NCj4gV2hhdCBpcyB5
b3VyIHN1Z2dlc3Rpb24gaGVyZT8NCj4gDQo+ID4NCj4gPiA+Pj4gK3N0YXRpYyBhdG9taWNfdCBz
Z3hfdXNhZ2VfY291bnQ7DQo+ID4gPj4NCj4gPiA+PiBJcyAzMiBiaXRzIGVub3VnaCBmb3Igc2d4
X3VzYWdlX2NvdW50PyBXaGF0IGdvZXMgYm9vbSB3aGVuIGl0DQo+ID4gb3ZlcmZsb3dzPw0KPiA+
ID4NCj4gPiA+IEkgY2FuIGluY3JlYXNlIHRoZSB2YWx1ZSBlYXNpbHksIGJ1dCBldmVuIHdpdGgg
Y3VycmVudCBudW1iZXIgd2UgYXJlDQo+IHRhbGtpbmcNCj4gPiA+IGFib3V0IDJeMzIgZW5jbGF2
ZXMsIGkgZG9udCB0aGluayB0aGlzIGlzIHJlYWxpc3RpYyB0byBoYXBwZW4gaW4gcHJhY3RpY2Uu
DQo+ID4NCj4gPiBJIGRvbid0IG1lYW4gdG8gYmUgcGVkYW50aWMsIGJ1dCBpcyBpdCAyXjMyPyBJ
IHRob3VnaHQgd2UgaGFkIHNpZ25lZA0KPiA+IGludHMgdW5kZXJuZWF0aCBhdG9taWNfdCBhbmQg
d2UgYWxsb3cgbmVnYXRpdmUgYXRvbWljX3QgdmFsdWVzLiBBcmUgeW91DQo+ID4gc3VnZ2VzdGlu
ZyB0aGF0IHNpbmNlIHdlJ3JlIGp1c3QgdXNpbmcgYSBjb3VudGVyIHRoYXQgdGhlIG92ZXJmbG93
cyBpbnRvDQo+ID4gdGhlIG5lZ2F0aXZlIHNwYWNlIGFyZSBPSyBhbmQgaXQgZG9lc24ndCBtYXR0
ZXIgdW50aWwgaXQgd3JhcHMgYWxsIHRoZQ0KPiA+IHdheSBiYWNrIGFyb3VuZCB0byAwPw0KPiAN
Cj4gWWVzLCB5b3Ugd291bGQgdGhpbmsgdGhhdCB3cmFwcGluZyB0byBuZWdhdGl2ZSBpcyBvayBp
biB0aGlzIGNhc2UgYXMgc29vbiBhcw0KPiBkb250IGVuZCB1cCBoaXR0aW5nIDAuIEJ1dCB3aGVu
IGl0IGRvZXMgaGFwcGVuLCB3ZSB3aWxsIHRoaW5rIHRoYXQgRVBDIGlzDQo+IGVtcHR5DQo+IGFu
ZCBhdHRlbXB0IHRvIGV4ZWN1dGUgRVVQREFURVNWTi4gSW4gdGhpcyBjYXNlLCBldXBkYXRldnNu
IGZhaWxzIHdpdGgNCj4gU0dYX0VQQ19OT1RfUkVBRFkgb3IgU0dYX0xPQ0tGQUlMIGVycm9ycyBk
ZXBlbmRpbmcgb24gdGhlIHN0YXRlDQo+IG9mIHRoZSBzeXN0ZW0sIHNlZSB0aGUgbWljcm9jb2Rl
IGZsb3c6DQo+IA0KPiBJRiAoT3RoZXIgaW5zdHJ1Y3Rpb24gaXMgYWNjZXNzaW5nIEVQQykgVEhF
Tg0KPiAgUkZMQUdTLlpGIDo9IDENCj4gIFJBWCA6PSBTR1hfTE9DS0ZBSUw7DQo+ICBHT1RPIEVS
Uk9SX0VYSVQ7DQo+IEZJDQo+ICgqIFZlcmlmeSBFUEMgaXMgcmVhZHkgKikNCj4gSUYgKHRoZSBF
UEMgY29udGFpbnMgYW55IHZhbGlkIHBhZ2VzKSBUSEVODQo+ICBSRkxBR1MuWkYgOj0gMTsNCj4g
IFJBWCA6PSBTR1hfRVBDX05PVF9SRUFEWTsNCj4gIEdPVE8gRVJST1JfRVhJVDsNCj4gRkkNCj4g
DQo+IFRoaXMgaXMgb2sgb24gaXRzIG93biwgYnV0IGluIHRoZSBjYXNlIGFueSAqb3RoZXIqIEVO
Q0xTDQo+IGluc3RydWN0aW9uIGlzIGV4ZWN1dGluZyBpbiBwYXJhbGxlbCBkdXJpbmcgdGhpcywg
aXQgbWlnaHQgI0dQLA0KPiB3aGljaCBpcyBnb2luZyB0byBiZSB1bmV4cGVjdGVkIGJlaGF2aW91
ciBmb3IgbGVnYWN5IFNXDQo+IGFuZCBzbXRoIHdlIHdvdWxkIGxpa2UgdG8gcHJldmVudC4gU28s
IEkgd291bGQgc3RhdGUgdGhhdA0KPiB0aGlzIGNvdW50ZXIgbXVzdCBiZSBkZXNpZ25lZCBhZ2Fp
bnN0IHBvc3NpYmxlIG92ZXJmbG93cw0KPiBiZWNhdXNlIG9mIHRoaXMuDQo+IA0KPiA+DQo+ID4g
QXNzdW1pbmcgdGhhdCB5b3UgYWN0dWFsbHkgbWVhbiAyXjMyLi4uIEl0IGlzIGl0IGFib3V0IDJe
MzIgZW5jbGF2ZXM/IE9yDQo+ID4gMl4zMiAqb3BlbnMqPyBUaG9zZSBhcmUgdmVyeSwgdmVyeSBk
aWZmZXJlbnQgdGhpbmdzLg0KPiANCj4gV2Ugd2lsbCBpbmNyZW1lbnQgY291bnRlciBvbiBldmVy
eSBvcGVuLCBzbyAyXjMyIG9wZW5zIGF0IHRoZSBzYW1lIHRpbWUsDQo+IGJlY2F1c2UgZWFjaCBy
ZWxlYXNlIGRyb3BzIGEgY291bnRlci4NCj4gDQo+ID4NCj4gPiBBbHNvLCB0aGlzIGlzIGtpbmRh
IHRoZSBzZWNvbmQgcXVlc3Rpb24gdGhhdCBJIGFza2VkIHRoYXQgaGFzbid0IHJlYWxseQ0KPiA+
IGJlZW4gYW5zd2VyZWQgZGlyZWN0bHkuIEkgcmVhbGx5IGFza2VkIGl0IGZvciBhIGdvb2QgcmVh
c29uLCBhbmQgSSdkDQo+ID4gcmVhbGx5IHByZWZlciB0aGF0IGl0IGJlIGFuc3dlcmVkLCBldmVu
IGlmIHlvdSBkaXNhZ3JlZSB3aXRoIHRoZSBwcmVtaXNlLg0KPiA+DQo+ID4gSSByZWFsbHkgd2Fu
dCB0byBrbm93IHdoYXQgZ29lcyBib29tIHdoZW4gaXQgb3ZlcmZsb3dzLCBzbyBJJ2xsIGdvIGlu
dG8NCj4gPiBkZXRhaWwgd2h5IGl0IG1hdHRlcnMuDQo+ID4NCj4gPiBJZiBpdCdzIGp1c3QgdGhh
dCBhbiBleHRyYSBFVVBEQVRFU1ZOIGdldHMgcnVuIGFuZCBzb21lIHJhbmRvbSBTR1ggdXNlcg0K
PiA+IG1pZ2h0IHNlZSBhIHJhbmRvbSAjR1AsIHRoYXQncyBub3Qgc28gYmFkLiBCdXQgaWYgaXQn
cyBrZXJuZWwgY3Jhc2ggb3INCj4gPiB1c2UtYWZ0ZXItZnJlZSwgdGhhdCBfaXNfIGJhZC4NCj4g
DQo+IFdlbGwsIEkgd291bGQgc3RpbGwgc2F5IHRoYXQgYSByYW5kb20gbGVnYWN5IFNHWCB1c2Vy
IGdldHRpbmcgYSAjR1AgaXMgbm90IGENCj4gZ29vZA0KPiBiZWhhdmlvdXIgYWxzbywgYnV0IHll
cywgdGhpcyBpcyB0aGUgd29yc3QgY2FzZS4NCj4gDQo+ID4NCj4gPiBJcyA0IGJ5dGVzIChtYXli
ZSBldmVuIDAgd2l0aCB0aGUgYWxpZ25tZW50IG9mIG90aGVyIHRoaW5ncyBpbiBwcmFjdGljZSkN
Cj4gPiB3b3J0aCBpdCB0byB0YWtlIHRoZSBwcm9ibGVtIGZyb20gIm5vdCByZWFsaXN0aWMiIHRv
ICJ1dHRlcmx5ICBpbXBvc3NpYmxlIi4NCj4gPg0KPiA+IHNpemVvZihzdHJ1Y3QgZmlsZSkgPT0g
MjQwLCBzbyBJIGd1ZXNzIGl0IHdvdWxkIHRha2UgYWxtb3N0IDFUQiBvZg0KPiA+ICdzdHJ1Y3Qg
ZmlsZScgdG8gb3ZlcmZsb3cgdGhlIGNvdW50ZXIsIHBsdXMgdGhlIG92ZXJoZWFkIG9mIDJeMzIg
J3N0cnVjdA0KPiA+IHNneF9lbmNsJ3MuIEknZCBjYWxsIHRoYXQgInN0dXBpZCIgYnV0IG5vdCBp
bXBvc3NpYmxlIG9uIGEgYml0IG1vZGVybg0KPiA+IG1hY2hpbmUuDQo+ID4NCj4gPiBCdXQgd2l0
aCBhIGF0b21pYzY0X3QsIHlvdSBsaXRlcmFsbHkgY2FuJ3Qgb3ZlcmZsb3cgaXQgd2l0aCAnc3Ry
dWN0DQo+ID4gZmlsZScgaW4gYSA2NC1iaXQgYWRkcmVzcyBzcGFjZSBiZWNhdXNlIHRoZSBhZGRy
ZXNzIHNwYWNlIGZpbGxzIHVwDQo+ID4gYmVmb3JlIHRoZSBjb3VudGVyIG92ZXJmbG93cy4gSXQn
cyBpbiAidXR0ZXJseSBpbXBvc3NpYmxlIiB0ZXJyaXRvcnkuDQo+IA0KPiBZZXMsIHNvIEkgd2ls
bCBjaGFuZ2UgaXQgdG8gYXRvbWljNjRfdC4NCj4gDQo+ID4NCj4gPiBJJ2xsIGFkbWl0LCBJIHdh
cyBydXNoaW5nIHRocm91Z2ggdGhlIHJldmlldyBhbmQgZGlkbid0IHNwZWxsIGFsbCBvZg0KPiA+
IHRoYXQgb3V0IG15IGZpcnN0IHBhc3MgYXJvdW5kLiBZZWFoLCBpdCdzIGEgbGl0dGxlIGJpdCBv
dmVya2lsbCB0bw0KPiA+IGV4cGxhaW4gdGhpcyBmb3IgdGhlIHR5cGUgb2Ygb25lIHZhcmlhYmxl
LiBCdXQsIEknbSBob3BpbmcgdGhhdCB3aXRoIGFsbA0KPiA+IG9mIHRoYXQgbG9naWMgbGFpZCBv
dXQsIHlvdSB3aWxsIGNvbnNpZGVyIGFuc3dlcmluZyBteSBxdWVzdGlvbiB0aGlzIHRpbWUuDQo+
ID4NCj4gPiBJJ2QgYWxzbyB2ZXJ5IG11Y2ggYXBwcmVjaWF0ZSBpZiB5b3UgY291bGQgZGlyZWN0
bHkgYW5zd2VyIG15IHF1ZXN0aW9ucw0KPiA+IGluIGZ1dHVyZSByZXZpZXdzLCBldmVuIGlmIHRo
ZXkgYXBwZWFyIHNpbGx5LiBJdCdsbCBtYWtlIHRoaXMgYWxsIGdvIGZhc3Rlci4NCj4gDQo+IFll
cywgb2YgY291cnNlLCBJIGFtIHNvcnJ5IG5vdCB0byBhbnN3ZXIgdG8gdGhpcyBwb2ludCBwcm9w
ZXJseSBiZWZvcmUuDQo+IEhvcGVmdWxseSB5b3UgaGF2ZSBhbiBhbnN3ZXIgbm93Lg0KPiANCj4g
Pg0KPiA+IC4uLg0KPiA+ID4+IAlpZiAocmV0ID09IFNHWF9OT19VUERBVEUpDQo+ID4gPj4gCQly
ZXR1cm4gMDsNCj4gPiA+Pg0KPiA+ID4+IAlpZiAocmV0KSB7DQo+ID4gPj4gCQlFTkNMU19XQVJO
KHJldCwgIkVVUERBVEVTVk4iKTsNCj4gPiA+PiAJCXJldHVybiByZXQ7DQo+ID4gPj4gCX0NCj4g
PiA+Pg0KPiA+ID4+IAlwcl9pbmZvKCJTVk4gdXBkYXRlZCBzdWNjZXNzZnVsbHlcbiIpOw0KPiA+
ID4+IAlyZXR1cm4gMDsNCj4gPiA+Pg0KPiA+ID4+IE9oLCBhbmQgZG8gd2UgZXhwZWN0IFNHWF9J
TlNVRkZJQ0lFTlRfRU5UUk9QWSBhbGwgdGhlIHRpbWU/IEkNCj4gdGhvdWdodA0KPiA+IGl0DQo+
ID4gPj4gd2FzIHN1cHBvc2VkIHRvIGJlIGhvcnJpYmx5IHJhcmUuIFNob3VsZG4ndCB3ZSB3YXJu
IG9uIGl0Pw0KPiA+ID4NCj4gPiA+IFRoZSBlbnRyb3B5IGNvbWVzIGZyb20gUkRTRUVEIGluIHRo
aXMgY2FzZSwgbm90IFJEUkFORC4NCj4gPiA+IFRoaXMgaXMgbm90IGEgaG9ycmlibHkgcmFyZSBi
dXQgdmVyeSByZWFsaXN0aWMgZmFpbHVyZS4NCj4gPg0KPiA+IEZhaXIgZW5vdWdoLiBJZiB5b3Ug
d2FudCB0byBrZWVwIGl0IHRoaXMgd2F5LCBjb3VsZCB5b3UgcnVuIGFuDQo+ID4gZXhwZXJpbWVu
dCBhbmQgc2VlIGhvdyByZWFsaXN0aWMgaXQgaXM/IFN1cmVseSwgaWYgaXQncyB2ZXJ5IHJlYWxp
c3RpYywNCj4gPiB5b3Ugc2hvdWxkIGJlIGFibGUgdG8gc2hvdyBpdCBvbiByZWFsIGhhcmR3YXJl
IHF1aXRlIGVhc2lseS4NCj4gPg0KPiA+IFdlIGhhZCBhIGxvb29vb29vb25nIGRpc2N1c3Npb24g
YWJvdXQgdGhpcyBub3Qgc28gbG9uZyBhZ28uIEkgYmVsaWV2ZQ0KPiA+IG9sZGVyIENQVXMgd2Vy
ZSBtdWNoIG1vcmUgbGlrZWx5IHRvIGJlIGFibGUgdG8gb2JzZXJ2ZSBSRFNFRUQgZmFpbHVyZXMu
DQo+ID4gQnV0LCBldmVuIG9uIHRob3NlIENQVXMsIHJlcGVhdGVkIGZhaWx1cmVzIHdlcmUgcHJl
dHR5IGRhcm4gcmFyZS4gTmV3DQo+ID4gQ1BVcyBhcmUgbGVzcyBsaWtlbHkgdG8gb2JzZXJ2ZSBh
IHNpbmdsZSBSRFNFRUQgZmFpbHVyZXMuIFRoZXkgYXJlIHZlcnkNCj4gPiB1bmxpa2VseSB0byBz
ZWUgcmVwZWF0ZWQgZmFpbHVyZXMuDQo+ID4NCj4gPiBTbyByZWFsbHkgd2FudCB0byBrbm93IGlm
IHRoaXMgaXMgbmVlZGVkIGluIF9wcmFjdGljZV8uIFN1cmUsDQo+ID4gdGhlb3JldGljYWxseSwg
dGhlIGFyY2hpdGVjdHVyZSBhbGxvd3MgQ1BVcyB0byBmYWlsIFJEU0VFRCBhbGwgdGhlIHRpbWUu
DQo+ID4gQnV0IGRvIHRoZSBDUFVzIHdpdGggRVVQREFURVNWTiBhbHNvIGhhdmUgUkRTRUVEIGlt
cGxlbWVudGF0aW9ucyB0aGF0DQo+ID4gZmFpbCBlYXNpbHk/DQo+IA0KPiBUaGlzIHdhcyB0aGUg
cmVjZW50IGRpc2N1c3Npb24gSSBhbSBhd2FyZSB3ZSBoYWQgb24gdGhpcyBtYXR0ZXI6DQo+IGh0
dHBzOi8vbGttbC5vcmcvbGttbC8yMDI0LzIvNS8xNTk1DQo+IFRoZSBtZWFzdXJlbWVudHMgd2Vy
ZSBkb25lIGZvciBvbGRlciBwbGF0Zm9ybSAoc2t5bGFrZSksIGJ1dCBJIGFtIG5vdA0KPiBhd2Fy
ZSBvZiBhbnkgYXJjaGl0ZWN0dXJhbCBjaGFuZ2VzIHNpbmNlIHRoYXQgdGltZSB0byBpbXByb3Zl
IHRoaXMuDQoNCkFuZCB0byBtYWtlIGl0IG1vcmUgY29uY3JldGUsIEkgbWFkZSBzb21lIHNpbXBs
ZSB0ZXN0cyBiYXNlZA0Kb24gcHJvZ3JhbSBmb3Igc3RyZXNzIHRlc3RpbmcgcmRyYW5kL3Jkc2Vl
ZCB0aGF0IHdhcyBkaXNjdXNzZWQgaW4gdGhhdA0KdGhyZWF0IGVhcmxpZXI6IGh0dHBzOi8vbGtt
bC5vcmcvbGttbC8yMDI0LzIvNi83NDYgDQpVc2luZyB0aGlzIHN0cmVzcyB0ZXN0aW5nIGFuZCBl
bm91Z2ggdGhyZWFkcywgSSBjYW4gbWFrZSBFVVBEQVRFU1ZOIGZhaWwNCnJlbGlhYmx5IGFuZCBx
dWl0ZSBlYXNpbHkgZXZlbiB3aXRoIDEwIHRpbWUgcmV0cnkgbG9vcCBieSBrZXJuZWwuIFNvLA0K
Z2l2ZW4gdGhpcywgd2hhdCBzaG91bGQgYmUgdGhlIGNvcnJlY3QgYmVoYXZpb3VyIGJlIGhlcmU/
IFdBUk5fT04NCmlzIG5vdCBqdXN0aWZpZWQgaW1vLiBCdXQgc2hvdWxkIHdlIHJldHVybiBhbiBl
cnJvciB0byB1c2Vyc3BhY2UgYW5kDQpibG9jayBvcGVuKCk/IA0KDQpCZXN0IFJlZ2FyZHMsDQpF
bGVuYS4NCg==
