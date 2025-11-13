Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B802576026;
	Thu, 13 Nov 2025 19:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763063836; cv=fail; b=TIBnOx8bMFvO9E+idZinG12xg2ykm8NyXM8ECdSyubcUrxshsLarCM5YAlpHx/zIzyRs1v+HgHD5f0uuaNI9bdpd72+k3613CwRB7r+Nr6FG1noZOiVVAVxZZJo60prpugpLS2lcrtRDe0IKlcbp/Buk54TFJGN71Gr0AgHQuzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763063836; c=relaxed/simple;
	bh=TUj7SjRkpYf4f8IXZ+JL4qx9ERecFzLxutklCaBWZWk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ygze52U6uAPsIc+0z7W/0QcEGIUIqoERcoD+UU0i31gni2VTK2mCBL160M44Q61zyZAZiCwOW0yJmFh2RkKRFQJyFmorr/+IqpatG1rvmDckVHLHjICxQWJ7tVoISMM7d7UT9lrPHOuW22ts7rXLsiJIxmenqi5QDDR5+OewjBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dr6XiL5U; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dr6XiL5U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763063834; x=1794599834;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TUj7SjRkpYf4f8IXZ+JL4qx9ERecFzLxutklCaBWZWk=;
  b=dr6XiL5UZqcE3D/6KyaF7rBbKdivfgqBYboL2xls2ZqDyHu6cNcSHnuC
   ob5q+Ml+c93BKjcZqIOeRXx3zSjzxYyTbXgLWJu0y2HwDS2YxLBjf1FbV
   W8AnyMG/lOYb8LmpbZqCmSk7Gn0YD7XJS4UGf70EfBsvsZRdxZGeQtEBw
   IrYogyiCKSaT+FCbrgarnAn9BvZxe8dEjTI/h22VWUv+ASiIRMyb4dQb3
   eHG9SbtNpdzQQiTfQk2nLKVeU2/btEGLv2NVk4TPRmjO0PDcVaJ4x21PG
   MKhOEUAUJ9UbKRqns0ZFGXy4oQlD2o3NZTsSgmXyjGCu9rDVSewLau+uv
   g==;
X-CSE-ConnectionGUID: rs1bmmJ0RF+KhmuBClWLwA==
X-CSE-MsgGUID: 6hICL1gkTdqKVAwbvZ/Auw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="76617085"
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="76617085"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 11:57:14 -0800
X-CSE-ConnectionGUID: imcwQ6E6QeqSoRAl/NsqBw==
X-CSE-MsgGUID: FWrYEd2hQq2De1/NnxJnAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="212986746"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 11:57:12 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 11:57:12 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 11:57:12 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.13) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 11:57:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBxx+pUVBRDJ7LYj45ili+0VxP6gwNfZMns+Coi3PjmTYaysrSikaHXu4nav+MvsHNrMgozSNBdG+Ue+OerUrnMQSly8lXKHJUuMlk0kBfl7qCLkf+YZbqVvWpMdH6osgL897Mqcx605r1PyIIM/P5I4HBbONYzPp1+x2Ffsx+l/+iG0+XpzYChSQqparEfjzxxfQZr8P8Mc/DlvG5ZuOg/qezOnev35TK2OPgLvhh07W0y8lTdhUfwGPK8Og3X0YWHHalqVSx3pFEeTzReNCBN/f7QlTJTcJwyy+5+pST/sBhKWJz6Il+iaeoiIwzrbYPFgKcirreGljFB1dzXnUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7cCz7yXXCc6/uYFTrKlBjKHNlxT/5O6hS/IINtLdsQ=;
 b=hS0VjoHGXXv+nQo98aXqw64XfHI5bW6LO7Iz0+JdNzGqPixgl/4a79cqwuvgQ6pDS7s+lyHsudpx02bXPiMn3lDcq8XEel4HgDUZMfWfKkU9Ll/zjBfK8GKbh8xm6BT3qUCm3IQU/PWtRSEdUHjPI9Dnf0zmeLiNiyeOyw/0nAOS86v3LLcrbxXSsdiFa0Bhsucxp236wdPBuEM67jtM1T1LokyyNEagOsS/SF1I4CIf4Ds+GA5lYKoRfhvidsZ4kG74UJWqP3wIwnhfnlyK4Rr3jIOpiBDhO5bWIqI+fFOFmbKNawnLty0CXVwelRJmJ4qTbat6HGLMaDeK8qPVzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA1PR11MB6171.namprd11.prod.outlook.com (2603:10b6:208:3e9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 19:57:02 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 19:57:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/5] x86/sgx: Add kernel-doc descriptions for params
 passed to vDSO user handler
Thread-Topic: [PATCH 2/5] x86/sgx: Add kernel-doc descriptions for params
 passed to vDSO user handler
Thread-Index: AQHcU/e0zV2XTh00j0W5Lh1D0RJ2G7Tv2j0AgADc2ACAAE/c4A==
Date: Thu, 13 Nov 2025 19:57:02 +0000
Message-ID: <BL1PR11MB5525861CA0EB9AC16FAF4047F7CDA@BL1PR11MB5525.namprd11.prod.outlook.com>
References: <20251112160708.1343355-1-seanjc@google.com>
 <20251112160708.1343355-3-seanjc@google.com>
 <9adc3a5437cf7d9af99642a0df837bbd0237bb58.camel@intel.com>
 <aRX0iB7gYS_GgGOV@google.com>
In-Reply-To: <aRX0iB7gYS_GgGOV@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA1PR11MB6171:EE_
x-ms-office365-filtering-correlation-id: 7ad48d3c-e4cb-4024-3350-08de22eed048
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?sJvEoKzI5PO6gSBU4BWQ7oZNWhhZucTceO5MCjDX4krfxK7r5PM7MXT3tuI1?=
 =?us-ascii?Q?ELG9kXg/Ei9m21YmeysBMQZFj/UCi8CzJCmBpXXRqufsBMzAFIw4GLRsBTwU?=
 =?us-ascii?Q?pVuJnnrWvUjlagf04S/P8VB/gCnCD4FGIMyFB0Y2MDbBaTv7hI1AGvNVwHny?=
 =?us-ascii?Q?WXKMtOxmMzdIP9+QbldHAgyejipgYBzNWV9UprZpmZSEEmDcr5d8XR7Ump2J?=
 =?us-ascii?Q?s5bPt5ILWvdc1Dly3VRyv05zHkv6CrqNbcjo4GJKHGigUum8qc5rloWfJzcc?=
 =?us-ascii?Q?vKwK5wZdum9TDl2V9217R0deRNyuOBkyC/x7lgzHLygA9DfsQRXCxMmxECmg?=
 =?us-ascii?Q?Z7npKPXY0dk7883XLUiw3pOd4PVA7BhLOjwaa9S8YSlYUOuIHOiJCvis2VEJ?=
 =?us-ascii?Q?UTpyv3kx4ukmMggk3DEbTJeciKaMZk8tJGUSqTY5osUx5Qd3ttoF9HQeZIHE?=
 =?us-ascii?Q?ZOKF9uRpsSKEd4q30qF3hIHNE1H5UpbwkawyrH70HRtDR1hwyxYv4ZZ6KL2x?=
 =?us-ascii?Q?kZXPqMW1DUIidm6BQa05IO71ZeKfntbqMao/NIBM8+snaCrMAVho96dmunq3?=
 =?us-ascii?Q?f5SPTqgXkaIsNpvNovgDeHB3/A/gIt7yp+8g8DP46IdGtkUHecpUWpIMCqBm?=
 =?us-ascii?Q?+fEcJXVq4OagryDdpPa3ZcZoKHYOKyuVcSSBqsI7y6ewcsOWy6deQKdLoLHM?=
 =?us-ascii?Q?zt72IjBiI86tEOWYhsu/UqmbTWwkfKgwUJ7k106p4WCnXtQCtFAXmR+9Nb+u?=
 =?us-ascii?Q?fyt4/x2v5L/N9TQ9y8is5rOOlAu1/pmFTWH7oMpBS2HI/o+XPc/Z/bFPGKZy?=
 =?us-ascii?Q?KmD+eU1H90tD1ETxMQJcC0clWq8tBzqL0fpUl0itL61l/huv/hRv+b36nDrj?=
 =?us-ascii?Q?zHALObdi8ja/Dn0uImzrtUsJKIMeVUWpXDH9jQ+UQCFJc8USD50PvaII5eUt?=
 =?us-ascii?Q?uXNXOVV0/mS3kiFVp5RvUGTplKZVVIq9l0pVDuGlIsedCqnFW34RibgP+Mf+?=
 =?us-ascii?Q?h3Q0OgTunca+9kKDSGVMvjuQLbwyWIKTn51/YE2DWecJ5bJXMvou59StML1I?=
 =?us-ascii?Q?mYCAwQkOOLxYwimX1Uu9WcGnq4s5+P5j7CobpEeWxnRi42e2SrKk1s5ViANe?=
 =?us-ascii?Q?uRDEZLSddG5dgyp9TKQaj+XIZhdPvzXBcd25mWM66coWxJIqbN+/pwrumSAr?=
 =?us-ascii?Q?imsS1ssD/9xw95f/C9XezFa71A5VovwwdJqoxZ1//nOSMjPlnIbnLDDwksfQ?=
 =?us-ascii?Q?GCcJK/TSUpHbQ9BgBazR395YQEAAN0Dxtcpzv4xAoPFWszUFmlWPcBw0tGCO?=
 =?us-ascii?Q?tBQGTTBtUwKbHIhLcKLPz9FMc9Y7vVDZ51mEsZwtNGk/sY1Jf3yu5rfc6/1l?=
 =?us-ascii?Q?VJ+uHamT8DE0PuV0uuMUQif0UCYTcknUeYIPpyNIq6bUlkmiy5VEC03NJZH/?=
 =?us-ascii?Q?WBm1RK6rz32XVesrh5oOvP81OJxbnpL8vTXrsDE8+Ilb4e+xz6GwNxlUwc4T?=
 =?us-ascii?Q?VCA2w/PzQT/TiqEV27l2XHqYhzOP1cW9b3T0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WrUC+wktQnAHdNWXabH4xPrmhy74TB4+ADZJzu4yrD/f3tC6jdWnCbDwWPGj?=
 =?us-ascii?Q?aqB0ESB7YEqaDiiiFGWaq2qlM29vlaqOjOeRP1S4+pMvs+0aZB1xEksmzD0q?=
 =?us-ascii?Q?WB6E20hX02JFhXPQFV3xD1KfPvtvJl5BcS2oVrXk6vaGe0S0SIQBAk64y5HK?=
 =?us-ascii?Q?U1wIqYp8lb8L5Uf/rjzsqa/AkAepBm2N108GXHmaWJ7o60i72mlNy/rPO11f?=
 =?us-ascii?Q?UtVaTvJIK2cH/Qidvv0QYIPS9QrxtSAQ8x4PkStEY5Apjt8lcL8EnMbl+92g?=
 =?us-ascii?Q?2g73TpLD+8M7ptpp6u9JbPQ1ZT3pSMvPTyGl5bGKK5mhO/rJ7jFNRKUhnoAD?=
 =?us-ascii?Q?P89QrY+D2aaJu9AmVumhiUoxWfY5F1eAG9Pqgy6ThNVbhP921MAIjktHfz12?=
 =?us-ascii?Q?EaV56DjqB3K+Ms1rRnzd5pts81h3ARXnDNO/8+aM4z8CPKlUNro2v2vBeq0+?=
 =?us-ascii?Q?QdS33H2Q+UqscidTEAH60Ugx6KY9XfOIzwvn8gWogBzgdN9zECinR3moqVgT?=
 =?us-ascii?Q?RNSOgn8u2eKGDnrnrbFDjG6rYlM9pWrho4XFaSvuQhV+xi5DsoQTX29QAeuO?=
 =?us-ascii?Q?nzITcQvHHYLud9JWGdikgttAUrE1uq/2ec1xLPcY0ahl/yIDy80c8k3zgTBo?=
 =?us-ascii?Q?HFCVoeZxhi9W/LnIMV4tbaWZOseZ3cSwuDrjHxx8i38W538SPB62mQErwR3P?=
 =?us-ascii?Q?bSAhX4r/9tvXDnPuwg4DFwH+FazDGCTOVseWgMRDN44/P/L2CviYZBNA6bT/?=
 =?us-ascii?Q?QOHF0BWXuKJohmmfMxYWi6AtZq6Y5AUcFKc9aUhzJGbjFbzJ1TWIPW1O0Rhg?=
 =?us-ascii?Q?R4IDAoZ5uKcyCgoWCLJwuKmrTg8K3nE5PdZWJ0YJd9sQGUHrKWnQ+pWmW4Lz?=
 =?us-ascii?Q?rEc00EUDoo7T7XSmQJTwaSKkVosjtRBpRy8S7p3reNq39xMRvMJF6pHLLjop?=
 =?us-ascii?Q?D3QGN8X0k0HUJWZDhC+MHsEVERpjWLhF60NmRhKE8yG9i4Dw6HSU9q5wff9m?=
 =?us-ascii?Q?116USxW6WLEgfXHo5NEwcUkslAzttlmuhcyRpkljz5Lr9gxJqfjLoNwc+qja?=
 =?us-ascii?Q?+2Ue8F/cAramhq6sCsv5MMM2dRiL2a5C/yEcVyEogOgitVnH4dW++w9Kv9Vl?=
 =?us-ascii?Q?iO/9w8DL/+c5bp77K7GWfwE5E0U5GbKq/LFgbIgPtlV1v9OB+qQQqQN21HG3?=
 =?us-ascii?Q?vSudYNhdNUoH6BytCUdQk6nDaGkm/DKmUU5NBoOOnWwP7DQhdQ98oWaj5GR7?=
 =?us-ascii?Q?AfBWFoPve/B/HjQ2Sj00gq2D1KFBn9l/XEDJtCU/s4FEaiq+Vi6YqtWavWMJ?=
 =?us-ascii?Q?bEFOrGLvrViobX1kbxzEM7NuiMsBqtrWO1pwaNMgXwmxY/9T7V4DvPfkv1bb?=
 =?us-ascii?Q?Z+ImCeoYldde06jIFdcMNW6EPDiMuVrpgLRRoUFhAh/YmORzrnW/btGD3Vpy?=
 =?us-ascii?Q?5Y+EPncZFqdzO9108pLSk9zEuYFTmex6HZJ8Gj4Z6l8K+Crl5qEohvNXyvjg?=
 =?us-ascii?Q?UAwt7i+sgirQWnuiQU8AUvbkBmNZ+8cLRoa95i/MWtmj4mf4w3pmv8gnpXD2?=
 =?us-ascii?Q?b6rCL02WtU1V5XFaU4VXFo4JuY8NA3KULXiof1ij?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad48d3c-e4cb-4024-3350-08de22eed048
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 19:57:02.4817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: quW3gmUb1cvPzONPRSnpzY7AjzmDtfKwzOmxJy3eXglswcjUaUk1k0HtpE8tZa2cOWilw5D8rfyV9Rs2aG76QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6171
X-OriginatorOrg: intel.com

> > > Call out that except for RSP, the registers are undefined on
> > > asynchronous exits as far as the vDSO ABI is concerned.  E.g. the
> > > vDSO's exception handler clobbers RDX, RDI, and RSI, and the kernel
> > > doesn't guarantee that
> > > R8 or R9 will be zero (the synthetic value loaded by the CPU).
> >
> > Perhaps a nit:
> >
> > I am not that familiar with this part, but AFAICT the kernel always
> > sets RDI/RSI/RDX to exception vector/error code/addr before invoking
> > the user handler, after the vDSO's exception handler clobbers them.
> >
> > Since you are adding description to them, should we somehow call this
> > out in the comment, if I didn't miss anything?
>=20
> I don't think we want to commit to that as ABI for the vDSO interface, wh=
ich is
> why I documented the values as being "undefined".  Maybe were already stu=
ck
> with that ABI, e.g. if some funky userspace is looking at the register pa=
rams
> instead of its run structure, but IMO we should at least discourage relyi=
ng on the
> values.
>=20
> E.g. if the kernel ever changed its exception fixup to use different regi=
sters, then
> RDI/RSI/RDX might not hold the same values.  In hindsight, we probably sh=
ould
> have scrambled those registers after propagating the exception informatio=
n to the
> run structure.

Yeah makes sense to me.  Thanks for explaining.=20

