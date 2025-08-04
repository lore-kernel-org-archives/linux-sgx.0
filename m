Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6A222259D;
	Mon,  4 Aug 2025 07:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754292093; cv=fail; b=KVi5eusEy95QpgJlxKDim6UiiLJLm3/vNBM5+PjJaP/r/BvXBukPp1WUtRYDUM8GefFiVYtse2PQSB0kLkI2e0G2h8ahZ7CCcUeJctkxAYWpXQQzo51nWxGM+Nr2KB4kv1VGHMvhowwyqWlZVrwp9Y1idcPvCULl2WwRp19o6lU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754292093; c=relaxed/simple;
	bh=YCfQRL1AQr/R0rCIQXGbqCUI7HQU0Wq3MpaqAId2CE8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eAuSKXZ2bSRcpZpYJMLxj7HVWo/Tn14iD0ogELq3DcpHk4ABAWG6p9PqnTtmJEwtYZJDIPZjRaptfBy+X5ETDATBMsypk6T8dkW+JyDLgO+KVx1AsIgvcmxgJWqqBIX3jlznMu2sDgdTRHMNNtTHYrH9PeUSMeMwPsZ0TZY3p1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XXa4i4vE; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XXa4i4vE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754292092; x=1785828092;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YCfQRL1AQr/R0rCIQXGbqCUI7HQU0Wq3MpaqAId2CE8=;
  b=XXa4i4vEBqanHnlOtgWpliVosDjNEVmyFzu6cNQVvKVBeSeHi66PTgwU
   bCUYMCgcgoGl4oXZWotC/edx5g2k+dCqbEzIhE9SaG6Dxm5pK5A00skvk
   hWh1Zx0H5xAmaRvZ0KHKr6S+fYTRSmNX13gfGBEti7PWfEShdGnPFTuiq
   4oCJvHdq6B4dlgZ9K5S2rzDJtYt1OzO4qSciC9ENSC2QsoJQpexOGduGd
   PCQTsbi0A/SQ2np7EbW/3Hr6drbX42Npjizqjy82R5ID53Nuy9m6dHVYP
   OlkCQcPdikamgn1zslK1TeXQAlfdh22O72ggp/avPYwIBJ+IlWnDtwnSo
   w==;
X-CSE-ConnectionGUID: WFS4+u6qS3CuTpQMeDOLgw==
X-CSE-MsgGUID: XffBtiqBQdKwtOw1U3ftaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="74002630"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="74002630"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 00:21:31 -0700
X-CSE-ConnectionGUID: 27ivIhFzSWiYA5mnFES8zQ==
X-CSE-MsgGUID: 69gt2h4ATRuYQO0rvvyL7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="169465714"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 00:21:31 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 00:21:31 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 4 Aug 2025 00:21:31 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.50) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 00:21:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPodbDD+oSbDrX5facgA29cc89hGSltiLtZOq5sBr3b6ZpK5QhpmI5X3LfPKQjtxOFVYOiE65TFT3gGWRnF7s18UjxPC0ONyDU+nBIps4Fnj7uM6pq0nKL1nSEy+TY+wKzZUAJYK6On9e8svFxKWC9BP5MWft5pN6r8iyuXcTOJyWRNadnqVmuWsIdSG1DskubuBlfUKiwsVhchoJTUy+yQd8Wbg+aUabZgHZQbEdsbw++O1/QogQc/n5Hqlgb5Lf9IKNS1zTfPcm72dZXSNE3hnHSU3wRC2Mpu7tgvDtQiJx7mSRQzHQoerpwfRMqsXjCKvJZg+uTqwX3BHlrqK6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YCfQRL1AQr/R0rCIQXGbqCUI7HQU0Wq3MpaqAId2CE8=;
 b=ZlycReCfcl5wNUDmEgm2Qvgx4vOiybWOhrp3Hf/FbjNpQbHGVA874dvnM1NOIIsitJ/xGhqCK65sMvxDNONEeq0ZXeH2B6r0vzyrwgFYlQqCLJnF37lstHujr9T2VfxnYNoP6jIERaSPthIhgqupwoZ1yvUIPPzdAhCN6VGPER6eRnCvfN9+QoTTO7W/gK4Y/ZP7n7M/eUoKBbWWPEYYuWVTzmH7uy3yJUdpbkKbYQZ/vXoyhAleJl51mY1EZFcasLEVr1OsT538pZ0Ps47giR24xsOLEFEMkD7awTohF06/DtgYLTTInHA6riKyUO54FZJ1qy0z/pzLr7/rA/Tv+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SJ0PR11MB5070.namprd11.prod.outlook.com (2603:10b6:a03:2d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 07:21:09 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%3]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 07:21:09 +0000
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
	"Bondarevska, Nataliia" <bondarn@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v10 4/6] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Topic: [PATCH v10 4/6] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Thread-Index: AQHcAtc1bBlshQJLFU2DhdSwAc13MbROBP8AgAQVZRA=
Date: Mon, 4 Aug 2025 07:21:09 +0000
Message-ID: <DM8PR11MB5750515E878BAC6199882330E723A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250801112619.1117549-1-elena.reshetova@intel.com>
 <20250801112619.1117549-5-elena.reshetova@intel.com>
 <80006246-d0c5-475d-a8c7-bdb5446d9489@intel.com>
In-Reply-To: <80006246-d0c5-475d-a8c7-bdb5446d9489@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SJ0PR11MB5070:EE_
x-ms-office365-filtering-correlation-id: 1323c291-aec2-4133-e0b1-08ddd3277c0d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MUdndHhSZ2R2NCtzRE4wTWNpL2RBTTIwUkZCbXZsS1BUb2dybWtjNmtCclYx?=
 =?utf-8?B?ajVPb3d4WEMwQ2ZpKzhSOVFoVmFmT09hR1ZHdHB5N1VnNUxoditmYlg1UkJ0?=
 =?utf-8?B?NUhqVGtmSUtObVdVTHA2d0dwb05nL01hNHhHeUhmQ1hPYnJzbHNMME1BOXY1?=
 =?utf-8?B?RkNKdHNCc3J2a05UaEVQemFzYm5vVDViT0tGQXRRMEhFUUlxZ3JhQy84TGlv?=
 =?utf-8?B?YTE3L0grSlNENndNYU1uaTF0SGlkdy9NcGFZMFU4N0tLcFNFbEY2SU9iZWRL?=
 =?utf-8?B?ZWdWRTdmdDlIM2RPbnRQL0ZCejIrTXFCWnNqdGZiOEFVZWRmb2xUaHQ1STJ6?=
 =?utf-8?B?K0ZwellOMWJBZGlhSWI5NnZyOStyckdIY1FralZ6RjZwYlNVQ2VTaml4UTFS?=
 =?utf-8?B?Z2I1UUwwQ2s4eGlRUFZobEJNOEhVM3FmcDlld3FjaytmbSsrdmZ5RnNpS2Vv?=
 =?utf-8?B?ZEtIQkFCaU45WG5KMVdrOUVDc3hWODExb1JXVUZPVnRrUmZnRVpSVzNSZ0pT?=
 =?utf-8?B?cW16bm1tNHVseittbXI0bS81L3pUbFJwTHV3TWFCcjUrVVpsb1BueE1jMjBQ?=
 =?utf-8?B?bHlsN2lMenJUTDU3dlNYbG9nYkxSRjJzMW5mZ2l5VHZhY3BrZE13U0F5VVYx?=
 =?utf-8?B?M3FETCtjMDl0L2diUTBQK2piZVA4M00rSTdINm9WRDk4WnY4bjhBKzM4ek5O?=
 =?utf-8?B?Y3lLT1lhSEVyTTNITGFqZ1FKYkliVzZtQjIrS0tUVEpBNGJzTGJJM2I2eDVG?=
 =?utf-8?B?WER6dDc4RCtUNjdKS3ZrYUl6UDVocDdvaTdiK3hmUmU3YjAyTjc1N3c1MmN6?=
 =?utf-8?B?M3loUGJvcVVOSE5zdktTd05JbFY1T0Q0enNZdUhGYXRCRWkvRVllakhJVzlF?=
 =?utf-8?B?eXJKWlVMbEhISHRSelRlR0VSSUsvc2dBQ2hOMDJtUEZ0VmF3RVhvTGh3RDFB?=
 =?utf-8?B?d0tpUEhlSHJsVS9jREc4c1BUYmhpNHNIU25rTUhBeFN4dVpDcVZSRjkrOUUy?=
 =?utf-8?B?VFNqSmg0TndDazFBeDBhRzd1eWpkZzA2OHFqLzdSTGxBbXoxanpTeElua0V3?=
 =?utf-8?B?SVNhTzRHUkpBeUxtRXhPK3hEMmZRdm1mVmhnbHdRVW45TnA0Y2grbHZHODVJ?=
 =?utf-8?B?MWNUNDNRMHlxYldodC9EWmxFSmdwQy9ZQmhtWmx2MUQ4eGZ0dFBscThwS2Rt?=
 =?utf-8?B?M0kwNU5KeGtYMVVZVWpwbjk5T2FpR1d0aGk3ZXpJVUduMjdpdm9jQWpsRFlX?=
 =?utf-8?B?VDJHMWVaTXJPN3pnR0lOa1JNczkzMXEyOGpydlRzRHY3UFBHUHQ4UGZNZ1I3?=
 =?utf-8?B?dkdjcWlsTUVRbWQwODBSQ1F2NitGTkdMWVNGTnY1QXRORmI0b3RKdnBXankx?=
 =?utf-8?B?S21raVJQYnY4ck5JQzFvQjBNa3ZONW03TlZ2MHRXc0p4aUNsdy9nbkhSSmUz?=
 =?utf-8?B?NVhVcFcvR3lrQjhxWkJHbFFKRElDbytXdVBkZE82RmE1SGMyT2I1NnY4MU1v?=
 =?utf-8?B?a0ZtRy8wYk1RUnQvdnlPbjY5OXltNDZoV05DQUlJbWxvckEvQVBuT3Blck45?=
 =?utf-8?B?bDZldTcxa2tsSXNGVHFDT1Y1QWNHRUhaZWtmdGpHMnpIY2U4TFZCMUpkVmho?=
 =?utf-8?B?OWUvd0VHQ0IwdzlGR3hiZEJDcGJ4WUUrM0ZiR1VjOEpNUzFPdXhNb05tcEs2?=
 =?utf-8?B?Z3E2aWlBc1pEVFp6WE5uOXNxaXhHNXFOK2ZyYWpWMjA1NzM1bWJMaEl1czFI?=
 =?utf-8?B?dDc4dmU2NVJqSXh0VUxLRWgwcnZWbjJQZDMwQ200SVVPN2ZpdFVwb3NRTHhj?=
 =?utf-8?B?bE5qZHVzVUdmNkRlc05ucUZ3RGpzVkNZcE5RSkI0RWFiSEx4SzdRdWxTVVNY?=
 =?utf-8?B?OFBSajRQcGRCR1FhaFNPOUVnbEtxem9qdEJxQ3lUcUlVOHNlUzEzdlgyWVNm?=
 =?utf-8?B?dzhja2NCWHduM2NjYkx4YTlmeVFucTdqUUVhbmpFeTFjN2dqaThHczREL1E1?=
 =?utf-8?Q?kWvqIG6z46/zD6fcYZ9VYwmV6zyyMw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFFDRzNXOWxxNmZYMnZuRE90K2tXZHVBMWFkV1BQSUVHa3FveEFLS2NZN2Ja?=
 =?utf-8?B?VCtVRlpmNHlmbkF2NTIzNW5sa25ZbXhnZmxuNkNmQ29DVFloWWVIMGh3cUdH?=
 =?utf-8?B?QkxUZ3FzZWY3NnNkVTcxNE5pUDg0c1NzNjJPbmJNYTd4a1QyZ1ZTSUM4RWls?=
 =?utf-8?B?dk5ZUC9Yc2lDY1JZNmFNcmNTcXljbGRnVTk3RTlIUG40MUU3VGVGeGZRMGtV?=
 =?utf-8?B?TzNiK2FZSEZEUEpTeGc5TUhDVS9pZzJQaVZxdlJSaXNQRzkvOWlIRncxenM3?=
 =?utf-8?B?TFVkMmhFa0VTTXp3SHRQZUp0NkZSWDR6SGRvUjhpcFhkZDN0ak50eFdxK2Vp?=
 =?utf-8?B?UnI0YXk3NkVBYjk4SUpiaWdqa1NEVzRTMCtsNmU4b1RhbmMvRlJocS9tSlE5?=
 =?utf-8?B?a3JVdWhlb2ZDbDRTT3ZIaklhVDJZRktHOUNBN2VIYUo5bVY1OXZya3dmbzE0?=
 =?utf-8?B?Y1cvNStnQjk2ZGtjMnJPcXRJd25VUjBDRXFYT3g0eTE4a2dwNG43UXNGYUVE?=
 =?utf-8?B?L2IwK2dza3cvSjRVSFFOZU9Kb2MrZkhsSzU3Uk1LZWJEYkNMZHFzWjFobm5G?=
 =?utf-8?B?SEpKNDF0Vmk4dVFmT1J6cTR4dGxUZnJ6WE4yLy9vd2YyNDJXM2p4anEvQ3NE?=
 =?utf-8?B?TGNZMklLdFRCWnkwOE95a3ZrVlRsbHhFSzRSUStaWFp3bzdUbDgzWXArNSs3?=
 =?utf-8?B?MEx4NjJxTlhRendSRkFTYU1PUTFLaHFYZXVuYkZ6Q2NnUmZ2TTJLcVpVWFpF?=
 =?utf-8?B?YUhrcm50M01zQjMyRTBVa2tJRXdtakJ3MmE2RTBmUDN3Q3doWnl1ODJQeURD?=
 =?utf-8?B?MStsTFVwcmdPcW5zU3BuUjlrUktNNm9GNG9EWnVIV1FRU2ZMNm8wMy81aTB6?=
 =?utf-8?B?RDJxWGY3NlM4dW1VdnBoYWdCTlZHdXp5YXRlMUJyZnRvaDVwV3VJdTZ5RHNQ?=
 =?utf-8?B?dmYxRHRWQStHR2loZFMrZGRnU2tSREoxNFhZY3Vhcmt3NGRqVC9mMWFZRnBZ?=
 =?utf-8?B?aUxJUUFtVmErejB0RG5tZE9NYjhuaWZqUXVQOXhrQTZXNm5KWWx3WXovNmZn?=
 =?utf-8?B?ZlBWRzVCZVhGelVBOG1NYVQrUHNZRVp5SVBrZlJtZ1JLTnVHNzR5cUJnaDln?=
 =?utf-8?B?aTR5aFlDczBJdjF4U2RYbE5UNUdhYmJnOUhVL0VHL0N4YWtzNUJ6MkdwZ1pT?=
 =?utf-8?B?dGNEci9XTGtBSmNnblRwLzlpa0djcmlQY3lxS1cwR29iNFRmUUZHaFh4d3c2?=
 =?utf-8?B?ZE84eVhWTE1Nb2s1a1Z1N1NiRGQzVnNVT2V5cTl1aDRJczBOOVlsMzRKdXlk?=
 =?utf-8?B?YlVNSENPT0RXSFg0TndoUVpPR3p4aEtYWjBwRWx4ejBUclYxNlA1Ujd2aXVZ?=
 =?utf-8?B?UmxpL1M0VW55cnVRTHN1UXJ6MHFiejdsczZ0UFBudWRtZnRRbzlPdCtSd3BG?=
 =?utf-8?B?SFljVHdWOS9OK3h6MlZLM0NLQ0ZRZkxsTVJEVW9lMTdISU1od3M1VnhNNkI4?=
 =?utf-8?B?N0diRzJrTWppTEFpVUhuL0p6Y0dHS1NYclZ2aXVUbEdna3VKSHMweEJuKysr?=
 =?utf-8?B?TXkwdTNOd200TUVBOXBybThIelhjTTF2Y0NUV3RUWHdEMFdvNzJiK3JLeVpQ?=
 =?utf-8?B?akUzMUdDVmgyWi8vM2cvVi9vbFg1ZkJKdHQvSHdxM0wrRWFGZHdrMDh0Wlhj?=
 =?utf-8?B?ajJhRTJrRGgwcURYQWo2OEcwSXRRRUxVZFlCd2R3RThTRDE2RUNBMFVpNE8w?=
 =?utf-8?B?UjlUZ3FmTEY2dTJucGdLZG16MERIb21KcExpZ2lCMFRoUSt1ZSt6bUxvRjVs?=
 =?utf-8?B?ZFlQbmtsR1ltNERxK25STFp5QXVkRG5jUGhzUnFBVGlsMmxqNlR1ZDRHVHc0?=
 =?utf-8?B?UFM1eWRVamxMRS9KRHVuOFRYUDY4OTV4dnM2NE5YYlhobXp2amhYZ083WUN2?=
 =?utf-8?B?OUs1a2tGN2lWR0ptQVVmdlJ4YlQwT2pKdTNpYmk3S2l5VlE2cldZT1Q0a3pk?=
 =?utf-8?B?azlNL0VzZVkyTmNUVGFPelNWMnA3RVZUTXIycjZVbWZHT293MDRmQTdVblBv?=
 =?utf-8?B?Y3RMYkJCZy9nQnpSOVQ5NjRJdUo0aTNCYXZiMEVUZEdsTjVPUWlId0lsbHlL?=
 =?utf-8?B?SU4zeVVMQlIzczZ5MDZqQTJWM0FpNlNFNWNoRkNpNnF6WTFXOFdZTklhdEVJ?=
 =?utf-8?B?UUE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1323c291-aec2-4133-e0b1-08ddd3277c0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2025 07:21:09.4668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8sDXK6mo/uVM74ei3gttQtE5Hio4jUh8rv/npd7yitrCRkrdSeEj9aIC21t6ThFmVx9y6H/uBeJITtUSYsUKzVqbxiK306AyCwoQQo1/m0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5070
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGFuc2VuLCBEYXZlIDxk
YXZlLmhhbnNlbkBpbnRlbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDEsIDIwMjUgNzo1
NyBQTQ0KPiBUbzogUmVzaGV0b3ZhLCBFbGVuYSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4N
Cj4gQ2M6IGphcmtrb0BrZXJuZWwub3JnOyBzZWFuamNAZ29vZ2xlLmNvbTsgSHVhbmcsIEthaQ0K
PiA8a2FpLmh1YW5nQGludGVsLmNvbT47IG1pbmdvQGtlcm5lbC5vcmc7IGxpbnV4LXNneEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyB4ODZAa2VybmVs
Lm9yZzsgTWFsbGljaywgQXNpdCBLDQo+IDxhc2l0LmsubWFsbGlja0BpbnRlbC5jb20+OyBTY2Fy
bGF0YSwgVmluY2VudCBSIDx2aW5jZW50LnIuc2NhcmxhdGFAaW50ZWwuY29tPjsNCj4gQ2FpLCBD
aG9uZyA8Y2hvbmdjQGdvb2dsZS5jb20+OyBBa3RhcywgRXJkZW0gPGVyZGVtYWt0YXNAZ29vZ2xl
LmNvbT47DQo+IEFubmFwdXJ2ZSwgVmlzaGFsIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+OyBCb25k
YXJldnNrYSwgTmF0YWxpaWENCj4gPGJvbmRhcm5AZ29vZ2xlLmNvbT47IFJheW5vciwgU2NvdHQg
PHNjb3R0LnJheW5vckBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEwIDQvNl0g
eDg2L3NneDogRGVmaW5lIGVycm9yIGNvZGVzIGZvciB1c2UgYnkNCj4gRU5DTFNbRVVQREFURVNW
Tl0NCj4gDQo+IE9uIDgvMS8yNSAwNDoyNSwgRWxlbmEgUmVzaGV0b3ZhIHdyb3RlOg0KPiA+IEFk
ZCBlcnJvciBjb2RlcyBmb3IgRU5DTFNbRVVQREFURVNWTl0sIHRoZW4gU0dYIENQVVNWTiB1cGRh
dGUNCj4gPiBwcm9jZXNzIGNhbiBrbm93IHRoZSBleGVjdXRpb24gc3RhdGUgb2YgRVVQREFURVNW
TiBhbmQgbm90aWZ5DQo+ID4gdXNlcnNwYWNlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogRWxl
bmEgUmVzaGV0b3ZhIDxlbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBh
cmNoL3g4Ni9pbmNsdWRlL2FzbS9zZ3guaCB8IDM3ICsrKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLS0tLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDE1IGRl
bGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Nn
eC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vc2d4LmgNCj4gPiBpbmRleCA2YTAwNjk3NjE1MDgu
LjFhYmYxNDYxZmFiNiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zZ3gu
aA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NneC5oDQo+ID4gQEAgLTI4LDIxICsy
OCwyMiBAQA0KPiA+ICAjZGVmaW5lIFNHWF9DUFVJRF9FUENfTUFTSwlHRU5NQVNLKDMsIDApDQo+
ID4NCj4gPiAgZW51bSBzZ3hfZW5jbHNfZnVuY3Rpb24gew0KPiA+IC0JRUNSRUFURQk9IDB4MDAs
DQo+ID4gLQlFQURECT0gMHgwMSwNCj4gPiAtCUVJTklUCT0gMHgwMiwNCj4gPiAtCUVSRU1PVkUJ
PSAweDAzLA0KPiA+IC0JRURHQlJECT0gMHgwNCwNCj4gPiAtCUVER0JXUgk9IDB4MDUsDQo+ID4g
LQlFRVhURU5ECT0gMHgwNiwNCj4gPiAtCUVMRFUJPSAweDA4LA0KPiA+IC0JRUJMT0NLCT0gMHgw
OSwNCj4gPiAtCUVQQQk9IDB4MEEsDQo+ID4gLQlFV0IJPSAweDBCLA0KPiA+IC0JRVRSQUNLCT0g
MHgwQywNCj4gPiAtCUVBVUcJPSAweDBELA0KPiA+IC0JRU1PRFBSCT0gMHgwRSwNCj4gPiAtCUVN
T0RUCT0gMHgwRiwNCj4gPiArCUVDUkVBVEUJCT0gMHgwMCwNCj4gPiArCUVBREQJCT0gMHgwMSwN
Cj4gPiArCUVJTklUCQk9IDB4MDIsDQo+ID4gKwlFUkVNT1ZFCQk9IDB4MDMsDQo+ID4gKwlFREdC
UkQJCT0gMHgwNCwNCj4gPiArCUVER0JXUgkJPSAweDA1LA0KPiA+ICsJRUVYVEVORAkJPSAweDA2
LA0KPiA+ICsJRUxEVQkJPSAweDA4LA0KPiA+ICsJRUJMT0NLCQk9IDB4MDksDQo+ID4gKwlFUEEJ
CT0gMHgwQSwNCj4gPiArCUVXQgkJPSAweDBCLA0KPiA+ICsJRVRSQUNLCQk9IDB4MEMsDQo+ID4g
KwlFQVVHCQk9IDB4MEQsDQo+ID4gKwlFTU9EUFIJCT0gMHgwRSwNCj4gPiArCUVNT0RUCQk9IDB4
MEYsDQo+ID4gKwlFVVBEQVRFU1ZOCT0gMHgxOCwNCj4gPiAgfTsNCj4gDQo+IFRoaXMgdXBkYXRl
IGlzIG5vdCBjb25zaXN0ZW50IHdpdGggdGhlIGNoYW5nZWxvZyBub3IgdGhlIHBhdGNoIHN1Ympl
Y3QuDQoNCkkgY2FuIHJlbW92ZSB0aGUgYWxpZ25tZW50IGZpeC4gIA0KDQo+IA0KPiA+ICAvKioN
Cj4gPiBAQCAtNzMsNiArNzQsMTAgQEAgZW51bSBzZ3hfZW5jbHNfZnVuY3Rpb24gew0KPiA+ICAg
KgkJCQlwdWJsaWMga2V5IGRvZXMgbm90IG1hdGNoDQo+IElBMzJfU0dYTEVQVUJLRVlIQVNILg0K
PiA+ICAgKiAlU0dYX1BBR0VfTk9UX01PRElGSUFCTEU6CVRoZSBFUEMgcGFnZSBjYW5ub3QgYmUg
bW9kaWZpZWQNCj4gYmVjYXVzZSBpdA0KPiA+ICAgKgkJCQlpcyBpbiB0aGUgUEVORElORyBvciBN
T0RJRklFRCBzdGF0ZS4NCj4gPiArICogJVNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWToJSW5zdWZm
aWNpZW50IGVudHJvcHkgaW4gUk5HLg0KPiA+ICsgKiAlU0dYX05PX1VQREFURToJCUVVUERBVEVT
Vk4gd2FzIHN1Y2Nlc3NmdWwsIGJ1dA0KPiBDUFVTVk4gd2FzIG5vdA0KPiA+ICsgKgkJCQl1cGRh
dGVkIGJlY2F1c2UgY3VycmVudCBTVk4gd2FzIG5vdCBuZXdlcg0KPiB0aGFuDQo+ID4gKyAqCQkJ
CUNQVVNWTi4NCj4gDQo+IFRoaXMgY29tbWVudCBib3RoZXJzIG1lLiBUaGlzIGlzIGFuICpFUlJP
UiogY29kZS4gSXQgbWVhbnMgdGhhdA0KPiBFVVBEQVRFU1ZOIHdhcyAqTk9UKiBzdWNjZXNzZnVs
LiBJdCBmYWlsZWQuIEl0IGRpZG4ndCBkbyBhbiB1cGRhdGUuDQo+IA0KPiBOb3csIGl0J3Mgbm90
IGEgX2JhZF8gZXJyb3IgY29kZS4gSXQncyBraW5kYSBsaWtlIHJlYWQoKSByZXR1cm5pbmcgMC4N
Cj4gSXQncyBhICJubyBoYXJtIG5vIGZvdWwiIGtpbmQgb2YgdGhpbmcuIEJ1dCBpdCdzICpOT1Qq
IHN1Y2Nlc3MuDQoNClllcywgYWdyZWUgb24gYm90aC4gDQoNCj4gDQo+IElkZWFsbHksIHdlIGZp
bmQgYSB3YXkgdG8gcmVsYXkgdGhpcyBpbiBhIHZlcnkgc3VjY2luY3Qgd2F5Lg0KDQpDb3VsZCB5
b3UgcGxlYXNlIGVsYWJvcmF0ZSB3aGF0IHlvdSBtZWFuIGJ5IHRoaXM/IA0KQ2hhbmdpbmcgdGhl
IGRlc2NyaXB0aW9uPyBUaGUgbmFtZSBvcj8gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLiANCg0K
DQo=
