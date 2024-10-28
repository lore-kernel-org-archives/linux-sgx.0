Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39291DE2CC;
	Mon, 28 Oct 2024 22:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730155886; cv=fail; b=Hs4+yFxXpeFC7B30C2e2ExPBnb0D4mmxmSxkozFe4kneZ3390Ozjokgcfbrq//GzLNXv3uxJe+tE+42XkGtqQ2lHInPtATaUsJBTWUonmImQ7yb2Zzua1bEhJqkdy25d++AopAs6xT6QarsCH23hwUctQwDtcUHrCljhn5jmmRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730155886; c=relaxed/simple;
	bh=/ggYRVPtw0v1QdYZI81QTlC2iIA+aqo0OASE5rLs0rE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AZ6FRr4wipL8Mxh1fSKF2hFVPHlzDWJO8Nd4GX65ju0TXTy/BjGRxZNfafP3G53jLpVWcKISQgIxEDWj9Tx4c9MFa4ROLl+s8imp1A4UW5lVId7Lob+aayGQ+Yk32bg3+r6ORUEDzxFAUT91l9l3Ni39qCWDC+m0G/bo3jGw/WQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZoEBSrCn; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZoEBSrCn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730155885; x=1761691885;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/ggYRVPtw0v1QdYZI81QTlC2iIA+aqo0OASE5rLs0rE=;
  b=ZoEBSrCnAtKRC7/mQZYOxtQK1LOx36a+tOHRujciwi8Xii2sE3JC4U/d
   iEo6ZTDLlNNDh4NuDpM+BPYb+BfFxXVFdVR/X7s06p6xekX7NB3CJGEvf
   RQN1RU8iVggr5LJCXPrjz8eUWEVVk/i0jHkiq/XItVWX4x/PQpOjejb92
   njUPfsRTRsYu/BC2Dp2p9Qf5hC2m1HmkNFjQJPaFcmq5l0pUgUCTAtoNx
   QUWlozCykIN/vkzh1Yo+YNm50Y/rcQpiA9cH8TOYgjZc3qAReU0AZ/Wr+
   fhs/t2Wq1uYz/4+sqhm825sqx5OCVhkVnuLrfHnLsww0xQdANu07o3jFq
   g==;
X-CSE-ConnectionGUID: FgFmNmGaSSKsEBuOqgIIJw==
X-CSE-MsgGUID: y0HX13eUS2abzpSg0DDIcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="29888159"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="29888159"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 15:51:24 -0700
X-CSE-ConnectionGUID: paSfy9gVQcu35xCsJOCMiA==
X-CSE-MsgGUID: ASP1imSySWGsaR6onVGBNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="86368663"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 15:51:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 15:51:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 15:51:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 15:51:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbeQQm90s9Q+WZB2VxxRu2SpCtuiuSgcuIPV6P1yjawmx4qxhK4qVMatWKLhVcr3f6EXG1LOLJuY8G3+a8yYmCgiJuq5Jnsz/G40NMjEW7GmbojZPR9+2KKW+ebWNniMFxQwS3QU3ODLEJZz9rHugj8USoINozHNVQPE8hGBvBYHNavdbT5O8WABDkMeLpVDdaRq88DtZo6b/tlt5g3tIr/KVSz7sAFXczB+05NRxE1CMIvNSSjkn8q7RM5n4KeUrdOdpW53AAwaftHmf+ISsVCp5KLonmtXDbasrHCbXK4cIwiJuhOV+GmUgDKwpw8VYwblnyMewGWA23DfHi0b6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+N1wJdS1Dv+5CMLTiYzi4J1kNIrwI1+/o1BMhCP/oM=;
 b=ITPIhHeEgspkjkXe9CAtP9xKGG3FoVndptkw9xfasY4lynm3zYtr3DN/CV7iAP64Ke6MvxCa/AxQbwHW4CQttg5dvfBa1aYPrOex76UVXtDLtkcChm9DdSoeFbWp8wjWoj55lE8louMPbw7crDnFqbUOyZMFOx0F9ac1ZHeHIZm7yc9gU+Zzxf1z2bD7tPryu0Z8D9KFwxBNBDBwmYq7Zs3bjyQcu9Of4mr4yINa20pLbgX9EwIx2WeasIYBp31ffqbyZGmucYG/4TJN5PvZB2Q0mQhCKJvH+WKQZfNsabBfn+xJdNuRavh/tc8ZqUWH/ZfqGxbV0WBQ26yBD4owxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by CYYPR11MB8358.namprd11.prod.outlook.com (2603:10b6:930:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 22:51:21 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8093.021; Mon, 28 Oct 2024
 22:51:21 +0000
Message-ID: <fbbca51f-267c-496e-b30d-6075ac684097@intel.com>
Date: Tue, 29 Oct 2024 11:51:15 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] x86/sgx: Use vmalloc_array() instead of vmalloc()
To: Thorsten Blum <thorsten.blum@linux.dev>
CC: Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, <linux-sgx@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20241026113248.129659-1-thorsten.blum@linux.dev>
 <cd663aa6-28a1-4c03-9258-511285316c0f@intel.com>
 <393CAEF9-A79E-4399-B0F2-FA3BCAD46290@linux.dev>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <393CAEF9-A79E-4399-B0F2-FA3BCAD46290@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To PH7PR11MB5983.namprd11.prod.outlook.com
 (2603:10b6:510:1e2::13)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5983:EE_|CYYPR11MB8358:EE_
X-MS-Office365-Filtering-Correlation-Id: 11ccfe3c-077b-4de4-9f98-08dcf7a30ab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WU5ZanVPYkVKNTVMemhkZTZaMWthZDN4NXBGWHcxQ2FQZDJILzB3bCs1NFpZ?=
 =?utf-8?B?RW9xVldMMEFxays2Uk9UQmlFQXNaazN1OW13YjQ4TENxUDdlK0VFVzQ5Vmg0?=
 =?utf-8?B?NUM5YW9aS3Zud002Sk5pQUZSQUNlNGRzUWxXMXZCOGFzampneVVhTW1vcURv?=
 =?utf-8?B?aXRpaHpQZ2plOVZrakI4eTY1b2pwa1R1TnZOeXJXNmVPTzFMcS85NjNaUDdw?=
 =?utf-8?B?T2IwMlhjTTNRUlgwbHpKRzdSTnFaMGRueXVMZWxIZ3hRNk5ja1VEVHBMZTdS?=
 =?utf-8?B?MHBGcEJhWkJnMWZRdFEwRzBjREJMVVRLL0pNVWtVZlpSK2c2Vjd0M29FU3k5?=
 =?utf-8?B?aVpQUjRqRUhxNHdHbTZBNXNza3hTOFdpQjluK2FvQW0zeXh6VjV6d3lEWjZ4?=
 =?utf-8?B?VStYb05nem01UGxSQ3ExMWhBT0JobWNkYjYrSEplTllWYTdjYWFYMSs0YmdR?=
 =?utf-8?B?NlRDRmxSSHFMaU9URVNBdTVHZWQvUXBpbDlieHptMEpMN2Q5K2t0Qy9nWHd5?=
 =?utf-8?B?MjhINjArWTJwSFBmWTI2Z2JnQit2TzUxUFlNVWd6eFJLd2M4SFI0Z0RLcHNR?=
 =?utf-8?B?U1ZBYk0xSEdpOEcwU0E3empXVXRJc2RGTFZ3S0txaTVnRDRQdUhtY0VKSE5t?=
 =?utf-8?B?d3ZNbEQ5THI2bzFnbGdWMjd0cE5aYjFXajlOQk16cVF5bTYrTlNWZnVFSUpG?=
 =?utf-8?B?OU1lckpvc2lTSFdHa2J1V3M4eGpzUTg3TWFzeGZ1RWhpd3BReTJiMFM1K0RP?=
 =?utf-8?B?a2hIamhIU3ZqT2xLbm5yZmVwVjRraENZVU4wVUt5N1lqamVDbW03RmlVdzZG?=
 =?utf-8?B?VFZtcVpCUVFINlVaMnhIY0RxQzJZRVIrMDVROGlTT3Z3U3FkbkJmdGw2c3J0?=
 =?utf-8?B?NDQvVGU0TVRGY2N1Zi91RytEL25OamVTMDF2Y1duQkg4bkxXVlVlakE4cWQ2?=
 =?utf-8?B?eWJ2TWk3V3U1b0kyM2Nvb2Z0QXVSYVRNTFdYNFJjbkJGVlhydGhkcm11ZHFS?=
 =?utf-8?B?UVdNZUxiSzVHbTQ5N0daeHA2RnU5M2Q4MmZuSjdpaE9IUWM1TXFTSkxsaVBH?=
 =?utf-8?B?aFJ5bXdlaWh1a0xwSDFzUEJacVJYRktTM2dBV2JzSERVbFVSOFRDc1N4V0di?=
 =?utf-8?B?em1CWEdRSlJIZFlqYTlWeVA0WEY1b0x1ZXRHclZXZ0hyWERkbWRYelhYTWhs?=
 =?utf-8?B?NDR0QXpzUHpDdUIxeVgxK1BxRThKRE9MbnY2UmtqdjIxeERJWXUyVUJLT29B?=
 =?utf-8?B?ZzhFeG1UMHpTdTJLdUx1OU92U3h2RmR0c0wveVBUN1BpVTVWQlFlRFdQZUFG?=
 =?utf-8?B?ZDQvY3RWL3d6RjNmejFQZmszQ1VGV3A2U3BRK1p0VTl4NjBVNVo0YWN4YW1T?=
 =?utf-8?B?WTRBU2hvZDhpNUNrSEhNUkx3WldZMTI3eHQxYlBZVGVSWkpxejJMRDA1SHZh?=
 =?utf-8?B?b3k3SVIyQ1B3TjBrQVhsWXI3VHkxZHdjUWZkZEdtUlplYUV0VThrNWlpNC8z?=
 =?utf-8?B?dXF1SzNkU29NSUluckkyaE9OenN5cmRPYWNIdHZUM2FMTXhBWlJPTXVVeXk0?=
 =?utf-8?B?a21Wemh4Wmh4blRodCtlc2FPS0dYalhpWjZRZEJOQlZhdHR6QjRBaHFuZXR2?=
 =?utf-8?B?WGVwY0ltUnAvY0NEWXZrbm9tOGxzVUhoUWx0a3FyczMzVTFYMEdqc0xSQTJO?=
 =?utf-8?B?NTFZWEttVzlDTE5QNi9UaHNUNVRIVC9xcWVrZ1hoRFFTTFZYUmZzZnN3bmMz?=
 =?utf-8?Q?fkSXSQKEkdp/BjZm6ZU7NX4EN1+B+/4D33ncAUf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnAvZTRaclZDQXErSVo3OEdiU1dCcDVEQzBlMGgyTG9oRzZLM08vVjFvMVZ1?=
 =?utf-8?B?N1Y2RVk3YjZLTVJRVGRoMFNHRDFuRDZuTUE5SUV3N3dBV0VZbTArbndlMXZI?=
 =?utf-8?B?aVM1OXQ4bngrekR2V2t3ZGhsWkIzQ2FUN3J3bmxuTy9Bcm1jZDBsMDJYT2xG?=
 =?utf-8?B?NllhellTaUVWb3VEcUJmRHNMSDliNEF4QzlOTTl1Y2lhTDlaSTNPQVpid25v?=
 =?utf-8?B?dDZDWkpQbWE0YVphTWdsMjlNQ3U2ZXkzNTBZWWRBTkx4MGU1ODgwM3dJeWtO?=
 =?utf-8?B?aGVMUGRQeWhJdFh2UW9ZL3dYRFZ4ZHU3KzREYTNjWXBiZzl4dGQxeDBvdzdQ?=
 =?utf-8?B?c2FnVXhpeUFKNFNLU3N3eDFDb0VScEkxdTZVbmdpbENIcWV3MWNUTjkrWGcz?=
 =?utf-8?B?dlFXUENqU0hMQ2VIQjlCay9kZkVlZnB4QitJdEVUZUY0V3RCZHpSVzRtQWY0?=
 =?utf-8?B?L2UyVXJVdy9QaHpxSHNtSU80dmRDQzBONzlhYkM4SW8vWDJCRjUvdlNvSnZa?=
 =?utf-8?B?R05hU2RGSURUODU3UkNqeXgrZ3ZtbUtpSWdVSDRML1RaWnd0RUVnNTZsc0E1?=
 =?utf-8?B?dzl6WUFSeWVwbWg3RmViaXk1eDFVS2h4bEhVRCtWWkZ3ckh0NHV4ckNUTVcz?=
 =?utf-8?B?cG9zOVVvL0NLU0dCUjNQVmttMmM5ak9PQVFGRFp2OHpYTVdXOUJYSm44NzBj?=
 =?utf-8?B?NzBhSkh5dWsxTEhuQzNmNzVBbGN5dTMrN0h6Q1BLVVMrRHNNZkFCQWdmUEhP?=
 =?utf-8?B?UUw4UGg2Y09NYUtaZ05Gc3lxWGl1SzZrNUpyODU5L1U5MUJOb2Q0NDA4TDJk?=
 =?utf-8?B?V1BoUmFqN2E5K0ZNY3dXdGZJZE5tdHRhM1NpbGg4TDcxbWEwckJPM2JxTks4?=
 =?utf-8?B?U2QyS0FrZ0lyRktYakdnOGtyaGhuTUxRRGg4WjRncGdsZ0FsUk04dXNOTXZm?=
 =?utf-8?B?YWlLd0NJU3NWbVZqemFMSlRBTGsvZGlVS0J0d2VGWHQyOWdQb3p0RmF1UjZn?=
 =?utf-8?B?cWxWMGpyamZpWjRhZ2k1T1lVMUlpc0ZXclNGamZKc1hvUHQxR0V0L3VaUkEy?=
 =?utf-8?B?RW5hQ1JpOWYwaXgyWjR0M3pRWXZUZGhoYldQZFZRZDZaWHErNHBTWnJsTk5O?=
 =?utf-8?B?MjVSVHViRlBzazRBVnFUL0hIRnlJZkJRdG1yenNVcFVsUVVxbXh1NWhsVVhp?=
 =?utf-8?B?Y2VoVHc0SXBVVFM1MEtwZVRyWDRJTGVuZVJXbEt0c0dheE0xbVNSZ0g1QjZj?=
 =?utf-8?B?Y2hDZHNGK2xwdk1DMkZ0cSs1ckJucERyS2hQbDM4V1hxcEtISHUzMFNDZnlQ?=
 =?utf-8?B?UlJsN0hZWjhmTGhkbW42bmtFdWdzcXViaTJiTHo0Ykt5dE53ZGNMNGxhcGJ0?=
 =?utf-8?B?alFjakhjclhQNkpMM2hMV2Znc0F6ZXF4S3VLMmJZN1B3OHVmZ2Nod1hrOXNn?=
 =?utf-8?B?L0sxdTR6Q1EveFg5MGFXaG1RZVdaZEc0bmY5azgrNk9wUHN4ckM4NE11aUNk?=
 =?utf-8?B?RGlTTyswcU9Md2ZTZ0tBc25qSWpMREZyaVRiTXBGVGhDM0NXV0pkWWFsMDhD?=
 =?utf-8?B?bm1COVlhcXJEUDRTaFU1V0pGZ1ZQaHFZOVBnWnhQWk9ML0NTdTUvMmFoOWlr?=
 =?utf-8?B?ajRPZjF2QlU2SGFOL1M1OUJ2OUR5cnF2TEo2b0xXUDdaaHZ4MTFsN1JCY2RY?=
 =?utf-8?B?ZTU5OHFrNjFnRUtZc3MzK01IMzBkRURaYjBSMVdaUlllQ3JldEloZDczWG5R?=
 =?utf-8?B?MTdnRGYwbkwzTTk4QnhwcExSNW1PeGRjQ2QyaDMxcVZBaG5MalRHOFhPSjhH?=
 =?utf-8?B?eDJBMkhtSkV5MngvMzFUZEZwc2E3aFZhVW12VWxQcDh3RWNpQ05oVU4vb1Aw?=
 =?utf-8?B?T3cyK2NPWHdST0w5dlh5Y3ZMdUJpb3M4alZ4UjRoMUZjNG9TSmFsdEgveWJ4?=
 =?utf-8?B?bGhJUEVzaEdLM0pXdlQ5KzZpY1gyTHdKWFBuQ0paQktLT1lVamhEdHJZMXFO?=
 =?utf-8?B?ekdqR0wzcWNJK3N2dmhFWituUWNsNHg1NEowKzZ2QUNPK2VqcVUxWWZ0bzNV?=
 =?utf-8?B?TGMzWFBHdEduMDM3cU04M3ZlUUppRUUvUDd1NFlPQS9uTWlhLzN2ZmlkRktX?=
 =?utf-8?Q?1FFSlKEhkGvtifvlfbfiBN8l7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ccfe3c-077b-4de4-9f98-08dcf7a30ab1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 22:51:21.2463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XXPZHpn0lwSLf7VZJKpjqSSyyBK48z58Xo/6xOCllceB11jSUB+6pu+6aQREqWulLnq03jxtW6l0KHjwgQw4MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8358
X-OriginatorOrg: intel.com



On 29/10/2024 11:47 am, Thorsten Blum wrote:
> On 28. Oct 2024, at 23:29, Huang, Kai wrote:
>> On 27/10/2024 12:32 am, Thorsten Blum wrote:
>>> Use vmalloc_array() instead of vmalloc() to calculate the number of
>>> bytes to allocate.
>>
>> This says nothing about _why_.  Is it because we want to take advantage of the multiplication overflow check inside the vmalloc_array()?
>>
>> I don't know whether it is implied we should always use vmalloc_array() for array allocation like this, i.e., when we see vmalloc() is used for array allocation in the kernel we can just write a patch to replace it with vmalloc_array() and send to upstream.
> 
> It's discouraged to use open-coded arithmetic in allocator arguments:
> 
> https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Happy to add this, but I assumed it's obvious.

Thanks for the info.

