Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713831CBA02;
	Fri,  2 May 2025 07:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746170593; cv=fail; b=h3aqoZWg3kvUJyn2VM0bJt+FiJ0sXQGW4HfxJpFYOmvlxGH2NWnvOBEeqOPAfYzPw2QtqtAbDl6jTvHl6Esv8e4QLWjh1WA40dYb49eRcKfQiyZksFbXVmM4wqHAL0eOszs4oTcBEwHl1Mny71OAZNoBhnlCHhlrRk9OD5FoIZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746170593; c=relaxed/simple;
	bh=GKr0Que1u4RzMiKBA+5CD5N9SQHgtBObnEf+sy7k9ag=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BvfZpUvR3Pkf1jTeelzg00kd+XbohHMhpm4N7vw8kSzziNVuWF5PXg9A3196guWXbMlmBwb5FVaK5Utr1mkuQ7AxQwXVdEw+V33K1PxQnPLzplf8jnKC3rH4A+4L61uGGMCDyWpUwQL/yBkzXTNiHHD6T11oqtiBIuwEZDBAvkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BXtBOr+B; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BXtBOr+B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746170592; x=1777706592;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GKr0Que1u4RzMiKBA+5CD5N9SQHgtBObnEf+sy7k9ag=;
  b=BXtBOr+B9lbexpuYY4oS+tYzhHaEEVFcNuime8peCTRGRcRuCtveLnGg
   eznK8GmtbxrGNG4+DqFEr9FHKsRKssl5vyIWOtu0FZwSFQ1uo0pLhecUA
   I5oNBGqxZJjpXbScKL//TOvKgLDNp3mkpcp1mmjP0rbSP1DgnA5Pma5K6
   Uj4aZuZnF8P2tDSGKSGVYcAKb2qWOECqItDkmSMrNmBHBj9G+jI1zdzVS
   LxhwSqHb4s8PtTOmZlnkPGh/7FwfFgNJHgCvkH8vm+Sn5uhfX6qCvpWLT
   /I+Dp12998k/FumGIEG1MWKImx2JHKGroKMRsNDTRx8kdhjZg1jhNqkiF
   w==;
X-CSE-ConnectionGUID: leMwug+OR76dCciWMwwqgw==
X-CSE-MsgGUID: ek17VLqQQXmxkooUpdELug==
X-IronPort-AV: E=McAfee;i="6700,10204,11420"; a="70352533"
X-IronPort-AV: E=Sophos;i="6.15,255,1739865600"; 
   d="scan'208";a="70352533"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 00:23:10 -0700
X-CSE-ConnectionGUID: ChGgDPgIRSix4GL0NMXyOA==
X-CSE-MsgGUID: 1K1oautmRB+CF7xsazW/FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,255,1739865600"; 
   d="scan'208";a="135090025"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 00:23:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 2 May 2025 00:23:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 2 May 2025 00:23:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 2 May 2025 00:23:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W552j3G5EQ1zPnf5irotK8y/MBSYQg+gv+Jbqf8ShUtGXu/idqiOn96WCWt0FkUfANVx5Aky3t4En6WlirT6F6NY/ESn/aEpf0g3Vh8Lgr4oOKc7L28MkN7PbZ4ThB2KKDvDWstWeUQXWQoC/e2ftOETiPZNLxqSUcNQt2iggIqOE0Je7V1FWc44UMHRmm1asZ4sZCskBfwyH1DnVUiZcH6+0/IPDFGOB0Pv+Wj9lvFAG8n292HgmUI4qMqm2MW0qJqnCXgjJDV+uo6atIKDnFAYbnXEKNyJfD1GrdE2vUEPir/iKkwswSg72/wxzV1i+rt7T4tzKodySoDgU/EqWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKr0Que1u4RzMiKBA+5CD5N9SQHgtBObnEf+sy7k9ag=;
 b=qSIG0k92OnOd2n6i3aYFsdljVkj+XdCvSknxHibEjoSdfJJkE/MEqpARd0ERBFxE4HhV75/tarygLHTbAU1F30qfst6O1d0sL2XJoMsOv3+tPNAU1mvXzfswO9GuTXNo3OBETXaPd390sH0sTsqt2LrqhUOdnXsVJgJEFtLRR9aNoH78a+z7oChS/XyZpUZ8zIAymlpQ/wfRR/odrjRVGVmG6vurwD7ZIsv3S8opDfBZsIpn2sxI0nVeFBvjn+I+DaDACnDfwymQ3wKt90+rgR5jJ77MzeSzriVfMrZZTDZwhyQ5RFpggNG3sPfaAMDgnMeKfXV3i63rFstm6xRWRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 SA1PR11MB8279.namprd11.prod.outlook.com (2603:10b6:806:25c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Fri, 2 May
 2025 07:22:52 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%7]) with mapi id 15.20.8699.022; Fri, 2 May 2025
 07:22:52 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, Sean Christopherson
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Scarlata, Vincent
 R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Cai, Chong"
	<chongc@google.com>, "Mallick, Asit K" <asit.k.mallick@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "bondarn@google.com" <bondarn@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "Raynor, Scott"
	<scott.raynor@intel.com>
Subject: RE: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbrfzujDHiSNozs0m8Z6fqnS5FZ7Oph/QAgAXK54CAAG1QAIACw3gAgABd6wCAAAZ2IIAANiqAgADdHdCAALsMgIAABskAgAAXsoCAAAu/gIAADsCAgAAFLwCAAAnhgIAAAmEAgAWa6ZCAADM0gIABBeNggACU7ICAAqAl8A==
Date: Fri, 2 May 2025 07:22:52 +0000
Message-ID: <DM8PR11MB575014811E4007EA00F5B3E6E78D2@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
 <aAviqeAdGn-w1GpK@google.com>
 <fbd2acdb-35dc-4e8c-9bd9-e84264f88648@intel.com>
 <aAv445Sr71NUJP1X@google.com>
 <db1fd062-5a66-4942-82e2-c889dd645a7b@intel.com>
 <aAwFhaqQDLXoqbmv@google.com>
 <4b4ecaa1-2ace-43bf-b71b-0de78bcf113c@intel.com>
 <DM8PR11MB5750B39557F5062038D0E551E7802@DM8PR11MB5750.namprd11.prod.outlook.com>
 <8db47bc1-445b-49db-b932-96aff0eb58a9@intel.com>
 <DM8PR11MB5750200DFF8CF40E3539B688E7832@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aBI-xQzatja2Y9dh@kernel.org>
In-Reply-To: <aBI-xQzatja2Y9dh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SA1PR11MB8279:EE_
x-ms-office365-filtering-correlation-id: 9acbcd25-1915-4111-06c3-08dd894a266f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N01sclU3Z09yck4zdjdPayt4blJaaDdZM0ZGQnl4NE1hdVBEK1gwYVN3TDVQ?=
 =?utf-8?B?MUhXVTBXblpFam1hSnVoZXpNcU5QK3NMQnRTNCtzK2kyaWVyM3FTSThxUW1F?=
 =?utf-8?B?cnBUYmI4cE1Rdkw0N0tSMWd2enh4aTJrdVY3SFpCOGlUV3pELzNCY3ZrNHlq?=
 =?utf-8?B?cjBJMHhzRFg1NHA5TWxTdnZXdURNZzB4eEUrdDR5b1RVeUhLWmRRcDNoNG5a?=
 =?utf-8?B?OFRkTjc0WXMvTFNvZmsySVVLd2RkS2dhTjIvaHRiU2Z1TUJsNG5JckRnYUtI?=
 =?utf-8?B?NDUzTlUyWkZYMElmV0JYMmwwb0t5YWlGT01mVzVwc0JTYTNCdy9sZ3FWaW9o?=
 =?utf-8?B?SmJYTmEzL3p5cW1sYVA4TUhEL3krSkJ0MEcvdTJIZzNiSklDczR0eHV4bmV4?=
 =?utf-8?B?QU9wdFVMWWtsSkJMMk4rUEJiMVNjNXJxdms1QnlxN25TaWdMVm1JSHBTUzNN?=
 =?utf-8?B?MnQwWTJPdXFEZlY0QmpzQlh2MUFPblNXdVF4QWRuV1pWNmxaVkRSMEQwWVYy?=
 =?utf-8?B?VEg3N09kQjVBNUo3Z2E3cEkrNUYxUFRtblUyL1QrM3FRMmRsdUlzanVPN1JQ?=
 =?utf-8?B?aHVUOThLYzI1Vm1zWlF3RWJKazR5MmtTOWFzUFhzem1NQ2lsWlVXRUtVcE82?=
 =?utf-8?B?N2ZwaWRBbldSTjlGVkRleHZJMmdjTTFiVzBlbUIyQU52SGFLdjIxNUtVNmFr?=
 =?utf-8?B?Wk5vbmd2SDROaVQ1T2tnODVPRGp3UHpCSkJuWTY3UjI0WHNlMHRJWGNzSTRk?=
 =?utf-8?B?T0YraGFCY3FpSUlBLzIxYnBQc01jMlk3YmJGWEVFWjZtdkwxRlhVbjBwdkRQ?=
 =?utf-8?B?Q2VZbGdTMXYrZzdIOVRZN3phNUpDZVE5YmIxL0ZoVjZiY3NGNlFJYVdtdnJH?=
 =?utf-8?B?VFN1OVZLRnZ2cXpSSW1qUldIVVNBRTd1NlFRamRXQmliZ2NiWFlVVnhHY3p3?=
 =?utf-8?B?d2lDemQxU2xMdGtEeUlCMlI5QXRnWUVEZkhsNm04bEc5NUpRQXV5cGY0ZlAr?=
 =?utf-8?B?QUlFUFJpTTNYSTR1a01vMStSNXg1d042aitWZlF5VzRCYzRMeXBBKzRzd29p?=
 =?utf-8?B?Q2tOS282M1U5emxLZ05BYjd3VEw4OWpnTkU3YSszcjJiZTg4ZjBtK1laaVdy?=
 =?utf-8?B?azhPOEpNQytUM0lTWVJrMGxFRGYvRXpJV0l5R2RrYm56SDg3ZWpOQ01maEFm?=
 =?utf-8?B?MXU2Wi80N0tON2dtTTZ2d3pkVlNpbytaeGtIYWNnV0FsbkJKZklEcWgwYkkv?=
 =?utf-8?B?M2k4T0ZwUXRrbUpPbkNzeDNqcGRBcDFRRmRJMGF0VDRydzQrYUZoekx1OUdx?=
 =?utf-8?B?TDl4Y0NiOHpMS0VwOVFNVmg1ZGtZeUs0aGRTWExBei9LUjFENnozVEZiWktx?=
 =?utf-8?B?U0FhekJIM1Z6YTlXQWVmc01ZQlFINDNwMlFqalIvMnlHYmY2bmpZS1NlRVRy?=
 =?utf-8?B?TGF4L1Yxai9NUGw2V0tDWGJ4VmVPMlVZOXFKK0V3QWF4VXQ2VEdSUmh1WitK?=
 =?utf-8?B?RWJrT0s0ZHZLN3RQN2tZZEdLMkpzMWw1MkJ0WE52RXpFbGRoYmZFenpIQU5s?=
 =?utf-8?B?Sll1RlBTbnVBY2MvVkR0NXl3YjJtRUhPYm90VWNobFV5M2tLb09kVXZnSG01?=
 =?utf-8?B?RjNwRXkxQmplZFVtbDhnKzdNNnYvV0J4WGw4WVI4STlPUldvVmszcEV3czB0?=
 =?utf-8?B?Um5HMkZodTk5OWtIYWoza0w0TVRpZjhCWGlQdmxHQ3JreW1rMzBVVGIySHkw?=
 =?utf-8?B?cmhQbzd3YnR4cGVhekRjZzNXUlVRUW8rdGRKdHBSV2RraWVNT2xDZlRBa2pt?=
 =?utf-8?B?WklqUVpKRTY4K3pQVHFuL05LWTUwRWwxQXFZOEdxQUtVeUpkRHd3b0NXTU9o?=
 =?utf-8?B?WGl1SDNtQnRhRFg0S1BKRXdUaU5yMWhTY3NiYWpXVFRMNHU4Q3NaYkhtSE1U?=
 =?utf-8?B?WitQSHoyZ3RZZnJ4MDQ0WFhiOHQxTmh1MWt4LzlldTVrUVNva1JkSWcrYTda?=
 =?utf-8?Q?hudwqhzfuHcBPKkmmJF6hVgJ+yWiwA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWtvVXU2bk8xTVE2Zkh2bHl6NldJZ3FWeE84ckdKanByamZLd0loS2hRa0sx?=
 =?utf-8?B?UzdBN013Z21hSU1UUS9TU3NPSDFjY1dsRE0xWmhBZFJFTEsvUkgyM01BblIx?=
 =?utf-8?B?MUwvN2RiTkQwL0FDT1VBdUZDTjRwZUY5U3NJSHRhazNWZktkK1RkWjIzZGZz?=
 =?utf-8?B?b1V5dHVtckZMbHFCWEQ2ZWRkblRPc1JBRzdNTENnR05rSDFzUVd3NFN5R3d3?=
 =?utf-8?B?YzJScGdTVHFibmM0Rk9ySWx3VzBsZk1MbVlzUy96VWZQMHNPTTlXSU1FQmNt?=
 =?utf-8?B?ZW9iblpOZEdhTGNaK0x5SlZabFNFMDMyWVdORFArVjJTUEZZYVRESVYveDJo?=
 =?utf-8?B?dFZjR3RTaUdHcTd5ZFBqZG5acXZXMXg3Wmp1Tm52NkJaUCs5YVdIeHNBRXNm?=
 =?utf-8?B?V0tkYzBTTkNNbmJSTXhCcERVZzIwOWpFU1k5NXFKWkZpcmpFcVhGckxVeFVr?=
 =?utf-8?B?MWRPSFpkaUp5L2c5Y25Lc0tXbGVvbUdJT0hrU04vQk9FSitJYzE2bVpsQjZj?=
 =?utf-8?B?MXBVK2w1T0s2MWZLckdndFN1aHc0Tk0zb2kvK1l6TEo5Ukk5V3VJWStuMExL?=
 =?utf-8?B?RFlzVnhTQjdNeEJDWnppRHFqbjR3ajRrRFBmbFlKSTBQMit3M3h6WWFhVnIx?=
 =?utf-8?B?dm5scjFzYVR1bWlLa2NiOC9xYmNyNGw0clMzcnNMT3pid3EycnVuMEdweW9H?=
 =?utf-8?B?Y2Y4ZVRuUHd4MmtkeUhBS0VhRzE4NVJnZXk4YTNoVnRydUdEZ3daMEtPTlB2?=
 =?utf-8?B?Wlg5Z3NJUTB3am02ZWJjTHFhTDdkanExK2NOajBSNDZIcUtiQUhOK0w0VWVx?=
 =?utf-8?B?di9TenduVnA2eVlEdEYxbkorczY0bWtHUzhOWFZ1Y1VmcDlDR241d0d5T080?=
 =?utf-8?B?L2ROMjBMdXVLV1pTdnJjVUg0czU3ZEt2NGhHUXBpSXRLcG8vbUV3eXJzQk4x?=
 =?utf-8?B?Q21qT3V6UmJSaHlPbEVtRXBqRlhUYWpZa2ZVdjhMcGhjbElEVUVmSU9GWkcx?=
 =?utf-8?B?SXRmcE8zLzF2cWFlbExpeTF5K08wOE5FM0ZXb05qV0hJNnU1alBTWUNhM1Fz?=
 =?utf-8?B?WHViaWVhY25vMkNROHFrcytBMXNhdnhxQXVYdEFkVDZ6RWNtTWZwSEw3NUxW?=
 =?utf-8?B?bmREMTlWTnZ4RS9obUE3ZXIxdURKaWcxK0tDblB1bkl0VHRZR2twQm9NOHBr?=
 =?utf-8?B?eWZvN3laQmtHWTRydlRrNS9LZjVHWEUzcU9GQUg5Rld2MFkxbHNyZ1VkTW1x?=
 =?utf-8?B?QklKTitQeU1XcUs1VjdueTRHcmhEdFdaRlo4Q0d6K0xqNjdlNEh1Q0kySDhu?=
 =?utf-8?B?SXRZdU1jQW9tZFl5NDJkZmhSZVZIbm45Z1JjUXQzRW5KZmlzbzZuaDNNWENZ?=
 =?utf-8?B?RlJIaE5wY2Z5QVJIV2ZCdnpPUUhBL1ZBZWp2T0tSY2lJcWNsbCtqY3N3bTZT?=
 =?utf-8?B?M0MrdHhoMENQeTRKQTRIL1llSFRiYmVQQ0ZBL2s3TFhmWU04Tjd6U3cwR25Y?=
 =?utf-8?B?b3M1cHV4dzhJQTRMVzNqNWNTTVVJRTFNRkNPM25WTVg0TkdTeklVYWxlaXg2?=
 =?utf-8?B?aVVHa3RDdWRNR1g2YlBIenRISjA0WmFnQTcreEFKRnJ0c0lqczRtOW9LYUEx?=
 =?utf-8?B?VGNtUUdGRWNPaVlUdmpWQ3FFMVg5U3VXTFM5a1Y1eUdqdEdKUS85WHpFbzV6?=
 =?utf-8?B?VHR6WUZXY2hEWjYyam84WHZJcTZwTmg1aE9jL0ZZV1c5VVhFMkNqVVhLblpV?=
 =?utf-8?B?dktkV3JKRGFuOWZQT0NMOWszK0h4U2ZRc2JOOHh3MW0rS20wU3FVeXFRZkxT?=
 =?utf-8?B?eEhrOHJJTThqb2xjZjg1TVk0Mnp0V2R5WmFpR05TVjVHNmFOeG5ZQVc1a0FP?=
 =?utf-8?B?ODdycDliSU56dXBKRWI5eUxzcUMyOWN6c3ZnR1R1MjQxbFBhN0x5TW5jOGVH?=
 =?utf-8?B?MFJMb1A1QkdZb2NtK203SmROSy9mb0pWUG9UcHo4WFNDQVlBYzJkbEhZTWNT?=
 =?utf-8?B?SmRFZFFCSVkvSGxxMHNyYnRMNGNCUGVkOVR6VFZ6cEJ3RTZQTVhVaUl2SXF4?=
 =?utf-8?B?d3ZBVUg0SThRSE80TDNvODFJc0l5SEI4eGt1aFE5a2cvYTBoL1lvMDRCbThW?=
 =?utf-8?B?aHltVVQ2SzdRbFRyUm1jTkIzR3Q3ZUN3MUNEanM1M2dyZWpYRGZYK0N4czB1?=
 =?utf-8?B?eUE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9acbcd25-1915-4111-06c3-08dd894a266f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2025 07:22:52.1547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lbv7SvGKrBak+uNg6U+fuPiCoraQLRLVDKsrDkrueIfa/MJDTd/SZFe/6QuF2BX9dLBGRUsY0wAmamTP7+GqZoxcepe/LJaoCfcaGxqIqsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8279
X-OriginatorOrg: intel.com

DQo+IA0KPiBPbiBXZWQsIEFwciAzMCwgMjAyNSBhdCAwNjo1MzozMkFNICswMDAwLCBSZXNoZXRv
dmEsIEVsZW5hIHdyb3RlOg0KPiA+IDIuIFN3aXRjaCB0byBTZWFuJ3MgYXBwcm9hY2ggdG8gZXhl
Y3V0ZSBFVVBEQVRFU1ZOIGR1cmluZyB0aGUNCj4gc2d4X29wZW4oKS4NCj4gPiBCdHcsIFNlYW4g
ZG8geW91IGFncmVlIHRoYXQgd2UgZG9uJ3QgZ2FpbiBtdWNoIGRvaW5nIGl0IHNlY29uZCB0aW1l
IGR1cmluZw0KPiA+IHJlbGVhc2UoKSBnaXZlbiB0aGUgbWljcm9jb2RlIGZsb3c/DQo+ID4gSSB3
b3VsZCByYXRoZXIgbGVhdmUgb25seSBvbmUgaW52b2NhdGlvbiBvZiBldXBkYXRlc3ZuIGR1cmlu
Zw0KPiBzZ3hfaW5jX3VzYWdlX2NvdW50KCkuDQo+ID4NCj4gPiBQcm9jOiBObyBuZXcgdUFCSS4g
TW9yZSBwcmVkaWN0YWJsZSBvbiBzdm4gY2hhbmdlIGNvbXBhcmVkIHRvIG9wdGlvbiAxLg0KPiAN
Cj4gPiBDb25zOiBUd28gZXhwbGljaXQgcGF0aHMgdG8gaG9vazogc2d4X29wZW4oKSBhbmQgc2d4
X3ZlcGNfb3BlbigpLg0KPiANCj4gV2h5IHRoaXMgaXMgYSBjb24/DQoNCldlbGwsIGp1c3QgZnJv
bSB0aGUgcG92IG9mIG5vdCBoYXZpbmcgYSBzaW5nbGUgcGF0aCB0byBlbmFibGUuIA0KQXJlIHlv
dSBvayB3aXRoIG9wdGlvbiAyPyANCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuDQo=
