Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625E222D4D1;
	Wed, 16 Apr 2025 07:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744789014; cv=fail; b=i7/fBZpdYlGpfd+HQWvSnvqan89j7dWYozfwMcsdavnb4G1U5t7+Og72mYUJNBx2Xx0+pjtBYCSl7KiJBOsdXes6aYsVMWF5yc3wgIima4ToTZOtY/OAU5pR4zfoQsHUF12NulO/+LoyLP0LZZspYmdV9WVGaUDyQoMIjtZfFpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744789014; c=relaxed/simple;
	bh=fxLWB6IWuiM0gZvqnKvZT6abQbIRqIpkpUKAhgpN3mo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EBpLQxg+W8kvbI1dwBvZwXUDJRgLdz5c1KpyScawKthuXo3wbp/YFRzYsyd7fvyxKAbioFr5rrnbL9Kf/0R3sPOFaQwgpWpkuU7D8osblXDyehJ6fP2GEuyjrxv2oEOpYbfrqH6mgQcQjVO/O5fHbS/uu3FrvkvVFWCeyw4Ase0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fjqzQ8Cx; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fjqzQ8Cx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744789012; x=1776325012;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fxLWB6IWuiM0gZvqnKvZT6abQbIRqIpkpUKAhgpN3mo=;
  b=fjqzQ8CxcRNtg6LaLe72BSA1asl6O68qdBHUG1eXzEQc1rvoda8nyYvO
   M8BjfJSPiuXWnnkzGWBSWGD743Lg1qLPjLtyctw5IBtey3vUEBmVULdiR
   gZmERpPhc5FIW3DwthhzWUyCj9TRCCkOOTIdy+7i82YtUmsn58iABE4E/
   K5pVi07XYadzo8V+SPBeJ5QwOJl4Xs3DhC/LBmRrbgeeDWUzQnk7NqtxZ
   TE4jw1qUgdPaV8k898ErDoX7NGYY8NxS/KDOMkr6S6k8cGkwgkEw5FcUD
   XzLh47lhzFI4Nap0xOXDj//pZ99TmysQKjJ8HLtIYjv4ATNY8YQ1cyLd+
   g==;
X-CSE-ConnectionGUID: 51vq72YeTXGUd0MdO2f7WQ==
X-CSE-MsgGUID: /y0JwVr9TJuFBtRiNZwywg==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="46486083"
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="46486083"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 00:36:52 -0700
X-CSE-ConnectionGUID: /meV+ev9TB+KqTqVplX1kg==
X-CSE-MsgGUID: 3viTGI6LR7GQ46rXD5yUSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="130311609"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 00:36:51 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 16 Apr 2025 00:36:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 16 Apr 2025 00:36:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 16 Apr 2025 00:36:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iVHNg6EwoxwqG2dWyV500YRAhMQKNneCvhTFXWm7olTjr0d2/UbfGjtyo5nsIn/K2MaOV2Qc3Dg6KCgUIaPwcfeC37yh947y3qnzzriAWsf4ON3N8XUH2jgKPyyD5KgIec4I9wKzniohnt3kukZdmXTF46cAs4keFlpwBU9BQa/GHY7KzqJNytfRXNw6jk4U1qoQhFhFBQqU4V/biZJzTg7vqy+Yz/FTdZA1gEn/uIcLUW4Wa58hXUo4er8X+jZom7vgkwFdICWqznhk/6LRU9nValJwwmy6mrfbqVurizjcyWUVrVyIBrzHLHlopFzj3ZcuuMBwowq3vpCZoUjMqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxLWB6IWuiM0gZvqnKvZT6abQbIRqIpkpUKAhgpN3mo=;
 b=G0lM3JU+EzhU7a5LgiFTijUR9V7s8dDWviDiuwuO3F9eVntDdV1kL3Lif4hhAVPIDl4OPe4dawDq9CrByOrFPtS4SRf10waSFUAkBuQB5euANAP+uRsAq/uNiiy5XMLo+5CNydNlh6lm3qT5ho4slxW+CLStCknCLUv58VOQg5pC8wabKIecPT7UYmF1s2SeBREdHuIzczwhjq+1an2YiNDgx/ePA6XoKBTQU/iwaKpedrpJvDJGIg0j2Va3w+0nPQ55e+3QtFQ3lqsjX8hddlnYfeqER1a9C3Fc0hAw1674DND0mQzhdXHiiUAl3AtknIKnXcDEwRCeKtqO7t3uDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Wed, 16 Apr
 2025 07:36:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8632.030; Wed, 16 Apr 2025
 07:36:38 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Scarlata,
 Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Cai, Chong" <chongc@google.com>, "Mallick, Asit K"
	<asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bondarn@google.com" <bondarn@google.com>, "dionnaglaze@google.com"
	<dionnaglaze@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Topic: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Thread-Index: AQHbrfz+Y/CHaQuxfEeQ0lhbNBYyWLOl6JWA
Date: Wed, 16 Apr 2025 07:36:37 +0000
Message-ID: <11f7e006073d2a4fa8fd6c609024a69ed40af9d6.camel@intel.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
	 <20250415115213.291449-3-elena.reshetova@intel.com>
In-Reply-To: <20250415115213.291449-3-elena.reshetova@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BY1PR11MB8126:EE_
x-ms-office365-filtering-correlation-id: b804d661-d810-49d2-7b3e-08dd7cb96c1c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018|13003099007;
x-microsoft-antispam-message-info: =?utf-8?B?N2hPSlFyVlNjSngyalpCbHJudlBvMGd5YklUb3R2OUdUZTNJT2JJQ29BdGcw?=
 =?utf-8?B?Qnd4bVhSdXpoOHd0NGxTRjVpdGpUbFRuUy8zTk9uMG1EYlZkYTBZSHB1SllI?=
 =?utf-8?B?N09nRlJ6TVNVcHhCY1J2YnBQQ05CT2R6Nys5SjNYMTNQWjlGUWxNQ2hJQmp0?=
 =?utf-8?B?cWVWS29YN0tvR1Fsb2ozTEZ1OXh6cE5VZ3JDbTZLTTV1UytxQXVaZHprWlN6?=
 =?utf-8?B?UnRYRGNtOVFkRFFPd1FyeXh5V3drMHYvZUV2Nzg3dUt0ZmIyS1hyaHhjT0lV?=
 =?utf-8?B?SGMrekVqQm9hcFlZUCtDYWtXcUtmY1d6b0RGUFoxOExna2tlT2VmM0YzaWNT?=
 =?utf-8?B?bUFraHBybnF1S3NGMERjeXk1Y1pqbnh6QmlQbnlwcEZ3MHNEaTBva1BWcXBr?=
 =?utf-8?B?ZlUwbTlqRisxczRFWmh3UHJwOHNsQ2hBSzhuaFhMQTFwK1JINWtHUncyTVFx?=
 =?utf-8?B?WHQ4Q053aDhRd2VvdndFaDBCMTNMVWZVa1luelZtL0NWbFJURUtXRUwxWFdM?=
 =?utf-8?B?K0hURWJUZTJsODdreWhNUEN0S05IdFRWRzdXRU8wVW1RaGxqbElPVG5GdUZi?=
 =?utf-8?B?WndRVzdTUVJYSUJaN2pON0h4K2pLb2ZzSXJHY01MWHdEWjhhd21wZDkwOWt3?=
 =?utf-8?B?b0pFbWk5SW9aYTVSUlNJQitzb1g0V0NnM0k3b3oybHFPWlZmVDhjRC9QNFFI?=
 =?utf-8?B?eXJCR2xBa25RMjA3bjRrUzBoWUF2V1ROY2gvOVlBUkV1bDl0RWpOSGhtbzJP?=
 =?utf-8?B?UjNQVmRpeVNwRXJWelNSdzZKMEViL0NrSnV6UXQ1NGt6S0hxaWNERHIzVjdY?=
 =?utf-8?B?bHZQSzZ2SkFiOThxWEZoQ01KSU5mUE1vZktNZkFGZ210YUF5TTVvWXpoSEd3?=
 =?utf-8?B?SGxONFNQZ1VrS3dMcVJLZE9FZm9yU2hrZVdvMHJiSmp4cnRtRXlGL2pvVXNw?=
 =?utf-8?B?VXJ5dFBOYlQvbzg3d1B2Z3NGQ0RVQUo5RjRUV09RUUU2ZG9Wb3U0bWJkdDVW?=
 =?utf-8?B?OUZyYTBHMmh3d2ttOWZIRE0reVdUTVMxYVF4dVNhTTNCSFl5MDdudFlzbHBE?=
 =?utf-8?B?YlFTSXR6VW9peTgyZzlxWTI3YnpuZkVIVlpCZGpGU1oxM2FpRjg3UE1MZFVn?=
 =?utf-8?B?cFZsMlVnLzNUbHNhRUtGL09oSnVFVGU3TzVoYWlaRjNnLzJZTWdGVlA2cHNS?=
 =?utf-8?B?MFByd1ViTzkva1FOSUdoR3FnNVFFdkc0bUtJazJPMm1DcUVIaGlISm9wSEc1?=
 =?utf-8?B?QllZZTJWNlM5a3J0WFJFUjRzTmh6YytEWkdkQVpBY0VXRmgvL3JRd2JEUVJz?=
 =?utf-8?B?aGo2cU9obmZqa2xTenordGg2V0NtL2pwUTlXWitmZVNEalJzY2NKZERReDA4?=
 =?utf-8?B?RHFLb2RkN0xXcllFZkpGOFpnTVhyM1dReHIwT1FqN2s5TnNaUkthNE8xRGcz?=
 =?utf-8?B?VEJJL1NyVy80ZDBUK3ZxSW9HOVEwS3BiL0FBS2lxby9VM2NQcmowZ2ZHcEhO?=
 =?utf-8?B?UURrdU5LTHE2ZUYrUjBjSlNQNWs1ZnlENlFYNHVwZkkwbS9qYlFyeXlwVXgz?=
 =?utf-8?B?NE1OVWc2SnhmdmprOWViVm5QNDQyNVVlQXEzbzdUR2tRL0ZsQ2dLUHhlYk5N?=
 =?utf-8?B?TG9xOE5yYTZ4VnVmNGhmS2VFUmQ5NDhqZzJYc2ZPYm5vSFdqSVVuTXoxdnIv?=
 =?utf-8?B?eSswczZ3QWdMalhtclhvMExKOWU0L2dZZTcwNEl4MGJBTE1nL0NOWExBakdE?=
 =?utf-8?B?b3FvWWxhc050SGc2TnB0cm1TNUlRNTV6S2xMZXdET240S0QrR1hrRE9LL25y?=
 =?utf-8?B?VDBLWUd6bys0eVZBWU44VVo5UFFDUUk2MmptZ24xNTVlRFJjU3REbDI0UnMy?=
 =?utf-8?B?b21PVWdSN1ZxQUxVbW9nRXgxZyttUldrZVlTczZzVkNkeGlMcXhoc3ZTYUR3?=
 =?utf-8?B?S2UwWkxodWxJU3dMSElKMklweEVicVgwSXE2eEswaVJMU0JwUjlVMWdUd1dK?=
 =?utf-8?Q?9spqtzxRs2/EBofaYt4/bsDhD2h7fg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018)(13003099007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmxxckJnZTdmNStUZFptTzV6ckltaXk2ZnNUaExGTEZJbzZ0QVVGdnpmZWRO?=
 =?utf-8?B?eVV3ZCtpM21lYWoyN3UxNENVWTNURlJFRlBrY1VDd1M5WW1CS1poc05oWXVn?=
 =?utf-8?B?QVZmVTJ0cy9jWGNVd01VSExwaTdJdG1SUG1FcVkxQldrbENPdEszNmE0dFVJ?=
 =?utf-8?B?RnBnZzZRaGJIdjFyT250VFMvNXNaUWxpUXBGUnJGNGFHNXNxdG5EUEpmUVZz?=
 =?utf-8?B?K2RvY2NSZ1RjSHZYYXhPRlRMMExGK1BTamx4NW9VTkhyRXpGNTFwZENOTFFz?=
 =?utf-8?B?Q1E3QSt2UkNOMEQvWk0yVDNhY0VlUlVDMGMvUEJmTHd6NTYvUlFmM1Q3ZTAw?=
 =?utf-8?B?ZHB6Ui9CaEd3WjliRG5QVTU0YUZ0NGJad21sNFlvbmZ4YUx4a0FiQUNZNUtY?=
 =?utf-8?B?bzZvUi9KaVU1UzVuVER4RHl4Z1ZBVmErbC9EbVZvUzJ6MlRscFJVTDBwM0Fr?=
 =?utf-8?B?MWkxUnZxSWJlbXE4eU0xQXpJT05TcjdEN244ZERoVk9SVTlLQTUyb2dxcm1B?=
 =?utf-8?B?QW1ibjNaZHhTTW1yUWpiaTVmTVMvd21iZEFRMHhBKzhFSlcxTU1meUp5U25M?=
 =?utf-8?B?MkRiMFIrK2dBMUN4TEZIZW9aOW52OWxUQ2VOT1ZWd2w3L2ZsQVQzb0h2WlI1?=
 =?utf-8?B?dHR6bE84dWY3bW0vejlmM0ZQSmQ4QmRtSWhmTlNEaVVzZ0lpVG8xdi9jMkdZ?=
 =?utf-8?B?dVY2cWU1bWxMTC9qSUM1MzhZTExrdmFoYmxLVlFCYUk1by9VdWxzZVcrY0tt?=
 =?utf-8?B?Q1IwdEx6c2J1aUtyMEdTUkhZSUN5WU5UU3RNYUkxSy9HT0ZESGIyMHE2Z0U4?=
 =?utf-8?B?WWFjMjNteTY1YmhSVTM0UThrckZ0TXg0bkpJNzNyRklmeVRybGZyei9CR2VS?=
 =?utf-8?B?MFJKOTRWdmIvRWZBQTRGY0Z3L2g3Rlk4M3hMcVR4UW9ZQkt2STc4YkE0VFEx?=
 =?utf-8?B?TVVJMXVLK3AxZkg3OWFYeC9XVnBySWRBY2pHTW1haXRERFVDQmttQmFuUVY2?=
 =?utf-8?B?S3lObGhnVWpLL3BSVkxrVDVkOTZBUEVSL2grU3V2c2dobHZmdmdEOTFHVlJZ?=
 =?utf-8?B?dEFjckFoUUxhb29uZGxteU8yQTMzRUlsQTl1Y3VjUmhEbnFoWk1PNWwxWURu?=
 =?utf-8?B?Q1ZpUU9xSzA3SEZJbHN5c2FNUWQ3TnV4NVpEVU5qTENJTHBxQ1ZxdXFkMVVK?=
 =?utf-8?B?bzJRY2hIbyswTWJ1S0FKY280dmRhVk5Ldy82c0t0RTErazhjd1ZhNWM1a2hD?=
 =?utf-8?B?eldjSXFjRTBBT1FYTnc4VWo2NUZVc0pPb25USUFWOFJabmNEVUtqSXFFOEkr?=
 =?utf-8?B?dmpRakJGMlFpRDJRSVdrQk1jUzI4Z05SZDZxV3BlSjNSNTJtU2VLMVk4Nk1z?=
 =?utf-8?B?Q080TEVCSUU5dTFiMzFMYWEzS1puSlBDMXVweXVBSmRHQTZoandsVUh1OHAx?=
 =?utf-8?B?RzgzVnAwUDdqeE9MMHJPR1FmOGdERDNVNUo1K3p5VTRZdXFkK1c1MWpBSm00?=
 =?utf-8?B?empoR3E5WkRURlMyWHYwWnE4Q09HRHBaWDNBaENyZGZFV2xWWkpQc205N1RH?=
 =?utf-8?B?U2ZidUtrVmdLbE1wT1A3QWVpRUF3SkVEUjdIVUlnMTFBZkQ0QzBMNE14cVU2?=
 =?utf-8?B?VUE5N2tOWmhxNzM1ajNsZnFDaWRxRkpSQUJLQWl5YWZyamtYL0pjR01xNDVP?=
 =?utf-8?B?NHB4ZzdRb0dhMFZaTTc3YVE4MEpWUjV4RE1xOFZFUkdTZGE1aXA0U1poOW9Q?=
 =?utf-8?B?Vjhpa25jQXlZSHQ4dnUyMmx5MEg4TmQvK3lZMzdnLzVKSnBCWDBycUxrV25Z?=
 =?utf-8?B?UUJRV1lXcTdSTlo1OHVYK0pDM3FHTU9IckllNXk1NWlWdVRwY1A2dytlMmlw?=
 =?utf-8?B?RUVvTDhqMVJ0emRHTUlyUHNta3FEaXQwczlnNXF6MGFrQzhQT3B0eXZja0NX?=
 =?utf-8?B?cTlEWDRuT0JGbkZaUFZ6b1ZiUmdRMk1iaEtzalYrZ3ZBdWU5KzdiZElSUXFI?=
 =?utf-8?B?akVqWTJ4T01mbm5USmtRMDhYRktwOUZBTVFyZVNadUZMUkVzbWJURHVqVkc2?=
 =?utf-8?B?OWo3S0VpQW9qK3p5R2RQNHVEcm56aGNoUTIrNHlnb3FGRllhOGhYZURLN2t0?=
 =?utf-8?Q?ZpOBso1i0UQ9QcgQvyTRQVD4o?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <83C69FEB8934CB4995A95770276691CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b804d661-d810-49d2-7b3e-08dd7cb96c1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2025 07:36:38.1022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u2Z6J1Cu9LTXVQyQupYG5YA2CRhL81hFRrEwOF//MZAJyd2O2b4oubfJuqaUP4j1g51mV6TEDiS7wq6uP3geMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8126
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA0LTE1IGF0IDE0OjUxICswMzAwLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6
DQo+IFNHWCBhcmNoaXRlY3R1cmUgaW50cm9kdWNlZCBhIG5ldyBpbnN0cnVjdGlvbiBjYWxsZWQg
RVVQREFURVNWTg0KDQoiYSBuZXcgRU5DTFMgbGVhZiBmdW5jdGlvbiBFVVBEQVRFU1ZOIj8NCg0K
PiB0byBJY2UgTGFrZS4gSXQgYWxsb3dzIHVwZGF0aW5nIHNlY3VyaXR5IFNWTiB2ZXJzaW9uLCBn
aXZlbiB0aGF0IEVQQw0KPiBpcyBjb21wbGV0ZWx5IGVtcHR5LiBUaGUgbGF0dGVyIGlzIHJlcXVp
cmVkIGZvciBzZWN1cml0eSByZWFzb25zDQo+IGluIG9yZGVyIHRvIHJlYXNvbiB0aGF0IGVuY2xh
dmUgc2VjdXJpdHkgcG9zdHVyZSBpcyBhcyBzZWN1cmUgYXMgdGhlDQo+IHNlY3VyaXR5IFNWTiB2
ZXJzaW9uIG9mIHRoZSBUQ0IgdGhhdCBjcmVhdGVkIGl0Lg0KPiANCj4gQWRkaXRpb25hbGx5IGl0
IGlzIGltcG9ydGFudCB0byBlbnN1cmUgdGhhdCB3aGlsZSBFTkNMU1tFVVBEQVRFU1ZOXQ0KPiBy
dW5zLCBubyBjb25jdXJyZW50IHBhZ2UgY3JlYXRpb24gaGFwcGVucyBpbiBFUEMsIGJlY2F1c2Ug
aXQgbWlnaHQNCj4gcmVzdWx0IGluICNHUCBkZWxpdmVyZWQgdG8gdGhlIGNyZWF0b3IuIExlZ2Fj
eSBTVyBtaWdodCBub3QgYmUgcHJlcGFyZWQNCj4gdG8gaGFuZGxlIHN1Y2ggdW5leHBlY3RlZCAj
R1BzIGFuZCB0aGVyZWZvcmUgdGhpcyBwYXRjaCBpbnRyb2R1Y2VzDQo+IGEgbG9ja2luZyBtZWNo
YW5pc20gdG8gZW5zdXJlIG5vIGNvbmN1cnJlbnQgRVBDIGFsbG9jYXRpb25zIGNhbiBoYXBwZW4u
DQo+IA0KPiBJdCBpcyBhbHNvIGVuc3VyZWQgdGhhdCBFTkNMU1tFVVBEQVRFU1ZOXSBpcyBub3Qg
Y2FsbGVkIHdoZW4gcnVubmluZw0KPiBpbiBhIFZNIHNpbmNlIGl0IGRvZXMgbm90IGhhdmUgYSBt
ZWFuaW5nIGluIHRoaXMgY29udGV4dCAobWljcm9jb2RlDQo+IHVwZGF0ZXMgYXBwbGljYXRpb24g
aXMgbGltaXRlZCB0byB0aGUgaG9zdCBPUykgYW5kIHdpbGwgY3JlYXRlDQo+IHVubmVjZXNzYXJ5
IGxvYWQuDQo+IA0KPiBUaGlzIHBhdGNoIGlzIGJhc2VkIG9uIHByZXZpb3VzIHN1Ym1pc2lvbiBi
eSBDYXRoeSBaaGFuZw0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMjA1MjAxMDM5
MDQuMTIxNi0xLWNhdGh5LnpoYW5nQGludGVsLmNvbS8NCg0KV2hlbiBKYXJra28gc3VnZ2VzdGVk
IHRvIHVzZSAiTGluayIgaGVyZToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9aOTgz
WmFUYVdOcUZVcFlTQGtlcm5lbC5vcmcvDQoNCkkgdGhpbmsgaGUgbWVhbnQgc29tZXRoaW5nIGxp
a2UgYmVsb3c6DQoNClRoaXMgcGF0Y2ggaXMgYmFzZWQgb24gLi4uIFsxXQ0KDQpMaW5rOiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMjA1MjAxMDM5MDQuMTIxNi0xLWNhdGh5LnpoYW5n
QGludGVsLmNvbS8NClsxXQ0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBFbGVuYSBSZXNoZXRvdmEg
PGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9h
c20vc2d4LmggICAgICB8IDQxICsrKysrKysrKysrLS0tLS0tDQo+ICBhcmNoL3g4Ni9rZXJuZWwv
Y3B1L3NneC9lbmNscy5oIHwgIDYgKysrDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWlu
LmMgIHwgODIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+ICBhcmNoL3g4Ni9r
ZXJuZWwvY3B1L3NneC9zZ3guaCAgIHwgIDEgKw0KPiAgNCBmaWxlcyBjaGFuZ2VkLCAxMTQgaW5z
ZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
aW5jbHVkZS9hc20vc2d4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zZ3guaA0KPiBpbmRleCA2
YTAwNjk3NjE1MDguLjVjYWY1YzMxZWJjNiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20vc2d4LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vc2d4LmgNCj4gQEAgLTI2
LDIzICsyNiwyNiBAQA0KPiAgI2RlZmluZSBTR1hfQ1BVSURfRVBDX1NFQ1RJT04JMHgxDQo+ICAv
KiBUaGUgYml0bWFzayBmb3IgdGhlIEVQQyBzZWN0aW9uIHR5cGUuICovDQo+ICAjZGVmaW5lIFNH
WF9DUFVJRF9FUENfTUFTSwlHRU5NQVNLKDMsIDApDQo+ICsvKiBFVVBEQVRFU1ZOIHByZXNlbmNl
IGluZGljYXRpb24gKi8NCj4gKyNkZWZpbmUgU0dYX0NQVUlEX0VVUERBVEVTVk4JQklUKDEwKQ0K
DQpJIGFtIG5vdCBzdXJlIHdoZXRoZXIgdGhpcyBzaG91bGQgYmUgYSBuZXcgWDg2X0ZFQVRVUkUg
Yml0LCBqdXN0IGxpa2Ugb3RoZXIgU0dYDQpiaXRzOg0KDQogIFg4Nl9GRUFUVVJFX1NHWDENCiAg
WDg2X0ZFQVRVUkVfU0dYMg0KICBYODZfRkVBVFVSRV9TR1hfRURFQ0NTU0ENCg0KLi4gcmVwb3J0
ZWQgaW4gQ1BVSUQuMHgxMi4weDA6RUFYLg0KDQpCdXQgdGhpcyBpcyBuZXZlciBnb2luZyB0byBi
ZSBleHBvc2VkIHRvIFZNcywgaS5lLiwgS1ZNIHNob3VsZCBuZXZlciBuZWVkIHRvIHVzZQ0KaXQs
IHNvIHBlcmhhcHMgZmluZSB0byBqdXN0IHB1dCBpdCBoZXJlLg0KDQpbLi4uXQ0KDQoNCj4gIA0K
PiArLyogVGhpcyBsb2NrIGlzIGhlbGQgdG8gcHJldmVudCBuZXcgRVBDIHBhZ2VzIGZyb20gYmVp
bmcgY3JlYXRlZA0KPiArICogZHVyaW5nIHRoZSBleGVjdXRpb24gb2YgRU5DTFNbRVVQREFURVNW
Tl0uDQo+ICsgKi8NCg0KLyoNCiAqIFRoaXMgbG9jayAuLi4NCiAqIC4uLg0KICovDQoNCj4gK3N0
YXRpYyBERUZJTkVfU1BJTkxPQ0soc2d4X2VwY19ldXBkYXRlc3ZuX2xvY2spOw0KPiArDQo+ICBz
dGF0aWMgYXRvbWljX2xvbmdfdCBzZ3hfbnJfdXNlZF9wYWdlcyA9IEFUT01JQ19MT05HX0lOSVQo
MCk7DQo+ICBzdGF0aWMgdW5zaWduZWQgbG9uZyBzZ3hfbnJfdG90YWxfcGFnZXM7DQo+ICANCj4g
QEAgLTQ0NCw2ICs0NDksNyBAQCBzdGF0aWMgc3RydWN0IHNneF9lcGNfcGFnZSAqX19zZ3hfYWxs
b2NfZXBjX3BhZ2VfZnJvbV9ub2RlKGludCBuaWQpDQo+ICB7DQo+ICAJc3RydWN0IHNneF9udW1h
X25vZGUgKm5vZGUgPSAmc2d4X251bWFfbm9kZXNbbmlkXTsNCj4gIAlzdHJ1Y3Qgc2d4X2VwY19w
YWdlICpwYWdlID0gTlVMTDsNCj4gKwlib29sIHJldDsNCj4gIA0KPiAgCXNwaW5fbG9jaygmbm9k
ZS0+bG9jayk7DQo+ICANCj4gQEAgLTQ1MiwxMiArNDU4LDMzIEBAIHN0YXRpYyBzdHJ1Y3Qgc2d4
X2VwY19wYWdlICpfX3NneF9hbGxvY19lcGNfcGFnZV9mcm9tX25vZGUoaW50IG5pZCkNCj4gIAkJ
cmV0dXJuIE5VTEw7DQo+ICAJfQ0KPiAgDQo+ICsJaWYgKCFhdG9taWNfbG9uZ19pbmNfbm90X3pl
cm8oJnNneF9ucl91c2VkX3BhZ2VzKSkgew0KPiArCQlzcGluX2xvY2soJnNneF9lcGNfZXVwZGF0
ZXN2bl9sb2NrKTsNCj4gKwkJLyoNCj4gKwkJICogT25seSBjYWxsIHNneF91cGRhdGVzdm4oKSBv
bmNlIHRoZSBmaXJzdCBlbmNsYXZlJ3MNCj4gKwkJICogcGFnZSBpcyBhbGxvY2F0ZWQgZnJvbSBF
UEMNCj4gKwkJICovDQoNClRoZSBWTXMgY2FuIHByZS1wb3B1bGF0ZSBFUEMgdy9vIGhhdmluZyBh
bnkgZW5jbGF2ZSBiZWluZyBjcmVhdGVkIGluc2lkZS4gIEhvdw0KYWJvdXQganVzdDoNCg0KCQkv
Kg0KCQkgKiBNYWtlIHN1cmUgU1ZOIGlzIHVwLXRvLWRhdGUgYmVmb3JlIGFueSBFUEMgcGFnZSBp
cw0KCQkgKiBhbGxvY2F0ZWQgZm9yIGFueSBlbmNsYXZlLg0KCQkgKi8NCg0KPiArCQlpZiAoYXRv
bWljX2xvbmdfcmVhZCgmc2d4X25yX3VzZWRfcGFnZXMpID09IDApIHsNCj4gKwkJCXJldCA9IHNn
eF91cGRhdGVzdm4oKTsNCj4gKwkJCWlmICghcmV0KSB7DQo+ICsJCQkJLyoNCj4gKwkJCQkgKiBz
Z3hfdXBkYXRlc3ZuKCkgcmV0dXJuZWQgdW5rbm93biBlcnJvciwgc210aA0KPiArCQkJCSAqIG11
c3QgYmUgYnJva2VuLCBkbyBub3QgYWxsb2NhdGUgYSBwYWdlIGZyb20gRVBDDQo+ICsJCQkJICov
DQoNClN0cmljdGx5IHNwZWFraW5nLCBzZ3hfdXBkYXRlc3ZuKCkgcmV0dXJucyB0cnVlIG9yIGZh
bHNlLCBidXQgbm90ICJ1bmtub3duDQplcnJvciIuDQoNClJlYWRpbmcgYmVsb3csIGl0IGNvdWxk
IGFsc28gZmFpbCBkdWUgdG8gcnVubmluZyBvdXQgb2YgZW50cm9weSwgd2hpY2ggaXMgc3RpbGwN
CmxlZ2FsbHkgcG9zc2libGUgdG8gaGFwcGVuIElNSE8uDQoNCk1heWJlIGp1c3Q6DQoJCQkJLyoN
CgkJCQkgKiBVcGRhdGluZyBTVk4gZmFpbGVkLiAgU0dYIG1pZ2h0IGJlIGJyb2tlbiwNCgkJCQkg
KiBvciBydW5uaW5nIG91dCBvZiBlbnRyb3B5IGhhcHBlbmVkLiAgRG8gbm90DQoJCQkJICogYWxs
b2NhdGUgRVBDIHBhZ2Ugc2luY2UgaXQgaXMgbm90IHNhZmUgdG8NCnVzZQ0KCQkJCSAqIFNHWCBh
bnltb3JlIGlmIGl0IHdhcyB0aGUgZm9ybWVyLiAgSWYgaXQgd2FzDQoJCQkJICogZHVlIHRvIHJ1
bm5pbmcgb3V0IG9mIGVudHJvcHksIHRoZSBmdXJ0aGVyDQoJCQkJICogY2FsbCBvZiBFUEMgYWxs
b2NhdGlvbiB3aWxsIHRyeQ0KCQkJCSAqIHNneF91cGRhdGVzdm4oKSBhZ2Fpbi4NCgkJCQkgKi8N
Cg0KPiArCQkJCXNwaW5fdW5sb2NrKCZzZ3hfZXBjX2V1cGRhdGVzdm5fbG9jayk7DQo+ICsJCQkJ
c3Bpbl91bmxvY2soJm5vZGUtPmxvY2spOw0KPiArCQkJCXJldHVybiBOVUxMOw0KPiArCQkJfQ0K
PiArCQl9DQo+ICsJCWF0b21pY19sb25nX2luYygmc2d4X25yX3VzZWRfcGFnZXMpOw0KPiArCQlz
cGluX3VubG9jaygmc2d4X2VwY19ldXBkYXRlc3ZuX2xvY2spOw0KPiArCX0NCj4gKw0KPiAgCXBh
Z2UgPSBsaXN0X2ZpcnN0X2VudHJ5KCZub2RlLT5mcmVlX3BhZ2VfbGlzdCwgc3RydWN0IHNneF9l
cGNfcGFnZSwgbGlzdCk7DQo+ICAJbGlzdF9kZWxfaW5pdCgmcGFnZS0+bGlzdCk7DQo+ICAJcGFn
ZS0+ZmxhZ3MgPSAwOw0KPiAgDQo+ICAJc3Bpbl91bmxvY2soJm5vZGUtPmxvY2spOw0KPiAtCWF0
b21pY19sb25nX2luYygmc2d4X25yX3VzZWRfcGFnZXMpOw0KPiAgDQo+ICAJcmV0dXJuIHBhZ2U7
DQo+ICB9DQo+IEBAIC05NzAsMyArOTk3LDU2IEBAIHN0YXRpYyBpbnQgX19pbml0IHNneF9pbml0
KHZvaWQpDQo+ICB9DQo+ICANCj4gIGRldmljZV9pbml0Y2FsbChzZ3hfaW5pdCk7DQo+ICsNCj4g
Ky8qKg0KPiArICogc2d4X3VwZGF0ZXN2bigpIC0gSXNzdWUgRU5DTFNbRVVQREFURVNWTl0NCj4g
KyAqIElmIEVQQyBpcyByZWFkeSwgdGhpcyBpbnN0cnVjdGlvbiB3aWxsIHVwZGF0ZSBDUFVTVk4g
dG8gdGhlIGN1cnJlbnRseQ0KDQpOb3Qgc3VyZSBob3cgdG8gaW50ZXJwcmV0ICJFUEMgaXMgcmVh
ZHkiLiAgQXNzdW1lIGl0IG1lYW5zICJFUEMgaXMgZW1wdHkiLCBpbg0Kd2hpY2ggY2FzZSBzaG91
bGQgd2UganVzdCBzYXkgc28/DQoNCkl0IGlzIGNvbnNpc3RlbnQgd2l0aCB3aGF0IHNhaWQgaW4g
dGhlIGNoYW5nZWxvZyBhbnl3YXkuDQoNCj4gKyAqIGxvYWRlZCBtaWNyb2NvZGUgdXBkYXRlIFNW
TiBhbmQgZ2VuZXJhdGUgbmV3IGNyeXB0b2dyYXBoaWMgYXNzZXRzLg0KPiArICoNCj4gKyAqIFJl
dHVybjoNCj4gKyAqIFRydWU6IHN1Y2Nlc3Mgb3IgRVVQREFURVNWTiBjYW4gYmUgc2FmZWx5IHJl
dHJpZWQgbmV4dCB0aW1lDQo+ICsgKiBGYWxzZTogVW5leHBlY3RlZCBlcnJvciBvY2N1cnJlZA0K
DQpIbW0uLiBJSVVDIGl0IGNvdWxkIGZhaWwgd2l0aCBydW5uaW5nIG91dCBvZiBlbnRyb3B5IGJ1
dCB0aGlzIGlzIHN0aWxsIGxlZ2FsbHkNCnBvc3NpYmxlIHRvIGhhcHBlbi4gIEFuZCBpdCBpcyBz
YWZlIHRvIHJldHJ5Lg0KDQo+ICsgKi8NCj4gK2Jvb2wgc2d4X3VwZGF0ZXN2bih2b2lkKQ0KPiAr
ew0KPiArCWludCByZXRyeSA9IDEwOw0KDQoiMTAiIGlzIGEgYml0IG91dCBvZiBibHVlLg0KDQpX
ZSBjYW4gdXNlIFJEUkFORF9SRVRSWV9MT09QUyBpbiA8YXNtL2FyY2hyYW5kb20uaD4gaW5zdGVh
ZDoNCg0KICAjZGVmaW5lIFJEUkFORF9SRVRSWV9MT09QUyAgICAgIDEwDQoNCj4gKwlpbnQgcmV0
Ow0KPiArDQo+ICsJbG9ja2RlcF9hc3NlcnRfaGVsZCgmc2d4X2VwY19ldXBkYXRlc3ZuX2xvY2sp
Ow0KPiArDQo+ICsJaWYgKCEoY3B1aWRfZWF4KFNHWF9DUFVJRCkgJiBTR1hfQ1BVSURfRVVQREFU
RVNWTikpDQo+ICsJCXJldHVybiB0cnVlOw0KPiArDQo+ICsJLyoNCj4gKwkgKiBEbyBub3QgZXhl
Y3V0ZSBFTkNMU1tFVVBEQVRFU1ZOXSBpZiBydW5uaW5nIGluIGEgVk0gc2luY2UNCj4gKwkgKiBt
aWNyb2NvZGUgdXBkYXRlcyBhcmUgb25seSBtZWFuaW5nZnVsIHRvIGJlIGFwcGxpZWQgb24gdGhl
IGhvc3QuDQo+ICsJICovDQo+ICsJaWYgKGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9IWVBFUlZJ
U09SKSkNCj4gKwkJcmV0dXJuIHRydWU7DQo+ICsNCj4gKwlkbyB7DQo+ICsJCXJldCA9IF9fZXVw
ZGF0ZXN2bigpOw0KPiArCQlpZiAocmV0ICE9IFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSkNCj4g
KwkJCWJyZWFrOw0KPiArDQoNClRoZSBibGFuayBsaW5lIGhlcmUgaXMgbm90IG5lZWRlZC4NCg0K
PiArCX0gd2hpbGUgKC0tcmV0cnkpOw0KPiArDQo+ICsJc3dpdGNoIChyZXQpIHsNCj4gKwljYXNl
IDA6DQo+ICsJCXByX2luZm8oIkVVUERBVEVTVk46IHN1Y2Nlc3NcbiIpOw0KPiArCQlicmVhazsN
Cj4gKwljYXNlIFNHWF9FUENfTk9UX1JFQURZOg0KPiArCWNhc2UgU0dYX0lOU1VGRklDSUVOVF9F
TlRST1BZOg0KPiArCWNhc2UgU0dYX0VQQ19QQUdFX0NPTkZMSUNUOg0KPiArCQlFTkNMU19XQVJO
KHJldCwgIkVVUERBVEVTVk4iKTsNCj4gKwkJYnJlYWs7DQoNCkkgZG9uJ3QgdGhpbmsgd2Ugc2hv
dWxkIHVzZSBFTkNMU19XQVJOKCkgZm9yIFNHWF9JTlNVRkZJQ0lFTlRfRU5UUk9QWSwgc2luY2UN
CklJVUMgaXQgaXMgc3RpbGwgbGVnYWxseSBwb3NzaWJsZSB0byBoYXBwZW4gYWZ0ZXIgdGhlIGFi
b3ZlIHJldHJ5Lg0KDQpBbHNvLCBpdCBkb2Vzbid0IHNlZW0gU0dYX0VQQ19OT1RfUkVBRFkgYW5k
IFNHWF9FUENfUEFHRV9DT05GTElDVCBhcmUgbmVlZGVkDQpzaW5jZSBJSVVDIHRoZSBvbmx5IHBv
c3NpYmxlIGVycm9yIGlzIG91dCBvZiBlbnRyb3B5Lg0KDQo+ICsJY2FzZSBTR1hfTk9fVVBEQVRF
Og0KPiArCQlicmVhazsNCj4gKwlkZWZhdWx0Og0KPiArCQlFTkNMU19XQVJOKHJldCwgIkVVUERB
VEVTVk4iKTsNCj4gKwkJcmV0dXJuIGZhbHNlOw0KPiArCX0NCj4gKw0KPiArCXJldHVybiB0cnVl
Ow0KPiArDQoNClBsZWFzZSByZW1vdmUgdGhpcyBibGFuayBsaW5lLg0KDQo+ICt9DQo+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9zZ3guaCBiL2FyY2gveDg2L2tlcm5lbC9j
cHUvc2d4L3NneC5oDQo+IGluZGV4IGQyZGFkMjEyNTlhOC4uZDdkNjMxYzk3M2QwIDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9zZ3guaA0KPiArKysgYi9hcmNoL3g4Ni9r
ZXJuZWwvY3B1L3NneC9zZ3guaA0KPiBAQCAtMTAzLDUgKzEwMyw2IEBAIHN0YXRpYyBpbmxpbmUg
aW50IF9faW5pdCBzZ3hfdmVwY19pbml0KHZvaWQpDQo+ICAjZW5kaWYNCj4gIA0KPiAgdm9pZCBz
Z3hfdXBkYXRlX2xlcHVia2V5aGFzaCh1NjQgKmxlcHVia2V5aGFzaCk7DQo+ICtib29sIHNneF91
cGRhdGVzdm4odm9pZCk7DQoNClNlZW1zIHNneF91cGRhdGVzdm4oKSBpcyBvbmx5IGNhbGxlZCBi
eSBfX3NneF9hbGxvY19lcGNfcGFnZV9mcm9tX25vZGUoKS4gIENhbg0KaXQgYmUgbWFkZSBzdGF0
aWM/DQoNCg==
