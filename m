Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD312D92D4;
	Tue, 29 Apr 2025 11:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745927087; cv=fail; b=bxldxA1/sqY+1Lqqp18ydjQyqUSgCzpekCltPHMfgTaSJKNot8yMoI5yob+f3sitB+MNv39R7inAzGcOSxsR24/PUwbUP8cY84B8tK8rugaj0iftmOGUicRz4RzhJdUJEwarmsa3e+HlNULI7jgd3ffBiHWZba6YhsKqrBYAerQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745927087; c=relaxed/simple;
	bh=Z799akb1eNrMfXV7lG1zIw7J2jgUZg/OLen4VQTpb0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SF4dtKJJPGWDbd4Hxap6ARYHf4lI4f58CKdfi1WoJILOfFXmZwY2vaiRRN9+vcY0lvYXf7jwUDGjIw4JspuaIgq1qEDVZET/SPTZzYnBP9891n4lvKNqyc+G25aKJW5p0H8RBkPhu1PsGS3238X25gfxyIxakSt/ZqGvqsjbegc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KyTfhEre; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KyTfhEre"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745927086; x=1777463086;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z799akb1eNrMfXV7lG1zIw7J2jgUZg/OLen4VQTpb0w=;
  b=KyTfhErelYWZvbJa8kOexgOrEtse8WNvWLnmkkEA0+U085LDNf+0fNxv
   r8SVMUKYFj66eNbzTq/U3anDBr/kyOEjyIRPesUK0T1UzAnWdehQNsJjT
   hHmeEWPuHXTLYm0fW+RKETbRzHTamMsIQ6+vS/EnUykMBeIP8caVa1NK1
   pWbS/HdTx+Gj69QmLQCmgI6em63npKEZ7swCj60C5Yj+LmdJNGrIbAYvl
   XnOQgihFGlfhKmLr+nzhJz0LqYNtHjJjtaYKc5VfYZZkuJUHU2GNUFk8l
   4bE8xq5dnOblAJKF4uSHqRxLYb77odNZfhzWLwizF/xQvguWGZDtWHm+H
   w==;
X-CSE-ConnectionGUID: KbNPvMrYTB6uFFiIL9SReA==
X-CSE-MsgGUID: CeIyLWOtT9ekiiVEAWHS3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="47553787"
X-IronPort-AV: E=Sophos;i="6.15,249,1739865600"; 
   d="scan'208";a="47553787"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 04:44:44 -0700
X-CSE-ConnectionGUID: 6fNDbO28R1Stp0YRs3YGPQ==
X-CSE-MsgGUID: 5EEhz35VQw6cmwehbTcqyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,249,1739865600"; 
   d="scan'208";a="133748218"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 04:44:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 29 Apr 2025 04:44:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 29 Apr 2025 04:44:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 29 Apr 2025 04:44:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O+T1HXb9w+aIPr5NkqQgK+vh/CDYiRVHiUbWX0t6IqZQDVhYqeLpciXzAuEg8P6EXXSKg7YFB60d5X7ULs74VVi8NOxMN/y7AYR1koPz/pdQZysZCy+gIX0YYF1gmcJZtFYguGreg3OH6aJ9iAZFlH9jRtejmnredolbIy89dJ8JSDupCTMMbFE8Jm6m/iy7pOvOGeeXXshKAy0lEhG+u2c+E62eshIAnh56zag96zuPNe8ErDz4A/s6ExfnFgr3IER3bdRjWff2dfjRy/rIwx4coYeHQchrCrgc/U1wQg3WltVnM4PJQ4Ct9SoNABKe0NrKofjuQGOwM/iW4+KdZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z799akb1eNrMfXV7lG1zIw7J2jgUZg/OLen4VQTpb0w=;
 b=ijSUbL/8DZYxT8zyqt4LbQNWNe0LwbG8VDEyUI+EMmRn7b+aESVrNMkoOlouMpbqihz4l/JOpWCy8C29uX6KslGwaGXd6lKy3jd+f3u9pR3r/GyUtQXYMo88MdiEXZgLf8bQgCJnxSB/S7XzInNISHOTLe45BhrzvNeHEGCPPvbpnHJ0COy0ErV+F3qlbp1KNCSWm7hhQyiMy6j8zZO5he3WEmAeqoxGNGhPMI1FaB1UocMSm2IL/uuHJIwQmkFnORaM7xRYAcWKa5O8rO6Wp3edp9/Vlg0Bl/s17I3gGIujfyvSJRA7PFcosbqodTV3S3CqxIJh2OEvO8XXl6jv/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 IA1PR11MB8198.namprd11.prod.outlook.com (2603:10b6:208:453::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 11:44:32 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%7]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 11:44:32 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, Sean Christopherson
	<seanjc@google.com>
CC: "jarkko@kernel.org" <jarkko@kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "Scarlata, Vincent R"
	<vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
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
Thread-Index: AQHbrfzujDHiSNozs0m8Z6fqnS5FZ7Oph/QAgAXK54CAAG1QAIACw3gAgABd6wCAAAZ2IIAANiqAgADdHdCAALsMgIAABskAgAAXsoCAAAu/gIAADsCAgAAFLwCAAAnhgIAAAmEAgAWa6ZA=
Date: Tue, 29 Apr 2025 11:44:32 +0000
Message-ID: <DM8PR11MB5750B39557F5062038D0E551E7802@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <aAo_2MPGOkOciNuM@google.com>
 <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aApgOqHvsYNd-yht@google.com>
 <DM8PR11MB5750AB0E790096AFF9AFD3AFE7842@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAutUaQvgEliXPUs@google.com>
 <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
 <aAviqeAdGn-w1GpK@google.com>
 <fbd2acdb-35dc-4e8c-9bd9-e84264f88648@intel.com>
 <aAv445Sr71NUJP1X@google.com>
 <db1fd062-5a66-4942-82e2-c889dd645a7b@intel.com>
 <aAwFhaqQDLXoqbmv@google.com>
 <4b4ecaa1-2ace-43bf-b71b-0de78bcf113c@intel.com>
In-Reply-To: <4b4ecaa1-2ace-43bf-b71b-0de78bcf113c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|IA1PR11MB8198:EE_
x-ms-office365-filtering-correlation-id: a44a9fa8-1d6e-4479-cde8-08dd87133568
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WVovam8wNmRUVllYQ215MnU0MFlBeWFoZHhoUWgyQkhuMjZKanMrUFB5QnhQ?=
 =?utf-8?B?Q3Y1ZTJMOUNHSmREK3NRRmpkQVh1dkRiaFVvM0IrOFp1SHlQWFVyZ3Nnalh5?=
 =?utf-8?B?MEVTclNJWHZBRmNHbGNKL0VERk9wK0RrbURiOE1oVGVPMWhPZXk5K0tvMUx0?=
 =?utf-8?B?dklhMmZoYXlzajdZN1o4eE5xdE5VREsxRkNXNko5R2xJK09JVTZzeSswQnV0?=
 =?utf-8?B?ZzUxazNCbE9pN0JGQUlYZWdsNjFxS09mY1RCY3BRdVlldG5jcjhOdzJBd3lJ?=
 =?utf-8?B?N1ZJYWhBZW5qb1BvZXY1VjZwU0kvcGNyQTJGZzR2WndYUEpUeFlwVWdXV0Jk?=
 =?utf-8?B?RUQ2akNsV25FK1R1SFAxQVJ4Tmttd09hZ0VXb1ZwR29vM3IyYUprOWowV05j?=
 =?utf-8?B?d0Vock8xZkwxTTdQdFRYci96MWZYSVp3S1J2R1RMUzkzM1VENUhDTTBzVm8v?=
 =?utf-8?B?TEpXWnJHa04vd0hnRWt2TitXWGFLUzYwa3Btcm9rRHZ6OGhDc2ZMSW9wZGt5?=
 =?utf-8?B?NWZxMWJmSnIyS1BvYitBaXptWFJwZ1lxSzJXcEtlWTF1cEVOOVhTYzVFME1o?=
 =?utf-8?B?N0ZnZk1PeFZrYTI3Z1A2U2Uvc2Z1TUNjU2pTaVVSVExkRDdMdzFMT3ZXSy90?=
 =?utf-8?B?aVZJUHVaR0JSVEUvY0NJQnIrK1pIZ3EveVdFT2p3TEdIQlg3bVlpSDRCVVJC?=
 =?utf-8?B?aGw5eE4vZm0vSnNBeE1OQWRKNnZNWmRzd1Z6YmxPVWJLQWp3WUpxd1Nub0pa?=
 =?utf-8?B?dmNkQmw4ZWZtWW4zYTNPbG1DQm9nZkZkWXI3aGdhOG1zMnNoTDZLMWVjN3Ir?=
 =?utf-8?B?YmpnU3B6RFhoNU16R0NHY3U1RU5sNDg3WWYxbDhqbjRnUG9YNjBCcVNRS0Yz?=
 =?utf-8?B?UFUxbEdMYXZKZFExaEtGaGkwYWFEcUNNNFdYZUl0VDI3UHlFbU5JSmhYdmJO?=
 =?utf-8?B?WjBrZEdpZkJWZGJvWThUQUVCNFlVYW16WE5Pd0JFV1BnUTdhcmZycHVWdlNV?=
 =?utf-8?B?cmh6dDlkNlJTVnBqQjdMbVg3U3NOblgrMXpYN1gyMW43cThqWFQrR1FXS3Av?=
 =?utf-8?B?NzQ1SnExM0lrSExFemZoWTJGQ3ZabHBwZTVIbFRoTjlxenZ5R2VySFdCSEJu?=
 =?utf-8?B?alFnSXo4VVJJWWl2aDJVbnliSmN5TVhEbEN5VmUvVzR1dVBQQUU2WmdWVHJE?=
 =?utf-8?B?YTVieU0zbEd6MllqK1ZrUDJaZ2w5bkNxaXRsNTVTUERCcUNLaWRPaHRaMXpl?=
 =?utf-8?B?bXlIOXVYdXZtVHhWTllBWEpTVG1YVWNBeG5uTytyOW9kb0t6K2lrdGJiRG5V?=
 =?utf-8?B?bWp4M1k4Q1o5SDdZTkZ1NVk0L2k3WDlWREp4eXJIUlhQQ2N2UnI0RUFlcnpB?=
 =?utf-8?B?U0JVWjQ3amRFdmpzMVlxbmlpQmpTcHVocnBHK2tnK3MxVFhXUGZ3eFNmdmVZ?=
 =?utf-8?B?Kzk5ak1hQ1VLNDN4Mm8rcksxUUFSSHFLSGhPUmxOS2N0Tnl5VEh3eVJCUy84?=
 =?utf-8?B?Nnl4Z005OElDRlFTSFlQd2gvaHJjRnlnYUNjOTIrVFRZRStPaUFjelVZZURX?=
 =?utf-8?B?dm4rSEdNUlIyMG9NZ20zVFBXdU41b1FwTVlUcFoyZXNxcnZsT2RkL2tZMmx4?=
 =?utf-8?B?dmxPSXNBK1FtSzY1RENyZDZxTndIcEhwbC9FNm42eTlHQnJveGpUUnFRN1ZD?=
 =?utf-8?B?UDZSRXZyVW1xZFEvNEtnQjZldmg2bS84TTYwUFpBTGl0aUU0cVFyeEtXZ1M3?=
 =?utf-8?B?M0ZIUG1mVGlNdWV3Z1pxNnRkYWtvMnA5QStPWDRUcFNZM29CS0x4ak5LalhS?=
 =?utf-8?B?cFhyWjBhbWQ3SkIvV1hQR2N4KzR0aW9UdDZLWG5zeHBoT1YrcTB5dWpIQ1pm?=
 =?utf-8?B?Y29tMnd4WVBUSUVJMUQyK2V0UGJGM1UyRk9KdUVEZk82TEJXK1VIL253MUFl?=
 =?utf-8?B?SjMzdGltdXcxZ0JtSlE3M0pPQ0VXdWR2VUFlQlJOK0ZuTDkvZnA1MVRhM3Aw?=
 =?utf-8?B?UFl0NzUxL0R3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmV2aGxxb0xDUlpuelZqNDAwdTNwVk8rRFE4YU9ydTVnZ2VPYWtLaWp1TU1O?=
 =?utf-8?B?ZExTU1VjcHgrRStlNDZ5R1RjbTIzcmp4aW1lWDhkcEQ1RStQWW9zQVFTL2xX?=
 =?utf-8?B?VVVndUo4MXlYOUFtWmpUSWhwYWkrZGVKMnBncnhNN3l4WTBFVGpvOWIxT2or?=
 =?utf-8?B?NEJnV2tabllwV0tzU2R3N1BTQnZQSmRRMjd0WnpFbVF3djlqUGI2OFFPZDNu?=
 =?utf-8?B?cHJuMWdsQmV2SHBOemt6STMzU2RYYzFmZG1QSlFjZjJ3MHRqeE5XK3RVc0oy?=
 =?utf-8?B?RDRRZzkxS3RiYm1UdmFuRlhUVXpGQnhoWDJiRVg0bUdWQ01Qb3Q2MFJHK2lF?=
 =?utf-8?B?US9CUzdiOUhKWVNQcXdDM214T01vdThPYXY4d2FrR2ZwRHNtdDdxUjUwNUtr?=
 =?utf-8?B?ZnQrTitsUzJXTlNLWXNhdlhFSVhBV1dmVTF1V2hpeUsvVGhLaXVrSzBLL2hl?=
 =?utf-8?B?V1E3WTdOVldxQjJyWW9LN3JnL2xBY3BMblgrM1JrNGUydGkraXN6T2QzWCtQ?=
 =?utf-8?B?SGIxMzVHTkR3ZlZTSDJ5OWdOT2VVTk9HWmVYeWVMb1dhdmFVanExQldqV0Zw?=
 =?utf-8?B?SVNSMVk1cUc4T0t6SmJDa2I1dHBKdTN2M1luZWJvT29HQU5zdWczdGVFdWZR?=
 =?utf-8?B?ZjYreEJWU3lJV1JHV2ptTHBiSEx2SVZmam1hZTAvL1ZDbVpZN1V1VjNaK0F6?=
 =?utf-8?B?dG5ZUjhsYldqM2VRWmxpVHFvQ1VXZkoyR3M0WlIyeFdhODdFOU12NldEcWpO?=
 =?utf-8?B?SlRBak52dGdGdFk1ZzNkd3NPQitSU1dBYmZwaDdxQm5SeTFqSUhKaWJFb0gv?=
 =?utf-8?B?QVRYUUVibDdYUi9mR0h6dGdNSWJjTlZLNk5DN09oRk9HUEY2TExOL0QvVWRY?=
 =?utf-8?B?aXpRKytSeHVRbEZmZzRqT0RVbEFMZXg1cDU5V1Ntc2lMdDFDVnE3OWd1YURj?=
 =?utf-8?B?b3lmdFcvNDRBeGR2M1h4dDVpZFU1ZTZlcFM1Y1E3bUVGc09CNk9lNzdGUXdq?=
 =?utf-8?B?VUpGbzJaQ3oyQ2VPZXUwWkJLWVVZdlZLSko1YTMxMWJ5dlU1TkkzSEFxdytN?=
 =?utf-8?B?SGVhMnFCNEpXZkN5bkVvVUx4T2JoaG9lemlyM2Y2d1d5bHY5QTZsZUJRaS9z?=
 =?utf-8?B?d3lUS092ODBwN085ZjRCWEZTNDBxeDZIRnRnQ1I5YVl0UmY2U0UzaS93NWl3?=
 =?utf-8?B?S2t5ZzNpOG0wNWtaSmVJcE9mY0dMMktaR2p0TUVaTnF1VmYzZ0VxQ3Y0aE9u?=
 =?utf-8?B?TnhTN2w0V1p0Y0luRnJnQndvUklzYlMxdGdtczZGUEpBL0k2eVpNc08xTGU2?=
 =?utf-8?B?OEhPdHlQUW03eU1EVS9MMUVzK3IzRU5vcHdPRzZjTDIzdTBsYXNjQk00Z1BD?=
 =?utf-8?B?SGdVYU9qaEJwMEJXVkRYQlRnMnNTRVl2M3M1TGpGbUNUOGdnMi9PL2czcGIv?=
 =?utf-8?B?eDBQYTA2cGsxMnlYU3BZTUJQUXdXYWY2RVBJaVZJVHVzOVE4MHdlRHBwYTBU?=
 =?utf-8?B?a0hkOVlFdzN5UEo1VzhqWkdvU255eEZsYWRmZEZlczJlMjUya3grMTYwRjN5?=
 =?utf-8?B?MU15cVN4M3dZMVdyT1lVVk9NU25nSGdVT05PMndkRThHTzlWaVZjL3FiTko1?=
 =?utf-8?B?cFBHdVNYRnR4cFpjWTJmUTZzU2hYU1VVMWl1WGRWamxUbmRFUk9MV3o1cStz?=
 =?utf-8?B?RjdDWnlBOExVUjB6MEoyUEhkNWVoS1FSblRIOXM1NG8vU1ZJcmZobDRkM3py?=
 =?utf-8?B?ZEllZFd2TzB6Q1VQOXVsS3lqYWNOVFNUSzk4cEp4d2t2U1c4LzhsR3JGTnpz?=
 =?utf-8?B?Y2p1dmNxNkJKS3RmNnFFN1k5WThJZW1pL0RYV014a0k0SzZHWHNNRmNQOVBD?=
 =?utf-8?B?SWNRQ3c1c1BtRkhvRUh3cm93REY2WlVsVTZTTmUwa0xUeU9YZUVIUVJHTjdK?=
 =?utf-8?B?VnBUeStreGNiQ3NMMDdmNUt3Sjd0UUZIQ3U3NUhkeUx0ZTQ1aHI4Nm94cXpD?=
 =?utf-8?B?Y0hIdFBhYVh1MmwveVd0SXpLRURGekk4dWtMVzdXT25oMDEwbE5yWm5UY1lr?=
 =?utf-8?B?TzB4U3o1MjhlNlU3WWZ5VmRHUmp4UVVQS0lhSVdnelN2OW51VEVKSUFwekpj?=
 =?utf-8?B?L0dYNWJmQmFZbThPbHJ0ZWhsaUZERm1abE5NSStuOUowd2ZRVzdIcm5SeVZ6?=
 =?utf-8?B?ZUE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a44a9fa8-1d6e-4479-cde8-08dd87133568
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2025 11:44:32.6037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oqy8ymsZuVSTeutCWt1EWoFB5Zaw9PqYJLH/8zwkcxBCA1QGTZGCXD71NElKBc9qaCUgrmF1b/zpybUtB/Ox9ogWR4cvhRpSUISGLWI4DgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8198
X-OriginatorOrg: intel.com

IA0KPiBPbiA0LzI1LzI1IDE0OjU4LCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+IE9u
IEZyaSwgQXByIDI1LCAyMDI1LCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gPj4gT24gNC8yNS8yNSAx
NDowNCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPj4+IFVzZXJzcGFjZSBpcyBnb2lu
ZyB0byBiZSB3YWl0aW5nIG9uIC0+cmVsZWFzZSgpIG5vIG1hdHRlciB3aGF0Lg0KPiA+PiBVbmxl
c3MgaXQgaXNuJ3QgZXZlbiBpbnZvbHZlZCBhbmQgaXQgaGFwcGVucyBhdXRvbWF0aWNhbGx5Lg0K
PiA+IFdpdGggbXkgR29vZ2xlIGhhdCBvbjogbm8gdGhhbmtzLg0KPiANCj4gSSdtIGNvbXBsZXRl
bHkgb3BlbiB0byB0aGUgaWRlYSBvZiBhZGRpbmcgdHJhbnNwYXJlbmN5IHNvIHRoYXQgZm9sa3Mg
Y2FuDQo+IHRlbGwgd2hlbiB0aGUgU1ZOIGluY3JlbWVudHMuIEknbSBtb3N0bHkgb3BlbiB0byBo
YXZpbmcgYSBuZXcgQUJJIHRvIGRvDQo+IGl0IGV4cGxpY2l0bHkgaW4gYWRkaXRpb24gdG8gZG9p
bmcgaXQgaW1wbGljaXRseS5dDQoNCkNvdWxkIHlvdSBwbGVhc2UgY2xhcmlmeSBoZXJlIERhdmUg
d2hhdCBBQkkgZG8geW91IGhhdmUgaW4gbWluZD8gDQoNCg0KDQo=
