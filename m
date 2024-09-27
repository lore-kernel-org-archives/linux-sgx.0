Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F07166F07
	for <linux-sgx@vger.kernel.org>; Fri, 27 Sep 2024 17:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727458777; cv=fail; b=IyLyM0tBuLaMgtNBgyzc6vqMvskgkdGS2j0n3wxM8Us1GKTeHoF3pjVFdz5Fwy2fMU121b30XgqMyTdwuempWDisFIgu1ECSwfXLvHwPKFBax+xDsCcRAuiHWv4Df2HAnYnKjRupMVrWGtTZMiMcRAFFQSqxeVcGmtZg7kfKCKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727458777; c=relaxed/simple;
	bh=1tEVxDOxRN4jRGzoTjZ744FOxryimWqC69v6MElRprw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RoDaw/wkHqjI4b9fopjZSYsdPJ879a9xAz4ElFWXdUiw+ZClggRm6XWPBqnoLn/W+IvgyzHbOrtNP2TNq3TAjsRhJjEcIi6de8NF6mSmdSSmt02brQYAIsfKko3XWvBU9uNLKqE2aW2iiwgR3ff6rQ9iTPJnl/kT6GzO8Hx4ai4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y1by41t0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s+EBLOCH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y1by41t0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s+EBLOCH"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48RHMdD3016070;
	Fri, 27 Sep 2024 17:39:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=lssydRnsWiREBmk
	utgHfXsGuMkRKPcitkLgtAM4ghEQ=; b=Y1by41t0T7WaI6WrUy9wGTzCCWU1Pth
	VxsZeXXTLNR4JxFEgloBPbUP1zqsYbPY301EzrqKMCEaAG0JpDCeIkKMxkhvmXtz
	b4tHlFU9CxoBrDE6rUJmolRjB+p+63nyB7IlVdxuH4z73+3FjgzPc+sv7FMC7uq0
	TZZtq1unEnoYiYovvf3QZ7siBDvZVH1HkfqFVUxkvXTf2wrVKwyt9I6UZlXix4/a
	Omvq6DaBF3J8hVYgUEgeu8P5d2Vg1AuZSwaZbHgQiePRgAo+ACarA8bM2k4AGKRD
	iq3euaa13ascsPCcEN1cXm95R9bYUqzlgKHaHzMJgIKvRB7d2yxIFyA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sp6cnw95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Sep 2024 17:39:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48RGun2v030319;
	Fri, 27 Sep 2024 17:39:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smkdy47r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Sep 2024 17:39:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZYurDm1lLd4CFTehfnbbHO3Nc3iXLR2uUvtXteA6UlzvuHlDoqkjW6jiPBEAleQueFY+pBqyWKAbCuR+livZFDO62L2MIOJxXNLNpqVWzMLufP/6KiqJhD33elOfEdCjdfeljxycTx9Yr4J++f2JSHaX8nwCXDSBPbojhPltuwEbgrBL/XVopvAX9JwEn5DyVuXReMsikznTeFHFcstuJDRSB2EsjDLjWkKWBBmMkD0z7Lh0wgS0sITNRJGQRk21leTpsZbCTQhqPMx+pVE7NBBgb/qi3MxraSW4iJKK4O61Dz18ZHFZ9n0N3EdrZYULYE6ksm0YnqIMrtiaA/3QCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lssydRnsWiREBmkutgHfXsGuMkRKPcitkLgtAM4ghEQ=;
 b=thA2OEQloibcmif8rOkXMj4VUVUfXWS/Rk5EtyGV1Egage0QMIL1JqSZd4kduHAqVlW8amuUknc8EaT4pOZg526zl9KZOzcIs8qIHgzIWwtCayMzJwxMixkXHBJmFUI4L52WyAs4zH8po7Oiu/Zu+Jui/888+ftLQvREpB+cJsM2gA3IgjOf/xcuYwazmaJcA2y2Iy6WLRToh9oe/dT/giqlUz0m6Tp9UruSQE7Q5IZd6DTjZdp5HGtKPLuXFKYWWNPghLfOfu9dlVuXjRfokRse6S0Vhav277jgLFtNo3r/oFNZ3dWxvBhKpeZSZ+126ODMWIyk/FGZLHEBy7sfqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lssydRnsWiREBmkutgHfXsGuMkRKPcitkLgtAM4ghEQ=;
 b=s+EBLOCHTsfLTOARhgz2y02uA2qup339BvXKQZ7TASK00aXtfV6gcIipSn+eDB/yZCrSE5EKHUnv++jJallvT3NTqkbw5o/H7q67T7hqh6LhvK3NVAzYSfLZVdCXPOv0L8eQjrBq+03L2BqNG81S861zqCtD8DMAPeC6cLvsGrs=
Received: from SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5)
 by SJ0PR10MB5857.namprd10.prod.outlook.com (2603:10b6:a03:3ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.9; Fri, 27 Sep
 2024 17:39:12 +0000
Received: from SJ0PR10MB5613.namprd10.prod.outlook.com
 ([fe80::4239:cf6f:9caa:940e]) by SJ0PR10MB5613.namprd10.prod.outlook.com
 ([fe80::4239:cf6f:9caa:940e%5]) with mapi id 15.20.8026.009; Fri, 27 Sep 2024
 17:39:12 +0000
Date: Fri, 27 Sep 2024 18:39:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@iki.fi>, linux-sgx@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: VMA merging updateds?
Message-ID: <2ba91a26-71b6-4150-9d8d-d5517d316808@lucifer.local>
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi>
 <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
 <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
X-ClientProxiedBy: LO4P123CA0576.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::23) To SJ0PR10MB5613.namprd10.prod.outlook.com
 (2603:10b6:a03:3d0::5)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_|SJ0PR10MB5857:EE_
X-MS-Office365-Filtering-Correlation-Id: dbdaebc5-c4e8-4562-3981-08dcdf1b4c95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HhOZYD8BSBkNX57fYf1NP8D6SinQZ0LkR5XCtaG3V3Zcz8YGVtcz3FTIwP42?=
 =?us-ascii?Q?MH91OLGdii+AEF1xIIh6tjk5ITUyJx/nhFY0zwoByu4nm6riQ7DWkPfJ/2lS?=
 =?us-ascii?Q?Bgg2jmi+9aEmSUUe5hHF95PkJHLqCUKsC0J6yxx3xxcf7JZPuVYyR4VlfKnX?=
 =?us-ascii?Q?ileHWRwH9GD/Rq2swHz4k63UNt0eJ34iJh6NuZFhitvckipB2mjbb2GNlasJ?=
 =?us-ascii?Q?z6Ahdnz41ZNLk21cCXhMNAVvCqdR3e2QBTmIkgTx5bM7iWkx8W8zMjaYM7MV?=
 =?us-ascii?Q?BAtn3wDBZvycg8xderqceGurNtmi4no7Ci6VNH5aA1z4UKU9dj2UH5eqAFvy?=
 =?us-ascii?Q?Xhk5aIn07fGjnpuMd8/lWSjSWvcfFTAGqpalMTTd9FdecLlID14ogAFF+vG+?=
 =?us-ascii?Q?/KJs9VtFMn4HGp8QaMtF6FFeogl39B0RLxHzca3aDj2MK3oIKbshEV84Ym4B?=
 =?us-ascii?Q?gFxAndTtEINxR9dm5m6r42cEZC0m14ZrstEsCrkjAFRlMZyWmJszEKD6hrDq?=
 =?us-ascii?Q?j2z29vxXW+7f9T+hycEdATZPLGDGyRl90I0ot+uJN33AQYZaMt/KEw6eyWrF?=
 =?us-ascii?Q?XdU0VPLeaNMg7IyM0uv/xQk9mCJt4HicYSV5ZqS+MVDkOxYl51tRsk/VP4Zd?=
 =?us-ascii?Q?N9UUN8smmT9Ysc1Lkb5t7A9dj/9M0U86/1ziqXuVP1/rSTrvayl9MZ1BLUP9?=
 =?us-ascii?Q?EjTBr/O9//+eSH0/vXhnT+HtFp8ooSR6KzNcUdymuwhvt7y2ak8BNMO8TeY+?=
 =?us-ascii?Q?xWPLT9J5Wgw35Hht4hi51U1aMJdCdPGKBNp7G7wM8Pq1OUdS1dRU6wowbJPI?=
 =?us-ascii?Q?HaMdYSycJoG1h/l64c9B5cbXtY0nDJXaLAkX5wrc0mivNaaJzSKHxnabnUmf?=
 =?us-ascii?Q?WCqk4wb2nnS6UssemdkXyq5pZaLMKeHRHC2ZIuc0CWH7NbS1PeVDVLo7XnAT?=
 =?us-ascii?Q?P2O9S70Agexn+NIxJ+0rzCmFySlblTsGJqX9jwmXgRnw8GGDZcHEokA2IC5t?=
 =?us-ascii?Q?r5sIaTXAvpNwO6jK7WPMdjJ68dgHa5l3MUgTaedrLvte0eFWcPVsjxZTzp1C?=
 =?us-ascii?Q?i69MSesILEZFYuFVlsqqJEDv3X5vP43/BEWsGxux7mt7MSYymBWM3S2V7w6Z?=
 =?us-ascii?Q?wbG84pK8z2AqWpzvLQhuO4h7U5OVUHY0XSMVHwIKF+ZoFdRtTCnDXPz7hhuR?=
 =?us-ascii?Q?NsW137KTXRWU4kMgFr+gARbNClDOQ5mD0XzTevCARZFXuwKNAZJFJx+0zCG4?=
 =?us-ascii?Q?lKQP2qiqdOBVa2SyF06YhacqHCN0f0KfhH8qs3QOMNQInVrgGNlm8J7ll/MI?=
 =?us-ascii?Q?2dw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5613.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2A3X1ZRMxLCcFDFqMruVIwgbOoH13pyP0UK0aydHL9Pv75W3rhhYoUTwCWYe?=
 =?us-ascii?Q?D1RUi1F/NfcM32Zw3iYzF5Z8dBPqQnUmfh1yELZQkKIoQw22OwKtFVZDFs5T?=
 =?us-ascii?Q?wNsOtGcjVAPv5zw2/I1yhvcdTN31cz8LKA2BieLhWEcHS123RLIXPBV7s6hy?=
 =?us-ascii?Q?HU9SQBbLlQ+2oJPBpHeudoA//SHpLKq45JLhtCV+vUbMdCyhAc0VxRgtHZ+f?=
 =?us-ascii?Q?z55RYdH2XGu7F0vZvmv75tFfLWyjBQgqWGnu0DzjM83j+bIGe3gwYvpZD0I4?=
 =?us-ascii?Q?a2tHA9YjhkoHi4y6uHblM52OJeDllNze9AqIBSbk1V5bXYUjj351H2fNxade?=
 =?us-ascii?Q?q6VOkE9ei7ATjGN4IFoB9b7LQBBW3U53NoH0Jg8mlHpyG4Jg+JkAlVGGlqqN?=
 =?us-ascii?Q?85eWqtq2H/t76+nMLk9hFCSe0ZMUrtAqeXSrE/30K2SzLvGJgT0oga49DOvM?=
 =?us-ascii?Q?a/12o9jwexcS0b6WZ+5qbU3fnRbb8g7fQg5p4qnH1rg7Ul4G2EBWy6hw/OjL?=
 =?us-ascii?Q?UIVpuf9LJWSLe3YZKsE/56gt6S1lsb9UifikIJQ+gzxYfLRqa7/TQ5dRmj/f?=
 =?us-ascii?Q?O+3C3xImtjHwCGsbeHrle3XcgjUQQXGzZEIRg9rJrJU9ksczAyR76buGqijz?=
 =?us-ascii?Q?w/q9eQ+WsbbUclJaNC3hlv9fWazLqnqt1NFnymUXWnuLYR7YJfJsLrvnPWzr?=
 =?us-ascii?Q?MP3iP5H+XAj/DdD9WiqZ/ymCbKTD6oRlAjDy4QxB/1cBpwpoHnMP5JvKqvqN?=
 =?us-ascii?Q?IW73ecIBpZeppqp+osV4a1/oquKR9etyBQZbxqwHlzbxdiXr836ffgzAwjf+?=
 =?us-ascii?Q?zEW1baPWHRT8eVLbAZxOUhalPGcgUddP0pH5QEhkvPC7ATFTm+uqCoV7iM6C?=
 =?us-ascii?Q?8DSWVCLB8nUePz9eXu+qD0hzF4Trz8G88JwiMrl43Wf9/A61X6ICnoxbBdT8?=
 =?us-ascii?Q?aX8HyB+CgiNuBtHm7STCEjx7M+dhupgy+A/85MZnHlQf7g94waZYtIJbToHr?=
 =?us-ascii?Q?KlqTIwz2qwrOg7Cs1+5pQD2J/+/iIIo/SaDqawgmRM7MrhOEOwWV2b7R9G0Q?=
 =?us-ascii?Q?yAxoYrLYYzFEHJ64rjx3oVNCrTB5WQRenBlpvDRWBnnZhUDwR8T2kYAEmzgd?=
 =?us-ascii?Q?/Qm+//0HnvVG5GVYHJE90njcBpgXDXjELjul9mfJIplUSXVRf228/kSG1aPW?=
 =?us-ascii?Q?cdTxuazUH2cNFaiD78w2Ls7XIXlrangj2Wmy6Td2xTbN2aRlm29xEbc7iNKg?=
 =?us-ascii?Q?VuozAFmat0ce2x3SZFh3FlAe3ZDkw2l9zitjC9x4zwBzYb4vDrcd7hh+QApm?=
 =?us-ascii?Q?K/MyKglxv8hriF4blYATD6R2rOGRt1lvHc5HeX65UFUbp2K/W/yt7GMlV2cg?=
 =?us-ascii?Q?7ng8FoSk4gfFNbqqxCbZfPUVVzo/oxk5OpATMuW9rIHvPPEJBKEkw60msuhL?=
 =?us-ascii?Q?M77nve+uJmrhHWrnLjUUH4xI84aDShJKayQLIW4C68I1bYOuI1mPb6zBM/NO?=
 =?us-ascii?Q?DlMSaTJ2mAERL85qY7lodJBloncni/dTDIZWCNN5x0BG0cM3e+4KxxVJr0wm?=
 =?us-ascii?Q?rDS01mHtptTEe9FIHkobqrIDCVf+NT2G+B9W8vSdBOSgGQwIpRckD9MwkkC3?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l0FZsdO3jF9l2pfxkC0N8OTSPquFRwlz22c1nOkM5LgscIne2WCS2YvnAfPpvO5H9rIWe63RhnUvLK3RqAqaxrCSr/6inciIsvX8VfDruO7CbDuKpHpYEOF0pL3e1F4HpHOFlo1FDryKPj17sSCWXnUHUgF8I6aAJHVPflVzhgHxplOkmDFRob17MUzUs+EQjGqxAzp2uX7IFfDHDi2CgZl2OOqYlt9cS4uBfcFGxz0Yw1EaUcyVnGk8tKdwWo7YIrfxA/vqQRyi1hnsCuET+8/5FfVJbuVQ4R0EbU4sVBY4w/GQ6jnEXh8puk+oIl3FqDv/Oj3sMa3lj+qKBUqMTdENEz1xAaNdib2nqxI5M4rVf0+HQu/3ebrOFSHfHDQkfX3itfMqKFLiyuTF9uSWOX5enhEi7ED++jqlqQySSlLC4xhiB4Zv9cIAsz8bNJonMftDfbIU8Fzre2hcpyFOF2myHy0aK/Pa3v1jHHZmNt5UT6Fi640cjq9H7vEvaDYzZIXd26zkg6mic+dBtEYpqSHY5mqrkZeHsO97sOjXlvjucNdcTDERBpMmWGia0JXgKaReqYjB6j9ACdccoqjR9rPdD58wTzfBOXdwfMFRJyE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbdaebc5-c4e8-4562-3981-08dcdf1b4c95
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5613.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 17:39:12.4807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vr/AUJz5nnFxzonXQ8Ho9zXNUyNXIwBG0Ra4sxV/5lMaetMwIgpjjFIanSpOrQueE0sx42F1bb2+OArBQOVnZEpCh44Yg10o42bJ9pyllO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5857
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-27_06,2024-09-27_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409270128
X-Proofpoint-GUID: 0Ejl_0QZDrV_HEXYUexOAV4iB5KlKXhM
X-Proofpoint-ORIG-GUID: 0Ejl_0QZDrV_HEXYUexOAV4iB5KlKXhM

Jumping into this thread mid-way to give my point of view.

On Thu, Sep 26, 2024 at 12:07:02PM GMT, Huang, Kai wrote:
>
>
> On 23/09/2024 7:48 pm, Jarkko Sakkinen wrote:
> > On Sun Sep 22, 2024 at 7:57 PM EEST, Jarkko Sakkinen wrote:
> > > > On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
> > > > > Hi
> > > > >
> > > > > I started to look into this old issue with mm subsystem and SGX, i.e.
> > > > > can we make SGX VMA's to merge together?
> > > > >
> > > > > This demonstrates the problem pretty well:
> > > > >
> > > > > https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org/
> > > > >
> > > > > It was result of brk() syscall being applied a few times.
> > >
> > > Briging some context here. This can be fixed in the run-time by book
> > > keeping the ranges and doing unmapping/mapping. I guess this goes
> > > beyond what mm should support?

The reason you're seeing this is that the ranges are VM_PFNMAP (as well as
VM_IO, VM_DONTEXPAND) , which are part of the VM_SPECIAL bitmask and
therefore explicitly not permitted to merge.

VMA merging occurs not when VMAs are merely adjacent to one another, but
when they are adjacent to one another AND share the same attributes.

Obviously for most VMA attributes this is critically important - you can't
have a read-only range merge with a r/w range, it is the VMAs that are
telling us this, equally so if different files/non-adjacent
offsets/etc. etc.

For these 'special' mappings each individual VMA may have distinct private
state and may be tracked/managed by the driver, and indeed I see that
vma->vm_private_data is used.

Also SGX utilises custom VMA handling operations for fault handling and
obviously does its own thing.

Because of this, there's just no way mm can know whether it's ok to merge
or not. Some of the attributes become in effect 'hidden'. You could map
anything in these ranges and track that with any kind of state.

So it's absolutely correct that we do not merge in these cases, as things
currently stand.

> > >
> > > I thought to plain check this as it has been two years since my last
> > > query on topic (if we could improve either the driver or mm somehow).
> >
> > In the past I've substituted kernel's mm merge code with user space
> > replacement:
> >
> > https://github.com/enarx/mmledger/blob/main/src/lib.rs
> >
> > It's essentially a reimplementation of al stuff that goes into
> > mm/mmap.c's vma_merge(). I cannot recall anymore whether merges
> > which map over existing ranges were working correctly, i.e. was
> > the issue only concerning adjacent VMA's.

mm/vma.c's vma_merge_existing_range() and vma_merge_new_range() now :) I
have completely rewritten this code from 6.12 onwards.

> >
> > What I'm looking here is that can we make some cosntraints that
> > if satisfied by the pfnmap code, it could leverage the code from
> > vma_merge(). Perhaps by making explicit call to vma_merge()?
> > I get that implicit use moves too much responsibility to the mm
> > subsystem.

Merging/splitting behaviour is an implementation detail and absolutely
cannot be exposed like this (and would be dangerous to do so).

However, I think the only sensible way we could proceed with something like
this is to add a new vma operation explicitly for pfnmap mappings which are
_otherwise mergeable_ like:

	vm_ops->may_merge_pfnmap(struct vm_area_struct *,
				 struct vm_area_struct *)

Which the driver could implement to check internal state matches between
the two VMAs.

It's nicely opt-in as we'd not merge if this were not set, and it defers
the decision as to 'hidden attributes' to the driver. Also we could ensure
all other merge characteristics were satisfied first to avoid any invalid
merging between VMAs - in fact this function would only be called if:

1. Both VMAs are VM_PFNMAP.
2. Both VMAs are otherwise compatible.
3. Both VMAs implement vm_ops->may_merge_pfnmap() (should be implied by 2,
   as vm_ops equality implies file equality).
4. vm_ops->may_merge_pfnmap(vma1, vma2) returns true.

At which point we could merge. Note that the existence of .close() could
cause issues here, though the existing merging rules should handle this
correctly.

I _suspect_ from a brief reading of the SGX stuff you only really need the
enclave value to be the same?

So it could be something like:

	static bool sgx_may_merge_pfnmap(struct vma_area_struct *vma1,
					 struct vma_area_struct *vma2)
	{
		/* Merge if enclaves match. */
		return vma1->vm_private_data == vma2->vm_private_data;
	}

Since you seem to be doing mappings explicitly based on virtual addresses
in these ranges?

I could look into RFC'ing something for you guys to test when I get a
chance?

> >
>
> Hi Jarkko,
>
> Just want to understand more on the background:
>
> Are you seeing any real problem due to needing a lot of mmap()s to the same
> enclave, or it is just a problem that doesn't look nice and you want to
> resolve?
>
> I mean, this problem doesn't seem to be SGX-specific but a common one for
> VMAs with VM_PFNMAP (any bit in VM_SPECIAL), e.g., from random device
> drivers with mmap() support.  We will need a good justification if we want
> to make any core-mm change, if any, for this.

I'm guessing the problem is a concern that a map limit will be hit or VMA
memory usage will be a problem? If not it may simply seem ugly...
