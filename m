Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567B2236430;
	Mon, 14 Jul 2025 07:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752478534; cv=fail; b=KAMDU+4CLwDcKjqyGmP4q3SL9nDtBk8XFni9VAwruy81yrloOKUjqPKE1j1S2A6rv5mox4A/2tGU1wsObkfMo1k8fkJLtyqden4VhOT/S6BhNco1o2YBGlUCIotA4m7QW84Fqq7DxGh6bAs9sBBAvUXhlPVxAHD9GzVDkqPzakc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752478534; c=relaxed/simple;
	bh=5qrUxhI1DCTW2/ADzruOJcuxomq7qznszu/jNyfCtPg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uUYXORJSgmcN/0WgoFseTZNetIqzIM1jAk+2CP1w2ZqJDze5tWr4c3+uo11JeJVi5u94sV9BYvJLdEg3MAU0LwRK5d5WkVuCRVPZRTeAnhEkTWvvUg9x/ZqGWZ85uw7SKuJvOC+Mw6Fi821fuxgbNoBU7Dq0ELxspSjc2ANBmCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P5sCgIoj; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P5sCgIoj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752478534; x=1784014534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5qrUxhI1DCTW2/ADzruOJcuxomq7qznszu/jNyfCtPg=;
  b=P5sCgIojFHAFSFrjtyjUSc+K0+4kv6BvymJIT2ZNePbX+tGBoBaMA22m
   8xkV+KTh9FJXov56VDytDUkrXyJpOWpIgrp5pUVC0t+mlOkGvMM58+Xou
   V4pGmdlqxA19yEv95S6YjmzKStwNkAqxxTsaVXAgghAvgdkX65DWr2dmT
   qmcVGlvEkT5NfmM3jmeBs7+/QttmTVDBcxtcGzPBgRL4XVLJT1ycyH81g
   Hduy6zF/dCLR2OYrJQqkPbLYwneoWeSpqH57JZN7rh1R2f4y3ISn0CLTC
   S6gNjMaBzCwmBf2LdbMgpExBQ8BKOLRgaMaXeLQn83+fi08ecc+nSIyZE
   g==;
X-CSE-ConnectionGUID: MN3+4eo2Sy6OLWvzEVqHZg==
X-CSE-MsgGUID: hncAimzSSuu48HkYCyOfZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54520943"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="54520943"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 00:35:33 -0700
X-CSE-ConnectionGUID: 4VAc1ie6SYKNRFoPY98r+Q==
X-CSE-MsgGUID: qtf4JnmBSOSGU5bX0jAmdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="156287091"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 00:35:31 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 00:35:30 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 14 Jul 2025 00:35:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.64)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 00:35:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYblxrKDx9pIEK0jmiIU2kSA5of32WsSb1oU8iNbfsdsNxv7qp9/gxjqlH5feavWoaUE01Tq9oxgb52l9jKtiHgToARoEL+/IGdCrotY9gFNvCh8/qexe8R484sdo5muBMe3aJyjHsd3/5oUIz71kdofgb8XRcBCOeG54JHtezAC6TOTz0k75vZEgcUfcC4EbzBVp2givzyG9Xnrz2foX2S0o69LnGf7DS/uzP4GO6KZnxaN+jd3sMMvs+jeCKZ3yenhp41IH93G4NLz1IwAtHbrJb48RZvBCxbwskFIe5H2/xkcJJBwTfh2vKAOQvykn5d1/jyiCXUbsGJHuTW2OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qrUxhI1DCTW2/ADzruOJcuxomq7qznszu/jNyfCtPg=;
 b=U/MUAcNLpBrmm2LRnmi3CeNvI4qImHlF0yhNtrode2kHzHlSkkwx4qrZG0+pI3Dv/+YgycYhfehW3+u7bvuZGkAPVuQRe+vTQHi8+JeKgOQdjOAyuEBTQs9Xn1RWfPbO+somuXY8R03CjJXnrRaXEvstjHkD+Y1shbJ2i1xL2Tw4jdFeMNNLFkYOmSKWO0qv99KXXUAoNYFuUESoUuiPAOfrGdXgQHTmQmNNlRVHVHZuFrsXh5jkjdctiu0ozEsMjlPfO5Gl9vXOAJ0962k/hTY7sHUd5qDOseh235j6hlenwLl+zqGm+5U0WgtOB36iFysva9pkIayrm9P5HsRNrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SJ5PPFD56E32CC2.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::859) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Mon, 14 Jul
 2025 07:35:27 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8901.030; Mon, 14 Jul 2025
 07:35:27 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "mingo@kernel.org"
	<mingo@kernel.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "Bondarevska, Nataliia"
	<bondarn@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: RE: [PATCH v7 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Topic: [PATCH v7 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Thread-Index: AQHb8oRLFp1NlY5JpU6hvhqGTVGDebQtNI4AgAQG2uA=
Date: Mon, 14 Jul 2025 07:35:27 +0000
Message-ID: <DM8PR11MB57503EC8DF105A7D7FF02303E754A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250711165212.1354943-1-elena.reshetova@intel.com>
 <20250711165212.1354943-6-elena.reshetova@intel.com>
 <461a33d3-f91a-4dd3-bb97-048670530b25@intel.com>
In-Reply-To: <461a33d3-f91a-4dd3-bb97-048670530b25@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SJ5PPFD56E32CC2:EE_
x-ms-office365-filtering-correlation-id: e175d360-1fd3-4139-62f2-08ddc2a900e3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NHYzN3B2aEYyajhnSVJqRytnWkZiNWF1R3RqaEtmaEl0NWorUm9mSkVON1lP?=
 =?utf-8?B?dys2RWFKU2dsdVQ2YW9IYVB3YW9GSDM1RERxNFNQamF4cVBOTGUvZkF5VXcy?=
 =?utf-8?B?RCsrWGYrUjlrSk9LTnN4QUhMTWJsMEZMaFFOYm9MWU9aNjFBbmxnZ2hWZ2Nz?=
 =?utf-8?B?R2Yza2UrQ2JhNkVZRzdLV1A1WERSWVZENG5iSVY4VU9mUUtJVi9tR3cveG9z?=
 =?utf-8?B?Ym1uRzdnUCtxUXNMSFJxaWl1YmwrbndmY2FoRzM4cCtabTVNR29rT05MK2ZV?=
 =?utf-8?B?Sms2UU5QZEtxaFVwdXlyK0FZTzgxYzNFdE55U3I1cXlHdUV5SXZrdWQvRjU2?=
 =?utf-8?B?SHpsWTBZdzJ5L2lhbjU3ZlJhV1M2OGViYWpibHd1S2YrLys3SjNuVDRzVk9N?=
 =?utf-8?B?akphZkJ0dmlKV1BvNUR6NTBYaXAyaDRqRDJrUUNTbTAyL015eGd0MGJBUkdU?=
 =?utf-8?B?Y3FlK1p3TkJGdEZuSFI5alJHMHlaaU5rUm5jdTFxNk5aTUJqSmZNQXR0N29G?=
 =?utf-8?B?NnpnVnZkb3B0eEloL0ZUaGV6alpvVHdzK3BGZkxtdnp5RmFrdm0wYmU4S3gw?=
 =?utf-8?B?NG1GM1hPenRxOWw0dS92VzRDb3MvaGRrbGR1WTU1L3h6V21EcGxwZWE5YXYv?=
 =?utf-8?B?VDMybXFsOWlPSHQ2VHgzNVJDSTZjR1BNRzZJL0NCRVVnaTZ2a3RDQW1rTWZl?=
 =?utf-8?B?MTRydFc4eGh5TlhlTGpobk1TcDlZOWduUnYwakgrUlVKOGxURG9SMHNlRGw4?=
 =?utf-8?B?ek93V3ZSQSs3MHRZdC8yOHJxMUx1ZUhEMTB3L0FHR0U2NnNiU1h5aDJwTmZM?=
 =?utf-8?B?eWJSc0Z6b0lLZFdHc2dWS2ZUVGhjZVkrRWFYSE85Ym84aDVaT3NUcmtJSFFZ?=
 =?utf-8?B?N21PZ1ZHTGZWMFRmNUl0MHFKWUhQbnhJWW8zZHVFU2VJMkxQTDVYYzdCeHA3?=
 =?utf-8?B?WHVma0xRa0doUXVLYlFhVlVtbWxMNlZqZnlMclFVMW43T0t6QXAwY2FRdFAz?=
 =?utf-8?B?c3dQeks1SUJxeG5EZjhPWWVpOTVvUVZ3YVM5emY5ZjJqcWNmQ3psTW5FOXBq?=
 =?utf-8?B?eFBsbHN5L1g5RmYzSWY3bkh6QVBIcEJoTUU0Z1lzQVpESkswNTNaeHgrM21z?=
 =?utf-8?B?WjhOQloxN3YvbDZaQW51NDU4M3FvNXBOS2xBVW1WUEpEa2dJKzhQOU1zU0JF?=
 =?utf-8?B?WUgyWDBtTytrdjFVcUN6M3RBc0VrWXdLTkhzcldxelloRWZUbWwybUIyUTQv?=
 =?utf-8?B?azQ2SGJUcGp1dithT1F2TDVZR0Rpb0R2R1R4dEsraXlkc21jNG9jQzlCcks3?=
 =?utf-8?B?T29hWi9tSWdIdmtCaS94d0dwTGg3VDRQN1NHVFJiQUs1L3IrK3ZGYTRsejZF?=
 =?utf-8?B?eFlnY1JKdUVKUmhxQk80cWY2K3VXL2tsVTcxaHluanZSOWkvQ0JmUlNJYzk2?=
 =?utf-8?B?QWtVSHR0ZVdKRytsYjk3cHlvSDVHVE1XRVNmRWlvaENMNDFYTlNYbzN5c1gw?=
 =?utf-8?B?Wkxhbkd2SzVrZkZ3aEk2TkVjOTN4UnNnSTRXOFJDb09hKzNuMzdydmtVZEpq?=
 =?utf-8?B?UXo4U3lTSS92Sk1qb2YvZnJpZlBtU295cmFuZXJPc2kvVlNRZ0lKT2J5RFJV?=
 =?utf-8?B?cUZDRElRYVVGem9xcUxLZGNQd2xRZldXdDFCRG9IdzEwaXZvMTR2Z09Cc2RO?=
 =?utf-8?B?TGRIOGVUTkUwZk9KNnFnWk05WXJMZm5nMjY5SS8yTW1tbmVGZ0JjUURPOHVS?=
 =?utf-8?B?a1FWUWtsbHRWaDMrMFBWeXhvZG5lOGJiNm15R1E3eXBheDFjMVkvOVNhVmVD?=
 =?utf-8?B?eUN6bjQrb0NHeDhHODdRdjFJdWsvRXJtQjhhV3l4eXRReGMraFlQcHhRS2FV?=
 =?utf-8?B?N1lVRWdFMEVqOUFxRzdKcS8rMGNZck9RWEJPTnZYc3hyR3JCNVVDTmhLYiti?=
 =?utf-8?B?cyszS01LQzRYa3VvZG91dzQ0ZnFxZDNDUmNQaXlET2ZoeEw2a1BhekZUVERz?=
 =?utf-8?B?NjRMRzFwY1FBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWthcitaRUVtM1dpc3UrSG1EM0VOaHgrMllJQTBGSm84QVZPNTFOMVFvWDhr?=
 =?utf-8?B?bjdxMEZGSDJYUnU0QjVOcm1YOFZMZzZ1Rk5UUG9nbngycE00L1JFTWVsd0kz?=
 =?utf-8?B?QWtzYm80cWU3QmhvazdmWDZoZkFPVkdPQTFNa3Q3dUtXTncrU0RjQkNpTFNt?=
 =?utf-8?B?L1ovcTE3OURTOVhsUVY2L29NVEtSMzhxZjNzcGtBbjRlR21BY2xiUGRPeVBm?=
 =?utf-8?B?ZDk4Q2tpa2lNa043UTNPYTQwSFlLQmVLMXdYOEJKSWtYTzZGWHNiZFJldW12?=
 =?utf-8?B?K0I0T0FaQlVNUGdlLy9ySTBraGZXSXlraHFhbExBNEczZHI0S3FySHpyT2NT?=
 =?utf-8?B?WUFkOFZmdmloOGRiY1JjOVFHRzJKZVFqUHdGa0RNcThJc2tYTU9XaGR2cGpx?=
 =?utf-8?B?QUJvcERpNkx3WXg2Wjhucm5QZ2RiL3ErWndGa1BPdi9iYjFpQVl0QmhvdGZk?=
 =?utf-8?B?OUNjS2JUbXFiRFFxRmxKakg0UnJyWU00bjJqSDdnYUxkMXFJblJGK2txeVNt?=
 =?utf-8?B?enRGSG51N05iN2EwN3JMUkFCSWhOZVdzTWNka01SWHlEVXU5NjQxenl0M1Nw?=
 =?utf-8?B?VW41WVVkRVl4ZHdXUjZ4MTIzQUd5Ui9hRGZSQUhXZGZNZGkvYUJNZHY1cEov?=
 =?utf-8?B?dGNoYmZSNy9zKzhkUmpiL2V5NWNDR1dMQitGWnFYVEl2S3JwYWZNVitCTStT?=
 =?utf-8?B?SkVFbWhmS3gxMit4SHltZXQyZlhHVWV6UGNXVWJMaVBxWmhrNG5ndi9QMlZq?=
 =?utf-8?B?dklFZUlTUGFFeThhNE1ieXVLenJCT1hRMCtOb05HWFhZajBqUEgxOGkwc25U?=
 =?utf-8?B?UHJ2Q0E0RTVqQjVUS1owZmU1d0xadGNJOXN3a1FldlZoQ0ZjVzNhcWpOWXNn?=
 =?utf-8?B?eHU4WVdSS3ZSK2JkMkJka0kwTXdwV3kzZWhBeE9KS3hmb042c0lHTWx1TkxF?=
 =?utf-8?B?T1VTcGNQTVl1ZFF0bUZFSEJMaUNFbElqaEZ0Yks4aGlCYnh3b3BrdXBRampZ?=
 =?utf-8?B?cndDSDlwNTVSMFRVRVBOMFNxZzVaMEtWSmR1QXVBZjQ0OTVXZzZGc2d1M1gv?=
 =?utf-8?B?U2pQVVZvYW1iUmliVDVhejJQU2Q5RnkwTFVjdWlORUp1dllqVG5FRE1nYjY4?=
 =?utf-8?B?Rm0wNTlPZWtuRlhPenJUeTlmODdoTGFmNnV2MUdXU1JDRnd0aDVja0poS2tE?=
 =?utf-8?B?MDhWT0ROOUorNkpqTjA2MVdkdHpobVJZSVhqUW1yNDZUZ3VoRmdMK2YwbVQz?=
 =?utf-8?B?YW9MTzNxOFlacEVJMVg5N1plK1FUd3MweW5zenFhYTRidDl4RnI4K1JFZjdL?=
 =?utf-8?B?b1RaQ1l2RjVSbTRJQjhHZTBLTVBKWGZrL0IvcWZUMkJzUGx4d2RYczNGUEZZ?=
 =?utf-8?B?d1JzWVVhME9iTzZZTko4di91Kzh1bUc1Ui9UdFhhWkdTaU5aTDdNeWFkaG8x?=
 =?utf-8?B?OERsZFo3NVBPTEgvaFlwR3g1anE2RHJ6UGY0VkVndTNSZ2JYRktjYnpKNHYx?=
 =?utf-8?B?SnZEcUVkbWYvczRWUzZ5djNGRGlIaVpLaUxTWU1GeHM2bE9PRDRKdEcybDd1?=
 =?utf-8?B?NVgwOHRleEFSaWlJaUJpV0wzR1h4aWxaU09Fc3NPSHpJSXdTSTJ6TXNYbDgx?=
 =?utf-8?B?MThOQjJ5OS85RFVGWEFDRXE4NmprUTZXcDVFNGc5ZmxPTEFoWTB1ZDJJTnc1?=
 =?utf-8?B?aTNXcm9oRFMrekhDSkUxdGZ4Vmlic0h3aFFjZ1pVeU9IWmhGSUF5dU1YclV6?=
 =?utf-8?B?MjdNRCs0dXZ6UTBxVlllelgwNUNRdW9RVmozdjBWM1lhbVdBN3JxUXdMT3Z2?=
 =?utf-8?B?djFkd2FNRmc1U3BpNzNsbGFhYndxb0lkMTlZaHJyNi9uMFcvSXlrdkxaWGpV?=
 =?utf-8?B?ZEpMb2J4aDdFclRQMFZJMEpkVGtVR21uMDBBTkFLd0NzaHhTVWE2dXB3clpn?=
 =?utf-8?B?SjdlYmFIMU91R0NvZkNpSFFXenBTS2czd3QxRm1uZkxTaUora1NJVEQ5QmU3?=
 =?utf-8?B?dkRLenRBbks1bFAzdE51aHJFazJMcHZRVm5RVFZobTBxZG01SEhpUE5LNXJs?=
 =?utf-8?B?bnBLeTB5Zms5MjZJbnNJT0ZQVlRUR1pJRitLVmliS2N5UmZTbzc4MHUvZUlE?=
 =?utf-8?B?KzhmUkpZV0g0SHo4bXpoOG9USUhkWTErSWxnYld6TmpoK0NGZ1l1N3ZnSHps?=
 =?utf-8?B?ZGc9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e175d360-1fd3-4139-62f2-08ddc2a900e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2025 07:35:27.6461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zinoa17SFM2bD/qcpWaLHEUIhUSG9pqjBHsdU5p6nX0piLMYt8hE2BUQyx7Hit74Di6oIJ34DH4KNYuJ6jTPv52qcO8L4XPu0WtDIUKl0LI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD56E32CC2
X-OriginatorOrg: intel.com

PiBPbiA3LzExLzI1IDA5OjUwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6DQo+ID4gPT0gQmFja2dy
b3VuZCA9PQ0KPiA+DQo+ID4gRU5DTFNbRVVQREFURVNWTl0gaXMgYSBuZXcgU0dYIGluc3RydWN0
aW9uIFsxXSB3aGljaCBhbGxvd3MgZW5jbGF2ZQ0KPiA+IGF0dGVzdGF0aW9uIHRvIGluY2x1ZGUg
aW5mb3JtYXRpb24gYWJvdXQgdXBkYXRlZCBtaWNyb2NvZGUgU1ZOIHdpdGhvdXQgYQ0KPiA+IHJl
Ym9vdC4gQmVmb3JlIGFuIEVVUERBVEVTVk4gb3BlcmF0aW9uIGNhbiBiZSBzdWNjZXNzZnVsLCBh
bGwgU0dYIG1lbW9yeQ0KPiA+IChha2EuIEVQQykgbXVzdCBiZSBtYXJrZWQgYXMg4oCcdW51c2Vk
4oCdIGluIHRoZSBTR1ggaGFyZHdhcmUgbWV0YWRhdGENCj4gPiAoYWthLkVQQ00pLiBUaGlzIHJl
cXVpcmVtZW50IGVuc3VyZXMgdGhhdCBubyBjb21wcm9taXNlZCBlbmNsYXZlIGNhbg0KPiA+IHN1
cnZpdmUgdGhlIEVVUERBVEVTVk4gcHJvY2VkdXJlIGFuZCBwcm92aWRlcyBhbiBvcHBvcnR1bml0
eSB0byBnZW5lcmF0ZQ0KPiA+IG5ldyBjcnlwdG9ncmFwaGljIGFzc2V0cy4NCj4gPg0KPiA+ID09
IFBhdGNoIENvbnRlbnRzID09DQo+ID4NCj4gPiBBdHRlbXB0IHRvIGV4ZWN1dGUgRU5DTFNbRVVQ
REFURVNWTl0gZXZlcnkgdGltZSB0aGUgZmlyc3QgZmlsZSBkZXNjcmlwdG9yDQo+ID4gaXMgb2J0
YWluZWQgdmlhIHNneF8odmVwY18pb3BlbigpLiBJbiB0aGUgbW9zdCBjb21tb24gY2FzZSB0aGUg
bWljcm9jb2RlDQo+ID4gU1ZOIGlzIGFscmVhZHkgdXAtdG8tZGF0ZSwgYW5kIHRoZSBvcGVyYXRp
b24gc3VjY2VlZHMgd2l0aG91dCB1cGRhdGluZyBTVk4uDQo+ID4gSWYgaXQgZmFpbHMgd2l0aCBh
bnkgb3RoZXIgZXJyb3IgY29kZSB0aGFuIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSwgdGhpcw0K
PiA+IGlzIGNvbnNpZGVyZWQgdW5leHBlY3RlZCBhbmQgdGhlICpvcGVuKCkgcmV0dXJucyBhbiBl
cnJvci4gVGhpcyBzaG91bGQgbm90DQo+ID4gaGFwcGVuIGluIHByYWN0aWNlLiBPbiBjb250cmFy
eSwgU0dYX0lOU1VGRklDSUVOVF9FTlRST1BZIG1pZ2h0IGhhcHBlbg0KPiBkdWUNCj4gPiB0byBh
IHByZXNzdXJlIG9uIHRoZSBzeXN0ZW0ncyBEUk5HIChSRFNFRUQpIGFuZCB0aGVyZWZvcmUgdGhl
ICpvcGVuKCkgY2FuDQo+ID4gYmUgc2FmZWx5IHJldHJpZWQgdG8gYWxsb3cgbm9ybWFsIGVuY2xh
dmUgb3BlcmF0aW9uLg0KPiANCj4gVGhlIGVmZm9ydCB0byBhZGQgcGFyYWdyYXBocyB3b3VsZCBi
ZSBhcHByZWNpYXRlZC4NCg0KWW91IG1lYW4gYnJlYWsgdGhpcyBwYXJhZ3JhaCBpbnRvIHR3byBz
dGFydGluZyBmcm9tICJPbiBjb250cmFyeSIgPyANCg0KPiANCj4gPiAgaW50IHNneF9pbmNfdXNh
Z2VfY291bnQodm9pZCkNCj4gPiAgew0KPiA+IC0JYXRvbWljNjRfaW5jKCZzZ3hfdXNhZ2VfY291
bnQpOw0KPiA+IC0JcmV0dXJuIDA7DQo+ID4gKwlpbnQgcmV0Ow0KPiAuLi4NCj4gDQo+IEZvciB3
aGF0IGl0IGRvZXMgc2d4X2luY191c2FnZV9jb3VudCgpIGlzIHNlcmlvdXNseSBoYXJkIHRvIHBh
cnNlIGFuZA0KPiBjb21wbGljYXRlZC4gVGhyZWUgbG9naWNhbCBhdG9taWMgb3BzICphbmQqIGEg
c3BpbmxvY2s/IFdvdWxkbid0IHRoaXMNCj4gc3VmZmljZT8NCj4gDQo+IEp1c3QgbWFrZSAnc2d4
X3VzYWdlX2NvdW50JyBhIG5vcm1hbCBpbnRlZ2VyIGFuZCBhbHdheXMgZ3VhcmQgaXQgd2l0aCBh
DQo+IHRoZSBleGlzdGluZyBsb2NrOg0KPiANCj4gaW50IHNneF9pbmNfdXNhZ2VfY291bnQodm9p
ZCkNCj4gew0KPiAJaW50IHJldDsNCj4gDQo+IAlndWFyZChtdXRleCkoJnNneF9zdm5fbG9jayk7
DQo+IA0KPiAJaWYgKHNneF91c2FnZV9jb3VudCsrID09IDApDQo+IAkJcmV0dXJuIHNneF91cGRh
dGVfc3ZuKCk7DQo+IA0KPiAJcmV0dXJuIDA7DQo+IH0NCj4gDQo+IFllYWgsIGl0IG1ha2VzIHRo
ZSBmYXN0IHBhdGggYSBzcGlubG9jayBpbnN0ZWFkIG9mIGFuIGF0b21pY19pbmMsIGJ1dA0KPiBp
dCdzIHN0aWxsIHRoZSBzYW1lIG51bWJlciBvZiBhdG9taWMgb3BzIGluIHRoZSBlbmQuDQo+IA0K
PiBJc24ndCB0aGF0IGEgYmlsbGlvbiB0aW1lcyBtb3JlIHJlYWRhYmxlPyBJdCBiYXJlbHkgZXZl
biBuZWVkcyBjb21tZW50aW5nLg0KDQpZZXMsIGFncmVlLCBiaWxsaW9uIHRpbWVzIG1vcmUgcmVh
ZGFibGUuIA0KDQo+IA0KPiBXaGF0IGFtIEkgbWlzc2luZz8NCg0KSSB0aGluayB5b3UgcHV0IGl0
OiB0aGlzIHdvdWxkIHJlcXVpcmUgYSBzcGlubG9jayBpbiB0aGUgZmFzdCBwYXRoIGFuZA0KKmlu
IHRoZW9yeSogaWYgd2UgYXJlIHJ1bm5pbmcgbWFueSBtYW55IGNvbmN1cnJlbnQgZW5jbGF2ZXMg
Y2FuIGNyZWF0ZSANCmNvbnRlbnRpb24uIFdoZW5ldmVyIHRoaXMgaXMgYSByZWFsaXN0aWMgKnBy
YWN0aWNhbCBkZXBsb3ltZW50IHByb2JsZW0qDQpJIGRvbid0IGtub3cuIE9uIHRoZSBvdGhlciBo
YW5kLCBzaW5jZSB3ZSBzd2l0Y2hlZCBwZXIgU2VhbidzIHN1Z2dlc3Rpb24NCnRvIHRha2luZyBh
IGxvY2sgcGVyIHNneF9vcGVuKCkgdnMuIHBlciBlYWNoIEVQQyBwYWdlIG1hbmlwdWxhdGlvbiwg
dGhlDQpjb250ZW50aW9uIGlzIG9ubHkgb24gZW5jbGF2ZSBjcmVhdGlvbiwgc28gdGhpcyB3b3Vs
ZCByZXF1aXJlIG1hbnkNCmNvbmN1cnJlbnQgZW5jbGF2ZXMgYmVpbmcgY29uc3RhbnRseSBjcmVh
dGVkLCB3aGljaCBldmVuIGZ1cnRoZXIgbGltaXRzDQphIHByb2JsZW0gdG8gYSBwYXJ0aWN1bGFy
IGRlcGxveW1lbnQuIERvIHdlIGhhdmUgc3VjaCBkZXBsb3ltZW50cw0Kd2hlcmUgcGVvcGxlIGNv
bnN0YW50bHkgY3JlYXRlIGFuZCBkZXN0cm95IGJpZyBudW1iZXIgb2YgZW5jbGF2ZXM/DQpNYXli
ZSBpbnN0ZWFkIG9mIHRyeWluZyB0byBmaW5kIHRoaXMgb3V0IHdlIGdvIHdpdGggeW91ciBzdWdn
ZXN0aW9uLA0KYW5kIG9ubHkgaWYgdGhlcmUgaXMgYSBwcmFjdGljYWwgcHJvYmxlbSByZXBvcnRl
ZCwgZ28gYmFjayB0byBhdG9taWMgdmVyc2lvbj8gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
